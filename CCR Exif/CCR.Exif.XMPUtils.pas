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
{ The Original Code is CCR.Exif.XMPUtils.pas.                                          }
{                                                                                      }
{ The Initial Developer of the Original Code is Chris Rolliston. Portions created by   }
{ Chris Rolliston are Copyright (C) 2009 Chris Rolliston. All Rights Reserved.         }
{                                                                                      }
{**************************************************************************************}

unit CCR.Exif.XMPUtils;
{
  This unit implements a IDOMDocument/IDOMNode-based XMP packet parser and editor.

  The only slightly funky thing here is the UpdateXXX methods of TXMPPacket, which are
  called automatically when you set a tag property of TCustomExifData. Basically, the
  methods' behaviour depends upon the TXMPPacket's UpdatePolicy property, which has
  three possible values:
  - xwAlwaysUpdate: if the new value is an empty string, then the XMP property is
    deleted, else it is changed (or added). This setting is the default for standalone
    TXMPPacket instances.
  - xwUpdateIfExists: any existing property is updated, but if it doesn't already exist,
    no property is added. This setting is the default for an TXMPPacket instance that is
    attached to a TCustomExifData object; change this to xwAlwaysUpdate to mimic Windows
    Vista's behaviour.
  - xwRemove: always removes the property when UpdateProperty is called.
}
interface

uses
  SysUtils, Classes, xmldom;

