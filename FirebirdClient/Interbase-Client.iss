;
; Win32 - Client für Interbase SQL Server 8.0.0.132
;
[Languages]
Name: "de"; MessagesFile: "compiler:languages\german.isl"

[Setup]
AppName=Interbase Database Client 8.0.0.132
AppID=IBDBClient
AppVerName=Interbase Client DLL 8.0.0.132
AppPublisher=CODEGEAR from Borland
AppPublisherURL=http://www.codegear.com
AppSupportURL=http://www.codegear.com
AppUpdatesURL=http://www.codegear.com
DefaultDirName={pf}\Interbase
AllowNoIcons=true
OutputDir=.
OutputBaseFilename=Setup-Interbase-Client-8.0.0.132
DisableStartUpPrompt=true
DisableDirPage=true
DisableReadyPage=true
Compression=lzma/max
VersionInfoVersion=8.0.0.132
WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP

[Files]
Source: gds32.codegear.8.0.0.132\gds32.dll; DestDir: {sys}\; DestName: gds32.dll; Flags: overwritereadonly sharedfile restartreplace;
Source: msvcp60.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall;
Source: msvcr71.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall;
Source: msvcp71.dll; DestDir: {sys}\; Flags: onlyifdoesntexist uninsneveruninstall;

Source: fbclient.dll; DestDir: {sys}\; Flags: overwritereadonly sharedfile restartreplace;
Source: firebird.msg; DestDir: {sys}\; Flags: overwritereadonly sharedfile restartreplace;


