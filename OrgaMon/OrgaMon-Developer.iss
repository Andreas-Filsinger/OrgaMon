;
; -- OrgaMon-update.iss --
;

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
AppName=OrgaMon-Dev
AppVerName=OrgaMon Developer
AppCopyright=Copyright (C) 1988-2010 Andreas Filsinger
DefaultDirName={pf}\OrgaMon-Dev
DefaultGroupName=OrgaMon-Dev
LicenseFile=Distribution\Lizenz\gpl-3.0.txt
DisableStartupPrompt=yes
DisableReadyPage=yes
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyMemo=yes
OutputDir=..\..\CargoBay
OutputBaseFilename=Setup-OrgaMon-Dev
AppVersion=1.000
Compression=lzma/max
WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP
PrivilegesRequired=none

[Files]

; infozip
Source: "..\infozip\zip32z64.dll"; DestDir: "{sys}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\infozip\unzip32.dll"; DestDir: "{sys}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall

; libxml2
Source: "..\libxml2\bin\iconv.dll"; DestDir: "{sys}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\libeay32.dll"; DestDir: "{sys}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\ssleay32.dll"; DestDir: "{sys}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\zlib1.dll"; DestDir: "{sys}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\libxml2.dll"; DestDir: "{sys}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall

