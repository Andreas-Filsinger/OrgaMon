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
unit Auswertung;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons,
  ExtCtrls, anfix32;

type
  TFormAuswertung = class(TForm)
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    SpeedButton35: TSpeedButton;
    SpeedButton36: TSpeedButton;
    SpeedButton37: TSpeedButton;
    Label11: TLabel;
    ListBox2: TListBox;
    ProgressBar1: TProgressBar;
    Button22: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    Memo2: TMemo;
    Image2: TImage;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton37Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton35Click(Sender: TObject);
    procedure SpeedButton36Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure RadioButton10Click(Sender: TObject);
    procedure RadioButton9Click(Sender: TObject);
    procedure RadioButton8Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure xlsOLAPrefresh;
  public
    { Public-Deklarationen }
    procedure setStart(d: TANFiXDate);
    procedure setStopp(d: TANFiXDate);
    function getStart: TANFiXDate;
    function getStopp: TANFiXDate;
    procedure vorlageOLAP(sBegriff: string; Silent: boolean = false);
  end;

var
  FormAuswertung: TFormAuswertung;

implementation

uses
  globals, CaretakerClient, wanfix32,
  ExcelHelper,

  FlexCel.Core, FlexCel.xlsAdapter,
  OLAP, Funktionen_Auftrag,
   Auswertung.Generator.MixStatistik.main;

{$R *.dfm}

procedure TFormAuswertung.Button22Click(Sender: TObject);
begin
  with ListBox2 do
  begin
    if Items.Count = 1 then
      ItemIndex := 0;
    if (ItemIndex <> -1) then
    begin
      // Caches de
      InvalidateCache_ArbeitBaustelle;
      vorlageOLAP(Items[ItemIndex]);
    end;
  end;
end;

procedure TFormAuswertung.FormActivate(Sender: TObject);
begin
  if (ListBox2.Items.Count = 0) then
    xlsOLAPrefresh;
end;

procedure TFormAuswertung.FormCreate(Sender: TObject);
begin
  setStart(DatePlus(DateGet, -1));
  setStopp(DateGet);
end;

function TFormAuswertung.getStart: TANFiXDate;
begin
  result := DateTime2Long(DateTimePicker1.Date);
end;

function TFormAuswertung.getStopp: TANFiXDate;
begin
  result := DateTime2Long(DateTimePicker2.Date);
end;

procedure TFormAuswertung.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Auswertung');
end;

procedure TFormAuswertung.RadioButton10Click(Sender: TObject);
begin
  setStart(DateGet);
  setStopp(DatePlus(DateGet, 1));
end;

procedure TFormAuswertung.RadioButton1Click(Sender: TObject);
begin
  // letzter Monat
  setStart(PrevMonth(DateGet));
  setStopp(ThisMonth(DateGet));
end;

procedure TFormAuswertung.RadioButton2Click(Sender: TObject);
begin
  setStart(Details2Long(extractYear(DateGet) - 1, 1, 1));
  setStopp(Details2Long(extractYear(DateGet), 1, 1));
end;

procedure TFormAuswertung.RadioButton3Click(Sender: TObject);
var
  q, j: integer;
begin
  // letztes Quartal
  j := extractYear(DateGet);
  q := pred(Quartal(DateGet));
  if (q = 0) then
  begin
    setStart(Details2Long(pred(j), 10, 1));
    setStopp(Details2Long(j, 1, 1));
  end
  else
  begin
    setStart(Details2Long(j, 1 + (pred(q) * 3), 1));
    setStopp(Details2Long(j, 4 + (pred(q) * 3), 1));
  end;
end;

procedure TFormAuswertung.RadioButton4Click(Sender: TObject);
begin
  setStart(ThisMonth(DateGet));
  setStopp(NextMonth(DateGet));
end;

procedure TFormAuswertung.RadioButton5Click(Sender: TObject);
begin
  setStart(Details2Long(extractYear(DateGet), 1, 1));
  setStopp(Details2Long(extractYear(DateGet) + 1, 1, 1));
end;

procedure TFormAuswertung.RadioButton6Click(Sender: TObject);
var
  q: integer;
begin
  // laufendes Quartal
  q := Quartal(DateGet);
  setStart(Details2Long(extractYear(DateGet), 1 + (pred(q) * 3), 1));
  setStopp(Details2Long(extractYear(DateGet), 4 + (pred(q) * 3), 1));
end;

procedure TFormAuswertung.RadioButton8Click(Sender: TObject);
begin
  setStart(DatePlus(DateGet, -2));
  setStopp(DatePlus(DateGet, -1));
end;

procedure TFormAuswertung.RadioButton9Click(Sender: TObject);
begin
  setStart(DatePlus(DateGet, -1));
  setStopp(DateGet);
end;

procedure TFormAuswertung.setStart(d: TANFiXDate);
begin
  DateTimePicker1.Date := long2datetime(d);
end;

procedure TFormAuswertung.setStopp(d: TANFiXDate);
begin
  DateTimePicker2.Date := long2datetime(d);
