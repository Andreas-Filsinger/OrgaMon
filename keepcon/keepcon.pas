{$mode Delphi}
//
// keepcon (c) 2003-2011 by Andreas Filsinger
// This is Open Source under GNU Licence.
//
// http://orgamon.org
//
program keepcon;

uses
  IniFiles, Classes, Unix, SysUtils, SystemLog;

const
  // Allgemeine Konstanten
  cVersion = '1.035'; // G:\rev\keepcon.rev
  cWorkingPath = '/root/';
  cTmpOutFileName = 'keepcon.tmp';
  cTmpScriptFileName = 'keepcon.script';
  cIniFile = '/etc/keepcon.conf';
  cWhoAmI = '/root/keepcon.who';
  cLogFile = '/root/keepcon.log';
  cTmpFile = cWorkingPath + cTmpOutFileName;
  cTmpScriptFile = cWorkingPath + cTmpScriptFileName;
  cConnectionDelimiter = '@'; // z.B. "tonline-dsl-business@dsl0"
  cRegularExpressionDelimiter = '"';
  cTheUnknownIP = '0.0.0.0';

  // cinternet Option
  cStatusInfo = 'status: ';
  cDownInfo = 'interface %s is down';
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
  sCachedScripts : TStringList;

  // keepcon.ini
  iFtpServer: string;
  iFTpUser: string;
  iftpPassword: string;
  iftpPath: string;
  iPublishName: string;
  iPrimaryConnection: string;
  iPing: string;
  iRemotes: TStringList;   // PUBLICNAME 
  iHostNames: TStringList; // lokaler Name, default ist der PUBLICNAME
  iRemoteIPs: TStringList; // 
  iFailOvers: TStringList;
  iTemplates: TStringList;
  iNewRoute: boolean;
  iDynDNS: string;
  iDynDNS_User: string;
  iDynDNS_Password: string;

procedure Log(s: string);
const  
 MaxMsgLength = 1024;
var  
 LogMsg: array[0..MaxMsgLength] of char;
begin
  StrPCopy(LogMsg,copy(s,1,pred(MaxMsgLength))); 
  SysLog(LOG_INFO, '%d: %s',[GetProcessID, LogMsg]);
end;

// Execute a Command

function Exec(s: string) : cint;
begin
  try
    if DebugMode then
      Log(s);
    result := fpsystem(s);
  except
    on E: Exception do Log('Exec.' + e.Message);
  end;
end;

procedure CachedExec(script:string);
begin
 if (sCachedScripts.indexof(script)=-1) then
 begin     
  Deletefile(cTmpScriptFile);
  Exec('/root/'+script+' > ' + cTmpScriptFile);
  sCachedScripts.add(script);
  sleep(300);
 end;
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
    iRemotes.Clear;
    iHostNames.Clear;
    iRemoteIps.Clear;
    iTemplates.Clear;
    iFailOvers.Clear;
    with MyIni do
    begin
      iPublishName := ReadString('System', 'publish', '');
      iFtpServer := ReadString('System', 'ftp_server', '');
      iFTpUser := ReadString('System', 'ftp_user', '');
      iFtpPassword := ReadString('System', 'ftp_password', '');
      iFtpPath := ReadString('System', 'ftp_path', '/');
      iPing := ReadString('System', 'ping', '');
      iNewRoute := ReadString('Primary', 'NewRoute', '')='YES';
      iPrimaryConnection := ReadString('Primary', 'provider', '');
      iDynDNS:= ReadString('System','DynDNS','');
      iDynDNS_User:= ReadString('System','DynDNS_user','');
      iDynDNS_Password:= ReadString('System','DynDNS_password','');
      for n := 1 to 10 do
      begin

        // Fremde Hosts, die von Interesse sind
        _host := ReadString('Remote', 'host' + inttostr(n), '');
        if (_host <> '') then
        begin
          k := pos(' ',_host);
          if k=0 then
          begin       
           iRemotes.Add(_host);
           iHostNames.Add(_host);
          end else
          begin
           iRemotes.Add(copy(_host,1,pred(k)));
           iHostNames.Add(copy(_host,succ(k),MaxInt));          
          end; 
          iRemoteIPs.Add(cTheUnknownIP);
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
    on E: Exception do Log('ReadIni.' + e.Message);
  end;
  MyIni.Free;
