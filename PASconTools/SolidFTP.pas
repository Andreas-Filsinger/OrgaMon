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
unit SolidFTP;

interface

uses
{$IFDEF FPC}
  fpchelper,
{$ENDIF}
  Classes, IdFTP, anfix32;

type
  TIdFtpRestart = class(TIdFTP)
    procedure PutRestart(const ASourceFile, ADestFile: string;
      const StartPosition: int64);
  end;

const
  cSolidFTP_DirCurrent = '';

  SolidFTP_LastError: string = '';
  SolidFTP_sLog: TStringList = nil;
  SolidFTP_Retries: integer = 3; // 030 ~ 1 Stunde pro Transaktion
  SolidFTP_NonLinuxParser: boolean = false;
  SolidFTP_SingleStepLog: boolean = true;

  // 120 ~ 4 Stunden pro Transaktion
  SolidFTP_LogDir: string = '';

  // Kommando-Reihenfolge bei "SolidPut" und "SolidStore"
  SolidFTP_Command_SourceFileName = 0;
  SolidFTP_Command_DestinationPath = 1;
  SolidFTP_Command_DestinationFileName = 2;

  // FTP - Initialisierung
procedure SolidInit(ftp: TIdFTP);
procedure SolidBeginTransaction;
procedure solidLog(s: string; DoStatistics: boolean = true);
procedure SolidEndTransaction;

// FTP - Login
procedure SolidLogin(ftp: TIdFTP);

// FTP - Upload: Variante "neu startender / immer überschreibender Upload"
function SolidPut(ftp: TIdFTP; SourceFName, DestPath, DestFName: string)
  : boolean; overload;
function SolidPut(ftp: TIdFTP; CommandList: TStringList): boolean; overload;

// FTP - Upload: Variante "ggf. restart, nicht überschreibender Upload"
function SolidStore(ftp: TIdFtpRestart;
  SourceFName, DestPath, DestFName: string): boolean; overload;
function SolidStore(ftp: TIdFtpRestart; CommandList: TStringList)
  : boolean; overload;

// FTP - Download
function SolidGet(ftp: TIdFTP; SourcePath, SourceMask, DestPath: string;
  RemoteDelete: boolean = false): boolean;

// FTP - Dir
function SolidDir(ftp: TIdFTP; SourcePath, SourceMask: string;
  FileList: TStringList): boolean;

// FTP - FileSize
function SolidSize(ftp: TIdFTP; SourcePath, SourceFName: string): int64;

// FTP - Delete
function SolidDel(ftp: TIdFTP; SourcePath: string; DeleteList: TStringList)
  : boolean; overload;
function SolidDel(ftp: TIdFTP; SourcePath: string; DelFName: string)
  : boolean; overload;


// function SolidSync(ftp: TIdFTP; SourcePath, DestDir): boolean; overload;
// function SolidUpdate(ftp: TIdFTP; Mask): boolean; overload;

// CoreFTP
function CoreFTP_Up(Profile, Mask, DestPath: string): boolean;

// Tools
procedure WakeOnLan(MAC: string); // sample: WakeOnLan('00-07-95-1C-64-7E');
function isFTP_FATAL_ERROR(s: string): boolean;

implementation

uses
  SysUtils,

  // anfix
  CareTakerClient, SimplePassword,

  // Indy FTP
  IdFTPCommon, IDFtpList, IdGlobal,
  IdResourceStringsProtocols, IdFTPListParseBase, IdStack,
  IdFTPListParseUnix, IdFTPListParseWindowsNT, IdReplyRFC,

  // Indy UDP
  IdUDPClient,
  globals,
  JclMiscel,
  windows;

procedure TIdFtpRestart.PutRestart(const ASourceFile, ADestFile: string;
  const StartPosition: int64);
var
  LSourceStream: TStream;
  LDestFileName: String;
begin
  LDestFileName := ADestFile;
  if LDestFileName = '' then
  begin
    LDestFileName := ExtractFileName(ASourceFile);
  end;
  LSourceStream := TIdReadFileNonExclusiveStream.Create(ASourceFile);
  try
    if ADestFile = '' then
      raise EIdFTPUploadFileNameCanNotBeEmpty.Create
        (RSFTPFileNameCanNotBeEmpty);
    LSourceStream.Position := StartPosition;
    DoBeforePut(LSourceStream);
    SendCmd('REST ' + IntToStr(StartPosition), [350]); { Do not localize }
    InternalPut('STOR ' + ADestFile, LSourceStream, false); { Do not localize }
    DoAfterPut;
  finally
    FreeAndNil(LSourceStream);
  end;
end;

