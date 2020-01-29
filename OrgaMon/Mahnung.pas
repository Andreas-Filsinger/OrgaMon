{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2020  Andreas Filsinger
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
unit Mahnung;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  ComCtrls, IB_Components, IB_Access,
  CheckLst, globals, ExtCtrls,
  IB_UpdateBar, Grids, IB_Grid,
  gplists, Vcl.Buttons;

type
  TFormMahnung = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label8: TLabel;
    Button8: TButton;
    Button9: TButton;
    Button20: TButton;
    Button3: TButton;
    Button5: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Label3: TLabel;
    IB_Grid1: TIB_Grid;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_QueryMahnlauf: TIB_Query;
    IB_DataSourceMahnlauf: TIB_DataSource;
    Button11: TButton;
    Image2: TImage;
    Image1: TImage;
    Image3: TImage;
    TabSheet3: TTabSheet;
    Label5: TLabel;
    IB_UpdateBar2: TIB_UpdateBar;
    IB_Grid2: TIB_Grid;
    IB_DataSourceAusgesetzteBelege: TIB_DataSource;
    IB_QueryAusgesetzteBelege: TIB_Query;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button18: TButton;
    TabSheet4: TTabSheet;
    Label7: TLabel;
    Label11: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    StaticText1: TStaticText;
    Button15: TButton;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText9: TStaticText;
    Panel1: TPanel;
    Panel2: TPanel;
    StaticText8: TStaticText;
    StaticText10: TStaticText;
    StaticText11: TStaticText;
    StaticText12: TStaticText;
    StaticText13: TStaticText;
    StaticText14: TStaticText;
    StaticText15: TStaticText;
    StaticText16: TStaticText;
    StaticText17: TStaticText;
    Panel3: TPanel;
    ListBox2: TListBox;
    Edit4: TEdit;
    Label36: TLabel;
    Label37: TLabel;
    CheckBox7: TCheckBox;
    Label4: TLabel;
    ProgressBar1: TProgressBar;
    Button16: TButton;
    Label12: TLabel;
    ListBox1: TListBox;
    Button4: TButton;
    Button6: TButton;
    Button7: TButton;
    Button1: TButton;
    SpeedButton24: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure CheckListBox1DblClick(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure IB_Grid2GetDisplayText(Sender: TObject; ACol, ARow: Integer; var AString: String);
    procedure Button18Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton24Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private-Deklarationen }
    BlackList: TgpIntegerList; // Liste der Personen, die NICHT gemahnt werden
    // sollen (via System-OLAP) oder können (Fehler)
    SilentMode: boolean;

    procedure ClearCustomers;
    function AddCustomerByRID(PERSON_R: Integer): boolean;
    function MarkedPERSON_R: Integer;
    function MarkedPERSON_R2: Integer;
    procedure ShowSaldo(st: TStaticText; summe: double; InversColor: boolean = false);

    procedure StartWait(titel: string; MaxCount: Integer);
    procedure EndWait;
    procedure EnsureMahnungUpdate;
    procedure EnsureOnline;
    procedure RefreshAussenstaende;
  public
    { Public-Deklarationen }
    function ErzeugeMahnliste(Silent: boolean; KundeInformiert: boolean = false): double;
    function ErzeugeKundenListe: Integer; // [[AnzahlDerFehler]]
    procedure ErzeugeAusschluss;
    function Execute(TAN: Integer = 0): boolean;
  end;

var
  FormMahnung: TFormMahnung;

implementation

uses
  html, anfix32, math,
  systemd, Geld, wanfix32,

  // OrgaMon
  Funktionen_OLAP,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  Person, Belege, AusgangsRechnungen,
  InternationaleTexte,
  CareTakerClient, Einstellungen,
  DruckSpooler,
  Datenbank, dbOrgaMon;

{$R *.DFM}

procedure TFormMahnung.ShowSaldo(st: TStaticText; summe: double; InversColor: boolean = false);
begin
  with st do
  begin
    caption := format('%m', [abs(summe)]);
    if InversColor then
      summe := -summe;
    if (summe > cGeld_KleinsterBetrag) then
      Color := clred
    else
      Color := cllime;
  end;
end;


procedure TFormMahnung.SpeedButton24Click(Sender: TObject);
var
 MahnungFName : String;
 DocFName: String;
 PERSON_R,BELEG_R,TEILLIEFERUNG : Integer;
 M : TStringList;
 n : Integer;
   bigDocument: THTMLTemplate;
begin
  PERSON_R := MarkedPERSON_R;
  M := TStringList.create;
  bigDocument:= THTMLTemplate.create;


  // Mahnung.combined erzeugen
  MahnungFName := e_r_MahnungFName(PERSON_R);
  if FileExists(MahnungFname) then
  begin
   M.LoadFromFile(MahnungFName);
   bigDocument.LoadFromFile(MahnungFName);

   for n := 0 to pred(M.count) do
   begin
     if pos('BelegNo=',M[n])=1 then
     begin
       BELEG_R := StrToIntDef(ExtractSegmentBetween(M[n],'=','-'),cRID_unset);
       TEILLIEFERUNG := StrToIntDef(nextp(M[n],'-',1),0);

       repeat
         DocFName := e_r_BelegFNameCombined(
         { } PERSON_R,
         { } BELEG_R,
         { } TEILLIEFERUNG);
         if FileExists(DocFName) then
          break;

         DocFName := e_r_BelegFName(
         { } PERSON_R,
         { } BELEG_R,
         { } TEILLIEFERUNG);
         if FileExists(DocFName) then
          break;

          continue;
       until yet;
       bigDocument.InsertDocument(DocFName);
     end;
   end;

   bigDocument.SaveToFile(e_r_MahnungFNameCombined(PERSON_R));
  end;
  bigDocument.free;
  M.free;
end;

procedure TFormMahnung.SpeedButton2Click(Sender: TObject);
var
 EREIGNIS_R: Integer;
 PERSON_R: Integer;
 MAHNUNG_R: Integer;
 ErrorMsg : String;
 FName_pdf: string;
 VORLAGE_R: Integer;
begin

  ErrorMsg := '';
  repeat

    //
    PERSON_R := MarkedPERSON_R;
    MAHNUNG_R:= IB_QueryMahnlauf.FieldByName('RID').AsInteger;
    if (MAHNUNG_R<cRID_FirstValid) then
    begin
      ErrorMsg := 'RID der Mahnung nicht ermittelbar';
      break;
    end;

    FName_pdf := e_r_MahnungFNameCombined(PERSON_R);
    ersetze('.html','.pdf', FName_pdf);

    if not(FileExists(FName_pdf)) then
    begin
     FName_pdf := e_r_MahnungFName(PERSON_R);
     ersetze('.html','.pdf', FName_pdf);
    end;

    if not(FileExists(FName_pdf)) then
    begin
      ErrorMsg := 'Keine Mahnung als PDF vorhanden';
      break;
    end;

    if FileDate(FName_pdf)<>dateGet then
    begin
      ErrorMsg := 'Die Mahnung ist nicht von heute';
      break;
    end;


    // Ereignis sicherstellen
    EREIGNIS_R := e_r_sql(
        { } 'select RID from' +
        { } ' EREIGNIS where' +
        { } ' (ART=' + inttostr(eT_MahnungPerEMail) + ') and ' +
        { } ' (PERSON_R=' + inttostr(PERSON_R) + ') and ' +
        { } ' (TEILLIEFERUNG=' + inttostr(MAHNUNG_R) + ')');

    if (EREIGNIS_R < cRID_FirstValid) then
    begin
      // Ereignis anlegen
      EREIGNIS_R := e_w_GEN('EREIGNIS_GID');
      e_x_sql('insert into EREIGNIS (RID,ART,BEARBEITER_R,PERSON_R,TEILLIEFERUNG) values (' +
        { } inttostr(EREIGNIS_R) + ',' +
        { } inttostr(eT_MahnungPerEMail) + ',' +
        { } inttostr(sBearbeiter) + ',' +
        { } inttostr(PERSON_R) + ',' +
        { } inttostr(MAHNUNG_R) + ')');
    end;

    // Ensure eMail Entry
    VORLAGE_R := e_r_VorlageMail(cMailvorlage_Mahnung);
    if (VORLAGE_R < cRID_FirstValid) then
    begin
      ErrorMsg := 'eMail-Vorlage "' + cMailvorlage_Mahnung + '" existiert nicht!';
      break;
    end;

    e_x_sql('insert into EMAIL (' +
      { } 'RID,PERSON_R,VORLAGE_R,EREIGNIS_R,DATEI_ANLAGE) values (' +
      { } '0' + ',' +
      { } inttostr(PERSON_R) + ',' +
      { } inttostr(VORLAGE_R) + ',' +
      { } inttostr(EREIGNIS_R) + ',' +
      { } '''' + FName_pdf + '''' + ')');
  until yet;

  if (ErrorMsg<>'') then
   ShowMessageTimeout(ErrorMsg);
end;

procedure TFormMahnung.SpeedButton1Click(Sender: TObject);
var
 PERSON_R: Integer;
 MahnungFName : String;
 ErrorMsg: string;
 PDF: TStringList;
 FName_pdf: string;
begin
  PERSON_R := MarkedPERSON_R;
  MahnungFName := '';
  ErrorMsg := '';

  repeat

   MahnungFName := e_r_MahnungFNameCombined(PERSON_R);
   if FileExists(MahnungFName) then
    break;

   MahnungFName := e_r_MahnungFName(PERSON_R);
   if FileExists(MahnungFName) then
    break;

  until yet;

  repeat

    if (MahnungFName='') then
    begin
      ErrorMsg := 'Keine Mahnung vorhanden!';
      break;
    end;


    PDF := html2pdf(MahnungFName);
    ErrorMsg := PDF.values['ERROR'];
    if (ErrorMsg<>'') then
     break;
    FName_pdf := PDF.Values['ConversionOutFName'];

    if not(FileExists(FName_pdf)) then
    begin
      ErrorMsg := 'die PDF-Erstellung ist nicht erfolgt';
      break;
    end;
  until yet;

  if (ErrorMsg<>'') then
   ShowMessageTimeout(ErrorMsg)
  else
   openShell(FName_pdf);

end;

procedure TFormMahnung.Button4Click(Sender: TObject);
begin
  FormPerson.SetContext(MarkedPERSON_R2);
end;

procedure TFormMahnung.Button2Click(Sender: TObject);
begin
  ClearCustomers;
  if (ErzeugeKundenListe <> 0) then
    ShowMessage('Es wurden problematische Mahneinträge entdeckt!' + #13 +
      'Bitte bearbeiten Sie die Einträge mit vorangestelltem !Ausrufezeichen.');
  if CheckBox7.checked then
    ErzeugeMahnliste(false);
  PageControl1.activepage := TabSheet2;
end;

procedure TFormMahnung.Button8Click(Sender: TObject);
begin
  FormPerson.SetContext(MarkedPERSON_R);
end;

procedure TFormMahnung.Button9Click(Sender: TObject);
begin
  FormAusgangsRechnungen.SetContext(MarkedPERSON_R);
end;

function TFormMahnung.AddCustomerByRID(PERSON_R: Integer): boolean;
begin
  result := false;
  if (PERSON_R >= cRID_FirstValid) then
  begin
    result := (e_r_sql('select count(rid) from MAHNLAUF where PERSON_R=' + inttostr(PERSON_R)) = 0);
    if result then
      e_x_sql('insert into MAHNLAUF (RID,PERSON_R) values (0,' + inttostr(PERSON_R) + ')');
  end;
end;

procedure TFormMahnung.ClearCustomers;
begin
  if not(e_w_NeuerMahnlauf) then
    if doit('In der aktuellen Mahnliste sind noch einzelne Personen angekreuzt!' + #13 +
      'Wollen Sie wirklich eine neue Liste erstellen lassen') then
      e_w_NeuerMahnlauf(true);

end;

function TFormMahnung.ErzeugeMahnliste(Silent: boolean; KundeInformiert: boolean = false): double;
var
  RecN: Integer;
  _Global_Offen: double;
  _Global_Verzug: double;
  PERSON_R: Integer;
  Bericht: TStringList;
  sKontoOptionen: TStringList;
  mQ: TIB_Query;
  sNullMahnungen: TgpIntegerList;
  VERZUG: double;
  n: Integer;
  Mahnschwelle: double;
begin
  BeginHourGlass;

  //
  Mahnschwelle := strtodoubledef(Edit3.text, iMahnSchwelle);
  sNullMahnungen := TgpIntegerList.create;

  // vom Mahnen ausgeschlossene Beleg
  ErzeugeAusschluss;

  //
  EnsureMahnungUpdate;

  //
  mQ := DataModuleDatenbank.nQuery;
  with mQ do
  begin
    sql.add('select * from MAHNLAUF for update');
    Open;

    if KundeInformiert then
    begin
      StartWait('Mahnungen verbuchen', RecordCount);
    end
    else
    begin
      StartWait('Mahnbelege erstellen', RecordCount);
    end;
    RecN := 0;
    _Global_Offen := 0;
    _Global_Verzug := 0;
    first;
    while not(eof) do
    begin
      PERSON_R := FieldByName('PERSON_R').AsInteger;

      edit;
      Bericht := nil;
      if KundeInformiert then
      begin
        if (FieldByName('BRIEF').AsString = cC_True) or
          (FieldByName('MAHNBESCHEID').AsString = cC_True) then
        begin
          sKontoOptionen := TStringList.create;
          sKontoOptionen.add('verbuchen=' + cIni_Activate);
          sKontoOptionen.add('mahnbescheid=' + bool2cO(FieldByName('MAHNBESCHEID')
            .AsString = cC_True));
          sKontoOptionen.add('moment=' + DatumUhr);
          Bericht := e_w_KontoInfo(PERSON_R, sKontoOptionen);
          sKontoOptionen.free;
        end;
        FieldByName('BRIEF').AsString := cC_False;
      end
      else
      begin
        Bericht := e_w_KontoInfo(PERSON_R);
        FieldByName('BRIEF').AsString := cC_True;
      end;

      if assigned(Bericht) then
      begin
        VERZUG := strtodouble(Bericht.values['VERZUG']);
        _Global_Offen := _Global_Offen + strtodouble(Bericht.values['OFFEN']);
        _Global_Verzug := _Global_Verzug + VERZUG;
        FieldByName('SUCHBEGRIFF').AsString := e_r_Person(PERSON_R);
        FieldByName('OFFEN').AsDouble := strtodouble(Bericht.values['OFFEN']);
        FieldByName('VERZUG').AsDouble := VERZUG;
        FieldByName('SEIT').AsInteger := strtointdef(Bericht.values['SEIT'], 0);
        FieldByName('MAHNSTUFE').AsInteger := strtointdef(Bericht.values['MAHNSTUFE'], 0);
        FreeAndNil(Bericht);

        // ausblenden
        if (VERZUG < Mahnschwelle) then
          sNullMahnungen.add(FieldByName('RID').AsInteger);

        // dokumentieren
        if (VERZUG > cGeld_KleinsterBetrag) and (VERZUG < Mahnschwelle) then
          ListBox1.items.addobject(format('Unterhalb der Mahnschwelle %m %s',
            [VERZUG, e_r_Person(PERSON_R)]), TObject(PERSON_R));
      end;

      post;
      ProgressBar1.position := RecN;
      application.processmessages;
      inc(RecN);
      next;
    end;
    close;
  end;
  EndWait;
  mQ.free;

  // jetzt noch die unterschwelligen Mahnungen löschen
  for n := 0 to pred(sNullMahnungen.count) do
    e_x_sql('delete from MAHNLAUF ' + 'where RID=' + inttostr(sNullMahnungen[n]));

  EndHourGlass;
  result := _Global_Offen;
end;

procedure TFormMahnung.Button20Click(Sender: TObject);
begin
  printhtmlOK(e_r_MahnungFName(MarkedPERSON_R));
end;

procedure TFormMahnung.Button3Click(Sender: TObject);
begin
  openShell(e_r_MahnungFName(MarkedPERSON_R));
end;

procedure TFormMahnung.CheckListBox1DblClick(Sender: TObject);
begin
  Button3Click(Sender);
end;

procedure TFormMahnung.Button11Click(Sender: TObject);
begin
  // diesen Datensatz buchen!
  if doit('Dürfen wirklich ' + inttostr(e_r_sql('select count(rid) from MAHNLAUF where BRIEF=''' +
    cC_True + '''')) + #13 + ' Mahnungen abgeschlossen werden') then
  begin
    BeginHourGlass;
    ErzeugeMahnliste(false, true);
    EnsureMahnungUpdate;
    EnsureOnline;
    EndHourGlass;
  end;
end;

function TFormMahnung.MarkedPERSON_R: Integer;
begin
  if IB_QueryMahnlauf.Active then
    result := IB_QueryMahnlauf.FieldByName('PERSON_R').AsInteger
  else
    result := cRID_Null;
end;

function TFormMahnung.MarkedPERSON_R2: Integer;
begin
  if (ListBox1.itemindex >= 0) then
    result := Integer(ListBox1.items.objects[ListBox1.itemindex])
  else
    result := -1;
end;

procedure TFormMahnung.Button5Click(Sender: TObject);
begin
  if doit('Alle Häkchen bei "Brief" entfernen') then
  begin
    e_x_sql('update MAHNLAUF set BRIEF=''' + cC_False + '''');
    EnsureOnline;
  end;
end;

procedure TFormMahnung.Button6Click(Sender: TObject);
begin
  FormAusgangsRechnungen.SetContext(MarkedPERSON_R2);
end;

procedure TFormMahnung.FormActivate(Sender: TObject);
begin
  if (Edit2.text = '') then
    Edit2.text := inttostr(iMahnFaelligkeitstoleranz);
  if (Edit3.text = '') then
    Edit3.text := format('%.2f', [iMahnSchwelle]);
end;

procedure TFormMahnung.FormCreate(Sender: TObject);
begin
  StartDebug('Mahnung');
  BlackList := TgpIntegerList.create;
  PageControl1.activepage := TabSheet2;
end;

procedure TFormMahnung.Button7Click(Sender: TObject);
var
  TheLine: string;
begin
  if (ListBox1.itemindex <> -1) then
  begin
    TheLine := ListBox1.items[ListBox1.itemindex];
    if pos('[', TheLine) * pos(']', TheLine) > 0 then
      FormBelege.SetContext(0, strtointdef(ExtractSegmentBetween(TheLine, '[', ']'), 0));
  end;
end;

procedure TFormMahnung.FormDestroy(Sender: TObject);
begin
  BlackList.free;
end;

procedure TFormMahnung.TabSheet2Show(Sender: TObject);
begin
  EnsureOnline;
end;

procedure TFormMahnung.ErzeugeAusschluss;
begin
  BeginHourGlass;
  if assigned(sAugesetzteBelege) then
    FreeAndNil(sAugesetzteBelege);
  if (date2long(Edit4.text) > date2long(cOrgaMonBirthDay)) then
  begin
    sAugesetzteBelege := e_r_sqlm('select distinct BELEG_R from AUSGANGSRECHNUNG where ' +
      ' (BETRAG>0) and ' + ' (BELEG_R is not null) and ' + ' (VALUTA>=''' + Edit4.text + ''')');
  end;
  EndHourGlass;
end;

function TFormMahnung.ErzeugeKundenListe: Integer;
var
  RecRead: Integer;
  cFAELLIGE: TIB_Cursor;
  cAUSGANGSRECHNUNG: TIB_Cursor;
  cUNPLAUSIBEL: TIB_Cursor;
  cBELEG: TIB_Cursor;
  PERSON_R: Integer;
  SummeLautAusgangsRechnung: double;
  SummeLautBelege: double;
  BetragsDifferenz: double;

  StartTime: dword;
  sDirOLAP: TStringList;
  sAusnahmen: TgpIntegerList;
  sKuerzlichGemahnte: TgpIntegerList;
  n, m: Integer;
  AusschlussName: string;

  procedure addBlack(PERSON_R: Integer; Msg: string);
  begin
    if (BlackList.indexof(PERSON_R) = -1) then
      BlackList.add(PERSON_R);
    if (Msg <> '') then
    begin
      if (pos('!', Msg) = 1) then
      begin
        ListBox1.items.insertobject(0, Msg, TObject(PERSON_R));
        inc(result);
      end
      else
        ListBox1.items.addobject(Msg, TObject(PERSON_R));
    end;
  end;

begin
  result := 0;
  BeginHourGlass;

  // Parameter lesen
  StartTime := 0;
  RecRead := 0;
  ListBox1.items.BeginUpdate;
  ListBox1.Clear;
  BlackList.Clear;

  // "Schnelle Rechnung" KANN nicht gemahnt werden!
  if iSchnelleRechnung_PERSON_R >= cRID_FirstValid then
    BlackList.add(iSchnelleRechnung_PERSON_R);

  // Blacklist um alle "unerwünschten" erweitern
  // Diese bleiben ausserhalb des Mahnsystems
  sDirOLAP := TStringList.create;
  dir(iOlapPath + 'System.Mahnung.Ausschluss.*' + cOLAPExtension, sDirOLAP, false);
  for n := 0 to pred(sDirOLAP.count) do
  begin
    AusschlussName :=
      ExtractSegmentBetween(sDirOLAP[n], 'System.Mahnung.Ausschluss.',cOLAPExtension);

    sAusnahmen := e_r_OLAP(sDirOLAP[n]);
    StartWait('Ausschluss "' + AusschlussName + '" ermitteln', sAusnahmen.count);
    for m := 0 to pred(sAusnahmen.count) do
    begin
      addBlack(sAusnahmen[m], format('Ausschluss "' + AusschlussName + '" %s',
        [e_r_Person(sAusnahmen[m])]));
      ProgressBar1.position := m;
    end;
    sAusnahmen.free;
  end;
  sDirOLAP.free;

  // Kürzlich gemahnte Personen ausklammern
  sKuerzlichGemahnte := e_r_sqlm(
    { } 'select distinct PERSON_R from BELEG where' +
    { } ' (MAHNUNG>=''' + Long2date(DatePlus(DateGet, -iMahnfreierZeitraum)) + ''')'
    { } );
  StartWait('Ausschluss "Kürzlich gemahnt" ermitteln', sKuerzlichGemahnte.count);
  for m := 0 to pred(sKuerzlichGemahnte.count) do
  begin
    addBlack(sKuerzlichGemahnte[m], format('Ausschluss "Kürzlich gemahnt" %s',
      [e_r_Person(sKuerzlichGemahnte[m])]));
    ProgressBar1.position := m;
  end;
  sKuerzlichGemahnte.free;

  // Plausi-Prüfungen
  StartWait('Prüfungen durchführen', 3);
  ProgressBar1.position := 1;
  cUNPLAUSIBEL := DataModuleDatenbank.nCursor;
  with cUNPLAUSIBEL do
  begin
    sql.add('select RID,PERSON_R from BELEG where');
    sql.add(' ( (mahnung3 is not null) and ( (mahnung2 is null) or (mahnung1 is null) )) or');
    sql.add(' ( (mahnung2 is not null) and (mahnung1 is null) ) or');
    sql.add(' ( (mahnstufe is null) and ( (mahnung1 is not null) or (mahnung2 is not null) or (mahnung3 is not null) ) ) or');
    sql.add(' ( (mahnstufe is not null) and (mahnung1 is null) and (mahnung2 is null) and (mahnung3 is null) ) or');
    sql.add(' ( (mahnstufe<>1) and (mahnung1 is not null) and (mahnung2 is null) and (mahnung3 is null) ) or');
    sql.add(' ( (mahnstufe<>2) and (mahnung1 is not null) and (mahnung2 is not null) and (mahnung3 is null) ) or');
    sql.add(' ( (mahnstufe<3) and (mahnung1 is not null) and (mahnung2 is not null) and (mahnung3 is not null) ) or');
    sql.add(' ( (mahnstufe=1) and (mahnung1<>mahnung) ) or');
    sql.add(' ( (mahnstufe=2) and (mahnung2<>mahnung) ) or');
    sql.add(' ( (mahnstufe=3) and (mahnung3<>mahnung) ) ');
    ApiFirst;
    while not(eof) do
    begin
      PERSON_R := FieldByName('PERSON_R').AsInteger;
      if (BlackList.indexof(PERSON_R) = -1) then
        addBlack(PERSON_R, format('!Unplausible Mahndaten im Beleg [%d] %s',
          [FieldByName('RID').AsInteger, e_r_Person(PERSON_R)]));
      ApiNext;
    end;
  end;
  cUNPLAUSIBEL.free;
  ProgressBar1.position := 2;

  // Kundenliste aufbauen ...
  cAUSGANGSRECHNUNG := DataModuleDatenbank.nCursor;
  with cAUSGANGSRECHNUNG do
  begin
    sql.add('select distinct kunde_r from AUSGANGSRECHNUNG');
    ApiFirst;
    StartWait('Mahnbedürftigkeit Feststellen', RecordCount);
    close;
    sql.Clear;
    sql.add('select kunde_r,sum(betrag) betrag from ausgangsrechnung group by kunde_r');
    Open;
    ApiFirst;

    while not(eof) do
    begin
      PERSON_R := FieldByName('KUNDE_R').AsInteger;
      if (BlackList.indexof(PERSON_R) = -1) then
      begin

        SummeLautAusgangsRechnung := FieldByName('BETRAG').AsDouble;
        cBELEG := DataModuleDatenbank.nCursor;
        with cBELEG do
        begin
          sql.add('select');
          sql.add(' sum(rechnungs_betrag) rechnungs_betrag,');
          sql.add(' sum(davon_bezahlt) davon_bezahlt');
          sql.add('from beleg where');
          sql.add(' person_r=' + inttostr(PERSON_R));
          sql.add('group by person_r');
          ApiFirst;
          SummeLautBelege := FieldByName('rechnungs_betrag').AsDouble -
            FieldByName('davon_bezahlt').AsDouble;
        end;
        cBELEG.free;

        BetragsDifferenz := abs(SummeLautAusgangsRechnung - SummeLautBelege);

        repeat

          if (BetragsDifferenz >= cGeld_KleinsterBetrag) then // Fehler!
          begin
            addBlack(PERSON_R, format('!Differenz %m %m %m %s', [SummeLautAusgangsRechnung,
              SummeLautBelege, SummeLautAusgangsRechnung - SummeLautBelege, e_r_Person(PERSON_R)]));
            break;
          end;

          if (SummeLautAusgangsRechnung < -cGeld_KleinsterBetrag) then // Guthaben!
          begin
            addBlack(PERSON_R, format('Guthaben %m %s', [SummeLautAusgangsRechnung,
              e_r_Person(PERSON_R)]));
            break;
          end;

          if (SummeLautAusgangsRechnung < cGeld_KleinsterBetrag) then // geringfügige Forderung
          begin
            addBlack(PERSON_R, '');
            break;
          end;

        until true;

      end;

      inc(RecRead);
      if frequently(StartTime, 777) or eof then
      begin
        ProgressBar1.position := RecRead;
        application.processmessages;
      end;
      ApiNext;
    end;
    EndWait;

  end;
  cAUSGANGSRECHNUNG.free;
  ProgressBar1.position := 3;

  // Personen hinzunehmen, die fällige Beträge haben
  cFAELLIGE := DataModuleDatenbank.nCursor;

  with cFAELLIGE do
  begin
    // grundsätzlich mahnfähige Personen
    sql.add('select distinct PERSON_R from BELEG');
    sql.add('where');
    sql.add(' (PERSON_R IS NOT NULL) and');
    sql.add(' ((MAHNUNG_AUSGESETZT IS NULL) OR (MAHNUNG_AUSGESETZT=''' + cC_False + ''')) and');
    sql.add(' (RECHNUNGS_BETRAG>=0.01) and');
    sql.add(' ((RECHNUNGS_BETRAG-DAVON_BEZAHLT>=0.01) or (DAVON_BEZAHLT is null)) and');
    sql.add(' (MAHNBESCHEID is null) and');
    sql.add(' (FAELLIG<''' + Long2date(DatePlus(DateGet, -strtointdef(Edit2.text,
      iMahnFaelligkeitstoleranz))) + ''')');

    AppendStringsToFile(sql, DiagnosePath + 'Mahnung.PERSON_R.txt');
    ApiFirst;
    RecRead := 0;
    StartWait('Liste aufbauen ', RecordCount);
    while not(eof) do
    begin

      // Personen die nicht auf der Blacklist sind aufnehmen!
      PERSON_R := FieldByName('PERSON_R').AsInteger;
      if (BlackList.indexof(PERSON_R) = -1) then
        AddCustomerByRID(PERSON_R);

      inc(RecRead);
      if frequently(StartTime, 777) then
      begin
        ProgressBar1.position := RecRead;
        application.processmessages;
      end;
      ApiNext;

    end;
    close;
  end;

  EndWait;
  ListBox1.items.EndUpdate;
  EndHourGlass;
end;

procedure TFormMahnung.EndWait;
begin
  ProgressBar1.position := 0;
  Label4.caption := '';
end;

procedure TFormMahnung.StartWait(titel: string; MaxCount: Integer);
begin
  ProgressBar1.position := 0;
  ProgressBar1.max := MaxCount;
  Label4.caption := titel;
  application.processmessages;
end;

procedure TFormMahnung.EnsureOnline;
begin
  BeginHourGlass;
  if not(IB_QueryMahnlauf.Active) then
    IB_QueryMahnlauf.Open
  else
    IB_QueryMahnlauf.refresh;
  if not(IB_QueryAusgesetzteBelege.Active) then
    IB_QueryAusgesetzteBelege.Open
  else
    IB_QueryAusgesetzteBelege.refresh;
  EndHourGlass;
end;

procedure TFormMahnung.EnsureMahnungUpdate;
begin
  e_x_sql('update MAHNLAUF M set ' +
    'MAHNUNG = (select max(B.MAHNUNG) from BELEG B where B.PERSON_R=M.PERSON_R)');
end;

procedure TFormMahnung.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Mahnsystem');
end;

function TFormMahnung.Execute(TAN: Integer): boolean;
var
  sLOG: TStringList;
begin
  result := false;
  try
    SilentMode := true;
    repeat
      PageControl1.activepage := TabSheet1;
      show;
      if (ErzeugeKundenListe <> 0) then
        break;
      ErzeugeMahnliste(false);
      result := true;
    until true;
    close;
  except
    on E: Exception do
    begin
      ListBox1.items.add(cERRORText + ' Mahnung: ' + E.Message);
      AppendStringsToFile('Mahnung: ' + E.Message, ErrorFName('MAHNUNG'), Uhr8);
    end;
  end;

  sLOG := TStringList.create;
  sLOG.addstrings(ListBox1.items);
  if (sLOG.count > 0) then
    sLOG.saveToFile(
     {} DiagnosePath +
     {} 'Mahnlauf-' + inttostrN(TAN, 8) +
     {} cLogExtension);
  sLOG.free;

  SilentMode := false;
end;

procedure TFormMahnung.Image1Click(Sender: TObject);
begin
  FormEinstellungen.SetContext('Mahnfälligkeitstoleranz');
end;

procedure TFormMahnung.Image3Click(Sender: TObject);
begin
  FormEinstellungen.SetContext('Mahnschwelle');
end;

procedure TFormMahnung.TabSheet3Show(Sender: TObject);
begin
  EnsureOnline;
end;

procedure TFormMahnung.IB_Grid2GetDisplayText(Sender: TObject; ACol, ARow: Integer;
  var AString: string);
begin
  if (ARow > 0) then
    if (AString <> '') then
      case ACol of
        1:
          ; // RID
        2:
          begin // PERSON
            AString := e_r_Person(strtoint(AString));
          end;
        3:
          begin // SALDO
            AString :=
              format('%m', [e_r_sqld('select SUM(BETRAG) from Ausgangsrechnung where BELEG_R=' +
              AString)]);
          end;
      end;
end;

procedure TFormMahnung.Button18Click(Sender: TObject);
var
  Bericht: TStringList;
begin
  Bericht := e_w_KontoInfo(MarkedPERSON_R);
  Bericht.free;
  openShell(e_r_MahnungFName(MarkedPERSON_R));
end;

procedure TFormMahnung.Button1Click(Sender: TObject);
begin
  ListBox1.items.saveToFile(DiagnosePath + 'Mahnvorlauf'+cLogExtension);
  openShell(DiagnosePath + 'Mahnvorlauf'+cLogExtension);
end;

procedure TFormMahnung.Button12Click(Sender: TObject);
begin
  FormAusgangsRechnungen.SetContext(IB_QueryAusgesetzteBelege.FieldByName('PERSON_R').AsInteger);
end;

procedure TFormMahnung.Button13Click(Sender: TObject);
begin
  FormPerson.SetContext(IB_QueryAusgesetzteBelege.FieldByName('PERSON_R').AsInteger);
end;

procedure TFormMahnung.Button14Click(Sender: TObject);
begin
  FormBelege.SetContext(0, IB_QueryAusgesetzteBelege.FieldByName('RID').AsInteger);
end;

procedure TFormMahnung.RefreshAussenstaende;
var
  summe: double;
  Aussenstaende: double;
  Offen: double;
  VERZUG: double;
  faellig: double;
  m1, m2, m3, mb: double;
  ungemahnt_r, ungemahnt_m1, ungemahnt_m2, ungemahnt_m3, ungemahnt_mb: double;
  cBELEGE: TIB_Cursor;
  n: Integer;
  LastValue: Integer;
  ThisValue: Integer;

  function Sign(i: Integer): string;
  begin
    if i >= 0 then
      result := '+'
    else
      result := '-';
  end;

begin
  BeginHourGlass;
  ListBox1.items.Clear;
  summe := e_r_sqld('select SUM(BETRAG) from ausgangsrechnung');
  ShowSaldo(StaticText1, summe, true);

  cBELEGE := DataModuleDatenbank.nCursor;
  with cBELEGE do
  begin

    // Alle Aussenstaende
    sql.add('select sum(RECHNUNGS_BETRAG) RECHNUNGS_BETRAG,SUM(DAVON_BEZAHLT) DAVON_BEZAHLT from BELEG');
    ApiFirst;
    Aussenstaende := FieldByName('RECHNUNGS_BETRAG').AsDouble -
      FieldByName('DAVON_BEZAHLT').AsDouble;
    close;
    ShowSaldo(StaticText11, Aussenstaende, true);

    // offene Beträge = Fälligkeit erst in der Zukunft
    sql.Clear;
    sql.add('select sum(RECHNUNGS_BETRAG) RECHNUNGS_BETRAG,SUM(DAVON_BEZAHLT) DAVON_BEZAHLT from BELEG');
    sql.add('where');
    sql.add('      (FAELLIG>''' + Long2date(DateGet) + ''')');
    ApiFirst;
    Offen := FieldByName('RECHNUNGS_BETRAG').AsDouble - FieldByName('DAVON_BEZAHLT').AsDouble;
    close;
    ShowSaldo(StaticText9, Offen, true);

    // Beträge in VerZug, ggf aber gemahnt!
    sql.Clear;
    sql.add('select sum(RECHNUNGS_BETRAG) RECHNUNGS_BETRAG,SUM(DAVON_BEZAHLT) DAVON_BEZAHLT from BELEG');
    sql.add('where');
    sql.add('      (FAELLIG<''' + Long2date(DatePlus(DateGet, -iMahnFaelligkeitstoleranz)) + ''')');
    ApiFirst;
    VERZUG := FieldByName('RECHNUNGS_BETRAG').AsDouble - FieldByName('DAVON_BEZAHLT').AsDouble;
    close;
    ShowSaldo(StaticText8, VERZUG, true);

    faellig := Aussenstaende - (Offen + VERZUG);

    // in Mahnung 1 / 2 / 3
    sql.Clear;
    sql.add('select sum(RECHNUNGS_BETRAG) RECHNUNGS_BETRAG,SUM(DAVON_BEZAHLT) DAVON_BEZAHLT from BELEG');
    sql.add('where');
    sql.add('      (MAHNBESCHEID is null) AND');
    sql.add('      (MAHNUNG2 is null) AND');
    sql.add('      (MAHNUNG3 is null) AND');
    sql.add('      (MAHNUNG1>=''' + Long2date(DatePlus(DateGet, -iMahnfreierZeitraum)) + ''')');
    ApiFirst;
    m1 := FieldByName('RECHNUNGS_BETRAG').AsDouble - FieldByName('DAVON_BEZAHLT').AsDouble;
    close;
    ShowSaldo(StaticText3, m1, true);

    // in aktueller Mahnung "1"
    sql.Clear;
    sql.add('select sum(RECHNUNGS_BETRAG) RECHNUNGS_BETRAG,SUM(DAVON_BEZAHLT) DAVON_BEZAHLT from BELEG');
    sql.add('where');
    sql.add('      (MAHNBESCHEID is null) AND');
    sql.add('      (MAHNUNG1 is not null) AND');
    sql.add('      (MAHNUNG3 is null) AND');
    sql.add('      (MAHNUNG2>=''' + Long2date(DatePlus(DateGet, -iMahnfreierZeitraum)) + ''')');
    ApiFirst;
    m2 := FieldByName('RECHNUNGS_BETRAG').AsDouble - FieldByName('DAVON_BEZAHLT').AsDouble;
    close;
    ShowSaldo(StaticText4, m2, true);

    // in aktueller Mahnung "2"
    sql.Clear;
    sql.add('select sum(RECHNUNGS_BETRAG) RECHNUNGS_BETRAG,SUM(DAVON_BEZAHLT) DAVON_BEZAHLT from BELEG');
    sql.add('where');
    sql.add('      (MAHNBESCHEID is null) AND');
    sql.add('      (MAHNUNG1 is not null) AND');
    sql.add('      (MAHNUNG2 is not null) AND');
    sql.add('      (MAHNUNG3>=''' + Long2date(DatePlus(DateGet, -iMahnfreierZeitraum)) + ''')');
    ApiFirst;
    m3 := FieldByName('RECHNUNGS_BETRAG').AsDouble - FieldByName('DAVON_BEZAHLT').AsDouble;
    close;
    ShowSaldo(StaticText5, m3, true);

    // im Mahnbescheid
    sql.Clear;
    sql.add('select sum(RECHNUNGS_BETRAG) RECHNUNGS_BETRAG,SUM(DAVON_BEZAHLT) DAVON_BEZAHLT from BELEG');
    sql.add('where');
    sql.add('      (MAHNBESCHEID is not null)');
    ApiFirst;
    mb := FieldByName('RECHNUNGS_BETRAG').AsDouble - FieldByName('DAVON_BEZAHLT').AsDouble;
    close;
    ShowSaldo(StaticText6, mb, true);

    // Berechnet "ungemahnt"
    ShowSaldo(StaticText7, VERZUG - (m1 + m2 + m3 + mb), true);
    ShowSaldo(StaticText10, VERZUG, true);

    // Berechnet "fällige Beträge"
    ShowSaldo(StaticText2, faellig, true);

    // bisher ungemahnte Mahnbare Rechnungen
    sql.Clear;
    sql.add('select sum(RECHNUNGS_BETRAG) RECHNUNGS_BETRAG,SUM(DAVON_BEZAHLT) DAVON_BEZAHLT from BELEG');
    sql.add('where');
    sql.add('      (FAELLIG<''' + Long2date(DatePlus(DateGet, -iMahnFaelligkeitstoleranz)) +
      ''') AND');
    sql.add('      (MAHNUNG1 is null)');
    ApiFirst;
    ungemahnt_r := FieldByName('RECHNUNGS_BETRAG').AsDouble - FieldByName('DAVON_BEZAHLT').AsDouble;
    close;
    ShowSaldo(StaticText12, ungemahnt_r, true);

    // bisher ungemahnte Mahnbare M1
    sql.Clear;
    sql.add('select sum(RECHNUNGS_BETRAG) RECHNUNGS_BETRAG,SUM(DAVON_BEZAHLT) DAVON_BEZAHLT from BELEG');
    sql.add('where');
    sql.add('      (FAELLIG<''' + Long2date(DatePlus(DateGet, -iMahnFaelligkeitstoleranz)) +
      ''') AND');
    sql.add('      (MAHNUNG<''' + Long2date(DatePlus(DateGet, -iMahnfreierZeitraum)) + ''') AND');
    sql.add('      (MAHNUNG1 is not null) AND');
    sql.add('      (MAHNUNG2 is null)');
    ApiFirst;
    ungemahnt_m1 := FieldByName('RECHNUNGS_BETRAG').AsDouble - FieldByName('DAVON_BEZAHLT')
      .AsDouble;
    close;
    ShowSaldo(StaticText13, ungemahnt_m1, true);

    // bisher ungemahnte Mahnbare M2
    sql.Clear;
    sql.add('select sum(RECHNUNGS_BETRAG) RECHNUNGS_BETRAG,SUM(DAVON_BEZAHLT) DAVON_BEZAHLT from BELEG');
    sql.add('where');
    sql.add('      (FAELLIG<''' + Long2date(DatePlus(DateGet, -iMahnFaelligkeitstoleranz)) +
      ''') AND');
    sql.add('      (MAHNUNG<''' + Long2date(DatePlus(DateGet, -iMahnfreierZeitraum)) + ''') AND');
    sql.add('      (MAHNUNG1 is not null) AND');
    sql.add('      (MAHNUNG2 is not null) AND');
    sql.add('      (MAHNUNG3 is null)');
    ApiFirst;
    ungemahnt_m2 := FieldByName('RECHNUNGS_BETRAG').AsDouble - FieldByName('DAVON_BEZAHLT')
      .AsDouble;
    close;
    ShowSaldo(StaticText14, ungemahnt_m2, true);

    // bisher ungemahnte Mahnbare M3
    sql.Clear;
    sql.add('select sum(RECHNUNGS_BETRAG) RECHNUNGS_BETRAG,SUM(DAVON_BEZAHLT) DAVON_BEZAHLT from BELEG');
    sql.add('where');
    sql.add('      (FAELLIG<''' + Long2date(DatePlus(DateGet, -iMahnFaelligkeitstoleranz)) +
      ''') AND');
    sql.add('      (MAHNUNG<''' + Long2date(DatePlus(DateGet, -iMahnfreierZeitraum)) + ''') AND');
    sql.add('      (MAHNUNG1 is not null) AND');
    sql.add('      (MAHNUNG2 is not null) AND');
    sql.add('      (MAHNUNG3 is not null) AND');
    sql.add('      (MAHNBESCHEID is null)');
    ApiFirst;
    ungemahnt_m3 := FieldByName('RECHNUNGS_BETRAG').AsDouble - FieldByName('DAVON_BEZAHLT')
      .AsDouble;
    close;
    ShowSaldo(StaticText15, ungemahnt_m3, true);

    // bisher ungemahnte Mahnbare MB
    sql.Clear;
    sql.add('select sum(RECHNUNGS_BETRAG) RECHNUNGS_BETRAG,SUM(DAVON_BEZAHLT) DAVON_BEZAHLT from BELEG');
    sql.add('where');
    sql.add('      (FAELLIG<''' + Long2date(DatePlus(DateGet, -iMahnFaelligkeitstoleranz)) +
      ''') AND');
    sql.add('      (MAHNUNG<''' + Long2date(DatePlus(DateGet, -iMahnungMahnBescheidLaufzeit)) +
      ''') AND');
    sql.add('      (MAHNBESCHEID is not null)');
    ApiFirst;
    ungemahnt_mb := FieldByName('RECHNUNGS_BETRAG').AsDouble - FieldByName('DAVON_BEZAHLT')
      .AsDouble;
    close;
    ShowSaldo(StaticText16, ungemahnt_mb, true);

    //
    ShowSaldo(StaticText17, ungemahnt_r + ungemahnt_m1 + ungemahnt_m2 + ungemahnt_m3 +
      ungemahnt_mb, true);

    // Anzahl der ungemahnten Personen
    LastValue := 0;
    for n := -3 to iMahnfreierZeitraum + 3 do
    begin
      sql.Clear;
      sql.add('select distinct count(PERSON_R) PERSON_R from BELEG');
      sql.add('where');
      sql.add('    ((RECHNUNGS_BETRAG-DAVON_BEZAHLT>0.009) or (RECHNUNGS_BETRAG>0.0 and DAVON_BEZAHLT is null)) and');
      sql.add('    (MAHNBESCHEID is null) and');
      sql.add('    (FAELLIG<''' + Long2date(DatePlus(DateGet, n + -iMahnFaelligkeitstoleranz)) +
        ''') and');
      sql.add('    ((MAHNUNG<''' + Long2date(DatePlus(DateGet, n + -iMahnfreierZeitraum)) +
        ''') or (MAHNUNG1 is NULL))');
      ApiFirst;
      ThisValue := FieldByName('PERSON_R').AsInteger;
      ListBox1.items.add(Long2date(DatePlus(DateGet, n)) + '  ' + inttostrN(ThisValue, 4) + ' (' +
        Sign(ThisValue - LastValue) + inttostrN(abs(ThisValue - LastValue), 3) + ')');
      LastValue := ThisValue;
      close;
      application.processmessages;
    end;

  end;
  cBELEGE.free;
  EndHourGlass;
end;

procedure TFormMahnung.Button15Click(Sender: TObject);
begin
  RefreshAussenstaende;
end;

procedure TFormMahnung.Button16Click(Sender: TObject);
begin
  ErzeugeAusschluss;
end;

end.