end;

// upload the TMP File via File Transfer Protokoll

procedure FTPup(iFTPServer, iFTPUser, iFTPPassword, iFTPPath, iFTPFName: string);
var
  s: TStringList;
begin
  s := TstringList.create;
  try

    if not (DaemonMode) then
      writeln('up: ' + iFTPUser + '@' + iFTPServer + iFTPPath + '/' + ExtractFileName(iFTPFName));

    // .netrc
    s.add('machine ' +
      iFtpServer +
      ' login ' +
      iFTpUser +
      ' password ' +
      iftpPassword
      );
    s.SaveToFile(cNetRC);
    Exec('chmod 600 ' + cNetRC);

    // keepcon.ftp
    s.clear;
    if iFTPPath <> '' then
      s.add('cd ' + iftpPath);
    s.add('put ' + cTmpFile + ' ' + ExtractFileName(iFTPFName));
    s.add('quit');
    s.savetofile(ckeepconFtp);

    // call ftp with the prepared script
    Exec('su root -c "' + cFTPcall + iFtpServer + ' < ' + ckeepconFtp + '" >>' + cLogFile);

  except
    on E: Exception do Log('FTPUp.' + e.Message);
  end;
  s.free;
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
    delete(s, 1, pred(k + length(delimiter)));
  end else
  begin
    result := s;
    s := '';
  end;
end;

function nextp(s: string; delimiter: string; SkipCount: integer; WithRest: boolean = false): string; overload;
var
  n, k: integer;
begin
  for n := 1 to SkipCount do
  begin
    k := pos(delimiter, s);
    if (k > 0) then
    begin
      delete(s, 1, pred(k+length(delimiter)));
    end else
    begin
      result := '';
      exit;
    end;  
  end;

  // cut the unneeded rest
  if not (WithRest) then
  begin
    k := pos(delimiter, s);
    if k > 0 then
      result := copy(s, 1, pred(k))
    else
      result := s;  
  end else
  begin
   result := s;  
  end;
end;

function TransportInterface(connection: string): string; // Beispiel "dsl0", bei "tonline-dsl-business@dsl0"
begin
  result := nextp(connection, cConnectionDelimiter, 1)
end;

function ProviderSpecifier(connection: string): string;
begin
  result := nextp(connection, cConnectionDelimiter, 0); // Beispiel "tonline-dsl-business", bei "tonline-dsl-business@dsl0"
end;

// Make a list of all Connections / Providers

procedure GetConnections(sConnections: TStrings);
var
 n : integer;
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
     for n := 0 to pred(s.Count) do
     begin
       case AutoMataState of
         0: begin // search for eth1, ippp0 ....
             if pos(TransportInterface(connection), s[n]) = 1 then
               AutoMataState := 1;
           end;
         1: begin // search now for "inet addr:"
             k := pos(cIPhit, s[n]);
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
     on E: Exception do Log('ObtainIP-ifconfig.' + e.Message);
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
     for n := 0 to pred(s.Count) do
     begin
       case AutoMataState of
         0: begin // search for eth1, ippp0 ....
             if pos(ProviderSpecifier(connection), trim(s[n])) = 1 then
               AutoMataState := 1;
           end;
         1: begin // search now for "inet addr:"
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
     on E: Exception do Log('ObtainIP-script.' + e.Message);
   end;
   s.free;
  end;
 
  