type
  EInvalidXMPPacket = class(Exception);
  EInvalidXMPOperation = class(EInvalidOperation);

  TXMPProperty = class;
  TXMPSchema = class;
  TXMPPacket = class;

  IXMPPropertyEnumerator = interface
  ['{32054DDD-5415-4F5D-8A38-C79BBCFD1A50}']
    function GetCurrent: TXMPProperty;
    function MoveNext: Boolean;
    property Current: TXMPProperty read GetCurrent;
  end;

  IXMPPropertyCollection = interface
  ['{A72E8B43-34AE-49E8-A889-36B51B6A6E48}']
    function GetProperty(Index: Integer): TXMPProperty;
    function GetPropertyCount: Integer;
    function GetEnumerator: IXMPPropertyEnumerator;
    property Count: Integer read GetPropertyCount;
    property Items[Index: Integer]: TXMPProperty read GetProperty; default;
  end;

  TXMPPropertyKind = (xpSimple, xpStructure, xpAltArray, xpBagArray, xpSeqArray);

  TXMPProperty = class(TInterfacedPersistent, IXMPPropertyCollection)
  strict private
    FDataNode, FRootNode: IDOMNode;
    FKind: TXMPPropertyKind;
    FKindInitialized: Boolean;
    FParentProperty: TXMPProperty;
    FSchema: TXMPSchema;
    FSubProperties: TList;
    function GetKind: TXMPPropertyKind;
    procedure SetKind(const Value: TXMPPropertyKind);
    procedure SetSubPropertyCount(NewCount: Integer);
    function GetName: DOMString;
  protected
    function GetSubProperty(Index: Integer): TXMPProperty;
    function GetSubPropertyByName(const AName: string): TXMPProperty;
    function GetSubPropertyCount: Integer;
    function IXMPPropertyCollection.GetProperty = GetSubProperty;
    function IXMPPropertyCollection.GetPropertyCount = GetSubPropertyCount;
    procedure SubPropertiesNeeded;
    property RootNode: IDOMNode read FRootNode;
  public
    class function SupportsSubProperties(Kind: TXMPPropertyKind): Boolean; overload; static; inline;
  public
    constructor Create(ASchema: TXMPSchema; AParentProperty: TXMPProperty;
      const ARootNode: IDOMNode);
    destructor Destroy; override;
    function GetEnumerator: IXMPPropertyEnumerator;
    function AddSubProperty(const AName: DOMString): TXMPProperty; //AName is ignored if self is an array property
    function FindSubProperty(const AName: string; out Prop: TXMPProperty): Boolean;
    function ReadValue(const Default: Boolean): Boolean; overload;
    function ReadValue(const Default: Integer): Integer; overload;
    function ReadValue(const Default: DOMString = ''): DOMString; overload;
    function RemoveSubProperty(const AName: string): Boolean;
    function SupportsSubProperties: Boolean; overload;
    procedure UpdateSubProperty(const SubPropName: string;
      SubPropKind: TXMPPropertyKind; const NewValue: DOMString); overload;
    procedure UpdateSubProperty(const SubPropName: string;
      const NewValue: DOMString); overload; inline;
    procedure UpdateSubProperty(const SubPropName: string; NewValue: Integer); overload;
    procedure UpdateSubProperty(const SubPropName: string; NewValue: Boolean); overload;
    procedure WriteValue(const NewValue: DOMString); overload;
    procedure WriteValue(const NewValue: Integer); overload;
    procedure WriteValue(const NewValue: Boolean); overload;
    property Kind: TXMPPropertyKind read GetKind write SetKind;
    property Name: DOMString read GetName;
    property ParentProperty: TXMPProperty read FParentProperty;
    property Schema: TXMPSchema read FSchema;
    property SubProperties[const Name: string]: TXMPProperty read GetSubPropertyByName; default; //adds if necessary
    property SubProperties[Index: Integer]: TXMPProperty read GetSubProperty; default;
    property SubPropertyCount: Integer read GetSubPropertyCount write SetSubPropertyCount;
  end;

  TXMPSchemaKind = (xsUnknown, xsCameraRaw, xsDublinCore, xsExif, xsMicrosoftPhoto,
    xsPDF, xsPhotoshop, xsTIFF, xsXMPBasic, xsXMPBasicJobTicket, xsXMPDynamicMedia,
    xsXMPMediaManagement, xsXMPPagedText, xsXMPRights);
  TXMPKnownSchemaKind = xsCameraRaw..High(TXMPSchemaKind);
  TXMPKnownSchemaKinds = set of TXMPKnownSchemaKind;

  TXMPSchema = class(TInterfacedPersistent, IXMPPropertyCollection)
  strict private
    FKind: TXMPSchemaKind;
    FMainRootNode: IDOMElement;
    FOwner: TXMPPacket;
    FPreferredPrefix: string;
    FProperties: TList;
    FURI: string;
  protected
    function AddProperty(const ARootNode: IDOMNode): TXMPProperty; overload;
    function FindOrAddProperty(const AName: string): TXMPProperty;
    function GetOwner: TPersistent; override;
    function GetProperty(Index: Integer): TXMPProperty;
    function GetPropertyCount: Integer;
    property MainRootNode: IDOMElement read FMainRootNode;
  public
    constructor Create(AOwner: TXMPPacket; const ARootNode: IDOMElement; const AURI: string);
    destructor Destroy; override;
    function GetEnumerator: IXMPPropertyEnumerator;
    function AddProperty(const AName: string): TXMPProperty; overload;
    function FindProperty(const AName: string; var AProperty: TXMPProperty): Boolean;
    function RemoveProperty(const AName: string): Boolean;
    property Kind: TXMPSchemaKind read FKind;
    property Owner: TXMPPacket read FOwner;
    property PreferredPrefix: string read FPreferredPrefix write FPreferredPrefix;
    property Properties[const Name: string]: TXMPProperty read FindOrAddProperty; default;
    property Properties[Index: Integer]: TXMPProperty read GetProperty; default;
    property PropertyCount: Integer read GetPropertyCount;
    property URI: string read FURI;
  end;

  TXMPWritePolicy = (xwAlwaysUpdate, xwUpdateIfExists, xwRemove);

  TXMPPacket = class(TInterfacedPersistent, IStreamPersist)
  public type
    TEnumerator = record
    private
      FIndex: Integer;
      FPacket: TXMPPacket;
      function GetCurrent: TXMPSchema;
    public
      constructor Create(Packet: TXMPPacket);
      function MoveNext: Boolean;
      property Current: TXMPSchema read GetCurrent;
    end;
  strict private
    FAboutAttributeValue: DOMString;
    FDocument: IDOMDocument;
    FDOMVendor: TDOMVendor;
    FRootRDFNode: IDOMNode;
    FSchemas: TStringList;
    FUpdatePolicy: TXMPWritePolicy;
    FWriteSegmentHeader: Boolean;
    function FindOrAddSchema(SchemaNode: IDOMElement; const URI: string): TXMPSchema; overload;
    function GetAboutAttributeValue: DOMString;
    function GetDOMVendor: TDOMVendor;
    function GetEmpty: Boolean;
    function GetRawXML: DOMString;
    function GetSchema(Index: Integer): TXMPSchema;
    function GetSchemaCount: Integer;
    procedure SetAboutAttributeValue(const Value: DOMString);
    procedure DoUpdateProperty(Policy: TXMPWritePolicy; SchemaKind: TXMPKnownSchemaKind;
      const PropName: string; PropKind: TXMPPropertyKind; const NewValue: DOMString);
    procedure DoUpdateArrayProperty(SchemaKind: TXMPKnownSchemaKind;
      const PropName: string; ArrayPropKind: TXMPPropertyKind;
      const NewValues: array of DOMString); overload;
  protected
    procedure DocumentNeeded;
    function FindOrAddSchema(const URI: string): TXMPSchema; overload;
    function FindOrAddSchema(Kind: TXMPKnownSchemaKind): TXMPSchema; overload;
    property Document: IDOMDocument read FDocument;
    property RootRDFNode: IDOMNode read FRootRDFNode;
    property UpdatePolicy: TXMPWritePolicy read FUpdatePolicy write FUpdatePolicy;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function FindSchema(const URI: string; var Schema: TXMPSchema): Boolean; overload;
    function FindSchema(Kind: TXMPKnownSchemaKind; var Schema: TXMPSchema): Boolean; overload;
    function GetEnumerator: TEnumerator;
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromStream(Stream: TStream); overload;
    procedure SaveToFile(const FileName: string);
    procedure SaveToStream(Stream: TStream);
    function TryLoadFromStream(Stream: TStream): Boolean;
    procedure RemoveProperty(SchemaKind: TXMPKnownSchemaKind;
      const PropName: string); overload;
    procedure RemoveProperty(SchemaKind: TXMPKnownSchemaKind;
      const PropNames: array of string); overload;
    procedure UpdateProperty(SchemaKind: TXMPKnownSchemaKind; const PropName: string;
      PropKind: TXMPPropertyKind; const NewValue: DOMString); overload;
    procedure UpdateBagProperty(SchemaKind: TXMPKnownSchemaKind; const PropName: string;
      const NewValues: array of DOMString); overload;
    procedure UpdateBagProperty(SchemaKind: TXMPKnownSchemaKind; const PropName: string;
      const NewValueList: DOMString); overload; inline; //commas and/or semi-colons act as delimiters
    procedure UpdateSeqProperty(SchemaKind: TXMPKnownSchemaKind; const PropName: string;
      const NewValues: array of DOMString); overload;
    procedure UpdateSeqProperty(SchemaKind: TXMPKnownSchemaKind; const PropName: string;
      const NewValueList: DOMString); overload; inline; //commas and/or semi-colons act as delimiters
    procedure UpdateProperty(SchemaKind: TXMPKnownSchemaKind;
      const PropName: string; const NewValue: DOMString); overload; inline;
    procedure UpdateProperty(SchemaKind: TXMPKnownSchemaKind;
      const PropName: string; const NewValue: Integer); overload;
    procedure UpdateDateTimeProperty(SchemaKind: TXMPKnownSchemaKind;
      const PropName: string; const NewValue: TDateTime; ApplyLocalBias: Boolean = False); overload;
    property AboutAttributeValue: DOMString read GetAboutAttributeValue write SetAboutAttributeValue;
    property DOMVendor: TDOMVendor read GetDOMVendor write FDOMVendor;
    property Empty: Boolean read GetEmpty;
    property RawXML: DOMString read GetRawXML;
    property SchemaCount: Integer read GetSchemaCount;
    property Schemas[Kind: TXMPKnownSchemaKind]: TXMPSchema read FindOrAddSchema; default;
    property Schemas[Index: Integer]: TXMPSchema read GetSchema; default;
    property Schemas[const URI: string]: TXMPSchema read FindOrAddSchema; default;
    property WriteSegmentHeader: Boolean read FWriteSegmentHeader write FWriteSegmentHeader;
  end;

  TXMPKnownSchemaInfo = record
    Kind: TXMPKnownSchemaKind;
    PreferredPrefix, URI: string;
  end;

