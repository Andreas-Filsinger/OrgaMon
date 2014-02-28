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
unit dbOrgaMon;

interface

{

  dbOrgaMon: Abstrahiert die Datenbankschicht, stellt dazu einige

  dbo* ("dbo" für DatenBank OrgaMon) Klassen zur Verfügung

}

uses
  Classes,
{$IFDEF fpc}
  db,
  ZConnection,
  ZDataset,
  ZAbstractDataset,
  ZDbcResultSetMetadata,
  ZSQLProcessor,
{$ELSE}
  IB_Components,
  IB_Access,
{$ENDIF}
  gplists,
  WordIndex,
  anfix32,
  globals;

type
{$IFDEF fpc}
TdboDatasource = TDatasource;
TdboDataset = TDataset;

{ TdboScript }

TdboScript = class(TZSQLProcessor)
  public function sql : TStrings;
end;

  TdboQuery = TZQuery;
  TdboField = TField;

  { TdboCursor }

  TdboCursor = class(TZReadOnlyQuery)
  public
    procedure ApiFirst;
    procedure ApiNext;
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

  // Datenbank Ankreuzfelder (Check)
  cC_True = 'Y';
  cC_True_AsString = '''Y''';
  cC_False = 'N';
  cC_concant = '||';

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
{$IFDEF fpc}
    ibc: TZConnection;
{$ELSE}
    ibc: TIB_Connection;
{$ENDIF}
    items: TgpIntegerList;
    itemsByReference: TgpIntegerList;

  private
    function TableName: string;
    procedure xsql(s: String);

  public
{$IFDEF fpc}
    constructor create(pibc: TZConnection; pRefTable: string); virtual;
{$ELSE}
    constructor create(pibc: TIB_Connection; pRefTable: string); virtual;
{$ENDIF}
    destructor Destroy; override;

    procedure add(i: integer); overload;
    procedure add(i: TgpIntegerList); overload;
    function sql(fromList: TgpIntegerList = nil): string; overload;
    function sql(s: string): string; overload;
    function join(FieldName: string = ''): string;
  end;

const
{$IFDEF fpc}
  cConnection: TZConnection = nil;
{$ELSE}
  cConnection: TIB_Connection = nil;
{$ENDIF}
  // Datenbank Tabelle exportieren
procedure ExportTable(TSql: string; FName: string; Seperator: char = ';';
  AppendMode: boolean = false); overload;
procedure ExportTable(TSql: TStrings; FName: string;
  Seperator: char = ';'); overload;
function slTable(TSql: string): TStringList; overload;
function slTable(TSql: TStrings): TStringList; overload;
function csTable(TSql: string): TsTable; overload;
function csTable(TSql: TStrings): TsTable; overload;

procedure fbDump(TSql: string; Dump: TStrings); overload;
procedure fbDump(TSql: TStrings; Dump: TStrings); overload;
procedure fbDump(_R: integer; References: TStringList;
  Dump: TStringList); overload;

// Datenbank Record exportiern
function AsKeyValue(q: TdboQuery): TStringList;

// Script
procedure ExportScript(TSql: TStrings; FName: string;
  Seperator: char = ';'); overload;
procedure ExportScript(TSql: string; FName: string;
  Seperator: char = ';'); overload;

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
function ColOf(q: TdboQuery; FieldName: string): integer; overload;
function ColOf(q: TdboDatasource; FieldName: string): integer; overload;

function ListasSQL(i: TgpIntegerList): string; overload;
function ListasSQL(i: TList): string; overload;

// Datum Tools
function Datum_coalesce(f: TdboField; d: TANFiXDate): TANFiXDate;

// Tools für SQL Abfragen
function isRID(RID: integer): string;
function bool2cC(b: boolean): string;
function RIDtostr(RID: integer): string;
function HasFieldName(IBQ: TdboDataset; FieldName: string): boolean;
function EnsureSQL(s: string): string;

// Tools für das Tabellen Handling
function useTable(TableName: string): string;
function AllTables: TStringList;
function TableExists(TableName: string): boolean;
procedure DropTable(TableName: string);
function RecordCopy(TableName, GeneratorName: string; RID: integer): integer;

