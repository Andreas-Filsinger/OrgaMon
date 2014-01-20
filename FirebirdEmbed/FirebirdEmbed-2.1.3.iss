;
; Win32 - Client für Firebird SQL Server 2.1.3
;
[Languages]
Name: "de"; MessagesFile: "compiler:languages\german.isl"

[Setup]
AppName=Firebird Database Fat Client 2.1.3
AppID=FBFatClient
AppVerName=Firebird Client DLL 2.1.3
AppPublisher=Firebird Project
AppPublisherURL=http://www.firebirdsql.org
AppSupportURL=http://www.firebirdsql.org
AppUpdatesURL=http://www.firebirdsql.org
DefaultDirName={pf}\OrgaMon
AllowNoIcons=true
OutputDir=../../CargoBay
OutputBaseFilename=Setup-Firebird-Embed-2.1.3
DisableStartUpPrompt=true
;DisableDirPage=true
DisableReadyPage=true
Compression=lzma/ultra
VersionInfoVersion=2.1.3
;WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardImageFile=firebird_install_logo1.bmp
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP

[Files]
Source: .\Firebird-2.1.3.18185-0_Win32_embed\*; DestDir: {app}; Flags: recursesubdirs onlyifdoesntexist uninsneveruninstall
Source: .\Firebird-2.1.3.18185-0_Win32_embed\fbembed.dll; DestDir: {app}; DestName: gds32.dll; Flags: onlyifdoesntexist uninsneveruninstall

