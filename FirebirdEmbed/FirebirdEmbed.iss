;
; Win32 - Client für Firebird SQL Server 2.0.3
;
[Languages]
Name: "de"; MessagesFile: "compiler:languages\german.isl"

[Setup]
AppName=Firebird Database Fat Client 2.0.3.12981
AppID=FBFatClient
AppVerName=Firebird Client DLL 2.0.3.12981
AppPublisher=Firebird Project
AppPublisherURL=http://www.firebirdsql.org
AppSupportURL=http://www.firebirdsql.org
AppUpdatesURL=http://www.firebirdsql.org
DefaultDirName={pf}\Firebird
AllowNoIcons=true
OutputDir=.
OutputBaseFilename=Setup-Firebird-Embed-2.0.3.12981
DisableStartUpPrompt=true
DisableDirPage=true
DisableReadyPage=true
Compression=lzma/ultra
VersionInfoVersion=2.0.3.12981
;WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardImageFile=firebird_install_logo1.bmp
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP

[Files]
Source: .\embedded\fbembed.dll; DestDir: {sys}\; DestName: fbclient.dll; Flags: ignoreversion overwritereadonly sharedfile restartreplace;
Source: .\embedded\fbembed.dll; DestDir: {sys}\; DestName: gds32.dll; Flags:  ignoreversion overwritereadonly sharedfile restartreplace;
Source: msvcp60.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\embedded\msvcr71.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\embedded\msvcp71.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: firebird.msg; DestDir: {sys}\; Flags: overwritereadonly sharedfile restartreplace;
Source: .\embedded\ib_util.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\embedded\icudt30.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\embedded\icuin30.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\embedded\icuuc30.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall

