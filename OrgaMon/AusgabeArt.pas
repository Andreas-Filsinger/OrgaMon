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
unit AusgabeArt;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  Grids, IB_Grid, IB_Components,
  IB_Access;

type
  TFormAusgabeArt = class(TForm)
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    procedure FormActivate(Sender: TObject);
    procedure IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    function RIDtoKurz(AUSGABEART_R: integer): string;
  end;

var
  FormAusgabeArt: TFormAusgabeArt;

implementation

{$R *.dfm}

procedure TFormAusgabeArt.FormActivate(Sender: TObject);
begin
  if not (IB_Query1.Active) then
    IB_query1.Open;
end;

procedure TFormAusgabeArt.IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
begin
  IB_Dataset.Refresh;
end;

function TFormAusgabeArt.RIDtoKurz(AUSGABEART_R: integer): string;
begin
  result := '';
  if (AusgabeArt_r <> 0) then
  begin
    with IB_Query1 do
    begin
      if not (Active) then
        Open;
      locate('RID', AUSGABEART_R, []);
      result := FieldByNAme('KUERZEL').AsString + ' ';
    end;
  end;
end;

end.
