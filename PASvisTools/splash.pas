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
unit splash;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls,
  StdCtrls;

type
  TFormSplashScreen = class(TForm)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    _SplashActive: boolean;
    _SplashNeverShow: boolean;
    MySymbol: TBitMap;
    procedure WMEraseBkgnd(var m: TWMEraseBkgnd); message WM_ERASEBKGND;
  public
    function SplashActive: boolean;
    procedure Write(SplashText: string);
    procedure close;
  end;

var
  FormSplashScreen: TFormSplashScreen;

procedure SplashWrite(X: string);
procedure SplashClose;

implementation

{$R *.DFM}

uses
  anfix32,
  globals; // every project must have a unit "globals"
// with
//
// const
// NoSplash       = false;
// LanguageDriver = '';
//

var
  SplashScreen: TFormSplashScreen = nil;

procedure TFormSplashScreen.WMEraseBkgnd(var m: TWMEraseBkgnd); // WM_EraseBack
begin
  m.Result := LRESULT(false);
end;

procedure TFormSplashScreen.Write(SplashText: string);
begin
  if assigned(self) then
  begin
    if _SplashNeverShow then
      exit;
    if not(visible) then
      show;
    with Label1 do
    begin
      caption := SplashText;
      left := self.Width div 2 - (Width div 2);
      top := self.height div 2;
      application.processmessages;
    end;
  end;
end;

procedure TFormSplashScreen.close;
begin
  if assigned(self) then
    if _SplashActive then
    begin
      _SplashActive := false;
      screen.cursor := crDefault;
      inherited close;
      FreeAndNil(SplashScreen);
    end;
end;

procedure TFormSplashScreen.FormCreate(Sender: TObject);
var
  FName: string;

  function CheckIt(TestFileName: string): boolean;
  begin
    Result := FileExists(TestFileName);
    if Result then
      FName := TestFileName;
  end;

begin
  FName := '';
  repeat
    // erst die Landesversionen prüfen

    // im Netz?
    if CheckIt(ValidatePathName(MyProgramPath) + '\system\StartUp' +
      LanguageDriver + '.bmp') then
      break;
    // lokal?
    if CheckIt(ExtractFilePath(application.exename) + 'system\StartUp' +
      LanguageDriver + '.bmp') then
      break;

    // nun die Internationale Version

    // im Netz?
    if CheckIt(ValidatePathName(MyProgramPath) + '\system\StartUp.bmp') then
      break;

    // lokal?
    if CheckIt(ExtractFilePath(application.exename) +
      '\system\StartUp.bmp') then
      break;

    if CheckIt(ExtractFilePath(application.exename) +
      '\system\Splash.bmp') then
      break;

  until true;

  if (FName <> '') then
  begin
    MySymbol := TBitMap.create;
    MySymbol.LoadFromFile(FName);
    Width := MySymbol.Width + 2;
    height := MySymbol.height + 2;
    top := (screen.height div 2) - (height div 2);
    left := (screen.Width div 2) - (Width div 2);
    // top     := 0;
    // left    := 0;
  end;
end;

procedure TFormSplashScreen.FormPaint(Sender: TObject);
begin
  if assigned(MySymbol) then
  begin
    with canvas do
    begin
      draw(1, 1, MySymbol);
      brush.color := clwhite;
      FrameRect(rect(0, 0, Width, height));
      cursor := crHourGlass;
      screen.cursor := crHourGlass;
    end;
    application.processmessages;
  end;
end;

procedure TFormSplashScreen.FormShow(Sender: TObject);
begin
  _SplashActive := true;
end;

function TFormSplashScreen.SplashActive: boolean;
begin
  if assigned(self) then
    Result := _SplashActive
  else
    Result := false;
end;

procedure TFormSplashScreen.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  close;
end;

procedure SplashWrite(X: string);
begin
  if assigned(SplashScreen) then
    if SplashScreen.SplashActive then
      SplashScreen.Write(X);
end;

procedure SplashClose;
begin
  if assigned(SplashScreen) then
    SplashScreen.close;
end;

initialization

if not(nosplash) then
begin
  SplashScreen := TFormSplashScreen.create(application);
  with SplashScreen do
  begin
    _SplashNeverShow := (paramstr(1) = 'nosplash');
    if not(_SplashNeverShow) then
    begin
      SplashScreen.show;
      application.initialize;
      SplashScreen.Update;
    end;
  end;
end;

finalization

end.
