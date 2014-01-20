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
unit WinAmp;

interface

const
  VersionWinAmp: single = 1.008; // G:\rev\winamp.rev

var
  SoundCardInstalled: boolean;
  ShutWinampDown: boolean;
  AlwaysOnTopToggled: boolean;

procedure WinAmpPlay; // Starts playing the first song of the PlayList
procedure WinAmpNext;
procedure WinAmpVolumeDown;
procedure WinAmpVolumeUp;
procedure WinAmpFadeOut; // Fades out actual song an stops playing
procedure WinAmpPlayFile(const FName: string); // just plays this File!
procedure WinAmpShow;
procedure WinAmpHide;
procedure WinAmpSetFocus;
procedure WinAmpLoadUp;
function WinAmpPlaying: boolean;
function WinAmpRunning: boolean;
procedure WinAmpToggleAOT;

// manipulating the Play-List!
procedure WinAmpClearPlayList;
procedure WinAmpAddOneFile(const FName: string);

implementation

uses
  windows, registry, Messages,
  dialogs, anfix32, forms,
  inifiles, SysUtils;

const
  WM_WA_IPC = WM_USER;

  IPC_GETVERSION = 0;
  IPC_PLAYFILE = 100;
  IPC_DELETE = 101;
  IPC_STARTPLAY = 102;
  IPC_CHDIR = 103;
  IPC_ISPLAYING = 104;
  IPC_GETOUTPUTTIME = 105;
  IPC_JUMPTOTIME = 106;
  IPC_WRITEPLAYLIST = 120;

  WINAMP_OPTIONS_EQ = 40036;
  WINAMP_OPTIONS_PLEDIT = 40040;
  WINAMP_BUTTON1 = 40044; // prev
  WINAMP_BUTTON2 = 40045; // play
  WINAMP_BUTTON3 = 40046; // pause
  WINAMP_BUTTON4 = 40047; // stop
  WINAMP_BUTTON5 = 40048; // next
  WINAMP_VOLUMEUP = 40058;
  WINAMP_VOLUMEDOWN = 40059;
  WINAMP_FFWD5S = 40060;
  WINAMP_REW5S = 40061;
  WINAMP_BUTTON1_SHIFT = 40144; // rewind
  WINAMP_BUTTON2_SHIFT = 40145;
  WINAMP_BUTTON3_SHIFT = 40146;
  WINAMP_BUTTON4_SHIFT = 40147; // fade out
  WINAMP_BUTTON5_SHIFT = 40148;
  WINAMP_BUTTON1_CTRL = 40154;
  WINAMP_BUTTON2_CTRL = 40155;
  WINAMP_BUTTON3_CTRL = 40156;
  WINAMP_BUTTON4_CTRL = 40157; // fade out
  WINAMP_BUTTON5_CTRL = 40158;
  WINAMP_PREVSONG = 40198;
  WINAMP_FILE_PLAY = 40029;
  WINAMP_OPTIONS_PREFS = 40012;
  WINAMP_OPTIONS_AOT = 40019;
  WINAMP_HELP_ABOUT = 40041;

var
  hWnd_WinAmp: hWnd;

function WinAmpRunning: boolean;
begin
  hwnd_winamp := FindWindow('Winamp v1.x', nil);
  result := (hwnd_winamp <> 0);
end;

procedure WinAmpPlay;
begin
  if WinAmpRunning then
    PostMessage(hwnd_winamp, WM_COMMAND, WINAMP_BUTTON2, 0);
end;

procedure WinAmpNext;
begin
  if WinAmpRunning then
    PostMessage(hwnd_winamp, WM_COMMAND, WINAMP_BUTTON5, 0);
end;

procedure WinAmpVolumeDown;
begin
  if WinAmpRunning then
    PostMessage(hwnd_winamp, WM_COMMAND, WINAMP_VOLUMEDOWN, 0);
end;

procedure WinAmpVolumeUp;
begin
  if WinAmpRunning then
    PostMessage(hwnd_winamp, WM_COMMAND, WINAMP_VOLUMEUP, 0);
end;

procedure WinAmpFadeOut;
begin
  if WinAmpRunning then
    PostMessage(hwnd_winamp, WM_COMMAND, WINAMP_BUTTON4_SHIFT, 0);
end;

