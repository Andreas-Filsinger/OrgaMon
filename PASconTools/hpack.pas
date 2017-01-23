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

{$mode delphi}

interface

uses
  Classes, SysUtils;

type
 THPACK = class(TStringList)
   privat
    // dynamic Table with a static beginning
    TABLE : TStringList;

    //
    BitPointer : Int64; // 0 .. MsgLength(octet) * 8

    // decode Functions
    function Bit: boolean; // read 1 Bit from the Turing Machine
    function Int4plus : Integer;
    function Int5plus : Integer;
    function Int6plus : Integer;
    function Int7plus : Integer;
    function Int8plus : Integer;
    function LiteralDecode(wire:RawByteString):RawByteString;

    // encode Functions
    procedure wBit(One:boolean);
    procedure writeInt(i:integer);
    function LiteralEncode(s:RawByteString):RawByteString;

    function getWire : RawByteString;
    procedure setWire(wire: RawByteString);
   public
     property Wire : read getWrite write setWire;
     property HEADER_TABLE_SIZE : read get TableSize write setTableSize(integer);
     procedure Clear;
     procedure Save(Stream:TStream);
 end;

implementation


const
 STATIC_TABLE = array[1..61] of RawByteString (
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

// A) Huffman Symbol 0 .. 255 Encode Decode (Symbol 256 = EOS is privat)

function LiteralEncode(s:RawByteString):RawByteString;
begin
end;

function LiteralDecode(wire:RawByteString):RawByteString;
begin
end;

// Huffman S

// "1" ~~

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


procedure Decode;

begin
 if Bit then
 begin
  // "1" ...
  TABLE_INDEX := int7+;
  if (TABLE_INDEX=0) then
   Except('Table Index 0 is not valid, Coding Error');
  if (TABLE_INDEX>=.count) then
   Except('Table Index '+TABLE_INDEX+' is not valid on a Table with '+.count+' Elements');
 end else
 begin
  // "0" ...
  if Bit then
  begin
   // "01" ...
    TABLE_INDEX := int6+;
    if TABLE_INDEX>0 then
    begin
      H := Bit;
      ValueLength := int7+;
      if H then
       ValueString := LiteralDecode(octets(ValueLength))
      else
        ValueString := octets(ValueLength);
    end else
    begin
      // "01" "000000"
      H := Bit;
      NameLength := int7+;
      if H then
       NameString := LiteralDecode(octets(NameLength))
      else
       NameString := octets(NameLength);
      H := Bit;
      ValueLength := int7+;
      if H then
       ValueString := LiteralDecode(octets(ValueLength))
      else
       ValueString := octets(ValueLength);
    end;
  end else
  begin
   // "00"
   if Bit then
   begin
     // "001"
     // 6.3. Dynamic Table Size Update
     HEADER_TABLE_SIZE := int5+;

   end else
   begin
    // 000
    if Bit then
    begin
      // "0001"
    TABLE_INDEX := int4+;
    if (TABLE_INDEX>0) then
    begin
    H := Bit;
    ValueLength := int7+;
    if H then
     ValueString := LiteralDecode(octets(ValueLength))
    else
      ValueString := octets(ValueLength);

    end else
    begin
      // "0001" "0000"
     H := Bit;
     NameLength := int7+;
     if H then
      NameString := LiteralDecode(octets(NameLength))
     else
      NameString := octets(NameLength);
     H := Bit;
     ValueLength := int7+;
     if H then
      ValueString := LiteralDecode(octets(ValueLength))
     else
      ValueString := octets(ValueLength);
    end;

    end else
    begin
      // 0000
     TABLE_INDEX := int4+;
     if (TABLE_INDEX>0) then
     begin
     H := Bit;
     ValueLength := int7+;
     if H then
      ValueString := LiteralDecode(octets(ValueLength))
     else
       ValueString := octets(ValueLength);
     end else
     begin
      // "0000" "0000"
      H := Bit;
      NameLength := int7+;
      if H then
       NameString := LiteralDecode(octets(NameLength))
      else
       NameString := octets(NameLength);
      H := Bit;
      ValueLength := int7+;
      if H then
       ValueString := LiteralDecode(octets(ValueLength))
      else
       ValueString := octets(ValueLength);
     end;
    end;
   end;
  end;
 end;
end;

procedure Encode;
begin

end.

(*

HPACK Source for Compiler - Code - Generation
(c)

Huffman:
(  0)  |11111111|11000                             1ff8  [13]
(  1)  |11111111|11111111|1011000                7fffd8  [23]
(  2)  |11111111|11111111|11111110|0010         fffffe2  [28]
(  3)  |11111111|11111111|11111110|0011         fffffe3  [28]
(  4)  |11111111|11111111|11111110|0100         fffffe4  [28]
(  5)  |11111111|11111111|11111110|0101         fffffe5  [28]
(  6)  |11111111|11111111|11111110|0110         fffffe6  [28]
(  7)  |11111111|11111111|11111110|0111         fffffe7  [28]
(  8)  |11111111|11111111|11111110|1000         fffffe8  [28]
(  9)  |11111111|11111111|11101010               ffffea  [24]
( 10)  |11111111|11111111|11111111|111100      3ffffffc  [30]
( 11)  |11111111|11111111|11111110|1001         fffffe9  [28]
( 12)  |11111111|11111111|11111110|1010         fffffea  [28]
( 13)  |11111111|11111111|11111111|111101      3ffffffd  [30]
( 14)  |11111111|11111111|11111110|1011         fffffeb  [28]
( 15)  |11111111|11111111|11111110|1100         fffffec  [28]
( 16)  |11111111|11111111|11111110|1101         fffffed  [28]
( 17)  |11111111|11111111|11111110|1110         fffffee  [28]
( 18)  |11111111|11111111|11111110|1111         fffffef  [28]
( 19)  |11111111|11111111|11111111|0000         ffffff0  [28]
( 20)  |11111111|11111111|11111111|0001         ffffff1  [28]
( 21)  |11111111|11111111|11111111|0010         ffffff2  [28]
( 22)  |11111111|11111111|11111111|111110      3ffffffe  [30]
( 23)  |11111111|11111111|11111111|0011         ffffff3  [28]
( 24)  |11111111|11111111|11111111|0100         ffffff4  [28]
( 25)  |11111111|11111111|11111111|0101         ffffff5  [28]
( 26)  |11111111|11111111|11111111|0110         ffffff6  [28]
( 27)  |11111111|11111111|11111111|0111         ffffff7  [28]
( 28)  |11111111|11111111|11111111|1000         ffffff8  [28]
( 29)  |11111111|11111111|11111111|1001         ffffff9  [28]
( 30)  |11111111|11111111|11111111|1010         ffffffa  [28]
( 31)  |11111111|11111111|11111111|1011         ffffffb  [28]
( 32)  |010100                                       14  [ 6]
( 33)  |11111110|00                                 3f8  [10]
( 34)  |11111110|01                                 3f9  [10]
( 35)  |11111111|1010                               ffa  [12]
( 36)  |11111111|11001                             1ff9  [13]
( 37)  |010101                                       15  [ 6]
( 38)  |11111000                                     f8  [ 8]
( 39)  |11111111|010                                7fa  [11]
( 40)  |11111110|10                                 3fa  [10]
( 41)  |11111110|11                                 3fb  [10]
( 42)  |11111001                                     f9  [ 8]
( 43)  |11111111|011                                7fb  [11]
( 44)  |11111010                                     fa  [ 8]
( 45)  |010110                                       16  [ 6]
( 46)  |010111                                       17  [ 6]
( 47)  |011000                                       18  [ 6]
( 48)  |00000                                         0  [ 5]
( 49)  |00001                                         1  [ 5]
( 50)  |00010                                         2  [ 5]
( 51)  |011001                                       19  [ 6]
( 52)  |011010                                       1a  [ 6]
( 53)  |011011                                       1b  [ 6]
( 54)  |011100                                       1c  [ 6]
( 55)  |011101                                       1d  [ 6]
( 56)  |011110                                       1e  [ 6]
( 57)  |011111                                       1f  [ 6]
( 58)  |1011100                                      5c  [ 7]
( 59)  |11111011                                     fb  [ 8]
( 60)  |11111111|1111100                           7ffc  [15]
( 61)  |100000                                       20  [ 6]
( 62)  |11111111|1011                               ffb  [12]
( 63)  |11111111|00                                 3fc  [10]
( 64)  |11111111|11010                             1ffa  [13]
( 65)  |100001                                       21  [ 6]
( 66)  |1011101                                      5d  [ 7]
( 67)  |1011110                                      5e  [ 7]
( 68)  |1011111                                      5f  [ 7]
( 69)  |1100000                                      60  [ 7]
( 70)  |1100001                                      61  [ 7]
( 71)  |1100010                                      62  [ 7]
( 72)  |1100011                                      63  [ 7]
( 73)  |1100100                                      64  [ 7]
( 74)  |1100101                                      65  [ 7]
( 75)  |1100110                                      66  [ 7]
( 76)  |1100111                                      67  [ 7]
( 77)  |1101000                                      68  [ 7]
( 78)  |1101001                                      69  [ 7]
( 79)  |1101010                                      6a  [ 7]
( 80)  |1101011                                      6b  [ 7]
( 81)  |1101100                                      6c  [ 7]
( 82)  |1101101                                      6d  [ 7]
( 83)  |1101110                                      6e  [ 7]
( 84)  |1101111                                      6f  [ 7]
( 85)  |1110000                                      70  [ 7]
( 86)  |1110001                                      71  [ 7]
( 87)  |1110010                                      72  [ 7]
( 88)  |11111100                                     fc  [ 8]
( 89)  |1110011                                      73  [ 7]
( 90)  |11111101                                     fd  [ 8]
( 91)  |11111111|11011                             1ffb  [13]
( 92)  |11111111|11111110|000                     7fff0  [19]
( 93)  |11111111|11100                             1ffc  [13]
( 94)  |11111111|111100                            3ffc  [14]
( 95)  |100010                                       22  [ 6]
( 96)  |11111111|1111101                           7ffd  [15]
( 97)  |00011                                         3  [ 5]
( 98)  |100011                                       23  [ 6]
( 99)  |00100                                         4  [ 5]
(100)  |100100                                       24  [ 6]
(101)  |00101                                         5  [ 5]
(102)  |100101                                       25  [ 6]
(103)  |100110                                       26  [ 6]
(104)  |100111                                       27  [ 6]
(105)  |00110                                         6  [ 5]
(106)  |1110100                                      74  [ 7]
(107)  |1110101                                      75  [ 7]
(108)  |101000                                       28  [ 6]
(109)  |101001                                       29  [ 6]
(110)  |101010                                       2a  [ 6]
(111)  |00111                                         7  [ 5]
(112)  |101011                                       2b  [ 6]
(113)  |1110110                                      76  [ 7]
(114)  |101100                                       2c  [ 6]
(115)  |01000                                         8  [ 5]
(116)  |01001                                         9  [ 5]
(117)  |101101                                       2d  [ 6]
(118)  |1110111                                      77  [ 7]
(119)  |1111000                                      78  [ 7]
(120)  |1111001                                      79  [ 7]
(121)  |1111010                                      7a  [ 7]
(122)  |1111011                                      7b  [ 7]
(123)  |11111111|1111110                           7ffe  [15]
(124)  |11111111|100                                7fc  [11]
(125)  |11111111|111101                            3ffd  [14]
(126)  |11111111|11101                             1ffd  [13]
(127)  |11111111|11111111|11111111|1100         ffffffc  [28]
(128)  |11111111|11111110|0110                    fffe6  [20]
(129)  |11111111|11111111|010010                 3fffd2  [22]
(130)  |11111111|11111110|0111                    fffe7  [20]
(131)  |11111111|11111110|1000                    fffe8  [20]
(132)  |11111111|11111111|010011                 3fffd3  [22]
(133)  |11111111|11111111|010100                 3fffd4  [22]
(134)  |11111111|11111111|010101                 3fffd5  [22]
(135)  |11111111|11111111|1011001                7fffd9  [23]
(136)  |11111111|11111111|010110                 3fffd6  [22]
(137)  |11111111|11111111|1011010                7fffda  [23]
(138)  |11111111|11111111|1011011                7fffdb  [23]
(139)  |11111111|11111111|1011100                7fffdc  [23]
(140)  |11111111|11111111|1011101                7fffdd  [23]
(141)  |11111111|11111111|1011110                7fffde  [23]
(142)  |11111111|11111111|11101011               ffffeb  [24]
(143)  |11111111|11111111|1011111                7fffdf  [23]
(144)  |11111111|11111111|11101100               ffffec  [24]
(145)  |11111111|11111111|11101101               ffffed  [24]
(146)  |11111111|11111111|010111                 3fffd7  [22]
(147)  |11111111|11111111|1100000                7fffe0  [23]
(148)  |11111111|11111111|11101110               ffffee  [24]
(149)  |11111111|11111111|1100001                7fffe1  [23]
(150)  |11111111|11111111|1100010                7fffe2  [23]
(151)  |11111111|11111111|1100011                7fffe3  [23]
(152)  |11111111|11111111|1100100                7fffe4  [23]
(153)  |11111111|11111110|11100                  1fffdc  [21]
(154)  |11111111|11111111|011000                 3fffd8  [22]
(155)  |11111111|11111111|1100101                7fffe5  [23]
(156)  |11111111|11111111|011001                 3fffd9  [22]
(157)  |11111111|11111111|1100110                7fffe6  [23]
(158)  |11111111|11111111|1100111                7fffe7  [23]
(159)  |11111111|11111111|11101111               ffffef  [24]
(160)  |11111111|11111111|011010                 3fffda  [22]
(161)  |11111111|11111110|11101                  1fffdd  [21]
(162)  |11111111|11111110|1001                    fffe9  [20]
(163)  |11111111|11111111|011011                 3fffdb  [22]
(164)  |11111111|11111111|011100                 3fffdc  [22]
(165)  |11111111|11111111|1101000                7fffe8  [23]
(166)  |11111111|11111111|1101001                7fffe9  [23]
(167)  |11111111|11111110|11110                  1fffde  [21]
(168)  |11111111|11111111|1101010                7fffea  [23]
(169)  |11111111|11111111|011101                 3fffdd  [22]
(170)  |11111111|11111111|011110                 3fffde  [22]
(171)  |11111111|11111111|11110000               fffff0  [24]
(172)  |11111111|11111110|11111                  1fffdf  [21]
(173)  |11111111|11111111|011111                 3fffdf  [22]
(174)  |11111111|11111111|1101011                7fffeb  [23]
(175)  |11111111|11111111|1101100                7fffec  [23]
(176)  |11111111|11111111|00000                  1fffe0  [21]
(177)  |11111111|11111111|00001                  1fffe1  [21]
(178)  |11111111|11111111|100000                 3fffe0  [22]
(179)  |11111111|11111111|00010                  1fffe2  [21]
(180)  |11111111|11111111|1101101                7fffed  [23]
(181)  |11111111|11111111|100001                 3fffe1  [22]
(182)  |11111111|11111111|1101110                7fffee  [23]
(183)  |11111111|11111111|1101111                7fffef  [23]
(184)  |11111111|11111110|1010                    fffea  [20]
(185)  |11111111|11111111|100010                 3fffe2  [22]
(186)  |11111111|11111111|100011                 3fffe3  [22]
(187)  |11111111|11111111|100100                 3fffe4  [22]
(188)  |11111111|11111111|1110000                7ffff0  [23]
(189)  |11111111|11111111|100101                 3fffe5  [22]
(190)  |11111111|11111111|100110                 3fffe6  [22]
(191)  |11111111|11111111|1110001                7ffff1  [23]
(192)  |11111111|11111111|11111000|00           3ffffe0  [26]
(193)  |11111111|11111111|11111000|01           3ffffe1  [26]
(194)  |11111111|11111110|1011                    fffeb  [20]
(195)  |11111111|11111110|001                     7fff1  [19]
(196)  |11111111|11111111|100111                 3fffe7  [22]
(197)  |11111111|11111111|1110010                7ffff2  [23]
(198)  |11111111|11111111|101000                 3fffe8  [22]
(199)  |11111111|11111111|11110110|0            1ffffec  [25]
(200)  |11111111|11111111|11111000|10           3ffffe2  [26]
(201)  |11111111|11111111|11111000|11           3ffffe3  [26]
(202)  |11111111|11111111|11111001|00           3ffffe4  [26]
(203)  |11111111|11111111|11111011|110          7ffffde  [27]
(204)  |11111111|11111111|11111011|111          7ffffdf  [27]
(205)  |11111111|11111111|11111001|01           3ffffe5  [26]
(206)  |11111111|11111111|11110001               fffff1  [24]
(207)  |11111111|11111111|11110110|1            1ffffed  [25]
(208)  |11111111|11111110|010                     7fff2  [19]
(209)  |11111111|11111111|00011                  1fffe3  [21]
(210)  |11111111|11111111|11111001|10           3ffffe6  [26]
(211)  |11111111|11111111|11111100|000          7ffffe0  [27]
(212)  |11111111|11111111|11111100|001          7ffffe1  [27]
(213)  |11111111|11111111|11111001|11           3ffffe7  [26]
(214)  |11111111|11111111|11111100|010          7ffffe2  [27]
(215)  |11111111|11111111|11110010               fffff2  [24]
(216)  |11111111|11111111|00100                  1fffe4  [21]
(217)  |11111111|11111111|00101                  1fffe5  [21]
(218)  |11111111|11111111|11111010|00           3ffffe8  [26]
(219)  |11111111|11111111|11111010|01           3ffffe9  [26]
(220)  |11111111|11111111|11111111|1101         ffffffd  [28]
(221)  |11111111|11111111|11111100|011          7ffffe3  [27]
(222)  |11111111|11111111|11111100|100          7ffffe4  [27]
(223)  |11111111|11111111|11111100|101          7ffffe5  [27]
(224)  |11111111|11111110|1100                    fffec  [20]
(225)  |11111111|11111111|11110011               fffff3  [24]
(226)  |11111111|11111110|1101                    fffed  [20]
(227)  |11111111|11111111|00110                  1fffe6  [21]
(228)  |11111111|11111111|101001                 3fffe9  [22]
(229)  |11111111|11111111|00111                  1fffe7  [21]
(230)  |11111111|11111111|01000                  1fffe8  [21]
(231)  |11111111|11111111|1110011                7ffff3  [23]
(232)  |11111111|11111111|101010                 3fffea  [22]
(233)  |11111111|11111111|101011                 3fffeb  [22]
(234)  |11111111|11111111|11110111|0            1ffffee  [25]
(235)  |11111111|11111111|11110111|1            1ffffef  [25]
(236)  |11111111|11111111|11110100               fffff4  [24]
(237)  |11111111|11111111|11110101               fffff5  [24]
(238)  |11111111|11111111|11111010|10           3ffffea  [26]
(239)  |11111111|11111111|1110100                7ffff4  [23]
(240)  |11111111|11111111|11111010|11           3ffffeb  [26]
(241)  |11111111|11111111|11111100|110          7ffffe6  [27]
(242)  |11111111|11111111|11111011|00           3ffffec  [26]
(243)  |11111111|11111111|11111011|01           3ffffed  [26]
(244)  |11111111|11111111|11111100|111          7ffffe7  [27]
(245)  |11111111|11111111|11111101|000          7ffffe8  [27]
(246)  |11111111|11111111|11111101|001          7ffffe9  [27]
(247)  |11111111|11111111|11111101|010          7ffffea  [27]
(248)  |11111111|11111111|11111101|011          7ffffeb  [27]
(249)  |11111111|11111111|11111111|1110         ffffffe  [28]
(250)  |11111111|11111111|11111101|100          7ffffec  [27]
(251)  |11111111|11111111|11111101|101          7ffffed  [27]
(252)  |11111111|11111111|11111101|110          7ffffee  [27]
(253)  |11111111|11111111|11111101|111          7ffffef  [27]
(254)  |11111111|11111111|11111110|000          7fffff0  [27]
(255)  |11111111|11111111|11111011|10           3ffffee  [26]
(256)  |11111111|11111111|11111111|111111      3fffffff  [30]

*)


