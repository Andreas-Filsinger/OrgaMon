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
unit PersonMailer;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  Grids, IB_Grid, IB_Components, IB_Access,
  StdCtrls,
  Buttons, ExtCtrls, IB_Controls,
  IB_UpdateBar, JvGIF,
  ComCtrls, Datenbank,

  gplists,

  // SMTP
  IdEMAILAddress,
  IdContext,
  IdBaseComponent,
  IdComponent,
  IdMessageClient,
  IdText,
  IdSMTP,
  IdMessage,
  IdSMTPBase,
  IdGlobal,

  // SSL / TLS
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL, IdSASLLogin,
  IdSASL_CRAM_SHA1, IdSASL, IdSASLUserPass,
  IdSASL_CRAMBase, IdSASL_CRAM_MD5, IdSASLSKey,
  IdSASLPlain, IdSASLOTP, IdSASLExternal,
  IdSASLDigest, IdSASLAnonymous, IdUserPassProvider,
  IdSSLOpenSSLHeaders;

type
  TFormPersonMailer = class(TForm)
    Label1: TLabel;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    SpeedButton4: TSpeedButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    IB_UpdateBar1: TIB_UpdateBar;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    Image2: TImage;
    ProgressBar1: TProgressBar;
    Label2: TLabel;
    Button8: TButton;
    Timer1: TTimer;
    CheckBox1: TCheckBox;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Button6: TButton;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    IB_Memo1: TIB_Memo;
    Memo1: TMemo;
    Button1: TButton;
    Edit1: TEdit;
    CheckBox2: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox3: TCheckBox;
    SpeedButton5: TSpeedButton;
    Edit3: TEdit;
    CheckBox5: TCheckBox;
    SpeedButton6: TSpeedButton;
    TabSheet4: TTabSheet;
    Label3: TLabel;
    Edit4: TEdit;
    Label4: TLabel;
    Edit5: TEdit;
    CheckBox6: TCheckBox;
    Edit2: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    SpeedButton7: TSpeedButton;

    procedure Timer1Timer(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);

  private

    { Private-Deklarationen }
    eMailStartTime: dword;
    PersonMailer_Break: boolean;
    PersonMailer_Active: integer;
    FirstTimerEventChecked: boolean;

    Blocklist_sl: TStringList;
    Blocklist_Age: integer;
    Blocklist_Active: boolean;
    Vorlagen: boolean;

    procedure IdSMTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure IdSMTP1Work(Sender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);

    function MakeSendList: TgpIntegerList;
    function LastSQL: string;
    procedure Log(sLog: string; EMAIL_R: Integer);
  public

    { Public-Deklarationen }
    procedure SendeEmail(EMAIL_R: integer);
    procedure SetSenden(EMAIL_R: integer; ClearIt: boolean = false);
    procedure Replace(EMAIL_R: integer; sText: TStrings; Attachments: TStrings);
    procedure produceMailFromEREIGNIS;

  end;

var
  FormPersonMailer: TFormPersonMailer;

implementation

uses
  anfix32, globals, html,
  dcpcrypt2, dcpmd5,
  WordIndex, txlib,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Artikel,
  Funktionen_Auftrag,
  Person, Belege,
  CareTakerClient, IdAttachmentFile,
  dbOrgaMon, IdAssignedNumbers, wanfix32,
  AuftragArbeitsplatz, main;

{$R *.dfm}

procedure IndyFromEML(emlFName, IndyFName: string);
var
  sEML: TStringList;
  n: integer;
begin
  sEML := TStringList.create;
  sEML.LoadFromFile(emlFName);
  for n := 0 to pred(sEML.count) do
    if (pos('.', sEML[n]) = 1) then
      sEML[n] := '=2E' + copy(sEML[n], 2, MaxInt);
  sEML.SaveToFile(IndyFName);
  sEML.free;
end;

procedure TFormPersonMailer.Button1Click(Sender: TObject);
var
  EMAIL_R: integer;
  qMAIL: TIB_Query;
  eMessage: TStringList;
begin
  BeginHourGlass;
  eMessage := TStringList.create;
  qMAIL := DataModuleDatenbank.nQuery;
  try

    // Eigenen ID dieser Mail bestimmen
    EMAIL_R := e_w_gen('GEN_EMAIL');

    // eMail Antrag in die Datenbank stellen!
    e_x_sql('insert into EMAIL (RID) values (' + inttostr(EMAIL_R) + ');');

    // Nachrichten Text dieser eMail zusammenbauen
    // multipart/related
    if CheckBox5.checked then
    begin
      // kein eigener Body!
    end
    else
    begin
      with eMessage do
      begin
        add('OrgaMon eMail - Test');
        add('Hallo zusammen,');
        add('');
        add('dies ist eine Testmail die vom OrgaMon automatisch generiert wurde!');
        add(Datum + ' ' + Uhr);
      end;
    end;

    // Den Nachrichten Text jetzt speichern
    with qMAIL do
    begin
      sql.add('select DATEI_ANLAGE,NACHRICHT,EMPFAENGER from EMAIL where RID=' + inttostr(EMAIL_R) + ' for update');
      Open;
      first;
      edit;
      FieldByName('EMPFAENGER').AsString := Edit1.text;
      if (eMessage.count > 0) then
        FieldByName('NACHRICHT').Assign(eMessage);
      if CheckBox3.checked then
        FieldByName('DATEI_ANLAGE').AsString := MyProgramPath + 'system\StartUp.bmp';
      if CheckBox5.checked then
        FieldByName('DATEI_ANLAGE').AsString := Edit3.text;

      post;
      close;
    end;

    // Jetzt wirklich senden
    SendeEmail(EMAIL_R);

  except
    //
  end;
  eMessage.free;
  qMAIL.free;
  EndHourGlass;
end;

procedure TFormPersonMailer.SpeedButton4Click(Sender: TObject);
var
  ActionDone: boolean;
begin
  ActionDone := false;
  if IB_Query1.Active then
    if IB_Query1.FieldByName('GESENDET').IsNotNull then
    begin
      SetSenden(IB_Query1.FieldByName('RID').AsInteger, true);
      IB_Query1.Refresh;
      ActionDone := true;
    end
    else
    begin
      SetSenden(IB_Query1.FieldByName('RID').AsInteger);
      IB_Query1.Refresh;
      ActionDone := true;
    end;
  if not(ActionDone) then
    beep
  else
    IB_Query1.Next;
end;

procedure TFormPersonMailer.SpeedButton5Click(Sender: TObject);
begin
  e_x_sql(
   { } 'update EMAIL set AUSGANG=null, ' +
   { } 'VERSUCHE=null where (VERSUCHE>2) and (RID>' +
   { } IB_Query1.FieldByName('RID').AsString + ')');
end;

procedure TFormPersonMailer.SpeedButton6Click(Sender: TObject);
begin
  FileAlive(SearchDir + 'Blocklist.txt');
  openShell(SearchDir + 'Blocklist.txt');
end;

procedure TFormPersonMailer.SpeedButton7Click(Sender: TObject);
var
  sNachricht: TStringList;
  sCSV: TStable;
  n, r: integer;
  FName: string;
begin
  sNachricht := TStringList.create;
  sCSV := TStable.create;
  IB_Query1.FieldByName('NACHRICHT').AssignTo(sNachricht);
  for n := 0 to pred(sNachricht.count) do
    if (pos(ceMail_Anlage, sNachricht[n]) = 1) then
    begin
      FName := nextp(sNachricht[n], ceMail_Anlage, 1);
      ersetze('.html', '.csv', FName);
      sCSV.Clear;
      sCSV.insertFromFile(FName);
      for r := 1 to sCSV.RowCount do
        FormAuftragArbeitsplatz.AddMarkierte(StrToIntDef(sCSV.readCell(r, cRID_Suchspalte), cRID_Null));
    end;
  sCSV.free;
  sNachricht.free;
