{
|     _   _ ____   _    ____ _  __
|    | | | |  _ \ / \  / ___| |/ /
|    | |_| | |_) / _ \| |   | ' /
|    |  _  |  __/ ___ \ |___| . \
|    |_| |_|_| /_/   \_\____|_|\_\
|
|    Header Compression for HTTP/2 (as described in RFC 7541)
|
|    (c) 2017 - 2024  Andreas Filsinger
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
|    https://wiki.orgamon.org/index.php?title=HTTP2
|
}
unit HPACK;

{$mode objfpc}{$H+}
{$modeswitch advancedrecords}

interface

uses
   {$ifdef windows}
   windows,
   {$endif}
   Classes, SysUtils;

const
 DEFAULT_MAXIMUM_TABLE_SIZE = 4096;

 CONTEXT_HEADER_STREAM_ID = '%sid'; // carry the http2 Stream ID inside Request Header '%sid=17'

 // RFC 9113: 8.2.1. Field Validity
 cHEADER_FIELD_VALID = ' !"#$%&''()*+,-./0123456789:;<=>?@'+
                       '[\]^_`'+
                       'abcdefghijklmnopqrstuvwxyz'+
                       '{|}~';

type

 { THPACK }

 THPACK = class(TStringList)
   private

    // a dynamic "Key=Value" Table with a static beginning of 61 Pairs
    // Index[0] is never used
    iTABLE : TStringList; // the full name=value Table
    nTABLE : TStringList; // clone of iTABLE, but NO values

    notIndexed : TStringList; // Header-Names, where "caching" of the values makes no sense
    neverIndexed : TStringList; // Header-Names, where "caching" / "storing" and "modifiy" is forbidden

    mDebug : TStringList; // Internal Infos

    // a number of octets, representing the HPACK-encoded part of a HEADERS FRAME
    iWIRE : RawByteString;

    // read/write Position of the decoder/encoder on iWIRE
    BytePos : UInt16; // 0..Length(iWIRE)-1
    BytePosLast: UInt16; // Length(iWIRE)-1
    BitPos : byte; // 0..7
    Octets : UInt32; // Length/Count of visible coming Octets,
                     // allowed to bitwise proceed
                     // this is for more security

    // read Functions @ BytePos.BitPos - they move that index
    function B : boolean; // inline; // read 1 Bit from the Turing Machine
    function I (MinBits:Byte) : Integer; // read Cardinal stored in at least MinBits
    function O : RawByteString; // read a octet stream of given length in [Octets]

    // write Functions
    procedure wB(Bit:boolean); overload; // write one Bit true/false
    procedure wB(Bit:Byte); overload; // write one Bit 0/1
    procedure wI(Int:Integer); // write one Integer
    procedure wO(Literal : RawByteString); // write a Literal

    // Wire - Stream coming from the wire
    function getWire : RawByteString;
    procedure setWire(wire: RawByteString);

    ///////////
    // TABLE //
    ///////////

    //
    function TokenSize (const NameValuePair : string): Integer;

    // add a NameValuePair to the TABLE, and remove entrys at the end,
    // if the add-process would xceed the MAX_TABLE_SIZE
    procedure incTABLE(NameValuePair:string);

    // delete one NameValuePair from the end of the TABLE
    // decrease TABLE_SIZE
    procedure delTABLE;

    // shrink the TABLE so TABLE_SIZE<=DYNAMIC_TABLE_SIZE is true
    procedure eviction;

   public

    // the actual Size of the TABLE as defined in
    // RFC "4.1.  Calculating Table Size"
    TABLE_SIZE : int64;

    // the overall maximum allowed size of the dynamic Part of the TABLE
    // this is never change in the Livetime of a TABLE
    MAXIMUM_TABLE_SIZE : int64;

    // the actual accepted "Fill-State" of the dynamic Part of the TABLE
    DYNAMIC_TABLE_SIZE : int64;

    //
    constructor Create(Size : int64 = DEFAULT_MAXIMUM_TABLE_SIZE);

    // COMPRESSED DATA
    property Wire : RawByteString read getWire write setWire;

    // TABLE (the dynamic part)
    function DynTABLE : TStringList;
    function DebugStrings : TStringList;

    procedure set_MAXIMUM_TABLE_SIZE(Size: int64 = DEFAULT_MAXIMUM_TABLE_SIZE);

    procedure Save(Stream:TStream);
    procedure Decode; // Wire -> Header-Strings
    procedure Encode; // Header-Strings -> Wire


    class function HexStrToRawByteString(s:String) : RawByteString;
    class function HuffmanOptionToString(H:Boolean) : string;
    class function HexStrToBinaryDebug(r:RawByteString) : TStringList;
    class function RawByteStringToHuffman(R:RawByteString) : RawByteString;
    class function RawByteStringToHexStr(R:RawByteString) : String;
    //
    class function Date : string;
    class function Server : string;
 end;

implementation

uses
 anfix, math;

const
 // RFC: Appendix A.  Static Table Definition
 STATIC_TABLE : array[0..61] of RawByteString = (
        { 00 } 'orgamon.org',
        { 01 } ':authority',
        { 02 } ':method=GET',
        { 03 } ':method=POST',
        { 04 } ':path=/',
        { 05 } ':path=/index.html',
        { 06 } ':scheme=http',
        { 07 } ':scheme=https',
        { 08 } ':status=200',
        { 09 } ':status=204',
        { 10 } ':status=206',
        { 11 } ':status=304',
        { 12 } ':status=400',
        { 13 } ':status=404',
        { 14 } ':status=500',
        { 15 } 'accept-charset',
        { 16 } 'accept-encoding=gzip, deflate',
        { 17 } 'accept-language',
        { 18 } 'accept-ranges',
        { 19 } 'accept',
        { 20 } 'access-control-allow-origin',
        { 21 } 'age',
        { 22 } 'allow',
        { 23 } 'authorization',
        { 24 } 'cache-control',
        { 25 } 'content-disposition',
        { 26 } 'content-encoding',
        { 27 } 'content-language',
        { 28 } 'content-length',
        { 29 } 'content-location',
        { 30 } 'content-range',
        { 31 } 'content-type',
        { 32 } 'cookie',
        { 33 } 'date',
        { 34 } 'etag',
        { 35 } 'expect',
        { 36 } 'expires',
        { 37 } 'from',
        { 38 } 'host',
        { 39 } 'if-match',
        { 40 } 'if-modified-since',
        { 41 } 'if-none-match',
        { 42 } 'if-range',
        { 43 } 'if-unmodified-since',
        { 44 } 'last-modified',
        { 45 } 'link',
        { 46 } 'location',
        { 47 } 'max-forwards',
        { 48 } 'proxy-authenticate',
        { 49 } 'proxy-authorization',
        { 50 } 'range',
        { 51 } 'referer',
        { 52 } 'refresh',
        { 53 } 'retry-after',
        { 54 } 'server',
        { 55 } 'set-cookie',
        { 56 } 'strict-transport-security',
        { 57 } 'transfer-encoding',
        { 58 } 'user-agent',
        { 59 } 'vary',
        { 60 } 'via',
        { 61 } 'www-authenticate' );
 //  --------------------------------------------- start of dynamic Part
 //     { 62 } "sample-just-now-added-element=yes"   <--- String insert Point
 //     { 63 } "sample-add-a-minute-ago=ever"
 //     { 64 } "sample-old-element=aged"

 DYN_TABLE_FIRST_ELEMENT = 62;
 DYN_TABLE_ELEMENT_ADD_SIZE = 32;

 SingleBitMask : array[0..7] of Byte = (
   { 0 } %10000000,
   { 1 } %01000000,
   { 2 } %00100000,
   { 3 } %00010000,
   { 4 } %00001000,
   { 5 } %00000100,
   { 6 } %00000010,
   { 7 } %00000001);

 IntegerPrefixMask : array[4..7] of Byte = (
  {} %00001111,
  {} %00011111,
  {} %00111111,
  {} %01111111);

 //
 HuffmanFillupMask : array[1..7] of Byte = (
  {} %01111111,
  {} %00111111,
  {} %00011111,
  {} %00001111,
  {} %00000111,
  {} %00000011,
  {} %00000001);

// RFC : "Appendix B.  Huffman Code"