//
// Fail-Over-Ketten:
//
// Syntax:
// ~PrimaryHostName~ { ">"  ~AlternativeHostName~ }
//
// Beispiel:
// orgamon.de->orgamon.net->orgamon.dyndns.org
// orgamon.net->orgamon.de->orgamon.dyndns.org
//
// Rang: Hier wird angegeben wieviele Alternativen man bisher erhalten hat
//
//

const
  FailOvers: TStringList = nil;
  _FailOvers: TStringList = nil; // interne Repräsentation der FailObers

function FailOverOf(host: string; Rang: integer = 0): string;
var
  n, m: integer;
  s: string;
begin

  if (FailOvers = nil) then
  begin

    // hier noch als Konstante, sollte langfristig aus ini oder DB geladen
    // werden können
    FailOvers := TStringList.Create;
    with FailOvers do
    begin
      add('orgamon.de>orgamon.net>orgamon.dyndns.org');
      add('orgamon.net>orgamon.de>orgamon.dyndns.org');
    end;

    // die Angaben werden in ein effizienteres Format konvertiert
    _FailOvers := TStringList.Create;
    for n := 0 to pred(FailOvers.Count) do
    begin
      s := FailOvers[n];
      m := 0;
      while (s <> '') do
      begin
        _FailOvers.values[nextp(s, '>') + ':' + IntToStr(m)] :=
          nextp(s, '>', 1);
        inc(m);
      end;
    end;

  end;

  result := _FailOvers.values[host + ':' + IntToStr(Rang)];
end;

const
  sErrorMsg: TStringList = nil;
  sErrorCount: integer = 0;
  sWarningCount: integer = 0;
  sActualServerWorkingDirectory: string = '';
  sTransactionFatalError: boolean = false;

procedure SolidInit(ftp: TIdFTP);
begin
  SolidFTP_NonLinuxParser := false;
  with ftp do
  begin
    Passive := true; // wichtig wegen NAT und Sicherheit
    TransferType := ftBinary; // wichtig wegen SIZE
    TransferTimeout := 30000; // 30 sec ohne Daten -> TimeOut
  end;
  with ftp.ProxySettings do
  begin
    if (iFTPProxyHost <> '') then
    begin
      host := iFTPProxyHost;
      Port := iFTPProxyPort;
      ProxyType := fpcmHttpProxyWithFtp;
    end
    else
    begin
      host := '';
      Port := 0;
      ProxyType := fpcmNone;
    end;
  end;
end;

procedure SolidBeginTransaction;
begin

  //
  if not(assigned(sErrorMsg)) then
    sErrorMsg := TStringList.Create;

  //
  if not(assigned(SolidFTP_sLog)) then
    SolidFTP_sLog := TStringList.Create;

  //
  sErrorCount := 0;
  sWarningCount := 0;
  sActualServerWorkingDirectory := cSolidFTP_DirCurrent;
  SolidFTP_LastError := '';
  sTransactionFatalError := false;

end;

procedure SolidSaveLog;
begin
  if assigned(SolidFTP_sLog) then
  begin
    if (SolidFTP_LogDir <> '') then
      if (SolidFTP_sLog.Count > 0) then
        AppendStringsToFile(SolidFTP_sLog, SolidFTP_LogDir + 'Solid-FTP-' +
          IntToStr(DateGet) + '.log.txt');
    SolidFTP_sLog.clear;
  end;
end;

procedure SolidSingleStepLog(s: string);
begin
  if SolidFTP_SingleStepLog then
    AppendStringsToFile(uhr8 + ':' + s, SolidFTP_LogDir + 'Solid-Step-FTP-' +
      IntToStr(DateGet) + '.log.txt');
end;

procedure SolidEndTransaction;
begin
  if assigned(sErrorMsg) then
  begin
    if (sErrorCount > 0) then
      SolidFTP_LastError := HugeSingleLine(sErrorMsg, '|')
    else
      SolidFTP_LastError := '';
    sErrorMsg.clear;
    SolidSaveLog;
  end;
end;

procedure solidLog(s: string; DoStatistics: boolean = true);
var
  TimeStampS: string;
