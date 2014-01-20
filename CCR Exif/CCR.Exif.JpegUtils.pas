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
{ The Original Code is CCR.Exif.JpegUtils.pas.                                         }
{                                                                                      }
{ The Initial Developer of the Original Code is Chris Rolliston. Portions created by   }
{ Chris Rolliston are Copyright (C) 2009 Chris Rolliston. All Rights Reserved.         }
{                                                                                      }
{**************************************************************************************}

unit CCR.Exif.JpegUtils;

interface

uses
  Types, SysUtils, Classes, VCL.Imaging.JPEG, CCR.Exif.StreamHelper;

type
  EInvalidJPEGHeader = class(ECCRExifException);

  PJPEGSegmentHeader = ^TJPEGSegmentHeader;
  TJPEGSegmentHeader = packed record
  strict private
    function GetDataSize: Word;
    procedure SetDataSize(const Value: Word);
  public
    property DataSize: Word read GetDataSize write SetDataSize;
  public
    NewMarkerByte: Byte; //$FF
    MarkerNum: Byte;
    case Integer of
      0: (DataSizeHi, DataSizeLo: Byte;
          Data: record end);
      1: (DataSizeBigEndian: Word);
  end;

  PJPEGMarkerHeader = PJPEGSegmentHeader deprecated;
  TJPEGMarkerHeader = TJPEGSegmentHeader deprecated;

  TJFIFDensityUnits = (duNone, duPixelsPerInch, duPixelsPerCentimetre);

  TJFIFData = packed record
  strict private
    function GetHorzDensity: Word;
    procedure SetHorzDensity(const Value: Word);
    function GetVertDensity: Word;
    procedure SetVertDensity(const Value: Word);
  public
    property HorzDensity: Word read GetHorzDensity write SetHorzDensity;
    property VertDensity: Word read GetVertDensity write SetVertDensity;
  public
    Ident: array[0..4] of AnsiChar; //should be 'JFIF', including null terminator
    MajorVersion, MinorVersion: Byte;
    DensityUnits: TJFIFDensityUnits;
    case Integer of
      0: (HorzDensityHi, HorzDensityLo: Byte;
          VertDensityHi, VertDensityLo: Byte;
          ThumbnailWidth, ThumbnailHeight: Byte;
          ThumbnailPixels: record end);
      1: (HorzDensityBigEndian: Word;
          VertDensityBigEndian: Word);
  end;

  PJPEGStartOfFrameData = ^TJPEGStartOfFrameData;
  TJPEGStartOfFrameData = packed record
  strict private
    function GetImageWidth: Word;
    function GetImageHeight: Word;
    procedure SetImageHeight(const Value: Word);
    procedure SetImageWidth(const Value: Word);
  public
    property ImageWidth: Word read GetImageWidth write SetImageWidth;
    property ImageHeight: Word read GetImageHeight write SetImageHeight;
  public
    SamplePrecision: Byte; //8
    ImageHeightHi, ImageHeightLo: Byte;
    ImageWidthHi, ImageWidthLo: Byte;
    ComponentCount: Byte; //1 = gray scaled, 3 = color YCbCr or YIQ, 4 = color CMYK
    ComponentData: record end;
  end;

  TJPEGMarker = Byte;
  TJPEGMarkers = set of TJPEGMarker;

  IJPEGSegment = interface
  ['{CF516230-D958-4C50-8C05-5AD985C6CBDD}']
    function GetData: TCustomMemoryStream;
    function GetMarkerNum: TJPEGMarker;

    property Data: TCustomMemoryStream read GetData;
    property MarkerNum: TJPEGMarker read GetMarkerNum;
  end;

  TUserJPEGSegment = class(TInterfacedObject, IJPEGSegment)
  strict private
    FData: TMemoryStream;
    FMarkerNum: TJPEGMarker;
  protected
    function GetData: TCustomMemoryStream;
    function GetMarkerNum: TJPEGMarker;
  public
    constructor Create(AMarkerNum: TJPEGMarker = 0; const ASource: IStreamPersist = nil);
    destructor Destroy; override;
    property Data: TMemoryStream read FData;
    property MarkerNum: TJPEGMarker read FMarkerNum write FMarkerNum;
  end;

  IFoundJPEGSegment = interface(IJPEGSegment)
  ['{138192CD-85DD-4CEB-B1A7-4678C7D67C88}']
    function GetOffset: Int64;
    function GetOffsetOfData: Int64;
    function GetTotalSize: Word;
    function PosOfDataInJpeg: Int64; deprecated; //use OffsetOfData

    property Offset: Int64 read GetOffset;
    property OffsetOfData: Int64 read GetOffsetOfData;
    property TotalSize: Word read GetTotalSize;
  end;

  IJPEGHeaderParser = interface
    function GetCurrent: IFoundJPEGSegment;
    function GetEnumerator: IJPEGHeaderParser;
    function MoveNext: Boolean;
    property Current: IFoundJPEGSegment read GetCurrent;
  end;

  TWhatToDoWithStreamAtEnd = TStreamOwnership deprecated;

