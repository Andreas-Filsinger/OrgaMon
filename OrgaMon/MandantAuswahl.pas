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
unit MandantAuswahl;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls;

type
  TFormMandantAuswahl = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Private-Deklarationen }
    OKpressed: boolean;
    iIndex: integer;
    function GetMandant : string;
  public
    { Public-Deklarationen }
    property Mandant : string read GetMandant;
    property Index : integer read iIndex;
  end;

var
  FormMandantAuswahl: TFormMandantAuswahl;

implementation

{$R *.dfm}

procedure TFormMandantAuswahl.Button1Click(Sender: TObject);
begin
 OKpressed := true;
 iIndex := listbox1.itemindex;
 close;
end;

function TFormMandantAuswahl.GetMandant: string;
begin
 if OKpressed then
  result := listbox1.items[iIndex]
 else
  result := '';
end;

procedure TFormMandantAuswahl.ListBox1DblClick(Sender: TObject);
begin
 Button1Click(self);
end;

end.
