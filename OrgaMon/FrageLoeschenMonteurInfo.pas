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
unit FrageLoeschenMonteurInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, anfix32;

type
  TFormFrageLoeschenMonteurInfo = class(TForm)
    LabelQuestion: TLabel;
    ButtonDeleteOneDataset: TButton;
    ButtonAllDatasets: TButton;
    procedure FormShow(Sender: TObject);
    procedure ButtonDeleteOneDatasetClick(Sender: TObject);
    procedure ButtonAllDatasetsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }

    DeleteAll:    Boolean;

    function CanDeleteAll: Boolean;
  end;

var
  FormFrageLoeschenMonteurInfo: TFormFrageLoeschenMonteurInfo;

implementation

{$R *.dfm}

function TFormFrageLoeschenMonteurInfo.CanDeleteAll: Boolean;
begin
  ShowModal;

  Result := DeleteAll;
end;

procedure TFormFrageLoeschenMonteurInfo.FormCreate(Sender: TObject);
begin
  Caption := cNachfrage;
end;

procedure TFormFrageLoeschenMonteurInfo.FormShow(Sender: TObject);
begin
  DeleteAll := False;
  ButtonDeleteOneDataset.SetFocus;
end;

procedure TFormFrageLoeschenMonteurInfo.ButtonDeleteOneDatasetClick(
  Sender: TObject);
begin
  DeleteAll := False;
  Close;
end;

procedure TFormFrageLoeschenMonteurInfo.ButtonAllDatasetsClick(
  Sender: TObject);
begin
  DeleteAll := True;
  Close;
end;

end.
