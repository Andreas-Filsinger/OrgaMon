{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2024  Andreas Filsinger
  |
  |    This program is free software: you can redistribute it and/or modify
  |    it under the terms of the GNU General Public License as published by
  |    the Free Software Foundation, either version 3 of the License, or
  |    (at your option) any later version.
  |
  |    This program is distributed in the hope that it will be useful,
  |    but WITHOUT ANY WARRANTY; without even the implied warranty of
  |    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  |    GNU General Public License for more details.
  |
  |    You should have received a copy of the GNU General Public License
  |    along with this program.  If not, see <http://www.gnu.org/licenses/>.
  |
  |    https://wiki.orgamon.org/
  |
}
unit globals;

interface

uses
  classes,
  graphics,
{$IFNDEF CONSOLE}
  controls,
{$ENDIF}
{$IFNDEF fpc}
  System.UITypes, System.Types,
{$ELSE}
  fpchelper,
{$ENDIF}
  anfix,
  OrientationConvert,
  WordIndex;

const
  cApplicationName = 'OrgaMon'; // CRYPT-KEY! - never Change a bit!!!
  Version: single = 8.767; // ..\rev\OrgaMon.rev.txt

  // Mindest-Versions-Anforderungen an die Client-App
  cMinVersion_OrgaMonApp: single = 2.045;

  // uneingeschränkt funktionierende Client-App
  cgoodVersion_OrgaMonApp: single = 2.045;

  // INI Sachen
  cIniFName = cApplicationName + '.ini';
  cIniFNameConsole = 'c' + cApplicationName + '.ini';
  cIniDataBaseName = 'DatabaseName';
  cIniDataBaseUser = 'DatabaseUser'; { Default = SYSDBA }
  cIniDataBasePwd = 'DatabasePassword'; { Default = masterkey }
  cIniDataBaseHost = 'DatabaseHost'; { realer Computername des DB-Host }

  cGroup_Id_Default = 'System';
  cGroup_Id_Spare = 'Spare';

  // Datenbank Migrations Hilfen
  TABELLE_AR = 'AUSGANGSRECHNUNG' deprecated 'Migriere nach 1400';

  // Anwendungs Sachen
  HourGlassLevel: integer = 0;
  iForceAppDown: boolean = false; // Anwendung muss jetzt verlassen werden
  nosplash: boolean = false; // wenn true, kein Splash Screen beim Programmstart

  // wenn true, wird keinerlei Timer-Routinen mehr ausgeführt werden sollen
  notimer: boolean = false;

  TimerLevel: integer = 0; // wir erhöht, wenn jemand in einem Timer steckt!

  // wenn true, kein Update der DB-Meta-Daten,
  // wenn true gilt eine andere Update-Quelle
  isBeta: boolean = true;
  is1400: boolean = false;

  LanguageDriver: string = '';

  // Contextsachen
  cContextExtension = '.ctx';
  cContextFirst = 0;
  cContextCountMax = 29;
  cContextCountFName = 'Head' + cContextExtension;

  // Autoup Sachen
  cRevExtension = '.rev.txt';

  // Import - Schema
  cSchemaExtension = '.gzs';
{$ifdef fpc}
  cSpreadSheetExtension = '.ods';
{$else}
  cSpreadSheetExtension = '.xls';
{$endif}
  cImageExtension = '.jpg';
  cPDFExtension = '.pdf';
  cMP3Extension = '.mp3';
  cZIPExtension = '.zip';
  cDATExtension = '.DAT';
  cUTF8DataExtension = '.utf-8.txt';
  cVorlageExtension = '.Vorlage';

  // OrgaMon Unterverzeichnisse für Dokumente ...
  cHTMLTemplatesDir = 'HTML Vorlagen\';
  cHTMLBlocksDir = cHTMLTemplatesDir + 'Blocks\';

  cRechnungPath = 'Rechnungen\';
  cAuswertungenPath = 'Auswertungen\';
  cMahnbescheidPath = 'Mahnbescheide\';
  cTransitionPath = 'Transition\';
  cDruckauftragPath = 'Druckauftrag\';
  cRechnungsKopiePath = 'Rechnungskopie\';
  cGeraeteKommandos = 'Kommandos\';
  cHBCIPath = 'HBCI\';
  cDBASICPath = 'D-BASIC\';

  cOffeneFensterFName = 'Offene Fenster.txt';
  cBreitengrad_in_m = 111136; // [m]
  cPLZlength_default = 5;

  // Buch
  cKontoStr = 'Konto:';
  cBLZStr = 'BLZ:';
  cBICStr = 'BIC:';
  cIBANStr = 'IBAN:';

  cRECHNUNGStr = 'RECHNUNG ';

  // virtuelle Konten
  cKonto_Deckblatt = 'Deckblatt';
  cKonto_Ungebucht = 'Ungebucht';

  // Bezeichnung für Gutschrift aus Lastschrift-Vorlagen
  cAnzeige_Vorgang_LSG = 'LASTSCHRIFT-EINZUG';
  cAnzeige_Vorgang_ABSCHLUSS = 'ABSCHLUSS';
  cAnzeige_Vorgang_EC = 'KARTENZAHLUNG';

  // Masken für Teillieferungen
  cTEILLIEFERUNG_FILTER_ALLE = -1;

  cBuch_HeaderLineAusgleich = 'PERSON_R;BELEG_R;Betrag;Valuta;BUCH_R;Meldung;Konto;TEILLIEFERUNG;EREIGNIS';
  cBuch_Ausgleich = '%d;%d;%m;%s;%d;%s;%s;%d;%d';

  cBuch_HeaderLineForderungen = 'Überschrift;UrsprünglicheGesamtForderung;BELEG_R;TEILLIEFERUNG;Anzahlungen;PERSON_R';
  cBuch_Forderungen = '%s;%m;%d;%d;%m;%d';

  // Suchindizes
  cAuftragsIndexFName = 'Auftrag' + c_wi_FileExtension;
  cBaustelleIndexFName = 'Baustelle.%d' + c_wi_FileExtension;
  cArtikelSuchindexFName = 'Artikel.%s' + c_wi_FileExtension;
  cKontoSuchindexFName = 'Konto.%s' + c_wi_FileExtension;
  cArtikelSuchindexIntern = 'intern';
  cTierSuchindexFName = 'Tier' + c_wi_FileExtension;
  cQAuftragsIndexFName = 'QAuftrag' + c_wi_FileExtension;
  cMusikerSuchindexFName = 'Musiker' + c_wi_FileExtension;

  // Caching
  cSortimentCacheFName = 'Sortiment.Cache';
  cLaenderCacheFName = 'Länder.Cache';
  cKreativeCacheFName = 'Kreative.Cache';
  cVertragsvariantenCacheFName = 'Vertragsvarianten.Cache';
  cItemsCacheFExtension = '.Items';
  cValueCacheFExtension = '.Values';

  // HTML Ausgabebelege
  cHTMLextension = '.html';
  cCombinedExtension = '.combined';
  cDOCextension = '.doc';
  cHTML_OrderFName = 'Bestellung' + cHTMLextension;
  cHTML_ArbeitszeitFName = 'Arbeitszeit' + cHTMLextension;
  cHTML_MahnungFName = 'Mahnung' + cHTMLextension;

  cTradeMark = '™';
  cImpossiblePLZ = '99999';
  // eine im echten Leben nicht vorkommende (vergebene) PLZ

  // Systemparameter
  cAllSettingsAnz = 196;
  cAllSettings: array [0 .. pred(cAllSettingsAnz)] of string = ('MwStSatzManuelleArtikel', 'NachlieferungInfo',
    'BereitsGeliefertInfo', 'StandardTextRechnung', 'FreigabePfad', 'SicherungsPfad', 'SicherungsPrefix',
    'SicherungsTyp', 'SicherungenAnzahl', 'SicherungLokalesZwischenziel', 'NichtMehrLieferbarInfo',
    'DatenbankBackupPfad', 'TagesabschlussUm', 'TagesabschlussAuf', 'NachTagesAbschlussHerunterfahren',
    'TagwacheUm', 'TagwacheAuf', 'NachTagwacheHerunterfahren', 'KontoInhaber', 'KontoBankName',
    'KontoNummer', 'KontoBLZ', 'KontoPIN', 'SpoolPath', 'MusicPath', 'PDFPathShop', 'PDFPathApp',
    'PDFVersender', 'PDFAdmin', 'PDFSend', 'PDFZoom', 'ShopHost', 'XMLRPCHost', 'XMLRPCPort', 'XMLRPCGeroutet', 'ScannerHost',
    'ScannerAutoBuchen', 'LabelHost', 'MagnetoHost', 'PortoFreiAbBrutto', 'PortoMwStLogik', 'Auftragsmedium',
    'Auftragsmotivation', 'AuftragsGrundRückfrage', 'RangZeitfenster', 'LieferzeitZeitfenster',
    'StandardLieferzeit', 'PersonSchnelleRechnung', 'Farbe', 'Replikation', 'OrtFormat', 'GOT',
    'BelegSetzeMengeNullBeiPreisNull', 'BelegRechnungGlattstellen', 'BelegUnterdrückeGeliefertes',
    'BelegMengenSortierung', 'BelegArtikelNeu', 'BearbeiterSprache', 'EinzelpreisNetto', 'Mahnschwelle',
    'Mahnfälligkeitstoleranz', 'MahnungAusgelicheneDazwischenAnzeigen', 'MahnungErstAbUnausgeglichenheit',
    'MahnungGebuehr1', 'MahnungGebuehr2', 'MahnungGebuehr3', 'MahnungZinsSatzPrivat', 'MahnungZinsSatzGewerblich',
    'MahnungMindestZins', 'MahnungMahnstufeZinsEintritt', 'MahnungAbstand', 'MahnlaufbeiTagesabschluss', 'Profil01',
    'Profil02', 'Profil03', 'Profil04', 'Profil05', 'Profil06', 'Profil07', 'Profil08', 'Profil09', 'Profil10',
    'Profil11', 'Profil12', 'Profil13', 'Profil14', 'Profil15', 'Profil16', 'Profil17', 'Profil18',
    'LagerPrinzip', 'LagerPrämisse', 'EinzelPositionNetto', 'KommaFaktor', 'BelegAnzeigeNachBuchen',
    'NachTagesAbschlussAnwendungNeustart', 'htmlPath', 'BilderURL', 'WikiServer',
    'AuftragsObjektPfad', 'FarbeStufe1', 'FarbeStufe2', 'FarbeStufe3', 'FarbeStufe4', 'FarbeStufe5', 'csvQuelle',
    'AblageVerzögerung', 'TagesArbeitszeit', 'MonDaVorlauf', 'NeuanlageZeitraum', 'Schalter01', 'Schalter02',
    'Schalter03', 'Schalter04', 'Schalter05', 'Schalter06', 'Schalter07', 'Schalter08', 'Schalter09', 'Schalter10',
    'Schalter11', 'Schalter12', 'Schalter13', 'Schalter14', 'Schalter15', 'Schalter16', 'Schalter17', 'Schalter18',
    'Schalter19', 'Schalter20', 'TagesabschlussBerechneRang', 'FaktorGanzzahlig', 'CareTaker', 'AutoUpRevPfad',
    'OLAPIstÖffentlich', 'KartenPfad', 'KartenHost', 'NachTagesAbschlussRechnerNeuStarten', 'AutoUpFTP', 'ShopKey',
    'ShopKonto', 'ShopLink', 'ShopArtikelBilderURL', 'ShopArtikelBilderPfad', 'ShopQRPfad', 'OpenOfficePDF',
    'AuftragsAblagePfad', 'TagwacheWochentage', 'TagesabschlussWochentage', 'NachTagwacheAnwendungNeustart',
    'FTPProxyHost', 'FTPProxyPort', 'FTPServer', 'TextdokumentDateierweiterung', 'AusgabeartLastschriftText',
    'KontenHBCI', 'JonDaAdmin', 'RechnungenFortlaufend', 'AnschriftNameOben', 'BruttoVersandGewicht', 'RESTHost',
    'RESTPort', 'RESTGeroutet', 'HBCIRest', 'BaustellenPfad', 'EinsUnterdrückung', 'RechnungsNummerVergabeMoment',
    'NachTagwacheRechnerNeuStarten', 'TestDrucker', 'FunktionsSicherungstellungsPfad', 'KassenHost', 'MobilFTP',
    'FotoPfad', 'BuchFokus', 'ShopMusicPath', 'MaxDownloadsProArtikel', 'TPicUploadPfad', 'VerlagsdatenabgleichPfad',
    'KartenProfil', 'SchubladePort', 'TagwacheBaustelle', 'memcachedHost', 'Ablage', 'KontoSEPAFrist',
    'TagesabschlussIdle', 'KartenQuota', 'AppServerURL', 'GläubigerID', 'AppServerPfad', 'AppServerId',
    'FotoRecherchePfad', 'InternetAblagenPfad', 'DiagnoseFTP', 'ArtikelDatenbankSucheAktiv', 'SuchlimitMaxSuchtreffer',
    'SuchworteAnzahlMax'
    );

  // Start-Datum, minimales Buchungs- / Transaktionsdatum
  // im OrgaMon
  cOrgaMonBirthDay = '17.07.2000';
  cOrgaMonBirthDayAsLong = 20000717;

  // wird benutzt, um Vorgänge auf
  // den St. Nimmerleinstag zu schieben!
  cOrgaMonDeathDay = '01.01.9999';
  cOrgaMonDeathDayAsLong = 99990101;

  // für die Markierung wiederkehrender Gutschriften
  // die nicht über Einnahmenkonten gebucht werden sollen
  cOrgaMonPrivat = '!! ohne Ausgleich-Buchungen !!';

  // OLAP
  cOLAPExtension = '.OLAP.txt';
  cOLAPDimPrefix = 'OLAP.Dim.';
  cOLAPnull = '<NULL>';
  cOLAPcsvSeparator = ';';
  cOLAPcsvQuote = '"';
  cOLAPcsvLineBreak = '|';
  cOLAP_Ergebnis = 'OLAP Ergebnis';
  cOLAP_ErgebnisFName = 'OLAP-Ergebnis.csv';

  // Ergebnis
  cErgebnisPrefix = 'Ergebnis-';

  // Skripte
  cSkriptExtension = '.Skript.txt';

  cAuftragLupeFavoritenFName = 'Auftrag.Lupe.Favoriten.xml';
  cFeiertageFName = 'Feiertage.xml';

  // Fälligkeit von Fordeurngen
  cStandard_ZahlungFrist = 10; { [Tage] }

  // Versendetag
  cVersendetag_ErstesDatum = 20070101;
  cVersendetag_OffsetLagernd = 100;
  cVersendetag_OffsetTage = 10;

  // Rückgängigmachen von Löschaktionen
  cROLL_BACK = 'RollBack-';

  // POS Kasse
  cBON_gemerkt = 'Gemerkt-';
  cBON_Bon = 'Bon-';

  cBON_Beleg_Datum = 'DATUM';
  cBON_Beleg_Uhr = 'UHR';
  cBON_Beleg_Bearbeiter = 'BEARBEITER';
  cBON_Beleg_Gegeben = 'GEGEBEN';

  // WEB Kasse
  cKasse_Wiederholung = 'Rep';
  cKasse_Faktor = ' mal ...';
  cKasse_Sortiment_Delimiter = ':';
  cKasse_Log_Prefix = '{';

