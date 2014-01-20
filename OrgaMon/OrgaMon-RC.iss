;
; -- OrgaMon-RC.iss --
;

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
AppName=OrgaMon-RC
AppVerName=OrgaMon �RevMitPunkt� RC
AppCopyright=Copyright (C) 1988-2010 Andreas Filsinger
DefaultDirName={pf}\OrgaMon
DefaultGroupName=OrgaMon
UninstallDisplayIcon={app}\OrgaMon-RC.exe
LicenseFile=Distribution\Lizenz\gpl-3.0.txt
DisableStartupPrompt=yes
DisableReadyPage=yes
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyMemo=yes
OutputDir=..\..\CargoBay
OutputBaseFilename=Setup-OrgaMon-RC
AppVersion=�RevMitPunkt� RC
Compression=lzma/max
WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP
PrivilegesRequired=none

[Files]
; Anwendung
Source: "OrgaMon.exe"; DestDir: "{app}"; DestName: "OrgaMon-RC.exe"; BeforeInstall: WaitForExit; Flags: ignoreversion restartreplace
Source: "cXMLRPC.exe"; DestDir: "{app}"; Flags: ignoreversion restartreplace
Source: "Distribution\Hilfe\OrgaMon-VNC.exe"; DestDir: "{app}"; Flags: onlyifdoesntexist

; infozip
Source: "..\infozip\zip32z64.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\infozip\unzip32.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall

; libxml2
Source: "..\libxml2\bin\iconv.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\libeay32.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\ssleay32.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\zlib1.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\libxml2.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall

[Icons]
Name: "{group}\OrgaMon-RC"; Filename: "{app}\OrgaMon-RC.exe"
Name: "{group}\Direkthilfe"; Filename: "{app}\OrgaMon-VNC.exe"

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