begin
  ersetze(#$0D#$0A, '|', s);

  // Um einen Zeitstempel erweitern
  TimeStampS := datum + ';' + uhr8 + ';' + s;

  // ins Log kommt alles
  SolidFTP_sLog.add(TimeStampS);

  if (pos(cWARNINGText, s) = 1) then
  begin
    if DoStatistics then
      inc(sWarningCount);
    sErrorMsg.add(TimeStampS);
  end;

  if (pos(cERRORText, s) = 1) then
  begin
    if DoStatistics then
      inc(sErrorCount);
    sErrorMsg.add(TimeStampS);
    CareTakerLog(s);
  end;

  if (pos(cEXCEPTIONText, s) = 1) then
  begin
    if DoStatistics then
      inc(sErrorCount);
    sErrorMsg.add(TimeStampS);
  end;

  //
  if SolidFTP_SingleStepLog then
    AppendStringsToFile(s, SolidFTP_LogDir + 'Solid-Step-FTP-' +
      IntToStr(DateGet) + '.log.txt');

end;

function solidHandleException(ftp: TIdFTP; ActRetry: integer;
  sMsg: string): boolean;
begin
  if (ActRetry >= SolidFTP_Retries) then
  begin

    solidLog(cERRORText + ' ' + sMsg);
    try
      SolidSingleStepLog('abort');
      ftp.Abort;
    except
      ;
    end;

    try
      SolidSingleStepLog('disconnect');
      ftp.Disconnect;
    except

      on E: EIdSocketError do
      begin
        solidLog(cEXCEPTIONText + ' [250] Socket Error: ' +
          IntToStr(E.LastError), false);
      end;

      on E: Exception do
      begin
        solidLog(cEXCEPTIONText + ' [279] ' + E.ClassName + ':' +
          E.Message, false);
      end;

    end;
    result := false
  end
  else
  begin
    solidLog(cWARNINGText + ' (n=' + IntToStr(ActRetry) + ') ' + sMsg);

    try
      SolidSingleStepLog('abort');
      ftp.Abort;
    except
      ;
    end;

    try
      SolidSingleStepLog('disconnect');
      ftp.Disconnect;
    except

      on E: EIdSocketError do
      begin
        solidLog(cEXCEPTIONText + ' [295] Socket Error: ' +
          IntToStr(E.LastError), false);
      end;

      on E: Exception do
      begin
        solidLog(cEXCEPTIONText + ' [301] ' + E.ClassName + ':' +
          E.Message, false);
      end;

    end;

    // Save the Problem-Log
    SolidSaveLog;

    // Sleep a bit, getting fit
    if not(sTransactionFatalError) then
      case ActRetry of
        0:
          sleep(1000 * 60);
        1:
          sleep(1000 * 60 * 2);
        2:
          sleep(1000 * 60 * 8);
      else
        sleep(1000 * 60 * 2);
      end;
    result := true;
  end;
end;

procedure SolidLogin(ftp: TIdFTP);
var
  HostAlternatives: TStringList;
  s: string;
  n: integer;
  RemoteSystemErrorCode: integer;

begin
  HostAlternatives := TStringList.Create;
  with ftp do
  begin

    HostAlternatives.add(host);

    // Calculate the Fail Overs
    s := host;
    repeat
      s := FailOverOf(s, pred(HostAlternatives.Count));
      if (s = '') then
        break;
      HostAlternatives.add(s);
    until false;

    if (length(UserName) = 0) then
    begin
      sTransactionFatalError := true;
      raise Exception.Create('Empty UserName, can not log in');
    end;

    // Usernames with a numeric First Character are in Linux not valid
    // OrgaMon-Rules: Enforce the Prefix "u" (for "U"ser)
    if CharInSet(UserName[1], ['0' .. '9']) then
    begin
      UserName := 'u' + UserName;
      solidLog(cINFOText + ' Prefixed Login-Name with "u", now "' +
        UserName + '"');
    end;

    n := 0;
    repeat

      try
        host := HostAlternatives[n];
        SolidSingleStepLog('connect ' + UserName + '@' + host);
        connect;
      except

        on E: Exception do
        begin

          // Fehlerprotokollierung
          solidLog(cEXCEPTIONText + ' ' + E.ClassName + ': ' +
            E.Message, false);

          // zusätzliche Fehlerprotokollierung
          if E is EIdReplyRFCError then
          begin
            RemoteSystemErrorCode := EIdReplyRFCError(E).ErrorCode;
            solidLog(cINFOText + ' zusätzlicher Fehlercode: ' +
              IntToStr(RemoteSystemErrorCode), false);

            if (RemoteSystemErrorCode = 530) then
            begin
              // Bei "Passwort/User falsch" ist ein
              // nerviges Retry,Retry,Retry, sinnlos. Also sofortige
              // Aufgabe der Aktion ist nötig!
              solidLog(cERRORText +
                ' Benutzername/Passwort wurde nicht akzeptiert.');
              sTransactionFatalError := true;
            end;

          end;

          // imp pend: Die "nicht erreichbaren Hosts" könnten
          // für 10 Minuten in einer "Bad-Host-Liste" landen.
          // Für den Fall dass es Alternativen gibt könnte
          // in dieser Zeit immer zuerst auf die Alternative
          // konnectiert werden
          { <code> }

          // ensure original "Host"
          if (n > 0) then
            host := HostAlternatives[0];

          // raise if no alternatives are left
          if (n = pred(HostAlternatives.Count)) or sTransactionFatalError then
            raise;

          inc(n);

        end;
      end;

    until (connected);

    // restore Original Host
    host := HostAlternatives[0];
    sActualServerWorkingDirectory := cSolidFTP_DirCurrent;

  end;
end;

function solidcdOne(ftp: TIdFTP; DestPath: string): boolean;
var
  ActRetry: integer;

  function _logID: string;
  begin
    result := 'cd(' + ftp.host + ',' + ftp.UserName + ',' + DestPath + ')';
  end;

begin
  result := true;
  if (DestPath <> sActualServerWorkingDirectory) and
    (DestPath <> cSolidFTP_DirCurrent) then
  begin
    with ftp do
    begin
      result := false;
      for ActRetry := 0 to SolidFTP_Retries do
      begin
        try

          // Verbindung sicherstellen
          if not(connected) then
            SolidLogin(ftp);

          //
          if (DestPath = '/') or (DestPath = '\') then
          begin
            SolidSingleStepLog('changedir /');
            ChangeDir('/')
          end
          else
          begin
            SolidSingleStepLog('changedir ' + ValidatePathName(DestPath));
            ChangeDir(ValidatePathName(DestPath));
          end;

          // Erfolg verbuchen!
          sActualServerWorkingDirectory := DestPath;
          result := true;
          break;

        except

          on E: EIdSocketError do
          begin
            solidLog(cEXCEPTIONText + ' [373] Socket Error: ' +
              IntToStr(E.LastError));
            solidHandleException(ftp, ActRetry, _logID + ': ' + E.Message);
          end;

          on E: Exception do
          begin
            solidLog(cEXCEPTIONText + ' [380] ' + E.Message);
            solidHandleException(ftp, ActRetry, _logID + ': ' + E.Message);
          end;

        end;
      end;
    end;
  end;
end;

function SolidDir(ftp: TIdFTP; SourcePath, SourceMask: string;
  FileList: TStringList): boolean;
var
  ActRetry: integer;
  n: integer;

  function _logID: string;
  begin
    result := 'dir(' + ftp.host + ',' + ftp.UserName + ',' + SourcePath + ',' +
      SourceMask + ')';
  end;

begin
  result := true;
  FileList.clear;
  with ftp do
  begin
    for ActRetry := 0 to SolidFTP_Retries do
    begin
      try

        // Verbindung sicherstellen
        if not(connected) then
          SolidLogin(ftp);

        // Verzeichnis sicherstellen
        solidcdOne(ftp, SourcePath);

        // Hinweise für den List-Parser
        UseMLIS := not(SolidFTP_NonLinuxParser);

        // Verzeichnis liste abrufen!
        SolidSingleStepLog('list ' + SourceMask);
        List(SourceMask, true);

        // Dateien zur List hinzunehmen
        for n := 0 to pred(DirectoryListing.Count) do
          with DirectoryListing[n] do
            if (ItemType = ditFile) then
              FileList.add(FileName);

        // Sortieren
        FileList.sort;

        // Erfolg verbuchen!
        result := true;
        break;

      except
        on E: EIdSocketError do
        begin
          solidLog(cEXCEPTIONText + ' [408] Socket Error: ' +
            IntToStr(E.LastError));
          if not(solidHandleException(ftp, ActRetry, _logID + ': ' + E.Message))
          then
            result := false;
        end;

        on E: Exception do
        begin
          solidLog(cEXCEPTIONText + ' [414] ' + E.Message);
          if not(solidHandleException(ftp, ActRetry, _logID + ': ' + E.Message))
          then
            result := false;
        end;
      end;
    end;
  end;
end;

function solidcommitOne(ftp: TIdFTP; DestPath, DestFName: string): boolean;
var
  ActRetry: integer;

  function _logID: string;
  begin
    result := 'commit(' + ftp.host + ',' + ftp.UserName + ',' + DestPath + ',' +
      DestFName + ')';
  end;

begin
  result := false;
  with ftp do
  begin
    for ActRetry := 0 to SolidFTP_Retries do
    begin
      try
        // Verbindung sicherstellen
        if not(connected) then
          SolidLogin(ftp);

        // Pfad sicherstellen!
        solidcdOne(ftp, DestPath);

        SolidSingleStepLog('size ' + DestFName + cTmpFileExtension);
        if (Size(DestFName + cTmpFileExtension) >= 0) then
        begin
          if (Size(DestFName) >= 0) then
          begin
            solidLog(cWARNINGText + 'solidCommit: ' + DestFName +
              ' gab es bereits');
            SolidSingleStepLog('delete ' + DestFName);
            Delete(DestFName);
          end;
          SolidSingleStepLog('rename ' + DestFName + cTmpFileExtension + ' ' +
            DestFName);
          Rename(DestFName + cTmpFileExtension, DestFName);
          result := true;
        end
        else
        begin
          solidLog(cERRORText + 'solidCommit: ' + DestFName + cTmpFileExtension
            + ' verschwunden');
        end;

        break;

      except

        on E: EIdSocketError do
        begin
          solidLog(cEXCEPTIONText + ' [474] Socket Error: ' +
            IntToStr(E.LastError));
          if not(solidHandleException(ftp, ActRetry, _logID + ': ' + E.Message))
          then
            result := false;
        end;

        on E: Exception do
        begin
          solidLog(cEXCEPTIONText + ' [480] ' + E.Message);
          if not(solidHandleException(ftp, ActRetry, _logID + ': ' + E.Message))
          then
            result := false;
        end;

      end;
    end;
  end;
end;

function solidupOne(ftp: TIdFTP; SourceFName, DestPath,
  DestFName: string): boolean;
var
  ActRetry: integer;

  function _logID: string;
  begin
    result := 'up(' + ftp.host + ',' + ftp.UserName + ',' + SourceFName + ',' +
      DestPath + ',' + DestFName + ')';
  end;

begin
  result := false;
  with ftp do
  begin
    for ActRetry := 0 to SolidFTP_Retries do
    begin

      try

        // verbindung sicherstellen
        if not(connected) then
          SolidLogin(ftp);

        // Pfad sicherstellen!
        solidcdOne(ftp, DestPath);

        // Ziel ev. schon vorhanden? -> Löschen
        SolidSingleStepLog('size ' + DestFName + cTmpFileExtension);
        if Size(DestFName + cTmpFileExtension) >= 0 then
        begin
          solidLog(cWARNINGText + 'solidUp: ' + DestFName + cTmpFileExtension +
            ' gab es schon');
          SolidSingleStepLog('delete ' + DestFName + cTmpFileExtension);
          Delete(DestFName + cTmpFileExtension);
        end;

        // Ziel hochladen!
        SolidSingleStepLog('put ' + DestFName + cTmpFileExtension);
        Put(SourceFName, DestFName + cTmpFileExtension);

        // Erfolg!
        result := true;
        break;

      except

        on E: EIdSocketError do
        begin
          solidLog(cEXCEPTIONText + ' [539] Socket Error: ' +
            IntToStr(E.LastError));
          if not(solidHandleException(ftp, ActRetry, _logID + ': ' + E.Message))
          then
            result := false;
        end;

        on E: Exception do
        begin
          solidLog(cEXCEPTIONText + ' [539] ' + E.Message);
          if not(solidHandleException(ftp, ActRetry, _logID + ': ' + E.Message))
          then
            result := false;
        end;

      end;
    end;
  end;
end;

function solidstoreOne(ftp: TIdFtpRestart;
  SourceFName, DestPath, DestFName: string): boolean;
var
  ActRetry: integer;
  rSize, lSize: int64;

  function _logID: string;
  begin
    result := 'store(' + ftp.host + ',' + ftp.UserName + ',' + SourceFName + ','
      + DestPath + ',' + DestFName + ')';
  end;

begin
  result := false;
  lSize := FSize(SourceFName);
  with ftp do
  begin
    for ActRetry := 0 to SolidFTP_Retries do
    begin

      try

        // verbindung sicherstellen
        if not(connected) then
          SolidLogin(ftp);

        // Pfad sicherstellen!
        solidcdOne(ftp, DestPath);

        // Zwischenspeicher ev. vorhanden?
        SolidSingleStepLog('size ' + DestFName + cTmpFileExtension);
        rSize := Size(DestFName + cTmpFileExtension);
        if (rSize <> lSize) then
        begin

          repeat
            if (rSize = -1) then
            begin
              // Datei bisher unbekannt!
              SolidSingleStepLog('put ' + DestFName + cTmpFileExtension);
              Put(SourceFName, DestFName + cTmpFileExtension);
              break;
            end;

            if (rSize < lSize) then
            begin
              // Datei da, aber unvollständig
              SolidSingleStepLog('putrestart@' + IntToStr(rSize) + ' ' +
                DestFName + cTmpFileExtension);
              PutRestart(SourceFName, DestFName + cTmpFileExtension, rSize);
              break;
            end;

            if (rSize = 0) then
            begin
              // Datei da, aber leer
              SolidSingleStepLog('delete ' + DestFName + cTmpFileExtension);
              Delete(DestFName + cTmpFileExtension);
              SolidSingleStepLog('put ' + DestFName + cTmpFileExtension);
              Put(SourceFName, DestFName + cTmpFileExtension);
              break;
            end;

            if rSize > lSize then
              raise Exception.Create('FTP: remote Datei ist ' +
                IntToStr(rSize - lSize) + ' Bytes grösser als die lokale');

          until true;
        end;

        // Erfolg!
        result := true;
        break;

      except

        on E: EIdSocketError do
        begin
          solidLog(cEXCEPTIONText + ' [664] Socket Error: ' +
            IntToStr(E.LastError));
          if not(solidHandleException(ftp, ActRetry, _logID + ': ' + E.Message))
          then
            result := false;
        end;

        on E: Exception do
        begin
          solidLog(cEXCEPTIONText + ' [673] ' + E.Message);
          if not(solidHandleException(ftp, ActRetry, _logID + ': ' + E.Message))
          then
            result := false;
        end;

      end;
    end;
  end;
end;

function SolidSize(ftp: TIdFTP; SourcePath, SourceFName: string): int64;
var
  ActRetry: integer;

  function _logID: string;
  begin
    result := 'size(' + ftp.host + ',' + ftp.UserName + ',' + SourceFName + ','
      + SourcePath + ',' + SourceFName + ')';
  end;

begin
  result := -1;
  with ftp do
  begin
    for ActRetry := 0 to SolidFTP_Retries do
    begin

      try

        // verbindung sicherstellen
        if not(connected) then
          SolidLogin(ftp);

        // Pfad sicherstellen!
        solidcdOne(ftp, SourcePath);

        // Grösse der Datei bestimmen
        SolidSingleStepLog('size ' + SourceFName);
        result := Size(SourceFName);
        break;

      except

        on E: EIdSocketError do
        begin
          solidLog(cEXCEPTIONText + ' [592] Socket Error: ' +
            IntToStr(E.LastError));
          if not(solidHandleException(ftp, ActRetry, _logID + ': ' + E.Message))
          then
            result := -1;
        end;

        on E: Exception do
        begin
          solidLog(cEXCEPTIONText + ' [592] ' + E.Message);
          if not(solidHandleException(ftp, ActRetry, _logID + ': ' + E.Message))
          then
            result := -1;
        end;

      end;
    end;
  end;
end;

function SolidDelOne(ftp: TIdFTP; SourcePath, SourceFName: string): boolean;
var
  ActRetry: integer;

  function _logID: string;
  begin
    result := 'del(' + ftp.host + ',' + ftp.UserName + ',' + SourcePath + ',' +
      SourceFName + ')';
  end;

begin
  result := false;
  with ftp do
  begin
    for ActRetry := 0 to SolidFTP_Retries do
    begin
      try

        // Verbindung sicherstellen
        if not(connected) then
          SolidLogin(ftp);

        // Pfad sicherstellen!
        solidcdOne(ftp, SourcePath);

        SolidSingleStepLog('delete ' + SourceFName);
        Delete(SourceFName);

        // Erfolg!
        result := true;
        break;

      except

        on E: EIdSocketError do
        begin
          solidLog(cEXCEPTIONText + ' [646] Socket Error: ' +
            IntToStr(E.LastError));
          if not(solidHandleException(ftp, ActRetry, _logID + ': ' + E.Message))
          then
            result := false;
        end;

        on E: Exception do
        begin
          solidLog(cEXCEPTIONText + ' [646] ' + E.Message);
          if not(solidHandleException(ftp, ActRetry, _logID + ': ' + E.Message))
          then
            result := false;
        end;

      end;
    end;
  end;
end;

function SolidDel(ftp: TIdFTP; SourcePath: string;
  DeleteList: TStringList): boolean;
var
  n: integer;
begin
  result := true;
  for n := 0 to pred(DeleteList.Count) do
    if not(SolidDelOne(ftp, SourcePath, DeleteList[n])) then
    begin
      result := false;
      break;
    end;
end;

function SolidDel(ftp: TIdFTP; SourcePath: string; DelFName: string)
  : boolean; overload;
begin
  result := SolidDelOne(ftp, SourcePath, DelFName);
end;

function soliddownOne(ftp: TIdFTP; SourcePath, SourceFName, DestPath: string;
  RemoteDelete: boolean = false): boolean;
var
  ActRetry: integer;

  function _logID: string;
  begin
    result := 'down(' + ftp.host + ',' + ftp.UserName + ',' + SourcePath + ',' +
      SourceFName + ',' + DestPath + ')';
  end;

begin
  result := false;
  with ftp do
  begin
    for ActRetry := 0 to SolidFTP_Retries do
    begin
      try

        // Verbindung sicherstellen
        if not(connected) then
          SolidLogin(ftp);

        // Pfad sicherstellen!
        solidcdOne(ftp, SourcePath);

        // Weg freimachen für die neue Datei!
        if DestPath <> '' then
        begin
          if (FSize(DestPath + SourceFName + cTmpFileExtension) >= 0) then
            FileDelete(DestPath + SourceFName + cTmpFileExtension);

          // Datei runterladen
          SolidSingleStepLog('get ' + SourceFName);
          Get(SourceFName, DestPath + SourceFName + cTmpFileExtension, true);

          // Jetzt umbenenen
          FileDelete(DestPath + SourceFName);
          FileRename(DestPath + SourceFName + cTmpFileExtension,
            DestPath + SourceFName);
        end;

        if RemoteDelete then
        begin
          SolidSingleStepLog('delete ' + SourceFName);
          Delete(SourceFName);
        end;

        // Erfolg!
        result := true;
        break;

      except

        on E: EIdSocketError do
        begin
          solidLog(cEXCEPTIONText + ' [929] Socket Error: ' +
            IntToStr(E.LastError));
          if not(solidHandleException(ftp, ActRetry, _logID + ': ' + E.Message))
          then
            result := false;
        end;

        on E: Exception do
        begin
          solidLog(cEXCEPTIONText + ' [938] ' + E.Message);
          if not(solidHandleException(ftp, ActRetry, _logID + ': ' + E.Message))
          then
            result := false;
        end;

      end;
    end;
  end;
end;

function SolidPut(ftp: TIdFTP; CommandList: TStringList): boolean;
var
  n: integer;
  WasError: boolean;
begin
  SolidBeginTransaction;
  WasError := false;
  CommandList.sort;
  RemoveDuplicates(CommandList);

  repeat

    // Hochladen
    for n := 0 to pred(CommandList.Count) do
    begin
      if not(solidupOne(ftp,
        { } nextp(CommandList[n], ';', SolidFTP_Command_SourceFileName),
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationPath),
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationFileName)))
      then
      begin
        WasError := true;
        break;
      end;
    end;
    if (WasError) then
      break;

    // Commit machen
    for n := 0 to pred(CommandList.Count) do
      if not(solidcommitOne(ftp,
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationPath),
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationFileName)))
      then
      begin
        WasError := true;
        break;
      end;

  until true;

  result := not(WasError);
  SolidEndTransaction;
