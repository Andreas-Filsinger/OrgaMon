{
  |
  |     http://wiki.orgamon.org/index.php5/Keepcon
  |      _  __                ____
  |     | |/ /___  ___ _ __  / ___|___  _ __
  |     | ' // _ \/ _ \ '_ \| |   / _ \| '_ \
  |     | . \  __/  __/ |_) | |__| (_) | | | |
  |     |_|\_\___|\___| .__/ \____\___/|_| |_|
  |                   |_|
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
  |    keepcon (c) 2003 - 2015 by Andreas Filsinger,
}
{$MODE Delphi}
//
// This is FreePascal Source Code for Linux-Targets
//

//
//
//
//
program keepcon;

uses
  IniFiles, Classes, Unix, SysUtils, SystemLog;

const
  cVersion = '1.037';

  //
  // Changelog unter
  // svn:orgamon.net/orgamon-7/rev/keepcon.rev
  //
  //

  // Allgemeine Konstanten
  cWorkingPath = '/root/';
  cTmpOutFileName = 'keepcon.tmp';
  cTmpScriptFileName = 'keepcon.script';
  cIniFile = '/etc/keepcon.conf';
  cWhoAmI = '/root/keepcon.who';
  cLogFile = '/root/keepcon.log';
  cTmpFile = cWorkingPath + cTmpOutFileName;
  cTmpScriptFile = cWorkingPath + cTmpScriptFileName;
  cConnectionDelimiter = '@';
  cRegularExpressionDelimiter = '"';
  cTheUnknownIP = '0.0.0.0';

  // cinternet Option
  cStatusTag = 'status: ';
  cDownInfo = 'interface %s is down';
  cUnavailableInfo = 'Interface %s is not available';
  cUpInfo = '%s is up';

  // cinternet Stati
  cStatusUnknown = 'unknown';
  cStatusConnected = 'connected';
  cStatusConnecting = 'connecting';
  cStatusDisconnected = 'disconnected';
  cStatusUnset = 'unset';

  // ifconfig
  cIPHit = 'inet addr:';

  // ftp Sachen
  cNetRC = '/root/.netrc';
  ckeepconFtp = '/root/keepcon.ftp';
  cFTPcall = 'ftp -v ';

  // firewall Sachen
  cFirewallApp = '/etc/and-firewall';

  // html Template Sachen
  cIPplaceholder = '~IP~';
  cTemplateDelimiter = ',';
  cTemplateParam_FName = 0;
  cTemplateParam_FTPHost = 1;
  cTemplateParam_FTPUser = 2;
  cTemplateParam_FTPpwd = 3;
  cTemplateParam_FTPpath = 4;

  // externe Scripte, Beispiel vigor.sh
  cScriptIdentifier = '.sh';

var
  // Commandozeile
  DebugMode: boolean = false;
  DaemonMode: boolean = false;
  XinetdMode: boolean = false;

  sConnections: TStringList;
  sCachedScripts: TStringList;

  // Parameter aus /etc/keepcon.conf
  iFtpServer: string;
  iFTpUser: string;
  iftpPassword: string;
  iftpPath: string;
  iPublishName: string;
  iPrimaryConnection: string;
  iPing: string;
  iRemotes: TStringList; // PUBLICNAME
  iHostNames: TStringList; // lokaler Name, default ist der PUBLICNAME
  iRemoteIPs: TStringList; //
  iFailOvers: TStringList;
  iTemplates: TStringList;

  // Bei iRestartRoute pruefen wir auch die Existenz einer
  // Default-Route im Unconnected Zustand. Gibt es
  // eine, so wird diese geloescht. Ein anschliessender
  // Connect wird dann in der Regel die richtige Route
  // wieder hochziehen.
  //
  // Grund:
  // Es sein kann, dass auf "eth1" z.B. ein
  // Modem haengt - auf eth0 ist ein DHCP-Client
  // aktiv ist.
  // Beide Interfaces setzen eine Default Route und
  // kommen sich ev. in die Quere.
  // In so einer Situation kann es vorkommen, dass
  // ein "ping" funktioniert obwohl das Modem offline
  // ist.
  //
  iRestartRoute: boolean;

  //
  // Wird ein IP-Adress-Wechsel durch den Provider
  // erkannt oder beim Neustart von Keepcon wird
  // die IP-Adresse an einen DynDNS-Anbieter mitgeteilt
  iDynDNS: string;
  iDynDNS_User: string;
  iDynDNS_Password: string;

  // iNetwork
  // ========
  //
  // Name des Netzwerk-Interfaces an dem die Internet-Nutzer
  // hÃ¤ngen. Auf dieses Netzwerk muss gewartet werden bevor
  // das Masquerading gestartet wird.
  //
  // Beispiel: eth0
  //
  iNetwork: string;

  // iModem
  // ======
  //
  // Name des Netzwerk-Interfaces, an dem das Modem hÃ¤ngt.
  // Auf dieses Netzwerk muss gewartet werden bevor eine
  // Internet-Verbindung aufgebaut werden kann.
  //
  // Beispiel: eth1
  //
  iModem: string;

  // iConnection
  // ===========
  //
  // Name des Internet-Interfaces das entsteht wenn eine
  // Verbindung aufgebaut wird.
  //
  // Beispiel: dsl0
  //
  iConnection: string;

function uptime: string;
var
  f: TextFile;
  u: string;
begin
  AssignFile(f, '/proc/uptime');
  reset(f);
  readln(f, u);
  CloseFile(f);
  result := copy(u, 1, pred(pos('.', u)));
end;

procedure Log(s: string);
const
  MaxMsgLength = 1024;
