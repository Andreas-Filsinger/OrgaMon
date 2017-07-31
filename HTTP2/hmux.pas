{
|                   _   _ __  __ _   ___  __
|                  | | | |  \/  | | | \ \/ / _<___>___
|      _<______>__ | |_| | |\/| | | | |\  / ___<____>_
                   |  _  | |  | | |_| |/  \ _<______>_
|                  |_| |_|_|  |_|\___//_/\_\
|
|    Data Transport and Multiplexing for HTTP/2 (as described in RFC 7540)
|
|    (c) 2017 Andreas Filsinger
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
unit HMUX;

{$mode objfpc}{$H+}
{$modeswitch advancedrecords}
interface

uses
  Classes, SysUtils, unicodedata;

Type
THTTP2_Stream = Class(TObject)
     ID : Integer;   { <>0, 1.. }
     weight : Integer; { 1..256, default 16 }

     window_size: Integer;    { 65,535 by default }
     SETTINGS_MAX_FRAME_SIZE : UInt24;  { 16384..16777215 }
end;

{ THTTP2_Connection }

THTTP2_Connection = class(TObject)
     SETTINGS_MAX_CONCURRENT_STREAMS_LOCAL : Integer;
     SETTINGS_MAX_CONCURRENT_STREAMS_REMOTE: Integer;
     public
     class function SETTING : string; overload;
          class function SETTING (Parameter: word; Value: Integer) : string; overload;

end;

THMUX = class(TObject)

 end;

var
  Buf: array[0..pred(16*1024)] of byte;


function StartFrames : string;

implementation

type
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
   // RFC: "4.1.  Frame Format"
   THTTP2_FRAME_HEADER = Packed Record
     Length : TNum24Bit;     // 0..SETTINGS_MAX_FRAME_SIZE
     FType : Byte;
     Flags : Byte;
     Stream_ID : TNum32Bit; // 0,2,4..2147483648  even-numbered on servers
   end;


  // RFC: "6.5.1.  SETTINGS Format"
   TFRAME_SETTINGS = Packed Record
    SETTING_ID : TNum16Bit;
    Value      : TNum32Bit;
   end;

   // RFC: "6.9 WINDOW_UPDATE"
   TFRAME_WINDOW_UPDATE = Packed Record
    Window_Size_Increment : TNum32Bit;  // 1..2147483647
   end;

const
  SizeOf_FRAME_HEADER = sizeof(THTTP2_FRAME_HEADER);
  SizeOf_SETTINGS = sizeof(TFRAME_SETTINGS);
  SizeOf_WINDOW_UPDATE = sizeof(TFRAME_WINDOW_UPDATE);

const
   // RFC: "7.  Error Codes"
   PROTOCOL_ERROR = $01;
   INTERNAL_ERROR = $02;
   FLOW_CONTROL_ERROR = $03;
   SETTINGS_TIMEOUT = $04;
   STREAM_CLOSED = $05;
   FRAME_SIZE_ERROR = $06;
   REFUSED_STREAM = $07;
   CANCEL = $08;
   COMPRESSION_ERROR = $09;
   CONNECT_ERROR = $0a;
   ENHANCE_YOUR_CALM = $0b;
   INADEQUATE_SECURITY = $0c;
   HTTP_1_1_REQUIRED = $0d;

const
 CRLF = #$0D#$0A;
 CLIENT_HELLO = 'PRI * HTTP/2.0' + CRLF+CRLF + 'SM' + CRLF+CRLF;

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


 // RFC: 6.5.2.  Defined SETTINGS Parameters

 // Server
 SETTINGS_HEADER_TABLE_SIZE = $01; // 0..? default 4096
 SETTINGS_MAX_CONCURRENT_STREAMS = $03; // 0,101..? suggested > 100
 SETTINGS_INITIAL_WINDOW_SIZE = $04; // 0..? default 65,535
 SETTINGS_MAX_FRAME_SIZE = $05; // 16,384..16777215
 SETTINGS_MAX_HEADER_LIST_SIZE = $06; // 0..? default 16,777,215

 // Client
 SETTINGS_ENABLE_PUSH = $02; // 0,1 default 1 (=ON)


    //
   {
    Length=8, Rauschen
    Flag=1; im Fall eines Responeses
   }

   //

type
   THTTP2_Stream_Status = (
     STREAM_STATUS_IDLE,
     STREAM_STATUS_RESERVED_LOCAL,
     STREAM_STATUS_RESERVED_REMOTE,
     STREAM_STATUS_OPEN,
     STREAM_STATUS_HALF_CLOSED_LOCAL,
     STREAM_STATUS_HALF_CLOSED_REMOTE,
     STREAM_STATUS_CLOSED,
     STREAM_STATUS_BROKEN);


// RFC: 3.5.  HTTP/2 Connection Preface

function StartFrames: string;
var
 PBuf, _PBuf: ^Byte;
 FRAME : THTTP2_FRAME_HEADER;
 WINDOW_UPDATE: TFRAME_WINDOW_UPDATE;
 SettingsCount: Integer;
 SIZE: Integer;

 procedure add(pSETTING_ID : UInt16;pValue : UInt32);
 var
  SETTING : TFRAME_SETTINGS;
 begin
   with SETTING do
   begin
     SETTING_ID := pSETTING_ID;
     Value      := pValue;
   end;
   move(SETTING,PBuf^,SizeOf_SETTINGS);
   inc(PBuf,SizeOf_SETTINGS);
   inc(SettingsCount);
 end;

begin
 SettingsCount := 0;

 // A) SETTINGS - FRAME

 PBuf := @Buf;
 inc(PBuf,SizeOf_FRAME_HEADER);

 add(SETTINGS_HEADER_TABLE_SIZE,4096);
 add(SETTINGS_MAX_CONCURRENT_STREAMS,101);
 add(SETTINGS_INITIAL_WINDOW_SIZE,65535);
 add(SETTINGS_MAX_FRAME_SIZE,1048576);
 _PBuf := PBuf;

 with FRAME do
 begin
   Length := SettingsCount*SizeOf_SETTINGS;
   FType := FRAME_TYPE_SETTINGS;
   Flags := 0;
   Stream_ID := 0;
 end;

 // Reset Pointer to the start ...
 PBuf := @Buf;
 // ... and write HEADER
 move(FRAME,PBuf^,SizeOf_FRAME_HEADER);

 SIZE := Sizeof_FRAME_HEADER + Cardinal(FRAME.Length);

 // B) WINDOW_UPDATE FRAME

 with FRAME do
 begin
   Length := SizeOf_WINDOW_UPDATE;
   FType := FRAME_TYPE_WINDOW_UPDATE;
   Flags := 0;
   Stream_ID := 0;
 end;
 PBuf := _PBuf;
 move(FRAME,PBuf^,SizeOf_FRAME_HEADER);
 inc(PBuf,SizeOf_FRAME_HEADER);

 with WINDOW_UPDATE do
 begin
   Window_Size_Increment := 655360;
 end;
 move(WINDOW_UPDATE,PBuf^,SizeOf_WINDOW_UPDATE);

 inc(SIZE, SizeOf_FRAME_HEADER + SizeOf_WINDOW_UPDATE);

 // Return the Structure
 SetLength(result, SIZE);
 move(Buf, result[1], SIZE);
end;

{ THTTP2_Connection }

class function THTTP2_Connection.SETTING: string;
begin
  // empty SETTINGS Frame
end;

class function THTTP2_Connection.SETTING(Parameter: word; Value: Integer
  ): string;
begin
 //
end;

type
TCardinalRec = packed record
{$ifdef FPC_LITTLE_ENDIAN}
  byte0, byte1, byte2, byte3 : Byte;
{$else FPC_LITTLE_ENDIAN}
  byte3, byte2, byte1, byte0 : Byte;
{$endif FPC_LITTLE_ENDIAN}
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
    Error(reIntOverflow);
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
    Error(reIntOverflow);
{$ENDIF R+}
  Result.byte0 := TCardinalRec(a).byte0;
  Result.byte1 := TCardinalRec(a).byte1;
end;

begin
 if (SizeOf_FRAME_HEADER<>9) then
  raise exception.create('Break of RFC 7540-4.1');
 if (SizeOf_SETTINGS<>6) then
  raise exception.create('Break of RFC 7540-6.5.1');
 if (SizeOf_WINDOW_UPDATE<>4) then
  raise exception.create('Break of RFC 7540-6.9');

end.

