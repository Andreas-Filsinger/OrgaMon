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


function StartFrame : string;

implementation


type
   // RFC: "4.1.  Frame Format"
   THTTP2_FRAME = Packed Record
     Length : UInt24;
     FType : Byte;
     Flags : Byte;
     Stream_ID : UInt32; // 0,2,4..2147483648  even-numbered on servers
   end;

const
  SizeOf_FRAME = sizeof(THTTP2_FRAME);

type
  // RFC: "6.5.1.  SETTINGS Format"
   THTTP2_SETTINGS = Packed Record
    SETTING_ID : UInt16;
    Value      : UInt32;
   end;

const
  SizeOf_SETTINGS = sizeof(THTTP2_SETTINGS);

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
 SETTINGS_MAX_FRAME_SIZE = $05; // 0..? inital 16,384
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

function StartFrame: string;
var
 Buf: array[0..pred(16*1024)] of byte;
 PBuf: ^Byte;
 FRAME : THTTP2_Frame;
 SettingsCount: Integer;
 SIZE: Integer;

 procedure add(pSETTING_ID : UInt16;pValue : UInt32);
 var
  SETTING : THTTP2_SETTINGS;
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

 PBuf := @Buf;
 inc(PBuf,SizeOf_FRAME);

 add(SETTINGS_HEADER_TABLE_SIZE,4096);
 add(SETTINGS_MAX_CONCURRENT_STREAMS,101);
 add(SETTINGS_INITIAL_WINDOW_SIZE,65535);
 add(SETTINGS_MAX_FRAME_SIZE,1048576);

 PBuf := @Buf;

 with FRAME do
 begin
   Length := SettingsCount*SizeOf_SETTINGS;
   FType := FRAME_TYPE_SETTINGS;
   Flags := 0;
   Stream_ID := 0;
 end;
 move(FRAME,PBuf^,sizeof(THTTP2_Frame));

 SIZE := Sizeof_FRAME + SettingsCount * SizeOf_SETTINGS;

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



end.