// Grundsätzliche Datenbank-Objekte
function nQuery: TdboQuery;
function nCursor: TdboCursor;
function nScript: TdboScript;

{ Datenbank Abfragen allgemein }
function e_r_IsRID(FieldName: string; RID: integer): boolean;
// SQL selects, die einen Einzelnen Wert zurückgeben

function e_r_sql(s: string): integer; overload;
// Nur das erste Feld aus der ersten Zeile als Integer

function e_r_sql(s: string; sl: TStringList): integer; overload;
// Nur das erste Feld aus der Element als Text-Blob, result=1

function e_r_sqlt(s: string): TStringList; overload;
procedure e_r_sqlt(Field: TdboField;s: TStrings); overload;
// Nur das erste Feld des ersten Records als Text-Blob

function e_r_GEN(GenName: string): integer;

function e_w_GEN(GenName: string): integer;
// erhöht den Generator erst um eins und liefert dann diesen neuen Wert.

// Zeit aus dem Datenbankserver lesen
function e_r_now: TdateTime;

//
function e_r_sqls(s: string): string;
function e_r_sqlb(s: string): boolean;
function e_r_sqld(s: string; ifnull: double = 0.0): double;

// Erste Ergebnis-Spalte als TStringList
function e_r_sqlsl(s: string): TStringList;

// wie sqlsl, jedoch noch den "RID" in der 2. Spalte
function e_r_sqlslo(s: string): TStringList;

// Alle numerischen Ergebnisse der ersten Spalte als Integer-Liste
function e_r_sqlm(s: string; m: TgpIntegerList = nil): TgpIntegerList;

function e_r_OLAP(OLAP: TStringList; Params: TStringList): TStringList;

// SQL Update, Execute Statements
procedure e_x_sql(s: string); overload;
procedure e_x_sql(s: TStrings); overload;
procedure e_x_update(s: string; sl: TStringList);
procedure e_w_dereference(RID: integer; TableN, FieldN: string;
  DeleteIt: boolean = false);

// Datenbank-Server Commit
procedure e_x_commit;

// Server Infos
function e_r_fbClientVersion: string;
function e_r_ConnectionCount: integer;


{$IFDEF CONSOLE}
{$IFDEF fpc}
const

fbConnection: TZConnection = nil;


{$ELSE}

  // Globale Datenbank-Elemente
const
  fbConnection: TIB_Connection = nil;
  fbTransaction: TIB_Transaction = nil;
  fbSession: TIB_Session = nil;

{$ENDIF}
{$ENDIF}

implementation

uses
  Windows,
  SysUtils,
{$IFDEF fpc}
  fpchelper,
{$ELSE}
  {$IFNDEF CONSOLE}
   Datenbank,
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
  ResultSQL.add(') for update');
  ChangeWhere(q, ResultSQL);
  ResultSQL.free;
end;

procedure qSelectList(q: TdboQuery; FName: string); overload;
var
  ResultSQL: TStringList;
  TheRIDs: TsTable;
  r, RID: integer;
  sRID: string;
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

