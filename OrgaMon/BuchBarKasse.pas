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
    Button3: TButton;
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
    procedure Button1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button3Click(Sender: TObject);
  private

    // Caching Elemente
    Konten: TStringList;
    KontoNummern: TStringList;
    MwStN: array [1 .. cBarKasse_AnzahlKonten] of double;

    // GUI Elemente
    Titel: string;
    BetragN: array [1 .. cBarKasse_AnzahlKonten] of double;
    Bar: double;

    // Berechnete Elemente
    Summe: double;
    RueckGeld: double;

    // Context Elements
    TICKET_R: Integer;

    // Einstellungen
    KassenStation: boolean;

    procedure ReflectBuchungsTaste;
    procedure ReflectData;
    procedure EnsureKonten;
    procedure BetragInp(const editBetrag, editNext: TEdit;
      BetragIndex: Integer);
    procedure Buche;
    procedure Speichere;
  public
    { Public-Deklarationen }
    function toStringList: TStringList;

    procedure setContext(BELEG_R: Integer = 0); overload;
    procedure setContext(fromString: TStringList); overload;
    procedure Clear;
    procedure Swap;
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
  BetragIndex: Integer);
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

procedure TFormBuchBarKasse.Buche;
var
  qBUCH: TIB_Query;
  BUCH_R: Integer;
  sDiagnose: TStringList;
  InfoText: TStringList;
  ScriptText: TStringList;
  n: Integer;
  WasError: boolean;
  WasSumme: double;
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
    if isSomeMoney(BetragN[n]) then
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
    close;
  Button1.Enabled := true;
  EndHourGlass;

end;

procedure TFormBuchBarKasse.Speichere;
var
  KasseBeleg: TStringList;
  qTICKET: TIB_Query;
begin
  if (TICKET_R < cRID_FirstValid) then
  begin
    // Neuanlage
    TICKET_R := e_w_gen('GEN_TICKET');
    KasseBeleg := toStringList;
    qTICKET := nQuery;
    with qTICKET do
    begin
      sql.add('select RID,ART,INFO from TICKET for update');
      insert;
      FieldByName('RID').AsInteger := TICKET_R;
      FieldByName('ART').AsInteger := eT_KassenBeleg;
      FieldByName('INFO').Assign(KasseBeleg);
      post;
    end;
    qTICKET.free;
  end
  else
  begin
    // Update
    qTICKET := nQuery;
    with qTICKET do
    begin
      sql.add('select INFO from TICKET where RID=' + inttostr(TICKET_R) +
        ' for update');
      edit;
      FieldByName('INFO').Assign(KasseBeleg);
      post;
    end;
    qTICKET.free;
  end;
end;

procedure TFormBuchBarKasse.Button1Click(Sender: TObject);
begin
  if isSomeMoney(Summe) then
  begin
    if KassenStation then
      Buche
    else
      Speichere;
  end;
end;

procedure TFormBuchBarKasse.Button1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbRight) then
    Swap;
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

procedure TFormBuchBarKasse.Button3Click(Sender: TObject);
begin
  if isSomeMoney(Summe) then
  begin
    if KassenStation then
      Speichere
    else
      Buche
  end;
end;

procedure TFormBuchBarKasse.Clear;
var
  n: Integer;
begin
  for n := 1 to cBarKasse_AnzahlKonten do
    BetragN[n] := 0;
  Bar := 0;
  Summe := 0;
  RueckGeld := 0;
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
  EnsureKonten;
  ReflectBuchungsTaste;
end;

procedure TFormBuchBarKasse.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Key := #0;
    Button2Click(Sender);
  end;
end;

procedure TFormBuchBarKasse.ReflectBuchungsTaste;
begin
  case KassenStation of
    true:
      begin
        Button1.Caption := '*';
        Button3.Caption := 'C';
      end;
    false:
      begin
        Button1.Caption := 'C';
        Button3.Caption := '*';
      end;
  end;
end;

procedure TFormBuchBarKasse.ReflectData;
begin
  // Berechnungen
  Summe := BetragN[1] + BetragN[2] + BetragN[3] + BetragN[4] + BetragN[5] +
    BetragN[6];
  RueckGeld := Bar - Summe;
  Titel := Edit1.Text;

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

procedure TFormBuchBarKasse.EnsureKonten;
var
  n: Integer;
  Konto: string;
begin
  if not(assigned(Konten)) then
  begin
    BeginHourGlass;

    KontoNummern := TStringList.create;
    Konten := e_r_sqlsl(
      { } 'select distinct SORTIMENT.KONTO||'' - ''||BUCH.KONTO as KONTO ' +
      { } 'from SORTIMENT ' +
      { } 'join BUCH on' +
      { } ' (BUCH.NAME=SORTIMENT.KONTO) and' +
      { } ' (BUCH.BETRAG is null) and' +
      { } ' (BUCH.SKRIPT not like ''%BAR=NEIN%'')' +
      { } 'where ' +
      { } ' (SORTIMENT.KONTO is not null) ' +
      { } 'order by' +
      { } ' SORTIMENT.KONTO');

    // Auffüllen auf zumindest "cBarKasse_AnzahlKonten" Konten
    for n := Konten.Count to cBarKasse_AnzahlKonten do
      Konten.add(cKonto_Erloese + ' - Erlöse');

    // "KontoNummern" den "Konten" zur Seite stellen
    for n := 0 to pred(Konten.Count) do
    begin
      Konto := nextp(Konten[n], ' ', 0);
      KontoNummern.add(Konto);
      if (n < cBarKasse_AnzahlKonten) then
        MwStN[succ(n)] := b_r_MwST(Konto);
    end;

    // die ersten "cBarKasse_AnzahlKonten"
    Label6.Caption := Konten[0];
    Label7.Caption := Konten[1];
    Label8.Caption := Konten[2];
    Label9.Caption := Konten[3];
    Label14.Caption := Konten[4];
    Label16.Caption := Konten[5];

    EndHourGlass;
  end;
end;

procedure TFormBuchBarKasse.setContext(BELEG_R: Integer = 0);
var
  cPosten: TIB_Cursor;
  ARTIKEL: string;
  Konto: string;
  Konto_Index: Integer;
  EinzelpreisNetto: boolean;
  _Anz, _AnzAuftrag, _AnzGeliefert, _AnzStorniert, _AnzAgent: Integer;
  _Rabatt, _EinzelPreis, _MwStSatz: double;
  _PreisProPosition: double;
  NameSet, KontoSet: boolean;
  n: Integer;
