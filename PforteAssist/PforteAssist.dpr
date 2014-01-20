program PforteAssist;

uses
  Forms,
  InfoAssist in 'InfoAssist.pas' {InfoAssistForm},
  globals in 'globals.pas',
  anfix32 in '..\PASconTools\anfix32.pas',
  wanfix32 in '..\PASvisTools\wanfix32.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TInfoAssistForm, InfoAssistForm);
  Application.Run;
end.