RFC_7541_Appendix_B_Bits : array[0..256] of QWord = (
  $1ff8, $7fffd8, $fffffe2, $fffffe3, $fffffe4, $fffffe5, $fffffe6, $fffffe7,
  $fffffe8, $ffffea, $3ffffffc, $fffffe9, $fffffea, $3ffffffd, $fffffeb, $fffffec,
  $fffffed, $fffffee, $fffffef, $ffffff0, $ffffff1, $ffffff2, $3ffffffe, $ffffff3,
  $ffffff4, $ffffff5, $ffffff6, $ffffff7, $ffffff8, $ffffff9, $ffffffa, $ffffffb,
  $14, $3f8, $3f9, $ffa, $1ff9, $15, $f8, $7fa, $3fa, $3fb, $f9, $7fb, $fa, $16, $17, $18,
  $0, $1, $2, $19, $1a, $1b, $1c, $1d, $1e, $1f, $5c, $fb, $7ffc, $20, $ffb, $3fc,
  $1ffa, $21, $5d, $5e, $5f, $60, $61, $62, $63, $64, $65, $66, $67, $68, $69, $6a,
  $6b, $6c, $6d, $6e, $6f, $70, $71, $72, $fc, $73, $fd, $1ffb, $7fff0, $1ffc, $3ffc, $22,
  $7ffd, $3, $23, $4, $24, $5, $25, $26, $27, $6, $74, $75, $28, $29, $2a, $7,
  $2b, $76, $2c, $8, $9, $2d, $77, $78, $79, $7a, $7b, $7ffe, $7fc, $3ffd, $1ffd, $ffffffc,
  $fffe6, $3fffd2, $fffe7, $fffe8, $3fffd3, $3fffd4, $3fffd5, $7fffd9, $3fffd6, $7fffda,
  $7fffdb, $7fffdc, $7fffdd, $7fffde, $ffffeb, $7fffdf, $ffffec, $ffffed, $3fffd7, $7fffe0,
  $ffffee, $7fffe1, $7fffe2, $7fffe3, $7fffe4, $1fffdc, $3fffd8, $7fffe5, $3fffd9, $7fffe6,
  $7fffe7, $ffffef, $3fffda, $1fffdd, $fffe9, $3fffdb, $3fffdc, $7fffe8, $7fffe9, $1fffde,
  $7fffea, $3fffdd, $3fffde, $fffff0, $1fffdf, $3fffdf, $7fffeb, $7fffec,
  $1fffe0, $1fffe1, $3fffe0, $1fffe2, $7fffed, $3fffe1, $7fffee, $7fffef,
  $fffea, $3fffe2, $3fffe3, $3fffe4, $7ffff0, $3fffe5, $3fffe6, $7ffff1,
  $3ffffe0, $3ffffe1, $fffeb, $7fff1, $3fffe7, $7ffff2, $3fffe8, $1ffffec,
  $3ffffe2, $3ffffe3, $3ffffe4, $7ffffde, $7ffffdf, $3ffffe5, $fffff1, $1ffffed,
  $7fff2, $1fffe3, $3ffffe6, $7ffffe0, $7ffffe1, $3ffffe7, $7ffffe2, $fffff2,
  $1fffe4, $1fffe5, $3ffffe8, $3ffffe9, $ffffffd, $7ffffe3, $7ffffe4, $7ffffe5,
  $fffec, $fffff3, $fffed, $1fffe6, $3fffe9, $1fffe7, $1fffe8, $7ffff3, $3fffea,
  $3fffeb, $1ffffee, $1ffffef, $fffff4, $fffff5, $3ffffea, $7ffff4,
  $3ffffeb, $7ffffe6, $3ffffec, $3ffffed, $7ffffe7, $7ffffe8, $7ffffe9, $7ffffea,
  $7ffffeb, $ffffffe, $7ffffec, $7ffffed, $7ffffee, $7ffffef, $7fffff0, $3ffffee,
  $3fffffff);

RFC_7541_Appendix_B_Length : array[0..256] of byte = (
  13, 23, 28, 28, 28, 28, 28, 28, 28, 24, 30, 28, 28, 30, 28, 28,
  28, 28, 28, 28, 28, 28, 30, 28, 28, 28, 28, 28, 28, 28, 28, 28,
   6, 10, 10, 12, 13,  6,  8, 11, 10, 10,  8, 11,  8,  6,  6,  6,
   5,  5,  5,  6,  6,  6,  6,  6,  6,  6,  7,  8, 15,  6, 12, 10,
  13,  6,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  7,
   7,  7,  7,  7,  7,  7,  7,  7,  8,  7,  8, 13, 19, 13, 14,  6,
  15,  5,  6,  5,  6,  5,  6,  6,  6,  5,  7,  7,  6,  6,  6,  5,
   6,  7,  6,  5,  5,  6,  7,  7,  7,  7,  7, 15, 11, 14, 13, 28,
  20, 22, 20, 20, 22, 22, 22, 23, 22, 23, 23, 23, 23, 23, 24, 23,
  24, 24, 22, 23, 24, 23, 23, 23, 23, 21, 22, 23, 22, 23, 23, 24,
  22, 21, 20, 22, 22, 23, 23, 21, 23, 22, 22, 24, 21, 22, 23, 23,
  21, 21, 22, 21, 23, 22, 23, 23, 20, 22, 22, 22, 23, 22, 22, 23,
  26, 26, 20, 19, 22, 23, 22, 25, 26, 26, 26, 27, 27, 26, 24, 25,
  19, 21, 26, 27, 27, 26, 27, 24, 21, 21, 26, 26, 28, 27, 27, 27,
  20, 24, 20, 21, 22, 21, 21, 23, 22, 22, 25, 25, 24, 24, 26, 23,
  26, 27, 26, 26, 27, 27, 27, 27, 27, 28, 27, 27, 27, 27, 27, 26,
  30);

function THPACK.B: boolean;  // inline;
begin

 if (Octets=0) then
 begin

   // for security: if someone reads across boarder, return "11111..."
   // this is "EOS" in the huffman code-Table
   result := true;

 end else
 begin

   // read the bit
   result := (ord(iWire[succ(BytePos)]) and SingleBitMask[BitPos]) <> 0;

   // move ahead
   inc(BitPos);
   if (BitPos>7) then
   begin

    // Flip to the next Byte
    inc(BytePos);
    BitPos := 0;

    // mark that one more Octet has gone now
    dec(Octets);

   end;
 end;
end;

function THPACK.I(MinBits: Byte): Integer;
const
  MIN_BITS_FF = 7; // After the initial "prefix", 7 Bits of an octet are used
var
  mask : byte;
  LastOctet: boolean;
  significance: Integer;
begin
 // RFC: 5.1. Integer Representation

 // prepare
 mask := IntegerPrefixMask[MinBits];

 // read the Int
 result := ord(iWire[succ(BytePos)]) and mask;

 // move ahead one octet
 inc(BytePos);
 BitPos := 0;

 // read another Part of the Int?
 if (result=mask) then
 begin
  mask := IntegerPrefixMask[MIN_BITS_FF];
  significance := 0;
  repeat
   // End of Integer-Parts?
   LastOctet := (B=false);

   // Increase result value by ...
   result := result + (ord(iWire[succ(BytePos)]) and mask) * (2 ** significance);

   // move ahead one octet
   inc(BytePos);
   BitPos := 0;

   // Leave here if no more work!
   if LastOctet then
    break;

   // increase significance for next one (if any!)
   inc(significance, MIN_BITS_FF);

  until false;
 end;
 // mDebug.add('L '+IntToStr(result));
end;

procedure THPACK.wI(Int: integer);
var
 N : Integer; // We have N Bits to store the Value
 ValueIfAllTheBitsUsed : Integer; // this value is a marker for "more to come"
begin
 // RFC 5.1.  Integer Representation
 N := 8 - BitPos;
 ValueIfAllTheBitsUsed := IntegerPrefixMask[N];

 // if I < 2^N - 1, encode I on N bits
 if (Int<ValueIfAllTheBitsUsed) then
 begin
  iWire[BytePos] := chr(Byte(iWire[BytePos]) or Byte(Int));
  inc(BytePos);
  BitPos := 0;
  exit;
 end;

 // encode (2^N - 1) on N bits
 iWire[BytePos] := chr(Byte(iWire[BytePos]) or ValueIfAllTheBitsUsed);
 inc(BytePos);
 BitPos := 0;

 // I = I - (2^N - 1)
 dec(Int,ValueIfAllTheBitsUsed);

 // Now, we have even more space: 7 Bits
 N := 7;
 ValueIfAllTheBitsUsed := IntegerPrefixMask[N];

 // while I >= 128
 while (Int>=128) do
 begin

   // encode (I % 128 + 128) on 8 bits
   wB(true);
   iWire[BytePos] := chr(Byte(iWire[BytePos]) or (Int mod 128));
   inc(BytePos);

   // I = I / 128
   Int := Int div 128;
 end;

 // encode I on 8 bits
 wB(false); // EOF-Marker "0"
 iWire[BytePos] := chr(Int);
 inc(BytePos);
 BitPos := 0;

end;

procedure THPACK.wO(Literal: RawByteString);
var
 Len : Integer;
begin
  Len := length(Literal);
  wI(Len);
  iWire += Literal;
  inc(BytePos, Len);
end;

procedure THPACK.wB(Bit: boolean);
begin
 if (BitPos=0) then
  iWire := iWire + #0;

 if Bit then
  iWire[BytePos] := chr(ord(iWire[BytePos]) or SingleBitMask[BitPos]);

 inc(BitPos);
 if (BitPos=8) then
 begin
  inc(BytePos);
  BitPos := 0;
 end;
end;

procedure THPACK.wB(Bit: Byte);
begin
  if (Bit=0) then
    wB(false)
  else
    wB(True);
end;

function THPACK.O : RawByteString;
begin
 result := copy(iWire,succ(BytePos),Octets);
 inc(BytePos, Octets);
end;

function THPACK.getWire: RawByteString;
begin
  result := iWIRE;
end;

procedure THPACK.setWire(wire: RawByteString);
begin
  iWIRE := wire;
end;

procedure THPACK.delTABLE;
var
 rmIndex : Integer;
begin
 rmIndex := pred(iTABLE.count);
 if (rmIndex>=DYN_TABLE_FIRST_ELEMENT) then
 begin
  mDebug.add('del '+IntToStr(rmIndex)+' "'+iTable[rmIndex]+'"');
  dec(TABLE_SIZE,TokenSize(iTABLE[rmIndex]));
  iTABLE.delete(rmIndex);
  nTABLE.delete(rmIndex);
 end;
end;

function THPACK.TokenSize(const NameValuePair : string): Integer;
begin
  result := DYN_TABLE_ELEMENT_ADD_SIZE + pred(length(NameValuePair));
end;

procedure THPACK.incTABLE(NameValuePair: string);
var
 NEW_SIZE_INCREMENT: Integer;
 NewIndex, k : integer;
begin

 NewIndex := min(iTABLE.count, DYN_TABLE_FIRST_ELEMENT);
 k := pos('=', NameValuePair);

 if (NewIndex=DYN_TABLE_FIRST_ELEMENT) then
 begin

  NEW_SIZE_INCREMENT := TokenSize(NameValuePair);

  // RFC 4.4.  Entry Eviction When Adding New Entries
  while (TABLE_SIZE>0) and (TABLE_SIZE+NEW_SIZE_INCREMENT>DYNAMIC_TABLE_SIZE) do
   delTABLE;

  if (NEW_SIZE_INCREMENT<=DYNAMIC_TABLE_SIZE) then
  begin
   iTABLE.insert(NewIndex,NameValuePair);
   if (k=0) then
    nTABLE.insert(NewIndex,NameValuePair)
   else
    nTABLE.insert(NewIndex,copy(NameValuePair,1,pred(k)));
   inc(TABLE_SIZE,NEW_SIZE_INCREMENT);
  end else
  begin
    if (k>0) then
     NameValuePair := copy(NameValuePair,1,pred(k));
    mDebug.add(
     {} 'WARNING: Client requests a storage of header-field '+
     {} '"' + NameValuePair+ '"' +
     {} ' knowing that there is no room for it');
  end;

 end else
 begin

  // Static Begin of the TABLE
  iTABLE.add(NameValuePair);
  if (k=0) then
   nTABLE.add(NameValuePair)
  else
   nTABLE.add(copy(NameValuePair,1,pred(k)));
 end;

end;

procedure THPACK.eviction;
begin
 // shrink the Table to fit DYNAMIC_TABLE_SIZE
 while (TABLE_SIZE>DYNAMIC_TABLE_SIZE) do
  delTABLE;
end;

constructor THPACK.Create(Size : int64 = 4096);
var
 n : integer;
begin
  MAXIMUM_TABLE_SIZE := Size;
  DYNAMIC_TABLE_SIZE := Size;
  iTABLE := TStringList.Create;
  nTABLE := TStringList.Create;
  mDebug := TStringList.Create;

  notIndexed := TStringList.Create;
  with notIndexed do
  begin
   add('date');
   add('etag');
   add('content-md5');
   // more to come
   // set-cookie? Oder ist es sogar sicherer wenn es nur einmal gesendet wird
   // uns sich ab dann in der Tabelle befindet
  end;

  neverIndexed := TStringList.Create;
  with neverIndexed do
  begin
   add('authorization');
   add('content-range');
   // more to come
  end;

  for n := low(STATIC_TABLE) to high(STATIC_TABLE) do
   incTABLE(STATIC_TABLE[n]);

  inherited Create;
end;

function THPACK.DynTABLE: TStringList;
var
  n : integer;
begin
  result := TStringList.create;
  for n := DYN_TABLE_FIRST_ELEMENT to pred(iTABLE.count) do
    result.add(iTABLE[n]);
end;

function THPACK.DebugStrings: TStringList;
begin
  result := TStringList.create;
  result.addStrings(mDebug);
  mDebug.clear;
end;

procedure THPACK.set_MAXIMUM_TABLE_SIZE(Size: int64);
begin
  MAXIMUM_TABLE_SIZE := Size;
  DYNAMIC_TABLE_SIZE := Size;
  eviction;
end;

procedure THPACK.Save(Stream: TStream);
begin

end;

procedure THPACK.Decode;

function Huffman_decode : String;

 procedure sym(b:byte);
 begin
   result += chr(b);
 end;

// { $ I RFC_7541_Appendix_B.pas}

