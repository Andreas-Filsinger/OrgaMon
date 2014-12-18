{
  |������___                  __  __
  |�����/ _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |����| | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |����| |_| | | | (_| | (_| | |  | | (_) | | | |
  |�����\___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |���������������|___/
  |
  |    Copyright (C) 2011  Andreas Filsinger
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
unit eOLAP;

interface

uses
  classes,

  FlexCel.Core, FLexCel.XLSAdapter,

  srvXMLRPC;

type
  IOLAP = Interface(IInvokable)

    procedure e_x_OLAP(FName: string; GlobalVars: TStringList = nil;
      XLS: TXLSFIle = nil; FeedBack: TXMLRPC_Method = nil); stdcall;

  End;

  TOLAP = class(TInterfacedobject, IOLAP)

  var
    ListCount: integer;

    procedure StandardParameter(s: TStrings);

    procedure e_x_OLAP(FName: string; GlobalVars: TStringList = nil;
      XLS: TXLSFile = nil; FeedBack: TXMLRPC_Method = nil); stdcall;

  end;

implementation

uses
  InvokeRegistry, globals, dbOrgaMon,
  Geld, Datenbank,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  SysUtils, anfix32,
  math, windows, IB_Components,
  WordIndex, gpLists, html,
  ExcelHelper, OpenOfficePDF,
  BASIC32, IB_Session, IB_Header,
  CareTakerClient;

{ TOLAP }

procedure TOLAP.e_x_OLAP(
  { } FName: string;
  { } GlobalVars: TStringList;
  { } XLS: TXLSFIle;
  { } FeedBack: TXMLRPC_Method);

  function ErgebnisTableName(n: integer): string;
  begin
    result := 'OLAP$TMP' + inttostr(n);
  end;

  procedure AliveOLAP(n: integer);
  begin

    // Tabelle l�schen
    DropTable(ErgebnisTableName(n));

    // Tabelle neu anlegen
    e_x_sql('create table ' + ErgebnisTableName(n) + ' (' +
      'RID DOM_REFERENCE NOT NULL)');
    e_x_sql('alter table ' + ErgebnisTableName(n) + ' add constraint PK_' +
      ErgebnisTableName(n) + ' primary key (RID)');
    e_x_sql('delete from ' + ErgebnisTableName(n));

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
  cState_subtract = 10; //
  cState_List = 11; // auflisten
  cState_Save = 12; // wiederum in die Datenbank r�ckspeichern
  cState_spread = 13; // 2. Spalte auf horizontale abbilden
  cState_load = 14; // laden einer externen csv in die Datenbank
  cState_repeat = 15;
  // Wiederholen einer SQL Anweisung mit Inhalten einer Tabelle
  cState_connect = 16; // Verbinden auf eine (andere) Datenbank
  cState_consult = 17; // eine externe Tabelle konsultieren
  cState_excel = 18; // aktuelles Ergebnis als XLS-Tabelle speichern
  cState_add = 19; // einzelne Datenzeilen manuell zu einem Ergebnis hinzunehmen
  cState_spread2 = 20; // 2. Spalte auf horizontale abbilden (alphanumerisch)
  cState_delete = 21; // einzelne Spalten l�schen!
  cState_story = 22;
  // erz�hlt eine flache Story, stradd von Zellen zu einer Zelle
  cState_replace = 23;
  // ersetzt Spalten-Inhalte durch die von "complete"-Funktionen
  cState_table = 24;
  // benutzt 2 letzten 2 Auswertungen + eine Complete Funktion und baut eine Tabelle daraus
  cState_BASIC = 25; // f�hrt das folgende BASIC-PRogramm aus!
  cState_default = 26;
  // die folgende Parameter Belegung ist nur wirksam wenn der bisherige Wert '' ist
  cState_html = 27; // der HTML Prozessor
  cState_evaluation = 28; // Auswertungen anwerfen

var
  m, k, l: integer;
  Script: TStringList;
  State: integer;
  CastCount: integer;
  sl: TStringList;
  Line: string;
  LineIndex: integer;
  ExecuteStatement: string;
  StartWait: dword;

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
  AnkerS: string;
  DatumGranularitaet: TDatum_Granularitaet;

  // Parameter Verwaltung
  ParameterL: TStringList;

  // "complete" Sachen
  ParamCol: integer;
  ParamAll: string;
  ParamConstant: string;
  ParamFunction: string;
  ParamVal1: string;
  ParamVal2: string;
  CompleteResult: string;
  sLine, FullLine: string;
  CompleteStrL: TStringList;
  CalculateStatement: TStringList;
  cCalc: TIB_cursor;
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

  // load
  LoadFname: string;
  LoadSQL: string;
  LoadSQLinsert: string;
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
  cRepeat: TIB_cursor;

  // connect
  ConnectionList: TStringList;
  rTRANSACTION: TIB_Transaction;

  // consult
  col_Question: integer; // Spaltenindex der Fragestellung
  col_ConsultIndex: integer; // Spaltenindex des verwendeten Suchindex
  col_ConsultAnswer: integer; // Spaltenindex der Antwort, die in die fragende
  // Datei eingef�gt wird
  sl_ConsultIndex: TStringList;

  // excel
  xlsAutoOpen: boolean;
  xlsAutoPrint: boolean;
  xlsAutoHTML: boolean;
  excelFormats: TStringList;

  // delete
  NewLine: string;

  // story
  StatementParams: TStringList; // aktuelle Wertvariable
  AnkerParam: string;
  AnkerValue: string;
  LastAnker: string; // Anker der letzen Zeile
  LastAnkerLine: integer; // dorthin wird die Story erz�hlt
  AktAnker: string; // aktueller Anker, den es zu bewahren gilt
  StoryFree: TgpIntegerList; // Liste der unn�tigen Zeile
  StoryMaxCol: integer;
  TargetCol: integer;

  // add
  addValue: double;

  // AppendMode
  AppendMode: boolean;

  // ehemals Public
const
  RohdatenCount: integer = 0;
  SilentMode: boolean = false;
  BASIC: TBasicProcessor = nil;
  DataBaseChosen: integer = 0;

  function RohdatenFName(n: integer; MitPfad: boolean = true): string;
  begin
    if MitPfad then
      result := iOlapPath + 'OLAP.tmp' + inttostr(max(0, n)) + '.csv'
    else
      result := 'OLAP.tmp' + inttostr(max(0, n)) + '.csv'
  end;
  function RohdatenxlsFName(n: integer; MitPfad: boolean = true): string;
  begin
    if MitPfad then
      result := AnwenderPath + 'OLAP-Ergebnis' + inttostr(max(0, n)) + '.xls'
    else
      result := 'OLAP-Ergebnis' + inttostr(max(0, n)) + '.xls'
  end;

  function RohdatenHTMLFName(n: integer; MitPfad: boolean = true): string;
  begin
    if MitPfad then
      result := AnwenderPath + 'OLAP-Ergebnis' + inttostr(max(0, n)) + '.html'
    else
      result := 'OLAP-Ergebnis' + inttostr(max(0, n)) + '.html'
  end;

  procedure setWaitCaption(s: string);
  var
    sParameter: TStringList;
  begin
    sParameter := TStringList.create;
    with sParameter do
    begin
      Add('OLAP.Log');
      Add(s);
      FeedBack(sParameter).free;
    end;
  end;

  function getValueofParameter(ParamS: string): string;
  begin
    result := ParameterL.values[ParamS];
    if (length(result) = 7) then
      if (result[1] = '#') then
        result := inttostr(HTMLColor2TColor(result));
  end;

//
  function ResolveParameter(s: string): string;
  var
    i, n, k, l: integer;
    IsNumeric: boolean;
  begin

    // Globale Konstanten den aktuellen lokalen Parametern noch hinzuf�gen
    if assigned(GlobalVars) then
      if (GlobalVars.count > 0) then
      begin
        for n := pred(GlobalVars.count) downto 0 do
          ParameterL.insert(0, GlobalVars[n]);
        GlobalVars.clear;
      end;

    //
    result := s;
    ersetze('$$', '��', result);
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

        if not(CharInSet(result[l], ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '_']))
        then
          break;
        if IsNumeric then
          if not(CharInSet(result[l], ['0' .. '9'])) then
            IsNumeric := false;
        inc(l);
      until false;
      if IsNumeric then
        ersetze(copy(result, k, l - k),
          LoadSQLInclude(strtoint(copy(result, k, l - k))), result)
      else
        ersetze(copy(result, k, l - k),
          getValueofParameter(copy(result, k, l - k)), result);

      // Iterationskontrolle
      inc(i);
      if (i > 100) then
        break;

    until false;
    ersetze('��', '$', result);
  end;

  function UserInput(Line: string): string;
  var
    sParameter: TStringList;
    sResult: TStringList;
  begin
    sParameter := TStringList.create;
    with sParameter do
    begin
      Add(cFeedback_Inquire);
      Add(Line);
    end;
    sResult := FeedBack(sParameter);
    if (sResult.count > 0) then
      result := sResult[0]
    else
      result := '';
  end;

{
  var
  DynForm: TForm;
  AskLabel: TLabel;
  AskSelect: TComboBox;
  DimensionValues: TStringList;
  n: integer;
  begin
  result := Line;
  repeat
  if pos('=?', Line) > 0 then
  begin

  // Vor dem Eingabe Feld!
  AskLabel := TLabel.create(nil);
  with AskLabel do
  begin
  top := 10;
  left := 10;
  caption := nextp(nextp(Line, '=?', 1), 'from', 0);
  end;

  // Das Eingabfeld
  AskSelect := TComboBox.create(nil);
  with AskSelect do
  begin
  top := 10;
  left := 150;
  end;

  DynForm := TForm.create(self);
  with DynForm do
  begin
  caption := 'Dimensionsbestimmung ' + nextp(Line, '=', 0);
  Position := poScreenCenter;
  clientwidth := 350;
  clientheight := 40;
  insertcontrol(AskLabel);
  insertcontrol(AskSelect);

  // Controlls f�llen!
  DimensionValues := TStringList.create;
  DimensionValues.loadfromFile
  (RohdatenFName(strtointdef(nextp(Line, 'from', 1), 0)));
  DimensionValues.delete(0);
  for n := 0 to pred(DimensionValues.count) do
  begin
  if (pos('"', DimensionValues[n]) = 1) then
  DimensionValues[n] := ExtractSegmentBetween(DimensionValues[n],
  '"', '"');
  end;
  DimensionValues.sort;

  AskSelect.items.assign(DimensionValues);
  DimensionValues.free;

  ShowModal;
  end;

  result := AskSelect.text;
  break;
  end;

  // Paramerter muss wiederum aufgel�st werden ...
  n := pos('=select ', Line);
  if (n > 0) then
  begin
  ExecuteStatement := ResolveParameter(copy(Line, n + 1, MaxInt));
  result := copy(Line, 1, n) + e_r_sqls
  (ExecuteStatement);
  break;
  end;

  until true;
  end;
}

  procedure SaveCopy(FName: string);
  var
    Pfad: string;
  begin
    Pfad := getValueofParameter('$KopieSpeichernUnter');
    if (Pfad <> '') then
    begin
      FileCopy(
        { } FName,
        { } Pfad + ExtractFileName(FName));
    end;
  end;

  procedure SaveJoin;
  var
    m: integer;
  begin
    // fertig -> rausspeichern
    JoinL.clear;
    for m := 0 to pred(BigJoin.count) do
      JoinL.Add(HugeSingleLine(TStringList(BigJoin[m]), cOLAPcsvSeparator));
    JoinL.savetofile(RohdatenFName(RohdatenCount));
    SaveCopy(RohdatenFName(RohdatenCount));
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
        excelFormats.values[cExcel_TabellenName] :=
          getValueofParameter('$Skript');
    end;

    // Excel ausgeben
    ExcelExport(RohdatenxlsFName(RohdatenCount), BigJoin, nil,
      excelFormats, XLS);
    SaveCopy(RohdatenxlsFName(RohdatenCount));

    // PDF ausgeben
    MakePDF(RohdatenxlsFName(RohdatenCount), RohdatenxlsFName(RohdatenCount) +
      cPDF_Extension);
    SaveCopy(RohdatenxlsFName(RohdatenCount) + cPDF_Extension);

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
        excelFormats.values[cExcel_TabellenName] :=
          getValueofParameter('$Skript');
    end;
    sData := TsTable.create;
    sData.insertFromFile(RohdatenFName(RohdatenCount));
    sData.SaveToHTML(RohdatenHTMLFName(RohdatenCount), excelFormats);
    Pfad := getValueofParameter('$KopieSpeichernUnter');
    if (Pfad <> '') then
      FileCopy(RohdatenHTMLFName(RohdatenCount),
        Pfad + RohdatenHTMLFName(RohdatenCount, false));
    sData.free;
  end;

  procedure FreeJoin;
  var
    k: integer;
  begin
    // init f�r Join
    for k := 0 to pred(BigJoin.count) do
      TObject(BigJoin[k]).free;
    BigJoin.clear;
  end;

  procedure InitJoin;
  begin
    FreeJoin;
    BigJoin.Add(TStringList.create);
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
      TStringList(BigJoin[0]).Add(nextp(ThisHeader, cOLAPcsvSeparator));
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
          Cols.Add(copy(ThisLine, 2, k - 1));
          delete(ThisLine, 1, k + 1);
          nextp(ThisLine, cOLAPcsvSeparator);
        end
        else
        begin
          Cols.Add(nextp(ThisLine, cOLAPcsvSeparator));
        end;
      end;
      BigJoin.Add(Cols);
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
      TStringList(BigJoin[0]).Add(nextp(ThisHeader, cOLAPcsvSeparator));
    ColCount := TStringList(BigJoin[0]).count;
    for n := 1 to pred(JoinL.count) do
    begin
      ThisData := JoinL[n];
      Cols := TStringList.create;
      for m := 0 to pred(ColCount) do
        Cols.Add(nextp(ThisData, cOLAPcsvSeparator));
      BigJoin.Add(Cols);
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
        raise Exception.create('complete:Plural: Anker nicht gefunden!');

      Plural1 := ExtractSegmentBetween(nextp(ParamAll, ','), '"', '"');
      PluralN := ExtractSegmentBetween(nextp(ParamAll, ','), '"', '"');
      if (strtointdef(sRow[PluralAnker], 1) = 1) then
        result := Plural1
      else
        result := PluralN;
      ersetze('_', ' ', result);
    end;

  begin
    result := cOLAPNull;
    repeat

      if (pos('"', ParamFunction) > 0) then
      begin
        result := ResolveParameter(ParamConstant);
        break;
      end;

      if (ParamFunction = 'Arbeit') then
      begin
        result := e_r_Arbeit(strtointdef(ParamVal1, cRID_Null),
          date2long(ParamVal2));
        break;
      end;

      if (ParamFunction = 'Einsatz') then
      begin
        result := e_r_Einsatz(strtointdef(ParamVal1, cRID_Null),
          date2long(ParamVal2));
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
        result := e_r_MusikerNurNachName(strtointdef(ParamVal1, 0));
        break;
      end;

      if (ParamFunction = 'ArrangeurN') then
      begin
        result := e_r_MusikerNurNachName(strtointdef(ParamVal1, 0));
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
        result := format('%.1f', [e_r_VerlagsRabatt(strtointdef(ParamVal1, 0),
          strtointdef(ParamVal2, 0))]);
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
            cPreisRundung(EinzelPreisUnrabattiert - (EinzelPreisUnrabattiert *
            (Rabatt / 100.0)));
        result := format('%.2m', [EinzelPreisUnrabattiert]);
        break;
      end;

      if (ParamFunction = 'Umsatz') then
      begin
        result := format('%.2m', [e_r_Umsatz(strtointdef(ParamVal1, 0))]);
        break;
      end;

      if (ParamFunction = 'Preis') then
      begin
        result := format('%.2m',
          [e_r_PreisBrutto(0, strtointdef(ParamVal1, 0))]);
        break;
      end;

      if (ParamFunction = 'Lieferzeit') then
      begin
        result := inttostr(e_r_Lieferzeit(0, strtointdef(ParamVal1, 0)));
        break;
      end;

      if (ParamFunction = 'Bemerkung') then
      begin
        CompleteStrL := e_r_sqlt('select INTERN_INFO from ARTIKEL where RID=' +
          ParamVal1);
        result := ReadLongStr('BEM', CompleteStrL, '|');
        ersetze('"', '''', result);
        result := '"' + result + '"';
        CompleteStrL.free;
        break;
      end;

      if (ParamFunction = 'Anschrift') then
      begin
        if ParamVal1 = cOLAPNull then
        begin
          result := fill(cOLAPcsvSeparator, 5);
        end
        else
        begin
          CompleteStrL := e_r_Adressat(strtointdef(ParamVal1, 0));
          result := CSVsecure(CompleteStrL[0]) + cOLAPcsvSeparator +
            CSVsecure(CompleteStrL[1]) + cOLAPcsvSeparator +
            CSVsecure(CompleteStrL[2]) + cOLAPcsvSeparator +
            CSVsecure(CompleteStrL[3]) + cOLAPcsvSeparator +
            CSVsecure(e_r_sqls('SELECT STRASSE from ANSCHRIFT where RID' +
            '=(SELECT PRIV_ANSCHRIFT_R from PERSON where RID=' + ParamVal1 +
            ')')) + cOLAPcsvSeparator +
            CSVsecure(e_r_Ort(strtointdef(ParamVal1, 0)));
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
        // k�nnte auch ein TimeStamp sein, sooo genau wollen wir das nicht!
        EinDatum := date2long(nextp(ParamVal1, ' ', 0));
        if DateOK(EinDatum) then
          result := inttostrN(extractYear(EinDatum), 4) + '_KW' +
            inttostrN(anfix32.Kalenderwoche(EinDatum), 2);
        break;
      end;

      if (ParamFunction = 'Tag') then
      begin
        // k�nnte auch ein TimeStamp sein, sooo genau wollen wir das nicht!
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

        result := // Beleg-Teillieferung;NETTO1;NETTO2;NETTO3;MWST1;MWST2;MWST3
          inttostr(BELEG_R) + '-' + inttostrN(TEILLIEFERUNG, 2) +
          cOLAPcsvSeparator + CompleteStrL.values['NETTO1'] + cOLAPcsvSeparator
          + CompleteStrL.values['SATZ1'] + cOLAPcsvSeparator +
          CompleteStrL.values['STEUER1'] + cOLAPcsvSeparator +
          CompleteStrL.values['NETTO2'] + cOLAPcsvSeparator +
          CompleteStrL.values['SATZ2'] + cOLAPcsvSeparator + CompleteStrL.values
          ['STEUER2'] + cOLAPcsvSeparator + CompleteStrL.values['NETTO3'] +
          cOLAPcsvSeparator + CompleteStrL.values['SATZ3'] + cOLAPcsvSeparator +
          CompleteStrL.values['STEUER3'];

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
            // H�her
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
        result := e_r_LohnKalkulation(strtodoubledef(ParamVal1, 0),
          date2long('01.' + ResolveParameter('$MonatJahr')));
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
        Protokoll := e_r_sqlt('SELECT PROTOKOLL from AUFTRAG where RID=' +
          ParamVal1);
        for l := 0 to pred(CompleteHeader.count) do
        begin
          s := Protokoll.values[nextp(CompleteHeader[l], ':', 0)];
          if (pos(':INT', CompleteHeader[l]) > 0) then
            if (s = 'X') then
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

        cCalc := DataModuleDatenbank.nCursor;

        ExecuteStatement := ParamConstant;

        // Aus der aktuellen Zeile alle Werte in die Parameter schreiben
        if pos('$', ExecuteStatement) > 0 then
        begin
          for l := 0 to AllHeader.count - 2 do
            if (l < sRow.count) then
              ParameterL.values['$' + AllHeader[l]] := sRow[l]
            else
              ParameterL.values['$' + AllHeader[l]] := cOLAPNull;
          ExecuteStatement := ResolveParameter(ExecuteStatement);
        end;

        setWaitCaption(ExecuteStatement);

        // Ergebnis saugen!
        with cCalc do
        begin
          if assigned(cConnection) then
            IB_Connection := cConnection;
          sql.Add(ExecuteStatement);
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
        cCalc := DataModuleDatenbank.nCursor;
        CalculateStatement := TStringList.create;
        CalculateStatement.loadfromFile(iOlapPath + cOLAPDimPreFix +
          ParamFunction + '.txt');
        ExecuteStatement := HugeSingleLine(CalculateStatement, ' ');

        // Aus der aktuellen Zeile alle Werte in die Parameter schreiben
        if pos('$', ExecuteStatement) > 0 then
        begin
          for l := 0 to AllHeader.count - 2 do
            ParameterL.values['$' + AllHeader[l]] := sRow[l];
          ExecuteStatement := ResolveParameter(ExecuteStatement);
        end;

        setWaitCaption(ExecuteStatement);

        // Ergebnis saugen!
        with cCalc do
        begin
          if assigned(cConnection) then
            IB_Connection := cConnection;
          sql.Add(ExecuteStatement);
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
      raise Exception.create('complete "' + ParamFunction +
        '" nicht gefunden!');

    until true;
  end;

begin
  BeginHourGlass;

  Script := TStringList.create;
  BigJoin := TList.create;
  IntegratedL := TList.create;
  ParameterL := TStringList.create;
  JoinL := TStringList.create;
  sl := TStringList.create;
  StatementParams := TStringList.create;
  ConnectionList := TStringList.create;
  excelFormats := TStringList.create;
  rTRANSACTION := TIB_Transaction.create(nil);
  CompleteHeader := TStringList.create;
  with rTRANSACTION do
  begin
    Isolation := tiCommitted;
    AutoCommit := true;
    ReadOnly := true;
  end;

  try

    LastKategorie := '';
    LastCode := '';
    TopKategorie := '';

    RohdatenCount := 0;
    CastCount := 0;
    State := cState_Rohdaten;
    LineIndex := -1;
    AppendMode := false;
    xlsAutoOpen := false;
    xlsAutoPrint := false;
    xlsAutoHTML := false;

    StandardParameter(ParameterL);
    ParameterL.Add('$Skript=' + nextp(ExtractFileName(FName),
      cOLAPExtension, 0));
    Script.loadfromFile(FName);

    if DebugMode then
      AppendStringsToFile(ParameterL, DebugLogPath + 'OLAP-' + inttostr(DateGet)
        + '.txt', DatumUhr);

    repeat

      inc(LineIndex);

      if (LineIndex = Script.count) then
        break;

      // Get Line
      Line := cutblank(Script[LineIndex]);

      // remove comment
      if not(assigned(BASIC)) then
      begin

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
          setWaitCaption(Line);
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
        if State = cState_default then
        begin
          if (ResolveParameter(nextp(Line, '=', 0)) = '') then
            ParameterL.Add(UserInput(Line));
        end
        else
        begin
          ParameterL.Add(UserInput(Line));
        end;
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

      if (Line = 'subtract') then
      begin
        State := cState_subtract;
        InitJoin;
        // continue;
      end;

      if (Line = 'spread') then
      begin
        State := cState_spread;
        InitJoin;
        LoadJoin;
        continue
      end;

      if (Line = 'spread2') then
      begin
        State := cState_spread2;
        InitJoin;
        LoadJoin;
        continue
      end;

      if (Line = 'extent') then // 2 Datentabellen verbinden
      begin
        State := cState_extent;
        InitJoin;
        continue;
      end;

      if (Line = 'integrate') then // �ber identische Spalten andere addieren
      begin
        State := cState_Integrate;
        continue;
      end;

      if (Line = 'integrate2') then // �ber identische Spalten andere addieren
      begin
        State := cState_Integrate2;
        continue;
      end;

      if (Line = 'sort') then // �ber Spalten sortieren
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

      if pos('load', Line) = 1 then
      begin
        State := cState_load;
        LoadFname := nextp(Line, ' ', 1);
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

      if pos('connect', Line) = 1 then
      begin
        State := cState_connect;
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
              if (Line = 'save as html') then
                xlsAutoHTML := true;

              if (pos('=', Line) > 0) then
                excelFormats.Add(Line);
            end
            else
            begin
              if xlsAutoHTML then
                SaveJoinAsHTML
              else
                SaveJoinAsExcel;

              if xlsAutoOpen then
                if (getValueofParameter('$ExcelOpen') <> cINI_deactivate) then
                begin
                 (*
                  if xlsAutoHTML then
                    openShell(RohdatenHTMLFName(RohdatenCount))
                  else
                    openShell(RohdatenxlsFName(RohdatenCount));
                  *)
                end;

              if xlsAutoPrint then
              begin
                (*
                  JclMiscel.WinExec32AndWait( '"' +
                  {} ProgramFilesDir +
                  {} 'OpenOffice.org 3\program\soffice.exe" '+
                  {} '-headless -p "' +RohdatenxlsFName(RohdatenCount) +'"',
                  SW_HIDE);
                if xlsAutoHTML then
                  printhtmlok(RohdatenHTMLFName(RohdatenCount))
                else
                  printShell(RohdatenxlsFName(RohdatenCount));
                *)

              end;
            end;
          end;
        cState_BASIC:
          if assigned(BASIC) then
          begin

            // Abschluss oder weitere Zeile?
            if (Line <> '-') then
            begin
              BASIC.Add(Line);
            end
            else
            begin
              with BASIC do
              begin

                // ParameterL
                for m := 0 to pred(ParameterL.count) do
                  WriteVal(nextp(ParameterL[m], '=', 0),
                    nextp(ParameterL[m], '=', 1));

                // GlobalVars
                if assigned(GlobalVars) then
                  for m := 0 to pred(GlobalVars.count) do
                    WriteVal(nextp(GlobalVars[m], '=', 0),
                      nextp(GlobalVars[m], '=', 1));

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
                  ParameterL.values['$RESULT'] :=
                    HugeSingleLine(BasicErrors, '|');
                end;
              end;
              BASIC.free;
              BASIC := nil;
            end;

          end;
        cState_connect:
          begin

            if (Line <> '-') then
            begin
              ConnectionList.Add(nextp(Line, ' ', 0));
              // ConnectionAlias.add(nextp(line,' ',1));
            end
            else
            begin
              cConnection := TIB_Connection.create(nil);
              with cConnection do
              begin
                UserName := 'SYSDBA';
                DefaultTransaction := rTRANSACTION;
                LoginDBReadOnly := true;
                Protocol := cpTCP_IP;
                if (pos(':', ConnectionList[DataBaseChosen]) = 0) then
                begin
                  Password := SysDBAPassword;
                  DataBaseName := iDataBaseHost + ':' + ConnectionList
                    [DataBaseChosen];
                end
                else
                begin
                  Password := 'masterkey';
                  DataBaseName := ConnectionList[DataBaseChosen];
                end;

                ExecuteStatement := 'connect ' + DataBaseName;
              end;
              rTRANSACTION.IB_Connection := cConnection;

              cConnection.connect;
            end;

          end;
        cState_Rohdaten:
          begin

            // Eine einzelne Zeile machen
            // die erste Leerzeile markiert das Ende
            repeat
              if (LineIndex + 1 = Script.count) then
                break;
              if cutblank(Script[LineIndex + 1]) = '' then
                break;

              inc(LineIndex);
              Line := Line + ' ' + nextp(Script[LineIndex], '--', 0);
            until false;

            Line := ResolveParameter(Line);

            if (Line <> '-') then
            begin

              setWaitCaption(inttostr(RohdatenCount) + ': ' + Line);
              ExecuteStatement := Line;

              // Ist es ein Select-Statement oder ein Script?
              if (pos('SELECT', AnsiUpperCase(cutblank(Line))) = 1) then
                ExportTable(ExecuteStatement, RohdatenFName(RohdatenCount),
                  cOLAPcsvSeparator, AppendMode)
              else
                ExportScript(ExecuteStatement, RohdatenFName(RohdatenCount),
                  cOLAPcsvSeparator);

              // Kopie speichern!
              SaveCopy(RohdatenFName(RohdatenCount));

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
                  sl[m] := nextp(nextp(sl[m], cOLAPcsvSeparator, 0), ' ', 0) +
                    cOLAPcsvSeparator + nextp(sl[m], cOLAPcsvSeparator, 1) +
                    cOLAPcsvSeparator;
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
              // 2) erzeuge "Null" Daten f�r jedes neue Feld

              sl_ConsultIndex := TStringList.create;
              if not(FileExists(iOlapPath + LoadFname)) then
                raise Exception.create('Datei ' + iOlapPath + LoadFname +
                  ' nicht gefunden!');
              LoadFromFileCSV(true, JoinL, iOlapPath + LoadFname);

              // Quell Spalte suchen
              AllHeader := TStringList(BigJoin[0]);
              col_Question := AllHeader.indexof(nextp(Line, ',', 0));
              if (col_Question = -1) then
                raise Exception.create('Referenzierende Spalte "' + nextp(Line,
                  ',', 0) + '" nicht gefunden!');

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
                    AllHeader.Add(OneHeader);
                    break;
                  end;
                  break;
                until false;
              end;
              if (col_ConsultIndex = -1) then
                raise Exception.create('Referenz Spalte "' + nextp(Line, ',', 1)
                  + '" in Datei "' + LoadFname + '" nicht gefunden!');
              if (col_ConsultAnswer = -1) then
                raise Exception.create('Antwort Spalte "' + nextp(Line, ',', 2)
                  + '" in Datei "' + LoadFname + '" nicht gefunden!');

              // Antwort Index aufbauen
              for m := 1 to pred(JoinL.count) do
                sl_ConsultIndex.addobject(nextp(JoinL[m], cOLAPcsvSeparator,
                  col_ConsultIndex), pointer(m));
              sl_ConsultIndex.sort;
              sl_ConsultIndex.sorted := true;

              // Doppelte sollten hier vermieden werden.
              if (RemoveDuplicates(sl_ConsultIndex) > 0) then
                raise Exception.create('Referenz Spalte "' + nextp(Line, ',', 1)
                  + '" in Datei "' + LoadFname + '" hat doppelte Eintr�ge!');

              // Nun den Referenzierlauf
              for m := 1 to pred(BigJoin.count) do
              begin
                AllHeader := TStringList(BigJoin[m]);
                k := sl_ConsultIndex.indexof(AllHeader[col_Question]);
                if (k = -1) then
                  AllHeader.Add(cOLAPNull)
                else
                  AllHeader.Add(nextp(JoinL[integer(sl_ConsultIndex.objects[k])
                    ], cOLAPcsvSeparator, col_ConsultAnswer));
              end;

              sl_ConsultIndex.free;

            end;

          end;
        cState_story:
          begin
            if (Line = '-') then
            begin
              // Optimierungs-M�glichkeiten
              // a) im Rahmen eines einmaligen Parserlaufes die
              // Ankerspalten bestimmen, in ein Integerlist
              // speichern. Sp�ter gaanz schnell den Anker
              // zusammenbauen.
              // b) Eine IntergerList f�r die CopySpalten bilden

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
                    raise Exception.create('story: Anker ist unbekannt!');
                end;

                // die Zielspalte bestimmen
                TargetCol := AllHeader.indexof(StatementParams.values['Ziel']);

                if (AnkerValue = LastAnker) then
                begin
                  // diese Zeile erz�hlen
                  AnkerParam := StatementParams.values['Erz�hle'];
                  while (AnkerParam <> '') do
                  begin
                    k := AllHeader.indexof
                      (nextp(AnkerParam, cOLAPcsvSeparator));
                    if (k <> -1) then
                    begin
                      if (TargetCol = -1) then
                      begin
                        TStringList(BigJoin[LastAnkerLine])
                          .Add(TStringList(BigJoin[m])[k]);
                      end
                      else
                      begin
                        SortRow := cutblank(TStringList(BigJoin[m])[k]);
                        if (SortRow <> '') and (SortRow <> cOLAPNull) then
                        begin
                          SortStr :=
                            cutblank(TStringList(BigJoin[LastAnkerLine])
                            [TargetCol]);
                          if (SortStr = '') or (SortStr = cOLAPNull) then
                            SortStr := TStringList(BigJoin[m])[k]
                          else
                            SortStr := SortStr + ', ' +
                              cutblank(TStringList(BigJoin[m])[k]);
                          TStringList(BigJoin[LastAnkerLine])[TargetCol]
                            := SortStr;
                        end;
                      end;
                    end;
                  end;
                  StoryMaxCol :=
                    max(StoryMaxCol, TStringList(BigJoin[LastAnkerLine]).count);
                  StoryFree.Add(m);
                end
                else
                begin
                  LastAnker := AnkerValue;
                  LastAnkerLine := m;
                end;

              end;

              // Erz�hlte Zeilen l�schen
              for m := pred(StoryFree.count) downto 0 do
                JoinDeleteLine(StoryFree[m]);

              // Titel Spalten mit Dummyies f�llen
              for m := AllHeader.count to pred(StoryMaxCol) do
                AllHeader.Add('C' + inttostr(m));

              StoryFree.free;
              SaveJoin;
            end
            else
            begin
              StatementParams.Add(Line);
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
              // 2) erzeuge "Null" Daten f�r jedes neue Feld

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
                  AllHeader.Add(OneHeader);
                  for m := 1 to pred(BigJoin.count) do
                    TStringList(BigJoin[m]).Add('0');
                end;
              end;

              // Header Reihenfolge bestimmen
              ThisHeader := JoinL[0];
              SetLength(HeaderOrder, ThisHeaderAnz);
              for m := 0 to pred(ThisHeaderAnz) do
                HeaderOrder[m] :=
                  AllHeader.indexof(nextp(ThisHeader, cOLAPcsvSeparator));

              // Alle Daten nachtragen - In der richtigen Reihenfolge
              for m := 1 to pred(JoinL.count) do
              begin
                OneLine := JoinL[m];

                JoinedL := TStringList.create;
                BigJoin.Add(JoinedL);

                for k := 0 to pred(AllHeader.count) do
                  JoinedL.Add('0');

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
              BigJoin.Add(JoinedL);
              for k := 0 to pred(AllHeader.count) do
              begin
                SingleValue := nextp(Line, cOLAPcsvSeparator);
                if (SingleValue = '=SUMME') then
                begin
                  addValue := 0.0;
                  for l := 1 to (BigJoin.count - 2) do
                    addValue := addValue +
                      strtodoubledef(TStringList(BigJoin[l])[k], 0.0);
                  SingleValue := format('%.2f', [addValue]);
                end;
                JoinedL.Add(ResolveParameter(SingleValue));
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
              // erweitern hinzunehmen. Erweitert wird �ber die Spalte
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
                  AllHeader.Add(OneHeader);
                  for m := 1 to pred(BigJoin.count) do
                    TStringList(BigJoin[m]).Add('0');
                end;
              end;

              // Header Reihenfolge bestimmen
              ThisHeader := JoinL[0];
              SetLength(HeaderOrder, ThisHeaderAnz);
              for m := 0 to pred(ThisHeaderAnz) do
                HeaderOrder[m] :=
                  AllHeader.indexof(nextp(ThisHeader, cOLAPcsvSeparator));

              // Alle Daten nachtragen - In der richtigen Reihenfolge
              for m := 1 to pred(JoinL.count) do
              begin
                OneLine := JoinL[m];

                JoinedL := TStringList.create;
                BigJoin.Add(JoinedL);

                for k := 0 to pred(AllHeader.count) do
                  JoinedL.Add('0');

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
                    ListResults.Add('0');
                  end
                  else
                  begin
                    if ListNumeric then
                    begin
                      ListResults.Add(TStringList(BigJoin[m])[ListCol]);
                    end
                    else
                    begin
                      ListResults.Add('''' + TStringList(BigJoin[m])
                        [ListCol] + '''');
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
                raise Exception.create('list: Spalte ' + ListColName +
                  ' nicht gefunden');
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

              cRepeat := DataModuleDatenbank.nCursor;
              with cRepeat do
              begin
                ExecuteStatement := 'select * from ' +
                  ErgebnisTableName(RohdatenCount - 2);
                sql.Add(ExecuteStatement);
                setWaitCaption(ExecuteStatement);
                ApiFirst;
                l := 0;
                FeedBack(TFeedbackHelper.Progress(
                  { } 0,
                  { } 'ProgressBar1',
                  { } RecordCount)).free;

                while not(eof) do
                begin
                  ParameterL.values['$RID'] := Fields[0].AsString;
                  RepeatSQL := ResolveParameter(_RepeatSQL);

                  while (RepeatSQL <> '') do
                  begin
                    ExecuteStatement := nextp(RepeatSQL, '~');
                    if (pos('SELECT', AnsiUpperCase(cutblank(ExecuteStatement))
                      ) = 1) then
                    begin
                      // select part
                      ExportTable(ExecuteStatement,
                        RohdatenFName(RohdatenCount), cOLAPcsvSeparator, true);
                    end
                    else
                    begin
                      // update / insert part
                      e_x_sql(ExecuteStatement);
                    end;
                  end;
                  ApiNext;
                  inc(l);
                  if frequently(StartWait, 333) or eof then
                  begin
                    setWaitCaption(RepeatSQL);
                    FeedBack(TFeedbackHelper.Progress(l)).free;
                  end;
                end;
              end;
              FeedBack(TFeedbackHelper.Progress(0)).free;
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
        cState_load:
          begin

            if (Line = '-') then
            begin

              // gibt es die Quelle?
              if not(FileExists(iOlapPath + LoadFname)) then
                raise Exception.create('Datei "' + iOlapPath + LoadFname +
                  '" nicht gefunden!');

              // bisherige Tabelle l�schen
              DropTable(ErgebnisTableName(RohdatenCount));

              // jetzt wird die Tabelle angelegt
              LoadSQL := '';
              for m := pred(SpaltenNamen.count) downto 0 do
              begin
                LoadSQL := LoadSQL + nextp(SpaltenNamen[m], ' ', 0) + ' ' +
                  nextp(SpaltenNamen[m], ' ', 1);
                if (m <> 0) then
                  LoadSQL := LoadSQL + ', ';
              end;

              e_x_sql('create table ' + ErgebnisTableName(RohdatenCount) + ' ( '
                + LoadSQL + ')');

              LoadSQL := '';
              for m := pred(SpaltenNamen.count) downto 0 do
              begin
                LoadSQL := LoadSQL +
                  nextp(SpaltenNamen[pred(SpaltenNamen.count) - m], ' ', 0);
                if (m <> 0) then
                  LoadSQL := LoadSQL + ',';
              end;

              // QuellDatei laden
              InitJoin;
              LoadJoinFrom(LoadFname);

              // Quell Spalten Index anlegen
              LoadSpalte := TgpIntegerList.create;
              LoadSpalteType := TgpIntegerList.create;
              for m := 0 to pred(SpaltenNamen.count) do
              begin
                LoadSpalte.Add(TStringList(BigJoin[0])
                  .indexof(nextp(SpaltenNamen[m], ' ', 2)));
                if pos('CHAR', AnsiUpperCase(nextp(SpaltenNamen[m], ' ', 1))) > 0
                then
                  LoadSpalteType.Add(SQL_TEXT)
                else
                  LoadSpalteType.Add(0);
              end;

              // jetzt gehts los! Insert Insert!
              FeedBack(TFeedbackHelper.Progress(0, 'ProgressBar1',
                BigJoin.count)).free;
              StartWait := 0;

              for m := 1 to pred(BigJoin.count) do
              begin

                //
                LoadSQLinsert := 'insert into ' +
                  ErgebnisTableName(RohdatenCount) + '(' + LoadSQL +
                  ') values (';

                //
                for k := 0 to pred(SpaltenNamen.count) do
                begin

                  case LoadSpalteType[k] of
                    SQL_TEXT:
                      begin
                        LoadSQLinsert := LoadSQLinsert + '''' +
                          TStringList(BigJoin[m])[LoadSpalte[k]] + '''';

                      end;
                  else
                    LoadSQLinsert := LoadSQLinsert + TStringList(BigJoin[m])
                      [LoadSpalte[k]];

                  end;

                  if (k < pred(SpaltenNamen.count)) then
                    LoadSQLinsert := LoadSQLinsert + ',';
                end;

                ExecuteStatement := LoadSQLinsert + ')';
                e_x_sql(ExecuteStatement);

                if frequently(StartWait, 333) then
                  FeedBack(TFeedbackHelper.Progress(m)).free;

              end;
              FreeAndNil(LoadSpalte);
              FreeAndNil(LoadSpalteType);
              FreeAndNil(SpaltenNamen);

              FeedBack(TFeedbackHelper.Progress(0)).free;
              State := cState_subtract;

            end
            else
            begin

              // Spaltennamen aufsammeln
              if not(assigned(SpaltenNamen)) then
                SpaltenNamen := TStringList.create;
              if (Line <> '') then
                SpaltenNamen.Add(Line);
            end;
          end;
        cState_html:
          begin

            if (Line = '-') then
            begin
              html := THTMLTemplate.create;
              html.loadfromFile(HTMLVorlagenPath + htmlFName + cHTMLextension);
              if assigned(GlobalVars) then
                html.WriteValue(GlobalVars);
              html.WriteValue(ParameterL);
              html.SaveToFileCompressed(htmlSaveFName);
              html.free;
              SaveCopy(htmlSaveFName);

            end
            else
            begin

              // Hier noch html-variable Hinzuf�gbar machen usw.
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

              //
              ListResults := TStringList.create;
              ListColName := Line;
              ListNumeric := pos('numeric', Line) > 0;
              if ListNumeric then
                ersetze('numeric', '', ListColName);

              ListColName := cutblank(ListColName);
              AllHeader := TStringList(BigJoin[0]);
              ListCol := AllHeader.indexof(ListColName);
              if (ListCol <> -1) then
              begin

                AliveOLAP(pred(RohdatenCount));

                // nun speichern!
                for m := 1 to pred(BigJoin.count) do
                begin
                  if (TStringList(BigJoin[m])[ListCol] <> cOLAPNull) then
                  begin
                    if ListNumeric then
                      e_x_sql('insert into ' +
                        ErgebnisTableName(pred(RohdatenCount)) + '(RID)values('
                        + TStringList(BigJoin[m])[ListCol] + ')');
                  end;
                end;

              end
              else
              begin
                raise Exception.create('save: Spalte ' + ListColName +
                  ' nicht gefunden!');
              end;
              ListResults.free;

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
                  if VerlagL.indexof(strtointdef(TStringList(BigJoin[m])[1], 0)
                    ) = -1 then
                    VerlagL.Add(strtointdef(TStringList(BigJoin[m])[1], 0));

              VerlagL.sort;
              SpaltenIst := TStringList(BigJoin[0]).count;
              SpaltenSoll := SpaltenIst + VerlagL.count;
              for m := 0 to pred(VerlagL.count) do
                TStringList(BigJoin[0])
                  .Add(SpreadColName + '_' + inttostr(VerlagL[m]));

              for m := 1 to pred(BigJoin.count) do
              begin
                for l := 1 to m do // von oben bis zu dieser Zeile suchen
                begin
                  if (TStringList(BigJoin[m])[0] = TStringList(BigJoin[l])[0])
                  then
                  begin
                    k := VerlagL.indexof
                      (strtointdef(TStringList(BigJoin[m])[1], 0));

                    // ggf. die Breite der Zeile sicherstellen
                    while TStringList(BigJoin[l]).count < SpaltenSoll do
                      TStringList(BigJoin[l]).Add('0');

                    TStringList(BigJoin[l])[k + SpaltenIst] :=
                      inttostr(strtointdef(TStringList(BigJoin[l])
                      [k + SpaltenIst], 0) +
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

              // alle neuen Spalten �berschriften sammeln
              for m := 1 to pred(BigJoin.count) do
                if (TStringList(BigJoin[m])[1] <> cOLAPNull) then
                  if SpreadTitle.indexof(TStringList(BigJoin[m])[1]) = -1 then
                    SpreadTitle.Add(TStringList(BigJoin[m])[1]);

              // die gesammelten �berschriften nun oben eintragen
              SpaltenIst := TStringList(BigJoin[0]).count;
              SpaltenSoll := SpaltenIst + SpreadTitle.count;
              for m := 0 to pred(SpreadTitle.count) do
                TStringList(BigJoin[0])
                  .Add(SpreadColName + '_' + SpreadTitle[m]);

              // nun summieren ...
              for m := 1 to pred(BigJoin.count) do
              begin
                // von oben bis zum Integrationsanker (Spalte 1) suchen
                for l := 1 to m do
                begin
                  // Ist "Name" identisch?
                  if (TStringList(BigJoin[m])[0] = TStringList(BigJoin[l])[0])
                  then
                  begin
                    k := SpreadTitle.indexof(TStringList(BigJoin[m])[1]);

                    // ggf. die Breite der Zeile sicherstellen
                    while TStringList(BigJoin[l]).count < SpaltenSoll do
                      TStringList(BigJoin[l]).Add('0');

                    TStringList(BigJoin[l])[k + SpaltenIst] :=
                      inttostr(strtointdef(TStringList(BigJoin[l])
                      [k + SpaltenIst], 0) +
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

              // Spalte 2+3 l�schen!

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
              AssignDatumCol := TStringList(BigJoin[0])
                .indexof(nextp(Line, ' ', 0));
              AssignWertCol := TStringList(BigJoin[0])
                .indexof(nextp(Line, ' ', 1));

              // Header um die Zeiten $Start ... $Ende erweitern
              MonatsNamen := TStringList.create;
              MonatsSpaltenOffset := TStringList(BigJoin[0]).count;
              AssignStart := date2long(ResolveParameter('$Start'));
              AssignEnde := date2long(ResolveParameter('$Ende'));
              AssignRun := AssignStart;
              repeat

                //
                MonatsName := AssignDate(AssignRun);
                if (MonatsNamen.indexof(MonatsName) = -1) then
                begin
                  MonatsNamen.Add(MonatsName);
                  TStringList(BigJoin[0]).Add(MonatsName);
                end;

                //
                if (AssignRun = AssignEnde) then
                  break;
                AssignRun := DatePlus(AssignRun, 1);
              until false;

              // Unscharf machen
              for m := 1 to pred(BigJoin.count) do
              begin
                MonatsName :=
                  AssignDate
                  (date2long(nextp(TStringList(BigJoin[m])[AssignDatumCol],
                  ' ', 0)));
                MonatsN := MonatsNamen.indexof(MonatsName);
                AssignWert :=
                  format('%.2m',
                  [strtodouble(TStringList(BigJoin[m])[AssignWertCol])]);
                TStringList(BigJoin[m])[AssignWertCol] := AssignWert;

                for k := 0 to pred(MonatsNamen.count) do
                  if (k = MonatsN) then
                    TStringList(BigJoin[m]).Add(AssignWert)
                  else
                    TStringList(BigJoin[m]).Add('0 �');
              end;
              MonatsNamen.free;
            end;

          end;
        cState_Complete:
          begin

            if (Line = '-') then
            begin

              SaveJoin;

            end
            else
            begin

              // Name der neuen Spalte(n) hinzuf�gen
              CompleteHeader.clear;
              NewColumnName := nextp(Line, ' ', max(1, CharCount(' ', Line)));
              if (NewColumnName = '') then
                NewColumnName := nextp(Line, '(', 0);;
              AllHeader := TStringList(BigJoin[0]);
              while (NewColumnName <> '') do
              begin
                CompleteResult := nextp(NewColumnName, cOLAPcsvSeparator);
                AllHeader.Add(nextp(CompleteResult, ':', 0));
                CompleteHeader.Add(CompleteResult);
              end;

              FeedBack(TFeedbackHelper.Progress(0, 'ProgressBar1',
                BigJoin.count)).free;

              StartWait := 0;
              for m := 1 to pred(BigJoin.count) do
              begin

                if frequently(StartWait, 333) then
                  FeedBack(TFeedbackHelper.Progress(m)).free;

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

                  CompleteResult := CompleteResult +
                    completeFunc(TStringList(BigJoin[m]));
                end;

                // Nun die Werte zur Tabelle dazu!
                if (CompleteResult = '') then
                begin
                  TStringList(BigJoin[m]).Add('');
                end
                else
                begin
                  while (CompleteResult <> '') do
                    TStringList(BigJoin[m])
                      .Add(nextp(CompleteResult, cOLAPcsvSeparator));
                end;

              end;
              FeedBack(TFeedbackHelper.Progress(0)).free;

            end;
          end;
        cState_replace:
          begin

            if (Line = '-') then
            begin

              SaveJoin;

            end
            else
            begin

              // Name der neuen Spalte(n) hinzuf�gen
              CompleteHeader.clear;
              AllHeader := TStringList(BigJoin[0]);
              NewColumnName := nextp(Line, ' ', 1);
              if (NewColumnName = '') then
                NewColumnName := ParamFunction;
              ReplaceIndex := AllHeader.indexof(NewColumnName);
              if ReplaceIndex = -1 then
                raise Exception.create('replace Spalte "' + NewColumnName +
                  '" nicht gefunden!');

              FeedBack(TFeedbackHelper.Progress(0, 'ProgressBar1',
                BigJoin.count)).free;

              StartWait := 0;
              for m := 1 to pred(BigJoin.count) do
              begin

                if frequently(StartWait, 333) then
                  FeedBack(TFeedbackHelper.Progress(m)).free;

                FullLine := nextp(Line, ' ', 0);
                CompleteResult := '';
                while (FullLine <> '') do
                begin
                  sLine := nextp(FullLine, cC_concant);

                  // Ersetzen-Funktion
                  ParamFunction := nextp(sLine, '(', 0);

                  // Quell-Parameter
                  ParamAll := ExtractSegmentBetween(sLine, '(', ')');
                  ParamConstant := ExtractSegmentBetween(sLine, '"', '"');

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

                  CompleteResult := CompleteResult +
                    completeFunc(TStringList(BigJoin[m]));
                end;

                // Nun die Werte in der Tabelle �berschreiben!
                TStringList(BigJoin[m])[ReplaceIndex] := CompleteResult;

              end;
              FeedBack(TFeedbackHelper.Progress(0)).free;

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
              TabelleHorizontal.insertFromFile
                (RohdatenFName(pred(RohdatenCount)));

              // Es kommen alle Zellen der ersten Datenspalte hinzu
              CompleteHeader.clear;
              AllHeader := TStringList(BigJoin[0]);
              for m := 1 to pred(TabelleHorizontal.count) do
              begin
                CompleteResult := TabelleHorizontal.readCell(m, 0);
                AllHeader.Add(nextp(CompleteResult, ':', 0));
                CompleteHeader.Add(CompleteResult);
              end;

              FeedBack(
                { } TFeedbackHelper.Progress(0, 'ProgressBar1',
                { } pred(BigJoin.count) * pred(TabelleHorizontal.count)
                { } )).free;

              StartWait := 0;
              k := 0;
              for l := 1 to pred(TabelleHorizontal.count) do
              begin

                // $-Parameter
                for m := 0 to pred(TabelleHorizontal.Header.count) do
                  ParameterL.values['$' + TabelleHorizontal.Header[m]] :=
                    TabelleHorizontal.readCell(l, m);

                for m := 1 to pred(BigJoin.count) do
                begin

                  if frequently(StartWait, 333) then
                    FeedBack(TFeedbackHelper.Progress(k)).free;

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
                        ParamVal2 := TabelleHorizontal.readCell(l,
                          TabelleHorizontal.colOf(nextp(ParamAll, ',', 1)));

                      // 1. Parameter
                      ParamCol := AllHeader.indexof(nextp(ParamAll, ',', 0));
                      if (ParamCol <> -1) then
                        ParamVal1 := TStringList(BigJoin[m])[ParamCol]
                      else
                        ParamVal1 := TabelleHorizontal.readCell(l,
                          TabelleHorizontal.colOf(nextp(ParamAll, ',', 0)));

                    end
                    else
                    begin
                      ParamVal1 := '';
                      ParamVal2 := '';
                    end;

                    CompleteResult := CompleteResult +
                      completeFunc(TStringList(BigJoin[m]));
                  end;

                  // Nun die Werte zur Tabelle dazu!
                  if (CompleteResult = '') then
                  begin
                    TStringList(BigJoin[m]).Add('');
                  end
                  else
                  begin
                    while (CompleteResult <> '') do
                      TStringList(BigJoin[m])
                        .Add(nextp(CompleteResult, cOLAPcsvSeparator));
                  end;
                  inc(k);
                end;
              end;
              // imp pend: feedback
              // ProgressBar1.Position := 0;
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
              IntegratedL.Add(TStringList.create);
              with TStringList(IntegratedL[0]) do
              begin
                while (ThisHeader <> '') do
                  Add(nextp(ThisHeader, cOLAPcsvSeparator));
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
                    DatumS := copy(DatumS, 7, 4) + '_KW' +
                      inttostrN(Kalenderwoche(date2long(DatumS)), 2);
                  TDG_Monat:
                    DatumS := copy(DatumS, 7, 4) + '_' + copy(DatumS, 4, 2);
                  TDG_Quartal:
                    DatumS := copy(DatumS, 7, 4) + '_Q' +
                      inttostr(Quartal(date2long(DatumS)));
                  TDG_Jahr:
                    DatumS := copy(DatumS, 7, 4);
                end;

                // nun dieses in der vorhandenen Liste suchen, ggf neue Zeile erstellen
                IntegratFound := false;
                for k := 1 to pred(IntegratedL.count) do
                begin
                  if (DatumS = TStringList(IntegratedL[k])[0]) then
                  // ^ imp pend: Im moment GROUP BY nur auf erstes Feld m�glich
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
                        if (pos(',', SingleValue + TStringList(IntegratedL[k])
                          [IntegrateCol]) > 0) then
                        begin
                          // DOUBLE - Typ
                          TStringList(IntegratedL[k])[IntegrateCol] :=
                            format('%.2f',
                            [strtodouble(TStringList(IntegratedL[k])
                            [IntegrateCol]) + strtodouble(SingleValue)]);
                        end
                        else
                        begin
                          // INTEGER - Typ
                          TStringList(IntegratedL[k])[IntegrateCol] :=
                            format('%d',
                            [strtoint(TStringList(IntegratedL[k])[IntegrateCol])
                            + strtoint(SingleValue)]);
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
                  IntegratedL.Add(IntegratedNewL);
                  with IntegratedNewL do
                  begin
                    Add(DatumS);
                    while (OneLine <> '') do
                      Add(nextp(OneLine, cOLAPcsvSeparator));
                  end;
                end;
              end;

              // speichern
              sl.clear;
              for m := 0 to pred(IntegratedL.count) do
                sl.Add(HugeSingleLine(TStringList(IntegratedL[m]),
                  cOLAPcsvSeparator));

              sl.savetofile(RohdatenFName(RohdatenCount));
              SaveCopy(RohdatenFName(RohdatenCount));
              inc(RohdatenCount);
            end;
          end;
        cState_Integrate2:
          begin

            // Aufsummieren und Integrale bilden
            LoadFromFileCSV(true, sl, RohdatenFName(pred(RohdatenCount)));

            // Header unbehandelt hinzu
            ThisHeader := sl[0];
            IntegratedL.Add(TStringList.create);
            with TStringList(IntegratedL[0]) do
            begin
              while (ThisHeader <> '') do
                Add(nextp(ThisHeader, cOLAPcsvSeparator));
            end;

            // Welche Spalte soll als Integrations-Anker verwendet werden
            IntegrateAnkerCol := TStringList(IntegratedL[0])
              .indexof(nextp(Line, ' ', 0));
            if IntegrateAnkerCol <> -1 then
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
                  if (AnkerS = TStringList(IntegratedL[k])[IntegrateAnkerCol])
                  then
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
                          format('%.2m',
                          [strtodouble(TStringList(IntegratedL[k])[IntegrateCol]
                          ) + strtodouble(SingleValue)]);
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
                  IntegratedL.Add(IntegratedNewL);
                  with IntegratedNewL do
                  begin
                    while (OneLine <> '') do
                      Add(nextp(OneLine, cOLAPcsvSeparator));
                  end;
                end;

              end;

              // speichern
              sl.clear;
              for m := 0 to pred(IntegratedL.count) do
                sl.Add(HugeSingleLine(TStringList(IntegratedL[m]),
                  cOLAPcsvSeparator));

              sl.savetofile(RohdatenFName(RohdatenCount));
              SaveCopy(RohdatenFName(RohdatenCount));
              inc(RohdatenCount);
            end
            else
            begin
              raise Exception.create(cERRORText + ' Spalte ' + 'x' +
                'nicht gefunden!');
            end;

          end;
        cState_subtract:
          begin

            if (Line = '-') then
            begin
              LoadJoin(false);
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
              if FileExists(iOlapPath + Line + cVorlageExtension +
                cExcelExtension) then
              begin
                // imp pend: h�����?
                // FormAuswertung.vorlageOLAP(Line, true);
                // Imp pend: Da Auswertungen auch wieder OLAP rufen
                // ist die Fortsetzung des Skripts nicht m�glich
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
                AllHeader.Add(nextp(ThisHeader, cOLAPcsvSeparator));
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
                    SortStr :=
                      inttostrN(round(strtodoubledef(SortStr, 0) * 100.0), 15);
                  if DoReverse and FormatNumeric then
                    for l := 1 to length(SortStr) do
                      SortStr[l] :=
                        chr(ord('0') + pred(pos(SortStr[l], '9876543210')));
                  ClientSorter[pred(m)] := ClientSorter[pred(m)] + SortStr;
                end;
              end;
              ClientSorter.sort;
              SortResult.Add(sl[0]);
              for m := 0 to pred(ClientSorter.count) do
                SortResult.Add(sl[integer(ClientSorter.objects[m])]);
              SortResult.savetofile(RohdatenFName(RohdatenCount));
              SaveCopy(RohdatenFName(RohdatenCount));

              inc(RohdatenCount);
              SortResult.free;
              ClientSorter.free;
              AllHeader.free;
            end;
          end;
      end;
    until false;
    setWaitCaption('#');
  except
    on E: Exception do
    begin
      FeedBack(TFeedbackHelper.ShowMessage(Line + #13 +
        HugeSingleLine(ParameterL, #13) + #13 + 'FILE: ' + FName + #13 + #13 +
        'SQL: ' + ExecuteStatement + #13 + #13 + cERRORText + ' OLAP: ' + #13 +
        E.Message)).free;

    end;
  end;

  sl.free;
  StatementParams.free;
  JoinL.free;
  ParameterL.free;
  ConnectionList.free;
  excelFormats.free;
  rTRANSACTION.free;
  CompleteHeader.free;

  EndHourGlass;
end;

procedure TOLAP.StandardParameter(s: TStrings);

  function prepareValue(s: string): string;
  begin
    result := s;
    ersetze('$', '��', result);
  end;

begin
  with s do
  begin
    Add('$Datum=' + Datum10);
    Add('$Datum10=' + Datum10);
    Add('$Datum8=' + Datum);
    Add('$Diagnose=' + prepareValue(DiagnosePath));
    Add('$SEQ_TAGESABSCHLUSS=' + inttostrN(e_r_gen('GEN_BACKUP'), 8));
    Add('$SEQ_TAGWACHE=' + inttostrN(e_r_gen('GEN_TAGWACHE'), 8));
  end;
end;

begin
  InvRegistry.RegisterInterface(TypeInfo(IOLAP));

end.
