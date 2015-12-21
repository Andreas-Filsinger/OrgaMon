{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2012 - 2015  Andreas Filsinger
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
program cOrgaMon;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Classes,
  math,
  inifiles,
  IB_Session,
  anfix32 in '..\PASconTools\anfix32.pas',
  globals in 'globals.pas',
  WordIndex in '..\PASconTools\WordIndex.pas',
  gplists in '..\PASconTools\gplists.pas',
  html in '..\PASconTools\html.pas',
  CareTakerClient in '..\PASconTools\CareTakerClient.pas',
  SimplePassword in '..\PASconTools\SimplePassword.pas',
  Geld in '..\PASconTools\Geld.pas',
  SolidFTP in '..\PASconTools\SolidFTP.pas',
  sperre in '..\PASconTools\sperre.pas',
  txlib in '..\PASconTools\txlib.pas',
  JonDaExec in '..\JonDaServer\JonDaExec.pas',
  binlager32 in '..\PASconTools\binlager32.pas',
  srvXMLRPC in '..\PASconTools\srvXMLRPC.pas',
  dbOrgaMon in '..\PASconTools\dbOrgaMon.pas',
  txHoliday in '..\PASconTools\txHoliday.pas',
  infozip in '..\infozip\infozip.pas',
  Mapping in '..\PASconTools\Mapping.pas',
  GHD_pngimage in '..\PASconTools\GHD_pngimage.pas',
  GHD_pnglang in '..\PASconTools\GHD_pnglang.pas',
  CCR.Exif.Consts in '..\CCR Exif\CCR.Exif.Consts.pas',
  CCR.Exif.JpegUtils in '..\CCR Exif\CCR.Exif.JpegUtils.pas',
  CCR.Exif in '..\CCR Exif\CCR.Exif.pas',
  CCR.Exif.StreamHelper in '..\CCR Exif\CCR.Exif.StreamHelper.pas',
  CCR.Exif.TagIDs in '..\CCR Exif\CCR.Exif.TagIDs.pas',
  CCR.Exif.XMPUtils in '..\CCR Exif\CCR.Exif.XMPUtils.pas',
  eConnect in 'eConnect.pas',
  OpenStreetMap in '..\PASconTools\OpenStreetMap.pas',
  Funktionen_Auftrag in 'Funktionen_Auftrag.pas',
  Funktionen_Basis in 'Funktionen_Basis.pas',
  Funktionen_Beleg in 'Funktionen_Beleg.pas',
  Funktionen_LokaleDaten in 'Funktionen_LokaleDaten.pas',
  OrientationConvert in '..\PASconTools\OrientationConvert.pas',
  libxml2 in '..\libxml2\libxml2.pas',
  ExcelHelper in '..\PASconTools\ExcelHelper.pas',
  basic32 in '..\PASconTools\basic32.pas',
  DTA in '..\PASconTools\DTA.PAS',
  memcache in '..\PASconTools\memcache.pas',
  FotoExec in '..\JonDaServer\FotoExec.pas',
  Foto in '..\PASconTools\Foto.pas';

type
  TIndentitaet = (id_TWebShop, id_Bestellen, id_Mail, id_Druck, id_App, id_Foto);

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
    if (length(iDataBasePassword) > 25) then
      Password := deCrypt_Hex(iDataBasePassword)
    else
      Password := iDataBasePassword;
    if (iDataBaseName = '') then
    begin
      writeln('ERROR: DataBaseName= ist leer');
      halt;
    end;
    write(anfix32.UserName + ' oeffnet ' + string(UserName) + '@' + string(iDataBaseName) +
      ' ... ');
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
  if (pos('ERROR', s) > 0) then
    AppendStringsToFile(s, MyWorkingPath + 'FotoService.log.txt');
  if (pos('FATAL', s) = 1) then
    halt(1);
end;

procedure RunAsFoto;
const
  Timer_Intervall = 2000;
var
  MyFotoExec: TownFotoExec;
  TimerWartend: integer;
  TimerInit: integer;
  sMoveTransaktionen: TStringList;
  sLog: TStringList;
begin

  // imp pend: Wie könnte man dies Steuern?
  MyProgramPath := 'W:\JonDaServer\';

  MyFotoExec := TownFotoExec.Create;
  TimerWartend := 0;
  TimerInit := 0;

  if (ComputerName = 'KHAO') then
    TimerInit := cKikstart_delay * 60 * 1000;

  sMoveTransaktionen := TStringList.Create;
  sLog := TStringList.Create;

  while true do
  begin

    try
      if (TimerInit < cKikstart_delay * 60 * 1000) then
      begin
        if (TimerInit = 0) then
          MyFotoExec.Log('Warte ' + InttoStr(cKikstart_delay) + ' Minuten ...');
        inc(TimerInit, Timer_Intervall);
        if (TimerInit >= cKikstart_delay * 60 * 1000) then
        begin
          MyFotoExec.Log('Erwacht ... ');
        end;
      end
      else
      begin

        // Alle 5 Min!
        if (TimerWartend > 5 * 60 * 1000) then
        begin
          TimerWartend := 0;

          // Ab und zu die neuen Daten beachten
          MyFotoExec.releaseGlobals;

          // Wartende verarbeiten
          MyFotoExec.workWartend;

          // Status Seite neu bearbeiten
          MyFotoExec.workStatus;

          // Zwischen 00:00 und ]01:00
          if (SecondsGet < (1 * 3600)) then
            // nur machen, wenn nicht in Arbeit oder bereits fertig
            if not(FileExists(MyFotoExec.MyWorkingPath + MyFotoExec.AblageFname)) then
              // Zips verschieben, Fotos zippen
              MyFotoExec.workAblage;

        end;

        // Jedes Mal
        MyFotoExec.workEingang;
      end;

    except

    end;
    inc(TimerWartend, Timer_Intervall);

    sleep(Timer_Intervall);
  end;
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
    iXMLRPCPort := InttoStr(UsedPort);

    DebugMode := anfix32.DebugMode;
    DiagnosePath := globals.DiagnosePath;
    TimingStats := IsParam('-at');
    LogContext := DatumLog + '-' + ComputerName + '-' + InttoStr(DefaultPort);

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
  until false;
end;

procedure RunAsUnImplemented;
begin

end;

procedure RunAsServiceApp;
var
  XMLRPC: TXMLRPC_Server;
  JonDa: TJonDaExec;
  MyIni: TIniFile;
  SectionName: string;

begin
  try
    SectionName := getParam('Id');
    if (SectionName = '') then
      SectionName := UserName;

    writeln(
      { } 'cJonDaServer Rev. ' + RevToStr(JonDaExec.version) + ' - ' +
      { } MyProgramPath);
    JonDa := TJonDaExec.Create;

    // DebugMode?
    if IsParam('-al') then
    begin
      writeln('DebugMode @' + MyProgramPath);
      DebugMode := true;
      DebugLogPath := globals.MyProgramPath;
    end;
    if IsParam('-at') then
    begin
      writeln('TimingStatistics @' + MyProgramPath);
    end;

    // lade IMEI
    write('Lade Tabelle IMEI ... ');
    JonDa.tIMEI.insertfromFile(MyProgramPath + cDBPath + 'IMEI.csv');
    writeln(InttoStr(JonDa.tIMEI.Count));

    // lade IMEI-OK
    write('Lade Tabelle IMEI-OK ... ');
    with JonDa.tIMEI_OK do
    begin
      insertfromFile(MyProgramPath + cDBPath + 'IMEI-OK.csv');
      writeln(InttoStr(Count));
    end;

    // Ini-Datei öffnen
    MyIni := TIniFile.Create(MyProgramPath + cIniFNameConsole);
    with MyIni do
    begin
      // Fall Back auf "System"
      if (ReadString(SectionName, 'ftpuser', '') = '') then
        SectionName := 'System';

      // Ftp-Bereich für diesen Server
      iJonDa_FTPHost := ReadString(SectionName, 'ftphost', 'gateway');
      iJonDa_FTPUserName := ReadString(SectionName, 'ftpuser', '');
      iJonDa_FTPPassword := ReadString(SectionName, 'ftppwd', '');
      iJonDa_Port := StrToIntDef(ReadString(SectionName, 'port', getParam('Port')), 3049);
      JonDa.start_NoTimeCheck := ReadString(SectionName, 'NoTimeCheck', '') = cIni_Activate;
      JonDa.Option_Console := true;
    end;
    MyIni.free;
    writeln('Verwende ' + iJonDa_FTPUserName + '@' + iJonDa_FTPHost + ' für FTP');

    // Log den Neustart
    JonDa.BeginAction('Start ' + cApplicationName + ' Rev. ' + RevToStr(JonDaExec.version) + ' [' +
      SectionName + ']');
    CareTakerLog(cApplicationName + ' Rev. ' + RevToStr(JonDaExec.version) + ' gestartet');

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
          { } MyProgramPath + cFotoPath + 'AUFTRAG+TS' + cBL_FileExtension);
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
        write('Öffne ' + ComputerName + ':' + InttoStr(DefaultPort) + '  ... ');
        DebugMode := anfix32.DebugMode;
        TimingStats := IsParam('-at');
        DiagnosePath := MyProgramPath;
        LogContext := DatumLog + '-' + ComputerName + '-' + InttoStr(DefaultPort);

        // Methoden registrieren
        AddMethod('BasePlug', JonDa.info);
        AddMethod('StartTAN', JonDa.start);
        AddMethod('ProceedTAN', JonDa.proceed);

        active := true;

        writeln('OK');
      end;

      // Aktueller Stand
      writeln('Nächste TAN ... ' + JonDa.NewTrn(false));

      // Arbeite ...
      while true do
        sleep(1000);
      XMLRPC.free;

    until true;
    JonDa.free;
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end;

begin
  // Bestimmen in welchem Modus das Programm laufen soll
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
    // Default "--twebshop"
    Ident := id_TWebShop;
  until true;

  // Ident- String
  case Ident of
    id_TWebShop:
      Modus := 'TWebShop'; // XMLRPC Server
    id_Bestellen:
      Modus := 'ORDER';
    id_Mail:
      Modus := 'MAIL';
    id_Druck:
      Modus := 'PRINT';
    id_App:
      Modus := 'Service-App'; // XMLRPC Server
    id_Foto:
      Modus := 'Service-Foto';
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
    writeln(Modus + '-Server@' + noblank(Betriebssystem) + ' [' + MyProgramPath + ']');

    case Ident of
      id_TWebShop:
        begin
          connectOrgamon;
          RunAsTWebShop;
        end;
      id_Bestellen:
        begin
          connectOrgamon;
          RunAsOrder;
        end;
      id_App:
        begin
          RunAsServiceApp;
        end;
      id_Foto:
        begin
          RunAsFoto;
        end
    else
      RunAsUnImplemented;

    end;

  except
    on E: Exception do
      writeln(cERRORText + E.ClassName, ': ', E.Message);
  end;

end.
