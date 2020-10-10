// Pascal Units Written and Copyright 2019 by Tobias Giesen

// License: same as putty, can be freely copied, modified and
// used for both open source and closed source commercial projects
unit tgputtysftp;

{$ifdef FPC}{$MODE Delphi}{$endif}

interface

uses {$ifdef SFFS}TGGlobal,Basics,{$endif}
     {$ifdef MSWINDOWS}Windows,{$endif}
     Classes, SysUtils, DateUtils, SyncObjs,
     tgputtylib;

{$ifndef FPC}
{$ifdef CONDITIONALEXPRESSIONS}
{$if CompilerVersion >= 27.0}
{$define HASUTCPARAM}
{$ifend}
{$endif}
{$endif}

const MinimumLibraryBuildNum=8;
      cDummyClearedErrorCode=-1000; // this error code means there was no real error code

      cConfCount=84; // 84 since PuTTY version 0.74, previously 83
      cDumpSettingsFile=false;

type TGPuttySFTPException=class(Exception);

     TOnMessage=procedure(const Msg:AnsiString;const isstderr:Boolean) of object;
     TOnProgress=function(const bytescopied:Int64;const isupload:Boolean):Boolean of object;
     TOnListing=function(const names:Pfxp_names):Boolean of object;
     TOnGetInput=function(var cancel:Boolean):AnsiString of object;
     TOnVerifyHostKey=function(const host:PAnsiChar;const port:Integer;
                               const fingerprint:PAnsiChar;
                               const verificationstatus:Integer;
                               var storehostkey:Boolean):Boolean of object;

     TConfIntArray=array[0..cConfCount-1] of Integer;
     TConfPAnsiCharArray=array[0..cConfCount-1] of PAnsiChar;

     PConfIntArray=^TConfIntArray;
     PConfPAnsiCharArray=^TConfPAnsiCharArray;

     { TTGPuttySFTP }

     TTGPuttySFTP=class(TObject)
       private
         Fcontext:TTGLibraryContext;
         FVerbose:Boolean;
         FHostName,FUserName,FPassword,FKeyPassword:AnsiString;
         FPort:Integer;
         FOnMessage: TOnMessage;
         FOnProgress: TOnProgress;
         FOnListing: TOnListing;
         FOnGetInput: TOnGetInput;
         FOnVerifyHostKey: TOnVerifyHostKey;
         FUploadStream,
         FDownloadStream:TStream;
         FConnected:Boolean;
         FPasswordAttempts:Integer;
         FLastMessages:AnsiString;
         FConfNames:PConfPAnsiCharArray;
         FConfTypes:PConfIntArray;
         FConfSubTypes:PConfIntArray;
         FConfCount:Integer;
         function GetHomeDir: AnsiString;
         function GetWorkDir: AnsiString;
         procedure SetVerbose(const Value: Boolean);
         procedure SetKeyfile(const Value: AnsiString);
         function GetLibVersion: AnsiString;
         function GetErrorCode: Integer;
         function GetErrorMessage: AnsiString;
         function GetAborted: Boolean;
         function GetConnectionTimeoutTicks: Integer;
         function GetTimeoutTicks: Integer;
         procedure SetAborted(const Value: Boolean);
         procedure SetConnectionTimeoutTicks(const Value: Integer);
         procedure SetTimeoutTicks(const Value: Integer);
         procedure DumpSettingsFile;
         procedure CreateConfigIndex;
         function GetProxyType: TProxyTypes;
         function GetProxyHost: AnsiString;
         function GetProxyPassword: AnsiString;
         function GetProxyUserName: AnsiString;
         function GetProxyPort: Integer;
         procedure SetProxyType(const Value: TProxyTypes);
         procedure SetProxyHost(const Value: AnsiString);
         procedure SetProxyPassword(const Value: AnsiString);
         procedure SetProxyUserName(const Value: AnsiString);
         procedure SetProxyPort(const Value: Integer);
       public
         constructor Create(const verbose:Boolean);
         destructor Destroy; override;

         function MakePSFTPErrorMsg(const where:string):string;
         function GetPuttyConfIndex(const name:string):Integer;

         procedure Connect;
         procedure Disconnect;

         procedure ChangeDir(const ADirectory:AnsiString);
         procedure MakeDir(const ADirectory:AnsiString);
         procedure RemoveDir(const ADirectory:AnsiString);
         procedure ListDir(const ADirectory:AnsiString);

         procedure GetStat(const AFileName:AnsiString;out Attrs:fxp_attrs);
         procedure SetStat(const AFileName:AnsiString;const Attrs:fxp_attrs);
         procedure SetModifiedDate(const AFileName:AnsiString;const ATimestamp:TDateTime; const isUTC:Boolean);
         procedure SetFileSize(const AFileName:AnsiString;const ASize:Int64);
         procedure SetUnixMode(const AFileName:AnsiString;const AMode:Integer);
         procedure Move(const AFromName,AToName:AnsiString);
         procedure MoveEx(const AFromName,AToName:AnsiString;const MoveFlags:Integer);
         procedure DeleteFile(const AName:AnsiString);

         procedure UploadFile(const ALocalFilename,ARemoteFilename:AnsiString;const anAppend:Boolean);
         procedure DownloadFile(const ARemoteFilename,ALocalFilename:AnsiString;const anAppend:Boolean);

         procedure UploadStream(const ARemoteFilename:AnsiString;const AStream:TStream; const anAppend:Boolean);
         procedure DownloadStream(const ARemoteFilename:AnsiString;const AStream:TStream; const anAppend:Boolean);

         function OpenFile(const apathname:AnsiString;
                           const anopenflags:Integer;
                           const attrs:Pfxp_attrs):TSFTPFileHandle;
         function CloseFile(var fh:TSFTPFileHandle):Integer;

         function xfer_upload_init(const fh:TSFTPFileHandle;const offset:UInt64):TSFTPTransfer;
         function xfer_upload_ready(const xfer:TSFTPTransfer):Boolean;
         procedure xfer_upload_data(const xfer:TSFTPTransfer;const buffer:Pointer;
                                    const len:Integer;const anoffset:UInt64);
         function xfer_ensuredone(const xfer:TSFTPTransfer):Boolean;
         function xfer_done(const xfer:TSFTPTransfer):Boolean;
         procedure xfer_cleanup(const xfer:TSFTPTransfer);

         procedure SetBooleanConfigValue(const OptionName:AnsiString;const OptionValue:Boolean);

         property HostName:AnsiString read FHostName write FHostName;
         property UserName:AnsiString read FUserName write FUserName;
         property Port:Integer read FPort write FPort;
         property Password:AnsiString read FPassword write FPassword;
         property KeyPassword:AnsiString read FKeyPassword write FKeyPassword;

         property HomeDir:AnsiString read GetHomeDir;
         property WorkDir:AnsiString read GetWorkDir;
         property LibVersion:AnsiString read GetLibVersion;

         property Connected:Boolean read FConnected;
         property Verbose:Boolean read FVerbose write SetVerbose;
         property Keyfile:AnsiString write SetKeyfile;
         property LastMessages:AnsiString read FLastMessages write FLastMessages;
         property ErrorCode:Integer read GetErrorCode;
         property ErrorMessage:AnsiString read GetErrorMessage;
         property TimeoutTicks:Integer read GetTimeoutTicks write SetTimeoutTicks;
         property ConnectionTimeoutTicks:Integer read GetConnectionTimeoutTicks write SetConnectionTimeoutTicks;
         property Aborted:Boolean read GetAborted write SetAborted;

         property ProxyType:TProxyTypes read GetProxyType write SetProxyType;
         property ProxyHost:AnsiString read GetProxyHost write SetProxyHost;
         property ProxyPort:Integer read GetProxyPort write SetProxyPort;
         property ProxyUserName:AnsiString read GetProxyUserName write SetProxyUserName;
         property ProxyPassword:AnsiString read GetProxyPassword write SetProxyPassword;

         property OnMessage:TOnMessage read FOnMessage write FOnMessage;
         property OnProgress:TOnProgress read FOnProgress write FOnProgress;
         property OnListing:TOnListing read FOnListing write FOnListing;
         property OnGetInput:TOnGetInput read FOnGetInput write FOnGetInput;
         property OnVerifyHostKey:TOnVerifyHostKey read FOnVerifyHostKey write FOnVerifyHostKey;
       end;