begin
  result := cTheUnknownIP;

  if pos('.sh',TransportInterface(connection))>0 then
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
      if (Fname <> '') then
        if FileExists(FName) then
        begin
          sl.LoadFromFile(FName);
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
    for n := 0 to pred(sl.Count) do
    begin
      SetK;
      if (k > 0) then
      begin
        repeat
          sl[n] := copy(sl[n], 1, pred(k)) +
            TheNewIP +
            copy(sl[n], k + length(cIPplaceholder), MaxInt);
          SetK;
        until (k = 0);
      end;
    end;

    sl.SaveToFile(cTmpFile);

    result := true;

  except
    on E: Exception do Log('Patch.' + e.Message);
  end;
  sl.Free;
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
begin
  s := TStringList.create;
  try
    interf := TransportInterface(connection);
    DeleteFile(cTmpFile);
    Exec('ifstatus ' +
      interf +
      ' > ' +
      cTmpFile
      );
    s.loadfromfile(cTmpFile);
    for n := 0 to pred(s.count) do
    begin
      if (pos(cStatusInfo,s[n])=1) then
      begin
        result := nextp(s[n], cStatusInfo, 1);
        break; 
      end;
      if (s[n]=format(cDownInfo,[interf])) then
      begin
        result := cStatusDisconnected;
        break;      
      end;
      if (pos(interf,s[n])>0) and (pos('is down',s[n])>pos(interf,s[n])) then
      begin
        result := cStatusDisconnected;
        break;      
      end;
    end;
    if (result=cStatusUnknown) then
     for n := 0 to pred(n) do
      if (s[n]=format(cUpInfo,[interf])) then
      begin
       result := cStatusConnected;
       break;
      end;   
  except
    on E: Exception do Log('Status.' + e.Message);
  end;
  s.Free;
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
      if (pos(wan,s[n])=1) then
      begin
        result := nextp(s[n], ':', 1);
        repeat

         if result='Connected' then
         begin
          result := cStatusConnected;
          break;
         end;
         
         if result='Disconnected' then
         begin
          result := cStatusDisconnected;
          break;         
         end;
         
         Log('Status.Unknown Status "'+result+'"');
         result := cStatusUnset;

        until true;
        break; 
      end;
    end;
  except
    on E: Exception do Log('Status.' + e.Message);
  end;
  s.Free;
end; 

begin
  result := cStatusUnknown;
  if pos('.sh',TransportInterface(connection))>0 then
   via_script
  else
   via_ifstatus; 
end;

function Gateway(connection: string): string;
var
  s: TStringList;
  n,k: integer;
  interf: string;
  sRoute: string;
begin
  result := cStatusUnset;
  s := TStringList.create;
  try
    interf := TransportInterface(connection);
    DeleteFile(cTmpFile);
    Exec('route -n' +
      ' > ' +
      cTmpFile
      );
    s.loadfromfile(cTmpFile);
    for n := 0 to pred(s.count) do
    begin
      if pos(cScriptIdentifier,interf)=0 then
       if (pos(interf,s[n])=0) then
        continue; 
      if (pos(' U',s[n])<21) then
        continue;
      sRoute := s[n];
      repeat
        k := pos('  ',sRoute);
        if k=0 then
          break;
        delete(sRoute,k,1);
      until false;
      // skip zero gateway
      sRoute := nextp(sRoute,' ',1);
      if (sRoute='0.0.0.0') then
       continue;
      // store, but take last active gateway 
      result := sRoute;
    end;
  except
    on E: Exception do Log('Status.' + e.Message);
  end;
  s.Free;
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
    if pos(cScriptIdentifier,connection)=0 then
  if Status(connection) <> cStatusConnected then
  begin
    // Schritt 1 : Die aktuelle Route loeschen
    // damit der Weg frei wird fuer die neue Route
     if iNewRoute then
      DelRoute;

    // Schritt 2 : Den richtigen Provider aktivieren
    Exec('ifup ' +
      TransportInterface(connection) 
      );

  end;
end;

