{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2022  Andreas Filsinger
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
  |    https://wiki.orgamon.org/
  |
}
unit AusgangsRechnungen;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, ComCtrls, Grids,
  ExtCtrls, StdCtrls, Mask,

  // IB-Objects
  IB_Grid, IB_Components, IB_SearchBar,
  IB_UpdateBar, IB_NavigationBar, IB_Controls,

  // tools
  anfix, Buttons, IB_Access;

type
  TFormAusgangsRechnungen = class(TForm)
    Panel1: TPanel;
    IB_Query1: TIB_Query;
    IB_Grid1: TIB_Grid;
    IB_DataSource1: TIB_DataSource;
    IB_UpdateBar1: TIB_UpdateBar;
    Button1: TButton;
    Button2: TButton;
    Panel2: TPanel;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Edit3: TEdit;
    Edit4: TEdit;
    Button4: TButton;
    IB_Memo1: TIB_Memo;
    Button9: TButton;
    IB_Query2: TIB_Query;
    IB_Query3: TIB_Query;
    Panel4: TPanel;
    Label2: TLabel;
    Edit5: TEdit;
    Label1: TLabel;
    IB_Query4: TIB_Query;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    StaticText5: TStaticText;
    SpeedButton13: TSpeedButton;
    Button3: TButton;
    Button5: TButton;
    Label4: TLabel;
    Edit6: TEdit;
    Button6: TButton;
    Button7: TButton;
    Button10: TButton;
    SpeedButton1: TSpeedButton;
    IB_ComboBox2: TIB_ComboBox;
    Label38: TLabel;
    SpeedButton3: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label3: TLabel;
    Button8: TButton;
    Edit1: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    StaticText1: TStaticText;
    Label8: TLabel;
    RadioGroup1: TRadioGroup;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure StaticText7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure IB_Query1ConfirmDelete(Sender: TComponent; var Confirmed: Boolean);
    procedure IB_Grid1GetDisplayText(Sender: TObject; ACol, ARow: Integer; var AString: string);
    procedure IB_Grid1CellGainFocus(Sender: TObject; ACol, ARow: Integer);
    procedure SpeedButton13Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private

    { Private-Deklarationen }
    PERSON_R: Integer;
    BELEG_R: Integer;

    Summe, Bar, RueckGeld: double;
    CloseIfzero: Boolean;
    RefreshBirth: dword;

    procedure SetContextCustomer(Kunde_RID: Integer);
    procedure refreshSumme;
  public
    { Public-Deklarationen }
    procedure EnsureOpen;
    procedure SetContext(Kunde_RID: Integer); overload;
    procedure SetContext(Kunde_RID: Integer; Beleg_RID: Integer; Betrag: double = 0.0); overload;
    procedure RefreshZahlungtypCombo;
    procedure ReflectData;
  end;

var
  FormAusgangsRechnungen: TFormAusgangsRechnungen;

implementation

uses
  globals, Person, Belege,
  dbOrgaMon, BelegSuche, ArtikelPOS,
  Funktionen_Basis,
  Funktionen_Buch,
  Funktionen_Beleg,
  Mahnung, gplists,
  CareServer, Geld, Datenbank,
  Buchhalter, wanfix;

{$R *.DFM}

procedure TFormAusgangsRechnungen.EnsureOpen;
begin
  if not(IB_Query1.Active) then
    IB_Query1.Open;
  if not(IB_Query2.Active) then
    IB_Query2.Open;
  if not(IB_Query3.Active) then
    IB_Query3.Open;
  if not(IB_Query4.Active) then
    IB_Query4.Open;
end;

procedure TFormAusgangsRechnungen.FormActivate(Sender: TObject);
begin
  // Alle 30 Min
  if frequently(RefreshBirth, 30 * 60 * 1000) then
  begin
    BeginHourGlass;
    RefreshZahlungtypCombo;
    EndHourGlass;
  end;
  EnsureOpen;