var
  LogMsg: array [0 .. MaxMsgLength] of char;
begin
  if DebugMode then
    writeln(s);
  StrPCopy(LogMsg, copy(s, 1, pred(MaxMsgLength)) + ' [' + uptime + 's]');
  SysLog(LOG_INFO, '%d: %s', [GetProcessID, LogMsg]);
end;

// Execute a Command

function Exec(s: string): cint;
begin
  try
    if DebugMode then
      Log('EXEC: ' + s);
    result := fpsystem(s);
  except
    on E: Exception do
      Log('ERROR: Exec(' + s + '):' + E.Message);
  end;
end;

procedure CachedExec(script: string);
begin
  if (sCachedScripts.indexof(script) = -1) then
  begin
    Deletefile(cTmpScriptFile);
    Exec('/root/' + script + ' > ' + cTmpScriptFile);
    sCachedScripts.add(script);
    sleep(300);
  end;
end;


// upload the TMP File via File Transfer Protokoll

procedure FTPup(iFtpServer, iFTpUser, iftpPassword, iftpPath,
  iFTPFName: string);
var
  s: TStringList;
begin
  s := TStringList.create;
  try

    if not(DaemonMode) then
      writeln('upload: ' + iFTpUser + '@' + iFtpServer + iftpPath + '/' +
        ExtractFileName(iFTPFName) + ' ...');

    // .netrc
    s.add('machine ' + iFtpServer + ' login ' + iFTpUser + ' password ' +
      iftpPassword);
    s.SaveToFile(cNetRC);
    Exec('chmod 600 ' + cNetRC);

    // keepcon.ftp
    s.clear;
    if (iftpPath <> '') then
      s.add('cd ' + iftpPath);
    s.add('put ' + cTmpFile + ' ' + ExtractFileName(iFTPFName));
    s.add('quit');
    s.SaveToFile(ckeepconFtp);

    // call ftp with the prepared script
    Exec('su root -c "' + cFTPcall + iFtpServer + ' < ' + ckeepconFtp + '" >>' +
      cLogFile);

  except
    on E: Exception do
      Log('ERROR: FTPUp:' + E.Message);
  end;
  s.free;
end;

// string utils

function noblank(s: string): string;
var
  n: integer;
begin
  repeat
    n := pos(' ', s);
    if n = 0 then
      break;
    delete(s, n, 1);

  until false;
  result := s;
end;


// parse a parameter

function NextP(var s: string; Delimiter: string): string; overload;
var
  k: integer;
begin
  k := pos(Delimiter, s);
  if k > 0 then
  begin
    result := copy(s, 1, pred(k));
    delete(s, 1, pred(k + length(Delimiter)));
  end
  else
  begin
    result := s;
    s := '';
  end;
end;

function NextP(s: string; Delimiter: string; SkipCount: integer;
  WithRest: boolean = false): string; overload;
var
  n, k: integer;
begin
  for n := 1 to SkipCount do
  begin
    k := pos(Delimiter, s);
    if (k > 0) then
    begin
      delete(s, 1, pred(k + length(Delimiter)));
    end
    else
    begin
      result := '';
      exit;
    end;
  end;

  // cut the unneeded rest
  if not(WithRest) then
  begin
    k := pos(Delimiter, s);
    if k > 0 then
      result := copy(s, 1, pred(k))
    else
      result := s;
  end
  else
  begin
    result := s;
  end;
end;

function TransportInterface(connection: string): string;
// Beispiel "dsl0", bei "tonline-dsl-business@dsl0"
begin
  if (pos(cConnectionDelimiter, connection) > 0) then
    result := NextP(connection, cConnectionDelimiter, 1)
  else
    result := connection;
end;

function ProviderSpecifier(connection: string): string;
begin
  result := NextP(connection, cConnectionDelimiter, 0);
  // Beispiel "tonline-dsl-business", bei "tonline-dsl-business@dsl0"
end;

procedure ReadIni;
var
  MyIni: TiniFile;
  n, k: integer;
  _host: string;
  _failOver: string;
  _template: string;
begin
  MyIni := TiniFile.create(cIniFile);
  try
    iRemotes.clear;
    iHostNames.clear;
    iRemoteIPs.clear;
    iTemplates.clear;
    iFailOvers.clear;
    with MyIni do
    begin
      iPublishName := ReadString('System', 'publish', '');
      iFtpServer := ReadString('System', 'ftp_server', '');
      iFTpUser := ReadString('System', 'ftp_user', '');
      iftpPassword := ReadString('System', 'ftp_password', '');
      iftpPath := ReadString('System', 'ftp_path', '/');
      iPing := ReadString('System', 'ping', '');
      iRestartRoute :=
      { } (ReadString('Primary', 'RestartRoute', '') = 'YES') or
      { } (ReadString('Primary', 'NewRoute', '') = 'YES');
      iPrimaryConnection := ReadString('Primary', 'provider', '');
      iNetwork := ReadString('Interface', 'network', '');
      iModem := ReadString('Interface', 'modem', '');
      iConnection := ReadString('Interface', 'connection',
        TransportInterface(iPrimaryConnection));
      iDynDNS := ReadString('System', 'DynDNS', '');
      iDynDNS_User := ReadString('System', 'DynDNS_user', '');
      iDynDNS_Password := ReadString('System', 'DynDNS_password', '');
      for n := 1 to 10 do
      begin

        // Fremde Hosts, die von Interesse sind
        _host := ReadString('Remote', 'host' + inttostr(n), '');
        if (_host <> '') then
        begin
          k := pos(' ', _host);
          if k = 0 then
          begin
            iRemotes.add(_host);
            iHostNames.add(_host);
          end
          else
          begin
            iRemotes.add(copy(_host, 1, pred(k)));
            iHostNames.add(copy(_host, succ(k), MaxInt));
          end;
          iRemoteIPs.add(cTheUnknownIP);
        end;

        // .html / .php / .inc Dateien, die gepached werden müssen
        _template := ReadString('Templates', inttostr(n), '');
        if (_template <> '') then
        begin
          iTemplates.add(_template);
        end;

        _failOver := ReadString('FailOver', 'provider' + inttostr(n), '');
        if (_failOver <> '') then
          iFailOvers.add(_failOver);
      end;

    end;
  except
    on E: Exception do
      Log('ERROR: ReadIni:' + E.Message);
  end;
  MyIni.free;
