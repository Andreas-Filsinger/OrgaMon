{
|     _   _   _____   _____   ____       __  ____
|    | | | | |_   _| |_   _| |  _ \     / / |___ \
|    | |_| |   | |     | |   | |_) |   / /    __) |
|    |  _  |   | |     | |   |  __/   / /    / __/
|    |_| |_|   |_|     |_|   |_|     /_/    |_____|
|
|    HTTP/2 (as described in RFC 7540)
|
|    (c) 2017 - 2021  Andreas Filsinger
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
unit HTTP2;

{$mode objfpc}{$H+}
{$modeswitch advancedrecords}

interface

uses
  cTypes,
  Classes,
  SysUtils,
  unicodedata,

  // Tools
  anfix32,
  PasMP,

  // HTTP/2 Project
  cryptossl,
  hpack;

Type
 { THTTP2_Stream - Class }

 // RFC: 5.1.  Stream States

 TStreamStates = (idle, reserved_local, reserved_remote, open, halfclosed_local, halfclosed_remote, closed, broken);

 THTTP2_Stream = Class(TObject)
       ID : Integer;   { <>0, 1.. }
       dependency: Integer; { dads ID }
       weight : Integer; { 1..256, default 16 }
       State : TStreamStates; { default idle }

       window_size: Integer;    { 65,535 by default }
       SETTINGS_MAX_FRAME_SIZE : UInt24;  { 16384..16777215 }

       class function StateToString(s:TStreamStates):string;
  end;

 THTTP2_Settings = Class(TObject)
   HEADER_TABLE_SIZE : Integer;
   ENABLE_PUSH : Integer;
   MAX_CONCURRENT_STREAMS : Integer;
   INITIAL_WINDOW_SIZE : Integer;
   MAX_FRAME_SIZE : Integer;
   MAX_HEADER_LIST_SIZE : Integer;
 end;

 TNoiseContainer = array[0..pred(16*1024)] of byte;
 TNoiseContainerP = ^TNoiseContainer;

 TNoiseQ = specialize TPasMPBoundedQueue<RawByteString>;
 TSSL_ERRORQ = specialize TPasMPBoundedQueue<Integer>;

 THTTP2_Reader = class(TThread)
       //
       // fires a Noise-Event for every received raw Data-Block
       // it makes no assumption about content just the raw bytes
       // so Noise can be Data from a SSL Connection or a Test Data Generator
       // or Test Data from the File-System. Please, never use it to get data from a
       // unsecured Connection or a uncrypted local connection
       //
 private

   FNoise : TThreadMethod;
   FSSL_ERROR : TThreadMethod;
   FSSL: PSSL;
   ErrorCount: Integer;

 protected
   procedure Execute; override;
 public

   NOISE : TNoiseQ;
   SSL_ERROR : TSSL_ERRORQ;

   constructor Create(SSL : PSSL);


   property OnNoise : TThreadMethod read FNoise write FNoise;
   property OnSSL_ERROR : TThreadMethod read FSSL_ERROR write FSSL_ERROR;
 end;

 { THTTP2_Connection }

 TRequestMethod = procedure(Request : TStringList) of Object;

 THTTP2_Connection = class(TObject)

     //
     // complete internal handling of a HTTP2 Connection. Wire-coding
     // encoding (HPACK) and Householding of Data Objects (Streams, Headers)
     //
     // Fires an Request-Event only if somethings is to do outside the
     // HTTP2 internal Stuff.
     //

     FRequest : TRequestMethod;

     // Data-Objects
     HEADERS_OUT: THPACK;
     HEADERS_IN: THPACK;
     SETTINGS : THTTP2_Settings;
     SETTINGS_REMOTE : THTTP2_Settings;

     // Streams
     Streams: TList;
     LOCAL_STREAM_ID: Integer; // even, initiated by me
     REMOTE_STREAM_ID: Integer; // odd, initiated by remote

     // openSSL
     CTX: PSSL_CTX;
     SSL: PSSL;

     // Incoming Data
     Reader : THTTP2_Reader;

     public
       ClientNoise : TNoiseContainer;
       CN_Size: Integer;
       CN_Pos: Integer; // 0..pred(CN_Size)
       AutomataState : Byte;
       ParseRounds : Integer;
       Path: String;

       //
       constructor Create;

       function StrictHTTP2Context: PSSL_CTX;
       procedure Accept(FD: cint);

       // Streams
       function byID (ID:Integer): THTTP2_Stream;

       // Parser
       procedure Parse;
       procedure ParserClear;
       procedure ParserSave;
       procedure SaveRawBytes(B: RawByteString; FName: string);
       procedure LoadRawBytes(FName: string);

       // FRAMES
       function r_PING(PayLoad : RawByteString; AsEcho: boolean = false) : RawByteString;
       function r_SETTINGS_ACK : RawByteString;
       function r_SETTINGS : RawByteString;
       function r_WINDOW_UPDATE (ID:integer=0; Size_Increment: Integer=$7fffff) : RawByteString;
       function r_HEADER (ID:Integer) : RawByteString;
       function r_DATA (ID:Integer; Content: RawByteString) : RawByteString;
       function r_GOAWAY : RawByteString;

       // lowlevel. really write to the Connection
       function write(buf : Pointer;  num: cint): cint; overload;
       function write(W : RawByteString): cint; overload;
       procedure sendfile(FName:string; ID:Integer);

       // Data
       procedure debug(D: RawByteString);
       procedure enqueue(D: RawByteString);

       // read Events
       procedure Noise;
       procedure Error;

       // Error Informations
       procedure loadERROR(Err : cint);

       // Call-Back if there is a request from Client
       property OnRequest : TrequestMethod read FRequest write FRequest;

       class function NULL_PAGE : RawByteString;
       class function ContentTypeof(ResourceName: String = ''):String;
 end;

const
  // Debug-Messages for the media Layer
  mDebug: TStringList = nil;
  CLIENT_PREFIX: RawByteString = '';
  PING_PAYLOAD: RawByteString = 'OrgaMon9';
  PathToTests: string = '';

function getSocket: cint;

implementation

uses
 Windows, // sollte wieder entfallen nur wegen GetLAstError
 sockets,
 systemd;

type

  { TNum31Bit }

  TNum31Bit = packed record
   {$ifdef FPC_LITTLE_ENDIAN}
    byte3, byte2, byte1, byte0 : Byte;
   {$else FPC_LITTLE_ENDIAN}
    byte0, byte1, byte2, byte3 : Byte;
   {$endif FPC_LITTLE_ENDIAN}
    class operator Explicit(a : TNum31Bit) : Cardinal;
    class operator Explicit(a : TNum31Bit) : QWord;
    class operator :=(a : Cardinal) : TNum31Bit;
    function readBit32: boolean;
    procedure writeBit32(Bit:boolean);
    property Bit32: boolean read readBit32 write writeBit32;
  end;

  TNum32Bit = packed record
   {$ifdef FPC_LITTLE_ENDIAN}
    byte3, byte2, byte1, byte0 : Byte;
   {$else FPC_LITTLE_ENDIAN}
    byte0, byte1, byte2, byte3 : Byte;
   {$endif FPC_LITTLE_ENDIAN}
    class operator Explicit(a : TNum32Bit) : Cardinal;
    class operator :=(a : Cardinal) : TNum32Bit;
  end;

  TNum24Bit = packed record
   {$ifdef FPC_LITTLE_ENDIAN}
    byte2, byte1, byte0 : Byte;
   {$else FPC_LITTLE_ENDIAN}
    byte0, byte1, byte2 : Byte;
   {$endif FPC_LITTLE_ENDIAN}
    class operator Explicit(a : TNum24Bit) : Cardinal;
    class operator :=(a : Cardinal) : TNum24Bit;
  end;

  TNum16Bit = packed record
   {$ifdef FPC_LITTLE_ENDIAN}
    byte1, byte0 : Byte;
   {$else FPC_LITTLE_ENDIAN}
    byte0, byte1 : Byte;
   {$endif FPC_LITTLE_ENDIAN}
    class operator Explicit(a : TNum16Bit) : Cardinal;
    class operator :=(a : Cardinal) : TNum16Bit;
  end;


