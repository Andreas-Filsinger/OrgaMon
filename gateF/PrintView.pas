unit PrintView;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  ExtCtrls, printers;

const
  TableRows = 6;
  TableColumns = 4;

type
  TPrintViewForm = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    alles: TButton;
    Label1: TLabel;
    CheckBoxDruck: TCheckBox;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    CheckBoxRahmen: TCheckBox;
    CheckBoxLogos: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure allesClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    PosX: integer;
    PosY: integer;
    OverAllX: integer;
    OverAllY: integer;

    // Formular-Daten
    drvName: string;
    drvFirma: string;
    drvTabelle: array [0 .. pred(TableColumns), 0 .. pred(TableRows)] of string;
    drvGueltig: string;
    drvPforteInfo: string;
    drvUnterschrift: TBitMap;
    drvKennzeichen: string;
    drvID: string;
    drvAnrede: string;
    drvParken: boolean;
    drvHandy: string;
    drvMitgebracht: string;
    drvLanguage: string;
    drvBarCode: string;

    Lang_Contract: TStringList;
    Lang_Unterschrift: string;
    Lang_valid: string;
    Lang_Herr: string;
    Lang_Frau: string;
    Lang_Entry: string;
    Lang_Parken: array [0 .. 1] of string;
    Lang_Back: array [0 .. 1] of string;

    procedure ClearData;
    procedure DummyData;

    procedure PaintAusweisskarte(DrawCanvas: TCanvas; FormFactor: extended);
    procedure PaintBesucherZettel(DrawCanvas: TCanvas; FormFactor: extended;
      links: boolean);
    procedure PaintFahrzeugKarte(DrawCanvas: TCanvas; FormFactor: extended;
      DrawRect: TRect);
    procedure WarmUp;
    procedure LoadLanguagePack;

  end;

var
  PrintViewForm: TPrintViewForm;

implementation

uses
  globals, math, anfix32;

{$R *.DFM}
// TOOLS

procedure Border(DrawCanvas: TCanvas; r: TRect;
  LineThicknessX, LineThicknessY: integer);
begin
  dec(LineThicknessX);
  dec(LineThicknessY);
  with DrawCanvas do
  begin
    FilLRect(SizeCorrect(Rect(r.left, r.top, r.left + LineThicknessX,
      r.Bottom + LineThicknessY)));
    FilLRect(SizeCorrect(Rect(r.left, r.Bottom, r.right + LineThicknessX,
      r.Bottom + LineThicknessY)));
    FilLRect(SizeCorrect(Rect(r.right, r.top, r.right + LineThicknessX,
      r.Bottom + LineThicknessY)));
    FilLRect(SizeCorrect(Rect(r.left, r.top, r.right + LineThicknessX,
      r.top + LineThicknessY)));
  end;
end;

procedure TextOutV(DrawCanvas: TCanvas; x, y: integer; const s: string);
var
  LogFont: TLogFont;
  OldF, NewF: hFont;
begin
  with DrawCanvas do
  begin
    GetObject(Font.Handle, SizeOf(TLogFont), @LogFont);
    LogFont.lfEscapement := 900;
    LogFont.lfOrientation := 900;
    NewF := CreateFontIndirect(LogFont);
    OldF := Font.Handle;
    Font.Handle := NewF;
    TextOut(x, y, s);
    Font.Handle := OldF;
    DeleteObject(NewF);
  end;
end;

procedure DrawImage(Canvas: TCanvas; DestRect: TRect; ABitmap: TBitMap);
var
  Header, Bits: Pointer;
  HeaderSize, BitsSize: dword;
begin
  GetDIBSizes(ABitmap.Handle, HeaderSize, BitsSize);
  GetMem(Header, HeaderSize);
  GetMem(Bits, BitsSize);
  try
    GetDIB(ABitmap.Handle, ABitmap.Palette, Header^, Bits^);
    StretchDIBits(Canvas.Handle, DestRect.left, DestRect.top,
      DestRect.right - DestRect.left, DestRect.Bottom - DestRect.top, 0, 0,
      ABitmap.Width, ABitmap.Height, Bits, TBitmapInfo(Header^),
      DIB_RGB_COLORS, SRCCOPY);
  finally
    FreeMem(Header, HeaderSize);
    FreeMem(Bits, BitsSize);
  end;
end;

//
// imp:TPrintViewForm
//

procedure TPrintViewForm.PaintAusweisskarte(DrawCanvas: TCanvas;
  FormFactor: extended);
const
  BreiteX = 330;
  BreiteY = 210;
var
  LineThicknessX: integer;
  LineThicknessY: integer;
  MaxNameFontSize: integer;
  MitarbeiterMode: boolean;
  _drvFirma: string;
  k: integer;

  function StretchX(x: integer): integer;
  var
    ToCalc: extended;
  begin
    ToCalc := x;
    ToCalc := FormFactor * ToCalc;
    result := trunc(ToCalc);
  end;

  function StretchY(y: integer): integer;
  var
    ToCalc: extended;
  begin
    ToCalc := y;
    ToCalc := FormFactor * ToCalc;
    result := trunc(ToCalc);
  end;