procedure ExportTable(TSql: string; FName: string; Seperator: char = ';';
  AppendMode: boolean = false);
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
  cABLAGE := TdboCursor.create(nil);
  StartTime := 0;
  with cABLAGE do
  begin

    if assigned(cConnection) then
{$IFDEF fpc}
      connection := cConnection;
{$ELSE}
      ib_connection := cConnection;
{$ENDIF}
    sql.add(TSql);

    if DebugMode then
      AppendStringsToFile(sql, DebugLogPath + 'wSQL-' + inttostr(DateGet) +
        '.txt', DatumUhr);
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
                  Infostr := Infostr + long2date(DateTime2Long(AsDateTime)) +
                    ' ' + secondstostr(DateTime2seconds(AsDateTime));
                end;

              SQL_TYPE_DATE, SQL_TYPE_DATE_:
                begin
                  Infostr := Infostr + long2date(DateTime2Long(AsDateTime));
                end;

              SQL_TYPE_TIME, SQL_TYPE_TIME_:
                begin
                  Infostr := Infostr +
                    secondstostr(DateTime2seconds(AsDateTime));
                end;
            else
              Infostr := Infostr + 'SQLType ' + inttostr(SQLType) +
                ' unbekannt!';
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
  cABLAGE := TdboCursor.create(nil);
  try
    with cABLAGE do
    begin

      if assigned(cConnection) then
{$IFDEF fpc}
        connection := cConnection;
{$ELSE}
        ib_connection := cConnection;
{$ENDIF}
      sql.add(TSql);
      if DebugMode then
        AppendStringsToFile(sql, DebugLogPath + 'wSQL-' + inttostr(DateGet) +
          '.txt', DatumUhr);
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
                    Infostr := Infostr + long2date(DateTime2Long(AsDateTime)) +
                      ' ' + secondstostr(DateTime2seconds(AsDateTime));
                  end;

                SQL_TYPE_DATE, SQL_TYPE_DATE_:
                  begin
                    Infostr := Infostr + long2date(DateTime2Long(AsDateTime));
                  end;
                SQL_TYPE_TIME, SQL_TYPE_TIME_:
                  begin
                    Infostr := Infostr +
                      secondstostr(DateTime2seconds(AsDateTime));
                  end;
              else
                Infostr := Infostr + 'SQLType ' + inttostr(SQLType) +
                  ' unbekannt!';
              end;
{$ENDIF}
          end
      else
      begin
        Infostr := Infostr + '<NULL>';
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
                  Infostr := long2date(DateTime2Long(AsDateTime)) + ' ' +
                    secondstostr(DateTime2seconds(AsDateTime));
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
  cABLAGE: TdboCursor;
  n, m: integer;
  Content: string;
  sRow: TStringList;

  DB_text: string;
  DB_memo: TStringList;

begin
  result := TsTable.create;
  DB_memo := TStringList.create;
  cABLAGE := TdboCursor.create(nil);
  with cABLAGE do
  begin

    if assigned(cConnection) then
{$IFDEF fpc}
      connection := cConnection;
{$ELSE}
      ib_connection := cConnection;
{$ENDIF}
    sql.add(TSql);
    if DebugMode then
      AppendStringsToFile(sql, DebugLogPath + 'wSQL-' + inttostr(DateGet) +
        '.txt', DatumUhr);
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
                  Content := long2date(DateTime2Long(AsDateTime)) + ' ' +
                    secondstostr(DateTime2seconds(AsDateTime));
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
        Content := '<NULL>';
      end;
      sRow.add(Content);
    end;
  end;
  result.add(sRow);
  ApiNext;
end;
end;
cABLAGE.free;
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

procedure ExportTable(TSql: TStrings; FName: string;
  Seperator: char = ';'); overload;
begin
  ExportTable(HugeSingleLine(TSql, ' '), FName, Seperator);
end;

procedure ExportScript(TSql: TStrings; FName: string;
  Seperator: char = ';'); overload;
begin
  ExportScript(HugeSingleLine(TSql, ' '), FName, Seperator);
end;

procedure ExportScript(TSql: string; FName: string;
  Seperator: char = ';'); overload;
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
  cABLAGE: TIB_DSQL;
  Ablage: TStringList;
begin
  FileDelete(FName);
  Ablage := TStringList.create;
  cABLAGE := TIB_DSQL.create(nil);
  with cABLAGE do
  begin
    if assigned(cConnection) then
      ib_connection := cConnection;
    sql.add(TSql);
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

{ TdboCursor }

procedure TdboCursor.ApiFirst;
begin
  First;
end;

