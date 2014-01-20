program NonDa;

uses
  Forms,
  Datensammler in 'Datensammler.pas' {Form1},
  globals in 'globals.pas',
  anfix32 in '..\Anfix32\anfix32.pas',
  SHFolders in '..\Anfix32\SHFolders.pas',
  SolidFTP in '..\Anfix32\SolidFTP.pas',
  CareTakerClient in '..\Anfix32\CareTakerClient.pas',
  SimplePassword in '..\Anfix32\SimplePassword.pas',
  gnugettext in '..\Anfix32\gnugettext.pas',
  html in '..\Anfix32\html.pas',
  gplists in '..\Anfix32\gplists.pas',
  WordIndex in '..\Anfix32\WordIndex.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