end;

function SolidPut(ftp: TIdFTP; SourceFName, DestPath, DestFName: string)
  : boolean; overload;
var
  CommandList: TStringList;
begin
  CommandList := TStringList.Create;
  CommandList.add(SourceFName + ';' + DestPath + ';' + DestFName);
  result := SolidPut(ftp, CommandList);
  CommandList.free;
end;

function SolidStore(ftp: TIdFtpRestart; CommandList: TStringList)
  : boolean; overload;
var
  n, k: integer;
  WasError: boolean;
  DestFName: string;
begin
  SolidBeginTransaction;
  WasError := false;
  CommandList.sort;
  RemoveDuplicates(CommandList);

  repeat

    // Hochladen
    for n := 0 to pred(CommandList.Count) do
    begin
      if not(solidstoreOne(ftp,
        { } nextp(CommandList[n], ';', SolidFTP_Command_SourceFileName),
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationPath),
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationFileName)))
      then
      begin
        WasError := true;
        break;
      end;
    end;
    if (WasError) then
      break;

    // Sicherstellen, dass ältere Uploads gleichen Namens
    // zuvor *NICHT* überschrieben werden
    for n := 0 to pred(CommandList.Count) do
    begin
      DestFName := nextp(CommandList[n], ';',
        SolidFTP_Command_DestinationFileName);
      if SolidSize(ftp,
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationPath),
        { } DestFName) > 0 then
      begin
        k := revpos('.', DestFName);
        if (k > 0) then
          DestFName :=
          { } copy(DestFName, 1, pred(k)) +
          { } '-' + FindANewPassword +
          { } copy(DestFName, k, MaxInt)
        else
          DestFName := DestFName + '-' + FindANewPassword;

        // Rename it to keep the "old" Version
        SolidSingleStepLog('rename ' + DestFName);
        ftp.Rename(
          { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationFileName),
          { } DestFName);
      end;
    end;

    // Commit machen
    for n := 0 to pred(CommandList.Count) do
      if not(solidcommitOne(ftp,
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationPath),
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationFileName)))
      then
      begin
        WasError := true;
        break;
      end;

  until true;

  result := not(WasError);
  SolidEndTransaction;

