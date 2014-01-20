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
unit Serie;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, Grids,

  // IB-Objects
  IB_Access,
  IB_Components,
  IB_UpdateBar,
  IB_NavigationBar,
  IB_DatasetBar,
  IB_Grid,
  IB_SearchBar;


type
  TFormSerie = class(TForm)
    IB_Grid1: TIB_Grid;
    Panel1: TPanel;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_DataSource1: TIB_DataSource;
    IB_Query1: TIB_Query;
    IB_SearchBar1: TIB_SearchBar;
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormSerie: TFormSerie;

implementation

uses
 Datenbank;

{$R *.DFM}

procedure TFormSerie.FormActivate(Sender: TObject);
begin
  if not (IB_Query1.active) then
    IB_Query1.active := true;
end;

end.
