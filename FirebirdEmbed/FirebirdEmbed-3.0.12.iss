;
; Win32 - Client für Firebird SQL Server 3.0.12
;
[Languages]
Name: "de"; MessagesFile: "compiler:languages\german.isl"

[Setup]
AppName=Firebird Database Fat Client 3.0.12.
AppID=FBFatClient
AppVerName=Firebird Client DLL 3.0.12.33787
AppPublisher=Firebird Project
AppPublisherURL=http://www.firebirdsql.org
AppSupportURL=http://www.firebirdsql.org
AppUpdatesURL=http://www.firebirdsql.org
DefaultDirName={pf}\Firebird
AllowNoIcons=true
OutputDir=..\..\CargoBay
OutputBaseFilename=Setup-Firebird-Embed-3.0.12.33787
DisableStartUpPrompt=true
DisableDirPage=true
DisableReadyPage=true
Compression=lzma/ultra
VersionInfoVersion=3.0.12.33787
;WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardImageFile=firebird_install_logo1.bmp
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP

[Files]
Source: .\Firebird-3.0.12.33787-0_Win32_embed\fbclient.dll; DestDir: {sys}\; DestName: fbclient.dll; Flags: ignoreversion overwritereadonly sharedfile restartreplace;
Source: .\Firebird-3.0.12.33787-0_Win32_embed\fbclient.dll; DestDir: {sys}\; DestName: gds32.dll; Flags:  ignoreversion overwritereadonly sharedfile restartreplace;

Source: .\Firebird-3.0.12.33787-0_Win32_embed\databases.conf; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\Firebird-3.0.12.33787-0_Win32_embed\firebird.conf; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\Firebird-3.0.12.33787-0_Win32_embed\gbak.exe; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\Firebird-3.0.12.33787-0_Win32_embed\gfix.exe; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\Firebird-3.0.12.33787-0_Win32_embed\icudt52l.dat; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\Firebird-3.0.12.33787-0_Win32_embed\IDPLicense.txt; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\Firebird-3.0.12.33787-0_Win32_embed\IPLicense.txt; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\Firebird-3.0.12.33787-0_Win32_embed\zlib1.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall

Source: .\Firebird-3.0.12.33787-0_Win32_embed\msvcr100.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\Firebird-3.0.12.33787-0_Win32_embed\msvcp100.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\Firebird-3.0.12.33787-0_Win32_embed\firebird.msg; DestDir: {sys}\; Flags: overwritereadonly sharedfile restartreplace;
Source: .\Firebird-3.0.12.33787-0_Win32_embed\ib_util.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\Firebird-3.0.12.33787-0_Win32_embed\icudt52.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\Firebird-3.0.12.33787-0_Win32_embed\icuin52.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\Firebird-3.0.12.33787-0_Win32_embed\icuuc52.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall

Source: ".\Firebird-3.0.12.33787-0_Win32_embed\intl\*"; DestDir: "{app}\intl"; Flags: recursesubdirs
Source: ".\Firebird-3.0.12.33787-0_Win32_embed\plugins\*"; DestDir: "{app}\plugins"; Flags: recursesubdirs