end;

function SolidStore(ftp: TIdFtpRestart;
  SourceFName, DestPath, DestFName: string): boolean; overload;
var
  CommandList: TStringList;
begin
  CommandList := TStringList.Create;
  CommandList.add(SourceFName + ';' + DestPath + ';' + DestFName);
  result := SolidStore(ftp, CommandList);
  CommandList.free;
end;

function SolidGet(ftp: TIdFTP; SourcePath, SourceMask, DestPath: string;
  RemoteDelete: boolean = false): boolean;
var
  WasError: boolean;
  n: integer;
  FileList: TStringList;
begin
  SolidBeginTransaction;
  WasError := false;
  FileList := TStringList.Create;
  repeat

    if not(SolidDir(ftp, SourcePath, SourceMask, FileList)) then
    begin
      WasError := true;
      break;
    end;

    for n := 0 to pred(FileList.Count) do
    begin
      if not(soliddownOne(ftp, SourcePath, FileList[n], DestPath, RemoteDelete))
      then
      begin
        WasError := true;
        break;
      end;
    end;

  until true;
  FileList.free;
  result := not(WasError);
  SolidEndTransaction;
end;

procedure WakeOnLan(MAC: string); // sample: WakeOnLan('00-07-95-1C-64-7E');

  function nextp(var s: string; Delimiter: string): string;
  var
    k: integer;
  begin
    k := pos(Delimiter, s);
    if (k > 0) then
    begin
      result := copy(s, 1, pred(k));
      Delete(s, 1, pred(k + length(Delimiter)));
    end
    else
    begin
      result := s;
      s := '';
    end;
  end;

