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
unit FolgeSetzen;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  IB_Components, IB_Access, StdCtrls,
  Grids, IB_Grid, IB_UpdateBar,
  ExtCtrls, IB_NavigationBar, jpeg,
  JvGIF, Datenbank;

type
  TFormFolgeSetzen = class(TForm)
    IB_NavigationBar2: TIB_NavigationBar;
    IB_UpdateBar2: TIB_UpdateBar;
    Button6: TButton;
    Button9: TButton;
    Button23: TButton;
    IB_Grid1: TIB_Grid;
    Label1: TLabel;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    Button1: TButton;
    Image1: TImage;
    Image2: TImage;
    procedure FormActivate(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private
    { Private-Deklarationen }
    _AUSGABEART_R: integer;
    _ARTIKEL_R: integer;
    TheQuery: TStringList;
    DialogResult: boolean;
    procedure SetQuery;
  public
    { Public-Deklarationen }
    function SetContext(AUSGABEART_R, ARTIKEL_R: integer): boolean;
  end;

var
  FormFolgeSetzen: TFormFolgeSetzen;

implementation

{$R *.dfm}

uses
  globals, anfix32, CareTakerClient,
  wanfix32, Funktionen_Beleg;

procedure TFormFolgeSetzen.FormActivate(Sender: TObject);
begin
  if IB_Query1.Active then
    IB_Query1.refresh
  else
    IB_Query1.open;
end;

procedure TFormFolgeSetzen.Button6Click(Sender: TObject);
var
  RID1, POSNO1: integer;
  RID2, POSNO2: integer;

  procedure SetPOSNO(RID, POSNO: integer);
  var
    POSTEN: TIB_DSQL;
  begin
    POSTEN := DataModuleDatenbank.nDSQL;
    with POSTEN do
    begin
      sql.add('UPDATE BPOSTEN SET FOLGE = ' + inttostr(POSNO) + ' WHERE RID = ' + inttostr(RID));
      execute;
    end;
    POSTEN.free;
  end;

begin
  // UP
  with IB_Query1 do
    if not (bof) then
    begin
      // swap posno with upper neighbour
      RID2 := FieldByName('RID').AsInteger;
      POSNO2 := FieldByName('FOLGE').AsInteger;
      prior;
      if not (bof) then
      begin
        RID1 := FieldByName('RID').AsInteger;
        POSNO1 := FieldByName('FOLGE').AsInteger;
        if (RID1 <> RID2) then
        begin
          SetPOSNO(RID1, POSNO2);
          SetPOSNO(RID2, POSNO1);
          locate('RID', RID1, []);
        end else
        begin
          locate('RID', RID2, []);
        end;
      end else
      begin
        locate('RID', RID2, []);
        beep;
      end;
      refresh;
    end;
end;

procedure TFormFolgeSetzen.Button9Click(Sender: TObject);
var
  RID1, POSNO1: integer;
  RID2, POSNO2: integer;

  procedure SetPOSNO(RID, POSNO: integer);
  var
    POSTEN: TIB_DSQL;
  begin
    POSTEN := DataModuleDatenbank.nDSQL;
    with POSTEN do
    begin
      sql.add('UPDATE BPOSTEN SET FOLGE = ' + inttostr(POSNO) + ' WHERE RID = ' + inttostr(RID));
      execute;
    end;
    POSTEN.free;
  end;

begin
  // DOWN
  with IB_Query1 do
    if not (Eof) then
    begin
      // swap posno with upper neighbour
      RID2 := FieldByName('RID').AsInteger;
      POSNO2 := FieldByName('FOLGE').AsInteger;
      next;
      if not (eof) then
      begin
        RID1 := FieldByName('RID').AsInteger;
        POSNO1 := FieldByName('FOLGE').AsInteger;
        if (RID1 <> RID2) then
        begin
          SetPOSNO(RID1, POSNO2);
          SetPOSNO(RID2, POSNO1);
          locate('RID', RID1, []);
        end else
        begin
          locate('RID', RID2, []);
        end;
      end else
      begin
        locate('RID', RID2, []);
        beep;
      end;
      refresh;
    end;
end;

procedure TFormFolgeSetzen.Button23Click(Sender: TObject);
begin
  e_w_SetFolge(_AUSGABEART_R, _ARTIKEL_R);
  IB_Query1.Refresh;
end;

function TFormFolgeSetzen.SetContext(AUSGABEART_R, ARTIKEL_R: integer): boolean;
begin
  DialogResult := false;
  _AUSGABEART_R := AUSGABEART_R;
  _ARTIKEL_R := ARTIKEL_R;
  SetQuery;
  showmodal;
  result := DialogResult;
end;

procedure TFormFolgeSetzen.SetQuery;
var
  n: integer;
begin
  with IB_Query1 do
  begin
    sql.clear;
    for n := 0 to pred(TheQuery.count) do
      if (pos('--', TheQuery[n]) > 0) then
      begin
        sql.add(' AND ' + e_r_sqlArtikelWhere(_AUSGABEART_R, _ARTIKEL_R, 'B'));
      end else
      begin
        sql.add(TheQuery[n]);
      end;
  end;
end;

procedure TFormFolgeSetzen.FormCreate(Sender: TObject);
begin
  TheQuery := TStringList.create;
  TheQuery.assign(IB_Query1.sql);
end;

procedure TFormFolgeSetzen.Button1Click(Sender: TObject);
begin
  DialogResult := true;
  close;
end;

procedure TFormFolgeSetzen.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL+'Buchungsfolge');
end;

end.

