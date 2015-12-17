{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2015  Andreas Filsinger
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
unit ServiceApp;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,
  anfix32, DCPcrypt2,
  DCPmd5, WordIndex, geld,

  // Indy
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP,

  // JonDaServer
  globals, JonDaExec, Buttons;

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
    Label4: TLabel;
    Label5: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Button6: TButton;
    Label6: TLabel;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    ComboBox1: TComboBox;
    CheckBox9: TCheckBox;
    DCP_md51: TDCP_md5;
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
    Edit14: TEdit;
    Label21: TLabel;
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
    Button14: TButton;
    Edit18: TEdit;
    Button15: TButton;
    CheckBox17: TCheckBox;
    Edit19: TEdit;
    Label26: TLabel;
    CheckBox19: TCheckBox;
    Label27: TLabel;
    Edit20: TEdit;
    Button1: TButton;
    Button5: TButton;
    Edit21: TEdit;
    Button17: TButton;
    ProgressBar1: TProgressBar;
    Label28: TLabel;
    Button11: TButton;
    Label24: TLabel;
    Edit22: TEdit;
    TabSheet5: TTabSheet;
    Button19: TButton;
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
    Button22: TButton;
    Button23: TButton;
    TabSheet7: TTabSheet;
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
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Edit19KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);

    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
  private

    { Private-Deklarationen }
    STOP: boolean;
    Initialized: boolean;

    // Log-Sachen
    sSendenLog: TStringList;

  public

    { Public-Deklarationen }

    // ermittelte Werte
    JonDaX: TJonDaExec;
    GeraeteNo: string;



    // Filter und Entry-Points

    // Eigentliche Arbeit
    procedure Diagnose_Log(One: TMdeRec; log: TStringList);
    function iXMLRPCHost: string;
    function iXMLRPCPort: string;

  end;

var
  FormServiceApp: TFormServiceApp;

implementation

uses
  Clipbrd, IniFiles, CareTakerClient,
  pem, gplists, html,
  SolidFTP, BinLager32, wanfix32,
  InfoZip;

{$R *.dfm}

procedure BeginHourGlass;
begin
  if (HourGlassLevel = 0) then
    screen.cursor := crHourGlass;
  inc(HourGlassLevel);
end;

procedure EndHourGlass;
begin
  dec(HourGlassLevel);
  if (HourGlassLevel = 0) then
  begin
    screen.cursor := crdefault;
  end;
end;

procedure EnsureHourGlass;
begin
  if (HourGlassLevel > 0) then
  begin
    screen.cursor := crHourGlass;
  end;
end;


// Datum;Uhrzeit;RID;Z#alt;Z#neu;Prefix

procedure TFormServiceApp.FormCreate(Sender: TObject);
var
  MyIni: TIniFile;
  sLog: TStringList;
  n: integer;
  iDateFromLog: TANFiXDate;
  SectionName: string;
