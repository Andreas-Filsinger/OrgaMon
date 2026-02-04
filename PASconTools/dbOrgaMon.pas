{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2023  Andreas Filsinger
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
unit dbOrgaMon;

{$ifdef fpc}
{$mode delphi}
{$endif}

interface

{

  dbOrgaMon: Abstrahiert die Datenbankschicht, stellt dazu einige

  dbo* ("dbo" für DatenBank OrgaMon) -Klassen zur Verfügung

}

uses
  Classes,
{$IFDEF fpc}
  db,
  ZConnection,
  ZClasses,
  ZDataset,
  ZDatasetUtils,
  ZAbstractDataset,
  ZAbstractConnection,
  ZDbcResultSetMetadata,
  ZSQLProcessor,
  //ZStreamBlob,
  ZDbcInterbase6,
  ZSequence,
{$ELSE}
  IB_Components,
  IB_Access,
  {$ifndef IBO_OLD}
  IB_ClientLib,
  {$endif}
  //Datenbank,
{$ENDIF}
  gplists,
  WordIndex,
  anfix,
  basic,
  globals;

const
 DROP_BUG : boolean = true;

type
{$IFDEF fpc}
  TdboDatasource = TDatasource;
  TdboDataset = TDataset;

  { TdboScript }

  TdboScript = class(TZSQLProcessor)
  public
    function sql: TStrings;
    procedure Prepare;
  end;

  TdboField = TField;

  { TdboCursor }

  TdboCursor = class(TZReadOnlyQuery)
  public
    procedure ApiFirst;
    procedure ApiNext;
  end;

  { TdboQuery }

  TdboQuery = class(TZQuery)
  public
    procedure Insert;
  end;

{$ELSE}

  TdboQuery = TIB_Query;
  TdboField = TIB_Column;
  TdboDataset = TIB_Dataset;
  TdboDatasource = TIB_Datasource;
  TdboCursor = TIB_Cursor;
  TdboScript = TIB_DSQL;
{$ENDIF}

const
  cSQLwhereMarker = '-- BEGIN';
  cSQLExtension = '.sql.txt';
  cSicherungsPrefix = 'sicherung_';

  // Datenbank Ankreuzfelder (Check)
  cC_True = 'Y';
  cC_True_AsString = '''Y''';
  cC_False = 'N';
  cC_False_AsString = '''N''';
  cC_concant = '||';
  cC_CRLF = '||ASCII_CHAR(13)||ASCII_CHAR(10)||';

  // erlaubte Zeichen bei Tabellennamen
  cTabellen = cZiffern + cBuchstaben + '$_';

  // Datenbank Referenz Identitäten
  cRID_Unset = -2;
  cRID_NULL = -1;
  sRID_NULL = '<NULL>';
  cRID_AutoInc = 0;
  cRID_Impossible = MaxInt;
  sRID_AutoInc = '0';
  cRID_FirstValid = 1;

type
  TSQLStringList = class(TStringList)
  public
    procedure ReplaceBlock(BlockName: string; NewLines: string);
  end;

  // Tools für ELEMENT
  TdboClub = class(TObject)
    ID: integer;
    RefTable: string;
    items: TgpIntegerList;

  private
    function TableName: string;

  public
    constructor create(pRefTable: string); virtual;
    destructor Destroy; override;

    procedure add(i: integer); overload;
    procedure add(i: TgpIntegerList); overload;
    procedure add(i: TExtendedList); overload;
    function fill(fromList: TgpIntegerList = nil): string; overload;
    function fill(sql: string): string; overload;
    function join(FieldName: string = ''): string;
    function Count : Integer;
    class procedure drop;
    property Members : TgpIntegerList read items;
  end;

//
procedure dbLog(s:string; ReadOnly: boolean = true); overload;
procedure dbLog(sl:TStrings; ReadOnly: boolean = true); overload;

// Datenbank-Inhalt als Tabelle exportieren
procedure ExportTable(TSql: string; FName: string; Seperator: char = ';'; AppendMode: boolean = false); overload;
procedure ExportTable(TSql: TStrings; FName: string; Seperator: char = ';'); overload;

// Stringlist Table
function slTable(TSql: string): TStringList; overload;
function slTable(TSql: TStrings): TStringList; overload;

// TsTable
function csTable(TSql: string): TsTable; overload;
function csTable(TSql: TStrings): TsTable; overload;

procedure fbDump(TSql: string; Dump: TStrings); overload;
procedure fbDump(TSql: TStrings; Dump: TStrings); overload;
procedure fbDump(_R: integer; References: TStringList; Dump: TStringList); overload;

// Datenbank Record exportiern
function AsKeyValue(q: TdboQuery): TStringList;

// Script
procedure ExportScript(TSql: TStrings; FName: string; Seperator: char = ';'); overload;
procedure ExportScript(TSql: string; FName: string; Seperator: char = ';'); overload;

procedure JoinTables(SourceL: TStringList; DestFName: string);
procedure RenameColumnHeader(fromS, toS: string; DestFName: string);

// Tools für den Anzeige Umfang von Queries
procedure ChangeWhere(q: TdboQuery; NewWhere: TStringList); overload;
procedure ChangeWhere(q: TdboQuery; NewWhere: string); overload;
procedure qSelectOne(q: TdboQuery);
procedure qSelectAll(q: TdboQuery);
procedure qSelectList(q: TdboQuery; FName: string); overload;
procedure qSelectList(q: TdboQuery; l: TList); overload;
procedure qStringsAdd(f: TdboField; s: string);
function HeaderNames(q: TdboDataset): TStringList; overload;
function HeaderNames(q: TdboQuery): TStringList; overload;
function HeaderNames(c: TdboCursor): TStringList; overload;

function ColOf(q: TdboQuery; FieldName: string): integer; overload;
function ColOf(q: TdboDatasource; FieldName: string): integer; overload;

function ListasSQL(i: TgpIntegerList): string; overload;
function ListasSQL(i: TList): string; overload;

// Datum Tools
function Datum_coalesce(f: TdboField; d: TANFiXDate): TANFiXDate;

// Boolean Types
function bool2cC(b: boolean): string;
function bool2cC_AsString(b: boolean): string;

// Tools für SQL Abfragen
function RIDtostr(RID: integer): string;
function HasFieldName(IBQ: TdboDataset; FieldName: string): boolean;
function EnsureSQL(const s: string): string;
function SQLstring(const s: string): string;
function isRID(RID: integer): string;
function isSQLString(FieldName: string; CheckStr:string): string;

// Tools für das Tabellen Handling
function useTable(TableName: string): string;
function AllTables: TStringList;
function TableExists(TableName: string): boolean;
procedure DropTable(TableName: string);
procedure DropTheUndropped;
function RecordCopy(TableName, GeneratorName: string; RID: integer): integer;

// Grundsätzliche Datenbank-Objekte
function nQuery: TdboQuery;
function nCursor: TdboCursor;
function nScript: TdboScript;

// Datenbank-Server Commit
procedure e_x_commit;

// a) Migrations-Tool (ibobjects->zeos)
// b) Markiert ein "write" SQL und führt auch DBLog() aus
function for_update(s: TStrings = nil): string;

{ Datenbank Abfragen allgemein }

// true wenn es den RID in der Tabelle gibt, FieldName muss
// ~TableName~ "_" ~ignored~ sein, Beispiel: "PERSON_R"
function e_r_IsRID(FieldName: string; RID: integer): boolean;

// true wenn es den RID in der Tabelle nicht gibt
function e_r_NoRID(FieldName: string; RID: integer): boolean;

// true wenn das erste Feld <NULL> ist
function e_r_IsNull(s: string) : boolean;

// erhöht den Generator erst um eins und liefert dann diesen neuen Wert.
function e_w_GEN(GenName: string): integer;

// liefert den aktuellen Wert des Generators
function e_r_GEN(GenName: string): integer;

// Nur das erste Feld aus der ersten Zeile als Integer
function e_r_sql(s: string): integer; overload;

// Nur das erste Feld aus der Element als Text-Blob, result=1
function e_r_sql(s: string; sl: TStringList): integer; overload;

// Nur das erste Feld des ersten Records als mehrzeilige TStringList
function e_r_sqlt(s: string): TStringList; overload;

// Die erste Zelle einer Datenbankabfrage als String
function e_r_sqls(s: string): string;

// Die erste Zelle einer Datenbankabfrage als Boolean
function e_r_sqlb(s: string): boolean;

// Die erste Zelle einer Datenbankabfrage als Double
function e_r_sqld(s: string; ifnull: double = 0.0): double;

// Nur das erste Feld als TimeStamp
function e_r_sql_DateTime(s: string): TDateTime;

// Nur das erste Feld des ersten Records als Datum
function e_r_sql_Date(s: string): TANFiXDate;

// Erste Ergebnis-Spalte mehrerer Records als TStringList
function e_r_sqlsl(s: string): TStringList;

// wie sqlsl, jedoch noch den "RID" in der 2. Spalte
function e_r_sqlslo(s: string): TStringList;

// Alle numerischen Ergebnisse der ersten Spalte als Integer-Liste
function e_r_sqlm(s: string; m: TgpIntegerList = nil): TgpIntegerList; overload;

// Alle numerischen Ergebnisse der ersten Spalte als Integer-Liste
function e_r_sqlm(TSql: TStrings; m: TgpIntegerList = nil): TgpIntegerList; overload;

// BLOBs: Ersatz für "assignto" bei IBObjects
// s := Field;
procedure e_r_sqlt(Field: TdboField; s: TStrings); overload;

// BLOBs: Schreiben eines Datenbank Blob-Feldes
// Field := s;
procedure e_w_sqlt(Field: TdboField; s: TStrings); overload;
procedure e_w_sqlt(sqls: String; s: TStrings); overload;

// SQL Update, Execute Statements
procedure e_x_sql(s: string); overload;
procedure e_x_sql(s: TStrings); overload;
procedure e_x_update(s: string; sl: TStringList);
procedure e_w_dereference(RID: integer; TableN, FieldN: string; DeleteIt: boolean = false; References: TStrings = nil);

// BASIC Prozessor
function ResolveSQL(const sql: String): String; // Callback für D-BASIC
procedure e_x_basic(FName: string; ParameterL: TStrings = nil); overload;
procedure e_x_basic(FName: string; ParameterS: String = ''); overload;

// alle Referenzen von einem Wert auf einen RID
//
// TABELLE "." FELD [","] [" where " CONDITION]
//
procedure e_x_dereference(dependencies: TStringList; fromref: string; toref: string = 'NULL'); overload;
procedure e_x_dereference(dependencies: TStringList; fromref: Integer; toref: Integer); overload;
procedure e_x_dereference(dependencies: string; fromref: string; toref: string = 'NULL'); overload;

// Server Infos
function e_r_fbClientVersion: string;
function e_r_ConnectionCount: integer;
function e_r_Revision_Latest: single;
function e_r_Revision_Zwang: single;
function e_r_NameFromMask(iDataBaseName: string): string;
function e_r_now: TDateTime; // aktuelles Datum+Uhrzeit aus dem Datenbankserver lesen
function r_Local_vs_Server_TimeDifference: Integer; // Zeitdifferenz zwischen Datenbank-Server und lokalem Server

{$IFDEF fpc}

const

  fbConnection: TZConnection = nil;

{$ELSE}

// Globale Datenbank-Elemente
const
  {$ifndef IBO_OLD}
  fbClientLib: TIB_ClientLib = nil;
  {$endif}
  fbConnection: TIB_Connection = nil;
  fbTransaction: TIB_Transaction = nil;
  fbSession: TIB_Session = nil;

{$ENDIF}

implementation

uses
  Windows,
  SysUtils,

{$IFDEF fpc}
  //ZPlainFirebirdInterbaseConstants,
  ZCompatibility,
  ZDbcIntfs,
  fpchelper,
{$ELSE}
{$IFNDEF CONSOLE}
  Datenbank,
    System.Contnrs,
{$ENDIF}
  IB_Header,
  IB_Session,
{$ENDIF}
  Math,
  CareTakerClient;

procedure ChangeWhere(q: TdboQuery; NewWhere: TStringList);
begin
  with q do
  begin
    close;
    while pos(cSQLwhereMarker, sql[pred(sql.count)]) = 0 do
      sql.delete(pred(sql.count));
    sql.AddStrings(NewWhere);
  end;
end;

procedure ChangeWhere(q: TdboQuery; NewWhere: string);
var
  NewWhereS: TStringList;
begin
  NewWhereS := TStringList.create;
  NewWhereS.add(NewWhere);
  ChangeWhere(q, NewWhereS);
  NewWhereS.free;
end;

procedure qSelectList(q: TdboQuery; l: TList); overload;
var
  ResultSQL: TStringList;
  n: integer;
begin
  ResultSQL := TStringList.create;
  ResultSQL.add('where RID in (');
  for n := 0 to pred(min(l.count, 999)) do
    if (n = 0) then
      ResultSQL.add(inttostr(integer(l[n])))
    else
      ResultSQL.add(',' + inttostr(integer(l[n])));
  ResultSQL.add(')');
  for_update(ResultSQL);
  ChangeWhere(q, ResultSQL);
  ResultSQL.free;
end;

procedure qSelectList(q: TdboQuery; FName: string); overload;
var
  ResultSQL: TStringList;
  TheRIDs: TsTable;
  r, RID: integer;
  cCol_RID: integer;
  lRESULT: TgpIntegerList;
begin
  TheRIDs := TsTable.create;
  lRESULT := TgpIntegerList.create;
  try
    TheRIDs.InsertFromFile(FName);
    ResultSQL := TStringList.create;

    // Spalte mit dem RID suchen
    cCol_RID := TheRIDs.ColOf('PERSON_R');
    if (cCol_RID = -1) then
      cCol_RID := TheRIDs.ColOf('RID');
    if (cCol_RID = -1) then
      cCol_RID := 0;

    for r := 1 to TheRIDs.RowCount do
    begin
      RID := strtointdef(TheRIDs.readCell(r, cCol_RID), cRID_NULL);
      if RID >= cRID_FirstValid then
        lRESULT.add(RID);
    end;

    ResultSQL.add('where RID in ' + ListasSQL(lRESULT));
    ResultSQL.add('for update');
    ChangeWhere(q, ResultSQL);
    ResultSQL.free;
  except
  end;
  TheRIDs.free;
  lRESULT.free;
end;

procedure qSelectOne(q: TdboQuery);
var
  ResultSQL: TStringList;
begin
  ResultSQL := TStringList.create;
  ResultSQL.add('WHERE RID=:CROSSREF');
  ResultSQL.add('FOR UPDATE');
  ChangeWhere(q, ResultSQL);
  ResultSQL.free;
end;

procedure qSelectAll(q: TdboQuery);
begin
  ChangeWhere(q, 'FOR UPDATE');
end;

procedure ExportTable(TSql: string; FName: string; Seperator: char = ';'; AppendMode: boolean = false);
var
  cABLAGE: TdboCursor;
  Ablage: TStringList;
  StartTime: dword;
  n, m: integer;
  Infostr: string;
  DB_text: string;
  DB_memo: TStringList;
  FirstTimeWrite: boolean;

  procedure SaveResults;
  begin
    if (Ablage.count > 0) then
    begin
      AppendStringsToFile(Ablage, FName);
      Ablage.clear;
    end;
  end;

begin
  if AppendMode then
  begin
    FirstTimeWrite := not(FileExists(FName));
  end
  else
  begin
    FileDelete(FName);
    FirstTimeWrite := true;
  end;
  DB_memo := TStringList.create;
  Ablage := TStringList.create;
  cABLAGE := nCursor;
  StartTime := 0;
  with cABLAGE do
  begin
    sql.add(TSql);

    dbLog(sql);
    ApiFirst;

    // Kopfzeile
    Infostr := '';
    for n := 0 to pred(FieldCount) do
    begin
      with Fields[n] do
        Infostr := Infostr + FieldName { '.' + inttostr(SQLType) + };
      if (n <> pred(FieldCount)) then
        Infostr := Infostr + Seperator;

    end;
    if FirstTimeWrite then
      Ablage.add(Infostr);

    while not(eof) do
    begin

      Infostr := '';
      for n := 0 to pred(FieldCount) do
        with Fields[n] do
        begin
          if not(IsNull) then
          begin
{$ifdef fpc}
 case DataType of
   ftFloat,ftCurrency:Infostr := Infostr + format('%.2f', [AsCurrency]);
   ftSmallint,ftWord,ftInteger: Infostr := Infostr + inttostr(AsInteger);
   ftString: Infostr := Infostr + AsString;
   ftDate:Infostr := Infostr + long2date(DateTime2Long(AsDateTime));
   ftTime:Infostr := Infostr + secondstostr(DateTime2seconds(AsDateTime));
   ftDateTime,ftTimeStamp:Infostr := Infostr + long2date(DateTime2Long(AsDateTime)) + ' ' +
                    secondstostr(DateTime2seconds(AsDateTime));
 else
   Infostr := Infostr + 'SQLType ' + inttostr(ord(DataType)) + ' unbekannt!';
 end;
   (*
   ftUnknown, ftString, ftSmallint, ftInteger, ftWord,
               ftBoolean, ftFloat, , ftBCD, ftDate,  , ftDateTime,
               ftBytes, ftVarBytes, ftAutoInc, ftBlob, ftMemo, ftGraphic, ftFmtMemo,
               ftParadoxOle, ftDBaseOle, ftTypedBinary, ftCursor, ftFixedChar,
               ftWideString, ftLargeint, ftADT, ftArray, ftReference,
               ftDataSet, ftOraBlob, ftOraClob, ftVariant, ftInterface,
               ftIDispatch, ftGuid, ftTimeStamp, ftFMTBcd, ftFixedWideChar, ftWideMemo
   *)
{$else}
           case SQLType of
           SQL_DOUBLE, SQL_DOUBLE_:
                Infostr := Infostr + format('%.2f', [AsDouble]);

              SQL_INT64, SQL_INT64_:
                Infostr := Infostr + inttostr(AsInt64);

              SQL_SHORT, SQL_SHORT_, SQL_LONG, SQL_LONG_:
                Infostr := Infostr + inttostr(AsInteger);

              SQL_VARYING, SQL_VARYING_, SQL_TEXT, SQL_TEXT_:
                begin
                  DB_text := AsString;
                  ersetze(#13, '', DB_text);
                  ersetze(#10, '', DB_text);
                  ersetze('"', '''', DB_text);
                  Infostr := Infostr + '"' + DB_text + '"';
                end;

              SQL_BLOB, SQL_BLOB_:
                begin
                  // if SubType = isc_blob_text
                  DB_text := '';
                  AssignTo(DB_memo);
                  for m := 0 to pred(DB_memo.count) do
                    if (m = 0) then
                      DB_text := DB_memo[0]
                    else
                      DB_text := DB_text + '|' + DB_memo[m];
                  ersetze('"', '''', DB_text);
                  Infostr := Infostr + '"' + DB_text + '"';
                end;

              SQL_TIMESTAMP, SQL_TIMESTAMP_:
                begin
                  Infostr := Infostr + long2date(DateTime2Long(AsDateTime)) + ' ' +
                    secondstostr(DateTime2seconds(AsDateTime));
                end;

              SQL_TYPE_DATE, SQL_TYPE_DATE_:
                begin
                  Infostr := Infostr + long2date(DateTime2Long(AsDateTime));
                end;

              SQL_TYPE_TIME, SQL_TYPE_TIME_:
                begin
                  Infostr := Infostr + secondstostr(DateTime2seconds(AsDateTime));
                end;
            else
              Infostr := Infostr + 'SQLType ' + inttostr(SQLType) + ' unbekannt!';
            end;

           {$endif}
          end
          else
          begin
            Infostr := Infostr + sRID_NULL;
          end;

          if (n <> pred(FieldCount)) then
            Infostr := Infostr + Seperator;

        end;

      Ablage.add(Infostr);

      ApiNext;
      if frequently(StartTime, 1000) or eof then
        SaveResults;
    end;
    SaveResults;
  end;
  cABLAGE.free;
  Ablage.free;
  DB_memo.free;
end;

function slTable(TSql: string): TStringList;
const
  Seperator = ';';
var
  cABLAGE: TdboCursor;
  n, m: integer;
  Infostr: string;
  DB_text: string;
  DB_memo: TStringList;

begin
  result := TStringList.create;
  DB_memo := TStringList.create;
  cABLAGE := nCursor;
  try
    with cABLAGE do
    begin

      sql.add(TSql);
      dbLog(sql);
      ApiFirst;

      // Kopfzeile
      Infostr := '';
      for n := 0 to pred(FieldCount) do
      begin
        with Fields[n] do
          Infostr := Infostr + FieldName { '.' + inttostr(SQLType) + };
        if (n <> pred(FieldCount)) then
          Infostr := Infostr + Seperator;

      end;
      result.add(Infostr);

      while not(eof) do
      begin

        Infostr := '';
        for n := 0 to pred(FieldCount) do
          with Fields[n] do
          begin
            if not(IsNull) then
            begin
{$IFDEF fpc}
              Infostr := Infostr + AsString;
{$ELSE}
              case SQLType of
                SQL_DOUBLE, SQL_DOUBLE_:
                  Infostr := Infostr + format('%.2f', [AsDouble]);

                SQL_INT64, SQL_INT64_:
                  Infostr := Infostr + inttostr(AsInt64);

                SQL_SHORT, SQL_SHORT_, SQL_LONG, SQL_LONG_:
                  Infostr := Infostr + inttostr(AsInteger);

                SQL_VARYING, SQL_VARYING_, SQL_TEXT, SQL_TEXT_:
                  begin
                    DB_text := AsString;
                    ersetze(#13, '', DB_text);
                    ersetze(#10, '', DB_text);
                    ersetze('"', '''', DB_text);
                    Infostr := Infostr + '"' + DB_text + '"';
                  end;

                SQL_BLOB, SQL_BLOB_:
                  begin
                    // if SubType = isc_blob_text
                    DB_text := '';
                    AssignTo(DB_memo);
                    for m := 0 to pred(DB_memo.count) do
                      if (m = 0) then
                        DB_text := DB_memo[0]
                      else
                        DB_text := DB_text + '|' + DB_memo[m];
                    ersetze('"', '''', DB_text);
                    Infostr := Infostr + '"' + DB_text + '"';
                  end;

                SQL_TIMESTAMP, SQL_TIMESTAMP_:
                  begin
                    Infostr := Infostr + long2date(DateTime2Long(AsDateTime)) + ' ' +
                      secondstostr(DateTime2seconds(AsDateTime));
                  end;

                SQL_TYPE_DATE, SQL_TYPE_DATE_:
                  begin
                    Infostr := Infostr + long2date(DateTime2Long(AsDateTime));
                  end;
                SQL_TYPE_TIME, SQL_TYPE_TIME_:
                  begin
                    Infostr := Infostr + secondstostr(DateTime2seconds(AsDateTime));
                  end;
              else
                Infostr := Infostr + 'SQLType ' + inttostr(SQLType) + ' unbekannt!';
              end;
{$ENDIF}
            end
            else
            begin
              Infostr := Infostr + sRID_NULL;
            end;

            if (n <> pred(FieldCount)) then
              Infostr := Infostr + Seperator;

          end;

        result.add(Infostr);

        ApiNext;
      end;
    end;
  except
    on E: Exception do
    begin
      result.add(cERRORText + ' slTable: ' + E.Message);
    end;

  end;
  cABLAGE.free;
  DB_memo.free;
end;

function AsKeyValue(q: TdboQuery): TStringList;
const
  Seperator = ';';
var
  n, m: integer;
  Infostr: string;
  DB_text: string;
  DB_memo: TStringList;

begin
  result := TStringList.create;
  DB_memo := TStringList.create;
  try
    with q do
    begin

      for n := 0 to pred(FieldCount) do
        with Fields[n] do
        begin

          if not(IsNull) then
          begin
{$IFDEF fpc}
            Infostr := AsString;
{$ELSE}
            case SQLType of
              SQL_DOUBLE, SQL_DOUBLE_:
                Infostr := format('%.2f', [AsDouble]);

              SQL_INT64, SQL_INT64_:
                Infostr := inttostr(AsInt64);

              SQL_SHORT, SQL_SHORT_, SQL_LONG, SQL_LONG_:
                Infostr := inttostr(AsInteger);

              SQL_VARYING, SQL_VARYING_, SQL_TEXT, SQL_TEXT_:
                begin
                  DB_text := AsString;
                  ersetze(#13, '<br>', DB_text);
                  ersetze(#10, '', DB_text);
                  ersetze('"', '''', DB_text);
                  Infostr := DB_text;
                end;

              SQL_BLOB, SQL_BLOB_:
                begin
                  // if SubType = isc_blob_text
                  DB_text := '';
                  AssignTo(DB_memo);
                  for m := 0 to pred(DB_memo.count) do
                    if (m = 0) then
                      DB_text := DB_memo[0]
                    else
                      DB_text := DB_text + '|' + DB_memo[m];
                  ersetze('"', '''', DB_text);
                  Infostr := DB_text;
                end;

              SQL_TIMESTAMP, SQL_TIMESTAMP_:
                begin
                  Infostr := long2date(DateTime2Long(AsDateTime)) + ' ' + secondstostr(DateTime2seconds(AsDateTime));
                end;

              SQL_TYPE_DATE, SQL_TYPE_DATE_:
                begin
                  Infostr := long2date(DateTime2Long(AsDateTime));
                end;
              SQL_TYPE_TIME, SQL_TYPE_TIME_:
                begin
                  Infostr := secondstostr(DateTime2seconds(AsDateTime));
                end;
            else
              Infostr := 'SQLType ' + inttostr(SQLType) + ' unbekannt!';
            end;
{$ENDIF}
          end
          else
          begin
            Infostr := '';
          end;

          result.add(Fields[n].FieldName + '=' + Infostr);

        end;

    end;
  except
    on E: Exception do
    begin
      result.add(cERRORText + ' : ' + E.Message);
    end;
  end;
  DB_memo.free;

end;

function slTable(TSql: TStrings): TStringList; overload;
begin
  result := slTable(HugeSingleLine(TSql, ' '));
end;

function csTable(TSql: string): TsTable; overload;
var
  cTABLE: TdboCursor;
  n, m: integer;
  Content: string;
  sRow: TStringList;

  DB_text: string;
  DB_memo: TStringList;

begin
  result := TsTable.create;
  DB_memo := TStringList.create;
  cTABLE := nCursor;
  with cTABLE do
  begin
    sql.add(TSql);
    dbLog(sql);
    ApiFirst;

    // Kopfzeile
    for n := 0 to pred(FieldCount) do
      result.addCol(Fields[n].FieldName);

    while not(eof) do
    begin
      sRow := TStringList.create;

      for n := 0 to pred(FieldCount) do
      begin
        Content := '';
        with Fields[n] do
        begin
          if not(IsNull) then
          begin
{$IFDEF fpc}
            Content := AsString;
{$ELSE}
            case SQLType of
              SQL_DOUBLE, SQL_DOUBLE_:
                Content := format('%.2f', [AsDouble]);

              SQL_INT64, SQL_INT64_:
                Content := inttostr(AsInt64);

              SQL_SHORT, SQL_SHORT_, SQL_LONG, SQL_LONG_:
                Content := inttostr(AsInteger);

              SQL_VARYING, SQL_VARYING_, SQL_TEXT, SQL_TEXT_:
                begin
                  DB_text := AsString;
                  ersetze(#13, '', DB_text);
                  ersetze(#10, '', DB_text);
                  Content := DB_text;
                end;

              SQL_BLOB, SQL_BLOB_:
                begin
                  // if SubType = isc_blob_text
                  DB_text := '';
                  AssignTo(DB_memo);
                  for m := 0 to pred(DB_memo.count) do
                    if (m = 0) then
                      DB_text := DB_memo[0]
                    else
                      DB_text := DB_text + '|' + DB_memo[m];
                  Content := DB_text;
                end;

              SQL_TIMESTAMP, SQL_TIMESTAMP_:
                begin
                  Content := long2date(DateTime2Long(AsDateTime)) + ' ' + secondstostr(DateTime2seconds(AsDateTime));
                end;

              SQL_TYPE_DATE, SQL_TYPE_DATE_:
                begin
                  Content := long2date(DateTime2Long(AsDateTime));
                end;
              SQL_TYPE_TIME, SQL_TYPE_TIME_:
                begin
                  Content := secondstostr(DateTime2seconds(AsDateTime));
                end;
            else
              Content := 'SQLType ' + inttostr(SQLType) + ' unbekannt!';
            end;

{$ENDIF}
          end
          else
          begin
            Content := sRID_NULL;
          end;
          sRow.add(Content);
        end;
      end;
      result.add(sRow);
      ApiNext;
    end;
  end;
  cTABLE.free;
  DB_memo.free;
end;

function csTable(TSql: TStrings): TsTable; overload;
begin
  result := csTable(HugeSingleLine(TSql, ' '));
end;

procedure JoinTables(SourceL: TStringList; DestFName: string);
var
  DestL: TStringList;
  OneL: TStringList;
  n, m: integer;
  Plus: string;
begin
  DestL := TStringList.create;
  OneL := TStringList.create;
  for n := 0 to pred(SourceL.count) do
  begin
    Plus := '';
    OneL.LoadFromFile(SourceL[n]);
    if DestL.count > 0 then
      if length(DestL[0]) > 0 then
        if DestL[0][length(DestL[0])] <> ';' then
          Plus := ';';
    for m := 0 to pred(OneL.count) do
      if DestL.count <= m then
        DestL.add(OneL[m])
      else
        DestL[m] := DestL[m] + Plus + OneL[m];
    DeleteFile(SourceL[n]);
  end;
  DestL.SaveToFile(DestFName);
  OneL.free;
  DestL.free;
end;

procedure RenameColumnHeader(fromS, toS: string; DestFName: string);
var
  DestL: TStringList;
begin
  DestL := TStringList.create;
  DestL.LoadFromFile(DestFName);
  ersetze(fromS, toS, DestL, 0);
  DestL.SaveToFile(DestFName);
  DestL.free;
end;

procedure ExportTable(TSql: TStrings; FName: string; Seperator: char = ';'); overload;
begin
  ExportTable(HugeSingleLine(TSql, ' '), FName, Seperator);
end;

procedure ExportScript(TSql: TStrings; FName: string; Seperator: char = ';'); overload;
begin
  ExportScript(HugeSingleLine(TSql, ' '), FName, Seperator);
end;

procedure ExportScript(TSql: string; FName: string; Seperator: char = ';'); overload;
{$IFDEF fpc}
var
  Ablage: TStringList;
begin
  FileDelete(FName);
  Ablage := TStringList.create;
  e_x_sql(TSql);
  Ablage.add('ANZAHL;');
  Ablage.add('<NULL>;');
  AppendStringsToFile(Ablage, FName);
  Ablage.free;
end;

{$ELSE}

var
  cABLAGE: TdboScript;
  Ablage: TStringList;
begin
  FileDelete(FName);
  Ablage := TStringList.create;
  cABLAGE := nScript;
  with cABLAGE do
  begin
    sql.add(TSql);
    dbLog(sql,false);
    execute;

    // imp pend: hier sollte mal die Anzahl der betroffenen Datensätze
    // ausgegeben werden!

    Ablage.add('ANZAHL;');
    Ablage.add('<NULL>;');

  end;
  AppendStringsToFile(Ablage, FName);
  cABLAGE.free;
  Ablage.free;
end;
{$ENDIF}

function ListasSQL(i: TgpIntegerList): string; overload;
var
  n: integer;
begin
  result := '0';
  if assigned(i) then
    if (i.count > 0) then
    begin
      result := inttostr(i[0]);
      for n := 1 to pred(i.count) do
        result := result + ',' + inttostr(i[n]);
    end;
  result := '(' + result + ')';
end;

function ListasSQL(i: TList): string; overload;
var
  iL: TgpIntegerList;
  n: integer;
begin
  if assigned(i) then
  begin
    iL := TgpIntegerList.create;
    for n := 0 to pred(i.count) do
      iL.add(integer(i[n]));
    result := ListasSQL(iL);
    iL.free;
  end
  else
  begin
    result := ListasSQL(TgpIntegerList(nil));
  end;
end;

{$IFDEF fpc}
{ TdboScript }

function TdboScript.sql: TStrings;
begin
  result := Script;
end;

procedure TdboScript.Prepare;
begin
  parse;
end;

{ TdboCursor }

procedure TdboCursor.ApiFirst;
begin
  if not(active) then
    Open
  else
    Refresh;
  First;
end;

procedure TdboCursor.ApiNext;
begin
  Next;
end;

{ TdboQuery }

procedure TdboQuery.Insert;
begin
  if not(active) then
    Open;
  inherited Insert;
end;

{$ENDIF}

procedure TSQLStringList.ReplaceBlock(BlockName: string; NewLines: string);
var
  n: integer;
  BlockStart: integer;
  BlockEnd: integer;
begin
  BlockStart := -1;
  for n := 0 to pred(count) do
    if pos('~' + BlockName + ' begin~', strings[n]) > 0 then
    begin
      BlockStart := n;
      break;
    end;
  if (BlockStart <> -1) then
  begin
    while (NewLines <> '') do
    begin
      inc(BlockStart);
      Insert(BlockStart, nextp(NewLines, #13));
    end;
    for n := BlockStart to pred(count) do
      if pos('~' + BlockName + ' end~', strings[n]) > 0 then
      begin
        BlockEnd := n;
        break;
      end;

    for n := pred(BlockEnd) downto succ(BlockStart) do
      delete(n);
  end;
end;

function AllTables: TStringList;
var
  cSYSTEM: TdboCursor;
begin
  result := TStringList.create;
  cSYSTEM := nCursor;
  with cSYSTEM do
  begin
    sql.add('select');
    sql.add(' RDB$RELATION_NAME');
    sql.add('from');
    sql.add(' RDB$RELATIONS');
    sql.add('where');
    sql.add(' (RDB$VIEW_BLR is null) and');
    sql.add(' (RDB$SYSTEM_FLAG=0)');
    dblog(sql);
    ApiFirst;
    while not(eof) do
    begin
      result.add(Fields[0].AsString);
      ApiNext;
    end;
  end;
  cSYSTEM.free;
end;

function TableExists(TableName: string): boolean;
begin
  result := e_r_sql('select 1 from RDB$RELATIONS where RDB$RELATION_NAME='+SQLString(TableName))=1;
end;

function _DropTableFName : string;
const
 DropListFName = 'DropTable.txt';
begin
  result := SystemPath + '\' + DropListFName;
end;

procedure DropTable(TableName: string);
begin
  if TableExists(TableName) then
  begin
    if DROP_BUG then
    begin
      // due a firebird-bug, "dropping a table" in a massive
      // multiuser environment may corrupt the database-file.
      // It is more secure to do this "later" inside an exclusive
      // db-connection, so i "delete" the content, but do
      // not delete the Table any more. I write the drop to
      // a Log-File hoping anybody other do the "Drop" with
      // the household function DropTheUndropped.
      e_x_sql('delete from ' + TableName);
      AppendStringsToFile(TableName,_DropTableFName);
    end else
    begin
     e_x_sql('drop table ' + TableName);
    end;
  end;
end;

procedure DropTheUndropped;
var
 sPlannedToDrop : TStringList;
 n : Integer;
begin
 if FileExists(_DropTableFName) then
 begin
   sPlannedToDrop := TStringList.create;
   sPlannedToDrop.LoadFromFile(_DropTableFName);
   sPlannedToDrop.Sort;
   RemoveDuplicates(sPlannedToDrop);
   for n := pred(sPlannedToDrop.Count) downto 0 do
     if not(TableExists(sPlannedToDrop[n])) then
       sPlannedToDrop.Delete(n);
   for n := 0 to pred(sPlannedToDrop.Count) do
     e_x_sql('drop table ' + sPlannedToDrop[n]);
   FileDelete(_DropTableFName);
   sPlannedToDrop.Free;
 end;
end;

procedure e_r_sqlt(Field: TdboField; s: TStrings); overload;
begin
{$IFDEF fpc}
  s.text := Field.AsString;
{$ELSE}
  Field.AssignTo(s);
{$ENDIF}
end;

procedure e_w_sqlt(Field: TdboField; s: TStrings); overload;
begin
{$IFDEF fpc}
  Field.AsString := s.text;
{$ELSE}
  Field.Assign(s);
{$ENDIF}
end;

procedure e_w_sqlt(sqls: String; s: TStrings); overload;
var
 qTABLE : TdboQuery;
begin
  qTABLE := nQuery;
  with qTABLE do
  begin
    sql.add(sqls);
    for_update(sql);
    dbLog(sql,false);
    Open;
    First;
    edit;
    e_w_sqlt(Fields[0], s);
    Post;
  end;
  qTABLE.free;
end;

procedure qStringsAdd(f: TdboField; s: string);
var
  sl: TStringList;
begin
  sl := TStringList.create;
  e_r_sqlt(f, sl);
  sl.add(s);

{$IFDEF fpc}
  f.AsString := sl.text;
{$ELSE}
  f.Assign(sl);
{$ENDIF}
  sl.free;
end;

function RecordCopy(TableName, GeneratorName: string; RID: integer): integer;
var
  cSOURCE: TdboCursor;
  qDEST: TdboQuery;
  NewRID: integer;
  _FieldName: string;
  n: integer;
begin
  result := -1;
  cSOURCE := nCursor;
  qDEST := nQuery;
  try
    repeat

      //
      with cSOURCE do
      begin

        sql.add('select * from ' + TableName + ' where RID=' + inttostr(RID));
        dbLog(sql);

        ApiFirst;
        if eof then
          break;
        NewRID := e_w_GEN(GeneratorName);
      end;

      //
      with qDEST do
      begin
        sql.add('select * from ' + TableName + ' for update');
        Insert;
        FieldByName('RID').AsInteger := NewRID;
        for n := 0 to pred(FieldCount) do
        begin
          _FieldName := Fields[n].FieldName;
          repeat

            if (_FieldName = 'RID') then
              break;

            if (_FieldName = 'PROTECT_RID') then
            begin
              qDEST.FieldByName(_FieldName).AsInteger := 1;
              break;
            end;

            if cSOURCE.FieldByName(_FieldName).IsNull then
              break;

            qDEST.FieldByName(_FieldName).Assign(cSOURCE.FieldByName(_FieldName));

          until yet;
        end;
        post;
      end;

      result := NewRID;
    until yet;

  except

  end;
  cSOURCE.free;
  qDEST.free;
end;

{ TdboClub }

class procedure TdboClub.drop;
const
 Preserve_Clubs_Count = 10;
var
 CLUB : TStringList;
 n,c,m : Integer;
begin
  // preserve ~Preserve_Clubs_Count~ CLUB$* Tables
  // drop the older
  m := e_r_gen('GEN_CLUB') - Preserve_Clubs_Count;
  if (m>Preserve_Clubs_Count) then
  begin
    CLUB := AllTables;
    // Drop Tables "m" and older
    for n := 0 to pred(CLUB.Count) do
     if (pos('CLUB$',CLUB[n])=1) then
     begin
      c := StrToIntDef(nextp(CLUB[n],'$',1),0);
      if (c>0) and (c<=m) then
       e_x_sql('drop table '+CLUB[n]);
     end;
    CLUB.Free;
  end;
end;

function TdboClub.Count : Integer;
begin
 if assigned(items) then
  result := items.Count
 else
  result := 0;
end;

procedure TdboClub.add(i: integer);
begin
  if not(assigned(items)) then
    items := TgpIntegerList.create;
  items.add(i);
end;

procedure TdboClub.add(i: TgpIntegerList);
begin
  if not(assigned(items)) then
    items := TgpIntegerList.create;
  items.append(i);
end;

procedure TdboClub.add(i: TExtendedList);
var
 n : Integer;
begin
  if not(assigned(items)) then
    items := TgpIntegerList.create;
  for n := 0 to pred(i.Count) do
   items.Add(Integer(i[n]));
end;

constructor TdboClub.create;
begin
  //
  RefTable := pRefTable;
end;

destructor TdboClub.Destroy;
begin
  if assigned(items) then
    FreeAndNil(items);
  inherited;
end;

function TdboClub.join(FieldName: string = ''): string;
begin
  if (FieldName = '') then
    FieldName := 'RID';
  result :=
   { } ' ' +
   { } 'join ' + TableName + ' on' +
   { } ' (' + TableName + '.RID=' + RefTable + '.' + FieldName + ') ';
end;

function TdboClub.fill(sql: string): string;
begin
  // den Club mit Hife des SQL füllen!
  result := TableName;
  e_x_sql('insert into ' + result + ' (RID) ' + sql);
end;

function TdboClub.fill(fromList: TgpIntegerList = nil): string;
var
  workL: TgpIntegerList;
  n: integer;
  dCLUB: TdboScript;
begin
  result := '';

  //
  if assigned(items) and assigned(fromList) then
    items.append(fromList);

  //
  if assigned(items) then
    workL := items
  else
    workL := fromList;

  //
  if not(assigned(workL)) then
    exit;

  dCLUB := nScript;
  with dCLUB do
  begin
    // imp pend:
    //
    // a) Do this by a Bulk Insert
    // or
    // b) Store Integers in a BLOB, let the engine do the work
    //
    // by now we do a step by step insert
    //
    sql.add('insert into ' + TableName + ' (RID) values (:RID)');
    for n := 0 to pred(workL.count) do
    begin
      ParamByName('RID').AsInteger := workL[n];
      execute;
    end;
  end;
  dCLUB.free;

  result := join;
end;

function TdboClub.TableName: string;
begin
  if (ID = 0) then
  begin
    ID := e_w_GEN('GEN_CLUB');
    result := 'CLUB$' + inttostr(ID);

    // CLUB Tabelle neu anlegen
    e_x_sql(
      { } 'create global temporary table ' +
      { } result +
      { } ' (RID DOM_REFERENCE not null,' +
      { } ' constraint PK_' + result + ' primary key (RID)' +
      { } ') '+
      { } 'on commit preserve rows');
  end
  else
  begin
    result := 'CLUB$' + inttostr(ID);
  end;
end;

function e_r_fbClientVersion: string;
var
  TheModuleName: array [0 .. 1023] of char;
  s: string;
begin
{$IFDEF fpc}
  result := 'imp pend: obtain DLL-Handle';
{$ELSE}
  // welche Firebird Client-DLL wird verwendet
{$IFNDEF CONSOLE}

  {$ifdef IBO_OLD}
  GetModuleFileName(DataModuleDatenbank.IB_Session1.GDS_Handle, TheModuleName, sizeof(TheModuleName));
  {$else}
  GetModuleFileName(DataModuleDatenbank.IB_ClientLib1.GDS_Handle, TheModuleName, sizeof(TheModuleName));
  {$endif}

{$ELSE}
  {$ifdef IBO_OLD}
   GetModuleFileName(fbSession.GDS_Handle, TheModuleName, sizeof(TheModuleName));
  {$else}
   // imp pend
  {$endif}
{$ENDIF}
  s := TheModuleName;
  result := s + ' ' + FileVersion(TheModuleName);
{$ENDIF}
end;

function isRID(RID: integer): string;
begin
  if (RID < cRID_FirstValid) then
    result := ' is null'
  else
    result := '=' + inttostr(RID);
end;

function isSQLString(FieldName: string; CheckStr:string): string;
begin
 if (CheckStr='') then
  result := ' (('+FieldName+'='''') or ('+FieldName+' is null)) '
 else
  result := ' ('+FieldName+'='+SQLString(CheckStr)+') ';
end;

function ColOf(q: TdboQuery; FieldName: string): integer; overload;
var
  sHeaderNames: TStringList;
begin
  sHeaderNames := HeaderNames(q);
  result := sHeaderNames.indexof(FieldName);
  sHeaderNames.free;
end;

function HeaderNames(q: TdboDataset): TStringList;
var
  n: integer;
begin
  result := TStringList.create;
  with q do
    for n := 0 to pred(FieldCount) do
      result.add(Fields[n].FieldName);
end;

function HeaderNames(q: TdboQuery): TStringList;
var
  n: integer;
begin
  result := TStringList.create;
  with q do
    for n := 0 to pred(FieldCount) do
      result.add(Fields[n].FieldName);
end;

function HeaderNames(c: TdboCursor): TStringList;
var
  n: integer;
begin
  result := TStringList.create;
  with c do
    for n := 0 to pred(FieldCount) do
      result.add(Fields[n].FieldName);
end;

function ColOf(q: TdboDatasource; FieldName: string): integer; overload;
var
  sHeaderNames: TStringList;
begin
  sHeaderNames := HeaderNames(q.DataSet);
  result := sHeaderNames.indexof(FieldName);
  sHeaderNames.free;
end;

function bool2cC(b: boolean): string;
begin
  if b then
    result := cC_True
  else
    result := cC_False;
end;

function bool2cC_AsString(b: boolean): string;
begin
  if b then
    result := cC_True_AsString
  else
    result := cC_False_AsString;
end;

function RIDtostr(RID: integer): string;
begin
  if (RID >= cRID_FirstValid) then
    result := inttostr(RID)
  else
    result := 'null';
end;

function Datum_coalesce(f: TdboField; d: TANFiXDate): TANFiXDate;
begin
  if f.IsNull then
    result := d
  else
    result := DateTime2Long(f.AsDateTime);
  if not(DateOK(result)) then
    result := d;
end;

function useTable(TableName: string): string;
begin
  if (TableName = '') then
    result := ''
  else
    result := TableName + '.';
end;

const
  cKommaBreakAt = 10;
  _KommaCount: integer = 0;

function fbDumpKomma: string;
begin
  inc(_KommaCount);
  if (_KommaCount Mod cKommaBreakAt = 0) then
    result := ',' + #13#10
  else
    result := ', ';
end;

procedure fbDump(TSql: string; Dump: TStrings);

const
  cTableNameUnset = '';
var
  _TableName: string;

  function cTableName: string;
  const
    cToken_FROM = 'from';
  var
    Token_Begin, Token_End, l: integer;
  begin
    if (_TableName = cTableNameUnset) then
    begin
      Token_Begin := pos(cToken_FROM, TSql);
      if (Token_Begin > 0) then
      begin
        l := length(TSql);
        inc(Token_Begin, length(cToken_FROM) + 1);
        // Überspringe nun alle White Spaces
        while CharInSet(TSql[Token_Begin], [#9, #32, #13, #10]) do
        begin
          inc(Token_Begin);
          if Token_Begin > l then
            raise Exception.create('fbDump: SQL: nach ');
        end;

        // Baue nun den Tabellennamen
        Token_End := Token_Begin + 1;
        repeat
          if Token_End + 1 > l then
            break;
          if CharInSet(TSql[Token_End + 1], [#9, #32, #13, #10]) then
            break;
          inc(Token_End);
        until eternity;
        _TableName := copy(TSql, Token_Begin, succ(Token_End - Token_Begin));

      end
      else
      begin
        raise Exception.create('fbDump: SQL: "' + cToken_FROM + '" nicht gefunden!');
      end;
    end;
    result := _TableName;
  end;

var
  cTABLE: TdboCursor;
  cFIELDCOUNT: integer;
  InsertPreFix: string;
  n, m: integer;
  sRow: string;
  Content: string;
  DB_text: string;
  DB_memo: TStringList;

begin
  DB_memo := TStringList.create;
  cTABLE := nCursor;
  _TableName := cTableNameUnset;

  InsertPreFix := 'insert into ' + cTableName;
  with cTABLE do
  begin

    sql.add(TSql);
    dbLog(sql);
    ApiFirst;
    cFIELDCOUNT := FieldCount;

    // Felder
    Content := '(';
    for n := 0 to cFIELDCOUNT - 2 do
      Content := Content + Fields[n].FieldName + fbDumpKomma;
    Content := Content + Fields[pred(cFIELDCOUNT)].FieldName + ')';
    InsertPreFix := InsertPreFix + Content + ' values (';

    while not(eof) do
    begin
      sRow := '';

      for n := 0 to pred(cFIELDCOUNT) do
      begin
        Content := '';
        with Fields[n] do
        begin
          if not(IsNull) then
          begin
{$IFDEF fpc}
            Content := AsString;

{$ELSE}
            case SQLType of
              SQL_DOUBLE, SQL_DOUBLE_:
                Content := FloatToStrISO(AsDouble, 2);

              SQL_INT64, SQL_INT64_:
                Content := inttostr(AsInt64);

              SQL_SHORT, SQL_SHORT_, SQL_LONG, SQL_LONG_:
                Content := inttostr(AsInteger);

              SQL_VARYING, SQL_VARYING_, SQL_TEXT, SQL_TEXT_:
                begin
                  DB_text := AsString;
                  ersetze(#13, '|', DB_text);
                  ersetze(#10, '', DB_text);
                  ersetze('''', '"', DB_text);
                  Content := '''' + DB_text + '''';
                end;

              SQL_BLOB, SQL_BLOB_:
                begin
                  // if SubType = isc_blob_text
                  DB_text := '';
                  AssignTo(DB_memo);
                  for m := 0 to pred(DB_memo.count) do
                    if (m = 0) then
                      DB_text := DB_memo[0]
                    else
                      DB_text := DB_text + '|' + DB_memo[m];
                  Content := '''' + DB_text + '''';
                end;

              SQL_TIMESTAMP, SQL_TIMESTAMP_:
                begin
                  Content := '''' + long2date(DateTime2Long(AsDateTime)) + ' ' +
                    secondstostr(DateTime2seconds(AsDateTime)) + '''';
                end;

              SQL_TYPE_DATE, SQL_TYPE_DATE_:
                begin
                  Content := '''' + long2date(DateTime2Long(AsDateTime)) + '''';
                end;
              SQL_TYPE_TIME, SQL_TYPE_TIME_:
                begin
                  Content := '''' + secondstostr(DateTime2seconds(AsDateTime)) + '''';
                end;
            else
              Content := 'SQLType ' + inttostr(SQLType) + ' unbekannt!';
            end;
{$ENDIF}
          end
          else
          begin
            Content := 'null';
          end;
          if n = pred(cFIELDCOUNT) then
            sRow := sRow + Content
          else
            sRow := sRow + Content + fbDumpKomma;
        end;
      end;
      Dump.Insert(0, InsertPreFix + sRow + ');');
      ApiNext;
    end;
  end;
  cTABLE.free;
  DB_memo.free;

end;

function OrgaMonDB_hasRID(TableName: string): boolean;
begin
  result := false;
  repeat
    if TableName = 'TICKET_QUELLE' then
      break;
    if TableName = 'TICKET_ZIEL' then
      break;
    result := true;
  until yet;
end;

procedure fbDump(TSql: TStrings; Dump: TStrings);
begin
  fbDump(HugeSingleLine(TSql), Dump);
end;

procedure fbDump(_R: integer; References: TStringList; Dump: TStringList); overload;
var
  cDATA: TdboCursor;
  Dependency: string;
  Condition: string;
  AddFields: string;
  TableName: string;
  FieldName: string;
  CalculatedSQL: string;
  n, m: integer;

begin
  cDATA := nCursor;
  with cDATA do
  begin
    for n := 0 to pred(References.count) do
    begin
      Condition := cutblank(nextp(References[n], ' where ', 1));
      Dependency := cutblank(nextp(References[n], ' where ', 0));

      AddFields := cutblank(nextp(Dependency, ',', 1));
      Dependency := cutblank(nextp(Dependency, ',', 0));

      TableName := nextp(Dependency, '.', 0);
      FieldName := nextp(Dependency, '.', 1);
      if OrgaMonDB_hasRID(TableName) then
      begin
        if (Condition <> '') then
          Condition := ' and (' + Condition + ')';

        sql.add(
          { } 'select RID from ' +
          { } TableName +
          { } ' where (' +
          { } FieldName + ' = ' + inttostr(_R) + ')' +
          { } Condition);

        m := 0;
        ApiFirst;
        while not(eof) do
        begin

          //
          inc(m);
          if (m = 1) then
            CalculatedSQL := FieldByName('RID').AsString
          else
            CalculatedSQL := CalculatedSQL + fbDumpKomma + FieldByName('RID').AsString;

          // Script ab und zu auftrennen
          if (m > 500) then
          begin
            Dump.Insert(0, 'update ' + TableName + ' set ' + FieldName + '=' + inttostr(_R) + ' where RID in (' +
              CalculatedSQL + ');');
            m := 0;
          end;

          ApiNext;
        end;
        close;
        sql.clear;

        repeat

          if (m = 0) then
            break;

          if (m = 1) then
          begin
            Dump.Insert(0, 'update ' + TableName + ' set ' + FieldName + '=' + inttostr(_R) + ' where RID=' +
              CalculatedSQL + ';');
            break;
          end;

          Dump.Insert(0, 'update ' + TableName + ' set ' + FieldName + '=' + inttostr(_R) + ' where RID in (' +
            CalculatedSQL + ');')

        until yet;
      end;
    end;
  end;
  cDATA.free;
end;

procedure e_x_sql(s: string);
begin
  dbLog(s,false);
{$IFDEF fpc}
  fbConnection.ExecuteDirect(s);
{$ELSE}
{$IFDEF CONSOLE}
  fbTransaction.ExecuteImmediate(s);
{$ELSE}
  Datamoduledatenbank.IB_Transaction_W.ExecuteImmediate(s);
{$ENDIF}
{$ENDIF}
end;

procedure e_x_commit;
begin
{$IFDEF fpc}
  fbConnection.commit;
{$ELSE}
{$IFDEF CONSOLE}
  // In der Konsolenanwendung haben wir nur *eine* Transaktion, ein commit war bisher
  // nicht notwendig
{$ELSE}
  Datamoduledatenbank.IB_Transaction_R.commit;
{$ENDIF}
{$ENDIF}
end;

function e_w_GEN(GenName: string): integer;
{$IFDEF fpc}
var
  s: TZSequence;
{$ENDIF}
begin
{$IFDEF fpc}
  s := TZSequence.create(nil);
  with s do
  begin
    connection := fbConnection;
    SequenceName := GenName;
    BlockSize := 1;
    result := GetNextValue;
  end;
  s.free;
{$ELSE}
{$IFDEF CONSOLE}
  result := fbConnection.gen_id(GenName, 1);
{$ELSE}
  result := Datamoduledatenbank.IB_connection1.gen_id(GenName, 1);
{$ENDIF}
{$ENDIF}
   dbLog(
      { } 'select GEN_ID(' +
      { } GenName +
      { } ',1) from RDB$DATABASE',false);

end;

function e_r_GEN(GenName: string): integer;
{$IFDEF fpc}
var
  s: TZSequence;
{$ENDIF}
begin
{$IFDEF fpc}
  s := TZSequence.create(nil);
  with s do
  begin
    connection := fbConnection;
    SequenceName := GenName;
    result := GetCurrentValue;
  end;
  s.free;
{$ELSE}
{$IFDEF CONSOLE}
  result := fbConnection.gen_id(GenName, 0);
{$ELSE}
  result := Datamoduledatenbank.IB_connection1.gen_id(GenName, 0);
{$ENDIF}
{$ENDIF}
    dbLog(
      { } 'select GEN_ID(' +
      { } GenName +
      { } ',0) from RDB$DATABASE');
end;

procedure e_x_update(s: string; sl: TStringList);
var
  qUPDATE: TdboQuery;
begin
  qUPDATE := nQuery;
  with qUPDATE do
  begin
    sql.add(s);
    First;
    edit;
    Fields[0].Assign(sl);
    post;
  end;
  qUPDATE.free;
end;

procedure e_x_sql(s: TStrings);
begin
  e_x_sql(HugeSingleLine(s, #13#10));
end;

function e_r_sql(s: string): integer;
var
  cSQL: TdboCursor;
begin
  cSQL := nCursor;
  with cSQL do
  begin
    sql.add(s);
    dbLog(s);
    ApiFirst;
    result := Fields[0].AsInteger;
  end;
  cSQL.free;
end;

function e_r_IsNull(s: string) : boolean;
var
  cSQL: TdboCursor;
begin
  cSQL := nCursor;
  with cSQL do
  begin
    sql.add(s);
    dbLog(s);
    ApiFirst;
    result := Fields[0].IsNull;
  end;
  cSQL.free;
end;


function HasFieldName(IBQ: TdboDataset; FieldName: string): boolean;
var
  n: integer;
begin
  result := false;
  with IBQ do
  begin
    for n := 0 to pred(FieldCount) do
      if (Fields[n].FieldName = FieldName) then
      begin
        result := true;
        break;
      end;
  end;
end;

function EnsureSQL(const s: string): string;
begin
  result := s;
  ersetze('''', '''''', result);
end;

function SQLstring(const s: string): string;
begin
  result := '''' + EnsureSQL(s) + '''';
end;

function nQuery: TdboQuery;
begin
{$IFDEF fpc}
  result := TdboQuery.create(nil);
  result.connection := fbConnection;
{$ELSE}
{$IFDEF CONSOLE}
  result := TIB_Query.create(nil);
  with result do
  begin
    ib_connection := fbConnection;
    IB_Session := fbSession;
  end;
{$ELSE}
  result := Datamoduledatenbank.nQuery;
{$ENDIF}
{$ENDIF}
end;

function nCursor: TdboCursor;
begin
{$IFDEF fpc}
  result := TdboCursor.create(niL);
  result.connection := fbConnection;
{$ELSE}
{$IFDEF CONSOLE}
  result := TIB_Cursor.create(nil);
  with result do
  begin
    ib_connection := fbConnection;
    IB_Session := fbSession;
  end;
{$ELSE}
  result := Datamoduledatenbank.nCursor;
  result.IB_Transaction := Datamoduledatenbank.IB_Transaction_R;
{$ENDIF}
{$ENDIF}
end;

function nScript: TdboScript;
begin
{$IFDEF fpc}
  result := TdboScript.create(nil);
  result.connection := fbConnection;
{$ELSE}
{$IFDEF CONSOLE}
  result := TIB_DSQL.create(nil);
  with result do
  begin
    ib_connection := fbConnection;
    IB_Session := fbSession;
  end;
{$ELSE}
  result := Datamoduledatenbank.nDSQL;
{$ENDIF}
{$ENDIF}
end;

type
  eConnectionCountMethod = (eCCM_unchecked, eCCM_impossible, eCCM_MonitorTables);

const
  CCM: eConnectionCountMethod = eCCM_unchecked;

function MON_ConnectionCount: Integer;

const
 cSQL = 'select count(0) from MON$ATTACHMENTS where MON$USER=''SYSDBA''';

{$IFDEF fpc}
  MON_Connection: TZConnection = nil;
  MON_Cursor: TZReadOnlyQuery = nil;
{$ELSE}
  {$ifndef IBO_OLD}
  MON_fbClientLib: TIB_ClientLib = nil;
  {$endif}
  MON_Connection: TIB_Connection = nil;
  MON_Transaction: TIB_Transaction = nil;
  MON_Session: TIB_Session = nil;
  MON_Cursor: TIB_Cursor = nil;
{$ENDIF}

begin
  result := -1;
  try
{$IFDEF fpc}
  MON_Connection := TZConnection.Create(nil);
  with MON_Connection do
  begin
    ClientCodePage := 'ISO8859_1';
    ControlsCodePage := cCP_UTF8;
    Protocol := 'firebird-2.5';
    TransactIsolationLevel := tiReadCommitted;
    User := iDataBaseUser;
    HostName := i_c_DataBaseHost;
    Database := i_c_DataBaseFName;
    Password := deCrypt_Hex(iDataBasePassword);
    Connect;
  end;

  MON_CURSOR := TZReadOnlyQuery.create(niL);
  with MON_CURSOR do
  begin
   connection := MON_Connection;
   sql.add(cSQL);
   dbLog(cSQL);
   Open;
   First;
   result := pred(Fields[0].AsInteger);
  end;

  MON_CURSOR.Free;
  MON_Connection.Free;

{$ELSE}

  {$ifndef IBO_OLD}
  MON_fbClientLib := TIB_ClientLib.Create(nil);
  with MON_fbClientLib do
  begin
    Filename := ExtractFilePath(ParamStr(0)) + globals.GetFBClientLibName;
  end;
  {$endif}
  MON_Session := TIB_Session.Create(nil);
  MON_Transaction := TIB_Transaction.Create(nil);
  MON_Connection := TIB_Connection.Create(nil);


  with MON_Session do
  begin
    {$ifndef IBO_OLD}
    IB_ClientLib := MON_fbClientLib;
    {$endif}
    AllowDefaultConnection := True;
    AllowDefaultTransaction := True;
    DefaultConnection := MON_Connection;
    StoreActive := False;
    UseCursor := False;
  end;

  with MON_Connection do
  begin
    IB_Session := MON_Session;
    CacheStatementHandles := False;
    DefaultTransaction := MON_Transaction;
    SQLDialect := 3;
    ParameterOrder := poNew;
    CharSet := 'NONE';
  end;

  with MON_Transaction do
  begin
    IB_Session := MON_Session;
    IB_Connection := MON_Connection;
    ServerAutoCommit := True;
    Isolation := tiCommitted;
    RecVersion := True;
    LockWait := True;
  end;

  with MON_Connection do
  begin
    DataBaseName := iDataBaseName;
    if (i_c_DataBaseHost = '') then
    begin
      Server := '';
      protocol := cplocal;
    end
    else
    begin
      protocol := cpTCP_IP;
    end;
    UserName := iDataBaseUser;
    Password := deCrypt_Hex(iDataBasePassword);
    Connect;
  end;

  MON_Cursor := TIB_Cursor.create(nil);
  with MON_Cursor do
  begin
    ib_connection := MON_Connection;
    IB_Session := MON_Session;
    sql.add(cSQL);
    dbLog(cSQL);
    ApiFirst;
    result := pred(Fields[0].AsInteger);
  end;

  MON_Cursor.Free;
  MON_Connection.Free;
  MON_Transaction.Free;
  MON_Session.Free;
{$ENDIF}
  except
  end;
end;

function e_r_ConnectionCount: integer;
begin

  if (CCM = eCCM_unchecked) then
  begin
    if (e_r_sql(
     {} 'select' +
     {} ' count(RDB$RELATION_NAME) ' +
     {} 'from' +
     {} ' RDB$RELATIONS ' +
     {} 'where' +
     {} ' (RDB$RELATION_NAME=''MON$ATTACHMENTS'')') = 1) then
      CCM := eCCM_MonitorTables
    else
      CCM := eCCM_impossible;
  end;

  if (CCM = eCCM_MonitorTables) then
    result := MON_ConnectionCount
  else
   result := 1;

end;

function e_r_IsRID(FieldName: string; RID: integer): boolean;
begin
  result := false;
  repeat
    if (RID < cRID_FirstValid) then
      break;

    result := (e_r_sql(
      { } 'select' +
      { } ' count(RID) ' +
      { } 'from' +
      { } ' ' + nextp(FieldName, '_', 0) + ' ' +
      { } 'where' +
      { } ' RID=' + inttostr(RID)) = 1);
  until yet;
end;

function e_r_NoRID(FieldName: string; RID: integer): boolean;
begin
  result := false;
  repeat
    if (RID < cRID_FirstValid) then
      break;

    result := (e_r_sql(
      { } 'select' +
      { } ' count(RID) ' +
      { } 'from' +
      { } ' ' + nextp(FieldName, '_', 0) + ' ' +
      { } 'where' +
      { } ' RID=' + inttostr(RID)) = 0);
  until yet;
end;

function for_update(s: TStrings = nil): string;
begin
{$IFNDEF fpc}
  if assigned(s) then
    s.add('for update');
  result := 'for update';
{$ELSE}
  result := '';
{$ENDIF}
  if assigned(s) then
    dbLog(s,false);
end;

function e_r_sql(s: string; sl: TStringList): integer;
var
  cSQL: TdboCursor;
begin
  result := 1;
  cSQL := nCursor;
  with cSQL do
  begin
    sql.add(s);
    dbLog(s);
    ApiFirst;
    e_r_sqlt(Fields[0], sl);
  end;
  cSQL.free;
end;

function e_r_sqlt(s: string): TStringList;
var
  cSQL: TdboCursor;
begin
  result := TStringList.create;
  cSQL := nCursor;
  with cSQL do
  begin
    sql.add(s);
    dbLog(s);
    ApiFirst;
    e_r_sqlt(Fields[0], result);
  end;
  cSQL.free;
end;

function e_r_sqlsl(s: string): TStringList;
var
  cSQL: TdboCursor;
begin
  result := TStringList.create;
  cSQL := nCursor;
  with cSQL do
  begin
    sql.add(s);
    dbLog(s);
    ApiFirst;
    while not(eof) do
    begin
      result.add(Fields[0].AsString);
      ApiNext;
    end;
  end;
  cSQL.free;
end;

function e_r_sqlslo(s: string): TStringList;
var
  cSQL: TdboCursor;
begin
  result := TStringList.create;
  cSQL := nCursor;
  with cSQL do
  begin
    sql.add(s);
    dbLog(s);
    ApiFirst;
    while not(eof) do
    begin
      result.AddObject(Fields[0].AsString, Pointer(Fields[1].AsInteger));
      ApiNext;
    end;
  end;
  cSQL.free;
end;

function e_r_sqlm(s: string; m: TgpIntegerList = nil): TgpIntegerList; overload;
var
  cSQL: TdboCursor;
begin
  if assigned(m) then
    result := m
  else
    result := TgpIntegerList.create;
  cSQL := nCursor;
  with cSQL do
  begin
    sql.add(s);
    dbLog(s);
    ApiFirst;
    while not(eof) do
    begin
      result.add(Fields[0].AsInteger);
      ApiNext;
    end;
  end;
  cSQL.free;
end;

function e_r_sqlm(TSql: TStrings; m: TgpIntegerList = nil): TgpIntegerList; overload;
var
  cSQL: TdboCursor;
  s : String;
begin
  if assigned(m) then
    result := m
  else
    result := TgpIntegerList.create;
  s := HugeSingleLine(TSql, ' ');
  cSQL := nCursor;
  with cSQL do
  begin
    sql.add(s);
    dbLog(s);
    ApiFirst;
    while not(eof) do
    begin
      result.add(Fields[0].AsInteger);
      ApiNext;
    end;
  end;
  cSQL.free;
end;

function e_r_sqls(s: string): string;
var
  cSQL: TdboCursor;
begin
  cSQL := nCursor;
  with cSQL do
  begin
    sql.add(s);
    dbLog(s);
    ApiFirst;
    result := Fields[0].AsString;
  end;
  cSQL.free;
end;

function e_r_sqlb(s: string): boolean;
begin
  result := e_r_sqls(s) = cC_True;
end;

function e_r_sqld(s: string; ifnull: double = 0.0): double;
var
  cSQL: TdboCursor;
begin
  cSQL := nCursor;
  with cSQL do
  begin
    sql.add(s);
    dbLog(s);
    ApiFirst;
    if eof then
      result := ifnull
    else
{$IFDEF fpc}
      result := Fields[0].AsFloat;
{$ELSE}
      result := Fields[0].AsDouble;
{$ENDIF}
  end;
  cSQL.free;
end;

function e_r_sql_Date(s: string): TANFiXDate;
var
  cSQL: TdboCursor;
begin
  cSQL := nCursor;
  with cSQL do
  begin
    sql.add(s);
    dbLog(s);
    ApiFirst;
    if eof then
      result := cIllegalDate
    else
{$ifdef FPC}
result := DateTime2Long(Fields[0].AsDateTime);
{$else}
result := DateTime2Long(Fields[0].AsDate);
{$endif}
  end;
  cSQL.free;
end;

function e_r_sql_DateTime(s: string): TDateTime;
var
  cSQL: TdboCursor;
begin
  cSQL := nCursor;
  with cSQL do
  begin
    sql.add(s);
    dbLog(s);
    ApiFirst;
    if eof then
      result := cIllegalDate
    else
      result := Fields[0].AsDateTime;
  end;
  cSQL.free;
end;

procedure e_w_dereference(RID: integer; TableN, FieldN: string; DeleteIt: boolean = false; References : TStrings = nil);
var
  sql: TStringList;
begin
  if (RID>=cRID_FirstValid) then
  begin
    sql := TStringList.create;
    if DeleteIt then
    begin
      sql.add('delete from ' + TableN);
      sql.add('WHERE');
      sql.add(FieldN + '=' + inttostr(RID));
    end
    else
    begin
      sql.add('update');
      sql.add(TableN + ' set');
      sql.add(FieldN + ' = NULL');
      sql.add('WHERE');
      sql.add(FieldN + '=' + inttostr(RID));
    end;
    e_x_sql(sql);
    sql.free;
  end;
  if assigned(References) then
   References.add(TableN + '.' + FieldN);
end;

function e_r_now: TDateTime;
var
  cNOW: TdboCursor;
begin
  cNOW := nCursor;
  with cNOW do
  begin
    sql.add('select CURRENT_TIMESTAMP from RDB$DATABASE');
    dbLog(sql);
    ApiFirst;
    result := Fields[0].AsDateTime;
  end;
  cNOW.free;
end;

procedure e_x_dereference(dependencies: TStringList; fromref, toref: string); overload;
var
  Dependency: string;
  Condition: string;
  AddFields: string;
  TableName: string;
  FieldName: string;
  CalculatedSQL: string;
  n: integer;
begin
  try
    for n := 0 to pred(dependencies.count) do
    begin
      Condition := cutblank(nextp(dependencies[n], ' where ', 1));
      Dependency := cutblank(nextp(dependencies[n], ' where ', 0));

      AddFields := cutblank(nextp(Dependency, ',', 1));
      Dependency := cutblank(nextp(Dependency, ',', 0));

      TableName := nextp(Dependency, '.', 0);
      FieldName := nextp(Dependency, '.', 1);

      if (Condition <> '') then
        Condition := ' and (' + Condition + ')';

      CalculatedSQL :=
      { } 'update ' + TableName + ' ' +
      { } 'set ' + FieldName + ' = ' + toref + AddFields + ' ' +
      { } 'where (' + FieldName + ' = ' + fromref + ')' +
      { } Condition;

      try
        e_x_sql(CalculatedSQL);
      except
        on E: Exception do
        begin
          AppendStringsToFile(E.Message, ErrorFName('SQL'), Uhr12);
        end;
      end;

    end;
  except
    on E: Exception do
    begin
      AppendStringsToFile(E.Message, ErrorFName('SQL'), Uhr12);
    end;
  end;
end;

procedure e_x_dereference(dependencies, fromref, toref: string); overload;
var
  sl: TStringList;
begin
  sl := TStringList.create;
  sl.add(dependencies);
  e_x_dereference(sl, fromref, toref);
  sl.free;
end;

procedure e_x_dereference(dependencies: TStringList; fromref: Integer; toref: Integer); overload;
begin
  e_x_dereference(dependencies, IntToStr(fromref), IntToStr(toref));
end;

function ResolveSQL(const sql: String): String;
begin
  if (pos('select', sql) = 1) then
  begin
    result := e_r_sqls(sql)
  end
  else
  begin
    e_x_sql(sql);
    result := '';
  end;
end;

const
  dbBASIC: TBasicProcessor = nil;
  dbBASIC_FName_Cache: TStringList = nil;

procedure e_x_basic(FName: string; ParameterL: TStrings = nil); overload;
var
  n: integer;
  sBASIC: TStringList;
begin

  // Init
  if (dbBASIC = nil) then
  begin
    dbBASIC := TBasicProcessor.create;
    dbBASIC.DeviceOverride := 'null';
    dbBASIC.ResolveSQL := ResolveSQL;
    dbBASIC_FName_Cache := TStringList.create;
    n := -1;
  end
  else
  begin
    n := dbBASIC_FName_Cache.indexof(FName);
  end;

  // Get Script
  // ACHTUNG: ein einziges Mal (das erste Mal) wird aus dem Dateisystem
  // das Script geladen, bzw. dessen Existenz geprüft. Danach bleibt es
  // gecached. Es wird auch nicht mehr auf das ev. spätere Erscheinen
  // des Skriptes geachtet.
  if (n = -1) then
  begin
    if FileExists(FName) then
    begin
      sBASIC := TStringList.create;
      sBASIC.LoadFromFile(FName);
    end
    else
    begin
      sBASIC := nil;
    end;
    dbBASIC_FName_Cache.AddObject(FName, sBASIC);
  end
  else
  begin
    sBASIC := TStringList(dbBASIC_FName_Cache.Objects[n]);
    // Im Debug-Modus: Überschreibe das ev. gecachte Script (es könnte auch nil sein) mit
    // dem aus dem Dateisystem - bei jedem einzelnen Lauf, da es sein kann dass dieses Skript
    // ständig entwickelt also auch abgeändert wird
    if DebugMode then
      if assigned(sBASIC) then
       sBASIC.LoadFromFile(FName);
  end;

  // Execute
  if assigned(sBASIC) then
  begin

    with dbBASIC do
    begin

      // Übernahme der ParameterL
      FileName := FName;
      for n := 0 to pred(ParameterL.count) do
        WriteVal(nextp(ParameterL[n], '=', 0), nextp(ParameterL[n], '=', 1));

      // Ausgabe eines vorherigen Laufes löschen
      CLS;

      // Script-Inhalt setzen
      Assign(sBASIC);

      // Script starten
      if not(RUN) then
      begin
        // Fehler bei der Ausführung
        BasicErrors.insert(0,FName+':');
        AppendStringsToFile(BasicErrors, ErrorFName('D-BASIC'), Uhr12);
      end;

      if DebugMode then
        AppendStringsToFile(BasicOutPut, DiagnosePath + 'D-BASIC-RUN-' + DatumLog + cLogExtension, Uhr12);

    end;

  end;
end;

procedure e_x_basic(FName: string; ParameterS: String = ''); overload;
var
  ParameterL: TStringList;
begin
  ParameterL := TStringList.create;
  while (ParameterS <> '') do
    ParameterL.add(nextp(ParameterS));
  e_x_basic(FName, ParameterL);
  ParameterL.free;
end;

function r_Local_vs_Server_TimeDifference: Integer;
const
  cWahrnehmungsSchwelle = 2;
var
  LocalTime, ServerTime: TANFiXTime;
  LocalDate, ServerDate: TANFiXDate;
begin
  LocalDate := DateGet;
  LocalTime := SecondsGet;
  DateTime2Long(e_r_now, ServerDate, ServerTime);
  result := SecondsDiffABS(LocalDate, LocalTime, ServerDate, ServerTime);
  if (result<=cWahrnehmungsSchwelle) then
    result := 0;
end;

function e_r_Revision_Latest: single;
begin
  result := e_r_sql('select max(RID) from REVISION') / 1000.0;
end;

function e_r_Revision_Zwang: single;
begin
  result := e_r_sql('select RID from REVISION where DATUM>CURRENT_TIMESTAMP') / 1000.0;
end;

function e_r_NameFromMask(iDataBaseName: string): string;
var
  sDir: TStringList;
  k, j, l: integer;
  Mask: string;
  Path: string;
begin
  k := pos('*', iDataBaseName);
  if (k = 0) then
  begin
    result := nextp(iDataBaseName,';',0);
  end
  else
  begin
    result := '';
    j := pos(';', iDataBaseName);
    if (j = 0) then
    begin
      // Datenbank auf "localhost"
      l := max(
        { } revpos('\', iDataBaseName),
        { } revpos('/', iDataBaseName));
      Mask := copy(iDataBaseName, succ(l), j - l);
      iDataBaseName := copy(iDataBaseName, 1, l);
      Path := iDataBaseName;
    end
    else
    begin
      // Datenbank auf "remotehost"
      Path := copy(iDataBaseName, succ(j), MaxInt);
      iDataBaseName := copy(iDataBaseName, 1, pred(j));
      l := max(
        { } revpos('\', iDataBaseName),
        { } revpos('/', iDataBaseName));

      Mask := copy(iDataBaseName, succ(l), j - l);
      iDataBaseName := copy(iDataBaseName, 1, l);
    end;

    sDir := TStringList.create;
    dir(Path + Mask, sDir, false, false);
    if (sDir.count > 0) then
    begin
      sDir.sort;
      result := iDataBaseName + sDir[pred(sDir.count)];
    end;
  end;

end;

const
 _dbLog_Read_FName : string = '';

function dbLog_Read_FName : string;
begin
 if (_dbLog_Read_FName='') then
  _dbLog_Read_FName :=
   { } DebugLogPath +
   { } 'rSQL-' +
   { } DatumLog + '-' +
   { } e_r_Kontext +
   { } '.txt';
 result := _dbLog_Read_FName;
end;

const
 _dbLog_Write_FName : string = '';

function dbLog_Write_FName : string;
begin
 if (_dbLog_Write_FName='') then
   _dbLog_Write_FName :=
     { } DebugLogPath +
     { } 'wSQL-' +
     { } DatumLog + '-' +
     { } e_r_Kontext +
     { } '.txt';
 result := _dbLog_Write_FName;
end;

procedure dbLog(s:string;ReadOnly: boolean = true); overload;
begin
  if DebugMode then
  begin
    if ReadOnly then
      AppendStringsToFile(s, dbLog_Read_FName, Uhr12)
    else
      AppendStringsToFile(s, dbLog_Write_FName, Uhr12);
  end;
end;

procedure dbLog(sl:TStrings;ReadOnly: boolean = true); overload;
begin
  if DebugMode then
  begin
    if ReadOnly then
      AppendStringsToFile(sl, dbLog_Read_FName, Uhr12)
    else
      AppendStringsToFile(sl, dbLog_Write_FName, Uhr12);
  end;
end;

end.