type
  TDOM_Reference = integer;
  function GetFBClientLibName: string;

const
  // Mengen Konstanten
  cMenge_max = MaxInt - cVersendetag_OffsetLagernd;

  cMenge_unbegrenzt = -1;
  // Typischer Eintrag für den "immer verfügbaren" Artikel

  cMenge_unbestimmt = -2;
  // Keine Aussage, da Artikel inzwischen gelöscht oder nicht auffindbar
  // Eintrag erfolgt in "MINDESTBESTAND"

  cMenge_downloadbar = -3;
  // der Artikel ist unbegrenzt verfügbar, da es sich um einen
  // Dateidownload handelt

  // Ausgabearten
  cAUSGABEART_OHNE = 0;
  // in der DB-> !!!NULL!!! (nicht "0" - die sollte es nicht geben!)
  cAusgabeArt_Probestimme_PDF: TDOM_Reference = 1;
  cAusgabeArt_Demoaufnahme_MP3: TDOM_Reference = 2;

  // Ausgabearten, die in der Ausgabeart Tabelle gehalten werden
  cAusgabeArt_FirstRID: TDOM_Reference = 3;
  // function cAusgabeArt_Aufnahme_MP3: TDOM_Reference; in "Funktionen_Basis"

  // Medium Typen
  cMediumWeblink = 1;
  cMediumBild = 2;

  // Gewichte für Bubbles "Rechnungs-Belege"
  cV_ZeroState = 100000;
  cV_Fehler = 10000;
  cV_Agent = 01000;
  // cV_Bestellt = 100;
  cV_Rechnung = 0010;
  cV_Geliefert = 0001;

  // Gewichte für Bubbles "Bestell-Belege"
  cB_ZeroState = 100000;
  cB_Fehler = 10000;
  cB_unbestellt = 01000;
  cB_zurueck = 00100;
  cB_Erwartet = 00010;
  cB_Geliefert = 00001;

  // EREIGNIS.ART für Geschäftsabläufe (wird auch für TICKET.ART verwendet)
  eT_BestellungNunVollstaendigLieferbar = 1;
  eT_BestellungNunTeilweiseLieferbar = 2;
  eT_BestellungMerkmalTeilweiseLieferbarVerloren = 3;
  eT_WareEingetroffen = 4;
  eT_LagerPlatzZugeteilt = 5;
  eT_LagerPlatzFreigabe = 6;
  eT_BelegScan = 7;
  eT_Miniscore = 8; // wird vom WebShop erzeugt! Hat keine Info-Eintrag
  eT_WareRausgegangen = 9;
  eT_WareBestellt = 10;
  eT_ZahlungPerLastschrift = 11; // ganze Zahlungsliste im Block
  eT_ForderungsAusgleich = 12;
  eT_KatalogVersendung = 13; // macht Alexander selbst
  eT_PaketIDErhalten = 14; // Es war möglich eine Versand-ID zuzuteilen
  eT_OrgaTix = 15; // Ticket im Support-System
  eT_Umsatzabruf = 16; // Es wurde ein Umsatz abgerufen (Online-Banking)
  eT_Kasse = 17; // Eine Kasse lieferte uns einen Kassenzettel
  eT_Newsletter = 18; // Der Webshop hat einen Newsletter erzeugt
  eT_SaldoAbruf = 19; // Es wurde ein Saldo abgerufen (Online-Banking)
  eT_BenutzerTextUpload = 20; // Blasmusikartikel werden hochgeladen
  eT_WebShopBestellung = 21; // Webshopbestellung
  eT_BelegStorno = 22;
  eT_Vormerken = 23;
  eT_FTP = 24; // Request für einen FTP Upload
  eT_KassenBeleg = 25; // Speicherung eines Kassenbeleges
  eT_AufgabeErledigt = 26; // Personenbezogene Aufgaben sind "erledigt"
  eT_VertragsAnwendung = 27; // Buchungslauf für Verträge
  eT_RechnungPerEMail = 28; // Rechnungsversendung per eMail wurde angefordert
  eT_WebshopLogin = 29;  // Login einer Person
  eT_WebShopLogout = 30; // Logout einer Person
  eT_WebShopArtikelAnzeigen = 31; // Anzeige eines Artikels
  eT_WebShopArtikelDetail = 32; // Anzeige von Details eines Artikels
  eT_WebShopArtikelMusik = 33; // Anhören der Musik zu einem Artikel
  eT_WebShopRemoteSQL = 34; // Ausführen von SQL in der Home-DB
  eT_WebShopRemoteXMLRPC = 35; // Ausführen von XMLRPC im Home-Land
  eT_OrderZusageAenderung = 36; // Neuer Zusage-Termin in einer Order
  eT_KreativeZusammenfuehren = 37; // Haifisch bei den Kreativen
  eT_MahnungPerEMail = 38; // Mahnung per eMail
  eT_Vergriffen = 39; // sorry, dieser Artikel ist nunmehr vergriffen
  eT_ZahlungPerEC = 40; // ganze Zahlungsliste im Block

  // Bestellsystem Motivationsgrund
  eT_MotivationMindestbestand = 10; // aus dem Bestellvorschlag
  eT_MotivationManuell = 20; // manuelle Eingabe durch den Benutzer
  eT_MotivationHaendlerAuftrag = 25; // durch Auftrag eines Händlers
  eT_MotivationKundenAuftrag = 30; // durch Auftrag eines Kunden

  cRefComboOhneEintrag = '- ohne Eintrag -';

  // Ini Schalter
  cIni_Activate = 'JA';
  cIni_Deactivate = 'NEIN';
  cIni_Distinct = 'SEPARAT';

  cAktiveBaustellenFName = 'AktiveBaustellen.txt';
  cMDEFNameMde = 'AUFTRAG.DAT';
  cMDEFNameNeu = 'NEUES.DAT';
  cBlank = '                                         ';
  cNoBearbeiter = -1;
  cVormittagsChar = 'V';
  cNachmittagsChar = 'N';
  cGEO_PQ_Length = 5; // Bei der Routenplanung
  cZaehlerNummerFieldLength = 40;

  //
  cAutoPlanquadratLength = 4;

  // Indexfeld AUFTRAG.STRASSE
  cSTRASSE_OrtsteilcodeLength = 2;
  cSTRASSE_PLANQUADRAT_Length = 30; // 30 relevante Zeichen beim Planquadrat
  cSTRASSE_HausNummern_Length = 6; // HHHHHH
  cSTRASSE_HausnummerNumerischerZusatz_Length = 2; // EE
  cSTRASSE_Wohneinheit_Length = 3;

  // Für Excel Spalten
  cCSV_Column_A = 0;
  cCSV_Column_B = 1;
  cCSV_Column_C = 2;
  cCSV_Column_D = 3;
  cCSV_Column_E = 4;
  cCSV_Column_F = 5;
  cCSV_Column_G = 6;
  cCSV_Column_H = 7;
  cCSV_Column_I = 8;
  cCSV_Column_J = 9;
  cCSV_Column_K = 10;

  // erweiterte Baustellen Einstellungen
  cE_FTPHOST = 'FTPServer';
  cE_FTPUSER = 'FTPBenutzer';
  cE_FTPPASSWORD = 'FTPPasswort';
  cE_ZIPPASSWORD = 'ZipPasswort';
  cE_FTPVerzeichnis = 'FTPVerzeichnis';
  cE_VERZEICHNIS = 'Verzeichnis';
  cE_ZusaetzlicheZips = 'ZusätzlicheZips';
  cE_BAUSTELLE_R = 'BAUSTELLE_R';
  cE_EXPORT_TAN = 'EXPORT_TAN';
  cE_Praefix = 'ZipPräfix';
  cE_Postfix = 'ZipPostfix'; // ".unmoeglich" oder ""
  cE_FreieZaehler = 'FreieZähler';
  cE_FreieZaehler_ErhalteBlanks = 'FreieZählerBlanks';
  cE_SAPReihenfolge = 'SpaltenReihenfolge';
  cE_SpaltenAlias = 'SpaltenAlias';
  cE_SpaltenOhneInhalt = 'SpaltenOhneInhalt';
  cE_MaxperLoad = 'MaxAnzahl';
  cE_MaterialNummerAlt = 'MaterialNummerAlt';
  cE_Zaehlwerk = 'Zählwerk';
  cE_MaterialNummerNeu = 'MaterialNummerNeu';
  cE_ZaehlwerkNeu = 'ZaehlwerksnummerNeu';
  cE_AuchAlsCSV = 'AuchAlsCSV';
  cE_AuchAlsCSVunmoeglich = 'AuchAlsCSV_Unmöglich';
  cE_AuchAlsXML = 'AuchAlsXML';
  cE_AuchAlsEinzelXML = 'AuchAlsEinzelXML';
  cE_AuchAlsXLS = 'AuchAlsXLS';
  cE_AuchAlsXLSunmoeglich = 'AuchAlsXLS_Unmöglich';
  cE_AuchAlsHTML = 'AuchAlsHTML';
  cE_AuchAlsHTMLunmoeglich = 'AuchAlsHTML_Unmöglich';
  cE_AuchAlsPDF = 'AuchAlsPDF';
  cE_HTMLBenennung = cOc_HTMLBenennung;
  cE_OhneStandardXLS = 'OhneStandardXLS';
  cE_OhneKonvertiertXLS = 'OhneKonvertiertXLS';
  cE_OhneHTML = 'OhneHTML';
  cE_EinsZuEins = 'EinsZuEins';
  cE_EineDatei = 'EineDatei';
  cE_Filter = 'Filter'; // für Zählernummer neu
  cE_ZaehlerNummerNeuZeichen = 'ZählerNummerNeuZeichen';
  cE_ZaehlerNummerNeuAusN1 = 'ZählerNummerNeuAusN1';
  cE_ZaehlerNummerNeuMitA1 = 'ZählerNummerNeuMitA1';
  cE_eMail = 'eMail';
  cE_Wochentage = 'Wochentage';
  cE_ZipAnlage = 'ZipAlsAnlage';
  cE_AuchAlsIDOC = 'AuchAlsIDOC';
  cE_QS_Mode = 'QS_Mode';
  cE_SQL_Filter = 'SQL_Filter';
  cE_Datenquelle = 'Datenquelle'; // BAUSTELLE_R
  cE_KopieVon = 'Original'; // BAUSTELLE_R
  cE_FotoQuelle = 'FotoQuelle'; // Quellverzeichnis für die Speicherkarte
  cE_FotoZiel = 'FotoZiel'; // default ist ~BaustellenPfad~ Fotos
  cE_FotoAblage = 'FotoAblage'; // default -ohne- Ablage
  cE_FotosMaxAnzahl = 'FotosMaxAnzahl'; // Maximale Anzahl Bilder im ZIP
  cE_FotoBenennung = 'FotoBenennung'; // Art der Bilder Namensgebung, sowie "FotoBenennung.csv" Dateien
  cE_CoreFTP = 'CoreFTP'; // Besonderer Upload über Core-FTP
  cE_AuchMitFoto = 'AuchMitFoto'; // wenn Fotos mit in das Zip sollen
  cE_SpalteAlsText = 'SpalteAlsText'; // bei der Ausgabe an Excel wichtig
  cE_AbschlussTransaktion = 'AbschlussTransaktion';
  cE_InternInfos = 'InternInfos'; // Solle ALLE InternInfos ausgegeben werden?
  cE_verboteneSpalten = 'VerboteneSpalten'; // Diese Spalten nicht ausgeben

  // Einstellungs-Postfix für den Foto Kontext
  cE_Postfix_Foto = '-Foto';

  // virtuelle Settings
  cE_TAN = 'TAN';
  cE_BAUSTELLE_KURZ = 'BAUSTELLE';
  cE_nichtEFRE = 'nichtEFRE';
  cE_TANLENGTH = 4;
  cE_FotoParameter = 'FotoParameter';
  cE_ZielBaustelle = 'Zielbaustelle';

  cQueryHint: array [0 .. 21] of UnicodeString = ('EDIT=Datensatz ändern', 'POST=Abschicken', 'CANCEL=Abbruch',
    'CANCELSEARCH=Suche abbrechen', 'POSTEDIT=Abschicken', 'POSTINSERT=Abschicken', 'POSTDELETE=Abschicken',
    'FIRST=Erster Datensatz', 'PRIOR=vorheriger Datensatz', 'NEXT=nächster Datensatz', 'LAST=Letzter Datensatz',
    'SEARCH=Suchen', 'COUNT=Anzahl der Datensätze', 'INSERT=Datensatz einfügen', 'DELETE=Datensatz löschen',
    'REFRESH=Aktualisieren', 'REFRESHKEYS=Aktualisieren', 'REFRESHROWS=Aktualisieren', 'POSTSEARCH=Abschicken',
    'CANCELEDIT=Änderung abbrechen', 'CANCELINSERT=Einfügen abbrechen', 'CANCELDELETE=Löschen abbrechen');

