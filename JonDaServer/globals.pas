{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2015  Andreas Filsinger
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
  |    http://orgamon.org/
  |
}
unit globals;

interface

uses
  anfix32;

const
  cApplicationName = 'JonDaServer';
  version: single = 2.218; // ..\rev\JonDaServer.rev.txt

  // Typische Client-Programmversionen
  cVersion_JonDa: single = 1.118;
  cVersion_OrgaMonApp: single = 2.000;

  // Mindest-Anforderungen
  cMinVersion_OrgaMonApp: single = 2.026;

  NoTimer: boolean = false;
  AllSystemsRunning: boolean = true;
  cERROR_TAN = '00000';
  MyProgramPath: string = '';
  MyApplicationPath: string = '';
  DiagnosePath: string = '';
  cProtokollTrenner = '|';
  cJondaProtokollDelimiter = '~';
  cProtPrefix = 'PROT';
  cProtExtension = '.TXT';
  cZIPExtension = '.ZIP';
  cDATExtension = '.DAT';
  cUTF8DataExtension = '.utf-8.txt';

  // ini-Sachen
  cTrnFName = 'Transaktionsnummer.ini';
  cIniFName = cApplicationName + '.ini';
  cDataBaseName = 'DatabaseName';
  cFirstTrn = '10000';
  cIni_Activate = 'JA';
  cIni_Deactivate = 'NEIN';
  cRID_FirstValid = 1;
  cRID_Suchspalte = 'ReferenzIdentitaet';

  //
  cCRLF = #13#10;

  // Daten-Verzeichnisse
  cServerDataPath = 'Daten\';
  cOrgaMonDataPath = 'OrgaMon\';
  cMeldungPath = 'Meldung\';
  cStatistikPath = 'Statistik\';
  cUpdatePath = 'Update\'; // depreciated since 2.000 migrate to cProtokollPath
  cProtokollPath = 'Protokolle\';
  cGeraeteEinstellungen = 'Einstellungen\';
  cGeraeteKommandos = 'Kommandos\';
  cFotoPath = 'Fotos\';
  cDBPath = 'db\';
  cSyncPath = 'sync\';
  cWebPath = '..\web\';

  cMonDaServer_AbgearbeitetFName = 'abgearbeitet.dat';
  cMonDaServer_AbgezogenFName = 'abgezogen.%s.dat';
  cMonDaServer_UnberuecksichtigtFName = 'unberuecksichtigt.txt';
  cMonDaServer_Baustelle = 'baustelle.csv';
  cMonDaServer_Baustelle_manuell = 'baustelle-manuell.csv';
  cFotoUmbenennungAusstehend = 'FotoService-Umbenennung-Ausstehend.csv';

  cJonDaServer_LogFName = cApplicationName + '.log';
  cJonDaServer_XMLRPCLogFName = 'XMLRPC.log';
  HourGlassLevel: integer = 0;

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

  // Systemparameter
  iJonDa_FTPHost: string = '';
  iJonDa_FTPUserName: string = '';
  iJonDa_FTPPassword: string = '';
  iJonDa_Port: integer = 0;

  // Globale FTP - Sachen
  iFTPProxyHost: string = '';
  iFTPProxyPort: integer = 0;
  cGeraetSchema = '  ??.??.?? ??:??:?? ?????:???';

  EigeneOrgaMonDateienPfad: string = '';

  // Eingabe.nnn.txt
  cHeader_Eingabe = 'DATUM;UHRZEIT;RID;ZAEHLER_NUMMER_ALT;ZAEHLER_NUMMER_NEU;PRAEFIX';
  cHeader_UmbenennungUnvollstaendig =
    'DATEINAME_ORIGINAL;DATEINAME_AKTUELL;RID;GERAETENO;BAUSTELLE;MOMENT';

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
  cJonDa_ErgebnisMaske_deprecated = '?????' + cDATExtension;
  cJonDa_ErgebnisMaske_utf8 = '?????' + cUTF8DataExtension;
  cE_ZIPPASSWORD = 'ZipPasswort';
  cE_FTPPASSWORD = 'FTPPasswort';
  cE_FTPUSER = 'FTPBenutzer';
  cE_FTPHOST = 'FTPServer';
  cE_FTPVerzeichnis = 'FTPVerzeichnis';
  cE_VERZEICHNIS = 'Verzeichnis';
  cE_ZusaetzlicheZips = 'ZusätzlicheZips';
  cE_BAUSTELLE_R = 'BAUSTELLE_R';
  cE_EXPORT_TAN = 'EXPORT_TAN';
  cE_Praefix = 'ZipPräfix';
  cE_Postfix = 'ZipPostfix'; // ".unmoeglich" oder ""
  cE_SAPQUELLE = 'FreieZähler';
  cE_SAPReihenfolge = 'SpaltenReihenfolge';
  cE_SpaltenAlias = 'SpaltenAlias';
  cE_SpaltenOhneInhalt = 'SpaltenOhneInhalt';
  cE_XLSVorlage = 'XLSVorlage';
  cE_MaxperLoad = 'MaxAnzahl';
  cE_MaterialNummerAlt = 'MaterialNummerAlt';
  cE_MaterialNummerNeu = 'MaterialNummerNeu';
  cE_Zaehlwerk = 'Zählwerk';
  cE_ZaehlwerkNeu = 'ZaehlwerksnummerNeu';
  cE_AuchAlsCSV = 'AuchAlsCSV';
  cE_AuchAlsXML = 'AuchAlsXML';
  cE_AuchAlsXLS = 'AuchAlsXLS';
  cE_AuchAlsXLSunmoeglich = 'AuchAlsXLS_Unmöglich';
  cE_AuchAlsKK22 = 'AuchAlsKK22';
  cE_AuchAlsARGOS = 'AuchAlsARGOS';
  cE_OhneStandardXLS = 'OhneStandardXLS';
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
  cE_FotoZiel = 'FotoZiel'; // default ~BaustellenPfad~ Fotos
  cE_FotoAblage = 'FotoAblage'; // default -ohne- Ablage
  cE_FotosLaden = 'FotosLaden';
  cE_FotosMaxAnzahl = 'FotosMaxAnzahl'; // Maximale Anzahl Bilder im ZIP
  cE_FotoBenennung = 'FotoBenennung'; // Art der Bilder Namensgebung
  cE_CoreFTP = 'CoreFTP'; // Besonderer Upload über Core-FTP
  cE_AuchMitFoto = 'AuchMitFoto'; // wenn Fotos mit in das Zip sollen
  cE_SpalteAlsText = 'SpalteAlsText'; // bei der Ausgabe an Excel wichtig

