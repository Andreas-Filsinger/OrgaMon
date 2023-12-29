; -- polyzalos.iss --
;

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
PrivilegesRequired=Admin
AppName=polyzalosd
AppVerName=polyzalosd «RevMitPunkt»
AppCopyright=Copyright (C) 1988-2023 Andreas Filsinger
DefaultDirName={pf64}\polyzalos
DefaultGroupName=polyzalos
UninstallDisplayIcon={app}\polyzalosd.exe
LicenseFile=..\..\OrgaMon\Distribution\Lizenz\gpl-3.0.txt
DisableStartupPrompt=yes
DisableReadyPage=yes
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyMemo=yes
OutputDir=..\..\..\CargoBay
OutputBaseFilename=Setup-polyzalosd-«RevOhnePunkt»
AppVersion=«RevMitPunkt»
VersionInfoVersion=«RevMitPunkt».0.0
Compression=lzma/max
WizardImageFile=compiler:WizClassicImage.bmp
WizardSmallImageFile=compiler:WizClassicSmallImage.bmp

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

; Anwendung
Source: "polyzalosd.exe"; DestDir: "{app}"; BeforeInstall: WaitForExit; Flags: ignoreversion restartreplace

; OpenSSL
Source: "R:\INSTALL\openSSL\VC_redist.x64.exe"; DestDir: "{app}"; BeforeInstall: WaitForExit; Flags: ignoreversion restartreplace
Source: "R:\INSTALL\openSSL\Win64OpenSSL_Light-3_2_0.exe"; DestDir: "{app}"; BeforeInstall: WaitForExit; Flags: ignoreversion restartreplace

Source: "..\..\OrgaMon\Distribution\Lizenz\gpl-3.0.txt"; DestDir: "{app}"; DestName: "Lizenz.txt"; Flags: onlyifdoesntexist
Source: "..\..\OrgaMon\Distribution\OLAP\*"; DestDir: "{userdocs}\polyzalosd\Daten\OLAP"; Flags: onlyifdoesntexist
Source: "..\..\OrgaMon\Distribution\Mahnung.Unplausibel.OLAP.txt"; DestDir: "{userdocs}\polyzalosd\Daten\OLAP"
Source: "..\..\OrgaMon\Distribution\HTML Vorlagen\*"; DestDir: "{userdocs}\polyzalosd\Daten\HTML Vorlagen"; Flags: onlyifdoesntexist
Source: "..\..\OrgaMon\Distribution\System\*"; DestDir: "{userdocs}\polyzalosd\Daten\System"; Flags: onlyifdoesntexist
Source: "..\..\OrgaMon\Distribution\LeereDatenbank\*"; DestDir: "{userdocs}\polyzalosd\Daten\LeereDatenbank"; Flags: onlyifdoesntexist
Source: "..\..\OrgaMon\Distribution\Prorata\*"; DestDir: "{userdocs}\polyzalosd\Daten\Prorata"; Flags: onlyifdoesntexist

[Icons]
Name: "{group}\polyzalosd"; Filename: "{app}\polyzalosd.exe"

[Run]
Filename: "{app}\polyzalosd.exe"; Description: "Starte polyzalosd"; Parameters: "{param:PostExec}"; Flags: postinstall nowait

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
   '* polyzalosd läuft noch -> Starten Sie den Taskmanager und beenden Sie alle polyzalosd Anwendungen.',mbError, MB_OK);
 end;
end;