function tgputtysftp_version : string;

implementation

var GPuttyConfigIndex:tStringList;
    GPuttyConfigCS:TCriticalSection;

function ls_callback(const names:Pfxp_names;const libctx:PTGLibraryContext):Boolean; cdecl;
var TGPSFTP:TTGPuttySFTP;
begin
  TGPSFTP:=TTGPuttySFTP(libctx.Tag);
  if Assigned(TGPSFTP.OnListing) then
     Result:=TGPSFTP.OnListing(names)
  else
     Result:=true;
  end;

function getpassword_callback(const prompt:PAnsiChar;const echo:Boolean;const cancel:System.PBoolean;const libctx:PTGLibraryContext):PAnsiChar; cdecl;
var TGPSFTP:TTGPuttySFTP;
begin
  Result:=nil;
  TGPSFTP:=TTGPuttySFTP(libctx.Tag);
  Inc(TGPSFTP.FPasswordAttempts);
  if TGPSFTP.FPasswordAttempts>3 then begin
     cancel^:=true;
     if Assigned(TGPSFTP.OnMessage) then
        TGPSFTP.OnMessage(AnsiString('Password was rejected, or no password given for ')+prompt+AnsiString('.')+sLineBreak,true);
     end
  else begin
    if System.Pos(AnsiString('Passphrase for key'),AnsiString(prompt))>0 then
       Result:=PAnsiChar(TGPSFTP.KeyPassword)
    else
       Result:=PAnsiChar(TGPSFTP.Password);
    cancel^:=false;
    end;
  end;