function decode_RFC_7541_Appendix_B : boolean;
{ this source code was generated by Oc Rev. 1.254 }
{ Oc --huff C:\Users\Andreas\Documents\Embarcadero\Studio\Projekte\OrgaMon-FS\Oc\huffman\HPACK\RFC_7541_Appendix_B.huff }
{ 20170124 11:49:19 }
begin
 result := false;
 while (Octets>0) do
 begin
  if B then
  begin { 1 }
   if B then
   begin { 11 }
    if B then
    begin { 111 }
     if B then
     begin { 1111 }
      if B then
      begin { 11111 }
       if B then
       begin { 111111 }
        if B then
        begin { 1111111 }
         if B then
         begin { 11111111 }
          if B then
          begin { 111111111 }
           if B then
           begin { 1111111111 }
            if B then
            begin { 11111111111 }
             if B then
             begin { 111111111111 }
              if B then
              begin { 1111111111111 }
               if B then
               begin { 11111111111111 }
                if B then
                begin { 111111111111111 }
                 if B then
                 begin { 1111111111111111 }
                  if B then
                  begin { 11111111111111111 }
                   if B then
                   begin { 111111111111111111 }
                    if B then
                    begin { 1111111111111111111 }
                     if B then
                     begin { 11111111111111111111 }
                      if B then
                      begin { 111111111111111111111 }
                       if B then
                       begin { 1111111111111111111111 }
                        if B then
                        begin { 11111111111111111111111 }
                         if B then
                         begin { 111111111111111111111111 }
                          if B then
                          begin { 1111111111111111111111111 }
                           if B then
                           begin { 11111111111111111111111111 }
                            if B then
                            begin { 111111111111111111111111111 }
                             if B then
                             begin { 1111111111111111111111111111 }
                              if B then
                              begin { 11111111111111111111111111111 }
                               if B then
                               begin { 111111111111111111111111111111 }
                                result := true;
                                break;
                               end else
                               begin { 111111111111111111111111111110 }
                                sym(22);
                               end;
                              end else
                              begin { 11111111111111111111111111110 }
                               if B then
                               begin { 111111111111111111111111111101 }
                                sym(13);
                               end else
                               begin { 111111111111111111111111111100 }
                                sym(10);
                               end;
                              end;
                             end else
                             begin { 1111111111111111111111111110 }
                              sym(249);
                             end;
                            end else
                            begin { 111111111111111111111111110 }
                             if B then
                             begin { 1111111111111111111111111101 }
                              sym(220);
                             end else
                             begin { 1111111111111111111111111100 }
                              sym(127);
                             end;
                            end;
                           end else
                           begin { 11111111111111111111111110 }
                            if B then
                            begin { 111111111111111111111111101 }
                             if B then
                             begin { 1111111111111111111111111011 }
                              sym(31);
                             end else
                             begin { 1111111111111111111111111010 }
                              sym(30);
                             end;
                            end else
                            begin { 111111111111111111111111100 }
                             if B then
                             begin { 1111111111111111111111111001 }
                              sym(29);
                             end else
                             begin { 1111111111111111111111111000 }
                              sym(28);
                             end;
                            end;
                           end;
                          end else
                          begin { 1111111111111111111111110 }
                           if B then
                           begin { 11111111111111111111111101 }
                            if B then
                            begin { 111111111111111111111111011 }
                             if B then
                             begin { 1111111111111111111111110111 }
                              sym(27);
                             end else
                             begin { 1111111111111111111111110110 }
                              sym(26);
                             end;
                            end else
                            begin { 111111111111111111111111010 }
                             if B then
                             begin { 1111111111111111111111110101 }
                              sym(25);
                             end else
                             begin { 1111111111111111111111110100 }
                              sym(24);
                             end;
                            end;
                           end else
                           begin { 11111111111111111111111100 }
                            if B then
                            begin { 111111111111111111111111001 }
                             if B then
                             begin { 1111111111111111111111110011 }
                              sym(23);
                             end else
                             begin { 1111111111111111111111110010 }
                              sym(21);
                             end;
                            end else
                            begin { 111111111111111111111111000 }
                             if B then
                             begin { 1111111111111111111111110001 }
                              sym(20);
                             end else
                             begin { 1111111111111111111111110000 }
                              sym(19);
                             end;
                            end;
                           end;
                          end;
                         end else
                         begin { 111111111111111111111110 }
                          if B then
                          begin { 1111111111111111111111101 }
                           if B then
                           begin { 11111111111111111111111011 }
                            if B then
                            begin { 111111111111111111111110111 }
                             if B then
                             begin { 1111111111111111111111101111 }
                              sym(18);
                             end else
                             begin { 1111111111111111111111101110 }
                              sym(17);
                             end;
                            end else
                            begin { 111111111111111111111110110 }
                             if B then
                             begin { 1111111111111111111111101101 }
                              sym(16);
                             end else
                             begin { 1111111111111111111111101100 }
                              sym(15);
                             end;
                            end;
                           end else
                           begin { 11111111111111111111111010 }
                            if B then
                            begin { 111111111111111111111110101 }
                             if B then
                             begin { 1111111111111111111111101011 }
                              sym(14);
                             end else
                             begin { 1111111111111111111111101010 }
                              sym(12);
                             end;
                            end else
                            begin { 111111111111111111111110100 }
                             if B then
                             begin { 1111111111111111111111101001 }
                              sym(11);
                             end else
                             begin { 1111111111111111111111101000 }
                              sym(8);
                             end;
                            end;
                           end;
                          end else
                          begin { 1111111111111111111111100 }
                           if B then
                           begin { 11111111111111111111111001 }
                            if B then
                            begin { 111111111111111111111110011 }
                             if B then
                             begin { 1111111111111111111111100111 }
                              sym(7);
                             end else
                             begin { 1111111111111111111111100110 }
                              sym(6);
                             end;
                            end else
                            begin { 111111111111111111111110010 }
                             if B then
                             begin { 1111111111111111111111100101 }
                              sym(5);
                             end else
                             begin { 1111111111111111111111100100 }
                              sym(4);
                             end;
                            end;
                           end else
                           begin { 11111111111111111111111000 }
                            if B then
                            begin { 111111111111111111111110001 }
                             if B then
                             begin { 1111111111111111111111100011 }
                              sym(3);
                             end else
                             begin { 1111111111111111111111100010 }
                              sym(2);
                             end;
                            end else
                            begin { 111111111111111111111110000 }
                             sym(254);
                            end;
                           end;
                          end;
                         end;
                        end else
                        begin { 11111111111111111111110 }
                         if B then
                         begin { 111111111111111111111101 }
                          if B then
                          begin { 1111111111111111111111011 }
                           if B then
                           begin { 11111111111111111111110111 }
                            if B then
                            begin { 111111111111111111111101111 }
                             sym(253);
                            end else
                            begin { 111111111111111111111101110 }
                             sym(252);
                            end;
                           end else
                           begin { 11111111111111111111110110 }
                            if B then
                            begin { 111111111111111111111101101 }
                             sym(251);
                            end else
                            begin { 111111111111111111111101100 }
                             sym(250);
                            end;
                           end;
                          end else
                          begin { 1111111111111111111111010 }
                           if B then
                           begin { 11111111111111111111110101 }
                            if B then
                            begin { 111111111111111111111101011 }
                             sym(248);
                            end else
                            begin { 111111111111111111111101010 }
                             sym(247);
                            end;
                           end else
                           begin { 11111111111111111111110100 }
                            if B then
                            begin { 111111111111111111111101001 }
                             sym(246);
                            end else
                            begin { 111111111111111111111101000 }
                             sym(245);
                            end;
                           end;
                          end;
                         end else
                         begin { 111111111111111111111100 }
                          if B then
                          begin { 1111111111111111111111001 }
                           if B then
                           begin { 11111111111111111111110011 }
                            if B then
                            begin { 111111111111111111111100111 }
                             sym(244);
                            end else
                            begin { 111111111111111111111100110 }
                             sym(241);
                            end;
                           end else
                           begin { 11111111111111111111110010 }
                            if B then
                            begin { 111111111111111111111100101 }
                             sym(223);
                            end else
                            begin { 111111111111111111111100100 }
                             sym(222);
                            end;
                           end;
                          end else
                          begin { 1111111111111111111111000 }
                           if B then
                           begin { 11111111111111111111110001 }
                            if B then
                            begin { 111111111111111111111100011 }
                             sym(221);
                            end else
                            begin { 111111111111111111111100010 }
                             sym(214);
                            end;
                           end else
                           begin { 11111111111111111111110000 }
                            if B then
                            begin { 111111111111111111111100001 }
                             sym(212);
                            end else
                            begin { 111111111111111111111100000 }
                             sym(211);
                            end;
                           end;
                          end;
                         end;
                        end;
                       end else
                       begin { 1111111111111111111110 }
                        if B then
                        begin { 11111111111111111111101 }
                         if B then
                         begin { 111111111111111111111011 }
                          if B then
                          begin { 1111111111111111111110111 }
                           if B then
                           begin { 11111111111111111111101111 }
                            if B then
                            begin { 111111111111111111111011111 }
                             sym(204);
                            end else
                            begin { 111111111111111111111011110 }
                             sym(203);
                            end;
                           end else
                           begin { 11111111111111111111101110 }
                            sym(255);
                           end;
                          end else
                          begin { 1111111111111111111110110 }
                           if B then
                           begin { 11111111111111111111101101 }
                            sym(243);
                           end else
                           begin { 11111111111111111111101100 }
                            sym(242);
                           end;
                          end;
                         end else
                         begin { 111111111111111111111010 }
                          if B then
                          begin { 1111111111111111111110101 }
                           if B then
                           begin { 11111111111111111111101011 }
                            sym(240);
                           end else
                           begin { 11111111111111111111101010 }
                            sym(238);
                           end;
                          end else
                          begin { 1111111111111111111110100 }
                           if B then
                           begin { 11111111111111111111101001 }
                            sym(219);
                           end else
                           begin { 11111111111111111111101000 }
                            sym(218);
                           end;
                          end;
                         end;
                        end else
                        begin { 11111111111111111111100 }
                         if B then
                         begin { 111111111111111111111001 }
                          if B then
                          begin { 1111111111111111111110011 }
                           if B then
                           begin { 11111111111111111111100111 }
                            sym(213);
                           end else
                           begin { 11111111111111111111100110 }
                            sym(210);
                           end;
                          end else
                          begin { 1111111111111111111110010 }
                           if B then
                           begin { 11111111111111111111100101 }
                            sym(205);
                           end else
                           begin { 11111111111111111111100100 }
                            sym(202);
                           end;
                          end;
                         end else
                         begin { 111111111111111111111000 }
                          if B then
                          begin { 1111111111111111111110001 }
                           if B then
                           begin { 11111111111111111111100011 }
                            sym(201);
                           end else
                           begin { 11111111111111111111100010 }
                            sym(200);
                           end;
                          end else
                          begin { 1111111111111111111110000 }
                           if B then
                           begin { 11111111111111111111100001 }
                            sym(193);
                           end else
                           begin { 11111111111111111111100000 }
                            sym(192);
                           end;
                          end;
                         end;
                        end;
                       end;
                      end else
                      begin { 111111111111111111110 }
                       if B then
                       begin { 1111111111111111111101 }
                        if B then
                        begin { 11111111111111111111011 }
                         if B then
                         begin { 111111111111111111110111 }
                          if B then
                          begin { 1111111111111111111101111 }
                           sym(235);
                          end else
                          begin { 1111111111111111111101110 }
                           sym(234);
                          end;
                         end else
                         begin { 111111111111111111110110 }
                          if B then
                          begin { 1111111111111111111101101 }
                           sym(207);
                          end else
                          begin { 1111111111111111111101100 }
                           sym(199);
                          end;
                         end;
                        end else
                        begin { 11111111111111111111010 }
                         if B then
                         begin { 111111111111111111110101 }
                          sym(237);
                         end else
                         begin { 111111111111111111110100 }
                          sym(236);
                         end;
                        end;
                       end else
                       begin { 1111111111111111111100 }
                        if B then
                        begin { 11111111111111111111001 }
                         if B then
                         begin { 111111111111111111110011 }
                          sym(225);
                         end else
                         begin { 111111111111111111110010 }
                          sym(215);
                         end;
                        end else
                        begin { 11111111111111111111000 }
                         if B then
                         begin { 111111111111111111110001 }
                          sym(206);
                         end else
                         begin { 111111111111111111110000 }
                          sym(171);
                         end;
                        end;
                       end;
                      end;
                     end else
                     begin { 11111111111111111110 }
                      if B then
                      begin { 111111111111111111101 }
                       if B then
                       begin { 1111111111111111111011 }
                        if B then
                        begin { 11111111111111111110111 }
                         if B then
                         begin { 111111111111111111101111 }
                          sym(159);
                         end else
                         begin { 111111111111111111101110 }
                          sym(148);
                         end;
                        end else
                        begin { 11111111111111111110110 }
                         if B then
                         begin { 111111111111111111101101 }
                          sym(145);
                         end else
                         begin { 111111111111111111101100 }
                          sym(144);
                         end;
                        end;
                       end else
                       begin { 1111111111111111111010 }
                        if B then
                        begin { 11111111111111111110101 }
                         if B then
                         begin { 111111111111111111101011 }
                          sym(142);
                         end else
                         begin { 111111111111111111101010 }
                          sym(9);
                         end;
                        end else
                        begin { 11111111111111111110100 }
                         sym(239);
                        end;
                       end;
                      end else
                      begin { 111111111111111111100 }
                       if B then
                       begin { 1111111111111111111001 }
                        if B then
                        begin { 11111111111111111110011 }
                         sym(231);
                        end else
                        begin { 11111111111111111110010 }
                         sym(197);
                        end;
                       end else
                       begin { 1111111111111111111000 }
                        if B then
                        begin { 11111111111111111110001 }
                         sym(191);
                        end else
                        begin { 11111111111111111110000 }
                         sym(188);
                        end;
                       end;
                      end;
                     end;
                    end else
                    begin { 1111111111111111110 }
                     if B then
                     begin { 11111111111111111101 }
                      if B then
                      begin { 111111111111111111011 }
                       if B then
                       begin { 1111111111111111110111 }
                        if B then
                        begin { 11111111111111111101111 }
                         sym(183);
                        end else
                        begin { 11111111111111111101110 }
                         sym(182);
                        end;
                       end else
                       begin { 1111111111111111110110 }
                        if B then
                        begin { 11111111111111111101101 }
                         sym(180);
                        end else
                        begin { 11111111111111111101100 }
                         sym(175);
                        end;
                       end;
                      end else
                      begin { 111111111111111111010 }
                       if B then
                       begin { 1111111111111111110101 }
                        if B then
                        begin { 11111111111111111101011 }
                         sym(174);
                        end else
                        begin { 11111111111111111101010 }
                         sym(168);
                        end;
                       end else
                       begin { 1111111111111111110100 }
                        if B then
                        begin { 11111111111111111101001 }
                         sym(166);
                        end else
                        begin { 11111111111111111101000 }
                         sym(165);
                        end;
                       end;
                      end;
                     end else
                     begin { 11111111111111111100 }
                      if B then
                      begin { 111111111111111111001 }
                       if B then
                       begin { 1111111111111111110011 }
                        if B then
                        begin { 11111111111111111100111 }
                         sym(158);
                        end else
                        begin { 11111111111111111100110 }
                         sym(157);
                        end;
                       end else
                       begin { 1111111111111111110010 }
                        if B then
                        begin { 11111111111111111100101 }
                         sym(155);
                        end else
                        begin { 11111111111111111100100 }
                         sym(152);
                        end;
                       end;
                      end else
                      begin { 111111111111111111000 }
                       if B then
                       begin { 1111111111111111110001 }
                        if B then
                        begin { 11111111111111111100011 }
                         sym(151);
                        end else
                        begin { 11111111111111111100010 }
                         sym(150);
                        end;
                       end else
                       begin { 1111111111111111110000 }
                        if B then
                        begin { 11111111111111111100001 }
                         sym(149);
                        end else
                        begin { 11111111111111111100000 }
                         sym(147);
                        end;
                       end;
                      end;
                     end;
                    end;
                   end else
                   begin { 111111111111111110 }
                    if B then
                    begin { 1111111111111111101 }
                     if B then
                     begin { 11111111111111111011 }
                      if B then
                      begin { 111111111111111110111 }
                       if B then
                       begin { 1111111111111111101111 }
                        if B then
                        begin { 11111111111111111011111 }
                         sym(143);
                        end else
                        begin { 11111111111111111011110 }
                         sym(141);
                        end;
                       end else
                       begin { 1111111111111111101110 }
                        if B then
                        begin { 11111111111111111011101 }
                         sym(140);
                        end else
                        begin { 11111111111111111011100 }
                         sym(139);
                        end;
                       end;
                      end else
                      begin { 111111111111111110110 }
                       if B then
                       begin { 1111111111111111101101 }
                        if B then
                        begin { 11111111111111111011011 }
                         sym(138);
                        end else
                        begin { 11111111111111111011010 }
                         sym(137);
                        end;
                       end else
                       begin { 1111111111111111101100 }
                        if B then
                        begin { 11111111111111111011001 }
                         sym(135);
                        end else
                        begin { 11111111111111111011000 }
                         sym(1);
                        end;
                       end;
                      end;
                     end else
                     begin { 11111111111111111010 }
                      if B then
                      begin { 111111111111111110101 }
                       if B then
                       begin { 1111111111111111101011 }
                        sym(233);
                       end else
                       begin { 1111111111111111101010 }
                        sym(232);
                       end;
                      end else
                      begin { 111111111111111110100 }
                       if B then
                       begin { 1111111111111111101001 }
                        sym(228);
                       end else
                       begin { 1111111111111111101000 }
                        sym(198);
                       end;
                      end;
                     end;
                    end else
                    begin { 1111111111111111100 }
                     if B then
                     begin { 11111111111111111001 }
                      if B then
                      begin { 111111111111111110011 }
                       if B then
                       begin { 1111111111111111100111 }
                        sym(196);
                       end else
                       begin { 1111111111111111100110 }
                        sym(190);
                       end;
                      end else
                      begin { 111111111111111110010 }
                       if B then
                       begin { 1111111111111111100101 }
                        sym(189);
                       end else
                       begin { 1111111111111111100100 }
                        sym(187);
                       end;
                      end;
                     end else
                     begin { 11111111111111111000 }
                      if B then
                      begin { 111111111111111110001 }
                       if B then
                       begin { 1111111111111111100011 }
                        sym(186);
                       end else
                       begin { 1111111111111111100010 }
                        sym(185);
                       end;
                      end else
                      begin { 111111111111111110000 }
                       if B then
                       begin { 1111111111111111100001 }
                        sym(181);
                       end else
                       begin { 1111111111111111100000 }
                        sym(178);
                       end;
                      end;
                     end;
                    end;
                   end;
                  end else
                  begin { 11111111111111110 }
                   if B then
                   begin { 111111111111111101 }
                    if B then
                    begin { 1111111111111111011 }
                     if B then
                     begin { 11111111111111110111 }
                      if B then
                      begin { 111111111111111101111 }
                       if B then
                       begin { 1111111111111111011111 }
                        sym(173);
                       end else
                       begin { 1111111111111111011110 }
                        sym(170);
                       end;
                      end else
                      begin { 111111111111111101110 }
                       if B then
                       begin { 1111111111111111011101 }
                        sym(169);
                       end else
                       begin { 1111111111111111011100 }
                        sym(164);
                       end;
                      end;
                     end else
                     begin { 11111111111111110110 }
                      if B then
                      begin { 111111111111111101101 }
                       if B then
                       begin { 1111111111111111011011 }
                        sym(163);
                       end else
                       begin { 1111111111111111011010 }
                        sym(160);
                       end;
                      end else
                      begin { 111111111111111101100 }
                       if B then
                       begin { 1111111111111111011001 }
                        sym(156);
                       end else
                       begin { 1111111111111111011000 }
                        sym(154);
                       end;
                      end;
                     end;
                    end else
                    begin { 1111111111111111010 }
                     if B then
                     begin { 11111111111111110101 }
                      if B then
                      begin { 111111111111111101011 }
                       if B then
                       begin { 1111111111111111010111 }
                        sym(146);
                       end else
                       begin { 1111111111111111010110 }
                        sym(136);
                       end;
                      end else
                      begin { 111111111111111101010 }
                       if B then
                       begin { 1111111111111111010101 }
                        sym(134);
                       end else
                       begin { 1111111111111111010100 }
                        sym(133);
                       end;
                      end;
                     end else
                     begin { 11111111111111110100 }
                      if B then
                      begin { 111111111111111101001 }
                       if B then
                       begin { 1111111111111111010011 }
                        sym(132);
                       end else
                       begin { 1111111111111111010010 }
                        sym(129);
                       end;
                      end else
                      begin { 111111111111111101000 }
                       sym(230);
                      end;
                     end;
                    end;
                   end else
                   begin { 111111111111111100 }
                    if B then
                    begin { 1111111111111111001 }
                     if B then
                     begin { 11111111111111110011 }
                      if B then
                      begin { 111111111111111100111 }
                       sym(229);
                      end else
                      begin { 111111111111111100110 }
                       sym(227);
                      end;
                     end else
                     begin { 11111111111111110010 }
                      if B then
                      begin { 111111111111111100101 }
                       sym(217);
                      end else
                      begin { 111111111111111100100 }
                       sym(216);
                      end;
                     end;
                    end else
                    begin { 1111111111111111000 }
                     if B then
                     begin { 11111111111111110001 }
                      if B then
                      begin { 111111111111111100011 }
                       sym(209);
                      end else
                      begin { 111111111111111100010 }
                       sym(179);
                      end;
                     end else
                     begin { 11111111111111110000 }
                      if B then
                      begin { 111111111111111100001 }
                       sym(177);
                      end else
                      begin { 111111111111111100000 }
                       sym(176);
                      end;
                     end;
                    end;
                   end;
                  end;
                 end else
                 begin { 1111111111111110 }
                  if B then
                  begin { 11111111111111101 }
                   if B then
                   begin { 111111111111111011 }
                    if B then
                    begin { 1111111111111110111 }
                     if B then
                     begin { 11111111111111101111 }
                      if B then
                      begin { 111111111111111011111 }
                       sym(172);
                      end else
                      begin { 111111111111111011110 }
                       sym(167);
                      end;
                     end else
                     begin { 11111111111111101110 }
                      if B then
                      begin { 111111111111111011101 }
                       sym(161);
                      end else
                      begin { 111111111111111011100 }
                       sym(153);
                      end;
                     end;
                    end else
                    begin { 1111111111111110110 }
                     if B then
                     begin { 11111111111111101101 }
                      sym(226);
                     end else
                     begin { 11111111111111101100 }
                      sym(224);
                     end;
                    end;
                   end else
                   begin { 111111111111111010 }
                    if B then
                    begin { 1111111111111110101 }
                     if B then
                     begin { 11111111111111101011 }
                      sym(194);
                     end else
                     begin { 11111111111111101010 }
                      sym(184);
                     end;
                    end else
                    begin { 1111111111111110100 }
                     if B then
                     begin { 11111111111111101001 }
                      sym(162);
                     end else
                     begin { 11111111111111101000 }
                      sym(131);
                     end;
                    end;
                   end;
                  end else
                  begin { 11111111111111100 }
                   if B then
                   begin { 111111111111111001 }
                    if B then
                    begin { 1111111111111110011 }
                     if B then
                     begin { 11111111111111100111 }
                      sym(130);
                     end else
                     begin { 11111111111111100110 }
                      sym(128);
                     end;
                    end else
                    begin { 1111111111111110010 }
                     sym(208);
                    end;
                   end else
                   begin { 111111111111111000 }
                    if B then
                    begin { 1111111111111110001 }
                     sym(195);
                    end else
                    begin { 1111111111111110000 }
                     sym(92);
                    end;
                   end;
                  end;
                 end;
                end else
                begin { 111111111111110 }
                 sym(123);
                end;
               end else
               begin { 11111111111110 }
                if B then
                begin { 111111111111101 }
                 sym(96);
                end else
                begin { 111111111111100 }
                 sym(60);
                end;
               end;
              end else
              begin { 1111111111110 }
               if B then
               begin { 11111111111101 }
                sym(125);
               end else
               begin { 11111111111100 }
                sym(94);
               end;
              end;
             end else
             begin { 111111111110 }
              if B then
              begin { 1111111111101 }
               sym(126);
              end else
              begin { 1111111111100 }
               sym(93);
              end;
             end;
            end else
            begin { 11111111110 }
             if B then
             begin { 111111111101 }
              if B then
              begin { 1111111111011 }
               sym(91);
              end else
              begin { 1111111111010 }
               sym(64);
              end;
             end else
             begin { 111111111100 }
              if B then
              begin { 1111111111001 }
               sym(36);
              end else
              begin { 1111111111000 }
               sym(0);
              end;
             end;
            end;
           end else
           begin { 1111111110 }
            if B then
            begin { 11111111101 }
             if B then
             begin { 111111111011 }
              sym(62);
             end else
             begin { 111111111010 }
              sym(35);
             end;
            end else
            begin { 11111111100 }
             sym(124);
            end;
           end;
          end else
          begin { 111111110 }
           if B then
           begin { 1111111101 }
            if B then
            begin { 11111111011 }
             sym(43);
            end else
            begin { 11111111010 }
             sym(39);
            end;
           end else
           begin { 1111111100 }
            sym(63);
           end;
          end;
         end else
         begin { 11111110 }
          if B then
          begin { 111111101 }
           if B then
           begin { 1111111011 }
            sym(41);
           end else
           begin { 1111111010 }
            sym(40);
           end;
          end else
          begin { 111111100 }
           if B then
           begin { 1111111001 }
            sym(34);
           end else
           begin { 1111111000 }
            sym(33);
           end;
          end;
         end;
        end else
        begin { 1111110 }
         if B then
         begin { 11111101 }
          sym(90);
         end else
         begin { 11111100 }
          sym(88);
         end;
        end;
       end else
       begin { 111110 }
        if B then
        begin { 1111101 }
         if B then
         begin { 11111011 }
          sym(59);
         end else
         begin { 11111010 }
          sym(44);
         end;
        end else
        begin { 1111100 }
         if B then
         begin { 11111001 }
          sym(42);
         end else
         begin { 11111000 }
          sym(38);
         end;
        end;
       end;
      end else
      begin { 11110 }
       if B then
       begin { 111101 }
        if B then
        begin { 1111011 }
         sym(122);
        end else
        begin { 1111010 }
         sym(121);
        end;
       end else
       begin { 111100 }
        if B then
        begin { 1111001 }
         sym(120);
        end else
        begin { 1111000 }
         sym(119);
        end;
       end;
      end;
     end else
     begin { 1110 }
      if B then
      begin { 11101 }
       if B then
       begin { 111011 }
        if B then
        begin { 1110111 }
         sym(118);
        end else
        begin { 1110110 }
         sym(113);
        end;
       end else
       begin { 111010 }
        if B then
        begin { 1110101 }
         sym(107);
        end else
        begin { 1110100 }
         sym(106);
        end;
       end;
      end else
      begin { 11100 }
       if B then
       begin { 111001 }
        if B then
        begin { 1110011 }
         sym(89);
        end else
        begin { 1110010 }
         sym(87);
        end;
       end else
       begin { 111000 }
        if B then
        begin { 1110001 }
         sym(86);
        end else
        begin { 1110000 }
         sym(85);
        end;
       end;
      end;
     end;
    end else
    begin { 110 }
     if B then
     begin { 1101 }
      if B then
      begin { 11011 }
       if B then
       begin { 110111 }
        if B then
        begin { 1101111 }
         sym(84);
        end else
        begin { 1101110 }
         sym(83);
        end;
       end else
       begin { 110110 }
        if B then
        begin { 1101101 }
         sym(82);
        end else
        begin { 1101100 }
         sym(81);
        end;
       end;
      end else
      begin { 11010 }
       if B then
       begin { 110101 }
        if B then
        begin { 1101011 }
         sym(80);
        end else
        begin { 1101010 }
         sym(79);
        end;
       end else
       begin { 110100 }
        if B then
        begin { 1101001 }
         sym(78);
        end else
        begin { 1101000 }
         sym(77);
        end;
       end;
      end;
     end else
     begin { 1100 }
      if B then
      begin { 11001 }
       if B then
       begin { 110011 }
        if B then
        begin { 1100111 }
         sym(76);
        end else
        begin { 1100110 }
         sym(75);
        end;
       end else
       begin { 110010 }
        if B then
        begin { 1100101 }
         sym(74);
        end else
        begin { 1100100 }
         sym(73);
        end;
       end;
      end else
      begin { 11000 }
       if B then
       begin { 110001 }
        if B then
        begin { 1100011 }
         sym(72);
        end else
        begin { 1100010 }
         sym(71);
        end;
       end else
       begin { 110000 }
        if B then
        begin { 1100001 }
         sym(70);
        end else
        begin { 1100000 }
         sym(69);
        end;
       end;
      end;
     end;
    end;
   end else
   begin { 10 }
    if B then
    begin { 101 }
     if B then
     begin { 1011 }
      if B then
      begin { 10111 }
       if B then
       begin { 101111 }
        if B then
        begin { 1011111 }
         sym(68);
        end else
        begin { 1011110 }
         sym(67);
        end;
       end else
       begin { 101110 }
        if B then
        begin { 1011101 }
         sym(66);
        end else
        begin { 1011100 }
         sym(58);
        end;
       end;
      end else
      begin { 10110 }
       if B then
       begin { 101101 }
        sym(117);
       end else
       begin { 101100 }
        sym(114);
       end;
      end;
     end else
     begin { 1010 }
      if B then
      begin { 10101 }
       if B then
       begin { 101011 }
        sym(112);
       end else
       begin { 101010 }
        sym(110);
       end;
      end else
      begin { 10100 }
       if B then
       begin { 101001 }
        sym(109);
       end else
       begin { 101000 }
        sym(108);
       end;
      end;
     end;
    end else
    begin { 100 }
     if B then
     begin { 1001 }
      if B then
      begin { 10011 }
       if B then
       begin { 100111 }
        sym(104);
       end else
       begin { 100110 }
        sym(103);
       end;
      end else
      begin { 10010 }
       if B then
       begin { 100101 }
        sym(102);
       end else
       begin { 100100 }
        sym(100);
       end;
      end;
     end else
     begin { 1000 }
      if B then
      begin { 10001 }
       if B then
       begin { 100011 }
        sym(98);
       end else
       begin { 100010 }
        sym(95);
       end;
      end else
      begin { 10000 }
       if B then
       begin { 100001 }
        sym(65);
       end else
       begin { 100000 }
        sym(61);
       end;
      end;
     end;
    end;
   end;
  end else
  begin { 0 }
   if B then
   begin { 01 }
    if B then
    begin { 011 }
     if B then
     begin { 0111 }
      if B then
      begin { 01111 }
       if B then
       begin { 011111 }
        sym(57);
       end else
       begin { 011110 }
        sym(56);
       end;
      end else
      begin { 01110 }
       if B then
       begin { 011101 }
        sym(55);
       end else
       begin { 011100 }
        sym(54);
       end;
      end;
     end else
     begin { 0110 }
      if B then
      begin { 01101 }
       if B then
       begin { 011011 }
        sym(53);
       end else
       begin { 011010 }
        sym(52);
       end;
      end else
      begin { 01100 }
       if B then
       begin { 011001 }
        sym(51);
       end else
       begin { 011000 }
        sym(47);
       end;
      end;
     end;
    end else
    begin { 010 }
     if B then
     begin { 0101 }
      if B then
      begin { 01011 }
       if B then
       begin { 010111 }
        sym(46);
       end else
       begin { 010110 }
        sym(45);
       end;
      end else
      begin { 01010 }
       if B then
       begin { 010101 }
        sym(37);
       end else
       begin { 010100 }
        sym(32);
       end;
      end;
     end else
     begin { 0100 }
      if B then
      begin { 01001 }
       sym(116);
      end else
      begin { 01000 }
       sym(115);
      end;
     end;
    end;
   end else
   begin { 00 }
    if B then
    begin { 001 }
     if B then
     begin { 0011 }
      if B then
      begin { 00111 }
       sym(111);
      end else
      begin { 00110 }
       sym(105);
      end;
     end else
     begin { 0010 }
      if B then
      begin { 00101 }
       sym(101);
      end else
      begin { 00100 }
       sym(99);
      end;
     end;
    end else
    begin { 000 }
     if B then
     begin { 0001 }
      if B then
      begin { 00011 }
       sym(97);
      end else
      begin { 00010 }
       sym(50);
      end;
     end else
     begin { 0000 }
      if B then
      begin { 00001 }
       sym(49);
      end else
      begin { 00000 }
       sym(48);
      end;
     end;
    end;
   end;
  end;
 end;