type
   // RFC: "4.1. Frame Format"
   THTTP2_FRAME = Packed record
     Len : TNum24Bit;     // 0..SETTINGS_MAX_FRAME_SIZE
     Typ : Byte;
     Flags : Byte;
     Stream_ID : TNum31Bit; // 0,2,4..2147483648  even-numbered on server-side-created

     function asString : RawByteString;
   end;
   PHTTP2_FRAME_HEADER = ^THTTP2_FRAME;

  // RFC: "6.2. HEADERS"
  // optional FRAME-Fragment: only if FLAG_PADDING is set
  TFRAME_HEADERS_PADDING = Packed record
    Pad_Length : byte;
  end;
  PFRAME_HEADERS_PADDING = ^TFRAME_HEADERS_PADDING;

  // optional FRAME-Fragment, only if FLAG_PRIORITY is set
  TFRAME_HEADERS_PRIORITY = Packed record
    Stream_Dependency : TNum31Bit;
    Weight : byte;
  end;
  PFRAME_HEADERS_PRIORITY = ^TFRAME_HEADERS_PRIORITY;

  // RFC: "6.3. PRIORITY"
  TFRAME_PRIORITY = packed record
    Stream_Dependency : TNum32Bit;
    Weight : Byte;
  end;
  PFRAME_PRIORITY = ^TFRAME_PRIORITY;

  // RFC: "6.4. RST_STREAM"
  TFRAME_RST_STREAM = packed record
   Error_Code : TNum32Bit;
  end;
  PFRAME_RST_STREAM = ^TFRAME_RST_STREAM;

  // RFC: "6.5.1. SETTINGS Format"
  TFRAME_SETTINGS = packed record
   SETTING_ID : TNum16Bit;
   Value      : TNum32Bit;
   function asString: RawByteString;
  end;
  PFRAME_SETTINGS = ^TFRAME_SETTINGS;

  // RFC: "6.8.GOAWAY"
  TFRAME_GOAWAY = packed record
    Last_Stream_ID : TNum31Bit;
    Error_Code : TNum32Bit;
    function asString: RawByteString;
  end;
  PFRAME_GOAWAY = ^TFRAME_GOAWAY;

  // RFC: "6.9 WINDOW_UPDATE"
  TFRAME_WINDOW_UPDATE = packed record
   Window_Size_Increment : TNum32Bit;  // 1..2147483647
   function asString: RawByteString;
  end;
  PFRAME_WINDOW_UPDATE = ^TFRAME_WINDOW_UPDATE;

const
  SizeOf_FRAME = sizeof(THTTP2_FRAME);
  SizeOf_SETTINGS = sizeof(TFRAME_SETTINGS);
  SizeOf_WINDOW_UPDATE = sizeof(TFRAME_WINDOW_UPDATE);
  SizeOf_GOAWAY = sizeof(TFRAME_GOAWAY);

const
   // RFC: "7.  Error Codes"
   NO_ERROR             = $00;
   PROTOCOL_ERROR       = $01;
   INTERNAL_ERROR       = $02;
   FLOW_CONTROL_ERROR   = $03;
   SETTINGS_TIMEOUT     = $04;
   STREAM_CLOSED        = $05;
   FRAME_SIZE_ERROR     = $06;
   REFUSED_STREAM       = $07;
   CANCEL               = $08;
   COMPRESSION_ERROR    = $09;
   CONNECT_ERROR        = $0a;
   ENHANCE_YOUR_CALM    = $0b;
   INADEQUATE_SECURITY  = $0c;
   HTTP_1_1_REQUIRED    = $0d;
   LAST_ERROR           = HTTP_1_1_REQUIRED;

 ERROR_CODES : array[NO_ERROR..LAST_ERROR] of string = (
   'NO_ERROR',
   'PROTOCOL_ERROR',
   'INTERNAL_ERROR',
   'FLOW_CONTROL_ERROR',
   'SETTINGS_TIMEOUT',
   'STREAM_CLOSED',
   'FRAME_SIZE_ERROR',
   'REFUSED_STREAM',
   'CANCEL',
   'COMPRESSION_ERROR',
   'CONNECT_ERROR',
   'ENHANCE_YOUR_CALM',
   'INADEQUATE_SECURITY',
   'HTTP_1_1_REQUIRED');

const
 // Client Hello String
 CRLF = #$0D#$0A;
 CLIENT_PREFIX_PRISM = 'PRISM' + CRLF+CRLF;
 CLIENT_PREFIX_HTTP = ' * HTTP/2.0' + CRLF+CRLF;
 SizeOf_CLIENT_PREFIX = length(CLIENT_PREFIX_PRISM)+length(CLIENT_PREFIX_HTTP);
 EMPTY_PAGE =
   {} '<!doctype html>' + CRLF +
   {} '<html lang=en>' + CRLF +
   {} ' <head>' + CRLF +
   {} '  <meta charset=utf-8>' + CRLF +
   {} '  <title>OrgaMon</title>' + CRLF +
   {} ' </head>' + CRLF +
   {} ' <body>OrgaMon-HTTP2 works!</body>' + CRLF +
   {} '</html>' + CRLF +
   {} CRLF +
   {} CRLF;

 // Frame Types
 FRAME_TYPE_DATA = 0;
 FRAME_TYPE_HEADERS = 1;
 FRAME_TYPE_PRIORITY = 2;
 FRAME_TYPE_RST_STREAM = 3;
 FRAME_TYPE_SETTINGS = 4;
 FRAME_TYPE_PUSH_PROMISE = 5;
 FRAME_TYPE_PING = 6;
 FRAME_TYPE_GOAWAY = 7;
 FRAME_TYPE_WINDOW_UPDATE = 8;
 FRAME_TYPE_CONTINUATION = 9;
 FRAME_LAST = FRAME_TYPE_CONTINUATION;

 // Frame-Type Extensions for use in the future
 // https://www.iana.org/assignments/http2-parameters/http2-parameters.xhtml#frame-type

 FRAME_TYPE_ALTSVC = 10; // https://tools.ietf.org/html/rfc7838
 // imp pend: propagate a list off "alternative" connections to the same service (fail overs!)
 //

 FRAME_TYPE_11 = 11; // there is no information in the internet why ORIGIN moved from "11" to "12"
 // so "11" is free, so this is a myth

 FRAME_TYPE_ORIGIN = 12; // https://tools.ietf.org/html/draft-ietf-httpbis-origin-frame-03
 // imp pend: a server may send a list of trusted "other" origins (apart from "this" actual open origin to itself),
 // the "client" is free as save to connect to this other origins (kind of a family member thing) ...

 FRAME_NAME : array[FRAME_TYPE_DATA..FRAME_LAST] of string =
   ( 'DATA',
     'HEADERS',
     'PRIORITY',
     'RST_STREAM',
     'SETTINGS',
     'PUSH_PROMISE',
     'PING',
     'GOAWAY',
     'WINDOW_UPDATE',
     'CONTINUATION');

 // FRAME FLAGS
 FLAG_END_STREAM = $01;
 FLAG_ACK = $01;
 FLAG_END_HEADERS = $04;
 FLAG_PADDED = $08;
 FLAG_PRIORITY = $20;

 // RFC: 6.5.2.  Defined SETTINGS Parameters

 //   Server
 SETTINGS_TYPE_HEADER_TABLE_SIZE = $01; // 0..? default 4096
 SETTINGS_TYPE_MAX_CONCURRENT_STREAMS = $03; // 0,101..? suggested > 100
 SETTINGS_TYPE_INITIAL_WINDOW_SIZE = $04; // 0..? default 65,535
 SETTINGS_TYPE_MAX_FRAME_SIZE = $05; // 16,384..16777215
 SETTINGS_TYPE_MAX_HEADER_LIST_SIZE = $06; // 0..? default 16,777,215

 //   Client
 SETTINGS_TYPE_ENABLE_PUSH = $02; // 0,1 default 1 (=ON)

 SETTINGS_NAMES: array[1..6] of string = (
      'HEADER_TABLE_SIZE',
      'ENABLE_PUSH',
      'MAX_CONCURRENT_STREAMS',
      'INITIAL_WINDOW_SIZE',
      'MAX_FRAME_SIZE',
      'MAX_HEADER_LIST_SIZE');

