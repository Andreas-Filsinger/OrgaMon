{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2011 - 2024  Ronny Schupeta
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
  |    https://wiki.orgamon.org/
  |
}
unit Auswertung.Generator.MixStatistik.config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormAGM_Config = class(TForm)
    GroupBoxExcel: TGroupBox;
    EditCityOverviewStart: TEdit;
    LabelCityOverviewStart: TLabel;
    EditCitySheetStart: TEdit;
    LabelCitySheetStart: TLabel;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    procedure EditCityOverviewStartKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonOkClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormAGM_Config: TFormAGM_Config;

implementation

uses
 Auswertung.Generator.MixStatistik.main;

{$R *.dfm}

function TXStrToInt(const Str: AnsiString; AbsValue: Boolean = False): Integer;
var
  i, l:   Integer;
  res:    AnsiString;
  minus:  Boolean;
begin
  if AbsValue then
    minus := False
  else if Pos('-', Str) > 0 then
    minus := True
  else
    minus := False;

  res := '';
  l := Length(Str);
  for i := 1 to l do
    if (Str[i] >= '0') and (Str[i] <= '9') then
      res := res + Str[i];

    result := StrToIntdef(res,0);
    if minus then
      result := -result;
end;


procedure TFormAGM_Config.FormShow(Sender: TObject);
begin
  EditCityOverviewStart.Text := IntToStr(FormAGM_Main.LNMITS.CityOverviewStart);
  EditCitySheetStart.Text := IntToStr(FormAGM_Main.LNMITS.CitySheetStart);
end;

procedure TFormAGM_Config.EditCityOverviewStartKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    ButtonOk.Click;
end;

procedure TFormAGM_Config.ButtonOkClick(Sender: TObject);
var
  CityOverviewStart:  Integer;
  CitySheetStart:     Integer;
begin
  CityOverviewStart := TXStrToInt(EditCityOverviewStart.Text);
  if CityOverviewStart < 1 then
  begin
    ShowMessage('Bitte geben Sie eine gültige Zeile ein (> 0)');
    EditCityOverviewStart.SetFocus;
    Exit;
  end;

  CitySheetStart := TXStrToInt(EditCitySheetStart.Text);
  if CitySheetStart < 1 then
  begin
    ShowMessage('Bitte geben Sie eine gültige Zeile ein (> 0)');
    EditCitySheetStart.SetFocus;
    Exit;
  end;

  FormAGM_Main.LNMITS.CityOverviewStart := CityOverviewStart;
  FormAGM_Main.LNMITS.CitySheetStart := CitySheetStart;
  FormAGM_Main.WriteConfig;

  Close;
end;

procedure TFormAGM_Config.ButtonCancelClick(Sender: TObject);
begin
  Close;
end;

end.
