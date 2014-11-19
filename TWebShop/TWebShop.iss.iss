; -- .iss --
; -- Grundlage von TWebShop.iss.iss

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
AppName=TWebShop
AppVerName=TWebShop 3.029
AppCopyright=Copyright (C) 2002-2012 Thorsten Schroff
DefaultDirName={pf}\www\htdocs\TWebShop
DefaultGroupName=TWebShop
LicenseFile=gnu-gpl-twebshop.txt
DisableStartupPrompt=yes
DisableReadyMemo=yes
OutputDir=..\..\CargoBay
OutputBaseFilename=Setup-TWebShop-3.029
AppVersion=3.029
ChangesAssociations=no
WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP

[Dirs]
Name: "{app}\core"
Name: "{app}\js"
Name: "{app}\logic"
Name: "{app}\action"
Name: "{app}\site"
Name: "{app}\images"
Name: "{app}\templates"
Name: "{app}\newsletter"

[Files]
Source: "core\*"; DestDir: "{app}\core"; Flags: recursesubdirs
Source: "js\*"; DestDir: "{app}\js"; Flags: recursesubdirs
Source: "logic\*"; DestDir: "{app}\logic"; Flags: recursesubdirs
Source: "action\*"; DestDir: "{app}\action"; Flags: recursesubdirs
Source: "site\*"; DestDir: "{app}\site"; Flags: recursesubdirs
Source: "images\*"; DestDir: "{app}\images"; Flags: recursesubdirs
Source: "templates\*"; DestDir: "{app}\templates"; Flags: recursesubdirs
; Source: "newsletter\*"; DestDir: "{app}\newsletter"; Flags: recursesubdirs 
Source: "FirePHPCore\*"; DestDir: "{app}\FirePHPCore"; Flags: recursesubdirs

Source: "cryption.sig"; DestDir: "{app}";
Source: "gnu-gpl-twebshop.txt"; DestDir: "{app}";
Source: "config.php"; DestDir: "{app}"; DestName: "config-distribution.php";
Source: "id.sig"; DestDir: "{app}";
Source: "index.php"; DestDir: "{app}";
Source: "shop.php"; DestDir: "{app}";
Source: "tpicupload.php"; DestDir: "{app}";
Source: "viewer.php"; DestDir: "{app}";
Source: "favicon.ico"; DestDir: "{app}"; Flags:onlyifdoesntexist

; Doku
Source: "..\..\CargoBay\TWebShop_Info.html"; DestDir: "{app}"
Source: "twebshop.ico"; DestDir: "{app}";
Source: "revision.txt"; DestDir: "{app}"; Flags: IgnoreVersion;

[Icons]
Name: "{group}\TWebShop Info"; Filename: "{app}\TWebShop_Info.html"; IconFilename: "{app}\twebshop.ico";
