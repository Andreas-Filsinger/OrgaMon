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
unit epIMPORT;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, IB_Access, IB_Components, ComCtrls,
  anfix;

type
  TFormepIMPORT = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    ListBox1: TListBox;
    Button2: TButton;
    Edit2: TEdit;
    Button3: TButton;
    Edit3: TEdit;
    IB_QueryPERSON: TIB_Query;
    IB_QueryANSCHRIFT: TIB_Query;
    IB_QueryTIER: TIB_Query;
    IB_QueryARTIKEL: TIB_Query;
    IB_QuerySORTIMENT: TIB_Query;
    IB_QueryMWST: TIB_Query;
    IB_QueryBELEG: TIB_Query;
    IB_QueryPOSTEN: TIB_Query;
    Label4: TLabel;
    Edit4: TEdit;
    Button4: TButton;
    Label3: TLabel;
    Label5: TLabel;
    Button5: TButton;
    TabSheet3: TTabSheet;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    TabSheet4: TTabSheet;
    Label6: TLabel;
    Edit5: TEdit;
    ProgressBar1: TProgressBar;
    Button10: TButton;
    Button11: TButton;
    Label7: TLabel;
    Edit6: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    TabSheet5: TTabSheet;
    Edit7: TEdit;
    Button9: TButton;
    CheckBox7: TCheckBox;
    TabSheet6: TTabSheet;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Label10: TLabel;
    Button15: TButton;
    TabSheet7: TTabSheet;
    Button16: TButton;
    Label11: TLabel;
    ListBox2: TListBox;
    TabSheet8: TTabSheet;
    Label12: TLabel;
    Edit8: TEdit;
    Label13: TLabel;
    Edit9: TEdit;
    Button17: TButton;
    ListBox3: TListBox;
    TabSheet10: TTabSheet;
    Button19: TButton;
    StaticText1: TStaticText;
    Abbruch: TCheckBox;
    IB_QueryFORDERUNG: TIB_Query;
    procedure Button6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
  private
    { Private-Deklarationen }
    BreakIt: boolean;
    sRechnungen: TStringList;

    procedure e_w_RechnungDatumSetzen(ib_q: TIB_Query; Aufdatum: TDateTime); overload;
    // historisch !! - löschen wenn möglich

    procedure e_w_RechnungDatumSetzen(ib_q: TIB_Query; Aufdatum: TANFiXDate); overload;
    // historisch !! - löschen wenn möglich
  public

    { Public-Deklarationen }
    procedure ImportPersonen;
    procedure ImportTiere;
    procedure ImportLeistungen;
    procedure ImportRechnungen;
    procedure ImportRechnung(FName: string);

    procedure doAnfiEuroPersonen;
    procedure doAnfiEuroRechnungen;

  end;

var
  FormepIMPORT: TFormepIMPORT;

implementation

uses
  globals, math,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Artikel,
  Funktionen_Auftrag,
  Funktionen_Buch,
  Einstellungen, IB_Process, Geld,
  IB_DataScan, IB_Session, IB_Export,
  IB_Import, GeoPostleitzahlen, GeoLokalisierung,
  GeoArbeitsplatz, gplists, dbOrgaMon,
  CareTakerClient,
  Datenbank, WordIndex, html,
  wanfix

  // fpspreadsheet
{$IFDEF FPSPREADSHEET}
    , fpspreadsheet, xlsbiff8, fpsconvencoding
{$ENDIF}
    ;
{$R *.dfm}

const
  cDelimiter = 'ý';

procedure TFormepIMPORT.Button10Click(Sender: TObject);
type
  TRechnungOneLine = string[78];
var
  n, m: integer;
  SubDir: Char;
  AllTheRechnungen: TStringList;
  lPersonen: TgpIntegerList;
  PersonBemerkungen: TStringList;
  PERSON_R: integer;
  BELEG_R: integer;
  _KNO: string;
  KNO: TStringList;
  k: integer;
  qBELEG: TIB_Query;
  qPOSTEN: TIB_Query;
  RechnungInhalt: TStringList;
  AllTheRechnungenStartIndex: integer;
begin
  if FileExists(Edit5.text + 'cunz.exe') then
  begin

    BeginHourGlass;

    //
    qBELEG := DataModuleDatenbank.nQuery;
    qBELEG.sql.add('select * from BELEG where RID=:CROSSREF for update');

    //
    qPOSTEN := DataModuleDatenbank.nQuery;
    qPOSTEN.sql.add('select * from POSTEN for insert');
    KNO := TStringList.create;
    RechnungInhalt := TStringList.create;

    // Alle Personen mit ihrer alten RID auflisten!
    lPersonen := e_r_sqlm('select RID from PERSON where A01=''' + cC_True + '''');
    for n := pred(lPersonen.count) downto 0 do
    begin
      PERSON_R := lPersonen[n];
      PersonBemerkungen := e_r_sqlT('select BEMERKUNG from PERSON where RID=' + inttostr(PERSON_R));
      _KNO := PersonBemerkungen.values['KNO'];

      if (_KNO <> '') then
        KNO.addObject(_KNO, pointer(PERSON_R));
      PersonBemerkungen.free;
    end;
    lPersonen.free;

    // Quellrechnungen auflisten
    AllTheRechnungen := TStringList.create;
    AllTheRechnungenStartIndex := 0;
    for SubDir := 'A' to 'E' do
    begin
      dir(Edit5.text + SubDir + 'DIR\*', AllTheRechnungen, false, false);
      // Pfad vervollständigen!
      if AllTheRechnungen.count > AllTheRechnungenStartIndex then
      begin
        for n := AllTheRechnungenStartIndex to pred(AllTheRechnungen.count) do
          AllTheRechnungen[n] := SubDir + 'DIR\' + AllTheRechnungen[n];
        AllTheRechnungenStartIndex := AllTheRechnungen.count;
      end;
    end;

    for n := 0 to pred(AllTheRechnungen.count) do
    begin
      repeat

        // Person lokalisieren
        _KNO := inttostr(strtointdef(nextp(ExtractFileName(Edit5.text + AllTheRechnungen[n]),
          '.', 0), 0));
        k := KNO.indexof(_KNO);
        if (k = -1) then
          break;

        PersonBemerkungen := e_r_sqlT('select BEMERKUNG from PERSON where RID=' +
          inttostr(PERSON_R));

        PERSON_R := integer(KNO.objects[k]);
        BELEG_R := e_w_BelegNeu(PERSON_R);

        // Ursprüngliche Zeilen laden!
        RechnungInhalt.loadfromfile(Edit5.text + AllTheRechnungen[n]);

        with qBELEG do
        begin
          ParamByName('CROSSREF').AsInteger := BELEG_R;
          if not(Active) then
            open;
          edit;
          FieldByName('BSTATUS').AsString := 'V';
          FieldByName('MEDIUM').AsString := RechnungInhalt[1];
          post;
        end;

        //
        with qPOSTEN do
          for m := 3 to pred(RechnungInhalt.count) do
          begin
            if not(Active) then
              open;
            insert;
            FieldByName('RID').AsInteger := cRID_AutoInc;
            FieldByName('BELEG_R').AsInteger := BELEG_R;
            FieldByName('MENGE').AsInteger := strtointdef(copy(RechnungInhalt[m], 9, 2), 0);
            FieldByName('ARTIKEL').AsString := OEM2Ansi(copy(RechnungInhalt[m], 11, 35));
            FieldByName('PREIS').AsDouble := StrToDouble(copy(RechnungInhalt[m], 47, 8));
            FieldByName('NETTO').AsString := cC_True;
            FieldByName('MWST').AsDouble := 19.0;
            FieldByName('INFO').AsString := 'SATZ1';
            post;
          end;

      until true;
    end;

    qBELEG.free;
    qPOSTEN.free;
    KNO.free;
    RechnungInhalt.free;
    EndHourGlass;
  end;
end;

procedure TFormepIMPORT.Button11Click(Sender: TObject);
var
  lPersonen: TgpIntegerList;
  n, m: integer;
  PERSON_R: integer;
  PersonenBemerkungen: TStringList;
  Betrag1: double;
  Betrag2: double;
  BetragProMonat: double;
  BaustellePrefix: string;
  BAUSTELLE_R: integer;
  qBAUSTELLE: TIB_Query;
  lVertraege: TgpIntegerList;
  BELEG_R: integer;
  BelegINfos: TStringList;
  MANDANT_R: integer;
  qPOSTEN: TIB_Query;
  qBELEG: TIB_Query;
  qVERTRAG: TIB_Query;
begin
  BeginHourGlass;
  qPOSTEN := DataModuleDatenbank.nQuery;
  qPOSTEN.sql.add('select * from POSTEN for insert');
  qBELEG := DataModuleDatenbank.nQuery;
  qBELEG.sql.add('select * from BELEG where RID=:CROSSREF for update');
  qVERTRAG := DataModuleDatenbank.nQuery;
  qVERTRAG.sql.add('select * from VERTRAG for insert');
  MANDANT_R := strtointdef(Edit6.text, 0);
  qBAUSTELLE := DataModuleDatenbank.nQuery;
  qBAUSTELLE.sql.add('select * from BAUSTELLE for insert');

  // Profil03=(D) Dauerauftrag
  // Profil04=(L) Lastschrift
  // Profil05=(M) Manueller Zahler
  // Profil06=(G) anderer zahlt
  // Profil07=(X) Verweigerer
  lPersonen := e_r_sqlm('select RID from PERSON where ' + '(A02=''Y'') or ' + '(A03=''Y'') or ' +
    '(A04=''Y'') or ' + '(A05=''Y'') or ' + '(A06=''Y'')');

  // Verträge zuordnen
  for n := 0 to pred(lPersonen.count) do
  begin
    //
    Label8.caption := inttostr(n) + '/' + inttostr(lPersonen.count);
    application.processmessages;

    //
    PERSON_R := lPersonen[n];
    PersonenBemerkungen := e_r_sqlT('select BEMERKUNG from PERSON where RID=' + inttostr(PERSON_R));
    Betrag1 := strtodoubledef(PersonenBemerkungen.values['BETRAG1'], 0);
    Betrag2 := strtodoubledef(PersonenBemerkungen.values['BETRAG2'], 0);
    BetragProMonat := cPreisRundung(Betrag2 / 3);
    BaustellePrefix := noblank(PersonenBemerkungen.values['OBJEKT']);

    // Baustelle ermitteln
    BAUSTELLE_R := e_r_sql('select RID from BAUSTELLE where NUMMERN_PREFIX=''' +
      BaustellePrefix + '''');

    if (BAUSTELLE_R < cRID_FirstValid) then
    begin
      BAUSTELLE_R := e_w_GEN('GEN_BAUSTELLE');
      with qBAUSTELLE do
      begin
        if not(Active) then
          open;
        insert;
        FieldByName('RID').AsInteger := BAUSTELLE_R;
        FieldByName('NUMMERN_PREFIX').AsString := BaustellePrefix;
        post;
      end;
    end;

    BELEG_R := cRID_NULL;
    BelegINfos := nil;
    // Alle Verträge dieser Baustelle ermitteln!
    lVertraege := e_r_sqlm('select BELEG_R from VERTRAG where baustelle_R=' +
      inttostr(BAUSTELLE_R));
    for m := 0 to pred(lVertraege.count) do
    begin
      BelegINfos := e_r_BelegInfo(lVertraege[m]);
      if BetragProMonat = strtodoubledef(BelegINfos.values['SUMME'], 0) then
      begin
        BELEG_R := lVertraege[m];
        break;
      end;
      FreeAndNil(BelegINfos);
    end;
    if Assigned(BelegINfos) then
      FreeAndNil(BelegINfos);

    if (BELEG_R < cRID_FirstValid) then
    begin
      // Neuanlage des Beleges (Vertragsgrundlage)
      BELEG_R := e_w_BelegNeu(MANDANT_R);

      with qPOSTEN do
      begin
        if not(Active) then
          open;
        insert;
        FieldByName('RID').AsInteger := cRID_AutoInc;
        FieldByName('BELEG_R').AsInteger := BELEG_R;
        FieldByName('MENGE').AsInteger := 1;
        FieldByName('PREIS').AsDouble := BetragProMonat;
        FieldByName('MWST').AsDouble := 19.0;
        FieldByName('NETTO').AsString := cC_False;
        FieldByName('ARTIKEL').AsString := 'Treppenhaus Reinigung';
        FieldByName('INFO').AsString := BaustellePrefix;
        post;
      end;

      e_w_BerechneBeleg(BELEG_R);
    end;

    // Neuanlage des Vertrages
    with qVERTRAG do
    begin
      if not(Active) then
        open;
      insert;
      FieldByName('RID').AsInteger := cRID_AutoInc;
      FieldByName('BELEG_R').AsInteger := BELEG_R;
      FieldByName('BAUSTELLE_R').AsInteger := BAUSTELLE_R;
      FieldByName('PERSON_R').AsInteger := PERSON_R;
      FieldByName('VON').AsString := '01.04.2007';
      FieldByName('VORLAUF').AsInteger := -46;
      FieldByName('WIEDERHOLUNGEN').AsInteger := 3;
      FieldByName('ZEITSPANNE').AsString := 'M';
      post;
    end;

  end;

  //
  lPersonen.free;
  qBAUSTELLE.free;
  qPOSTEN.free;
  qVERTRAG.free;
  EndHourGlass;
end;

procedure TFormepIMPORT.Button12Click(Sender: TObject);
var
  sKONTEN: TStringList;
  n: integer;
  OneLIne: string;
  _KontoNummer: integer;
  _KontoName: string;
begin
  BeginHourGlass;
  // Den aktuellen Kontenrahmen löschen!
  e_x_sql('delete from BUCH where BETRAG is null');

  sKONTEN := TStringList.create;
  sKONTEN.loadfromfile(SystemPath + '\SKR03.txt');

  for n := 0 to pred(sKONTEN.count) do
  begin
    OneLIne := cutblank(sKONTEN[n]);
    if (OneLIne <> '') then
    begin
      _KontoNummer := strtointdef(nextp(OneLIne, ' '), 0);
      _KontoName := OneLIne;
      e_x_sql('insert into BUCH (NAME,KONTO) values (' + '''' + inttostrN(_KontoNummer, 4) + ''',' +
        '''' + _KontoName + ''')');
    end;
  end;
  sKONTEN.free;
  EndHourGlass;
end;

procedure TFormepIMPORT.Button13Click(Sender: TObject);
var
  STEMPEL_AR_R: integer;
  STEMPEL_ER_R: integer;
  AR, AR_MAX: integer;
  ER, ER_MAX: integer;
  qBUCH: TIB_Query;
  GegenKonto: string;

