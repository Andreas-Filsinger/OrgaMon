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
unit Prorata;

interface

uses
  Windows, Messages, SysUtils, Variants,
  Classes, Graphics, Controls, Forms,
  Dialogs, IB_Access, IB_Components, StdCtrls,
  Mask, IB_Controls, ExtCtrls, DatePick,
  Grids, IB_Grid, ComCtrls, Buttons;

type
  TFormProrata = class(TForm)
    Button1: TButton;
    ProgressBar1: TProgressBar;
    Label5: TLabel;
    Button4: TButton;
    IB_QueryPERSON: TIB_Query;
    IB_QueryARTIKEL: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    IB_DataSource3: TIB_DataSource;
    IB_Query6: TIB_Query;
    IB_Query7: TIB_Query;
    IB_Query8: TIB_Query;
    IB_DataSource4: TIB_DataSource;
    GroupBox1: TGroupBox;
    Label7: TLabel;
    Edit2: TEdit;
    CheckBox2: TCheckBox;
    CheckBoxAusgabearten: TCheckBox;
    CheckBox4: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    IB_Grid1: TIB_Grid;
    IB_Grid2: TIB_Grid;
    Button2: TButton;
    Button3: TButton;
    SpeedButton1: TSpeedButton;
    Image2: TImage;
    CheckBox5: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Edit1: TEdit;
    CheckBox6: TCheckBox;
    ComboBox1: TComboBox;
    Label8: TLabel;
    SpeedButton2: TSpeedButton;
    CheckBoxSinglePerson: TCheckBox;
    CheckBoxSingleArtikel: TCheckBox;
    procedure IB_QueryPERSONAfterScroll(IB_Dataset: TIB_Dataset);
    procedure FormActivate(Sender: TObject);
    procedure IB_Grid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure IB_Grid1DrawFocusedCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure CheckBoxSingleArtikelClick(Sender: TObject);
  private
    { Private-Deklarationen }
    Modus: string;

    // Prorata.ini
    // ===========
    //
    // Titel Anzahl Zeichen=
    // Ausgabearten=
    // Beleg Titel=
    //
    sEinstellungen: TStringList;

    function cProrataPath: string;
    function cProrataDataPath: string;
    function cProrataAuswertungPath: string;
    procedure ReflectModus;
  public
    { Public-Deklarationen }
    procedure ArtikelSort(ArtikelListe: TStringList);
    procedure DiagSave(ArtikelListe: TStrings; AsNumber: Integer);
  end;

var
  FormProrata: TFormProrata;

implementation

uses
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  Funktionen.LokaleDaten,
  Person, anfix32, globals,
  Artikel, WordIndex, html,
  CareTakerClient, Geld, Datenbank,
  IBExportTable, wanfix32;

{$R *.dfm}

const
  cFID_ARTIKEL_R = 0; //
  cFID_AUSGABEART_R = 1; //
  cFID_TITEL = 2; //
  cFID_PERSON_R = 3; //
  cFID_NAME = 4; //
  cFID_PROZENT = 5; //
  cFID_MENGE = 6; // summierbar
  cFID_WERT = 7; // summierbar
  cFID_DATUM = 8; // Verkaufsdatum
  cFID_BELEG_R = 9; //
  cFID_LAGER_MENGE = 10; //
  cFID_VERLAGNO = 11;
  cFID_VON = 12; // Prorataberechtigung "VON"
  cFID_BIS = 13; // Prorataberechtigung "BIS"
  cFID_START = 14; // Artikel "VERLAG_STAT_START"

  cProrata_Header =
    'ARTIKEL_R;AUSGABEART_R;TITEL;PERSON_R;NAME;PROZENT;MENGE;WERT;DATUM;BELEG_R;LAGER_MENGE;VERLAGNO;VON;BIS;START';

procedure TFormProrata.IB_QueryPERSONAfterScroll(IB_Dataset: TIB_Dataset);
begin
  IB_QueryARTIKEL.ParamByName('CROSSREF').AsInteger := IB_QueryPERSON.Fields[0]
    .AsInteger;
end;

procedure TFormProrata.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Prorata');
end;