type

  TDoubleObject = class(TObject)
    Wert: double;
  end;

const
  cMonDa_Status_unbearbeitet = 0;
  cMonDa_Status_Restant = -1;
  cMonDa_Status_Unmoeglich = -2;
  cMonDa_Status_Wegfall = -3;
  cMonDa_Status_NeuAnschreiben = -4;
  cMonDa_Status_Info = -5;
  cMonDa_Status_Vorgezogen = -6;
  cMonDa_Status_FallBack = -7;
  cMonDa_Status_OhneInfo = -8;
  cMonDa_ImmerAusfuehren = 20000101; // Sonder-Datum "Neu"-Vorlage
  cMonDa_FreieTerminWahl = 20000102; // Sonder-Datum FTW
  cMonDa_ErsterTermin = 20010101; // Ab hier beginnen die echten Termine
  cMonDa_ErsteEingabe = 20020601; // Erster
  cMonDa_FieldLength_ZaehlerNummer = 15;
  cIMEI_Null = '000000000000000';
  cApp_TAN_Maske = '?????';
  cJonDa_ErgebnisMaske_deprecated = cApp_TAN_Maske + cDATExtension; // this do not work in vsftp>2.3.2 anymore
  cJonDa_ErgebnisMaske_deprecated_FTP = '*' + cDATExtension;

  cJonDa_ErgebnisMaske_utf8 = cApp_TAN_Maske + cUTF8DataExtension; // this do not work in vsftp>2.3.2 anymore
  cJonDa_ErgebnisMaske_utf8_FTP = '*' + cUTF8DataExtension;

  // Aufbau der Rückmeldung
  // RID;Z#A-Korrektur;Z#N;ZSN;ZSA;R#-Korrektur;R#-Neu;Protokoll;Datum-Ist;Uhr-Ist
  cMobileMeldung_COLUMN_RID = 0;
  cMobileMeldung_COLUMN_ZAEHLER_KORR = 1;
  cMobileMeldung_COLUMN_ZAEHLER_NEU = 2;
  cMobileMeldung_COLUMN_ZAEHLER_STAND_NEU = 3;
  cMobileMeldung_COLUMN_ZAEHLER_STAND_ALT = 4;
  cMobileMeldung_COLUMN_REGLER_KORR = 5;
  cMobileMeldung_COLUMN_REGLER_NEU = 6;
  cMobileMeldung_COLUMN_PROTOKOLL = 7;
  cMobileMeldung_COLUMN_EINGABE_DATUM = 8;
  cMobileMeldung_COLUMN_EINGABE_UHR = 9;
  cMobileMeldung_COLUMN_MOMENT = 10;

  // Spaltenüberschrift des "RID"
  cRID_Suchspalte = 'ReferenzIdentitaet';

  // Spezieller interner Person RID für die
  // Bankenidentiät, Buchungskonto 1200
  cRID_Person_Lastschrift = -71;

type
  TZaehlerNummerType = string[cMonDa_FieldLength_ZaehlerNummer];
  TTextBlobType = array[1..5] of String[255];
  TMDERec = packed record

    { von GaZMa }
    RID: longint;
    Baustelle: string[6]; { wird auch für die Gerätenummer verwendet }
    ABNummer: string[5];
    Monteur: string[6];
    Art: string[2];
    Zaehlernummer_alt: TZaehlerNummerType;
    Reglernummer_alt: TZaehlerNummerType;
    Ausfuehren_soll: TAnfixDate;
    Vormittags: boolean;
    Monteur_Info: TTextBlobType;
    Zaehler_Info: TTextBlobType; { auch Plausibilitätsfelder }
    Zaehler_Name1: string[35];
    Zaehler_Name2: string[35];
    Zaehler_Strasse: string[35];
    Zaehler_Ort: string[35];

    { von Monda }
    Zaehlernummer_korr: TZaehlerNummerType;
    Zaehlernummer_neu: TZaehlerNummerType;
    Zaehlerstand_neu: string[8];
    Zaehlerstand_alt: string[8];
    Reglernummer_korr: TZaehlerNummerType;
    Reglernummer_neu: TZaehlerNummerType;
    ProtokollInfo: TTextBlobType;

    { von Monda intern }
    { <0: Sonderstati, Bedeutung siehe obige Konstanten }
    { 00: Unerledigt }
    { >0: Erledigt }
    Ausfuehren_ist_datum: TAnfixDate; { Träger von cMonDa_Status }
    Ausfuehren_ist_uhr: TAnfixTime;

  end deprecated 'Migriere nach DB-Storage';

