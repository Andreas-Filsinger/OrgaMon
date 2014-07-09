{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |   l \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2014  Andreas Filsinger
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
program lOrgaMon;

{

 l("l" für Lazarus / Linux)OrgaMon

 cOrgaMon ist der Embarcadero/Delphi XMLRPC Server für Win32
 dieses lOrgaMon ist das Lazarus/FreePascal Gegenstück für Win32 und Linux (Yeah!)


 Voraussetzungen
 ===============

 zeos
 jcl
 Indy

 Vergleiche
 ==========

 cOrgaMon | lOrgaMon
 =========+=========
 flexcel  | fpspreadsheet! (Lack of Revision Number)
 IBO      | Zeos! (Umlaut OK!)
 infozip  | Abbrevia 5.2! (Reported as 5.0)
 ccr-exif | ?: dexif, commandline "exiftool", oder ccr-exif-port, es geht eigentlich nur um das Datum?!

}

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces,
  Classes,
  Math,
  inifiles,
  SysUtils,
  globals,
  fpchelper in '..\PASconTools\fpchelper.pas',
  anfix32 in '..\PASconTools\anfix32.pas',
  WordIndex in '..\PASconTools\WordIndex.pas',
  gplists in '..\PASconTools\gplists.pas',
  DCPcrypt2 in '..\DCPcrypt\DCPcrypt2.pas',
  DCPmd5 in '..\DCPcrypt\Hashes\DCPmd5.pas',
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
  InfoZIP in '..\infozip\InfoZIP.pas',
  Mapping in '..\PASconTools\Mapping.pas',
  OpenStreetMap in '..\PASconTools\OpenStreetMap.pas',
  laz_fpspreadsheet,
  Funktionen_Auftrag,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_LokaleDaten,
  eConnect;

type
  TIndentitaet = (id_XMLRPC, id_Bestellen, id_Mail, id_Druck);

var
  Ident: TIndentitaet;
  Modus: string;
  _iDataBaseName: string;

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
      JonDa.start_NoTimeCheck :=
        ReadString(UserName, 'NoTimeCheck', '') = cIni_Activate;
      JonDa.Option_Console := True;
    end;
    MyIni.Free;

    // Caching Objekte voraktivieren
    Write('Cache ');
    e_r_Preis_ensureCache;
    Write('.');
    e_r_PreisTabelle_ensureCache;
    Write('.');
    e_r_SortimentSatz_EnsureCache;
    Write('.');
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
      AddMethod('ArtikelSuche',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_r_ArtikelSuche);
      AddMethod('ArtikelPreis',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_r_ArtikelPreis);
      AddMethod('KontoInfo',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_r_KontoInfo);
      AddMethod('BestellInfo',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_r_BestellInfo);
      AddMethod('Land',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_r_Land);
      AddMethod('Bestellen',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_w_Bestellen);
      AddMethod('Vormerken',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_w_Vormerken);
      AddMethod('Buchen',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_w_Buchen);
      AddMethod('ArtikelVersendetag',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_r_ArtikelVersendetag);
      AddMethod('Verlag',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_r_Verlag);
      AddMethod('Versandkosten',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_r_Versandkosten);
      AddMethod('ArtikelInfo',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_r_ArtikelInfo);
      AddMethod('BasePlug',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_r_BasePlug);
      AddMethod('ArtikelRabattPreis',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_r_ArtikelRabattPreis);
      AddMethod('PersonNeu',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_w_PersonNeu);
      AddMethod('Ort',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_r_Ort);
      AddMethod('Rabatt',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_r_Rabatt);
      AddMethod('Preis',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_r_Preis);
      AddMethod('Miniscore',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_w_Miniscore);
      AddMethod('LoginInfo',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_w_LoginInfo);
      AddMethod('Skript',
{$ifdef fpc}
        @
{$endif}
        XMethods.rpc_e_w_Skript);

      // JonDa
      AddMethod('JonDaPlug',
{$ifdef fpc}
        @
{$endif}
        JonDa.info);
      AddMethod('StartTAN',
{$ifdef fpc}
        @
{$endif}
        JonDa.start);
      AddMethod('ProceedTAN',
{$ifdef fpc}
        @
{$endif}
        JonDa.proceed);

      // Starten
      BasePlug := e_r_BasePlug;
      Write(
        'Starte ' + ComputerName + ':' + iXMLRPCPort + ' im Kontext ' +
        BasePlug[25] + ' ... ');
      BasePlug.Free;
      active := True;
      writeln(cOKText);

    end;

    // if DebugHook = 0 then
    while True do
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
    until False;
  end;

  procedure RunAsUnImplemented;
  begin

  end;

var
  k, l: integer;


{$R *.res}

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
  until True;

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

    writeln('  _  ___                  __  __');
    writeln(' | |/ _ \ _ __ __ _  __ _|  \/  | ___  _ __');
    writeln(' | | | | | ''__/ _` |/ _` | |\/| |/ _ \| ''_ \');
    writeln(' | | |_| | | | (_| | (_| | |  | | (_) | | | |');
    writeln(' |_|\___/|_|  \__, |\__,_|_|  |_|\___/|_| |_| ' +
      Modus + '-Server@' + Betriebssystem);
    writeln('              |___/');
    writeln;
    Write('Rev. ' + RevToStr(globals.version) + ' lade ' + MyProgramPath + ' ... ');
    writeln(cOKText);

    with fbConnection do
    begin

      _iDataBaseName := iDataBaseName;
      if (iDataBaseHost <> '') then
        i_c_DataBaseFName := copy(_iDataBaseName,
          succ(pos(':', _iDataBaseName)), MaxInt)
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

{$ifdef fpc}
      User := iDataBaseUser;
      HostName := iDataBaseHost;
      Database := i_c_DataBaseFName;
{$else}
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
{$endif}
      if (length(iDataBasePassword) > 25) then
        Password := deCrypt_Hex(iDataBasePassword)
      else
        Password := iDataBasePassword;
      if (iDataBaseName = '') then
      begin
        writeln('ERROR: DataBaseName= ist leer');
        halt;
      end;
      Write(anfix32.UserName + ' oeffnet ' + string(UserName) + '@' +
        string(iDataBaseName) + ' ... ');
      Connect;
      if not (Connected) then
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
      writeln(cERRORText + ' Bearbeiter ' + anfix32.UserName +
        ' ist noch nicht angelegt!');
      halt(1);
    end;

    writeln(cOKText);

    // Debug-Modus aktiv?
    if IsParam('-al') then
    begin
      writeln('DebugMode @' + DiagnosePath);
      DebugMode := True;
      DebugLogPath := globals.DiagnosePath;
    end;

    // Systemparameter ermitteln
    e_r_LadeParameter;
    AllSystemsRunning := True;

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