var
  OutStr: AnsiString;
  OneLine: AnsiString;
  n: integer;
  BroadCaster: TIdUDPClient;
  Delimiter: char;
begin
  // check Delimiter
  if (pos('-', MAC) > 0) then
    Delimiter := '-'
  else
    Delimiter := ':';

  // assemble one MAC
  OneLine := '';
  for n := 0 to pred(6) do
    OneLine := OneLine + chr(strtoint('$' + nextp(MAC, Delimiter)));

  // assemble magic Paket
  OutStr := fill(#$FF, 6);
  for n := 0 to pred(16) do
    OutStr := OutStr + OneLine;

  // broadcast magic Paket
  BroadCaster := TIdUDPClient.Create(nil);
{$IFDEF FPC}
  BroadCaster.broadcast(OutStr, 9, '');
{$ELSE}
  BroadCaster.broadcast(OutStr, 9, '', TEncoding.ANSI);
{$ENDIF}
  BroadCaster.free;
end;

// CoreFTP

const
  cCoreFTPExecPath = 'CoreFTP\corecmd.exe';
  cCoreFTP_MsgUploadedFiles = 'Total uploaded files:';

function CoreFTP_Up(Profile, Mask, DestPath: string): boolean;
var
  CommandL: string;
  CoreFTPExitCode: Cardinal;
  sUpFiles: TStringList;
  sLog: TStringList;
  n: integer;
  AnzahlErfolgreicherUploads: integer;
  CoreFTPLogFName: string;
begin
  sUpFiles := TStringList.Create;
  AnzahlErfolgreicherUploads := 0;
  result := false;

  dir(Mask, sUpFiles);

  CommandL := '"' + ProgramFilesDir + cCoreFTPExecPath + '"';

  CommandL := CommandL + ' -O -site ' + Profile + ' -u ' + Mask;
  if (DestPath <> '') then
    CommandL := CommandL + ' -p ' + DestPath;

  // Log ?!
  if (SolidFTP_LogDir <> '') then
  begin
    CoreFTPLogFName := SolidFTP_LogDir + 'CoreFTP-' + IntToStr(DateGet) +
      '.log.txt';

    CommandL := CommandL + ' -log ' + CoreFTPLogFName;
    AppendStringsToFile(uhr8 + ': { ' + CommandL, CoreFTPLogFName);
  end;

  if (sUpFiles.Count > 0) then
    CoreFTPExitCode := JclMiscel.WinExec32AndWait(CommandL, SW_SHOWNORMAL)
  else
    CoreFTPExitCode := 0;

  // Log ?!
  if (SolidFTP_LogDir <> '') then
  begin
    if (sUpFiles.Count = 0) then
    begin
      AppendStringsToFile(cWARNINGText + ' Keine Dateien gefunden!',
        CoreFTPLogFName);
    end
    else
    begin
      // Die Log Datei nach der Anzahl der dateien absuchen
      sLog := TStringList.Create;
      sLog.LoadFromFile(CoreFTPLogFName);
      for n := pred(sLog.Count) downto 0 do
        if pos(cCoreFTP_MsgUploadedFiles, sLog[n]) = 1 then
        begin
          AnzahlErfolgreicherUploads :=
            StrToIntDef(noblank(nextp(sLog[n], ':', 1)), 0);
          break;
        end;
      sLog.free;
    end;
    if AnzahlErfolgreicherUploads <> sUpFiles.Count then
      AppendStringsToFile(cERRORText + format('Nur %d/%d Uploads!',
        [AnzahlErfolgreicherUploads, sUpFiles.Count]), CoreFTPLogFName);

    AppendStringsToFile(format('%s: CoreFTPExitCode:%d }',
      [uhr8, CoreFTPExitCode]), CoreFTPLogFName);
  end;

  result := (CoreFTPExitCode <> Cardinal($FFFFFFFF)) and
    (AnzahlErfolgreicherUploads = sUpFiles.Count);
  sUpFiles.free;
end;

function isFTP_FATAL_ERROR(s: string): boolean;
begin
  result := (pos('# 10054', s) = 0);
end;

end.