const
  // App-Service
  // ===========
  cJonDaServer_LogFName = 'JonDaServer.log';
  cGeraetSchema = '  ??.??.?? ??:??:?? ?????:???';
  cServerDataPath = 'Daten\';
  cOrgaMonDataPath = 'OrgaMon\';
  cMeldungPath = 'Meldung\';
  cUpdatePath = 'Update\';
  cProtokollPath = 'Protokolle\';
  cGeraeteEinstellungen = 'Einstellungen\';
  cDBPath = 'db\';
  cSyncPath = 'sync\';
  cTrnFName = 'Transaktionsnummer.ini';
  cFirstTrn = '10000';
  cERROR_TAN = '00000';
  cMonDaServer_AbgearbeitetFName = 'abgearbeitet.dat';
  cMonDaServer_AbgezogenFName = 'abgezogen.%s.dat';
  cMonDaServer_UnberuecksichtigtFName = 'unberuecksichtigt.txt';
  cAppService_SendenFName = 'SENDEN.csv';
  cJondaProtokollDelimiter = '~';
  cProtPrefix = 'PROT';
  cProtExtension = '.txt';
  // html-Dateien
  cMonDaIndex = 'MonDa_Index' + cHTMLextension;
  // Eingabe.nnn.txt
  cHeader_Eingabe = 'DATUM;UHRZEIT;RID;REGLER_NUMMER_NEU;ZAEHLER_NUMMER_NEU';
  cActionRestantenLeeren = 'Restanten ignorieren';
  cActionRestantenAddieren = 'Restanten addieren';
  cActionFremdMonteurLoeschen = 'Fremdmonteur löschen';
  // alle Monteure aus <Geräte>.dat sammeln
  // alle anderen Monteure fliegen raus!
  cActionAusAlterTAN = 'Datenmitnahme aus alter TAN';
  // alle Reste aus alter AUFTRAG.DAT einer alten
  // TAN wieder laden. Einfach alle RIDs die nicht
  // in der aktuellen Datei zu finden sind! So ne Art
  // externe STAY.DAT

  // Foto-Service
  // ===========
  cFotoService_BaustelleFName = 'baustelle.csv';
  cFotoService_BaustelleManuellFName = 'baustelle-manuell.csv';
  cFotoService_GlobalHintFName_ZaehlerNummer = 'ZaehlerNummerNeu.xls.csv'; // manuell plazierte Tabelle um "Neu" Umbenennungen durchzuführen
  cFotoService_GlobalHintFName_ReglerNummer = 'ReglerNummerNeu.xls.csv'; // manuell plazierte Tabelle um "Neu" Umbenennungen durchzuführen
  // Für wartende "*Neu*" Bilddateien
  cFotoService_UmbenennungAusstehendHeader = 'DATEINAME_ORIGINAL;DATEINAME_AKTUELL;RID;GERAETENO;BAUSTELLE;MOMENT;BENENNUNG';
  cFotoService_UmbenennungAusstehendFName = 'FotoService-Umbenennung-Ausstehend.csv';
  cFotoService_NeuPlatzhalter = 'Neu';
  // Ablage
  cFotoService_IdFName = 'Backup-Service.ini';
  cFotoService_AblageFName = 'ablage.csv';
  cFotoService_FTPBackupSubPath = 'Fotos\';

  // Creator
  // =======
  cHistorieTextFName = 'Creator\historie.txt';
  cPwdAllTextFName = 'Creator\HEntry.txt';
  SerialText = 'Creator\Serie Nummer.txt';
  CryptOriginal = 'Creator\Original von Crypt.txt';

  // Dateinamen für CD-R
  cNotenTableFName = 'noten.txt';
  // noten und deren Beschreibung, die mitgeliefert werden
  cHaendlerFName = 'Haendler.txt';
  // cd-r pwd Datei "händler" für Einsicht in Händler Adressen
  SerialFName = 'serial.txt'; // Serien-Nummer der CDR
  CryptAusgabe = 'Crypt.txt'; // cd-r pwd Datei "normal" für noten
  MUSExtension = 'MUS';
  cHochKommaMac = '"';
  PlaceForHugeText = 20 * 1024;
  clListeGrau = $F0F0F0;
  clListeGrauer = $E0E0E0;
  cWordHeaderFName = 'Word Kopfzeile.txt';


  // eMail Makros
  ceMail_Anlage = 'Anlage:';
  ceMail_Baustein = 'Baustein:';
  ceMail_eml = 'eml:';
  ceMail_ResetPasswort = 'Aktion:PasswortNeu';

  // eMail UIDS
  cMail_Blocked = 'BLOCKED';

  // Mail-Vorlagen
  cMailvorlage_Login = 'LOGIN';
  cMailvorlage_Ergebnis = 'ERGEBNIS';
  cMailvorlage_Dokument = 'PDF';
  cMailvorlage_Rechnung = 'RECHNUNG';
  cMailvorlage_Mahnung = 'MAHNUNG';
  cMailVorlage_Zusage = 'ZUSAGE';
  cMailvorlage_Versand = 'Versand@';

  // für die Drucklabels
  cZugangsVorgang = 'Warenzugang';
  cLagerBegriff = 'Lager';
  cInventurviaMenge = 'Menge>0';
  cInventur = 'Inventur';
  cBelegbuchung = 'Belegbuchung';

  // Besondere Events der Datenbank
  cEventsDisconnect = 'PLEASE_DISCONNECT';
  cEventsDown = 'PLEASE_DOWN';

  // Farben für Sperren
  cSperreAusfuehren = TColors.red; // Baustelle ist von...bis
  cSperreUrlaub: TColor = TColors.lime; // Monteur
  cSperreWochentag: TColor = TColors.Yellow; // Wochentag
  cSperreAuszeit: TColor = 0;
  cSperreBaustelle = TColors.blue; // innerhalb der Baustelle
  cSperreZaehler = TColors.Purple; // innerhalb des Zählers
  cSperreArbeit = TColors.LtGray;
  // eigentlich keine Sperre sondern umgekehrt -> Arbeit
  cSperreMehrArbeit = TColors.DkGray;
  // eigentlich keine Sperre sondern umgekehrt -> MehrArbeit
  cSperreFeiertag: TColor = 0; // ein Feiertag

  // Werte für Sperren
  // Name;Bad;Color;Prio
  sSperre_Wert_Baustelle: TStringList = nil;
  sSperre_Wert_Person: TStringList = nil;
  sSperre_Wert_Arbeit: TStringList = nil;
  sSperre_Wert_Baustopp: TStringList = nil;
  sSperre_Wert_Zuordnung: TStringList = nil;

  // Sichtbarkeit-Prios für Sperren
  cPrio_ZaehlerSperre = 0;
  cPrio_BaustellenSperre = 1;
  cPrio_MonteurSperre = 2;
  cPrio_FeiertagSperre = 3;

  // Arbeit an sich spielt eigentlich in einer anderen Liga
  cPrio_ArbeitSperre = 0;

  // H = Hausnummer
  // E = Wohneinheit
  // 44/1
  // 44 WE 19
  cAuftragsNummer_Length = 5;

  // Anzahl [Sekunden] die ein Aufwand grösser sein darf als
  // die Kapazität ohne dass von Überlast die Rede ist
  cToleranzRahmenVolllast = 90;

  cMonteurTrenner = '----';
  c2Monteure = '&';
  cProtokollTrenner = '|';

  cMapping_EFRE_Sparten = 'EFRE-Sparten';

  // Mitgabeparameter zum Zeichnen der Auslastungsanzeige
  c_Auslastungsflag_Ueberlast = 1; // Belastung ist mehr als möglich
  c_Auslastungsflag_Fremd = 2; // andere Baustelle wie aktuelle
  c_Auslastungsflag_Mix = 4; // mehrere Baustellen

  cImportFieldsAnz = 64;
  cImportFields: array [0 .. pred(cImportFieldsAnz)] of UnicodeString = (
    { 00 } 'Art',
    { 01 } 'Zähler_Nummer',
    { 02 } 'Zähler_Ort_Name1',
    { 03 } 'Zähler_Ort_Name2',
    { 04 } 'Zähler_Ort_Strasse',
    { 05 } 'Zähler_Ort_Strasse_#_#_#',
    { 06 } 'Zähler_Ort_Ort',
    { 07 } 'Zähler_Ort_Ort_#_#',
    { 08 } 'Zähler_Info_#_#', // Konstante + Feld -> eine Zeile
    { 09 } 'Zähler_Planquadrat',
    { 10 } 'Kunde_Brief_Nummer',
    { 11 } 'Kunde_Brief_Name1',
    { 12 } 'Kunde_Brief_Name2',
    { 13 } 'Kunde_Brief_Straße',
    { 14 } 'Kunde_Brief_Ort',
    { 15 } 'Kunde_Brief_Ort_#_#',
    { 16 } 'Monteur_Info_#_#', // Konstante + Feld -> eine Zeile
    { 17 } 'C_Art_Info', // Konstante -> Art
    { 18 } 'C_Zähler_Ort_Info',
    { 19 } 'Zähler_Sperre_von',
    { 20 } 'Zähler_Sperre_bis',
    { 21 } 'Kunde_Brief_Strasse_#_#_#',
    { 22 } 'Kunde_Brief_Name1_#_#',
    { 23 } 'Intern_Info_#_#',
    { 24 } 'Zähler_Ort_Ortsteil',
    { 25 } 'Kunde_Brief_Ort_#_#_#',
    { 26 } 'Zähler_Planquadrat_#_#',
    { 27 } 'Verbrauch_Datum',
    { 28 } 'Verbrauch_Zähler_Stand',
    { 29 } 'Verbrauch_Pro_Jahr',
    { 30 } 'Regler_Nummer',
    { 31 } 'C_Monteur1_Kürzel',
    { 32 } 'C_Monteur2_Kürzel',
    { 33 } 'Monteur1',
    { 34 } 'Monteur2',
    { 35 } 'WordEmpfänger',
    { 36 } 'C_Zähler_Ort_Ortsteil',
    { 37 } 'Verbrauch_0_Datum',
    { 38 } 'Verbrauch_0_Zähler_Stand',
    { 39 } 'SAP_Info_#_#',
    { 40 } 'SAP_Art_#_#',
    { 41 } 'Zählerstand_AlterZähler',
    { 42 } 'Zählerstand_NeuerZähler',
    { 43 } 'Zähler_Ort_Name1_#_#',
    { 44 } 'Zähler_Ort_Name2_#_#',
    { 45 } 'Wechselzeitraum_Von',
    { 46 } 'Wechselzeitraum_Bis',
    { 47 } 'Wechselzeitraum_Bereich_#_#_#',
    { 48 } 'Zähler_Sperre_Bereich_#_#_#',
    { 49 } 'SAP_Sperre_von',
    { 50 } 'SAP_Sperre_bis',
    { 51 } 'Plausibilität_Min_Max_#_#_#',
    { 52 } 'Strassen_erst_ungerade',
    { 53 } 'Nummer_Auto',
    { 54 } 'Termin',
    { 55 } 'Zusatzarbeiten',
    { 56 } 'C_SAP_INFO_#_#',
    { 57 } 'Transaktion',
    { 58 } 'Material_Nummer',
    { 59 } 'Protokoll_#',
    { 60 } 'Protokoll_C_#',
    { 61 } 'Protokoll_C_C',
    { 62 } 'Zählwerk-Ausbau',
    { 63 } 'Zählwerk-Einbau');

  cWordHeaderLine2 =

  // Bereich I : Zählerdaten
    'Art;' + 'Zaehler_Nummer;' + 'ReglerNummerAlt;' + 'Sperre;' + 'SperreKurz;' +
    'ZaehlerInfo1;ZaehlerInfo2;ZaehlerInfo3;ZaehlerInfo4;ZaehlerInfo5;' +
    'ZaehlerInfo6;ZaehlerInfo7;ZaehlerInfo8;ZaehlerInfo9;ZaehlerInfo10;' +

  // Bereich II : Liegenschaft
    'Verbraucher_Name;' + 'Verbraucher_Name2;' + 'Verbraucher_Strasse;' + 'Verbaucher_Strasse_Teil1;' +
    'Verbaucher_Strasse_Teil2;' + 'Verbaucher_Strasse_Teil3;' + 'Planquadrat;' + 'OrtsteilCode;' +
    'Verbraucher_Ortsteil;' + 'Verbraucher_Ort;' +

  // Bereich III: Anschreiben
    'KundeNummer;' + 'Anschreiben_Name;' + 'Anschreiben_Name2' + 'Anschreiben_Strasse;' + 'Anschreiben_Ort;' +
    'WordEmpfaenger;' + 'WordAnzahl;' +

  // Bereich IV: Termin Info
    'Baustelle;' + 'Auftrags_Nummer;' + 'MonteurText;' + 'WochentagLang;' + 'WochentagKurz;' + 'Datum;' + 'DatumText;' +
    'Zeit;' + 'ZeitText;' + 'Zeit_Von;' + 'Zeit_Bis;' + 'Zeitfenster;' +
    'Monteur;' + 'MonteurHandy;' +
    'InternInfo1;InternInfo2;InternInfo3;InternInfo4;InternInfo5;' +
    'InternInfo6;InternInfo7;InternInfo8;InternInfo9;InternInfo10;' + 'Bemerkung;' +

  // Bereich V: OrgaMon Interna, ohne Bedeutung für den Auftraggeber
    'ReferenzIdentitaet;' + 'Status1;' + 'Status2;' + 'Geaendert;' + 'Bearbeiter;' +

  // Bereich VI: Ergebnisse für den Auftraggeber
    'WechselDatum;' + 'WechselZeit;' + 'ZaehlerNummerKorrektur;' + 'ZaehlerStandAlt;' + 'ZaehlerNummerNeu;' +
    'ZaehlerStandNeu;' + 'ReglerNummerKorrektur;' + 'ReglerNummerNeu;' + 'Protokoll;' + 'Leer';

  // Bereich VII: weitere Ergebnisse für den Auftraggeber (speziefisch!)

  cWordHeaderLine0 =
    {0} 'Datum;KundeNummer;Monteur;Bemerkung;Art;Zaehler_Nummer;' +
    {6} 'Anschreiben_Name;Anschreiben_Strasse;Verbraucher_Ort;' +
    {9} 'Verbraucher_Name;Verbraucher_Strasse;Anschreiben_Ort;' +
    {12} 'Zeit;Geaendert;Auftrags_Nummer;Status1;Status2;WochentagKurz;' +
    {18} 'Verbraucher_Name2;Anschreiben_Name2;WochentagLang;MonteurText;' +
    {22} 'ZeitText;DatumText;Baustelle;Bearbeiter;Sperre;Planquadrat;' +
    {28} 'ZaehlerInfo1;ZaehlerInfo2;ZaehlerInfo3;ZaehlerInfo4;ZaehlerInfo5;' +
    {} 'ZaehlerInfo6;ZaehlerInfo7;ZaehlerInfo8;ZaehlerInfo9;ZaehlerInfo10;' +
    {} 'Verbraucher_Ortsteil;ZaehlerNummerKorrektur;ZaehlerNummerNeu;' +
    {} 'ZaehlerStandAlt;ZaehlerStandNeu;Protokoll;WechselDatum;WechselZeit;' +
    {} 'ReglerNummerAlt;ReglerNummerKorrektur;ReglerNummerNeu;' +
    {} 'Verbaucher_Strasse_Teil1;Verbaucher_Strasse_Teil2;Verbaucher_Strasse_Teil3;' +
    {} 'WordEmpfaenger;ReferenzIdentitaet;WordAnzahl;OrtsteilCode;SperreKurz;MonteurHandy;' +
    {} 'InternInfo1;InternInfo2;InternInfo3;InternInfo4;InternInfo5;' +
    {} 'InternInfo6;InternInfo7;InternInfo8;InternInfo9;InternInfo10;' +
    {68} 'Status3;ZeitraumKurz;Zaehlwerke_Ausbau;Zaehlwerke_Einbau;Zeit_Von;Zeit_Bis;' +
    {74} 'Zeitfenster';

  cWordHeaderLine = cWordHeaderLine0 +
    ';Leer';

  // Spalten, die nicht an den Auftraggeber übertragen werden!
  cRedHeaderLine = 'Protokoll;Planquadrat;OrtsteilCode;InternInfo1;InternInfo2;InternInfo3;' +
    'InternInfo4;InternInfo5;InternInfo6;InternInfo7;InternInfo8;InternInfo9;' +
    'InternInfo10;Leer';

const
  twh_Datum = 0;
  twh_KundeNummer = 1;
  twh_Monteur = 2;
  twh_MonteurInfo = 3;
  twh_Art = 4;
  twh_Zaehler_Nummer = 5;
  twh_Anschreiben_Name = 6;
  twh_Anschreiben_Strasse = 7;
  twh_Verbraucher_Ort = 8;
  twh_Verbraucher_Name = 9;
  twh_Verbraucher_Strasse = 10;
  twh_Anschreiben_Ort = 11;
  twh_Zeit = 12;
  twh_Geaendert = 13;
  twh_Auftrags_Nummer = 14;
  twh_Status1 = 15;
  twh_Status2 = 16;
  twh_WochentagKurz = 17;
  twh_Verbraucher_Name2 = 18;
  twh_Anschreiben_Name2 = 19;
  twh_WochentagLang = 20;
  twh_MonteurText = 21;
  twh_ZeitText = 22;
  twh_DatumText = 23;
  twh_Baustelle = 24;
  twh_Bearbeiter = 25;
  twh_Sperre = 26;
  twh_Planquadrat = 27;
  twh_ZaehlerInfo1 = 28;
  twh_ZaehlerInfo2 = 29;
  twh_ZaehlerInfo3 = 30;
  twh_ZaehlerInfo4 = 31;
  twh_ZaehlerInfo5 = 32;
  twh_ZaehlerInfo6 = 33;
  twh_ZaehlerInfo7 = 34;
  twh_ZaehlerInfo8 = 35;
  twh_ZaehlerInfo9 = 36;
  twh_ZaehlerInfo10 = 37;
  twh_Verbraucher_Ortsteil = 38;
  twh_ZaehlerNummerKorrektur = 39;
  twh_ZaehlerNummerNeu = 40;
  twh_ZaehlerStandAlt = 41;
  twh_ZaehlerStandNeu = 42;
  twh_Protokoll = 43;
  twh_WechselDatum = 44;
  twh_WechselZeit = 45;
  twh_ReglerNummerAlt = 46;
  twh_ReglerNummerKorrektur = 47;
  twh_ReglerNummerNeu = 48;
  twh_Verbaucher_Strasse_Teil1 = 49;
  twh_Verbaucher_Strasse_Teil2 = 50;
  twh_Verbaucher_Strasse_Teil3 = 51;
  twh_WordEmpfaenger = 52;
  twh_ReferenzIdentitaet = 53;
  twh_WordAnzahl = 54;
  twh_OrtsteilCode = 55;
  twh_SperreKurz = 56;
  twh_MonteurHandy = 57;
  twh_InternInfo1 = 58;
  twh_InternInfo2 = 59;
  twh_InternInfo3 = 60;
  twh_InternInfo4 = 61;
  twh_InternInfo5 = 62;
  twh_InternInfo6 = 63;
  twh_InternInfo7 = 64;
  twh_InternInfo8 = 65;
  twh_InternInfo9 = 66;
  twh_InternInfo10 = 67;
  twh_Status3 = 68;
  twh_ZeitraumKurz = 69;
  twh_Zaehlwerke_Ausbau = 70;
  twh_Zaehlwerke_Einbau = 71;
  twh_Zeit_Von = 72;
  twh_Zeit_Bis = 73;
  twh_Zeitfenster = 74;
  twh_Leer = 75;

  // Geschäftsvorgang
  cGV_Forderung = 70;

