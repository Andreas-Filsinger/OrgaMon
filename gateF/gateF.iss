;
; -- gateF.iss --
;

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
AppName=gateF
AppVerName=gateF «RevMitPunkt»
AppCopyright=Copyright (C) 1999-2006 Andreas Filsinger
DefaultDirName={pf}\gateF
DefaultGroupName=gateF
UninstallDisplayIcon={app}\gateF.exe
DisableStartupPrompt=yes
DisableReadyMemo=yes
OutputDir=G:\CargoBay
OutputBaseFilename=Setup-gateF-«RevOhnePunkt»
AppVersion=«RevMitPunkt»

[Files]
; Anwendung gateF
Source: "gateF.exe"; DestDir: "{app}"
Source: "\rev\gateF_Info.html"; DestDir: "{app}"

; System gateF
Source: "system\*"; DestDir: "{app}\system"

; Konfiguration gateF
Source: "Distribution\gateF.ini"; DestDir: "{app}"; CopyMode: onlyifdoesntexist

; Anwendung PforteAssist
Source: "\delphi\itsiemens3\PforteAssist.exe"; DestDir: "{app}\PforteAssist"
Source: "\rev\PforteAssist_Info.html"; DestDir: "{app}\PforteAssist"

; System PforteAssist
Source: "\delphi\itsiemens3\PforteAssist.ini"; DestDir: "{app}\PforteAssist"
Source: "\delphi\itsiemens3\Keyboard Layouts.ini"; DestDir: "{app}\PforteAssist"
Source: "\delphi\itsiemens3\itsiemens3.itp"; DestDir: "{app}\PforteAssist"
Source: "\delphi\itsiemens3\Besucher Hinweise ??.txt"; DestDir: "{app}\PforteAssist"
Source: "\delphi\itsiemens3\Installations Hinweise.txt"; DestDir: "{app}\PforteAssist"
Source: "\delphi\itsiemens3\main.bmp"; DestDir: "{app}\PforteAssist"

[Icons]
Name: "{group}\gateF"; Filename: "{app}\gateF.exe"
Name: "{group}\Theken Unterschreib Terminal"; Filename: "{app}\PforteAssist\PforteAssist.exe"

