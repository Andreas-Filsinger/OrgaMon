{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2011  Ronny Schupeta
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
unit Auswertung.Generator.MixStatistik.editcity;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormAGM_EditCity = class(TForm)
    LabeledEditCity: TLabeledEdit;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure LabeledEditCityKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }

    UserCanceled: Boolean;
  end;

var
  FormAGM_EditCity: TFormAGM_EditCity;

implementation

{$R *.dfm}

procedure TFormAGM_EditCity.FormShow(Sender: TObject);
begin
  UserCanceled := True;
end;

procedure TFormAGM_EditCity.ButtonOkClick(Sender: TObject);
begin
  UserCanceled := False;
  Close;
end;

procedure TFormAGM_EditCity.ButtonCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAGM_EditCity.LabeledEditCityKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    ButtonOk.Click;
end;

end.