// Tools

function FlagName(SingleFlag:byte):string;
begin
 case SingleFlag of
   FLAG_ACK : result := 'ACK|END_STREAM';
   FLAG_END_HEADERS : result := 'END_HEADERS';
   FLAG_PADDED : result := 'PADDED';
   FLAG_PRIORITY : result := 'PRIORITY';
 else
  result := IntToHex(SingleFlag,2);
 end;
end;

function FlagsAsString(Flags:byte):string;

 procedure CheckFlag(Flag:byte);
 begin
   if Flags and Flag<>0 then
     result := result + '|' + FlagName(Flag);
 end;

begin
 result := '';
 if (Flags=0) then
  exit;

 CheckFlag(FLAG_ACK);
 CheckFlag(FLAG_END_HEADERS);
 CheckFlag(FLAG_PADDED);
 CheckFlag(FLAG_PRIORITY);

 delete(result,1,1);
end;

{ TFRAME_GOAWAY }

function TFRAME_GOAWAY.asString: RawByteString;
begin
 setLength(result,sizeof(TFRAME_GOAWAY));
 move(Last_Stream_ID,result[1],sizeof(TFRAME_GOAWAY));
end;

{ TFRAME_WINDOW_UPDATE }

function TFRAME_WINDOW_UPDATE.asString: RawByteString;
begin
  setLength(result,sizeof(TFRAME_WINDOW_UPDATE));
  move(Window_Size_Increment,result[1],sizeof(TFRAME_WINDOW_UPDATE));
end;

{ TFRAME_SETTINGS }

function TFRAME_SETTINGS.AsString: RawByteString;
begin
 setLength(result,sizeof(TFRAME_SETTINGS));
 move(SETTING_ID,result[1],sizeof(TFRAME_SETTINGS));
end;

function THTTP2_FRAME.asString: RawByteString;
begin
  SetLength(result,sizeof(THTTP2_FRAME));
  move(Len,result[1],sizeof(THTTP2_FRAME));
end;

{ THTTP2_Stream }

class function THTTP2_Stream.StateToString(s: TStreamStates): string;
const
  STATE_NAMES: array[idle..broken] of string = (
    'IDLE',
    'RESERVED_LOCAL',
    'RESERVED_REMOTE',
    'OPEN',
    'CLOSED_LOCAL',
    'CLOSED_REMOTE',
    'CLOSED',
    'BROKEN');
begin
 result := STATE_NAMES[s];
end;

function THTTP2_Connection.r_SETTINGS_ACK: RawByteString;
var
 FRAME : THTTP2_FRAME;
begin
 with FRAME do
 begin
   Len := 0;
   Typ := FRAME_TYPE_SETTINGS;
   Flags := FLAG_ACK;
   Stream_ID := 0;
 end;

 // Return the Structure
 SetLength(result, SizeOf_FRAME);
 move(FRAME, result[1], SizeOf_FRAME);
end;

function THTTP2_Connection.r_SETTINGS: RawByteString;
var
  FRAME : THTTP2_FRAME;

 function add(pSETTING_ID : UInt16;pValue : UInt32): RawByteString;
 var
  SETTING : TFRAME_SETTINGS;
 begin
   with SETTING do
   begin
     SETTING_ID := pSETTING_ID;
     Value      := pValue;
     result := AsString;
   end;
   FRAME.Len := cardinal(FRAME.Len) + sizeof(TFRAME_SETTINGS);
 end;

 var
  Settings_Data : RawByteString;

begin
 with FRAME do
 begin
   Len := 0;
   Typ := FRAME_TYPE_SETTINGS;
   Flags := 0;
   Stream_ID := 0;
 end;

 with SETTINGS do
  Settings_Data :=
   {} add(SETTINGS_TYPE_MAX_CONCURRENT_STREAMS, MAX_CONCURRENT_STREAMS)+
   {} add(SETTINGS_TYPE_INITIAL_WINDOW_SIZE, INITIAL_WINDOW_SIZE)+
   {} add(SETTINGS_TYPE_MAX_FRAME_SIZE, MAX_FRAME_SIZE) +
   {} add(SETTINGS_TYPE_MAX_HEADER_LIST_SIZE, MAX_HEADER_LIST_SIZE);

  result := FRAME.asString + Settings_Data;
end;

function THTTP2_Connection.r_WINDOW_UPDATE(ID: integer;
  Size_Increment: Integer): RawByteString;
var
 FRAME : THTTP2_FRAME;
 FRAME_WINDOW_UPDATE : TFRAME_WINDOW_UPDATE;
begin
 with FRAME do
 begin
   Len := sizeof(TFRAME_WINDOW_UPDATE);
   Typ := FRAME_TYPE_WINDOW_UPDATE;
   Flags := 0;
   Stream_ID := ID;
 end;
 with FRAME_WINDOW_UPDATE do
 begin
  Window_Size_Increment := Size_Increment;
 end;
 result := FRAME.asString + FRAME_WINDOW_UPDATE.asString;
end;

function THTTP2_Connection.r_HEADER(ID: Integer): RawByteString;
var
 FRAME: THTTP2_FRAME;
begin
 with FRAME do
 begin
   Len := length(HEADERS_OUT.wire);
   Typ := FRAME_TYPE_HEADERS;
   Flags := FLAG_END_HEADERS;
   Stream_ID := ID;
 end;
 result := FRAME.asString + HEADERS_OUT.wire;
