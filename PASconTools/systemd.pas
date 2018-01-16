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
  |    http://orgamon.org/
  |
}
unit systemd;

{$ifdef FPC}
{$mode objfpc}{$H+}
{$endif}

// #
// # OS - Wrapper
// #
// # win32: Aufruf externer Anwendungen
// # linux: rudimentäres libsystemd API um "ordentliche" Services schreiben zu können
// #

interface

// Tools
function CallExternalApp(Cmd: string; const CmdShow: Integer): Cardinal;
function RunExternalApp(Cmd: string; const CmdShow: Integer): boolean;

const
   SD_LISTEN_FDS_START = 3;

// systemd
function sd_notify(h:Integer; s:string) : Integer;
function sd_listen_fds(h:Integer) : Integer;

implementation

uses
 anfix32,
 {$ifndef FPC}
 JclMiscel,
 {$endif}
 SysUtils;

function CallExternalApp(Cmd: string; const CmdShow: Integer): Cardinal;
begin
 if DebugMode then
   AppendStringsToFile(Cmd, DebugLogPath + 'SYSTEMD-' + inttostr(DateGet) + '.log.txt', Uhr8);
 {$ifdef FPC}
 {$else}
 result := JclMiscel.WinExec32AndWait(Cmd,CmdShow);
 {$endif}
 if DebugMode then
   AppendStringsToFile(IntToStr(result), DebugLogPath + 'SYSTEMD-' + inttostr(DateGet) + '.log.txt', Uhr8);
end;

function RunExternalApp(Cmd: string; const CmdShow: Integer): boolean;
begin
 if DebugMode then
   AppendStringsToFile(Cmd, DebugLogPath + 'SYSTEMD-' + inttostr(DateGet) + '.log.txt', Uhr8);
 {$ifdef FPC}
 {$else}
 result := JclMiscel.WinExec32(Cmd,CmdShow);
 {$endif}
 if DebugMode then
   AppendStringsToFile(BoolToStr(result), DebugLogPath + 'SYSTEMD-' + inttostr(DateGet) + '.log.txt', Uhr8);
end;

function sd_notify(h: Integer; s: string): Integer;
// sample:     sd_notify( 0, "RELOADING=1\nSTATUS=50% done\n" );
// sample
begin
 result := -1;
end;

function sd_listen_fds(h: Integer): Integer;
begin
 result := -1;

end;

end.
