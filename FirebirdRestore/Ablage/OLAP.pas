//   ___    _          _      ____
//  / _ \  | |        / \    |  _ \
// | | | | | |       / _ \   | |_) |
// | |_| | | |___   / ___ \  |  __/
//  \___/  |_____| /_/   \_\ |_|
//
// Never ask me, ask OLAP
//
unit OLAP;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, JvGIF,
  ExtCtrls, SynEditHighlighter, SynHighlighterSQL,
  SynEdit, SynMemo, SynEditExport,
  SynExportHTML, IB_Components, IB_Header,
  IB_Grid, gplists;

type
  TFormOLAP = class(TForm)
    Label1: TLabel;
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    Button3: TButton;
    SaveDialog1: TSaveDialog;
    Label3: TLabel;
    Label4: TLabel;
    ProgressBar1: TProgressBar;
    Image2: TImage;
    SynMemo1: TSynMemo;
    SynSQLSyn1: TSynSQLSyn;
    SynExporterHTML1: TSynExporterHTML;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private
    { Private-Deklarationen }
    Initialized: boolean;
    UnSaved: boolean;
    ActFName: string;
    GlobalVars: TStringList;
    SilentMode: boolean;
    RohdatenCount: integer;

    procedure ReFreshFileList;
    procedure Log(s: string);
    function DefaultFName: string;
    function UserInput(Line: string): string;
  public

    { Public-Deklarationen }
    DataBaseChosen: integer;
    // Haupt - Auswerte Funktionen
    procedure DoContextOLAP(g: TIB_Grid); overload;
    procedure DoContextOLAP(GlobalVars, OLAPScript: TStringList; Connection: TIB_Connection); overload;
    procedure DoContextOLAP(FName: string); overload;
    function OLAP(FName: string): TIntegerList;

    // Tool Funktionen
    function RohdatenFName(n: integer): string;
    function RohdatenxlsFName(n: integer): string;

  end;

var
  FormOLAP: TFormOLAP;

// Faulenzer:
procedure DoContextOLAP(g: TIB_Grid);

implementation

uses
  globals, anfix32, IBExportTable,
  math, CareTakerClient, Musiker,
  eCommerce, HebuData, ArtikelVerlag,
  ExcelHelper, Einstellungen, IB_Session,
  html, OpenOfficePDF;

{$R *.dfm}

function TFormOLAP.DefaultFName: string;
begin
  result := OLAPPath + 'default' + cOLAPExtension;
end;

procedure TFormOLAP.FormActivate(Sender: TObject);
begin
  if not (Initialized) then
  begin
    label2.caption := 'Ihr persönliches OLAP Verzeichnis : ' + OLAPPath;
    CheckCreateDir(OLAPPath);
    if FileExists(DefaultFName) then
      SynMemo1.lines.loadfromFile(DefaultFName);
    ComboBox1.text := ExtractFileName(DefaultFName);
    SaveDialog1.DefaultExt := cOLAPExtension + '|' + 'OLAP Definitions Script';
    Initialized := true;
  end;
  ReFreshFileList;
end;

procedure TFormOLAP.Button1Click(Sender: TObject);
begin
  SaveDialog1.FileName := OLAPPath + ComBoBox1.Text;
  if SaveDialog1.Execute then
  begin
    ComBoBox1.Text := ExtractFileName(SaveDialog1.FileName);
    SynMemo1.lines.savetofile(SaveDialog1.FileName);
    ReFreshFileList;
  end;
end;

procedure TFormOLAP.Button2Click(Sender: TObject);

  function ErgebnisTableName(n: integer): string;
  begin
    result := 'OLAP$TMP' + inttostr(n);
  end;

  procedure AliveOLAP(n: integer);
  begin

    // Tabelle löschen
    DropTable(ErgebnisTableName(n));

    // Tabelle neu anlegen
    DataModuleeCommerce.e_x_sql('create table ' + ErgebnisTableName(n) + ' (' +
      'RID DOM_REFERENCE NOT NULL)');
    DataModuleeCommerce.e_x_sql('alter table ' + ErgebnisTableName(n) +
      ' add constraint PK_' + ErgebnisTableName(n) +
      ' primary key (RID)');
    DataModuleeCommerce.e_x_sql('delete from ' + ErgebnisTableName(n));

  end;

  function IncludeFName(n: integer): string;
  begin
    result := OLAPPath + 'SQL.' + inttostr(max(0, n)) + '.txt';
  end;

  function LoadSQLInclude(n: integer): string;
  var
    TheSQL: TStringList;
  begin
    TheSQL := TStringList.create;
    TheSQL.LoadFromFile(IncludeFName(n));
    result := HugeSingleLine(TheSql, ' ');
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
  cState_Save = 12; // wiederum in die Datenbank rückspeichern
  cState_spread = 13; // 2. Spalte auf horizontale abbilden
  cState_load = 14; // laden einer externen csv in die Datenbank
  cState_repeat = 15; // Wiederholen einer SQL Anweisung mit Inhalten einer Tabelle
  cState_connect = 16; // Verbinden auf eine (andere) Datenbank
  cState_consult = 17; // eine externe Tabelle konsultieren
  cState_excel = 18; // aktuelles Ergebnis als XLS-Tabelle speichern
  cState_add = 19; // einzelne Datenzeilen manuell zu einem Ergebnis hinzunehmen
  cState_spread2 = 20; // 2. Spalte auf horizontale abbilden (alphanumerisch)
  cState_delete = 21; // einzelne Spalten löschen!
  cState_story = 22; // erzählt eine flache Story