type
  TeSymbolColor = (cscRed, cscGreen, cscGray, cscLogo);
  TeSymbolBackground = (csbWhite, csbGray);

  TePhaseStatus = (
    { 00 } ctsDatenFehlen, //
    { 01 } ctsTerminiert, //
    { 02 } ctsAngeschrieben, //
    { 03 } ctsMonteurinformiert, //
    { 04 } ctsErfolg, //
    { 05 } ctsNeuAnschreiben, //
    { 06 } ctsHistorisch, //
    { 07 } ctsVorgezogen, // durch einen anderen erledigt!
    { 08 } ctsRestant, //
    { 09 } ctsUnmoeglich, //
    { 10 } ctsLast);

  TeVirtualPhaseStatus = (
    { 00 } ctvDatenFehlen, //
    { 01 } ctvTerminiert, //
    { 02 } ctvAngeschrieben, //
    { 03 } ctvMonteurinformiert, //
    { 04 } ctvErfolg, //
    { 05 } ctvNeuAnschreiben, //
    { 06 } ctvHistorisch, //
    { 07 } ctvVorgezogen, // durch einen anderen erledigt!
    { 08 } ctvRestant, //
    { 09 } ctvUnmoeglich, //
    // Ab jetzt kommen die virtuellen Stati
    { 10+0 } ctvAngeschriebenInformiert,
    { 10+1 } ctvHistorischInformiert,
    { 10+2 } ctvErfolgGemeldet,
    { 10+3 } ctvUnmoeglichGemeldet,
    { 10+4 } ctvVorgezogenGemeldet,
    { 10+5 } ctvUnterwegs,
    { 10+6 } ctvPausiert);

const
  { 00 } cs_DatenFehlen = ord(ctsDatenFehlen);
  { 01 } cs_Terminiert = ord(ctsTerminiert);
  { 02 } cs_Angeschrieben = ord(ctsAngeschrieben);
  { 03 } cs_Monteurinformiert = ord(ctsMonteurinformiert);
  { 04 } cs_Erfolg = ord(ctsErfolg);
  { 05 } cs_NeuAnschreiben = ord(ctsNeuAnschreiben);
  { 06 } cs_Historisch = ord(ctsHistorisch);
  { 07 } cs_Vorgezogen = ord(ctsVorgezogen);
  { 08 } cs_Restant = ord(ctsRestant);
  { 09 } cs_Unmoeglich = ord(ctsUnmoeglich);
  { 10 } cs_AngeschriebenInformiert = ord(ctvAngeschriebenInformiert);
  { 11 } cs_HistorischInformiert = ord(ctvHistorischInformiert);
  { 12 } cs_ErfolgGemeldet = ord(ctvErfolgGemeldet);
  { 13 } cs_UnmoeglichGemeldet = ord(ctvUnmoeglichGemeldet);
  { 14 } cs_VorgezogenGemeldet = ord(ctvVorgezogenGemeldet);
  { 15 } cs_Unterwegs = ord(ctvUnterwegs);
  { 16 } cs_Pausiert = ord(ctvPausiert);

type
  TeInfoStatus = (
    { 0 } cisOK, // 29
    { 1 } cisWiedervorlage, // 15
    { 2 } cisAlarm, // 17
    { 3 } cisSperreVerletzt, // 33
    { 4 } cisProbleme, // 8
    { 5 } cisLast);

  TeWertigkeitBaustellenzuordnung = (
    { } cwb_Keine,
    { } cwb_echteArbeit,
    { } cwb_Zuordnung,
    { } cwb_Vermutung);

  TeTerminarbeitsplatzSortMode = (csm_normalSortierung, csm_PLZSortierung, csm_PostSortierung, csm_ZeitSortierung,
    csm_ZaehlernummerSortierung, csm_BriefadresseSortierung, csm_ABNummerSortierung, csm_StatusSortierung,
    csm_WechselSortierung);

  eRechnungsNummerVergabeMoment = (ernvm_Anlage, ernvm_Berechnen, ernvm_Vorschau, ernvm_Verbuchen);

  // Fotos durchlaufen mehrere Phasen, von ...
  //  Zeit
  //   |
  //   v
  // Build:   der Aufname des Bildes mit der Handy-Camera ...
  //   |      Umbenennen und verschieben in Ziel-Pfade
  //   |      Ablegen in Ziel-Baustellen
  //   v
  // Unpack:  letztendlichen Entpacken
  //   |
  //   v
  // Deliver: Q25 Qualitätsicherung im Moment der Ergebnismeldung
  //   |      Dateiname einbinden in .html Dateien
  //   |      Ausbelichten in PDF
  //   v      Hinzupacken zu einem Kunden-ZIP
  //
  TeFotoPhase = (fp_Build, fp_Unpack, fp_Deliver);

const
  cFotoPhasen : array[fp_Build..fp_Deliver] of String = ('Build','Unpack', 'Deliver');

const
  cPhasenStatusText: array [0 .. ord(ctsLast) + 6] of UnicodeString = (
    { 00 } 'unvollständig',
    { 01 } 'terminiert',
    { 02 } 'angeschrieben',
    { 03 } 'informiert',
    { 04 } 'erfolgreich',
    { 05 } 'Neu anschreiben',
    { 06 } 'historisch',
    { 07 } 'vorgezogen',
    { 08 } 'Restant',
    { 09 } 'unmöglich',
    { 10+0 } 'offen', // ab "offen" sind es virtuelle Status ...
    { 10+1 } 'anschreibbar',
    { 10+2 } 'abgearbeitet',
    { 10+3 } 'gemeldet',
    { 10+4 } 'ungemeldet',
    { 10+5 } 'unterwegs',
    { 10+6 } 'pausiert');

var
  MyProgramPath: string; // OrgaMon-Verzeichnis
  MyApplicationPath: string;
  WebDir: string;
  AnwenderPath: string;
  SearchDir: string;
  SpoolDir: string;
  DatensicherungPath: string;
  SoundPath: string;
  UpdatePath: string;
  DiagnosePath: string;
  ImportePath: string;
  WordPath: string;
  ProtokollePath: string;
  WebPath: string;
  SchemaPath: string;
  RohstoffePath: string;
{$ifndef CONSOLE}
  ContextPath: string;
{$endif}
  EigeneOrgaMonDateienPfad: string;
  MDEPath: string;
  HtmlVorlagenPath: string;
  AuftragMobilServerPath: string;
  FotoPath: string;
  KassePath: string;

  // aus der OrgaMon.ini Datei
  iDataBaseName: string;
  iDataBaseUser: string;
  iDataBasePassword: string; // in verschlüsselter Form im Speicher
  iDataBaseHost: string; // hostname of the database server, if named by herself

  i_c_DataBaseFName: string; // (calculated) pfad/Dateiname der Datenbank
  i_c_DataBasePath: string; // pfad der Datenbank

  // iDataBaseName = i_c_DatabaseHost + ":" + i_c_DataBasePath + i_c_DataBaseFName

  // aus System-Parameter Tabelle
  iSicherungsPfad: string;
  iSicherungsPreFix: string;  // Mandantbezeichnung
  iSicherungenAnzahl: string;
  iSicherungLokalesZwischenziel: boolean;
  iSicherungsTyp: string;

  // Belege / Rechnungen
  iUnterdrueckeGeliefertes: boolean;
  iRechnungsNummerVergabeMoment: eRechnungsNummerVergabeMoment;
  iMwStSatzManuelleArtikel: string;
  iPortoFreiAbBrutto: string;
  iPortoMwStLogik: boolean;
  iNachlieferungInfo: string;
  iBereitsGeliefertInfo: string;
  iNichtMehrLieferbarInfo: string;
  iStandardTextRechnung: string;
  iAuftragsMotivation: string;
  iAuftragsGrundRueckfrage: boolean;
  iSchnelleRechnung_PERSON_R: integer;
  iRechnungGlattstellen: boolean;
  iEinzelpreisNetto: boolean;
  iGOT: boolean; // Gebührenordnung für Tierärtze
  iBruttoVersandGewicht: boolean;
  iMahnSchwelle: double;
  iMahnFaelligkeitstoleranz: integer;
  iMahnungAusgelicheneDazwischenAnzeigen: boolean;
  iMahnungErstAbUnausgeglichenheit: boolean;
  iMahnungGebuehr1: double;
  iMahnungGebuehr2: double;
  iMahnungGebuehr3: double;
  iMahnungZinsSatzPrivat: double;
  iMahnungZinsSatzGewerblich: double;
  iMahnstufeZinsEintritt: integer;
  iMahnungMindestZins: double;
  iMahnfreierZeitraum: integer;
  iMahnungMahnBescheidLaufzeit: integer = 100;
  iMahnlaufbeiTagesabschluss: boolean;
  iEinzelPositionNetto: string;
  iKommaFaktor: boolean;
  iBelegAnzeigeNachBuchen: boolean;
  iBelegAutoSetMengeNull: boolean;
  iBelegMengenSortierung: boolean;
  iBelegArtikelNeu: boolean;

  iDataBaseBackUpDir: string; // fbak Server-Path
  iTranslatePath: string; // fbak Client-Path
  iTagesAbschlussUm: TAnfixTime;
  iTagesAbschlussAuf: string;
  iNachTagesAbschlussAnwendungNeustart: boolean;
  iNachTagesAbschlussRechnerNeustarten: boolean;
  iNachTagwacheAnwendungNeustart: boolean;
  iNachTagwacheRechnerNeustarten: boolean;
  iTagesabschlussAusschluss: string;
  iTagwacheAusschluss: string;

  iArtikelDatenbankSucheAktiv: boolean;
  iSuchlimitMaxSuchtreffer: Integer;
  iSuchworteAnzahlMax:Integer;

  iKontoInhaber: string;
  iGlaeubigerID: string;
  iKontoBankName: string;
  iKontoNummer: string;
  iKontoBLZ: string;
  iKontoPIN: string;
  iKontoSEPAFrist: integer;
  iKontoLSErkennung: boolean;
  iKontenHBCI: string;
  iHBCIRest: string;
  iMusicPath: string;
  iPDFPathApp: string;
  iMailHost: string;
  iPDFAdmin: string;
  iPDFSend: string;

  // App-Server
  iJonDaAdmin: integer;
  iJonDaServer: string;
  iAppServerPfad: string;
  iAppServerId: string; // AppServer-Mandant, [Id]
  iFotoRecherchePfad : string;
  iInternetAblagenPfad : string;

  // Shop Sachen
  iShopDomain: string;
  iShopArtikelBilderPath: string;
  iPDFPathShop: string;
  iXMLRPCHost: string;
  iXMLRPCPort: string;
  iXMLRPCGeroutet: boolean;
  iHTMLPath: string;
  iBildURL: string;
  iTPicUpload: string;
  iVerlagsdatenabgleich: string;
  iShopArtikelBilderURL: string;
  iMusicPathShop: string;
  iMusikDownloadsProArtikel: integer;
  iShopQRPath: string;
  imemcachedHost: string; // Host [ ":" Port ]

const
  // remote Shop Sachen
  cOLAP_ArtikelUmfangRemoteShop = 'Artikel.des.Webshop';
  cOLAP_MusikAusExternenLinks = 'Musik aus externen Links';

  // Scanner Konstanten
  cScanner_VersenderExec  = '+00000-';
  cScanner_Check_Inc_1    = '+00001-';
  cScanner_Buchen         = '+00002-';
  cScanner_Check_Inc_2    = '+00003-';

