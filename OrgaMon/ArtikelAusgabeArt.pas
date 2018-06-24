{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2018  Andreas Filsinger
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
unit ArtikelAusgabeArt;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  Grids, IB_Grid, IB_Components,
  IB_Access;

type
  TFormArtikelAusgabeArt = class(TForm)
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    procedure FormActivate(Sender: TObject);
    procedure IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormArtikelAusgabeArt: TFormArtikelAusgabeArt;

implementation

{$R *.dfm}

procedure TFormArtikelAusgabeArt.FormActivate(Sender: TObject);
begin
  if not (IB_Query1.Active) then
    IB_query1.Open;
end;

procedure TFormArtikelAusgabeArt.IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
begin
  IB_Dataset.Refresh;
end;

end.
