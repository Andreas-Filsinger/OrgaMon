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
unit OLAPArbeitsplatz;
//
// select distinct
// "Focusiertes Feld"
// from
// "Focusierte Tabelle"
// { -- gibt es Fremdbedingungen
// join
// (Fremdtabelle mit Bedingungen)
// }
//
// { -- if fremde oder eigene Bedingungen
// where
// { -- if eigenen Bedingung
// "Bedingungen der eigenen Tabelle"
// }
// {
// "Bedingungen der fremden Tabelle"
// }
// }

// Fremdbedingungen sind solche, die nicht die eigene Tabelle betreffen
//

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  ImgList, ComCtrls, JvGIF,
  ExtCtrls, StdCtrls, ToolWin,
  Grids, IB_Components, IB_Access,
  gplists, Buttons;

type
  TFormOLAPArbeitsplatz = class(TForm)
    ImageList1: TImageList;
    DrawGrid1: TDrawGrid;
    ToolBar1: TToolBar;
    ToolButton16: TToolButton;
    ToolButton3: TToolButton;
    ToolButton8: TToolButton;
    ToolButton7: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton5: TToolButton;
    ToolButton33: TToolButton;
    ToolButton38: TToolButton;
    ToolButton2: TToolButton;
    ToolButton32: TToolButton;
    ToolButton13: TToolButton;
    ToolButton12: TToolButton;
    ToolButton18: TToolButton;
    ToolButton31: TToolButton;
    ToolButton23: TToolButton;
    ToolButton34: TToolButton;
    ToolButton6: TToolButton;
    ToolButton21: TToolButton;
    ToolButton40: TToolButton;
    ToolButton41: TToolButton;
    ToolButton11: TToolButton;
    ToolButton43: TToolButton;
    ToolButton17: TToolButton;
    Image2: TImage;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    ToolButton1: TToolButton;
    Label1: TLabel;
    ComboBox1: TComboBox;
    ToolBar2: TToolBar;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ToolButton22: TToolButton;
    ToolButton24: TToolButton;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    StaticText10: TStaticText;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit30: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Edit34: TEdit;
    Edit35: TEdit;
    Edit36: TEdit;
    Edit37: TEdit;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Edit61: TEdit;
    Edit62: TEdit;
    Edit63: TEdit;
    Edit64: TEdit;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Edit91: TEdit;
    Edit92: TEdit;
    Edit93: TEdit;
    Edit94: TEdit;
    Edit95: TEdit;
    Edit96: TEdit;
    Edit97: TEdit;
    Edit98: TEdit;
    Edit109: TEdit;
    Edit112: TEdit;
    Edit113: TEdit;
    Edit114: TEdit;
    Edit115: TEdit;
    Edit116: TEdit;
    Edit117: TEdit;
    Edit118: TEdit;
    Edit119: TEdit;
    Edit120: TEdit;
    Label98: TLabel;
    Label99: TLabel;
    Label100: TLabel;
    Label101: TLabel;
    Label102: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    Label110: TLabel;
    Label111: TLabel;
    Label112: TLabel;
    Label113: TLabel;
    Label114: TLabel;
    Label115: TLabel;
    Label116: TLabel;
    Label127: TLabel;
    ToolButton25: TToolButton;
    SpeedButton3: TSpeedButton;
    ToolButton26: TToolButton;
    ToolButton27: TToolButton;
    ToolButton29: TToolButton;
    ToolButton30: TToolButton;
    Label21: TLabel;
    StaticText11: TStaticText;
    ToolButton35: TToolButton;
    ProgressBar1: TProgressBar;
    TabSheet5: TTabSheet;
    Memo1: TMemo;
    Label22: TLabel;
    SpeedButton1: TSpeedButton;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    SpeedButton2: TSpeedButton;
    ToolButton4: TToolButton;
    ToolButton28: TToolButton;
    ToolButton36: TToolButton;
    procedure Image2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure Edit95Change(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure ToolButton24Click(Sender: TObject);
    procedure ToolButton25Click(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure ToolButton19Click(Sender: TObject);
    procedure ToolButton20Click(Sender: TObject);
    procedure ToolButton22Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure ToolButton27Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure ToolButton29Click(Sender: TObject);
    procedure ToolButton16Click(Sender: TObject);
    procedure ToolButton26Click(Sender: TObject);
    procedure ToolButton35Click(Sender: TObject);
    procedure TabSheet5Show(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBox3Select(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton33Click(Sender: TObject);
    procedure ToolButton21Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

    { Private-Deklarationen }
    ContentHeaders: TStringList;
    ConnectionItems: TStringList;
    // Connection-Strings, also Name der Datenbank. Objects: IB_connections

    ContentItems: TList;
    // ConnectionIndex;CalibrationID;EquipmentID;SerialNumber - Objects: <nil>
    ItemMarked: TgpIntegerList;
    UserBreak: boolean;

    //
    QuestionaireFields: TStringList;
    JoinFields: TStringList;
    MaxTag: Integer;
    SupressGridPaint: Integer;

    // online=true: alles aus einer Live Connection
    // online=false: alles aus der OLAP$TMP Tabelle der aktuellen Datenbank
    ColQueries: TStringList;
    ColSettings: TList;

    // für lokale Queries
    TempTables: TStringList;

    // Für das malen der Liste
    StatusBMPs: array of TBitMap;

    // Für ausgeblendete Dateien!
    BlackList: TStringList;

    // init-Vorgang
    function CreateSymbol(id: Integer): TBitMap;
    procedure LoadStartupView;

    // Connection Verwaltung
    procedure LoadConnections(FName: string);

    // Content Verwaltung
    procedure Content_load(FName: string);
    procedure Content_delete(Index: Integer = -1);
    function Content_CellText(row, col: Integer): string;
    procedure Content_complete;
    procedure Content_plausibel;
    procedure Content_prepare(Subs: TStringList);
    procedure Content_close;

    // Temp Table verwaltung!
    procedure Tmp_load(tTable: TList; FName: string);
    procedure Tmp_delete(tTable: TList; Index: Integer = -1);
    function Tmp_Aufzaehlung(tTable: TList; col: Integer;
      HasHeader: boolean = true): string;

    // Speichern als Excel

    // User Interface Funktionen
    function FocusTag: Integer;
    function TagEdit(eTag: Integer): TEdit;
    function TagLabel(eTag: Integer): TLabel;
    function TagWhere(eTag: Integer): string;
    function fullWhere(JoinTables: TStringList = nil): TStringList;
    function fullQuest(fromTable: string): TStringList;
    function fullReject(fromTable: string): TStringList;
    function fmDisplay(const s: string): string;

    // Einstellungen für die einzelnen Spalten
    function ColparamAsInteger(const s: string): Integer; overload;
    function ColparamAsString(const s: string): string; overload;
    function ColparamAsInteger(c: Integer; const s: string): Integer; overload;
    function ColparamAsString(c: Integer; const s: string): string; overload;

    // Questionaire
    function quFieldName(eTag: Integer): string;
    function quTableName(eTag: Integer): string;
    function quAbfrage: TStringList;
    procedure quLoad(FromL: TStringList); overload;
    procedure quLoad(FromFName: string); overload;
    procedure quFillGrid;

    function quFieldTypeNumeric(eTag: Integer): boolean;
    function quFieldTypeDateTime(eTag: Integer): boolean;
    function quTableHas(TableName, FieldName: string): boolean;

    //
    function quLastFName(Mask: string): string;

    procedure RefreshLoadCombo;
    procedure RefreshXLSCombo;
    procedure RefreshDBCombo;
    procedure RefreshQuestionaireInfo;
    procedure Mark;

    procedure dir(const Mask: string; FileNames: TStrings; uppercase: boolean);
    procedure bericht(AllowOpen: boolean = true);
    procedure run;

    // Sachen für den Tagesabschluss
    procedure readHelium;
    procedure writeGestern;

  public
    { Public-Deklarationen }
    procedure Tagwache;
  end;

var
  FormOLAPArbeitsplatz: TFormOLAPArbeitsplatz;

implementation

uses
  math, wanfix32,
  anfix32, html,

  // FlexCell
  FlexCel.Core, FlexCel.xlsAdapter,

  globals, CareTakerClient, OLAP,
  dbOrgaMon, IB_Header, OLAPedit,
  main, Bearbeiter, OpenOfficePDF,
  Datenbank;

{$R *.dfm}

const
  cPlanX = 18;
  cPlanY = 16;
  cPlanQ = 50;
  cPlanY_div_2 = cPlanY div 2;

  cOLAPAbfrageExtension = '.OLAP-Parameter.txt';
  cQuestionaireVolumeFName = 'Bericht-Volumen.OLAP.csv';
  cQuestionaireRejectFName = 'Ausfall-Volumen.OLAP.csv';

  // Spalten Definition!
  col_Equipment: Integer = 0;
  col_Calibration: Integer = 1;
  col_Serial: Integer = 2;

  // weitere Spalten aus Text-Definition
  col_FirstCalculated = 3;
  col_Moment = col_FirstCalculated + 0;
  col_Qmin = col_FirstCalculated + 1;
  col_Q02max = col_FirstCalculated + 2;
  col_Qmax = col_FirstCalculated + 3;
  col_Radpaar = col_FirstCalculated + 4;
  col_RDppc = col_FirstCalculated + 5;
  col_Dminmax = col_FirstCalculated + 6;
  col_Dmin = col_FirstCalculated + 7;
  col_D02max = col_FirstCalculated + 8;
  col_Dmax = col_FirstCalculated + 9;
  col_FieldOrder = col_FirstCalculated + 10;
  col_AnzahlMesspunkte = col_FirstCalculated + 11;
  col_typ = col_FirstCalculated + 12;
  col_FirstFrei = col_FirstCalculated + 13;

  col_CountCalculated = 23;
  col_names: array [0 .. pred(col_CountCalculated)] of string = ('Prüfmoment',
    'Fehler-Qmin', 'Fehler-Q02max', 'Fehler-Qmax', 'Radpaar', 'RP%',
    'Druckverluste-Qmin-max', 'Druckverluste-Qmin', 'Druckverluste-Q02max',
    'Druckverluste-Qmax', 'Auftragsnummer', 'Anzahl-Tests', 'Typ',
    'Dimension.Frei.1', 'Dimension.Frei.2', 'Dimension.Frei.3',
    'Dimension.Frei.4', 'Dimension.Frei.5', 'Dimension.Frei.6',
    'Dimension.Frei.7', 'Dimension.Frei.8', 'Dimension.Frei.9',
    'Dimension.Frei.0');

  col_last = col_FirstCalculated + pred(col_CountCalculated);

function SQL_and(var FormerStatements: Integer): string;
begin
  if (FormerStatements < 1) then
    result := '    '
  else
    result := 'and ';
  inc(FormerStatements);
end;

procedure TFormOLAPArbeitsplatz.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'OLAP.Arbeitsplatz');
end;

procedure TFormOLAPArbeitsplatz.FormActivate(Sender: TObject);
var
  SQLquery: TStringList;
  n, m, k: Integer;
  ActSettings: TStringList;
  ActGridCol: Integer;
  _LastTag: Integer;
  LastTag: Integer;
  LastParameterFName: string;
  _lcaption: string;

  procedure SetGridHeader(TextLabel: TStaticText; HeaderS: string;
    ColSpan: Integer = 1);
  var
    _left: Integer;
    _width: Integer;
    n: Integer;
  begin
    with TextLabel do
    begin
      //
      top := StaticText1.top;

      if (ActGridCol > 0) then
      begin
        _left := StaticText1.left; // Anker!
        for n := 0 to pred(ActGridCol) do
          inc(_left, DrawGrid1.ColWidths[n]);
        left := succ(_left);
      end;

      height := StaticText1.height;
      _width := DrawGrid1.ColWidths[ActGridCol];
      for n := 2 to ColSpan do
        inc(_width, DrawGrid1.ColWidths[ActGridCol + pred(ColSpan)]);
      if (ActGridCol = 0) then
        width := _width + 2
      else
        width := succ(_width);

      Caption := HeaderS;
    end;
    inc(ActGridCol, ColSpan);

  end;

begin
  RefreshDBCombo;

  //
  if not(assigned(ConnectionItems)) then
  begin

    BeginHourGlass;
    if (ComboBox3.items.count > 0) then
      if (ComboBox3.itemIndex = -1) then
        ComboBox3.itemIndex := 0;

    inc(SupressGridPaint);

    ConnectionItems := TStringList.create;
    ContentItems := TList.create;
    ItemMarked := TgpIntegerList.create;
    ColQueries := TStringList.create;
    ColSettings := TList.create;
    TempTables := TStringList.create;
    QuestionaireFields := TStringList.create;
    JoinFields := TStringList.create;
    BlackList := TStringList.create;

    //
    BlackList.add('out.xls');

    // imp pend: hardcoded:
    JoinFields.add('CALIBRATIONID');
    JoinFields.add('EQUIPMENTID');
    JoinFields.add('SERIALNUMBER');

    QuestionaireFields.LoadFromFile
      (iOlapPath + 'External.Questionaire.Fields.txt');
    LastTag := 0;
    for n := 0 to pred(QuestionaireFields.count) do
    begin
      _LastTag := StrToIntDef(nextp(QuestionaireFields[n], '=', 0), 0);
      if (_LastTag > 0) then
        LastTag := _LastTag;
      if (pos('.', QuestionaireFields[n]) = 1) then
        QuestionaireFields[n] := inttostr(LastTag) + QuestionaireFields[n];

      MaxTag := max(MaxTag, LastTag);
    end;

    // set Label-Captions
    for n := 1 to MaxTag do
    begin
      _lcaption := QuestionaireFields.values[inttostr(n) + '.CAPTION'];
      if (_lcaption <> '') then
        TagLabel(n).Caption := _lcaption;
    end;

    // Vorgegebenes Spalten Setting laden
    for n := 0 to col_FirstCalculated do
    begin
      ActSettings := TStringList.create;
      if FileExists(iOlapPath + cOLAPDimPrefix + inttostr(n) + '.txt') then
        ActSettings.LoadFromFile(iOlapPath + cOLAPDimPrefix + inttostr(n)
          + '.txt');
      ColSettings.add(ActSettings);
    end;

    // Spalten - SQL laden.
    SQLquery := TStringList.create;
    for n := 0 to pred(col_CountCalculated) do
    begin
      ActSettings := TStringList.create;
      if FileExists(iOlapPath + cOLAPDimPrefix + col_names[n] + '.txt') then
      begin
        SQLquery.LoadFromFile(iOlapPath + cOLAPDimPrefix + col_names[n]
          + '.txt');
        for m := pred(SQLquery.count) downto 0 do
        begin
          k := pos('--', SQLquery[m]);
          if (k > 0) then
          begin
            ActSettings.add(cutblank(copy(SQLquery[m], k + 2, MaxInt)));
            SQLquery[m] := copy(SQLquery[m], 1, pred(k));
          end;
        end;
      end
      else
      begin
        SQLquery.clear;
        SQLquery.add(cOLAPNull);
      end;
      ColQueries.add(HugeSingleLine(SQLquery, ' '));
      ColSettings.add(ActSettings);
    end;
    SQLquery.free;

    //
    LastParameterFName := quLastFName('*' + cOLAPAbfrageExtension);
    if (LastParameterFName <> '') then
      quLoad(LastParameterFName);

    ComboBox2.text := quLastFName('*.xls');

    application.processmessages;

    // Jetzt erstmalig Leer anzeigen

    with DrawGrid1, canvas do
    begin
      DefaultRowHeight := cPlanY;
      Font.Name := 'Courier New';
      Font.Size := 7;
      Font.Color := clblack;

      ColCount := 17;

      // Defaults
      ColWidths[0] := cPlanX; // Symbol(e)
      ColWidths[1] := 40; // Equipment
      ColWidths[2] := 80; // Calib
      ColWidths[3] := 80; // Serial
      ColWidths[4] := 150; // TimeStamp

      ColWidths[5] := cPlanQ; // Qmin
      ColWidths[6] := cPlanQ; // 0,2Qmax
      ColWidths[7] := cPlanQ; // Qmax

      ColWidths[8] := 47; // Radpaar
      ColWidths[9] := 47; // RP%

      ColWidths[10] := cPlanQ; // D-Qmin(max)
      ColWidths[11] := cPlanQ; // D-Qmin
      ColWidths[12] := cPlanQ; // D-0,2QMin
      ColWidths[13] := cPlanQ; // D-Q-max

      ColWidths[14] := 129; // Auftragsnummer
      ColWidths[15] := 10;
      ColWidths[16] := 1; // Dummy

      // ev. die Defaults überschreiben!
      for n := 0 to pred(17) do
      begin
        k := ColparamAsInteger(n, 'WIDTH');
        if (k <> -1) then
          ColWidths[n] := k;
      end;

      ClientHeight := succ(pred(ClientHeight) div DefaultRowHeight) *
        DefaultRowHeight;
      rowCount := 0;
    end;

    // Titel der Tabelle anzeigen:
    ActGridCol := 0;
    SetGridHeader(StaticText1, 'DB');

    if (ColparamAsString(1, 'TITLE') = '') then
      SetGridHeader(StaticText2, 'Bank')
    else
      SetGridHeader(StaticText2, ColparamAsString(1, 'TITLE'));

    if (ColparamAsString(2, 'TITLE') = '') then
      SetGridHeader(StaticText3, 'Calib')
    else
      SetGridHeader(StaticText3, ColparamAsString(2, 'TITLE'));

    if (ColparamAsString(3, 'TITLE') = '') then
      SetGridHeader(StaticText4, 'Serial')
    else
      SetGridHeader(StaticText4, ColparamAsString(3, 'TITLE'));

    if (ColparamAsString(4, 'TITLE') = '') then
      SetGridHeader(StaticText5, 'Moment')
    else
      SetGridHeader(StaticText5, ColparamAsString(4, 'TITLE'));

    if (ColparamAsString(5, 'TITLE') = '') then
      SetGridHeader(StaticText6, 'Fehler' + #13 + 'Qmin  0,2Qmax  Qmax', 3)
    else
      SetGridHeader(StaticText6, ColparamAsString(5, 'TITLE'), 3);

    if (ColparamAsString(8, 'TITLE') = '') then
      SetGridHeader(StaticText7, 'RP')
    else
      SetGridHeader(StaticText7, ColparamAsString(8, 'TITLE'));

    if (ColparamAsString(9, 'TITLE') = '') then
      SetGridHeader(StaticText8, 'RP%')
    else
      SetGridHeader(StaticText8, ColparamAsString(9, 'TITLE'));

    if (ColparamAsString(10, 'TITLE') = '') then
      SetGridHeader(StaticText9, 'Druck' + #13 +
        'Qmin(max)  Qmin  0,2Qmax  Qmax', 4)
    else
      SetGridHeader(StaticText9, ColparamAsString(10, 'TITLE'), 4);

    if (ColparamAsString(11, 'TITLE') = '') then
      SetGridHeader(StaticText10, 'Auftrags' + #13 + 'Nummer')
    else
      SetGridHeader(StaticText10, ColparamAsString(11, 'TITLE'));

    SetGridHeader(StaticText11, '3' + #13 + '!');

    SetLength(StatusBMPs, 1);
    StatusBMPs[0] := CreateSymbol(96);

    LoadStartupView;
    dec(SupressGridPaint);

    DrawGrid1.refresh;

    EndHourGlass;
  end;

  // Werte in der "load" Combobox auffrischen
  RefreshLoadCombo;
  RefreshXLSCombo;
end;

procedure TFormOLAPArbeitsplatz.LoadStartupView;
begin
  //
  FormOLAP.DoContextOLAP(iOlapPath + 'Datenbanken.OLAP.txt');
  Content_load(FormOLAP.RohdatenFName(0));
  quFillGrid;
end;

function TFormOLAPArbeitsplatz.CreateSymbol(id: Integer): TBitMap;
begin
  result := TBitMap.create;
  ImageList1.GetBitmap(id, result);
end;

procedure TFormOLAPArbeitsplatz.DrawGrid1DrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  FocusColor: TColor;
  Fokusiert: boolean;
  Subs: TStringList;
  DataCol: Integer;
begin

  try
    if (ARow >= 0) then
      with DrawGrid1.canvas do
      begin

        Fokusiert := (ARow = DrawGrid1.row);

        if Fokusiert then
        begin
          brush.Color := HTMLColor2TColor($99CCFF);
        end
        else
        begin
          if odd(ARow) then
          begin
            brush.Color := clWhite;
          end
          else
          begin
            brush.Color := clListeGrau;
          end;
        end;

        repeat

          if not(assigned(ContentItems)) then
          begin
            FillRect(Rect);
            break;
          end;

          if (ARow < ContentItems.count) and (SupressGridPaint = 0) then
          begin

            Subs := TStringList(ContentItems[ARow]);

            // Anzahl der Feldinhalte sicherstellen
            Content_prepare(Subs);

            if (ItemMarked.indexof(ARow) <> -1) then
            begin
              if Fokusiert then
              begin
                brush.Color := HTMLColor2TColor($CCFFFF); // $99FF00
              end
              else
              begin
                if odd(ARow) then
                begin
                  brush.Color := HTMLColor2TColor($00CCFF);
                end
                else
                begin
                  brush.Color := HTMLColor2TColor($0099CC);
                end;
              end;
            end;
            FocusColor := brush.Color;
            case ACol of
              0:
                begin
                  FillRect(Rect);
                  draw(Rect.left + 3, Rect.top, StatusBMPs[0]); // Status
                end;
              1:
                begin
                  Font.Size := 10;
                  TextRect(Rect, Rect.left + 2, Rect.top, fmDisplay(Subs[0]));
                  // Equipment
                end;
              2:
                begin
                  Font.Size := 10;
                  TextRect(Rect, Rect.left + 2, Rect.top, fmDisplay(Subs[1]));
                  // Calibration
                end;
              3:
                begin
                  Font.Size := 10;
                  TextRect(Rect, Rect.left + 2, Rect.top, fmDisplay(Subs[2]));
                  // Serial
                end;
              4 .. 4 + pred(col_CountCalculated):
                begin
                  Font.Size := 9;
                  DataCol := ACol - 1;
                  if (Subs[DataCol] = cOLAPNull) then
                    Subs[DataCol] := Content_CellText(ARow, DataCol);
                  TextRect(Rect, Rect.left + 2, Rect.top,
                    fmDisplay(Subs[DataCol]));
                end;
            else
              // Dummy Rand Zellen
              FillRect(Rect);
            end;

            if (ACol > 0) then
            begin
              pen.Color := $A0A0A0;
              MoveTo(Rect.left, Rect.top);
              LineTo(Rect.left, Rect.bottom);
            end;
            break;
          end;

          // total leer!
          FillRect(Rect);
        until true;
      end;
  except
  end;
end;

procedure TFormOLAPArbeitsplatz.LoadConnections(FName: string);
var
  FullOLAPScript: TStringList;
  n: Integer;
  AutoMataState: Integer;
begin
  FullOLAPScript := TStringList.create;
  ConnectionItems.clear;
  FullOLAPScript.LoadFromFile(iOlapPath + 'Datenbanken.OLAP.txt');
  AutoMataState := 0;
  for n := 0 to pred(FullOLAPScript.count) do
  begin
    case AutoMataState of
      0:
        if (FullOLAPScript[n] = 'connect') then
          AutoMataState := 1;
      1:
        if (FullOLAPScript[n] = '-') then
        begin
          AutoMataState := 2
        end
        else
        begin
          if (FullOLAPScript[n] <> '') then
            ConnectionItems.add(FullOLAPScript[n]);
        end;
      2:
        break;
    end;
  end;
  FullOLAPScript.free;
end;

procedure TFormOLAPArbeitsplatz.Tmp_delete(tTable: TList; Index: Integer);
var
  n: Integer;
begin
  if (Index = -1) then
  begin
    for n := pred(tTable.count) downto 0 do
      Tmp_delete(tTable, n);
  end
  else
  begin
    TStringList(tTable[Index]).free;
    tTable.delete(Index);
  end;
end;

procedure TFormOLAPArbeitsplatz.Tmp_load(tTable: TList; FName: string);
var
  n, m: Integer;
  Cols: TStringList;
  ThisHeader: string;
  ThisData: string;
  ColCount: Integer;
  JoinL: TStringList;
begin
  JoinL := TStringList.create;
  Tmp_delete(tTable);
  tTable.add(TStringList.create);
  LoadFromFileCSV(true, JoinL, FName);
  if (JoinL.count > 0) then
  begin
    ThisHeader := JoinL[0];
    while (ThisHeader <> '') do
      TStringList(tTable[0]).add(nextp(ThisHeader, cOLAPcsvSeparator));
    ColCount := TStringList(tTable[0]).count;
    for n := 1 to pred(JoinL.count) do
    begin
      ThisData := JoinL[n];
      Cols := TStringList.create;
      for m := 0 to pred(ColCount) do
        Cols.add(nextp(ThisData, cOLAPcsvSeparator));
      tTable.add(Cols);
    end;
  end;
  JoinL.free;
end;

procedure TFormOLAPArbeitsplatz.Content_load(FName: string);
begin
  Tmp_load(ContentItems, FName);
  PageControl1.ActivePage := TabSheet4;
  Edit95.SetFocus;
end;

procedure TFormOLAPArbeitsplatz.Content_delete(Index: Integer);
begin
  Tmp_delete(ContentItems);
end;

function TFormOLAPArbeitsplatz.Content_CellText(row, col: Integer): string;
var
  Subs: TStringList;
  n: Integer;
  cABFRAGE: TIB_Cursor;
  TheSQL: string;

  // für TMP Zugriffe
  ExternalFileName: string;
  ReferencedColName: string;
  ReturnedColName: string;
  StoredTableIndex: Integer;
  TheTempTable: TList;
  TheTempTableHeader: TStringList;
  SearchCol: Integer;
  ResultCol: Integer;
  ReferencedVal: string;
  HeaderText: string;

  fmtDouble: string;
  roundDouble: double;
  charsDouble: Integer;

begin

  try

    // die Datenzeile an sich holen
    Subs := ContentItems[row];

    // das passende SQL laden
    TheSQL := ColQueries[col - col_FirstCalculated];

    repeat

      if pos('$$', TheSQL) = 1 then
      begin
        //
        // zugriff auf eine temp-tabelle, die im Moment extern geladen wird!
        // hier gibt es noch kein zu OLAP passendes Konzept!
        //
        // select RP from External.Gears.txt where RADPAAR = $RADPAAR
        //
        ExternalFileName := ExtractSegmentbetween(TheSQL, 'from ', ' where');
        ReferencedColName := ExtractSegmentbetween(TheSQL, 'where ', ' =');
        ReturnedColName := ExtractSegmentbetween(TheSQL, 'select ', ' from');

        ReferencedVal := Subs[col_Radpaar]; // sorry - Hardcoded!!!
        HeaderText := 'RPpc';

        StoredTableIndex := TempTables.indexof(ExternalFileName);
        if (StoredTableIndex = -1) then
        begin
          StoredTableIndex := TempTables.count;
          TheTempTable := TList.create;
          TempTables.addobject(ExternalFileName, TheTempTable);
          Tmp_load(TheTempTable, iOlapPath + ExternalFileName);
        end
        else
        begin
          TheTempTable := TList(TempTables.objects[StoredTableIndex]);
        end;

        TheTempTableHeader := TStringList(TheTempTable[0]);
        SearchCol := TheTempTableHeader.indexof(ReferencedColName);
        ResultCol := TheTempTableHeader.indexof(ReturnedColName);
        result := cOLAPNull;
        for n := 1 to pred(TheTempTable.count) do
          if (ReferencedVal = TStringList(TheTempTable[n])[SearchCol]) then
          begin
            result := TStringList(TheTempTable[n])[ResultCol];
            break;
          end;
        break;
      end;

      if (TheSQL = cOLAPNull) then
      begin
        // keine Definition gefunden
        HeaderText := col_names[col - col_FirstCalculated];
        result := cOLAPNull;
        break;
      end;

      if (pos('!', TheSQL) = 1) then
      begin
        // Konstanter Wert
        HeaderText := col_names[col - col_FirstCalculated];
        result := copy(TheSQL, 2, MaxInt);
        break;
      end;

      // echtes SQL Statement

      // die 3 Referenzpunkte konkretisieren
      for n := 0 to 2 do
        ersetze('$' + ContentHeaders[n], fmDisplay(Subs[n]), TheSQL);

      // das Script starten und das Zeug holen
      cABFRAGE := DataModuleDatenbank.nCursor;
      with cABFRAGE do
      begin
        if assigned(cConnection) then
          ib_connection := cConnection;
        sql.add(TheSQL);
        ApiFirst;

        // Ergebniswert
        with Fields[0] do
        begin
          if (SQLType = SQL_DOUBLE) or (SQLType = SQL_DOUBLE_) then
          begin

            fmtDouble := ColparamAsString(col + 1, 'FORMAT');
            if fmtDouble = '' then
              fmtDouble := '%.2f';

            if (ColparamAsString(col + 1, 'ROUND') = '') then
              roundDouble := 100.0
            else
              roundDouble := strtodoubledef(ColparamAsString(col + 1,
                'ROUND'), 100);

            // "+" oder "-" sicherstellen!
            if (AsDouble < 0) then
              result := format(fmtDouble,
                [round(AsDouble * roundDouble) / roundDouble])
            else
              result := '+' + format(fmtDouble,
                [round(AsDouble * roundDouble) / roundDouble]);

            // mit schönen Nullen auffüllen!
            charsDouble := ColparamAsInteger(pred(col), 'LENGTH');
            if (charsDouble = -1) then
              charsDouble := 5;
            if (length(result) < charsDouble) then
              result := result + fill('0', charsDouble - length(result));

          end
          else
          begin
            result := AsString;
          end;
          // Spaltenüberschrift noch nachtragen
          HeaderText := FieldName;
        end;

      end;
      cABFRAGE.free;

    until true;

    // Ev. noch die Überschrift hinzunehmen
    if (ContentHeaders.count <= col) then
    begin
      for n := ContentHeaders.count to col do
        ContentHeaders.add('TITEL');
      ContentHeaders[col] := HeaderText;
    end;

  except
    on E: Exception do
    begin
      AppendStringsToFile(TheSQL + ':' + E.Message,
        DiagnosePath + 'OLAPArbeitsplatz.log.txt');
      result := '<?>';
    end;
  end;
end;

procedure TFormOLAPArbeitsplatz.ToolButton3Click(Sender: TObject);
var
  fSQL, rSQL: TStringList;
  ActInputFieldTag: Integer;
  fromTable: string;
begin
  BeginHourGlass;
  ActInputFieldTag := FocusTag;
  if (ActInputFieldTag > 0) then
    fromTable := nextp(quFieldName(ActInputFieldTag), '.', 0)
  else
    fromTable := 'METERS';
  fSQL := fullQuest(fromTable);
  fSQL.add('');
  rSQL := fullReject(fromTable);
  fSQL.addstrings(rSQL);
  fSQL.SaveToFile(AnwenderPath + 'Question.OLAP.txt');
  fSQL.free;
  rSQL.free;
  EndHourGlass;
  openShell(AnwenderPath + 'Question.OLAP.txt');
end;

procedure TFormOLAPArbeitsplatz.ToolButton12Click(Sender: TObject);
var
  cABRUF: TIB_Cursor;
  ActInputFieldTag: Integer;

  //
  qTABLE_Name: string;
  qFIELD_Name: string;

  //
  ResultStrings: TStringList;
  n, m: Integer;
  ExtraWhere: TStringList;
  JoinTables: TStringList;
  SelfJoinIndex: Integer;
  SQLconditions: Integer;
  RecN: Integer;
begin
  ActInputFieldTag := FocusTag;
  if (ActInputFieldTag > 0) then
  begin

    BeginHourGlass;
    ResultStrings := TStringList.create;
    JoinTables := TStringList.create;
    try

      qFIELD_Name := quFieldName(ActInputFieldTag);
      qTABLE_Name := nextp(qFIELD_Name, '.', 0);

      cABRUF := DataModuleDatenbank.nCursor;
      with cABRUF do
      begin
        if assigned(cConnection) then
          ib_connection := cConnection;

        sql.add('select distinct');
        sql.add(' ' + qFIELD_Name);
        sql.add('from');
        sql.add(' ' + qTABLE_Name);

        ExtraWhere := fullWhere(JoinTables);

        //
        // J O I N
        //

        // join auf eigene "from" Tabelle verhindern
        SelfJoinIndex := JoinTables.indexof(qTABLE_Name);
        if (SelfJoinIndex <> -1) then
          JoinTables.delete(SelfJoinIndex);
        // join auf die restlichen, verbleibenden Tabellen verbinden
        if (JoinTables.count > 0) then
        begin
          for n := 0 to pred(JoinTables.count) do
          begin
            sql.add('inner join');
            sql.add(' ' + JoinTables[n]);
            sql.add('on');
            SQLconditions := 0;
            for m := 0 to pred(JoinFields.count) do
              if quTableHas(qTABLE_Name, JoinFields[m]) and
                quTableHas(JoinTables[n], JoinFields[m]) then
                sql.add(' ' + SQL_and(SQLconditions) + '(' + qTABLE_Name + '.' +
                  JoinFields[m] + '=' + JoinTables[n] + '.' + JoinFields
                  [m] + ')');
          end;

        end;

        // W H E R E
        sql.add('where');
        sql.add('     (' + qFIELD_Name + ' is not null)');

        // Hier die Wheres
        sql.addstrings(ExtraWhere);
        ExtraWhere.free;

        for n := 0 to pred(sql.count) do
          ResultStrings.add('-- ' + sql[n]);
        ResultStrings.add('');
        ApiFirst;
        RecN := 0;
        while not(eof) do
        begin
          ResultStrings.add(Fields[0].AsString);
          inc(RecN);
          ApiNext;
        end;
        ResultStrings.insert(0, '-- ' + inttostr(RecN) + ':');

      end;
      cABRUF.free;
    except
    end;
    ResultStrings.SaveToFile(AnwenderPath + 'OLAP-Arbeitsplatz.Feldauswahl.Tag.'
      + inttostrN(ActInputFieldTag, 3) + '.txt');
    ResultStrings.free;
    JoinTables.free;
    EndHourGlass;
    openShell(AnwenderPath + 'OLAP-Arbeitsplatz.Feldauswahl.Tag.' +
      inttostrN(ActInputFieldTag, 3) + '.txt');
  end;
end;

function TFormOLAPArbeitsplatz.FocusTag: Integer;
var
  n, m: Integer;
begin
  // Liefert den Tag des aktuell fokusierten Tags zurück.
  result := 0;
  for n := 0 to pred(PageControl1.PageCount) do
    with PageControl1.Pages[n] do
      for m := 0 to pred(ControlCount) do
        if (Controls[m].tag > 0) then
          with Controls[m] as TEdit do
            if focused then
            begin
              result := tag;
              exit;
            end;
end;

function TFormOLAPArbeitsplatz.quAbfrage: TStringList;
var
  n, m: Integer;
begin
  result := TStringList.create;
  for n := 0 to pred(PageControl1.PageCount) do
    with PageControl1.Pages[n] do
      for m := 0 to pred(ControlCount) do
        if (Controls[m].tag > 0) then
          with Controls[m] as TEdit do
            result.add(inttostr(tag) + '=' + text);
end;

procedure TFormOLAPArbeitsplatz.quLoad(FromL: TStringList);
var
  n: Integer;
  sGestern: string;
  OneIf: string;
begin
  sGestern := long2date(DatePlus(DateGet, -1));
  for n := 1 to MaxTag do
  begin
    OneIf := FromL.values[inttostr(n)];
    ersetze('~gestern~', sGestern, OneIf);
    TagEdit(n).text := OneIf;
  end;
end;

procedure TFormOLAPArbeitsplatz.quLoad(FromFName: string);
var
  Settings: TStringList;
begin
  Settings := TStringList.create;
  try
    Settings.LoadFromFile(AnwenderPath + FromFName);
    quLoad(Settings);
    ComboBox1.text := FromFName;
  except
  end;
  Settings.free;
end;

function TFormOLAPArbeitsplatz.TagEdit(eTag: Integer): TEdit;
var
  n, m: Integer;
begin
  result := nil;
  if (eTag > 0) then
    for n := 0 to pred(PageControl1.PageCount) do
      with PageControl1.Pages[n] do
        for m := 0 to pred(ControlCount) do
          if (Controls[m].tag = eTag) and (Controls[m] is TEdit) then
          begin
            result := Controls[m] as TEdit;
            exit;
          end;
end;

function TFormOLAPArbeitsplatz.TagLabel(eTag: Integer): TLabel;
var
  fEdit: TEdit;
  n, m: Integer;
begin
  result := nil;
  if (eTag > 0) then
  begin
    fEdit := TagEdit(eTag);
    for n := 0 to pred(PageControl1.PageCount) do
      with PageControl1.Pages[n] do
        for m := 0 to pred(ControlCount) do
          if (Controls[m] is TLabel) then
            with Controls[m] as TLabel do
              if FocusControl = fEdit then
              begin
                result := Controls[m] as TLabel;
                exit;
              end;
  end;
end;

procedure TFormOLAPArbeitsplatz.Tagwache;
begin
  if (iAuftragsObjektPath <> '') then
  begin
    BeginHourGlass;
    show;
    readHelium;
    writeGestern;
    close;
    EndHourGlass;
  end;
end;

function TFormOLAPArbeitsplatz.TagWhere(eTag: Integer): string;

  function Operant(s: string; IsNumeric: boolean): string;
  begin
    s := cutblank(s);
    ersetze('"', '', s);
    if IsNumeric then
      result := s
    else
      result := '''' + s + '''';
  end;

const
  cQuestOrSeperator = ',';

const
  cOperator: array [0 .. 7] of string = ('=', '>=', '<=', '>', '<', '<>',
    'like', 'starts with');

  cOperator2: array [0 .. 7] of string = ('=', '>=', '<=', '>', '<', '<>',
    ' like ', ' starts with ');

var
  OperatorINdex: Integer;
  UserQuery: string;
  n, k: Integer;
  IsNumeric: boolean;
  FirstTime: boolean;

  //
  // ev. ein Statement-Stack beim Parsen aufbauen
  //
  // >=,>,<,<=,<>,starts with, near
  // between '' and ''
  //

begin

  //
  result := '';
  try

    UserQuery := TagEdit(eTag).text;
    if (UserQuery <> '*') then
    begin

      //
      if (UserQuery = '') or (UserQuery = '!') then
      begin
        if (UserQuery = '') then
          result := ' and (' + quFieldName(eTag) + ' is null)'
        else
          result := ' and (' + quFieldName(eTag) + ' is not null)';
      end
      else
      begin
        // mehr Info zu dem Feld-Typ

        IsNumeric := quFieldTypeNumeric(eTag);
        // Operator bestimmen

        k := pos('..', UserQuery);
        if (k > 0) then
        begin
          // between
          result := ' and (' + quFieldName(eTag) + ' between ' +
            Operant(copy(UserQuery, 1, pred(k)), IsNumeric) + ' and ' +
            Operant(copy(UserQuery, k + 2, MaxInt), IsNumeric) + ')';
        end
        else
        begin

          k := pos(cQuestOrSeperator, UserQuery);

          if (k > 0) then
          begin
            result := ' and (' + quFieldName(eTag) + ' in (';

            FirstTime := true;
            while (UserQuery <> '') do
            begin

              if not(FirstTime) then
                result := result + ', '
              else
                FirstTime := false;

              result := result + Operant(nextp(UserQuery, cQuestOrSeperator),
                IsNumeric);
            end;
            result := result + '))';

          end
          else
          begin

            OperatorINdex := 0; // Default Operator
            for n := 0 to high(cOperator) do
              if pos(cOperator[n], UserQuery) = 1 then
              begin
                OperatorINdex := n;
                UserQuery :=
                  copy(UserQuery, succ(length(cOperator[OperatorINdex])
                  ), MaxInt);
                break;
              end;

            //
            result := ' and (' + quFieldName(eTag) + cOperator2[OperatorINdex] +
              Operant(UserQuery, IsNumeric) + ')';

          end;
        end;

      end;
    end;
  except
  end;
end;

function TFormOLAPArbeitsplatz.quFieldName(eTag: Integer): string;
begin
  result := QuestionaireFields.values[inttostr(eTag)];
end;

function TFormOLAPArbeitsplatz.quTableName(eTag: Integer): string;
begin
  result := nextp(quFieldName(eTag), '.', 0);
end;

function TFormOLAPArbeitsplatz.fullWhere(JoinTables: TStringList): TStringList;
var
  _TagWhere: string;
  _TagTable: string;
  SQLwheres: Integer;
  n: Integer;
begin
  result := TStringList.create;
  SQLwheres := 0;
  for n := 1 to MaxTag do
  begin
    _TagWhere := TagWhere(n);
    if (_TagWhere <> '') then
    begin
      _TagTable := quTableName(n);
      if assigned(JoinTables) then
        if (JoinTables.indexof(_TagTable) = -1) then
          JoinTables.add(_TagTable);
      result.add(_TagWhere);
      inc(SQLwheres);
    end;
  end;
end;

function TFormOLAPArbeitsplatz.quFieldTypeNumeric(eTag: Integer): boolean;
begin
  result := QuestionaireFields.values[inttostr(eTag) + '.TYPE'] = '';
end;

function TFormOLAPArbeitsplatz.quTableHas(TableName, FieldName: string)
  : boolean;
var
  n: Integer;
begin
  result := false;
  for n := 0 to pred(QuestionaireFields.count) do
    if (pos('=' + TableName + '.' + FieldName, QuestionaireFields[n]) > 0) then
    begin
      result := true;
      exit;
    end;
end;

procedure TFormOLAPArbeitsplatz.Edit95Change(Sender: TObject);
begin
  // Den String entsprechend einfärben
  with Sender as TEdit do
    if (text <> '*') then
      Color := clInactiveCaptionText
    else
      Color := clWindow;
end;

function TFormOLAPArbeitsplatz.fmDisplay(const s: string): string;
begin
  if pos('"', s) = 1 then
    result := copy(s, 2, length(s) - 2)
  else
    result := s;
end;

procedure TFormOLAPArbeitsplatz.ToolButton14Click(Sender: TObject);
var
  Abfrage: TStringList;
  SaveFName: string;
begin
  //
  BeginHourGlass;
  Abfrage := quAbfrage;
  if (ComboBox1.text = '') then
    SaveFName := 'Ohne-Name'
  else
    SaveFName := ComboBox1.text;
  ersetze(cOLAPAbfrageExtension, '', SaveFName);

  Abfrage.SaveToFile(AnwenderPath + SaveFName + cOLAPAbfrageExtension);
  Abfrage.free;
  EndHourGlass;
end;

function TFormOLAPArbeitsplatz.quLastFName(Mask: string): string;
var
  n: Integer;
  _FileAge, NewestFileAge: Integer;
  AllProjects: TStringList;
begin
  // rev-Liste erzeugen aus dem Dateisystem
  result := '';
  AllProjects := TStringList.create;
  try
    NewestFileAge := 0;
    AllProjects.clear;
    dir(AnwenderPath + Mask, AllProjects, false);
    for n := 0 to pred(AllProjects.count) do
    begin
      _FileAge := FileAge(AnwenderPath + AllProjects[n]);
      if (_FileAge > NewestFileAge) then
      begin
        NewestFileAge := _FileAge;
        result := AllProjects[n];
      end;
    end;
  except
  end;
  AllProjects.free;
end;

procedure TFormOLAPArbeitsplatz.ToolButton24Click(Sender: TObject);
begin
  openShell(AnwenderPath);
end;

procedure TFormOLAPArbeitsplatz.ToolButton25Click(Sender: TObject);
begin
  run;
end;

procedure TFormOLAPArbeitsplatz.RefreshLoadCombo;
var
  AllTheFiles: TStringList;
begin
  BeginHourGlass;
  AllTheFiles := TStringList.create;
  dir(AnwenderPath + '*' + cOLAPAbfrageExtension, AllTheFiles, false);
  ComboBox1.items.assign(AllTheFiles);
  AllTheFiles.clear;
  EndHourGlass;
end;

function TFormOLAPArbeitsplatz.ColparamAsString(c: Integer;
  const s: string): string;
var
  sSettings: TStringList;
begin
  sSettings := TStringList(ColSettings[c]);
  result := sSettings.values[s];
end;

function TFormOLAPArbeitsplatz.ColparamAsString(const s: string): string;
begin
  result := ColparamAsString(StrToIntDef(nextp(s, '.', 0), 0),
    nextp(s, '.', 1));
end;

procedure TFormOLAPArbeitsplatz.bericht;
var
  xlsAUSGABE: TXLSFIle;
  fmHeader: Integer;
  fmHigh, fmHigh_Date: Integer;
  fmLow, fmLow_Date: Integer;
  fmfm: TFlxFormat;

  // Temp Tabellen!
  MF, RP, REJECT: TList;
  GLOBAL: TList;

  procedure WriteCell(r, c: Integer; s: string; DoFormat: boolean = false);

    function _fm(fLow, fHigh: Int32):Int32;
    begin
      result := -1;
      if DoFormat and (r > 1) then
        with xlsAUSGABE do
        begin
          if (r mod 2 = 0) then
            result :=  fHigh
          else
            result := fLow;
        end;
    end;

  begin
    with xlsAUSGABE do
      repeat

        // Float oder Ganzzahl
        if (pos('-', s) = 1) or (pos('+', s) = 1) then
        begin
          setCellValue(r, c, strtodoubledef(s, 0), _fm(fmLow, fmHigh));
          break;
        end;

        // Datumsformat
        if (pos('.', s) = 3) and (pos(' ', s) = 11) and (pos(':', s) = 14) then
        begin
          setCellValue(r, c, double(mkDateTime(date2long(nextp(s, ' ', 0)),
            strtoseconds(nextp(s, ' ', 1)))), _fm(fmLow_Date, fmHigh_Date));
          break;
        end;

        // Ganzzahl
        if length(s) > 0 then
          if (s[1] >= '0') and (s[1] <= '9') then
            if s = StrFilter(s, '0123456789') then
            begin
              setCellValue(r, c, s, _fm(fmLow, fmHigh));
              break;
            end;

        // als String!
        setCellValue(r, c, s, _fm(fmLow, fmHigh));

      until true;

  end;

  procedure WriteContent(ContentItems: TList; HeaderS: TStringList = nil);
  var
    slRow: TStringList;
    sCell: string;
    c, r: Integer;
    xlsColumnWidth: array of Integer;

    function getCount: Integer;
    begin
      result := ContentItems.count;
      if assigned(HeaderS) then
        inc(result);
    end;

    function getLine(Index: Integer): TStringList;
    begin
      if assigned(HeaderS) then
      begin
        if (Index = 0) then
          result := HeaderS
        else
          result := ContentItems[pred(Index)];
      end
      else
      begin
        result := ContentItems[Index];
      end;
    end;

  begin
    if (getCount > 0) then
      with xlsAUSGABE do
      begin
        if assigned(HeaderS) then
          SetLength(xlsColumnWidth, HeaderS.count)
        else
          SetLength(xlsColumnWidth, TStringList(ContentItems[0]).count);

        for c := 0 to high(xlsColumnWidth) do
          xlsColumnWidth[c] := DefaultColWidth;
        for r := 0 to pred(getCount) do
        begin
          slRow := getLine(r);
          for c := 0 to pred(slRow.count) do
          begin
            sCell := fmDisplay(slRow[c]);
            WriteCell(succ(r), succ(c), sCell, true);
            xlsColumnWidth[c] := max(xlsColumnWidth[c], length(sCell) * 320);
          end;

          // Einfärbung der ganzen Titel-Zeile
          if r = 0 then
          begin
            // imp pend FlexCel: RowFormat
            // RowFormat[succ(r)] := fmHeader;
          end;

        end;

        // Spaltenbreite anpassen!
        for c := 0 to high(xlsColumnWidth) do
          setColWidth(succ(c), xlsColumnWidth[c]);
      end;

  end;


//
// Reines wertmäsiges befüllen
//

  procedure CloneContent(CopyColumn: TStringList);
  var
    n: Integer;
    CommandLine: string;
    SheetNumber: string;
    TableName: string;
    ColName: string;
    r, c: Integer;
    mapTable: TList;
    SourceCol, SourceRow, SourceStart: Integer;
    StartTime: dword;
  begin
    StartTime := 0;
    ProgressBar1.max := CopyColumn.count;
    for n := 0 to pred(CopyColumn.count) do
    begin

      //
      CommandLine := CopyColumn[n];

      // Parsen
      SheetNumber := nextp(CommandLine, ',');
      TableName := nextp(CommandLine, '#');
      ColName := nextp(CommandLine, ',');
      r := StrToIntDef(nextp(CommandLine, ','), 0);
      c := StrToIntDef(nextp(CommandLine, ','), 0);
      if (r = 0) then
        break;
      if (c = 0) then
        break;

      mapTable := nil;
      SourceStart := 1;
      SourceCol := -1;
      repeat

        // Mappe raussuchen!
        if (TableName = 'PE') then
        begin
          mapTable := ContentItems;
          SourceStart := 0;
          SourceCol := ContentHeaders.indexof(ColName);
          break;
        end;

        if (TableName = 'MF') then
        begin
          mapTable := MF;
          SourceCol := TStringList(mapTable[0]).indexof(ColName);
          break;
        end;

        if (TableName = 'RP') then
        begin
          mapTable := RP;
          SourceCol := TStringList(mapTable[0]).indexof(ColName);
          break;
        end;

      until true;

      repeat

        // keine Tabelle?
        if (mapTable = nil) then
        begin
          WriteCell(r + 1, c, 'Mappe ' + TableName + ' nicht gefunden!');
          break;
        end;

        // keine Spalte?
        if (SourceCol = -1) then
        begin
          WriteCell(r + 1, c, 'Spaltenüberschrift ' + ColName +
            ' nicht gefunden!');
          break;
        end;

        // Jetzt die ganze Tabelle kopieren - ohne Formate!
        with xlsAUSGABE do
        begin
          ActiveSheet := StrToIntDef(SheetNumber, 1);
          for SourceRow := SourceStart to pred(mapTable.count) do
          begin
            WriteCell(r + (SourceRow - SourceStart), c,
              fmDisplay(TStringList(mapTable[SourceRow])[SourceCol]));
            setCellFormat(r + (SourceRow - SourceStart), c,
              getCellFormat(r + 1, c));
          end;
        end;

      until true;

      if frequently(StartTime, 333) then
      begin
        ProgressBar1.position := n;
        application.processmessages;
      end;

    end;
    ProgressBar1.position := 0;
  end;

var
  s: Integer; // Mappen-Zähler
  c, c2, r: Integer; // Spalten, Zeilen Zähler
  countMAIN: Integer; // Anzahl der Hauptmappen (links)
  ContentSubs: TStringList; //
  MFSubs: TStringList;
  SearchD: double;
  SearchStr: string;

  DynamicFirstRow: Integer;
  GlobalSubs: TStringList;
  AusfallSubs: TStringList;
  Ausfall: Integer;

  // ganze Spalten kopieren
  CopyColumn: TStringList;
  n: Integer;
  FormatLists: TStringList;

begin

  if FileDelete(AnwenderPath + 'out.xls') then
  begin

    BeginHourGlass;
    Content_complete;

    //
    Content_plausibel;

    xlsAUSGABE := TXLSFIle.create(true);
    CopyColumn := TStringList.create;
    with xlsAUSGABE do
    begin

      //
      if FileExists(AnwenderPath + ComboBox2.text) then
      begin
        Open(AnwenderPath + ComboBox2.text);

        ActiveSheet := 1;

(*
        Format Diagnostik

        FormatLists := TStringList.create;
        for n := 0 to pred(FormatCount) do
        begin
          fmfm := GetFormat(n);
          FormatLists.add(format('%d=%s;%d', [
            { } n,
            { } fmfm.format,
            { } fmfm.FillPattern.FgColor.Index]));
        end;
        FormatLists.add(inttostr(getCellFormat(4, 2)));
        FormatLists.SaveToFile(AnwenderPath + 'Excel.Formats.txt');
        FormatLists.free;
        open(UserDir + 'Excel.Formats.txt');
*)

        countMAIN := SheetCount - 4;
      end
      else
      begin
        NewFile(5);
        countMAIN := 1;
        ActiveSheet := 1;
        SheetName := 'MAIN';
      end;

      // procedure ClearSheet;virtual;abstract;

      //
      ActiveSheet := countMAIN + 1;
      SheetName := 'IN';
      ClearSheet;

      ActiveSheet := countMAIN + 2;
      SheetName := 'PE';
      ClearSheet;

      ActiveSheet := countMAIN + 3;
      SheetName := 'MF';
      ClearSheet;

      ActiveSheet := countMAIN + 4;
      SheetName := 'RP';
      ClearSheet;

      // Die 2 Formate machen
      fmfm := GetDefaultFormat;

      // fmfm.format := 'Standard';
      // fmfm.HAlignment := fha_right;
      fmfm.borders.left.style := TFlxBorderStyle.Thin;
      fmfm.borders.left.Color := clblack;
      fmfm.FillPattern.Pattern := TFlxPatternStyle.Solid; // solid fill
      fmfm.FillPattern.BgColor := clblack;

      // Header Format (hellgelb)
      fmfm.FillPattern.FgColor := HTMLColor2TColor($FFFF99);
      fmHeader := addFormat(fmfm);

      // Normale Zellen (hellblau,weiss)
      fmfm.FillPattern.FgColor := HTMLColor2TColor($88EEFF);
      fmHigh := addFormat(fmfm);
      fmfm.FillPattern.FgColor := clWhite;
      fmLow := addFormat(fmfm);

      // Datums Zelle (hellblau,weiss)
      fmfm.FillPattern.FgColor := HTMLColor2TColor($88EEFF);
      fmfm.format := 'dd/mm/yyyy\ hh:mm:ss';
      fmHigh_Date := addFormat(fmfm);
      fmfm.FillPattern.FgColor := clWhite;
      fmLow_Date := addFormat(fmfm);

      // Messergebnisse
      ActiveSheet := countMAIN + 2; // PE!
      WriteContent(ContentItems, ContentHeaders);

      // Ausfälle
      REJECT := TList.create;
      Tmp_load(REJECT, AnwenderPath + cQuestionaireRejectFName);

      GLOBAL := TList.create;

      GlobalSubs := TStringList.create;
      GlobalSubs.add('PARAMETER'); // [0]
      GLOBAL.add(GlobalSubs);

      GlobalSubs := TStringList.create;
      GlobalSubs.add('Ausfall 1-4'); // [1]
      GLOBAL.add(GlobalSubs);

      GlobalSubs := TStringList.create;
      GlobalSubs.add('Ausfall 5'); // [2]
      GLOBAL.add(GlobalSubs);

      GlobalSubs := TStringList.create;
      GlobalSubs.add('Ausfall 6'); // [3]
      GLOBAL.add(GlobalSubs);

      GlobalSubs := TStringList.create;
      GlobalSubs.add('Ausfall 7'); // [4]
      GLOBAL.add(GlobalSubs);

      GlobalSubs := TStringList.create;
      GlobalSubs.add('Ausfall 8'); // [5]
      GLOBAL.add(GlobalSubs);

      GlobalSubs := TStringList.create;
      GlobalSubs.add('Ausfall 9'); // [6]
      GLOBAL.add(GlobalSubs);

      GlobalSubs := TStringList.create;
      GlobalSubs.add('Ausfall 10'); // [7]
      GLOBAL.add(GlobalSubs);

      GlobalSubs := TStringList.create;
      GlobalSubs.add('Ausfall 11'); // [8]
      GLOBAL.add(GlobalSubs);

      GlobalSubs := TStringList.create;
      GlobalSubs.add('Ausfall 12'); // [9]
      GLOBAL.add(GlobalSubs);

      GlobalSubs := TStringList.create;
      GlobalSubs.add('Ausfall sonstige'); // [10]
      GLOBAL.add(GlobalSubs);

      GlobalSubs := TStringList.create;
      GlobalSubs.add('Ausfall Summe'); // [11]
      GLOBAL.add(GlobalSubs);

      GlobalSubs := TStringList.create;
      GlobalSubs.add('MF Summe'); // [12]
      GLOBAL.add(GlobalSubs);

      GlobalSubs := TStringList.create;
      GlobalSubs.add('MF+'); // [13]
      GLOBAL.add(GlobalSubs);

      GlobalSubs := TStringList.create;
      GlobalSubs.add('MF-'); // [14]
      GLOBAL.add(GlobalSubs);

      GlobalSubs := TStringList.create;
      GlobalSubs.add('Questionaire'); // [15]
      GLOBAL.add(GlobalSubs);

      // Jetzt kommt der Variable teil!
      DynamicFirstRow := GLOBAL.count;
      for c := 0 to pred(ContentHeaders.count) do
      begin
        GlobalSubs := TStringList.create;
        GlobalSubs.add(ContentHeaders[c]);
        GLOBAL.add(GlobalSubs);
      end;

      // Jetzt die 2. Spalte befüllen (mit leeren werten!)
      for r := 0 to pred(GLOBAL.count) do
      begin
        GlobalSubs := TStringList(GLOBAL[r]);
        if (r = 0) then
          GlobalSubs.add('WERT')
        else
          GlobalSubs.add('');
      end;

      for r := 1 to pred(REJECT.count) do
      begin
        GlobalSubs := TStringList(REJECT[r]);
        Ausfall := StrToIntDef(GlobalSubs[1], 0); // Ausfallgrund!
        case Ausfall of
          1 .. 4:
            AusfallSubs := TStringList(GLOBAL[1]);
          5 .. 12:
            AusfallSubs := TStringList(GLOBAL[Ausfall - 3]);
        else
          // alle Sonstigen!
          AusfallSubs := TStringList(GLOBAL[10]);
        end;
        AusfallSubs[1] := '+' + inttostr(StrToIntDef(AusfallSubs[1], 0) + 1);
      end;

      // Summe der Ausfälle
      AusfallSubs := TStringList(GLOBAL[11]);
      AusfallSubs[1] := '+' + inttostr(pred(REJECT.count));

      // Summe der MF
      AusfallSubs := TStringList(GLOBAL[12]);
      AusfallSubs[1] := '+' + inttostr(ContentItems.count);

      Tmp_delete(REJECT);
      REJECT.free;

      // Messfehler
      MF := TList.create;
      Tmp_load(MF, iOlapPath + 'External.MF.txt');

      // Fehlende Spalte erweitern
      for c := 0 to pred(MF.count) do
      begin
        ContentSubs := TStringList(MF[c]);
        if (c = 0) then
          ContentSubs.add('GUT')
        else
          ContentSubs.add('+0');
      end;

      // Werte hinzuaddieren
      for c := 0 to pred(ContentItems.count) do
      begin
        ContentSubs := TStringList(ContentItems[c]);
        SearchD := round(

          (strtodoubledef(ContentSubs[col_Q02max], 0) -
          strtodoubledef(ContentSubs[col_Qmax], 0))

          * 10) / 10;
        if (SearchD < 0) then
          TStringList(GLOBAL[14])[1] := '+' +
            inttostr(StrToIntDef(TStringList(GLOBAL[14])[1], 0) + 1)
        else
          TStringList(GLOBAL[13])[1] := '+' +
            inttostr(StrToIntDef(TStringList(GLOBAL[13])[1], 0) + 1);
        for c2 := 1 to pred(MF.count) do
        begin
          MFSubs := TStringList(MF[c2]);
          if (strtodoubledef(MFSubs[0], 0) = SearchD) then
            MFSubs[1] := '+' + inttostr(StrToIntDef(MFSubs[1], 0) + 1);
        end;
      end;

      // Aufzählungsliste dazu
      for r := 0 to pred(ContentHeaders.count) do
      begin
        GlobalSubs := TStringList(GLOBAL[r + DynamicFirstRow]);
        GlobalSubs[1] := ' ' + Tmp_Aufzaehlung(ContentItems, r, false);
      end;

      // Selektions-String dazu
      RefreshQuestionaireInfo;
      GlobalSubs := TStringList(GLOBAL[15]);
      GlobalSubs[1] := Memo1.lines[0];

      ActiveSheet := countMAIN + 3;
      WriteContent(MF);

      // imp pend: rausschreiben ganzer Datenreihen.

      // Radpaar
      RP := TList.create;
      Tmp_load(RP, iOlapPath + 'External.Gears.txt');

      // Fehlende Spalte erweitern
      for c := 0 to pred(RP.count) do
      begin
        ContentSubs := TStringList(RP[c]);
        if (c = 0) then
          ContentSubs.add('ANZ')
        else
          ContentSubs.add('+0');
      end;

      for c := 0 to pred(ContentItems.count) do
      begin
        ContentSubs := TStringList(ContentItems[c]);
        SearchStr := ContentSubs[col_Radpaar];
        for c2 := 1 to pred(RP.count) do
        begin
          MFSubs := TStringList(RP[c2]);
          if (MFSubs[0] = SearchStr) then
            MFSubs[2] := '+' + inttostr(StrToIntDef(MFSubs[2], 0) + 1);
        end;
      end;

      ActiveSheet := countMAIN + 4; // RP!
      WriteContent(RP);

      ActiveSheet := countMAIN + 1; // IN!
      WriteContent(GLOBAL);

      // eventuell noch Spalten vorkopieren
      // Hier nur die Aufgaben sammeln
      for s := 1 to countMAIN do
      begin

        //
        ActiveSheet := s;

        //
        for r := 1 to 80 do
          for c := 1 to 30 do
          begin
            if (pos('#', getCellValue(r, c).ToStringInvariant) = 3) then
              CopyColumn.add(
              {} inttostr(s) + ',' +
              {} getCellValue(r, c).ToStringInvariant + ',' +
               {} inttostr(r) + ',' +
               {} inttostr(c));
          end;

      end;

      // Jetzt die Arbeit machen (lassen)
      CloneContent(CopyColumn);

      // Objekte freigeben
      Tmp_delete(MF);
      MF.free;
      Tmp_delete(RP);
      RP.free;
      Tmp_delete(GLOBAL);
      GLOBAL.free;
      if not(UserBreak) then
      begin
        Save(AnwenderPath + 'out.xls');
        MakePDF(AnwenderPath + 'out.xls', AnwenderPath + 'out.pdf');
      end;
    end;
    xlsAUSGABE.free;
    CopyColumn.free;
    EndHourGlass;
    if not(UserBreak) then
      if AllowOpen then
        openShell(AnwenderPath + 'out.xls');
  end
  else
  begin
    ShowMessage('Ausgabe XLS ist noch offen!');
  end;
  UserBreak := false;
end;

function TFormOLAPArbeitsplatz.ColparamAsInteger(c: Integer;
  const s: string): Integer;
var
  sSettings: TStringList;
begin
  sSettings := TStringList(ColSettings[c]);
  result := StrToIntDef(sSettings.values[s], -1);
end;

function TFormOLAPArbeitsplatz.ColparamAsInteger(const s: string): Integer;
begin
  result := ColparamAsInteger(StrToIntDef(nextp(s, '.', 0), 0),
    nextp(s, '.', 1));
end;

procedure TFormOLAPArbeitsplatz.ComboBox1Select(Sender: TObject);
begin
  // load
  quLoad(ComboBox1.text);
end;

procedure TFormOLAPArbeitsplatz.ToolButton19Click(Sender: TObject);
var
  n: Integer;
  SettingsS: TStringList;
begin
  SettingsS := TStringList.create;
  for n := 1 to MaxTag do
    SettingsS.add(inttostr(n) + '=*');
  ComboBox1.text := 'Neu_' + Datum + cOLAPAbfrageExtension;
  quLoad(SettingsS);
  SettingsS.free;
end;

procedure TFormOLAPArbeitsplatz.ToolButton20Click(Sender: TObject);
var
  LastParameterFName: string;
begin
  if doit(ComboBox1.text + ' wirklich löschen?') then
  begin
    FileDelete(AnwenderPath + ComboBox1.text);
    RefreshLoadCombo;
    ComboBox1.text := '';
    LastParameterFName := quLastFName('*' + cOLAPAbfrageExtension);
    if (LastParameterFName <> '') then
      quLoad(LastParameterFName);
  end;
end;

procedure TFormOLAPArbeitsplatz.ToolButton21Click(Sender: TObject);
begin
  readHelium;
end;

procedure TFormOLAPArbeitsplatz.ToolButton22Click(Sender: TObject);
var
  LastParameterFName: string;
begin
  if FileExists(AnwenderPath + ComboBox1.text) then
  begin
    FileCopy(AnwenderPath + ComboBox1.text, AnwenderPath + 'Kopie_' + Datum +
      cOLAPAbfrageExtension);
    FileTouch(AnwenderPath + 'Kopie_' + Datum + cOLAPAbfrageExtension);
    RefreshLoadCombo;
    LastParameterFName := quLastFName('*' + cOLAPAbfrageExtension);
    if (LastParameterFName <> '') then
      quLoad(LastParameterFName);
  end
  else
  begin
    ShowMessage('Fehler' + #13 + 'Datei ' + AnwenderPath + ComboBox1.text + #13
      + 'nicht gefunden!');
  end;
end;

procedure TFormOLAPArbeitsplatz.SpeedButton3Click(Sender: TObject);
begin
  RefreshLoadCombo;
end;

function TFormOLAPArbeitsplatz.fullQuest(fromTable: string): TStringList;
var
  SelfJoinIndex: Integer;
  n, m: Integer;
  ExtraWhere: TStringList;
  JoinTables: TStringList;
  SQLconditions: Integer;
begin

  //
  JoinTables := TStringList.create;
  result := TStringList.create;

  result.add('select distinct');
  result.add('  ' + fromTable + '.EQUIPMENTID');
  result.add(' ,' + fromTable + '.CALIBRATIONID');
  result.add(' ,METERS.SERIALNUMBER');
  result.add('from');
  result.add(' ' + fromTable);

  ExtraWhere := fullWhere(JoinTables);
  if (ExtraWhere.count > 0) then
    ersetze(' and (', '     (', ExtraWhere, 0);

  //
  // J O I N
  //

  // join auf eigene "from" Tabelle verhindern
  SelfJoinIndex := JoinTables.indexof(fromTable);
  if (SelfJoinIndex <> -1) then
    JoinTables.delete(SelfJoinIndex);

  // Meters jedoch immer sicherstellen!
  if (fromTable <> 'METERS') then
    if (JoinTables.indexof('METERS') = -1) then
      JoinTables.add('METERS');

  // join auf die restlichen, verbleibenden Tabellen verbinden
  if (JoinTables.count > 0) then
  begin
    for n := 0 to pred(JoinTables.count) do
    begin
      result.add('inner join');
      result.add(' ' + JoinTables[n]);
      result.add('on');
      SQLconditions := 0;
      for m := 0 to pred(JoinFields.count) do
        if quTableHas(fromTable, JoinFields[m]) and
          quTableHas(JoinTables[n], JoinFields[m]) then
          result.add(' ' + SQL_and(SQLconditions) + '(' + fromTable + '.' +
            JoinFields[m] + '=' + JoinTables[n] + '.' + JoinFields[m] + ')');
    end;

  end;

  // W H E R E
  result.add('where');

  // Hier die Wheres
  result.addstrings(ExtraWhere);

  // S O R T
  result.add('order by');
  result.add(' METERS.SERIALNUMBER');

  ExtraWhere.free;
  JoinTables.free;
end;

function TFormOLAPArbeitsplatz.fullReject(fromTable: string): TStringList;
var
  SelfJoinIndex: Integer;
  n, m: Integer;
  ExtraWhere: TStringList;
  JoinTables: TStringList;
  SQLconditions: Integer;
begin

  //
  JoinTables := TStringList.create;
  result := TStringList.create;

  result.add('select distinct');
  result.add(' rejections.equipmentid,');
  result.add(' rejections.rejectionid,');
  result.add(' rejections.calibrationid,');
  result.add(' rejections.PositionNumber');
  result.add('from');
  result.add(' ' + fromTable);

  ExtraWhere := fullWhere(JoinTables);
  if (ExtraWhere.count > 0) then
    ersetze(' and (', '     (', ExtraWhere, 0);

  //
  // J O I N
  //
  SelfJoinIndex := JoinTables.indexof(fromTable);
  if (SelfJoinIndex <> -1) then
    JoinTables.delete(SelfJoinIndex);

  // Rejections muss aber dabei sein!
  if (JoinTables.indexof('REJECTIONS') = -1) then
    JoinTables.add('REJECTIONS');

  if (JoinTables.count > 0) then
  begin
    for n := 0 to pred(JoinTables.count) do
    begin
      result.add('inner join');
      result.add(' ' + JoinTables[n]);
      result.add('on');
      SQLconditions := 0;
      for m := 0 to pred(JoinFields.count) do
        if quTableHas(fromTable, JoinFields[m]) and
          quTableHas(JoinTables[n], JoinFields[m]) then
          result.add(' ' + SQL_and(SQLconditions) + '(' + fromTable + '.' +
            JoinFields[m] + '=' + JoinTables[n] + '.' + JoinFields[m] + ')');
    end;

  end;

  // W H E R E
  result.add('where');

  // Hier die Wheres
  result.addstrings(ExtraWhere);

  ExtraWhere.free;
  JoinTables.free;
end;

procedure TFormOLAPArbeitsplatz.quFillGrid;
begin
  //
  StaticText4.Caption := 'Serial #' + #13 + 'Anz: ' +
    inttostr(pred(ContentItems.count));

  // application.processmessage
  if assigned(ContentHeaders) then
    FreeAndNil(ContentHeaders);
  ContentHeaders := TStringList(ContentItems[0]);
  ContentItems.delete(0);

  with DrawGrid1 do
  begin
    inc(SupressGridPaint);
    rowCount := ContentItems.count;
    row := pred(rowCount);
    dec(SupressGridPaint);
    refresh;
  end;

end;

procedure TFormOLAPArbeitsplatz.ToolButton27Click(Sender: TObject);
begin
  openShell(AnwenderPath + cQuestionaireVolumeFName);
end;

procedure TFormOLAPArbeitsplatz.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    ord('m'), ord('M'), ord(' '):
      if DrawGrid1.focused then
      begin
        if ssCtrl in Shift then
        begin
          // suche nächsten Markierten
          // FindNextMarked;
        end
        else
        begin
          Key := 0;
          Mark;
        end;
      end;
  end;
end;

procedure TFormOLAPArbeitsplatz.Mark;
var
  FoundIndex: Integer;
begin
  if (ContentItems.count > 0) then
  begin
    FoundIndex := ItemMarked.indexof(DrawGrid1.row);
    if (FoundIndex = -1) then
    begin
      ItemMarked.add(DrawGrid1.row);
    end
    else
      ItemMarked.delete(FoundIndex);
    // RefreshCountAnzeige;

    // redraw one line;
    if (DrawGrid1.row < pred(DrawGrid1.rowCount)) then
      DrawGrid1.row := DrawGrid1.row + 1
    else
      DrawGrid1.refresh;
  end;
end;

procedure TFormOLAPArbeitsplatz.ToolButton7Click(Sender: TObject);
var
  n: Integer;
begin
  BeginHourGlass;
  if (ItemMarked.count = 0) then
  begin
    for n := 0 to pred(ContentItems.count) do
      ItemMarked.add(n);
  end
  else
  begin
    ItemMarked.clear;
  end;
  DrawGrid1.refresh;
  EndHourGlass;
end;

procedure TFormOLAPArbeitsplatz.ToolButton9Click(Sender: TObject);
var
  _ItemMarked: TgpIntegerList;
  n: Integer;
begin
  // invert marked list
  BeginHourGlass;
  _ItemMarked := TgpIntegerList.create;
  for n := 0 to pred(ContentItems.count) do
    if (ItemMarked.indexof(n) = -1) then
      _ItemMarked.add(n);
  FreeAndNil(ItemMarked);
  ItemMarked := _ItemMarked;
  DrawGrid1.refresh;
  EndHourGlass;
end;

procedure TFormOLAPArbeitsplatz.writeGestern;
var
  sGestern: string;
begin
  try
    BeginHourGlass;

    // Auswahl "gestern" laden
    quLoad('gestern.OLAP-Parameter.txt');

    // richtige XLS Vorlage anwählen
    ComboBox2.text := 'Tagesbericht.xls';

    // Starten
    run;

    FileDelete(AnwenderPath + 'out.pdf');

    // XLS Funktion auslösen
    bericht(false);

    // XLS-Ergebnis in die Ablage verschieben
    if FileExists(AnwenderPath + 'out.pdf') then
    begin
      sGestern := long2date(DatePlus(DateGet, -1));
      CheckCreateDir(iAuftragsAblagePath + 'Tagesberichte\');
      FileCopy(AnwenderPath + 'out.pdf', iAuftragsAblagePath + 'Tagesberichte\'
        + copy(sGestern, 8, 4) + '-' + copy(sGestern, 4, 2) + '-' +
        copy(sGestern, 1, 2) + '.pdf');
    end;

    EndHourGlass;

  except

  end;

end;

procedure TFormOLAPArbeitsplatz.ToolButton10Click(Sender: TObject);
begin
  ShowMessage('Dies vermindert das Ergebnisvolumen.' + #13 +
    'Diese Funktion ist für Auswertungen sehr kritisch und wurde deaktiviert!');
end;

procedure TFormOLAPArbeitsplatz.ToolButton5Click(Sender: TObject);
begin
  ItemMarked.clear;
  DrawGrid1.refresh;
end;

procedure TFormOLAPArbeitsplatz.ToolButton6Click(Sender: TObject);
begin
  bericht;
end;

procedure TFormOLAPArbeitsplatz.Content_complete;
var
  r, c: Integer;
  Subs: TStringList;
  StartTime: dword;
begin
  //
  // sicherstellen, dass alle Spalten nun gefüllt sind!
  //
  BeginHourGlass;
  try
    ProgressBar1.max := ContentItems.count;
    for r := 0 to pred(ContentItems.count) do
    begin
      Subs := TStringList(ContentItems[r]);
      Content_prepare(Subs);
      if not(UserBreak) then
        for c := col_FirstCalculated to col_last do
          if (Subs[c] = cOLAPNull) then
            Subs[c] := Content_CellText(r, c);
      if frequently(StartTime, 666) then
      begin
        application.processmessages;
        ProgressBar1.position := r;
      end;
    end;
  except
  end;
  ProgressBar1.position := 0;
  EndHourGlass;
end;

procedure TFormOLAPArbeitsplatz.ToolButton29Click(Sender: TObject);

const
  cWienGasSeperator = ',';

var
  wiengas: TStringList;
  Subs: TStringList;
  r: Integer;

  function WienGasSerial(s: string): string;
  begin
    result := fill('0', 8 - length(s)) + s;
  end;

  function WienGasNumeric(s: string): string;
  begin
    result := s;
    ersetze(',', '.', result);
  end;

  function WienGasDatum(s: string): string;
  begin
    result := nextp(s, ' ', 0);
  end;

begin
  // Speichere im wiengas Format
  BeginHourGlass;
  Content_complete;
  wiengas := TStringList.create;
  for r := 0 to pred(ContentItems.count) do
  begin
    Subs := TStringList(ContentItems[r]);
    wiengas.add(WienGasSerial(Subs[col_FirstFrei + 1]) + cWienGasSeperator + 'B'
      + cWienGasSeperator + WienGasDatum(Subs[col_Moment]) + cWienGasSeperator +
      WienGasNumeric(Subs[col_Qmin]) + cWienGasSeperator +
      WienGasNumeric(Subs[col_Q02max]) + cWienGasSeperator +
      WienGasNumeric(Subs[col_Qmax]) + cWienGasSeperator +
      WienGasNumeric(Subs[col_Dmin]) + cWienGasSeperator +
      WienGasNumeric(Subs[col_D02max]) + cWienGasSeperator +
      WienGasNumeric(Subs[col_Dmax]));
  end;
  wiengas.SaveToFile(AnwenderPath + 'wiengas.txt');
  wiengas.free;
  EndHourGlass;
  openShell(AnwenderPath + 'wiengas.txt');
end;

procedure TFormOLAPArbeitsplatz.Content_prepare(Subs: TStringList);
var
  n: Integer;
begin
  if (Subs.count <= col_last) then
    for n := Subs.count to col_last do
      Subs.add(cOLAPNull);
end;

procedure TFormOLAPArbeitsplatz.ToolButton16Click(Sender: TObject);
var
  Subs: TStringList;
begin
  ShowMessage('Im Moment gesperrt!');
  exit;
  if (ContentItems.count > 0) then
  begin
    Subs := TStringList(ContentItems[DrawGrid1.row]);
    FormOLAPedit.SetContext(Subs[col_Equipment], Subs[col_Calibration],
      Subs[col_Serial]);
  end;
end;

function TFormOLAPArbeitsplatz.Tmp_Aufzaehlung(tTable: TList; col: Integer;
  HasHeader: boolean = true): string;
var
  Subs: TStringList;
  DistinctItems: TStringList;
  r: Integer;
  StartR: Integer;

  // für numerische Werte
  NumericMode: boolean;
  maxEl_s, minEl_s: string;
  maxEl, minEl: double;
  AsNum: double;
begin
  DistinctItems := TStringList.create;

  if HasHeader then
    StartR := 1
  else
    StartR := 0;

  maxEl_s := cOLAPNull;
  minEl_s := cOLAPNull;
  maxEl := MinDouble;
  minEl := MAxDouble;

  if tTable.count > StartR then
    NumericMode := (pos('+', TStringList(tTable[StartR])[col]) = 1) or
      (pos('-', TStringList(tTable[StartR])[col]) = 1)
  else
    NumericMode := false;

  for r := StartR to pred(tTable.count) do
  begin
    Subs := TStringList(tTable[r]);
    if (Subs[col] <> cOLAPNull) then
    begin
      if NumericMode then
      begin

        AsNum := strtodoubledef(Subs[col], 0);
        if (AsNum > maxEl) then
        begin
          maxEl_s := Subs[col];
          maxEl := AsNum;
        end;

        if (AsNum < minEl) then
        begin
          minEl_s := Subs[col];
          minEl := AsNum;
        end;

      end
      else
      begin
        DistinctItems.add(fmDisplay(Subs[col]));
      end;
    end;
  end;
  if NumericMode then
  begin
    result := minEl_s + ' .. ' + maxEl_s;
  end
  else
  begin
    DistinctItems.sort;
    RemoveDuplicates(DistinctItems);
    case DistinctItems.count of
      0:
        result := '(0)';
      1:
        result := DistinctItems[0];
      2:
        result := DistinctItems[0] + ', ' + DistinctItems[1] + ' (2)';
      3:
        result := DistinctItems[0] + ', ' + DistinctItems[1] + ', ' +
          DistinctItems[2] + ', ' + ' (3)';
    else
      result := DistinctItems[0] + ' .. ' + DistinctItems
        [pred(DistinctItems.count)] + ' (' +
        inttostr(DistinctItems.count) + ')';
    end;
  end;
  DistinctItems.free;
end;

procedure TFormOLAPArbeitsplatz.ToolButton26Click(Sender: TObject);
var
  r: Integer;
  SerialNo: TgpIntegerList;
  LastSerial: Integer;
  ReportFehlende: TStringList;
  ReportDoppelte: TStringList;
  Report: TStringList;
  NextToCome: Integer;
begin

  // Erstellen der Liste mit fehlenden Serial-Nummern!
  if (ContentItems.count > 2) then
  begin

    //
    Report := TStringList.create;
    ReportFehlende := TStringList.create;
    ReportDoppelte := TStringList.create;
    SerialNo := TgpIntegerList.create;
    for r := 0 to pred(ContentItems.count) do
      SerialNo.add(StrToIntDef(TStringList(ContentItems[r])[col_Serial], 0));
    SerialNo.sort;

    // erst mal Doppelte
    LastSerial := MaxInt;
    for r := 0 to pred(SerialNo.count) do
    begin
      if (SerialNo[r] = LastSerial) then
        ReportDoppelte.add(inttostr(SerialNo[r]));
      LastSerial := SerialNo[r];
    end;

    // nun die Folge sicherstellen!
    NextToCome := SerialNo[0] + 1;
    for r := 1 to pred(SerialNo.count) do
    begin
      if (NextToCome <> SerialNo[r]) then
      begin
        ReportFehlende.add(inttostr(NextToCome));
        NextToCome := SerialNo[r] + 1;
      end
      else
      begin
        inc(NextToCome);
      end;
    end;

    //
  end;

  Report.add('-- Doppelte: ' + inttostr(ReportDoppelte.count));
  Report.add('');
  Report.addstrings(ReportDoppelte);

  Report.add('-- Fehlende: ' + inttostr(ReportFehlende.count));
  Report.add('');
  Report.addstrings(ReportFehlende);

  Report.SaveToFile(AnwenderPath + 'Report.Doppelte.Fehlende.txt');

  ReportFehlende.free;
  ReportDoppelte.free;
  Report.free;
  EndHourGlass;

  openShell(AnwenderPath + 'Report.Doppelte.Fehlende.txt');

end;

procedure TFormOLAPArbeitsplatz.ToolButton35Click(Sender: TObject);
begin
  Content_plausibel;
end;

procedure TFormOLAPArbeitsplatz.Content_plausibel;
var
  n: Integer;
  Subs: TStringList;
begin
  BeginHourGlass;
  Content_complete;
  ItemMarked.clear;
  for n := 0 to pred(ContentItems.count) do
  begin
    Subs := TStringList(ContentItems[n]);
    if (Subs[col_AnzahlMesspunkte] <> '3') then
      if (Subs[col_AnzahlMesspunkte] <> '4') then
        ItemMarked.add(n);
  end;
  DrawGrid1.refresh;
  EndHourGlass;
  if not(UserBreak) then
    if (ItemMarked.count > 0) then
      ShowMessage('Es gibt unplausible!');
end;

procedure TFormOLAPArbeitsplatz.TabSheet5Show(Sender: TObject);
begin
  RefreshQuestionaireInfo;
end;

procedure TFormOLAPArbeitsplatz.RefreshQuestionaireInfo;
var
  n: Integer;
  MyText: string;
  s: string;
  OneHit: boolean;
  FieldName, FieldRealName: string;
begin
  BeginHourGlass;

  Memo1.lines.clear;
  if (ComboBox3.text <> '') then
  begin
    s := 'DB=' + ComboBox3.text;
    OneHit := true;
  end
  else
  begin
    s := '';
    OneHit := false;
  end;

  for n := 1 to MaxTag do
  begin
    MyText := TagEdit(n).text;
    if (MyText <> '*') then
    begin
      if OneHit then
        s := s + ' & ';

      FieldName := TagLabel(n).Caption;
      FieldRealName := nextp(QuestionaireFields.values[inttostr(n)], '.', 1);
      if (FieldName <> FieldRealName) then
        FieldName := FieldName + '(' + FieldRealName + ')';
      ersetze('&', '', FieldName);

      s := s + FieldName + '=' + MyText;
      OneHit := true;
    end;
  end;
  Memo1.lines.add(s);
  EndHourGlass;
end;

procedure TFormOLAPArbeitsplatz.SpeedButton1Click(Sender: TObject);
begin
  RefreshQuestionaireInfo;
end;

procedure TFormOLAPArbeitsplatz.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if bErlaubnis('OLAP Arbeitsplatz Autostart') then
    FormMain.close;
end;

procedure TFormOLAPArbeitsplatz.FormCreate(Sender: TObject);
begin
  with ToolBar1 do
  begin
    ButtonHeight := height - 2;
    ButtonWidth := dpiX(23);
  end;
end;

function TFormOLAPArbeitsplatz.quFieldTypeDateTime(eTag: Integer): boolean;
begin
  // Noch keine Anwendung, da kodierung als String OK ist
end;

procedure TFormOLAPArbeitsplatz.RefreshXLSCombo;
var
  FilesL: TStringList;
begin
  //
  FilesL := TStringList.create;
  dir(AnwenderPath + '*.xls', FilesL, false);
  FilesL.sort;
  FilesL.insert(0, '- ohne -');
  ComboBox2.items.assign(FilesL);
  FilesL.free;
end;

procedure TFormOLAPArbeitsplatz.run;
var
  ActInputFieldTag: Integer;
  sql: TStringList;
  fromTable: string;
begin
  BeginHourGlass;
  UserBreak := false;
  try
    //
    ActInputFieldTag := FocusTag;
    if (ActInputFieldTag > 0) then
      fromTable := nextp(quFieldName(ActInputFieldTag), '.', 0)
    else
      fromTable := 'METERS';

    //
    sql := fullQuest(fromTable);
    ExportTable(sql, AnwenderPath + cQuestionaireVolumeFName);
    sql.free;

    //
    sql := fullReject(fromTable);
    ExportTable(sql, AnwenderPath + cQuestionaireRejectFName);
    sql.free;

    // Ergebnis anzeigen!
    Content_load(AnwenderPath + cQuestionaireVolumeFName);

    quFillGrid;

  except
  end;
  EndHourGlass;
end;

procedure TFormOLAPArbeitsplatz.dir(const Mask: string; FileNames: TStrings;
  uppercase: boolean);
var
  n, j: Integer;
begin
  anfix32.dir(Mask, FileNames, uppercase);
  for n := 0 to pred(BlackList.count) do
  begin
    j := FileNames.indexof(BlackList[n]);
    if (j <> -1) then
      FileNames.delete(j);
  end;
end;

procedure TFormOLAPArbeitsplatz.readHelium;
const
  s_csv_FormatRevision = 0;
  s_csv_Datum = 1;
  s_csv_Uhrzeit = 2;
  s_csv_Zaehlertyp = 3;
  s_csv_Pruefwerkzeug = 4;
  s_csv_Membranhersteller = 5;
  s_csv_Chargennummer = 6;
  s_csv_fortlNummer = 7;
  s_csv_Station_Pruefkammer = 8;
  s_csv_Kammer_Glocke = 9;
  s_csv_Messwert = 10;
  s_csv_Grenzwert = 11;
  s_csv_Pruefergebnis = 12;
  s_csv_Separator = ';';
  s_csv_IllegalChar_1 = #0;
var
  EQUIPMENTID: string;
  CALIBRATIONID: Integer;
  SERIALNUMBER: string;
  PRUEFMOMENT: TDateTime;
  FIELD_DATE: TANfixDate;

  cINSERT: TIB_Cursor;
  qCALIBRATIONS: TIB_Query;
  qMETERS: TIB_Query;
  qTESTS: TIB_Query;

  // CSV
  sCSV: TStringList;
  sData: TStringList;
  rData: string;
  n, l, t: Integer;
  StartTime: dword;
  OneProcessed: boolean;
  DestPath: string;
  rCnt: Integer;

  procedure SwapTo(FName: string; sl: TStrings);
  var
    BinFile: file;
    a: array [0 .. 4095] of byte;
    n, i: Integer;
    s: string;
  begin
    sl.clear;
    try
      AssignFile(BinFile, FName);
      reset(BinFile, 1);
      BlockRead(BinFile, a, sizeof(a), i);
      s := '';
      for n := 0 to pred(i) do
      begin
        case a[n] of
          13, 0:
            ;
          10:
            begin
              sl.add(s);
              s := '';
            end;
        else
          s := s + chr(a[n]);
        end;
      end;
      if (s <> '') then
        sl.add(s);
      CloseFile(BinFile);
    except
    end;
  end;

begin
  if (iAuftragsObjektPath = '') then
    exit;

  BeginHourGlass;

  sCSV := TStringList.create;
  dir(iAuftragsObjektPath + '*.CSV', sCSV, false);
  sCSV.sort;

  if (sCSV.count > 0) then
  begin

    ProgressBar1.position := 0;
    ProgressBar1.max := sCSV.count;
    StartTime := 0;
    qCALIBRATIONS := DataModuleDatenbank.nQuery;
    qMETERS := DataModuleDatenbank.nQuery;
    qTESTS := DataModuleDatenbank.nQuery;
    cINSERT := DataModuleDatenbank.nCursor;
    sData := TStringList.create;

    // prepare calibs
    with qCALIBRATIONS do
    begin
      if assigned(cConnection) then
        ib_connection := cConnection;
      sql.add('select * from CALIBRATIONS for update');
    end;

    // prepare meters
    with qMETERS do
    begin
      if assigned(cConnection) then
        ib_connection := cConnection;
      sql.add('select * from METERS for update');
    end;

    with qTESTS do
    begin
      if assigned(cConnection) then
        ib_connection := cConnection;
      sql.add('select * from TESTS for update');
    end;

    with cINSERT do
    begin
      if assigned(cConnection) then
        ib_connection := cConnection;

      sql.add('select');
      sql.add(' count(CALIBRATIONS.CALIBRATIONID)');
      sql.add('from');
      sql.add(' CALIBRATIONS');
      sql.add('join');
      sql.add(' METERS');
      sql.add('on');
      sql.add(' (CALIBRATIONS.CALIBRATIONID=METERS.CALIBRATIONID) and');
      sql.add(' (CALIBRATIONS.EQUIPMENTID=METERS.EQUIPMENTID)');
      sql.add('where');
      sql.add(' (CALIBRATIONS.EQUIPMENTID=:EQUIPMENTID) and');
      sql.add(' (CALIBRATIONS.FIELD_DATE=:FIELD_DATE) and');
      sql.add(' (METERS.SERIALNUMBER=:SERIALNUMBER)');
      prepare;
    end;

    for n := 0 to pred(sCSV.count) do
    begin
      try

        // Datei laden!
        SwapTo(iAuftragsObjektPath + sCSV[n], sData);
        OneProcessed := false;

        for l := 0 to pred(sData.count) do
        begin

          // Vorbereitung
          rData := sData[l];

          // Grundvoraussetzung für einen Import
          if (nextp(rData, s_csv_Separator, s_csv_FormatRevision) <> 'R1.000')
          then
            continue;

          EQUIPMENTID := cutblank(nextp(rData, s_csv_Separator,
            s_csv_Pruefwerkzeug));
          SERIALNUMBER := cutblank(nextp(rData, s_csv_Separator,
            s_csv_fortlNummer));
          FIELD_DATE := date2long(nextp(rData, s_csv_Separator, s_csv_Datum));
          PRUEFMOMENT := mkDateTime(FIELD_DATE,
            strtoseconds(nextp(rData, s_csv_Separator, s_csv_Uhrzeit)));

          if (EQUIPMENTID = '') or (SERIALNUMBER = '') then
            continue;

          // erst mal prüfen, ob schon dieser Messwert drin ist
          with cINSERT do
          begin
            ParamByName('EQUIPMENTID').AsString := EQUIPMENTID;
            ParamByName('SERIALNUMBER').AsString := SERIALNUMBER;
            ParamByName('FIELD_DATE').AsDateTime := PRUEFMOMENT;
            Open;
            ApiFirst;
            rCnt := Fields[0].AsInteger;
            close;
            if (rCnt > 0) then
              continue;
          end;

          // neue Helium-Messwerte eintragen
          with qCALIBRATIONS do
          begin
            CALIBRATIONID := GEN_ID('GEN_CALIBRATIONID', 1);

            insert;
            // Index
            FieldByName('CALIBRATIONID').AsInteger := CALIBRATIONID;
            FieldByName('EQUIPMENTID').AsString := EQUIPMENTID;
            FieldByName('FIELD_DATE').AsDateTime := PRUEFMOMENT;
            post;
          end;

          with qMETERS do
          begin
            insert;

            // Index
            FieldByName('CALIBRATIONID').AsInteger := CALIBRATIONID;
            FieldByName('EQUIPMENTID').AsString := EQUIPMENTID;
            FieldByName('SERIALNUMBER').AsString := SERIALNUMBER;

            // Data
            FieldByName('METERDATA2').AsString := nextp(rData, s_csv_Separator,
              s_csv_Zaehlertyp);
            FieldByName('METERDATA4').AsString := nextp(rData, s_csv_Separator,
              s_csv_Membranhersteller);
            FieldByName('METERDATA5').AsString := nextp(rData, s_csv_Separator,
              s_csv_Chargennummer);
            FieldByName('POSITIONNUMBER').AsInteger :=
              StrToIntDef(nextp(rData, s_csv_Separator,
              s_csv_Station_Pruefkammer), -1);
            FieldByName('METERDATA6').AsString := nextp(rData, s_csv_Separator,
              s_csv_Kammer_Glocke);
            FieldByName('METERDATA9').AsString := nextp(rData, s_csv_Separator,
              s_csv_Pruefergebnis);
            post;
          end;

          for t := 1 to 3 do
          begin
            with qTESTS do
            begin
              insert;
              // Index
              FieldByName('CALIBRATIONID').AsInteger := CALIBRATIONID;
              FieldByName('EQUIPMENTID').AsString := EQUIPMENTID;
              FieldByName('SERIALNUMBER').AsString := SERIALNUMBER;
              // Data
              FieldByName('POINTNUM').AsInteger := t;
              FieldByName('METERPLOSS').AsDouble :=
                strtodoubledef(nextp(rData, s_csv_Separator,
                s_csv_Messwert), -1);
              FieldByName('METERMAXPLOSS').AsDouble :=
                strtodoubledef(nextp(rData, s_csv_Separator,
                s_csv_Grenzwert), -1);
              FieldByName('DONE').AsInteger := 1;
              post;
            end;
          end;

          OneProcessed := true;
        end;

        if OneProcessed then
        begin
          DestPath := 'Ablage\' + copy(long2date(FIELD_DATE), 7, 4) + '-KW' +
            inttostrN(WeekGet(FIELD_DATE), 2) + '\';
        end
        else
        begin
          DestPath := 'Unlesbar\';
        end;

        CheckCreateDir(iAuftragsAblagePath + DestPath);
        FileMove(iAuftragsObjektPath + sCSV[n], iAuftragsAblagePath + DestPath
          + sCSV[n]);

      except

      end;

      if frequently(StartTime, 444) then
      begin
        ProgressBar1.position := n;
        application.processmessages;
      end;

    end;
    qCALIBRATIONS.free;
    qMETERS.free;
    qTESTS.free;
    sData.free;
  end;
  sCSV.free;
  ProgressBar1.position := 0;
  EndHourGlass;
end;

procedure TFormOLAPArbeitsplatz.Content_close;
begin
  FreeAndNil(ConnectionItems);
  // open(OLAPpath + 'Datenbanken.OLAP.txt');
end;

procedure TFormOLAPArbeitsplatz.RefreshDBCombo;
var
  OLAPscript: TStringList;
  n: Integer;
  Connections: TStringList;
  AutoMataState: Integer;
  OneLine: string;
  OldIndex: Integer;
begin

  //
  OLAPscript := TStringList.create;
  Connections := TStringList.create;
  OLAPscript.LoadFromFile(iOlapPath + 'Datenbanken.OLAP.txt');
  AutoMataState := 0;
  for n := 0 to pred(OLAPscript.count) do
  begin
    OneLine := cutblank(OLAPscript[n]);
    if (OneLine = '') then
      continue;
    case AutoMataState of
      0:
        if (OneLine = 'connect') then
          inc(AutoMataState);
      1:
        if (OneLine = '-') then
          inc(AutoMataState)
        else
        begin
          nextp(OneLine, ' ');
          Connections.add(OneLine);
        end;
      2:
        break;
    end;
  end;

  //
  OldIndex := ComboBox3.itemIndex;
  ComboBox3.items.assign(Connections);
  if (OldIndex < ComboBox3.items.count) then
    ComboBox3.itemIndex := OldIndex;

  Connections.free;
  OLAPscript.free;
end;

procedure TFormOLAPArbeitsplatz.ComboBox3Select(Sender: TObject);
begin
  if (ComboBox3.itemIndex <> -1) then
    if assigned(ConnectionItems) then
    begin
      if (ComboBox3.itemIndex <> FormOLAP.DataBaseChosen) then
      begin
        BeginHourGlass;
        FormOLAP.DataBaseChosen := ComboBox3.itemIndex;
        Content_close;
        FormActivate(self);
        EndHourGlass;
      end;
    end;
end;

procedure TFormOLAPArbeitsplatz.SpeedButton2Click(Sender: TObject);
begin
  RefreshXLSCombo;
end;

procedure TFormOLAPArbeitsplatz.ToolButton4Click(Sender: TObject);
begin
  UserBreak := true;
end;

procedure TFormOLAPArbeitsplatz.ToolButton33Click(Sender: TObject);
begin
  ShowMessage('*ShortDateFormat:' + ShortDateFormat + #13 + 'LongDateFormat:' +
    LongDateFormat + #13 + 'TimeSeparator:' + TimeSeparator + #13 +
    'TimeAMString:' + TimeAMString + #13 + 'TimePMString:' + TimePMString + #13
    + 'ShortTimeFormat:' + ShortTimeFormat + #13 + '*LongTimeFormat:' +
    LongTimeFormat + #13);
end;

end.