end;

// Make a list of all Connections / Providers

procedure BuildConnectionList(sConnections: TStrings);
var
  n: integer;
begin
  sConnections.clear;
  sConnections.add(iPrimaryConnection);
  sConnections.addstrings(iFailOvers);
  if DebugMode then
  begin
    for n := 0 to pred(sConnections.count) do
      Log(format('%d|%s', [n + 1, sConnections[n]]));
  end;
end;

function ObtainIP(connection: string): string;

  procedure via_ifconfig;
  var
    s: TStringList;
    AutoMataState: integer;
    IP: string;
    n, k: integer;
  begin
    s := TStringList.create;
    try
      Deletefile(cTmpFile);
      Exec('ifconfig > ' + cTmpFile);
      s.loadfromfile(cTmpFile);
      AutoMataState := 0;
      for n := 0 to pred(s.count) do
      begin
        case AutoMataState of
          0:
            begin // search for eth1, ippp0 ....
              if pos(TransportInterface(connection), s[n]) = 1 then
                AutoMataState := 1;
            end;
          1:
            begin // search now for "inet addr:"
              k := pos(cIPHit, s[n]);
              if (k > 0) then
              begin
                IP := copy(s[n], k + length(cIPHit), MaxInt);
                k := pos(' ', IP);
                if (k > 0) then
                  IP := copy(IP, 1, pred(k));
                if (IP <> '127.0.0.1') then
                  result := IP;
                break;
              end;
            end;
        end;
      end;
    except
      on E: Exception do
        Log('ERROR: ObtainIP-ifconfig:' + E.Message);
    end;
    s.free;
  end;

  procedure via_script;
  const
    cIPHit = 'IP:';
  var
    s: TStringList;
    AutoMataState: integer;
    IP: string;
    n, k: integer;
  begin
    s := TStringList.create;
    try
      CachedExec(TransportInterface(connection));
      s.loadfromfile(cTmpScriptFile);
      AutoMataState := 0;
      for n := 0 to pred(s.count) do
      begin
        case AutoMataState of
          0:
            begin // search for eth1, ippp0 ....
              if pos(ProviderSpecifier(connection), trim(s[n])) = 1 then
                AutoMataState := 1;
            end;
          1:
            begin // search now for "inet addr:"
              k := pos(cIPHit, s[n]);
              if (k > 0) then
              begin
                IP := copy(s[n], k + length(cIPHit), MaxInt);
                k := pos('GW', IP);
                if (k > 0) then
                  IP := trim(copy(IP, 1, pred(k)));
                if (IP <> '127.0.0.1') then
                  result := IP;
                break;
              end;
            end;
        end;
      end;
    except
      on E: Exception do
        Log('ERROR: ObtainIP-script:' + E.Message);
    end;
    s.free;
  end;

begin
  result := cTheUnknownIP;

  if (pos('.sh', TransportInterface(connection)) > 0) then
    via_script
  else
    via_ifconfig;

end;

function Patch(FName, TheNewIP: string): boolean;
var
  sl: TStringList;
  n, k: integer;

  procedure SetK;
  begin
    k := pos(cIPplaceholder, sl[n]);
  end;

begin
  result := false;
  sl := TStringList.create;
  try
    repeat

      // load the template
      if (FName <> '') then
        if FileExists(FName) then
        begin
          sl.loadfromfile(FName);
          break;
        end;

      // create it by your own
      sl.add('<HTML>');
      sl.add('<HEAD>');
      sl.add('<TITLE>' + iPublishName + '</TITLE>');
      sl.add('</HEAD>');
      sl.add('<BODY>');
      sl.add(TheNewIP);
      sl.add('</BODY>');
      sl.add('</HTML>');

    until true;

    // patch the IP
    for n := 0 to pred(sl.count) do
    begin
      SetK;
      if (k > 0) then
      begin
        repeat
          sl[n] := copy(sl[n], 1, pred(k)) + TheNewIP +
            copy(sl[n], k + length(cIPplaceholder), MaxInt);
          SetK;
        until (k = 0);
      end;
    end;

    sl.SaveToFile(cTmpFile);

    result := true;

  except
    on E: Exception do
      Log('ERROR: Patch:' + E.Message);
  end;
  sl.free;
end;

procedure DelRoute;
begin
  Exec('route del default');
end;

