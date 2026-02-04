{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2016 - 2022  Andreas Filsinger
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
unit Identitaet;

interface

procedure setIdentitaetAndRun;

procedure connectOrgamon;

procedure RunAsApp;
procedure RunAsFoto;
procedure RunAsTWebShop;
procedure RunAsTagesabschluss;
procedure RunAsTagwache;
procedure RunAsMagneto;

implementation

uses
  // Pascal-Core
  SysUtils,
  Classes,
{$ifndef FPC}
  math,
{$endif}

  // Tools
  anfix,
  c7zip,
  CaretakerClient,
  WordIndex,
  srvXMLRPC,
  binlager,
  systemd,
  windows,

  // DB
{$IFNDEF FPC}
  IB_Session,
{$ENDIF}
  // OrgaMon-Globals
  globals,
  dbOrgaMon,
  eConnect,

  // OrgaMon-Core
  Funktionen_App,
  Funktionen_Auftrag,
  Funktionen_Basis,
  Funktionen_Artikel,
  Funktionen_Beleg,
  Funktionen_LokaleDaten,
  Funktionen_OLAP,
  Funktionen_Buch,

  // Service
  TestExec;

type
  TIndentitaet = (id_TWebShop,
                  id_Mail,
                  id_Druck,
                  id_App,
                  id_Foto,
                  id_Test,
                  id_Tagesabschluss,
                  id_Tagwache,
                  id_Magneto,
                  id_Help);

var
  Ident: TIndentitaet;
  Modus: string;
  ForceRev: single;

procedure connectOrgamon;
var
  l, k: integer;
begin
  with dbOrgaMon.fbConnection do
  begin

    if IsParam('-al') then
    begin
      writeln('WARNING: DebugMode @' + DiagnosePath);
      DebugMode := true;
      DebugLogPath := globals.DiagnosePath;
    end;

    // patch iDataBaseName to help to avoid
    if IsParam('-cl') then
    begin
      if (pos(ComputerName + ':', iDataBaseName)=1) or
         (ComputerName=iDataBaseHost) then
      begin
        iDataBaseName := copy(iDataBaseName, succ(pos(':', iDataBaseName)), MaxInt);
        writeln('INFO: i run on the same machine as the database-server -> trying to avoid TCP connection ...');
      end;
    end else
    begin
      if (pos(ComputerName + ':', iDataBaseName)=1) or
         (ComputerName=iDataBaseHost) then
      begin
        iDataBaseName := 'localhost' + copy(iDataBaseName, pos(':', iDataBaseName), MaxInt);
        writeln('INFO: i run on the same machine as the database-server -> trying to establish a tcp-connection to localhost:  ...');
      end;
    end;

    if (i_c_DataBaseHost <> '') then
      i_c_DataBaseFName := copy(iDataBaseName, succ(pos(':', iDataBaseName)), MaxInt)
    else
      i_c_DataBaseFName := iDataBaseName;

    i_c_DataBasePath := i_c_DataBaseFName;
    l := revpos('.', i_c_DataBasePath);
    k := max(revpos('\', i_c_DataBasePath), revpos('/', i_c_DataBasePath));
    if (k > 0) then
    begin
      i_c_DataBasePath := copy(i_c_DataBaseFName, 1, k);
      MandantName := copy(i_c_DataBaseFName, succ(k), pred(l - k));
    end;

{$IFDEF fpc}
    protocol := 'firebird';
    ClientCodePage := '';
    User := iDataBaseUser;
    HostName := i_c_DataBaseHost;
    Database := i_c_DataBaseFName;
{$ELSE}
    DataBaseName := iDataBaseName;
    write('DB-Protokoll ... ');
    if (i_c_DataBaseHost = '') then
    begin
      Server := '';
      protocol := cplocal;
      writeln('LOCAL!');
    end
    else
    begin
      protocol := cpTCP_IP;
      writeln('TCP!');
    end;
    UserName := iDataBaseUser;
{$ENDIF}
    Password := deCrypt_Hex(iDataBasePassword);
    if (iDataBaseName = '') then
    begin
      writeln('ERROR: DataBaseName= ist leer');
      halt;
    end;

    writeln(e_r_fbClientVersion);
    write(anfix.UserName + ' oeffnet ' + string(UserName) + '@' + string(iDataBaseName) + ' ... ');
    Connect;
    if not(Connected) then
    begin
      writeln('ERROR: DataBase.connect erfolglos');
      halt;
    end;
    MachineIDChanged;
  end;

  sBearbeiter := e_r_Bearbeiter;
  if (sBearbeiter < cRID_FirstValid) then
  begin
    writeln(cERRORText + ' Bearbeiter "' + anfix.UserName + '" ist noch nicht angelegt!');
    halt(1);
  end;
  sBearbeiterKurz :=
   { } e_r_BearbeiterKuerzel(sBearbeiter) + '@' +
   { } e_r_Kontext;

  writeln(cOKText);

  // Aktueller Versionszwang?
  ForceRev := e_r_Revision_Zwang;
  if (ForceRev > 8.0) then
    if (RevAsInteger(globals.version) <> RevAsInteger(ForceRev)) then
    begin
      writeln(
        { } cERRORText +
        { } ' Es besteht Versionszwang zu Rev. ' +
        { } RevToStr(ForceRev) + '!');
      halt(1);
    end;

  // Systemparameter ermitteln
  e_r_LadeParameter;
  AllSystemsRunning := true;
end;

type
  TownFotoExec = class(TOrgaMonApp)
    procedure FotoLog(s: string); override;

  end;

  { TownFotoExec }

procedure TownFotoExec.FotoLog(s: string);
begin
  if (s<>'') then
    writeln(s);

  AppendStringsToFile(
    { } sTimeStamp + ';' +
    { } inttostr(AUFTRAG_R) + ';' +
    { } s,
    { } DiagnosePath + cFotoLogFName);

  if (pos(cFotoService_AbortTag, s) = 1) then
    halt(1);
end;

procedure RunAsFoto;
const
  cWorker_Intervall = 4 * 1000; // alle 4 Sekunden nach Arbeit sehen
  cSleep_Intervall = 20 * 1000; // wenn Pausiert 20 Sekunden nichts tun
  cProceed_Intervall = 2 * 1000; // wenn proceed-Läuft 2 Sekunden warten
  cNews_Intervall = 5 * 60 * 1000; // so oft werden "Neu" Umbenennungen durchgeführt
var
  MyFotoExec: TownFotoExec;
  TimerWartend: integer;
  BackupSizeByNow: double;
  SectionName: string;
  ProceedLogged: boolean;
begin
  MyFotoExec := TownFotoExec.Create;
  with MyFotoExec do
  begin
    Option_Console := true;
    ProceedLogged := false;

    SectionName := getParam('Id');
    readIni(SectionName);
    DiagnosePath := pLogPath;

    // Startup
    FotoLog(cINFOText + ' FotoService Rev. ' + RevToStr(version));

    // 7zip Installation ist erforderlich
    ensure7zip;

    // DebugMode?
    if IsParam('-al') then
    begin
      FotoLog('DebugMode @' + DiagnosePath);
      DebugMode := true;
      DebugLogPath := DiagnosePath;
    end;

    write('Lade Tabelle '+cLICENCE_FName+' ... ');
    with tIMEI do
    begin
      oSalt := SectionName;
      insertfromHash(DataPath, cLICENCE_FName);
      writeln(inttostr(RowCount));
    end;

    // Server direkt durchstarten?
    TimerWartend := 0;

    while true do
    begin

      // Ist die Verarbeitung im Moment pausiert
      if Pause then
      begin
        FotoLog('Pausiert ...');
        ReleaseGlobals;
        sleep(cSleep_Intervall);
        // Nach der Pause IMMER erst Bilder abholen
        TimerWartend := 0;
        continue;
      end;

      if FileExists(pAppServicePath + cAppService_Proceed) then
      begin
        if not(ProceedLogged) then
        begin
         FotoLog('Warte auf Ende von "Proceed" ...');
         ProceedLogged := true;
        end;

        sleep(cProceed_Intervall);
        inc(TimerWartend, cProceed_Intervall);
        if (TimerWartend >= cNews_Intervall) then
        begin
         FotoLog('Breche Warten auf "Proceed"-Ende ab ...');
         FileDelete(pAppServicePath + cAppService_Proceed);
         ProceedLogged := false;
        end;
        continue;
      end;
      ProceedLogged := false;

      // Alle 5 Min:
      if (TimerWartend >= cNews_Intervall) then
      begin
        TimerWartend := 0;

        try
          // Ab und zu die neuen Daten beachten
          ReleaseGlobals;
        except
          on E: Exception do
            FotoLog(cERRORText + ' 271:' + E.ClassName + ': ' + E.Message);
        end;

        try
          // Wartende verarbeiten
          workWartend;
        except
          on E: Exception do
            FotoLog(cERRORText + ' 279:' + E.ClassName + ': ' + E.Message);
        end;

        try
          // Status Seite neu bearbeiten
          workAusstehendeFotos;
        except
          on E: Exception do
            FotoLog(cERRORText + ' 287:' + E.ClassName + ': ' + E.Message);
        end;

        // Zwischen "00:00 h" und ]"01:00 h" (=eine Stunde lang prüfen!)
        if (SecondsGet < (1 * 3600)) then
          // nur machen, wenn nicht in Arbeit oder bereits fertig
          if not(FileExists(AblageLogFname)) then
          begin

            try
              workAblage;
            except
              on E: Exception do
                FotoLog(cERRORText + ' 300:' + E.ClassName + ': ' + E.Message);
            end;

            BackupSizeByNow := 0.0;
            try
              BackupSizeByNow := doBackup;
            except
              on E: Exception do
                FotoLog(cERRORText + ' 307:' + E.ClassName + ': ' + E.Message);
            end;

            FotoLog(cINFOText + format(' %s hat %.3f GB', [BackupDir, BackupSizeByNow / 1024.0 / 1024.0 /
              1024.0]));

            if (BackupSizeByNow>3800.0*1024.0*1024.0) then
            begin
             CheckCreateDir(nextBackupDir);
             if DirExists(nextBackupDir) then
               FotoLog(cINFOText + ' nächstes Backupverzeichnis ('+nextBackupDir+') erstellt')
             else
               FotoLog(cERRORText + ' 357: konnte Verzeichnis ' + nextBackupDir + ' nicht erstellen');
            end;

          end;
      end;

      try
        workEingang_JPG;
      except
        on E: Exception do
          FotoLog(cERRORText + ' 385:' + E.ClassName + ': ' + E.Message);
      end;

      try
        workEingang_TXT;
      except
        on E: Exception do
          FotoLog(cERRORText + ' 392:' + E.ClassName + ': ' + E.Message);
      end;

      sleep(cWorker_Intervall);
      inc(TimerWartend, cWorker_Intervall);
    end;
  end;
end;

procedure RunAsTagesabschluss;
var
 TimeDiff: TANFiXTime;
 TagesAbschluss_TAN : integer;
 LetzerTagesAbschlussWarAm : TAnfixDate;
 LetzerTagesAbschlussWarUm : TAnfixTime;
 ErrorCount: Integer;
 sAktions: TSTringList;
 n : Integer;
 TagesabschlussLogFName : String;

  procedure Log(s: string);
  begin
    try
      writeln(s);
      AppendStringsToFile(s, TagesabschlussLogFName);
      if (pos(cERRORText, s) > 0) then
         AppendStringsToFile(s, ErrorFName('TAGESABSCHLUSS'), Uhr8);
      if (pos(cFotoService_AbortTag, s) = 1) then
        halt(1);
    except
      // nichts tun!
    end;
  end;

begin
  TagesAbschluss_TAN := e_w_GEN('GEN_BACKUP');
  TagesabschlussLogFName := DiagnosePath + 'Tagesabschluss-' + inttostrN(TagesAbschluss_TAN, 8) + '.log.txt';
  writeln('Tagesabschluss-Log ... ' + TagesabschlussLogFName);
  LetzerTagesAbschlussWarAm := DateGet;
  LetzerTagesAbschlussWarUm := SecondsGet;
  Log(
   {} 'Start am ' + long2date(LetzerTagesAbschlussWarAm) +
   {} ' um ' + secondstostr(LetzerTagesAbschlussWarUm) +
   {} ' h auf ' + ComputerName);
  ErrorCount := 0;

  sAktions:= TStringList.create;
  with sAktions do
  begin
    add('Datensicherung Datenbank');
    add('Datensicherung Gesamtsystem');
    add('Dateiverzeichnisse aufräumen');
    add('Paket-IDs ermitteln');
    add('Tagesabschluss.*.OLAP.txt ausführen');
    add('Replikation mit einer anderen Datenbank');
    add('Monda empfangen/senden');
    add('Auftrag Extern aufbereiten');
    add('Webshop Extern Datenbank upload');
    add('Webshop Medien upload');
    add('HBCI-Konten: Umsatzabfrage');
    add('Diverse Caching Elemente neu erzeugen');
    add('Auftrag Speed Suche neu erzeugen');
    add('Verkaufsrang berechnen');
    add('Lieferzeit berechnen');
    add('Personen Speed Suche neu erzeugen');
    add('CMS Katalog neu erstellen');
    add('Musiker Speed Suche neu erzeugen');
    add('Tier Speed Suche neu erzeugen');
    add('Artikel Speed Suche im Belege Fenster neu erzeugen');
    add('DMO und PRO Mengen setzen');
    add('Freigebbare Lagerplätze freigeben');
    add('ausgeglichene Belege löschen');
    add('Mahnliste erstellen');
    add('Verträge anwenden');
    add('Abgleich Server Zeitgeber <-> Lokaler Zeitgeber');
  end;

  for n := 0 to pred(sAktions.Count) do
  begin

        if (pos(','+IntToStr(succ(n))+',',iTagesabschlussAusschluss)>0) then
        begin
          Log( { } 'Ausschluss Aktion "' +
               { } sAktions[n] + '"');
          continue;
        end;

        try
          case n of
           3,5,8,9,16,20,23:
             begin
               Log( { } 'keine Aktion "' +
                 { } sAktions[n] + '"');
             end;
          else
            Log( { } 'Beginne Aktion "' +
              { } sAktions[n] + '" um ' +
              { } secondstostr(SecondsGet) + ' h');
          end;

          case n of
            0:
              if not(SicherungDatenbank(TagesAbschluss_TAN)) then
                raise Exception.Create('Datenbanksicherung erfolglos');
            1:
              begin
                // normale Gesamt-Sicherung
                if (iSicherungenAnzahl <> cIni_DeActivate) then
                  if not(SicherungDateisystem(TagesAbschluss_TAN)) then
                    raise Exception.Create('Gesamtsicherung erfolglos');
              end;
            2:
              begin
                // Dateien verschieben, die zu lange ausser Gebrauch sind!
                (*

                if iAblage then
                  FormDatensicherung.do400(TagesAbschluss_TAN)
                else
                  FormDatensicherung.die400.Free;
                *)

                // Datei-Löschungen
                FileDelete(DiagnosePath + '*', 20);
                FileDelete(MyProgramPath + 'Bestellungskopie\*', 30);
                FileDelete(UpdatePath + '*', 30, 3);
                FileDelete(WordPath + '*.csv', 10);
                FileDelete(WordPath + '*.html', 10);
                FileDelete(MyProgramPath + cRechnungsKopiePath + '*', 90);
                if (iSchnelleRechnung_PERSON_R >= cRID_FirstValid) then
                  FilesLimit(
                    { } cPersonPath(iSchnelleRechnung_PERSON_R) + '*' +
                    { } cHTMLextension, 2000, 1500);

                FileDelete(DatensicherungPath + '*', 3, 3);
                FileDelete(WebPath + '*', 10);
                FileDelete(cAuftragErgebnisPath + '*', 5);
                FileDelete(SearchDir + '*', 400);

                // Verzeichnis Löschungen
                DirDelete(ImportePath + '*', 10);
                KartenQuota;

              end;
            3: begin
(*               FormVersenderPaketID.Execute; *)

            end;

            4:
              begin
                // sich selbst enthaltende Kollektionen löschen!
                e_x_sql('delete from ARTIKEL_MITGLIED where (MASTER_R=ARTIKEL_R)');

                // verwaiste Anschriften löschen
                e_x_sql('delete from ANSCHRIFT where'+
                 {} ' (RID not in (select PRIV_ANSCHRIFT_R from PERSON where PRIV_ANSCHRIFT_R is not null)) and'+
                 {} ' (RID not in (select GESCH_ANSCHRIFT_R from PERSON where GESCH_ANSCHRIFT_R is not null))');

                // CLUB$ Tabellen löschen
                TdboClub.drop;

                // Context-OLAPs
                e_x_OLAP(iSystemOLAPPath + 'Tagesabschluss.*' + cOLAPExtension);

              end;
            5:
              begin (*
                if iReplikation then
                  FormReplikation.Execute; *)
              end;
            6:
              begin
                e_w_ReadMobil;
                e_w_WriteMobil;
              end;
            7:
              begin
                // Für den Foto Server
                e_r_Sync_AuftraegeAlle;
               (*
                // Für externe Auftrags-Routen
                if not(FormAuftragExtern.DoJob) then
                  Log(cERRORText + ' AuftragExtern fail'); *)
              end;
            8: begin
(*
              if (iShopKey <> '') then
                if not(FormWebShopConnector.doMediumBuilder) then
                  Log(cERRORText + ' Medium Upload fail');
*)
            end;
            9: begin
(*

              if (iShopKey <> '') then
                if not(FormWebShopConnector.doContenBuilder) then
                  Log(cERRORText + ' Content Upload fail');
*)
            end;
            10: begin
              if (iKontenHBCI <> '') then
                b_w_KontoSync(iKontenHBCI);
            end;
            11:
              ReBuild;
            12: begin
              AuftragSuchindex;
                 end;
            13: begin
              if iTagesabschlussRang then
                e_d_Rang;
                end;
            14: begin
              e_d_Lieferzeit;
            end;
            15: begin
              PersonSuchindex;
            end;
            16: begin
(*
              FormCreatorMain.CreateSearchIndex;
*)
              end;
            17:begin
              MusikerSuchIndex;
            end;
            18: begin
              TierSuchIndex;
                end;
            19: begin
             ArtikelSuchIndex;
             end;
            20:
              begin
(*
                FormNatuerlicheResourcen.Execute;
*)
              end;
            21: begin
              e_w_LagerFreigeben;
               end;
            22:
              begin
                e_x_BelegAusPOS;
                e_d_Belege;
              end;
            23: begin
(*
              if iMahnlaufbeiTagesabschluss then
              begin
                if e_w_NeuerMahnlauf then
                begin
                  if not(FormMahnung.Execute(TagesAbschluss_TAN)) then
                    Log(cERRORText + ' kein neuer Mahnlauf möglich, da noch Fehler abgearbeitet werden müssen!');
                end
                else
                  Log(cERRORText + ' kein neuer Mahnlauf möglich, da noch teilweise "Brief" angekreuzt ist!');
              end;
*)
               end;
            24:
              e_w_VertragBuchen;
            25:
              begin
                TimeDiff := r_Local_vs_Server_TimeDifference;
                repeat
                  if (TimeDiff<=10) then
                   break;

                  if (TimeDiff<=25) then
                  begin
                  Log(cWARNINGText + format(' Abweichung der lokalen Zeit zu der des DB-Servers ist %d Sekunde(n)!',
                    [TimeDiff]));
                    break;
                  end;

                  Log(cERRORText + format(' Abweichung der lokalen Zeit zu der des DB-Servers ist %d Sekunde(n)!',
                    [TimeDiff]));

                until yet;
              end;
          end;
        except
          on e: Exception do
          begin
            inc(ErrorCount);
            Log(cERRORText + ' Tagesabschluss Exception ' + e.message);
          end;
        end;

        if (ErrorCount > 0) then
          break;
  end;
  if (ErrorCount > 0) then
    Log(cERRORText + ' Tagesabschluss FAIL at Stage ' + inttostr(n));

  Log('Ende um ' + secondstostr(SecondsGet) + ' h');
  e_x_OLAP(iSystemOLAPPath + 'System.Tagesabschluss.*' + cOLAPExtension);
  sAktions.Free;
end;

procedure RunAsTagwache;
var
 sAktions: TStringList;
 LetzteTagwacheWarAm: TAnfixDate;
 LetzteTagwacheWarUm: TAnfixTime;
 Tagwache_TAN : integer;
 ErrorCount: Integer;
 n, ActionNo : Integer;

 procedure Log(s: string);
 begin
    try
      writeln(s);
      AppendStringsToFile(s, DiagnosePath + 'Tagwache-' + inttostrN(Tagwache_TAN, 8) + '.log.txt');
      if (pos(cERRORText, s) > 0) then
         AppendStringsToFile(s, ErrorFName('TAGWACHE'), Uhr8);
      if (pos(cFotoService_AbortTag, s) = 1) then
        halt(1);
    except
      // nichts tun!
    end;
 end;

begin
  LetzteTagwacheWarAm := DateGet;
  LetzteTagwacheWarUm := SecondsGet;
  Tagwache_TAN := e_w_gen('GEN_TAGWACHE');
  ErrorCount := 0;
  ActionNo := -1;
  Log('Start am ' + long2date(LetzteTagwacheWarAm) + ' um ' + secondstostr(LetzteTagwacheWarUm) + ' h auf ' +
      ComputerName);

  sAktions := TStringList.create;
  with sAktions do
  begin
    add('Fotos laden');
    add('Mobil auslesen');
    add('Sync mit dem Fotoserver');
    add('Auftrag Ergebnis');
    add('Automatischer Import');
    add('Mobil schreiben');
    add('Tagwache OLAPs ausführen');
  end;
  for n := 0 to pred(sAktions.Count) do
  begin

    if (pos(','+IntToStr(succ(n))+',',iTagwacheAusschluss)>0) then
    begin
      Log( { } 'Ausschluss Aktion "' +
           { } sAktions[n] + '"');
      continue;
    end;

    Log( { } 'Beginne Aktion "' +
      { } sAktions[n] + '" um ' +
      { } secondstostr(SecondsGet) + ' h');
    ActionNo := n;
    try
       case ActionNo of
          0: e_w_FotoDownload;
          1: e_w_ReadMobil;
          2: e_r_Sync_AuftraegeAlle;
          3: e_w_Ergebnis(cRID_Unset);
          4: if (iTagwacheBaustelle >= cRID_FirstValid) then
             begin
                inc(ErrorCount);
                 repeat
                   if not(e_w_BaustelleAblegen(iTagwacheBaustelle)) then
                    break;
                   if not(e_w_BaustelleLoeschen(iTagwacheBaustelle)) then
                    break;
                   if not(e_r_Bewegungen) then
                    break;
                   if not(e_w_Import(iTagwacheBaustelle)) then
                    break;
                   dec(ErrorCount);
                 until yet;
             end;
          5: e_w_WriteMobil;
          6: e_x_OLAP(iSystemOLAPPath + 'Tagwache.*' + cOLAPExtension);
       end;
     except
          on e: Exception do
          begin
            inc(ErrorCount);
            Log(cERRORText + ' Tagwache Exception ' + e.message);
          end;
     end;
   end;
  if (ErrorCount > 0) then
    Log(cERRORText + ' Tagwache FAIL at Stage ' + inttostr(ActionNo));
  Log('Ende um ' + secondstostr(SecondsGet) + ' h');

  // Tagwache-OLAPs ausführen
  e_x_OLAP(iSystemOLAPPath + 'System.Tagwache.*' + cOLAPExtension);
  sAktions.Free;
end;

procedure RunAsTWebShop;
var
  UsedPort: Word;
  XMethods: TeConnect;
  XServer: TXMLRPC_Server;
  BasePlug: TStringList;
begin

  // Caching Objekte voraktivieren
  write('Cache ');
  e_r_Preis_ensureCache;
  write('.');
  e_r_PreisTabelle_ensureCache;
  write('.');
  e_r_SortimentSatz_EnsureCache;
  write('.');
  e_r_PreisNativ_ensureCache;
  writeln(' OK');

  // Vorrangig über den "--Port=nnnnn" Parameter
  UsedPort := StrToIntDef(getParam('port'), 0);
  if (UsedPort=0) then
    UsedPort := StrToIntDef(iXMLRPCPort, 3040);

  XMethods := TeConnect.Create;
  XMethods.Init;
  XServer := TXMLRPC_Server.Create(nil);
  with XServer do
  begin
    // Init

    // Listen-Port des Servers setzen
    DefaultPort := UsedPort;
    // iXMLRPCPort muss aber auch entsprechende gesetzt sein!
    iXMLRPCPort := inttostr(UsedPort);

    DebugMode := anfix.DebugMode;
    DiagnosePath := globals.DiagnosePath;
    TimingStats := IsParam('-at');
    LogContext := ComputerName + '-' + inttostr(DefaultPort);

    if TimingStats then
      writeln('Performance-Log aktiv: ' + LogContext);

    // TWebShop
    AddMethod('ArtikelSuche', XMethods.rpc_e_r_ArtikelSuche);
    AddMethod('ArtikelPreis', XMethods.rpc_e_r_ArtikelPreis);
    AddMethod('KontoInfo', XMethods.rpc_e_r_KontoInfo);
    AddMethod('BestellInfo', XMethods.rpc_e_r_BestellInfo);
    AddMethod('Land', XMethods.rpc_e_r_Land);
    AddMethod('Bestellen', XMethods.rpc_e_w_Bestellen);
    AddMethod('Vormerken', XMethods.rpc_e_w_Vormerken);
    AddMethod('Buchen', XMethods.rpc_e_w_Buchen);
    AddMethod('ArtikelVersendetag', XMethods.rpc_e_r_ArtikelVersendetag);
    AddMethod('Verlag', XMethods.rpc_e_r_Verlag);
    AddMethod('Versandkosten', XMethods.rpc_e_r_Versandkosten);
    AddMethod('ArtikelInfo', XMethods.rpc_e_r_ArtikelInfo);
    AddMethod('BasePlug', XMethods.rpc_e_r_BasePlug);
    AddMethod('ArtikelRabattPreis', XMethods.rpc_e_r_ArtikelRabattPreis);
    AddMethod('PersonNeu', XMethods.rpc_e_w_PersonNeu);
    AddMethod('Ort', XMethods.rpc_e_r_Ort);
    AddMethod('Rabatt', XMethods.rpc_e_r_Rabatt);
    AddMethod('Preis', XMethods.rpc_e_r_Preis);
    AddMethod('Miniscore', XMethods.rpc_e_w_Miniscore);
    AddMethod('LoginInfo', XMethods.rpc_e_w_LoginInfo);
    AddMethod('NextVal', XMethods.rpc_e_w_NextVal);
    AddMethod('Senden', XMethods.rpc_e_w_Senden);

    // Starten
    BasePlug := e_r_BasePlug;
    write(
      { } 'Starte ' +
      { } ComputerName + ':' + iXMLRPCPort +
      { } ' im Kontext ' +
      { } BasePlug[25] + ' ... ');
    BasePlug.free;
    active := true;
    writeln(cOKText);

  end;

  // if DebugHook = 0 then
  while true do
    sleep(1000);

end;

procedure RunAsUnImplemented;
begin

end;

procedure RunAsApp;
var
  XMLRPC: TXMLRPC_Server;
  JonDa: TOrgaMonApp;
  SectionName: string;
begin

  try
    // Create App Services
    JonDa := TOrgaMonApp.Create;
    with JonDa do
    begin
      Option_Console := true;
      SectionName := getParam('Id');
      readIni(SectionName);
      DiagnosePath := pLogPath;

      write('Lade Tabelle '+cLICENCE_FName+' ... ');
      with tIMEI do
      begin
        oSalt := SectionName;
        insertfromHash(DataPath, cLICENCE_FName);
        writeln(inttostr(RowCount));
      end;

      write('Lade Tabelle '+cIMEI_OK_FName+' ... ');
      with tIMEI_OK do
      begin
        oSalt := SectionName;
        insertfromHash(DataPath, cIMEI_OK_FName);
        writeln(inttostr(RowCount));
      end;

      // Vertragsdaten ausgeben
      maintainVERTRAG;

      // Log den Neustart
      BeginAction('Start ' + cApplicationName + ' Rev. ' + RevToStr(globals.version) + ' [' + SectionName + ']');
    end;

    // DebugMode?
    if IsParam('-al') then
    begin
      writeln('DebugMode @' + DiagnosePath);
      DebugMode := true;
      DebugLogPath := DiagnosePath;
    end;

    repeat

      // Disable Abschluss ?!
      write('Abschluss ... ');
      if not(IsParam('-da')) then
      begin

        // Binäres Auftragslager
        JonDa.doAbschluss;
        writeln('OK');

        write('Auftragsdaten ... ');
        FileCopy(
          { } MyProgramPath + cServerDataPath + 'AUFTRAG+TS' + cBL_FileExtension,
          { } JonDa.DataPath + 'AUFTRAG+TS' + cBL_FileExtension);
        writeln('OK');

      end
      else
      begin
        writeln('SKIP');
      end;

      // Erstelle den Dienst
      XMLRPC := TXMLRPC_Server.Create(nil);
      with XMLRPC do
      begin
        DefaultPort := JonDa.pPort;
        DiagnosePath := globals.DiagnosePath;
        LogContext := ComputerName + '-' + inttostr(DefaultPort);

        DebugMode := anfix.DebugMode;
        TimingStats := IsParam('-at');
        // Verbrauchte Zeit pro XMLRPC
        if TimingStats then
          writeln('TimingStatistics @' + DiagnosePath);

        // Methoden registrieren
        AddMethod('BasePlug', JonDa.info);
        AddMethod('StartTAN', JonDa.start);
        AddMethod('ProceedTAN', JonDa.proceed);

        // Starten
        write('Aktiviere ' + ComputerName + ':' + inttostr(DefaultPort) + '  ... ');
        active := true;

        writeln('OK');
      end;

      // Aktueller Stand
      writeln('TAN-Vergabe steht bei ... ' + JonDa.NewTrn(false));

      // Arbeite ...
      while true do
        sleep(1000);
      XMLRPC.free;

    until yet;
    JonDa.free;
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;
end;

procedure setIdentitaetAndRun;
begin
  // Bestimmen in welchem Modus das Programm laufen soll
  Ident := id_TWebShop;
  repeat
    if IsParam('--help') then
    begin
      Ident := id_Help;
      break;
    end;
    if IsParam('--mail') then
    begin
      Ident := id_Mail;
      break;
    end;
    if IsParam('--print') then
    begin
      Ident := id_Druck;
      break;
    end;
    if IsParam('--app') then
    begin
      Ident := id_App;
      break;
    end;
    if IsParam('--foto') then
    begin
      Ident := id_Foto;
      break;
    end;
    if IsParam('--test*') then
    begin
      Ident := id_Test;
      break;
    end;
    if IsParam('--tagesabschluss') then
    begin
      Ident := id_Tagesabschluss;
      break;
    end;
    if IsParam('--tagwache') then
    begin
      Ident := id_Tagwache;
      break;
    end;
    if IsParam('--magneto') then
    begin
      Ident := id_Magneto;
      break;
    end;
  until yet;

  // Ident- String
  case Ident of
    id_TWebShop:
      Modus := 'TWebShop-Server'; // XMLRPC-Server für den TWebshop
    id_Mail:
      Modus := 'MAIL-Server';
    id_Druck:
      Modus := 'PRINT-Server';
    id_App:
      Modus := 'App-Service'; // XMLRPC-Server für die OrgaMon-App (up.php)
    id_Foto:
      Modus := 'Foto-Service'; // Foto Dienst für die OrgaMon App
    id_Test:
      Modus := 'Test-Service'; // vollführt Testszenarien
    id_Tagesabschluss:
      Modus := 'Tagesabschluss';
    id_Tagwache:
      Modus := 'Tagwache';
    id_Magneto:
      Modus := 'Magento';
    id_Help:
      Modus := 'Hilfe';
  end;

  try
    //
    if not(IsParam('-dl')) then
    begin
      {$ifdef fpc}
      writeln('┌─────────────────────────────────────────────────┐');
      writeln('│   _  ___                  __  __                │');
      writeln('│  | |/ _ \ _ __ __ _  __ _|  \/  | ___  _ __     │');
      writeln('│  | | | | | ''__/ _` |/ _` | |\/| |/ _ \| ''_ \    │');
      writeln('│  | | |_| | | | (_| | (_| | |  | | (_) | | | |   │');
      writeln('│  |_|\___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|   │');
      {$ifdef windows}
      writeln('│    Rev. ' + RevToStr(globals.version) + ' |___/          win64              │');
      {$else windows}
      writeln('│    Rev. ' + RevToStr(globals.version) + ' |___/          linux              │');
      {$endif windows}
      writeln('│                                                 │');
      writeln('└─────────────────────────────────────────────────┘');
      writeln(' ');
      {$else fpc}
      writeln('/---------------------------------------------------\');
      writeln('|         ___                  __  __               |');
      writeln('|    ___ / _ \ _ __ __ _  __ _|  \/  | ___  _ __    |');
      writeln('|   / __| | | | ''__/ _` |/ _` | |\/| |/ _ \| ''_ \   |');
      writeln('|  | (__| |_| | | | (_| | (_| | |  | | (_) | | | |  |');
      writeln('|   \___|\___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|  |');
      writeln('|    Rev. ' + RevToStr(globals.version) + '    |___/       win32                |');
      writeln('\---------------------------------------------------/');
      writeln(' ');
      {$endif fpc}
    end;
    writeln(
     {} Modus + '@' + noblank(Betriebssystem) + ' ' +
     {} iMandant +
     {} ' (' + MyProgramPath + ')');

    if IsParam('--version') then
     halt;

    case Ident of
      id_TWebShop:
        begin
          connectOrgamon;
          RunAsTWebShop;
        end;
      id_Tagesabschluss:
        begin
          connectOrgamon;
          RunAsTagesabschluss;
        end;
      id_Tagwache:
        begin
          connectOrgamon;
          RunAsTagwache;
        end;
      id_App:
        begin
          RunAsApp;
        end;
      id_Foto:
        begin
          RunAsFoto;
        end;
      id_Magneto:
        begin
          RunAsMagneto;
        end;
      id_Test:
        begin
          RunAsTest;
        end;
      id_Help:
        begin
          write('check '+EigeneOrgaMonDateienPfad+' ... ');
          repeat
           if DirExists(EigeneOrgaMonDateienPfad) then
           begin
             writeln('OK!');
             break;
           end;
           CheckCreateDir(EigeneOrgaMonDateienPfad);
           if DirExists(EigeneOrgaMonDateienPfad) then
           begin
             writeln('CREATED!');
             break;
           end else
           begin
             writeln('FAIL!');
             break;
           end;
          until yet;
          writeln('https://wiki.orgamon.org/index.php?title=cOrgaMon');
        end
    else
      RunAsUnImplemented;
    end;

  except
    on E: Exception do
      writeln(cERRORText + E.ClassName, ': ', E.Message);
  end;
  writeln('¯\_(ツ)_/¯');
  writeln(' ');
  writeln(' ');
  if (Ident=Id_Test) then
   readln;
end;

type
 TMagneto = class(TObject)
 public
   function rpc_e_w_Magneto(sParameter: TStringList): TStringList;
 end;

function TMagneto.rpc_e_w_Magneto(sParameter: TStringList): TStringList;
var
 OK : boolean;
begin
  result := TStringList.create;
  // Batch-File that do this
  write('ONOFF ... ');
  OK := (CallExternalApp('C:\Program Files\USB\bin-Win64\ONOFF.bat', SW_HIDE)<2);
  with TXMLRPC_Server do
    result.AddObject(fromboolean(OK), oBoolean);
  writeln('OK');
end;

procedure RunAsMagneto;
var
  XMLRPC: TXMLRPC_Server;
  Magneto : TMagneto;
begin
  // Erstelle den Dienst
  Magneto := TMagneto.create;
  XMLRPC := TXMLRPC_Server.Create(nil);
  with XMLRPC do
  begin
    // Vorrangig über den "--Port=nnnnn" Parameter
    DefaultPort := StrToIntDef(getParam('port'), 0);
    if (DefaultPort=0) then
      DefaultPort := 3040;

    DiagnosePath := globals.DiagnosePath;
    LogContext := ComputerName + '-' + inttostr(DefaultPort);

    DebugMode := anfix.DebugMode;
    TimingStats := IsParam('-at');
    // Verbrauchte Zeit pro XMLRPC
    if TimingStats then
      writeln('TimingStatistics @' + DiagnosePath);

    // Methoden registrieren
    AddMethod('Open', Magneto.rpc_e_w_Magneto);

    // Starten
    write('Aktiviere ' + ComputerName + ':' + inttostr(DefaultPort) + '  ... ');
    active := true;
    writeln('OK');
  end;

  // Arbeite ...
  while true do
    sleep(1000);
  XMLRPC.free;
  Magneto.Free;
end;

end.