end;

procedure TFormAusgangsRechnungen.ReflectData;
begin
  RueckGeld := Bar - Summe;

  // Anzeigen
  if isHaben(RueckGeld) then
    StaticText1.Caption := format(cAnzeigeFormat_Geld, [RueckGeld])
  else
    StaticText1.Caption := '+++';
end;

procedure TFormAusgangsRechnungen.Button10Click(Sender: TObject);
begin
  Edit6.Text := '';
end;

procedure TFormAusgangsRechnungen.Button1Click(Sender: TObject);
begin
  if not(IB_Query1.FieldByName('KUNDE_R').IsNull) then
    FormPerson.SetContext(IB_Query1.FieldByName('KUNDE_R').AsInteger)
  else
    ShowMessage('Kein Datensatz im Moment angeklickt!');
end;

procedure TFormAusgangsRechnungen.Button2Click(Sender: TObject);
begin
  if not(IB_Query1.FieldByName('KUNDE_R').IsNull) then
    if not(IB_Query1.FieldByName('BELEG_R').IsNull) then
    begin
      FormBelege.SetContext(IB_Query1.FieldByName('KUNDE_R').AsInteger,
        IB_Query1.FieldByName('BELEG_R').AsInteger);
      exit;
    end;
  ShowMessage('Kein Datensatz im Moment angeklickt oder kein Beleg der Zahlung zugeordnet!');
end;

procedure TFormAusgangsRechnungen.Button3Click(Sender: TObject);
begin
  FormBuchhalter.SetContext(IB_Query1.FieldByName('RECHNUNG').AsInteger);
end;

procedure TFormAusgangsRechnungen.Button4Click(Sender: TObject);
var
  NewSql: TSQLStringList;
  NewLine: string;
  FirstAND: Boolean;