procedure TFormProrata.ReflectModus;
begin
  BeginHourGlass;

  sEinstellungen.LoadFromFile(cProrataDataPath + 'Prorata.ini');

  with IB_QueryPERSON do
  begin
    if Active then
      Close;
    sql.LoadFromFile(cProrataDataPath + 'Person.OLAP.txt');
    Open;
  end;

  with IB_QueryARTIKEL do
  begin
    if Active then
      Close;
    sql.LoadFromFile(cProrataDataPath + 'Artikel.OLAP.txt');
    Open;
  end;

  Edit1.Text := sEinstellungen.values['Titel Anzahl Zeichen'];
  CheckBoxAusgabearten.Checked := sEinstellungen.values['Ausgabearten']
    = cIni_Activate;

  EndHourGlass;

end;

procedure TFormProrata.SpeedButton1Click(Sender: TObject);
begin
  openShell(cProrataAuswertungPath);
end;

procedure TFormProrata.SpeedButton2Click(Sender: TObject);
begin
  openShell(cProrataDataPath);
end;

procedure TFormProrata.FormActivate(Sender: TObject);
var
  _Modus: string;
  sDir: TStringList;
  n: Integer;
begin

  // Init
  CheckCreateOnce(cProrataPath);
  if not(assigned(sEinstellungen)) then
    sEinstellungen := TStringList.Create;
  _Modus := ComboBox1.Text;

  // Combobox1 Refresh
  sDir := TStringList.Create;
  dir(cProrataPath + '*.', sDir, false);
  for n := pred(sDir.Count) downto 0 do
    if pos('.', sDir[n]) = 1 then
      sDir.Delete(n);
  sDir.sort;
  ComboBox1.items.Assign(sDir);
  if (sDir.Count > 0) then
    if sDir.IndexOf(_Modus) = -1 then
      ComboBox1.Text := sDir[0];
  sDir.Free;

  // Set
  Modus := ComboBox1.Text;
  if (_Modus <> Modus) then
    ReflectModus;

end;

procedure TFormProrata.IB_Grid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  _CellDisplayText: string;
begin
  with Sender as TIB_Grid do
  begin
    _CellDisplayText := GetCellDisplayText(ACol, ARow);
    if (ACol = 1) then
      _CellDisplayText := e_r_Person(strtol(_CellDisplayText));
    DefaultDrawCell(ACol, ARow, Rect, State, _CellDisplayText,
      GetCellAlignment(ACol, ARow));
  end;
end;

procedure TFormProrata.IB_Grid1DrawFocusedCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  _CellDisplayText: string;
begin
  with Sender as TIB_Grid do
  begin
    _CellDisplayText := GetCellDisplayText(ACol, ARow);
    if (ACol = 1) then
      _CellDisplayText := e_r_Person(strtol(_CellDisplayText));

    canvas.Font.style := [fsbold];
    canvas.Font.color := clwhite;
    canvas.brush.color := clblue;
    DefaultDrawCell(ACol, ARow, Rect, State, _CellDisplayText,
      GetCellAlignment(ACol, ARow));
    canvas.brush.color := clwhite;
    canvas.Font.color := clblack;
    canvas.Font.style := [];
  end;
end;

procedure TFormProrata.Button1Click(Sender: TObject);
var
  StartTime: dword;
  ThisRecN: Integer;
  Ergebnisse: TStringList;
  Aussortierte: TStringList;
  ArtikelListe: TStringList;
  k: Integer;

  _DieseMenge: Integer;
  _Rabatt: double;
  _PreisOhneRabatt: double;
  _Preis: double;
  _PreisNetto: double;
  _MwSt: double;
  _Percent: double;
  _Titel: string;

  _ThisArticle: string;
  ErrorCount: Integer;

  cBELEGE: TIB_Cursor;
  cPOSTEN: TIB_Cursor;

  RECHNUNG: TANFiXDate;
  START: TANFiXDate;
  VON: TANFiXDate;
  BIS: TANFiXDate;

  Line: string;

