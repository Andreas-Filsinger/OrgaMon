{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2020  Andreas Filsinger
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
unit CareTakerClient;

interface

uses
  Classes;

type
  // Für die "Funktions Sicherstellung"
  tTestProc = procedure(Path: string) of object;
  tSelfTestProc = function: TStringList of object;

const
  cERRORText = 'ERROR:'; // never change!
  cWARNINGText = 'WARNING:'; // never change!
  cINFOText = 'INFO:'; // never change!
  cEXCEPTIONText = 'EXCEPTION:'; // never change!
  // Log-Files
  cLogExtension = '.log.txt';
  cOKText = 'OK!'; // never change!
  iWikiServer: string = '';
  ReportedErrorCount: integer = 0;
  reinInformativ = true;

function Int64asKeyStr(i: int64): AnsiString;
function KeyStrasInt64(s: AnsiString): int64;
function MachineID: string;
procedure MachineIDChanged;
function vhost(url: string): string;
function cHelpURL: string;
function ResolveServer(s: string): string;
function e_r_Kontext: string;
function ErrorFName(Namespace: string; only4yi: boolean = false):string;

implementation

uses
  sysutils,

  // tools
  anfix, SimplePassword,

  // Indy
  IdHttp;

const
  _TrueServerName: string = '';
  _MachineID: string = '';

function MachineID: string;
begin
  if (_MachineID = '') then
    _MachineID :=
     {} UserName + '@' +
     {} 'de_DE' + '.' +
     {} ComputerName + '.' +
     {} MandantName;
  result := _MachineID;
end;

procedure MachineIDChanged;
begin
  _MachineID := '';
end;

function ResolveServer(s: string): string;
var
  hPROXY: TIdHTTP;
begin
  try
    hPROXY := TIdHTTP.create(nil);
    _TrueServerName :=
      StrFilter(ExtractSegmentBetween(hPROXY.get(s + '?p=' +
      FindANewPassword('', 15)), '<BODY>', '</BODY>', true), '.0123456789');
    result := _TrueServerName;
    hPROXY.free;
  except
    result := '';
  end;
end;

function vhost(url: string): string;
var
  hCARETAKER: TIdHTTP;
  RawResult: string;
begin
  try
    hCARETAKER := TIdHTTP.create(nil);
    RawResult := ExtractSegmentBetween(hCARETAKER.get(url), '<BODY>',
      '</BODY>', true);
    hCARETAKER.free;
    result := StrFilter(RawResult, '0123456789.', false);
  except
    result := '';
  end;
end;

function cHelpURL: string;
begin
  if (iWikiServer <> '') then
  begin
    result := iWikiServer + '?title='
  end
  else
  begin
    result := 'https://wiki.orgamon.org/?title=';
  end;
end;

function Int64asKeyStr(i: int64): AnsiString;
var
  L, n: integer;
begin
  SetLength(result, 8);
  L := sizeof(i);
  for n := 1 to L do
  begin
    result[n] := AnsiChar(i AND 255);
    i := i shr 8;
  end;
end;

function KeyStrasInt64(s: AnsiString): int64;
var
  L: integer;
begin
  result := 0;
  if (length(s) <> 8) then
    raise Exception.create
      ('KeyStr as a base of int64 must have the length of 8 Bytes');
  for L := 8 downto 1 do
  begin
    result := result shl 8;
    result := result + ord(s[L]);
  end;
end;

function getQuestion(Path: string): TStringList;
begin
  result := TStringList.create;
end;

procedure setAnswer(sAnswer: TStringList);
begin

end;

const
  _Kontext: string = '';

function e_r_Kontext: string;
begin
  if (_Kontext = '') then
    _Kontext := FindANewPassword;
  result := _Kontext;
end;

function ErrorFName(Namespace: string; only4yi: boolean = false):string;
begin
  result :=
   { } DebugLogPath +
   { } NameSpace + '-' +
   { } DatumLog + '-' +
   { } e_r_Kontext + '-' +
   { } 'ERROR'+
   {} cLogExtension;
  if not(only4yi) then
   inc(ReportedErrorCount);
end;


end.

