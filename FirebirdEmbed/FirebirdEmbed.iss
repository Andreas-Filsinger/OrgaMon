;
; Win32 - Client für Firebird SQL Server 2.0.3
;
[Languages]
Name: "de"; MessagesFile: "compiler:languages\german.isl"

[Setup]
AppName=Firebird Database Fat Client 2.5.9.27139
AppID=FBFatClient
AppVerName=Firebird Client DLL 2.5.9.27139
AppPublisher=Firebird Project
AppPublisherURL=http://www.firebirdsql.org
AppSupportURL=http://www.firebirdsql.org
AppUpdatesURL=http://www.firebirdsql.org
DefaultDirName={pf}\Firebird
AllowNoIcons=true
OutputDir=.
OutputBaseFilename=Setup-Firebird-Embed-2.5.9.27139
DisableStartUpPrompt=true
DisableDirPage=true
DisableReadyPage=true
Compression=lzma/ultra
VersionInfoVersion=2.5.9.27139
WizardImageFile=firebird_install_logo1.bmp
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP

[Files]
Source: .\Firebird-2.5.9.27139-0_Win32_embed\fbembed.dll; DestDir: {sys}\; DestName: fbclient.dll; Flags: ignoreversion overwritereadonly sharedfile restartreplace;
Source: .\Firebird-2.5.9.27139-0_Win32_embed\fbembed.dll; DestDir: {sys}\; DestName: gds32.dll; Flags:  ignoreversion overwritereadonly sharedfile restartreplace;
Source: .\Firebird-2.5.9.27139-0_Win32_embed\msvcr80.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\Firebird-2.5.9.27139-0_Win32_embed\msvcp80.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\Firebird-2.5.9.27139-0_Win32_embed\firebird.msg; DestDir: {sys}\; Flags: overwritereadonly sharedfile restartreplace;
Source: .\Firebird-2.5.9.27139-0_Win32_embed\ib_util.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\Firebird-2.5.9.27139-0_Win32_embed\icudt30.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\Firebird-2.5.9.27139-0_Win32_embed\icuin30.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall
Source: .\Firebird-2.5.9.27139-0_Win32_embed\icuuc30.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall

