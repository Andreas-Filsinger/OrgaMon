{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007  Andreas Filsinger
  |
  |    This program is free software: you can redistribute it and/or modify
  |    it under the terms of the GNU General Public License as published by
  |    the Free Software Foundation, either version 3 of the License, or
  |    (at your option) any later version.
  |
  |    This program is distributed in the hope that it will be useful,
  |    but WITHOUT ANY WARRANTY; without even the implied warranty of
  |    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  |    GNU General Public License for more details.
  |
  |    You should have received a copy of the GNU General Public License
  |    along with this program.  If not, see <http://www.gnu.org/licenses/>.
  |
  |    http://orgamon.org/
  |
}
unit DruckLabel;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, JvGIF, ExtCtrls,
  OleCtrls, SHDocVw, IB_Components,
  IB_Access, IB_UpdateBar, IB_Controls, Grids,
  IB_Grid, JvImage, Datenbank;

type
  TFormDruckLabel = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit1: TEdit;
    Label7: TLabel;
    Edit2: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Edit3: TEdit;
    Button1: TButton;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Image1: TImage;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label12: TLabel;
    IB_Query1: TIB_Query;
    IB_Grid1: TIB_Grid;
    IB_Memo1: TIB_Memo;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_DataSource1: TIB_DataSource;
    Button20: TButton;
    Button2: TButton;
    PrinterSetupDialog1: TPrinterSetupDialog;
    Button4: TButton;
    Image2: TImage;
    CheckBox1: TCheckBox;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure StartTest;
    procedure SetParameter;
    procedure NewPrinter;
    procedure UpdatePageInfo;
  end;

var
  FormDruckLabel: TFormDruckLabel;

implementation

{$R *.dfm}

uses
  globals, anfix32, printers,
  basic32, DruckSpooler, dbOrgaMon,
  Funktionen_Beleg, CareTakerClient, wanfix32;

procedure TFormDruckLabel.Button1Click(Sender: TObject);
begin
  StartTest;
end;

procedure TFormDruckLabel.FormActivate(Sender: TObject);
begin
  ComboBox1.Items.assign(printer.printers);
  ComboBox1.Text := printer.printers[printer.printerindex];
  if IB_Query1.active then
    IB_Query1.refresh
  else
    IB_Query1.Open;
  UpdatePageInfo;
end;

procedure Border(DrawCanvas: TCanvas; r: Trect;
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

procedure TFormDruckLabel.SetParameter;
begin
  Edit1.Text := '100';
  Edit2.Text := '100';
  Edit4.Text := '300';
  Edit5.Text := '300';
  Edit6.Text := '3';
  Edit3.Text := '1';
end;

procedure TFormDruckLabel.StartTest;
var
  AnzLaeufe: integer;
  n, x, y, xl, yl, T: integer;
begin
  AnzLaeufe := strtol(Edit3.Text);
  x := strtol(Edit1.Text);
  y := strtol(Edit2.Text);
  xl := strtol(Edit4.Text);
  yl := strtol(Edit5.Text);
  T := strtol(Edit6.Text);
  if (AnzLaeufe > 0) then
    with printer do
    begin
      for n := 1 to AnzLaeufe do
      begin
        Title := 'Drucktest ' + inttostr(n) + '/' + Edit3.Text;
        BeginDoc;

        // Rahmen zeichen
        canvas.brush.color := clblack;
        Border(canvas, mkrect(x, y, xl, yl), T, T);
        canvas.brush.color := clwhite;

        // Script interpretieren
        EndDoc;
      end;
    end;
end;

procedure TFormDruckLabel.FormCreate(Sender: TObject);
begin
  StartDebug('DruckLabel');
  SetParameter;
end;

procedure TFormDruckLabel.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Drucken');
end;

procedure TFormDruckLabel.NewPrinter;
var
  AllThePrinters: TStringList;
  k: integer;
begin
  AllThePrinters := TStringList.create;
  with printer do
  begin
    AllThePrinters.assign(printers);
    k := AllThePrinters.indexof(ComboBox1.Text);
    if (k <> -1) then
      printerindex := k;
  end;
  AllThePrinters.free;
  //
  ComboBox1.Text := printer.printers[printer.printerindex];
  UpdatePageInfo;
end;

procedure TFormDruckLabel.ComboBox1Change(Sender: TObject);
begin
  NewPrinter;
end;

function Resolve(const s: String): String;
begin
  result := s;
end;

procedure TFormDruckLabel.Button20Click(Sender: TObject);
var
  BASIC: TBasicProcessor;
begin
  BASIC := TBasicProcessor.create;
  if CheckBox1.Checked then
    BASIC.DeviceOverride := iTestDrucker;
  BASIC.PicturePath := MyProgramPath + cHTMLTemplatesDir;
  BASIC.ResolveData := Resolve;
  BASIC.ResolveSQL := ResolveSQL;
  BASIC.WriteVal('TITEL', IB_Query1.FieldByName('NAME').AsString);
  IB_Query1.FieldByName('DEFINITION').AssignTo(BASIC);
  if not(BASIC.RUN) then
    ShowMessage(HugeSingleLine(BASIC.BasicErrors));
  BASIC.free;
end;

procedure TFormDruckLabel.Button2Click(Sender: TObject);
begin
  FormDruckSpooler.show;
end;

procedure TFormDruckLabel.Button3Click(Sender: TObject);
begin
 with Printer do
 begin
   BeginDoc;
   Title := 'Leeres Dokument ' + sTimeStamp;
   EndDoc;
 end;
end;

procedure TFormDruckLabel.Button4Click(Sender: TObject);
begin
  PrinterSetupDialog1.execute;
  UpdatePageInfo;
end;

procedure TFormDruckLabel.UpdatePageInfo;
begin
  application.ProcessMessages;
  Label3.caption := inttostr(printer.PageWidth);
  Label4.caption := inttostr(printer.PageHeight);
end;

end.
