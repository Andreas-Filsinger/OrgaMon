{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2023  Andreas Filsinger
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
unit ServiceApp;

{$ifdef FPC}
{$mode delphi}
{$endif}

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons,
  anfix, DCPcrypt2,
  DCPmd5, WordIndex, geld,

  // OrgaMon
  globals,
  Funktionen_App;

type
  TFormServiceApp = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    Edit1: TEdit;
    Button2: TButton;
    CheckBox11: TCheckBox;
    Label5: TLabel;
    Edit3: TEdit;
    Button6: TButton;
    Label6: TLabel;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    ComboBox1: TComboBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    Label7: TLabel;
    Label9: TLabel;
    ListBox1: TListBox;
    Edit4: TEdit;
    Button7: TButton;
    ComboBox2: TComboBox;
    Label12: TLabel;
    Edit5: TEdit;
    Label13: TLabel;
    Label8: TLabel;
    Edit6: TEdit;
    Button8: TButton;
    CheckBox1: TCheckBox;
    Edit7: TEdit;
    Edit8: TEdit;
    Label15: TLabel;
    Edit9: TEdit;
    Label16: TLabel;
    Edit10: TEdit;
    Label17: TLabel;
    Edit12: TEdit;
    Label18: TLabel;
    Edit11: TEdit;
    Label19: TLabel;
    Edit13: TEdit;
    Label20: TLabel;
    Edit15: TEdit;
    Label22: TLabel;
    CheckBox12: TCheckBox;
    Label11: TLabel;
    Label10: TLabel;
    Label14: TLabel;
    paStatus: TLabel;
    Button9: TButton;
    TabSheet4: TTabSheet;
    Edit16: TEdit;
    Button10: TButton;
    Edit17: TEdit;
    Button12: TButton;
    Button13: TButton;
    CheckBox16: TCheckBox;
    Button3: TButton;
    Label25: TLabel;
    Button4: TButton;
    Edit18: TEdit;
    CheckBox17: TCheckBox;
    Edit19: TEdit;
    Label26: TLabel;
    CheckBox19: TCheckBox;
    Label27: TLabel;
    Edit20: TEdit;
    Button1: TButton;
    Button5: TButton;
    Edit21: TEdit;
    ProgressBar1: TProgressBar;
    Label28: TLabel;
    Button11: TButton;
    Label24: TLabel;
    Edit22: TEdit;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    Button18: TButton;
    Button20: TButton;
    Button21: TButton;
    CheckBox20: TCheckBox;
    CheckBox15: TCheckBox;
    SpeedButton2: TSpeedButton;
    CheckBox21: TCheckBox;
    CheckBox22: TCheckBox;
    CheckBox18: TCheckBox;
    Button23: TButton;
    Edit23: TEdit;
    Button16: TButton;
    TabSheet8: TTabSheet;
    Edit24: TEdit;
    Label23: TLabel;
    Button24: TButton;
    Button25: TButton;
    Edit25: TEdit;
    Edit26: TEdit;
    ListBox2: TListBox;
    Button26: TButton;
    Label21: TLabel;
    Label29: TLabel;
    SpeedButton4: TSpeedButton;
    Edit14: TEdit;
    Button27: TButton;
    ComboBox3: TComboBox;
    Statistik: TTabSheet;
    Edit2: TEdit;
    Button14: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label4: TLabel;
    Memo4: TMemo;
    Button15: TButton;
    Label30: TLabel;
    Edit27: TEdit;
    Label31: TLabel;
    Label32: TLabel;
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Edit19KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);

    procedure Button20Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure ComboBox3Select(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure TabSheet5Show(Sender: TObject);
  private

    { Private-Deklarationen }
    STOP: boolean;
    Initialized: boolean;
    GUIInitialised : boolean;

    // Arbeits Verzeichnis initialisieren
    // Ini Laden
    procedure EnsureSetup;
    procedure _log(s: string);

  public

    { Public-Deklarationen }

    JonDaX: TOrgaMonApp;
    SectionPath: TStringList;
    GeraeteNo: string;

    procedure Diagnose_Log(One: TMdeRec; log: TStringList);
    procedure RefreshAppPath;

  end;

var
  FormServiceApp: TFormServiceApp;

implementation

uses
  Clipbrd, IniFiles, CareTakerClient,
  gplists, html, c7zip,
  SolidFTP, BinLager, wanfix;

{$R *.dfm}

procedure TFormServiceApp.FormActivate(Sender: TObject);
begin
 if not(GUIInitialised) then
 begin
  PageControl1.ActivePage := TabSheet1;
  GUIInitialised := true;
 end;
end;

procedure TFormServiceApp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 halt;
end;

procedure TFormServiceApp.FormDeactivate(Sender: TObject);
begin
 halt;
end;

procedure TFormServiceApp.RefreshAppPath;
var
  MyIni: TIniFile;
begin
  MyIni := TIniFile.Create(EigeneOrgaMonDateienPfad + cIniFName);
  Edit14.Text := MyIni.ReadString(ComboBox3.Text, cIniDataBaseName, MyProgramPath);
  MyIni.Free;
end;

procedure TFormServiceApp.Button4Click(Sender: TObject);
begin
  openshell(JonDaX.LogFName);
end;

procedure TFormServiceApp.Button5Click(Sender: TObject);
const
  cFixedTAN_FName = '90000.DAT';
var
  lAbgearbeitet: TgpIntegerList;
  lMeldungen: TStringList;
  i: integer;
  mRID: integer;
  mderec: TMdeRec;
  OneJLine: string;
  JProtokoll: string;
  OrgaMonErgebnis: file of TMdeRec; // Das sind Ergebnisse von MonDa
  sOrgaMonFName: string;
  dTimeOut: TANFiXDate;
  dMeldung: TANFiXDate;
  //dHandy: TANFiXDate;
  Stat_Meldungen: integer;
  lFehlDatum: TStringList;
  lHeuteFehlDatum: TStringList;
  GeraeteNo: string;
  MeldungsMoment: string;
  //_DateGet: TANFiXDate;
  //_SecondsGet: TAnfixTime;
begin
  _log('melde TAN ??? ... ');

  lAbgearbeitet := TgpIntegerList.Create;
  lMeldungen := TStringList.Create;
  lFehlDatum := TStringList.Create;
  lHeuteFehlDatum := TStringList.Create;
  fillchar(mderec, sizeof(mderec), 0);
  Stat_Meldungen := 0;
  try

    dTimeOut := DatePlus(DateGet, strtointdef(Edit21.Text, 0));
    sOrgaMonFName := MyProgramPath + cOrgaMonDataPath + cFixedTAN_FName;
    assignFile(OrgaMonErgebnis, sOrgaMonFName);
    rewrite(OrgaMonErgebnis);

    // Lade die fertigen!
    // lAbgearbeitet.LoadFromFile(MyProgramPath + cServerDataPath + 'abgearbeitet.dat');

    // Lade alle Meldungen!
    lMeldungen.LoadFromFile(MyProgramPath + cMeldungPath + '000.txt');
    for i := 0 to pred(lMeldungen.count) do
    begin
      mRID := strtointdef(nextp(lMeldungen[i], ';', 0), 0);
      if (mRID > 0) then
      begin

        // damit er nicht mehrfach übertragen wird
        lAbgearbeitet.add(mRID);

        // nun den mderec Schreiben!
        OneJLine := ANSI2OEM(lMeldungen[i]);
        nextp(OneJLine, ';');
        with mderec do
        begin

          RID := mRID;
          zaehlernummer_korr := nextp(OneJLine, ';');
          zaehlernummer_neu := nextp(OneJLine, ';');
          zaehlerstand_neu := nextp(OneJLine, ';');
          zaehlerstand_alt := nextp(OneJLine, ';');
          Reglernummer_korr := nextp(OneJLine, ';');
          Reglernummer_neu := nextp(OneJLine, ';');
          JProtokoll := nextp(OneJLine, ';');
          ersetze(cJondaProtokollDelimiter, ';', JProtokoll);
          TOrgaMonApp.setTTBT(JProtokoll, ProtokollInfo ) ;
          ausfuehren_ist_datum := strtointdef(nextp(OneJLine, ';'), 0);
          ausfuehren_ist_uhr := strtointdef(nextp(OneJLine, ';'), 0);
          MeldungsMoment := nextp(OneJLine, ';');
          GeraeteNo := nextp(OneJLine, ';');
          dMeldung := Date2Long(nextp(MeldungsMoment, ' - ', 0));

          if (ausfuehren_ist_datum > cMonDa_Status_unbearbeitet) then
            if (dMeldung > ausfuehren_ist_datum) then
              if (dMeldung > DatePlus(ausfuehren_ist_datum, 1)) then
              begin
                lFehlDatum.add(lMeldungen[i] + ';' + secondstostr(ausfuehren_ist_uhr));
                if dMeldung >= dTimeOut then
                  if lHeuteFehlDatum.IndexOf(GeraeteNo) = -1 then
                    lHeuteFehlDatum.add(GeraeteNo);
              end;
        end;

      end;
    end;

    lHeuteFehlDatum.add('###');
    (*
      lMeldungen.LoadFromFile(MyProgramPath + cJonDaServer_XMLRPCLogFName);
      for i := pred(lMeldungen.count) downto 0 do
      begin
      if (nextp(lMeldungen[i], ';', 2) = 'StartTAN') then
      begin

      _DateGet := strtoint(nextp(lMeldungen[i], ';', 0));
      if _DateGet < dTimeOut then
      continue;
      _SecondsGet := strtoseconds(nextp(lMeldungen[i], ';', 1));
      UHR := nextp(lMeldungen[i], ';', 7);
      if SecondsDiffABS(_DateGet, _SecondsGet, Date2Long(nextp(UHR, ' - ', 0)), strtoseconds(nextp(UHR, ' - ', 1))) >
      60 * 5 then
      begin
      GeraeteNo := nextp(lMeldungen[i], ';', 3);
      if lHeuteFehlDatum.IndexOf(GeraeteNo) = -1 then
      lHeuteFehlDatum.add(GeraeteNo);

      end;
      end;

      end;
    *)
    // Falsches Datum

    CloseFile(OrgaMonErgebnis);
  except
  end;
  lAbgearbeitet.Free;
  lMeldungen.Free;
  lFehlDatum.SaveToFile(MyProgramPath + '000-Datum.txt');
  lFehlDatum.Free;
  // lHeuteFehlDatum.Sort;
  lHeuteFehlDatum.SaveToFile(MyProgramPath + 'Geräte-Datum-Falsch-' + inttostr(dTimeOut) + '.txt');
  lHeuteFehlDatum.Free;

  Memo1.lines[pred(Memo1.lines.count)] := Memo1.lines[pred(Memo1.lines.count)] + '(' + inttostr(Stat_Meldungen) +
    'x) ' + 'OK';
  beep;

end;

procedure TFormServiceApp.Button3Click(Sender: TObject);
begin
  FileAlive(MyProgramPath + cIniFName);
  openshell(MyProgramPath + cIniFName);
end;

procedure TFormServiceApp.EnsureSetup;
var
  SectionName: string;
begin
  if not(Initialized) then
  begin
    SectionName := ComboBox3.Text;

    JonDaX := TOrgaMonApp.Create;
    JonDaX.readIni(SectionName);

    // lade IMEI
    _log('Lade Tabelle ' + cLICENCE_FName + ' ... ');
    with JonDaX.tIMEI do
    begin
      oSalt := SectionName;
      insertfromHash(JonDaX.DataPath, cLICENCE_FName);
      _log(inttostr(RowCount));
    end;

    // lade IMEI-OK
    _log('Lade Tabelle '+cIMEI_OK_FName+' ... ');
    with JonDaX.tIMEI_OK do
    begin
      oSalt := SectionName;
      insertfromHash(JonDaX.DataPath, cIMEI_OK_FName);
      _log(inttostr(RowCount));
    end;

    // Einstellungen weitergeben
    SolidFTP.SolidFTP_LogDir := DiagnosePath;

    //
    ComboBox2.items.Clear;
    ComboBox2.items.add(cActionRestantenLeeren);
    ComboBox2.items.add(cActionRestantenAddieren);
    ComboBox2.items.add(cActionFremdMonteurLoeschen);
    ComboBox2.items.add(cActionAusAlterTAN);

    // Aktuellen TAN Stand anzeigen
    Label25.caption := JonDaX.NewTrn(false);
    _log('FTP-Verzeichnis ist ' + JonDaX.pFTPPath);

    Initialized := true;
  end;
end;

procedure TFormServiceApp.Button2Click(Sender: TObject);
var
  n: integer;
  sParameter, sResult: TStringList;
  access_log: TStringList;

  procedure Nachtrag(TAN: string);
  var
    m: integer;
    MatchStr: string;
    Raw: string;
  begin
    if assigned(access_log) then
    begin
      MatchStr := '"GET /up.php?tan=' + TAN + '&data=';
      for m := 0 to pred(access_log.count) do
        if pos(MatchStr, access_log[m]) > 0 then
        begin
          Raw := ExtractSegmentBetween(access_log[m], MatchStr, ' HTTP/1.1"');
          Raw := RFC1738ToAnsi(Raw);
          _log(Raw);
          AppendStringsToFile(Raw, MyProgramPath + TAN + '\' + TAN + '.txt');
        end;
    end;

  end;

begin
  access_log := nil;
  sParameter := TStringList.Create;
  sParameter.Values['OFFLINE'] := cIni_Activate;

  if CheckBox22.Checked then
  begin
    access_log := TStringList.Create;
    access_log.LoadFromFile(MyProgramPath + 'access_log');
  end;

  if (Edit20.Text = '') then
  begin
    JonDaX.proceed_NoUpload := not(CheckBox17.Checked);
    sParameter.Values['TAN'] := Edit1.Text;
    Nachtrag(Edit1.Text);
    _log('verarbeite ' + Edit1.Text + ' ... ');
    sResult := JonDaX.proceed(sParameter);
    if sResult[0]='0' then
     _log('OK')
    else
     _log('ERROR');
    sResult.Free;
  end
  else
  begin
    for n := strtointdef(Edit1.Text, MaxInt) to strtointdef(Edit20.Text, -1) do
      if DirExists(MyProgramPath + inttostr(n)) then
      begin
        JonDaX.proceed_NoUpload := not(CheckBox17.Checked);
        sParameter.Values['TAN'] := inttostrN(n, 5);
        Nachtrag(inttostrN(n, 5));
        _log('verarbeite ' + inttostrN(n, 5) + ' ... ');
        sResult := JonDaX.proceed(sParameter);
        sResult.Free;
        _log('OK');
      end;
  end;
  sParameter.Free;
end;

procedure TFormServiceApp.Button6Click(Sender: TObject);
var
  AllTRN: TStringList;
  RID: integer;
  sDiagnose_Log: TStringList;
  sTAN_Log: TStringList;
  MoreInfo: string;
  OrgaMonFile: TStringList;
  StartTime: dword;
  GeraeteNummer: string;
  GeraetZIPFName: string;
  sMeldung: TStringList;
  sLostProceed: TStringList;
  GeraetZIPDatum: TANFiXDate;
  WasGefunden: boolean;

  procedure CheckOut(FName, Header: string);
  var
    FoundOne: boolean;
    MonDaRec: TMdeRec;
    MonDaF: file of TMdeRec;
    n: integer;
    Doppelte: TStringList;
    DoppelteAnz: integer;
    _FileOpenMode: integer;
  begin
    if FileExists(FName) then // hex
    begin
      Doppelte := TStringList.Create;
      FoundOne := false;
      assignFile(MonDaF, FName);
      _FileOpenMode := FileMode;
      FileMode := fmOpenRead + fmShareDenyNone;
      reset(MonDaF);
      FileMode := _FileOpenMode;
      for n := 1 to FileSize(MonDaF) do
      begin
        read(MonDaF, MonDaRec);
        TOrgaMonApp.toAnsi(MonDaRec);

        Doppelte.add(inttostr(MonDaRec.RID));
        if ((MonDaRec.RID = RID) or (RID = 0)) and ((pos(Edit5.Text, String(MonDaRec.zaehlernummer_neu)) > 0) or
          (Edit5.Text = '*')) and
        { } ((pos(Edit8.Text, MonDaRec.monteur) = 1) or (Edit8.Text = '*')) and
        { } ((strtointdef(Edit9.Text, MaxInt) = MonDaRec.ausfuehren_ist_datum) or
          (Date2Long(Edit9.Text) = MonDaRec.ausfuehren_ist_datum) or (Edit9.Text = '*')) and
          ((Date2Long(Edit13.Text) = MonDaRec.ausfuehren_soll) or (Edit13.Text = '*')) and
          ((pos(Edit6.Text, String(MonDaRec.zaehlernummer_alt)) > 0) or (Edit6.Text = '*')) and
          ((pos(Edit10.Text, TOrgaMonApp.getTTBT(MonDaRec.ProtokollInfo)) > 0) or (Edit10.Text = '*')) and
          ((pos(Edit12.Text, MonDaRec.ABNummer) > 0) or (Edit12.Text = '*')) and
          ((pos(Edit11.Text, MonDaRec.Zaehler_Strasse) > 0) or (Edit11.Text = '*')) and
          ((pos(Edit15.Text, MonDaRec.Baustelle) > 0) or (Edit15.Text = '*')) and true then
        begin
          WasGefunden := true;
          if not(FoundOne) then
          begin
            FoundOne := true;
            sDiagnose_Log.add(
             {} Header + ' [' + FName + ',' +
             {} long2date(FDate(FName)) + ',' +
             {} secondstostr(FSeconds(FName)) + ',' +
             {} inttostr(FSize(FName)) + ']');
          end
          else
          begin
            if CheckBox9.Checked then
              sDiagnose_Log.add('            ------------------------------------');
          end;
          if CheckBox9.Checked then
          begin
            Diagnose_Log(MonDaRec, sDiagnose_Log);
          end
          else
          begin
            if CheckBox10.Checked then
              with MonDaRec do
                sDiagnose_Log.add(Baustelle + ';' + zaehlernummer_alt + ';' + monteur + ';' + inttostr(RID) + ';' +
                  long2date(ausfuehren_soll) + ';' + BoolToStr(vormittags));

          end;
        end;
      end;
      Doppelte.sort;
      DoppelteAnz := 0;
      RemoveDuplicates(Doppelte, DoppelteAnz);
      if (DoppelteAnz > 0) then
        sDiagnose_Log.add(inttostr(DoppelteAnz) + ' doppelte!');

      Doppelte.Free;
      CloseFile(MonDaF);
    end
    else
    begin
      // sDiagnose_Log.add(Header);
      // sDiagnose_Log.add(' Fehler: Datei '+FName+' nicht gefunden!');
    end;
  end;

var
  n, m: integer;

begin
  // Auswerte-Funktion
  BeginHourGlass;
  sDiagnose_Log := TStringList.Create;
  OrgaMonFile := TStringList.Create;
  sTAN_Log := TStringList.Create;
  sMeldung := TStringList.Create;
  sLostProceed := TStringList.Create;
  AllTRN := TStringList.Create;

  sLostProceed.add('TAN');
  sTAN_Log.add('TAN;Moment;Geraet;Monteur;Baustelle;Version;Einstellungen');

  RID := strtointdef(Edit3.Text, 0);
  dir(Edit14.Text + ComboBox1.Text + '.', AllTRN, false);
  AllTRN.sort;
  if (AllTRN.count = 0) then
    AllTRN.add('.');
  AllTRN.sort;
  ProgressBar1.max := AllTRN.count;
  StartTime := 0;
  STOP := false;
  GeraetZIPDatum := 0;
  for n := pred(AllTRN.count) downto 0 do
  begin

    WasGefunden := false;

    try

      if frequently(StartTime, 800) then
      begin
        Label28.caption := AllTRN[n] + ' vom ' + long2date(GeraetZIPDatum);
        application.ProcessMessages;
        ProgressBar1.position := n;
        if STOP then
          break;
      end;

      GeraeteNummer := JonDaX.detectGeraeteNummer(Edit14.Text + AllTRN[n]);
      if (GeraeteNummer = '') then
        continue;

      GeraetZIPFName := Edit14.Text + AllTRN[n] + '\' + GeraeteNummer + cZIPExtension;
      GeraetZIPDatum := FDate(GeraetZIPFName);

      sMeldung.LoadFromFile(Edit14.Text + AllTRN[n] + '\' + AllTRN[n] + '.txt');

      if not(FileExists(Edit14.Text + AllTRN[n] + '\' + AllTRN[n] + '.dat')) then
        sLostProceed.add(AllTRN[n]);

      MoreInfo := AllTRN[n] + '\' + long2date(FDate(Edit14.Text + AllTRN[n] + '\NEW.ZIP')) + ' ' +
        secondstostr(FSeconds(Edit14.Text + AllTRN[n] + '\NEW.ZIP'));

      // Was kam vom Gerät
      if CheckBox6.Checked then
        CheckOut(Edit14.Text + AllTRN[n] + '\MONDA.DAT', MoreInfo + ' MonDa-Gerät bisher');

      // Was bleibt auf dem Gerät?
      if CheckBox11.Checked then
        CheckOut(Edit14.Text + AllTRN[n] + '\STAY.DAT', MoreInfo + ' verbleibt auf dem Gerät');

      if CheckBox16.Checked then
        CheckOut(Edit14.Text + AllTRN[n] + '\LOST.DAT', MoreInfo + ' wurde zwangsentfernt!');

      // Was kommt von OrgaMon
      if CheckBox5.Checked then
      begin
        dir(Edit14.Text + AllTRN[n] + '\???.DAT', OrgaMonFile, false);
        for m := 0 to pred(OrgaMonFile.count) do
          if CharInSet(OrgaMonFile[m][1], ['0' .. '9']) then
            CheckOut(Edit14.Text + AllTRN[n] + '\' + OrgaMonFile[m], MoreInfo + ' OrgaMon-Daten');
      end;

      // Was geht zum OrgaMon
      if CheckBox8.Checked then
        CheckOut(Edit14.Text + AllTRN[n] + '\' + AllTRN[n] + cDATExtension, MoreInfo + ' Meldung an OrgaMon');

      // Was geht wieder auf das Gerät
      if CheckBox7.Checked then
        CheckOut(Edit14.Text + AllTRN[n] + '\AUFTRAG.DAT', MoreInfo + ' MonDa-Gerät neu');

      // Was kam eigentlich über das Web
      // im Moment nur RID-Suche vorgesehen
      if CheckBox21.Checked then
      begin

        // Suche nach RIDs
        if (Edit3.Text <> '*') then
          for m := 0 to pred(sMeldung.count) do
            if (pos(Edit3.Text + ';', sMeldung[m]) = 1) then
              sDiagnose_Log.add('Meldung@' + AllTRN[n] + '=' + sMeldung[m]);

      end;

      repeat
        if CheckBox18.Checked then
          if not(WasGefunden) then
            break;

        sTAN_Log.add(AllTRN[n] + ';' + long2date(GeraetZIPDatum) + ' ' + secondstostr(FSeconds(GeraetZIPFName)) + ';' +
          GeraeteNummer + ';' + 'M' + ';' + 'B' + ';' + sMeldung.Values['VERSION'] + ';' + sMeldung.Values['OPTIONEN']);
      until true;

    except
      on E: Exception do
      begin
        sDiagnose_Log.add(cERRORText + ' 735:' + E.Message);
        break;
      end;
    end;
  end;
  if CheckBox12.Checked then
  begin
    dir(Edit14.Text + '0000\???.DAT', OrgaMonFile, false);
    for m := 0 to pred(OrgaMonFile.count) do
      if CharInSet(OrgaMonFile[m][1], ['0' .. '9']) then
        CheckOut(Edit14.Text + '0000\' + OrgaMonFile[m], OrgaMonFile[m] + ' OrgaMon-Daten');
  end;
  ProgressBar1.position := 0;
  sLostProceed.SaveToFile(MyProgramPath + 'Ohne-Proceed.txt');
  sDiagnose_Log.SaveToFile(MyProgramPath + 'Diagnose.txt');
  sTAN_Log.SaveToFile(MyProgramPath + 'TAN'+cLogExtension);

  EndHourGlass;

  openshell(MyProgramPath + 'Diagnose.txt');
  openshell(MyProgramPath + 'TAN'+cLogExtension);
  if sLostProceed.count > 1 then
    openshell(MyProgramPath + 'Ohne-Proceed.txt');

  sMeldung.Free;
  AllTRN.Free;
  sDiagnose_Log.Free;
  OrgaMonFile.Free;
  sTAN_Log.Free;
  sLostProceed.Free;
end;

procedure TFormServiceApp.Diagnose_Log(One: TMdeRec; log: TStringList);

  procedure outLog(s: string);
  begin
    log.add(s);
  end;

begin
  with One do
  begin
    outLog('            RID                  : ' + inttostr(RID));
    outLog('            Baustelle            : ' + string(Baustelle));
    outLog('            ABNummer             : ' + string(ABNummer));
    outLog('            Monteur              : ' + string(monteur));
    outLog('            Art                  : ' + string(Art));
    outLog('            zaehlernummer_alt    : ' + string(zaehlernummer_alt));
    outLog('            Reglernummer_alt     : ' + string(Reglernummer_alt));
    outLog('            ausfuehren_soll      : ' + string(long2date(ausfuehren_soll)));
    outLog('            vormittags           : ' + string(BoolToStr(vormittags)));
    outLog('            Monteur_Info         : ' + string(TOrgaMonApp.getTTBT(Monteur_Info)));
    outLog('            Zaehler_Info         : ' + string(TOrgaMonApp.getTTBT(Zaehler_Info)));
    outLog('            Zaehler_Name1        : ' + string(Zaehler_Name1));
    outLog('            Zaehler_Name2        : ' + string(Zaehler_Name2));
    outLog('            Zaehler_Strasse      : ' + string(Zaehler_Strasse));
    outLog('            Zaehler_Ort          : ' + string(Zaehler_Ort));
    outLog('            zaehlernummer_korr   : ' + string(zaehlernummer_korr));
    outLog('            zaehlernummer_neu    : ' + string(zaehlernummer_neu));
    outLog('            zaehlerstand_neu     : ' + string(zaehlerstand_neu));
    outLog('            zaehlerstand_alt     : ' + string(zaehlerstand_alt));
    outLog('            Reglernummer_korr    : ' + string(Reglernummer_korr));
    outLog('            Reglernummer_neu     : ' + string(Reglernummer_neu));
    outLog('            ProtokollInfo        : ' + string(TOrgaMonApp.getTTBT(ProtokollInfo)));
    outLog('            ausfuehren_ist_datum : ' + string(TOrgaMonApp.AusfuehrenStr(ausfuehren_ist_datum)));
    outLog('            ausfuehren_ist_uhr   : ' + string(secondstostr(ausfuehren_ist_uhr)));
  end;
end;

procedure TFormServiceApp.Button7Click(Sender: TObject);
begin
  ListBox1.items.add(Edit4.Text + ',' + ComboBox2.Text + ',' + Edit7.Text);
end;

procedure TFormServiceApp.Edit19KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Edit19.Text := RFC1738ToAnsi(Edit19.Text);
    Key := #0;
  end;
end;

procedure TFormServiceApp.Button8Click(Sender: TObject);
begin
  openshell(Edit14.Text + ComboBox1.Text + '\restanten.txt');
end;

procedure TFormServiceApp.Button9Click(Sender: TObject);
var
  sResult, sParameter: TStringList;
begin
  sParameter := TStringList.Create;
  MyProgramPath := Edit14.Text;
  sParameter.Values['TAN'] := Edit1.Text;
  sResult := JonDaX.proceed(sParameter);
  sResult.Free;
  sParameter.Free;
end;

procedure TFormServiceApp.ComboBox3Select(Sender: TObject);
begin
  RefreshAppPath;
end;

procedure TFormServiceApp.Button10Click(Sender: TObject);
var
  TheX: TStringList;

  procedure Doit(s: string);
  var
    sl: TStringList;
    n: integer;
    newl: string;
  begin
    sl := TStringList.Create;
    sl.LoadFromFile(s);
    for n := 0 to pred(sl.count) do
    begin
      if pos('            zaehlernummer_alt    :', sl[n]) = 1 then
        newl := '"' + cutblank(nextp(sl[n], ':', 1)) + '"';
      if pos('            zaehlernummer_neu    :', sl[n]) = 1 then
      begin
        newl := newl + ';"' + cutblank(nextp(sl[n], ':', 1)) + '"';
        TheX.add(newl);
      end;
    end;
  end;

begin
  TheX := TStringList.Create;
  Doit(Edit17.Text);
  Doit(Edit16.Text);
  TheX.sort;
  RemoveDuplicates(TheX);
  TheX.SaveToFile(MyProgramPath + 'Diagnose.txt');
  TheX.Free;
  openshell(MyProgramPath + 'Diagnose.txt');
end;

procedure TFormServiceApp.SpeedButton2Click(Sender: TObject);
begin
  openshell(MyProgramPath + cGeraeteEinstellungen);
end;

procedure TFormServiceApp.SpeedButton4Click(Sender: TObject);
begin
  RefreshAppPath;
end;

procedure TFormServiceApp.TabSheet1Show(Sender: TObject);
var
 Ids : TStringList;

  procedure Check(FName: String);
  var
    n: integer;
    Id: string;
    MyIni: TMemIniFile;
    sl: TStringList;
  begin
    if FileExists(FName) then
    begin
      sl := TStringList.Create;
      sl.LoadFromFile(FName);
      for n := 0 to pred(sl.Count) do
        if (pos('[', sl[n]) = 1) then
          if (revpos(']', sl[n]) = length(sl[n])) then
          begin
            Id := ExtractSegmentBetween(sl[n], '[', ']');
            if (Id = cGroup_Id_Default) then
              continue;
            if (Id = cGroup_Id_Spare) then
              continue;
            if (Ids.IndexOf(Id)=-1) then
            begin
              Ids.Add(Id);
              ComboBox3.Items.Add(Id);
              MyIni := TMemIniFile.create(FName);
              SectionPath.Add(Id+'='+MyIni.ReadString(Id, cIniDataBaseName, MyProgramPath));
              MyIni.Free;
            end;
          end;
      sl.Free;
    end;
  end;

begin
 if not(assigned(SectionPath)) then
 begin
   SectionPath := TStringList.Create;
   Ids := TStringList.Create;
   // 1. Rang
   Check(EigeneOrgaMonDateienPfad + cIniFName);
   // 2. Rang
   Check(MyProgramPath + cIniFName);

   if (Ids.Count=1) then
   begin
     // keine Alternativen
     ComboBox3.Text := Ids[0];
   end;

   Ids.Free;
 end;
end;

procedure TFormServiceApp.TabSheet5Show(Sender: TObject);
begin
 if (label32.Caption = '#') then
 begin
  // Quelle (eine Kopie - eben aus dem Ziel erstellt)
  edit27.Text := copy(iAppServerPfad,1,pred(length(iAppServerPfad)))+'-o\';
  // Ziel-Pfad, dort wirkt die Migration
  label32.Caption := 'Ziel: ' + iAppServerPfad;
 end;
end;

procedure TFormServiceApp._log(s: string);
begin
  Memo1.lines.add(s);
end;

procedure TFormServiceApp.Button11Click(Sender: TObject);
const
  cRID_Null = -1;
  cRID_FirstValid = 1;
var
  GeraeteID: string;
  sAltFName: string;
  sAlt: TStringList;
  sNeu: TStringList;
  n, m, o: integer;
  RID: integer;
  AllTRN: TStringList;
  AuftragFName: string;

  mderec: TMdeRec;
  fauftrag: file of TMdeRec; // neue, aufbereitete Liste an MonDa
  Gefunden: boolean;
  StartTime: dword;
begin
  GeraeteID := Edit22.Text;
  StartTime := 0;

  sAlt := TStringList.Create;
  sNeu := TStringList.Create;
  AllTRN := TStringList.Create;

  // Vorlauf
  AllTRN := TStringList.Create;
  dir(MyProgramPath + '?????.', AllTRN, false);
  AllTRN.sort;

  sAltFName := JonDaX.DataPath + 'Eingabe.' + GeraeteID + '.txt';
  sAlt.LoadFromFile(sAltFName);

  ProgressBar1.max := pred(sAlt.count);

  for n := 0 to pred(sAlt.count) do
  begin
    ProgressBar1.position := n;
    RID := strtointdef(nextp(sAlt[n], ';', 2), cRID_Null);
    if (RID >= cRID_FirstValid) then
    begin
      // Diesen RID in den Aufträgen finden!
      Gefunden := false;
      for m := pred(AllTRN.count) downto 0 do
      begin

        // der Anwendung etwas Zeit geben
        if frequently(StartTime, 333) then
          application.ProcessMessages;

        AuftragFName := MyProgramPath + AllTRN[m] + '\' + 'AUFTRAG.DAT';
        if FileExists(AuftragFName) then
        begin

          assignFile(fauftrag, AuftragFName);
          try
            reset(fauftrag);
          except
            on E: Exception do
              _log(cERRORText + ' 748:' + E.Message);
          end;
          for o := 1 to FileSize(fauftrag) do
          begin
            read(fauftrag, mderec);

            // die Abschlüsse des Monteurs übernehmen!
            if (mderec.RID = RID) then
            begin
              Gefunden := true;
              break;
            end;

          end;
          CloseFile(fauftrag);

        end;
        if Gefunden then
          break;
      end;
      if Gefunden then
      begin
        //
        sNeu.add(nextp(sAlt[n], ';', 0) + ';' + // 0
          nextp(sAlt[n], ';', 1) + ';' + // 1
          nextp(sAlt[n], ';', 2) + ';' + // 2
          nextp(sAlt[n], ';', 3) + ';' + // 3
          nextp(sAlt[n], ';', 4) + ';' + // 4
          nextp(JonDaX.toEingabe(mderec), ';', 5)); // 5
      end;
    end;
  end;

  //
  sNeu.SaveToFile(JonDaX.DataPath + 'Eingabe.' + GeraeteID + '-Neu.txt');

  sAlt.Free;
  sNeu.Free;
  AllTRN.Free;
  ProgressBar1.position := 0;

end;

procedure TFormServiceApp.Button12Click(Sender: TObject);
var
  FTP: TSolidFTP;
  n: integer;
  Path, TAN: string;
begin

  Path := 'W:\JonDaServer\';
  if (Edit20.Text = '') then
    Edit20.Text := Edit1.Text;

  FTP := TSolidFTP.Create;
  with FTP do
  begin
    Host := 'host';
    UserName := 'user';
    Password := 'pwd';
    connect;
  end;
  for n := strtointdef(Edit1.Text, MaxInt) to strtointdef(Edit20.Text, -1) do
  begin
    TAN := inttostrN(n, 5);
    if FSize(Path + TAN + '\' + TAN + cDATExtension) > 0 then
    begin
      FTP.Put(Path + TAN + '\' + TAN + cUTF8DataExtension, '', TAN + cUTF8DataExtension);
      FTP.Put(Path + TAN + '\' + TAN + cDATExtension, '', TAN + cDATExtension);
    end;
  end;
  FTP.Disconnect;
  FTP.Free;
end;

procedure TFormServiceApp.Button13Click(Sender: TObject);
begin
  STOP := true;
end;

procedure TFormServiceApp.Button14Click(Sender: TObject);
var
 log, stat : TStringList;
 DATUM, IMEI, MELDUNGEN, GERAET : string;
 Automat, n: Integer;

 function Mask(s:string):boolean;
 var
  i : Integer;
 begin
  result := false;
  if length(log[n])<length(s) then
   exit;
  for i := 1 to length(s) do
   if (s[i]<>'?') then
    if (log[n][i]<>s[i]) then
      exit;
  result := true;
 end;

begin
 BeginHourGlass;
 log := TStringList.create;
 log.LoadFromFile(edit2.Text);
 stat := TStringList.Create;
 Automat := 0;
 for n := 0 to pred(log.Count) do
 begin
  case AutoMat of
   0:if Mask('  ??.??.?? ??:??:?? ?????:???') then
     begin // Suche nach DATUM
       DATUM := copy(log[n],3,8);
       GERAET := copy(log[n],27,3);
       inc(Automat);
     end;
   1:if Mask('    IMEI ???????????????') then
     begin
       if RadioButton1.Checked then
         IMEI := copy(log[n],10,15)
       else
         IMEI := 'GGGGGGGGGGGG' + GERAET;
       inc(Automat);
     end;
   2:begin
      repeat

        if pos('->OrgaMon/Neu',log[n])>0 then
        begin
          MELDUNGEN := ExtractSegmentBetween(log[n],': ','/');
          if (MELDUNGEN<>'') and (MELDUNGEN<>'0') then
            Stat.Add(
             {} '20'+copy(DATUM,7,2)+copy(DATUM,4,2)+copy(DATUM,1,2)+';'+
             {} copy(DATUM,1,6)+'20'+copy(DATUM,7,2)+';'+
             {} IMEI + ';' +
             {} MELDUNGEN );
          Automat := 0;
          break;
        end;

        if Mask('  ??.??.?? ??:??:?? ???') then
        begin
          Automat := 0;
          break;
        end;

      until yet;
     end;
  end;
 end;
 Stat.sort;
 Stat.SaveToFile(ExtractFilePath(edit2.Text)+'\JonDaServer-Stat-1.csv');
 for n := pred(Stat.count) downto 1 do
 begin
  if nextp(Stat[n],';',0)=nextp(Stat[pred(n)],';',0) then
   if nextp(Stat[n],';',2)=nextp(Stat[pred(n)],';',2) then
   begin
    Stat[pred(n)] :=
     {A   } nextp(Stat[n],';',0) + ';' +
     {B   } nextp(Stat[n],';',1) + ';' +
     {IMEI} nextp(Stat[n],';',2) + ';' +
     {MELDUNGEN} IntToStr( StrtoIntDef(nextp(Stat[n],';',3),0)+
                           StrtoIntDef(nextp(Stat[pred(n)],';',3),0) );
    Stat.delete(n);
   end;
 end;
 if RadioButton1.Checked then
   Stat.insert(0,'Datum_A;Datum_B;IMEI;MELDUNGEN')
 else
   Stat.insert(0,'Datum_A;Datum_B;GERAET;MELDUNGEN');

 Stat.SaveToFile(ExtractFilePath(edit2.Text)+'\JonDaServer-Stat-2.csv');
 for n := pred(Stat.count) downto 1 do
 begin
  if (nextp(Stat[n],';',0)=nextp(Stat[pred(n)],';',0)) then
   begin
    IMEI := nextp(Stat[n],';',2);
    if length(IMEI)=15 then
     IMEI := '1';
    Stat[pred(n)] :=
     {A   } nextp(Stat[n],';',0) + ';' +
     {B   } nextp(Stat[n],';',1) + ';' +
     {count(IMEI)} IntToStr(StrToIntDef(IMEI,0)+1) + ';' +
     {MELDUNGEN} IntToStr( StrtoIntDef(nextp(Stat[n],';',3),0)+
                           StrtoIntDef(nextp(Stat[pred(n)],';',3),0) );
    Stat.delete(n);
   end;
 end;

 // switch single IMEI to 1
 for n := 1 to pred(Stat.count) do
 begin
   IMEI := nextp(Stat[n],';',2);
   if (length(IMEI)=15) then
   begin
     Stat[n] :=
      {A   } nextp(Stat[n],';',0) + ';' +
      {B   } nextp(Stat[n],';',1) + ';' +
      {count(IMEI)=1} '1' + ';' +
      {MELDUNGEN} nextp(Stat[n],';',3)  ;
   end;
 end;
 Stat.SaveToFile(ExtractFilePath(edit2.Text)+'\JonDaServer-Stat-3.csv');

 Stat.free;
 Log.free;
 EndHourGlass;
end;

procedure TFormServiceApp.Button15Click(Sender: TObject);
var
 SourcePath, DestPath : String;
 sDir: TStringList;

 function DestFName(SourceFName: String):String;
 begin
   // Zieldateiname=Quelldateiname, aber der SourcePfad ist ausgetauscht durch DestPath
   result := DestPath + copy(SourceFName, succ(length(SourcePath)), MaxInt);
   // Ziel loggen
   memo4.lines.add(result);
   Application.ProcessMessages;
 end;

type
  oldTMDERec = packed record

    { von GaZMa }
    RID: longint;
    Baustelle: string[6]; { wird auch für die Gerätenummer verwendet }
    ABNummer: string[5];
    Monteur: string[6];
    Art: string[2];
    Zaehlernummer_alt: TZaehlerNummerType;
    Reglernummer_alt: TZaehlerNummerType;
    Ausfuehren_soll: TAnfixDate;
    Vormittags: boolean;
    Monteur_Info: string[255];
    Zaehler_Info: string[255]; { auch Plausibilitätsfelder }
    Zaehler_Name1: string[35];
    Zaehler_Name2: string[35];
    Zaehler_Strasse: string[35];
    Zaehler_Ort: string[35];

    { von Monda }
    Zaehlernummer_korr: TZaehlerNummerType;
    Zaehlernummer_neu: TZaehlerNummerType;
    Zaehlerstand_neu: string[8];
    Zaehlerstand_alt: string[8];
    Reglernummer_korr: TZaehlerNummerType;
    Reglernummer_neu: TZaehlerNummerType;
    ProtokollInfo: string[255];

    { von Monda intern }
    { <0: Sonderstati, Bedeutung siehe obige Konstanten }
    { 00: Unerledigt }
    { >0: Erledigt }
    Ausfuehren_ist_datum: TAnfixDate; { Träger von cMonDa_Status }
    Ausfuehren_ist_uhr: TAnfixTime;

  end;

 procedure rc8726(s: oldTMDERec; var x :TMDERec);
 begin
   fillchar(x, sizeof(TMDERec), #0);
   with x do
   begin
    RID := s.RID;
    Baustelle := s.Baustelle;
    ABNummer := s.ABNummer;
    Monteur := s.Monteur;
    Art := s.Art;
    Zaehlernummer_alt := s.Zaehlernummer_alt;
    Reglernummer_alt := s.Reglernummer_alt;
    Ausfuehren_soll := s.Ausfuehren_soll;
    Vormittags := s.Vormittags;
    Zaehler_Name1 := s.Zaehler_Name1;
    Zaehler_Name2 := s.Zaehler_Name2;
    Zaehler_Strasse := s.Zaehler_Strasse;
    Zaehler_Ort := s.Zaehler_Ort;
    Zaehlernummer_korr := s.Zaehlernummer_korr;
    Zaehlernummer_neu := s.Zaehlernummer_neu;
    Zaehlerstand_neu := s.Zaehlerstand_neu;
    Zaehlerstand_alt := s.Zaehlerstand_alt;
    Reglernummer_korr := s.Reglernummer_korr;
    Reglernummer_neu := s.Reglernummer_neu;
    Ausfuehren_ist_datum := s.Ausfuehren_ist_datum;
    Ausfuehren_ist_uhr := s.Ausfuehren_ist_uhr;
    Monteur_Info[1] := s.Monteur_Info;
    Zaehler_Info[1] := s.Zaehler_Info;
    ProtokollInfo[1] := s.ProtokollInfo;
   end;
 end;

 procedure convertDAT(PathAndFName: String);
 var
  o : oldTMDERec;
  n : TMDERec;
  Inf: File of oldTMDERec;
  OutF : File of TMDERec;
  OutFName : string;
 begin
  OutFName := DestFName(PathAndFName);
  FileDelete(OutFName);

  AssignFile(Inf,PathAndFName);
  reset(Inf);
  AssignFile(OutF,OutFname);
  rewrite(OutF);
  while not(eof(Inf)) do
  begin
    read(inf,o);
    rc8726(o,n);
    write(OutF,n);
  end;
  CloseFile(Inf);
  CloseFile(OutF);
 end;

 procedure convertBLA(PathAndFName: String);
 var
  InBLA, OutBLA : TBLager;
  o : oldTMDERec;
  n : TMDERec;
  OutFName : string;
 begin
  // old
  InBLA  := TBLager.Create;
  InBLA.Init(PathAndFname, o, sizeof(oldTMDERec));
  InBLA.BeginTransaction(now);

  // clear new
  OutFName := DestFName(PathAndFName);
  FileDelete(OutFName + cBL_FileExtension);

  // new
  OutBLA := TBLager.Create;
  OutBLA.Init(OutFName, n, sizeof(TMDERec));
  OutBLA.DeleteAll;
  OutBLA.BeginTransaction(now);

  with InBLA do
  begin
    first;
    while not(eol) do
    begin
      rc8726(o,n);
      // Sicherstellen, dass die alte "TimeStamp" wiederverwendet wird
      OutBLA.SetTransactionTimeStamp(RecordTimeStamp);
      // Save
      OutBLA.insert(RecordIndex, sizeof(TMDERec));
      next;
    end;
  end;
  OutBLA.EndTransaction;
  InBLA.EndTransaction;
  FreeAndNil(OutBLA);
  FreeAndNil(InBLA);
 end;

var
 n : Integer;
 TAN, GGG: String;
 WorkPath: String;

begin
  // convert all DAT & BLA Files
  if sizeof(TMDERec)<=sizeof(oldTMDERec) then
   exit;
  if (iAppServerPfad='') then
   exit;
  SourcePath := edit27.Text;
  DestPath := iAppServerPfad;
  if (SourcePath=DestPath) then
   exit;
  if not(DirExists(SourcePath)) then
   exit;
  if not(DirExists(DestPath)) then
   exit;

  //
 //
{
  convertBLA('.\dat\Daten\AUFTRAG+TS');      # YES
  convertBLA('.\dat\Daten\FOTO+TS');         # YES
  convertBLA('.\dat\db\AUFTRAG+TS.BLA');     # eigentlich eine Kopie, daher nicht nötig

  convertDAT('.\ftp\AUFTRAG.???.DAT');       # YES
  convertDAT('.\ftp\???.DAT');               # kommt neu vom OrgaMon, daher nein
  convertDAT('.\dat\OrgaMon\?????.DAT');     # YES
  convertDAT('.\dat\Daten\???.DAT');         # YES
  convertDAT('.\dat\Daten\AUFTRAG.???.DAT'); # YES

  // nnnnn - Unterverzeichnisse
  if FileExits() then
    convertBLA('.\dat\nnnnn\AUFTRAG+TS');    # YES
  if FileExits() then
    convertBLA('.\dat\nnnnn\FOTO+TS');       # YES

  convertDAT('GGG.DAT');                     # YES
  convertDAT('nnnnn.DAT');                   # YES
  convertDAT('AUFTRAG.DAT');                 # YES
  convertDAT('MONDA.DAT');                   # YES
  convertDAT('STAY.DAT');                    # YES
  convertDAT('LOST.DAT');                    # YES

  }

  // init
  sDir := TStringList.create;


  if FileExists(SourcePath+'dat\Daten\AUFTRAG+TS' + cBL_FileExtension) then
    convertBLA(SourcePath+'dat\Daten\AUFTRAG+TS');
  if FileExists(SourcePath+'dat\Daten\FOTO+TS' + cBL_FileExtension) then
    convertBLA(SourcePath+'dat\Daten\FOTO+TS');

  dir(SourcePath+'ftp\AUFTRAG.???.DAT', sDir, false);
  for n := 0 to pred(sDir.Count) do
    convertDAT(SourcePath+'ftp\'+sDir[n]);

  dir(SourcePath+'dat\OrgaMon\?????.DAT', sDir, false, true);
  for n := 0 to pred(sDir.Count) do
    convertDAT(SourcePath+'dat\OrgaMon\'+sDir[n]);

  dir(SourcePath+'dat\Daten\???.DAT', sDir, false, true);
  for n := 0 to pred(sDir.Count) do
    convertDAT(SourcePath+'dat\Daten\'+sDir[n]);

  dir(SourcePath+'dat\Daten\AUFTRAG.???.DAT', sDir, false, true);
  for n := 0 to pred(sDir.Count) do
    convertDAT(SourcePath+'dat\Daten\'+sDir[n]);

  dir(SourcePath+'dat\*.', sDir, false, true);
  for n := 0 to pred(sDir.Count) do
    if (length(StrFilter(sDir[n],cZiffern))=5) then
    begin
      TAN := sDir[n];
      WorkPath := SourcePath + 'dat\' + TAN + '\';
      GGG := TOrgaMonApp.detectGeraeteNummer(WorkPath);

      if FileExists(WorkPath + 'AUFTRAG+TS' + cBL_FileExtension) then
        convertBLA(WorkPath + 'AUFTRAG+TS');
      if FileExists(WorkPath + 'FOTO+TS' + cBL_FileExtension) then
        convertBLA(WorkPath + 'FOTO+TS');

      convertDAT(WorkPath + GGG + '.DAT');
      convertDAT(WorkPath + TAN + '.DAT');
      convertDAT(WorkPath + 'AUFTRAG.DAT');
      convertDAT(WorkPath + 'MONDA.DAT');
      convertDAT(WorkPath + 'STAY.DAT');
      convertDAT(WorkPath + 'LOST.DAT');
    end;


  sDir.Free;
end;

procedure TFormServiceApp.Button16Click(Sender: TObject);
var
  SourceFName, DestFNAme: string;
begin
  SourceFName := MyProgramPath + 'Update\' + Edit23.Text;
  DestFNAme := MyProgramPath + cProtPrefix + cProtExtension;
  JonDaX.migrateProtokoll(SourceFName, DestFNAme);
  openshell(DestFNAme);
end;

procedure TFormServiceApp.Button18Click(Sender: TObject);
const
  cIsAblageMarkerFile = 'ampel-horizontal.gif';
  cFileTimeOutDays = 50 + 10;
  cPicTimeOutDays = 0; // 0 = gestern ist schon zu alt
var
  sDirs: TStringList;
  sZips: TStringList;
  sPics: TStringList;
  sFotos: TStringList;
  n, m: integer;
  sRoot: string;
  sPath, sPathShort: string;
  ZIP_OlderThan: TANFiXDate;
  PIC_OlderThan: TANFiXDate;

  sDest: string;
  MovedToDay: int64;
  tBAUSTELLE: TsTable;
  r: integer;

  FTP_Benutzer: string;
  mIni: TIniFile;
  FotosSequence: integer;
  Col_FTP_Benutzer: integer;

  //
  WARTEND: TsTable;

begin
  BeginHourGlass;

  // prepare
  sDirs := TStringList.Create;
  sZips := TStringList.Create;
  sPics := TStringList.Create;
  sFotos := TStringList.Create;

  tBAUSTELLE := TsTable.Create;
  tBAUSTELLE.insertfromFile(MyProgramPath + cDBPath + cFotoService_BaustelleFName);
  Col_FTP_Benutzer := tBAUSTELLE.colOf(cE_FTPUSER);

  //
  WARTEND := TsTable.Create;
  WARTEND.insertfromFile(MyProgramPath + cDBPath + cFotoService_UmbenennungAusstehendFName);

  // init
  sRoot := 'W:\';
  MovedToDay := 0;
  ZIP_OlderThan := DatePlus(DateGet, -cFileTimeOutDays);
  PIC_OlderThan := DatePlus(DateGet, -cPicTimeOutDays);
  sDest := PersonalDataDir + cApplicationName + '\';
  checkcreatedir(sDest);

  // work
  dir(sRoot + '*.', sDirs, false);
  ProgressBar1.max := sDirs.count;
  for n := 0 to pred(sDirs.count) do
  begin
    if pos('.', sDirs[n]) = 1 then
      continue;
    sPathShort := sDirs[n] + '\';
    sPath := sRoot + sPathShort;

    ProgressBar1.position := n;

    if FileExists(sPath + cIsAblageMarkerFile) then
    begin

      // Zips
      dir(sPath + '*.zip', sZips, false);
      for m := 0 to pred(sZips.count) do
      begin
        if (FileDate(sPath + sZips[m]) < ZIP_OlderThan) then
        begin
          checkcreatedir(sDest + sDirs[n]);
          inc(MovedToDay, FSize(sPath + sZips[m]));
          FileMove(sPath + sZips[m], sDest + sDirs[n] + '\' + sZips[m]);
          Label28.caption := inttostr(MovedToDay);
          application.ProcessMessages;
        end;
      end;

      // Jpegs
      dir(sPath + '*.jpg', sPics, false);

      // reduziere auf "zu neue" Bilder
      for m := pred(sPics.count) downto 0 do
        if (FileDate(sPath + sPics[m]) >= PIC_OlderThan) then
          sPics.Delete(m);

      // reduziere um "wartende" Bilder
      if (sPics.count > 0) then
      begin
        for m := pred(sPics.count) downto 0 do
          if (WARTEND.locate('DATEINAME_AKTUELL', sPathShort + sPics[m]) <> -1) then
            sPics.Delete(m);
      end;

      if (sPics.count > 0) then
      begin
        repeat

          // Prüfen, ob dies eine ordentliche Baustelle ist
          FTP_Benutzer := nextp(sPath, '\', 1);
          if CharInSet(FTP_Benutzer[1], ['0' .. '9']) then
            FTP_Benutzer := 'u' + FTP_Benutzer;
          r := tBAUSTELLE.locate(Col_FTP_Benutzer, FTP_Benutzer);
          if (r = -1) then
            break;

          // Die Nummer des zu erzeugenden ZIP suchen
          mIni := TIniFile.Create(sPath + 'Fotos-nnnn.ini');
          with mIni do
          begin
            FotosSequence := strtoint(ReadString(cGroup_Id_Default, 'Sequence', '-1'));
            if FotosSequence < 0 then
            begin
              dir(sPath + 'Fotos-????.zip', sFotos, false);
              if sFotos.count > 0 then
              begin
                sFotos.sort;
                FotosSequence := strtointdef(ExtractSegmentBetween(sFotos[pred(sFotos.count)], 'Fotos-', cZIPExtension), -1);
              end;
            end;

            if FotosSequence < 0 then
              FotosSequence := 0;

            inc(FotosSequence);
            WriteString(cGroup_Id_Default, 'Sequence', inttostr(FotosSequence));
          end;
          mIni.Free;

          // Archivieren
          if (zip(
            { } sPics,
            { } sPath +
            { } 'Fotos-' + inttostrN(FotosSequence, 4) + cZIPExtension,
            { } czip_set_RootPath + '=' + sPath + ';' +
            { } czip_set_Password + '=' +
            { } deCrypt_Hex(
            { } tBAUSTELLE.readCell(r, cE_ZIPPASSWORD)) + ';' +
            { } czip_set_Level + '=' + '0') = sPics.count) then
          begin
            // Löschen!
            for m := 0 to pred(sPics.count) do
              FileDelete(sPath + sPics[m]);
          end;
        until true;
      end;

    end;
  end;

  // unprepare
  sDirs.Free;
  sZips.Free;
  sPics.Free;
  sFotos.Free;
  tBAUSTELLE.Free;
  WARTEND.Free;
  ProgressBar1.position := 0;
  EndHourGlass;

end;

procedure TFormServiceApp.Button20Click(Sender: TObject);

  procedure toText(FName: string);
  var
    bla: TBLAGER;
    mderec: TMdeRec;
    s: TStringList;
  begin
    s := TStringList.Create;
    bla := TBLAGER.Create;
    bla.Init(FName, mderec, sizeof(TMdeRec));
    with bla do
    begin
      BeginTransaction(now);
      s.add(format('ANZAHL=%d', [CountRecs]));
      try
        first;
        while not(eol) do
        begin
          if RecordTimeStamp > 1 then
            s.add(format('RID%d [%d] %s %s', [
              { } RecordIndex,
              { } RecordSize,
              { } long2dateLocalized(RecordTimeStamp),
              { } TOrgaMonApp.getTTBT(mderec.Zaehler_Info)]));
          next;
        end;
      except
        on E: Exception do
          ShowMessage(format('RID%d [%d] %.2f %s:' + #13 + '%s', [
            { } RecordIndex,
            { } RecordSize,
            { } RecordTimeStamp,
            { } TOrgaMonApp.getTTBT(mderec.Zaehler_Info),
            { } E.Message]));
      end;
      EndTransaction;
    end;
    bla.Free;
    s.SaveToFile(FName + '.txt');
    openshell(FName + '.txt');
  end;

var
  Postfix: string;

begin
  // toText(MyProgramPath + cServerDataPath + 'FOTO+TS - Kopie');
  // toText(MyProgramPath + cServerDataPath + 'AUFTRAG+TS - Kopie');
  Postfix := '';
  if CheckBox15.Checked then
    Postfix := ' - Kopie';
  if CheckBox20.Checked then
    Postfix := '.fresh';

  toText(MyProgramPath + cServerDataPath + 'FOTO+TS' + Postfix);
  toText(MyProgramPath + cServerDataPath + 'AUFTRAG+TS' + Postfix);
end;

procedure TFormServiceApp.Button21Click(Sender: TObject);
begin
  JonDaX.DoAbschluss;
end;

procedure TFormServiceApp.Button23Click(Sender: TObject);
begin
  BeginHourGlass;
  JonDaX.maintainGERAETE;
  EndHourGlass;
end;

procedure TFormServiceApp.Button24Click(Sender: TObject);
begin
  // JonDaX

  if (JonDaX.tIMEI.count = 0) then
  begin
    // lade IMEI
    JonDaX.tIMEI.oSalt := JonDaX.MandantId;
    JonDaX.tIMEI.insertfromHash(MyProgramPath + cDBPath , cLICENCE_FName);

    // lade IMEI-OK
    JonDaX.tIMEI_OK.oSalt := JonDaX.MandantId;
    JonDaX.tIMEI_OK.insertfromHash(MyProgramPath + cDBPath , cIMEI_OK_FName);
  end;

  with JonDaX.tIMEI_OK do
  begin
    if (locate('IMEI', Edit24.Text) = -1) then
      ShowMessage(cWARNINGText + ' Unbekanntes Handy!')
    else
      ShowMessage('OK!');
  end;

end;

procedure TFormServiceApp.Button25Click(Sender: TObject);
begin
  JonDaX.maintainSENDEN;
end;

procedure TFormServiceApp.Button26Click(Sender: TObject);
var
  n, k: integer;
  v: TgpIntegerList;
begin
  ListBox2.Clear;
  n := strtoint(Edit25.Text);
  k := strtoint(Edit26.Text);
  v := TgpIntegerList.Create;
  while (n_over_k(n, k, v)) do
    ListBox2.items.add('(' + v.AsDelimitedText(',') + ')');
  v.Free;
end;

procedure TFormServiceApp.Button27Click(Sender: TObject);
begin
  if not(FileExists(Edit14.Text + 'cOrgaMon.ini')) then
  begin
    ShowMessage('Die ist kein Service-Verzeichnis');
    exit;
  end;

  MyProgramPath := Edit14.Text;
  EnsureSetup;
end;

procedure TFormServiceApp.Button1Click(Sender: TObject);
begin
  BeginHourGlass;
  JonDaX.doStat;
  EndHourGlass;
end;

end.
