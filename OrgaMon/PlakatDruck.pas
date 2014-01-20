(*
      ___                  __  __
     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
    | |_| | | | (_| | (_| | |  | | (_) | | | |
     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
               |___/

    Copyright (C) 2007  Andreas Filsinger

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    http://orgamon.org/

*)
unit PlakatDruck;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, ExtDlgs,
  StdCtrls, ExtCtrls, printers;

const
  Version: single = 1.001; // \rev\Plakat.rev

type
  TFormPlakatDruck = class(TForm)
    OpenPictureDialog1: TOpenPictureDialog;
    Laden: TButton;
    drucken: TButton;
    Label1: TLabel;
    Breite: TEdit;
    Label2: TLabel;
    quit: TButton;
    Image2: TImage;
    Label3: TLabel;
    ab: TEdit;
    Label4: TLabel;
    PrintDialog1: TPrintDialog;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Image1: TImage;


    procedure LadenClick(Sender: TObject);
    procedure druckenClick(Sender: TObject);
    procedure quitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BreiteChange(Sender: TObject);

  private
   { Private-Deklarationen }
  public
    loaded: boolean;
    breit: integer;
    hoch: double;
    function MkRect(x, y, xl, yl: integer): TRect;
   { Public-Deklarationen }
  end;

var
  FormPlakatDruck: TFormPlakatDruck;


implementation

{$R *.DFM}

function TFormPlakatDruck.MkRect(x, y, xl, yl: integer): TRect;
var
  r: TRect;
begin
  r.topleft.x := x;
  r.topleft.y := y;
  r.bottomright.x := x + xl;
  r.bottomright.y := y + yl;
  result := r;
end;

procedure TFormPlakatDruck.LadenClick(Sender: TObject);
begin
  if openpicturedialog1.execute then
  begin
    image2.picture.LoadFromFile(openpicturedialog1.filename);
    if image2.picture.Height > image2.picture.width then
      image1.width := trunc((image1.height * image2.picture.width) / image2.picture.Height) + 1
    else
      image1.height := trunc((image2.picture.height * image1.width) / image2.picture.width) + 1;
    image1.Canvas.StretchDraw(mkrect(0, 0, image1.width, image1.height), image2.picture.graphic);
    loaded := true;
  end;
end;

procedure TFormPlakatDruck.druckenClick(Sender: TObject);

const
  TotalX: double = 21.0;
  TotalY: double = 29.7;

  UseXcm: double = 19.5;
  UseYcm: double = 26.5;

var err, abs: integer;
  xPixel, ypixel, x, y: integer;
  xpages, ypages: integer;
  pageheight, pagewidth: integer;
  pixelheight, pixelwidth: integer;
  copyheight, copywidth: integer;
  abx, aby: integer;
  i, j: integer;
  s: string;
  exitFlag, rep: boolean;
  rect: trect;

  SeitNo: integer;
  AllPages: word;
  XCopyStart, YCopyStart: integer; // Startpunkt für das Viereck
                                        // aus dem Quell-BMP.
  DrawPixelCount: integer;
  OnePixelSize: double;
  PageName: string;
  AusgabeXL, AusgabeYL: integer;
  FullXL, FullYL: integer;
  SteineProBlatt: integer;
  SteinX, SteinY: integer;
  LeftBorder: integer;
  TopBorder: integer;

  procedure Cross(x, y: integer);
  const
    LengthX = 20;
    LengthY = 20;
    ThicknessX = 2;
    ThicknessY = 2;
  begin

      // von links nach rechts
    printer.canvas.FillRect(MkRect(x - (LengthX div 2), y - (ThicknessY div 2), LengthX, ThicknessY));
      // von oben nach unten
    printer.canvas.FillRect(MkRect(x - (ThicknessX div 2), y - (LengthY div 2), ThicknessX, LengthY));

  end;


  procedure CursorXOR;
  begin
    image1.Canvas.drawfocusRect(mkrect(x * (image1.width div xpages), y * (image1.height div ypages), (image1.width div xpages), (image1.height div ypages)));
  end;


begin
  if not (loaded) then
    exit;
  exitFlag := false;
  val(ab.text, abs, err);
  val(breite.text, breit, err);

 // Höhe der Graphic berechnen
  xpages := trunc(breit / UseXcm) + 1;
  OnePixelSize := breit / image2.picture.bitmap.width;
  hoch := OnePixelSize * image2.picture.bitmap.height;
  str(hoch: 5: 2, s);
  label7.caption := s;

 // Anzahl der Seiten berechnen
  ypages := trunc((OnePixelSize * image2.picture.bitmap.height) / UseYcm) + 1;
  AllPages := xPages * YPages;
  str(AllPages: 4, s);
  label5.caption := s;

 // Berechne Größe des Druckausgabe-Bereiches in Pixel!!!
  AusgabeXL := trunc((UseXcm * printer.pagewidth) / TotalX);
  FullXL := AusgabeXL * xpages;
  LeftBorder := (printer.pagewidth - AusgabeXL) div 2;

  AusgabeYL := trunc((UseYcm * printer.pageheight) / TotalY);
  FullYL := AusgabeYL * ypages;
  TopBorder := (printer.pageheight - AusgabeYL) div 2;

 // Berechne Größe eines Ausgabe Mosaik-Steins in Pixel
  SteinX := trunc(FullXL / image2.picture.bitmap.width) + 1;
  SteinY := SteinX;

 // Ausgabebereich auf dem Drucker vergrößern, so daß "Stein" Teiler
 // von "Ausgabe" ist
  inc(AusgabeXL, AusgabeXL mod SteinX);
  inc(AusgabeYL, AusgabeYL mod SteinY);

 // wiegroß ist eine Quell-Seite in Pixel
  copywidth := AusgabeXL div SteinX;
  copyheight := AusgabeYL div SteinY;

// xpages := (image2.picture.bitmap.width DIV copywidth)+ 1;
// ypages := (image2.picture.bitmap.height DIV copyheight) + 1;
// AllPages := xPages * YPages;
  str(AllPages: 4, s);
  label5.caption := s;

  if printdialog1.execute then
  begin


    printer.Canvas.Brush.Style := bssolid;

    for SeitNo := abs to AllPages do
    begin

      x := pred(seitno) mod xPages;
      y := pred(seitno) div xPages;

      str(x + 1, s);
      PageName := chr(ord('A') + y) + s;

//  Rahmen um gerade Druckenden Ausschnitt zeichnen
      CursorXOR;
(*
    case messagedlg('Seite '+PageName+' drucken?',mtconfirmation,[mbok,mbcancel,mbignore,mbAll],0) of
      mrok:begin
*)
      XCopyStart := x * copywidth;
      YCopyStart := y * copyheight;

      printer.title := 'Kachel ' + PageName;
      printer.BeginDoc;
      DrawPixelCount := 0;

      // Einzelne Pixel kopieren!
      for j := 0 to pred(copywidth) do
        for i := 0 to pred(copyheight) do
        begin
   //       if DrawPixelCount>2000 then
   //        break;
   //       inc(DrawPixelCount);

          // Liegt Quell-Pixel noch im Bildbereich?
          if (xcopystart + j < image2.picture.bitmap.width) and
            (ycopystart + i < image2.picture.bitmap.height) then
          begin

           // Farbe des Quell-Pixel ermitteln
            printer.Canvas.Brush.Color := image2.Canvas.Pixels[xcopystart + j, ycopystart + i];

           // Ausgabe Ziel-Kachel berechnen
            rect.Left := LeftBorder + j * SteinX;
            rect.Top := TopBorder + i * SteinY;
            rect.Right := rect.Left + SteinX;
            rect.Bottom := rect.Top + SteinY;
            printer.Canvas.FillRect(rect);
          end;
        end;

      printer.Canvas.Brush.Color := clblack;
      Cross(LeftBorder - 2, TopBorder - 2);
      Cross((printer.pagewidth - LeftBorder) + 2, TopBorder - 2);
      Cross(LeftBorder - 2, (printer.pageheight - TopBorder) + 2);
      Cross((printer.pagewidth - LeftBorder) + 2, (printer.pageheight - TopBorder) + 2);

      printer.Canvas.Brush.Color := clwhite;
      printer.canvas.TextOut(LeftBorder, printer.PageHeight - (TopBorder div 2), PageName);
      printer.EndDoc;
(*
     end;
     mrIgnore:;
    else
     CursorXOR;
     break;
    end;
*)
      CursorXOR;
    end;
  end;
end;

procedure TFormPlakatDruck.quitClick(Sender: TObject);
begin
  close;
end;

procedure TFormPlakatDruck.FormCreate(Sender: TObject);
var err: integer;
begin
  loaded := false;
  val(breite.text, breit, err);
end;


procedure TFormPlakatDruck.BreiteChange(Sender: TObject);
var err: integer;
begin
  val(breite.text, breit, err);
end;

end.

