;
; -- Oc.iss --
;

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
AppName=Oc
AppVerName=Oc 1.296
AppCopyright=Copyright (C) 2005-2024 Andreas Filsinger
AppPublisher=OrgaMon
AppPublisherURL=https://wiki.orgamon.org/
AppSupportURL=https://cargobay.orgamon.org/Oc.html
AppUpdatesURL=https://cargobay.orgamon.org/Oc.html
DefaultDirName={autopf}\Oc
DefaultGroupName=Oc
UninstallDisplayIcon={app}\Oc.exe
LicenseFile=..\OrgaMon\Rohstoffe\gnu-gpl-orgamon.txt
DisableStartupPrompt=yes
DisableReadyPage=yes
DisableDirPage=no
DisableProgramGroupPage=yes
DisableReadyMemo=yes
OutputDir=..\..\CargoBay
OutputBaseFilename=Setup-Oc-1296
AppVersion=1296
ChangesAssociations=yes
Compression=lzma/max
WizardImageFile=compiler:WizClassicImage.bmp
WizardSmallImageFile=compiler:WizClassicSmallImage.bmp
; VersionInfoVersion=1.296
; VersionInfoCompany=OrgaMon
; VersionInfoCopyright=Copyright (C) 2005-2009 Andreas Filsinger

[Files]
; Anwendung
Source: "C:\Program Files (x86)\\Oc\Oc.exe"; DestDir: "{app}"

; libxml
Source: "..\libxml2\bin\iconv.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\zlib1.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\libxml2.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall

; openssl
Source: "..\openssl\openssl-1.0.2u-i386-win32\libeay32.dll"; DestDir: "{app}"; Flags: 32bit restartreplace uninsneveruninstall
Source: "..\openssl\openssl-1.0.2u-i386-win32\ssleay32.dll"; DestDir: "{app}"; Flags: 32bit restartreplace uninsneveruninstall

[Icons]
Name: "{group}\Oc"; Filename: "{app}\Oc.exe"
Name: "{group}\Oc Info"; Filename: "\rev\Oc_Info.html"


[Registry]
; .tab 
Root: "HKCR"; Subkey: "SystemFileAssociations\.tab\shell\tab-Konvertierung mit Oc"; ValueType: none; ValueName: ""; ValueData: ""; Flags: uninsdeletekey
Root: "HKCR"; Subkey: "SystemFileAssociations\.tab\shell\tab-Konvertierung mit Oc\command"; ValueType: string; ValueName: ""; ValueData: """{app}\Oc.exe""  ""%1"" --tab"; Flags: uninsdeletekey

; .xml 
Root: "HKCR"; Subkey: "SystemFileAssociations\.xml\shell\xml-Konvertierung mit Oc"; ValueType: none; ValueName: ""; ValueData: ""; Flags: uninsdeletekey
Root: "HKCR"; Subkey: "SystemFileAssociations\.xml\shell\xml-Konvertierung mit Oc\command"; ValueType: string; ValueName: ""; ValueData: """{app}\Oc.exe""  ""%1"" --xml"; Flags: uninsdeletekey
Root: "HKCR"; Subkey: "SystemFileAssociations\.xml\shell\xml-Validierung mit Oc"; ValueType: none; ValueName: ""; ValueData: ""; Flags: uninsdeletekey
Root: "HKCR"; Subkey: "SystemFileAssociations\.xml\shell\xml-Validierung mit Oc\command"; ValueType: string; ValueName: ""; ValueData: """{app}\Oc.exe""  ""%1"" --val"; Flags: uninsdeletekey

; .xls
Root: "HKCR"; Subkey: "SystemFileAssociations\.xls\shell\xls-Konvertierung mit Oc"; ValueType: none; ValueName: ""; ValueData: ""; Flags: uninsdeletekey
Root: "HKCR"; Subkey: "SystemFileAssociations\.xls\shell\xls-Konvertierung mit Oc\command"; ValueType: string; ValueName: ""; ValueData: """{app}\Oc.exe""  ""%1"" --xls"; Flags: uninsdeletekey
Root: "HKCR"; Subkey: "SystemFileAssociations\.xls\shell\xls-html mit Oc"; ValueType: none; ValueName: ""; ValueData: ""; Flags: uninsdeletekey
Root: "HKCR"; Subkey: "SystemFileAssociations\.xls\shell\xls-html mit Oc\command"; ValueType: string; ValueName: ""; ValueData: """{app}\Oc.exe""  ""%1"" --html"; Flags: uninsdeletekey
