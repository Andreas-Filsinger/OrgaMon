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
{ The Original Code is CCR.Exif.pas.                                                   }
{                                                                                      }
{ The Initial Developer of the Original Code is Chris Rolliston. Portions created by   }
{ Chris Rolliston are Copyright (C) 2009 Chris Rolliston. All Rights Reserved.         }
{                                                                                      }
{**************************************************************************************}

unit CCR.Exif;
{
  To do:
  - MakerNote rewriting in TExifData. Perhaps remove MakerNotePosition to make this
    easier.

  Notes:
  - In Exif-jargon, we have 'tags' and 'IFDs' (including 'sub-IFDs'). In the jargon of
    this unit, we have 'tags' and 'sections'.
  - The idea is that, in general, you should only need to explicitly add CCR.Exif to
    your uses clause, CCR.Exif.XMPUtils etc. only being needed for lower-level work. The
    sub-units (so to speak) are still used by CCR.Exif.pas (i.e., this file) itself
    though.
  - You enumerate the tags of a section with the for-in syntax. No traditional indexing
    is provided so as to avoid confusing tag IDs with tag indices.
  - The enumerator implementation for TExifSection allows calling Delete on a tag while
    you are enumerating the container section.
  - When tags are loaded from a JPEG, any associated XMP packet is loaded too (more
    exactly, the XMP segment is loaded immediately, then parsed when required). When
    setting a tag property, the default behaviour is for the loaded XMP packet
    to be updated if the equivalent XMP tag already exists.
}
interface

{$IF CompilerVersion >= 18.5}
{$DEFINE CANINLINE} //inline directive on record methods is unstable pre-D2007
{$IFEND}

uses
  Types, SysUtils, Classes, VCL.Graphics, Contnrs, VCL.Imaging.JPEG,
  CCR.Exif.JpegUtils, CCR.Exif.StreamHelper, CCR.Exif.TagIDs, CCR.Exif.XMPUtils;

const
  SmallEndian = CCR.Exif.StreamHelper.SmallEndian;
  BigEndian = CCR.Exif.StreamHelper.BigEndian;

  xwAlwaysUpdate = CCR.Exif.XMPUtils.xwAlwaysUpdate;
  xwUpdateIfExists = CCR.Exif.XMPUtils.xwUpdateIfExists;
  xwRemove = CCR.Exif.XMPUtils.xwRemove;

type
  {$IF not Declared(TBytes)}
  TBytes = array of Byte;           //added in D2007
  {$IFEND}
  {$IF not Declared(RawByteString)}
  RawByteString = AnsiString;       //added in D2009
  {$IFEND}
  {$IF not Declared(UnicodeString)}
  UnicodeString = type WideString;  //added in D2009
  {$IFEND}

  ECCRExifException = CCR.Exif.StreamHelper.ECCRExifException; //= class(Exception);
  EInvalidJPEGHeader = CCR.Exif.JPEGUtils.EInvalidJPEGHeader; //= class(ECCRExifException);
  EInvalidTiffData = class(ECCRExifException);

  TEndianness = CCR.Exif.StreamHelper.TEndianness;

  TTiffTagID = type Word;
{$Z2}
  TTiffDataType = (tdByte = 1, tdAscii, tdWord, tdLongWord, tdLongWordFraction,
    tdShortInt, tdUndefined, tdSmallInt, tdLongInt, tdLongIntFraction, tdSingle,
    tdDouble, tdSubDirectory);
{$Z1}
  TTiffDataTypes = set of TTiffDataType;

  TTiffTagInfo = record //note that this structure does not exactly map onto the 'real' one
    HeaderOffset, DataOffset: Int64;
    ID: TTiffTagID;
    DataType: TTiffDataType;
    ElementCount: LongInt;
    function DataSize: Integer;
    function IsWellFormed: Boolean; {$IFDEF CANINLINE}inline;{$ENDIF}
  end;

  TTiffDirectoryLoadError = (leBadOffset, leBadTagCount, leBadTagHeader);
  TTiffDirectoryLoadErrors = set of TTiffDirectoryLoadError;

  TTiffDirectory = record
    Tags: array of TTiffTagInfo;
    LoadErrors: TTiffDirectoryLoadErrors;
  end;

  TTiffInfo = record
    Stream: TStream;
    BasePosition: Int64;
    Endianness: TEndianness;
    Directories: array of TTiffDirectory;
  end;

  TiffString = type AnsiString;

  TTiffLongWordFraction = packed record
    constructor Create(ANumerator: LongWord; ADenominator: LongWord = 1);
    constructor CreateFromString(const AString: string);
    function AsString: string;
    function MissingOrInvalid: Boolean; {$IFDEF CANINLINE}inline;{$ENDIF}
    function Quotient: Extended; {$IFDEF CANINLINE}inline;{$ENDIF}
    case Integer of
      0: (Numerator, Denominator: LongWord);
      1: (PackedValue: Int64);
  end;

  TTiffLongIntFraction = packed record
    constructor Create(ANumerator: LongWord; ADenominator: LongInt = 1);
    constructor CreateFromString(const AString: string);
    function AsString: string;
    function MissingOrInvalid: Boolean; {$IFDEF CANINLINE}inline;{$ENDIF}
    function Quotient: Extended; {$IFDEF CANINLINE}inline;{$ENDIF}
    case Integer of
      0: (Numerator, Denominator: LongInt);
      1: (PackedValue: Int64);
  end;

const
  TiffElementSizes: array[TTiffDataType] of Integer = (
    1, 1, 2, 4, 8, 1, 1, 2, 4, 8, 4, 8, 4);

  TiffSmallEndianCode = Word($4949);
  TiffBigEndianCode = Word($4D4D);
  TiffMagicNum: Word = $002A;

procedure LoadTiffInfo(Stream: TStream; var Info: TTiffInfo);
function LoadTiffDirectory(const Info: TTiffInfo; const Offset: Int64;
  const InternalOffset: Int64 = 0): TTiffDirectory;
procedure LoadTiffTagData(const Info: TTiffInfo; const Tag: TTiffTagInfo; var Buffer); overload;
function LoadTiffTagData(const Info: TTiffInfo; const Tag: TTiffTagInfo): TBytes; overload;

function TryStrToTiffFraction(const S: string; out Fraction: TTiffLongWordFraction): Boolean; deprecated; //use CreateFromString and test for MissingOrInvalid
function StrToTiffFraction(const S: string): TTiffLongWordFraction; deprecated; //use CreateFromString
function TiffFractionToStr(const Fraction: TTiffLongWordFraction): string; deprecated; //use Fraction.AsString

{ Exif-specific types, constants and routines }

const
  tdExifFraction = tdLongWordFraction;
  tdExifSignedFraction = tdLongIntFraction;

  StandardExifThumbnailWidth   = 160;
  StandardExifThumbnailHeight  = 120;

type
  ENotOnlyASCIIError = class(EInvalidTiffData);

  TExifTag = class;
  TExifSection = class;
  TExtendableExifSection = class;
  TCustomExifData = class;
  TExifData = class;

  TExifTagID = TTiffTagID;
  TExifDataType = TTiffDataType;
  TExifDataTypes = TTiffDataTypes;

  PExifFraction = ^TExifFraction;
  TExifFraction = TTiffLongWordFraction;
  TExifSignedFraction = TTiffLongIntFraction;
{$Z2}
  TWindowsStarRating = (urUndefined, urOneStar, urTwoStars, urThreeStars,
    urFourStars, urFiveStars);
{$Z1}
  TExifTagChangeType = (tcData, tcDataSize, tcID);
  TExifPaddingTagSize = 2..High(LongInt);

  TExifTag = class
  strict private
    FAsStringCache: string;
    FData: Pointer;
    FDataType: TExifDataType;
    FElementCount: LongInt;
    FID: TExifTagID;
    FOriginalDataOffset: Int64;
    FOriginalDataSize: Integer;
    FWellFormed: Boolean;
    function GetAsBytes: TBytes;
    procedure SetAsBytes(const Value: TBytes);
    function GetAsString: string;
    procedure SetAsString(const Value: string);
    function GetDataSize: Integer; inline;
    procedure SetDataType(const NewDataType: TExifDataType);
    function GetElementAsString(Index: Integer): string;
    procedure SetElementCount(const NewCount: LongInt);
    procedure SetID(const Value: TExifTagID);
  protected
    FSection: TExifSection;
    procedure Changing(NewID: TExifTagID; NewDataType: TExifDataType;
      NewElementCount: LongInt; NewData: Boolean);
    procedure Changed(ChangeType: TExifTagChangeType); overload;
    procedure WriteHeader(Stream: TStream; Endianness: TEndianness; DataOffset: LongInt);
    procedure WriteOffsettedData(Stream: TStream; Endianness: TEndianness);
    constructor Create(const Section: TExifSection; const Info: TTiffInfo;
      const TagRec: TTiffTagInfo); overload;
  public
    constructor Create(const Section: TExifSection; const ID: TExifTagID;
      DataType: TExifDataType; ElementCount: LongInt); overload;
    destructor Destroy; override;
    procedure Assign(Source: TExifTag);
    procedure Changed; overload; //call this if Data is modified directly
    procedure Delete;
    function HasWindowsStringData: Boolean;
    function IsPadding: Boolean;
    procedure SetAsPadding(Size: TExifPaddingTagSize);
    procedure UpdateData(NewDataType: TExifDataType; NewElementCount: LongInt;
      const NewData); overload;
    procedure UpdateData(const NewData); overload;
    function ReadFraction(Index: Integer; const Default: TExifFraction): TExifFraction;
    function ReadLongWord(Index: Integer; const Default: LongWord): LongWord;
    function ReadWord(Index: Integer; const Default: Word): Word;
    property AsBytes: TBytes read GetAsBytes write SetAsBytes;
    property AsString: string read GetAsString write SetAsString;
    property ElementAsString[Index: Integer]: string read GetElementAsString;
    property Data: Pointer read FData;
    property DataSize: Integer read GetDataSize;
    property DataType: TExifDataType read FDataType write SetDataType; //this needs to be loaded before AsString
    property ElementCount: LongInt read FElementCount write SetElementCount;
    property ID: TExifTagID read FID write SetID;
    property OriginalDataOffset: Int64 read FOriginalDataOffset;
    property OriginalDataSize: Integer read FOriginalDataSize;
    property Section: TExifSection read FSection;
    property WellFormed: Boolean read FWellFormed;
  end;

  ETagAlreadyExists = class(EInvalidTiffData);

  TExifSectionLoadErrors = TTiffDirectoryLoadErrors;

  TExifSectionKindEx = (esUserDefined, esGeneral, esDetails, esInterop, esGPS,
    esThumbnail, esMakerNote);
  TExifSectionKind = esGeneral..esMakerNote;

  TExifSection = class
  public type
    TEnumerator = record
    private
      FCurrent: TExifTag;
      FIndex: Integer;
      FTags: TList;
      constructor Create(ATagList: TList);
    public
      function MoveNext: Boolean;
      property Current: TExifTag read FCurrent;
    end;
  strict private class var
    LastSetDateTimeValue: TDateTime;
    LastSetDateTimeMainStr, LastSetDateTimeSubSecStr: string;
  strict private
    FFirstTagHeaderOffset: Int64;
    FKind: TExifSectionKindEx;
    FLoadErrors: TExifSectionLoadErrors;
    FModified: Boolean;
    FOwner: TCustomExifData;
    FTagList: TList;
    function GetTagCount: Integer;
    procedure DoSetFractionValue(TagID: TExifTagID; Index: Integer;
      DataType: TExifDataType; const Value);
  protected
    constructor Create(AOwner: TCustomExifData; AKind: TExifSectionKindEx);
    function Add(ID: TExifTagID; DataType: TExifDataType; ElementCount: LongInt): TExifTag;
    procedure Changed;
    function CheckExtendable: TExtendableExifSection;
    procedure DoDelete(TagIndex: Integer; FreeTag: Boolean);
    function EnforceASCII: Boolean;
    function FindIndex(ID: TExifTagID; var TagIndex: Integer): Boolean;
    function ForceSetElement(ID: TExifTagID; DataType: TExifDataType;
      Index: Integer; const Value): TExifTag;
    procedure Load(const Info: TTiffInfo; const Directory: TTiffDirectory); overload;
    procedure Load(const Info: TTiffInfo; const Offset: Int64;
      const InternalOffset: Int64 = 0); overload;
    procedure TagChanging(Tag: TExifTag; NewID: TExifTagID;
      NewDataType: TExifDataType; NewElementCount: LongInt; NewData: Boolean);
    procedure TagChanged(Tag: TExifTag; ChangeType: TExifTagChangeType);
    procedure TagDeleting(Tag: TExifTag);
    property FirstTagHeaderOffset: Int64 read FFirstTagHeaderOffset;
  public
    destructor Destroy; override;
    function GetEnumerator: TEnumerator;
    procedure Clear;
    function Find(ID: TExifTagID; out Tag: TExifTag): Boolean;
    function GetByteValue(TagID: TExifTagID; Index: Integer; Default: Byte;
      MinValue: Byte = 0; MaxValue: Byte = High(Byte)): Byte;
    function GetDateTimeValue(MainID, SubSecsID: TExifTagID; const Default: TDateTime = 0): TDateTime;
    function GetFractionValue(TagID: TExifTagID; Index: Integer): TExifFraction; overload;
    function GetFractionValue(TagID: TExifTagID; Index: Integer;
      const Default: TExifFraction): TExifFraction; overload;
    function GetLongIntValue(TagID: TExifTagID; Index: Integer; Default: LongInt): LongInt;
    function GetLongWordValue(TagID: TExifTagID; Index: Integer; Default: LongWord): LongWord;
    function GetSmallIntValue(TagID: TExifTagID; Index: Integer; Default: SmallInt;
      MinValue: SmallInt = Low(SmallInt); MaxValue: SmallInt = High(SmallInt)): SmallInt;
    function GetStringValue(TagID: TExifTagID; const Default: string = ''): string;
    function GetWindowsStringValue(TagID: TExifTagID; const Default: UnicodeString = ''): UnicodeString;
    function GetWordValue(TagID: TExifTagID; Index: Integer; Default: Word;
      MinValue: Word = 0; MaxValue: Word = High(Word)): Word;
    function IsExtendable: Boolean; inline;
    function Remove(ID: TExifTagID): Boolean; overload; //returns True if contained a tag with the specified ID
    procedure Remove(const IDs: array of TExifTagID); overload;
    function RemovePaddingTag: Boolean; //returns True if contained a padding tag
    function SetByteValue(TagID: TExifTagID; Index: Integer; Value: Byte): TExifTag;
    procedure SetDateTimeValue(MainID, SubSecsID: TExifTagID; const Value: TDateTime);
    procedure SetFractionValue(TagID: TExifTagID; Index: Integer; const Value: TExifFraction);
    function SetLongWordValue(TagID: TExifTagID; Index: Integer; Value: LongWord): TExifTag;
    procedure SetSignedFractionValue(TagID: TExifTagID; Index: Integer;
      const Value: TExifSignedFraction);
    procedure SetStringValue(TagID: TExifTagID; const Value: string);
    procedure SetWindowsStringValue(TagID: TExifTagID; const Value: UnicodeString);
    function SetWordValue(TagID: TExifTagID; Index: Integer; Value: Word): TExifTag;
    function TagExists(ID: TExifTagID; ValidDataTypes: TExifDataTypes =
      [Low(TExifDataType)..High(TExifDataType)]; MinElementCount: LongInt = 1): Boolean;
    function TryGetByteValue(TagID: TExifTagID; Index: Integer; var Value): Boolean;
    function TryGetLongWordValue(TagID: TExifTagID; Index: Integer; var Value): Boolean;
    function TryGetWordValue(TagID: TExifTagID; Index: Integer; var Value): Boolean;
    function TryGetStringValue(TagID: TExifTagID; var Value: string): Boolean;
    function TryGetWindowsStringValue(TagID: TExifTagID; var Value: UnicodeString): Boolean;
    property Count: Integer read GetTagCount;
    property Kind: TExifSectionKindEx read FKind;
    property LoadErrors: TExifSectionLoadErrors read FLoadErrors write FLoadErrors;
    property Modified: Boolean read FModified write FModified;
    property Owner: TCustomExifData read FOwner;
  end;

  TExifSectionClass = class of TExifSection;

  TExtendableExifSection = class(TExifSection)
  public
    function Add(ID: TExifTagID; DataType: TExifDataType;
      ElementCount: LongInt = 1): TExifTag;
    function AddOrUpdate(ID: TExifTagID; DataType: TExifDataType;
      ElementCount: LongInt): TExifTag; overload;
    function AddOrUpdate(ID: TExifTagID; DataType: TExifDataType;
      ElementCount: LongInt; const Data): TExifTag; overload;
    procedure Assign(Source: TExifSection);
    procedure CopyTags(Section: TExifSection);
  end;

  EInvalidMakerNoteFormat = class(EInvalidTiffData);

  TExifMakerNoteSection = class(TExifSection)
  protected
    procedure GetIFDInfo(SourceTag: TExifTag; var TiffStartFromTagDataStart: Int64;
      var Endianness: TEndianness; var IFDFromTagDataStart: Integer); virtual;
  public
    constructor Create(ASource: TCustomExifData); reintroduce;
    class function FormatIsOK(Source: TCustomExifData;
      AlwaysCheckMakerName: Boolean = True): Boolean; overload;
    class function FormatIsOK(MakerNoteTag: TExifTag;
      AlwaysCheckMakerName: Boolean): Boolean; overload; virtual; abstract;
  end deprecated;

  TExifFlashMode = (efUnknown, efCompulsoryFire, efCompulsorySuppression, efAuto);
  TExifStrobeLight = (esNoDetectionFunction, esUndetected, esDetected);

  TWordBitEnum = 0..SizeOf(Word) * 8 - 1;
  TWordBitSet = set of TWordBitEnum;

  TExifFlashInfo = class(TPersistent)
  strict private const
    FiredBit = 0;
    NotPresentBit = 5;
    RedEyeReductionBit = 6;
  strict private
    FOwner: TCustomExifData;
    function GetBitSet: TWordBitSet;
    procedure SetBitSet(const Value: TWordBitSet);
    function GetFired(Source: Integer): Boolean;
    procedure SetFired(Dummy: Integer; Value: Boolean);
    function GetMode(Source: Integer): TExifFlashMode;
    procedure SetMode(Dummy: Integer; const Value: TExifFlashMode);
    function GetPresent(Source: Integer): Boolean;
    procedure SetPresent(Dummy: Integer; Value: Boolean);
    function GetRedEyeReduction(Source: Integer): Boolean;
    procedure SetRedEyeReduction(Dummy: Integer; Value: Boolean);
    function GetStrobeEnergy: TExifFraction;
    procedure SetStrobeEnergy(const Value: TExifFraction);
    function GetStrobeLight(Source: Integer): TExifStrobeLight;
    procedure SetStrobeLight(Dummy: Integer; const Value: TExifStrobeLight);
    function SourceToValues(Source: Integer): TWordBitSet;
  public
    constructor Create(AOwner: TCustomExifData);
    procedure Assign(Source: TPersistent); override;
    function MissingOrInvalid: Boolean;
    property BitSet: TWordBitSet read GetBitSet write SetBitSet stored False;
  published
    property Fired: Boolean index -1 read GetFired write SetFired stored False;
    property Mode: TExifFlashMode index -1 read GetMode write SetMode stored False;
    property Present: Boolean index -1 read GetPresent write SetPresent stored False;
    property RedEyeReduction: Boolean index 6 read GetRedEyeReduction write SetRedEyeReduction stored False;
    property StrobeEnergy: TExifFraction read GetStrobeEnergy write SetStrobeEnergy stored False;
    property StrobeLight: TExifStrobeLight index -1 read GetStrobeLight write SetStrobeLight stored False;
  end;

  TExifVersionElement = 0..9;

  TCustomExifVersion = class abstract(TPersistent)
  strict private
    FOwner: TCustomExifData;
    function GetAsString: string;
    procedure SetAsString(const Value: string);
    function GetMajor: TExifVersionElement;
    procedure SetMajor(Value: TExifVersionElement);
    function GetMinor: TExifVersionElement;
    procedure SetMinor(Value: TExifVersionElement);
    function GetRelease: TExifVersionElement;
    procedure SetRelease(Value: TExifVersionElement);
    function GetValue(Index: Integer): TExifVersionElement;
    procedure SetValue(Index: Integer; Value: TExifVersionElement);
  strict protected
    FMajorIndex: Integer;
    FSectionKind: TExifSectionKind;
    FStoreAsChar: Boolean;
    FTagID: TExifTagID;
    FTiffDataType: TTiffDataType;
    procedure Initialize; virtual; abstract;
  public
    constructor Create(AOwner: TCustomExifData);
    procedure Assign(Source: TPersistent); override;
    function MissingOrInvalid: Boolean;
    property Owner: TCustomExifData read FOwner;
  published
    property AsString: string read GetAsString write SetAsString stored False;
    property Major: TExifVersionElement read GetMajor write SetMajor stored False;
    property Minor: TExifVersionElement read GetMinor write SetMinor stored False;
    property Release: TExifVersionElement read GetRelease write SetRelease stored False;
  end;

  TExifVersion = class(TCustomExifVersion)
  protected
    procedure Initialize; override;
  end;

  TFlashPixVersion = class(TCustomExifVersion)
  protected
    procedure Initialize; override;
  end;

  TGPSVersion = class(TCustomExifVersion)
  protected
    procedure Initialize; override;
  end;

  TInteropVersion = class(TCustomExifVersion)
  protected
    procedure Initialize; override;
  end;

{$Z2}
  TTiffOrientation = (toUndefined, toTopLeft, toTopRight, toBottomRight,
    toBottomLeft, toLeftTop{i.e., rotated}, toRightTop, toRightBottom, toLeftBottom);
  TExifOrientation = TTiffOrientation;
  TTiffResolutionUnit = (trNone = 1, trInch, trCentimetre);
  TExifResolutionUnit = TTiffResolutionUnit;

  TExifColorSpace = (csTagMissing = 0, csRGB = 1, csAdobeRGB, csUncalibrated = $FFFF);
  TExifContrast = (cnTagMissing = -1, cnNormal, cnSoft, cnHard);
  TExifExposureMode = (exTagMissing = -1, exAuto, exManual, exAutoBracket);
  TExifExposureProgram = (eeTagMissing = -1, eeUndefined, eeManual, eeNormal,
    eeAperturePriority, eeShutterPriority, eeCreative, eeAction, eePortrait, eeLandscape);
  TExifGainControl = (egTagMissing = -1, egNone, egLowGainUp, egHighGainUp, egLowGainDown, egHighGainDown);
  TExifLightSource = (elTagMissing = -1, elUnknown, elDaylight, elFluorescent,
    elTungsten, elFlash, elFineWeather = 9, elCloudyWeather, elShade, elDaylightFluorescent,
    elDayWhiteFluorescent, elCoolWhiteFluorescent, elWhiteFluorescent,
    elStandardLightA = 17, elStandardLightB, elStandardLightC, elD55, elD65,
    elD75, elD50, elISOStudioTungsten);
  TExifMeteringMode = (emTagMissing = -1, emUnknown, emAverage, emCenterWeightedAverage,
    emSpot, emMultiSpot, emPattern, emPartial);
  TExifRendering = (erTagMissing = -1, erNormal, erCustom);
  TExifSaturation = (euTagMissing = -1, euNormal, euLow, euHigh);
  TExifSceneCaptureType = (ecTagMissing = -1, ecStandard, ecLandscape, ecPortrait, ecNightScene);
  TExifSensingMethod = (esTagMissing = -1, esMonochrome = 1, esOneChip, esTwoChip,
    esThreeChip, esColorSequential, elTrilinear = 7, esColorSequentialLinear); //esMonochrome was esUndefined before 0.9.7
  TExifSharpness = (ehTagMissing = -1, ehNormal, ehSoft, ehHard);
  TExifSubjectDistanceRange = (edTagMissing = -1, edUnknown, edMacro, edClose, edDistant);
  TExifWhiteBalanceMode = (ewTagMissing = -1, ewAuto, ewManual);
{$Z1}

  TCustomExifResolution = class(TPersistent)
  strict private
    FOwner: TCustomExifData;
    FSchema: TXMPSchemaKind;
    FSection: TExifSection;
    FXTagID, FYTagID, FUnitTagID: TExifTagID;
    FXName, FYName, FUnitName: string;
    function GetUnit: TExifResolutionUnit;
    function GetX: TExifFraction;
    function GetY: TExifFraction;
    procedure SetUnit(const Value: TExifResolutionUnit);
    procedure SetX(const Value: TExifFraction);
    procedure SetY(const Value: TExifFraction);
  protected
    procedure GetTagInfo(var Section: TExifSectionKind; 
      var XTag, YTag, UnitTag: TExifTagID; var Schema: TXMPSchemaKind; 
      var XName, YName, UnitName: string); virtual; abstract;
    property Owner: TCustomExifData read FOwner;
  public
    constructor Create(AOwner: TCustomExifData);
    procedure Assign(Source: TPersistent); override;
    function MissingOrInvalid: Boolean;
    property Section: TExifSection read FSection;
  published
    property X: TExifFraction read GetX write SetX stored False;
    property Y: TExifFraction read GetY write SetY stored False;
    property Units: TExifResolutionUnit read GetUnit write SetUnit stored False;
  end;

  TImageResolution = class(TCustomExifResolution)
  protected
    procedure GetTagInfo(var Section: TExifSectionKind; 
      var XTag, YTag, UnitTag: TExifTagID; var Schema: TXMPSchemaKind; 
      var XName, YName, UnitName: string); override;
  end;

  TFocalPlaneResolution = class(TCustomExifResolution)
  protected
    procedure GetTagInfo(var Section: TExifSectionKind; 
      var XTag, YTag, UnitTag: TExifTagID; var Schema: TXMPSchemaKind; 
      var XName, YName, UnitName: string); override;
  end;

  TThumbnailResolution = class(TCustomExifResolution)
  protected
    procedure GetTagInfo(var Section: TExifSectionKind; 
      var XTag, YTag, UnitTag: TExifTagID; var Schema: TXMPSchemaKind; 
      var XName, YName, UnitName: string); override;
  end;

  TExifResolution = TCustomExifResolution deprecated;

  TISOSpeedRatings = class(TPersistent)
  strict private const
    XMPSchema = xsExif;
    XMPKind = xpSeqArray;
    XMPName = 'ISOSpeedRatings';
  strict private
    FOwner: TCustomExifData;
    function GetAsString: string;
    procedure SetAsString(const Value: string);
    function GetCount: Integer;
    function GetItem(Index: Integer): Word;
    procedure SetCount(const Value: Integer);
    procedure SetItem(Index: Integer; const Value: Word);
  protected
    procedure Clear;
    function FindTag(VerifyDataType: Boolean; out Tag: TExifTag): Boolean;
    property Owner: TCustomExifData read FOwner;
  public
    constructor Create(AOwner: TCustomExifData);
    procedure Assign(Source: TPersistent); override;
    function MissingOrInvalid: Boolean;
    property AsString: string read GetAsString write SetAsString stored False;
    property Count: Integer read GetCount write SetCount stored False;
    property Items[Index: Integer]: Word read GetItem write SetItem; default;
  end;

  TExifFileSource = (fsUnknown, fsFilmScanner, fsReflectionPrintScanner, fsDigitalCamera);
  TExifSceneType = (esUnknown, esDirectlyPhotographed);

  TGPSLatitudeRef = (ltMissingOrInvalid, ltNorth, ltSouth);
  TGPSLongitudeRef = (lnMissingOrInvalid, lnWest, lnEast);
  TGPSAltitudeRef = (alTagMissing, alAboveSeaLevel, alBelowSeaLevel);
  TGPSStatus = (stMissingOrInvalid, stMeasurementActive, stMeasurementVoid);
  TGPSMeasureMode = (mmUnknown, mm2D, mm3D);
  TGPSSpeedRef = (srMissingOrInvalid, srKilometresPerHour, srMilesPerHour, srKnots); //Exif spec makes KM/h the default value
  TGPSDirectionRef = (drMissingOrInvalid, drTrueNorth, drMagneticNorth);
  TGPSDistanceRef = (dsMissingOrInvalid, dsKilometres, dsMiles, dsKnots);
{$Z2}
  TGPSDifferential = (dfTagMissing = -1, dfWithoutCorrection, dfCorrectionApplied);
{$Z1}
  TGPSCoordinate = class(TPersistent)
  strict private
    FOwner: TCustomExifData;
    FRefTagID, FTagID: TExifTagID;
    FXMPName: string;
    function GetAsString: string;
    function GetDirectionChar: AnsiChar;
    function GetValue(Index: Integer): TExifFraction;
    procedure SetDirectionChar(NewChar: AnsiChar);
  protected
    procedure Assign(const ADegrees, AMinutes, ASeconds: TExifFraction;
      ADirectionChar: AnsiChar); reintroduce; overload;
    property Owner: TCustomExifData read FOwner;
    property RefTagID: TExifTagID read FRefTagID;
    property TagID: TExifTagID read FTagID;
    property XMPName: string read FXMPName;
  public
    constructor Create(AOwner: TCustomExifData; ATagID: TExifTagID);
    procedure Assign(Source: TPersistent); overload; override;
    function MissingOrInvalid: Boolean;
    property AsString: string read GetAsString;
    property Degrees: TExifFraction index 0 read GetValue;
    property Minutes: TExifFraction index 1 read GetValue;
    property Seconds: TExifFraction index 2 read GetValue;
    property Direction: AnsiChar read GetDirectionChar write SetDirectionChar;
  end;

  TGPSLatitude = class(TGPSCoordinate)
  strict private
    function GetDirection: TGPSLatitudeRef;
  public
    procedure Assign(const ADegrees, AMinutes, ASeconds: TExifFraction;
      ADirection: TGPSLatitudeRef); reintroduce; overload;
    procedure Assign(ADegrees, AMinutes, ASeconds: LongWord;
      ADirection: TGPSLatitudeRef); reintroduce; overload; inline;
    property Direction: TGPSLatitudeRef read GetDirection;
  end;

  TGPSLongitude = class(TGPSCoordinate)
  strict private
    function GetDirection: TGPSLongitudeRef;
  public
    procedure Assign(const ADegrees, AMinutes, ASeconds: TExifFraction;
      ADirection: TGPSLongitudeRef); reintroduce; overload;
    procedure Assign(ADegrees, AMinutes, ASeconds: LongWord;
      ADirection: TGPSLongitudeRef); reintroduce; overload; inline;
    property Direction: TGPSLongitudeRef read GetDirection;
  end;

