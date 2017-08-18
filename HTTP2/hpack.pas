{
|     _   _ ____   _    ____ _  __
|    | | | |  _ \ / \  / ___| |/ /
|    | |_| | |_) / _ \| |   | ' /
|    |  _  |  __/ ___ \ |___| . \
|    |_| |_|_| /_/   \_\____|_|\_\
|
|    Header Compression for HTTP/2 (as described in RFC 7541)
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
unit HPACK;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

 { THPACK }

 THPACK = class(TStringList)
   private

    // a dynamic "Key=Value" Table with a static beginning of 61 Pairs
    // Index[0] is never used
    iTABLE : TStringList;
    nTABLE : TStringList; // same as iTABLE but no values

    // a number of octets, representing the encoded representation of the headers
    iWIRE : RawByteString;

    // read/write Position of the decoder/encoder
    BytePos : UInt16; // 0..Length(iWIRE)-1
    BytePosLast: UInt16; // Length(iWIRE)-1
    BitPos : byte; // 0..7
    Octets : UInt16; // Length/Count of visible Octets, allowed to proceed (Security)

    // read Functions @ BytePos.BitPos - they move that index
    function B : boolean; inline; // read 1 Bit from the Turing Machine
    function I (MinBits:Byte) : Integer; // read Cardinal stored in at least MinBits
    function O : RawByteString; // read a octet stream of given length in [Octets]

    // write Functions
    procedure wBit(Bit:boolean);
    procedure writeInt(Int:integer);

    // Huffman Functions
    function LiteralDecode(wire:RawByteString) : RawByteString;
    function LiteralEncode(s:RawByteString):RawByteString;

    // Wire - Stream coming from the wire
    function getWire : RawByteString;
    procedure setWire(wire: RawByteString);

    function getTABLE_SIZE: Integer;
    procedure setTABLE_SIZE(M: Integer);

    // add a token to the TABLE
    procedure addTABLE(token:string);

    // add or overwrite a token, RFC calls it "incrementing"
    procedure incTABLE(token:string);

   public
     MAXIMUM_TABLE_SIZE : int64;

     constructor Create;

     // COMPRESSED DATA
     property Wire : RawByteString read getWire write setWire;

     // TABLE
     function DynTABLE : TStringList;

     // TABLE_SIZE
     property TABLE_SIZE : Integer read getTABLE_SIZE write setTABLE_SIZE;

     procedure Save(Stream:TStream);
     procedure Decode; // Wire -> Header-Strings
     procedure Encode; // Header-Strings -> Wire

     class function HexStrToRawByteString(s:String):RawByteString;
 end;

implementation

uses
   math;

const
 // RFC : "Appendix A.  Static Table Definition"
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

 DYN_TABLE_FIRST_ELEMENT = 62;
 DYN_TABLE_ELEMENT_ADD_SIZE = 32;

 SingleBitMask : array[0..7] of Byte = (
   {} %10000000,
   {} %01000000,
   {} %00100000,
   {} %00010000,
   {} %00001000,
   {} %00000100,
   {} %00000010,
   {} %00000001);

 IntegerPrefixMask : array[4..7] of Byte = (
  {} %00001111,
  {} %00011111,
  {} %00111111,
  {} %01111111);

// A) Huffman Symbol 0 .. 255 Encode Decode (Symbol 256 = EOS is privat)

// Huffman S

// "1" ~~

function encode_integer(i : Integer; prefix_bits: Byte):RawByteString;
begin
 (*
 def encode_integer(integer, prefix_bits):
     """
     This encodes an integer according to the wacky integer encoding rules
     defined in the HPACK spec.
     """
     log.debug("Encoding %d with %d bits", integer, prefix_bits)

     max_number = (2 ** prefix_bits) - 1

     if integer < max_number:
         return bytearray([integer])  # Seriously?
     else:
         elements = [max_number]
         integer -= max_number

         while integer >= 128:
             elements.append((integer % 128) + 128)
             integer //= 128  # We need integer division

         elements.append(integer)

         return bytearray(elements)
 *)
end;

function decode_integer(data: RawByteString; prefix_bits: Byte):Integer;
begin
end;