end;

function THTTP2_Connection.r_DATA(ID: Integer; Content: RawByteString
  ): RawByteString;
var
 FRAME: THTTP2_FRAME;
begin
 with FRAME do
 begin
   Len := length(Content);
   Typ := FRAME_TYPE_DATA;
   Flags := FLAG_END_STREAM;
   Stream_ID := ID;
 end;
 result := FRAME.asString + Content;
end;

function THTTP2_Connection.r_GOAWAY: RawByteString;
var
 FRAME: THTTP2_FRAME;
 FRAME_GOAWAY: TFRAME_GOAWAY;
 Content : RawByteString;
begin
 Content := 'please connect again in a seconds';
 with FRAME do
 begin
   Len := sizeof(TFRAME_GOAWAY)+length(Content);
   Typ := FRAME_TYPE_GOAWAY;
   Flags := 0;
   Stream_ID := 0;
 end;
 with FRAME_GOAWAY do
 begin
   Last_Stream_ID := REMOTE_STREAM_ID;
   Error_Code := NO_ERROR;
 end;
 result := FRAME.asString + FRAME_GOAWAY.asstring + Content;
end;

function THTTP2_Connection.r_PING(PayLoad:RawByteString; AsEcho: boolean = false):RawByteString;
var
  Buf: array[0..pred(16*1024)] of byte;
  PBuf: ^Byte;
  FRAME: THTTP2_FRAME;
  SIZE: Integer;
begin

 // PING_FRAME
 with FRAME do
 begin
   Len := 8;
   Typ := FRAME_TYPE_PING;
   if AsEcho then
    Flags := FLAG_ACK
   else
    Flags := 0;
   Stream_ID := 0;
 end;
 PBuf := @Buf;
 SIZE := SizeOf_FRAME;
 move(FRAME,PBuf^,SizeOf_FRAME);
 inc(PBuf,SizeOf_FRAME);

 // r_PING Playload (Echo!)
 if (length(PayLoad)=8) then
  move(PayLoad[1],PBuf^,8);
 inc(SIZE,8);

 // Return the Structure
 SetLength(result, SIZE);
 move(Buf, result[1], SIZE);
end;

const
 FatalError: boolean = false;

procedure THTTP2_Connection.ParserSave;
var
  F: File;
begin
 if (PathToTests<>'') then
 begin
  AssignFile(F,PathToTests+'incoming-'+inttostr(ParseRounds)+'.http2');
  rewrite(F,1);
  blockwrite(F,ClientNoise,CN_Size);
  CloseFIle(F);
 end;
end;

procedure THTTP2_Connection.SaveRawBytes(B: RawByteString; FName: string);
var
  F: File;
begin
 AssignFile(F,FName);
 rewrite(F,1);
 blockwrite(F,B[1],length(B));
 CloseFIle(F);
end;

procedure THTTP2_Connection.LoadRawBytes(FName: string);
var
  F: File;
  FSize: int64;
  R: int64;
begin
 AssignFile(F,FName);
 reset(F,1);
 FSize := FileSize(F);
 R := 0;
 blockread(F,ClientNoise,min(FSize,SizeOf(ClientNoise)),R);
 CloseFile(F);
 CN_Pos := 0;
 CN_Size := R;
end;


procedure THTTP2_Connection.Parse;

  function Size_Unparsed : Integer;
  begin
   result := CN_Size - CN_Pos;
  end;

var
  CN_Pos2: Integer;
  n,m : Integer;
  ContentSize: Integer;
  H, D : RawByteString;

  // Streams
  S : THTTP2_Stream;
  StreamFound : boolean;

  // Request
  R : TStringList;