end;

begin
   result := '';
    if not(decode_RFC_7541_Appendix_B) then
      if (Octets<>0) then
       raise Exception.Create('Huffman Code Error, '+IntTOStr(Octets)+' Octets left!');

    // skip over orphan bits
    if (BitPos>0) then
    begin
      inc(BytePos);
      BitPos := 0;
    end;
end;

var
 NameString, ValueString : String;
 NameValuePair : String;
 TABLE_INDEX : Integer;
 H_Name, H_Value : boolean;
begin
 BytePos := 0;
 BytePosLast := pred(length(iWire));
 BitPos := 0;
 Clear;
 while true do
 begin

   // RFC: 6. Binary Format
   Octets := 1; // allow only 1 Byte
   if B then
   begin
    // "1" ...
    // RFC: 6.1. Indexed Header Field Representation
    TABLE_INDEX := I(7);

    if (TABLE_INDEX=0) then
     raise Exception.Create('Table Index 0 is not valid, Coding Error');

    if (TABLE_INDEX>=iTABLE.count) then
     raise Exception.Create(
      {} 'Table Index '+
      {} IntToStr(TABLE_INDEX)+
      {} ' is not valid on a Table with '+
      {} IntToStr(iTABLE.count)+
      {} ' Elements');

    add(iTABLE[TABLE_INDEX]);
    mDebug.add('INFO: C=C "'+iTABLE[TABLE_INDEX]+'" *');
   end else
   begin
    // "0" ...
    if B then
    begin
      // "01" ...
      // RFC "6.2.1.  Literal Header Field with Incremental Indexing"
      TABLE_INDEX := I(6);

      Octets := 1; // allow only 1 more Byte
      if (TABLE_INDEX>0) then
      begin
        H_Value := B;
        Octets := I(7);
        if H_Value then
         ValueString := Huffman_decode
        else
          ValueString := O;
        NameValuePair := nTABLE[TABLE_INDEX]+'='+ValueString;

        mDebug.add('INFO: C='+HuffmanOptionToString(H_Value)+' "'+NameValuePair+'" +');
      end else
      begin
        // "01" "000000"
        H_Name := B;
        Octets := I(7);
        if H_Name then
         NameString := Huffman_decode
        else
         NameString := O;

        Octets := 1;
        H_Value := B;
        Octets := I(7);
        if H_Value then
         ValueString := Huffman_decode
        else
         ValueString := O;
        NameValuePair := NameString+'='+ValueString;

        mDebug.add('INFO: '+HuffmanOptionToString(H_Name)+'='+HuffmanOptionToString(H_Value)+ ' "'+NameValuePair+'" +');

      end;
      add(NameValuePair);
      incTABLE(NameValuePair);

    end else
    begin

     // "00 ..."
     if B then
     begin
       // "001"

       // RFC: 6.3. Dynamic Table Size Update
       DYNAMIC_TABLE_SIZE := I(5);

       if (TABLE_SIZE<=DYNAMIC_TABLE_SIZE) then
        mDebug.add('WARNING: Client requests an actual '+IntToStr(TABLE_SIZE)+' Byte(s) big TABLE purged to '+IntToStr(DYNAMIC_TABLE_SIZE)+ ' Byte(s)')
       else
        mDebug.add('INFO: DYNAMIC_TABLE_SIZE '+inttostr(DYNAMIC_TABLE_SIZE));

       if (DYNAMIC_TABLE_SIZE>=MAXIMUM_TABLE_SIZE) then
        raise Exception.Create('Illegal DYNAMIC_TABLE_SIZE request to purge higher than MAXIMUM_TABLE_SIZE');

       // RFC: 4.3. Entry Eviction When Dynamic Table Size Changes
       eviction;

     end else
     begin
      // "000 ..."

      // "0000"
      // RFC: 6.2.2. Literal Header Field without Indexing

      // "0001"
      // RFC: 6.2.3. Literal Header Field Never Indexed
       TABLE_INDEX := I(4);
       Octets := 1; // allow only 1 Byte
       if (TABLE_INDEX>0) then
       begin
         H_Value := B;
         Octets := I(7);
         if H_Value then
          ValueString := Huffman_decode
         else
          ValueString := O;
         NameValuePair := nTABLE[TABLE_INDEX]+'='+ValueString;

         mDebug.add('INFO: C='+HuffmanOptionToString(H_Value)+' "'+NameValuePair+'" -');
       end else
       begin
         // "0001" "0000"
         H_Name := B;
         Octets := I(7);
         if H_Name then
          NameString := Huffman_decode
         else
          NameString := O;

         Octets := 1;
         H_Value := B;
         Octets := I(7);
         if H_Value then
          ValueString := Huffman_decode
         else
          ValueString := O;
         NameValuePair := NameString+'='+ValueString;
         mDebug.add('INFO: '+HuffmanOptionToString(H_Name)+'='+HuffmanOptionToString(H_Value)+' "'+NameValuePair+'" -');
       end;
       add(NameValuePair);
     end;
    end;
   end;
   if (BytePos>BytePosLast) then
    break;
 end;
