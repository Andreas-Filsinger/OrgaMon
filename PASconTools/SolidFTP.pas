{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2024  Andreas Filsinger
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
unit SolidFTP;

{$ifdef FPC}
{$mode delphi}
{$endif}

interface

uses
{$IFDEF FPC}
  fpchelper,
{$ENDIF}
  Classes,
  anfix,
  IdFTP,
  tgputtylib,
  tgputtysftp;

type
  TIdFtpRestart = class(TIdFTP)
    procedure PutRestart(const ASourceFile, ADestFile: string; const StartPosition: int64);
  end;

(*

  TSolidFTP ist eine Abstraktionsklasse und bietet:
  =================================================

    FTP  | plain unsecure Text-FTP | implementiert mit Indy
    SFTP | FTP via ssh             | implementiert mit Putty (tgputtysftp.dll)
    FTPS | Secured (AUTH TLS) FTP  | implementiert mit CoreFTP Commandline**

  dabei wird dem Host ein Protokoll vorangestellt:

  [ "" | "sftp:" | "ftp:" | "ftps:" ] Host

  default ist FTP, dies muss nicht angegeben werden.

  ** unvollständig

*)


const
  // unspeziefischer Anfangspfad, kann für
  // "sourcePath" Parameter verwendet werden um auszudrücken dass
  // kein Pfadwechsel nötig ist
  SolidFTP_LogDir: string = '';

  // define "host" replacements for simple
  // service migrations
  // localhost>rom;roma>rom
  iFTPAlias: string = '';

const
  cSolidFTP_DirCurrent = '';

  // Kommando-Reihenfolge bei "SolidPut" und "SolidStore"
  SolidFTP_Command_SourceFileName = 0;
  SolidFTP_Command_DestinationPath = 1;
  SolidFTP_Command_DestinationFileName = 2;

type
  TSolidFTP = class(TObject)

   private
     type
      eMode = (Undecided, Indy, Putty, Core);

     const
       sErrorCount: integer = 0;
       sWarningCount: integer = 0;
       sActualServerWorkingDirectory: string = '';
       sTransactionFatalError: boolean = false;
       sTransactionLevel: integer = 0;

     var
      iFTP : TIdFTPRestart;
      sFTP : TTGPuttySFTP;
      Mode : eMode;

      // putty
      ls : TStringList;
      WatchOutMsg: string;
      WatchOutMsgHit: boolean;

     // late check what eMode we are in
     procedure CheckSetMode;

     // upload DestFName.$$$ (Vorgängerversuche löschen)
     function upOne(SourceFName, DestPath, DestFName: string): boolean;

     // restart upload of DestFName.$$$
     function restartOne(SourceFName, DestPath, DestFName: string): boolean;

     // delete DestFName, rename DestFName.$$$ to DestFName
     function commitOne(DestPath, DestFName: string; WarnIfAlreadyThere : boolean = true): boolean;

     // download SourceFName
     function downOne(SourcePath, SourceFName, DestPath: string; RemoteDelete: boolean = false): boolean;

     // delete, rm
     function delOne(SourcePath, SourceFName: string): boolean;

     // putty specific Call-Backs
     procedure putty_cb_Message(const Msg:AnsiString;const isstderr:Boolean);
     function putty_cb_lsOne(const names:Pfxp_names):Boolean;
     function putty_cb_verifyHostkey(const host:PAnsiChar;const port:Integer;
                               const fingerprint:PAnsiChar;
                               const verificationstatus:Integer;
                               var storehostkey:Boolean):Boolean;

   public
     Host : string;
     UserName : string;
     Password : string;
     Retries: Integer;
     NonLinuxParser: Boolean;

     constructor Create;
     destructor Destroy; override;

     // native F T P Fuktionen
     function Connected : boolean;
     procedure Connect;
     procedure Disconnect;
     procedure Abort;
     procedure ChangeDir(RemotePath: string);
     procedure Rename(FromName, ToName:string);
     function Size(RemoteFName: string): int64; Overload;
     procedure Delete(RemoteFName: string); Overload;
     procedure Put(SourceFName, DestFName: string); Overload;
     procedure PutRestart(const ASourceFile, ADestFile: string; const StartPosition: int64);
     procedure Get(const ASourceFile, ADestFile: string; const ACanOverwrite: Boolean = False;
      AResume: Boolean = False); Overload;

     // S O L I D Functions
     procedure BeginTransaction;

     procedure Log(s: string; DoStatistics: boolean = true);
     function HandleException(ActRetry: integer; sMsg: string): boolean;

     procedure Login(DestPath: string = cSolidFTP_DirCurrent);
     function cdOne(DestPath: string): boolean;

     // Put: Variante "von 0 neu startender / immer wieder überschreibender Upload"
     function Put(SourceFName, DestPath, DestFName: string): boolean; overload;
     function Put(CommandList: TStringList): boolean; overload;

     // Upload: Variante "erst Put, danach wenn nötig Restart"
     function Upload(SourceFName, DestPath, DestFName: string): boolean; overload;
     function Upload(CommandList: TStringList): boolean; overload;

     // Store: Variante "ggf. restart, niemals überschreibender Upload"
     function Store(SourceFName, DestPath, DestFName: string): boolean; overload;
     function Store(CommandList: TStringList): boolean; overload;

     // Download (Herunterladen von Dateien)
     // SourceMask ist z.B. '*.zip'
     // SourcePattern ist z.B. 'Fotos-????.zip'
     //  leeres Pattern lässt alles durch
     function Get(SourcePath, SourceMask, SourcePattern, DestPath: string;
      RemoteDelete: boolean = false): boolean; Overload;

     // Dir (Auflisten von Verzeichnisinhalten)
     // SourceMask ist z.B. '*.zip'
     // SourcePattern ist z.B. 'Fotos-????.zip'
     //  leeres Pattern lässt alles durch
     function Dir(SourcePath, SourceMask, SourcePattern: string; FileList: TStringList): boolean;

     // CheckDir (Prüfen, ob es ein Verzeichnis gibt)
     function CheckDir(SourcePath: string): boolean;

     //
     // FTP - FileSize
     //
     // -1 wenn es die Datei gar nicht gibt
     //
     function Size(SourcePath, SourceFName: string): int64; overload;

     function Del(SourcePath: string; DeleteList: TStringList): boolean; overload;
     function Del(SourcePath: string; DelFName: string): boolean; overload;

     procedure EndTransaction;


  end;

// CoreFTP
function CoreFTP_Up(Profile, Mask, DestPath: string): boolean;

// Tools
function isFTP_FATAL_ERROR(s: string): boolean;
function CheckAgainstPattern(FileName, Pattern: string): boolean;

// der Username kann durch "/pfad" erweitert sein
// diese Funktion liefert NUR den LoginUser
function e_r_FTP_LoginUser (s : String) : String;

function e_r_FTP_SourcePath (s:string):string;
function FTPAlias(alias:string):string; // return real host-name

implementation

uses
  SysUtils,

  // anfix
  CareTakerClient, SimplePassword, systemd,

  // Indy FTP
  IdFTPCommon, IDFtpList, IdGlobal, IdException,
  IdResourceStringsProtocols, IdFTPListParseBase, IdStack,
{$ifndef FPC}
  IdFTPListParseUnix, IdFTPListParseWindowsNT,
{$endif}
  IdReplyRFC,

//  globals,
  windows;

function ValidatePathNameFTP(DestPath : string):string;
begin
  result := ValidatePathName(DestPath);
  ersetze('\','/',result);
end;

procedure TIdFtpRestart.PutRestart(const ASourceFile, ADestFile: string; const StartPosition: int64);
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
      raise EIdFTPUploadFileNameCanNotBeEmpty.Create(RSFTPFileNameCanNotBeEmpty);
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
// orgamon.de->orgamon.net->ftp.orgamon.net
// orgamon.net->orgamon.de->ftp.orgamon.net
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
      add('orgamon.de>orgamon.net>ftp.orgamon.net');
      add('orgamon.net>orgamon.de>ftp.orgamon.net');
    end;

    // die Angaben werden in ein effizienteres Format konvertiert
    _FailOvers := TStringList.Create;
    for n := 0 to pred(FailOvers.Count) do
    begin
      s := FailOvers[n];
      m := 0;
      while (s <> '') do
      begin
        _FailOvers.values[nextp(s, '>') + ':' + IntToStr(m)] := nextp(s, '>', 1);
        inc(m);
      end;
    end;

  end;

  result := _FailOvers.values[host + ':' + IntToStr(Rang)];
end;

function isFTP_FATAL_ERROR(s: string): boolean;
begin
  result := (pos('# 10054', s) = 0);
end;

function CheckAgainstPattern(FileName, Pattern: string): boolean;
var
  n: integer;
begin
  result := true;

  // Check for illegal Chars inside the FileName
  for n := 1 to length(cInvalidFNameChars) do
   if (pos(cInvalidFNameChars[n],FileName)>0) then
   begin
     //solidLog(cWARNINGText + ' i do now ignore the illegal FileName "'+FileName+'" the FTP-Server just reported');
     result := false;
     exit;
   end;

  // No Pattern, no further check
  if (Pattern = '') then
    exit;

  // FileName's length must be length(Pattern)
  if (length(FileName) = length(Pattern)) then
  begin

    // Patch FileName at ? Positions of Pattern
    for n := 1 to length(FileName) do
      if (Pattern[n] = '?') then
        FileName[n] := '?';

    // FileName must Match now 100%
    if (FileName=Pattern) then
     exit;

  end;

  result := false;
end;

function e_r_FTP_LoginUser (s:string):string;
begin
 result := cutblank(nextp(s, '\', 0));
end;

function e_r_FTP_SourcePath (s:string):string;
var
 i : Integer;
begin
  result := '';
  i := pos('\',s);
  if (i>0) then
  begin
   result := cutblank(copy(s,succ(i),MaxInt));
   // Sicherheit vor Pfad Manipulationen
   // unerwünscht: Masken und relative Angaben
   result := StrFilter(result,cInvalidPathNameChars,true);
   // Am Ende muss ein Backslash sein!!
   if (result[length(result)]<>'\') then
    result := result + '\';
   // Unnötige Doppel-Slash
   ersetze('\\','\',result);
   // Leere Pfadangabe tolerieren
   if (result='\') then
    result := '';
  end;
end;

const
 _FTPAlias_Alias: TStringList = nil;
 _FTPAlias_Host: TStringList = nil;

function FTPAlias(alias:string):string; // return real host-name
var
 i : Integer;
 entry,param: string;
begin

 // first init?
 if not(assigned(_FTPAlias_Alias)) then
 begin
  _FTPAlias_Alias := TStringList.Create;
  _FTPAlias_Host := TStringList.Create;
  if (iFTPAlias<>'') then
  begin
   entry := iFTPAlias;
   repeat
    param := nextp(entry,';');
    _FTPAlias_Alias.Add(AnsiLowerCase(nextp(param,'>')));
    _FTPAlias_Host.Add(param);
   until (entry='');
  end;
 end;

 // Search the Alias, if not found its a host
 i := _FTPAlias_Alias.IndexOf(AnsiLowerCase(alias));
 if (i=-1) then
  result := alias
 else
  result := FTPAlias(_FTPAlias_Host[i]);
end;

constructor TSolidFTP.Create;
begin
  Retries := 3;
end;

destructor TSolidFTP.Destroy;
begin
 if assigned(iFTP) then
  iFTP.Free;
 if assigned(sFTP) then
  sFTP.Free;
 if assigned(ls) then
  ls.Free;
end;

procedure TSolidFTP.Log(s: string; DoStatistics: boolean = true);
begin

 if (SolidFTP_LogDir <> '') then
   AppendStringsToFile(
     {} uhr8 + ':' + s,
     {} SolidFTP_LogDir + 'FTP-' + DatumLog + cLogExtension);

  repeat
    if not(DoStatistics) then
      break;

    if (pos(cWARNINGText, s) = 1) then
    begin
      inc(sWarningCount);
      break;
    end;

    if (pos(cERRORText, s) = 1) then
    begin
      inc(sErrorCount);
      break;
    end;

    if (pos(cEXCEPTIONText, s) = 1) then
    begin
      inc(sErrorCount);
      break;
    end;

  until yet;

end;

procedure TSolidFTP.BeginTransaction;
begin
  //
  sErrorCount := 0;
  sWarningCount := 0;
  sTransactionFatalError := false;
  inc(sTransactionLevel);
end;

procedure TSolidFTP.EndTransaction;
begin
 dec(sTransactionLevel);
 if (sTransactionLevel<0) then
  sTransactionLevel := 0;
 if (sTransactionLevel=0) then
  Log(fill('_',80));
end;

procedure TSolidFTP.Login(DestPath: string = cSolidFTP_DirCurrent);
var
  HostAlternatives: TStringList;
  s: string;
  n: integer;
  RemoteSystemErrorCode: integer;
begin
  if sTransactionFatalError then
   raise Exception.Create('Try to Login in Fatal-Error-Condition');
  if not(connected) then
  begin
    HostAlternatives := TStringList.Create;
    host := FTPAlias(host);

    HostAlternatives.add(host);

    // Calculate the Fail Overs
    s := host;
    repeat
      s := FailOverOf(s, pred(HostAlternatives.Count));
      if (s = '') then
        break;
      HostAlternatives.add(s);
    until eternity;

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
      Log(cINFOText + ' Prefixed Login-Name with "u", now "' + UserName + '"');
    end;

    n := 0;
    repeat

      try
        host := HostAlternatives[n];
        Log('>connect ' + UserName + '@' + host);
        WatchOutMsg :=
         {} 'Access denied;'+
         {} 'Software caused connection abort;'+
         {} 'Remote side unexpectedly closed network connection';
        WatchOutMsgHit := false;
        connect;
      except

        on E: Exception do
        begin

          // Fehlerprotokollierung
          Log(cEXCEPTIONText + ' [577] ' + E.ClassName + ': ' + E.Message, false);

          // Putty: Ist es ein falsches Passwort?
          if WatchOutMsgHit then
          begin
            sTransactionFatalError := true;
            Log(cERRORText + ' Benutzername/Passwort wurde nicht akzeptiert.');
          end;

          // Indy: zusätzliche Fehlerprotokollierung
          if E is EIdReplyRFCError then
          begin
            RemoteSystemErrorCode := EIdReplyRFCError(E).ErrorCode;
            Log(cINFOText + ' zusätzlicher Fehlercode: ' + IntToStr(RemoteSystemErrorCode), false);

            if (RemoteSystemErrorCode = 530) then
            begin
              // Bei "Passwort/User falsch" ist ein
              // nerviges Retry,Retry,Retry, sinnlos. Also sofortige
              // Aufgabe der Aktion ist nötig!
              sTransactionFatalError := true;
              Log(cERRORText + ' Benutzername/Passwort wurde nicht akzeptiert.');
            end;

          end;

          // imp pend: Die "nicht erreichbaren Hosts" könnten
          // für 10 Minuten in einer "Bad-Host-Liste" landen.
          // Für den Fall dass es Alternativen gibt könnte
          // in dieser Zeit immer zuerst auf die Alternative
          // connectiert werden
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

      if sTransactionFatalError then
        break;

    until (connected);

    // restore Original Host
    host := HostAlternatives[0];
    if (DestPath <> '') then
    begin
     ChangeDir(DestPath);
     sActualServerWorkingDirectory := DestPath;
    end else
    begin
     sActualServerWorkingDirectory := '/';
    end;
 end;
end;

function TSolidFTP.Put(CommandList: TStringList): boolean;
var
  n: integer;
  WasError: boolean;
begin
  BeginTransaction;
  WasError := false;
  CommandList.sort;
  RemoveDuplicates(CommandList);

  repeat

    // Hochladen
    for n := 0 to pred(CommandList.Count) do
    begin
      if not(upOne(
        { } nextp(CommandList[n], ';', SolidFTP_Command_SourceFileName),
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationPath),
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationFileName))) then
      begin
        WasError := true;
        break;
      end;
    end;
    if (WasError) then
      break;

    // Commit machen
    for n := 0 to pred(CommandList.Count) do
      if not(commitOne(
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationPath),
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationFileName),
        { } false)) then
      begin
        WasError := true;
        break;
      end;

  until yet;

  result := not(WasError);
  EndTransaction;
end;

function TSolidFTP.Put(SourceFName, DestPath, DestFName: string): boolean;
var
  CommandList: TStringList;
begin
  CommandList := TStringList.Create;
  CommandList.add(SourceFName + ';' + DestPath + ';' + DestFName);
  result := Put(CommandList);
  CommandList.free;
end;

// FTP - Upload: Variante "ggf. restart, nicht überschreibender Upload"
function TSolidFTP.Store(SourceFName, DestPath, DestFName: string): boolean;
var
  CommandList: TStringList;
begin
  CommandList := TStringList.Create;
  CommandList.add(SourceFName + ';' + DestPath + ';' + DestFName);
  result := Store(CommandList);
  CommandList.free;
end;

function TSolidFTP.Store(CommandList: TStringList): boolean;
var
  n, k: integer;
  WasError: boolean;
  DestFName: string;
begin
  BeginTransaction;
  WasError := false;
  CommandList.sort;
  RemoveDuplicates(CommandList);

  repeat

    // Hochladen
    for n := 0 to pred(CommandList.Count) do
    begin
      if not(restartOne(
        { } nextp(CommandList[n], ';', SolidFTP_Command_SourceFileName),
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationPath),
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationFileName))) then
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
      DestFName := nextp(CommandList[n], ';', SolidFTP_Command_DestinationFileName);
      if Size(
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
        Log('>rename ' + nextp(CommandList[n], ';', SolidFTP_Command_DestinationFileName) + ' ' + DestFName);
        Rename(
          { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationFileName),
          { } DestFName);
      end;
    end;

    // Commit machen
    for n := 0 to pred(CommandList.Count) do
      if not(commitOne(
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationPath),
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationFileName))) then
      begin
        WasError := true;
        break;
      end;

  until yet;

  result := not(WasError);
  EndTransaction;

end;

// FTP - Upload: Variante "Hybrid aus Put, danach wenn nötig Store"
function TSolidFTP.Upload(SourceFName, DestPath, DestFName: string): boolean;
var
  CommandList: TStringList;
begin
  CommandList := TStringList.Create;
  CommandList.add(SourceFName + ';' + DestPath + ';' + DestFName);
  result := Upload(CommandList);
  CommandList.free;
end;

function TSolidFTP.Upload(CommandList: TStringList): boolean;
var
  n, k: integer;
  WasError: boolean;
  UploadOK: boolean;
  DestFName: string;
  _Retries : Integer;
begin
  BeginTransaction;
  _Retries := Retries;
  WasError := false;
  CommandList.sort;
  RemoveDuplicates(CommandList);

  repeat

    // Hochladen
    for n := 0 to pred(CommandList.Count) do
    begin

      Retries := 0;
      UploadOK := UpOne(
        { } nextp(CommandList[n], ';', SolidFTP_Command_SourceFileName),
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationPath),
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationFileName));
      Retries := _Retries;

      if not(UploadOK) then
        if not(restartOne(
          { } nextp(CommandList[n], ';', SolidFTP_Command_SourceFileName),
          { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationPath),
          { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationFileName))) then
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
      DestFName := nextp(CommandList[n], ';', SolidFTP_Command_DestinationFileName);
      if Size(
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
        Log('>rename ' + nextp(CommandList[n], ';', SolidFTP_Command_DestinationFileName) + ' ' + DestFName);
        Rename(
          { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationFileName),
          { } DestFName);
      end;
    end;

    // Commit machen
    for n := 0 to pred(CommandList.Count) do
      if not(commitOne(
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationPath),
        { } nextp(CommandList[n], ';', SolidFTP_Command_DestinationFileName))) then
      begin
        WasError := true;
        break;
      end;

  until yet;

  result := not(WasError);
  EndTransaction;

