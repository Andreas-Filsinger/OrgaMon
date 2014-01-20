//
//
//
unit QGruppe;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls,
  IB_Controls, IB_NavigationBar, IB_UpdateBar,
  Grids, IB_Grid, IB_Components, IB_Access,
  CheckLst;

const
  cBEARBEITERvalue = 'BEARBEITER';
  cADMINvalue = 'ADMIN';

  cGruppeField_Kuerzel = 0;
  cGruppeField_Name = 1;
  cGruppeField_Bearbeiter = 2;
  cGruppeField_Admin = 3;

type
  TFormQGruppe = class(TForm)
    Panel1: TPanel;
    IB_DataSource1: TIB_DataSource;
    IB_Query1: TIB_Query;
    IB_Grid1: TIB_Grid;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_NavigationBar1: TIB_NavigationBar;
    Label1: TLabel;
    IB_Memo1: TIB_Memo;
    CheckListBox1: TCheckListBox;
    Label2: TLabel;
    Button1: TButton;
    Label3: TLabel;
    CheckListBox2: TCheckListBox;
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure FormDeactivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckListBox2ClickCheck(Sender: TObject);
  private
    { Private-Deklarationen }
    _cache: TStringList;
    _kuerzel: TStringList;
    procedure EnsureCache;
  public

    { Public-Deklarationen }
    procedure ReflectData;
    procedure InvalidateCache;
    procedure None;

    function FetchKuerzel: TStringList;
    function FetchRIDfromKuerzel(Kuerzel: string): integer;
    function FetchKuerzelfromRID(RID: integer): string;
    function IsMember(BEARBEITER_R: integer; GRUPPE_R: integer = 0): boolean;
    function IsAdmin(BEARBEITER_R: integer; GRUPPE_R: integer = 0): boolean;
    procedure MemberShips(BEARBEITER_R: integer; GRUPPEN: TList);
    procedure AdminShips(BEARBEITER_R: integer; GRUPPEN: TList);
  end;

var
  FormQGruppe: TFormQGruppe;

implementation

uses
  anfix32, Bearbeiter, main,
  Qmain, Datenbank;

{$R *.dfm}

procedure TFormQGruppe.CheckListBox1ClickCheck(Sender: TObject);
begin
  if (IB_Query1.State <> dssedit) and (IB_Query1.State <> dssinsert) then
    IB_Query1.edit;
end;

procedure TFormQGruppe.FormActivate(Sender: TObject);
begin
  CheckListBox1.Items.assign(FormBearbeiter.FetchKuerzel);
  CheckListBox2.Items.assign(FormBearbeiter.FetchKuerzel);

  if not (IB_Query1.Active) then
    IB_Query1.Open;
  ReflectData;
end;

procedure TFormQGruppe.IB_Query1BeforePost(IB_Dataset: TIB_Dataset);

  function ListRIDs(CheckListBox1: TCheckListBox): string;
  var
    n: integer;
  begin
    result := '';
    for n := 0 to pred(checkListbox1.items.count) do
      if CheckListBox1.Checked[n] then
        result := result + inttostr(FormBearbeiter.FetchRIDFromKurz(CheckListBox1.items[n])) + ',';
    if length(result) > 0 then
      system.delete(result, length(result), 1);
  end;

var
  MemoField: TStringList;
  n: integer;

begin
  with IB_Dataset do
  begin
    MemoField := TStringList.create;
    FieldByName('TEXT').AssignTo(MemoField);
    MemoField.values[cBEARBEITERvalue] := ListRIDs(CheckListBox1);
    MemoField.values[cADMINvalue] := ListRIDs(CheckListBox2);
    FieldByName('TEXT').Assign(MemoField);
    MemoField.free;
  end;
end;

procedure TFormQGruppe.ReflectData;
var
  MemoField: TStringList;

  procedure SetCross(CheckListBox1: TCheckListBox; BearbeiterSubs: string);
  var
    n: integer;
    RID: integer;
    BearbeiterKuerzel: string;
  begin
    for n := 0 to pred(CheckListBox1.items.count) do
      CheckListBox1.checked[n] := false;
    while (BearbeiterSubs <> '') do
    begin
      RID := strtoint(nextp(BearbeiterSubs, ','));
      BearbeiterKuerzel := FormBearbeiter.FetchKurzFromRID(RID);
      n := CheckListbox1.items.indexof(BearbeiterKuerzel);
      if (n <> -1) then
        CheckListBox1.checked[n] := true
      else
        ShowMessage('ups');
    end;
  end;

begin

  //
  if CheckListBox1.items.count = 0 then
  begin
    CheckListBox1.Items.assign(FormBearbeiter.FetchKuerzel);
    CheckListBox2.Items.assign(FormBearbeiter.FetchKuerzel);

  end;


  //
  MemoField := TStringList.create;
  IB_Query1.FieldByName('TEXT').AssignTo(MemoField);
  SetCross(CheckListBox1, MemoField.values[cBEARBEITERvalue]);
  SetCross(CheckListBox2, MemoField.values[cADMINvalue]);
  MemoField.free;

  //

end;

procedure TFormQGruppe.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  //
  ReflectData;
end;

procedure TFormQGruppe.FormDeactivate(Sender: TObject);
begin
  //
  InvalidateCache;
  FormQMain.UpdateGruppenSelektionNow := true;
end;

procedure TFormQGruppe.EnsureCache;
var
  lSubItem: TStringList;
  lmemo: TStringList;
  n: integer;
  SumBearbeiter: string;
  SumAdmin: string;

  function KommaEmbed(s: string): string;
  begin
    result := s;
    ersetze(',,', ',', result);
    if (length(result) > 0) then
    begin
      if result[1] <> ',' then
        result := ',' + result;
      if result[length(result)] <> ',' then
        result := result + ',';
    end;
  end;

begin
  if not (assigned(_Cache)) then
  begin
    SumBearbeiter := '';
    SumAdmin := '';
    _Cache := TStringList.create;
    lmemo := TStringList.create;
    with IB_Query1 do
    begin
      if not (Active) then
        Open
      else
        refresh;
      first;
      while not (eof) do
      begin
        lSubItem := TStringList.create;

  {[0]} lSubItem.add(FieldByName('KUERZEL').AsString);
  {[1]} lSubItem.add(FieldByName('NAME').AsString);

        FieldByName('TEXT').AssignTo(lmemo);

  {[2]} lSubItem.add(KommaEmbed(lmemo.values[cBEARBEITERvalue]));
  {[3]} lSubItem.add(KommaEmbed(lmemo.values[cADMINvalue]));

        SumBearbeiter := SumBearbeiter + lmemo.values[cBEARBEITERvalue] + ',';
        SumAdmin := SumAdmin + lmemo.values[cADMINvalue] + ',';

        _Cache.addObject(inttostr(FieldByName('RID').AsInteger), lSubItem);
        next;
      end;

      lSubItem := TStringList.create;
{[0]} lSubItem.add('*');
{[1]} lSubItem.add('*');
{[2]} lSubItem.add(KommaEmbed(SumBearbeiter));
{[3]} lSubItem.add(KommaEmbed(SumAdmin));
      _Cache.addObject('0', lSubItem);

      _Cache.sort;
      _Cache.sorted := true;
      _kuerzel := TStringList.Create;
      for n := 0 to pred(_cache.count) do
       if TStringList(_cache.objects[n])[0]<>'*' then
        _kuerzel.Addobject(TStringList(_cache.objects[n])[0], TObject(Strtoint(_cache[n])));
      _kuerzel.sort;

    end;
    lmemo.free;
  end;
end;

procedure TFormQGruppe.InvalidateCache;
var
  n: integer;
begin
  if assigned(_cache) then
  begin
    for n := 0 to pred(_Cache.Count) do
      _cache.Objects[n].free;
    FreeAndNil(_cache);
    FreeAndNil(_kuerzel);
  end;
end;

procedure TFormQGruppe.Button1Click(Sender: TObject);
begin
  with IB_Query1 do
  begin
    disablecontrols;
    insert;
    None;
    post;
    locate('RID', GEN_ID('GEN_GRUPPE', 0), []);
    enablecontrols;
  end;
end;

procedure TFormQGruppe.None;
var
  n: integer;
begin
  for n := 0 to pred(CheckListBox1.Items.count) do
    CheckListBox1.checked[n] := false;
end;

function TFormQGruppe.FetchKuerzel: TStringList;
begin
  EnsureCache;
  result := _kuerzel;
end;

function TFormQGruppe.FetchRIDfromKuerzel(Kuerzel: string): integer;
var
  n: integer;
begin
  result := -1;
  EnsureCache;
  for n := 0 to pred(_Cache.count) do
    if (kuerzel = TStringList(_Cache.Objects[n])[0]) then
    begin
      result := strtoint(_cache[n]);
      break;
    end;
end;

function TFormQGruppe.FetchKuerzelfromRID(RID: integer): string;
var
  n: integer;
begin
  EnsureCache;
  n := _cache.IndexOf(inttostr(RID));
  if n <> -1 then
    result := TStringList(_cache.Objects[n])[0]
  else
    result := '?';
end;

procedure TFormQGruppe.CheckListBox2ClickCheck(Sender: TObject);
begin
  CheckListBox1ClickCheck(Sender);
end;

function TFormQGruppe.IsMember(BEARBEITER_R, GRUPPE_R: integer): boolean;
var
  n: integer;
begin
  EnsureCache;
  n := _Cache.IndexOf(inttostr(GRUPPE_R));
  if (n <> -1) then
    result := pos(',' + inttostr(BEARBEITER_R) + ',', TStringList(_Cache.objects[n])[cGruppeField_Bearbeiter]) > 0
  else
    result := false;
end;

function TFormQGruppe.IsAdmin(BEARBEITER_R, GRUPPE_R: integer): boolean;
var
  n: integer;
begin
  EnsureCache;
  n := _Cache.IndexOf(inttostr(GRUPPE_R));
  if (n <> -1) then
    result := pos(',' + inttostr(BEARBEITER_R) + ',', TStringList(_Cache.objects[n])[cGruppeField_Admin]) > 0
  else
    result := false;
end;

procedure TFormQGruppe.MemberShips(BEARBEITER_R: integer; GRUPPEN: TList);
var
  n: integer;
  s: string;
  GRUPPE_R: integer;
begin
  EnsureCache;
  for n := 0 to pred(_Cache.Count) do
  begin
   GRUPPE_R:= strtoint(_Cache[n]);
   if (GRUPPE_R>0) then
    if IsMember(BEARBEITER_R,GRUPPE_R) then
     GRUPPEN.add(pointer(GRUPPE_R));
  end;
end;

procedure TFormQGruppe.AdminShips(BEARBEITER_R: integer; GRUPPEN: TList);
var
  n: integer;
  s: string;
  GRUPPE_R: integer;
begin
  EnsureCache;
  for n := 0 to pred(_Cache.Count) do
  begin
   GRUPPE_R:= strtoint(_Cache[n]);
   if (GRUPPE_R>0) then
    if IsAdmin(BEARBEITER_R,GRUPPE_R) then
     GRUPPEN.add(pointer(GRUPPE_R));
  end;
end;

end.

