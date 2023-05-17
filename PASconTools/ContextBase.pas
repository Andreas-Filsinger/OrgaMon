{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2018  Andreas Filsinger
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
unit ContextBase;

interface

uses
  gplists;

type
  TContext = class(TgpIntegerList)
  private
    sFileName: string;
    iListSize: integer;
    iGID: Int64;
  public
    constructor Create(FName: string; ListSize: integer = 10);
    procedure Clear; virtual;
    procedure addContext(RID: integer);
    procedure delContext(RID: integer);

    function top: integer;
    property GID: Int64 read iGID;
  end;

  { TContext }

implementation

uses
  anfix, SysUtils, dbOrgaMon;

procedure TContext.addContext(RID: integer);
var
  k: integer;
begin
  repeat
    if (RID < cRID_FirstValid) then
      break;
    k := indexof(RID);
    if (k = 0) then
      break;
    if (k <> -1) then
      delete(k);
    insert(0, RID);
    if (count > iListSize) then
      delete(pred(count));
    inc(iGID);
    SaveToFile(sFileName);
  until true;
end;

procedure TContext.delContext(RID: integer);
var
  k: integer;
begin
  repeat
    if (RID <= 0) then
      break;
    k := indexof(RID);
    if (k = -1) then
      break;
    delete(k);
    inc(iGID);
    SaveToFile(sFileName);
  until true;
end;

procedure TContext.Clear;
begin
  repeat
    if (count = 0) then
      break;
    inherited;
    inc(iGID);
    SaveToFile(sFileName);
  until true;
end;

constructor TContext.Create(FName: string; ListSize: integer);
begin
  sFileName := FName + '.ContextList';
  iListSize := ListSize;
  inherited Create;
  if FileExists(sFileName) then
    LoadFromFile(sFileName);
end;

function TContext.top: integer;
begin
  if (count > 0) then
    result := items[0]
  else
    result := -1;
end;

end.