begin
  JonDaX := TJonDaExec.create;
  sSendenLog := TStringList.create;

  // interne Varibale setzen
  DiagnosePath := MyProgramPath;
  caption := 'Service-App [' + UserName + '@' + MyProgramPath + '] Rev. ' + RevToStr(JonDaExec.Version);

  // Ini-Datei öffnen
  MyIni := TIniFile.create(MyProgramPath + '-' + cIniFName);
  with MyIni do
  begin
    SectionName := UserName;
    if (ReadString(SectionName, 'ftpuser', '') = '') then
      SectionName := 'System';

    // Ftp-Bereich für diesen Server
    iJonDa_FTPHost := ReadString(SectionName, 'ftphost', 'gateway');
    iJonDa_FTPUserName := ReadString(SectionName, 'ftpuser', '');
    iJonDa_FTPPassword := ReadString(SectionName, 'ftppwd', '');
  end;
  MyIni.free;

  // sSendenLog aufbauen!
  FileAlive(MyProgramPath + cJonDaServer_LogFName);
  iDateFromLog := DatePlus(DateGet, -10);
  sLog := TStringList.create;
  sLog.LoadFromFile(MyProgramPath + cJonDaServer_LogFName);
  for n := pred(sLog.count) downto 0 do
  begin
    if JonDaX.LogMatch(sLog[n], cGeraetSchema) then
    begin
      if (Date2Long(nextp(sLog[n], ' ', 2)) < iDateFromLog) then
        break;
      sSendenLog.insert(0, sLog[n]);
    end;
  end;
  sLog.free;

  //
  JonDaX.BeginAction('Start ' + cApplicationName + ' Rev. ' + RevToStr(globals.Version) + ' [' +
    UserName + ']');
  CareTakerLog(cApplicationName + ' Rev. ' + RevToStr(globals.Version) + ' gestartet');

  // Verzeichnisse Anlegen
  if FileExists(MyProgramPath + cIniFName) then
  begin
    checkcreatedir(MyProgramPath + cServerDataPath);
    checkcreatedir(MyProgramPath + cOrgaMonDataPath);
    checkcreatedir(MyProgramPath + cMeldungPath);
    checkcreatedir(MyProgramPath + cStatistikPath);
    // checkcreatedir(MyProgramPath + cUpdatePath);
    checkcreatedir(MyProgramPath + cProtokollPath);
    checkcreatedir(MyProgramPath + cGeraeteEinstellungen);
    checkcreatedir(MyProgramPath + cFotoPath);
    checkcreatedir(MyProgramPath + cDBPath);
    checkcreatedir(MyProgramPath + cSyncPath);
  end;

  PageControl1.ActivePage := TabSheet1;

  //
  ComboBox2.items.Clear;
  ComboBox2.items.add(cActionRestantenLeeren);
  ComboBox2.items.add(cActionRestantenAddieren);
  ComboBox2.items.add(cActionFremdMonteurLoeschen);
  ComboBox2.items.add(cActionAusAlterTAN);

end;

procedure TFormServiceApp.FormDestroy(Sender: TObject);
begin
  if assigned(JonDaX) then
    JonDaX.free;

  if assigned(sSendenLog) then
    sSendenLog.free;

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
  MyProgramPath: string;
  sOrgaMonFName: string;
  dTimeOut: TANFiXDate;
  dMeldung: TANFiXDate;
  dHandy: TANFiXDate;
  Stat_Meldungen: integer;
  lFehlDatum: TStringList;
  lHeuteFehlDatum: TStringList;
  GeraeteNo: string;
  MeldungsMoment: string;
  _DateGet: TANFiXDate;
  _SecondsGet: TAnfixTime;
  UHR: string;
begin
  Memo1.lines.add('melde TAN ??? ... ');

  MyProgramPath := 'W:\JonDaServer\';

  lAbgearbeitet := TgpIntegerList.create;
  lMeldungen := TStringList.create;
  lFehlDatum := TStringList.create;
  lHeuteFehlDatum := TStringList.create;
  fillchar(mderec, sizeof(mderec), 0);
  Stat_Meldungen := 0;
  try

    dTimeOut := DatePlus(DateGet, strtointdef(Edit21.text, 0));
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
          ProtokollInfo := JProtokoll;
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
        if SecondsDiffABS(_DateGet, _SecondsGet, Date2Long(nextp(UHR, ' - ', 0)),
          strtoseconds(nextp(UHR, ' - ', 1))) > 60 * 5 then
        begin
          GeraeteNo := nextp(lMeldungen[i], ';', 3);
          if lHeuteFehlDatum.IndexOf(GeraeteNo) = -1 then
            lHeuteFehlDatum.add(GeraeteNo);

        end;
      end;

    end;

    // Falsches Datum

    CloseFile(OrgaMonErgebnis);

    (*
      with idftp1 do
      begin
      //
      if not (connected) then
      connect;
      if (FSize(sOrgaMonFname) > 0) then
      sput(sOrgaMonFname, cFixedTAN_FName)
      else
      WriteDetail('Unterlassener Upload aufgrund Ergebnislosigkeit bei TRN ' + cFixedTAN_FName);
      quit;
      end;
      WriteDetail('->OrgaMon     : ' + inttostr(Stat_Meldungen));
    *)

  except
  end;
  lAbgearbeitet.free;
  lMeldungen.free;
  lFehlDatum.SaveToFile(MyProgramPath + '000-Datum.txt');
  lFehlDatum.free;
  // lHeuteFehlDatum.Sort;
  lHeuteFehlDatum.SaveToFile(MyProgramPath + 'Geräte-Datum-Falsch-' + inttostr(dTimeOut) + '.txt');
  lHeuteFehlDatum.free;

  Memo1.lines[pred(Memo1.lines.count)] := Memo1.lines[pred(Memo1.lines.count)] + '(' +
    inttostr(Stat_Meldungen) + 'x) ' + 'OK';
  beep;

