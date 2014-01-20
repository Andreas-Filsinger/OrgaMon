{**************************************************************************************}
{                                                                                      }
{ CCR Exif - Delphi class library for reading and writing Exif metadata in JPEG files  }
{ Version 0.9.9 (2009-11-19)                                                           }
{                                                                                      }
{ The contents of this file are subject to the Mozilla Public License Version 1.1      }
{ (the "License"); you may not use this file except in compliance with the License.    }
{ You may obtain a copy of the License at http://www.mozilla.org/MPL/                  }
{                                                                                      }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT   }
{ WARRANTY OF ANY KIND, either express or implied. See the License for the specific    }
{ language governing rights and limitations under the License.                         }
{                                                                                      }
{ The Original Code is CCR.Exif.StreamHelper.pas.                                      }
{                                                                                      }
{ The Initial Developer of the Original Code is Chris Rolliston. Portions created by   }
{ Chris Rolliston are Copyright (C) 2009 Chris Rolliston. All Rights Reserved.         }
{                                                                                      }
{**************************************************************************************}

unit CCR.Exif.StreamHelper;

interface

uses
  SysUtils, Classes;

type
  ECCRExifException = class(Exception);

  TEndianness = (SmallEndian, BigEndian);

  TStreamHelper = class helper for TStream
    function ReadByte: Byte;
    function ReadWord(Endianness: TEndianness; var Value: Word): Boolean; overload;
    function ReadWord(Endianness: TEndianness): Word; overload;
    function ReadLongInt(Endianness: TEndianness; var Value: LongInt): Boolean; overload;
    function ReadLongInt(Endianness: TEndianness): LongInt; overload;
    function ReadLongWord(Endianness: TEndianness; var Value: LongWord): Boolean; overload;
    function ReadLongWord(Endianness: TEndianness): LongWord; overload;
    function ReadDouble(Endianness: TEndianness): Double;
    procedure WriteByte(Value: Byte);
    procedure WriteWord(Value: Word; Endianness: TEndianness);
    procedure WriteLongInt(Value: LongInt; Endianness: TEndianness);
    procedure WriteLongWord(Value: LongWord; Endianness: TEndianness);
    procedure WriteDouble(Value: Double; Endianness: TEndianness);
  end;

  TUserMemoryStream = class(TCustomMemoryStream) //read-only stream access on an existing buffer;
  public
    constructor Create(Memory: Pointer; Size: Integer);
    function Write(const Buffer; Count: Integer): Integer; override;
  end;

function SwapLongInt(const Value: LongInt): LongInt;
function SwapLongWord(const Value: LongWord): LongWord;
function SwapSingle(const Value: Single): Single;
function SwapDouble(const Value: Double): Double;

implementation

uses RTLConsts, SysConst;

function SwapLongInt(const Value: LongInt): LongInt;
asm
  BSWAP EAX
end;

function SwapLongWord(const Value: LongWord): LongWord;
asm
  BSWAP EAX
end;

function SwapSingle(const Value: Single): Single;
asm
  BSWAP EAX
end;

function SwapDouble(const Value: Double): Double;
var
  I: Integer;
begin
  for I := SizeOf(Double) - 1 downto 0 do
    PByteArray(@Result)[I] := PByteArray(@Value)[SizeOf(Double) - 1 - I];
end;

{ TStreamHelper }

function TStreamHelper.ReadByte: Byte;
begin
  ReadBuffer(Result, 1);
end;

function TStreamHelper.ReadWord(Endianness: TEndianness; var Value: Word): Boolean;
begin
  Result := (Read(Value, 2) = 2);
  if Result and (Endianness = BigEndian) then
    Value := Swap(Value)
end;

function TStreamHelper.ReadWord(Endianness: TEndianness): Word;
begin
  if not ReadWord(Endianness, Result) then
    raise EReadError.CreateRes(@SReadError);
end;

function TStreamHelper.ReadDouble(Endianness: TEndianness): Double;
begin
  ReadBuffer(Result, 8);
  if Endianness = BigEndian then
    Result := SwapDouble(Result);
end;

function TStreamHelper.ReadLongInt(Endianness: TEndianness; var Value: LongInt): Boolean;
begin
  Result := (Read(Value, 4) = 4);
  if Result and (Endianness = BigEndian) then
    Value := SwapLongWord(Value);
end;

function TStreamHelper.ReadLongInt(Endianness: TEndianness): LongInt;
begin
  if not ReadLongInt(Endianness, Result) then
    raise EReadError.CreateRes(@SReadError);
end;

function TStreamHelper.ReadLongWord(Endianness: TEndianness;
  var Value: LongWord): Boolean;
begin
  Result := (Read(Value, 4) = 4);
  if Result and (Endianness = BigEndian) then
    Value := SwapLongWord(Value);
end;

function TStreamHelper.ReadLongWord(Endianness: TEndianness): LongWord;
begin
  if not ReadLongWord(Endianness, Result) then
    raise EReadError.CreateRes(@SReadError);
end;

procedure TStreamHelper.WriteByte(Value: Byte);
begin
  WriteBuffer(Value, 1);
end;

procedure TStreamHelper.WriteDouble(Value: Double; Endianness: TEndianness);
begin
  if Endianness = BigEndian then
    Value := SwapDouble(Value);
  WriteBuffer(Value, 8);
end;

procedure TStreamHelper.WriteWord(Value: Word; Endianness: TEndianness);
begin
  if Endianness = SmallEndian then
    WriteBuffer(Value, 2)
  else
  begin
    WriteBuffer(WordRec(Value).Hi, 1);
    WriteBuffer(WordRec(Value).Lo, 1);
  end;
end;

procedure TStreamHelper.WriteLongWord(Value: LongWord;
  Endianness: TEndianness);
begin
  if Endianness = BigEndian then
    Value := SwapLongWord(Value);
  WriteBuffer(Value, 4);
end;

procedure TStreamHelper.WriteLongInt(Value: LongInt;
  Endianness: TEndianness);
begin
  if Endianness = BigEndian then
    Value := SwapLongInt(Value);
  WriteBuffer(Value, 4);
end;

{ TUserMemoryStream }

constructor TUserMemoryStream.Create(Memory: Pointer; Size: Integer);
begin
  inherited Create;
  SetPointer(Memory, Size);
end;

function TUserMemoryStream.Write(const Buffer; Count: Integer): Integer;
begin
  Result := 0;
end;

end.
