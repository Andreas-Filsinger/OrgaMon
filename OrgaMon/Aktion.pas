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
unit Aktion;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  IB_Access, IB_Components, IB_UpdateBar, IB_NavigationBar,
  ExtCtrls, StdCtrls, IB_Controls,
  Grids, IB_Grid, Buttons;

type
  TFormAktion = class(TForm)
    Panel1: TPanel;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    IB_Memo1: TIB_Memo;
    Button7: TButton;
    SpeedButton13: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormAktion: TFormAktion;

implementation

uses
  globals, Belege, anfix,
  WordIndex, Artikel, ArtikelContext;

{$R *.dfm}

procedure TFormAktion.FormActivate(Sender: TObject);
begin
  if not (IB_Query1.active) then
    IB_Query1.open;
end;

procedure TFormAktion.Button7Click(Sender: TObject);
begin
 FormArtikel.SetContext(IB_Query1.FieldByName('ARTIKEL_R').AsInteger);
end;

procedure TFormAktion.SpeedButton13Click(Sender: TObject);
begin
  FormArtikelContext.SetContextContext(IB_Query1.FieldByNAme('ARTIKEL_R').AsInteger);
end;

end.

