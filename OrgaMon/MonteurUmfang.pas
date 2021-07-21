{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2021  Andreas Filsinger
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
unit MonteurUmfang;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, Vcl.ExtCtrls, JvComponentBase, JvFormPlacement,
  anfix;

const
 cUMFANG_CANCEL = -1;
 // Matrix aus
 //  Monteure
 //   M1 = ein Monteur
 //   B  = Alle Monteure der Baustelle
 //   Mx = alle Monteure
 //  Zeit
 //   T1 = ein Tag
 //   KW = eine Kalenderwoche
 cUMFANG_BKW    = 0;
 cUMFANG_MxKW   = 1;
 cUMFANG_M1KW   = 2;
 cUMFANG_BT1    = 3;
 cUMFANG_MxT1   = 4;
 cUMFANG_M1T1   = 5;

type
  TFormMonteurUmfang = class(TForm)
    Button1: TButton;
    Button2: TButton;
    JvFormStorage1: TJvFormStorage;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    RadioButtonM1: TRadioButton;
    RadioButtonB: TRadioButton;
    RadioButtonX: TRadioButton;
    RadioButtonT1: TRadioButton;
    RadioButtonKW: TRadioButton;
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
    procedure UnCheck;
  end;

var
  FormMonteurUmfang: TFormMonteurUmfang;

implementation

{$R *.dfm}

procedure TFormMonteurUmfang.Button1Click(Sender: TObject);
begin
  ExecuteResult := -1;
  if (RadioButtonM1.Checked) and (RadioButtonT1.Checked) then
    ExecuteResult := cUMFANG_M1T1;
  if (RadioButtonM1.Checked) and (RadioButtonKW.Checked) then
    ExecuteResult := cUMFANG_M1KW;
  if (RadioButtonB.Checked) and (RadioButtonT1.Checked) then
    ExecuteResult := cUMFANG_BT1;
  if (RadioButtonB.Checked) and (RadioButtonKW.Checked) then
    ExecuteResult := cUMFANG_BKW;
  if (RadioButtonX.Checked) and (RadioButtonT1.Checked) then
    ExecuteResult := cUMFANG_MxT1;
  if (RadioButtonX.Checked) and (RadioButtonKW.Checked) then
    ExecuteResult := cUMFANG_MxKW;
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

procedure TFormMonteurUmfang.UnCheck;
begin
  RadioButtonM1.Checked := false;
  RadioButtonB.Checked := false;
  RadioButtonX.Checked := false;
  RadioButtonT1.Checked := false;
  RadioButtonKW.Checked := false;
end;

end.