const
  wsLeaveStreamAsIs = soReference deprecated;
  wsAutoFreeStream = soOwned deprecated;

type
  TParseJPEGHeaderCallback = procedure (MarkerNum: TJPEGMarker;
    const PosOfDataInJpeg: Int64; Data: TMemoryStream;
    var ContinueParsing: Boolean) of object;

const
  JPEGSegmentHeaderSize = 4;

  AllJPEGMarkers = [Low(TJPEGMarker)..High(TJPEGMarker)];
  AnyJPEGMarker = AllJPEGMarkers;

  jmNewOrPadding       = TJPEGMarker($FF);
  jmStartOfImage       = TJPEGMarker($D8);
  jmEndOfImage         = TJPEGMarker($D9);
  jmQuantizationTable  = TJPEGMarker($DB);
  jmStartOfFrame0      = TJPEGMarker($C0);
  jmStartOfFrame1      = TJPEGMarker($C1);
  jmStartOfFrame2      = TJPEGMarker($C2);
  jmStartOfFrame3      = TJPEGMarker($C3);
  jmStartOfFrame5      = TJPEGMarker($C5);
  jmStartOfFrame6      = TJPEGMarker($C6);
  jmStartOfFrame7      = TJPEGMarker($C7);
  jmJpegExtension      = TJPEGMarker($C8);
  jmHuffmanTable       = TJPEGMarker($C4);
  jmRestartInternal    = TJPEGMarker($DD);
  jmComment            = TJPEGMarker($FE);
  jmAppSpecificFirst   = TJPEGMarker($E0);
  jmAppSpecificLast    = TJPEGMarker($EF);
  jmJFIF               = TJPEGMarker($E0);
  jmApp1               = TJPEGMarker($E1);
  jmStartOfScan        = TJPEGMarker($DA);

  jmExif = jmApp1 deprecated;

  JpegFileHeader: Word = jmNewOrPadding or jmStartOfImage shl 8;
  StartOfFrameMarkers  = [jmStartOfFrame0..jmStartOfFrame3,
    jmStartOfFrame5..jmStartOfFrame7]; //there's no jmStartOfFrame4
  MarkersWithNoData = [$01, $D0..$D9];
{
var
  Segment: IFoundJPEGSegment;
begin
  for Segment in JPEGHeader(JPEGStream) do
    ...
  for Segment in JPEGHeader('myimage.jpg') do
    ...
  for Segment in JPEGHeader(JPEGImage) do
    ...
}
function JPEGHeader(JPEGStream: TStream; const MarkersToLookFor: TJPEGMarkers;
  StreamOwnership: TStreamOwnership = soReference): IJPEGHeaderParser; overload;
function JPEGHeader(const JPEGFile: string;
  const MarkersToLookFor: TJPEGMarkers = AnyJPEGMarker): IJPEGHeaderParser; overload; inline;
function JPEGHeader(Image: TJPEGImage;
  const MarkersToLookFor: TJPEGMarkers = AnyJPEGMarker): IJPEGHeaderParser; overload;

function GetJpegDataSize(Data: TStream): Int64; overload;
function GetJpegDataSize(Jpeg: TJPEGImage): Int64; overload;

procedure WriteJPEGHeaderToStream(Stream: TStream); inline;
procedure WriteJPEGSegmentToStream(Stream: TStream; MarkerNum: TJPEGMarker;
  const Data; DataSize: Word); overload;
procedure WriteJPEGSegmentToStream(Stream: TStream; MarkerNum: TJPEGMarker;
  Data: TStream; DataSize: Word = 0); overload;