{ To add support for a different MakerNote format, you need to write a descendent of
  TExifMakerNote, implementing the protected version of FormatIsOK and probably
  GetIFDInfo too, before registering it via TExifData.RegisterMakerNoteType. }

  TExifDataOffsetsType = (doFromExifStart, doFromMakerNoteStart, doFromIFDStart);

  TExifMakerNote = class abstract
  strict private
    FDataOffsetsType: TExifDataOffsetsType;
    FEndianness: TEndianness;
    FTags: TExifSection;
  protected
    class function FormatIsOK(SourceTag: TExifTag;
      out HeaderSize: Integer): Boolean; overload; virtual; abstract;
    procedure GetIFDInfo(SourceTag: TExifTag; var ProbableEndianness: TEndianness;
      var DataOffsetsType: TExifDataOffsetsType); virtual;
    //procedure RewriteSourceTag(Tag: TExifTag); virtual;
    //procedure WriteHeader(Stream: TStream); virtual; abstract;
    //procedure SaveToStream(Stream: TStream; const StartPos: Int64);
  public
    constructor Create(ASection: TExifSection);
    class function FormatIsOK(SourceTag: TExifTag): Boolean; overload;
    property DataOffsetsType: TExifDataOffsetsType read FDataOffsetsType;
    property Endianness: TEndianness read FEndianness;
    property Tags: TExifSection read FTags;
  end;

  TExifMakerNoteClass = class of TExifMakerNote;

  TUnrecognizedMakerNote = class sealed(TExifMakerNote)
  protected
    class function FormatIsOK(SourceTag: TExifTag; out HeaderSize: Integer): Boolean; override;
  end;

  TCanonMakerNote = class(TExifMakerNote)
  protected
    class function FormatIsOK(SourceTag: TExifTag; out HeaderSize: Integer): Boolean; override;
    procedure GetIFDInfo(SourceTag: TExifTag; var ProbableEndianness: TEndianness;
      var DataOffsetsType: TExifDataOffsetsType); override;
  end;

  TPanasonicMakerNote = class(TExifMakerNote)
  protected
    const Header: array[0..11] of AnsiChar = 'Panasonic';
    class function FormatIsOK(SourceTag: TExifTag; out HeaderSize: Integer): Boolean; override;
    procedure GetIFDInfo(SourceTag: TExifTag; var ProbableEndianness: TEndianness;
      var DataOffsetsType: TExifDataOffsetsType); override;
  end;

  TNikonType1MakerNote = class(TExifMakerNote)
  protected
    const Header: array[0..7] of AnsiChar = 'Nikon'#0#1;
    class function FormatIsOK(SourceTag: TExifTag; out HeaderSize: Integer): Boolean; override;
  end;

  TSonyMakerNote = class(TExifMakerNote)
  protected
    const Header: array[0..7] of AnsiChar = 'SONY DSC';
    class function FormatIsOK(SourceTag: TExifTag; out HeaderSize: Integer): Boolean; override;
    procedure GetIFDInfo(SourceTag: TExifTag; var ProbableEndianness: TEndianness;
      var DataOffsetsType: TExifDataOffsetsType); override;
  end;

  EInvalidExifData = class(ECCRExifException);

  TJPEGMetaDataKind = (mkExif, mkXMP);
  TJPEGMetadataKinds = set of TJPEGMetadataKind;

  TCustomExifData = class(TInterfacedPersistent)
  public type
    TEnumerator = record
    strict private
      FClient: TCustomExifData;
      FDoneFirst: Boolean;
      FSection: TExifSectionKind;
      function GetCurrent: TExifSection; {$IFDEF CANINLINE}inline;{$ENDIF}
    public
      constructor Create(AClient: TCustomExifData);
      function MoveNext: Boolean;
      property Current: TExifSection read GetCurrent;
    end;
    TMakerNoteTypePriority = (mtTestForLast, mtTestForFirst);
  strict private
    FAlwaysWritePreciseTimes: Boolean;
    FChangedWhileUpdating: Boolean;
    FEndianness: TEndianness;
    FEnforceASCII: Boolean;
    FExifVersion: TCustomExifVersion;
    FFlash: TExifFlashInfo;
    FFlashPixVersion: TCustomExifVersion;
    FFocalPlaneResolution: TCustomExifResolution;
    FGPSLatitude, FGPSDestLatitude: TGPSLatitude;
    FGPSLongitude, FGPSDestLongitude: TGPSLongitude;
    FGPSVersion: TCustomExifVersion;
    FInteropVersion: TCustomExifVersion;
    FISOSpeedRatings: TISOSpeedRatings;
    FMakerNoteType: TExifMakerNoteClass;
    FMakerNoteValue: TExifMakerNote;
    FOffsetBase: Int64;
    FModified: Boolean;
    FResolution: TCustomExifResolution;
    FSections: array[TExifSectionKind] of TExifSection;
    FThumbnailResolution: TCustomExifResolution;
    FUpdateCount: Integer;
    FXMPPacketValue: TXMPPacket;
    FXMPSegmentToLoad: IFoundJPEGSegment;
    FOnChange: TNotifyEvent;
    procedure SetEndianness(Value: TEndianness);
    function GetMakerNote: TExifMakerNote;
    function GetSection(Section: TExifSectionKind): TExifSection; //inline;
    function GetUpdating: Boolean; inline;
    procedure SetModified(const Value: Boolean);
    function GetDateTime: TDateTime;
    procedure SetDateTime(const Value: TDateTime);
    function GetGeneralString(TagID: Integer): string;
    procedure SetGeneralString(TagID: Integer; const Value: string);
    function GetGeneralWinString(TagID: Integer): UnicodeString;
    procedure SetGeneralWinString(TagID: Integer; const Value: UnicodeString);
    function GetDetailsDateTime(TagID: Integer): TDateTime;
    procedure SetDetailsDateTime(TagID: Integer; const Value: TDateTime);
    function GetDetailsFraction(TagID: Integer): TExifFraction;
    procedure SetDetailsFraction(TagID: Integer; const Value: TExifFraction);
    function GetDetailsSFraction(TagID: Integer): TExifSignedFraction;
    procedure SetDetailsSFraction(TagID: Integer; const Value: TExifSignedFraction);
    function GetDetailsLongInt(TagID: Integer): LongInt;
    procedure SetDetailsLongInt(TagID: Integer; const Value: LongInt);
    function GetDetailsLongWord(TagID: Integer): LongWord;
    function GetDetailsString(TagID: Integer): string;
    procedure SetDetailsString(TagID: Integer; const Value: string);
    function GetAuthor: UnicodeString;
    procedure SetAuthor(const Value: UnicodeString);
    function GetComments: UnicodeString;
    procedure SetComments(const Value: UnicodeString);
    function GetUserRating: TWindowsStarRating;
    procedure SetUserRating(const Value: TWindowsStarRating);
    procedure SetFlash(Value: TExifFlashInfo);
    procedure SetFocalPlaneResolution(Value: TCustomExifResolution);
    procedure SetResolution(Value: TCustomExifResolution);
    procedure SetThumbnailResolution(Value: TCustomExifResolution);
    procedure SetGPSVersion(Value: TCustomExifVersion);
    procedure SetGPSLatitude(Value: TGPSLatitude);
    procedure SetGPSLongitude(Value: TGPSLongitude);
    function GetGPSAltitudeRef: TGPSAltitudeRef;
    procedure SetGPSAltitudeRef(const Value: TGPSAltitudeRef);
    function GetGPSFraction(TagID: Integer): TExifFraction;
    procedure SetGPSFraction(TagID: Integer; const Value: TExifFraction);
    function GetGPSDateTimeUTC: TDateTime;
    procedure SetGPSDateTimeUTC(const Value: TDateTime);
    function GetGPSTimeStamp(const Index: Integer): TExifFraction;
    procedure SetGPSTimeStamp(const Index: Integer; const Value: TExifFraction);
    function GetGPSString(TagID: Integer): string;
    procedure SetGPSString(TagID: Integer; const Value: string);
    function GetGPSStatus: TGPSStatus;
    procedure SetGPSStatus(const Value: TGPSStatus);
    function GetGPSMeasureMode: TGPSMeasureMode;
    procedure SetGPSMeasureMode(const Value: TGPSMeasureMode);
    function GetGPSSpeedRef: TGPSSpeedRef;
    procedure SetGPSSpeedRef(const Value: TGPSSpeedRef);
    function GetGPSDirection(TagID: Integer): TGPSDirectionRef;
    procedure SetGPSDirection(TagID: Integer; Value: TGPSDirectionRef);
    procedure SetGPSDestLatitude(Value: TGPSLatitude);
    procedure SetGPSDestLongitude(Value: TGPSLongitude);
    function GetGPSDestDistanceRef: TGPSDistanceRef;
    procedure SetGPSDestDistanceRef(const Value: TGPSDistanceRef);
    function GetGPSDifferential: TGPSDifferential;
    procedure SetGPSDifferential(Value: TGPSDifferential);
    function GetColorSpace: TExifColorSpace;
    procedure SetColorSpace(Value: TExifColorSpace);
    function GetContrast: TExifContrast;
    procedure SetContrast(Value: TExifContrast);
    function GetOrientation(SectionKind: Integer): TExifOrientation;
    procedure SetOrientation(SectionKind: Integer; Value: TExifOrientation);
    procedure SetExifVersion(Value: TCustomExifVersion);
    procedure SetFlashPixVersion(Value: TCustomExifVersion);
    procedure SetInteropVersion(Value: TCustomExifVersion);
    function GetExposureProgram: TExifExposureProgram;
    procedure SetExposureProgram(const Value: TExifExposureProgram);
    function GetFileSource: TExifFileSource;
    procedure SetFileSource(const Value: TExifFileSource);
    function GetLightSource: TExifLightSource;
    procedure SetLightSource(const Value: TExifLightSource);
    function GetMeteringMode: TExifMeteringMode;
    procedure SetMeteringMode(const Value: TExifMeteringMode);
    function GetSaturation: TExifSaturation;
    procedure SetSaturation(Value: TExifSaturation);
    function GetSceneType: TExifSceneType;
    procedure SetSceneType(Value: TExifSceneType);
    function GetSensingMethod: TExifSensingMethod;
    procedure SetSensingMethod(const Value: TExifSensingMethod);
    function GetSharpness: TExifSharpness;
    procedure SetSharpness(Value: TExifSharpness);
    function GetSubjectLocation: TSmallPoint;
    procedure SetSubjectLocation(const Value: TSmallPoint);
    function GetRendering: TExifRendering;
    function GetFocalLengthIn35mmFilm: Word;
    function GetExposureMode: TExifExposureMode;
    function GetSceneCaptureType: TExifSceneCaptureType;
    function GetWhiteBalance: TExifWhiteBalanceMode;
    procedure SetRendering(const Value: TExifRendering);
    procedure SetFocalLengthIn35mmFilm(Value: Word);
    procedure SetExposureMode(const Value: TExifExposureMode);
    procedure SetSceneCaptureType(const Value: TExifSceneCaptureType);
    procedure SetWhiteBalance(const Value: TExifWhiteBalanceMode);
    function GetGainControl: TExifGainControl;
    procedure SetGainControl(const Value: TExifGainControl);
    function GetSubjectDistanceRange: TExifSubjectDistanceRange;
    procedure SetSubjectDistanceRange(Value: TExifSubjectDistanceRange);
    procedure SetDetailsByteEnum(ID: TExifTagID; const XMPName: UnicodeString; const Value);
    procedure SetDetailsWordEnum(ID: TExifTagID; const XMPName: UnicodeString; const Value);
    procedure SetExifImageSize(ID: Integer; NewValue: LongWord);
    function GetInteropTypeName: string;
    procedure SetInteropTypeName(const Value: string);
    procedure SetISOSpeedRatings(Value: TISOSpeedRatings);
    function GetXMPPacket: TXMPPacket;
    function GetXMPWritePolicy: TXMPWritePolicy;
    procedure SetXMPWritePolicy(Value: TXMPWritePolicy);
  strict protected
    FMetadataInSource: TJPEGMetadataKinds;
    FXMPSegmentPosition, FXMPPacketSizeInSource: Int64;
    property XMPSegmentToLoad: IFoundJPEGSegment read FXMPSegmentToLoad;
  protected
    const MaxThumbnailSize = $F000;
    class function SectionClass: TExifSectionClass; virtual;
    procedure Changed(Section: TExifSection); virtual;
    function GetEmpty: Boolean; virtual;
    function FindThumbnailOffset(SourceStream: TStream; var Offset: LongInt): Boolean;
    function LoadFromJPEG(JPEGStream: TStream): Boolean;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure RemoveXMPProperty(Schema: TXMPSchemaKind; const PropName: string); overload;
    procedure RemoveXMPProperty(Schema: TXMPSchemaKind; const PropNames: array of string); overload;
    procedure ResetMakerNoteType;
    property OffsetBase: Int64 read FOffsetBase;
  private class var
    FMakerNoteClasses: TList;
  public
    class procedure RegisterMakerNoteType(AClass: TExifMakerNoteClass;
      Priority: TMakerNoteTypePriority);
    class procedure RegisterMakerNoteTypes(const AClasses: array of TExifMakerNoteClass;
      Priority: TMakerNoteTypePriority);
    class procedure UnregisterMakerNoteType(AClass: TExifMakerNoteClass);
  public
    constructor Create;
    destructor Destroy; override;
    function GetEnumerator: TEnumerator;
    procedure Clear(XMPPacketToo: Boolean = True); virtual;
    procedure BeginUpdate;
    procedure EndUpdate;
    function HasMakerNote: Boolean;
    procedure Rewrite;
    procedure SetAllDateTimeValues(const NewValue: TDateTime);
    function ShutterSpeedInMSecs: Extended;
    property Empty: Boolean read GetEmpty;
    property Endianness: TEndianness read FEndianness write SetEndianness;
    property MakerNote: TExifMakerNote read GetMakerNote;
    property MetadataInSource: TJPEGMetadataKinds read FMetadataInSource; //set in LoadFromJPEG
    property Modified: Boolean read FModified write SetModified;
    property Sections[Section: TExifSectionKind]: TExifSection read GetSection; default;
    property Updating: Boolean read GetUpdating;
    property XMPPacket: TXMPPacket read GetXMPPacket;
    property XMPWritePolicy: TXMPWritePolicy read GetXMPWritePolicy write SetXMPWritePolicy;
  published
    property AlwaysWritePreciseTimes: Boolean read FAlwaysWritePreciseTimes write FAlwaysWritePreciseTimes default False;
    property EnforceASCII: Boolean read FEnforceASCII write FEnforceASCII default True;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    { main dir tags }
    property CameraMake: string index ttMake read GetGeneralString write SetGeneralString stored False;
    property CameraModel: string index ttModel read GetGeneralString write SetGeneralString stored False;
    property Copyright: string index ttCopyright read GetGeneralString write SetGeneralString stored False;
    property DateTime: TDateTime read GetDateTime write SetDateTime stored False;
    property ImageDescription: string index ttImageDescription read GetGeneralString write SetGeneralString stored False;
    property Orientation: TExifOrientation index Ord(esGeneral) read GetOrientation write SetOrientation stored False;
    property Resolution: TCustomExifResolution read FResolution write SetResolution stored False;
    property Software: string index ttSoftware read GetGeneralString write SetGeneralString stored False;
    { main dir tags set by Windows Explorer (XP+) }
    property Author: UnicodeString read GetAuthor write SetAuthor stored False; //falls back to ttArtist if nec
    property Comments: UnicodeString read GetComments write SetComments stored False; //falls back to ttUserComment in the Exif IFD if necessary
    property Keywords: UnicodeString index ttWindowsKeywords read GetGeneralWinString write SetGeneralWinString stored False;
    property Subject: UnicodeString index ttWindowsSubject read GetGeneralWinString write SetGeneralWinString stored False;
    property Title: UnicodeString index ttWindowsTitle read GetGeneralWinString write SetGeneralWinString stored False;
    property UserRating: TWindowsStarRating read GetUserRating write SetUserRating stored False;
    { sub dir tags }
    property ApertureValue: TExifFraction index ttApertureValue read GetDetailsFraction write SetDetailsFraction stored False;
    property BrightnessValue: TExifSignedFraction index ttBrightnessValue read GetDetailsSFraction write SetDetailsSFraction stored False;
    property ColorSpace: TExifColorSpace read GetColorSpace write SetColorSpace stored False;
    property Contrast: TExifContrast read GetContrast write SetContrast stored False;
    property CompressedBitsPerPixel: TExifFraction index ttCompressedBitsPerPixel read GetDetailsFraction write SetDetailsFraction stored False;
    property DateTimeOriginal: TDateTime index ttDateTimeOriginal read GetDetailsDateTime write SetDetailsDateTime stored False;
    property DateTimeDigitized: TDateTime index ttDateTimeDigitized read GetDetailsDateTime write SetDetailsDateTime stored False;
    property DigitalZoomRatio: TExifFraction index ttDigitalZoomRatio read GetDetailsFraction write SetDetailsFraction stored False;
    property ExifVersion: TCustomExifVersion read FExifVersion write SetExifVersion stored False;
    property ExifImageWidth: LongWord index ttExifImageWidth read GetDetailsLongWord write SetExifImageSize stored False;
    property ExifImageHeight: LongWord index ttExifImageHeight read GetDetailsLongWord write SetExifImageSize stored False;
    property ExposureBiasValue: TExifSignedFraction index ttExposureBiasValue read GetDetailsSFraction write SetDetailsSFraction stored False;
    property ExposureIndex: TExifFraction index ttExposureIndex read GetDetailsFraction write SetDetailsFraction stored False; //old Kodak camera tag
    property ExposureMode: TExifExposureMode read GetExposureMode write SetExposureMode stored False;
    property ExposureProgram: TExifExposureProgram read GetExposureProgram write SetExposureProgram stored False;
    property ExposureTime: TExifFraction index ttExposureTime read GetDetailsFraction write SetDetailsFraction stored False; //in secs
    property FileSource: TExifFileSource read GetFileSource write SetFileSource;
    property Flash: TExifFlashInfo read FFlash write SetFlash stored False;
    property FlashPixVersion: TCustomExifVersion read FFlashPixVersion write SetFlashPixVersion stored False;
    property FNumber: TExifFraction index ttFNumber read GetDetailsFraction write SetDetailsFraction stored False;
    property FocalLength: TExifFraction index ttFocalLength read GetDetailsFraction write SetDetailsFraction stored False;
    property FocalLengthIn35mmFilm: Word read GetFocalLengthIn35mmFilm write SetFocalLengthIn35mmFilm stored False;
    property FocalPlaneResolution: TCustomExifResolution read FFocalPlaneResolution write SetFocalPlaneResolution stored False;
    property GainControl: TExifGainControl read GetGainControl write SetGainControl stored False;
    property ImageUniqueID: string index ttImageUniqueID read GetDetailsString write SetDetailsString stored False;
    property ISOSpeedRatings: TISOSpeedRatings read FISOSpeedRatings write SetISOSpeedRatings;
    property LightSource: TExifLightSource read GetLightSource write SetLightSource stored False;
    property MaxApertureValue: TExifFraction index ttMaxApertureValue read GetDetailsFraction write SetDetailsFraction stored False;
    property MeteringMode: TExifMeteringMode read GetMeteringMode write SetMeteringMode stored False;
    property OffsetSchema: LongInt index ttOffsetSchema read GetDetailsLongInt write SetDetailsLongInt stored False;
    property RelatedSoundFile: string index ttRelatedSoundFile read GetDetailsString write SetDetailsString stored False;
    property Rendering: TExifRendering read GetRendering write SetRendering stored False;
    property Saturation: TExifSaturation read GetSaturation write SetSaturation stored False;
    property SceneCaptureType: TExifSceneCaptureType read GetSceneCaptureType write SetSceneCaptureType stored False;
    property SceneType: TExifSceneType read GetSceneType write SetSceneType stored False;
    property SensingMethod: TExifSensingMethod read GetSensingMethod write SetSensingMethod stored False;
    property Sharpness: TExifSharpness read GetSharpness write SetSharpness stored False;
    property ShutterSpeedValue: TExifSignedFraction index ttShutterSpeedValue read GetDetailsSFraction write SetDetailsSFraction stored False; //in APEX; for display, you may well prefer to use ShutterSpeedInMSecs
    property SpectralSensitivity: string index ttSpectralSensitivity read GetDetailsString write SetDetailsString;
    property SubjectDistance: TExifFraction index ttSubjectDistance read GetDetailsFraction write SetDetailsFraction stored False;
    property SubjectDistanceRange: TExifSubjectDistanceRange read GetSubjectDistanceRange write SetSubjectDistanceRange stored False;
    property SubjectLocation: TSmallPoint read GetSubjectLocation write SetSubjectLocation stored False;
    property WhiteBalanceMode: TExifWhiteBalanceMode read GetWhiteBalance write SetWhiteBalance stored False;
    { sub dir tags whose data are rolled into the DateTime properties, so don't display them for the sake of it }
    property SubsecTime: string index ttSubsecTime read GetDetailsString write SetDetailsString stored False;
    property SubsecTimeOriginal: string index ttSubsecTimeOriginal read GetDetailsString write SetDetailsString stored False;
    property SubsecTimeDigitized: string index ttSubsecTimeDigitized read GetDetailsString write SetDetailsString stored False;
    { Interop }
    property InteropTypeName: string read GetInteropTypeName write SetInteropTypeName stored False;
    property InteropVersion: TCustomExifVersion read FInteropVersion write SetInteropVersion;
    { GPS }
    property GPSVersion: TCustomExifVersion read FGPSVersion write SetGPSVersion stored False;
    property GPSLatitude: TGPSLatitude read FGPSLatitude write SetGPSLatitude;
    property GPSLongitude: TGPSLongitude read FGPSLongitude write SetGPSLongitude;
    property GPSAltitudeRef: TGPSAltitudeRef read GetGPSAltitudeRef write SetGPSAltitudeRef stored False;
    property GPSAltitude: TExifFraction index ttGPSAltitude read GetGPSFraction write SetGPSFraction stored False;
    property GPSSatellites: string index ttGPSSatellites read GetGPSString write SetGPSString stored False;
    property GPSStatus: TGPSStatus read GetGPSStatus write SetGPSStatus stored False;
    property GPSMeasureMode: TGPSMeasureMode read GetGPSMeasureMode write SetGPSMeasureMode stored False;
    property GPSDOP: TExifFraction index ttGPSDOP read GetGPSFraction write SetGPSFraction stored False;
    property GPSSpeedRef: TGPSSpeedRef read GetGPSSpeedRef write SetGPSSpeedRef stored False;
    property GPSSpeed: TExifFraction index ttGPSSpeed read GetGPSFraction write SetGPSFraction stored False;
    property GPSTrackRef: TGPSDirectionRef index ttGPSTrackRef read GetGPSDirection write SetGPSDirection stored False;
    property GPSTrack: TExifFraction index ttGPSTrack read GetGPSFraction write SetGPSFraction;
    property GPSImgDirectionRef: TGPSDirectionRef index ttGPSImgDirectionRef read GetGPSDirection write SetGPSDirection stored False;
    property GPSImgDirection: TExifFraction index ttGPSImgDirection read GetGPSFraction write SetGPSFraction;
    property GPSMapDatum: string index ttGPSMapDatum read GetGPSString write SetGPSString;
    property GPSDestLatitude: TGPSLatitude read FGPSDestLatitude write SetGPSDestLatitude;
    property GPSDestLongitude: TGPSLongitude read FGPSDestLongitude write SetGPSDestLongitude;
    property GPSDestBearingRef: TGPSDirectionRef index ttGPSDestBearingRef read GetGPSDirection write SetGPSDirection stored False;
    property GPSDestBearing: TExifFraction index ttGPSDestBearing read GetGPSFraction write SetGPSFraction stored False;
    property GPSDestDistanceRef: TGPSDistanceRef read GetGPSDestDistanceRef write SetGPSDestDistanceRef stored False;
    property GPSDestDistance: TExifFraction index ttGPSDestDistance read GetGPSFraction write SetGPSFraction stored False;
    property GPSDifferential: TGPSDifferential read GetGPSDifferential write SetGPSDifferential stored False;
    property GPSDateTimeUTC: TDateTime read GetGPSDateTimeUTC write SetGPSDateTimeUTC stored False;
    { GPS tags whose data are rolled into the GPSDataTimeUTC property, so don't display them for the sake of it }
    property GPSDateStamp: string index ttGPSDateStamp read GetGPSString write SetGPSString stored False;
    property GPSTimeStampHour: TExifFraction index 0 read GetGPSTimeStamp write SetGPSTimeStamp stored False;
    property GPSTimeStampMinute: TExifFraction index 1 read GetGPSTimeStamp write SetGPSTimeStamp stored False;
    property GPSTimeStampSecond: TExifFraction index 2 read GetGPSTimeStamp write SetGPSTimeStamp stored False;
    { thumbnail tags }
    property ThumbnailOrientation: TExifOrientation index Ord(esThumbnail) read GetOrientation write SetOrientation stored False;
    property ThumbnailResolution: TCustomExifResolution read FThumbnailResolution
      write SetThumbnailResolution stored False;
  public
    { *** TO BE REMOVED *** }
    function GPSDifferentialApplied: Boolean; deprecated; //use GPSDifferential instead
    function GPSLatitudeRef: TGPSLatitudeRef; deprecated; //use GPSLatitude.Direction instead
    function GPSLatitudeDegrees: TExifFraction; deprecated; //use GPSLatitude.Degrees instead
    function GPSLatitudeMinutes: TExifFraction; deprecated; //use GPSLatitude.Minutes instead
    function GPSLatitudeSeconds: TExifFraction; deprecated; //use GPSLatitude.Seconds instead
    function GPSLongitudeRef: TGPSLongitudeRef; deprecated; //use GPSLongitude.Direction instead
    function GPSLongitudeDegrees: TExifFraction; deprecated; //use GPSLongitude.Degrees instead
    function GPSLongitudeMinutes: TExifFraction; deprecated; //use GPSLongitude.Minutes instead
    function GPSLongitudeSeconds: TExifFraction; deprecated; //use GPSLongitude.Seconds instead
    function GPSDestLatitudeRef: TGPSLatitudeRef; deprecated; //use GPSDestLatitude.Direction instead
    function GPSDestLatitudeDegrees: TExifFraction; deprecated; //use GPSDestLatitude.Degrees instead
    function GPSDestLatitudeMinutes: TExifFraction; deprecated; //use GPSDestLatitude.Minutes instead
    function GPSDestLatitudeSeconds: TExifFraction; deprecated; //use GPSDestLatitude.Seconds instead
    function GPSDestLongitudeRef: TGPSLongitudeRef; deprecated; //use GPSDestLongitude.Direction instead
    function GPSDestLongitudeDegrees: TExifFraction; deprecated; //use GPSDestLongitude.Degrees instead
    function GPSDestLongitudeMinutes: TExifFraction; deprecated; //use GPSDestLongitude.Minutes instead
    function GPSDestLongitudeSeconds: TExifFraction; deprecated; //use GPSDestLongitude.Seconds instead
  end;

  EExifDataPatcherError = class(ECCRExifException);
  ENoExifFileOpenError = class(EExifDataPatcherError);
  EIllegalEditOfExifData = class(EExifDataPatcherError);

  TExifDataPatcher = class(TCustomExifData)
  strict private
    FOriginalEndianness: TEndianness;
    FPreserveFileDate: Boolean;
    FStream: TFileStream;
    function GetFileDateTime: TDateTime;
    procedure SetFileDateTime(const Value: TDateTime);
    function GetFileName: string;
  protected
    procedure CheckFileIsOpen;
    property Stream: TFileStream read FStream;
  public
    constructor Create(const AFileName: string = '');
    destructor Destroy; override;
    procedure GetImage(Dest: TJPEGImage);
    procedure GetThumbnail(Dest: TJPEGImage);
    function HasThumbnail: Boolean;
    procedure OpenFile(const FileName: string);
    procedure UpdateFile;
    procedure CloseFile(SaveChanges: Boolean = False);
    property FileDateTime: TDateTime read GetFileDateTime write SetFileDateTime;
  published
    property FileName: string read GetFileName write OpenFile;
    property PreserveFileDate: Boolean read FPreserveFileDate write FPreserveFileDate default False;
  end;

  TExifData = class(TCustomExifData, IStreamPersist)
  public type
    TMakerNotePositioning = (mpAuto, mpNeverMove, mpCanMove);
  strict private
    FRemovePaddingTagsOnSave: Boolean;
    FThumbnailOrNil: TJPEGImage;
    function GetSection(Section: TExifSectionKind): TExtendableExifSection; inline;
    function GetThumbnail: TJPEGImage;
    procedure SetThumbnail(const Value: TJPEGImage);
    procedure ThumbnailChanged(Sender: TObject);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure DoSaveToJPEG(InStream, OutStream: TStream);
    function GetEmpty: Boolean; override;
    class function SectionClass: TExifSectionClass; override;
  public
    MakerNotePosition: TMakerNotePositioning deprecated;
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear(XMPPacketToo: Boolean = True); override;
    procedure CreateThumbnail(Source: TGraphic;
      ThumbnailWidth: Integer = StandardExifThumbnailWidth;
      ThumbnailHeight: Integer = StandardExifThumbnailHeight);
    function LoadFromJPEG(JPEGStream: TStream): Boolean; overload;
    function LoadFromJPEG(JPEGImage: TJPEGImage): Boolean; overload;
    function LoadFromJPEG(const FileName: string): Boolean; overload;
    procedure LoadFromStream(Stream: TStream); override;
    procedure RemoveMakerNote;
    procedure RemovePaddingTags;
    { SaveToJPEG replaces any existing Exif data }
    procedure SaveToJPEG(const JPEGFileName: string); overload; //file must already exist
    procedure SaveToJPEG(JPEGImage: TJPEGImage); overload;
    procedure SaveToStream(Stream: TStream);
    procedure StandardizeThumbnail;
    property Sections[Section: TExifSectionKind]: TExtendableExifSection read GetSection; default;
  published
    property RemovePaddingTagsOnSave: Boolean read FRemovePaddingTagsOnSave write
      FRemovePaddingTagsOnSave default True;
    property Thumbnail: TJPEGImage read GetThumbnail write SetThumbnail stored False;
  end;

  TJpegImageEx = class(TJPEGImage)
  strict private
    FChangedSinceLastLoad: Boolean;
    FExifData: TExifData;
    function GetXMPPacket: TXMPPacket;
    procedure ReloadExifData;
  protected
    procedure Changed(Sender: TObject); override;
    procedure ReadData(Stream: TStream); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CreateThumbnail(ThumbnailWidth: Integer = StandardExifThumbnailWidth;
      ThumbnailHeight: Integer = StandardExifThumbnailHeight);
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    property ExifData: TExifData read FExifData;
    property XMPPacket: TXMPPacket read GetXMPPacket; //just a shortcut for ExifData.XMPPacket
  end;

const
  stMeasurementInProgress = stMeasurementActive;
  stMeasurementInInterop = stMeasurementVoid;
  ltUnknown = ltMissingOrInvalid deprecated;
  lnUnknown = lnMissingOrInvalid deprecated;
  stUnknown = stMissingOrInvalid deprecated;

function ContainsOnlyASCII(const S: UnicodeString): Boolean; overload;
function ContainsOnlyASCII(const S: RawByteString): Boolean; overload;

function DateTimeToExifString(const DateTime: TDateTime): string;
function TryExifStringToDateTime(const S: string; var DateTime: TDateTime): Boolean; overload;

function ProportionallyResizeExtents(const Width, Height: Integer;
  const MaxWidth, MaxHeight: Integer): TSize;

const
  AllJPEGMetaDataKinds = [Low(TJPEGMetaDataKind)..High(TJPEGMetaDataKind)];

function RemoveMetadataFromJPEG(const JPEGFileName: string;
  Kinds: TJPEGMetadataKinds = AllJPEGMetaDataKinds): TJPEGMetadataKinds; overload;
function RemoveMetadataFromJPEG(JPEGImage: TJpegImage;
  Kinds: TJPEGMetadataKinds = AllJPEGMetaDataKinds): TJPEGMetadataKinds; overload;

function RemoveExifDataFromJPEG(const JPEGFileName: string): Boolean; overload; inline; deprecated;
function RemoveExifDataFromJPEG(JPEGImage: TJpegImage): Boolean; overload; inline; deprecated;

type
  THeaderCheckOption = (hcAlwaysRewindStream, hcMovePositionOnSuccess);

function StreamHasHeader(Data: TStream; const Header; HeaderSize: Byte;
  StreamPosAtEnd: THeaderCheckOption = hcAlwaysRewindStream): Boolean;
function StreamHasExifHeader(Stream: TStream;
  StreamPosAtEnd: THeaderCheckOption = hcAlwaysRewindStream): Boolean;
function StreamHasJpegHeader(Stream: TStream;
  StreamPosAtEnd: THeaderCheckOption = hcAlwaysRewindStream): Boolean;
function StreamHasXMPSegmentHeader(Stream: TStream;
  StreamPosAtEnd: THeaderCheckOption = hcAlwaysRewindStream): Boolean;
function StreamHasXMPHeader(Stream: TStream;
  StreamPosAtEnd: THeaderCheckOption = hcAlwaysRewindStream): Boolean; deprecated; //use StreamHasXMPSegmentHeader

implementation

{$IFOPT R-}
  {$DEFINE RANGECHECKINGOFF}
{$ENDIF}

uses
  SysConst, RTLConsts, Math, DateUtils, CCR.Exif.Consts;

type
  PDoubleArray = ^TDoubleArray;
  TDoubleArray = array[0..High(TByteArray) div 8] of Double;

  PShortIntArray = ^TShortIntArray;
  TShortIntArray = array[0..High(TByteArray)] of ShortInt;

  PSmallIntArray = ^TSmallIntArray;
  TSmallIntArray = array[0..High(TWordArray)] of SmallInt;

  PLongWordArray = ^TLongWordArray;
  TLongWordArray = array[0..High(TWordArray) div 2] of LongWord;

  PLongIntArray = ^TLongIntArray;
  TLongIntArray = array[0..High(TWordArray) div 2] of LongInt;

  PExifFractionArray = ^TExifFractionArray;
  TExifFractionArray = array[0..High(TLongWordArray) div 2] of TExifFraction;

const
  NullFraction: TExifFraction = (PackedValue: 0);
  TagHeaderSize = 12;

{ general helper routines }

function ContainsOnlyASCII(const S: UnicodeString): Boolean;
var
  Ch: WideChar;
begin
  Result := True;
  for Ch in S do
    if Ord(Ch) > 128 then
    begin
      Result := False;
      Break;
    end;
end;

function ContainsOnlyASCII(const S: RawByteString): Boolean;
var
  Ch: AnsiChar;
begin
  Result := True;
  for Ch in S do
    if Ord(Ch) > 128 then
    begin
      Result := False;
      Break;
    end;
end;

function GetGPSTagXMPName(TagID: TExifTagID): string;
begin
  case TagID of
    ttGPSVersionID: Result := 'GPSVersionID';
    ttGPSLatitude: Result := 'GPSLatitude'; //includes ttGPSLatitudeRef
    ttGPSLongitude: Result := 'GPSLongitude'; //includes ttGPSLongitudeRef
    ttGPSAltitudeRef: Result := 'GPSAltitudeRef';
    ttGPSAltitude: Result := 'GPSAltitude';
    ttGPSTimeStamp: Result := 'GPSTimeStamp'; //includes GPSDateStamp
    ttGPSSatellites: Result := 'GPSSatellites';
    ttGPSStatus: Result := 'GPSStatus';
    ttGPSMeasureMode: Result :='GPSMeasureMode';
    ttGPSDOP: Result := 'GPSDOP';
    ttGPSSpeedRef: Result := 'GPSSpeedRef';
    ttGPSSpeed: Result := 'GPSSpeed';
    ttGPSTrackRef: Result := 'GPSTrackRef';
    ttGPSTrack: Result := 'GPSTrack';
    ttGPSImgDirectionRef: Result := 'GPSImgDirectionRef';
    ttGPSImgDirection: Result := 'GPSImgDirection';
    ttGPSMapDatum: Result := 'GPSMapDatum';
    ttGPSDestBearingRef: Result := 'GPSDestBearingRef';
    ttGPSDestBearing: Result := 'GPSDestBearing';
    ttGPSDestDistance: Result := 'GPSDestDistance';
    ttGPSDestLatitude: Result := 'GPSDestLatitude'; //includes ttGPSDestLatitudeRef
    ttGPSDestLongitude: Result := 'GPSDestLongitude'; //includes ttGPSDestLongitudeRef
    ttGPSDifferential: Result := 'GPSDifferential';
  else Result := '';
  end;
end;

function FindGPSTagXMPName(TagID: TExifTagID; out PropName: string): Boolean;
begin
  PropName := GetGPSTagXMPName(TagID);
  Result := (PropName <> '');
end;

function ProportionallyResizeExtents(const Width, Height: Integer;
  const MaxWidth, MaxHeight: Integer): TSize;
var
  XYAspect: Double;
begin
  if (Width = 0) or (Height = 0) then
  begin
    Result.cx := 0;
    Result.cy := 0;
    Exit;
  end;
  Result.cx := Width;
  Result.cy := Height;
  XYAspect := Width / Height;
  if Width > Height then
  begin
    Result.cx := MaxWidth;
    Result.cy := Round(MaxWidth / XYAspect);
    if Result.cy > MaxHeight then
    begin
      Result.cy := MaxHeight;
      Result.cx := Round(MaxHeight * XYAspect);
    end;
  end
  else
  begin
    Result.cy := MaxHeight;
    Result.cx := Round(MaxHeight * XYAspect);
    if Result.cx > MaxWidth then
    begin
      Result.cx := MaxWidth;
      Result.cy := Round(MaxWidth / XYAspect);
    end;
  end;
end;

procedure CreateExifThumbnail(Source: TGraphic; Dest: TJPEGImage;
  MaxWidth: Integer = StandardExifThumbnailWidth;
  MaxHeight: Integer = StandardExifThumbnailHeight);
var
  Bitmap: TBitmap;
  R: TRect;
begin
  with ProportionallyResizeExtents(Source.Width, Source.Height, MaxWidth, MaxHeight) do
    R := Rect(0, 0, cx, cy);
  Bitmap := TBitmap.Create;
  try
    Bitmap.SetSize(R.Right, R.Bottom);
    if not Source.Empty then Bitmap.Canvas.StretchDraw(R, Source);
    Dest.Assign(Bitmap);
  finally
    Bitmap.Free;
  end;
end;

function DoRemoveMetaDataFromJPEG(InStream, OutStream: TStream;
  Kinds: TJPEGMetadataKinds): TJPEGMetadataKinds;
var
  Segment: IFoundJPEGSegment;
  StartCopyFrom: Int64;

  procedure DoCopyFrom(const EndPos: Int64);
  begin
    InStream.Position := StartCopyFrom;
    if (EndPos - StartCopyFrom) > 0 then
      OutStream.CopyFrom(InStream, EndPos - StartCopyFrom);
    StartCopyFrom := EndPos;
  end;
begin
  StartCopyFrom := InStream.Position;
  for Segment in JPEGHeader(InStream, [jmApp1]) do
  begin
    if (mkExif in Kinds) and StreamHasExifHeader(Segment.Data, hcMovePositionOnSuccess) then
      Include(Result, mkExif)
    else if (mkXMP in Kinds) and StreamHasXMPSegmentHeader(Segment.Data, hcMovePositionOnSuccess) then
      Include(Result, mkXMP)
    else
      Continue;
    DoCopyFrom(Segment.Offset);
    Inc(StartCopyFrom, Segment.TotalSize);
  end;
  DoCopyFrom(InStream.Size);
  if OutStream is THandleStream then OutStream.Size := OutStream.Position;
end;

function RemoveMetadataFromJPEG(const JPEGFileName: string;
  Kinds: TJPEGMetadataKinds = AllJPEGMetaDataKinds): TJPEGMetadataKinds; overload;
var
  InStream: TMemoryStream;
  OutStream: TFileStream;
begin
  OutStream := nil;
  InStream := TMemoryStream.Create;
  try
    InStream.LoadFromFile(JPEGFileName);
    OutStream := TFileStream.Create(JPEGFileName, fmOpenWrite);
    Result := DoRemoveMetaDataFromJPEG(InStream, OutStream, Kinds);
  finally
    OutStream.Free;
    InStream.Free;
  end;
end;

function RemoveMetaDataFromJPEG(JPEGImage: TJpegImage;
  Kinds: TJPEGMetadataKinds = AllJPEGMetaDataKinds): TJPEGMetadataKinds; overload;
var
  InStream, OutStream: TMemoryStream;
begin
  OutStream := nil;
  InStream := TMemoryStream.Create;
  try
    JPEGImage.SaveToStream(InStream);
    InStream.Position := 0;
    OutStream := TMemoryStream.Create;
    Result := DoRemoveMetaDataFromJPEG(InStream, OutStream, Kinds);
    if Result <> [] then
    begin
      OutStream.Position := 0;
      JPEGImage.LoadFromStream(OutStream);
    end;
  finally
    OutStream.Free;
    InStream.Free;
  end;
end;

function RemoveExifDataFromJPEG(const JPEGFileName: string): Boolean; overload;
begin
  Result := (mkExif in RemoveMetaDataFromJPEG(JPEGFileName, [mkExif]));
end;

function RemoveExifDataFromJPEG(JPEGImage: TJpegImage): Boolean; overload;
begin
  Result := (mkExif in RemoveMetaDataFromJPEG(JPEGImage, [mkExif]));
end;

{ segment header checking }

const
  ExifHeader: array[0..5] of AnsiChar = 'Exif'#0#0;

function StreamHasHeader(Data: TStream; const Header; HeaderSize: Byte;
  StreamPosAtEnd: THeaderCheckOption = hcAlwaysRewindStream): Boolean;
var
  Buffer: array[Byte] of Byte;
begin
  Result := (HeaderSize = 0);
  if not Result and (Data.Size > (Data.Position + HeaderSize)) then
  begin
    Data.ReadBuffer(Buffer[0], HeaderSize);
    Result := CompareMem(@Buffer[0], @Header, HeaderSize);
    if (StreamPosAtEnd = hcAlwaysRewindStream) or not Result then
      Data.Seek(-Int64(HeaderSize), soCurrent);
  end;
end;

function StreamHasExifHeader(Stream: TStream;
  StreamPosAtEnd: THeaderCheckOption = hcAlwaysRewindStream): Boolean;
begin
  Result := StreamHasHeader(Stream, ExifHeader, SizeOf(ExifHeader), StreamPosAtEnd);
end;

function StreamHasJpegHeader(Stream: TStream;
  StreamPosAtEnd: THeaderCheckOption = hcAlwaysRewindStream): Boolean;
begin
  Result := StreamHasHeader(Stream, JpegFileHeader, SizeOf(JpegFileHeader), StreamPosAtEnd);
end;

function StreamHasXMPSegmentHeader(Stream: TStream;
  StreamPosAtEnd: THeaderCheckOption = hcAlwaysRewindStream): Boolean;
begin
  Result := StreamHasHeader(Stream, XMPSegmentHeader, SizeOf(XMPSegmentHeader), StreamPosAtEnd);
end;

function StreamHasXMPHeader(Stream: TStream;
  StreamPosAtEnd: THeaderCheckOption = hcAlwaysRewindStream): Boolean;
begin
  Result := StreamHasHeader(Stream, XMPSegmentHeader, SizeOf(XMPSegmentHeader), StreamPosAtEnd);
end;

{ TTiffTagInfo }

function TTiffTagInfo.DataSize: Integer;
begin
  if IsWellFormed then
    Result := ElementCount * TiffElementSizes[DataType]
  else
    Result := 0;
end;

function TTiffTagInfo.IsWellFormed: Boolean;
begin
  Result := (ElementCount >= 0) and (Word(DataType) >= Word(Low(DataType))) and
    (Word(DataType) <= Word(High(DataType)));
end;

{ TTiffLongXXXFraction }

function TryStrToTiffFraction(const S: string; out Fraction: TTiffLongWordFraction): Boolean;
var
  DivSignPos: Integer;
  Value: Int64;
begin
  DivSignPos := Pos('/', S);
  Result := TryStrToInt64(Copy(S, 1, DivSignPos - 1), Value);
  if Result then
  begin
    Fraction.Numerator := LongWord(Value);
    if DivSignPos = 0 then
      Fraction.Denominator := 1
    else
      Result := TryStrToInt64(Copy(S, DivSignPos + 1, MaxInt), Value);
      if Result then Fraction.Denominator := LongWord(Value);
  end;
  if not Result then
    Fraction.PackedValue := 0;
end;

function StrToTiffFraction(const S: string): TTiffLongWordFraction;
begin
  if not TryStrToTiffFraction(S, Result) then
    raise EConvertError.CreateFmt(SInvalidFraction, [S]);
end;

function TiffFractionToStr(const Fraction: TTiffLongWordFraction): string;
begin
  Result := Fraction.AsString;
end;

constructor TTiffLongIntFraction.Create(ANumerator: LongWord; ADenominator: LongInt);
begin
  Numerator := ANumerator;
  Denominator := ADenominator;
end;

constructor TTiffLongIntFraction.CreateFromString(const AString: string);
var
  DivSignPos: Integer;
  Result: Boolean;
begin
  DivSignPos := Pos('/', AString);
  if DivSignPos <> 0 then
    Result := TryStrToInt(Copy(AString, 1, DivSignPos - 1), Numerator) and
      TryStrToInt(Copy(AString, DivSignPos + 1, MaxInt), Denominator)
  else
  begin
    Result := TryStrToInt(AString, Numerator);
    if Result then Denominator := 1;
  end;
  if not Result then
    PackedValue := 0;
end;

function TTiffLongIntFraction.AsString: string;
begin
  if MissingOrInvalid then
    Result := ''
  else if Denominator = 1 then
    Result := IntToStr(Numerator)
  else
    FmtStr(Result, '%d/%d', [Numerator, Denominator]);
end;

function TTiffLongIntFraction.MissingOrInvalid: Boolean;
begin
  Result := (Denominator = 0);
end;

function TTiffLongIntFraction.Quotient: Extended;
begin
  if MissingOrInvalid then
    Result := 0
  else
    Result := Numerator / Denominator
end;

function TryStrToLongWord(const S: string; var Value: LongWord): Boolean;
var
  Int64Value: Int64;
begin
  Result := TryStrToInt64(S, Int64Value) and (Int64Value >= 0) and
    (Int64Value <= High(Value));
  if Result then Value := LongWord(Int64Value);
end;

constructor TTiffLongWordFraction.Create(ANumerator: LongWord; ADenominator: LongWord);
begin
  Numerator := ANumerator;
  Denominator := ADenominator;
end;

constructor TTiffLongWordFraction.CreateFromString(const AString: string);
var
  DivSignPos: Integer;
  Result: Boolean;
begin
  DivSignPos := Pos('/', AString);
  if DivSignPos <> 0 then
    Result := TryStrToLongWord(Copy(AString, 1, DivSignPos - 1), Numerator) and
      TryStrToLongWord(Copy(AString, DivSignPos + 1, MaxInt), Denominator)
  else
  begin
    Result := TryStrToLongWord(AString, Numerator);
    if Result then Denominator := 1;
  end;
  if not Result then
    PackedValue := 0;
end;

function TTiffLongWordFraction.AsString: string;
begin
  if MissingOrInvalid then
    Result := ''
  else if Denominator = 1 then
    Result := IntToStr(Numerator)
  else
    FmtStr(Result, '%d/%d', [Numerator, Denominator]);
end;

function TTiffLongWordFraction.MissingOrInvalid: Boolean;
begin
  Result := (Denominator = 0);
end;

function TTiffLongWordFraction.Quotient: Extended;
begin
  if MissingOrInvalid then
    Result := 0
  else
    Result := Numerator / Denominator
end;

{ TIFF parsing routines }

function LoadTiffDirectory(const Info: TTiffInfo; const Offset: Int64;
  const InternalOffset: Int64 = 0): TTiffDirectory;
var                                        // Sanity checking:
  I, TagCount: Integer;                    // - We check the reported tag count is
  MaxTagCount, StartPos, StreamSize: Int64;//   theoretically possible up front.
begin                                      // - Data offsets are validated.
  Result.LoadErrors := [];                 // - Two bad tag headers in a row, and any
  Result.Tags := nil;                      //   further parsing is aborted.
  StartPos := Info.BasePosition + Offset;
  StreamSize := Info.Stream.Seek(0, soEnd);
  if (StartPos < 0) or (StartPos + 2 > StreamSize) then
  begin
    Result.LoadErrors := [leBadOffset];
    Exit;
  end;
  MaxTagCount := (StreamSize - StartPos - 2) div TagHeaderSize;
  Info.Stream.Position := StartPos;
  TagCount := Info.Stream.ReadWord(Info.Endianness);
  if TagCount > MaxTagCount then
  begin
    TagCount := MaxTagCount;
    Include(Result.LoadErrors, leBadTagCount);
  end;
  SetLength(Result.Tags, TagCount);
  for I := 0 to TagCount - 1 do
  begin
    Result.Tags[I].HeaderOffset := Info.Stream.Position - Info.BasePosition;
    Result.Tags[I].ID := Info.Stream.ReadWord(Info.Endianness);
    Word(Result.Tags[I].DataType) := Info.Stream.ReadWord(Info.Endianness);
    Result.Tags[I].ElementCount := Info.Stream.ReadLongInt(Info.Endianness);
    if Result.Tags[I].DataSize > 4 then
    begin
      Result.Tags[I].DataOffset := Info.Stream.ReadLongInt(Info.Endianness) + InternalOffset;
      if (Result.Tags[I].DataOffset + Info.BasePosition < 0) or
         (Result.Tags[I].DataOffset + Result.Tags[I].DataSize + Info.BasePosition > StreamSize) then
        Result.Tags[I].ElementCount := -1;
    end
    else
    begin
      Result.Tags[I].DataOffset := Info.Stream.Position - Info.BasePosition;
      Info.Stream.Seek(4, soCurrent);
    end;
    if not Result.Tags[I].IsWellFormed then
      if (I = 0) or Result.Tags[I - 1].IsWellFormed then
        Include(Result.LoadErrors, leBadTagHeader)
      else
      begin
        Include(Result.LoadErrors, leBadTagCount);
        SetLength(Result.Tags, I);
        Exit;
      end;
  end;
end;

procedure LoadTiffInfo(Stream: TStream; var Info: TTiffInfo);
var
  DirectoryCount: Integer;
  MaxOffsetValue: Int64;

  procedure ReadDirectory(Offset: LongInt);
  begin
    if Offset = 0 then Exit;
    if Length(Info.Directories) = DirectoryCount then
      SetLength(Info.Directories, DirectoryCount + 8);
    Info.Directories[DirectoryCount] := LoadTiffDirectory(Info, Offset);
    Inc(DirectoryCount);
    if Stream.ReadLongInt(Info.Endianness, Offset) and (Offset <= MaxOffsetValue) then
      ReadDirectory(Offset);
  end;
begin
  DirectoryCount := 0;
  Info.Directories := nil;
  Info.Stream := Stream;
  Info.BasePosition := Stream.Position;
  case Stream.ReadWord(SmallEndian) of
    TiffSmallEndianCode: Info.Endianness := SmallEndian;
    TiffBigEndianCode: Info.Endianness := BigEndian;
  else
    raise EInvalidTiffData.Create(SInvalidTiffData);
  end;
  if Stream.ReadWord(Info.Endianness) <> TiffMagicNum then
    raise EInvalidTiffData.Create(SInvalidTiffData);
  MaxOffsetValue := Stream.Size - Info.BasePosition - 4; //4 is the minimum size of an IFD (word-sized tag count + word-sized next IFD offset)
  ReadDirectory(Stream.ReadLongInt(Info.Endianness));
  SetLength(Info.Directories, DirectoryCount);
end;

procedure LoadTiffTagData(const Info: TTiffInfo; const Tag: TTiffTagInfo; var Buffer);
var
  Size: Integer;
  I: Integer;
begin
  Size := Tag.DataSize;
  if Size = 0 then Exit;
  Info.Stream.Position := Info.BasePosition + Tag.DataOffset;
  case TiffElementSizes[Tag.DataType] of
    1: Info.Stream.ReadBuffer(Buffer, Size);
    2:
      for I := 0 to Tag.ElementCount - 1 do
        PWordArray(@Buffer)[I] := Info.Stream.ReadWord(Info.Endianness);
  else
    if Tag.DataType = tdDouble then
      for I := 0 to Tag.ElementCount - 1 do
        PDoubleArray(@Buffer)[I] := Info.Stream.ReadDouble(Info.Endianness)
    else
      for I := 0 to (Size div 4) - 1 do
        PLongWordArray(@Buffer)[I] := Info.Stream.ReadLongWord(Info.Endianness);
  end;
end;

function LoadTiffTagData(const Info: TTiffInfo; const Tag: TTiffTagInfo): TBytes;
begin
  SetLength(Result, Tag.DataSize);
  if Result <> nil then
    LoadTiffTagData(Info, Tag, Result[0]);
end;

{ Exif date/time strings }

function GetExifSubSecsString(const MSecs: Word): string; overload;
begin
  Result := Copy(Format('%d', [MSecs]), 1, 3);
end;

function GetExifSubSecsString(const DateTime: TDateTime): string; overload;
begin
  Result := GetExifSubSecsString(MilliSecondOf(DateTime));
end;

function DateTimeToExifString(const DateTime: TDateTime): string;
var
  Year, Month, Day, Hour, Minute, Second, MilliSecond: Word;
begin
  if DateTime = 0 then
    Result := StringOfChar(' ', 19)
  else
  begin
    DecodeDateTime(DateTime, Year, Month, Day, Hour, Minute, Second, MilliSecond);
    FmtStr(Result, '%.4d:%.2d:%.2d %.2d:%.2d:%.2d', [Year, Month, Day, Hour, Minute, Second]);
  end;
end;

function TryExifStringToDateTime(const S: string; var DateTime: TDateTime): Boolean;
var
  Year, Month, Day, Hour, Min, Sec: Integer;
begin //'2007:09:02 02:30:49'
  Result := (Length(S) = 19) and (S[5] = ':') and (S[8] = ':') and 
    TryStrToInt(Copy(S, 1, 4), Year) and
    TryStrToInt(Copy(S, 6, 2), Month) and
    TryStrToInt(Copy(S, 9, 2), Day) and
    TryStrToInt(Copy(S, 12, 2), Hour) and
    TryStrToInt(Copy(S, 15, 2), Min) and
    TryStrToInt(Copy(S, 18, 2), Sec) and
    TryEncodeDateTime(Year, Month, Day, Hour, Min, Sec, 0, DateTime);
end;

{ TExifTag }

constructor TExifTag.Create(const Section: TExifSection;
  const ID: TExifTagID; DataType: TExifDataType; ElementCount: Integer);
begin
  inherited Create;
  FDataType := DataType;
  FID := ID;
  FSection := Section;
  FElementCount := ElementCount;
  if FElementCount < 0 then FElementCount := 0;
  FData := AllocMem(DataSize);
  FOriginalDataSize := DataSize;
  FWellFormed := True;
end;

constructor TExifTag.Create(const Section: TExifSection;
  const Info: TTiffInfo; const TagRec: TTiffTagInfo);
begin
  if TagRec.IsWellFormed then
    Create(Section, TagRec.ID, TagRec.DataType, TagRec.ElementCount)
  else
    Create(Section, TagRec.ID, tdUndefined, 0);
  FOriginalDataOffset := TagRec.DataOffset;
  FWellFormed := TagRec.IsWellFormed;
  if TagRec.ElementCount > 0 then LoadTiffTagData(Info, TagRec, FData^);
end;

destructor TExifTag.Destroy;
begin
  if Section <> nil then Section.TagDeleting(Self);
  if FData <> nil then FreeMem(FData);
  inherited;
end;

procedure TExifTag.Assign(Source: TExifTag);
begin
  if Source = nil then
    ElementCount := 0
  else
  begin
    if (Source.Section <> Section) or (Section = nil) then
      ID := Source.ID;
    UpdateData(Source.DataType, Source.ElementCount, Source.Data^);
  end;
end;

procedure TExifTag.Changing(NewID: TExifTagID; NewDataType: TExifDataType;
  NewElementCount: LongInt; NewData: Boolean);
begin
  if Section <> nil then
    Section.TagChanging(Self, NewID, NewDataType, NewElementCount, NewData);
end;

procedure TExifTag.Changed(ChangeType: TExifTagChangeType);
begin
  if ChangeType in [tcData, tcDataSize] then FAsStringCache := '';
  if Section <> nil then Section.TagChanged(Self, ChangeType);
end;

procedure TExifTag.Changed;
begin
  Changed(tcData);
end;

function TExifSection.CheckExtendable: TExtendableExifSection;
begin
  if Self is TExtendableExifSection then
    Result := TExtendableExifSection(Self)
  else
    raise EIllegalEditOfExifData.Create(SIllegalEditOfExifData);
end;

procedure TExifTag.Delete;
begin
  Destroy;
end;

function TExifTag.GetAsBytes: TBytes;
begin
  if FElementCount = 0 then
    Result := nil
  else
  begin
    SetLength(Result, DataSize);
    Move(FData^, Result[0], Length(Result));
  end;
end;

function NextElementStr(DataType: TExifDataType; var SeekPtr: PAnsiChar): string;
begin
  case DataType of
    tdAscii: Result := string(AnsiString(SeekPtr^));
    tdByte: Result := IntToStr(PByte(SeekPtr)^);
    tdWord: Result := IntToStr(PWord(SeekPtr)^);
    tdLongWord: Result := IntToStr(PLongWord(SeekPtr)^);
    tdShortInt: Result := IntToStr(PShortInt(SeekPtr)^);
    tdSmallInt: Result := IntToStr(PSmallInt(SeekPtr)^);
    tdLongInt, tdSubDirectory: Result := IntToStr(PLongInt(SeekPtr)^);
    tdSingle: Result := FloatToStr(PSingle(SeekPtr)^);
    tdDouble: Result := FloatToStr(PDouble(SeekPtr)^);
    tdLongWordFraction, tdLongIntFraction: Result := PExifFraction(SeekPtr).AsString;
  end;
  Inc(SeekPtr, TiffElementSizes[DataType]);
end;

function TExifTag.GetAsString: string;
var
  TiffStr: TiffString;
  I: Integer;
  SeekPtr: PAnsiChar;
begin
  if (FAsStringCache = '') and (ElementCount <> 0) then
    case DataType of
      tdAscii:
      begin
        SetString(TiffStr, PAnsiChar(FData), ElementCount - 1);
        FAsStringCache := string(TiffStr);
      end;
      tdUndefined:
      begin
        SetLength(FAsStringCache, DataSize * 2);
        BinToHex(FData, PChar(FAsStringCache), DataSize);
      end
    else
      if HasWindowsStringData then
        FAsStringCache := WideCharLenToString(FData, ElementCount div 2 - 1)
      else
      begin
        SeekPtr := FData;
        if ElementCount = 1 then
          FAsStringCache := NextElementStr(DataType, SeekPtr)
        else
          with TStringList.Create do
          try
            for I := 0 to ElementCount - 1 do
              Add(NextElementStr(DataType, SeekPtr));
            FAsStringCache := CommaText;
          finally
            Free;
          end;
      end;
    end;
  Result := FAsStringCache;
end;

procedure TExifTag.SetAsString(const Value: string);
var
  Buffer: TiffString;
  S: string;
  List: TStringList;
  SeekPtr: PAnsiChar;
  UnicodeStr: UnicodeString;
begin
  if Length(Value) = 0 then
    ElementCount := 0
  else
    case DataType of
      tdAscii:
      begin
        if (Section <> nil) and Section.EnforceASCII and not ContainsOnlyASCII(Value) then
          raise ENotOnlyASCIIError.Create(STagCanContainOnlyASCII);
        Buffer := TiffString(Value);
        UpdateData(tdAscii, Length(Buffer) + 1, PAnsiChar(Buffer)^); //ascii tag data includes null terminator
      end;
      tdUndefined:
      begin
        SetLength(Buffer, Length(Value) div 2);
        SeekPtr := PAnsiChar(Buffer);
        HexToBin(PChar(LowerCase(Value)), SeekPtr, Length(Buffer));
        UpdateData(tdUndefined, Length(Buffer), SeekPtr^);
      end;
    else
      if HasWindowsStringData then
      begin
        UnicodeStr := Value;
        UpdateData(tdByte, Length(UnicodeStr) * 2 + 1, UnicodeStr[1]);
      end
      else
      begin
        List := TStringList.Create;
        try
          List.CommaText := Value;
          SetLength(Buffer, List.Count * TiffElementSizes[DataType]);
          SeekPtr := PAnsiChar(Buffer);
          for S in List do
          begin
            {$RANGECHECKS ON}
            case DataType of
              tdByte: PByte(SeekPtr)^ := StrToInt(S);
              tdWord: PWord(SeekPtr)^ := StrToInt(S);
              tdLongWord: PLongWord(SeekPtr)^ := StrToInt64(S);
              tdShortInt: PShortInt(SeekPtr)^ := StrToInt(S);
              tdSmallInt: PSmallInt(SeekPtr)^ := StrToInt(S);
              tdLongInt, tdSubDirectory: PLongInt(SeekPtr)^ := StrToInt(S);
              tdLongWordFraction, tdLongIntFraction: PExifFraction(SeekPtr)^ :=
                TExifFraction.CreateFromString(S);
              tdSingle: PSingle(SeekPtr)^ := StrToFloat(S);
              tdDouble: PDouble(SeekPtr)^ := StrToFloat(S);
            end;
            {$IFDEF RANGECHECKINGOFF}{$RANGECHECKS OFF}{$ENDIF}
            Inc(SeekPtr, TiffElementSizes[DataType]);
          end;
        finally
          List.Free;
        end;
        UpdateData(DataType, Length(Buffer), Pointer(Buffer)^);
      end;
    end;
  FAsStringCache := Value;
end;

function TExifTag.GetDataSize: Integer;
begin
  Result := ElementCount * TiffElementSizes[DataType]
end;

function TExifTag.GetElementAsString(Index: Integer): string;
var
  SeekPtr: PAnsiChar;
begin
  if (Index < 0) or (Index >= ElementCount) then
    raise EListError.CreateFmt(SListIndexError, [Index]);
  SeekPtr := FData;
  Inc(SeekPtr, Index * TiffElementSizes[DataType]);
  Result := NextElementStr(DataType, SeekPtr);
end;

function TExifTag.HasWindowsStringData: Boolean;
begin
  Result := False;
  if (DataType = tdByte) and (Section <> nil) and (Section.Kind = esGeneral) then
    case ID of
      ttWindowsTitle, ttWindowsComments, ttWindowsAuthor, ttWindowsKeywords,
      ttWindowsSubject: Result := True;
    end;
end;

procedure TExifTag.SetDataType(const NewDataType: TExifDataType);
begin
  if NewDataType <> FDataType then
    UpdateData(NewDataType, ElementCount, PByte(nil)^);
end;

procedure TExifTag.SetElementCount(const NewCount: LongInt);
begin
  if NewCount <> FElementCount then
    UpdateData(DataType, NewCount, PByte(nil)^);
end;

procedure TExifTag.SetID(const Value: TExifTagID);
begin
  if Value = FID then Exit;
  Changing(Value, DataType, ElementCount, False);
  FID := Value;
  Changed(tcID);
end;

function TExifTag.IsPadding: Boolean;
begin
  Result := (ID = ttWindowsPadding) and (DataType = tdUndefined) and
    (ElementCount >= 2) and (PWord(Data)^ = ttWindowsPadding);
end;

function TExifTag.ReadFraction(Index: Integer; const Default: TExifFraction): TExifFraction;
begin
  if (DataType in [tdLongWordFraction, tdLongIntFraction]) and (Index >= 0) and
     (Index < ElementCount) then
    Result := PExifFractionArray(FData)[Index]
  else
    Result := Default;
end;

function TExifTag.ReadLongWord(Index: Integer; const Default: LongWord): LongWord;
begin
  if (Index < 0) or (Index >= ElementCount) then
    Result := Default
  else
    case DataType of
      tdByte, tdShortInt: Result := PByteArray(FData)[Index];
      tdWord, tdSmallInt: Result := PWordArray(FData)[Index];
      tdLongWord, tdLongInt: Result := PLongWordArray(FData)[Index];
    else Result := Default;
    end;
end;

function TExifTag.ReadWord(Index: Integer; const Default: Word): Word;
begin
  if (Index < 0) or (Index >= ElementCount) then
    Result := Default
  else
    case DataType of
      tdByte, tdShortInt: Result := PByteArray(FData)[Index];
      tdWord, tdSmallInt: Result := PWordArray(FData)[Index];
    else Result := Default;
    end;
end;

procedure TExifTag.SetAsBytes(const Value: TBytes);
begin
  if Value <> nil then
    UpdateData(DataType, Length(Value) div TiffElementSizes[DataType], Value[0])
  else
    ElementCount := 0;
end;

procedure TExifTag.SetAsPadding(Size: TExifPaddingTagSize);
begin
  ID := ttWindowsPadding;
  UpdateData(tdUndefined, Size, Pointer(nil)^);
  PWord(Data)^ := ttWindowsPadding;
  if Size > 2 then
    FillChar(PWordArray(Data)[1], Size - 2, 0);
end;

procedure TExifTag.UpdateData(const NewData);
begin
  Changing(ID, DataType, ElementCount, True);
  Move(NewData, FData^, DataSize);
  Changed(tcData);
end;

procedure TExifTag.UpdateData(NewDataType: TExifDataType;
  NewElementCount: Integer; const NewData);
const
  IntDataTypes = [tdByte, tdWord, tdLongWord, tdShortInt, tdSmallInt, tdLongWord];
var
  OldDataSize, NewDataSize, I: Integer;
  OldIntVals: array of LongWord;
begin
  if NewElementCount < 0 then NewElementCount := 0;
  if (@NewData = nil) and (NewDataType = DataType) and (NewElementCount = ElementCount) then
    Exit;
  OldDataSize := GetDataSize;
  NewDataSize := NewElementCount * TiffElementSizes[NewDataType];
  Changing(ID, NewDataType, NewElementCount, (@NewData <> nil));
  if (@NewData = nil) and (NewDataSize <> OldDataSize) and (DataType in IntDataTypes) and
     (NewDataType in IntDataTypes) and (ElementCount <> 0) and (NewElementCount <> 0) then
  begin
    SetLength(OldIntVals, FElementCount);
    for I := 0 to Min(FElementCount, NewElementCount) - 1 do
      Move(PByteArray(FData)[I * TiffElementSizes[DataType]], OldIntVals[I],
        TiffElementSizes[DataType]);
  end;
  ReallocMem(FData, NewDataSize);
  if NewDataSize > OldDataSize then
    FillChar(PByteArray(FData)[OldDataSize], NewDataSize - OldDataSize, 0);
  if @NewData <> nil then
    Move(NewData, FData^, NewDataSize)
  else if TiffElementSizes[FDataType] <> TiffElementSizes[NewDataType] then
  begin
    FillChar(FData^, Min(OldDataSize, NewDataSize), 0);
    if OldIntVals <> nil then
      for I := 0 to High(OldIntVals) do
        Move(OldIntVals[I], PByteArray(FData)[I * TiffElementSizes[DataType]],
          TiffElementSizes[DataType]);
  end;
  FDataType := NewDataType;
  FElementCount := NewElementCount;
  if NewDataSize <> OldDataSize then
    Changed(tcDataSize)
  else
    Changed(tcData);
end;

procedure TExifTag.WriteHeader(Stream: TStream; Endianness: TEndianness;
  DataOffset: LongInt);
var
  I: Integer;
begin
  Stream.WriteWord(ID, Endianness);
  Stream.WriteWord(Ord(DataType), Endianness);
  Stream.WriteLongInt(ElementCount, Endianness);
  if DataSize > 4 then
    Stream.WriteLongInt(DataOffset, Endianness)
  else
  begin
    case TiffElementSizes[DataType] of
      1: Stream.WriteBuffer(Data^, ElementCount);
      2: for I := 0 to ElementCount - 1 do
           Stream.WriteWord(PWordArray(Data)[I], Endianness);
      4: Stream.WriteLongWord(PLongWord(Data)^, Endianness);
    end;
    for I := 3 downto DataSize do
      Stream.WriteByte(0);
  end;
end;

procedure TExifTag.WriteOffsettedData(Stream: TStream; Endianness: TEndianness);
var
  I: Integer;
begin
  if DataSize <= 4 then Exit;
  if DataType = tdDouble then
    for I := 0 to ElementCount - 1 do
      Stream.WriteDouble(PDoubleArray(Data)[I], Endianness)
  else
    case TiffElementSizes[DataType] of
      1: Stream.WriteBuffer(Data^, ElementCount);
      2: for I := 0 to ElementCount - 1 do
           Stream.WriteWord(PWordArray(Data)[I], Endianness);
    else
      for I := 0 to DataSize div 4 - 1 do
        Stream.WriteLongWord(PLongWordArray(Data)[I], Endianness)
    end;
end;

{ TExifSection.Enumerator }

constructor TExifSection.TEnumerator.Create(ATagList: TList);
begin
  FCurrent := nil;
  FIndex := 0;
  FTags := ATagList;
end;

function TExifSection.TEnumerator.MoveNext: Boolean;
begin //allow deleting a tag when enumerating
  if (FCurrent <> nil) and (FIndex < FTags.Count) and (FCurrent = FTags.List[FIndex]) then
    Inc(FIndex);
  Result := FIndex < FTags.Count;
  if Result then FCurrent := FTags.List[FIndex];
end;

{ TExifSection }

constructor TExifSection.Create(AOwner: TCustomExifData; AKind: TExifSectionKindEx);
begin
  inherited Create;
  FOwner := AOwner;
  FTagList := TList.Create;
  FKind := AKind;
end;

destructor TExifSection.Destroy;
var
  I: Integer;
begin
  for I := FTagList.Count - 1 downto 0 do
    with TExifTag(FTagList.List[I]) do
    begin
      FSection := nil;
      Destroy;
    end;
  FTagList.Free;
  inherited;
end;

function TExifSection.Add(ID: TExifTagID; DataType: TExifDataType;
  ElementCount: Integer): TExifTag;
var
  I: Integer;
  Tag: TExifTag;
begin
  CheckExtendable;
  for I := 0 to FTagList.Count - 1 do
  begin
    Tag := FTagList.List[I];
    if Tag.ID = ID then
      raise ETagAlreadyExists.CreateFmt(STagAlreadyExists, [ID]);
    if Tag.ID > ID then
    begin
      Result := TExifTag.Create(Self, ID, DataType, ElementCount);
      FTagList.Insert(I, Result);
      Changed;
      Exit;
    end;
  end;
  Result := TExifTag.Create(Self, ID, DataType, ElementCount);
  FTagList.Add(Result);
  Changed;
end;

procedure TExifSection.Changed;
begin
  FModified := True;
  if (FOwner <> nil) and (FKind <> esUserDefined) then FOwner.Changed(Self);
end;

procedure TExifSection.Clear;
var
  I: Integer;
begin
  FLoadErrors := [];
  if FOwner <> nil then FOwner.BeginUpdate;
  try
    for I := FTagList.Count - 1 downto 0 do
      DoDelete(I, True);
  finally
    if FOwner <> nil then FOwner.EndUpdate;
  end;
end;

procedure TExifSection.DoDelete(TagIndex: Integer; FreeTag: Boolean);
var
  Tag: TExifTag;
begin
  Tag := FTagList[TagIndex];
  FTagList.Delete(TagIndex);
  Tag.FSection := nil;
  if (Tag.ID = ttMakerNote) and (FKind = esDetails) and (FOwner <> nil) then
    FOwner.ResetMakerNoteType;
  if FreeTag then Tag.Destroy;
  Changed;
end;

function TExifSection.EnforceASCII: Boolean;
begin
  Result := (FOwner <> nil) and FOwner.EnforceASCII;
end;

function TExifSection.Find(ID: TExifTagID; out Tag: TExifTag): Boolean;
var
  Index: Integer;
begin
  Result := FindIndex(ID, Index);
  if Result then
    Tag := FTagList.List[Index]
  else
    Tag := nil;
end;

function TExifSection.FindIndex(ID: TExifTagID; var TagIndex: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FTagList.Count - 1 do
    if TExifTag(FTagList.List[I]).ID >= ID then
    begin
      if TExifTag(FTagList.List[I]).ID = ID then
      begin
        TagIndex := I;
        Result := True;
      end;
      Exit;
    end;
end;

function TExifSection.ForceSetElement(ID: TExifTagID; DataType: TExifDataType;
  Index: Integer; const Value): TExifTag;
var
  Dest: PByte;
  NewValueIsDifferent: Boolean;
begin
  Assert(Index >= 0);
  if Find(ID, Result) then
    Result.UpdateData(DataType, Max(Result.ElementCount, Succ(Index)), PByte(nil)^)
  else
    Result := Add(ID, DataType, Succ(Index));
  Dest := @PByteArray(Result.Data)[Index * TiffElementSizes[DataType]];
  NewValueIsDifferent := not CompareMem(Dest, @Value, TiffElementSizes[DataType]);
  if NewValueIsDifferent then
  begin
    Move(Value, Dest^, TiffElementSizes[DataType]);
    Result.Changed;
  end;
end;

function TExifSection.GetTagCount: Integer;
begin
  Result := FTagList.Count;
end;

function TExifSection.GetEnumerator: TEnumerator;
begin
  Result := TEnumerator.Create(FTagList);
end;

function TExifSection.GetByteValue(TagID: TExifTagID; Index: Integer; Default: Byte;
  MinValue: Byte = 0; MaxValue: Byte = High(Byte)): Byte;
begin
  if not TryGetByteValue(TagID, Index, Result) or (Result < MinValue) or (Result > MaxValue) then
    Result := Default;
end;

function TExifSection.GetDateTimeValue(MainID, SubSecsID: TExifTagID;
  const Default: TDateTime): TDateTime;
var
  SubSecsTag: TExifTag;
  SubSecs: Integer;
  S: TiffString;
begin
  if not TryExifStringToDateTime(GetStringValue(MainID), Result) then
    Result := Default
  else if (Owner <> nil) and (SubSecsID <> 0) and Owner[esDetails].Find(SubSecsID, SubSecsTag) and
    (SubSecsTag.ElementCount > 1) and (SubSecsTag.DataType = tdAscii) then
  begin
    SetLength(S, 3);
    FillChar(Pointer(S)^, 3, '0');
    Move(SubSecsTag.Data^, S[1], Max(3, SubSecsTag.ElementCount - 1));
    if TryStrToInt(string(S), SubSecs) then
      IncMilliSecond(Result, SubSecs)
  end;
end;

function TExifSection.GetFractionValue(TagID: TExifTagID; Index: Integer): TExifFraction;
begin
  Result := GetFractionValue(TagID, Index, NullFraction)
end;

function TExifSection.GetFractionValue(TagID: TExifTagID; Index: Integer;
  const Default: TExifFraction): TExifFraction;
var
  Tag: TExifTag;
begin
  if Find(TagID, Tag) and (Tag.DataType in [tdLongWordFraction,
     tdLongIntFraction]) and (Tag.ElementCount > Index) and (Index >= 0) then
    Result := PExifFractionArray(Tag.Data)[Index]
  else
    Result := Default;     
end;

function TExifSection.GetLongIntValue(TagID: TExifTagID; Index: Integer;
  Default: LongInt): LongInt;
begin
  if not TryGetLongWordValue(TagID, Index, Result) then
    Result := Default;
end;

function TExifSection.GetLongWordValue(TagID: TExifTagID; Index: Integer;
  Default: LongWord): LongWord;
begin
  if not TryGetLongWordValue(TagID, Index, Result) then
    Result := Default;
end;

function TExifSection.GetSmallIntValue(TagID: TExifTagID; Index: Integer; Default: SmallInt;
  MinValue: SmallInt = Low(SmallInt); MaxValue: SmallInt = High(SmallInt)): SmallInt;
begin
  if not TryGetWordValue(TagID, Index, Result) or (Result < MinValue) or (Result > MaxValue) then
    Result := Default;
end;

function TExifSection.GetStringValue(TagID: TExifTagID;
  const Default: string): string;
begin
  if not TryGetStringValue(TagID, Result) then
    Result := Default;
end;

function TExifSection.GetWindowsStringValue(TagID: TExifTagID;
  const Default: UnicodeString): UnicodeString;
begin
  if not TryGetWindowsStringValue(TagID, Result) then
    Result := Default;
end;

function TExifSection.GetWordValue(TagID: TExifTagID; Index: Integer; Default: Word;
  MinValue: Word = 0; MaxValue: Word = High(Word)): Word;
begin
  if not TryGetWordValue(TagID, Index, Result) or (Result < MinValue) or (Result > MaxValue) then
    Result := Default;
end;

function TExifSection.IsExtendable: Boolean;
begin
  Result := InheritsFrom(TExtendableExifSection);
end;

function CompareIDs(Item1, Item2: TExifTag): Integer;
begin
  Result := Item1.ID - Item2.ID;
end;

procedure TExifSection.Load(const Info: TTiffInfo; const Directory: TTiffDirectory);
var
  Rec: TTiffTagInfo;
  NewTag: TExifTag;
begin
  Clear;
  FLoadErrors := Directory.LoadErrors;
  if Directory.Tags <> nil then
    FFirstTagHeaderOffset := Directory.Tags[0].HeaderOffset
  else
    FFirstTagHeaderOffset := 0;
  for Rec in Directory.Tags do
  begin
    NewTag := TExifTag.Create(Self, Info, Rec);
    FTagList.Add(NewTag);
  end;
  FTagList.Sort(@CompareIDs);
  FModified := False;
end;

procedure TExifSection.Load(const Info: TTiffInfo; const Offset: Int64;
  const InternalOffset: Int64 = 0);
begin
  Load(Info, LoadTiffDirectory(Info, Offset, InternalOffset));
end;

function TExifSection.Remove(ID: TExifTagID): Boolean;
var
  Index: Integer;
begin
  Result := FindIndex(ID, Index);
  if Result then DoDelete(Index, True);
end;

procedure TExifSection.Remove(const IDs: array of TExifTagID);
var
  I: Integer;
  ID: TExifTagID;
  Tag: TExifTag;
begin
  if Owner <> nil then Owner.BeginUpdate;
  try
    for I := FTagList.Count - 1 downto 0 do
    begin
      Tag := TExifTag(FTagList.List[I]);
      for ID in IDs do
        if ID = Tag.ID then
        begin
          DoDelete(I, True);
          Break;
        end;
    end;
  finally
    if Owner <> nil then Owner.EndUpdate;
  end;
end;

function TExifSection.RemovePaddingTag: Boolean;
var
  Tag: TExifTag;
begin
  Result := False;
  for Tag in Self do
    if Tag.IsPadding then
    begin
      Tag.Delete;
      Result := True;
      Exit;
    end;
end;

function TExifSection.SetByteValue(TagID: TExifTagID; Index: Integer; Value: Byte): TExifTag;
begin
  Result := ForceSetElement(TagID, tdByte, Index, Value);
end;

procedure TExifSection.SetDateTimeValue(MainID, SubSecsID: TExifTagID; const Value: TDateTime);
var
  SubSecsTag: TExifTag;
begin
  if (Owner = nil) or (SubSecsID = 0) then
    SubSecsTag := nil
  else
    if not Owner[esDetails].Find(SubSecsID, SubSecsTag) then
      if (Value <> 0) and Owner.AlwaysWritePreciseTimes then
        SubSecsTag := Owner[esDetails].Add(SubSecsID, tdAscii, 4)
      else
        SubSecsTag := nil;
  if Value = 0 then
  begin
    Remove(MainID);
    FreeAndNil(SubSecsTag);
  end
  else
  begin
    if Value <> LastSetDateTimeValue then
    begin
      LastSetDateTimeValue := Value;
      LastSetDateTimeMainStr := DateTimeToExifString(Value);
      LastSetDateTimeSubSecStr := GetExifSubSecsString(Value);
    end;
    SetStringValue(MainID, LastSetDateTimeMainStr);
    if SubSecsTag <> nil then
    begin
      SubSecsTag.DataType := tdAscii;
      SubSecsTag.AsString := LastSetDateTimeSubSecStr;
    end;
  end;
end;

procedure TExifSection.DoSetFractionValue(TagID: TExifTagID; Index: Integer;
  DataType: TExifDataType; const Value);
var
  Tag: TExifTag;
begin
  if Int64(Value) = 0 then //prefer deleting over setting null fractions
    if not Find(TagID, Tag) or (Tag.ElementCount <= Index) then
      Exit
    else if Tag.ElementCount = Succ(Index) then
    begin
      if Index = 0 then
        Tag.Delete
      else
        Tag.ElementCount := Index;
      Exit;
    end;
  ForceSetElement(TagID, DataType, Index, Value);
end;

procedure TExifSection.SetFractionValue(TagID: TExifTagID; Index: Integer;
  const Value: TExifFraction);
begin
  DoSetFractionValue(TagID, Index, tdExifFraction, Value);
end;

function TExifSection.SetLongWordValue(TagID: TExifTagID; Index: Integer; Value: LongWord): TExifTag;
begin
  Result := ForceSetElement(TagID, tdLongWord, Index, Value);
end;

procedure TExifSection.SetSignedFractionValue(TagID: TExifTagID; Index: Integer;
  const Value: TExifSignedFraction);
begin
  DoSetFractionValue(TagID, Index, tdExifFraction, Value);
end;

procedure TExifSection.SetStringValue(TagID: TExifTagID; const Value: string);
var
  ElemCount: Integer;
  Tag: TExifTag;
begin
  if Value = '' then
  begin
    Remove(TagID);
    Exit;
  end;
  if EnforceASCII and not ContainsOnlyASCII(Value) then
    raise ENotOnlyASCIIError.Create(STagCanContainOnlyASCII);
  ElemCount := Length(Value) + 1; //ascii tiff tag data includes null terminator
  if not Find(TagID, Tag) then
    Tag := Add(TagID, tdAscii, ElemCount);
  Tag.UpdateData(tdAscii, ElemCount, PAnsiChar(TiffString(Value))^)
end;

procedure TExifSection.SetWindowsStringValue(TagID: TExifTagID; const Value: UnicodeString);
var
  ElemCount: Integer;
  Tag: TExifTag;
begin
  if Value = '' then
  begin
    Remove(TagID);
    Exit;
  end;
  ElemCount := (Length(Value) + 1) * 2; //data includes null terminator
  if not Find(TagID, Tag) then
    Tag := Add(TagID, tdByte, ElemCount);
  Tag.UpdateData(tdByte, ElemCount, PWideChar(Value)^);
end;

function TExifSection.SetWordValue(TagID: TExifTagID; Index: Integer; Value: Word): TExifTag;
begin
  Result := ForceSetElement(TagID, tdWord, Index, Value);
end;

procedure TExifSection.TagChanging(Tag: TExifTag; NewID: TExifTagID;
  NewDataType: TExifDataType; NewElementCount: LongInt; NewData: Boolean);
var
  NewDataSize: Integer;
  OtherTag: TExifTag;
begin
  if (NewID <> Tag.ID) and CheckExtendable.Find(NewID, OtherTag) then //Changing of tag IDs is disallowed in patch
    raise ETagAlreadyExists.CreateFmt(STagAlreadyExists, [NewID]);    //mode to ensure sorting of IFD is preserved.
  NewDataSize := TiffElementSizes[NewDataType] * NewElementCount;
  if (NewDataSize > 4) and (NewDataSize > Tag.OriginalDataSize) then
    CheckExtendable;
  if (FKind = esDetails) and (Tag.ID = ttMakerNote) and (FOwner <> nil) then
    FOwner.ResetMakerNoteType
end;

procedure TExifSection.TagChanged(Tag: TExifTag; ChangeType: TExifTagChangeType);
var
  I: Integer;
begin
  if ChangeType = tcID then
    for I := FTagList.Count - 1 downto 0 do
      if Tag.ID > TExifTag(FTagList.List[I]).ID then
      begin
        FTagList.Move(FTagList.IndexOf(Tag), I + 1);
        Break;
      end;
  Changed;
end;

procedure TExifSection.TagDeleting(Tag: TExifTag);
begin
  DoDelete(FTagList.IndexOf(Tag), False);
end;

function TExifSection.TagExists(ID: TExifTagID; ValidDataTypes: TExifDataTypes;
  MinElementCount: LongInt): Boolean;
var
  Tag: TExifTag;
begin
  Result := Find(ID, Tag) and (Tag.DataType in ValidDataTypes) and
    (Tag.ElementCount >= MinElementCount);
end;

function TExifSection.TryGetByteValue(TagID: TExifTagID; Index: Integer; var Value): Boolean;
var
  Tag: TExifTag;
begin
  Result := Find(TagID, Tag) and (Tag.DataType in [tdByte, tdShortInt, tdUndefined]) and
    (Tag.ElementCount > Index) and (Index >= 0);
  if Result then
    Byte(Value) := PByteArray(Tag.Data)[Index];
end;

function TExifSection.TryGetLongWordValue(TagID: TExifTagID; Index: Integer;
  var Value): Boolean;
var
  Tag: TExifTag;
begin
  Result := Find(TagID, Tag) and (Index < Tag.ElementCount) and (Index >= 0);
  if Result then
    case Tag.DataType of
      tdByte, tdShortInt: LongWord(Value) := PByteArray(Tag.Data)[Index];
      tdWord, tdSmallInt: LongWord(Value) := PWordArray(Tag.Data)[Index];
      tdLongWord, tdLongInt: LongWord(Value) := PLongWordArray(Tag.Data)[Index];
    else Result := False;
    end;
end;

function TExifSection.TryGetStringValue(TagID: TExifTagID; var Value: string): Boolean;
var
  Tag: TExifTag;
  S: AnsiString;
begin
  Result := Find(TagID, Tag) and (Tag.DataType = tdAscii) and (Tag.ElementCount > 0);
  if Result then
  begin
    SetString(S, PAnsiChar(Tag.Data), Tag.ElementCount - 1);
    Value := string(S); //for D2009+ compatibility
  end
end;

function TExifSection.TryGetWindowsStringValue(TagID: TExifTagID; var Value: UnicodeString): Boolean;
var
  Tag: TExifTag;
begin
  Result := Find(TagID, Tag) and (Tag.DataType = tdByte) and (Tag.ElementCount > 1); //should have at least 2 bytes since null terminated
  if Result then
    SetString(Value, PWideChar(Tag.Data), Tag.ElementCount div 2 - 1)
end;

function TExifSection.TryGetWordValue(TagID: TExifTagID; Index: Integer;
  var Value): Boolean;
var
  Tag: TExifTag;
begin
  Result := Find(TagID, Tag) and (Index < Tag.ElementCount) and (Index >= 0);
  if Result then
    case Tag.DataType of
      tdByte, tdShortInt: Word(Value) := PByteArray(Tag.Data)[Index];
      tdWord, tdSmallInt: Word(Value) := PWordArray(Tag.Data)[Index];
    else Result := False;
    end;
end;

{ TExtendableExifSection }

function TExtendableExifSection.Add(ID: TExifTagID; DataType: TExifDataType;
  ElementCount: LongInt): TExifTag;
begin
  Result := inherited Add(ID, DataType, ElementCount);
end;

function TExtendableExifSection.AddOrUpdate(ID: TExifTagID; DataType: TExifDataType;
  ElementCount: Integer): TExifTag;
begin
  if not Find(ID, Result) then
    Result := Add(ID, DataType, ElementCount);
  Result.UpdateData(DataType, ElementCount, Pointer(nil)^);
end;

function TExtendableExifSection.AddOrUpdate(ID: TExifTagID; DataType: TExifDataType;
  ElementCount: Integer; const Data): TExifTag;
begin
  if not Find(ID, Result) then
    Result := Add(ID, DataType, ElementCount);
  Result.UpdateData(DataType, ElementCount, Data);
end;

procedure TExtendableExifSection.Assign(Source: TExifSection);
begin
  if Owner <> nil then Owner.BeginUpdate;
  try
    if Source = nil then
      Clear
    else
    begin
      Clear;
      CopyTags(Source)
    end
  finally
    if Owner <> nil then Owner.EndUpdate;
  end;
end;

procedure TExtendableExifSection.CopyTags(Section: TExifSection);
var
  Tag: TExifTag;
begin
  if Section <> nil then
    for Tag in Section do
      AddOrUpdate(Tag.ID, Tag.DataType, Tag.ElementCount, Tag.Data^)
end;

{ TExifMakerNoteSection }

constructor TExifMakerNoteSection.Create(ASource: TCustomExifData);
var
  Tag: TExifTag;
  TiffInfo: TTiffInfo;
  IFDFromTagDataStart: Integer;
begin
  inherited Create(ASource, esUserDefined);
  if not Owner[esDetails].Find(ttMakerNote, Tag) then Exit;
  if not FormatIsOK(Tag, False) then
    raise EInvalidMakerNoteFormat.Create(SInvalidMakerNoteFormat);
  TiffInfo.Stream := TUserMemoryStream.Create(Tag.Data, Tag.DataSize);
  try
    TiffInfo.BasePosition := -Tag.OriginalDataOffset;
    TiffInfo.Endianness := Owner.Endianness;
    IFDFromTagDataStart := 0;
    GetIFDInfo(Tag, TiffInfo.BasePosition, TiffInfo.Endianness, IFDFromTagDataStart);
    Load(TiffInfo, IFDFromTagDataStart - TiffInfo.BasePosition);
  finally
    TiffInfo.Stream.Free;
  end;
end;

class function TExifMakerNoteSection.FormatIsOK(Source: TCustomExifData;
  AlwaysCheckMakerName: Boolean = True): Boolean;
var
  Tag: TExifTag;
begin
  Result := Source[esDetails].Find(ttMakerNote, Tag) and
    FormatIsOK(Tag, AlwaysCheckMakerName);
end;

procedure TExifMakerNoteSection.GetIFDInfo(SourceTag: TExifTag;
  var TiffStartFromTagDataStart: Int64; var Endianness: TEndianness;
  var IFDFromTagDataStart: Integer);
begin
end;

{ TExifFlashInfo }

constructor TExifFlashInfo.Create(AOwner: TCustomExifData);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TExifFlashInfo.Assign(Source: TPersistent);
begin
  if not (Source is TExifFlashInfo) and (Source <> nil) then
  begin
    inherited;
    Exit;
  end;
  FOwner.BeginUpdate;
  try
    if Source = nil then
    begin
      BitSet := [];
      StrobeEnergy := NullFraction;
    end
    else
    begin
      BitSet := TExifFlashInfo(Source).BitSet;
      StrobeEnergy := TExifFlashInfo(Source).StrobeEnergy;
    end;
  finally
    FOwner.EndUpdate;
  end;
end;

function TExifFlashInfo.MissingOrInvalid: Boolean;
begin
  with FOwner[esDetails] do
    Result := not TagExists(ttFlash, [tdWord, tdSmallInt]) and
      not TagExists(ttFlashEnergy, [tdLongWordFraction, tdLongIntFraction]);
end;

function TExifFlashInfo.GetBitSet: TWordBitSet;
begin
  if not FOwner[esDetails].TryGetWordValue(ttFlash, 0, Result) then
    Result := [];
end;

procedure TExifFlashInfo.SetBitSet(const Value: TWordBitSet);
const
  XMPRoot = 'Flash';
  StrobeLightValues: array[TExifStrobeLight] of Integer = (0, 2, 3);
var
  Root: TXMPProperty;
  ValueAsSource: Integer absolute Value;
begin
  if Value = [] then
  begin
    FOwner[esDetails].Remove(ttFlash);
    FOwner.RemoveXMPProperty(xsExif, XMPRoot);
    Exit;
  end;
  FOwner[esDetails].ForceSetElement(ttFlash, tdWord, 0, Value);
  if FOwner.XMPWritePolicy = xwRemove then
  begin
    FOwner.RemoveXMPProperty(xsExif, XMPRoot);
    Exit;
  end;
  if not FOwner.XMPPacket[xsExif].FindProperty(XMPRoot, Root) then
    if FOwner.XMPWritePolicy = xwUpdateIfExists then
      Exit
    else
      Root := FOwner.XMPPacket[xsExif].AddProperty(XMPRoot);
  Root.Kind := xpStructure;
  Root.UpdateSubProperty('Fired', GetFired(ValueAsSource));
  Root.UpdateSubProperty('Function', not GetPresent(ValueAsSource));
  Root.UpdateSubProperty('Mode', Ord(GetMode(ValueAsSource)));
  Root.UpdateSubProperty('RedEyeMode', GetRedEyeReduction(ValueAsSource));
  Root.UpdateSubProperty('Return', StrobeLightValues[GetStrobeLight(ValueAsSource)]);
end;

function TExifFlashInfo.SourceToValues(Source: Integer): TWordBitSet;
begin
  if Source = -1 then
    Result := BitSet
  else
    Word(Result) := Word(Source);
end;

function TExifFlashInfo.GetFired(Source: Integer): Boolean;
begin
  Result := FiredBit in SourceToValues(Source)
end;

procedure TExifFlashInfo.SetFired(Dummy: Integer; Value: Boolean);
begin
  if Value then
    BitSet := BitSet + [FiredBit]
  else
    BitSet := BitSet - [FiredBit]
end;

function TExifFlashInfo.GetMode(Source: Integer): TExifFlashMode;
var
  Values: TWordBitSet;
begin
  Values := SourceToValues(Source);
  if 4 in Values then
    if 3 in Values then
      Result := efAuto
    else
      Result := efCompulsorySuppression
  else
    if 3 in Values then
      Result := efCompulsoryFire
    else
      Result := efUnknown;
end;

procedure TExifFlashInfo.SetMode(Dummy: Integer; const Value: TExifFlashMode);
var
  Values: TWordBitSet;
begin
  Values := BitSet;
  if Value in [efCompulsorySuppression, efAuto] then
    Include(Values, 4)
  else
    Exclude(Values, 4);
  if Value in [efCompulsoryFire, efAuto] then
    Include(Values, 3)
  else
    Exclude(Values, 3);
  BitSet := Values;
end;

function TExifFlashInfo.GetPresent(Source: Integer): Boolean;
begin
  Result := not (NotPresentBit in SourceToValues(Source));
end;

procedure TExifFlashInfo.SetPresent(Dummy: Integer; Value: Boolean);
begin
  if Value then
    BitSet := BitSet - [NotPresentBit]
  else
    BitSet := BitSet + [NotPresentBit]
end;

function TExifFlashInfo.GetRedEyeReduction(Source: Integer): Boolean;
begin
  Result := RedEyeReductionBit in SourceToValues(Source)
end;

procedure TExifFlashInfo.SetRedEyeReduction(Dummy: Integer; Value: Boolean);
begin
  if Value then
    BitSet := BitSet + [RedEyeReductionBit]
  else
    BitSet := BitSet - [RedEyeReductionBit]
end;

function TExifFlashInfo.GetStrobeLight(Source: Integer): TExifStrobeLight;
var
  Values: TWordBitSet;
begin
  Values := SourceToValues(Source);
  if 2 in Values then
    if 1 in Values then
      Result := esDetected
    else
      Result := esUndetected
  else
    Result := esNoDetectionFunction;
end;

procedure TExifFlashInfo.SetStrobeLight(Dummy: Integer; const Value: TExifStrobeLight);
var
  Values: TWordBitSet;
begin
  Values := BitSet;
  Include(Values, 2);
  case Value of
    esUndetected: Exclude(Values, 1);
    esDetected: Include(Values, 1);
  else
    Exclude(Values, 1);
    Exclude(Values, 2);
  end;
  BitSet := Values;
end;

function TExifFlashInfo.GetStrobeEnergy: TExifFraction;
begin
  Result := FOwner[esDetails].GetFractionValue(ttFlashEnergy, 0);
end;

procedure TExifFlashInfo.SetStrobeEnergy(const Value: TExifFraction);
begin
  FOwner[esDetails].SetFractionValue(ttFlashEnergy, 0, Value);
  FOwner.XMPPacket.UpdateProperty(xsExif, 'FlashEnergy', Value.AsString);
end;

{ TCustomExifVersion }

constructor TCustomExifVersion.Create(AOwner: TCustomExifData);
begin
  inherited Create;
  FOwner := AOwner;
  FMajorIndex := 1;
  FStoreAsChar := True;
  FTiffDataType := tdUndefined;
  Initialize;
end;

procedure TCustomExifVersion.Assign(Source: TPersistent);
begin
  if Source = nil then
    Owner[FSectionKind].Remove(FTagID)
  else if not (Source is TCustomExifVersion) then
    inherited
  else if TCustomExifVersion(Source).MissingOrInvalid then
    Owner[FSectionKind].Remove(FTagID)
  else
  begin
    Major := TCustomExifVersion(Source).Major;
    Minor := TCustomExifVersion(Source).Minor;
  end;
end;

function TCustomExifVersion.MissingOrInvalid: Boolean;
begin
  Result := (Major = 0);
end;

function TCustomExifVersion.GetAsString: string;
begin
  if MissingOrInvalid then
    Result := ''
  else
    FmtStr(Result, '%d%s%d%d', [Major, DecimalSeparator, Minor, Release]);
end;

procedure TCustomExifVersion.SetAsString(const Value: string);
var
  SeekPtr: PChar;

  function GetElement: TExifVersionElement;
  begin
    if SeekPtr^ = #0 then
      Result := 0
    else
    begin
      {$RANGECHECKS ON}
      Result := Ord(SeekPtr^) - Ord('0');
      {$IFDEF RANGECHECKINGOFF}{$RANGECHECKS OFF}{$ENDIF}
      Inc(SeekPtr);
    end;
  end;
begin
  SeekPtr := Pointer(Value); //we *could* cast to a PChar and so be able to remove the
  if SeekPtr = nil then      //next five lines, but doing it this way gets the source
  begin                      //tag removed if the string is empty
    Assign(nil);
    Exit;
  end;
  Major := GetElement;
  if SeekPtr^ <> #0 then
  begin
    Inc(SeekPtr); //skip past separator, whatever that may precisely be
    Minor := GetElement;
    Release := GetElement;
  end
  else
  begin
    Minor := 0;
    Release := 0;
  end;
end;

function TCustomExifVersion.GetValue(Index: Integer): TExifVersionElement;
var
  RawValue: Byte;
begin
  if not Owner[FSectionKind].TryGetByteValue(FTagID, Index, RawValue) then
    Result := 0
  else if RawValue >= Ord('0') then
    Result := RawValue - Ord('0')
  else
    Result := RawValue;
end;

procedure TCustomExifVersion.SetValue(Index: Integer; Value: TExifVersionElement);
var
  RawValue: Byte;
begin
  RawValue := Value;
  if FStoreAsChar then Inc(RawValue, Ord('0'));
  Owner[FSectionKind].ForceSetElement(FTagID, FTiffDataType, Index, RawValue);
end;

function TCustomExifVersion.GetMajor: TExifVersionElement;
begin
  Result := GetValue(FMajorIndex);
end;

function TCustomExifVersion.GetMinor: TExifVersionElement;
begin
  Result := GetValue(FMajorIndex + 1);
end;

function TCustomExifVersion.GetRelease: TExifVersionElement;
begin
  Result := GetValue(FMajorIndex + 2);
end;

procedure TCustomExifVersion.SetMajor(Value: TExifVersionElement);
begin
  SetValue(FMajorIndex, Value);
end;

procedure TCustomExifVersion.SetMinor(Value: TExifVersionElement);
begin
  SetValue(FMajorIndex + 1, Value);
end;

procedure TCustomExifVersion.SetRelease(Value: TExifVersionElement);
begin
  SetValue(FMajorIndex + 2, Value);
end;

{ TExifVersion }

procedure TExifVersion.Initialize;
begin
  FSectionKind := esDetails;
  FTagID := ttExifVersion;
end;

{ TFlashPixVersion }

procedure TFlashPixVersion.Initialize;
begin
  FSectionKind := esDetails;
  FTagID := ttFlashPixVersion;
end;

{ TGPSVersion }

procedure TGPSVersion.Initialize;
begin
  FMajorIndex := 0;
  FSectionKind := esGPS;
  FStoreAsChar := False;
  FTagID := ttGPSVersionID;
  FTiffDataType := tdByte;
end;

{ TInteropVersion }

procedure TInteropVersion.Initialize;
begin
  FSectionKind := esInterop;
  FTagID := ttInteropVersion;
end;

{ TCustomExifResolution }

constructor TCustomExifResolution.Create(AOwner: TCustomExifData);
var
  SectionKind: TExifSectionKind;
begin
  inherited Create;
  FOwner := AOwner;
  FXTagID := ttXResolution;
  FYTagID := ttYResolution;
  FUnitTagID := ttResolutionUnit;
  GetTagInfo(SectionKind, FXTagID, FYTagID, FUnitTagID, FSchema, FXName, FYName, FUnitName);
  FSection := AOwner[SectionKind];
end;

procedure TCustomExifResolution.Assign(Source: TPersistent);
begin
  if not (Source is TCustomExifResolution) and (Source <> nil) then
  begin
    inherited;
    Exit;
  end;
  FOwner.BeginUpdate;
  try
    if (Source = nil) or TCustomExifResolution(Source).MissingOrInvalid then
    begin
      Section.Remove(FXTagID);
      Section.Remove(FYTagID);
      Section.Remove(FUnitTagID);
      if FSchema <> xsUnknown then 
        FOwner.RemoveXMPProperty(FSchema, [FXName, FYName, FUnitName]);
    end
    else
    begin
      X := TCustomExifResolution(Source).X;
      Y := TCustomExifResolution(Source).Y;
      Units := TCustomExifResolution(Source).Units;
    end;
  finally
    FOwner.EndUpdate;
  end;
end;

function TCustomExifResolution.GetUnit: TExifResolutionUnit;
begin
  if not Section.TryGetWordValue(FUnitTagID, 0, Result) then
    Result := trNone;
end;

function TCustomExifResolution.GetX: TExifFraction;
begin
  Result := Section.GetFractionValue(FXTagID, 0);
end;

function TCustomExifResolution.GetY: TExifFraction;
begin
  Result := Section.GetFractionValue(FYTagID, 0);
end;

function TCustomExifResolution.MissingOrInvalid: Boolean;
begin
  Result := not Section.TagExists(FXTagID, [tdLongWordFraction, tdLongWordFraction]) or
    not Section.TagExists(FYTagID, [tdLongWordFraction, tdLongWordFraction]);
end;

procedure TCustomExifResolution.SetUnit(const Value: TExifResolutionUnit);
begin
  Section.SetWordValue(FUnitTagID, 0, Ord(Value));
  if FSchema <> xsUnknown then
    if Value = trNone then 
      FOwner.RemoveXMPProperty(FSchema, FUnitName)
    else
      FOwner.XMPPacket.UpdateProperty(FSchema, FUnitName, Integer(Value));
end;

procedure TCustomExifResolution.SetX(const Value: TExifFraction);
begin
  Section.SetFractionValue(FXTagID, 0, Value);
  if FSchema <> xsUnknown then
    FOwner.XMPPacket.UpdateProperty(FSchema, FXName, Value.AsString);
end;

procedure TCustomExifResolution.SetY(const Value: TExifFraction);
begin
  Section.SetFractionValue(FYTagID, 0, Value);
  if FSchema <> xsUnknown then
    FOwner.XMPPacket.UpdateProperty(FSchema, FYName, Value.AsString);
end;

{ TImageResolution }

procedure TImageResolution.GetTagInfo(var Section: TExifSectionKind; var XTag, YTag,
  UnitTag: TExifTagID; var Schema: TXMPSchemaKind; var XName, YName, UnitName: string);
begin
  Section := esGeneral;
  Schema := xsTIFF;
  XName := 'XResolution';
  YName := 'YResolution';
  UnitName := 'ResolutionUnit';
end;

{ TFocalPlaneResolution }

procedure TFocalPlaneResolution.GetTagInfo(var Section: TExifSectionKind; var XTag,
  YTag, UnitTag: TExifTagID; var Schema: TXMPSchemaKind; var XName, YName,
  UnitName: string);
begin
  Section := esDetails;
  XTag := ttFocalPlaneXResolution;
  YTag := ttFocalPlaneYResolution;
  UnitTag := ttFocalPlaneResolutionUnit;
  Schema := xsExif;
  XName := 'FocalPlaneXResolution';
  YName := 'FocalPlaneYResolution';
  UnitName := 'FocalPlaneResolutionUnit';
end;

{ TThumbnailResolution }

procedure TThumbnailResolution.GetTagInfo(var Section: TExifSectionKind; var XTag, YTag,
  UnitTag: TExifTagID; var Schema: TXMPSchemaKind; var XName, YName, UnitName: string);
begin
  Section := esThumbnail;
end;

{ TISOSpeedRatings }

constructor TISOSpeedRatings.Create(AOwner: TCustomExifData);
begin
  FOwner := AOwner;
end;

procedure TISOSpeedRatings.Assign(Source: TPersistent);
var
  SourceTag, DestTag: TExifTag;
begin
  if Source = nil then
    Clear
  else if Source is TISOSpeedRatings then
  begin
    if not TISOSpeedRatings(Source).FindTag(True, SourceTag) then
      Clear
    else
    begin
      if FindTag(False, DestTag) then
        DestTag.UpdateData(tdWord, SourceTag.ElementCount, PWord(SourceTag.Data)^)
      else
      begin
        DestTag := FOwner[esDetails].Add(ttISOSpeedRatings, tdWord, SourceTag.ElementCount);
        Move(PWord(SourceTag.Data)^, DestTag.Data^, SourceTag.DataSize);
      end;
      FOwner.XMPPacket.UpdateProperty(XMPSchema, XMPName, XMPKind, DestTag.AsString);
    end;
  end
  else
    inherited;
end;

procedure TISOSpeedRatings.Clear;
begin
  FOwner[esDetails].Remove(ttISOSpeedRatings);
  FOwner.XMPPacket.RemoveProperty(XMPSchema, XMPName);
end;

function TISOSpeedRatings.FindTag(VerifyDataType: Boolean; out Tag: TExifTag): Boolean;
begin
  Result := FOwner[esDetails].Find(ttISOSpeedRatings, Tag);
  if Result and VerifyDataType and not (Tag.DataType in [tdWord, tdShortInt]) then
  begin
    Tag := nil;
    Result := False;
  end;
end;

function TISOSpeedRatings.GetAsString: string;
var
  Tag: TExifTag;
begin
  if FindTag(True, Tag) then
    Result := Tag.AsString
  else
    Result := '';
end;

function TISOSpeedRatings.GetCount: Integer;
var
  Tag: TExifTag;
begin
  if FindTag(True, Tag) then
    Result := Tag.ElementCount
  else
    Result := 0;
end;

function TISOSpeedRatings.GetItem(Index: Integer): Word;
var
  Tag: TExifTag;
begin
  if FindTag(True, Tag) and (Index < Tag.ElementCount) and (Index >= 0) then
    Result := PWordArray(Tag.Data)[Index]
  else
    Result := 0;
end;

function TISOSpeedRatings.MissingOrInvalid: Boolean;
var
  Tag: TExifTag;
begin
  Result := not FindTag(True, Tag);
end;

procedure TISOSpeedRatings.SetAsString(const Value: string);
var
  Tag: TExifTag;
begin
  if Value = '' then
  begin
    Assign(nil);
    Exit;
  end;
  if not FindTag(False, Tag) then
    Tag := FOwner[esDetails].Add(ttISOSpeedRatings, tdWord, 0);
  Tag.AsString := Value;
  FOwner.XMPPacket.UpdateProperty(XMPSchema, XMPName, XMPKind, Value);
end;

procedure TISOSpeedRatings.SetCount(const Value: Integer);
var
  Tag: TExifTag;
begin
  if Value <= 0 then
    Clear
  else if FindTag(False, Tag) then
    Tag.ElementCount := Value
  else
    FOwner[esDetails].Add(ttISOSpeedRatings, tdWord, Value);
end;

procedure TISOSpeedRatings.SetItem(Index: Integer; const Value: Word);
  procedure WriteXMP;
  begin
    with FOwner.XMPPacket[XMPSchema][XMPName] do
    begin
      Kind := XMPKind;
      Count := Max(Count, Succ(Index));
      SubProperties[Index].WriteValue(Value);
    end;
  end;
var
  Tag: TExifTag;
  Schema: TXMPSchema;
  Prop: TXMPProperty;
begin
  if not FindTag(True, Tag) or (Index >= Tag.ElementCount) then
    raise EListError.CreateFmt(SListIndexError, [Index]);
  FOwner[esDetails].ForceSetElement(ttISOSpeedRatings, tdWord, Index, Value);
  case FOwner.XMPWritePolicy of
    xwRemove: FOwner.XMPPacket.RemoveProperty(XMPSchema, XMPName);
    xwAlwaysUpdate: if FOwner.XMPPacket.FindSchema(XMPSchema, Schema) and
      Schema.FindProperty(XMPName, Prop) then WriteXMP;
  else WriteXMP;
  end
end;

{ TGPSCoordinate }

constructor TGPSCoordinate.Create(AOwner: TCustomExifData; ATagID: TExifTagID);
begin
  FOwner := AOwner;
  FRefTagID := Pred(ATagID);
  FTagID := ATagID;
  FXMPName := GetGPSTagXMPName(ATagID)
end;

procedure TGPSCoordinate.Assign(Source: TPersistent);
var
  SourceAsCoord: TGPSCoordinate absolute Source;
  SourceTag, DestTag: TExifTag;
begin
  if (Source <> nil) and not (Source is ClassType) then
  begin
    inherited;
    Exit;
  end;
  if (Source = nil) or not SourceAsCoord.Owner[esGPS].Find(FTagID, SourceTag) then
  begin
    FOwner[esGPS].Remove([FTagID, Pred(FTagID)]);
    FOwner.XMPPacket.RemoveProperty(xsExif, XMPName);
    Exit;
  end;
  FOwner.BeginUpdate;
  try
    if not FOwner[esGPS].Find(FTagID, DestTag) then
      DestTag := FOwner[esGPS].Add(FTagID, SourceTag.DataType, SourceTag.ElementCount);
    DestTag.Assign(SourceTag);
    Direction := SourceAsCoord.Direction;
  finally
    FOwner.EndUpdate;
  end;
end;

procedure TGPSCoordinate.Assign(const ADegrees, AMinutes, ASeconds: TExifFraction;
  ADirectionChar: AnsiChar);
var
  NewElemCount: Integer;
  Tag: TExifTag;
begin
  if ASeconds.MissingOrInvalid then NewElemCount := 2 else NewElemCount := 3;
  if FOwner[esGPS].Find(FTagID, Tag) then
    Tag.UpdateData(tdLongWordFraction, NewElemCount, PByte(nil)^)
  else
    Tag := FOwner[esGPS].Add(FTagID, tdLongWordFraction, NewElemCount);
  PExifFractionArray(Tag.Data)[0] := ADegrees;
  PExifFractionArray(Tag.Data)[1] := AMinutes;
  if NewElemCount > 2 then PExifFractionArray(Tag.Data)[2] := ASeconds;
  Tag.Changed;
  Direction := ADirectionChar;
end;

function TGPSCoordinate.MissingOrInvalid: Boolean;
var
  Mins, Degs: TExifFraction; //needed for D2006 compatibility - the D2006 compiler is buggy as hell with record methods
begin
  Mins := Minutes; Degs := Degrees;
  Result := Mins.MissingOrInvalid or Degs.MissingOrInvalid or (Direction = #0);
end;

function TGPSCoordinate.GetAsString: string;
var
  Direction: string;
  Degrees, Minutes, Seconds: TExifFraction;
begin
  Degrees := Self.Degrees;
  Minutes := Self.Minutes;
  Seconds := Self.Seconds;
  if Degrees.MissingOrInvalid or Minutes.MissingOrInvalid then
  begin
    Result := '';
    Exit;
  end;
  Direction := FOwner[esGPS].GetStringValue(RefTagID);
  if Seconds.MissingOrInvalid then
    FmtStr(Result, '%s,%g%s', [Degrees.AsString, Minutes.Quotient, Direction])
  else //if we do *exactly* what the XMP spec says, the value won't be round-trippable...
    FmtStr(Result, '%s,%s,%s%s', [Degrees.AsString, Minutes.AsString, Seconds.AsString, Direction]);
end;

function TGPSCoordinate.GetDirectionChar: AnsiChar;
var
  Tag: TExifTag;
begin
  if FOwner[esGPS].Find(RefTagID, Tag) and (Tag.DataType = tdAscii) and (Tag.ElementCount >= 2) then
    Result := UpCase(PAnsiChar(Tag.Data)^)
  else
    Result := #0;
end;

procedure TGPSCoordinate.SetDirectionChar(NewChar: AnsiChar);
var
  ValueAsString, XMPValue: string;
  I: Integer;
begin
  if NewChar = #0 then 
  begin
    FOwner[esGPS].Remove(RefTagID);
    FOwner.XMPPacket.RemoveProperty(xsExif, XMPName);
    Exit;
  end;
  ValueAsString := string(UpCase(NewChar));
  XMPValue := AsString;
  FOwner[esGPS].SetStringValue(RefTagID, ValueAsString);
  for I := Length(XMPValue) downto 1 do
    if not (AnsiChar(XMPValue[I]) in (['A'..'Z', 'a'..'z'])) then
    begin
      XMPValue := Copy(XMPValue, 1, I) + ValueAsString;
      FOwner.XMPPacket.UpdateProperty(xsExif, XMPName, XMPValue);
      Break;
    end; 
end;

function TGPSCoordinate.GetValue(Index: Integer): TExifFraction;
begin
  Result := FOwner[esGPS].GetFractionValue(TagID, Index);
end;

{ TGPSLatitude }

procedure TGPSLatitude.Assign(const ADegrees, AMinutes, ASeconds: TExifFraction;
  ADirection: TGPSLatitudeRef);
const
  DirectionChars: array[TGPSLatitudeRef] of AnsiChar = (#0, 'N', 'S');
begin
  Assign(ADegrees, AMinutes, ASeconds, DirectionChars[ADirection]);
end;

procedure TGPSLatitude.Assign(ADegrees, AMinutes, ASeconds: LongWord;
  ADirection: TGPSLatitudeRef);
begin
  Assign(TExifFraction.Create(ADegrees), TExifFraction.Create(AMinutes),
    TExifFraction.Create(ASeconds), ADirection);
end;

function TGPSLatitude.GetDirection: TGPSLatitudeRef;
begin
  case inherited Direction of
    'N': Result := ltNorth;
    'S': Result := ltSouth;
  else Result := ltMissingOrInvalid;
  end;
end;

{ TGPSLongitude }

procedure TGPSLongitude.Assign(const ADegrees, AMinutes, ASeconds: TExifFraction;
  ADirection: TGPSLongitudeRef);
const
  DirectionChars: array[TGPSLongitudeRef] of AnsiChar = (#0, 'W', 'E');
begin
  Assign(ADegrees, AMinutes, ASeconds, DirectionChars[ADirection]);
end;

procedure TGPSLongitude.Assign(ADegrees, AMinutes, ASeconds: LongWord;
  ADirection: TGPSLongitudeRef);
begin
  Assign(TExifFraction.Create(ADegrees), TExifFraction.Create(AMinutes),
    TExifFraction.Create(ASeconds), ADirection);
end;

function TGPSLongitude.GetDirection: TGPSLongitudeRef;
begin
  case inherited Direction of
    'W': Result := lnWest;
    'E': Result := lnEast;
  else Result := lnMissingOrInvalid;
  end;
end;

{ TCustomExifData.TEnumerator }

constructor TCustomExifData.TEnumerator.Create(AClient: TCustomExifData);
begin
  FClient := AClient;
  FDoneFirst := False;
  FSection := Low(TExifSectionKind);
end;

function TCustomExifData.TEnumerator.GetCurrent: TExifSection;
begin
  Result := FClient[FSection];
end;

function TCustomExifData.TEnumerator.MoveNext: Boolean;
begin
  Result := False;
  repeat
    if not FDoneFirst then
      FDoneFirst := True
    else
    begin
      if FSection = High(TExifSectionKind) then Exit;
      Inc(FSection);
    end;
  until (FClient[FSection].Count > 0);
  Result := True;
end;

{ TCustomExifData }

type
  TContainedXMPPacket = class(TXMPPacket);

constructor TCustomExifData.Create;
var
  Kind: TExifSectionKind;
begin
  inherited Create;
  FEnforceASCII := True;
  FExifVersion := TExifVersion.Create(Self);
  FFlashPixVersion := TFlashPixVersion.Create(Self);
  FGPSVersion := TGPSVersion.Create(Self);
  FGPSLatitude := TGPSLatitude.Create(Self, ttGPSLatitude);
  FGPSLongitude := TGPSLongitude.Create(Self, ttGPSLongitude);
  FGPSDestLatitude := TGPSLatitude.Create(Self, ttGPSDestLatitude);
  FGPSDestLongitude := TGPSLongitude.Create(Self, ttGPSDestLongitude);
  for Kind := Low(TExifSectionKind) to High(TExifSectionKind) do
    FSections[Kind] := SectionClass.Create(Self, Kind);
  FFlash := TExifFlashInfo.Create(Self);
  FFocalPlaneResolution := TFocalPlaneResolution.Create(Self);
  FInteropVersion := TInteropVersion.Create(Self);
  FISOSpeedRatings := TISOSpeedRatings.Create(Self);
  FResolution := TImageResolution.Create(Self);
  FThumbnailResolution := TThumbnailResolution.Create(Self);
  FXMPPacketValue := TContainedXMPPacket.Create;
  ResetMakerNoteType;
  SetXMPWritePolicy(xwUpdateIfExists);
end;

destructor TCustomExifData.Destroy;
var
  Section: TExifSectionKind;
begin
  FUpdateCount := 1000;
  FreeAndNil(FMakerNoteValue);
  FThumbnailResolution.Free;
  FResolution.Free;
  FISOSpeedRatings.Free;
  FInteropVersion.Free;
  FGPSDestLongitude.Free;
  FGPSDestLatitude.Free;
  FGPSLongitude.Free;
  FGPSLatitude.Free;
  FGPSVersion.Free;
  FFocalPlaneResolution.Free;
  FFlash.Free;
  FFlashPixVersion.Free;
  FExifVersion.Free;
  for Section := Low(TExifSectionKind) to High(TExifSectionKind) do
    FSections[Section].Free;
  FXMPPacketValue.Free;
  inherited;
end;

class function TCustomExifData.SectionClass: TExifSectionClass;
begin
  Result := TExifSection;
end;

class procedure TCustomExifData.RegisterMakerNoteType(AClass: TExifMakerNoteClass;
  Priority: TMakerNoteTypePriority);
begin
  if (AClass <> nil) and (FMakerNoteClasses.IndexOf(AClass) < 0) then
    case Priority of
      mtTestForLast: FMakerNoteClasses.Insert(0, AClass);
      mtTestForFirst: FMakerNoteClasses.Add(AClass);
    end;
end;

class procedure TCustomExifData.RegisterMakerNoteTypes(
  const AClasses: array of TExifMakerNoteClass; Priority: TMakerNoteTypePriority);
var
  LClass: TExifMakerNoteClass;
begin
  for LClass in AClasses do
    RegisterMakerNoteType(LClass, Priority);
end;

class procedure TCustomExifData.UnregisterMakerNoteType(AClass: TExifMakerNoteClass);
begin
  FMakerNoteClasses.Remove(AClass)
end;

procedure TCustomExifData.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TCustomExifData.EndUpdate;
begin
  Dec(FUpdateCount);
  if (FUpdateCount = 0) and FChangedWhileUpdating then
  begin
    FChangedWhileUpdating := False;
    Changed(nil);
  end;
end;

function TCustomExifData.GetUpdating: Boolean;
begin
  Result := (FUpdateCount > 0);
end;

procedure TCustomExifData.Changed(Section: TExifSection);
begin
  if FUpdateCount > 0 then
    FChangedWhileUpdating := True
  else
  begin
    FModified := True;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TCustomExifData.Clear(XMPPacketToo: Boolean = True);
var
  Section: TExifSection;
begin
  BeginUpdate;
  try
    ResetMakerNoteType;
    for Section in Self do
      Section.Clear;
    if XMPPacketToo then
    begin
      FXMPSegmentToLoad := nil;
      FXMPPacketValue.Clear;
    end;
  finally
    EndUpdate;
  end;
end;

function TCustomExifData.GetEmpty: Boolean;
var
  Section: TExifSectionKind;
begin
  Result := False;
  for Section := Low(Section) to High(Section) do
    if FSections[Section].Count > 0 then Exit;
  Result := True;
end;

function TCustomExifData.GetEnumerator: TEnumerator;
begin
  Result := TEnumerator.Create(Self);
end;

function TCustomExifData.GetMakerNote: TExifMakerNote;
begin
  if FMakerNoteValue = nil then
  begin
    BeginUpdate;
    try
      FMakerNoteValue := FMakerNoteType.Create(FSections[esMakerNote]);
    finally
      EndUpdate;
    end;
  end;
  Result := FMakerNoteValue;
end;

function TCustomExifData.GetSection(Section: TExifSectionKind): TExifSection;
begin
  Result := FSections[Section];
  if (Section = esMakerNote) and (FMakerNoteType <> TUnrecognizedMakerNote) then
    GetMakerNote; //MakerNote tags are lazy-loaded
end;

function TCustomExifData.HasMakerNote: Boolean;
begin
  Result := FSections[esDetails].TagExists(ttMakerNote)
end;

function TCustomExifData.FindThumbnailOffset(SourceStream: TStream;
  var Offset: LongInt): Boolean;
var
  Buffer: array[0..9] of Word;
  OrigPos: Int64;
  Tag: TExifTag;
begin
  Result := FSections[esThumbnail].Find(ttThumbnailOffset, Tag) and
    (Tag.DataType in [tdLongWord, tdLongInt, tdSubDirectory]) and
    (Tag.ElementCount = 1);
  if Result then
  begin
    Offset := PLongInt(Tag.Data)^;
    if SourceStream = nil then Exit;
    OrigPos := SourceStream.Position;
    SourceStream.Seek(OffsetBase + Offset, soBeginning);
    if (SourceStream.Read(Buffer, SizeOf(Buffer)) <> SizeOf(Buffer)) or
       (Buffer[0] <> JpegFileHeader) then Result := False;
    SourceStream.Position := OrigPos;
  end;
end;

function TCustomExifData.LoadFromJPEG(JPEGStream: TStream): Boolean;
var
  Segment: IFoundJPEGSegment;
begin
  Result := False;
  FMetadataInSource := [];
  FXMPSegmentPosition := 0;
  FXMPPacketSizeInSource := 0;
  BeginUpdate;
  try
    Clear;
    for Segment in JPEGHeader(JPEGStream, [jmApp1]) do
      if not (mkExif in MetadataInSource) and StreamHasExifHeader(Segment.Data) then
      begin
        Include(FMetadataInSource, mkExif);
        LoadFromStream(Segment.Data);
        Inc(FOffsetBase, Segment.OffsetOfData);
        Result := True;
      end
      else if not (mkXMP in MetadataInSource) and StreamHasXMPSegmentHeader(Segment.Data) then
      begin
        Include(FMetadataInSource, mkXMP);
        FXMPSegmentPosition := Segment.Offset;
        FXMPPacketSizeInSource := Segment.Data.Size;
        FXMPSegmentToLoad := Segment;
      end;
  finally
    FChangedWhileUpdating := False;
    EndUpdate;
    Modified := False;
  end;
end;

procedure TCustomExifData.LoadFromStream(Stream: TStream);
var
  Info: TTiffInfo;

  procedure LoadSubDir(SourceSection: TExifSectionKind; TagID: TExifTagID;
    DestSection: TExifSectionKind);
  var
    Tag: TExifTag;
  begin
    if FSections[SourceSection].Find(TagID, Tag) and (Tag.ElementCount = 1) and
        (Tag.DataType in [tdLongWord, tdLongInt, tdSubDirectory]) then
      FSections[DestSection].Load(Info, PLongInt(Tag.Data)^);
  end;
var
  MakerNoteTag: TExifTag;
  I: Integer;
begin
  BeginUpdate;
  try
    Clear(False);
    if not StreamHasExifHeader(Stream, hcMovePositionOnSuccess) then
      raise EInvalidExifData.Create(SNoExifHeaderFound);
    LoadTiffInfo(Stream, Info);
    FOffsetBase := Info.BasePosition;
    FEndianness := Info.Endianness;
    if Info.Directories <> nil then
    begin
      FSections[esGeneral].Load(Info, Info.Directories[0]);
      LoadSubDir(esGeneral, ttExifOffset, esDetails);
      LoadSubDir(esGeneral, ttGPSOffset, esGPS);
      LoadSubDir(esDetails, ttInteropOffset, esInterop);
      if Length(Info.Directories) >= 2 then
        FSections[esThumbnail].Load(Info, Info.Directories[1]);
      if FSections[esDetails].Find(ttMakerNote, MakerNoteTag) then
        for I := FMakerNoteClasses.Count - 1 downto 0 do
        begin
          if TExifMakerNoteClass(FMakerNoteClasses.List[I]).FormatIsOK(MakerNoteTag) then
          begin
            FMakerNoteType := FMakerNoteClasses.List[I];
            Break;
          end;
        end;
    end;
  finally
    FChangedWhileUpdating := False;
    EndUpdate;
    Modified := False;
  end;
end;

procedure TCustomExifData.Rewrite;
begin
  BeginUpdate;
  try
    CameraMake := CameraMake;
    CameraModel := CameraModel;
    Copyright := Copyright;
    DateTime := DateTime;
    ImageDescription := ImageDescription;
    Orientation := Orientation;
    Resolution := Resolution;
    Software := Software;
    Author := Author;
    Comments := Comments;
    Keywords := Keywords;
    Subject := Subject;
    Title := Title;
    UserRating := UserRating;
    ApertureValue := ApertureValue;
    BrightnessValue := BrightnessValue;
    ColorSpace := ColorSpace;
    Contrast := Contrast;
    CompressedBitsPerPixel := CompressedBitsPerPixel;
    DateTimeOriginal := DateTimeOriginal;
    DateTimeDigitized := DateTimeDigitized;
    DigitalZoomRatio := DigitalZoomRatio;
    ExifVersion := ExifVersion;
    ExifImageWidth := ExifImageWidth;
    ExifImageHeight := ExifImageHeight;
    ExposureBiasValue := ExposureBiasValue;
    ExposureIndex := ExposureIndex;
    ExposureMode := ExposureMode;
    ExposureProgram := ExposureProgram;
    ExposureTime := ExposureTime;
    FileSource := FileSource;
    Flash := Flash;
    FlashPixVersion := FlashPixVersion;
    FNumber := FNumber;
    FocalLength := FocalLength;
    FocalLengthIn35mmFilm := FocalLengthIn35mmFilm;
    FocalPlaneResolution := FocalPlaneResolution;
    GainControl := GainControl;
    ImageUniqueID := ImageUniqueID;
    ISOSpeedRatings := ISOSpeedRatings;
    LightSource := LightSource;
    MaxApertureValue := MaxApertureValue;
    MeteringMode := MeteringMode;
    RelatedSoundFile := RelatedSoundFile;
    Rendering := Rendering;
    Saturation := Saturation;
    SceneCaptureType := SceneCaptureType;
    SceneType := SceneType;
    SensingMethod := SensingMethod;
    Sharpness := Sharpness;
    ShutterSpeedValue := ShutterSpeedValue;
    SpectralSensitivity := SpectralSensitivity;
    SubjectDistance := SubjectDistance;
    SubjectDistanceRange := SubjectDistanceRange;
    SubjectLocation := SubjectLocation;
    GPSVersion := GPSVersion;
    GPSLatitude := GPSLatitude;
    GPSLongitude := GPSLongitude;
    GPSAltitudeRef := GPSAltitudeRef;
    GPSAltitude := GPSAltitude;
    GPSSatellites := GPSSatellites;
    GPSStatus := GPSStatus;
    GPSMeasureMode := GPSMeasureMode;
    GPSDOP := GPSDOP;
    GPSSpeedRef := GPSSpeedRef;
    GPSSpeed := GPSSpeed;
    GPSTrackRef := GPSTrackRef;
    GPSTrack := GPSTrack;
    GPSImgDirectionRef := GPSImgDirectionRef;
    GPSImgDirection := GPSImgDirection;
    GPSMapDatum := GPSMapDatum;
    GPSDestLatitude := GPSDestLatitude;
    GPSDestLongitude := GPSDestLongitude;
    GPSDestBearingRef := GPSDestBearingRef;
    GPSDestBearing := GPSDestBearing;
    GPSDestDistanceRef := GPSDestDistanceRef;
    GPSDestDistance := GPSDestDistance;
    GPSDifferential := GPSDifferential;
    GPSDateTimeUTC := GPSDateTimeUTC;
    ThumbnailOrientation := ThumbnailOrientation;
    ThumbnailResolution := ThumbnailResolution;
  finally
    EndUpdate;
  end;
end;

procedure TCustomExifData.SetAllDateTimeValues(const NewValue: TDateTime);
begin
  BeginUpdate;
  try
    DateTime := NewValue;
    DateTimeOriginal := NewValue;
    DateTimeDigitized := NewValue;
  finally
    EndUpdate;
  end;
end;

procedure TCustomExifData.SetEndianness(Value: TEndianness);
begin
  if Value = FEndianness then Exit;
  FEndianness := Value;
  Changed(nil);
end;

procedure TCustomExifData.ResetMakerNoteType;
begin
  FMakerNoteType := TUnrecognizedMakerNote;
  FreeAndNil(FMakerNoteValue);
end;

procedure TCustomExifData.SetModified(const Value: Boolean);
begin
  if Value then
    Changed(nil)
  else
    FModified := Value;
end;

function TCustomExifData.ShutterSpeedInMSecs: Extended;
var
  Apex: TExifSignedFraction;
begin
  Apex := ShutterSpeedValue;
  if Apex.MissingOrInvalid then
    Result := 0
  else
    Result := (1 / Power(2, Apex.Quotient)) * 1000;
end;

procedure TCustomExifData.RemoveXMPProperty(Schema: TXMPSchemaKind; const PropName: string);
begin
  RemoveXMPProperty(Schema, [PropName]);
end;

procedure TCustomExifData.RemoveXMPProperty(Schema: TXMPSchemaKind;
  const PropNames: array of string);
begin //idea is that an invalid XMP packet only causes an exception if the user explicitly attempts to read it
  if FXMPSegmentToLoad <> nil then
    if FXMPPacketValue.TryLoadFromStream(FXMPSegmentToLoad.Data) then
      FXMPSegmentToLoad := nil
    else
      Exit;
  FXMPPacketValue.RemoveProperty(Schema, PropNames);
end;

function TCustomExifData.GetXMPPacket: TXMPPacket;
var
  Segment: IFoundJPEGSegment;
begin
  if FXMPSegmentToLoad <> nil then
  begin
    Segment := FXMPSegmentToLoad;
    FXMPSegmentToLoad := nil;
    FXMPPacketValue.LoadFromStream(Segment.Data);
  end;
  Result := FXMPPacketValue;
end;

function TCustomExifData.GetXMPWritePolicy: TXMPWritePolicy;
begin
  Result := TContainedXMPPacket(FXMPPacketValue).UpdatePolicy;
end;

procedure TCustomExifData.SetXMPWritePolicy(Value: TXMPWritePolicy);
begin
  TContainedXMPPacket(FXMPPacketValue).UpdatePolicy := Value;
end;

{ TCustomExifData - tag getters }

function TCustomExifData.GetAuthor: UnicodeString;
begin
  Result := GetGeneralWinString(ttWindowsAuthor);
  if Result = '' then
    Result := GetGeneralString(ttArtist);
end;

function TCustomExifData.GetColorSpace: TExifColorSpace;
begin
  if not FSections[esDetails].TryGetWordValue(ttColorSpace, 0, Result) then
    Result := csTagMissing;
end;

type
  TExifUserCommentID = array[1..8] of AnsiChar;

const
  UCID_ASCI: TExifUserCommentID = 'ASCII'#0#0#0;
  UCID_Kanji: TExifUserCommentID = 'JIS'#0#0#0#0#0;
  UCID_Unicode: TExifUserCommentID = 'UNICODE'#0;

function TCustomExifData.GetComments: UnicodeString;
const
  IDSize = SizeOf(TExifUserCommentID);
var
  Tag: TExifTag;
  StrStart: PAnsiChar;
  StrByteLen: Integer;
  TiffStr: TiffString;
begin
  Result := GetGeneralWinString(ttWindowsComments);
  if (Result = '') and FSections[esDetails].Find(ttUserComment, Tag) and
     (Tag.DataType in [tdByte, tdUndefined]) and (Tag.ElementCount > 9) then
  begin
    StrStart := @PAnsiChar(Tag.Data)[IDSize];
    StrByteLen := Tag.ElementCount - IDSize;
    while (StrByteLen > 0) and (StrStart[StrByteLen - 1] in [#0..' ']) do
      Dec(StrByteLen);
    if CompareMem(Tag.Data, @UCID_Unicode, IDSize) then
      SetString(Result, PWideChar(StrStart), StrByteLen div 2)
    else if CompareMem(Tag.Data, @UCID_ASCI, IDSize) then
    begin
      SetString(TiffStr, StrStart, StrByteLen);
      Result := UnicodeString(TiffStr);
    end;
  end;
end;

function TCustomExifData.GetContrast: TExifContrast;
begin
  if not FSections[esDetails].TryGetWordValue(ttContrast, 0, Result) then
    Result := cnTagMissing;
end;

procedure TCustomExifData.SetContrast(Value: TExifContrast);
begin
  SetDetailsWordEnum(ttContrast, 'Contrast', Value);
end;

function TCustomExifData.GetDetailsDateTime(TagID: Integer): TDateTime;
var
  SubSecsID: TExifTagID;
begin
  case TagID of
    ttDateTimeOriginal: SubSecsID := ttSubsecTimeOriginal;
    ttDateTimeDigitized: SubSecsID := ttSubsecTimeDigitized;
  else SubSecsID := 0;
  end;
  Result := FSections[esDetails].GetDateTimeValue(TagID, SubSecsID);
end;

function TCustomExifData.GetDetailsFraction(TagID: Integer): TExifFraction;
begin
  Result := FSections[esDetails].GetFractionValue(TagID, 0)
end;

function TCustomExifData.GetDetailsSFraction(TagID: Integer): TExifSignedFraction;
begin
  Result := TExifSignedFraction(FSections[esDetails].GetFractionValue(TagID, 0))
end;

function TCustomExifData.GetDetailsLongInt(TagID: Integer): LongInt;
begin
  Result := FSections[esDetails].GetLongIntValue(TagID, 0, 0)
end;

function TCustomExifData.GetDetailsLongWord(TagID: Integer): LongWord;
begin
  if not FSections[esDetails].TryGetLongWordValue(TagID, 0, Result) then
    Result := 0;
end;

function TCustomExifData.GetDetailsString(TagID: Integer): string;
begin
  Result := FSections[esDetails].GetStringValue(TagID)
end;

function TCustomExifData.GetFocalLengthIn35mmFilm: Word;
begin
  if not FSections[esDetails].TryGetWordValue(ttFocalLengthIn35mmFilm, 0, Result) then
    Result := 0;
end;

function TCustomExifData.GetExposureMode: TExifExposureMode;
begin
  if not FSections[esDetails].TryGetWordValue(ttExposureMode, 0, Result) then
    Result := exTagMissing;
end;

function TCustomExifData.GetExposureProgram: TExifExposureProgram;
begin
  if not FSections[esDetails].TryGetWordValue(ttExposureProgram, 0, Result) then
    Result := eeTagMissing;
end;

function TCustomExifData.GetFileSource: TExifFileSource;
begin
  if not FSections[esDetails].TryGetByteValue(ttFileSource, 0, Result) then
    Result := fsUnknown;
end;

function TCustomExifData.GetGainControl: TExifGainControl;
begin
  if not FSections[esDetails].TryGetWordValue(ttGainControl, 0, Result) then
    Result := egTagMissing;
end;

function TCustomExifData.GetDateTime: TDateTime;
begin
  Result := FSections[esGeneral].GetDateTimeValue(ttDateTime, ttSubsecTime);
end;

function TCustomExifData.GetGeneralString(TagID: Integer): string;
begin
  Result := FSections[esGeneral].GetStringValue(TagID)
end;

function TCustomExifData.GetGeneralWinString(TagID: Integer): UnicodeString;
begin
  Result := FSections[esGeneral].GetWindowsStringValue(TagID)
end;

function TCustomExifData.GetGPSAltitudeRef: TGPSAltitudeRef;
begin
  if not FSections[esGPS].TryGetByteValue(ttGPSAltitudeRef, 0, Result) then
    Result := alTagMissing;
end;

function TCustomExifData.GetGPSDateTimeUTC: TDateTime;
var
  Hour, Minute, Second: TExifFraction;
  S: string;
  TimePart: TDateTime;
  Year, Month, Day: Integer;
begin
  S := GPSDateStamp;
  if (Length(S) <> 10) or not TryStrToInt(Copy(S, 1, 4), Year) or
      not TryStrToInt(Copy(S, 6, 2), Month) or not TryStrToInt(Copy(S, 9, 2), Day) or
      not TryEncodeDate(Year, Month, Day, Result) then
    Result := 0;
  Hour := GPSTimeStampHour;
  Minute := GPSTimeStampMinute;
  Second := GPSTimeStampSecond;
  if Hour.MissingOrInvalid or Minute.MissingOrInvalid or Second.MissingOrInvalid then
    Exit;
  if TryEncodeTime(Trunc(Hour.Quotient), Trunc(Minute.Quotient), Trunc(Second.Quotient),
      0, TimePart) then
  begin
    if Result = 0 then
    begin
      Result := DateTime;
      if Result = 0 then Result := DateTimeOriginal;
      Result := DateOf(Result);
    end;
    if Result >= 0 then
      Result := Result + TimePart
    else
      Result := Result - TimePart
  end;
end;

function TCustomExifData.GetGPSFraction(TagID: Integer): TExifFraction;
begin
  Result := FSections[esGPS].GetFractionValue(TagID, 0);
end;

function TCustomExifData.GetGPSDestDistanceRef: TGPSDistanceRef;
var
  S: string;
begin
  Result := dsMissingOrInvalid;
  if FSections[esGPS].TryGetStringValue(ttGPSDestDistanceRef, S) and (S <> '') then
    case UpCase(S[1]) of
      'K': Result := dsKilometres;
      'M': Result := dsMiles;
      'N': Result := dsKnots;
    end;
end;

function TCustomExifData.GetGPSDifferential: TGPSDifferential;
begin
  if not FSections[esGPS].TryGetWordValue(ttGPSDifferential, 0, Result) then
    Result := dfTagMissing;
end;

function TCustomExifData.GetGPSDirection(TagID: Integer): TGPSDirectionRef;
var
  S: string;
begin
  Result := drMissingOrInvalid;
  if FSections[esGPS].TryGetStringValue(TagID, S) and (S <> '') then
    case UpCase(S[1]) of
      'T': Result := drTrueNorth;
      'M': Result := drMagneticNorth;
    end;
end;

function TCustomExifData.GetGPSMeasureMode: TGPSMeasureMode;
var
  S: string;
begin
  Result := mmUnknown;
  if FSections[esGPS].TryGetStringValue(ttGPSMeasureMode, S) and (S <> '') then
    case UpCase(S[1]) of
      '2': Result := mm2D;
      '3': Result := mm3D;
    end;
end;

function TCustomExifData.GetGPSSpeedRef: TGPSSpeedRef;
var
  S: string;
begin
  Result := srMissingOrInvalid;
  if FSections[esGPS].TryGetStringValue(ttGPSSpeedRef, S) and (S <> '') then
    case UpCase(S[1]) of
      'K': Result := srKilometresPerHour;
      'M': Result := srMilesPerHour;
      'N': Result := srKnots;
    end;
end;

function TCustomExifData.GetGPSStatus: TGPSStatus;
var
  S: string;
begin
  Result := stMissingOrInvalid;
  if FSections[esGPS].TryGetStringValue(ttGPSStatus, S) and (S <> '') then
    case UpCase(S[1]) of
      'A': Result := stMeasurementActive;
      'V': Result := stMeasurementVoid;
    end;
end;

function TCustomExifData.GetGPSString(TagID: Integer): string;
begin
  Result := FSections[esGPS].GetStringValue(TagID)
end;

function TCustomExifData.GetGPSTimeStamp(const Index: Integer): TExifFraction;
begin
  Result := FSections[esGPS].GetFractionValue(ttGPSTimeStamp, Index)
end;

function TCustomExifData.GetInteropTypeName: string;
begin
  Result := FSections[esInterop].GetStringValue(ttInteropIndex);
end;

procedure TCustomExifData.SetInteropTypeName(const Value: string);
begin
  FSections[esInterop].SetStringValue(ttInteropIndex, Value);
end;

function TCustomExifData.GetLightSource: TExifLightSource;
begin
  if not FSections[esDetails].TryGetWordValue(ttLightSource, 0, Result) then
    Result := elTagMissing;
end;

function TCustomExifData.GetMeteringMode: TExifMeteringMode;
begin
  if not FSections[esDetails].TryGetWordValue(ttMeteringMode, 0, Result) then
    Result := emTagMissing;
end;

function TCustomExifData.GetOrientation(SectionKind: Integer): TExifOrientation;
var
  Section: TExifSectionKind absolute SectionKind;
begin
  if not FSections[Section].TryGetWordValue(ttOrientation, 0, Result) then
    Result := toUndefined;
end;

function TCustomExifData.GetRendering: TExifRendering;
begin
  if not FSections[esDetails].TryGetWordValue(ttCustomRendered, 0, Result) then
    Result := erTagMissing;
end;

function TCustomExifData.GetSaturation: TExifSaturation;
begin
  if not FSections[esDetails].TryGetWordValue(ttSaturation, 0, Result) then
    Result := euTagMissing;
end;

function TCustomExifData.GetSceneCaptureType: TExifSceneCaptureType;
begin
  if not FSections[esDetails].TryGetWordValue(ttSceneCaptureType, 0, Result) then
    Result := ecTagMissing;
end;

function TCustomExifData.GetSceneType: TExifSceneType;
begin
  if not FSections[esDetails].TryGetByteValue(ttSceneType, 0, Result) then
    Result := esUnknown;
end;

function TCustomExifData.GetSensingMethod: TExifSensingMethod;
begin
  if not FSections[esDetails].TryGetWordValue(ttSensingMethod, 0, Result) then
    Result := esTagMissing;
end;

function TCustomExifData.GetSharpness: TExifSharpness;
begin
  if not FSections[esDetails].TryGetWordValue(ttSharpness, 0, Result) then
    Result := ehTagMissing;
end;

function TCustomExifData.GetSubjectDistanceRange: TExifSubjectDistanceRange;
begin
  if not FSections[esDetails].TryGetWordValue(ttSubjectDistanceRange, 0, Result) then
    Result := edTagMissing;
end;

function TCustomExifData.GetSubjectLocation: TSmallPoint;
var
  Tag: TExifTag;
begin
  if FSections[esDetails].Find(ttSubjectLocation, Tag) and
    (Tag.DataType in [tdWord, tdSmallInt]) and (Tag.ElementCount >= 2) then
    Result := PSmallPoint(Tag.Data)^
  else
  begin
    Result.x := -1;
    Result.y := -1;
  end;
end;

function TCustomExifData.GetUserRating: TWindowsStarRating;
begin
  if not FSections[esGeneral].TryGetWordValue(ttWindowsRating, 0, Result) then
    Result := urUndefined;
end;

function TCustomExifData.GetWhiteBalance: TExifWhiteBalanceMode;
begin
  if not FSections[esDetails].TryGetWordValue(ttWhiteBalance, 0, Result) then
    Result := ewTagMissing;
end;

{ TCustomExifData - tag setters }

procedure TCustomExifData.SetAuthor(const Value: UnicodeString);
var              //While it always writes both XMP properties, Windows Explorer always
  Tag: TExifTag; //set its own unicode Exif tag and clears the 'standard' ASCII one;
begin            //we'll be a bit more intelligent though.
  XMPPacket.UpdateSeqProperty(xsDublinCore, 'creator', Value);
  XMPPacket.UpdateProperty(xsTIFF, 'Artist', Value);
  if Length(Value) = 0 then
  begin
    FSections[esGeneral].Remove(ttArtist);
    FSections[esGeneral].Remove(ttWindowsAuthor);
    Exit;
  end;
  if not ContainsOnlyASCII(Value) then
    FSections[esGeneral].Remove(ttArtist)
  else
    if FSections[esGeneral].Find(ttArtist, Tag) then
    begin
      Tag.UpdateData(tdAscii, Length(Value), TiffString(Value)[1]);
      if not FSections[esGeneral].Find(ttWindowsAuthor, Tag) then
        Exit;
    end;
  FSections[esGeneral].SetWindowsStringValue(ttWindowsAuthor, Value);
end;

procedure TCustomExifData.SetColorSpace(Value: TExifColorSpace);
begin
  if Value = csTagMissing then
  begin
    FSections[esDetails].Remove(ttColorSpace);
    RemoveXMPProperty(xsExif, 'ColorSpace');
  end
  else
  begin
    FSections[esDetails].ForceSetElement(ttColorSpace, tdWord, 0, Value);
    XMPPacket.UpdateProperty(xsExif, 'ColorSpace', Ord(Value));
  end;
end;

procedure TCustomExifData.SetComments(const Value: UnicodeString);
var
  Tag: TExifTag;
  NewSize: Integer;
begin
  XMPPacket.UpdateProperty(xsExif, 'UserComment', xpAltArray, Value);
  if Length(Value) = 0 then
  begin
    FSections[esGeneral].Remove(ttWindowsComments);
    FSections[esDetails].Remove(ttUserComment);
  end
  else
  begin
    FSections[esGeneral].SetWindowsStringValue(ttWindowsComments, Value);
    if FSections[esGeneral].Find(ttUserComment, Tag) then
    begin
      NewSize := SizeOf(UCID_Unicode) + Length(Value) * 2;
      if (NewSize > Tag.OriginalDataSize) and not Tag.Section.IsExtendable then
        Tag.ElementCount := 0
      else
      begin
        Tag.UpdateData(tdByte, NewSize, PByte(nil)^);
        Move(UCID_Unicode, Tag.Data^, SizeOf(UCID_Unicode));
        Move(PWideChar(Value)^, PByteArray(Tag.Data)[SizeOf(UCID_Unicode)],
          NewSize - SizeOf(UCID_Unicode));
      end;
    end;
  end;
end;

procedure TCustomExifData.SetDetailsDateTime(TagID: Integer; const Value: TDateTime);
var
  SubSecsID: TExifTagID;
  XMPName: string;
begin
  case TagID of
    ttDateTimeOriginal: SubSecsID := ttSubsecTimeOriginal;
    ttDateTimeDigitized: SubSecsID := ttSubsecTimeDigitized;
  else SubSecsID := 0;
  end;
  FSections[esDetails].SetDateTimeValue(TagID, SubSecsID, Value);
  case TagID of
    ttDateTimeOriginal: XMPName := 'DateTimeOriginal';
    ttDateTimeDigitized: XMPName := 'DateTimeDigitized';
  else Exit;
  end;
  XMPPacket.UpdateDateTimeProperty(xsExif, XMPName, Value);
end;

procedure TCustomExifData.SetDetailsFraction(TagID: Integer;
  const Value: TExifFraction);
var
  XMPName: string;
begin
  FSections[esDetails].SetFractionValue(TagID, 0, Value);
  case TagID of
    ttApertureValue: XMPName := 'ApertureValue';
    ttCompressedBitsPerPixel: XMPName := 'CompressedBitsPerPixel';
    ttDigitalZoomRatio: XMPName := 'DigitalZoomRatio';
    ttExposureBiasValue: XMPName := 'ExposureBiasValue';
    ttExposureTime: XMPName := 'ExposureTime';
    ttFNumber: XMPName := 'FNumber';
    ttMaxApertureValue: XMPName := 'MaxApertureValue';
    ttSubjectDistance: XMPName := 'SubjectDistance';
  else Exit;
  end;
  XMPPacket.UpdateProperty(xsExif, XMPName, Value.AsString);
end;

procedure TCustomExifData.SetDetailsSFraction(TagID: Integer;
  const Value: TExifSignedFraction);
var
  PropName: string;
begin
  FSections[esDetails].SetSignedFractionValue(TagID, 0, Value);
  case TagID of
    ttBrightnessValue: PropName := 'BrightnessValue';
    ttExposureBiasValue: PropName := 'ExposureBiasValue';
    ttShutterSpeedValue: PropName := 'ShutterSpeedValue';
  else Exit;
  end;
  XMPPacket.UpdateProperty(xsExif, PropName, Value.AsString);
end;

procedure TCustomExifData.SetDetailsLongInt(TagID: Integer; const Value: LongInt);
begin
  FSections[esDetails].ForceSetElement(TagID, tdLongInt, 0, Value)
end;

//procedure TCustomExifData.SetDetailsLongWord(TagID: Integer; const Value: LongWord);
//begin
//  FSections[esDetails].SetLongWordValue(TagID, 0, Value)
//end;

procedure TCustomExifData.SetDetailsString(TagID: Integer; const Value: string);
var
  XMPName: string;
begin
  FSections[esDetails].SetStringValue(TagID, Value);
  case TagID of
    ttImageUniqueID: XMPName := 'ImageUniqueID';
    ttRelatedSoundFile: XMPName := 'RelatedSoundFile';
    ttSpectralSensitivity: XMPName := 'SpectralSensitivity';
  else Exit;
  end;
  XMPPacket.UpdateProperty(xsExif, XMPName, Value);
end;

procedure TCustomExifData.SetFocalLengthIn35mmFilm(Value: Word);
begin
  FSections[esDetails].SetWordValue(ttFocalLengthIn35mmFilm, 0, Value);
  XMPPacket.UpdateProperty(xsExif, 'FocalLengthIn35mmFilm', Value);
end;

procedure TCustomExifData.SetDetailsWordEnum(ID: TExifTagID;
  const XMPName: UnicodeString; const Value);
begin
  if SmallInt(Value) = -1 then
  begin
    FSections[esDetails].Remove(ID);
    RemoveXMPProperty(xsExif, XMPName);
  end
  else
  begin
    FSections[esDetails].ForceSetElement(ID, tdWord, 0, Value);
    XMPPacket.UpdateProperty(xsExif, XMPName, Word(Value));
  end;
end;

procedure TCustomExifData.SetDetailsByteEnum(ID: TExifTagID; const XMPName: UnicodeString; const Value);
begin
  if Byte(Value) = 0 then
  begin
    FSections[esDetails].Remove(ID);
    RemoveXMPProperty(xsExif, XMPName);
  end
  else
  begin
    FSections[esDetails].ForceSetElement(ID, tdUndefined, 0, Value);
    XMPPacket.UpdateProperty(xsExif, XMPName, Byte(Value));
  end;
end;

procedure TCustomExifData.SetExifImageSize(ID: Integer; NewValue: LongWord);
const
  PropNames: array[ttExifImageWidth..ttExifImageHeight] of string = ('PixelXDimension',
    'PixelYDimension');
var
  Tag: TExifTag;
begin
  Tag := nil;
  if (NewValue <= High(Word)) and FSections[esDetails].Find(ID, Tag) and
     (Tag.DataType = tdWord) and (Tag.ElementCount = 1) then
    Tag.UpdateData(NewValue)
  else if Tag <> nil then
    Tag.UpdateData(tdLongWord, 1, NewValue)
  else
    PLongWord(FSections[esDetails].Add(ID, tdLongWord, 1).Data)^ := NewValue;
  XMPPacket.UpdateProperty(xsExif, PropNames[ID], Integer(NewValue));
end;

procedure TCustomExifData.SetExifVersion(Value: TCustomExifVersion);
begin
  FExifVersion.Assign(Value);
end;

procedure TCustomExifData.SetExposureMode(const Value: TExifExposureMode);
begin
  SetDetailsWordEnum(ttExposureMode, 'ExposureMode', Value);
end;

procedure TCustomExifData.SetExposureProgram(const Value: TExifExposureProgram);
begin
  SetDetailsWordEnum(ttExposureProgram, 'ExposureProgram', Value);
end;

procedure TCustomExifData.SetFlashPixVersion(Value: TCustomExifVersion);
begin
  FFlashPixVersion.Assign(Value);
end;

procedure TCustomExifData.SetFileSource(const Value: TExifFileSource);
begin
  SetDetailsByteEnum(ttFileSource, 'FileSource', Value);
end;

procedure TCustomExifData.SetFlash(Value: TExifFlashInfo);
begin
  FFlash.Assign(Value);
end;

procedure TCustomExifData.SetFocalPlaneResolution(Value: TCustomExifResolution);
begin
  FFocalPlaneResolution.Assign(Value);
end;

procedure TCustomExifData.SetGainControl(const Value: TExifGainControl);
begin
  SetDetailsWordEnum(ttGainControl, 'GainControl', Value);
end;

procedure TCustomExifData.SetDateTime(const Value: TDateTime);
begin
  FSections[esGeneral].SetDateTimeValue(ttDateTime, ttSubsecTime, Value);
  XMPPacket.UpdateDateTimeProperty(xsTIFF, 'DateTime', Value);
end;

procedure TCustomExifData.SetGeneralString(TagID: Integer; const Value: string);
begin
  FSections[esGeneral].SetStringValue(TagID, Value);
  case TagID of
    ttCopyright: XMPPacket.UpdateProperty(xsDublinCore, 'rights', xpAltArray,
      Value);
    ttImageDescription:
      if (Value <> '') or (XMPWritePolicy = xwRemove) or
         not FSections[esDetails].TagExists(ttWindowsSubject) then
        XMPPacket.UpdateProperty(xsDublinCore, 'description', xpAltArray, Value);
    ttMake: XMPPacket.UpdateProperty(xsTIFF, 'Make', Value);
    ttModel: XMPPacket.UpdateProperty(xsTIFF, 'Model', Value);
    ttSoftware:
    begin
      XMPPacket.UpdateProperty(xsXMPBasic, 'creatortool', Value);
      XMPPacket.UpdateProperty(xsTIFF, 'Software', Value);
    end;
  end;
end;

procedure TCustomExifData.SetGeneralWinString(TagID: Integer;
  const Value: UnicodeString);
begin
  FSections[esGeneral].SetWindowsStringValue(TagID, Value);
  case TagID of
    ttWindowsKeywords:
    begin
      XMPPacket.UpdateBagProperty(xsDublinCore, 'subject', Value);
      XMPPacket.UpdateBagProperty(xsMicrosoftPhoto, 'LastKeywordXMP', Value);
    end;
    ttWindowsSubject: XMPPacket.UpdateProperty(xsDublinCore, 'description', xpAltArray, Value);
    ttWindowsTitle: XMPPacket.UpdateProperty(xsDublinCore, 'title', xpAltArray, Value);
  end;
end;

procedure TCustomExifData.SetGPSAltitudeRef(const Value: TGPSAltitudeRef);
begin
  if Value = alTagMissing then
  begin
    FSections[esGPS].Remove(ttGPSAltitudeRef);
    RemoveXMPProperty(xsExif, GetGPSTagXMPName(ttGPSAltitudeRef));
    Exit;
  end;
  FSections[esGPS].SetByteValue(ttGPSAltitudeRef, 0, Ord(Value));
  XMPPacket.UpdateProperty(xsExif, GetGPSTagXMPName(ttGPSAltitudeRef), Ord(Value));
end;

procedure TCustomExifData.SetGPSDateTimeUTC(const Value: TDateTime);
const
  XMPName = 'GPSTimeStamp';
var
  Year, Month, Day, Hour, Minute, Second, MSecond: Word;
begin
  BeginUpdate;
  try
    if Value = 0 then
    begin
      FSections[esGPS].Remove(ttGPSDateStamp);
      FSections[esGPS].Remove(ttGPSTimeStamp);
      RemoveXMPProperty(xsExif, XMPName);
      Exit;
    end;
    DecodeDateTime(Value, Year, Month, Day, Hour, Minute, Second, MSecond);
    GPSDateStamp := Format('%.4d:%.2d:%.2d', [Year, Month, Day]);
    GPSTimeStampHour := TExifFraction.Create(Hour, 1);
    GPSTimeStampMinute := TExifFraction.Create(Minute, 1);
    GPSTimeStampSecond := TExifFraction.Create(Second, 1);
    XMPPacket.UpdateDateTimeProperty(xsExif, XMPName, Value);
  finally
    EndUpdate;
  end;
end;

procedure TCustomExifData.SetGPSDestDistanceRef(const Value: TGPSDistanceRef);
const
  Strings: array[TGPSDistanceRef] of string = ('', 'K', 'M', 'N');
begin
  FSections[esGPS].SetStringValue(ttGPSDestDistanceRef, Strings[Value]);
  XMPPacket.UpdateProperty(xsExif, GetGPSTagXMPName(ttGPSDestDistanceRef), Strings[Value]);
end;

procedure TCustomExifData.SetGPSDestLatitude(Value: TGPSLatitude);
begin
  FGPSDestLatitude.Assign(Value);
end;

procedure TCustomExifData.SetGPSDestLongitude(Value: TGPSLongitude);
begin
  FGPSDestLongitude.Assign(Value);
end;

procedure TCustomExifData.SetGPSDifferential(Value: TGPSDifferential);
begin
  if Value = dfTagMissing then
  begin
    FSections[esGPS].Remove(ttGPSDifferential);
    RemoveXMPProperty(xsExif, GetGPSTagXMPName(ttGPSDifferential));
    Exit;
  end;
  FSections[esGPS].ForceSetElement(ttGPSDifferential, tdWord, 0, Value);
  XMPPacket.UpdateProperty(xsExif, GetGPSTagXMPName(ttGPSDifferential), Ord(Value));
end;

procedure TCustomExifData.SetGPSDirection(TagID: Integer; Value: TGPSDirectionRef);
const
  Strings: array[TGPSDirectionRef] of string = ('', 'T', 'M');
begin
  FSections[esGPS].SetStringValue(TagID, Strings[Value]);
  XMPPacket.UpdateProperty(xsExif, GetGPSTagXMPName(TagID), Strings[Value]);
end;

procedure TCustomExifData.SetGPSFraction(TagID: Integer; const Value: TExifFraction);
var
  XMPName: string;
begin
  FSections[esGPS].SetFractionValue(TagID, 0, Value);
  if FindGPSTagXMPName(TagID, XMPName) then 
    XMPPacket.UpdateProperty(xsExif, XMPName, Value.AsString);
end;

procedure TCustomExifData.SetGPSLatitude(Value: TGPSLatitude);
begin
  FGPSLatitude.Assign(Value);
end;

procedure TCustomExifData.SetGPSLongitude(Value: TGPSLongitude);
begin
  FGPSLongitude.Assign(Value);
end;

procedure TCustomExifData.SetGPSMeasureMode(const Value: TGPSMeasureMode);
const
  Strings: array[TGPSMeasureMode] of string = ('', '2', '3');
begin
  FSections[esGPS].SetStringValue(ttGPSMeasureMode, Strings[Value]);
  XMPPacket.UpdateProperty(xsExif, GetGPSTagXMPName(ttGPSMeasureMode), Strings[Value]);
end;

procedure TCustomExifData.SetGPSSpeedRef(const Value: TGPSSpeedRef);
const
  Strings: array[TGPSSpeedRef] of string = ('', 'K', 'M', 'N');
begin
  FSections[esGPS].SetStringValue(ttGPSSpeedRef, Strings[Value]);
  XMPPacket.UpdateProperty(xsExif, 'GPSSpeedRef', Strings[Value]);
end;

procedure TCustomExifData.SetGPSStatus(const Value: TGPSStatus);
const
  Strings: array[TGPSStatus] of string = ('', 'A', 'V');
begin
  FSections[esGPS].SetStringValue(ttGPSStatus, Strings[Value]);
  XMPPacket.UpdateProperty(xsExif, 'GPSStatus', Strings[Value]);
end;

procedure TCustomExifData.SetGPSString(TagID: Integer; const Value: string);
var
  XMPName: string;
begin
  FSections[esGPS].SetStringValue(TagID, Value);
  if FindGPSTagXMPName(TagID, XMPName) then 
    XMPPacket.UpdateProperty(xsExif, XMPName, Value);
end;

procedure TCustomExifData.SetGPSTimeStamp(const Index: Integer;
  const Value: TExifFraction);
begin
  FSections[esGPS].SetFractionValue(ttGPSTimeStamp, Index, Value);
  if FUpdateCount = 0 then
    RemoveXMPProperty(xsExif, GetGPSTagXMPName(ttGPSTimeStamp));
end;

procedure TCustomExifData.SetGPSVersion(Value: TCustomExifVersion);
begin
  FGPSVersion.Assign(Value);
end;

procedure TCustomExifData.SetInteropVersion(Value: TCustomExifVersion);
begin
  FInteropVersion.Assign(Value);
end;

procedure TCustomExifData.SetISOSpeedRatings(Value: TISOSpeedRatings);
begin
  if Value <> FISOSpeedRatings then FISOSpeedRatings.Assign(Value);
end;

procedure TCustomExifData.SetLightSource(const Value: TExifLightSource);
begin
  SetDetailsWordEnum(ttLightSource, 'LightSource', Value);
end;

procedure TCustomExifData.SetMeteringMode(const Value: TExifMeteringMode);
begin
  SetDetailsWordEnum(ttMeteringMode, 'MeteringMode', Value);
end;

procedure TCustomExifData.SetOrientation(SectionKind: Integer; Value: TExifOrientation);
var
  XMPValue: UnicodeString;
begin
  with FSections[TExifSectionKind(SectionKind)] do
    if Value = toUndefined then
      Remove(ttOrientation)
    else
      SetWordValue(ttOrientation, 0, Ord(Value));
  if TExifSectionKind(SectionKind) <> esGeneral then Exit;
  if Value = toUndefined then
    XMPValue := ''
  else
    XMPValue := IntToStr(Ord(Value));
  XMPPacket.UpdateProperty(xsTIFF, 'Orientation', XMPValue);
end;

procedure TCustomExifData.SetResolution(Value: TCustomExifResolution);
begin
  FResolution.Assign(Value);
end;

procedure TCustomExifData.SetRendering(const Value: TExifRendering);
begin
  SetDetailsWordEnum(ttCustomRendered, 'CustomRendered', Value);
end;

procedure TCustomExifData.SetSaturation(Value: TExifSaturation);
begin
  SetDetailsWordEnum(ttSaturation, 'Saturation', Value);
end;

procedure TCustomExifData.SetSceneCaptureType(const Value: TExifSceneCaptureType);
begin
  SetDetailsWordEnum(ttSceneCaptureType, 'SceneCaptureType', Value);
end;

procedure TCustomExifData.SetSceneType(Value: TExifSceneType);
begin
  SetDetailsByteEnum(ttSceneType, 'SceneType', Value);
end;

procedure TCustomExifData.SetSensingMethod(const Value: TExifSensingMethod);
begin
  SetDetailsWordEnum(ttSensingMethod, 'SensingMethod', Value);
end;

procedure TCustomExifData.SetSharpness(Value: TExifSharpness);
begin
  SetDetailsWordEnum(ttSharpness, 'Sharpness', Value);
end;

procedure TCustomExifData.SetSubjectDistanceRange(Value: TExifSubjectDistanceRange);
begin
  SetDetailsWordEnum(ttSubjectDistanceRange, 'SubjectDistanceRange', Value);
end;

procedure TCustomExifData.SetSubjectLocation(const Value: TSmallPoint);
const
  XMPName = 'SubjectLocation';
var
  Tag: TExifTag;
begin
  if InvalidPoint(Value) then
  begin
    FSections[esDetails].Remove(ttSubjectDistance);
    RemoveXMPProperty(xsExif, XMPName);
  end
  else
  begin
    if not FSections[esDetails].Find(ttSubjectDistance, Tag) then
      Tag := FSections[esDetails].Add(ttSubjectDistance, tdWord, 2);
    Tag.UpdateData(tdWord, 2, Value);
    XMPPacket.UpdateSeqProperty(xsExif, XMPName, [IntToStr(Value.x), IntToStr(Value.y)]);
  end;
end;

procedure TCustomExifData.SetThumbnailResolution(Value: TCustomExifResolution);
begin
  FThumbnailResolution.Assign(Value);
end;

procedure TCustomExifData.SetUserRating(const Value: TWindowsStarRating);
const
  MSPhotoValues: array[TWindowsStarRating] of UnicodeString = ('', '1', '25', '50', '75', '99');
  XMPBasicValues: array[TWindowsStarRating] of UnicodeString = ('', '1', '2', '3', '4', '5');
begin
  if Value = urUndefined then
    FSections[esGeneral].Remove(ttWindowsRating)
  else
    FSections[esGeneral].SetWordValue(ttWindowsRating, 0, Ord(Value));
  XMPPacket.UpdateProperty(xsMicrosoftPhoto, 'Rating', MSPhotoValues[Value]);
  XMPPacket.UpdateProperty(xsXMPBasic, 'Rating', XMPBasicValues[Value]);
end;

procedure TCustomExifData.SetWhiteBalance(const Value: TExifWhiteBalanceMode);
begin
  SetDetailsWordEnum(ttWhiteBalance, 'WhiteBalance', Value);
end;

{ *** deprecated *** }

function TCustomExifData.GPSDifferentialApplied: Boolean;
begin
  Result := FSections[esGPS].GetWordValue(ttGPSDifferential, 0, 0) <> 0;
end;

function TCustomExifData.GPSLatitudeRef: TGPSLatitudeRef;
begin
  Result := GPSLatitude.Direction;
end;

function TCustomExifData.GPSLatitudeDegrees: TExifFraction;
begin
  Result := GPSLatitude.Degrees;
end;

function TCustomExifData.GPSLatitudeMinutes: TExifFraction;
begin
  Result := GPSLatitude.Minutes;
end;

function TCustomExifData.GPSLatitudeSeconds: TExifFraction;
begin
  Result := GPSLatitude.Seconds;
end;

function TCustomExifData.GPSLongitudeRef: TGPSLongitudeRef;
begin
  Result := GPSLongitude.Direction;
end;

function TCustomExifData.GPSLongitudeDegrees: TExifFraction;
begin
  Result := GPSLongitude.Degrees;
end;

function TCustomExifData.GPSLongitudeMinutes: TExifFraction;
begin
  Result := GPSLongitude.Minutes;
end;

function TCustomExifData.GPSLongitudeSeconds: TExifFraction;
begin
  Result := GPSLongitude.Seconds;
end;

function TCustomExifData.GPSDestLatitudeRef: TGPSLatitudeRef;
begin
  Result := GPSDestLatitude.Direction;
end;

function TCustomExifData.GPSDestLatitudeDegrees: TExifFraction;
begin
  Result := GPSDestLatitude.Degrees;
end;

function TCustomExifData.GPSDestLatitudeMinutes: TExifFraction;
begin
  Result := GPSDestLatitude.Minutes;
end;

function TCustomExifData.GPSDestLatitudeSeconds: TExifFraction;
begin
  Result := GPSDestLatitude.Seconds;
end;

function TCustomExifData.GPSDestLongitudeRef: TGPSLongitudeRef;
begin
  Result := GPSDestLongitude.Direction;
end;

function TCustomExifData.GPSDestLongitudeDegrees: TExifFraction;
begin
  Result := GPSDestLongitude.Degrees;
end;

function TCustomExifData.GPSDestLongitudeMinutes: TExifFraction;
begin
  Result := GPSDestLongitude.Minutes;
end;

function TCustomExifData.GPSDestLongitudeSeconds: TExifFraction;
begin
  Result := GPSDestLongitude.Seconds;
end;

{ TExifDataPatcher }

constructor TExifDataPatcher.Create(const AFileName: string);
begin
  inherited Create;
  OpenFile(AFileName);
end;

destructor TExifDataPatcher.Destroy;
begin
  CloseFile;
  inherited;
end;

procedure TExifDataPatcher.CheckFileIsOpen;
begin
  if FStream = nil then
    raise ENoExifFileOpenError.Create(SNoFileOpenError);
end;

function TExifDataPatcher.GetFileDateTime: TDateTime;
begin
  CheckFileIsOpen;
  Result := FileDateToDateTime(FileGetDate(FStream.Handle));
end;

function TExifDataPatcher.GetFileName: string;
begin
  if FStream <> nil then
    Result := FStream.FileName
  else
    Result := '';
end;

procedure TExifDataPatcher.GetImage(Dest: TJPEGImage);
begin
  CheckFileIsOpen;
  FStream.Position := 0;
  Dest.LoadFromStream(FStream);
end;

procedure TExifDataPatcher.GetThumbnail(Dest: TJPEGImage);
var
  Offset: LongInt;
begin
  CheckFileIsOpen;
  if not FindThumbnailOffset(FStream, Offset) then
  begin
    Dest.Assign(nil);
    Exit;
  end;
  FStream.Position := OffsetBase + Offset;
  TJpegImageEx(Dest).ReadStream(GetJpegDataSize(FStream), FStream);
end;

function TExifDataPatcher.HasThumbnail: Boolean;
var
  Offset: LongInt;
begin
  Result := (FStream <> nil) and FindThumbnailOffset(FStream, Offset);
end;

procedure TExifDataPatcher.SetFileDateTime(const Value: TDateTime);
begin
  CheckFileIsOpen;                                        {$WARN SYMBOL_PLATFORM OFF}
  FileSetDate(FStream.Handle, DateTimeToFileDate(Value)); {$WARN SYMBOL_PLATFORM ON}
end;

procedure TExifDataPatcher.OpenFile(const FileName: string);

  procedure InvalidFile;
  begin
    raise EInvalidJPEGHeader.CreateFmt(SFileIsNotAValidJPEG, [FileName]); //give a bit more info
  end;
begin
  CloseFile;
  if FileName = '' then Exit;
  FStream := TFileStream.Create(FileName, fmOpenReadWrite);
  try
    LoadFromJPEG(FStream);
  except
    on EInvalidJPEGHeader do InvalidFile;
    on EStreamError do InvalidFile;
    else raise;
  end;
  FOriginalEndianness := Endianness;
end;

procedure TExifDataPatcher.CloseFile(SaveChanges: Boolean);
begin
  if FStream = nil then Exit;
  if SaveChanges then UpdateFile;
  FreeAndNil(FStream);
  Clear;
  Modified := False;
end;

procedure TExifDataPatcher.UpdateFile;
var
  DataOffsetFix: Int64;
  OldDate: Integer;
  Section: TExifSection;
  SectionEndianness: TEndianness;
  Tag: TExifTag;
  XMPStream: TMemoryStream;
  Segment: IFoundJPEGSegment;
  BytesToRewrite: TBytes;
begin
  if (FStream = nil) or not Modified then Exit;
  OldDate := FileGetDate(FStream.Handle);
  for Section in Self do
    if Section.Modified or ((Endianness <> FOriginalEndianness) and (Section.Kind <> esMakerNote)) then
    begin
      if Section.Kind = esMakerNote then
      begin
        DataOffsetFix := -OffsetSchema;
        SectionEndianness := MakerNote.Endianness;
      end
      else
      begin
        DataOffsetFix := 0;
        SectionEndianness := Endianness;
      end;
      Stream.Position := OffsetBase + Section.FirstTagHeaderOffset;
      for Tag in Section do
        Tag.WriteHeader(Stream, SectionEndianness, Tag.OriginalDataOffset + DataOffsetFix);
      for Tag in Section do
      begin
        Stream.Position := OffsetBase + Tag.OriginalDataOffset;
        Tag.WriteOffsettedData(Stream, SectionEndianness);
      end;
      Section.Modified := False;
    end;
  if (XMPSegmentToLoad = nil) and ((mkXMP in MetadataInSource) or not XMPPacket.Empty) then
  begin
    BytesToRewrite := nil;
    XMPStream := TMemoryStream.Create;
    try
      XMPPacket.WriteSegmentHeader := True;
      XMPPacket.SaveToStream(XMPStream);
      if XMPStream.Size <= FXMPPacketSizeInSource then
      begin
        Assert(mkXMP in MetadataInSource);
        XMPStream.Size := FXMPPacketSizeInSource;
        FillChar(PAnsiChar(XMPStream.Memory)[XMPStream.Size],
          FXMPPacketSizeInSource - XMPStream.Size, $20);
      end
      else
      begin
        if mkXMP in MetadataInSource then
          Stream.Position := FXMPSegmentPosition + SizeOf(TJPEGSegmentHeader) + FXMPPacketSizeInSource
        else
        begin
          Stream.Position := 0;
          for Segment in JPEGHeader(Stream, AllJPEGMarkers) do
            if Segment.MarkerNum <> jmApp1 then Break;
          FXMPSegmentPosition := Stream.Position;
          Include(FMetadataInSource, mkXMP);
        end;
        FXMPPacketSizeInSource := XMPStream.Size;
        SetLength(BytesToRewrite, Stream.Size - Stream.Position);
        Stream.ReadBuffer(BytesToRewrite[0], Length(BytesToRewrite));
      end;
      Stream.Position := FXMPSegmentPosition;
      WriteJPEGSegmentToStream(Stream, jmApp1, XMPStream);
      if BytesToRewrite <> nil then
        Stream.WriteBuffer(BytesToRewrite[0], Length(BytesToRewrite));
    finally
      XMPStream.Free;
    end;
  end;
  FOriginalEndianness := Endianness;
  if PreserveFileDate then                {$WARN SYMBOL_PLATFORM OFF}
    FileSetDate(FStream.Handle, OldDate); {$WARN SYMBOL_PLATFORM ON}
  Modified := False;
end;

{ TExifData }

constructor TExifData.Create;
begin
  inherited Create;
  FRemovePaddingTagsOnSave := True;
end;

destructor TExifData.Destroy;
begin
  inherited;
  FThumbnailOrNil.Free;
end;

procedure TExifData.Assign(Source: TPersistent);
var
  SourceData: TCustomExifData;
  Section: TExifSectionKind;
begin
  if Source = nil then
    Clear
  else if Source is TCustomExifData then
  begin
    BeginUpdate;
    try
      SourceData := TCustomExifData(Source);
      for Section := Low(TExifSectionKind) to High(TExifSectionKind) do
        Sections[Section].Assign(SourceData[Section]);
      if SourceData is TExifData then
        Thumbnail := TExifData(SourceData).FThumbnailOrNil
      else if Sections[esThumbnail].Count = 0 then
        SetThumbnail(nil);
    finally
      EndUpdate;
    end;
  end
  else
    inherited;
end;

procedure TExifData.Clear(XMPPacketToo: Boolean = True);
begin
  FreeAndNil(FThumbnailOrNil);
  inherited;
end;

procedure TExifData.CreateThumbnail(Source: TGraphic;
  ThumbnailWidth, ThumbnailHeight: Integer);
begin
  if (Source = nil) or Source.Empty then
    SetThumbnail(nil)
  else
    CreateExifThumbnail(Source, Thumbnail, ThumbnailWidth, ThumbnailHeight);
end;

procedure TExifData.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('Data', LoadFromStream, SaveToStream, not Empty);
end;

function TExifData.GetEmpty: Boolean;
begin
  Result := inherited GetEmpty and ((FThumbnailOrNil = nil) or FThumbnailOrNil.Empty);
end;

function TExifData.GetSection(Section: TExifSectionKind): TExtendableExifSection;
begin
  Result := TExtendableExifSection(inherited Sections[Section]);
end;

function TExifData.GetThumbnail: TJPEGImage;
begin
  if FThumbnailOrNil = nil then
  begin
    FThumbnailOrNil := TJPEGImage.Create;
    FThumbnailOrNil.OnChange := ThumbnailChanged;
  end;
  Result := FThumbnailOrNil;
end;

procedure TExifData.SetThumbnail(const Value: TJPEGImage);
begin
  if Value <> nil then
    GetThumbnail.Assign(Value)
  else
    FreeAndNil(FThumbnailOrNil);
end;

procedure TExifData.StandardizeThumbnail;
begin
  if (FThumbnailOrNil <> nil) and (FThumbnailOrNil.Width > StandardExifThumbnailWidth) or
     (FThumbnailOrNil.Height > StandardExifThumbnailHeight) then
    CreateExifThumbnail(FThumbnailOrNil, FThumbnailOrNil);
end;

procedure TExifData.ThumbnailChanged(Sender: TObject);
var
  Tag: TExifTag;
begin
  Modified := True;
  if Sender = FThumbnailOrNil then
    with Sections[esThumbnail] do
      if Find(ttImageWidth, Tag) or Find(ttImageHeight, Tag) then
      begin
        SetWordValue(ttImageWidth, 0, FThumbnailOrNil.Width);
        SetWordValue(ttImageHeight, 0, FThumbnailOrNil.Height);
      end;
end;

function TExifData.LoadFromJPEG(JPEGStream: TStream): Boolean;
begin
  Result := inherited LoadFromJPEG(JPEGStream);
end;

function TExifData.LoadFromJPEG(JPEGImage: TJPEGImage): Boolean;
var
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    JPEGImage.SaveToStream(Stream);
    Stream.Position := 0;
    Result := inherited LoadFromJPEG(Stream)
  finally
    Stream.Free;
  end;
end;

function TExifData.LoadFromJPEG(const FileName: string): Boolean;
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    Result := inherited LoadFromJPEG(Stream);
  finally
    Stream.Free;
  end;
end;

type
  TJpegImageAccess = class(TJPEGImage);

procedure TExifData.LoadFromStream(Stream: TStream);
var
  Offset: LongInt;
begin
  inherited;
  Modified := False;
  if not FindThumbnailOffset(Stream, Offset) then Exit;
  Stream.Position := OffsetBase + Offset;
  { TJpegImage reads and stores the rest of the stream by default -> use ReadStream to
    prevent extraneous data being written out in our own SaveToStream method. }
  TJpegImageAccess(Thumbnail).ReadStream(GetJpegDataSize(Stream), Stream);
  Thumbnail.Modified := False;
  Modified := False;
end;

procedure TExifData.RemoveMakerNote;
begin
  Sections[esDetails].Remove(ttMakerNote);
end;

procedure TExifData.RemovePaddingTags;
var
  Section: TExifSection;
begin
  for Section in Self do
    Section.RemovePaddingTag;
end;

procedure TExifData.DoSaveToJPEG(InStream, OutStream: TStream); //forces proper order of JFIF -> Exif -> XMP
var
  BytesToSegment, InStreamStartPos: Int64;
  FoundMetadata: TJPEGMetadataKinds;
  I: Integer;
  Segment: IFoundJPEGSegment;
  SegmentsToSkip: IInterfaceList;
  SOFData: PJPEGStartOfFrameData;
  Tag: TExifTag;
begin
  if not StreamHasJpegHeader(InStream) then
    raise EInvalidJPEGHeader.Create(SInvalidJPEGHeader);
  InStreamStartPos := InStream.Position;
  for Tag in Sections[esDetails] do
    case Tag.ID of
      ttExifImageWidth, ttExifImageHeight:
      begin
        for Segment in JPEGHeader(InStream, StartOfFrameMarkers) do
          if Segment.Data.Size >= SizeOf(TJPEGStartOfFrameData) then
          begin
            SOFData := Segment.Data.Memory;
            ExifImageWidth := SOFData.ImageWidth;
            ExifImageHeight := SOFData.ImageHeight;
            Break;
          end;
        InStream.Position := InStreamStartPos;
        Break;
      end;
    end;
  FoundMetadata := [];
  SegmentsToSkip := TInterfaceList.Create;
  WriteJPEGHeaderToStream(OutStream);
  for Segment in JPEGHeader(InStream, [jmJFIF, jmApp1]) do
  begin
    if Segment.MarkerNum = jmJFIF then
      WriteJPEGSegmentToStream(OutStream, Segment)
    else
    begin
      if not (mkExif in FoundMetadata) and StreamHasExifHeader(Segment.Data) then
        Include(FoundMetadata, mkExif)
      else if not (mkXMP in FoundMetadata) and StreamHasXMPSegmentHeader(Segment.Data) then
        Include(FoundMetadata, mkXMP)
      else
        Continue;
    end;
    SegmentsToSkip.Add(Segment);
  end;
  if not Empty then
    WriteJPEGSegmentToStream(OutStream, TUserJPEGSegment.Create(jmApp1, Self));
  if XMPSegmentToLoad <> nil then
    WriteJPEGSegmentToStream(OutStream, XMPSegmentToLoad)
  else if not XMPPacket.Empty then
  begin
    XMPPacket.WriteSegmentHeader := True;
    WriteJPEGSegmentToStream(OutStream, TUserJPEGSegment.Create(jmApp1, XMPPacket));
  end;
  InStream.Position := InStreamStartPos + SizeOf(JpegFileHeader);
  for I := 0 to SegmentsToSkip.Count - 1 do
  begin
    Segment := IFoundJPEGSegment(SegmentsToSkip[I]);
    BytesToSegment := Segment.Offset - InStream.Position;
    if BytesToSegment > 0 then
      OutStream.CopyFrom(InStream, BytesToSegment);
    InStream.Seek(Segment.TotalSize, soCurrent)
  end;
  OutStream.CopyFrom(InStream, InStream.Size - InStream.Position);
  OutStream.Size := OutStream.Position;
end;

procedure TExifData.SaveToJPEG(const JPEGFileName: string);
var
  InStream: TMemoryStream;
  OutStream: TFileStream;
begin
  OutStream := nil;
  InStream := TMemoryStream.Create;
  try
    InStream.LoadFromFile(JPEGFileName);
    OutStream := TFileStream.Create(JPEGFileName, fmCreate);
    DoSaveToJPEG(InStream, OutStream);
  finally
    InStream.Free;
    OutStream.Free;
  end;
end;

procedure TExifData.SaveToJPEG(JPEGImage: TJPEGImage);
var
  InStream, OutStream: TMemoryStream;
begin
  OutStream := nil;
  InStream := TMemoryStream.Create;
  try
    JPEGImage.SaveToStream(InStream);
    OutStream := TMemoryStream.Create;
    DoSaveToJPEG(InStream, OutStream);
    OutStream.Position := 0;
    JPEGImage.LoadFromStream(OutStream);
  finally
    InStream.Free;
    OutStream.Free;
  end;
end;

type
  TSectionSavingInfo = record
    StartOffset, DirectorySize, OffsettedDataSize: Int64;
    function EndOffsetPlus1: LongWord; {$IFDEF CANINLINE}inline;{$ENDIF}
  end;

function TSectionSavingInfo.EndOffsetPlus1: LongWord;
begin
  Result := StartOffset + DirectorySize + OffsettedDataSize;
end;

procedure TExifData.SaveToStream(Stream: TStream); //Sections are written out in TExifSection order,
type                                               //with a section's offsetted data immediately
  TOffsetSectionKind = esDetails..esThumbnail;     //following its tag directory. If a MakerNote tag
const
  OffsetSectionKinds = [Low(TOffsetSectionKind)..High(TOffsetSectionKind)];
var                                                //exists and the MakerNotePosition property is the
  BaseStreamPos: Int64;                            //default or mpNeverMove, then sections are saved
  MakerNoteTag, MakerNoteOffsetTag: TExifTag;      //around the MakerNote data.
  MakerNoteDataOffset: Int64;
  PreserveMakerNotePos: Boolean;
  OffsetTags: array[TOffsetSectionKind] of TExifTag;
  SavingInfo: array[TExifSectionKind] of TSectionSavingInfo;

  procedure InitSavingInfo(Kind: TExifSectionKind;
    const OffsettedSections: array of TOffsetSectionKind);
  const
    OffsetTagIDs: array[TOffsetSectionKind] of TExifTagID = (ttExifOffset,
      ttInteropOffset, ttGPSOffset, ttThumbnailOffset);
  var
    Client: TOffsetSectionKind;
    Tag: TExifTag;
  begin
    for Client in OffsettedSections do
      if (SavingInfo[Client].DirectorySize > 0) or (Client = Kind){as for thumbnail} then
        OffsetTags[Client] := Sections[Kind].AddOrUpdate(OffsetTagIDs[Client],
          tdLongWord, 1, PLongWord(nil)^)
      else
        Sections[Kind].Remove(OffsetTagIDs[Client]);
    if (Kind <> esGeneral) and (Sections[Kind].Count = 0) then Exit; //don't write out empty sections
    for Tag in Sections[Kind] do
      if Tag.DataSize > 4 then Inc(SavingInfo[Kind].OffsettedDataSize, Tag.DataSize);
    SavingInfo[Kind].DirectorySize := 2 + (TagHeaderSize * Sections[Kind].Count) + 4; //length + tag recs + pos of next IFD
  end;

  procedure WriteDirectory(Kind: TExifSectionKind);
  var
    NextDataOffset: LongWord;
    Tag: TExifTag;
  begin
    if SavingInfo[Kind].DirectorySize = 0 then Exit;
    Stream.Position := BaseStreamPos + SizeOf(ExifHeader) + SavingInfo[Kind].StartOffset;
    Stream.WriteWord(Sections[Kind].Count, Endianness);
    NextDataOffset := SavingInfo[Kind].StartOffset + SavingInfo[Kind].DirectorySize;
    for Tag in Sections[Kind] do
      if (Tag = MakerNoteTag) and PreserveMakerNotePos then
        Tag.WriteHeader(Stream, Endianness, MakerNoteDataOffset)
      else
      begin
        Tag.WriteHeader(Stream, Endianness, NextDataOffset);
        if Tag.DataSize > 4 then
        begin
          if (Tag = MakerNoteTag) and (MakerNoteOffsetTag <> nil) then
            Inc(PLongInt(MakerNoteOffsetTag.Data)^, NextDataOffset - Tag.OriginalDataOffset);
          Inc(NextDataOffset, Tag.DataSize);
        end;
    end;
    if (Kind = esGeneral) and (SavingInfo[esThumbnail].DirectorySize <> 0) then
      Stream.WriteLongWord(SavingInfo[esThumbnail].StartOffset, Endianness)
    else
      Stream.WriteLongWord(0, Endianness);
    for Tag in Sections[Kind] do
      if (Tag <> MakerNoteTag) or not PreserveMakerNotePos then
        Tag.WriteOffsettedData(Stream, Endianness);
  end;
var
  Kind: TExifSectionKind;
  ThumbnailImageStream: TMemoryStream;
begin
  if RemovePaddingTagsOnSave then RemovePaddingTags;
  BaseStreamPos := Stream.Position;
  FillChar(OffsetTags, SizeOf(OffsetTags), 0);
  FillChar(SavingInfo, SizeOf(SavingInfo), 0);
  { initialise saving of the easy sections first }
  for Kind in [esInterop, esGPS] do
    InitSavingInfo(Kind, []);
  { initialise saving the details section, including MakerNote positioning }
  with Sections[esDetails] do
  begin
    PreserveMakerNotePos := False;
    MakerNoteOffsetTag := nil;
    {$WARN SYMBOL_DEPRECATED OFF}
    if Find(ttMakerNote, MakerNoteTag) and (MakerNoteTag.OriginalDataOffset <> 0) and (MakerNoteTag.DataSize > 4) then //if size is 4 or less, then data isn't offsetted
      case MakerNotePosition of
        mpAuto:
        begin //put it back if Windows has moved it
          MakerNoteDataOffset := MakerNoteTag.OriginalDataOffset;
          if Find(ttOffsetSchema, MakerNoteOffsetTag) and
             (MakerNoteOffsetTag.DataType = tdLongInt) and (MakerNoteOffsetTag.ElementCount = 1) and
             (MakerNoteDataOffset - PLongInt(MakerNoteOffsetTag.Data)^ > SizeOf(ExifHeader)) then
          begin
            Dec(MakerNoteDataOffset, PLongInt(MakerNoteOffsetTag.Data)^);
            PLongInt(MakerNoteOffsetTag.Data)^ := 0;
          end
          else
            MakerNoteOffsetTag := nil;
          PreserveMakerNotePos := True;
        end;
        mpCanMove: MakerNoteOffsetTag := AddOrUpdate(ttOffsetSchema, tdLongInt, 1);
        mpNeverMove:
        begin
          MakerNoteDataOffset := MakerNoteTag.OriginalDataOffset;
          PreserveMakerNotePos := True;
        end;
      end;
    {$WARN SYMBOL_DEPRECATED ON}
//      if (MakerNotePosition = mpNeverMove) or
//         ((MakerNotePosition = mpAuto) and not TagExists(ttOffsetSchema)) then
//        PreserveMakerNotePos := True
//      else
//      begin
//        MakerNoteOffsetTag := AddOrUpdate(ttOffsetSchema, tdLongInt, 1);
//        if (MakerNotePosition = mpAuto) and (PLongInt(MakerNoteOffsetTag.Data)^ = 0) then
//          PreserveMakerNotePos := True;
//      end;
  end;
  InitSavingInfo(esDetails, [esInterop]);
  if PreserveMakerNotePos then
    Dec(SavingInfo[esDetails].OffsettedDataSize, MakerNoteTag.DataSize);
  { initialise saving the thumbnail section }
  ThumbnailImageStream := nil;
  try
    if (FThumbnailOrNil <> nil) and not FThumbnailOrNil.Empty then
    begin
      ThumbnailImageStream := TMemoryStream.Create;
      FThumbnailOrNil.SaveToStream(ThumbnailImageStream);
      ThumbnailImageStream.Position := 0;
      ThumbnailImageStream.Size := GetJpegDataSize(ThumbnailImageStream);
      if ThumbnailImageStream.Size > MaxThumbnailSize then
      begin
        ThumbnailImageStream.Clear;
        StandardizeThumbnail;
        if FThumbnailOrNil.CompressionQuality > 90 then
          FThumbnailOrNil.CompressionQuality := 90;
        FThumbnailOrNil.SaveToStream(ThumbnailImageStream);
        Assert(ThumbnailImageStream.Size <= MaxThumbnailSize);
      end;
      with Sections[esThumbnail] do
      begin
        SetWordValue(ttCompression, 0, 6);
        SetLongWordValue(ttThumbnailSize, 0, ThumbnailImageStream.Size);
      end;
      InitSavingInfo(esThumbnail, [esThumbnail]);
      Inc(SavingInfo[esThumbnail].OffsettedDataSize, ThumbnailImageStream.Size);
    end;
    { initialise saving of the general section }
    InitSavingInfo(esGeneral, [esDetails, esGPS]);
    { calculate section positions }
    for Kind := Low(TExifSectionKind) to High(TExifSectionKind) do
    begin
      if Kind = esGeneral then
        SavingInfo[esGeneral].StartOffset := 8
      else
        SavingInfo[Kind].StartOffset := SavingInfo[Pred(Kind)].EndOffsetPlus1;
      if PreserveMakerNotePos and (SavingInfo[Kind].EndOffsetPlus1 > MakerNoteDataOffset) and
         (SavingInfo[Kind].StartOffset < MakerNoteDataOffset + MakerNoteTag.OriginalDataSize) then
        SavingInfo[Kind].StartOffset := MakerNoteDataOffset + MakerNoteTag.OriginalDataSize;
      if (Kind in OffsetSectionKinds) and (OffsetTags[Kind] <> nil) then
        if Kind = esThumbnail then
          PLongWord(OffsetTags[Kind].Data)^ := SavingInfo[Kind].EndOffsetPlus1 - ThumbnailImageStream.Size
        else
          PLongWord(OffsetTags[Kind].Data)^ := SavingInfo[Kind].StartOffset;
    end;
    { let's do the actual writing }
    Stream.WriteBuffer(ExifHeader, SizeOf(ExifHeader));
    if Endianness = BigEndian then
      Stream.WriteWord(TiffBigEndianCode, BigEndian)
    else
      Stream.WriteWord(TiffSmallEndianCode, SmallEndian);
    Stream.WriteWord(TiffMagicNum, Endianness);
    Stream.WriteLongWord(SavingInfo[esGeneral].StartOffset, Endianness);
    for Kind := Low(TExifSectionKind) to High(TExifSectionKind) do
      WriteDirectory(Kind);
    if ThumbnailImageStream <> nil then
      Stream.WriteBuffer(ThumbnailImageStream.Memory^, ThumbnailImageStream.Size);
    if PreserveMakerNotePos then
    begin
      Stream.Position := BaseStreamPos + SizeOf(ExifHeader) + MakerNoteDataOffset;
      Stream.WriteBuffer(MakerNoteTag.Data^, MakerNoteTag.DataSize);
    end;
  finally
    ThumbnailImageStream.Free;
  end;
end;

class function TExifData.SectionClass: TExifSectionClass;
begin
  Result := TExtendableExifSection;
end;

{ TJpegImageEx }

constructor TJpegImageEx.Create;
begin
  inherited;
  FExifData := TExifData.Create;
  FExifData.OnChange := Changed;
end;

destructor TJpegImageEx.Destroy;
begin
  FExifData.Free;
  inherited;
end;

procedure TJpegImageEx.Changed(Sender: TObject);
begin
  FChangedSinceLastLoad := True;
  inherited;
end;

procedure TJpegImageEx.CreateThumbnail(ThumbnailWidth, ThumbnailHeight: Integer);
begin
  if Empty then
    FExifData.Thumbnail := nil
  else
    CreateExifThumbnail(Self, FExifData.Thumbnail, ThumbnailWidth, ThumbnailHeight);
end;

function TJpegImageEx.GetXMPPacket: TXMPPacket;
begin
  Result := FExifData.XMPPacket;
end;

procedure TJpegImageEx.LoadFromStream(Stream: TStream);
begin
  inherited;
  ReloadExifData;
end;

procedure TJpegImageEx.ReadData(Stream: TStream);
begin
  inherited;
  ReloadExifData;
end;

procedure TJpegImageEx.ReloadExifData;
var
  MemStream: TMemoryStream;
begin
  if Empty then
    FExifData.Clear
  else
  begin
    MemStream := TMemoryStream.Create;
    try
      inherited SaveToStream(MemStream);
      MemStream.Position := 0;
      FExifData.LoadFromJPEG(MemStream)
    finally
      MemStream.Free;
    end;
  end;
  FChangedSinceLastLoad := False;
end;

procedure TJpegImageEx.SaveToStream(Stream: TStream);
var
  MemStream: TMemoryStream;
begin
  if not FChangedSinceLastLoad or Empty then
  begin
    inherited;
    Exit;
  end;
  MemStream := TMemoryStream.Create;
  try
    inherited SaveToStream(MemStream);
    MemStream.Position := 0;
    FExifData.OnChange := nil; //the ExifImageWidth/Height properties may be updated when saving
    FExifData.DoSaveToJPEG(MemStream, Stream);
  finally
    FExifData.OnChange := Changed;
    MemStream.Free;
  end;
end;

{ TExifMakerNote }

constructor TExifMakerNote.Create(ASection: TExifSection);
var
  HeaderSize: Integer;
  SourceTag: TExifTag;
  TiffInfo: TTiffInfo;
begin
  inherited Create;
  FTags := ASection;
  if ClassType = TUnrecognizedMakerNote then Exit;
  if not ASection.Owner[esDetails].Find(ttMakerNote, SourceTag) or not FormatIsOK(SourceTag,
    HeaderSize) then raise EInvalidMakerNoteFormat.Create(SInvalidMakerNoteFormat);
  FDataOffsetsType := doFromExifStart;
  TiffInfo.Endianness := Tags.Owner.Endianness;
  GetIFDInfo(SourceTag, TiffInfo.Endianness, FDataOffsetsType);
  case FDataOffsetsType of
    doFromExifStart: TiffInfo.BasePosition := -SourceTag.OriginalDataOffset;
    doFromMakerNoteStart: TiffInfo.BasePosition := 0;
    doFromIFDStart: TiffInfo.BasePosition := HeaderSize;
  end;
  TiffInfo.Stream := TUserMemoryStream.Create(SourceTag.Data, SourceTag.DataSize);
  try
    Tags.Load(TiffInfo, HeaderSize - TiffInfo.BasePosition, Tags.Owner.OffsetSchema);
    { When edited in Vista's Explorer, Exif data are *always* re-written in big endian
      format. Since MakerNotes are left 'as is', however, this means a parser can't rely
      on the container's endianness to determine the endianness of the MakerNote. So, if
      we get tag header load errors with the endianness suggested by GetIFDInfo, we'll
      try the other one too. }
    if (Tags.Count = 0) or ((Tags.LoadErrors <> []) and
      not (leBadOffset in Tags.LoadErrors) and (Tags.Count < 3)) then
    begin
      if TiffInfo.Endianness = SmallEndian then
        TiffInfo.Endianness := BigEndian
      else
        TiffInfo.Endianness := SmallEndian;
      Tags.Load(TiffInfo, HeaderSize - TiffInfo.BasePosition, Tags.Owner.OffsetSchema);
      if Tags.LoadErrors <> [] then Tags.Clear;
      if Tags.Count = 0 then Tags.LoadErrors := [leBadOffset];
    end;
  finally
    TiffInfo.Stream.Free;
  end;
  FEndianness := TiffInfo.Endianness;
end;

class function TExifMakerNote.FormatIsOK(SourceTag: TExifTag): Boolean;
var
  HeaderSize: Integer;
begin
  Result := (SourceTag.DataType = tdUndefined) and (SourceTag.ElementCount >= 2) and
    FormatIsOK(SourceTag, HeaderSize);
end;

procedure TExifMakerNote.GetIFDInfo(SourceTag: TExifTag;
  var ProbableEndianness: TEndianness; var DataOffsetsType: TExifDataOffsetsType);
begin
end;

{ TUnrecognizedMakerNote }

class function TUnrecognizedMakerNote.FormatIsOK(SourceTag: TExifTag; out HeaderSize: Integer): Boolean;
begin
  Result := False;
end;

{ TCanonSection }

class function TCanonMakerNote.FormatIsOK(SourceTag: TExifTag; out HeaderSize: Integer): Boolean;
begin
  HeaderSize := 0;
  Result := (SourceTag.Section.Owner.CameraMake = 'Canon'); //as no header, we'll look for something else
end;

procedure TCanonMakerNote.GetIFDInfo(SourceTag: TExifTag;
  var ProbableEndianness: TEndianness; var DataOffsetsType: TExifDataOffsetsType);
begin
  ProbableEndianness := SmallEndian;
end;

{ TPanasonicSection }

class function TPanasonicMakerNote.FormatIsOK(SourceTag: TExifTag;
  out HeaderSize: Integer): Boolean;
begin
  HeaderSize := SizeOf(Header);
  Result := (SourceTag.ElementCount > HeaderSize) and
    CompareMem(SourceTag.Data, @Header, HeaderSize);
end;

procedure TPanasonicMakerNote.GetIFDInfo(SourceTag: TExifTag;
  var ProbableEndianness: TEndianness; var DataOffsetsType: TExifDataOffsetsType);
begin
  ProbableEndianness := SmallEndian;
end;

{ TNikonType1MakerNote }

class function TNikonType1MakerNote.FormatIsOK(SourceTag: TExifTag;
  out HeaderSize: Integer): Boolean;
begin
  HeaderSize := SizeOf(Header);
  Result := (SourceTag.ElementCount > HeaderSize) and
    CompareMem(SourceTag.Data, @Header, HeaderSize);
end;

{ TSonyMakerNote }

class function TSonyMakerNote.FormatIsOK(SourceTag: TExifTag;
  out HeaderSize: Integer): Boolean;
begin
  HeaderSize := 12;
  Result := (SourceTag.ElementCount > HeaderSize) and
    CompareMem(SourceTag.Data, @Header, SizeOf(Header));
end;

procedure TSonyMakerNote.GetIFDInfo(SourceTag: TExifTag;
  var ProbableEndianness: TEndianness; var DataOffsetsType: TExifDataOffsetsType);
begin
  if SourceTag.Section.Owner.CameraModel = 'DSLR-A100' then
    ProbableEndianness := BigEndian
  else
    ProbableEndianness := SmallEndian;
end;

initialization
  TCustomExifData.FMakerNoteClasses := TList.Create;
  TCustomExifData.FMakerNoteClasses.Add(TCanonMakerNote);
  TCustomExifData.FMakerNoteClasses.Add(TPanasonicMakerNote);
  TCustomExifData.FMakerNoteClasses.Add(TNikonType1MakerNote);
  TCustomExifData.FMakerNoteClasses.Add(TSonyMakerNote);
{$IFDEF MSWINDOWS}
  if IsConsole and Assigned(InitProc) then
  begin                   //TXMPPacket implicitly uses MSXML, which requires CoInitialize
    TProcedure(InitProc); //or CoInitializeEx to be called. This will be done
    InitProc := nil;      //automatically with a VCL app (the RTL's MSXML wrapper uses
  end;                    //ComObj.pas, which assigns InitProc, which is called by
{$ENDIF}                  //Application.Initialize), but not in a console one.
finalization
  TCustomExifData.FMakerNoteClasses.Free;
end.
