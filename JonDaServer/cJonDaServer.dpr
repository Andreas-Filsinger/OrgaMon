{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007  Andreas Filsinger
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
program cJonDaServer;
{$APPTYPE CONSOLE}

uses
  SysUtils,
  IniFiles,
  IdFTP,
  JonDaExec in 'JonDaExec.pas',
  anfix32 in '..\PASconTools\anfix32.pas',
  WordIndex in '..\PASconTools\WordIndex.pas',
  gplists in '..\PASconTools\gplists.pas',
  CareTakerClient in '..\PASconTools\CareTakerClient.pas',
  SolidFTP in '..\PASconTools\SolidFTP.pas',
  html in '..\PASconTools\html.pas',
  SimplePassword in '..\PASconTools\SimplePassword.pas',
  globals in 'globals.pas',
  srvXMLRPC in '..\PASconTools\srvXMLRPC.pas',
  binlager32 in '..\PASconTools\binlager32.pas';

var
  XMLRPC: TXMLRPC_Server;
  JonDa: TJonDaExec;
  MyIni: TIniFile;
  SectionName: string;

begin
  try
    SectionName := getParam('Id');
    if (SectionName='') then
     SectionName := UserName;

    writeln(
      { } 'cJonDaServer Rev. ' + RevToStr(globals.version) + ' - ' +
      { } MyProgramPath);
    JonDa := TJonDaExec.Create;

    // DebugMode?
    if IsParam('-al') then
    begin
      writeln('DebugMode @' + MyProgramPath);
      DebugMode := true;
      DebugLogPath := globals.MyProgramPath;
    end;

    // lade IMEI
    write('Lade Tabelle IMEI ... ');
    JonDa.tIMEI.insertfromFile(MyProgramPath + cDBPath + 'IMEI.csv');
    writeln(IntToStr(JonDa.tIMEI.Count));

    // lade IMEI-OK
    write('Lade Tabelle IMEI-OK ... ');
    with JonDa.tIMEI_OK do
    begin
     insertfromFile(MyProgramPath + cDBPath + 'IMEI-OK.csv');
     writeln(IntToStr(Count));
    end;

    // Ini-Datei öffnen
    MyIni := TIniFile.Create(MyProgramPath + cIniFName);
    with MyIni do
    begin
      // Fall Back auf "System"
      if (ReadString(SectionName, 'ftpuser', '') = '') then
        SectionName := 'System';

      // Ftp-Bereich für diesen Server
      iJonDa_FTPHost := ReadString(SectionName, 'ftphost', 'gateway');
      iJonDa_FTPUserName := ReadString(SectionName, 'ftpuser', '');
      iJonDa_FTPPassword := ReadString(SectionName, 'ftppwd', '');
      iJonDa_Port := StrToIntDef(ReadString(SectionName, 'port', getParam('Port')),3049);
      JonDa.start_NoTimeCheck := ReadString(SectionName, 'NoTimeCheck', '')
        = cIni_Activate;
      JonDa.Option_Console := true;
    end;
    MyIni.free;
    writeln('Verwende ' + iJonDa_FTPUserName + '@' + iJonDa_FTPHost +
      ' für FTP');

    // Log den Neustart
    JonDa.BeginAction('Start ' + cApplicationName + ' Rev. ' +
      RevToStr(globals.version) + ' [' + UserName + ']');
    CareTakerLog(cApplicationName + ' Rev. ' + RevToStr(globals.version) +
      ' gestartet');

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
          { } MyProgramPath + cServerDataPath + 'AUFTRAG+TS' +
          cBL_FileExtension,
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
        write('Öffne ' + ComputerName + ':' + IntToStr(DefaultPort) + '  ... ');
        DiagnosePath := MyProgramPath;
        DebugMode := anfix32.DebugMode;
        TimingStats := IsParam('-at');

        // Methoden registrieren
        addMethod('BasePlug', JonDa.info);
        addMethod('StartTAN', JonDa.start);
        addMethod('ProceedTAN', JonDa.proceed);

        Active := true;

        writeln('OK');
      end;

      // Aktueller Stand
      writeln('Nächste TAN ... ' + JonDa.NewTrn(false));

      // Arbeite ...
      while true do
        Sleep(1000);
      XMLRPC.free;

    until true;
    JonDa.free;
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
