program TerminPlaner;

uses
  Forms,
  KalenderAnsicht in 'KalenderAnsicht.pas' {FormKalenderAnsicht},
  HilfeAnzeige in 'HilfeAnzeige.pas' {FormHilfeAnzeige},
  anfix32 in '..\Anfix32\anfix32.pas',
  SHFolders in '..\Anfix32\SHFolders.pas',
  html in '..\Anfix32\html.pas',
  gplists in '..\Anfix32\gplists.pas',
  globals in 'globals.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormKalenderAnsicht, FormKalenderAnsicht);
  Application.CreateForm(TFormHilfeAnzeige, FormHilfeAnzeige);
  Application.Run;
end.
