;
; Win32 - Client für Firebird SQL Server 2.5.2.26415 nur im OrgaMon Verzeichnis!
;
[Languages]
Name: "de"; MessagesFile: "compiler:languages\german.isl"

[Setup]
AppName=Firebird Database Client 2.5.2.26415
AppID=FBDBClientOrgaMon
AppVerName=Firebird Client DLL 2.5.2.26415
AppPublisher=Firebird Project
AppPublisherURL=http://www.firebirdsql.org
AppSupportURL=http://www.firebirdsql.org
AppUpdatesURL=http://www.firebirdsql.org
DefaultDirName={pf}\OrgaMon
AllowNoIcons=true
OutputDir=.
OutputBaseFilename=Setup-Firebird-Client-OrgaMon-2.5.2.26415
DisableStartUpPrompt=true
DisableDirPage=true
DisableReadyPage=true
Compression=lzma/max
VersionInfoVersion=2.5.2.26415
;WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardImageFile=firebird_install_logo1.bmp
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP

[Files]
Source: .\Firebird-2.5.2.26415-0_Win32\bin\fbclient.dll; DestDir: {app}; DestName: gds32.dll; Flags: overwritereadonly sharedfile restartreplace;
Source: .\Firebird-2.5.2.26415-0_Win32\firebird.msg; DestDir: {app}; Flags: overwritereadonly sharedfile restartreplace;

Source: .\Firebird-2.5.2.26415-0_Win32\bin\msvcr80.dll; DestDir: {app}; Flags: overwritereadonly sharedfile restartreplace;
Source: .\Firebird-2.5.2.26415-0_Win32\bin\msvcp80.dll; DestDir: {app}; Flags: overwritereadonly sharedfile restartreplace;
Source: .\Firebird-2.5.2.26415-0_Win32\bin\Microsoft.VC80.CRT.manifest; DestDir: {app}; Flags: overwritereadonly sharedfile restartreplace;