procedure WinAmpPlayFile(const FName: string); // plays this File!
begin
  if FileExists(FName) then
  begin
    if not (WinAmpRunning) then
      WinAmpLoadup;

    // Delete Play List
    SendMessage(hwnd_winamp, WM_USER, 0, IPC_DELETE);
    // insert Song
    WinAmpAddOneFile(FName);
    // play!
    SendMessage(hwnd_winamp, WM_COMMAND, WINAMP_BUTTON2, 0);
  end;
end;

procedure WinAmpClearPlayList;
begin
  if WinAmpRunning then
  begin
  // Delete Play List
    SendMessage(hwnd_winamp, WM_USER, 0, IPC_DELETE);
  end;
end;

procedure WinAmpAddOneFile(const FName: string);
var
  cds: COPYDATASTRUCT;
  _Fname: array[0..1023] of AnsiChar;
begin
  if WinAmpRunning then
  begin
    StrPCopy(_Fname,FName);

    cds.dwData := IPC_PLAYFILE;
    cds.lpData := @_FName;
    cds.cbData := Length(FName) + 1;
    SendMessage(hwnd_winamp, WM_COPYDATA, 0, integer(@cds));
  end;
end;

procedure WinAmpShow;
begin
  if WinAmpRunning then
  begin
  {
  ShowWindow(hwnd_winamp,SW_HIDE);     // dont no why, but it works only this way
  }

    ShowWindow(hwnd_winamp, SW_RESTORE);
    SetForeGroundWindow(Application.handle);
//  BringWindowToTop(hwnd_winamp);
  end;
end;

procedure WinAmpSetFocus;
begin
  if WinAmpRunning then
  begin
  {
  ShowWindow(hwnd_winamp,SW_HIDE);     // dont no why, but it works only this way
  }
//  ShowWindow(hwnd_winamp,SW_RESTORE);
    SetForeGroundWindow(hwnd_winamp);
//  BringWindowToTop(hwnd_winamp);
  end;
end;

procedure WinAmpLoadUp;
var
  AlwaysOnTop: boolean;
  ExecuteStr: array[0..1023] of AnsiChar;

  function GetAOTValue(FName: string): boolean;
  var
    MyIni: TINIFile;
  begin
    MyIni := TIniFile.create(FName);
    result := MyIni.ReadString('Winamp', 'aot', '0') = '1';
    MyIni.free;
  end;

  function ProgramFilesDir: string;
  var
    vRegistry: TRegistry;
  begin
    vRegistry := TRegistry.Create;
    with vRegistry do
    begin
      RootKey := HKEY_LOCAL_MACHINE;
      OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion', False);
      result := ReadString('ProgramFilesDir') + '\';
    end;
    vRegistry.Free;
  end;

begin
  if SoundCardInstalled then
  begin
    if FileExists(ProgramFilesDir + 'Winamp\winamp.exe') then
    begin
      AlwaysOnTop := GetAOTValue(PRogramFilesDir + 'Winamp\winamp.ini');
      if not (WinAmpRunning) then
      begin
        StrPCopy(ExecuteStr, PRogramFilesDir);
        StrCat(ExecuteStr, 'Winamp\winamp.exe');
        WinExec(ExecuteStr, SW_SHOWMINIMIZED);
      end;
      if WinAmpRunning then
        if not (AlwaysOnTop) then
        begin
          WinAmpToggleAOT;
          AlwaysOnTopToggled := true;
        end;
    end;
  end;
end;

function WinAmpPlaying: boolean;
begin
  if WinAmpRunning then
    result := (SendMessage(hwnd_winamp, WM_WA_IPC, 0, IPC_ISPLAYING) = 1)
  else
    result := false;
end;

procedure WinAmpToggleAOT;
begin
  SendMessage(hwnd_winamp, WM_COMMAND, WINAMP_OPTIONS_AOT, 0);
end;

procedure WinAmpHide;
begin
  if WinAmpRunning then
  begin
    ShowWindow(hwnd_winamp, SW_SHOWMINIMIZED);
    SetForeGroundWindow(Application.handle);
    application.processmessages;
  end;
end;

initialization
  SoundCardInstalled := not(IsParam('--s'));
  ShutWinampDown := not (WinAmpRunning);
  AlwaysOnTopToggled := false;
finalization
StartDebug('finalization-WinAmp-A');
  if SoundCardInstalled then
    if WinAmpRunning then
    begin
      if ShutWinampDown then
        PostMessage(hwnd_winamp, WM_Close, 0, 0)
      else
        if AlwaysOnTopToggled then
          WinAmpToggleAOT;
    end;
StartDebug('finalization-WinAmp-B');
end.