procedure TdboCursor.ApiNext;
begin
  Next;
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
      insert(BlockStart, nextp(NewLines, #13));
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
    sql.add('SELECT');
    sql.add(' RDB$RELATION_NAME');
    sql.add('FROM');
    sql.add(' RDB$RELATIONS');
    sql.add('WHERE');
    sql.add(' (RDB$VIEW_BLR is null) and');
    sql.add(' (RDB$SYSTEM_FLAG=0)');
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
var
  TableList: TStringList;
begin
  //
  TableList := AllTables;
  result := TableList.indexof(TableName) <> -1;
  TableList.free;
end;

// imp pend: This is really "DropTableIfExists()"
procedure DropTable(TableName: string);
begin
  if TableExists(TableName) then
    e_x_sql('drop table ' + TableName);
end;

procedure qStringsAdd(f: TdboField; s: string);
var
  sl: TStringList;
begin
  sl := TStringList.create;
{$ifdef fpc}
 Raise Exception.Create('imp pend: db: Add a Line to TStringList-Field');
{$else}
  f.AssignTo(sl);
  sl.add(s);
  f.assign(sl);
{$endif}
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

        if DebugMode then
          AppendStringsToFile(sql, DebugLogPath + 'wSQL-' + inttostr(DateGet) +
            '.txt', DatumUhr);

        ApiFirst;
        if eof then
          break;
        NewRID := e_w_gen(GeneratorName);
      end;

      //
      with qDEST do
      begin
        sql.add('select * from ' + TableName + ' for update');
        insert;
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

            qDEST.FieldByName(_FieldName)
              .assign(cSOURCE.FieldByName(_FieldName));

          until true;
        end;
        post;
      end;

      result := NewRID;
    until true;

  except

  end;
  cSOURCE.free;
  qDEST.free;
end;

{ TSQLMENGE }

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

constructor TdboClub.create;
begin
  //
  RefTable := pRefTable;
  ibc := pibc;
end;

destructor TdboClub.Destroy;
begin
  if assigned(items) then
    FreeAndNil(items);
  xsql('drop table ' + TableName);
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

function TdboClub.sql(s: string): string;
begin
  // den Club mit Hife des SQL füllen!
  result := TableName;
  xsql('insert into ' + result + ' (RID) ' + s);
end;

function TdboClub.sql(fromList: TgpIntegerList = nil): string;
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
    ID := e_w_gen('GEN_CLUB');
    result := 'CLUB$' + inttostr(ID);

    // CLUB Tabelle neu anlegen
    xsql(
      { } 'create table ' +
      { } result +
      { } ' (RID DOM_REFERENCE NOT NULL,' +
      { } '  constraint PK_' + result + ' primary key (RID)' +
      { } ' )');

  end
  else
  begin
    result := 'CLUB$' + inttostr(ID);
  end;
end;

procedure TdboClub.xsql(s: String);
begin
   e_x_sql(s);
//  ibc.DefaultTransaction.ExecuteImmediate(s);
end;

function e_r_fbClientVersion: string;
var
  TheModuleName: array [0 .. 1023] of char;
  s: string;
begin
{$ifdef fpc}
 result := 'imp pend: obtain DLL-Handle';
{$else}
  // welcher Client wird verwendet
  GetModuleFileName(FGDS_Handle, TheModuleName, sizeof(TheModuleName));
  s := TheModuleName;
  result := s + ' ' + FileVersion(TheModuleName);
{$endif}
end;

function isRID(RID: integer): string;
begin
  if (RID < cRID_FirstValid) then
    result := ' is null'
  else
    result := '=' + inttostr(RID);
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
        until false;
        _TableName := copy(TSql, Token_Begin, succ(Token_End - Token_Begin));

      end
      else
      begin
        raise Exception.create('fbDump: SQL: "' + cToken_FROM +
          '" nicht gefunden!');
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
    if DebugMode then
      AppendStringsToFile(sql, DebugLogPath + 'wSQL-' + inttostr(DateGet) +
        '.txt', DatumUhr);
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
{$ifdef fpc}
Content := AsString;

{$else}
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
                  Content := '''' +
                    secondstostr(DateTime2seconds(AsDateTime)) + '''';
                end;
            else
              Content := 'SQLType ' + inttostr(SQLType) + ' unbekannt!';
            end;
{$endif}

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
      Dump.insert(0, InsertPreFix + sRow + ');');
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
  until true;
end;

procedure fbDump(TSql: TStrings; Dump: TStrings);
begin
  fbDump(HugeSingleLine(TSql), Dump);
end;

procedure fbDump(_R: integer; References: TStringList;
  Dump: TStringList); overload;
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
            CalculatedSQL := CalculatedSQL + fbDumpKomma +
              FieldByName('RID').AsString;

          // Script ab und zu auftrennen
          if (m > 500) then
          begin
            Dump.insert(0, 'update ' + TableName + ' set ' + FieldName + '=' +
              inttostr(_R) + ' where RID in (' + CalculatedSQL + ');');
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
            Dump.insert(0, 'update ' + TableName + ' set ' + FieldName + '=' +
              inttostr(_R) + ' where RID=' + CalculatedSQL + ';');
            break;
          end;

          Dump.insert(0, 'update ' + TableName + ' set ' + FieldName + '=' +
            inttostr(_R) + ' where RID in (' + CalculatedSQL + ');')

        until true;
      end;
    end;
  end;
  cDATA.free;
end;

procedure e_x_sql(s: string);
begin
  if DebugMode then
    AppendStringsToFile(s, DiagnosePath + 'wSQL-' + inttostr(DateGet) + '.txt',
      DatumUhr);
{$ifdef fpc}
 raise Exception.create('imp pend: e_x_sql');
{$else}
{$IFDEF CONSOLE}
  fbTransaction.ExecuteImmediate(s);
{$ELSE}
  Datamoduledatenbank.IB_Transaction_W.ExecuteImmediate(s);
{$ENDIF}
{$endif}
end;

procedure e_x_commit;
begin
  {$ifdef fpc}
   raise Exception.create('imp pend: e_x_commit');
  {$else}
{$IFDEF CONSOLE}
  // In der Konsolenanwendung haben wir nur *eine* Transaktion, ein commit war bisher
  // nicht notwendig
{$ELSE}
  Datamoduledatenbank.IB_Transaction_R.Commit;
  {$ENDIF}
  {$ENDIF}
end;

function e_r_GEN(GenName: string): integer;
begin
  {$ifdef fpc}
   raise Exception.create('imp pend: e_r_gen');
  {$else}
{$IFDEF CONSOLE}
  result := fbConnection.gen_id(GenName, 0);
{$ELSE}
  result := Datamoduledatenbank.IB_connection1.gen_id(GenName, 0);
{$ENDIF}
{$ENDIF}
end;

function e_w_GEN(GenName: string): integer;
begin
  {$ifdef fpc}
   raise Exception.create('imp pend: e_w_gen');
  {$else}
{$IFDEF CONSOLE}
  result := fbConnection.gen_id(GenName, 1);
{$ELSE}
  result := Datamoduledatenbank.IB_connection1.gen_id(GenName, 1);
{$ENDIF}
{$ENDIF}
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
    Fields[0].assign(sl);
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
    ApiFirst;
    result := Fields[0].AsInteger;
  end;
  cSQL.free;
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
    ApiFirst;
{$ifdef fpc}
 Raise Exception.create('imp pend: Assign StringList to Blob');
{$else}
    Fields[0].AssignTo(sl);
{$endif}
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

function EnsureSQL(s: string): string;
begin
  result := s;
  ersetze('''', '''''', result);
end;

function nQuery: TdboQuery;
begin

{$ifdef fpc}
result := TZQuery.create(nil);

{$else}
{$IFDEF CONSOLE}
  result := TIB_Query.create(nil);
  with result do
  begin
    IB_Connection := fbConnection;
    IB_Session := fbSession;
  end;
{$ELSE}
  result := Datamoduledatenbank.nQuery;
{$ENDIF}
{$ENDIF}
end;

function nCursor: TdboCursor;
begin
  {$ifdef fpc}
  result := TdboCursor.create(niL);
  {$else}
  {$IFDEF CONSOLE}
  result := TIB_Cursor.create(nil);
  with result do
  begin
    IB_Connection := fbConnection;
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
{$ifdef fpc}
 result := TdboScript.create(nil);
{$else}
{$IFDEF CONSOLE}
  result := TIB_DSQL.create(nil);
  with result do
  begin
    IB_Connection := fbConnection;
    IB_Session := fbSession;
  end;
{$ELSE}
  result := Datamoduledatenbank.nDSQL;
{$ENDIF}
{$ENDIF}
end;

type
  eConnectionCountMethod = (eCCM_unchecked, eCCM_impossible,
    eCCM_MonitorTables);

const
  CCM: eConnectionCountMethod = eCCM_unchecked;

function e_r_ConnectionCount: integer;
begin
  if (CCM = eCCM_unchecked) then
  begin
    if (e_r_sql('SELECT' + ' count(RDB$RELATION_NAME) ' + 'FROM' +
      ' RDB$RELATIONS ' + 'WHERE' +
      ' (RDB$RELATION_NAME=''MON$ATTACHMENTS'')') = 1) then
      CCM := eCCM_MonitorTables
    else
      CCM := eCCM_impossible;
  end;

  if (CCM = eCCM_MonitorTables) then
    result := e_r_sql('select sum(MON$STATE) from MON$ATTACHMENTS')
  else
    result := 1;

end;
function e_r_IsRID(FieldName: string; RID: integer): boolean;
begin
  result := false;
  repeat
    if (RID < cRID_FirstValid) then
      break;

    result := (e_r_sql('select count(RID) from ' + nextp(FieldName, '_',
      0) + ' where RID=' + inttostr(RID)) = 1);
  until true;
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
    ApiFirst;
    {$ifdef fpc}
     Raise Exception.Create('imp pend: dbOrgaMon:e_r_sqlt Add a Line to TStringList-Field');
    {$else}
    Fields[0].AssignTo(result);
{$endif}
  end;
  cSQL.free;
end;

procedure e_r_sqlt(Field: TdboField;s: TStrings); overload;
begin
{$ifdef fpc}
     Raise Exception.Create('imp pend: dbOrgaMon:e_r_sqlt Add a Line to TStringList-Field');
{$else}
 Field.AssignTo(s);
{$endif}
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
    ApiFirst;
    while not(eof) do
    begin
      result.AddObject(Fields[0].AsString, Pointer(Fields[1].AsInteger));
      ApiNext;
    end;
  end;
  cSQL.free;
end;

function e_r_sqlm(s: string; m: TgpIntegerList = nil): TgpIntegerList;
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
    ApiFirst;
    if eof then
      result := ifnull
    else
      {$ifdef fpc}
      result := Fields[0].AsFloat;
    {$else}
    result := Fields[0].AsDouble;
    {$endif}
  end;
  cSQL.free;
end;

procedure e_w_dereference(RID: integer; TableN, FieldN: string;
  DeleteIt: boolean = false);
var
  sql: TStringList;
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


function e_r_OLAP(OLAP: TStringList; Params: TStringList): TStringList;
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
      if k = 0 then
        break;

      // Länge bestimmen
      l := min(k + 1, length(result));
      repeat
        if (l > length(result)) then
          break;
        if not(result[l] in ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '_']) then
          break;
        inc(l);
      until false;

      // Nun austauschen
      ersetze(copy(result, k, l - k), ParameterL.Values[copy(result, k, l - k)
        ], result);

    until false;
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

  //
  // 12.12.2005
  // erste Anfänge, den Kernel via OLAP Statements
  // variable zu halten. Die OLAP Ausführungs-Funktion sollte
  // noch vollständig in das eCommerce Modul verschoben werden.
  //
  result := TStringList.create;
  ParameterL := TStringList.create;
  ParameterL.addstrings(Params);
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
    ApiFirst;
    for n := 0 to pred(FieldCount) do
      result.add(Fields[n].FieldName + '=' + Fields[n].AsString);
  end;

  cOLAP.free;
  ParameterL.free;
end;

function e_r_now: TdateTime;
var
  cNOW: TdboCursor;
begin
  cNOW := nCursor;
  with cNOW do
  begin
    sql.add('select CURRENT_TIMESTAMP from RDB$DATABASE');
    ApiFirst;
    result := Fields[0].AsDateTime;
  end;
  cNOW.free;
end;

end.
