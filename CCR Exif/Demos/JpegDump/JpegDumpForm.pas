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
{ The Original Code is JpegDumpForm.pas.                                               }
{                                                                                      }
{ The Initial Developer of the Original Code is Chris Rolliston. Portions created by   }
{ Chris Rolliston are Copyright (C) 2009 Chris Rolliston. All Rights Reserved.         }
{                                                                                      }
{**************************************************************************************}

unit JpegDumpForm;
{
  Demonstrates using the JPEGHeader enumerator function of CCR.Exif.JPEGUtils to parse a
  JPEG file's header (note that unlike the Exif List demo, any Exif data found by this
  one are presented 'raw') - please see JpegDumpOutputFrame.pas for the actual parsing
  code. While the implementation of JPEGHeader may look a bit funky if you're unused to
  the details of Delphi's for/in loop support, its use should appear (and is!)
  straightforward.
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtDlgs,
  Buttons, StdCtrls, ExtCtrls, ComCtrls, ActnList, StdActns,
  CCR.Exif.Demos, JpegDumpOutputFrame;


type
  TfrmJpegDump = class(TForm)
    panBtns: TPanel;
    btnOpen: TBitBtn;
    btnExit: TBitBtn;
    dlgOpen: TOpenPictureDialog;
    ActionList: TActionList;
    EditSelectAll1: TEditSelectAll;
    PageControl: TPageControl;
    tabOriginal: TTabSheet;
    tabResaved: TTabSheet;
    actOpen: TAction;
    dlgSave: TSavePictureDialog;
    procedure btnExitClick(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FOriginalFrame, FResavedFrame: TOutputFrame;
    procedure DoOpen(const FileName1: string; const FileName2: string = '');
  protected
    procedure WMDropFiles(var Message: TWMDropFiles); message WM_DROPFILES;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
  end;

var
  frmJpegDump: TfrmJpegDump;

implementation

uses ShellApi, CCR.Exif;

{$R *.dfm}

procedure TfrmJpegDump.FormCreate(Sender: TObject);
begin
  Application.Title := Caption;
  PageControl.Visible := TestMode;
  FOriginalFrame := TOutputFrame.Create(Self);
  FOriginalFrame.Align := alClient;
  FOriginalFrame.Name := '';
  if not TestMode then
    FOriginalFrame.Parent := Self
  else
  begin
    actOpen.Enabled := False;
    actOpen.Visible := False;
    ActiveControl := PageControl;
    FOriginalFrame.Parent := tabOriginal;
    FResavedFrame := TOutputFrame.Create(Self);
    FResavedFrame.Align := alClient;
    FResavedFrame.Parent := tabResaved;
  end;
  SetTimer(Handle, 1, 10, nil);
end;

procedure TfrmJpegDump.WMTimer(var Message: TWMTimer);
var
  S: string;
begin
  KillTimer(Handle, Message.TimerID);
  if TestMode then
    DoOpen(ParamStr(1), ParamStr(2))
  else
  begin
    S := ParamStr(1);
    if (S <> '') and not (S[1] in SwitchChars) then
      DoOpen(S);
    DragAcceptFiles(Handle, True);
  end;
end;

procedure TfrmJpegDump.WMDropFiles(var Message: TWMDropFiles);
var
  I: Integer;
  Buffer: array[0..MAX_PATH] of Char;
  FileName: string;
begin
  for I := 0 to DragQueryFile(HDROP(Message.Drop), $FFFFFFFF, nil, 0) - 1 do
  begin
    SetString(FileName, Buffer, DragQueryFile(HDROP(Message.Drop), I, Buffer,
      Length(Buffer)));
    if I = 0 then
      DoOpen(FileName)
    else
      NewInstanceOfEXE(FileName)
  end;
  DragFinish(HDROP(Message.Drop));
end;

procedure TfrmJpegDump.actOpenExecute(Sender: TObject);
begin
  if dlgOpen.Execute then DoOpen(dlgOpen.FileName);
end;

procedure TfrmJpegDump.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmJpegDump.DoOpen(const FileName1: string; const FileName2: string = '');
begin
  Screen.Cursor := crHourGlass;
  try
    Caption := ExtractFileName(FileName1) + ' - ' + Application.Title;
    FOriginalFrame.LoadFromFile(FileName1);
    if TestMode then
    begin
      FResavedFrame.LoadFromFile(FileName2);
      tabOriginal.Caption := ExtractFileName(FileName1);
      tabResaved.Caption := ExtractFileName(FileName2);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

end.