begin
  BeginHourGlass;
  ArtikelListe := TStringList.Create;
  Ergebnisse := TStringList.Create;
  Aussortierte := TStringList.Create;
  cBELEGE := DataModuleDatenbank.nCursor;
  cBELEGE.sql.LoadFromFile(cProrataDataPath + 'Belege.OLAP.txt');
  cPOSTEN := DataModuleDatenbank.nCursor;
  cPOSTEN.sql.LoadFromFile(cProrataDataPath + 'Posten.OLAP.txt');

  DateTimePicker1.Time := EncodeTime(0, 0, 0, 0);
  DateTimePicker2.Time := EncodeTime(23, 59, 59, 999);
  CheckCreateOnce(cProrataAuswertungPath);

  // (-)Personen Liste
  // (-)Artikel
  // A
  // B
  // C
  ErrorCount := 0;

  Label5.Caption := 'Artikelliste erstellen ...';
  application.ProcessMessages;

  if not(CheckBoxSinglePerson.Checked) then
    IB_QueryPERSON.First;
  while not(IB_QueryPERSON.Eof) do
  begin
    if not(CheckBoxSingleArtikel.Checked) then
      IB_QueryARTIKEL.First;
    while not(IB_QueryARTIKEL.Eof) do
    begin
      _Percent := IB_QueryARTIKEL.FieldByName('PERCENT').AsDouble;
      if (_Percent > 0.0) then
        ArtikelListe.add(
          { ARTIKEL_R } IB_QueryARTIKEL.FieldByName('RID').AsString + ';' +
          { AUSGABEART_R } IB_QueryARTIKEL.FieldByName('AUSGABEART_R')
          .AsString + ';' +
          { TITEL } nosemi(IB_QueryARTIKEL.FieldByName('TITEL').AsString + ' ('
          + IB_QueryARTIKEL.FieldByName('NUMERO').AsString + ')') + ';' +
          { PERSON_R } IB_QueryPERSON.Fields[0].AsString + ';' +
          { NAME } nosemi(e_r_Person(IB_QueryPERSON.Fields[0]
          .AsInteger)) + ';' +
          { % } IB_QueryARTIKEL.FieldByName('PERCENT').AsString + ';' +
          { MENGE } '0' + ';' +
          { WERT } '0' + ';' +
          { DATUM } IB_QueryARTIKEL.FieldByName('VERLAG_STAT_START')
          .AsString + ';' +
          { BELEG_R } '0' + ';' +
          { LAGER_MENGE } IB_QueryARTIKEL.FieldByName('MENGE').AsString + ';' +
          { cFID_VERLAGNO } IB_QueryARTIKEL.FieldByName('VERLAGNO')
          .AsString + ';' +
          { VON } Long2Date(Datum_coalesce(IB_QueryARTIKEL.FieldByName('VON'),
          cOrgaMonBirthDayAsLong)) + ';' +
          { BIS } Long2Date(Datum_coalesce(IB_QueryARTIKEL.FieldByName('BIS'),
          cOrgaMonDeathDayAsLong)) + ';' +
          { START } IB_QueryARTIKEL.FieldByName('VERLAG_STAT_START').AsString

          )
      else
      begin
        ShowMessage('Achtung: Prozent Angabe leer oder 0!');
        inc(ErrorCount);
        break;
      end;

      if not(CheckBoxSingleArtikel.Checked) then
        IB_QueryARTIKEL.Next
      else
        break;

    end;

    if (ErrorCount > 0) then
      break;

    if not(CheckBoxSinglePerson.Checked) then
      IB_QueryPERSON.Next
    else
      break;

  end;

  ArtikelSort(ArtikelListe);

  if (ErrorCount = 0) then
  begin

    // (-) Belege
    // (-) Posten
    // (-) Artikel
    Label5.Caption := 'Belegliste erstellen ...';
    application.ProcessMessages;
    StartTime := GetTickCount;
    ThisRecN := 0;

    cPOSTEN.Open;
    IB_Query6.Open;
    IB_Query7.Open;
    IB_Query8.Open;
    with cBELEGE do
    begin
      ParamByName('DATE1').AsDateTime := DateTimePicker1.DateTime;
      ParamByName('DATE2').AsDateTime := DateTimePicker2.DateTime;
      Open;
      ProgressBar1.Max := RecordCount;
      while not(Eof) do
      begin

        //
        // aufgrund von Verkaufs-Belegen in IBQ5
        //
        cPOSTEN.ParamByName('CROSSREF').AsInteger := FieldByName('RID')
          .AsInteger;
        cPOSTEN.First;
        while not(cPOSTEN.Eof) do
        begin
          repeat

            // Filter für Ausgabearten
            if not(CheckBoxAusgabearten.Checked) then
              if cPOSTEN.FieldByName('AUSGABEART_R').IsNotNull then
                break;

            // Artikel muss grundsätzlich erwünscht sein!
            _ThisArticle :=
            { ARTIKEL_R } cPOSTEN.FieldByName('ARTIKEL_R').AsString + ';' +
            { AUSGABEART_R } cPOSTEN.FieldByName('AUSGABEART_R').AsString + ';';
            for k := 0 to pred(ArtikelListe.Count) do
            begin

              if (pos(_ThisArticle, ArtikelListe[k]) = 1) then
              begin

                // Artikel gefunden!

                // Mein Artikel!
                _DieseMenge := cPOSTEN.FieldByName('MENGE_GELIEFERT').AsInteger;
                _Rabatt := cPOSTEN.FieldByName('RABATT').AsDouble;
                _PreisOhneRabatt := e_r_PostenPreis(
                  { } cPOSTEN.FieldByName('PREIS').AsDouble,
                  { } _DieseMenge,
                  { } cPOSTEN.FieldByName('EINHEIT_R').AsInteger);

                _MwSt := cPOSTEN.FieldByName('MWST').AsDouble;
                if (_Rabatt > 0) then
                begin
                  _Preis := _PreisOhneRabatt -
                    (_PreisOhneRabatt * (_Rabatt / 100.0));
                  _Preis := cPreisRundung(_Preis);
                end
                else
                begin
                  _Preis := _PreisOhneRabatt;
                end;
                _PreisNetto := _Preis / (1.0 + (_MwSt / 100.0));

                if CheckBox6.Checked then
                  _Titel := nosemi(cPOSTEN.FieldByName('ARTIKEL').AsString)
                else
                  _Titel := nextp(ArtikelListe[k], ';', cFID_TITEL);

                START := date2long(nextp(ArtikelListe[k], ';', cFID_DATUM));
                VON := date2long(nextp(ArtikelListe[k], ';', cFID_VON));
                BIS := date2long(nextp(ArtikelListe[k], ';', cFID_BIS));
                RECHNUNG :=
                  datetime2long(cBELEGE.FieldByName('RECHNUNG').AsDate);

                // Ausgabe
                Line :=
                { 00;01; } _ThisArticle +
                { 02 } _Titel + ';' +
                { 03 } nextp(ArtikelListe[k], ';', cFID_PERSON_R) + ';' +
                { 04 } nextp(ArtikelListe[k], ';', cFID_NAME) + ';' +
                { 05 } nextp(ArtikelListe[k], ';', cFID_PROZENT) + ';' +
                { 06 } inttostr(_DieseMenge) + ';' +
                { 07 } inttostr(round(_PreisNetto * 100.0)) + ';' +
                { 08* } Long2Date(RECHNUNG) + ';' +
                { 09 } cPOSTEN.FieldByName('BELEG_R').AsString + ';' +
                { 10 } nextp(ArtikelListe[k], ';', cFID_LAGER_MENGE) + ';' +
                { 11 } nextp(ArtikelListe[k], ';', cFID_VERLAGNO) + ';' +
                { 12 } Long2Date(VON) + ';' +
                { 13 } Long2Date(BIS) + ';' +
                { 14 } Long2Date(START);

                if (RECHNUNG >= START) and (RECHNUNG >= VON) and
                  (RECHNUNG <= BIS) then
                  Ergebnisse.add(Line)
                else
                  Aussortierte.add(Line);
              end;
            end;
          until true;
          cPOSTEN.Next;
        end;
        Next;
        inc(ThisRecN);
        if frequently(StartTime, 333) or Eof then
        begin
          ProgressBar1.Position := ThisRecN;
          application.ProcessMessages;
        end;
      end;
      Close;
    end;

    DiagSave(Aussortierte, 31);

    ArtikelListe.AddStrings(Ergebnisse);

    DiagSave(ArtikelListe, 4);

    ArtikelSort(ArtikelListe);
    DiagSave(ArtikelListe, 5);

    IB_Query6.Close;
    IB_Query7.Close;
    IB_Query8.Close;

  end;

  Ergebnisse.Free;
  Aussortierte.Free;
  ArtikelListe.Free;
  ProgressBar1.Position := 0;
  cPOSTEN.Free;
  cBELEGE.Free;
  EndHourGlass;

  if (ErrorCount = 0) then
    openShell(cProrataAuswertungPath);

