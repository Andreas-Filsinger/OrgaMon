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
unit Lager;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, Grids,
  ExtCtrls, StdCtrls,

  // IBObjects
  IB_Access,
  IB_ArrayGrid,
  IB_Grid,
  IB_Components,
  IB_UpdateBar,
  IB_NavigationBar,
  IB_SearchBar,

  ComCtrls, JvComponent;

type
  TFormLager = class(TForm)
    Panel1: TPanel;
    IB_DataSource1: TIB_DataSource;
    IB_Query1: TIB_Query;
    IB_Grid1: TIB_Grid;
    IB_SearchBar1: TIB_SearchBar;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Button1: TButton;
    CheckBox1: TCheckBox;
    Label5: TLabel;
    Edit5: TEdit;
    Label6: TLabel;
    TabSheet2: TTabSheet;
    Label7: TLabel;
    Label8: TLabel;
    Button2: TButton;
    ComboBox1: TComboBox;
    Button3: TButton;
    Button4: TButton;
    Label9: TLabel;
    IB_Query2: TIB_Query;
    Button5: TButton;
    Button6: TButton;
    IB_Query3: TIB_Query;
    Edit6: TEdit;
    Button7: TButton;
    Label10: TLabel;
    IB_Query4: TIB_Query;
    TabSheet3: TTabSheet;
    Button8: TButton;
    CheckBox2: TCheckBox;
    IB_Query5: TIB_Query;
    IB_Query6: TIB_Query;
    IB_Query7: TIB_Query;
    IB_Query8: TIB_Query;
    CheckBox3: TCheckBox;
    Edit7: TEdit;
    Label11: TLabel;
    TabSheet4: TTabSheet;
    Button9: TButton;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Button10: TButton;
    Button11: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
  private
    { Private-Deklarationen }
    _StartRID: integer;
    _EndeRID: integer;
    _VerlagRID: integer;
    ComboBox1IgnoreUpdate: boolean;
    procedure ReflectPlatzCount;
    procedure ReflectPlatzCountVerlag;
    procedure ArtikelLagern(Verlage, Freie: boolean);
  public
    { Public-Deklarationen }
    function LagerNames: TStringList;
    procedure CreateNew(VERLAG_R: integer; Anz: integer);
  end;

var
  FormLager: TFormLager;

implementation

uses
  globals, anfix32, math,
  Funktionen_Beleg,
  Funktionen_Artikel,
  Funktionen_Auftrag,
  ArtikelVerlag,  Datenbank,
  dbOrgaMon, wanfix32;

{$R *.DFM}

procedure TFormLager.FormActivate(Sender: TObject);
begin
  if not (IB_Query1.Active) then
    IB_query1.open;
  ReflectPlatzCount;
end;

procedure TFormLager.Button1Click(Sender: TObject);
var
  Xnnn: string;
  nXnn: string;
  nnXn: string;
  nnnX: string;
  n1, n2, n3, n4: string;
  CreatedNames: TStringList;
  n: integer;

  procedure Add;
  begin
    CreatedNames.add(n1 + n2 + n3 + n4);
  end;

begin
  CreatedNames := TStringList.create;
  n1 := '';
  n2 := '';
  n3 := '';
  n4 := '';
  Xnnn := edit1.Text;
  while (Xnnn <> '') do
  begin
    n1 := nextp(Xnnn, ',');
    nXnn := edit2.Text;
    if nXnn = '' then
      add;
    while (nXnn <> '') do
    begin
      n2 := nextp(nXnn, ',');
      nnXn := edit3.Text;
      if nnXn = '' then
        add;
      while (nnXn <> '') do
      begin
        n3 := nextp(nnXn, ',');
        nnnX := edit4.Text;
        if nnnX = '' then
          add;
        while (nnnX <> '') do
        begin
          n4 := nextp(nnnX, ',');
          add;
        end;
      end;
    end;
  end;
  if CheckBox1.checked then
  begin
    with IB_Query1 do
    begin
      DisableControls;
      for n := 0 to pred(CreatedNames.count) do
      begin
        append;
        FieldByName('RID').AsInteger := 0;
        FieldByName('NAME').AsString := CreatedNAmes[n];
        FieldByName('VOLUMEN').AsInteger := strtoint(edit5.Text);
        post;
      end;
      EnableControls;
    end;
  end else
  begin
    CreatedNames.SaveToFile(DiagnosePath + 'Lager.txt');
    openShell(DiagnosePath + 'Lager.txt');
  end;
  CreatedNames.free;
end;

procedure TFormLager.Edit1Change(Sender: TObject);
begin
  ReflectPlatzCount;
end;

procedure TFormLager.ReflectPlatzCount;
begin
  label5.caption := inttostr(succ(CharCount(',', edit1.Text)) *
    succ(CharCount(',', edit2.Text)) *
    succ(CharCount(',', edit3.Text)) *
    succ(CharCount(',', edit4.Text))) + ' Plätze';
end;

