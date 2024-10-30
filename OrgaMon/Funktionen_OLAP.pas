{
  |      ___    _          _      ____
  |     / _ \  | |        / \    |  _ \
  |    | | | | | |       / _ \   | |_) |
  |    | |_| | | |___   / ___ \  |  __/
  |     \___/  |_____| /_/   \_\ |_|
  |
  |    Copyright (C) 2019 - 2022  Andreas Filsinger
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
  |    https://wiki.orgamon.org/
  |
}
unit Funktionen_OLAP;

{$ifdef fpc}
{$mode delphi}
{$endif}

interface

uses
  // System
  Classes,

  {$ifdef fpc}
  // fpspreadsheet
  fpspreadsheet,
  {$else}
  // FlexCel
  FlexCel.Core, FlexCel.xlsAdapter,
  {$endif}

  // Tools
  gplists, CareTakerClient, anfix,
  html,

  // OrgaMon
  globals;

{ OLAP }

// Tool Funktionen
function RohdatenFName(n: integer; MitPfad: boolean = true): string;
function RohdatenxlsFName(n: integer; MitPfad: boolean = true): string;
function RohdatenHTMLFName(n: integer; MitPfad: boolean = true): string;
function IncludeFName(n: integer): string;
function LoadSQLInclude(n: integer): string;
function ResolveParameter(s: string; ParameterL: TStringList): string;

procedure OLAP_addDefaults(s: TStrings);

{$ifdef fpc}
procedure e_w_OLAP_ODS(ODS: TsWorkbook);
{$else}
procedure e_w_OLAP_XLS(XLS: TXLSFile);
{$endif}

function e_x_OLAP(
 { } FName: string;
 { } GlobalVars: TStringList = nil;
 { } fb: TFeedback = nil ): boolean;

// OLAP-Script ausführen
function e_r_OLAP(OLAP: TStringList; Params: TStringList): TStringList; overload;
function e_r_OLAP(FName: string): TgpIntegerList; overload;

// Name einer temporären OLAP-Tabelle
function e_r_OLAP_Tabellenname(NameSpace: string; n: integer): string;

// temporäre OLAP Tabelle anlegen
procedure e_n_OLAP(NameSpace: string; n: integer);

// Bulk insert in eine OLAP Tabelle
procedure e_w_OLAP(NameSpace: string; n: integer; Werte: TgpIntegerList);


implementation

uses
 SysUtils, Math, Types,

 // Tools
 WordIndex, ExcelHelper, OpenOfficePDF,
 Geld, basic,

{$ifdef fpc}
 // ZEOS
 ZDatasetUtils,
 ZPlainFirebirdInterbaseDriver,
 //ZPlainFirebirdInterbaseConstants,
{$else}
 // IB-Objects
 IB_Components, IB_Header, IB_Session,
{$endif}

 // OrgaMon
 dbOrgaMon,
 OrientationConvert,
 Funktionen_Basis,
 Funktionen_Beleg,
 Funktionen_Artikel,
 Funktionen_Buch,
 Funktionen_Auftrag;

const
 RohdatenCount: Integer = 0;
 {$ifdef fpc}
 pODS: TsWorkbook = nil;
 {$else}
 pXLS: TXLSFile = nil;
 {$endif}

function RohdatenFName(n: integer; MitPfad: boolean = true): string;
begin
  result := 'OLAP.tmp' + inttostr(max(0, n)) + '.csv';
  if MitPfad then
    result := iOlapPath + result;
end;

function RohdatenxlsFName(n: integer; MitPfad: boolean = true): string;
begin
  result := 'OLAP-Ergebnis' + inttostr(max(0, n)) + cSpreadSheetExtension;
  if MitPfad then
    result := AnwenderPath + result;
end;

function RohdatenHTMLFName(n: integer; MitPfad: boolean = true): string;
begin
  result := 'OLAP-Ergebnis' + inttostr(max(0, n)) + '.html';
  if MitPfad then
    result := AnwenderPath + result;
end;

function IncludeFName(n: integer): string;
begin
  result := iOlapPath + 'SQL.' + inttostr(max(0, n)) + '.txt';
end;

function LoadSQLInclude(n: integer): string;
var
  TheSQL: TStringList;
begin
  TheSQL := TStringList.create;
  TheSQL.loadfromFile(IncludeFName(n));
  result := HugeSingleLine(TheSQL, ' ');
  TheSQL.free;
end;

procedure OLAP_addDefaults(s: TStrings);

  function prepareValue(s: string): string;
  begin
    result := s;
    ersetze('$', '€€', result);
  end;