begin
 ParserSave;
 repeat

   case AutoMataState of
    0:begin // just born

        if (Size_Unparsed<SizeOf_CLIENT_PREFIX + SizeOf_FRAME) then
         begin
           mDebug.add('WARNING: nothing worse to parse - i wait and hope for more Noise ...');
           // imp pend: delay, read, timeout?
           break;
         end else
         begin
           for n := 1 to SizeOf_CLIENT_PREFIX do
            if (CLIENT_PREFIX[n]<>chr(ClientNoise[pred(n)])) then
             begin
               mDebug.add('ERROR: CLIENT_PREFIX expected, create dump for Diag');
               // imp pend: dump ClientNoise
               FatalError := true;
               break;
             end;
            inc(CN_pos,SizeOf_CLIENT_PREFIX);
            inc(AutomataState);
            mDebug.add('CLIENT_PREFIX');
         end;

      end;
    1:begin // FRAME - World

       if (Size_Unparsed<SizeOf_FRAME) then
        begin
          mDebug.add('WARNING: nothing worse to parse - i wait and hope for more Noise ...');
          // imp pend: delay, read, timeout?
          break;
        end;

       with PHTTP2_FRAME_HEADER(@ClientNoise[CN_pos])^ do
       begin

          // Typ
          if (Typ<=FRAME_LAST) then
           mDebug.add('FRAME_'+FRAME_NAME[Typ])
          else
           mDebug.add('FRAME_'+IntToStr(Typ));

          // Flags?
          if (Flags<>0) then
           mDebug.add(' Flags ['+FlagsAsString(Flags)+']');

          // Stream - ID, Save the max value
          mDebug.add(' Stream '+IntToStr(Cardinal(Stream_ID)));
          if (Cardinal(Stream_ID)>REMOTE_STREAM_ID) then
            REMOTE_STREAM_ID := Cardinal(Stream_ID);


         inc(CN_Pos,SizeOf_FRAME);
         CN_Pos2 := CN_pos;

         case Typ of
          FRAME_TYPE_DATA : begin

            ContentSize := Cardinal(Len);

            mDebug.add(' DATA_SIZE '+IntToStr(ContentSize));

            D := '';
            for n := 0 to pred(ContentSize) do
              D := D + chr(ClientNoise[CN_Pos2+n]);
            mDebug.add(' DATA '+ D);

            end;
          FRAME_TYPE_HEADERS : begin

            ContentSize := Cardinal(Len);

            if (Flags and FLAG_PADDED=FLAG_PADDED) then
            begin
               with PFRAME_HEADERS_PADDING(@ClientNoise[CN_Pos2])^ do
               begin
                mDebug.add(' Pad Length ' + IntTOStr(Pad_Length));
                dec(ContentSize,Pad_Length);
               end;
               inc(CN_Pos2,sizeof(TFRAME_HEADERS_PADDING));
               dec(ContentSize,sizeof(TFRAME_HEADERS_PADDING));
            end;


            if (Flags and FLAG_PRIORITY=FLAG_PRIORITY) then
            begin
              with PFRAME_HEADERS_PRIORITY(@ClientNoise[CN_Pos2])^ do
              begin
                mDebug.add('  Stream Dependency ' + IntTostr(Cardinal(Stream_Dependency)) );
                if Stream_Dependency.Bit32 then
                 mDebug.add('  EXCLUSIVE')
                else
                  mDebug.add('  NOT EXCLUSIVE');
                mDebug.add('  Weight '+INtTOstr(Weight));

              end;
              inc(CN_Pos2,sizeof(TFRAME_HEADERS_PRIORITY));
              dec(ContentSize,sizeof(TFRAME_HEADERS_PRIORITY));
            end;

            if (ContentSize>SETTINGS.MAX_HEADER_LIST_SIZE) then
            begin
             mDebug.add('ERROR: Size of Headers>MAX_HEADER_LIST_SIZE');
             FatalError := true;
             break;
            end;

            mDebug.add(' HEADER_SIZE '+IntToStr(ContentSize));

            // create the ASCII-HEX Representation of the HEADER
            H := '';
            for n := 0 to pred(ContentSize) do
              H := H + IntToHex(ClientNoise[CN_Pos2+n],2);
            mDebug.add(' HEADER '+ H);

            setLength(H,ContentSize);
            move(ClientNoise[CN_Pos2],H[1],ContentSize);
            with HEADERS_IN do
            begin
             Wire := H;
             Decode;
            end;

            R := TStringList.create;
            R.AddStrings(HEADERS_IN);
            R.add(CONTEXT_HEADER_STREAM_ID+'='+IntToStr(Cardinal(Stream_ID)));

            mDebug.addStrings(R);

            if assigned(FRequest) then
             FRequest(R);

           end;

          FRAME_TYPE_PRIORITY : begin;

            if (Cardinal(Len)<>5) then
            begin
               mDebug.add('ERROR: multible unsupported');
               FatalError := true;
               break;
            end;

            with PFRAME_PRIORITY(@ClientNoise[CN_Pos2])^ do
            begin
              mdebug.add(
               {} ' Stream '+
               {} INtTOstr(cardinal(Stream_ID)) + '.' +
               {} inttostr(cardinal(Stream_Dependency))+' Weight='+
               {} IntToStr(Weight));

              // find stream
              StreamFound := false;
              for n := 0 to pred(Streams.Count) do
                if (cardinal(Stream_ID)=cardinal(THTTP2_Stream(Streams[n]).ID)) then
                begin
                  StreamFound := true;
                  break;
                end;

              // Auto-Create if not found
              if not(StreamFound) then
              begin
                S := THTTP2_Stream.Create;
                with S do
                begin
                 ID := cardinal(Stream_ID);
                 dependency:= cardinal(Stream_Dependency);
                 weight := Weight;
                end;
                Streams.add(S);
              end;
            end;
          end;

          FRAME_TYPE_RST_STREAM : begin

            if (Cardinal(Len)<>4) then
             begin
               mDebug.add('ERROR: multible unsupported');
               FatalError := true;
               break;
             end;

            with PFRAME_RST_STREAM(@ClientNoise[CN_Pos2])^ do
            begin
             mDebug.add(' Error_Code=' + ERROR_CODES[Cardinal(Error_Code)]);
            end;


            end;
          FRAME_TYPE_SETTINGS : begin

              for n := 1 to (cardinal(Len) DIV SizeOf_SETTINGS) do
              begin
                with PFRAME_SETTINGS(@ClientNoise[CN_Pos2])^ do
                begin
                  mDebug.add(' '+SETTINGS_NAMES[cardinal(SETTING_ID)]+' '+IntToStr(Cardinal(Value)));

                  with SETTINGS_REMOTE do
                    case cardinal(SETTING_ID) of
                       SETTINGS_TYPE_HEADER_TABLE_SIZE:begin
                        HEADER_TABLE_SIZE := Cardinal(Value);

                        HEADERS_IN.set_MAXIMUM_TABLE_SIZE(HEADER_TABLE_SIZE)

                      end;
                      SETTINGS_TYPE_MAX_CONCURRENT_STREAMS :begin
                       MAX_CONCURRENT_STREAMS := Cardinal(Value);
                      end;
                      SETTINGS_TYPE_INITIAL_WINDOW_SIZE :begin
                        INITIAL_WINDOW_SIZE:= Cardinal(Value);
                      end;
                      SETTINGS_TYPE_MAX_FRAME_SIZE :begin
                        MAX_FRAME_SIZE := Cardinal(Value);
                      end;
                      SETTINGS_TYPE_MAX_HEADER_LIST_SIZE :begin
                        MAX_HEADER_LIST_SIZE := Cardinal(Value);
                      end;
                      SETTINGS_TYPE_ENABLE_PUSH :begin
                        ENABLE_PUSH := Cardinal(Value);
                     end;
                  end;
                end;
                inc(CN_Pos2,SizeOf_SETTINGS);
              end;

              write(r_SETTINGS_ACK);
               // if Initialized then
              //write(SETTINGS_ACK);
              // else
              //H := StartFrames;
              // write(H);
              //debug(H);
            end;
          FRAME_TYPE_PUSH_PROMISE : begin

             mDebug.add('ERROR: Servers can not process PUSH_PROMISE frames');
             FatalError := true;
             break;

            end;
          FRAME_TYPE_PING : begin

            if (Cardinal(Len)<>8) then
            begin
               mDebug.add('ERROR: PING Len of '+IntToStr(Cardinal(Len)));
               FatalError := true;
               break;
            end;

            if (Cardinal(Stream_ID)<>0) then
            begin
               mDebug.add('ERROR: invalid StreamID '+IntToStr(Cardinal(Stream_ID)));
               FatalError := true;
               break;
            end;

            // copy Content
            ContentSize := Cardinal(Len);
            SetLength(D,ContentSize );
            move(ClientNoise[CN_Pos2+n], D[1], ContentSize);

            // echo only if ACK is not set
            if (Flags and FLAG_ACK=0) then
             write(r_PING(D,true));

          end;
          FRAME_TYPE_GOAWAY : begin

            if (Cardinal(Stream_ID)<>0) then
             begin
               mDebug.add('ERROR: invalid StreamID<>0');
               FatalError := true;
               break;
             end;

             if (Cardinal(Len)<SizeOf_GOAWAY) then
             begin
               mDebug.add('ERROR: unsufficiant GOAWAY FRAME SIZE Payload');
               FatalError := true;
               break;
             end;

             with PFRAME_GOAWAY(@ClientNoise[CN_Pos2])^ do
             begin
              mDebug.add(' Last_Stream_ID=' + IntToStr(QWord(Last_Stream_ID)));
              if Cardinal(Error_Code)<=LAST_ERROR then
               mDebug.add(' Error_Code=' + ERROR_CODES[Cardinal(Error_Code)])
              else
               mDebug.add(' Error_Code=' + IntToHex(Cardinal(Error_Code),4));
             end;

             inc(CN_Pos2,SizeOf_GOAWAY);
             Len := Cardinal(Len) - SizeOf_GOAWAY;

             if Cardinal(Len)>0 then
             begin
               mDebug.add(' More_Info=' + IntToHex(Cardinal(Len),4)+' Byte(s)');
             end;

            end;
          FRAME_TYPE_WINDOW_UPDATE : begin

            if (Cardinal(Len)<>SizeOf_WINDOW_UPDATE) then
             begin
               mDebug.add('ERROR: multible unsupported');
               FatalError := true;
               break;
             end;

            // Search for the Stream
            if (cardinal(Stream_ID)<=REMOTE_STREAM_ID) then
            begin
             S := byID(cardinal(Stream_ID));
              if not(assigned(S)) then
              begin
                 // auto-create
                 S := THTTP2_Stream.Create;
                 with S do
                  ID := cardinal(Stream_ID);

              end;
              mDebug.add(' Window_Size_Increment ' + IntToStr(Cardinal(PFRAME_WINDOW_UPDATE(@ClientNoise[CN_Pos2])^.Window_Size_Increment)) );
              inc (S.window_size,Cardinal(PFRAME_WINDOW_UPDATE(@ClientNoise[CN_Pos2])^.Window_Size_Increment) );
            end else
            begin
              mDebug.add('Noise on Stream '+IntToStr(cardinal(Stream_ID))+' is ignored');
            end;

            end;
          FRAME_TYPE_CONTINUATION : begin

            if (Cardinal(Stream_ID)=0) then
             begin
               mDebug.add('ERROR: invalid StreamID 0');
               FatalError := true;
               break;
             end;
            end;

         else

           mDebug.add('INFO: skip unknown FRAME 0x' + IntToHex( Typ,2)+ '- waiting for implementation ...');

         end;
         inc(CN_Pos,Cardinal(Len));

      end;

    end;
   end;
   if FatalError then
     break;
   if (Size_Unparsed=0) then
     break;
  until false;
  inc(ParseRounds);