end;

function TSolidFTP.Get(SourcePath, SourceMask, SourcePattern, DestPath: string;
  RemoteDelete: boolean = false): boolean;
var
  WasError: boolean;
  n: integer;
  FileList: TStringList;
begin
  BeginTransaction;
  WasError := false;
  FileList := TStringList.Create;
  repeat

    if not(Dir(SourcePath, SourceMask, SourcePattern, FileList)) then
    begin
      WasError := true;
      break;
    end;

    for n := 0 to pred(FileList.Count) do
    begin
      if not(downOne(SourcePath, FileList[n], DestPath, RemoteDelete)) then
      begin
        WasError := true;
        break;
      end;
    end;

  until yet;
  FileList.free;
  result := not(WasError);
  EndTransaction;
end;

function TSolidFTP.Dir(SourcePath, SourceMask, SourcePattern: string; FileList: TStringList): boolean;
var
  ActRetry: integer;
  n: integer;

  function _logID: string;
  begin
    result := 'dir(' + host + ',' + UserName + ',' + SourcePath + ',' + SourceMask + ')';
  end;

begin
  result := false;
  FileList.clear;
  for ActRetry := 0 to Retries do
  begin
    if sTransactionFatalError then
      break;
    try

      // Verbindung sicherstellen
      if not(connected) then
        Login;

      // Verzeichnis sicherstellen
      cdOne(SourcePath);

      Log('>list ' + SourceMask);
      case Mode of
       Indy:begin

              // Hinweise für den List-Parser
              iFTP.UseMLIS := not(NonLinuxParser);

              // Verzeichnis liste abrufen!
              iFTP.List(SourceMask, true);

              // Dateien zur List hinzunehmen
              for n := 0 to pred(iFTP.DirectoryListing.Count) do
                with iFTP.DirectoryListing[n] do
                  if (ItemType = ditFile) then
                    if CheckAgainstPattern(FileName, SourcePattern) then
                      FileList.add(FileName);
            end;
       Putty:begin
              ls.clear;
              sFTP.ListDir('');
              if DebugMode then
               for n := 0 to pred(ls.Count) do
                  Log(' ´' + ls[n] + '´');
              for n := pred(ls.Count) downto 0 do
               if not(CheckAgainstPattern(ls[n], SourcePattern)) then
                ls.Delete(n);
              for n := 0 to pred(ls.count) do
                FileList.add(ls[n]);
             end;
      end;

      // Sortieren
      FileList.sort;
      for n := 0 to pred(FileList.Count) do
        Log(' "' + FileList[n] + '"');

      // Erfolg verbuchen!
      result := true;
      break;
    except

      on E: EIdSocketError do
      begin
        Log(cEXCEPTIONText + ' [2130] Socket Error: ' + IntToStr(E.LastError));
        if not(HandleException(ActRetry, _logID + ': ' + E.Message)) then
          result := false;
      end;

      on E: Exception do
      begin
        Log(cEXCEPTIONText + ' [2137] ' + E.Message);
        if not(HandleException(ActRetry, _logID + ': ' + E.Message)) then
          result := false;
      end;

    end;
  end;
