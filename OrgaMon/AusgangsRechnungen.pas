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
  anfix32, Buttons, IB_Access;

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
    Button8: TButton;
    Edit5: TEdit;
    Label1: TLabel;
    IB_Query4: TIB_Query;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    StaticText5: TStaticText;
    SpeedButton13: TSpeedButton;
    CheckBox1: TCheckBox;
    Button3: TButton;
    Button5: TButton;
    Label4: TLabel;
    Edit6: TEdit;
    Button6: TButton;
    Button7: TButton;
    Button10: TButton;
    SpeedButton1: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure StaticText7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure IB_Query1ConfirmDelete(Sender: TComponent;
      var Confirmed: Boolean);
    procedure IB_Grid1GetDisplayText(Sender: TObject; ACol, ARow: Integer;
      var AString: string);
    procedure IB_Grid1CellGainFocus(Sender: TObject; ACol, ARow: Integer);
    procedure SpeedButton13Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure SpeedButton1Click(Sender: TObject);
  private

    { Private-Deklarationen }
    PERSON_R: integer;
    BELEG_R: integer;

    Summe: double;
    CloseIfzero: boolean;

    procedure SetContextCustomer(Kunde_RID: integer);
    procedure refreshSumme;
  public
    { Public-Deklarationen }
    procedure EnsureOpen;
    procedure SetContext(Kunde_RID: integer); overload;
    procedure SetContext(Kunde_RID: integer; Beleg_RID: integer; Betrag: double = 0.0); overload;
  end;

var
  FormAusgangsRechnungen: TFormAusgangsRechnungen;

implementation

uses
  globals, Person, Belege,
  IBExportTable, BelegSuche, ArtikelPOS,
  Funktionen_Basis,
  Funktionen_Buch,
  Funktionen_Beleg,
  Mahnung, gplists,
  CareServer, Geld, Datenbank,
  Buchhalter, wanfix32;

{$R *.DFM}

procedure TFormAusgangsRechnungen.EnsureOpen;
begin
  if not (IB_Query1.Active) then
    IB_Query1.Open;
  if not (IB_Query2.Active) then
    IB_Query2.Open;
  if not (IB_Query3.Active) then
    IB_Query3.Open;
  if not (IB_Query4.Active) then
    IB_Query4.Open;
end;

procedure TFormAusgangsRechnungen.FormActivate(Sender: TObject);
begin
  EnsureOpen;
end;

procedure TFormAusgangsRechnungen.Button10Click(Sender: TObject);
begin
 edit6.Text := '';
end;

procedure TFormAusgangsRechnungen.Button1Click(Sender: TObject);
begin
  if not (IB_Query1.FieldByName('KUNDE_R').IsNull) then
    FormPerson.SetContext(IB_Query1.FieldByName('KUNDE_R').AsInteger)
  else
    ShowMessage('Kein Datensatz im Moment angeklickt!');
end;

procedure TFormAusgangsRechnungen.Button2Click(Sender: TObject);
begin
  if not (IB_Query1.FieldByName('KUNDE_R').IsNull) then
    if not (IB_Query1.FieldByName('BELEG_R').IsNull) then
    begin
      FormBelege.SetContext(IB_Query1.FieldByName('KUNDE_R').AsInteger, IB_Query1.FieldByName('BELEG_R').AsInteger);
      exit;
    end;
  ShowMessage('Kein Datensatz im Moment angeklickt oder kein Beleg der Zahlung zugeordnet!');
end;

procedure TFormAusgangsRechnungen.Button3Click(Sender: TObject);
begin
 FormBuchhalter.setContext(IB_Query1.FieldByName('RECHNUNG').AsInteger);
end;

procedure TFormAusgangsRechnungen.Button4Click(Sender: TObject);
var
  NewSql: TSQLStringList;
  NewLine: string;
  FirstAND: boolean;