procedure printmessage_callback(const msg:PAnsiChar;const isstderr:Boolean;const libctx:PTGLibraryContext); cdecl;
var TGPSFTP:TTGPuttySFTP;
begin
  TGPSFTP:=TTGPuttySFTP(libctx.Tag);
  if Assigned(TGPSFTP.OnMessage) then
     TGPSFTP.OnMessage(msg,isstderr);
  TGPSFTP.LastMessages:=TGPSFTP.LastMessages+msg;
  end;

function progress_callback(const bytescopied:Int64;const isupload:Boolean;const libctx:PTGLibraryContext):Boolean; cdecl;
var TGPSFTP:TTGPuttySFTP;
begin
  TGPSFTP:=TTGPuttySFTP(libctx.Tag);
  if Assigned(TGPSFTP.OnProgress) then
     Result:=TGPSFTP.OnProgress(bytescopied,isupload)
  else
     Result:=true;
  end;

function get_input_callback(linebuf:PAnsiChar;const maxchars:Integer;const libctx:PTGLibraryContext):Boolean; cdecl;
var line:AnsiString;
    TGPSFTP:TTGPuttySFTP;
    cancel:Boolean;
begin
  TGPSFTP:=TTGPuttySFTP(libctx.Tag);
  cancel:=false;

  if Assigned(TGPSFTP.OnGetInput) then begin
     line:=TGPSFTP.OnGetInput(cancel);
     Result:=not cancel;
     end
  else
     try
       Write('Your Input: ');
       ReadLn(line);
       Result:=true;
       except
         raise Exception.Create('No input method available');
       end;

  if Result then begin
     if Length(line)>maxchars then
        SetLength(line,maxchars);
     if line>'' then begin
        Move(line[1],linebuf^,maxchars);
        linebuf[Length(line)]:=#0;
        end
     else
        linebuf^:=#0;
     end;
  end;

function read_from_stream(const offset:UInt64;const buffer:Pointer;const bufsize:Integer;const libctx:PTGLibraryContext):Integer; cdecl;
var TGPSFTP:TTGPuttySFTP;
begin
  TGPSFTP:=TTGPuttySFTP(libctx.Tag);
  if Assigned(TGPSFTP.FUploadStream) then begin
     TGPSFTP.FUploadStream.Position:=Offset;
     Result:=TGPSFTP.FUploadStream.Read(buffer^,bufsize);
     end
  else
     Result:=0;
  end;

function write_to_stream(const offset:UInt64;const buffer:Pointer;const bufsize:Integer;const libctx:PTGLibraryContext):Integer; cdecl;
var TGPSFTP:TTGPuttySFTP;
begin
  TGPSFTP:=TTGPuttySFTP(libctx.Tag);
  if Assigned(TGPSFTP.FDownloadStream) then begin
     TGPSFTP.FDownloadStream.Position:=Offset;
     Result:=TGPSFTP.FDownloadStream.Write(buffer^,bufsize);
     if Assigned(TGPSFTP.OnProgress) then
        TGPSFTP.OnProgress(Offset+bufsize,false);
     end
  else
     Result:=0;
  end;

procedure raise_exception_callback(const msg:PAnsiChar;const srcfile:PAnsiChar;const line:Integer;const libctx:PTGLibraryContext); cdecl;
begin
{$ifdef SFFS}
  if IndyLogging then begin
     WriteLn(IndyLog,'NOW RAISING TTGPuttySFTP exception '+AnsiString(msg)+' at line '+IntToStr(line)+' in '+AnsiString(srcfile));
     CloseFile(IndyLog);
     Append(IndyLog);
     if Logging then begin
        WriteLn(LogFile,'NOW RAISING TTGPuttySFTP exception '+AnsiString(msg)+' at line '+IntToStr(line)+' in '+AnsiString(srcfile));
        CloseFile(LogFile);
        Append(LogFile);
        end;
     end;
{$endif}
  raise TGPuttySFTPException.Create('TTGPuttySFTP exception '+
                                    {$ifdef UNICODE}Utf8ToString{$endif}(AnsiString(msg))+
                                    ' at line '+
                                    IntToStr(line)+
                                    ' in '+
                                    {$ifdef UNICODE}Utf8ToString{$endif}(AnsiString(srcfile)));
  end;

