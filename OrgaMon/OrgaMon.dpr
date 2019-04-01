//
// mderec.inc in 'MDEREC.INC'
//
program OrgaMon;


uses
  Forms,
  Graphics,
  globals in 'globals.pas',
  Datenbank in 'Datenbank.pas' {DataModuleDatenbank: TDataModule},
  Bearbeiter in 'Bearbeiter.pas' {FormBearbeiter},
  Person in 'Person.pas' {FormPerson},
  Artikel in 'Artikel.pas' {FormArtikel},
  main in 'main.pas' {FormMain},
  Serie in 'Serie.pas' {FormSerie},
  Laender in 'Laender.pas' {FormLaender},
  InternationaleTexte in 'InternationaleTexte.pas' {FormInternationaleTexte},
  SystemPflege in 'SystemPflege.pas' {FormSystemPflege},
  PersonDoppelte in 'PersonDoppelte.pas' {FormPersonDoppelte},
  PersonExport in 'PersonExport.pas' {FormPersonExport},
  Belege in 'Belege.pas' {FormBelege},
  Lager in 'Lager.pas' {FormLager},
  ArtikelSortiment in 'ArtikelSortiment.pas' {FormArtikelSortiment},
  MwSt in 'MwSt.pas' {FormMwSt},
  Einstellungen in 'Einstellungen.pas' {FormEinstellungen},
  BelegSuche in 'BelegSuche.pas' {FormBelegSuche},
  PersonSuche in 'PersonSuche.pas' {FormPersonSuche},
  CreatorMain in 'CreatorMain.pas' {FormCreatorMain},
  CreatorOK in 'CreatorOK.pas' {FormCreatorOK},
  CreatorWait in 'CreatorWait.pas' {FormCreatorWait},
  AusgangsRechnungen in 'AusgangsRechnungen.pas' {FormAusgangsRechnungen},
  Mahnung in 'Mahnung.pas' {FormMahnung},
  Inventur in 'Inventur.pas' {FormInventur},
  QueryEdit in 'QueryEdit.pas' {FormQueryEdit},
  Ereignis in 'Ereignis.pas' {FormEreignis},
  ArtikelEingabe in 'ArtikelEingabe.pas' {FormArtikelEingabe},
  Tagesabschluss in 'Tagesabschluss.pas' {FormTagesAbschluss},
  Versender in 'Versender.pas' {FormVersender},
  BelegVersand in 'BelegVersand.pas' {FormBelegVersand},
  VersenderPaketID in 'VersenderPaketID.pas' {FormVersenderPaketID},
  BelegRecherche in 'BelegRecherche.pas' {FormBelegRecherche},
  ArtikelVerlag in 'ArtikelVerlag.pas' {FormArtikelVerlag},
  ArtikelBackorder in 'ArtikelBackorder.pas' {FormArtikelBackorder},
  PreisCode in 'PreisCode.pas' {FormPreisCode},
  ArtikelAusgabeArt in 'ArtikelAusgabeArt.pas' {FormArtikelAusgabeArt},
  Prorata in 'Prorata.pas' {FormProrata},
  bbelege in 'bbelege.pas' {FormBBelege},
  BestellArbeitsplatz in 'BestellArbeitsplatz.pas' {FormBestellArbeitsplatz},
  WebShopConnector in 'WebShopConnector.pas' {FormWebShopConnector},
  Aktion in 'Aktion.pas' {FormAktion},
  WarenBewegung in 'WarenBewegung.pas' {FormWarenBewegung},
  NatuerlicheResourcen in 'NatuerlicheResourcen.pas' {FormNatuerlicheResourcen},
  Datensicherung in 'Datensicherung.pas' {FormDatensicherung},
  BaseUpdate in 'BaseUpdate.pas' {FormBaseUpdate},
  ArtikelAusgang in 'ArtikelAusgang.pas' {FormArtikelAusgang},
  PreAuftrag in 'PreAuftrag.pas' {FormPreAuftrag},
  ArtikelPakete in 'ArtikelPakete.pas' {FormArtikelPakete},
  ArtikelNeu in 'ArtikelNeu.pas' {FormArtikelNeu},
  ArtikelRang in 'ArtikelRang.pas' {FormArtikelRang},
  Tier in 'Tier.pas' {FormTier},
  ArtikelLeistung in 'ArtikelLeistung.pas' {FormArtikelLeistung},
  MandantAuswahl in 'MandantAuswahl.pas' {FormMandantAuswahl},
  Replikation in 'Replikation.pas' {FormReplikation},
  TierAuswahl in 'TierAuswahl.pas' {FormTierAuswahl},
  ArtikelKategorie in 'ArtikelKategorie.pas' {FormArtikelKategorie},
  OLAP in 'OLAP.pas' {FormOLAP},
  DruckLabel in 'DruckLabel.pas' {FormDruckLabel},
  DruckSpooler in 'DruckSpooler.pas' {FormDruckSpooler},
  Objektverwaltung in 'Objektverwaltung.pas' {FormObjektverwaltung},
  KontoAuswertung in 'KontoAuswertung.pas' {FormKontoAuswertung},
  LohnTabelle in 'LohnTabelle.pas' {FormLohntabelle},
  BudgetKalkulation in 'BudgetKalkulation.pas' {FormBudgetKalkulation},
  RechnungsUebersicht in 'RechnungsUebersicht.pas' {FormRechnungsUebersicht},
  Baustelle in 'Baustelle.pas' {FormBaustelle},
  Budget in 'Budget.pas' {FormBudget},
  Arbeitszeit in 'Arbeitszeit.pas' {FormArbeitszeit},
  GeoPostleitzahlen in 'GeoPostleitzahlen.pas' {FormGeoPostleitzahlen},
  Zahlungsart in 'Zahlungsart.pas' {FormZahlungsart},
  Musiker in 'Musiker.pas' {FormMusiker},
  FolgeSetzen in 'FolgeSetzen.pas' {FormFolgeSetzen},
  ArtikelContext in 'ArtikelContext.pas' {FormArtikelContext},
  QProfil in 'QProfil.pas' {FormQProfil},
  QArbeitsbereich in 'QArbeitsbereich.pas' {FormQArbeitsbereich},
  QAuftrag in 'QAuftrag.pas' {FormQAuftrag},
  QGruppe in 'QGruppe.pas' {FormQGruppe},
  Qmain in 'Qmain.pas' {FormQMain},
  Medium in 'Medium.pas' {FormMedium},
  QAbzeichnen in 'QAbzeichnen.pas' {FormQAbzeichnen},
  CareServer in 'CareServer.pas' {FormCareServer},
  PersonMailer in 'PersonMailer.pas' {FormPersonMailer},
  ArtikelAusgabeartAuswahl in 'ArtikelAusgabeartAuswahl.pas' {FormArtikelAusgabeartAuswahl},
  ArtikelPreis in 'ArtikelPreis.pas' {FormArtikelPreis},
  AnschriftOptimierung in 'AnschriftOptimierung.pas' {FormAnschriftOptimierung},
  Auftrag in 'Auftrag.pas' {FormAuftrag},
  AuftragAssist in 'AuftragAssist.pas' {FormAuftragAssist},
  AuftragExtern in 'AuftragExtern.pas' {FormAuftragExtern},
  AuftragSuchindex in 'AuftragSuchindex.pas' {FormAuftragSuchindex},
  AuftragErgebnis in 'AuftragErgebnis.pas' {FormAuftragErgebnis},
  AuftragSuche in 'AuftragSuche.pas' {FormAuftragSuche},
  AuftragImport in 'AuftragImport.pas' {FormAuftragImport},
  AuftragMobil in 'AuftragMobil.pas' {FormAuftragMobil},
  MonteurUmfang in 'MonteurUmfang.pas' {FormMonteurUmfang},
  PlanquadratNachfrage in 'PlanquadratNachfrage.pas' {FormPlanquadratNachfrage},
  Tagwache in 'Tagwache.pas' {FormTagwache},
  AuftragArbeitsplatz in 'AuftragArbeitsplatz.pas' {FormAuftragArbeitsplatz},
  Buchhalter in 'Buchhalter.pas' {FormBuchhalter},
  AutoUp in 'AutoUp.pas' {FormAutoUp},
  GeoLokalisierung in 'GeoLokalisierung.pas' {FormGeoLokalisierung},
  AuftragGeo in 'AuftragGeo.pas' {FormAuftragGeo},
  GeoArbeitsplatz in 'GeoArbeitsplatz.pas' {FormGeoArbeitsplatz},
  QTicketArbeitsplatz in 'QTicketArbeitsplatz.pas' {FormQTicketArbeitsplatz},
  Buchung in 'Buchung.pas' {FormBuchung},
  ZahlungECconnect in 'ZahlungECconnect.pas' {FormZahlungECconnect},
  AuftragBildzuordnung in 'AuftragBildzuordnung.pas' {FormAuftragBildzuordnung},
  ArtikelEinheit in 'ArtikelEinheit.pas' {FormArtikelEinheit},
  PlakatDruck in 'PlakatDruck.pas' {FormPlakatDruck},
  Vertrag in 'Vertrag.pas' {FormVertrag},
  Kontext in 'Kontext.pas' {FormKontext},
  PEM in 'PEM.PAS',
  ArtikelAAA in 'ArtikelAAA.pas' {FormArtikelAAA},
  BuchBarKasse in 'BuchBarKasse.pas' {FormBuchBarKasse},
  REST in 'REST.pas' {DataModuleREST: TDataModule},
  BaustelleFoto in 'BaustelleFoto.pas' {FormBaustelleFoto},
  epIMPORT in 'epIMPORT.pas' {FormepIMPORT},
  FavoritenSQL in 'FavoritenSQL.pas' {FormSQLFavoriten},
  libxml2 in '..\libxml2\libxml2.pas',
  Rechnungen in 'Rechnungen.pas' {FormRechnungen},
  RechnungenFrame in 'RechnungenFrame.pas' {FrameRechnungUeberblick: TFrame},
  eConnect in 'eConnect.pas',
  Kalender in 'Kalender.pas' {FormKalender},
  Auswertung in 'Auswertung.pas' {FormAuswertung},
  Audit in 'Audit.pas' {FormAudit},
  FotoMeldung in 'FotoMeldung.pas' {FormFotoMeldung},
  FrageLoeschenMonteurInfo in 'FrageLoeschenMonteurInfo.pas' {FormFrageLoeschenMonteurInfo},
  feiertage in 'feiertage.pas' {FormOfficialHolidays},
  feiertagbearbeiten in 'feiertagbearbeiten.pas' {FormEditOfficialHolidays},
  wanfix32 in '..\PASvisTools\wanfix32.pas',
  txlib_UI in '..\PASvisTools\txlib_UI.pas',
  splash in '..\PASvisTools\splash.pas' {FormSplashScreen},
  SysHot in '..\PASvisTools\SysHot.pas',
  Geld in '..\PASconTools\Geld.pas',
  GHD_pngimage in '..\PASconTools\GHD_pngimage.pas',
  gplists in '..\PASconTools\gplists.pas',
  anfix32 in '..\PASconTools\anfix32.pas',
  sperre in '..\PASconTools\sperre.pas',
  ExcelHelper in '..\PASconTools\ExcelHelper.pas',
  WordIndex in '..\PASconTools\WordIndex.pas',
  txlib in '..\PASconTools\txlib.pas',
  CareTakerClient in '..\PASconTools\CareTakerClient.pas',
  html in '..\PASconTools\html.pas',
  DTA in '..\PASconTools\DTA.PAS',
  OrientationConvert in '..\PASconTools\OrientationConvert.pas',
  binlager32 in '..\PASconTools\binlager32.pas',
  SolidFTP in '..\PASconTools\SolidFTP.pas',
  GeoCache in '..\PASconTools\GeoCache.pas',
  basic32 in '..\PASconTools\basic32.pas',
  srvXMLRPC in '..\PASconTools\srvXMLRPC.pas',
  ContextBase in '..\PASconTools\ContextBase.pas',
  FastGEO in '..\PASconTools\FastGEO.pas',
  GHD_pnglang in '..\PASconTools\GHD_pnglang.pas',
  OpenOfficePDF in '..\PASconTools\OpenOfficePDF.pas',
  SimplePassword in '..\PASconTools\SimplePassword.pas',
  WinAmp in '..\PASvisTools\WinAmp.pas',
  Mapping in '..\PASconTools\Mapping.pas',
  IBExcel in '..\PASconTools\IBExcel.pas',
  txHoliday in '..\PASconTools\txHoliday.pas',
  OpenStreetMap in '..\PASconTools\OpenStreetMap.pas',
  TPUMain in '..\TPicUpload\TPUMain.pas' {FormTPMain},
  TSJpeg in '..\TPicUpload\TSJpeg.pas',
  TSResample in '..\TPicUpload\TSResample.pas',
  MsMultiPartFormData in '..\TPicUpload\MsMultiPartFormData.pas',
  TPUIni in '..\TPicUpload\TPUIni.pas' {Ini},
  Auswertung.Generator.MixStatistik.config in 'Auswertung.Generator.MixStatistik.config.pas' {FormAGM_Config},
  Auswertung.Generator.MixStatistik.editcity in 'Auswertung.Generator.MixStatistik.editcity.pas' {FormAGM_EditCity},
  Auswertung.Generator.MixStatistik.lnmits in 'Auswertung.Generator.MixStatistik.lnmits.pas',
  Auswertung.Generator.MixStatistik.main in 'Auswertung.Generator.MixStatistik.main.pas' {FormAGM_Main},
  ArtikelBild in 'ArtikelBild.pas' {FormArtikelBild},
  Resource.SiteDownload in 'Resource.SiteDownload.pas' {FormSiteDownload},
  TPUUploadProgress in '..\TPicUpload\TPUUploadProgress.pas' {UploadProgressForm},
  Funktionen_Basis in 'Funktionen_Basis.pas',
  Funktionen_Beleg in 'Funktionen_Beleg.pas',
  Funktionen_Auftrag in 'Funktionen_Auftrag.pas',
  Funktionen_Buch in 'Funktionen_Buch.pas',
  ArtikelKasse in 'ArtikelKasse.pas' {FormArtikelKasse},
  ArtikelPOS in 'ArtikelPOS.pas' {FormArtikelPOS},
  Funktionen_Transaktion in 'Funktionen_Transaktion.pas',
  Funktionen_LokaleDaten in 'Funktionen_LokaleDaten.pas',
  IB_Components in '..\..\IBO5\source\core\IB_Components.pas',
  IB_Access in '..\..\IBO5\source\access\IB_Access.pas',
  dbOrgaMon in '..\PASconTools\dbOrgaMon.pas',
  memcache in '..\PASconTools\memcache.pas',
  GUIhelp in '..\PASvisTools\GUIhelp.pas' {DataModuleGUIhelp: TDataModule},
  ServiceApp in 'ServiceApp.pas' {FormServiceApp},
  ServiceFoto in 'ServiceFoto.pas' {FormServiceFoto},
  Foto in '..\PASconTools\Foto.pas',
  systemd in '..\PASconTools\systemd.pas',
  ArtikelEingang in 'ArtikelEingang.pas' {FormArtikelEingang},
  c7zip in '..\PASconTools\c7zip.pas',
  Funktionen_App in 'Funktionen_App.pas',
  Funktionen_OLAP in 'Funktionen_OLAP.pas';