begin
  NewSql := TSQLStringList.create;
  NewSql.assign(IB_Query1.sql);

  NewLine := 'WHERE ';
  FirstAND := true;

  if (edit3.Text <> '') then
  begin
    NewLine := NewLine + '(KUNDE_R=' + edit3.Text + ')'#13;
    FirstAND := false;
  end;

  if (edit4.Text <> '') then
  begin
    if not (FirstAND) then
      NewLine := NewLine + ' AND ';
    NewLine := NewLine + '(BELEG_R=' + edit4.Text + ')' + #13;
    FirstAND := false;
  end;

  if (edit6.Text <> '') then
  begin
    if not (FirstAND) then
      NewLine := NewLine + ' AND ';
    NewLine := NewLine + '(TEILLIEFERUNG=' + edit6.Text + ')' + #13;
    FirstAND := false;
  end;

  if RadioButton1.checked then
  begin
    if not (FirstAND) then
      NewLine := NewLine + ' AND ';
    NewLine := NewLine + '(VORGANG='''+cVorgang_Rechnung+''')' + #13;
    FirstAND := false;
  end;

  if RadioButton2.checked then
  begin
    if not (FirstAND) then
      NewLine := NewLine + ' AND ';
    NewLine := NEWLINE + '((VORGANG<>'''+cVorgang_Rechnung+''') or (VORGANG is null))'+#13;
    FirstAND := false;
  end;

  if FirstAND then
    NewSql.ReplaceBlock('where', '')
  else
    NewSql.ReplaceBlock('where', NewLine);

  IB_Query1.close;
  IB_Query1.sql.clear;
  IB_Query1.sql.AddStrings(NewSQL);
  IB_Query1.Open;
  NewSql.free;

  refreshSumme;

end;

procedure TFormAusgangsRechnungen.Button5Click(Sender: TObject);
begin
 FormBuchhalter.setContext(cKonto_Anzahlungen,IB_Query1.FieldByName('BELEG_R').AsInteger);
end;

procedure TFormAusgangsRechnungen.Button6Click(Sender: TObject);
begin
 edit4.text := '';
end;

procedure TFormAusgangsRechnungen.Button7Click(Sender: TObject);
begin
 edit3.TExt := '';
end;

procedure TFormAusgangsRechnungen.SetContext(Kunde_rid: integer);
begin
  BeginHourGLass;
  EnsureOpen;
  SetContextCustomer(Kunde_RID);
  edit3.Text := inttostr(Kunde_rid);
  edit4.Text := '';
  edit5.Text := '';
  RadioButton1.Checked := false;
  RadioButton2.Checked := false;
  CheckBox1.Checked := false;

  application.ProcessMessages;
  Button4Click(self);
  refreshSumme;
  IB_Query1.last;
  show;
  EndHourGLass;
end;

procedure TFormAusgangsRechnungen.SetContext(Kunde_RID: integer; Beleg_RID: integer; Betrag: double);
begin
  BeginHourGLass;
  EnsureOpen;
  SetContextCustomer(Kunde_RID);
  edit3.Text := inttostr(Kunde_rid);
  edit4.Text := inttostr(Beleg_RID);
  RadioButton1.Checked := false;
  RadioButton2.Checked := false;
  CheckBox1.Checked := false;
  application.ProcessMessages;
  Button4Click(self);
  refreshSumme;

  if (Betrag = 0) then
    edit5.Text := format('%.2f', [Summe])
  else
    edit5.Text := format('%.2f', [betrag]);

  IB_Query1.last;
  show;
  Button8.SetFocus;
  EndHourGLass;
end;

procedure TFormAusgangsRechnungen.Button8Click(Sender: TObject);
var
  _davonbezahlt: double; //
  _RestZahlung: double; //
  _AktuelleZahlung: double;
  // Ermittlung der zum Betrag passenden Teillieferung!
  cTL: TIB_Cursor;

  TEILLIEFERUNG: integer;
  OFFEN: double;
  Konto: string;
  sDiagnose: TStringList;
begin
  TEILLIEFERUNG := cRID_Null;

  // ist ein Kunde gesetzt
  _AktuelleZahlung := cPreisRundung(edit5.Text);

  if IsSomeMoney(_AktuelleZahlung) then
    if (str2int(edit3.Text) >= cRID_FirstValid) then
    begin

      if (Beleg_R >= cRID_FirstValid) then
      begin

        // Teillieferungs Kandidaten mal ermitteln

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
          sql.add(' (BELEG_R='+inttostr(Beleg_R)+') and');
          sql.add(' (LIEFERBETRAG is not null)');
          sql.add('order by');
          sql.add(' TEILLIEFERUNG');
          ApiFirst;
          while not (eof) do
          begin
              //
            TEILLIEFERUNG := FieldByName('TEILLIEFERUNG').AsInteger;
            OFFEN := FieldByName('OFFEN').AsDouble;
            if isSomeMoney(OFFEN) then
            begin
              if OFFEN<0 then
              begin
                //
                if OFFEN+_AktuelleZahlung<=0 then
                 break;
              end else
              begin
                if OFFEN+_AktuelleZahlung>=0 then
                 break;
              end;
            end;
            apinext;
          end;
        end;


        cTL.free;

        // Beleg mal holen!
        IB_Query4.ParamByName('CROSSREF').AsInteger := Beleg_R;
        if IB_Query4.IsEmpty then
        begin
          ShowMessage('Angegebener Beleg nicht gefunden! Buchung nicht möglich!');
          exit;
        end;

        // bisherigen davon bezahlt holen!
        if not (IB_Query4.FieldByName('DAVON_BEZAHLT').IsNull) then
          _davonbezahlt := cPreisRundung(IB_Query4.FieldByName('DAVON_BEZAHLT').AsDouble)
        else
          _davonbezahlt := 0.0;

        _RestZahlung := cPreisRundung(IB_Query4.FieldByName('RECHNUNGS_BETRAG').AsDouble) - _davonbezahlt;

        if (_RestZahlung - _AktuelleZahlung >= cGeld_KleinsterBetrag) then
          if not (DoIt('Wollen Sie wirklich diese Teilzahlung buchen')) then
            exit;

        if (_AktuelleZahlung - _RestZahlung >= cGeld_KleinsterBetrag) then
          if not (DoIt('Hat der Kunde wirklich zuviel bezahlt')) then
            exit;

      end else
      begin
        if not (doit('Es ist keine Belegnummer angegeben.' + #13 +
          'Diese Zahlung kann dann keinem Beleg zugezuordnet werden.' + #13 +
          'Wirklich buchen')) then
          exit;
      end;

      // auf Kasse buchen, nur wenn es existiert!
      repeat
        Konto := '';
        if CheckBox1.Checked then
        begin
          CheckBox1.Checked := false;
          break;
        end;
        if (e_r_sql('select count(RID) from BUCH where (BETRAG is null) and NAME='''+cKonto_Kasse+'''')>0) then
          Konto := cKonto_Kasse
      until true;

      // Jetzt den ganzen Rattenschwanz buchen
      sDiagnose := TStringList.create;
      b_w_ForderungAusgleich(
        format(cBuch_Ausgleich,
        [PERSON_R,
        BELEG_R,
        _AktuelleZahlung,
        '',
        cRID_Null,
        '',
        Konto,
        TEILLIEFERUNG,
        cRID_Null]), sDiagnose);
      FormCareServer.ShowIfError(sDiagnose);
      sDiagnose.free;

      // Zahlung jetzt buchen
      with IB_Query1 do
      begin

        // refresh ...
        formBelegSuche.IB_UpdateBar1.BtnClick(ubRefreshAll);

        edit5.Text := '';
        IB_UpdateBar1.BtnClick(ubRefreshAll);
        refreshSumme;


        application.processmessages;
        IB_grid1.SetFocus;

      end;
    end;
end;

procedure TFormAusgangsRechnungen.SetContextCustomer(Kunde_RID: integer);
begin
 //
  PERSON_R := Kunde_rid;
  IB_Query2.ParamByName('CROSSREF').AsInteger := Kunde_RID;
  IB_Query3.ParamByName('CROSSREF').AsInteger := IB_Query2.FieldByName('PRIV_ANSCHRIFT_R').AsInteger;
  label1.caption := e_r_name(IB_Query2) +
    ' (' +
    IB_Query2.FieldByName('NUMMER').AsString +
    ') ' +
    e_r_ort(IB_Query3);
end;

procedure TFormAusgangsRechnungen.SpeedButton13Click(Sender: TObject);
begin
  refreshSumme;
end;

procedure TFormAusgangsRechnungen.SpeedButton1Click(Sender: TObject);
begin
 FormArtikelPOS.Schublade_Auf(iSchubladePort);
end;

procedure TFormAusgangsRechnungen.StaticText7Click(Sender: TObject);
begin
  edit4.Text := '';
  edit6.Text := '';
end;

procedure TFormAusgangsRechnungen.IB_Grid1CellGainFocus(Sender: TObject; ACol,
  ARow: Integer);
begin
  FormBelege.setShortCut(IB_DataSource1);
end;

procedure TFormAusgangsRechnungen.FormCreate(Sender: TObject);
begin
  label2.Caption := FormatSettings.CurrencyString;
end;

procedure TFormAusgangsRechnungen.Button9Click(Sender: TObject);
var
  Bericht: TStringList;
begin
  Bericht := e_w_KontoInfo(PERSON_R);
  Bericht.free;
  openShell(MahnungFName(PERSON_R));
end;

procedure TFormAusgangsRechnungen.Edit5KeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Button8Click(self);
  end;
end;

procedure TFormAusgangsRechnungen.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
 BELEG_R := IB_Query1.FieldByName('BELEG_R').AsInteger;
end;

procedure TFormAusgangsRechnungen.IB_Query1ConfirmDelete(
  Sender: TComponent; var Confirmed: Boolean);
begin
  with Sender as TIB_Dataset do
    Confirmed := doit('Buchung über ' + #13 +
      format('%m', [FieldByName('BETRAG').AsDouble]) + #13 +
      'wirklich löschen');
end;

procedure TFormAusgangsRechnungen.refreshSumme;
var
  LastSet: dword;
  RecN: integer;
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
    while not (eof) do
    begin
      inc(RecN);
      Summe := Summe + FieldByName('BETRAG').AsFloat;
      next;
    end;
    EnableControls;
  end;
  enabled := true;
  StaticText5.caption := format('%m', [abs(Summe)]);
  if (summe <= 0) then
    StaticText5.Color := cllime
  else
    StaticText5.Color := clred;
  if (summe = 0) and CloseIfzero then
    close;
  EndHourGlass;
end;

procedure TFormAusgangsRechnungen.IB_Grid1GetDisplayText(Sender: TObject;
  ACol, ARow: Integer; var AString: string);
begin
  if (ARow > 0) then
    if (ACol = 6) then
      if (AString <> '') then
        AString := format('%m', [strtodoubledef(AString, 0.0)]);
end;

end.

