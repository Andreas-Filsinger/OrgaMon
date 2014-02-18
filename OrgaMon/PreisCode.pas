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
unit PreisCode;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  ExtCtrls,
  IB_Access,
  IB_Components,
  IB_UpdateBar,
  IB_NavigationBar,
  Grids,
  IB_Grid, IB_SearchBar, StdCtrls;

type
  TFormPreisCode = class(TForm)
    Panel1: TPanel;
    IB_Query1: TIB_Query;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    IB_SearchBar1: TIB_SearchBar;
    Button1: TButton;
    Label1: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
    procedure Button1Click(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure ReflectData(IB_Dataset: TIB_Dataset);
  end;

var
  FormPreisCode: TFormPreisCode;

implementation

uses
  ArtikelVerlag,
  Funktionen_Basis,
  Funktionen_Auftrag,
  Datenbank;

{$R *.dfm}

procedure TFormPreisCode.FormActivate(Sender: TObject);
begin
  if not IB_Query1.Active then
    IB_Query1.Open;
end;

procedure TFormPreisCode.IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
begin
  with IB_Dataset do
  begin
    if FieldByName('RID').IsNull then
      FieldByName('RID').AsInteger := 0;
    if FieldByName('ALIAS_R').IsNotNull then
    begin
      FieldByName('CODE').AsString := 'ALIAS';
      FieldByName('WAEHRUNG_R').AsInteger := e_r_LaenderRIDfromISO('DE');
      FieldByName('PREIS').AsDouble := 0;
      FieldByName('EURO').AsDouble := 0;
      FieldByName('USD').AsDouble := 0;
    end;
  end;
end;

procedure TFormPreisCode.Button1Click(Sender: TObject);
var
  Waehrung_r: integer;
  Verlag_r: integer;
begin
  with IB_Query1 do
  begin
    Waehrung_r := FieldByName('WAEHRUNG_R').AsInteger;
    Verlag_r := FieldByName('VERLAG_R').AsInteger;
    if (Waehrung_r <> 0) and (Verlag_r <> 0) then
    begin
      insert;
      FieldByName('WAEHRUNG_R').AsInteger := Waehrung_r;
      FieldByName('VERLAG_R').AsInteger := Verlag_r;
      FieldByName('CODE').AsString := '?';
      FieldByName('PREIS').AsDouble := 0.0;
      post;
    end;
    refresh;
  end;
end;

procedure TFormPreisCode.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  ReflectData(IB_Dataset);
end;

procedure TFormPreisCode.ReflectData(IB_Dataset: TIB_Dataset);
begin
  with IB_Dataset do
    Label1.Caption :=
    { } e_r_LaenderISO(FieldByName('WAEHRUNG_R').AsInteger) +
    { } '-' +
    { } e_r_Verlag_VERLAG_R(FieldByName('VERLAG_R').AsInteger);
end;

procedure TFormPreisCode.IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
begin
  ReflectData(IB_Dataset);
end;

end.
