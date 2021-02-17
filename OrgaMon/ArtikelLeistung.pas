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
unit ArtikelLeistung;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  IB_Access, IB_Components, Grids,
  IB_Grid, IB_UpdateBar, IB_NavigationBar,
  ExtCtrls, IB_Controls, StdCtrls,
  Mask, Datenbank, IB_EditButton;

type
  TFormArtikelLeistung = class(TForm)
    Panel1: TPanel;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_Grid1: TIB_Grid;
    Panel2: TPanel;
    IB_DataSource1: TIB_DataSource;
    IB_Query1: TIB_Query;
    IB_Edit1: TIB_Edit;
    IB_Edit2: TIB_Edit;
    IB_Edit3: TIB_Edit;
    IB_Edit4: TIB_Edit;
    IB_Edit5: TIB_Edit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    IB_Text1: TIB_Text;
    IB_Text2: TIB_Text;
    Button2: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormArtikelLeistung: TFormArtikelLeistung;

implementation

uses
  Artikel, anfix;

{$R *.dfm}

procedure TFormArtikelLeistung.FormActivate(Sender: TObject);
begin
  if not (IB_Query1.Active) then
    IB_Query1.Open;
end;

procedure TFormArtikelLeistung.Button2Click(Sender: TObject);
begin
  formartikel.SetContext(IB_query1.FieldByName('RID').AsInteger);
end;

end.

