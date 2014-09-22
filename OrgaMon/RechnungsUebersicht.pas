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
unit RechnungsUebersicht;

{$IFDEF OrgaMonServer}
{$Message Error 'Someone uses "RechnungsUebersicht" in Server-Mode!'}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, Grids, IB_Grid,
  ExtCtrls, IB_Access, IB_Components, IB_UpdateBar,
  IB_SearchBar, Buttons, Datenbank;

type
  TFormRechnungsUebersicht = class(TForm)
    IB_Grid1: TIB_Grid;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    SpeedButton8: TSpeedButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    IB_UpdateBar1: TIB_UpdateBar;
    Button4: TButton;
    Button18: TButton;
    CheckBox1: TCheckBox;
    Image4: TImage;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure IB_Grid1GetDisplayText(Sender: TObject; ACol, ARow: Integer;
      var AString: String);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure setSQL;
  public
    { Public-Deklarationen }
    procedure SetContext(PERSON_R: Integer);
  end;

var
  FormRechnungsUebersicht: TFormRechnungsUebersicht;

implementation

uses
  globals,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  Funktionen_Buch,
  Person, Belege,
  AusgangsRechnungen, anfix32,
  geld, dbOrgaMon, Rechnungen,
  ZahlungECconnect, wanfix32;

{$R *.dfm}

