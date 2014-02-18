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
unit Laender;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, Grids,
  ExtCtrls, StdCtrls, ComCtrls,
  Mask,

  // IB-Objects
  IB_Components,
  IB_UpdateBar,
  IB_NavigationBar,
  IB_SearchBar,
  IB_DatasetBar,
  IB_Grid,
  IB_Controls,
  IB_ArrayGrid, IB_Access;

type
  TFormLaender = class(TForm)
    IB_DataSource1: TIB_DataSource;
    IB_Query1: TIB_Query;
    IB_Grid1: TIB_Grid;
    Button4: TButton;
    IB_Query2: TIB_Query;
    Image2: TImage;
    IB_SearchBar1: TIB_SearchBar;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    procedure FormActivate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
    procedure FormDeactivate(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }

    // Länder Funktionen

  end;

var
  FormLaender: TFormLaender;

implementation

uses
  Datenbank, globals, anfix32,
  Funktionen_Basis, CareTakerClient, IBExportTable,
  wanfix32;

{$R *.DFM}

procedure TFormLaender.FormActivate(Sender: TObject);
begin
  if not (IB_Query1.Active) then
    IB_Query1.Open;
end;

procedure TFormLaender.Button4Click(Sender: TObject);
var
  ISOCodes: TStringList;
  _USRID: integer;
  _DERID: integer;
  _Kurz: string;
  _langDE: string;
  _langUS: string;
  n: integer;
  TheLandText: TStringList;
  OneLine: string;
begin
  screen.cursor := crHourGlass;

  TheLandText := TStringList.create;
  ISOCodes := TStringList.create;
  ISOCodes.LoadFromFile(SystemPath + '\tld_cc.csv');

  IB_Query1.open;
  IB_Query1.DisableControls;
  IB_Query2.Open;

  // erst alle Kurz-Codes eintragen
  for n := 0 to pred(ISOCodes.count) do
  begin
    OneLine := ISOCodes[n];
    if charCount(';', OneLine) <> 2 then
      continue;

    _Kurz := AnsiUpperCase(noblank(nextp(OneLine, ';')));

    if not (IB_query1.Locate('ISO_KURZZEICHEN', _kurz, [])) then
    begin
      IB_Query1.Insert;
      IB_Query1.FieldByName('ISO_KURZZEICHEN').AsString := _Kurz;
      IB_Query1.FieldByName('INT_NAME_R').AsInteger := IB_Query1.GEN_ID('TEXTE_GID', 1);
      if (_Kurz = 'US') or (_Kurz = 'DE') then
        IB_Query1.FieldByName('ARTIKEL_RELEVANT').AsString := 'Y';
      IB_Query1.Post;
    end;
  end;

  // Den RID für US speichern
  InvalidateCache_Laender;
  _USRID := e_r_LaenderRIDfromISO('US');
  if _USRID = -1 then
    exit;
  _DERID := e_r_LaenderRIDfromISO('DE');
  if _DERID = -1 then
    exit;

  //
  for n := 0 to pred(ISOCodes.count) do
  begin

    OneLine := ISOCodes[n];
    if charCount(';', OneLine) <> 2 then
      continue;

    _Kurz := AnsiUpperCase(noblank(nextp(OneLine, ';')));
    _LangUS := ANsiUpperCase(cutblank(nextp(OneLine, ';')));
    _LangDE := cutblank(nextp(OneLine, ';'));

    IB_query1.Locate('ISO_KURZZEICHEN', _kurz, []);

    TheLandText.clear;
    TheLandText.add(_LangUS);

      // Das Land gibts schon, nur noch den neuen Text hinzunehmen!
    IB_Query2.insert;
    IB_Query2.FieldByName('LAND_R').AsInteger := _USRID;
    IB_Query2.FieldByName('RID').AsInteger := IB_Query1.FieldByName('INT_NAME_R').AsInteger;
    IB_Query2.FieldByName('INT_TEXT').Assign(TheLandText);
    IB_Query2.post;

    TheLandText.clear;
    TheLandText.add(_LangDE);

      // Das Land gibts schon, nur noch den neuen Text hinzunehmen!
    IB_Query2.insert;
    IB_Query2.FieldByName('LAND_R').AsInteger := _DERID;
    IB_Query2.FieldByName('RID').AsInteger := IB_Query1.FieldByName('INT_NAME_R').AsInteger;
    IB_Query2.FieldByName('INT_TEXT').Assign(TheLandText);
    IB_Query2.post;

  end;

  TheLandText.free;
  IB_Query1.EnableControls;
  IB_Query1.refresh;
  screen.cursor := crdefault;
end;

procedure TFormLaender.IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
begin
  if IB_DataSet.FieldByName('INT_NAME_R').IsNull then
    IB_DataSet.FieldByName('INT_NAME_R').AsInteger := 0;
end;

procedure TFormLaender.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Land');
end;


procedure TFormLaender.FormDeactivate(Sender: TObject);
begin
  InvalidateCache_Laender;
end;

end.