var
  // remote Shop Sachen
  iShopKey: string;
  iShopKonto: string;
  iShopLink: string;
  iShopMP3: string;

  iRESTHost: string;
  iRESTPort: string;
  iRESTGeroutet: boolean; // XMLRPCGeroutet

  // POS Sachen
  iArtikelAusgang_ScannerHost: string;
  iArtikelEingang_ScannerHost: string;
  iScannerAutoBuchen: boolean;
  iMagnetoHost: string;
  iSchubladePort: string;
  iLabelHost: string;
  iKasseHost: string;
  iTagwacheAuf: string;
  iTagwacheUm: TAnfixTime;
  iNachTagwacheHerunterfahren: boolean;
  iTextDocumentExtension: string;
  iIdleProzessPrioritaetAbschluesse: boolean;
  iNachTagesAbschlussHerunterfahren: boolean;
  iTagwacheWochentage: string;
  iTagwacheBaustelle: integer;
  iTagesabschlussWochentage: string;
  iAuftragsMedium: string;
  iRangZeitfenster: integer;
  iLieferzeitZeitfenster: integer;
  iStandardLieferZeit: integer;
  iFormColor: TColor;
  iReplikation: boolean;
  iHeimatLand: integer;
  iAnschriftNameOben: boolean;
  iOrtFormat: string;
  iAblage: boolean;
  iProfilTexte: TStringList;
  iSchalterTexte: TStringList;
  iOLAPpublic: boolean;
  iNeuanlageZeitraum: integer; // [Tage]
  iOpenOfficePDF: boolean;
  iAusgabeartLastschriftText: integer;

  // L A G E R
  type

  eLagerPrinzipien = (
   LagerPrinzip_Volumen,
   LagerPrinzip_Stapel,
   LagerPrinzip_Menge,
   LagerPrinzip_Masse,
   LagerPrinzip_Diversitaet,
   LagerPrinzip_COUNT);

  eLagerPraemissen = (
   LagerPraemisse_Fluten,
   LagerPraemisse_Zufall,
   LagerPraemisse_Heimweg,
   LagerPraemisse_Gastweg,
   LagerPraemisse_COUNT);

  eLagerPlatzierungen = (
   LagerPlazierung_Stehend,
   LagerPlazierung_Stapel,
   LagerPlazierung_Seitlich,
   LagerPlazierung_Nativ,
   LagerPlazierung_Supermarkt,
   LagerPlazierung_COUNT);

  const
    cVerlagUebergangsfach = 'Übergangsfach'; // im SUCHBEGRIFF der PERSON
    cVerlagFreiesLager = 'Freies Lager'; // im SUCHBEGRIFF der PERSON
    cLagerPrinzipien :
     array[LagerPrinzip_Volumen .. LagerPrinzip_COUNT] of string =
     ('Volumen', 'Stapel', 'Menge', 'Masse', 'Diversität', '*');

    cLagerPraemissen : array[LagerPraemisse_Fluten .. LagerPraemisse_COUNT] of string =
     ('Fluten', 'Zufall', 'Heimweg', 'Gastweg', '*');

    cLagerPlazierungen : array[LagerPlazierung_Stehend .. LagerPlazierung_COUNT] of string =
     ('Stehend', 'Stapel', 'Seitlich', 'Nativ', 'Supermarkt', '*');

    // Index für Lager-Dimensionen
    cLiX      = 0;
    cLiY      = 1;
    cLiZ      = 2;
    cLiMENGE  = 3;
    cLiFREI   = 4;

    cDimensionen: array[cLiX..cLiZ] of string =
     ('X','Y','Z');

  var
    iLagerPrinzip: eLagerPrinzipien;
    iLagerPraemisse: eLagerPraemissen;

  // [AUSGABEART_R] der HBCI Verwendungszweck
  //
  iBuchSonstigeErloese: string;
  iBuchFokus: TAnfixDate;
  iEinsUnterdrueckung: boolean;
  iTestDrucker: string;
  // Name des Druckers für Testausdrucke default = "FreePDF"

  iAuftragsObjektPath: string;
  iAuftragsAblagePath: string;
  iWarnFarbe_L0: TColor;
  iWarnFarbe_L1: TColor;
  iWarnFarbe_L2: TColor;
  iWarnFarbe_L3: TColor;
  iWarnFarbe_L4: TColor;

  // aus GaZMa
  iCSVOpenPath: string;
  iAblageZeitraum: integer; // in Tagen
  iJonDaVorlauf: integer; // in Tagen
  iTagesArbeitszeit: TAnfixTime; // in Sekunden
  iTagesabschlussRang: boolean;
  iFaktorGanzzahlig: boolean;

  // FTP-Sachen
  iMobilFTP: string;
  iDiagnoseFTP: string;

  // aus AutoUp
  iAutoUpRevDir: string = '';
  iAutoUpFTP: string = '';

  // aus Funktions-Sicherstellung Tests
  iFSPath: string = '';

  // global FTP-Proxy
  iFtpProxyHost: string = '';
  iFtpProxyPort: integer = 0;

  // für Kartensachen TxOrtung
  iKartenPfad: string; // Ablage-Fläche auf der Karten-Bild-Dateien bereitgestellt werden
  iKartenHost: string; // Tile-Server, der Angesprochen wird
  iKartenProfil: string; // Zusatz-Einstellungen für das Outfitt der Karten
  iKartenQuota: int64; // Limitierung des Kartenverzeichnisses

  // für Baustellensachen
  iBaustellenPfad: string;

  ActualPwdNoten: string; // pwd 1
  ActualPwdHaendler: string; // pwd 2
  ActualSerialNumber: string; // SerialNumber

  // Persistent Registration Data
  ActualSource: string;
  ETFLager: string;
  CDRAusgabe: string;
  BLAOutFName: string;

  ReallyBigString: array [0 .. pred(PlaceForHugeText)] of char;
  sBearbeiter: integer = -1; // RID des aktuellen Benutzers (-1=keiner)
  sBearbeiterKurz: string = '';

  // True, wenn Datenbankverbindung steht, und alle Start-Ups beendet sind
  //
  AllSystemsRunning: boolean = false;

  // Abschalten von Server-Diensten, über die Kommandozeile!
  pDisableTagesabschluss: boolean = true;
  pDisableTagwache: boolean = true;
  pDisableXMLRPC: boolean = true;
  pDisableMailer: boolean = true;
  pDisableHotkeys: boolean = true;
  pDisableDrucker: boolean = true;
  pDisableKasse: boolean = true;

  pDisableAll: Boolean = false;

const
  // Für CDR Anwendung
  ProjektID = 'anfisoft\hebu';

  // Program-Limits
  MaxDesktopSymbols = 100;
  MaxSymbols = 100;
  MaxFoundAnz = 15000; // Maximale Anzahl der gefundenen Datensätze
  MaxMedien = 25; // Maximale Anzahl der Sound-Medien
  MaxHugeText = 20 * 1024; // Maximale Größe der Info-Text

  // Pixel-Konstanten
  MaxFontSize = 18;
  MaxInpPixelwidth = 390; // Pixel-Breite der Eingabe-Zeile
  LEDPixelPosX = 431; // LED - Position X
  LEDPixelPosY = 21; // LED - Position Y
  WAITPixelPosX = 249;
  WAITPixelPosY = 49;
  INPUTPixelPosX = 27;
  INPUTPixelPosY = 14;
  FILTER_CHECKLISTBOX_ZERO_SIZE = 0;
  FILTER_CHECKLISTBOX_ENTRY_SIZE = 13;
  VolumeReglerPixelPosX = 50;
  VolumeReglerPixelPosY = 78;
  VolumeOFFSwitchArea: TRect = (left: 10; top: 10; right: 52; bottom: 77);
  ListenAnsichtArea: TRect = (left: 6; top: 41; right: 25; bottom: 59);
  ZoomSizeX = 90;
  ZoomSizeY = 120;
  LEDonTimer = 1;
  LEDoffTimer = 3;
  LegalStr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  TranslatetStr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ';
  swmode: boolean = false;
  MaxSubSearch = 20; // Max Anzahl der Suchworte

  // FILTER-IDs
  cFILTER_ANZ = 6;

  FILTER_FELDER = 1;
  FILTER_LAND = 2;
  FILTER_SCHWER = 3;
  FILTER_PREIS = 4;
  FILTER_MUSIC = 5;
  FILTER_NEU = 6;

  // Offsets für verschiedene Farben
  FilterOFF = 0;
  FilterGREEN = cFILTER_ANZ;
  FilterRED = cFILTER_ANZ * 2;

  //
  BUT_INFO = 0;
  BUT_SEARCH = 1;
  BUT_EXIT = 2;
  BUT_DATABASE = 3;
  BUT_NON = 3;

  cSym_Notiz_leer: word = 0;
  cSym_Notiz_belegt: word = 0;
  cSym_Bestell_leer: word = 0;
  cSym_Bestell_belegt: word = 0;
  cSym_Eingabe: word = 0;
  cSym_sound_disabled: word = 0;
  cSym_Sound_play: word = 0;
  cSym_Sound_volume: word = 0;
  cSym_rSound_weel: word = 0;
  cSym_hilfe: word = 0;
  cSym_Mulleimer_leer: word = 0;
  cSym_Mulleimer_belegt: word = 0;
  cSym_neu: word = 0;
  cSym_preis: word = 0;
  cSym_schwer: word = 0;
  cSym_land: word = 0;
  cSym_musik: word = 0;
  cSym_feld: word = 0;
  cSym_Farben: word = 0;
  cSym_HeBu: word = 0;
  cSym_Amos: word = 0;
  cSym_rdunkelrot: word = 0;
  cSym_rrot: word = 0;
  cSym_rgrun: word = 0;
  cSym_rdunkelgrun: word = 0;
  cSym_rLED_grun: word = 0;
  cSym_rLED_gelb: word = 0;
  cSym_rLED_blau: word = 0;
  cSym_rLED_rot: word = 0;
  cSym_rLED_grau: word = 0;
  cSym_InterNet: word = 0;
  cSym_Jubi: word = 0;

const
  Artikel0FName = 'artikel0.bin';
  Artikel1FName = 'artikel1.bin';
  Bestellung0FName = 'best0.rtf';
  Bestellung1FName = 'best1.rtf';
  CDHintergrundFName = 'cdback.bmp';
  Desktop0x1024FName = 'd0x10.ini';
  Desktop0x640FName = 'd0x6.ini';
  Desktop0x800FName = 'd0x8.ini';
  Desktop1x1024FName = 'd1x10.ini';
  Desktop1x640FName = 'd1x6.ini';
  Desktop1x800FName = 'd1x8.ini';
  HilfeDemosFName = 'hdemos.txt';
  HilfeLizenzFName = 'hlizenz.txt';
  HilfeMetrixFName = 'hmetrix.txt';
  HilfeNotenFName = 'hnoten.txt';
  NotenHinterGrundFName = 'noback.bmp';
  WordStartIndex0FName = 'wsi0.bin';
  WordStartIndex1FName = 'wsi1.bin';
  WordStartSorted0FName = 'wss0.bin';
  WordStartSorted1FName = 'wss1.bin';

type
  tDataBaseRec = packed record
    ArtikelNo: string[10];
    Land: string[3];
    Titel: string[80];
    Komponist: string[35];
    Arranger: string[35];
    schwer: string[10];
    preis: single;
    verlag: string[35];
    Serie: string[35];
    Dauer: string[10];
    ProbeStimme: string[10];
    Aufnahme: string[35];
    Sparte: string[35];
    Bemerkung: integer;
    Komposition: integer;
    UeberKomponist: integer;
    UeberArranger: integer;
    PaperColor: TColor;
    BestellNo: string[10];
    OrgPreis: single;
    OrgCurrency: string[3];
    EntryDate: integer;
    SoundSource: byte; // 0=nicht verfügbar, 1=HeBu CDR usw.
    dealerID: string[6]; // xxxxxc, eigentlich integer
    BildDokument: integer; // Nummer des Bildes falls vorhanden
  end;

  tCheckArray = array [1 .. 1023] of boolean;

  tVerlag = packed record
    nummer: string[10]; // eigentlich integer
    name: string[40];
    strasse: string[40];
    Ort: string[40];
    Ansprechpartner: string[40];
    tel: string[40];
    fax: string[40];
    eMail: string[40];
    website: string[40];
  end;

const
  MaxDoubleWordCount = 30000;
  MaxVerlage = 1000;

type
  eSymbolTypes = (SYM_UNKNOWN, // "0" may occur if not initialized
    SYM_NOTENBLATT, // großes Notenblatt
    SYM_FILTERBUTTON, // Filter
    SYM_NOTIZ, // Ablage
    SYM_KORB, // Bestellkorb
    SYM_MININOTEN, // kleine Noten
    SYM_LED, // kleine LED auf Input Symbol
    SYM_INPUT, // Controll-Panel
    SYM_HILFE, // Hilfe
    SYM_AMOS, // Mode-Switch
    SYM_HEBU, // Mode-Switch
    SYM_SOUND, // Sound-Modul
    SYM_TRASH, // Müll-Eimer
    SYM_INTERNET, // InterNet
    SYM_JUBI);

  eLEDStatus = (LED_OFF, LED_GREEN, LED_RED, LED_ORANGE);

  eInsideArea = (INSIDE_UNKNOWN, INSIDE_DRAG, INSIDE_OTHER);

  eSoundState = (SS_DISABLED, SS_PLAY, SS_STOP);

  tPaintProc = procedure(DesktopIndex: word);

  tDesktopSymbol = record
    Symbolrect: TRect;
    SymbolType: eSymbolTypes; // Symbol-Typ
    SymbolDATA: integer; // Symbol-ID
    SymbolOffset: integer; // Symbol-ID-Offset
    DragArea: TRect; // Bereich für Object-Move
  end;

  tDeskTopSymbols = array [1 .. MaxDesktopSymbols] of tDesktopSymbol;

  tSymbolPosition = record
    SymbolName: string[35];
    Spos: TRect; // Source Pos
    OwnSize: TRect; // "self-Rect"
    BitMap: TBitMap;
  end;

  tLandRec = record
    LandName: string[35];
  end;

  tKomponistRec = record
    name: string[35];
  end;

  tArragerRec = record
    name: string[35];
  end;

  tVerlagRec = record
    name: string[35];
  end;

  tSerieRec = record
    name: string[35];
  end;

  tFoundArray = array [1 .. MaxFoundAnz] of integer;
  pFoundArray = ^tFoundArray;

  tverlage = array [0 .. pred(MaxVerlage)] of tVerlag;
  pverlage = ^tverlage;

