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
unit IBExportTable;

interface

uses
  Classes,
  IB_Components,
  IB_Access,
  gplists,
  WordIndex,
  anfix32;

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
  TIB_Club = class(TObject)
    ID: integer;
    RefTable: string;
    ibc: TIB_Connection;
    items: TgpIntegerList;
    itemsByReference: TgpIntegerList;

  private
    function TableName: string;
    procedure xsql(s: String);

  public
    constructor create(pibc: TIB_Connection; pRefTable: string); virtual;
    destructor Destroy; override;

    procedure add(i: integer); overload;
    procedure add(i: TgpIntegerList); overload;
    function sql(fromList: TgpIntegerList = nil): string; overload;
    function sql(s: string): string; overload;
    function join(FieldName: string = ''): string;
  end;

const
  cConnection: TIB_Connection = nil;

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
function AsKeyValue(q: TIB_Query): TStringList;

// Script
procedure ExportScript(TSql: TStrings; FName: string;
  Seperator: char = ';'); overload;
procedure ExportScript(TSql: string; FName: string;
  Seperator: char = ';'); overload;

procedure JoinTables(SourceL: TStringList; DestFName: string);
procedure RenameColumnHeader(fromS, toS: string; DestFName: string);

// Tools für den Anzeige Umfang von Queries
procedure ChangeWhere(q: TIB_Query; NewWhere: TStringList); overload;
procedure ChangeWhere(q: TIB_Query; NewWhere: string); overload;
procedure qSelectOne(q: TIB_Query);
procedure qSelectAll(q: TIB_Query);
procedure qSelectList(q: TIB_Query; FName: string); overload;
procedure qSelectList(q: TIB_Query; l: TList); overload;
procedure qStringsAdd(f: TIB_Column; s: string);
function HeaderNames(q: TIB_Query): TStringList; overload;
function HeaderNames(q: TIB_Dataset): TStringList; overload;
function ColOf(q: TIB_Query; FieldName: string): integer; overload;
function ColOf(q: TIB_Datasource; FieldName: string): integer; overload;

function ListasSQL(i: TgpIntegerList): string; overload;
function ListasSQL(i: TList): string; overload;

// Datum Tools
function Datum_coalesce(f: TIB_Column; d: TANFiXDate): TANFiXDate;

// Tools für SQL Abfragen
function isRID(RID: integer): string;
function bool2cC(b: boolean): string;
function RIDtostr(RID: integer): string;

// Tools für das Tabellen Handling
function useTable(TableName: string): string;
function AllTables: TStringList;
function TableExists(TableName: string): boolean;
procedure DropTable(TableName: string);
function RecordCopy(TableName, GeneratorName: string; RID: integer): integer;
function e_r_fbClientVersion: string;

implementation

uses
  Windows,
  SysUtils,
  IB_Header,
  IB_Session,
  Math,
  CareTakerClient;

procedure ChangeWhere(q: TIB_Query; NewWhere: TStringList);
begin
  with q do
  begin
    close;
    while pos(cSQLwhereMarker, sql[pred(sql.count)]) = 0 do
      sql.delete(pred(sql.count));
    sql.AddStrings(NewWhere);
  end;
end;

procedure ChangeWhere(q: TIB_Query; NewWhere: string);
var
  NewWhereS: TStringList;
begin
  NewWhereS := TStringList.create;
  NewWhereS.add(NewWhere);
  ChangeWhere(q, NewWhereS);
  NewWhereS.free;
end;

procedure qSelectList(q: TIB_Query; l: TList); overload;
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

procedure qSelectList(q: TIB_Query; FName: string); overload;
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

procedure qSelectOne(q: TIB_Query);
var
  ResultSQL: TStringList;
begin
  ResultSQL := TStringList.create;
  ResultSQL.add('WHERE RID=:CROSSREF');
  ResultSQL.add('FOR UPDATE');
  ChangeWhere(q, ResultSQL);
  ResultSQL.free;