type
  // soll in Zukunft nur noch eine interne Datenstruktur sein ...
  TZaehlerNummerType = string[cMonDa_FieldLength_ZaehlerNummer];

  TMDERec = packed record

    { von GaZMa }
    RID: longint;
    Baustelle: string[6]; { wird auch f�r die Ger�tenummer verwendet }
    ABNummer: string[5];
    Monteur: string[6];
    Art: string[2];
    zaehlernummer_alt: TZaehlerNummerType;
    Reglernummer_alt: TZaehlerNummerType;
    ausfuehren_soll: TAnfixDate;
    vormittags: boolean;
    Monteur_Info: string[255];
    Zaehler_Info: string[255]; { auch Plausibilit�tsfelder }
    Zaehler_Name1: string[35];
    Zaehler_Name2: string[35];
    Zaehler_Strasse: string[35];
    Zaehler_Ort: string[35];

    { von Monda }
    zaehlernummer_korr: TZaehlerNummerType;
    zaehlernummer_neu: TZaehlerNummerType;
    zaehlerstand_neu: string[8];
    zaehlerstand_alt: string[8];
    Reglernummer_korr: TZaehlerNummerType;
    Reglernummer_neu: TZaehlerNummerType;
    ProtokollInfo: string[255];

    { von Monda intern }
    { <0: Sonderstati, Bedeutung siehe obige Konstanten }
    { 00: Unerledigt }
    { >0: Erledigt }
    ausfuehren_ist_datum: TAnfixDate; { Tr�ger von cMonDa_Status }
    ausfuehren_ist_uhr: TAnfixTime;

  end;

  // RID;Z#A-Korrektur;Z#N;ZSN;ZSA;R#-Korrektur;R#-Neu;Protokoll;Datum-Ist;Uhr-Ist

