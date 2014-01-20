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
unit ArtikelAusgabeart;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls,
  IB_Components, IB_Access, IB_UpdateBar, Grids,
  IB_Grid, JvGIF;

type
  TFormArtikelAusgabeart = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    IB_Grid1: TIB_Grid;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    Button1: TButton;
    Button2: TButton;
    Image2: TImage;
    procedure Image2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormArtikelAusgabeart: TFormArtikelAusgabeart;

implementation

uses
 globals, CareTakerClient, wanfix32;

{$R *.dfm}

procedure TFormArtikelAusgabeart.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Ausgabeart');
end;

end.
