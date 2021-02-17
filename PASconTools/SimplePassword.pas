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
unit SimplePassword;

interface

// pwd
function FindANewPassword(const OldPasswordsFName: string='';pwdlength:integer=9): string;
procedure SavePassword(const FName, pwd, comment: string);

// serial number
function FindANewSerialNumber(const OldNumberFName: string): string;
procedure SaveSerial(const FName, serialNo: string);

implementation

uses
  classes, sysutils, anfix;

const
   // this is a "support" secure pwd char set, 32 Chars long (2 Chars = 1024 PWDS)
   // no 0=O (Zero and Oh)
   // no i,j,L
   // only upper chars, so the user can make upper or lower chars
   // no special chars that can not typed in in every country
   // it is a problem, if hackers know this set - crack the pwd is easier
   // increase the length of key, to avoid this, one Char ~ 5 Bit,
   // to have a 256 Bit Password, you need a length of 52 Chars!
   //
   PwdCharSet: string = '123456789ABCDEFGHJKMNPQRSTUVWXYZ';

function FindANewPassword(const OldPasswordsFName: string='';pwdlength:integer=9): string;
var
  OldPwds: TStringList;
  TryPwd: string;
  i: integer;
  WasFound: boolean;

  function NewPassword: string;
  var
    pwd: string;
    l, n: byte;
  begin
    pwd := '';
    l := length(PwdCharSet);
    for n := 1 to pwdlength do
      pwd := pwd + PwdCharSet[succ(random(l))];
    result := pwd;
  end;

begin
  while true do
  begin
    TryPwd := NewPassword;
    if (OldPasswordsFName<>'') and FileExists(OldPasswordsFName) then
    begin
      OldPwds := TStringList.create;
      OldPwds.LoadFromFile(OldPasswordsFName);
      WasFound := false;
      for i := 0 to pred(OldPwds.count) do
        if (pos(TryPwd, OldPwds[i]) = 1) then
        begin
          WasFound := true;
          break;
        end;
      OldPwds.free;
      if WasFound then
        continue;
      result := TryPwd;
      break;
    end else
    begin
      result := TryPwd;
      break;
    end;
  end;
end;

procedure SavePassword(const FName, pwd, comment: string);
var
  OutF: TextFile;
begin
  AssignFile(OutF, FName);
{$I-}
  append(OutF);
{$I+}
  if ioresult <> 0 then
    rewrite(OutF);
  writeln(OutF, pwd, ' ; ', datum, ' ; ', SecondsToStr8(SecondsGet), ' ; ', comment);
  close(OutF);
end;

function FindANewSerialNumber(const OldNumberFName: string): string;
var
  InpFile: TextFile;
  InpStr: string;
  Pre, Suf: integer;
  dummy: integer;
  PreStr, SufStr: string[4];
begin
  result := '0000-0000';
  if FileExists(OldNumberFName) then
  begin
    assignFile(InpFile, OldNumberFName);
    reset(InpFile);
    readln(InpFile, InpStr);
    close(InpFile);
    if (InpStr[5] <> '-') then
      exit;
    val(copy(InpStr, 1, 4), Pre, dummy);
    if (dummy <> 0) then
      exit;
    val(copy(InpStr, 6, 4), Suf, dummy);
    if (dummy <> 0) then
      exit;

  // increment!
    inc(suf);
    if suf > 9999 then
    begin
      inc(pre);
      suf := 0;
    end;

  // return
    str(Pre, PreStr);
    while length(PreStr) <> 4 do
      PreStr := '0' + PreStr;
    str(Suf, SufStr);
    while length(SufStr) <> 4 do
      SufStr := '0' + SufStr;

    result := PreStr + '-' + SufStr;
  end;
end;

procedure SaveSerial(const FName, serialNo: string);
var
  OutF: TextFile;
begin
  AssignFile(OutF, Fname);
  rewrite(OutF);
  writeln(OutF, serialNo);
  close(OutF);
end;

initialization
  StartDebug('SimplePassword');
  randomize;
end.