procedure Firewall(connection: string);
begin
 try
  if pos(cScriptIdentifier,connection)=0 then
   Exec(
    {} cFirewallApp +
    {} ' start ' +
    {} TransportInterface(connection));
  except
    on E: Exception do Log('Firewall.' + e.Message);
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
      if not (DaemonMode) then
        if (Trys > 0) then
          write('H');
      inc(Trys);
      OneUp := false;
      for n := 0 to pred(sConnections.count) do
       if pos(cScriptIdentifier,sConnections[n])=0 then
       begin
         _status := Status(sConnections[n]);
         if (_status = cStatusConnected) or (_status = cStatusConnecting) then
         begin
           OneUp := true;
           Exec('ifdown '+ TransportInterface(sConnections[n]) );
           sleep(100);
         end;
       end;
    until not (OneUp) or (Trys = 3);
  except
    on E: Exception do Log('HangUp.' + e.Message);
  end;
end;

procedure Upload(Connection: string = '');
var
  n: integer;
  TheNewIP: string;
  FName: string;
begin
  try
    if (Connection = '') then
      Connection := ActiveConnection;
    TheNewIP := ObtainIP(Connection);

    if (iFTPServer <> '') then
    begin
      Patch('', TheNewIP);
      FTPup(iFTPServer, iFTPUser, iFTPPassword, iFTPPath, iPublishName + '.html');
    end;
    
    if (iDynDNS<>'') then
    begin
     Exec(
      { command } 'wget '+
      { no spam } '--quiet '+
      { no file } '--output-document=- '+
      { user    } '--http-user='+iDynDNS_User+' '+
      { pwd     } '--http-password='+iDynDNS_Password+' '+
      { URL     } 'https://members.dyndns.org/nic/update?'+
      { hostnme } 'hostname='+iDynDNS+
      { ip      } '\&myip='+TheNewIP+' '+
      { quiet   } '&> /dev/null');
      Log('DynDNS '+iDynDNS+' set to '+ TheNewIP );
    end;

    for n := 0 to pred(iTemplates.count) do
    begin
      FName := nextp(iTemplates[n], cTemplateDelimiter, cTemplateParam_FName);
      if Patch(FName, TheNewIP) then
      begin
        if (FName <> '') then
          FTPup(
            nextp(iTemplates[n], cTemplateDelimiter, cTemplateParam_FTPHost),
            nextp(iTemplates[n], cTemplateDelimiter, cTemplateParam_FTPUser),
            nextp(iTemplates[n], cTemplateDelimiter, cTemplateParam_FTPpwd),
            nextp(iTemplates[n], cTemplateDelimiter, cTemplateParam_FTPpath),
            FName)
        else
          FTPup(
            nextp(iTemplates[n], cTemplateDelimiter, cTemplateParam_FTPHost),
            nextp(iTemplates[n], cTemplateDelimiter, cTemplateParam_FTPUser),
            nextp(iTemplates[n], cTemplateDelimiter, cTemplateParam_FTPpwd),
            nextp(iTemplates[n], cTemplateDelimiter, cTemplateParam_FTPpath),
            iPublishName + '.html');
      end;
    end;
  except
    on E: Exception do Log('Upload.' + e.Message);
  end;
end;

var
 _Ping_AnzahlHosts : integer = -1;
 _Ping_Skip   : integer = 0;

function Ping: boolean;
var
  Target, tmpTarget: string;
  Host : string;
  SysResultCode: cInt;
  iHost : integer;