end;

procedure qSelectAll(q: TIB_Query);
begin
  ChangeWhere(q, 'FOR UPDATE');
end;

procedure ExportTable(TSql: string; FName: string; Seperator: char = ';';
  AppendMode: boolean = false);
var
  cABLAGE: TIB_Cursor;
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
  cABLAGE := TIB_Cursor.create(nil);
  StartTime := 0;
  with cABLAGE do
  begin

    if assigned(cConnection) then
      ib_connection := cConnection;

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
  cABLAGE: TIB_Cursor;
  n, m: integer;
  Infostr: string;
  DB_text: string;
  DB_memo: TStringList;

begin
  result := TStringList.create;
  DB_memo := TStringList.create;
  cABLAGE := TIB_Cursor.create(nil);
  try
    with cABLAGE do
    begin

      if assigned(cConnection) then
        ib_connection := cConnection;

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

function AsKeyValue(q: TIB_Query): TStringList;
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
  cABLAGE: TIB_Cursor;
  n, m: integer;
  Content: string;
  sRow: TStringList;

  DB_text: string;
  DB_memo: TStringList;

begin
  result := TsTable.create;
  DB_memo := TStringList.create;
  cABLAGE := TIB_Cursor.create(nil);
  with cABLAGE do
  begin

    if assigned(cConnection) then
      ib_connection := cConnection;

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
  cSYSTEM: TIB_Cursor;
begin
  result := TStringList.create;
  cSYSTEM := TIB_Cursor.create(nil);
  with cSYSTEM do
  begin
    if assigned(cConnection) then
      ib_connection := cConnection;
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

procedure DropTable(TableName: string);
var
  x: TIB_DSQL;
begin
  if TableExists(TableName) then
  begin
    x := TIB_DSQL.create(nil);
    with x do
    begin
      if assigned(cConnection) then
        ib_connection := cConnection;
      sql.add('drop table ' + TableName);
      execute;
    end;
    x.free;
  end;
end;

procedure qStringsAdd(f: TIB_Column; s: string);
var
  sl: TStringList;
begin
  sl := TStringList.create;
  f.AssignTo(sl);
  sl.add(s);
  f.assign(sl);
  sl.free;
end;

function RecordCopy(TableName, GeneratorName: string; RID: integer): integer;
var
  cSOURCE: TIB_Cursor;
  qDEST: TIB_Query;
  NewRID: integer;
  _FieldName: string;
  n: integer;
begin
  result := -1;
  cSOURCE := TIB_Cursor.create(nil);
  qDEST := TIB_Query.create(nil);
  try
    repeat

      //
      with cSOURCE do
      begin
        if assigned(cConnection) then
          ib_connection := cConnection;

        sql.add('select * from ' + TableName + ' where RID=' + inttostr(RID));

        if DebugMode then
          AppendStringsToFile(sql, DebugLogPath + 'wSQL-' + inttostr(DateGet) +
            '.txt', DatumUhr);

        ApiFirst;
        if eof then
          break;
        NewRID := gen_id(GeneratorName, 1);
      end;

      //
      with qDEST do
      begin
        if assigned(cConnection) then
          ib_connection := cConnection;
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

function gen_id(genName: string; Step: integer = 0): integer;
var
  x: TIB_DSQL;
begin
  if assigned(cConnection) then
  begin
    result := cConnection.gen_id(genName, Step);
  end
  else
  begin
    x := TIB_DSQL.create(nil);
    with x do
    begin
      result := gen_id(genName, Step);
    end;
    x.free;
  end;
end;

{ TSQLMENGE }

procedure TIB_Club.add(i: integer);
begin
  if not(assigned(items)) then
    items := TgpIntegerList.create;
  items.add(i);
end;

procedure TIB_Club.add(i: TgpIntegerList);
begin
  if not(assigned(items)) then
    items := TgpIntegerList.create;
  items.append(i);
end;

