(*
      ___                  __  __
     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
    | |_| | | | (_| | (_| | |  | | (_) | | | |
     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
               |___/

    Copyright (C) 2007  Andreas Filsinger

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    http://orgamon.org/

*)
unit PreAuftrag;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, CheckLst;

type
  TFormPreAuftrag = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckListBox1: TCheckListBox;
    CheckListBox2: TCheckListBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
    ListeInitialized: boolean;
    ExecuteResult: integer;
    PreFilled: boolean;
    procedure DoInitialize;
  public
    { Public-Deklarationen }
    function Execute: integer;
    function Medium: string;
    function Motivation: string;
    function DefaultMedium: string;
    function DefaultMotivation: string;
    procedure SetValues(Medium, Motivation: string);
    function RemoveCodes(s: string): string;
  end;

var
  FormPreAuftrag: TFormPreAuftrag;

implementation

uses
  anfix, globals;

{$R *.dfm}

{ TFormPreAuftrag }

function TFormPreAuftrag.Execute: integer;
var
  n: integer;
begin
  if not (PreFilled) then
  begin
    DoInitialize;
    with CheckListBox1 do
      for n := 0 to pred(Items.count) do
        checked[n] := (pos('!', items[n]) > 0);
    with CheckListBox2 do
      for n := 0 to pred(Items.count) do
        checked[n] := (pos('!', items[n]) > 0);
  end;
  PreFilled := false;
  showmodal;
  result := ExecuteResult;
end;

procedure TFormPreAuftrag.FormActivate(Sender: TObject);
begin
  DoInitialize;
end;

function TFormPreAuftrag.Medium: string;
var
  n: integer;
begin
  result := '';
  with CheckListbox1 do
    for n := 0 to pred(Items.count) do
      if Checked[n] then
        result := result + RemoveCodes(items[n]) + ',';
  if (length(result) > 0) then
    delete(result, length(result), 1);
end;

function TFormPreAuftrag.Motivation: string;
var
  n: integer;
begin
  result := '';
  with CheckListbox2 do
    for n := 0 to pred(Items.count) do
      if Checked[n] then
        result := result + RemoveCodes(items[n]) + ',';
  if (length(result) > 0) then
    delete(result, length(result), 1);
end;

procedure TFormPreAuftrag.Button1Click(Sender: TObject);
begin
  ExecuteResult := 1;
  close;
end;

procedure TFormPreAuftrag.Button2Click(Sender: TObject);
begin
  ExecuteResult := -1;
  close;
end;

procedure TFormPreAuftrag.SetValues(Medium, Motivation: string);
var
  n: integer;
begin
  DoInitialize;
  with Checklistbox1 do
    for n := 0 to pred(items.count) do
      checked[n] := (pos(RemoveCodes(items[n]), Medium) > 0);
  with Checklistbox2 do
    for n := 0 to pred(items.count) do
      checked[n] := (pos(RemoveCodes(items[n]), Motivation) > 0);
  PreFilled := true;
end;

procedure TFormPreAuftrag.DoInitialize;
begin
  if not (ListeInitialized) then
  begin
    while iAuftragsMedium <> '' do
      CheckListbox1.Items.add(nextp(iAuftragsMedium, ','));
    while iAuftragsMotivation <> '' do
      CheckListbox2.Items.add(nextp(iAuftragsMotivation, ','));
    ListeInitialized := true;
  end;
end;

function TFormPreAuftrag.RemoveCodes(s: string): string;
begin
  result := s;
  ersetze('!', '', result);
end;

function TFormPreAuftrag.DefaultMedium: string;
var
  n: integer;
begin
  result := '';
  with CheckListbox1 do
    for n := 0 to pred(Items.count) do
      if pos('!',Items[n])>0 then
        result := result + RemoveCodes(items[n]) + ',';
  if (length(result) > 0) then
    delete(result, length(result), 1);
end;

function TFormPreAuftrag.DefaultMotivation: string;
var
  n: integer;
begin
  result := '';
  with CheckListbox2 do
    for n := 0 to pred(Items.count) do
      if pos('!',Items[n])>0 then
        result := result + RemoveCodes(items[n]) + ',';
  if (length(result) > 0) then
    delete(result, length(result), 1);
end;

end.