end;

procedure TFormAuswertung.SpeedButton1Click(Sender: TObject);
begin
  FormAGM_main.show;
end;

procedure TFormAuswertung.SpeedButton35Click(Sender: TObject);
begin
  xlsOLAPrefresh;
end;

procedure TFormAuswertung.SpeedButton36Click(Sender: TObject);
begin
  openShell(iOlapPath);
end;

procedure TFormAuswertung.SpeedButton37Click(Sender: TObject);
begin
  with ListBox2 do
    if (ItemIndex <> -1) then
      openShell(iOlapPath + Items[ItemIndex] + cVorlageExtension +
        cExcelExtension);
end;

procedure TFormAuswertung.vorlageOLAP(sBegriff: string;
  Silent: boolean = false);
var
  GlobalVars: TStringList;
  DestFName: string;
  xlsAUSGABE: TXLSFIle;
  Content: TList;
  Headers: TStringList;
  sSub: TStringList;
  n: integer;
  SheetParameter: integer;
begin
  BeginHourGlass;
  ProgressBar1.max := 10;
  ProgressBar1.Position := 1;
  GlobalVars := TStringList.Create;
  Content := TList.Create;
  Headers := TStringList.Create;
  xlsAUSGABE := TXLSFile.create(true);
  DestFName := AnwenderPath + sBegriff + cExcelExtension;
  FileDelete(DestFName);
  GlobalVars.add('$StartDatum=''' + long2date(getStart) + '''');
  GlobalVars.add('$EndeDatum=''' + long2date(getStopp) + '''');
  GlobalVars.add('$StoppDatum=''' + long2date(DatePlus(getStopp, -1)) + '''');
  GlobalVars.add('$ExcelOpen=' + cINI_Deactivate);
  GlobalVars.add('$Vorlage=''' + sBegriff + '''');
  GlobalVars.addstrings(Memo2.lines);
  FormOLAP.StandardParameter(GlobalVars);

  //
  // Idee für die Verallgemeinerung:
  //
  // # öffne die Excel-Vorlage
  // # das Arbeitsblatt 1 (meist "Deckblatt") bleibt vollig unberührt
  // # schreibe die Parameter in Arbeitsblatt 2+ (Name "Parameter" wird gesucht)
  // # lade zu jedem weiteren Arbeitsblatt das OLAP Vorlagename.ArbeitsblattName.OLAP.txt
  // und fülle das Blatt entsprechend dem Ergebnis.
  // #
  //

  with xlsAUSGABE do
  begin

    //
    Open(iOlapPath + sBegriff + cVorlageExtension + cExcelExtension);

    // erste Seite -> Globale Parameter
    Headers.add('Parameter');
    Headers.add('Wert');
    for n := 0 to pred(GlobalVars.Count) do
    begin
      sSub := TStringList.Create;
      sSub.add(nextp(GlobalVars[n], '=', 0));
      sSub.add(nextp(GlobalVars[n], '=', 1));
      Content.add(sSub);
    end;
    ProgressBar1.max := SheetCount + 1;
    ProgressBar1.Position := 2;

    // Suche die Tabelle "Parameter", default = zweites Sheet
    SheetParameter := 2;
    for n := SheetCount downto 1 do
    begin
      ActiveSheet := n;
      if (SheetName = 'Parameter') then
      begin
        SheetParameter := n;
        break;
      end;
    end;

    // Parameter-Sheet befüllen
    ActiveSheet := SheetParameter;
    ClearSheet;
    ExcelExport('', Content, Headers, nil, xlsAUSGABE);

    for n := succ(SheetParameter) to SheetCount do
    begin
      ActiveSheet := n;
      ProgressBar1.Position := n;
      ClearSheet;

      // Sicherstellen, dass es die Datei gibt!
      FileAlive(iOlapPath + sBegriff + '.' + SheetName + cOLAPExtension);

      // Nun das OLAP ausführen!
      FormOLAP.DoContextOLAP(iOlapPath + sBegriff + '.' + SheetName +
        cOLAPExtension, GlobalVars, xlsAUSGABE);
    end;

    ActiveSheet := 1;
    Save(DestFName);
  end;
  xlsAUSGABE.free;
  for n := 0 to pred(Content.Count) do
    TStringList(Content[n]).free;
  Content.free;
  Headers.free;
  GlobalVars.free;
  ProgressBar1.Position := 0;
  if not(Silent) then
    openShell(DestFName);
  EndHourGlass;
end;

procedure TFormAuswertung.xlsOLAPrefresh;
var
  sDir: TStringList;
  n: integer;
begin
  sDir := TStringList.Create;
  with ListBox2 do
  begin
    Items.BeginUpdate;
    Items.clear;
    dir(iOlapPath + '*' + cVorlageExtension + cExcelExtension, sDir, false);
    for n := 0 to pred(sDir.Count) do
      Items.add(nextp(sDir[n], cVorlageExtension + cExcelExtension, 0));
    Items.EndUpdate;
  end;
  sDir.free;
end;

end.
