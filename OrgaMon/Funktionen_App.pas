{
  |������___                  __  __
  |�����/ _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |����| | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |����| |_| | | | (_| | (_| | |  | | (_) | | | |
  |�����\___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |���������������|___/
  |
  |    Copyright (C) 2007 - 2020  Andreas Filsinger
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
unit Funktionen_App;

interface

uses
{$IFNDEF linux}

{$ENDIF}
{$IFDEF fpc}
  lazUTF8Classes,
{$ENDIF}
  // System
  classes, Sysutils,
  math,
{$IFDEF FPC}
  fpImage, FPReadJPEG, Graphics,
{$ELSE}
  jpeg, ImageHlp,
{$ENDIF}

  // Tools
  anfix32, CareTakerClient, WordIndex, c7zip,
  gplists, Foto, SolidFTP,

  // OrgaMon
  globals;

const
  // F�r ungesetzte Daten-Bank RIDs
  cRID_Null = -1;

  // Foto - Beobachtungszeitraum:
  // ============================
  // Innerhalb dieses Zeitraumes m�ssen JonDa-Eingabe und Foto-Aufnahme
  // abgeglichen sein, sp�ter vergisst der Server die Eingabe Liste.
  // Die Eingabe.nnn.txt wird automatisch dementsprechend gek�rzt
  cMaxAge_Foto = 32; // [Tage] Solange bleiben Eingaben gesichert

  // Foto - Umbenennen:
  // ==================
  // Innerhalb dieses Zeitraumes m�ssen Informationen nachgeliefert
  // werden, um "Neu" Umbenennungen abzuschliessen.
  // Die cFotoUmbenennungAusstehend wird automatisch dementsprechend gek�rzt
  cMaxAge_Umbenennen = 10; // [Tage] Solange bleiben die Ausstehenden in der Liste

  // Verzeichnisse ./dat/nnnnn:
  // ==========================
  // Nach dieser Zeit werden die Verzeichnise und weitere Rand-Daten
  // in die Datensicherung verschoben
  cMaxAge_Produktive_Sichtbarkeit = 50;

  // Verzeichnis ./log/*
  // ==========================
  // Nach dieser Zeit werden die Dateien des Diagnose-Verzeichnisses
  // in die Datensicherung verschoben
  cMaxAge_log_Sichtbarkeit = 90;

  // Monteur-Individuelle Optionen
  cServerOption_ZeitPruefung = 'ZEIT_PR�FUNG';
  cServerOption_JonDaOptionen = 'OPTIONEN';
  cServerOption_EinfacheListe = 'EinfacheListe';
  cServerOption_ProtokollPfad = 'ProtokollPfad';

  // Transaktionen des FotoServers
  cFTRN_timestamp = 'timestamp'; // No Operation, just report date and time
  cFTRN_copy = 'cp'; // copy a File
  cFTRN_move = 'mv'; // move a File
  cFTRN_touch = 'touch'; // set date and time of a file

const
  // Namens-konvention Bild: Ger�t-RID-ProtokollParameter.jpg

  // INPUT
  // =====

  // Benennung=1 .. 12 (0 = default)
  cParameter_foto_Modus = 'MODUS';

  // bisheriger Bildparameter "FA", "FN"
  cParameter_foto_parameter = 'PARAMETER';

  // Kurzform der Baustellen Bez "KARL"
  cParameter_foto_baustelle = 'NUMMERN_PREFIX';
  cParameter_foto_strasse = 'STRASSE'; //
  cParameter_foto_ort = 'ORT'; //
  cParameter_foto_zaehler_info = 'ZAEHLER_INFO';
  cParameter_foto_RID = 'RID';
  cParameter_foto_ART = 'ART';
  cParameter_foto_Zaehlernummer_alt = 'ZAEHLERNUMMER_ALT';
  cParameter_foto_Zaehlernummer_neu = 'ZAEHLERNUMMER_NEU';
  cParameter_foto_Reglernummer_Neu = 'REGLERNUMMER_NEU';
  cParameter_foto_ABNummer = 'ABNUMMER'; // Auftragsnummer
  cParameter_foto_geraet = 'GERAET'; // 3-stellige Ger�tenummer
  cParameter_foto_Pfad = 'PFAD'; // Wurzel-Pfad der Baustellen-Unterverzeichnisse
  cParameter_foto_Optionen = 'OPTIONEN'; // Verarbeitungs-Optionen

  cFoto_Option_NeuLeer = '-Neu'; // Bewirkt dass die Z�hlernummer Neu leer sein soll!
  cFoto_FName_ValidChars = cValidFNameChars + '_+#()[]{}!$%&,;=~';

  // INPUT OPTIONAL
  // =====

  cParameter_foto_Datei = 'DATEI'; // Bisheriger Dateiname des Fotos (incl. Pfad)

  // OUTPUT
  // =====

  cParameter_foto_Fehler = 'ERROR'; // Meldung �ber etwaige Fehler
  cParameter_foto_neu = 'NAME_NEU'; // Umbenannter Dateiname - ohne Pfad

  cParameter_foto_fertig = 'ENDGUELTIG'; // Ja/Nein ob genug Infos vorliegen
  cParameter_foto_ziel = 'BAUSTELLE_NEU'; // Kurzform der Baustellen Bez "Ziel"
  cParameter_foto_definition_csv = 'DEFINITIONS_CSV'; // Im Modes 6 wird eine csv-Datei, zu Rate gezogen, welche?
  cParameter_foto_definition_version = 'DEFINITIONS_REV'; // Im Modus 6 wird eine csv-Datei zu Rate gezogen, welche Rev?


  // Warte Zeiten [min]
  cKikstart_delay = 10;

  // Anzahl der Stellen verschiedener Ablagesysteme
  cAnzahlStellen_Transaktionszaehler = 5;
  cAnzahlStellen_FotosTagwerk = 4;

  // static Filenames
  cFotoLogFName = 'FotoService'+cLogExtension;
  cFotoTransaktionenFName = 'FotoService-Transaktionen'+cLogExtension;
  cProtokollTransaktionenFName = 'ProtokollService-Transaktionen'+cLogExtension;
  cFotoAblageFName = 'FotoService-Ablage-%s'+cLogExtension;
  cFotoService_Pause = 'pause.txt';
  cAppService_Proceed = 'proceed.txt';
  cIsAblageMarkerFile = 'ampel-horizontal.gif' deprecated 'Alte Ablage!';
  cIsAblageMarkerFName = 'ampel.gif';
  cFotoService_AbortTag = 'FATAL';
  cLICENCE_FName = 'IMEI.csv';
  cIMEI_OK_FName = 'IMEI-OK.csv';

type
  TOrgaMonApp_TMoreInfo = function(RID: integer; FotoGeraeteNo: string): string of object;

  TOrgaMonApp = class(TObject)

  private
    //
    TabCounter: integer;
    sSendenLog: TStringList;

  public

    // Ini-Sachen

    // bisher fix 'W:\JonDaServer\' jetzt Anwendungsverzeichnis,
    // Endpunkt der ini-Kette, Home von cOrgaMon.ini,
    // in der Regel=pAppServicePath
    // ./dat/
    pAppServicePath: string;

    // bisher fix 'I:\KundenDaten\JonDaServer\' jetzt Parameter "BackupPath"
    // direkt dorthinein nichts sichern, es gibt ".\#nnn" Unterverzeichnisse,
    // ACHTUNG: Benutze "BackupDir" zu sichern und NICHT dieses Root-Verzeichnis aller Backups
    // ./bak/
    pBackUpRootPath: string;

    // bisher fix 'W:\status\' jetzt Parameter "WebPath"
    // default= ./web/
    pWebPath: string;

    // bisher fix 'W:\orgamon-mob\' jetzt Parameter "FTPPath"
    // ./ftp/
    pFTPPath: string;

    // XMLRPC-Server f�r "Senden"
    pXMLRPC_Host: string;
    pXMLRPC_Port: Integer;

    // Sind wir im Consolen Modus?
    Option_Console: boolean;

    // heutiges Sicherungsverzeichnis
    // z.B. "./bak/#053/"
    BackupDir: string;

    // Statistik und Infos
    Stat_Unmoeglich: integer;
    Stat_Vorgezogen: integer;
    Stat_NeuAnschreiben: integer;
    Stat_Restanten: integer;
    Stat_Unbearbeitet: integer;
    Stat_Abgearbeitete: integer;
    Stat_Meldungen: integer; // Meldungen an OrgaMon
    Stat_SelbstAnlagen: integer;
    Stat_AutoRestant: integer;
    Stat_MondaNeu: integer;
    Stat_MondaStay: integer;
    Stat_FallBack: integer;
    Stat_Bisher: integer;
    Stat_FrischFertig: integer;
    Stat_Schlafmuetzen: integer;
    Stat_OrgaMonGruen: integer; // die Abgearbeiteten des OrgaMon
    Stat_OrgaMonPending: integer;
    Stat_PostError: string; // Fehler �ber ein Problem im Nachgang

    // die Abschl�sse von denen der OrgaMon noch nichts weiss
    Stat_Abberufen: integer;
    Stat_IgnoriertTest: integer;
    Stat_IgnoriertFehlenderAuftrag: integer;
    Stat_AusfuehrungsMomentKorrektur: integer;
    Stat_FotoMeldungen: integer;

    // Caching Element:
    //  Wenn es einmal schon einen Datei-Treffer f�r einen Protokoll-Namen gab
    //  wird nach dieser Datei nicht mehr gesucht, sondern der Dateiname
    //  wird direkt in dieser Liste gespeichert und sp�ter direkt gefunden
    sProtokolle: TSearchStringList;

    // Optionen f�r "start"
    start_StaticResult: string; // vorbereitetes statisches Ergebnis
    start_NoTimeCheck: boolean; // Unterdr�cken der Zeitpr�fung

    // Optionen f�r "proceed"
    proceed_FremdmonteureLoeschen: boolean;
    // Auftraege anderer Monteure ablehnen
    proceed_ArbeitIgnorieren: boolean; // Eingaben des Monteurs nicht beachten
    proceed_RestantenLoeschen: boolean; //

    // Ignoriert "Letzte TAN", "Restanten", "Stay-Liste"
    proceed_EinfacheListe: boolean;

    // Erzwingen, dass das OrgaMon-App Volumen neu erzeugt wird
    proceed_refresh: boolean;

    // F�r "private" Protokolle
    proceed_ProtokollPfad: string;

    // Normale Verarbeitung OHNE Ergebnis-Upload
    proceed_NoUpload: boolean;

    // Optionen f�r "proceed", nicht programmiert
    proceed_ProceedAblehnen: boolean; // not imp

    // Call-Backs
    callback_ZaehlerNummerNeu: TOrgaMonApp_TMoreInfo;
    callback_ReglerNummerNeu: TOrgaMonApp_TMoreInfo;

    // IMEI-Tabellen
    tIMEI: TsTable;
    tIMEI_OK: TsTable;
    // aktueller Context
    tBAUSTELLE: tsTable;
    tABLAGE: tsTable;
    LastLogWasTimeStamp: boolean; // Protect TimeStamp Flood
    MandantId: string; // Der [Mandantname]
    AUFTRAG_R: integer; // Aktueller Context f�r Log-Datei, Fehlermeldungsausgabe usw.

    // core
    constructor Create;
    destructor Destroy; override;
    function Initialized: boolean;

    // Verzeichnisse errechnet
    function DataPath: string; // ./dat/db/
    function AuftragPath: string; // ./dat/Daten
    function MySyncPath: string; //

    // Berechnet die Versionsnummer einer gelieferten Datei
    function BisherGeliefert(Id, Merkmal: string): Integer;

    // load cOrgaMon.ini
    procedure readIni(SectionName: string = ''; Path: string = '');

    // SERVICE: "info"
    //
    function info(sParameter: TStringList): TStringList;

    // SERVICE: "start"
    //
    // TAN        vormalige TAN
    // VERSION    JonDa Programmversion
    // OPTIONEN   JonDa Programm-Optionen
    // UHR        Handy Datum - Uhr
    // MOMENT     aktueller Anfrage-Moment
    // GERAET     Monteurs Kennung
    // IMEI       Handy Identifikation
    function start(sParameter: TStringList): TStringList;

    // SERVICE: "proceed"
    //
    // TAN        die verarbeitet werden soll
    function proceed(sParameter: TStringList): TStringList;

    // SERVICE: "foto"
    //
    // Benennt ein Foto mit Hilfe der aktuellen Umgebungsparameter um
    // In besonderen F�llen wird noch ein lokaler CallBack zu Rate gezogen
    function foto(sParameter: TStringList): TStringList;

    // TOOL: Logging
    function LogFName: string;
    procedure BeginAction(ActionText: string);
    procedure EndAction(ActionText: string = '');
    procedure log(s: TStrings); overload;
    procedure log(s: string); overload;
    function AblageLogFname: string;

    // Dateinamen
    function TrnFName: string;

    // TOOL: Ger�t
    function GeraeteAlias(GeraeteID: string): string;
    // [GeraeteID]

    function isProd(pGeraeteNo: string; pRID: integer; pFertig: TANFiXDate): boolean;
    function isTest(pGeraeteNo: string; pRID: integer; pFertig: TANFiXDate): boolean;

    // TOOL: Allgemein
    procedure ClearStat;
    class function VormittagsStr(vormittags: boolean): string;
    class function AusfuehrenStr(ausfuehren_ist_datum: TANFiXDate): string;
    class function FormatZaehlerNummerNeu(const s: string): string;
    class function clearTempTag(const s: string): string;
    class function createTempTag(RID: integer; Parameter: string): string;
    class function active(a: boolean): string;
    class procedure validateBaustelleCSV(FName: string);
    class function isGeraeteNo(s:string): boolean;

    // Errechnet aus einem aktuellen MDEREC den jeweils g�ltigen
    // Protokollnamen, es gibt ein Caching �ber sProtokolle
    function toProtokollFName(const mderec: TMdeRec; RemoteRev: single): string;

    class function toEingabe(const mderec: TMdeRec): string;
    class procedure toAnsi(var mderec: TMdeRec);
    class function toZaehlerNummerType(s:string): TZaehlerNummerType;
    function detectGeraeteNummer(sPath: string): string;

    // TOOL: Dateinamen
    function UpFName(Trn: string): string;
    function AuftragFName(Trn: string): string;

    // TOOL: Migration
    function MdeRec2Jonda(mderec: TMdeRec; RemoteRev: single): string;
    function WebToMdeRecString(s: AnsiString): AnsiString;
    function migrateProtokoll(OldFName, NewFName: string): boolean;

    // TOOL: TAN
    function ActTRN: string;
    function NewTrn(IncrementIt: boolean = true): string;
    function FolgeTRNFName(GeraetID: string): string;
    function FolgeTAN(GeraetID: string): string;
    function InitTrn(GeraeteNo, AktTrn: string): boolean;
    function LogMatch(Pattern, Schema: string): boolean;

    // REPORT:
    procedure doStat;
    function upMeldungen: TStringList;

    // MAINTANACE:
    procedure maintainSENDEN;
    procedure maintainGERAETE;

    // MAINTANANCE:
    //
    // * Bin�res Lager auffrischen
    // * SENDEN.CSV von altem M�ll befreien
    procedure doAbschluss;

    //
    // Verzeichnisse aufr�umen
    function doBackup: int64;
    function nextBackupDir: string;

    // im Moment Pause
    function Pause(WechsleStatus: boolean = false; Off: boolean = false): boolean;

    // load Settings

    // Init, Deinit
    procedure ensureGlobals;
    procedure releaseGlobals;

    function GEN_ID: integer;

    // Work ...
    procedure workEingang_JPG(sParameter: TStringList = nil); // ftp-Eing�nge *.jpg verarbeiten
    procedure workEingang_TXT(sParameter: TStringList = nil); // ftp-Eing�nge *.txt verarbeiten
    procedure workWartend(sParameter: TStringList = nil); // -Neu Umbenennungen vornehmen
    procedure workAblage(sParameter: TStringList = nil); //
    procedure workSync;
    procedure workAusstehendeFotos; // Liste der bisher un�bertragenen Fotos

    // muss IMMER �berladen werden
    procedure FotoLog(s: string); virtual; abstract;
    procedure Dump(s: string; sl: TStringList);
    procedure FotoTransaction(TransactionCommand,TransactionParameter:string);

    // Eingabe.GGG.txt Suchfunktionen
    procedure invalidate_NummerNeuCache;
    function EingabeLocate(AUFTRAG_R: integer; GeraeteNo: string; Spalte: string): string;

    // Implementierungen von Prototypen
    function ZaehlerNummerNeu(AUFTRAG_R: integer; GeraeteNo: string): string;
    function ReglerNummerNeu(AUFTRAG_R: integer; GeraeteNo: string): string;

  end;

implementation

uses
  // System
  windows, IniFiles,
  // anfix
  BinLager32, html, srvXMLRPC,
  // Exif
  CCR.Exif, CCR.Exif.BaseUtils;

{ TOrgaMonApp }

function TOrgaMonApp.LogFName: string;
begin
  result := DiagnosePath + cJonDaServer_LogFName;
end;

function TOrgaMonApp.LogMatch(Pattern, Schema: string): boolean;
var
  n: integer;
  SchemaMisMatch: boolean;
begin
  result := false;
  repeat
    if (length(Pattern) <> length(Schema)) then
      break;
    SchemaMisMatch := false;
    for n := 1 to length(Schema) do
      if (Schema[n] <> '?') then
        if (Schema[n] <> Pattern[n]) then
        begin
          SchemaMisMatch := true;
          break;
        end;
    if SchemaMisMatch then
      break;
    result := true;
  until yet;
end;

procedure TOrgaMonApp.maintainGERAETE;
var
  sLog: TStringList;
  n, r: integer;
  CallDate, HasDate: TANFiXDate;
  _HasDate: string;
  GeraeteID: string;
  sGeraete: TsTable;
  SingleRow: TStringList;
  cCol_GERAET, cCol_CALL, cCol_COUNT: integer;
begin

  // Ergebnistabelle anlegen
  sGeraete := TsTable.Create;
  with sGeraete do
  begin
    cCol_GERAET := addCol('GERAET');
    cCol_CALL := addCol('CALL');
    cCol_COUNT := addCol('COUNT', '0');

    // Tabelle mit besonders interessanten Werte vorbef�llen
    for n := 1 to 100 do
    begin
      SingleRow := TStringList.Create;
      SingleRow.add(inttostrN(n, 3));
      SingleRow.add('NAD');
      SingleRow.add('0');
      addRow(SingleRow);
    end;

  end;

  // Log laden und auswerten
  sLog := TStringList.Create;
  sLog.LoadFromFile(LogFName);
  for n := pred(sLog.count) downto 0 do
  begin
    if LogMatch(sLog[n], cGeraetSchema) then
    begin
      GeraeteID := nextp(sLog[n], ':', 3);
      if (GeraeteID <> '000') then
      begin
        CallDate := Date2Long(nextp(sLog[n], ' ', 2));

        r := sGeraete.locate(cCol_GERAET, GeraeteID);
        if (r = -1) then
        begin
          // Bisher unbekannt
          SingleRow := TStringList.Create;
          SingleRow.add(GeraeteID);
          SingleRow.add(inttostr(CallDate));
          r := sGeraete.addRow(SingleRow);
        end
        else
        begin
          repeat
            _HasDate := sGeraete.readCell(r, cCol_CALL);

            if (_HasDate = 'NAD') then
            begin
              sGeraete.writeCell(r, cCol_CALL, inttostr(CallDate));
              break;
            end;

            HasDate := strtointdef(_HasDate, cIllegalDate);

            if (HasDate < CallDate) then
            begin
              sGeraete.writeCell(r, cCol_CALL, inttostr(CallDate));
              break;
            end;

          until yet;
        end;
        sGeraete.incCell(r, cCol_COUNT);

      end;
    end;
  end;
  sLog.free;

  sGeraete.SortBy('COUNT numeric;CALL numeric descending;GERAET');
  // Ergebnis speichern
  sGeraete.SaveToHTML(pWebPath + 'geraete.html');
  sGeraete.free;
end;

const
  maintainSENDEN_Cache_Init: boolean = false;

procedure TOrgaMonApp.maintainSENDEN;
const
  cOlderThan = 10;
var
  tSENDEN: TsTable;
  r, c, n: integer;
  CellDate, d: TANFiXDate;
  sSENDEN: TStringList;
begin

  // senden.csv angelegt?
  if not(maintainSENDEN_Cache_Init) then
    if not(FileExists(DataPath + cAppService_SendenFName)) then
    begin
      sSENDEN := TStringList.Create;
      sSENDEN.add('IMEI;NAME;ID;MOMENT;TAN;REV;ERROR;PAPERCOLOR');
      sSENDEN.SaveToFile(DataPath + cAppService_SendenFName);
      sSENDEN.free;
    end;

  // Nach "SENDEN" Tabelle protokollieren
  tSENDEN := TsTable.Create;
  with tSENDEN do
  begin
    InsertFromFile(DataPath + cAppService_SendenFName);

    if not(maintainSENDEN_Cache_Init) then
    begin
      addCol('ERROR');
      addCol('PAPERCOLOR');
    end;

    c := colof('MOMENT', true);
    d := DatePlus(DateGet, -cOlderThan);
    // zu alte Zeile l�schen
    for r := 1 to RowCount do
    begin
      CellDate := strtointdef(nextp(readCell(r, c), ' ', 0), cIllegalDate);
      if (CellDate > cIllegalDate) and (CellDate < d) then
      begin
        // L�schposition gefunden -> alles ab da l�schen!
        for n := RowCount downto r do
          Del(n);
        break;
      end;
    end;

    if changed then
    begin
      SaveToHTML(pWebPath + 'senden.html');
      SaveToFile(DataPath + cAppService_SendenFName);
    end;
  end;
  tSENDEN.free;
  maintainSENDEN_Cache_Init := true;
end;

function TOrgaMonApp.AuftragFName(Trn: string): string;
begin
  // Das Ergebnis im Web bereitstellen
  result :=
    { } pWebPath +
    { } Trn + '.auftrag' + cUTF8DataExtension;
end;

function TOrgaMonApp.UpFName(Trn: string): string;
begin
  result :=
   { } pWebPath +
   { } Trn + '.txt';
end;

class function TOrgaMonApp.AusfuehrenStr(ausfuehren_ist_datum: TANFiXDate): string;
begin
  begin
    case ausfuehren_ist_datum of
      cMonDa_Status_unbearbeitet:
        result := 'unbearbeitet';
      cMonDa_Status_Restant:
        result := 'Restant';
      cMonDa_Status_Unmoeglich:
        result := 'Unm�glich';
      cMonDa_Status_Wegfall:
        result := 'Wegfall';
      cMonDa_Status_NeuAnschreiben:
        result := 'NeuAnschreiben';
      cMonDa_Status_Vorgezogen:
        result := 'Vorgezogen';
      cMonDa_Status_Info:
        result := 'Info';
      cMonDa_Status_OhneInfo:
        result := 'undefiniert';
    else
      result := long2date(ausfuehren_ist_datum);
    end;
  end;
end;

procedure TOrgaMonApp.BeginAction(ActionText: string);
begin
  log(datum + ' ' + secondstostr(secondsget) + ' ' + ActionText);
  inc(TabCounter);
end;

procedure TOrgaMonApp.EndAction;
begin
  // pragma
  dec(TabCounter);
  if (ActionText <> '') then
    log(datum + ' ' + secondstostr(secondsget) + ' ' + ActionText);
end;

procedure TOrgaMonApp.log(s: TStrings);
var
  LogF: TextFile;
  n: integer;
  LogS: string;
begin
  if not(assigned(sSendenLog)) then
    sSendenLog := TStringList.Create;

  assignFile(LogF, LogFName);
{$I-}
  append(LogF);
{$I+}
  if (ioresult <> 0) then
  begin
    CloseFile(LogF);
    raise Exception.Create('Append Fail!');
  end;
  for n := 0 to pred(s.count) do
  begin
    LogS := fill(' ', TabCounter * 2) + s[n];
    if LogMatch(LogS, cGeraetSchema) then
      sSendenLog.add(LogS);
    writeln(LogF, LogS);
  end;
  CloseFile(LogF);
end;

procedure TOrgaMonApp.log(s: string);
var
  StringList: TStringList;
begin
  StringList := TStringList.Create;
  StringList.add(s);
  log(StringList);
  StringList.free;
end;

function TOrgaMonApp.GeraeteAlias(GeraeteID: string): string;
begin
  // Besondere Aktionen bei besonderen Ger�te-Nummern ausf�hren
  repeat

    if (GeraeteID = '999') then
    begin
      // Statistik
      doStat;
      // ausstehende Meldungen
      upMeldungen;
      result := '000';
      break;
    end;

    result := GeraeteID;
  until yet;
end;

class function TOrgaMonApp.FormatZaehlerNummerNeu(const s: string): string;
begin
  result := cutblank(s);
  repeat
    if (length(result) <= 1) then
      break;
    if (result[1] = '0') then
      result := copy(result, 2, MaxInt)
    else
      break;
  until eternity;
end;

function TOrgaMonApp.FolgeTRNFName(GeraetID: string): string;
begin
  result := AuftragPath + 'TAN.' + GeraetID + '.txt';
end;

function TOrgaMonApp.FolgeTAN(GeraetID: string): string;
var
  sFolgeTAN: TStringList;
  SaveIt: boolean;
begin
  SaveIt := false;
  sFolgeTAN := TStringList.Create;

  if FileExists(FolgeTRNFName(GeraetID)) then
  begin
    // eine TAN wurde bereits zugeteilt, diese
    // ist noch unverarbeitet, wird also abermals ausgegeben
    // dies verhindert dass TANs ausgegeben werden an die
    // gemeldet wird, aber die niemals abgearbeitet wird
    // Ein Benutzer erh�lt gleichzeitig also immer nur
    // eine TAN, diese muss abgearbeitet sein bevor
    // eine neue TAN erzeugt wird.
    sFolgeTAN.LoadFromFile(FolgeTRNFName(GeraetID));
    repeat

     if (sFolgeTAN.Count=0) then
     begin
       // Datei ist leer!
       log({} cWARNINGText + ' 666:' +
           {} 'Folge TRN. Datei leer, erzeuge neue TRN ...');
       result := NewTrn;
       SaveIt := true;
       break;
     end;

     result := StrFilter(sFolgeTAN[0],cZiffern);

     if (length(result)<>length(cFirstTrn)) then
     begin
       // Format der Nummer stimmt irgendwie nicht
       log({} cWARNINGText + ' 678:' +
           {} 'Folge TRN. Datei defekt, erzeuge neue TRN ...');
       result := NewTrn;
       SaveIt := true;
       break;
     end;

    until yet;

  end else
  begin
    // Erstkontakt! Es wird eine ganz neu TAN
    // generiert und abgespeichert.
    result := NewTrn;
    SaveIt := true;
  end;

  if SaveIt then
  begin
    sFolgeTAN.add(result);
    sFolgeTAN.SaveToFile(FolgeTRNFName(GeraetID));
  end;

  sFolgeTAN.free;

  // das TAN Verzeichnis anlegen
  CheckCreateDir(pAppServicePath + result);
end;

class function TOrgaMonApp.active(a: boolean): string;
begin
  if a then
    result := cIni_Activate
  else
    result := cIni_Deactivate;
end;

class function TOrgaMonApp.isGeraeteNo(s:string):boolean;
begin
  result := false;
  repeat
    if (length(s)<>3) then
     break;
    s := StrFilter(s,cZiffern);
    if (length(s)<>3) then
     break;
    result := true;
  until yet;
end;

function TOrgaMonApp.ActTRN: string;
begin
  result := NewTrn(false);
end;

function TOrgaMonApp.NewTrn(IncrementIt: boolean = true): string;
var
  TrnFile: TextFile;
  TrnLine: string;
begin

  // Lade aktuelle TAN, das ist auch R�ckgabewert!
  if not(FileExists(TrnFName)) then
  begin
    TrnLine := cFirstTrn;
  end
  else
  begin
    assignFile(TrnFile, TrnFName);
    try
      reset(TrnFile);
    except
      on E: Exception do
        log(cERRORText + ' 645:' + E.Classname + ': ' + E.Message);
    end;
    readln(TrnFile, TrnLine);
    CloseFile(TrnFile);
  end;
  result := TrnLine;

  // F�r das n�chste Mal: Inkrementiere TAN und speichere sie dann
  if IncrementIt then
  begin

    // <Aktueller Stand> + 1
    TrnLine := inttostr(succ(strtoint(TrnLine)));

    // Bei Flip-Over wieder auf Anfang (da sollten schon Monate dazwischen liegen)
    if (strtoint(TrnLine) >= strtoint(cFirstTrn) * 10) then
      TrnLine := cFirstTrn;

    assignFile(TrnFile, TrnFName);
    try
      rewrite(TrnFile);
    except
      on E: Exception do
        log(cERRORText + ' 1830:' + E.Message);
    end;
    writeln(TrnFile, TrnLine);
    CloseFile(TrnFile);

  end;

end;

function TOrgaMonApp.info(sParameter: TStringList): TStringList;
begin
  result := TStringList.Create;
  with result do
  begin
    add(pAppServicePath);
    add(cApplicationName + ' Rev. ' + RevToStr(globals.Version));
    add('Indy Rev. N/A');
    add('ANFiX Rev. ' + RevToStr(VersionAnfix32));
    add(ComputerName);
    add(datum + ' ' + uhr8);
    addobject(ActTRN + '.' + cServerFunctions_Meta_CallCount, TXMLRPC_Server.oMetaString);
    add(iJonDa_FTPUserName + '@' + iJonDa_FTPHost);
    add(Betriebssystem);
  end;
end;

function TOrgaMonApp.proceed(sParameter: TStringList): TStringList;

var
  AktTrn: string;
  GeraeteNo: string;

  GoodMonteurL: TStringList;
  ProtocolL: TStringList;
  ProtocolAll: TStringList;
  JondaAll: TSearchStringList;
  Einstellungen: TStringList;

  // F�r die Foto "Neu" Umbenennung werden 2. Informationen
  // gesammelt: Z�hlernummer Neu und Reglernummer Neu
  // die Speicherung erfolgt in Eingabe.GGG.txt
  BilderAll: TStringList;
  BilderAll_WechselMomentKorrigiert: TStringList;
  EingabeL: TStringList;

  //
  ProtS: string;
  LastTrnNo: string; // Vom Ger�t
  Optionen: string; // Vom Ger�t
  IMEI: string; // Vom Ger�t

  // Aus der IMEI Tabelle
  NAME: string;
  BEZAHLT_BIS: TANFiXDate;

  OneJLine: string;
  JProtokoll: string;
  JAuftragBisherFName: string;
  FName: string;
  MonDaGeraetF: TextFile;
  RemoteRev: single;

  // Eingabe/Ausgabe Dateien
  f_OrgaMon_Auftrag: file of TMdeRec; // Neues von OrgaMon
  bOrgaMonAuftrag: TBLager;

  // Das sind Ergebnisse der App an OrgaMon ...
  fOrgaMonErgebnis: file of TMdeRec;

  // String-List mit der Original-Protokoll-Eingabe
  sOrgaMonErgebnis: TStringList; // ... hier als utf8-Variante

  // alle Ergebnisdaten die ein F?= enthalten
  bFotoErgebnis: TBLager;

  // Das Handy meldet nur �nderungen, jedoch
  // wird der komplette Auftrag inclusive der Unver�nderten rekonstruiert
  // AUFTRAG.DAT der aktuelle Stand
  f_OrgaMonApp_Ergebnis: file of TMdeRec;

  f_OrgaMonApp_NeuerAuftrag: file of TMdeRec;
  // neue, aufbereitete Liste an MonDa
  // -> Restanten und Neue
  MonDaAasTxt: TextFile;
  Auftrag: TStringList;

  MonDaA_StayF: file of TMdeRec; // neue, aufbereitete Liste an MonDa
  // heutige Eingaben!
  MonDaA_LostF: file of TMdeRec; // Aufgrund zu langer Verweildauer auf
  // dem Ger�t wurden diese in den Status
  // "unm�glich" versetzt!
  mderec: TMdeRec;
  mdeS: string;
  // Text-Entsprechung zum MdeRec, also immer wenn hier auf den MDEREC zugegriffen wird
  // sollte mdeS entsprechend gesetzt werden!
  mderec2: TMdeRec;
  n, m, k, iRID: integer;
  dFertig: TANFiXDate;
  EntryPointReached: boolean;

  _DateGet: TANFiXDate;
  _SecondsGet: TANFiXTime;
  _DatumWechselTimeOut: TANFiXDate;
  // Wenn der Wechsel zu lange her ist, wird der "Moment"
  // korigiert
  _DateGetTimeOut: TANFiXDate;
  ErrorCount: integer;

  OldTrn: string;
  // Bei Serverauftr�gen ist die der erste Parameter (zumeist eine
  // alte existierende TAN).

  // Liste aller neuen RIDs
  OrgaMonPlanungsVolumen: TgpIntegerList;
  OrgaMonFertig: TgpIntegerList;
  OrgaMonAbgearbeitet: TgpIntegerList;

  // Stay-Liste
  // ==========
  //
  // Liste aller erledigten! Alle werden nat�rlich an OrgaMon gemeldet!
  // Einige sollten jedoch auf der App bleiben: OrgaMon weis
  // ev. von diesen Meldungen noch nichts, und versucht die Datens�tze
  // durch "unbearbeitete" zu Ersetzen - ein �rgernis f�r den Monteur
  // hat dieser doch die Auftr�ge schon erledigt!
  //
  // Es wird ein Pool von heutigen und vorgezogenen Auftr�gen gef�hrt.
  // Kommen jedoch diese mit einem anderen _soll Datum oder Vormittag/Nachmittag
  // wird der Datensatz von OrgaMon genommen, ansonsten der eigene behalten.
  // Kommt dieser Datensatz gar nicht mehr von OrgaMon, so kann auch die weitere
  // Speicherung auf der App unterbleiben. OrgaMon ist dann offensichtlich schon
  // irgendwie von der Erledigung informiert.
  //
  // Entweder steht der Datensatz an der Stelle wo er war, oder er ist weg.
  // Oder OrgaMon hat ihn durch einen neuen ersetzt.
  //
  // Vorgehensweise:
  //
  // ist der OrgaMon-Datensatz in der Stay Liste?
  // ja -> pr�fe, ob soll=soll ist
  // ja->nehme den App-Datensatz
  // (man k�nnte jedoch die OrgaMon-Datenfelder updaten!!!)
  // nein->nehme den OrgaMon-Datensatz
  // ev. wurde hier umterminiert!
  // nein -> einfach �bernehmen!
  //
  MondaStay: TStringList;

  //
  // Verzeichnis der Baustellen, es wird mitprotokolliert welche
  // Baustellen auf das Ger�t �bertragen werden. Aus dieser Info
  // wird die Dateimaske
  //
  MondaBaustellen: TStringList;

  // Ev. wird der Wechselmoment korrigiert, da er z.B. in der
  // Zukunft - oder zu weit in der Vergangenheit liegt.
  // In diesem Fall, darf z.B. nicht der Eingabemoment
  // aufgezeichnet werden, da sonst
  WechselmomentKorrektur: TgpIntegerList;

  // Log nach "SENDEN" Tabelle
  tSENDEN: TsTable;
  sSENDEN: TStringList;

  // XMLRPC-Ergebnis
  XMLRPC_Result : TStringList;
  XMLRPC_Parameter : TStringList;

  function isFertig: boolean;
  begin
    result := (mderec.ausfuehren_ist_datum > cMonDa_Status_unbearbeitet);
  end;

  function FName_Abgezogen: string;
  begin
    result := format(pAppServicePath + AktTrn + PathDelim + cMonDaServer_AbgezogenFName, [GeraeteNo]);
  end;

  procedure SaveOneStay;
  begin

    repeat

      // bei einfacher Liste gibt es kein Stay
      if (proceed_EinfacheListe) then
        break;

      // Freie Terminwahl muss immer vom OrgaMon selbst kommen
      if (mderec.ausfuehren_ist_datum > cMonDa_Status_unbearbeitet) and
         (mderec.ausfuehren_soll = cMonDa_FreieTerminWahl) then
        break;

      // heute ausgef�hrt?
      if (mderec.ausfuehren_ist_datum = _DateGet) or
         // f�r heute geplant oder vorgezogen?
         (mderec.ausfuehren_soll > _DateGet) or
         // oder folgende Stati
         (mderec.ausfuehren_ist_datum = cMonDa_Status_Restant) or
         (mderec.ausfuehren_ist_datum = cMonDa_Status_Unmoeglich) or
         (mderec.ausfuehren_ist_datum = cMonDa_Status_NeuAnschreiben) or
         (mderec.ausfuehren_ist_datum = cMonDa_Status_Vorgezogen) then
      begin
        write(MonDaA_StayF, mderec);
        MondaStay.addobject(inttostr(mderec.RID), TObject(Stat_MondaStay));
        inc(Stat_MondaStay);
      end;

    until yet;
  end;

  procedure WriteJonDa(s: string);
  begin
    writeln(MonDaAasTxt, s);
    Auftrag.add(s);
  end;

  procedure CloseJonDa;
  begin
    //
    CloseFile(MonDaAasTxt);

    // Das Ergebnis zum Download bereitstellen
    SaveStringsToFileUTF8(Auftrag, AuftragFName(AktTrn));
  end;

  procedure add_OrgaMonApp_NeuerAuftrag;
  begin
    repeat

      // Ger�t nur leeren -> keine neuen Auftr�ge
      if (GeraeteNo = '000') then
        break;

      // grade eben als "fertig" gemeldet! -> Nicht mehr aufs Ger�t!
      if (OrgaMonFertig.IndexOf(mderec.RID) <> -1) then
      begin
        inc(Stat_FrischFertig);
        break;
      end;

      if (OrgaMonAbgearbeitet.IndexOf(mderec.RID) <> -1) then
      begin
        inc(Stat_Schlafmuetzen);
        break;
      end;

      if (mderec.ausfuehren_soll = cMonDa_FreieTerminWahl) then
        if (OrgaMonPlanungsVolumen.IndexOf(mderec.RID) = -1) then
        begin
          inc(Stat_Abberufen);
          break;
        end;

      //
      if proceed_FremdmonteureLoeschen then
        if (GoodMonteurL.IndexOf(mderec.monteur) = -1) then
          break;

      //
      write(f_OrgaMonApp_NeuerAuftrag, mderec);
      MondaBaustellen.add(mderec.Baustelle);
      inc(Stat_MondaNeu);

      WriteJonDa(MdeRec2Jonda(mderec, RemoteRev));

    until yet;
  end;

  procedure WriteOrgaMon;
  // Info der App an den OrgaMon
  var
   sProtokoll : TStringList;
   n : Integer;
   FotoMeldung: boolean;
   mderec_SendeMoment : TMDERec;
  begin

    // f�r die Statistik
    inc(Stat_Meldungen);

    // ausgeben in eine Datei
    write(fOrgaMonErgebnis, mderec);

    // Bild-Infotexte ausgeben
    mderec_SendeMoment := mderec;
    with mderec_SendeMoment do
      if (ausfuehren_ist_datum < cMonDa_ErsterTermin) then
      begin
       ausfuehren_ist_datum := _DateGet;
       ausFuehren_ist_uhr := _SecondsGet;
      end;

    if (WechselmomentKorrektur.IndexOf(mderec.RID) = -1) then
     BilderAll.add(toEingabe(mderec_SendeMoment))
    else
     BilderAll_WechselMomentKorrigiert.add(toEingabe(mderec_SendeMoment));

    // Bild-Zuordnung protokollieren
    FotoMeldung := false;
    sProtokoll := split(mderec.ProtokollInfo);
    for n := 0 to pred(sProtokoll.count) do
    begin
      if (length(sProtokoll[n])<4) then
        continue;
      if (sProtokoll[n][1]='F') then
        if (sProtokoll[n][3]='=') then
          if (pos(sProtokoll[n][2],cBuchstaben)>0) then
          begin
            FotoMeldung := true;
            break;
          end;
    end;
    sProtokoll.free;

    if FotoMeldung then
    begin
      inc(Stat_FotoMeldungen);
      with bFotoErgebnis do
      begin
        if exist(mderec.RID) then
          put(sizeof(TMdeRec))
        else
          insert(mderec.RID, sizeof(TMdeRec));
      end;
    end;

  end;

  function ReadMonDaRev: string;
  var
    MondaRev: string;
    MonDaRevF: TextFile;
  begin
    if FileExists(pAppServicePath + AktTrn + '\REV.DAT') then
    begin
      assignFile(MonDaRevF, pAppServicePath + AktTrn + '\REV.DAT');
      try
        reset(MonDaRevF);
      except
        on E: Exception do
          log(cERRORText + ' 879:' + E.Message);
      end;
      readln(MonDaRevF, MondaRev);
      CloseFile(MonDaRevF);
      result := MondaRev;
    end
    else
    begin
      result := '0.000';
    end;
  end;

  procedure MergeMeldung;
  var
    slGeraet: TStringList;
    ilGemeldeteRIDS: TgpIntegerList;
    i, RID: integer;
    dFertig: TANFiXDate;
    UHR: string;
  begin
    if FileExists(pAppServicePath + cMeldungPath + GeraeteNo + '.txt') then
    begin
      slGeraet := TStringList.Create;
      ilGemeldeteRIDS := TgpIntegerList.Create;
      try
        slGeraet.LoadFromFile(pAppServicePath + cMeldungPath + GeraeteNo + '.txt');
        if (JondaAll.count > 0) then
          slGeraet.AddStrings(JondaAll);
        JondaAll.Clear;

        // dadurch immer die letzte Meldung nehmen!
        for i := pred(slGeraet.count) downto 0 do
        begin
          RID := strtointdef(nextp(slGeraet[i], ';', 0), 0);
          UHR := nextp(slGeraet[i], ';', 10);
          dFertig := Date2Long(nextp(UHR, ' - ', 0));
          // dFertig := strtointdef(nextp(slGeraet[I], ';', 8), 0);

          if (RID > 0) then
            if isProd(GeraeteNo, RID, dFertig) then
            begin
              if (ilGemeldeteRIDS.IndexOf(RID) = -1) then
              begin
                ilGemeldeteRIDS.add(RID);
                JondaAll.add(slGeraet[i]);
              end;
            end;

        end;
        // den Stand dann auch so speichern!
        JondaAll.SaveToFile(pAppServicePath + cMeldungPath + GeraeteNo + '.txt');
      except
        on E: Exception do
          log(cERRORText + ' 620:' + E.Message);
      end;
      slGeraet.free;
      ilGemeldeteRIDS.free;
    end;
  end;

  procedure addSingle(FName: string);
  var
    mderec: TMdeRec;
    fpending: file of TMdeRec; // neue, aufbereitete Liste an die App
    n: integer;
  begin
    assignFile(fpending, FName);
    try
      reset(fpending);
    except
      on E: Exception do
        log(cERRORText + ' 748:' + E.Message);
    end;
    for n := 1 to FileSize(fpending) do
    begin
      read(fpending, mderec);

      // die Abschl�sse des Monteurs �bernehmen!
      with mderec do
      begin
        if RID > 0 then
        begin
          if (ausfuehren_ist_datum > cMonDa_Status_unbearbeitet) or (ausfuehren_ist_datum = cMonDa_Status_Unmoeglich) or
            (ausfuehren_ist_datum = cMonDa_Status_NeuAnschreiben) or (ausfuehren_ist_datum = cMonDa_Status_Vorgezogen)
          then
            if OrgaMonAbgearbeitet.IndexOf(RID) = -1 then
              OrgaMonAbgearbeitet.add(RID);
        end;
      end;
    end;
    CloseFile(fpending);
  end;

  procedure addPending;
  var
    sPendings: TStringList;
    n: integer;
    sTAN_FName: string;
  begin
    sPendings := TStringList.Create;
    sPendings.LoadFromFile(pAppServicePath + AktTrn + PathDelim + cMonDaServer_UnberuecksichtigtFName);
    for n := 0 to pred(sPendings.count) do
    begin
      sTAN_FName := cutblank(sPendings[n]);
      if (sTAN_FName <> '') then
      begin
        sTAN_FName := pAppServicePath + cOrgaMonDataPath + sTAN_FName;
        if FileExists(sTAN_FName) then
          addSingle(sTAN_FName);
      end;
    end;
    sPendings.free;
  end;

  procedure addAbgezogene;
  var
    lAbgezogene: TgpIntegerList;
  begin
    if FileExists(FName_Abgezogen) then
    begin
      lAbgezogene := TgpIntegerList.Create;
      lAbgezogene.LoadFromFile(FName_Abgezogen);
      OrgaMonAbgearbeitet.append(lAbgezogene);
      lAbgezogene.free;
    end;
  end;

  procedure WebSite;
  var
    MonteurInfo: THTMLTemplate;
    mderecOrgaMon, mderecFoto: TMdeRec;
    finfo: file of TMdeRec;
    DatensammlerLokal: TStringList;
    DatensammlerGlobal: TStringList;

    sEingabe: TStringList;
    sLog: TStringList;

    // Info-"Datenbanken"
    bFoto: TBLager; // globales Foto-Lager (immer neuester Stand)
    bOrgaMon: TBLager; // globales Auftrags-Lager (immer neuester Stand)

    sRIDbereitsBerichtet: TgpIntegerList;
    AUFTRAG_R: integer;
    Stat_Zeilen: integer;

    procedure report(sEingabeIndex: integer; HasFoto: boolean);
    // Info-Strings
    var
      iTermin, iDetails, iStatus, iFarbe: string;
      iEingabeDatum, iEingabeUhr: string;
      Status,n: integer;
      sProtokoll: TStringList;
    begin
      with mderecOrgaMon do
      begin

        iDetails := Oem2asci(Zaehler_Strasse) + cLineSeparator + Oem2asci(Zaehler_Ort);

        // Text beim Termin (Spalte 1)
        iTermin :=
        { BAU-00000 } Oem2asci(Baustelle) + '-' + ABNummer + #13 +
        { MON } WeekDayS(ausfuehren_soll) + #160 +
        { 23.02. } copy(long2date(ausfuehren_soll), 1, 5) + VormittagsStr(vormittags);

        if (sEingabeIndex <> -1) then
        begin
          iEingabeDatum := nextp(sEingabe[sEingabeIndex], ';', 0);
          iEingabeUhr := nextp(sEingabe[sEingabeIndex], ';', 1);
          iTermin := iTermin + #13 + iEingabeDatum + #160 + iEingabeUhr;
        end;

        repeat

          if HasFoto then
          begin
            sProtokoll := split(mderecFoto.ProtokollInfo);
            sProtokoll.Sort;
            for n := 0 to pred(sProtokoll.Count) do
            begin
              if (length(sProtokoll[n])<4) then
                continue;
              if (sProtokoll[n][1]='F') then
                if (sProtokoll[n][3]='=') then
                  if (pos(sProtokoll[n][2],cBuchstaben)>0) then
                     iDetails := iDetails + #13 + sProtokoll[n];
            end;
            sProtokoll.free;
            Status := 0;
            break;
          end;

          Status := 1;

        until yet;

        // Text bei Status (Spalte 3)
        if (ausfuehren_ist_datum <> 0) then
          iStatus := AusfuehrenStr(ausfuehren_ist_datum)
        else
          iStatus := '';

        // Zukunft + Rot -> aus der Liste ausblenden!
        if (Status = 1) then
          if (ausfuehren_soll > _DateGet) then
            Status := -1;

        // Restant + Rot -> Gelb
        if (Status = 1) then
          if (ausfuehren_ist_datum = cMonDa_Status_Restant) then
            Status := 4;

        // Wegfall + Rot -> Grau
        if (Status = 1) then
          if (ausfuehren_ist_datum = cMonDa_Status_Wegfall) then
            Status := 3;

        case Status of
          0:
            iFarbe := '66CC00'; // gr�n (Foto-Da)
          1:
            iFarbe := 'CC3333'; // rot (kein Foto)
          2:
            iFarbe := 'FFCC66'; // orange
          3:
            iFarbe := 'E8F4F8'; // hellblau (bisher keine Eingabe)
          4:
            iFarbe := 'FFFF00'; // gelb
        end;

      end;

      if (Status >= 0) then
      begin
        inc(Stat_Zeilen);
        with DatensammlerLokal do
        begin
          add('load AUFTRAG MID,AUFTRAG');
          add('Termin=' + iTermin);
          add('Details=' + iDetails);
          add('Farbe=' + iFarbe);
          add('Status=' + iStatus);
          add('Typ=' + inttostr(Status));
          add('Zeile=' + inttostr(Stat_Zeilen));
        end;
      end;

    end;

  var
    n: integer;
    E: integer;
    SearchStr: string;
    i: integer;
    HasFoto, FirstFoto: boolean;

  begin
    sEingabe := TStringList.Create;
    sLog := TStringList.Create;
    DatensammlerLokal := TStringList.Create;
    DatensammlerGlobal := TStringList.Create;

    bFoto := TBLager.Create;
    bOrgaMon := TBLager.Create;
    sRIDbereitsBerichtet := TgpIntegerList.Create;
    Stat_Zeilen := 0;
    with DatensammlerGlobal do
    begin
      add('');
      add('Tabelle Titel=' + GeraeteNo);
      add('GeraeteNo=' + GeraeteNo);
      add('TAN=' + AktTrn);
      add('Version=' + RevToStr(RemoteRev));
      add('Datum=' + long2dateLocalized(DateGet));
      add('AktuellesDatum=' + DatumLocalized);
      add('AktuelleUhrzeit=' + UHR);
      add('save&delete FORMFEED');
      add('save&delete TRENNER');
      add('save&delete AUFTRAG MID');
      add('save&delete AUFTRAG LAST');
    end;

    bFoto.Init(AuftragPath + 'FOTO+TS', mderecFoto, sizeof(TMdeRec));
    bFoto.BeginTransaction(now);

    bOrgaMon.Init(AuftragPath + 'AUFTRAG+TS', mderecOrgaMon, sizeof(TMdeRec));
    bOrgaMon.BeginTransaction(now);

    // der "neue" Auftrag ist massgeblich!
    assignFile(finfo, pAppServicePath + AktTrn + PathDelim + cMDEFNameMde);
    try
      reset(finfo);
    except
      on E: Exception do
        log(cERRORText + ' 748:' + E.Message);
    end;

    // Laden der "Eingabe.???.txt"
    if FileExists(DataPath + 'Eingabe.' + GeraeteNo + '.txt') then
      sEingabe.LoadFromFile(DataPath + 'Eingabe.' + GeraeteNo + '.txt');

    // �ber die Eingaben des Monteurs selbst
    FirstFoto := false;
    for n := 0 to pred(sEingabe.count) do
    begin
      AUFTRAG_R := strtointdef(nextp(sEingabe[n], ';', 2), -1);
      if (AUFTRAG_R >= 1) then
        if (sRIDbereitsBerichtet.IndexOf(AUFTRAG_R) = -1) then
        begin
          sRIDbereitsBerichtet.add(AUFTRAG_R);

          if bOrgaMon.exist(AUFTRAG_R) then
          begin
            bOrgaMon.get;
          end
          else
          begin
            fillchar(mderecOrgaMon, sizeof(mderec), 0);
            mderecOrgaMon.ausfuehren_ist_datum := cMonDa_Status_OhneInfo;
            mderecOrgaMon.ausfuehren_soll := Date2Long(nextp(sEingabe[n], ';', 0));
          end;

          HasFoto := bFoto.exist(AUFTRAG_R);
          if HasFoto then
          begin
            bFoto.get;
            FirstFoto := true;
          end;

          // Report erstellen
          if FirstFoto then
            report(n, HasFoto);

        end;
    end;

    // �ber die Angaben des B�ros
    for n := 1 to FileSize(finfo) do
    begin
      read(finfo, mderecOrgaMon);
      AUFTRAG_R := mderecOrgaMon.RID;

      // nicht norwendig, da im Auftrag immer nur einmal!
      if sRIDbereitsBerichtet.IndexOf(AUFTRAG_R) <> -1 then
        continue;

      //

      // sRIDbereitsBerichtet.add(mderecOrgaMon.RID);

      // die Abschl�sse des Monteurs �bernehmen!

      // nun den RID in der Eingabe finden
      i := -1;
      SearchStr := ';' + inttostr(AUFTRAG_R) + ';';
      for E := pred(sEingabe.count) downto 0 do
        if (pos(SearchStr, sEingabe[E]) > 0) then
        begin
          i := E;
          break;
        end;

      HasFoto := bFoto.exist(AUFTRAG_R);
      if HasFoto then
        bFoto.get;

      report(i, HasFoto);

    end;
    CloseFile(finfo);
    bFoto.EndTransaction;
    bOrgaMon.EndTransaction;

    with DatensammlerLokal do
    begin
      add('load AUFTRAG LAST,AUFTRAG');
      add('SummeOffen=#');
      add('SummeDetails=#');
    end;
    with DatensammlerGlobal do
    begin
      add('MehrInfo=');
    end;
    MonteurInfo := THTMLTemplate.Create;
    with MonteurInfo do
    begin
      LoadFromFile(pAppServicePath + 'HTML Vorlagen\Info.html');
      WriteValue(DatensammlerLokal, DatensammlerGlobal);
      SaveToFileCompressed(pWebPath + GeraeteNo + '.html');
    end;
    DatensammlerLokal.free;
    DatensammlerGlobal.free;
    sEingabe.free;
    sLog.free;

    MonteurInfo.free;
    bFoto.free;
    bOrgaMon.free;
    sRIDbereitsBerichtet.free;
  end;

  procedure logEingabeL_merge(sBilder: TStringList);
  {
    EingabeL wird mit neuen Infos aus sBilder erg�nzt, aber ein leerer Eintrag
    kann keine bestehende Eintragung l�schen.
  }
  var
    n,m : integer;
    RID, C3, C4 : string;
    _C3, _C4 : string;
    PatchLine : boolean;
  begin
    //
    for n := 0 to pred(sBilder.Count) do
    begin
     RID := nextp(sBilder[n], ';', 2);
     C3 := nextp(sBilder[n], ';', 3);
     C4 := nextp(sBilder[n], ';', 4);
     if (C3<>'') or (C4<>'') then
     begin

       PatchLine := false;
       for m := 0 to pred(EingabeL.Count) do
        if (nextp(EingabeL[m], ';', 2)=RID) then
        begin
          // alte Werte lesen
          _C3 := nextp(EingabeL[m], ';', 3);
          _C4 := nextp(EingabeL[m], ';', 4);

          // �berhaupt eine Neuigkeit?
          if (C3<>_C3) or (C4<>_C4) then
          begin
            // Sicherstellen dass nicht �berschrieben wird
            if (C3='') then
              C3 := _C3;
            if (C4='') then
             C4 := _C4;

            // Patch!
            EingabeL[m] :=
              {Datum} nextp(sBilder[n], ';', 0) + ';' +
              {Uhr} nextp(sBilder[n], ';', 1) + ';' +
              { RID } RID + ';' +
              { C3 } C3 + ';' +
              { C4 } C4;
          end;
          PatchLine := true;
          break;
        end;
       if not(PatchLine) then
        EingabeL.Add(sBilder[n]);
     end;
    end;

  end;

  procedure logEingabeL_replace(sBilder: TStringList);
  {
    die RIDs aus den sBilder werden gesammelt und alle passenden Datens�tze
    aus der bestehenden Liste (EingabeL) gel�scht, dann wird sBilder einfach
    hinzugef�gt
  }
  var
    n: integer;
    NeueInfos: TgpIntegerList;
    AUFTRAG_R: integer;
  begin
    NeueInfos := TgpIntegerList.Create;

    // RIDs der neuen Bilder sammeln
    for n := 0 to pred(sBilder.count) do
      NeueInfos.add(strtointdef(nextp(sBilder[n], ';', 2), cRID_Null));
    NeueInfos.sort;

    // Die neuen Infos z�hlen, die alten Zeilen mit dem
    // selben RID werden gel�scht
    for n := pred(EingabeL.count) downto 0 do
    begin
      AUFTRAG_R := strtointdef(nextp(EingabeL[n], ';', 2), cRID_Null);
      if (AUFTRAG_R > cRID_Null) then
        if (NeueInfos.IndexOf(AUFTRAG_R) <> -1) then
          EingabeL.Delete(n);
    end;

    // Nun einfach unten dran machen!
    EingabeL.AddStrings(sBilder);
    NeueInfos.free;
  end;

  procedure logEingabeL_add(sBilder: TStringList);
  {
    wie logEingabeL_replace jedoch werden keine Daten �berschrieben sondern nur
    fehlende Eintr�ge nachgetragen!
  }
  var
    n: integer;
    BisherInfos: TgpIntegerList;
    AUFTRAG_R: integer;
  begin
    BisherInfos := TgpIntegerList.Create;

    // RIDs der neuen Eintr�ge sammeln
    for n := 0 to pred(EingabeL.count) do
      BisherInfos.add(strtointdef(nextp(EingabeL[n], ';', 2), cRID_Null));
    BisherInfos.sort;

    // sehen, ob es neue RIDs gibt, die bisher noch nicht da waren
    for n := 0 to pred(sBilder.count) do
    begin
      AUFTRAG_R := strtointdef(nextp(sBilder[n], ';', 2), cRID_Null);
      if (BisherInfos.IndexOf(AUFTRAG_R) = -1) then
        EingabeL.add(sBilder[n]);
    end;

    BisherInfos.free;
  end;

  procedure sortEingabeL;
  {
   sortieren nach Datum;Uhr;RID
  }
  var
    ClientSorter: TStringList;
    EingabeL_Sorted: TStringList;
    WechselDatum: TANFiXDate;
    n, m: integer;
    AutomataState: integer;
    Stichtag: TANFiXDate;
  begin

    EingabeL_Sorted := TStringList.Create;
    ClientSorter := TStringList.Create;
    Stichtag := DatePlus(DateGet, -cMaxAge_Foto);

    for n := 0 to pred(EingabeL.count) do
      ClientSorter.addobject(
        // Datum als JJJJMMTT
        inttostrN(Date2Long(nextp(EingabeL[n], ';', 0)), 8) + '-' +
        // Uhrzeit (ist schon sortierf�hig!)
        nextp(EingabeL[n], ';', 1) + '-' +
        // RID im 3. Rang
        nextp(EingabeL[n], ';', 2), Pointer(n));
    ClientSorter.sort;

    AutomataState := 0;
    for n := 0 to pred(ClientSorter.count) do
    begin
      m := integer(ClientSorter.objects[n]);
      case AutomataState of
        0:
          begin
            WechselDatum := Date2Long(nextp(EingabeL[m], ';', 0));
            if (WechselDatum >= Stichtag) then
            begin
              AutomataState := 1;
              EingabeL_Sorted.add(EingabeL[m]);
            end;
          end;
        1:
          begin
            EingabeL_Sorted.add(EingabeL[m]);
          end;
      end;
    end;

    RemoveDuplicates(EingabeL_Sorted);
    EingabeL.Assign(EingabeL_Sorted);
    EingabeL_Sorted.free;
    ClientSorter.free;
  end;

var
  StartTime: int64;

begin
  // Create Info-File "proceed"
  FileAlive(pAppServicePath + cAppService_Proceed);

  StartTime := RDTSCms;
  ErrorCount := 0;
  result := TStringList.Create;

  // ermittlung des "TAN"-Parameters
  AktTrn := sParameter.values['TAN'];
  if (AktTrn = '') then
    if (sParameter.count > 0) then
      AktTrn := sParameter[1];

  // Nur den neuen Auftrag aktualisieren
  proceed_refresh := (sParameter.Values['REFRESH']=cIni_Activate);

  try

    if Option_Console then
    begin
     if proceed_refresh then
      write('aktualisiere TAN ' + AktTrn + ' ... ')
     else
      write('verarbeite TAN ' + AktTrn + ' ... ');
    end;
    ClearStat;
    LastTrnNo := '?';
    GeraeteNo := '?';
    OldTrn := '';

    //
    OrgaMonPlanungsVolumen := TgpIntegerList.Create;
    OrgaMonFertig := TgpIntegerList.Create;
    OrgaMonAbgearbeitet := TgpIntegerList.Create;

    MondaStay := TStringList.Create;
    MondaBaustellen := TStringList.Create;
    GoodMonteurL := TStringList.Create;
    ProtocolL := TStringList.Create;
    ProtocolAll := TStringList.Create;
    Einstellungen := TStringList.Create;
    Auftrag := TStringList.Create;
    JondaAll := TSearchStringList.Create;
    sOrgaMonErgebnis := TStringList.Create;

    // Foto-Sachen
    BilderAll := TStringList.Create;
    BilderAll_WechselMomentKorrigiert := TStringList.Create;
    EingabeL := TStringList.Create;

    bOrgaMonAuftrag := TBLager.Create;
    bFotoErgebnis := TBLager.Create;

    WechselmomentKorrektur := TgpIntegerList.Create;

    repeat

      // Wer (welches Ger�t) hat eigentlich gerufen
      GeraeteNo := detectGeraeteNummer(pAppServicePath + AktTrn);
      if (GeraeteNo = '') then
      begin
        log(cERRORText + ' 1433:"' + pAppServicePath + AktTrn + '\nnn.zip" fehlt!');
        inc(ErrorCount);
        break;
      end;

      BeginAction(AktTrn + ':' + GeraeteNo);

      // zentral wichtiges "Verarbeitungsdatum"
      // fest gesetzt auf einen vergangenen Wert k�nnen Fehler reproduziert werden
      if not(DebugMode) then
      begin
        _DateGet := FDate(pAppServicePath + AktTrn + PathDelim + GeraeteNo + cZIPExtension);
        _SecondsGet := FSeconds(pAppServicePath + AktTrn + PathDelim + GeraeteNo + cZIPExtension);
      end else
      begin
        _DateGet := DateGet;
        _SecondsGet := SecondsGet;
      end;

      // MI! DO FR SA SO MO*
      // Eingaben vom Mittwoch werden auf das heutige Datum korrigiert!
      _DatumWechselTimeOut := DatePlus(_DateGet, -4);

      _DateGetTimeOut := DatePlus(_DateGet, -13);

      // Parameter f�r diesen Lauf auswerten
      if FileExists(pAppServicePath + cGeraeteEinstellungen + GeraeteNo + '.ini') then
        Einstellungen.LoadFromFile(pAppServicePath + cGeraeteEinstellungen + GeraeteNo + '.ini');

      // Optionen setzen
      with Einstellungen do
      begin
       proceed_EinfacheListe := (values[cServerOption_EinfacheListe] = cIni_Activate);
       proceed_ProtokollPfad := values[cServerOption_ProtokollPfad];
      end;

      // den neuesten Stand aller Auftragsdateien aus dem
      // FTP-Verzeichnis holen - wenn nicht schon vorhanden!
      if not(InitTrn(GeraeteNo, AktTrn)) then
      begin
        log(cERRORText + ' 936:InitTrn(' + GeraeteNo + ',' + AktTrn + ') fail!');
        inc(ErrorCount);
        break;
      end;

      // abgearbeitete Laden
      if FileExists(pAppServicePath + AktTrn + PathDelim + cMonDaServer_AbgearbeitetFName) then
      begin
        OrgaMonAbgearbeitet.LoadFromFile(pAppServicePath + AktTrn + PathDelim + cMonDaServer_AbgearbeitetFName);
        Stat_OrgaMonGruen := OrgaMonAbgearbeitet.count;
      end;

      // JonDaServer kennt die UpLoad-Dateien, die
      // vom OrgaMon noch nicht ber�cksichtigt sind. Solange OrgaMon
      // diese "unber�cksichtigen" noch nicht verarbeitet hat, muss
      // JonDaServer seine eigenen Schl�sse daraus ziehen.
      //
      // Abgearbeitete der anderen Monteure und anderen TAN laden
      if FileExists(pAppServicePath + AktTrn + PathDelim + cMonDaServer_UnberuecksichtigtFName) then
        addPending;
      Stat_OrgaMonPending := OrgaMonAbgearbeitet.count - Stat_OrgaMonGruen;

      // Abgezogene laden
      addAbgezogene;

      // "Weiter-Versuche-Marker" l�schen, damit der Weg f�r eine neue TAN frei wird.
      //
      FileDelete(FolgeTRNFName(GeraeteNo));

      // aktueller Upload + Info aus .\<ehemaliger TAN>\AUFTRAG + Stand des Handy zusammenbauen
      if FileExists(UpFName(AktTrn)) then
      begin

        // Settings auswerten!
        LoadStringsFromFileUTF8(JondaAll, UpFName(AktTrn));
        if (JondaAll.count = 0) then
        begin
          log(cWARNINGText + ' 1211:' +
            'Eingangsdaten sind nicht korrekt UTF-8 kodiert, Vermute ANSI und kodiere um ...');
          FileCopy(UpFName(AktTrn), UpFName(AktTrn) + '.Backup');

          // danger: Modify original User Data
          FileRemoveBOM(UpFName(AktTrn));
          JondaAll.LoadFromFile(UpFName(AktTrn)
{$IFNDEF fpc}
            , TEncoding.ANSI
{$ENDIF}
            );
          JondaAll[0] := cutblank(JondaAll[0]);

          // danger: Overwrite original User Data
          SaveStringsToFileUTF8(JondaAll, UpFName(AktTrn));

        end;

        RemoteRev := strtodouble(JondaAll.values['VERSION']);
        LastTrnNo := JondaAll.values['TAN'];
        Optionen := JondaAll.values['OPTIONEN'];
        IMEI := JondaAll.values['IMEI'];
        NAME := JondaAll.values['NAME'];
        BEZAHLT_BIS := Date2Long(JondaAll.values['BEZAHLT_BIS']);

        if proceed_refresh then
        begin
          // da es nur um einen auftrags-Refresh geht:
          // Nicht nochmal die Eingangsdaten verarbeiten
          JonDaAll.Clear;
        end else
        begin
          // nun alle Setting-Lines entfernen
          if (JondaAll.count > 0) then
            while (pos(';', JondaAll[0]) = 0) do
            begin
              JondaAll.Delete(0);
              if JondaAll.count = 0 then
                break;
            end;
        end;

        // bei aufeinanderfolgenden Meldungen zu identischen RIDs immer die letzte Meldung nehmen
        for n := pred(JondaAll.count) downto 1 do
          if (pos('-1;', JondaAll[n]) <> 1) then
            if nextp(JondaAll[n], ';', 0) = nextp(JondaAll[pred(n)], ';', 0) then
              JondaAll.Delete(pred(n));

        // versehentlich doppelt �bertragene Datens�tze l�schen
        JondaAll.sort;
        RemoveDuplicates(JondaAll);

        // jetzt noch alle "relevanten" Meldungen hinzu!
        if (GeraeteNo <> '000') then
          MergeMeldung;

        // Es wird nun die urspr�ngliche AUFTRAG.DAT des Handys rekonstruiert
        assignFile(f_OrgaMonApp_Ergebnis, pAppServicePath + AktTrn + PathDelim + cMDEFNameMde);
        try
          rewrite(f_OrgaMonApp_Ergebnis);
        except
          on E: Exception do
            log(cERRORText + ' 1058:' + E.Message);
        end;

        // Alle App-"Auftrags-Kopieen"/"Neuanlagen" -> OrgaMon
        fillchar(mderec, sizeof(mderec), 0);
        for n := pred(JondaAll.count) downto 0 do
          if (pos('-1;', JondaAll[n]) = 1) then
          begin

            sOrgaMonErgebnis.add(JondaAll[n]);
            with mderec do
            begin

              // Originalzeile laden, MS-DOS Zeichsatz simulieren!
              OneJLine := WebToMdeRecString(JondaAll[n]);

              // nun die einzelnen Felder f�llen
              RID := strtointdef(nextp(OneJLine, ';'), -1);
              Baustelle := GeraeteNo;
              zaehlernummer_korr := toZaehlerNummerType(nextp(OneJLine, ';'));
              zaehlernummer_neu := toZaehlerNummerType(nextp(OneJLine, ';'));
              zaehlerstand_neu := nextp(OneJLine, ';');
              zaehlerstand_alt := nextp(OneJLine, ';');
              Reglernummer_korr := toZaehlerNummerType(nextp(OneJLine, ';'));
              Reglernummer_neu := toZaehlerNummerType(nextp(OneJLine, ';'));
              JProtokoll := nextp(OneJLine, ';');
              ersetze(cJondaProtokollDelimiter, ';', JProtokoll);
              if (length(JProtokoll) > 254) then
                log(cWARNINGText + ' 1259:' + 'Protokollfeld zu lange, Eintr�ge gehen verloren!');
              ProtokollInfo := JProtokoll;
              ausfuehren_ist_datum := strtointdef(nextp(OneJLine, ';'), cMonDa_Status_unbearbeitet);
              ausfuehren_ist_uhr := strtointdef(nextp(OneJLine, ';'), 0);
              Monteur_Info := OneJLine;

            end;
            inc(Stat_SelbstAnlagen);
            write(f_OrgaMonApp_Ergebnis, mderec);
            JondaAll.Delete(n);
          end;

        repeat

          // "AUFTRAG.DAT" aus letzter Tan
          JAuftragBisherFName := pAppServicePath + LastTrnNo + PathDelim + cMDEFNameMde;
          if FileExists(JAuftragBisherFName) then
            break;

          // "AUFTRAG.DAT" aus globaler Ablage
          JAuftragBisherFName := AuftragPath + 'AUFTRAG.' + GeraeteNo + cDATExtension;
          if FileExists(JAuftragBisherFName) then
            break;

          JAuftragBisherFName := '';

        until yet;

        // nun alle Datens�tze aus der alten TRN r�berkopieren!
        if (JAuftragBisherFName <> '') then
        begin
          //
          assignFile(f_OrgaMonApp_NeuerAuftrag, JAuftragBisherFName);
          try
            reset(f_OrgaMonApp_NeuerAuftrag);
          except
            on E: Exception do
              log(cERRORText + ' 1114:' + E.Message);
          end;
          Stat_Bisher := FileSize(f_OrgaMonApp_NeuerAuftrag);
          for n := 0 to pred(Stat_Bisher) do
          begin
            read(f_OrgaMonApp_NeuerAuftrag, mderec);

            // die Eingaben des Monteurs jedoch �bernehmen (wenn vorhanden!)
            with mderec do
            begin
              if (RID > 0) then
              begin
                k := JondaAll.FindInc(inttostr(RID) + ';');
                if (k <> -1) then
                begin
                  sOrgaMonErgebnis.add(JondaAll[k]);

                  OneJLine := WebToMdeRecString(JondaAll[k]);
                  { RID := }
                  nextp(OneJLine, ';');
                  zaehlernummer_korr := toZaehlerNummerType(nextp(OneJLine, ';'));
                  zaehlernummer_neu := toZaehlerNummerType(nextp(OneJLine, ';'));
                  zaehlerstand_neu := nextp(OneJLine, ';');
                  zaehlerstand_alt := nextp(OneJLine, ';');
                  Reglernummer_korr := toZaehlerNummerType(nextp(OneJLine, ';'));
                  Reglernummer_neu := toZaehlerNummerType(nextp(OneJLine, ';'));
                  JProtokoll := nextp(OneJLine, ';');
                  ersetze(cJondaProtokollDelimiter, ';', JProtokoll);
                  if (length(JProtokoll) > 254) then
                    log(cWARNINGText + ' 1324:' + 'Protokollfeld zu lange, Eintr�ge gehen verloren!');
                  ProtokollInfo := JProtokoll;
                  ausfuehren_ist_datum := strtointdef(nextp(OneJLine, ';'), cMonDa_Status_unbearbeitet);
                  ausfuehren_ist_uhr := strtointdef(nextp(OneJLine, ';'), 0);
                  JondaAll.Delete(k);
                end;
              end;
            end;
            write(f_OrgaMonApp_Ergebnis, mderec);
          end;
          Stat_Bisher := 0;
          CloseFile(f_OrgaMonApp_NeuerAuftrag);
        end;

        if (Optionen = 'Foto') then
        begin

          // Jetzt alle Unber�cksichtigten+Merge aus JonDaAll in MonDaE
          for n := 0 to pred(JondaAll.count) do
          begin
            OneJLine := WebToMdeRecString(JondaAll[n]);
            iRID := strtointdef(nextp(OneJLine, ';'), 0);
            if (iRID > 0) then
            begin
              sOrgaMonErgebnis.add(JondaAll[n]);

              // die Eingaben des Monteurs jedoch �bernehmen!
              fillchar(mderec, sizeof(mderec), 0);
              with mderec do
              begin
                RID := iRID;
                ausfuehren_soll := cMonDa_FreieTerminWahl;

                zaehlernummer_korr := toZaehlerNummerType(nextp(OneJLine, ';'));
                zaehlernummer_neu := toZaehlerNummerType(nextp(OneJLine, ';'));
                zaehlerstand_neu := nextp(OneJLine, ';');
                zaehlerstand_alt := nextp(OneJLine, ';');
                Reglernummer_korr := toZaehlerNummerType(nextp(OneJLine, ';'));
                Reglernummer_neu := toZaehlerNummerType(nextp(OneJLine, ';'));
                JProtokoll := nextp(OneJLine, ';');
                ersetze(cJondaProtokollDelimiter, ';', JProtokoll);
                if (length(JProtokoll) > 254) then
                  log(cWARNINGText + ' 1365:' + 'Protokollfeld zu lange, Eintr�ge gehen verloren!');
                ProtokollInfo := JProtokoll;
                ausfuehren_ist_datum := strtointdef(nextp(OneJLine, ';'), cMonDa_Status_unbearbeitet);
                ausfuehren_ist_uhr := strtointdef(nextp(OneJLine, ';'), 0);
              end;
              write(f_OrgaMonApp_Ergebnis, mderec);
            end;
          end;

        end
        else
        begin

          // Jetzt alle Unber�cksichtigten+Merge aus JonDaAll in die abgearbeiteten hinzu!
          for n := 0 to pred(JondaAll.count) do
          begin
            iRID := strtointdef(nextp(JondaAll[n], ';', 0), 0);
            if (iRID > 0) then
            begin
              inc(Stat_IgnoriertFehlenderAuftrag);
              dFertig := strtointdef(nextp(JondaAll[n], ';', 8), 0);
              if (dFertig > 0) then
                if (OrgaMonAbgearbeitet.IndexOf(iRID) = -1) then
                  OrgaMonAbgearbeitet.add(iRID);
            end;
          end;
        end;

        CloseFile(f_OrgaMonApp_Ergebnis);
      end;

      if not(proceed_refresh) then
      begin
        log('Monteur ' + NAME);
        log('LastTrn ' + LastTrnNo);
        log('OrgaMon-App Rev. ' + RevToStr(RemoteRev));
        log('IMEI ' + IMEI);
      end;

      { Quell-Datei vorhanden? }
      if not(FileExists(pAppServicePath + AktTrn + PathDelim + cMDEFNameMde)) then
      begin
        EndAction(cWARNINGText + ' "' + pAppServicePath + AktTrn + PathDelim+cMDEFNameMde+'" fehlt!');
        FileEmpty(pAppServicePath + AktTrn + PathDelim + cMDEFNameMde);
      end;

      if not(DebugMode) then
        FileDelete(pAppServicePath + AktTrn + '\MONDA.DAT');

      if not(FileExists(pAppServicePath + AktTrn + '\MONDA.DAT')) then
        ReNameFile(
         {} pAppServicePath + AktTrn + PathDelim + cMDEFNameMde,
         {} pAppServicePath + AktTrn + '\MONDA.DAT');

      // Foto-Datei
      bFotoErgebnis.Init(AuftragPath + 'FOTO+TS', mderec, sizeof(TMdeRec));
      bFotoErgebnis.BeginTransaction(long2datetime(_DateGet));

      // aktuelle, neue OrgaMon Daten f�rs Ger�t
      assignFile(f_OrgaMon_Auftrag, pAppServicePath + AktTrn + PathDelim + GeraeteNo + cDATExtension);
      try
        reset(f_OrgaMon_Auftrag);
      except
        on E: Exception do
          log(cERRORText + ' 1235:' + E.Message);
      end;

      // an OrgaMon gemeldete Ergebnisse
      assignFile(fOrgaMonErgebnis, pAppServicePath + AktTrn + PathDelim + AktTrn + cDATExtension);
      try
        rewrite(fOrgaMonErgebnis);
      except
        on E: Exception do
          log(cERRORText + ' 1249:' + E.Message);
      end;

      // aktuelle MonDa Daten
      if (OldTrn <> '') then
      begin
        FileConcat(
          { } pAppServicePath + AktTrn + '\MONDA.DAT',
          { } pAppServicePath + OldTrn + '\MONDA.DAT',
          { } pAppServicePath + AktTrn + '\MONDA' + cTmpFileExtension);
        FileCopy(
          { } pAppServicePath + AktTrn + '\MONDA' + cTmpFileExtension,
          { } pAppServicePath + AktTrn + '\MONDA.DAT');
      end;

      assignFile(f_OrgaMonApp_Ergebnis, pAppServicePath + AktTrn + '\MONDA.DAT');
      try
        reset(f_OrgaMonApp_Ergebnis);
      except
        on E: Exception do
          log(cERRORText + ' 1256:' + E.Message);
      end;
      Stat_Bisher := FileSize(f_OrgaMonApp_Ergebnis);

      // neue, kommende JonDa-Daten!
      assignFile(f_OrgaMonApp_NeuerAuftrag, pAppServicePath + AktTrn + PathDelim + cMDEFNameMde);
      try
        rewrite(f_OrgaMonApp_NeuerAuftrag);
      except
        on E: Exception do
          log(cERRORText + ' 1276:' + E.Message);
      end;

      assignFile(MonDaAasTxt, pAppServicePath + AktTrn + '\auftrag' + cTmpFileExtension);
      try
        rewrite(MonDaAasTxt);
      except
        on E: Exception do
          log(cERRORText + ' 1286:' + E.Message);
      end;

      // hey, hartn�ckige MonDa Daten, die bleiben auf dem Ger�t
      assignFile(MonDaA_StayF, pAppServicePath + AktTrn + '\STAY.DAT');
      try
        rewrite(MonDaA_StayF);
      except
        on E: Exception do
          log(cERRORText + ' 1296:' + E.Message);
      end;

      // hoh, diese Daten wurden in den Unm�glich-Zwang �bergeben!
      assignFile(MonDaA_LostF, pAppServicePath + AktTrn + '\LOST.DAT');
      try
        rewrite(MonDaA_LostF);
      except
        on E: Exception do
          log(cERRORText + ' 1305:' + E.Message);
      end;

      { erst mal die neuen RIDs sammeln! }
      { das sind die, welche vom OrgaMon auf dem Ger�t gesehen werden }
      { sollen. }
      bOrgaMonAuftrag.Init(AuftragPath + 'AUFTRAG+TS', mderec, sizeof(TMdeRec));
      bOrgaMonAuftrag.BeginTransaction(long2datetime(_DateGet));
      EntryPointReached := false;
      for m := 1 to FileSize(f_OrgaMon_Auftrag) do
      begin

        read(f_OrgaMon_Auftrag, mderec);

        // imp pend:
        // nur dann schreiben, wenn die Generation des Rec
        // neuer ist als die Vorhandene
        with bOrgaMonAuftrag do
        begin
          if exist(mderec.RID) then
            put(sizeof(TMdeRec))
          else
            insert(mderec.RID, sizeof(TMdeRec));
        end;

        // Die "Vorlagen" m�ssen immer ganz an den Anfang!
        if (mderec.ausfuehren_soll = cMonDa_ImmerAusfuehren) then
        begin
          add_OrgaMonApp_NeuerAuftrag;
          OrgaMonFertig.add(mderec.RID);
          GoodMonteurL.add(mderec.monteur);
        end;

        if (mderec.ausfuehren_soll = cMonDa_FreieTerminWahl) or (mderec.ausfuehren_soll >= _DateGet) or EntryPointReached
        then
        begin
          //
          // ist es eine aktuelle News von OrgaMon -> beibehalten
          //
          OrgaMonPlanungsVolumen.add(mderec.RID);
          GoodMonteurL.add(mderec.monteur);
          EntryPointReached := true;
        end;

        // Fertige d�rfen entg�ltig nicht mehr auf das Ger�t
        if isFertig then
          OrgaMonFertig.add(mderec.RID);

      end;
      bOrgaMonAuftrag.EndTransaction;
      GoodMonteurL.sort;
      RemoveDuplicates(GoodMonteurL);
      seek(f_OrgaMon_Auftrag, 0);

      { gelieferte Daten (AUFTRAG.DAT) der OrgaMon-App verarbeiten }
      if not(proceed_ArbeitIgnorieren) then
        for m := 1 to FileSize(f_OrgaMonApp_Ergebnis) do
        begin

          // Bearbeitete Daten durchsuchen!
          read(f_OrgaMonApp_Ergebnis, mderec); { MONDA.DAT }
          if (mderec.RID = 0) then
            continue;

          // Zeitpunkt pr�fen
          if (mderec.ausfuehren_ist_datum > cMonDa_Status_unbearbeitet) then
          begin
            // Bearbeitung liegt in der Zukunft?
            if (mderec.ausfuehren_ist_datum > _DateGet) or
            // Bearbeitung liegt allzuweit in der Vergangenheit?
              (mderec.ausfuehren_ist_datum < _DatumWechselTimeOut) then
            begin
              inc(Stat_AusfuehrungsMomentKorrektur);
              WechselmomentKorrektur.add(mderec.RID);

              // Auf "heute" 12:00:00 h umstellen!
              mderec.ausfuehren_ist_datum := _DateGet;
              mderec.ausfuehren_ist_uhr := cNoon;
            end;
          end;

          // isTest, damit kann man Eingaben ignorieren!
          // z.B. Test-Eingabe "Th�ga" alle ignorieren!
          if isTest(GeraeteNo, mderec.RID, mderec.ausfuehren_ist_datum) then
          begin
            // Testeingabe, die nicht ber�cksichtigt werden kann
            mderec.ausfuehren_ist_datum := cMonDa_Status_unbearbeitet;
            inc(Stat_IgnoriertTest);
          end;

          //
          // unbearbeitete aus der Vergangenheit verfallen automatisch in den
          // Status Restant, hier wurde ja gar nichts gemacht!!!
          //
          if (mderec.ausfuehren_soll < _DateGet) and (mderec.ausfuehren_soll <> cMonDa_FreieTerminWahl) and
            (mderec.ausfuehren_ist_datum = cMonDa_Status_unbearbeitet) then
          begin
            inc(Stat_AutoRestant);
            mderec.ausfuehren_ist_datum := cMonDa_Status_Restant;
          end;

          //
          // Unerledigte, die jedoch
          // Protokoll-Infos haben bitte senden
          // -> es wird "Restant" eingetragen
          if (mderec.ausfuehren_ist_datum = cMonDa_Status_unbearbeitet) then
          begin
            if (noblank(mderec.ProtokollInfo) <> '') then
              mderec.ausfuehren_ist_datum := cMonDa_Status_Restant;
          end;

          //
          // jetzt entscheiden, was zu machen ist!
          //
          case mderec.ausfuehren_ist_datum of

            cMonDa_Status_Wegfall, cMonDa_Status_Info:
              begin
                { nix tun, "hands off" }
              end;

            cMonDa_Status_unbearbeitet:
              begin
                if (mderec.ausfuehren_soll = _DateGet) then
                begin
                  inc(Stat_Unbearbeitet);
                  SaveOneStay;
                end;
              end;

            cMonDa_Status_Restant:
              begin { Restant }

                if (mderec.ausfuehren_soll < _DateGetTimeOut) and
                // vor dem Timeout UND
                  (mderec.ausfuehren_soll <> cMonDa_ImmerAusfuehren) and
                // nicht "immer" Termin UND
                  (mderec.ausfuehren_soll <> cMonDa_FreieTerminWahl) and
                // nicht "freier" Termin UND
                  (mderec.ausfuehren_soll > 0) // �berhaupt ein Termin
                then
                begin

                  //
                  // Auto-Fall-Back
                  //
                  write(MonDaA_LostF, mderec);

                  mderec.ausfuehren_ist_datum := cMonDa_Status_FallBack;

                  inc(Stat_FallBack);

                  { melden! }
                  WriteOrgaMon;

                  with mderec do
                    log('FallBack: ' + Baustelle + ';' + zaehlernummer_alt + ';' + monteur + ';' + inttostr(RID) + ';' +
                      long2date(ausfuehren_soll) + ';' + BoolToStr(vormittags));

                end
                else
                begin

                  if (mderec.RID = -1) then
                  begin
                    WriteOrgaMon;
                  end
                  else
                  begin

                    { melden! }
                    inc(Stat_Restanten);
                    WriteOrgaMon;

                    //
                    // muss das Schreiben erzwungen werden, weil er
                    // von OrgaMon nicht mehr kommt?
                    // (Beispiel: Restanten!)
                    if (OrgaMonPlanungsVolumen.IndexOf(mderec.RID) = -1) then
                    begin

                      //
                      // zum Monda-Auftrag rausschreiben, da es vom OrgaMon
                      // nicht mehr kommt!
                      if not(proceed_RestantenLoeschen) and not(proceed_EinfacheListe) then
                        add_OrgaMonApp_NeuerAuftrag;

                    end
                    else
                    begin

                      //
                      // der Datensatz ist bekannt, er sollte jedoch (so) erhalten
                      // bleiben.
                      SaveOneStay;

                    end;
                  end;
                end;
              end;

            cMonDa_Status_Vorgezogen:
              begin

                inc(Stat_Vorgezogen);
                WriteOrgaMon;
                SaveOneStay; { ev. behalten }

              end;
            cMonDa_Status_Unmoeglich:
              begin

                inc(Stat_Unmoeglich);
                WriteOrgaMon;
                SaveOneStay; { ev. behalten }
              end;

            cMonDa_Status_NeuAnschreiben:
              begin

                inc(Stat_NeuAnschreiben);
                WriteOrgaMon;
                SaveOneStay;

              end;
          else
            //
            // !bearbeitet!
            //
            inc(Stat_Abgearbeitete);
            if (mderec.ausfuehren_soll = cMonDa_FreieTerminWahl) then
              if (OrgaMonAbgearbeitet.IndexOf(mderec.RID) = -1) then
                OrgaMonAbgearbeitet.add(mderec.RID);

            WriteOrgaMon;
            // ev. in die Stay-Liste, weil "vorgezogen" oder
            // "Restant" oder ...
            SaveOneStay;

          end;
        end;

      { nun neues hinterherschreiben! }
      EntryPointReached := false;
      for m := 1 to FileSize(f_OrgaMon_Auftrag) do
      begin

        //
        read(f_OrgaMon_Auftrag, mderec);
        if (mderec.ausfuehren_soll = cMonDa_ImmerAusfuehren) or (mderec.ausfuehren_soll = cMonDa_FreieTerminWahl) or
          (mderec.ausfuehren_soll >= _DateGet) or EntryPointReached then
        begin
          EntryPointReached := true;
          k := MondaStay.IndexOf(inttostr(mderec.RID));
          if (k = -1) then
          begin
            // den OrgaMon-Datensatz unver�ndert �bernehmen! Es gibt keine
            // sch�tzenswerte Monda-Daten, der OrgaMon-Datensatz ist MonDa unbekannt.
            add_OrgaMonApp_NeuerAuftrag;
          end
          else
          begin
            // Es gibt den Datensatz in der Stay-Liste sowie
            // in den Neuerungen von OrgaMon
            // aus der Stay-Datei den Datensatz holen
            seek(MonDaA_StayF, integer(MondaStay.objects[k]));
            read(MonDaA_StayF, mderec2);

            // Aus den Stay-Daten alle wichtigen MonDa-Anteile
            // mit den Neu-Meldungen von OrgaMon vermixen
            mderec.zaehlernummer_korr := mderec2.zaehlernummer_korr;
            mderec.zaehlernummer_neu := mderec2.zaehlernummer_neu;
            mderec.zaehlerstand_neu := mderec2.zaehlerstand_neu;
            mderec.zaehlerstand_alt := mderec2.zaehlerstand_alt;
            mderec.Reglernummer_korr := mderec2.Reglernummer_korr;
            mderec.Reglernummer_neu := mderec2.Reglernummer_neu;
            mderec.ProtokollInfo := mderec2.ProtokollInfo;
            mderec.ausfuehren_ist_datum := mderec2.ausfuehren_ist_datum;
            mderec.ausfuehren_ist_uhr := mderec2.ausfuehren_ist_uhr;

            add_OrgaMonApp_NeuerAuftrag;
          end;
        end;
      end;

      // Dateien schliessen
      CloseFile(f_OrgaMon_Auftrag);
      CloseFile(fOrgaMonErgebnis);

      SaveStringsToFileUTF8(sOrgaMonErgebnis,
        { } pAppServicePath + AktTrn + PathDelim + AktTrn + cUTF8DataExtension);
      CloseFile(f_OrgaMonApp_Ergebnis);
      CloseFile(f_OrgaMonApp_NeuerAuftrag);
      CloseFile(MonDaA_StayF);
      CloseFile(MonDaA_LostF);
      bFotoErgebnis.EndTransaction;

      MondaBaustellen.sort;
      RemoveDuplicates(MondaBaustellen);

      if (BilderAll.count > 0) or
         (BilderAll_WechselMomentKorrigiert.count > 0) then
      begin

        // Im aktuellen Verarbeitungs-Verzeichnis die aktuelle Eingabe.GGG.txt bereitstellen
        // Sie stellt die urspr�ngliche Wissensbasis dar. Beim ersten Durchlauf fehlt die
        // Datei - sie wird reinkopiert.
        FName := pAppServicePath + AktTrn + PathDelim + 'Eingabe.' + GeraeteNo + '.txt';
        if not(FileExists(FName)) then
        begin
          if FileExists(DataPath + 'Eingabe.' + GeraeteNo + '.txt') then
            FileCopy(
              { } DataPath + 'Eingabe.' + GeraeteNo + '.txt',
              { } FName)
          else
            FileAlive(FName);
        end;

        EingabeL.LoadFromFile(FName);

        if (BilderAll.count > 0) then
          logEingabeL_merge(BilderAll);

        if (BilderAll_WechselMomentKorrigiert.count > 0) then
          logEingabeL_add(BilderAll_WechselMomentKorrigiert);

        sortEingabeL;

        // Nun die ver�nderte Eingabe.txt sichern
        m := 0;
        repeat
          if (m = 0) then
            FName := pAppServicePath + AktTrn + PathDelim + 'Eingabe.' + GeraeteNo + '.Neu.txt'
          else
            FName := pAppServicePath + AktTrn + PathDelim + 'Eingabe.' + GeraeteNo + '.Neu-' + inttostr(m) + '.txt';
          inc(m);
        until not(FileExists(FName));

        // Save lokal
        EingabeL.SaveToFile(FName);
        // Overwrite global
        EingabeL.SaveToFile(DataPath + 'Eingabe.' + GeraeteNo + '.txt');

      end;

      // alle Zuordnungen ansehen, und die existierenden unter ihrem
      // realen Namen hinzunehmen.
      // Beispiel:  PLED3->PLE & PLED2->PLE : Es wird nur einmal "PLE"
      //            hinzugef�gt
      for m := 0 to pred(sProtokolle.count) do
      begin
        OneJLine := AnsiUpperCase(nextp(sProtokolle[m], cJondaProtokollDelimiter, 1));
        if (OneJLine <> '') then
          if (ProtocolAll.IndexOf(OneJLine) = -1) then
            ProtocolAll.add(OneJLine);
      end;

      // nun alle Protokolle anf�gen
      for m := 0 to pred(ProtocolAll.count) do
      begin
        ProtS := ProtocolAll[m];
        // der Doppelpunkt leitet Protokolle ein
        WriteJonDa(':' + ProtS);

        // Lade nun das ermittelte Protokoll
        try
          // Vorrangig aus dem "privaten" Verzeichnis
          repeat
            if (proceed_ProtokollPfad<>'') then
             if FileExists(pAppServicePath + cProtokollPath + proceed_ProtokollPfad + ProtocolAll[m] + cProtExtension) then
             begin
               ProtocolL.LoadFromFile(pAppServicePath + cProtokollPath + proceed_ProtokollPfad + ProtocolAll[m] + cProtExtension);
               break;
             end;
           ProtocolL.LoadFromFile(pAppServicePath + cProtokollPath + ProtocolAll[m] + cProtExtension);
          until yet;

        except
          on E: Exception do
            log(cERRORText + ' 2432:' + E.Message);
        end;

        // Schreibe es hinter den ":", verhindere aber weitere ":"
        for k := 0 to pred(ProtocolL.count) do
          if (length(ProtocolL[k]) > 0) then
            if (ProtocolL[k][1] <> ':') then
              WriteJonDa(ProtocolL[k]);
      end;

      // nun alle Ger�te-Optionen noch anf�gen, falls vorhanden
      // wird im Moment nicht ausgewertet
      if (Einstellungen.values[cServerOption_JonDaOptionen] <> '') then
      begin
        WriteJonDa(':' + 'OPTIONEN');
        WriteJonDa(Einstellungen.values[cServerOption_JonDaOptionen]);
      end;

      // nun alle (einmaligen) Ger�te-.\Kommandos
      if (RevIsFrom(RemoteRev, 2.016)) then
        if FileExists(pAppServicePath + cGeraeteKommandos + GeraeteNo + '.ini') then
        begin
          Einstellungen := TStringList.Create;
          Einstellungen.LoadFromFile(pAppServicePath + cGeraeteKommandos + GeraeteNo + '.ini');
          for k := 0 to pred(Einstellungen.count) do
            WriteJonDa('$' + Einstellungen[k]);
          Einstellungen.free;

          // Als verarbeitet markieren indem es nach AktTrn verschoben wird
          FileMove(
            { } pAppServicePath + cGeraeteKommandos + GeraeteNo + '.ini',
            { } pAppServicePath + AktTrn + PathDelim + GeraeteNo + '.ini');
        end;

      //
      CloseJonDa;

      // Alte Datei l�schen
      FileDelete(pAppServicePath + AktTrn + '\auftrag.txt');

      // Neue Auftr�ge bereitstellen
      repeat

        // IMEI �berhaupt g�ltig?
        if (tIMEI_OK.locate('IMEI', IMEI) = -1) then
        begin
          // Unbekanntes Handy
          log(cWARNINGText + ' Unbekanntes Handy!');
          FileCopy(pAppServicePath + cProtokollPath + 'Unbekannt' + cUTF8DataExtension, AuftragFName(AktTrn));
          Stat_PostError := 'unbekannt';
          break;
        end;

        // zu alte OrgaMon-App?
        if not(RevIsFrom(RemoteRev, cMinVersion_OrgaMonApp)) then
        begin
          // Programmversion ist zu alt!
          log(cWARNINGText + ' Programmversion ' + RevToStr(RemoteRev) + ' zu alt!');
          FileCopy(pAppServicePath + cProtokollPath + 'VersionNichtAusreichend' + cUTF8DataExtension,
            AuftragFName(AktTrn));
          Stat_PostError := 'veraltet';
          break;
        end;

        // Ger�tenummer gar nicht bekannt?
        if (GeraeteNo <> '000') then
          if (BEZAHLT_BIS = cMonDa_ErsteEingabe) then
          begin
            // Unbekannte Ger�tenummer
            log(cWARNINGText + ' Unbekannte Ger�tenummer!');
            FileCopy(
             {} pAppServicePath + cProtokollPath + 'Undefiniert' + cUTF8DataExtension,
             {} AuftragFName(AktTrn));
            Stat_PostError := 'undefiniert';
            break;
          end;

        // Vertragszeitraum nicht bezahlt?
        if (GeraeteNo <> '000') then
          if DateOK(BEZAHLT_BIS) and (_DateGet > BEZAHLT_BIS) then
          begin
            // Unbezahlt!
            log(cWARNINGText + ' Unbezahlter Zeitraum!');
            FileCopy(
             {} pAppServicePath + cProtokollPath + 'Unbezahlt' + cUTF8DataExtension,
             {} AuftragFName(AktTrn));
            FileTouch(AuftragFName(AktTrn));
            Stat_PostError := 'unbezahlt';
            break;
          end;

        // Auftrag.txt nun wirklich bereitstellen!
        ReNameFile(
         { } pAppServicePath + AktTrn + '\auftrag' + cTmpFileExtension,
         { } pAppServicePath + AktTrn + '\auftrag.txt');

      until yet;

      if (GeraeteNo <> '000') then
        if (Stat_Meldungen > 0) then
        begin

          // Sicherung ins "OrgaMon" Verzeichnis!
          FileCopy(
            { } pAppServicePath + AktTrn + PathDelim + AktTrn + cDATExtension,
            { } pAppServicePath + cOrgaMonDataPath + AktTrn + cDATExtension);

          // Web-Statistik anfertigen!
          if (Stat_FotoMeldungen > 0) then
            WebSite;
        end;

      if (Stat_OrgaMonGruen <> 0) or (Stat_OrgaMonPending <> 0) then
        log('OrgaMon gr�n  : ' + inttostr(Stat_OrgaMonGruen) + '+' + inttostr(Stat_OrgaMonPending));
      if (Stat_Bisher <> 0) then
        log('Bisher        : ' + inttostr(Stat_Bisher));
      if (Stat_Unbearbeitet <> 0) then
        log('Unbearbeitet  : ' + inttostr(Stat_Unbearbeitet));
      if (Stat_Abgearbeitete <> 0) then
        log('Abgearbeitete : ' + inttostr(Stat_Abgearbeitete));
      if (Stat_FotoMeldungen <> 0) then
        log('Fotomeldungen : ' + inttostr(Stat_FotoMeldungen));
      if (Stat_NeuAnschreiben <> 0) then
        log('NeuAnschr.    : ' + inttostr(Stat_NeuAnschreiben));
      if (Stat_Restanten <> 0) or (Stat_AutoRestant <> 0) then
        log('Restant/AutoR : ' + inttostr(Stat_Restanten) + '/' + inttostr(Stat_AutoRestant));
      if (Stat_FallBack <> 0) then
        log('Fallback      : ' + inttostr(Stat_FallBack));
      if (Stat_Unmoeglich <> 0) then
        log('Unm�glich     : ' + inttostr(Stat_Unmoeglich));
      if (Stat_Vorgezogen <> 0) then
        log('Vorgezogen    : ' + inttostr(Stat_Vorgezogen));
      if (Stat_FrischFertig <> 0) then
        log('Fertige -     : ' + inttostr(Stat_FrischFertig));
      if (Stat_Schlafmuetzen <> 0) then
        log('Schlafm�tzen  : ' + inttostr(Stat_Schlafmuetzen));
      if (Stat_AusfuehrungsMomentKorrektur <> 0) then
        log('Korrigiert    : ' + inttostr(Stat_AusfuehrungsMomentKorrektur));
      if (Stat_Abberufen <> 0) then
        log('Abberufen     : ' + inttostr(Stat_Abberufen));
      if (Stat_IgnoriertTest <> 0) or (Stat_IgnoriertFehlenderAuftrag <> 0) then
        log('Ignoriert     : ' + inttostr(Stat_IgnoriertTest) + '/' + inttostr(Stat_IgnoriertFehlenderAuftrag));
      if (Stat_MondaStay <> 0) then
        log('Stay-liste    : ' + inttostr(Stat_MondaStay));
      if (Stat_Meldungen <> 0) or (Stat_SelbstAnlagen <> 0) then
        log('->OrgaMon/Neu : ' + inttostr(Stat_Meldungen) + '/' + inttostr(Stat_SelbstAnlagen));
      if (Stat_MondaNeu <> 0) then
        log('->JonDa       : ' + inttostr(Stat_MondaNeu));
      log('Baustellen    : ' + HugeSingleLine(MondaBaustellen, ','));
      log('Protokolle    : ' + HugeSingleLine(sProtokolle, ' & '));

      assignFile(MonDaGeraetF, pAppServicePath + AktTrn + '\GERAET.DAT');
      try
        rewrite(MonDaGeraetF);
      except
        on E: Exception do
          log(cERRORText + ' 1633:' + E.Message);
      end;
      writeln(MonDaGeraetF, GeraeteNo);
      writeln(MonDaGeraetF, AktTrn);
      CloseFile(MonDaGeraetF);

      assignFile(MonDaGeraetF, DataPath + GeraeteNo + '.txt');
      try
        rewrite(MonDaGeraetF);
      except
        on E: Exception do
          log(cERRORText + ' 1644:' + E.Message);
      end;
      writeln(MonDaGeraetF, AktTrn);
      CloseFile(MonDaGeraetF);

    until yet;

    if (ErrorCount = 0) then
    begin
      if not(proceed_NoUpload) then
        if (GeraeteNo <> '000') then
        begin

          // Absichern des Ger�te-Volumens
          FileCopy(
           {} pAppServicePath + AktTrn + PathDelim + cMDEFNameMde,
           {} AuftragPath + 'AUFTRAG.' + GeraeteNo + cDATExtension);

          try
              if (FSize(pAppServicePath + AktTrn + PathDelim + AktTrn + cDATExtension) > 0) then
              begin
                // TAN Upload ...

                // ... als Bin�r-Datei
                if not(proceed_refresh) then
                  FileCopy(
                    { } pAppServicePath + AktTrn + PathDelim + AktTrn + cDATExtension,
                    { } pFTPPath + AktTrn + cDATExtension);

                // ... als Text
                if not(proceed_refresh) then
                  FileCopy(
                    { } pAppServicePath + AktTrn + PathDelim + AktTrn + cUTF8DataExtension,
                    { } pFTPPath + AktTrn + cUTF8DataExtension);

              end
              else
              begin
                if not(proceed_refresh) then
                 log('Unterlassener Upload aufgrund Ergebnislosigkeit bei TRN ' + AktTrn);
              end;

              // �ber das aktuelle Auftragsvolumen informieren
              FileCopy(
               { } pAppServicePath + AktTrn + PathDelim + cMDEFNameMde,
               { } pFTPPath + 'AUFTRAG.' + GeraeteNo + cDATExtension);

          except
            on E: Exception do
              log(cERRORText + ' 1470:' + E.Message);
          end;
        end;

      if Option_Console then
       if (ErrorCount=0) then
        writeln('OK')
       else
        writeln('ERROR');
    end;

    if not(proceed_refresh) then
      if proceed_EinfacheListe and (ErrorCount=0) then
      begin
        repeat

          // prepare "Senden" Parameter
          XMLRPC_Parameter := TStringList.Create;
          XMLRPC_Parameter.AddObject(GeraeteNo, TXMLRPC_Server.oString);

          XMLRPC_Result := nil;
          try
            // call "Senden"
            XMLRPC_Result := remote_exec(
             {} pXMLRPC_Host,
             {} pXMLRPC_Port,
             {} 'Senden',
             {} XMLRPC_Parameter);
            XMLRPC_Parameter.Free;
          except
           on E: Exception do
             log(
              { } cERRORText + ' 2780:' +
              { } pXMLRPC_Host + ':' + IntToStr(pXMLRPC_Port) + ' ' +
              { } E.Message);
          end;

          if (XMLRPC_Result=nil) then
          begin
            log(cERRORText + ' 2729:' + 'XMLRPC Senden = nil');
            break;
          end;

          if (XMLRPC_Result.count<1) then
          begin
            log(cERRORText + ' 2735:' + 'XMLRPC Senden: empty result');
            break;
          end;

          if (XMLRPC_Result.Objects[0]<>TXMLRPC_Server.oBoolean) then
          begin
            log(cERRORText + ' 2773:' + 'XMLRPC Senden: boolean result-type expected');
            break;
          end;

          if (XMLRPC_Result[0]<>TXMLRPC_Server.fromBoolean(true)) then
          begin
            log(cERRORText + ' 2747:' + 'XMLRPC Senden: ERROR');
            break;
          end;

          XMLRPC_Result.Free;

          // Aktuelle Meldungen wegsichern:
          if FileExists(pAppServicePath + AktTrn + PathDelim + AktTrn + cDATExtension) then
           RenameFile(pAppServicePath + AktTrn + PathDelim + AktTrn + cDATExtension,
           pAppServicePath + AktTrn + '\_' + AktTrn + cDATExtension);

          if FileExists(pAppServicePath + AktTrn + PathDelim + AktTrn + cUTF8DataExtension) then
           RenameFile(pAppServicePath + AktTrn + PathDelim + AktTrn + cUTF8DataExtension,
           pAppServicePath + AktTrn + '\_' + AktTrn + cUTF8DataExtension);

          // Auftragsvolumen mit den neuesten Erkenntnissen neu erstellen
          sParameter.Add('REFRESH=JA');
          proceed(sParameter);

        until yet;

      end;

    // Statistik:
    // Nach "SENDEN" Tabelle protokollieren
    // IMEI;NAME;ID;MOMENT;TAN;REV;ERROR;PAPERCOLOR
    if FileExists(DataPath + cAppService_SendenFName) then
    begin

      tSENDEN := TsTable.Create;
      with tSENDEN do
      begin
        InsertFromFile(DataPath + cAppService_SendenFName);

        // Alte Zeile l�schen
        n := -1;
        if (IMEI <> '') then
          n := locate('IMEI', IMEI)
        else
          n := locate('ID', GeraeteNo);
        if (n <> -1) then
          Del(n);

        // neue Zeile hinzu
        sSENDEN := TStringList.Create;
        with sSENDEN do
        begin
          { IMEI }
          add(IMEI);
          { NAME }
          add(NAME);
          { ID }
          add(GeraeteNo);
          { MOMENT }
          add(sTimeStamp);
          { TAN }
          add(AktTrn);
          { REV }
          add(RevToStr(RemoteRev));
          { ERROR }
          add(Stat_PostError);
          { PAPERCOLOR }
          if (Stat_PostError = '') then
            add('')
          else
            add('#C36241');
        end;
        addRow(sSENDEN);

        // Sortieren
        SortBy('descending MOMENT');

        // speichern
        SaveToHTML(pWebPath + 'senden.html');
        SaveToFile(DataPath + cAppService_SendenFName);
      end;
      tSENDEN.free;
    end;

    EndAction(GeraeteNo);

    OrgaMonPlanungsVolumen.free;
    OrgaMonFertig.free;
    OrgaMonAbgearbeitet.free;
    MondaStay.free;
    MondaBaustellen.free;
    GoodMonteurL.free;
    ProtocolL.free;
    ProtocolAll.free;
    Auftrag.free;
    JondaAll.free;
    sOrgaMonErgebnis.free;
    BilderAll.free;
    BilderAll_WechselMomentKorrigiert.free;
    EingabeL.free;
    bOrgaMonAuftrag.free;
    bFotoErgebnis.free;
    WechselmomentKorrektur.free;
    Einstellungen.free;

  except
    on E: Exception do
      log(cERRORText + ' 2481:' + E.Message);
  end;

  // defaults wiederherstellen
  proceed_NoUpload := false;

  if (ErrorCount=0) then
      result.addobject('0', TXMLRPC_Server.oInteger)
  else
      result.addobject('1', TXMLRPC_Server.oInteger);

  FileDelete(pAppServicePath + cAppService_Proceed);
end;

procedure TOrgaMonApp.readIni(SectionName: string = ''; Path: string = '');
var
  MyIni: TMemIniFile;
  RootPath : string;
begin

  // Root Path
  if (Path = '') then
    Path := MyProgramPath;
  pAppServicePath := Path;

  // Berechne Root
  RootPath := copy(pAppServicePath,1,pred(revPos(PathDelim,pAppServicePath)));
  RootPath := copy(RootPath,1,revPos(PathDelim,RootPath));

  MyIni := TMemIniFile.Create(pAppServicePath + cIniFNameConsole);
  with MyIni do
  begin
    if (SectionName = '') then
      SectionName := getParam('Id');
    if (SectionName = '') then
      SectionName := UserName;

    // ftpuser ist ein Mussfeld dessen Wert aber nicht verwendet wird
    if (ReadString(SectionName, 'ftpuser', '') = '') then
      SectionName := cGroup_Id_Default;
    MandantId := SectionName;

    iJonDa_Port := strtointdef(ReadString(SectionName, 'port', getParam('Port')), 3049);
    start_NoTimeCheck := ReadString(SectionName, 'NoTimeCheck', '') = cIni_Activate;

    // f�r remote "Senden"
    pXMLRPC_Host := ReadString(SectionName, 'XMLRPCHost', '');
    pXMLRPC_Port := StrToIntDef(ReadString(SectionName, 'XMLRPCPort', ''), 3042);

    // die ganzen Pfade (in der Regel nicht n�tig)
    // wenn die default Installationsvorgaben eingehalten werden
    pBackUpRootPath := ReadString(SectionName, 'BackUpPath', RootPath + 'bak\');
    pWebPath := ReadString(SectionName, 'WebPath', RootPath + 'web\');
    pFTPPath := ReadString(SectionName, 'FTPPath', RootPath + 'ftp\');
    DiagnosePath := ReadString(SectionName, 'LogPath', RootPath + 'log\');

  end;
  MyIni.Free;
end;

function TOrgaMonApp.start(sParameter: TStringList): TStringList;
var
  s: string;
  GeraetID, _GeraetID: string;
  _TAN: string;
  version, Optionen, UHR, IMEI, NAME: string;
  TAN: string;
  BEZAHLT_BIS: TANFiXDate;
  Einstellungen: TStringList; // vorbereitete Einstellungen f�r dieses Ger�t
  OptionStrings: TStringList;
  MomentDate: TANFiXDate;
  MomentTime: TANFiXTime;
  rDate: TANFiXDate;
  rSeconds: TANFiXTime;
  g, r: integer;
begin
  TAN := cERROR_TAN;
  result := TStringList.Create;
  Einstellungen := TStringList.Create;
  // vorbereitete Einstellungen f�r dieses Ger�t
  repeat

    // Testmethode
    if (start_StaticResult <> '') then
    begin
      result.add(start_StaticResult);
      start_StaticResult := '';
      break;
    end;

    MomentDate := DateGet;
    MomentTime := secondsget;

    try

      r := -1;
      g := -1;
      NAME := '';
      BEZAHLT_BIS := cMonDa_ErsteEingabe;
      s := '';
      GeraetID := sParameter.values['GERAET'];
      if (GeraetID = '') then
      begin
        if (sParameter.count > 0) then
          s := sParameter[1];
        GeraetID := nextp(s, ',');
        _TAN := nextp(s, ',');
        version := nextp(s, ',');
        Optionen := nextp(s, ',');
        UHR := nextp(s, ',');
        IMEI := nextp(s, ',');
      end
      else
      begin
        _TAN := sParameter.values['TAN'];
        version := sParameter.values['VERSION'];
        Optionen := sParameter.values['OPTIONEN'];
        UHR := sParameter.values['UHR'];
        IMEI := sParameter.values['IMEI'];
      end;

      repeat

        // Plausibilit�t der 3 stelligen "Ger�te-Nummer"
        if (length(StrFilter(GeraetID, '0123456789')) <> 3) then
        begin
          log(cWARNINGText + ' 2590:' + ' GERAET "' + GeraetID + '" falsch aufgebaut');
          TAN := 'Geraetenummer ist ungueltig';
          break;
        end;

        // Ger�t-bekannt?
        if (GeraetID <> '000') then
        begin

          // �ber die Ger�tenummer suchen
          g := tIMEI.locate('GERAET', GeraetID);
          if (g = -1) then
          begin
            log(cWARNINGText + ' 2775:' + ' GERAET "' + GeraetID + '" ist in der IMEI-Tabelle nicht bekannt');
            TAN := 'Geraetenummer ist ungueltig';
            break;
          end;

        end
        else
        begin

          // bei "000" �ber die IMEI den Namen bestimmen
          g := tIMEI.locate('IMEI', IMEI);
        end;

        // Setzen des Namens und des Bezahlt-Zeitraumes
        if (g <> -1) then
        begin
          NAME :=
          { } tIMEI.readCell(g, 'VORNAME') + ' ' +
          { } tIMEI.readCell(g, 'NACHNAME');
          BEZAHLT_BIS :=
          { } Date2Long(tIMEI.readCell(g, 'BEZAHLT_BIS'));
        end;

        // Plausibilit�t "IMEI-Nummer"
        if (length(IMEI) = 0) then
        begin

          log(cWARNINGText + ' 2344:' + ' IMEI ist leer - es verwendet GERAET "' + GeraetID + '"');
          TAN := 'Handy ist unbekannt';
          break;

        end
        else
        begin

          if (IMEI='null') then
           IMEI := '000000000000000';

          if (length(IMEI) <> 15) then
          begin
            log(
              { } cWARNINGText + ' 2616:' +
              { } ' IMEI "' + IMEI + '" hat keine 15 Stellen - es verwendet GERAET "' + GeraetID + '"');
            TAN := 'Dieses Handy ist unbekannt';
            break;
          end;

          if (length(IMEI) = 15) then
          begin
            r := tIMEI.locate('IMEI', IMEI);
            if (r = -1) then
            begin

              // IMEI �berhaupt g�ltig?
              if (tIMEI_OK.locate('IMEI', IMEI) = -1) then
              begin
                // Unbekanntes Handy
                log(
                  { } cWARNINGText + ' 2645:' +
                  { } ' IMEI "' + IMEI + '" ist unbekannt. (Ger�t "' + GeraetID + '")');
                TAN := 'Dieses Handy ist unbekannt';
                break;
              end
              else
              begin
                log(
                  { } cWARNINGText + ' 2624:' +
                  { } ' IMEI "' + IMEI +
                  { } '" hat keine feste Vertragszuordnung - es verwendet GERAET "' + GeraetID + '"');
              end;
            end
            else
            begin
              _GeraetID := tIMEI.readCell(r, 'GERAET');
              if (_GeraetID <> GeraetID) and (GeraetID <> '000') then
              begin
                log(cWARNINGText + ' 2662:' + ' Bei IMEI "' + IMEI + '" sollte GERAET "' + _GeraetID +
                  '" verwendet werden, ist aber GERAET "' + GeraetID + '"');
              end;
            end;
          end;
        end;

        // Einstellungen laden
        if FileExists(pAppServicePath + cGeraeteEinstellungen + GeraetID + '.ini') then
        begin
          Einstellungen.LoadFromFile(pAppServicePath + cGeraeteEinstellungen + GeraetID + '.ini');
          if (Einstellungen.values[cServerOption_ZeitPruefung] = cIni_Deactivate) then
            start_NoTimeCheck := true;
        end;

        // gr�ssere Zeitabweichung?
        if not(start_NoTimeCheck) then
        begin
          rDate := Date2Long(nextp(UHR, ' - ', 0));
          rSeconds := strtoSeconds(nextp(UHR, ' - ', 1));
          if SecondsDiffABS(DateGet, secondsget, rDate, rSeconds) > 60 * 5 then
          begin
            if (DateGet <> rDate) then
              TAN := 'Das Datum sollte ' + long2date(DateGet) + ' sein (Ist aber ' + long2date(rDate) + ').'
            else
              TAN := 'Die Uhrzeit sollte ' + secondstostr8(secondsget + 1) + ' sein (Ist aber ' + UHR + ').';
            break;
          end;
        end;
        start_NoTimeCheck := false;

        // TAN jetzt berechnen
        TAN := FolgeTAN(GeraetID);

        if not(FileExists(UpFName(TAN))) then
        begin
          // Erstmaliges �bertragen?!
          OptionStrings := TStringList.Create;
          with OptionStrings do
          begin
            add('TAN=' + _TAN);
            add('VERSION=' + version);
            add('OPTIONEN=' + Optionen);
            add('UHR=' + UHR);
            add('IMEI=' + IMEI);
            add('NAME=' + NAME);

            // Format: "26.09.2005 - 07:21:05"
            add('MOMENT=' + long2date(MomentDate) + ' - ' + secondstostr8(MomentTime));
            add('GERAET=' + GeraetID);
            AddStrings(Einstellungen);
            add('BEZAHLT_BIS=' + long2date(BEZAHLT_BIS));
          end;
          SaveStringsToFileUTF8(OptionStrings, UpFName(TAN));
          OptionStrings.free;
        end;

        // Sicherstellen, dass es die Ger�tenummer gibt.
        FileEmpty(pAppServicePath + TAN + PathDelim + GeraetID + '.zip');

      until yet;
    except
      on E: Exception do
        log(cERRORText + ' 2696:' + E.Classname + ': ' + E.Message);
    end;
  until yet;
  Einstellungen.free;
  result.add(TAN);
end;

function TOrgaMonApp.foto(sParameter: TStringList): TStringList;
var
  Baustelle: string;
  FotoBenennung: integer;
  FotoPrefix: string;
  FotoParameter: string;
  Zaehler_Info: string;
  zaehlernummer_neu: string;
  Reglernummer_neu: String;
  zaehlernummer_alt: string;
  FotoDateiNameNeu: string;
  FotoDateiNameBisher: string;
  NameOhneZaehlerNummerAlt: boolean;
  KeineZaehlerNummerNeuAmEnde: boolean;
  KeineReglerNummerNeuAmEnde: boolean;
  NameBereitsMitNeuPlatzhalter: boolean;
  UmbenennungAbgeschlossen: boolean;
  AUFTRAG_R: integer;
  Path: string;
  tNAMES: TsTable;
  sNAMES: TStringList;
  r,c: integer;
  FName: string;
  FreeFormat: string;
  Token, Value: string;
  WechselDatum: TANFiXDate;
  ZielBaustelle: string;
  Mandant, aknr: string;
  ReferenzDiagnose: TStringList;
  ShouldAbort: boolean;
  Optionen: TStringList;

  function Option(s:string):boolean;
  begin
    result := (Optionen.IndexOf(s)<>-1);
  end;

  procedure FatalError(s: string);
  begin
    if (result.values[cParameter_foto_Fehler] = '') then
      result.values[cParameter_foto_Fehler] := s
    else
      result.values[cParameter_foto_Fehler] := result.values[cParameter_foto_Fehler] + cLineSeparator + s;
    result.values[cParameter_foto_fertig] := cIni_Deactivate;
    ShouldAbort := true;
  end;

begin
  result := TStringList.Create;
  FotoDateiNameNeu := '';

  // cE_FotoBenennung
  FotoBenennung := strtointdef(sParameter.values[cParameter_foto_Modus], 0);
  Baustelle := sParameter.values[cParameter_foto_baustelle];
  ZielBaustelle := Baustelle;
  FotoParameter := sParameter.values[cParameter_foto_parameter];
  Zaehler_Info := sParameter.values[cParameter_foto_zaehler_info];
  Optionen := split(sParameter.values[cParameter_foto_Optionen]);

  // Limitierung mit der f�hrenden Null
  zaehlernummer_neu := FormatZaehlerNummerNeu(sParameter.values[cParameter_foto_Zaehlernummer_neu]);
  Reglernummer_neu := FormatZaehlerNummerNeu(sParameter.values[cParameter_foto_Reglernummer_Neu]);

  zaehlernummer_alt := sParameter.values[cParameter_foto_Zaehlernummer_alt];
  if (length(zaehlernummer_alt) > cMonDa_FieldLength_ZaehlerNummer) then
    zaehlernummer_alt := revCopy(
      { } zaehlernummer_alt,
      { } 1,
      { } cMonDa_FieldLength_ZaehlerNummer);

  //
  // Verzeichnis wo es Baustellen Unterverzeichnisse gibt f�r Modus=6
  Path := sParameter.values[cParameter_foto_Pfad];
  AUFTRAG_R := strtointdef(sParameter.values[cParameter_foto_RID], cRID_Null);
  sParameter.values[cParameter_foto_strasse] :=
  { } asci(
    { } StrassePostalisch(
    { } sParameter.values[cParameter_foto_strasse]));
  sParameter.values[cParameter_foto_ort] :=
  { } asci(
    { } OrtPostalisch(
    { } sParameter.values[cParameter_foto_ort]));
  FotoDateiNameBisher := sParameter.values[cParameter_foto_Datei];

  // Init
  FotoPrefix := '';
  UmbenennungAbgeschlossen := false;
  NameOhneZaehlerNummerAlt := false;
  KeineZaehlerNummerNeuAmEnde := false;
  KeineReglerNummerNeuAmEnde := false;
  NameBereitsMitNeuPlatzhalter := false;
  ShouldAbort := false;

  while true do
  begin

    case FotoBenennung of
      1:
        begin
          FotoPrefix :=
          { } sParameter.values[cParameter_foto_strasse] + ' ' +
          { } sParameter.values[cParameter_foto_ort];
          ersetze(' ', '_', FotoPrefix);
          FotoPrefix := FotoPrefix + '-';

        end;
      2:
        begin
          // CELL*
          FotoPrefix := Baustelle + '-';
        end;
      3:
        begin
          // RWTR*
          FotoPrefix := 'MaxAnzahl=12' + cProtokollTrenner;
        end;
      4:
        begin
          // ENW*
          FotoPrefix := 'MaxAnzahl=9' + cProtokollTrenner;
        end;
      5:
        begin
          // FH Bilder laufen in eine andere Baustelle
          if (pos('FH', FotoParameter) = 1) then
          begin
            ZielBaustelle := 'MVHA';
            FotoBenennung := 1;
            continue;
          end;

        end;
      6:
        begin
          // mit Hilfe von FotoBenennung.csv

          // default Umbenennung:
          // ====================
          // [ ~Mandant~ "-" ] [ ~aknr~ "-" ] ~~

          // v�llig freie Umbennung:
          // =======================
          //
          // Spalten�berschrift "??-Benennung"

          tNAMES := TsTable.Create;
          repeat

            if (Path = '') then
            begin
              FatalError(
                { } 'In diesem Modus muss ' + cParameter_foto_Pfad + '=' +
                { } ' gesetzt sein');
              break;
            end;

            FName := Path + Baustelle + PathDelim + cE_FotoBenennung + '.csv';
            if not(FileExists(FName)) then
            begin
              FatalError(
                { } 'Datei "' + FName + '"' +
                { } ' nicht gefunden');
              break;
            end;

            if DebugMode then
            begin
              result.values[cParameter_foto_definition_csv] := FName;
              result.values[cParameter_foto_definition_version] := dTimeStamp(FileTouched(FName));
            end;

            tNAMES.InsertFromFile(FName);
            r := tNAMES.locate(cRID_Suchspalte, inttostr(AUFTRAG_R));
            if (r <> -1) then
            begin

              FreeFormat := tNAMES.readCell(r, FotoParameter + '-Benennung');
              if (FreeFormat <> '') then
              begin
                FotoPrefix := FreeFormat;
                while (pos('~', FotoPrefix) > 0) do
                begin
                  Token := ExtractSegmentBetween(FotoPrefix, '~', '~');
                  if (Token='') then
                   break;
                  Value := '';
                  repeat

                    if (Token = 'TTMMJJJJ') then
                    begin

                      // 1.Rang: aus der Spalte Wechsel-Datum
                      WechselDatum := Date2Long(tNAMES.readCell(r, 'WechselDatum'));
                      if DateOK(WechselDatum) then
                      begin
                        Value := StrFilter(long2date(WechselDatum),cZiffern);
                        break;
                      end;

                      // 2.Rang: aus dem Datei-Datum der Bild-Datei
                      if (FotoDateiNameBisher = '') then
                      begin
                        FatalError('Wert "DATEI=" ist leer');
                        break;
                      end;
                      if FileExists(FotoDateiNameBisher) then
                      begin
                        Value := StrFilter(long2date(FileDate(FotoDateiNameBisher)), cZiffern);
                        break;
                      end;

                      // 3.Rang: aus dem Planungsdatum
                      WechselDatum := Date2Long(tNAMES.readCell(r, 'Datum'));
                      if DateOK(WechselDatum) then
                      begin
                        Value := StrFilter(long2date(WechselDatum),cZiffern);
                        break;
                      end;

                      // 4.Rang: einfach das aktuelle Datum
                      Value := StrFilter(long2date(DateGet),cZiffern);

                      break;
                    end;

                    if (Token = 'JJJJMMTT') then
                    begin

                      // 1.Rang: aus der Spalte Wechsel-Datum
                      WechselDatum := Date2Long(tNAMES.readCell(r, 'WechselDatum'));
                      if DateOK(WechselDatum) then
                      begin
                        Value := long2dateLog(WechselDatum);
                        break;
                      end;

                      // 2.Rang: aus dem Datei-Datum der Bild-Datei
                      if (FotoDateiNameBisher = '') then
                      begin
                        FatalError('Wert "DATEI=" ist leer');
                        break;
                      end;
                      if FileExists(FotoDateiNameBisher) then
                      begin
                        Value := long2dateLog(FileDate(FotoDateiNameBisher));
                        break;
                      end;

                      // 3.Rang: aus dem Planungsdatum
                      WechselDatum := Date2Long(tNAMES.readCell(r, 'Datum'));
                      if DateOK(WechselDatum) then
                      begin
                        Value := long2dateLog(WechselDatum);
                        break;
                      end;

                      // 4.Rang: einfach das aktuelle Datum
                      Value := long2dateLog(DateGet);

                      break;
                    end;

                    if (Token = 'TT.MM.JJJJ') then
                    begin

                      // 1.Rang: aus der Spalte Wechsel-Datum
                      WechselDatum := Date2Long(tNAMES.readCell(r, 'WechselDatum'));
                      if DateOK(WechselDatum) then
                      begin
                        Value := long2date(WechselDatum);
                        break;
                      end;

                      // 2.Rang: aus dem Datei-Datum der Bild-Datei
                      if (FotoDateiNameBisher = '') then
                      begin
                        FatalError('Wert "DATEI=" ist leer');
                        break;
                      end;
                      if FileExists(FotoDateiNameBisher) then
                      begin
                        Value := long2date(FileDate(FotoDateiNameBisher));
                        break;
                      end;

                      // 3.Rang: aus dem Planungsdatum
                      WechselDatum := Date2Long(tNAMES.readCell(r, 'Datum'));
                      if DateOK(WechselDatum) then
                      begin
                        Value := long2date(WechselDatum);
                        break;
                      end;

                      // 4.Rang: einfach das aktuelle Datum
                      Value := long2date(DateGet);

                      break;
                    end;

                    if (Token = 'wieFA') then
                    begin
                      FotoParameter := 'Ausbau';
                      { Value bleibt leer }
                      break;
                    end;

                    if (Token = 'wieFN') then
                    begin
                      FotoParameter := 'Einbau';
                      { Value bleibt leer }
                      break;
                    end;

                    if (Token = 'wieFE') then
                    begin
                      FotoParameter := 'Regler';
                      { Value bleibt leer }
                      break;
                    end;

                    if (Token = '-Neu-ist-OK') or (Token = 'ohne-Neu') then
                    begin
                      UmbenennungAbgeschlossen := true;
                      { Value bleibt leer }
                      break;
                    end;

                    if (Token = 'ohne-Z#Alt') or (Token = 'FN-Kurz') then
                    begin
                      NameOhneZaehlerNummerAlt := true;
                      { Value bleibt leer }
                      break;
                    end;

                    if (Token = 'ohne-Z#Neu') then
                    begin
                      KeineZaehlerNummerNeuAmEnde := true;
                      { Value bleibt leer }
                      break;
                    end;

                    if (Token = 'ohne-R#Neu') then
                    begin
                      KeineReglerNummerNeuAmEnde := true;
                      { Value bleibt leer }
                      break;
                    end;

                    if (Token = '#') then
                    begin
                      // Berechnungsparameter
                      Value := IntToStr(
                       BisherGeliefert(
                        {Id} IntToStr(AUFTRAG_R)+ '-' +
                             sParameter.values[cParameter_foto_parameter] ,
                        {Merkmal} dTimeStamp(FileTouched(FotoDateiNameBisher)) + ' ' +
                                  IntToStr(FSize(FotoDateiNameBisher))));
                      break;
                    end;

                    // Wert aus einer anderen Spalte
                    c := tNAMES.colof(Token);
                    // gibt es den Spalten-Namen?
                    if (c = -1) then
                    begin
                     FatalError('Spalte "' + Token + '" nicht gefunden');
                     break;
                    end else
                    begin
                     Value := tNAMES.readCell(r, c);
                    end;

                    // normale "Neu" Logik bei der Spalte "ZaehlerNummerNeu" ...
                    if (Token='ZaehlerNummerNeu') or (Token='ReglerNummerNeu') then
                    begin
                     if (Value<>'') then
                     begin
                      if Option(cFoto_Option_NeuLeer) then
                        Value := '';
                     end else
                     begin
                       Value := cFotoService_NeuPlatzhalter;
                       NameBereitsMitNeuPlatzhalter := true;
                     end;
                    end;

                  until yet;
                  ersetze('~' + Token + '~', Value, FotoPrefix);
                end;

              end
              else
              begin

                // default Verhalten mit 4 M�glichkeiten, automatisch je nachdem was bef�llt ist
                //
                // 1) <Leer>
                // 2) ~Mandant~-
                // 3) ~Mandant~-~aknr~-
                // 4) ~aknr~-
                //
                Mandant := cutblank(tNAMES.readCell(r, 'Mandant'));
                aknr := cutblank(tNAMES.readCell(r, 'aknr'));

                if (Mandant <> '') then
                  FotoPrefix := Mandant + '-'
                else
                  FotoPrefix := '';

                if (aknr <> '') then
                  FotoPrefix := FotoPrefix + aknr + '-';

              end;
            end
            else
            begin
              result.values[cParameter_foto_Fehler] :=
              { } 'RID "' + inttostr(AUFTRAG_R) + '"' +
              { } ' in Datei "' + FName + '"' +
              { } ' in Spalte "' + cRID_Suchspalte + '" ' +
              { } ' nicht gefunden!';
              FotoPrefix := 'ERROR' + '-';

              // Diagnose
              if DebugMode then
                if FileAge(Path + Baustelle + '-' + cRID_Suchspalte + '.csv') < FileAge(FName) then
                begin
                  ReferenzDiagnose := tNAMES.Col(tNAMES.colof(cRID_Suchspalte));
                  ReferenzDiagnose.SaveToFile(Path + Baustelle + '-' + cRID_Suchspalte + '.csv');
                  ReferenzDiagnose.free;
                end;

            end;
          until yet;
          tNAMES.free;

        end;
      7:
        begin
          // Erdgas S�dwest,
          repeat

            if (pos('FR', FotoParameter) = 1) then
            begin
              FotoPrefix := 'V-' +
              { } sParameter.values[cParameter_foto_ort] + ' ' +
              { } sParameter.values[cParameter_foto_strasse];
              ersetze(' ', '_', FotoPrefix);
              FotoPrefix := FotoPrefix + '-';
              break;
            end;

            if (pos('FL', FotoParameter) = 1) then
            begin
              FotoPrefix := 'N-' +
              { } sParameter.values[cParameter_foto_ort] + ' ' +
              { } sParameter.values[cParameter_foto_strasse];
              ersetze(' ', '_', FotoPrefix);
              FotoPrefix := FotoPrefix + '-';
              break;
            end;

            // "FN" soll nicht weiterverarbeitet werden!
            UmbenennungAbgeschlossen := true;

          until yet;

        end;
      8:
        begin
          // manuelle Weiterbearbeitung, z.B. Weiterleitung per eMail
          FotoPrefix :=
          { } sParameter.values[cParameter_foto_baustelle] + '-' +
          { } sParameter.values[cParameter_foto_ABNummer] + '-';
          UmbenennungAbgeschlossen := true;
        end;
      9:
        begin
          FotoPrefix :=
          { } sParameter.values[cParameter_foto_ART] + ' ' +
          { } sParameter.values[cParameter_foto_strasse] + ' ' +
          { } sParameter.values[cParameter_foto_ort];
          ersetze(' ', '_', FotoPrefix);
          FotoPrefix := FotoPrefix + '-';

        end;
      10:
        begin
          // wie "7" Erdgas S�dwest, jedoch mit "Neu" Umbenennung
          repeat

            if (pos('FR', FotoParameter) = 1) then
            begin
              FotoPrefix := 'V-' +
              { } sParameter.values[cParameter_foto_ort] + ' ' +
              { } sParameter.values[cParameter_foto_strasse];
              ersetze(' ', '_', FotoPrefix);
              FotoPrefix := FotoPrefix + '-';
              break;
            end;

            if (pos('FL', FotoParameter) = 1) then
            begin
              FotoPrefix := 'N-' +
              { } sParameter.values[cParameter_foto_ort] + ' ' +
              { } sParameter.values[cParameter_foto_strasse];
              ersetze(' ', '_', FotoPrefix);
              FotoPrefix := FotoPrefix + '-';
              break;
            end;

          until yet;

        end;
      11:
        begin
          // FA,FN normal - FH = Strasse und Ort
          repeat
            if (pos('FH', FotoParameter) = 1) then
            begin
              FotoPrefix :=
              { } sParameter.values[cParameter_foto_strasse] + ' ' +
              { } sParameter.values[cParameter_foto_ort];
              ersetze(' ', '_', FotoPrefix);
              FotoPrefix := FotoPrefix + '-';
              break;
            end;

          until yet;

        end;
      12:
        begin
          // FA,FN normal -
          // FE = ReglerNummerNeu, ohne Z�hlernummerAlt
          repeat
            if (pos('FE', FotoParameter) = 1) then
            begin
              NameOhneZaehlerNummerAlt := true;
              FotoPrefix := '';
              break;
            end;
          until yet;
        end;
      13:
        begin
          // wie "1" jedoch ohne "Neu" Logik
          FotoPrefix :=
          { } sParameter.values[cParameter_foto_strasse] + ' ' +
          { } sParameter.values[cParameter_foto_ort];
          ersetze(' ', '_', FotoPrefix);
          FotoPrefix := FotoPrefix + '-';
          UmbenennungAbgeschlossen := true;
        end;
      14:
        begin
          // wie "0" jedoch ohne "Neu" Logik
          UmbenennungAbgeschlossen := true;
        end;
    end;

    // Prefix: zus�tzliche Erweiterungen, f�r alle Baustellen g�ltig
    if (pos('Schrott', Zaehler_Info) > 0) then
      FotoPrefix := FotoPrefix + 'Schrott-';

    repeat

      // Ausbau
      if (pos('FA', FotoParameter) = 1) or (pos('Ausbau', FotoParameter) = 1) then
      begin
        if NameOhneZaehlerNummerAlt then
          FotoDateiNameNeu := FotoPrefix
        else
          FotoDateiNameNeu := FotoPrefix + zaehlernummer_alt;
        UmbenennungAbgeschlossen := true;
        break;
      end;

      // Einbau "Z�hler"
      if (pos('FN', FotoParameter) = 1) or (pos('Einbau', FotoParameter) = 1) then
      begin

        if UmbenennungAbgeschlossen then
        begin
          zaehlernummer_neu := '';
        end else
        begin
          if (zaehlernummer_neu = '') then
            zaehlernummer_neu := FormatZaehlerNummerNeu(
              { } callback_ZaehlerNummerNeu(
              { } AUFTRAG_R,
              { } sParameter.values[cParameter_foto_geraet]));
        end;

        if (zaehlernummer_neu = '') then
        begin

         if NameBereitsMitNeuPlatzhalter then
         begin
          if NameOhneZaehlerNummerAlt then
            FotoDateiNameNeu :=
            { } FotoPrefix
          else
            FotoDateiNameNeu :=
            { } FotoPrefix +
            { } zaehlernummer_alt;
         end else
         begin
          if NameOhneZaehlerNummerAlt then
            FotoDateiNameNeu :=
            { } FotoPrefix +
            { } cFotoService_NeuPlatzhalter
          else
            FotoDateiNameNeu :=
            { } FotoPrefix +
            { } zaehlernummer_alt + '-' +
            { } cFotoService_NeuPlatzhalter;
         end;

        end
        else
        begin

         // zaehlernummer_neu ist bekannt
         if NameBereitsMitNeuPlatzhalter then
           ersetze(cFotoService_NeuPlatzhalter,zaehlernummer_neu,FotoPrefix);

         if KeineZaehlerNummerNeuAmEnde then
         begin

          if NameOhneZaehlerNummerAlt then
            FotoDateiNameNeu :=
            { } FotoPrefix
          else
            FotoDateiNameNeu :=
            { } FotoPrefix +
            { } zaehlernummer_alt;

         end else
         begin

            if NameOhneZaehlerNummerAlt then
              FotoDateiNameNeu :=
              { } FotoPrefix +
              { } zaehlernummer_neu
            else
              FotoDateiNameNeu :=
              { } FotoPrefix +
              { } zaehlernummer_alt + '-' +
              { } zaehlernummer_neu;

         end;
         UmbenennungAbgeschlossen := true;
        end;
        break;
      end;

      // Einbau "Regler"
      if (pos('FE', FotoParameter) = 1) or (pos('Regler', FotoParameter) = 1) then
      begin

        if UmbenennungAbgeschlossen then
        begin
          Reglernummer_neu := '';
        end
        else
        begin
          if (Reglernummer_neu = '') then
            Reglernummer_neu := FormatZaehlerNummerNeu(
              { } callback_ReglerNummerNeu(
              { } AUFTRAG_R,
              { } sParameter.values[cParameter_foto_geraet]));
        end;

        if (Reglernummer_neu = '') then
        begin
          if NameBereitsMitNeuPlatzhalter then
          begin
            if NameOhneZaehlerNummerAlt then
              FotoDateiNameNeu :=
              { } FotoPrefix
             else
              FotoDateiNameNeu :=
              { } FotoPrefix +
              zaehlernummer_alt;
          end else
          begin
            if NameOhneZaehlerNummerAlt then
              FotoDateiNameNeu :=
              { } FotoPrefix +
              { } cFotoService_NeuPlatzhalter +
              { } '-Regler'
            else
              FotoDateiNameNeu :=
              { } FotoPrefix +
              { } zaehlernummer_alt + '-' +
              { } cFotoService_NeuPlatzhalter +
              { } '-Regler'
          end;
        end
        else
        begin

         // Reglernummer_neu ist bekannt
         if NameBereitsMitNeuPlatzhalter then
           ersetze(cFotoService_NeuPlatzhalter,Reglernummer_neu,FotoPrefix);

         if KeineReglerNummerNeuAmEnde then
         begin
          if NameOhneZaehlerNummerAlt then
            FotoDateiNameNeu :=
            { } FotoPrefix
          else
            FotoDateiNameNeu :=
            { } FotoPrefix +
            { } zaehlernummer_alt ;
         end else
         begin
          if NameOhneZaehlerNummerAlt then
              FotoDateiNameNeu :=
              { } FotoPrefix +
              { } Reglernummer_neu +
              { } '-Regler'
          else
              FotoDateiNameNeu :=
              { } FotoPrefix +
              { } zaehlernummer_alt + '-' +
              { } Reglernummer_neu +
              { } '-Regler';
         end;
         UmbenennungAbgeschlossen := true;
        end;
        break;
      end;

      // Sonstige FotoParameter wie "FB", "FC", "FM" ...
      // Sollten aber abgeschlossen sein!

      if NameOhneZaehlerNummerAlt then
       FotoDateiNameNeu :=
        { } FotoPrefix
      else
       FotoDateiNameNeu :=
         { } FotoPrefix +
         { } zaehlernummer_alt +
         { } '-' +
         { } FotoParameter;
      UmbenennungAbgeschlossen := true;

    until yet;

    break;
  end;

  // Ergebnis
  if not(ShouldAbort) then
  begin

    // Wenn fertig, dann die TMP-Sachen wieder wegmachen!
    if UmbenennungAbgeschlossen then
      FotoDateiNameNeu := clearTempTag(FotoDateiNameNeu)
    else
      FotoDateiNameNeu := FotoDateiNameNeu + createTempTag(AUFTRAG_R,FotoParameter);

    // Gar keine Prefix / Tmp usw. vorhanden, einfach nix
    if (FotoDateiNameNeu = '') then
    begin
      // leeres Ergebnis
      FatalError(
        { } 'NAME_NEU kann nicht ermittelt werden, da Prefix und Z�hlernummer leer sind');
    end else
    begin
      result.values[cParameter_foto_fertig] := active(UmbenennungAbgeschlossen);
      result.values[cParameter_foto_neu] :=
        {} StrFilter(FotoDateiNameNeu, cFoto_FName_ValidChars) +
        {} '.jpg';
      result.values[cParameter_foto_ziel] := ZielBaustelle;
    end;
  end;

  Optionen.Free;
end;

function TOrgaMonApp.InitTrn(GeraeteNo, AktTrn: string): boolean;
var
  DownFileDate: TDateTime;
  sErgebnisTANs: TStringList;
  GeraeteNoSrc: string;
  FName_Abgezogen: string;
  FName_AbgezogenSrc: string;
  ErrorCount: Integer;

  procedure FileCopyR (Source,Destination: string);
  var
   BytesToCopy : int64;
  begin
   BytesToCopy := FSize(source);
   repeat

    if (BytesToCopy<1) then
    begin
     FileEmpty(Destination);
     break;
    end;

    if (BytesToCopy>0) then
    begin
     if not(FileCopy(source,destination)) then
     begin
      log(cERRORText + ' 3717: copy '+source+' '+destination);
      inc(ErrorCount);
     end;
    end;

   until yet;
  end;

var
 n,l : Integer;
begin
  ErrorCount := 0;

  // calculate FileNames
  GeraeteNoSrc := GeraeteAlias(GeraeteNo);
  FName_Abgezogen := format(cMonDaServer_AbgezogenFName, [GeraeteNo]);
  FName_AbgezogenSrc := format(cMonDaServer_AbgezogenFName, [GeraeteNoSrc]);

  // 1) abgearbeitet.dat (OrgaMon will von diesen RIDs keine Ergebnisse mehr!)
  if proceed_refresh or not(FileExists(pAppServicePath + AktTrn + PathDelim + cMonDaServer_AbgearbeitetFName)) then
  begin

    if not(FileExists(pFTPPath + cMonDaServer_AbgearbeitetFName)) then
    begin
      log(cWARNINGText + ' 3724:' + cMonDaServer_AbgearbeitetFName + ' existiert nicht');
      FileAlive(pFTPPath + cMonDaServer_AbgearbeitetFName);
    end;

    // 1a) copy to "Data" assuming we are fresh first contact
    FileCopyR(
     { } pFTPPath + cMonDaServer_AbgearbeitetFName,
     { } AuftragPath + cMonDaServer_AbgearbeitetFName);

    // 1b) copy to "TRN"
    FileCopyR(
     { } pFTPPath + cMonDaServer_AbgearbeitetFName,
     { } pAppServicePath + AktTrn + PathDelim + cMonDaServer_AbgearbeitetFName);

  end;

  // 2) unberuecksichtigt.txt (OrgaMon kennt diese Daten noch nicht)
  if proceed_refresh or not(FileExists(pAppServicePath + AktTrn + PathDelim + cMonDaServer_UnberuecksichtigtFName)) then
  begin
    sErgebnisTANs := TStringList.Create;
    dir(pFTPPath + cJonDa_ErgebnisMaske_deprecated_FTP,sErgebnisTANs);

    // remove nnn.dat and other unwanted .dat Files
    l := length(cJonDa_ErgebnisMaske_deprecated);
    for n := pred(sErgebnisTANs.Count) downto 0 do
     if (length(sErgebnisTANs[n])<>l) then
       sErgebnisTANs.delete(n);
    sErgebnisTANS.Sort;
    sErgebnisTANs.SaveToFile(
      { } AuftragPath + cMonDaServer_UnberuecksichtigtFName);
    sErgebnisTANs.SaveToFile(
      { } pAppServicePath + AktTrn + PathDelim + cMonDaServer_UnberuecksichtigtFName);
    sErgebnisTANs.Free;
  end;

  // 3) abgezogen.GGG.dat
  if (GeraeteNoSrc <> '000') then
    if proceed_refresh or not(FileExists(pAppServicePath + AktTrn + PathDelim + FName_Abgezogen)) then
    begin

      if not(FileExists(pFTPPath + FName_AbgezogenSrc)) then
      begin
       log(cWARNINGText + ' ' + FName_AbgezogenSrc + ' existierte nicht und musste erstellt werden');
       FileAlive(pFTPPath + FName_AbgezogenSrc);
      end;

      // 2a) copy to "Data"
      FileCopyR(
       {} pFTPPath + FName_AbgezogenSrc,
       {} AuftragPath + FName_Abgezogen);

      // 2b) copy to "TRN"
      FileCopyR(
       {} pFTPPath + FName_AbgezogenSrc,
       {} pAppServicePath + AktTrn + PathDelim + FName_Abgezogen);

      // von cFreshDataPath -> ins lokale Verzeichnis!

    end;

  // 4) GGG.dat (das Auftragsvolumen!)
  if proceed_refresh or not(FileExists(pAppServicePath + AktTrn + PathDelim + GeraeteNo + cDATExtension)) then
  begin

    if (GeraeteNoSrc = '000') then
    begin
      // Just an empty File!
      FileEmpty(pAppServicePath + AktTrn + PathDelim + GeraeteNo + cDATExtension);
      result := true;
    end
    else
    begin

      // 3a) copy to "Data"
      if not(FileExists(pFTPPath + GeraeteNoSrc + cDATExtension)) then
      begin
        log(cWARNINGText + ' ' + GeraeteNoSrc + cDATExtension + ' existiert nicht und musste erstellt werden');
        FileAlive(AuftragPath + GeraeteNo + cDATExtension);
      end else
      begin
        FileCopyR(
         {} pFTPPath + GeraeteNoSrc + cDATExtension,
         {} AuftragPath + GeraeteNo + cDATExtension);
      end;

      // 3b) copy to "TRN"
      FileCopyR(
        { } AuftragPath + GeraeteNo + cDATExtension,
        { } pAppServicePath + AktTrn + PathDelim + GeraeteNo + cDATExtension);
    end;
  end;
  result := (ErrorCount=0);
end;

procedure TOrgaMonApp.doAbschluss;
var
  MinimumDate: TDateTime;

  procedure Freshen(FName: string);
  var
    bla: TBLager;
    mderec: TMdeRec;
  begin
    bla := TBLager.Create;
    bla.Init(FName, mderec, sizeof(TMdeRec));
    bla.BeginTransaction(now);
    bla.DeleteOld(MinimumDate);
    bla.EndTransaction;
    bla.free;

    // Copy Fresh to Original
    if FileDelete(FName + cBL_FileExtension) then
      FileMove(FName + cBL_FreshPostfix + cBL_FileExtension, FName + cBL_FileExtension);
  end;

var
   LastTrn: string;

begin
  FileAlive(pAppServicePath + cAppService_Proceed);

  // Datensicherungsverzeichnis!
  LastTrn := inttostr(pred(strtoint(ActTRN))) + PathDelim;

  // erst mal 'ne Datensicherung machen
  FileCopy(AuftragPath + 'FOTO+TS' + cBL_FileExtension,
   pAppServicePath + LastTrn + 'FOTO+TS' + cBL_FileExtension);
  FileCopy(AuftragPath + 'AUFTRAG+TS' + cBL_FileExtension,
   pAppServicePath + LastTrn + 'AUFTRAG+TS' + cBL_FileExtension);

  // wenn Hilfsdateien veraltet sind -> ablegen
  if FileRetire(DataPath + cFotoService_GlobalHintFName_ZaehlerNummer,5) then
   FileMove({} DataPath + cFotoService_GlobalHintFName_ZaehlerNummer,
            pAppServicePath + LastTrn + cFotoService_GlobalHintFName_ZaehlerNummer);
  if FileRetire(DataPath + cFotoService_GlobalHintFName_ReglerNummer,5) then
   FileMove({} DataPath + cFotoService_GlobalHintFName_ReglerNummer,
            pAppServicePath + LastTrn + cFotoService_GlobalHintFName_ReglerNummer);

  // Zeitlimit f�r alte Auftr�ge setzen
  MinimumDate := long2datetime(DatePlus(DateGet, -cMaxAge_Foto));

  // neu aufbauen + alte raus!
  Freshen(AuftragPath + 'FOTO+TS');
  Freshen(AuftragPath + 'AUFTRAG+TS');

  // SENDEN.CSV neu aufbereiten
  maintainSENDEN;

  // geraete.html
  maintainGERAETE;

  //
  // imp pend: doAbschluss remote ausl�sbar machen per XMLRPC, per CRON, per Neustart?)

  FileDelete(pAppServicePath + cAppService_Proceed);
end;

function TOrgaMonApp.nextBackupDir: string;
const
 MinAnzStellen = 3;
var
 Num,SuccNum : string;
 N,TagPos: Integer;
begin
 result := '';
 if (CharCount('#',BackupDir)<>1) then
 begin
   FotoLog(cERRORText + ' 4172: Kein # Tag in  ' + BackupDir);
   FotoLog(cFotoService_AbortTag);
   exit;
 end;
 TagPos := pos('#',BackupDir);
 Num := ExtractSegmentBetween(BackupDir,'#',PathDelim);
 N := StrToIntDef(Num,-1);
 if (N<0) then
 begin
  FotoLog(cERRORText + ' 4172: Keine Nummer nach # in  ' + BackupDir);
  FotoLog(cFotoService_AbortTag);
  exit;
 end;

 SuccNum := IntToStr(N+1);
 while (length(SuccNum)<MinAnzStellen) do
  SuccNum := '0' + SuccNum;

 result := copy(BackupDir, 1, TagPos) + SuccNum + PathDelim;
end;

function TOrgaMonApp.doBackup: int64;
const
  cTAN_BackupPath = 'TAN' + PathDelim;
  cLOG_BackupPath = 'log' + PathDelim;
  cVersioned_BackupPath = 'dat' + PathDelim;
{$IFDEF fpc}
  MOVEFILE_WRITE_THROUGH = 8;
{$ENDIF}
var
  // TAN-Stuff
  AllTRN: TStringList;
  n: integer;
  TAN: string;
  GeraeteNummer: string;
  TAN_OlderThan, TAN_Date: TANFiXDate;

  // LOG-Stuff
  sDir: TStringList;

  procedure LogReduce(FName: string; MaxFSize: int64);
  var
   sLOG: TStringList;
  begin
    sLOG := FileReduce( DiagnosePath + FName, MaxFSize );
    if assigned(sLOG) then
    begin
     AppendStringsToFile(sLOG,BackupDir + cLOG_BackupPath + FName);
     sLOG.Free;
    end else
    begin
      FileTouch(DiagnosePath + FName);
    end;
  end;

  procedure VersionedMove(Path, Name : string);
  var
   sPath, sSubs, sNewPath : TStringList;
   sFiles : TStringList;
   n,m : Integer;
   MaskStart, MaskEnd : Integer;
   NameMask, NameUnMask : string;
   Numbers: string;

   procedure md (Path: string);
   // like md, but remembers already done jobs
   begin
     if (sNewPath.IndexOf(Path)=-1) then
     begin
       sNewPath.Add(Path);
       CheckCreateDir(Path);
     end;
   end;

  begin
   // create the Path-List
   sNewPath := TStringList.Create;
   sPath := TStringList.Create;
   sSubs := TStringList.Create;
   sFiles := TStringList.Create;
   if (pos('*',Path)=0) then
   begin
     // One single Path
     sPath.Add(Path);
     sSubs.Add(''); // Sicherung in das Wurzelverzeichnis
   end else
   begin
     // Use a Mask
     n := revpos('*',Path);
     NameUnMask := copy(Path,1,pred(n));
     dir(Path,sPath,false);
     for n := 0 to pred(sPath.Count) do
     begin
       sSubs.Add(sPath[n] + PathDelim);
       sPath[n] := NameUnMask + sPath[n] + PathDelim;
     end;
   end;

   // Collect Candidates
   NameMask := Name;
   n := revpos('.',NameMask);
   NameMask := copy(Name,1,pred(n)) + '-*' + copy(Name,n,MaxInt);

   for n := 0 to pred(sPath.Count) do
   begin
    dir(sPath[n]+NameMask,sFiles,false);
    for m := 0 to pred(sFiles.Count) do
    begin

      // Nur numerische Anteile
      MaskStart := revpos('-',sFiles[m]);
      MaskEnd := revpos('.',sFiles[m]);
      Numbers := copy(sFiles[m],succ(MaskStart),pred(MaskEnd-MaskStart));
      if (Numbers='') then
       continue;
      if (StrFilter(Numbers,cZiffern)<>Numbers) then
       continue;

      // Nur Dateien, die alt genug sind
      if FileRetire(sPath[n]+sFiles[m], cMaxAge_log_Sichtbarkeit) then
      begin
       md(BackupDir + cVersioned_BackupPath + sSubs[n]);
       FileMove(sPath[n]+sFiles[m], BackupDir + cVersioned_BackupPath + sSubs[n] + sFiles[m]);
      end;
    end;
   end;
   sFiles.Free;
   sSubs.Free;
   sPath.Free;
   sNewPath.Free;
  end;

begin
  result := -1;

  if (BackupDir = '') then
    exit;

  if not(DirExists(BackupDir)) then
    exit;

  // TAN-Ablage-Bereich erstellen
  checkcreatedir(BackupDir + cTAN_BackupPath);

  // Log-Ablage-Bereich erstellen
  checkcreatedir(BackupDir + cLOG_BackupPath);

  // Ablage f�r versionierte Dateien erstellen
  checkcreatedir(BackupDir + cVersioned_BackupPath);

  TAN_OlderThan := DatePlus(DateGet, -cMaxAge_Produktive_Sichtbarkeit);
  AllTRN := TStringList.Create;
  dir(pAppServicePath + '*.', AllTRN, false);
  AllTRN.sort;
  for n := 0 to pred(AllTRN.count) do
  begin

    TAN := AllTRN[n];
    if (length(TAN) <> 5) then
      continue;

    TAN := StrFilter(AllTRN[n], cZiffern);
    if (length(TAN) <> 5) then
      continue;

    GeraeteNummer := detectGeraeteNummer(pAppServicePath + TAN);
    if (GeraeteNummer = '') then
      continue;

    // Pr�fung ob bei diesem Verzeichnis ein Proceed gemacht ist
    if not(FileExists(pAppServicePath + TAN  + PathDelim + TAN + '.dat')) then
    begin
     log(cERRORText + ' 3985: Trn '+TAN+' ohne Proceed!');
     continue;
    end;

    TAN_Date := FDate(pAppServicePath + TAN  + PathDelim + GeraeteNummer + cZIPExtension);
    if (TAN_Date < cOrgaMonBirthDayAsLong) then
      continue;
    if (TAN_Date >= TAN_OlderThan) then
      break;

    // Transaktions-Datenverzeichnisse wegsichern danach l�schen
    // ACHTUNG: "pAppServicePath" und "BackupDir" m�ssen auf dem selben Share liegen -
    // sonst funktioniert MoveFileEx nicht
    if not(MoveFileEx(
      { } pchar(pAppServicePath + TAN),
      { } pchar(BackupDir + cTAN_BackupPath + TAN),
      { } MOVEFILE_COPY_ALLOWED + MOVEFILE_WRITE_THROUGH)) then
    begin
     log(cERRORText + ' 4062: Verzeichnis '+TAN+' konnte nicht in die Sicherung verschoben werden!');
     continue;
    end;

    if DirExists(BackupDir + cTAN_BackupPath + TAN  + PathDelim) then
    begin
      FileMove(UpFName(TAN), BackupDir + cTAN_BackupPath + TAN  + PathDelim + TAN + '.txt');
      FileMove(AuftragFName(TAN), BackupDir + cTAN_BackupPath + TAN  + PathDelim + TAN + '.auftrag' + cUTF8DataExtension);
    end;

    // M�glich, dass es wegen Ergebnislosigkeit die folgende Datei NICHT gibt
    // Dies darf dann aber nicht zu einem Fehler f�hren
    FileDelete(pAppServicePath + cOrgaMonDataPath + TAN + cDATExtension);

  end;

  AllTRN.free;

  // LOGs-verkleinern
  LogReduce(cFotoLogFName, 4 * 1024 * 1024 );
  LogReduce(cJonDaServer_LogFName, 3 * 1024 * 1024 );
  LogReduce(cFotoTransaktionenFName, 3 * 1024 * 1024);

  // zu alte LOG-Wegsichern
  sDir := TStringList.create;
  dir(DiagnosePath+'*',sDir,false);
  for n := 0 to pred(sDir.count) do
    if (pos('.',sDir[n])<>1) then
      if FileRetire(DiagnosePath+sDir[n],cMaxAge_log_Sichtbarkeit) then
        FileMove(DiagnosePath+sDir[n],BackupDir + cLOG_BackupPath + sDir[n]);
  sDir.Free;

  // Vorg�ngerversionen von Dateien wegsichern
  VersionedMove(DataPath, 'baustelle.csv' );
  VersionedMove(DataPath, 'IMEI.csv' );
  VersionedMove(DataPath, 'IMEI-OK.csv' );
  VersionedMove(DataPath+'*.', 'FotoBenennung.csv' );

  // �ber die Gr�sse des Backups informieren
  result := DirSize(BackupDir);
end;

procedure TOrgaMonApp.doStat;

  function SplitUp(s: string): TStringList;
  begin
    result := TStringList.Create;
    while s <> '' do
      result.add(nextp(s, ';'));
  end;

  function Stat_Anzahl_Senden(geraet: string): integer;
  var
    n: integer;
  begin
    if not(assigned(sSendenLog)) then
      sSendenLog := TStringList.Create;
    result := 0;
    for n := 0 to pred(sSendenLog.count) do
      if pos(':' + geraet, sSendenLog[n]) > 0 then
        inc(result);
  end;

  procedure StatSingle(UmfangFName: string);
  const
    meld_col_Ausfuehrung = 8;
    meld_col_Protokoll = 7;
    cMonDa_FreieTerminWahl = 20000102;
  var
    sStatistik: TStringList;
    sUmfang: TStringList;
    sMeldungen: TStringList;
    sMeldungsDetails: TStringList;
    sRIDs: TgpIntegerList;

    RID: integer;
    um_Geraet: string;
    um_Name: string;
    um_Baustelle: string;
    n, m: integer;

    // Aufbau der Umfang.csv
    ColName: string;
    ColCounter: integer;
    um_Col_Gerate: integer;
    um_Col_Name: integer;

    iDate, mDate: TANFiXDate;
    iDateFromLog: TANFiXDate;
    sDateFromLog: string;
    iTime, mTime: TANFiXTime;
    mTimeDiff: TANFiXTime;
    OneCell: string;
    OneLine: string;

    // interessante Details aus einer Meldung
    dAusfuehrung: TANFiXDate;
    protokoll: string;

    // statistik
    Stat_Stueckzahl: integer;
    Stat_Blau: integer;
    Stat_Heute: integer;
    Stat_Auftrag: integer;
    Stat_Planung: integer;

    Stat_Summe_Stueckzahl: integer;
    Stat_Summe_Blau: integer;
    Stat_Summe_Heute: integer;
    Stat_Summe_Auftrag: integer;
    Stat_Summe_Planung: integer;

    // TimeOuts
    tt_Meldung: TANFiXTime;
    tt_Senden: TANFiXTime;

    // AuftragsSachen
    fAUFTRAG: file of TMdeRec;
    sAuftragFName: string;

  begin
    um_Baustelle := nextp(UmfangFName, '.', 1);

    iDate := DateGet;
    sDateFromLog := long2date(iDate);
    iTime := secondsget;

    sStatistik := TStringList.Create;
    sUmfang := TStringList.Create;
    sMeldungen := TStringList.Create;
    sRIDs := TgpIntegerList.Create;

    // Umfang laden
    sUmfang.LoadFromFile(DataPath + UmfangFName);

    // Colum - Defaults
    um_Col_Gerate := 0;
    um_Col_Name := 4;

    // Header interpretieren ...
    OneLine := sUmfang[0];
    ColCounter := 0;
    while (OneLine <> '') do
    begin
      ColName := AnsiUpperCase(nextp(OneLine, ';'));
      if (ColName = 'MONDA') then
        um_Col_Gerate := ColCounter;
      if (ColName = 'KUERZEL') then
        um_Col_Name := ColCounter;
      inc(ColCounter);
    end;

    sStatistik.add('');
    sStatistik.add('JonDa-Server ' + um_Baustelle + '-Statistik vom ' + long2date(iDate) + ' - ' + secondstostr(iTime));
    sStatistik.add('');

    sStatistik.add('Ger�t(Kurz)AnzAu;letzte Meldung; letztes Senden (TAN:Anz)  Anz; Fertig    ; Blau');
    sStatistik.add('----------------;--------------;------------------------------;-----------;-----');

    Stat_Summe_Stueckzahl := 0;
    Stat_Summe_Blau := 0;
    Stat_Summe_Heute := 0;
    Stat_Summe_Auftrag := 0;
    Stat_Summe_Planung := 0;
    tt_Meldung := strtoSeconds('02:29:59');
    tt_Senden := strtoSeconds('09:59:59');


    for n := 1 to pred(sUmfang.count) do
    begin

      if (cutblank(sUmfang[n]) = '') then
        continue;

      if (sUmfang[n][1] = '-') then
      begin
        sStatistik.add('--------------------------------------------------------------------------------');
        continue;
      end;

      // Ger�t
      um_Geraet := nextp(sUmfang[n], ';', um_Col_Gerate);
      if (length(um_Geraet) <> 3) then
        continue;

      um_Name := nextp(sUmfang[n], ';', um_Col_Name);
      OneCell := um_Geraet + '(' + noblank(um_Name) + ')';
      bfill(OneCell, 12);

      // Anzahl des Planungsvolumens
      Stat_Planung := FSize(pFTPPath + um_Geraet + '.DAT');

      if (Stat_Planung > 0) then
      begin
        Stat_Planung := Stat_Planung div sizeof(TMdeRec);
        OneCell := OneCell + format('%4d', [Stat_Planung]);
      end
      else
      begin
        OneCell := OneCell + '   #';
        Stat_Planung := 0;
      end;
      OneLine := OneCell;

      // Sicherstellen, dass der Merge funktioniert!!
      if not(FileExists(pAppServicePath + cMeldungPath + um_Geraet + '.txt')) then
      begin
        FileAlive(pAppServicePath + cMeldungPath + um_Geraet + '.txt');
        FileTouch(pAppServicePath + cMeldungPath + um_Geraet + '.txt', cMonDa_FreieTerminWahl, 0);
      end;

      // �ber Meldungen berichten!!
      mDate := FDate(pAppServicePath + cMeldungPath + um_Geraet + '.txt');
      mTime := FSeconds(pAppServicePath + cMeldungPath + um_Geraet + '.txt');
      if (mDate > cMonDa_FreieTerminWahl) then
      begin
        mTimeDiff := SecondsDiff(iDate, iTime, mDate, mTime);
        OneCell := '  -' + secondstostr9(mTimeDiff) + ' h';
        if (mTimeDiff > tt_Meldung) then
          OneCell[1] := '#';

      end
      else
      begin
        OneCell := '#';
      end;
      bfill(OneCell, 14);
      OneLine := OneLine + ';' + OneCell;

      // Anzahl der Datens�tze auf dem Ger�t
      sAuftragFName := AuftragPath + 'AUFTRAG.' + um_Geraet + '.DAT';
      if FileExists(sAuftragFName) then
      begin
        assignFile(fAUFTRAG, sAuftragFName);
        reset(fAUFTRAG);
        Stat_Auftrag := FileSize(fAUFTRAG);
        CloseFile(fAUFTRAG);
      end
      else
      begin
        Stat_Auftrag := 0;
      end;

      // Senden
      mDate := FDate(DataPath + um_Geraet + '.txt');
      mTime := FSeconds(DataPath + um_Geraet + '.txt');
      if (mDate > 0) then
      begin
        mTimeDiff := SecondsDiff(iDate, iTime, mDate, mTime);
        sMeldungen.LoadFromFile(DataPath + um_Geraet + '.txt');
        OneCell := '  -' + secondstostr9(mTimeDiff) + ' h (' + sMeldungen[0] + ':' +
          format('%4d', [Stat_Auftrag]) + ')';
        OneCell := OneCell + format('x%2d', [Stat_Anzahl_Senden(um_Geraet)]);
        if (mTimeDiff > tt_Senden) then
          OneCell[1] := '#';
      end
      else
      begin
        OneCell := '#';
      end;
      bfill(OneCell, 30);
      OneLine := OneLine + ';' + OneCell;

      // St�ckzahl - Heute - Blau
      if FileExists(pAppServicePath + cMeldungPath + um_Geraet + '.txt') then
      begin
        Stat_Stueckzahl := 0;
        Stat_Blau := 0;
        Stat_Heute := 0;
        sMeldungen.LoadFromFile(pAppServicePath + cMeldungPath + um_Geraet + '.txt');
        sRIDs.Clear;
        for m := pred(sMeldungen.count) downto 0 do
        begin
          RID := strtointdef(nextp(sMeldungen[m], ';', 0), -1);
          if (RID > 0) then
          begin
            if (sRIDs.IndexOf(RID) = -1) then
            begin
              sRIDs.add(RID);
              sMeldungsDetails := SplitUp(sMeldungen[m]);
              dAusfuehrung := strtointdef(sMeldungsDetails[meld_col_Ausfuehrung], 0);
              repeat

                if (dAusfuehrung > 0) then
                begin
                  // Erfolg!
                  inc(Stat_Stueckzahl);
                  if (dAusfuehrung = iDate) then
                    inc(Stat_Heute);
                  break;
                end;

                if (dAusfuehrung = 0) then
                begin
                  // Blau?
                  protokoll := sMeldungsDetails[meld_col_Protokoll];
                  if (pos('V1=', protokoll) > 0) then
                    inc(Stat_Blau);
                end;

              until yet;
              sMeldungsDetails.free;
            end;
          end;
        end;
        OneCell := format('%5d/%5d', [Stat_Heute, Stat_Stueckzahl]);
        OneLine := OneLine + ';' + OneCell;
        OneCell := format('%5d', [Stat_Blau]);
        OneLine := OneLine + ';' + OneCell;
        inc(Stat_Summe_Stueckzahl, Stat_Stueckzahl);
        inc(Stat_Summe_Blau, Stat_Blau);
        inc(Stat_Summe_Heute, Stat_Heute);
        inc(Stat_Summe_Auftrag, Stat_Auftrag);
        inc(Stat_Summe_Planung, Stat_Planung);

      end;
      sStatistik.add(OneLine);

    end;
    sStatistik.add('----------------;--------------;------------------------------;-----------;-----');
    sStatistik.add(format('Summe      %5d;                                    %5d     %5d/%5d;%5d',
      [Stat_Summe_Planung, Stat_Summe_Auftrag, Stat_Summe_Heute, Stat_Summe_Stueckzahl, Stat_Summe_Blau]));
    sStatistik.add('');
    sStatistik.add(' # erfordert eine tel. R�ckfrage bei Ableser!');
    sStatistik.add('');
    sStatistik.add(' Ger�t: 3 stellige Monteurs-Identifikation');
    sStatistik.add(' Kurz: Monteurs-Namensk�rzel');
    sStatistik.add(' AnzAu: Ger�tevolumen abrufbar auf dem JonDaServer');
    sStatistik.add(' letzte Meldung: verstrichene Zeit (HHH:MM:SS) seit der letzten Meldung');
    sStatistik.add(' letztes Senden: verstrichene Zeit (HHH:MM:SS) seit dem letzten Senden');
    sStatistik.add('  (letzte TAN:Anzahl der Auftr�ge auf dem Ger�t) Anzahl "Senden" inerhalb der letzten 10 Tage');
    sStatistik.add(' Fertig: Summe "Fertig" heute/Summe "Fertig" gesamt');
    sStatistik.add(' Blau: Summe im Status "Blau"');
    sStatistik.SaveToFile(DataPath + 'Info-' + um_Baustelle + '.txt');
    sStatistik.free;
    sUmfang.free;
    sMeldungen.free;
    sRIDs.free;
  end;

var
  sDir: TStringList;
  n: integer;
begin
  sDir := TStringList.Create;
  dir(DataPath + 'Umfang.*.csv', sDir, false);
  for n := 0 to pred(sDir.count) do
    StatSingle(sDir[n]);
  sDir.free;
end;

function TOrgaMonApp.upMeldungen: TStringList;
const
  cFixedTAN_FName = '50000.DAT';
var
  lAbgearbeitet: TgpIntegerList;
  lMeldungen: TStringList;
  i: integer;
  mRID: integer;
  mderec: TMdeRec;
  OneJLine: string;
  JProtokoll: string;
  OrgaMonErgebnis: file of TMdeRec;
  // Das sind Ergebnisse von MonDa
  pAppServicePath: string;
  sOrgaMonFName: string;
  dTimeOut: TANFiXDate;
  dMeldung: TANFiXDate;
  Stat_Meldungen: integer;
  GeraeteNo: string;
  MeldungsMoment: string;
begin
  result := TStringList.Create;
  ClearStat;
  result.add('melde TAN 50000 ... ');

  lAbgearbeitet := TgpIntegerList.Create;
  lMeldungen := TStringList.Create;
  fillchar(mderec, sizeof(mderec), 0);
  Stat_Meldungen := 0;
  try
    BeginAction('50000:000');

    dTimeOut := DatePlus(DateGet, -8);
    sOrgaMonFName := pAppServicePath + cOrgaMonDataPath + cFixedTAN_FName;
    assignFile(OrgaMonErgebnis, sOrgaMonFName);
    rewrite(OrgaMonErgebnis);

    // Lade die fertigen!
    lAbgearbeitet.LoadFromFile(AuftragPath + 'abgearbeitet.dat');

    // Lade alle Meldungen!
    lMeldungen.LoadFromFile(pAppServicePath + cMeldungPath + '000.txt');
    for i := pred(lMeldungen.count) downto 0 do
    begin
      mRID := strtointdef(nextp(lMeldungen[i], ';', 0), 0);
      if (mRID > 0) then
      begin
        if (lAbgearbeitet.IndexOf(mRID) = -1) then
        begin

          // damit er nicht mehrfach �bertragen wird
          lAbgearbeitet.add(mRID);

          // nun den mderec Schreiben!
          OneJLine := WebToMdeRecString(lMeldungen[i]);
          nextp(OneJLine, ';');
          with mderec do
          begin

            RID := mRID;
            zaehlernummer_korr := toZaehlerNummerType(nextp(OneJLine, ';'));
            zaehlernummer_neu := toZaehlerNummerType(nextp(OneJLine, ';'));
            zaehlerstand_neu := nextp(OneJLine, ';');
            zaehlerstand_alt := nextp(OneJLine, ';');
            Reglernummer_korr := toZaehlerNummerType(nextp(OneJLine, ';'));
            Reglernummer_neu := toZaehlerNummerType(nextp(OneJLine, ';'));
            JProtokoll := nextp(OneJLine, ';');
            ersetze(cJondaProtokollDelimiter, ';', JProtokoll);
            if (length(JProtokoll) > 254) then
              log(cWARNINGText + ' 2822:' + 'Protokollfeld zu lange, Eintr�ge gehen verloren!');
            ProtokollInfo := JProtokoll;
            ausfuehren_ist_datum := strtointdef(nextp(OneJLine, ';'), 0);
            ausfuehren_ist_uhr := strtointdef(nextp(OneJLine, ';'), 0);
            MeldungsMoment := nextp(OneJLine, ';');
            GeraeteNo := nextp(OneJLine, ';');
            dMeldung := Date2Long(nextp(MeldungsMoment, ' - ', 0));

          end;

          if (dMeldung > cMonDa_ErsteEingabe) then
          begin

            if (dMeldung <= dTimeOut) then
              break;

            // Korrektur des mderec.ausfuehren_ist_datums
            if (mderec.ausfuehren_ist_datum > cMonDa_Status_unbearbeitet) then
            begin
              // Eingabe-Tag <> Melde-Tag
              if (mderec.ausfuehren_ist_datum <> dMeldung) then
              begin
                // Auf "heute" 12:00:00 h umstellen!
                mderec.ausfuehren_ist_datum := dMeldung;
                mderec.ausfuehren_ist_uhr := cNoon;
              end;
            end;

            if isProd(GeraeteNo, mderec.RID, mderec.ausfuehren_ist_datum) then
            begin
              write(OrgaMonErgebnis, mderec);
              inc(Stat_Meldungen);
            end;

          end;
        end;
      end;
    end;
    CloseFile(OrgaMonErgebnis);

    if (FSize(sOrgaMonFName) > 0) then
    begin
      FileCopy(
       {} sOrgaMonFName,
       {} pFTPPath + cFixedTAN_FName);
    end
    else
    begin
      log('Unterlassener Upload aufgrund Ergebnislosigkeit bei TRN ' + cFixedTAN_FName);
    end;
    log('->OrgaMon     : ' + inttostr(Stat_Meldungen));
    EndAction;

  except
    on E: Exception do
      log(cERRORText + ' 2260:' + E.Message);
  end;
  lAbgearbeitet.free;
  lMeldungen.free;

  result.add('(' + inttostr(Stat_Meldungen) + 'x) ' + 'OK');

end;

class procedure TOrgaMonApp.validateBaustelleCSV(FName: string);
var
  sBAUSTELLE: TsTable;
  cColumnIndex_NUMMERN_PREFIX: integer;
  r: integer;
  NUMMERN_PREFIX, _NUMMERN_PREFIX: string;
begin
  sBAUSTELLE := TsTable.Create;
  with sBAUSTELLE do
  begin
    InsertFromFile(FName);
    cColumnIndex_NUMMERN_PREFIX := colof('NUMMERN_PREFIX', true);
    for r := 1 to RowCount do
    begin
      _NUMMERN_PREFIX := readCell(r, cColumnIndex_NUMMERN_PREFIX);
      NUMMERN_PREFIX := copy(_NUMMERN_PREFIX, 1, 6);
      if (_NUMMERN_PREFIX <> NUMMERN_PREFIX) then
        writeCell(
          { } r, cColumnIndex_NUMMERN_PREFIX,
          { } NUMMERN_PREFIX);
    end;
    if changed then
      SaveToFile(FName);
  end;
  sBAUSTELLE.free;
end;

class function TOrgaMonApp.VormittagsStr(vormittags: boolean): string;
begin
  if vormittags then
    result := 'V'
  else
    result := 'N';
end;

function TOrgaMonApp.toProtokollFName(const mderec: TMdeRec; RemoteRev: single): string;
var
  k: integer;

  function _baustelle: string;
  begin
    result := AnsiUpperCase(Oem2asci(mderec.Baustelle));
  end;

begin
  with mderec do
  begin

    k := sProtokolle.FindInc(_baustelle + Art + cJondaProtokollDelimiter);
    if (k <> -1) then
    begin
      result := nextp(sProtokolle[k], cJondaProtokollDelimiter, 1);
    end
    else
    begin

      result := '';
      repeat
        if FileExists(pAppServicePath + cProtokollPath + _baustelle + Art + cProtExtension) then
        begin
          result := _baustelle + AnsiUpperCase(Art);
          break;
        end;

        if FileExists(pAppServicePath + cProtokollPath + _baustelle + cProtExtension) then
        begin
          result := _baustelle;
          break;
        end;

        if FileExists(pAppServicePath + cProtokollPath + cProtPrefix + Art + cProtExtension) then
        begin
          result := cProtPrefix + AnsiUpperCase(Art);
          break;
        end;

        // Default - dieses Protokoll MUSS vorhanden sein!
        result := cProtPrefix;

      until yet;

      sProtokolle.add(_baustelle + Art + cJondaProtokollDelimiter + result);
    end;
  end;
end;

function TOrgaMonApp.TrnFName: string;
begin
  result := DataPath + cTrnFName
end;

class function TOrgaMonApp.toZaehlerNummerType(s:string):TZaehlerNummerType;
begin
  // Bei �berl�nge: Zusammenr�cken
  if (length(s)>cMonDa_FieldLength_ZaehlerNummer) then
   s := noblank(s);
  // Bei �berl�nge: Nur die letzten 15 Stellen
  if (length(s)>cMonDa_FieldLength_ZaehlerNummer) then
   s := copy(s,succ(length(s))-cMonDa_FieldLength_ZaehlerNummer,cMonDa_FieldLength_ZaehlerNummer);
  result := s;
end;

class procedure TOrgaMonApp.toAnsi(var mderec: TMdeRec);
begin
  with mderec do
  begin
    monteur := OEM2Ansi(monteur);
    Monteur_Info := OEM2Ansi(Monteur_Info);
    Zaehler_Info := OEM2Ansi(Zaehler_Info);
    Zaehler_Name1 := OEM2Ansi(Zaehler_Name1);
    Zaehler_Name2 := OEM2Ansi(Zaehler_Name2);
    Zaehler_Strasse := OEM2Ansi(Zaehler_Strasse);
    Zaehler_Ort := OEM2Ansi(Zaehler_Ort);
    ProtokollInfo := OEM2Ansi(ProtokollInfo);
  end;
end;

class function TOrgaMonApp.toEingabe(const mderec: TMdeRec): string;
begin
  with mderec do
  begin
    // im Format f�r 'Eingabe.???.txt'
    result :=
    { 0 } long2date(ausfuehren_ist_datum) + ';' +
    { 1 } secondstostr8(ausfuehren_ist_uhr) + ';' +
    { 2 } inttostr(RID) + ';' +
    { 3 } Reglernummer_neu + ';' +
    { 4 } zaehlernummer_neu;
  end;
end;

// Produktiv- oder Test- Daten
function TOrgaMonApp.isProd(pGeraeteNo: string; pRID: integer; pFertig: TANFiXDate): boolean;
begin
  result := true;
  if (pGeraeteNo > '299') then
    if (pFertig > cMonDa_ErsteEingabe) then
    begin
      repeat

        if (pFertig < 20080822) then
        begin
          // THGO + SWL
          // Testeingabe, die nicht ber�cksichtigt werden kann
          result := false;
          break;
        end;

        if (pRID >= 10657135) and (pRID <= 10755791) then
          if (pFertig < 20080829) then
          begin
            // THUA
            // Testeingabe, die nicht ber�cksichtigt werden kann
            result := false;
            break;
          end;

      until yet;
    end;
end;

function TOrgaMonApp.isTest(pGeraeteNo: string; pRID: integer; pFertig: TANFiXDate): boolean;
begin
  result := not(isProd(pGeraeteNo, pRID, pFertig));
end;

procedure TOrgaMonApp.ClearStat;
begin
  if not(assigned(sProtokolle)) then
    sProtokolle := TSearchStringList.Create;
  Stat_Vorgezogen := 0;
  Stat_Unmoeglich := 0;
  Stat_NeuAnschreiben := 0;
  Stat_Unbearbeitet := 0;
  Stat_Restanten := 0;
  Stat_Abgearbeitete := 0;
  Stat_Meldungen := 0;
  Stat_AutoRestant := 0;
  Stat_MondaNeu := 0;
  Stat_MondaStay := 0;
  Stat_FallBack := 0;
  Stat_Bisher := 0;
  Stat_SelbstAnlagen := 0;
  Stat_FrischFertig := 0;
  Stat_Schlafmuetzen := 0;
  Stat_OrgaMonGruen := 0;
  Stat_OrgaMonPending := 0;
  Stat_Abberufen := 0;
  Stat_IgnoriertTest := 0;
  Stat_IgnoriertFehlenderAuftrag := 0;
  Stat_AusfuehrungsMomentKorrektur := 0;
  Stat_FotoMeldungen := 0;
  Stat_PostError := '';
  sProtokolle.Clear;
end;

const
  TmpNameTagOpen = '-(RID';
  TmpNameTagClose = ')';

class function TOrgaMonApp.clearTempTag(const s: string): string;
var
  k, l: integer;
  _s: string;
begin
  result := s;
  k := pos(TmpNameTagOpen, s);
  if (k > 0) then
  begin
    _s := copy(s, k + length(TmpNameTagOpen), MaxInt);
    l := pos(TmpNameTagClose, _s);
    if (l > 0) then
      result :=
      { } copy(s, 1, pred(k)) +
      { } copy(s, pred(k) + l + length(TmpNameTagOpen) + length(TmpNameTagClose), MaxInt);
  end;
end;

class function TOrgaMonApp.createTempTag(RID: integer; Parameter: string): string;
begin
  result :=
   { } TmpNameTagOpen +
   { } inttostr(RID) +
   { } '#' +
   { } Parameter +
   { } TmpNameTagClose;
end;

constructor TOrgaMonApp.Create;
begin
  inherited Create;
  tIMEI := TsTable.Create;
  tIMEI_OK := TsTable.Create;
end;

destructor TOrgaMonApp.Destroy;
begin
  if assigned(sSendenLog) then
    sSendenLog.free;
  if assigned(sProtokolle) then
    sProtokolle.free;
  tIMEI_OK.free;
  tIMEI.free;

  inherited;
end;

function TOrgaMonApp.WebToMdeRecString(s: AnsiString): AnsiString;
begin
  result := ANSI2OEM(s);
  ersetze('*', '.', result);
end;

function TOrgaMonApp.MdeRec2Jonda(mderec: TMdeRec; RemoteRev: single): string;

  function toTargetCharset(s: string): string;
  begin
    result := OEM2Ansi(s);
  end;

  function GoodStr(s: string): string;
  begin
    result := toTargetCharset(cutblank(s));
    ersetze(';', cJondaProtokollDelimiter, result);
    ersetze(PathDelim, '', result);
    ersetze(#10, '', result);
    ersetze(#9, ' ', result);
    ersetze('Grund / Bemerkung: ', '', result);
    ersetze('  ', ' ', result);
    ersetze(#13, cProtokollTrenner, result);
  end;

var
  Z_ort: string;
  sTerminInfo: string;

  procedure addOrt(s: string);
  begin
    if (s <> '') then
      if (Z_ort <> '') then
        Z_ort := Z_ort + cProtokollTrenner + s
      else
        Z_ort := Z_ort + s;
  end;

begin
  with mderec do
  begin

    Z_ort := '';
    addOrt(GoodStr(cutblank(Zaehler_Name1 + ' ' + Zaehler_Name2)));
    addOrt(GoodStr(Zaehler_Strasse));
    addOrt(GoodStr(Zaehler_Ort));

    case ausfuehren_soll of
      cMonDa_ImmerAusfuehren:
        sTerminInfo := 'KV'; // Kopier-Vorlage
      cMonDa_FreieTerminWahl:
        sTerminInfo := 'FTW';
      // Freie Termin Wahl
    else
      sTerminInfo := WeekDayS(ausfuehren_soll) + ' ' + copy(long2date(ausfuehren_soll), 1, 5) +
        VormittagsStr(vormittags);
    end;

    result :=
    { } 'N;' + // not modified
    { } inttostr(RID) + ';' +

    // Terminangaben
    { } toTargetCharset(monteur) + ' ' + sTerminInfo + ';' +

    // Monteur Baustelle ABNUMMER
    { } GoodStr(Baustelle + '-' + ABNummer) + ';' +

    { } GoodStr(Art) + ';' +
    { } GoodStr(zaehlernummer_alt) + ';' +
    { } GoodStr(Reglernummer_alt) + ';' +

    { } GoodStr(Zaehler_Info) + ';' +
    { } GoodStr(Monteur_Info) + ';' +

    { } Z_ort + ';' +
    { } toProtokollFName(mderec, RemoteRev) + ';' +

    { von Monda }
    { } GoodStr(zaehlernummer_korr) + ';' +
    { } GoodStr(zaehlernummer_neu) + ';' +
    { } GoodStr(zaehlerstand_neu) + ';' +
    { } GoodStr(zaehlerstand_alt) + ';' +
    { } GoodStr(Reglernummer_korr) + ';' +
    { } GoodStr(Reglernummer_neu) + ';' +
    { } GoodStr(ProtokollInfo) + ';' +

    { von Monda intern }
    { } inttostr(ausfuehren_ist_datum) + ';' +
    { } inttostr(ausfuehren_ist_uhr);
  end;

end;

function TOrgaMonApp.migrateProtokoll(OldFName, NewFName: string): boolean;

const
  cMigrationsVorlage_FName = 'JonDa-Migrationsprotokoll.txt';
  cRightBorder = '�';

var
  sMigrationsVorlage: TStringList;
  sInput, sOutput: TStringList;
  InputIndex: integer;
  InsertPoint: integer;
  n: integer;
  sTxt, sParameter: string;

begin
  result := false;
  //
  sMigrationsVorlage := TStringList.Create;
  sInput := TStringList.Create;
  sOutput := TStringList.Create;

  try
    // Load the old MSDOS Protokolls
    sInput.LoadFromFile(OldFName);
    for n := 0 to pred(sInput.count) do
      sInput[n] := OEM2Ansi(sInput[n]);

    with sInput do
    begin
      insert(0, '#');
      insert(1, '# JonDa-Protokoll vom');
      insert(2, '# ' + datum + ' um ' + UHR);
      insert(3, '#');
    end;

    sMigrationsVorlage.LoadFromFile(pAppServicePath + 'Update\' + cMigrationsVorlage_FName);

    // Einf�ge Punkt suchen
    InsertPoint := sMigrationsVorlage.IndexOf(cJondaProtokollDelimiter);
    if (InsertPoint = -1) then
      raise Exception.Create(
        { } 'Zeile "' + cJondaProtokollDelimiter +
        { } '" in ' + cMigrationsVorlage_FName +
        { } ' nicht gefunden)');
    sMigrationsVorlage.Delete(InsertPoint);

    // Content bilden
    for InputIndex := 0 to pred(sInput.count) do
    begin

      // Trenner
      if (pos('--', sInput[InputIndex]) = 1) then
      begin
        sOutput.add('--');
        continue;
      end;

      // normaler Text
      if (pos('$', sInput[InputIndex]) = 0) then
      begin
        sTxt := cutblank(nextp(sInput[InputIndex], cRightBorder, 0));
        sOutput.add(sTxt);
        continue;
      end;

      // Ankreuzhaken
      if (pos('[', sInput[InputIndex]) = 1) then
      begin
        sTxt := cutblank(ExtractSegmentBetween(sInput[InputIndex], ']', cRightBorder));
        sParameter := cutblank(nextp(sInput[InputIndex], '$', 1));
        sOutput.add(sParameter + '=');
        sOutput.add('H;' + sTxt);
        continue;
      end;

      // JA/NEIN Feld
      if (pos('{', sInput[InputIndex]) = 1) then
      begin
        //
        sTxt := cutblank(ExtractSegmentBetween(sInput[InputIndex], '}', cRightBorder));
        sOutput.add(sTxt);

        sParameter := cutblank(nextp(sInput[InputIndex], '$', 1));
        sOutput.add(sParameter + '=');
        sOutput.add('B;Ja;J');
        sOutput.add('B;Nein;N');
        sOutput.add('--');
        continue;
      end;

      // Normale Eingabe-Positionen
      sParameter := cutblank(nextp(sInput[InputIndex], '$', 1));
      sParameter := nextp(sParameter, '.', 0);
      sTxt := cutblank(nextp(sInput[InputIndex], cRightBorder, 0));
      if length(sParameter) > 1 then
      begin
        sOutput.add(sParameter + '=');
        if (sParameter[1] = 'N') then
          sOutput.add('D;' + sTxt)
        else
          sOutput.add('A;' + sTxt);
      end;

    end;

    // Einf�gen
    for n := 0 to pred(sOutput.count) do
      sMigrationsVorlage.insert(InsertPoint + n, sOutput[n]);

    SaveStringsToFileUTF8(sMigrationsVorlage, NewFName);
    result := true;

  except
    on E: Exception do
      log(cERRORText + ' 3454:' + E.Message);
  end;

  sInput.free;
  sOutput.free;
  sMigrationsVorlage.free;
end;

function TOrgaMonApp.detectGeraeteNummer(sPath: string): string;
var
  DirEntries: TStringList;
  i: integer;
  ZipPraefix: string;
begin
  result := '';
  DirEntries := TStringList.Create;
  dir(ValidatePathName(sPath) + '\*' + cZIPExtension, DirEntries, false);
  for i := 0 to DirEntries.count - 1 do
  begin
    ZipPraefix := nextp(DirEntries[i], cZIPExtension, 0);
    if (strtointdef(ZipPraefix, -1) >= 0) then
    begin
      result := ZipPraefix;
      break;
    end;
  end;
  DirEntries.free;
end;

function TOrgaMonApp.Pause(WechsleStatus: boolean = false; Off: boolean = false): boolean;
var
  FName: string;
begin
  FName := pAppServicePath + cFotoService_Pause;
  if WechsleStatus then
  begin
    if Off then
      FileDelete(FName)
    else
      FileAlive(FName);
  end;
  result := FileExists(FName);
end;

const
  _GeraeteNo: string = '';
  EINGABE: tsTable = nil;

procedure TOrgaMonApp.invalidate_NummerNeuCache;
begin
  _GeraeteNo := '';
end;

function TOrgaMonApp.EingabeLocate(AUFTRAG_R: integer; GeraeteNo: string; Spalte: string): string;
var
  FName: string;
  r: integer;
begin

  // Datenspeicher laden
  if (GeraeteNo <> _GeraeteNo) then
  begin
    if not(assigned(EINGABE)) then
      EINGABE := tsTable.Create
    else
      EINGABE.Clear;
    FName := DataPath + 'Eingabe.' + GeraeteNo + '.txt';
    if FileExists(FName) then
      FileAlive(FName);
    EINGABE.insertfromFile(FName, cHeader_Eingabe);
    _GeraeteNo := GeraeteNo;
  end;

  // RID suchen
  r := EINGABE.locate('RID', InttoStr(AUFTRAG_R));
  if (r <> -1) then
    result := EINGABE.readCell(r, Spalte)
  else
    result := '';

end;

function TOrgaMonApp.ZaehlerNummerNeu(AUFTRAG_R: integer; GeraeteNo: string): string;
begin
  result := EingabeLocate(AUFTRAG_R, GeraeteNo, 'ZAEHLER_NUMMER_NEU');
end;

function TOrgaMonApp.ReglerNummerNeu(AUFTRAG_R: integer; GeraeteNo: string): string;
begin
  result := EingabeLocate(AUFTRAG_R, GeraeteNo, 'REGLER_NUMMER_NEU');
end;

procedure TOrgaMonApp.Dump(s: string; sl: TStringList);
var
  n: integer;
begin
  FotoLog(s + ' {');
  for n := 0 to pred(sl.Count) do
    FotoLog(' ' + sl[n]);
  FotoLog('}');
end;

function TOrgaMonApp.Initialized: boolean;
begin
  result := assigned(tBAUSTELLE);
end;

procedure TOrgaMonApp.ensureGlobals;
var
  r: integer;
  sDirs: TStringList;
  n: integer;
  SubPath: string;
begin
  if not(Initialized) then
  begin
    // sicherstellen das "Initialized" nun true ist
    tBAUSTELLE := tsTable.Create;
    tABLAGE := tsTable.Create;

    // Initialer Lauf
    callback_ZaehlerNummerNeu := ZaehlerNummerNeu;
    callback_ReglerNummerNeu := ReglerNummerNeu;

    // die aktuellen Daten aus dem FTP-Bereich jetzt abholen
    workSync;

    tBAUSTELLE.insertfromFile(DataPath + cFotoService_BaustelleFName);
    if FileExists(DataPath + cFotoService_BaustelleManuellFName) then
    begin
      with tBAUSTELLE do
      begin
        insertfromFile(DataPath + cFotoService_BaustelleManuellFName);
        for r := RowCount downto 1 do
          if (length(readCell(r, cE_FTPUSER)) < 3) then
            del(r);
      end;
    end;

    tABLAGE.insertfromFile(DataPath + cFotoService_AblageFName);

    // Datei der Wartenden sicherstellen, Header anlegen
    if not(FileExists(DataPath + cFotoService_UmbenennungAusstehendFName)) then
      AppendStringsToFile(
        { } cFotoService_UmbenennungAusstehendHeader,
        { } DataPath + cFotoService_UmbenennungAusstehendFName);

    // heutiges BackupDir bestimmen, "...\#001\", "...\#002" usw.
    // es ist immer das mit der gr�ssten Nummer
    sDirs := TStringList.Create;
    dir(pBackUpRootPath + '*.', sDirs, false);
    sDirs.sort;

    // reduce list to the wanted
    for n := pred(sDirs.Count) downto 0 do
      if (pos('.', sDirs[n]) = 1) or (pos('#',sDirs[n])<>1) then
        sDirs.Delete(n);

    // check the list for validity
    for n := 0 to pred(sDirs.count) do
    begin
      SubPath := StrFilter(sDirs[n], '#' + cZiffern);
      if (length(SubPath) < 4) then
      begin
        FotoLog(cERRORText + ' Backup: Unterverzeichnis nicht in der Form #nnn ');
        FotoLog(cFotoService_AbortTag);
        continue;
      end;
      if (SubPath[1] <> '#') then
      begin
        FotoLog(cERRORText + ' Backup: Unterverzeichnis nicht in der Form #nnn ');
        FotoLog(cFotoService_AbortTag);
        continue;
      end;
      if (n<pred(sDirs.count)) then
       if not(FileExists(pBackUpRootPath+SubPath+PathDelim+'MOVE-OK')) then
       begin
        FileAlive(pBackUpRootPath+SubPath+PathDelim+'MOVE-OK');
        FotoLog(cINFOText + ' Backup: Verzeichnis "'+pBackUpRootPath+SubPath+'\" bereit zur Ablage');
       end;
    end;

    // check list for the
    if (sDirs.Count = 0) then
    begin
      FotoLog(cERRORText + ' Backup: Kein #nnn Unterverzeichnis in ' + pBackUpRootPath);
      FotoLog(cFotoService_AbortTag);
    end else
    begin
      // das gr��te Element w�hlen
      BackupDir := pBackUpRootPath + sDirs[pred(sDirs.Count)] + PathDelim;
    end;
    sDirs.Free;

    // TimeStamp in die Logdatei legen
    if not(LastLogWasTimeStamp) then
    begin
      FotoTransaction(cFTRN_timestamp, sTimeStamp);
      LastLogWasTimeStamp := true;
    end;

  end;
end;

procedure TOrgaMonApp.releaseGlobals;
begin
  if initialized then
  begin
    try
      FreeAndNil(tBAUSTELLE);
      FreeAndNil(tABLAGE);
    except
      on E: Exception do
        FotoLog(cERRORText + ' 345:' + E.ClassName + ': ' + E.Message);
    end;
  end;
end;

function TOrgaMonApp.DataPath: string; // ./dat/db/
begin
  result := pAppServicePath + cDBPath;
end;

function TOrgaMonApp.AuftragPath: string; // ./dat/Daten
begin
  result := pAppServicePath + cServerDataPath;
end;

function TOrgaMonApp.MySyncPath: string; // ./dat/sync
begin
  result := pAppServicePath + cSyncPath;
end;

function TOrgaMonApp.GEN_ID: integer;
var
  mIni: TIniFile;
begin
  mIni := TIniFile.Create(DataPath + cFotoService_IdFName);
  with mIni do
  begin
    result := StrToInt(ReadString(cGroup_Id_Default, 'Sequence', '0'));
    inc(result);
    if (result >= round(power(10, cAnzahlStellen_Transaktionszaehler))) then
      result := 1;
    WriteString(cGroup_Id_Default, 'Sequence', InttoStr(result));
  end;
  mIni.Free;
end;

procedure TOrgaMonApp.workEingang_JPG(sParameter: TStringList = nil);
var
  sFiles: TStringList;
  IgnoreIt: boolean;
  // �berspringen weil zu neu?!
  sFilesClientSorter: TStringList;
  sTemp: TStringList;
  n, m, i, f, r, w: integer;
  FileTimeStamp: TDateTime;
  d, File_Date: TANFiXDate;
  s, File_Seconds: TANFiXTime;
  FName, FNameBackup: string;
  DATEINAME_AKTUELL: string;
  Id: string; //
  bOrgaMon, bOrgaMonOld: TBLager;
  mderecOrgaMon: TMDERec;
  AuftragArt: string;
  FotoGeraeteNo: string;
  FotoParameter: string;
  FotoUserAndPath: string;

  // Ein symbolischer Ablage name, z.B. "stadtwerke-bruchsal"
  FotoZiel: string;

  // Ein realer Pfad in den die Bilder kopiert werden
  //  Backslash am Ende
  FotoAblage_PFAD: string;

  // ein Ziel-Unterverzeichnis in das die Bilder kopiert werden,
  //  Backslash am Ende
  FotoUnterverzeichnis: string;

  // FA, Ausbau, FN, Anlage usw.
  // Kompletter Dateiname, ohne Pfad
  FotoDateiName, FotoDateiNameVerfuegbar: string;

  sIndexDocument : TStringList;

  FullSuccess: boolean;
  FoundAuftrag: boolean;
  UmbenennungAbgeschlossen: boolean;
{$IFDEF FPC}
  Image: TPicture;
{$ELSE}
  Image: TJPEGImage;
{$ENDIF}
  sBaustelle: string;
  sZiel: string;

  BAUSTELLE_Index: integer;

  // alternativer Auftragspool
  fOrgaMonAuftrag: file of TMDERec;
  iEXIF: TExifData;
  FotoDateTime, DateiDateTime_1, DateiDateTime_2: TDateTime;

  // Foto - Umbenennung
  sFotoCall: TStringList;
  sFotoResult: TStringList;
  RenameError: boolean;

  // Parameter
  pAll: boolean;

  procedure unverarbeitet(m: integer);
  var
    FNameAlt: string;
    FNameNeu: string;
  begin
    FNameAlt := pFTPPath + sFiles[m];
    FNameNeu := pWebPath + Id + '+' + sFiles[m];

    // Datei wegsperren, aber nicht l�schen!
    if not(FileMove(
      { } FNameAlt,
      { } FNameNeu)) then
    begin
      FotoLog(cERRORText + ' 460: FileMove("' + FNameAlt + '", "' + FNameNeu + '")');
      FotoLog(cFotoService_AbortTag);
    end;

    FotoTransaction(cFTRN_move,
      { } FNameAlt +
      { } ' ' + FNameNeu);
    LastLogWasTimeStamp := false;

    // Datei aus der Verarbeitungskette entfernen
    sFiles.Delete(m);
  end;

begin
  if assigned(sParameter) then
  begin
    pAll := sParameter.Values['ALL'] <> cIni_Deactivate;
  end
  else
  begin
    pAll := true;
  end;

  ensureGlobals;

  // Init Phase
  sFiles := TStringList.Create;
  sFilesClientSorter := TStringList.Create;
  Id := '';

  // get File List
  dir(pFTPPath + '*.jpg', sFiles, false);

  // reduce to Files-Age > 5 Seconds
  d := DateGet;
  s := SecondsGet;
  for n := pred(sFiles.Count) downto 0 do
  begin
    FName := pFTPPath + sFiles[n];
    FileAge(FName, FileTimeStamp);
    File_Date := DateTime2long(FileTimeStamp);
    File_Seconds := cIllegalSeconds;

    IgnoreIt := true;
    repeat

      if not(DateOK(File_Date)) then
      begin
        FotoLog(
          { } cWARNINGText + ' 564: ' +
          { } 'Skip ' + FName + ' (FileTimeStamp illegal) ...');
        break;
      end;

      File_Seconds := dateTime2Seconds(FileTimeStamp);
      if SecondsDiff(d, s, File_Date, File_Seconds) < 4 then
      begin
        if DebugMode then
          FotoLog(
           { } cINFOText + ' 572: ' +
           { } 'Skip ' + FName + ' (too new) ...');
        break;
      end;

      IgnoreIt := false;

    until yet;
    if not(IgnoreIt) then
      sFilesClientSorter.AddObject(
        { } long2dateLog(File_Date) + '|' +
        { } secondstostr(File_Seconds) + '|' +
        { } sFiles[n], TObject(n));

  end;

  // Sort Files by "Date / Time", Oldest topmost
  sFilesClientSorter.sort;
  sTemp := TStringList.Create;
  for n := 0 to pred(sFilesClientSorter.Count) do
    sTemp.add(sFiles[integer(sFilesClientSorter.Objects[n])]);
  sFiles.Assign(sTemp);
  sTemp.Free;

  // Reduce Work to Only One?!
  if not(pAll) then
    for n := pred(sFiles.Count) downto 1 do
      sFiles.Delete(n);

  // Generate Work-TAN as "ID"
  if (sFiles.Count > 0) then
  begin
    Id := inttostrN(GEN_ID, cAnzahlStellen_Transaktionszaehler);
    CheckCreateDir(BackupDir + cFotoService_FTPBackupSubPath);
  end;

  // reduce to valid jpg's
  for n := pred(sFiles.Count) downto 0 do
  begin

    FullSuccess := false;
    FName := pFTPPath + sFiles[n];
{$IFDEF FPC}
    Image := TPicture.Create;
{$ELSE}
    Image := TJPEGImage.Create;
{$ENDIF}
    iEXIF := TExifData.Create;
    try
      repeat

        // Load it
        Image.LoadFromFile(FName);

        if (Image.Width < 280) then
        begin
          FotoLog(cERRORText + ' ' + sFiles[n] + ': Breite kleiner als 280');
          break;
        end;

        if (Image.Height < 280) then
        begin
          FotoLog(cERRORText + ' ' + sFiles[n] + ': H�he kleiner als 280');
          break;
        end;

        // load EXIF Info
        if not(iEXIF.LoadFromGraphic(FName)) then
        begin
          FotoLog(cERRORText + ' ' + sFiles[n] + ': EXiF konnte nicht geladen werden');
          break;
        end;

        FotoDateTime := iEXIF.DateTimeOriginal;
        if (FotoDateTime=TDateTimeTagValue.CreateMissingOrInvalid) then
        begin
          FotoLog(cERRORText + ' ' + sFiles[n] + ': EXiF Datum konnte nicht ermittelt werden');
          break;
        end;
        FullSuccess := true;

      until yet;

    except
      on E: Exception do
      begin
        FotoLog(cERRORText + ' ' + sFiles[n] + ': ' + E.Message);
      end;
    end;
    Image.Free;
    iEXIF.Free;

    if FullSuccess then
    begin

      // Datei-Datum und Datei-Uhrzeit anpassen
      DateiDateTime_1 := FileTouched(FName);
      if not(VeryClose(FotoDateTime,DateiDateTime_1)) then
      begin

       // Alter Stand
       FotoLog(cINFOText + ' 5730: ' + sFiles[n] + ' ' +
         {} dTimeStamp(DateiDateTime_1) + ' -> '+
         {} dTimeStamp(FotoDateTime) );
       if FileTouch(FName, FotoDateTime) then
       begin
         FotoTransaction(cFTRN_touch,
          {} sFiles[n] +
          {} ' ' + dTimeStamp(FotoDateTime));
         LastLogWasTimeStamp := false;
       end else
       begin
         FotoLog(cERRORText + ' 5737: ' + sFiles[n] + ': Touch misslungen' )
       end;

       for w := 1 to 5 do
       begin

          // Pr�fen, ob die �nderung angekommen ist
          DateiDateTime_2 := FileTouched(FName);
          if VeryClose(FotoDateTime,DateiDateTime_2) then
           break;

          FotoLog(cWARNINGText + ' 5744: ' + sFiles[n] + ' ' + dTimeStamp(DateiDateTime_2));

          // Pr�fen, ob sich zumindest etwas ver�ndert hat
          if VeryClose(DateiDateTime_1,DateiDateTime_2) then
           FotoLog(cWARNINGText + ' 5748: ' + sFiles[n] + ': Touch wirkungslos' )
          else
           FotoLog(cWARNINGText + ' 5750: ' + sFiles[n] + ': Touch fehlerhaft' );

          sleep(555); // gib dem Dateisystem Zeit
          if (w>=3) then
          begin
           if not(FileTouch(FName,FotoDateTime)) then
            FotoLog(cERRORText + ' 5754: ' + sFiles[n] + ': Touch misslungen' );
          end;
          sleep(555); // gib dem Dateisystem Zeit

        end;
      end;

      FNameBackup := BackupDir + cFotoService_FTPBackupSubPath + Id + '-' + sFiles[n];

      // Mache eine Sicherungskopie des Fotos
      if not(FileCopy(pFTPPath + sFiles[n], FNameBackup)) then
      begin
        FotoLog(
          { } cERRORText + ' 598: ' +
          { } 'can not write to ' + BackupDir + cFotoService_FTPBackupSubPath);
        FotoLog(cFotoService_AbortTag);
        exit;
      end;

      // Check Foto-Date again
      FotoDateTime := FotoAufnahmeMoment(FNameBackup);
      DateiDateTime_1 := FileTouched(FNameBackup);
      if not(VeryClose(FotoDateTime,DateiDateTime_1)) then
      begin
        FotoLog(
          { } cWARNINGText + ' 5775: ' +
          { } 'copy: Zieldatei verliert Dateiuhrzeit und Datumdatum');
        FotoLog(
          { } cWARNINGText + ' 5793: SOLL=' + dTimeStamp(FotoDateTime));

        // Ist es ein Timing-Problem - m�ssen wir warten?
        for w := 1 to 8 do
        begin

         FotoLog(
          {} cWARNINGText +
          {} ' 5795: IST('+IntToStr(w)+'/8)=' +
          {} dTimeStamp(DateiDateTime_1));
          sleep(555);

         if (w=5) then
         begin
          FotoLog(cINFOText + ' 5798: Touch');
          if not(FotoTouch(FNameBackup)) then
           FotoLog(
            { } cERRORText + ' 5780: ' +
            { } ' touch ' + FNameBackup);
         end;

         DateiDateTime_1 := FileTouched(FNameBackup);
        end;

      end;

    end
    else
    begin
      unverarbeitet(n);
    end;
  end;

  if (sFiles.Count > 0) then
  begin

    bOrgaMon := TBLager.Create;
    bOrgaMon.Init(DataPath + 'AUFTRAG+TS', mderecOrgaMon, sizeof(TMDERec));
    bOrgaMon.BeginTransaction(now);

    if FileExists(DataPath + '_AUFTRAG+TS' + cBL_FileExtension) then
    begin
      bOrgaMonOld := TBLager.Create;
      bOrgaMonOld.Init(DataPath + '_AUFTRAG+TS', mderecOrgaMon, sizeof(TMDERec));
      bOrgaMonOld.BeginTransaction(now);
    end
    else
    begin
      bOrgaMonOld := nil;
    end;

    sFiles.sort;

    // Umbenennen nach dem Standard der jeweiligen Baustelle
    for m := pred(sFiles.Count) downto 0 do
    begin
      RenameError := false;
      FullSuccess := false;
      FoundAuftrag := false;
      UmbenennungAbgeschlossen := false;
      BAUSTELLE_Index := -1;

      // Parameter aus der Bilddatei berechnen
      FotoGeraeteNo := nextp(sFiles[m], '-', 0);
      AUFTRAG_R := StrToIntDef(nextp(sFiles[m], '-', 1), -1);
      FotoParameter := nextp(nextp(sFiles[m], '-', 2), '.', 0);
      sBaustelle := '';
      sZiel := '';

      // passenden Auftrag suchen
      while true do
      begin

        if (length(FotoGeraeteNo)<>3) then
        begin
          FotoLog(cERRORText + ' ' + sFiles[m] + ': 719: Syntax des Dateinamens falsch: Ger�te-ID nicht erkennbar!');
          break;
        end;

        if (StrToIntDef(FotoGeraeteNo,0)<=0) then
        begin
          FotoLog(cERRORText + ' ' + sFiles[m] + ': 725: Syntax des Dateinamens falsch: Ger�te-ID nicht im Bereich von 001-999!');
          break;
        end;

        if (AUFTRAG_R < 1) then
        begin
          FotoLog(cERRORText + ' ' + sFiles[m] + ': 731: Syntax des Dateinamens falsch: RID konnte nicht ermittelt werden!');
          break;
        end;

        // (1/3) Im OrgaMon Record-Store
        if bOrgaMon.exist(AUFTRAG_R) then
        begin
          bOrgaMon.get;
          FoundAuftrag := true;
          break;
        end;

        FotoLog('WARNUNG: ' + sFiles[m] + ': RID in ' + bOrgaMon.FileName + ' nicht vorhanden!');

        // (2/3) In der Alternative suchen
        if (assigned(bOrgaMonOld)) then
        begin
          if bOrgaMonOld.exist(AUFTRAG_R) then
          begin
            bOrgaMonOld.get;
            FoundAuftrag := true;
            break;
          end;

          FotoLog('WARNUNG: ' + sFiles[m] + ': RID in ' + bOrgaMonOld.FileName + ' nicht vorhanden!');
        end;

        // (3/3) Im aktuellen Auftrag des Monteurs
        assignFile(fOrgaMonAuftrag, pAppServicePath + cServerDataPath + FotoGeraeteNo + cDATExtension);
        try
          reset(fOrgaMonAuftrag);
        except
          on E: Exception do
            FotoLog(cERRORText + ' 614: ' + sFiles[m] + ':' + E.Message);
        end;

        for f := 1 to FileSize(fOrgaMonAuftrag) do
        begin
          read(fOrgaMonAuftrag, mderecOrgaMon);
          if (AUFTRAG_R = mderecOrgaMon.RID) then
          begin
            FoundAuftrag := true;
            break;
          end;
        end;
        CloseFile(fOrgaMonAuftrag);

        if not(FoundAuftrag) then
          FotoLog(cERRORText + ' ' + sFiles[m] + ': RID ' + InttoStr(AUFTRAG_R) + ' konnte nicht gefunden werden!');
        break;
      end;

      if FoundAuftrag then
      begin

        // das Baustellenk�rzel wird aus dem AUFTRAG.BLA ermittelt
        sBaustelle := Oem2utf8(mderecOrgaMon.Baustelle);
        while true do
        begin

          // Modus und weitere Parameter der Fotobenennung werden �ber
          // Tabelle "BAUSTELLE" ermittelt
          BAUSTELLE_Index := tBAUSTELLE.locate(0, sBaustelle);
          if (BAUSTELLE_Index > -1) then
          begin

            sFotoCall := TStringList.Create;
            with mderecOrgaMon do
            begin
              // Belegung der Foto-Parameter
              sFotoCall.Values[cParameter_foto_Modus] := tBAUSTELLE.readCell(BAUSTELLE_Index, cE_FotoBenennung);
              sFotoCall.Values[cParameter_foto_parameter] := FotoParameter;
              // bisheriger Bildparameter
              sFotoCall.Values[cParameter_foto_baustelle] := sBaustelle;
              sFotoCall.Values[cParameter_foto_strasse] := Oem2asci(Zaehler_Strasse);
              sFotoCall.Values[cParameter_foto_ort] := Oem2asci(Zaehler_Ort);
              sFotoCall.Values[cParameter_foto_zaehler_info] := Zaehler_Info;
              sFotoCall.Values[cParameter_foto_RID] := InttoStr(RID);

              AuftragArt := Art;
              sFotoCall.Values[cParameter_foto_ART] := Art;
              sFotoCall.Values[cParameter_foto_zaehlernummer_alt] := zaehlernummer_alt;
              sFotoCall.Values[cParameter_foto_zaehlernummer_neu] := zaehlernummer_neu;
              sFotoCall.Values[cParameter_foto_ReglerNummer_neu] := Reglernummer_neu;
              sFotoCall.Values[cParameter_foto_geraet] := FotoGeraeteNo;
              sFotoCall.Values[cParameter_foto_Pfad] := DataPath;
              sFotoCall.Values[cParameter_foto_Datei] := pFTPPath + sFiles[m];
              sFotoCall.Values[cParameter_foto_ABNummer] := ABNummer;
            end;

            if DebugMode then
              Dump(cINFOText + ' Foto(' + InttoStr(AUFTRAG_R) + ' ', sFotoCall);

            // globale Methode zur Foto-Um-Benennung
            sFotoResult := Foto(sFotoCall);

            if DebugMode then
              Dump(cINFOText + ' ) : ', sFotoResult);

            sFotoCall.Free;

            // Ergebnis auswerten
            FotoDateiName := sFotoResult.Values[cParameter_foto_neu];
            UmbenennungAbgeschlossen := (sFotoResult.Values[cParameter_foto_fertig] = active(true));
            sZiel := sFotoResult.Values[cParameter_foto_Ziel];

            if (sFotoResult.Values[cParameter_foto_Fehler] <> '') then
            begin
              RenameError := true;
              FotoLog(cERRORText + ' ' + sFotoResult.Values[cParameter_foto_Fehler]);
            end;

            sFotoResult.Free;

            if (sBaustelle <> sZiel) then
              BAUSTELLE_Index := tBAUSTELLE.locate(0, sZiel);

          end;

          //
          if (BAUSTELLE_Index <= -1) then
          begin
            if (sBaustelle <> sZiel) then
              FotoLog(cERRORText + ' 5946:' + sFiles[m] + ': Ziel-Baustelle "' + sZiel + '" unbekannt!')
            else
              FotoLog(cERRORText + ' 5948:' + sFiles[m] + ': Baustelle "' + sBaustelle + '" unbekannt!');
          end;

          break;
        end;

        //
        if (BAUSTELLE_Index > -1) and not(RenameError) then
        begin

          // FotoUnterverzeichnis ist das Unterverzeichnis in Fotoziel
          FotoUserAndPath := tBAUSTELLE.readCell(BAUSTELLE_Index, cE_FTPUSER);

          // Fotoziel ist der Name der Internet-Ablage nicht 1:1 der Ablage-Pfad
          FotoZiel := e_r_FTP_LoginUser(FotoUserAndPath);
          FotoUnterverzeichnis := e_r_FTP_SourcePath(FotoUserAndPath);

          // Dinge, die im Pfad angegeben werden k�nnen
          { cParameter_foto_parameter } ersetze('~fx~', FotoParameter, FotoUnterverzeichnis);
          { cParameter_foto_baustelle } ersetze('~baustelle~', sBaustelle, FotoUnterverzeichnis);
          { cParameter_foto_ART } ersetze('~art~', AuftragArt, FotoUnterverzeichnis);
          { cParameter_foto_geraet } ersetze('~geraet~', FotoGeraeteNo, FotoUnterverzeichnis);

          repeat

            if (length(FotoZiel) < 3) then
            begin
              FotoLog(cERRORText + ' ' + sFiles[m] + ': ' + sBaustelle + ': Keine Internet-Ablage definiert');
              break;
            end;

            // Workaround, Linux User mit Ziffer am Anfang geht nicht
            if (FotoZiel[1] = 'u') and CharInSet(FotoZiel[2], ['0' .. '9']) then
              FotoZiel := copy(FotoZiel, 2, MaxInt);

            r := tABLAGE.locate('NAME', FotoZiel { + } );
            if (r = -1) then
            begin
              FotoLog(cERRORText + ' ' + sFiles[m] + ': ' + sBaustelle + ': Internet-Ablage "' + FotoZiel +
                '": Die Ablage ist nicht bekannt');
              break;
            end;

            FotoAblage_PFAD := tABLAGE.readCell(r, 'PFAD');
            if not(DirExists(FotoAblage_PFAD)) then
            begin
              FotoLog(cERRORText + ' ' + sFiles[m] + ': ' + sBaustelle + ': Internet-Ablage "' + FotoZiel +
                '": Das Verzeichnis "' + FotoAblage_PFAD + '" existiert nicht');
              break;
            end;

            if (FotoUnterverzeichnis<>'') then
            begin
              if not(DirExists(FotoAblage_PFAD + FotoUnterverzeichnis)) then
              begin
               CheckCreateDir(FotoAblage_PFAD + FotoUnterverzeichnis);

               if not(FileCopy(FotoAblage_PFAD + cIsAblageMarkerFName, FotoAblage_PFAD + FotoUnterverzeichnis + cIsAblageMarkerFName)) then
               begin
                  FotoLog(
                   {} cERRORText +
                   {} ' cp ' +
                   {} '"' + FotoAblage_PFAD + cIsAblageMarkerFName + '"' +
                   {} ' ' +
                   {} '"' + FotoAblage_PFAD + FotoUnterverzeichnis + cIsAblageMarkerFName + '" misslungen');
                  break;
               end;
               // more to copy here? (Make/Load a list?)

               sIndexDocument := TStringList.Create;
               with sIndexDocument do
               begin
                add('<?php');
                add(' //');
                add(' // This PHP-Code was generated by cOrgaMonFoto at ' + sTimeStamp + ' by FotoExec.pas Line 943');
                add(' //');
                add(' include_once("'+
                 { } fill('../',
                 { } CharCount(PathDelim,FotoUnterverzeichnis) +
                 { } 1) +
                 { } 'zipablagen.php");');
                add('?>');
                SaveToFile(FotoAblage_PFAD + FotoUnterverzeichnis + 'index.php');
               end;
               sIndexDocument.Free;

               // Bericht
               FotoLog(cINFOText + ' ' + sFiles[m] + ': ' + sBaustelle + ': Internet-Ablage "' + FotoZiel +
                 '": Das Unterverzeichnis "' + FotoUnterverzeichnis + '" wurde erstellt');
              end;

              // Weiterarbeiten mit dem vollen Path
              FotoAblage_PFAD := FotoAblage_PFAD + FotoUnterverzeichnis;
            end;

            // freien Ziel-Dateinamen finden:
            FotoDateiNameVerfuegbar := FotoDateiName;
            i := 1;
            repeat
              if not(FileExists(FotoAblage_PFAD + FotoDateiNameVerfuegbar)) then
                break;
              if (i = 1) then
                FotoDateiNameVerfuegbar := copy(FotoDateiNameVerfuegbar, 1, revpos('.', FotoDateiNameVerfuegbar) - 1) +
                  '-' + InttoStr(i) + '.jpg'
              else
                FotoDateiNameVerfuegbar := copy(FotoDateiNameVerfuegbar, 1, revpos('-', FotoDateiNameVerfuegbar) - 1) +
                  '-' + InttoStr(i) + '.jpg';
              inc(i);
            until eternity;

            // Ist der Dateiname schon belegt, wird ggf. Platz geschaffen.
            // Der hereinkommende Name hat Vorrang vor den bisher
            // unter diesem Namen bereitgestellten Bildern.
            // Aber nur wenn die hereinkommende Datei j�nger ist
            // als das aktuelle Bild
            if (FotoDateiName <> FotoDateiNameVerfuegbar) then
            begin
              if (
                { } FotoAufnahmeMoment(pFTPPath + sFiles[m])
                { } >=
                { } FotoAufnahmeMoment(FotoAblage_PFAD + FotoDateiName)) then
              begin
                if not(RenameFile(
                  { } FotoAblage_PFAD + FotoDateiName,
                  { } FotoAblage_PFAD + FotoDateiNameVerfuegbar)) then
                begin
                  FotoLog(cERRORText + ' 802: ' + sFiles[m] + ': Platz schaffen nicht erfolgreich');
                  break;
                end;
              end
              else
              begin
                FotoLog(cINFOText + ' ' + sFiles[m] + ': Veraltetes Bild, behalte Neueres');
                FotoDateiName := FotoDateiNameVerfuegbar;
              end;
            end;

            // Transaktion archivieren
            FotoTransaction(cFTRN_copy,
              { } sFiles[m] +
              { } ' ' +
              { } FotoAblage_PFAD + FotoDateiName);
            LastLogWasTimeStamp := false;

            // Auszeichnen, wenn die Umbenennung vorl�ufig ist
            if not(UmbenennungAbgeschlossen) then
            begin
              // aktueller Dateiname, wo er im Moment liegt
              DATEINAME_AKTUELL := FotoAblage_PFAD + FotoDateiName;

              if DebugMode then
                FotoLog(
                 {} cINFOText + ' 954: ' +
                 {} cFotoService_UmbenennungAusstehendFName + ': f�ge ' +
                 {} '"' + DATEINAME_AKTUELL + '"' +
                 {} ' hinzu');

              AppendStringsToFile(
                { DATEINAME_ORIGINAL } sFiles[m] + ';' +
                { DATEINAME_AKTUELL } DATEINAME_AKTUELL + ';' +
                { RID } InttoStr(AUFTRAG_R) + ';' +
                { GERAETENO } FotoGeraeteNo + ';' +
                { BAUSTELLE } sBaustelle + ';' +
                { MOMENT } DatumLog,
                { CSV-Dateiname } DataPath + cFotoService_UmbenennungAusstehendFName);
            end;

            // Foto in die richtige Ablage kopieren!
            if not(FileCopy(
              { } pFTPPath + sFiles[m],
              { } FotoAblage_PFAD + FotoDateiName)) then
            begin
              FotoLog(cERRORText + ' {' + sFiles[m] + ': Kopieren nicht erfolgreich');
              FotoLog('Quelle war: "' + pFTPPath + sFiles[m] + '"');
              FotoLog('Ziel war: "' + FotoAblage_PFAD + FotoDateiName + '" }');
              break;
            end;

            // Touch pr�fen
            if not(FotoTouch(FotoAblage_PFAD + FotoDateiName)) then
            begin
              FotoLog(
               { } cERRORText + ' 6153:' +
               { } ' FotoTouch(' + FotoAblage_PFAD + FotoDateiName + ')');
            end;

            FullSuccess := true;

          until yet;
        end;

      end;

      if not(FullSuccess) then
        unverarbeitet(m);

    end; // for m

    bOrgaMon.EndTransaction;
    bOrgaMon.Free;

    if assigned(bOrgaMonOld) then
    begin
      bOrgaMonOld.EndTransaction;
      bOrgaMonOld.Free;
    end;

    // Bilder jetzt aus FTP-Bereich l�schen
    if (sFiles.Count > 0) then
    begin
      FotoLog(Id);
      for n := 0 to pred(sFiles.Count) do
        if not(FileDelete(pFTPPath + sFiles[n])) then
        begin
          FotoLog(cERRORText + ' "' + pFTPPath + sFiles[n] + '" : Nicht l�schbar');
          FotoLog(cFotoService_AbortTag);
          break;
        end;
    end;

  end;

  sFiles.Free;
  sFilesClientSorter.Free;
end;

procedure TOrgaMonApp.workEingang_TXT(sParameter: TStringList = nil);
var
  sFiles: TStringList;
  n: integer;
  ProtokollFName : string;

  // Parameter
  pAll: boolean;

begin
  if assigned(sParameter) then
  begin
    pAll := sParameter.Values['ALL'] <> cIni_Deactivate;
  end
  else
  begin
    pAll := true;
  end;

  ensureGlobals;

  // Init Phase
  sFiles := TStringList.Create;

  // get File List
  dir(pFTPPath + '*' + cProtExtension, sFiles, false);

  // reduce to Protocols
  for n := pred(sFiles.Count) downto 0 do
  begin
   if (pos(cUTF8DataExtension,sFiles[n])>0) then
   begin
    sFiles.Delete(n);
    continue;
   end;
   if (FSize(pFTPPath+sFiles[n])<16) then
   begin
    sFiles.Delete(n);
    continue;
   end;
  end;

  // Reduce Work to Only One?!
  if not(pAll) then
    for n := pred(sFiles.Count) downto 1 do
      sFiles.Delete(n);

  // ev. Zeit Datum protokollieren
  if (sFiles.Count>0) then
      AppendStringsToFile(
        { } 'timestamp ' + sTimeStamp,
        { } DiagnosePath + cProtokollTransaktionenFName);

  // Protokolle verschieben
  for n := pred(sFiles.Count) downto 0 do
  begin
    ProtokollFName := UpperCase(nextp(sFiles[n],'.',0));

    if FileMove(
     { } pFTPPath + sFiles[n],
     { } pAppServicePath + cProtokollPath + ProtokollFName + cProtExtension) then
    begin
      AppendStringsToFile(
        { } 'cp ' + sFiles[n] +
        { } ' ' +
        { } pAppServicePath + cProtokollPath + ProtokollFName + cProtExtension,
        { } DiagnosePath + cProtokollTransaktionenFName);
    end else
    begin
      FotoLog(cERRORText + ' Protokoll konnte nicht aus FTP-Bereich verschoben werden (mv '+sFiles[n]+' '+pAppServicePath + cProtokollPath+')');
      FotoLog(cFotoService_AbortTag);
    end;
  end;

  sFiles.Free;
end;

const
  col_GERAET = 0;
  col_NAME = 1;
  col_AUFNAHME = 2;
  col_ANKUENDIGUNG = 3;
  col_LIEFERUNG = 4;

  //
  // Zeitraum der zur�ck geblickt wird, Foto Ank�ndigungen, die
  // weiter zur�ck liegen werden nicht ber�cksichtigt
  //
  BETRACHTUNGS_ZEITRAUM = 25; { [Tage] }

  //
  // Bilder werden im normal-Fall per FTP vom Handy "sofort" nach
  // der Aufnahme versendet. Die Ank�ndigung im Protokoll wird
  // zwar auch sofort eingetragen, wir wissen davon aber erst nach dem
  // "senden" des Monteures.
  //
  VERZOEGERUNG_ANKUENDIGUNG = 14; { [Tage] }

procedure TOrgaMonApp.workAusstehendeFotos;
var
  BildAnkuendigung: TStringList;
  BildLieferung: TStringList;
  AllTRN: TStringList;
  FTPLog: TStringList;
  TAN: string;
  m, n, o, r: integer;
  StartMoment: TDateTime;
  ProceedMoment: TDateTime;
  ProceedMoment_First: TDateTime;
  ProceedMoment_Oldest: TDateTime;
  LogMoment_Oldest: TDateTime;
  FName: string;
  PROTOKOLL: string;
  sProtokoll: TStringList;
  sHANGOVER: tsTable;
  sMONTEURE: tsTable;
  BildName: string;
  LieferMoment_First: TDateTime;
  sLieferMoment_First: string;
  sLieferMoment: string;
  GERAET, _GERAET, GERAETE: string;
  Anzahl: integer;
  GesamtAnzahl: integer;
  Timer: int64;
  PAPERCOLOR: string;
  Age: integer; // [Sekunden]

  procedure WriteIt { (_GERAET) };
  var
    n: integer;
  begin
    with sMONTEURE do
    begin
      n := locate('GERAET', _GERAET);
      if (n = -1) then
      begin
        n := addRow;
        writeCell(n, 'GERAET', _GERAET);
      end;
      writeCell(n, 'R�CKSTAND', InttoStr(Anzahl));
    end;
    GesamtAnzahl := GesamtAnzahl + Anzahl;
  end;

begin
  StartMoment := now;
  Timer := RDTSCms;

  AllTRN := TStringList.Create;
  FTPLog := TStringList.Create;
  BildAnkuendigung := TStringList.Create;
  BildLieferung := TStringList.Create;
  sHANGOVER := tsTable.Create;
  sMONTEURE := tsTable.Create;

  ensureGlobals;

  ProceedMoment_First := StartMoment;
  ProceedMoment_Oldest := StartMoment - BETRACHTUNGS_ZEITRAUM;

  // Pr�fe ob �ber der Pr�fungszeitraum �berhaupt genung
  // protokolliert ist, oder ob wir ev. k�rzen m�ssen
  FTPLog.LoadFromFile(DiagnosePath + cFotoTransaktionenFName);
  LogMoment_Oldest := StartMoment;
  for n := 0 to pred(FTPLog.count) do
   if (pos('timestamp ', FTPLog[n]) = 1) then
   begin
     LogMoment_Oldest := Long2DateTime(StrtoIntdef(nextp(FTPLog[n], ' ', 1),-1)) + 1.0;
     break;
    end;

  // Wenn der Betrachtungszeitraum gar nicht protokolliert wurde?
  if (LogMoment_Oldest > ProceedMoment_Oldest) then
   // Korrigiere das am weitesten zur�ckliegende Datum auf den
   // FotoLog- Start
   ProceedMoment_Oldest := LogMoment_Oldest;

  if DebugMode then
    FotoLog(
      { } cINFOText + ' 1271: ' +
      { } 'vom ' +
      { } long2date(ProceedMoment_Oldest) +
      { } ' bis ' +
      { } long2date(ProceedMoment_First) +
      { } ' ...');

  with sHANGOVER do
  begin
    addcol('GERAET');
    addcol('NAME');
    addcol('AUFNAHME_MOMENT');
    addcol('ANK�NDIGUNG');
    addcol('LIEFERUNG');
  end;

  with sMONTEURE do
  begin
    addcol('GERAET'); // dreistellige Nummer
    addcol('MONTEUR'); // Name des Monteures
    addcol('LETZTER_UPLOAD'); // Datum + Uhr der letzten Bild-Lieferung
    addcol('R�CKSTAND'); // Anzahl der Bilder, die noch fehlen
    addcol('VOM'); // Datum des �ltesten Bildes das fehlt
    addcol('PAPERCOLOR');
  end;

  { Schritt 1: Bildnamen aus der Ank�ndigung ermitteln und das Datum der Ank�ndigung im Protokoll }
  dir(pAppServicePath + cApp_TAN_Maske + '.', AllTRN, false);
  AllTRN.sort;
  for n := pred(AllTRN.Count) downto 0 do
  begin
    TAN := StrFilter(AllTRN[n], cZiffern);

    if (length(TAN) = length(cFirstTrn)) then
    begin

      // Dateiname der Ergebnisdatei
      FName := { } pAppServicePath +
      { } TAN + PathDelim +
      { } TAN + cUTF8DataExtension;

      ProceedMoment := FileDateTime(FName);

      if (ProceedMoment <> 0) then
      begin

        //
        // Abbrechen, wenn es vorhanden ist aber zu weit zur�ck liegt
        //
        if (ProceedMoment < ProceedMoment_Oldest) then
          break;

        BildLieferung.LoadFromFile(
          { } pAppServicePath +
          { } TAN + PathDelim +
          { } TAN + cUTF8DataExtension);
        for m := 0 to pred(BildLieferung.Count) do
        begin
          PROTOKOLL := nextp(BildLieferung[m], ';', cMobileMeldung_COLUMN_PROTOKOLL);
          if pos('F', PROTOKOLL) > 0 then
          begin
            sProtokoll := split(PROTOKOLL, '~');
            for o := 0 to pred(sProtokoll.Count) do
              if (pos('F', sProtokoll[o]) = 1) then
                if (pos('=', sProtokoll[o]) = 3) then
                  with sHANGOVER do
                  begin
                    { Bilddateiname ermitteln }
                    BildName := nextp(sProtokoll[o], '=', 1);

                    { Ger�tenummer ermitteln }
                    GERAET := copy(BildName, 1, 3);
                    if not(TOrgaMonApp.isGeraeteNo(GERAET)) then
                      continue;

                    { �ltestes Datum ermitteln }
                    if (ProceedMoment < ProceedMoment_First) then
                      ProceedMoment_First := ProceedMoment;

                    { Eintrag in der Tabelle suchen }
                    r := locate(col_NAME, BildName);
                    if (r = -1) then
                    begin
                      // Neu-Eintrag
                      r := addRow;
                      writeCell(r, col_GERAET, GERAET);
                      writeCell(r, col_NAME, BildName);
                      writeCell(r, col_ANKUENDIGUNG, dTimeStamp(ProceedMoment));
                    end
                    else
                    begin
                      { wir wollen den �ltesten (kleinsten) Ank�ndigungsmoment }
                      if (readCell(r, col_ANKUENDIGUNG) = '') or
                        (readCell(r, col_ANKUENDIGUNG) > dTimeStamp(ProceedMoment)) then
                        writeCell(r, col_ANKUENDIGUNG, dTimeStamp(ProceedMoment));
                    end;
                  end;
            sProtokoll.Free;
          end;
        end;
      end;
    end;
  end;

  if DebugMode then
   sHANGOVER.SaveToHTML(pWebPath + 'HANGOVER.html');

  { Schritt 2: Erg�nzung der Lieferdatums }
  LieferMoment_First := ProceedMoment_First - VERZOEGERUNG_ANKUENDIGUNG;
  sLieferMoment_First := dTimeStamp(LieferMoment_First);

  // Bestimmen ab welchem Zeitpunkt die Datei relevant ist
  // Dabei die Monteure sammeln, die wann zuletzt geliefert haben
  //
  GERAETE := '';
  with sMONTEURE do
    for n := pred(FTPLog.Count) downto 0 do
    begin

      if (pos('timestamp ', FTPLog[n]) = 1) then
      begin
        sLieferMoment := copy(FTPLog[n], 11, MaxInt);
        if (sLieferMoment < sLieferMoment_First) then
          break;
      end;

      BildName := '';
      if (pos('cp ', FTPLog[n]) = 1) then
        BildName := nextp(FTPLog[n], ' ', 1);

      if (pos('mv ', FTPLog[n]) = 1) then
        BildName := ExtractFileName(nextp(FTPLog[n], ' ', 1));

      if (BildName <> '') and (pos(cFotoService_NeuPlatzhalter, BildName) = 0) then
      begin
        //
        GERAET := copy(BildName, 1, 3);
        if pos('{' + GERAET + '}', GERAETE) = 0 then
        begin
          GERAETE := GERAETE + '{' + GERAET + '}';

          r := addRow;
          writeCell(r, 'GERAET', GERAET);
          writeCell(r, 'LETZTER_UPLOAD', sLieferMoment);

        end;

      end;

    end;
  n := max(n, 0);

  if DebugMode then
   sMONTEURE.SaveToHTML(pWebPath + 'MONTEURE.html');

  if DebugMode then
    FotoLog(
    { } cINFOText + ' 1431: ' +
    { } 'Foto-Lieferungen ab ' +
    { } long2date(LieferMoment_First) +
    { } ' also ab Zeile ' +
    { } InttoStr(n) +
    { } ' ...');

  // Nun gelieferten die Bilder in der Soll Liste erg�nzen
  sLieferMoment := sLieferMoment_First;
  for m := n to pred(FTPLog.Count) do
  begin

    if (pos('timestamp ', FTPLog[m]) = 1) then
    begin
      sLieferMoment := copy(FTPLog[m], 11, MaxInt);
      continue;
    end;

    BildName := '';
    if (pos('cp ', FTPLog[m]) = 1) then
      BildName := nextp(FTPLog[m], ' ', 1);

    if (pos('mv ', FTPLog[m]) = 1) then
      BildName := ExtractFileName(nextp(FTPLog[m], ' ', 1));

    if (BildName <> '') and (pos(cFotoService_NeuPlatzhalter, BildName) = 0) then
    begin

      with sHANGOVER do
      begin

        // durch Nachlieferungen auf einem anderen Zustellungsweg
        // z.B. per eMail kann die Dateiendung verf�lscht werden
        // aus .jpg wird dann z.B. .JPG oder �hnlich. Wir m�ssen
        // hier leider angleichen
        if (pos('.jpg', BildName) = 0) then
          BildName := copy(BildName, 1, length(BildName) - 4) + '.jpg';

        { Eintrag in der Tabelle suchen }
        r := locate(col_NAME, BildName);
        if (r = -1) then
        begin
          //
          // Dies ist ein bereits geliefertes Bild wobei noch nicht "gesendet" wurde
          // oder die ank�ndigung in der Vergangenheit liegt. Das Anf�gen in die �bersicht
          // ist optional
          //
          {
            r := addRow;
            writeCell(r, col_GERAET, copy(BildName, 1, 3));
            writeCell(r, col_NAME, BildName);
            writeCell(r, col_LIEFERUNG, LieferMoment);
          }
        end
        else
        begin
          { wir wollen den �ltesten Ank�ndigungsmoment }
          if (readCell(r, col_LIEFERUNG) = '') or (readCell(r, col_LIEFERUNG) > sLieferMoment) then
            writeCell(r, col_LIEFERUNG, sLieferMoment);
        end;
      end;
    end;
  end;

  with sHANGOVER do
  begin
    sortby('GERAET;LIEFERUNG;ANK�NDIGUNG');

    //
    // nun reduzieren auf die, die noch nicht geliefert wurden
    //
    for r := RowCount downto 1 do
      if (readCell(r, col_LIEFERUNG) <> '') then
        del(r);

    // Diese Detail-Liste auch ausgeben
    //
    SaveToFile(DataPath + 'FotoService-Upload-Ausstehend.csv');
    SaveToHTML(pWebPath + 'ausstehende-details.html');
  end;

  if DebugMode then
   sHANGOVER.SaveToHTML(pWebPath + 'HANGOVER-2.html');

  //
  // Nun �ber die Ger�te kumulieren
  //
  _GERAET := '';
  Anzahl := 0;
  with sHANGOVER do
  begin
    for r := 1 to RowCount do
    begin
      GERAET := readCell(r, 'GERAET');
      if (GERAET = _GERAET) then
      begin
        inc(Anzahl);
      end
      else
      begin
        if (_GERAET <> '') then
          WriteIt;
        Anzahl := 1;
        _GERAET := GERAET;
      end;
    end;
    if (RowCount > 0) then
      WriteIt;
  end;

  if DebugMode then
   sHANGOVER.SaveToHTML(pWebPath + 'HANGOVER-3.html');


  with sMONTEURE do
  begin

    //
    // Reduzieren auf die Monteure, die Bilder schuldig sind
    //
    GesamtAnzahl := 0;
    for r := RowCount downto 1 do
    begin
      Anzahl := StrToIntDef(readCell(r, 'R�CKSTAND'), 0);
      if (Anzahl = 0) then
      begin
        del(r)
      end
      else
      begin
        //
        // Aufkummulieren der Gesamtfehlmenge
        //
        inc(GesamtAnzahl, Anzahl);

        // Nachr�sten der Monteurs-Namen
        // imp pend

        // Eintragen der Farbgebung
        //
        Age := SecondsDiff(StartMoment, mkDateTime(readCell(r, 'LETZTER_UPLOAD'), true));
        case Age of
          - 1 * 3600 .. 10 * 60:
            PAPERCOLOR := '#00FF00'; { tief gr�n }
          10 * 60 + 1 .. 20 * 60:
            PAPERCOLOR := '#2EFE2E';
          20 * 60 + 1 .. 35 * 60:
            PAPERCOLOR := '#58FA58';
          35 * 60 + 1 .. 120 * 60:
            PAPERCOLOR := '#81F781';
          120 * 60 + 1 .. 180 * 60:
            PAPERCOLOR := '#A9F5A9';
          180 * 60 + 1 .. 4 * 3600:
            PAPERCOLOR := '#CEF6CE';
          4 * 3600 + 1 .. 5 * 3600:
            PAPERCOLOR := '#E0F8E0';
          5 * 3600 + 1 .. 6 * 3600:
            PAPERCOLOR := '#EFFBEF';
          6 * 3600 + 1 .. 7 * 3600:
            PAPERCOLOR := '#FFFFFF'; { wei� }
          7 * 3600 + 1 .. 8 * 3600:
            PAPERCOLOR := '#FBEFEF'; { pastel rot }
          8 * 3600 + 1 .. 9 * 3600:
            PAPERCOLOR := '#F6CECE';
          9 * 3600 + 1 .. 10 * 3600:
            PAPERCOLOR := '#F5A9A9';
          10 * 3600 + 1 .. 11 * 3600:
            PAPERCOLOR := '#F78181';
          11 * 3600 + 1 .. 12 * 3600:
            PAPERCOLOR := '#FA5858';
          12 * 3600 + 1 .. 13 * 3600:
            PAPERCOLOR := '#FE2E2E';
        else
          PAPERCOLOR := '#FF0000'; { tief rot }

        end;
        writeCell(r, 'PAPERCOLOR', PAPERCOLOR);
      end;
    end;

    if DebugMode then
      SaveToHTML(pWebPath + 'MONTEURE-2.html');

    // Sortieren, die schlimmsten nach oben
    sortby('R�CKSTAND numeric descending');

    if DebugMode then
      SaveToHTML(pWebPath + 'MONTEURE-3.html');

    // Die Namen nachtragen
    for r := 1 to RowCount do
    begin
     n := tIMEI.locate('GERAET', readCell(r,'GERAET'));
     if (n <> -1) then
       WriteCell(
        {} r,'MONTEUR',
        { } tIMEI.readCell(n, 'VORNAME') + ' ' +
        { } tIMEI.readCell(n, 'NACHNAME'));
    end;

    if DebugMode then
      SaveToHTML(pWebPath + 'MONTEURE-4.html');

    // Ausgabe nach htlm
    oHTML_Prefix :=
    { } '<h2>' + MandantId + ' vom ' + long2date(StartMoment) +
    { } ' um ' + secondstostr(StartMoment) + '</h2><br>' +
    { } '<h1>Es fehlen ' + InttoStr(GesamtAnzahl) + ' Foto(s):</h1><br>';
    oHTML_Postfix := '<br>' + cOrgaMonCopyright + '<br>[erstellt in ' + InttoStr(RDTSCms - Timer) + ' ms]';

    SaveToFile(DataPath + 'FotoService-Upload-�bersicht.csv');
    SaveToHTML(pWebPath + 'ausstehende-fotos.html');
  end;

  sHANGOVER.Free;
  sMONTEURE.Free;
  FTPLog.Free;
  AllTRN.Free;
  BildAnkuendigung.Free;
  BildLieferung.Free;
end;

procedure TOrgaMonApp.workWartend(sParameter: TStringList = nil);
var
  WARTEND: tsTable;
  Stat_Anfangsbestand: integer;
  Stat_NachtragBaustelle: integer;
  Stat_ZuAlt: integer;
  Stat_Verschwunden: integer;
  Stat_Doppelt: integer;
  Stat_Umbenannt: integer;

  col_MOMENT: integer;
  col_DATEINAME_AKTUELL: integer;

  MomentTimeout: TANFiXDate;
  CSV_ZaehlerNummer, CSV_ReglerNummer: tsTable;
  r, i, k, ro, c: integer;

  ZAEHLER_NUMMER_NEU: string;
  REGLER_NUMMER_NEU: string;
  NEU: string;

  ORIGINAL_DATEI: string;
  DATEINAME_AKTUELL: string;
  PARAMETER: string;
  FNameAlt, FNameNeu: string;
  RID: integer;
  sBaustelle: string;
  BAUSTELLE_Index: integer;

  // Baustellen-Ermittlung
  bOrgaMon: TBLager;
  mderecOrgaMon: TMDERec;
  FotoBenennungsModus: integer;

  // senden einf�rben
  tSENDEN: tsTable;

  // Doppelten Erkennung
  slAKTUELL: TStringList;

begin

  // 'FA' ... 'FE' ... 'FK' ->Regler#Neu-Umbenennung
  // 'FL' ... 'FN' ... 'FZ' ->Z�hler#Neu-Umbenennung

  // Init
  ensureGlobals;
  invalidate_NummerNeuCache;

  CSV_ZaehlerNummer := nil;
  CSV_ReglerNummer := nil;
  WARTEND := tsTable.Create;
  with WARTEND do
  begin

    // load+sort
    insertfromFile(DataPath + cFotoService_UmbenennungAusstehendFName);

    // init Global Stat
    Stat_Anfangsbestand := RowCount;
    Stat_Umbenannt := 0;
    Stat_NachtragBaustelle := 0;

    // Sortieren
    sortby('GERAETENO;MOMENT;DATEINAME_AKTUELL');
    if Changed then
      if DebugMode then
        FotoLog(
          { } cINFOText + ' 988: ' +
          { } ' Frisch sortiert');

    // sicherstellen von Spalten
    addcol('BAUSTELLE');
    addcol('MOMENT');

    // all zu alte Eintr�ge l�schen
    MomentTimeout := DatePlus(DateGet, -cMaxAge_Umbenennen);
    slAKTUELL := TStringList.Create;
    Stat_ZuAlt := 0;
    Stat_Verschwunden := 0;
    Stat_Doppelt := 0;
    col_MOMENT := colof('MOMENT');
    col_DATEINAME_AKTUELL := colof('DATEINAME_AKTUELL');
    for r := RowCount downto 1 do
    begin

      DATEINAME_AKTUELL := readCell(r, col_DATEINAME_AKTUELL);

      if (StrToIntDef(readCell(r, col_MOMENT), ccMaxDate) < MomentTimeout) then
      begin
        del(r);
        inc(Stat_ZuAlt);
        FotoLog(
          { } cWARNINGText + ' 1049: ' +
          { } 'gebe "' + DATEINAME_AKTUELL + '" auf, da sie �lter als ' + InttoStr(cMaxAge_Umbenennen) + ' Tage ist');
        continue;
      end;

      if not(FileExists(DATEINAME_AKTUELL)) then
      begin
        del(r);
        inc(Stat_Verschwunden);
        FotoLog(
          { } cWARNINGText + ' 1059: ' +
          { } 'gebe "' + DATEINAME_AKTUELL + '" auf, da sie verschwunden ist');
        continue;
      end;

      if (slAKTUELL.IndexOf(DATEINAME_AKTUELL) <> -1) then
      begin
        Del(r);
        inc(Stat_Doppelt);
        FotoLog(
          { } cWARNINGText + ' 1069: ' +
          { } 'gebe "' + DATEINAME_AKTUELL + '" auf, da der Eintrag doppelt ist');
        continue;
      end;

      slAKTUELL.add(DATEINAME_AKTUELL);
    end;
    slAKTUELL.Free;
  end;

  bOrgaMon := TBLager.Create;
  bOrgaMon.Init(DataPath + 'AUFTRAG+TS', mderecOrgaMon, sizeof(TMDERec));
  bOrgaMon.BeginTransaction(now);

  for r := WARTEND.RowCount downto 1 do
  begin

    // Init
    ZAEHLER_NUMMER_NEU := '';
    REGLER_NUMMER_NEU := '';
    NEU := '';

    // Parameter Init
    RID := StrToIntDef(WARTEND.readCell(r, 'RID'), 0);
    ORIGINAL_DATEI := WARTEND.readCell(r, 'DATEINAME_ORIGINAL');
    PARAMETER := nextp(ORIGINAL_DATEI, '-', 2);
    ersetze('.jpg', '', PARAMETER);

    // Nachtrag der Baustellen-Info
    sBaustelle := WARTEND.readCell(r, 'BAUSTELLE');
    if (sBaustelle = '') then
      if bOrgaMon.exist(RID) then
      begin
        bOrgaMon.get;
        sBaustelle := Oem2utf8(mderecOrgaMon.Baustelle);
        WARTEND.writeCell(r, 'BAUSTELLE', sBaustelle);
        inc(Stat_NachtragBaustelle);
      end;

    // Ist bei dieser Baustelle eine Umbenennung �berhaupt erw�nscht?
    // Die Frage sei dann aber erlaubt: Warum steht es dann in WARTEND?
    if (sBaustelle <> '') then
    begin
      BAUSTELLE_Index := tBAUSTELLE.locate(0, sBaustelle);
      if (BAUSTELLE_Index > -1) then
      begin
        FotoBenennungsModus := StrToIntDef(
          { } tBAUSTELLE.readCell(
          { } BAUSTELLE_Index,
          { } cE_FotoBenennung), 0);
      end;
    end;

    if (PARAMETER >= 'FL') then
    begin

      // Umbenennungsversuch �ber den Callback, in dem Fall also die Monteurs-Eingaben "Eingabe.nnn.txt"
      if (ZAEHLER_NUMMER_NEU = '') then
        ZAEHLER_NUMMER_NEU :=
        { } ZaehlerNummerNeu(
          { } RID,
          { } WARTEND.readCell(r, 'GERAETENO'));

      // Zuschaltbare Alternative f�r Notf�lle: den Inhalt einer CSV pr�fen
      if (ZAEHLER_NUMMER_NEU = '') then
        if FileExists(DataPath+cFotoService_GlobalHintFName_ZaehlerNummer) then
        begin
          if not(assigned(CSV_ZaehlerNummer)) then
          begin
            CSV_ZaehlerNummer := tsTable.Create;
            CSV_ZaehlerNummer.insertfromFile(DataPath + cFotoService_GlobalHintFName_ZaehlerNummer);
            FotoLog(cINFOText + ' 6881: lade zus�tzlich '+cFotoService_GlobalHintFName_ZaehlerNummer);
          end;
          ro := CSV_ZaehlerNummer.locate('ReferenzIdentitaet', InttoStr(RID));
          if (ro <> -1) then
            ZAEHLER_NUMMER_NEU := CSV_ZaehlerNummer.readCell(ro, 'ZaehlerNummerNeu');
        end;

      // kein Ergebnis -> keine Aktion
      if (ZAEHLER_NUMMER_NEU = '') then
        continue;

      NEU := ZAEHLER_NUMMER_NEU { + };
    end;

    if (PARAMETER < 'FL') then
    begin

      // Umbenennungsversuch �ber den Callback, in dem Fall also die Monteurs-Eingaben "Eingabe.nnn.txt"
      if (REGLER_NUMMER_NEU = '') then
        REGLER_NUMMER_NEU :=
        { } ReglerNummerNeu(
          { } RID,
          { } WARTEND.readCell(r, 'GERAETENO'));

      // Zuschaltbare Alternative f�r Notf�lle: den Inhalt einer CSV pr�fen
      if (REGLER_NUMMER_NEU = '') then
        if FileExists(DataPath+cFotoService_GlobalHintFName_ReglerNummer) then
        begin
          if not(assigned(CSV_ReglerNummer)) then
          begin
            CSV_ReglerNummer := tsTable.Create;
            CSV_ReglerNummer.insertfromFile(DataPath + cFotoService_GlobalHintFName_ReglerNummer);
            FotoLog(cINFOText + ' 6913: suche zus�tzlich in ' + cFotoService_GlobalHintFName_ReglerNummer);
          end;
          ro := CSV_ReglerNummer.locate('ReferenzIdentitaet', InttoStr(RID));
          if (ro <> -1) then
            REGLER_NUMMER_NEU := CSV_ReglerNummer.readCell(ro, 'ReglerNummerNeu');
        end;

      // kein Ergebnis -> keine Aktion
      if (REGLER_NUMMER_NEU = '') then
        continue;

      NEU := REGLER_NUMMER_NEU { + };
    end;

    // Verbotene Zeichen entfernen
    NEU := StrFilter(NEU, cInvalidFNameChars, true);

    // nichts neues? -> nichts machen in diesem Fall
    if (NEU = '') then
      continue;

    // Umbenennung starten
    FNameAlt := WARTEND.readCell(r, 'DATEINAME_AKTUELL');
    FNameNeu := FNameAlt;

    // das letzte "Neu" am Ende des Dateinamens z�hlt
    k := revpos(cFotoService_NeuPlatzhalter, FNameNeu);
    if (k = 0) then
    begin
      FotoLog(
        { } cERRORText + ' 1699: ' +
        { } '"' + cFotoService_NeuPlatzhalter + '"' +
        { } ' in "' + FNameNeu + '" nicht gefunden, Umbenennen dadurch unm�glich');
      continue;
    end;

    // Neuen Dateinamen zusammenbauen
    FNameNeu :=
    { } copy(FNameNeu, 1, pred(k)) +
    { } TOrgaMonApp.FormatZaehlerNummerNeu(NEU) +
    { } copy(FNameNeu, k + length(cFotoService_NeuPlatzhalter), MaxInt);

    // die (TMP..)- Sachen wieder wegzumachen
    FNameNeu := clearTempTag(FNameNeu);

    // Laufwerksbuchstaben
    if (CharCount(':', FNameNeu) <> 1) then
    begin
      FotoLog(
        { } cERRORText + ' 1718: ' +
        { } 'Umbenennung zu "' + FNameNeu + '" ist ung�ltig. Laufwerksangabe mit ":" fehlt');
      continue;
    end;

    // Pfad ging irgendwie verloren
    if (CharCount(PathDelim, FNameNeu) < 2) then
    begin
      FotoLog(
        { } cERRORText + ' 1727: ' +
        { } 'Umbenennung zu "' + FNameNeu + '" ist ung�ltig. Zwei Pfadtrenner "\" fehlen');
      continue;
    end;

    if (FNameNeu = FNameAlt) then
    begin
      // ohne Umbenennung (also es stimmt bereits!) einfach nur den Eintrag l�schen!
      FotoLog(cINFOText + ' 1735: Name "'+FNameNeu+'" stimmte bereits');
      WARTEND.Del(r);
      inc(Stat_Umbenannt);
    end
    else
    begin

      // freien Ziel-Dateinamen finden:
      i := 1;
      repeat
        if not(FileExists(FNameNeu)) then
          break;
        if (i = 1) then
          FNameNeu := copy(FNameNeu, 1, revpos('.', FNameNeu) - 1) + '-' + InttoStr(i) + '.jpg'
        else
          FNameNeu := copy(FNameNeu, 1, revpos('-', FNameNeu) - 1) + '-' + InttoStr(i) + '.jpg';
        inc(i);
      until eternity;

      if FileMove(FNameAlt, FNameNeu) then
      begin
        FotoTransaction(cFTRN_move,
          { } FNameAlt +
          { } ' ' + FNameNeu);
        LastLogWasTimeStamp := false;

        WARTEND.Del(r);
        inc(Stat_Umbenannt);
      end
      else
      begin
        FotoLog(cERRORText + ' 1280: FileMove("' + FNameAlt + '", "' + FNameNeu + '")');
        FotoLog(cFotoService_AbortTag);
      end;
    end;
  end;

  bOrgaMon.EndTransaction;
  bOrgaMon.Free;

  if WARTEND.Changed then
  begin

    // recreate senden.html, muss jemand noch "senden"
    tSENDEN := tsTable.Create;
    with tSENDEN do
    begin
      insertfromFile(DataPath + cAppService_SendenFName);
      i := addcol('PAPERCOLOR');
      k := WARTEND.colof('GERAETENO');
      c := colof('ID');
      for r := 1 to RowCount do
        if (WARTEND.locate(k, readCell(r, c)) <> -1) then
          writeCell(r, i, '#FFFF00');
      SaveToHTML(pWebPath + 'senden.html');
    end;
    tSENDEN.Free;

    // save WARTEND / save as html
    WARTEND.SaveToHTML(pWebPath + '-neu.html');
    WARTEND.SaveToFile(DataPath + cFotoService_UmbenennungAusstehendFName);

    // FotoLog
    if (Stat_Umbenannt > 0) then
      FotoLog(cINFOText + ' 1276: ' +
        { } InttoStr(Stat_Umbenannt) +
        { } ' "Neu" Umbenennung(en) wurde(n) durchgef�hrt, ' +
        { } InttoStr(WARTEND.RowCount) +
        { } ' verbleiben');

    if (Stat_NachtragBaustelle > 0) then
      FotoLog(cINFOText + ' 1283: ' +
        { } InttoStr(Stat_NachtragBaustelle) +
        { } ' Baustelleninfo(s) wurde(n) nachgetragen');

  end;

  WARTEND.Free;
  if assigned(CSV_ZaehlerNummer) then
    CSV_ZaehlerNummer.Free;
  if assigned(CSV_ReglerNummer) then
    CSV_ReglerNummer.Free;
end;

function TOrgaMonApp.AblageLogFname: string;
begin
  result := DiagnosePath + format(cFotoAblageFName, [DatumLog]);
end;

procedure TOrgaMonApp.workAblage(sParameter: TStringList = nil);

  procedure AblageLog(Source, Dest: string);
  begin
    AppendStringsToFile(sTimeStamp + ';' + Source + ';' + Dest, AblageLogFname);
  end;

const
  cFileTimeOutDaysIs = 39;

  // Transition may removed at 10.01.2020
  cTransitionStart = 20191216;
  cFileTimeOutDaysWas = 50 + 10;


  // 0 = gestern ist schon zu alt
  cPicTimeOutDays = 0;
var
  // globale Infrastruktur - Parameter
  Ablage_NAME: string; // Allgemeiner Name der Internet-Ablage: 'abc'
  Ablage_PFAD: string; // Realer vollst�ndiger Pfad der Internet-Ablage
  Ablage_SUB: string; // Unterverzeichnis inerhalb der aktuellen Internet-Ablage '','abc\',...
  Ablage_ZIP_PASSWORD: string;

  //
  Ablage_PFADE: TStringList;
  Ablage_SUBS: TStringList;
  ZIP_OlderThan: TANFiXDate;
  PIC_OlderThan: TANFiXDate;
  WARTEND: tsTable;
  col_DATEINAME_AKTUELL: integer;

  Col_ZIPPASSWORD: integer;
  Col_FTPBenutzer: integer;
  MovedToDay: int64;

  procedure serviceJPG;
  const
    cMaxZIP_Size = 100 * 1024 * 1024;
  var
    m: integer;
    Pending: boolean;
    FotoFSize: int64;
    sPics: TStringList;
    mIni: TIniFile;
    FotosSequence: integer;
    FotosAbzug: boolean;
    sOldZips: TStringList;
    DATEINAME_AKTUELL: string;
  begin
    Pending := false;
    sPics := TStringList.Create;
    sOldZips := TStringList.Create;
    repeat
      // Jpegs
      dir(Ablage_PFAD + '*.jpg', sPics, false);
      if (sPics.Count = 0) then
        break;

      // reduziere um "zu neue" Bilder
      for m := pred(sPics.Count) downto 0 do
        if (FileDate(Ablage_PFAD + sPics[m]) >= PIC_OlderThan) then
          sPics.Delete(m);
      if (sPics.Count = 0) then
        break;

      // reduziere um "wartende" Bilder
      for m := pred(sPics.Count) downto 0 do
      begin
        DATEINAME_AKTUELL := Ablage_PFAD + sPics[m];

        if (WARTEND.locate(col_DATEINAME_AKTUELL, DATEINAME_AKTUELL) <> -1) then
          sPics.Delete(m);
      end;
      if (sPics.Count = 0) then
        break;

      // reduziere auf < 100 MByte
      FotoFSize := 0;
      for m := pred(sPics.Count) downto 0 do
      begin
        if (FotoFSize >= cMaxZIP_Size) then
        begin
          sPics.Delete(m);
          Pending := true;
        end
        else
        begin
          inc(FotoFSize, FSize(Ablage_PFAD + sPics[m]));
        end;
      end;

      // Die Nummer des zu erzeugenden ZIP suchen
      FotosAbzug := false;
      mIni := TIniFile.Create(Ablage_PFAD + 'Fotos-nnnn.ini');
      with mIni do
      begin
        FotosSequence := StrToInt(ReadString(cGroup_Id_Default, 'Sequence', '-1'));
        FotosAbzug := (ReadString(cGroup_Id_Default, 'Abzug', cIni_Deactivate) = cINI_ACTIVATE);
        if FotosSequence < 0 then
        begin
          dir(Ablage_PFAD + 'Fotos-????.zip', sOldZips, false);
          if (sOldZips.Count > 0) then
          begin
            sOldZips.sort;
            FotosSequence := StrToIntDef(ExtractSegmentBetween(sOldZips[pred(sOldZips.Count)], 'Fotos-', '.zip'), -1);
          end;
        end;
        if (FotosSequence < 0) then
          FotosSequence := 0;
        inc(FotosSequence);
      end;
      mIni.Free;

      // Archivieren in Fotos-nnnn.zip
      AblageLog(Ablage_PFAD + 'Fotos-' + inttostrN(FotosSequence, cAnzahlStellen_FotosTagwerk) + '.zip', '.');
      if (zip(
        { } sPics,
        { } Ablage_PFAD +
        { } 'Fotos-' + inttostrN(FotosSequence, cAnzahlStellen_FotosTagwerk) + '.zip',
        { } czip_set_RootPath + '=' + Ablage_PFAD + ';' +
        { } czip_set_Password + '=' +
        { } deCrypt_Hex(
        { } Ablage_ZIP_PASSWORD) + ';' +
        { } czip_set_Level + '=' + '0') <> sPics.Count) then
      begin
        // Problem anzeigen
        FotoLog(cERRORText + ' 7zip Fehler');
        Pending := false;
        break;
      end;

      if FotosAbzug then
      begin
        // Archivieren auch in Abzug-nnnn.zip

        for m := 0 to pred(sPics.Count) do
          FotoCompress(Ablage_PFAD + sPics[m], Ablage_PFAD + sPics[m], 94, 6);

        AblageLog(Ablage_PFAD + 'Abzug-' + inttostrN(FotosSequence, cAnzahlStellen_FotosTagwerk) + '.zip', '.');
        if (zip(
          { } sPics,
          { } Ablage_PFAD +
          { } 'Abzug-' + inttostrN(FotosSequence, cAnzahlStellen_FotosTagwerk) + '.zip',
          { } czip_set_RootPath + '=' + Ablage_PFAD + ';' +
          { } czip_set_Password + '=' +
          { } deCrypt_Hex(
          { } Ablage_ZIP_PASSWORD) + ';' +
          { } czip_set_Level + '=' + '0') <> sPics.Count) then
        begin
          // Problem anzeigen
          FotoLog(cERRORText + ' 7zip Fehler');
          Pending := false;
          break;
        end;

      end;

      // Fotos-nnnn.ini erh�hen
      mIni := TIniFile.Create(Ablage_PFAD + 'Fotos-nnnn.ini');
      mIni.WriteString(cGroup_Id_Default, 'Sequence', InttoStr(FotosSequence));
      mIni.Free;

      // nun die eben archivierten JPGS schlussendlich l�schen!
      for m := 0 to pred(sPics.Count) do
        FileDelete(Ablage_PFAD + sPics[m]);

    until yet;
    sPics.Free;
    sOldZips.Free;

    if Pending then
      serviceJPG;
  end;

  procedure serviceHTML;
  var
    m: integer;
    sHTMLSs: TStringList;
    mIni: TIniFile;
    FotosSequence: integer;
    sOldZips: TStringList;
  begin
    sHTMLSs := TStringList.Create;
    sOldZips := TStringList.Create;
    repeat

      // Jpegs
      dir(Ablage_PFAD + '*.zip.html', sHTMLSs, false);
      if (sHTMLSs.Count = 0) then
        break;

      // reduziere um "zu neue" Bilder
      for m := pred(sHTMLSs.Count) downto 0 do
        if (FileDate(Ablage_PFAD + sHTMLSs[m]) >= PIC_OlderThan) then
          sHTMLSs.Delete(m);
      if (sHTMLSs.Count = 0) then
        break;

      // reduziere um "wartende" Wechselbelege, bei denen das pdf fehlt!
      for m := pred(sHTMLSs.Count) downto 0 do
        if not(FileExists(Ablage_PFAD + sHTMLSs[m] + '.pdf')) then
          sHTMLSs.Delete(m);
      if (sHTMLSs.Count = 0) then
        break;

      // .pdf muss auch mit!
      // erweitere um die .pdf Dateien
      for m := 0 to pred(sHTMLSs.Count) do
        sHTMLSs.add(sHTMLSs[m] + '.pdf');

      // Die Nummer des zu erzeugenden ZIP suchen
      mIni := TIniFile.Create(Ablage_PFAD + 'Wechselbelege-nnnn.ini');
      with mIni do
      begin
        FotosSequence := StrToInt(ReadString(cGroup_Id_Default, 'Sequence', '-1'));
        if (FotosSequence < 0) then
        begin
          dir(Ablage_PFAD + 'Wechselbelege-????.zip', sOldZips, false);
          if sOldZips.Count > 0 then
          begin
            sOldZips.sort;
            FotosSequence := StrToIntDef(ExtractSegmentBetween(sOldZips[pred(sOldZips.Count)], 'Wechselbelege-',
              '.zip'), -1);
          end;
        end;

        if FotosSequence < 0 then
          FotosSequence := 0;

        inc(FotosSequence);
      end;
      mIni.Free;

      // Archivieren
      AblageLog(Ablage_PFAD + 'Wechselbelege-' + inttostrN(FotosSequence, cAnzahlStellen_FotosTagwerk) + '.zip', '.');
      if (zip(
        { } sHTMLSs,
        { } Ablage_PFAD +
        { } 'Wechselbelege-' + inttostrN(FotosSequence, cAnzahlStellen_FotosTagwerk) + '.zip',
        { } czip_set_RootPath + '=' + Ablage_PFAD + ';' +
        { } czip_set_Password + '=' +
        { } deCrypt_Hex(
        { } Ablage_ZIP_PASSWORD) + ';' +
        { } czip_set_Level + '=' + '0') <> sHTMLSs.Count) then
      begin
        // Problem anzeigen
        FotoLog(cERRORText + ' 7zip Fehler');
        break;
      end;

      // Laufnummer erh�hen
      mIni := TIniFile.Create(Ablage_PFAD + 'Wechselbelege-nnnn.ini');
      mIni.WriteString(cGroup_Id_Default, 'Sequence', InttoStr(FotosSequence));
      mIni.Free;

      // nun die eben archivierten l�schen!
      for m := 0 to pred(sHTMLSs.Count) do
        FileDelete(Ablage_PFAD + sHTMLSs[m]);

    until yet;
    sHTMLSs.Free;
    sOldZips.Free;
  end;

  procedure serviceZIP;
  var
    sZips: TStringList;
    m: integer;
    DestPath : string;
    DestPathCheckCreated: boolean;
  begin
    sZips := TStringList.Create;
    DestPath := BackupDir + Ablage_NAME + PathDelim + Ablage_SUB;
    DestPathCheckCreated := false;
    dir(Ablage_PFAD + '*.zip', sZips, false);
    for m := 0 to pred(sZips.Count) do
    begin

      if (pos('~',sZips[m])>0) then
      begin
          FotoLog(cERRORText +
            { } ' 2119: ZIP "' +
            { } Ablage_PFAD + sZips[m] + '" kann nicht verschoben werden, da der Dateiname korrupt ist ("~" ist enthalten)');
          continue;
      end;

      if (FileDate(Ablage_PFAD + sZips[m]) < ZIP_OlderThan) then
      begin

        // Datei bereits vorhanden? Darf nicht sein!
        if FileExists(DestPath + sZips[m]) then
        begin
          FotoLog(cERRORText +
            { } ' 2295: ZIP "' +
            { } Ablage_PFAD + sZips[m] +
            { } '" kann nicht verschoben werden, da diese Datei in "' +
            { } DestPath + '" '+
            { } 'bereits existiert');
          continue;
        end;

        // Zielverzeichnis f�r das Verschieben erstellen
        if not(DestPathCheckCreated) then
        begin
         CheckCreateDir(DestPath);
         DestPathCheckCreated := true;
        end;

        // Verschieben
        if FileMove(
          { } Ablage_PFAD + sZips[m],
          { } DestPath + sZips[m]) then
        begin
          inc(MovedToDay, FSize(Ablage_PFAD + sZips[m]));
          AblageLog(Ablage_PFAD + sZips[m], BackupDir);
        end
        else
        begin
          FotoLog(cERRORText +
            { } ' 1645: FileMove("' +
            { } Ablage_PFAD + sZips[m] + '", "' +
            { } DestPath + sZips[m] + '")');
          FotoLog(cFotoService_AbortTag);
        end;
      end;
    end;
    sZips.Free;
  end;

var
  BasisDatum: TANFiXDate;

  // Parameter
  pDatum: string;
  pEinzeln: string;

  r,a: integer;
  UserN:string;
  PFAD, SUB: string;
  FileTimeOutDays: Integer;

begin

  // Set "Lock" for this day
  FileAlive(AblageLogFname);

  ensureGlobals;

  if assigned(sParameter) then
  begin
    pDatum := sParameter.Values['DATUM'];
    pEinzeln := sParameter.Values['EINZELN'];
  end
  else
  begin
    pDatum := '';
    pEinzeln := '';
  end;

  // Infos �ber Baustellen
  Col_ZIPPASSWORD := tBAUSTELLE.colof(cE_ZIPPASSWORD);
  Col_FTPBENUTZER := tBAUSTELLE.colof(cE_FTPUSER);

  // Infos �ber noch nicht umbenannte Dateien
  WARTEND := tsTable.Create;
  WARTEND.insertfromFile(DataPath + cFotoService_UmbenennungAusstehendFName);
  col_DATEINAME_AKTUELL := WARTEND.colof('DATEINAME_AKTUELL');

  // "Wann" ist der Arbeitsfokus
  if (pDatum = '') then
  begin
    BasisDatum := DateGet;
  end
  else
  begin
    BasisDatum := date2long(pDatum);
  end;

  // init
  MovedToDay := 0;

  // slowly transition from higher value to lower value
  // starting at cTransitionStart  on - lower size from
  if (BasisDatum>=cTransitionStart) then
  begin
   FileTimeOutDays := max(cFileTimeOutDaysIs,cFileTimeOutDaysWas-DateDiff(cTransitionStart,BasisDatum)-1);
  end else
  begin
   FileTimeOutDays := cFileTimeOutDaysWas;
  end;

  ZIP_OlderThan := DatePlus(BasisDatum, -FileTimeOutDays);
  PIC_OlderThan := DatePlus(BasisDatum, -cPicTimeOutDays);

  for r := 1 to tABLAGE.RowCount do
  begin

    Ablage_NAME := cutblank(tABLAGE.readCell(r, 'NAME'));
    if (Ablage_NAME = '') then
      continue;

    //
    if (pEinzeln <> '') then
      if (pEinzeln <> Ablage_NAME) then
        continue;

    //
    Ablage_PFAD := cutblank(tABLAGE.readCell(r, 'PFAD'));

    if (Ablage_PFAD = '') then
    begin
      FotoLog(cERRORText + ' Bei Ablage "' + Ablage_NAME + '"  ist kein Pfad definiert');
      continue;
    end;

    if not(DirExists(Ablage_PFAD)) then
    begin
      FotoLog(cERRORText + ' Zu Ablage "' + Ablage_NAME + '"  existiert "' + Ablage_PFAD + '" nicht');
      continue;
    end;

    // Passwort ermitteln (F�r alle Unterverzeichnisse einer Ablage gleich)
    Ablage_ZIP_PASSWORD := '';
    for a := 1 to tBAUSTELLE.RowCount do
    begin
      UserN := tBAUSTELLE.readCell(a,Col_FTPBENUTZER);
      if (UserN=Ablage_NAME) then
      begin
        Ablage_ZIP_PASSWORD := tBAUSTELLE.readCell(a,Col_ZIPPASSWORD);
        break;
      end;
      if (length(UserN)>length(Ablage_NAME)) then
       if (pos(Ablage_NAME+PathDelim,UserN)=1) then
       begin
         Ablage_ZIP_PASSWORD := tBAUSTELLE.readCell(a,Col_ZIPPASSWORD);
         break;
       end;
    end;
    if (Ablage_ZIP_PASSWORD='') then
    begin
      FotoLog(cERRORText + ' Ablage "' + Ablage_NAME + '"  in ' + cFotoService_BaustelleFName +' nicht gefunden');
      continue;
    end;

    // Verzeichnis- und Unterverzeichnis-Liste anlegen
    Ablage_SUBS := TStringList.Create;

    Ablage_PFADE := anfix32.dirs(Ablage_PFAD);
    Ablage_PFADE.sort;
    Ablage_PFADE.Insert(0,'');

    for a := pred(Ablage_PFADE.Count) downto 0 do
    begin
      PFAD := ValidatePathName(Ablage_PFAD + Ablage_PFADE[a]) + PathDelim;

      if not(FileExists(PFAD+'index.php')) then
      begin
       FotoLog(
        cINFOText + ' 2245:'+
        ' In Ablage "' + Ablage_NAME + '" '+
        'wird das Verzeichnis "' + Ablage_PFADE[a] + '" '+
        '('+PFAD+') '+
        'ignoriert');
       Ablage_PFADE.delete(a);
      end else
      begin
       SUB := ValidatePathName(Ablage_PFADE[a])+PathDelim;
       if (SUB=PathDelim) then
        SUB := '';
       Ablage_SUBS.insert(0,SUB);
       Ablage_PFADE[a] := PFAD;
      end;
    end;

    // Hauptablage und alle Unterverzeichnisse (wenn vorhanden)
    for a := 0 to pred(Ablage_PFADE.count) do
    begin
      Ablage_PFAD := Ablage_PFADE[a];
      Ablage_SUB := Ablage_SUBS[a];

      // ganz alte Zips ablegen
      try
        serviceZIP;
      except
        on E: Exception do
          FotoLog(cERRORText + ' :serviceZIP(' + Ablage_PFAD + '): ' + E.ClassName + ': ' + E.Message);
      end;

      // jpgs von gestern zippen
      try
        serviceJPG;
      except
        on E: Exception do
          FotoLog(cERRORText + ' :serviceJPG(' + Ablage_PFAD + '): ' + E.ClassName + ': ' + E.Message);
      end;

      // htmls von gestern zippen
      try
        serviceHTML;
      except
        on E: Exception do
          FotoLog(cERRORText + ' :serviceHTML(' + Ablage_PFAD + '): ' + E.ClassName + ': ' + E.Message);
      end;
    end;

    Ablage_PFADE.Free;
    Ablage_SUBS.Free;

  end;

  // unprepare
  WARTEND.Free;
  AblageLog('ENDE', '*');

end;

procedure TOrgaMonApp.workSync;
var
  sDir: TStringList;
  n: integer;
  BaustellePath: string;

  procedure FileMoveR(source,destination:string);
  begin
    if not(FileMove(
      { } source,
      { } destination)) then
      FotoLog(cERRORText + ' 2502: FileMove("' + source + '", "' + destination + '")');
  end;

begin

  // baustelle.csv
  try

    if FileExists(pFTPPath + cFotoService_BaustelleFName) then
    begin

     // baustelle.csv -> sync
     FileMoveR(
      {} pFTPPath + cFotoService_BaustelleFName,
      {} MySyncPath + cFotoService_BaustelleFName);

      // prepare
      TOrgaMonApp.validateBaustelleCSV(MySyncPath + cFotoService_BaustelleFName);

      // compare + copy
      if not(FileCompare(
        { } MySyncPath + cFotoService_BaustelleFName,
        { } DataPath + cFotoService_BaustelleFName)) then
      begin
        FileVersionedCopy(
          { } MySyncPath + cFotoService_BaustelleFName,
          { } DataPath + cFotoService_BaustelleFName);
        FotoLog(cINFOText + ' neue ' + cFotoService_BaustelleFName);
      end;

      // delete
      FileDelete(MySyncPath + cFotoService_BaustelleFName);
    end;

  except
    on E: Exception do
      FotoLog(cERRORText + ' 1889:' + E.ClassName + ': ' + E.Message);
  end;

  // Foto-Benennungen
  try

    sDir := TStringList.Create;
    dir(pFTPPath + cE_FotoBenennung + '-*.csv', sDir, false);
    for n := 0 to pred(sDir.Count) do
    begin

     FileMoveR(
      {} pFTPPath + sDir[n],
      {} MySyncPath + sDir[n]);

      // FotoBenennung-*.csv ->  DataPath + Baustelle + "FotoBenennung-"+ Baustelle + ".csv"

      // Lese den Pfad aus dem Dateinamen
      BaustellePath := ExtractSegmentBetween(sDir[n], cE_FotoBenennung + '-', '.csv');

      // JonDa - Limitation!
      BaustellePath := copy(noblank(BaustellePath), 1, 6) + PathDelim;

      CheckCreateDir(DataPath + BaustellePath);

      if not(FileCompare(
        { } MySyncPath + sDir[n],
        { } DataPath + BaustellePath + cE_FotoBenennung + '.csv')) then
      begin
        FileVersionedCopy(
          { } MySyncPath + sDir[n],
          { } DataPath + BaustellePath + cE_FotoBenennung + '.csv');
        FotoLog(cINFOText + ' in ' + BaustellePath + ' neue ' + cE_FotoBenennung + '.csv');
      end;

      FileDelete(MySyncPath + sDir[n]);
    end;
    sDir.Free;

  except
    on E: Exception do
      FotoLog(cERRORText + ' 1923:' + E.ClassName + ': ' + E.Message);
  end;

end;

procedure TOrgaMonApp.FotoTransaction(TransactionCommand: string; TransactionParameter: string);
begin
 if Option_console then
   writeln(TransactionCommand + ' ' + TransactionParameter);
 AppendStringsToFile(
   { } TransactionCommand + ' ' + TransactionParameter,
   { } DiagnosePath + cFotoTransaktionenFName);
end;

function TOrgaMonApp.BisherGeliefert(Id,Merkmal:string):Integer;
const
 saveFName = 'Fotos-Laufende-Nummer.ini';
 saveLimit = 1000000;
var
 save : TStringList;
 PathAndFName: string;
 FullMatch: boolean;
 n : Integer;
begin
 // Init
 save := TStringList.Create;
 PathAndFName := DataPath + saveFName;
 result := 1;
 FullMatch := false;
 Id := Id + '=';

 if FileExists(PathAndFName) then
  save.LoadFromFile(PathAndFName);

 for n := 0 to pred(save.Count) do
   if (pos(Id,save[n]) = 1) then
   begin
     FullMatch := (save[n] = Id + Merkmal);
     if FullMatch then
       break;
     inc(result);
   end;

 if not(FullMatch) then
 begin
   save.Add(Id + Merkmal);
   while (save.Count > saveLimit) do
     save.delete(0);
   save.SaveToFile(PathAndFName);
 end;

 save.Free;
end;

end.