function verify_host_key_callback(const host:PAnsiChar;const port:Integer;const keytype:PAnsiChar;
                                  const keystr:PAnsiChar;const fingerprint:PAnsiChar;
                                  const verificationstatus:Integer;const storehostkey:System.PBoolean;
                                  const libctx:PTGLibraryContext):Boolean; cdecl;
var TGPSFTP:TTGPuttySFTP;
begin
  TGPSFTP:=TTGPuttySFTP(libctx.Tag);
  if Assigned(TGPSFTP.OnVerifyHostKey) then
     Result:=TGPSFTP.OnVerifyHostKey(host,port,fingerprint,verificationstatus,storehostkey^)
  else
     Result:=false;
  end;

{ TTGPuttySFTP }

procedure TTGPuttySFTP.ChangeDir(const ADirectory: AnsiString);
var res:Integer;
begin
  FLastMessages:='';
  Fcontext.fxp_errtype:=cDummyClearedErrorCode; // "clear" error field
  res:=tgsftp_cd(PAnsiChar(ADirectory),@Fcontext);
  if res<>1 then // 1 = success
     raise TGPuttySFTPException.Create(MakePSFTPErrorMsg('tgsftp_cd'));
  end;

function TTGPuttySFTP.CloseFile(var fh: TSFTPFileHandle): Integer;
begin
  Result:=tgputty_closefile(@fh,@Fcontext);
  end;

procedure TTGPuttySFTP.Connect;
var res:Integer;
begin
  FPasswordAttempts:=0;
  FLastMessages:='';
  Fcontext.fxp_errtype:=cDummyClearedErrorCode; // "clear" error field
  res:=tgsftp_connect(PAnsiChar(FHostName),PAnsiChar(FUserName),FPort,PAnsiChar(FPassword),@Fcontext);
  FConnected:=res=0; // 0 = success
  if not FConnected then
     raise TGPuttySFTPException.Create(MakePSFTPErrorMsg('tgsftp_connect'));
  end;

constructor TTGPuttySFTP.Create(const verbose:Boolean);
var puttyversion:Double;
    tgputtylibbuild:Integer;
begin
  if not TGPuttyLibAvailable then
     raise Exception.Create('TGPuttyLib is not available');
  tgputtygetversions(@puttyversion,@tgputtylibbuild);
  if tgputtylibbuild<MinimumLibraryBuildNum then
     raise Exception.Create('tgputtylib is too old, its build number is '+
                             IntToStr(tgputtylibbuild)+
                            ', but we need a minimum of '+IntToStr(MinimumLibraryBuildNum));

  Fcontext.Init;
  FVerbose:=verbose;

  Fcontext.structsize:=sizeof(Fcontext);
  if Fcontext.structsize<tggetlibrarycontextsize then
     raise Exception.Create('Incorrect TTGLibraryContext record size');
  Fcontext.Tag:=UInt64(NativeUInt(self));
  Fcontext.ls_callback:=ls_callback;
  Fcontext.getpassword_callback:=getpassword_callback;
  Fcontext.printmessage_callback:=printmessage_callback;
  Fcontext.progress_callback:=progress_callback;
  Fcontext.read_from_stream:=read_from_stream;
  Fcontext.write_to_stream:=write_to_stream;
  Fcontext.get_input_callback:=get_input_callback;
  Fcontext.raise_exception_callback:=raise_exception_callback;
  Fcontext.verify_host_key_callback:=verify_host_key_callback;

  if tgputty_initcontext(verbose,@Fcontext)<>0 then
     raise TGPuttySFTPException.Create('tgputty_initcontext failed - incorrect tgputtylib version?');

  if not tgputty_getconfigarrays(@FConfTypes,@FConfSubTypes,@FConfNames,@FConfCount) then
     raise TGPuttySFTPException.Create('tgputty_getconfigarrays failed - incorrect tgputtylib version?');

  if FConfCount<>cConfCount then
     printmessage_callback(PAnsiChar(AnsiString('Possibly tgputtylib version mismatch, it has ')+
                            AnsiString(IntToStr(FConfCount))+
                            AnsiString(' config strings, but we expected ')+
                            AnsiString(IntToStr(cConfCount))),false,@Fcontext);

  if cDumpSettingsFile then
     DumpSettingsFile;

  CreateConfigIndex;
  end;