procedure TFormLager.Edit2Change(Sender: TObject);
begin
  ReflectPlatzCount;
end;

procedure TFormLager.Edit3Change(Sender: TObject);
begin
  ReflectPlatzCount;
end;

procedure TFormLager.Edit4Change(Sender: TObject);
begin
  ReflectPlatzCount;
end;

procedure TFormLager.Button3Click(Sender: TObject);
begin
  with IB_Query1 do
  begin
    _StartRID := FieldByName('RID').AsInteger;
    label7.caption := FieldByName('NAME').AsString;
  end;
  ReflectPlatzCountVerlag
end;

procedure TFormLager.Button4Click(Sender: TObject);
begin
  with IB_Query1 do
  begin
    _EndeRID := FieldByName('RID').AsInteger;
    label8.caption := FieldByName('NAME').AsString;
  end;
  ReflectPlatzCountVerlag;
end;

procedure TFormLager.ReflectPlatzCountVerlag;
begin
  with IB_query2 do
  begin
    ParamByName('CR1').AsString := label7.caption;
    ParamByName('CR2').AsString := label8.caption;
    if not (active) then
      Open;
    label9.caption := '(' + inttostr(recordCount) + 'x)';
  end;
end;

procedure TFormLager.Button5Click(Sender: TObject);
begin
  ReflectPlatzCountVerlag;
end;

procedure TFormLager.Button2Click(Sender: TObject);
begin
  if _VerlagRID <> -1 then
  begin
    ReflectPlatzCountVerlag;
    with IB_Query2 do
    begin
      if doit('Mehr Lagerplatz für Verlag ' + e_r_Verlag_VERLAG_R(_VerlagRID) + '?' + #13 +
        'Sollen ' + inttostr(RecordCount) + ' Lagerplätze zugeordnet werden') then
      begin
        first;
        while not (eof) do
        begin
          if FieldByName('VERLAG_R').IsNull then
          begin
            edit;
            FieldByName('VERLAG_R').AsInteger := _VerlagRID;
            FieldByName('FREIGABE').AsString := bool2cC(CheckBox3.checked);
            FieldByNAme('DIVERSITAET').AsInteger := strtointdef(edit7.text, 1);
            post;
          end;
          next;
        end;
      end;
      IB_Query1.refresh;
    end;
  end;
end;

procedure TFormLager.ComboBox1DropDown(Sender: TObject);
begin
  if combobox1.items.count = 0 then
    combobox1.items.addstrings(e_r_Verlage2);
end;

procedure TFormLager.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1IgnoreUpdate then
    exit;
  _VerlagRID := e_r_Verlag_R(ComboBox1.Text);
end;

procedure TFormLager.Button6Click(Sender: TObject);
begin
  with IB_Query3 do
  begin
    Open;
    _StartRID := FieldByName('RID').AsInteger;
    label7.caption := FieldByName('NAME').AsString;
    first;
    close;
  end;
  ReflectPlatzCountVerlag;
end;

procedure TFormLager.Button7Click(Sender: TObject);
var
  n: integer;
begin
  with IB_Query3 do
  begin
    Open;
    first;
    for n := 1 to pred(strtol(edit6.text)) do
      next;
    _EndeRID := FieldByName('RID').AsInteger;
    label8.caption := FieldByName('NAME').AsString;
    close;
  end;
  ReflectPlatzCountVerlag;
end;

procedure TFormLager.CreateNew(VERLAG_R: integer; Anz: integer);
begin
  // Verlag auswählen und Anzeigen
  _VerlagRID := VERLAG_R;
  ComboBox1IgnoreUpdate := true;
  Combobox1.Text := e_r_Verlag_VERLAG_R(VERLAG_R);
  ComboBox1IgnoreUpdate := false;

  // Startpunkt setzen
  show;
  Button6Click(self);

  // Endpunkt setzen
  edit6.Text := inttostr(Anz);
  Button7Click(self);

  // ersten Lagerplatz ansteuern
  IB_Query1.locate('NAME', label7.caption, []);
end;

procedure TFormLager.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  label10.caption := e_r_Verlag_VERLAG_R(IB_DataSet.FieldByName('VERLAG_R').AsInteger);
end;

function nosemi(const s: string): string;
begin
  result := s;
  ersetze(';', ',', result);
end;

procedure TFormLager.Button8Click(Sender: TObject);
var
  OutL: TStringList;
  ArtikelInfo: TStringList;