begin
  MitarbeiterMode := (pos(cMitarbeiter, drvFirma) = 1);

  with DrawCanvas do // TCanvas
  begin
    OverAllX := StretchX(BreiteX + 2);
    OverAllY := StretchY(BreiteY);
    LineThicknessX := max(StretchX(1), 1);
    LineThicknessY := max(StretchY(1), 1);

    if CheckBoxRahmen.checked then
    begin
      brush.color := clblack;
      Border(DrawCanvas, Rect(PosX + StretchX(0), PosY + StretchY(0),
        PosX + StretchX(BreiteX), PosY + StretchY(BreiteY)), LineThicknessX,
        LineThicknessY);
      brush.color := clwhite;
    end;

    if CheckBoxLogos.checked then
    begin
      brush.color := clblack;
      FrameRect(Rect(PosX + StretchX(10), PosY + StretchY(6),
        PosX + StretchX(90), PosY + StretchY(23)));
      brush.color := clwhite;
    end;

    // Font.Name := 'Verdana';
    Font.Name := 'Arial';
    Font.Style := [fsunderline];
    Font.Height := StretchY(-13);
    TextOut(PosX + StretchX(22), PosY + StretchY(51), drvAnrede);

    Font.Name := 'Arial Black';
    Font.Style := [];
    MaxNameFontSize := StretchY(-25);
    while true do
    begin
      Font.Height := MaxNameFontSize;
      if ((PosX + StretchX(20) + TextWidth(drvName)) < PosX +
        StretchX(290)) then
        break;
      inc(MaxNameFontSize);
    end;

    TextOut(PosX + StretchX(20), PosY + StretchY(65), drvName);

    Font.Name := 'Arial';
    Font.Height := StretchY(-20);
    Font.Style := [];
    if MitarbeiterMode then
    begin
      _drvFirma := drvFirma;
      k := pos(' ', _drvFirma);
      if (k > 0) then
        _drvFirma := copy(_drvFirma, succ(k), MaxInt);
      TextOut(PosX + StretchX(20), PosY + StretchY(120), _drvFirma);
    end
    else
      TextOut(PosX + StretchX(20), PosY + StretchY(120), drvFirma);

    Font.Height := StretchY(-13);
    TextOut(PosX + StretchX(10), PosY + StretchY(155), drvGueltig);
    TextOut(PosX + StretchX(10), PosY + StretchY(170), drvBarCode);

    (*
      with asbarcode1 do
      begin
      Text := drvBarCode;
      top := PosY + StretchY(150);
      left := PosX + StretchX(10) + TextWidth(drvGueltig) + StretchX(7);
      height := StretchY(39);
      width := StretchX(125);
      DrawBarCode(DrawCanvas);
      end;
    *)
    Font.Height := StretchY(-17);
    Font.Style := [fsunderline];
    if MitarbeiterMode then
      TextOut(PosX + StretchX(152), PosY + StretchY(16), 'MA-Tagesausweis')
    else
      TextOut(PosX + StretchX(190), PosY + StretchY(16), 'Besucher');

  end;
end;

procedure TPrintViewForm.PaintBesucherZettel(DrawCanvas: TCanvas;
  FormFactor: extended; links: boolean);
const
  BreiteX = 430;
  BreiteY = 810;
var
  LineThicknessX: integer;
  LineThicknessY: integer;
  CheckFormatStr: string;
  OutString: string;
  TextY, n, k: integer;
  Row: array [1 .. TableColumns] of integer;
  Cell: array [1 .. TableRows] of integer;
  CellPos: array [1 .. TableColumns, 1 .. TableRows] of TPoint;
  TableYStart: integer;
  TableYEnd: integer;
  _TextY: integer;
  r, c: integer;
  RowStart: integer;
  ColumnStart: integer;
  TextXStart: integer;
  TextYStart: integer;
  UnterschriftRect: TRect;
  RealXOut: extended;
  RealYOut: extended;
  PUx: integer;
  PUy: integer;
  ax, by, cy: extended;
  TelefonX: integer;
  MaxNameFontSize: integer;
  FreierTextSize: integer;

  function StretchX(x: integer): integer;
  var
    ToCalc: extended;
  begin
    ToCalc := x;
    ToCalc := FormFactor * ToCalc;
    result := trunc(ToCalc);
  end;

  function StretchY(y: integer): integer;
  var
    ToCalc: extended;
  begin
    ToCalc := y;
    ToCalc := FormFactor * ToCalc;
    result := trunc(ToCalc);
  end;

  procedure Thickline(r: TRect);
  begin
    with DrawCanvas do
    begin
      FilLRect(Rect(r.left, r.top, r.right, r.Bottom + LineThicknessY));
    end;
  end;

  function CutFirstLine(s: string): string;
  var
    k: integer;
  begin
    k := pos('(', s);
    if (k > 0) then
    begin
      result := copy(s, 1, pred(k));
    end
    else
    begin
      result := s;
    end;
  end;

  function CutSecondLine(s: string): string;
  var
    k: integer;
  begin
    k := pos('(', s);
    if (k > 0) then
    begin
      result := copy(s, succ(k), pred(length(s)) - k);
    end
    else
    begin
      result := '';
    end;
  end;