end;

// FTP - CheckDir (Prüfen, ob es ein Verzeichnis gibt)
function TSolidFTP.CheckDir(SourcePath: string): boolean;
  function _logID: string;
  begin
    result := 'cd(' + host + ',' + UserName + ',' + SourcePath + ')';
  end;

begin
  if (SourcePath=cSolidFTP_DirCurrent) then
  begin
    result := true;
  end else
  begin
      try
        result := false;

        // Verbindung sicherstellen
        if not(connected) then
          Login;

        // check
        ChangeDir(ValidatePathNameFTP(SourcePath));

        // go silently back to root
        ChangeDir('/');
        //
        result := true;

      except

        on E: EIdSocketError do
        begin
          Log(cEXCEPTIONText + ' [2119] Socket Error: ' + IntToStr(E.LastError));
          if not(HandleException(Retries, _logID + ': ' + E.Message)) then
            result := false;
        end;

        on E: Exception do
        begin
          Log(cEXCEPTIONText + ' [2126] ' + E.Message);
          if not(HandleException(Retries, _logID + ': ' + E.Message)) then
            result := false;
        end;
      end;
    end;
end;

//
// FTP - FileSize
//
// -1 wenn es die Datei gar nicht gibt
//
function TSolidFTP.Size(SourcePath, SourceFName: string): int64;
var
  ActRetry: integer;

  function _logID: string;
  begin
    result := 'size(' + host + ',' + UserName + ',' + SourceFName + ',' + SourcePath + ',' + SourceFName + ')';
  end;

