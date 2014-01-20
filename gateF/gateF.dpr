program gateF;

uses
  Forms,
  PrintView in 'PrintView.pas' {PrintViewForm},
  globals in 'globals.pas',
  SystemSettings in 'SystemSettings.pas' {FormSystemSettings},
  BesucherListe in 'BesucherListe.pas' {BesucherListeForm},
  VerbindungIT in 'VerbindungIT.pas' {VerbindungITForm},
  BenutzerWechsel in 'BenutzerWechsel.pas' {BenutzerWechselForm},
  PlanungLoeschen in 'PlanungLoeschen.pas' {PlanungLoeschenForm},
  Willkommen in 'Willkommen.pas' {WillkommenForm},
  AufWiedersehen in 'AufWiedersehen.pas' {AufWiedersehenForm},
  BesucherPflege in 'BesucherPflege.pas' {BesucherPflegeForm},
  MitarbeiterSuche in 'MitarbeiterSuche.pas' {MitarbeiterSucheForm},
  BesucherSuche in 'BesucherSuche.pas' {BesucherSucheForm},
  SystemPasswort in 'SystemPasswort.pas' {FormSystemPasswort},
  import in 'import.pas' {FormImport},
  Transaction in 'Transaction.pas' {FormTransaction},
  anfix32 in '..\PASconTools\anfix32.pas',
  WordIndex in '..\PASconTools\WordIndex.pas',
  splash in '..\PASvisTools\splash.pas' {FormSplashScreen},
  wanfix32 in '..\PASvisTools\wanfix32.pas',
  SymbolPool in 'SymbolPool.pas',
  gplists in '..\PASconTools\gplists.pas',
  html in '..\PASconTools\html.pas',
  infozip in '..\infozip\infozip.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'gateF';
  Application.CreateForm(TBesucherListeForm, BesucherListeForm);
  Application.CreateForm(TFormSystemSettings, FormSystemSettings);
  Application.CreateForm(TPrintViewForm, PrintViewForm);
  Application.CreateForm(TVerbindungITForm, VerbindungITForm);
  Application.CreateForm(TBenutzerWechselForm, BenutzerWechselForm);
  Application.CreateForm(TPlanungLoeschenForm, PlanungLoeschenForm);
  Application.CreateForm(TWillkommenForm, WillkommenForm);
  Application.CreateForm(TAufWiedersehenForm, AufWiedersehenForm);
  Application.CreateForm(TBesucherPflegeForm, BesucherPflegeForm);
  Application.CreateForm(TMitarbeiterSucheForm, MitarbeiterSucheForm);
  Application.CreateForm(TBesucherSucheForm, BesucherSucheForm);
  Application.CreateForm(TFormSystemPasswort, FormSystemPasswort);
  Application.CreateForm(TFormImport, FormImport);
  Application.CreateForm(TFormTransaction, FormTransaction);
  Application.CreateForm(TFormSplashScreen, FormSplashScreen);
  Application.Run;
end.

