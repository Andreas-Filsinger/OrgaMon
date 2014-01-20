;
; Win32 - Client für Firebird SQL Server 2.5.2.26415
;
[Languages]
Name: "de"; MessagesFile: "compiler:languages\german.isl"

[Setup]
AppName=Firebird Database Client 2.5.2.26415
AppID=FBDBClient
AppVerName=Firebird Client DLL 2.5.2.26415
AppPublisher=Firebird Project
AppPublisherURL=http://www.firebirdsql.org
AppSupportURL=http://www.firebirdsql.org
AppUpdatesURL=http://www.firebirdsql.org
DefaultDirName={pf}\Firebird
AllowNoIcons=true
OutputDir=.
OutputBaseFilename=Setup-Firebird-Client-2.5.2.26415
DisableStartUpPrompt=true
DisableDirPage=true
DisableReadyPage=true
Compression=lzma/max
VersionInfoVersion=2.5.2.26415
;WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardImageFile=firebird_install_logo1.bmp
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP

[Files]
Source: .\Firebird-2.5.2.26415-0_Win32\bin\fbclient.dll; DestDir: {sys}\; Flags: overwritereadonly sharedfile restartreplace;
Source: .\Firebird-2.5.2.26415-0_Win32\bin\fbclient.dll; DestDir: {sys}\; DestName: gds32.dll; Flags: overwritereadonly sharedfile restartreplace;
Source: .\Firebird-2.5.2.26415-0_Win32\firebird.msg; DestDir: {sys}\; Flags: overwritereadonly sharedfile restartreplace;
Source: .\Firebird-2.5.2.26415-0_Win32\system32\vccrt8_Win32.msi; DestDir: "{tmp}"

[Run]
Filename: "msiexec.exe"; Parameters: "/i ""{tmp}\vccrt8_Win32.msi"""
