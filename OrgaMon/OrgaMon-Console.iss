;
; cOrgaMon unattended Install on Wine-Systems
;
[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
AllowCancelDuringInstall=no
SetupLogging=yes
AppName=OrgaMon
AppVerName=OrgaMon «RevMitPunkt»
AppVersion=«RevMitPunkt»
VersionInfoVersion=«RevMitPunkt».0.0
AppCopyright=Copyright (C) 1988-2019 Andreas Filsinger
DefaultDirName={pf}\OrgaMon
DefaultGroupName=OrgaMon
UninstallDisplayIcon={app}\OrgaMon.exe
DisableStartupPrompt=yes
DisableReadyPage=yes
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyMemo=yes
DisableFinishedPage=yes
OutputDir=..\..\CargoBay
OutputBaseFilename=Setup-cOrgaMon-«RevOhnePunkt»
Compression=lzma/max
PrivilegesRequired=none


[Files]
;
; (Fat) Database Client
;
Source: ..\FirebirdEmbed\Firebird-2.5.9.27139-0_Win32_embed\fbembed.dll; DestDir: {app}; DestName: fbclient.dll; Flags: 32bit ignoreversion overwritereadonly sharedfile restartreplace
Source: ..\FirebirdEmbed\Firebird-2.5.9.27139-0_Win32_embed\fbembed.dll; DestDir: {app}; DestName: gds32.dll; Flags: 32bit ignoreversion overwritereadonly sharedfile restartreplace
Source: ..\FirebirdEmbed\Firebird-2.5.9.27139-0_Win32_embed\msvcr80.dll; DestDir: {app}; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: ..\FirebirdEmbed\Firebird-2.5.9.27139-0_Win32_embed\msvcp80.dll; DestDir: {app}; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: ..\FirebirdEmbed\Firebird-2.5.9.27139-0_Win32_embed\ib_util.dll; DestDir: {app}; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: ..\FirebirdEmbed\Firebird-2.5.9.27139-0_Win32_embed\icudt30.dll; DestDir: {app}; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: ..\FirebirdEmbed\Firebird-2.5.9.27139-0_Win32_embed\icuin30.dll; DestDir: {app}; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: ..\FirebirdEmbed\Firebird-2.5.9.27139-0_Win32_embed\icuuc30.dll; DestDir: {app}; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: ..\FirebirdEmbed\Firebird-2.5.9.27139-0_Win32_embed\firebird.msg; DestDir: {app}; Flags: onlyifdoesntexist uninsneveruninstall

; Anwendung
Source: "«ProgramFiles»\OrgaMon\cOrgaMon.exe"; DestDir: "{app}"; Flags: ignoreversion restartreplace

; Lizenz-Infos
Source: "..\..\CargoBay\OrgaMon_Info.html"; DestDir: "{app}"
Source: "Distribution\Lizenz\gpl-3.0.txt"; DestDir: "{app}"; DestName: "Lizenz.txt"; Flags: onlyifdoesntexist

; openssl
Source: "..\openssl\openssl-1.0.2o-i386-win32\libeay32.dll"; DestDir: "{app}"; Flags: 32bit uninsneveruninstall
Source: "..\openssl\openssl-1.0.2o-i386-win32\ssleay32.dll"; DestDir: "{app}"; Flags: 32bit uninsneveruninstall

; libxml2
Source: "..\libxml2\bin\iconv.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\zlib1.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\libxml2.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall

; neue und aktualisierte notwendige Files
Source: "Distribution\HTML Vorlagen\COR1.xml"; DestDir: "{userdocs}\OrgaMon\Daten\HTML Vorlagen"; Flags: onlyifdoesntexist
Source: "Distribution\HTML Vorlagen\+*"; DestDir: "{userdocs}\OrgaMon\Daten\HTML Vorlagen"; Flags: onlyifdoesntexist
Source: "Distribution\System\BLZ_*"; DestDir: "{userdocs}\OrgaMon\Daten\System"; Flags: onlyifdoesntexist