procedure WriteJPEGSegmentToStream(Stream: TStream; Segment: IJPEGSegment); overload;

implementation

uses CCR.Exif.Consts;

type
  TFoundJPEGSegment = class(TUserJPEGSegment, IFoundJPEGSegment)
  strict private
    FOffset: Int64;
  protected
    function GetOffset: Int64;
    function GetOffsetOfData: Int64;
    function GetTotalSize: Word;
    function PosOfDataInJpeg: Int64;
  public
    constructor Create(AMakerNum: TJPEGMarker; ASource: TStream; ADataSize: Integer); overload;
  end;

  TJPEGHeaderParser = class(TInterfacedObject, IJPEGHeaderParser)
  strict private
    FCurrent: IFoundJPEGSegment;
    FLastMarker: TJPEGMarker;
    FMarkersToLookFor: TJPEGMarkers;
    FSavedPos, FStartPos: Int64;
    FStream: TStream;
    FStreamOwnership: TStreamOwnership;
  protected
    function GetEnumerator: IJPEGHeaderParser;
    function GetCurrent: IFoundJPEGSegment;
    function MoveNext: Boolean;
  public
    constructor Create(JPEGStream: TStream; const MarkersToLookFor: TJPEGMarkers;
      StreamOwnership: TStreamOwnership);
    destructor Destroy; override;
  end;

{ TJPEGSegmentHeader }

function TJPEGSegmentHeader.GetDataSize: Word;
begin
  Result := DataSizeLo or (DataSizeHi shl 8);
end;

procedure TJPEGSegmentHeader.SetDataSize(const Value: Word);
begin
  with WordRec(Value) do
  begin
    DataSizeHi := Hi;
    DataSizeLo := Lo;
  end;
end;

{ TJFIFData }

function TJFIFData.GetHorzDensity: Word;
begin
  Result := HorzDensityLo or (HorzDensityHi shl 8);
end;

function TJFIFData.GetVertDensity: Word;
begin
  Result := VertDensityLo or (VertDensityHi shl 8);
end;

procedure TJFIFData.SetHorzDensity(const Value: Word);
begin
  with WordRec(Value) do
  begin
    HorzDensityHi := Hi;
    HorzDensityLo := Lo;
  end;
end;

procedure TJFIFData.SetVertDensity(const Value: Word);
begin
  with WordRec(Value) do
  begin
    VertDensityHi := Hi;
    VertDensityLo := Lo;
  end;
end;

{ TJPEGStartOfFrameData }

function TJPEGStartOfFrameData.GetImageWidth: Word;
begin
  Result := ImageWidthLo or (ImageWidthHi shl 8);
end;

function TJPEGStartOfFrameData.GetImageHeight: Word;
begin
  Result := ImageHeightLo or (ImageHeightHi shl 8);
end;

procedure TJPEGStartOfFrameData.SetImageHeight(const Value: Word);
begin
  with WordRec(Value) do
  begin
    ImageHeightHi := Hi;
    ImageHeightLo := Lo;
  end;
end;

procedure TJPEGStartOfFrameData.SetImageWidth(const Value: Word);
begin
  with WordRec(Value) do
  begin
    ImageWidthHi := Hi;
    ImageWidthLo := Lo;
  end;
end;

{ TUserJPEGSegment }

constructor TUserJPEGSegment.Create(AMarkerNum: TJPEGMarker = 0;
  const ASource: IStreamPersist = nil);
begin
  FData := TMemoryStream.Create;
  FMarkerNum := AMarkerNum;
  if ASource <> nil then
  begin
    ASource.SaveToStream(FData);
    FData.Position := 0;
  end;
end;

destructor TUserJPEGSegment.Destroy;
begin
  FData.Free;
  inherited;
end;

function TUserJPEGSegment.GetData: TCustomMemoryStream;
begin
  Result := FData;
end;

function TUserJPEGSegment.GetMarkerNum: TJPEGMarker;
begin
  Result := FMarkerNum;
end;

{ TFoundJPEGSegment }

constructor TFoundJPEGSegment.Create(AMakerNum: TJPEGMarker; ASource: TStream;
  ADataSize: Integer);