end;

procedure THTTP2_Connection.ParserClear;
begin
 AutomataState := 0;
 FatalError := false;
 CN_Pos := 0;
end;

{ THTTP2_Reader }

procedure THTTP2_Reader.Execute;
var
 BytesRead : cint;
 buf : array[0..pred(16*1024)] of byte;
 D : RawByteString;
 ERROR: integer;
begin
   if assigned(FSSL_ERROR) then
   begin
     // Just informa about the start of the task
     SSL_ERROR.enqueue(SSL_ERROR_NONE);
     Synchronize(FSSL_ERROR);
   end;

   while not Terminated do
   begin

    BytesRead := SSL_read(FSSL,@buf,sizeof(buf));

    if (BytesRead<1) then
    begin
      inc(ErrorCount);

      ERROR := SSL_get_error(FSSL,BytesRead);
      if not(SSL_ERROR.IsFull) then
       SSL_ERROR.enqueue(ERROR);
      sDebug.add(SSL_ERROR_NAME[ERROR]);

      if (ERROR=SSL_ERROR_SYSCALL) then
      begin
       sDebug.add('WSAGetLastError='+IntTOstr(socketerror));
       sDebug.add('GetLastError='+IntTOstr(GetLastError));
       // SysErrorMessage()
      end;
      ERR_print_errors_cb(@cb_ERROR,nil);

      if assigned(FSSL_ERROR) then
      begin
        // we have errors
        Synchronize(FSSL_ERROR);
      end;

      Terminate;

    end else
    begin


     if assigned(FNoise) then
     begin
       SetLength(D, BytesRead);
       move(buf, D[1], BytesRead);
       while NOISE.IsFull do
       begin
         // WARNING: Consumer to slow!!!
         Sleep(250);
         // Call consumer, maybe she missed several "FNoise"-Events?
         Synchronize(FNoise);
       end;
       // new data, copy it to a thread-save place!
       NOISE.enqueue(D);
       // publish the news!
       Synchronize(FNoise);
     end;

   end;
  end;
end;

constructor THTTP2_Reader.Create(SSL : PSSL);
begin
 inherited Create(True);
 FSSL := SSL;
 FreeOnTerminate := True;
 SSL_ERROR := TSSL_ERRORQ.Create(1024);
 NOISE :=  TNoiseQ.Create(1024);
end;

type
TCardinalRec = packed record
{$ifdef FPC_LITTLE_ENDIAN}
  byte0, byte1, byte2, byte3 : Byte;
{$else FPC_LITTLE_ENDIAN}
  byte3, byte2, byte1, byte0 : Byte;
{$endif FPC_LITTLE_ENDIAN}
end;

class operator TNum31Bit.Explicit(a : TNum31Bit) : Cardinal;
begin
  TCardinalRec(Result).byte0 := a.byte0;
  TCardinalRec(Result).byte1 := a.byte1;
  TCardinalRec(Result).byte2 := a.byte2;
  TCardinalRec(Result).byte3 := a.byte3 and $7F;
end;

class operator TNum31Bit.Explicit(a: TNum31Bit): QWord;
begin
  result := Cardinal(a);
end;

class operator TNum31Bit.:=(a : Cardinal) : TNum31Bit;
begin
  Result.byte0 := TCardinalRec(a).byte0;
  Result.byte1 := TCardinalRec(a).byte1;
  Result.byte2 := TCardinalRec(a).byte2;
  Result.byte3 := TCardinalRec(a).byte3 and $7F;
end;

function TNum31Bit.readBit32: boolean;
begin
  result := (byte3 and $80=$80)
end;

procedure TNum31Bit.writeBit32(Bit: boolean);
begin
 if Bit then
  byte3 := byte3 or $80
   else
  byte3 := byte3 and $7F;
end;

class operator TNum32Bit.Explicit(a : TNum32Bit) : Cardinal;
begin
  TCardinalRec(Result).byte0 := a.byte0;
  TCardinalRec(Result).byte1 := a.byte1;
  TCardinalRec(Result).byte2 := a.byte2;
  TCardinalRec(Result).byte3 := a.byte3;
end;

class operator TNum32Bit.:=(a : Cardinal) : TNum32Bit;
begin
  Result.byte0 := TCardinalRec(a).byte0;
  Result.byte1 := TCardinalRec(a).byte1;
  Result.byte2 := TCardinalRec(a).byte2;
  Result.byte3 := TCardinalRec(a).byte3;
end;

class operator TNum24Bit.Explicit(a : TNum24Bit) : Cardinal;
begin
  TCardinalRec(Result).byte0 := a.byte0;
  TCardinalRec(Result).byte1 := a.byte1;
  TCardinalRec(Result).byte2 := a.byte2;
  TCardinalRec(Result).byte3 := 0;
end;

class operator TNum24Bit.:=(a : Cardinal) : TNum24Bit;
begin
{$IFOPT R+}
  if (a > $FFFFFF) then
    system.Error(reIntOverflow);
{$ENDIF R+}
  Result.byte0 := TCardinalRec(a).byte0;
  Result.byte1 := TCardinalRec(a).byte1;
  Result.byte2 := TCardinalRec(a).byte2;
end;

class operator TNum16Bit.Explicit(a : TNum16Bit) : Cardinal;
begin
  TCardinalRec(Result).byte0 := a.byte0;
  TCardinalRec(Result).byte1 := a.byte1;
  TCardinalRec(Result).byte2 := 0;
  TCardinalRec(Result).byte3 := 0;
end;

class operator TNum16Bit.:=(a : Cardinal) : TNum16Bit;
begin
{$IFOPT R+}
  if (a > $FFFF) then
    system.Error(reIntOverflow);
{$ENDIF R+}
  Result.byte0 := TCardinalRec(a).byte0;
  Result.byte1 := TCardinalRec(a).byte1;
end;

// Knowledge Base
//  fpopenssl
//  http2_openssl.pas
//  socketssl


// create a Parameter Context for a TLS 1.2 Server Connection
// intended for a "HTTPS://" Server Socket

{ THTTP2_Connection }

