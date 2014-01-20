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
{ The Original Code is CCR.XMPBrowserFrame.pas.                                        }
{                                                                                      }
{ The Initial Developer of the Original Code is Chris Rolliston. Portions created by   }
{ Chris Rolliston are Copyright (C) 2009 Chris Rolliston. All Rights Reserved.         }
{                                                                                      }
{**************************************************************************************}

unit XMPBrowserFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Tabs, CCR.Exif, CCR.Exif.JpegUtils, CCR.Exif.XMPUtils;

type
  TTabSet = class(Tabs.TTabSet) //work around a bug that is actually TPageControl's
  protected
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
  end;

  TOutputFrame = class(TFrame)
    TabSet: TTabSet;
    panProps: TPanel;
    TreeView: TTreeView;
    Splitter: TSplitter;
    memValue: TMemo;
    redRawXML: TRichEdit;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure TreeViewClick(Sender: TObject);
    procedure TabSetChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
  private
    FXMPPacket: TXMPPacket;
    procedure LoadPacket(Source: TCustomMemoryStream);
  protected
    procedure SetParent(AParent: TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadFromFile(const FileName: string);
  end;

implementation

uses StrUtils, Themes;

{$R *.dfm}

{ TTabSet }

procedure TTabSet.CMDialogChar(var Message: TCMDialogChar);
var
  Grandparent: TWinControl;
begin
  Grandparent := Parent.Parent;
  if not (Grandparent is TTabSheet) or (TTabSheet(Grandparent).PageControl.ActivePage = Grandparent) then
    inherited;
end;

{ TOutputFrame }

constructor TOutputFrame.Create(AOwner: TComponent);
begin
  inherited;
  TabSet.Tabs.Objects[0] := panProps;
  TabSet.Tabs.Objects[1] := redRawXML;
  FXMPPacket := TXMPPacket.Create;
end;

destructor TOutputFrame.Destroy;
begin
  FXMPPacket.Free;
  inherited;
end;

procedure TOutputFrame.LoadPacket(Source: TCustomMemoryStream);
  procedure LoadNodes(Parent: TTreeNode; const Properties: IXMPPropertyCollection);
  var
    Counter: Integer;
    Prop: TXMPProperty;
    S: string;
  begin
    Counter := 0;
    for Prop in Properties do //both TXMPSchema and TXMPProperty implement IXMPPropertyCollection
    begin
      Inc(Counter);
      if (Prop.ParentProperty = nil) or not (Prop.ParentProperty.Kind in [xpBagArray, xpSeqArray]) then
        S := Prop.Name
      else
        S := Format('<item %d>', [Counter]);
      LoadNodes(TreeView.Items.AddChildObject(Parent, S, Prop), Prop);
    end;
  end;
const
  KnownSchemaTitles: array[TXMPKnownSchemaKind] of string = (
    'Camera Raw', 'Dublin Core', 'Exif', 'Microsoft Photo',
    'PDF', 'Photoshop', 'TIFF', 'XMP Basic', 'XMP Basic Job Ticket', 'XMP Dynamic Media',
    'XMP Media Management', 'XMP Paged Text', 'XMP Rights');
  TabStops: array[0..0] of UINT = (8);
var
  Schema: TXMPSchema;
  S: string;
begin
  FXMPPacket.LoadFromStream(Source); //will raise an EInvalidXMPPacket exception if invalid
  SendMessage(redRawXML.Handle, EM_SETTABSTOPS, Length(TabStops), LPARAM(@TabStops));
  redRawXML.Text := FXMPPacket.RawXML;
  TreeView.Items.Add(nil, '''About'' attribute');
  for Schema in FXMPPacket do
  begin
    if Schema.Kind = xsUnknown then
      S := Schema.PreferredPrefix
    else
      S := KnownSchemaTitles[Schema.Kind];
    LoadNodes(TreeView.Items.AddObject(nil, S, Schema), Schema);
  end;
  TreeView.AlphaSort;
  if TreeView.Items.Count > 0 then
    TreeView.Items[0].Expand(False);
end;

procedure TOutputFrame.SetParent(AParent: TWinControl);
begin
  inherited;
  if AParent <> nil then
    if (AParent is TTabSheet) and ThemeServices.ThemesEnabled then
      TabSet.BackgroundColor := clWindow
    else
      TabSet.BackgroundColor := clBtnFace;
end;

procedure TOutputFrame.LoadFromFile(const FileName: string);
var
  Stream: TMemoryStream;
  Segment: IFoundJPEGSegment;
begin
  TreeView.Items.Clear;
  memValue.Clear;
  FXMPPacket.Clear;
  Stream := TMemoryStream.Create;
  try
    Stream.LoadFromFile(FileName);
    if MatchText(ExtractFileExt(FileName), ['.xmp', '.xml', '.txt']) then
      LoadPacket(Stream)
    else if StreamHasJpegHeader(Stream) then
    begin
      for Segment in JPEGHeader(Stream, [jmApp1]) do
        if StreamHasXMPSegmentHeader(Segment.Data, hcMovePositionOnSuccess) then
        begin
          LoadPacket(Segment.Data);
          Exit;
        end;
      MessageDlg('Image does not contain any XMP metadata', mtInformation, [mbOK], 0);
    end
    else
      raise EInvalidXMPPacket.CreateFmt('%s is neither a JPEG image nor an XMP ' +
        'sidecar file', [FileName]);
  finally
    Stream.Free;
  end;
end;

procedure TOutputFrame.TabSetChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
var
  NewPanel: TWinControl;
begin
  NewPanel := (TabSet.Tabs.Objects[NewTab] as TWinControl);
  NewPanel.Show;
  NewPanel.BringToFront;
  NewPanel.SetFocus;
  (TabSet.Tabs.Objects[TabSet.TabIndex] as TControl).Hide;
end;

procedure TOutputFrame.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  if TObject(Node.Data) is TXMPProperty then
    case TXMPProperty(Node.Data).Kind of
      xpAltArray: memValue.Text := '<alternative array property>';
      xpBagArray: memValue.Text := '<unordered array property>';
      xpSeqArray: memValue.Text := '<ordered array property>';
      xpStructure: memValue.Text := '<structure property>';
    else
      memValue.Text := TXMPProperty(Node.Data).ReadValue
    end
  else if Node.IsFirstNode then
    memValue.Text := FXMPPacket.AboutAttributeValue
  else
    memValue.Text := ''
end;

procedure TOutputFrame.TreeViewClick(Sender: TObject);
var
  Node: TTreeNode;
  Pos: TPoint;
begin
  Pos := TreeView.ScreenToClient(Mouse.CursorPos);
  Node := TreeView.GetNodeAt(Pos.X, Pos.Y);
  if (Node <> nil) and (Node = TreeView.Selected) and (TreeView.Items.Count > 1) and
     PtInRect(Node.DisplayRect(True), Pos) then
    Node.Expanded := not Node.Expanded;
end;

end.
