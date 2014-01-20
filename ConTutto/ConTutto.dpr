program ConTutto;

// Bemerkungen zum Hebu-Projekt:
// Eigenschaften der Text-Elemente sind alle im "Label1" gespeichert
// Die folgenden Labels machen einen propertry Copy

uses
  Forms,
  noten in 'noten.pas' {NotenForm},
  HauptMenu in 'HauptMenu.pas' {HauptMenue},
  SystemSettings in 'SystemSettings.pas' {SettingForm},
  InstallComponent in 'InstallComponent.pas' {InstallForm},
  globals in 'globals.pas',
  decrypt in 'decrypt.pas' {FormDecrypt},
  HeBuBase in 'HeBuBase.pas' {FormHeBuBase},
  MiniTexte in 'MiniTexte.pas' {MiniTexteForm},
  FilterDialog in 'FilterDialog.pas' {FilterForm},
  Remain in 'Remain.pas' {MainForm},
  WirUeber in 'WirUeber.pas' {WirUeberForm},
  Hilfe in 'Hilfe.pas' {HilfeForm},
  Name in 'Name.pas' {NameForm},
  ListenAnsicht in 'ListenAnsicht.pas' {ListenAnsichtForm},
  verlage in 'verlage.pas' {VerlageForm},
  Jubi in 'Jubi.pas' {JubiForm},
  ObermayerImport in 'ObermayerImport.pas' {FormObermayerImport},
  TrackAnsicht in 'TrackAnsicht.pas' {FormTrackAnsicht},
  NotenDaten in 'NotenDaten.pas' {FormNotenDaten},
  WebExport in 'WebExport.pas' {FormWebExport},
  anfix32 in '..\PASconTools\anfix32.pas',
  html in '..\PASconTools\html.pas',
  WinAmp in '..\PASvisTools\WinAmp.pas',
  splash in '..\PASvisTools\splash.pas' {FormSplashScreen},
  WordIndex in '..\PASconTools\WordIndex.pas',
  gplists in '..\PASconTools\gplists.pas',
  Rstream in 'Rstream.pas',
  wanfix32 in '..\PASvisTools\wanfix32.pas',
  binlager32 in '..\PASconTools\binlager32.pas',
  AddCursors in 'AddCursors.pas',
  volumes in 'volumes.pas',
  PasLibVlcUnit in 'PasLibVlcUnit.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'ConTutto 2';
  Application.CreateForm(TNameForm, NameForm);
  Application.CreateForm(TFormDecrypt, FormDecrypt);
  Application.CreateForm(THauptMenue, HauptMenue);
  Application.CreateForm(TFormHeBuBase, FormHeBuBase);
  Application.CreateForm(TNotenForm, NotenForm);
  Application.CreateForm(TSettingForm, SettingForm);
  Application.CreateForm(TInstallForm, InstallForm);
  Application.CreateForm(TMiniTexteForm, MiniTexteForm);
  Application.CreateForm(TFilterForm, FilterForm);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TWirUeberForm, WirUeberForm);
  Application.CreateForm(THilfeForm, HilfeForm);
  Application.CreateForm(TListenAnsichtForm, ListenAnsichtForm);
  Application.CreateForm(TVerlageForm, VerlageForm);
  Application.CreateForm(TJubiForm, JubiForm);
  Application.CreateForm(TFormObermayerImport, FormObermayerImport);
  Application.CreateForm(TFormTrackAnsicht, FormTrackAnsicht);
  Application.CreateForm(TFormNotenDaten, FormNotenDaten);
  Application.CreateForm(TFormWebExport, FormWebExport);
  Application.CreateForm(TFormSplashScreen, FormSplashScreen);
  Application.Run;
end.

