;
; -- OrgaMonAppService-update.iss --
;

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
AppName=OrgaMonAppService
AppVerName=OrgaMonAppService «RevMitPunkt»
AppCopyright=Copyright (C) 1988-2013 Andreas Filsinger
DefaultDirName={pf}\OrgaMon
DefaultGroupName=OrgaMon
UninstallDisplayIcon={app}\OrgaMonAppService.exe
LicenseFile=..\OrgaMon\Distribution\Lizenz\gpl-3.0.txt
DisableStartupPrompt=yes
DisableReadyPage=yes
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyMemo=yes
OutputDir=..\..\CargoBay
OutputBaseFilename=Setup-OrgaMonAppService-«RevOhnePunkt»
AppVersion=«RevMitPunkt»
Compression=lzma/max
WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP
PrivilegesRequired=none

[Files]
; Anwendung
Source: "«ProgramFiles»\OrgaMon\OrgaMonAppService.exe"; DestDir: "{app}"; DestName: "OrgaMonAppService.exe"; Flags: ignoreversion restartreplace

; Lizenz-Infos
Source: "..\OrgaMon\Distribution\Lizenz\gpl-3.0.txt"; DestDir: "{app}"; DestName: "Lizenz.txt"; Flags: onlyifdoesntexist

; infozip
Source: "..\infozip\zip32z64.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\infozip\unzip32.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\infozip\unzip.exe"; DestDir: "{app}"; Flags: onlyifdoesntexist uninsneveruninstall
Source: "..\infozip\unzip.txt"; DestDir: "{app}"; Flags: onlyifdoesntexist uninsneveruninstall

; libxml2
;Source: "..\libxml2\bin\iconv.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
;Source: "..\libxml2\bin\libeay32.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
;Source: "..\libxml2\bin\ssleay32.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
;Source: "..\libxml2\bin\zlib1.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
;Source: "..\libxml2\bin\libxml2.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall

; libxml2 aus Postgres QL
Source: "..\postgresQL\libiconv-2.dll"; DestDir: "{app}"; Flags: 32bit ignoreversion restartreplace uninsneveruninstall
Source: "..\postgresQL\libeay32.dll"; DestDir: "{app}"; Flags: 32bit ignoreversion restartreplace uninsneveruninstall
Source: "..\postgresQL\ssleay32.dll"; DestDir: "{app}"; Flags: 32bit ignoreversion restartreplace uninsneveruninstall
Source: "..\postgresQL\libxml2.dll"; DestDir: "{app}"; Flags: 32bit ignoreversion restartreplace uninsneveruninstall
Source: "..\postgresQL\zlib1.dll"; DestDir: "{app}"; Flags: 32bit ignoreversion restartreplace uninsneveruninstall

; Postgres QL
Source: "..\postgresQL\libpq.dll"; DestDir: "{app}"; Flags: 32bit ignoreversion restartreplace uninsneveruninstall
Source: "..\postgresQL\libintl-8.dll"; DestDir: "{app}"; Flags: 32bit ignoreversion restartreplace uninsneveruninstall

[Icons]
Name: "{group}\OrgaMonAppService"; Filename: "{app}\OrgaMonAppService.exe"

; [Run]
; Filename: "{app}\OrgaMonAppService.exe"; Description: "Starte OrgaMon-App-Service"; Parameters: "{param:PostExec}"; Flags: postinstall nowait