begin
  BeginHourGlass;
  OutL := TStringList.create;
  ArtikelInfo := TStringList.create;
  with IB_Query1 do
  begin
    DisableControls;
    first;
    while not (eof) do
    begin
      with IB_Query5 do
      begin
        ParamByName('CROSSREF').AsInteger := IB_Query1.FieldByName('RID').AsInteger;
        if not (Active) then
          Open;
        if IsEmpty then
        begin
          if not (CheckBox2.checked) then
            OutL.add(NoSemi(e_r_Verlag_VERLAG_R(IB_Query1.FieldByName('VERLAG_R').AsInteger)) + ';' +
              ';' +
              ';' +
              ';' +
              ';' +
              e_r_LagerPlatzNameFromLAGER_R(IB_Query1.FieldByName('RID').AsInteger) + ';' +
              ';'
              );
        end else
        begin
          FieldByName('INTERN_INFO').AssignTo(ArtikelInfo);
          OutL.add(NoSemi(e_r_Verlag_PERSON_R(FieldByName('VERLAG_R').AsInteger)) + ';' +
            inttostr(FieldByName('NUMERO').AsInteger) + ';' +
            NoSemi(FieldByName('TITEL').AsString) + ';' +
            inttostr(FieldByName('MENGE').AsInteger) + ';' +
            NoSemi(ArtikelInfo.Values['BEM']) + ';' +
            e_r_LagerPlatzNameFromLAGER_R(FieldByName('LAGER_R').AsInteger) + ';' +
            NoSemi(ArtikelInfo.Values['VERLAGNO']) + ';'
            );
        end;
      end;
      next;
    end;
    EnableControls;
  end;
  OutL.SaveToFile(DiagnosePath + 'Lager Liste 2.txt');
  OutL.free;
  ArtikelInfo.free;
  EndHourGlass;
  openShell(DiagnosePath + 'Lager Liste 2.txt');
end;

function TFormLager.LagerNames: TStringList;
var
  cLAGER: TIB_Cursor;
begin
  result := TStringList.create;
  cLAGER := DataModuleDatenbank.nCursor;
  with cLAGER do
  begin
    sql.add('select NAME from LAGER');
    ApiFirst;
    while not (eof) do
    begin
      result.add(FieldByName('NAME').AsString);
      ApiNext;
    end;
  end;
  cLAGER.free;
  result.sort;
end;

procedure TFormLager.Button9Click(Sender: TObject);
begin
  ArtikelLagern(CheckBox4.Checked, CheckBox5.Checked);
end;

procedure TFormLager.ArtikelLagern(Verlage, Freie: boolean);
var
  cARTIKEL: TIB_Cursor;
begin
  BeginHourGlass;
  cARTIKEL := DataModuleDatenbank.nCursor;
  with cARTIKEL do
  begin
    sql.add('SELECT RID');
    sql.add('FROM ARTIKEL');
    sql.add('WHERE (LAGER_R IS NULL) AND');
    sql.add('      ((MENGE>0) OR (MINDESTBESTAND>0)) AND');
    sql.add('      (SORTIMENT_R IN (SELECT RID FROM SORTIMENT WHERE LAGER=''' + cC_True + '''))');
    ApiFirst;
    while not (eof) do
    begin
      e_w_EinLagern(cRID_unset, cRID_unset, FieldByName('RID').AsInteger);
      ApiNext;
    end;
  end;
  cARTIKEL.free;
  EndHourGlass;
end;

procedure TFormLager.Button10Click(Sender: TObject);
var
  OutL: TStringList;
  ArtikelInfo: TStringList;
  n: integer;
  cARTIKEL: TIB_Cursor;
begin
  BeginHourGlass;
  OutL := TStringList.create;
  ArtikelInfo := TStringList.create;
  cARTIKEL := DataModuleDatenbank.nCursor;
  with cARTIKEL do
  begin
    sql.add('SELECT RID');
    sql.add('FROM ARTIKEL');
    sql.add('WHERE (LAGER_R IS NULL) AND');
    sql.add('      ((MENGE>0) OR (MINDESTBESTAND>0)) AND');
    sql.add('      NOT(VERLAG_R IS NULL) AND');
    sql.add('      (SORTIMENT_R IN (SELECT RID FROM SORTIMENT WHERE LAGER=''Y''))');
    ApiFirst;
    while not (eof) do
    begin
      FieldByName('INTERN_INFO').AssignTo(ArtikelInfo);
      for n := 1 to FieldByName('MENGE').AsInteger do
        OutL.add(NoSemi(e_r_Verlag_PERSON_R(FieldByName('VERLAG_R').AsInteger)) + ';' +
          inttostr(FieldByName('NUMERO').AsInteger) + ';' +
          NoSemi(FieldByName('TITEL').AsString) + ';' +
          inttostr(n) + '/' +
          inttostr(FieldByName('MENGE').AsInteger) + ';' +
          NoSemi(ArtikelInfo.Values['BEM']) + ';' +
          e_r_LagerPlatzNameFromLAGER_R(FieldByName('LAGER_R').AsInteger) + ';' +
          NoSemi(ArtikelInfo.Values['VERLAGNO']) + ';'
          );
      ApiNext;
    end;
  end;
  cARTIKEL.free;
  OutL.SaveToFile(DiagnosePath + 'Lager Liste.txt');
  OutL.free;
  ArtikelInfo.free;
  EndHourGlass;
  openShell(DiagnosePath + 'Lager Liste.txt');
end;

procedure TFormLager.Button11Click(Sender: TObject);
begin
  e_w_LagerFreigeben;
end;

end.

