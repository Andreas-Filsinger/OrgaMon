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
unit CareTakerClient;

interface

uses
  Classes;

type
  TTroubleTicket = integer; // \rev\TCareTaker.rev

  // Für die "Funktions Sicherstellung"
  //
  tTestProc = procedure(Path: string) of object;
  tSelfTestProc = function: TStringList of object;

const
  cCareTakerKey: string = 'PNE-32bit-STUB-VxD'; // Key! do not change
  cCareTakerDiagnosePath: string = '';
  cERRORText = 'ERROR:'; // never change!
  cWARNINGText = 'WARNING:'; // never change!
  cINFOText = 'INFO:'; // never change!
  cEXCEPTIONText = 'EXCEPTION:'; // never change!
  cOKText = 'OK!'; // never change!
  cCareTakerLogFName = 'CareTaker.log.txt';
  iWikiServer: string = '';
  iWikiServer2: string = '';
  iCareTakerOffline: boolean = false;

function CareTakerLog(s: string; Nachmeldungen: boolean = true): TTroubleTicket;
procedure CareTakerClose(Ticket: TTroubleTicket);
function deCrypt(s: string): string;
function Int64asKeyStr(i: int64): AnsiString;
function KeyStrasInt64(s: AnsiString): int64;
function MachineID: string;
function CareTakerFName: string;
procedure Nachmeldungen;
procedure MachineIDChanged;
function vhost(url: string): string;
function cHelpURL: string;
function cTixURL: string;
function ResolveServer(s: string): string;

// Funktions Sicherstellung
function getQuestion(Path: string): TStringList;
procedure setAnswer(sAnswer: TStringList);

implementation

uses
  // system
  math, sysutils,

{$IFNDEF CONSOLE}
  Jvgnugettext,
{$ENDIF}
  // anfix
  gplists, anfix32, html,
  SimplePassword,

  // Indy
  IdHttp,

  // aus DCP
  DCPcrypt2, DCPblockciphers, DCPblowfish;

const
  _TrueServerName: string = '';
  _MachineID: string = '';
  CareTakerDiagnosePathChecked: string = '';

function MachineID: string;
begin
  if (_MachineID = '') then
    _MachineID := UserName + '@' +
{$IFDEF CONSOLE}
      'de_DE' + '.' +
{$ELSE}
      GetCurrentLanguage + '.' +
{$ENDIF}
      ComputerName + '.' + MandantName;
  result := _MachineID;
end;

procedure MachineIDChanged;
begin
  _MachineID := '';
end;

function enCrypt(s: string): string;
var
  cBLOWFISH: TDCP_blowfish;
  CryptKey: array [0 .. 1023] of AnsiChar;
begin
  cBLOWFISH := TDCP_blowfish.create(nil);
  with cBLOWFISH do
  begin
    StrPCopy(CryptKey, cCareTakerKey);
    Init(CryptKey, length(cCareTakerKey) * 8, nil);
    result := encryptstring(s);
  end;
  cBLOWFISH.free;
end;

function deCrypt(s: string): string;
var
  cBLOWFISH: TDCP_blowfish;
  CryptKey: array [0 .. 1023] of AnsiChar;
begin
  cBLOWFISH := TDCP_blowfish.create(nil);
  with cBLOWFISH do
  begin
    StrPCopy(CryptKey, cCareTakerKey);
    Init(CryptKey, length(cCareTakerKey) * 8, nil);
    result := decryptstring(s);
  end;
  cBLOWFISH.free;
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

procedure CheckCreateDiagnosePath;
begin
  if (cCareTakerDiagnosePath = '') then
  begin
    // nimm den Anwendungspfad - der braucht nicht überprüft werden
    cCareTakerDiagnosePath := ExtractFilePath(ParamStr(0));
    CareTakerDiagnosePathChecked := cCareTakerDiagnosePath;
  end
  else
  begin
    // nur prüfen, wenn nicht schon erfolgt!
    if (CareTakerDiagnosePathChecked <> cCareTakerDiagnosePath) then
    begin
      CheckCreateDir(cCareTakerDiagnosePath);
      CareTakerDiagnosePathChecked := cCareTakerDiagnosePath;
    end;
  end;
end;

function CareTakerLog(s: string; Nachmeldungen: boolean = true): TTroubleTicket;
var
  hCARETAKER: TIdHTTP;
  RawResult: string;
begin
  result := -1;
  s := MachineID + ': ' + s;
  if not(iCareTakerOffline) then
  begin
    try
      hCARETAKER := TIdHTTP.create(nil);
      RawResult := ExtractSegmentBetween
        (hCARETAKER.get('http://caretaker.orgamon.org/log.php?msg=' +
        AnsiTorfc1738(enCrypt(copy(s, 1, 240)))), '<BODY>', '</BODY>', true);
      hCARETAKER.free;
      result := strtointdef(StrFilter(RawResult, '0123456789', false), -1);
    except
    end;
  end;

  //
  // if log fail, write to file: Note the Moment of fail!
  //
  if Nachmeldungen then
    if (result = -1) then
      AppendStringsToFile(s + ' [' + long2date(DateGet) + ' ' +
        secondstostr(SecondsGet) + ']', CareTakerFName);
end;

procedure CareTakerClose(Ticket: TTroubleTicket);
begin
  CareTakerLog('Close Ticket ' + inttostr(Ticket));
end;

procedure Nachmeldungen;
var
  n: integer;
  LogS: TStringList;
  Nachgemeldete: TgpIntegerList;
begin
  if not(iCareTakerOffline) then
    if FileExists(CareTakerFName) then
    begin

      Nachgemeldete := TgpIntegerList.create;
      LogS := TStringList.create;
      LogS.LoadFromFile(CareTakerFName);

      // Melde nach, aber nur maximal 4
      for n := 0 to min(4, pred(LogS.count)) do
        if (CareTakerLog(LogS[n], false) > 0) then
          Nachgemeldete.add(n)
        else
          break;

      if (Nachgemeldete.count > 0) then
      begin
        for n := pred(Nachgemeldete.count) downto 0 do
          LogS.delete(Nachgemeldete[n]);
        if (LogS.count = 0) then
          FileDelete(CareTakerFName)
        else
          LogS.savetoFile(CareTakerFName);
      end;
      LogS.free;
    end;
end;

function CareTakerFName: string;
begin
  CheckCreateDiagnosePath;
  result := cCareTakerDiagnosePath + cCareTakerLogFName;
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
    result := iWikiServer + 'index.php5/'
  end
  else
  begin
    result := 'http://wiki.orgamon.org/index.php5/';
  end;
end;

function cTixURL: string;
begin
  result := iWikiServer2 + 'index.php5/';
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

end.
