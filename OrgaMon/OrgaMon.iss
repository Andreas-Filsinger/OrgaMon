; -- OrgaMon.iss --
;

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
PrivilegesRequired=Admin
AppName=OrgaMon
AppVerName=OrgaMon «RevMitPunkt»
AppCopyright=Copyright (C) 1988-2018 Andreas Filsinger
DefaultDirName={pf}\OrgaMon
DefaultGroupName=OrgaMon
UninstallDisplayIcon={app}\OrgaMon.exe
LicenseFile=Distribution\Lizenz\gpl-3.0.txt
DisableStartupPrompt=yes
DisableReadyPage=yes
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyMemo=yes
OutputDir=..\..\CargoBay
OutputBaseFilename=Setup-OrgaMon-«RevOhnePunkt»
AppVersion=«RevMitPunkt»
VersionInfoVersion=«RevMitPunkt».0.0
Compression=lzma/max
WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP

[Dirs]
Name: "{app}\doc"
Name: "{app}\intl"
Name: "{app}\udf"

Name: "{userdocs}\OrgaMon"; Flags: uninsneveruninstall
Name: "{userdocs}\OrgaMon\Daten"; Flags: uninsneveruninstall
Name: "{userdocs}\OrgaMon\Daten\OLAP"; Flags: uninsneveruninstall
Name: "{userdocs}\OrgaMon\Daten\HTML Vorlagen"; Flags: uninsneveruninstall
Name: "{userdocs}\OrgaMon\Daten\System"; Flags: uninsneveruninstall
Name: "{userdocs}\OrgaMon\Daten\Noten"; Flags: uninsneveruninstall
Name: "{userdocs}\OrgaMon\Daten\LeereDatenbank"; Flags: uninsneveruninstall
Name: "{userdocs}\OrgaMon\Daten\anfisoft"; Flags: uninsneveruninstall

[Files]

; Anwendungen
Source: "«ProgramFiles»OrgaMon\OrgaMon.exe"; DestDir: "{app}"; BeforeInstall: WaitForExit; Flags: ignoreversion restartreplace
Source: "«ProgramFiles»OrgaMon\cOrgaMon.exe"; DestDir: "{app}"; BeforeInstall: WaitForExit; Flags: ignoreversion restartreplace
Source: "Distribution\Hilfe\OrgaMon-VNC.exe"; DestDir: "{app}"; Flags: ignoreversion restartreplace
Source: "Distribution\Lizenz\gpl-3.0.txt"; DestDir: "{app}"; DestName: "Lizenz.txt"; Flags: onlyifdoesntexist

; Shared Object: infozip
Source: "..\infozip\zip32z64.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\infozip\unzip32.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\infozip\unzip.exe"; DestDir: "{app}"; Flags: onlyifdoesntexist uninsneveruninstall
Source: "..\infozip\unzip.txt"; DestDir: "{app}"; Flags: onlyifdoesntexist uninsneveruninstall

; Shared Object: libxml2
Source: "..\libxml2\bin\iconv.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\zlib1.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\libxml2.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall

; Shared Object: OpenSSL
Source: "..\openssl\openssl-1.0.2o-i386-win32\libeay32.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\openssl\openssl-1.0.2o-i386-win32\ssleay32.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall


; Shared Object: Firebird embedded Server
Source: "..\FirebirdEmbed\Firebird-2.5.4.26856-0_Win32_embed\*"; DestDir: "{app}"; Flags: recursesubdirs

; Anwendungs Zubehör
Source: "..\..\CargoBay\OrgaMon_Info.html"; DestDir: "{app}"

; Anwendungsdaten
Source: "Distribution\OrgaMon-Dokumente.ini"; DestDir: "{userdocs}\OrgaMon"; DestName: "OrgaMon.ini"; Flags: onlyifdoesntexist
Source: "Distribution\sicherung_00000006-2.5.fdb"; DestDir: "{userdocs}\OrgaMon"; DestName: "OrgaMon.fdb"; Flags: onlyifdoesntexist

Source: "Distribution\OrgaMon-Daten.ini"; DestDir: "{userdocs}\OrgaMon\Daten"; DestName: "OrgaMon.ini"; Flags: onlyifdoesntexist

Source: "Distribution\OLAP\*"; DestDir: "{userdocs}\OrgaMon\Daten\OLAP"; Flags: onlyifdoesntexist
Source: "Distribution\Mahnung.Unplausibel.OLAP.txt"; DestDir: "{userdocs}\OrgaMon\Daten\OLAP"
Source: "Distribution\HTML Vorlagen\*"; DestDir: "{userdocs}\OrgaMon\Daten\HTML Vorlagen"; Flags: onlyifdoesntexist
Source: "Distribution\System\*"; DestDir: "{userdocs}\OrgaMon\Daten\System"; Flags: onlyifdoesntexist
Source: "Distribution\Noten\*"; DestDir: "{userdocs}\OrgaMon\Daten\Noten"; Flags: onlyifdoesntexist
Source: "Distribution\LeereDatenbank\*"; DestDir: "{userdocs}\OrgaMon\Daten\LeereDatenbank"; Flags: onlyifdoesntexist
Source: "Distribution\anfisoft\*"; DestDir: "{userdocs}\OrgaMon\Daten\anfisoft"; Flags: onlyifdoesntexist

; diese Fonts sind nötig bei der Verwendung unter Wine
;Source: "Distribution\WineFonts\wingding.ttf"; DestDir: "{fonts}"; FontInstall: "Wingdings"; Flags: onlyifdoesntexist uninsneveruninstall
;Source: "Distribution\WineFonts\tahoma.ttf"; DestDir: "{fonts}"; FontInstall: "Tahoma"; Flags: onlyifdoesntexist uninsneveruninstall
;Source: "Distribution\WineFonts\verdana.ttf"; DestDir: "{fonts}"; FontInstall: "Verdana"; Flags: onlyifdoesntexist uninsneveruninstall
;Source: "Distribution\WineFonts\webdings.ttf"; DestDir: "{fonts}"; FontInstall: "Webdings"; Flags: onlyifdoesntexist uninsneveruninstall

[Icons]
Name: "{group}\OrgaMon"; Filename: "{app}\OrgaMon.exe"
Name: "{group}\OrgaMon Info"; Filename: "{app}\OrgaMon_Info.html"
Name: "{group}\Direkthilfe"; Filename: "{app}\OrgaMon-VNC.exe"

[Run]
Filename: "{app}\OrgaMon.exe"; Description: "Starte OrgaMon"; Parameters: "{param:PostExec}"; Flags: postinstall nowait

[Code]
procedure WaitForExit;
var
 DestFName : string;
 n : integer;
begin
 DestFName := ExpandConstant(CurrentFileName);
 if FileExists(DestFName) then
 begin
  n := 0;
  repeat
   sleep(1000);
   DelayDeleteFile(DestFName,4);
   if not(FileExists(DestFName)) then
    break;
   n := n + 1;
   if (n=8) then
    break;
   beep;
  until false;
 end;
 if FileExists(DestFName) then
 begin
  MsgBox(DestFName + #13 +
   'kann nicht überschrieben werden!'+ #13+#13+
   'Ursachen können sein:'+#13+
   '* Sie haben nicht ausreichende Benutzerrechte -> Fragen Sie den Administrator'+#13+
   '* OrgaMon läuft noch -> Starten Sie den Taskmanager und beenden Sie alle OrgaMon Anwendungen.',mbError, MB_OK);
 end;
end;
