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
unit CareServer;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls,
  IniFiles,
  IdBaseComponent, IdComponent,  anfix,
   Grids,
  IB_Grid, IB_Components, IB_UpdateBar, IB_Access,
  IdExplicitTLSClientServerBase, IdSMTPBase, IB_Controls,
  Buttons, IdUDPBase, IdUDPClient, IdSNMP,
  CareTakerClient;

type
  TFormCareServer = class(TForm)
    PageControl1: TPageControl;
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
    TabSheet2: TTabSheet;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Label11: TLabel;
    Button7: TButton;
    Edit6: TEdit;
    Label12: TLabel;
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
    procedure Button7Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
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
    Initialized: boolean;

  public
    { Public-Deklarationen }
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
  globals, systemd, wanfix, html, c7zip,

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

procedure TFormCareServer.Button7Click(Sender: TObject);
begin
  Edit3.Text := rfc1738toAnsi(Edit5.Text);
end;

procedure TFormCareServer.Button9Click(Sender: TObject);
begin
  Edit9.Text := deCrypt_Hex(Edit9.Text);
end;

procedure TFormCareServer.addTest(NameSpace: string; test: tTestProc);
begin
  //
end;

procedure TFormCareServer.addTest(NameSpace: string; test: tSelfTestProc);
begin
  //
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

const
 Putty_app : string = '';
 cPutty = 'PuTTY\putty.exe';

procedure ensurePutty;
begin
 if (Putty_app='') then
 begin

  repeat

    Putty_app := 'C:\Program Files\' + cPutty;
    if FileExists(Putty_app) then
      break;

    Putty_app := ProgramFilesDir + cPutty;
    if FileExists(Putty_app) then
      break;

    Putty_app := 'C:\Program Files (x86)\' + cPutty;
    if FileExists(Putty_app) then
      break;

    raise Exception.create('Keine ' +  cPutty + '-Installation gefunden!');

  until yet;
  Putty_app := '"' + Putty_app + '"';

 end;
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

  ensurePutty;

  RunExternalApp(
    { App } Putty_app +
    { Cmd } ' -ssh ' +
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
      repeat
        ServerName := sSettings.values['firebird-host'];
        if (ServerName<>'') then
         break;
        ServerName := sSettings.values['ssh-host'];
        if (ServerName<>'') then
         break;
        ServerName := IB_Query4.FieldByName('HOST').AsString;
      until yet;

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


procedure TFormCareServer.FormActivate(Sender: TObject);
var
  cHOSTS: TIB_Cursor;
begin
  BeginHourGlass;
  if not(Initialized) then
  begin

    caption := 'Pflege Arbeitsplatz - [' + MachineID + ']';
    PageControl1.ActivePage := TabSheet5;

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

procedure TFormCareServer.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Ticket');
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
  sOptions := anfix.Split(sTest.values['Options']);
  ersetze('~Path~', Path, sOptions);
  sFiles := anfix.Split(sTest.values['Files']);
  ersetze('~Path~', Path, sFiles);

  if (sTest.values['Test'] = 'unzip') then
  begin
    // imp pend: check result-Value too!?
    unzip(Path + cTestArchiveName, Path, sOptions);
  end
  else
  begin
    // imp pend: check result-Value too!?
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
    anfix.dir(root + '*.', sdir, false, true);
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
    _anfix_DebugLogPath : string;
  begin
    sErgebnisseSoll := TStringList.create;
    FullPath := iFSPath + NameSpace + '\' + TestName + '\';
    _anfix_DebugLogPath := anfix.DebugLogPath;
    anfix.TestMode := true; // suppress timestamps in Result
    anfix.DebugLogPath := FullPath;

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

    anfix.TestMode := false;
    anfix.DebugLogPath := _anfix_debugLogPath;

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