const
  clpaper = $00808080;
  clShadow = $00E0E0E0;
  cNotenBlattXL: integer = 270;
  cNotenBlattYL: integer = 405;

  cNotenBlattSchadowOffsetX = 2;
  cImpossibleRect: array [0 .. 3] of integer = (0, 0, -1, -1);
  cUninstall: boolean = false;
  cDeleteRegistry: boolean = false;

  FeldNamenAnz = 8;
  cFelderNamen: array [1 .. FeldNamenAnz] of word = (39, 40, 41, 42, 43, 44, 45, 99);

var
  noten: tDataBaseRec; // aktueller Datensatz "notenblatt"

  // für die Händler-Version
  verlag: tVerlag; // aktueller Datensatz "verlagsadresse"
  VerlageArray: pverlage;
  VerlageAnz: integer;

  SystemPath: string; // CDROM:SYSTEM

  SuggestedWindowPosition: TPoint;

  // Persistent Registration Data
  FurtherVersion: string;
  SerialNumber: string;
  Password: string;
  Name1: string;
  Name2: string;
  strasse: string;
  PLZOrt: string;
  DesktopSetting: string;
  LastResolution: integer;
  MyResolutionStr: string;
  DesktopMode: integer;
  FirstInstallOfThisVersion: string;
  PasswordHaendler: string;
  BaseDate: string;
  OwnMedias: string;
  RegistrationKey: string;
  LastInterNetConnection: string;
  QuellPath: string;

  // Sprach-Treiber
  LanguageStr: TStringList;
  LanguageModes: TStringList;
  MusicMedias: TStringList;

  // InterNet-Update Programm Version
  Paramstr0: string;

  // läuft von "C:\"
  Crunner: boolean;

  // Boot-Sequence
  sBootSequence: TStringList;

function cOrgaMonCopyright: string;
function cAppName: string;
function i_c_DataBaseHost: string; // Host des firebird
function iMandant: string; // Markante Bezeichnung des Mandanten

function AddBackSlash(const s: string): string;
function RemoveBackSlash(const s: string): string;
procedure BeginHourGlass;
procedure EnsureHourGlass;
procedure EndHourGlass;
procedure EnsureDefaultCursor;

// Allgemeine String Utils
function bool2cO(b: boolean): string;
function RIDasStr(PERSON_R: integer): string; overload;
function RIDasStr(PERSON_R: TObject): string; overload;
function StrassePostalisch(s: string): string;
function OrtPostalisch(s: string): string;

// dynamische Pfade
function cAuftragErgebnisPath: string;
function cPersonPath(PERSON_R: integer): string;
function iOlapPath: string;
function iSystemOLAPPath: string;
function iPDFPathPublicShop: string;
function iPDFPathPublicApp: string;
function iLohnPath: string;
function iBaustellenPath: string;
function iSkriptePath: string;
function evalPath(iDataBaseName: string): string;
function lookLikePath(s: string): boolean;

// Diagnose/Test-FTP Zugang
function cFTP_Host : string;
function cFTP_UserName : string;
function cFTP_Password : string;

// Umsetzer, Platzhalter in Pfaden
procedure patchPath(var s: string);

// dynamische Parameter
function JonDaVorlauf: integer;

// Verschlüssellung
function enCrypt_Hex(s: string): string;
function deCrypt_Hex(s: string): string;
function ensureCrypt(s: string): string;

implementation

uses
  CareTakerClient,
  IniFiles, SysUtils,
{$IFNDEF CONSOLE}
  Dialogs,
  forms,
  MandantAuswahl,
{$ENDIF}
  math, Geld,
{$IFDEF FPC}

{$ELSE}
  IB_Session,
{$ENDIF}
  IdGlobal,
  DCPcrypt2, DCPblockciphers, DCPblowfish,
  SolidFTP,
  SimplePassword;

const
  RegistrySoftwareID = 'SOFTWARE';

  // TOOLS

function cOrgaMonCopyright: string;
begin
  result :=
   {} cApplicationName + cTradeMark +
   {} ' Rev ' + RevToStr(globals.Version) +
   {} ' ©1987-' + JahresZahl +
   {} ' https://wiki.orgamon.org/';
end;

function cAppName: string;
begin
  if isBeta then
    result := cApplicationName + cTradeMark + '-RC Rev. ' + RevToStr(globals.Version) + ' [' + iMandant + ']'
  else
    result := cApplicationName + cTradeMark + ' Rev. ' + RevToStr(globals.Version) + ' [' + iMandant + ']';
end;

function i_c_DataBaseHost: string;
var
  k: integer;
begin
  k := pred(pos(':', string(iDataBaseName)));
  if (k > 2) then
    // true server name like "aaron:..."
    result := copy(string(iDataBaseName), 1, k)
  else
    // windows-drive name like "C:\..."
    result := '';
end;

// Im OrgaMon müssen alle Pfadangaben mit einem Slash am Ende angegeben werden
// so wird die Unterscheidung zur Datei deutlich

