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
unit BuchBarKasse;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

const
  cBarKasse_AnzahlKonten = 6;

type
  TFormBuchBarKasse = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    StaticText1: TStaticText;
    Edit2: TEdit;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    Panel1: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Button1: TButton;
    Button2: TButton;
    SpeedButton12: TSpeedButton;
    Edit7: TEdit;
    Label14: TLabel;
    StaticText7: TStaticText;
    Label15: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    Edit8: TEdit;
    StaticText8: TStaticText;
    Panel7: TPanel;
    SpeedButton1: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit7KeyPress(Sender: TObject; var Key: Char);
    procedure Edit8KeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    Konten: TStringList;
    BetragN: array [1 .. cBarKasse_AnzahlKonten] of double;
    Bar: double;
    Summe: double;
    RueckGeld: double;

    procedure ReflectData;
    procedure ReflectKonten;
    procedure BetragInp(const editBetrag, editNext: TEdit;
      BetragIndex: integer);
  public
    { Public-Deklarationen }
    procedure setContext;
    procedure Clear;
  end;

var
  FormBuchBarKasse: TFormBuchBarKasse;

implementation

uses
  anfix32, globals,
  IBExportTable,
  Funktionen.Basis,
  Funktionen.Beleg,
  Funktionen.Buch,
  IB_Components, IB_Access,
  CareServer, Geld, Datenbank, ArtikelPOS;

{$R *.dfm}

const
  cMoneyFormat = '%m ';

procedure TFormBuchBarKasse.BetragInp(const editBetrag, editNext: TEdit;
  BetragIndex: integer);
var
  Betrag: double;
begin

  if (editBetrag.Text = '') then
  begin
    editNext.SetFocus;
    exit;
  end;

  if (editBetrag.Text = '0') then
  begin
    BetragN[BetragIndex] := 0;
  end;

  Betrag := StrToDoubledef(editBetrag.Text, 0);

  BetragN[BetragIndex] := BetragN[BetragIndex] + Betrag;
  editBetrag.Text := '';
  ReflectData;

end;

procedure TFormBuchBarKasse.Button1Click(Sender: TObject);
var
  qBUCH: TIB_Query;
  BUCH_R: integer;
  sDiagnose: TStringList;
  InfoText: TStringList;
  ScriptText: TStringList;
  n: integer;
  WasError: boolean;
  WasSumme: double;
begin
  if isSomeMoney(Summe) then
  begin
    WasSumme := Summe;
    Summe := 0;

    Button1.Enabled := false;
    BeginHourGlass;

    WasError := true;
    sDiagnose := TStringList.create;
    ScriptText := TStringList.create;
    InfoText := TStringList.create;
    qBUCH := DataModuleDatenbank.nQuery;

    // Name und Info in dieser Buchung
    InfoText.add(Edit1.Text);
    InfoText.add(format('%m gegeben (%m zurück)', [Bar, RueckGeld]));

    // technische Buchungsinfos
    ScriptText.add('Schema=Folge');
    for n := 1 to cBarKasse_AnzahlKonten do
      if (BetragN[n] <> 0) then
        ScriptText.add(format('BETRAG=%.2f;%s',
          [BetragN[n], nextp(Konten[pred(n)], ' ', 0)]));

    with qBUCH do
    begin
      BUCH_R := e_w_gen('GEN_BUCH');
      sql.add('select * from BUCH for update');

      //
      insert;
      FieldByName('RID').AsInteger := BUCH_R;
      FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
      FieldByName('DATUM').AsDateTime := now;
      FieldByName('NAME').AsString := cKonto_Kasse;
      FieldByName('GEGENKONTO').AsString := cKonto_Erloese;
      FieldByName('ERTRAG').AsString := cC_True;
      FieldByName('BETRAG').AsDouble := cPreisRundung(WasSumme);
      FieldByName('TEXT').Assign(InfoText);
      FieldByName('SKRIPT').Assign(ScriptText);
      post;

      b_w_buche(BUCH_R, sDiagnose);
      EndHourGlass;
      WasError := FormCareServer.ShowIfError(sDiagnose);
      BeginHourGlass;
    end;
    qBUCH.free;
    InfoText.free;
    sDiagnose.free;
    ScriptText.free;
    if not(WasError) then
    begin
      close;
    end;
    Button1.Enabled := true;
    EndHourGlass;
  end;
end;