function StrassePostalisch(s: string): string;
function OrtPostalisch(s: string): string;
function cCopyright: string;

implementation

uses
  inifiles, classes, Sysutils;

const
  LoadIniFCalled: boolean = false;

function cCopyright: string;
begin
  result := cApplicationName + '™ Rev ' + RevToStr(globals.version) + ' ©1987-' + JahresZahl +
    ' http://www.orgamon.org';
end;

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
  iDataBaseName: string;
  MyIni: TIniFile;

  function iServerName: string;
  var
    k: integer;
  begin
    k := pred(pos(':', iDataBaseName));
    if (k > 2) then
      // true server Name "aaron:..."
      result := copy(iDataBaseName, 1, k)
    else
      // Drive Name like "C:\..."
      result := '';
  end;

begin

  // Enable Spare
  if isParam('-es') then
    sGroup := 'Spare'
  else
  begin
    // --Id=Kundenkennung
    sGroup := getParam('Id');
    if (sGroup = '') then
      sGroup := 'System';
  end;

  //
  AllTheMandanten := TStringList.create;
  repeat

    if not(LoadIniFCalled) then
      if FileExists(EigeneOrgaMonDateienPfad + cIniFName) then
      begin
        MyIni := TIniFile.create(EigeneOrgaMonDateienPfad + cIniFName);
        break;
      end;

    MyIni := TIniFile.create(MyProgramPath + cIniFName);
  until true;
  LoadIniFCalled := true;

  try
    with MyIni do
    begin

      // erster Datenbankname ermitteln
      iDataBaseName := ReadString(sGroup, cDataBaseName, '');
      if (iDataBaseName = '') then
        iDataBaseName := ReadString(sGroup, cDataBaseName + '1', '');

      ersetze('{app}', ProgramFilesDir, iDataBaseName);
      ersetze('{exe}', MyApplicationPath, iDataBaseName);
      ersetze('{own}', EigeneOrgaMonDateienPfad, iDataBaseName);

      // weitere Datenbanknamen
      AllTheMandanten.add(iDataBaseName);
      for n := 2 to cMaxMandanten do
        AllTheMandanten.add(ReadString(sGroup, cDataBaseName + inttostr(n), ''));
      for n := pred(AllTheMandanten.count) downto 1 do
        if (AllTheMandanten[n] = '') then
          AllTheMandanten.delete(n);

      // ist in der Kommandozeile etwas angegeben?
      cUpperBaseSettingParam := AnsiUpperCase(cDataBaseName);
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

      if (iDataBaseName <> '') then
      begin
        // auf den nächsten verweisen, im Fall, dass kein Server angegeben ist.
        MyProgramPath := iDataBaseName;
        if FileExists(iDataBaseName + cIniFName) then
        begin
          LoadIniF;
        end;
      end;

    end;
  except

  end;
  AllTheMandanten.free;
  MyIni.free;
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

begin
  // OrgaMon
  MyApplicationPath := ExtractFilePath(ParamStr(0));
  MyProgramPath := MyApplicationPath;
  EigeneOrgaMonDateienPfad := PersonalDataDir + cApplicationName + '\';
  LoadIniF;

end.