end;

procedure TFormProrata.Button3Click(Sender: TObject);
begin
  FormPerson.SetContext(IB_QueryPERSON.Fields[0].AsInteger);
end;

procedure TFormProrata.Button2Click(Sender: TObject);
begin
  FormArtikel.SetContext(IB_QueryARTIKEL.FieldByName('RID').AsInteger);
end;

procedure TFormProrata.Button4Click(Sender: TObject);
var
  StartTime: dword;
  ThisRecN: Integer;
  pTextLength: Integer;
  FName: string;
  ArtikelListe: TSearchStringList;
  n, m: Integer;

  _Preis: double;
  _Percent: double;

  Auszahlung: double;
  EinzelAuszahlungsSumme: double;
  GesamtAuszahlungsSumme: double;

  AbrechnungsBeleg: THTMLTemplate;
  FPDataGlobal: TStringList;
  FPDataLocal: TStringList;
  _ustid: string;
  ProrataDoMwSt: boolean;
  ProrataGuthaben: double;
  Abschlag: double;
  AUSGABEART_R: Integer;

  cProRataMwSt: double;
begin
  // nach Personen sortiert ausgeben
  BeginHourGlass;

  //
  cProRataMwSt := e_r_sqld('select SATZ from MWST where NAME=''PRORATA''');
  if (cProRataMwSt = 0.0) then
    cProRataMwSt := 7.0;

  FileDelete(cProrataAuswertungPath + '*.html');
  Abschlag := strtodoubledef(StrFilter(Edit2.Text, '0123456789,'), 0.0);

  if CheckBox5.Checked then
    FName := cProrataAuswertungPath + 'Prorata_' +
      inttostr(datetime2long(DateTimePicker1.Date)) + '_' +
      inttostr(datetime2long(DateTimePicker2.Date)) + '.4.txt'
  else
    FName := cProrataAuswertungPath + 'Prorata_' +
      inttostr(datetime2long(DateTimePicker1.Date)) + '_' +
      inttostr(datetime2long(DateTimePicker2.Date)) + '.5.txt';

  ArtikelListe := TSearchStringList.Create;
  ArtikelListe.LoadFromFile(FName);
  pTextLength := strtol(Edit1.Text);

  IB_Query6.Open;
  IB_Query7.Open;
  IB_Query8.Open;

  GesamtAuszahlungsSumme := 0.0;
  ThisRecN := 0;
  if not(CheckBoxSinglePerson.Checked) then
  begin
    IB_QueryPERSON.First;
    ProgressBar1.Max := IB_QueryPERSON.RecordCount;
  end;
  while not(IB_QueryPERSON.Eof) do
  begin
    //
    IB_Query6.ParamByName('CROSSREF').AsInteger := IB_QueryPERSON.Fields[0]
      .AsInteger;
    IB_Query7.ParamByName('CROSSREF').AsInteger :=
      IB_Query6.FieldByName('PRIV_ANSCHRIFT_R').AsInteger;

    FPDataGlobal := TStringList.Create;
    FPDataLocal := TStringList.Create;

    AbrechnungsBeleg := THTMLTemplate.Create;
    AbrechnungsBeleg.LoadFromFile(cProrataDataPath + 'Auswertung.html');

    CheckCreateOnce(cProrataAuswertungPath);

    FPDataGlobal.add('save&delete ARTIKEL EVEN');
    FPDataGlobal.add('save&delete ARTIKEL ODD');
    FPDataGlobal.add('save&delete MWST');

    ProrataDoMwSt := IB_Query6.FieldByName('PRORATA_MWST').AsString <> cC_False;
    ProrataGuthaben := IB_Query6.FieldByName('PRORATA_GUTHABEN').AsDouble;

    FPDataGlobal.add('Datum=' + Long2Date(DateGet));
    FPDataGlobal.add('AktuellesDatum=' + datum);
    FPDataGlobal.add('AktuelleUhrzeit=' + Uhr);

    e_r_Anschrift(IB_Query6.FieldByName('RID').AsInteger, FPDataGlobal);
    e_r_Bank(IB_Query6.FieldByName('RID').AsInteger, FPDataGlobal);

    FPDataGlobal.add(
      { } 'Beleg Titel=' +
      { } format(sEinstellungen.values['Beleg Titel'], [
      { } long2dateLocalized(DateTimePicker1.DateTime),
      { } long2dateLocalized(DateTimePicker2.DateTime)]));

    with IB_Query7 do
    begin

      _ustid := FieldByName('UST_ID').AsString;
      if _ustid <> '' then
      begin
        FPDataGlobal.add('USTID=' + _ustid);
      end
      else
      begin
        FPDataGlobal.add('delete USTID_A');
        FPDataGlobal.add('delete USTID_B');
      end;
    end;

    // Zeilen suchen
    EinzelAuszahlungsSumme := 0.0;
    m := 0;
    for n := 0 to pred(ArtikelListe.Count) do
    begin
      if (nextp(ArtikelListe[n], ';', cFID_PERSON_R) = IB_QueryPERSON.Fields[0]
        .AsString) then
      begin

        // html-Zeile rausschreiben
        while true do
        begin
          inc(m);
          if odd(m) then
            FPDataLocal.add('load ARTIKEL EVEN,ARTIKEL')
          else
            FPDataLocal.add('load ARTIKEL ODD,ARTIKEL');

          if (ProrataGuthaben > 0.0) then
          begin
            FPDataLocal.add('ArtNo=-.-');
            FPDataLocal.add('ArtTxt=Guthaben aus Vorjahr');
            FPDataLocal.add('Percent=100%');
            FPDataLocal.add('Menge=-.-');
            FPDataLocal.add('Wert=-.-');
            FPDataLocal.add('Anteil=' + UnBreakAble(format('%m',
              [ProrataGuthaben])));
            EinzelAuszahlungsSumme := EinzelAuszahlungsSumme + ProrataGuthaben;
            ProrataGuthaben := 0;
            continue;
          end;
          break;
        end;

        IB_Query8.ParamByName('CROSSREF').AsInteger :=
          strtoint(nextp(ArtikelListe[n], ';', cFID_ARTIKEL_R));

        FPDataLocal.add('ArtNo=' + IB_Query8.FieldByName('NUMERO').AsString);
        if pTextLength > 0 then
          FPDataLocal.add('ArtTxt=' + copy(nextp(ArtikelListe[n], ';',
            cFID_TITEL), 1, pTextLength))
        else
          FPDataLocal.add('ArtTxt=' + nextp(ArtikelListe[n], ';', cFID_TITEL));

        //
        _Percent := strtodouble(nextp(ArtikelListe[n], ';', cFID_PROZENT));
        FPDataLocal.add('Percent=' + UnBreakAble(format('%2.1f%%%',
          [_Percent])));
        FPDataLocal.add('Menge=' + nextp(ArtikelListe[n], ';', cFID_MENGE));

        //
        _Preis := strtodouble(nextp(ArtikelListe[n], ';', cFID_WERT)) / 100.0;
        if (Abschlag <> 0.0) then
          _Preis := _Preis * (1.0 - Abschlag / 100.0);

        FPDataLocal.add('Wert=' + UnBreakAble(format('%m', [_Preis])));

        Auszahlung := cPreisRundung(_Preis * (_Percent / 100.0));

        FPDataLocal.add('Anteil=' + UnBreakAble(format('%m', [Auszahlung])));
        FPDataLocal.add('StartDatum=' + nextp(ArtikelListe[n], ';',
          cFID_DATUM));
        FPDataLocal.add('Beleg=' + nextp(ArtikelListe[n], ';', cFID_BELEG_R));
        FPDataLocal.add('LagerMenge=' + nextp(ArtikelListe[n], ';',
          cFID_LAGER_MENGE));
        FPDataLocal.add('VerlagNo=' + nextp(ArtikelListe[n], ';',
          cFID_VERLAGNO));
        FPDataLocal.add('Start=' + nextp(ArtikelListe[n], ';', cFID_START));
        FPDataLocal.add('Von=' + nextp(ArtikelListe[n], ';', cFID_VON));
        FPDataLocal.add('Bis=' + nextp(ArtikelListe[n], ';', cFID_BIS));

        AUSGABEART_R := strtointdef(nextp(ArtikelListe[n], ';',
          cFID_AUSGABEART_R), 0);
        if (AUSGABEART_R > cRID_FirstValid) then
          FPDataLocal.add('AusgabeArt=' +
            cutblank(e_r_Ausgabeart(AUSGABEART_R)))
        else
          FPDataLocal.add('AusgabeArt=');

        FPDataLocal.add(cPageBreakHerePossible);

        EinzelAuszahlungsSumme := EinzelAuszahlungsSumme + Auszahlung;

      end;
    end;

    FPDataGlobal.add('ZS=' + UnBreakAble(format('%m',
      [EinzelAuszahlungsSumme])));

    if ProrataDoMwSt then
    begin
      // Erhöhung der Prorata um den MWST Betrag
      FPDataLocal.add('load MWST');
      FPDataLocal.add('MwStSatz=' + UnBreakAble(format('%2.1f',
        [cProRataMwSt])));
      FPDataLocal.add('MW=' + UnBreakAble(format('%m',
        [EinzelAuszahlungsSumme * (cProRataMwSt / 100.0)])));
      EinzelAuszahlungsSumme :=
        cPreisRundung((EinzelAuszahlungsSumme *
        (1.0 + (cProRataMwSt / 100.0))));
      FPDataLocal.add('GS=' + UnBreakAble(format('%m',
        [EinzelAuszahlungsSumme])));
    end;

    GesamtAuszahlungsSumme := GesamtAuszahlungsSumme + EinzelAuszahlungsSumme;

    AbrechnungsBeleg.WriteValue(FPDataLocal, FPDataGlobal);
    AbrechnungsBeleg.SaveToFile(
      { } cProrataAuswertungPath +
      { } ValidateFName(IB_Query6.FieldByName('NACHNAME').AsString) + '_' +
      { } IB_Query6.FieldByName('NUMMER').AsString + '.html');

    AbrechnungsBeleg.Free;
    FPDataGlobal.Free;
    FPDataLocal.Free;

    if not(CheckBoxSinglePerson.Checked) then
    begin
      IB_QueryPERSON.Next;
    end
    else
    begin
      break;
    end;

    if frequently(StartTime, 333) or IB_QueryPERSON.Eof then
    begin
      ProgressBar1.Position := ThisRecN;
      application.ProcessMessages;
    end;
    inc(ThisRecN);

  end;
  ProgressBar1.Position := 0;
  Label5.Caption := format('%m', [GesamtAuszahlungsSumme]);
  application.ProcessMessages;
  ArtikelListe.Free;
  IB_Query6.Close;
  IB_Query7.Close;
  IB_Query8.Close;
  EndHourGlass;
  openShell(cProrataAuswertungPath);
