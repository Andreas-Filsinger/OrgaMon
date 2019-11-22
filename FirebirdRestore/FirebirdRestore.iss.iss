;
; -- FirebirdRestore.iss --
;

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
AppName=FirebirdRestore
AppVerName=FirebirdRestore 1.014
AppCopyright=Copyright (C) 2003-2013 Andreas Filsinger
DefaultDirName={pf}\FirebirdRestore
DefaultGroupName=FirebirdRestore
UninstallDisplayIcon={app}\FirebirdRestore.exe
LicenseFile=Rohstoffe\gnu-gpl-orgamon.txt
DisableStartupPrompt=yes
DisableReadyPage=yes
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyMemo=yes
OutputDir=..\..\CargoBay
OutputBaseFilename=Setup-FirebirdRestore-1014
AppVersion=1.014
ChangesAssociations=yes
Compression=lzma/max
WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP

[Registry]
Root: HKCR; Subkey: ".fbak"; ValueType: string; ValueName: ""; ValueData: "FirebirdRestore"; Flags: uninsdeletevalue
Root: HKCR; Subkey: "FirebirdRestore"; ValueType: string; ValueName: ""; ValueData: "FirebirdRestore"; Flags: uninsdeletekey
Root: HKCR; Subkey: "FirebirdRestore\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\FirebirdRestore.EXE,0"
Root: HKCR; Subkey: "FirebirdRestore\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\FirebirdRestore.EXE"" ""%1"""

[Dirs]
Name: "{app}\doc"
Name: "{app}\intl"
Name: "{app}\udf"
Name: "{userdocs}\FirebirdRestore"; Flags: uninsneveruninstall

[Files]
; Anwendung
Source: "C:\Program Files (x86)\\FirebirdRestore\FirebirdRestore.exe"; DestDir: "{app}"
Source: "FirebirdRestore.ini"; DestDir: "{userdocs}\FirebirdRestore"; Flags: onlyifdoesntexist

; Shared Object: Firebird embedded Server
Source: "..\FirebirdEmbed\Firebird-2.5.9.27139-0_Win32_embed\*"; DestDir: "{app}"; Flags: recursesubdirs
Source: "..\FirebirdEmbed\Firebird-2.5.9.27139-0_Win32_embed\fbembed.dll"; DestDir: "{app}"; DestName: gds32.dll

[Icons]
Name: "{group}\FirebirdRestore"; Filename: "{app}\FirebirdRestore.exe"
Name: "{group}\FirebirdRestore Info"; Filename: "\rev\FirebirdRestore_Info.html"

