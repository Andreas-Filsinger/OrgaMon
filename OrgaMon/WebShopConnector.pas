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
unit WebShopConnector;
{$IFDEF CONSOLE}
{$MESSAGE FATAL 'Prüfe Abhängigkeit: Diese Unit hat GUI'}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,

  // XML RPC
  srvXMLRPC,
  wordindex,
  eConnect,

  // memcache
  memcache,

  // IBO
  IB_Components, IB_Access,

  // Indy
  IdFTP, Vcl.Buttons, IdServerIOHandler, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer,
  IdServerInterceptLogEvent, IdIntercept, IdServerInterceptLogBase, IdContext;

const
  // cXML_RPC_namespace = 'abu';
  cXML_RPC_namespace = '*';

type
  TFormWebShopConnector = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    StaticText1: TStaticText;
    CheckBox2: TCheckBox;
    Button1: TButton;
    Edit1: TEdit;
    Button4: TButton;
    Timer1: TTimer;
    TabSheet2: TTabSheet;
    Button5: TButton;
    CheckBox3: TCheckBox;
    Label4: TLabel;
    Label5: TLabel;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    Label6: TLabel;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    StaticText8: TStaticText;
    TabSheet3: TTabSheet;
    Button6: TButton;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    CheckBox10: TCheckBox;
    Edit2: TEdit;
    Edit3: TEdit;
    ProgressBar2: TProgressBar;
    CheckBoxAbbruch: TCheckBox;
    ListBoxLog: TListBox;
    Label7: TLabel;
    Button2: TButton;
    TabSheet4: TTabSheet;
    Button11: TButton;
    CheckBox4: TCheckBox;
    Button12: TButton;
    Button13: TButton;
    Panel1: TPanel;
    Button14: TButton;
    Label12: TLabel;
    StaticText9: TStaticText;
    CheckBox1: TCheckBox;
    CheckBox5: TCheckBox;
    TabSheet5: TTabSheet;
    ComboBox1: TComboBox;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Button3: TButton;
    TabSheet6: TTabSheet;
    Label17: TLabel;
    Edit7: TEdit;
    Button15: TButton;
    Edit8: TEdit;
    Button16: TButton;
    Button17: TButton;
    Label18: TLabel;
    Label19: TLabel;
    Button18: TButton;
    Edit9: TEdit;
    Button19: TButton;
    Button20: TButton;
    SpeedButton1: TSpeedButton;
    Button21: TButton;
    Label20: TLabel;
    Label21: TLabel;
    Edit10: TEdit;
    Edit11: TEdit;
    TabSheet7: TTabSheet;
    IdHTTPServer1: TIdHTTPServer;
    IdServerIOHandlerSSLOpenSSL1: TIdServerIOHandlerSSLOpenSSL;
    IdServerInterceptLogEvent1: TIdServerInterceptLogEvent;
    Button22: TButton;
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Button9Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button4Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure TabSheet5Show(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure IdServerInterceptLogEvent1LogString(
      ASender: TIdServerInterceptLogEvent; const AText: string);
    procedure IdHTTPServer1QuerySSLPort(APort: Word; var VUseSSL: Boolean);
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure Button22Click(Sender: TObject);

  private
    { Private declarations }

    // globals
    FirstTimerEventChecked: boolean;

    // TimerSachen
    TimerState: integer;
    TimerTicks: longword;

    // XMLRPC - Sachen
    XServer: TXMLRPC_Server;
    XMethods: TeConnect;
    ConnectorExceptions: integer;

    // Memcache - Sachen
    MClient: TmemcacheClient;

    // FTP
    IdFTP1: TIdFTP;
    SummeUploadFSize: int64;
    pSiteHost: string;
    pSiteAction: string;

    procedure Log(const Msg: string);

    //
    procedure setLAUFNUMMER;
    function dumpMySQL: integer; // [ArtikelAnzahl]
    function dumpUP: boolean;
    function dumpON: boolean;
    function ArtikelDump: boolean;

  public
    procedure UpdateClicksCount; overload;
    procedure UpdateClicksCount(Clicks: integer); overload;

    // Key-Sachen
    function genLink(ARTIKEL_R: integer): string;

    // Caching-Sachen
    procedure EnsureCache;

    // Externe Calls
    function doMediumBuilder: boolean;
    function doContenBuilder: boolean;

    // XMLRPC-Server
    function XMLRPC_Running: boolean;
    procedure XMLRPC_Assign;
    procedure XMLRPC_Start;
    procedure XMLRPC_Stop;
    function XMLRPC_Clicks(DecrementBy: integer = 0): integer;

  end;

var
  FormWebShopConnector: TFormWebShopConnector;

implementation

{$R *.dfm}

uses
  math, geld, anfix32,
  globals, Datenbank, Person,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  SimplePassword, html,
  DateUtils, CareTakerClient,
  gplists, OLAP, SolidFTP,
  DCPcrypt2, DCPblockciphers, DCPblowfish,
  DCPbase64, ArtikelVerlag,
  IdHttp,

  JclBase, JvclVer,
  dbOrgaMon,
  SystemPflege, REST, main;

const
  cMySQLdumpFName = 'mysql.dump-%s.txt';
  cMySQLclearFName = 'mysql.delete.txt';

procedure TFormWebShopConnector.TabSheet5Show(Sender: TObject);
begin
  XMLRPC_Assign;
  ComboBox1.Items.Assign(XServer.Methods);
end;

procedure TFormWebShopConnector.Timer1Timer(Sender: TObject);
var
  _WebShopClicks: integer;
begin

  if NoTimer then
    exit;
  if not(AllSystemsRunning) then
    exit;

  // Durchläufe des Timers zählen
  inc(TimerTicks);
  if TimerTicks mod 2 = 0 then
    Panel1.color := clred
  else
    Panel1.color := cllime;

  //
  if not(FirstTimerEventChecked) then
  begin
    FirstTimerEventChecked := true;
    if pDisableXMLRPC then
    begin
      TimerState := 3;
      Log('eAPIs wurden deaktiviert!');
    end;
  end;

  //
  case TimerState of
    0:
      begin

        // XML- RPC
        if (AnSiUpperCase(ComputerName) = AnSiUpperCase(iXMLRPCHost)) then
        begin
          TimerState := 1;
          XMLRPC_Start;
          FormMain.panel2.color := cllime;
        end
        else
        begin
          Log('XML-RPC: ' + iXMLRPCHost + ' ist Server ...');
          TimerState := 3;
        end;

        // REST
        if (AnSiUpperCase(ComputerName) = AnSiUpperCase(iRESTHost)) then
        begin
          DataModuleREST.start;
          CheckBox4.Checked := true;
          FormMain.panel2.color := cllime;
        end
        else
        begin
          CheckBox4.caption := iRESTHost + ' ist Server';
        end;
      end;
    1:
      ; // Initializing ...
    2: // !Server online!
      begin
        _WebShopClicks := XMLRPC_Clicks;

        if (_WebShopClicks > 0) then
        begin

          (*
            with IB_Query2 do
            begin
            ParamByName('CROSSREF').AsDate := today;
            if not(active) then
            Open
            else
            refresh;

            if eof then
            begin
            insert;
            FieldByName('CLICKS').AsINteger := _WebShopClicks;
            post;
            end
            else
            begin
            edit;
            FieldByName('CLICKS').AsINteger := FieldByName('CLICKS')
            .AsINteger + _WebShopClicks;
            post;
            end;
            UpdateClicksCount(FieldByName('CLICKS').AsINteger);
            end;
          *)
          XMLRPC_Clicks(_WebShopClicks);

        end;
      end;
    3: // please dont waste time and stop!
      begin
        Log('Timer ist aus');
        Timer1.enabled := false;
      end;
  end;

  //
end;

procedure TFormWebShopConnector.Log(const Msg: string);
begin
  with ListBoxLog do
  begin
    Items.Add(Msg);
    ItemIndex := pred(Items.count);
  end;
  if pos(cERRORText, Msg) = 1 then
  begin
    CareTakerLog(Msg);
    if (pos(' rpc_e_', Msg) > 0) and (pos('Zugriffsverletzung', Msg) = 0) then
      inc(ConnectorExceptions);
    if (ConnectorExceptions >= 12) then
    begin
      e_w_Ticket('Es gab XML-RPC-Exceptions!');
      WindowsNeuStarten;
    end;
  end;
  application.processmessages;
end;

procedure TFormWebShopConnector.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet1;
  IdFTP1 := TIdFTP.Create(self);
end;

function TFormWebShopConnector.genLink(ARTIKEL_R: integer): string;
begin
  EnsureCache;
  Result := pSiteHost + pSiteAction;
  ersetze('~id~', e_r_ArtikelLink(ARTIKEL_R), Result);
end;

procedure TFormWebShopConnector.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
 ListBoxLog.items.Add('Get');
end;

procedure TFormWebShopConnector.IdHTTPServer1QuerySSLPort(APort: Word;
  var VUseSSL: Boolean);
begin
 ListBoxLog.items.Add('QuerySSLPort: '+Inttostr(APort));
 VUseSSL := true;
end;

procedure TFormWebShopConnector.IdServerInterceptLogEvent1LogString(
  ASender: TIdServerInterceptLogEvent; const AText: string);
begin
 ListBoxLog.items.add(AText);
end;

// OnWork

{
  procedure TFormWebShopConnector.IdFTP1Work(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCount: Integer);
  begin
  if frequently(FTPStartTime, 500) then
  begin
  StaticText4.caption := inttostr(SummeUploadFSize + AWorkCount);
  application.processmessages;
  sleep(125);
  end;
  end;

}

procedure TFormWebShopConnector.FormActivate(Sender: TObject);
begin
  UpdateClicksCount;
end;

procedure TFormWebShopConnector.UpdateClicksCount;
begin
  (*
    with IB_Query2 do
    begin
    ParamByName('CROSSREF').AsDate := today;
    if not(active) then
    Open
    else
    refresh;
    UpdateClicksCount(FieldByName('CLICKS').AsINteger);
    end;
  *)
end;

procedure TFormWebShopConnector.UpdateClicksCount(Clicks: integer);
begin
  StaticText1.caption := datum + ' : ' + inttostr(Clicks);
end;

procedure TFormWebShopConnector.XMLRPC_Assign;
begin
  if not(assigned(XServer)) then
  begin
    XMethods := TeConnect.Create;
    XMethods.Init;
    XServer := TXMLRPC_Server.Create(self);
    with XServer do
    begin
      // TCP-Sachen
      DefaultPort := StrToIntDef(iXMLRPCPort, 80);
      DiagnosePath := globals.DiagnosePath;

      // Methoden anmelden
      AddMethod('ArtikelSuche', XMethods.rpc_e_r_ArtikelSuche);
      AddMethod('ArtikelPreis', XMethods.rpc_e_r_ArtikelPreis);
      AddMethod('KontoInfo', XMethods.rpc_e_r_KontoInfo);
      AddMethod('BestellInfo', XMethods.rpc_e_r_BestellInfo);
      AddMethod('Land', XMethods.rpc_e_r_Land);
      AddMethod('Bestellen', XMethods.rpc_e_w_Bestellen);
      AddMethod('Buchen', XMethods.rpc_e_w_Buchen);
      AddMethod('ArtikelVersendetag', XMethods.rpc_e_r_ArtikelVersendetag);
      AddMethod('Verlag', XMethods.rpc_e_r_Verlag);
      AddMethod('Versandkosten', XMethods.rpc_e_r_Versandkosten);
      AddMethod('ArtikelInfo', XMethods.rpc_e_r_ArtikelInfo);
      AddMethod('BasePlug', XMethods.rpc_e_r_BasePlug);
      AddMethod('ArtikelRabattPreis', XMethods.rpc_e_r_ArtikelRabattPreis);
      AddMethod('PersonNeu', XMethods.rpc_e_w_PersonNeu);
      AddMethod('Ort', XMethods.rpc_e_r_Ort);
      AddMethod('Rabatt', XMethods.rpc_e_r_Rabatt);
      AddMethod('Preis', XMethods.rpc_e_r_Preis);
      AddMethod('Miniscore', XMethods.rpc_e_w_Miniscore);
      AddMethod('LoginInfo', XMethods.rpc_e_w_LoginInfo);
      AddMethod('Skript', XMethods.rpc_e_w_Skript);
      AddMethod('NextVal', XMethods.rpc_e_w_NextVal);
    end;
  end;

end;

function TFormWebShopConnector.XMLRPC_Clicks(DecrementBy: integer = 0): integer;
begin
  Result := 0;
  if assigned(XServer) then
  begin
    dec(XMethods.WebShopClicks, DecrementBy);
    Result := XMethods.WebShopClicks;
  end;
end;

function TFormWebShopConnector.XMLRPC_Running: boolean;
begin
  Result := false;
  if assigned(XServer) then
    Result := XServer.active;
end;

procedure TFormWebShopConnector.XMLRPC_Start;
begin
  XMLRPC_Assign;

  with XServer do
  begin
    active := true;
    Log('XML-RPC-Server wurde gestartet (' + ComputerName + ':' + inttostr(DefaultPort) + ')');
  end;

  Timer1.enabled := true;
  TimerState := 2;

end;

procedure TFormWebShopConnector.XMLRPC_Stop;
begin
  if assigned(XServer) then
    with XServer do
    begin
      active := false;
      Log('XML-RPC-Server wurde gestoppt');
    end;

end;

function TFormWebShopConnector.doContenBuilder: boolean;
begin
  show;
  PageControl1.ActivePage := TabSheet3;
  Result := ArtikelDump;
  close;
end;

function TFormWebShopConnector.doMediumBuilder: boolean;
begin
  show;
  PageControl1.ActivePage := TabSheet2;
  Button5Click(self);
  close;
  Result := true;
end;

procedure TFormWebShopConnector.setLAUFNUMMER;
var
  ARTIKEL_R: TgpIntegerList;
  RecCount: integer;
  PatchIndex: integer;
begin
  BeginHourGlass;
  try
    // alternative Numeros erst mal setzen!
    ARTIKEL_R := e_r_sqlm('select RID from ARTIKEL where LAUFNUMMER is null');
    repeat

      //
      RecCount := ARTIKEL_R.count;
      if (RecCount = 0) then
        break;
      if (RecCount > 1) then
        PatchIndex := random(RecCount)
      else
        PatchIndex := 0;

      //
      e_x_sql('update ARTIKEL set LAUFNUMMER=' + inttostr(e_w_GEN('GEN_ARTIKEL_LAUFNUMMER')) +
        ' where RID=' + inttostr(ARTIKEL_R[PatchIndex]));
      ARTIKEL_R.Delete(PatchIndex);

    until false;
    ARTIKEL_R.free;
  except
    on e: exception do
    begin
      Log(cERRORText + ' ' + e.Message);
    end;
  end;
  EndHourGlass;
  Log('OK: setLAUFNUMMER!')
end;

procedure TFormWebShopConnector.SpeedButton1Click(Sender: TObject);
begin
  Edit7.Text := imemcachedHost;
end;

procedure TFormWebShopConnector.EnsureCache;
begin
  if (pSiteHost = '') then
  begin
    pSiteHost := nextp(iShopLink, ',', 0);
    pSiteAction := nextp(iShopLink, ',', 1);
  end;
end;

procedure TFormWebShopConnector.Button20Click(Sender: TObject);
begin
  MClient.exist(Edit8.Text);
  ListBoxLog.Items.Add(MClient.LastError);
end;

procedure TFormWebShopConnector.Button21Click(Sender: TObject);
begin
  MClient.purge;
  ListBoxLog.Items.Add(MClient.LastError);
end;

procedure TFormWebShopConnector.Button22Click(Sender: TObject);
begin
 IdHTTPServer1.Active := true;
end;

procedure TFormWebShopConnector.Button2Click(Sender: TObject);
begin
  ListBoxLog.Items.clear;
end;

procedure TFormWebShopConnector.Button3Click(Sender: TObject);
var
  Parameter: TStringList;
begin
  ListBoxLog.Items.clear;
  Parameter := TStringList.Create;
  with Edit4 do
    if (Text <> '') then
      Parameter.AddObject(Text, TXMLRPC_Server.oInteger);
  with Edit5 do
    if (Text <> '') then
      Parameter.AddObject(Text, TXMLRPC_Server.oInteger);
  with Edit6 do
    if (Text <> '') then
      Parameter.AddObject(Text, TXMLRPC_Server.oInteger);
  if (Edit10.Text='') then
   ListBoxLog.Items.AddStrings(XServer.exec(ComboBox1.Text, Parameter))
  else
   ListBoxLog.Items.AddStrings(remote_exec(Edit10.Text,STrToIntDef(Edit11.Text,3049), ComboBox1.Text, Parameter))
end;

procedure TFormWebShopConnector.Button10Click(Sender: TObject);
begin
  dumpON;
end;

procedure TFormWebShopConnector.Button11Click(Sender: TObject);
begin
  DataModuleREST.start;
end;

procedure TFormWebShopConnector.Button12Click(Sender: TObject);
begin
  XMLRPC_Start;
end;

procedure TFormWebShopConnector.Button13Click(Sender: TObject);
begin
  XMLRPC_Stop;
end;

procedure TFormWebShopConnector.Button14Click(Sender: TObject);
const
  RemoteMusikFName = '10000.mp3';
var
  RemoteFSize: int64;
  pShopMusicPath: string;
begin
  SolidBeginTransaction;
  SolidInit(IdFTP1);
  with IdFTP1 do
  begin
    Passive := true;
    Host := nextp(iShopkonto, ',', 0);
    UserName := nextp(iShopkonto, ',', 1);
    Password := nextp(iShopkonto, ',', 2);
    pShopMusicPath := nextp(iShopkonto, ',', 3);
    connect;
    ChangeDir(pShopMusicPath);
    Log('Subdir is ' + RetrieveCurrentDir + ' ...');
    RemoteFSize := Size(RemoteMusikFName);
    Log(format('Size(%s)=%d', [RemoteMusikFName, RemoteFSize]));
    Disconnect;
  end;
  SolidEndTransaction;
end;

procedure TFormWebShopConnector.Button15Click(Sender: TObject);
begin
  if not(assigned(MClient)) then
  begin
    MClient := TmemcacheClient.Create(self);
    MClient.open(Edit7.Text);
    Button16.enabled := true;
    Button17.enabled := true;
    Button18.enabled := true;
    Button19.enabled := true;
    Button20.enabled := true;
    Button21.enabled := true;
  end;
  ListBoxLog.Items.Add(MClient.Version);
end;

procedure TFormWebShopConnector.Button16Click(Sender: TObject);
begin
  Edit9.Text := MClient.read(Edit8.Text);
  ListBoxLog.Items.Add(MClient.LastError);
end;

procedure TFormWebShopConnector.Button17Click(Sender: TObject);
begin
  MClient.write(Edit8.Text, Edit9.Text);
  ListBoxLog.Items.Add(MClient.LastError);
end;

procedure TFormWebShopConnector.Button18Click(Sender: TObject);
begin
  Edit9.Text := inttostr(MClient.inc(Edit8.Text));
  ListBoxLog.Items.Add(MClient.LastError);
end;

procedure TFormWebShopConnector.Button19Click(Sender: TObject);
begin
  MClient.Delete(Edit8.Text);
  ListBoxLog.Items.Add(MClient.LastError);
end;

procedure TFormWebShopConnector.Button1Click(Sender: TObject);
var
  cPERSON: TIB_Cursor;
  ZwangsErmittlung: integer;
begin
  BeginHourGlass;
  ZwangsErmittlung := 0;
  cPERSON := DataModuleDatenbank.nCursor;
  with cPERSON do
  begin
    sql.Add('select RID from PERSON where');
    sql.Add(' (USER_ID is not null) and');
    sql.Add(' ((USER_PWD is null) or (USER_PWD = ''''))');
    ApiFirst;
    while not(eof) do
    begin
      e_x_sql('update PERSON set USER_PWD=''' + FindANewPassword('', 5) + ''' where RID=' +
        FieldByName('RID').AsString);
      ApiNext;
      inc(ZwangsErmittlung);
    end;
  end;
  cPERSON.free;
  Label1.caption := inttostr(ZwangsErmittlung) + ' eingetragen!';
  EndHourGlass;
end;

procedure TFormWebShopConnector.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    Button4Click(Sender);
  end;
end;

procedure TFormWebShopConnector.Edit2KeyPress(Sender: TObject; var Key: Char);
var
  ARTIKEL_R: integer;
begin
  if Key = #13 then
  begin
    Key := #0;

    // Rechne den RID um in einen Key
    ARTIKEL_R := StrToIntDef(Edit2.Text, 0);
    Edit3.Text := genLink(ARTIKEL_R);
  end;
end;

procedure TFormWebShopConnector.Button4Click(Sender: TObject);
var
  cPERSON: TIB_Cursor;
begin
  cPERSON := DataModuleDatenbank.nCursor;
  with cPERSON do
  begin
    sql.Add('select RID from PERSON where USER_ID=''' + Edit1.Text + '''');
    ApiFirst;
    if eof then
      ShowMessage('Nicht gefunden!')
    else
      FormPerson.SetContext(FieldByName('RID').AsINteger);
  end;
end;

procedure TFormWebShopConnector.Button5Click(Sender: TObject);

  function member(RID: integer; Club: TgpIntegerList): boolean;
  begin
    if assigned(Club) then
      Result := (Club.IndexOf(RID) <> -1)
    else
      Result := false;
  end;

var
  // Listen der Referenznummern
  ARTIKEL: TgpIntegerList; // Alle Artikel
  WEBSHOP: TgpIntegerList; // Alle Artikel des WebShop
  MUSIC: TgpIntegerList; // Alle die Music haben dürfen
  BEMERKUNG: TgpIntegerList;

  w, n: integer;
  ARTIKEL_R: integer;
  IsExternalEmpty: boolean;
  IsFTP: boolean;
  IsFTPup: boolean;
  IsFTPdel: boolean;
  pShopMusicPath: string;

  _NUMERO: string;
  _LAUFNUMMER: string;
  _TRACKS: string;
  LocalMusikFName: TStringList;
  RemoteMusikFName: TStringList;

  ExterneLinks: TStringList;
  ExterneLinksModyfied: boolean;
  DOKUMENT_R: integer;
  qDOKUMENT: TIB_Query;

  //
  LocalFSize: int64;
  RemoteFSize: int64;
  SummeLocalFSize: int64;
  SummeRemoteFSize: int64;

  SummeFTPFehler: integer;
  SummeLocalCount: integer;
  SummeRemoteCount: integer;
  SummeUploadCount: integer;
  SummeModifiedLinksCount: integer;

  // Timing Sachen
  StartTime: dword;

  // Fehlerbehandlung
  FTPError: boolean;
  FTPLastError: string;

  procedure locateArtikel(ARTIKEL_R: integer);
  var
    cARTIKEL: TIB_Cursor;
  begin
    cARTIKEL := DataModuleDatenbank.nCursor;
    with cARTIKEL do
    begin
      sql.Add('select NUMERO,LAUFNUMMER from ARTIKEL where RID=' + inttostr(ARTIKEL_R));
      ApiFirst;
      _NUMERO := FieldByName('NUMERO').AsString;
      _LAUFNUMMER := FieldByName('LAUFNUMMER').AsString;
    end;
    cARTIKEL.free;
  end;

  function getReferences(ARTIKEL_R: integer): TStringList;
  var
    cDOKUMENT: TIB_Cursor;
  begin
    Result := nil;
    cDOKUMENT := DataModuleDatenbank.nCursor;
    with cDOKUMENT do
    begin
      sql.Add(
        { } 'select BEMERKUNG from DOKUMENT where ' +
        { } ' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') and' +
        { } ' (MEDIUM_R=1) and' +
        { } ' (BEMERKUNG is not null)');
      ApiFirst;
      repeat
        if eof then
          break;
        Result := TStringList.Create;
        FieldByName('BEMERKUNG').Assignto(Result);
      until true;
    end;
    cDOKUMENT.free;
  end;

// true if target "sl" was modified
  function EnsureEntry(id,tracks: string; sl: TStringList): boolean;
  var
    n: integer;
    TheNewLink: string;
    IsPerfect: boolean;
    ChangeCount: integer;
    DeleteCount: integer;
  begin
    ChangeCount := 0;

    // remove duplicates
    RemoveDuplicates(sl, DeleteCount);
    if (DeleteCount > 0) then
      inc(ChangeCount);

    // remove old entries
    TheNewLink := pSiteHost + pSiteAction;
    ersetze('~id~', id, TheNewLink);
    ersetze('~tracks~', tracks, TheNewLink);
    IsPerfect := false;
    for n := pred(sl.count) downto 0 do
      if (pos(pSiteHost, sl[n]) = 1) then
      begin
        if (sl[n] = TheNewLink) then
        begin
          IsPerfect := true
        end
        else
        begin
          // Alte Einträge Löschen
          sl.Delete(n);
          inc(ChangeCount);
        end;
      end;

    // add the new one?
    if not(IsPerfect) then
    begin
      sl.Add(TheNewLink);
      inc(ChangeCount);
    end;

    Result := (ChangeCount > 0);
  end;

  function RemoveEntry(sl: TStringList): boolean;
  var
    n: integer;
    ChangeCount: integer;
    DeleteCount: integer;
  begin
    ChangeCount := 0;

    // remove duplicates
    RemoveDuplicates(sl, DeleteCount);
    if (DeleteCount > 0) then
      inc(ChangeCount);

    // remove valids
    for n := pred(sl.count) downto 0 do
      if (pos(pSiteHost, sl[n]) = 1) then
      begin
        sl.Delete(n);
        inc(ChangeCount);
      end;
    Result := (ChangeCount > 0);
  end;

  procedure EnsureUp(LocalMusikFName, RemoteMusikFName: string);
  begin

    LocalFSize := FSize(LocalMusikFName);
    if (LocalFSize > 0) then
    begin

      Log(LocalMusikFName + ' ...');
      inc(SummeLocalFSize, max(0, LocalFSize));
      inc(SummeLocalCount);

      // Datei sicherstellen.
      if IsFTPup then
      begin

        with IdFTP1 do
        begin

          if not(connected) then
          begin
            connect;
            ChangeDir(pShopMusicPath);
            Log('Subdir is ' + RetrieveCurrentDir + ' ...');
          end;

          RemoteFSize := Size(RemoteMusikFName);
          Log(format('Size(%s)=%d', [RemoteMusikFName, RemoteFSize]));

          inc(SummeRemoteFSize, max(0, RemoteFSize));

          // Unterschied in der Dateigrösse?
          // ev. noch einbauen:
          // Date(local)>Date(remote)
          if (RemoteFSize <> LocalFSize) then
          begin
            Log(RemoteMusikFName + ' hochladen');

            if SolidPut(IdFTP1, LocalMusikFName, pShopMusicPath, RemoteMusikFName) then
            begin
              SummeFTPFehler := 0;
              inc(SummeUploadFSize, LocalFSize);
            end
            else
            begin
              Log(cERRORText + ': FTP Error!');
              FTPError := true;
            end;
            inc(SummeUploadCount);

          end
          else
          begin
            SummeFTPFehler := 0;
            inc(SummeRemoteCount);
          end;
        end;
      end;
    end
    else
    begin
      Log(cERRORText + ': Datei "' + LocalMusikFName + '" nicht gültig!');
    end;
  end;

  procedure FTPini;
  begin
    SolidInit(IdFTP1);
    if IsFTP then
    begin
      with IdFTP1 do
      begin
        Passive := true;
        Host := nextp(iShopkonto, ',', 0);
        UserName := nextp(iShopkonto, ',', 1);
        Password := nextp(iShopkonto, ',', 2);
      end;
      pShopMusicPath := nextp(iShopkonto, ',', 3);
    end;

  end;

begin
  if not(FileExists(iOlapPath + 'Artikel.des.Webshop' + cOLAPExtension)) then
    exit;

  //
  BeginHourGlass;
  LocalMusikFName := TStringList.Create;
  RemoteMusikFName := TStringList.Create;

  EnsureCache;

  // Logging initialisieren
  Log('Vorlauf ...');

  IsFTPup := CheckBox3.Checked;
  IsFTPdel := CheckBox10.Checked;
  IsFTP := IsFTPup or IsFTPdel;

  // FTP vorbereiten!
  SolidBeginTransaction;
  FTPini;

  //
  SummeLocalFSize := 0;
  SummeRemoteFSize := 0;
  SummeUploadFSize := 0;
  SummeLocalCount := 0;
  SummeRemoteCount := 0;
  SummeUploadCount := 0;

  SummeModifiedLinksCount := 0;

  StartTime := 0;
  FTPError := false;
  SummeFTPFehler := 0;

  // Vorlauf "ARTIKEL"
  ARTIKEL := e_r_sqlm('select RID from ARTIKEL where LAUFNUMMER is not null');
  Log(inttostr(ARTIKEL.count) + ' relevante Artikel (mit LAUFNUMMER)');
  ProgressBar2.max := ARTIKEL.count;

  // Wer darf in den WebShop
  WEBSHOP := FormOLAP.OLAP('Artikel.des.Webshop');
  Log(inttostr(WEBSHOP.count) + ' Artikel im WebShop');

  // Wer darf öffentlich dokumentiert werden?
  MUSIC := FormOLAP.OLAP('Musik aus externen Links');
  Log(inttostr(MUSIC.count) + ' Artikel mit MP3 Erlaubnis');

  // Wer darf
  BEMERKUNG := e_r_sqlm(
    { } 'select ARTIKEL_R from DOKUMENT where ' +
    { } '(MEDIUM_R=1) and ' +
    { } '(BEMERKUNG is not null)');
  Log(inttostr(BEMERKUNG.count) + ' Artikel mit externen Links!');

  for w := 0 to pred(ARTIKEL.count) do
  begin

    try
      //
      ARTIKEL_R := ARTIKEL[w];

      if member(ARTIKEL_R, WEBSHOP) then
      begin

        ExterneLinksModyfied := false;

        // Laden von Informationen aus dem Artikel!
        locateArtikel(ARTIKEL_R);

        // Ist eine/mehrere MP3s da?! ->
        RemoteMusikFName.clear;
        dir(iMusicPath + _NUMERO + iShopMP3, LocalMusikFName, false);
        LocalMusikFName.sort;
        for n := 0 to pred(LocalMusikFName.count) do
        begin

          LocalMusikFName[n] := iMusicPath + LocalMusikFName[n];
          if (n = 0) then
            RemoteMusikFName.Add(_LAUFNUMMER + '.mp3')
          else
            RemoteMusikFName.Add(_LAUFNUMMER + chr(pred(ord('A') + n)) + '.mp3');
        end;
        _TRACKS := IntToStr(RemoteMusikFname.Count);

        //
        if member(ARTIKEL_R, MUSIC) then
        begin

          // sind Links da?
          ExterneLinks := getReferences(ARTIKEL_R);

          // Ist die Datei da?
          for n := 0 to pred(LocalMusikFName.count) do
            EnsureUp(LocalMusikFName[n], RemoteMusikFName[n]);

          if (LocalMusikFName.count = 0) then
          begin

            // Referenz(+Datei) löschen, da scheinbar wegegnommen
            if assigned(ExterneLinks) then
              ExterneLinksModyfied := RemoveEntry(ExterneLinks);

          end
          else
          begin

            // es kommt auf alle Fälle ein Eintrag hinzu!
            if not(assigned(ExterneLinks)) then
              ExterneLinks := TStringList.Create;

            ExterneLinksModyfied := EnsureEntry(e_r_ArtikelLink(ARTIKEL_R),_TRACKS, ExterneLinks);
          end;

        end
        else
        begin

          if member(ARTIKEL_R, BEMERKUNG) then
          begin
            // kontrollieren, ob hier ein Link eingetragen ist
            // sind Links da?
            ExterneLinks := getReferences(ARTIKEL_R);
            ExterneLinksModyfied := RemoveEntry(ExterneLinks);
          end;

          if (ExterneLinksModyfied) and IsFTPdel then
          begin
            // jetzt auch nachsehen, ob es noch die Datei gibt!
            with IdFTP1 do
            begin
              if not(connected) then
                connect;
              for n := 0 to pred(RemoteMusikFName.count) do
                DeleteFile(pShopMusicPath + RemoteMusikFName[n]);
            end;
          end;

        end;

        if ExterneLinksModyfied then
        begin

          inc(SummeModifiedLinksCount);

          // Bestimmung, ob es darum geht "Nichts zu speichern"
          if assigned(ExterneLinks) then
            IsExternalEmpty := (ExterneLinks.count = 0)
          else
            IsExternalEmpty := true;

          if (IsExternalEmpty) then
          begin
            // die Liste ist nun leer, ->kann gelöscht werden!
            Log(inttostr(ARTIKEL_R) + ' free Links!');
            e_x_sql(
              { } 'delete from DOKUMENT where' +
              { } ' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') and' +
              { } ' (MEDIUM_R=1)');
          end
          else
          begin

            // Link abändern!
            DOKUMENT_R := e_r_sql(
              { } 'select RID from DOKUMENT where ' +
              { } ' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') and' +
              { } ' (MEDIUM_R=1)');

            qDOKUMENT := DataModuleDatenbank.nQuery;
            with qDOKUMENT do
            begin
              if DOKUMENT_R = 0 then
              begin

                // Neuanlage!
                Log(inttostr(ARTIKEL_R) + ' new Links!');
                sql.Add('select * from DOKUMENT for update');
                insert;
                FieldByName('RID').AsINteger := 0;
                FieldByName('ARTIKEL_R').AsINteger := ARTIKEL_R;
                FieldByName('MEDIUM_R').AsINteger := 1;
                FieldByName('BEMERKUNG').Assign(ExterneLinks);
                post;

              end
              else
              begin

                // Update!
                Log(inttostr(ARTIKEL_R) + ' update Links!');
                sql.Add('select BEMERKUNG from DOKUMENT where ' + ' (RID=' + inttostr(DOKUMENT_R) +
                  ') ' + ' for update');
                open;
                first;
                if not(eof) then
                begin
                  edit;
                  FieldByName('BEMERKUNG').Assign(ExterneLinks);
                  post;
                end;
              end;
            end;
            qDOKUMENT.free;

          end;
          //
        end;

        // Abgleich
        if assigned(ExterneLinks) then
          FreeAndNil(ExterneLinks);

      end;

      if frequently(StartTime, 777) or (w = pred(ARTIKEL.count)) then
      begin
        Label7.caption := inttostr(w);
        ProgressBar2.Position := w;
        application.processmessages;
        // Dateigrössen
        StaticText2.caption := inttostr(SummeLocalFSize);
        StaticText3.caption := inttostr(SummeRemoteFSize);
        StaticText4.caption := inttostr(SummeUploadFSize);

        // Anzahl der Synchronisierten Dateien
        StaticText5.caption := inttostr(SummeLocalCount);
        StaticText6.caption := inttostr(SummeRemoteCount);
        StaticText7.caption := inttostr(SummeUploadCount);

        // Fehler
        StaticText9.caption := inttostr(SummeFTPFehler);

        //
        StaticText8.caption := inttostr(SummeModifiedLinksCount);

        if CheckBoxAbbruch.Checked then
          break;
      end;

    except
      on e: exception do
      begin
        FTPLastError := e.ClassName + ': ' + e.Message;
        FTPError := true;
      end;
    end;

    // FTP - Fehler auflösen!
    if FTPError then
    begin

      //
      FTPError := false;
      if isFTP_FATAL_ERROR(FTPLastError) then
      begin
        Log(cERRORText + ' ' + FTPLastError);
        inc(SummeFTPFehler);
      end
      else
      begin
        Log(cWARNINGText + ' ' + FTPLastError);
      end;

      try
        with IdFTP1 do
        begin
          if connected then
            Disconnect;
          connect;
        end;
      except
        on e: exception do
        begin
          Log(cINFOText + ' ' + e.Message);
        end;
      end;

      // ganze Komponente freigeben
      // Ich vermute mit "Quit" gehen die Socket-Errors
      // nicht weg
      IdFTP1.free;

      // Dem ganzen System Zeit geben!
      sleep(30000 * SummeFTPFehler);

      // Neues Spiel, neues Glück
      IdFTP1 := TIdFTP.Create(self);
      FTPini;

    end;

    if (SummeUploadCount > 100) and CheckBox1.Checked then
      break;
    if (SummeFTPFehler > 10) and CheckBox5.Checked then
      break;

  end;

  // Verbindung zum Server trennen
  try
    if IsFTP then
    begin
      with IdFTP1 do
      begin
        if connected then
          Disconnect;
      end;
    end;
  except
    ;
  end;

  Log('ENDE');
  ProgressBar2.Position := 0;

  SolidEndTransaction;
  //
  ARTIKEL.free;
  WEBSHOP.free;
  MUSIC.free;
  BEMERKUNG.free;

  FreeAndNil(LocalMusikFName);
  FreeAndNil(RemoteMusikFName);

  EndHourGlass;

end;

procedure TFormWebShopConnector.Button6Click(Sender: TObject);
begin
  if CheckBox6.Checked then
    setLAUFNUMMER;
  if CheckBox9.Checked then
    dumpMySQL;
  if CheckBox7.Checked then
    dumpUP;
  if CheckBox8.Checked then
    dumpON;
end;

function TFormWebShopConnector.ArtikelDump: boolean;
begin
  Result := false;
  repeat
    setLAUFNUMMER;
    if (dumpMySQL = 0) then
      break;
    if not(dumpUP) then
      break;
    if not(dumpON) then
      break;
    Result := true;
  until true;
end;

procedure TFormWebShopConnector.Button7Click(Sender: TObject);
begin
  setLAUFNUMMER;
end;

procedure TFormWebShopConnector.Button8Click(Sender: TObject);
begin
  dumpMySQL;
end;

procedure TFormWebShopConnector.Button9Click(Sender: TObject);
begin
  dumpUP;
end;

function TFormWebShopConnector.dumpMySQL: integer;
const
  cMySQLNull = 'NULL';
  cGRANULARITAET = 50000;
var
  ARTIKEL_R: TgpIntegerList;
  ARTIKEL: TIB_Cursor;

  function ExportOne(ARTIKEL_R: integer): string;

    function AsString(s: string): string; overload;
    begin
      // erst mal unerwünschte Zeichen raus
      Result := StrFilter(s, #10#13, true);

      // nun die Konvertierung nach html
      Result := Ansi2html(Result);

      // nun noch die Hochkommas entschärfen
      ersetze('''', '\''', Result);

      // das Ergebnis String-Mässig einfassen
      Result := '''' + Result + '''';
    end;

    function asNumber(f: TIB_Column): string; overload;
    begin
      if f.IsNull then
        Result := cMySQLNull
      else
        Result := f.AsString;
    end;

    function AsString(f: TIB_Column): string; overload;
    begin
      if f.IsNull then
        Result := cMySQLNull
      else
        Result := AsString(f.AsString);
    end;

    function AsString(d: double): string; overload;
    begin
      Result := FloatToStrISO(d);
    end;

  begin
    with ARTIKEL do
    begin
      ParamByName('CROSSREF').AsINteger := ARTIKEL_R;
      ApiFirst;
      Result := '(' + asNumber(FieldByName('RID')) + ',' + asNumber(FieldByName('LAUFNUMMER')) + ','
        + AsString(FieldByName('TITEL')) + ',' +
        AsString(cutblank(FieldByName('SCHWER_GRUPPE').AsString + ' ' +
        FieldByName('SCHWER_DETAILS').AsString)) + ',' + AsString(FieldByName('DAUER')) + ',' +
        AsString(e_r_Verlag_PERSON_R(FieldByName('VERLAG_R').AsINteger)) + ',' +
        AsString(e_r_MusikerName(FieldByName('KOMPONIST_R').AsINteger)) + ',' +
        AsString(e_r_MusikerName(FieldByName('ARRANGEUR_R').AsINteger)) + ',' +
        AsString(e_r_USD(FieldByName('RID').AsINteger)) + ')';
    end;
  end;

  procedure addInsertStatement(const MySQLdump: TStrings);
  begin
    with MySQLdump do
    begin
      Add('INSERT INTO ARTIKEL');
      Add(' (RID, NUMERO, TITEL, SCHWER, DAUER, VERLAG, KOMPONIST, ARRANGEUR, PREIS)');
      Add('VALUES');
    end;
  end;

var
  MySQLdump: TStringList;
  n, BlockNumber: integer;
  StartIndex: integer;
  EndeIndexExclusiv: integer;
  REST: integer;

begin
  BeginHourGlass;
  Result := 0;
  ARTIKEL := DataModuleDatenbank.nCursor;
  MySQLdump := TStringList.Create;
  try

    // Die bisherigen Dateien löschen
    FileDelete(format(DiagnosePath + cMySQLdumpFName, ['*']));

    // den ARTIKEL Zugriff mal sicherstellen!
    with ARTIKEL do
    begin
      sql.Add('select RID, LAUFNUMMER, TITEL, ' + ' SCHWER_GRUPPE, SCHWER_DETAILS, DAUER, ' +
        ' VERLAG_R, KOMPONIST_R, ARRANGEUR_R ' + ' from ARTIKEL where RID=:CROSSREF');
      open;
    end;

    // nun die mySQL Ausgabe
    with MySQLdump do
    begin

      // delete the old Data
      // 2 Statements auf einen Streich funktionieren nicht mehr!
      // dieser Befehl wird durch "mysql.delete.txt" aus geführt
      // Add('DELETE FROM ARTIKEL;');

      //
      ARTIKEL_R := FormOLAP.OLAP('Artikel.des.WebShop');
      AppendStringsToFile(inttostr(ARTIKEL_R.count), format(DiagnosePath + cMySQLdumpFName,
        ['Count']));

      StartIndex := 0;
      BlockNumber := 0;

      repeat

        // Schleifenende bestimmen
        EndeIndexExclusiv := min(StartIndex + cGRANULARITAET, ARTIKEL_R.count);

        // Es muss immer ein Rest<>1 sein wegen der
        // "," und ";" Lösung
        REST := ARTIKEL_R.count - EndeIndexExclusiv;
        if (REST = 1) then
          dec(EndeIndexExclusiv);

        inc(BlockNumber);
        addInsertStatement(MySQLdump);

        for n := StartIndex to (EndeIndexExclusiv - 2) do
          Add(ExportOne(ARTIKEL_R[n]) + ',');

        Add(ExportOne(ARTIKEL_R[pred(EndeIndexExclusiv)]) + ';');

        SaveToFile(format(DiagnosePath + cMySQLdumpFName, [intToStrN(BlockNumber, 4)]));

        if (EndeIndexExclusiv = ARTIKEL_R.count) then
          break;

        StartIndex := EndeIndexExclusiv;

        clear;

      until false;

      Result := ARTIKEL_R.count;
      ARTIKEL_R.free;

      Log('OK: dumpMySQL!');

    end;
  except
    on e: exception do
    begin
      Log(cERRORText + ' ' + e.Message);
    end;
  end;
  ARTIKEL.free;
  MySQLdump.free;
  EndHourGlass;
end;

function TFormWebShopConnector.dumpON: boolean;
{

  COUNT=
  DB=

}
var
  pSiteHost: string;
  execRequest: string;

  //
  sResult: TStringList;
  cResult: integer;
  nResult: string;
  sDir: TStringList;
  n: integer;
  ArtikelAnzahl: integer;
begin
  Result := false;
  nResult := '';
  if (iShopLink <> '') then
  begin
    BeginHourGlass;
    sDir := TStringList.Create;
    pSiteHost := nextp(iShopLink, ',', 0);
    try
      repeat

        // Artikel-Anzahl bestimmen ...
        sResult := TStringList.Create;
        sResult.LoadFromFile(format(DiagnosePath + cMySQLdumpFName, ['Count']));
        if (sResult.count > 0) then
          ArtikelAnzahl := StrToIntDef(sResult[0], 0)
        else
          ArtikelAnzahl := 0;
        sResult.free;

        if (ArtikelAnzahl = 0) then
        begin
          Log(cERRORText + ' dump-Import: ArtikelAnzahl=0');
          break;
        end;

        // Remote Tabelle "ARTIKEL" leeren ...
        execRequest := pSiteHost + 'db/import_db.php5' + '?import_file=' + cMySQLclearFName +
          '&pwd=' + FindANewPassword('', 15);
        sResult := DataModuleREST.REST(execRequest);
        cResult := StrToIntDef(sResult.values['COUNT'], -1);
        sResult.free;

        if (cResult <> 0) then
        begin
          Log(cERRORText + ' dump-Import: Artikelanzahl sollte nach Löschung=0 sein');
          break;
        end;

        // Datentabelle aufbauen ...
        dir(format(DiagnosePath + cMySQLdumpFName, ['*']), sDir, false);
        sDir.sort;
        for n := 0 to (sDir.count - 2) do
        begin
          execRequest := pSiteHost + 'db/import_db.php5' + '?import_file=' + sDir[n] + '&pwd=' +
            FindANewPassword('', 15);
          sResult := DataModuleREST.REST(execRequest);
          cResult := StrToIntDef(sResult.values['COUNT'], 0);
          sResult.free;
        end;

        if (cResult <> ArtikelAnzahl) then
        begin
          Log(cERRORText +
            { } ' dump-Import: von ' +
            { } inttostr(ArtikelAnzahl) +
            { } ' wurden nur ' +
            { } inttostr(cResult) +
            { } ' übernommen');
          break;
        end;

        // Datenbank durch umschalten aktivieren ...
        execRequest := pSiteHost + 'db/toggle_db.php5' + '?pwd=' + FindANewPassword('', 15);
        sResult := DataModuleREST.REST(execRequest);
        nResult := sResult.values['DB'];
        sResult.free;
        if (nResult = '') then
        begin
          Log(cERRORText + ' dump-Toggle: ' + HugeSingleLine(sResult, '|'));
          break;
        end;

        Result := true;
        Log('OK: dumpON!');

      until true;
    except
      on e: exception do
      begin
        Log(cERRORText + ' dumpON: ' + e.Message);
      end;
    end;
    sDir.free;
    EndHourGlass;
  end;
end;

function TFormWebShopConnector.dumpUP: boolean;
var
  sDir: TStringList;
  n: integer;
begin
  Result := false;
  sDir := TStringList.Create;
  if (iShopkonto <> '') then
  begin

    BeginHourGlass;
    try
      with IdFTP1 do
      begin
        Passive := true;
        Host := nextp(iShopkonto, ',', 0);
        UserName := nextp(iShopkonto, ',', 1);
        Password := nextp(iShopkonto, ',', 2);
        dir(format(DiagnosePath + cMySQLdumpFName, ['*']), sDir, false);
        for n := 0 to pred(sDir.count) do
        begin
          Result := SolidPut(IdFTP1, DiagnosePath + sDir[n], '/db', sDir[n]);
          if not(Result) then
            break;
        end;
        sDir.free;
        Disconnect;
      end;
      if not(Result) then
        Log(cERRORText + ' dumpUp: fail!')
      else
        Log('OK: dumpUP!');
    except
      on e: exception do
      begin
        Log(cERRORText + ' dumpUP: ' + e.Message);
      end;
    end;
    EndHourGlass;
  end;
end;

end.