function THPACK.B: boolean; inline;
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
 // RFC: "5.1.  Integer Representation"

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

end;

(*
def decode_integer(data, prefix_bits):
    """
    This decodes an integer according to the wacky integer encoding rules
    defined in the HPACK spec. Returns a tuple of the decoded integer and the
    number of bytes that were consumed from ``data`` in order to get that
    integer.
    """
    max_number = (2 ** prefix_bits) - 1
    mask = 0xFF >> (8 - prefix_bits)
    index = 0

    try:
        number = to_byte(data[index]) & mask

        if number == max_number:

            while True:
                index += 1
                next_byte = to_byte(data[index])

                # There's some duplication here, but that's because this is a
                # hot function, and incurring too many function calls here is
                # a real problem. For that reason, we unrolled the maths.
                if next_byte >= 128:
                    number += (next_byte - 128) * (128 ** (index - 1))
                else:
                    number += next_byte * (128 ** (index - 1))
                    break
    except IndexError:
        raise HPACKDecodingError(
            "Unable to decode HPACK integer representation from %r" % data
        )

    log.debug("Decoded %d, consumed %d bytes", number, index + 1)

    return number, index + 1
*)


function THPACK.O : RawByteString;
begin
 result := copy(iWire,succ(BytePos),Octets);
 inc(BytePos,Octets);
end;

function THPACK.LiteralDecode(wire: RawByteString): RawByteString;
begin

end;

procedure THPACK.wBit(Bit: boolean);
begin

end;

procedure THPACK.writeInt(Int: integer);
begin

end;

function THPACK.LiteralEncode(s: RawByteString): RawByteString;
begin

end;

function THPACK.getWire: RawByteString;
begin

end;

procedure THPACK.setWire(wire: RawByteString);
begin
  iWIRE := wire;
end;

function THPACK.getTABLE_SIZE: Integer;
begin
 // RFC      4.1.  Calculating Table Size
 if (iTABLE.count>DYN_TABLE_FIRST_ELEMENT) then
 begin
  result :=
   {Static Part} length(iTABLE.text)-833 +
   {RFC-Rules}  ( DYN_TABLE_ELEMENT_ADD_SIZE
   {CR} -1
   {LF} -1
   {'='} -1 )
   *(iTABLE.count-DYN_TABLE_FIRST_ELEMENT);
 end else
 begin
   result := 0;
 end;
end;

procedure THPACK.setTABLE_SIZE(M: Integer);
begin
  MAXIMUM_TABLE_SIZE := M;

  // shrink to fit the new Size
  while (TABLE_SIZE>MAXIMUM_TABLE_SIZE) do
   begin
    // delete last entry
    iTABLE.delete(pred(iTABLE.count));
    nTABLE.delete(pred(nTABLE.count));
   end;

end;

procedure THPACK.addTABLE(token: string);
var
 Index,k : integer;
begin
 Index := min(iTABLE.count,DYN_TABLE_FIRST_ELEMENT);
 iTABLE.insert(Index,token);
 k := pos('=',token);
 if (k=0) then
  nTABLE.insert(Index,token)
 else
  nTABLE.insert(Index,copy(token,1,pred(k)));
end;

procedure THPACK.incTABLE(token: string);
var
  NEW_SIZE_INCREMENT: Integer;
begin

 // RFC 4.4.  Entry Eviction When Adding New Entries
 NEW_SIZE_INCREMENT :=
  {} DYN_TABLE_ELEMENT_ADD_SIZE
  {} + length(token)
  {'='} - 1;

 while (TABLE_SIZE+NEW_SIZE_INCREMENT>MAXIMUM_TABLE_SIZE) do
  begin
   // delete last entry
   iTABLE.delete(pred(iTABLE.count));
   nTABLE.delete(pred(nTABLE.count));
  end;

 if (NEW_SIZE_INCREMENT<=MAXIMUM_TABLE_SIZE) then
  addTABLE(token);

end;

constructor THPACK.Create;
var
 n,k : integer;
