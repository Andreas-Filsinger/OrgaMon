;
; Win32 - Client für Firebird SQL Server
;
[Languages]
Name: "de"; MessagesFile: "compiler:languages\german.isl"

[Setup]
AppName=Firebird Database Client 3.0.7.33374
AppID=FBDBClient
AppVerName=Firebird Client DLL 3.0.7.33374
AppPublisher=Firebird Project
AppPublisherURL=http://www.firebirdsql.org
AppSupportURL=http://www.firebirdsql.org
AppUpdatesURL=http://www.firebirdsql.org
DefaultDirName={pf}\Firebird
AllowNoIcons=true
OutputDir=..\..\CargoBay
OutputBaseFilename=Setup-Firebird-Client-3.0.7.33374
DisableStartUpPrompt=true
DisableDirPage=true
DisableReadyPage=true
Compression=lzma/max
VersionInfoVersion=3.0.7.33374
WizardImageFile=firebird_install_logo1.bmp
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP

[Files]
Source: ./Firebird-3.0.7.33374-1_Win32/fbclient.dll; DestDir: {sys}\; Flags: overwritereadonly sharedfile restartreplace;
Source: ./Firebird-3.0.7.33374-1_Win32/fbclient.dll; DestDir: {sys}\; DestName: gds32.dll; Flags: overwritereadonly sharedfile restartreplace;
Source: ./Firebird-3.0.7.33374-1_Win32/firebird.msg; DestDir: {sys}\; Flags: overwritereadonly sharedfile restartreplace;
;Source: ./Firebird-3.0.7.33374-1_Win32/vccrt8_Win32.msi; DestDir: "{tmp}"

[Run]
Filename: "msiexec.exe"; Parameters: "/i ""{tmp}\vccrt8_Win32.msi"""