begin

  // AR
  STEMPEL_AR_R := e_r_sql('select RID from STEMPEL where PREFIX=''AR''');
  if (STEMPEL_AR_R < cRID_FirstValid) then
    raise Exception.create('Stempel AR fehlt! Bitte anlegen!');

  // ER
  STEMPEL_ER_R := e_r_sql('select RID from STEMPEL where PREFIX=''ER''');
  if (STEMPEL_ER_R < cRID_FirstValid) then
    raise Exception.create('Stempel ER fehlt! Bitte anlegen!');

  AR_MAX := -1;
  ER_MAX := -1;
  qBUCH := DataModuleDatenbank.nQuery;
  with qBUCH do
  begin
    sql.add('select RID, GEGENKONTO, STEMPEL_R, STEMPEL_DOKUMENT from BUCH where RID=MASTER_R for update');
    open;
    First;
    while not(eof) do
    begin
      GegenKonto := FieldByName('GEGENKONTO').AsString;
      repeat

        // AR
        if pos('AR', GegenKonto) > 0 then
        begin
          AR := strtointdef(nextp(GegenKonto, 'AR', 1), 0);
          if (AR > 0) then
          begin
            GegenKonto := noblank(nextp(GegenKonto, 'AR', 0));
            AR_MAX := max(AR, AR_MAX);
            edit;
            FieldByName('STEMPEL_R').AsInteger := STEMPEL_AR_R;
            FieldByName('STEMPEL_DOKUMENT').AsInteger := AR;
            FieldByName('GEGENKONTO').AsString := inttostrN(strtointdef(GegenKonto, 0), 4);
            post;
          end;
          break;
        end;

        // ER
        if pos('ER', GegenKonto) > 0 then
        begin
          ER := strtointdef(nextp(GegenKonto, 'ER', 1), 0);
          if (ER > 0) then
          begin
            GegenKonto := noblank(nextp(GegenKonto, 'ER', 0));
            ER_MAX := max(ER, ER_MAX);
            edit;
            FieldByName('STEMPEL_R').AsInteger := STEMPEL_ER_R;
            FieldByName('STEMPEL_DOKUMENT').AsInteger := ER;
            FieldByName('GEGENKONTO').AsString := inttostrN(strtointdef(GegenKonto, 0), 4);
            post;
          end;
          break;
        end;

      until true;

      next;
    end;
  end;
  qBUCH.free;

  // Stempel setzen auf das MAX!
  e_x_sql('update STEMPEL set STAND=' + inttostr(AR_MAX) + ' where RID=' + inttostr(STEMPEL_AR_R));
  e_x_sql('update STEMPEL set STAND=' + inttostr(ER_MAX) + ' where RID=' + inttostr(STEMPEL_ER_R));

end;

procedure TFormepIMPORT.Button14Click(Sender: TObject);
var
  drv_txt: TStringList;
  SubDir: Char;
  sDir: TStringList;
  FName: string;
  n: integer;
  OneFound: boolean;
  AnzahlRechnungen: integer;
begin

  // einzelne Rechnung einlesen!
  if not(Assigned(sRechnungen)) then
  begin
    BeginHourGlass;
    sRechnungen := TStringList.create;
    drv_txt := TStringList.create;
    sDir := TStringList.create;
    for SubDir := 'A' to 'E' do
    begin
      dir(Edit1.text + SubDir + 'DIR\*.*', sDir);
      for n := 0 to pred(sDir.count) do
      begin
        FName := Edit1.text + SubDir + 'DIR\' + sDir[n];
        drv_txt.loadfromfile(FName);
        AnzahlRechnungen := e_r_sql('select count(RID) from BELEG where RID=' + drv_txt[1]);
        sRechnungen.add(drv_txt[1] + ';' + FName + ';' + inttostr(AnzahlRechnungen));
      end;
    end;
    sRechnungen.sort;
    sRechnungen.SaveToFile(DiagnosePath + 'EP-Rechnungen.txt');
    drv_txt.free;
    sDir.free;
    EndHourGlass;
  end;

  // einzelne Rechnung ins System!
  OneFound := false;
  for n := 0 to pred(sRechnungen.count) do
    if pos(Edit2.text, sRechnungen[n]) = 1 then
    begin
      ImportRechnung(nextp(sRechnungen[n], ';', 1));
      OneFound := true;
      break;
    end;

  if not(OneFound) then
    ShowMessage('Beleg nicht gefunden!')
end;

procedure TFormepIMPORT.Button15Click(Sender: TObject);
begin
  Edit1.text := MyProgramPath + 'anfisoft\';
end;

procedure TFormepIMPORT.Button16Click(Sender: TObject);
var
  cAUSGANGSRECHNUNGEN: TdboCursor;
  qBUCH: TdboQuery;
  cBELEG: TdboCursor;
  BUCH_R: integer;
  n: integer;
begin
  // 1400er Migration
  BeginHourGlass;
  cAUSGANGSRECHNUNGEN := nCursor;
  qBUCH := nQuery;
  cBELEG := nCursor;

  with qBUCH do
  begin
    sql.add('select * from BUCH');
  end;

  with cBELEG do
  begin
    sql.add('select * from BELEG where RID=:CROSSREF');
  end;

  with cAUSGANGSRECHNUNGEN do
  begin
    sql.add('select * from AUSGANGSRECHNUNG');
    APiFirst;
    ProgressBar1.max := RecordCount;
    n := 0;
    while not(eof) do
    begin
      // in das BUCH kopieren
      qBUCH.insert;

      BUCH_R := e_w_GEN('GEN_BUCH');
      ListBox2.items.add(inttostr(BUCH_R));

      qBUCH.FieldByName('RID').AsInteger := BUCH_R;
      qBUCH.FieldByName('MASTER_R').AsInteger := BUCH_R;
      qBUCH.FieldByName('NAME').AsString := cKonto_Forderungen;
      // nicht Namensgleich
      qBUCH.FieldByName('PERSON_R').Assign(FieldByName('KUNDE_R'));
      qBUCH.FieldByName('WERTSTELLUNG').Assign(FieldByName('VALUTA'));
      // Namensgleich
      qBUCH.FieldByName('BELEG_R').Assign(FieldByName('BELEG_R'));
      qBUCH.FieldByName('TEILLIEFERUNG').Assign(FieldByName('TEILLIEFERUNG'));
      qBUCH.FieldByName('RECHNUNG').Assign(FieldByName('RECHNUNG'));
      qBUCH.FieldByName('DATUM').Assign(FieldByName('DATUM'));
      qBUCH.FieldByName('BETRAG').Assign(FieldByName('BETRAG'));
      qBUCH.FieldByName('TEXT').Assign(FieldByName('TEXT'));
      qBUCH.FieldByName('ZAHLUNGTYP_R').Assign(FieldByName('ZAHLUNGTYP_R'));
      qBUCH.FieldByName('EREIGNIS_R').Assign(FieldByName('EREIGNIS_R'));
      qBUCH.FieldByName('VORGANG').Assign(FieldByName('VORGANG'));
      qBUCH.FieldByName('ZAHLUNGSPFLICHTIGER_R').Assign(FieldByName('ZAHLUNGSPFLICHTIGER_R'));
      qBUCH.FieldByName('POSNO').Assign(FieldByName('POSNO'));
      qBUCH.FieldByName('MANDANT_R').Assign(FieldByName('MANDANT_R'));

      if (FieldByName('VORGANG').AsString = cVorgang_Rechnung) and (FieldByName('BELEG_R').IsNotNull)
      then
      begin
        cBELEG.ParamByName('CROSSREF').AsInteger := FieldByName('BELEG_R').AsInteger;
        cBELEG.open;
        if cBELEG.eof then
          raise Exception.create('Beleg nicht mehr gefunden');
        // qBUCH.FieldByName('DATUM').Assign(cBELEG.FieldByName('RECHNUNG'));
        // qBUCH.FieldByName('WERTSTELLUNG').Assign(cBELEG.FieldByName('FAELLIG'));

        qBUCH.FieldByName('MAHNSTUFE').Assign(cBELEG.FieldByName('MAHNSTUFE'));
        qBUCH.FieldByName('MAHNUNG').Assign(cBELEG.FieldByName('MAHNUNG'));
        qBUCH.FieldByName('MAHNUNG1').Assign(cBELEG.FieldByName('MAHNUNG1'));
        qBUCH.FieldByName('MAHNUNG2').Assign(cBELEG.FieldByName('MAHNUNG2'));
        qBUCH.FieldByName('MAHNUNG3').Assign(cBELEG.FieldByName('MAHNUNG3'));
        qBUCH.FieldByName('MAHNBESCHEID').Assign(cBELEG.FieldByName('MAHNBESCHEID'));
        qBUCH.FieldByName('MAHNUNG_AUSGESETZT').Assign(cBELEG.FieldByName('MAHNUNG_AUSGESETZT'));
        cBELEG.close;
      end;

      qBUCH.post;
      inc(n);
      if (n MOD 10 = 0) then
      begin
        ProgressBar1.position := n;
        application.processmessages;
        if Abbruch.Checked then
          break;
      end;

      ApiNext;
    end;
    close;
  end;
  ProgressBar1.position := 0;

  cAUSGANGSRECHNUNGEN.free;
  qBUCH.close;
  qBUCH.free;
  cBELEG.free;

  // c) Tabelle AUSGANGSRECHNUNG löschen!
  e_x_commit;
  e_x_sql('drop table AUSGANGSRECHNUNG');

  // d) Indexe löschen
  e_x_sql('drop index BELEG_RECHNUNG_A');
  e_x_sql('drop index MAHNUNG_AUSGESETZT_BELEG_A');
  e_x_sql('drop index MAHNUNG_AUSGESETZT_BELEG_D');

  // d) Felder aus BELEG löschen!
  e_x_sql('alter table BELEG drop RECHNUNGS_BETRAG');
  e_x_sql('alter table BELEG drop DAVON_BEZAHLT');
  e_x_sql('alter table BELEG drop RECHNUNG');
  e_x_sql('alter table BELEG drop FAELLIG');
  e_x_sql('alter table BELEG drop MAHNSTUFE');
  e_x_sql('alter table BELEG drop MAHNUNG');
  e_x_sql('alter table BELEG drop MAHNUNG1');
  e_x_sql('alter table BELEG drop MAHNUNG2');
  e_x_sql('alter table BELEG drop MAHNUNG3');
  e_x_sql('alter table BELEG drop MAHNBESCHEID');
  e_x_sql('alter table BELEG drop MAHNUNG_AUSGESETZT');
  // e_x_sql('alter table BELEG drop ABSCHLUSS
  e_x_commit;

  ListBox2.items.add('ENDE');

  EndHourGlass;
end;

procedure TFormepIMPORT.Button17Click(Sender: TObject);
var
  sBISHER: TgpIntegerList;
  sMAIL: TStringList;
  n, r: integer;
  sCSV: TsTable;
  sl: TStringList;
  sl_DeleteCount: integer;
  sl_Dups: TStringList;
  MailAdr: string;
  i, PERSON_R: integer;
  BELEG_R: integer;

  col_Anrede, col_Vorname, col_Nachname, col_eMail: integer;

  Stat_Loeschungen: integer;
  Stat_NeuAnlagen: integer;
  Stat_Eintragungen: integer;

  procedure Log(s: string);
  begin
    ListBox3.items.add(s);
    application.processmessages;
  end;