end;

procedure TFormProrata.ArtikelSort(ArtikelListe: TStringList);
var
  Clientsorter: TStringList;
  n: Integer;

  function NumericReverse(s: string): string;
  var
    n: Integer;
  begin
    result := inttostrN(round(strtodoubledef(s, 0) * 100.0), 15);
    for n := 1 to length(result) do
      result[n] := chr(ord('0') + pred(pos(result[n], '9876543210')));
  end;

begin
  Clientsorter := TStringList.Create;
  if CheckBox2.Checked then
  begin
    // Beleg-Sortierung
    // "BELEG_R"."TITEL"  - Sortierung
    for n := 0 to pred(ArtikelListe.Count) do
      Clientsorter.addobject(nextp(ArtikelListe[n], ';', cFID_PERSON_R) + ';' +
        inttostrN(strtol(nextp(ArtikelListe[n], ';', cFID_BELEG_R)), 5) + ';' +
        nextp(ArtikelListe[n], ';', cFID_TITEL), TObject(n))
  end
  else
  begin
    // "Artikel_R"."Ausgabeart_R"  - Sortierung
    for n := 0 to pred(ArtikelListe.Count) do
      Clientsorter.addobject(nextp(ArtikelListe[n], ';', cFID_PERSON_R) + ';' +
        nextp(ArtikelListe[n], ';', cFID_ARTIKEL_R) + ';' +
        nextp(ArtikelListe[n], ';', cFID_AUSGABEART_R), TObject(n));
  end;

  // Sortieren und Reihenfolge übernehmen
  Clientsorter.sort;
  for n := 0 to pred(ArtikelListe.Count) do
    Clientsorter[n] := ArtikelListe[Integer(Clientsorter.objects[n])];
  ArtikelListe.Clear;
  ArtikelListe.AddStrings(Clientsorter);
  Clientsorter.Free;
  DiagSave(ArtikelListe, 1);

  // jetzt noch der JOIN zur Summierung unerwünschter Details
  // Anker: PERSON_R+ARTIKEL_R+AUSGABEART_R
  if not(CheckBox2.Checked) then
  begin
    for n := pred(ArtikelListe.Count) downto 1 do
      if nextp(ArtikelListe[n], ';', cFID_ARTIKEL_R) + ';' +
        nextp(ArtikelListe[n], ';', cFID_AUSGABEART_R) + ';' +
        nextp(ArtikelListe[n], ';', cFID_PERSON_R)
        = nextp(ArtikelListe[pred(n)], ';', cFID_ARTIKEL_R) + ';' +
        nextp(ArtikelListe[pred(n)], ';', cFID_AUSGABEART_R) + ';' +
        nextp(ArtikelListe[pred(n)], ';', cFID_PERSON_R) then
      begin
        try
          ArtikelListe[pred(n)] := nextp(ArtikelListe[n], ';', cFID_ARTIKEL_R) +
            ';' + nextp(ArtikelListe[n], ';', cFID_AUSGABEART_R) + ';' +
            nextp(ArtikelListe[n], ';', cFID_TITEL) + ';' +
            nextp(ArtikelListe[n], ';', cFID_PERSON_R) + ';' +
            nextp(ArtikelListe[n], ';', cFID_NAME) + ';' +
            nextp(ArtikelListe[n], ';', cFID_PROZENT) + ';' +

          // Menge summieren!
            inttostr(strtoint(nextp(ArtikelListe[n], ';', cFID_MENGE)) +
            strtoint(nextp(ArtikelListe[pred(n)], ';', cFID_MENGE))) + ';' +

          // Wert summieren!
            inttostr(strtoint(nextp(ArtikelListe[n], ';', cFID_WERT)) +
            strtoint(nextp(ArtikelListe[pred(n)], ';', cFID_WERT))) + ';' +
          //
            nextp(ArtikelListe[n], ';', cFID_DATUM) + ';' +
            nextp(ArtikelListe[n], ';', cFID_BELEG_R) + ';' +
            nextp(ArtikelListe[n], ';', cFID_LAGER_MENGE) + ';' +
            nextp(ArtikelListe[n], ';', cFID_VERLAGNO) + ';' +
            nextp(ArtikelListe[n], ';', cFID_VON) + ';' + nextp(ArtikelListe[n],
            ';', cFID_BIS) + ';' + nextp(ArtikelListe[n], ';', cFID_START);
        except
          on e: Exception do
          begin
            ShowMessage(
              { } cERRORText + e.Message + #13 +
              { } ArtikelListe[n] + #13 +
              { } ArtikelListe[pred(n)]);
          end;

        end;

        ArtikelListe.Delete(n);
      end;

    // Speicherung zur Diagnose
    DiagSave(ArtikelListe, 2);

  end;

  // Jetzt 2. Mal sortieren, nach Verkaufsmenge
  if CheckBox4.Checked then
  begin
    Clientsorter := TStringList.Create;
    for n := 0 to pred(ArtikelListe.Count) do
      Clientsorter.addobject(nextp(ArtikelListe[n], ';', cFID_PERSON_R) + ';' +
        NumericReverse(nextp(ArtikelListe[n], ';', cFID_MENGE)) + ';' +
        nextp(ArtikelListe[n], ';', cFID_TITEL), TObject(n));

    Clientsorter.sort;
    for n := 0 to pred(ArtikelListe.Count) do
      Clientsorter[n] := ArtikelListe[Integer(Clientsorter.objects[n])];
    ArtikelListe.Clear;
    ArtikelListe.AddStrings(Clientsorter);
    Clientsorter.Free;

    // Speicherung zur Diagnose
    DiagSave(ArtikelListe, 3);
  end;

