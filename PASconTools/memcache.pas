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

{$ifdef fpc}
{$mode delphi}
{$endif}

(*

*===============================*
* memcached Delphi Client       *
* www.memcache.org              *
*===============================*

Rev 1.001 (19.11.14) Andreas Filsinger

 Neu: Funktion "open"

Rev 1.000 (18.11.14) Andreas Filsinger

 Neu: initiale Version mit den Funktionen: read, write, exist, inc, version

*)

interface

uses
  Classes, Sysutils,

  // Tools
  anfix,

  // Indy
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient;

const
 Version: single = 1.001;
 MC_STORED = 'STORED';
 MC_NOTFOUND = 'NOT_FOUND';
 MC_FOUND = 'FOUND';
 MC_END = 'END';
 MC_VALUE = 'VALUE';

type
  TmemcacheClient = class(TIdTCPClient)
  private
    function cmd(command: string): string;

  public
    LastError: string;

    // Admin Functions
    function version: string;
    procedure open(host:string); // Host [ ":" Port ]

    // Read Functions
    function read(Key: string): string;
    function exist(Key: string): boolean;

    // Write Functions
    procedure write(Key, Value: string);
    function inc(Key: string): int64;

    // Delete Funktions
    procedure delete(Key: string);
    procedure purge;

  end;

implementation


function TmemcacheClient.cmd(command: string): string;
begin
  with IOHandler do
  begin
    InputBuffer.Clear;
    {$ifdef fpc}
    writeln(command);
    result := ReadLn(#13#10);
    {$else}
    {$ifdef VER310}
    writeln(command);
    result := ReadLn(#13#10);
    {$else}
    writeln(command, TEnCoding.ASCII);
    result := ReadLn(#13#10, TEnCoding.ASCII);
    {$endif}
    {$endif}
  end;
end;

procedure TmemcacheClient.delete(Key: string);
begin
  LastError := cmd('delete ' + Key);
end;

function TmemcacheClient.exist(Key: string): boolean;
begin
  read(Key);
  result := (LastError <> MC_NOTFOUND);
  if result then
    LastError := MC_FOUND;
end;

function TmemcacheClient.inc(Key: string): int64;
var
  s: string;
begin
  s := cmd('incr ' + Key + ' 1');
  result := StrToIntDef(s, -1);
  if (result = -1) then
  begin
    if (s = MC_NOTFOUND) then
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

procedure TmemcacheClient.open(host: string);
begin
    ConnectTimeout := 2000;
    ReadTimeout := 500;
    self.Host := nextp(host, ':', 0);
    Port := StrToIntDef(nextp(host, ':', 1), 11211);
    connect;
end;

procedure TmemcacheClient.purge;
begin
 cmd('flush_all');
end;

function TmemcacheClient.read(Key: string): string;
begin
  result := cmd('get ' + Key);
  repeat
    if (result = MC_END) then
    begin
      result := '';
      LastError := MC_NOTFOUND;
      break;
    end;
    if (pos(MC_VALUE + ' ' + Key, result) = 1) then
    begin
      {$ifdef fpc}
      result := IOHandler.ReadLn(#13#10);
      LastError := IOHandler.ReadLn(#13#10);
      {$else}
      {$ifdef VER310}
      result := IOHandler.ReadLn(#13#10);
      LastError := IOHandler.ReadLn(#13#10);
      {$else}
      result := IOHandler.ReadLn(#13#10, TEnCoding.ASCII);
      LastError := IOHandler.ReadLn(#13#10, TEnCoding.ASCII);
      {$endif}
      {$endif}
    end;
  until yet;
end;

function TmemcacheClient.version: string;
begin
  result := cmd('version');
end;

procedure TmemcacheClient.write(Key, Value: string);
begin
  {$ifdef fpc}
  IOHandler.writeln('set ' + Key + ' 0 0 ' + IntToStr(length(Value)));
  {$else}
  {$ifdef VER310}
  IOHandler.writeln('set ' + Key + ' 0 0 ' + IntToStr(length(Value)));
  {$else}
  IOHandler.writeln('set ' + Key + ' 0 0 ' + IntToStr(length(Value)),
    TEnCoding.ASCII);
  {$endif}
  {$endif}
  LastError := cmd(Value);
end;

end.