procedure TTGPuttySFTP.CreateConfigIndex;
var i:Integer;
begin
  GPuttyConfigCS.Enter;
  try
    if not Assigned(GPuttyConfigIndex) then begin
       GPuttyConfigIndex:=tStringList.Create;
       GPuttyConfigIndex.Sorted:=true;
       for i:=0 to FConfCount-1 do
         GPuttyConfigIndex.AddObject(string(FConfNames[i]),TObject(NativeUInt(i)));
       end;
    finally
      GPuttyConfigCS.Leave;
    end;
  end;

procedure TTGPuttySFTP.DeleteFile(const AName: AnsiString);
var res:Integer;
begin
  FLastMessages:='';
  Fcontext.fxp_errtype:=cDummyClearedErrorCode; // "clear" error field
  res:=tgsftp_rm(PAnsiChar(AName),@Fcontext);
  if res<>1 then // 1 = success
     raise TGPuttySFTPException.Create(MakePSFTPErrorMsg('tgsftp_rm'));
  end;

destructor TTGPuttySFTP.Destroy;
begin
  Disconnect;
  tgputtyfree(@Fcontext);
  inherited;
  end;

procedure TTGPuttySFTP.Disconnect;
begin
  if FConnected then begin
     tgsftp_close(@Fcontext);
     FConnected:=false;
     end;
  end;

procedure TTGPuttySFTP.DownloadFile(const ARemoteFilename, ALocalFilename: AnsiString; const anAppend: Boolean);
var res:Integer;
begin
  FLastMessages:='';
  Fcontext.fxp_errtype:=cDummyClearedErrorCode; // "clear" error field
  res:=tgsftp_getfile(PAnsiChar(ARemoteFilename),PAnsiChar(ALocalFilename),anAppend,@Fcontext);
  if res<>1 then
     raise TGPuttySFTPException.Create(MakePSFTPErrorMsg('tgsftp_getfile'));
  end;

procedure TTGPuttySFTP.DownloadStream(const ARemoteFilename: AnsiString; const AStream: TStream; const anAppend: Boolean);
var res:Integer;
begin
  FLastMessages:='';
  FDownloadStream:=AStream;
  Fcontext.fxp_errtype:=cDummyClearedErrorCode; // "clear" error field
  try
    res:=tgsftp_getfile(PAnsiChar(ARemoteFilename),nil,anAppend,@Fcontext);
    if res<>1 then
       raise TGPuttySFTPException.Create(MakePSFTPErrorMsg('tgsftp_getfile'));
    finally
      FDownloadStream:=nil;
    end;
  end;

procedure TTGPuttySFTP.DumpSettingsFile;
var T:System.Text;
    i:Integer;