end;

procedure THPACK.Encode;

 // write Bit and Literal
 procedure wBL(Literal:RawByteString);
 var
  L : Integer;
  HuffmanRepresentation : RawByteString;
  HuffmanWins : boolean;
 begin
  L := length(Literal);

  HuffmanWins := false;
  repeat
   // Literals of Length "1" and "2" never get Huffman encoded
   // this is not worth it, and a waste of energy
   if (L<3) then
    break;

   // do the encoding/compression
   HuffmanRepresentation := RawByteStringToHuffman(Literal);

   // The Huffman Representation must be noticeable shorter
   // than the uncompressed Literal, if not the uncompressed
   // goes to the wire:
   // so if the gain is smaller than 2 Bytes
   if (L-length(HuffmanRepresentation)<2) then
    break;

   HuffmanWins := true;
  until true;

  if HuffmanWins then
  begin
   wb(1); wO(HuffmanRepresentation);
  end else
  begin
   wb(0); wO(Literal);
  end;

 end;


var
 n : integer;
 TABLE_INDEX : Integer;
 k : Integer;
 NameString, ValueString : RawByteString;
 Without_Index, Never_Index : boolean;

begin
 iWire := '';
 BytePos := 1;
 BitPos := 0;

 for n := 0 to pred(count) do
 begin
  // ensure Lowercase, filter invalid chars
  NameString := StrFilter(lowerCase(Strings[n]), cHEADER_FIELD_VALID);
  if (NameString<>Strings[n]) then
   mDebug.add('Header "'+Strings[n]+'" transformed to "'+NameString+'" due restrictions');

  // check if this full Name=value pair is in the TABLE
  TABLE_INDEX := iTABLE.indexof(NameString);

  if (TABLE_INDEX=-1) then
  begin

   // Split
   k := pos('=', NameString);
   if (k=0) then
   begin
    ValueString := '';
   end else
   begin
    ValueString := copy(NameString,succ(k),MaxInt);
    NameString := copy(NameString,1,pred(k));
   end;

   // check a pure "Name" Hit
   TABLE_INDEX := nTABLE.indexof(NameString);

   Without_Index := notIndexed.indexof(NameString)<>-1;
   Never_Index := neverIndexed.indexof(NameString)<>-1;

   if (Never_Index) then
     Without_Index := true;

   if not(Without_Index) then
   begin
    // RFC: 6.2.1.  Literal Header Field with Incremental Indexing
    wB(0); wB(1);  { PreFix }
   end else
   begin
    if not(Never_Index) then
    begin
     // RFC: 6.2.2.  Literal Header Field without Indexing
     wB(0); wB(0); wB(0); wB(0);  { PreFix }
    end else
    begin
     // RFC: 6.2.3.  Literal Header Field Never Indexed
     wB(0); wB(0); wB(0); wB(1); { PreFix }
    end;
   end;

   if (TABLE_INDEX=-1) then
   begin
    wI(0);
    // encode NameString
    wBL(NameString);
    // encode ValueString
    wBL(ValueString);
   end else
   begin
     // request Table for "name"
     wI(TABLE_INDEX);
     // encode Value
     wBL(ValueString);
   end;
  end else
  begin
   // full table hit (name and value)
   wb(1); { Prefix }
   wI(TABLE_INDEX);
  end;
 end;