constructor THTTP2_Connection.Create;
begin
  inherited Create;

  // Streams
  Streams:= TList.create;
  REMOTE_STREAM_ID := 0;

  // Settings
  SETTINGS := THTTP2_Settings.create;
  with SETTINGS do
  begin
    MAX_CONCURRENT_STREAMS := 32;
    INITIAL_WINDOW_SIZE := 64*1024;
    MAX_FRAME_SIZE := 5*1024*1024;
    MAX_HEADER_LIST_SIZE := 10*1024;
  end;
  SETTINGS_REMOTE := THTTP2_Settings.create;

  // Headers
  HEADERS_OUT := THPACK.create;
  HEADERS_IN := THPACK.create;

end;

function THTTP2_Connection.StrictHTTP2Context: PSSL_CTX;
var
   cs_METH : PSSL_METHOD;
begin

 //  ssl->ctx = SSL_CTX_new(SSLv23_method());

 cs_METH := TLS_server_method();
 CTX := SSL_CTX_new(cs_METH);

 if not(assigned(CTX)) then
   raise Exception.Create('Create a new SSL-Context fails');

 if (SSL_CTX_ctrl(CTX, SSL_CTRL_SET_MIN_PROTO_VERSION, TLS1_2_VERSION, nil) = 0) then
  raise Exception.Create('Set CTX Min Protokoll Version to <default> fails');
 if (SSL_CTX_ctrl(CTX, SSL_CTRL_SET_MAX_PROTO_VERSION, TLS1_3_VERSION, nil) = 0) then
  raise Exception.Create('Set CTX Max Protokoll Version to 1.3 fails');

 // Register a Callback for OpenSSL Infos
 SSL_CTX_set_info_callback(CTX,@cb_info);

 // do this help?
 SSL_CTX_ctrl(CTX, SSL_CTRL_SET_ECDH_AUTO, 1, nil);

// need SSL_CTX_set_tmp_{dh|rsa}
// need SSL_CTX_set_cert_cb ?
// need SSL_CTX_set_client_hello_cb ?
// SSL_CTX_set_read_ahead?
// SSL_CTX_set_options(CTX, SSL_OP_CIPHER_SERVER_PREFERENCE); ?

 // Register a Callback for: "SNI" read Identity Client expects
 SSL_CTX_callback_ctrl(CTX,SSL_CTRL_SET_TLSEXT_SERVERNAME_CB,@cb_SERVERNAME);

 // Register a Callback for: "ALPN" Select "h2" Protocol
 SSL_CTX_set_alpn_select_cb(CTX,@cb_ALPN,nil);

 result := CTX;

end;

// binds a HANDLE (comes from systemd, or from incoming socket) to a new SLL Connection

procedure THTTP2_Connection.Accept(FD: cint);
var
  a,e : cInt;
//  ErrStr : array[0..4096] of char;
P : PChar;
x : AnsiString;
ERR_F : THandle;
//ERROR: Integer;

// initial Read
buf : array[0..pred(16*1024)] of byte;
D : RawByteString;

BytesRead, BytesWritten: cint;
   DD: string;
   DC : string;
   n: Integer;
   SSL_CIPHER : PSSL_CIPHER;
   Cipher: string;
   SecurityPromise : TStringList;
   ErrorCount: integer;

   procedure CheckSecurityItem(item,ok_list:String);
   begin
    if pos(SecurityPromise.values[item],ok_list)=0 then
      begin
        inc(ErrorCount);
        sDebug.Add('ERROR: '+Item+' should be element of ['+ok_list+']. But is "'+SecurityPromise.values[item]+'" -> untrusted');
        sDebug.add(INtToStr(length(SecurityPromise.values[item])));
      end;
   end;

