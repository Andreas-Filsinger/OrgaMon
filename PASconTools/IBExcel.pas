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
unit IBExcel;

interface

uses
 Classes, ExcelHelper;

procedure ExportTableAsXLS(TSql: string; FName: string; Seperator: char = ';');
  overload;
procedure ExportTableAsXLS(TSql: TStrings; FName: string;
  Seperator: char = ';'); overload;


implementation

uses
 SysUtils,
 IB_Access,
 IB_Components,
   IB_Header,
  IB_Session,
  anfix,
  dbOrgaMon;

procedure ExportTableAsXLS(TSql: string; FName: string; Seperator: char = ';');
  overload;
var
  Content: TList;
  Headers: TStringList;
  Options: TStringList;

  procedure CreateContent;
  var
    cABLAGE: TdboCursor;
    Subs: TStringList;
    n, m: integer;
    Infostr: string;
    DB_text: string;
    DB_memo: TStringList;

  begin
    DB_memo := TStringList.create;
    cABLAGE := nCursor;
    with cABLAGE do
    begin
      sql.add(TSql);
      ApiFirst;

      // Kopfzeile
      for n := 0 to pred(FieldCount) do
        with Fields[n] do
        begin
          Headers.add(FieldName);
          case SQLType of
            SQL_DOUBLE, SQL_DOUBLE_:
              Options.add(FieldName + '=' + xls_CellTypes[xls_CellType_Money]);
            SQL_INT64, SQL_INT64_:
              Options.add(FieldName + '=' + xls_CellTypes[xls_CellType_ordinal]
                );
            SQL_SHORT, SQL_SHORT_, SQL_LONG, SQL_LONG_:
              Options.add(FieldName + '=' + xls_CellTypes[xls_CellType_double]);
            SQL_VARYING, SQL_VARYING_, SQL_TEXT, SQL_TEXT_:
              Options.add(FieldName + '=' + xls_CellTypes[xls_CellType_String]);
            SQL_BLOB, SQL_BLOB_:
              Options.add(FieldName + '=' + xls_CellTypes[xls_CellType_Auto]);
            SQL_TIMESTAMP, SQL_TIMESTAMP_:
              Options.add(FieldName + '=' + xls_CellTypes[xls_CellType_DateTime]
                );
            SQL_TYPE_DATE, SQL_TYPE_DATE_:
              Options.add(FieldName + '=' + xls_CellTypes[xls_CellType_Date]);
            SQL_TYPE_TIME, SQL_TYPE_TIME_:
              Options.add(FieldName + '=' + xls_CellTypes[xls_CellType_Time]);

          end;
        end;

      while not(eof) do
      begin

        //
        Subs := TStringList.create;
        Content.add(Subs);

        Infostr := '';
        for n := 0 to pred(FieldCount) do
          with Fields[n] do
          begin
            if not(IsNull) then
            begin
              case SQLType of
                SQL_DOUBLE, SQL_DOUBLE_:
                  Subs.add(format('%.2f', [AsDouble]));
                SQL_INT64, SQL_INT64_:
                  Subs.add(inttostr(AsInt64));

                SQL_SHORT, SQL_SHORT_, SQL_LONG, SQL_LONG_:
                  Subs.add(inttostr(AsInteger));

                SQL_VARYING, SQL_VARYING_, SQL_TEXT, SQL_TEXT_:
                  begin
                    DB_text := AsString;
                    ersetze(#13, '', DB_text);
                    ersetze(#10, '', DB_text);
                    ersetze('"', '''', DB_text);
                    ersetze(Seperator, ',', DB_text);
                    Subs.add(DB_text);
                  end;

                SQL_BLOB, SQL_BLOB_:
                  begin
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

                SQL_TIMESTAMP, SQL_TIMESTAMP_:
                  Subs.add(long2date(DateTime2Long(AsDateTime))
                      + ' ' + secondstostr(DateTime2seconds(AsDateTime)));

                SQL_TYPE_DATE, SQL_TYPE_DATE_:
                  Subs.add(long2date(DateTime2Long(AsDateTime)));
                SQL_TYPE_TIME, SQL_TYPE_TIME_:
                  Subs.add(secondstostr(DateTime2seconds(AsDateTime)));

              else
               raise Exception.Create('SQLType ' + inttostr(SQLType) + ' unbekannt!');
              end;
            end
            else
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

procedure ExportTableAsXLS(TSql: TStrings; FName: string;
  Seperator: char = ';'); overload;
begin
  ExportTableAsXLS(HugeSingleLine(TSql), FName, Seperator);
end;

end.
