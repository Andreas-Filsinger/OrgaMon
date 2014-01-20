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
unit ArtikelNeu;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  ExtCtrls, Grids,

  // IBObjects
  IB_Access,
  IB_constants,
  IB_Components,
  IB_UpdateBar,
  IB_Grid,

  // Projekt-Privat
  Datenbank;

type
  TFormArtikelNeu = class(TForm)
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    Button1: TButton;
    Button2: TButton;
    IB_Grid1: TIB_Grid;
    Label1: TLabel;
    IB_UpdateBar1: TIB_UpdateBar;
    Timer1: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private-Deklarationen }

  public
    { Public-Deklarationen }
    SORTIMENT_R : integer;

    function execute : boolean;
  end;

var
  FormArtikelNeu: TFormArtikelNeu;

implementation

uses
  Artikel, Globals;

{$R *.DFM}

procedure TFormArtikelNeu.FormActivate(Sender: TObject);
begin
  if not (IB_query1.active) then
    IB_query1.Open;
  timer1.enabled := true;
end;

procedure TFormArtikelNeu.Button1Click(Sender: TObject);
begin
  SORTIMENT_R := IB_Query1.FieldByName('RID').AsInteger;
  close;
end;

procedure TFormArtikelNeu.Button2Click(Sender: TObject);
begin
 SORTIMENT_R := -1;
  close;
end;

procedure TFormArtikelNeu.FormDeactivate(Sender: TObject);
begin
  timer1.enabled := false;
end;

procedure TFormArtikelNeu.Timer1Timer(Sender: TObject);
begin
  if NoTimer then
   Exit;
  IB_Query1.refresh;
end;

function TFormArtikelNeu.execute: boolean;
begin
 showmodal;
 result :=  SORTIMENT_R <>-1;
end;

end.
