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


interface

uses
  Classes, SysUtils;

type

 { THPACK }

 THPACK = class(TStringList)
   private

    // a dynamic Key=Value Table with a static beginning of 61 Pairs
    iTABLE : TStringList;
    iWIRE : RawByteString;

    // read/write Position of the
    BitIndex : UInt64; // 0 .. MsgLength(octet) * 8
    BitPos : byte;
    BytePos : UInt16;
    decoderSTOPP : boolean; // Stop Huffman decoding after last symbol decoded
    procedure seek(I:UInt64);

    // read Functions
    function B : boolean; inline; // read 1 Bit from the Turing Machine
    function I (MinBits:Byte) : Integer; // read Cardinal stored in at least MinBits
    function O (Octets:Integer) : RawByteString; // read a octet stream of given length

    // write Functions
    procedure wBit(Bit:boolean);
    procedure writeInt(Int:integer);

    // Huffman Functions
    function LiteralDecode(wire:RawByteString) : RawByteString;
    function LiteralEncode(s:RawByteString):RawByteString;

    // Wire - Stream coming from the wire
    function getWire : RawByteString;
    procedure setWire(wire: RawByteString);

    // TABLE_SIZE max count of elements TABLE can have
    function getTABLE_SIZE: Integer;
    procedure setTABLE_SIZE(TABLE_SIZE: Integer);

   public
     constructor Create;

     // COMPRESSED DATA
     property Wire : RawByteString read getWire write setWire;

     // TABLE
     property HEADER_TABLE_SIZE : Integer read getTABLE_SIZE write setTABLE_SIZE;
     procedure Clear;

     procedure Save(Stream:TStream);
     procedure Decode; // Wire -> Header-Strings
     procedure Encode; // Header-Strings -> Wire

     class function HexStrToRawByteString(s:String):RawByteString;
 end;

implementation

uses
   math;

