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
unit Budget;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  ExtCtrls, IB_NavigationBar, IB_UpdateBar,
  Grids, IB_Grid, IB_Components,
  IB_Access, Datenbank,
  StdCtrls, ComCtrls, Buttons;

type
  TFormBudget = class(TForm)
    IB_DataSource1: TIB_DataSource;
    IB_Query1: TIB_Query;
    IB_Grid1: TIB_Grid;
    IB_UpdateBar1: TIB_UpdateBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Button2: TButton;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Button3: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    SpeedButton1: TSpeedButton;
    Button1: TButton;
    Button4: TButton;
    CheckBox4: TCheckBox;
    Panel1: TPanel;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    RadioButtonZ_Alle: TRadioButton;
    RadioButtonZ_Vormonat: TRadioButton;
    RadioButtonZ_DieserMonat: TRadioButton;
    RadioButtonZ_User: TRadioButton;
    RadioButtonZ_MonatUser: TRadioButton;
    Label7: TLabel;
    Panel2: TPanel;
    Edit9: TEdit;
    RadioButtonB_Alle: TRadioButton;
    RadioButtonB_ungebuchte: TRadioButton;
    RadioButtonB_gebuchteUser: TRadioButton;
    RadioButtonB_gebuchte: TRadioButton;
    Label8: TLabel;
    Edit10: TEdit;
    CheckBox5: TCheckBox;
    TabSheet3: TTabSheet;
    Label9: TLabel;
    Label10: TLabel;
    Edit11: TEdit;
    Button11: TButton;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button11Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    function e_r_StundenSatz(BUDGET_R: integer): double;
  end;

var
  FormBudget: TFormBudget;

implementation

uses
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  BudgetKalkulation,
  anfix32, globals, Person, Artikel,
  Geld, dbOrgaMon, wanfix32;

{$R *.dfm}

procedure TFormBudget.Button11Click(Sender: TObject);
var
  WorkPath: string;
  Beleg_R: integer;
begin
  BeginHourGlass;
  Beleg_R := StrToIntDef(Edit11.Text, cRID_Null);
  WorkPath := cPersonPath(IB_Query1.FieldByName('PERSON_R').AsInteger);
  e_w_BudgetAbschreiben(Beleg_R, WorkPath + cHTML_ArbeitszeitFName);
  FileMove(WorkPath + cHTML_ArbeitszeitFName, WorkPath + inttostrN(Beleg_R, 10) + '-verbuchte-' +
    cHTML_ArbeitszeitFName);
  EndHourGlass;
end;

procedure TFormBudget.Button1Click(Sender: TObject);
begin
  FormArtikel.setContext(IB_Query1.FieldByName('ARTIKEL_R').AsInteger);
end;

procedure TFormBudget.Button2Click(Sender: TObject);
var
  StundenSatz: double;
  Arbeitslohn: double;
begin

  //
  StundenSatz := e_r_StundenSatz(IB_Query1.FieldByName('RID').AsInteger);
  Arbeitslohn := cPreisRundung((StrToIntDef(Edit1.Text, 0) * StundenSatz) / 3600.0);
  Edit2.Text := format('%m', [Arbeitslohn]);

  //
  Edit3.Text := format('%m', [cPreisRundung(Arbeitslohn * 0.13)]);
  Edit4.Text := format('%m', [cPreisRundung(Arbeitslohn * 0.15)]);
  Edit5.Text := format('%m', [cPreisRundung(Arbeitslohn * 0.02)]);

end;

procedure TFormBudget.Button3Click(Sender: TObject);
var
  moreSettings: TStringList;
  pDateVon: TAnfixDate;
  pDateBis: TAnfixDate;
