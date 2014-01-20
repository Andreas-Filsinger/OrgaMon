;
; Win32 - Client für Firebird SQL Server 2.1.2.18118
;
[Languages]
Name: "de"; MessagesFile: "compiler:languages\german.isl"

[Setup]
AppName=Firebird Database Client 2.1.2.18118
AppID=FBDBClient
AppVerName=Firebird Client DLL 2.1.2.18118
AppPublisher=Firebird Project
AppPublisherURL=http://www.firebirdsql.org
AppSupportURL=http://www.firebirdsql.org
AppUpdatesURL=http://www.firebirdsql.org
DefaultDirName={pf}\Firebird
AllowNoIcons=true
OutputDir=.
OutputBaseFilename=Setup-Firebird-Client-2.1.2.18118
DisableStartUpPrompt=true
DisableDirPage=true
DisableReadyPage=true
Compression=lzma/max
VersionInfoVersion=2.1.2.18118
;WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardImageFile=firebird_install_logo1.bmp
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP

[Files]
Source: fbclient.dll; DestDir: {sys}\; Flags: overwritereadonly sharedfile restartreplace;
Source: fbclient.dll; DestDir: {sys}\; DestName: gds32.dll; Flags: overwritereadonly sharedfile restartreplace;
Source: firebird.msg; DestDir: {sys}\; Flags: overwritereadonly sharedfile restartreplace;
Source: "vccrt8_Win32.msi"; DestDir: "{tmp}"

[Run]
Filename: "msiexec.exe"; Parameters: "/i ""{tmp}\vccrt8_Win32.msi"""