function Status(connection: string): string;

  procedure via_ifstatus;
  var
    s: TStringList;
    n: integer;
    interf: string;
    hit: string;
  begin
    s := TStringList.create;
    try
      interf := TransportInterface(connection);
      Deletefile(cTmpFile);
      Exec('ifstatus ' + interf + ' > ' + cTmpFile);
      s.loadfromfile(cTmpFile);
      for n := 0 to pred(s.count) do
      begin
        if (pos(cStatusTag, s[n]) = 1) then
        begin
          result := NextP(s[n], cStatusTag, 1);
          break;
        end;
        if (s[n] = format(cDownInfo, [interf])) then
        begin
          result := cStatusDisconnected;
          break;
        end;
        if (s[n] = format(cUnavailableInfo, [interf])) then
        begin
          result := cStatusDisconnected;
          break;
        end;
        if (pos(interf, s[n]) > 0) and (pos('is down', s[n]) > pos(interf, s[n]))
        then
        begin
          result := cStatusDisconnected;
          break;
        end;
      end;

      hit := noblank(format(cUpInfo, [interf]));
      if (result = cStatusUnknown) then
        for n := 0 to pred(s.count) do
        begin
          if DebugMode then
            writeln('"' + noblank(s[n]) + '"');
          if (pos(hit, noblank(s[n])) > 0) then
          begin
            result := cStatusConnected;
            break;
          end;
        end;
    except
      on E: Exception do
        Log('ERROR: Status:' + E.Message);
    end;
    s.free;
  end;

  procedure via_script;
  var
    s: TStringList;
    n: integer;
    wan: string;
  begin
    s := TStringList.create;
    try
      CachedExec(TransportInterface(connection));
      wan := ProviderSpecifier(connection);
      s.loadfromfile(cTmpScriptFile);
      for n := 0 to pred(s.count) do
      begin
        if (pos(wan, s[n]) = 1) then
        begin
          result := NextP(s[n], ':', 1);
          repeat

            if result = 'Connected' then
            begin
              result := cStatusConnected;
              break;
            end;

            if result = 'Disconnected' then
            begin
              result := cStatusDisconnected;
              break;
            end;

            Log('ERROR: Status.Unknown Status "' + result + '"');
            result := cStatusUnset;

          until true;
          break;
        end;
      end;
    except
      on E: Exception do
        Log('ERROR: Status.' + E.Message);
    end;
    s.free;
  end;

begin
  result := cStatusUnknown;
  if pos('.sh', TransportInterface(connection)) > 0 then
    via_script
  else
    via_ifstatus;
end;

function Gateway(connection: string): string;
var
  s: TStringList;
  n, k: integer;
  interf: string;
  sRoute: string;
begin
  result := cStatusUnset;
  s := TStringList.create;
  try
    interf := TransportInterface(connection);
    if pos(cScriptIdentifier, interf) = 0 then
    begin
      Deletefile(cTmpFile);
      Exec('route -n' + ' > ' + cTmpFile);
      s.loadfromfile(cTmpFile);
      for n := 0 to pred(s.count) do
      begin
        // Wir brauchen unser Interface
        if (pos(interf, s[n]) = 0) then
          continue;

        // Die Route muss "U"p sein
        if (pos(' U', s[n]) < 21) then
          continue;
        sRoute := s[n];

        // Die Route muss die "default" Route
        if (pos(cTheUnknownIP, sRoute) <> 1) then
          continue;

        // Loesche Alle Spacer Blanks
        repeat
          k := pos('  ', sRoute);
          if (k = 0) then
            break;
          delete(sRoute, k, 1);
        until false;

        //
        sRoute := NextP(sRoute, ' ', 1);
        if (sRoute = cTheUnknownIP) then
          result := interf
        else
          result := sRoute;
        break;

      end;
    end;
  except
    on E: Exception do
      Log('ERROR: Status.' + E.Message);
  end;
  s.free;
end;

function ActiveConnection: string;
var
  n: integer;
begin
  result := '';
  for n := 0 to pred(sConnections.count) do
    if Status(sConnections[n]) = cStatusConnected then
    begin
      result := sConnections[n];
      break;
    end;
end;

procedure StartConnection(connection: string);
begin
  if (pos(cScriptIdentifier, connection) = 0) then
    if (Status(connection) <> cStatusConnected) then
    begin

      // Schritt 1 : Die aktuelle default Route loeschen
      // damit der Weg frei wird fuer die neue Route
      if iRestartRoute then
        DelRoute;

      // Schritt 2 : Den richtigen Provider aktivieren
      Exec('ifup ' + TransportInterface(connection));

      // Schritt 3 : Dem System Zeit geben alles einzurichten
      sleep(2000);

    end;
end;

procedure Firewall(connection: string);
var
  n: integer;
  IsConnected: boolean;
begin
  try

    if (pos(cScriptIdentifier, connection) = 0) then
    begin

      // Warten auf das Network-Interface
      if (iNetwork <> '') then
      begin
        n := 0;
        repeat
          inc(n);
          IsConnected := (Status(iNetwork) = cStatusConnected);
          if IsConnected or (n >= 15) then
            break;
          if not(DaemonMode) then
            write('n');
          sleep(1000);
        until false;
        if not(IsConnected) then
        begin
          Log('WARNING: Firewall: Users-Interface "' + iNetwork +
            '" do not comes available, timeout after 15s');
        end
        else
        begin
          if (n > 1) then
            Log('INFO: Firewall: Users-Interface "' + iNetwork +
              '" came up after ' + inttostr(n) + 's');
        end;
      end;

      // Starten der Firewall
      if (iNetwork <> '') then
        Exec(
          { } cFirewallApp + ' ' +
          { } iNetwork + ' ' +
          { } TransportInterface(connection));

    end;
  except
    on E: Exception do
      Log('ERROR: Firewall.' + E.Message);
  end;
end;

procedure HangUp(sConnections: TStrings);
var
  n: integer;
  _status: string;
  OneUp: boolean;
  Trys: integer;
begin
  try
    Trys := 0;
    repeat
      if not(DaemonMode) then
        if (Trys > 0) then
          write('H');
      inc(Trys);
      OneUp := false;
      for n := 0 to pred(sConnections.count) do
        if pos(cScriptIdentifier, sConnections[n]) = 0 then
        begin
          _status := Status(sConnections[n]);
          if (_status = cStatusConnected) or (_status = cStatusConnecting) then
          begin
            OneUp := true;
            Exec('ifdown ' + TransportInterface(sConnections[n]));
            sleep(500);
          end;
        end;
    until not(OneUp) or (Trys = 3);
  except
    on E: Exception do
      Log('ERROR: HangUp.' + E.Message);
  end;
end;

procedure Upload(connection: string = '');
var
  n: integer;
  TheNewIP: string;
  FName: string;
begin
  try
    if (connection = '') then
      connection := ActiveConnection;
    TheNewIP := ObtainIP(connection);

    if (iFtpServer <> '') then
    begin
      Patch('', TheNewIP);
      FTPup(iFtpServer, iFTpUser, iftpPassword, iftpPath,
        iPublishName + '.html');
    end;

    if (iDynDNS <> '') then
    begin
      if not(DaemonMode) then
        writeln('dyn: set ' + iDynDNS + ' to ' + TheNewIP + ' ...');

      if Exec(
        { command } 'wget ' +
        { no spam } '--no-verbose ' +
        { 200? } '--save-headers ' +
        { Result } '--output-document=/root/keepcon.wget.result ' +
        { Log } '--append-output=/root/keepcon.wget.log ' +
        { user } '--http-user=' + iDynDNS_User + ' ' +
        { pwd } '--http-password=' + iDynDNS_Password + ' ' +
        { URL } 'https://members.dyndns.org/nic/update?' +
        { hostnme } 'hostname=' + iDynDNS +
        { ip } '\&myip=' + TheNewIP + ' ' +
        { quiet } '&> /dev/null') = 0 then
      begin
        Log('INFO: DynDNS ' + iDynDNS + ' set to ' + TheNewIP)
      end
      else
      begin
        Log('ERROR: DynDNS failure!');
      end;

    end;

    for n := 0 to pred(iTemplates.count) do
    begin
      FName := NextP(iTemplates[n], cTemplateDelimiter, cTemplateParam_FName);
      if Patch(FName, TheNewIP) then
      begin
        if (FName <> '') then
          FTPup(NextP(iTemplates[n], cTemplateDelimiter,
            cTemplateParam_FTPHost), NextP(iTemplates[n], cTemplateDelimiter,
            cTemplateParam_FTPUser), NextP(iTemplates[n], cTemplateDelimiter,
            cTemplateParam_FTPpwd), NextP(iTemplates[n], cTemplateDelimiter,
            cTemplateParam_FTPpath), FName)
        else
          FTPup(NextP(iTemplates[n], cTemplateDelimiter,
            cTemplateParam_FTPHost), NextP(iTemplates[n], cTemplateDelimiter,
            cTemplateParam_FTPUser), NextP(iTemplates[n], cTemplateDelimiter,
            cTemplateParam_FTPpwd), NextP(iTemplates[n], cTemplateDelimiter,
            cTemplateParam_FTPpath), iPublishName + '.html');
      end;
    end;
  except
    on E: Exception do
      Log('ERROR: Upload.' + E.Message);
  end;
end;

var
  _Ping_AnzahlHosts: integer = -1;
  _Ping_Skip: integer = 0;

function Ping: boolean;
var
  Target, tmpTarget: string;
  Host: string;
  SysResultCode: cint;
  iHost: integer;
begin
  result := false;
  if (iPing = '') then
    Target := iFtpServer
  else
    Target := iPing;

  // Sollte Ping noch nie verwendet worden sein
  // muss zunaechst die Anzahl der Hosts bestimmt werden
  if (_Ping_AnzahlHosts < 1) then
  begin
    tmpTarget := Target;
    _Ping_AnzahlHosts := 0;
    while (tmpTarget <> '') do
    begin
      inc(_Ping_AnzahlHosts);
      NextP(tmpTarget, cTemplateDelimiter);
    end;
    if DebugMode then
      writeln(_Ping_AnzahlHosts:2, ' Ping-Hosts!');
  end;

  if iRestartRoute then
    if (Gateway(iPrimaryConnection) = cStatusUnset) then
    begin
      Log('ERROR: Route fail!');
      exit;
    end;

  // Sollte der Skip-Count die Verwendung des
  // letzten Hosts verhindern, so wird wieder der
  // erste Host verwendet.
  if (_Ping_Skip >= _Ping_AnzahlHosts) then
    _Ping_Skip := 0;

  iHost := 0;
  while (Target <> '') do
  begin
    // Skip?
    inc(iHost);
    Host := NextP(Target, cTemplateDelimiter);
    if (iHost <= _Ping_Skip) then
      continue;
    if DebugMode then
      writeln(_Ping_Skip, ' skipped!');

    // Ping!
    try
      SysResultCode := Exec('ping -c 1 -w 2 ' + Host + ' &> /dev/null');

      if (SysResultCode = 0) then
      begin
        result := true;
        break;
      end;
      Log('WARNING: Ping ' + Host + ' fail!');
    except
      Log('ERROR: Ping ' + Host + ' except!');
    end;
  end;
  inc(_Ping_Skip);

end;

function Dial(connection: string): boolean;
var
  n: integer;
  IsConnected: boolean;
  HasIP: boolean;
  HasRoute: boolean;
  ErrorCount: integer;
begin
  result := false;
  try
    ErrorCount := 0;

    // Warten auf das Modem-Interface
    if (iModem <> '') then
    begin
      n := 0;
      repeat
        inc(n);
        IsConnected := (Status(iModem) = cStatusConnected);
        if IsConnected or (n >= 15) then
          break;
        if not(DaemonMode) then
          write('m');
        sleep(1000);
      until false;
      if not(IsConnected) then
      begin
        Log('WARNING: Dial: Modem-Interface "' + iModem +
          '" do not comes available, timeout after 15s');
      end
      else
      begin
        if (n > 1) then
          Log('INFO: Dial: Modem-Interface "' + iModem + '" came up after ' +
            inttostr(n) + 's');
      end;
    end;

    // Internet Einwahl
    StartConnection(connection);
    repeat

      // Warte auf die Verbindung, timeout=15s
      // * Das Interface muss erscheinen, z.B. "dsl0"
      // * Das Interface muss in den Status "connected" wechseln
      n := 0;
      repeat
        inc(n);
        IsConnected := (Status(connection) = cStatusConnected);
        if IsConnected or (n >= 15) then
          break;
        if not(DaemonMode) then
          write('c');
        sleep(1000);
      until false;
      if not(IsConnected) then
      begin
        Log('ERROR: Dial: Connection "' + connection +
          '" do not comes available, timeout after 15s');
        inc(ErrorCount);
        break;
      end
      else
      begin
        if (n > 1) then
          Log('INFO: Dial: Connection "' + connection + '" came up after ' +
            inttostr(n) + 's');
      end;

      // Warte auf die zugeteilte IP-Adresse, timeout=5s
      //
      n := 0;
      repeat
        inc(n);
        HasIP := (ObtainIP(connection) <> cTheUnknownIP);
        if HasIP or (n >= 5) then
          break;
        if not(DaemonMode) then
          write('i');
        sleep(1000);
      until false;
      if not(HasIP) then
      begin
        Log('ERROR: Dial: IP-Adress comes not up, timeout after 5s');
        inc(ErrorCount);
        break;
      end
      else
      begin
        // wait for more details comming up
        sleep(250);
      end;

      // Warte auf die "default" Route in das Interface oder den Host, timeout=5s
      n := 0;
      repeat
        inc(n);
        HasRoute := (Gateway(connection) <> cStatusUnset);
        if HasRoute or (n >= 5) then
          break;
        Exec('route add default ' + TransportInterface(connection));
        if not(DaemonMode) then
          write('r');
        sleep(1000);
      until false;
      if not(HasRoute) then
      begin
        Log('ERROR: Dial: default route comes not up, timeout after 5s');
        inc(ErrorCount);
        break;
      end;

    until true;
    result := (ErrorCount = 0)
  except
    on E: Exception do
      Log('ERROR: Dial.' + E.Message);
  end;
end;

function DownLoad: boolean;
var
  s: TStringList;
  n, m: integer;
  HostChangeCount: integer;
  CommentPos: integer;
  BlankPos: integer;
  IPPos: integer;
  IPAlreadyResolved: boolean;
  OneLine: string;
begin
  result := false;
  if (iRemotes.count > 0) then
  begin
    s := TStringList.create;
    try
      // .netrc
      s.add('machine ' + iFtpServer + ' login ' + iFTpUser + ' password ' +
        iftpPassword);
      s.SaveToFile(cNetRC);
      Exec('chmod 600 ' + cNetRC);

      // keepcon.ftp
      s.clear;
      s.add('cd ' + iftpPath);
      for n := 0 to pred(iRemotes.count) do
      begin
        Deletefile(cWorkingPath + iRemotes[n] + '.html');
        s.add('get ' + iRemotes[n] + '.html ' + cWorkingPath + iRemotes[n]
          + '.html');
      end;
      s.add('quit');
      s.SaveToFile(ckeepconFtp);

      // call ftp
      Exec('su root -c "' + cFTPcall + iFtpServer + ' < ' + ckeepconFtp + '" >>'
        + cLogFile);

      // process the files
      for n := 0 to pred(iRemotes.count) do
      begin
        iRemoteIPs[n] := cTheUnknownIP;
        if FileExists(cWorkingPath + iRemotes[n] + '.html') then
        begin
          s.loadfromfile(cWorkingPath + iRemotes[n] + '.html');
          Deletefile(cWorkingPath + iRemotes[n] + '.html');
          for m := 0 to pred(s.count) do
          begin
            if length(s[m]) > 0 then
            begin
              if (pos('.', s[m]) > 0) and (s[m][1] in ['0' .. '9']) then
              begin
                iRemoteIPs[n] := s[m];
                break;
              end;
            end;
          end;
        end
        else
        begin
          Log('ERROR: unknown host "' + iRemotes[n] + '"');
        end;
      end;

      // modify /etc/hosts (if nessesary)
      HostChangeCount := 0;

      s.loadfromfile('/etc/hosts');

      for m := 0 to pred(iRemotes.count) do
      begin
        IPAlreadyResolved := false;
        for n := 0 to pred(s.count) do
        begin
          OneLine := s[n];
          CommentPos := pos('#', OneLine);
          if CommentPos = 0 then
            CommentPos := MaxInt;
          IPPos := pos('.', OneLine);
          BlankPos := pos(' ', OneLine);
          if (IPPos < CommentPos) and (BlankPos < CommentPos) then
          begin
            // a valid line
            if (CommentPos < MaxInt) then
              OneLine := copy(OneLine, 1, pred(CommentPos));
            if pos(iHostNames[m], OneLine) > 0 then
            begin
              if (pos(iRemoteIPs[m], OneLine) > 0) and
                (iRemoteIPs[m] <> cTheUnknownIP) then
              begin
                // old IP OK!
                IPAlreadyResolved := true;
                break;
              end
              else
              begin
                // IP changed
                if (iRemoteIPs[m] <> cTheUnknownIP) then
                begin
                  // IP changed
                  s[n] := iRemoteIPs[m] + '     ' + iHostNames[m] +
                    '     # updated by keepcon';
                end
                else
                begin
                  // IP could not be resolved, remove line!
                  if DebugMode then
                    writeln('remove!');
                  s.delete(n);
                end;

                inc(HostChangeCount);
                IPAlreadyResolved := true;
                break;
              end;
            end;
          end;
        end;
        if not(IPAlreadyResolved) and (iRemoteIPs[m] <> cTheUnknownIP) then
        begin
          // insert this new line
          s.add(iRemoteIPs[m] + '     ' + iHostNames[m] +
            '     # inserted by keepcon');
          inc(HostChangeCount);
        end;
      end;

      if (HostChangeCount > 0) then
      begin
        result := true;
        s.SaveToFile('/etc/hosts');
        Log('/etc/hosts modified');

        // restart samba name server
        Exec('rcnmb restart');
      end;
    except
      on E: Exception do
        Log('DownLoad.' + E.Message);
    end;
    s.free;
  end;
