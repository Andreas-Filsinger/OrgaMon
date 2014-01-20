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
unit Zahlungsart;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IB_Controls, IB_Access, Grids, IB_Grid, ExtCtrls, IB_UpdateBar,
  IB_Components, JvGIF, Datenbank;

type
  TFormZahlungsart = class(TForm)
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_Grid1: TIB_Grid;
    IB_Memo1: TIB_Memo;
    Label1: TLabel;
    Label2: TLabel;
    StaticText1: TStaticText;
    Image2: TImage;
    Image1: TImage;
    Label3: TLabel;
    IB_Memo2: TIB_Memo;
    procedure FormActivate(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
    procedure Image2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure RefreshText;

  public
    { Public-Deklarationen }
  end;

var
  FormZahlungsart: TFormZahlungsart;

implementation

uses
  Funktionen.Beleg, anfix32, CareTakerClient,
  ZahlungECconnect, Jvgnugettext, wanfix32;

{$R *.dfm}

procedure TFormZahlungsart.FormActivate(Sender: TObject);
begin
  if IB_Query1.Active then
    IB_Query1.refresh
  else
    IB_Query1.open;
end;

procedure TFormZahlungsart.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  RefreshText;
end;

procedure TFormZahlungsart.Image1Click(Sender: TObject);
begin
  FormZahlungECconnect.show;
end;

procedure TFormZahlungsart.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Zahlungsart');
end;

procedure TFormZahlungsart.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

procedure TFormZahlungsart.IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
begin
  RefreshText;
end;

procedure TFormZahlungsart.RefreshText;
begin
  StaticText1.caption := e_r_ZahlungText(IB_Query1.FieldByName('RID').AsInteger);
end;

end.

