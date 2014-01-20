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
unit InternationaleTexte;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  Grids, ExtCtrls, 

  // IB-Objects
  IB_Access,
  IB_CGrid,
  IB_Components,
  IB_Controls,
  IB_Grid,
  IB_UpdateBar,
  IB_NavigationBar,
  IB_SearchBar,
  IB_Dialogs;


type
  TFormInternationaleTexte = class(TForm)
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    IB_Memo1: TIB_Memo;
    IB_Query2: TIB_Query;
    IB_SearchBar1: TIB_SearchBar;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    Button1: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
  end;

var
  FormInternationaleTexte: TFormInternationaleTexte;

implementation

uses
  wanfix32, Datenbank;

{$R *.DFM}

procedure TFormInternationaleTexte.FormActivate(Sender: TObject);
begin
  if not (IB_Query1.active) then
    IB_Query1.active := true;
  caption := 'Internationale Texte';
end;

procedure TFormInternationaleTexte.Button1Click(Sender: TObject);
begin
  if doit('wirklich alles löschen') then
  begin
   //
  end;
end;


end.