begin
  result := -1;
  for ActRetry := 0 to Retries do
  begin
    if sTransactionFatalError then
      break;
    try

      // verbindung sicherstellen
      if not(connected) then
        Login;

      // Pfad sicherstellen!
      cdOne(SourcePath);

      // Grösse der Datei bestimmen
      Log('>size ' + SourceFName);
      result := Size(SourceFName);
      Log(' ' + IntToStr(result));
      break;

    except

      on E: EIdSocketError do
      begin
        Log(cEXCEPTIONText + ' [1987] Socket Error: ' + IntToStr(E.LastError));
        if not(HandleException(ActRetry, _logID + ': ' + E.Message)) then
          result := -1;
      end;

      on E: Exception do
      begin
        Log(cEXCEPTIONText + ' [1994] ' + E.Message);
        if not(HandleException(ActRetry, _logID + ': ' + E.Message)) then
          result := -1;
      end;

    end;
  end;
end;

function TSolidFTP.Del(SourcePath: string; DeleteList: TStringList): boolean;
var
  n: integer;
begin
  result := true;
  for n := 0 to pred(DeleteList.Count) do
    if not(delOne(SourcePath, DeleteList[n])) then
    begin
      result := false;
      break;
    end;
end;

function TSolidFTP.Del(SourcePath: string; DelFName: string): boolean;
begin
  result := delOne(SourcePath, DelFName);