begin
  with s do
  begin
    add('$Version='''+cAppName+'''');
    add('$Datum=' + Datum10);
    add('$Datum10=' + Datum10);
    add('$Datum8=' + Datum);
    add('$Diagnose=' + prepareValue(DiagnosePath));
    add('$SEQ_TAGESABSCHLUSS=' + inttostrN(e_r_gen('GEN_BACKUP'), 8));
    add('$SEQ_TAGWACHE=' + inttostrN(e_r_gen('GEN_TAGWACHE'), 8));
  end;
end;

// dbOrgaMOn OLAP
function e_r_OLAP_Tabellenname(NameSpace: string; n: integer): string;
begin
  if (NameSpace='') then
   result := 'OLAP$TMP' + inttostr(n)
  else
   result := 'OLAP$'+ StrFilter(NameSpace,cTabellen) + inttostr(n);
end;

procedure e_n_OLAP(NameSpace: string; n: integer);
var
 TableName : string;

  procedure CreateNewTable;
  begin
    // Tabelle neu anlegen
    e_x_sql('create table ' + TableName + ' (' + 'RID DOM_REFERENCE NOT NULL)');
    e_x_sql('alter table ' + TableName + ' add constraint PK_' + TableName +
      ' primary key (RID)');
  end;

begin
  TableName := e_r_OLAP_Tabellenname(NameSpace,n);
  if DROP_BUG then
  begin
    if TableExists(TableName) then
      e_x_sql('delete from ' + TableName)
    else
      CreateNewTable;
  end else
  begin
    // Tabelle löschen
    DropTable(TableName);
    CreateNewTable;
  end;
end;

procedure e_w_OLAP(NameSpace:string; n: integer; Werte: TgpIntegerList);
var
  OLAP: TdboScript;
  i: integer;
begin
  OLAP := nScript;
  with OLAP do
  begin
    sql.add('insert into');
    sql.add(e_r_OLAP_Tabellenname(NameSpace,n));
    sql.add(' (RID)');
    sql.add('values');
    sql.add(' (:CR1)');
    Prepare;
    for i := 0 to pred(Werte.count) do
    begin
      Params[0].AsInteger := Werte[i];
      if (i=0) then
       dbLog(sql,false);
      execute;
    end;
  end;
  OLAP.free;
end;

{$ifdef fpc}
procedure e_w_OLAP_ODS(ODS: TsWorkbook);
begin
  pODS := ODS;
end;
{$else}
procedure e_w_OLAP_XLS(XLS: TXLSFile);
begin
  pXLS := XLS;
end;
{$endif}

function e_x_OLAP(
 {} FName: string;
 {} GlobalVars : TStringList = nil;
 {} fb : TFeedback = nil ): boolean;

{$I feedback.inc}

const
  cState_Rohdaten = 0;
  cState_Cast = 1;
  cState_Join = 2;
  cState_Integrate = 3; // aggregate
  cState_Sort = 4;
  cState_extent = 6;
  cState_Complete = 7;
  cState_Assign = 8;
  cState_Integrate2 = 9; // aggregate
  cState_subtract = 10; // L := (L-1) - (L-2)
  cState_List = 11; // auflisten
  cState_Save = 12; // wiederum in die Datenbank rückspeichern
  cState_spread = 13; // 2. Spalte auf horizontale abbilden
  cState_load = 14; // laden einer externen csv in die Datenbank
  cState_repeat = 15;
  // Wiederholen einer SQL Anweisung mit Inhalten einer Tabelle
  cState_consult = 17; // eine externe Tabelle konsultieren
  cState_excel = 18; // aktuelles Ergebnis als XLS-Tabelle speichern
  cState_add = 19; // einzelne Datenzeilen manuell zu einem Ergebnis hinzunehmen
  cState_spread2 = 20; // 2. Spalte auf horizontale abbilden (alphanumerisch)
  cState_delete = 21; // einzelne Spalten löschen!
  cState_story = 22;
  // erzählt eine flache Story, stradd von Zellen zu einer Zelle
  cState_replace = 23;
  // ersetzt Spalten-Inhalte durch die von "complete"-Funktionen
  cState_table = 24;
  // benutzt 2 letzten 2 Auswertungen + eine Complete Funktion und baut eine Tabelle daraus
  cState_BASIC = 25; // führt das folgende BASIC-PRogramm aus!
  cState_default = 26;
  // die folgende Parameter Belegung ist nur wirksam wenn der bisherige Wert '' ist
  cState_html = 27; // der HTML Prozessor
  cState_evaluation = 28; // Auswertungen anwerfen
  cState_store = 29; // Ergebnisdatei in ein andere Verzeichnis kopieren
  cState_header = 30; // Tauscht den Header aus
  cState_integrate3 = 31; // aggregate
  cState_Oc = 32; // führt OrentationConvert aus

var
  m, k, l: integer;
  State: integer;
  CastCount: integer;
  sl: TStringList;
  Script: TStringList;
  Line: string;
  LineIndex: integer;
  SQL_ExecuteStatement: string;
  Line_ExecuteStatement: string;
  SilentMode: boolean;
  NameSpace: string;
  StartWait: dword;

  // BASIC-Prozessor
  BASIC: TBasicProcessor;

  // List
  ListCount: integer;

  // Join Sachen
  BigJoin: TList;
  JoinL: TStringList;

  ThisHeader: string;
  AllHeader: TStringList;
  OneHeader: string;
  OneLine: string;
  JoinedL: TStringList;
  HeaderOrder: array of integer;
  ThisHeaderAnz: integer;

  // Integration Sachen
  IntegratedL: TList;
  IntegratFound: boolean;
  IntegratedNewL: TStringList;
  DatumS: string;
  SingleValue: string;
  IntegrateCol: integer;
  IntegrateAnkerCol: integer;
  IntegrateOperation: string;
  AnkerS: string;
  DatumGranularitaet: TDatum_Granularitaet;

  // Parameter Verwaltung
  ParameterL: TStringList;
  DebugInfos: TStringList;

  // "complete" Sachen
  ParamCol: integer;
  ParamAll: string;
  ParamConstant: string;
  ParamFunction: string;
  ParamVal1: string;
  ParamVal2: string;
  CompleteResult: string;
  CompleteResultL: TStringList;
  sLine, FullLine: string;
  CompleteStrL: TStringList;
  CalculateStatement: TStringList;
  cCalc: Tdbocursor;
  NewColumnName: string;
  FirstDollarFound: boolean;
  CompleteHeader: TStringList;

  // "replace" Sachen
  ReplaceIndex: integer;

  // "table" Sachen
  TabelleHorizontal: TsTable;

  // Sort Sachen
  ClientSorter: TStringList;
  SortResult: TStringList;
  SortRow: string;
  SortStr: string;
  FormatNumeric: boolean;
  DoReverse: boolean;

  // Umsatz Sachen
  Rabatt: double;
  EinzelPreisUnrabattiert: double;

  // Assign Sachen
  MonatsName: string;
  MonatsNamen: TStringList;
  MonatsSpaltenOffset: integer;
  AssignStart: TAnfixDate;
  AssignEnde: TAnfixDate;
  AssignRun: TAnfixDate;
  MonatsN: integer;
  AssignDatumCol: integer;
  AssignWertCol: integer;
  AssignWert: string;

  // subtract
  RedList: TStringList;
  RedValue: string;

  // List
  ListColName: string;
  ListCol: integer;
  ListDistinct: boolean;
  ListNumeric: boolean;
  ListResult: string;
  ListResults: TStringList;

  //
  LastKategorie: string;
  LastCode: string;
  TopKategorie: string;

  // spread
  SpaltenSoll: integer;
  SpaltenIst: integer;
  VerlagL: TgpIntegerList;
  SpreadColName: string;

  // spread-alpha
  SpreadTitle: TStringList;

  // load / save
  LoadFname: string;
  LoadSQL: string;
  LoadSQLinsert: string;
  LoadSQLvalues: string;
  LoadSQLvalue: string;
  SpaltenNamen: TStringList;
  LoadSpalte: TgpIntegerList;
  LoadSpalteType: TgpIntegerList;

  // html
  htmlFName: string;
  htmlSaveFName: string;
  html: THTMLTemplate;

  // repeat
  RepeatTable: string;
  RepeatSQL, _RepeatSQL: string;
  cRepeat: TdboCursor;
  RepeatFieldNames: TStringList;

  // consult
  col_Question: integer; // Spaltenindex der Fragestellung
  col_ConsultIndex: integer; // Spaltenindex des verwendeten Suchindex
  col_ConsultAnswer: integer; // Spaltenindex der Antwort, die in die fragende
  // Datei eingefügt wird
  sl_ConsultIndex: TStringList;

  // excel
  xlsAutoOpen: boolean;
  xlsAutoPrint: boolean;
  xlsAutoHTML: boolean;
  xlsHTMLCopy: string;
  excelFormats: TStringList;

  // delete
  NewLine: string;

  // Oc
  Oc_Params: TStringList;

  // story
  StatementParams: TStringList; // aktuelle Wertvariable
  AnkerParam: string;
  AnkerValue: string;
  LastAnker: string; // Anker der letzen Zeile
  LastAnkerLine: integer; // dorthin wird die Story erzählt
  AktAnker: string; // aktueller Anker, den es zu bewahren gilt
  StoryFree: TgpIntegerList; // Liste der unnötigen Zeile
  StoryMaxCol: integer;
  TargetCol: integer;

  // add
  addValueD: double;
  addValueI: integer;

  // AppendMode
  AppendMode: boolean;

  // OLAP-Ergebnis.csv
  OLAP_Ergebnis_Count: Integer;

  procedure setWaitCaption(s: string);
  begin
    _(cFeedback_Label+4, s);
    _(cFeedback_processmessages);
  end;

  function getValueofParameter(ParamS: string): string;
  begin
    result := ParameterL.values[ParamS];
    if (length(result) = 7) then
      if (result[1] = '#') then
        result := inttostr(HTMLColor2TColor(result));
  end;

  function completeValue(Line: string): string;
  var
    DimensionValues: TStringList;
    n: integer;
    AskLabel : string;
    AskCaption : string;
  begin
    result := Line;
    repeat
      if pos('=?', Line) > 0 then
      begin

        // Text Vor dem Eingabe Feld!
        AskLabel := nextp(nextp(Line, '=?', 1), 'from', 0);

        // Titel des Dialoges
        AskCaption := 'Dimensionsbestimmung ' + nextp(Line, '=', 0);

        // Eine Box der möglichen Elemente füllen
        DimensionValues := TStringList.create;
        DimensionValues.loadfromFile(RohdatenFName(strtointdef(nextp(Line, 'from', 1), 0)));
        DimensionValues.delete(0);
        for n := 0 to pred(DimensionValues.count) do
        begin
          if (pos('"', DimensionValues[n]) = 1) then
            DimensionValues[n] := ExtractSegmentBetween(DimensionValues[n], '"', '"');
        end;
        DimensionValues.sort;

        // Unsupported FeedBack
        _(-1,
         {} cERRORText+' Benutzereingabe '+
         {} AskLabel+':'+
         {} AskCaption+'@'+
         {} HugeSingleLine(DimensionValues,'|')+' nicht möglich');

        DimensionValues.Free;
        result := '';
        break;
      end;

      // Paramerter muss wiederum aufgelöst werden ...
      n := pos('=select ', Line);
      if (n > 0) then
      begin
        SQL_ExecuteStatement := ResolveParameter(copy(Line, n + 1, MaxInt),ParameterL);
        result := copy(Line, 1, n) + e_r_sqls(SQL_ExecuteStatement);
        break;
      end;

    until yet;
  end;

  procedure SaveCopy(FName: string);
  var
    Pfad: string;
  begin
    Pfad := getValueofParameter('$KopieSpeichernUnter');
    if (Pfad <> '') then
      FileCopy(
        { } FName,
        { } Pfad + ExtractFileName(FName));
  end;

  procedure SaveJoin;
  var
    m: integer;
  begin
    // fertig -> rausspeichern
    JoinL.clear;
    for m := 0 to pred(BigJoin.count) do
      JoinL.add(HugeSingleLine(TStringList(BigJoin[m]), cOLAPcsvSeparator));
    JoinL.savetofile(RohdatenFName(RohdatenCount));
    SaveCopy(RohdatenFName(RohdatenCount));
    OLAP_Ergebnis_Count := RohdatenCount;
    inc(RohdatenCount);
  end;

  procedure SaveJoinAsExcel;
  begin
    if SilentMode then
    begin
      excelFormats.values[cExcel_TabellenName] := '';
    end
    else
    begin
      if (excelFormats.values[cExcel_TabellenName] = '') then
        excelFormats.values[cExcel_TabellenName] := getValueofParameter('$Skript');
    end;

    {$ifdef fpc}
    // als ODS ausgeben
    ExcelExport(RohdatenxlsFName(RohdatenCount), BigJoin, nil, excelFormats, pODS);
    {$else}
    // als Excel ausgeben
    ExcelExport(RohdatenxlsFName(RohdatenCount), BigJoin, nil, excelFormats, pXLS);
    {$endif}

    // wegkopieren?
    SaveCopy(RohdatenxlsFName(RohdatenCount));

    // als PDF ausgeben
    if (getValueofParameter('$AuchAlsPDF') = cIni_Activate) then
      {$ifdef fpc}
      if (pODS = nil) then
      {$else}
      if (pXLS = nil) then
      {$endif}
      begin
        MakePDF(RohdatenxlsFName(RohdatenCount), RohdatenxlsFName(RohdatenCount) + cPDF_Extension);

        // wegkopieren?
        SaveCopy(RohdatenxlsFName(RohdatenCount) + cPDF_Extension);
      end;

  end;

  procedure SaveJoinAsHTML;
  var
    sData: TsTable;
    Pfad: string;
  begin
    if SilentMode then
    begin
      excelFormats.values[cExcel_TabellenName] := '';
    end
    else
    begin
      if (excelFormats.values[cExcel_TabellenName] = '') then
        excelFormats.values[cExcel_TabellenName] := getValueofParameter('$Skript');
    end;
    sData := TsTable.create;
    sData.insertFromFile(RohdatenFName(RohdatenCount));
    sData.SaveToHTML(RohdatenHTMLFName(RohdatenCount), excelFormats);
    Pfad := getValueofParameter('$KopieSpeichernUnter');
    if (Pfad <> '') then
      FileCopy(RohdatenHTMLFName(RohdatenCount), Pfad + RohdatenHTMLFName(RohdatenCount, false));
    sData.free;
  end;

  procedure FreeJoin;
  var
    k: integer;
  begin
    for k := 0 to pred(BigJoin.count) do
      TObject(BigJoin[k]).free;
    BigJoin.clear;
  end;

  procedure InitJoin;
  begin
    FreeJoin;
    BigJoin.add(TStringList.create);
    StatementParams.clear;
  end;

  procedure JoinDeleteLine(Index: integer);
  var
    TheElements: TStringList;
  begin
    TheElements := TStringList(BigJoin[Index]);
    TheElements.free;
    BigJoin.delete(Index);
  end;

  procedure LoadJoin(UseSameOutPut: boolean = true);
  // : BigJoin [= TList of TStringList];
  var
    n, m, k: integer;
    Cols: TStringList;
    ThisHeader: string;
    ThisLine: string;
    ColCount: integer;
  begin
    LoadFromFileCSV(true, JoinL, RohdatenFName(RohdatenCount - 1));
    if JoinL.count > 0 then
      ThisHeader := JoinL[0]
    else
      ThisHeader := '';
    while (ThisHeader <> '') do
      TStringList(BigJoin[0]).add(nextp(ThisHeader, cOLAPcsvSeparator));
    ColCount := TStringList(BigJoin[0]).count;
    for n := 1 to pred(JoinL.count) do
    begin
      ThisLine := JoinL[n];
      Cols := TStringList.create;
      for m := 0 to pred(ColCount) do
      begin
        if (pos(cOLAPcsvQuote, ThisLine) = 1) then
        begin
          k := pos(cOLAPcsvQuote, copy(ThisLine, 2, MaxInt));
          Cols.add(copy(ThisLine, 2, k - 1));
          delete(ThisLine, 1, k + 1);
          nextp(ThisLine, cOLAPcsvSeparator);
        end
        else
        begin
          Cols.add(nextp(ThisLine, cOLAPcsvSeparator));
        end;
      end;
      BigJoin.add(Cols);
    end;
    if UseSameOutPut then
      dec(RohdatenCount);
  end;

  procedure LoadJoinFrom(FName: string);
  var
    n, m: integer;
    Cols: TStringList;
    ThisHeader: string;
    ThisData: string;
    ColCount: integer;
  begin
    LoadFromFileCSV(true, JoinL, iOlapPath + FName);
    ThisHeader := JoinL[0];
    while (ThisHeader <> '') do
      TStringList(BigJoin[0]).add(nextp(ThisHeader, cOLAPcsvSeparator));
    ColCount := TStringList(BigJoin[0]).count;
    for n := 1 to pred(JoinL.count) do
    begin
      ThisData := JoinL[n];
      Cols := TStringList.create;
      for m := 0 to pred(ColCount) do
        Cols.add(nextp(ThisData, cOLAPcsvSeparator));
      BigJoin.add(Cols);
    end;
  end;

  function CSVsecure(s: string): string;
  begin
    result := s;
    ersetze(cOLAPcsvSeparator, ',', result);
    ersetze(cOLAPcsvQuote, '''', result);
  end;

  function AssignDate(d: TAnfixDate): string;
  var
    j, m, t: integer;
  begin
    long2details(d, j, m, t);
    result := cMonatWeb[m] + '_' + inttostr(j);
  end;

  function _IntToStrN(const i: integer; n: byte): string;
  begin
    result := inttostr(i);
    result := fill('0', n - length(result)) + result;
  end;

  function completeFunc(sRow: TStringList): string;
  var
    l, m: integer;
    BELEG_R: integer;
    TEILLIEFERUNG: integer;
    Protokoll: TStringList;
    SubItems: TStringList;
    Header: TStringList;
    EinDatum: TAnfixDate;
    s: string;

    function Plural: string;
    var
      PluralAnker: integer;
      Plural1: string;
      PluralN: string;
    begin
      result := cOLAPNull;
      PluralAnker := AllHeader.indexof(nextp(ParamAll, ','));
      if (PluralAnker = -1) then
      begin
        _(cFeedback_ShowMessage,'complete:Plural: Anker nicht gefunden!');
      end
      else
      begin
        Plural1 := ExtractSegmentBetween(nextp(ParamAll, ','), '"', '"');
        PluralN := ExtractSegmentBetween(nextp(ParamAll, ','), '"', '"');
        if (strtointdef(sRow[PluralAnker], 1) = 1) then
          result := Plural1
        else
          result := PluralN;
      end;
      ersetze('_', ' ', result);
    end;

  begin
    result := cOLAPNull;
    repeat

      if (pos('"', ParamFunction) > 0) then
      begin
        result := ResolveParameter(ParamConstant,ParameterL);
        break;
      end;

      if (ParamFunction = 'Arbeit') then
      begin
        result := e_r_Arbeit(strtointdef(ParamVal1, cRID_Null), date2long(ParamVal2));
        break;
      end;

      if (ParamFunction = 'Anno') then
      begin
        result := format('%.2m', [b_r_Anno(ParamVal1, date2long(ParamVal2), DateGet)]);
        break;
      end;

      if (ParamFunction = 'Einsatz') then
      begin
        result := e_r_Einsatz(strtointdef(ParamVal1, cRID_Null), date2long(ParamVal2));
        break;
      end;

      if (ParamFunction = 'NächsteAnwendung') then
      begin
       result := e_r_Vertrag_NaechsteAnwendung(strtointdef(ParamVal1, cRID_Null));
       break;
      end;

      if (ParamFunction = 'Komponist') then
      begin
        result := e_r_MusikerName(strtointdef(ParamVal1, 0));
        break;
      end;

      if (ParamFunction = 'Arrangeur') then
      begin
        result := e_r_MusikerName(strtointdef(ParamVal1, 0));
        break;
      end;

      if (ParamFunction = 'KomponistN') then
      begin
        result := e_r_MusikerNachname(strtointdef(ParamVal1, 0));
        break;
      end;

      if (ParamFunction = 'ArrangeurN') then
      begin
        result := e_r_MusikerNachname(strtointdef(ParamVal1, 0));
        break;
      end;

      if (ParamFunction = 'Bild') then
      begin
        result := e_r_ArtikelBild(0, strtointdef(ParamVal1, 0));
        break;
      end;

      if (ParamFunction = 'Vorschau') then
      begin
        result := e_r_ArtikelVorschaubild(0, strtointdef(ParamVal1, 0));
        break;
      end;

      if (ParamFunction = 'Musik') then
      begin
        result := e_r_ArtikelMusik(0, strtointdef(ParamVal1, 0));
        break;
      end;

      if (ParamFunction = 'Kontext') then
      begin
        result := e_r_ArtikelKontext(0, strtointdef(ParamVal1, 0));
        break;
      end;

      if (ParamFunction = 'Verlag') then
      begin
        result := e_r_Verlag_PERSON_R(strtointdef(ParamVal1, 0));
        break;
      end;

      if (ParamFunction = 'VerlagsRabatt') then
      begin
        result := format('%.1f', [e_r_VerlagsRabatt(strtointdef(ParamVal1, 0), strtointdef(ParamVal2, 0))]);
        break;
      end;

      if (ParamFunction = 'Zeit') then
      begin
        result := SecondsToStr9(strtointdef(ParamVal1, 0));
        break;
      end;

      if (ParamFunction = 'limit32') then
      begin
        result := _IntToStrN(strtoint64def(noblank(ParamVal1), 0), 0);
        break;
      end;

      if (ParamFunction = 'Rabattiert') then
      begin
        EinzelPreisUnrabattiert := strtodoubledef(ParamVal1, 0.0);
        Rabatt := strtodoubledef(sRow[ParamCol + 1], 0);
        if (Rabatt > 0) then
          EinzelPreisUnrabattiert :=
            cPreisRundung(EinzelPreisUnrabattiert - (EinzelPreisUnrabattiert * (Rabatt / 100.0)));
        result := format('%.2m', [EinzelPreisUnrabattiert]);
        break;
      end;

      if (ParamFunction = 'Umsatz') then
      begin
        result := format('%.2m', [e_r_PostenUmsatz(strtointdef(ParamVal1, 0))]);
        break;
      end;

      if (ParamFunction = 'Netto') then
      begin
        result := format('%.2m', [e_r_GeliefertUmsatz(strtointdef(ParamVal1, 0))]);
        break;
      end;

      if (ParamFunction = 'Preis') then
      begin
        result := format('%.2m', [e_r_PreisBrutto(0, strtointdef(ParamVal1, 0))]);
        break;
      end;

      if (ParamFunction = 'Lieferzeit') then
      begin
        result := inttostr(e_r_Lieferzeit(0, strtointdef(ParamVal1, 0)));
        break;
      end;

      if (ParamFunction = 'Bemerkung') then
      begin
        CompleteStrL := e_r_sqlt('select INTERN_INFO from ARTIKEL where RID=' + ParamVal1);
        result := ReadLongStr('BEM', CompleteStrL, '|');
        ersetze('"', '''', result);
        result := '"' + result + '"';
        CompleteStrL.free;
        break;
      end;

      if (ParamFunction = 'Anschrift') then
      begin
        if (ParamVal1 = cOLAPNull) then
        begin
          result := fill(cOLAPcsvSeparator, 5);
        end
        else
        begin
          CompleteStrL := e_r_Adressat(strtointdef(ParamVal1, 0));
          result := CSVsecure(
           {} CompleteStrL[0]) + cOLAPcsvSeparator +
           {} CSVsecure(CompleteStrL[1]) + cOLAPcsvSeparator +
           {} CSVsecure(CompleteStrL[2]) + cOLAPcsvSeparator +
           {} CSVsecure(CompleteStrL[3]) + cOLAPcsvSeparator +
           {} CSVsecure(e_r_sqls('SELECT STRASSE from ANSCHRIFT where RID' +
            '=(SELECT PRIV_ANSCHRIFT_R from PERSON where RID=' + ParamVal1 + ')')) + cOLAPcsvSeparator +
           {} CSVsecure(HugeSingleLine(e_r_Ort(strtointdef(ParamVal1, 0)),'|',3,true));
          CompleteStrL.free;
        end;
        break;
      end;

      if (ParamFunction = 'Person') then
      begin
        result := e_r_Person(strtointdef(ParamVal1, 0));
        break;
      end;

      if (ParamFunction = 'Land') then
      begin
        result := e_r_ObtainISOfromRID(strtointdef(ParamVal1, 0));
        break;
      end;

      if (ParamFunction = 'Woche') then
      begin
        // könnte auch ein TimeStamp sein, sooo genau wollen wir das nicht!
        EinDatum := date2long(nextp(ParamVal1, ' ', 0));
        if DateOK(EinDatum) then
          result := inttostrN(extractYear(EinDatum), 4) + '_KW' + inttostrN(anfix.Kalenderwoche(EinDatum), 2);
        break;
      end;

      if (ParamFunction = 'Tag') then
      begin
        // könnte auch ein TimeStamp sein, sooo genau wollen wir das nicht!
        EinDatum := date2long(nextp(ParamVal1, ' ', 0));
        if DateOK(EinDatum) then
          result := WeekDayL(EinDatum);
        break;
      end;

      if (ParamFunction = 'Fax') then
      begin
        result := e_r_fax(strtointdef(ParamVal1, 0));
        break;
      end;

      if (ParamFunction = 'Beleg') then
      begin
        BELEG_R := strtointdef(ParamVal1, -1);
        TEILLIEFERUNG := strtointdef(ParamVal2, -1);
        CompleteStrL := e_r_BelegInfo(BELEG_R, TEILLIEFERUNG);

        if (CompleteStrL.values['SATZ1'] = '') then
          CompleteStrL.values['SATZ1'] := cOLAPNull;

        if (CompleteStrL.values['SATZ2'] = '') then
          CompleteStrL.values['SATZ2'] := cOLAPNull;

        if (CompleteStrL.values['SATZ3'] = '') then
          CompleteStrL.values['SATZ3'] := cOLAPNull;

        if (CompleteStrL.values['NETTO1'] = '') then
          CompleteStrL.values['NETTO1'] := cOLAPNull;

        if (CompleteStrL.values['NETTO2'] = '') then
          CompleteStrL.values['NETTO2'] := cOLAPNull;

        if (CompleteStrL.values['NETTO3'] = '') then
          CompleteStrL.values['NETTO3'] := cOLAPNull;

        if (CompleteStrL.values['STEUER1'] = '') then
          CompleteStrL.values['STEUER1'] := cOLAPNull;

        if (CompleteStrL.values['STEUER2'] = '') then
          CompleteStrL.values['STEUER2'] := cOLAPNull;

        if (CompleteStrL.values['STEUER3'] = '') then
          CompleteStrL.values['STEUER3'] := cOLAPNull;

        result := // Beleg-Teillieferung;NETTO1;SATZ1;MWST1;NETTO2;SATZ2;MWST2;NETTO3;SATZ3;MWST3
        { } inttostr(BELEG_R) + '-' +
        { } inttostrN(TEILLIEFERUNG, 2) + cOLAPcsvSeparator +
        { } CompleteStrL.values['NETTO1'] + cOLAPcsvSeparator +
        { } CompleteStrL.values['SATZ1'] + cOLAPcsvSeparator +
        { } CompleteStrL.values['STEUER1'] + cOLAPcsvSeparator +
        { } CompleteStrL.values['NETTO2'] + cOLAPcsvSeparator +
        { } CompleteStrL.values['SATZ2'] + cOLAPcsvSeparator +
        { } CompleteStrL.values['STEUER2'] + cOLAPcsvSeparator +
        { } CompleteStrL.values['NETTO3'] + cOLAPcsvSeparator +
        { } CompleteStrL.values['SATZ3'] + cOLAPcsvSeparator +
        { } CompleteStrL.values['STEUER3'];

        CompleteStrL.free;
        break;
      end;

      if (ParamFunction = 'Kategorie') then
      begin

        if (ParamVal1 = LastKategorie) then
          result := 'N'
        else
        begin

          if (length(sRow[0]) > length(LastCode)) then
          begin

            // Tiefer
            if (TopKategorie <> '') then
              TopKategorie := TopKategorie + '|' + LastKategorie
            else
              TopKategorie := LastKategorie;

          end;

          if (length(sRow[0]) < length(LastCode)) then
          begin
            // Höher
            rnextp(TopKategorie, '|');
          end;

          if (TopKategorie <> '') then
            result := TopKategorie + ':' + ParamVal1
          else
            result := ParamVal1;

        end;

        LastCode := sRow[0];
        LastKategorie := ParamVal1;

        break;
      end;

      if (ParamFunction = 'Lohn') then
      begin
        result := e_r_LohnKalkulation(strtodoubledef(ParamVal1, 0), date2long('01.' + ResolveParameter('$MonatJahr',ParameterL)));
        break;
      end;

      if (ParamFunction = 'Plural') then
      begin
        // Plural(ANKER,"der Hase","die Hasen")
        result := Plural;
        break;
      end;

      if (ParamFunction = 'Protokoll') then
      begin
        //
        Protokoll := e_r_sqlt('SELECT PROTOKOLL from AUFTRAG where RID=' + ParamVal1);
        for l := 0 to pred(CompleteHeader.count) do
        begin
          s := Protokoll.values[nextp(CompleteHeader[l], ':', 0)];
          if (pos(':INT', CompleteHeader[l]) > 0) then
            if (s = 'X') or (s = 'J') then
              s := '1'
            else
              s := '0';
          if (l = 0) then
            result := s
          else
            result := result + ';' + s;
        end;
        Protokoll.free;
        break;
      end;

      if (ParamFunction = 'Auftrag') then
      begin

        // cWordHeaderLine
        SubItems := e_r_AuftragItems(strtointdef(ParamVal1, cRID_Null));
        Header := e_c_AuftragHeader;

        for l := 0 to pred(CompleteHeader.count) do
        begin
          m := Header.indexof(CompleteHeader[l]);
          if m = -1 then
            s := 'N/A'
          else
            s := SubItems[m];

          if (l = 0) then
            result := s
          else
            result := result + ';' + s;
        end;
        Header.free;
        break;

      end;

      if (ParamFunction = 'SQL') then
      begin

        cCalc := nCursor;

        SQL_ExecuteStatement := ParamConstant;

        // Aus der aktuellen Zeile alle Werte in die Parameter schreiben
        if pos('$', SQL_ExecuteStatement) > 0 then
        begin
          for l := 0 to AllHeader.count - 2 do
            if (l < sRow.count) then
              ParameterL.values['$' + AllHeader[l]] := sRow[l]
            else
              ParameterL.values['$' + AllHeader[l]] := cOLAPNull;
          SQL_ExecuteStatement := ResolveParameter(SQL_ExecuteStatement,ParameterL);
        end;

        setWaitCaption(SQL_ExecuteStatement);

        // Ergebnis saugen!
        with cCalc do
        begin
          sql.add(SQL_ExecuteStatement);
          dblog(sql);
          ApiFirst;
          if eof then
          begin
            if (ParamAll = '') then
              result := cOLAPNull
            else
              result := ParamAll;
          end
          else
            result := Fields[0].AsString;
        end;
        cCalc.free;
        break;

      end;

      if FileExists(iOlapPath + cOLAPDimPreFix + ParamFunction + '.txt') then
      begin
        //
        cCalc := nCursor;
        CalculateStatement := TStringList.create;
        CalculateStatement.loadfromFile(iOlapPath + cOLAPDimPreFix + ParamFunction + '.txt');
        SQL_ExecuteStatement := HugeSingleLine(CalculateStatement, ' ');

        // Aus der aktuellen Zeile alle Werte in die Parameter schreiben
        if pos('$', SQL_ExecuteStatement) > 0 then
        begin
          for l := 0 to AllHeader.count - 2 do
            ParameterL.values['$' + AllHeader[l]] := sRow[l];
          SQL_ExecuteStatement := ResolveParameter(SQL_ExecuteStatement,ParameterL);
        end;

        setWaitCaption(SQL_ExecuteStatement);

        // Ergebnis saugen!
        with cCalc do
        begin
          sql.add(SQL_ExecuteStatement);
          dblog(sql);
          ApiFirst;
          if eof then
          begin
            if (ParamAll = '') then
              result := cOLAPNull
            else
              result := ParamAll;
          end
          else
            result := Fields[0].AsString;
        end;
        cCalc.free;
        CalculateStatement.free;
        break;
      end;

      // ERROR: Unknown Funktion
      raise Exception.create('complete "' + ParamFunction + '" nicht gefunden!');

    until yet;
  end;

begin
  result := false;

  // do we have a filemask?
  if (length(StrFilter(FName, '*?'))>0) then
  begin
    sl := TStringList.create;
    dir(FName, sl, false);
    sl.Sort;
    m := 0;
    for l := 0 to pred(sl.count) do
      if e_x_OLAP(ExtractFilePath(FName) + sl[l], GlobalVars, fb) then
        inc(m);
    result := (m=sl.Count);
    sl.free;
    exit;
  end;

  // check File
  if not(FileExists(FName)) then
  begin
   _(cFeedback_Log,cERRORText+FName+' nicht gefunden');
   exit;
  end;

  // delete Result-File
  FileDelete(iOlapPath + cOLAP_ErgebnisFName);
  if FileExists(iOlapPath + cOLAP_ErgebnisFName) then
  begin
   _(cFeedback_Log,cERRORText+iOlapPath + cOLAP_ErgebnisFName+' nicht löschbar');
   exit;
  end;

  Script := TStringList.Create;
  Script.LoadFromFile(FName);
  BigJoin := TList.create;
  IntegratedL := TList.create;
  ParameterL := TStringList.create;
  JoinL := TStringList.create;
  sl := TStringList.create;
  StatementParams := TStringList.create;
  excelFormats := TStringList.create;
  CompleteHeader := TStringList.create;
  Oc_Params := TStringList.Create;
  BASIC := nil;

  try

    LastKategorie := '';
    LastCode := '';
    TopKategorie := '';

    RohdatenCount := 0;
    OLAP_Ergebnis_Count := -1;
    NameSpace := 'TMP';
    CastCount := 0;
    State := cState_Rohdaten;
    LineIndex := -1;
    AppendMode := false;
    xlsAutoOpen := false;
    xlsAutoPrint := false;
    xlsAutoHTML := false;

    // self assigned Parameters
    ParameterL.add('$Skript=' + nextp(ExtractFileName(FName), cOLAPExtension, 0));
    ParameterL.add('$Lines=' + inttostr(Script.count));
    OLAP_addDefaults(ParameterL);

    if DebugMode then
    begin
      DebugInfos := TStringList.create;
      DebugInfos.add('-- Parameter --');
      DebugInfos.AddStrings(ParameterL);
      if assigned(GlobalVars) then
      begin
        DebugInfos.add('-- Global Vars --');
        DebugInfos.AddStrings(GlobalVars);
      end;
      AppendStringsToFile(DebugInfos, DebugLogPath + 'OLAP-' + DatumLog + '.txt', DatumUhr);
      DebugInfos.free;
    end;

    // Merge all to ParameterL
    if assigned(GlobalVars) then
     for m := pred(GlobalVars.count) downto 0 do
       ParameterL.insert(0, GlobalVars[m]);

    // set Parameter from Vars
    SilentMode := (ParameterL.values['$Silent'] <> cINI_deactivate);

    repeat

      inc(LineIndex);

      if (LineIndex = Script.count) then
        break;

      // Get Line
      Line := cutblank(Script[LineIndex]);

      if not(assigned(BASIC)) then
      begin

        // remove comment
        k := pos('//', Line);
        if (k > 0) then
          Line := copy(Line, 1, pred(k));
        k := pos('--', Line);
        if (k > 0) then
          Line := copy(Line, 1, pred(k));

        //
        if (Line = '') then
          continue;

        if (Line <> '-') then
        begin
          Line_ExecuteStatement := Line;
          setWaitCaption(Line_ExecuteStatement);
        end;
      end;

      // optionaler leiser Ausstieg aus einem Statement
      // (wird im Interaktiven Modus ignoriert)
      if (Line = 'return') then
      begin
        if SilentMode then
          break
        else
          continue;
      end;

      // Parameter - Definition?
      if (pos('$', Line) = 1) then
      begin
        if (State = cState_default) then
        begin
          if (ResolveParameter(nextp(Line, '=', 0),ParameterL) = '') then
            ParameterL.add(completeValue(Line));
        end
        else
        begin
          ParameterL.add(completeValue(Line));
        end;
        if (pos('NAMESPACE=',Line)=2) then
         NameSpace := nextp(Line,'=',1);
        continue;
      end;

      if (pos('include', Line) = 1) then
      begin
        // imp pend: echtes include! Ist im Moment so ein "Jump"
        // ohne den $Skript anzupassen, ist das gewollt? JA!
        Script.loadfromFile(iOlapPath + nextp(Line, ' ', 1) + cOLAPExtension);
        LineIndex := -1;
        continue;
      end;

      if (Line = 'data') then // Es wird ein SQL-Statement erwartet
      begin
        State := cState_Rohdaten;
        continue;
      end;

      if (Line = 'cast') then // Feld-Typen anpassen
      begin
        State := cState_Cast;
        continue;
      end;

      if (Line = 'join') then // 2 Datentabellen verbinden
      begin
        State := cState_Join;
        InitJoin;
        continue;
      end;

      if (Line = 'subtract') then // 2 Datentabellen voneinander abziehen
      begin
        State := cState_subtract;
        InitJoin;
        LoadJoin(false);
        continue;
      end;

      if (Line = 'spread') then
      begin
        State := cState_spread;
        InitJoin;
        LoadJoin;
        continue;
      end;

      if (Line = 'spread2') then
      begin
        State := cState_spread2;
        InitJoin;
        LoadJoin;
        continue;
      end;

      if (Line = 'extent') then // 2 Datentabellen verbinden
      begin
        State := cState_extent;
        InitJoin;
        continue;
      end;

      if (Line = 'integrate') then // über identische Spalten andere addieren
      begin
        State := cState_Integrate;
        continue;
      end;

      if (Line = 'integrate2') then // über identische Spalten andere addieren
      begin
        State := cState_Integrate2;
        continue;
      end;

      if (Line = 'integrate3') then
      begin
        State := cState_integrate3;
        continue;
      end;

      if (Line = 'header') then
      begin
        State := cState_header;
        continue;
      end;

      if (Line = 'sort') then // über Spalten sortieren
      begin
        State := cState_Sort;
        continue;
      end;

      if (Line = 'complete') then
      // Spalten hinzunehmen anhand von Funktionen oder SQL Statements
      begin
        State := cState_Complete;
        InitJoin;
        LoadJoin;
        continue;
      end;

      if (Line = 'table') then
      // Spalten hinzunehmen anhand von Funktionen oder SQL Statements
      begin
        State := cState_table;
        InitJoin;
        LoadJoin;
        continue;
      end;

      if (Line = 'replace') then
      // Spalten ersetzen anhand von Funktionen oder SQL Statements
      begin
        State := cState_replace;
        InitJoin;
        LoadJoin;
        continue;
      end;

      if (Line = 'assign') then //
      begin
        State := cState_Assign;
        InitJoin;
        LoadJoin(false);
        continue;
      end;

      if (Line = 'nop') then
      begin
        inc(RohdatenCount);
        continue;
      end;

      if (Line = 'list') then
      begin
        State := cState_List;
        InitJoin;
        LoadJoin;
        ListCount := RohdatenCount;
        continue;
      end;

      if (Line = 'save') then
      begin
        State := cState_Save;
        InitJoin;
        LoadJoin(false);
        continue;
      end;

      if (Line = 'add') then
      begin
        State := cState_add;
        InitJoin;
        LoadJoin;
        continue;
      end;

      if (Line = 'delete') then
      begin
        State := cState_delete;
        InitJoin;
        LoadJoin;
        continue;
      end;

      if (Line = 'story') then
      begin
        State := cState_story;
        InitJoin;
        LoadJoin;
        continue;
      end;

      if (Line = 'Oc') then
      begin
        Oc_Params.clear;
        State := cState_Oc;
        InitJoin;
        LoadJoin;
        continue;
      end;

      if (pos('load', Line) = 1) then
      begin
        State := cState_load;
        LoadFname := nextp(Line, ' ', 1);
        if (LoadFName='') then
         LoadFName := RohdatenFName(pred(RohdatenCount));
        continue;
      end;

      if (pos('store', Line) = 1) then
      begin
        State := cState_store;
        LoadFname := ResolveParameter(nextp(Line, ' ', 1),ParameterL);
        continue;
      end;

      if pos('html', Line) = 1 then
      begin
        State := cState_html;
        htmlFName := nextp(Line, ' ', 1);
        continue;
      end;

      if pos('repeat', Line) = 1 then
      begin
        State := cState_repeat;
        _RepeatSQL := '';
        continue;
      end;

      if pos('basic', Line) = 1 then
      begin
        State := cState_BASIC;
        BASIC := TBasicProcessor.create;
        BASIC.DeviceOverride := 'null';
        continue;
      end;

      if pos('evaluation', Line) = 1 then
      begin
        State := cState_evaluation;
        continue;
      end;

      if pos('default', Line) = 1 then
      begin
        State := cState_default;
        continue;
      end;

      if pos('consult', Line) = 1 then
      begin
        State := cState_consult;
        LoadFname := nextp(Line, ' ', 1);
        InitJoin;
        LoadJoin;
        continue;
      end;

      if (Line = 'excel') then
      begin
        State := cState_excel;
        excelFormats.clear;
        xlsAutoOpen := false;
        xlsAutoPrint := false;
        xlsAutoHTML := false;
        xlsHTMLCopy := '';
        InitJoin;
        LoadJoin;
        continue;
      end;

      if (Line = 'append') then
      begin
        AppendMode := true;
        dec(RohdatenCount);
        continue;
      end;

      case State of
        cState_default:
          begin
            if Line = '-' then
              State := cState_Rohdaten;
          end;
        cState_excel:
          begin
            if (Line <> '-') then
            begin
              // optionen sammeln!
              if (Line = 'open') then
                xlsAutoOpen := true;
              if (Line = 'print') then
                xlsAutoPrint := true;
              if (pos('save as html', Line) = 1) then
              begin
                xlsAutoHTML := true;
                xlsHTMLCopy := ResolveParameter(
                  { } cutblank(nextp(Line, 'save as html', 1)),
                  { } ParameterL);
              end;

              if (pos('=', Line) > 0) then
                excelFormats.add(Line);
            end
            else
            begin
              if xlsAutoHTML then
              begin
                SaveJoinAsHTML;
                if (xlsHTMLCopy <> '') then
                  FileCopy(RohdatenHTMLFName(pred(RohdatenCount)), xlsHTMLCopy);
              end
              else
              begin
                SaveJoinAsExcel;
              end;

              if xlsAutoOpen then
                if (getValueofParameter('$ExcelOpen') <> cINI_deactivate) then
                begin
                  if xlsAutoHTML then
                    _(cFeedback_openShell,RohdatenHTMLFName(RohdatenCount))
                  else
                    _(cFeedback_openShell,RohdatenxlsFName(RohdatenCount));
                end;

              if xlsAutoPrint then
              begin
                if xlsAutoHTML then
                  _(cFeedback_Function+1{printhtmlok},RohdatenHTMLFName(RohdatenCount))
                else
                  _(cFeedback_Function+2{printShell},RohdatenxlsFName(RohdatenCount));
              end;

            end;
          end;
        cState_BASIC:
          if assigned(BASIC) then
          begin

            // Abschluss oder weitere Zeile?
            if (Line <> '-') then
            begin
              BASIC.add(Line);
            end
            else
            begin
              with BASIC do
              begin

                // ParameterL
                for m := 0 to pred(ParameterL.count) do
                  WriteVal(nextp(ParameterL[m], '=', 0), nextp(ParameterL[m], '=', 1));

                if RUN then
                begin
                  ParameterL.values['$RESULT'] := ReadVal('$RESULT');
                  if (BasicOutPut.count > 0) then
                  begin
                    // erweitere das aktuelle Skript nach dem "-"
                    for m := 0 to pred(BasicOutPut.count) do
                      Script.insert(succ(LineIndex + m), BasicOutPut[m]);
                  end;
                end
                else
                begin
                  ParameterL.values['$RESULT'] := HugeSingleLine(BasicErrors, '|');
                end;
              end;
              BASIC.free;
              BASIC := nil;
            end;

          end;
        cState_Rohdaten:
          begin

            // Eine einzelne Zeile draus machen
            repeat

              // Natürliches Ende
              if (LineIndex + 1 = Script.count) then
                break;

              // die erste Leerzeile markiert das Ende
              if cutblank(Script[LineIndex + 1]) = '' then
                break;

              inc(LineIndex);
              Line := Line + ' ' + nextp(Script[LineIndex], '--', 0);
            until false;

            Line := ResolveParameter(Line,ParameterL);

            if (Line <> '-') then
            begin
              SQL_ExecuteStatement := Line;
              setWaitCaption(inttostr(RohdatenCount) + ': ' + SQL_ExecuteStatement);

              // Ist es ein Select-Statement oder ein Script?
              if (pos('SELECT', AnsiUpperCase(cutblank(Line))) = 1) then
                ExportTable(SQL_ExecuteStatement, RohdatenFName(RohdatenCount), cOLAPcsvSeparator, AppendMode)
              else
                ExportScript(SQL_ExecuteStatement, RohdatenFName(RohdatenCount), cOLAPcsvSeparator);

              // Kopie speichern!
              SaveCopy(RohdatenFName(RohdatenCount));
              OLAP_Ergebnis_Count := RohdatenCount;

              //
              AppendMode := false;
              inc(RohdatenCount);
            end;

          end;
        cState_Cast:
          begin
            if (Line <> '-') then
            begin
              LoadFromFileCSV(true, sl, RohdatenFName(CastCount));
              while (Line <> '') do
              begin
                // commando ausarbeiten
                for m := 1 to pred(sl.count) do
                begin
                  sl[m] := nextp(nextp(sl[m], cOLAPcsvSeparator, 0), ' ', 0) + cOLAPcsvSeparator +
                    nextp(sl[m], cOLAPcsvSeparator, 1) + cOLAPcsvSeparator;
                end;
                break;
              end;
              sl.savetofile(RohdatenFName(CastCount));
              SaveCopy(RohdatenFName(CastCount));
            end;
            inc(CastCount);
          end;
        cState_consult:
          begin
            if (Line = '-') then
            begin
              //
              SaveJoin;
            end
            else
            begin

              // Immer zur aktuellen Liste noch die neuen Daten
              // hinzunehmen. Erscheinen neue Felder:
              // 1) modifiziere den Header (+neues Feld)
              // 2) erzeuge "Null" Daten für jedes neue Feld

              sl_ConsultIndex := TStringList.create;
              if not(FileExists(iOlapPath + LoadFname)) then
                raise Exception.create('Datei ' + iOlapPath + LoadFname + ' nicht gefunden!');
              LoadFromFileCSV(true, JoinL, iOlapPath + LoadFname);

              // Quell Spalte suchen
              AllHeader := TStringList(BigJoin[0]);
              col_Question := AllHeader.indexof(nextp(Line, ',', 0));
              if (col_Question = -1) then
                raise Exception.create('Referenzierende Spalte "' + nextp(Line, ',', 0) + '" nicht gefunden!');

              // Index und Antwort suchen
              col_ConsultAnswer := -1;
              col_ConsultIndex := -1;
              ThisHeaderAnz := 0;
              ThisHeader := JoinL[0];
              while (ThisHeader <> '') do
              begin
                inc(ThisHeaderAnz);
                OneHeader := nextp(ThisHeader, cOLAPcsvSeparator);
                repeat
                  //
                  if (OneHeader = nextp(Line, ',', 1)) then
                  begin
                    col_ConsultIndex := pred(ThisHeaderAnz);
                    break;
                  end;
                  //
                  if (OneHeader = nextp(Line, ',', 2)) then
                  begin
                    col_ConsultAnswer := pred(ThisHeaderAnz);
                    AllHeader.add(OneHeader);
                    break;
                  end;
                  break;
                until false;
              end;
              if (col_ConsultIndex = -1) then
                raise Exception.create('Referenz Spalte "' + nextp(Line, ',', 1) + '" in Datei "' + LoadFname +
                  '" nicht gefunden!');
              if (col_ConsultAnswer = -1) then
                raise Exception.create('Antwort Spalte "' + nextp(Line, ',', 2) + '" in Datei "' + LoadFname +
                  '" nicht gefunden!');

              // Antwort Index aufbauen
              for m := 1 to pred(JoinL.count) do
                sl_ConsultIndex.addobject(nextp(JoinL[m], cOLAPcsvSeparator, col_ConsultIndex), pointer(m));
              sl_ConsultIndex.sort;
              sl_ConsultIndex.sorted := true;

              // Doppelte sollten hier vermieden werden.
              if (RemoveDuplicates(sl_ConsultIndex) > 0) then
                raise Exception.create('Referenz Spalte "' + nextp(Line, ',', 1) + '" in Datei "' + LoadFname +
                  '" hat doppelte Einträge!');

              // Nun den Referenzierlauf
              for m := 1 to pred(BigJoin.count) do
              begin
                AllHeader := TStringList(BigJoin[m]);
                k := sl_ConsultIndex.indexof(AllHeader[col_Question]);
                if (k = -1) then
                  AllHeader.add(cOLAPNull)
                else
                  AllHeader.add(nextp(JoinL[integer(sl_ConsultIndex.objects[k])], cOLAPcsvSeparator,
                    col_ConsultAnswer));
              end;

              sl_ConsultIndex.free;

            end;

          end;
        cState_Oc:
          begin
            if (Line = '-') then
            begin
              for k := 0 to pred(Oc_Params.Count) do
               if (pos('copy ',Oc_Params[k])=1) then
                FileCopy(
                 {} nextp(Oc_Params[k],' ',1),
                 {} AnwenderPath+ExtractFileName(nextp(Oc_Params[k],' ',1)));
              doConversion(
               {} StrToIntDef(Oc_Params.Values['Modus'],Content_Mode_xls2xls),
               {} RohdatenxlsFName(RohdatenCount));

            end else
            begin
              Oc_Params.Add(Line);
            end;
          end;
        cState_story:
          begin
            if (Line = '-') then
            begin
              // Optimierungs-Möglichkeiten
              // a) im Rahmen eines einmaligen Parserlaufes die
              // Ankerspalten bestimmen, in ein Integerlist
              // speichern. Später gaanz schnell den Anker
              // zusammenbauen.
              // b) Eine IntergerList für die CopySpalten bilden

              StoryFree := TgpIntegerList.create;

              AllHeader := TStringList(BigJoin[0]);
              StoryMaxCol := AllHeader.count;
              LastAnker := '';
              LastAnkerLine := -1;
              for m := 1 to pred(BigJoin.count) do
              begin

                // aktuellen Ankerbestimmen
                AnkerParam := StatementParams.values['Anker'];
                AnkerValue := '';
                while (AnkerParam <> '') do
                begin
                  k := AllHeader.indexof(nextp(AnkerParam, cOLAPcsvSeparator));
                  if (k <> -1) then
                    AnkerValue := AnkerValue + TStringList(BigJoin[m])[k]
                  else
                    _(cFeedback_ShowMessage,'story: Anker ist unbekannt!');
                end;

                // die Zielspalte bestimmen
                TargetCol := AllHeader.indexof(StatementParams.values['Ziel']);

                if (AnkerValue = LastAnker) then
                begin
                  // diese Zeile erzählen
                  AnkerParam := StatementParams.values['Erzähle'];
                  while (AnkerParam <> '') do
                  begin
                    k := AllHeader.indexof(nextp(AnkerParam, cOLAPcsvSeparator));
                    if (k <> -1) then
                    begin
                      if (TargetCol = -1) then
                      begin
                        TStringList(BigJoin[LastAnkerLine]).add(TStringList(BigJoin[m])[k]);
                      end
                      else
                      begin
                        SortRow := cutblank(TStringList(BigJoin[m])[k]);
                        if (SortRow <> '') and (SortRow <> cOLAPNull) then
                        begin
                          SortStr := cutblank(TStringList(BigJoin[LastAnkerLine])[TargetCol]);
                          if (SortStr = '') or (SortStr = cOLAPNull) then
                            SortStr := TStringList(BigJoin[m])[k]
                          else
                            SortStr := SortStr + ', ' + cutblank(TStringList(BigJoin[m])[k]);
                          TStringList(BigJoin[LastAnkerLine])[TargetCol] := SortStr;
                        end;
                      end;
                    end;
                  end;
                  StoryMaxCol := max(StoryMaxCol, TStringList(BigJoin[LastAnkerLine]).count);
                  StoryFree.add(m);
                end
                else
                begin
                  LastAnker := AnkerValue;
                  LastAnkerLine := m;
                end;

              end;

              // Erzählte Zeilen löschen
              for m := pred(StoryFree.count) downto 0 do
                JoinDeleteLine(StoryFree[m]);

              // Titel Spalten mit Dummyies füllen
              for m := AllHeader.count to pred(StoryMaxCol) do
                AllHeader.add('C' + inttostr(m));

              StoryFree.free;
              SaveJoin;
            end
            else
            begin
              StatementParams.add(Line);
            end;

          end;
        cState_delete:
          begin
            if (Line = '-') then
            begin
              SaveJoin;
            end
            else
            begin
              k := strtointdef(Line, 0);
              if (k > 0) and (k <= TStringList(BigJoin[0]).count) then
                for m := 0 to pred(BigJoin.count) do
                  TStringList(BigJoin[m]).delete(pred(k));
            end;
          end;
        cState_Join:
          begin

            //
            if (Line = '-') then
            begin

              SaveJoin;

            end
            else
            begin

              // Immer zur aktuellen Liste noch die neuen Daten
              // hinzunehmen. Erscheinen neue Felder:
              // 1) modifiziere den Header (+neues Feld)
              // 2) erzeuge "Null" Daten für jedes neue Feld

              dec(RohdatenCount);
              LoadFromFileCSV(true, JoinL, RohdatenFName(RohdatenCount));

              // Header modifizieren
              ThisHeaderAnz := 0;
              ThisHeader := JoinL[0];
              AllHeader := TStringList(BigJoin[0]);
              while (ThisHeader <> '') do
              begin
                inc(ThisHeaderAnz);
                OneHeader := nextp(ThisHeader, cOLAPcsvSeparator);
                k := AllHeader.indexof(OneHeader);
                if (k = -1) then
                begin
                  // neues Feld, am Ende hinzu
                  AllHeader.add(OneHeader);
                  for m := 1 to pred(BigJoin.count) do
                    TStringList(BigJoin[m]).add('0');
                end;
              end;

              // Header Reihenfolge bestimmen
              ThisHeader := JoinL[0];
              SetLength(HeaderOrder, ThisHeaderAnz);
              for m := 0 to pred(ThisHeaderAnz) do
                HeaderOrder[m] := AllHeader.indexof(nextp(ThisHeader, cOLAPcsvSeparator));

              // Alle Daten nachtragen - In der richtigen Reihenfolge
              for m := 1 to pred(JoinL.count) do
              begin
                OneLine := JoinL[m];

                JoinedL := TStringList.create;
                BigJoin.add(JoinedL);

                for k := 0 to pred(AllHeader.count) do
                  JoinedL.add('0');

                for k := 0 to pred(ThisHeaderAnz) do
                  JoinedL[HeaderOrder[k]] := nextp(OneLine, cOLAPcsvSeparator);

              end;

            end;
          end;
        cState_add:
          begin
            if (Line = '-') then
            begin

              SaveJoin;

            end
            else
            begin

              AllHeader := TStringList(BigJoin[0]);
              JoinedL := TStringList.create;
              BigJoin.add(JoinedL);
              for k := 0 to pred(AllHeader.count) do
              begin
                SingleValue := nextp(Line, cOLAPcsvSeparator);
                if (SingleValue = '=SUMME') then
                begin
                  addValueD := 0.0;
                  for l := 1 to (BigJoin.count - 2) do
                    addValueD := addValueD + strtodoubledef(TStringList(BigJoin[l])[k], 0.0);
                  SingleValue := format('%.2f', [addValueD]);
                end;
                if (SingleValue = '=N') then
                begin
                  addValueI := 0;
                  for l := 1 to (BigJoin.count - 2) do
                    addValueI := addValueI + strtointdef(TStringList(BigJoin[l])[k], 0);
                  SingleValue := format('%d', [addValueI]);
                end;
                JoinedL.add(ResolveParameter(SingleValue,ParameterL));
              end;

            end;
          end;
        cState_extent:
          begin

            //
            if (Line = '-') then
            begin

              SaveJoin;

            end
            else
            begin

              // Immer zur aktuellen Liste noch die neuen Spalten rechts
              // erweitern hinzunehmen. Erweitert wird über die Spalte
              dec(RohdatenCount);
              LoadFromFileCSV(true, JoinL, RohdatenFName(RohdatenCount));

              // Header modifizieren
              ThisHeaderAnz := 0;
              ThisHeader := JoinL[0];
              AllHeader := TStringList(BigJoin[0]);
              while (ThisHeader <> '') do
              begin
                inc(ThisHeaderAnz);
                OneHeader := nextp(ThisHeader, cOLAPcsvSeparator);
                k := AllHeader.indexof(OneHeader);
                if (k = -1) then
                begin
                  // neues Feld, am Ende hinzu
                  AllHeader.add(OneHeader);
                  for m := 1 to pred(BigJoin.count) do
                    TStringList(BigJoin[m]).add('0');
                end;
              end;

              // Header Reihenfolge bestimmen
              ThisHeader := JoinL[0];
              SetLength(HeaderOrder, ThisHeaderAnz);
              for m := 0 to pred(ThisHeaderAnz) do
                HeaderOrder[m] := AllHeader.indexof(nextp(ThisHeader, cOLAPcsvSeparator));

              // Alle Daten nachtragen - In der richtigen Reihenfolge
              for m := 1 to pred(JoinL.count) do
              begin
                OneLine := JoinL[m];

                JoinedL := TStringList.create;
                BigJoin.add(JoinedL);

                for k := 0 to pred(AllHeader.count) do
                  JoinedL.add('0');

                for k := 0 to pred(ThisHeaderAnz) do
                  JoinedL[HeaderOrder[k]] := nextp(OneLine, cOLAPcsvSeparator);

              end;

            end;
          end;
        cState_List:
          begin
            if (Line = '-') then
            begin
              State := cState_Rohdaten;
            end
            else
            begin
              ListResults := TStringList.create;

              ListColName := Line;
              ListDistinct := pos('distinct', Line) > 0;
              ListNumeric := pos('numeric', Line) > 0;
              if ListDistinct then
                ersetze('distinct', '', ListColName);
              if ListNumeric then
                ersetze('numeric', '', ListColName);

              ListColName := cutblank(ListColName);

              AllHeader := TStringList(BigJoin[0]);
              ListCol := AllHeader.indexof(ListColName);
              if (ListCol <> -1) then
              begin
                //
                for m := 1 to pred(BigJoin.count) do
                begin
                  if (TStringList(BigJoin[m])[ListCol] = cOLAPNull) then
                  begin
                    ListResults.add('0');
                  end
                  else
                  begin
                    if ListNumeric then
                    begin
                      ListResults.add(TStringList(BigJoin[m])[ListCol]);
                    end
                    else
                    begin
                      ListResults.add('''' + TStringList(BigJoin[m])[ListCol] + '''');
                    end;
                  end;
                end;

                if ListDistinct then
                begin
                  ListResults.sort;
                  RemoveDuplicates(ListResults);
                end;

                ListResult := '(' + HugeSingleLine(ListResults, ', ') + ')';

                // Ausgabe in eine
                FileDelete(IncludeFName(ListCount));
                AppendStringsToFile(ListResult, IncludeFName(ListCount));
                inc(ListCount);

              end
              else
              begin
                raise Exception.create('list: Spalte ' + ListColName + ' nicht gefunden');
              end;
              ListResults.free;
            end;
          end;
        cState_repeat:
          begin
            //
            if (Line = '-') then
            begin
              StartWait := 0;
              inc(RohdatenCount);

              FileDelete(RohdatenFName(RohdatenCount));

              //
              cRepeat := nCursor;
              with cRepeat do
              begin
                SQL_ExecuteStatement := 'select * from ' + e_r_OLAP_Tabellenname(NameSpace,RohdatenCount - 2);
                sql.add(SQL_ExecuteStatement);
                setWaitCaption(SQL_ExecuteStatement);
                dbLog(sql);
                Open;
                RepeatFieldNames := dbOrgaMon.HeaderNames(cRepeat);
                ApiFirst;
                l := 0;
                _(cFeedback_ProgressBar_max+1,IntToStr(recordcount));
                while not(eof) do
                begin

                  if (RepeatFieldNames.Count=1) then
                  begin
                   // Sonderbehandlung bei nur einem Datenfeld, das
                   // heist dann IMMER einfach RID
                   ParameterL.values['$RID'] := Fields[0].AsString;
                  end else
                  begin
                    for k := 0 to pred(RepeatFieldNames.Count) do
                      ParameterL.values['$'+RepeatFieldNames[k]] := FieldByName(RepeatFieldNames[k]).AsString;
                  end;
                  RepeatSQL := ResolveParameter(_RepeatSQL,ParameterL);

                  while (RepeatSQL <> '') do
                  begin
                    SQL_ExecuteStatement := nextp(RepeatSQL, '~');
                    if (pos('SELECT', AnsiUpperCase(cutblank(SQL_ExecuteStatement))) = 1) then
                    begin
                      // select part
                      ExportTable(SQL_ExecuteStatement, RohdatenFName(RohdatenCount), cOLAPcsvSeparator, true);
                    end
                    else
                    begin
                      // update / insert part
                      e_x_sql(SQL_ExecuteStatement);
                    end;
                  end;
                  ApiNext;
                  inc(l);
                  if frequently(StartWait, 333) or eof then
                  begin
                    setWaitCaption(SQL_ExecuteStatement);
                    _(cFeedback_processmessages);
                    _(cFeedback_ProgressBar_Position+1,IntToStr( l));
                  end;
                end;
              end;
              _(cFeedback_ProgressBar_Position+1);
              RepeatFieldNames.free;
              cRepeat.free;
              //
              inc(RohdatenCount);
              State := cState_Rohdaten;
            end
            else
            begin
              _RepeatSQL := _RepeatSQL + ' ' + Line;
            end;
          end;
        cState_store:
          begin
            if (Line = '-') then
            begin
              if not(FileCompare(RohdatenFName(pred(RohdatenCount)), LoadFname)) then
              begin
                // use this
                FileVersionedCopy(RohdatenFName(pred(RohdatenCount)), LoadFname);
                // save secured version
                if (ParameterL.values['$salt']<>'') then
                 AddTableHash(LoadFName,ParameterL.values['$salt']);
              end else
              begin
                if (ParameterL.values['$salt']<>'') then
                  // if missing, create secured version
                  if not(FileExists(AddTableHashFName(LoadFName))) then
                    AddTableHash(LoadFName,ParameterL.values['$salt']);
              end;
              State := cState_Rohdaten;
            end;
          end;
        cState_load:
          begin

            if (Line = '-') then
            begin

              // Ist es eine Absolute Pfadangabe?
              if (pos(':', LoadFname) > 0) then
              begin
                if not(FileExists(LoadFname)) then
                  raise Exception.create('Datei "' + LoadFname + '" nicht gefunden!');
                FileCopy(LoadFname, iOlapPath + ExtractFileName(LoadFname));
                LoadFname := ExtractFileName(LoadFname);
              end;

              // gibt es die Quelle im OLAP-Pfad?
              if not(FileExists(iOlapPath + LoadFname)) then
                raise Exception.create('Datei "' + iOlapPath + LoadFname + '" nicht gefunden!');

              // bisherige Tabelle löschen
              DropTable(e_r_OLAP_Tabellenname(NameSpace,RohdatenCount));

              // jetzt wird die Tabelle angelegt
              LoadSQL := '';
              for m := pred(SpaltenNamen.count) downto 0 do
              begin
                LoadSQL := LoadSQL + nextp(SpaltenNamen[m], ' ', 0) + ' ' + nextp(SpaltenNamen[m], ' ', 1);
                if (m <> 0) then
                  LoadSQL := LoadSQL + ', ';
              end;

              if DROP_BUG then
              begin
               if not(TableExists(e_r_OLAP_Tabellenname(NameSpace,RohdatenCount))) then
                 e_x_sql('create table ' + e_r_OLAP_Tabellenname(NameSpace,RohdatenCount) + ' ( ' + LoadSQL + ')')
               else
                 _(cFeedback_ShowMessage,
                   {} 'Datenbank-Tabelle ' + e_r_OLAP_Tabellenname(NameSpace,RohdatenCount) + ':' + #13#10 +
                   {} 'sollte die Struktur' + #13#10 +
                   {} LoadSQL + #13#10 +
                   {} 'aufweisen, ansonsten geht der load schief!');
              end else
              begin
                e_x_sql('create table ' + e_r_OLAP_Tabellenname(NameSpace,RohdatenCount) + ' ( ' + LoadSQL + ')');
              end;

              LoadSQL := '';
              for m := pred(SpaltenNamen.count) downto 0 do
              begin
                LoadSQL := LoadSQL + nextp(SpaltenNamen[pred(SpaltenNamen.count) - m], ' ', 0);
                if (m <> 0) then
                  LoadSQL := LoadSQL + ',';
              end;
              LoadSQLinsert :=
               { } 'insert into ' +
               { } e_r_OLAP_Tabellenname(NameSpace,RohdatenCount) +
               { } ' (' + LoadSQL + ') values (';

              // QuellDatei laden
              InitJoin;
              LoadJoinFrom(LoadFname);

              // Quell Spalten Index anlegen
              LoadSpalte := TgpIntegerList.create;
              LoadSpalteType := TgpIntegerList.create;
              for m := 0 to pred(SpaltenNamen.count) do
              begin
                LoadSpalte.add(TStringList(BigJoin[0]).indexof(nextp(SpaltenNamen[m], ' ', 2)));
                if pos('CHAR', AnsiUpperCase(nextp(SpaltenNamen[m], ' ', 1))) > 0 then
                  LoadSpalteType.add(SQL_TEXT)
                else
                  LoadSpalteType.add(0);
              end;

              // jetzt gehts los! Insert Insert!
              _(cFeedback_ProgressBar_max+1,IntToStr(BigJoin.count));
              StartWait := 0;

              for m := 1 to pred(BigJoin.count) do
              begin

                //
                LoadSQLvalues := '';
                //
                for k := 0 to pred(SpaltenNamen.count) do
                begin

                  case LoadSpalteType[k] of
                    SQL_TEXT:
                      begin
                        LoadSQLvalue := TStringList(BigJoin[m])[LoadSpalte[k]];

                        // Unquote it
                        l := pos('"',LoadSQLvalue);
                        if l=1 then
                         LoadSQLvalue := ExtractSegmentBetween(LoadSQLvalue, '"', '"');

                        // Quote it
                        LoadSQLvalues := LoadSQLvalues + '''' + LoadSQLvalue + '''';

                      end;
                  else
                    LoadSQLvalues := LoadSQLvalues + TStringList(BigJoin[m])[LoadSpalte[k]];

                  end;

                  if (k < pred(SpaltenNamen.count)) then
                    LoadSQLvalues := LoadSQLvalues + ',';
                end;

                e_x_sql(LoadSQLinsert + LoadSQLvalues + ')');

                if frequently(StartWait, 333) then
                begin
                  setWaitCaption(LoadSQLvalues);
                  _(cFeedback_ProgressBar_Position+1,IntTOstr( m));
                  _(cFeedback_processmessages);
                end;

              end;
              FreeAndNil(LoadSpalte);
              FreeAndNil(LoadSpalteType);
              FreeAndNil(SpaltenNamen);
              _(cFeedback_ProgressBar_Position+1);

              State := cState_Rohdaten;
            end
            else
            begin

              // Spaltennamen aufsammeln
              if not(assigned(SpaltenNamen)) then
                SpaltenNamen := TStringList.create;
              if (Line <> '') then
                SpaltenNamen.add(Line);
            end;
          end;
        cState_html:
          begin

            if (Line = '-') then
            begin
              html := THTMLTemplate.create;
              html.loadfromFile(HTMLVorlagenPath + htmlFName + cHTMLextension);
              html.WriteValue(ParameterL);
              html.SaveToFileCompressed(htmlSaveFName);
              html.free;
              SaveCopy(htmlSaveFName);
            end else
            begin

              // Hier noch html-variable Hinzufügbar machen usw.
              if pos('save', Line) = 1 then
                htmlSaveFName := fromP(Line, ' ', 1);
              if pos('open', Line) = 1 then
                raise Exception.create('open ist nicht implementiert');

              if pos('print', Line) = 1 then
                raise Exception.create('print ist nicht implementiert');

            end;
          end;
        cState_Save:
          begin
            if (Line <> '-') then
            begin
              LoadSpalte := TgpIntegerList.create;
              ListColName := Line;
              ListNumeric := pos('numeric', Line) > 0;
              if ListNumeric then
                ersetze('numeric', '', ListColName);
              ListColName := cutblank(ListColName);
              AllHeader := TStringList(BigJoin[0]);
              ListCol := AllHeader.indexof(ListColName);
              if (ListCol <> -1) then
              begin
                e_n_OLAP(NameSpace,pred(RohdatenCount));
                if ListNumeric then
                  for m := 1 to pred(BigJoin.count) do
                    if (TStringList(BigJoin[m])[ListCol] <> cOLAPNull) then
                    begin
                      k := strtointdef(TStringList(BigJoin[m])[ListCol], cRID_UnSet);
                      if (k <> cRID_UnSet) then
                        if (LoadSpalte.indexof(k) = -1) then
                          LoadSpalte.add(k);
                    end;
                e_w_OLAP(NameSpace,pred(RohdatenCount), LoadSpalte);
              end
              else
              begin
                _(cFeedback_ShowMessage,'save: Spalte ' + ListColName + ' nicht gefunden!');
              end;
              LoadSpalte.free;
              State := cState_Rohdaten;
            end;
          end;
        cState_spread:
          begin

            if (Line = '-') then
            begin
              SaveJoin;
            end
            else
            begin

              SpreadColName := TStringList(BigJoin[0])[1];
              VerlagL := TgpIntegerList.create;
              for m := 1 to pred(BigJoin.count) do
                if (TStringList(BigJoin[m])[1] <> cOLAPNull) then
                  if VerlagL.indexof(strtointdef(TStringList(BigJoin[m])[1], 0)) = -1 then
                    VerlagL.add(strtointdef(TStringList(BigJoin[m])[1], 0));

              VerlagL.sort;
              SpaltenIst := TStringList(BigJoin[0]).count;
              SpaltenSoll := SpaltenIst + VerlagL.count;
              for m := 0 to pred(VerlagL.count) do
                TStringList(BigJoin[0]).add(SpreadColName + '_' + inttostr(VerlagL[m]));

              for m := 1 to pred(BigJoin.count) do
              begin
                for l := 1 to m do // von oben bis zu dieser Zeile suchen
                begin
                  if (TStringList(BigJoin[m])[0] = TStringList(BigJoin[l])[0]) then
                  begin
                    k := VerlagL.indexof(strtointdef(TStringList(BigJoin[m])[1], 0));

                    // ggf. die Breite der Zeile sicherstellen
                    while TStringList(BigJoin[l]).count < SpaltenSoll do
                      TStringList(BigJoin[l]).add('0');

                    TStringList(BigJoin[l])[k + SpaltenIst] :=
                      inttostr(strtointdef(TStringList(BigJoin[l])[k + SpaltenIst], 0) +
                      strtointdef(TStringList(BigJoin[m])[2], 0));

                    break;
                  end;
                end;
              end;

              for m := pred(BigJoin.count) downto 1 do
                if TStringList(BigJoin[m]).count <> SpaltenSoll then
                begin
                  TStringList(BigJoin[m]).free;
                  BigJoin.delete(m);
                end;

              VerlagL.free;
            end;

          end;
        cState_spread2:
          begin

            if (Line = '-') then
            begin
              SaveJoin;
            end
            else
            begin
              SpreadColName := TStringList(BigJoin[0])[1];
              SpreadTitle := TStringList.create;

              // alle neuen Spalten Überschriften sammeln
              for m := 1 to pred(BigJoin.count) do
                if (TStringList(BigJoin[m])[1] <> cOLAPNull) then
                  if SpreadTitle.indexof(TStringList(BigJoin[m])[1]) = -1 then
                    SpreadTitle.add(TStringList(BigJoin[m])[1]);

              // die gesammelten Überschriften nun oben eintragen
              SpaltenIst := TStringList(BigJoin[0]).count;
              SpaltenSoll := SpaltenIst + SpreadTitle.count;
              for m := 0 to pred(SpreadTitle.count) do
                TStringList(BigJoin[0]).add(SpreadColName + '_' + SpreadTitle[m]);

              // nun summieren ...
              for m := 1 to pred(BigJoin.count) do
              begin
                // von oben bis zum Integrationsanker (Spalte 1) suchen
                for l := 1 to m do
                begin
                  // Ist "Name" identisch?
                  if (TStringList(BigJoin[m])[0] = TStringList(BigJoin[l])[0]) then
                  begin
                    k := SpreadTitle.indexof(TStringList(BigJoin[m])[1]);

                    // ggf. die Breite der Zeile sicherstellen
                    while TStringList(BigJoin[l]).count < SpaltenSoll do
                      TStringList(BigJoin[l]).add('0');

                    TStringList(BigJoin[l])[k + SpaltenIst] :=
                      inttostr(strtointdef(TStringList(BigJoin[l])[k + SpaltenIst], 0) +
                      strtointdef(TStringList(BigJoin[m])[2], 0));

                    break;
                  end;
                end;
              end;

              //
              for m := pred(BigJoin.count) downto 1 do
                if TStringList(BigJoin[m]).count <> SpaltenSoll then
                begin
                  TStringList(BigJoin[m]).free;
                  BigJoin.delete(m);
                end;

              // Spalte 2+3 löschen!

              SpreadTitle.free;
            end;

          end;
        cState_Assign:
          begin

            if (Line = '-') then
            begin

              SaveJoin;

            end
            else
            begin

              //
              AssignDatumCol := TStringList(BigJoin[0]).indexof(nextp(Line, ' ', 0));
              AssignWertCol := TStringList(BigJoin[0]).indexof(nextp(Line, ' ', 1));

              // Header um die Zeiten $Start ... $Ende erweitern
              MonatsNamen := TStringList.create;
              MonatsSpaltenOffset := TStringList(BigJoin[0]).count;
              AssignStart := date2long(ResolveParameter('$Start',ParameterL));
              AssignEnde := date2long(ResolveParameter('$Ende',ParameterL));
              AssignRun := AssignStart;
              repeat

                //
                MonatsName := AssignDate(AssignRun);
                if (MonatsNamen.indexof(MonatsName) = -1) then
                begin
                  MonatsNamen.add(MonatsName);
                  TStringList(BigJoin[0]).add(MonatsName);
                end;

                //
                if (AssignRun = AssignEnde) then
                  break;
                AssignRun := DatePlus(AssignRun, 1);
              until false;

              // Unscharf machen
              for m := 1 to pred(BigJoin.count) do
              begin
                MonatsName := AssignDate(date2long(nextp(TStringList(BigJoin[m])[AssignDatumCol], ' ', 0)));
                MonatsN := MonatsNamen.indexof(MonatsName);
                AssignWert := format('%.2m', [strtodouble(TStringList(BigJoin[m])[AssignWertCol])]);
                TStringList(BigJoin[m])[AssignWertCol] := AssignWert;

                for k := 0 to pred(MonatsNamen.count) do
                  if (k = MonatsN) then
                    TStringList(BigJoin[m]).add(AssignWert)
                  else
                    TStringList(BigJoin[m]).add('0 €');
              end;
              MonatsNamen.free;
            end;

          end;
        cState_Complete, cState_replace:
          begin

            if (Line = '-') then
            begin

              SaveJoin;

            end
            else
            begin

              // Name der neuen Spalte(n) hinzufügen
              ReplaceIndex := -1;
              CompleteHeader.clear;
              NewColumnName := nextp(Line, ' ', max(1, CharCount(' ', Line)));
              if (NewColumnName = '') then
                NewColumnName := nextp(Line, '(', 0);

              //
              AllHeader := TStringList(BigJoin[0]);
              if (State = cState_replace) then
              begin
                ReplaceIndex := AllHeader.indexof(NewColumnName);
                if ReplaceIndex = -1 then
                  raise Exception.create('replace Spalte "' + NewColumnName + '" nicht gefunden!');
              end
              else
              begin
                while (NewColumnName <> '') do
                begin
                  CompleteResult := nextp(NewColumnName, cOLAPcsvSeparator);
                  AllHeader.add(nextp(CompleteResult, ':', 0));
                  CompleteHeader.add(CompleteResult);
                end;
              end;

              _(cFeedback_ProgressBar_max+1,IntToStr( BigJoin.count));
              StartWait := 0;
              for m := 1 to pred(BigJoin.count) do
              begin

                if frequently(StartWait, 333) then
                begin
                  _(cFeedback_ProgressBar_Position+1,IntToStr( m));
                  _(cFeedback_processmessages);
                end;

                if (pos(' ', Line) > 0) then
                  FullLine := copy(Line, 1, pred(revpos(' ', Line)))
                else
                  FullLine := Line;

                CompleteResult := '';
                while (FullLine <> '') do
                begin
                  sLine := nextp(FullLine, cC_concant);

                  // Ersetzen-Funktion
                  ParamFunction := nextp(sLine, '(', 0);

                  // Quell-Parameter
                  ParamAll := ExtractSegmentBetween(sLine, '(', ')');
                  ParamConstant := ExtractSegmentBetween(sLine, '"', '"');
                  if (ParamConstant = '') then
                  begin

                    // 2. Parameter
                    ParamCol := AllHeader.indexof(nextp(ParamAll, ',', 1));
                    if (ParamCol <> -1) then
                      ParamVal2 := TStringList(BigJoin[m])[ParamCol]
                    else
                      ParamVal2 := '';

                    // 1. Parameter
                    ParamCol := AllHeader.indexof(nextp(ParamAll, ',', 0));
                    if (ParamCol <> -1) then
                      ParamVal1 := TStringList(BigJoin[m])[ParamCol]
                    else
                      ParamVal1 := '';

                  end
                  else
                  begin
                    ParamVal1 := '';
                    ParamVal2 := '';
                  end;

                  CompleteResult := CompleteResult + completeFunc(TStringList(BigJoin[m]));
                end;

                if (ReplaceIndex <> -1) then
                begin
                  TStringList(BigJoin[m])[ReplaceIndex] := CompleteResult;
                end
                else
                begin
                  // Nun die Werte zur Tabelle dazu!
                  CompleteResultL := split(CompleteResult, cOLAPcsvSeparator);
                  TStringList(BigJoin[m]).AddStrings(CompleteResultL);
                  CompleteResultL.free;
                end;

              end;
              _(cFeedback_ProgressBar_Position+1);
            end;
          end;
        cState_table:
          begin

            if (Line = '-') then
            begin

              SaveJoin;

            end
            else
            begin

              TabelleHorizontal := TsTable.create;
              TabelleHorizontal.insertFromFile(RohdatenFName(pred(RohdatenCount)));

              // Es kommen alle Zellen der ersten Datenspalte hinzu
              CompleteHeader.clear;
              AllHeader := TStringList(BigJoin[0]);
              for m := 1 to pred(TabelleHorizontal.count) do
              begin
                CompleteResult := TabelleHorizontal.readCell(m, 0);
                AllHeader.add(nextp(CompleteResult, ':', 0));
                CompleteHeader.add(CompleteResult);
              end;

              _(cFeedback_ProgressBar_max+1,IntTOStr(pred(BigJoin.count) * pred(TabelleHorizontal.count)));
              StartWait := 0;
              k := 0;
              for l := 1 to pred(TabelleHorizontal.count) do
              begin
                // $-Parameter
                for m := 0 to pred(TabelleHorizontal.Header.count) do
                  ParameterL.values['$' + TabelleHorizontal.Header[m]] := TabelleHorizontal.readCell(l, m);

                for m := 1 to pred(BigJoin.count) do
                begin

                  if frequently(StartWait, 333) then
                  begin
                    _(cFeedback_ProgressBar_Position+1,IntToStr(k));
                    _(cFeedback_processmessages);
                  end;

                  if (pos(' ', Line) > 0) then
                    FullLine := copy(Line, 1, pred(revpos(' ', Line)))
                  else
                    FullLine := Line;

                  CompleteResult := '';
                  while (FullLine <> '') do
                  begin
                    sLine := nextp(FullLine, cC_concant);

                    // Ersetzen-Funktion
                    ParamFunction := nextp(sLine, '(', 0);

                    // Quell-Parameter
                    ParamAll := ExtractSegmentBetween(sLine, '(', ')');
                    ParamConstant := ExtractSegmentBetween(sLine, '"', '"');
                    if (ParamConstant = '') then
                    begin

                      // 2. Parameter
                      ParamCol := AllHeader.indexof(nextp(ParamAll, ',', 1));
                      if (ParamCol <> -1) then
                        ParamVal2 := TStringList(BigJoin[m])[ParamCol]
                      else
                        ParamVal2 := TabelleHorizontal.readCell(l, TabelleHorizontal.colOf(nextp(ParamAll, ',', 1)));

                      // 1. Parameter
                      ParamCol := AllHeader.indexof(nextp(ParamAll, ',', 0));
                      if (ParamCol <> -1) then
                        ParamVal1 := TStringList(BigJoin[m])[ParamCol]
                      else
                        ParamVal1 := TabelleHorizontal.readCell(l, TabelleHorizontal.colOf(nextp(ParamAll, ',', 0)));

                    end
                    else
                    begin
                      ParamVal1 := '';
                      ParamVal2 := '';
                    end;

                    CompleteResult := CompleteResult + completeFunc(TStringList(BigJoin[m]));
                  end;

                  // Nun die Werte zur Tabelle dazu!
                  if (CompleteResult = '') then
                  begin
                    TStringList(BigJoin[m]).add('');
                  end
                  else
                  begin
                    while (CompleteResult <> '') do
                      TStringList(BigJoin[m]).add(nextp(CompleteResult, cOLAPcsvSeparator));
                  end;
                  inc(k);
                end;
              end;
              _(cFeedback_ProgressBar_Position+1);
              TabelleHorizontal.free;
            end;
          end;
        cState_Integrate:
          begin
            if (Line <> '-') then
            begin

              // Aufsummieren und Integrale bilden
              LoadFromFileCSV(true, sl, RohdatenFName(pred(RohdatenCount)));

              // Header unbehandelt hinzu
              ThisHeader := sl[0];
              IntegratedL.add(TStringList.create);
              with TStringList(IntegratedL[0]) do
              begin
                while (ThisHeader <> '') do
                  add(nextp(ThisHeader, cOLAPcsvSeparator));
              end;

              DatumGranularitaet := TDG_Monat; // default!
              if (pos('Week', Line) > 0) then
                DatumGranularitaet := TDG_Woche;
              if (pos('Year', Line) > 0) then
                DatumGranularitaet := TDG_Jahr;
              if (pos('Quarter', Line) > 0) then
                DatumGranularitaet := TDG_Quartal;
              if (pos('Day', Line) > 0) then
                DatumGranularitaet := TDG_Tag;

              for m := 1 to pred(sl.count) do
              begin

                //
                OneLine := sl[m];

                // Datum erstellen
                DatumS := nextp(OneLine, cOLAPcsvSeparator);
                DatumS := nextp(DatumS, ' '); // ev. ist es ein Timestamp!
                case DatumGranularitaet of
                  TDG_Woche:
                    DatumS := copy(DatumS, 7, 4) + '_KW' + inttostrN(Kalenderwoche(date2long(DatumS)), 2);
                  TDG_Monat:
                    DatumS := copy(DatumS, 7, 4) + '_' + copy(DatumS, 4, 2);
                  TDG_Quartal:
                    DatumS := copy(DatumS, 7, 4) + '_Q' + inttostr(Quartal(date2long(DatumS)));
                  TDG_Jahr:
                    DatumS := copy(DatumS, 7, 4);
                end;

                // nun dieses in der vorhandenen Liste suchen, ggf neue Zeile erstellen
                IntegratFound := false;
                for k := 1 to pred(IntegratedL.count) do
                begin
                  if (DatumS = TStringList(IntegratedL[k])[0]) then
                  // ^ imp pend: Im moment GROUP BY nur auf erstes Feld möglich
                  begin
                    // ok gefunden -> jetzt summieren / integrieren
                    IntegrateCol := 0;
                    while (OneLine <> '') do
                    begin
                      inc(IntegrateCol);
                      SingleValue := nextp(OneLine, cOLAPcsvSeparator);
                      //
                      if (SingleValue <> cOLAPNull) then
                      begin
                        if (pos(',', SingleValue + TStringList(IntegratedL[k])[IntegrateCol]) > 0) then
                        begin
                          // DOUBLE - Typ
                          TStringList(IntegratedL[k])[IntegrateCol] :=
                            format('%.2f', [strtodouble(TStringList(IntegratedL[k])[IntegrateCol]) +
                            strtodouble(SingleValue)]);
                        end
                        else
                        begin
                          // INTEGER - Typ
                          TStringList(IntegratedL[k])[IntegrateCol] :=
                            format('%d', [strtoint(TStringList(IntegratedL[k])[IntegrateCol]) + strtoint(SingleValue)]);
                        end;
                      end;
                    end;
                    IntegratFound := true;
                    break;
                  end;
                end;

                if not(IntegratFound) then
                begin

                  // Zeile neu hinzu
                  IntegratedNewL := TStringList.create;
                  IntegratedL.add(IntegratedNewL);
                  with IntegratedNewL do
                  begin
                    add(DatumS);
                    while (OneLine <> '') do
                      add(nextp(OneLine, cOLAPcsvSeparator));
                  end;
                end;
              end;

              // speichern
              sl.clear;
              for m := 0 to pred(IntegratedL.count) do
                sl.add(HugeSingleLine(TStringList(IntegratedL[m]), cOLAPcsvSeparator));

              sl.savetofile(RohdatenFName(RohdatenCount));
              SaveCopy(RohdatenFName(RohdatenCount));
              OLAP_Ergebnis_Count := RohdatenCount;
              inc(RohdatenCount);
            end;
          end;
        cState_Integrate2:
          begin
            if (Line <> '-') then
            begin

              // Aufsummieren und Integrale bilden
              LoadFromFileCSV(true, sl, RohdatenFName(pred(RohdatenCount)));

              // Header unbehandelt hinzu
              ThisHeader := sl[0];
              IntegratedL.add(TStringList.create);
              with TStringList(IntegratedL[0]) do
              begin
                while (ThisHeader <> '') do
                  add(nextp(ThisHeader, cOLAPcsvSeparator));
              end;

              // Welche Spalte soll als Integrations-Anker verwendet werden
              AktAnker := nextp(Line, ' ', 0);
              IntegrateAnkerCol := TStringList(IntegratedL[0]).indexof(AktAnker);
              if (IntegrateAnkerCol <> -1) then
              begin

                for m := 1 to pred(sl.count) do
                begin

                  //
                  OneLine := sl[m];

                  // Anker ermitteln
                  AnkerS := nextp(OneLine, cOLAPcsvSeparator, IntegrateAnkerCol);

                  // nun dieses in der vorhandenen Liste suchen, ggf neue Zeile erstellen
                  IntegratFound := false;
                  for k := 1 to pred(IntegratedL.count) do
                  begin
                    if (AnkerS = TStringList(IntegratedL[k])[IntegrateAnkerCol]) then
                    begin
                      // ok gefunden -> jetzt summieren / integrieren
                      IntegrateCol := 0;
                      while (OneLine <> '') do
                      begin
                        SingleValue := nextp(OneLine, cOLAPcsvSeparator);
                        //
                        if (pos(cMonetarySymbol, SingleValue) > 0) then
                        begin
                          // DOUBLE - Typ
                          TStringList(IntegratedL[k])[IntegrateCol] :=
                            format('%.2m', [strtodouble(TStringList(IntegratedL[k])[IntegrateCol]) +
                            strtodouble(SingleValue)]);
                        end;
                        inc(IntegrateCol);
                      end;
                      IntegratFound := true;
                      break;
                    end;
                  end;

                  if not(IntegratFound) then
                  begin

                    // Zeile neu hinzu
                    IntegratedNewL := TStringList.create;
                    IntegratedL.add(IntegratedNewL);
                    with IntegratedNewL do
                    begin
                      while (OneLine <> '') do
                        add(nextp(OneLine, cOLAPcsvSeparator));
                    end;
                  end;

                end;

                // speichern
                sl.clear;
                for m := 0 to pred(IntegratedL.count) do
                  sl.add(HugeSingleLine(TStringList(IntegratedL[m]), cOLAPcsvSeparator));

                sl.savetofile(RohdatenFName(RohdatenCount));
                SaveCopy(RohdatenFName(RohdatenCount));
                OLAP_Ergebnis_Count := RohdatenCount;
                inc(RohdatenCount);
              end
              else
              begin
                _(cFeedback_ShowMessage,cERRORText + ' Spalte "' + AktAnker + '" nicht gefunden!');
              end;
            end;
          end;
        cState_integrate3:
          begin

            // Aufsummieren und Integrale bilden
            LoadFromFileCSV(true, sl, RohdatenFName(pred(RohdatenCount)));

            // Header unbehandelt hinzu
            ThisHeader := sl[0];
            IntegratedL.add(TStringList.create);
            with TStringList(IntegratedL[0]) do
            begin
              while (ThisHeader <> '') do
                add(nextp(ThisHeader, cOLAPcsvSeparator));
            end;

            // Welche Spalte soll als Integrations-Anker verwendet werden
            IntegrateAnkerCol := TStringList(IntegratedL[0]).indexof('GROUP BY');

            for m := 1 to pred(sl.count) do
            begin

              //
              OneLine := sl[m];

              // Anker ermitteln
              AnkerS := nextp(OneLine, cOLAPcsvSeparator, IntegrateAnkerCol);

              // nun diesen Ankerwert in der vorhandenen Liste suchen, ggf neue Zeile erstellen
              IntegratFound := false;
              for k := 1 to pred(IntegratedL.count) do
              begin
                if (AnkerS = TStringList(IntegratedL[k])[IntegrateAnkerCol]) then
                begin
                  // ok gefunden -> jetzt summieren / integrieren
                  IntegrateCol := 0;
                  while (OneLine <> '') do
                  begin

                    SingleValue := nextp(OneLine, cOLAPcsvSeparator);

                    repeat

                      // Nichts tun bei der Ankerspalte
                      if IntegrateCol = IntegrateAnkerCol then
                        break;

                      if (SingleValue = cOLAPNull) then
                        break;

                      // Was soll mit dieser Spalte gemacht werden
                      IntegrateOperation := TStringList(IntegratedL[0])[IntegrateCol];

                      // nix
                      if (IntegrateOperation = '') then
                        break;

                      // d+d
                      if (IntegrateOperation = 'add MONEY') then
                      begin
                        // Geld addieren
                        TStringList(IntegratedL[k])[IntegrateCol] :=
                        { } MoneyToStr(
                          { } StrToMoneyDef(TStringList(IntegratedL[k])[IntegrateCol]) +
                          { } StrToMoneyDef(SingleValue)
                          { } );
                        break;
                      end;

                      if (IntegrateOperation = 'add INTEGER') then
                      begin
                        // Geld addieren
                        TStringList(IntegratedL[k])[IntegrateCol] :=
                        { } inttostr(
                          { } strtointdef(TStringList(IntegratedL[k])[IntegrateCol], 0) +
                          { } strtointdef(SingleValue, 0)
                          { } );
                        break;
                      end;

                      TStringList(IntegratedL[k])[IntegrateCol] := 'ERROR: Operation "' + IntegrateOperation +
                        '" unbekannt';

                    until yet;

                    inc(IntegrateCol);
                  end;
                  IntegratFound := true;
                  break;
                end;
              end;

              if not(IntegratFound) then
              begin

                // Zeile 1:1 neu hinzu
                IntegratedNewL := TStringList.create;
                IntegratedL.add(IntegratedNewL);
                with IntegratedNewL do
                begin
                  while (OneLine <> '') do
                    add(nextp(OneLine, cOLAPcsvSeparator));
                end;
              end;

            end;

            // speichern
            sl.clear;
            for m := 0 to pred(IntegratedL.count) do
              sl.add(HugeSingleLine(TStringList(IntegratedL[m]), cOLAPcsvSeparator));

            sl.savetofile(RohdatenFName(RohdatenCount));
            SaveCopy(RohdatenFName(RohdatenCount));
            OLAP_Ergebnis_Count := RohdatenCount;
            inc(RohdatenCount);
          end;
        cState_header:
          begin
            if (Line <> '-') then
            begin
              // Einfach die Kopfzeile austauschen
              LoadFromFileCSV(true, sl, RohdatenFName(pred(RohdatenCount)));
              sl[0] := Line;
              sl.savetofile(RohdatenFName(RohdatenCount));
              SaveCopy(RohdatenFName(RohdatenCount));
              OLAP_Ergebnis_Count := RohdatenCount;
              inc(RohdatenCount);
            end;
          end;
        cState_subtract:
          begin
            if (Line = '-') then
            begin
              RedList := TStringList.create;
              LoadFromFileCSV(true, RedList, RohdatenFName(RohdatenCount - 2));
              RedList.delete(0);
              for m := 0 to pred(RedList.count) do
                RedList[m] := nextp(RedList[m], cOLAPcsvSeparator, 0);
              RedList.sort;
              for m := pred(BigJoin.count) downto 1 do
                if (RedList.indexof(TStringList(BigJoin[m])[0]) <> -1) then
                  JoinDeleteLine(m);
              SaveJoin;
            end;
          end;
        cState_evaluation:
          begin
            if (Line = '-') then
            begin
              State := cState_Rohdaten;
            end
            else
            begin
              if FileExists(iOlapPath + Line + cVorlageExtension + cSpreadsheetExtension) then
              begin
                _(cFeedback_Function+4{FormAuswertung.vorlageOLAP},Line); // , true);
                // Imp pend: Da Auswertungen auch wieder OLAP rufen
                // ist die Fortsetzung des Skripts nicht möglich
                // hier muss Schluss sein!
                break;
              end;
            end;
          end;
        cState_Sort:
          begin
            if (Line <> '-') then
            begin
              // Aktuelle Datei sortieren
              ClientSorter := TStringList.create;
              SortResult := TStringList.create;
              AllHeader := TStringList.create;

              // Quelle laden, alle Header aufzeichnen
              LoadFromFileCSV(true, sl, RohdatenFName(pred(RohdatenCount)));
              ThisHeader := sl[0];
              while (ThisHeader <> '') do
                AllHeader.add(nextp(ThisHeader, cOLAPcsvSeparator));
              for m := 1 to pred(sl.count) do
                ClientSorter.addobject('', TObject(m));
              while (Line <> '') do
              begin
                SortRow := nextp(Line, cOLAPcsvSeparator);
                FormatNumeric := pos('numeric', SortRow) > 0;
                if FormatNumeric then
                  ersetze('numeric', '', SortRow);
                DoReverse := pos('descending', SortRow) > 0;
                if DoReverse then
                  ersetze('descending', '', SortRow)
                else
                  ersetze('ascending', '', SortRow);
                SortRow := cutblank(SortRow);
                k := AllHeader.indexof(SortRow);
                if (k = -1) then
                  k := 0;
                for m := 1 to pred(sl.count) do
                begin
                  SortStr := nextp(sl[m], cOLAPcsvSeparator, k);
                  if FormatNumeric then
                    SortStr := inttostrN(round(strtodoubledef(SortStr, 0) * 100.0), 15);
                  if DoReverse and FormatNumeric then
                    for l := 1 to length(SortStr) do
                      SortStr[l] := chr(ord('0') + pred(pos(SortStr[l], '9876543210')));
                  ClientSorter[pred(m)] := ClientSorter[pred(m)] + SortStr;
                end;
              end;
              ClientSorter.sort;
              SortResult.add(sl[0]);
              for m := 0 to pred(ClientSorter.count) do
                SortResult.add(sl[integer(ClientSorter.objects[m])]);
              SortResult.savetofile(RohdatenFName(RohdatenCount));
              SaveCopy(RohdatenFName(RohdatenCount));
              OLAP_Ergebnis_Count := RohdatenCount;
              inc(RohdatenCount);
              SortResult.free;
              ClientSorter.free;
              AllHeader.free;
            end;
          end;
      end;
    until false;
    setWaitCaption('#');
    result := true;
  except
    on E: Exception do
    begin
      _(cFeedback_ShowMessage,
        { } 'FILE: ' + FName + #13 +
        { } HugeSingleLine(ParameterL, #13) + #13 +
        { } 'LINE: '+ Line_ExecuteStatement + #13 +
        { } 'SQL: ' + SQL_ExecuteStatement + #13 +
        { } #13 +
        { } cERRORText + ' ' + E.Message
        { } );
    end;
  end;

  // letzte CSV Ausgabe speichern
  if (OLAP_Ergebnis_Count<>-1) then
   FileCopy(
    {} RohdatenFName(OLAP_Ergebnis_Count),
    {} iOlapPath + cOLAP_ErgebnisFName);

  sl.free;
  StatementParams.free;
  JoinL.free;
  ParameterL.free;
  excelFormats.free;
  CompleteHeader.free;
  Oc_Params.free;
end;

function ResolveParameter(s: string; ParameterL: TStringList): string;

  function getValueofParameter(ParamS: string): string;
  begin
    result := ParameterL.values[ParamS];
    if (length(result) = 7) then
      if (result[1] = '#') then
        result := inttostr(HTMLColor2TColor(result));
  end;

var
  i, k, l: integer;
  IsNumeric: boolean;
begin

  //
  result := s;
  ersetze('$$', '€€', result);
  i := 0;
  repeat

    k := pos('$', result);
    if k = 0 then
      break;
    l := min(k + 1, length(result));
    IsNumeric := true;
    repeat
      if (l > length(result)) then
        break;
      if not CharInSet(result[l], ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '_']) then
        break;
      if IsNumeric then
        if not CharInSet(result[l], ['0' .. '9']) then
          IsNumeric := false;
      inc(l);
    until false;
    if IsNumeric then
      ersetze(copy(result, k, l - k), LoadSQLInclude(strtoint(copy(result, k, l - k))), result)
    else
      ersetze(copy(result, k, l - k), getValueofParameter(copy(result, k, l - k)), result);

    // Iterationskontrolle
    inc(i);
    if (i > 100) then
      break;

  until false;
  ersetze('€€', '$', result);
end;

function e_r_OLAP(OLAP: TStringList; Params: TStringList): TStringList; overload;
var
  ParameterL: TStringList;

  function ResolveParameter(s: string): string;
  var
    k, l: integer;
  begin
    //
    result := s;
    ersetze('$$', '€€', result);
    repeat

      // Anfangsposition bestimmen
      k := pos('$', result);
      if (k = 0) then
        break;

      // Länge bestimmen
      l := min(k + 1, length(result));
      repeat
        if (l > length(result)) then
          break;
        if not CharInSet (result[l], ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '_']) then
          break;
        inc(l);
      until eternity;

      // Nun austauschen
      ersetze(copy(result, k, l - k), ParameterL.Values[copy(result, k, l - k)], result);

    until eternity;
    ersetze('€€', '$', result);
  end;

var
  cOLAP: TdboCursor;
  OneLine: string;
  sSQL: string;
  n, k: integer;
  AutoMataState: integer;
  EmptyLine: boolean;
begin
  result := TStringList.create;
  ParameterL := TStringList.create;
  ParameterL.AddStrings(Params);
  AutoMataState := 0;
  for n := 0 to pred(OLAP.count) do
  begin

    OneLine := cutblank(OLAP[n]);
    EmptyLine := (OneLine = '');

    // remove comment
    k := pos('//', OneLine);
    if (k > 0) then
      OneLine := copy(OneLine, 1, pred(k));
    k := pos('--', OneLine);
    if (k > 0) then
      OneLine := copy(OneLine, 1, pred(k));

    case AutoMataState of
      0:
        begin
          if pos('select', OneLine) = 1 then
          begin
            sSQL := OneLine;
            AutoMataState := 1;
          end
          else
          begin
            if (OneLine <> '') then
              ParameterL.add(OneLine);
          end;
        end;
      1:
        begin
          if EmptyLine then
            break
          else
            sSQL := sSQL + ' ' + OneLine;
        end;
    end;
  end;

  cOLAP := nCursor;
  with cOLAP do
  begin
    sql.add(ResolveParameter(sSQL));
    dbLog(sql);
    ApiFirst;
    for n := 0 to pred(FieldCount) do
      result.add(Fields[n].FieldName + '=' + Fields[n].AsString);
  end;

  cOLAP.free;
  ParameterL.free;
end;

function e_r_OLAP(FName: string): TgpIntegerList; overload;
var
  myRIDs: TStringList;
  n: integer;
  aRID: integer;
begin
  result := TgpIntegerList.create;

  if (pos(cOLAPExtension, FName) = 0) then
    // Dateiname in der kurzen Form
    e_x_OLAP(iOlapPath + FName + cOLAPExtension)
  else
    // Dateiname mit Pfad
    e_x_OLAP(FName);

  if FileExists(iOlapPath + cOLAP_ErgebnisFName) then
  begin
    myRIDs := TStringList.create;
    myRIDs.loadfromFile(iOlapPath + cOLAP_ErgebnisFName);
    for n := 1 to pred(myRIDs.count) do
      if (myRIDs[n] <> cOLAPNull) then
      begin
        aRID := strtointdef(nextp(myRIDs[n], ';', 0), cRID_Null);
        if (aRID >= cRID_FirstValid) then
          result.add(aRID);
      end;
    myRIDs.free;
  end;
end;

end.

