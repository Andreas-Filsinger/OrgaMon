; -- OrgaMon-Data.iss --
;

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
PrivilegesRequired=Admin
AppName=OrgaMon
AppVerName=OrgaMon-Daten
AppCopyright=Copyright (C) 1988-2013 Andreas Filsinger
DefaultGroupName=OrgaMon
LicenseFile=Distribution\Lizenz\gpl-3.0.txt
DisableStartupPrompt=yes
DisableReadyPage=yes
DisableProgramGroupPage=yes
DisableReadyMemo=yes
OutputDir=..\..\CargoBay
OutputBaseFilename=Setup-OrgaMon-Data
Compression=lzma/max
WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP
DefaultDirName={userdocs}\OrgaMon

[Dirs]
Name: "{app}\OLAP"; Flags: uninsneveruninstall
Name: "{app}\HTML Vorlagen"; Flags: uninsneveruninstall
Name: "{app}\System"; Flags: uninsneveruninstall
Name: "{app}\Noten"; Flags: uninsneveruninstall
Name: "{app}\anfisoft"; Flags: uninsneveruninstall

[Files]
Source: "Distribution\OrgaMon-Daten.ini"; DestDir: "{app}"; DestName: "OrgaMon.ini"; Flags: onlyifdoesntexist

Source: "Distribution\OLAP\*"; DestDir: "{app}\OLAP"; Flags: onlyifdoesntexist
Source: "Distribution\Mahnung.Unplausibel.OLAP.txt"; DestDir: "{app}\OLAP"
Source: "Distribution\HTML Vorlagen\*.html"; DestDir: "{app}\HTML Vorlagen"; Flags: onlyifdoesntexist
Source: "Distribution\System\*"; DestDir: "{app}\System"; Flags: onlyifdoesntexist
Source: "Distribution\Noten\*"; DestDir: "{app}\Noten"; Flags: onlyifdoesntexist
Source: "Distribution\anfisoft\*"; DestDir: "{app}\anfisoft"; Flags: onlyifdoesntexist