end;

procedure TFormPersonMailer.Timer1Timer(Sender: TObject);

var
  EMAIL_R: TgpIntegerList;
  n: integer;
  StartDate: TANFiXDate;
  StartTime: TANFiXTime;
begin

  if NoTimer then
    exit;

  if not(AllSystemsRunning) then
    exit;

  if not(FirstTimerEventChecked) then
  begin
    FirstTimerEventChecked := true;

    repeat

      if pDisableMailer then
      begin
        Timer1.enabled := false;
        CheckBox1.caption := '"-dm" -> kein Servermodus';
        exit;
      end;

      if (AnsiUpperCase(ComputerName) <> AnsiUpperCase(iMailHost)) then
      begin
        Timer1.enabled := false;
        CheckBox1.caption := iMailHost + ' ist Server';
        exit;
      end;

    until true;
    CheckBox1.checked := true;
    CheckBox1.caption := 'Ich bin Server';
    FormMain.Panel1.Color := cllime;

  end;

  Log('Timer (' + inttostr(PersonMailer_Active) + ')',cRID_unset);

  if (PersonMailer_Active = 0) and (CheckBox1.checked) then
  begin
    inc(PersonMailer_Active);

    try
      // prüfen, ob aus Ereignissen,
      // Mails produziert werden können.
      // Das macht NUR der eMail Versender
      if (AnsiUpperCase(ComputerName) = AnsiUpperCase(iMailHost)) then
        produceMailFromEREIGNIS;

      // alle eMail senden, die für diesen Server anstehen
      EMAIL_R := MakeSendList;
      if (EMAIL_R.count > 0) then
      begin
        StartDate := DateGet;
        StartTime := SecondsGet;

        EMAIL_R.sort;
        if (EMAIL_R.count > 2) then
          EMAIL_R.Exchange(0, EMAIL_R.count - 2);

        for n := pred(EMAIL_R.count) downto 0 do
        begin
          SendeEmail(EMAIL_R[n]);

          if NoTimer then
          begin
            Log('INFO: Down Break!',cRID_unset);
            break;
          end;

          if not(CheckBox1.checked) then
          begin
            Log('INFO: Service Break!',cRID_unset);
            break;
          end;

          // nicht mehr als 3 Minuten ununterbrochen an einer Liste mailen
          if (SecondsDiff(DateGet, SecondsGet, StartDate, StartTime) > 3 * 60) then
          begin
            Log('INFO: Timelimit Break!',cRID_unset);
            break;
          end;

        end;
      end
      else
      begin
        Log('Idle',cRID_unset);
      end;
      EMAIL_R.free;

    except
      //
      on E: Exception do
        Log(cERRORText + ' PersonMailer.Timer: ' + E.Message,cRID_unset);
    end;
    dec(PersonMailer_Active);

  end;

end;

procedure TFormPersonMailer.FormActivate(Sender: TObject);
begin
  if not(IB_Query1.Active) then
    IB_Query1.Open;
end;

procedure TFormPersonMailer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  IB_Query1.close;
end;

procedure TFormPersonMailer.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet1;
end;

procedure TFormPersonMailer.SpeedButton1Click(Sender: TObject);
var
  ImportL: TStringList;
  n: integer;
  VORLAGE_R: integer;
  AUSGANG: string;
begin
  with IB_Query1 do
  begin
    VORLAGE_R := FieldByName('RID').AsInteger;
    AUSGANG := FieldByName('AUSGANG').AsString;
  end;
  if (AUSGANG = '') then
    AUSGANG := 'null'
  else
    AUSGANG := '''' + AUSGANG + '''';

  OpenDialog1.InitialDir := iOlapPath;
  if OpenDialog1.execute then
  begin
    BeginHourGlass;
    ImportL := TStringList.create;
    ImportL.LoadFromFile(OpenDialog1.FileName);
    for n := 1 to pred(ImportL.count) do
    begin
      e_x_sql('insert into EMAIL (RID,PERSON_R,VORLAGE_R,AUSGANG) values (' +
        { RID } '0' + ',' +
        { PERSON_R } nextp(ImportL[n], ';', 0) + ',' +
        { VORLAGE_R } inttostr(VORLAGE_R) + ',' +
        { DATUM } AUSGANG + ')');
    end;
    IB_Query1.Refresh;
    ImportL.free;
    EndHourGlass;
  end;
end;

procedure TFormPersonMailer.SpeedButton2Click(Sender: TObject);
begin
  SendeEmail(IB_Query1.FieldByName('RID').AsInteger);
  IB_Query1.Refresh;
end;

procedure TFormPersonMailer.SpeedButton3Click(Sender: TObject);
var
  EMAIL_R: TgpIntegerList;
  n: integer;
begin
  BeginHourGlass;
  EMAIL_R := MakeSendList;
  EndHourGlass;

  if doit('Sollen wirklich ' + inttostr(EMAIL_R.count) + ' eMails versendet werden') then
  begin

    BeginHourGlass;
    for n := 0 to pred(EMAIL_R.count) do
      SendeEmail(EMAIL_R[n]);
    EndHourGlass;

    IB_Query1.Refresh;
  end;

  EMAIL_R.free;

end;

procedure TFormPersonMailer.SendeEmail(EMAIL_R: integer);

  function VersandFilter(s: string): string;
  const
    cMailDelimiter = ';';
  var
    sAddresses: TStringList;
    AddressOK: boolean;
    n: integer;
  begin
    result := AnsiLowerCase(noblank(s));
    if (result <> '') then
    begin
      sAddresses := Split(result, cMailDelimiter);
      for n := pred(sAddresses.count) downto 0 do
      begin

        AddressOK := true;
        repeat

          if not(eMailAdresseOK(sAddresses[n])) then
          begin
            AddressOK := false;
            break;
          end;

          if not(Blocklist_Active) then
            break;

          if (Blocklist_sl.indexof(sAddresses[n]) <> -1) then
          begin
            AddressOK := false;
            break;
          end;

          if (Blocklist_sl.indexof('*@' + nextp(sAddresses[n], '@', 1)) <> -1) then
          begin
            AddressOK := false;
            break;
          end;

        until true;

        if not(AddressOK) then
        begin
          AppendStringsToFile(
            { ERROR } cERRORText +
            { RID } ' (RID=' + inttostr(EMAIL_R) + ') ' +
            { STAMP } DatumUhr + ' ' +
            { Cause } '"' + sAddresses[n] + '" just '+cMail_Blocked,
            { FName } DiagnosePath + 'Blocklist'+ cLogExtension);
          sAddresses.delete(n);
        end;

      end;

      result := HugeSingleLine(sAddresses, cMailDelimiter);
      sAddresses.free;
    end;
  end;

