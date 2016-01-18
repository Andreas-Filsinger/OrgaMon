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
unit JonDaExec;

interface

uses
{$IFDEF fpc}
  lazUTF8Classes,
{$ENDIF}
  globals, classes, Sysutils,
  anfix32, wordindex, IdFTP;

const
  // Für ungesetzte Daten-Bank RIDs
  cRID_Null = -1;

  // Foto - Beobachtungszeitraum:
  // ============================
  // Innerhalb dieses Zeitraumes müssen JonDa-Eingabe und Foto-Aufnahme
  // abgeglichen sein, später vergisst der Server die Eingabe Liste
  cMaxAge_Foto = 32; // [Tage] Solange bleiben Eingaben gesichert

  // Monteur-Individuelle Optionen
  cServerOption_ZeitPruefung = 'ZEIT_PRÜFUNG';
  cServerOption_JonDaOptionen = 'OPTIONEN';
  cServerOption_EinfacheListe = 'EinfacheListe';

const
  // Namens-konvention Bild: Gerät-RID-Parameter.jpg

  // INPUT
  cParameter_foto_Modus = 'MODUS'; // Benennung=0..6
  cParameter_foto_parameter = 'PARAMETER';
  // bisheriger Bildparameter "FA", "FN"
  cParameter_foto_baustelle = 'NUMMERN_PREFIX';
  // Kurzform der Baustellen Bez "KARL"
  cParameter_foto_strasse = 'STRASSE'; //
  cParameter_foto_ort = 'ORT'; //
  cParameter_foto_zaehler_info = 'ZAEHLER_INFO';
  cParameter_foto_RID = 'RID';
  cParameter_foto_ART = 'ART';
  cParameter_foto_zaehlernummer_alt = 'ZAEHLERNUMMER_ALT';
  cParameter_foto_zaehlernummer_neu = 'ZAEHLERNUMMER_NEU';
  cParameter_foto_ABNummer = 'ABNUMMER'; // Auftragsnummer
  cParameter_foto_geraet = 'GERAET'; // 3stellige Gerätenummer
  cParameter_foto_Pfad = 'PFAD';

  // INPUT OPTIONAL
  cParameter_foto_Datei = 'DATEI'; // Dateiname des Fotos (incl. Pfad)

  // OUTPUT
  cParameter_foto_fertig = 'ENDGUELTIG'; //
  cParameter_foto_neu = 'NAME_NEU'; // Umbenannter Dateiname - ohne Pfad
  cParameter_foto_ziel = 'BAUSTELLE_NEU'; // Kurzform der Baustellen Bez "Ziel"
  cParameter_foto_Fehler = 'ERROR'; // Meldung über etwaige Fehler

type
  TJonDaExec_ZaehlerNummerNeu = function(RID: integer; FotoGeraeteNo: string): string of object;

  TJonDaExec = class(TObject)
  private
    //
    TabCounter: integer;
    sSendenLog: TStringList;

    function oldInfrastructure: boolean;

  public
    //
    Option_Console: boolean;

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
    Stat_PostError: string; // Fehler über ein Problem im Nachgang

    // die Abschlüsse von denen der OrgaMon noch nichts weiss
    Stat_Abberufen: integer;
    Stat_IgnoriertTest: integer;
    Stat_IgnoriertFehlenderAuftrag: integer;
    Stat_AusfuehrungsMomentKorrektur: integer;
    Stat_FotoMeldungen: integer;

    // Caching Elemente
    sProtokolle: TSearchStringList;

    // Optionen für "start"
    start_StaticResult: string; // vorbereitetes statisches Ergebnis
    start_NoTimeCheck: boolean; // Unterdrücken der Zeitprüfung

    // Optionen für "proceed"
    proceed_FremdmonteureLoeschen: boolean;
    // Auftraege anderer Monteure ablehnen
    proceed_ArbeitIgnorieren: boolean; // Eingaben des Monteurs nicht beachten
    proceed_RestantenLoeschen: boolean; //

    //
    // Ignoriert "Letzte TAN", "Restanten", "Stay-Liste"
    proceed_EinfacheListe: boolean;

    //
    // Normale Verarbeitung OHNE Ergebnis-Upload
    proceed_NoUpload: boolean;

    // Optionen für "proceed", nicht programmiert
    proceed_ProceedAblehnen: boolean; // not imp

    // Call-Backs
    callback_ZaehlerNummerNeu: TJonDaExec_ZaehlerNummerNeu;

    // IMEI-Tabellen
    tIMEI: TsTable;
    tIMEI_OK: TsTable;

    // core
    constructor Create;
    destructor Destroy; override;

    // SERVICE: "info"
    function info(sParameter: TStringList): TStringList;

    // SERVICE: "start"
    //
    // TAN        vormalige TAN
    // VERSION    JonDa Programmversion
    // OPTIONEN   JonDa Programm-Optionen
    // UHR        Handy Datum - Uhr
    // MOMENT     aktueller Anfrage-Moment
    // GERAET     Monteurs Kennung
    function start(sParameter: TStringList): TStringList;

    // SERVICE: "proceed"
    //
    // TAN        die verarbeitet werden soll
    // OFFLINE    sollen keine Daten via FTP hoch/runtergeladen werden?
    function proceed(sParameter: TStringList): TStringList;

    // SERVICE: "foto"
    //
    // Benennt ein Foto mit Hilfe der aktuellen Umgebungsparameter um
    // In besonderen Fällen wird noch ein lokaler CallBack zu Rate gezogen
    function foto(sParameter: TStringList): TStringList;

    // TOOL: Logging
    function LogFName: string;
    procedure BeginAction(ActionText: string);
    procedure EndAction(ActionText: string = '');
    procedure log(s: TStrings); overload;
    procedure log(s: string); overload;

    // TOOL: Gerät
    function GeraeteAlias(GeraeteID: string; iFTP: TIdFTP): string;
    // [GeraeteID]

    function isProd(pGeraeteNo: string; pRID: integer; pFertig: TANFiXDate): boolean;
    function isTest(pGeraeteNo: string; pRID: integer; pFertig: TANFiXDate): boolean;

    // TOOL: Allgemein
    procedure ClearStat;
    class function VormittagsStr(vormittags: boolean): string;
    class function AusfuehrenStr(ausfuehren_ist_datum: TANFiXDate): string;
    class function FormatZaehlerNummerNeu(const s: string): string;

    class function active(a: boolean): string;
    class function ProtokollPath(Rev: single): string;

    function toProtokollFName(const mderec: TMdeRec; RemoteRev: single): string;
    class function toBild(const mderec: TMdeRec): string;
    class procedure toAnsi(var mderec: TMdeRec);
    procedure LogBilder(sBilder: TStringList; GeraeteID: string);
    procedure LogBilder2(sBilder: TStringList; GeraeteID: string);
    function detectGeraeteNummer(sPath: string): string;

    // TOOL: Migration
    function MdeRec2Jonda(mderec: TMdeRec; RemoteRev: single): string;
    function WebToMdeRecString(s: AnsiString): AnsiString;
    function migrateProtokoll(OldFName, NewFName: string): boolean;

    // TOOL: TAN
    function ActTRN: string;
    function NewTrn(IncrementIt: boolean = true): string;
    function FolgeTANFName(GeraetID: string): string;
    function FolgeTAN(GeraetID: string): string;
    function UpFName(AktTrn: string): string;
    function LogMatch(Pattern, Schema: string): boolean;

    // TOOL: FTP
    procedure sput(source, dest: string; iFTP: TIdFTP);
    function ftpDown(GeraeteNo, AktTrn: string; iFTP: TIdFTP): boolean;
    function upMeldungen(iFTP: TIdFTP): TStringList;

    // REPORT:
    procedure doStat(iFTP: TIdFTP);

    // MAINTANACE:
    procedure maintainSENDEN;
    procedure maintainGERAETE;

    // MAINTANANCE:
    //
    // * Binäres Lager auffrischen
    // * SENDEN.CSV von altem Müll befreien
    procedure doAbschluss;

    // aus dem FTP-Bereich diverse
    // Sync-Dateien holen
    procedure doSync;

  end;

function enCrypt_Hex(s: string): string;
function deCrypt_Hex(s: string): string;
procedure validateBaustelleCSV(Fname: string);

implementation

uses
  BinLager32, CareTakerClient, html,
  gplists, SolidFTP, idGlobal,
  DCPcrypt2, DCPblockciphers, DCPblowfish,
  srvXMLRPC;

{ TJonDaExec }

function TJonDaExec.LogFName: string;
begin
  result := MyProgramPath + cJonDaServer_LogFName;
end;

function TJonDaExec.LogMatch(Pattern, Schema: string): boolean;
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
  until true;
end;

procedure TJonDaExec.maintainGERAETE;
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

    // Tabelle mit besonders interessanten Werte vorbefüllen
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
  sLog.LoadFromFile(MyProgramPath + cJonDaServer_LogFName);
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

          until true;
        end;
        sGeraete.incCell(r, cCol_COUNT);

      end;
    end;
  end;
  sLog.free;

  sGeraete.SortBy('COUNT numeric;CALL numeric descending;GERAET');
  // Ergebnis speichern
  if oldInfrastructure then
    sGeraete.SaveToHTML(MyProgramPath + cStatistikPath + 'geraete.html')
  else
    sGeraete.SaveToHTML(MyProgramPath + cWebPath + 'geraete.html');
  sGeraete.free;
end;

const
  maintainSENDEN_Cache_Init: boolean = false;

procedure TJonDaExec.maintainSENDEN;
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
    if not(FileExists(MyProgramPath + cDBPath + 'SENDEN.csv')) then
    begin
      sSENDEN := TStringList.Create;
      sSENDEN.add('IMEI;NAME;ID;MOMENT;TAN;REV;ERROR;PAPERCOLOR');
      sSENDEN.SaveToFile(MyProgramPath + cDBPath + 'SENDEN.csv');
      sSENDEN.free;
    end;

  // Nach "SENDEN" Tabelle protokollieren
  tSENDEN := TsTable.Create;
  with tSENDEN do
  begin
    InsertFromFile(MyProgramPath + cDBPath + 'SENDEN.csv');

    if not(maintainSENDEN_Cache_Init) then
    begin
      addCol('ERROR');
      addCol('PAPERCOLOR');
    end;

    c := colof('MOMENT', true);
    d := DatePlus(DateGet, -cOlderThan);
    // zu alte Zeile löschen
    for r := 1 to RowCount do
    begin
      CellDate := strtointdef(nextp(readCell(r, c), ' ', 0), cIllegalDate);
      if (CellDate > cIllegalDate) and (CellDate < d) then
      begin
        // Löschposition gefunden -> alles ab da löschen!
        for n := RowCount downto r do
          Del(n);
        break;
      end;
    end;

    if changed then
    begin
      if oldInfrastructure then
        SaveToHTML(MyProgramPath + cStatistikPath + 'index.html')
      else
        SaveToHTML(MyProgramPath + cWebPath + 'senden.html');
      SaveToFile(MyProgramPath + cDBPath + 'SENDEN.csv');
    end;
  end;
  tSENDEN.free;
  maintainSENDEN_Cache_Init := true;
end;

class function TJonDaExec.AusfuehrenStr(ausfuehren_ist_datum: TANFiXDate): string;
begin
  begin
    case ausfuehren_ist_datum of
      cMonDa_Status_unbearbeitet:
        result := 'unbearbeitet';
      cMonDa_Status_Restant:
        result := 'Restant';
      cMonDa_Status_Unmoeglich:
        result := 'Unmöglich';
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

procedure TJonDaExec.BeginAction(ActionText: string);
begin
  log(datum + ' ' + secondstostr(secondsget) + ' ' + ActionText);
  inc(TabCounter);
end;

procedure TJonDaExec.EndAction;
begin
  // pragma
  dec(TabCounter);
  if (ActionText <> '') then
    log(datum + ' ' + secondstostr(secondsget) + ' ' + ActionText);
end;

procedure TJonDaExec.log(s: TStrings);
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
    if pos(cERRORText, s[n]) > 0 then
    begin
      CareTakerLog(s[n]);
    end;
  end;
  CloseFile(LogF);
end;

procedure TJonDaExec.log(s: string);
var
  StringList: TStringList;
begin
  StringList := TStringList.Create;
  StringList.add(s);
  log(StringList);
  StringList.free;
end;

function TJonDaExec.GeraeteAlias(GeraeteID: string; iFTP: TIdFTP): string;
begin
  // Besondere Aktionen bei besonderen Geräte-Nummern ausführen
  repeat

    if (GeraeteID = '999') then
    begin
      // Statistik
      doStat(iFTP);
      // ausstehende Meldungen
      upMeldungen(iFTP);
      result := '000';
      break;
    end;

    result := GeraeteID;
  until true;
end;

function TJonDaExec.FolgeTANFName(GeraetID: string): string;
begin
  result := MyProgramPath + cServerDataPath + 'TAN.' + GeraetID + '.txt';
end;

class function TJonDaExec.FormatZaehlerNummerNeu(const s: string): string;
begin
  result := cutblank(s);
  repeat
    if (length(result) <= 1) then
      break;
    if (result[1] = '0') then
      result := copy(result, 2, MaxInt)
    else
      break;
  until false;
end;

function TJonDaExec.FolgeTAN(GeraetID: string): string;
var
  ErsterVersuch: boolean;
  sFolgeTAN: TStringList;
begin
  sFolgeTAN := TStringList.Create;
  ErsterVersuch := not(FileExists(FolgeTANFName(GeraetID)));
  if ErsterVersuch then
  begin
    result := NewTrn;
    sFolgeTAN.add(result);
    sFolgeTAN.SaveToFile(FolgeTANFName(GeraetID));
  end
  else
  begin
    sFolgeTAN.LoadFromFile(FolgeTANFName(GeraetID));
    result := sFolgeTAN[0];
  end;
  sFolgeTAN.free;

  // das TAN Verzeichnis anlegen
  checkcreatedir(MyProgramPath + result);
end;

class function TJonDaExec.active(a: boolean): string;
begin
  if a then
    result := cIni_Activate
  else
    result := cIni_Deactivate;
