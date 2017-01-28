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

{$mode fpc}

interface

uses
  Classes, SysUtils;

const
   (*
  NO_ERROR (0x0):  The associated condition is not a result of an
        error.  For example, a GOAWAY might include this code to indicate
        graceful shutdown of a connection.

     PROTOCOL_ERROR (0x1):  The endpoint detected an unspecific protocol
        error.  This error is for use when a more specific error code is
        not available.

     INTERNAL_ERROR (0x2):  The endpoint encountered an unexpected
        internal error.

     FLOW_CONTROL_ERROR (0x3):  The endpoint detected that its peer
        violated the flow-control protocol.




  Belshe, et al.               Standards Track                   [Page 50]


  RFC 7540                         HTTP/2                         May 2015


     SETTINGS_TIMEOUT (0x4):  The endpoint sent a SETTINGS frame but did
        not receive a response in a timely manner.  See Section 6.5.3
        ("Settings Synchronization").

     STREAM_CLOSED (0x5):  The endpoint received a frame after a stream
        was half-closed.

     FRAME_SIZE_ERROR (0x6):  The endpoint received a frame with an
        invalid size.

     REFUSED_STREAM (0x7):  The endpoint refused the stream prior to
        performing any application processing (see Section 8.1.4 for
        details).

     CANCEL (0x8):  Used by the endpoint to indicate that the stream is no
        longer needed.

     COMPRESSION_ERROR (0x9):  The endpoint is unable to maintain the
        header compression context for the connection.

     CONNECT_ERROR (0xa):  The connection established in response to a
        CONNECT request (Section 8.3) was reset or abnormally closed.

     ENHANCE_YOUR_CALM (0xb):  The endpoint detected that its peer is
        exhibiting a behavior that might be generating excessive load.

     INADEQUATE_SECURITY (0xc):  The underlying transport has properties
        that do not meet minimum security requirements (see Section 9.2).

     HTTP_1_1_REQUIRED (0xd):  The endpoint requires that HTTP/1.1 be used
        instead of HTTP/2.
     *)

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

   // RFC: "4.1.  Frame Format"
   THTTP2_Frame = packed record
     Length : UInt24;       // UInt24
     FType : Byte;
     Flags : Byte;
     ID : Integer;
   end;


   THTTP2_Stream = class(TObject)
        ID : Integer;   { <>0, 1.. }
        weight : Integer; { 1..256, default 16 }

        window_size: Integer;    { 65,535 by default }
        SETTINGS_MAX_FRAME_SIZE : UInt24;  { 16384..16777215 }
   end;

   THTTP2_Connection = class(TObject)
        SETTINGS_MAX_CONCURRENT_STREAMS_LOCAL : Integer;
        SETTINGS_MAX_CONCURRENT_STREAMS_REMOTE: Integer;

   end;

implementation

end.

