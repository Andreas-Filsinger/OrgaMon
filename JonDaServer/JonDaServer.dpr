program JonDaServer;

{$define MonDaServer}

uses
  Forms,
  GUI in 'GUI.pas' {FormGUI},
  PEM in '..\OrgaMon\PEM.PAS',
  globals in 'globals.pas',
  JonDaExec in 'JonDaExec.pas',
  gplists in '..\PASconTools\gplists.pas',
  anfix32 in '..\PASconTools\anfix32.pas',
  html in '..\PASconTools\html.pas',
  binlager32 in '..\PASconTools\binlager32.pas',
  WordIndex in '..\PASconTools\WordIndex.pas',
  CareTakerClient in '..\PASconTools\CareTakerClient.pas',
  SimplePassword in '..\PASconTools\SimplePassword.pas',
  SolidFTP in '..\PASconTools\SolidFTP.pas',
  srvXMLRPC in '..\PASconTools\srvXMLRPC.pas',
  wanfix32 in '..\PASvisTools\wanfix32.pas',
  infozip in '..\infozip\infozip.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;

  Application.Initialize;
  Application.CreateForm(TFormGUI, FormGUI);
  Application.Run;
end.