end;

function TJonDaExec.ActTRN: string;
begin
  result := NewTrn(false);
end;

function TJonDaExec.UpFName(AktTrn: string): string;
begin
  if oldInfrastructure then
    result := MyProgramPath + AktTrn + '\' + AktTrn + '.txt'
  else
    result := MyProgramPath + cWebPath + AktTrn + '.txt';
end;

function TJonDaExec.NewTrn(IncrementIt: boolean = true): string;
var
  TrnFile: TextFile;
  TrnLine: string;
begin

  // Lade aktuelle TAN, das ist auch Rückgabewert!
  if not(FileExists(MyProgramPath + cTrnFName)) then
  begin
    TrnLine := cFirstTrn;
  end
  else
  begin
    assignFile(TrnFile, MyProgramPath + cTrnFName);
    try
      reset(TrnFile);
    except
      on E: Exception do
        log(cERRORText + ' 1771:' + E.Message);
    end;
    readln(TrnFile, TrnLine);
    CloseFile(TrnFile);
  end;
  result := TrnLine;

  // Für das nächste Mal: Inkrementiere TAN und speichere sie dann
  if IncrementIt then
  begin

    // <Aktueller Stand> + 1
    TrnLine := inttostr(succ(strtoint(TrnLine)));

    // Bei Flip-Over wieder auf Anfang (da sollten schon Monate dazwischen liegen)
    if (strtoint(TrnLine) >= strtoint(cFirstTrn) * 10) then
      TrnLine := cFirstTrn;

    assignFile(TrnFile, MyProgramPath + cTrnFName);
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

