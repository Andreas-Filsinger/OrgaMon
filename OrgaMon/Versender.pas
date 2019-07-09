{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2019  Andreas Filsinger
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
unit Versender;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  Grids, IB_Access, IB_Grid, IB_Components,
  IB_NavigationBar, IB_UpdateBar, ExtCtrls,
  IB_Controls;

type
  TFormVersender = class(TForm)
    IB_DataSource1: TIB_DataSource;
    IB_Query1: TIB_Query;
    IB_Grid1: TIB_Grid;
    IB_Query2: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    IB_Grid2: TIB_Grid;
    IB_Memo1: TIB_Memo;
    Label3: TLabel;
    Label1: TLabel;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_NavigationBar1: TIB_NavigationBar;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    IB_NavigationBar2: TIB_NavigationBar;
    IB_UpdateBar2: TIB_UpdateBar;
    procedure FormActivate(Sender: TObject);
    procedure IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
    procedure IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
    procedure Button1Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
    VersenderCache: TStringList;
    FormenCache: TStringList;
    procedure EnsureOpen;
  public
    { Public-Deklarationen }
    function Versender: TStringList;
    function Versandformen: TStringList;
    procedure LocateVersender(RID: integer);
  end;

var
  FormVersender: TFormVersender;

implementation

uses
  anfix32, Datenbank, Person;

{$R *.DFM}

procedure TFormVersender.EnsureOpen;
begin
  if not (IB_Query1.active) then
    IB_Query1.Open;
  if not (IB_Query2.active) then
    IB_Query2.Open;
end;

procedure TFormVersender.FormActivate(Sender: TObject);
begin
  EnsureOpen;
end;

procedure TFormVersender.IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
begin
  if IB_Dataset.FieldByName('RID').IsNull then
    IB_Dataset.FieldByName('RID').AsInteger := 0; // nur zum Schein
end;

procedure TFormVersender.IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
begin
  if IB_Dataset.FieldByName('RID').IsNull then
    IB_Dataset.FieldByName('RID').AsInteger := 0; // nur zum Schein
end;

procedure TFormVersender.Button1Click(Sender: TObject);
begin
  with IB_Query1 do
  begin
    if FieldByName('PERSON_R').IsNull then
    begin
      if FormPerson.TakeActual then
      begin
        edit;
        FieldByName('PERSON_R').AsInteger := FormPerson.IB_Query1.FieldByName('RID').AsInteger;
        post;
      end;
    end
    else
    begin
      FormPerson.SetContext(FieldByName('PERSON_R').AsInteger);
    end;
  end;
end;

procedure TFormVersender.FormDeactivate(Sender: TObject);
begin
  VersenderCache.clear;
  FormenCache.clear;
end;

procedure TFormVersender.FormCreate(Sender: TObject);
begin
  StartDebug('Versender');
  VersenderCache := TStringList.create;
  FormenCache := TStringList.create;
end;

function TFormVersender.Versender: TStringList;
begin
  if (VersenderCache.count = 0) then
  begin
    Ensureopen;
    with IB_Query1 do
    begin
      disablecontrols;
      first;
      while not (eof) do
      begin
        VersenderCache.AddObject(FieldByName('BEZEICHNUNG').AsString, TOBject(FieldByName('RID').AsInteger));
        next;
      end;
      enablecontrols;
    end;
    VersenderCache.sort;
  end;
  result := VersenderCache;
end;

function TFormVersender.Versandformen: TStringList;
begin
  if (FormenCache.count = 0) then
    with IB_Query2 do
    begin
      EnsureOpen;
      disablecontrols;
      first;
      while not (eof) do
      begin
        FormenCache.AddObject(FieldByName('BEZEICHNUNG').AsString, TOBject(FieldByName('RID').AsInteger));
        next;
      end;
      enablecontrols;
      FormenCache.sort;
    end;
  result := FormenCache;
end;

procedure TFormVersender.LocateVersender(RID: integer);
begin
  EnsureOpen;
  if not (IB_Query1.locate('RID', RID, [])) then
    ShowMessage('Fehler: Versender nicht gefunden (RID=' + inttostr(RID) + ')');
end;

procedure TFormVersender.Button2Click(Sender: TObject);
begin
  IB_Query1.edit;
  IB_Query1.FieldByName('PACKFORM_R').AsInteger := IB_Query2.FieldByName('RID').AsInteger;
  IB_Query1.Post;
end;

end.