function lookLikePath(s: string): boolean;
begin
  result := false;
  if length(s) > 1 then
    result := CharInset(s[length(s)], ['\', '/']);
end;

function iMandant: string;
var
  k: integer;
begin
  result := ValidatePathName(MyProgramPath);
  k := revpos('\', result);
  result := copy(result, succ(k), MaxInt);
end;

procedure patchPath(var s: string);
begin
  ersetze('{app}', ProgramFilesDir, s);
  ersetze('{exe}', MyApplicationPath, s);
  ersetze('{own}', EigeneOrgaMonDateienPfad, s);
  ersetze('{doc}', PersonalDataDir, s);
  ersetze('{org}', MyProgramPath, s);
  ersetze('\.\', '\', s);
end;

function evalPath(iDataBaseName: string): string;
begin
  result := iDataBaseName;
  patchPath(result);
end;

const
  LoadIniFCalled: boolean = false;
  OrgaMonIni: TMemIniFile = nil;
  BootStage: integer = 0;

procedure LoadIniF;
const
  cMaxMandanten = 20;
var
  n: integer;
  AllTheMandanten: TStringList;
  ParamWhatBase: string;
  cUpperBaseSettingParam: string;
  ChosenIndex: integer;
  sGroup: string;
  DataBaseName: string;

  procedure LogBootStage(Mandant: string);
  begin
    sBootSequence.Add(inttostr(BootStage) + '=' + Mandant);
    inc(BootStage);
  end;

begin

  // Die INI-Datei laden
  AllTheMandanten := TStringList.create;
  repeat

    if not(LoadIniFCalled) then
    begin
      StartDebug('check '+EigeneOrgaMonDateienPfad + cIniFName);
      if FileExists(EigeneOrgaMonDateienPfad + cIniFName) then
      begin
        if assigned(OrgaMonIni) then
          FreeAndNil(OrgaMonIni);
        sBootSequence.Add('load ' + EigeneOrgaMonDateienPfad + cIniFName);
        OrgaMonIni := TMemIniFile.create(EigeneOrgaMonDateienPfad + cIniFName);
        break;
      end;
    end;

    if assigned(OrgaMonIni) then
      FreeAndNil(OrgaMonIni);
    sBootSequence.Add('load ' + MyProgramPath + cIniFName);
    OrgaMonIni := TMemIniFile.create(MyProgramPath + cIniFName);
  until yet;
  LoadIniFCalled := true;

  // Den Namespace bestimmen
  repeat

    // 1. Rang "Spare"
    if isParam('-es') then
     if OrgaMonIni.ValueExists(cGroup_Id_Spare,cIniDataBaseName) then
     begin
       sGroup := cGroup_Id_Spare;
       break;
     end;

    // 2. Rang "Id"
    sGroup := getParam('Id');
    if OrgaMonIni.ValueExists(sGroup,cIniDataBaseName) then
      break;

    // 3. Rang "Default" = [System]
    sGroup := cGroup_Id_Default;

  until yet;
  sBootSequence.Add('Namespace=' + sGroup);


  try
    with OrgaMonIni do
    begin

      // User+Passwort
      iDataBaseUser := AnsiString(ReadString(sGroup, cIniDataBaseUser, 'SYSDBA'));
      iDataBasePassword :=
       ensureCrypt(AnsiString(ReadString(sGroup, cIniDataBasePwd, 'masterkey')));
      //
      iDataBaseHost := AnsiString(ReadString(sGroup, cIniDataBaseHost, ''));

      // erster Datenbankname ermitteln
      repeat

        iDataBaseName := AnsiString(ReadString(sGroup, cIniDataBaseName, ''));
        if (iDataBaseName <> '') then
          break;

        iDataBaseName := AnsiString(ReadString(sGroup, cIniDataBaseName + '1', ''));
        if (iDataBaseName <> '') then
          break;

        if (sGroup = cGroup_Id_Spare) then
          sGroup := cGroup_Id_Default
        else
          break;

      until eternity;

      iDataBaseName := evalPath(iDataBaseName);

      // weitere Datenbanknamen
      AllTheMandanten.Add(iDataBaseName);
      for n := 2 to cMaxMandanten do
        AllTheMandanten.Add(ReadString(sGroup, cIniDataBaseName + inttostr(n), ''));
      for n := pred(AllTheMandanten.count) downto 1 do
        if (AllTheMandanten[n] = '') then
        begin
          AllTheMandanten.delete(n)
        end
        else
        begin
          DataBaseName := evalPath(AllTheMandanten[n]);
          AllTheMandanten[n] := DataBaseName;
        end;

      // ist in der Kommandozeile etwas angegeben?
      cUpperBaseSettingParam := AnsiUpperCase(cIniDataBaseName);
      for n := 1 to ParamCount do
      begin
        ParamWhatBase := AnsiUpperCase(ParamStr(n));
        if pos(cUpperBaseSettingParam, ParamWhatBase) = 1 then
        begin
          ChosenIndex := strtointdef(nextp(ParamWhatBase, cUpperBaseSettingParam, 1), 1);
          if (ChosenIndex <= AllTheMandanten.count) then
          begin
            iDataBaseName := AllTheMandanten[pred(ChosenIndex)];
            AllTheMandanten.clear;
            break;
          end;
        end;
      end;

      // einen manuell Auswählen
      if (AllTheMandanten.count > 1) then
      begin
        // FormMandantAuswahl := TFormMandantAuswahl.create(Application);
        // Application.initialize;
        StartDebug('MandantAuswahl');
{$IFNDEF CONSOLE}
{$IFDEF fpc}
        LogBootStage(AllTheMandanten[0]);
        iDataBaseName := AllTheMandanten[0];
      //  iDataBasePassword := ensureCrypt(ReadString(sGroup, cDataBasePwd + inttostr(1), iDataBasePassword));

{$ELSE}
        FormMandantAuswahl := TFormMandantAuswahl.create(nil);
        with FormMandantAuswahl do
        begin
          listbox1.items.assign(AllTheMandanten);
          listbox1.itemindex := 0;
          ShowModal;
          if (Mandant = '') then
          begin
            halt;
          end
          else
          begin
            LogBootStage(Mandant);
            iDataBaseName := Mandant;
            iDataBasePassword :=
             ensureCrypt(ReadString(sGroup, cIniDataBasePwd + inttostr(succ(Index)), iDataBasePassword));
          end;
        end;
        FreeAndNil(FormMandantAuswahl);
{$ENDIF}
{$ENDIF}
      end;

      // Datenbankname muss einen Wert haben!
      if (iDataBaseName = '') then
      begin
{$IFNDEF CONSOLE}
        ShowMessage(
{$ELSE}
        writeln(
{$ENDIF}
          { } 'ERROR: Die Datei ' + #13#10 + #13#10 +
          { } MyProgramPath + cIniFName + #13#10 + #13#10 +
          { } '[' + sGroup + ']' + #13#10 +
          { } cIniDataBaseName + '=' + #13#10 + #13#10 +
          { } ' notwendige Einstellung ist ohne Wert!');
{$IFDEF CONSOLE}
  sleep(2000);
{$ENDIF}
        halt;
      end
      else
      begin
        LogBootStage(iDataBaseName);
      end;

      // auf den nächsten verweisen, im Fall, dass kein Server angegeben ist.
      if (i_c_DataBaseHost = '') and lookLikePath(iDataBaseName) then
      begin

        if DirExists(iDataBaseName) then
        begin
          MyProgramPath := iDataBaseName;

          if FileExists(iDataBaseName + cIniFName) then
            LoadIniF;

        end
        else
        begin
{$IFNDEF CONSOLE}
          ShowMessage(
{$ELSE}
          writeln(
{$ENDIF}
            'ERROR: Das Verzeichnis' + #13#10 + #13#10 + iDataBaseName + #13#10 + #13#10 +
            'existiert nicht oder ist zur Zeit nicht verfügbar!');
          halt;

        end;
      end;

      //

    end;
  except

  end;
  AllTheMandanten.free;
  if assigned(OrgaMonIni) then
    FreeAndNil(OrgaMonIni);
end;

function AddBackSlash(const s: string): string;
begin
  if (length(s) > 0) then
  begin
    if (s[length(s)] <> '\') then
      result := s + '\'
    else
      result := s;
  end
  else
  begin
    result := s;
  end;
end;

function RemoveBackSlash(const s: string): string;
begin
  if (length(s) > 0) then
  begin
    if (s[length(s)] = '\') or (s[length(s)] = '/') then
      result := copy(s, 1, pred(length(s)))
    else
      result := s;
  end
  else
  begin
    result := s;
  end;
end;

function iPDFPathPublicShop: string;
var
  k: integer;
begin
  result := RemoveBackSlash(iPDFPathShop);
  k := max(revpos('\', result), revpos('/', result));
  result := copy(result, 1, k);
end;

var
  _iPDFPathPublicApp: string = '';

function iPDFPathPublicApp: string;
// das letzte Verzeichnis wird abgeschnitten
var
  k: integer;
begin
  if (_iPDFPathPublicApp = '') then
  begin
    _iPDFPathPublicApp := RemoveBackSlash(iPDFPathApp);
    k := max(revpos('\', _iPDFPathPublicApp), revpos('/', _iPDFPathPublicApp));
    _iPDFPathPublicApp := copy(_iPDFPathPublicApp, 1, k);
  end;
  result := _iPDFPathPublicApp;
end;

function iSystemOLAPPath: string;
begin
  result := MyProgramPath + 'OLAP\'
end;

var
 _iOlapPath : string = '';

function iOlapPath: string;
begin
 if (_iOlapPath='') then
 begin
    if iOLAPpublic then
      _iOlapPath := iSystemOLAPPath
    else
    begin
      _iOlapPath := EigeneOrgaMonDateienPfad + 'OLAP\';
      CheckCreateDir(_iOlapPath);
    end;
 end;
 result := _iOlapPath;
end;

procedure BeginHourGlass;
begin
  if (HourGlassLevel = 0) then
  begin
{$IFNDEF CONSOLE}
    screen.cursor := crHourGlass;
    Application.ProcessMessages;
{$ENDIF}
  end;
  inc(HourGlassLevel);
end;

procedure EnsureHourGlass;
begin
{$IFNDEF CONSOLE}
  if (HourGlassLevel > 0) then
    screen.cursor := crHourGlass
  else
    screen.cursor := crdefault;
{$ENDIF}
end;

procedure EndHourGlass;
begin
  dec(HourGlassLevel);
{$IFNDEF CONSOLE}
  if HourGlassLevel = 0 then
    screen.cursor := crdefault;
{$ENDIF}
end;

procedure EnsureDefaultCursor;
begin
  HourGlassLevel := 0;
{$IFNDEF CONSOLE}
  screen.cursor := crdefault;
{$ENDIF}
end;

function bool2cO(b: boolean): string;
begin
  if b then
    result := cIni_Activate
  else
    result := cIni_Deactivate;
end;

function RIDasStr(PERSON_R: integer): string;
begin
  result := inttostrN(PERSON_R, 10);
end;

function RIDasStr(PERSON_R: TObject): string;
begin
  result := RIDasStr(PtrUInt(PERSON_R));
end;

function cPersonPath(PERSON_R: integer): string;
begin
  result := MyProgramPath + cRechnungPath + RIDasStr(PERSON_R) + '\';
end;

const
  AuftragErgebnis_path_called_once: boolean = false;

function cAuftragErgebnisPath: string;
begin
  result := MyProgramPath + 'SAP\';
  if not(AuftragErgebnis_path_called_once) then
  begin
    AuftragErgebnis_path_called_once := true;
    CheckCreateDir(result);
  end;
end;

const
  LohnPath_called_once: boolean = false;

function iLohnPath: string;
begin
  result := MyProgramPath + 'Lohn\';
  if not(LohnPath_called_once) then
  begin
    LohnPath_called_once := true;
    CheckCreateDir(result);
  end;
end;

const
  BaustellenPath_called_once: boolean = false;
  BaustellenPath_result: string = '';

function iBaustellenPath: string;
begin
  if not(BaustellenPath_called_once) then
  begin
    if (iBaustellenPfad = '') then
      BaustellenPath_result := MyProgramPath + 'Baustellen\'
    else
      BaustellenPath_result := iBaustellenPfad;
    CheckCreateDir(BaustellenPath_result);
    BaustellenPath_called_once := true;
  end;
  result := BaustellenPath_result;
end;

const
  SkriptePath_called_once: boolean = false;
  SkriptePath_result: string = '';

function iSkriptePath: string;
begin
  if not(SkriptePath_called_once) then
  begin
    SkriptePath_result := MyProgramPath + 'Skripte\';
    CheckCreateDir(SkriptePath_result);
    SkriptePath_called_once := true;
  end;
  result := SkriptePath_result;
end;

const
  JonDaVorlauf_Date: TAnfixDate = 0;
  JonDaVorlauf_Result: integer = 0;

function JonDaVorlauf: integer;
var
  NextDate: TAnfixDate;
begin
  if (DateGet <> JonDaVorlauf_Date) then
  begin
    JonDaVorlauf_Date := DateGet;
    NextDate := WerktagDatePlus(JonDaVorlauf_Date, iJonDaVorlauf);
    JonDaVorlauf_Result := DateDiff(JonDaVorlauf_Date, NextDate);
  end;
  result := JonDaVorlauf_Result;
end;

function GetFBClientLibName: string;
begin
  // kann erst wieder geändert werden, sobald
  // wir von den "Interbase Admin" Komponenten
  // wegkommen, die ja eh die gds32.dll laden.
  // Die Situation will ich vermeiden, dass die
  // fbclient.dll UND die gds32.dll vom OrgaMon
  // geladen werden. Ev. mal auf die zeos Komponenten
  // umstellen!
  result := MyProgramPath + 'gds32.dll';
end;

function StrassePostalisch(s: string): string;
begin
  result :=
  { } noDoubleBlank(
    { } nextp(
    { } nextp(
    { } StrFilter(
    { } s, '!?', true),
    { } '@', 0), '#', 0));
end;

function OrtPostalisch(s: string): string;
begin
  result := nextp(
    { } StrFilter(
    { } s, '!?', true),
    { } '@', 0)
end;

const
  DCP_blowfish1: TDCP_Blowfish = nil;
  CryptKeyLength: integer = 0;
  CryptKey: array [0 .. 1023] of AnsiChar = 'anfisoft' + cApplicationName;

procedure Crypt_Init;
begin
  // Verschlüsselungs Namespace
  CryptKeyLength := StrLen(CryptKey) * 8;
  DCP_blowfish1 := TDCP_Blowfish.Create(nil);
end;

function deCrypt_Hex(s: string): string;
begin
  if not(assigned(DCP_blowfish1)) then
    Crypt_Init;
  with DCP_blowfish1 do
  begin
    Init(CryptKey, CryptKeyLength, nil);
    result := cutrblank(decryptstring(hexstr2bin(s)));
  end;
end;

function enCrypt_Hex(s: string): string;
begin
  if not(assigned(DCP_blowfish1)) then
    Crypt_Init;
  with DCP_blowfish1 do
  begin
    Init(CryptKey, CryptKeyLength, nil);
    result := bin2hexstr(encryptstring(s + fill(' ', 16 - length(s))));
  end;
end;

function ensureCrypt(s: string): string;
begin
  if (length(s)=48) then
   result := s
  else
   result := enCrypt_Hex(s);
end;

function cFTP_Host : string;
begin
  result := nextp(iDiagnoseFTP, ';', 0);
  if (result='') then
    result := 'ftp.orgamon.net';
end;

function cFTP_UserName : string;
begin
  result := nextp(iDiagnoseFTP, ';', 1);
  if (result='') then
    result := 'incoming';
end;

function cFTP_Password : string;
begin
 result := nextp(iDiagnoseFTP, ';', 2);
 if (result='') then
   result := '1kfan8wx5';
end;

initialization
{$IFNDEF CONSOLE}
  Application.Title := cApplicationName;
{$ENDIF}
StartDebug('globals');
{$IFNDEF FPC}
{$ifdef IBO_OLD}
 IB_GetClientLibNameFunc := GetFBClientLibName;
{$endif}
{$ENDIF}
// i8n

DebugMode := false;
isBeta :=
{ } isParam('-b') or
{ } (pos(inttostr(RevAsInteger(globals.Version)), ParamStr(0)) > 0) or
{ } (pos('-RC.exe', ParamStr(0)) > 0);

iProfilTexte := TStringList.create;
iSchalterTexte := TStringList.create;
LanguageStr := TStringList.create;
LanguageModes := TStringList.create;
MusicMedias := TStringList.create;
sBootSequence := TStringList.create;

// OrgaMon
MyApplicationPath := ExtractFilePath(ParamStr(0));
MyProgramPath := MyApplicationPath;
EigeneOrgaMonDateienPfad := PersonalDataDir + cApplicationName + '\';

// Namespace;Bad;Color;Priorität

sSperre_Wert_Baustelle := TStringList.create;
sSperre_Wert_Person := TStringList.create;
sSperre_Wert_Arbeit := TStringList.create;
sSperre_Wert_Baustopp := TStringList.create;
sSperre_Wert_Zuordnung := TStringList.create;

StartDebug(MyProgramPath);
LoadIniF;

StartDebug(iDataBaseName);
StartDebug(MyProgramPath);

//
DiagnosePath := MyProgramPath + 'Diagnose\';
SolidFTP.SolidFTP_LogDir := DiagnosePath;
anfix.DebugLogPath := DiagnosePath;

WebDir := MyProgramPath + 'Web Veröffentlichung\';
SearchDir := MyProgramPath + 'SuchIndex\';
CDRAusgabe := MyProgramPath + 'CD-R\Noten\';
AnwenderPath := MyProgramPath + 'Anwender\' + UserName + '\';
ETFLager := MyProgramPath + 'Creator\Zwischenlager\';
DatensicherungPath := MyProgramPath + 'Datensicherung\';
SoundPath := MyProgramPath + 'Sounds\';
SystemPath := MyProgramPath + 'System';
Geld.iSystemPath := SystemPath;
UpdatePath := MyProgramPath + 'Updates\';
WordPath := MyProgramPath + 'Word\';
ProtokollePath := MyProgramPath + 'Protokolle\';
{$ifndef CONSOLE}
 ContextPath := ApplicationDataDir + cApplicationName + '\Context\' + iMandant + '\';
{$endif}
MDEPath := MyProgramPath + 'MonDa\';
HtmlVorlagenPath := MyProgramPath + cHTMLTemplatesDir;
AuftragMobilServerPath := MyProgramPath + 'MonDaServer\';
WebPath := MyProgramPath + 'Intranet\';
SchemaPath := MyProgramPath + 'Schemen\';
RohstoffePath := MyProgramPath + 'Rohstoffe\';
ImportePath := MyProgramPath + 'Importe\';
//cCareTakerDiagnosePath := MyProgramPath + 'CareTaker\';
KassePath := MyProgramPath + 'Kasse\';

StartDebug('CheckCreate.begin');

CheckCreateDir(AnwenderPath); // Username dependency

{$IFNDEF CONSOLE}
CheckCreateDir(ContextPath); // local Filesystem
CheckCreateDir(WebPath);
CheckCreateDir(ProtokollePath);
CheckCreateDir(MyProgramPath + 'Musik');
CheckCreateDir(MyProgramPath + 'System');
CheckCreateDir(MyProgramPath + 'Noten');
CheckCreateDir(MyProgramPath + 'Creator');
CheckCreateDir(UpdatePath);
CheckCreateDir(ETFLager);
CheckCreateDir(MyProgramPath + 'Mailing');
CheckCreateDir(MyProgramPath + 'CD-R\Noten');
CheckCreateDir(MyProgramPath + 'CD-R\System');
CheckCreateDir(MyProgramPath + 'GermanParcel');
CheckCreateDir(MyProgramPath + cRechnungsKopiePath);
CheckCreateDir(MyProgramPath + 'Bestellungskopie');
CheckCreateDir(HtmlVorlagenPath);
CheckCreateDir(MyProgramPath + cHTMLBlocksDir);
CheckCreateDir(DiagnosePath);
CheckCreateDir(WebDir);
CheckCreateDir(SearchDir);
CheckCreateDir(CDRAusgabe);
{$ENDIF}
StartDebug('CheckCreate.end');

finalization

LanguageStr.free;
LanguageModes.free;
MusicMedias.free;
iProfilTexte.free;
iSchalterTexte.free;
sBootSequence.free;
if assigned(OrgaMonIni) then
  FreeAndNil(OrgaMonIni);

end.