begin
  inherited Create(AMakerNum);
  FOffset := ASource.Position - SizeOf(TJPEGSegmentHeader);
  if AMakerNum in MarkersWithNoData then
    Inc(FOffset, 2)
  else if ADataSize > 0 then
  begin
    Data.Size := ADataSize;
    ASource.ReadBuffer(Data.Memory^, ADataSize);
  end;
end;

function TFoundJPEGSegment.GetOffset: Int64;
begin
  Result := FOffset;
end;

function TFoundJPEGSegment.GetOffsetOfData: Int64;
begin
  Result := FOffset + SizeOf(TJPEGSegmentHeader);
end;

function TFoundJPEGSegment.GetTotalSize: Word;
begin
  Result := Data.Size + SizeOf(TJPEGSegmentHeader);
  if MarkerNum in MarkersWithNoData then Dec(Result, 2);
end;

function TFoundJPEGSegment.PosOfDataInJpeg: Int64;
begin
  Result := GetOffsetOfData;
end;

{ TJPEGHeaderParser }

constructor TJPEGHeaderParser.Create(JPEGStream: TStream;
  const MarkersToLookFor: TJPEGMarkers; StreamOwnership: TStreamOwnership);
begin
  inherited Create;
  FMarkersToLookFor := MarkersToLookFor;
  FStartPos := JPEGStream.Position;
  FStream := JPEGStream;
  FStreamOwnership := StreamOwnership;
  if JPEGStream.ReadWord(SmallEndian) <> JpegFileHeader then
    raise EInvalidJPEGHeader.Create(SInvalidJPEGHeader);
  FSavedPos := FStartPos + 2;
end;

destructor TJPEGHeaderParser.Destroy;
begin
  if FStreamOwnership = soOwned then //If loop didn't complete, MoveNext
    FreeAndNil(FStream);             //wouldn't have had the chance to
  inherited;                         //free the stream.
end;

function TJPEGHeaderParser.GetCurrent: IFoundJPEGSegment;
begin
  Result := FCurrent;
end;

function TJPEGHeaderParser.GetEnumerator: IJPEGHeaderParser;
begin
  Result := Self;
end;

function TJPEGHeaderParser.MoveNext: Boolean;
var
  AllocatedBuffer: Boolean;
  Buffer: PAnsiChar;
  BufferSize: Integer;
  DataSize: Word;
  MaxPos, SeekPtr: PAnsiChar;
begin
  Result := False;
  if (FStream = nil) or (FLastMarker = jmEndOfImage) then Exit;
  FCurrent := nil;
  FStream.Position := FSavedPos;
  while FStream.ReadByte = jmNewOrPadding do
  begin
    repeat
      FLastMarker := FStream.ReadByte;
    until (FLastMarker <> jmNewOrPadding); //extra $FF bytes are legal as padding
    if FLastMarker in MarkersWithNoData then
      DataSize := 0
    else
      DataSize := FStream.ReadWord(BigEndian) - 2;
    if not (FLastMarker in FMarkersToLookFor) then
      if FLastMarker = jmEndOfImage then
        Break
      else
        FStream.Seek(DataSize, soCurrent)
    else
    begin
      FCurrent := TFoundJPEGSegment.Create(FLastMarker, FStream, DataSize);
      FSavedPos := FStream.Position;
      Result := True;
      Exit;
    end;
  end;
  if (FLastMarker = jmStartOfScan) and (jmEndOfImage in FMarkersToLookFor) then
  begin
    FSavedPos := FStream.Position;
    BufferSize := FStream.Size - FSavedPos;
    AllocatedBuffer := not (FStream is TCustomMemoryStream);
    if AllocatedBuffer then
      GetMem(Buffer, BufferSize)
    else
    begin
      Buffer := TCustomMemoryStream(FStream).Memory;
      Inc(Buffer, FSavedPos);
    end;
    try
      if AllocatedBuffer then FStream.ReadBuffer(Buffer^, BufferSize);
      MaxPos := @Buffer[BufferSize - 1];
      SeekPtr := Buffer;
      while SeekPtr < MaxPos do
      begin
        Inc(SeekPtr);
        if Byte(SeekPtr^) <> jmNewOrPadding then Continue;
        Inc(SeekPtr);
        if Byte(SeekPtr^) <> jmEndOfImage then Continue;
        Inc(SeekPtr);
        FStream.Position := FSavedPos + (SeekPtr - Buffer);
        FCurrent := TFoundJPEGSegment.Create(jmEndOfImage, FStream, 0);
        FLastMarker := jmEndOfImage;
        Result := True;
        Exit;
      end;
    finally
      if AllocatedBuffer then FreeMem(Buffer);
    end;
    FStream.Seek(0, soEnd);
  end;
  if FStreamOwnership = soOwned then
    FreeAndNil(FStream);