end;

function TSolidFTP.Connected : boolean;
begin
 CheckSetMode;
 case Mode of
   Indy : Result := iFTP.Connected;
   Putty : Result := sFTP.Connected;
   Core : Result := true;
 end;
end;

procedure TSolidFTP.Connect;
begin
 CheckSetMode;
 case Mode of
   Indy : begin
            iFTP.Host := Host;
            iFTP.Connect;
          end;
   Putty : sFTP.Connect;
 end;
end;

function TSolidFTP.Size(RemoteFName: string) : int64;
begin
 case Mode of
   Indy : Result := iFTP.Size(RemoteFName);
   Putty : Result := sFTP.GetFileSize(RemoteFName);
 end;
end;

procedure TSolidFTP.ChangeDir(RemotePath: string);
begin
 case Mode of
   Indy :  begin
             Log('>changedir ' + RemotePath,false);
             iFTP.ChangeDir(RemotePath);
           end;
   Putty : begin
            // we act like we are not chrooted
            if (RemotePath='/') and (sFTP.HomeDir<>'/') then
            begin
              Log(cINFOText + ' "/" in a sence of "homepath" witch is "'+string(sFTP.HomeDir)+'"');
              Log('>changedir ' + string(sFTP.HomeDir),false);
              sFTP.ChangeDir(sFTP.HomeDir)
            end else
            begin
              Log('>changedir ' + RemotePath,false);
              sFTP.ChangeDir(RemotePath);
            end;
           end;
 end;
end;

procedure TSolidFTP.Rename(FromName, ToName:string);
begin
 case Mode of
   Indy : iFTP.Rename(FromName, ToName);
   Putty : sFTP.Move(FromName, ToName);
 end;
end;

procedure TSolidFTP.Get(const ASourceFile, ADestFile: string; const ACanOverwrite: Boolean = False;
  AResume: Boolean = False);
var
 LogInfo : string;
begin
 LogInfo := '>get';
 if ACanOverwrite then
  LogInfo := LogInfo + ' +OVERWRITE';
 if AResume then
  LogInfo := LogInfo + ' +RESUME';
 Log(LogInfo+' ' + ASourceFile + ' ' + ADestFile);
 case Mode of
   Indy : iFTP.Get(ASourceFile, ADestFile, ACanOverwrite, AResume);
   Putty : sFTP.DownloadFile(ASourceFile, ADestFile, false);
 end;
end;

procedure TSolidFTP.Disconnect;
begin
 case Mode of
   Indy : iFTP.Disconnect;
   Putty : sFTP.Disconnect;
 end;
end;

procedure TSolidFTP.Abort;
begin
 case Mode of
   Indy : iFTP.Abort;
   Putty : sFTP.Aborted := true;
 end;
end;

procedure TSolidFTP.Delete(RemoteFName: string);
begin
 case Mode of
   Indy : iFTP.Delete(RemoteFName);
   Putty : sFTP.DeleteFile(RemoteFName);
 end;
end;

procedure TSolidFTP.Put(SourceFName, DestFName: string);
begin
 case Mode of
   Indy : iFTP.Put(SourceFName, DestFName);
   Putty : begin
             sFTP.UploadFile(SourceFName, DestFName, false);
             sFTP.SetUnixMode(DestFName, 438);
           end;
 end;
end;

procedure TSolidFTP.PutRestart(const ASourceFile, ADestFile: string; const StartPosition: int64);
begin
 case Mode of
   Indy : iFTP.PutRestart(ASourceFile, ADestFile, StartPosition);
   Putty : sFTP.UploadFile(ASourceFile, ADestFile, false);
 end;
end;

procedure TSolidFTP.CheckSetMode;
var
 ProtocolIdentifier : string;