begin
  MAXIMUM_TABLE_SIZE := 256;
  iTABLE := TStringList.Create;
  nTABLE := TStringList.Create;
  for n := low(STATIC_TABLE) to high(STATIC_TABLE) do
   addTABLE(STATIC_TABLE[n]);

  inherited;
end;

function THPACK.DynTABLE: TStringList;
var
  n : integer;
begin
  result := TStringList.create;
              for n := DYN_TABLE_FIRST_ELEMENT to pred(iTABLE.count) do
                result.add(iTABLE[n]);
end;

procedure THPACK.Save(Stream: TStream);
begin

end;

procedure THPACK.Decode;

var
 ValueString : RawByteString;

 procedure sym(b:byte);
 begin
   ValueString := ValueString + chr(b);
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
  procedure huffman_decode;
  begin

   ValueString := '';
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
  function fHuffman_decode: RawByteString;
  begin
   huffman_decode;
   result := ValueString;
  end;

var
 NameString : string;
 NameValuePair: string;
 TABLE_INDEX : Integer;
 H : boolean;

begin
 BytePos := 0;
 BytePosLast := pred(length(iWire));
 BitPos := 0;
 while true do
 begin

   // RFC: "6. Binary Format"
   Octets := 5; // longest possible Code Block
   if B then
   begin
    // "1" ...
    // RFC: "6.1. Indexed Header Field Representation"
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
   end else
   begin
    // "0" ...
    if B then
    begin
      // "01" ...
      // RFC "6.2.1.  Literal Header Field with Incremental Indexing"
      TABLE_INDEX := I(6);
      if TABLE_INDEX>0 then
      begin
        H := B;
        Octets := I(7);
        if H then
         huffman_decode
        else
          ValueString := O;
        NameValuePair := nTABLE[TABLE_INDEX]+'='+ValueString;
      end else
      begin
        // "01" "000000"
        H := B;
        Octets := I(7);
        if H then
         NameString := fHuffman_decode
        else
         NameString := O;
        H := B;
        Octets := I(7);
        if H then
         huffman_decode
        else
         ValueString := O;
        NameValuePair := NameString+'='+ValueString;
      end;
      add(NameValuePair);
      incTABLE(NameValuePair);

    end else
    begin
     // "00 ..."
     if B then
     begin
       // "001"
       // RFC: "6.3. Dynamic Table Size Update"
       TABLE_SIZE := I(5);

     end else
     begin
      // "000 ..."
      if B then
      begin
       // "0001"
       // RFC "6.2.3.  Literal Header Field Never Indexed"
       TABLE_INDEX := I(4);
       if (TABLE_INDEX>0) then
       begin
         H := B;
         Octets := I(7);
         if H then
          huffman_decode
         else
          ValueString := O;
         add(nTABLE[TABLE_INDEX]+'='+ValueString);
       end else
       begin
         // "0001" "0000"
         H := B;
         Octets := I(7);
         if H then
          NameString := fHuffman_decode
         else
          NameString := O;
         H := B;
         Octets := I(7);
         if H then
          huffman_decode
         else
          ValueString := O;
         add(NameString+'='+ValueString);
       end;
      end else
      begin
       // "0000"
       // RFC "6.2.2.  Literal Header Field without Indexing"
       TABLE_INDEX := I(4);
       if (TABLE_INDEX>0) then
       begin
         H := B;
         Octets := I(7);
         if H then
          huffman_decode
         else
           ValueString := O;
         add(nTABLE[TABLE_INDEX]+'='+ValueString);
       end else
       begin
        // "0000" "0000"
        H := B;
        Octets := I(7);
        if H then
         NameString := fhuffman_decode
        else
         NameString := O;
        H := B;
        Octets := I(7);
        if H then
         huffman_decode
        else
         ValueString := O;
        add(NameString+'='+ValueString);
       end;
      end;
     end;
    end;
   end;
   if (BytePos>BytePosLast) then
    break;
 end;
end;

procedure THPACK.Encode;
begin
end;

class function THPACK.HexStrToRawByteString(s: String): RawByteString;
var
  n : integer;
begin
 result := '';
 for n := 1 to length(s) DIV 2 do
  result := result + chr(StrToInt('$'+copy(s,pred(n*2),2)));
end;

end.

