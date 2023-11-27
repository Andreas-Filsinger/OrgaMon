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
  anfix, cryptossl, hpack, http2, ctypes;

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
    // imp pend: create an error if somebody uses Uppercase Letters
    encode;
   end;
   store(r_Header(ID));
   storeFile(RequestedResourceName,ID);
   write;
 end;

 R.Free;
end;

procedure TMyApplication.DoRun;
const
  console_red : RawByteString = #27'[91m';
  console_green : RawByteString = #27'[92m';
  console_white : RawByteString = #27'[0m';

  test : Array of Byte = (27,ord('['),ord('3'),ord('2'),ord('m'));
  tus: Array of word = (ord('A'),ord('['),ord('3'),ord('2'),ord('m'));
  a: String = 'Hallo';
  b : String = #27'[32m';
var
  ErrorMsg: String;
  SomethingSynced: Boolean;
  H: dword;
  F : File of Byte;
  OutS: TFileStream;
begin
  // quick check parameters
  ErrorMsg := CheckOptions('h', 'help');
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

  write(console_red);
  write('↑'); // 🡅 🡑 ⍏ 🞁
  write(console_green);
  writeln('↓'); // 🡇 🡓 ⍖ 🞃
  write(console_white);

  // init http2-Server
  fHTTP2 := THTTP2_Connection.create;

  try
    with fHTTP2 do
    begin
     // chroot
     Path := 'R:\srv\hosts\';
     OnRequest := @RequestCall;
     OnError := @ErrorCall;
     Accept(getSocket);

     repeat
       SomethingSynced := CheckSynchronize(250);

       // Check Connection and quit if there is a Problem
       if ConnectionDropped then
        break;

       if not(SomethingSynced) then
       begin
         if frequently(ConnectionLastNoise,20000) then
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