end;

procedure TFormServiceApp.Button3Click(Sender: TObject);
begin
  FileAlive(MyProgramPath + cIniFName);
  openshell(MyProgramPath + cIniFName);
end;

procedure TFormServiceApp.FormActivate(Sender: TObject);
begin

  if not(Initialized) then
  begin
    show;
    SetForegroundWindow(handle);
    Initialized := true;
    Label25.caption := JonDaX.NewTrn(false);
    Memo1.lines.add('FTP-Login is ' + iJonDa_FTPUserName + '@' + iJonDa_FTPHost);
    Nachmeldungen;
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
          Memo1.lines.add(Raw);
          AppendStringsToFile(Raw, MyProgramPath + TAN + '\' + TAN + '.txt');
        end;
    end;

  end;

begin
  access_log := nil;
  sParameter := TStringList.create;
  sParameter.Values['OFFLINE'] := cIni_Activate;

  MyProgramPath := Edit14.text;

  if CheckBox22.Checked then
  begin
    access_log := TStringList.create;
    access_log.LoadFromFile(MyProgramPath + 'access_log');
  end;

  if (Edit20.text = '') then
  begin
    JonDaX.proceed_NoUpload := not(CheckBox17.Checked);
    sParameter.Values['TAN'] := Edit1.text;
    Nachtrag(Edit1.text);
    Memo1.lines.add('verarbeite ' + Edit1.text + ' ... ');
    sResult := JonDaX.proceed(sParameter);
    sResult.free;
    Memo1.lines[pred(Memo1.lines.count)] := Memo1.lines[pred(Memo1.lines.count)] + 'OK';
  end
  else
  begin
    for n := strtointdef(Edit1.text, MaxInt) to strtointdef(Edit20.text, -1) do
      if DirExists(MyProgramPath + inttostr(n)) then
      begin
        JonDaX.proceed_NoUpload := not(CheckBox17.Checked);
        sParameter.Values['TAN'] := inttostrN(n, 5);
        Nachtrag(inttostrN(n, 5));
        Memo1.lines.add('verarbeite ' + inttostrN(n, 5) + ' ... ');
        sResult := JonDaX.proceed(sParameter);
        sResult.free;
        Memo1.lines[pred(Memo1.lines.count)] := Memo1.lines[pred(Memo1.lines.count)] + 'OK';
      end;
  end;
  sParameter.free;
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
    md5: string;
  begin
    if FileExists(FName) then // hex
    begin
      md5 := DCP_md51.FromFile(FName);
      Doppelte := TStringList.create;
      FoundOne := false;
      assignFile(MonDaF, FName);
      _FileOpenMode := FileMode;
      FileMode := fmOpenRead + fmShareDenyNone;
      reset(MonDaF);
      FileMode := _FileOpenMode;
      for n := 1 to FileSize(MonDaF) do
      begin
        read(MonDaF, MonDaRec);
        TJonDaExec.toAnsi(MonDaRec);

        Doppelte.add(inttostr(MonDaRec.RID));
        if ((MonDaRec.RID = RID) or (RID = 0)) and
          ((pos(Edit5.text, MonDaRec.zaehlernummer_neu) > 0) or (Edit5.text = '*')) and
        { } ((pos(Edit8.text, MonDaRec.monteur) = 1) or (Edit8.text = '*')) and
        { } ((strtointdef(Edit9.text, MaxInt) = MonDaRec.ausfuehren_ist_datum) or
          (Date2Long(Edit9.text) = MonDaRec.ausfuehren_ist_datum) or (Edit9.text = '*')) and
          ((Date2Long(Edit13.text) = MonDaRec.ausfuehren_soll) or (Edit13.text = '*')) and
          ((pos(Edit6.text, MonDaRec.zaehlernummer_alt) > 0) or (Edit6.text = '*')) and
          ((pos(Edit10.text, MonDaRec.ProtokollInfo) > 0) or (Edit10.text = '*')) and
          ((pos(Edit12.text, MonDaRec.ABNummer) > 0) or (Edit12.text = '*')) and
          ((pos(Edit11.text, MonDaRec.Zaehler_Strasse) > 0) or (Edit11.text = '*')) and
          ((pos(Edit15.text, MonDaRec.Baustelle) > 0) or (Edit15.text = '*')) and true then
        begin
          WasGefunden := true;
          if not(FoundOne) then
          begin
            FoundOne := true;
            sDiagnose_Log.add(Header + ' [' + FName + ',' + long2date(FDate(FName)) + ',' +
              secondstostr(FSeconds(FName)) + ',' + inttostr(FSize(FName)) + ',' + 'MD5 ' +
              md5 + ']');
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
                sDiagnose_Log.add(Baustelle + ';' + zaehlernummer_alt + ';' + monteur + ';' +
                  inttostr(RID) + ';' + long2date(ausfuehren_soll) + ';' + BoolToStr(vormittags));

          end;
        end;
      end;
      Doppelte.sort;
      DoppelteAnz := 0;
      RemoveDuplicates(Doppelte, DoppelteAnz);
      if (DoppelteAnz > 0) then
        sDiagnose_Log.add(inttostr(DoppelteAnz) + ' doppelte!');

      Doppelte.free;
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
  sDiagnose_Log := TStringList.create;
  OrgaMonFile := TStringList.create;
  sTAN_Log := TStringList.create;
  sMeldung := TStringList.create;
  sLostProceed := TStringList.create;
  AllTRN := TStringList.create;

  sLostProceed.add('TAN');
  sTAN_Log.add('TAN;Moment;Geraet;Monteur;Baustelle;Version;Einstellungen');

  RID := strtointdef(Edit3.text, 0);
  dir(Edit2.text + ComboBox1.text + '.', AllTRN, false);
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

      GeraeteNummer := JonDaX.detectGeraeteNummer(Edit2.text + AllTRN[n]);
      if (GeraeteNummer = '') then
        continue;

      GeraetZIPFName := Edit2.text + AllTRN[n] + '\' + GeraeteNummer + cZIPExtension;
      GeraetZIPDatum := FDate(GeraetZIPFName);

      sMeldung.LoadFromFile(Edit2.text + AllTRN[n] + '\' + AllTRN[n] + '.txt');

      if not(FileExists(Edit2.text + AllTRN[n] + '\' + AllTRN[n] + '.dat')) then
        sLostProceed.add(AllTRN[n]);

      MoreInfo := AllTRN[n] + '\' + long2date(FDate(Edit2.text + AllTRN[n] + '\NEW.ZIP')) + ' ' +
        secondstostr(FSeconds(Edit2.text + AllTRN[n] + '\NEW.ZIP'));

      // Was kam vom Gerät
      if CheckBox6.Checked then
        CheckOut(Edit2.text + AllTRN[n] + '\MONDA.DAT', MoreInfo + ' MonDa-Gerät bisher');

      // Was bleibt auf dem Gerät?
      if CheckBox11.Checked then
        CheckOut(Edit2.text + AllTRN[n] + '\STAY.DAT', MoreInfo + ' verbleibt auf dem Gerät');

      if CheckBox16.Checked then
        CheckOut(Edit2.text + AllTRN[n] + '\LOST.DAT', MoreInfo + ' wurde zwangsentfernt!');

      // Was kommt von OrgaMon
      if CheckBox5.Checked then
      begin
        dir(Edit2.text + AllTRN[n] + '\???.DAT', OrgaMonFile, false);
        for m := 0 to pred(OrgaMonFile.count) do
          if OrgaMonFile[m][1] in ['0' .. '9'] then
            CheckOut(Edit2.text + AllTRN[n] + '\' + OrgaMonFile[m], MoreInfo + ' OrgaMon-Daten');
      end;

      // Was geht zum OrgaMon
      if CheckBox8.Checked then
        CheckOut(Edit2.text + AllTRN[n] + '\' + AllTRN[n] + cDATExtension,
          MoreInfo + ' Meldung an OrgaMon');

      // Was geht wieder auf das Gerät
      if CheckBox7.Checked then
        CheckOut(Edit2.text + AllTRN[n] + '\AUFTRAG.DAT', MoreInfo + ' MonDa-Gerät neu');

      // Was kam eigentlich über das Web
      // im Moment nur RID-Suche vorgesehen
      if CheckBox21.Checked then
      begin

        // Suche nach RIDs
        if (Edit3.text <> '*') then
          for m := 0 to pred(sMeldung.count) do
            if (pos(Edit3.text + ';', sMeldung[m]) = 1) then
              sDiagnose_Log.add('Meldung@' + AllTRN[n] + '=' + sMeldung[m]);

      end;

      repeat
        if CheckBox18.Checked then
          if not(WasGefunden) then
            break;

        sTAN_Log.add(AllTRN[n] + ';' + long2date(GeraetZIPDatum) + ' ' +
          secondstostr(FSeconds(GeraetZIPFName)) + ';' + GeraeteNummer + ';' + 'M' + ';' + 'B' + ';'
          + sMeldung.Values['VERSION'] + ';' + sMeldung.Values['OPTIONEN']);
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
    dir(Edit2.text + '0000\???.DAT', OrgaMonFile, false);
    for m := 0 to pred(OrgaMonFile.count) do
      if OrgaMonFile[m][1] in ['0' .. '9'] then
        CheckOut(Edit2.text + '0000\' + OrgaMonFile[m], OrgaMonFile[m] + ' OrgaMon-Daten');
  end;
  ProgressBar1.position := 0;
  sLostProceed.SaveToFile(MyProgramPath + 'Ohne-Proceed.txt');
  sDiagnose_Log.SaveToFile(MyProgramPath + 'Diagnose.txt');
  sTAN_Log.SaveToFile(MyProgramPath + 'TAN.Log.txt');

  EndHourGlass;

  openshell(MyProgramPath + 'Diagnose.txt');
  openshell(MyProgramPath + 'TAN.Log.txt');
  if sLostProceed.count > 1 then
    openshell(MyProgramPath + 'Ohne-Proceed.txt');

  sMeldung.free;
  AllTRN.free;
  sDiagnose_Log.free;
  OrgaMonFile.free;
  sTAN_Log.free;
  sLostProceed.free;
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
    outLog('            Baustelle            : ' + Baustelle);
    outLog('            ABNummer             : ' + ABNummer);
    outLog('            Monteur              : ' + monteur);
    outLog('            Art                  : ' + Art);
    outLog('            zaehlernummer_alt    : ' + zaehlernummer_alt);
    outLog('            Reglernummer_alt     : ' + Reglernummer_alt);
    outLog('            ausfuehren_soll      : ' + long2date(ausfuehren_soll));
    outLog('            vormittags           : ' + BoolToStr(vormittags));
    outLog('            Monteur_Info         : ' + Monteur_Info);
    outLog('            Zaehler_Info         : ' + Zaehler_Info);
    outLog('            Zaehler_Name1        : ' + Zaehler_Name1);
    outLog('            Zaehler_Name2        : ' + Zaehler_Name2);
    outLog('            Zaehler_Strasse      : ' + Zaehler_Strasse);
    outLog('            Zaehler_Ort          : ' + Zaehler_Ort);
    outLog('            zaehlernummer_korr   : ' + zaehlernummer_korr);
    outLog('            zaehlernummer_neu    : ' + zaehlernummer_neu);
    outLog('            zaehlerstand_neu     : ' + zaehlerstand_neu);
    outLog('            zaehlerstand_alt     : ' + zaehlerstand_alt);
    outLog('            Reglernummer_korr    : ' + Reglernummer_korr);
    outLog('            Reglernummer_neu     : ' + Reglernummer_neu);
    outLog('            ProtokollInfo        : ' + ProtokollInfo);
    outLog('            ausfuehren_ist_datum : ' + TJonDaExec.AusfuehrenStr(ausfuehren_ist_datum));
    outLog('            ausfuehren_ist_uhr   : ' + secondstostr(ausfuehren_ist_uhr));
  end;
end;

procedure TFormServiceApp.Button7Click(Sender: TObject);
begin
  ListBox1.items.add(Edit4.text + ',' + ComboBox2.text + ',' + Edit7.text);
end;

procedure TFormServiceApp.Edit19KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Edit19.text := RFC1738ToAnsi(Edit19.text);
    Key := #0;
  end;
end;

procedure TFormServiceApp.Edit2Exit(Sender: TObject);
begin
  Edit2.text := ValidatePathName(Edit2.text) + '\';
end;

procedure TFormServiceApp.Button8Click(Sender: TObject);
begin
  openshell(Edit2.text + ComboBox1.text + '\restanten.txt');
end;

procedure TFormServiceApp.Button9Click(Sender: TObject);
var
  sResult, sParameter: TStringList;
begin
  sParameter := TStringList.create;
  MyProgramPath := Edit14.text;
  sParameter.Values['TAN'] := Edit1.text;
  sResult := JonDaX.proceed(sParameter);
  sResult.free;
  sParameter.free;
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
    sl := TStringList.create;
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
  TheX := TStringList.create;
  Doit(Edit17.text);
  Doit(Edit16.text);
  TheX.sort;
  RemoveDuplicates(TheX);
  TheX.SaveToFile(MyProgramPath + 'Diagnose.txt');
  TheX.free;
  openshell(MyProgramPath + 'Diagnose.txt');
end;

function TFormServiceApp.iXMLRPCHost: string;
begin
  result := ComputerName;
end;

function TFormServiceApp.iXMLRPCPort: string;
begin
  result := '3049';
end;

procedure TFormServiceApp.SpeedButton2Click(Sender: TObject);
begin
  openshell(MyProgramPath + cGeraeteEinstellungen);
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
  GeraeteID := Edit22.text;
  StartTime := 0;

  sAlt := TStringList.create;
  sNeu := TStringList.create;
  AllTRN := TStringList.create;

  // Vorlauf
  AllTRN := TStringList.create;
  dir(MyProgramPath + '?????.', AllTRN, false);
  AllTRN.sort;

  sAltFName := MyProgramPath + cStatistikPath + 'Eingabe.' + GeraeteID + '.txt';
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
              Memo1.lines.add(cERRORText + ' 748:' + E.Message);
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
          nextp(JonDaX.toBild(mderec), ';', 5)); // 5

      end;

    end;
  end;

  //
  sNeu.SaveToFile(MyProgramPath + cStatistikPath + 'Eingabe.' + GeraeteID + '-Neu.txt');

  sAlt.free;
  sNeu.free;
  AllTRN.free;
  ProgressBar1.position := 0;

end;

procedure TFormServiceApp.Button12Click(Sender: TObject);
begin
  ShowMessage
    ('nichtmehr imple,mentiert: VErwenden Sie eine FTP-CLient um Ergebnis-TANS hochzuladen!');
end;

procedure TFormServiceApp.Button13Click(Sender: TObject);
begin
  STOP := true;
end;

//

procedure TFormServiceApp.Button14Click(Sender: TObject);
begin
  Nachmeldungen;
  ShowMessage(inttostr(CareTakerLog('Hallo')));
end;

procedure TFormServiceApp.Button15Click(Sender: TObject);
var
  AllNames: TStringList;
  n: integer;
begin
  AllNames := TStringList.create;
  pem_fullList(Edit2.text + cUpdatePath + Edit18.text, AllNames);
  AllNames.SaveToFile(MyProgramPath + 'AlleNamen.txt');
  for n := pred(AllNames.count) downto 0 do
    if pos('//', AllNames[n]) > 0 then
      AllNames.Delete(n);
  clipboard.AsText := HugeSingleLine(AllNames, ';');
  AllNames.free;
  openshell(MyProgramPath + 'AlleNamen.txt');
end;

procedure TFormServiceApp.Button16Click(Sender: TObject);
var
  SourceFName, DestFNAme: string;
begin
  SourceFName := JonDaX.ProtokollPath(cVersion_JonDa) + Edit23.text;
  DestFNAme := MyProgramPath + cProtPrefix + cProtExtension;
  JonDaX.migrateProtokoll(SourceFName, DestFNAme);
  openshell(DestFNAme);
end;

procedure TFormServiceApp.Button17Click(Sender: TObject);
const
  cFixedTAN_FName = '50000.DAT';
var
  lAbgearbeitet: TgpIntegerList;
  lMeldungen: TStringList;
  i: integer;
  mRID: integer;
  mderec: TMdeRec;
  OneJLine: string;
  JProtokoll: string;
  OrgaMonErgebnis: file of TMdeRec; // Das sind Ergebnisse von MonDa
  MyProgramPath: string;
  sOrgaMonFName: string;
  dTimeOut: TANFiXDate;
  dMeldung: TANFiXDate;
  Stat_Meldungen: integer;
  lFehlEingaben: TStringList;
  GeraeteNo: string;
  MeldungsMoment: string;
  iFTP: TIdFTP;
begin
  iFTP := TIdFTP.create(self);
  with iFTP do
  begin
    Host := iJonDa_FTPHost;
    UserName := iJonDa_FTPUserName;
    Password := iJonDa_FTPPassword;
    passive := true;

  end;

  Memo1.lines.add('melde TAN 50000 ... ');

  MyProgramPath := 'W:\JonDaServer\';

  lAbgearbeitet := TgpIntegerList.create;
  lMeldungen := TStringList.create;
  lFehlEingaben := TStringList.create;
  fillchar(mderec, sizeof(mderec), 0);
  Stat_Meldungen := 0;
  try
    JonDaX.BeginAction('50000:000');

    dTimeOut := DatePlus(DateGet, -8);
    sOrgaMonFName := MyProgramPath + cOrgaMonDataPath + cFixedTAN_FName;
    assignFile(OrgaMonErgebnis, sOrgaMonFName);
    rewrite(OrgaMonErgebnis);

    // Lade die fertigen!
    lAbgearbeitet.LoadFromFile(MyProgramPath + cServerDataPath + 'abgearbeitet.dat');

    // Lade alle Meldungen!
    lMeldungen.LoadFromFile(MyProgramPath + 'XXX.txt');
    for i := pred(lMeldungen.count) downto 0 do
    begin
      mRID := strtointdef(nextp(lMeldungen[i], ';', 0), 0);
      if (mRID > 0) then
      begin
        if (lAbgearbeitet.IndexOf(mRID) = -1) then
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
            ProtokollInfo := JProtokoll;
            ausfuehren_ist_datum := strtointdef(nextp(OneJLine, ';'), 0);
            ausfuehren_ist_uhr := strtointdef(nextp(OneJLine, ';'), 0);
            MeldungsMoment := nextp(OneJLine, ';');
            GeraeteNo := nextp(OneJLine, ';');
            dMeldung := Date2Long(nextp(MeldungsMoment, ' - ', 0));

          end;

          write(OrgaMonErgebnis, mderec);
          inc(Stat_Meldungen);

        end;
      end;
    end;
    CloseFile(OrgaMonErgebnis);

    with iFTP do
    begin
      //
      if not(connected) then
        connect;
      if (FSize(sOrgaMonFName) > 0) then
        JonDaX.sput(sOrgaMonFName, cFixedTAN_FName, iFTP)
      else
        JonDaX.log('Unterlassener Upload aufgrund Ergebnislosigkeit bei TRN ' + cFixedTAN_FName);
      Disconnect;
    end;

    JonDaX.log('->OrgaMon     : ' + inttostr(Stat_Meldungen));
    JonDaX.EndAction;
  except
  end;
  lAbgearbeitet.free;
  lMeldungen.free;
  lFehlEingaben.SaveToFile(MyProgramPath + 'DiagnoseHTNT.txt');
  lFehlEingaben.free;
  iFTP.free;

  Memo1.lines[pred(Memo1.lines.count)] := Memo1.lines[pred(Memo1.lines.count)] + '(' +
    inttostr(Stat_Meldungen) + 'x) ' + 'OK';

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
  sDirs := TStringList.create;
  sZips := TStringList.create;
  sPics := TStringList.create;
  sFotos := TStringList.create;

  tBAUSTELLE := TsTable.create;
  tBAUSTELLE.insertFromFile(MyProgramPath + cFotoPath + cMonDaServer_Baustelle);
  Col_FTP_Benutzer := tBAUSTELLE.colOf(cE_FTPUSER);

  //
  WARTEND := TsTable.create;
  WARTEND.insertFromFile(MyProgramPath + cFotoPath + cFotoUmbenennungAusstehend);

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
          mIni := TIniFile.create(sPath + 'Fotos-nnnn.ini');
          with mIni do
          begin
            FotosSequence := strtoint(ReadString('System', 'Sequence', '-1'));
            if FotosSequence < 0 then
            begin
              dir(sPath + 'Fotos-????.zip', sFotos, false);
              if sFotos.count > 0 then
              begin
                sFotos.sort;
                FotosSequence := strtointdef(ExtractSegmentBetween(sFotos[pred(sFotos.count)],
                  'Fotos-', '.zip'), -1);
              end;
            end;

            if FotosSequence < 0 then
              FotosSequence := 0;

            inc(FotosSequence);
            WriteString('System', 'Sequence', inttostr(FotosSequence));
          end;
          mIni.free;

          // Archivieren
          if (zip(
            { } sPics,
            { } sPath +
            { } 'Fotos-' + inttostrN(FotosSequence, 4) + '.zip',
            { } infozip_RootPath + '=' + sPath + ';' +
            { } infozip_Password + '=' +
            { } deCrypt_Hex(
            { } tBAUSTELLE.readCell(r, cE_ZIPPASSWORD)) + ';' +
            { } infozip_Level + '=' + '0') = sPics.count) then
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
  sDirs.free;
  sZips.free;
  sPics.free;
  sFotos.free;
  tBAUSTELLE.free;
  WARTEND.free;
  ProgressBar1.position := 0;
  EndHourGlass;

end;

procedure TFormServiceApp.Button19Click(Sender: TObject);

  procedure Migrate(FName: string);
  var
    bla: TBLAGER;
    mderec: TMdeRec;
  begin
    bla := TBLAGER.create;
    bla.Init(FName, mderec, sizeof(TMdeRec));
    bla.Clone(now);
    bla.free;
  end;

begin
  Migrate(MyProgramPath + cServerDataPath + 'FOTO');
  Migrate(MyProgramPath + cServerDataPath + 'AUFTRAG');
end;

procedure TFormServiceApp.Button20Click(Sender: TObject);

  procedure toText(FName: string);
  var
    bla: TBLAGER;
    mderec: TMdeRec;
    s: TStringList;
  begin
    s := TStringList.create;
    bla := TBLAGER.create;
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
              { } mderec.Zaehler_Info]));
          next;
        end;
      except
        on E: Exception do
          ShowMessage(format('RID%d [%d] %.2f %s:' + #13 + '%s', [
            { } RecordIndex,
            { } RecordSize,
            { } RecordTimeStamp,
            { } mderec.Zaehler_Info,
            { } E.Message]));
      end;
      EndTransaction;
    end;
    bla.free;
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

procedure TFormServiceApp.Button22Click(Sender: TObject);
var
  iFTP: TIdFTP;
begin
  BeginHourGlass;
  iFTP := TIdFTP.create(nil);
  SolidInit(iFTP);
  with iFTP do
  begin
    Host := iJonDa_FTPHost;
    UserName := iJonDa_FTPUserName;
    Password := iJonDa_FTPPassword;
  end;

  try
    SolidGet(iFTP, '', cMonDaServer_Baustelle, MyProgramPath + cFotoPath);
    validateBaustelleCSV(MyProgramPath + cFotoPath + cMonDaServer_Baustelle);
    iFTP.Disconnect;
  except

  end;
  iFTP.free;
  EndHourGlass;
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
    JonDaX.tIMEI.insertFromFile(MyProgramPath + cDBPath + 'IMEI.csv');

    // lade IMEI-OK
    JonDaX.tIMEI_OK.insertFromFile(MyProgramPath + cDBPath + 'IMEI-OK.csv');
  end;

  with JonDaX.tIMEI_OK do
  begin
    if (locate('IMEI', Edit24.text) = -1) then
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
 n, k : integer;
 v : TgpIntegerList;
begin
 listbox2.clear;
 n := StrToInt(edit25.Text);
 k := StrToInt(edit26.Text);
 v := TgpIntegerList.create;
 while (nk(n,k,v)) do
   listbox2.items.add('('+v.AsDelimitedText(',')+')');
 v.free;
end;

procedure TFormServiceApp.Button1Click(Sender: TObject);
var
  iFTP: TIdFTP;
begin
  BeginHourGlass;
  iFTP := TIdFTP.create(self);
  with iFTP do
  begin
    Host := iJonDa_FTPHost;
    UserName := iJonDa_FTPUserName;
    Password := iJonDa_FTPPassword;
    passive := true;
  end;
  MyProgramPath := 'W:\JonDaServer\';
  JonDaX.doStat(iFTP);
  iFTP.free;
  EndHourGlass;
end;

end.