begin
  result := false;
  if (iPing = '') then
    Target := iFtpServer
  else
    Target := iPing;

  // Sollte Ping noch nie verwendet worden sein
  // muss zunaechst die Anzahl der Hosts bestimmt werden
  if (_Ping_AnzahlHosts<1) then
  begin
   tmpTarget := Target;
   _Ping_AnzahlHosts := 0;
   while (tmpTarget <> '') do
   begin
     inc(_Ping_AnzahlHosts);
     nextp(tmpTarget,cTemplateDelimiter);
   end;
   if DebugMode then
     writeln(_Ping_AnzahlHosts:2,' Ping-Hosts!');
  end;
  
  // Bei iNewRoute pruefen wir auch die Route
  // da es sein kann, dass auf "eth1" z.B. ein
  // Modem haengt - aber auf eth0 ein DHCP-Client
  // aktiv ist. Wir wollen die default Route auf
  // eth1 aktiv haben! Jedoch, kann durch Neustart
  // des eth0 ev. die Standard-Route auf das dort
  // angebotene Gateway gesetzt werden. Ping wuerde
  // das nicht auffallen, da das Internet via eth0
  // ev. einwandfrei funktioniert. 
  if iNewRoute then
   if (GateWay(iPrimaryConnection)=cStatusUnset) then
   begin
     Log('Route fail!'); 
     exit;  
   end;

  // Sollte der Skip-Count die Verwendung des
  // letzten Hosts verhindern, so wird wieder der
  // erste Host verwendet.
  if (_Ping_Skip>=_Ping_AnzahlHosts) then
   _Ping_Skip := 0;

  iHost := 0;
  while (Target <> '') do
  begin
    // Skip?
    inc(iHost);
    Host := nextp(Target, cTemplateDelimiter);
    if (iHost<=_Ping_Skip) then
     continue;
    if DebugMode then 
      writeln(_Ping_Skip, ' skipped!'); 

    // Ping!
    try
      SysResultCode := Exec('ping -c 1 -w 2 '+Host+' &> /dev/null');
 
      if (SysResultCode=0) then
      begin
        result := true;
        break;
      end;
      Log('Ping ' + Host + ' fail!');
    except
      Log('Ping ' + Host + ' except!');
    end;
  end;
  inc(_Ping_Skip);
  
 end;

function Dial(Connection: string): boolean;
var
  n: integer;
  IsConnected: boolean;
  HasIP: boolean;
  ErrorCount: integer;
begin
  result := false;
  try
    ErrorCount := 0;
    StartConnection(Connection);
    repeat

      // establish the connection, timeout=15s
      n := 0;
      repeat
        inc(n);
        IsConnected := (Status(Connection) = cStatusConnected);
        if IsConnected or (n >= 15) then
          break;
        if not (DaemonMode) then
          write('c');
        sleep(1000);
      until false;
      if not (IsConnected) then
      begin
        inc(ErrorCount);
        break;
      end;

      // wait for the given IP, timeout=5s
      n := 0;
      repeat
        inc(n);
        HasIP := (ObtainIP(Connection) <> cTheUnknownIP);
        if HasIP or (n >= 5) then
          break;
        if not (DaemonMode) then
          write('i');
        sleep(1000);
      until false;
      if not (HasIp) then
      begin
        inc(ErrorCount);
        break;
      end else
      begin
       // wait for more details comming up
        sleep(250);
      end;

    until true;
    result := (ErrorCount = 0)
  except
    on E: Exception do Log('Dial.' + e.Message);
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
    s := TstringList.create;
    try
      // .netrc
      s.add('machine ' +
        iFtpServer +
        ' login ' +
        iFTpUser +
        ' password ' +
        iftpPassword
        );
      s.SaveToFile(cNetRC);
      Exec('chmod 600 ' + cNetRC);

      // keepcon.ftp
      s.clear;
      s.add('cd ' + iftpPath);
      for n := 0 to pred(iRemotes.count) do
      begin
        DeleteFile(cWorkingPath + iRemotes[n] + '.html');
        s.add('get ' + iRemotes[n] + '.html ' + cWorkingPath + iRemotes[n] + '.html');
      end;
      s.add('quit');
      s.savetofile(ckeepconFtp);

      // call ftp
      Exec('su root -c "' + cFTPcall + iFtpServer + ' < ' + ckeepconFtp + '" >>' + cLogFile);

      // process the files
      for n := 0 to pred(iRemotes.count) do
      begin
        iRemoteIPS[n] := cTheUnknownIP;
        if FileExists(cWorkingPath + iRemotes[n] + '.html') then
        begin
          s.LoadFromFile(cWorkingPath + iRemotes[n] + '.html');
          DeleteFile(cWorkingPath + iRemotes[n] + '.html');
          for m := 0 to pred(s.Count) do
          begin
            if length(s[m]) > 0 then
            begin
              if (pos('.', s[m]) > 0) and (s[m][1] in ['0'..'9']) then
              begin
                iRemoteIPS[n] := s[m];
                break;
              end;
            end;
          end;
        end else
        begin
          Log('unknown host "' + iRemotes[n] + '"');
        end;
      end;

      // modify /etc/hosts (if nessesary)
      HostChangeCount := 0;

      s.LoadFromFile('/etc/hosts');

      for m := 0 to pred(iRemotes.count) do
      begin
        IPAlreadyResolved := false;
        for n := 0 to pred(s.Count) do
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
              if (pos(iRemoteIPs[m], OneLine) > 0) and (iRemoteIPs[m] <> cTheUnknownIP) then
              begin
                // old IP OK!
                IPAlreadyResolved := true;
                break;
              end else
              begin
                // IP changed
                if (iRemoteIPs[m] <> cTheUnknownIP) then
                begin
                  // IP changed
                  s[n] := iRemoteIPs[m] +
                    '     ' +
                    iHostNames[m] +
                    '     # updated by keepcon';
                end else
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
        if not (IPAlreadyResolved) and (iRemoteIPs[m] <> cTheUnknownIP) then
        begin
          // insert this new line
          s.Add(
            iRemoteIPs[m] +
            '     ' +
            iHostNames[m] +
            '     # inserted by keepcon'
            );
          inc(HostChangeCount);
        end;
      end;

      if (HostChangeCount > 0) then
      begin
        result := true;
        s.SaveToFile('/etc/hosts');
        Log('/etc/hosts modified');

        // restart samba name server
        exec('rcnmb restart');
      end;
    except
      on E: Exception do Log('DownLoad.' + e.Message);
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
  
  procedure DebugWrite(s:string);
  begin
   if DebugMode then
    write(s);  
  end;
  
  procedure DebugWriteLn(s:string);
  begin
   if DebugMode then
    writeln(s);  
  end;