function TJonDaExec.oldInfrastructure: boolean;
begin
  result := (pos('\JonDaServer\', MyProgramPath) > 0);
end;

function TJonDaExec.info(sParameter: TStringList): TStringList;
begin
  result := TStringList.Create;
  with result do
  begin
    add(MyProgramPath);
    add(cApplicationName + ' Rev. ' + RevToStr(version));
    add(gsIdProductName + ' Rev. ' + gsIdVersion);
    add('ANFiX Rev. ' + RevToStr(VersionAnfix32));
    add(ComputerName);
    add(datum + ' ' + uhr8);
    addobject(ActTRN + '.' + cServerFunctions_Meta_CallCount, TXMLRPC_Server.oMetaString);
    add(iJonDa_FTPUserName + '@' + iJonDa_FTPHost);
    add(Betriebssystem);
  end;
end;

function TJonDaExec.proceed(sParameter: TStringList): TStringList;

var
  AktTrn: string;
  GeraeteNo: string;
  Online: boolean; //
  iFTP: TIdFTP;

  GoodMonteurL: TStringList;
  ProtocolL: TStringList;
  ProtocolAll: TStringList;
  JondaAll: TSearchStringList;
  BilderAll: TStringList;
  BilderAll2: TStringList;
  Einstellungen: TStringList;

  //
  ProtS: string;
  LastTrnNo: string; // Vom Gerät
  Optionen: string; // Vom Gerät
  IMEI: string; // Vom Gerät

  // Aus der IMEI Tabelle
  NAME: string;
  BEZAHLT_BIS: TANFiXDate;

  OneJLine: string;
  JProtokoll: string;
  JAuftragBisherFName: string;
  Fname: string;
  MonDaGeraetF: TextFile;
  RemoteRev: single;

  // Eingabe/Ausgabe Dateien
  f_OrgaMon_Auftrag: file of TMdeRec; // Neues von OrgaMon
  bOrgaMonAuftrag: TBLager;

  fOrgaMonErgebnis: file of TMdeRec;
  // Das sind Ergebnisse von MonDa an OrgaMon ...
  sOrgaMonErgebnis: TStringList; // ... hier als utf8-Variante
  // String-List mit der Original-Protokoll-Eingabe
  bFotoErgebnis: TBLager;
  f_OrgaMonApp_Ergebnis: file of TMdeRec; // so kommt es von Monda

  f_OrgaMonApp_NeuerAuftrag: file of TMdeRec;
  // neue, aufbereitete Liste an MonDa
  // -> Restanten und Neue
  MonDaAasTxt: TextFile;
  Auftrag: TStringList;

  MonDaA_StayF: file of TMdeRec; // neue, aufbereitete Liste an MonDa
  // heutige Eingaben!
  MonDaA_LostF: file of TMdeRec; // Aufgrund zu langer Verweildauer auf
  // dem Gerät wurden diese in den Status
  // "unmöglich" versetzt!
  mderec: TMdeRec;
  mdeS: string;
  // Text-Entsprechung zum MdeRec, also immer wenn hier auf den MDEREC zugegriffen wird
  // sollte mdeS entsprechend gesetzt werden!
  mderec2: TMdeRec;
  n, m, k, iRID: integer;
  dFertig: TANFiXDate;
  EntryPointReached: boolean;

  _DateGet: TANFiXDate;
  _DatumWechselTimeOut: TANFiXDate;
  // Wenn der Wechsel zu lange her ist, wird der "Moment"
  // korigiert
  _DateGetTimeOut: TANFiXDate;
  ErrorCount: integer;

  OldTrn: string;
  // Bei Serveraufträgen ist die der erste Parameter (zumeist eine
  // alte existierende TAN).

  // Liste aller neuen RIDs
  OrgaMonPlanungsVolumen: TgpIntegerList;
  OrgaMonFertig: TgpIntegerList;
  OrgaMonAbgearbeitet: TgpIntegerList;

  // Stay-Liste
  // ==========
  //
  // Liste aller erledigten! Alle werden natürlich an OrgaMon gemeldet!
  // Einige sollten jedoch auf dem MonDa-System bleiben: OrgaMon weis
  // ev. von diesen Meldungen noch nichts, und versucht die Datensätze
  // durch "unbearbeitete" zu Ersetzen - ein Ärgernis für den Monteur
  // hat dieser doch die Aufträge schon erledigt!
  //
  // Es wird ein Pool von heutigen und vorgezogenen Aufträgen geführt.
  // Kommen jedoch diese mit einem anderen _soll Datum oder Vormittag/Nachmittag
  // wird der Datensatz von OrgaMon genommen, ansonsten der eigene behalten.
  // Kommt dieser Datensatz gar nicht mehr von OrgaMon, so kann auch die weitere
  // Speicherung auf MonDa unterbleiben. OrgaMon ist dann offensichtlich schon
  // irgendwie von der Erledigung informiert.
  //
  // Entweder steht der Datensatz an der Stelle wo er war, oder er ist weg.
  // Oder OrgaMon hat ihn durch einen neuen ersetzt.
  //
  // Vorgehensweise:
  //
  // ist der OrgaMon-Datensatz in der Stay Liste?
  // ja -> prüfe, ob soll=soll ist
  // ja->nehme den MonDa-Datensatz
  // (man könnte jedoch die OrgaMon-Datenfelder updaten!!!)
  // nein->nehme den OrgaMon-Datensatz
  // ev. wurde hier umterminiert!
  // nein -> einfach übernehmen!
  //
  MondaStay: TStringList;

  //
  // Verzeichnis der Baustellen, es wird mitprotokolliert welche
  // Baustellen auf das Gerät übertragen werden. Aus dieser Info
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

  function isFertig: boolean;
  begin
    result := (mderec.ausfuehren_ist_datum > cMonDa_Status_unbearbeitet);
  end;

  function FName_Abgezogen: string;
  begin
    result := format(MyProgramPath + AktTrn + '\' + cMonDaServer_AbgezogenFName, [GeraeteNo]);
  end;

  procedure SaveOneStay;
  begin

    repeat

      // bei einfacher Liste gibt es kein Stay
      if (proceed_EinfacheListe) then
        break;

      //
      if (mderec.ausfuehren_ist_datum > cMonDa_Status_unbearbeitet) and
        (mderec.ausfuehren_soll = cMonDa_FreieTerminWahl) then
        break;

      // heute ausgeführt?
      if (mderec.ausfuehren_ist_datum = _DateGet) or
      // für heute geplant oder vorgezogen?
        (mderec.ausfuehren_soll > _DateGet) or (mderec.ausfuehren_ist_datum = cMonDa_Status_Restant)
        or (mderec.ausfuehren_ist_datum = cMonDa_Status_Unmoeglich) or
        (mderec.ausfuehren_ist_datum = cMonDa_Status_NeuAnschreiben) or
        (mderec.ausfuehren_ist_datum = cMonDa_Status_Vorgezogen) then
      begin
        write(MonDaA_StayF, mderec);
        MondaStay.addobject(inttostr(mderec.RID), TObject(Stat_MondaStay));
        inc(Stat_MondaStay);
      end;
    until true;
  end;

  procedure WriteJonDa(s: string);
  begin
    writeln(MonDaAasTxt, s);
    Auftrag.add(s);
  end;

  procedure CloseJonDa;
  begin
    CloseFile(MonDaAasTxt);

    // Das Ergebnis im Web bereitstellen
    if oldInfrastructure then
      SaveStringsToFileUTF8(Auftrag, MyProgramPath + AktTrn + '\auftrag' + cUTF8DataExtension)
    else
      SaveStringsToFileUTF8(Auftrag,
        { } MyProgramPath +
        { } cWebPath +
        { } AktTrn + '.auftrag' + cUTF8DataExtension);
  end;

  procedure add_OrgaMonApp_NeuerAuftrag;
  begin
    repeat

      // Gerät nur leeren -> keine neuen Aufträge
      if (GeraeteNo = '000') then
        break;

      // grade eben als "fertig" gemeldet! -> Nicht mehr aufs Gerät!
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

    until true;
  end;

  procedure WriteOrgaMon;
  begin

    // für die Statistik
    inc(Stat_Meldungen);

    // ausgeben in eine Datei
    write(fOrgaMonErgebnis, mderec);

    // Bild-Infotexte ausgeben
    if (mderec.ausfuehren_ist_datum >= cMonDa_ErsterTermin) then
      if (WechselmomentKorrektur.IndexOf(mderec.RID) = -1) then
        BilderAll.add(toBild(mderec))
      else
        BilderAll2.add(toBild(mderec));

    // Bild-Zuordnung protokollieren
    if (pos('FA=', mderec.ProtokollInfo) > 0) then
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
    if FileExists(MyProgramPath + AktTrn + '\REV.DAT') then
    begin
      assignFile(MonDaRevF, MyProgramPath + AktTrn + '\REV.DAT');
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
    if FileExists(MyProgramPath + cMeldungPath + GeraeteNo + '.txt') then
    begin
      slGeraet := TStringList.Create;
      ilGemeldeteRIDS := TgpIntegerList.Create;
      try
        slGeraet.LoadFromFile(MyProgramPath + cMeldungPath + GeraeteNo + '.txt');
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
        JondaAll.SaveToFile(MyProgramPath + cMeldungPath + GeraeteNo + '.txt');
      except
        on E: Exception do
          log(cERRORText + ' 620:' + E.Message);
      end;
      slGeraet.free;
      ilGemeldeteRIDS.free;
    end;
  end;

  procedure addSingle(Fname: string);
  var
    mderec: TMdeRec;
    fpending: file of TMdeRec; // neue, aufbereitete Liste an MonDa
    n: integer;
  begin
    assignFile(fpending, Fname);
    try
      reset(fpending);
    except
      on E: Exception do
        log(cERRORText + ' 748:' + E.Message);
    end;
    for n := 1 to FileSize(fpending) do
    begin
      read(fpending, mderec);

      // die Abschlüsse des Monteurs übernehmen!
      with mderec do
      begin
        if RID > 0 then
        begin
          if (ausfuehren_ist_datum > cMonDa_Status_unbearbeitet) or
            (ausfuehren_ist_datum = cMonDa_Status_Unmoeglich) or
            (ausfuehren_ist_datum = cMonDa_Status_NeuAnschreiben) or
            (ausfuehren_ist_datum = cMonDa_Status_Vorgezogen) then
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
    sPendings.LoadFromFile(MyProgramPath + AktTrn + '\' + cMonDaServer_UnberuecksichtigtFName);
    for n := 0 to pred(sPendings.count) do
    begin
      sTAN_FName := cutblank(sPendings[n]);
      if (sTAN_FName <> '') then
      begin
        sTAN_FName := MyProgramPath + cOrgaMonDataPath + sTAN_FName;
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
    bFoto: TBLager; // globales Foto-Verzeichnis (immer neuester Stand)
    bOrgaMon: TBLager; // globales Auftrags-Verzeichnis (immer neuester Stand)

    sRIDbereitsBerichtet: TgpIntegerList;
    AUFTRAG_R: integer;
    Stat_Zeilen: integer;

    procedure report(sEingabeIndex: integer; HasFoto: boolean);
    // Info-Strings
    var
      iTermin, iDetails, iStatus, iFarbe: string;
      iEingabeDatum, iEingabeUhr: string;
      iAusbau, iEinbau: string;
      Status: integer;
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
            iAusbau := sProtokoll.values['FA'];
            iEinbau := sProtokoll.values['FN'];
            if (iAusbau <> '') then
              iDetails := iDetails + #13 + 'Foto' + #160 + 'Ausbau' + #160 + iAusbau;
            if (iEinbau <> '') then
              iDetails := iDetails + #13 + 'Foto' + #160 + 'Einbau' + #160 + iEinbau;
            sProtokoll.free;
            Status := 0;
            break;
          end;

          Status := 1;

        until true;

        // Text bei Status (Spalte 3)
        if ausfuehren_ist_datum <> 0 then
          iStatus := AusfuehrenStr(ausfuehren_ist_datum)
        else
          iStatus := '';

        // Zukunft + Rot -> aus der Liste ausblenden!
        if Status = 1 then
          if ausfuehren_soll > _DateGet then
            Status := -1;

        // Restant + Rot -> Gelb
        if Status = 1 then
          if ausfuehren_ist_datum = cMonDa_Status_Restant then
            Status := 4;

        // Wegfall + Rot -> Grau
        if Status = 1 then
          if ausfuehren_ist_datum = cMonDa_Status_Wegfall then
            Status := 3;

        case Status of
          0:
            iFarbe := '66CC00'; // grün (Foto-Da)
          1:
            iFarbe := 'CC3333'; // red (kein Foto)
          2:
            iFarbe := 'FFCC66'; // organge (?)
          3:
            iFarbe := 'E8F4F8'; // grau?! (bisher keine Eingabe)
          4:
            iFarbe := 'FFFF00'; // organge (?)
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

    bFoto.Init(MyProgramPath + cServerDataPath + 'FOTO+TS', mderecFoto, sizeof(TMdeRec));
    bFoto.BeginTransaction(now);

    bOrgaMon.Init(MyProgramPath + cServerDataPath + 'AUFTRAG+TS', mderecOrgaMon, sizeof(TMdeRec));
    bOrgaMon.BeginTransaction(now);

    // der "neue" Auftrag ist massgeblich!
    assignFile(finfo, MyProgramPath + AktTrn + '\AUFTRAG.DAT');
    try
      reset(finfo);
    except
      on E: Exception do
        log(cERRORText + ' 748:' + E.Message);
    end;

    // Laden der "Eingabe.???.txt"
    if FileExists(MyProgramPath + cStatistikPath + 'Eingabe.' + GeraeteNo + '.txt') then
      sEingabe.LoadFromFile(MyProgramPath + cStatistikPath + 'Eingabe.' + GeraeteNo + '.txt');

    // Über die Eingaben des Monteurs selbst
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
            bOrgaMon.get
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
          begin
            // if HasFoto then and mderecOrgaMon.ausfuehren_soll then
            repeat

              report(n, HasFoto);
            until true;
          end;

        end;
    end;

    // Über die Angaben des Büros
    for n := 1 to FileSize(finfo) do
    begin
      read(finfo, mderecOrgaMon);
      AUFTRAG_R := mderecOrgaMon.RID;

      // nicht norwendig, da im Auftrag immer nur einmal!
      if sRIDbereitsBerichtet.IndexOf(AUFTRAG_R) <> -1 then
        continue;

      //

      // sRIDbereitsBerichtet.add(mderecOrgaMon.RID);

      // die Abschlüsse des Monteurs übernehmen!

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
      begin
        bFoto.get;
      end;

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
      add('MehrInfo=' + 'Verbesserungsvorschläge bitte an Andreas Filsinger 07251/966100');
    end;
    MonteurInfo := THTMLTemplate.Create;
    with MonteurInfo do
    begin
      LoadFromFile(MyProgramPath + 'HTML Vorlagen\Info.html');
      WriteValue(DatensammlerLokal, DatensammlerGlobal);
      if oldInfrastructure then
        SaveToFileCompressed(MyProgramPath + 'Info\' + GeraeteNo + '.html')
      else
        SaveToFileCompressed(MyProgramPath + cWebPath + GeraeteNo + '.html');
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

var
  StartTime: int64;

begin
  StartTime := RDTSCms;
  result := TStringList.Create;

  // ermittlung des "TAN"-Parameters
  AktTrn := sParameter.values['TAN'];
  if (AktTrn = '') then
    if sParameter.count > 0 then
      AktTrn := sParameter[1];

  // weitere Parmeter
  Online := sParameter.values['OFFLINE'] <> cIni_Activate;

  try

    if Option_Console then
      write('verarbeite TAN ' + AktTrn + ' ... ');
    ClearStat;
    ErrorCount := 0;
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
    BilderAll2 := TStringList.Create;
    bOrgaMonAuftrag := TBLager.Create;
    bFotoErgebnis := TBLager.Create;

    WechselmomentKorrektur := TgpIntegerList.Create;

    //
    iFTP := TIdFTP.Create(nil);
    with iFTP do
    begin
      Host := iJonDa_FTPHost;
      UserName := iJonDa_FTPUserName;
      Password := iJonDa_FTPPassword;
      passive := true;
    end;

    repeat

      // Wer (welches Gerät) hat eigentlich gerufen
      GeraeteNo := detectGeraeteNummer(MyProgramPath + AktTrn);
      if (GeraeteNo = '') then
      begin
        log(cERRORText + ' 1433:"' + MyProgramPath + AktTrn + '\nnn.zip" fehlt!');
        inc(ErrorCount);
        break;
      end;

      BeginAction(AktTrn + ':' + GeraeteNo);

      // Verarbeitungsdatum
      if not(Online) then
        _DateGet := FDate(MyProgramPath + AktTrn + '\' + GeraeteNo + cZIPExtension)
      else
        _DateGet := DateGet;

      // MI! DO FR SA SO MO*
      // Eingaben vom Mittwoch werden auf das heutige Datum korrigiert!
      _DatumWechselTimeOut := DatePlus(_DateGet, -4);

      _DateGetTimeOut := DatePlus(_DateGet, -13);

      // Parameter für diesen Lauf auswerten
      if FileExists(MyProgramPath + cGeraeteEinstellungen + GeraeteNo + '.ini') then
        Einstellungen.LoadFromFile(MyProgramPath + cGeraeteEinstellungen + GeraeteNo + '.ini');

      // Optionen setzen
      proceed_EinfacheListe := (Einstellungen.values[cServerOption_EinfacheListe] = cIni_Activate);

      // den neuesten <GeraeteNo>.DAT aus dem Internet holen
      // wenn nicht schon vorhanden!
      if not(ftpDown(GeraeteNo, AktTrn, iFTP)) then
      begin
        log(cERRORText + ' 936:FTPdown(' + GeraeteNo + ',' + AktTrn + ') fail!');
        inc(ErrorCount);
        break;
      end;

      // abgearbeitete Laden
      if FileExists(MyProgramPath + AktTrn + '\' + cMonDaServer_AbgearbeitetFName) then
      begin
        OrgaMonAbgearbeitet.LoadFromFile(MyProgramPath + AktTrn + '\' +
          cMonDaServer_AbgearbeitetFName);
        Stat_OrgaMonGruen := OrgaMonAbgearbeitet.count;
      end;

      // JonDaServer kennt die UpLoad-Dateien, die
      // vom OrgaMon noch nicht berücksichtigt sind. Solange OrgaMon
      // diese "unberücksichtigen" noch nicht verarbeitet hat, muss
      // JonDaServer seine eigenen Schlusse daraus ziehen.
      //
      // Abgearbeitete der anderen Monteure und anderen TAN laden
      if FileExists(MyProgramPath + AktTrn + '\' + cMonDaServer_UnberuecksichtigtFName) then
        addPending;
      Stat_OrgaMonPending := OrgaMonAbgearbeitet.count - Stat_OrgaMonGruen;

      // Abgezogene laden
      addAbgezogene;

      // "Weiter-Versuche-Marker" löschen, damit der Weg für eine neue TAN frei wird.
      //
      FileDelete(FolgeTANFName(GeraeteNo));

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

        // nun alle Setting-Lines entfernen
        if (JondaAll.count > 0) then
          while (pos(';', JondaAll[0]) = 0) do
          begin
            JondaAll.Delete(0);
            if JondaAll.count = 0 then
              break;
          end;

        // bei aufeinanderfolgenden Meldungen zu identischen RIDs immer die letzte Meldung nehmen
        for n := pred(JondaAll.count) downto 1 do
          if (pos('-1;', JondaAll[n]) <> 1) then
            if nextp(JondaAll[n], ';', 0) = nextp(JondaAll[pred(n)], ';', 0) then
              JondaAll.Delete(pred(n));

        // versehentlich doppelt übertragene Datensätze löschen
        JondaAll.sort;
        RemoveDuplicates(JondaAll);

        // jetzt noch alle "relevanten" Meldungen hinzu!
        if (GeraeteNo <> '000') then
          MergeMeldung;

        // Es wird nun die ursprüngliche AUFTRAG.DAT des Handys rekonstruiert
        assignFile(f_OrgaMonApp_Ergebnis, MyProgramPath + AktTrn + '\AUFTRAG.DAT');
        try
          rewrite(f_OrgaMonApp_Ergebnis);
        except
          on E: Exception do
            log(cERRORText + ' 1058:' + E.Message);
        end;

        // Alle "Kopieen" nun in die Ausgabe!
        fillchar(mderec, sizeof(mderec), 0);
        for n := pred(JondaAll.count) downto 0 do
          if (pos('-1;', JondaAll[n]) = 1) then
          begin

            sOrgaMonErgebnis.add(JondaAll[n]);
            with mderec do
            begin

              // Originalzeile laden, MS-DOS Zeichsatz simulieren!
              OneJLine := WebToMdeRecString(JondaAll[n]);

              // nun die einzelnen Felder füllen
              RID := strtointdef(nextp(OneJLine, ';'), -1);
              Baustelle := GeraeteNo;
              zaehlernummer_korr := nextp(OneJLine, ';');
              zaehlernummer_neu := nextp(OneJLine, ';');
              zaehlerstand_neu := nextp(OneJLine, ';');
              zaehlerstand_alt := nextp(OneJLine, ';');
              Reglernummer_korr := nextp(OneJLine, ';');
              Reglernummer_neu := nextp(OneJLine, ';');
              JProtokoll := nextp(OneJLine, ';');
              ersetze(cJondaProtokollDelimiter, ';', JProtokoll);
              if (length(JProtokoll) > 254) then
                log(cWARNINGText + ' 1259:' + 'Protokoll zu lange!');
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
          JAuftragBisherFName := MyProgramPath + LastTrnNo + '\AUFTRAG.DAT';
          if FileExists(JAuftragBisherFName) then
            break;

          // "AUFTRAG.DAT" aus globaler Ablage
          JAuftragBisherFName := MyProgramPath + cServerDataPath + 'AUFTRAG.' + GeraeteNo +
            cDATExtension;
          if FileExists(JAuftragBisherFName) then
            break;

          JAuftragBisherFName := '';

        until true;

        // nun alle Datensätze aus der alten TRN rüberkopieren!
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

            // die Eingaben des Monteurs jedoch übernehmen (wenn vorhanden!)
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
                  zaehlernummer_korr := nextp(OneJLine, ';');
                  zaehlernummer_neu := nextp(OneJLine, ';');
                  zaehlerstand_neu := nextp(OneJLine, ';');
                  zaehlerstand_alt := nextp(OneJLine, ';');
                  Reglernummer_korr := nextp(OneJLine, ';');
                  Reglernummer_neu := nextp(OneJLine, ';');
                  JProtokoll := nextp(OneJLine, ';');
                  ersetze(cJondaProtokollDelimiter, ';', JProtokoll);
                  if (length(JProtokoll) > 254) then
                    log(cWARNINGText + ' 1324:' + 'Protokoll zu lange!');
                  ProtokollInfo := JProtokoll;
                  ausfuehren_ist_datum := strtointdef(nextp(OneJLine, ';'),
                    cMonDa_Status_unbearbeitet);
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

          // Jetzt alle Unberücksichtigten+Merge aus JonDaAll in MonDaE
          for n := 0 to pred(JondaAll.count) do
          begin
            OneJLine := WebToMdeRecString(JondaAll[n]);
            iRID := strtointdef(nextp(OneJLine, ';'), 0);
            if (iRID > 0) then
            begin
              sOrgaMonErgebnis.add(JondaAll[n]);

              // die Eingaben des Monteurs jedoch übernehmen!
              fillchar(mderec, sizeof(mderec), 0);
              with mderec do
              begin
                RID := iRID;
                ausfuehren_soll := cMonDa_FreieTerminWahl;

                zaehlernummer_korr := nextp(OneJLine, ';');
                zaehlernummer_neu := nextp(OneJLine, ';');
                zaehlerstand_neu := nextp(OneJLine, ';');
                zaehlerstand_alt := nextp(OneJLine, ';');
                Reglernummer_korr := nextp(OneJLine, ';');
                Reglernummer_neu := nextp(OneJLine, ';');
                JProtokoll := nextp(OneJLine, ';');
                ersetze(cJondaProtokollDelimiter, ';', JProtokoll);
                if (length(JProtokoll) > 254) then
                  log(cWARNINGText + ' 1365:' + 'Protokoll zu lange!');
                ProtokollInfo := JProtokoll;
                ausfuehren_ist_datum := strtointdef(nextp(OneJLine, ';'),
                  cMonDa_Status_unbearbeitet);
                ausfuehren_ist_uhr := strtointdef(nextp(OneJLine, ';'), 0);
              end;
              write(f_OrgaMonApp_Ergebnis, mderec);
            end;
          end;

        end
        else
        begin

          // Jetzt alle Unberücksichtigten+Merge aus JonDaAll in die abgearbeiteten hinzu!
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

      log('Monteur ' + NAME);
      log('LastTrn ' + LastTrnNo);
      log('OrgaMon-App Rev. ' + RevToStr(RemoteRev));
      log('IMEI ' + IMEI);

      { Quell-Datei vorhanden? }
      if not(FileExists(MyProgramPath + AktTrn + '\AUFTRAG.DAT')) then
      begin
        EndAction(cWARNINGText + ' "' + MyProgramPath + AktTrn + '\AUFTRAG.DAT" fehlt!');
        FileEmpty(MyProgramPath + AktTrn + '\AUFTRAG.DAT');
      end;

      if not(Online) then
        FileDelete(MyProgramPath + AktTrn + '\MONDA.DAT');

      if not(FileExists(MyProgramPath + AktTrn + '\MONDA.DAT')) then
        FileReName(MyProgramPath + AktTrn + '\AUFTRAG.DAT', MyProgramPath + AktTrn + '\MONDA.DAT');

      // Foto-Datei
      bFotoErgebnis.Init(MyProgramPath + cServerDataPath + 'FOTO+TS', mderec, sizeof(TMdeRec));
      bFotoErgebnis.BeginTransaction(long2datetime(_DateGet));

      // aktuelle, neue OrgaMon Daten fürs Gerät
      assignFile(f_OrgaMon_Auftrag, MyProgramPath + AktTrn + '\' + GeraeteNo + cDATExtension);
      try
        reset(f_OrgaMon_Auftrag);
      except
        on E: Exception do
          log(cERRORText + ' 1235:' + E.Message);
      end;

      // an OrgaMon gemeldete Ergebnisse
      assignFile(fOrgaMonErgebnis, MyProgramPath + AktTrn + '\' + AktTrn + cDATExtension);
      try
        rewrite(fOrgaMonErgebnis);
      except
        on E: Exception do
          log(cERRORText + ' 1249:' + E.Message);
      end;

      // aktuelle MonDa Daten
      if (OldTrn <> '') then
      begin
        FileConcat(MyProgramPath + AktTrn + '\MONDA.DAT', MyProgramPath + OldTrn + '\MONDA.DAT',
          MyProgramPath + AktTrn + '\MONDA.$$$');
        FileCopy(MyProgramPath + AktTrn + '\MONDA.$$$', MyProgramPath + AktTrn + '\MONDA.DAT');
      end;

      assignFile(f_OrgaMonApp_Ergebnis, MyProgramPath + AktTrn + '\MONDA.DAT');
      try
        reset(f_OrgaMonApp_Ergebnis);
      except
        on E: Exception do
          log(cERRORText + ' 1256:' + E.Message);
      end;
      Stat_Bisher := FileSize(f_OrgaMonApp_Ergebnis);

      // neue, kommende JonDa-Daten!
      assignFile(f_OrgaMonApp_NeuerAuftrag, MyProgramPath + AktTrn + '\AUFTRAG.DAT');
      try
        rewrite(f_OrgaMonApp_NeuerAuftrag);
      except
        on E: Exception do
          log(cERRORText + ' 1276:' + E.Message);
      end;

      assignFile(MonDaAasTxt, MyProgramPath + AktTrn + '\auftrag.$$$');
      try
        rewrite(MonDaAasTxt);
      except
        on E: Exception do
          log(cERRORText + ' 1286:' + E.Message);
      end;

      // hey, hartnäckige MonDa Daten, die bleiben auf dem Gerät
      assignFile(MonDaA_StayF, MyProgramPath + AktTrn + '\STAY.DAT');
      try
        rewrite(MonDaA_StayF);
      except
        on E: Exception do
          log(cERRORText + ' 1296:' + E.Message);
      end;

      // hoh, diese Daten wurden in den Unmöglich-Zwang übergeben!
      assignFile(MonDaA_LostF, MyProgramPath + AktTrn + '\LOST.DAT');
      try
        rewrite(MonDaA_LostF);
      except
        on E: Exception do
          log(cERRORText + ' 1305:' + E.Message);
      end;

      { erst mal die neuen RIDs sammeln! }
      { das sind die, welche vom OrgaMon auf dem Gerät gesehen werden }
      { sollen. }
      bOrgaMonAuftrag.Init(MyProgramPath + cServerDataPath + 'AUFTRAG+TS', mderec, sizeof(TMdeRec));
      bOrgaMonAuftrag.BeginTransaction(long2datetime(_DateGet));
      EntryPointReached := false;
      for m := 1 to FileSize(f_OrgaMon_Auftrag) do
      begin

        read(f_OrgaMon_Auftrag, mderec);

        // imp-pend:
        // nur dann schreiben, wenn die Generation des Rec
        // neuer ist als die Vorhandene
        // imp-pend:
        // Clean Up, Falls ein Auftrag eine gewisse Zeit
        // vom OrgaMon nicht mehr kommt, muss er hier gelöscht
        // werden. Das ist Aufgabe eine Clean-Up Algos, der muss rein
        // Zeitgesteuert sein, genau wie die Eingabe-txt, also alles was
        // aus dem Fokus gerät muss hier rausgelöscht werden.
        with bOrgaMonAuftrag do
        begin
          if exist(mderec.RID) then
            put(sizeof(TMdeRec))
          else
            insert(mderec.RID, sizeof(TMdeRec));
        end;

        // Die "Vorlagen" müssen immer ganz an den Anfang!
        if (mderec.ausfuehren_soll = cMonDa_ImmerAusfuehren) then
        begin
          add_OrgaMonApp_NeuerAuftrag;
          OrgaMonFertig.add(mderec.RID);
          GoodMonteurL.add(mderec.monteur);
        end;

        if (mderec.ausfuehren_soll = cMonDa_FreieTerminWahl) or (mderec.ausfuehren_soll >= _DateGet)
          or EntryPointReached then
        begin
          //
          // ist es eine aktuelle News von OrgaMon -> beibehalten
          //
          OrgaMonPlanungsVolumen.add(mderec.RID);
          GoodMonteurL.add(mderec.monteur);
          EntryPointReached := true;
        end;

        // Fertige dürfen entgültig nicht mehr auf das Gerät
        if isFertig then
          OrgaMonFertig.add(mderec.RID);

      end;
      bOrgaMonAuftrag.EndTransaction;
      GoodMonteurL.sort;
      RemoveDuplicates(GoodMonteurL);
      seek(f_OrgaMon_Auftrag, 0);

      { gelieferte Daten vom JonDa verarbeiten }
      if not(proceed_ArbeitIgnorieren) then
        for m := 1 to FileSize(f_OrgaMonApp_Ergebnis) do
        begin

          // Bearbeitete Daten durchsuchen!
          read(f_OrgaMonApp_Ergebnis, mderec); { MONDA.DAT }
          if (mderec.RID = 0) then
            continue;

          // Zeitpunkt prüfen
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

          // pre 2.019 Bug: "Alles fertig",
          if (RevIsFrom(RemoteRev, cVersion_OrgaMonApp)) then
            if (RevIsBefore(RemoteRev, 2.019)) then
              if (pos('ZZ=J', mderec.ProtokollInfo) > 0) then
                if (
                  { } (mderec.ausfuehren_ist_datum = cMonDa_Status_Restant) or
                  { } (mderec.ausfuehren_ist_datum = cMonDa_Status_unbearbeitet)) then
                begin
                  inc(Stat_AusfuehrungsMomentKorrektur);
                  WechselmomentKorrektur.add(mderec.RID);

                  // Auf "heute" 12:00:00 h umstellen!
                  mderec.ausfuehren_ist_datum := _DateGet;
                  mderec.ausfuehren_ist_uhr := cNoon;
                end;

          // isTest, damit kann man Eingaben ignorieren!
          // z.B. Test-Eingabe "Thüga" alle ignorieren!
          if isTest(GeraeteNo, mderec.RID, mderec.ausfuehren_ist_datum) then
          begin
            // Testeingabe, die nicht berücksichtigt werden kann
            mderec.ausfuehren_ist_datum := cMonDa_Status_unbearbeitet;
            inc(Stat_IgnoriertTest);
          end;

          //
          // unbearbeitete aus der Vergangenheit verfallen automatisch in den
          // Status Restant, hier wurde ja gar nichts gemacht!!!
          //
          if (mderec.ausfuehren_soll < _DateGet) and
            (mderec.ausfuehren_soll <> cMonDa_FreieTerminWahl) and
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
                  (mderec.ausfuehren_soll > 0) // überhaupt ein Termin
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
                    log('FallBack: ' + Baustelle + ';' + zaehlernummer_alt + ';' + monteur + ';' +
                      inttostr(RID) + ';' + long2date(ausfuehren_soll) + ';' +
                      BoolToStr(vormittags));

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
                    //
                    if (OrgaMonPlanungsVolumen.IndexOf(mderec.RID) = -1) then
                    begin

                      //
                      // zum Monda-Auftrag rausschreiben, da es vom OrgaMon
                      // nicht mehr kommt!
                      //
                      if not(proceed_RestantenLoeschen) and not(proceed_EinfacheListe) then
                      begin
                        add_OrgaMonApp_NeuerAuftrag;
                      end;

                    end
                    else
                    begin

                      //
                      // der Datensatz ist bekannt, er sollte jedoch (so) erhalten
                      // bleiben.
                      //
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
        if (mderec.ausfuehren_soll = cMonDa_ImmerAusfuehren) or
          (mderec.ausfuehren_soll = cMonDa_FreieTerminWahl) or (mderec.ausfuehren_soll >= _DateGet)
          or EntryPointReached then
        begin
          EntryPointReached := true;
          k := MondaStay.IndexOf(inttostr(mderec.RID));
          if (k = -1) then
          begin
            // den OrgaMon-Datensatz unverändert übernehmen! Es gibt keine
            // schützenswerte Monda-Daten, der OrgaMon-Datensatz ist MonDa unbekannt.
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

      SaveStringsToFileUTF8(sOrgaMonErgebnis, MyProgramPath + AktTrn + '\' + AktTrn +
        cUTF8DataExtension);
      CloseFile(f_OrgaMonApp_Ergebnis);
      CloseFile(f_OrgaMonApp_NeuerAuftrag);
      CloseFile(MonDaA_StayF);
      CloseFile(MonDaA_LostF);
      bFotoErgebnis.EndTransaction;

      MondaBaustellen.sort;
      RemoveDuplicates(MondaBaustellen);

      // Datensicherung der Monteur-Eingabe-Datei erstellen
      if not(FileExists(MyProgramPath + AktTrn + '\' + 'Eingabe.' + GeraeteNo + '.txt')) then
      begin
        if FileExists(MyProgramPath + cStatistikPath + 'Eingabe.' + GeraeteNo + '.txt') then
          FileCopy(
            { } MyProgramPath + cStatistikPath + 'Eingabe.' + GeraeteNo + '.txt',
            { } MyProgramPath + AktTrn + '\' + 'Eingabe.' + GeraeteNo + '.txt')
        else
          FileAlive(MyProgramPath + AktTrn + '\' + 'Eingabe.' + GeraeteNo + '.txt');
      end;

      // BilderAll
      if (BilderAll.count > 0) then
        LogBilder(BilderAll, GeraeteNo);

      if (BilderAll2.count > 0) then
        LogBilder2(BilderAll2, GeraeteNo);

      // Nun die neue Eingabe.txt sichern
      m := 0;
      repeat
        if (m = 0) then
          Fname := MyProgramPath + AktTrn + '\' + 'Eingabe.' + GeraeteNo + '.Neu.txt'
        else
          Fname := MyProgramPath + AktTrn + '\' + 'Eingabe.' + GeraeteNo + '.Neu-' +
            inttostr(m) + '.txt';
        inc(m);
      until not(FileExists(Fname));
      FileCopy(MyProgramPath + cStatistikPath + 'Eingabe.' + GeraeteNo + '.txt', Fname);

      // alle Zuordnungen ansehen,
      // Beispiel:    PLED3->PLE & PLED2->PLE
      for m := 0 to pred(sProtokolle.count) do
      begin
        OneJLine := AnsiUpperCase(nextp(sProtokolle[m], cJondaProtokollDelimiter, 1));
        if (OneJLine <> '') then
          if (ProtocolAll.IndexOf(OneJLine) = -1) then
            ProtocolAll.add(OneJLine);
      end;

      // nun alle Protokolle anfügen
      for m := 0 to pred(ProtocolAll.count) do
      begin
        ProtS := ProtocolAll[m];
        WriteJonDa(':' + ProtS);

        //
        ProtocolL.LoadFromFile(ProtokollPath(RemoteRev) + ProtocolAll[m] + cProtExtension);

        if RevIsBefore(RemoteRev, cVersion_OrgaMonApp) then
        begin
          for k := 0 to pred(ProtocolL.count) do
            if (length(ProtocolL[k]) > 0) then
              if (ProtocolL[k][1] <> ':') then
                WriteJonDa(Oem2asci(ProtocolL[k]));
        end
        else
        begin
          for k := 0 to pred(ProtocolL.count) do
            if (length(ProtocolL[k]) > 0) then
              if (ProtocolL[k][1] <> ':') then
                WriteJonDa(ProtocolL[k]);
        end;
      end;

      // nun alle Geräte-Optionen noch anfügen, falls vorhanden
      if (Einstellungen.values[cServerOption_JonDaOptionen] <> '') then
      begin
        WriteJonDa(':' + 'OPTIONEN');
        WriteJonDa(Einstellungen.values[cServerOption_JonDaOptionen]);
      end;

      // nun alle (einmaligen) Geräte-Kommandos
      if (RevIsFrom(RemoteRev, 2.016)) then
        if FileExists(MyProgramPath + cGeraeteKommandos + GeraeteNo + '.ini') then
        begin
          Einstellungen := TStringList.Create;
          Einstellungen.LoadFromFile(MyProgramPath + cGeraeteKommandos + GeraeteNo + '.ini');
          for k := 0 to pred(Einstellungen.count) do
            WriteJonDa('$' + Einstellungen[k]);
          Einstellungen.free;

          // Als verarbeitet markieren indem es nach AktTrn verschoben wird
          FileMove(MyProgramPath + cGeraeteKommandos + GeraeteNo + '.ini',
            MyProgramPath + AktTrn + '\' + GeraeteNo + '.ini');
        end;

      //
      CloseJonDa;

      // Alte Datei löschen
      FileDelete(MyProgramPath + AktTrn + '\auftrag.txt');

      // Neue Aufträge bereitstellen
      repeat

        // noch JonDa?
        if not(RevIsFrom(RemoteRev, cVersion_OrgaMonApp)) then
        begin
          log(cWARNINGText + ' JonDa ' + RevToStr(RemoteRev) + ' wird nicht mehr unterstützt!');
          FileCopy(ProtokollPath(RemoteRev) + 'VersionNichtAusreichend.txt',
            MyProgramPath + AktTrn + '\auftrag.txt');
          break;
        end;

        // zu alte OrgaMon-App?
        if not(RevIsFrom(RemoteRev, cMinVersion_OrgaMonApp)) then
        begin
          // Programmversion ist zu alt!
          log(cWARNINGText + ' Programmversion ' + RevToStr(RemoteRev) + ' zu alt!');
          FileCopy(ProtokollPath(RemoteRev) + 'VersionNichtAusreichend' + cUTF8DataExtension,
            MyProgramPath + AktTrn + '\auftrag' + cUTF8DataExtension);
          Stat_PostError := 'veraltet';
          break;
        end;

        // Gerätenummer gar nicht bekannt?
        if (BEZAHLT_BIS = cMonDa_ErsteEingabe) then
        begin
          // Unbekannte Gerätenummer
          log(cWARNINGText + ' Unbekannte Gerätenummer!');
          FileCopy(ProtokollPath(RemoteRev) + 'Undefiniert' + cUTF8DataExtension,
            MyProgramPath + AktTrn + '\auftrag' + cUTF8DataExtension);
          Stat_PostError := 'undefiniert';
          break;
        end;

        // Vertragszeitraum nicht bezahlt?
        if DateOK(BEZAHLT_BIS) and (_DateGet > BEZAHLT_BIS) then
        begin
          // Unbezahlt!
          log(cWARNINGText + ' Unbezahlter Zeitraum!');
          FileCopy(ProtokollPath(RemoteRev) + 'Unbezahlt' + cUTF8DataExtension,
            MyProgramPath + AktTrn + '\auftrag' + cUTF8DataExtension);
          Stat_PostError := 'unbezahlt';
          break;
        end;

        // IMEI überhaupt gültig?
        if (tIMEI_OK.locate('IMEI', IMEI) = -1) then
        begin
          // Unbekanntes Handy
          log(cWARNINGText + ' Unbekanntes Handy!');
          FileCopy(ProtokollPath(RemoteRev) + 'Unbekannt' + cUTF8DataExtension,
            MyProgramPath + AktTrn + '\auftrag' + cUTF8DataExtension);
          Stat_PostError := 'unbekannt';
          break;
        end;

        // Auftrag.txt nun wirklich bereitstellen!
        FileReName(MyProgramPath + AktTrn + '\auftrag.$$$', MyProgramPath + AktTrn + '\auftrag.txt')

      until true;

      if (GeraeteNo <> '000') then
        if (Stat_Meldungen > 0) then
        begin

          // Sicherung ins "OrgaMon" Verzeichnis!
          FileCopy(MyProgramPath + AktTrn + '\' + AktTrn + cDATExtension,
            MyProgramPath + cOrgaMonDataPath + AktTrn + cDATExtension);

          // Web-Statistik anfertigen!
          if (Stat_FotoMeldungen > 0) then
            WebSite;
        end;

      if (Stat_OrgaMonGruen <> 0) or (Stat_OrgaMonPending <> 0) then
        log('OrgaMon grün  : ' + inttostr(Stat_OrgaMonGruen) + '+' + inttostr(Stat_OrgaMonPending));
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
        log('Unmöglich     : ' + inttostr(Stat_Unmoeglich));
      if (Stat_Vorgezogen <> 0) then
        log('Vorgezogen    : ' + inttostr(Stat_Vorgezogen));
      if (Stat_FrischFertig <> 0) then
        log('Fertige -     : ' + inttostr(Stat_FrischFertig));
      if (Stat_Schlafmuetzen <> 0) then
        log('Schlafmützen  : ' + inttostr(Stat_Schlafmuetzen));
      if (Stat_AusfuehrungsMomentKorrektur <> 0) then
        log('Korrigiert    : ' + inttostr(Stat_AusfuehrungsMomentKorrektur));
      if (Stat_Abberufen <> 0) then
        log('Abberufen     : ' + inttostr(Stat_Abberufen));
      if (Stat_IgnoriertTest <> 0) or (Stat_IgnoriertFehlenderAuftrag <> 0) then
        log('Ignoriert     : ' + inttostr(Stat_IgnoriertTest) + '/' +
          inttostr(Stat_IgnoriertFehlenderAuftrag));
      if (Stat_MondaStay <> 0) then
        log('Stay-liste    : ' + inttostr(Stat_MondaStay));
      if (Stat_Meldungen <> 0) or (Stat_SelbstAnlagen <> 0) then
        log('->OrgaMon/Neu : ' + inttostr(Stat_Meldungen) + '/' + inttostr(Stat_SelbstAnlagen));
      if (Stat_MondaNeu <> 0) then
        log('->JonDa       : ' + inttostr(Stat_MondaNeu));
      log('Baustellen    : ' + HugeSingleLine(MondaBaustellen, ','));
      log('Protokolle    : ' + HugeSingleLine(sProtokolle, ' & '));

      assignFile(MonDaGeraetF, MyProgramPath + AktTrn + '\GERAET.DAT');
      try
        rewrite(MonDaGeraetF);
      except
        on E: Exception do
          log(cERRORText + ' 1633:' + E.Message);
      end;
      writeln(MonDaGeraetF, GeraeteNo);
      writeln(MonDaGeraetF, AktTrn);
      CloseFile(MonDaGeraetF);

      assignFile(MonDaGeraetF, MyProgramPath + cStatistikPath + GeraeteNo + '.txt');
      try
        rewrite(MonDaGeraetF);
      except
        on E: Exception do
          log(cERRORText + ' 1644:' + E.Message);
      end;
      writeln(MonDaGeraetF, AktTrn);
      CloseFile(MonDaGeraetF);

    until true;

    if (ErrorCount = 0) then
    begin
      if not(proceed_NoUpload) then
        if (GeraeteNo <> '000') then
        begin

          FileCopy(MyProgramPath + AktTrn + '\AUFTRAG.DAT', MyProgramPath + cServerDataPath +
            'AUFTRAG.' + GeraeteNo + cDATExtension);
          try
            with iFTP do
            begin
              //
              if not(connected) then
                connect;
              if (FSize(MyProgramPath + AktTrn + '\' + AktTrn + cDATExtension) > 0) then
              begin
                // TAN Upload
                sput(
                  { } MyProgramPath + AktTrn + '\' + AktTrn + cDATExtension,
                  { } AktTrn + cDATExtension,
                  { } iFTP);
                sput(
                  { } MyProgramPath + AktTrn + '\' + AktTrn + cUTF8DataExtension,
                  { } AktTrn + cUTF8DataExtension,
                  { } iFTP);

              end
              else
              begin
                log('Unterlassener Upload aufgrund Ergebnislosigkeit bei TRN ' + AktTrn);
              end;
              sput(MyProgramPath + AktTrn + '\AUFTRAG.DAT',
                'AUFTRAG.' + GeraeteNo + cDATExtension, iFTP);
              try
                DisConnect;
              except
                // diese Exception "10054" ist normal und braucht nicht
                // gehandelt werden.
              end;
            end;
          except
            on E: Exception do
              log(cERRORText + ' 1470:' + E.Message);
          end;
        end;
      if Option_Console then
        writeln('OK');
      result.addobject('0', TXMLRPC_Server.oInteger);

    end
    else
    begin
      result.addobject('1', TXMLRPC_Server.oInteger);
    end;

    // Nach "SENDEN" Tabelle protokollieren
    // IMEI;NAME;ID;MOMENT;TAN;REV;ERROR;PAPERCOLOR

    if FileExists(MyProgramPath + cDBPath + 'SENDEN.csv') then
    begin

      tSENDEN := TsTable.Create;
      with tSENDEN do
      begin
        InsertFromFile(MyProgramPath + cDBPath + 'SENDEN.csv');

        // Alte Zeile löschen
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
        if oldInfrastructure then
          SaveToHTML(MyProgramPath + cStatistikPath + 'index.html')
          else
          SaveToHTML(MyProgramPath + cWebPath + 'senden.html');
        SaveToFile(MyProgramPath + cDBPath + 'SENDEN.csv');
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
    BilderAll2.free;
    bOrgaMonAuftrag.free;
    bFotoErgebnis.free;
    WechselmomentKorrektur.free;
    iFTP.free;
    Einstellungen.free;

  except
    on E: Exception do
      log(cERRORText + ' 2481:' + E.Message);
  end;

  AppendStringsToFile(DatumLog + ';' + uhr8 + ';' + 'ProceedTAN:' + AktTrn + ';' +
    inttostr(RDTSCms - StartTime) + 'ms', MyProgramPath + cJonDaServer_XMLRPCLogFName);

end;

class function TJonDaExec.ProtokollPath(Rev: single): string;
begin
  if RevIsFrom(Rev, cVersion_OrgaMonApp) then
    result := MyProgramPath + cProtokollPath
  else
    result := MyProgramPath + cUpdatePath;
end;

function TJonDaExec.start(sParameter: TStringList): TStringList;
var
  s: string;
  GeraetID, _GeraetID: string;
  _TAN: string;
  version, Optionen, UHR, IMEI, NAME: string;
  TAN: string;
  BEZAHLT_BIS: TANFiXDate;
  Einstellungen: TStringList; // vorbereitete Einstellungen für dieses Gerät
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
  // vorbereitete Einstellungen für dieses Gerät
  repeat

    if (start_StaticResult <> '') then
    begin
      result.add(start_StaticResult);
      start_StaticResult := '';
      break;
    end;

    MomentDate := DateGet;
    MomentTime := secondsget;

    try

      NAME := '';
      BEZAHLT_BIS := cMaxDate;
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

        // Plausibilität "Geräte-Nummer"
        if (length(StrFilter(GeraetID, '0123456789')) <> 3) then
        begin
          TAN := 'Geraetenummer ist ungültig';
          break;
        end;

        // Gerät-bekannt?
        if (GeraetID <> '000') then
        begin

          g := tIMEI.locate('GERAET', GeraetID);
          if (g = -1) then
          begin
            log(cWARNINGText + ' 2337:' + ' GERAET "' + GeraetID +
              '" ist in der IMEI-Tabelle nicht bekannt');
            BEZAHLT_BIS := cMonDa_ErsteEingabe;
          end
          else
          begin
            NAME :=
            { } tIMEI.readCell(g, 'VORNAME') + ' ' +
            { } tIMEI.readCell(g, 'NACHNAME');
            BEZAHLT_BIS :=
            { } Date2Long(tIMEI.readCell(g, 'BEZAHLT_BIS'));
          end;

        end;

        // Plausibilität "IMEI-Nummer"
        if (length(IMEI) = 0) then
        begin

          log(cWARNINGText + ' 2344:' + ' IMEI ist leer bei Gerät "' + GeraetID + '"');
          // break;

        end
        else
        begin

          if (length(IMEI) <> 15) then
          begin
            log(cWARNINGText + ' 2344:' + ' IMEI "' + IMEI + '" hat keine 15 Stellen bei GERAET "' +
              GeraetID + '"');
            // break;
          end;

          if (length(IMEI) = 15) then
          begin
            r := tIMEI.locate('IMEI', IMEI);
            if (r = -1) then
              log(cWARNINGText + ' 2344:' + ' IMEI "' + IMEI +
                '" ist in der IMEI-Tabelle nicht bekannt bei GERAET "' + GeraetID + '"');
            if (r <> -1) then
            begin
              _GeraetID := tIMEI.readCell(r, 'GERAET');
              if (_GeraetID <> GeraetID) then
              begin
                log(cWARNINGText + ' 2357:' + ' Bei IMEI "' + IMEI + '" sollte GERAET "' + _GeraetID
                  + '" verwendet werden, ist aber GERAET "' + GeraetID + '"');
              end;
            end;
          end;

        end;

        // Einstellungen laden
        if FileExists(MyProgramPath + cGeraeteEinstellungen + GeraetID + '.ini') then
        begin
          Einstellungen.LoadFromFile(MyProgramPath + cGeraeteEinstellungen + GeraetID + '.ini');
          if (Einstellungen.values[cServerOption_ZeitPruefung] = cIni_Deactivate) then
            start_NoTimeCheck := true;
        end;

        // grössere Zeitabweichung?
        if not(start_NoTimeCheck) then
        begin
          rDate := Date2Long(nextp(UHR, ' - ', 0));
          rSeconds := strtoSeconds(nextp(UHR, ' - ', 1));
          if SecondsDiffABS(DateGet, secondsget, rDate, rSeconds) > 60 * 5 then
          begin
            if (DateGet <> rDate) then
              TAN := 'Das Datum sollte ' + long2date(DateGet) + ' sein (Ist aber ' +
                long2date(rDate) + ').'
            else
              TAN := 'Die Uhrzeit sollte ' + secondstostr8(secondsget + 1) + ' sein (Ist aber ' +
                UHR + ').';
            break;
          end;
        end;
        start_NoTimeCheck := false;

        // TAN jetzt berechnen
        TAN := FolgeTAN(GeraetID);

        if not(FileExists(UpFName(TAN))) then
        begin
          // Erstmaliges Übertragen?!
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

        // Sicherstellen, dass es die Gerätenummer gibt.
        FileEmpty(MyProgramPath + TAN + '\' + GeraetID + '.zip');

      until true;
    except
      on E: Exception do
        log(cERRORText + ' 620:' + E.Message);
    end;

    // Ergebnis und den Call loggen!
    AppendStringsToFile(DatumLog + ';' + uhr8 + ';' + 'StartTAN:' + TAN + ';' + version + ';' +
      Optionen + ';' + UHR + ';' + IMEI, MyProgramPath + cJonDaServer_XMLRPCLogFName);

  until true;
  Einstellungen.free;
  result.add(TAN);
end;

procedure TJonDaExec.sput(source, dest: string; iFTP: TIdFTP);
var
  tmp: string;
begin
  try
    tmp := dest + cTmpFileExtension;
    with iFTP do
    begin

      // upload ... take your time ...
      if Size(tmp) >= 0 then
        Delete(tmp);
      put(source, tmp);
      // upload end.

      // atomic.begin
      if Size(dest) >= 0 then
        Delete(dest);
      Rename(tmp, dest);
      // atomic.end

    end;
  except
    on E: Exception do
      log(cERRORText + ' 323:' + E.Message);
  end;
end;

function TJonDaExec.foto(sParameter: TStringList): TStringList;
var
  Baustelle: string;
  FotoBenennung: integer;
  FotoPrefix: string;
  FotoParameter: string;
  Zaehler_Info: string;
  zaehlernummer_neu: string;
  zaehlernummer_alt: string;
  ZAEHLER_NUMMER_NEU: string;
  FotoDateiNameNeu: string;
  FotoDateiNameBisher: string;
  NameOhneZaehlerNummerAlt: boolean;
  UmbenennungAbgeschlossen: boolean;
  AUFTRAG_R: integer;
  FotoGeraeteNo: string;
  Path: string;
  tNAMES: TsTable;
  sNAMES: TStringList;
  r: integer;
  Fname: string;
  FreeFormat: string;
  Token, Value: string;
  WechselDatum: TANFiXDate;
  ZielBaustelle: string;
  Mandant, aknr: string;
  ReferenzDiagnose: TStringList;
  ShouldAbort: boolean;

  procedure FatalError(s: string);
  begin
    if (result.values[cParameter_foto_Fehler] = '') then
      result.values[cParameter_foto_Fehler] := s
    else
      result.values[cParameter_foto_Fehler] := result.values[cParameter_foto_Fehler] +
        cLineSeparator + s;
    result.values[cParameter_foto_fertig] := cIni_Deactivate;
    ShouldAbort := true;
  end;

begin
  result := TStringList.Create;
  FotoDateiNameNeu := '';
  // mderecOrgaMon.Baustelle / cParameter_foto_baustelle
  // mderecOrgaMon.Zaehler_Strasse / cParameter_foto_strasse
  // mderecOrgaMon.Zaehler_Ort / cParameter_foto_ort
  // mderecOrgaMon.zaehlernummer_alt / cParameter_foto_zaehlernummer_alt
  // mderecOrgaMon.zaehlernummer_neu / cParameter_foto_zaehlernummer_neu
  // cE_FotoBenennung
  FotoBenennung := strtointdef(sParameter.values[cParameter_foto_Modus], 0);
  Baustelle := sParameter.values[cParameter_foto_baustelle];
  ZielBaustelle := Baustelle;
  FotoParameter := sParameter.values[cParameter_foto_parameter];
  Zaehler_Info := sParameter.values[cParameter_foto_zaehler_info];

  // Limitierung mit der führenden Null
  zaehlernummer_neu := FormatZaehlerNummerNeu(sParameter.values[cParameter_foto_zaehlernummer_neu]);

  zaehlernummer_alt := sParameter.values[cParameter_foto_zaehlernummer_alt];
  if (length(zaehlernummer_alt) > cMonDa_FieldLength_ZaehlerNummer) then
    zaehlernummer_alt := revCopy(
      { } zaehlernummer_alt,
      { } 1,
      { } cMonDa_FieldLength_ZaehlerNummer);
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
          FotoPrefix := StrFilter(
            { } FotoPrefix,
            { } cValidFNameChars + '_') + '-';

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
          // mit Hilfe von Foto-Benennung.csv

          // default Umbenennung:
          // ====================
          // [ ~Mandant~ "-" ] [ ~aknr~ "-" ] ~~

          // völlig freie Umbennung:
          // =======================
          //
          //

          tNAMES := TsTable.Create;
          tNAMES.oTextHasLF := true;
          repeat

            if (Path = '') then
            begin
              FatalError(
                { } 'In diesem Modus muss ' + cParameter_foto_Pfad + '=' +
                { } ' gesetzt sein');
              break;
            end;

            Fname := Path + Baustelle + '\' + cE_FotoBenennung + '.csv';
            if not(FileExists(Fname)) then
            begin
              FatalError(
                { } 'Datei "' + Fname + '"' +
                { } ' nicht gefunden');
              break;
            end;

            tNAMES.InsertFromFile(Fname);
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
                  Value := '';
                  repeat

                    if (Token = 'JJJJMMTT') then
                    begin

                      WechselDatum := Date2Long(tNAMES.readCell(r, 'WechselDatum'));
                      if DateOK(WechselDatum) then
                      begin
                        Value := long2dateLog(WechselDatum);
                        break;
                      end;

                      if (FotoDateiNameBisher = '') then
                      begin
                        FatalError('Wert "DATEI=" ist leer');
                        break;
                      end;
                      if not(FileExists(FotoDateiNameBisher)) then
                      begin
                        FatalError('Datei "' + FotoDateiNameBisher + '" nicht gefunden');
                        break;
                      end;
                      Value := long2dateLog(FileDate(FotoDateiNameBisher));
                      break;
                    end;

                    if (Token = 'FN-Kurz') then
                    begin
                      NameOhneZaehlerNummerAlt := true;
                      break;
                    end;

                    // aus einer anderen Spalte
                    if tNAMES.colof(Token) = -1 then
                    begin
                      FatalError('Spalte "' + Token + '" nicht gefunden');
                      break;
                    end;
                    Value := tNAMES.readCell(r, Token);

                  until true;
                  ersetze('~' + Token + '~', Value, FotoPrefix);
                end;

              end
              else
              begin

                //
                Mandant := cutblank(tNAMES.readCell(r, 'Mandant'));
                aknr := cutblank(tNAMES.readCell(r, 'aknr'));

                if (Mandant <> '') then
                  FotoPrefix := Mandant + '-'
                else
                  FotoPrefix := '';

                if (aknr <> '') then
                  FotoPrefix := FotoPrefix + aknr + '-';

                // Bei dieser Art der Umbenennung ist
                // das Thema scheinbar direkt abgeschlossen
                // unabhängig von der Z# Neu
                UmbenennungAbgeschlossen := true;
              end;
            end
            else
            begin
              result.values[cParameter_foto_Fehler] :=
              { } 'RID "' + inttostr(AUFTRAG_R) + '"' +
              { } ' in Datei "' + Fname + '"' +
              { } ' in Spalte "' + cRID_Suchspalte + '" ' +
              { } ' nicht gefunden!';
              FotoPrefix := 'ERROR' + '-';

              // Diagnose
              if DebugMode then
                if FileAge(Path + Baustelle + '-' + cRID_Suchspalte + '.csv') < FileAge(Fname) then
                begin

                  ReferenzDiagnose := tNAMES.Col(tNAMES.colof(cRID_Suchspalte));
                  ReferenzDiagnose.SaveToFile(Path + Baustelle + '-' + cRID_Suchspalte + '.csv');
                  ReferenzDiagnose.free;
                end;

            end;
          until true;
          tNAMES.free;

        end;
      7:
        begin
          // Erdgas Südwest
          repeat

            if (pos('FR', FotoParameter) = 1) then
            begin
              FotoPrefix := 'V-' +
              { } sParameter.values[cParameter_foto_ort] + ' ' +
              { } sParameter.values[cParameter_foto_strasse];
              ersetze(' ', '_', FotoPrefix);
              FotoPrefix := StrFilter(
                { } FotoPrefix,
                { } cValidFNameChars + '_') + '-';
              break;
            end;

            if (pos('FL', FotoParameter) = 1) then
            begin
              FotoPrefix := 'N-' +
              { } sParameter.values[cParameter_foto_ort] + ' ' +
              { } sParameter.values[cParameter_foto_strasse];
              ersetze(' ', '_', FotoPrefix);
              FotoPrefix := StrFilter(
                { } FotoPrefix,
                { } cValidFNameChars + '_') + '-';
              break;
            end;

          until true;

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
          FotoPrefix := StrFilter(
            { } FotoPrefix,
            { } cValidFNameChars + '_') + '-';

        end;
      10:
        begin
          // wie "7" Erdgas Südwest, jedoch mit Z#Neu
          // da der OrgaMonApp-Server im Modus "7" keine "-Neu"
          // umbenennung macht und will. Ursache unklar
          repeat

            if (pos('FR', FotoParameter) = 1) then
            begin
              FotoPrefix := 'V-' +
              { } sParameter.values[cParameter_foto_ort] + ' ' +
              { } sParameter.values[cParameter_foto_strasse];
              ersetze(' ', '_', FotoPrefix);
              FotoPrefix := StrFilter(
                { } FotoPrefix,
                { } cValidFNameChars + '_') + '-';
              break;
            end;

            if (pos('FL', FotoParameter) = 1) then
            begin
              FotoPrefix := 'N-' +
              { } sParameter.values[cParameter_foto_ort] + ' ' +
              { } sParameter.values[cParameter_foto_strasse];
              ersetze(' ', '_', FotoPrefix);
              FotoPrefix := StrFilter(
                { } FotoPrefix,
                { } cValidFNameChars + '_') + '-';
              break;
            end;

          until true;

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
              FotoPrefix := StrFilter(
                { } FotoPrefix,
                { } cValidFNameChars + '_') + '-';
              break;
            end;

          until true;

        end;
    end;

    // Prefix: zusätzliche Erweiterungen, für alle Baustellen gültig
    if (pos('Schrott', Zaehler_Info) > 0) then
      FotoPrefix := FotoPrefix + 'Schrott-';

    repeat

      // Ausbau
      if (pos('FA', FotoParameter) = 1) or (pos('Ausbau', FotoParameter) = 1) then
      begin
        if NameOhneZaehlerNummerAlt then
          FotoDateiNameNeu := FotoPrefix
        else
          FotoDateiNameNeu := FotoPrefix + StrFilter(zaehlernummer_alt, cValidFNameChars + '_');
        UmbenennungAbgeschlossen := true;
        break;
      end;

      // Einbau
      if (pos('FN', FotoParameter) = 1) or (pos('Einbau', FotoParameter) = 1) then
      begin
        ZAEHLER_NUMMER_NEU := zaehlernummer_neu;

        if (ZAEHLER_NUMMER_NEU = '') then
        begin
          FotoGeraeteNo := sParameter.values[cParameter_foto_geraet];
          ZAEHLER_NUMMER_NEU := FormatZaehlerNummerNeu(callback_ZaehlerNummerNeu(AUFTRAG_R,
            FotoGeraeteNo));
        end;

        if (ZAEHLER_NUMMER_NEU = '') then
        begin
          FotoDateiNameNeu :=
          { } FotoPrefix +
          { } zaehlernummer_alt + '-Neu';
        end
        else
        begin
          if NameOhneZaehlerNummerAlt then
            FotoDateiNameNeu :=
            { } FotoPrefix +
            { } ZAEHLER_NUMMER_NEU
          else
            FotoDateiNameNeu :=
            { } FotoPrefix +
            { } zaehlernummer_alt + '-' +
            { } ZAEHLER_NUMMER_NEU;
          UmbenennungAbgeschlossen := true;
        end;
        break;
      end;

      // Sonstige
      FotoDateiNameNeu :=
      { } FotoPrefix +
      { } zaehlernummer_alt +
      { } '-' + FotoParameter;
      UmbenennungAbgeschlossen := true;

    until true;

    break;
  end;

  if (FotoDateiNameNeu = '') then
  begin
    // leeres Ergebnis
    FatalError(
      { } 'NAME_NEU kann nicht ermittelt werden, da Prefix und Zählernummer leer sind');
  end
  else
  begin
    // Ergebnis
    if not(ShouldAbort) then
    begin
      result.values[cParameter_foto_fertig] := active(UmbenennungAbgeschlossen);
      result.values[cParameter_foto_neu] := FotoDateiNameNeu + '.jpg';
      result.values[cParameter_foto_ziel] := ZielBaustelle;
    end;
  end;
end;

function TJonDaExec.ftpDown(GeraeteNo, AktTrn: string; iFTP: TIdFTP): boolean;
var
  DownFileDate: TDateTime;
  sErgebnisTANs: TStringList;
  GeraeteNoSrc: string;
  FName_Abgezogen: string;
  FName_AbgezogenSrc: string;
begin
  result := true;
  sErgebnisTANs := TStringList.Create;

  GeraeteNoSrc := GeraeteAlias(GeraeteNo, iFTP);

  FName_Abgezogen := format(cMonDaServer_AbgezogenFName, [GeraeteNo]);
  FName_AbgezogenSrc := format(cMonDaServer_AbgezogenFName, [GeraeteNoSrc]);

  // 1) abgearbeitet.dat (OrgaMon will von diesen RIDs keine Ergebnisse mehr!)
  if not(FileExists(MyProgramPath + AktTrn + '\abgearbeitet.dat')) then
  begin

    // vom Server -> cFreshDataPath
    try
      FileDelete(MyProgramPath + cServerDataPath + 'abgearbeitet.$$$');
      with iFTP do
      begin
        if not(connected) then
          connect;
        get(cMonDaServer_AbgearbeitetFName, MyProgramPath + cServerDataPath + 'abgearbeitet.$$$');
      end;

      // die unverarbeiteten Dateien vom Server holen!
      SolidDir(iFTP, cSolidFTP_DirCurrent, cJonDa_ErgebnisMaske_deprecated, sErgebnisTANs);
      sErgebnisTANs.SaveToFile(MyProgramPath + cServerDataPath +
        cMonDaServer_UnberuecksichtigtFName);

      // Die Datei bereitstellen!
      FileDelete(MyProgramPath + cServerDataPath + cMonDaServer_AbgearbeitetFName);
      FileReName(MyProgramPath + cServerDataPath + 'abgearbeitet.$$$',
        MyProgramPath + cServerDataPath + 'abgearbeitet.dat');
    except
      on E: Exception do
        log(cERRORText + ' 2174:' + E.Message);
    end;

    // von cFreshDataPath -> ins lokale Verzeichnis!
    if FileExists(MyProgramPath + cServerDataPath + cMonDaServer_AbgearbeitetFName) then
    begin
      result :=
      // abgearbeitet.dat
        FileCopy(MyProgramPath + cServerDataPath + cMonDaServer_AbgearbeitetFName,
        MyProgramPath + AktTrn + '\' + cMonDaServer_AbgearbeitetFName) and
      // unberuecksichtigte.txt
        FileCopy(MyProgramPath + cServerDataPath + cMonDaServer_UnberuecksichtigtFName,
        MyProgramPath + AktTrn + '\' + cMonDaServer_UnberuecksichtigtFName);
    end
    else
    begin
      log(cERRORText + ' 2182:' + cMonDaServer_AbgearbeitetFName + ' fehlt');
      result := false;
    end;

  end;

  // 2) abgezogen.GGG.dat
  if (GeraeteNoSrc <> '000') then
    if not(FileExists(MyProgramPath + AktTrn + '\' + FName_Abgezogen)) then
    begin

      // vom Server -> cFreshDataPath
      try
        FileDelete(MyProgramPath + cServerDataPath + FName_Abgezogen + '.$$$');
        with iFTP do
        begin
          if not(connected) then
            connect;
          get(FName_AbgezogenSrc, MyProgramPath + cServerDataPath + FName_Abgezogen + '.$$$');
        end;

        // Die Datei bereitstellen!
        FileDelete(MyProgramPath + cServerDataPath + FName_Abgezogen);
        FileReName(MyProgramPath + cServerDataPath + FName_Abgezogen + '.$$$',
          MyProgramPath + cServerDataPath + FName_Abgezogen);
      except
        on E: Exception do
          log(cERRORText + ' 2153:' + E.Message);
      end;

      // von cFreshDataPath -> ins lokale Verzeichnis!
      if FileExists(MyProgramPath + cServerDataPath + FName_Abgezogen) then
      begin
        result := FileCopy(MyProgramPath + cServerDataPath + FName_Abgezogen,
          MyProgramPath + AktTrn + '\' + FName_Abgezogen);
      end
      else
      begin
        log(cERRORText + ' 2164:abgezogen.GGG.DAT fehlt');
        result := false;
      end;

    end;

  // 3) GeraeteNo.dat (das Auftragsvolumen!)
  if not(FileExists(MyProgramPath + AktTrn + '\' + GeraeteNo + cDATExtension)) then
  begin

    if (GeraeteNoSrc = '000') then
    begin
      // Just an empty File!
      FileEmpty(MyProgramPath + AktTrn + '\' + GeraeteNo + cDATExtension);
      result := true;
    end
    else
    begin

      try
        FileDelete(MyProgramPath + cServerDataPath + GeraeteNo + cTmpFileExtension);
        with iFTP do
        begin
          if not(connected) then
            connect;
          get(GeraeteNoSrc + cDATExtension, MyProgramPath + cServerDataPath + GeraeteNo +
            cTmpFileExtension);
          // DownFileDate := FileDate(GeraeteNoSrc + cDATExtension, true) - TIdSysVCL.OffsetFromUTC;
          DownFileDate := FileDate(GeraeteNoSrc + cDATExtension, true);
        end;
        FileDelete(MyProgramPath + cServerDataPath + GeraeteNo + cDATExtension);
        FileReName(MyProgramPath + cServerDataPath + GeraeteNo + cTmpFileExtension,
          MyProgramPath + cServerDataPath + GeraeteNo + cDATExtension);
        if (DownFileDate > 0) then
          FileSetDate(MyProgramPath + cServerDataPath + GeraeteNo + cDATExtension,
            DateTimeToFileDate(DownFileDate));
      except
        on E: Exception do
          log(cWARNINGText + ' 2212:' + E.Message);
      end;

      if FileExists(MyProgramPath + cServerDataPath + GeraeteNo + cDATExtension) then
      begin
        result := FileCopy(MyProgramPath + cServerDataPath + GeraeteNo + cDATExtension,
          MyProgramPath + AktTrn + '\' + GeraeteNo + cDATExtension);
      end
      else
      begin
        log(cERRORText + ' 2220:' + GeraeteNo + '.DAT fehlt');
        result := false;
      end;

    end;
  end;

  try
    with iFTP do
    begin
      if connected then
        DisConnect;
    end;
  except
    // stille, bzw keine Exception hier
    // Normal ist: 'Socket Error # 10054 Connection reset by peer.'
  end;
  sErgebnisTANs.free;
end;

procedure TJonDaExec.doAbschluss;
var
  MinimumDate: TDateTime;
  LastTrn: string;

  procedure Freshen(Fname: string);
  var
    bla: TBLager;
    mderec: TMdeRec;
  begin
    bla := TBLager.Create;
    bla.Init(Fname, mderec, sizeof(TMdeRec));
    bla.BeginTransaction(now);
    bla.DeleteOld(MinimumDate);
    bla.EndTransaction;
    bla.free;

    // Copy Fresh to Original
    if FileDelete(Fname + cBL_FileExtension) then
      FileMove(Fname + cBL_FreshPostfix + cBL_FileExtension, Fname + cBL_FileExtension);
  end;

begin

  // Datensicherungsverzeichnis!
  LastTrn := inttostr(pred(strtoint(ActTRN)));

  // erst mal 'ne Datensicherung machen
  FileCopy(MyProgramPath + cServerDataPath + 'FOTO+TS' + cBL_FileExtension,
    MyProgramPath + LastTrn + '\FOTO+TS' + cBL_FileExtension);
  FileCopy(MyProgramPath + cServerDataPath + 'AUFTRAG+TS' + cBL_FileExtension,
    MyProgramPath + LastTrn + '\AUFTRAG+TS' + cBL_FileExtension);

  // Zeitlimit für alte Aufträge setzen
  MinimumDate := long2datetime(DatePlus(DateGet, -cMaxAge_Foto));

  // neu aufbauen + alte raus!
  Freshen(MyProgramPath + cServerDataPath + 'FOTO+TS');
  Freshen(MyProgramPath + cServerDataPath + 'AUFTRAG+TS');

  // SENDEN.CSV neu aufbereiten
  maintainSENDEN;

  // geraete.html
  maintainGERAETE;

  //
  // imp pend: Transaktions-Datenverzeichnisse wegsichern danach löschen
  // imp pend: doAbschluss Automatisieren (per XMLRPC, per CRON, per Neustart?)
  //
  // imp pend: ev. Transaktionsverzeichnis erstellen, das führt aber auch
  // zur Veränderung des Clients. Ev. kann man da was machen
  // mit rewrite ...

end;

procedure TJonDaExec.doStat(iFTP: TIdFTP);

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
    sUmfang.LoadFromFile(MyProgramPath + cStatistikPath + UmfangFName);

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
    sStatistik.add('JonDa-Server ' + um_Baustelle + '-Statistik vom ' + long2date(iDate) + ' - ' +
      secondstostr(iTime));
    sStatistik.add('');

    sStatistik.add
      ('Gerät(Kurz)AnzAu;letzte Meldung; letztes Senden (TAN:Anz)  Anz; Fertig    ; Blau');
    sStatistik.add
      ('----------------;--------------;------------------------------;-----------;-----');

    Stat_Summe_Stueckzahl := 0;
    Stat_Summe_Blau := 0;
    Stat_Summe_Heute := 0;
    Stat_Summe_Auftrag := 0;
    Stat_Summe_Planung := 0;
    tt_Meldung := strtoSeconds('02:29:59');
    tt_Senden := strtoSeconds('09:59:59');

    iFTP.connect;

    for n := 1 to pred(sUmfang.count) do
    begin

      if (cutblank(sUmfang[n]) = '') then
        continue;

      if (sUmfang[n][1] = '-') then
      begin
        sStatistik.add
          ('--------------------------------------------------------------------------------');
        continue;
      end;

      // Gerät
      um_Geraet := nextp(sUmfang[n], ';', um_Col_Gerate);
      if (length(um_Geraet) <> 3) then
        continue;

      um_Name := nextp(sUmfang[n], ';', um_Col_Name);
      OneCell := um_Geraet + '(' + noblank(um_Name) + ')';
      bfill(OneCell, 12);

      // Anzahl des Planungsvolumens
      Stat_Planung := iFTP.Size(um_Geraet + '.DAT');

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
      if not(FileExists(MyProgramPath + cMeldungPath + um_Geraet + '.txt')) then
      begin
        FileAlive(MyProgramPath + cMeldungPath + um_Geraet + '.txt');
        FileTouch(MyProgramPath + cMeldungPath + um_Geraet + '.txt', cMonDa_FreieTerminWahl, 0);
      end;

      // Über Meldungen berichten!!
      mDate := FDate(MyProgramPath + cMeldungPath + um_Geraet + '.txt');
      mTime := FSeconds(MyProgramPath + cMeldungPath + um_Geraet + '.txt');
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

      // Anzahl der Datensätze auf dem Gerät
      sAuftragFName := MyProgramPath + cServerDataPath + 'AUFTRAG.' + um_Geraet + '.DAT';
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
      mDate := FDate(MyProgramPath + cStatistikPath + um_Geraet + '.txt');
      mTime := FSeconds(MyProgramPath + cStatistikPath + um_Geraet + '.txt');
      if (mDate > 0) then
      begin
        mTimeDiff := SecondsDiff(iDate, iTime, mDate, mTime);
        sMeldungen.LoadFromFile(MyProgramPath + cStatistikPath + um_Geraet + '.txt');
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

      // Stückzahl - Heute - Blau
      if FileExists(MyProgramPath + cMeldungPath + um_Geraet + '.txt') then
      begin
        Stat_Stueckzahl := 0;
        Stat_Blau := 0;
        Stat_Heute := 0;
        sMeldungen.LoadFromFile(MyProgramPath + cMeldungPath + um_Geraet + '.txt');
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

              until true;
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
    sStatistik.add
      ('----------------;--------------;------------------------------;-----------;-----');
    sStatistik.add(format('Summe      %5d;                                    %5d     %5d/%5d;%5d',
      [Stat_Summe_Planung, Stat_Summe_Auftrag, Stat_Summe_Heute, Stat_Summe_Stueckzahl,
      Stat_Summe_Blau]));
    sStatistik.add('');
    sStatistik.add(' # erfordert eine tel. Rückfrage bei Ableser!');
    sStatistik.add('');
    sStatistik.add(' Gerät: 3 stellige Monteurs-Identifikation');
    sStatistik.add(' Kurz: Monteurs-Namenskürzel');
    sStatistik.add(' AnzAu: Gerätevolumen abrufbar auf dem JonDaServer');
    sStatistik.add(' letzte Meldung: verstrichene Zeit (HHH:MM:SS) seit der letzten Meldung');
    sStatistik.add(' letztes Senden: verstrichene Zeit (HHH:MM:SS) seit dem letzten Senden');
    sStatistik.add
      ('  (letzte TAN:Anzahl der Aufträge auf dem Gerät) Anzahl "Senden" inerhalb der letzten 10 Tage');
    sStatistik.add(' Fertig: Summe "Fertig" heute/Summe "Fertig" gesamt');
    sStatistik.add(' Blau: Summe im Status "Blau"');
    iFTP.DisConnect;
    sStatistik.SaveToFile(MyProgramPath + cStatistikPath + 'Info-' + um_Baustelle + '.txt');
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
  dir(MyProgramPath + cStatistikPath + 'Umfang.*.csv', sDir, false);
  for n := 0 to pred(sDir.count) do
    StatSingle(sDir[n]);
  sDir.free;
end;

procedure TJonDaExec.doSync;
var
  iFTP: TIdFTP;
  sDir: TStringList;
  n: integer;
  BaustellePath: string;
begin

  // Sync Down
  iFTP := TIdFTP.Create(nil);
  SolidInit(iFTP);
  with iFTP do
  begin
    Host := iJonDa_FTPHost;
    UserName := iJonDa_FTPUserName;
    Password := iJonDa_FTPPassword;
  end;

  try
    SolidGet(iFTP, '', cMonDaServer_Baustelle, MyProgramPath + cSyncPath, true);
    SolidGet(iFTP, '', cE_FotoBenennung + '-*.csv', MyProgramPath + cSyncPath, true);
    iFTP.DisConnect;
  except

  end;
  iFTP.free;

  // baustelle.csv -> MyProgramPath + cFotoPath
  if FileExists(MyProgramPath + cSyncPath + cMonDaServer_Baustelle) then
  begin

    // prepare
    validateBaustelleCSV(MyProgramPath + cSyncPath + cMonDaServer_Baustelle);

    // compare + copy
    if not(FileCompare(
      { } MyProgramPath + cSyncPath + cMonDaServer_Baustelle,
      { } MyProgramPath + cFotoPath + cMonDaServer_Baustelle)) then
      FileVersionedCopy(
        { } MyProgramPath + cSyncPath + cMonDaServer_Baustelle,
        { } MyProgramPath + cFotoPath + cMonDaServer_Baustelle);

    // delete
    FileDelete(MyProgramPath + cSyncPath + cMonDaServer_Baustelle);
  end;

  //
  //
  // FotoBenennung-*.csv -> MyProgramPath + cDBPath + Baustelle + "FotoBenennung-"+ Baustelle + ".csv"

  sDir := TStringList.Create;
  dir(MyProgramPath + cSyncPath + cE_FotoBenennung + '-*.csv', sDir, false);
  for n := 0 to pred(sDir.count) do
  begin

    // Lese den Pfad aus dem Dateinamen
    BaustellePath := ExtractSegmentBetween(sDir[n], cE_FotoBenennung + '-', '.csv');

    // JonDa - Limitation!
    BaustellePath := copy(noblank(BaustellePath), 1, 6) + '\';

    checkcreatedir(MyProgramPath + cDBPath + BaustellePath);

    if not(FileCompare(
      { } MyProgramPath + cSyncPath + sDir[n],
      { } MyProgramPath + cDBPath + BaustellePath + cE_FotoBenennung + '.csv')) then
      FileVersionedCopy(
        { } MyProgramPath + cSyncPath + sDir[n],
        { } MyProgramPath + cDBPath + BaustellePath + cE_FotoBenennung + '.csv');

    FileDelete(MyProgramPath + cSyncPath + sDir[n]);
  end;
  sDir.free;

end;

function TJonDaExec.upMeldungen(iFTP: TIdFTP): TStringList;
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
  MyProgramPath: string;
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
    sOrgaMonFName := MyProgramPath + cOrgaMonDataPath + cFixedTAN_FName;
    assignFile(OrgaMonErgebnis, sOrgaMonFName);
    rewrite(OrgaMonErgebnis);

    // Lade die fertigen!
    lAbgearbeitet.LoadFromFile(MyProgramPath + cServerDataPath + 'abgearbeitet.dat');

    // Lade alle Meldungen!
    lMeldungen.LoadFromFile(MyProgramPath + cMeldungPath + '000.txt');
    for i := pred(lMeldungen.count) downto 0 do
    begin
      mRID := strtointdef(nextp(lMeldungen[i], ';', 0), 0);
      if (mRID > 0) then
      begin
        if (lAbgearbeitet.IndexOf(mRID) = -1) then
        begin

          // damit er nicht mehrfach übertragen wird
          lAbgearbeitet.add(mRID);

          // nun den mderec Schreiben!
          OneJLine := WebToMdeRecString(lMeldungen[i]);
          nextp(OneJLine, ';');
          with mderec do
          begin

            RID := mRID;
            zaehlernummer_korr := nextp(OneJLine, ';');
            zaehlernummer_neu := nextp(OneJLine, ';');
            zaehlerstand_neu := nextp(OneJLine, ';');
            zaehlerstand_alt := nextp(OneJLine, ';');
            Reglernummer_korr := nextp(OneJLine, ';');
            Reglernummer_neu := nextp(OneJLine, ';');
            JProtokoll := nextp(OneJLine, ';');
            ersetze(cJondaProtokollDelimiter, ';', JProtokoll);
            if (length(JProtokoll) > 254) then
              log(cWARNINGText + ' 2822:' + 'Protokoll zu lange!');
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

    with iFTP do
    begin
      //
      if not(connected) then
        connect;
      if (FSize(sOrgaMonFName) > 0) then
      begin
        sput(sOrgaMonFName, cFixedTAN_FName, iFTP)
      end
      else
      begin
        log('Unterlassener Upload aufgrund Ergebnislosigkeit bei TRN ' + cFixedTAN_FName);
      end;
      DisConnect;
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

class function TJonDaExec.VormittagsStr(vormittags: boolean): string;
begin
  if vormittags then
    result := 'V'
  else
    result := 'N';
end;

function TJonDaExec.toProtokollFName(const mderec: TMdeRec; RemoteRev: single): string;
// Errechnet aus einem aktuellen MDEREC den jeweils gültigen
// Protokollnamen, es gibt ein Caching über sProtokolle
var
  k: integer;
  JonDaProtokoll: string;

  function _baustelle: string;
  begin
    result := Oem2asci(mderec.Baustelle);
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
        if FileExists(ProtokollPath(RemoteRev) + _baustelle + Art + cProtExtension) then
        begin
          result := _baustelle + Art;
          break;
        end;

        if FileExists(ProtokollPath(RemoteRev) + _baustelle + cProtExtension) then
        begin
          result := _baustelle;
          break;
        end;

        if FileExists(ProtokollPath(RemoteRev) + cProtPrefix + Art + cProtExtension) then
        begin
          result := cProtPrefix + Art;
          break;
        end;

        if FileExists(ProtokollPath(RemoteRev) + cProtPrefix + cProtExtension) then
        begin
          result := cProtPrefix;
          break;
        end;
      until true;

      if (result = cProtPrefix) and RevIsFrom(RemoteRev, cVersion_OrgaMonApp) then
      begin
        // Gibt es etwas passenderes aus der JonDa-Zeit
        JonDaProtokoll := toProtokollFName(mderec, cVersion_JonDa);
        if (JonDaProtokoll <> '') then
          if (JonDaProtokoll <> result) then
          begin
            // Autogen des Protokolles
            if migrateProtokoll(
              { } ProtokollPath(cVersion_JonDa) + JonDaProtokoll + cProtExtension,
              { } ProtokollPath(cVersion_OrgaMonApp) + JonDaProtokoll + cProtExtension) then
              result := JonDaProtokoll;
          end;
      end
      else
      begin
        result := AnsiUpperCase(result);
      end;
      sProtokolle.add(_baustelle + Art + cJondaProtokollDelimiter + result);

    end;
  end;
end;

class procedure TJonDaExec.toAnsi(var mderec: TMdeRec);
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

class function TJonDaExec.toBild(const mderec: TMdeRec): string;
// ACHTUNG: OEM-Zeichensatz beachten
// _ansi =             'üöäÜÖÄß';
// _oem  : string[7] = '”„š™Žá';

  function MVVFName: string;
  begin
    with mderec do
      result := Oem2asci(Zaehler_Strasse) + ' ' + Oem2asci(Zaehler_Ort);
    ersetze(' ', '_', result);
    result := StrFilter(result, cValidFNameChars + '_');
  end;

var
  Prefix: string;
begin
  with mderec do
  begin

    // Prefix: Initialisierungen
    repeat

      if (pos('CELL', Baustelle) = 1) then
      begin
        Prefix := Baustelle + '-';
        break;
      end;

      if (pos('MVHA', Baustelle) = 1) or
      { } (pos('OHG', Baustelle) = 1) or
      { } (pos('MVVW', Baustelle) = 1) then
      begin
        Prefix := MVVFName + '-';
        break;
      end;

      if (pos('RWTR', Baustelle) = 1) then
      begin
        Prefix := 'MaxAnzahl=12' + cProtokollTrenner;
        break;
      end;

      if (pos('ENW', Baustelle) = 1) then
      begin
        Prefix := 'MaxAnzahl=9' + cProtokollTrenner;
        break;
      end;

      if pos('SEWA Weskamp', Zaehler_Info) > 0 then
      begin
        Prefix := 'Weskamp-';
        break;
      end;

      if (pos('SEWA Hoehner', Zaehler_Info) > 0) or (pos('SEWA H”hner', Zaehler_Info) > 0) or
        (pos('SEWA Höhner', Zaehler_Info) > 0) then
      begin
        Prefix := 'Höhner-';
        break;
      end;

      if pos('SEWA Heupel', Zaehler_Info) > 0 then
      begin
        Prefix := 'Heupel-';
        break;
      end;

      Prefix := '';
    until true;

    // Prefix: zusätzliche Erweiterungen
    if (pos('Schrott', Zaehler_Info) > 0) then
      Prefix := Prefix + 'Schrott-';

    //

    // Format der 'Eingabe.???.txt'
    result := long2date(ausfuehren_ist_datum) + ';' + // 0
      secondstostr8(ausfuehren_ist_uhr) + ';' + // 1
      inttostr(RID) + ';' + // 2
      zaehlernummer_alt + ';' + // 3
      zaehlernummer_neu + ';' + // 4
      Prefix; // 5
  end;
end;

function TJonDaExec.isProd(pGeraeteNo: string; pRID: integer; pFertig: TANFiXDate): boolean;
begin
  result := true;
  if (pGeraeteNo > '299') then
    if (pFertig > cMonDa_ErsteEingabe) then
    begin
      repeat

        if (pFertig < 20080822) then
        begin
          // THGO + SWL
          // Testeingabe, die nicht berücksichtigt werden kann
          result := false;
          break;
        end;

        if (pRID >= 10657135) and (pRID <= 10755791) then
          if (pFertig < 20080829) then
          begin
            // THUA
            // Testeingabe, die nicht berücksichtigt werden kann
            result := false;
            break;
          end;

      until true;
    end;
end;

function TJonDaExec.isTest(pGeraeteNo: string; pRID: integer; pFertig: TANFiXDate): boolean;
begin
  result := not(isProd(pGeraeteNo, pRID, pFertig));
end;

procedure TJonDaExec.ClearStat;
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

constructor TJonDaExec.Create;
begin
  inherited Create;
  tIMEI := TsTable.Create;
  tIMEI_OK := TsTable.Create;
end;

destructor TJonDaExec.Destroy;
begin
  if assigned(sSendenLog) then
    sSendenLog.free;
  if assigned(sProtokolle) then
    sProtokolle.free;
  tIMEI_OK.free;
  tIMEI.free;

  inherited;
end;

procedure TJonDaExec.LogBilder(sBilder: TStringList; GeraeteID: string);
var
  Fname: string;
  oBilder: TStringList;
  oBilderSorted: TStringList;
  ClientSorter: TStringList;
  n, m: integer;
  WechselDatum: TANFiXDate;
  Stichtag: TANFiXDate;
  AutomataState: integer;
  NeueInfos: TgpIntegerList;
  NeuesBild: integer;
begin
  oBilder := TStringList.Create;
  oBilderSorted := TStringList.Create;
  ClientSorter := TStringList.Create;
  NeueInfos := TgpIntegerList.Create;

  // RIDs der neuen Bilder sammeln
  for n := 0 to pred(sBilder.count) do
    NeueInfos.add(strtointdef(nextp(sBilder[n], ';', 2), cRID_Null));
  NeueInfos.sort;

  Stichtag := DatePlus(DateGet, -cMaxAge_Foto);
  Fname := MyProgramPath + cStatistikPath + 'Eingabe.' + GeraeteID + '.txt';
  if FileExists(Fname) then
    oBilder.LoadFromFile(Fname);

  // Neu kommende Bilder erst mal rauslöschen!
  for n := pred(oBilder.count) downto 0 do
  begin
    NeuesBild := strtointdef(nextp(oBilder[n], ';', 2), cRID_Null);
    if NeuesBild > cRID_Null then
      if NeueInfos.IndexOf(NeuesBild) <> -1 then
        oBilder.Delete(n);
  end;

  oBilder.AddStrings(sBilder);
  for n := 0 to pred(oBilder.count) do
    ClientSorter.addobject(
      // Datum als JJJJMMTT
      inttostrN(Date2Long(nextp(oBilder[n], ';', 0)), 8) + '-' +
      // Uhrzeit (ist schon sortierfähig!)
      nextp(oBilder[n], ';', 1) + '-' +
      // RID im 3. Rang
      nextp(oBilder[n], ';', 2)

      , Pointer(n));
  ClientSorter.sort;

  AutomataState := 0;
  for n := 0 to pred(ClientSorter.count) do
  begin
    m := integer(ClientSorter.objects[n]);
    case AutomataState of
      0:
        begin
          WechselDatum := Date2Long(nextp(oBilder[m], ';', 0));
          if (WechselDatum >= Stichtag) then
          begin
            AutomataState := 1;
            oBilderSorted.add(oBilder[m]);
          end;
        end;
      1:
        begin
          oBilderSorted.add(oBilder[m]);
        end;
    end;
  end;

  RemoveDuplicates(oBilderSorted);
  oBilderSorted.SaveToFile(Fname);

  oBilder.free;
  oBilderSorted.free;
  ClientSorter.free;
  NeueInfos.free;
end;

// wie LogBilder jedoch werden keine Daten Überschrieben sondern nur
// fehlende Einträge nachgetragen!
procedure TJonDaExec.LogBilder2(sBilder: TStringList; GeraeteID: string);
var
  Fname: string;
  oBilder: TStringList;
  oBilderSorted: TStringList;
  ClientSorter: TStringList;
  n, m: integer;
  WechselDatum: TANFiXDate;
  Stichtag: TANFiXDate;
  AutomataState: integer;
  BisherInfos: TgpIntegerList;
  AUFTRAG_R: integer;
begin
  oBilder := TStringList.Create;
  oBilderSorted := TStringList.Create;
  ClientSorter := TStringList.Create;
  BisherInfos := TgpIntegerList.Create;

  Stichtag := DatePlus(DateGet, -cMaxAge_Foto);
  Fname := MyProgramPath + cStatistikPath + 'Eingabe.' + GeraeteID + '.txt';
  if FileExists(Fname) then
    oBilder.LoadFromFile(Fname);

  // RIDs der neuen Bilder sammeln
  for n := 0 to pred(oBilder.count) do
    BisherInfos.add(strtointdef(nextp(oBilder[n], ';', 2), cRID_Null));
  BisherInfos.sort;

  //
  for n := 0 to pred(sBilder.count) do
  begin
    AUFTRAG_R := strtointdef(nextp(sBilder[n], ';', 2), cRID_Null);
    if (BisherInfos.IndexOf(AUFTRAG_R) = -1) then
      oBilder.add(sBilder[n]);
  end;

  for n := 0 to pred(oBilder.count) do
    ClientSorter.addobject(
      // Datum als JJJJMMTT
      inttostrN(Date2Long(nextp(oBilder[n], ';', 0)), 8) + '-' +
      // Uhrzeit (ist schon sortierfähig!)
      nextp(oBilder[n], ';', 1), Pointer(n));
  ClientSorter.sort;

  AutomataState := 0;
  for n := 0 to pred(ClientSorter.count) do
  begin
    m := integer(ClientSorter.objects[n]);
    case AutomataState of
      0:
        begin
          WechselDatum := Date2Long(nextp(oBilder[m], ';', 0));
          if (WechselDatum >= Stichtag) then
          begin
            AutomataState := 1;
            oBilderSorted.add(oBilder[m]);
          end;
        end;
      1:
        begin
          oBilderSorted.add(oBilder[m]);
        end;
    end;
  end;

  RemoveDuplicates(oBilderSorted);
  oBilderSorted.SaveToFile(Fname);

  oBilder.free;
  oBilderSorted.free;
  ClientSorter.free;
  BisherInfos.free;
end;

function TJonDaExec.WebToMdeRecString(s: AnsiString): AnsiString;
begin
  result := ANSI2OEM(s);
  ersetze('*', '.', result);
end;

function TJonDaExec.MdeRec2Jonda(mderec: TMdeRec; RemoteRev: single): string;

  function toTargetCharset(s: string): string;
  begin
    result := OEM2Ansi(s);
  end;

  function GoodStr(s: string): string;
  begin
    result := toTargetCharset(cutblank(s));
    ersetze(';', cJondaProtokollDelimiter, result);
    ersetze('\', '', result);
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

function TJonDaExec.migrateProtokoll(OldFName, NewFName: string): boolean;

const
  cMigrationsVorlage_FName = 'JonDa-Migrationsprotokoll.txt';
  cRightBorder = '¦';

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

    sMigrationsVorlage.LoadFromFile(ProtokollPath(cVersion_OrgaMonApp) + cMigrationsVorlage_FName);

    // Einfüge Punkt suchen
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

    // Einfügen
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

function TJonDaExec.detectGeraeteNummer(sPath: string): string;
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

var
  DCP_blowfish1: TDCP_Blowfish = nil;
  CryptKeyLength: integer = 0;
  CryptKey: array [0 .. 1023] of AnsiChar;

procedure Crypt_Init;
const
  cApplicationNameOrgaMon = 'OrgaMon';
begin
  // Verschlüsselungs Namespace
  CryptKey := 'anfisoft' + cApplicationNameOrgaMon;
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

procedure validateBaustelleCSV(Fname: string);
var
  sBAUSTELLE: TsTable;
  cColumnIndex_NUMMERN_PREFIX: integer;
  r: integer;
  NUMMERN_PREFIX, _NUMMERN_PREFIX: string;
begin
  sBAUSTELLE := TsTable.Create;
  with sBAUSTELLE do
  begin
    InsertFromFile(Fname);
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
      SaveToFile(Fname);
  end;
  sBAUSTELLE.free;
end;

end.
