program polyzalosd;

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}
{$codepage UTF8}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, SysUtils, CustApp,
  { you can add units after this }
  anfix, fpchelper,
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
    procedure RequestCall(R:TStringList);
    procedure ErrorCall(R:TList);
  end;

{ TMyApplication }


var
  fHTTP2 : THTTP2_Connection;

procedure TMyApplication.ErrorCall(R: TList);
var
   n : Integer;
begin
 for n := 0 to pred(R.count) do
  writeln('E:'+IntToStr(Integer(R[n])));
end;

procedure TMyApplication.RequestCall(R: TStringList);
var
  RequestedResourceName : string;
  ID : Integer;
begin

 RequestedResourceName := R.Values[':path'];
 ID := StrToIntDef(R.Values[CONTEXT_HEADER_STREAM_ID],0);

 if (RequestedResourceName='/') then
  RequestedResourceName := 'index.html';

 // deliver a file

 // imp pend:
 // 5 Sekundenregel:
 //  * Inerhalb von 5 Sekunden soll der client gar nicht fragen
 //  * Dann soll er immer die ETAG Repräsentation des cache bekanntgeben
 //  * und Danach soll er fragen ob die Resource "so" immer noch frisch ist (via ETAG)
 //  * der Server prüft dann, ob es so ist und macht 304 oder halt 200
 //
 // Server:
 //  Cache-Control: private, no-cache, max-age=5
 //  ETag: "SJDHNDHSGS"
 // Remote:
 //  If-None-Match: "SJDHNDHSGS"
 //
 // at the first usage, give the resource a ETAG
 // check the ETAG in the request, if ok, send
 // RFC 15.4.5. "304 Not Modified"
 // https://datatracker.ietf.org/doc/html/rfc9111
 // https://datatracker.ietf.org/doc/html/rfc9110#status.304

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
  SomethingSynced: Boolean;
begin
  // quick check parameters
  ErrorMsg := CheckOptions('h', 'help');
  if (ErrorMsg<>'') then
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
     // imp pend: chroot to
     Path := 'R:\srv\hosts\';
     OnRequest := @RequestCall;
     OnError := @ErrorCall;
     Accept(getSocket);

     repeat
       SomethingSynced := CheckSynchronize(250);

       // Check the connection and quit if there is a Problem
       if ConnectionDropped then
        break;

       // imp pend:
       // Look for enqueued-writings (writings not done by now because window_size did not allowed it), is the receiver know ready to handle now?
       // this is part of the WINDOW_UPDATE flow control
       // Only do this, if any window_size is changed, in any other case it is useless
       // if window_size_changed then
       //  for n:= pred(EnquedWritings.count) to 0 do
       //   if TryWrite(n) then
       //     EnquedWritings.delete(n);

       if not(SomethingSynced) then
       begin
         if frequently(ConnectionLastNoise,20000) then
          if AutomataState>0 then
           if not(GoAway) then
           begin
            store(r_PING(PING_PAYLOAD));
            write;
           end;
       end else
       begin
         //
       end;

     until eternity;
    end;

  finally

  end;
  writeln('EOF');
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