end;

function JPEGHeader(JPEGStream: TStream; const MarkersToLookFor: TJPEGMarkers;
  StreamOwnership: TStreamOwnership = soReference): IJPEGHeaderParser; overload;
begin
  Result := TJPEGHeaderParser.Create(JPEGStream, MarkersToLookFor, StreamOwnership);
end;

function JPEGHeader(const JPEGFile: string;
  const MarkersToLookFor: TJPEGMarkers): IJPEGHeaderParser;
begin
  Result := JPEGHeader(TFileStream.Create(JPEGFile, fmOpenRead), MarkersToLookFor,
    soOwned);
end;

function JPEGHeader(Image: TJPEGImage;
  const MarkersToLookFor: TJPEGMarkers): IJPEGHeaderParser;
var
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  Image.SaveToStream(Stream);
  Result := JPEGHeader(Stream, MarkersToLookFor, soOwned);
end;

function GetJpegDataSize(Data: TStream): Int64; overload;
var
  OrigPos: Int64;
  Segment: IFoundJPEGSegment;
begin
  OrigPos := Data.Position;
  Result := Data.Size - OrigPos;
  for Segment in JPEGHeader(Data, [jmEndOfImage]) do
    Result := Data.Position - OrigPos;
  Data.Position := OrigPos;
end;

function GetJpegDataSize(Jpeg: TJPEGImage): Int64; overload;
var
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    Jpeg.SaveToStream(Stream); //TJpegImage.LoadFromStream keeps everything from the starting pos
    Stream.Position := 0;
    Result := GetJpegDataSize(Stream);
  finally
    Stream.Free;
  end;
end;

procedure WriteJPEGHeaderToStream(Stream: TStream); inline;
begin
  Stream.WriteBuffer(JpegFileHeader, SizeOf(JpegFileHeader));
end;

procedure WriteJPEGSegmentToStream(Stream: TStream; MarkerNum: TJPEGMarker;
  const Data; DataSize: Word); overload;
var
  Header: TJPEGSegmentHeader;
begin
  Header.NewMarkerByte := jmNewOrPadding;
  Header.MarkerNum := MarkerNum;
  Inc(DataSize, 2);
  Header.DataSizeHi := Hi(DataSize);
  Header.DataSizeLo := Lo(DataSize);
  Dec(DataSize, 2);
  Stream.WriteBuffer(Header, SizeOf(Header));
  if (DataSize > 0) and (@Data <> nil) then Stream.WriteBuffer(Data, DataSize);
end;

procedure WriteJPEGSegmentToStream(Stream: TStream; MarkerNum: TJPEGMarker;
  Data: TStream; DataSize: Word); overload;
var
  Buffer: Pointer;
  BufferAllocated: Boolean;
begin
  if DataSize = 0 then
  begin
    Data.Position := 0;
    DataSize := Word(Data.Size);
    if DataSize = 0 then
    begin
      WriteJPEGSegmentToStream(Stream, MarkerNum, MarkerNum, 0);
      Exit;
    end;
  end;
  BufferAllocated := not (Data is TCustomMemoryStream);
  if BufferAllocated then
    GetMem(Buffer, DataSize)
  else
  begin
    Buffer := @PByteArray(TCustomMemoryStream(Data).Memory)[Data.Position];
    Data.Seek(DataSize, soCurrent);
  end;
  try
    if BufferAllocated then Data.ReadBuffer(Buffer^, DataSize);
    WriteJPEGSegmentToStream(Stream, MarkerNum, Buffer^, DataSize);
  finally
    if BufferAllocated then FreeMem(Buffer);
  end;
end;

procedure WriteJPEGSegmentToStream(Stream: TStream; Segment: IJPEGSegment); overload;
begin
  WriteJPEGSegmentToStream(Stream, Segment.MarkerNum, Segment.Data);
end;

end.