begin
  RoundCount := 0;
  FirstLoop := true;
  MainConnection := iPrimaryConnection;
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
            FireWall(MainConnection);
            DebugWriteLn('!Ping');
            if Ping then
            begin
              DebugWriteLn('!Upload');
              Upload;
              DebugWriteLn('!SaveIP');
              SaveIP;
              Log('reuse IP [' + actIP + ']');
            end else
            begin
              Log('panic, ping after fresh "connected" fails ...');
              DebugWriteLn('!HangUp');
              HangUp(sConnections);
            end;
          end else
          begin
            // Unverbunden!
            DebugWriteLn('!HangUp');
            HangUp(sConnections);
            DebugWriteLn('!Dial');
            if Dial(MainConnection) then
            begin
            DebugWriteLn('!Firewall');
              Firewall(MainConnection);
            DebugWriteLn('!Upload');
              Upload; // Publish own IPs
            DebugWriteLn('!SaveIP');
              SaveIP;
              Log('new IP [' + actIP + '] after "initial dial"');
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

          DebugWriteLn('!Firewall');
            Firewall(MainConnection); // now start the firewall
          DebugWriteLn('!Upload');
            Upload; // Publish own IP to different hosts
          DebugWriteLn('!Download');
            DownLoad; // Download remote IPs
          DebugWriteLn('!SaveIP');
            SaveIP;
            Log('new IP [' + actIP + '] after unconnected');

          end else
          begin
            Log('panic, can not connect ...');
            GetConnections(sConnections);
          end;
          RoundCount := 0;
        end else
        begin

          // Connection OK, refresh the newest hostnamens from internet
          if ChangedIP then
          begin
            RoundCount := 0;
          DebugWriteLn('!UpLoad');
            UpLoad;
          DebugWriteLn('!SaveIP');
            SaveIP;
            Log('reuse IP [' + actIP + '] after "ghost redial"');
          end;


          if (RoundCount mod 3 = 0) then
          begin

            // Ping die Verbindung prüfen
          DebugWriteLn('!Ping');
            if not (Ping) then
            begin
              RoundCount := 0;
              Log('panic, ping at status "connected" fails ...');
          DebugWriteLn('!HangUp');
              HangUp(sConnections);
              continue;
            end;

            // Weg frei für die remote Host Namen
            if DownLoad then
              RoundCount := 0;
          end;

        end;
      end else
      begin
        // mach erst mal Pause
        sleep(1000 * 10);
        GetConnections(sConnections);
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
      if (RoundCount mod 20 = 0) then
        Log('Round ' + inttostr(RoundCount) + ' of silence!');


  until false;
    except
      on E: Exception do Log('Auto.' + e.Message);
    end;
