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
unit Tier;
//
// Personen zugeordnete Interessen-Schwerpunkte
//

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  IB_UpdateBar, Grids, IB_Grid,
  IB_Components, IB_Access, ExtCtrls, StdCtrls,
  Mask, IB_Controls, ComCtrls,
  ShellCtrls, Buttons, WordIndex, IB_EditButton;

type
  TFormTier = class(TForm)
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    IB_Memo1: TIB_Memo;
    IB_Memo2: TIB_Memo;
    IB_Edit1: TIB_Edit;
    IB_Edit2: TIB_Edit;
    IB_Edit3: TIB_Edit;
    IB_Edit4: TIB_Edit;
    IB_Edit5: TIB_Edit;
    IB_Edit6: TIB_Edit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Button1: TButton;
    Label9: TLabel;
    Edit1: TEdit;
    Label10: TLabel;
    Edit2: TEdit;
    SpeedButton2: TSpeedButton;
    ProgressBar1: TProgressBar;
    SpeedButton1: TSpeedButton;
    IB_UpdateBar1: TIB_UpdateBar;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Image2: TImage;
    SpeedButton16: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure SpeedButton16Click(Sender: TObject);
    procedure IB_Query1ConfirmDelete(Sender: TComponent;
      var Confirmed: Boolean);
  private
    { Private-Deklarationen }
    Edit1Showing: boolean;
    MainQuerySql: TStringList;
    TierSucheWI: TWordIndex;
    PERSON_R: integer;
  public
    { Public-Deklarationen }
    procedure SetContext(pPERSON_R: integer; pTIER_R: integer = 0);
    procedure CreateIndex;
    function cSelectOne: string;
    function cSelectAll: string;
    function cSelectList(l: TList): string;
    procedure DoTheTierSearch;
  end;

var
  FormTier: TFormTier;

implementation

uses
  globals, anfix32, math,
  Funktionen_Basis,
  Funktionen_Beleg,
  Person, CareTakerClient, Datenbank,
  dbOrgaMon, Jvgnugettext,
  wanfix32;

{$R *.dfm}

{ TFormTier }

procedure TFormTier.SetContext;
begin
  if (pPERSON_R>=cRID_FirstValid) then
  begin
    PERSON_R := pPERSON_R;
    with IB_Query1 do
    begin
      close;
      sql.clear;
      AddStringsCR(sql, cSelectAll);
      ParamByName('CROSSREF').AsInteger := PERSON_R;
      if not (active) then
        Open;
    end;
    show;
  end;
end;

procedure TFormTier.Button1Click(Sender: TObject);
begin
  if IB_Query1.state in [dssinsert, dssedit] then
    IB_Query1.Post;
  close;
end;

procedure TFormTier.Edit1Change(Sender: TObject);
begin
  if not (Edit1Showing) then
  begin
    IB_Query1.FieldByName('GEBURT').AsInteger := date2long(edit1.text);
  end;
end;

procedure TFormTier.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  Edit1Showing := true;
  edit1.text := noblank(long2date(IB_Query1.FieldByName('GEBURT').AsInteger));
  Edit1Showing := false;
end;

procedure TFormTier.IB_Query1ConfirmDelete(Sender: TComponent;
  var Confirmed: Boolean);
begin
  Confirmed := false;
  with Sender as TIB_Dataset do
    if doit(_('Tier') + #13 +
      FieldByName('NAME').AsString + #13 +
      _('wirklich löschen'), true) then
    begin
//       e_w_preDeleteTier
      Confirmed := true;
    end;
end;

procedure TFormTier.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Tiere');
end;

procedure TFormTier.SpeedButton16Click(Sender: TObject);
var
 TIER_R : integer;
begin
  // neues Tier
  with IB_query1 do
  begin
    if state in [dssinsert, dssedit] then
      Post;
    TIER_R := e_w_gen('GEN_TIER');

    insert;
    FieldByName('RID').AsInteger := TIER_R;
    FieldByName('PERSON_R').AsInteger := PERSON_R;
    post;
    refresh;
    locate('RID',TIER_R,[]);
  end;
  IB_Query1.Edit;
  IB_Edit1.SetFocus;
end;

procedure TFormTier.SpeedButton1Click(Sender: TObject);
var
  PathName: string;
begin
  PathName := MyProgramPath + 'Tiere\' +
    inttostrN(ib_query1.FieldByName('RID').AsInteger, 8);
  CheckCreateDir(PathName);
  openShell(PathName);
end;

function TFormTier.cSelectList(l: TList): string;
var
  ResultSQL: TStringList;
  n: integer;
begin
  ResultSQL := TStringList.create;
  for n := 0 to pred(MainQuerySql.count) do
    if pos(cSQLwhereMarker, MainQuerySql[n]) = 1 then
      break
    else
      ResultSQL.add(MainQuerySql[n]);
  ResultSQL.add('WHERE RID IN (');
  for n := 0 to pred(min(l.count, 75)) do
    if (n = 0) then
      ResultSQL.add(inttostr(integer(l[n])))
    else
      ResultSQL.add(',' + inttostr(integer(l[n])));
  ResultSQL.add(') FOR UPDATE');
  result := HugeSingleLine(ResultSQL);
  ResultSQL.free;