begin
  // Werte zurücksetzen
  BeginHourGlass;
  Clear;
  NameSet := false;

  if (BELEG_R >= cRID_FirstValid) then
  begin
    EnsureKonten;
    EinzelpreisNetto :=
      (e_r_sqls('select EINZELPREIS_NETTO from BELEG where RID=' +
      inttostr(BELEG_R)) = cC_True);
    cPosten := nCursor;
    with cPosten do
    begin
      sql.add('select');
      sql.add(' POSTEN.ARTIKEL,');
      sql.add(' POSTEN.ARTIKEL_R,');
      sql.add(' POSTEN.AUSGABEART_R,');
      sql.add(' POSTEN.EINHEIT_R,');
      sql.add(' POSTEN.MENGE,');
      sql.add(' POSTEN.MENGE_RECHNUNG,');
      sql.add(' POSTEN.MENGE_AUSFALL,');
      sql.add(' POSTEN.MENGE_GELIEFERT,');
      sql.add(' POSTEN.MENGE_AGENT,');
      sql.add(' POSTEN.MWST,');
      sql.add(' POSTEN.NETTO,');
      sql.add(' POSTEN.RABATT,');
      sql.add(' POSTEN.PREIS,');
      sql.add(' SORTIMENT.KONTO');
      sql.add('from POSTEN');
      sql.add('left join ARTIKEL on');
      sql.add(' (POSTEN.ARTIKEL_R=ARTIKEL.RID)');
      sql.add('left join SORTIMENT on');
      sql.add(' (ARTIKEL.SORTIMENT_R=SORTIMENT.RID)');
      sql.add('where');
      sql.add(' (POSTEN.BELEG_R=' + inttostr(BELEG_R) + ')');
      sql.add('order by');
      sql.add(' POSTEN.POSNO,POSTEN.RID');
      ApiFirst;
      while not(eof) do
      begin
        // um welche Zeile gehts?
        ARTIKEL := FieldByName('ARTIKEL').AsString;

        // den Brutto Preis und die zugehörige Kontonummer berechnen

        e_r_PostenInfo(cPosten, false, EinzelpreisNetto, _Anz, _AnzAuftrag,
          _AnzGeliefert, _AnzStorniert, _AnzAgent, _Rabatt, _EinzelPreis,
          _MwStSatz);
        _PreisProPosition := e_c_Rabatt(e_r_PostenPreis(_EinzelPreis, _Anz,
          FieldByName('EINHEIT_R').AsInteger), _Rabatt);

        if isSomeMoney(_PreisProPosition) then
        begin

          repeat

            // Über Konto und passender MwST-Satz suchen
            Konto := FieldByName('KONTO').AsString;
            Konto_Index := KontoNummern.IndexOf(Konto);
            if (Konto_Index <> -1) then
            begin
              if (MwStN[Konto_Index + 1] = _MwStSatz) then
              begin
                BetragN[Konto_Index + 1] := BetragN[Konto_Index + 1] +
                  _PreisProPosition;
                break;
              end;
            end;

            // über den MWST Satz suchen
            KontoSet := false;
            for n := cBarKasse_AnzahlKonten downto 1 do
              if (MwStN[n] = _MwStSatz) then
              begin
                BetragN[n] := BetragN[n] + _PreisProPosition;
                KontoSet := true;
                break;
              end;
            if KontoSet then
              break;

            ShowMessage('Fehler: "' + ARTIKEL +
              '" konnte nicht zugeordnet werden!');

          until true;
        end
        else
        begin
          if not(NameSet) then
            if (ARTIKEL <> '') then
            begin
              Edit1.Text := ARTIKEL;
              NameSet := true;
            end;

        end;
        ApiNext;
      end;
      close;
    end;
    cPosten.free;

  end;

  // Anzeigen
  ReflectData;
  Show;
  if NameSet then
    Edit2.SetFocus
  else
    Edit1.SetFocus;
  EndHourGlass;

end;

procedure TFormBuchBarKasse.setContext(fromString: TStringList);
var
  n: Integer;
begin
  BeginHourGlass;
  Clear;
  with fromString do
  begin
    Titel := Values['Titel'];
    for n := 1 to cBarKasse_AnzahlKonten do
      BetragN[n] := StrToMoneyDef(Values['Betrag' + inttostr(n)]);
    Bar := StrToMoneyDef(Values['Bar']);
    TICKET_R := StrToIntDef(Values['TICKET_R'], cRID_Unset);
  end;
  ReflectData;
  Show;
  Edit2.SetFocus;
  EndHourGlass;
end;

procedure TFormBuchBarKasse.SpeedButton12Click(Sender: TObject);
begin

  // refresh Kontoinfo
  FreeAndNil(Konten);
  FreeAndNil(KontoNummern);
  EnsureKonten;

  // Infos über alle Konten
  ShowMessage(HugeSingleLine(Konten));
end;

procedure TFormBuchBarKasse.SpeedButton1Click(Sender: TObject);
begin
  FormArtikelPOS.Schublade_Auf(iSchubladePort);
end;

procedure TFormBuchBarKasse.Swap;
begin
  KassenStation := not(KassenStation);
  ReflectBuchungsTaste;
end;

function TFormBuchBarKasse.toStringList: TStringList;
var
  n: Integer;
begin
  result := TStringList.create;
  with result do
  begin
    Values['Titel'] := Titel;
    for n := 1 to cBarKasse_AnzahlKonten do
      Values['Betrag' + inttostr(n)] := MoneyToStr(BetragN[n]);
    Values['Bar'] := MoneyToStr(Bar);
    Values['TICKET_R'] := inttostr(TICKET_R);
  end;
end;

end.
