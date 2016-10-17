{$mode Delphi}
//
// domadd (c) 2008 - 2016  by Andreas Filsinger
// This is Open Source under GNU Licence.
//
// http://orgamon.org
//
program domadd;

uses
  IniFiles, Classes, Unix, SysUtils, SystemLog;

const
  // Allgemeine Konstanten
  cVersion = '1.004'; 
  
  // 
  cHtdocs = '/srv/ftp/';
  cFtdocs = '/srv/FTP/';
  
  cVhosts = '/etc/apache2/vhosts.d/';
  
  // Zentraler Zugriffsdomain
  // Zugriff erfolgt dann über http://*.~cDomain~/
  cDomain = 'orgamon.de';
  
  // Alias Domains die im 2. Rang angegeben werden
  // Durch Semikolon getrennt, kann leer sein!
  cHost   = 'raib25;netzumbau.de';

  cLoginMsg = 'SEWA Internet Datei-Ablage';
  cDaSiPath = '/raid/backup';

var
  // Commandozeile
  DebugMode: boolean = false;
  
  // Arbeitsparameter
  pUser : string; //  User aus dem Kommandozeilenparameter
  uUser : string; // User, der unter Linux anlegbar ist
  PathPrefix : string; // /PathPrefix/{User}
 
  
  pPassword : string;
  pPasswordCrypted : string;
  
  // Zwischenspeicher
  sCrypt : TStringList;
  sVhost : TStringList;

// Log to system Log

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
  writeln('-- '+s);
  try
    if DebugMode then
      Log(s);
    result := fpsystem(s);
  except
    on E: Exception do Log('Exec.' + e.Message);
  end;
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
    k := pos(delimiter, result);
    if k > 0 then
      result := copy(s, 1, pred(k))
    else
      result := s;  
  end else
  begin
   result := s;  
  end;
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

var
 AliasDomains, OneAlias : string;


begin
 DebugMode := true;

 pUser := ParamStr(1);
 pPassword := ParamStr(2);
 if (pUser='') or (pPassword='') then
 begin
  writeln('usage: domadd <User> <Password>'); 
 end else
 begin
 
   // Benutzer anlegen
{
   Exec('echo "'+pPassword+'" | openssl passwd -1 -stdin >domadd.tmp');
   
   Exec('mkpasswd '+pPassword+' >domadd.tmp');
   sCrypt := TStringList.create;
   sCrypt.LoadFromFile('domadd.tmp');
   pPasswordCrypted := sCrypt[0];
   sCrypt.free;
}
  
   
   PathPrefix := cHtdocs;
   if (pos('ftp-',pUser)=1) or (pUser='incoming') then
     PathPrefix := cFtdocs;
   
   // Benutzer hat ev. einen numerischen Namen?
   if (pUser[1] in ['0'..'9']) then
   begin
    uUser := 'u' + pUser;
   end else
   begin
    uUser := pUser;
   end;

   // Add User
   Exec('useradd'+
    ' --home '+PathPrefix+pUser+
    ' --groups ftp'+
    ' --gid www'+
    ' --shell /bin/bash'+
//    ' --password "'+pPasswordCrypted+'"'+
    ' '+uUser );

   // Set Password
   Exec('echo "'+uUser+':'+pPassword+'" | chpasswd');


   if false then
   begin 
   
   // Verzeichnis anlegen 
   Exec('mkdir '+cHtdocs+pUser);
   Exec('chmod 0777 '+cHtdocs+pUser);

   // Aus einem Template die Vorlagen kopieren
   Exec('cp -p '+cHtdocs+cDomain+'/* '+cHtdocs+pUser);

   // Aus einer Datensicherung die Inhalte sichern
   Exec('cp -p '+cDaSiPath+cHtdocs+pUser+'/*.zip '+cHtdocs+pUser);

   // Anpassen der Zugehoerigkeit 
   Exec('chown '+uUser+' '+cHtdocs+pUser+'/*.zip');
   Exec('chgrp www '+cHtdocs+pUser+'/*.zip');

   // Benutzereinstellungen laden
   Exec('cp -p '+cDaSiPath+cHtdocs+pUser+'/*.txt '+cHtdocs+pUser);
   Exec('chown nobody '+cHtdocs+pUser+'/*.txt');
   Exec('chgrp nobody '+cHtdocs+pUser+'/*.txt');
   Exec('chmod 0766 '+cHtdocs+pUser+'/*.txt');
   
   // Zugriffsschutz installieren
   Exec('htpasswd2 -bc ' + cHtdocs + pUser + '/.htpasswd '+ PUser + ' ' + pPassword);
   
   // virtuellen Host anlegen

   svhost := TStringList.create;

   // User
   svhost.add('   <VirtualHost *:80>');
   svhost.add('     ServerName ' + pUser + '.' + cDomain);
   AliasDomains := cHost;
   repeat
    OneAlias := nextp(AliasDomains,';');
    if (OneAlias<>'') then
      svhost.add('     ServerAlias ' + pUser + '.' + OneAlias);
   until (AliasDomains='');   

   svhost.add('     DocumentRoot ' + cHtdocs + pUser );
   svhost.add('   </VirtualHost>');
   svhost.add('');     
   svhost.add('   <Directory '+ cHtdocs + pUser +'>' );
   svhost.add('     AuthType Basic');
   svhost.add('     AuthName "' + cLoginMsg + '"');
   svhost.add('     AuthUserFile ' + cHtdocs + pUser + '/.htpasswd');
   svhost.add('     Require user '+pUser );
   svhost.add('   </Directory>');
         
   svhost.SaveToFile('/etc/apache2/vhosts.d/'+pUser+'.conf'); 
   
   // zzz
   svhost.clear;
   svhost.add('  <VirtualHost _default_>');
   svhost.add('    DocumentRoot '+copy(cHtdocs,1,pred(length(cHtdocs))));
   svhost.add('  </VirtualHost>');

//   svhost.SaveToFile('/etc/apache2/vhosts.d/default.conf'); 
     
   
   sVhost.free;
   
   // apache neu starten
   Exec('rcapache2 restart');
   
   end;
 
 end;
end.