begin
  AssignFile(T,'C:\TEMP\TGPuttyLibSettings.pas');
  Rewrite(T);
  WriteLn(T,'const');
  for i:=0 to FConfCount-1 do begin
    Write(T,'      cPuttyConf_',FConfNames[i],'=''',FConfNames[i],'''; // ',txtPuttyConfTypes[FConfTypes[i]]);
    try
      if FConfSubTypes[i]>0 then
         WriteLn(T,' [',txtPuttyConfTypes[FConfTypes[i]],']') //  default ',tgputty_conf_get_int_int(i,0))
      else
        try
          case FConfTypes[i] of
            TYPE_BOOL : WriteLn(T,' default ',tgputty_conf_get_bool(i,@FContext));
            TYPE_INT  : WriteLn(T,' default ',tgputty_conf_get_int(i,@FContext));
            TYPE_STR  : WriteLn(T,' default ''',tgputty_conf_get_str(i,@FContext),'''');
            else
              WriteLn(T);
            end;
          except
            WriteLn(T); // no default value
          end;
      except
        on E:Exception do
           WriteLn(T,' Exception: ',E.Message);
      end;
    end;
  System.Close(T);
  end;

function TTGPuttySFTP.GetAborted: Boolean;
begin
  Result:=Fcontext.aborted;
  end;

function TTGPuttySFTP.GetConnectionTimeoutTicks: Integer;
begin
  Result:=Fcontext.connectiontimeoutticks;
  end;

function TTGPuttySFTP.GetErrorCode: Integer;
begin
  Result:=Fcontext.fxp_errtype;
  end;

function TTGPuttySFTP.GetErrorMessage: AnsiString;
begin
  Result:=Fcontext.fxp_error_message;
  end;

function TTGPuttySFTP.GetHomeDir: AnsiString;
begin
  Result:=Fcontext.homedir;
  end;

function TTGPuttySFTP.GetLibVersion: AnsiString;
var puttyversion:Double;
    tgputtylibbuild:Integer;
    strpv:AnsiString;
begin
  tgputtygetversions(@puttyversion,@tgputtylibbuild);
  Str(puttyversion:0:2,strpv);
  Result:=AnsiString('tgputtylib build ')+AnsiString(IntToStr(tgputtylibbuild))+AnsiString(' based on PuTTY Release ')+strpv;
  end;

function TTGPuttySFTP.GetProxyHost: AnsiString;
begin
  Result:=tgputty_conf_get_str(GetPuttyConfIndex(cPuttyConf_proxy_host),@FContext);
  end;

function TTGPuttySFTP.GetProxyPassword: AnsiString;
begin
  Result:=tgputty_conf_get_str(GetPuttyConfIndex(cPuttyConf_proxy_password),@FContext);
  end;

function TTGPuttySFTP.GetProxyPort: Integer;
begin
  Result:=tgputty_conf_get_int(GetPuttyConfIndex(cPuttyConf_proxy_port),@FContext);
  end;

function TTGPuttySFTP.GetProxyType: TProxyTypes;
begin
  Result:=TProxyTypes(tgputty_conf_get_int(GetPuttyConfIndex(cPuttyConf_proxy_type),@FContext));
  end;

function TTGPuttySFTP.GetProxyUserName: AnsiString;
begin
  Result:=tgputty_conf_get_str(GetPuttyConfIndex(cPuttyConf_proxy_username),@FContext);
  end;

function TTGPuttySFTP.GetPuttyConfIndex(const name: string): Integer;
var idx:Integer;
begin
  idx:=GPuttyConfigIndex.IndexOf(name);
  if idx<0 then
     raise TGPuttySFTPException.Create('Putty Conf Name Not Found: '+name);
  Result:=NativeUInt(GPuttyConfigIndex.Objects[idx]);
  end;

procedure TTGPuttySFTP.GetStat(const AFileName: AnsiString;out Attrs: fxp_attrs);
begin
  FLastMessages:='';
  Fcontext.fxp_errtype:=cDummyClearedErrorCode; // "clear" error field
  if not tgsftp_getstat(PAnsiChar(AFileName),@Attrs,@Fcontext) then
     raise TGPuttySFTPException.Create(MakePSFTPErrorMsg('tgsftp_getstat'));
  end;

function TTGPuttySFTP.GetTimeoutTicks: Integer;
begin
  Result:=Fcontext.timeoutticks;
  end;

function TTGPuttySFTP.GetWorkDir: AnsiString;
begin
  Result:=Fcontext.pwd;
  end;

procedure TTGPuttySFTP.ListDir(const ADirectory: AnsiString);
var res:Integer;
begin
  FLastMessages:='';
  Fcontext.fxp_errtype:=cDummyClearedErrorCode; // "clear" error field
  res:=tgsftp_ls(PAnsiChar(ADirectory),@Fcontext);
  if res<>1 then
     raise TGPuttySFTPException.Create(MakePSFTPErrorMsg('tgsftp_ls'));
  end;

procedure TTGPuttySFTP.MakeDir(const ADirectory: AnsiString);
var res:Integer;
begin
  FLastMessages:='';
  Fcontext.fxp_errtype:=cDummyClearedErrorCode; // "clear" error field
  res:=tgsftp_mkdir(PAnsiChar(ADirectory),@Fcontext);
  if res<>1 then // 1 = success
     raise TGPuttySFTPException.Create(MakePSFTPErrorMsg('tgsftp_mkdir'));
  end;

function TTGPuttySFTP.MakePSFTPErrorMsg(const where: string): string;
begin
  if Fcontext.fxp_errtype>=0 then
     Result:=where+': Error '+IntToStr(Fcontext.fxp_errtype)+', '+{$ifdef UNICODE}Utf8ToString{$endif}(Fcontext.fxp_error_message)
  else
     Result:=where+': Unknown Error.'+sLineBreak+{$ifdef UNICODE}Utf8ToString{$endif}(LastMessages);
  end;

procedure TTGPuttySFTP.Move(const AFromName, AToName: AnsiString);
var res:Integer;
begin
  FLastMessages:='';
  Fcontext.fxp_errtype:=cDummyClearedErrorCode; // "clear" error field
  res:=tgsftp_mv(PAnsiChar(AFromName),PAnsiChar(AToName),@Fcontext);
  if res<>1 then // 1 = success
     raise TGPuttySFTPException.Create(MakePSFTPErrorMsg('tgsftp_mv'));
  end;

procedure TTGPuttySFTP.MoveEx(const AFromName, AToName: AnsiString; const MoveFlags: Integer);
var res:Integer;
begin
  FLastMessages:='';
  Fcontext.fxp_errtype:=cDummyClearedErrorCode; // "clear" error field
  res:=tgsftp_mvex(PAnsiChar(AFromName),PAnsiChar(AToName),MoveFlags,@Fcontext);
  if res<>1 then // 1 = success
     raise TGPuttySFTPException.Create(MakePSFTPErrorMsg('tgsftp_mvex'));
  end;

function TTGPuttySFTP.OpenFile(const apathname: AnsiString; const anopenflags: Integer; const attrs: Pfxp_attrs): TSFTPFileHandle;
begin
  Result:=tgputty_openfile(PAnsiChar(apathname),anopenflags,attrs,@Fcontext);
  end;

procedure TTGPuttySFTP.RemoveDir(const ADirectory: AnsiString);
var res:Integer;
begin
  FLastMessages:='';
  Fcontext.fxp_errtype:=cDummyClearedErrorCode; // "clear" error field
  res:=tgsftp_rmdir(PAnsiChar(ADirectory),@Fcontext);
  if res<>1 then // 1 = success
     raise TGPuttySFTPException.Create(MakePSFTPErrorMsg('tgsftp_rmdir'));
  end;

procedure TTGPuttySFTP.SetAborted(const Value: Boolean);
begin
  Fcontext.aborted:=Value;
  end;

procedure TTGPuttySFTP.SetConnectionTimeoutTicks(const Value: Integer);
begin
  Fcontext.connectiontimeoutticks:=Value;
  end;

procedure TTGPuttySFTP.SetFileSize(const AFileName: AnsiString; const ASize: Int64);
var Attrs:fxp_attrs;
begin
  GetStat(AFileName,Attrs);
  attrs.flags := SSH_FILEXFER_ATTR_SIZE; // set only this
  attrs.size:=ASize;
  SetStat(AFileName,Attrs);
  end;

procedure TTGPuttySFTP.SetKeyfile(const Value: AnsiString);
begin
  tgputty_setkeyfile(PAnsiChar(Value),@Fcontext);
  end;

{$if defined(MSWINDOWS) and not defined(FPC) and not defined(HASUTCPARAM)}
function GetBias:Integer;
var Info: TTimeZoneInformation;
begin
  Case GetTimeZoneInformation(Info) of
    TIME_ZONE_ID_UNKNOWN:
       Result:=Info.Bias;
    TIME_ZONE_ID_DAYLIGHT:
       Result:=Info.Bias+Info.DaylightBias;
    TIME_ZONE_ID_STANDARD:
       Result:=Info.Bias+Info.StandardBias;
    else begin
      Result:=0;
      Exit;
      end;
    end;
  end;
{$ifend}


procedure TTGPuttySFTP.SetModifiedDate(const AFileName: AnsiString;const ATimestamp: TDateTime; const isUTC:Boolean);
var Attrs:fxp_attrs;
    unixtime:Int64;
begin
  GetStat(AFileName,Attrs);
  attrs.flags := SSH_FILEXFER_ATTR_ACMODTIME; // set only this
  {$ifdef FPC}
  if isUTC then
     unixtime:=DateTimeToUnix(ATimestamp)
  else
     unixtime:=DateTimeToUnix(LocalTimeToUniversal(ATimestamp));
  {$else}
  {$ifdef HASUTCPARAM}
  unixtime:=DateTimeToUnix(ATimestamp,isUTC);
  {$else}
  if isUTC then
     unixtime:=DateTimeToUnix(ATimestamp)
  else
     unixtime:=DateTimeToUnix(ATimestamp+GetBias);
  {$endif}
  {$endif}
  if unixtime>=0 then
     attrs.mtime:=unixtime
  else
     attrs.mtime:=0;
  SetStat(AFileName,Attrs);
  end;

procedure TTGPuttySFTP.SetProxyHost(const Value: AnsiString);
begin
  tgputty_conf_set_str(GetPuttyConfIndex(cPuttyConf_proxy_host),PAnsiChar(Value),@FContext);
  end;

procedure TTGPuttySFTP.SetProxyPassword(const Value: AnsiString);
begin
  tgputty_conf_set_str(GetPuttyConfIndex(cPuttyConf_proxy_password),PAnsiChar(Value),@FContext);
  end;

procedure TTGPuttySFTP.SetProxyPort(const Value: Integer);
begin
  tgputty_conf_set_int(GetPuttyConfIndex(cPuttyConf_proxy_port),ord(Value),@FContext);
  end;

procedure TTGPuttySFTP.SetProxyType(const Value: TProxyTypes);
begin
  tgputty_conf_set_int(GetPuttyConfIndex(cPuttyConf_proxy_type),ord(Value),@FContext);
  end;

procedure TTGPuttySFTP.SetProxyUserName(const Value: AnsiString);
begin
  tgputty_conf_set_str(GetPuttyConfIndex(cPuttyConf_proxy_username),PAnsiChar(Value),@FContext);
  end;

procedure TTGPuttySFTP.SetStat(const AFileName: AnsiString;const Attrs: fxp_attrs);
begin
  FLastMessages:='';
  Fcontext.fxp_errtype:=cDummyClearedErrorCode; // "clear" error field
  if not tgsftp_setstat(PAnsiChar(AFileName),@Attrs,@Fcontext) then
     raise TGPuttySFTPException.Create(MakePSFTPErrorMsg('tgsftp_setstat'));
  end;

procedure TTGPuttySFTP.SetTimeoutTicks(const Value: Integer);
begin
  Fcontext.timeoutticks:=Value;
  end;

procedure TTGPuttySFTP.SetUnixMode(const AFileName: AnsiString; const AMode: Integer);
var Attrs:fxp_attrs;
begin
  GetStat(AFileName,Attrs);
  attrs.flags := SSH_FILEXFER_ATTR_PERMISSIONS; // set only this
  attrs.permissions:=AMode;
  SetStat(AFileName,Attrs);
  end;

procedure TTGPuttySFTP.SetVerbose(const Value: Boolean);
begin
  tgputty_setverbose(Value);
  FVerbose:=Value;
  end;

procedure TTGPuttySFTP.UploadFile(const ALocalFilename, ARemoteFilename: AnsiString; const anAppend: Boolean);
var res:Integer;
begin
  FLastMessages:='';
  Fcontext.fxp_errtype:=cDummyClearedErrorCode; // "clear" error field
  res:=tgsftp_putfile(PAnsiChar(ALocalFilename),PAnsiChar(ARemoteFilename),anAppend,@Fcontext);
  if res<>1 then
     raise TGPuttySFTPException.Create(MakePSFTPErrorMsg('tgsftp_putfile'));
  end;

procedure TTGPuttySFTP.UploadStream(const ARemoteFilename: AnsiString; const AStream: TStream; const anAppend: Boolean);
var res:Integer;
begin
  FLastMessages:='';
  FUploadStream:=AStream;
  Fcontext.fxp_errtype:=cDummyClearedErrorCode; // "clear" error field
  try
    res:=tgsftp_putfile(nil,PAnsiChar(ARemoteFilename),anAppend,@Fcontext);
    if res<>1 then
       raise TGPuttySFTPException.Create(MakePSFTPErrorMsg('tgsftp_putfile'));
    finally
      FUploadStream:=nil;
    end;
  end;

procedure TTGPuttySFTP.xfer_cleanup(const xfer: TSFTPTransfer);
begin
  tgputty_xfer_cleanup(xfer,@Fcontext);
  end;

procedure TTGPuttySFTP.SetBooleanConfigValue(const OptionName: AnsiString; const OptionValue: Boolean);
begin
  tgputty_conf_set_bool(GetPuttyConfIndex(OptionName),OptionValue,@FContext);
  end;

function TTGPuttySFTP.xfer_done(const xfer: TSFTPTransfer): Boolean;
begin
  Result:=tgputty_xfer_done(xfer,@Fcontext);
  end;

function TTGPuttySFTP.xfer_ensuredone(const xfer: TSFTPTransfer): Boolean;
begin
  Result:=tgputty_xfer_ensuredone(xfer,@Fcontext);
  end;

procedure TTGPuttySFTP.xfer_upload_data(const xfer: TSFTPTransfer; const buffer: Pointer; const len: Integer; const anoffset: UInt64);
begin
  tgputty_xfer_upload_data(xfer,buffer,len,anoffset,@Fcontext);
  end;

function TTGPuttySFTP.xfer_upload_init(const fh: TSFTPFileHandle; const offset: UInt64): TSFTPTransfer;
begin
  Result:=tgputty_xfer_upload_init(fh,offset,@Fcontext);
  end;

function TTGPuttySFTP.xfer_upload_ready(const xfer: TSFTPTransfer): Boolean;
begin
  Result:=tgputty_xfer_upload_ready(xfer,@Fcontext);
  end;

function tgputtysftp_version : string;
var
 SFTP : TTGPuttySFTP;
begin
 SFTP := TTGPuttySFTP.Create(false);
 result := SFTP.GetLibVersion;
 SFTP.Free;
end;

initialization

  GPuttyConfigCS:=TCriticalSection.Create;

finalization

  FreeAndNil(GPuttyConfigIndex);
  FreeAndNil(GPuttyConfigCS);

end.

