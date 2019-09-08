; -- .iss --
; -- Grundlage von TPicUpload.iss.iss

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
AppName=TPicUpload
AppVerName=TPicUpload «RevMitPunkt»
AppCopyright=Copyright (C) 2004-2005 Thorsten Schroff
DefaultDirName={pf}\TPicUpload
DefaultGroupName=TPicUpload
LicenseFile=D:\Delphi\TPicUpload\gnu-gpl-tpicupload.txt
DisableStartupPrompt=yes
DisableReadyMemo=yes
OutputDir=D:\Web\Cargobay
OutputBaseFilename=Setup-TPicUpload-«RevMitPunkt»
AppVersion=«RevMitPunkt»
ChangesAssociations=no
WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP

[Dirs]
; Verzeichnisse
;Name: "{app}\folder"

[Files]
; Anwendung
; root (Source: "TPicUpload\*"; DestDir: "{app}")
Source: "TPicUpload.exe"; DestDir: "{app}";
Source: "TPicUpload.ini-dst"; DestDir: "{app}"; DestName: "TPicUpload.ini"; Flags: onlyifdoesntexist uninsneveruninstall;
Source: "..\openssl\openssl-1.0.2o-i386-win32\libeay32.dll"; DestDir: "{app}";
Source: "..\openssl\openssl-1.0.2o-i386-win32\ssleay32.dll"; DestDir: "{app}";
Source: "..\openssl\openssl-1.0.2o-i386-win32\OpenSSL License.txt"; DestDir: "{app}";
Source: "D:\Web\Cargobay\TPicUpload_Info.html"; DestDir: "{app}";
Source: "icon_selected.bmp"; DestDir: "{app}";
Source: "icon_unselected.bmp"; DestDir: "{app}";
; source (Source: "TPicUpload\sources\*"; DestDir: {app}")
;Source: "TPicUpload.dpr"; DestDir: "{app}\source"; DestName: "TPicUpload.dpr";
;Source: "TPUMain.dfm"; DestDir: "{app}\source"; DestName: "TPUMain.dfm";
;Source: "TPUMain.pas"; DestDir: "{app}\source"; DestName: "TPUMain.pas";
;Source: "TPUIni.dfm"; DestDir: "{app}\source"; DestName: "TPUIni.dfm";
;Source: "TPUIni.pas"; DestDir: "{app}\source"; DestName: "TPUIni.pas";
;Source: "TPUSplash.dfm"; DestDir: "{app}\source"; DestName: "TPUSplash.dfm";
;Source: "TPUSplash.pas"; DestDir: "{app}\source"; DestName: "TPUSplash.pas";
;Source: "TPicUpload_Highlight_05.bmp"; DestDir: "{app}\source"; DestName: "tpicupload.bmp";

[Icons]
Name: "{group}\TPicUpload"; Filename: "{app}\TPicUpload.exe";
Name: "{group}\TPicUpload Setup"; Filename: "{app}\TPicUpload.ini";
Name: "{group}\TPicUpload Info"; Filename: "{app}\TPicUpload_Info.html";
Name: "{group}\TPicUpload Uninstall"; Filename: "{uninstallexe}";
Name: "{userdesktop}\TPicUpload"; Filename: "{app}\TPicUpload.exe";

[Registry]
Root: HKCR; Subkey: "Directory\shell\tpicupload"; ValueType: string; ValueData: "Mit TPicUpload hochladen"; Flags: uninsdeletekey;
Root: HKCR; Subkey: "Directory\shell\tpicupload\command"; ValueType: string; ValueData: "{app}\TPicUpload.exe ""%L"""; Flags: uninsdeletekey;

[Run]
Filename: "{app}\TPicUpload.exe"; Parameters: """{param:RunOnPath|}"""; Description: "Starte TPicUpload"; Flags: nowait skipifnotsilent;
Filename: "{app}\TPicUpload_Info.html"; Description: "TPicUpload Info anzeigen"; Flags: nowait shellexec runminimized skipifnotsilent;
Filename: "{app}\TPicUpload_Info.html"; Description: "TPicUpload Info anzeigen"; Flags: postinstall nowait shellexec skipifsilent unchecked;

[InstallDelete]
; Type: files; Name: "{app}\user_login.htm";

