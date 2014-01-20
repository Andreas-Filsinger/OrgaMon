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
unit MonteurUmfang;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls;

type
  TFormMonteurUmfang = class(TForm)
    Button1: TButton;
    Button2: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    ExecuteResult: integer; { -1=Abbruch
                                0=Alle blauen
                                1=Alle, Alle
                             }
  end;

var
  FormMonteurUmfang: TFormMonteurUmfang;

implementation

{$R *.dfm}

procedure TFormMonteurUmfang.Button1Click(Sender: TObject);
begin
  ExecuteResult := -1;
  if radiobutton1.Checked then
    ExecuteResult := 0;
  if radiobutton2.Checked then
    ExecuteResult := 1;
  close;
end;

procedure TFormMonteurUmfang.Button2Click(Sender: TObject);
begin
  ExecuteResult := -1;
  close;
end;

procedure TFormMonteurUmfang.FormCreate(Sender: TObject);
begin
  ExecuteResult := -1;
end;

end.