begin
  ErrorCount := 0;

  // SSL Init
  SSL := SSL_new(CTX);
  if not(assigned(SSL)) then
    raise Exception.create('SSL_new() fails');

  // SSL File Handle Übernahme
  if (SSL_set_fd(SSL, FD)<>1) then
   raise Exception.create('SSL_set_fd() fails');

  //
  a := SSL_accept(SSL);
  if (a<>1) then
  begin
    sDebug.add(SSL_ERROR_NAME[SSL_get_error(SSL,a)]);
    ERR_print_errors_cb(@cb_ERROR,nil);
    raise Exception.create('SSL_accept() fails');
  end else
  begin
   sDebug.add('connection with "' + SSL_get_version(SSL) + '"-secured established');

   SSL_CIPHER := SSL_get_current_cipher(SSL);
   Cipher := noDoubleBlank(SSL_CIPHER_description(SSL_CIPHER,@buf,sizeof(buf)));
   ersetze(#$0D,'',Cipher);
   ersetze(#$0A,'',Cipher);

   SecurityPromise := Split(Cipher,' ');
   SecurityPromise[0] := 'Cipher=' + SecurityPromise[0];
   SecurityPromise[1] := 'Version=' + SecurityPromise[1];

   // Log-Actual Security
   sDebug.addstrings(SecurityPromise);

   // Check Security
   CheckSecurityItem('Cipher','ECDHE-RSA-AES128-GCM-SHA256|ECDHE-RSA-AES256-GCM-SHA384|TLS_AES_128_GCM_SHA256');
   CheckSecurityItem('Version','TLSv1.2|TLSv1.3');
   CheckSecurityItem('Kx','ECDH|any');
   CheckSecurityItem('Au','RSA|any');
   CheckSecurityItem('Enc','AESGCM(128)|AESGCM(256)');
   CheckSecurityItem('Mac','AEAD');

   // Start the Read Connection Data Thread
   Reader := THTTP2_Reader.Create(SSL);
   Reader.OnNoise:=@Noise;
   Reader.OnSSL_ERROR:=@Error;
   Reader.Start;

  end;
end;

function THTTP2_Connection.byID(ID: Integer): THTTP2_Stream;
var
 n : integer;
begin
 result := nil;
 for n := 0 to pred(Streams.Count) do
   if (cardinal(ID)=cardinal(THTTP2_Stream(Streams[n]).ID)) then
   begin
     result := THTTP2_Stream(Streams[n]);
     break;
   end;
end;

function THTTP2_Connection.write(buf: Pointer; num: cint): cint; overload;
begin
 result := SSL_write(SSL,buf,num);
 mDebug.Add(IntTostr(result)+'/'+IntToStr(num)+' Byte(s) written ...');
end;

function THTTP2_Connection.write(W: RawByteString): cint;
var
 WriteBuffer : TNoiseContainer;
begin
  if (PathToTests<>'') then
  begin
   SaveRawBytes(W,PathToTests+'send-'+inttostr(ParseRounds)+'.http2');
   inc(ParseRounds);
  end;
  move(W[1],WriteBuffer,length(W));
  result := write(@WriteBuffer, length(W));
end;

procedure THTTP2_Connection.sendfile(FName: string; ID: Integer);
var
 fd : THandle;
 size : Int64;
 buffer: pointer;
 FRAME: THTTP2_FRAME;
 RESOURCE: RawByteString;
 ResourceFName: String;
begin
 // imp pend: secure this!
 ResourceFName := Path + cs_Servername + '\' + FName;

 RESOURCE := '';
 size := FSize(ResourceFName);
 if (size>0) then
 begin
   with FRAME do
   begin
     Len := size;
     Typ := FRAME_TYPE_DATA;
     Flags := FLAG_END_STREAM;
     Stream_ID := ID;
   end;
//   write(FRAME.AsString);
  // OpenSSL 3.0.0
  // SSL_sendfile(SSL, fd, 0, size, 0);

// ************************** sameold sameold
  buffer := GetMem(size);
  fd := FileOpen(ResourceFName,fmOpenRead);
  FileRead(fd,Buffer^,size);
  FileClose(fd);

  setLength(RESOURCE,size);
  move(Buffer^,RESOURCE[1],size);
  FreeMem(buffer);
//**************************

  write(FRAME.AsString+RESOURCE);

 end;
end;

procedure THTTP2_Connection.debug(D: RawByteString);
var
  DD : string;
  n : integer;
begin
 mDebug.add('--------------------------------------------');
 DD := '';
 for n := 1 to length(D) do
 begin
   DD := DD + ' ' + IntToHex(ord(D[n]),2);
   if (pred(n) MOD 16=15) then
   begin
    mDebug.add(DD);
    DD := '';
   end;
 end;
 if (DD<>'') then
  mDebug.add(DD);
 mDebug.add('--------------------------------------------');
end;

procedure THTTP2_Connection.enqueue(D: RawByteString);
var
 CN_NewBlockSize: Integer;
begin
 CN_NewBlockSize := length(D);
 if (CN_Size+CN_NewBlockSize<sizeof(TNoiseContainer)) then
 begin
  move(D[1], ClientNoise[CN_Size], CN_NewBlockSize);
  inc(CN_Size,CN_NewBlockSize);
  Parse;
 end else
 begin
   mDebug.add('ERROR: Out of memory');
 end;
end;

procedure THTTP2_Connection.Noise;
var
  D: RawByteString;
begin
 if Reader.NOISE.dequeue(D) then
 begin
  mDebug.add('Have '+IntToStr(length(D))+' Byte(s) of Incoming Data');
  enqueue(D);
 end;
end;

procedure THTTP2_Connection.Error;
var
   I : Integer;
begin
  if Reader.SSL_ERROR.dequeue(I) then
   mDebug.add('We have a Update of SSL_ERROR Code! New Value is '+SSL_ERROR_NAME[I]);
end;

procedure THTTP2_Connection.loadERROR(Err: cint);
begin
 sDebug.add(SSL_ERROR_NAME[SSL_get_error(SSL,Err)]);
 ERR_print_errors_cb(@cb_ERROR,nil);
end;

class function THTTP2_Connection.NULL_PAGE: RawByteString;
begin
  result := EMPTY_PAGE;
end;

class function THTTP2_Connection.ContentTypeof(ResourceName: String = '') : String;
var
 DotPos: Integer;
begin
  repeat
    DotPos:= RevPos('.',ResourceName);
    if (DotPos=0) then
    begin
      result := 'text/html; charset=UTF-8';
      break;
    end;
    case ResourceName[succ(DotPos)] of
     'c'{ss}: result := 'text/css';
     'h'{tml}: result := 'text/html';
     'a'{pk}: result := 'application/vnd.android.package-archive';
     'j': case ResourceName[DotPos+2] of
           {j}'s': result := 'application/javascript; charset=UTF-8';
           {j}'p'{g}: result := 'image/jpeg';
          else
            result := 'none';
          end;
     'i'{co}: result := 'image/x-icon';
     'p': case ResourceName[DotPos+2] of
           {p}'n'{g}: result := 'image/png';
           {p}'d'{f}: result := 'application/pdf';
          else
            result := 'none';
          end;
     's'{vg}: result := 'image/svg+xml';
    else
      result := 'none';
    end;
  until yet;
end;

// Im Rang 1: socket von systemd erhalten: // http://0pointer.de/blog/projects/socket-activation.html
// Im Rang 2: selbst ein Socket öffnen und auf Verbindungsversuche von aussen warten

function getSocket: cint;
var
 ServerAddr : TInetSockAddr;
 ClientAddr : TInetSockAddr;
 len : cint;
 ListenSocket, ConnectionSocket : cint;
 Flag: Longint;
begin
  // try systemd
  sd_notify(0, 'READY=1\nSTATUS=Ready\n');
  Result := sd_listen_fds(0);

  if (Result > 1) then
  begin
    raise Exception.Create('Too many file descriptors received');
  end
  else
  begin

    if (Result = 1) then
    begin
      // success via "systemd", result is a "symbolic" handle
      // with a fixed value (3)
      Result := SD_LISTEN_FDS_START;
    end
    else
    begin
       // Open via a SOCKET!

       // create a Handle
       ListenSocket:=fpSocket (AF_INET,SOCK_STREAM,0);
       if SocketError<>0 then
        raise Exception.Create('Server : Socket : ');

       // set usefull options
       Flag := 1;
       if fpsetsockopt(ListenSocket, IPPROTO_TCP, TCP_NODELAY, @flag, sizeof(LongInt))<0 then
        raise Exception.Create('Server: Socket: can not set TCP_NODELAY ');

       // FpFcntl(ListenSocket, F_SetFl, FpFcntl(ListenSocket, F_GetFl) or O_NONBLOCK);


       // bind to interface
       with ServerAddr do
       begin
         sin_family:=AF_INET;
         sin_port:=htons(443);
         sin_addr.s_addr:=INADDR_ANY;
       end;
       len := sizeof(ServerAddr);
       if fpBind(ListenSocket,@ServerAddr,sizeof(ServerAddr))=-1 then
        raise Exception.Create ('Server : Bind : ');
       if fpListen (ListenSocket,1)=-1 then
        raise Exception.Create ('Server : Listen : ');

       ConnectionSocket := fpAccept(ListenSocket,@ClientAddr,@len);
       if (ConnectionSocket=-1) then
        raise Exception.Create ('Server : Accept : ');

       sDebug.add(NetAddrToStr(ClientAddr.sin_addr));

       result := ConnectionSocket;

           (*
       // OPen via inetServer
   {$ifdef linux}
      client_socket := TUnixServer.Create('0.0.0.0:443');
   {$else}
      client_socket := TInetServer.Create('0.0.0.0', 443);
   {$endif}

      with client_socket do
      begin
        // Parameter?
        SetNonBlocking;
        KeepAlive := true;

        // Bind to Interface
        StartAccepting;

        // Make no further actions, let SSL take over
        Result := Socket;

      end;
      *)
    end;
  end;
end;


procedure Release;
begin
  (*
  SSLfree(ssl);
    close(client);
    close(sock);
    SSL_CTX_free(ctx);
    cleanup_openssl();
   *)
end;

begin
 mDebug := TStringList.create;

 // RFC: 3.5.  HTTP/2 Connection Preface
 CLIENT_PREFIX := copy(CLIENT_PREFIX_PRISM,1,3) + CLIENT_PREFIX_HTTP + copy(CLIENT_PREFIX_PRISM,4,MaxInt);

 // Check RFC Conditions
 assert(SizeOf_CLIENT_PREFIX=24,'Break of RFC 7540-3.5');
 assert(SizeOf_FRAME=9,'Break of RFC 7540-4.1');
 assert(SizeOf_SETTINGS=6,'Break of RFC 7540-6.5.1');
 assert(SizeOf_WINDOW_UPDATE=4,'Break of RFC 7540-6.9');
 assert(length(PING_PAYLOAD)=8,'Break of RFC 7540-6.7');
end.
