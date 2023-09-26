{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2012 - 2018  Andreas Filsinger
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
unit Kontext;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, CheckLst, ComCtrls,
  ContextBase;

const
  cContextMode_VertragNeu = 1;
  cContextMode_VertragsNehmerNeu = 2;

type
  TFormKontext = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    CheckListBox1: TCheckListBox;
    Button1: TButton;
    TabSheet2: TTabSheet;
    CheckListBox2: TCheckListBox;
    Button4: TButton;
    TabSheet3: TTabSheet;
    CheckListBox3: TCheckListBox;
    Button7: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure CheckListBox1DblClick(Sender: TObject);
    procedure CheckListBox2DblClick(Sender: TObject);
    procedure CheckListBox3DblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
    setPerson: boolean;
    setBeleg: boolean;
    setBaustelle: boolean;
    retMode: integer;

    procedure updateControls(CheckFirst: boolean = false);
    function strBELEG(RID: integer): string;
    function strBAUSTELLE(RID: integer): string;
    procedure doExit;
  public
    { Public-Deklarationen }
    PERSON_GID, BELEGE_GID, BAUSTELLE_GID: Int64;
    PERSON_R: integer;
    BELEG_R: integer;
    BAUSTELLE_R: integer;

    procedure browse;
    procedure setContext(Mode: integer);
  end;

var
  FormKontext: TFormKontext;

implementation

uses
  globals, IB_Components, Datenbank,
  anfix, Person, Baustelle,
  Belege, Vertrag, dbOrgaMon,
  Funktionen_LokaleDaten,
  Funktionen_Auftrag;

{$R *.dfm}

procedure TFormKontext.browse;
begin
  PageControl1.ActivePage := TabSheet1;
  updateControls;
  show;
end;

procedure TFormKontext.Button10Click(Sender: TObject);
begin
  if (CheckListBox1.ItemIndex <> -1) then
    FormPerson.setContext(cnPERSON[CheckListBox1.ItemIndex]);
end;

procedure TFormKontext.Button11Click(Sender: TObject);
begin
  if (CheckListBox2.ItemIndex <> -1) then
    FormBelege.setContext(0, cnBELEG[CheckListBox2.ItemIndex]);
end;

procedure TFormKontext.Button12Click(Sender: TObject);
begin
  if (CheckListBox3.ItemIndex <> -1) then
    FormBaustelle.setContext(cnBAUSTELLE[CheckListBox3.ItemIndex]);
end;

procedure TFormKontext.Button1Click(Sender: TObject);
var
  n: integer;
begin
  PERSON_R := cRID_NULL;
  for n := 0 to pred(cnPERSON.count) do
    if CheckListBox1.checked[n] then
    begin
      PERSON_R := cnPERSON[n];
      break;
    end;
  if (PERSON_R <> cRID_NULL) then
  begin
    case retMode of
      cContextMode_VertragNeu:
        PageControl1.ActivePage := TabSheet2;
      cContextMode_VertragsNehmerNeu:
        doExit;
    end;
  end;
end;

procedure TFormKontext.Button4Click(Sender: TObject);
var
  n: integer;
begin
  BELEG_R := cRID_NULL;
  for n := 0 to pred(cnBELEG.count) do
    if CheckListBox2.checked[n] then
    begin
      BELEG_R := cnBELEG[n];
      break;
    end;
  if (BELEG_R <> cRID_NULL) then
    PageControl1.ActivePage := TabSheet3;
end;

procedure TFormKontext.Button7Click(Sender: TObject);
var
  n: integer;
begin
  BAUSTELLE_R := cRID_NULL;
  for n := 0 to pred(cnBAUSTELLE.count) do
    if CheckListBox3.checked[n] then
    begin
      BAUSTELLE_R := cnBAUSTELLE[n];
      break;
    end;
  if (BAUSTELLE_R <> cRID_NULL) then
    doExit;
end;

procedure TFormKontext.CheckListBox1ClickCheck(Sender: TObject);
var
  n: integer;
begin
  with Sender as TCheckListBox do
    for n := 0 to pred(items.count) do
      if n <> ItemIndex then
        checked[n] := false;
end;

procedure TFormKontext.CheckListBox1DblClick(Sender: TObject);
begin
  Button10Click(Sender);
end;

procedure TFormKontext.CheckListBox2DblClick(Sender: TObject);
begin
  Button11Click(Sender);
end;

procedure TFormKontext.CheckListBox3DblClick(Sender: TObject);
begin
  Button12Click(Sender);
end;

procedure TFormKontext.doExit;
begin
  BeginHourGlass;
  close;
  case retMode of
    cContextMode_VertragNeu:
      FormVertrag.CreateVertragFromContext;
    cContextMode_VertragsNehmerNeu:
      FormVertrag.CreateVertragsnehmerFromContext;
  end;
  EndHourGlass;
end;

procedure TFormKontext.FormActivate(Sender: TObject);
begin
  // refresh?!
  if
  { } (cnPERSON.GID <> PERSON_GID) or
  { } (cnBELEG.GID <> BELEGE_GID) or
  { } (cnBAUSTELLE.GID <> BAUSTELLE_GID) then
    updateControls(false);
end;

procedure TFormKontext.setContext(Mode: integer);
begin
  retMode := 0;
  case Mode of
    cContextMode_VertragNeu:
      begin
        PageControl1.ActivePage := TabSheet1;
        setPerson := true;
        setBeleg := true;
        setBaustelle := true;
        retMode := Mode;
      end;
    cContextMode_VertragsNehmerNeu:
      begin
        PageControl1.ActivePage := TabSheet1;
        setPerson := true;
        setBeleg := false;
        setBaustelle := false;
        retMode := Mode;
      end;
  else
    PageControl1.ActivePage := TabSheet1;
  end;
  updateControls(true);
  show;
end;

function TFormKontext.strBAUSTELLE(RID: integer): string;
var
  cBAUSTELLE: TIB_Cursor;
  sSCHLAGZEILE: TStringList;
begin
  sSCHLAGZEILE := TStringList.create;
  cBAUSTELLE := DataModuleDatenbank.nCursor;
  with cBAUSTELLE do
  begin
    sql.add('select RID,NUMMERN_PREFIX,SCHLAGZEILE from BAUSTELLE where RID=' +
      inttostr(RID));
    ApiFirst;
    FieldByName('SCHLAGZEILE').assignTo(sSCHLAGZEILE);
    result := format('%6d %6s %s', [FieldByName('RID').AsInteger,
      FieldByName('NUMMERN_PREFIX').AsString, HugeSingleLine(sSCHLAGZEILE)]);
  end;
  cBAUSTELLE.free;
  sSCHLAGZEILE.free;
end;

function TFormKontext.strBELEG(RID: integer): string;
var
  cBELEG: TIB_Cursor;
begin
  cBELEG := DataModuleDatenbank.nCursor;
  with cBELEG do
  begin
    sql.add('select RID,VOLUMEN,MOTIVATION from Beleg where RID=' +
      inttostr(RID));
    ApiFirst;
    result := format('%6d %m %s', [FieldByName('RID').AsInteger,
      FieldByName('VOLUMEN').AsDouble, FieldByName('MOTIVATION').AsString]);
  end;
  cBELEG.free;
end;

procedure TFormKontext.updateControls(CheckFirst: boolean);
var
  n: integer;
begin
  // Personen
  CheckListBox1.items.clear;
  for n := 0 to pred(cnPERSON.count) do
    CheckListBox1.items.add(e_r_Person(cnPERSON[n]));
  if CheckFirst then
    if (cnPERSON.count > 0) then
      CheckListBox1.checked[0] := true;
  PERSON_GID := cnPERSON.GID;
  // Belege
  CheckListBox2.items.clear;
  for n := 0 to pred(cnBELEG.count) do
    CheckListBox2.items.add(strBELEG(cnBELEG[n]));
  if CheckFirst then
    if cnBELEG.count > 0 then
      CheckListBox2.checked[0] := true;
  BELEGE_GID := cnBELEG.GID;
  // Baustellen
  CheckListBox3.items.clear;
  for n := 0 to pred(cnBAUSTELLE.count) do
    CheckListBox3.items.add(strBAUSTELLE(cnBAUSTELLE[n]));
  if CheckFirst then
    if cnBAUSTELLE.count > 0 then
      CheckListBox3.checked[0] := true;
  BAUSTELLE_GID := cnBAUSTELLE.GID;
end;

end.