begin
  NewSql := TSQLStringList.create;
  NewSql.assign(IB_Query1.sql);

  NewLine := 'WHERE ';
  FirstAND := true;

  if (Edit3.Text <> '') then
  begin
    NewLine := NewLine + '(KUNDE_R=' + Edit3.Text + ')'#13;
    FirstAND := false;
  end;

  if (Edit4.Text <> '') then
  begin
    if not(FirstAND) then
      NewLine := NewLine + ' AND ';
    NewLine := NewLine + '(BELEG_R=' + Edit4.Text + ')' + #13;
    FirstAND := false;
  end;

  if (Edit6.Text <> '') then
  begin
    if not(FirstAND) then
      NewLine := NewLine + ' AND ';
    NewLine := NewLine + '(TEILLIEFERUNG=' + Edit6.Text + ')' + #13;
    FirstAND := false;
  end;

  if RadioButton1.checked then
  begin
    if not(FirstAND) then
      NewLine := NewLine + ' AND ';
    NewLine := NewLine + '(VORGANG=''' + cVorgang_Rechnung + ''')' + #13;
    FirstAND := false;
  end;

  if RadioButton2.checked then
  begin
    if not(FirstAND) then
      NewLine := NewLine + ' AND ';
    NewLine := NewLine + '((VORGANG<>''' + cVorgang_Rechnung + ''') or (VORGANG is null))' + #13;
    FirstAND := false;
  end;

  if FirstAND then
    NewSql.ReplaceBlock('where', '')
  else
    NewSql.ReplaceBlock('where', NewLine);

  IB_Query1.close;
  IB_Query1.sql.clear;
  IB_Query1.sql.AddStrings(NewSql);
  IB_Query1.Open;
  NewSql.free;

  refreshSumme;

end;

procedure TFormAusgangsRechnungen.Button5Click(Sender: TObject);
var
  cRIDs: TgpIntegerList;
begin
  // FormBuchhalter.SetContext(cKonto_Anzahlungen, IB_Query1.FieldByName('BELEG_R').AsInteger);

  cRIDs := e_r_sqlm('select RID from BUCH where ' +
    { } '(NAME=' + cKonto_Anzahlungen_AsDBString + ') and' +
    { } '(BELEG_R=' + IB_Query1.FieldByName('BELEG_R').AsString + ')');
  FormBuchhalter.SetContext(cRIDs);
  cRIDs.free;

end;

procedure TFormAusgangsRechnungen.Button6Click(Sender: TObject);
begin
  Edit4.Text := '';
end;

procedure TFormAusgangsRechnungen.Button7Click(Sender: TObject);
begin
  Edit3.Text := '';
end;

procedure TFormAusgangsRechnungen.Button8Click(Sender: TObject);
var
  _davonbezahlt: double; //
  _RestZahlung: double; //
  _AktuelleZahlung: double;
  // Ermittlung der zum Betrag passenden Teillieferung!
  cTL: TIB_Cursor;

  TEILLIEFERUNG: Integer;
  OFFEN: double;
  Konto: string;
  sDiagnose: TStringList;
begin
  TEILLIEFERUNG := cRID_Null;
  _AktuelleZahlung := cPreisRundung(Edit5.Text);

  if IsSomeMoney(_AktuelleZahlung) then
    if (str2int(Edit3.Text) >= cRID_FirstValid) then
    begin

      if (BELEG_R >= cRID_FirstValid) then
      begin

        // den passenden Teillieferungs Kandidaten mal ermitteln
        cTL := DataModuleDatenbank.nCursor;
        with cTL do
        begin
          sql.add('select');
          sql.add(' TEILLIEFERUNG,');
          sql.add(' LIEFERBETRAG,');
          sql.add(' (select');
          sql.add('   SUM(BETRAG)');
          sql.add('  from');
          sql.add('   AUSGANGSRECHNUNG');
          sql.add('  where');
          sql.add('   (BELEG_R=VERSAND.BELEG_R) and');
          sql.add('   (TEILLIEFERUNG=VERSAND.TEILLIEFERUNG)');
          sql.add('  ) as OFFEN');
          sql.add('from');
          sql.add(' VERSAND');
          sql.add('where');
          sql.add(' (BELEG_R=' + inttostr(BELEG_R) + ') and');
          sql.add(' (LIEFERBETRAG is not null)');
          sql.add('order by');
          sql.add(' TEILLIEFERUNG');
          ApiFirst;
          while not(eof) do
          begin
            //
            TEILLIEFERUNG := FieldByName('TEILLIEFERUNG').AsInteger;
            OFFEN := FieldByName('OFFEN').AsDouble;
            if IsSomeMoney(OFFEN) then
            begin
              if isSoll(OFFEN) then
              begin
                //
                if isZeroMoney(OFFEN + _AktuelleZahlung) then
                 break;
                if isSoll(OFFEN + _AktuelleZahlung) then
                 break;
              end
              else
              begin
                if isZeroMoney(OFFEN + _AktuelleZahlung) then
                 break;
                if isHaben(OFFEN + _AktuelleZahlung) then
                 break;
              end;
            end;
            apinext;
          end;
        end;

        cTL.free;

        // Beleg mal holen!
        IB_Query4.ParamByName('CROSSREF').AsInteger := BELEG_R;
        if IB_Query4.IsEmpty then
        begin
          ShowMessage('Angegebener Beleg nicht gefunden! Buchung nicht möglich!');
          exit;
        end;

        // bisherigen davon bezahlt holen!
        if not(IB_Query4.FieldByName('DAVON_BEZAHLT').IsNull) then
          _davonbezahlt := cPreisRundung(IB_Query4.FieldByName('DAVON_BEZAHLT').AsDouble)
        else
          _davonbezahlt := 0.0;

        _RestZahlung := cPreisRundung(IB_Query4.FieldByName('RECHNUNGS_BETRAG').AsDouble) -
          _davonbezahlt;

        if (_RestZahlung - _AktuelleZahlung >= cGeld_KleinsterBetrag) then
          if not(DoIt('Wollen Sie wirklich diese Teilzahlung buchen')) then
            exit;

        if (_AktuelleZahlung - _RestZahlung >= cGeld_KleinsterBetrag) then
          if not(DoIt('Hat der Kunde wirklich zuviel bezahlt')) then
            exit;

      end
      else
      begin
        if not(DoIt('Es ist keine Belegnummer angegeben.' + #13 +
          'Diese Zahlung kann dann keinem Beleg zugezuordnet werden.' + #13 + 'Wirklich buchen'))
        then
          exit;
      end;

      // Ursprung der Geldquelle wählen
      repeat

        // ohne besondere Ursprung / kein Rahmen vorhanden
        Konto := '';
        if RadioButton7.checked then
        begin
          RadioButton4.checked := true;
          break;
        end;

        // Forderungsverlust
        if RadioButton6.checked then
        begin
          if isKonto(cKonto_Forderungsverlust) then
          begin
            // wenn es bereits buchungen auf dem 1710er gibt!
            _AktuelleZahlung := b_w_ForderungsAusfall(BELEG_R, _AktuelleZahlung);
            Konto := cKonto_Forderungsverlust;
          end;
          RadioButton4.checked := true;
          break;
        end;

        // Kasse?
        if RadioButton4.checked then
         if isKonto(cKonto_Kasse) then
          Konto := cKonto_Kasse;

        // Kartenzahlung?
        if RadioButton5.checked then
        begin
          if isKonto(cKonto_EC) then
            Konto := cKonto_EC;
          RadioButton4.checked := true;
        end;

      until true;

      // Zahlung
      if IsSomeMoney(_AktuelleZahlung) then
      begin
        sDiagnose := TStringList.create;
        b_w_ForderungAusgleich(format(cBuch_Ausgleich, [
          { } PERSON_R,
          { } BELEG_R,
          { } _AktuelleZahlung,
          { } '',
          { } cRID_Null,
          { } '',
          { } Konto,
          { } TEILLIEFERUNG,
          { } cRID_Null]), sDiagnose);
        FormCareServer.ShowIfError(sDiagnose);
        sDiagnose.free;
      end;

      with IB_Query1 do
      begin

        // refresh ...
        formBelegSuche.IB_UpdateBar1.BtnClick(ubRefreshAll);

        Edit5.Text := '';
        Edit1.Text := '';
        IB_UpdateBar1.BtnClick(ubRefreshAll);
        refreshSumme;

        application.ProcessMessages;
        IB_Grid1.SetFocus;

      end;
    end;
end;

procedure TFormAusgangsRechnungen.SetContext(Kunde_RID: Integer);
begin
  BeginHourGlass;
  EnsureOpen;
  SetContextCustomer(Kunde_RID);
  Edit3.Text := inttostr(Kunde_RID);
  Edit4.Text := '';
  Edit5.Text := '';
  RadioButton1.checked := false;
  RadioButton2.checked := false;
  RadioButton4.Checked := true;
  Application.ProcessMessages;
  Button4Click(self);
  refreshSumme;
  IB_Query1.last;
  show;
  Edit5.SetFocus;
  EndHourGlass;
end;

procedure TFormAusgangsRechnungen.SetContext(Kunde_RID: Integer; Beleg_RID: Integer;
  Betrag: double);
begin
  BeginHourGlass;
  EnsureOpen;
  SetContextCustomer(Kunde_RID);
  Edit3.Text := inttostr(Kunde_RID);
  Edit4.Text := inttostr(Beleg_RID);
  RadioButton1.checked := false;
  RadioButton2.checked := false;
  RadioButton4.Checked := true;
  application.ProcessMessages;
  Button4Click(self);
  refreshSumme;

  if (Betrag = 0) then
    Edit5.Text := format('%.2f', [Summe])
  else
    Edit5.Text := format('%.2f', [Betrag]);

  IB_Query1.last;
  show;
  Edit5.SetFocus;
  EndHourGlass;
end;

procedure TFormAusgangsRechnungen.SetContextCustomer(Kunde_RID: Integer);
begin
  //
  PERSON_R := Kunde_RID;
  IB_Query2.ParamByName('CROSSREF').AsInteger := Kunde_RID;
  IB_Query3.ParamByName('CROSSREF').AsInteger := IB_Query2.FieldByName('PRIV_ANSCHRIFT_R')
    .AsInteger;
  Label1.caption := e_r_name(IB_Query2) + ' (' + IB_Query2.FieldByName('NUMMER').AsString + ') ' +
    HugeSingleLine(e_r_ort(IB_Query3),'|',3,true);
end;

procedure TFormAusgangsRechnungen.SpeedButton13Click(Sender: TObject);
begin
  refreshSumme;
end;

procedure TFormAusgangsRechnungen.SpeedButton1Click(Sender: TObject);
begin
  FormArtikelPOS.Schublade_Auf(iSchubladePort);
end;

procedure TFormAusgangsRechnungen.SpeedButton2Click(Sender: TObject);
var
  BELEG_R: Integer;
  TEILLIEFERUNG: Integer;
  Betrag: double;
  BUCH_R: Integer;
  AUSGANGSRECHNUNG_R: Integer;
  Konto: string;
begin

  with IB_Query1 do
  begin

    if (FieldByName('VORGANG').AsString = cVorgang_Rechnung) then
    begin

      // Forderung
      ShowMessage('Storno einer Forderung ist noch nicht programmiert!');
    end
    else
    begin

      // Zahlung stornieren
      if DoIt('Zahlung stornieren') then
      begin

        BeginHourGlass;

        //
        BELEG_R := FieldByName('BELEG_R').AsInteger;
        TEILLIEFERUNG := FieldByName('TEILLIEFERUNG').AsInteger;
        Betrag := FieldByName('BETRAG').AsDouble;
        BUCH_R := FieldByName('RECHNUNG').AsInteger;
        AUSGANGSRECHNUNG_R := FieldByName('RID').AsInteger;

        // Forderunsbetrag in dem Beleg wieder erhöhen
        e_x_sql(
          { } 'update BELEG set' +
          { } ' DAVON_BEZAHLT = DAVON_BEZAHLT + ' +
          { } FloatToStrISO(Betrag) + ' ' +
          { } 'where' +
          { } ' (RID=' + inttostr(BELEG_R) + ')');

        repeat

          if (BUCH_R < cRID_FirstValid) then
            break;

          Konto := e_r_sqls(
            { } 'select NAME from BUCH where RID=' +
            { } inttostr(BUCH_R));

          if (Konto = '') then
            break;

          // Nun bei der Person die ELV-Freigabe wieder hochsetzen
          if (Konto = cKonto_Bank) or (Konto = cKonto_Kasse) then
          begin

            // Buchung löschen
            b_w_DeleteBuch(BUCH_R);
            break;
          end;

          // unbar über ein Giro-Konto
          // oder eventuell über ein andere Kassenkonto
          b_w_reset(BUCH_R);

        until true;

        // Nun die Forderungszeile löschen
        e_x_sql('delete from AUSGANGSRECHNUNG where RID=' + inttostr(AUSGANGSRECHNUNG_R));

        Refresh;
        refreshSumme;
        EndHourGlass;
      end;
    end;
  end;
end;

procedure TFormAusgangsRechnungen.SpeedButton3Click(Sender: TObject);
begin
  RefreshZahlungtypCombo;
  IB_Query1.Refresh;
end;

procedure TFormAusgangsRechnungen.StaticText7Click(Sender: TObject);
begin
  Edit4.Text := '';
  Edit6.Text := '';
end;

procedure TFormAusgangsRechnungen.IB_Grid1CellGainFocus(Sender: TObject; ACol, ARow: Integer);
begin
  FormBelege.setShortCut(IB_DataSource1);
end;

procedure TFormAusgangsRechnungen.FormCreate(Sender: TObject);
begin
  StartDebug('AusgangsRechnungen');
  Label2.caption := FormatSettings.CurrencyString;
end;

procedure TFormAusgangsRechnungen.Button9Click(Sender: TObject);
var
  Bericht: TStringList;
begin
  Bericht := e_w_KontoInfo(PERSON_R);
  Bericht.free;
  openShell(e_r_MahnungFName(PERSON_R));
end;

procedure TFormAusgangsRechnungen.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    Bar := StrToDoubledef(Edit1.Text, 0);
    ReflectData;
  end;
  if (Key = #32) then
  begin
    Key := #0;
    Button8Click(Sender);
  end;
end;

procedure TFormAusgangsRechnungen.Edit5KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    Summe := StrToDoubledef(Edit5.Text, 0);
    Edit1.SetFocus;
  end;
end;

procedure TFormAusgangsRechnungen.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  BELEG_R := IB_Query1.FieldByName('BELEG_R').AsInteger;
end;

procedure TFormAusgangsRechnungen.IB_Query1ConfirmDelete(Sender: TComponent;
  var Confirmed: Boolean);
begin
  with Sender as TIB_Dataset do
    Confirmed := DoIt('Buchung über ' + #13 + format('%m', [FieldByName('BETRAG').AsDouble]) + #13 +
      'wirklich löschen');
end;

procedure TFormAusgangsRechnungen.refreshSumme;
var
  LastSet: dword;
  RecN: Integer;
begin
  BeginHourGlass;
  Summe := 0.0;
  enabled := false;
  LastSet := 0;
  RecN := 0;
  with IB_Query1 do
  begin
    DisableControls;
    first;
    while not(eof) do
    begin
      inc(RecN);
      Summe := Summe + FieldByName('BETRAG').AsFloat;
      next;
    end;
    EnableControls;
  end;
  enabled := true;
  StaticText5.caption := format(cAnzeigeFormat_Geld, [abs(Summe)]);
  if (Summe <= 0) then
    StaticText5.Color := cllime
  else
    StaticText5.Color := clred;

  Bar := 0;
  edit1.TexT := '';
  reflectData;


  if (Summe = 0) and CloseIfzero then
    close;
  EndHourGlass;
end;

procedure TFormAusgangsRechnungen.RefreshZahlungtypCombo;
var
  cZAHLUNGTYP: TIB_Cursor;
begin
  with IB_ComboBox2 do
  begin
    Items.clear;
    Itemvalues.clear;
    Items.add('- Standard -');
    Itemvalues.add('');
    cZAHLUNGTYP := DataModuleDatenbank.nCursor;
    with cZAHLUNGTYP do
    begin
      sql.add(
        { } 'select RID,BEZEICHNUNG from ZAHLUNGTYP ' +
        { } 'where ' +
        { } ' (AUTOZAHLUNG is null) or' +
        { } ' (AUTOZAHLUNG=' + cC_False_AsString + ') ' +
        { } 'order by ' +
        { } ' BEZEICHNUNG');
      ApiFirst;
      while not(eof) do
      begin
        Items.add(FieldByName('BEZEICHNUNG').AsString);
        Itemvalues.add(FieldByName('RID').AsString);
        apinext;
      end;
    end;
    ItemIndex := 0;
    cZAHLUNGTYP.free;
  end;
end;

procedure TFormAusgangsRechnungen.IB_Grid1GetDisplayText(Sender: TObject; ACol, ARow: Integer;
  var AString: string);
begin
  if (ARow > 0) then
    if (ACol = 6) then
      if (AString <> '') then
        AString := format('%m', [strtodoubledef(AString, 0.0)]);
end;

end.