begin

  // Vorlauf
  Stat_Loeschungen := 0;
  Stat_NeuAnlagen := 0;
  Stat_Eintragungen := 0;
  BELEG_R := strtointdef(Edit8.text, cRID_NULL);
  if BELEG_R < cRID_FirstValid then
    exit;

  // Init
  BeginHourGlass;
  ListBox3.clear;
  sl_Dups := TStringList.create;

  sCSV := TsTable.create;
  if FileExists(MyProgramPath + Edit9.text) then
  begin

    sCSV.InsertFromFile(MyProgramPath + Edit9.text);
    with sCSV do
    begin
      col_Anrede := colof('Anrede');
      if col_Anrede = -1 then
        raise Exception.create('Spalte "Anrede" nicht gefunde!');
      col_Vorname := colof('Vorname');
      if col_Vorname = -1 then
        raise Exception.create('Spalte "Vorname" nicht gefunde!');
      col_Nachname := colof('Nachname');
      if col_Nachname = -1 then
        raise Exception.create('Spalte "Nachname" nicht gefunde!');
      col_eMail := colof('eMail');
      if col_eMail = -1 then
        raise Exception.create('Spalte "eMail" nicht gefunde!');

      Log(inttostr(sCSV.count - 1) + ' Abonennten der Liste');
      sl := col(col_eMail);
      sl.sort;
      removeduplicates(sl, sl_DeleteCount, sl_Dups);
      sl.free;

      Log(inttostr(sl_DeleteCount) + ' sind doppelt:');
      for n := 0 to pred(sl_Dups.count) do
        Log(cERRORText + ' ' + sl_Dups[n] + ' ist doppeltet in der Liste');

    end;
  end;

  // erst mal sehen was schon drin ist
  sBISHER := e_r_sqlm('select PERSON_R from VERTRAG where BELEG_R=' + inttostr(BELEG_R));

  Log(inttostr(sBISHER.count) + ' bisherige Abonennten');

  // die Liste aller eMail-Adresse ermitteln
  sMAIL := e_r_sqlslo('select EMAIL,RID from PERSON where (EMAIL is not null) and (EMAIL<>'''')');

  Log(inttostr(sMAIL.count) + ' Mail Adressen bisher');

  // Alle Mail-Adressen aufsplitten
  for n := pred(sMAIL.count) downto 0 do
  begin
    MailAdr := AnsiLowerCase(noblank(sMAIL[n]));

    while (pos(';', MailAdr) > 0) do
      sMAIL.addObject(nextp(MailAdr, ';'), sMAIL.objects[n]);

    sMAIL[n] := MailAdr;
  end;

  // remove emptys
  for n := pred(sMAIL.count) downto 0 do
    if not(eMailAdresseOK(sMAIL[n])) then
    begin
      Log(cERRORText + ' (RID=' + inttostr(integer(sMAIL.objects[n])) + ') ' + sMAIL[n] +
        ' ist keine gültige eMail Adresse');
      sMAIL.delete(n);
    end;

  Log(inttostr(sMAIL.count) + ' gültige Einzel-Mail Adressen bisher');

  sMAIL.sort;
  sl_Dups.clear;
  removeduplicates(sMAIL, sl_DeleteCount, sl_Dups);

  Log(inttostr(sl_DeleteCount) + ' sind doppelt:');

  for n := 0 to pred(sl_Dups.count) do
    Log(cERRORText + ' (RID=' + inttostr(integer(sl_Dups.objects[n])) + ') ' + sl_Dups[n] +
      ' ist doppeltet in der Liste');

  // OK, nun für jede Newletter-Adresse den RID ermitteln
  ProgressBar1.max := sCSV.count;
  for r := 1 to pred(sCSV.count) do
  begin

    MailAdr := sCSV.readcell(r, col_eMail);
    i := sMAIL.indexof(MailAdr);
    if (i <> -1) then
      PERSON_R := integer(sMAIL.objects[i])
    else
      PERSON_R := cRID_NULL;

    if (PERSON_R < cRID_FirstValid) then
    begin
      PERSON_R := e_w_PersonNeu;
      e_x_sql('update PERSON set ' +
        { EMAIL } 'EMAIL=''' + MailAdr + ''',' +
        { ANREDE } 'ANREDE=''' + sCSV.readcell(r, col_Anrede) + ''',' +
        { VORNAME } 'VORNAME=''' + sCSV.readcell(r, col_Vorname) + ''',' +
        { NACHNAME } 'NACHNAME=''' + sCSV.readcell(r, col_Nachname) + ''' ' +
        { } ' where RID=' + inttostr(PERSON_R));
      inc(Stat_NeuAnlagen);
    end
    else
    begin
      // die Person existierte bereits
      i := sBISHER.indexof(PERSON_R);
      if (i <> -1) then
      begin
        // der hat schon den Vertrag
        sBISHER.delete(i);
        continue;
      end;

    end;

    // Vertrag anlegen
    e_x_sql('insert into VERTRAG (RID,PERSON_R,BELEG_R) values (' +
      { RID } '0,' +
      { PERSON_R } inttostr(PERSON_R) + ',' +
      { BELEG_R } inttostr(BELEG_R) + ')');
    inc(Stat_Eintragungen);

    ProgressBar1.position := r;
  end;

  // Die Übrig gebliebenen nun löschen
  if sCSV.count > 0 then
    for n := 0 to pred(sBISHER.count) do
    begin
      e_x_sql('delete from VERTRAG where ' +
        { PERSON_R } '(PERSON_R=' + inttostr(sBISHER[n]) + ') and ' +
        { BELEG_R } '(BELEG_R=' + inttostr(BELEG_R) + ')');
      inc(Stat_Loeschungen);
    end;

  Log('Loeschungen  :' + inttostr(Stat_Loeschungen));
  Log('NeuAnlagen   :' + inttostr(Stat_NeuAnlagen));
  Log('Eintragungen :' + inttostr(Stat_Eintragungen));
  ProgressBar1.position := 0;

  sBISHER.free;
  sCSV.free;
  sMAIL.free;
  sl_Dups.free;

  ListBox3.items.SaveToFile(DiagnosePath + 'eMail-Migration.txt');
  EndHourGlass;
  openShell(DiagnosePath + 'eMail-Migration.txt');
end;

procedure TFormepIMPORT.Button19Click(Sender: TObject);
{$IFDEF FPSPREADSHEET}
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  MyRPNFormula: TsRPNFormula;
{$ENDIF}
begin
{$IFDEF FPSPREADSHEET}
  MyWorkbook := TsWorkbook.create;
  MyWorksheet := MyWorkbook.AddWorksheet(Str_Worksheet1);

  // Write some cells
  MyWorksheet.WriteNumber(0, 0, 1.0); // A1
  MyWorksheet.WriteNumber(0, 1, 2.0); // B1
  MyWorksheet.WriteNumber(0, 2, 3.0); // C1
  MyWorksheet.WriteNumber(0, 3, 4.0); // D1
  MyWorksheet.WriteUTF8Text(4, 2, Str_Total); // C5
  MyWorksheet.WriteNumber(4, 3, 10); // D5

  { Uncommend this to test large XLS files
    for i := 2 to 20 do
    begin
    MyWorksheet.WriteAnsiText(i, 0, ParamStr(0));
    MyWorksheet.WriteAnsiText(i, 1, ParamStr(0));
    MyWorksheet.WriteAnsiText(i, 2, ParamStr(0));
    MyWorksheet.WriteAnsiText(i, 3, ParamStr(0));
    end;
  }

  // Write the formula E1 = A1 + B1
  SetLength(MyRPNFormula, 3);
  MyRPNFormula[0].ElementKind := fekCell;
  MyRPNFormula[0].col := 0;
  MyRPNFormula[0].Row := 0;
  MyRPNFormula[1].ElementKind := fekCell;
  MyRPNFormula[1].col := 1;
  MyRPNFormula[1].Row := 0;
  MyRPNFormula[2].ElementKind := fekAdd;
  MyWorksheet.WriteRPNFormula(0, 4, MyRPNFormula);

  // Write the formula F1 = ABS(A1)
  SetLength(MyRPNFormula, 2);
  MyRPNFormula[0].ElementKind := fekCell;
  MyRPNFormula[0].col := 0;
  MyRPNFormula[0].Row := 0;
  MyRPNFormula[1].ElementKind := fekABS;
  MyWorksheet.WriteRPNFormula(0, 5, MyRPNFormula);

  // MyFormula.FormulaStr := '';

  // Creates a new worksheet
  MyWorksheet := MyWorkbook.AddWorksheet(Str_Worksheet2);

  // Write some string cells
  MyWorksheet.WriteUTF8Text(0, 0, Str_First);
  MyWorksheet.WriteUTF8Text(0, 1, Str_Second);
  MyWorksheet.WriteUTF8Text(0, 2, Str_Third);
  MyWorksheet.WriteUTF8Text(0, 3, Str_Fourth);
  MyWorksheet.WriteTextRotation(0, 0, rt90DegreeClockwiseRotation);
  MyWorksheet.WriteUsedFormatting(0, 1, [uffBold]);

  // Save the spreadsheet to a file
  MyWorkbook.WriteToFile(DiagnosePath + 'test' + cExcelExtension, sfExcel8, false);
  MyWorkbook.free;
{$ENDIF}
  openShell(DiagnosePath + 'test' + cExcelExtension);
end;

procedure TFormepIMPORT.Button1Click(Sender: TObject);
begin
  BeginHourGlass;
  BreakIt := false;
  if CheckBox1.Checked then
    ImportPersonen;
  if CheckBox2.Checked then
    ImportTiere;
  if CheckBox3.Checked then
    ImportLeistungen;
  if CheckBox4.Checked then
    ImportRechnungen;
  EndHourGlass;
end;

procedure TFormepIMPORT.ImportLeistungen;
const
  MwStAnz = 5;
  iPreiseRunden = false;
  leidatfile = 'leilis.dat'; { Leistungs Verzeichnis }

type
  leirectype = packed record
    abk: string[6]; { Bezeichnungsabkrzung }
    bez: string[35]; { Volle Bezeichnung }
    pre: real48; { Netto Preis }
    meh: byte; { Mehrwertsteuer Klasse }
    typ: byte; { Leistungsklasse }
  end;

var
  mwst_klasse: array [1 .. MwStAnz] of real48;
  leirec: leirectype;
  leirecdatf: file of leirectype;
  leirec_anz: integer;

  function brutto(r: real48; x: real48): real48;
  begin
    if iPreiseRunden then
      brutto := round((r * x) / 10.0) / 10.0
    else
      brutto := round(r * x) / 100.0;
  end;

var
  n, k, p: integer;
  Sortimente: TStringList;
  MwSt_R: array [1 .. MwStAnz] of integer;
  ARTIKEL_GID: integer;
  PaketGroesse: integer;

  procedure CheckAndInsertSortiment(SortimentS: string);
  begin
    if (Sortimente.indexof(SortimentS) = -1) then
      Sortimente.add(SortimentS);
  end;

  procedure InsertLeirecAs(leirec: leirectype; NUMERO: integer; PAKET_R: integer = -1);
  begin
    with leirec, IB_QueryARTIKEL do
    begin
      insert;
      FieldByName('TITEL').AsString := OEM2Ansi(bez);
      FieldByName('CODE').AsString := OEM2Ansi(abk);
      FieldByName('EURO').AsDouble := round(brutto(pre, (100 + mwst_klasse[meh])) * 100.0) / 100.0;
      FieldByName('SORTIMENT_R').AsInteger := integer(Sortimente.objects[k]);
      FieldByName('ERSTEINTRAG').AsDateTime := now;
      FieldByName('NUMERO').AsInteger := NUMERO;

      // keiner Bestandsverwaltung
      FieldByName('MINDESTBESTAND').AsInteger := -1;

      // keine Gewichtsberechnung
      FieldByName('GEWICHT').AsInteger := -1;

      if (PAKET_R > 0) then
      begin
        FieldByName('PAKET_R').AsInteger := PAKET_R;
        FieldByName('PAKET_POSNO').AsInteger := NUMERO;
      end;

      post;
    end;
  end;

begin
  BeginHourGlass;
  mwst_klasse[1] := 19.0;
  mwst_klasse[2] := 7.0;
  mwst_klasse[3] := 0.0;
  mwst_klasse[4] := 0.0;
  mwst_klasse[5] := 0.0;

  //
  // Mehrwertsteuerklassen anlegen
  //
  with IB_QueryMWST do
  begin
    open;
    for n := 1 to MwStAnz do
    begin
      while true do
      begin
        if locate('SATZ', mwst_klasse[n], []) then
          break;

        //
        insert;
        FieldByName('SATZ').AsDouble := mwst_klasse[n];
        post;
        refresh;
      end;
      MwSt_R[n] := FieldByName('RID').AsInteger;
    end;
    close;
  end;

  //
  // Sortimente ermitteln
  //

  Sortimente := TStringList.create;
  assignFile(leirecdatf, Edit1.text + leidatfile);
{$I-} reset(leirecdatf); {$I+}
  leirec_anz := filesize(leirecdatf);
  for n := 1 to leirec_anz do
  begin
    seek(leirecdatf, n - 1);
    read(leirecdatf, leirec);
    with leirec do
    begin
      CheckAndInsertSortiment(inttostrN(typ, 2) + ',' + inttostrN(meh, 2));
    end;
  end;

  //
  // Sortimente anlegen!
  //
  with IB_QuerySORTIMENT do
  begin
    open;
    for n := 0 to pred(Sortimente.count) do
    begin
      while true do
      begin
        if locate('BEZEICHNUNG', Sortimente[n], []) then
          break;
        insert;
        FieldByName('BEZEICHNUNG').AsString := Sortimente[n];
        FieldByName('MWST_R').AsInteger := MwSt_R[strtoint(nextp(Sortimente[n], ',', 1))];
        FieldByName('NAECHSTE_NUMMER').AsInteger := -1;
        post;
        refresh;
      end;
      Sortimente.objects[n] := TObject(FieldByName('RID').AsInteger);
    end;
    close;
  end;

  //
  // alle Leistungen eintragen
  //
  with IB_QueryARTIKEL do
  begin
    open;
    for n := 1 to leirec_anz do
    begin
      seek(leirecdatf, n - 1);
      read(leirecdatf, leirec);
      with leirec do
      begin
        k := Sortimente.indexof(inttostrN(typ, 2) + ',' + inttostrN(meh, 2));
        if (k <> -1) then
        begin
          ARTIKEL_GID := GEN_ID('ARTIKEL_GID', 0) + 1;

          InsertLeirecAs(leirec, ARTIKEL_GID);

        end
        else
        begin
          ShowMessage('Fehler: Sortiment nicht gefunden');
        end;
      end;
    end;
    close;
  end;
  closeFile(leirecdatf);
  EndHourGlass;
end;

procedure TFormepIMPORT.ImportPersonen;
type
  Tadresse = packed record
    ind: string[10]; { ersten 5 Buchstaben nam }
    { ersten 3 Buchstaben str }
    { letzen 2 Ziffern von str }
    { Beispiel : FILSIAM 01 }
    { Beispiel : HAAS HER22 }
    anr: string[1]; { Anrede }
    nam: string[30]; { Name des Kunden }
    str: string[25]; { Straáe }
    ort: string[25]; { Wohnort }
    tel: string[25]; { Telefon }
    ber: string[15]; { Beruf }
    geb: TANFiXDate; { Geburtsdatum }
    bes: TANFiXDate; { Datum des Letzen Besuches }
    zah: string[30]; { Zahlungsfeld }
    off: string[10]; { Offene Posten }
    bem: string[50]; { Bemerkungen }
    kon: longint; { Kodierte Kontonummer }
  end;

var
  ImpF: TStringList;
  Kunrec: Tadresse;
  MaxKonNum: integer;
  n: integer;
  CrossReference: integer;
  OneLIne: string;
  Bemerkungen: TStringList;
  StartTime: dword;
  LAND_R: integer;

  function extract_plz(fullS: string): integer;
  var
    k: integer;
  begin
    k := pos('-', fullS);
    if (k > 0) and (k < 4) then
      fullS := nextp(fullS, '-');
    result := strtointdef(nextp(fullS, ' '), 0);
  end;

  function extract_land(fullS: string): string;
  var
    k: integer;
  begin
    k := pos('-', fullS);
    if (k > 0) and (k < 4) then
      result := nextp(fullS, '-') + '-'
    else
      result := 'D-';
  end;

  function extract_ort(fullS: string): string;
  begin
    nextp(fullS, ' ');
    result := fullS;
  end;

  function _anrede: string;
  begin
    result := '';
    if length(Kunrec.anr) > 0 then
      case Kunrec.anr[1] of
        '1':
          result := 'Herrn';
        '2':
          result := 'Frau';
        '3':
          result := 'Firma';
        '4':
          result := 'Familie';
        '5':
          result := 'Landwirt';
        '6':
          result := 'Tierheim';
      end;
  end;

  function _ansprache: string;

    function NamenTitel: string;
    var
      h2, vk, nk: string[35];
      kpos: byte;
    begin
      h2 := Kunrec.nam;
      kpos := pos(',', h2);
      if kpos = 0 then
        result := h2;

      vk := cutblank(copy(h2, 1, kpos - 1));
      nk := cutblank(copy(h2, kpos + 1, 100));

      result := '';

      if pos(' ', nk) <> 0 then
      begin
        if (nk[pos(' ', nk) - 1] = '.') then { Titel }
        begin
          result := copy(nk, 1, pos(' ', nk));
          delete(nk, 1, pos(' ', nk));
        end;
      end;

      if pos(' ', nk) <> 0 then
      begin
        result := result + copy(nk, pos(' ', nk) + 1, 100) + ' ';
      end;

      result := result + vk;
    end;

  begin
    result := '';
    if length(Kunrec.anr) > 0 then
      case Kunrec.anr[1] of
        '1':
          result := 'Sehr geehrter Herr ' + NamenTitel;
        '2':
          result := 'Sehr geehrte Frau ' + NamenTitel;
        '3':
          result := 'Sehr geehrte Damen und Herren';
        '4':
          result := 'Liebe Familie ' + NamenTitel;
        '5':
          result := 'Sehr geehrter Herr ' + NamenTitel;
        '6':
          result := 'Liebes Tierheim ' + NamenTitel;
      end;
  end;

  function _vorname(s: string): string;
  var
    k: integer;
  begin
    k := pos(',', s);
    if (k = 0) then
      result := s
    else
      result := cutblank(copy(s, succ(k), MaxInt));
  end;

  function _nachname(s: string): string;
  var
    k: integer;
  begin
    k := pos(',', s);
    if k = 0 then
      result := ''
    else
      result := cutblank(copy(s, 1, pred(k)));
  end;

begin

  // Patientenbesitzer
  Bemerkungen := TStringList.create;
  ImpF := TStringList.create;
  ImpF.loadfromfile(Edit1.text + 'KREO.TXT');
  MaxKonNum := -1;
  IB_QueryANSCHRIFT.open;
  IB_QueryPERSON.open;
  StartTime := 0;

  //
  ProgressBar1.max := ImpF.count;
  for n := 0 to pred(ImpF.count) do
  begin

    OneLIne := ImpF[n];
    with Kunrec do
    begin
      ind := nextp(OneLIne, cDelimiter);
      anr := nextp(OneLIne, cDelimiter);
      nam := OEM2Ansi(nextp(OneLIne, cDelimiter));
      str := OEM2Ansi(nextp(OneLIne, cDelimiter));
      ort := OEM2Ansi(nextp(OneLIne, cDelimiter));
      tel := OEM2Ansi(nextp(OneLIne, cDelimiter));
      ber := OEM2Ansi(nextp(OneLIne, cDelimiter));
      geb := date2long(nextp(OneLIne, cDelimiter));
      bes := date2long(nextp(OneLIne, cDelimiter));
      zah := OEM2Ansi(nextp(OneLIne, cDelimiter));
      off := OEM2Ansi(nextp(OneLIne, cDelimiter));
      bem := OEM2Ansi(nextp(OneLIne, cDelimiter));
      kon := strtointdef(nextp(OneLIne, cDelimiter), 0);
      MaxKonNum := max(MaxKonNum, kon);
    end;

    with IB_QueryPERSON do
    begin

      if locate('NUMMER', Kunrec.kon, []) then
        continue;

      CrossReference := GEN_ID('GLOBAL_GID', 0) + 1;
      with IB_QueryANSCHRIFT do
      begin
        insert;
        FieldByName('RID').AsInteger := 0;
        FieldByName('STRASSE').AsString := Kunrec.str;
        FieldByName('PLZ').AsInteger := extract_plz(Kunrec.ort);
        LAND_R := e_r_LaenderRIDfromALT(extract_land(Kunrec.ort));
        if (LAND_R >= cRID_FirstValid) then
          FieldByName('LAND_R').AsInteger := LAND_R
        else
          FieldByName('LAND_R').AsInteger := iHeimatLand;
        FieldByName('ORT').AsString := extract_ort(Kunrec.ort);
        post;
      end;

      insert;
      FieldByName('NUMMER').AsInteger := Kunrec.kon;
      FieldByName('PRIV_ANSCHRIFT_R').AsInteger := CrossReference;
      FieldByName('RID').AsInteger := 0;
      FieldByName('EINTRAG').AsDateTime := now;

      FieldByName('VORNAME').AsString := _vorname(Kunrec.nam);
      FieldByName('NACHNAME').AsString := _nachname(Kunrec.nam);
      FieldByName('INT_ANREDE_R').AsInteger := strtointdef(Kunrec.anr, 0);

      if DateExact(Kunrec.bes) then
        FieldByName('KONTAKTAM').AsDate := long2datetime(Kunrec.bes);
      FieldByName('SUCHBEGRIFF').AsString := Kunrec.ind;
      FieldByName('PRIV_TEL').AsString := Kunrec.tel;

      if DateExact(Kunrec.geb) then
        FieldByName('GEBURTSTAG').AsDate := long2datetime(Kunrec.geb);
      FieldByName('BERUF').AsString := Kunrec.ber;
      Bemerkungen.clear;
      Bemerkungen.add('Zahlungsbemerkung=' + Kunrec.zah);
      Bemerkungen.add('OffenePosten=' + Kunrec.off);
      Bemerkungen.add('Bermerkung=' + Kunrec.bem);
      Bemerkungen.add('ANREDE=' + _anrede);
      Bemerkungen.add('ANSPRACHE=' + _ansprache);
      FieldByName('BEMERKUNG').Assign(Bemerkungen);
      post;
    end;

    // SetGen/ 'NK_KUNDE' := MaxKonNum;
    if frequently(StartTime, 500) or (n = pred(ImpF.count)) then
    begin
      application.processmessages;
      ProgressBar1.position := n;
    end;

    if BreakIt then
      break;

  end;
  IB_QueryANSCHRIFT.close;
  IB_QueryPERSON.close;
  ImpF.free;
  Bemerkungen.free;
  ProgressBar1.position := 0;
  EndHourGlass;
end;

procedure TFormepIMPORT.ImportRechnungen;

const
  iPreiseRunden = false;
  MwStAnz = 5;
  recnumfile = 'recnum.dat'; { Laufenden Rechnungsnummer }

var
  //
  SubDir: Char;
  AllTheRechnungen: TStringList;
  CursorPERSON: TIB_Cursor;
  mwst_klasse: array [1 .. MwStAnz] of real48;

  PERSON_R: integer;
  BELEG_R: integer;
  BELEG_R_MAX: integer;

  // Rechnungstitel
  rbNummer: integer;
  rbDatumAnlage: TANFiXDate;
  rbDatumRechnung: TANFiXDate;
  rbDatumM1: TANFiXDate;
  rbDatumM2: TANFiXDate;

  rbBetrag: double;
  rbAnzahlung: double;

  // Rechnungspositionen
  rpDatum: TANFiXDate;
  rpMenge: integer;
  rpBezeichnung: string;
  rpMwSt: double;
  rpPreis: double;
  rpEURO: double;

  //
  n, m: integer;
  drv_txt: TStringList;
  drv_poi: integer;
  StartTime: dword;

  procedure sql(s: string);
  var
    IB_Script: TIB_DSQL;
  begin
    IB_Script := DataModuleDatenbank.nDSQL;
    with IB_Script do
    begin
      sql.add(s);
      execute;
    end;
    IB_Script.free;
  end;

  function brutto(r: real48; x: real48): real48;
  begin
    if iPreiseRunden then
      brutto := round((r * x) / 10.0) / 10.0
    else
      brutto := round(r * x) / 100.0;
  end;

  function inc_recnum: longint;
  var
    zae: longint;
    numdatf: file of longint;
  begin
    assignFile(numdatf, Edit1.text + recnumfile);
{$I-} reset(numdatf); {$I+}
    read(numdatf, zae);
    inc_recnum := zae;
    inc(zae);
    seek(numdatf, 0);
    write(numdatf, zae);
    closeFile(numdatf);
  end;

begin
  // init
  mwst_klasse[1] := 19.0;
  mwst_klasse[2] := 7.0;
  mwst_klasse[3] := 0.0;
  mwst_klasse[4] := 0.0;
  mwst_klasse[5] := 0.0;
  ListBox1.items.clear;
  drv_txt := TStringList.create;
  AllTheRechnungen := TStringList.create;
  BELEG_R_MAX := 0;

  sql('delete from warenbewegung');
  sql('delete from versand');
  sql('delete from BUCH');
  sql('delete from posten');
  sql('delete from geliefert');
  sql('delete from versand');
  sql('delete from ereignis');
  sql('delete from beleg');

  // suche Rechnungen ...
  for SubDir := 'A' to 'E' do
  begin
    dir(Edit1.text + SubDir + 'DIR\*.*', AllTheRechnungen);
    for n := 0 to pred(AllTheRechnungen.count) do
      AllTheRechnungen[n] := AllTheRechnungen[n] + ',' + SubDir + 'DIR';
    ListBox1.items.addstrings(AllTheRechnungen);
  end;
  AllTheRechnungen.Assign(ListBox1.items);

  CursorPERSON := DataModuleDatenbank.nCursor;
  with CursorPERSON do
  begin
    sql.add('select RID from Person where nummer=:CROSSREF');
  end;

  // verarbeite Rechnungen
  ProgressBar1.max := AllTheRechnungen.count;
  ListBox1.clear;
  StartTime := 0;
  for n := 0 to pred(AllTheRechnungen.count) do
  begin
    if BreakIt then
      break;

    //
    ListBox1.items.add(AllTheRechnungen[n]);

    // PERSON_R ermitteln
    with CursorPERSON do
    begin
      CursorPERSON.ParamByName('CROSSREF').AsInteger :=
        strtoint(nextp(AllTheRechnungen[n], '.', 0));
      open;
      APiFirst;
      if eof then
        continue;
      PERSON_R := FieldByName('RID').AsInteger;
      close;
    end;
    ListBox1.items.add('RID:' + inttostr(PERSON_R));

    rbBetrag := 0.0;
    rbAnzahlung := 0.0;

    // Rechnung laden
    drv_txt.loadfromfile(Edit1.text + nextp(AllTheRechnungen[n], ',', 1) + '\' +
      nextp(AllTheRechnungen[n], ',', 0));

    // Länge runterkürzen
    for m := pred(drv_txt.count) downto 0 do
      if copy(drv_txt[m], 11, 35) = fill(' ', 35) then
        drv_txt.delete(m);

    { Initialisieren der Eingabe Variable }
    rbDatumAnlage := date2long(copy(drv_txt[0], 1, 8));
    rbDatumRechnung := date2long(copy(drv_txt[0], 9, 8));
    rbDatumM1 := date2long(copy(drv_txt[0], 17, 8));
    rbDatumM2 := date2long(copy(drv_txt[0], 25, 8));
    rbNummer := strtoint(drv_txt[1]);

    BELEG_R_MAX := max(BELEG_R_MAX, rbNummer);

    with IB_QueryBELEG do
    begin
      insert;
      FieldByName('PERSON_R').AsInteger := PERSON_R;
      FieldByName('RID').AsInteger := rbNummer;
      FieldByName('MEDIUM').AsString := 'EP';
      FieldByName('MOTIVATION').AsString := 'Originalsumme ' + drv_txt[2];
      if DateOK(rbDatumM1) then
      begin
        FieldByName('MAHNUNG1').AsDate := long2datetime(rbDatumM1);
        FieldByName('MAHNSTUFE').AsInteger := 1;
      end;
      if DateOK(rbDatumM2) then
      begin
        FieldByName('MAHNUNG2').AsDate := long2datetime(rbDatumM2);
        FieldByName('MAHNSTUFE').AsInteger := 2;
      end;
      if DateOK(rbDatumRechnung) then
        FieldByName('RECHNUNG').AsDate := long2datetime(rbDatumRechnung);
      if DateOK(rbDatumAnlage) then
        FieldByName('ANLAGE').AsDate := long2datetime(rbDatumAnlage);
      FieldByName('BTYP').AsString := 'p';
      FieldByName('EINZELPREIS_NETTO').AsString := 'Y';
      post;
    end;

    for drv_poi := 3 to pred(drv_txt.count) do
    begin

      // Daten umsetzen
      rpDatum := date2long(copy(drv_txt[drv_poi], 1, 8));
      rpMenge := strtointdef(cutblank(copy(drv_txt[drv_poi], 9, 2)), 0);
      rpBezeichnung := OEM2Ansi(cutrblank(copy(drv_txt[drv_poi], 11, 35)));
      rpMwSt := mwst_klasse[strtoint(drv_txt[drv_poi][46])];
      rpPreis := StrToDouble(copy(drv_txt[drv_poi], 47, 7));
      rpEURO := round(brutto(rpPreis, 100 + rpMwSt) * 100.0) / 100.0;

      if (copy(drv_txt[drv_poi], 11, 2) <> '*a') then
      begin

        // normaler Posten buchen
        rbBetrag := rbBetrag + rpMenge * rpEURO;
        with IB_QueryPOSTEN do
        begin
          insert;
          FieldByName('BELEG_R').AsInteger := rbNummer;
          if DateOK(rpDatum) then
            FieldByName('AUSFUEHRUNG').AsDateTime := long2datetime(rpDatum);
          FieldByName('MENGE').AsInteger := rpMenge;
          FieldByName('MWST').AsDouble := rpMwSt;
          FieldByName('PREIS').AsDouble := rpEURO;
          FieldByName('ARTIKEL').AsString := rpBezeichnung;
          post;
        end;

      end
      else
      begin

        // Anzahlung buchen!
        rbAnzahlung := rbAnzahlung + rpPreis;
        with IB_QueryPOSTEN do
        begin
          insert;
          FieldByName('BELEG_R').AsInteger := rbNummer;
          if DateOK(rpDatum) then
            FieldByName('AUSFUEHRUNG').AsDateTime := long2datetime(rpDatum);
          FieldByName('MENGE').AsInteger := 0;
          FieldByName('PREIS').AsDouble := -rpPreis;
          FieldByName('ARTIKEL').AsString := format('Anzahlung %s', [rpBezeichnung]);
          post;
        end;
      end;
    end;

    // Bereits berechnet?
    if DateOK(rbDatumRechnung) then
    begin
      e_w_BelegBuchen(rbNummer);
      // Teilweise ausgeglichen?
      if isSomeMoney(rbAnzahlung) then
      begin
        b_w_ForderungAusgleich(format(cBuch_Ausgleich, [PERSON_R, rbNummer, rbAnzahlung,
          long2date(rbDatumRechnung), cRID_NULL, 'Anzahlung', cKonto_DurchlaufenderPosten, 0,
          cRID_NULL]));
      end;
    end;

    if frequently(StartTime, 222) then
    begin
      application.processmessages;
      ProgressBar1.position := n;
    end;

  end;
  sql('SET GENERATOR BELEG_GID TO ' + inttostr(inc_recnum));
  CursorPERSON.close;
  CursorPERSON.free;
  IB_QueryBELEG.close;
  IB_QueryPOSTEN.close;
  IB_QueryFORDERUNG.close;
  AllTheRechnungen.free;
  drv_txt.free;
  ProgressBar1.position := 0;
end;

procedure TFormepIMPORT.ImportRechnung;

const
  iPreiseRunden = false;
  MwStAnz = 5;
  recnumfile = 'recnum.dat'; { Laufenden Rechnungsnummer }

var
  //
  SubDir: Char;
  CursorPERSON: TIB_Cursor;
  mwst_klasse: array [1 .. MwStAnz] of real48;

  PERSON_R: integer;
  BELEG_R: integer;
  BELEG_R_MAX: integer;

  // Rechnungstitel
  rbNummer: integer;
  rbDatumAnlage: TANFiXDate;
  rbDatumRechnung: TANFiXDate;
  rbDatumM1: TANFiXDate;
  rbDatumM2: TANFiXDate;

  rbBetrag: double;
  rbAnzahlung: double;

  // Rechnungspositionen
  rpDatum: TANFiXDate;
  rpMenge: integer;
  rpBezeichnung: string;
  rpMwSt: double;
  rpPreis: double;
  rpEURO: double;

  //
  n, m: integer;
  drv_txt: TStringList;
  drv_poi: integer;
  StartTime: dword;
  NUMMER: integer;

  procedure sql(s: string);
  var
    IB_Script: TIB_DSQL;
  begin
    IB_Script := DataModuleDatenbank.nDSQL;
    with IB_Script do
    begin
      sql.add(s);
      execute;
    end;
    IB_Script.free;
  end;

  function brutto(r: real48; x: real48): real48;
  begin
    if iPreiseRunden then
      brutto := round((r * x) / 10.0) / 10.0
    else
      brutto := round(r * x) / 100.0;
  end;

  function inc_recnum: longint;
  var
    zae: longint;
    numdatf: file of longint;
  begin
    assignFile(numdatf, Edit1.text + recnumfile);
{$I-} reset(numdatf); {$I+}
    read(numdatf, zae);
    inc_recnum := zae;
    inc(zae);
    seek(numdatf, 0);
    write(numdatf, zae);
    closeFile(numdatf);
  end;

begin
  // init
  BeginHourGlass;
  mwst_klasse[1] := 19.0;
  mwst_klasse[2] := 7.0;
  mwst_klasse[3] := 0.0;
  mwst_klasse[4] := 0.0;
  mwst_klasse[5] := 0.0;
  drv_txt := TStringList.create;
  BELEG_R_MAX := 0;

  CursorPERSON := DataModuleDatenbank.nCursor;
  with CursorPERSON do
  begin
    sql.add('select RID from Person where nummer=:CROSSREF');
  end;

  // verarbeite Rechnungen
  n := revpos('.', FName);
  NUMMER := strtointdef(copy(FName, n - 6, 6), 0);

  // PERSON_R ermitteln
  with CursorPERSON do
  begin
    CursorPERSON.ParamByName('CROSSREF').AsInteger := NUMMER;
    open;
    APiFirst;
    if eof then
      raise Exception.create('PERSON ' + inttostr(NUMMER) + ' nicht gefunden!');
    PERSON_R := FieldByName('RID').AsInteger;
    close;
  end;

  rbBetrag := 0.0;
  rbAnzahlung := 0.0;

  // Rechnung laden
  drv_txt.loadfromfile(FName);

  // Länge runterkürzen
  for m := pred(drv_txt.count) downto 0 do
    if copy(drv_txt[m], 11, 35) = fill(' ', 35) then
      drv_txt.delete(m);

  { Initialisieren der Eingabe Variable }
  rbDatumAnlage := date2long(copy(drv_txt[0], 1, 8));
  rbDatumRechnung := date2long(copy(drv_txt[0], 9, 8));
  rbDatumM1 := date2long(copy(drv_txt[0], 17, 8));
  rbDatumM2 := date2long(copy(drv_txt[0], 25, 8));
  rbNummer := strtoint(drv_txt[1]);

  BELEG_R_MAX := max(BELEG_R_MAX, rbNummer);

  with IB_QueryBELEG do
  begin
    insert;
    FieldByName('PERSON_R').AsInteger := PERSON_R;
    FieldByName('RID').AsInteger := rbNummer;
    FieldByName('NUMMER').AsInteger := rbNummer;
    FieldByName('MEDIUM').AsString := 'EP';
    FieldByName('MOTIVATION').AsString := 'Originalsumme ' + drv_txt[2];
    if DateOK(rbDatumM1) then
    begin
      FieldByName('MAHNUNG1').AsDate := long2datetime(rbDatumM1);
      FieldByName('MAHNSTUFE').AsInteger := 1;
    end;
    if DateOK(rbDatumM2) then
    begin
      FieldByName('MAHNUNG2').AsDate := long2datetime(rbDatumM2);
      FieldByName('MAHNSTUFE').AsInteger := 2;
    end;
    if DateOK(rbDatumRechnung) then
      FieldByName('RECHNUNG').AsDate := long2datetime(rbDatumRechnung);
    if DateOK(rbDatumAnlage) then
      FieldByName('ANLAGE').AsDate := long2datetime(rbDatumAnlage);
    FieldByName('BTYP').AsString := 'p';
    FieldByName('EINZELPREIS_NETTO').AsString := 'Y';
    post;
  end;

  for drv_poi := 3 to pred(drv_txt.count) do
  begin

    // Daten umsetzen
    rpDatum := date2long(copy(drv_txt[drv_poi], 1, 8));
    rpMenge := strtointdef(cutblank(copy(drv_txt[drv_poi], 9, 2)), 0);
    rpBezeichnung := OEM2Ansi(cutrblank(copy(drv_txt[drv_poi], 11, 35)));
    rpMwSt := mwst_klasse[strtoint(drv_txt[drv_poi][46])];
    rpPreis := StrToDouble(copy(drv_txt[drv_poi], 47, 7));
    rpEURO := round(brutto(rpPreis, 100 + rpMwSt) * 100.0) / 100.0;

    if (copy(drv_txt[drv_poi], 11, 2) <> '*a') then
    begin

      // normaler Posten buchen
      rbBetrag := rbBetrag + rpMenge * rpEURO;
      with IB_QueryPOSTEN do
      begin
        insert;
        FieldByName('BELEG_R').AsInteger := rbNummer;
        if DateOK(rpDatum) then
          FieldByName('AUSFUEHRUNG').AsDateTime := long2datetime(rpDatum);
        FieldByName('MENGE').AsInteger := rpMenge;
        FieldByName('MWST').AsDouble := rpMwSt;
        FieldByName('PREIS').AsDouble := rpEURO;
        FieldByName('ARTIKEL').AsString := rpBezeichnung;
        post;
      end;

    end
    else
    begin

      // Anzahlung buchen!
      rbAnzahlung := rbAnzahlung + rpPreis;
      with IB_QueryPOSTEN do
      begin
        insert;
        FieldByName('BELEG_R').AsInteger := rbNummer;
        if DateOK(rpDatum) then
          FieldByName('AUSFUEHRUNG').AsDateTime := long2datetime(rpDatum);
        FieldByName('MENGE').AsInteger := 0;
        FieldByName('PREIS').AsDouble := -rpPreis;
        FieldByName('ARTIKEL').AsString := format('Anzahlung %s', [rpBezeichnung]);
        post;
      end;
    end;
  end;

  // Bereits berechnet?
  if DateOK(rbDatumRechnung) then
  begin
    e_w_BelegBuchen(rbNummer);
    // Teilweise ausgeglichen?
    if isSomeMoney(rbAnzahlung) then
    begin
      b_w_ForderungAusgleich(format(cBuch_Ausgleich, [PERSON_R, rbNummer, rbAnzahlung,
        long2date(rbDatumRechnung), cRID_NULL, 'Anzahlung', cKonto_DurchlaufenderPosten, 0,
        cRID_NULL]));
    end;
  end;

  CursorPERSON.close;
  CursorPERSON.free;
  IB_QueryBELEG.close;
  IB_QueryPOSTEN.close;
  IB_QueryFORDERUNG.close;
  drv_txt.free;
  EndHourGlass;
end;

procedure TFormepIMPORT.ImportTiere;

type
  Ttierrec = record
    ind: integer; { Eigener Index }
    art: string[15]; { Tierart }
    ras: string[15]; { Rasse }
    nam: string[15]; { Name }
    geb: TANFiXDate; { Geburtsdatum }
    ges: string[2]; { Geschlecht }
    tae: string[10]; { T„towier Nummer }
    imp: string[50]; { Bemerkungen zur Impfumg }
    kra: string[50]; { Krankheitsbild }
  end;

var
  NummerCursor: TIB_Cursor;
  ImpF: TStringList;
  tierec: Ttierrec;

  Impfung, Krankheit: TStringList;
  OneLIne: string;
  n: integer;
  StartTime: dword;
begin
  //
  //
  //
  BeginHourGlass;
  StartTime := 0;
  Impfung := TStringList.create;
  Krankheit := TStringList.create;
  NummerCursor := DataModuleDatenbank.nCursor;
  with NummerCursor do
  begin
    sql.add('SELECT RID FROM PERSON WHERE NUMMER=:CROSSREF');
  end;
  ImpF := TStringList.create;
  ImpF.loadfromfile(Edit1.text + 'TREO.TXT');
  ProgressBar1.max := ImpF.count;
  for n := 0 to pred(ImpF.count) do
  begin
    OneLIne := ImpF[n];
    with tierec do
    begin
      ind := strtoint(nextp(OneLIne, cDelimiter));
      art := OEM2Ansi(nextp(OneLIne, cDelimiter));
      ras := OEM2Ansi(nextp(OneLIne, cDelimiter));
      nam := OEM2Ansi(nextp(OneLIne, cDelimiter));
      geb := date2long(nextp(OneLIne, cDelimiter));
      ges := OEM2Ansi(nextp(OneLIne, cDelimiter));
      tae := OEM2Ansi(nextp(OneLIne, cDelimiter));
      imp := OEM2Ansi(nextp(OneLIne, cDelimiter));
      kra := OEM2Ansi(nextp(OneLIne, cDelimiter));
    end;
    NummerCursor.ParamByName('CROSSREF').AsInteger := tierec.ind;
    NummerCursor.open;
    if not(NummerCursor.eof) then
    begin
      with IB_QueryTIER do
      begin
        if not(Active) then
          open;
        insert;
        FieldByName('PERSON_R').AsInteger := NummerCursor.FieldByName('RID').AsInteger;
        FieldByName('ART').AsString := tierec.art;
        FieldByName('RASSE').AsString := tierec.ras;
        FieldByName('NAME').AsString := tierec.nam;
        FieldByName('GEBURT').AsInteger := tierec.geb;
        FieldByName('GESCHLECHT').AsString := tierec.ges;
        FieldByName('TAETOWIERNUMMER').AsString := tierec.tae;
        Impfung.clear;
        Impfung.add(tierec.imp);
        FieldByName('IMPFUNG').Assign(Impfung);
        Krankheit.clear;
        Krankheit.add(tierec.kra);
        FieldByName('KRANKHEIT').Assign(Krankheit);
        post;
      end;
    end
    else
    begin
      ListBox1.items.add(inttostr(tierec.ind));
    end;
    NummerCursor.close;
    if frequently(StartTime, 222) or (n = pred(ImpF.count)) then
    begin
      ProgressBar1.position := n;
      application.processmessages;
    end;
  end;
  ImpF.free;
  Impfung.free;
  Krankheit.free;
  ProgressBar1.position := 0;
  EndHourGlass;
end;

procedure TFormepIMPORT.Button2Click(Sender: TObject);
begin
  BreakIt := true;
end;

procedure TFormepIMPORT.FormActivate(Sender: TObject);
begin
  if (Edit4.text = '') then
    Edit4.text := iDataBaseHost + ':' + i_c_DataBasePath + 'gazma.539.fdb';
end;

procedure TFormepIMPORT.Button4Click(Sender: TObject);

var
  rCONNECTION: TIB_Connection;
  rTRANSACTION: TIB_Transaction;
  qAUFTRAG: TIB_Query;
  cRIDs: TIB_Cursor;
  StartTime: dword;
  RecN: integer;
  n: integer;
  SourceDestTable: string;
  ExceptionCount: integer;
  BackupGID: integer;
  Anz_Inserts: integer;

  qPERSON: TIB_Query;
  qANSCHRIFT: TIB_Query;
  cMONTEUR: TIB_Cursor;
  cAUFTRAGGEBER: TIB_Cursor;

  procedure Log(s: string);
  begin
    if frequently(StartTime, 777) then
    begin
      Label3.caption := s;
      application.processmessages;
    end;
  end;

  procedure BulkCopy(TableName: string);
  var
    cBAUSTELLE: TIB_Cursor;
    qBAUSTELLE: TIB_Query;
    n: integer;
  begin

    cBAUSTELLE := DataModuleDatenbank.nCursor;
    qBAUSTELLE := DataModuleDatenbank.nQuery;
    with qBAUSTELLE do
    begin
      sql.add('select * from ' + TableName + ' where RID=:CROSSREF for update');
    end;

    with cBAUSTELLE do
    begin
      IB_connection := rCONNECTION;
      sql.add('select * from ' + TableName);
      APiFirst;
      while not(eof) do
      begin

        repeat
          if qBAUSTELLE.Active then
            qBAUSTELLE.close;
          qBAUSTELLE.ParamByName('CROSSREF').AsInteger := cBAUSTELLE.FieldByName('RID').AsInteger;
          qBAUSTELLE.open;
          if qBAUSTELLE.eof then
          begin
            qBAUSTELLE.insert;
            qBAUSTELLE.FieldByName('RID').AsInteger := 0;
            qBAUSTELLE.post;
          end
          else
            break;
        until false;

        qBAUSTELLE.edit;
        for n := 0 to pred(FieldCount) do
          if Fields[n].IsNotNull then
            qBAUSTELLE.FieldByName(Fields[n].FieldName).Assign(Fields[n])
          else
            qBAUSTELLE.FieldByName(Fields[n].FieldName).clear;
        qBAUSTELLE.post;
        Log(TableName + ' ' + FieldByName('RID').AsString);
        ApiNext;
      end;
    end;
    cBAUSTELLE.free;
    qBAUSTELLE.free;
  end;

  procedure InsertData(HauptDatensatz: boolean);
  var
    n: integer;
    cAUFTRAG: TIB_Cursor;
  begin
    if not(BreakIt) then
    begin
      StartTime := 0;
      RecN := 0;
      ExceptionCount := 0;

      cAUFTRAG := DataModuleDatenbank.nCursor;
      with cAUFTRAG do
      begin
        IB_connection := rCONNECTION;
        sql.add('select * from ' + SourceDestTable);
        sql.add('where');
        if HauptDatensatz then
          sql.add('(MASTER_R=RID)')
        else
          sql.add('(MASTER_R<>RID)');
        APiFirst;
        while not(eof) do
        begin

          //
          try
            qAUFTRAG.insert;
            for n := 0 to pred(FieldCount) do
              if Fields[n].IsNotNull then
                qAUFTRAG.FieldByName(Fields[n].FieldName).Assign(Fields[n])
              else
                qAUFTRAG.FieldByName(Fields[n].FieldName).clear;
            qAUFTRAG.FieldByName('PROTECT_RID').AsInteger := 1;
            qAUFTRAG.post;
            if HauptDatensatz then
              inc(Anz_Inserts);
          except
            inc(ExceptionCount);
          end;

          inc(RecN);
          ApiNext;
          Log(FieldByName('RID').AsString);
          if BreakIt then
            break;
        end;
        close;
      end;
      cAUFTRAG.free;
    end;
  end;

begin
  BeginHourGlass;
  BreakIt := false;
  Label3.caption := 'Vorlauf ...';

  //
  rTRANSACTION := TIB_Transaction.create(self);
  with rTRANSACTION do
  begin
    Isolation := tiCommitted;
    AutoCommit := true;
    ReadOnly := true;
  end;

  //
  rCONNECTION := TIB_Connection.create(self);
  with rCONNECTION do
  begin
    DefaultTransaction := rTRANSACTION;
    LoginDBReadOnly := true;
    Protocol := cpTCP_IP;
    DatabaseName := Edit4.text;
    UserName := 'SYSDBA';
    Password := deCrypt_Hex(iDataBasePassword);
  end;

  with rTRANSACTION do
  begin
    IB_connection := rCONNECTION;
  end;

  rCONNECTION.connect;

  qPERSON := DataModuleDatenbank.nQuery;
  with qPERSON do
  begin
    sql.add('select * from PERSON where RID=:CROSSREF for update');
  end;

  qANSCHRIFT := DataModuleDatenbank.nQuery;
  with qANSCHRIFT do
  begin
    sql.add('select * from ANSCHRIFT where RID=:CROSSREF for update');
  end;

  cMONTEUR := DataModuleDatenbank.nCursor;
  with cMONTEUR do
  begin
    IB_connection := rCONNECTION;
    sql.add('select * from MONTEUR');

    APiFirst;
    while not(eof) do
    begin

      repeat
        if qPERSON.Active then
          qPERSON.close;
        qPERSON.ParamByName('CROSSREF').AsInteger := cMONTEUR.FieldByName('RID').AsInteger;
        qPERSON.open;
        if qPERSON.eof then
          e_w_PersonNeu
        else
          break;
      until false;

      if qANSCHRIFT.Active then
        qANSCHRIFT.close;
      qANSCHRIFT.ParamByName('CROSSREF').AsInteger := qPERSON.FieldByName('PRIV_ANSCHRIFT_R')
        .AsInteger;
      qANSCHRIFT.open;
      if qANSCHRIFT.eof then
        ShowMessage('ANSCHRIFT verloren!');

      qANSCHRIFT.edit;
      qPERSON.edit;
      qANSCHRIFT.FieldByName('name1').Assign(cMONTEUR.FieldByName('NAME1'));
      qPERSON.FieldByName('vorname').AsString :=
        cutblank(nextp(cMONTEUR.FieldByName('NAME1').AsString, ',', 1));
      qPERSON.FieldByName('nachname').AsString :=
        cutblank(nextp(cMONTEUR.FieldByName('NAME1').AsString, ',', 0));
      qPERSON.FieldByName('suchbegriff').Assign(cMONTEUR.FieldByName('KUERZEL'));
      qPERSON.FieldByName('kuerzel').Assign(cMONTEUR.FieldByName('KUERZEL'));
      qPERSON.FieldByName('anrede').Assign(cMONTEUR.FieldByName('ANREDE'));
      qANSCHRIFT.FieldByName('name2').Assign(cMONTEUR.FieldByName('NAME2'));
      qANSCHRIFT.FieldByName('strasse').AsString :=
        cutblank(cMONTEUR.FieldByName('STRASSE').AsString + ' ' + cMONTEUR.FieldByName('HAUSNUMMER')
        .AsString);
      if cMONTEUR.FieldByName('PLZ').IsNotNull then
        qANSCHRIFT.FieldByName('plz').AsInteger :=
          strtointdef(cMONTEUR.FieldByName('PLZ').AsString, 0);
      qANSCHRIFT.FieldByName('ort').Assign(cMONTEUR.FieldByName('ORT'));
      qANSCHRIFT.FieldByName('ortsteil').Assign(cMONTEUR.FieldByName('ORTSTEIL'));
      qPERSON.FieldByName('ansprache').Assign(cMONTEUR.FieldByName('ANSPRACHE'));
      qPERSON.FieldByName('PRIV_TEL').Assign(cMONTEUR.FieldByName('TELEFON'));
      qPERSON.FieldByName('PRIV_FAX').Assign(cMONTEUR.FieldByName('FAX'));
      qPERSON.FieldByName('HANDY').Assign(cMONTEUR.FieldByName('MOBILE'));
      qPERSON.FieldByName('email').Assign(cMONTEUR.FieldByName('EMAIL'));
      qPERSON.FieldByName('bemerkung').Assign(cMONTEUR.FieldByName('BEMERKUNG'));
      qPERSON.FieldByName('monda').Assign(cMONTEUR.FieldByName('MONDA'));

      qANSCHRIFT.post;
      qPERSON.post;
      Log('Monteur ' + FieldByName('RID').AsString);
      if BreakIt then
        break;
      ApiNext;
    end;
  end;
  cMONTEUR.free;

  // jetzt kommen die Auftraggeber, durch eine Fügung des Schicksals
  // haben die immer andere RIDs als die Monteure ...
  cAUFTRAGGEBER := DataModuleDatenbank.nCursor;
  with cAUFTRAGGEBER do
  begin
    IB_connection := rCONNECTION;
    sql.add('select * from AUFTRAGGEBER');

    APiFirst;
    while not(eof) do
    begin

      repeat
        if qPERSON.Active then
          qPERSON.close;
        qPERSON.ParamByName('CROSSREF').AsInteger := cAUFTRAGGEBER.FieldByName('RID').AsInteger;
        qPERSON.open;
        if qPERSON.eof then
          e_w_PersonNeu
        else
          break;
      until false;

      if qANSCHRIFT.Active then
        qANSCHRIFT.close;
      qANSCHRIFT.ParamByName('CROSSREF').AsInteger := qPERSON.FieldByName('PRIV_ANSCHRIFT_R')
        .AsInteger;
      qANSCHRIFT.open;
      if qANSCHRIFT.eof then
        ShowMessage('ANSCHRIFT verloren!');

      qANSCHRIFT.edit;
      qPERSON.edit;
      qANSCHRIFT.FieldByName('name1').Assign(cAUFTRAGGEBER.FieldByName('NAME1'));
      qPERSON.FieldByName('vorname').AsString :=
        cutblank(nextp(cAUFTRAGGEBER.FieldByName('NAME1').AsString, ',', 1));
      qPERSON.FieldByName('nachname').AsString :=
        cutblank(nextp(cAUFTRAGGEBER.FieldByName('NAME1').AsString, ',', 0));
      qPERSON.FieldByName('suchbegriff').Assign(cAUFTRAGGEBER.FieldByName('name1'));
      qPERSON.FieldByName('anrede').Assign(cAUFTRAGGEBER.FieldByName('ANREDE'));
      qANSCHRIFT.FieldByName('name2').Assign(cAUFTRAGGEBER.FieldByName('NAME2'));
      qANSCHRIFT.FieldByName('strasse').AsString :=
        cutblank(cAUFTRAGGEBER.FieldByName('STRASSE').AsString + ' ' +
        cAUFTRAGGEBER.FieldByName('HAUSNUMMER').AsString);
      if cAUFTRAGGEBER.FieldByName('PLZ').IsNotNull then
        qANSCHRIFT.FieldByName('plz').AsInteger :=
          strtointdef(cAUFTRAGGEBER.FieldByName('PLZ').AsString, 0);
      qANSCHRIFT.FieldByName('ort').Assign(cAUFTRAGGEBER.FieldByName('ORT'));
      qANSCHRIFT.FieldByName('ortsteil').Assign(cAUFTRAGGEBER.FieldByName('ORTSTEIL'));
      qPERSON.FieldByName('ansprache').Assign(cAUFTRAGGEBER.FieldByName('ANSPRACHE'));
      qPERSON.FieldByName('PRIV_TEL').Assign(cAUFTRAGGEBER.FieldByName('TELEFON'));
      qPERSON.FieldByName('PRIV_FAX').Assign(cAUFTRAGGEBER.FieldByName('FAX'));
      qPERSON.FieldByName('HANDY').Assign(cAUFTRAGGEBER.FieldByName('MOBILE'));
      qPERSON.FieldByName('email').Assign(cAUFTRAGGEBER.FieldByName('EMAIL'));
      qPERSON.FieldByName('bemerkung').Assign(cAUFTRAGGEBER.FieldByName('BEMERKUNG'));
      qANSCHRIFT.post;
      qPERSON.post;
      Log('Auftraggeber ' + FieldByName('RID').AsString);
      if BreakIt then
        break;
      ApiNext;
    end;
  end;
  cAUFTRAGGEBER.free;

  qPERSON.free;
  qANSCHRIFT.free;

  // jetzt kommen die 1:1 Kopien
  BulkCopy('BAUSTELLE');
  BulkCopy('BEARBEITER');

  qAUFTRAG := DataModuleDatenbank.nQuery;
  Anz_Inserts := 0;
  SourceDestTable := 'AUFTRAG';
  with qAUFTRAG do
  begin
    sql.add('select * from ' + SourceDestTable + ' for insert');
    open;
  end;
  InsertData(true);
  InsertData(false);

  (*
    SourceDestTable := 'ABLAGE';
    with qAUFTRAG do
    begin
    close;
    sql.clear;
    sql.add('select * from ' + SourceDestTable + ' for insert');
    open;
    end;
    InsertData(true);
    InsertData(false);
  *)

  qAUFTRAG.close;
  qAUFTRAG.free;
  Label3.caption := 'Fertig!';
  EndHourGlass;
end;

procedure TFormepIMPORT.Button5Click(Sender: TObject);
begin
  BreakIt := true;
end;

procedure TFormepIMPORT.Button6Click(Sender: TObject);
begin
  FormGeoPostleitzahlen.show;
end;

procedure TFormepIMPORT.Button7Click(Sender: TObject);
begin
  FormGeoLokalisierung.show;
end;

procedure TFormepIMPORT.Button8Click(Sender: TObject);
begin
  FormGeoArbeitsplatz.show;
end;

procedure TFormepIMPORT.Button9Click(Sender: TObject);
var
  sMEDI: TStringList;
  sAA: TStringList;
  sEinheit: TStringList;
  sSortiment: TStringList;
  n: integer;
  AutoMataState: integer;

  // Medikament
  PNR, MEDI, ABGA, ANZ, EINHA, EINH, bem, EKN, ABG: string;
  GRPN, GRP, VART, MWST: string;
  INDEX, VKB3, VKN3, VKN4: string;

  // Person
  VERNR, NAM1, NAM2, str, PORT, TEL1, FAX, VKURZ, TEL2, TELEX: string;
  WasPerson: boolean;

  x: string;

  aaAusgabeart: string;
  aaSortiment: string;

  // Datenbank
  AUSGABEART_R: integer;
  SORTIMENT_R: integer;
  ARTIKEL_R: integer;
  EINHEIT_R: integer;
  PERSON_R: integer;

  // WarteBalken
  StartTime: dword;

const
  CacheMWST: TStringList = nil;

  function MWST_SATZ: String;
  begin
    if not(Assigned(CacheMWST)) then
      CacheMWST := TStringList.create;

    result := CacheMWST.values[MWST];
    if (result = '') then
    begin
      result := e_r_sqls(
       {} 'select distinct NAME from MWST where SATZ=' + MWST);
      if (result = '') then
        raise Exception.create('MwSt-Satz ' + MWST + ' fehlt! Bitte anlegen!');
      CacheMWST.add(MWST + '=' + result);
    end;
  end;

  function CheckCreateAusgabeart: integer; // [AUSGABEART_R]
  begin
    result := e_r_sql('select RID from AUSGABEART where (NAME=' + SQLstring(aaAusgabeart) + ')');
    if (result < cRID_FirstValid) then
    begin
      result := e_w_GEN('GEN_AUSGABEART');
      e_x_sql('insert into AUSGABEART (RID,NAME) values (' + inttostr(result) + ',' +
        SQLstring(aaAusgabeart) + ')');
    end;
  end;

  function CheckCreateSortiment: integer; // [SORTIMENT_R]
  begin
    result := e_r_sql(
     {} 'select RID from sortiment where ' +
     {} ' (BEZEICHNUNG=' + SQLstring(aaSortiment) + ') and ' +
     {} ' (MWST_NAME=' + SQLString(MWST_SATZ) + ')');
    if (result < cRID_FirstValid) then
    begin
      result := e_w_GEN('GLOBAL_GID');
      e_x_sql('insert into SORTIMENT (RID,NAECHSTE_NUMMER,NETTO,MWST_NAME,BEZEICHNUNG) values (' +
        { } inttostr(result) + ',' +
        { } '-1,' +
        { } cC_True_AsString + ',' +
        { } SQLstring(MWST_SATZ) + ',' +
        { } SQLstring(aaSortiment) + ')');
    end;
  end;

  function CheckCreateArtikel: integer; // [ARTIKEL_R]
  begin
    result := e_r_sql('select RID from ARTIKEL where ' + ' (DAUER=' + SQLstring(INDEX) + ')');
    if (result < cRID_FirstValid) then
    begin
      // erste Anlage!!
      result := e_w_ArtikelNeu(SORTIMENT_R);
      e_x_sql('update ARTIKEL set ' +
        { } ' DAUER=' + SQLstring(INDEX) + ',' +
        { } ' SCHWER_GRUPPE=' + SQLstring(VART) + ',' +
        { } ' TITEL=' + SQLstring(MEDI) + ',' +
        { } ' GEWICHT=-1, ' +
        { } ' LETZTEAENDERUNG=CURRENT_TIMESTAMP, ' +
        { } ' VERLAG_R=' + inttostr(PERSON_R) + ' ' +
        { } 'where RID=' + inttostr(result));
    end
    else
    begin
      e_x_sql('update ARTIKEL set ' +
        { } ' SCHWER_GRUPPE=' + SQLstring(VART) + ',' +
        { } ' TITEL=' + SQLstring(MEDI) + ',' +
        { } ' GEWICHT=-1, ' +
        { } ' LETZTEAENDERUNG=CURRENT_TIMESTAMP, ' +
        { } ' VERLAG_R=' + inttostr(PERSON_R) + ' ' +
        { } 'where RID=' + inttostr(result));
    end;
  end;

  procedure CheckCreatePreis;
  var
    ARTIKEL_AA_R: integer;
    PreisKomplett: double;
    PreisProEinheit: double;
  begin
    //
    PreisKomplett := StrToDouble(VKN3);
    if (PreisKomplett = 0.0) then
      PreisKomplett := StrToDouble(EKN);
    PreisProEinheit := StrToDouble(VKN4);

    // Stückpreis eintragen
    ARTIKEL_AA_R := e_r_sql(
      {} 'select RID from ARTIKEL_AA where ' +
      {} ' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') and ' +
      {} ' (AUSGABEART_R=' + inttostr(AUSGABEART_R) + ') and ' +
      {} ' (EINHEIT_R is null)');
    if (ARTIKEL_AA_R < cRID_FirstValid) then
    begin
      ARTIKEL_AA_R := e_w_GEN('GEN_ARTIKEL_AA');
      e_x_sql(
       {} 'insert into ARTIKEL_AA (RID, ARTIKEL_R, AUSGABEART_R, MINDESTBESTAND, GEWICHT, EURO, LETZTEAENDERUNG) ' +
       {} ' values (' +
       {} inttostr(ARTIKEL_AA_R) + ',' +
       {} inttostr(ARTIKEL_R) + ',' +
       {} inttostr(AUSGABEART_R) + ',' +
       {} '-1,' +
       {} '-1,' +
       {} FloatToStrISO(PreisKomplett) + ',' +
       {} 'CURRENT_TIMESTAMP' + ')');
    end
    else
    begin
      e_x_sql(
       {} 'update ARTIKEL_AA set ' +
       {} ' EURO=' + FloatToStrISO(PreisKomplett) + ',' +
       {} ' LETZTEAENDERUNG=CURRENT_TIMESTAMP ' +
       {} 'where RID=' + inttostr(ARTIKEL_AA_R));
    end;

    // Preis pro Einheit eintragen falls interessant
    if (PreisProEinheit > 0.0) and (PreisKomplett <> PreisProEinheit) then
    begin
      ARTIKEL_AA_R := e_r_sql(
       {} 'select RID from ARTIKEL_AA where ' +
       {} ' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') and ' +
       {} ' (AUSGABEART_R=' + inttostr(AUSGABEART_R) + ') and ' +
       {} ' (EINHEIT_R=' + inttostr(EINHEIT_R) + ')');
      if (ARTIKEL_AA_R < cRID_FirstValid) then
      begin
        ARTIKEL_AA_R := e_w_GEN('GEN_ARTIKEL_AA');
        e_x_sql(
        {} 'insert into ARTIKEL_AA (RID, EINHEIT_R, ARTIKEL_R, AUSGABEART_R, MINDESTBESTAND, GEWICHT, EURO, LETZTEAENDERUNG) ' +
        {} ' values (' + inttostr(ARTIKEL_AA_R) + ',' +
        {} inttostr(EINHEIT_R) + ',' +
        {} inttostr(ARTIKEL_R) + ',' +
        {} inttostr(AUSGABEART_R) + ',' +
        {} '-1,' +
        {} '-1,' +
        {} FloatToStrISO(PreisProEinheit) + ',' +
        {} 'CURRENT_TIMESTAMP' + ')');
      end
      else
      begin
        e_x_sql('update ARTIKEL_AA set ' + ' EURO=' + FloatToStrISO(PreisProEinheit) + ',' +
          ' LETZTEAENDERUNG=CURRENT_TIMESTAMP ' + 'where RID=' + inttostr(ARTIKEL_AA_R));
      end;
    end;

  end;

  function CheckCreateEinheit: integer;
  begin
    //
    result := e_r_sql(
     {} 'select RID from EINHEIT ' +
     {} 'where (EINHEIT=1) and (BASIS=' + SQLstring(ABG) + ')');
    if (result < cRID_FirstValid) then
    begin
      result := e_w_GEN('GEN_EINHEIT');
      e_x_sql('insert into EINHEIT (RID,EINHEIT,BASIS) values ' +
      {} '(' + inttostr(result) + ',' +
      {} '1,' +
      {} SQLstring(ABG) + ')');
    end;
  end;

  function CheckCreatePerson: integer;
  var
    ANSCHRIFT_R: integer;
  begin
    if (VKURZ = '') then
      VKURZ := VERNR;

    result := e_r_sql(
      { } 'select RID from PERSON where ' +
      { } ' (SUCHBEGRIFF=''' + EnsureSQL(VKURZ) + ' Barsoi'')');
    if (result < cRID_FirstValid) then
      result := e_w_PersonNeu;

    ANSCHRIFT_R := e_r_sql('select PRIV_ANSCHRIFT_R from PERSON where RID=' + inttostr(result));

    e_x_sql('update PERSON set ' +
      { } ' SUCHBEGRIFF=''' + EnsureSQL(copy(VKURZ, 1, 45)) + ' Barsoi'', ' +
      { } ' NACHNAME=null, ' +
      { } ' GESCH_TEL=' + SQLstring(copy(TEL1, 1, 25)) + ',' +
      { } ' EMAIL=' + SQLstring(copy(TEL2, 1, 120)) + ',' +
      { } ' WEBSITE=' + SQLstring(copy(TELEX, 1, 120)) + ',' +
      { } ' GESCH_FAX=' + SQLstring(copy(FAX, 1, 25)) + ',' +
      { } ' HAUPT_NUMMER=' + SQLstring(VERNR) + '' +
      { } ' where RID=' + inttostr(result));

    e_x_sql('update ANSCHRIFT set ' +
      { } ' NAME1=' + SQLstring(copy(NAM1, 1, 45)) + ',' +
      { } ' NAME2=' + SQLstring(copy(NAM2, 1, 45)) + ',' +
      { } ' STRASSE=' + SQLstring(copy(str, 1, 45)) + ',' +
      { } ' PLZ=' + inttostr(strtointdef(nextp(PORT, ' ', 0), 0)) + ',' +
      { } ' ORT=' + SQLstring(copy(nextp(PORT, ' ', 1), 1, 45)) + ' ' +
      { } ' where RID=' + inttostr(ANSCHRIFT_R));
  end;

  procedure parse(const s: string);

  // 0->1 Ausgabearten {PNR=..}MEDI=

  var
    sName: string;
    sValue: string;

    function CheckSet(const Token: string; var s: string): boolean;
    begin
      result := (sName = Token);
      if result then
        s := sValue;
    end;

    function decode(s: string): string;
    begin
      result := OEM2Ansi(cutblank(s));
      ersetze('Ó', 'ß', result);
      ersetze(#26, '', result);
    end;

  begin
    sName := nextp(s, '=', 0);
    sValue := decode(nextp(s, '=', 1));
    repeat
      case AutoMataState of
        0: // Kopf-Mode
          begin

            if CheckSet('VERNR', VERNR) then
            begin
              WasPerson := true;
              NAM1 := '';
              NAM2 := '';
              str := '';
              PORT := '';
              TEL1 := '';
              FAX := '';
              TEL2 := '';
              TELEX := '';
              VKURZ := '';

            end;
            CheckSet('NAM1', NAM1);
            CheckSet('NAM2', NAM2);
            CheckSet('STR', str);
            CheckSet('PORT', PORT);
            CheckSet('TEL1', TEL1);
            CheckSet('FAX', FAX);
            CheckSet('TEL2', TEL2);
            CheckSet('TELEX', TELEX);
            CheckSet('VKURZ', VKURZ);

            //

            if CheckSet('MEDI', MEDI) then
            begin
              if WasPerson then
              begin
                PERSON_R := CheckCreatePerson;
                WasPerson := false;
              end;
            end;
            CheckSet('GRPN', GRPN);
            CheckSet('GRP', GRP); // Sortiment
            CheckSet('VART', VART); // Verordnungsart F,A,Rp -> "SCHWER_GRUPPE"
            CheckSet('INDEX', INDEX);
            // eindeutiges Merkmal für Update -> "DAUER"
            CheckSet('MWST', MWST);

            if CheckSet('SORT', x) then
            begin
              sSortiment.add(GRPN + ' ' + GRP + ' ' + MWST);
              aaSortiment := GRPN + ' ' + GRP;
              SORTIMENT_R := CheckCreateSortiment;
              ARTIKEL_R := CheckCreateArtikel;
            end;

            if CheckSet('PNR', PNR) then
            begin
              aaAusgabeart := '';
              AutoMataState := 1;
              break;
            end;

          end;
        1: // Preis Mode
          begin

            if CheckSet('ANZ', ANZ) then
            begin
              ersetze('.00', '', ANZ);
              ersetze('.', ',', ANZ);
              aaAusgabeart := cutblank(aaAusgabeart + ' ' + ANZ);
            end;

            if CheckSet('EINH', EINH) then
            begin
              aaAusgabeart := cutblank(aaAusgabeart + ' ' + EINH);
            end;

            if CheckSet('BEM', bem) then
            begin
              aaAusgabeart := cutblank(aaAusgabeart + ' [' + bem + ']');
            end;

            //
            CheckSet('EKN', EKN);
            CheckSet('VKN3', VKN3);
            CheckSet('VKN4', VKN4);

            //
            if CheckSet('ABG', ABG) then
            begin
              // Einheit eintragen
              EINHEIT_R := CheckCreateEinheit;
              sEinheit.add(ABG);

              // Ausgabeart eintragen
              AUSGABEART_R := CheckCreateAusgabeart;
              sAA.add(aaAusgabeart);

              // Preis (ARTIKEL_AA) eintragen
              CheckCreatePreis;
              aaAusgabeart := '';
            end;

            if CheckSet('VERNR', VERNR) then
            begin
              AutoMataState := 0;
              break;
            end;
            if CheckSet('MEDI', MEDI) then
            begin
              AutoMataState := 0;
              break;
            end;

          end;
      end;
    until true;
  end;

begin
  BeginHourGlass;
  StartTime := 0;
  sMEDI := TStringList.create;
  sAA := TStringList.create;
  sEinheit := TStringList.create;
  sSortiment := TStringList.create;
  sMEDI.loadfromfile(MyProgramPath + Edit7.text);
  AutoMataState := 0;
  ProgressBar1.max := sMEDI.count;
  for n := 0 to pred(sMEDI.count) do
  begin
    parse(sMEDI[n]);
    if frequently(StartTime, 333) then
    begin
      application.processmessages;
      if CheckBox7.Checked then
        break;
      ProgressBar1.position := n;
      StaticText1.caption := inttostr(n);
    end;
  end;

  sAA.sort;
  removeduplicates(sAA);
  sAA.SaveToFile(DiagnosePath + 'Medi-Ausgabearten.txt');
  sEinheit.sort;
  removeduplicates(sEinheit);
  sEinheit.SaveToFile(DiagnosePath + 'Medi-Einheiten.txt');
  sSortiment.sort;
  removeduplicates(sSortiment);
  sSortiment.SaveToFile(DiagnosePath + 'Medi-Sortimente.txt');

  sMEDI.free;
  sAA.free;
  sEinheit.free;
  sSortiment.free;

  ProgressBar1.position := 0;
  StaticText1.caption := inttostr(0);
  EndHourGlass;
end;

procedure TFormepIMPORT.doAnfiEuroPersonen;
type
  Tadresse = packed record
    ind: string[10]; { ersten 5 Buchstaben nam }
    { ersten 3 Buchstaben str }
    { letzen 2 Ziffern von str }
    { Beispiel : FILSIAM 01 }
    { Beispiel : HAAS HER22 }
    anr: string[1]; { Anrede }
    nam: string[30]; { Name des Kunden }
    str: string[25]; { Straáe }
    ort: string[25]; { Wohnort }
    tel: string[25]; { Telefon }
    ber: string[15]; { Beruf }
    geb: TANFiXDate; { Geburtsdatum }
    bes: TANFiXDate; { Datum des Letzen Besuches }
    zah: string[30]; { Zahlungsfeld }
    off: string[10]; { Offene Posten }
    bem: string[50]; { Bemerkungen }
    kon: longint; { Kodierte Kontonummer }
  end;

var
  ImpF: TStringList;
  Kunrec: Tadresse;
  MaxKonNum: integer;
  n: integer;
  CrossReference: integer;
  OneLIne: string;
  Bemerkungen: TStringList;
  StartTime: dword;

  function extract_plz(fullS: string): integer;
  var
    k: integer;
  begin
    k := pos('-', fullS);
    if (k > 0) and (k < 4) then
      fullS := nextp(fullS, '-');
    result := strtointdef(nextp(fullS, ' '), 0);
  end;

  function extract_land(fullS: string): string;
  var
    k: integer;
  begin
    k := pos('-', fullS);
    if (k > 0) and (k < 4) then
      result := nextp(fullS, '-') + '-'
    else
      result := 'D-';
  end;

  function extract_ort(fullS: string): string;
  begin
    nextp(fullS, ' ');
    result := fullS;
  end;

  function _anrede: string;
  begin
    result := '';
    if length(Kunrec.anr) > 0 then
      case Kunrec.anr[1] of
        '1':
          result := 'Herrn';
        '2':
          result := 'Frau';
        '3':
          result := 'Firma';
        '4':
          result := 'Familie';
        '5':
          result := 'Landwirt';
        '6':
          result := 'Tierheim';
      end;
  end;

  function _ansprache: string;

    function NamenTitel: string;
    var
      h2, vk, nk: string[35];
      kpos: byte;
    begin
      h2 := Kunrec.nam;
      kpos := pos(',', h2);
      if kpos = 0 then
        result := h2;

      vk := cutblank(copy(h2, 1, kpos - 1));
      nk := cutblank(copy(h2, kpos + 1, 100));

      result := '';

      if pos(' ', nk) <> 0 then
      begin
        if (nk[pos(' ', nk) - 1] = '.') then { Titel }
        begin
          result := copy(nk, 1, pos(' ', nk));
          delete(nk, 1, pos(' ', nk));
        end;
      end;

      if pos(' ', nk) <> 0 then
      begin
        result := result + copy(nk, pos(' ', nk) + 1, 100) + ' ';
      end;

      result := result + vk;
    end;

  begin
    result := '';
    if length(Kunrec.anr) > 0 then
      case Kunrec.anr[1] of
        '1':
          result := 'Sehr geehrter Herr ' + NamenTitel;
        '2':
          result := 'Sehr geehrte Frau ' + NamenTitel;
        '3':
          result := 'Sehr geehrte Damen und Herren';
        '4':
          result := 'Liebe Familie ' + NamenTitel;
        '5':
          result := 'Sehr geehrter Herr ' + NamenTitel;
        '6':
          result := 'Liebes Tierheim ' + NamenTitel;
      end;
  end;

  function _vorname(s: string): string;
  var
    k: integer;
  begin
    k := pos(',', s);
    if (k = 0) then
      result := s
    else
      result := cutblank(copy(s, succ(k), MaxInt));
  end;

  function _nachname(s: string): string;
  var
    k: integer;
  begin
    k := pos(',', s);
    if k = 0 then
      result := ''
    else
      result := cutblank(copy(s, 1, pred(k)));
  end;

begin

  // Patientenbesitzer
  Bemerkungen := TStringList.create;
  ImpF := TStringList.create;
  ImpF.loadfromfile(Edit1.text + 'KREO.TXT');
  MaxKonNum := -1;
  IB_QueryANSCHRIFT.open;
  IB_QueryPERSON.open;
  StartTime := 0;

  //
  ProgressBar1.max := ImpF.count;
  for n := 0 to pred(ImpF.count) do
  begin

    OneLIne := ImpF[n];
    with Kunrec do
    begin
      ind := nextp(OneLIne, cDelimiter);
      anr := nextp(OneLIne, cDelimiter);
      nam := OEM2Ansi(nextp(OneLIne, cDelimiter));
      str := OEM2Ansi(nextp(OneLIne, cDelimiter));
      ort := OEM2Ansi(nextp(OneLIne, cDelimiter));
      tel := OEM2Ansi(nextp(OneLIne, cDelimiter));
      ber := OEM2Ansi(nextp(OneLIne, cDelimiter));
      geb := date2long(nextp(OneLIne, cDelimiter));
      bes := date2long(nextp(OneLIne, cDelimiter));
      zah := OEM2Ansi(nextp(OneLIne, cDelimiter));
      off := OEM2Ansi(nextp(OneLIne, cDelimiter));
      bem := OEM2Ansi(nextp(OneLIne, cDelimiter));
      kon := strtointdef(nextp(OneLIne, cDelimiter), 0);
      MaxKonNum := max(MaxKonNum, kon);
    end;

    with IB_QueryPERSON do
    begin

      if locate('NUMMER', Kunrec.kon, []) then
        continue;

      CrossReference := GEN_ID('GLOBAL_GID', 0) + 1;
      with IB_QueryANSCHRIFT do
      begin
        insert;
        FieldByName('RID').AsInteger := 0;
        FieldByName('STRASSE').AsString := Kunrec.str;
        FieldByName('PLZ').AsInteger := extract_plz(Kunrec.ort);
        FieldByName('STATE').AsString := extract_land(Kunrec.ort);
        FieldByName('ORT').AsString := extract_ort(Kunrec.ort);
        post;
      end;

      insert;
      FieldByName('NUMMER').AsInteger := Kunrec.kon;
      FieldByName('PRIV_ANSCHRIFT_R').AsInteger := CrossReference;
      FieldByName('RID').AsInteger := 0;
      FieldByName('EINTRAG').AsDateTime := now;

      FieldByName('VORNAME').AsString := _vorname(Kunrec.nam);
      FieldByName('NACHNAME').AsString := _nachname(Kunrec.nam);
      FieldByName('INT_ANREDE_R').AsInteger := strtointdef(Kunrec.anr, 0);

      if DateExact(Kunrec.bes) then
        FieldByName('KONTAKTAM').AsDate := long2datetime(Kunrec.bes);
      FieldByName('SUCHBEGRIFF').AsString := Kunrec.ind;
      FieldByName('PRIV_TEL').AsString := Kunrec.tel;

      if DateExact(Kunrec.geb) then
        FieldByName('GEBURTSTAG').AsDate := long2datetime(Kunrec.geb);
      FieldByName('BERUF').AsString := Kunrec.ber;
      Bemerkungen.clear;
      Bemerkungen.add('Zahlungsbemerkung=' + Kunrec.zah);
      Bemerkungen.add('OffenePosten=' + Kunrec.off);
      Bemerkungen.add('Bermerkung=' + Kunrec.bem);
      Bemerkungen.add('ANREDE=' + _anrede);
      Bemerkungen.add('ANSPRACHE=' + _ansprache);
      FieldByName('BEMERKUNG').Assign(Bemerkungen);
      post;
    end;

    // SetGen/ 'NK_KUNDE' := MaxKonNum;
    if frequently(StartTime, 500) or (n = pred(ImpF.count)) then
    begin
      application.processmessages;
      ProgressBar1.position := n;
    end;

    if BreakIt then
      break;

  end;
  IB_QueryANSCHRIFT.close;
  IB_QueryPERSON.close;
  ImpF.free;
  Bemerkungen.free;
  ProgressBar1.position := 0;
  EndHourGlass;
end;

procedure TFormepIMPORT.e_w_RechnungDatumSetzen(ib_q: TIB_Query; Aufdatum: TDateTime);
var
  _NewDate: TANFiXDate;
  BELEG_R: integer;
begin
  BELEG_R := -1;
  with ib_q do
  begin
    BELEG_R := FieldByName('RID').AsInteger;
    edit;
    FieldByName('RECHNUNG').AsDateTime := Aufdatum;
    _NewDate := datetime2long(Aufdatum);
    FieldByName('FAELLIG').AsDateTime :=
      long2datetime(DatePlus(_NewDate, cStandard_ZahlungFrist));
    post;
  end;
end;

procedure TFormepIMPORT.e_w_RechnungDatumSetzen(ib_q: TIB_Query; Aufdatum: TANFiXDate);
begin
  e_w_RechnungDatumSetzen(ib_q, long2datetime(Aufdatum));
end;

procedure TFormepIMPORT.doAnfiEuroRechnungen;
var

  //
  SubDir: Char;
  AllTheRechnungen: TStringList;
  CursorPERSON: TIB_Cursor;

  PERSON_R: integer;
  BELEG_R: integer;
  BELEG_R_MAX: integer;

  // Rechnungstitel
  rbNummer: integer;
  rbDatumAnlage: TANFiXDate;
  rbDatumRechnung: TANFiXDate;
  rbDatumM1: TANFiXDate;
  rbDatumM2: TANFiXDate;

  rbBetrag: double;
  rbAnzahlung: double;

  // Rechnungspositionen
  rpDatum: TANFiXDate;
  rpMenge: integer;
  rpBezeichnung: string;
  rpMwSt: double;
  rpPreis: double;
  rpEURO: double;
  mwst_klasse: array [0 .. 3] of double;

  //
  n, m: integer;
  drv_txt: TStringList;
  drv_poi: integer;
  StartTime: dword;

  Anzahlung: TStringList;

  procedure sql(s: string);
  var
    IB_Script: TIB_DSQL;
  begin
    IB_Script := DataModuleDatenbank.nDSQL;
    with IB_Script do
    begin
      sql.add(s);
      execute;
    end;
    IB_Script.free;
  end;

begin
  // init
  ListBox1.items.clear;
  drv_txt := TStringList.create;
  AllTheRechnungen := TStringList.create;
  Anzahlung := TStringList.create;
  BELEG_R_MAX := 0;

  sql('delete from warenbewegung');
  sql('delete from versand');
  sql('delete from BUCH');
  sql('delete from posten');
  sql('delete from beleg');

  // suche Rechnungen ...
  for SubDir := 'A' to 'E' do
  begin
    dir(Edit1.text + SubDir + 'DIR\*.*', AllTheRechnungen);
    for n := 0 to pred(AllTheRechnungen.count) do
      AllTheRechnungen[n] := AllTheRechnungen[n] + ',' + SubDir + 'DIR';
    ListBox1.items.addstrings(AllTheRechnungen);
  end;
  AllTheRechnungen.Assign(ListBox1.items);

  CursorPERSON := DataModuleDatenbank.nCursor;
  with CursorPERSON do
  begin
    sql.add('select RID from Person where nummer=:CROSSREF');
  end;

  // verarbeite Rechnungen
  ProgressBar1.max := AllTheRechnungen.count;
  ListBox1.clear;
  StartTime := 0;
  PERSON_R := cRID_NULL;
  for n := 0 to pred(AllTheRechnungen.count) do
  begin
    //
    ListBox1.items.add(AllTheRechnungen[n]);

    // PERSON_R ermitteln
    with CursorPERSON do
    begin
      CursorPERSON.ParamByName('CROSSREF').AsInteger :=
        strtoint(nextp(AllTheRechnungen[n], '.', 0));
      open;
      APiFirst;
      if eof then
        continue;
      PERSON_R := FieldByName('RID').AsInteger;
      close;
    end;
    ListBox1.items.add('RID:' + inttostr(PERSON_R));

    rbBetrag := 0.0;
    rbAnzahlung := 0.0;

    // Rechnung laden
    drv_txt.loadfromfile(Edit1.text + nextp(AllTheRechnungen[n], ',', 1) + '\' +
      nextp(AllTheRechnungen[n], ',', 0));

    // Länge runterkürzen
    for m := pred(drv_txt.count) downto 0 do
      if copy(drv_txt[m], 11, 35) = fill(' ', 35) then
        drv_txt.delete(m);

    { Initialisieren der Eingabe Variable }
    rbDatumAnlage := date2long(copy(drv_txt[0], 1, 8));
    rbDatumRechnung := date2long(copy(drv_txt[0], 9, 8));
    rbDatumM1 := date2long(copy(drv_txt[0], 17, 8));
    rbDatumM2 := date2long(copy(drv_txt[0], 25, 8));
    rbNummer := strtoint(drv_txt[1]);

    BELEG_R_MAX := max(BELEG_R_MAX, rbNummer);

    with IB_QueryBELEG do
    begin
      insert;
      FieldByName('PERSON_R').AsInteger := PERSON_R;
      FieldByName('RID').AsInteger := rbNummer;
      FieldByName('MEDIUM').AsString := 'EP';
      FieldByName('MOTIVATION').AsString := 'Originalsumme ' + drv_txt[2];
      if DateOK(rbDatumM1) then
        FieldByName('MAHNUNG1').AsDate := long2datetime(rbDatumM1);
      if DateOK(rbDatumM2) then
        FieldByName('MAHNUNG2').AsDate := long2datetime(rbDatumM2);

      post;
    end;

    for drv_poi := 3 to pred(drv_txt.count) do
    begin

      // Daten umsetzen
      rpDatum := date2long(copy(drv_txt[drv_poi], 1, 8));

      rpMenge := strtointdef(cutblank(copy(drv_txt[drv_poi], 9, 2)), 0);
      rpBezeichnung := OEM2Ansi(cutrblank(copy(drv_txt[drv_poi], 11, 35)));
      rpMwSt := mwst_klasse[strtoint(drv_txt[drv_poi][46])];
      rpPreis := StrToDouble(copy(drv_txt[drv_poi], 47, 7));
      rpEURO := round(cbrutto(rpPreis, 100 + rpMwSt) * 100.0) / 100.0;

      if copy(drv_txt[drv_poi], 11, 2) <> '*a' then
      begin

        rbBetrag := rbBetrag + rpMenge * rpEURO;

        with IB_QueryPOSTEN do
        begin
          insert;
          FieldByName('BELEG_R').AsInteger := rbNummer;
          if DateOK(rpDatum) then
            FieldByName('AUSFUEHRUNG').AsDateTime := long2datetime(rpDatum);
          FieldByName('MENGE').AsInteger := rpMenge;
          if DateOK(rbDatumRechnung) then
            FieldByName('MENGE_GELIEFERT').AsInteger := rpMenge
          else
            FieldByName('MENGE_RECHNUNG').AsInteger := rpMenge;

          FieldByName('MWST').AsDouble := rpMwSt;
          FieldByName('PREIS').AsDouble := rpEURO;
          FieldByName('ARTIKEL').AsString := rpBezeichnung;
          post;
        end;

      end
      else
      begin

        // Anzahlung buchen!
        rbAnzahlung := rbAnzahlung + rpPreis;

        Anzahlung.clear;
        Anzahlung.add(drv_txt[drv_poi]);
        ListBox1.items.add(drv_txt[drv_poi]);

        with IB_QueryFORDERUNG do
        begin
          insert;
          FieldByName('NAME').AsString := cKonto_Forderungen;
          FieldByName('BELEG_R').AsInteger := rbNummer;
          FieldByName('PERSON_R').AsInteger := PERSON_R;
          FieldByName('BETRAG').AsDouble := -rpPreis;
          FieldByName('TEXT').Assign(Anzahlung);
          post;
        end;
      end;
    end;

    with IB_QueryPOSTEN do
    begin
      close;
      ParamByName('CROSSREF').AsInteger := rbNummer;
      open;
    end;

    with IB_QueryBELEG do
    begin
      ParamByName('CROSSREF').AsInteger := rbNummer;
      if not(Active) then
        open;

      if DateOK(rbDatumRechnung) then
      begin
        e_w_RechnungDatumSetzen(IB_QueryBELEG, rbDatumRechnung);
      end;

      edit;
      if DateOK(rbDatumAnlage) then
        FieldByName('ANLAGE').AsDate := long2datetime(rbDatumAnlage);
      FieldByName('RECHNUNGS_BETRAG').AsDouble := rbBetrag;
      if (rbAnzahlung <> 0) then
        FieldByName('DAVON_BEZAHLT').AsDouble := rbAnzahlung;
      FieldByName('BTYP').AsString := 'p';
      FieldByName('EINZELPREIS_NETTO').AsString := 'Y';
      post;

    end;

    with IB_QueryFORDERUNG do
    begin
      insert;
      FieldByName('NAME').AsString := cKonto_Forderungen;
      if IB_QueryBELEG.FieldByName('FAELLIG').IsNotNull then
        FieldByName('WERTSTELLUNG').Assign(IB_QueryBELEG.FieldByName('FAELLIG'));
      FieldByName('BELEG_R').AsInteger := rbNummer;
      FieldByName('PERSON_R').AsInteger := PERSON_R;
      FieldByName('BETRAG').AsDouble := rbBetrag;
      post;
    end;

    e_w_BelegStatusBuchen(rbNummer);

    if frequently(StartTime, 222) then
    begin
      application.processmessages;
      ProgressBar1.position := n;
    end;

  end;
  // sql('SET GENERATOR BELEG_GID TO ' + inttostr(inc_recnum));
  CursorPERSON.close;
  CursorPERSON.free;
  IB_QueryBELEG.close;
  IB_QueryPOSTEN.close;
  IB_QueryFORDERUNG.close;
  AllTheRechnungen.free;
  Anzahlung.free;
  drv_txt.free;
  ProgressBar1.position := 0;
end;

end.