end;

class function THPACK.HexStrToRawByteString(s: String): RawByteString;
var
  n : integer;
begin
 result := '';
 for n := 1 to length(s) DIV 2 do
  result += chr(StrToInt('$'+copy(s,pred(n*2),2)));
end;

class function THPACK.HuffmanOptionToString(H: Boolean): string;
begin
  if H then
   result := 'H'
  else
   result := 'S';
end;

class function THPACK.HexStrToBinaryDebug(r: RawByteString): TStringList;

 function toBinary (c : char; b : Integer) : string;
 begin
   if ((ord(c) and SingleBitMask[b])>0) then
    result := '1'
   else
   result := '0';
 end;

var
   n,bb : Integer;
   tmp : string;
begin
 R := HexStrToRawByteString(R);
 result := TStringList.create;
 with result do
 begin
  add('  O   I   2   3   4   5   6   7  ');
  add('+---+---+---+---+---+---+---+---+');
  for n := 1 to length(r) do
  begin
   tmp := '';
   for bb := 0 to 7 do
    tmp += '| ' + toBinary(r[n],bb) + ' ';
   add(tmp + '|');
   add('+---+---+---+---+---+---+---+---+');
  end;
 end;
end;

class function THPACK.RawByteStringToHuffman(R: RawByteString): RawByteString;
 (*
     The Idea is, to have a Work-Bench wich is long enough to hold 7 Bits AND the longest Huffman-Code (30 Bit)
     7+30 = 37 Bits, OK a 64 Bit wide Bench will do the job (48 Bit will do it too)!

     OOOOOOOO ... OOOOOOOO (a 64 Bit wide Work-Bench)
     ^
     |
     BitWritePos=0

     00000000 ... 00100001 (the Huffman-Code for "A")

     Step 1: Have the Huffman-Codes of your Token ready in the same Wideness of the Bench
     Step 2: Shift it left so that leftmost Bit is at BitWritePos
     Step 3: OR the Bench with the code
     Step 4: Increment your BitWritePos by the length of the code
     Step 5: Cut all complete leftside Bytes of your Bench and if this is possible decrement BitWritePos
     Step 6: continue with the next Token at Step 1

 *)
 var
   EAX, EBX : QWord;
   n : integer;
   Token : Integer;
   BitWritePos : Byte;
   BitLen : Byte;
 begin
   result := '';
   EAX := 0;
   BitWritePos := 0;

   for n := 1 to length(R) do
   begin

    Token := ord(R[n]);
    BitLen := RFC_7541_Appendix_B_Length[Token];
    EBX := RFC_7541_Appendix_B_Bits[Token];
    EAX := EAX or (EBX shl (64 - BitLen - BitWritePos));
    inc(BitWritePos, BitLen);

    // pull out fully ready Bytes
    while (BitWritePos>7) do
    begin

     // take most left byte
     result += chr(EAX shr 56);

     // destroy it!
     EAX := EAX shl 8;

     // move write Pointer
     dec(BitWritePos, 8);
    end;

   end;

   // emit the last few bits - fitting in a last byte
   // fill all the unused with "1s" that will fullfill Huffman Rules
   // we never! emit the EOS Symbol
   if (BitWritePos>0) then
     result += chr((EAX shr 56) + HuffmanFillupMask[BitWritePos] );

