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
unit MwSt;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls,
  Grids,

  // IBObjects
  IB_Access,
  IB_UpdateBar,
  IB_NavigationBar,
  IB_SearchBar,
  IB_Grid,
  IB_Components;

type
  TFormMwSt = class(TForm)
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    Image2: TImage;
    procedure FormActivate(Sender: TObject);
    procedure IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
    procedure Image2Click(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure EnsureOpen;
  public
    { Public-Deklarationen }
  end;

var
  FormMwSt: TFormMwSt;

implementation

uses
  anfix32, CaretakerClient, Datenbank,
  wanfix32;

{$R *.DFM}

procedure TFormMwSt.FormActivate(Sender: TObject);
begin
  EnsureOpen;
end;

procedure TFormMwSt.EnsureOpen;
begin
  if not (IB_Query1.active) then
    IB_Query1.Open;
end;

procedure TFormMwSt.IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
begin
  IB_Dataset.refresh;
end;

procedure TFormMwSt.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Steuersaetze');
end;

end.