end;

// ------------------------------------------------------------

procedure AutomaticMode;
var
  MainConnection: string;
  actIP: string;
  _status: string;
  FirstLoop: boolean;
  RoundCount: integer; // Number of Round with same IP

  function ChangedIP: boolean;
  begin
    result := (actIP <> ObtainIP(MainConnection));
  end;

  procedure SaveIP;
  begin
    actIP := ObtainIP(MainConnection);
    RoundCount := 0;
  end;

  procedure DebugWrite(s: string);
  begin
    if DebugMode then
      write(s);
  end;

  procedure DebugWriteLn(s: string);
  begin
    if DebugMode then
      writeln(s);
  end;

begin
  RoundCount := 0;
  FirstLoop := true;
  MainConnection := iPrimaryConnection;
  actIP := ObtainIP(MainConnection);
  try

    repeat

      if (MainConnection <> '') then
      begin

        // Status ermitteln
        DebugWrite('?Status:');
        _status := Status(MainConnection);
        DebugWriteLn(_status);

        if FirstLoop then
        begin

          if (_status = cStatusConnected) then
          begin
            // Verbindung schon OK - mache jedoch dennoch
            // deine IP publik
            DebugWriteLn('!Firewall');
            Firewall(MainConnection);
            DebugWriteLn('!Ping');
            if Ping then
            begin

              DebugWriteLn('!SaveIP');
              SaveIP;
              Log('INFO: has IP [' + actIP + '] after "connected"');

              DebugWriteLn('!Upload');
              Upload;
            end
            else
            begin
              Log('ERROR: ping after fresh "connected" fails');
              DebugWriteLn('!HangUp');
              HangUp(sConnections);
            end;
          end
          else
          begin
            // Unverbunden!
            DebugWriteLn('!HangUp');
            HangUp(sConnections);
            DebugWriteLn('!Dial');
            if Dial(MainConnection) then
            begin

              if ChangedIP then
              begin
                DebugWriteLn('!SaveIP');
                SaveIP;
                Log('INFO: new IP [' + actIP + '] after "initial dial"');
              end;

              DebugWriteLn('!Firewall');
              Firewall(MainConnection);

              DebugWriteLn('!Upload');
              Upload; // Publish own IPs

            end;
          end;
          FirstLoop := false;
          _status := Status(MainConnection);
        end;

        if (_status <> cStatusConnected) then
        begin
          // Disconnected?!
          // Zur Sicherheit Auflegen -> verhindert wertlose
          // Geisterverbindungen
          DebugWriteLn('!HangUp');
          HangUp(sConnections);
          if Dial(MainConnection) then
          begin

            if ChangedIP then
            begin
              DebugWriteLn('!SaveIP');
              SaveIP;
              Log('INFO: new IP [' + actIP + '] after "unconnected"');
            end;

            DebugWriteLn('!Firewall');
            Firewall(MainConnection); // now start the firewall

            DebugWriteLn('!Upload');
            Upload; // Publish own IP to different hosts

            DebugWriteLn('!Download');
            DownLoad; // Download remote IPs

          end
          else
          begin
            BuildConnectionList(sConnections);
          end;
          RoundCount := 0;
        end
        else
        begin

          // Connection OK, refresh the newest hostnamens from internet
          if ChangedIP then
          begin
            DebugWriteLn('!SaveIP');
            SaveIP;
            Log('INFO: new IP [' + actIP + '] after "ghost redial"');

            DebugWriteLn('!UpLoad');
            Upload;

            RoundCount := 0;
          end;

          if (RoundCount mod 3 = 0) then
          begin

            // Ping die Verbindung prüfen
            DebugWriteLn('!Ping');
            if not(Ping) then
            begin
              RoundCount := 0;
              Log('ERROR: Ping at status "connected" fails');

              DebugWriteLn('!HangUp');
              HangUp(sConnections);
              continue;
            end;

            // Weg frei für die remote Host Namen
            if DownLoad then
              RoundCount := 0;
          end;

        end;
      end
      else
      begin
        // mach erst mal Pause
        sleep(1000 * 10);
        BuildConnectionList(sConnections);
        MainConnection := iPrimaryConnection;
        continue;
      end;

      // Jetzt wieder schlafen
      sleep(1000 * 60); // 1 Minute!

      // (neue?) Ini-Lesen
      sCachedScripts.clear;

      DebugWriteLn('!ReadIni');
      ReadIni;

      inc(RoundCount);

    until false;
  except
    on E: Exception do
      Log('ERROR: Auto.' + E.Message);
  end;