begin
  if (Mode=Undecided) then
  begin

    Host := AnsiLowerCase(Host);
    if (pos(':',Host)>0) then
      ProtocolIdentifier := nextp(Host, ':')
    else
      ProtocolIdentifier := 'ftp';

    repeat

      if (ProtocolIdentifier='ftp') then
      begin
        Log('init Indy');
        Mode := Indy;
        iFTP := TidFTPRestart.create(nil);
        iFTP.Host := Host;
        iFTP.UserName := UserName;
        iFTP.Password := Password;
        with iFTP do
        begin
          Port := 21;
          Passive := true; // wichtig wegen NAT und Sicherheit
          PassiveUseControlHost := true; // dem PASV Befehl mistrauen
          TransferType := ftBinary; // wichtig wegen SIZE
          with ProxySettings do
          begin
            host := '';
            Port := 0;
            ProxyType := fpcmNone;
          end;
        end;
        break;
      end;

      if (ProtocolIdentifier='sftp') then
      begin
        Log('init Putty');
        Mode := Putty;
        sFTP := TTGPuttySFTP.Create(false);
        sFTP.HostName := Host;
        sFTP.UserName := UserName;
        sFTP.Password := Password;
        sFTP.Port := 22;
        with sFTP do
        begin
         OnMessage := putty_cb_Message;
         OnListing := putty_cb_lsOne;
         OnVerifyHostKey := putty_cb_verifyHostKey;
         ls := TStringList.Create;
          // more init
        end;
        break;
      end;

      if (ProtocolIdentifier='ftps') then
      begin
        Log('init Core');
        Mode := Core;
        break;
      end;

      raise Exception.Create('Unknown Protocol Identifier "'+ProtocolIdentifier+'"');

    until yet;

  end;
end;

function TSolidFTP.cdOne(DestPath: string): boolean;

var
  ActRetry: integer;

  function _logID: string;
  begin
    result := 'cd(' + host + ',' + UserName + ',' + DestPath + ')';
  end;

