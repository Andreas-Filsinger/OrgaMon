{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2012  Andreas Filsinger
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
unit ArtikelRang;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  IB_Grid, IB_Components, IB_Access, Grids,
  StdCtrls, IB_UpdateBar, ExtCtrls,
  IB_NavigationBar;

type
  TFormArtikelRang = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    Button2: TButton;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
  end;

var
  FormArtikelRang: TFormArtikelRang;

implementation

uses
  anfix, globals, Artikel,
  ArtikelKategorie, Datenbank, gplists,
  Funktionen_Beleg, Math;

{$R *.dfm}

procedure TFormArtikelRang.Button1Click(Sender: TObject);
begin
 BeginHourGlass;
 e_d_Rang;
 EndHourGlass;
end;

procedure TFormArtikelRang.FormActivate(Sender: TObject);
begin
  IB_Query1.open;
end;

procedure TFormArtikelRang.FormDeactivate(Sender: TObject);
begin
  IB_Query1.close;
end;

procedure TFormArtikelRang.Button2Click(Sender: TObject);
begin
  FormArtikel.SetContext(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormArtikelRang.Button3Click(Sender: TObject);
begin
  FormArtikelKategorie.execute(IB_Query1.FieldByName('RID').AsInteger);
end;

end.
