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
{ The Original Code is XMPBrowserForm.pas.                                             }
{                                                                                      }
{ The Initial Developer of the Original Code is Chris Rolliston. Portions created by   }
{ Chris Rolliston are Copyright (C) 2009 Chris Rolliston. All Rights Reserved.         }
{                                                                                      }
{**************************************************************************************}

unit XMPBrowserForm;
{
  Not much to this one really. Note that according to both Adobe's XMP specification and
  Microsoft's XMP implementation, a schema's properties may be placed at various places
  in the XML structure. As presented by TXMPPacket, however, they are collated under the
  same Schema property.
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtDlgs,
  ActnList, StdCtrls, ExtCtrls, ComCtrls, Buttons, CCR.Exif.Demos, CCR.Exif.XMPUtils,
  XMPBrowserFrame;

type
  TfrmXMPBrowser = class(TForm)
    panFooter: TPanel;
    dlgOpen: TOpenPictureDialog;
    btnOpen: TBitBtn;
    btnExit: TBitBtn;
    PageControl: TPageControl;
    tabOriginal: TTabSheet;
    tabResaved: TTabSheet;
    ActionList: TActionList;
    actOpen: TAction;
    procedure actOpenExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
  private
    FOriginalFrame, FResavedFrame: TOutputFrame;
    procedure DoOpen(const FileName1: string; const FileName2: string = '');
  protected
    procedure WMDropFiles(var Message: TWMDropFiles); message WM_DROPFILES;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
  end;

var
  frmXMPBrowser: TfrmXMPBrowser;

implementation

uses ShellApi, StrUtils, CCR.Exif, CCR.Exif.JpegUtils;

{$R *.dfm}

procedure TfrmXMPBrowser.FormCreate(Sender: TObject);
begin
  Application.Title := Caption;
  PageControl.Visible := TestMode;
  FOriginalFrame := TOutputFrame.Create(Self);
  FOriginalFrame.Align := alClient;
  FOriginalFrame.Name := '';
  if not TestMode then
  begin
    FOriginalFrame.Parent := Self;
    panFooter.Height := panFooter.Height - btnOpen.Top;
    btnOpen.Top := 0;
    btnExit.Top := 0;
  end
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

procedure TfrmXMPBrowser.WMTimer(var Message: TWMTimer);
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

procedure TfrmXMPBrowser.DoOpen(const FileName1: string; const FileName2: string = '');
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

procedure TfrmXMPBrowser.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmXMPBrowser.actOpenExecute(Sender: TObject);
begin
  if dlgOpen.Execute then DoOpen(dlgOpen.FileName);
end;

procedure TfrmXMPBrowser.WMDropFiles(var Message: TWMDropFiles);
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

end.