const
  KnownXMPSchemas: array[TXMPKnownSchemaKind] of TXMPKnownSchemaInfo = (
    (Kind: xsCameraRaw; PreferredPrefix: 'crs';
      URI: 'http://ns.adobe.com/camera-raw-settings/1.0/'),
    (Kind: xsDublinCore; PreferredPrefix: 'dc';
      URI: 'http://purl.org/dc/elements/1.1/'),
    (Kind: xsExif; PreferredPrefix: 'exif';
      URI: 'http://ns.adobe.com/exif/1.0/'),
    (Kind: xsMicrosoftPhoto; PreferredPrefix: 'MicrosoftPhoto';
      URI: 'http://ns.microsoft.com/photo/1.0'),
    (Kind: xsPDF; PreferredPrefix: 'pdf';
      URI: 'http://ns.adobe.com/pdf/1.3/'),
    (Kind: xsPhotoshop; PreferredPrefix: 'photoshop';
      URI: 'http://ns.adobe.com/photoshop/1.0/'),
    (Kind: xsTIFF; PreferredPrefix: 'tiff';
      URI: 'http://ns.adobe.com/tiff/1.0/'),
    (Kind: xsXMPBasic; PreferredPrefix: 'xmp';
      URI: 'http://ns.adobe.com/xap/1.0/'),
    (Kind: xsXMPBasicJobTicket; PreferredPrefix: 'xmpBJ';
      URI: 'http://ns.adobe.com/xap/1.0/bj/'),
    (Kind: xsXMPDynamicMedia; PreferredPrefix: 'xmpDM';
      URI: 'http://ns.adobe.com/xmp/1.0/DynamicMedia/'),
    (Kind: xsXMPMediaManagement; PreferredPrefix: 'xmpMM';
      URI: 'http://ns.adobe.com/xap/1.0/mm/'),
    (Kind: xsXMPPagedText; PreferredPrefix: 'xmpTPg';
      URI: 'http://ns.adobe.com/xap/1.0/t/pg/'),
    (Kind: xsXMPRights; PreferredPrefix: 'xmpRights';
      URI: 'http://ns.adobe.com/xap/1.0/rights/'));

const
  XMPBoolStrs: array[Boolean] of string = ('False', 'True'); //case as per the XMP spec
  XMPSegmentHeader: array[0..28] of AnsiChar = 'http://ns.adobe.com/xap/1.0/'#0;

function DateTimeToXMPString(Value: TDateTime; ApplyLocalBias: Boolean): DOMString;

implementation

uses Math, RTLConsts, Contnrs, StrUtils, WideStrings, XSBuiltIns, //XSBuiltIns for DateTimeToXMLTime
  CCR.Exif.Consts, CCR.Exif.StreamHelper;

function DateTimeToXMPString(Value: TDateTime; ApplyLocalBias: Boolean): DOMString;
begin
  Result := DateTimeToXMLTime(Value, ApplyLocalBias)
end;

const
  XMLLangAttrName = 'xml:lang';
  DefaultLangIdent = 'x-default';

type
  RDF = record const
    URI = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#';
    PreferredPrefix = 'rdf';
    AboutAttrLocalName = 'about';
    AboutAttrName = PreferredPrefix + ':' + AboutAttrLocalName;
    AltNodeName = PreferredPrefix + ':' + 'Alt';
    BagNodeName = PreferredPrefix + ':' + 'Bag';
    DescriptionNodeName = PreferredPrefix + ':' + 'Description';
    ListNodeLocalName = 'li';
    ListNodeName = PreferredPrefix + ':' + ListNodeLocalName;
    SeqNodeName = PreferredPrefix + ':' + 'Seq';
  end;

  TStringListThatOwnsItsObjects = class(TStringList)
  public
    destructor Destroy; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
  end;

  TUnicodeStringList = {$IFDEF UNICODE}TStringList{$ELSE}TWideStringList{$ENDIF};

  TXMPPropertyEnumerator = class(TInterfacedObject, IXMPPropertyEnumerator)
  strict private
    FIndex: Integer;
    FSource: TList;
  protected
    function GetCurrent: TXMPProperty;
    function MoveNext: Boolean;
  public
    constructor Create(Source: TList);
  end;

destructor TStringListThatOwnsItsObjects.Destroy;
begin
  Clear;
  inherited;
end;

procedure TStringListThatOwnsItsObjects.Clear;
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do
    Objects[I].Free;
  inherited;
end;

procedure TStringListThatOwnsItsObjects.Delete(Index: Integer);
begin
  Objects[Index].Free;
  inherited;
end;

{ TXMPPropertyEnumerator }

constructor TXMPPropertyEnumerator.Create(Source: TList);
begin
  FIndex := -1;
  FSource := Source;
end;

function TXMPPropertyEnumerator.GetCurrent: TXMPProperty;
begin
  Result := FSource[FIndex];
end;

function TXMPPropertyEnumerator.MoveNext: Boolean;
begin
  Inc(FIndex);
  Result := (FIndex < FSource.Count);
end;

{ TXMPProperty }

class function TXMPProperty.SupportsSubProperties(Kind: TXMPPropertyKind): Boolean;
begin
  Result := (Kind in [xpAltArray, xpBagArray, xpSeqArray, xpStructure]);
end;

constructor TXMPProperty.Create(ASchema: TXMPSchema; AParentProperty: TXMPProperty;
  const ARootNode: IDOMNode);
begin
  Assert(ARootNode <> nil);
  FParentProperty := AParentProperty;
  FRootNode := ARootNode;
  FSchema := ASchema;
end;

destructor TXMPProperty.Destroy;
begin
  FSubProperties.Free;
  inherited;
end;

function TXMPProperty.AddSubProperty(const AName: DOMString): TXMPProperty;
var
  NewNode: IDOMNode;
