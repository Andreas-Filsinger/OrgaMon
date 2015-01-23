{$MODE Delphi}
//
// domadd (c) 2008-2012 by Andreas Filsinger
// This is Open Source under GNU Licence.
//
// http://orgamon.org
//
program domadd;

uses
  IniFiles, Classes, Unix, SysUtils, SystemLog;

const
  // Allgemeine Konstanten
  cVersion = '1.002'; // G:\rev\domadd.rev

  //
  cHtdocs = '/srv/www/htdocs/';
  cVhosts = '/etc/apache2/vhosts.d/';

  // Umfeld-Parameter
  cDomain = 'orgamon.de';
  cHost = 'raib25';
  cLoginMsg = 'SEWA Internet Datei-Ablage';
  cDaSiPath = '/raid/backup';

var
  // Commandozeile
  DebugMode: boolean = false;

  // Arbeitsparameter
  pUser: string; // User aus dem Kommandozeilenparameter
  uUser: string; // User, der unter Linux anlegbar ist

  pPassword: string;
  pPasswordCrypted: string;

  // Zwischenspeicher
  sCrypt: TStringList;
  sVhost: TStringList;

  // Log to system Log

procedure Log(s: string);
const
  MaxMsgLength = 1024;
var
  LogMsg: array [0 .. MaxMsgLength] of char;
begin
  StrPCopy(LogMsg, copy(s, 1, pred(MaxMsgLength)));
  SysLog(LOG_INFO, '%d: %s', [GetProcessID, LogMsg]);
end;

// Execute a Command

function Exec(s: string): cint;
begin
  writeln('-- ' + s);
  try
    if DebugMode then
      Log(s);
    result := fpsystem(s);
  except
    on E: Exception do
      Log('Exec.' + E.Message);
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
    k := pos(Delimiter, result);
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
  DebugMode := true;

  pUser := Paramstr(1);
  pPassword := Paramstr(2);
  if (pUser = '') or (pPassword = '') then
  begin
    writeln('usage: domadd <User> <Password>');
  end
  else
  begin

    // Benutzer anlegen
    Exec('mkpasswd ' + pPassword + ' >domadd.tmp');
    sCrypt := TStringList.create;
    sCrypt.LoadFromFile('domadd.tmp');
    pPasswordCrypted := sCrypt[0];
    sCrypt.free;

    // Benutzer hat ev. einen numerischen Namen?
    if (pUser[1] in ['0' .. '9']) then
    begin
      uUser := 'u' + pUser;
    end
    else
    begin
      uUser := pUser;
    end;

    Exec('useradd' + ' --home ' + cHtdocs + pUser + ' --groups ftp' +
      ' --gid www' + ' --shell /bin/false' + ' --password "' + pPasswordCrypted
      + '"' + ' ' + uUser);

    // Verzeichnis anlegen
    Exec('mkdir ' + cHtdocs + pUser);
    Exec('chmod 0777 ' + cHtdocs + pUser);

    // Aus einem Template die Vorlagen kopieren
    Exec('cp -p ' + cHtdocs + cDomain + '/* ' + cHtdocs + pUser);

    // Aus einer Datensicherung die Inhalte sichern
    Exec('cp -p ' + cDaSiPath + cHtdocs + pUser + '/*.zip ' + cHtdocs + pUser);

    // Anpassen der Zugehoerigkeit
    Exec('chown ' + uUser + ' ' + cHtdocs + pUser + '/*.zip');
    Exec('chgrp www ' + cHtdocs + pUser + '/*.zip');

    // Benutzereinstellungen laden
    Exec('cp -p ' + cDaSiPath + cHtdocs + pUser + '/*.txt ' + cHtdocs + pUser);
    Exec('chown nobody ' + cHtdocs + pUser + '/*.txt');
    Exec('chgrp nobody ' + cHtdocs + pUser + '/*.txt');
    Exec('chmod 0766 ' + cHtdocs + pUser + '/*.txt');

    // Zugriffsschutz installieren
    Exec('htpasswd2 -bc ' + cHtdocs + pUser + '/.htpasswd ' + pUser + ' ' +
      pPassword);

    // virtuellen Host anlegen

    sVhost := TStringList.create;

    // User
    sVhost.add('   <VirtualHost *:80>');
    sVhost.add('     ServerName ' + pUser + '.' + cDomain);
    sVhost.add('     ServerAlias ' + pUser + '.' + cHost);
    sVhost.add('     DocumentRoot ' + cHtdocs + pUser);
    sVhost.add('   </VirtualHost>');
    sVhost.add('');
    sVhost.add('   <Directory ' + cHtdocs + pUser + '>');
    sVhost.add('     AuthType Basic');
    sVhost.add('     AuthName "' + cLoginMsg + '"');
    sVhost.add('     AuthUserFile ' + cHtdocs + pUser + '/.htpasswd');
    sVhost.add('     Require user ' + pUser);
    sVhost.add('   </Directory>');

    sVhost.SaveToFile('/etc/apache2/vhosts.d/' + pUser + '.conf');

    // zzz
    sVhost.clear;
    sVhost.add('  <VirtualHost _default_>');
    sVhost.add('    DocumentRoot ' + copy(cHtdocs, 1, pred(length(cHtdocs))));
    sVhost.add('  </VirtualHost>');

    // svhost.SaveToFile('/etc/apache2/vhosts.d/default.conf');

    sVhost.free;

    // apache neu starten
    // Exec('rcapache2 restart');

  end;

end.