end;

class function THPACK.RawByteStringToHexStr(R: RawByteString): String;
var
  n : Integer;
begin
 result := '';
 for n := 1 to length(R) do
   result += IntToHex(ord(R[n]),2);
end;

function NowGMT: TDateTime;
var
  ST: TSystemTime;
begin
  // This Windows API function gets system time in UTC/GMT
  // see http://msdn.microsoft.com/en-us/library/ms724390
  GetSystemTime(ST);
  Result := SystemTimeToDateTime(ST);
end;

class function THPACK.Date: string;
//
// RFC1123 / rfc1849 5.1.  Date
// 'ShortDayNames, d[d] ShortMonthNames YYYY hh:nn:ss GMT'
// Length(Date) is 28 or 29
//

// imp pend:
//
// "Date" should be calculated at the first time requested and then
// be a huffman-compressed constant for about 1000 ms.
// After this, a time should callback us to update the constant.
// A sync Object should ensure nothing is going wrong in this
// update phase.
//

const
 ShortDayNames : Array[1..7] of string =
   ( 'Sun','Mon','Tue','Wed','Thu','Fri','Sat' );
 ShortMonthNames : Array[1..12] of string =
   ( 'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec' );
var
 N : TDateTime;
 Year, Month, Day: word;
begin
 N := NowGMT;
 DecodeDate(N, Year, Month, Day);
 result :=
  { } ShortDayNames[DayOfWeek(N)] + ', ' +
  { } IntToStr(Day) + ' ' +
  { } ShortMonthNames[Month] + ' ' +
  { } IntToStr(Year) + ' ' +
  { } FormatDateTime(
  { } 'hh:nn:ss', N) +
  { } ' GMT';
end;

class function THPACK.Server: string;
begin
  // ..\..\rev\polyzalos.rev.txt
  result := 'Polyzalos/9.002';
end;

end.

