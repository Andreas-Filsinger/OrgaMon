unit IBExportTable;

interface

uses
  Classes, IB_Components, IB_Grid,
  gplists;

const
  cMinimalHeaderWidth = 9;
  cSQLwhereMarker = '// -- BEGIN';
type
  TSQLStringList = class(TStringList)
  public
    procedure ReplaceBlock(BlockName: string; NewLines: string);
  end;

  // Tools für ELEMENT
  TIB_Club = class(TObject)
    ID: integer;
    RefTable: string;
    items: TIntegerList;
    itemsByReference: TIntegerList;
  private
    function TableName: string;
  public
    constructor create(pRefTable: string); virtual;
    destructor Destroy; override;

    procedure add(i: integer); overload;
    procedure add(i: TIntegerList); overload;
    function sql(fromList: TIntegerList = nil): string;
  end;

const
  cConnection: TIB_Connection = nil;

// Table
procedure ExportTable(TSql: string; FName: string; Seperator: char = ';'; AppendMode: boolean = false); overload;
procedure ExportTable(TSql: TStrings; FName: string; Seperator: char = ';'); overload;
procedure ExportTableAsXLS(TSql: string; FName: string; Seperator: char = ';'); overload;
procedure ExportTableAsXLS(TSql: TStrings; FName: string; Seperator: char = ';'); overload;

// Script
procedure ExportScript(TSql: TStrings; FName: string; Seperator: char = ';'); overload;
procedure ExportScript(TSql: string; FName: string; Seperator: char = ';'); overload;

procedure JoinTables(SourceL: TStringList; DestFName: string);
procedure RenameColumnHeader(fromS, toS: string; DestFName: string);

// Tools für die Speicherung von Spaltenbreiten und Reihenfolge
//
// 1) OnClick bei Speedbutton:
//      SaveHeaderSettings(IB_grid, UserDir + HeaderSettingsFName(IB_grid));
// 2) OnMouseDown beim Speedbutton:
(*
  if (Button = mbRight) then
    if doit('Wollen Sie die Spaltenbreiten wieder auf Standard setzen', true) then
    begin
      FileDelete(UserDir + HeaderSettingsFName(IB_grid));
      IB_Query.close;
      IB_Query.sql.clear;
      IB_Query.sql.AddStrings(Query_SQL); // <- gerettes Orginal SQL
      IB_Query.open;
    end;
*)
// 3) BeforePrepare bei der Query
//        LoadHeaderSettings(IB_grid, UserDir + HeaderSettingsFName(IB_grid));
//
//  4) im FormCreate
//       das SQL der Orginal Abfrage reten
//
function HeaderSettingsFName(g: TIB_Grid): string;
procedure SaveHeaderSettings(g: TIB_Grid; FName: string);
procedure LoadHeaderSettings(g: TIB_Grid; FName: string);
function GridSettingsIdentifier(g: TIB_Grid): string;
function HeaderACol(g: TIB_Grid; HeaderFieldName: string): integer;

// Tools für den Anzeige Umfang von Queries
procedure ChangeWhere(q: TIB_Query; NewWhere: TStringList); overload;
procedure ChangeWhere(q: TIB_Query; NewWhere: string); overload;
procedure qSelectOne(q: TIB_Query);
procedure qSelectAll(q: TIB_Query);
procedure qSelectList(q: TIB_Query; FName: string); overload;
procedure qSelectList(q: TIB_Query; l: TList); overload;
procedure qStringsAdd(f: TIB_Column; s: string);
function ListasSQL(i: TIntegerList): string; overload;
function ListasSQL(i: TList): string; overload;

// Tools für das Tabellen Handling
function AllTables: TStringList;
function TableExists(TableName: string): boolean;
procedure DropTable(TableName: string);
function RecordCopy(TableName, GeneratorName: string; RID: integer): integer;
function e_r_fbClientVersion: string;

implementation

uses
  Windows, Messages, SysUtils,
  Variants, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, anfix32, WordIndex,
  IB_Constants, IB_Header, IB_Process,
  IB_Session, Math, ExcelHelper;

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
  ResultSQL.add('WHERE RID IN (');
  for n := 0 to pred(min(l.count, 999)) do
    if (n = 0) then
      ResultSQL.add(inttostr(integer(l[n])))
    else
      ResultSQL.add(',' + inttostr(integer(l[n])));
  ResultSQL.add(') FOR UPDATE');
  ChangeWhere(q, ResultSQL);
  ResultSQL.free;
