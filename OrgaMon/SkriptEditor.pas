{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2011  Andreas Filsinger
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
unit SkriptEditor;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  SynEditHighlighter, SynHighlighterPas, StdCtrls,
  SynEdit, SynMemo, ToolWin,
  ComCtrls, ExtCtrls, ImgList,
  eConnect;

type
  TFormSkriptEditor = class(TForm)
    SynPasSyn1: TSynPasSyn;
    SynMemo1: TSynMemo;
    StatusBar1: TStatusBar;
    SynMemo2: TSynMemo;
    ToolBar1: TToolBar;
    Splitter1: TSplitter;
    ToolButton1: TToolButton;
    ImageList1: TImageList;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
  private
    { Private-Deklarationen }
    XMethods: TeConnect;

  public
    { Public-Deklarationen }
  end;

var
  FormSkriptEditor: TFormSkriptEditor;

implementation

{$R *.dfm}

procedure TFormSkriptEditor.ToolButton1Click(Sender: TObject);
var
  Source, ErrMsg: TStringList;
  n: integer;
begin
  if not(assigned(XMethods)) then
    XMethods := TeConnect.create;

  Source := TStringList.create;
  Source.Assign(SynMemo1.Lines);
  ErrMsg := XMethods.rpc_e_w_Skript(Source);

  for n := 0 to pred(ErrMsg.count) do
    SynMemo2.Lines.Add(ErrMsg[n]);
  ErrMsg.free;
end;

procedure TFormSkriptEditor.ToolButton4Click(Sender: TObject);
begin
 Synmemo2.clear;
end;

end.
