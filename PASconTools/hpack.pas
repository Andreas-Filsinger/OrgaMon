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
    function getWire : RawByteString;
    procedure setWire(wire: RawByteString);
   public
     property Wire : read getWrite write setWire;
     property HEADER_TABLE_SIZE : read get TableSize write setTableSize(integer);
     procedure Clear;
     procedure Save(Stream:TStream);
 end;

implementation

end.

