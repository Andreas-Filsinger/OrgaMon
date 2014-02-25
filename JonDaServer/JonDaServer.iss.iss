; -- JondaServer.iss --
;

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
AppName=JonDaServer
AppVerName=JonDaServer 2.204
AppCopyright=Copyright (C) 2009-2012 Andreas Filsinger
DefaultDirName={pf}\JonDaServer
DefaultGroupName=JonDaServer
UninstallDisplayIcon={app}\JonDaServer.exe
DisableStartupPrompt=yes
DisableDirPage=yes
DisableReadyMemo=yes
OutputDir=..\..\CargoBay
OutputBaseFilename=Setup-JonDaServer-2204
AppVersion=2.204
Compression=lzma/max
WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP
PrivilegesRequired=none

[Files]
; Anwendung
Source: "C:\Program Files\\JonDaServer\JonDaServer.exe"; DestDir: "{app}"
Source: "C:\Program Files\\JonDaServer\cJonDaServer.exe"; DestDir: "{app}"

; infozip
Source: "..\infozip\zip32z64.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\infozip\unzip32.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\infozip\unzip.exe"; DestDir: "{app}"; Flags: onlyifdoesntexist uninsneveruninstall
Source: "..\infozip\unzip.txt"; DestDir: "{app}"; Flags: onlyifdoesntexist uninsneveruninstall

; php-Scripte
Source: "t_errorlist.inc.php5"; DestDir: "{app}\htdocs"; Flags: IgnoreVersion
Source: "t_xmlrpc.inc.php5"; DestDir: "{app}\htdocs"; Flags: IgnoreVersion
Source: "up.php"; DestDir: "{app}\htdocs"; Flags: IgnoreVersion

[Icons]
Name: "{group}\JonDaServer"; Filename: "{app}\JonDaServer.exe"
Name: "{group}\JonDaServer-Konsole"; Filename: "{app}\cJonDaServer.exe"

