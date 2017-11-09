{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2017  Andreas Filsinger
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
unit ArtikelEinheit;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, Grids, IB_Grid,
  ExtCtrls, IB_Access, IB_UpdateBar,
  IB_Components;

type
  TFormArtikelEinheit = class(TForm)
    Label1: TLabel;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_Grid1: TIB_Grid;
    Image2: TImage;
    procedure Image2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure IB_Query1AfterInsert(IB_Dataset: TIB_Dataset);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormArtikelEinheit: TFormArtikelEinheit;

implementation

uses
  globals, CareTakerClient, anfix32,
  wanfix32;

{$R *.dfm}

procedure TFormArtikelEinheit.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Einheiten');
end;

procedure TFormArtikelEinheit.FormActivate(Sender: TObject);
begin
  if not (IB_Query1.Active) then
    IB_Query1.Open;
end;

procedure TFormArtikelEinheit.FormDeactivate(Sender: TObject);
begin
  IB_Query1.Close;
end;

procedure TFormArtikelEinheit.IB_Query1AfterInsert(
  IB_Dataset: TIB_Dataset);
begin
 IB_Dataset.post;
 IB_Dataset.Refresh;
end;

end.