end;

procedure ManualMode;
var
  n: integer;
  inp: string;
  Number: integer;
  _Status: string;

begin
  writeln;
  writeln('keepcon Rev. ' + cVersion + ' (c) Andreas Filsinger, orgamon.org');
  writeln('---------------------------------------------------------');
  writeln;

  repeat
      sCachedScripts.clear;

    writeln('ID = Provider@Interface | Gateway | Status | IP');
    writeln('---------------------------------------------------------------');
    for n := 1 to sConnections.count do
    begin
      _Status := Status(sConnections[pred(n)]);
      if _Status = cStatusConnected then
        _Status := _Status + ' | ' + ObtainIP(sConnections[pred(n)])
      else
       _Status := _Status + ' | ' + cStatusUnset;  
      writeln(n:2,
        ' = ',
        sConnections[pred(n)],
        ' | ',
        Gateway(sConnections[pred(n)]),
        ' | ',
        _Status);
    end;
    writeln('---------------------------------------------------------------');
    writeln;
    writeln('ID = Published Hostname | provided IP | local Alias(es) ');
    for n := 1 to iRemotes.count do
    begin
      writeln(n:2,
        ' = ',
        iRemotes[pred(n)],
        ' ',
        iRemoteIPs[pred(n)],
        ' '+iHostNames[pred(n)]);
    end;
    writeln;
    write('keepcon@' + iPublishName + ' # ');
    readln(Inp);
    if (Inp = 'exit') then
      break;
    Inp := Inp + '  ';
    Number := pred(strtointdef(Inp[2], 0));
    if (Number >= sConnections.count) then
      Number := -1;
    case Inp[1] of
      'r', 'R': begin
          HangUp(sConnections);
          if Dial(iPrimaryConnection) then
          begin
                      // now start the firewall
            Firewall(iPrimaryConnection);
            Upload; // Publish own IPs
            DownLoad; // Download remote IPs
          end;
        end;
      'h', 'H': HangUp(sConnections);
      'd', 'D': if (number <> -1) then
          StartConnection(sConnections[Number]);
      'f', 'F': if (number <> -1) then
          Firewall(sConnections[Number]);
      's', 'S': if number <> -1 then
          Status(sConnections[Number]);
      'u', 'U': Upload;
      'g', 'G': DownLoad;
      't', 'T': if ping then
                  writeln('## PING OK ##')
                else
                  writeln('## PING FAIL ##');  
      'k', 'K': DelRoute;
      'a', 'A': begin
          AutoMaticMode;
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

  if XinetdMode then
    Log('Rev. ' + cVersion + ' enters xinet.d mode');
  if DaemonMode then
    Log('Rev. ' + cVersion + ' enters automatic mode');

  // Load Config
  ReadIni;

  // little Test, if exec works - if not
  // you are inside the ide - disable online debugger
  DeleteFile(cWhoAmI);
  Exec('whoami > ' + cWhoAmI);
  if not (FileExists(cWhoAmI)) then
  begin
    Log('panic, can not write to ' + cWhoAmI);
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

  end else
  begin

    // load core info
    GetConnections(sConnections);

    //
    if DaemonMode then
    begin
      AutomaticMode;
    end else
    begin
      ManualMode;
    end;

  end;

end.


