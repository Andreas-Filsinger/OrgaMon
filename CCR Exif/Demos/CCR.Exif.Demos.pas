{**************************************************************************************}
{                                                                                      }
{ CCR Exif - Delphi class library for reading and writing Exif metadata in JPEG files  }
{ Version 0.9.9 (2009-11-19)                                                           }
{                                                                                      }
{ The contents of this file are subject to the Mozilla Public License Version 1.1      }
{ (the "License"); you may not use this file except in compliance with the License.    }
{ You may obtain a copy of the License at http://www.mozilla.org/MPL/                  }
{                                                                                      }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT   }
{ WARRANTY OF ANY KIND, either express or implied. See the License for the specific    }
{ language governing rights and limitations under the License.                         }
{                                                                                      }
{ The Original Code is CCR.Exif.Demos.pas.                                             }
{                                                                                      }
{ The Initial Developer of the Original Code is Chris Rolliston. Portions created by   }
{ Chris Rolliston are Copyright (C) 2009 Chris Rolliston. All Rights Reserved.         }
{                                                                                      }
{**************************************************************************************}

unit CCR.Exif.Demos;

{ Small support unit for the demo programs. }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ExtDlgs{$IF CompilerVersion < 18.5}, XPMan{$IFEND};

type
  {$IF CompilerVersion < 18.5}
  TApplicationHelper = class helper for TApplication
  private
    procedure DummySetter(Value: Boolean);
  public
    property MainFormOnTaskbar: Boolean write DummySetter;
  end;
  {$IFEND}

  TForm = class(Forms.TForm)
  protected
    procedure WMSetIcon(var Message: TWMSetIcon); message WM_SETICON; //for VCL buglet
  public
    constructor Create(AOwner: TComponent); override; //update the font if running on Vista or greater
  end;

procedure NewInstanceOfEXE(const FileName: string);
procedure OpenExplorerAndSelectFile(const FileName: string);
function TestMode: Boolean;

implementation

uses
  ShellApi;

procedure OpenExplorerAndSelectFile(const FileName: string);
begin
  ShellExecute(Screen.ActiveForm.Handle, 'open', 'explorer.exe',
    PChar('/select,"' + FileName + '"'), nil, SW_SHOWNORMAL)
end;

procedure NewInstanceOfEXE(const FileName: string);
var
  Params: string;
begin
  if Pos(' ', FileName) > 0 then
    Params := '"' + FileName + '"'
  else
    Params := FileName;
  ShellExecute(0, nil, PChar(Application.ExeName), PChar(Params), PChar(GetCurrentDir),
    SW_SHOWNORMAL);
end;

var
  TestModeStatus: (tmDontKnow, tmNo, tmYes);

function TestMode: Boolean;
begin
  if TestModeStatus = tmDontKnow then
  begin
    if FileExists(ParamStr(2)) and FileExists(ParamStr(1)) then
      TestModeStatus := tmYes
    else
      TestModeStatus := tmNo;
  end;
  Result := (TestModeStatus = tmYes);
end;

{$IF CompilerVersion < 18.5}
procedure TApplicationHelper.DummySetter(Value: Boolean);
begin
end;
{$IFEND}

constructor TForm.Create(AOwner: TComponent);
begin
  inherited;
  ReportMemoryLeaksOnShutdown := True;
  if Win32MajorVersion >= 6 then //update the font if running on Vista or later
    with Font do
    begin
      Name := 'Segoe UI';
      Size := 9;
    end;
end;

procedure TForm.WMSetIcon(var Message: TWMSetIcon);
begin
  if not Application.Terminated then //The VCL pointlessly clears the icon when a form is
    inherited;                       //destroyed, producing an annoying visual effect on Vista.
end;

end.