constructor TIB_Club.create;
begin
  //
  RefTable := pRefTable;
  ibc := pibc;
end;

destructor TIB_Club.Destroy;
begin
  if assigned(items) then
    FreeAndNil(items);
  xsql('drop table ' + TableName);
  inherited;
end;

function TIB_Club.join(FieldName: string = ''): string;
begin

  if (FieldName = '') then
    FieldName := 'RID';

  result :=
  { } ' ' +
  { } 'join ' + TableName + ' on' +
  { } ' (' + TableName + '.RID=' + RefTable + '.' + FieldName + ') ';
end;

function TIB_Club.sql(s: string): string;
begin
  // den Club mit Hife des SQL füllen!
  result := TableName;
  xsql('insert into ' + result + ' (RID) ' + s);
end;

function TIB_Club.sql(fromList: TgpIntegerList = nil): string;
var
  workL: TgpIntegerList;
  n: integer;
  dCLUB: TIB_DSQL;
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

  dCLUB := TIB_DSQL.create(nil);
  with dCLUB do
  begin
    if assigned(cConnection) then
      ib_connection := cConnection;

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

function TIB_Club.TableName: string;
begin
  if (ID = 0) then
  begin
    ID := gen_id('GEN_CLUB', 1);
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

procedure TIB_Club.xsql(s: String);
begin
  ibc.DefaultTransaction.ExecuteImmediate(s);
end;

function e_r_fbClientVersion: string;
var
  TheModuleName: array [0 .. 1023] of char;
  s: string;
begin
  // welcher Client wird verwendet
  GetModuleFileName(FGDS_Handle, TheModuleName, sizeof(TheModuleName));
  s := TheModuleName;
  result := s + ' ' + FileVersion(TheModuleName);
end;

function isRID(RID: integer): string;
begin
  if (RID < cRID_FirstValid) then
    result := ' is null'
  else
    result := '=' + inttostr(RID);
end;

function ColOf(q: TIB_Query; FieldName: string): integer; overload;
var
  sHeaderNames: TStringList;
begin
  sHeaderNames := HeaderNames(q);
  result := sHeaderNames.indexof(FieldName);
  sHeaderNames.free;
end;

function ColOf(q: TIB_Datasource; FieldName: string): integer; overload;
var
  sHeaderNames: TStringList;
begin
  sHeaderNames := HeaderNames(q.Dataset);
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

function HeaderNames(q: TIB_Query): TStringList; overload;
var
  n: integer;
begin
  result := TStringList.create;
  with q do
    for n := 0 to pred(FieldCount) do
      result.add(Fields[n].FieldName);
end;

function HeaderNames(q: TIB_Dataset): TStringList; overload;
var
  n: integer;
begin
  result := TStringList.create;
  with q do
    for n := 0 to pred(FieldCount) do
      result.add(Fields[n].FieldName);
end;

function Datum_coalesce(f: TIB_Column; d: TANFiXDate): TANFiXDate;
begin
  if f.IsNull then
    result := d
  else
    result := DateTime2Long(f.AsDate);
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
  cTABLE: TIB_Cursor;
  cFIELDCOUNT: integer;
  InsertPreFix: string;
  n, m: integer;
  sRow: string;
  Content: string;
  DB_text: string;
  DB_memo: TStringList;

begin
  DB_memo := TStringList.create;
  cTABLE := TIB_Cursor.create(nil);
  _TableName := cTableNameUnset;

  InsertPreFix := 'insert into ' + cTableName;
  with cTABLE do
  begin

    if assigned(cConnection) then
      ib_connection := cConnection;

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
  cDATA: TIB_Cursor;
  Dependency: string;
  Condition: string;
  AddFields: string;
  TableName: string;
  FieldName: string;
  CalculatedSQL: string;
  n, m: integer;

begin
  cDATA := TIB_Cursor.create(nil);
  with cDATA do
  begin
    if assigned(cConnection) then
      ib_connection := cConnection;
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

end.