end;

procedure qSelectList(q: TIB_Query; FName: string); overload;
var
  ResultSQL: TStringList;
  TheRIDs: TStringList;
  n: integer;
begin
  TheRIDs := TStringList.create;
  try
    TheRIDs.LoadFromFile(FName);

    ResultSQL := TStringList.create;
    if (TheRIDs.count < 2) then
    begin
      ResultSQL.add('where RID is null');
    end else
    begin
      ResultSQL.add('where RID in (');
      for n := 1 to pred(min(TheRIDs.count, 999)) do
        if (n = 1) then
          ResultSQL.add(nextp(TheRIDs[n], ';', 0))
        else
          ResultSQL.add(',' + nextp(TheRIDs[n], ';', 0));
      ResultSQL.add(')');
    end;
    ResultSQL.add('for update');
    ChangeWhere(q, ResultSQL);
    ResultSQL.free;
  except
  end;
  TheRIDs.free;
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

procedure ExportTable(TSql: string; FName: string; Seperator: char = ';'; AppendMode: boolean = false);
var
  cABLAGE: TIB_Cursor;
  Ablage: TStringList;
  RecN: integer;
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
  end else
  begin
    FileDelete(FName);
    FirstTimeWrite := true;
  end;
  DB_memo := TStringList.create;
  Ablage := TStringList.create;
  cABLAGE := TIB_Cursor.create(nil);
  RecN := 0;
  StartTime := 0;
  with cABLAGE do
  begin

    if assigned(cConnection) then
      ib_connection := cConnection;

    sql.add(Tsql);
    ApiFirst;

    // Kopfzeile
    Infostr := '';
    for n := 0 to pred(FieldCount) do
    begin
      with Fields[n] do
        InfoStr := InfoStr + FieldName { '.' + inttostr(SQLType) + };
      if (n <> pred(FieldCount)) then
        Infostr := Infostr + Seperator;

    end;
    if FirstTimeWrite then
      Ablage.add(InfoStr);

    while not (eof) do
    begin

      InfoStr := '';
      for n := 0 to pred(FieldCount) do
        with Fields[n] do
        begin
          if not (IsNull) then
          begin

            case SQLType of
              SQL_DOUBLE,
                SQL_DOUBLE_: InfoStr := InfoStr + format('%.2f', [AsDouble]);

              SQL_INT64,
                SQL_INT64_: InfoStr := InfoStr + inttostr(AsInt64);

              SQL_SHORT,
                SQL_SHORT_,
                SQL_LONG,
                SQL_LONG_: InfoStr := InfoStr + inttostr(AsInteger);

              SQL_VARYING,
                SQL_VARYING_,
                SQL_TEXT,
                SQL_TEXT_: begin
                  DB_text := AsString;
                  ersetze(#13, '', DB_text);
                  ersetze(#10, '', DB_text);
                  ersetze('"', '''', DB_text);
                  InfoStr := InfoStr + '"' + DB_text + '"';
                end;

              SQL_BLOB,
                SQL_BLOB_: begin
                  // if SubType = isc_blob_text
                  DB_text := '';
                  AssignTo(DB_memo);
                  for m := 0 to pred(DB_memo.count) do
                    if (m = 0) then
                      DB_text := DB_memo[0]
                    else
                      DB_text := DB_text + '|' + DB_memo[m];
                  ersetze('"', '''', DB_text);
                  InfoStr := InfoStr + '"' + DB_text + '"';
                end;

              SQL_TIMESTAMP,
                SQL_TIMESTAMP_: begin
                  InfoStr := InfoStr + long2date(DateTime2Long(AsDateTime)) + ' ' +
                    secondstostr(DateTime2seconds(AsDateTime));
                end;

              SQL_TYPE_DATE,
                SQL_TYPE_DATE_: begin
                  INfostr := InfoStr + long2date(DateTime2Long(AsDateTime));
                end;
            else
              InfoStr := InfoStr + 'SQLType ' + inttostr(SQLType) + ' unbekannt!';
            end;
          end else
          begin
            InfoStr := InfoStr + '<NULL>';
          end;

          if (n <> pred(FieldCount)) then
            InfoStr := InfoStr + Seperator;

        end;

      Ablage.add(Infostr);

      inc(RecN);
      ApiNext;
      if frequently(StartTime, 1000) or eof then
      begin
        application.processmessages;
        SaveResults;
      end;
    end;
    SaveResults;
  end;
  cABLAGE.free;
  Ablage.free;
  DB_memo.free;
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
    OneL.LoadfromFile(SourceL[n]);
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
  DestL.Free;
end;

procedure RenameColumnHeader(fromS, toS: string; DestFName: string);
var
  DestL: TSTringList;
begin
  DestL := TSTringList.create;
  DestL.loadFromFile(DestFName);
  ersetze(fromS, toS, DestL, 0);
  DestL.SaveToFile(DestFName);
  DestL.free;
end;

function HeaderACol(g: TIB_Grid; HeaderFieldName: string): integer;
var
  n: integer;
begin
  result := -1;
  with g do
    for n := 0 to pred(GridFieldCount) do
      if (GridFields[n].FieldName = HeaderFieldName) then
      begin
        result := succ(n);
        break;
      end;
end;

procedure SaveHeaderSettings(g: TIB_Grid; FName: string);
var
  k, n: integer;
  oColsL: TSearchStringList;
  nColsL: TStringList;
begin
  // Reihenfolge + Breite abspeichern!
  // ganze kleine Spalten ganz unten!
  oColsL := TSearchStringList.create;
  nColsL := TStringList.create;
  if FileExists(Fname) then
    oColsL.LoadFromFile(FName);
  with g do
    for n := 0 to pred(GridFieldCount) do
    begin
      nColsL.add(GridFields[n].FieldName + '=' + inttostr(GridFields[n].DisplayWidth));
      k := oColsL.findinc(GridFields[n].FieldName + '=');
      if (k <> -1) then
        oColsL.delete(k)
    end;
  nColsL.addStrings(oColsL);
  nColsL.SaveToFile(FName);
  nColsL.free;
  oColsL.free;

  // Neue Settings aktivieren
  if g.datasource.dataset.active then
  begin
    g.datasource.dataset.close;
    LoadHeaderSettings(g, FName);
    g.datasource.dataset.open;
  end;
end;

procedure LoadHeaderSettings(g: TIB_Grid; FName: string);
var
  ColsL: TStringList;
  k, m, n: integer;
  TheWidth: integer;
  nSQL: TStringList; // new SQL
  oSQL: TStringList; // old SQL
  sSQL: TStringList; // sorted SQL
  AutomataState: integer;
  BeginFields, EndFields: integer;
  FieldName: string;

  function SearchFor(s: string): integer;
  var
    n: integer;
  begin
    result := -1;
    for n := 0 to pred(oSQL.count) do
      if pos(s, oSQL[n]) > 0 then
      begin
        result := n;
        break;
      end;
  end;

begin
  if FileExists(extractFilePath(Fname) + '..\' + ExtractFileName(Fname)) then
    FName := extractFilePath(Fname) + '..\' + ExtractFileName(Fname);
  if FileExists(FName) then
  begin
    if g.datasource.dataset.active then
      g.datasource.dataset.close;

    Colsl := TStringList.create;
    Colsl.LoadFromFile(FName);
    nSQL := TStringList.create;
    oSQL := TStringList.create;
    sSQL := TStringList.create;

    // Spaltenreihenfolge anpassen
    AutomataState := 0;
    nSQL.addstrings(g.datasource.dataset.sql);

    for n := 0 to pred(nSQL.count) do
    begin
      case AutoMataState of
        0: begin // search "SELECT"
            if pos('SELECT', nSQL[n]) = 1 then
            begin
              BeginFields := succ(n);
              AutoMataState := 1;
            end;
          end;
        1: begin
            if pos('FROM', nSQL[n]) = 1 then
            begin
              // processing
              EndFields := pred(n);
              for m := 0 to pred(ColsL.count) do
              begin
                FieldName := nextp(ColsL[m], '=', 0);

                // Methode "1", Feld Alias mit
                repeat
                  k := SearchFor('as ' + FieldName);
                  if k <> -1 then
                    break;
                  k := SearchFor(' ' + FieldName);
                  if k <> -1 then
                    break;
                  k := SearchFor('.' + FieldName);
                  if k <> -1 then
                    break;
                  k := SearchFor(FieldName);
                  if k <> -1 then
                    break;
                until true;

                if (k <> -1) then
                begin
                  sSQL.add(oSQL[k]);
                  oSQL.delete(k);
                end;
              end;

              // Rest, was nich berührt war hinten dran
              sSQL.addstrings(oSQL);

              // Sicherstellen, dass die Kommas stimmen
              if pos(',', sSQL[0]) = 1 then
                sSQL[0] := copy(sSQL[0], 2, MaxInt);
              for m := 1 to pred(sSQL.count) do
                if pos(',', sSQL[m]) <> 1 then
                  sSQL[m] := ',' + sSQL[m];

              // Nun die bisherige Felderreihenfolge Überschreiben!
              for m := 0 to pred(sSQL.count) do
                g.datasource.dataset.sql[BeginFields + m] := sSql[m];

              break;
              AutoMataState := 2;
            end else
            begin
              oSQL.add(nSQL[n]);
            end;
          end;
      end;
    end;

    // nun Spaltenbreiten anpassen
    for n := 0 to pred(Colsl.count) do
    begin
      TheWidth := strtointdef(nextp(ColsL[n], '=', 1), 0);
      if (TheWidth >= cMinimalHeaderWidth) then
        g.datasource.dataset.FieldsDisplayWidth.values[nextp(ColsL[n], '=', 0)] := inttostr(TheWidth)
      else
        g.datasource.dataset.Fieldsvisible.add(nextp(ColsL[n], '=', 0) + '=FALSE');
    end;
    ColsL.free;
    nSQL.free;
    oSQL.free;
    sSQL.free;
  end;

end;

function GridSettingsIdentifier(g: TIB_Grid): string;
begin
  with g do
    result :=
    // Formular
    dataSource.dataset.owner.name + '.' +
    // Grid
    name + '.' +
    // Query / Cursor
    dataSource.dataset.name;
end;

function HeaderSettingsFName(g: TIB_Grid): string;
begin
  result :=
    'Spalteneinstellung.' +
    GridSettingsIdentifier(g) +
    '.txt';
end;

procedure ExportTable(TSql: Tstrings; FName: string; Seperator: char = ';'); overload;
begin
  ExportTable(HugeSingleLine(TSql, ' '), FName, Seperator);
end;

procedure ExportScript(TSql: Tstrings; FName: string; Seperator: char = ';'); overload;
begin
  ExportScript(HugeSingleLine(TSql, ' '), FName, Seperator);
end;

procedure ExportScript(TSql: string; FName: string; Seperator: char = ';'); overload;
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
    sql.add(Tsql);
    execute;

    // imp pend: hier sollte mal die Anzahl der Betroffenen Datensätze
    //           ausgegeben werden!

    Ablage.add('ANZAHL;');
    Ablage.add('<NULL>;');

  end;
  AppendStringsToFile(Ablage, FName);
  cABLAGE.free;
  Ablage.free;
end;

function ListasSQL(i: TIntegerList): string; overload;
var
  n: integer;
begin
  if assigned(i) then
  begin
    if (i.count > 0) then
    begin
      result := '(' + inttostr(i[0]);
      for n := 1 to pred(i.count) do
        result := result + ',' + inttostr(i[n]);
      result := result + ')';
    end else
    begin
      result := 'NULL';
    end;
  end else
  begin
    result := 'NULL';
  end;
end;

function ListasSQL(i: TList): string; overload;
var
  iL: TIntegerList;
  n: integer;
begin
  if assigned(i) then
  begin
    iL := TIntegerList.create;
    for n := 0 to pred(i.Count) do
      il.add(integer(i[n]));
    result := ListAsSQL(iL);
    iL.free;
  end else
  begin
    result := ListAsSQL(TIntegerList(nil));
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
      inc(Blockstart);
      insert(BlockStart, nextp(NewLines, #13));
    end;
    for n := Blockstart to pred(count) do
      if pos('~' + BlockName + ' end~', strings[n]) > 0 then
      begin
        BlockEnd := n;
        break;
      end;

    for n := pred(BlockEnd) downto succ(BlockStart) do
      delete(n);
  end;
end;

function AllTables: TSTringList;
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
    while not (eof) do
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
end;

procedure DropTable(TableName: string);
var
  x: TIB_dsql;
begin
  if TableExists(TableName) then
  begin
    x := TIB_dsql.create(nil);
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

procedure ExportTableAsXLS(TSql: string; FName: string; Seperator: char = ';'); overload;
var
  Content: TList;
  Headers: TStringList;
  Options: TStringList;

  procedure CreateContent;
  var
    cABLAGE: TIB_Cursor;
    Subs: TStringList;
    n, m: integer;
    Infostr: string;
    DB_text: string;
    DB_memo: TStringList;

  begin
    DB_memo := TStringList.create;
    cABLAGE := TIB_Cursor.create(nil);
    with cABLAGE do
    begin

      if assigned(cConnection) then
        ib_connection := cConnection;

      sql.add(Tsql);
      ApiFirst;

      // Kopfzeile
      for n := 0 to pred(FieldCount) do
        with Fields[n] do
        begin
          Headers.add(FieldName);
          case SQLType of
            SQL_DOUBLE,
              SQL_DOUBLE_: Options.add(FieldName + '=' + xls_CellTypes[xls_CellType_Money]);
            SQL_INT64,
              SQL_INT64_: Options.add(FieldName + '=' + xls_CellTypes[xls_CellType_ordinal]);
            SQL_SHORT,
              SQL_SHORT_,
              SQL_LONG,
              SQL_LONG_: Options.add(FieldName + '=' + xls_CellTypes[xls_CellType_double]);
            SQL_VARYING,
              SQL_VARYING_,
              SQL_TEXT,
              SQL_TEXT_: Options.add(FieldName + '=' + xls_CellTypes[xls_CellType_String]);
            SQL_BLOB,
              SQL_BLOB_: Options.add(FieldName + '=' + xls_CellTypes[xls_CellType_Auto]);
            SQL_TIMESTAMP,
              SQL_TIMESTAMP_: Options.add(FieldName + '=' + xls_CellTypes[xls_CellType_DateTime]);
            SQL_TYPE_DATE,
              SQL_TYPE_DATE_: Options.add(FieldName + '=' + xls_CellTypes[xls_CellType_Date]);
          end;
        end;

      while not (eof) do
      begin

        //
        Subs := TStringList.create;
        Content.Add(Subs);

        InfoStr := '';
        for n := 0 to pred(FieldCount) do
          with Fields[n] do
          begin
            if not (IsNull) then
            begin
              case SQLType of
                SQL_DOUBLE,
                  SQL_DOUBLE_: Subs.add(format('%.2f', [AsDouble]));
                SQL_INT64,
                  SQL_INT64_: Subs.add(inttostr(AsInt64));

                SQL_SHORT,
                  SQL_SHORT_,
                  SQL_LONG,
                  SQL_LONG_: Subs.add(inttostr(AsInteger));

                SQL_VARYING,
                  SQL_VARYING_,
                  SQL_TEXT,
                  SQL_TEXT_: begin
                    DB_text := AsString;
                    ersetze(#13, '', DB_text);
                    ersetze(#10, '', DB_text);
                    ersetze('"', '''', DB_text);
                    ersetze(Seperator, ',', DB_text);
                    Subs.add(DB_text);
                  end;

                SQL_BLOB,
                  SQL_BLOB_: begin
                  // if SubType = isc_blob_text
                    DB_text := '';
                    AssignTo(DB_memo);
                    for m := 0 to pred(DB_memo.count) do
                      if (m = 0) then
                        DB_text := DB_memo[m]
                      else
                        DB_text := DB_text + '|' + DB_memo[m];

                    Subs.add(DB_text);
                  end;

                SQL_TIMESTAMP,
                  SQL_TIMESTAMP_: Subs.add(
                    long2date(DateTime2Long(AsDateTime)) + ' ' +
                    secondstostr(DateTime2seconds(AsDateTime)));

                SQL_TYPE_DATE,
                  SQL_TYPE_DATE_: Subs.add(long2date(DateTime2Long(AsDateTime)));
              else
                ShowMessage('SQLType ' + inttostr(SQLType) + ' unbekannt!');
                exit;
              end;
            end else
            begin
              Subs.add('');
            end;
          end;


        ApiNext;
      end;
    end;
    cABLAGE.free;
    DB_memo.free;
  end;

var
  n: integer;

begin
  Content := TList.create;
  Headers := TStringList.create;
  Options := TStringList.create;

  // Die bekannte 2D-Content-Struktur aufbauen
  CreateContent;

  //
  ExcelExport(FName, Content, Headers, Options);

  for n := 0 to pred(Content.count) do
    TStringList(Content[n]).free;
  Content.free;
  Headers.free;
  Options.free;
end;

procedure ExportTableAsXLS(TSql: TStrings; FName: string; Seperator: char = ';'); overload;
begin
  ExportTableAsXLS(HugeSingleLine(TSql), FName, Seperator);
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
        sql.add('select * from ' +
          TableName +
          ' where RID=' +
          inttostr(RID)
          );
        APiFirst;
        if eof then
          break;
        NewRID := gen_id(GeneratorName, 1);
      end;

      //
      with qDEST do
      begin
        sql.add('select * from ' + TableName + ' for insert');
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

            qDEST.FieldByName(_FieldName).assign(cSOURCE.FieldByName(_FieldName));

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

procedure e_x_sql(s: string);
var
  x: TIB_dsql;
begin
  x := TIB_dsql.create(nil);
  with x do
  begin
    sql.add(s);
    execute;
  end;
  x.free;
end;

function GEN_ID(genName: string; Step: integer = 0): integer;
var
  x: TIB_dsql;
begin
  x := TIB_dsql.create(nil);
  with x do
  begin
    result := GEN_ID(genName, Step);
  end;
  x.free;
end;

{ TSQLMENGE }

procedure TIB_Club.add(i: integer);
begin
  if not (assigned(items)) then
    items := TIntegerList.create;
  items.add(i);
end;

procedure TIB_Club.add(i: TIntegerList);
begin
  if not (assigned(items)) then
    items := TIntegerList.create;
  items.addIntegers(i);
end;

constructor TIB_Club.create;
begin
  //
  RefTable := pRefTable;
end;

destructor TIB_Club.Destroy;
begin
  if assigned(items) then
    FreeAndNil(items);
  DropTable(TableName);
  inherited;
end;

function TIB_Club.sql(fromList: TIntegerList = nil): string;
var
  workL: TIntegerList;
  n: integer;
  qCLUB: TIB_Query;
begin
  result := '';

  //
  if assigned(items) and assigned(fromList) then
    items.addIntegers(fromList);

  //
  if assigned(items) then
    workL := items
  else
    workL := fromList;

  //
  if not (assigned(workL)) then
    exit;

  ID := GEN_ID('GEN_CLUB', 1);

  // Tabelle neu anlegen
  e_x_sql('create table ' + TableName + ' (' +
    'RID DOM_REFERENCE NOT NULL)');

  e_x_sql('alter table ' + TableName +
    ' add constraint PK_' + TableName +
    ' primary key (RID)');

{
  e_x_sql('alter table ' + TableName +
    ' add constraint FK_' + TableName +
    ' foreign key (RID) ' +
    ' references ' + RefTable + '(RID)');
}

  qCLUB := TIB_Query.create(nil);
  with qCLUB do
  begin
    sql.ADD('select RID from ' + TableName + ' for insert');
    for n := 0 to pred(workL.count) do
    begin
      insert;
      Fields[0].AsInteger := workL[n];
      post;
    end;
  end;
  qCLUB.free;

  result := 'join ' + TableName + ' on (' + TableName + '.RID=' + refTable + '.RID) ';
end;

function TIB_Club.TableName: string;
begin
  result := 'CLUB$' + inttostr(ID);
end;

function e_r_fbClientVersion: string;
var
  TheModuleName: array[0..1023] of char;
  s: string;
begin
  // welcher Client wird verwendet
  GetModuleFileName(FGDS_Handle, TheModuleName, sizeof(TheModuleName));
  s := TheModuleName;
  result := s + ' ' + FileVersion(TheModuleName);
end;


end.

