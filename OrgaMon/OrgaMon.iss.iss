; -- OrgaMon.iss --
;

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
PrivilegesRequired=Admin
AppName=OrgaMon
AppVerName=OrgaMon 8.764
AppCopyright=Copyright (C) 1988-2024 Andreas Filsinger
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
OutputBaseFilename=Setup-OrgaMon-8764
AppVersion=8.764
VersionInfoVersion=8.764.0.0
Compression=zip
WizardImageFile=compiler:WizModernImage.bmp
WizardSmallImageFile=compiler:WizModernSmallImage.bmp

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
Source: "C:\Program Files (x86)\OrgaMon\OrgaMon.exe"; DestDir: "{app}"; BeforeInstall: WaitForExit; Flags: ignoreversion restartreplace
Source: "C:\Program Files (x86)\OrgaMon\OrgaMon.exe"; DestDir: "{app}"; DestName: "OrgaMon-RC.exe"; BeforeInstall: WaitForExit; Flags: ignoreversion restartreplace
Source: "C:\Program Files (x86)\OrgaMon\cOrgaMon.exe"; DestDir: "{app}"; BeforeInstall: WaitForExit; Flags: ignoreversion restartreplace
Source: "Distribution\Lizenz\gpl-3.0.txt"; DestDir: "{app}"; DestName: "Lizenz.txt"; Flags: onlyifdoesntexist

; libxml2
Source: "..\libxml2\bin\iconv.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\zlib1.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\libxml2.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall

; OpenSSL
Source: "..\openssl\openssl-1.0.2u-i386-win32\libeay32.dll"; DestDir: "{app}"; Flags: 32bit restartreplace uninsneveruninstall
Source: "..\openssl\openssl-1.0.2u-i386-win32\ssleay32.dll"; DestDir: "{app}"; Flags: 32bit restartreplace uninsneveruninstall

; tgputtylib
Source: "..\TGPuttyLib\tgputtylib.dll"; DestDir: "{app}"; Flags: 32bit restartreplace uninsneveruninstall

; Firebird embedded Server
Source: "..\FirebirdEmbed\Firebird-3.0.12.33787-0_Win32_embed\*"; DestDir: "{app}"; Flags: recursesubdirs
Source: "..\FirebirdEmbed\Firebird-3.0.12.33787-0_Win32_embed\fbclient.dll"; DestDir: "{app}"; DestName: "gds32.dll"; 

; Anwendungs Zubeh�r
Source: "..\..\CargoBay\OrgaMon_Info.html"; DestDir: "{app}"

; Anwendungsdaten
Source: "Distribution\OrgaMon-Dokumente.ini"; DestDir: "{userdocs}\OrgaMon"; DestName: "OrgaMon.ini"; Flags: onlyifdoesntexist
Source: "Distribution\SICHERUNG_00000008.FDB"; DestDir: "{userdocs}\OrgaMon"; DestName: "OrgaMon.fdb"; Flags: onlyifdoesntexist

Source: "Distribution\OrgaMon-Daten.ini"; DestDir: "{userdocs}\OrgaMon\Daten"; DestName: "OrgaMon.ini"; Flags: onlyifdoesntexist

Source: "Distribution\OLAP\*"; DestDir: "{userdocs}\OrgaMon\Daten\OLAP"; Flags: onlyifdoesntexist
Source: "Distribution\Mahnung.Unplausibel.OLAP.txt"; DestDir: "{userdocs}\OrgaMon\Daten\OLAP"
Source: "Distribution\HTML Vorlagen\*"; DestDir: "{userdocs}\OrgaMon\Daten\HTML Vorlagen"; Flags: onlyifdoesntexist
Source: "Distribution\System\*"; DestDir: "{userdocs}\OrgaMon\Daten\System"; Flags: onlyifdoesntexist
Source: "Distribution\LeereDatenbank\*"; DestDir: "{userdocs}\OrgaMon\Daten\LeereDatenbank"; Flags: onlyifdoesntexist
Source: "Distribution\Prorata\*"; DestDir: "{userdocs}\OrgaMon\Daten\Prorata"; Flags: onlyifdoesntexist

[Icons]
Name: "{group}\OrgaMon"; Filename: "{app}\OrgaMon.exe"; 
Name: "{group}\OrgaMon-RC"; Filename: "{app}\OrgaMon-RC.exe"
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
   'kann nicht �berschrieben werden!'+ #13+#13+
   'Ursachen k�nnen sein:'+#13+
   '* Sie haben nicht ausreichende Benutzerrechte -> Fragen Sie den Administrator'+#13+
   '* OrgaMon l�uft noch -> Starten Sie den Taskmanager und beenden Sie alle OrgaMon Anwendungen.',mbError, MB_OK);
 end;
end;