begin
  result := true;
  if (DestPath <> sActualServerWorkingDirectory) and (DestPath <> cSolidFTP_DirCurrent) then
  begin
    result := false;
    for ActRetry := 0 to Retries do
    begin
      if sTransactionFatalError then
       break;
      try

        // Verbindung sicherstellen
        if not(connected) then
          Login;

        //
        if (DestPath = '/') or (DestPath = '\') then
        begin
          ChangeDir('/');
        end
        else
        begin
          ChangeDir(ValidatePathNameFTP(DestPath));
        end;

        // Erfolg verbuchen!
        sActualServerWorkingDirectory := DestPath;
        result := true;
        break;

      except

        on E: EIdSocketError do
        begin
          Log(cEXCEPTIONText + ' [2173] Socket Error: ' + IntToStr(E.LastError));
          HandleException(ActRetry, _logID + ': ' + E.Message);
        end;

        on E: Exception do
        begin
          // Bei nicht existierendem Unterverzeichnis ist ein
          // nerviges Retry,Retry,Retry, sinnlos. Also sofortige
          // Aufgabe der Aktion ist nötig!
          sTransactionFatalError := true;
          Log(cEXCEPTIONText + ' [2179] ' + E.Message);
          HandleException(ActRetry, _logID + ': ' + E.Message);
        end;

      end;
    end;
  end;
end;

function TSolidFTP.HandleException(ActRetry: integer; sMsg: string): boolean;
var
 SleepTimeInSeconds : Integer;
begin
  // Status "Fatal - Give up" als default
  result := false;
  if (ActRetry >= Retries) then
  begin

    Log(cERRORText + ' ' + sMsg);
    try
      Log('>abort');
      Abort;
    except
      ;
    end;

    try
      Log('>disconnect');
      Disconnect;
    except

      on E: EIdSocketError do
      begin
        Log(cEXCEPTIONText + ' [250] Socket Error: ' + IntToStr(E.LastError), false);
      end;

      on E: Exception do
      begin
        Log(cEXCEPTIONText + ' [279] ' + E.ClassName + ':' + E.Message, false);
      end;

    end;
  end
  else
  begin
    Log(cWARNINGText + ' (n=' + IntToStr(ActRetry) + ') ' + sMsg);

    try
      Log('>abort');
      Abort;
    except
      ;
    end;

    try
      Log('>disconnect');
      Disconnect;
    except

      on E: EIdConnClosedGracefully do
      begin;
      end;

      on E: EIdSocketError do
      begin
        Log(cEXCEPTIONText + ' [2253] Socket Error: ' + IntToStr(E.LastError), false);
      end;

      on E: Exception do
      begin
        Log(cEXCEPTIONText + ' [2258] ' + E.ClassName + ':' + E.Message, false);
      end;

    end;

    // Sleep a bit, getting fit
    if not(sTransactionFatalError) then
    begin
      case ActRetry of
        0:
          SleepTimeInSeconds := 60;
        1:
          SleepTimeInSeconds := 60 * 2;
        2:
          SleepTimeInSeconds := 60 * 8;
      else
        SleepTimeInSeconds := 60;
      end;
      Log('sleep '+IntToStr(SleepTimeInSeconds));
      sleep(SleepTimeInSeconds*1000);
    end;
    result := true;
  end;
end;

function TSolidFTP.upOne(SourceFName, DestPath, DestFName: string): boolean;
var
  ActRetry: integer;
  s: Int64;

  function _logID: string;
  begin
    result := 'up(' + host + ',' + UserName + ',' + SourceFName + ',' + DestPath + ',' + DestFName + ')';
  end;

begin
  result := false;
  for ActRetry := 0 to Retries do
  begin
    if sTransactionFatalError then
      break;
    try

      // verbindung sicherstellen
      if not(connected) then
        Login;

      // Pfad sicherstellen!
      cdOne(DestPath);

      // temporäres Ziel ev. schon vorhanden? -> Löschen
      Log('>size ' + DestFName + cTmpFileExtension);
      s := Size(DestFName + cTmpFileExtension);
      Log(' ' + IntToStr(s));
      if (s >= 0) then
      begin
        Log(cWARNINGText + 'solidUpOne: ' + DestFName + cTmpFileExtension + ' gab es schon');
        Log('>delete ' + DestFName + cTmpFileExtension);
        Delete(DestFName + cTmpFileExtension);
      end;

      // Ziel hochladen!
      Log('>put ' + DestFName + cTmpFileExtension + ' 0');
      Put(SourceFName, DestFName + cTmpFileExtension);

      // Erfolg!
      result := true;
      break;

    except

      on E: EIdConnClosedGracefully do
      begin;
        result := true;
      end;

      on E: EIdSocketError do
      begin
        Log(cEXCEPTIONText + ' [2406] Socket Error: ' + IntToStr(E.LastError));
        if not(HandleException(ActRetry, _logID + ': ' + E.Message)) then
          result := false;
      end;

      on E: Exception do
      begin
        Log(cEXCEPTIONText + ' [2413] ' + E.Message);
        if not(HandleException(ActRetry, _logID + ': ' + E.Message)) then
          result := false;
      end;

    end;
  end;
end;

function TSolidFTP.commitOne(DestPath, DestFName: string; WarnIfAlreadyThere : boolean = true): boolean;
var
  ActRetry: integer;
  s : Int64;

  function _logID: string;
  begin
    result := 'commit(' + host + ',' + UserName + ',' + DestPath + ',' + DestFName + ')';
  end;

begin
  result := false;
  for ActRetry := 0 to Retries do
  begin
    if sTransactionFatalError then
      break;
    try
      // Verbindung sicherstellen
      if not(connected) then
        Login;

      // Pfad sicherstellen!
      cdOne(DestPath);

      Log('>size ' + DestFName + cTmpFileExtension);
      s := Size(DestFName + cTmpFileExtension);
      Log(' ' + IntToStr(s));
      if (s >= 0) then
      begin
        Log('>size ' + DestFName );
        s := Size(DestFName);
        Log(' ' + IntToStr(s));
        if (s >= 0) then
        begin
          if WarnIfAlreadyThere then
            Log(cWARNINGText + 'solidCommit: ' + DestFName + ' gab es bereits');
          Log('>delete ' + DestFName);
          Delete(DestFName);
        end;
        Log('>rename ' + DestFName + cTmpFileExtension + ' ' + DestFName);
        Rename(DestFName + cTmpFileExtension, DestFName);
        result := true;
      end
      else
      begin
        Log(cERRORText + 'solidCommit: ' + DestFName + cTmpFileExtension + ' verschwunden');
      end;

      break;

    except

      on E: EIdSocketError do
      begin
        Log(cEXCEPTIONText + ' [2467] Socket Error: ' + IntToStr(E.LastError));
        if not(HandleException(ActRetry, _logID + ': ' + E.Message)) then
          result := false;
      end;

      on E: Exception do
      begin
        Log(cEXCEPTIONText + ' [2474] ' + E.Message);
        if not(HandleException(ActRetry, _logID + ': ' + E.Message)) then
          result := false;
      end;

    end;
  end;
end;

function TSolidFTP.restartOne(SourceFName, DestPath, DestFName: string): boolean;
var
  ActRetry: integer;
  rSize, lSize: int64;

  function _logID: string;
  begin
    result := 'store(' + host + ',' + UserName + ',' + SourceFName + ',' + DestPath + ',' + DestFName + ')';
  end;

begin
  result := false;
  lSize := FSize(SourceFName);
  for ActRetry := 0 to Retries do
  begin
    if sTransactionFatalError then
      break;
    try

      // verbindung sicherstellen
      if not(connected) then
        Login;

      // Pfad sicherstellen!
      cdOne(DestPath);

      // Zwischenspeicher ev. vorhanden?
      Log('>size ' + DestFName + cTmpFileExtension);
      rSize := Size(DestFName + cTmpFileExtension);
      Log(' ' + IntTostr(rSize));
      if (rSize <> lSize) then
      begin

        repeat
          if (rSize = -1) then
          begin
            // Datei bisher unbekannt!
            Log('>put ' + DestFName + cTmpFileExtension + ' 0');
            Put(SourceFName, DestFName + cTmpFileExtension);
            break;
          end;

          if (rSize < lSize) then
          begin
            // Datei da, aber unvollständig
            Log('>put ' + DestFName + cTmpFileExtension + ' ' + IntToStr(rSize));
            PutRestart(SourceFName, DestFName + cTmpFileExtension, rSize);
            break;
          end;

          if (rSize = 0) or (rSize > lSize) then
          begin
            // Datei da, aber leer oder grösser als gewünscht
            Log('>delete ' + DestFName + cTmpFileExtension);
            Delete(DestFName + cTmpFileExtension);
            Log('>put ' + DestFName + cTmpFileExtension + ' 0');
            Put(SourceFName, DestFName + cTmpFileExtension);
            break;
          end;

        until yet;
      end;

      // Erfolg!
      result := true;
      break;

    except

      on E: EIdSocketError do
      begin
        Log(cEXCEPTIONText + ' [2636] Socket Error: ' + IntToStr(E.LastError));
        if not(HandleException(ActRetry, _logID + ': ' + E.Message)) then
          result := false;
      end;

      on E: Exception do
      begin
        Log(cEXCEPTIONText + ' [2643] ' + E.Message);
        if not(HandleException(ActRetry, _logID + ': ' + E.Message)) then
          result := false;
      end;

    end;
  end;
end;

function TSolidFTP.downOne(SourcePath, SourceFName, DestPath: string; RemoteDelete: boolean = false): boolean;

var
  ActRetry: integer;
  TmpPathAndFileName: string;

  function _logID: string;
  begin
    result := 'down(' + host + ',' + UserName + ',' + SourcePath + ',' + SourceFName + ',' + DestPath + ')';
  end;

begin
  result := false;
  for ActRetry := 0 to Retries do
  begin
    if sTransactionFatalError then
     break;
    try

      // Verbindung sicherstellen
      if not(connected) then
        Login;

      // Pfad sicherstellen!
      cdOne(SourcePath);

      // Weg freimachen für die neue Datei!
      if (DestPath <> '') then
      begin

        // Wir downloaden in einen TMP-File (.$$$)
        TmpPathAndFileName :=
        { } DestPath +
        { } SourceFName +
        { } cTmpFileExtension;

        // Gibt es den schon müssen wir uns einen neuen Dateinamen einfallen lassen (.~PWD~.$$$)
        if FileExists(TmpPathAndFileName) then
          TmpPathAndFileName :=
          { } DestPath +
          { } SourceFName + '.' +
          { } FindANewPassword +
          { } cTmpFileExtension;

        // Datei runterladen
        Get(SourceFName, TmpPathAndFileName, true);

        // alte Version der Datei vorhanden?
        if FileExists(DestPath + SourceFName) then
        begin
          Log('>delete ' + DestPath + SourceFName);
          FileDelete(DestPath + SourceFName);
        end;

        // alte Version immer noch vorhanden?
        if FileExists(DestPath + SourceFName) then
          raise Exception.Create('[1090] can not delete ' + DestPath + SourceFName);

        // Jetzt lokal umbenenen
        if not(RenameFile(TmpPathAndFileName, DestPath + SourceFName)) then
          raise Exception.Create('[1093] rename impossible ' + TmpPathAndFileName + ' to ' + DestPath + SourceFName);

        // alter noch da?
        if FileExists(TmpPathAndFileName) then
          raise Exception.Create('[1095] after rename still there ' + TmpPathAndFileName);

        // neuer nicht da?
        if not(FileExists(DestPath + SourceFName)) then
          raise Exception.Create('[1097] disappeared ' + DestPath + SourceFName);

      end;

      if RemoteDelete then
      begin
        Log('>delete ' + SourceFName);
        Delete(SourceFName);
      end;

      // Erfolg!
      result := true;
      break;

    except

      on E: EIdSocketError do
      begin
        Log(cEXCEPTIONText + ' [2955] Socket Error: ' + IntToStr(E.LastError));
        if not(HandleException(ActRetry, _logID + ': ' + E.Message)) then
          result := false;
      end;

      on E: Exception do
      begin
        Log(cEXCEPTIONText + ' [2962] ' + E.Message);
        if not(HandleException(ActRetry, _logID + ': ' + E.Message)) then
          result := false;
      end;

    end;
  end;
end;

function TSolidFTP.delOne(SourcePath, SourceFName: string): boolean;
var
  ActRetry: integer;

  function _logID: string;
  begin
    result := 'del(' + host + ',' + UserName + ',' + SourcePath + ',' + SourceFName + ')';
  end;

begin
  result := false;
  for ActRetry := 0 to Retries do
  begin
    if sTransactionFatalError then
      break;
    try

      // Verbindung sicherstellen
      if not(connected) then
        Login;

      // Pfad sicherstellen!
      cdOne(SourcePath);

      Log('>delete ' + SourceFName);
      Delete(SourceFName);

      // Erfolg!
      result := true;
      break;

    except

      on E: EIdSocketError do
      begin
        Log(cEXCEPTIONText + ' [3047] Socket Error: ' + IntToStr(E.LastError));
        if not(HandleException(ActRetry, _logID + ': ' + E.Message)) then
          result := false;
      end;

      on E: Exception do
      begin
        Log(cEXCEPTIONText + ' [3054] ' + E.Message);
        if not(HandleException(ActRetry, _logID + ': ' + E.Message)) then
          result := false;
      end;

    end;
  end;
end;

procedure TSolidFTP.putty_cb_Message(const Msg:AnsiString;const isstderr:Boolean);
var
 OutMsg : String;
 AllMsg, CheckMsg: String;
begin
 OutMsg := Msg;

 AllMsg := WatchOutMsg;
 repeat

   CheckMsg := nextp(AllMsg);
   if (CheckMsg='') then
    break;

   if (pos(CheckMsg,Msg)>0) then
   begin
    WatchOutMsgHit := true;
    WatchOutMsg := '';
    OutMsg := 'HIT: '+Msg;
    break;
   end;

 until eternity;

 if isstderr then
  Log(cERRORText+ ' ' +OutMsg)
 else
  Log(OutMsg);

 // Clear Lastmessages, already logged in all cases
 if (Mode=Putty) then
  if assigned(sFTP) then
   sFTP.LastMessages := '';
end;

function TSolidFTP.putty_cb_verifyHostkey(const host:PAnsiChar;const port:Integer;
                               const fingerprint:PAnsiChar;
                               const verificationstatus:Integer;
                               var storehostkey:Boolean):Boolean;
begin
  Log('verify '+host+':'+IntToStr(Port));
  Log('fingerprint is '+fingerprint);
  storehostkey := true;
  result := true;
end;

function TSolidFTP.putty_cb_lsOne(const names:Pfxp_names):Boolean;
var
  n : Integer;
begin
  result := true;
  for n := 0 to pred(names^.nnames) do
    ls.add(Utf8ToString(Pfxp_name_array(names^.names)^[n].filename));
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
    CoreFTPLogFName := SolidFTP_LogDir + 'CoreFTP-' + DatumLog + cLogExtension;

    CommandL := CommandL + ' -log ' + CoreFTPLogFName;
    AppendStringsToFile(uhr8 + ': { ' + CommandL, CoreFTPLogFName);
  end;

  if (sUpFiles.Count > 0) then
{$IFDEF fpc}
    CoreFTPExitCode := $FFFFFFFF
{$ELSE}
    CoreFTPExitCode := CallExternalApp(CommandL, SW_SHOWNORMAL)
{$ENDIF}
  else
    CoreFTPExitCode := 0;

  // Log ?!
  if (SolidFTP_LogDir <> '') then
  begin
    if (sUpFiles.Count = 0) then
    begin
      AppendStringsToFile(cWARNINGText + ' Keine Dateien gefunden!', CoreFTPLogFName);
    end
    else
    begin
      // Die Log Datei nach der Anzahl der dateien absuchen
      sLog := TStringList.Create;
      sLog.LoadFromFile(CoreFTPLogFName);
      for n := pred(sLog.Count) downto 0 do
        if pos(cCoreFTP_MsgUploadedFiles, sLog[n]) = 1 then
        begin
          AnzahlErfolgreicherUploads := StrToIntDef(noblank(nextp(sLog[n], ':', 1)), 0);
          break;
        end;
      sLog.free;
    end;
    if (AnzahlErfolgreicherUploads <> sUpFiles.Count) then
      AppendStringsToFile(cERRORText + format('Nur %d/%d Uploads!', [AnzahlErfolgreicherUploads, sUpFiles.Count]),
        CoreFTPLogFName);

    AppendStringsToFile(format('%s: CoreFTPExitCode:%d }', [uhr8, CoreFTPExitCode]), CoreFTPLogFName);
  end;

  result := (CoreFTPExitCode <> Cardinal($FFFFFFFF)) and (AnzahlErfolgreicherUploads = sUpFiles.Count);
  sUpFiles.free;
end;

end.