procedure TFormBuchBarKasse.Button2Click(Sender: TObject);
begin
  if (Edit1.Text <> '') or (Edit2.Text <> '') or (Edit3.Text <> '') or
    (Edit4.Text <> '') or (Edit5.Text <> '') or (Edit6.Text <> '') or
    (Edit7.Text <> '') or (Edit8.Text <> '') then
  begin
    Clear;
    Edit1.SetFocus;
    ReflectData;
  end
  else
  begin
    close;
  end;
end;

procedure TFormBuchBarKasse.Clear;
var
  n: integer;
begin
  for n := 1 to cBarKasse_AnzahlKonten do
    BetragN[n] := 0;

  Bar := 0;
  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
  Edit4.Text := '';
  Edit5.Text := '';
  Edit6.Text := '';
  Edit7.Text := '';
  Edit8.Text := '';
end;

procedure TFormBuchBarKasse.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    Edit3.SetFocus;
  end;
end;

procedure TFormBuchBarKasse.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Bar := StrToDoubledef(Edit2.Text, 0);
    ReflectData;
  end;
  if Key = #32 then
  begin
    Key := #0;
    Button1Click(Sender);
  end;
end;

procedure TFormBuchBarKasse.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    BetragInp(Edit3, Edit4, 1);
  end;
end;

procedure TFormBuchBarKasse.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    BetragInp(Edit4, Edit5, 2);
  end;
end;

procedure TFormBuchBarKasse.Edit5KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    BetragInp(Edit5, Edit6, 3);
  end;
end;

procedure TFormBuchBarKasse.Edit6KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    BetragInp(Edit6, Edit7, 4);
  end;
end;

procedure TFormBuchBarKasse.Edit7KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    BetragInp(Edit7, Edit8, 5);
  end;
end;

procedure TFormBuchBarKasse.Edit8KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    BetragInp(Edit8, Edit2, 6);
  end;
end;

procedure TFormBuchBarKasse.FormActivate(Sender: TObject);
begin
  if not(assigned(Konten)) then
    ReflectKonten;
end;

procedure TFormBuchBarKasse.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    Button2Click(Sender);
  end;
end;

procedure TFormBuchBarKasse.ReflectData;
begin
  // Berechnungen
  Summe := BetragN[1] + BetragN[2] + BetragN[3] + BetragN[4] + BetragN[5] +
    BetragN[6];
  RueckGeld := Bar - Summe;

  // Anzeigen
  StaticText3.Caption := format(cMoneyFormat, [BetragN[1]]);
  StaticText4.Caption := format(cMoneyFormat, [BetragN[2]]);
  StaticText5.Caption := format(cMoneyFormat, [BetragN[3]]);
  StaticText6.Caption := format(cMoneyFormat, [BetragN[4]]);
  StaticText7.Caption := format(cMoneyFormat, [BetragN[5]]);
  StaticText8.Caption := format(cMoneyFormat, [BetragN[6]]);
  StaticText1.Caption := format(cMoneyFormat, [Summe]);
  if (RueckGeld > 0) then
    StaticText2.Caption := format(cMoneyFormat, [RueckGeld])
  else
    StaticText2.Caption := '+++';
end;

procedure TFormBuchBarKasse.ReflectKonten;
var
  n: integer;
begin
  BeginHourGlass;
  if assigned(Konten) then
    FreeAndNil(Konten);

  Konten := e_r_sqlsl
    ('select distinct SORTIMENT.KONTO||'' - ''||BUCH.KONTO as KONTO ' +
    'from SORTIMENT ' + 'join BUCH on' + ' (BUCH.NAME=SORTIMENT.KONTO) and' +
    ' (BUCH.BETRAG is null) and' + ' (BUCH.SKRIPT not like ''%BAR=NEIN%'')' +
    'where ' + ' (SORTIMENT.KONTO is not null) ' + 'order by' +
    ' SORTIMENT.KONTO');

  for n := Konten.count to cBarKasse_AnzahlKonten do
    Konten.add(cKonto_Erloese + ' - Erlöse');

  Label6.Caption := Konten[0];
  Label7.Caption := Konten[1];
  Label8.Caption := Konten[2];
  Label9.Caption := Konten[3];
  Label14.Caption := Konten[4];
  Label16.Caption := Konten[5];
  EndHourGlass;
end;

procedure TFormBuchBarKasse.setContext;
begin
  Clear;
  show;
  Edit1.SetFocus;
  ReflectData;
end;

procedure TFormBuchBarKasse.SpeedButton12Click(Sender: TObject);
begin
  ReflectKonten;
  Showmessage(HugeSingleLine(Konten));
end;

procedure TFormBuchBarKasse.SpeedButton1Click(Sender: TObject);
begin
 FormArtikelPOS.Schublade_Auf(iSchubladePort);
end;

end.