const
  sSQL_NurUnbezahlte = ' select' +
  { } '  VERSAND.RECHNUNG,' +
  { } '  VERSAND.LIEFERBETRAG,' +
  { } '  (select' +
  { } '    SUM(-B.BETRAG)' +
  { } '   from' +
  { } '    AUSGANGSRECHNUNG B' +
  { } '   where' +
  { } '    (VERSAND.BELEG_R=B.BELEG_R) and' +
  { } '    (VERSAND.TEILLIEFERUNG=B.TEILLIEFERUNG) and' +
  { } '    ((B.VORGANG<>''' + cVorgang_Rechnung + ''') or ' +
  { } '     (B.VORGANG is null))' + '   ) as DAVON_BEZAHLT,' +
  { } '  VERSAND.BELEG_R,' +
  { } '  VERSAND.TEILLIEFERUNG,' +
  { } '  VERSAND.AUSGANG,' +
  { } '  BELEG.MAHNSTUFE,' +
  { } '  PERSON.RID as PERSON_R,' +
  { } '  PERSON.SUCHBEGRIFF' +
  { } ' from' +
  { } '  VERSAND' +
  { } ' join' +
  { } '  BELEG' +
  { } ' on' +
  { } '  (BELEG.RID=VERSAND.BELEG_R)' +
  { } ' join' +
  { } '  PERSON' +
  { } ' on' +
  { } '  (PERSON.RID=BELEG.PERSON_R)' +
  { } ' where' +
  { } '  (VERSAND.RECHNUNG is not null) and' +
  { } '  (VERSAND.AUSGANG>CURRENT_DATE-365) and' +
  { } '  (VERSAND.LIEFERBETRAG > coalesce(' +
  { } '   (select' +
  { } '      -SUM(B.BETRAG)' +
  { } '    from' +
  { } '     AUSGANGSRECHNUNG B' +
  { } '    where' +
  { } '     (VERSAND.BELEG_R=B.BELEG_R) and' +
  { } '     (VERSAND.TEILLIEFERUNG=B.TEILLIEFERUNG) and' +
  { } '     ((B.VORGANG<>''' + cVorgang_Rechnung +
    ''') or (B.VORGANG is null))' +
  { } '   ),0.0) + 0.01) and' +

  { } ' ((select' +
  { } '    SUM(B.BETRAG)' +
  { } '  from' +
  { } '    AUSGANGSRECHNUNG B' +
  { } '  where' +
  { } '   (VERSAND.BELEG_R=B.BELEG_R))>0.01)' +
  { } ' order by' +
  { } '  VERSAND.AUSGANG descending ';

  sSQL_Alle = ' select' + '  VERSAND.RECHNUNG,' + '  VERSAND.LIEFERBETRAG,' +
    '  (select' + '    SUM(-B.BETRAG)' + '   from' + '    AUSGANGSRECHNUNG B' +
    '   where' + '    (VERSAND.BELEG_R=B.BELEG_R) and' +
    '    (VERSAND.TEILLIEFERUNG=B.TEILLIEFERUNG) and' + '    ((B.VORGANG<>''' +
    cVorgang_Rechnung + ''') or (B.VORGANG is null))' + '   ) as DAVON_BEZAHLT,'
    + '  VERSAND.BELEG_R,' + '  VERSAND.TEILLIEFERUNG,' + '  VERSAND.AUSGANG,' +
    '  BELEG.MAHNSTUFE,' + '  PERSON.RID as PERSON_R,' + '  PERSON.SUCHBEGRIFF'
    + ' from' + '  VERSAND' + ' join' + '  BELEG' + ' on' +
    '  (BELEG.RID=VERSAND.BELEG_R)' + ' join' + '  PERSON' + ' on' +
    '  (PERSON.RID=BELEG.PERSON_R)' + ' where' +
    '  (VERSAND.RECHNUNG is not null) and' +
    '  (VERSAND.AUSGANG>CURRENT_DATE-365) ' + ' order by' +
    '  VERSAND.AUSGANG descending ';

procedure TFormRechnungsUebersicht.FormActivate(Sender: TObject);
begin
  BeginHourGlass;
  if not(IB_Query1.active) then
  begin
    with IB_Query1 do
    begin
      setSQL;
      open;
    end;
  end
  else
    IB_Query1.refresh;
  EndHourGlass;
end;

procedure TFormRechnungsUebersicht.Button1Click(Sender: TObject);
begin
  FormPerson.SetContext(IB_Query1.FieldByName('PERSON_R').AsInteger);
end;

procedure TFormRechnungsUebersicht.Button2Click(Sender: TObject);
begin
  FormBelege.SetContext(0, IB_Query1.FieldByName('BELEG_R').AsInteger);
end;

procedure TFormRechnungsUebersicht.Button3Click(Sender: TObject);
begin
  FormAusgangsrechnungen.SetContext(IB_Query1.FieldByName('PERSON_R').AsInteger,
    IB_Query1.FieldByName('BELEG_R').AsInteger,
    IB_Query1.FieldByName('LIEFERBETRAG').AsDouble + IB_Query1.FieldByName
    ('DAVON_BEZAHLT').AsDouble);
end;

procedure TFormRechnungsUebersicht.SetContext(PERSON_R: Integer);
begin

end;

procedure TFormRechnungsUebersicht.setSQL;
begin
  with IB_Query1 do
  begin
    sql.clear;
    if CheckBox1.Checked then
      sql.add(sSQL_Alle)
    else
      sql.add(sSQL_NurUnbezahlte);
  end;
end;

procedure TFormRechnungsUebersicht.SpeedButton8Click(Sender: TObject);
begin
  openShell(MyProgramPath + cRechnungPath + '\' +
    RIDasStr(IB_Query1.FieldByName('PERSON_R').AsInteger));
end;

procedure TFormRechnungsUebersicht.Button4Click(Sender: TObject);
begin
  with IB_Query1 do
    openShell(RechnungFName(
      { } FieldByName('PERSON_R').AsInteger,
      { } FieldByName('BELEG_R').AsInteger,
      { } FieldByName('TEILLIEFERUNG').AsInteger));
end;

procedure TFormRechnungsUebersicht.Button5Click(Sender: TObject);
begin
end;
// FormRechnungen.show;

procedure TFormRechnungsUebersicht.CheckBox1Click(Sender: TObject);
begin
  IB_Query1.close;
  setSQL;
  IB_Query1.open;
end;

procedure TFormRechnungsUebersicht.Button18Click(Sender: TObject);
var
  Bericht: TStringList;
  PERSON_R: Integer;
begin
  PERSON_R := IB_Query1.FieldByName('PERSON_R').AsInteger;
  if PERSON_R > 0 then
  begin
    Bericht := e_w_KontoInfo(PERSON_R);
    Bericht.free;
    openShell(MahnungFName(PERSON_R));
  end;
end;

procedure TFormRechnungsUebersicht.IB_Grid1GetDisplayText(Sender: TObject;
  ACol, ARow: Integer; var AString: string);
begin
  if (ARow > 0) then
    if (AString <> '') then
      case ACol of
        2, 3:
          AString := format('%m', [strtodoubledef(AString, 0.0)]);
        8:
          AString := e_r_Person(strtointdef(AString, cRID_NULL));
      end;
end;

procedure TFormRechnungsUebersicht.Image4Click(Sender: TObject);
begin
  FormPerson.SetContext(IB_Query1.FieldByName('PERSON_R').AsInteger);

  // EC-Karten Event simulieren!
  with FormZahlungECconnect, FormPerson.IB_Query1 do
  begin
    Edit_BLZ.Text := b_r_Person_ELV_BLZ(
      { } FieldByName('Z_ELV_BLZ').AsString,
      { } FieldByName('Z_ELV_KONTO').AsString);
    Edit_Konto.Text := b_r_Person_ELV_Konto(
      { } FieldByName('Z_ELV_BLZ').AsString,
      { } FieldByName('Z_ELV_KONTO').AsString);
    Edit_GueltigBis.Text := 'NOCARD';
    FillContext;
    if (PERSON_R <> FormPerson.IB_Query1.FieldByName('RID').AsInteger) then
      ShowMEssage('RID=' + inttostr(PERSON_R) +
        ' hat dieselben Kontodaten (Dublette?)!')
    else
      show;
  end;

end;

end.
