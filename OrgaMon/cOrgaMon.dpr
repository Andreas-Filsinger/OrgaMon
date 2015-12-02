{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2012  Andreas Filsinger
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
  memcache in '..\PASconTools\memcache.pas';

type
  TIndentitaet = (id_XMLRPC, id_Bestellen, id_Mail, id_Druck);

var
  Ident: TIndentitaet;
  Modus: string;
  _iDataBaseName: string;
  ForceRev: single;

procedure RunAsXMLRPC;
var
  JonDa: TJonDaExec;
  MyIni: TIniFile;
  UsedPort: integer;
  XMethods: TeConnect;
  XServer: TXMLRPC_Server;
  BasePlug: TStringList;
begin
  JonDa := TJonDaExec.Create;

  // Ini-Datei öffnen
  MyIni := TIniFile.Create(MyProgramPath + cIniFName);
  with MyIni do
  begin
    // Ftp-Bereich für diesen Server
    iJonDa_FTPHost := ReadString(UserName, 'ftphost', 'gateway');
    iJonDa_FTPUserName := ReadString(UserName, 'ftpuser', '');
    iJonDa_FTPPassword := ReadString(UserName, 'ftppwd', '');
    JonDa.start_NoTimeCheck := ReadString(UserName, 'NoTimeCheck', '') = cIni_Activate;
    JonDa.Option_Console := true;
  end;
  MyIni.free;
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
    iXMLRPCPort := IntToStr(UsedPort);

    DebugMode := anfix32.DebugMode;
    DiagnosePath := globals.DiagnosePath;
    TimingStats := IsParam('-at');
    LogContext := DatumLog + '-' + ComputerName + '-' + IntToStr(DefaultPort);
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

    // JonDa
    AddMethod('JonDaPlug', JonDa.info);
    AddMethod('StartTAN', JonDa.start);
    AddMethod('ProceedTAN', JonDa.proceed);

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

var
  k, l: integer;

begin
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
    // Default
    Ident := id_XMLRPC;
  until true;

  // Ident- String
  case Ident of
    id_XMLRPC:
      Modus := 'XMLRPC';
    id_Bestellen:
      Modus := 'ORDER';
    id_Mail:
      Modus := 'MAIL';
    id_Druck:
      Modus := 'PRINT';
  end;

  try
    //
    if not(IsParam('-dl')) then
    begin

      writeln(Modus + '-Server@' + Betriebssystem);
      writeln('=======================================================');
      writeln('|         ___                  __  __                 |');
      writeln('|    ___ / _ \ _ __ __ _  __ _|  \/  | ___  _ __      |');
      writeln('|   / __| | | | ''__/ _` |/ _` | |\/| |/ _ \| ''_ \     |');
      writeln('|  | (__| |_| | | | (_| | (_| | |  | | (_) | | | |    |');
      writeln('|   \___|\___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|    |');
      writeln('|                  |___/                              |');
      writeln('=======================================================');
      writeln;
    end;
    write('Rev. ' + RevToStr(globals.version) + ' lade ' + MyProgramPath + ' ... ');

    writeln(cOKText);

    with fbConnection do
    begin

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
      write(anfix32.UserName + ' oeffnet ' + string(UserName) + '@' + string(iDataBaseName)
        + ' ... ');
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

    // Debug-Modus aktiv?
    if IsParam('-al') then
    begin
      writeln('DebugMode @' + DiagnosePath);
      DebugMode := true;
      DebugLogPath := globals.DiagnosePath;
    end;

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

    case Ident of
      id_XMLRPC:
        RunAsXMLRPC;
      id_Bestellen:
        RunAsOrder;
    else
      RunAsUnImplemented;

    end;

  except
    on E: Exception do
      writeln(cERRORText + E.ClassName, ': ', E.Message);
  end;

end.
