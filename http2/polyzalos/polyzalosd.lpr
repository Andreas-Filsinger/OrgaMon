program polyzalosd;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, SysUtils, CustApp,
  { you can add units after this }
  cryptossl, hpack, http2, ctypes;

type

  { TMyApplication }

  TMyApplication = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
    procedure Request(R:TStringList);
    procedure Error(R:TStringList);
  end;

{ TMyApplication }


var
  fHTTP2 : THTTP2_Connection;

procedure TMyApplication.Error(R: TStringList);
var
   n : Integer;
begin
 for n := 0 to pred(R.count) do
  writeln(R[n]);
end;

procedure TMyApplication.Request(R: TStringList);
var
  C : RawByteString;
  RequestedResourceName : string;
  ID : Integer;
begin

 RequestedResourceName := R.Values[':path'];
 ID := StrToIntDef(R.Values[CONTEXT_HEADER_STREAM_ID],0);

 writeln(RequestedResourceName+'@'+IntToStr(ID));

 if (RequestedResourceName='/') then
  RequestedResourceName := 'index.html';

 // deliver a file
 with fHTTP2 do
 begin
   with HEADERS_OUT do
   begin
    clear;
    add(':status=200');
    add('date='+Date);
    add('server='+Server);
    add('cross-origin-opener-policy=same-origin');
    add('cross-origin-embedder-policy=require-corp');
    add('content-type='+ContentTypeOf(RequestedResourceName));
    encode;
   end;
   store(r_Header(ID));
   storeFile(RequestedResourceName,ID);
   write;
 end;

 R.Free;
end;

procedure TMyApplication.DoRun;
var
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then
  begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then
  begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  // init openssl
  writeln(cryptossl.Version);
  // init http2-Server
  fHTTP2 := THTTP2_Connection.create;

  try
    with fHTTP2 do
    begin
     // chroot
     Path := 'R:\srv\hosts\';
     OnRequest := @Request;
     //OnError := @Error;
     CTX := StrictHTTP2Context;
     Accept(getSocket);

     repeat
       if GetCurrentThreadID = MainThreadID then
       begin
         CheckSynchronize;
         Sleep(100);
       end
     until false;

    end;

  finally
  end;

  readln;

  // stop program loop
  Terminate;
end;

constructor TMyApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TMyApplication.Destroy;
begin
  inherited Destroy;
end;

procedure TMyApplication.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;

var
  Application: TMyApplication;
begin
  Application:=TMyApplication.Create(nil);
  Application.Title:='My Application';
  Application.Run;
  Application.Free;
end.