begin

  with DrawCanvas do // TCanvas
  begin

    OverAllX := StretchX(BreiteX + 2);
    OverAllY := StretchY(BreiteY);

    LineThicknessX := max(StretchX(1), 1);
    LineThicknessY := max(StretchY(1), 1);

    if CheckBoxRahmen.checked then
    begin
      brush.color := clblack;
      Border(DrawCanvas, Rect(PosX + StretchX(0), PosY + StretchY(0),
        PosX + StretchX(BreiteX), PosY + StretchY(BreiteY)), LineThicknessX,
        LineThicknessY);
      brush.color := clwhite;
    end;

    if CheckBoxLogos.checked then
    begin
      brush.color := clblack;
      FrameRect(Rect(PosX + StretchX(10), PosY + StretchY(6),
        PosX + StretchX(90), PosY + StretchY(23)));
      brush.color := clwhite;
    end;

    Font.Name := 'Arial';
    Font.Style := [];
    Font.Height := StretchY(-8);
    if links then
    begin
      TextOut(PosX + StretchX(230), PosY + StretchY(6),
        'Dieses Exemplar ist von allen');
      TextOut(PosX + StretchX(230), PosY + StretchY(16),
        'Besuchten zu unterzeichnen und');
      TextOut(PosX + StretchX(230), PosY + StretchY(26),
        'bei Besuchsende am Empfang');
      TextOut(PosX + StretchX(230), PosY + StretchY(36), 'zurückzugeben');
    end
    else
      TextOut(PosX + StretchX(230), PosY + StretchY(6), Lang_Back[0]);

    Font.Height := StretchY(-17);
    Font.Style := [fsunderline];
    if links then
      TextOut(PosX + StretchX(140), PosY + StretchY(16), 'Laufkarte')
    else
      TextOut(PosX + StretchX(230), PosY + StretchY(16), Lang_Back[1]);

    Font.Height := StretchY(-13);
    TextOut(PosX + StretchX(22), PosY + StretchY(37), drvAnrede);

    TextY := StretchY(52);

    // Name ...
    Font.Name := 'Arial Black';
    Font.Style := [];

    MaxNameFontSize := StretchY(-25);
    while true do
    begin
      Font.Height := MaxNameFontSize;
      if ((PosX + StretchX(20) + TextWidth(drvName)) < PosX +
        StretchX(360)) then
        break;
      inc(MaxNameFontSize);
    end;

    TextOut(PosX + StretchX(20), PosY + TextY, drvName);
    inc(TextY, TextHeight('X') + StretchY(2));

    // Firma ...
    Font.Name := 'Arial';
    Font.Height := StretchY(-17);
    Font.Style := [];
    TextOut(PosX + StretchX(20), PosY + TextY, drvFirma);
    inc(TextY, TextHeight('X') + StretchY(2));

    if (drvHandy <> '') then
    begin
      TelefonX := (PosX + StretchX(400)) - TextWidth(drvHandy);
      TextOut(TelefonX, PosY + TextY, ' ' + drvHandy);
      Font.Name := 'Wingdings';
      TextOut(TelefonX - TextWidth(')'), PosY + TextY, ')');
    end;

    // gültig bis ...
    Font.Name := 'Arial';
    Font.Height := StretchY(-14);
    Font.Style := [];
    TextOut(PosX + StretchX(20), PosY + TextY, drvGueltig);
    inc(TextY, TextHeight('X') + StretchY(10));

    // Text eintragen
    TableYStart := TextY;
    inc(TextY, StretchY(10));

    Font.Style := [];
    FreierTextSize := 12;
    Font.Height := StretchY(-FreierTextSize);

    if Font.Size < 10 then
      Font.Name := 'Small Fonts'
    else
      Font.Name := 'Arial';

    for n := 0 to pred(Lang_Contract.count) do
    begin
      CheckFormatStr := Lang_Contract[n];
      while true do
      begin
        if (length(CheckFormatStr) = 0) then
          break;
        if CheckFormatStr[1] = '\' then
        begin
          case CheckFormatStr[2] of
            '!':
              ;
            'F':
              Font.Style := Font.Style + [fsbold];
            'f':
              Font.Style := Font.Style - [fsbold];
            'U':
              Font.Style := Font.Style + [fsunderline];
            'u':
              Font.Style := Font.Style - [fsunderline];
            'K':
              Font.Style := Font.Style + [fsItalic];
            'k':
              Font.Style := Font.Style - [fsItalic];
            '+':
              begin
                inc(FreierTextSize);
                Font.Height := StretchY(-FreierTextSize);
              end;
            '-':
              begin
                dec(FreierTextSize);
                Font.Height := StretchY(-FreierTextSize);
              end;
          else
            ShowMessage('Besucher Hinweise ??.txt(' + inttostr(succ(n)) +
              ') falsche Formatangabe: \' + CheckFormatStr[2]);
          end;
          delete(CheckFormatStr, 1, 2);
        end;
        k := pos('\', CheckFormatStr);
        if (k > 0) then
        begin
          OutString := copy(CheckFormatStr, 1, pred(k));
          if OutString <> '' then
          begin
            TextOut(PosX + StretchX(18), PosY + TextY, OutString);
            inc(TextY, TextHeight('X') + (TextHeight('X') div 7));
          end;
          delete(CheckFormatStr, 1, pred(k));
        end
        else
        begin
          TextOut(PosX + StretchX(18), PosY + TextY, CheckFormatStr);
          inc(TextY, TextHeight('X') + (TextHeight('X') div 7));
          break;
        end;
      end;

    end;

    // wieder auf den normalen Font schalten
    Font.Height := StretchY(-12);

    // wieder ein bischen zurück
    dec(TextY, TextHeight('X')*2);

    if (drvUnterschrift.Height > 0) and (drvUnterschrift.Width > 0) then
    begin
      RealYOut := TextHeight('X') * 3;

      // Ausgabe-Höhe berechnen
      ax := drvUnterschrift.Width; // Bild-Breite
      by := drvUnterschrift.Height; // Bild-Höhe
      cy := RealYOut; // Ausgabe-Höhe
      RealXOut := round((cy * ax) / by);

      PUx := PosX + StretchX(150);
      PUy := TextY;

      UnterschriftRect := Rect(PUx, PUy, PUx + round(RealXOut),
        PUy + round(RealYOut));
      DrawImage(DrawCanvas, UnterschriftRect, drvUnterschrift);
    end;

    // eine Freizeile
    inc(TextY, TextHeight('X')*2);

    // Linie für Unterschrift
    LineThicknessX := max(StretchX(1), 1);
    LineThicknessY := max(StretchY(1), 1);
    brush.color := clblack;
    Thickline(Rect(PosX + StretchX(170), PosY + TextY, PosX + StretchX(380),
      PosY + TextY));
    brush.color := clwhite;

    // nochmal etwas Platz
    inc(TextY, StretchY(3));

    //
    Font.Name := 'Arial';
    Font.Style := [];
    Font.Height := StretchY(-8);
    TextOut(PosX + StretchX(170), PosY + TextY, Lang_Unterschrift);
    inc(TextY, TextHeight('X'));

    // nochmal etwas Platz
    inc(TextY, StretchY(3));

    // große Box um den Besucher Text
    LineThicknessX := max(StretchX(2), 2);
    LineThicknessY := max(StretchY(2), 2);
    brush.color := clblack;
    Border(DrawCanvas, Rect(PosX + StretchX(10), PosY + TableYStart,
      PosX + StretchX(BreiteX - 30), PosY + TextY), LineThicknessX,
      LineThicknessY);
    brush.color := clwhite;

    inc(TextY, TextHeight('X'));

    TableYStart := TextY;
    // PosY := PosY + ( TextY -

    // Tabelle 4 x 5
    LineThicknessX := max(StretchX(1), 1);
    LineThicknessY := max(StretchY(1), 1);

    Row[1] := StretchX(180);
    for r := 2 to TableColumns do
      Row[r] := StretchX(70);

    Cell[1] := StretchY(36);
    for c := 2 to TableRows do
      Cell[c] := StretchY(30);

    brush.color := clblack;
    RowStart := StretchX(10);
    for r := 1 to TableColumns do
    begin
      ColumnStart := TableYStart;
      for c := 1 to TableRows do
      begin
        CellPos[r, c] := point(PosX + RowStart, PosY + ColumnStart);
        Border(DrawCanvas, Rect(PosX + RowStart, PosY + ColumnStart,
          PosX + RowStart + Row[r], PosY + ColumnStart + Cell[c]),
          LineThicknessX, LineThicknessY);
        inc(ColumnStart, Cell[c]);
      end;
      inc(RowStart, Row[r]);
    end;

    TableYEnd := ColumnStart;
    brush.color := clwhite;
    TextXStart := StretchX(14);
    TextYStart := TableYStart + StretchY(2);

    // Daten-Texte
    Font.Name := 'Arial';
    Font.Style := [];
    Font.Height := StretchY(-10);
    for r := 1 to TableColumns do
      for c := 2 to TableRows do
      begin
        _TextY := CellPos[r, c].y + StretchY(3);
        TextOut(CellPos[r, c].x + StretchX(3), _TextY,
          CutFirstLine(drvTabelle[pred(r), pred(c)]));
        inc(_TextY, TextHeight('X') + (TextHeight('X') div 7));
        TextOut(CellPos[r, c].x + StretchX(3), _TextY,
          CutSecondLine(drvTabelle[pred(r), pred(c)]));
      end;

    // Titel Texte
    Font.Name := 'Arial';
    Font.Style := [];
    Font.Height := StretchY(-12);
    TextY := TextHeight('X');

    TextOut(PosX + TextXStart, PosY + TextYStart, 'Besuchter Mitarbeiter');
    TextOut(PosX + TextXStart, PosY + TextYStart + TextY, 'Ort/Tel');

    TextOut(PosX + TextXStart + Row[1], PosY + TextYStart, 'Besuchs-');
    TextOut(PosX + TextXStart + Row[1], PosY + TextYStart + TextY, 'beginn');

    TextOut(PosX + TextXStart + Row[1] + Row[2], PosY + TextYStart, 'Besuchs-');
    TextOut(PosX + TextXStart + Row[1] + Row[2],
      PosY + TextYStart + TextY, 'ende');

    if links then
    begin
      TextOut(PosX + TextXStart + Row[1] + Row[2] + Row[3], PosY + TextYStart,
        'Unterschrift');
      TextOut(PosX + TextXStart + Row[1] + Row[2] + Row[3],
        PosY + TextYStart + TextY, 'Mitarbeiter');
    end;

    TextY := TableYEnd + TextY;

    // den Ort, an den man zurücklaufen muss
{
    TextOut(PosX + StretchX(20), PosY + TextY,
      Lang_Entry + ' ' + drvPforteInfo);
}

    inc(TextY, TextHeight('X'));
    if (drvMitgebracht <> '') then
    begin
      TextOut(PosX + StretchX(20), PosY + TextY, 'eingebrachte Waren / Gegenstände / Unterlagen : ' +
        drvMitgebracht);
    end;

    Font.Height := StretchY(-10);
    TextOut(PosX + StretchX(15), PosY + StretchY(BreiteY - 30), drvID);
    TextOut(PosX + StretchX(15), PosY + StretchY(BreiteY - 40),
      'BESUCHER-' + drvBarCode);

    (*
      with asbarcode1 do
      begin
      Text := drvBarCode;
      top := PosY + StretchY(BreiteY - 52 - 39);
      left := PosX + StretchX(15);
      height := StretchY(39);
      width := StretchX(125);
      DrawBarCode(DrawCanvas);
      end;
    *)

    Font.Height := StretchY(-6);
    TextOutV(DrawCanvas, PosX + StretchX(2), PosY + StretchY(BreiteY - 10),
      'gateF Rev ' + RevToStr(Version) +' ©''2011 Open-Source by OrgaMon.de');
  end;
end;

procedure TPrintViewForm.PaintFahrzeugKarte(DrawCanvas: TCanvas;
  FormFactor: extended; DrawRect: TRect);
const
  BreiteX = 330;
  BreiteY = 600;
var
  LineThicknessX: integer;
  LineThicknessY: integer;
  TextY, n, k: integer;
  r, c: integer;
  RowStart: integer;
  ColumnStart: integer;
  TextXStart: integer;
  TextYStart: integer;
  Row: array [1 .. TableColumns] of integer;
  Cell: array [1 .. TableRows] of integer;
  CellPos: array [1 .. TableColumns, 1 .. TableRows] of TPoint;
  TableYStart: integer;
  TableYEnd: integer;
  _TextY: integer;

  function StretchX(x: integer): integer;
  var
    ToCalc: extended;
  begin
    ToCalc := x;
    ToCalc := FormFactor * ToCalc;
    result := trunc(ToCalc);
  end;

  function StretchY(y: integer): integer;
  var
    ToCalc: extended;
  begin
    ToCalc := y;
    ToCalc := FormFactor * ToCalc;
    result := trunc(ToCalc);
  end;

  procedure Thickline(r: TRect);
  begin
    with DrawCanvas do
    begin
      FilLRect(Rect(r.left, r.top, r.right, r.Bottom + LineThicknessY));
    end;
  end;

  function CutFirstLine(s: string): string;
  var
    k: integer;
  begin
    k := pos('(', s);
    if (k > 0) then
    begin
      result := copy(s, 1, pred(k));
    end
    else
    begin
      result := s;
    end;
  end;

  function CutSecondLine(s: string): string;
  var
    k: integer;
  begin
    k := pos('(', s);
    if (k > 0) then
    begin
      result := copy(s, succ(k), pred(length(s)) - k);
    end
    else
    begin
      result := '';
    end;
  end;

begin

  with DrawCanvas do // TCanvas
  begin
    OverAllX := StretchX(BreiteX + 2);
    OverAllY := StretchY(BreiteY);
    LineThicknessX := max(StretchX(1), 1);
    LineThicknessY := max(StretchY(1), 1);

    if CheckBoxRahmen.checked then
    begin
      brush.color := clblack;
      Border(DrawCanvas, Rect(PosX + StretchX(0), PosY + StretchY(0),
        PosX + StretchX(BreiteX), PosY + StretchY(BreiteY)), LineThicknessX,
        LineThicknessY);
      brush.color := clwhite;
    end;

    if CheckBoxLogos.checked then
    begin
      brush.color := clblack;
      FrameRect(Rect(PosX + StretchX(10), PosY + StretchY(6),
        PosX + StretchX(90), PosY + StretchY(23)));
      brush.color := clwhite;
    end;

    Font.Name := 'Arial';
    Font.Style := [];
    Font.Height := StretchY(-27);
    TextOut(PosX + StretchX(130), PosY + StretchY(6),
      Lang_Parken[0] { 'Parkschein' } );
    Font.Height := StretchY(-8);
    Font.Style := [fsunderline];
    TextOut(PosX + StretchX(130), PosY + StretchY(36),
      Lang_Parken[1] { 'gut sichtbar im Fahrzeug belassen' } );

    // Font.Name := 'Verdana';
    TextY := StretchY(55);
    Font.Name := 'Arial Black';
    Font.Height := StretchY(-30);
    Font.Style := [];
    TextOut(PosX + StretchX(20), PosY + TextY, drvKennzeichen);
    inc(TextY, TextHeight('X') + (TextHeight('X') div 7));

    Font.Name := 'Arial';
    Font.Style := [];
    Font.Height := StretchY(-17);
    TextOut(PosX + StretchX(20), PosY + TextY, drvName);
    inc(TextY, TextHeight('X') + (TextHeight('X') div 7));

    Font.Name := 'Arial';
    Font.Height := StretchY(-17);
    Font.Style := [];
    TextOut(PosX + StretchX(20), PosY + TextY, drvFirma);
    inc(TextY, TextHeight('X') + TextHeight('X'));

    TableYStart := TextY;
    // PosY := PosY + ( TextY -

    // Tabelle 4 x 5
    LineThicknessX := max(StretchX(1), 1);
    LineThicknessY := max(StretchY(1), 1);

    Row[1] := StretchX(164 + 16);
    for r := 2 to TableColumns - 1 do
      Row[r] := StretchX(57 + 6);

    Cell[1] := StretchY(36);
    for c := 2 to TableRows do
      Cell[c] := StretchY(30);

    brush.color := clblack;
    RowStart := StretchX(10);
    for r := 1 to TableColumns - 1 do
    begin
      ColumnStart := TableYStart;
      for c := 1 to TableRows do
      begin
        CellPos[r, c] := point(PosX + RowStart, PosY + ColumnStart);

        Border(DrawCanvas, Rect(PosX + RowStart, PosY + ColumnStart,
          PosX + RowStart + Row[r], PosY + ColumnStart + Cell[c]),
          LineThicknessX, LineThicknessY);
        inc(ColumnStart, Cell[c]);
      end;
      inc(RowStart, Row[r]);
    end;

    TableYEnd := ColumnStart;

    brush.color := clwhite;
    TextXStart := StretchX(14);
    TextYStart := TableYStart + StretchY(2);

    // Daten-Texte
    Font.Name := 'Arial';
    Font.Style := [];
    Font.Height := StretchY(-10);
    for r := 1 to TableColumns - 1 do
      for c := 2 to TableRows do
      begin
        _TextY := CellPos[r, c].y + StretchY(3);
        TextOut(CellPos[r, c].x + StretchX(3), _TextY,
          CutFirstLine(drvTabelle[pred(r), pred(c)]));
        inc(_TextY, TextHeight('X') + (TextHeight('X') div 7));
        TextOut(CellPos[r, c].x + StretchX(3), _TextY,
          CutSecondLine(drvTabelle[pred(r), pred(c)]));
      end;

    // Titel Texte
    Font.Name := 'Arial';
    Font.Style := [];
    Font.Height := StretchY(-12);
    TextY := TextHeight('X');

    TextOut(PosX + TextXStart, PosY + TextYStart, 'Besuchter Mitarbeiter');
    TextOut(PosX + TextXStart, PosY + TextYStart + TextY, 'Ort/Tel');

    TextOut(PosX + TextXStart + Row[1], PosY + TextYStart, 'Besuchs-');
    TextOut(PosX + TextXStart + Row[1], PosY + TextYStart + TextY, 'beginn');

    TextOut(PosX + TextXStart + Row[1] + Row[2], PosY + TextYStart, 'Besuchs-');
    TextOut(PosX + TextXStart + Row[1] + Row[2],
      PosY + TextYStart + TextY, 'ende');

    TextY := TableYEnd + TextY;
    Font.Name := 'Arial';
    Font.Height := StretchY(-14);
    Font.Style := [];
    TextOut(PosX + StretchX(20), PosY + TextY, drvGueltig);
    inc(TextY, TextHeight('X') + (TextHeight('X') div 7));

    Font.Height := StretchY(-6);
    TextOutV(DrawCanvas, PosX + StretchX(2), PosY + StretchY(BreiteY - 10),
      '©''99 filsinger.de Rev ' + RevToStr(Version));
  end;
end;

procedure TPrintViewForm.Button1Click(Sender: TObject);
begin
  PosX := 2;
  PosY := 2;
  with Image1.Canvas do
  begin
    brush.color := clwhite;
    FilLRect(Rect(0, 0, Width, Height));
  end;
  PaintAusweisskarte(Image1.Canvas, 2.5);
end;

procedure TPrintViewForm.Button2Click(Sender: TObject);
begin
  PosX := 2;
  PosY := 2;
  with Image1.Canvas do
  begin
    brush.color := clwhite;
    FilLRect(Rect(0, 0, Width, Height));
  end;
  PaintBesucherZettel(Image1.Canvas, 1.4, true);
end;

procedure TPrintViewForm.Button3Click(Sender: TObject);
begin
  PosX := 2;
  PosY := 2;
  with Image1.Canvas do
  begin
    brush.color := clwhite;
    FilLRect(Rect(0, 0, Width, Height));
  end;
  PaintFahrzeugKarte(Image1.Canvas, 0.8, Rect(0, 0, 0, 0));
end;

procedure TPrintViewForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = chr(VK_ESCAPE)) then
  begin
    close;
    Key := #0;
  end;
end;

procedure TPrintViewForm.FormActivate(Sender: TObject);
begin
  Button2.SetFocus;
  if printer.printers.count > 0 then
    Label1.caption := printer.printers[printer.printerindex];
end;

procedure TPrintViewForm.allesClick(Sender: TObject);
var
  KFZAusweissRect: TRect;
  MyBMP: TBitMap;
  MyCanvas: TCanvas;
  DoPrint: boolean;
  FaktorBesucher: extended;
  FaktorAuto: extended;
  FaktorKarte: extended;
  XGap: integer;

  function YZeroPos: integer;
  begin
    if DoPrint then
      result := 0 // 400
    else
      result := 0;
  end;

begin
  LoadLanguagePack;
  DoPrint := CheckBoxDruck.checked;
  if DoPrint then
  begin
    MyCanvas := printer.Canvas;
    XGap := 0;
    FaktorBesucher := 5.80;
    FaktorKarte := 5.80;
    FaktorAuto := 5.80;
    printer.Orientation := poLandscape;
    printer.BeginDoc;
  end
  else
  begin
    XGap := 3;
    FaktorBesucher := 0.3;
    FaktorKarte := 0.3;
    FaktorAuto := 0.3;
    MyCanvas := Image1.Canvas;
    with MyCanvas do
    begin
      brush.color := clwhite;
      FilLRect(Rect(0, 0, Width, Height));
    end;
  end;

  // Druck und berechung der Ausweisskarte
  PosX := 0;
  PosY := YZeroPos;
  PaintAusweisskarte(MyCanvas, FaktorKarte);
  if not(pos(cMitarbeiter, drvFirma) = 1) then
  begin
    KFZAusweissRect.top := OverAllY + XGap;
    KFZAusweissRect.left := 0;
    KFZAusweissRect.right := OverAllX;
    PosX := OverAllX + XGap;
    PosY := YZeroPos;
    PaintBesucherZettel(MyCanvas, FaktorBesucher, true);
    PosX := PosX + OverAllX + XGap;
    PosY := YZeroPos;
    PaintBesucherZettel(MyCanvas, FaktorBesucher, false);
    KFZAusweissRect.Bottom := OverAllY;

    PosX := 0;
    PosY := KFZAusweissRect.top;
    if (drvParken) then
      PaintFahrzeugKarte(MyCanvas, FaktorAuto, KFZAusweissRect);

    {
      if not(DoPrint) then
      with MyCanvas do
      begin
      brush.color := cllime;
      FillRect(KFZAusweissRect);
      end;
    }

    PosX := KFZAusweissRect.left;
    PosY := KFZAusweissRect.top;
  end;

  if DoPrint then
    printer.EndDoc;
end;

procedure TPrintViewForm.WarmUp;
begin
  if iDruckerWarmUp then
  begin
    printer.BeginDoc;
    printer.EndDoc;
  end;
end;

procedure TPrintViewForm.Button4Click(Sender: TObject);
begin
  WarmUp;
end;

procedure TPrintViewForm.ClearData;
var
  x, y: integer;
begin
  drvName := '';
  drvFirma := '';
  drvGueltig := '';
  drvPforteInfo := '';
  drvKennzeichen := '';
  drvID := '';
  drvAnrede := '';
  drvHandy := '';
  drvMitgebracht := '';
  drvLanguage := 'DE';
  drvBarCode := '0';
  for x := 0 to high(drvTabelle) do
    for y := 0 to high(drvTabelle[x]) do
    begin
      drvTabelle[x, y] := '';
    end;
  drvUnterschrift.Height := 0;
  drvUnterschrift.Width := 0;
end;

procedure TPrintViewForm.DummyData;
var
  x, y: integer;
begin
  drvName := '<Name>';
  drvFirma := '<Firma>';
  drvGueltig := '<gültig bis 00.00.00>';
  drvPforteInfo := '<pforte>';
  drvKennzeichen := '<Kennzeichen>';
  drvID := '<ID-000000-kurz>';
  drvAnrede := '<Anrede>';
  drvHandy := '<Handy>';
  drvMitgebracht := '<Mitgebracht>';
  drvLanguage := 'DE';
  drvBarCode := '1003000059';
  for x := 0 to high(drvTabelle) do
    for y := 0 to high(drvTabelle[x]) do
    begin
      drvTabelle[x, y] := '<' + inttostr(x) + ',' + inttostr(y) + '> (2.Zeile)';
    end;
  drvUnterschrift.Height := 0;
  drvUnterschrift.Width := 0;
end;

procedure TPrintViewForm.Button5Click(Sender: TObject);
begin
  DummyData;
end;

procedure TPrintViewForm.Button6Click(Sender: TObject);
begin
  ClearData;
end;

procedure TPrintViewForm.FormCreate(Sender: TObject);
begin
  drvUnterschrift := TBitMap.Create;
  Lang_Contract := TStringList.Create;
end;

procedure TPrintViewForm.LoadLanguagePack;
var
  BesucherHinweise: TStringList;
  n: integer;

  procedure LoadTextFromNextLines(StartIndex: integer; s: TStrings);
  var
    n: integer;
  begin
    s.clear;
    for n := StartIndex to pred(BesucherHinweise.count) do
    begin
      if pos('[', BesucherHinweise[n]) = 1 then
        break;
      s.add(BesucherHinweise[n]);
    end;
  end;

begin
  BesucherHinweise := TStringList.Create;
  if FileExists(MyProgramPath + 'Besucher Hinweise ' + drvLanguage +
    '.TXT') then
  begin
    BesucherHinweise.LoadFromFile(MyProgramPath + 'Besucher Hinweise ' +
      drvLanguage + '.txt');
  end
  else
  begin
    BesucherHinweise.LoadFromFile(MyProgramPath + 'Besucher Hinweise DE.txt');
  end;

  // Nun alle Texte laden!
  for n := 0 to pred(BesucherHinweise.count) do
  begin

    // '[' muss da sein!
    if pos('[', BesucherHinweise[n]) <> 1 then
      continue;

    if pos('[Hinweise]', BesucherHinweise[n]) = 1 then
      LoadTextFromNextLines(succ(n), Lang_Contract);

    if pos('[Herr]', BesucherHinweise[n]) = 1 then
      Lang_Herr := BesucherHinweise[succ(n)];
    if pos('[Frau]', BesucherHinweise[n]) = 1 then
      Lang_Frau := BesucherHinweise[succ(n)];
    if pos('[gültig bis]', BesucherHinweise[n]) = 1 then
      Lang_valid := BesucherHinweise[succ(n)];
    if pos('[Rückgabe]', BesucherHinweise[n]) = 1 then
    begin
      Lang_Back[0] := BesucherHinweise[succ(n)];
      Lang_Back[1] := BesucherHinweise[succ(n) + 1];
    end;

    if pos('[Pforte Empfang]', BesucherHinweise[n]) = 1 then
      Lang_Entry := BesucherHinweise[succ(n)];

    if pos('[Parken]', BesucherHinweise[n]) = 1 then
    begin
      Lang_Parken[0] := BesucherHinweise[succ(n)];
      Lang_Parken[1] := BesucherHinweise[succ(n) + 1];
    end;

    if pos('[Unterschrift]', BesucherHinweise[n]) = 1 then
      Lang_Unterschrift := BesucherHinweise[succ(n)];
  end;
  BesucherHinweise.free;
  ersetze('gültig bis', Lang_valid, drvGueltig);
  ersetze('Herr', Lang_Herr, drvAnrede);
  ersetze('Frau', Lang_Frau, drvAnrede);
end;

procedure TPrintViewForm.FormDestroy(Sender: TObject);
begin
  drvUnterschrift.free;
  Lang_Contract.free;
end;

end.
