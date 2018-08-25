{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2016  Andreas Filsinger
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
unit CareServer;
//
// CareTaker
//
// CareTaker überwacht Rechner, Applikationen und eServices.
//
// * Im Problemfall setzt das Trouble-Ticket System ein
// * Je nach Eskalations-Stufe werden verschiedene eMail Aktionen ausgelöst
// * Fehler Verfolgung bei Softwareentwicklungsprojekten
// * Arbteitsschrittverfolgung in der Fertigungsabwicklung
// * customer relationship management (CRM)
// * Produktionsfehler Nachverfolgung
// * help desk System
// * Problemfallverfolgung und Lösung
// * Datenbankbasiertes FAQ System mit mehrsprachigem Stichwort-Index
//
// RECHNER
// * RID, Hostname (Beispiel "Herr Hildebrand"), Beschreibung
//
// TICKET_GRUPPE
// * RID, Name (Beispiel "Kunde A")
//
// TICKET_QUELLE
// TICKET_GRUPPE_R,RECHNER_R  ("Herr Hildebrand" gehört zur Firma "Kunde A")
//
// TICKET_ZIEL
// TICKET_GRUPPE_R,PERSON_R
//
// TICKET
// * RID, MOMENT, Rechner_R, Text, EMAIL, NUMMER
//
// Vorgehensweise des Servers
//
// 1) Nachrichten lesen, Rechner ggf. anlegen, Rechner_R eintragen in DB Speichern
// 2) Auf Anforderung: alle tickets ohne email: Gruppe bestimmen, dann alle ziele
// via eMail benachrichtigen!
//
//
// todo
// verschieben ins eCommerceModul!
//

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls,
  IniFiles,
  IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, anfix32,
  IdMessageClient, IdSMTP, Grids,
  IB_Grid, IB_Components, IB_UpdateBar, IB_Access,
  IdExplicitTLSClientServerBase, IdSMTPBase, IB_Controls,
  Buttons, IdUDPBase, IdUDPClient, IdSNMP,
  CareTakerClient;

type
  TFormCareServer = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Memo1: TMemo;
    RadioGroup1: TRadioGroup;
    Button2: TButton;
    IdHTTP1: TIdHTTP;
    IdSMTP1: TIdSMTP;
    TabSheet3: TTabSheet;
    IB_Grid1: TIB_Grid;
    IB_Grid2: TIB_Grid;
    IB_Grid3: TIB_Grid;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_UpdateBar2: TIB_UpdateBar;
    IB_UpdateBar3: TIB_UpdateBar;
    IB_Query1: TIB_Query;
    IB_Query2: TIB_Query;
    IB_Query3: TIB_Query;
    IB_Query4: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_DataSource2: TIB_DataSource;
    IB_DataSource3: TIB_DataSource;
    IB_DataSource4: TIB_DataSource;
    Label5: TLabel;
    IB_Query5: TIB_Query;
    IB_DataSource5: TIB_DataSource;
    IB_Grid5: TIB_Grid;
    IB_UpdateBar5: TIB_UpdateBar;
    Button5: TButton;
    ListBox1: TListBox;
    Label6: TLabel;
    Button4: TButton;
    TabSheet2: TTabSheet;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button1: TButton;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Button6: TButton;
    Label10: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Label11: TLabel;
    Button7: TButton;
    Edit6: TEdit;
    Label12: TLabel;
    Edit8: TEdit;
    Label13: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Label14: TLabel;
    Button8: TButton;
    Edit7: TEdit;
    IdSNMP1: TIdSNMP;
    Edit9: TEdit;
    Button9: TButton;
    Label15: TLabel;
    TabSheet4: TTabSheet;
    ListBox2: TListBox;
    Label16: TLabel;
    Button10: TButton;
    Label17: TLabel;
    Edit10: TEdit;
    Image2: TImage;
    TabSheet5: TTabSheet;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    IB_Grid4: TIB_Grid;
    IB_UpdateBar4: TIB_UpdateBar;
    IB_Memo1: TIB_Memo;
    procedure Button8Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure IB_Grid5CellDblClick(Sender: TObject; ACol, ARow: Integer;
      AButton: TMouseButton; AShift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private
    { Private-Deklarationen }
    LastData: TStringList;
    Initialized: boolean;

    procedure BeginHourGlass;
    procedure EndHourGlass;
    function pKey: string;
    function SelectedDate: TAnfixDate;
  public
    { Public-Deklarationen }
    function LoadLogViaHTTP(Datum: TAnfixDate): string;
    procedure insertRecords(sl: TStrings);
    function UnScramble(FName: string): TStringList;
    function ShowIfError(sDiagnose: TStringList): boolean;

    // Tests zur "Funktions Sicherstellung" registrieren!
    //
    procedure addTest(NameSpace: string; test: tTestProc); overload;
    procedure addTest(NameSpace: string; test: tSelfTestProc); overload;

    // Vorläufige Implementierung für Oc
    procedure OcTest(Path: string);
    procedure txlibTest(Path: string);
    procedure zipTest(Path: string);
    procedure HashTest(Path: string);
    procedure htmlTest(Path: string);
  end;

var
  FormCareServer: TFormCareServer;

implementation

uses
  globals, systemd, wanfix32, html, c7zip,

  //
  DCPcrypt2, DCPblockciphers, DCPblowfish, DCPbase64,

  // Tools
  SolidFTP, OrientationConvert,

  // Server-Steuerung
  IdASN1Util, IDMessage,
  IdEMailAddress,

  // Server-Version
  IBOServices, IB_Session,

  // OrgaMon
  Funktionen_Basis,

  // Tests
  DCPmd5, txlib, Datenbank;
{$R *.dfm}

function TFormCareServer.ShowIfError(sDiagnose: TStringList): boolean;
var
  n: Integer;
begin
  result := false;
  if assigned(sDiagnose) then
  begin
    for n := 0 to pred(sDiagnose.count) do
      if pos(cERRORText, sDiagnose[n]) = 1 then
      begin
        result := true;
        break;
      end;
    if result then
    begin
      if (sDiagnose.count > 5) then
      begin
        sDiagnose.SaveToFile(DiagnosePath + 'Buch.txt');
        openShell(DiagnosePath + 'Buch.txt');
      end
      else
      begin
        ShowMessage(HugeSingleline(sDiagnose));
      end;
    end;
  end;
end;

procedure TFormCareServer.Button2Click(Sender: TObject);
var
  RawResult: string;
  OneLine: string;
  ThisData: TStringList;
begin
  if (RadioGroup1.itemindex <> -1) then
  begin
    BeginHourGlass;
    ThisData := TStringList.create;

    RawResult := LoadLogViaHTTP(SelectedDate);
    LastData.clear;
    Memo1.lines.clear;
    while (RawResult <> '') do
    begin
      OneLine := StrFilter(nextp(RawResult, #$0A), #$0D#$0A, true);
      LastData.add(nextp(OneLine, ';', 0) + ';' + nextp(OneLine, ';', 1) + ';' +
        nextp(OneLine, ';', 2) + ';' + nextp(OneLine, ';', 3));

      OneLine := nextp(OneLine, ';', 0) + ';' + nextp(OneLine, ';', 1) + ';' +
        deCrypt(nextp(OneLine, ';', 2)) + ';' + nextp(OneLine, ';', 3);

      ThisData.add(OneLine);

      repeat

        // Filter
        (*
          if not(checkBox1.checked) then
          if not (ListBox1.items[0] = '*') then
          if (ListBox1.items.indexof(nextp(nextp(OneLine, '@', 1), '.', 1)) = -1) then
          break;
        *)

        Memo1.lines.add(OneLine);
      until true;

    end;
    ThisData.SaveToFile(DiagnosePath + 'CareLog.csv');
    ThisData.Free;
    EndHourGlass;
  end;
end;

function TFormCareServer.LoadLogViaHTTP(Datum: TAnfixDate): string;
var
  _datum: string;
begin
  try
    _datum := long2date(Datum);
    with IdHTTP1 do
    begin
      result := get('http://caretaker.orgamon.org/' + copy(_datum, 7, 4) + '.' +
        copy(_datum, 4, 2) + '.' + copy(_datum, 1, 2) + '.log');
    end;
  except
    result := '';
  end;
end;
procedure TFormCareServer.Button1Click(Sender: TObject);
var
  S: string;
  Str: string;
  cBLOWFISH: TDCP_blowfish;
  CryptKey: array [0 .. 1023] of char;
begin

  cBLOWFISH := TDCP_blowfish.create(nil);
  with cBLOWFISH do
  begin
    StrPCopy(CryptKey, pKey);
    Init(CryptKey, Length(pKey) * 8, nil);

    if (Edit1.Text <> '') then
      Str := Edit1.Text
    else
      Str := Int64asKeyStr(strtoint64def(Edit4.Text, 0));

    SetLength(S, Length(Str));
    EncryptCFB8bit(Str[1], S[1], Length(Str));
    Edit2.Text := S;
    Edit3.Text := Base64EncodeStr(S);
    Edit5.Text := AnsiTorfc1738(Edit3.Text);

  end;
  cBLOWFISH.Free;

end;

procedure TFormCareServer.Button6Click(Sender: TObject);
var
  cBLOWFISH: TDCP_blowfish;
  CryptKey: array [0 .. 1023] of char;
  S: string;
  r: string;
begin
  cBLOWFISH := TDCP_blowfish.create(nil);
  with cBLOWFISH do
  begin
    StrPCopy(CryptKey, pKey);
    Init(CryptKey, Length(pKey) * 8, nil);
    S := Base64DecodeStr(Edit3.Text);
    r := S;
    SetLength(r, Length(S));
    Edit2.Text := S;
    DecryptCFB8bit(r[1], r[1], Length(r));
    Edit1.Text := r;
    if (Length(r) = 8) then
      Edit4.Text := IntToStr(KeystrasInt64(r))
    else
      Edit4.Text := '';
  end;
  cBLOWFISH.Free;
end;

procedure TFormCareServer.Button7Click(Sender: TObject);
begin
  Edit3.Text := rfc1738toAnsi(Edit5.Text);
  Button6Click(Sender);
end;

procedure TFormCareServer.Button8Click(Sender: TObject);
var
  TheLogPath: string;
  TheFiles: TStringList;
  TheLog: TStringList;
  AllTheLog: TStringList;
  n: Integer;
begin
  BeginHourGlass;
  AllTheLog := TStringList.create;
  TheLogPath := Edit7.Text;
  TheFiles := TStringList.create;
  dir(TheLogPath + '*.log', TheFiles, false);
  TheFiles.sort;
  for n := 0 to pred(TheFiles.count) do
    if pos('.', TheFiles[n]) = 5 then
    begin
      //
      TheLog := UnScramble(TheLogPath + TheFiles[n]);
      AllTheLog.addstrings(TheLog);
      TheLog.Free;
    end;
  TheFiles.Free;
  AllTheLog.SaveToFile(DiagnosePath + 'caretaker.log.txt');
  AllTheLog.Free;
  EndHourGlass;
end;

procedure TFormCareServer.Button9Click(Sender: TObject);
begin
  Edit9.Text := deCrypt_Hex(Edit9.Text);
end;


function TFormCareServer.pKey: string;
begin
  if (Edit6.Text = '<default>') then
    result := cCareTakerKey
  else
    result := Edit6.Text;
end;

procedure TFormCareServer.addTest(NameSpace: string; test: tTestProc);
begin
  //
end;

procedure TFormCareServer.addTest(NameSpace: string; test: tSelfTestProc);
begin
  //
end;

procedure TFormCareServer.BeginHourGlass;
begin
  screen.cursor := crHourGLass;
end;

procedure TFormCareServer.EndHourGlass;
begin
  screen.cursor := crDefault;
end;

procedure TFormCareServer.Button4Click(Sender: TObject);
begin
  //
  insertRecords(LastData);
end;

procedure TFormCareServer.insertRecords(sl: TStrings);
var
  n: Integer;
  HostNames: TStringList;
  Host: string;
  cRECHNER: TIB_Cursor;
  qRECHNER: TIB_Query;
  cTICKET: TIB_Cursor;
  Moment: string;
  TicketNummer: Integer;
  xTICKET: TIB_DSQL;
  qTICKET: TIB_Query;
  RECHNER_R: Integer;
  TICKET_R: Integer;
  TroubleText: TStringList;
begin

  // HostNamen herausfiltern
  HostNames := TStringList.create;
  for n := pred(sl.count) downto 0 do
  begin
    Host := deCrypt(nextp(sl[n], ';', 2));
    Host := nextp(Host, ':', 0);
    Host := nextp(Host, '@', 1);
    if (Host <> '') then
    begin
      sl[n] := Host + ';' + sl[n];
      HostNames.add(Host);
    end
    else
    begin
      sl.delete(n);
    end;
  end;
  HostNames.sort;
  RemoveDuplicates(HostNames);

  // Sicherstellen, dass alle HostNames angelegt sind!
  // Nach diesem Block sind alle vorkommenden Hostnamen im cache!
  cRECHNER := DataModuleDatenbank.nCursor;
  for n := 0 to pred(HostNames.count) do
  begin
    with cRECHNER do
    begin
      sql.clear;
      sql.add('select RID from RECHNER where HOST=''' + HostNames[n] + '''');
      ApiFirst;
      if eof then
      begin
        RECHNER_R := GEN_ID('GEN_RECHNER', 1);
        qRECHNER := DataModuleDatenbank.nQuery;
        with qRECHNER do
        begin
          sql.add('select * from RECHNER for update');
          ColumnAttributes.add('RID=NOTREQUIRED');
          insert;
          FieldByName('RID').AsInteger := RECHNER_R;
          FieldByName('HOST').AsString := HostNames[n];
          post;
        end;

      end
      else
      begin
        RECHNER_R := FieldByName('RID').AsInteger;
      end;
      close;
      HostNames.objects[n] := TObject(RECHNER_R);
    end;

  end;
  cRECHNER.Free;

  // Jetzt alle Log-Einträge eintragen, die noch nicht vorkommen!
  cTICKET := DataModuleDatenbank.nCursor;
  for n := 0 to pred(sl.count) do
  begin
    with cTICKET do
    begin
      RECHNER_R := Integer(HostNames.objects[HostNames.indexof(nextp(sl[n],
        ';', 0))]);
      Moment := nextp(sl[n], ';', 1) + ' ' + nextp(sl[n], ';', 2);
      TicketNummer := strtointdef(StrFilter(nextp(sl[n], ';', 4),
        '-0123456789'), 0);
      sql.clear;
      sql.add('select count(RID) CRID from TICKET where NUMMER=' +
        IntToStr(TicketNummer) + ' and MOMENT=''' + Moment + '''');
      ApiFirst;
      if (FieldByName('CRID').AsInteger = 0) then
      begin

        // Ticket eintragen
        xTICKET := DataModuleDatenbank.nDSQL;
        with xTICKET do
        begin
          TICKET_R := GEN_ID('GEN_TICKET', 1);
          sql.add('insert into TICKET (RID,NUMMER,MOMENT,RECHNER_R)');
          sql.add('values (' + IntToStr(TICKET_R) + ',' + IntToStr(TicketNummer)
            + ',''' + Moment + ''',' + IntToStr(RECHNER_R) + ')');
          execute;
        end;
        xTICKET.Free;

        // Ticket Text nachtragen
        TroubleText := TStringList.create;
        TroubleText.add(nextp(sl[n], ';', 3));
        qTICKET := DataModuleDatenbank.nQuery;
        with qTICKET do
        begin
          sql.add('select INFO from TICKET where RID=' + IntToStr(TICKET_R) +
            ' for update');
          open;
          first;
          edit;
          FieldByName('INFO').Assign(TroubleText);
          post;
        end;
        qTICKET.Free;
        TroubleText.Free;
      end;
      close;
    end;
  end;
  cTICKET.Free;
end;

function TFormCareServer.SelectedDate: TAnfixDate;
begin
  result := cIllegalDate;
  case RadioGroup1.itemindex of
    0:
      result := Date2Long(Edit8.Text);
    1:
      result := datePlus(DateGet, -3);
    2:
      result := datePlus(DateGet, -2);
    3:
      result := datePlus(DateGet, -1);
    4:
      result := DateGet;
  end;
end;

procedure TFormCareServer.SpeedButton1Click(Sender: TObject);
var
  sSettings: TStringList;
  MacAdress: string;
begin
  sSettings := TStringList.create;
  IB_Query4.FieldByName('INFO').AssignTo(sSettings);
  MacAdress := sSettings.values['MAC'];
  if (MacAdress <> '') then
    WakeOnLan(MacAdress)
  else
    ShowMessage('MAC= definieren!');
  sSettings.Free;
end;

procedure TFormCareServer.SpeedButton2Click(Sender: TObject);
var
  sSettings: TStringList;
  LogInName: string;
  LogInHost: string;
  LogInPort: string;
begin
  sSettings := TStringList.create;
  IB_Query4.FieldByName('INFO').AssignTo(sSettings);
  LogInName := sSettings.values['Login'];
  if (LogInName = '') then
    LogInName := 'root';
  LogInHost := sSettings.values['ssh-host'];
  if (LogInHost = '') or (pos(':', LogInHost) = 1) then
    LogInHost := IB_Query4.FieldByName('HOST').AsString + LogInHost;

  LogInPort := nextp(LogInHost, ':', 1);
  LogInHost := nextp(LogInHost, ':', 0);

  if (LogInPort <> '') then
    LogInPort := '-P ' + LogInPort + ' ';

  RunExternalApp(
    { } ProgramFilesDir +
    { Cmd } 'puTTY\putty.exe -ssh ' +
    { Port } LogInPort +
    { Passwort } '-pw ' + sSettings.values['password'] +
    { User@Host } ' ' + LogInName + '@' + LogInHost, sw_showdefault);
  sSettings.Free;
end;

procedure TFormCareServer.SpeedButton3Click(Sender: TObject);
var
  Msg: string;
  IBOServerProperties1: TIBOServerProperties;
  sSettings: TStringList;
begin
  BeginHourGlass;
  sSettings := TStringList.create;
  IB_Query4.FieldByName('INFO').AssignTo(sSettings);
  IBOServerProperties1 := TIBOServerProperties.create(self);
  try
    with IBOServerProperties1 do
    begin
      SysErrorMessage(10060);
      application.processmessages;
      LoginPrompt := false;
      Options := [IBOServices.Version];
      Params.clear;
      Params.add('user_name=SYSDBA');
      Params.add('password=' + sSettings.values['SYSDBA']);
      ServerName := IB_Query4.FieldByName('HOST').AsString;
      Protocol := cpTCP_IP;
      // Active := true;
      Attach;
      Fetch;
      application.processmessages;
      Msg := VersionInfo.ServerImplementation + ' ' + VersionInfo.ServerVersion;
      Detach;
    end;
  except
    on E: Exception do
    begin
      Msg := 'FEHLER' + #13 + E.Message;
    end;
  end;
  IBOServerProperties1.Free;
  sSettings.Free;
  EndHourGlass;
  ShowMessage(Msg);
end;

procedure TFormCareServer.SpeedButton4Click(Sender: TObject);
var
  sSettings: TStringList;
  sHost: string;
  sApp: string;
begin
  sSettings := TStringList.create;
  IB_Query4.FieldByName('INFO').AssignTo(sSettings);
  sHost := sSettings.values['vnc-host'];
  if (sHost = '') or (pos(':', sHost) = 1) then
    sHost := IB_Query4.FieldByName('HOST').AsString + sHost;

  repeat

    sApp := ProgramFilesDir + 'UltraVNC\vncviewer.exe';
    if FileExists(sApp) then
      break;
    sApp := ProgramFilesDir + 'uvnc bvba\UltraVNC\vncviewer.exe';
    if FileExists(sApp) then
      break;
    // auf einem 64-Bit System
    sApp := 'C:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe';
    if FileExists(sApp) then
      break;

    sApp := '';
    ShowMessage('Keine Ultra-VNC Installation gefunden');
  until true;
  if (sApp <> '') then
    RunExternalApp(sApp + ' ' + sHost + ' /password ' + sSettings.values['vnc'],
      sw_showdefault);
  sSettings.Free;
end;

procedure TFormCareServer.SpeedButton5Click(Sender: TObject);
var
  sSettings: TStringList;

  function _g(Setting, SettingDefault: string): string;
  begin
    result := sSettings.values['snmp.' + Setting];
    if (result = '') then
      result := SettingDefault;
  end;

begin
  sSettings := TStringList.create;
  IB_Query4.FieldByName('INFO').AssignTo(sSettings);
  with IdSNMP1 do
  begin
    Host := _g('host', IB_Query4.FieldByName('HOST').AsString);
    Community := _g('community', 'public');
    Active := true;

    Query.clear;
    Query.MIBAdd(_g('cpu', '1.3.6.1.4.1.2021.13.16.2.1.3.2'), '', ASN1_GAUGE);
    Query.PDUType := PDUGetRequest;

    if SendQuery then
      ShowMessage(Reply.Value[0])
    else
      ShowMessage('ERROR');

    Active := false;
  end;
  sSettings.Free;
  EndHourGlass;
end;

procedure TFormCareServer.SpeedButton6Click(Sender: TObject);
var
  sSettings: TStringList;
begin
  sSettings := TStringList.create;
  IB_Query4.FieldByName('INFO').AssignTo(sSettings);
  RunExternalApp(ProgramFilesDir + 'puTTY\plink.exe -ssh -pw ' + sSettings.values
    ['password'] + ' -X root@' + IB_Query4.FieldByName('HOST').AsString +
    ' xterm', sw_showdefault);
  sSettings.Free;
end;

function TFormCareServer.UnScramble(FName: string): TStringList;
var
  InF: TStringList;
  n: Integer;
  OneLine: string;
  OrgMsg: string;
begin
  //
  result := TStringList.create;
  //
  InF := TStringList.create;
  if FileExists(FName) then
  begin
    InF.LoadFromFile(FName);
    for n := 0 to pred(InF.count) do
    begin
      OneLine := InF[n];
      OrgMsg := deCrypt(nextp(OneLine, ';', 2));
      ersetze(#13, cLineSeparator, OrgMsg);
      ersetze(#10, '', OrgMsg);

      result.add(nextp(OneLine, ';', 0) + ';' + // Moment
        nextp(OneLine, ';', 1) + ';' + // Rechner
        OrgMsg + ';' + // Meldung
        nextp(OneLine, ';', 3)); // Übertragungsmoment

    end;
  end;
  InF.Free;
end;

procedure TFormCareServer.FormActivate(Sender: TObject);
var
  _DateGet: TAnfixDate;
  cHOSTS: TIB_Cursor;
begin
  BeginHourGlass;
  if not(Initialized) then
  begin

    LastData := TStringList.create;
    _DateGet := DateGet;
    with RadioGroup1 do
    begin
      items.add('Freie Eingabe');
      items.add(long2date(datePlus(_DateGet, -3)));
      items.add(long2date(datePlus(_DateGet, -2)));
      items.add(long2date(datePlus(_DateGet, -1)));
      items.add(long2date(_DateGet));
      itemindex := pred(items.count);
    end;

    caption := 'Pflege Arbeitsplatz - [' + MachineID + ']';
    Memo1.lines.clear;
    PageControl1.ActivePage := TabSheet1;

    Initialized := true;
  end;

  if not(IB_Query1.Active) then
  begin
    IB_Query1.open;
    IB_Query2.open;
    IB_Query3.open;
    IB_Query4.open;
    IB_Query5.open;
  end
  else
  begin
    IB_Query1.refresh;
    IB_Query2.refresh;
    IB_Query3.refresh;
    IB_Query4.refresh;
    IB_Query5.refresh;
  end;

  // Namen der zu überwachenden Hosts bilden
  ListBox1.items.clear;
  cHOSTS := DataModuleDatenbank.nCursor;
  with cHOSTS do
  begin
    sql.add('select HOST from RECHNER');
    ApiFirst;
    while not(eof) do
    begin
      ListBox1.items.add(FieldByName('HOST').AsString);
      ApiNext;
    end;
  end;
  cHOSTS.Free;
  if ListBox1.items.count = 0 then
    ListBox1.items.add('*');

  EndHourGlass;
end;

procedure TFormCareServer.Button5Click(Sender: TObject);
var
  xTICKET: TIB_DSQL;
begin
  if IB_Query5.FieldByName('EMAIL').IsNotNull then
    if doit('Diese eMail Aktion wirklich rückgängig machen') then
    begin
      xTICKET := DataModuleDatenbank.nDSQL;
      with xTICKET do
      begin
        sql.add('update ticket set email=null');
        sql.add('where email=(select email from ticket where rid=' +
          IB_Query5.FieldByName('RID').AsString + ')');
        execute;
      end;
      xTICKET.Free;
    end;
end;

procedure TFormCareServer.IB_Grid5CellDblClick(Sender: TObject;
  ACol, ARow: Integer; AButton: TMouseButton; AShift: TShiftState);
var
  TheTextLines: TStringList;
begin
  TheTextLines := TStringList.create;
  IB_Query5.FieldByName('INFO').AssignTo(TheTextLines);
  TheTextLines.add('');
  ShowMessage(deCrypt(TheTextLines[0]));
  TheTextLines.Free;
end;

procedure TFormCareServer.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Ticket');
end;

procedure TFormCareServer.FormDestroy(Sender: TObject);
begin
  LastData.Free;
end;

// TESTS

procedure TFormCareServer.OcTest(Path: string);
var
  sOcSettings: TStringList;
  Content_Mode: Integer;
  FName: string;
begin
  // diese Routine soll später durch add() unnötig werden
  // bzw. die implementierung sollte woanders hin wandern!

  // Beispielhafte Oc Implementierung!
  sOcSettings := TStringList.create;
  if FileExists(Path + 'Test.ini') then
    sOcSettings.LoadFromFile(Path + 'Test.ini');

  Content_Mode := strtointdef(sOcSettings.values['Content_Mode'], -1);
  FName := sOcSettings.values['DateiName'];

  if (Content_Mode > 0) then
    if (FName <> '') then
      OrientationConvert.doConversion(Content_Mode, Path + FName);

  sOcSettings.Free;

end;

procedure TFormCareServer.htmlTest(Path: string);
var
  html: THTMLTemplate;
  Datensammler: TStringList;
begin
  if FileExists(Path + 'WriteValue.txt') then
  begin

    html := THTMLTemplate.create;
    Datensammler := TStringList.create;
    html.LoadFromFile(Path + 'Template.html');
    Datensammler.LoadFromFile(Path + 'WriteValue.txt');
    html.writeValue(Datensammler);
    html.SaveToFileCompressed(Path + 'Ergebnis.html');
    html.Free;
    Datensammler.Free;
  end
  else
  begin
    html := THTMLTemplate.create;
    html.LoadFromFile(Path + 'A.html');
    html.InsertDocument(Path + 'B.html');
    html.SaveToFile(Path + 'Ergebnis.html');
    html.Free;

  end;
end;

procedure TFormCareServer.txlibTest(Path: string);
var
  txlibSettings: TIniFile;
  test: String;

  // TTXStringList testen:
  // - Suchen
  // - Lineare Suche
  // - AVL-Baum-Suche
  // - Hash-Suche
  procedure TestStringList;
  var
    StrList: TTXStringList;
    S: String;

    procedure SearchTest;
    var
      Source: TStringList;
      Dest: TStringList;
      I, C: Integer;
    begin
      Source := TStringList.create;
      Dest := TStringList.create;

      try
        // Quell-Testdaten laden
        Source.LoadFromFile(Path + 'quelle.txt');

        // TTXStringList mit Testdaten füllen
        C := Source.count - 1;
        for I := 0 to C do
          StrList.add(Source.Strings[I]);

        // TTXStringList gegen Source testen. Gefundene Suchwerte werden
        // anhand des Index in Dest geschrieben
        C := Source.count - 1;
        for I := 0 to C do
          Dest.add(IntToStr(StrList.Find(Source.Strings[I])));

        // Gefundene Einträge werden gespeichert
        Dest.SaveToFile(Path + 'ergebnis.txt');
      finally
        Source.Free;
        Dest.Free;
      end;
    end;

  begin
    StrList := TTXStringList.create;

    try
      with StrList do
      begin
        S := LowerCase(Trim(txlibSettings.ReadString('TTXStringList',
          'SearchMethod', '')));
        if S = 'hash' then
          SearchMethod := smHash
        else if S = 'avl' then
          SearchMethod := smAVL
        else
          SearchMethod := smLinear;

        HashSize := txlibSettings.ReadInteger('TTXStringList',
          'Hashsize', 1024);
        CaseSensitive := txlibSettings.ReadBool('TTXStringList',
          'CaseSensitive', false);
        Trimmed := txlibSettings.ReadBool('TTXStringList', 'Trimmed', false);
        Umlaut := txlibSettings.ReadBool('TTXStringList', 'Umlaut', false);
      end;

      test := LowerCase(Trim(txlibSettings.ReadString('TTXStringList',
        'Test', '')));
      if test = 'search' then
        SearchTest;
    finally
      StrList.Free;
    end;
  end;

begin
  txlibSettings := TIniFile.create(Path + 'Test.ini');
  try
    test := LowerCase(Trim(txlibSettings.ReadString('Global', 'Test', '')));
    if test = 'stringlist' then
      TestStringList;
  finally
    txlibSettings.Free;
  end;
end;

procedure TFormCareServer.zipTest(Path: string);
const
  cTestArchiveName = 'test.zip';
var
  sTest: TStringList;
  sFiles: TStringList;
  sOptions: TStringList;
begin
  sTest := TStringList.create;

  //
  sTest.LoadFromFile(Path + 'Test.ini');
  sOptions := anfix32.Split(sTest.values['Options']);
  ersetze('~Path~', Path, sOptions);
  sFiles := anfix32.Split(sTest.values['Files']);
  ersetze('~Path~', Path, sFiles);

  if (sTest.values['Test'] = 'unzip') then
  begin
    unzip(Path + cTestArchiveName, Path, sOptions);
  end
  else
  begin
    zip(sFiles, Path + cTestArchiveName, sOptions);
  end;



  sFiles.Free;
  sOptions.Free;
  sTest.Free;
end;

procedure TFormCareServer.HashTest(Path: string);
var
  sTestData: TStringList;
  MD5s: TStringList;
  DCP_md51: TDCP_md5;
  n: Integer;
  BraketLevel: Integer;
  LineNo: Integer;
begin
  DCP_md51 := TDCP_md5.create(self);
  sTestData := TStringList.create;
  MD5s := TStringList.create;
  BraketLevel:= 0;
  LineNo:= 0;

  // MD5 Test
  sTestData.LoadFromFile(Path + 'Test-MD5.txt');
  for n := 0 to pred(sTestData.count) do
  begin

    if BraketLevel = 1 then
      inc(LineNo);

    if Length(sTestData[n]) = 1 then
    begin
      if pos('{', sTestData[n]) = 1 then
      begin
        inc(BraketLevel);
        LineNo := 0;
      end;
      if pos('}', sTestData[n]) = 1 then
        dec(BraketLevel);
    end;

    if (sTestData[n] = '#') then
    begin
      AppendStringsToFile(DCP_md51.FromStrings(MD5s), Path + 'MD5.txt');
      MD5s.clear;
    end
    else
    begin
      if (BraketLevel = 1) and (LineNo > 1) then
        MD5s.add(#$0D#$0A + sTestData[n])
      else
        MD5s.add(sTestData[n]);
    end;

  end;
  MD5s.Free;
  sTestData.Free;
end;

procedure TFormCareServer.Button10Click(Sender: TObject);
const
  cPath_ErgebnisSoll = 'Soll-Ergebnis\';
var
  sDiagnose: TStringList;
  nTest: tTestProc;
  FileCompare_UseSize: boolean;

  // Vergleichs-Methoden

  procedure sdir(root: string; sdir: TStringList);
  var
    n: Integer;
  begin
    anfix32.dir(root + '*.', sdir, false, true);
    for n := pred(sdir.count) downto 0 do
      if pos('.', sdir[n]) = 1 then
        sdir.delete(n);
    sdir.sort;
  end;

  function FilterTestSource(S: string): string;
  begin
    if pos('size_', S) = 1 then
    begin
      result := copy(S, 6, MaxInt);
      FileCompare_UseSize := true;
    end
    else
    begin
      result := S;
      FileCompare_UseSize := false;
    end;
  end;

  procedure SingleTest(NameSpace, TestName: string);
  var
    FullPath: string;
    TestSourceFName: string;
    sErgebnisseSoll: TStringList;
    n: Integer;
    _anfix32_DebugLogPath : string;
  begin
    sErgebnisseSoll := TStringList.create;
    FullPath := iFSPath + NameSpace + '\' + TestName + '\';
    _anfix32_DebugLogPath := anfix32.DebugLogPath;
    anfix32.TestMode := true; // suppress timestamps in Result
    anfix32.DebugLogPath := FullPath;

    // den Test durchführen!
    try
      // was gibt es für Ergebnisse?
      dir(FullPath + cPath_ErgebnisSoll + '*', sErgebnisseSoll, false);

      // Imp pend: Wenn es keine Vorgaben gibt muss es
      // einen Selbststest geben!

      // In einem früher ausgeführten Testlauf erstellte Dateien löschen
      for n := 0 to pred(sErgebnisseSoll.count) do
      begin
        TestSourceFName := FilterTestSource(sErgebnisseSoll[n]);
        if FileExists(FullPath + TestSourceFName) then
          FileDelete(FullPath + TestSourceFName);
      end;

      // der Test an sich!
      nTest(FullPath);

      // Es muss Vorgaben geben,
      if (sErgebnisseSoll.count = 0) then
        raise Exception.create('Keine Soll-Ergebnisse in ' + cPath_ErgebnisSoll);

      for n := 0 to pred(sErgebnisseSoll.count) do
      begin

        TestSourceFName := FilterTestSource(sErgebnisseSoll[n]);
        repeat

          // Datei-Grössen vergleichen
          if FileCompare_UseSize then
          begin
            if (FSize(FullPath + TestSourceFName) <>
              FSize(FullPath + cPath_ErgebnisSoll + sErgebnisseSoll[n])) then
              raise Exception.create('Grössenunterschiede bei "' +
                sErgebnisseSoll[n] + '"');
            break;
          end;

          // Ist die Datei überhaupt entstanden?
          if not(FileExists(FullPath + TestSourceFName)) then
            raise Exception.create('Ergebnisdatei "' + sErgebnisseSoll[n] +
              '" wurde nicht erzeugt');

          // Datei-Inhalte vergleichen
          if not(FileCompare(FullPath + TestSourceFName,
            FullPath + cPath_ErgebnisSoll + sErgebnisseSoll[n])) then
            raise Exception.create('Unterschiede bei "' + sErgebnisseSoll
              [n] + '"');
          break;

        until true;

      end;

    except
      on E: Exception do
      begin
        sDiagnose.add(cERRORText + TestName + '.' + NameSpace + ': ' +
          E.Message);
      end;
    end;

    anfix32.TestMode := false;
    anfix32.DebugLogPath := _anfix32_debugLogPath;

    sErgebnisseSoll.Free;
  end;

  function FilterMatch_NS(NameSpace: string): boolean;
  var
    sFilter: string;
  begin
    result := true;
    sFilter := nextp(Edit10.Text, '.', 1);
    repeat
      if (sFilter = '*') then
        break;
      if pos(NameSpace, sFilter) > 0 then
        break;
      // Fail
      result := false;
    until true;
  end;

  function FilterMatch_Test(NameTest: string): boolean;
  var
    sFilter: string;
  begin
    result := true;
    sFilter := nextp(Edit10.Text, '.', 0);
    repeat
      if (sFilter = '*') then
        break;
      if pos(NameTest, sFilter) > 0 then
        break;
      // Fail
      result := false;
    until true;
  end;

var
  sNameSpaces, sTests: TStringList;
  n, m: Integer;

begin
  // Test starten
  BeginHourGlass;
  ListBox2.items.clear;
  sNameSpaces := TStringList.create;
  sDiagnose := TStringList.create;
  sTests := TStringList.create;
  sdir(iFSPath, sNameSpaces);
  sNameSpaces.sort;
  for n := 0 to pred(sNameSpaces.count) do
  begin
    if FilterMatch_NS(sNameSpaces[n]) then
    begin

      // setzen der Testmethode!
      repeat

        if (sNameSpaces[n] = 'Oc') then
        begin
          nTest := OcTest;
          break;
        end;

        if (sNameSpaces[n] = 'txlib') then
        begin
          nTest := txlibTest;
          break;
        end;

        if (sNameSpaces[n] = 'zip') then
        begin
          nTest := zipTest;
          break;
        end;

        if (sNameSpaces[n] = 'Hash') then
        begin
          nTest := HashTest;
          break;
        end;

        if (sNameSpaces[n] = 'html') then
        begin
          nTest := htmlTest;
          break;
        end;

        nTest := nil;

      until true;

      // im pend: hier noch über das Anmeldesystem gehen

      if assigned(nTest) then
      begin

        sdir(iFSPath + sNameSpaces[n] + '\', sTests);
        sTests.sort;
        for m := 0 to pred(sTests.count) do
          if FilterMatch_Test(sTests[m]) then
          begin
            sDiagnose.clear;
            ListBox2.items.add(sTests[m] + '.' + sNameSpaces[n] + ' ...');
            application.processmessages;

            // Der Test an sich
            SingleTest(sNameSpaces[n], sTests[m]);

            ListBox2.items.addstrings(sDiagnose);
            application.processmessages;
          enD;

      end;
    end;
  end;
  ListBox2.items.add('ENDE');
  sNameSpaces.Free;
  sTests.Free;
  sDiagnose.Free;
  EndHourGlass;
end;


end.
