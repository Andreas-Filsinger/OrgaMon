;
; -- OrgaMon-RC.iss --
;

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
AppName=OrgaMon-RC
AppVerName=OrgaMon 8.763 RC
AppCopyright=Copyright (C) 1988-2022 Andreas Filsinger
DefaultDirName={pf}\OrgaMon
DefaultGroupName=OrgaMon
UninstallDisplayIcon={app}\OrgaMon-RC.exe
DisableStartupPrompt=yes
DisableReadyPage=yes
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyMemo=yes
DisableFinishedPage=yes
OutputDir=..\..\CargoBay
OutputBaseFilename=Setup-OrgaMon-RC
AppVersion=8.763 RC
VersionInfoVersion=8.763.0.0
Compression=lzma/max
WizardImageFile=compiler:WizModernImage.bmp
WizardSmallImageFile=compiler:WizModernSmallImage.bmp
PrivilegesRequired=none

[Files]
; Anwendung
Source: "C:\Program Files (x86)\\OrgaMon\OrgaMon.exe"; DestDir: "{app}"; DestName: "OrgaMon-RC.exe"; BeforeInstall: WaitForExit; Flags: ignoreversion restartreplace


; neue DLL
Source: "..\TGPuttyLib\tgputtylib.dll"; DestDir: "{app}"; Flags: 32bit restartreplace uninsneveruninstall

; Lizenz-Infos
Source: "..\..\CargoBay\OrgaMon_Info.html"; DestDir: "{app}"
Source: "Distribution\Lizenz\gpl-3.0.txt"; DestDir: "{app}"; DestName: "Lizenz.txt"; Flags: onlyifdoesntexist

[Icons]
Name: "{group}\OrgaMon-RC"; Filename: "{app}\OrgaMon-RC.exe"
Name: "{group}\OrgaMon Info"; Filename: "{app}\OrgaMon_Info.html"

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