var
  SenderSettings: TStringList;
  USER_DIENSTE: TStringList;
  qEMAIL: TIB_Query;
  cVORLAGE_EMAIL, cDUBLETTE_EMAIL: TIB_Cursor;
  SENDER_R: integer;
  ZIEL_R: integer;
  ARTIKEL_R: integer;
  n: integer;
  VersucheBisher: integer;
  _WaitTime: string;
  ResultInfo: string;
  sUMFANG: TMemoryStream;

  // Caching
  DATEI_ANLAGE: string;
  BEGINN: TDateTime;
  UMFANG: Int64;
  sPORT: string;

  // Indy
  eMailContent: TIdMessage;
  IndyMessageFName: string;
  sAttachments: TStringList;
  sTextInhalt: TStringList;
  InfoVomAdmin: string;
  SMTP: TIdSMTP;

  Versand_An: string;
  Versand_CC: string;
  Versand_Bcc: string;

  procedure addSecurity;
  var
    SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
    IdUserPassProvider: TIdUserPassProvider;
    IdSASLCRAMMD5: TIdSASLCRAMMD5;
    IdSASLCRAMSHA1: TIdSASLCRAMSHA1;
    IdSASLPlain: TIdSASLPlain;
    IdSASLLogin: TIdSASLLogin;
    IdSASLSKey: TIdSASLSKey;
    IdSASLOTP: TIdSASLOTP;
    IdSASLAnonymous: TIdSASLAnonymous;
    IdSASLExternal: TIdSASLExternal;
  begin

    // SSL Handler
    SSLHandler := TIdSSLIOHandlerSocketOpenSSL.create(SMTP);
    // SSL/TLS handshake determines the highest available SSL/TLS version dynamically
    SSLHandler.SSLOptions.Method := DEF_SSLVERSION;
    SSLHandler.SSLOptions.Mode := sslmClient;
    SSLHandler.SSLOptions.VerifyMode := [];
    SSLHandler.SSLOptions.VerifyDepth := 0;
    SMTP.IOHandler := SSLHandler;

    case SMTP.Port of
      25:
        ;
      587:
        SMTP.UseTLS := utUseExplicitTLS;
    else
      SMTP.UseTLS := utUseImplicitTLS;
    end;

    // Passwort
    // SMTP.AuthType := satSASL;
    SMTP.AuthType := DEF_SMTP_AUTH;
    IdUserPassProvider := TIdUserPassProvider.create(SMTP);
    IdUserPassProvider.Username := SMTP.Username;
    IdUserPassProvider.Password := SMTP.Password;

    IdSASLCRAMSHA1 := TIdSASLCRAMSHA1.create(SMTP);
    IdSASLCRAMSHA1.UserPassProvider := IdUserPassProvider;
    IdSASLCRAMMD5 := TIdSASLCRAMMD5.create(SMTP);
    IdSASLCRAMMD5.UserPassProvider := IdUserPassProvider;
    IdSASLSKey := TIdSASLSKey.create(SMTP);
    IdSASLSKey.UserPassProvider := IdUserPassProvider;
    IdSASLOTP := TIdSASLOTP.create(SMTP);
    IdSASLOTP.UserPassProvider := IdUserPassProvider;
    IdSASLAnonymous := TIdSASLAnonymous.create(SMTP);
    IdSASLExternal := TIdSASLExternal.create(SMTP);
    IdSASLLogin := TIdSASLLogin.create(SMTP);
    IdSASLLogin.UserPassProvider := IdUserPassProvider;
    IdSASLPlain := TIdSASLPlain.create(SMTP);
    IdSASLPlain.UserPassProvider := IdUserPassProvider;

    SMTP.SASLMechanisms.add.SASL := IdSASLCRAMSHA1;
    SMTP.SASLMechanisms.add.SASL := IdSASLCRAMMD5;
    SMTP.SASLMechanisms.add.SASL := IdSASLSKey;
    SMTP.SASLMechanisms.add.SASL := IdSASLOTP;
    SMTP.SASLMechanisms.add.SASL := IdSASLAnonymous;
    SMTP.SASLMechanisms.add.SASL := IdSASLExternal;
    SMTP.SASLMechanisms.add.SASL := IdSASLLogin;
    SMTP.SASLMechanisms.add.SASL := IdSASLPlain;

    SMTP.ConnectTimeout := 30000;
  end;

