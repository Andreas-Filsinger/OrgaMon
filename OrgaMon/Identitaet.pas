{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2016  Andreas Filsinger
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
unit Identitaet;

interface

procedure setIdentitaetAndRun;

procedure connectOrgamon;

procedure RunAsApp;
procedure RunAsFoto;
procedure RunAsOrder;
procedure RunAsTWebShop;
procedure RunAsTagesabschluss;
procedure RunAsTagwache;

implementation

uses
  // Pascal-Core
  SysUtils,
  math,
  Classes,

  // Tools
  anfix32,
  CaretakerClient,
  srvXMLRPC,
  SolidFTP,
  binlager32,

  // DB
{$IFDEF FPC}
  Windows,
{$ELSE}
  IB_Session,
{$ENDIF}
  // OrgaMon-Globals
  globals,
  dbOrgaMon,

  // OrgaMon-Core
  Funktionen_Auftrag,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_LokaleDaten,

  // hm
  eConnect,

  // Service
  FotoExec,
  JonDaExec,
  TestExec;

type
  TIndentitaet = (id_TWebShop, id_Bestellen, id_Mail, id_Druck, id_App, id_Foto, id_Test, id_Tagesabschluss, id_Tagwache);

var
  Ident: TIndentitaet;
  Modus: string;
  _iDataBaseName: string;
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

    if IsParam('-cl') then
      if (pos(ComputerName + ':', iDataBaseName)=1) then
      begin
        iDataBaseName := copy(iDataBaseName, succ(pos(':', iDataBaseName)), MaxInt);
        writeln('INFO: i run on the same machine as the database-server -> trying to establish a local connection ...');
      end;

    _iDataBaseName := iDataBaseName;
    if (iDataBaseHost <> '') then
      i_c_DataBaseFName := copy(_iDataBaseName, succ(pos(':', _iDataBaseName)), MaxInt)
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
    User := iDataBaseUser;
    HostName := iDataBaseHost;
    Database := i_c_DataBaseFName;
{$ELSE}
    DataBaseName := _iDataBaseName;
    if (iDataBaseHost = '') then
    begin
      Server := '';
      protocol := cplocal;
    end
    else
    begin
      protocol := cpTCP_IP;
    end;
    UserName := iDataBaseUser;
{$ENDIF}
    if (length(iDataBasePassword) > 25) then
      Password := deCrypt_Hex(iDataBasePassword)
    else
      Password := iDataBasePassword;
    if (iDataBaseName = '') then
    begin
      writeln('ERROR: DataBaseName= ist leer');
      halt;
    end;
    write(anfix32.UserName + ' oeffnet ' + string(UserName) + '@' + string(iDataBaseName) + ' ... ');
    Connect;
    if not(Connected) then
    begin
      writeln('ERROR: DataBase.connect erfolglos');
      halt;
    end;
    MachineIDChanged;
  end;

  dbOrgaMon.cConnection := fbConnection;

  sBearbeiter := e_r_Bearbeiter;
  if (sBearbeiter < cRID_FirstValid) then
  begin
    writeln(cERRORText + ' Bearbeiter "' + anfix32.UserName + '" ist noch nicht angelegt!');
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
  TownFotoExec = class(TFotoExec)
    procedure Log(s: string); override;

  end;

  { TownFotoExec }

procedure TownFotoExec.Log(s: string);
begin
  writeln(s);
  // if (pos('ERROR', s) > 0) then
  AppendStringsToFile(
    { } sTimeStamp + ';' +
    { } inttostr(AUFTRAG_R) + ';' +
    { } s,
    { } DiagnosePath + 'FotoService.log.txt');
  if (pos(cFotoService_AbortTag, s) = 1) then
    halt(1);
end;

procedure RunAsFoto;
const
  Worker_Intervall = 4000;
  Sleep_Intervall = 20000;
var
  MyFotoExec: TownFotoExec;
  TimerWartend: integer;
  TimerInit: integer;
  doDirectStart: boolean;
  BackupSizeByNow: double;
begin

  MyFotoExec := TownFotoExec.Create;

  with MyFotoExec do
  begin

    readIni;

    // Log startup
    Log(cINFOText + ' FotoService Rev. ' + RevToStr(version));

    // DebugMode?
    if IsParam('-al') then
    begin
      Log('DebugMode @' + DiagnosePath);
      DebugMode := true;
      DebugLogPath := DiagnosePath;
    end
    else
    begin
      SolidFTP_SingleStepLog := false;
    end;

    // Server direkt durchstarten?
    TimerWartend := 0;
    TimerInit := 0;

    // sofortiges Starten sicherstellen? (direct start)
    doDirectStart := IsParam('+ds');
    if doDirectStart then
      TimerInit := cKikstart_delay * 60 * 1000;

    while true do
    begin

      if (TimerInit < cKikstart_delay * 60 * 1000) then
      begin
        if (TimerInit = 0) then
          Log('Warte ' + inttostr(cKikstart_delay) + ' Minuten ...');
        inc(TimerInit, Worker_Intervall);
        if (TimerInit >= cKikstart_delay * 60 * 1000) then
        begin
          Log('Erwacht ... ');
        end;
      end
      else
      begin

        // Ist die Verarbeitung im Moment pausiert
        if Pause then
        begin
          Log('Pausiert ...');
          ReleaseGlobals;
          sleep(Sleep_Intervall);
          continue;
        end;

        // Alle 5 Min:
        if (TimerWartend > 5 * 60 * 1000) or doDirectStart then
        begin
          TimerWartend := 0;
          doDirectStart := false;

          try
            // Ab und zu die neuen Daten beachten
            ReleaseGlobals;
          except
            on E: Exception do
              Log(cERRORText + ' 271:' + E.ClassName + ': ' + E.Message);
          end;

          try
            // Wartende verarbeiten
            workWartend;
          except
            on E: Exception do
              Log(cERRORText + ' 279:' + E.ClassName + ': ' + E.Message);
          end;

          try
            // Status Seite neu bearbeiten
            workAusstehendeFotos;
          except
            on E: Exception do
              Log(cERRORText + ' 287:' + E.ClassName + ': ' + E.Message);
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
                  Log(cERRORText + ' 300:' + E.ClassName + ': ' + E.Message);
              end;

              BackupSizeByNow := 0.0;
              try
                BackupSizeByNow := JonDaExec.doBackup;
              except
                on E: Exception do
                  Log(cERRORText + ' 307:' + E.ClassName + ': ' + E.Message);
              end;

              Log(cINFOText + format(' %s hat %.3f GB', [JonDaExec.BackupDir, BackupSizeByNow / 1024.0 / 1024.0 /
                1024.0]));
            end;
        end;

        // Jedes Mal:
        try
          workEingang_JPG;
          workEingang_TXT;
        except
          on E: Exception do
            Log(cERRORText + ' 318:' + E.ClassName + ': ' + E.Message);
        end;

      end;

      sleep(Worker_Intervall);
      inc(TimerWartend, Worker_Intervall);
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
 n, Ticket : Integer;

  procedure Log(s: string);
  begin
    try
      writeln(s);
      AppendStringsToFile(s, DiagnosePath + 'Tagesabschluss-' + inttostrN(TagesAbschluss_TAN, 8) + '.log.txt');
      if (pos(cERRORText, s) > 0) then
         CareTakerLog(s);
      if (pos(cFotoService_AbortTag, s) = 1) then
        halt(1);
    except
      // nichts tun!
    end;
  end;

begin
  TagesAbschluss_TAN := e_w_GEN('GEN_BACKUP');
  LetzerTagesAbschlussWarAm := DateGet;
  LetzerTagesAbschlussWarUm := SecondsGet;
  Log('Start am ' + long2date(LetzerTagesAbschlussWarAm) + ' um ' + secondstostr(LetzerTagesAbschlussWarUm) +
      ' h auf ' + ComputerName);
  Ticket := CareTakerLog('Tagesabschluss START');
  Log('Ticket ' + inttostr(Ticket) + ' erhalten');
  ErrorCount := 0;

  sAktions:= TSTringList.create;
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
    add('CareTaker Nachmeldungen');
  end;

  for n := 0 to pred(sAktions.Count) do
  begin

        if (pos(IntToStr(succ(n))+',',iTagesabschlussAusschluss)>0) then
        begin
          Log( { } 'Ausschluss Aktion "' +
               { } sAktions[n] + '"');
          continue;
        end;

        try
          Log( { } 'Beginne Aktion "' +
            { } sAktions[n] + '" um ' +
            { } secondstostr(SecondsGet) + ' h');

          case n of
            0:
           if not(dbBackup(TagesAbschluss_TAN)) then
                raise Exception.Create('Datenbanksicherung erfolglos');
            1:
              begin
                // normale Gesamt-Sicherung
                 (*
                if (iSicherungenAnzahl <> -1) then
                  if not(FormDatensicherung.doCompress(TagesAbschluss_TAN)) then
                    raise Exception.Create('Gesamtsicherung erfolglos');
                  *)
              end;
            2:
              begin
                // Dateien verschieben, die zu lange ausser Gebrauch sind!
                (*

                if iAblage then
                  FormDatensicherung.do400(TagesAbschluss_TAN)
                else
                  FormDatensicherung.die400.Free;

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

                if (DatensicherungPath <> '') then
                  FileDelete(DatensicherungPath + '*', 3, 3);
                if (iTranslatePath <> '') then
                  if (pos(';', iTranslatePath) = 0) then
                    FileDelete(iTranslatePath + iSicherungsPrefix + '*', 10);
                FileDelete(WebPath + '*', 10);
                FileDelete(cAuftragErgebnisPath + '*', 5);

                // Verzeichnis Löschungen
                DirDelete(ImportePath + '*', 10);
                KartenQuota;
                 *)
              end;
            3: begin
(*               FormVersenderPaketID.Execute; *)

            end;

            4:
              begin
                // sich selbst enthaltende Kollektionen löschen!
                e_x_sql('delete from ARTIKEL_MITGLIED where (MASTER_R=ARTIKEL_R)');
                (*
                // Context-OLAPs
                GlobalVars := TStringList.Create;
                GlobalVars.add('$ExcelOpen=' + cINI_Deactivate);

                FormOLAP.DoContextOLAP(
                  { } iSystemOLAPPath + 'Tagesabschluss.*' + cOLAPExtension,
                  { } GlobalVars);
                GlobalVars.Free;
                 *)
              end;
            5:
              begin (*
                if iReplikation then
                  FormReplikation.Execute; *)
              end;
            6:
              begin                          (*
                FormAuftragMobil.ReadMobil;
                FormAuftragMobil.WriteMobil;   *)
              end;
            7:
              begin   (*
                // Für den Foto Server
                e_r_Sync_AuftraegeAlle;

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
(*
              if (iKontenHBCI <> '') then
                FormBuchhalter.e_w_KontoSync(iKontenHBCI);
*)
            end;
            11:
              ReBuild;
            12: begin
(*
              FormAuftragSuchindex.ReCreateTheIndex;
*)
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
(*
              FormMusiker.CreateTheIndex;
*)
            end;
            18: begin
(*
              FormTier.CreateIndex;
*)
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
                if (TimeDiff <> 0) then
                  Log(cERRORText + format(' Abweichung der lokalen Zeit zu der des DB-Servers ist %d Sekunde(n)!',
                    [TimeDiff]));
              end;
            26:
              begin
                Nachmeldungen;
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
  CareTakerClose(Ticket);
  Log('Ende um ' + secondstostr(SecondsGet) + ' h');
  (*
  FormOLAP.DoContextOLAP(iSystemOLAPPath + 'System.Tagesabschluss.*' + cOLAPExtension);
  EofTagesabschluss;
  *)
  sAktions.Free;
end;

procedure RunAsTagwache;
var
  n: integer;
  ErrorCount: integer;
  Ticket: TTroubleTicket;
  GlobalVars: TStringList;
begin
(*
  if TagwacheAktiv then
  begin
    Log(cERRORText + ' Benutzer Abbruch');
    EofTagwache;
    Button1.caption := 'Abbruch ...';
    application.processmessages;
  end
  else
  begin
    BeginHourGlass;
    NoTimer := true;
    LetzteTagWacheWarAm := DateGet;
    LetzteTagWacheWarUm := SecondsGet;
    Tagwache_TAN := e_w_gen('GEN_TAGWACHE');
    ProgressBar1.max := CheckListBox1.items.count;
    Ticket := CareTakerLog('TagWache START');
    ErrorCount := 0;
    Log('Start am ' + long2date(LetzteTagWacheWarAm) + ' um ' + secondstostr(LetzteTagWacheWarUm) + ' h auf ' +
      ComputerName);

    _TagWache := iTagWacheUm;
    iTagWacheUm := 0;
    Button1.caption := '&Abbruch';
    for n := 0 to pred(CheckListBox1.items.count) do
    begin
      ProgressBar1.position := n;
      if not(CheckListBox1.checked[n]) then
      begin
        try
          Log( { } 'Beginne Aktion "' +
            { } CheckListBox1.items[n] + '" um ' +
            { } secondstostr(SecondsGet) + ' h');

          case n of
            0:
*)
              e_w_FotoDownload;
(*
            1:
              FormAuftragMobil.ReadMobil;
            2:
              FormAuftragErgebnis.UploadNewTANS(-1, false);
            3:
              if (iTagwacheBaustelle >= cRID_FirstValid) then
              begin

                // Baustelle ablegen
                with FormBaustelle do
                begin
                  Show;
                  if IB_Query1.Locate('RID', iTagwacheBaustelle, []) then
                  begin
                    AutoYES := true;
                    Button7Click(self);
                  end;
                  Close;
                end;

                // WE frisch erzeugen!
                FormBestellArbeitsplatz.MobilExport;

                // Import-Schema laden
                with FormAuftragImport do
                begin
                  SetContext(iTagwacheBaustelle);
                  DoImport;
                  Close;
                end;

                //

              end;
            4:
              FormAuftragMobil.WriteMobil;
            5:
*)
                e_r_Sync_AuftraegeAlle;
(*
            6:
              begin
                FormOLAPArbeitsplatz.TagWache;
              end;
            7:
              begin
                // Context-OLAPs
                GlobalVars := TStringList.Create;
                GlobalVars.add('$ExcelOpen=' + cINI_Deactivate);
                FormOLAP.DoContextOLAP(
                  { } iSystemOLAPPath + 'Tagwache.*' + cOLAPExtension,
                  { } GlobalVars);
                GlobalVars.free;
              end;
          else
            delay(2000);
          end;
        except
          on e: exception do
          begin
            inc(ErrorCount);
            Log(cERRORText + ' TagWache Exception ' + e.message);
          end;
        end;
        if (ErrorCount = 0) then
          CheckListBox1.checked[n] := true;
        application.processmessages;
        if not(TagwacheAktiv) or (ErrorCount > 0) then
          break;
      end;
    end;
    ProgressBar1.position := 0;
    iTagWacheUm := _TagWache;
    Button1.caption := '&Start';
    if (ErrorCount > 0) then
      Log(cERRORText + ' TagWache FAIL at Stage ' + inttostr(n));
    CareTakerClose(Ticket);
    Log('Ende um ' + secondstostr(SecondsGet) + ' h');

    // Tagwache-OLAPs ausführen
    FormOLAP.DoContextOLAP(iSystemOLAPPath + 'System.Tagwache.*' + cOLAPExtension);

    EofTagwache;
    EndHourGlass;

    // Aktionen NACH der Tagwache
    repeat

      // Anwendung neu starten
      if iNachTagwacheAnwendungNeustart then
      begin
        FormBaseUpdate.RestartApplication;
        break;
      end;

      // Rechner herunterfahren
      if iNachTagWacheHerunterfahren then
      begin
        WindowsHerunterfahren;
        break;
      end;

      // Rechner neu starten
      if iNachTagwacheRechnerNeustarten then
      begin
        FormBaseUpdate.CloseOtherInstances;
        delay(1000);
        WindowsNeuStarten;
        break;
      end;

      // normal weitermachen ...
      if (ErrorCount = 0) then
        for n := 0 to pred(CheckListBox1.items.count) do
          CheckListBox1.checked[n] := false;
      Close;
      NoTimer := false;
    until true;
  end;
*)
end;

procedure RunAsTWebShop;
var
  UsedPort: integer;
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
  UsedPort := StrToIntDef(getParam('port'), -1);
  if (UsedPort < 0) or (UsedPort > 65536) then
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

    DebugMode := anfix32.DebugMode;
    DiagnosePath := globals.DiagnosePath;
    TimingStats := IsParam('-at');
    LogContext := DatumLog + '-' + ComputerName + '-' + inttostr(DefaultPort);

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
    AddMethod('Skript', XMethods.rpc_e_w_Skript);
    AddMethod('NextVal', XMethods.rpc_e_w_NextVal);

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

procedure RunAsOrder;
var
  EREIGNIS_R, BELEG_R, PERSON_R: integer;
begin
  repeat
    // Step 1 : Erlöse die Timeout Jobs (aber nur alle 5 Min)

    // Step 2 : Markiere offene Jobs für mich

    // Step 3 : Verarbeite offene Jobs

    sleep(2000);
  until eternity;
end;

procedure RunAsUnImplemented;
begin

end;

procedure RunAsApp;
var
  XMLRPC: TXMLRPC_Server;
  JonDa: TJonDaExec;
  SectionName: string;
begin

  try
    JonDa := TJonDaExec.Create;
    with JonDa do
    begin
      Option_Console := true;
      SectionName := getParam('Id');
      JonDa.readIni(SectionName);
    end;

    // DebugMode?
    if IsParam('-al') then
    begin
      writeln('DebugMode @' + DiagnosePath);
      DebugMode := true;
      DebugLogPath := DiagnosePath;
    end
    else
    begin
      SolidFTP_SingleStepLog := false;
    end;

    // lade IMEI
    write('Lade Tabelle IMEI ... ');
    with JonDa.tIMEI do
    begin
      insertfromFile(MyProgramPath + cDBPath + 'IMEI.csv');
      writeln(inttostr(RowCount));
    end;

    // lade IMEI-OK
    write('Lade Tabelle IMEI-OK ... ');
    with JonDa.tIMEI_OK do
    begin
      insertfromFile(MyProgramPath + cDBPath + 'IMEI-OK.csv');
      writeln(inttostr(RowCount));
    end;

    // Einstellungen weitergeben
    SolidFTP.SolidFTP_LogDir := DiagnosePath;
    writeln('Verwende FTP Zugang ' + iJonDa_FTPUserName + '@' + iJonDa_FTPHost);

    // Log den Neustart
    JonDa.BeginAction('Start ' + cApplicationName + ' Rev. ' + RevToStr(globals.version) + ' [' + SectionName + ']');
    CareTakerLog(cApplicationName + ' Rev. ' + RevToStr(globals.version) + ' gestartet');

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
          { } JonDa.MyDataBasePath2 + 'AUFTRAG+TS' + cBL_FileExtension);
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
        DefaultPort := iJonDa_Port;
        DiagnosePath := globals.DiagnosePath;

        DebugMode := anfix32.DebugMode;
        TimingStats := IsParam('-at');
        // Verbrauchte Zeit pro XMLRPC
        if TimingStats then
        begin
          writeln('TimingStatistics @' + DiagnosePath);
        end;
        LogContext := DatumLog + '-' + ComputerName + '-' + inttostr(DefaultPort);

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
  {$ifdef fpc}
  {$IFDEF WINDOWS}
//  SetConsoleOutputCP(CP_UTF8);
  {$ENDIF}
  {$endif}

  // Bestimmen in welchem Modus das Programm laufen soll
  Ident := id_TWebShop;
  repeat
    if IsParam('--order') then
    begin
      Ident := id_Bestellen;
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
    if IsParam('--test') then
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
  until yet;

  // Ident- String
  case Ident of
    id_TWebShop:
      Modus := 'TWebShop-Server'; // XMLRPC-Server für den TWebshop
    id_Bestellen:
      Modus := 'ORDER-Server';
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
  end;

  try
    //
    if not(IsParam('-dl')) then
    begin

      writeln('/---------------------------------------------------\');
      writeln('|         ___                  __  __               |');
      writeln('|    ___ / _ \ _ __ __ _  __ _|  \/  | ___  _ __    |');
      writeln('|   / __| | | | ''__/ _` |/ _` | |\/| |/ _ \| ''_ \   |');
      writeln('|  | (__| |_| | | | (_| | (_| | |  | | (_) | | | |  |');
      writeln('|   \___|\___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|  |');
      writeln('|    Rev. ' + RevToStr(globals.version) + '    |___/                            |');
      writeln('\---------------------------------------------------/');
      writeln;
    end;
    writeln(Modus + '@' + noblank(Betriebssystem) + ' [' + MyProgramPath + ']');

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
      id_Bestellen:
        begin
          connectOrgamon;
          RunAsOrder;
        end;
      id_App:
        begin
          RunAsApp;
        end;
      id_Foto:
        begin
          RunAsFoto;
        end;
      id_Test:
        begin
          RunAsTest;
        end
    else
      RunAsUnImplemented;

    end;

  except
    on E: Exception do
      writeln(cERRORText + E.ClassName, ': ', E.Message);
  end;
  sleep(2000);
end;

end.