end;

procedure ManualMode;
var
  n: integer;
  inp: string;
  Number: integer;
  _status: string;
begin
  writeln;
  writeln('  _  __                ____              keepcon');
  writeln(' | |/ /___  ___ _ __  / ___|___  _ __    (c) 2003-2015 by Andreas Filsinger');
  writeln(' | '' // _ \/ _ \ ''_ \| |   / _ \| ''_ \');
  writeln(' | . \  __/  __/ |_) | |__| (_) | | | |');
  writeln(' |_|\_\___|\___| .__/ \____\___/|_| |_|  Rev. ' + cVersion);
  writeln('               |_|');

  repeat

    sCachedScripts.clear;
    writeln('----------------------------------------------------------------------');
    writeln('ID = Provider@Interface | Modem-   | Users-    | Gateway | Status | IP');
    writeln('                        | Interface| Interface |         |        |   ');
    writeln('----------------------------------------------------------------------');
    for n := 1 to sConnections.count do
    begin
      _status := Status(sConnections[pred(n)]);
      if _status = cStatusConnected then
        _status := _status + ' | ' + ObtainIP(sConnections[pred(n)])
      else
        _status := _status + ' | ' + cStatusUnset;
      writeln(n:2, ' = ', sConnections[pred(n)], ' | ', iModem, ' | ', iNetwork,
        ' | ', Gateway(sConnections[pred(n)]), ' | ', _status);
    end;
    writeln('---------------------------------------------------------------');
    writeln;
    writeln('ID = Published Hostname | provided IP | local Alias(es) ');
    for n := 1 to iRemotes.count do
    begin
      writeln(n:2, ' = ', iRemotes[pred(n)], ' ', iRemoteIPs[pred(n)],
        ' ' + iHostNames[pred(n)]);
    end;
    writeln;
    write('keepcon@' + iPublishName + ' [' + uptime + 's] # ');
    readln(inp);
    if (inp = 'exit') then
      break;
    inp := inp + '  ';
    Number := pred(strtointdef(inp[2], 0));
    if (Number >= sConnections.count) then
      Number := -1;
    case inp[1] of
      'r', 'R':
        begin
          HangUp(sConnections);
          if Dial(iPrimaryConnection) then
          begin
            // now start the firewall
            Firewall(iPrimaryConnection);
            Upload; // Publish own IPs
            DownLoad; // Download remote IPs
          end;
        end;
      'h', 'H':
        HangUp(sConnections);
      'd', 'D':
        if (Number <> -1) then
          StartConnection(sConnections[Number]);
      'f', 'F':
        if (Number <> -1) then
          Firewall(sConnections[Number]);
      's', 'S':
        if Number <> -1 then
          Status(sConnections[Number]);
      'u', 'U':
        Upload;
      'g', 'G':
        DownLoad;
      't', 'T':
        if Ping then
          writeln('## PING OK ##')
        else
          writeln('## PING FAIL ##');
      'k', 'K':
        DelRoute;
      'a', 'A':
        begin
          AutomaticMode;
          break;
        end;
    else
      writeln;
      writeln('Use one of the following commands:');
      writeln('==================================');
      writeln('     R = (restart all:) (re)Dial & Firewall & Up & Get');
      writeln(' D<ID> = Dial');
      writeln('     H = HangUp');
      writeln(' F<ID> = Firewall');
      writeln(' S<ID> = Status');
      writeln('     U = Upload (Hostname and Templates)');
      writeln('     G = Get remote Names');
      writeln('     T = Test & Check Internet-Connection');
      writeln('     K = Kill default Route');
      writeln('     A = Enter Automatic Mode');
      writeln('exit   = End this keepcon Session');
      writeln('==================================');
      writeln;
    end;
  until false;
end;

function IsParam(s: string): boolean;
var
  n: integer;
begin
  result := false;
  for n := 1 to ParamCount do
    if s = Paramstr(n) then
    begin
      result := true;
      break;
    end;
end;

begin

  // Init
  sConnections := TStringList.create;
  sCachedScripts := TStringList.create;

  iRemotes := TStringList.create;
  iHostNames := TStringList.create;
  iRemoteIPs := TStringList.create;
  iFailOvers := TStringList.create;
  iTemplates := TStringList.create;

  // Params
  DebugMode := IsParam('-d');
  DaemonMode := IsParam('-a');
  XinetdMode := IsParam('-x');

  repeat

    if XinetdMode then
    begin
      Log('INFO: Rev. ' + cVersion + ' enters xinet.d mode');
      break;
    end;

    if DaemonMode then
    begin
      Log('INFO: Rev. ' + cVersion + ' enters automatic mode');
      break;
    end;

    Log('INFO: Rev. ' + cVersion + ' enters manual mode');

  until true;

  // Load Config
  ReadIni;

  // little Test, if Exec works - if not
  // you are inside the ide - disable online debugger
  Deletefile(cWhoAmI);
  Exec('whoami > ' + cWhoAmI);
  if not(FileExists(cWhoAmI)) then
  begin
    Log('FATAL ERROR: can not write to ' + cWhoAmI);
    halt;
  end;

  if XinetdMode then
  begin
    //
    repeat

      // Download remote IPs
      if DownLoad then
        Exec('rcxinetd restart');

      sleep(20 * 1000);

    until false;

  end
  else
  begin

    BuildConnectionList(sConnections);

    if DaemonMode then
    begin
      AutomaticMode;
    end
    else
    begin
      ManualMode;
    end;

  end;

end.
