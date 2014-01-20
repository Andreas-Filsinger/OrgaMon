;
; -- WatchDog.iss --
;

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
AppName=WatchDog
AppVerName=OrgaMon WatchDog 1.002
AppCopyright=Copyright (C) 2004, 2005 Andreas Filsinger
DefaultDirName={pf}\WatchDog
LicenseFile=..\OrgaMon\Rohstoffe\gnu-gpl-orgamon.txt
DefaultGroupName=WatchDog
UninstallDisplayIcon={app}\WatchDog.exe

DisableStartupPrompt=yes
DisableReadyPage=yes
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyMemo=yes

OutputDir=..\..\CargoBay
OutputBaseFilename=Setup-WatchDog-1002
AppVersion=1.002
Compression=lzma/max
WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP

[Files]
; Anwendung
Source: "WatchDog.exe"; DestDir: "{app}"; Flags: ignoreversion restartreplace
Source: "..\rev\WatchDog_Info.html"; DestDir: "{app}"

[Icons]
Name: "{group}\WatchDog installieren"; Filename: "{app}\WatchDog.exe /install"
Name: "{group}\WatchDog deinstallieren"; Filename: "{app}\WatchDog.exe /uninstall"
Name: "{group}\WatchDog Info"; Filename: "{app}\WatchDog_Info.html"

[Run]
Filename: "{app}\WatchDog.exe"; Description: "WatchDog jetzt als Service installieren"; Parameters: "/install"; Flags: postinstall nowait