var
  m, k, l: integer;
  State: integer;
  CastCount: integer;
  sl: TStringList;
  Line: string;
  LineIndex: integer;
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

  // Parameter Verwaltung
  ParameterL: TStringList;

  // Complete Sachen
  ParamCol: integer;
  ParamAll: string;
  ParamConstant: string;
  ParamFunction: string;
  ParamVal: string;
  CompleteResult: string;
  sLine, FullLine: string;
  CompleteSQL: string;
  CompleteStrL: TStringList;
  CalculateStatement: TStringList;
  cCalc: TIB_cursor;
  NewColumnName: string;
  FirstDollarFound: boolean;

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
  VerlagL: TIntegerList;
  SpreadColName: string;

  // spread-alpha
  SpreadTitle: TStringList;

  // load
  LoadFname: string;
  LoadSQL: string;
  LoadSQLinsert: string;
  SpaltenNamen: TStringList;
  LoadSpalte: TIntegerList;
  LoadSpalteType: TIntegerList;

  // repeat
  RepeatTable: string;
  RepeatSQL, _RepeatSQL: string;
  cRepeat: TIB_Cursor;

  // connect
  ConnectionList: TStringList;
  rTRANSACTION: TIB_Transaction;

  // consult
  col_Question: integer; // Spaltenindex der Fragestellung
  col_ConsultIndex: integer; // Spaltenindex des verwendeten Suchindex
  col_ConsultAnswer: integer; // Spaltenindex der Antwort, die in die fragende
                              // Datei eingefügt wird
  sl_ConsultIndex: TStringList;

  // excel
  xlsAutoOpen: boolean;
  excelFormats: TStringList;

  // delete
  NewLine: string;

  // story
  StatementParams: TStringList; // aktuelle Wertvariable
  AnkerParam: string;
  AnkerValue: string;
  LastAnker: string; // Anker der letzen Zeile
  LastAnkerLine: integer; // dorthin wird die Story erzählt
  AktAnker: string; // aktueller Anker, den es zu bewahren gilt
  StoryFree: TIntegerList; // Liste der unnötigen Zeile
  StoryMaxCol: integer;
  TargetCol: integer;

  procedure setWaitCaption(s: string);
  begin
    label4.caption := s;
    application.processmessages
  end;

  //
  function ResolveParameter(s: string): string;
  var
    n, k, l: integer;
    IsNumeric: boolean;
  begin

    //
    if assigned(GlobalVars) then
      if (GlobalVars.count > 0) then
      begin
        for n := pred(GlobalVars.count) downto 0 do
          ParameterL.insert(0, GlobalVars[n]);
        GlobalVars.clear;
      end;

    //
    result := s;
    ersetze('$$', '€€', result);
    repeat
      k := pos('$', result);
      if k = 0 then
        break;
      l := min(k + 1, length(result));
      IsNumeric := true;
      repeat
        if (l > length(result)) then
          break;
        if not (result[l] in ['a'..'z', 'A'..'Z', '0'..'9', '_']) then
          break;
        if IsNumeric then
          if not (result[l] in ['0'..'9']) then
            IsNumeric := false;
        inc(l);
      until false;
      if IsNumeric then
        ersetze(copy(result, k, l - k), LoadSQLInclude(strtoint(copy(result, k, l - k))), result)
      else
        ersetze(copy(result, k, l - k), ParameterL.values[copy(result, k, l - k)], result);
    until false;
    ersetze('€€', '$', result);
  end;

  procedure SaveJoin;
  var
    m: integer;
  begin
    // fertig -> rausspeichern
    JoinL.clear;
    for m := 0 to pred(BigJoin.count) do
      JoinL.add(HugeSingleLine(TStringList(BigJoin[m]), cOLAPcsvSeparator));
    JoinL.SaveToFile(RohdatenFname(Rohdatencount));
    inc(Rohdatencount);
  end;

  procedure SaveJoinAsExcel;
  begin
    ExcelExport(RohdatenXLSFname(Rohdatencount), BigJoin, nil, excelFormats);
    MakePDF(RohdatenXLSFname(Rohdatencount), RohdatenXLSFname(Rohdatencount) + '.pdf');
  end;

  procedure FreeJoin;
  var
    k: integer;
  begin
    // init für Join
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
    BigJoin.Delete(Index);
  end;

  procedure LoadJoin(UseSameOutPut: boolean = true); // : BigJoin [= List of TStringList];
  var
    n, m, k: integer;
    Cols: TStringList;
    ThisHeader: string;
    ThisLine: string;
    ColCount: integer;
  begin
    LoadFromFileCSV(true, JoinL, RohdatenFname(RohdatenCount - 1));
    ThisHeader := JoinL[0];
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
        end else
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
    LoadFromFileCSV(true, JoinL, OLAPPath + FName);
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

  function AssignDate(d: TANFiXDate): string;
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

  function completeFunc: string;
  var
    l: integer;

    function Plural: string;
    var
      PluralAnker: integer;
      Plural1: string;
      PluralN: string;
    begin
      PluralAnker := AllHeader.indexof(nextp(ParamAll, ','));
      if (PluralAnker = -1) then
      begin
        ShowMessage('complete:Plural: Anker nicht gefunden!');
        result := cOLAPNull;
      end else
      begin
        Plural1 := ExtractSegmentBetween(nextp(ParamAll, ','), '"', '"');
        PluralN := ExtractSegmentBetween(nextp(ParamAll, ','), '"', '"');
        if (strtointdef(TStringList(BigJoin[m])[PluralAnker], 1) = 1) then
          result := Plural1
        else
          result := PluralN;
      end;
      ersetze('_',' ',result);
    end;

  begin
    result := cOLAPnull;
    repeat

      if (pos('"', ParamFunction) > 0) then
      begin
        result := ResolveParameter(ParamConstant);
        break;
      end;

      if (ParamFunction = 'Komponist') then
      begin
        result := FormMusiker.ObtainNamefromMUSIKER_RID(strtointdef(ParamVal, 0));
        break;
      end;

      if (ParamFunction = 'Arrangeur') then
      begin
        result := FormMusiker.ObtainNamefromMUSIKER_RID(strtointdef(ParamVal, 0));
        break;
      end;

      if (ParamFunction = 'KomponistN') then
      begin
        result := FormMusiker.ObtainNurNachNamefromMUSIKER_RID(strtointdef(ParamVal, 0));
        break;
      end;

      if (ParamFunction = 'ArrangeurN') then
      begin
        result := FormMusiker.ObtainNurNachNamefromMUSIKER_RID(strtointdef(ParamVal, 0));
        break;
      end;

      if (ParamFunction = 'Bild') then
      begin
        result := DataModuleeCommerce.e_r_Bild(0, strtointdef(ParamVal, 0));
        break;
      end;

      if (ParamFunction = 'Vorschau') then
      begin
        result := DataModuleeCommerce.e_r_Vorschau(0, strtointdef(ParamVal, 0));
        break;
      end;

      if (ParamFunction = 'Musik') then
      begin
        result := DataModuleeCommerce.e_r_Musik(0, strtointdef(ParamVal, 0));
        break;
      end;

      if (ParamFunction = 'Kontext') then
      begin
        result := DataModuleeCommerce.e_r_Kontext(0, strtointdef(ParamVal, 0));
        break;
      end;

      if (ParamFunction = 'Verlag') then
      begin
        result := FormArtikelVerlag.ObtainVerlagFromPERSON_RID(strtointdef(ParamVal, 0));
        break;
      end;

      if (ParamFunction = 'limit32') then
      begin
        result := _IntToStrN(strtoint64def(noblank(ParamVal), 0), 0);
        break;
      end;

      if (ParamFunction = 'Umsatz') then
      begin
        EinzelPreisUnrabattiert := strtodoubledef(ParamVal, 0.0);
        Rabatt := strtodoubledef(TStringList(BigJoin[m])[ParamCol + 1], 0);
        if (Rabatt > 0) then
          EinzelPreisUnrabattiert := cPreisRundung(EinzelPreisUnrabattiert - (EinzelPreisUnrabattiert * (Rabatt / 100.0)));
        result := format('%.2m', [EinzelPreisUnrabattiert]);
        break;
      end;

      if (ParamFunction = 'Preis') then
      begin
        result := format('%.2m', [DataModuleeCommerce.e_r_PreisBrutto(0, strtointdef(ParamVal, 0))]);
        break;
      end;

      if (ParamFunction = 'Lieferzeit') then
      begin
        result := inttostr(DataModuleeCommerce.e_r_Lieferzeit(0, strtointdef(ParamVal, 0)));
        break;
      end;

      if (ParamFunction = 'Bemerkung') then
      begin
        CompleteStrL := DataModuleeCommerce.e_r_sqlt('select INTERN_INFO from ARTIKEL where RID=' + ParamVal);
        result := ReadLongStr('BEM', CompleteStrL, '|');
        ersetze('"', '''', result);
        result := '"' + result + '"';
        CompleteStrL.free;
        break;
      end;

      if (ParamFunction = 'Anschrift') then
      begin
        if ParamVal = cOLAPnull then
        begin
          result := fill(cOLAPcsvSeparator, 5);
        end else
        begin
          CompleteStrL := DataModuleeCommerce.e_r_Adressat(strtointdef(ParamVal, 0));
          result :=
            CSVsecure(CompleteStrL[0]) + cOLAPcsvSeparator +
            CSVsecure(CompleteStrL[1]) + cOLAPcsvSeparator +
            CSVsecure(CompleteStrL[2]) + cOLAPcsvSeparator +
            CSVsecure(CompleteStrL[3]) + cOLAPcsvSeparator +
            CSVsecure(DataModuleeCommerce.e_r_sqls(
            'SELECT STRASSE from ANSCHRIFT where RID' +
            '=(SELECT PRIV_ANSCHRIFT_R from PERSON where RID=' + ParamVal + ')')) + cOLAPcsvSeparator +
            CSVsecure(DataModuleeCommerce.e_r_Ort(strtointdef(ParamVal, 0)));
          CompleteStrL.free;
        end;
        break;
      end;

      if (ParamFunction = 'Person') then
      begin
        result := __PersonKurz(strtointdef(ParamVal, 0));
        break;
      end;

      if (ParamFunction = 'Fax') then
      begin
        result := DataModuleeCommerce.e_r_fax(strtointdef(ParamVal, 0));
        break;
      end;

      if (ParamFunction = 'Kategorie') then
      begin

        if (ParamVal = LastKategorie) then
          result := 'N'
        else
        begin

          if (length(TStringList(BigJoin[m])[0]) > length(LastCode)) then
          begin
                          // Tiefer
            if (TopKategorie <> '') then
              TopKategorie := TopKategorie + '|' + LastKategorie
            else
              TopKategorie := LastKategorie;

          end;

          if (length(TStringList(BigJoin[m])[0]) < length(LastCode)) then
          begin
                          // Höher
            rnextp(TopKategorie, '|');
          end;

          if (TopKategorie <> '') then
            result := TopKategorie + ':' + ParamVal
          else
            result := ParamVal;

        end;

        LastCode := TStringList(BigJoin[m])[0];
        LastKategorie := ParamVal;

        break;
      end;

      if (ParamFunction = 'Lohn') then
      begin
        result := DataModuleeCommerce.e_r_LohnKalkulation(
          strtodoubledef(ParamVal, 0),
          date2long('01.' +
          ResolveParameter('$MonatJahr')
          ));
        break;
      end;

      if (ParamFunction = 'Plural') then
      begin
        // Plural(ANKER,"der Hase","die Hasen")
        result := Plural;
        break;
      end;


      if FileExists(OLAPPath + cOLAPDimPreFix + ParamFunction + '.txt') then
      begin
                    //
        cCalc := TIB_cursor.create(self);
        CalculateStatement := TStringList.create;
        CalculateStatement.LoadFromFile(OLAPPath + cOLAPDimPrefix + ParamFunction + '.txt');
        CompleteSQL := HugeSingleLine(CalculateStatement, ' ');

                    // Aus der aktuellen Zeile alle Werte in die Parameter schreiben
        if pos('$', CompleteSQL) > 0 then
        begin
          for l := 0 to AllHeader.count - 2 do
            ParameterL.values['$' + AllHeader[l]] :=
              TStringList(BigJoin[m])[l];
          CompleteSQL := ResolveParameter(CompleteSQL);
        end;

        setWaitCaption(CompleteSQL);

        // Ergebnis saugen!
        with cCalc do
        begin
          if assigned(cConnection) then
            IB_Connection := cConnection;
          sql.add(CompleteSQL);
          ApiFirst;
          if eof then
          begin
            if (ParamAll = '') then
              result := cOLAPnull
            else
              result := ParamAll;
          end else
            result := Fields[0].AsString;
        end;
        cCalc.free;
        CalculateStatement.free;
        break;
      end;

                    // ERROR: Unknown Funktion

    until true;
  end;


begin
  BeginHourGlass;

  BigJoin := TList.create;
  IntegratedL := TList.create;
  ParameterL := TStringList.create;
  JoinL := TStringList.create;
  sl := TStringList.create;
  StatementParams := TStringList.create;
  ConnectionList := TStringList.create;
  excelFormats := TStringList.create;
  rTRANSACTION := TIB_Transaction.Create(self);
  with rTRANSACTION do
  begin
    Isolation := tiCommitted;
    AutoCommit := true;
    ReadOnly := True;
  end;

  try

    LastKategorie := '';
    LastCode := '';
    TopKategorie := '';

    RohdatenCount := 0;
    CastCount := 0;
    State := cState_Rohdaten;
    LineIndex := -1;
    ParameterL.add('$Datum=' + Datum10);
    ParameterL.add('$Datum10=' + Datum10);
    ParameterL.add('$Datum8=' + Datum);
    repeat

      inc(LineIndex);

      if (LineIndex = SynMemo1.lines.count) then
        break;

      // Get Line
      Line := cutblank(SynMemo1.lines[LineIndex]);


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
        setWaitCaption(line);

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
      if pos('$', Line) = 1 then
      begin

        ParameterL.add(UserInput(Line));
        continue;
      end;

      // Status Wechsel
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
//        continue;
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

      if (Line = 'sort') then // über Spalten sortieren
      begin
        State := cState_Sort;
        continue;
      end;

      if (Line = 'complete') then // Spalten hinzunehmen anhand von Funktionen oder SQL Statements
      begin
        State := cState_Complete;
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
        continue;
      end;

      if (Line = 'save') then
      begin
        State := cState_Save;
        InitJoin;
        LoadJoin;
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
        LoadFName := nextp(Line, ' ', 1);
        continue;
      end;

      if pos('repeat', Line) = 1 then
      begin
        State := cState_repeat;
        _repeatSQL := '';
        continue;
      end;

      if pos('connect', Line) = 1 then
      begin
        State := cState_connect;
        continue;
      end;

      if pos('consult', Line) = 1 then
      begin
        State := cState_consult;
        LoadFName := nextp(Line, ' ', 1);
        InitJoin;
        LoadJoin;
        continue;
      end;

      if (Line = 'excel') then
      begin
        State := cState_excel;
        excelFormats.clear;
        xlsAutoOpen := false;
        InitJoin;
        LoadJoin;
        continue;
      end;

      case State of
        cState_excel: begin
            if (Line <> '-') then
            begin
              if (line = 'open') then
                xlsAutoOpen := true;
              if (pos('=', line) > 0) then
                excelFormats.add(line);
            end else
            begin
              SaveJoinAsExcel;
              if xlsAutoOpen then
                open(RohdatenXLSFname(Rohdatencount));
            end;
          end;
        cState_connect: begin

            if (Line <> '-') then
            begin
              ConnectionList.add(nextp(line, ' ', 0));
              // ConnectionAlias.add(nextp(line,' ',1));
            end else
            begin
              cConnection := TIB_Connection.create(self);
              with cConnection do
              begin
                DefaultTransaction := rTRANSACTION;
                LoginDBReadOnly := true;
                Protocol := cpTCP_IP;
                DataBaseName := iServerName + ':' + ConnectionList[DataBaseChosen];
                UserName := 'SYSDBA';
                Password := FormEinstellungen.SysDBAPassword;
              end;
              rTRANSACTION.IB_Connection := cConnection;

              cConnection.connect;
            end;

          end;
        cState_Rohdaten: begin

            // Eine einzelne Zeile machen
            // die erste Leerzeile markiert das Ende
            repeat
              if (LineIndex + 1 = SynMemo1.lines.count) then
                break;
              if cutblank(SynMemo1.lines[LineIndex + 1]) = '' then
                break;

              inc(LineIndex);
              line := line + ' ' + nextp(SynMemo1.lines[LineIndex], '--', 0);
            until false;

            line := ResolveParameter(line);

            if (line <> '-') then
            begin

              // Ist es ein Select-Statement oder ein Script?
              if (pos('SELECT', AnsiUpperCase(cutblank(line))) = 1) then
                ExportTable(line, RohdatenFName(Rohdatencount), cOLAPcsvSeparator)
              else
                ExportScript(line, RohdatenFName(Rohdatencount), cOLAPcsvSeparator);

              //
              inc(Rohdatencount);
            end;
          end;
        cState_Cast: begin
            if (Line <> '-') then
            begin
              loadfromFileCSV(true, sl, RohdatenFName(CastCount));
              while (line <> '') do
              begin
                // commando ausarbeiten
                for m := 1 to pred(sl.count) do
                begin
                  sl[m] :=
                    nextp(nextp(sl[m], cOLAPcsvSeparator, 0), ' ', 0) +
                    cOLAPcsvSeparator +
                    nextp(sl[m], cOLAPcsvSeparator, 1) +
                    cOLAPcsvSeparator;
                end;
                break;
              end;
              sl.SavetoFile(RohdatenFName(CastCount));
            end;
            Inc(CastCount);
          end;
        cState_consult: begin
            if (Line = '-') then
            begin
              //
              SaveJoin;
            end else
            begin

              // Immer zur aktuellen Liste noch die neuen Daten
              // hinzunehmen. Erscheinen neue Felder:
              // 1) modifiziere den Header (+neues Feld)
              // 2) erzeuge "Null" Daten für jedes neue Feld

              sl_ConsultIndex := TStringList.create;
              if not (FileExists(OLAPPath + LoadFName)) then
                raise Exception.create('Datei ' + OLAPPath + LoadFName + ' nicht gefunden!');
              LoadFromFileCSV(true, JoinL, OLAPPath + LoadFName);

              // Quell Spalte suchen
              AllHeader := TStringList(BigJoin[0]);
              col_Question := AllHeader.indexof(nextp(line, ',', 0));
              if (col_Question = -1) then
                raise exception.create('Referenzierende Spalte "' + nextp(line, ',', 0) + '" nicht gefunden!');

              // Index und Antwort suchen
              col_consultAnswer := -1;
              col_consultIndex := -1;
              ThisHeaderAnz := 0;
              ThisHeader := JoinL[0];
              while (ThisHeader <> '') do
              begin
                inc(ThisHeaderAnz);
                OneHeader := nextp(ThisHeader, cOLAPcsvSeparator);
                repeat
                  //
                  if (OneHeader = nextp(line, ',', 1)) then
                  begin
                    col_ConsultIndex := pred(ThisHeaderAnz);
                    break;
                  end;
                  //
                  if (OneHeader = nextp(line, ',', 2)) then
                  begin
                    col_ConsultAnswer := pred(ThisHeaderAnz);
                    AllHeader.add(OneHeader);
                    break;
                  end;
                  break;
                until false;
              end;
              if (col_ConsultIndex = -1) then
                raise Exception.create('Referenz Spalte "' + nextp(line, ',', 1) + '" in Datei "' + LoadFName + '" nicht gefunden!');
              if (col_ConsultAnswer = -1) then
                raise Exception.create('Antwort Spalte "' + nextp(line, ',', 2) + '" in Datei "' + LoadFName + '" nicht gefunden!');

              // Antwort Index aufbauen
              for m := 1 to pred(JoinL.count) do
                sl_ConsultIndex.addobject(nextp(JoinL[m], cOLAPcsvSeparator, col_ConsultIndex), pointer(m));
              sl_ConsultIndex.sort;
              sl_ConsultIndex.sorted := true;

              // Doppelte sollten hier vermieden werden.
              if (RemoveDuplicates(sl_ConsultIndex) > 0) then
                raise Exception.create('Referenz Spalte "' + nextp(line, ',', 1) + '" in Datei "' + LoadFName + '" hat doppelte Einträge!');

              // Nun den Referenzierlauf
              for m := 1 to pred(BigJoin.count) do
              begin
                AllHeader := TStringList(BigJoin[m]);
                k := sl_ConsultIndex.indexof(AllHeader[col_Question]);
                if (k = -1) then
                  AllHeader.add(cOLAPnull)
                else
                  AllHeader.add(nextp(JoinL[integer(sl_ConsultIndex.objects[k])], cOLAPcsvSeparator, col_ConsultAnswer));
              end;

              sl_ConsultIndex.free;

            end;

          end;
        cState_story: begin
            if (Line = '-') then
            begin
              // Optimierungs-Möglichkeiten
              // a) im Rahmen eines einmaligen Parserlaufes die
              //    Ankerspalten bestimmen, in ein Integerlist
              //    speichern. Später gaanz schnell den Anker
              //    zusammenbauen.
              // b) Eine IntergerList für die CopySpalten bilden

              StoryFree := TIntegerList.create;

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
                  k := AllHeader.indexof(nextp(AnkerPAram, cOLAPcsvSeparator));
                  if (k <> -1) then
                    AnkerValue := AnkerValue + TStringList(BigJoin[m])[k]
                  else
                    ShowMessage('story: Anker ist unbekannt!');
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
                        TStringList(BigJoin[LastAnkerLine]).add(
                          TStringList(BigJoin[m])[k]);
                      end else
                      begin
                        SortRow := cutblank(TStringList(BigJoin[m])[k]);
                        if (SortRow <> '') and (SortRow <> cOLAPnull) then
                        begin
                          SortStr := cutblank(TStringList(BigJoin[LastAnkerLine])[TargetCol]);
                          if (SortStr = '') or (SortStr = cOLAPnull) then
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
                end else
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
            end else
            begin
              StatementParams.add(Line);
            end;

          end;
        cState_delete: begin
            if (Line = '-') then
            begin
              SaveJoin;
            end else
            begin
              k := strtointdef(line, 0);
              if (k > 0) and (k <= TStringList(BigJoin[0]).count) then
                for m := 0 to pred(BigJoin.count) do
                  TStringList(BigJoin[m]).delete(pred(k));
            end;
          end;
        cState_Join: begin

            //
            if (Line = '-') then
            begin

              SaveJoin;


            end else
            begin

              // Immer zur aktuellen Liste noch die neuen Daten
              // hinzunehmen. Erscheinen neue Felder:
              // 1) modifiziere den Header (+neues Feld)
              // 2) erzeuge "Null" Daten für jedes neue Feld

              dec(RohdatenCount);
              LoadFromFileCSV(true, JoinL, RohdatenFname(RohdatenCount));

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
        cState_add: begin
            if (Line = '-') then
            begin

              SaveJoin;

            end else
            begin

              AllHeader := TstringList(BigJoin[0]);
              JoinedL := TStringList.create;
              BigJoin.add(JoinedL);
              for k := 0 to pred(AllHeader.count) do
                JoinedL.add(nextp(line, cOLAPcsvSeparator));

            end;
          end;
        cState_Extent: begin

            //
            if (Line = '-') then
            begin

              SaveJoin;

            end else
            begin

              // Immer zur aktuellen Liste noch die neuen Spalten rechts
              // erweitern hinzunehmen. Erweitert wird über die Spalte
              dec(RohdatenCount);
              LoadFromFileCSV(true, JoinL, RohdatenFname(RohdatenCount));

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
        cState_List: begin
            if (Line = '-') then
            begin
              State := cState_Rohdaten;
            end else
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
                for m := 1 to pred(BigJoin.Count) do
                begin
                  if (TStringList(BigJoin[m])[ListCol] = cOLAPnull) then
                  begin
                    ListResults.Add('0');
                  end else
                  begin
                    if ListNumeric then
                    begin
                      ListResults.Add(TStringList(BigJoin[m])[ListCol]);
                    end else
                    begin
                      ListResults.Add('''' + TStringList(BigJoin[m])[ListCol] + '''');
                    end;
                  end;
                end;

                if ListDistinct then
                begin
                  ListResults.Sort;
                  removeduplicates(ListResults);
                end;

                ListResult := '(' + HugeSingleLine(Listresults, ' ,') + ')';

              //
                FileDelete(IncludeFName(Rohdatencount));
                AppendStringsToFile(ListResult, IncludeFName(Rohdatencount));

              end else
              begin
                exception.create('list: ' + ListColName + ' nicht gefunden');
              end;
              ListResults.free;
            end;
          end;
        cState_repeat: begin
            //
            if (Line = '-') then
            begin
              StartWait := 0;
              inc(RohdatenCount);

              FileDelete(RohdatenFName(Rohdatencount));

              cRepeat := TIB_Cursor.create(self);
              with cRepeat do
              begin
                sql.add('select * from ' + ErgebnisTableName(Rohdatencount - 1));
                setWaitCaption(sql[0]);
                ApiFirst;
                l := 0;
                progressbar1.max := recordcount;
                while not (eof) do
                begin
                  ParameterL.values['$RID'] := Fields[0].AsString;
                  RepeatSQL := ResolveParameter(_RepeatSQL);

                  while (RepeatSQL <> '') do
                  begin
                    if (pos('SELECT', AnsiUpperCase(cutblank(RepeatSQL))) = 1) then
                    begin
                      // select part
                      ExportTable(nextp(RepeatSQL, '~'), RohdatenFName(Rohdatencount), cOLAPcsvSeparator, true)
                    end else
                    begin
                      // update / insert part
                      DatamoduleeCommerce.e_x_sql(nextp(RepeatSQL, '~'));
                    end;
                  end;
                  ApiNext;
                  inc(l);
                  if frequently(StartWait, 333) or eof then
                  begin
                    setWaitCaption(RepeatSQL);
                    application.processmessages;
                    progressbar1.position := l;
                  end;
                end;
              end;
              progressbar1.position := 0;
              cRepeat.free;
              //
              inc(Rohdatencount);
              State := cState_Rohdaten;
            end else
            begin
              _repeatSQL := _rePeatSQL + ' ' + line;
            end;
          end;
        cState_load: begin

            if (line = '-') then
            begin

              // bisherige Tabelle löschen
              DropTable(ErgebnisTableName(Rohdatencount));

              // jetzt wird die Tabelle angelegt
              LoadSQL := '';
              for m := pred(SpaltenNamen.count) downto 0 do
              begin
                LoadSQL := LoadSQL +
                  nextp(SpaltenNamen[m], ' ', 0) + ' ' +
                  nextp(SpaltenNamen[m], ' ', 1);
                if (m <> 0) then
                  LoadSql := LoadSql + ', ';
              end;

              DataModuleeCommerce.e_x_sql(
                'create table ' +
                ErgebnisTableName(Rohdatencount) +
                ' ( ' + LoadSQL + ')');

              LoadSQL := '';
              for m := pred(SpaltenNamen.count) downto 0 do
              begin
                LoadSQL := LoadSQL + nextp(SpaltenNamen[pred(SpaltenNamen.count) - m], ' ', 0);
                if (m <> 0) then
                  LoadSQL := LoadSQL + ',';
              end;

              // QuellDatei laden
              InitJoin;
              LoadJoinFrom(LoadFname);

              // Quell Spalten Index anlegen
              LoadSpalte := TIntegerList.create;
              LoadSpalteType := TIntegerList.create;
              for m := 0 to pred(SpaltenNamen.count) do
              begin
                LoadSpalte.add(
                  TStringList(BigJoin[0]).indexof(
                  nextp(SpaltenNamen[m], ' ', 2)));
                if pos('char', nextp(SpaltenNamen[m], ' ', 1)) = 1 then
                  LoadSpalteType.add(SQL_TEXT)
                else
                  LoadSpalteType.add(0);
              end;

              // jetzt gehts los! Insert Insert!
              progressbar1.max := BigJoin.Count;
              StartWait := 0;

              for m := 1 to pred(BigJoin.Count) do
              begin
                //
                LoadSQLinsert :=
                  'insert into ' +
                  ErgebnisTableName(Rohdatencount) +
                  '(' + LoadSQL + ') values (';

                //
                for k := 0 to pred(SpaltenNamen.count) do
                begin

                  case LoadSpalteType[k] of
                    SQL_TEXT: begin
                        LoadSQLinsert := LoadSQLinsert + '''' +
                          TStringlist(BigJoin[m])[LoadSpalte[k]] + '''';

                      end;
                  else
                    LoadSQLinsert := LoadSQLinsert +
                      TStringlist(BigJoin[m])[LoadSpalte[k]];

                  end;

                  if (k < pred(SpaltenNamen.count)) then
                    LoadSQLinsert := LoadSQLinsert + ',';
                end;

                DatamoduleeCommerce.e_x_sql(LoadSQLinsert + ')');

                if frequently(StartWait, 333) then
                begin
                  progressbar1.position := m;
                  application.processmessages;
                end;

              end;
              FreeAndNil(LoadSpalte);
              FreeAndNil(LoadSpalteType);
              FreeAndNil(SpaltenNamen);
              progressbar1.position := 0;
              //
              State := cState_subtract;

            end else
            begin

              // Spaltennamen aufsammeln
              if not (assigned(SpaltenNamen)) then
                SpaltenNamen := TStringList.create;
              if (line <> '') then
                SpaltenNamen.add(line);
            end;
          end;
        cState_Save: begin

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

                AliveOLAP(Rohdatencount);

                // nun speichern!
                for m := 1 to pred(BigJoin.Count) do
                begin
                  if (TStringList(BigJoin[m])[ListCol] <> cOLAPnull) then
                  begin
                    if ListNumeric then
                      DatamoduleeCommerce.e_x_sql('insert into ' + ErgebnisTableName(Rohdatencount) +
                        '(RID)values(' + TStringList(BigJoin[m])[ListCol] + ')');
                  end;
                end;

              end else
              begin
                ShowMessage('save: Spalte ' + ListColName + ' nicht gefunden!');
              end;
              ListResults.free;

              State := cState_Rohdaten;
            end;

          end;
        cState_spread: begin

            if (Line = '-') then
            begin
              SaveJoin;
            end else
            begin

              SpreadColName := TStringList(BigJoin[0])[1];
              VerlagL := TIntegerList.create;
              for m := 1 to pred(BigJoin.count) do
                if (TStringList(BigJoin[m])[1] <> cOLAPnull) then
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

                    TStringList(BigJoin[l])[k + SpaltenIst] := inttostr(
                      strtointdef(TStringList(BigJoin[l])[k + SpaltenIst], 0) +
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
        cState_spread2: begin

            if (Line = '-') then
            begin
              SaveJoin;
            end else
            begin
              SpreadColName := TStringList(BigJoin[0])[1];
              SpreadTitle := TStringList.create;

              // alle neuen Spalten Überschriften sammeln
              for m := 1 to pred(BigJoin.count) do
                if (TStringList(BigJoin[m])[1] <> cOLAPnull) then
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

                    TStringList(BigJoin[l])[k + SpaltenIst] := inttostr(
                      strtointdef(TStringList(BigJoin[l])[k + SpaltenIst], 0) +
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
        cState_Assign: begin

            if (Line = '-') then
            begin

              SaveJoin;

            end else
            begin

              //
              AssignDatumCol := TStringList(BigJoin[0]).indexof(nextp(Line, ' ', 0));
              AssignWertCol := TStringList(BigJoin[0]).indexof(nextp(Line, ' ', 1));

              // Header um die Zeiten $Start ... $Ende erweitern
              MonatsNamen := TStringList.create;
              MonatsSpaltenOffset := TStringList(BigJoin[0]).count;
              AssignStart := date2long(ResolveParameter('$Start'));
              AssignEnde := date2long(ResolveParameter('$Ende'));
              AssignRun := AssignStart;
              repeat

                //
                MonatsName := AssignDate(AssignRun);
                if (MonatsNamen.IndexOf(MonatsName) = -1) then
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
                MonatsName := AssignDate(
                  date2long(
                  nextp(TStringList(BigJoin[m])[AssignDatumCol], ' ', 0)
                  ));
                MonatsN := MonatsNamen.indexof(MonatsName);
                AssignWert := format('%.2m', [strtodouble(TStringList(BigJoin[m])[AssignWertCol])]);
                TStringList(BigJoin[m])[AssignWertCol] := AssignWert;

                for k := 0 to pred(MonatsNamen.count) do
                  if (k = MonatsN) then
                    TStringList(BigJoin[m]).add(AssignWert)
                  else
                    TStringList(BigJoin[m]).add('0 €');
              end;
              MonatsNamen.Free;
            end;

          end;
        cState_complete: begin

            if (Line = '-') then
            begin

              SaveJoin;

            end else
            begin

              // Name der neuen Spalte(n) hinzufügen
              NewColumnName := nextp(Line, ' ', 1);
              if (NewColumnName = '') then
                NewColumnName := ParamFunction;
              AllHeader := TStringList(BigJoin[0]);
              while (NewColumnName <> '') do
                AllHeader.add(nextp(NewColumnName, cOLAPcsvSeparator));


              Progressbar1.max := BigJoin.count;
              StartWait := 0;
              for m := 1 to pred(BigJoin.count) do
              begin

                if frequently(StartWait, 333) then
                begin
                  Progressbar1.Position := m;
                  application.processmessages;
                end;

                FullLine := nextp(Line, ' ', 0);
                CompleteResult := '';
                while (FullLine <> '') do
                begin
                  sLine := nextp(FullLine, cC_concant);

                  // Quell-Parameter
                  ParamAll := ExtractSegmentBetween(sLine, '(', ')');
                  ParamCol := AllHeader.indexof(ParamAll);
                  ParamConstant := ExtractSegmentBetween(sLine, '"', '"');
                  // Ersetzen-Funktion
                  ParamFunction := nextp(sLine, '(', 0);

                  if (ParamCol <> -1) then
                    ParamVal := TStringList(BigJoin[m])[ParamCol]
                  else
                    ParamVal := '';

                  CompleteResult := CompleteResult + completeFunc;
                end;

                // Nun die Werte zur Tabelle dazu!
                if (CompleteResult = '') then
                begin
                  TStringList(BigJoin[m]).add('');
                end else
                begin
                  while (CompleteResult <> '') do
                    TStringList(BigJoin[m]).add(nextp(CompleteResult, cOLAPcsvSeparator));
                end;

              end;
              Progressbar1.Position := 0;
            end;
          end;
        cState_Integrate: begin

            // Aufsummieren und Integrale bilden
            LoadFromFileCSV(true, sl, RohdatenFName(pred(Rohdatencount)));

            // Header unbehandelt hinzu
            ThisHeader := sl[0];
            IntegratedL.add(TstringList.create);
            with TStringList(IntegratedL[0]) do
            begin
              while (ThisHeader <> '') do
                add(nextp(ThisHeader, cOLAPcsvSeparator));
            end;

            for m := 1 to pred(sl.count) do
            begin

              //
              OneLine := sl[m];

              // Datum erstellen
              datumS := nextp(OneLine, cOLAPcsvSeparator);
              datumS := nextp(datumS, ' '); // ev. ist es ein Timestamp!
              datumS := copy(datumS, 7, 4) + '_' + copy(DatumS, 4, 2); // 2005_01

              // nun dieses in der vorhandenen Liste suchen, ggf neue Zeile erstellen
              IntegratFound := false;
              for k := 1 to pred(IntegratedL.count) do
              begin
                if (datumS = TStringList(IntegratedL[k])[0]) then
              //                                       ^ imp pend: Im moment GROUP BY nur auf erstes Feld möglich
                begin
                  // ok gefunden -> jetzt summieren / integrieren
                  IntegrateCol := 0;
                  while (OneLine <> '') do
                  begin
                    inc(IntegrateCol);
                    SingleValue := nextp(OneLine, cOLAPcsvSeparator);
                    //
                    if (SingleValue <> cOLAPnull) then
                    begin
                      if (pos(',', SingleValue + TStringList(IntegratedL[k])[IntegrateCol]) > 0) then
                      begin
                        // DOUBLE - Typ
                        TStringList(IntegratedL[k])[IntegrateCol] := format('%.2f', [strtodouble(TStringList(IntegratedL[k])[IntegrateCol]) +
                          strtodouble(SingleValue)]);
                      end else
                      begin
                        // INTEGER - Typ
                        TStringList(IntegratedL[k])[IntegrateCol] := format('%d', [strtoint(TStringList(IntegratedL[k])[IntegrateCol]) +
                          strtoint(SingleValue)]);
                      end;
                    end;
                  end;
                  IntegratFound := true;
                  break;
                end;
              end;

              if not (IntegratFound) then
              begin

                // Zeile neu hinzu
                IntegratedNewL := TStringList.create;
                IntegratedL.add(IntegratedNewL);
                with INtegratedNewL do
                begin
                  add(datumS);
                  while (OneLine <> '') do
                    add(nextp(OneLine, cOLAPcsvSeparator));
                end;
              end;
            end;

            // speichern
            sl.clear;
            for m := 0 to pred(IntegratedL.count) do
              sl.add(HugeSingleLine(TSTringList(IntegratedL[m]), cOLAPcsvSeparator));

            sl.SaveToFile(RohdatenFname(Rohdatencount));
            inc(Rohdatencount);

          end;
        cState_subtract: begin

            if (Line = '-') then
            begin
              LoadJoin(false);
              RedList := TStringList.create;
              LoadFromFileCSV(true, RedList, RohdatenFName(Rohdatencount - 2));
              for m := 1 to pred(RedList.count) do
              begin
                RedValue := nextp(RedList[m], cOLAPcsvSeparator, 0);
                for k := pred(BigJoin.count) downto 1 do
                  if (TStringList(BigJoin[k])[0] = RedValue) then
                    JoinDeleteLine(k);
              end;
              SaveJoin;
            end;

          end;
        cState_Integrate2: begin

            // Aufsummieren und Integrale bilden
            LoadFromFileCSV(true, sl, RohdatenFName(pred(Rohdatencount)));

            // Welche Spalte soll als Integrations-Anker verwendet werden
            IntegrateAnkerCol := TStringList(BigJoin[0]).indexof(nextp(Line, ' ', 0));

            // Header unbehandelt hinzu
            ThisHeader := sl[0];
            IntegratedL.add(TstringList.create);
            with TStringList(IntegratedL[0]) do
            begin
              while (ThisHeader <> '') do
                add(nextp(ThisHeader, cOLAPcsvSeparator));
            end;

            // Welche Spalte soll als Integrations-Anker verwendet werden
            IntegrateAnkerCol := TStringList(IntegratedL[0]).indexof(nextp(Line, ' ', 0));
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
                          format('%.2m', [
                          strtodouble(TStringList(IntegratedL[k])[IntegrateCol]) +
                            strtodouble(SingleValue)]);
                      end;
                      inc(IntegrateCol);
                    end;
                    IntegratFound := true;
                    break;
                  end;
                end;

                if not (IntegratFound) then
                begin

                  // Zeile neu hinzu
                  IntegratedNewL := TStringList.create;
                  IntegratedL.add(IntegratedNewL);
                  with INtegratedNewL do
                  begin
                    while (OneLine <> '') do
                      add(nextp(OneLine, cOLAPcsvSeparator));
                  end;
                end;

              end;

              // speichern
              sl.clear;
              for m := 0 to pred(IntegratedL.count) do
                sl.add(HugeSingleLine(TSTringList(IntegratedL[m]), cOLAPcsvSeparator));

              sl.SaveToFile(RohdatenFname(Rohdatencount));
              inc(Rohdatencount);
            end else
            begin
              Log(cERRORText + ' Spalte ' + 'x' + 'nicht gefunden!');
            end;

          end;
        cState_Sort: begin
            if (Line <> '-') then
            begin
              // Aktuelle Datei sortieren
              ClientSorter := TStringList.create;
              SortResult := TStringList.create;
              AllHeader := TStringList.create;

              // Quelle laden, alle Header aufzeichnen
              LoadFromFileCSV(true, sl, RohdatenFname(pred(Rohdatencount)));
              ThisHeader := sl[0];
              while (ThisHeader <> '') do
                AllHeader.add(nextp(ThisHeader, cOLAPcsvSeparator));
              for m := 1 to pred(sl.count) do
                ClientSorter.addobject('', TObject(m));
              while (line <> '') do
              begin
                SortRow := nextp(line, cOLAPcsvSeparator);
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
              Sortresult.SaveToFile(RohdatenFname(Rohdatencount));
              inc(Rohdatencount);
              SortResult.free;
              ClientSorter.free;
              AllHeader.Free;
            end;
          end;
      end;
    until false;
    setWaitCaption('#');
  except
    on E: Exception do
    begin
      ShowMessage(line + #13 +
        HugeSingleLine(ParameterL, #13) + #13 +
        cERRORText + ' OLAP: ' + #13 +
        E.Message);
    end;
  end;

  sl.free;
  StatementParams.free;
  JoinL.free;
  ParameterL.free;
  ConnectionList.free;
  excelFormats.free;
  rTRANSACTION.free;

  EndHourGlass;
end;

procedure TFormOLAP.Button3Click(Sender: TObject);
begin
  open(OLAPPath);
end;

procedure TFormOLAP.ReFreshFileList;
var
  AllOLAPs: TStringList;
begin
  AllOLAPs := TStringList.create;
  dir(OLAPPath + '*' + cOLAPExtension, ALLOLAPS, false);
  AllOLAPs.sort;
  ComboBox1.items.assign(AllOLAPs);
  AllOLAPs.free;
end;

procedure TFormOLAP.ComboBox1Select(Sender: TObject);
begin
  if UnSaved then
    if DoIt('OLAP-Script geändert!' + #13 + 'Jetzt speichern') then
      SynMemo1.lines.SaveToFile(ActFName);
  SynMemo1.lines.LoadFromFile(OLAPPath + Combobox1.Text);
end;

procedure TFormOLAP.Image2Click(Sender: TObject);
begin
  open(cHelpURL + 'OLAP');
end;

procedure TFormOLAP.Log(s: string);
begin
 //
end;

function TFormOLAP.OLAP(FName: string): TIntegerList;
var
  myRIDs: TSTringList;
  n: integer;
  aRID: integer;
begin
  result := TIntegerList.create;
  myRIDs := TStringList.create;
  try
    DoContextOLAP(OLAPPath + FName + '.OLAP.txt');
    myRIDs.loadFromFile(RohDatenFName(pred(RohdatenCount)));
    for n := 1 to pred(myRIDs.count) do
      if (myRIDs[n] <> cOLAPnull) then
      begin
        aRID := strtointdef(nextp(myRIDs[n], ';', 0), 0);
        if (aRID > 0) then
          result.add(aRID);
      end;
  except

  end;
  myRIDs.free;
end;

function TFormOLAP.RohdatenFName(n: integer): string;
begin
  result := OLAPPath + 'OLAP.tmp' + inttostr(max(0, n)) + '.csv';
end;

function TFormOLAP.RohdatenxlsFName(n: integer): string;
begin
  result := UserDir + 'OLAP-Ergebnis.xls';
end;

function TFormOLAP.UserInput(Line: string): string;
var
  DynForm: TForm;
  AskLabel: TLabel;
  AskSelect: TCombobox;
  DimensionValues: TStringList;
  n: integer;
begin
  result := line;
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
    AskSelect := TCombobox.create(nil);
    with AskSelect do
    begin
      top := 10;
      left := 150;
    end;

    DynForm := TForm.Create(self);
    with DynForm do
    begin
      caption := 'Dimensionsbestimmung ' + nextp(Line, '=', 0);
      Position := poScreenCenter;
      clientwidth := 350;
      clientheight := 40;
      insertcontrol(AskLabel);
      insertcontrol(AskSelect);

      // Controlls füllen!
      DimensionValues := TStringList.create;
      DimensionValues.loadfromFile(RohdatenFname(strtointdef(nextp(Line, 'from', 1), 0)));
      DimensionValues.delete(0);
      for n := 0 to pred(DimensionValues.count) do
      begin
        if (pos('"', DimensionValues[n]) = 1) then
          DimensionValues[n] := ExtractSegmentBetween(DimensionValues[n], '"', '"');
      end;
      DimensionValues.sort;

      AskSelect.items.assign(DimensionValues);
      DimensionValues.free;

      ShowModal;
    end;

    result := AskSelect.text;

  end;

end;

procedure TFormOLAP.DoContextOLAP(g: TIB_Grid);
var
  FName: string;
  n: integer;
begin
  try
    FName := OLAPPath + GridSettingsIdentifier(g) + cOLAPExtension;
    if FileExists(FName) then
    begin

      // Lister der Globales Variable aufbauen!
      if assigned(GlobalVars) then
        GlobalVars.clear
      else
        GlobalVars := TStringList.create;

      //
      with g.DataSource.Dataset do
      begin
        for n := 0 to pred(FieldCount) do
          with Fields[n] do
          begin
            if IsNull then
            begin
              GlobalVars.add('$' + FieldName + '=null');
            end else
            begin
              case SQLType of
                SQL_DOUBLE,
                  SQL_DOUBLE_,
                  SQL_INT64,
                  SQL_INT64_,
                  SQL_SHORT,
                  SQL_SHORT_,
                  SQL_LONG,
                  SQL_LONG_,
                  SQL_VARYING,
                  SQL_VARYING_,
                  SQL_TEXT,
                  SQL_TEXT_,
                  SQL_TIMESTAMP,
                  SQL_TIMESTAMP_,
                  SQL_TYPE_DATE,
                  SQL_TYPE_DATE_: begin
                    GlobalVars.add('$' + FieldName + '=' + AsString);
                  end;
              end;
            end;
          end;
      end;

      // Ausführen
      SynMemo1.lines.LoadFromFile(FName);
      SynMemo1.lines.addstrings(globalvars);
      SilentMode := true;
      Button2Click(nil);

    end else
    begin
      ShowMessage(FName);
    end;
  except
  end;
  SilentMode := false;
end;

procedure DoContextOLAP(g: TIB_Grid);
begin
  FormOLAP.DoContextOLAP(g);
end;

procedure TFormOLAP.DoContextOLAP(GlobalVars, OLAPScript: TStringList;
  Connection: TIB_Connection);
begin

end;

procedure TFormOLAP.DoContextOLAP(FName: string);
begin
  SynMemo1.lines.LoadFromFile(FName);
  SilentMode := true;
  Button2Click(nil);
  SilentMode := false;
end;

end.