end;

procedure TFormProrata.CheckBoxSingleArtikelClick(Sender: TObject);
begin
  if CheckBoxSingleArtikel.Checked then
    CheckBoxSinglePerson.Checked := true;
end;

procedure TFormProrata.ComboBox1Change(Sender: TObject);
begin
  // Aktuellen Modus umschalten
  Modus := ComboBox1.Text;
  ReflectModus;
end;

function TFormProrata.cProrataAuswertungPath: string;
begin
  result := cProrataDataPath + 'Auswertung\';
end;

function TFormProrata.cProrataDataPath: string;
begin
  result := cProrataPath + Modus + '\';
end;

function TFormProrata.cProrataPath: string;
begin
  result := EigeneOrgaMonDateienPfad + 'Prorata\';
end;

procedure TFormProrata.DiagSave(ArtikelListe: TStrings; AsNumber: Integer);
var
  DiagAsCSV: TStringList;
begin
  DiagAsCSV := TStringList.Create;
  DiagAsCSV.add(cProrata_Header);
  DiagAsCSV.AddStrings(ArtikelListe);
  ArtikelListe.SaveToFile(cProrataAuswertungPath + 'Prorata_' +
    inttostr(datetime2long(DateTimePicker1.Date)) + '_' +
    inttostr(datetime2long(DateTimePicker2.Date)) + '.' + inttostr(AsNumber)
    + '.txt');
  DiagAsCSV.SaveToFile(cProrataAuswertungPath + 'Prorata_' +
    inttostr(datetime2long(DateTimePicker1.Date)) + '_' +
    inttostr(datetime2long(DateTimePicker2.Date)) + '.' + inttostr(AsNumber)
    + '.csv');
  DiagAsCSV.Free;
end;

end.