{$R *.RES}

begin
//ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  StartDebug('Main');
  Application.Initialize;
  Application.Title := 'OrgaMon';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormSplashScreen, FormSplashScreen);
  Application.CreateForm(TDataModuleDatenbank, DataModuleDatenbank);
  Application.CreateForm(TFormPersonSuche, FormPersonSuche);
  Application.CreateForm(TFormBearbeiter, FormBearbeiter);
  Application.CreateForm(TFormPerson, FormPerson);
  Application.CreateForm(TFormArtikel, FormArtikel);
  Application.CreateForm(TFormSerie, FormSerie);
  Application.CreateForm(TFormLaender, FormLaender);
  Application.CreateForm(TFormInternationaleTexte, FormInternationaleTexte);
  Application.CreateForm(TFormSystemPflege, FormSystemPflege);
  Application.CreateForm(TFormPersonDoppelte, FormPersonDoppelte);
  Application.CreateForm(TFormPersonExport, FormPersonExport);
  Application.CreateForm(TFormQTicketArbeitsplatz, FormQTicketArbeitsplatz);
  Application.CreateForm(TFormBuchung, FormBuchung);
  Application.CreateForm(TFormBelege, FormBelege);
  Application.CreateForm(TFormLager, FormLager);
  Application.CreateForm(TFormArtikelSortiment, FormArtikelSortiment);
  Application.CreateForm(TFormMwSt, FormMwSt);
  Application.CreateForm(TFormEinstellungen, FormEinstellungen);
  Application.CreateForm(TFormBelegSuche, FormBelegSuche);
  Application.CreateForm(TFormCreatorMain, FormCreatorMain);
  Application.CreateForm(TFormCreatorOK, FormCreatorOK);
  Application.CreateForm(TFormCreatorWait, FormCreatorWait);
  Application.CreateForm(TFormAusgangsRechnungen, FormAusgangsRechnungen);
  Application.CreateForm(TFormMahnung, FormMahnung);
  Application.CreateForm(TFormInventur, FormInventur);
  Application.CreateForm(TFormQueryEdit, FormQueryEdit);
  Application.CreateForm(TFormEreignis, FormEreignis);
  Application.CreateForm(TFormArtikelEingabe, FormArtikelEingabe);
  Application.CreateForm(TFormTagesAbschluss, FormTagesAbschluss);
  Application.CreateForm(TFormVersender, FormVersender);
  Application.CreateForm(TFormBelegVersand, FormBelegVersand);
  Application.CreateForm(TFormVersenderPaketID, FormVersenderPaketID);
  Application.CreateForm(TFormBelegRecherche, FormBelegRecherche);
  Application.CreateForm(TFormArtikelVerlag, FormArtikelVerlag);
  Application.CreateForm(TFormArtikelBackorder, FormArtikelBackorder);
  Application.CreateForm(TFormPreisCode, FormPreisCode);
  Application.CreateForm(TFormArtikelAusgabeArt, FormArtikelAusgabeArt);
  Application.CreateForm(TFormProrata, FormProrata);
  Application.CreateForm(TFormBBelege, FormBBelege);
  Application.CreateForm(TFormBestellArbeitsplatz, FormBestellArbeitsplatz);
  Application.CreateForm(TFormWebShopConnector, FormWebShopConnector);
  Application.CreateForm(TFormAktion, FormAktion);
  Application.CreateForm(TFormWarenBewegung, FormWarenBewegung);
  Application.CreateForm(TFormNatuerlicheResourcen, FormNatuerlicheResourcen);
  Application.CreateForm(TFormDatensicherung, FormDatensicherung);
  Application.CreateForm(TFormBaseUpdate, FormBaseUpdate);
  Application.CreateForm(TFormArtikelAusgang, FormArtikelAusgang);
  Application.CreateForm(TFormPreAuftrag, FormPreAuftrag);
  Application.CreateForm(TFormArtikelPakete, FormArtikelPakete);
  Application.CreateForm(TFormArtikelNeu, FormArtikelNeu);
  Application.CreateForm(TFormArtikelRang, FormArtikelRang);
  Application.CreateForm(TFormTier, FormTier);
  Application.CreateForm(TFormArtikelLeistung, FormArtikelLeistung);
  Application.CreateForm(TFormReplikation, FormReplikation);
  Application.CreateForm(TFormTierAuswahl, FormTierAuswahl);
  Application.CreateForm(TFormArtikelKategorie, FormArtikelKategorie);
  Application.CreateForm(TFormOLAP, FormOLAP);
  Application.CreateForm(TFormDruckLabel, FormDruckLabel);
  Application.CreateForm(TFormDruckSpooler, FormDruckSpooler);
  Application.CreateForm(TFormObjektverwaltung, FormObjektverwaltung);
  Application.CreateForm(TFormKontoAuswertung, FormKontoAuswertung);
  Application.CreateForm(TFormLohntabelle, FormLohntabelle);
  Application.CreateForm(TFormBudgetKalkulation, FormBudgetKalkulation);
  Application.CreateForm(TFormRechnungsUebersicht, FormRechnungsUebersicht);
  Application.CreateForm(TFormBaustelle, FormBaustelle);
  Application.CreateForm(TFormBudget, FormBudget);
  Application.CreateForm(TFormArbeitszeit, FormArbeitszeit);
  Application.CreateForm(TFormGeoPostleitzahlen, FormGeoPostleitzahlen);
  Application.CreateForm(TFormZahlungsart, FormZahlungsart);
  Application.CreateForm(TFormMusiker, FormMusiker);
  Application.CreateForm(TFormFolgeSetzen, FormFolgeSetzen);
  Application.CreateForm(TFormArtikelContext, FormArtikelContext);
  Application.CreateForm(TFormQProfil, FormQProfil);
  Application.CreateForm(TFormQArbeitsbereich, FormQArbeitsbereich);
  Application.CreateForm(TFormQAuftrag, FormQAuftrag);
  Application.CreateForm(TFormQGruppe, FormQGruppe);
  Application.CreateForm(TFormQMain, FormQMain);
  Application.CreateForm(TFormMedium, FormMedium);
  Application.CreateForm(TFormQAbzeichnen, FormQAbzeichnen);
  Application.CreateForm(TFormCareServer, FormCareServer);
  Application.CreateForm(TFormPersonMailer, FormPersonMailer);
  Application.CreateForm(TFormArtikelPreis, FormArtikelPreis);
  Application.CreateForm(TFormAnschriftOptimierung, FormAnschriftOptimierung);
  Application.CreateForm(TFormAuftrag, FormAuftrag);
  Application.CreateForm(TFormAuftragAssist, FormAuftragAssist);
  Application.CreateForm(TFormAuftragExtern, FormAuftragExtern);
  Application.CreateForm(TFormAuftragSuchindex, FormAuftragSuchindex);
  Application.CreateForm(TFormAuftragErgebnis, FormAuftragErgebnis);
  Application.CreateForm(TFormAuftragImport, FormAuftragImport);
  Application.CreateForm(TFormAuftragMobil, FormAuftragMobil);
  Application.CreateForm(TFormAuftragSuche, FormAuftragSuche);
  Application.CreateForm(TFormMonteurUmfang, FormMonteurUmfang);
  Application.CreateForm(TFormPlanquadratNachfrage, FormPlanquadratNachfrage);
  Application.CreateForm(TFormTagwache, FormTagwache);
  Application.CreateForm(TFormAuftragArbeitsplatz, FormAuftragArbeitsplatz);
  Application.CreateForm(TFormBuchhalter, FormBuchhalter);
  Application.CreateForm(TFormAutoUp, FormAutoUp);
  Application.CreateForm(TFormGeoLokalisierung, FormGeoLokalisierung);
  Application.CreateForm(TFormAuftragGeo, FormAuftragGeo);
  Application.CreateForm(TFormGeoArbeitsplatz, FormGeoArbeitsplatz);
  Application.CreateForm(TFormZahlungECconnect, FormZahlungECconnect);
  Application.CreateForm(TFormAuftragBildzuordnung, FormAuftragBildzuordnung);
  Application.CreateForm(TFormArtikelEinheit, FormArtikelEinheit);
  Application.CreateForm(TFormPlakatDruck, FormPlakatDruck);
  Application.CreateForm(TFormVertrag, FormVertrag);
  Application.CreateForm(TFormKontext, FormKontext);
  Application.CreateForm(TFormArtikelAAA, FormArtikelAAA);
  Application.CreateForm(TFormBuchBarKasse, FormBuchBarKasse);
  Application.CreateForm(TDataModuleREST, DataModuleREST);
  Application.CreateForm(TFormBaustelleFoto, FormBaustelleFoto);
  Application.CreateForm(TFormepIMPORT, FormepIMPORT);
  Application.CreateForm(TFormSQLFavoriten, FormSQLFavoriten);
  Application.CreateForm(TFormRechnungen, FormRechnungen);
  Application.CreateForm(TFormKalender, FormKalender);
  Application.CreateForm(TFormAuswertung, FormAuswertung);
  Application.CreateForm(TFormAudit, FormAudit);
  Application.CreateForm(TFormFotoMeldung, FormFotoMeldung);
  Application.CreateForm(TFormFrageLoeschenMonteurInfo, FormFrageLoeschenMonteurInfo);
  Application.CreateForm(TFormOfficialHolidays, FormOfficialHolidays);
  Application.CreateForm(TFormEditOfficialHolidays, FormEditOfficialHolidays);
  Application.CreateForm(TFormTPMain, FormTPMain);
  Application.CreateForm(TIni, Ini);
  Application.CreateForm(TFormAGM_Config, FormAGM_Config);
  Application.CreateForm(TFormAGM_EditCity, FormAGM_EditCity);
  Application.CreateForm(TFormAGM_Main, FormAGM_Main);
  Application.CreateForm(TFormArtikelBild, FormArtikelBild);
  Application.CreateForm(TFormSiteDownload, FormSiteDownload);
  Application.CreateForm(TUploadProgressForm, UploadProgressForm);
  Application.CreateForm(TFormArtikelKasse, FormArtikelKasse);
  Application.CreateForm(TFormArtikelPOS, FormArtikelPOS);
  Application.CreateForm(TDataModuleGUIhelp, DataModuleGUIhelp);
  Application.CreateForm(TFormServiceApp, FormServiceApp);
  Application.CreateForm(TFormServiceFoto, FormServiceFoto);
  Application.CreateForm(TFormArtikelAusgabeartAuswahl, FormArtikelAusgabeartAuswahl);
  Application.CreateForm(TFormArtikelEingang, FormArtikelEingang);
  Application.Run;
end.