begin
  moreSettings := TStringList.create;
  repeat

    if RadioButtonZ_Vormonat.checked then
    begin
      pDateVon := PrevMonth(DateGet);
      pDateBis := DatePlus(pDateVon, LastDayOfMonth(pDateVon) - 1);

      //
      moreSettings.add('VON=' + long2date(pDateVon));
      moreSettings.add('BIS=' + long2date(pDateBis));

    end;

    if RadioButtonZ_DieserMonat.checked then
    begin
      pDateVon := ThisMonth(DateGet);
      pDateBis := DateGet;

      //
      moreSettings.add('VON=' + long2date(pDateVon));
      moreSettings.add('BIS=' + long2date(pDateBis));

    end;

    if RadioButtonZ_MonatUser.checked then
    begin
      pDateVon := date2long('01.' + Edit6.Text);
      pDateBis := DatePlus(pDateVon, LastDayOfMonth(pDateVon) - 1);

      //
      moreSettings.add('VON=' + long2date(pDateVon));
      moreSettings.add('BIS=' + long2date(pDateBis));

    end;

    if RadioButtonZ_User.checked then
    begin
      pDateVon := date2long(Edit7.Text);
      pDateBis := date2long(Edit8.Text);

      //
      moreSettings.add('VON=' + long2date(pDateVon));
      moreSettings.add('BIS=' + long2date(pDateBis));
    end;

    if RadioButtonB_Alle.checked then
    begin
      moreSettings.add('BELEG=*');
    end;

    if RadioButtonB_ungebuchte.checked then
    begin
      moreSettings.add('BELEG=');
    end;

    if RadioButtonB_gebuchte.checked then
    begin
      moreSettings.add('BELEG=!');
    end;

    if RadioButtonB_gebuchteUser.checked then
    begin
      moreSettings.add('BELEG=' + Edit9.Text);
    end;

  until true;

  if CheckBox1.checked then
    moreSettings.add('SCHAETZUNG=' + cC_True);

  if CheckBox2.checked then
    moreSettings.add('LOHN=' + cC_True);

  if CheckBox3.checked then
    moreSettings.add('STEUER=' + cC_True);

  if CheckBox4.checked then
    moreSettings.add('BUDGET=' + IB_Query1.FieldByName('RID').AsString);

  if not(CheckBox5.checked) then
    moreSettings.add('STUNDENSATZ=' + cC_False);

  //
  e_w_BudgetEinfuegen(cRID_Null, Edit10.Text, IB_Query1.FieldByName('PERSON_R').AsInteger,
    moreSettings);
  moreSettings.free;

  //
  openShell(
    { } cPersonPath(IB_Query1.FieldByName('PERSON_R').AsInteger) +
    { } cHTML_ArbeitszeitFName);

end;

procedure TFormBudget.Button4Click(Sender: TObject);
begin
  FormPerson.setContext(IB_Query1.FieldByName('PERSON_R').AsInteger);
end;

procedure TFormBudget.CheckBox3Click(Sender: TObject);
begin
  if CheckBox3.checked then
    CheckBox2.checked := true;
end;

function TFormBudget.e_r_StundenSatz(BUDGET_R: integer): double;
var
  ARTIKEL_R: integer;
begin
  ARTIKEL_R := e_r_sql('select ARTIKEL_R from BUGET where RID=' + inttostr(BUDGET_R));
  result := e_r_PreisNetto(0, ARTIKEL_R);
end;

procedure TFormBudget.FormActivate(Sender: TObject);
begin
  if IB_Query1.active then
    IB_Query1.refresh
  else
    IB_Query1.Open;
end;

procedure TFormBudget.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet1;
end;

procedure TFormBudget.SpeedButton1Click(Sender: TObject);
var
  BUDGET_R: integer;
  MONTEUR_R: integer;
begin
  //
  with IB_Query1 do
  begin
    if FieldByName('MONTEUR_R').IsNotNull then
    begin
      BUDGET_R := FieldByName('RID').AsInteger;
      MONTEUR_R := FieldByName('MONTEUR_R').AsInteger;
      e_x_sql('update ARBEITSZEIT set' + ' MONTEUR_R=' + inttostr(MONTEUR_R) + ' ' + 'where ' +
        ' (BUGET_R=' + inttostr(BUDGET_R) + ') and ' + ' (MONTEUR_R is null)');
    end;
  end;

end;

end.
