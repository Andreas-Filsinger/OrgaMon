;
; -- OrgaMon-update.iss --
;

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
AppName=OrgaMon
AppVerName=OrgaMon 8.103
AppCopyright=Copyright (C) 1988-2011 Andreas Filsinger
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
OutputBaseFilename=Setup-OrgaMon-8103-Update
AppVersion=8.103
VersionInfoVersion=8.103.0.0
Compression=lzma/max
WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP
PrivilegesRequired=none

[Files]
; Anwendung
Source: "C:\Program Files\\OrgaMon\OrgaMon.exe"; DestDir: "{app}"; DestName: "OrgaMon.exe"; BeforeInstall: WaitForExit; Flags: ignoreversion restartreplace
Source: "C:\Program Files\\OrgaMon\cOrgaMon.exe"; DestDir: "{app}"; Flags: ignoreversion restartreplace
Source: "Distribution\Hilfe\OrgaMon-VNC.exe"; DestDir: "{app}"; Flags: ignoreversion restartreplace

; Lizenz-Infos
Source: "..\..\CargoBay\OrgaMon_Info.html"; DestDir: "{app}"
Source: "Distribution\Lizenz\gpl-3.0.txt"; DestDir: "{app}"; DestName: "Lizenz.txt"; Flags: onlyifdoesntexist

; infozip
Source: "..\infozip\zip32z64.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\infozip\unzip32.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\infozip\unzip.exe"; DestDir: "{app}"; Flags: onlyifdoesntexist uninsneveruninstall
Source: "..\infozip\unzip.txt"; DestDir: "{app}"; Flags: onlyifdoesntexist uninsneveruninstall

; libxml2
Source: "..\libxml2\bin\iconv.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\libeay32.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\ssleay32.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\zlib1.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\libxml2.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall

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
