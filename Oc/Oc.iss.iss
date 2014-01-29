;
; -- Oc.iss --
;

[Languages]
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Setup]
AppName=Oc
AppVerName=Oc 1.231
AppCopyright=Copyright (C) 2005-2009 Andreas Filsinger
AppPublisher=OrgaMon
AppPublisherURL=http://www.orgamon.org/
AppSupportURL=http://cargobay.orgamon.org/Oc.html
AppUpdatesURL=http://cargobay.orgamon.org/Oc.html
DefaultDirName={pf}\Oc
DefaultGroupName=Oc
UninstallDisplayIcon={app}\Oc.exe
LicenseFile=..\OrgaMon\Rohstoffe\gnu-gpl-orgamon.txt
DisableStartupPrompt=yes
DisableReadyPage=yes
DisableDirPage=no
DisableProgramGroupPage=yes
DisableReadyMemo=yes
OutputDir=..\..\CargoBay
OutputBaseFilename=Setup-Oc-1231
AppVersion=1231
ChangesAssociations=yes
Compression=lzma/max
WizardImageFile=compiler:WIZMODERNIMAGE-IS.BMP
WizardSmallImageFile=compiler:WIZMODERNSMALLIMAGE-IS.BMP
; VersionInfoVersion=1.231
; VersionInfoCompany=OrgaMon
; VersionInfoCopyright=Copyright (C) 2005-2009 Andreas Filsinger

[Files]
; Anwendung
Source: "C:\Program Files\\Oc\Oc.exe"; AfterInstall: AddOpenWithKeys; DestDir: "{app}"

; infozip
Source: "..\infozip\zip32z64.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\infozip\unzip32.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall

; libxml
Source: "..\libxml2\bin\iconv.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\libeay32.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\ssleay32.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\zlib1.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall
Source: "..\libxml2\bin\libxml2.dll"; DestDir: "{app}"; Flags: 32bit onlyifdoesntexist uninsneveruninstall

[Icons]
Name: "{group}\Oc"; Filename: "{app}\Oc.exe"
Name: "{group}\Oc Info"; Filename: "\rev\Oc_Info.html"


[Code]

//will add the "Open with MyApp" menu item to a file even if the file is not registered with your app
procedure AddOpenWithKeys();
var
  bExists     : Boolean;
  myExtension : String;
  myDescriptor: String;
  xDescriptor : String;
  myFileDesc  : String;
  myOpenKey   : String;
  myOpenMenu  : String;
  myExeName   : String;
