;
; Win32 - Client für Firebird SQL Server
;
[Languages]
Name: "de"; MessagesFile: "compiler:languages\german.isl"

[Setup]
AppName=Firebird Database Client 3.0.12.33787
AppID=FBDBClient
AppVerName=Firebird Client DLL 3.0.12.33787
AppPublisher=Firebird Project
AppPublisherURL=http://www.firebirdsql.org
AppSupportURL=http://www.firebirdsql.org
AppUpdatesURL=http://www.firebirdsql.org
;DefaultDirName={pf}\Firebird
DefaultDirName={pf}\OrgaMon
AllowNoIcons=true
OutputDir=..\..\CargoBay
OutputBaseFilename=Setup-Firebird-Client-3.0.12.33787
DisableStartUpPrompt=true
DisableDirPage=true
DisableReadyPage=true
Compression=lzma/max
VersionInfoVersion=3.0.12.33787
WizardImageFile=firebird_install_logo1.bmp
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP

[Files]
Source: ./Firebird-3.0.12.33787-0_Win32/fbclient.dll; DestDir: {app}\; Flags: overwritereadonly sharedfile restartreplace;
Source: ./Firebird-3.0.12.33787-0_Win32/fbclient.dll; DestDir: {app}\; DestName: gds32.dll; Flags: overwritereadonly sharedfile restartreplace;
Source: ./Firebird-3.0.12.33787-0_Win32/firebird.msg; DestDir: {app}\; Flags: overwritereadonly sharedfile restartreplace;

Source: ./Firebird-3.0.12.33787-0_Win32/vccrt10_Win32.msi; DestDir: "{tmp}"

[Run]
Filename: "msiexec.exe"; Parameters: "/i ""{tmp}\vccrt10_Win32.msi"""