begin
  if not SupportsSubProperties(Kind) then
    raise EInvalidXMPOperation.Create(SSubPropertiesNotSupported);
  if (AName = '') and (FKind in [xpAltArray, xpStructure]) then
    raise EInvalidXMPOperation.Create(SSubPropertiesMustBeNamed);
  if FKind = xpStructure then
    NewNode := FRootNode.ownerDocument.createElementNS(FRootNode.namespaceURI,
      FRootNode.prefix + ':' + AName)
  else
  begin
    NewNode := FRootNode.ownerDocument.createElementNS(RDF.URI, RDF.ListNodeName);
    NewNode.attributes.setNamedItemNS(FRootNode.ownerDocument.createAttribute(
      XMLLangAttrName)).nodeValue := AName;
  end;
  Assert(FDataNode <> nil);
  FDataNode.appendChild(NewNode);
  Result := TXMPProperty.Create(Schema, Self, NewNode);
  FSubProperties.Add(Result);
end;

function TXMPProperty.FindSubProperty(const AName: string; out Prop: TXMPProperty): Boolean;
var
  AttrNode: IDOMNode;
  I: Integer;
  LocalNameToFind: string;
begin
  case FKind of
    xpAltArray: LocalNameToFind := RDF.ListNodeLocalName;
    xpStructure: LocalNameToFind := AName;
  else
    Result := False;
    Exit;
  end;
  Result := True;
  for I := 0 to SubPropertyCount - 1 do
  begin
    Prop := TXMPProperty(FSubProperties.List[I]);
    if Prop.RootNode.localName = LocalNameToFind then
      if FKind = xpStructure then
        Exit
      else
      begin
        AttrNode := Prop.RootNode.attributes.getNamedItem(XMLLangAttrName);
        if (AttrNode <> nil) and SameText(AttrNode.nodeValue, AName) then Exit; //language identifies should
      end;                                                                      //be case insensitive according
  end;                                                                          //to the XMP spec
  Prop := nil;
  Result := False;
end;

function TXMPProperty.GetEnumerator: IXMPPropertyEnumerator;
begin
  SubPropertiesNeeded;
  Result := TXMPPropertyEnumerator.Create(FSubProperties);
end;

function TXMPProperty.GetKind: TXMPPropertyKind;
var
  S: string;
begin
  if not FKindInitialized then
  begin
    FKindInitialized := True;
    FKind := xpSimple;
    FDataNode := FRootNode.firstChild;
    while FDataNode <> nil do
    begin
      case FDataNode.nodeType of
        TEXT_NODE: Break;
        ELEMENT_NODE:
          if (ParentProperty = nil) or (ParentProperty.Kind = xpStructure) then
          begin
            S := FDataNode.nodeName;
            if S = RDF.AltNodeName then
              FKind := xpAltArray
            else if S = RDF.BagNodeName then
              FKind := xpBagArray
            else if S = RDF.SeqNodeName then
              FKind := xpSeqArray
            else if S = RDF.DescriptionNodeName then
              FKind := xpStructure;
            Break;
          end
      end;
      FDataNode := FDataNode.nextSibling;
    end;
  end;
  Result := FKind;
end;

function TXMPProperty.GetName: DOMString;
var
  AttrNode: IDOMNode;
begin
  if ParentProperty = nil then
    Result := FRootNode.localName
  else
    case ParentProperty.Kind of
      xpBagArray, xpSeqArray: Result := '';
      xpAltArray:
      begin
        AttrNode := FRootNode.attributes.getNamedItem(XMLLangAttrName);
        if AttrNode <> nil then
          Result := AttrNode.nodeValue
        else
          Result := '';
      end
    else Result := FRootNode.localName;
    end;
end;

function TXMPProperty.GetSubProperty(Index: Integer): TXMPProperty;
begin
  SubPropertiesNeeded;
  Result := TXMPProperty(FSubProperties[Index]);
end;

function TXMPProperty.GetSubPropertyByName(const AName: string): TXMPProperty;
begin
  if not FindSubProperty(AName, Result) then
    Result := AddSubProperty(AName);
end;

function TXMPProperty.GetSubPropertyCount: Integer;
begin
  SubPropertiesNeeded;
  Result := FSubProperties.Count;
end;

function TXMPProperty.ReadValue(const Default: Boolean): Boolean;
var
  S: string;
begin
  S := ReadValue;
  if SameText(S, XMPBoolStrs[True]) then
    Result := True
  else if SameText(S, XMPBoolStrs[False]) then
    Result := False
  else if S = '1' then
    Result := True
  else if S = '0' then
    Result := False
  else
    Result := Default;
end;

function TXMPProperty.ReadValue(const Default: Integer): Integer;
begin
  Result := StrToIntDef(ReadValue, Default);
end;

function TXMPProperty.ReadValue(const Default: DOMString): DOMString;
var
  I: Integer;
begin
  case Kind of
    xpSimple: if FDataNode <> nil then Result := FDataNode.nodeValue else Result := Default;
    xpAltArray: Result := SubProperties[DefaultLangIdent].ReadValue(Default);
    xpBagArray, xpSeqArray:
      case SubPropertyCount of
        0: Result := Default;
        1: Result := SubProperties[0].ReadValue(Default);
      else
        Result := SubProperties[0].ReadValue;
        for I := 1 to SubPropertyCount - 1 do
          Result := Result + ',' + SubProperties[I].ReadValue;
      end;
  else Result := Default;
  end;
end;

function TXMPProperty.RemoveSubProperty(const AName: string): Boolean;
var
  I: Integer;
  Prop: TXMPProperty;
begin
  Result := False;
  for I := 0 to FSubProperties.Count - 1 do
  begin
    Prop := FSubProperties.List[I];
    if AName = Prop.Name then
    begin
      FDataNode.removeChild(Prop.RootNode);
      FSubProperties.Delete(I);
      Result := True;
      Break;
    end;
  end;
end;

procedure TXMPProperty.SetKind(const Value: TXMPPropertyKind);
const
  ArrayKinds = [xpBagArray, xpSeqArray];
var
  I: Integer;
  SavedInfo: array of record
    Name, Value: DOMString;
  end;
  SavedSingleValue: DOMString;
  NewName: string;
begin
  if Value = Kind then Exit;
  if not SupportsSubProperties(Value) then
    SavedSingleValue := ReadValue
  else
  begin
    SetLength(SavedInfo, SubPropertyCount);
    for I := High(SavedInfo) downto 0 do
    begin
      SavedInfo[I].Name := SubProperties[I].Name;
      SavedInfo[I].Value := SubProperties[I].ReadValue;
    end;
  end;
  if FDataNode <> nil then
  begin
    FRootNode.removeChild(FDataNode);
    FDataNode := nil;
  end;
  FKind := Value;
  if FSubProperties <> nil then FSubProperties.Clear;
  if not SupportsSubProperties(Value) then
  begin
    WriteValue(SavedSingleValue);
    Exit;
  end;
  case Value of
    xpAltArray: NewName := RDF.AltNodeName;
    xpBagArray: NewName := RDF.BagNodeName;
    xpSeqArray: NewName := RDF.SeqNodeName;
    xpStructure: NewName := RDF.DescriptionNodeName;
  else Assert(False);
  end;
  FDataNode := FRootNode.ownerDocument.createElementNS(RDF.URI, NewName);
  FRootNode.appendChild(FDataNode);
  for I := 0 to High(SavedInfo) do
    AddSubProperty(SavedInfo[I].Name).WriteValue(SavedInfo[I].Value);
end;

//procedure TXMPProperty.SetName(const Value: DOMString);
//begin
//  if ParentProperty <> nil then
//    case ParentProperty.Kind of
//      xpAltArray: ;
//      xpStructure: ;
//    else raise EInvalidXMPOperation.Create(SNamedSubPropertiesNotSupported);
//    end;             //urgh - nodeName not writeable...
//  FRootNode.nodeName := MakeNodeName(FRootNode.prefix
//end;

procedure TXMPProperty.SetSubPropertyCount(NewCount: Integer);
var
  I: Integer;
  NewNode: IDOMNode;
  NewNodeName, NewNodeURI: DOMString;
begin
  if NewCount < 0 then NewCount := 0;
  if NewCount = SubPropertyCount then Exit;
  if not SupportsSubProperties(FKind) then
    raise EInvalidXMPOperation.Create(SSubPropertiesNotSupported);
  for I := SubPropertyCount - 1 downto NewCount do
    FDataNode.removeChild(SubProperties[I].RootNode);
  if FKind = xpStructure then
  begin
    NewNodeName := FRootNode.prefix + ':NewSubProperty';
    NewNodeURI := FRootNode.namespaceURI;
  end
  else
  begin
    NewNodeName := RDF.ListNodeName;
    NewNodeURI := RDF.URI;
  end;
  for I := SubPropertyCount to NewCount - 1 do
  begin
    NewNode := FRootNode.ownerDocument.createElementNS(NewNodeURI, NewNodeName);
    if FKind = xpAltArray then
      NewNode.attributes.setNamedItemNS(FRootNode.ownerDocument.createAttribute(XMLLangAttrName));
    FSubProperties.Add(TXMPProperty.Create(Schema, Self, NewNode));
  end;
end;

procedure TXMPProperty.SubPropertiesNeeded;
var
  Child: IDOMNode;
  DoAdd: Boolean;
begin
  if FSubProperties <> nil then Exit;
  FSubProperties := TObjectList.Create;
  if not SupportsSubProperties then Exit;
  FSubProperties.Capacity := FDataNode.childNodes.length;
  Child := FDataNode.firstChild;
  while Child <> nil do
  begin
    DoAdd := False;
    if Child.nodeType = ELEMENT_NODE then
    begin
      if FKind = xpStructure then
        DoAdd := True
      else if Child.nodeName = RDF.ListNodeName then
        DoAdd := (FKind <> xpAltArray) or
          (Child.attributes.getNamedItem(XMLLangAttrName) <> nil);
    end;
    if DoAdd then
      FSubProperties.Add(TXMPProperty.Create(Schema, Self, Child));
    Child := Child.nextSibling;
  end;
end;

function TXMPProperty.SupportsSubProperties: Boolean;
begin
  Result := SupportsSubProperties(Kind);
end;

procedure TXMPProperty.UpdateSubProperty(const SubPropName: string;
  SubPropKind: TXMPPropertyKind; const NewValue: DOMString);
var
  SubProp: TXMPProperty;
begin
  if (FSchema.Owner.UpdatePolicy = xwRemove) or (NewValue = '') then
  begin
    RemoveSubProperty(SubPropName);
    Exit;
  end;
  if not FindSubProperty(SubPropName, SubProp) then
  begin
    if FSchema.Owner.UpdatePolicy = xwUpdateIfExists then Exit;
    if not (Kind in [xpStructure, xpAltArray]) then Kind := xpStructure;
    SubProp := AddSubProperty(SubPropName)
  end;
  SubProp.Kind := SubPropKind;
  SubProp.WriteValue(NewValue);
end;

procedure TXMPProperty.UpdateSubProperty(const SubPropName: string;
  const NewValue: DOMString);
begin
  UpdateSubProperty(SubPropName, xpSimple, NewValue);
end;

procedure TXMPProperty.UpdateSubProperty(const SubPropName: string; NewValue: Integer);
begin
  UpdateSubProperty(SubPropName, xpSimple, IntToStr(NewValue));
end;

procedure TXMPProperty.UpdateSubProperty(const SubPropName: string; NewValue: Boolean);
begin
  UpdateSubProperty(SubPropName, xpSimple, XMPBoolStrs[NewValue]);
end;

procedure TXMPProperty.WriteValue(const NewValue: DOMString);
var
  I, BeginPos, TotalLen: Integer;
  Strings: TUnicodeStringList;
begin
  case Kind of
    xpSimple:
      if FDataNode <> nil then
        FDataNode.nodeValue := NewValue
      else
      begin
        FDataNode := FRootNode.ownerDocument.createTextNode(NewValue);
        FRootNode.appendChild(FDataNode);
      end;
    xpStructure: raise EInvalidXMPOperation.Create(SCannotWriteSingleValueToStructureProperty);
    xpAltArray: SubProperties[DefaultLangIdent].WriteValue(NewValue);
  else
    Strings := TUnicodeStringList.Create;
    try
      BeginPos := 1;
      TotalLen := Length(NewValue);
      for I := 1 to TotalLen do
        if AnsiChar(NewValue[I]) in [',', ';'] then //cast to avoid compiler warning
        begin
          Strings.Add(Copy(NewValue, BeginPos, I - BeginPos));
          BeginPos := I + 1;
        end;
      if BeginPos <= TotalLen then Strings.Add(Copy(NewValue, BeginPos, TotalLen));
      SubPropertyCount := Strings.Count;
      for I := 0 to Strings.Count - 1 do
        SubProperties[I].WriteValue(Strings[I]);
    finally
      Strings.Free;
    end;
  end;
end;

procedure TXMPProperty.WriteValue(const NewValue: Integer);
begin
  WriteValue(IntToStr(NewValue));
end;

procedure TXMPProperty.WriteValue(const NewValue: Boolean);
begin
  WriteValue(XMPBoolStrs[NewValue]);
end;

{ TXMPSchema }

constructor TXMPSchema.Create(AOwner: TXMPPacket; const ARootNode: IDOMElement; const AURI: string);
var
  Info: TXMPKnownSchemaInfo;
begin
  Assert((ARootNode <> nil) and (AURI <> ''));
  for Info in KnownXMPSchemas do
    if SameText(AURI, Info.URI) then
    begin
      FKind := Info.Kind;
      FPreferredPrefix := Info.PreferredPrefix;
      ARootNode.setAttributeNS(SXMLNamespaceURI, SXMLNS + NSDelim + Info.PreferredPrefix,
        Info.URI);
      Break;
    end;
  FMainRootNode := ARootNode;
  FOwner := AOwner;
  FProperties := TObjectList.Create;
  FURI := AURI;
end;

destructor TXMPSchema.Destroy;
begin
  FProperties.Free;
  inherited;
end;

function TXMPSchema.AddProperty(const ARootNode: IDOMNode): TXMPProperty;
begin
  if FPreferredPrefix = '' then FPreferredPrefix := ARootNode.prefix;
  Result := TXMPProperty.Create(Self, nil, ARootNode);
  FProperties.Add(Result);
end;

function TXMPSchema.AddProperty(const AName: string): TXMPProperty;
var
  Node: IDOMNode;
begin
  if FPreferredPrefix = '' then
    raise EInvalidXMPOperation.Create(SPreferredPrefixMustBeSet);
  Node := FOwner.Document.createElementNS(URI, PreferredPrefix + ':' + AName);
  FMainRootNode.appendChild(Node);
  Result := TXMPProperty.Create(Self, nil, Node);
  FProperties.Add(Result);
end;

function TXMPSchema.FindProperty(const AName: string; var AProperty: TXMPProperty): Boolean;
var
  I: Integer;
begin
  for I := 0 to PropertyCount - 1 do
  begin
    AProperty := Properties[I];
    if AProperty.Name = AName then
    begin
      Result := True;
      Exit;
    end;
  end;
  AProperty := nil;
  Result := False;
end;

function TXMPSchema.FindOrAddProperty(const AName: string): TXMPProperty;
begin
  if not FindProperty(AName, Result) then
    Result := AddProperty(AName);
end;

function TXMPSchema.GetEnumerator: IXMPPropertyEnumerator;
begin
  Result := TXMPPropertyEnumerator.Create(FProperties);
end;

function TXMPSchema.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TXMPSchema.GetProperty(Index: Integer): TXMPProperty;
begin
  Result := FProperties[Index];
end;

function TXMPSchema.GetPropertyCount: Integer;
begin
  Result := FProperties.Count;
end;

function TXMPSchema.RemoveProperty(const AName: string): Boolean;
var
  I: Integer;
  Prop: TXMPProperty;
begin
  Result := False;
  if AName = '' then Exit;
  for I := 0 to FProperties.Count - 1 do
  begin
    Prop := FProperties.List[I];
    if AName = Prop.Name then
    begin
      Prop.RootNode.parentNode.removeChild(Prop.RootNode);
      FProperties.Delete(I);
      Result := True;
      Break;
    end;
  end;
end;

{ TXMPPacket }

constructor TXMPPacket.Create;
begin
  FSchemas := TStringListThatOwnsItsObjects.Create;
  FSchemas.CaseSensitive := False;
  FSchemas.Sorted := True;
end;

destructor TXMPPacket.Destroy;
begin
  FSchemas.Free;
  inherited;
end;

procedure TXMPPacket.Clear;
begin
  FRootRDFNode := nil;
  FDocument := nil;
  FSchemas.Clear;
end;

