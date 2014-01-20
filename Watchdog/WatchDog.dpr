program WatchDog;

uses
  SvcMgr,
  UnitWatchDog in 'UnitWatchDog.pas' {ServiceWatchDog: TService},
  anfix32 in '..\Anfix32\anfix32.pas',
  ServiceManager in '..\Anfix32\ServiceManager.pas',
  SHFolders in '..\Anfix32\SHFolders.pas',
  CareTakerClient in '..\Anfix32\CareTakerClient.pas',
  html in '..\Anfix32\html.pas',
  gplists in '..\Anfix32\gplists.pas',
  SimplePassword in '..\Anfix32\SimplePassword.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TServiceWatchDog, ServiceWatchDog);
  Application.Run;
end.