begin

  //---------------------------------------------
  //  xls -> Autokonvert mit Oc
  //---------------------------------------------

  myExtension  := '.xls'              //the extension you want to associate with your app
  myDescriptor := 'WES.Oc.Database' //the descriptor of the extension (make unique)
  myFileDesc   := 'Excel Document'     //the description of the file type with your extension
  myOpenKey    := 'OpenWithOc'      //a name for the OpenWith key (make unique)
  myOpenMenu   := 'xls-Konvertieren mit Oc 1.231'   //the menu item that will be displayed when you right-click on a file with your extension
  myExeName    := 'Oc.exe'          //the executable that is associated with the extension (assumes it is in {app})

  //if the extension key does not exist in the registry then we add it with a customized descriptor
  bExists := RegKeyExists( HKCR, myExtension );
  if not bExists then
  begin
     RegWriteStringValue (HKCR, myExtension, '', myDescriptor); //we add the extension key
  end;

  //at this point we are assured that the extension key is in the registry. it already existed and
  //we left it untouched or we just added it in the step above. so now we just get the descriptor
  //value associated with the extension key
  RegQueryStringValue( HKCR, myExtension, '', xDescriptor );

  //if the descriptor key does not exist in the registry then we add it with a customized file description
  bExists := RegKeyExists( HKCR, xDescriptor );
  if not bExists then
  begin
     RegWriteStringValue (HKCR, xDescriptor, '', myFileDesc); //we add the descriptor key
  end;

  //at this point we are assured an extension key and a descriptor key so we add our "Open with" keys
  //first we add the "Open with MyApp" key to the descriptor
  RegWriteStringValue (HKCR, xDescriptor + '\shell\' + myOpenKey, '', myOpenMenu);
  //second we add the application file path key to the descriptor
  RegWriteStringValue (HKCR, xDescriptor + '\shell\' + myOpenKey + '\command', '','"' + ExpandConstant('{app}\') + myExeName + '" "%1"');

  //---------------------------------------------
  //  xls -> csv
  //---------------------------------------------

  myExtension  := '.xls'              //the extension you want to associate with your app
  myDescriptor := 'WES.Oc.Database' //the descriptor of the extension (make unique)
  myFileDesc   := 'Excel Document'     //the description of the file type with your extension
  myOpenKey    := 'csvWithOc'      //a name for the OpenWith key (make unique)
  myOpenMenu   := 'Speichern als csv'   //the menu item that will be displayed when you right-click on a file with your extension
  myExeName    := 'Oc.exe'          //the executable that is associated with the extension (assumes it is in {app})

  //if the extension key does not exist in the registry then we add it with a customized descriptor
  bExists := RegKeyExists( HKCR, myExtension );
  if not bExists then
  begin
     RegWriteStringValue (HKCR, myExtension, '', myDescriptor); //we add the extension key
  end;

  //at this point we are assured that the extension key is in the registry. it already existed and
  //we left it untouched or we just added it in the step above. so now we just get the descriptor
  //value associated with the extension key
  RegQueryStringValue( HKCR, myExtension, '', xDescriptor );

  //if the descriptor key does not exist in the registry then we add it with a customized file description
  bExists := RegKeyExists( HKCR, xDescriptor );
  if not bExists then
  begin
     RegWriteStringValue (HKCR, xDescriptor, '', myFileDesc); //we add the descriptor key
  end;

  //at this point we are assured an extension key and a descriptor key so we add our "Open with" keys
  //first we add the "Open with MyApp" key to the descriptor
  RegWriteStringValue (HKCR, xDescriptor + '\shell\' + myOpenKey, '', myOpenMenu);
  //second we add the application file path key to the descriptor
  RegWriteStringValue (HKCR, xDescriptor + '\shell\' + myOpenKey + '\command', '','"' + ExpandConstant('{app}\') + myExeName + '" "%1" --xls');


  //---------------------------------------------
  //  txt -> ?
  //---------------------------------------------

  myExtension  := '.txt'              //the extension you want to associate with your app
  myDescriptor := 'WES.txt.Oc.Database' //the descriptor of the extension (make unique)
  myFileDesc   := 'Text Document'     //the description of the file type with your extension
  myOpenKey    := 'OpenWithOcAsTXT'      //a name for the OpenWith key (make unique)
  myOpenMenu   := 'txt-Konvertieren mit Oc 1.231'   //the menu item that will be displayed when you right-click on a file with your extension
  myExeName    := 'Oc.exe'          //the executable that is associated with the extension (assumes it is in {app})

  //if the extension key does not exist in the registry then we add it with a customized descriptor
  bExists := RegKeyExists( HKCR, myExtension );
  if not bExists then
  begin
     RegWriteStringValue (HKCR, myExtension, '', myDescriptor); //we add the extension key
  end;

  //at this point we are assured that the extension key is in the registry. it already existed and
  //we left it untouched or we just added it in the step above. so now we just get the descriptor
  //value associated with the extension key
  RegQueryStringValue( HKCR, myExtension, '', xDescriptor );

  //if the descriptor key does not exist in the registry then we add it with a customized file description
  bExists := RegKeyExists( HKCR, xDescriptor );
  if not bExists then
  begin
     RegWriteStringValue (HKCR, xDescriptor, '', myFileDesc); //we add the descriptor key
  end;

  //at this point we are assured an extension key and a descriptor key so we add our "Open with" keys
  //first we add the "Open with MyApp" key to the descriptor
  RegWriteStringValue (HKCR, xDescriptor + '\shell\' + myOpenKey, '', myOpenMenu);
  //second we add the application file path key to the descriptor
  RegWriteStringValue (HKCR, xDescriptor + '\shell\' + myOpenKey + '\command', '','"' + ExpandConstant('{app}\') + myExeName + '" "%1" --txt');
  
  //---------------------------------------------
  //  csv -> ?
  //---------------------------------------------

  myExtension  := '.csv'              //the extension you want to associate with your app
  myDescriptor := 'WES.csv.Oc.Database' //the descriptor of the extension (make unique)
  myFileDesc   := 'Comma seperated values'     //the description of the file type with your extension
  myOpenKey    := 'OpenWithOcAsCSV'      //a name for the OpenWith key (make unique)
  myOpenMenu   := 'csv-Konvertieren mit Oc 1.231'   //the menu item that will be displayed when you right-click on a file with your extension
  myExeName    := 'Oc.exe'          //the executable that is associated with the extension (assumes it is in {app})

  //if the extension key does not exist in the registry then we add it with a customized descriptor
  bExists := RegKeyExists( HKCR, myExtension );
  if not bExists then
  begin
     RegWriteStringValue (HKCR, myExtension, '', myDescriptor); //we add the extension key
  end;

  //at this point we are assured that the extension key is in the registry. it already existed and
  //we left it untouched or we just added it in the step above. so now we just get the descriptor
  //value associated with the extension key
  RegQueryStringValue( HKCR, myExtension, '', xDescriptor );

  //if the descriptor key does not exist in the registry then we add it with a customized file description
  bExists := RegKeyExists( HKCR, xDescriptor );
  if not bExists then
  begin
     RegWriteStringValue (HKCR, xDescriptor, '', myFileDesc); //we add the descriptor key
  end;

  //at this point we are assured an extension key and a descriptor key so we add our "Open with" keys
  //first we add the "Open with MyApp" key to the descriptor
  RegWriteStringValue (HKCR, xDescriptor + '\shell\' + myOpenKey, '', myOpenMenu);
  //second we add the application file path key to the descriptor
  RegWriteStringValue (HKCR, xDescriptor + '\shell\' + myOpenKey + '\command', '','"' + ExpandConstant('{app}\') + myExeName + '" "%1" --csv');


  //---------------------------------------------
  //  xml -> ?
  //---------------------------------------------

  myExtension  := '.xml'              //the extension you want to associate with your app
  myDescriptor := 'WES.xml.Oc.Database' //the descriptor of the extension (make unique)
  myFileDesc   := 'Extensible Markup Language'     //the description of the file type with your extension
  myOpenKey    := 'OpenWithOcAsXML'      //a name for the OpenWith key (make unique)
  myOpenMenu   := 'xml-Konvertieren mit Oc 1.231'   //the menu item that will be displayed when you right-click on a file with your extension
  myExeName    := 'Oc.exe'          //the executable that is associated with the extension (assumes it is in {app})

  //if the extension key does not exist in the registry then we add it with a customized descriptor
  bExists := RegKeyExists( HKCR, myExtension );
  if not bExists then
  begin
     RegWriteStringValue (HKCR, myExtension, '', myDescriptor); //we add the extension key
  end;

  //at this point we are assured that the extension key is in the registry. it already existed and
  //we left it untouched or we just added it in the step above. so now we just get the descriptor
  //value associated with the extension key
  RegQueryStringValue( HKCR, myExtension, '', xDescriptor );

  //if the descriptor key does not exist in the registry then we add it with a customized file description
  bExists := RegKeyExists( HKCR, xDescriptor );
  if not bExists then
  begin
     RegWriteStringValue (HKCR, xDescriptor, '', myFileDesc); //we add the descriptor key
  end;

  //at this point we are assured an extension key and a descriptor key so we add our "Open with" keys
  //first we add the "Open with MyApp" key to the descriptor
  RegWriteStringValue (HKCR, xDescriptor + '\shell\' + myOpenKey, '', myOpenMenu);
  //second we add the application file path key to the descriptor
  RegWriteStringValue (HKCR, xDescriptor + '\shell\' + myOpenKey + '\command', '','"' + ExpandConstant('{app}\') + myExeName + '" "%1" --xml');


  //---------------------------------------------
  //  xml -> ?
  //---------------------------------------------

  myExtension  := '.xml'              //the extension you want to associate with your app
  myDescriptor := 'WES.xml.Oc.Database' //the descriptor of the extension (make unique)
  myFileDesc   := 'Extensible Markup Language'     //the description of the file type with your extension
  myOpenKey    := 'OpenWithOcAsVAL'      //a name for the OpenWith key (make unique)
  myOpenMenu   := 'xml-Validierung mit Oc 1.231'   //the menu item that will be displayed when you right-click on a file with your extension
  myExeName    := 'Oc.exe'          //the executable that is associated with the extension (assumes it is in {app})

  //if the extension key does not exist in the registry then we add it with a customized descriptor
  bExists := RegKeyExists( HKCR, myExtension );
  if not bExists then
  begin
     RegWriteStringValue (HKCR, myExtension, '', myDescriptor); //we add the extension key
  end;

  //at this point we are assured that the extension key is in the registry. it already existed and
  //we left it untouched or we just added it in the step above. so now we just get the descriptor
  //value associated with the extension key
  RegQueryStringValue( HKCR, myExtension, '', xDescriptor );

  //if the descriptor key does not exist in the registry then we add it with a customized file description
  bExists := RegKeyExists( HKCR, xDescriptor );
  if not bExists then
  begin
     RegWriteStringValue (HKCR, xDescriptor, '', myFileDesc); //we add the descriptor key
  end;

  //at this point we are assured an extension key and a descriptor key so we add our "Open with" keys
  //first we add the "Open with MyApp" key to the descriptor
  RegWriteStringValue (HKCR, xDescriptor + '\shell\' + myOpenKey, '', myOpenMenu);
  //second we add the application file path key to the descriptor
  RegWriteStringValue (HKCR, xDescriptor + '\shell\' + myOpenKey + '\command', '','"' + ExpandConstant('{app}\') + myExeName + '" "%1" --val');


  //---------------------------------------------
  //  tab -> ?
  //---------------------------------------------

  myExtension  := '.tab'              //the extension you want to associate with your app
  myDescriptor := 'WES.tab.Oc.Database' //the descriptor of the extension (make unique)
  myFileDesc   := 'TAB seperated values'     //the description of the file type with your extension
  myOpenKey    := 'OpenWithOcAsTAB'      //a name for the OpenWith key (make unique)
  myOpenMenu   := 'tab-Konvertieren mit Oc 1.231'   //the menu item that will be displayed when you right-click on a file with your extension
  myExeName    := 'Oc.exe'          //the executable that is associated with the extension (assumes it is in {app})

  //if the extension key does not exist in the registry then we add it with a customized descriptor
  bExists := RegKeyExists( HKCR, myExtension );
  if not bExists then
  begin
     RegWriteStringValue (HKCR, myExtension, '', myDescriptor); //we add the extension key
  end;

  //at this point we are assured that the extension key is in the registry. it already existed and
  //we left it untouched or we just added it in the step above. so now we just get the descriptor
  //value associated with the extension key
  RegQueryStringValue( HKCR, myExtension, '', xDescriptor );

  //if the descriptor key does not exist in the registry then we add it with a customized file description
  bExists := RegKeyExists( HKCR, xDescriptor );
  if not bExists then
  begin
     RegWriteStringValue (HKCR, xDescriptor, '', myFileDesc); //we add the descriptor key
  end;

  //at this point we are assured an extension key and a descriptor key so we add our "Open with" keys
  //first we add the "Open with MyApp" key to the descriptor
  RegWriteStringValue (HKCR, xDescriptor + '\shell\' + myOpenKey, '', myOpenMenu);
  //second we add the application file path key to the descriptor
  RegWriteStringValue (HKCR, xDescriptor + '\shell\' + myOpenKey + '\command', '','"' + ExpandConstant('{app}\') + myExeName + '" "%1" --tab');


end;

//the function is dependent on path of the EXE. in my case it is in {app} so the function
//has to be called after the {app} variable has been initialized. so any page after the directory
//selection page will do.
function NextButtonClick(CurPage: Integer): Boolean;
begin
  case CurPage of
    wpSelectTasks:
      AddOpenWithKeys();
  end;

  Result := true;
end;