procedure TXMPPacket.DocumentNeeded;
const
  BlankXMPData: DOMString =
    '<?xpacket begin='''' id=''W5M0MpCehiHzreSzNTczkc9d''?>' + sLineBreak +
    '<x:xmpmeta xmlns:x="adobe:ns:meta/">' + sLineBreak +
    '  <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">' + sLineBreak +
    '  </rdf:RDF>' + SLineBreak +
    '</x:xmpmeta>' + sLineBreak +
    '<?xpacket end=''w''?>'; //packet wrapper - the <?xpacket lines - are optional according to the XMP spec, but required for Vista
begin
  if FDocument <> nil then Exit;
  FDocument := DOMVendor.DOMImplementation.createDocument('', '', nil);
  (FDocument as IDOMPersist).loadxml(BlankXMPData);
  FRootRDFNode := FDocument.childNodes[1].firstChild;
end;

function TXMPPacket.FindOrAddSchema(SchemaNode: IDOMElement; const URI: string): TXMPSchema;
var
  Index: Integer;
  SetAboutAttribute: Boolean;
begin
  DocumentNeeded;
  if FSchemas.Find(URI, Index) then
  begin
    Result := FSchemas.Objects[Index] as TXMPSchema;
    Exit;
  end;
  if SchemaNode <> nil then                    //The spec says every 'description' node
    SetAboutAttribute := (FSchemas.Count <> 0) //should have the same 'about' atrib set,
  else                                         //yet Vista's Explorer only sets the first.
  begin
    SchemaNode := FDocument.createElementNS(RDF.URI, RDF.DescriptionNodeName);
    FRootRDFNode.appendChild(SchemaNode);
    SetAboutAttribute := True;
  end;
  if SetAboutAttribute then
    SchemaNode.setAttributeNS(RDF.URI, RDF.AboutAttrName, AboutAttributeValue);
  Result := TXMPSchema.Create(Self, SchemaNode, URI);
  FSchemas.AddObject(URI, Result);
end;

function TXMPPacket.FindSchema(const URI: string; var Schema: TXMPSchema): Boolean;
var
  Index: Integer;
begin
  Result := (FDocument <> nil) and FSchemas.Find(URI, Index);
  if Result then Schema := FSchemas.Objects[Index] as TXMPSchema;
end;

function TXMPPacket.FindSchema(Kind: TXMPKnownSchemaKind; var Schema: TXMPSchema): Boolean;
begin
  Result := FindSchema(KnownXMPSchemas[Kind].URI, Schema);
end;

function TXMPPacket.FindOrAddSchema(const URI: string): TXMPSchema;
begin
  Result := FindOrAddSchema(nil, URI)
end;

function TXMPPacket.FindOrAddSchema(Kind: TXMPKnownSchemaKind): TXMPSchema;
begin
  Result := FindOrAddSchema(nil, KnownXMPSchemas[Kind].URI);
end;

function TXMPPacket.GetAboutAttributeValue: DOMString;
var
  I: Integer;
  Node: IDOMElement;
begin
  for I := 0 to FSchemas.Count - 1 do
  begin
    Node := Schemas[I].MainRootNode;
    Result := Node.getAttributeNS(RDF.URI, RDF.AboutAttrLocalName);
    if Result = '' then
      Result := Node.getAttribute(RDF.AboutAttrLocalName);
    if Result <> '' then Exit;
  end;
  Result := FAboutAttributeValue;
end;

procedure TXMPPacket.SetAboutAttributeValue(const Value: DOMString);
var
  I: Integer;
begin
  FAboutAttributeValue := Value;
  for I := FSchemas.Count - 1 downto 0 do
    with Schemas[I].MainRootNode do
    begin
      removeAttribute(RDF.AboutAttrLocalName);
      setAttributeNS(RDF.URI, RDF.AboutAttrName, Value);
    end;
end;

function TXMPPacket.GetDOMVendor: TDOMVendor;
begin
  if FDOMVendor = nil then FDOMVendor := xmldom.GetDOMVendor('');
  Result := FDOMVendor;
end;

function TXMPPacket.GetEmpty: Boolean;
begin
  Result := (SchemaCount = 0);
end;

function TXMPPacket.GetEnumerator: TEnumerator;
begin
  Result := TEnumerator.Create(Self);
end;

function TXMPPacket.GetRawXML: DOMString;
begin
  DocumentNeeded;
  Result := (FDocument as IDOMPersist).xml;
end;

function TXMPPacket.GetSchema(Index: Integer): TXMPSchema;
begin
  Result := FSchemas.Objects[Index] as TXMPSchema;
end;

function TXMPPacket.GetSchemaCount: Integer;
begin
  Result := FSchemas.Count;
end;

procedure TXMPPacket.LoadFromFile(const FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TXMPPacket.LoadFromStream(Stream: TStream);
begin
  if not TryLoadFromStream(Stream) then
    raise EInvalidXMPPacket.Create(SInvalidXMPPacket);
end;

function TXMPPacket.TryLoadFromStream(Stream: TStream): Boolean;
var
  Buffer: array[1..SizeOf(XMPSegmentHeader)] of Byte;
  BytesRead: Integer;
  NewDocument: IDOMDocument;
  NewStream: TMemoryStream;
  Node, PropNode: IDOMNode;
  URI: string;
begin
  Result := False;
  Clear;
  BytesRead := Stream.Read(Buffer, SizeOf(Buffer));
  WriteSegmentHeader := (BytesRead = SizeOf(Buffer)) and
    CompareMem(@Buffer, @XMPSegmentHeader, BytesRead);
  if not WriteSegmentHeader then Stream.Seek(-BytesRead, soCurrent);
  NewDocument := DOMVendor.DOMImplementation.createDocument('', '', nil);
  NewStream := TMemoryStream.Create;
  try
    NewStream.SetSize(Stream.Size - Stream.Position);
    Stream.ReadBuffer(NewStream.Memory^, NewStream.Size);
    if not (NewDocument as IDOMPersist).loadFromStream(NewStream) then
      Exit;
  finally
    NewStream.Free;
  end;
  Node := NewDocument.firstChild;
  while Node <> nil do
  begin
    if MatchStr(Node.localName, ['xmpmeta', 'xapmeta']) and
       (Node.nodeType = ELEMENT_NODE) then Break;
    Node := Node.nextSibling;
  end;
  if Node <> nil then
  begin
    Node := Node.firstChild;
    while Node <> nil do
    begin
      if (Node.nodeName = 'rdf:RDF') and (Node.nodeType = ELEMENT_NODE) then Break;
      Node := Node.nextSibling;
    end;
  end;
  if Node = nil then Exit;
  FDocument := NewDocument;
  FRootRDFNode := Node;
  Node := FRootRDFNode.firstChild;
  while Node <> nil do
  begin
    if SameText(Node.namespaceURI, RDF.URI) and
       SameText(Node.nodeName, RDF.DescriptionNodeName) then
    begin
      PropNode := Node.firstChild;
      while PropNode <> nil do
      begin
        URI := PropNode.namespaceURI;
        if (URI <> '') and (PropNode.nodeType = ELEMENT_NODE) then
          FindOrAddSchema(Node as IDOMElement, URI).AddProperty(PropNode);
        PropNode := PropNode.nextSibling;
      end;
    end;
    Node := Node.nextSibling;
  end;
  Result := True;
end;

procedure TXMPPacket.SaveToFile(const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TXMPPacket.SaveToStream(Stream: TStream);
const
  PaddingByte: AnsiChar = ' ';
begin
  DocumentNeeded;
  if WriteSegmentHeader then
    Stream.WriteBuffer(XMPSegmentHeader, SizeOf(XMPSegmentHeader));
  (FDocument as IDOMPersist).saveToStream(Stream);
  Stream.WriteBuffer(PaddingByte, 1); //don't do this, and Vista doesn't read and raises an error when the user tries to write...
end;

procedure TXMPPacket.RemoveProperty(SchemaKind: TXMPKnownSchemaKind;
  const PropName: string);
var
  Schema: TXMPSchema;
begin
  if FindSchema(SchemaKind, Schema) then Schema.RemoveProperty(PropName);
end;

procedure TXMPPacket.RemoveProperty(SchemaKind: TXMPKnownSchemaKind;
  const PropNames: array of string);
var
  Schema: TXMPSchema;
  Name: string;
begin
  if FindSchema(SchemaKind, Schema) then
    for Name in PropNames do Schema.RemoveProperty(Name);
end;

procedure TXMPPacket.DoUpdateProperty(Policy: TXMPWritePolicy; SchemaKind: TXMPKnownSchemaKind;
  const PropName: string; PropKind: TXMPPropertyKind; const NewValue: DOMString);
var
  Prop: TXMPProperty;
  Schema: TXMPSchema;
begin
  if (Policy = xwRemove) or (NewValue = '') then
  begin
    RemoveProperty(SchemaKind, PropName);
    Exit;
  end;
  if Policy = xwAlwaysUpdate then
    Schema := FindOrAddSchema(SchemaKind)
  else
    if not FindSchema(SchemaKind, Schema) then Exit;
  if not Schema.FindProperty(PropName, Prop) then
    if Policy = xwAlwaysUpdate then
      Prop := Schema.AddProperty(PropName)
    else
      Exit;
  Prop.Kind := PropKind;
  Prop.WriteValue(TrimRight(NewValue));
end;

procedure TXMPPacket.DoUpdateArrayProperty(SchemaKind: TXMPKnownSchemaKind;
  const PropName: string; ArrayPropKind: TXMPPropertyKind;
  const NewValues: array of DOMString);
var
  I, NewSubPropCount: Integer;
  Prop: TXMPProperty;
  Schema: TXMPSchema;
begin
  NewSubPropCount := Length(NewValues);
  if (UpdatePolicy = xwRemove) or (NewSubPropCount = 0) then
  begin
    RemoveProperty(SchemaKind, PropName);
    Exit;
  end;
  if UpdatePolicy = xwAlwaysUpdate then
    Schema := FindOrAddSchema(SchemaKind)
  else
    if not FindSchema(SchemaKind, Schema) then Exit;
  if not Schema.FindProperty(PropName, Prop) then
    if UpdatePolicy = xwAlwaysUpdate then
      Prop := Schema.AddProperty(PropName)
    else
      Exit;
  if not (Prop.Kind in [xpSimple, xpBagArray, xpSeqArray]) then
  begin
    RemoveProperty(SchemaKind, PropName);
    Prop := Schema.AddProperty(PropName);
  end;
  Prop.Kind := ArrayPropKind;
  Prop.SubPropertyCount := NewSubPropCount;
  for I := 0 to NewSubPropCount - 1 do
    Prop[I].WriteValue(NewValues[I]);
end;

procedure TXMPPacket.UpdateProperty(SchemaKind: TXMPKnownSchemaKind;
  const PropName: string; PropKind: TXMPPropertyKind; const NewValue: DOMString);
var
  SubPolicy: TXMPWritePolicy;
begin
  DoUpdateProperty(UpdatePolicy, SchemaKind, PropName, PropKind, NewValue);
  if (SchemaKind <> xsTIFF) or (PropKind <> xpSimple) or
     (PropName[1] <> UpCase(PropName[1])) then Exit;
  { Special handling for the TIFF schema - basically, the spec has its properties all
    with an initial capital, but Vista (perhaps for bkwards compat reasons) can write
    to both this *and* an all lowercase version. }
  SubPolicy := UpdatePolicy;
  if SubPolicy = xwAlwaysUpdate then SubPolicy := xwUpdateIfExists;
  DoUpdateProperty(SubPolicy, SchemaKind, LowerCase(PropName), PropKind, NewValue);
end;

procedure TXMPPacket.UpdateBagProperty(SchemaKind: TXMPKnownSchemaKind;
  const PropName: string; const NewValues: array of DOMString);
begin
  DoUpdateArrayProperty(SchemaKind, PropName, xpBagArray, NewValues);
end;

procedure TXMPPacket.UpdateBagProperty(SchemaKind: TXMPKnownSchemaKind;
  const PropName: string; const NewValueList: DOMString);
begin
  UpdateProperty(SchemaKind, PropName, xpBagArray, NewValueList);
end;

procedure TXMPPacket.UpdateSeqProperty(SchemaKind: TXMPKnownSchemaKind;
  const PropName: string; const NewValues: array of DOMString);
begin
  DoUpdateArrayProperty(SchemaKind, PropName, xpSeqArray, NewValues);
end;

procedure TXMPPacket.UpdateSeqProperty(SchemaKind: TXMPKnownSchemaKind;
  const PropName: string; const NewValueList: DOMString);
begin
  UpdateProperty(SchemaKind, PropName, xpSeqArray, NewValueList);
end;

procedure TXMPPacket.UpdateProperty(SchemaKind: TXMPKnownSchemaKind;
  const PropName: string; const NewValue: DOMString);
begin
  UpdateProperty(SchemaKind, PropName, xpSimple, NewValue);
end;

procedure TXMPPacket.UpdateProperty(SchemaKind: TXMPKnownSchemaKind;
  const PropName: string; const NewValue: Integer);
begin
  UpdateProperty(SchemaKind, PropName, xpSimple, IntToStr(NewValue));
end;

procedure TXMPPacket.UpdateDateTimeProperty(SchemaKind: TXMPKnownSchemaKind;
  const PropName: string; const NewValue: TDateTime; ApplyLocalBias: Boolean);
var
  S: DOMString;
begin
  if NewValue = 0 then
    RemoveProperty(SchemaKind, PropName)
  else
  begin
    S := DateTimeToXMLTime(NewValue, ApplyLocalBias);
    UpdateProperty(SchemaKind, PropName, xpSimple, S);
  end;
end;

{ TXMPPacket.TEnumerator }

constructor TXMPPacket.TEnumerator.Create(Packet: TXMPPacket);
begin
  FPacket := Packet;
  FIndex := -1;
end;

function TXMPPacket.TEnumerator.GetCurrent: TXMPSchema;
begin
  Result := FPacket[FIndex];
end;

function TXMPPacket.TEnumerator.MoveNext: Boolean;
begin
  Inc(FIndex);
  Result := (FIndex < FPacket.SchemaCount);
end;

end.