end;

function TFormTier.cSelectOne: string;
var
  ResultSQL: TStringList;
  n: integer;
begin
  ResultSQL := TStringList.create;
  for n := 0 to pred(MainQuerySql.count) do
    if pos(cSQLwhereMarker, MainQuerySql[n]) = 1 then
      break
    else
      ResultSQL.add(MainQuerySql[n]);
  ResultSQL.add('WHERE RID=:CROSSREF');
  ResultSQL.add('FOR UPDATE');
  result := HugeSingleLine(ResultSQL);
  ResultSQL.free;
end;

function TFormTier.cSelectAll: string;
var
  ResultSQL: TStringList;
  n: integer;
begin
  ResultSQL := TStringList.create;
  for n := 0 to pred(MainQuerySql.count) do
    if pos(cSQLwhereMarker, MainQuerySql[n]) = 1 then
      break
    else
      ResultSQL.add(MainQuerySql[n]);
  ResultSQL.add('WHERE PERSON_R=:CROSSREF');
  ResultSQL.add('FOR UPDATE');
  result := HugeSingleLine(ResultSQL);
  ResultSQL.free;
end;

procedure TFormTier.Button2Click(Sender: TObject);
var
  ToRID: integer;
begin
  with ib_query1 do
  begin
    screen.cursor := crHourGlass;
    ToRID := FieldByName('RID').AsInteger;
    close;
    sql.clear;
    AddStringsCR(sql, cSelectAll);
    open;
    locate('RID', ToRID, []);
    button2.Enabled := false;
    screen.cursor := crDefault;
  end;
end;

procedure TFormTier.FormCreate(Sender: TObject);
begin
  MainQuerySql := TStringList.create;
  MainQuerySql.addStrings(IB_Query1.sql);
end;

procedure TFormTier.CreateIndex;
var
  cTIER: TIB_Cursor;
  IMPFUNGsl: TSTringList;
  KRANKHEITsl: TSTringList;
  StartT: dword;
  RecN: integer;
begin
  BeginHourGlass;
  if assigned(TierSucheWI) then
    FreeAndNil(TierSucheWI);
  TierSucheWI := TWordIndex.create(nil);
  cTIER := DataModuleDatenbank.nCursor;
  IMPFUNGsl := TSTringList.create;
  KRANKHEITsl := TSTringList.create;
  RecN := 0;
  StartT := 0;
  with cTIER do
  begin
    sql.add('select * from TIER');
    ApiFirst;
    progressbar1.max := RecordCount;
    while not (eof) do
    begin
      FieldByName('IMPFUNG').AssignTo(IMPFUNGsl);
      FieldByName('KRANKHEIT').AssignTo(KRANKHEITsl);
      TierSucheWI.AddWords(FieldByNAme('ART').AsString + ' ' +
        FieldByNAme('RASSE').AsString + ' ' +
        FieldByNAme('NAME').AsString + ' ' +
        'g' + FieldByNAme('GESCHLECHT').AsString + ' ' +
        FieldByNAme('TAETOWIERNUMMER').AsString + ' ' +
        FieldByNAme('CHIPNUMMER').AsString + ' ' +
        HugeSingleLine(IMPFungsl, ' ') + ' ' +
        HugeSingleLine(KRANKHEITsl, ' ')

        , TObject(FieldByName('RID').AsInteger));
      ApiNext;
      inc(RecN);
      if frequently(StartT, 444) or eof then
      begin
        progressbar1.position := RecN;
        application.processmessages;
      end;
    end;
  end;
  cTIER.free;
  IMPFUNGsl.free;
  KRANKHEITsl.free;
  TierSucheWI.JoinDuplicates(false);
  TierSucheWI.SaveToFile(SearchDir + cTierSuchindexFName);
  progressbar1.position := 0;
  EndHourGlass;
end;

procedure TFormTier.DoTheTierSearch;
begin
  BeginHourGlass;
  if not (FileExists(SearchDir + cTierSuchindexFName)) then
    CreateIndex;
  if not (assigned(TierSucheWI)) then
  begin
    TierSucheWI := TWordIndex.create(nil);
    TierSucheWI.LoadFromFile(SearchDir + cTierSuchindexFName);
  end else
  begin
    TierSucheWI.ReloadIfNew;
  end;

  TierSucheWI.Search(edit2.Text);
  if TierSucheWI.FoundList.count > 0 then
  begin
    with ib_query1 do
    begin
      close;
      sql.clear;
      AddStringsCR(sql, cSelectList(TierSucheWI.FoundList));
      open;
      button2.Enabled := true;
    end;
  end else
  begin
    ShowMessage('Nichts gefunden!');
    edit2.SetFocus;
  end;
  EndHourGlass;
end;

procedure TFormTier.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    DoTheTierSearch;
  end;
end;

procedure TFormTier.SpeedButton2Click(Sender: TObject);
begin
  CreateIndex;
end;

procedure TFormTier.Button3Click(Sender: TObject);
begin
  FormPerson.SetContext(IB_Query1.FieldByName('PERSON_R').AsInteger);
end;

end.

