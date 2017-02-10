{
|            _   _ __  __ _   ___  __
|           | | | |  \/  | | | \ \/ / _____
|      ____ | |_| | |\/| | | | |\  / ______
|           |  _  | |  | | |_| |/  \ ______
|           |_| |_|_|  |_|\___//_/\_\
|
|    Multiplexing for HTTP/2 (as described in RFC 7540)
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

THTTP2_Connection = class(TObject)
     SETTINGS_MAX_CONCURRENT_STREAMS_LOCAL : Integer;
     SETTINGS_MAX_CONCURRENT_STREAMS_REMOTE: Integer;

end;

THMUX = class(TObject)

 end;

implementation


Type
   // RFC: "4.1.  Frame Format"
   THTTP2_Frame = Packed Record
     Length : UInt24;       // UInt24
     FType : Byte;
     Flags : Byte;
     ID : Integer;
   end;

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





end.

