; -- .iss --
; -- Grundlage von kasse.iss.iss

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
AppName=kasse
AppVerName=kasse «RevMitPunkt»
AppCopyright=Copyright (C) 2009-2010 Thorsten Schroff / Andreas Filsinger
DefaultDirName={userdocs}\htdocs\kasse
DefaultGroupName=kasse
LicenseFile=gnu-gpl-twebshop-dev.txt
DisableStartupPrompt=yes
DisableReadyMemo=yes
OutputDir=..\..\CargoBay
OutputBaseFilename=Setup-Kasse-«RevMitPunkt»
AppVersion=«RevMitPunkt»
ChangesAssociations=no
WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP

[Dirs]
; Verzeichnisse
; Name: "{app}\admin\updates"

[Files]
; Anwendung
Source: "up.php5"; DestDir: "{app}";
Source: "i_config.inc.php5-dist"; DestDir: "{app}"; DestName: "i_config.inc.php5"; Flags: OnlyIfdoesntexist;
Source: "index.html"; DestDir: "{app}";
Source: "kasse.html"; DestDir: "{app}";
Source: "gnu-gpl-twebshop-dev.txt"; DestDir: "{app}";

; Includes
Source: "..\PHPIncludes\t_cryption.inc.php5"; DestDir: "{app}";
Source: "..\PHPIncludes\t_errorlist.inc.php5"; DestDir: "{app}";
Source: "..\PHPIncludes\t_ibase.inc.php5"; DestDir: "{app}";
Source: "..\PHPIncludes\t_xmlrpc.inc.php5"; DestDir: "{app}";

Source: "revision.txt"; DestDir: "{app}"; Flags: IgnoreVersion;
Source: "favicon.ico"; DestDir: "{app}"; Flags: OnlyIfdoesntexist;
Source: "kasse.ico"; DestDir: "{app}"; Flags: OnlyIfdoesntexist;


[Icons]
Name: "{group}\kasse Info"; Filename: "{app}\kasse_Info.html"; IconFilename: "{app}\kasse.ico";