const
 STATIC_TABLE : array[0..61] of RawByteString = (
        { 00 } '',
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

 SingleBitMask : array[0..7] of byte = (
   {} %10000000,
   {} %01000000,
   {} %00100000,
   {} %00010000,
   {} %00001000,
   {} %00000100,
   {} %00000010,
   {} %00000001);

 IntegerPrefixMask : array[4..7] of byte = (
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
end;

procedure THPACK.seek(I: UInt64);
begin
 BitIndex := I;
 BitPos := BitIndex MOD 8;
 BytePos :=  BitIndex DIV 8;
end;

function THPACK.B: boolean; inline;
begin

 // read the bit
 result := (ord(iWire[succ(BytePos)]) and SingleBitMask[BitPos]) <> 0;

 // move ahead
 inc(BitPos);
 if (BitPos>7) then
 begin

  // Flip to next Byte
  inc(BytePos);
  BitPos := 0;
 end;
end;

function THPACK.I(MinBits: Byte): Integer;
var
  mask : byte;
  NoMore: boolean;
  Multiplier: Integer;
begin

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
  mask := IntegerPrefixMask[7];
  Multiplier := 0;
  repeat
   NoMore := (B=false);

   result := result + (ord(iWire[succ(BytePos)]) and mask) * trunc(power(2,Multiplier));

   // move ahead one octet
   inc(BytePos);
   BitPos := 0;

  until NoMore;
 end;

end;

function THPACK.O(Octets: Integer): RawByteString;
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

end;

procedure THPACK.setTABLE_SIZE(TABLE_SIZE: Integer);
begin

end;

constructor THPACK.Create;
var
 n : integer;
begin
  iTABLE := TStringList.Create;
  for n := low(STATIC_TABLE) to high(STATIC_TABLE) do
   iTABLE.add(STATIC_TABLE[n]);

  inherited;
end;

procedure THPACK.Clear;
begin

end;

procedure THPACK.Save(Stream: TStream);
begin

end;

procedure THPACK.Decode;
var
 TABLE_INDEX : Integer;
 H : boolean;
 ValueLength, NameLength : Integer;
 ValueString, NameString : string;

  procedure sym(b:byte);
  begin
    ValueString := ValueString + chr(b);
  end;

  function _decode: boolean;
  { this source code was generated by Oc Rev. 1.254 }
  { Oc --huff C:\Users\Andreas\Documents\Embarcadero\Studio\Projekte\OrgaMon-FS\Oc\huffman\HPACK\HPACK.huff }
  { 20170124 11:49:19 }
  begin
   result := false;
   while true or decoderSTOPP do
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
                                  sym( 22);
                                  continue;
                                 end;
                                end else
                                begin { 11111111111111111111111111110 }
                                 if B then
                                 begin { 111111111111111111111111111101 }
                                  sym( 13);
                                  continue;
                                 end else
                                 begin { 111111111111111111111111111100 }
                                  sym( 10);
                                  continue;
                                 end;
                                end;
                               end else
                               begin { 1111111111111111111111111110 }
                                sym(249);
                                continue;
                               end;
                              end else
                              begin { 111111111111111111111111110 }
                               if B then
                               begin { 1111111111111111111111111101 }
                                sym(220);
                                continue;
                               end else
                               begin { 1111111111111111111111111100 }
                                sym(127);
                                continue;
                               end;
                              end;
                             end else
                             begin { 11111111111111111111111110 }
                              if B then
                              begin { 111111111111111111111111101 }
                               if B then
                               begin { 1111111111111111111111111011 }
                                sym( 31);
                                continue;
                               end else
                               begin { 1111111111111111111111111010 }
                                sym( 30);
                                continue;
                               end;
                              end else
                              begin { 111111111111111111111111100 }
                               if B then
                               begin { 1111111111111111111111111001 }
                                sym( 29);
                                continue;
                               end else
                               begin { 1111111111111111111111111000 }
                                sym( 28);
                                continue;
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
                                sym( 27);
                                continue;
                               end else
                               begin { 1111111111111111111111110110 }
                                sym( 26);
                                continue;
                               end;
                              end else
                              begin { 111111111111111111111111010 }
                               if B then
                               begin { 1111111111111111111111110101 }
                                sym( 25);
                                continue;
                               end else
                               begin { 1111111111111111111111110100 }
                                sym( 24);
                                continue;
                               end;
                              end;
                             end else
                             begin { 11111111111111111111111100 }
                              if B then
                              begin { 111111111111111111111111001 }
                               if B then
                               begin { 1111111111111111111111110011 }
                                sym( 23);
                                continue;
                               end else
                               begin { 1111111111111111111111110010 }
                                sym( 21);
                                continue;
                               end;
                              end else
                              begin { 111111111111111111111111000 }
                               if B then
                               begin { 1111111111111111111111110001 }
                                sym( 20);
                                continue;
                               end else
                               begin { 1111111111111111111111110000 }
                                sym( 19);
                                continue;
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
                                sym( 18);
                                continue;
                               end else
                               begin { 1111111111111111111111101110 }
                                sym( 17);
                                continue;
                               end;
                              end else
                              begin { 111111111111111111111110110 }
                               if B then
                               begin { 1111111111111111111111101101 }
                                sym( 16);
                                continue;
                               end else
                               begin { 1111111111111111111111101100 }
                                sym( 15);
                                continue;
                               end;
                              end;
                             end else
                             begin { 11111111111111111111111010 }
                              if B then
                              begin { 111111111111111111111110101 }
                               if B then
                               begin { 1111111111111111111111101011 }
                                sym( 14);
                                continue;
                               end else
                               begin { 1111111111111111111111101010 }
                                sym( 12);
                                continue;
                               end;
                              end else
                              begin { 111111111111111111111110100 }
                               if B then
                               begin { 1111111111111111111111101001 }
                                sym( 11);
                                continue;
                               end else
                               begin { 1111111111111111111111101000 }
                                sym(  8);
                                continue;
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
                                sym(  7);
                                continue;
                               end else
                               begin { 1111111111111111111111100110 }
                                sym(  6);
                                continue;
                               end;
                              end else
                              begin { 111111111111111111111110010 }
                               if B then
                               begin { 1111111111111111111111100101 }
                                sym(  5);
                                continue;
                               end else
                               begin { 1111111111111111111111100100 }
                                sym(  4);
                                continue;
                               end;
                              end;
                             end else
                             begin { 11111111111111111111111000 }
                              if B then
                              begin { 111111111111111111111110001 }
                               if B then
                               begin { 1111111111111111111111100011 }
                                sym(  3);
                                continue;
                               end else
                               begin { 1111111111111111111111100010 }
                                sym(  2);
                                continue;
                               end;
                              end else
                              begin { 111111111111111111111110000 }
                               sym(254);
                               continue;
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
                               continue;
                              end else
                              begin { 111111111111111111111101110 }
                               sym(252);
                               continue;
                              end;
                             end else
                             begin { 11111111111111111111110110 }
                              if B then
                              begin { 111111111111111111111101101 }
                               sym(251);
                               continue;
                              end else
                              begin { 111111111111111111111101100 }
                               sym(250);
                               continue;
                              end;
                             end;
                            end else
                            begin { 1111111111111111111111010 }
                             if B then
                             begin { 11111111111111111111110101 }
                              if B then
                              begin { 111111111111111111111101011 }
                               sym(248);
                               continue;
                              end else
                              begin { 111111111111111111111101010 }
                               sym(247);
                               continue;
                              end;
                             end else
                             begin { 11111111111111111111110100 }
                              if B then
                              begin { 111111111111111111111101001 }
                               sym(246);
                               continue;
                              end else
                              begin { 111111111111111111111101000 }
                               sym(245);
                               continue;
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
                               continue;
                              end else
                              begin { 111111111111111111111100110 }
                               sym(241);
                               continue;
                              end;
                             end else
                             begin { 11111111111111111111110010 }
                              if B then
                              begin { 111111111111111111111100101 }
                               sym(223);
                               continue;
                              end else
                              begin { 111111111111111111111100100 }
                               sym(222);
                               continue;
                              end;
                             end;
                            end else
                            begin { 1111111111111111111111000 }
                             if B then
                             begin { 11111111111111111111110001 }
                              if B then
                              begin { 111111111111111111111100011 }
                               sym(221);
                               continue;
                              end else
                              begin { 111111111111111111111100010 }
                               sym(214);
                               continue;
                              end;
                             end else
                             begin { 11111111111111111111110000 }
                              if B then
                              begin { 111111111111111111111100001 }
                               sym(212);
                               continue;
                              end else
                              begin { 111111111111111111111100000 }
                               sym(211);
                               continue;
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
                               continue;
                              end else
                              begin { 111111111111111111111011110 }
                               sym(203);
                               continue;
                              end;
                             end else
                             begin { 11111111111111111111101110 }
                              sym(255);
                              continue;
                             end;
                            end else
                            begin { 1111111111111111111110110 }
                             if B then
                             begin { 11111111111111111111101101 }
                              sym(243);
                              continue;
                             end else
                             begin { 11111111111111111111101100 }
                              sym(242);
                              continue;
                             end;
                            end;
                           end else
                           begin { 111111111111111111111010 }
                            if B then
                            begin { 1111111111111111111110101 }
                             if B then
                             begin { 11111111111111111111101011 }
                              sym(240);
                              continue;
                             end else
                             begin { 11111111111111111111101010 }
                              sym(238);
                              continue;
                             end;
                            end else
                            begin { 1111111111111111111110100 }
                             if B then
                             begin { 11111111111111111111101001 }
                              sym(219);
                              continue;
                             end else
                             begin { 11111111111111111111101000 }
                              sym(218);
                              continue;
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
                              continue;
                             end else
                             begin { 11111111111111111111100110 }
                              sym(210);
                              continue;
                             end;
                            end else
                            begin { 1111111111111111111110010 }
                             if B then
                             begin { 11111111111111111111100101 }
                              sym(205);
                              continue;
                             end else
                             begin { 11111111111111111111100100 }
                              sym(202);
                              continue;
                             end;
                            end;
                           end else
                           begin { 111111111111111111111000 }
                            if B then
                            begin { 1111111111111111111110001 }
                             if B then
                             begin { 11111111111111111111100011 }
                              sym(201);
                              continue;
                             end else
                             begin { 11111111111111111111100010 }
                              sym(200);
                              continue;
                             end;
                            end else
                            begin { 1111111111111111111110000 }
                             if B then
                             begin { 11111111111111111111100001 }
                              sym(193);
                              continue;
                             end else
                             begin { 11111111111111111111100000 }
                              sym(192);
                              continue;
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
                             continue;
                            end else
                            begin { 1111111111111111111101110 }
                             sym(234);
                             continue;
                            end;
                           end else
                           begin { 111111111111111111110110 }
                            if B then
                            begin { 1111111111111111111101101 }
                             sym(207);
                             continue;
                            end else
                            begin { 1111111111111111111101100 }
                             sym(199);
                             continue;
                            end;
                           end;
                          end else
                          begin { 11111111111111111111010 }
                           if B then
                           begin { 111111111111111111110101 }
                            sym(237);
                            continue;
                           end else
                           begin { 111111111111111111110100 }
                            sym(236);
                            continue;
                           end;
                          end;
                         end else
                         begin { 1111111111111111111100 }
                          if B then
                          begin { 11111111111111111111001 }
                           if B then
                           begin { 111111111111111111110011 }
                            sym(225);
                            continue;
                           end else
                           begin { 111111111111111111110010 }
                            sym(215);
                            continue;
                           end;
                          end else
                          begin { 11111111111111111111000 }
                           if B then
                           begin { 111111111111111111110001 }
                            sym(206);
                            continue;
                           end else
                           begin { 111111111111111111110000 }
                            sym(171);
                            continue;
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
                            continue;
                           end else
                           begin { 111111111111111111101110 }
                            sym(148);
                            continue;
                           end;
                          end else
                          begin { 11111111111111111110110 }
                           if B then
                           begin { 111111111111111111101101 }
                            sym(145);
                            continue;
                           end else
                           begin { 111111111111111111101100 }
                            sym(144);
                            continue;
                           end;
                          end;
                         end else
                         begin { 1111111111111111111010 }
                          if B then
                          begin { 11111111111111111110101 }
                           if B then
                           begin { 111111111111111111101011 }
                            sym(142);
                            continue;
                           end else
                           begin { 111111111111111111101010 }
                            sym(  9);
                            continue;
                           end;
                          end else
                          begin { 11111111111111111110100 }
                           sym(239);
                           continue;
                          end;
                         end;
                        end else
                        begin { 111111111111111111100 }
                         if B then
                         begin { 1111111111111111111001 }
                          if B then
                          begin { 11111111111111111110011 }
                           sym(231);
                           continue;
                          end else
                          begin { 11111111111111111110010 }
                           sym(197);
                           continue;
                          end;
                         end else
                         begin { 1111111111111111111000 }
                          if B then
                          begin { 11111111111111111110001 }
                           sym(191);
                           continue;
                          end else
                          begin { 11111111111111111110000 }
                           sym(188);
                           continue;
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
                           continue;
                          end else
                          begin { 11111111111111111101110 }
                           sym(182);
                           continue;
                          end;
                         end else
                         begin { 1111111111111111110110 }
                          if B then
                          begin { 11111111111111111101101 }
                           sym(180);
                           continue;
                          end else
                          begin { 11111111111111111101100 }
                           sym(175);
                           continue;
                          end;
                         end;
                        end else
                        begin { 111111111111111111010 }
                         if B then
                         begin { 1111111111111111110101 }
                          if B then
                          begin { 11111111111111111101011 }
                           sym(174);
                           continue;
                          end else
                          begin { 11111111111111111101010 }
                           sym(168);
                           continue;
                          end;
                         end else
                         begin { 1111111111111111110100 }
                          if B then
                          begin { 11111111111111111101001 }
                           sym(166);
                           continue;
                          end else
                          begin { 11111111111111111101000 }
                           sym(165);
                           continue;
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
                           continue;
                          end else
                          begin { 11111111111111111100110 }
                           sym(157);
                           continue;
                          end;
                         end else
                         begin { 1111111111111111110010 }
                          if B then
                          begin { 11111111111111111100101 }
                           sym(155);
                           continue;
                          end else
                          begin { 11111111111111111100100 }
                           sym(152);
                           continue;
                          end;
                         end;
                        end else
                        begin { 111111111111111111000 }
                         if B then
                         begin { 1111111111111111110001 }
                          if B then
                          begin { 11111111111111111100011 }
                           sym(151);
                           continue;
                          end else
                          begin { 11111111111111111100010 }
                           sym(150);
                           continue;
                          end;
                         end else
                         begin { 1111111111111111110000 }
                          if B then
                          begin { 11111111111111111100001 }
                           sym(149);
                           continue;
                          end else
                          begin { 11111111111111111100000 }
                           sym(147);
                           continue;
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
                           continue;
                          end else
                          begin { 11111111111111111011110 }
                           sym(141);
                           continue;
                          end;
                         end else
                         begin { 1111111111111111101110 }
                          if B then
                          begin { 11111111111111111011101 }
                           sym(140);
                           continue;
                          end else
                          begin { 11111111111111111011100 }
                           sym(139);
                           continue;
                          end;
                         end;
                        end else
                        begin { 111111111111111110110 }
                         if B then
                         begin { 1111111111111111101101 }
                          if B then
                          begin { 11111111111111111011011 }
                           sym(138);
                           continue;
                          end else
                          begin { 11111111111111111011010 }
                           sym(137);
                           continue;
                          end;
                         end else
                         begin { 1111111111111111101100 }
                          if B then
                          begin { 11111111111111111011001 }
                           sym(135);
                           continue;
                          end else
                          begin { 11111111111111111011000 }
                           sym(  1);
                           continue;
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
                          continue;
                         end else
                         begin { 1111111111111111101010 }
                          sym(232);
                          continue;
                         end;
                        end else
                        begin { 111111111111111110100 }
                         if B then
                         begin { 1111111111111111101001 }
                          sym(228);
                          continue;
                         end else
                         begin { 1111111111111111101000 }
                          sym(198);
                          continue;
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
                          continue;
                         end else
                         begin { 1111111111111111100110 }
                          sym(190);
                          continue;
                         end;
                        end else
                        begin { 111111111111111110010 }
                         if B then
                         begin { 1111111111111111100101 }
                          sym(189);
                          continue;
                         end else
                         begin { 1111111111111111100100 }
                          sym(187);
                          continue;
                         end;
                        end;
                       end else
                       begin { 11111111111111111000 }
                        if B then
                        begin { 111111111111111110001 }
                         if B then
                         begin { 1111111111111111100011 }
                          sym(186);
                          continue;
                         end else
                         begin { 1111111111111111100010 }
                          sym(185);
                          continue;
                         end;
                        end else
                        begin { 111111111111111110000 }
                         if B then
                         begin { 1111111111111111100001 }
                          sym(181);
                          continue;
                         end else
                         begin { 1111111111111111100000 }
                          sym(178);
                          continue;
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
                          continue;
                         end else
                         begin { 1111111111111111011110 }
                          sym(170);
                          continue;
                         end;
                        end else
                        begin { 111111111111111101110 }
                         if B then
                         begin { 1111111111111111011101 }
                          sym(169);
                          continue;
                         end else
                         begin { 1111111111111111011100 }
                          sym(164);
                          continue;
                         end;
                        end;
                       end else
                       begin { 11111111111111110110 }
                        if B then
                        begin { 111111111111111101101 }
                         if B then
                         begin { 1111111111111111011011 }
                          sym(163);
                          continue;
                         end else
                         begin { 1111111111111111011010 }
                          sym(160);
                          continue;
                         end;
                        end else
                        begin { 111111111111111101100 }
                         if B then
                         begin { 1111111111111111011001 }
                          sym(156);
                          continue;
                         end else
                         begin { 1111111111111111011000 }
                          sym(154);
                          continue;
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
                          continue;
                         end else
                         begin { 1111111111111111010110 }
                          sym(136);
                          continue;
                         end;
                        end else
                        begin { 111111111111111101010 }
                         if B then
                         begin { 1111111111111111010101 }
                          sym(134);
                          continue;
                         end else
                         begin { 1111111111111111010100 }
                          sym(133);
                          continue;
                         end;
                        end;
                       end else
                       begin { 11111111111111110100 }
                        if B then
                        begin { 111111111111111101001 }
                         if B then
                         begin { 1111111111111111010011 }
                          sym(132);
                          continue;
                         end else
                         begin { 1111111111111111010010 }
                          sym(129);
                          continue;
                         end;
                        end else
                        begin { 111111111111111101000 }
                         sym(230);
                         continue;
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
                         continue;
                        end else
                        begin { 111111111111111100110 }
                         sym(227);
                         continue;
                        end;
                       end else
                       begin { 11111111111111110010 }
                        if B then
                        begin { 111111111111111100101 }
                         sym(217);
                         continue;
                        end else
                        begin { 111111111111111100100 }
                         sym(216);
                         continue;
                        end;
                       end;
                      end else
                      begin { 1111111111111111000 }
                       if B then
                       begin { 11111111111111110001 }
                        if B then
                        begin { 111111111111111100011 }
                         sym(209);
                         continue;
                        end else
                        begin { 111111111111111100010 }
                         sym(179);
                         continue;
                        end;
                       end else
                       begin { 11111111111111110000 }
                        if B then
                        begin { 111111111111111100001 }
                         sym(177);
                         continue;
                        end else
                        begin { 111111111111111100000 }
                         sym(176);
                         continue;
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
                         continue;
                        end else
                        begin { 111111111111111011110 }
                         sym(167);
                         continue;
                        end;
                       end else
                       begin { 11111111111111101110 }
                        if B then
                        begin { 111111111111111011101 }
                         sym(161);
                         continue;
                        end else
                        begin { 111111111111111011100 }
                         sym(153);
                         continue;
                        end;
                       end;
                      end else
                      begin { 1111111111111110110 }
                       if B then
                       begin { 11111111111111101101 }
                        sym(226);
                        continue;
                       end else
                       begin { 11111111111111101100 }
                        sym(224);
                        continue;
                       end;
                      end;
                     end else
                     begin { 111111111111111010 }
                      if B then
                      begin { 1111111111111110101 }
                       if B then
                       begin { 11111111111111101011 }
                        sym(194);
                        continue;
                       end else
                       begin { 11111111111111101010 }
                        sym(184);
                        continue;
                       end;
                      end else
                      begin { 1111111111111110100 }
                       if B then
                       begin { 11111111111111101001 }
                        sym(162);
                        continue;
                       end else
                       begin { 11111111111111101000 }
                        sym(131);
                        continue;
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
                        continue;
                       end else
                       begin { 11111111111111100110 }
                        sym(128);
                        continue;
                       end;
                      end else
                      begin { 1111111111111110010 }
                       sym(208);
                       continue;
                      end;
                     end else
                     begin { 111111111111111000 }
                      if B then
                      begin { 1111111111111110001 }
                       sym(195);
                       continue;
                      end else
                      begin { 1111111111111110000 }
                       sym( 92);
                       continue;
                      end;
                     end;
                    end;
                   end;
                  end else
                  begin { 111111111111110 }
                   sym(123);
                   continue;
                  end;
                 end else
                 begin { 11111111111110 }
                  if B then
                  begin { 111111111111101 }
                   sym( 96);
                   continue;
                  end else
                  begin { 111111111111100 }
                   sym( 60);
                   continue;
                  end;
                 end;
                end else
                begin { 1111111111110 }
                 if B then
                 begin { 11111111111101 }
                  sym(125);
                  continue;
                 end else
                 begin { 11111111111100 }
                  sym( 94);
                  continue;
                 end;
                end;
               end else
               begin { 111111111110 }
                if B then
                begin { 1111111111101 }
                 sym(126);
                 continue;
                end else
                begin { 1111111111100 }
                 sym( 93);
                 continue;
                end;
               end;
              end else
              begin { 11111111110 }
               if B then
               begin { 111111111101 }
                if B then
                begin { 1111111111011 }
                 sym( 91);
                 continue;
                end else
                begin { 1111111111010 }
                 sym( 64);
                 continue;
                end;
               end else
               begin { 111111111100 }
                if B then
                begin { 1111111111001 }
                 sym( 36);
                 continue;
                end else
                begin { 1111111111000 }
                 sym(  0);
                 continue;
                end;
               end;
              end;
             end else
             begin { 1111111110 }
              if B then
              begin { 11111111101 }
               if B then
               begin { 111111111011 }
                sym( 62);
                continue;
               end else
               begin { 111111111010 }
                sym( 35);
                continue;
               end;
              end else
              begin { 11111111100 }
               sym(124);
               continue;
              end;
             end;
            end else
            begin { 111111110 }
             if B then
             begin { 1111111101 }
              if B then
              begin { 11111111011 }
               sym( 43);
               continue;
              end else
              begin { 11111111010 }
               sym( 39);
               continue;
              end;
             end else
             begin { 1111111100 }
              sym( 63);
              continue;
             end;
            end;
           end else
           begin { 11111110 }
            if B then
            begin { 111111101 }
             if B then
             begin { 1111111011 }
              sym( 41);
              continue;
             end else
             begin { 1111111010 }
              sym( 40);
              continue;
             end;
            end else
            begin { 111111100 }
             if B then
             begin { 1111111001 }
              sym( 34);
              continue;
             end else
             begin { 1111111000 }
              sym( 33);
              continue;
             end;
            end;
           end;
          end else
          begin { 1111110 }
           if B then
           begin { 11111101 }
            sym( 90);
            continue;
           end else
           begin { 11111100 }
            sym( 88);
            continue;
           end;
          end;
         end else
         begin { 111110 }
          if B then
          begin { 1111101 }
           if B then
           begin { 11111011 }
            sym( 59);
            continue;
           end else
           begin { 11111010 }
            sym( 44);
            continue;
           end;
          end else
          begin { 1111100 }
           if B then
           begin { 11111001 }
            sym( 42);
            continue;
           end else
           begin { 11111000 }
            sym( 38);
            continue;
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
           continue;
          end else
          begin { 1111010 }
           sym(121);
           continue;
          end;
         end else
         begin { 111100 }
          if B then
          begin { 1111001 }
           sym(120);
           continue;
          end else
          begin { 1111000 }
           sym(119);
           continue;
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
           continue;
          end else
          begin { 1110110 }
           sym(113);
           continue;
          end;
         end else
         begin { 111010 }
          if B then
          begin { 1110101 }
           sym(107);
           continue;
          end else
          begin { 1110100 }
           sym(106);
           continue;
          end;
         end;
        end else
        begin { 11100 }
         if B then
         begin { 111001 }
          if B then
          begin { 1110011 }
           sym( 89);
           continue;
          end else
          begin { 1110010 }
           sym( 87);
           continue;
          end;
         end else
         begin { 111000 }
          if B then
          begin { 1110001 }
           sym( 86);
           continue;
          end else
          begin { 1110000 }
           sym( 85);
           continue;
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
           sym( 84);
           continue;
          end else
          begin { 1101110 }
           sym( 83);
           continue;
          end;
         end else
         begin { 110110 }
          if B then
          begin { 1101101 }
           sym( 82);
           continue;
          end else
          begin { 1101100 }
           sym( 81);
           continue;
          end;
         end;
        end else
        begin { 11010 }
         if B then
         begin { 110101 }
          if B then
          begin { 1101011 }
           sym( 80);
           continue;
          end else
          begin { 1101010 }
           sym( 79);
           continue;
          end;
         end else
         begin { 110100 }
          if B then
          begin { 1101001 }
           sym( 78);
           continue;
          end else
          begin { 1101000 }
           sym( 77);
           continue;
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
           sym( 76);
           continue;
          end else
          begin { 1100110 }
           sym( 75);
           continue;
          end;
         end else
         begin { 110010 }
          if B then
          begin { 1100101 }
           sym( 74);
           continue;
          end else
          begin { 1100100 }
           sym( 73);
           continue;
          end;
         end;
        end else
        begin { 11000 }
         if B then
         begin { 110001 }
          if B then
          begin { 1100011 }
           sym( 72);
           continue;
          end else
          begin { 1100010 }
           sym( 71);
           continue;
          end;
         end else
         begin { 110000 }
          if B then
          begin { 1100001 }
           sym( 70);
           continue;
          end else
          begin { 1100000 }
           sym( 69);
           continue;
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
           sym( 68);
           continue;
          end else
          begin { 1011110 }
           sym( 67);
           continue;
          end;
         end else
         begin { 101110 }
          if B then
          begin { 1011101 }
           sym( 66);
           continue;
          end else
          begin { 1011100 }
           sym( 58);
           continue;
          end;
         end;
        end else
        begin { 10110 }
         if B then
         begin { 101101 }
          sym(117);
          continue;
         end else
         begin { 101100 }
          sym(114);
          continue;
         end;
        end;
       end else
       begin { 1010 }
        if B then
        begin { 10101 }
         if B then
         begin { 101011 }
          sym(112);
          continue;
         end else
         begin { 101010 }
          sym(110);
          continue;
         end;
        end else
        begin { 10100 }
         if B then
         begin { 101001 }
          sym(109);
          continue;
         end else
         begin { 101000 }
          sym(108);
          continue;
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
          continue;
         end else
         begin { 100110 }
          sym(103);
          continue;
         end;
        end else
        begin { 10010 }
         if B then
         begin { 100101 }
          sym(102);
          continue;
         end else
         begin { 100100 }
          sym(100);
          continue;
         end;
        end;
       end else
       begin { 1000 }
        if B then
        begin { 10001 }
         if B then
         begin { 100011 }
          sym( 98);
          continue;
         end else
         begin { 100010 }
          sym( 95);
          continue;
         end;
        end else
        begin { 10000 }
         if B then
         begin { 100001 }
          sym( 65);
          continue;
         end else
         begin { 100000 }
          sym( 61);
          continue;
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
          sym( 57);
          continue;
         end else
         begin { 011110 }
          sym( 56);
          continue;
         end;
        end else
        begin { 01110 }
         if B then
         begin { 011101 }
          sym( 55);
          continue;
         end else
         begin { 011100 }
          sym( 54);
          continue;
         end;
        end;
       end else
       begin { 0110 }
        if B then
        begin { 01101 }
         if B then
         begin { 011011 }
          sym( 53);
          continue;
         end else
         begin { 011010 }
          sym( 52);
          continue;
         end;
        end else
        begin { 01100 }
         if B then
         begin { 011001 }
          sym( 51);
          continue;
         end else
         begin { 011000 }
          sym( 47);
          continue;
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
          sym( 46);
          continue;
         end else
         begin { 010110 }
          sym( 45);
          continue;
         end;
        end else
        begin { 01010 }
         if B then
         begin { 010101 }
          sym( 37);
          continue;
         end else
         begin { 010100 }
          sym( 32);
          continue;
         end;
        end;
       end else
       begin { 0100 }
        if B then
        begin { 01001 }
         sym(116);
         continue;
        end else
        begin { 01000 }
         sym(115);
         continue;
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
         continue;
        end else
        begin { 00110 }
         sym(105);
         continue;
        end;
       end else
       begin { 0010 }
        if B then
        begin { 00101 }
         sym(101);
         continue;
        end else
        begin { 00100 }
         sym( 99);
         continue;
        end;
       end;
      end else
      begin { 000 }
       if B then
       begin { 0001 }
        if B then
        begin { 00011 }
         sym( 97);
         continue;
        end else
        begin { 00010 }
         sym( 50);
         continue;
        end;
       end else
       begin { 0000 }
        if B then
        begin { 00001 }
         sym( 49);
         continue;
        end else
        begin { 00000 }
         sym( 48);
         continue;
        end;
       end;
      end;
     end;
    end;
   end;
  end;

  procedure __decode;
  begin
    ValueString := '';
    if _decode then
    begin
      if (BitPos>0) then
      begin
        inc(BytePos);
        BitPos := 0;
      end;
    end else
    begin
      raise Exception.Create('Huffman Code Error!');
    end;
  end;

begin
 BytePos := 0;
 BitPos := 0;
 while true do
 begin
   // RFC: "6. Binary Format"
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
        ValueLength := I(7);
        if H then
         ValueString := LiteralDecode(O(ValueLength))
        else
          ValueString := O(ValueLength);
      end else
      begin
        // "01" "000000"
        H := B;
        NameLength := I(7);
        if H then
         NameString := LiteralDecode(O(NameLength))
        else
         NameString := O(NameLength);
        H := B;
        ValueLength := I(7);
        if H then
         ValueString := LiteralDecode(O(ValueLength))
        else
         ValueString := O(ValueLength);
      end;
    end else
    begin
     // "00 ..."
     if B then
     begin
       // "001"
       // RFC: "6.3. Dynamic Table Size Update"
       HEADER_TABLE_SIZE := I(5);

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
        ValueLength := I(7);
        if H then
         ValueString := LiteralDecode(O(ValueLength))
        else
          ValueString := O(ValueLength);
      end else
      begin
         // "0001" "0000"
         H := B;
         NameLength := I(7);
         if H then
          NameString := LiteralDecode(O(NameLength))
         else
          NameString := O(NameLength);
         H := B;
         ValueLength := I(7);
         if H then
          ValueString := LiteralDecode(O(ValueLength))
         else
          ValueString := O(ValueLength);
        end;
      end else
      begin
       // "0000"
       // RFC "6.2.2.  Literal Header Field without Indexing"
       TABLE_INDEX := I(4);
       if (TABLE_INDEX>0) then
       begin
         H := B;
         ValueLength := I(7);
         if H then
          __decode
         else
           ValueString := O(ValueLength);
         add(iTABLE[TABLE_INDEX]+'='+ValueString);
       end else
       begin
        // "0000" "0000"
        H := B;
        NameLength := I(7);
        if H then
         NameString := LiteralDecode(O(NameLength))
        else
         NameString := O(NameLength);
        H := B;
        ValueLength := I(7);
        if H then
         ValueString := LiteralDecode(O(ValueLength))
        else
         ValueString := O(ValueLength);
       end;
      end;
     end;
    end;
   end;
   if (BytePos=length(iWire)) then
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