begin
  inc(PersonMailer_Active);

  // Eine einzelne Mail wird gesendet
  BeginHourGlass;
  eMailStartTime := 0;
  ProgressBar1.max := 0;
  UMFANG := 0;
  ResultInfo := inttostr(EMAIL_R) + ': ';
  Log('Sende ' + inttostr(EMAIL_R) + ' ...',EMAIL_R);
  qEMAIL := DataModuleDatenbank.nQuery;
  cVORLAGE_EMAIL := DataModuleDatenbank.nCursor;
  cDUBLETTE_EMAIL := DataModuleDatenbank.nCursor;
  USER_DIENSTE := TStringList.create;
  sAttachments := TStringList.create;
  eMailContent := TIdMessage.create(self);
  sTextInhalt := TStringList.create;
  SenderSettings := niL;
  sPORT := '';
  SMTP := TIdSMTP.create(self);
  Versand_An := '';
  Versand_CC := '';
  Versand_Bcc := '';
  Blocklist_Active := false;
  InfoVomAdmin := '';

  try

    // Blocklist reload?
    if assigned(Blocklist_sl) then
      if (Blocklist_Age <> FileAge(SearchDir + 'Blocklist.txt')) then
      begin
        Blocklist_sl.free;
        Blocklist_sl := nil;
      end;

    // Blocklist load
    if (Blocklist_sl = nil) then
    begin
      Blocklist_sl := TStringList.create;
      FileAlive(SearchDir + 'Blocklist.txt');
      Blocklist_sl.LoadFromFile(SearchDir + 'Blocklist.txt');

      for n := 0 to pred(Blocklist_sl.count) do
        Blocklist_sl[n] := AnsiLowerCase(noblank(Blocklist_sl[n]));
      Blocklist_sl.sort;
      RemoveDuplicates(Blocklist_sl);

      Blocklist_sl.SaveToFile(SearchDir + 'Blocklist.txt');
      Blocklist_Age := FileAge(SearchDir + 'Blocklist.txt');
    end;

    try
      with qEMAIL do
      begin

        // SQL eintragen
        sql.add('select * from EMAIL where RID=' + inttostr(EMAIL_R) + ' for update');
        Open;
        first;

        // Vorlage laden
        if FieldByName('VORLAGE_R').IsNotNull then
          with cVORLAGE_EMAIL do
          begin
            sql.add('select * from EMAIL where RID=' + qEMAIL.FieldByName('VORLAGE_R').AsString);
            ApiFirst;
          end;

        // Ziel Person
        if FieldByName('PERSON_R').IsNotNull then
          ZIEL_R := FieldByName('PERSON_R').AsInteger
        else
          ZIEL_R := cRID_Null;

        // Artikel, um den es geht
        ARTIKEL_R := FieldByName('ARTIKEL_R').AsInteger;

        // Eigene Identität
        SenderSettings := e_r_BearbeiterEinstellungen(sBearbeiter);
        sPORT := SenderSettings.values['Port'];

        // Versende-Identität, Einstellungen laden
        SENDER_R := sBearbeiter;
        repeat

          if FieldByName('SENDER_R').IsNotNull then
          begin
            SENDER_R := FieldByName('SENDER_R').AsInteger;
            break;
          end;

          if cVORLAGE_EMAIL.Active then
            if cVORLAGE_EMAIL.FieldByName('SENDER_R').IsNotNull then
            begin
              SENDER_R := cVORLAGE_EMAIL.FieldByName('SENDER_R').AsInteger;
              break;
            end;

        until true;
        if (SENDER_R <> sBearbeiter) then
        begin
          SenderSettings.free;
          SenderSettings := e_r_BearbeiterEinstellungen(SENDER_R);
        end;

        // Prüfung der SENDER Settings
        if (cutblank(SenderSettings.values['Host']) = '') then
          raise Exception.create(inttostr(SENDER_R) + ' Host= fehlt!');
        if (cutblank(SenderSettings.values['Username']) = '') then
          raise Exception.create(inttostr(SENDER_R) + ' Username= fehlt!');
        if (cutblank(SenderSettings.values['Password']) = '') then
          raise Exception.create(inttostr(SENDER_R) + ' Password= fehlt!');
        if (cutblank(SenderSettings.values['Name']) = '') then
          raise Exception.create(inttostr(SENDER_R) + ' Name= fehlt!');
        if (cutblank(SenderSettings.values['Address']) = '') then
          raise Exception.create(inttostr(SENDER_R) + ' Address= fehlt!');

        with SMTP, eMailContent do
        begin
          OnWorkEnd := IdSMTP1WorkEnd;
          OnWork := IdSMTP1Work;

          // Eine Anlage mitsenden, falls vorhanden
          DATEI_ANLAGE := '';
          repeat

            // im 1. Rang: aus der Vorlage
            if cVORLAGE_EMAIL.Active then
              if cVORLAGE_EMAIL.FieldByName('DATEI_ANLAGE').IsNotNull then
              begin
                DATEI_ANLAGE := cVORLAGE_EMAIL.FieldByName('DATEI_ANLAGE').AsString;
                if (DATEI_ANLAGE <> '') then
                  break;
              end;

            // im 2. Rang: aus der eigenen Mail
            DATEI_ANLAGE := FieldByName('DATEI_ANLAGE').AsString;

          until true;

          if (DATEI_ANLAGE <> '') then
          begin
            // Ist die "Anlage" eine ".eml"-Datei, dann ist die eMail zu laden!
            if (pos('.eml', DATEI_ANLAGE) > 0) then
            begin
              Blocklist_Active := true;

              // Dateianlage in das Indy-Format konvertieren!
              IndyMessageFName := DATEI_ANLAGE;
              ersetze('.eml', '.Indy', IndyMessageFName);
              if (FileAge(DATEI_ANLAGE) > FileAge(IndyMessageFName)) then
                IndyFromEML(DATEI_ANLAGE, IndyMessageFName);

              LoadFromFile(IndyMessageFName);
            end
            else
            begin

              // Prüfe, on das Attachement heute bereits geliefert wurde
              with cDUBLETTE_EMAIL do
              begin
                sql.Clear;
                sql.add(
                  { } 'select GESENDET from EMAIL where' +
                  { } ' (GESENDET>CURRENT_TIMESTAMP-0.25) and ' +
                  { } ' (PERSON_R=' + inttostr(ZIEL_R) + ') and ' +
                  { } ' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') and ' +
                  { } ' (DATEI_ANLAGE=''' + DATEI_ANLAGE + ''') ' +
                  { } 'order by ' +
                  { } ' GESENDET descending');
                ApiFirst;
                if not(eof) then
                begin
                  InfoVomAdmin := 'Sie erhielten diese Datei bereits am ' + FieldByName('GESENDET').AsString +
                    ', der Anhang wurde entfernt!';
                  DATEI_ANLAGE := '';
                end;
                close;
              end;

              // Normales Datei-Attachement
              if (DATEI_ANLAGE <> '') then
                sAttachments.add(DATEI_ANLAGE);

            end;
          end;

          // eMail Header zusammen setzen!
          MsgId := '<' + inttostr(EMAIL_R) + '-' + inttostr(FieldByName('VERSUCHE').AsInteger) + '@' + iMandant +
            '.orgamon.org>';

          headers.values['Message-Id'] := MsgId;

          with SenderSettings do
          begin
            host := values['Host'];
            Username := values['Username'];
            Password := values['Password'];
            from.name := values['Name'];
            from.address := values['Address'];
            if (values['Reply'] <> '') then
              ReplyTo.EMailAddresses := values['Reply'];
            repeat

              // 1. Rang: Aus dem sBearbeiter
              if (sPORT <> '') then
              begin
                Port := StrToIntDef(sPORT, IdPORT_SMTP);
                break;
              end;

              // 2. Rang: Aus der angegebenen Versende-Identität
              if (values['Port'] <> '') then
              begin
                Port := StrToIntDef(values['Port'], IdPORT_SMTP);
                break;
              end;
            until true;
          end;

          // SSL, TLS Sicherheit hinzufügen
          if (Port = 465) or (Port = 587) then
            addSecurity;

          if CheckBox2.checked then
          begin
            // Nur an Testperson versenden!
            Versand_An := Edit1.text;
          end
          else
          begin

            // Empfänger ermitteln
            if (ZIEL_R < cRID_FirstValid) then
            begin

              // aus dem eigenen Empfänger Feld
              Versand_An := FieldByName('EMPFAENGER').AsString;

            end
            else
            begin

              // im 1. Rang: aus "EMail"
              Versand_An := noblank(e_r_sqls('select EMAIL from PERSON where RID=' + inttostr(ZIEL_R)));

              // im 2. Rang: aus "USER-ID"
              if (Versand_An = '') then
                Versand_An := noblank(e_r_sqls('select USER_ID from PERSON where RID=' + inttostr(ZIEL_R)));

              // die "cc=", "bcc=" Tabelle laden
              e_r_sql('select USER_DIENSTE from PERSON where RID=' + inttostr(ZIEL_R), USER_DIENSTE);
            end;

            // cc Empfänger hinzunehmen
            Versand_CC := '';
            for n := 0 to pred(USER_DIENSTE.count) do
              if (pos('cc=', USER_DIENSTE[n]) = 1) then
                if (Versand_CC = '') then
                  Versand_CC := nextp(USER_DIENSTE[n], 'cc=', 1)
                else
                  Versand_CC := Versand_CC + ';' + nextp(USER_DIENSTE[n], 'cc=', 1);

            // bcc Empfänger hinzunehmen
            if CheckBox4.checked then
              Versand_Bcc := Edit1.text
            else
              Versand_Bcc := '';
            for n := 0 to pred(USER_DIENSTE.count) do
              if (pos('bcc=', USER_DIENSTE[n]) = 1) then
                if (Versand_Bcc = '') then
                  Versand_Bcc := nextp(USER_DIENSTE[n], 'bcc=', 1)
                else
                  Versand_Bcc := Versand_Bcc + ';' + nextp(USER_DIENSTE[n], 'bcc=', 1);

          end;

          // die Nachricht als solches!
          if FieldByName('VORLAGE_R').IsNotNull then
          begin
            cVORLAGE_EMAIL.FieldByName('NACHRICHT').AssignTo(sTextInhalt);
          end
          else
          begin
            FieldByName('NACHRICHT').AssignTo(sTextInhalt);
          end;

          if (sTextInhalt.count > 0) then
          begin

            // ~Platzhalter~ durch echte Werte ersetzen
            Replace(EMAIL_R, sTextInhalt, sAttachments);

            // die Nachricht hat in der ersten Zeile den Betreff (OrgaMon-Regel)
            Subject := sTextInhalt[0];
            sTextInhalt.delete(0);

            //
          end;

          // Hinweis des Admins noch einbauen
          if (InfoVomAdmin <> '') then
          begin
            Log(InfoVomAdmin,EMAIL_R);
            sTextInhalt.insert(0, 'Wichtiger Hinweis: ' + InfoVomAdmin);
          end;

          // den Textinhalt der Mail aufbereiten
          if (sTextInhalt.count > 0) then
            with TIdText.create(MessageParts, sTextInhalt) do
            begin
              // Einstellungen für den reinen Text-Teil
              ContentType := 'text/plain';
              CharSet := 'ISO-8859-1';
              ContentTransfer := '8bit';
            end;

          // Attachements dazu!
          for n := 0 to pred(sAttachments.count) do
            TIdAttachmentFile.create(MessageParts, sAttachments[n]);

          // überhaupt ein Empfänger angegeben?
          Recipients.EMailAddresses := VersandFilter(Versand_An);
          CCList.EMailAddresses := VersandFilter(Versand_CC);
          BccList.EMailAddresses := VersandFilter(Versand_Bcc);

          if (Recipients.count > 0) then
          begin

            // Grösse der eMail "berechnen"
            // Im Moment sehe ich keine andere Möglichkeit als die Mail zu speichern!
            sUMFANG := TMemoryStream.create;
            SaveToStream(sUMFANG);
            UMFANG := sUMFANG.Size;
            sUMFANG.free;

            ProgressBar1.max := UMFANG;

            // Sicherstellen, dass Offline
            if connected then
              disconnect;

            // Einwählen ...
            connect;

            // Nach dem connect den Transferbeginn aufzeichnen
            BEGINN := e_r_now;

            // Versenden ...
            send(eMailContent);

            // verabschieden
            disconnect;
          end;

          // Erfolg verbuchen!
          edit;

          //
          if (Recipients.count > 0) then
          begin
            FieldByName('UID').AsString := MsgId;
          end
          else
          begin
            ResultInfo := ResultInfo + ' ' + cMail_Blocked;
            FieldByName('UID').AsString := cMail_Blocked;
          end;
          FieldByName('UMFANG').AsInt64 := UMFANG;
          if DateOK(DateTime2Long(BEGINN)) then
            FieldByName('BEGINN').AsDateTime := BEGINN;

          if FieldByName('EMPFAENGER').IsNull then
            FieldByName('EMPFAENGER').AsString := Recipients.EMailAddresses;
          if FieldByName('SENDER_R').IsNull then
            FieldByName('SENDER_R').AsInteger := SENDER_R;
          post;

          ResultInfo := ResultInfo + ' OK!';

        end;

        //
        close;
        SetSenden(EMAIL_R);

      end;
    except

      // Misserfolg verbuchen
      on E: Exception do
      begin
        ResultInfo := ResultInfo + cERRORText + ' ' + E.Message;
        Log(cERRORText + ' sendeeMail: ' + E.Message, EMAIL_R);

        // Anzahl der bisherigen Versuche prüfen
        VersucheBisher := e_r_sql('select VERSUCHE from EMAIL ' + ' where RID=' + inttostr(EMAIL_R));

        // entsprechende Wartezeiten einbauen
        case VersucheBisher of
          0:
            _WaitTime := '0.0013889'; // 2 Minuten
          1:
            _WaitTime := '0.0069444'; // 10 Minuten
          2:
            _WaitTime := '0.0416667'; // 1 Stunde
          3:
            _WaitTime := '1.0'; // 24 Stunden
        end;

        // Jetzt die Datenbank updaten!
        e_x_sql(
         {} 'update EMAIL set ' +
         {} ' VERSUCHE = COALESCE(VERSUCHE,0) + 1,' +
         {} ' AUSGANG = CURRENT_TIMESTAMP + ' + _WaitTime + ' ' +
         {} 'where RID=' + inttostr(EMAIL_R));

      end;

    end;
    // Hang UP!
    if SMTP.connected then
      SMTP.disconnect;
    Label2.caption := '#';
    Log(ResultInfo,EMAIL_R);
  except
    on E: Exception do
      Log(cERRORText + ' sendeeMail: ' + E.Message,EMAIL_R);
  end;
  eMailContent.free;
  qEMAIL.free;
  cVORLAGE_EMAIL.free;
  cDUBLETTE_EMAIL.free;
  USER_DIENSTE.free;
  SMTP.free;
  sAttachments.free;
  sTextInhalt.free;
  if assigned(SenderSettings) then
    SenderSettings.free;

  EndHourGlass;
  dec(PersonMailer_Active);
end;

procedure TFormPersonMailer.SetSenden(EMAIL_R: integer; ClearIt: boolean = false);
begin
  if ClearIt then
    e_x_sql('update EMAIL set GESENDET = NULL where RID=' + inttostr(EMAIL_R))
  else
    e_x_sql('update EMAIL set GESENDET = ''NOW'' where RID=' + inttostr(EMAIL_R));
end;

procedure TFormPersonMailer.Replace(EMAIL_R: integer; sText: TStrings; Attachments: TStrings);
var
  cEMAIL: TIB_Cursor;
  cPERSON: TIB_Cursor;
  cANSCHRIFT: TIB_Cursor;
  cARTIKEL: TIB_Cursor;
  cVERSAND: TIB_Cursor;
  n: integer;
  eMail_Parameter: TStringList;
  eMail_Baustein: TStringList;
  FName: string;
  VERSAND_R: integer;
  md5: TDCP_md5;
begin
  cEMAIL := DataModuleDatenbank.nCursor;
  eMail_Parameter := TStringList.create;
  eMail_Baustein := TStringList.create;
  try
    repeat

      with cEMAIL do
      begin
        sql.add('select * from EMAIL where RID=' + inttostr(EMAIL_R));
        ApiFirst;
        if eof then
          break;

        // Die "NACHRICHT" enthält nur die Parameter-Werte für die folgende
        // Ausbelichtung der VORLAGE_R
        FieldByName('NACHRICHT').AssignTo(eMail_Parameter);

        // noch dazu: grundsätzlich bereitgestellte Variablen
        e_a_Infos(eMail_Parameter);

        for n := 0 to pred(eMail_Parameter.count) do
        begin

          // Besondere Aktionen
          if (pos(ceMail_ResetPasswort, eMail_Parameter[n]) = 1) then
          begin
            e_w_PersonSetPassword(FieldByName('PERSON_R').AsInteger);
            continue;
          end;

          // Dateianlagen
          if (pos(ceMail_Anlage, eMail_Parameter[n]) = 1) then
          begin
            FName := cutblank(copy(eMail_Parameter[n], succ(pos(':', eMail_Parameter[n])), MaxInt));
            if FileExists(FName) then
              Attachments.add(FName)
            else
              sText.add('ERROR: Datei-Anlage "' + ExtractFileName(FName) +
                '" fehlt, da die Datei vor dem Versenden nicht gefunden wurde');
            continue;
          end;

          // Text-Includes via "Baustein:<DateiName>"
          if (pos(ceMail_Baustein, eMail_Parameter[n]) = 1) then
          begin
            FName := cutblank(copy(eMail_Parameter[n], succ(pos(':', eMail_Parameter[n])), MaxInt));
            // Sicherheit
            ersetze('*', '', FName);
            ersetze('?', '', FName);
            ersetze('..', '', FName);
            if FileExists(FName) then
            begin
              eMail_Baustein.LoadFromFile(FName);
              sText.AddStrings(eMail_Baustein);
            end
            else
              sText.add('ERROR: Textbaustein "' + ExtractFileName(FName) +
                '" fehlt, da die Datei vor dem Versenden nicht gefunden wurde');

            continue;
          end;

          // Raw-eMail
          if (pos(ceMail_eml, eMail_Parameter[n]) = 1) then
          begin
            FName := cutblank(copy(eMail_Parameter[n], succ(pos(':', eMail_Parameter[n])), MaxInt));
            // Sicherheit
            ersetze('*', '', FName);
            ersetze('?', '', FName);
            ersetze('..', '', FName);
            if FileExists(FName) then
            begin
              eMail_Baustein.LoadFromFile(FName);
              // ContenType :=
              sText.AddStrings(eMail_Baustein);
            end
            else
              sText.add('ERROR: eml-Datei "' + ExtractFileName(FName) +
                '" fehlt, da die Datei vor dem Versenden nicht gefunden wurde');

            continue;

          end;

          // Ist es ein Parameter
          if (pos('=', eMail_Parameter[n]) > 0) then
          begin
            ersetze('~' + nextp(eMail_Parameter[n], '=', 0) + '~', nextp(eMail_Parameter[n], '=', 1), sText);
            continue;
          end;

        end;
      end;

      if cEMAIL.FieldByName('PERSON_R').IsNotNull then
      begin
        cPERSON := DataModuleDatenbank.nCursor;
        cANSCHRIFT := DataModuleDatenbank.nCursor;
        with cPERSON do
        begin
          sql.add('select * from PERSON where RID=' + cEMAIL.FieldByName('PERSON_R').AsString);
          ApiFirst;
          for n := 0 to pred(FieldCount) do
            with Fields[n] do
              ersetze('~PERSON.' + FieldName + '~', AsString, sText);
        end;
        with cANSCHRIFT do
        begin
          sql.add('select * from ANSCHRIFT where RID=' + cPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsString);
          ApiFirst;
          for n := 0 to pred(FieldCount) do
            with Fields[n] do
              ersetze('~ANSCHRIFT.' + FieldName + '~', AsString, sText);
        end;
        cPERSON.free;
        cANSCHRIFT.free;
      end;

      if cEMAIL.FieldByName('ARTIKEL_R').IsNotNull then
      begin
        cARTIKEL := DataModuleDatenbank.nCursor;
        with cARTIKEL do
        begin
          sql.add('select * from ARTIKEL where RID=' + cEMAIL.FieldByName('ARTIKEL_R').AsString);
          ApiFirst;
          for n := 0 to pred(FieldCount) do
            with Fields[n] do
              ersetze('~ARTIKEL.' + FieldName + '~', AsString, sText);
        end;
        cARTIKEL.free;
      end;

      if cEMAIL.FieldByName('EREIGNIS_R').IsNotNull then
      begin
        VERSAND_R := e_r_sql('select VERSAND_R from EREIGNIS where RID=' + cEMAIL.FieldByName('EREIGNIS_R').AsString);

        if (VERSAND_R >= cRID_FirstValid) then
        begin
          cVERSAND := DataModuleDatenbank.nCursor;
          with cVERSAND do
          begin
            sql.add('select * from VERSAND where RID=' + inttostr(VERSAND_R));
            ApiFirst;
            for n := 0 to pred(FieldCount) do
              with Fields[n] do
                ersetze('~VERSAND.' + FieldName + '~', AsString, sText);
          end;
          cVERSAND.free;
        end;

      end;

      if cEMAIL.FieldByName('DATEI_ANLAGE').IsNotNull then
      begin
        md5 := TDCP_md5.create(nil);
        ersetze('~MD5~', md5.FromFile(cEMAIL.FieldByName('DATEI_ANLAGE').AsString), sText);
        md5.free;
      end;

    until true;
  except
    // Fehler eintragen!
    on E: Exception do
      sText.add(cERRORText + ' PersonMailer.Replace: ' + E.Message);
  end;
  eMail_Parameter.free;
  eMail_Baustein.free;
  cEMAIL.free;
end;

procedure TFormPersonMailer.Button2Click(Sender: TObject);
begin
  FormPerson.SetContext(IB_Query1.FieldByName('PERSON_R').AsInteger);
end;

procedure TFormPersonMailer.Button3Click(Sender: TObject);
begin
  // Toggle "Vorlagen"
  Vorlagen := not(Vorlagen);
  with IB_Query1 do
  begin
   Close;
  case Vorlagen of
   true:begin
     // nur noch VORLAGEN ansehen
     Button3.Font.Style := [fsbold];
     sql.Text :=
      {} 'select * from EMAIL where '+
      {} ' (VORLAGE_R is null) and '+
      {} ' (UID is not null) and '+
      {} ' (UID<>'+SQLstring(cMail_Blocked)+') and '+
      {} ' ((UID not containing ''@'') or (UID containing ''Versand'')) '+
      {} 'for update';
   end;
   false:begin
     // wieder alles ansehen
     Button3.Font.Style := [];
     sql.Text := 'select * from EMAIL order by RID descending for update';
   end;
  end;
  Open;
  end;
end;

procedure TFormPersonMailer.Button4Click(Sender: TObject);
begin
  FormBelege.SetContext(0, IB_Query1.FieldByName('BELEG_R').AsInteger);
end;

procedure TFormPersonMailer.Button5Click(Sender: TObject);
begin
  // eml in eine "@" Vorlage laden
end;

procedure TFormPersonMailer.Button6Click(Sender: TObject);
begin
  produceMailFromEREIGNIS;
end;

procedure TFormPersonMailer.Button8Click(Sender: TObject);
begin
  PersonMailer_Break := true;
end;

procedure TFormPersonMailer.CheckBox1Click(Sender: TObject);
begin
  Timer1.enabled := CheckBox1.checked;
end;

procedure TFormPersonMailer.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'eMail');
end;

function TFormPersonMailer.LastSQL: string;
var
  AnzahlDerSysteme: integer;
  ModuloDesSystems: integer;
begin
  if CheckBox6.checked then
  begin
    AnzahlDerSysteme := StrToIntDef(Edit5.text, 1);
    ModuloDesSystems := pred(StrToIntDef(Edit4.text, 1));
    result :=
    { } ' ((RID - (RID / ' + inttostr(AnzahlDerSysteme) + ')' +
    { } ' * ' + inttostr(AnzahlDerSysteme) + ')=' +
    { } inttostr(ModuloDesSystems) + ') and';
  end
  else
  begin
    result := '';
  end;
end;

procedure TFormPersonMailer.Log(sLog: string; EMAIL_R: Integer);
begin
  Memo1.Lines.add(sLog);
  if (pos(cERRORText, sLog)>0) then
   AppendStringsToFile(
    {} sLog+' (RID='+IntTostr(EMAIL_R)+')',
    {} DiagnosePath+'EMAIL-'+ComputerName+'-'+e_r_Kontext+cLogExtension);
end;

function TFormPersonMailer.MakeSendList: TgpIntegerList;
begin
  result := e_r_sqlm(
    { } 'select RID from EMAIL where ' +
    { } ' (GESENDET is NULL) and' +
    { } ' ((PERSON_R is NOT NULL) or (EMPFAENGER is not null)) and' +
    { } ' ((VERSUCHE is NULL) OR (VERSUCHE<=3)) and' +
    { } LastSQL +
    { } ' ((AUSGANG < CURRENT_TIMESTAMP) OR (AUSGANG is NULL)) ' +
    { } Edit2.text);
  if (result.count > 0) then
    Log(inttostr(result.count) + ' noch zu senden ...',cRID_Unset);
end;

procedure TFormPersonMailer.IdSMTP1Work(Sender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
begin

  if (ProgressBar1.max > 0) then
    if frequently(eMailStartTime, 222) then
    begin
      ProgressBar1.position := AWorkCount;
      Label2.caption := inttostr(AWorkCount);
    end;

  if PersonMailer_Break or NoTimer then
    if (PersonMailer_Active > 0) then
    begin
      try
        (Sender as TIdSMTP).disconnect(); // Socket
      except
        ;
      end;
    end;
end;

procedure TFormPersonMailer.IdSMTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  ProgressBar1.position := 0;
  Label2.caption := 'OK';
end;

procedure TFormPersonMailer.produceMailFromEREIGNIS;
var
  cEREIGNIS: TIB_Cursor;
  Aktion: TStringList;
  TicketInfo: TStringList;

  EREIGNIS_R: integer;
  VORLAGE_R: integer;

  procedure PostTicket;
  var
    qTICKET: TIB_Query;
  begin
    qTICKET := DataModuleDatenbank.nQuery;
    with qTICKET do
    begin

      // ein Ticket, durch das System erzeugt
      sql.add('select * from TICKET for update');
      insert;
      FieldByName('RID').AsInteger := 0;
      FieldByName('AKTION').Assign(Aktion);
      FieldByName('INFO').Assign(TicketInfo);
      FieldByName('PERSON_R').Assign(cEREIGNIS.FieldByName('PERSON_R'));
      FieldByName('MOMENT').AsDateTime := now;
      FieldByName('ABLAUF').AsDateTime := now + 2;
      post;

    end;
    qTICKET.free;
  end;

  procedure doMiniScore;
  var
    NUMERO: string;
    FName: string;
  begin
    with cEREIGNIS do
    begin

      // eT_Miniscore
      sql.Clear;
      sql.add('select * from EREIGNIS where');
      sql.add(' (ART=' + inttostr(eT_Miniscore) + ') and');
      sql.add(' (BEARBEITER_R IS NULL)');
      ApiFirst;
      while not(eof) do
      begin

        EREIGNIS_R := FieldByName('RID').AsInteger;

        if FieldByName('ARTIKEL_R').IsNull then
          raise Exception.create('EREIGNIS ' + FieldByName('RID').AsString + ': ARTIKEL_R IS NULL');

        if FieldByName('PERSON_R').IsNull then
          raise Exception.create('EREIGNIS ' + FieldByName('RID').AsString + ': PERSON_R IS NULL');

        NUMERO := e_r_sqls('select NUMERO from ARTIKEL WHERE RID=' + FieldByName('ARTIKEL_R').AsString);

        // einen eMail Eintrag erzeugen
        FName := iPDFPathPublicApp + NUMERO + cPDFExtension;
        if FileExists(FName) then
        begin

          // Grössenkontrolle
          if (FSize(FName) < 8 * 1024 * 1024) then
          begin

            // Die Datei an den Kunden - alles klar
            VORLAGE_R := e_r_VorlageMail(cMailVorlage_Dokument);

            if (VORLAGE_R >= cRID_FirstValid) then
            begin
              e_x_sql('insert into EMAIL (' +
                { } 'RID,PERSON_R,VORLAGE_R,ARTIKEL_R,DATEI_ANLAGE) values (' +
                { } '0' + ',' +
                { } FieldByName('PERSON_R').AsString + ',' +
                { } inttostr(VORLAGE_R) + ',' +
                { } FieldByName('ARTIKEL_R').AsString + ',' +
                { } '''' + FName + '''' + ');');

              e_w_EreignisAbschluss(EREIGNIS_R);
            end
            else
            begin
              e_w_EreignisAbschluss(EREIGNIS_R, cERRORText + ' eMail Vorlage "PDF" fehlt');
            end;

          end
          else
          begin
            // --> ein Ticket erzeugen: Sysadmin: sorge dafür, dass die Datei kleiner wird
            // Folgeaktion, nach der Verbesserung: 'insert into EREIGNIS values(RID,ARTIKEL_R,PERSON_R)'
            // der Kunde bekommt seine pdf - noch "Close" des Tickets schicken?
            // ohne Abzeichnen: -> eMail Entschuldigung
            TicketInfo.Clear;
            TicketInfo.add('Datei "' + FName + '" muss auf unter 8 M Byte verkleinert werden!');
            TicketInfo.add('ARTIKEL_R=' + FieldByName('ARTIKEL_R').AsString);

            Aktion.Clear;
            Aktion.values['NACH_LÖSUNG'] := 'update EREIGNIS set BEARBEITER_R = NULL where RID = ' +
              FieldByName('RID').AsString;
            Aktion.values['NACH_UNLÖSBAR'] := 'OLAP KundeAbwatschen(PERSON_R)';
            PostTicket;

            // Kunde: mit dieser Datei ist ein Problem aufgetreten
            // Das Technik Team wird sich bemühen, die Störung in
            // den nächsten Stunden zu beheben.

            // Kunde: leider konnte das Problem nicht behoben werden. Ev. wenden Sie
            // sich direkt an Herrn ...
            // Vielen Dank für Ihre Mithilfe.

            // Kunde: Das Problem wurde heute untersucht, es konnte aber noch
            // keine Lösung gefunden werden. Wir erwarten eine Klärung
            // bis ~Datum~
            e_w_EreignisAbschluss(EREIGNIS_R, cERRORText + ' Datei ist zu gross');

          end;

        end
        else
        begin

          //
          // --> ein Ticket erzeugen: Sysadmin: Besorge die Datei, sie ist nicht
          // vorhanden!
          //

          //
          // Kunde-Sofort-Info: Diese Datei konnte nicht gefunden werden.
          // Das Technik Team wird sich bemühen, die Störung in
          // den nächsten Stunden zu beheben.

          // Ergebnis GUT: Kunde bekommt mail, Datei ist jetzt wieder da!
          // Ergebnis BÖSE: Kunde bekommt info, dass die Datei leider nicht verfügbar ist!
          // Ergebnis 0: Kunde bekommt info, dass die Datei leider nicht verfügbar ist!
          // Q von Orgamon sinkt!

          TicketInfo.Clear;
          TicketInfo.add('Datei "' + FName + '" muss verfügbar gemacht werden!');
          TicketInfo.add('ARTIKEL_R=' + FieldByName('ARTIKEL_R').AsString);

          Aktion.Clear;

          //
          Aktion.values['NACH_LÖSUNG'] := 'update EREIGNIS set BEARBEITER_R = NULL where RID = ' +
            FieldByName('RID').AsString;

          //
          Aktion.values['NACH_UNLÖSBAR'] := 'OLAP KundeAbwatschen(PERSON_R)';
          PostTicket;

          //
          e_w_EreignisAbschluss(EREIGNIS_R, cERRORText + ' Datei fehlt');

        end;

        ApiNext;
      end;
      close;
    end;
  end;

  procedure doVersand;
  var
    VERSAND_R: integer;
    PERSON_R: integer;
    cVERSAND: TIB_Cursor;
    VorlageName: string;
    eMailParameter: TStringList;
    qMAIL: TIB_Query;
  begin

    cVERSAND := DataModuleDatenbank.nCursor;
    eMailParameter := TStringList.create;
    qMAIL := DataModuleDatenbank.nQuery;

    with cEREIGNIS do
    begin

      sql.Clear;
      sql.add('select * from EREIGNIS where');
      sql.add(' (ART=' + inttostr(eT_PaketIDErhalten) + ') and');
      sql.add(' (BEARBEITER_R IS NULL)');
      ApiFirst;
      while not(eof) do
      begin

        EREIGNIS_R := FieldByName('RID').AsInteger;

        if FieldByName('VERSAND_R').IsNull then
          raise Exception.create('EREIGNIS ' + FieldByName('RID').AsString + ': VERSAND_R IS NULL');
        VERSAND_R := FieldByName('VERSAND_R').AsInteger;

        with cVERSAND do
        begin

          if (sql.count = 0) then
            sql.add(
              { } 'select' +
              { } ' VERSAND.BELEG_R,' +
              { } ' VERSAND.TEILLIEFERUNG,' +
              { } ' VERSAND.PAKETID,' +
              { } ' COALESCE(BELEG.LIEFERANSCHRIFT_R,BELEG.PERSON_R) PERSON_R,' +
              { } ' VERSENDER.BEZEICHNUNG ' +
              { } 'from VERSAND ' +
              { } 'join BELEG on' +
              { } ' (BELEG.RID=VERSAND.BELEG_R) ' +
              { } 'left join VERSENDER on' +
              { } ' (VERSAND.VERSENDER_R=VERSENDER.RID) ' +
              { } 'where' +
              { } ' (VERSAND.RID=:CROSSREF)');

          close;
          ParamByName('CROSSREF').AsInteger := VERSAND_R;
          Open;
          first;
          if eof then
            raise Exception.create('VERSAND ' + inttostr(VERSAND_R) + ': nicht gefunden');

          PERSON_R := cVERSAND.FieldByName('PERSON_R').AsInteger;
          VorlageName := cMailvorlage_Versand + FieldByName('BEZEICHNUNG').AsString;
          VORLAGE_R := e_r_VorlageMail(VorlageName);

          if (VORLAGE_R > 0) then
          begin
            eMailParameter.Clear;

            with eMailParameter do
            begin
              values['PAKETID'] := FieldByName('PAKETID').AsString;

              add('Baustein:' +
                { } cPersonPath(FieldByName('PERSON_R').AsInteger) +
                { } inttostrN(FieldByName('BELEG_R').AsInteger, 10) + '-' +
                { } inttostrN(FieldByName('TEILLIEFERUNG').AsInteger, 2) + '#M' +
                { } chtmlExtension);

              add('Anlage:' +
                { } cPersonPath(FieldByName('PERSON_R').AsInteger) +
                { } inttostrN(FieldByName('BELEG_R').AsInteger, 10) + '-' +
                { } inttostrN(FieldByName('TEILLIEFERUNG').AsInteger, 2) + '#W' +
                { } chtmlExtension);

            end;

            //
            with qMAIL do
            begin
              if (sql.count = 0) then
                sql.add('select * from EMAIL for update');
              insert;
              FieldByName('RID').AsInteger := cRID_AutoInc;
              FieldByName('PERSON_R').AsInteger := PERSON_R;
              FieldByName('EREIGNIS_R').AsInteger := EREIGNIS_R;
              FieldByName('VORLAGE_R').AsInteger := VORLAGE_R;
              FieldByName('NACHRICHT').Assign(eMailParameter);
              post;
            end;

          end
          else
          begin
            e_w_EreignisAbschluss(EREIGNIS_R, cERRORText + ' eMail Vorlage "' + VorlageName + '" nicht gefunden');
          end;

        end;
        e_w_EreignisAbschluss(EREIGNIS_R);

        ApiNext;
      end;
      close;
    end;
    cVERSAND.free;
    qMAIL.free;
    eMailParameter.free;
  end;

  procedure doZusage;
  var
   VORLAGE_R : Integer;
   PERSON_R : Integer;
   ARTIKEL_R : Integer;
   AUSGABEART_R : Integer;
   cEREIGNIS : TdboCursor;
   cPOSTEN : TdboCursor;
   EREIGNIS_R: Integer;
   sINFO: TStringList;
   TODAY, ZUSAGE_ALT, ZUSAGE_NEU : TAnfixDate;
   eMailParameter : TStringList;
   qMAIL: TIB_Query;
  begin
    VORLAGE_R := e_r_VorlageMail(cMailVorlage_Zusage);
    sINFO := TStringList.Create;
    eMailParameter := TStringList.Create;
    cEREIGNIS := nCursor;
    qMAIL := nQuery;
    TODAY := DateGet;

    // Zunächst "abgelaufene" (TimeOut) Ereignisse als beendet ausschliessen
    with cEREIGNIS do
    begin
      sql.Add('select * from EREIGNIS where');
      sql.add(' (ART=' + inttostr(eT_OrderZusageAenderung) + ') and');
      sql.add(' (BEENDET IS NULL)');
      ApiFirst;
      while not(EOF) do
      begin
        EREIGNIS_R := FieldByName('RID').AsInteger;
        ARTIKEL_R := FieldByName('ARTIKEL_R').AsInteger;
        AUSGABEART_R := FieldByName('AUSGABEART_R').AsInteger;
        repeat

          // Umsetzung gar nicht gewünscht?
          if (VORLAGE_R<cRID_FirstValid) then
          begin
            e_w_EreignisAbschluss(EREIGNIS_R, cERRORText + ' eMail Vorlage "' + cMailVorlage_Zusage + '" nicht gefunden');
            break;
          end;

          // Für eine eMail-Info ist es zu spät?
          e_r_sqlt(FieldByName('INFO'), sINFO);
          ZUSAGE_ALT := date2long(nextp(sINFO.values['ZUSAGE'],' ',0));
          ZUSAGE_NEU := date2long(nextp(sINFO.values['NEW.ZUSAGE'],' ',0));
          if DateNotOK(ZUSAGE_NEU) then
          begin
            e_w_EreignisAbschluss(EREIGNIS_R, cERRORText + ' Zusage-Neu-Datum unlesbar');
            break;
          end;
          if (ZUSAGE_NEU<=TODAY) then
          begin
            e_w_EreignisAbschluss(EREIGNIS_R, cERRORText + ' Zusage-Neu TimeOut');
            break;
          end;

          cPOSTEN  := nCursor;

          with cPOSTEN do
          begin
            sql.Add('select BELEG.PERSON_R,SUM(POSTEN.MENGE_AGENT) MENGE from POSTEN');
            sql.add('join BELEG on (POSTEN.BELEG_R=BELEG.RID) and (BELEG.PERSON_R is not null) where');
            sql.Add(' (POSTEN.ARTIKEL_R='+IntToStr(ARTIKEL_R)+') and');
            sql.Add(' (POSTEN.AUSGABEART_R' + isRID(AUSGABEART_R) +') and');
            sql.Add(' (POSTEN.MENGE_AGENT>0)');
            sql.Add('group by');
            sql.add(' BELEG.PERSON_R');
            APiFirst;
          end;

          while not(cPOSTEN.Eof) do
          begin

            PERSON_R := cPOSTEN.FieldByName('PERSON_R').AsInteger;

            // eMail schreiben an alle, die darauf warten
            with eMailParameter do
            begin
              values['AUSGABEART_R'] := IntTostr(AUSGABEART_R);
              values['AUSGABEART'] := e_r_Ausgabeart(AUSGABEART_R);
              values['MENGE'] := IntToStr(cPOSTEN.FieldByName('MENGE').AsInteger);
              values['ZUSAGE'] := long2date(ZUSAGE_ALT);
              values['NEW.ZUSAGE'] := long2date(ZUSAGE_NEU);
            end;

            with qMAIL do
            begin
              if (sql.count = 0) then
                sql.add('select * from EMAIL for update');
              insert;
              FieldByName('RID').AsInteger := cRID_AutoInc;
              FieldByName('VORLAGE_R').AsInteger := VORLAGE_R;
              FieldByName('PERSON_R').AsInteger := PERSON_R;
              FieldByName('ARTIKEL_R').AsInteger := ARTIKEL_R;
              FieldByName('EREIGNIS_R').AsInteger := EREIGNIS_R;
              FieldByName('NACHRICHT').Assign(eMailParameter);
              post;
            end;
            cPOSTEN.APINext;
          end;
          cPOSTEN.Free;

          // Erfolg verbuchen!
          e_w_EreignisAbschluss(EREIGNIS_R, cERRORText + ' Zusage-Neu TimeOut');

        until yet;
        ApiNext;
      end;

    end;
    cEREIGNIS.Free;
    sINFO.Free;
    qMAIL.Free;
    eMailParameter.free;
  end;

begin
  //
  BeginHourGlass;

  // Ereignis - Tabelle abfragen!
  Aktion := TStringList.create;
  TicketInfo := TStringList.create;
  cEREIGNIS := DataModuleDatenbank.nCursor;

  try
    doMiniScore;
  except
    on E: Exception do
      Log(cERRORText + ' doMiniScore: ' + E.Message, cRID_unset);
  end;

  try
    doVersand;
  except
    on E: Exception do
      Log(cERRORText + ' doVersand: ' + E.Message, cRID_unset);
  end;

  try
    doZusage;
  except
    on E: Exception do
      Log(cERRORText + ' doZusage: ' + E.Message, cRID_unset);
  end;

  cEREIGNIS.free;
  Aktion.free;
  TicketInfo.free;
  EndHourGlass;
end;

end.
