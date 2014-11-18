{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2014  Andreas Filsinger
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
unit memcache;

(*

*===============================*
* memchached Client             *
* www.memcache.org              *
*===============================*

Rev 1.000 (18.11.14) Andreas Filsinger

 Neu: initiale Version mit den Funktionen: read, write, exist, inc, version

*)

interface

uses
  Classes, Sysutils,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient;


const
 MC_STORED = 'STORED';
 MC_NOTFOUND = 'NOT_FOUND';
 MC_FOUND = 'FOUND';


type
  TmemcacheClient = class(TIdTCPClient)
  private
    function cmd(command: string): string;

  public
    LastError: string;

    // Admin Functions
    function version: string;

    // Read Functions
    function read(Key: string): string;
    function exist(Key: string): boolean;

    // Write Functions
    procedure write(Key, Value: string);
    procedure delete(Key: string);
    function inc(Key: string): int64;

  end;

implementation


function TmemcacheClient.cmd(command: string): string;
begin
  with IOHandler do
  begin
    InputBuffer.Clear;
    writeln(command, TEnCoding.ASCII);
    result := ReadLn(#13#10, TEnCoding.ASCII);
  end;
end;

procedure TmemcacheClient.delete(Key: string);
begin
  LastError := cmd('delete ' + Key);
end;

function TmemcacheClient.exist(Key: string): boolean;
begin
  read(Key);
  result := (LastError <> 'NOT_FOUND');
  if result then
    LastError := 'FOUND';
end;

function TmemcacheClient.inc(Key: string): int64;
var
  s: string;
begin
  s := cmd('incr ' + Key + ' 1');
  result := StrToIntDef(s, -1);
  if (result = -1) then
  begin
    if (s = 'NOT_FOUND') then
    begin
      write(Key, '1');
      result := 1;
    end
    else
      LastError := s;
  end
  else
  begin
    LastError := MC_STORED;
  end;
end;

function TmemcacheClient.read(Key: string): string;
begin
  result := cmd('get ' + Key);
  repeat
    if (result = 'END') then
    begin
      result := '';
      LastError := 'NOT_FOUND';
      break;
    end;
    if pos('VALUE ' + Key, result) = 1 then
    begin
      result := IOHandler.ReadLn(#13#10, TEnCoding.ASCII);
      LastError := IOHandler.ReadLn(#13#10, TEnCoding.ASCII);
    end;
  until true;
end;

function TmemcacheClient.version: string;
begin
  result := cmd('version');
end;

procedure TmemcacheClient.write(Key, Value: string);
begin
  IOHandler.writeln('set ' + Key + ' 0 0 ' + IntTOStr(length(Value)),
    TEnCoding.ASCII);
  LastError := cmd(Value);
end;

end.
