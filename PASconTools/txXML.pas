// **************************************************
// * TXLIB Rev. 0.046                               *
// *                                                *
// *           Autor: Ronny Schupeta                *
// * Letzte Änderung: 29.10.2009                    *
// **************************************************
unit txXML;

interface

{$ifdef FPC}
{$mode delphi}
{$ASMMODE intel}
{$endif}

uses
 Windows, SysUtils, StrUtils,
 Classes, DateUtils,
 {$ifdef fpc}
 fpchelper,
 {$endif}
 anfix;

function TXStrToInt(const Str: AnsiString; AbsValue: Boolean = False): Integer;
function LimitSpaces(const Text: AnsiString): AnsiString;

type
  ETXXMLError = class(Exception);

type
  TTXSearchMethod = ( smLinear, smAVL, smHash );

  PTTXStringListItem = ^TTXStringListItem;

  TTXAVLItem = class;

  TTXStringListItem = record
    FString:  AnsiString;
    FObject:  TObject;
    FAVLItem: TTXAVLItem;
  end;

  PTXStringListItemArray = ^TTXStringListItemArray;
  TTXStringListItemArray = array[0..0] of TTXStringListItem;

  TTXStringListHashItem = record
    FAVLRoot: TTXAVLItem;
  end;

  PTXStringListHashArray = ^TTXStringListHashArray;
  TTXStringListHashArray = array[0..0] of TTXStringListHashItem;

  TTXAVLItem = class
  private
    FData:        Integer;

    FParent:      TTXAVLItem;
    FLeftChild:   TTXAVLItem;
    FRightChild:  TTXAVLItem;
    FHeight:      Integer;

    FNext:        TTXAVLItem;     // LinkedList (Next) für Duplikate
    FPrev:        TTXAVLItem;     // LinkedList (Prev) für Duplikate

    function GetSlope: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure UpdateHeight;
    procedure Rebalance(var Root: TTXAVLItem);

    procedure Delete(var Root: TTXAVLItem);

    property Data: Integer read FData write FData;

    property Parent: TTXAVLItem read FParent write FParent;
    property LeftChild: TTXAVLItem read FLeftChild write FLeftChild;
    property RightChild: TTXAVLItem read FRightChild write FRightChild;
    property Height: Integer read FHeight write FHeight;

    property Next: TTXAVLItem read FNext write FNext;
    property Prev: TTXAVLItem read FPrev write FPrev;

    property Slope: Integer read GetSlope;
  end;

  TTXStringList = class;

  TTXPrepareProc = procedure (var Str: AnsiString);
  TTXStringListSortCompare = function (List: TTXStringList; Index1, Index2: Integer; UserData: Pointer): Integer;

  TTXStringList = class
  private
    FItems:         PTXStringListItemArray;
    FItemsLength:   Integer;
    FCount:         Integer;

    FHashItems:     PTXStringListHashArray;

    FSorted:        Boolean;

    FFindStr:       AnsiString;
    FFindIndex:     Integer;

    FDuplicates:    Boolean;
    FCaseSensitive: Boolean;
    FUmlaut:        Boolean;
    FTrimmed:       Boolean;

    FAVLRoot:       TTXAVLItem;

    FSearchMethod:  TTXSearchMethod;
    FHashSize:      Integer;

    FPrepareProc:   TTXPrepareProc;

    procedure SetString(Index: Integer; const Value: AnsiString);
    function GetString(Index: Integer): AnsiString;
    procedure SetObject(Index: Integer; Value: TObject);
    function GetObject(Index: Integer): TObject;

    procedure SetSorted(Sorted: Boolean);

    procedure SetDuplicates(Duplicates: Boolean);
    procedure SetCaseSensitive(CaseSensitive: Boolean);
    procedure SetUmlaut(Umlaut: Boolean);
    procedure SetTrimmed(Trimmed: Boolean);

    procedure SetSearchMethod(SearchMethod: TTXSearchMethod);
    procedure SetHashSize(Hashsize: Integer);

    procedure SetText(Text: AnsiString);
    function GetText: AnsiString;

    function InsertItem(Index: Integer; const Str: AnsiString; AObject: TObject; RaiseException: Boolean): Integer;

    procedure InternalExchange(Index1, Index2: Integer);
    procedure InternalMove(CurIndex, NewIndex: Integer);

    function BinarySearch(const Str: AnsiString; var IndexToInsert: Integer): Integer;

    function AVLAddItem(var Root: TTXAVLItem; Index: Integer): TTXAVLItem;
    procedure AVLFree(Items: PTXStringListItemArray; Count: Integer);

    procedure PrepareString(var Str: AnsiString);
    function HashFunc(Str: AnsiString): Cardinal;

    procedure Rebuild;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(StringList: TTXStringList);
    procedure AssignTo(StringList: TTXStringList);

    procedure LoadFromFile(Filename: AnsiString);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(Filename: AnsiString);
    procedure SaveToStream(Stream: TStream);

    procedure Clear;
    function Add(const Str: AnsiString): Integer;
    function AddObject(const Str: AnsiString; AObject: TObject): Integer;
    function Insert(Index: Integer; const Str: AnsiString): Integer;
    function InsertObject(Index: Integer; const Str: AnsiString; AObject: TObject): Integer;
    procedure Delete(Index: Integer);
    procedure Exchange(Index1, Index2: Integer);
    procedure Move(CurIndex, NewIndex: Integer);

    function CompareStrings(const Str1, Str2: AnsiString): Integer;

    function Find(const Str: AnsiString): Integer;
    function FindNext: Integer;

    procedure Sort(Ascending: Boolean = True); overload;
    procedure Sort(StartIndex, EndIndex: Integer; Ascending: Boolean = True); overload;
    procedure CustomSort(Compare: TTXStringListSortCompare; UserData: Pointer); overload;
    procedure CustomSort(StartIndex, EndIndex: Integer; Compare: TTXStringListSortCompare; UserData: Pointer); overload;

    property Strings[Index: Integer]: AnsiString read GetString write SetString; default;
    property Objects[Index: Integer]: TObject read GetObject write SetObject;
    property Count: Integer read FCount;

    property Sorted: Boolean read FSorted write SetSorted;

    property Duplicates: Boolean read FDuplicates write SetDuplicates;
    property CaseSensitive: Boolean read FCaseSensitive write SetCaseSensitive;
    property Umlaut: Boolean read FUmlaut write SetUmlaut;
    property Trimmed: Boolean read FTrimmed write SetTrimmed;

    property SearchMethod: TTXSearchMethod read FSearchMethod write SetSearchMethod;
    property Hashsize: Integer read FHashSize write SetHashSize;

    property Text: AnsiString read GetText write SetText;

    property PrepareProc: TTXPrepareProc read FPrepareProc write FPrepareProc;
  end;

type
  TTXXMLEntitiesItem = record
    FName:  AnsiString;
  end;

  PTXXMLEntitiesArray = ^TTXXMLEntitiesArray;
  TTXXMLEntitiesArray = array[0..0] of TTXXMLEntitiesItem;

  TTXXMLEntities = class
  private
    FEntities:    TTXStringList;
    FCharacter:   PTXXMLEntitiesArray;

    procedure SetEntity(Index: Integer; Value: AnsiString);
    function GetEntity(Index: Integer): AnsiString;
    procedure SetCharacter(Index: Integer; Value: WideChar);
    function GetCharacter(Index: Integer): WideChar;
    function GetCount: Integer;

    procedure SetCharacterOfEntity(const Name: AnsiString; Value: WideChar);
    function GetCharacterOfEntity(const Name: AnsiString): WideChar;
    procedure SetEntityOfCharacter(Character: WideChar; const Value: AnsiString);
    function GetEntityOfCharacter(Character: WideChar): AnsiString;

    function WellEntity(const Name: AnsiString): AnsiString;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    function Add(Character: WideChar; Name: AnsiString): Integer;
    procedure AddStandardXMLEntities;
    procedure AddStandardHTMLEntities;
    procedure Delete(Index: Integer);

    function IndexOfEntity(const Name: AnsiString): Integer;
    function EntityExists(const Name: AnsiString): Boolean;

    function IndexOfCharacter(Character: WideChar): Integer;
    function CharacterExists(Character: WideChar): Boolean;

    property Entity[Index: Integer]: AnsiString read GetEntity write SetEntity;
    property Character[Index: Integer]: WideChar read GetCharacter write SetCharacter;
    property Count: Integer read GetCount;

    property CharacterOfEntity[const Name: AnsiString]: WideChar read GetCharacterOfEntity write SetCharacterOfEntity;
    property EntityOfCharacter[Character: WideChar]: AnsiString read GetEntityOfCharacter write SetEntityOfCharacter;
  end;

type
  TTXXMLDocument = class;
  TTXXMLNodeElement = class;

  TTXXMLNodeType = ( dtNone, dtElement, dtText, dtCDATA, dtComment );

  TTXXMLEncoding = ( xeNone, xeUTF8 );

  TTXXMLNode = class
  private
    FParent:      TTXXMLNodeElement;
    FDocument:    TTXXMLDocument;

    FNodeType:    TTXXMLNodeType;
  public
    constructor Create(Parent: TTXXMLNodeElement; XMLDocument: TTXXMLDocument = nil);
    destructor Destroy; override;

    procedure Assign(Node: TTXXMLNode);
    procedure AssignTo(Node: TTXXMLNode);

    property NodeType: TTXXMLNodeType read FNodeType;

    property Parent: TTXXMLNodeElement read FParent;
    property Document: TTXXMLDocument read FDocument;
  end;

  TTXXMLNodeText = class(TTXXMLNode)
  private
    FText:        AnsiString;

    procedure SetText(const Text: AnsiString);

    procedure SetIsCDATA(IsCDATA: Boolean);
    function GetIsCDATA: Boolean;
  public
    constructor Create(Parent: TTXXMLNodeElement; XMLDocument: TTXXMLDocument = nil);
    destructor Destroy; override;

    property Text: AnsiString read FText write SetText;

    property IsCDATA: Boolean read GetIsCDATA write SetIsCDATA;
  end;

  TTXXMLNodeComment = class(TTXXMLNode)
  private
    FComment:     AnsiString;

    procedure SetComment(Comment: AnsiString);
  public
    constructor Create(Parent: TTXXMLNodeElement; XMLDocument: TTXXMLDocument = nil);
    destructor Destroy; override;

    property Comment: AnsiString read FComment write SetComment;
  end;

  TTXXMLNodeElement = class(TTXXMLNode)
  private
    FOwner:       TTXXMLNode;

    FNodeName:    AnsiString;

    FChildNodes:  TList;
    FAttributes:  TTXStringList;

    procedure SetChildNode(Index: Integer; Value: TTXXMLNode);
    function GetChildNode(Index: Integer): TTXXMLNode;
    procedure SetElement(Index: Integer; Value: TTXXMLNodeElement);
    function GetElement(Index: Integer): TTXXMLNodeElement;
    procedure SetTextNode(Index: Integer; Value: TTXXMLNodeText);
    function GetTextNode(Index: Integer): TTXXMLNodeText;
    procedure SetComment(Index: Integer; Value: TTXXMLNodeComment);
    function GetComment(Index: Integer): TTXXMLNodeComment;
    function GetNodeType(Index: Integer): TTXXMLNodeType;
    function GetCount: Integer;

    procedure SetAttributeName(Index: Integer; const Value: AnsiString);
    function GetAttributeName(Index: Integer): AnsiString;
    procedure SetAttributeValue(Index: Integer; const Value: AnsiString);
    function GetAttributeValue(Index: Integer): AnsiString;
    function GetAttributeCount: Integer;
    procedure SetAttribute(const Name, Value: AnsiString);
    function GetAttribute(const Name: AnsiString): AnsiString;
    procedure SetAttributeAsInteger(const Name: AnsiString; Value: Integer);
    function GetAttributeAsInteger(const Name: AnsiString): Integer;
    procedure SetAttributeAsBoolean(const Name: AnsiString; Value: Boolean);
    function GetAttributeAsBoolean(const Name: AnsiString): Boolean;

    procedure SetNodeName(const NodeName: AnsiString);

    procedure SetText(const Text: AnsiString);
    function GetText: AnsiString;
    function _GetXMLText: AnsiString;

    procedure InternalSetXMLText(Text: PAnsiChar; XMLEntities: TTXXMLEntities; Encoding: TTXXMLEncoding);
    function InternalGetXMLText(var DestStr: PAnsiChar; var DestSize: Integer; IncludeTopNode: Boolean; XMLEntities: TTXXMLEntities; Encoding: TTXXMLEncoding; WriteVersion: Boolean; UseTabs: Boolean; Spaces: Integer; LineFeed: PAnsiChar; LineFeedLen: Integer): Integer;

    function GetLevel: Integer;

    function GetIndex: Integer;

    function IsValidName(const Name: AnsiString): Boolean;
  public
    constructor Create(Parent: TTXXMLNodeElement; XMLDocument: TTXXMLDocument = nil);
    destructor Destroy; override;

    procedure LoadFromFile(const Filename: AnsiString);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const Filename: AnsiString);
    procedure SaveToStream(Stream: TStream);

    procedure SetXMLText(const Text: AnsiString; XMLEntities: TTXXMLEntities = nil; Encoding: TTXXMLEncoding = xeUTF8);
    function GetXMLText(IncludeTopNode: Boolean = True; XMLEntities: TTXXMLEntities = nil; Encoding: TTXXMLEncoding = xeUTF8; WriteVersion: Boolean = True; UseTabs: Boolean = True; Spaces: Integer = 1; const LineFeed: AnsiString = #13#10): AnsiString;

    function IsSubNode(FromNode: TTXXMLNodeElement): Boolean;

    procedure Clear;
    function AddElement(const NodeName: AnsiString): TTXXMLNodeElement;
    function AddText(const Text: AnsiString; IsCDATA: Boolean = False): TTXXMLNodeText;
    function AddComment(const Comment: AnsiString): TTXXMLNodeComment;
    function InsertElement(Index: Integer; const NodeName: AnsiString): TTXXMLNodeElement;
    function InsertText(Index: Integer; const Text: AnsiString; IsCDATA: Boolean = False): TTXXMLNodeText;
    function InsertComment(Index: Integer; const Comment: AnsiString): TTXXMLNodeComment;
    procedure Delete(Index: Integer);
    procedure Exchange(Index1, Index2: Integer);
    procedure Move(CurIndex, NewIndex: Integer);

    function IndexOfElement(const Name: AnsiString; StartIndex: Integer = 0; CaseSensitive: Boolean = True; Umlaut: Boolean = False): Integer;

    procedure ClearAttributes;
    function AddAttribute(const Name, Value: AnsiString): Integer;
    function InsertAttribute(Index: Integer; const Name, Value: AnsiString): Integer;
    procedure DeleteAttribute(Index: Integer);
    procedure ExchangeAttribute(Index1, Index2: Integer);
    procedure MoveAttribute(Index1, Index2: Integer);

    function IndexOfAttribute(const Name: AnsiString): Integer;

    property ChildNodes[Index: Integer]: TTXXMLNode read GetChildNode write SetChildNode;
    property Elements[Index: Integer]: TTXXMLNodeElement read GetElement write SetElement;
    property TextNodes[Index: Integer]: TTXXMLNodeText read GetTextNode write SetTextNode;
    property Comments[Index: Integer]: TTXXMLNodeComment read GetComment write SetComment;
    property NodeTypes[Index: Integer]: TTXXMLNodeType read GetNodeType;
    property Count: Integer read GetCount;

    property AttributeNames[Index: Integer]: AnsiString read GetAttributeName write SetAttributeName;
    property AttributeValues[Index: Integer]: AnsiString read GetAttributeValue write SetAttributeValue;
    property AttributeCount: Integer read GetAttributeCount;

    property Attributes[const Name: AnsiString]: AnsiString read GetAttribute write SetAttribute;
    property AttributesAsInteger[const Name: AnsiString]: Integer read GetAttributeAsInteger write SetAttributeAsInteger;
    property AttributesAsBoolean[const Name: AnsiString]: Boolean read GetAttributeAsBoolean write SetAttributeAsBoolean;

    property NodeName: AnsiString read FNodeName write SetNodeName;

    property Text: AnsiString read GetText write SetText;
    property XMLText: AnsiString read _GetXMLText write SetText;

    property Level: Integer read GetLevel;

    property Index: Integer read GetIndex;
  end;

  TTXXMLDocument = class
  private
    FDocument:                TTXXMLNodeElement;

    FXMLEntities:             TTXXMLEntities;

    FEncoding:                TTXXMLEncoding;
    FWriteVersion:            Boolean;
    FSpaces:                  Integer;
    FLineFeed:                AnsiString;

    FUseTabs:                 Boolean;

    FAttributesCaseSensitive: Boolean;

    procedure SetText(const Text: AnsiString);
    function GetText: AnsiString;

    procedure SetAttributesCaseSensitive(AttributesCaseSensitive: Boolean);
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadFromFile(const Filename: AnsiString);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const Filename: AnsiString);
    procedure SaveToStream(Stream: TStream);

    procedure Clear;

    property Document: TTXXMLNodeElement read FDocument;

    property Text: AnsiString read GetText write SetText;

    property XMLEntities: TTXXMLEntities read FXMLEntities write FXMLEntities;
    property Encoding: TTXXMLEncoding read FEncoding write FEncoding;
    property WriteVersion: Boolean read FWriteVersion write FWriteVersion;
    property Spaces: Integer read FSpaces write FSpaces;
    property LineFeed: AnsiString read FLineFeed write FLineFeed;

    property UseTabs: Boolean read FUseTabs write FUseTabs;

    property AttributesCaseSensitive: Boolean read FAttributesCaseSensitive write SetAttributesCaseSensitive;
  end;

function GetXMLText(XMLNode: TTXXMLNodeElement; IncludeSubNodes: Boolean = False): AnsiString;

type
  TTXDateTime = Int64;

implementation

type
  TDirSortType = ( dsNone, dsFile, dsDateTime );
  TTXNameFormat = ( nfStandard, nfNameUnknown, nfNameFullyQualifiedDN,
                    nfNameSamCompatible, nfNameDisplay, nfNameUniqueId,
                    nfNameCanonical, nfNameUserPrincipal, nfNameCanonicalEx,
                    nfNameServicePrincipal, nfDNSDomainName );

const
  faOnlyFiles =   faAnyFile - faDirectory;


function DeleteChars(const Text, Chars: AnsiString): AnsiString; forward;
function ReplaceChar(const Text: AnsiString; FromChar, ToChar: AnsiChar): AnsiString; forward;
function TXStrToFloat(const Str: AnsiString): Extended; forward;
function WellFilename(const Filename: AnsiString): AnsiString; forward;
function LimitString(const Text, Chars: AnsiString; AllowedChars: Boolean = True): AnsiString; forward;
function TXPos(const SubStr, Str: AnsiString; Offset: Integer = 1): Integer; forward;
function LimitMultiChars(const Text, Chars: AnsiString): AnsiString; forward;
function DateTimeToTXDateTime(DateTime: TDateTime): TTXDateTime; forward;
function TXDateTimeToDateTime(DateTime: TTXDateTime): TDateTime; forward;
function TXNow: TTXDateTime; forward;
procedure TXSetDateTime(var DateTime: TTXDateTime; Day, Month, Year, Hour, Minute, Second: Integer; Millisec: Integer = 0); overload; forward;
function TXSetDateTime(Day, Month, Year, Hour, Minute, Second: Integer; Millisec: Integer = 0): TTXDateTime; overload; forward;
procedure TXGetDateTime(DateTime: TTXDateTime; var Day, Month, Year, Hour, Minute, Second, Millisec: Integer); forward;

function TXStrToInt(const Str: AnsiString; AbsValue: Boolean = False): Integer;
var
  i, l:   Integer;
  res:    AnsiString;
  minus:  Boolean;
begin
  if AbsValue then
    minus := False
  else if Pos('-', Str) > 0 then
    minus := True
  else
    minus := False;

  res := '';
  l := Length(Str);
  for i := 1 to l do
    if (Str[i] >= '0') and (Str[i] <= '9') then
      res := res + Str[i];

    result := StrToIntdef(res,0);
    if minus then
      result := -result;
end;

function TXStrToInt64(const Str: AnsiString; AbsValue: Boolean = False): Int64;
var
  i, l:   Integer;
  res:    AnsiString;
  minus:  Boolean;
begin
  if AbsValue then
    minus := False
  else if Pos('-', Str) > 0 then
    minus := True
  else
    minus := False;

  res := '';
  l := Length(Str);
  for i := 1 to l do
    if (Str[i] >= '0') and (Str[i] <= '9') then
      res := res + Str[i];

  try
    result := StrToInt64(res);
    if minus then
      result := -result;
  except
    result := 0;
  end;
end;

function TXPosChar(Chr: AnsiChar; const Str: AnsiString; Offset: Integer = 1; StrLen: Integer = -1): Integer;
var
  PSrc:   PAnsiChar;
  l:      Integer;
begin
  PSrc := PAnsiChar(Str);
  if PSrc <> nil then
  begin
    if StrLen < 0 then
      StrLen := Length(Str);

    if StrLen > 0 then
    begin
      if Offset <= StrLen then
      begin
        if Offset < 1 then
          Offset := 1;

        dec(Offset);
        l := StrLen - Offset;
        inc(PSrc, Offset);
        asm
          {$ifndef FPC}
          push edi
          {$endif}
          cld
          xor eax, eax
          mov al, Chr
          mov ecx, l
          inc ecx
          mov edi, [PSrc]
          repne SCASB
          mov result, ecx
          {$ifndef FPC}
          pop edi
          {$endif}
        end;

        if result > 0 then
          result := 1 + StrLen - result;
      end
      else
        result := 0;
    end
    else
      result := 0;
  end
  else
    result := 0;
end;

function TXPosMultiChar(const Chrs, Str: AnsiString; Offset: Integer = 1): Integer;
var
  i, c, l:  Integer;
begin
  result := 0;

  l := Length(Chrs);
  if l > 0 then
  begin
    c := Length(Str);
    for i := Offset to c do
      if TXPosChar(Str[i], Chrs, 1, l) > 0 then
      begin
        result := i;
        break;
      end;
  end;
end;

constructor TTXAVLItem.Create;
begin
  FData := 0;

  FParent := nil;
  FLeftChild := nil;
  FRightChild := nil;
  FHeight := 0;

  FNext := nil;
  FPrev := nil;
end;

destructor TTXAVLItem.Destroy;
begin
  inherited;
end;

procedure TTXAVLItem.UpdateHeight;
begin
  if FLeftChild <> nil then
  begin
    if FRightChild <> nil then
    begin
      if FLeftChild.FHeight > FRightChild.FHeight then
        FHeight := FLeftChild.FHeight + 1
      else
        FHeight := FRightChild.FHeight + 1;
    end
    else
      FHeight := FLeftChild.FHeight + 1
  end
  else if FRightChild <> nil then
    FHeight := FRightChild.FHeight + 1
  else
    FHeight := 1;
end;

procedure TTXAVLItem.Rebalance(var Root: TTXAVLItem);
var
  s:  Integer;

  procedure RotL(Item: TTXAVLItem);
  begin
    if Item.FParent <> nil then
      if Item.FParent.FLeftChild = Item then
        Item.FParent.FLeftChild := Item.FRightChild
      else
        Item.FParent.FRightChild := Item.FRightChild;

    Item.FRightChild.FParent := Item.FParent;
    Item.FParent := Item.FRightChild;

    if Item.FRightChild.FLeftChild <> nil then
      Item.FRightChild.FLeftChild.FParent := Item;

    Item.FRightChild := Item.FRightChild.FLeftChild;
    Item.FParent.FLeftChild := Item;

    if Item = Root then
      Root := Item.FParent;

    Item.UpdateHeight;
    Item.FParent.UpdateHeight;
  end;

  procedure RotR(Item: TTXAVLItem);
  begin
    if Item.FParent <> nil then
      if Item.FParent.FLeftChild = Item then
        Item.FParent.FLeftChild := Item.FLeftChild
      else
        Item.FParent.FRightChild := Item.FLeftChild;

    Item.FLeftChild.FParent := Item.FParent;
    Item.FParent := Item.FLeftChild;

    if Item.FLeftChild.FRightChild <> nil then
      Item.FLeftChild.FRightChild.FParent := Item;
    Item.FLeftChild := Item.FLeftChild.FRightChild;

    Item.FParent.FRightChild := Item;

    if Item = Root then
      Root := Item.FParent;

    Item.UpdateHeight;
    Item.FParent.UpdateHeight;
  end;

  procedure ShiftL(Item: TTXAVLItem);
  begin
    if Item.FRightChild.Slope = 1 then
      RotR(Item.FRightChild);

    RotL(Item);
  end;

  procedure ShiftR(Item: TTXAVLItem);
  begin
    if Item.FLeftChild.Slope = -1 then
      RotL(Item.FLeftChild);

    RotR(Item);
  end;
begin
  s := GetSlope;

  if s = 2 then
    ShiftR(Self)
  else if s = -2 then
    ShiftL(Self);
end;

procedure TTXAVLItem.Delete(var Root: TTXAVLItem);
var
  CurItem:      TTXAVLItem;
  ReplaceItem:  TTXAVLItem;
begin
  // LinkedList (für Duplikate)?
  if FNext <> nil then
  begin
    if FPrev <> nil then
    begin
      FPrev.FNext := FNext;
      FNext.FPrev := FPrev;
    end
    else
    begin
      FNext.FParent := FParent;
      FNext.FLeftChild := FLeftChild;
      FNext.FRightChild := FRightChild;
      FNext.FHeight := FHeight;
      FNext.FPrev := nil;

      if FParent <> nil then
        if FParent.FLeftChild = Self then
          FParent.FLeftChild := FNext
        else if FParent.FRightChild = Self then
          FParent.FRightChild := FNext;

      if FLeftChild <> nil then
        FLeftChild.FParent := FNext;
      if FRightChild <> nil then
        FRightChild.FParent := FNext;

      if Root = Self then
        Root := FNext;
    end;

    Exit;
  end
  else if FPrev <> nil then
  begin
    FPrev.FNext := nil;

    Exit;
  end;

  // Element aus AVL-Baum entfernen
  if FLeftChild <> nil then
  begin
    if FRightChild <> nil then
    begin
      ReplaceItem := FLeftChild;
      while ReplaceItem.FRightChild <> nil do
        ReplaceItem := ReplaceItem.FRightChild;

      if FLeftChild <> ReplaceItem then
      begin
        if ReplaceItem.FLeftChild <> nil then
        begin
          ReplaceItem.FParent.FRightChild := ReplaceItem.FLeftChild;

          ReplaceItem.FLeftChild.FParent := ReplaceItem.FParent;
        end
        else
          ReplaceItem.FParent.FRightChild := ReplaceItem.FLeftChild;

        ReplaceItem.FLeftChild := FLeftChild;
        ReplaceItem.FLeftChild.FParent := ReplaceItem;
      end;

      if FParent <> nil then
      begin
        if FParent.FLeftChild = Self then
          FParent.FLeftChild := ReplaceItem
        else
          FParent.FRightChild := ReplaceItem;

        ReplaceItem.FParent := FParent;
      end
      else
        ReplaceItem.FParent := nil;

      ReplaceItem.FRightChild := FRightChild;
      ReplaceItem.FRightChild.FParent := ReplaceItem;

      CurItem := ReplaceItem;
    end
    else
    begin
      ReplaceItem := FLeftChild;

      if FParent <> nil then
      begin
        if FParent.FLeftChild = Self then
          FParent.FLeftChild := ReplaceItem
        else
          FParent.FRightChild := ReplaceItem;

        ReplaceItem.FParent := FParent;
      end
      else
        ReplaceItem.FParent := nil;

      CurItem := ReplaceItem;
    end;
  end
  else if FRightChild <> nil then
  begin
    ReplaceItem := FRightChild;

    if FParent <> nil then
    begin
      if FParent.FLeftChild = Self then
        FParent.FLeftChild := ReplaceItem
      else
        FParent.FRightChild := ReplaceItem;

      ReplaceItem.FParent := FParent;
    end
    else
      ReplaceItem.FParent := nil;

    CurItem := ReplaceItem;
  end
  else
  begin
    ReplaceItem := nil;

    if FParent <> nil then
      if FParent.FLeftChild = Self then
        FParent.FLeftChild := nil
      else
        FParent.FRightChild := nil;

    CurItem := FParent;
  end;

  if Root = Self then
    Root := ReplaceItem;

  if CurItem <> nil then
    while CurItem <> nil do
    begin
      CurItem.UpdateHeight;
      CurItem.Rebalance(Root);

      CurItem := CurItem.FParent;
    end;

end;

function TTXAVLItem.GetSlope: Integer;
begin
  if FLeftChild <> nil then
  begin
    if FRightChild <> nil then
      result := FLeftChild.FHeight - FRightChild.FHeight
    else
      result := FLeftChild.FHeight;
  end
  else if FRightChild <> nil then
    result := -FRightChild.FHeight
  else
    result := 0;
end;

constructor TTXStringList.Create;
begin
  FItems := nil;
  FItemsLength := 0;
  FCount := 0;

  FHashItems := nil;

  FSorted := False;

  FPrepareProc := nil;

  FFindIndex := -1;

  FDuplicates := True;
  FCaseSensitive := True;
  FUmlaut := True;
  FTrimmed := False;

  FAVLRoot := nil;

  FSearchMethod := smLinear;
  FHashSize := 1024;
end;

destructor TTXStringList.Destroy;
begin
  Clear;

  inherited;
end;

procedure TTXStringList.Assign(StringList: TTXStringList);
var
  i, c:   Integer;
begin
  Clear;

  FSorted := StringList.FSorted;
  FFindStr := StringList.FFindStr;
  FFindIndex := StringList.FFindIndex;

  FDuplicates := StringList.FDuplicates;
  FCaseSensitive := StringList.FCaseSensitive;
  FUmlaut := StringList.FUmlaut;
  FTrimmed := StringList.FTrimmed;

  FSearchMethod := StringList.FSearchMethod;
  FHashSize := StringList.FHashSize;

  FPrepareProc := StringList.FPrepareProc;

  c := StringList.Count - 1;
  for i := 0 to c do
    try
      AddObject(StringList.Strings[i], StringList.Objects[i]);
    except
    end;
end;

procedure TTXStringList.AssignTo(StringList: TTXStringList);
begin
  StringList.Assign(Self);
end;

procedure TTXStringList.LoadFromFile(Filename: AnsiString);
var
  Stream:   TFileStream;
begin
  Stream := TFileStream.Create(Filename, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TTXStringList.LoadFromStream(Stream: TStream);
var
  Size: Integer;
  Str:  AnsiString;
begin
  Size := Stream.Size - Stream.Position;
  System.SetString(Str, nil, Size);
  Stream.Read(Pointer(Str)^, Size);
  SetText(Str);
end;

procedure TTXStringList.SaveToFile(Filename: AnsiString);
var
  Stream:   TFileStream;
begin
  Stream := TFileStream.Create(Filename, fmCreate or fmShareDenyWrite);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TTXStringList.SaveToStream(Stream: TStream);
var
  Str:  AnsiString;
begin
  Str := GetText;
  Stream.WriteBuffer(Pointer(Str)^, Length(Str));
end;

procedure TTXStringList.Clear;
begin
  if FSearchMethod <> smLinear then
    AVLFree(FItems, FCount);

  if FItems <> nil then
  begin
    Finalize(FItems^[0], FCount);
    FreeMem(FItems);
    FItems := nil;
  end;

  FItemsLength := 0;
  FCount := 0;
  FFindIndex := -1;

  FAVLRoot := nil;
end;

function TTXStringList.Add(const Str: AnsiString): Integer;
begin
  result := InsertItem(Count, Str, nil, True);
end;

function TTXStringList.AddObject(const Str: AnsiString; AObject: TObject): Integer;
begin
  result := InsertItem(Count, Str, AObject, True);
end;

function TTXStringList.Insert(Index: Integer; const Str: AnsiString): Integer;
begin
  result := InsertObject(Index, Str, nil);
end;

function TTXStringList.InsertObject(Index: Integer; const Str: AnsiString; AObject: TObject): Integer;
begin
  if Index >= 0 then
    if Index <= FCount then
    begin
      result := InsertItem(Index, Str, AObject, True);

      Exit;
    end;

  raise ETXXMLError.CreateFmt('Listindex out of bounds (Index = %d; Count = %d).', [ Index, Count ]);
end;

procedure TTXStringList.Delete(Index: Integer);
var
  i, c: Integer;
begin
  if Index >= 0 then
    if Index < FCount then
    begin
      dec(FCount);

      case FSearchMethod of
      smAVL:
      begin
        FItems[Index].FAVLItem.Delete(FAVLRoot);
        FreeAndNil(FItems[Index].FAVLItem);
      end;
      smHash:
      begin
        FItems[Index].FAVLItem.Delete(FHashItems[HashFunc(FItems[Index].FString)].FAVLRoot);
        FreeAndNil(FItems[Index].FAVLItem);
      end;
      end;

      Finalize(FItems^[Index]);
      System.Move(FItems^[Index + 1], FItems^[Index], (FCount - Index) * sizeof(TTXStringListItem));

      if FSearchMethod <> smLinear then
      begin
        c := FCount - 1;
        for i := Index to c do
          FItems[i].FAVLItem.FData := i;
      end;

      if FItemsLength > 16 then
        if FCount < FItemsLength shr 1 then
        begin
          FItemsLength := FItemsLength shr 1;
          ReAllocMem(FItems, FItemsLength * sizeof(TTXStringListItem));
        end;

      if FCount = 0 then
      begin
        FreeMem(FHashItems);
        FHashItems := nil;
      end;

      Exit;
    end;

  raise ETXXMLError.CreateFmt('Listindex out of bounds (Index = %d; Count = %d).', [ Index, Count ]);
end;

procedure TTXStringList.Exchange(Index1, Index2: Integer);
begin
  if FSorted then
    raise ETXXMLError.Create('Cannot exchange item on sorted list ')
  else
  begin
    if Index1 >= 0 then
      if Index1 < FCount then
      begin
        if Index2 >= 0 then
          if Index2 < FCount then
          begin
            InternalExchange(Index1, Index2);

            Exit;
          end;

        raise ETXXMLError.CreateFmt('Listindex out of bounds (Index = %d; Count = %d).', [ Index2, FCount ]);
      end;

    raise ETXXMLError.CreateFmt('Listindex out of bounds (Index = %d; Count = %d).', [ Index1, FCount ]);
  end;
end;

procedure TTXStringList.Move(CurIndex, NewIndex: Integer);
begin
  if FSorted then
    raise EtxXMLError.Create('Cannot move item on sorted list ')
  else
  begin
    if CurIndex >= 0 then
      if CurIndex < FCount then
      begin
        if NewIndex >= 0 then
          if NewIndex < FCount then
          begin
            InternalMove(CurIndex, NewIndex);

            Exit;
          end;

        raise EtxXMLError.CreateFmt('Listindex out of bounds (Index = %d; Count = %d).', [ NewIndex, FCount ]);
      end;

    raise EtxXMLError.CreateFmt('Listindex out of bounds (Index = %d; Count = %d).', [ CurIndex, FCount ]);
  end;
end;

function TTXStringList.CompareStrings(const Str1, Str2: AnsiString): Integer;
var
  S1, S2: AnsiString;
begin
  S1 := Str1;
  S2 := Str2;

  PrepareString(S1);
  PrepareString(S2);

  result := CompareStr(S1, S2);
end;

function TTXStringList.Find(const Str: AnsiString): Integer;
var
  CurItem:  TTXAVLItem;
  i, c:     Integer;
begin
  FFindStr := Str;
  FFindIndex := -1;

  case FSearchMethod of
  smLinear:
  begin
    if FSorted then
    begin
      FFindIndex := BinarySearch(Str, i);

      repeat
        if FFindIndex > 0 then
        begin
          if CompareStrings(FItems[FFindIndex - 1].FString, Str) = 0 then
            dec(FFindIndex)
          else
            Break;
        end
        else
          Break;
      until eternity;
    end
    else
    begin
      c := Count - 1;
      for i := 0 to c do
        if CompareStrings(FItems[i].FString, Str) = 0 then
        begin
          FFindIndex := i;
          Break;
        end;
    end;
  end;
  smAVL, smHash:
  begin
    if FSearchMethod = smAVL then
      CurItem := FAVLRoot
    else if FHashItems <> nil then
      CurItem := FHashItems[HashFunc(Str)].FAVLRoot
    else
      CurItem := nil;

    if CurItem <> nil then
    begin
      repeat
        c := CompareStrings(Str, FItems[CurItem.FData].FString);
        if c < 0 then
          CurItem := CurItem.LeftChild
        else if c > 0 then
          CurItem := CurItem.RightChild
        else
          Break;
      until CurItem = nil;

      if CurItem <> nil then
        FFindIndex := CurItem.FData;
    end;
  end;
  end;

  result := FFindIndex;
end;

function TTXStringList.FindNext: Integer;
var
  CurItem:  TTXAVLItem;
  i, c, s:  Integer;
begin
  if FFindIndex >= 0 then
    case FSearchMethod of
    smLinear:
    begin
      c := Count - 1;

      if FSorted then
      begin
        // !!!Überprüfen: Diese Routine funktioniert möglicherweise nicht
        //                richtig.

        if FFindIndex >= c then
          FFindIndex := -1
        else if CompareStrings(FItems[FFindIndex + 1].FString, FFindStr) = 0 then
          inc(FFindIndex)
        else
          FFindIndex := -1;
      end
      else
      begin
        s := FFindIndex + 1;
        FFindIndex := -1;
        for i := s to c do
          if CompareStrings(FItems[i].FString, FFindStr) = 0 then
          begin
            FFindIndex := i;
            Break;
          end;
      end;
    end;
    smAVL, smHash:
    begin
      CurItem := FItems[FFindIndex].FAVLItem;
      if CurItem.FNext <> nil then
        FFindIndex := CurItem.FNext.FData
      else
        FFindIndex := -1;
    end;
    end;

  result := FFindIndex;
end;

function TXLIB_CompareFunc(List: TTXStringList; Index1, Index2: Integer; UserData: Pointer): Integer;
begin
  if Boolean(UserData) then
    result := List.CompareStrings(List.Strings[Index1], List.Strings[Index2])
  else
    result := List.CompareStrings(List.Strings[Index2], List.Strings[Index1]);
end;

procedure TTXStringList.Sort(Ascending: Boolean = True);
begin
  if FCount > 1 then
    Sort(0, FCount - 1, Ascending);
end;

procedure TTXStringList.Sort(StartIndex, EndIndex: Integer; Ascending: Boolean = True);
begin
  CustomSort(StartIndex, EndIndex, TXLIB_CompareFunc, Pointer(Ascending));
end;

procedure TTXStringList.CustomSort(Compare: TTXStringListSortCompare; UserData: Pointer);
begin
  if FCount > 1 then
    CustomSort(0, FCount - 1, Compare, UserData);
end;

procedure TTXStringList.CustomSort(StartIndex, EndIndex: Integer; Compare: TTXStringListSortCompare; UserData: Pointer);
  procedure QuickSort(Left, Right: Integer);
  var
    l, r:   Integer;
    pivot:  Integer;
  begin
    repeat
      l := Left;
      r := Right;

      pivot := (l + r) shr 1;

      repeat
        while Compare(Self, l, pivot, UserData) < 0 do
          inc(l);
        while Compare(Self, r, pivot, UserData) > 0 do
          dec(r);

        if l <= r then
        begin
          InternalExchange(l, r);

          if l = pivot then
            pivot := r
          else if r = pivot then
            pivot := l;

          inc(l);
          dec(r);
        end;
      until l > r;

      if Left < r then
        QuickSort(Left, r);

      Left := l;
    until l >= Right;
  end;
begin
  if not FSorted then
  begin
    if StartIndex >= 0 then
      if StartIndex < FCount then
      begin
        if EndIndex >= 0 then
          if EndIndex < FCount then
          begin
            QuickSort(StartIndex, EndIndex);

            Exit;
          end;

        raise EtxXMLError.CreateFmt('Listindex out of bounds (Index = %d; Count = %d).', [ EndIndex, FCount ]);
      end;

    raise EtxXMLError.CreateFmt('Listindex out of bounds (Index = %d; Count = %d).', [ StartIndex, FCount ]);
  end;
end;

procedure TTXStringList.SetString(Index: Integer; const Value: AnsiString);
var
  NewIndex: Integer;
begin
  if Index >= 0 then
    if Index < FCount then
    begin
      if not FDuplicates then
        if CompareStrings(FItems[Index].FString, Value) = 0 then
        begin
          FItems[Index].FString := Value;

          Exit;
        end
        else if Find(Value) >= 0 then
          raise EtxXMLError.Create('Duplicates are not allowed.');

      case FSearchMethod of
      smAVL:
      begin
        FItems[Index].FAVLItem.Delete(FAVLRoot);
        FreeAndNil(FItems[Index].FAVLItem);
      end;
      smHash:
      begin
        FItems[Index].FAVLItem.Delete(FHashItems[HashFunc(FItems[Index].FString)].FAVLRoot);
        FreeAndNil(FItems[Index].FAVLItem);
      end;
      end;

      if FSorted then
      begin
        BinarySearch(Value, NewIndex);

        FItems[Index].FString := Value;

        if Index <> NewIndex then
          if NewIndex < Index then
          begin
            InternalMove(Index, NewIndex);
            Index := NewIndex;
          end
          else
          begin
            InternalMove(Index, NewIndex - 1);
            Index := NewIndex - 1;
          end;
      end
      else
        FItems[Index].FString := Value;

      case FSearchMethod of
      smAVL: FItems[Index].FAVLItem := AVLAddItem(FAVLRoot, Index);
      smHash: FItems[Index].FAVLItem := AVLAddItem(FHashItems[HashFunc(Value)].FAVLRoot, Index);
      end;

      Exit;
    end;

  raise EtxXMLError.CreateFmt('Listindex out of bounds (Index = %d; Count = %d).', [ Index, FCount ]);
end;

function TTXStringList.GetString(Index: Integer): AnsiString;
begin
  if Index >= 0 then
    if Index < FCount then
    begin
      result := FItems[Index].FString;
      Exit;
    end;

  raise EtxXMLError.CreateFmt('Listindex out of bounds (Index = %d; Count = %d).', [ Index, FCount ]);
end;

procedure TTXStringList.SetObject(Index: Integer; Value: TObject);
begin
  if Index >= 0 then
    if Index < FCount then
    begin
      FItems[Index].FObject := Value;
      Exit;
    end;

  raise EtxXMLError.CreateFmt('Listindex out of bounds (Index = %d; Count = %d).', [ Index, FCount ]);
end;

function TTXStringList.GetObject(Index: Integer): TObject;
begin
  if Index >= 0 then
    if Index < FCount then
    begin
      result := FItems[Index].FObject;
      Exit;
    end;

  raise EtxXMLError.CreateFmt('Listindex out of bounds (Index = %d; Count = %d).', [ Index, FCount ]);
end;

procedure TTXStringList.SetSorted(Sorted: Boolean);
begin
  if Sorted <> FSorted then
  begin
    if Sorted then
      Sort;

    FSorted := Sorted;
  end;
end;

procedure TTXStringList.SetDuplicates(Duplicates: Boolean);
begin
  if Duplicates <> FDuplicates then
  begin
    FDuplicates := Duplicates;

    if not Duplicates then
      Rebuild;
  end;
end;

procedure TTXStringList.SetCaseSensitive(CaseSensitive: Boolean);
begin
  if CaseSensitive <> FCaseSensitive then
  begin
    FCaseSensitive := CaseSensitive;

    if FSorted or (FSearchMethod <> smLinear) then
      Rebuild;
  end;
end;

procedure TTXStringList.SetUmlaut(Umlaut: Boolean);
begin
  if Umlaut <> FUmlaut then
  begin
    FUmlaut := Umlaut;

    if not FCaseSensitive then
      if FSorted or (FSearchMethod <> smLinear) then
        Rebuild;
  end;
end;

procedure TTXStringList.SetTrimmed(Trimmed: Boolean);
begin
  if Trimmed <> FTrimmed then
  begin
    FTrimmed := Trimmed;

    if FSorted or (FSearchMethod <> smLinear) then
      Rebuild;
  end;
end;

procedure TTXStringList.SetSearchMethod(SearchMethod: TTXSearchMethod);
begin
  if SearchMethod <> FSearchMethod then
  begin
    if FSearchMethod <> smLinear then
      AVLFree(FItems, FCount);

    FSearchMethod := SearchMethod;

    if SearchMethod <> smLinear then
      Rebuild;
  end;
end;

procedure TTXStringList.SetHashSize(Hashsize: Integer);
begin
  if HashSize < 1 then
    HashSize := 1;

  if HashSize <> FHashSize then
  begin
    FHashSize := HashSize;

    if FSearchMethod = smHash then
      Rebuild;
  end;
end;

procedure TTXStringList.SetText(Text: AnsiString);
var
  start, ptr: PAnsiChar;
  s:          AnsiString;
begin
  Clear;

  ptr := Pointer(Text);
  if ptr <> nil then
    while ptr^ <> #0 do
    begin
      start := ptr;
      while not (ptr^ in [#0, #10, #13]) do
        inc(ptr);

      System.SetString(s, start, ptr - start);
      InsertItem(FCount, s, nil, False);

      if ptr^ = #13 then
        inc(ptr);
      if ptr^ = #10 then
        inc(ptr);
    end;
end;

function TTXStringList.GetText: AnsiString;
var
  i, l, c, size:  Integer;
  ptr:            PAnsiChar;
  s, lb:          AnsiString;
begin
  c := FCount - 1;
  Size := 0;
  lb := sLineBreak;

  for i := 0 to c do
    inc(size, Length(FItems[i].FString) + Length(lb));

  System.SetString(result, nil, size);

  ptr := Pointer(result);
  for i := 0 to c do
  begin
    s := FItems[i].FString;
    l := Length(s);
    if l <> 0 then
    begin
      System.Move(Pointer(s)^, ptr^, l);
      inc(ptr, l);
    end;
    l := Length(lb);
    if l <> 0 then
    begin
      System.Move(Pointer(lb)^, ptr^, l);
      inc(ptr, l);
    end;
  end;
end;

function TTXStringList.InsertItem(Index: Integer; const Str: AnsiString; AObject: TObject; RaiseException: Boolean): Integer;
var
  Delta:  Integer;
  i:      Integer;
  hash:   Cardinal;
begin
  if not FDuplicates then
    if Find(Str) >= 0 then
      if RaiseException then
        raise EtxXMLError.Create('Duplicates are not allowed.')
      else
      begin
        result := -1;

        Exit;
      end;

  if FItemsLength = 0 then
  begin
    FItemsLength := 2;
    FItems := AllocMem(2 * sizeof(TTXStringListItem));
  end
  else if FCount = FItemsLength then
  begin
    if FItemsLength > 64 then
      Delta := FItemsLength shr 2
    else if FItemsLength > 8 then
      Delta := 16
    else
      Delta := 8;

    inc(FItemsLength, Delta);

    ReAllocMem(FItems, FItemsLength * sizeof(TTXStringListItem));
  end;

  if FSorted then
    BinarySearch(Str, Index);

  if Index < FCount then
  begin
    System.Move(FItems^[Index], FItems^[Index + 1], (FCount - Index) * sizeof(TTXStringListItem));

    if FSearchMethod <> smLinear then
      for i := Index + 1 to FCount do
        inc(FItems[i].FAVLItem.FData);
  end;

  with FItems[Index] do
  begin
    Pointer(FString) := nil;
    FString := Str;
    FObject := AObject;
    FAVLItem := nil;
  end;

  case FSearchMethod of
  smAVL: FItems[Index].FAVLItem := AVLAddItem(FAVLRoot, Index);
  smHash:
  begin
    if FHashItems = nil then
    begin
      FHashItems := AllocMem(FHashSize * sizeof(TTXStringListHashItem));
      ZeroMemory(FHashItems, FHashSize * sizeof(TTXStringListHashItem));
    end;

    hash := HashFunc(Str);

    FItems[Index].FAVLItem := AVLAddItem(FHashItems[hash].FAVLRoot, Index);
  end;
  end;

  inc(FCount);

  result := Index;
end;

procedure TTXStringList.InternalExchange(Index1, Index2: Integer);
var
  Temp:   TTXStringListItem;
begin
  Temp.FString := FItems[Index1].FString;
  Temp.FObject := FItems[Index1].FObject;
  FItems[Index1].FString := FItems[Index2].FString;
  FItems[Index1].FObject := FItems[Index2].FObject;
  FItems[Index2].FString := Temp.FString;
  FItems[Index2].FObject := Temp.FObject;

  if FSearchMethod <> smLinear then
  begin
    Temp.FAVLItem := FItems[Index1].FAVLItem;
    FItems[Index1].FAVLItem := FItems[Index2].FAVLItem;
    FItems[Index2].FAVLItem := Temp.FAVLItem;

    FItems[Index1].FAVLItem.FData := Index1;
    FItems[Index2].FAVLItem.FData := Index2;
  end;
end;

procedure TTXStringList.InternalMove(CurIndex, NewIndex: Integer);
var
  Temp:   TTXStringListItem;
  i, c:   Integer;
begin
  if CurIndex <> NewIndex then
  begin
    Temp.FString := FItems[CurIndex].FString;
    Temp.FObject := FItems[CurIndex].FObject;
    Temp.FAVLItem := FItems[CurIndex].FAVLItem;

    Finalize(FItems^[CurIndex]);

    if NewIndex < CurIndex then
    begin
      if FSearchMethod <> smLinear then
      begin
        c := CurIndex - 1;
        for i := NewIndex to c do
          if FItems[i].FAVLItem <> nil then
            FItems[i].FAVLItem.FData := i + 1;
      end;

      System.Move(FItems^[NewIndex], FItems^[NewIndex + 1], (CurIndex - NewIndex) * sizeof(TTXStringListItem));
    end
    else
    begin
      System.Move(FItems^[CurIndex + 1], FItems^[CurIndex], (NewIndex - CurIndex) * sizeof(TTXStringListItem));

      if FSearchMethod <> smLinear then
      begin
        c := NewIndex - 1;
        for i := CurIndex to c do
          if FItems[i].FAVLItem <> nil then
            FItems[i].FAVLItem.FData := i + 1;
      end;
    end;

    Pointer(FItems[NewIndex].FString) := nil;
    FItems[NewIndex].FString := Temp.FString;
    FItems[NewIndex].FObject := Temp.FObject;
    FItems[NewIndex].FAVLItem := Temp.FAVLItem;

    if FSearchMethod <> smLinear then
      if FItems[NewIndex].FAVLItem <> nil then
        FItems[NewIndex].FAVLItem.FData := NewIndex;
  end;
end;

function TTXStringList.BinarySearch(const Str: AnsiString; var IndexToInsert: Integer): Integer;
var
  l, r, c:  Integer;
begin
  result := -1;

  IndexToInsert := 0;

  if FCount > 0 then
  begin
  	l := 0;
	  r := FCount - 1;

	  repeat
		  IndexToInsert := (l + r) shr 1;

      c := CompareStrings(Str, FItems[IndexToInsert].FString);
		  if c < 0 then
        r := IndexToInsert - 1
		  else if c > 0 then
			  l := IndexToInsert + 1
		  else
      begin
        result := IndexToInsert;
			  Break;
      end;

		  if l > r then
      begin
			  IndexToInsert := l;

			  Break;
      end;
		until eternity;
  end;
end;

function TTXStringList.AVLAddItem(var Root: TTXAVLItem; Index: Integer): TTXAVLItem;
var
  CurItem:  TTXAVLItem;
  c:        Integer;
begin
  if Root <> nil then
  begin
    result := nil;

    CurItem := Root;

    repeat
      c := CompareStrings(FItems[Index].FString, FItems[CurItem.FData].FString);
      if c = 0 then // Duplikate fallen in eine LinkedList
      begin
        result := TTXAVLItem.Create;
        result.FData := Index;

        if CurItem.FNext <> nil then
        begin
          result.FNext := CurItem.FNext;
          CurItem.FNext.FPrev := result;
          CurItem.FNext := result;
        end
        else
          CurItem.FNext := result;

        result.FPrev := CurItem;

        Exit;
      end
      else if c < 0 then
      begin
        if CurItem.FLeftChild = nil then
        begin
          result := TTXAVLItem.Create;
          result.FData := Index;

          CurItem.FLeftChild := result;
          result.FParent := curItem;

          Break;
        end
        else
          CurItem := CurItem.FLeftChild;
      end
      else if CurItem.FRightChild = nil then
      begin
        result := TTXAVLItem.Create;
        result.FData := Index;

        CurItem.FRightChild := result;
        result.FParent := CurItem;

        Break;
      end
      else
        CurItem := CurItem.FRightChild;
    until eternity;

    CurItem := result;

    while CurItem <> nil do
    begin
      CurItem.UpdateHeight;
      CurItem.Rebalance(Root);

      CurItem := CurItem.FParent;
    end;
  end
  else
  begin
    result := TTXAVLItem.Create;
    result.FData := Index;

    Root := result;
  end;
end;

procedure TTXStringList.AVLFree(Items: PTXStringListItemArray; Count: Integer);
var
  i:  Integer;
begin
  if (FAVLRoot <> nil) or (FHashItems <> nil) then
  begin
    dec(Count);
    for i := 0 to Count do
      if Items[i].FAVLItem <> nil then
        FreeAndNil(Items[i].FAVLItem);

    FAVLRoot := nil;

    if FHashItems <> nil then
    begin
      FreeMem(FHashItems);
      FHashItems := nil;
    end;
  end;
end;

procedure TTXStringList.PrepareString(var Str: AnsiString);
begin
  if Assigned(FPrepareProc) then
    FPrepareProc(Str);

  if FTrimmed then
    Str := Trim(Str);

  if not FCaseSensitive then
    if FUmlaut then
      Str := AnsiLowerCase(Str)
    else
      Str := LowerCase(Str);

  {if FTrimmed or not FCaseSensitive then
  begin
    psrc := PAnsiChar(Str);
    if psrc <> nil then
    begin
      if FTrimmed then
      begin
        pstart := nil;
        pend := psrc;
        pstr := psrc;
        repeat
          chr := pstr^;
          if chr = #0 then
            Break;
          if chr <> ' ' then
          begin
            if pstart = nil then
              pstart := pstr;

            pend := pstr;
          end;

          inc(pstr);
        until eternity;

        if pstart = nil then
        begin
          SetLength(Str, 0);
          Exit;
        end;

        inc(pend);

        l := pend - pstart;

        if pstart <> psrc then
          MoveMemory(psrc, pstart, l);

        SetLength(Str, l);

        psrc := PAnsiChar(Str);
      end;

      if not FCaseSensitive then
      begin
        repeat
          chr := psrc^;
          if chr = #0 then
            Break;

          if (chr >= 'A') and (chr <= 'Z') then
            inc(psrc^, 32)
          else if FUmlaut then
            case chr of
            'Ä': psrc^ := 'ä';
            'Ü': psrc^ := 'ü';
            'Ö': psrc^ := 'ö';
            'É': psrc^ := 'é';
            'Ú': psrc^ := 'ú';
            'Í': psrc^ := 'í';
            'Ó': psrc^ := 'ó';
            'Á': psrc^ := 'á';
            'Ý': psrc^ := 'ý';
            'È': psrc^ := 'è';
            'Ù': psrc^ := 'ù';
            'Ì': psrc^ := 'ì';
            'Ò': psrc^ := 'ò';
            'À': psrc^ := 'à';
            'Ê': psrc^ := 'ê';
            'Û': psrc^ := 'û';
            'Î': psrc^ := 'î';
            'Ô': psrc^ := 'ô';
            'Â': psrc^ := 'â';
            end;

          inc(psrc);
        until eternity;
      end;
    end;
  end;}
end;

var StringList_HashTab: array[0..255] of Cardinal = (
  6718, 3420, 11116, 2411, 9146, 2747, 12190, 5874, 7308, 9398, 15796, 10200,
  9596, 4004, 9334, 9301, 10145, 12976, 9540, 7572, 12700, 9597, 40, 12453, 865,
  2403, 3721, 12322, 693, 11134, 5777, 7088, 12573, 12513, 11701, 9677, 13691,
  3067, 9250, 11097, 4880, 13472, 12111, 12919, 13416, 3639, 9398, 12774, 4910,
  4403, 10430, 3080, 7308, 7889, 14665, 3851, 3493, 12322, 5767, 12085, 13265,
  5922, 9531, 4355, 15940, 1383, 13337, 10855, 5752, 14991, 3818, 6312, 7551,
  268, 6163, 5055, 6930, 4000, 858, 1039, 3240, 5882, 8621, 5651, 9058, 1811,
  696, 5091, 4480, 8983, 10362, 8264, 166, 8939, 10746, 9528, 4062, 12148,
  14359, 6165, 4824, 854, 9683, 1724, 2571, 15911, 751, 14072, 2426, 7400,
  13624, 15333, 10597, 396, 470, 12420, 7127, 10745, 12923, 9515, 7985, 15387,
  15758, 1881, 6620, 4914, 2315, 594, 9376, 7538, 4455, 8612, 14122, 2388, 3318,
  3561, 12618, 15628, 916, 13929, 13071, 240, 15092, 9726, 14244, 10615, 13089,
  11128, 7344, 1611, 7084, 13472, 4074, 9327, 11807, 1321, 7433, 1060, 2566,
  8640, 10256, 8131, 425, 462, 3944, 14969, 1283, 739, 1109, 2350, 6399, 13824,
  15130, 9427, 8537, 2606, 64, 5566, 13580, 7508, 10492, 15687, 12177, 4530,
  8840, 852, 2092, 8884, 12569, 2760, 3297, 4669, 1581, 1609, 15566, 951, 3360,
  14837, 9633, 6848, 9718, 10151, 317, 12873, 11442, 4355, 1463, 11036, 1268,
  15667, 760, 8516, 7813, 5255, 14391, 12289, 5410, 2060, 110, 8151, 2186,
  11204, 13811, 13390, 15705, 4691, 2284, 8234, 7492, 5779, 15942, 11712, 7957,
	10325, 1201, 14351, 13700, 484, 310, 511, 10276, 6337, 2266, 1455, 5088, 8479,
	12482, 9864, 4984, 4242, 2593, 9301, 11992, 10755, 10691, 13047
);

function TTXStringList.HashFunc(Str: AnsiString): Cardinal;
var
  chr, tab, i:  Cardinal;
  ptr:          PAnsiChar;
begin
  result := 0;

  PrepareString(Str);

  ptr := PAnsiChar(Str);
  if ptr <> nil then
  begin
    i := 1;
    while ptr^ <> #0 do
    begin
      chr := Cardinal(ptr^);
      tab := StringList_HashTab[(chr or i or ((result shr 16) and $FF) or (result and $FF)) and $FF];
      result := (11 * chr * i + tab * (chr and 3) + tab + chr + i) mod Cardinal(FHashSize);

      inc(i);
      inc(ptr);
    end;
  end;
end;

procedure TTXStringList.Rebuild;
var
  FItemsOld:  PTXStringListItemArray;
  i, c:       Integer;
begin
  if FCount > 0 then
  begin
    AVLFree(FItems, FCount);

    c := FCount - 1;

    FItemsOld := FItems;
    FItems := nil;
    FFindIndex := -1;

    try
      FCount := 0;
      FItemsLength := 0;

      for i := 0 to c do
        InsertItem(FCount, FItemsOld[i].FString, FItemsOld[i].FObject, False);
    finally
      inc(c);

      Finalize(FItemsOld^[0], c);
      FreeMem(FItemsOld);
    end;
  end;
end;

type
  TTXXMLStandardEntities = packed record
    N:  AnsiString;
    C:  WideChar;
  end;

const XMLStandardEntities: array[0..4] of TTXXMLStandardEntities = (
  (N: 'quot'; C: #34), (N: 'amp'; C: #38), (N: 'apos'; C: #39),
  (N: 'lt'; C: #60), (N: 'gt'; C: #62));

const HTMLStandardEntities: array[0..243] of TTXXMLStandardEntities = (
  (N: 'quot'; C: #34), (N: 'amp'; C: #38), (N: 'apos'; C: #39),
  (N: 'lt'; C: #60), (N: 'gt'; C: #62), (N: 'nbsp'; C: #160),
  (N: 'iexcl'; C: #161), (N: 'cent'; C: #162), (N: 'pound'; C: #163),
  (N: 'curren'; C: #164), (N: 'yen'; C: #165), (N: 'brvbar'; C: #166),
  (N: 'sect'; C: #167), (N: 'uml'; C: #168), (N: 'copy'; C: #169),
  (N: 'ordf'; C: #170), (N: 'laquo'; C: #171),
  (N: 'not'; C: #172), (N: 'shy'; C: #173),
  (N: 'reg'; C: #174), (N: 'macr'; C: #175), (N: 'deg'; C: #176),
  (N: 'plusmn'; C: #177), (N: 'sup2'; C: #178), (N: 'sup3'; C: #179),
  (N: 'acute'; C: #180), (N: 'micro'; C: #181), (N: 'para'; C: #182),
  (N: 'middot'; C: #183), (N: 'cedil'; C: #184), (N: 'sup1'; C: #185),
  (N: 'ordm'; C: #186), (N: 'raquo'; C: #187), (N: 'frac14'; C: #188),
  (N: 'frac12'; C: #189), (N: 'frac34'; C: #190), (N: 'iquest'; C: #191),
  (N: 'Agrave'; C: #192), (N: 'Aacute'; C: #193), (N: 'Acirc'; C: #194),
  (N: 'Atilde'; C: #195), (N: 'Auml'; C: #196), (N: 'Aring'; C: #197),
  (N: 'AElig'; C: #198), (N: 'Ccedil'; C: #199), (N: 'Egrave'; C: #200),
  (N: 'Eacute'; C: #201), (N: 'Ecirc'; C: #202), (N: 'Euml'; C: #203),
  (N: 'Igrave'; C: #204), (N: 'Iacute'; C: #205), (N: 'Icirc'; C: #206),
  (N: 'Iuml'; C: #207), (N: 'ETH'; C: #208), (N: 'Ntilde'; C: #209),
  (N: 'Ograve'; C: #210), (N: 'Oacute'; C: #211), (N: 'Ocirc'; C: #212),
  (N: 'Otilde'; C: #213), (N: 'Ouml'; C: #214), (N: 'times'; C: #215),
  (N: 'Oslash'; C: #216), (N: 'Ugrave'; C: #217), (N: 'Uacute'; C: #218),
  (N: 'Ucirc'; C: #219), (N: 'Uuml'; C: #220), (N: 'Yacute'; C: #221),
  (N: 'THORN'; C: #222), (N: 'szlig'; C: #223), (N: 'agrave'; C: #224),
  (N: 'aacute'; C: #225), (N: 'acirc'; C: #226), (N: 'atilde'; C: #227),
  (N: 'auml'; C: #228), (N: 'aring'; C: #229), (N: 'aelig'; C: #230),
  (N: 'ccedil'; C: #231), (N: 'egrave'; C: #232), (N: 'eacute'; C: #233),
  (N: 'ecirc'; C: #234), (N: 'euml'; C: #235), (N: 'igrave'; C: #236),
  (N: 'iacute'; C: #237), (N: 'icirc'; C: #238), (N: 'iuml'; C: #239),
  (N: 'eth'; C: #240), (N: 'ntilde'; C: #241), (N: 'ograve'; C: #242),
  (N: 'oacute'; C: #243), (N: 'ocirc'; C: #244), (N: 'otilde'; C: #245),
  (N: 'ouml'; C: #246), (N: 'divide'; C: #247), (N: 'oslash'; C: #248),
  (N: 'ugrave'; C: #249), (N: 'uacute'; C: #250), (N: 'ucirc'; C: #251),
  (N: 'uuml'; C: #252), (N: 'yacute'; C: #253), (N: 'thorn'; C: #254),
  (N: 'yuml'; C: #255), (N: 'Alpha'; C: #913), (N: 'alpha'; C: #945),
  (N: 'Beta'; C: #914), (N: 'beta'; C: #946), (N: 'Gamma'; C: #915),
  (N: 'gamma'; C: #947), (N: 'Delta'; C: #916), (N: 'delta'; C: #948),
  (N: 'Epsilon'; C: #917), (N: 'epsilon'; C: #949), (N: 'Zeta'; C: #918),
  (N: 'zeta'; C: #950), (N: 'Eta'; C: #919), (N: 'eta'; C: #951),
  (N: 'Theta'; C: #920), (N: 'theta'; C: #952), (N: 'Iota'; C: #921),
  (N: 'iota'; C: #953), (N: 'Kappa'; C: #922), (N: 'kappa'; C: #954),
  (N: 'Lambda'; C: #923), (N: 'lambda'; C: #955), (N: 'Mu'; C: #924),
  (N: 'mu'; C: #956), (N: 'Nu'; C: #925), (N: 'nu'; C: #957),
  (N: 'Xi'; C: #926), (N: 'xi'; C: #958), (N: 'Omicron'; C: #927),
  (N: 'omicron'; C: #959), (N: 'Pi'; C: #928), (N: 'pi'; C: #960),
  (N: 'Rho'; C: #929), (N: 'rho'; C: #961), (N: 'Sigma'; C: #931),
  (N: 'sigmaf'; C: #962), (N: 'sigma'; C: #963), (N: 'Tau'; C: #932),
  (N: 'tau'; C: #964), (N: 'Upsilon'; C: #933), (N: 'upsilon'; C: #965),
  (N: 'Phi'; C: #934), (N: 'phi'; C: #966), (N: 'Chi'; C: #935),
  (N: 'chi'; C: #967), (N: 'Psi'; C: #936), (N: 'psi'; C: #968),
  (N: 'Omega'; C: #937), (N: 'omega'; C: #969), (N: 'thetasym'; C: #977),
  (N: 'upsih'; C: #978), (N: 'piv'; C: #982), (N: 'forall'; C: #8704),
  (N: 'part'; C: #8706), (N: 'exist'; C: #8707), (N: 'empty'; C: #8709),
  (N: 'nabla'; C: #8711), (N: 'isin'; C: #8712), (N: 'notin'; C: #8713),
  (N: 'ni'; C: #8715), (N: 'prod'; C: #8719), (N: 'sum'; C: #8721),
  (N: 'minus'; C: #8722), (N: 'lowast'; C: #8727), (N: 'radic'; C: #8730),
  (N: 'prop'; C: #8733), (N: 'infin'; C: #8734), (N: 'ang'; C: #8736),
  (N: 'and'; C: #8843), (N: 'or'; C: #8844), (N: 'cap'; C: #8745),
  (N: 'cup'; C: #8746), (N: 'int'; C: #8747), (N: 'there4'; C: #8756),
  (N: 'sim'; C: #8764), (N: 'cong'; C: #8773), (N: 'asymp'; C: #8776),
  (N: 'ne'; C: #8800), (N: 'equiv'; C: #8801), (N: 'le'; C: #8804),
  (N: 'ge'; C: #8805), (N: 'sub'; C: #8834), (N: 'sup'; C: #8835),
  (N: 'nsub'; C: #8836), (N: 'sube'; C: #8838), (N: 'supe'; C: #8839),
  (N: 'oplus'; C: #8853), (N: 'otimes'; C: #8855), (N: 'perp'; C: #8869),
  (N: 'sdot'; C: #8901), (N: 'loz'; C: #9674), (N: 'lceil'; C: #8968),
  (N: 'rceil'; C: #8969), (N: 'lfloor'; C: #8970),(N: 'rfloor'; C: #8971),
  (N: 'lang'; C: #9001), (N: 'rang'; C: #9002), (N: 'larr'; C: #8592),
  (N: 'uarr'; C: #8593), (N: 'rarr'; C: #8594), (N: 'darr'; C: #8595),
  (N: 'harr'; C: #8596), (N: 'crarr'; C: #8629), (N: 'lArr'; C: #8656),
  (N: 'uArr'; C: #8657), (N: 'rArr'; C: #8658), (N: 'dArr'; C: #8659),
  (N: 'hArr'; C: #8660), (N: 'bull'; C: #8226), (N: 'hellip'; C: #8230),
  (N: 'prime'; C: #8242), (N: 'oline'; C: #8254), (N: 'frasl'; C: #8260),
  (N: 'weierp'; C: #8472), (N: 'image'; C: #8465), (N: 'real'; C: #8476),
  (N: 'trade'; C: #8482), (N: 'euro'; C: #8364), (N: 'alefsym'; C: #8501),
  (N: 'spades'; C: #9824), (N: 'clubs'; C: #9827), (N: 'hearts'; C: #9829),
  (N: 'diams'; C: #9830), (N: 'ensp'; C: #8194), (N: 'emsp'; C: #8195),
  (N: 'thinsp'; C: #8201), (N: 'zwnj'; C: #8204), (N: 'zwj'; C: #8205),
  (N: 'lrm'; C: #8206), (N: 'rlm'; C: #8207), (N: 'ndash'; C: #8211),
  (N: 'mdash'; C: #8212), (N: 'lsquo'; C: #8216), (N: 'rsquo'; C: #8217),
  (N: 'sbquo'; C: #8218), (N: 'ldquo'; C: #8220), (N: 'rdquo'; C: #8221),
  (N: 'bdquo'; C: #8222), (N: 'dagger'; C: #8224), (N: 'Dagger'; C: #8225),
  (N: 'permil'; C: #8240), (N: 'lsaquo'; C: #8249), (N: 'rsaquo'; C: #8250));

constructor TTXXMLEntities.Create;
begin
  FEntities := TTXStringList.Create;
  FEntities.SearchMethod := smHash;
  FEntities.Hashsize := 1024;

  FCharacter := AllocMem(65536 * sizeof(TTXXMLEntitiesItem));
  ZeroMemory(FCharacter, 65536 * sizeof(TTXXMLEntitiesItem));
end;

destructor TTXXMLEntities.Destroy;
begin
  Clear;

  FEntities.Free;
  FreeMem(FCharacter);

  inherited;
end;

procedure TTXXMLEntities.Clear;
begin
  Finalize(FCharacter^[0], 65536);
  ZeroMemory(FCharacter, 65536 * sizeof(TTXXMLEntitiesItem));

  FEntities.Clear;
end;

function TTXXMLEntities.Add(Character: WideChar; Name: AnsiString): Integer;
begin
  if Pointer(FCharacter[Cardinal(Character)].FName) = nil then
  begin
    Name := WellEntity(Name);
    if Name <> '' then
    begin
      if FEntities.Find(Name) < 0 then
      begin
        FCharacter[Cardinal(Character)].FName := Name;

        result := FEntities.AddObject(Name, TObject(Character));
      end
      else
        raise EtxXMLError.Create('Entityname already exists.');
    end
    else
      raise EtxXMLError.Create('Entityname cannot be empty.');
  end
  else
    raise EtxXMLError.Create('Entitycharacter already exists.');
end;

procedure TTXXMLEntities.AddStandardXMLEntities;
var
  i:  Integer;
begin
  for i := 0 to 4 do
    try
      Add(XMLStandardEntities[i].C, XMLStandardEntities[i].N);
    except
    end;
end;

procedure TTXXMLEntities.AddStandardHTMLEntities;
var
  i:  Integer;
begin
  for i := 0 to 243 do
    try
      Add(XMLStandardEntities[i].C, HTMLStandardEntities[i].N);
    except
    end;
end;

procedure TTXXMLEntities.Delete(Index: Integer);
var
  Character:  Cardinal;
begin
  if Index >= 0 then
    if Index < Count then
    begin
      Character := Cardinal(FEntities.Objects[Index]);

      Finalize(FCharacter^[Character]);
      Pointer(FCharacter[Character].FName) := nil;

      FEntities.Delete(Index);

      Exit;
    end;

  raise EtxXMLError.CreateFmt('Entityindex out of bounds (Index = %d; Count = %d).', [ Index, Count ]);
end;

function TTXXMLEntities.IndexOfEntity(const Name: AnsiString): Integer;
begin
  result := FEntities.Find(Name);
end;

function TTXXMLEntities.EntityExists(const Name: AnsiString): Boolean;
begin
  result := IndexOfEntity(Name) >= 0;
end;

function TTXXMLEntities.IndexOfCharacter(Character: WideChar): Integer;
begin
  result := IndexOfEntity(FCharacter[Cardinal(Character)].FName);
end;

function TTXXMLEntities.CharacterExists(Character: WideChar): Boolean;
begin
  result := IndexOfCharacter(Character) >= 0;
end;

procedure TTXXMLEntities.SetEntity(Index: Integer; Value: AnsiString);
begin
  if Index >= 0 then
    if Index < Count then
    begin
      Value := WellEntity(Value);
      if Value = FEntities.Strings[Index] then
        Exit;

      if FEntities.Find(Value) >= 0 then
        raise EtxXMLError.Create('Entityname already exists.');

      FEntities.Strings[Index] := Value;
      FCharacter[Cardinal(FEntities.Objects[Index])].FName := Value;

      Exit;
    end;

  raise EtxXMLError.CreateFmt('Entityindex out of bounds (Index = %d; Count = %d).', [ Index, Count ]);
end;

function TTXXMLEntities.GetEntity(Index: Integer): AnsiString;
begin
  if Index >= 0 then
    if Index < Count then
    begin
      result := FEntities.Strings[Index];

      Exit;
    end;

  raise EtxXMLError.CreateFmt('Entityindex out of bounds (Index = %d; Count = %d).', [ Index, Count ]);
end;

procedure TTXXMLEntities.SetCharacter(Index: Integer; Value: WideChar);
var
  Character:  Cardinal;
begin
  if Index >= 0 then
    if Index < Count then
    begin
      Character := Cardinal(Value);
      if Character = Cardinal(FEntities.Objects[Index]) then
        Exit;

      if Pointer(FCharacter[Character].FName) <> nil then
        raise EtxXMLError.Create('Entitycharacter already exists.');

      Finalize(FCharacter^[Cardinal(FEntities.Objects[Index])]);
      Pointer(FCharacter^[Cardinal(FEntities.Objects[Index])].FName) := nil;

      FCharacter^[Cardinal(FEntities.Objects[Index])].FName := FEntities.Strings[Index];
      FEntities.Objects[Index] := TObject(Character);

      Exit;
    end;

  raise EtxXMLError.CreateFmt('Entityindex out of bounds (Index = %d; Count = %d).', [ Index, Count ]);
end;

function TTXXMLEntities.GetCharacter(Index: Integer): WideChar;
begin
  if Index >= 0 then
    if Index < Count then
    begin
      result := WideChar(FEntities.Objects[Index]);

      Exit;
    end;

  raise EtxXMLError.CreateFmt('Entityindex out of bounds (Index = %d; Count = %d).', [ Index, Count ]);
end;

function TTXXMLEntities.GetCount: Integer;
begin
  result := FEntities.Count;
end;

procedure TTXXMLEntities.SetCharacterOfEntity(const Name: AnsiString; Value: WideChar);
var
  i:  Integer;
begin
  i := FEntities.Find(Name);
  if i >= 0 then
    SetCharacter(i, Value)
  else
    raise EtxXMLError.Create('Entityname does not exists.');
end;

function TTXXMLEntities.GetCharacterOfEntity(const Name: AnsiString): WideChar;
var
  i:  Integer;
begin
  i := FEntities.Find(Name);
  if i >= 0 then
    result := GetCharacter(i)
  else
    raise EtxXMLError.Create('Entityname does not exists.');
end;

procedure TTXXMLEntities.SetEntityOfCharacter(Character: WideChar; const Value: AnsiString);
begin
  if Pointer(FCharacter[Cardinal(Character)].FName) <> nil then
    SetEntity(IndexOfEntity(FCharacter[Cardinal(Character)].FName), FCharacter[Cardinal(Character)].FName)
  else
    raise EtxXMLError.Create('Entitycharacter does not exists.');
end;

function TTXXMLEntities.GetEntityOfCharacter(Character: WideChar): AnsiString;
begin
  if Pointer(FCharacter[Cardinal(Character)].FName) <> nil then
    result := FCharacter[Cardinal(Character)].FName
  else
    raise EtxXMLError.Create('Entitycharacter does not exists.');
end;

function TTXXMLEntities.WellEntity(const Name: AnsiString): AnsiString;
begin
  result := LimitString(Name, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789');
end;

const
  XML_ATTRIBUTES_SEARCHMETHOD = smLinear;

function _EncodeUTF8(Src: PAnsiChar; var DestStr: PAnsiChar; var DestLen: Integer; StartPos: Integer = 0): Integer;
var
  pres:   PAnsiChar;
  chr:    AnsiChar;
  wc:     Word;
  cc:     Cardinal;
begin
  result := StartPos;

  if Src <> nil then
  begin
    pres := DestStr;
    inc(pres, StartPos);

    repeat
      chr := Src^;
      if chr = #0 then
        Break;

      if chr > #127 then
      begin
        if result + 4 >= DestLen then
        begin
          DestLen := (result + 4) shl 1;
          ReallocMem(DestStr, DestLen);
          pres := DestStr;
          inc(pres, result);
        end;

        MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, @chr, 1, PWideChar(@wc), 1);

        cc := Cardinal(wc);

        if cc > $1FFFFF then
        begin
          pres^ := '?';
          inc(pres);
          inc(result);
        end
        else if cc > $FFFF then
        begin
          pres^ := AnsiChar($F0 or ((cc shr 18) and $7));
          inc(pres);

          pres^ := AnsiChar($80 or ((cc shr 12) and $3F));
          inc(pres);

          pres^ := AnsiChar($80 or ((cc shr 6) and $3F));
          inc(pres);

          pres^ := AnsiChar($80 or (cc and $3F));
          inc(pres);

          inc(result, 4);
        end
        else if cc > $7FF then
        begin
          pres^ := AnsiChar($E0 or ((cc shr 12) and $F));
          inc(pres);

          pres^ := AnsiChar($80 or ((cc shr 6) and $3F));
          inc(pres);

          pres^ := AnsiChar($80 or (cc and $3F));
          inc(pres);

          inc(result, 3);
        end
        else if cc > $7F then
        begin
          pres^ := AnsiChar($C0 or ((cc shr 6) and $1F));
          inc(pres);

          pres^ := AnsiChar($80 or (cc and $3F));
          inc(pres);

          inc(result, 2);
        end
        else
        begin
          pres^ := AnsiChar(cc and $7F);
          inc(pres);

          inc(result);
        end;
      end
      else
      begin
        if (result + 16) >= DestLen then
        begin
          DestLen := (result + 16) shl 1;
          ReallocMem(DestStr, DestLen);
          pres := DestStr;
          inc(pres, result);
        end;

        pres^ := chr;
        inc(pres);
        inc(result);
      end;

      inc(Src);
    until eternity;

    pres^ := #0;
  end;

  dec(result, StartPos);
end;

function _DecodeUTF8(Src: PAnsiChar; var DestStr: PAnsiChar; var DestLen: Integer): Integer;
var
  pres:       PAnsiChar;
  chr:        AnsiChar;
  w1, w2, w3: Word;
  wc:         Word;
  cc:         Cardinal;
begin
  result := 0;

  if Src <> nil then
  begin
    w1 := 0;
    w2 := 0;
    w3 := 0;

    pres := DestStr;

    repeat
      chr := Src^;
      if chr = #0 then
        Break;

      if (Cardinal(chr) and $E0) = $C0 then
      begin
        inc(Src);
        if Src^ = #0 then
        begin
          pres^ := chr;
          inc(pres);
          inc(result);
          Break;
        end
        else if (Cardinal(Src^) and $C0) <> $80 then
        begin
          if (result + 16) >= DestLen then
          begin
            DestLen := (result + 16) shl 1;
            ReallocMem(DestStr, DestLen);
            pres := DestStr;
            inc(pres, result);
          end;

          pres^ := chr;
          inc(pres);
          inc(result);

          pres^ := Src^;
          inc(Src);
          inc(pres);
          inc(result);
        end
        else
        begin
          wc := ((Word(chr) and $1F) shl 6) or (Word(Src^) and $3F);
          if wc > 256 then
            WideCharToMultiByte(CP_ACP, 0, PWideChar(@wc), 1, @chr, 1, nil, nil)
          else
            chr := AnsiChar(wc);

          if chr >= #31 then
          begin
            pres^ := chr;
            inc(pres);
            inc(result);
          end;

          inc(Src);
        end;
      end
      else if (Word(chr) and $F0) = $E0 then
      begin
        if result + 3 >= DestLen then
        begin
          DestLen := (result + 3) shl 1;
          ReallocMem(DestStr, DestLen);
          pres := DestStr;
          inc(pres, result);
        end;

        inc(Src);
        if Src^ = #0 then
        begin
          pres^ := chr;
          inc(pres);
          inc(result);
          Break;
        end
        else
          w1 := Word(Src^);

        inc(Src);
        if Src^ = #0 then
        begin
          pres^ := chr;
          inc(pres);
          pres^ := AnsiChar(w1);
          inc(pres);
          inc(result, 2);
          Break;
        end
        else
          w2 := Word(Src^);

        if ((w1 and $C0) = $80) and ((w2 and $C0) = $80) then
        begin
          cc := ((Cardinal(chr) and $7) shl 18) or ((w1 and $3F) shl 12) or ((w2 and $3F) shl 6) or (w3 and $3F);
          if cc > $FFFF then
            chr := #32
          else
          begin
            wc := Word(cc);

            if wc > 256 then
              WideCharToMultiByte(CP_ACP, 0, PWideChar(@wc), 1, @chr, 1, nil, nil)
            else
              chr := AnsiChar(wc);
          end;

          if chr >= #31 then
          begin
            pres^ := chr;
            inc(result);
            inc(pres);
          end;

          inc(Src);
        end
        else
        begin
          pres^ := chr;
          inc(pres);
          pres^ := AnsiChar(w1);
          inc(pres);
          pres^ := AnsiChar(w2);
          inc(pres);
          inc(result, 3);
          inc(Src);
        end;
      end
      else if (Word(chr) and $F8) = $F0 then
      begin
        if result + 4 >= DestLen then
        begin
          DestLen := (result + 4) shl 1;
          ReallocMem(DestStr, DestLen);
          pres := DestStr;
          inc(pres, result);
        end;

        inc(Src);
        if Src^ = #0 then
        begin
          pres^ := chr;
          inc(pres);
          inc(result);
          Break;
        end
        else
          w1 := Word(Src^);

        inc(Src);
        if Src^ = #0 then
        begin
          pres^ := chr;
          inc(pres);
          pres^ := AnsiChar(w1);
          inc(pres);
          inc(result, 2);
          Break;
        end
        else
          w2 := Word(Src^);

        inc(Src);
        if Src^ = #0 then
        begin
          pres^ := chr;
          inc(pres);
          pres^ := AnsiChar(w1);
          inc(pres);
          pres^ := AnsiChar(w2);
          inc(pres);
          inc(result, 3);
          Break;
        end
        else
          w3 := Word(Src^);

        if ((w1 and $C0) = $80) and ((w2 and $C0) = $80) and ((w3 and $C0) = $80) then
        begin
          wc := ((Word(chr) and $F) shl 12) or ((w1 and $3F) shl 6) or (w2 and $3F);
          if wc > 256 then
            WideCharToMultiByte(CP_ACP, 0, PWideChar(@wc), 1, @chr, 1, nil, nil)
          else
            chr := AnsiChar(wc);

          if chr >= #31 then
          begin
            pres^ := chr;
            inc(pres);
            inc(result);
          end;

          inc(Src);
        end
        else
        begin
          pres^ := chr;
          inc(pres);
          pres^ := AnsiChar(w1);
          inc(pres);
          pres^ := AnsiChar(w2);
          inc(pres);
          pres^ := AnsiChar(w3);
          inc(pres);
          inc(result, 4);
          inc(Src);
        end;
      end
      else
      begin
        if (result + 16) >= DestLen then
        begin
          DestLen := (result + 16) shl 1;
          ReallocMem(DestStr, DestLen);
          pres := DestStr;
          inc(pres, result);
        end;

        pres^ := chr;
        inc(Src);
        inc(pres);
        inc(result);
      end;
    until eternity;

    pres^ := #0;
  end
  else
    DestStr^ := #0;
end;

function _TextToXMLText(Src: PAnsiChar; var DestStr: PAnsiChar; var DestLen: Integer; Entities: TTXXMLEntities = nil; Encoding: TTXXMLEncoding = xeNone; ReduceSpaces: Boolean = True; StartPos: Integer = 0): Integer;
var
  psrc:         PAnsiChar;
  psrcStart:    PAnsiChar;
  psrcDestLen:  Integer;
  dest:         PAnsiChar;
  str:          AnsiString;
  code:         WideChar;
  l:            Integer;
  wr:           Boolean;
begin
  result := StartPos;

  if Src <> nil then
  begin
    if Encoding = xeUTF8 then
    begin
      psrcDestLen := DestLen;
      if psrcDestLen < 32 then
        psrcDestLen := 32;

      psrc := AllocMem(psrcDestLen);
      psrcStart := psrc;

      _EncodeUTF8(Src, psrc, psrcDestLen);
    end
    else
    begin
      psrcStart := nil;
      psrc := Src;
    end;

    wr := False;

    dest := DestStr;
    inc(dest, StartPos);

    repeat
      if ReduceSpaces then
        while psrc^ = ' ' do
          inc(psrc);

      while psrc^ <> #0 do
      begin
        if ReduceSpaces then
          if psrc^ = ' ' then
            Break;

        if (psrc^ > #127) and (Encoding = xeNone) then
        begin
          wr := True;

          MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, psrc, 1, @code, 1);

          if result + 128 >= DestLen then
          begin
            DestLen := (result + 128) shl 1;
            ReallocMem(DestStr, DestLen);
            dest := DestStr;
            inc(dest, result);
          end;

          dest^ := '&';
          inc(dest);
          inc(result);

          if Entities <> nil then
          begin
            if Pointer(Entities.FCharacter[Cardinal(code)].FName) <> nil then
            begin
              l := Length(Entities.FCharacter[Cardinal(code)].FName);
              CopyMemory(dest, PAnsiChar(Entities.FCharacter[Cardinal(code)].FName), l);
            end
            else
            begin
              dest^ := '#';
              inc(dest);
              inc(result);

              str := IntToStr(Integer(code));

              l := Length(str);
              CopyMemory(dest, PAnsiChar(str), l);
            end;
          end
          else
          begin
            dest^ := '#';
            inc(dest);
            inc(result);

            str := IntToStr(Integer(code));

            l := Length(str);
            CopyMemory(dest, PAnsiChar(str), l);
          end;

          inc(dest, l);
          inc(result, l);

          dest^ := ';';
          inc(dest);
          inc(result, 1);
        end
        else if psrc^ in [ #34, #38, #39, #60, #62 ] then
        begin
          wr := True;

          if result + 16 >= DestLen then
          begin
            DestLen := (result + 16) shl 1;
            ReallocMem(DestStr, DestLen);
            dest := DestStr;
            inc(dest, result);
          end;

          dest^ := '&';
          inc(dest);
          inc(result);

          if Entities <> nil then
          begin
            if Pointer(Entities.FCharacter[Cardinal(psrc^)].FName) <> nil then
            begin
              l := Length(Entities.FCharacter[Cardinal(psrc^)].FName);
              CopyMemory(dest, PAnsiChar(Entities.FCharacter[Cardinal(psrc^)].FName), l);
            end
            else
            begin
              dest^ := '#';
              inc(dest);
              inc(result);

              str := IntToStr(Integer(psrc^));

              l := Length(str);
              CopyMemory(dest, PAnsiChar(str), l);
            end;
          end
          else
          begin
            dest^ := '#';
            inc(dest);
            inc(result);

            str := IntToStr(Integer(psrc^));

            l := Length(str);
            CopyMemory(dest, PAnsiChar(str), l);
          end;

          inc(dest, l);
          inc(result, l);

          dest^ := ';';
          inc(dest);
          inc(result, 1);

          {dest^ := '&';
          inc(dest);

          dest^ := '#';
          inc(dest);

          inc(result, 2);

          str := IntToStr(Integer(psrc^));
          l := Length(str);
          CopyMemory(dest, PAnsiChar(str), l);

          inc(dest, l);
          inc(result, l);

          dest^ := ';';
          inc(dest);
          inc(result);}
        end
        else if (psrc^ > #32) or (psrc^ in [ #13, #10 ]) or ((not ReduceSpaces) and (psrc^ = ' ')) then
        begin
          if not (psrc^ in [ ' ', #9, #13, #10 ]) then
            wr := True;

          if result + 16 >= DestLen then
          begin
            DestLen := (result + 16) shl 1;
            ReallocMem(DestStr, DestLen);
            dest := DestStr;
            inc(dest, result);
          end;

          dest^ := psrc^;
          inc(dest);
          inc(result);
        end;

        inc(psrc);

        if ReduceSpaces then
          if psrc^ = ' ' then
          begin
            if (result + 16) >= DestLen then
            begin
              DestLen := (result + 16) shl 1;
              ReallocMem(DestStr, DestLen);
              dest := DestStr;
              inc(dest, result);
            end;

            dest^ := ' ';
            inc(dest);
            inc(result);
          end;
      end;
    until psrc^ = #0;

    if ReduceSpaces and (not wr) then
    begin
      dest^ := #0;
      result := StartPos;
    end
    else
      dest^ := #0;

    if psrcStart <> nil then
      FreeMem(psrcStart);
  end;

  dec(result, StartPos);
end;

function _XMLTextToText(Src: PAnsiChar; var DestStr: PAnsiChar; var DestLen: Integer; Entities: TTXXMLEntities = nil; Encoding: TTXXMLEncoding = xeUTF8; ReduceSpaces: Boolean = True): Integer;
var
  tmpsrc:       PAnsiChar;
  tmpsrclen:    Integer;
  dest:         PAnsiChar;
  start:        PAnsiChar;
  entstart:     PAnsiChar;
  entend:       PAnsiChar;
  entdstart:    PAnsiChar;
  code:         WideChar;
  value, k:     Cardinal;
  chr:          AnsiChar;
  rchr, lchr:   AnsiChar;
  ui:           Integer;
  c, s:         Integer;
  wr:           Boolean;
begin
  result := 0;

  if Src <> nil then
  begin
    if Encoding = xeUTF8 then
    begin
      tmpsrclen := 128;
      tmpsrc := AllocMem(tmpsrclen);
      _DecodeUTF8(Src, tmpsrc, tmpsrclen);

      Src := tmpsrc;
    end
    else
      tmpsrc := nil;

    dest := DestStr;

    wr := False;

    repeat
      if ReduceSpaces then
        while Src^ = ' ' do
          inc(Src);

      lchr := ' ';
      ui := 0;

      start := Src;
      entstart := nil;
      entdstart := nil;
      repeat
        chr := Src^;
        case chr of
        #0: Break;
        ' ': if ReduceSpaces then Break;
        '&':
          if ui = 0 then
          begin
            entstart := Src;

            ui := 1;
          end
          else
            ui := 0;
        '#':
          if ui = 1 then
            ui := 2
          else
            ui := 0;
        ';':
        begin
          if ui >= 4 then
          begin
            c := entstart - start;
            if c > 0 then
            begin
              s := result + c;
              if s >= DestLen then
              begin
                DestLen := s shl 1;
                ReallocMem(DestStr, DestLen);
                dest := DestStr;
                inc(dest, result);
              end;

              CopyMemory(dest, start, c);
              inc(dest, c);
              inc(result, c);
            end;
            start := Src + 1;

            //SetString(ent, entdstart, src - entdstart);
            case ui of
            4:
              if Entities <> nil then
              begin
                src^ := #0;

                try
                  code := Entities.CharacterOfEntity[entdstart];
                except
                  code := #0;
                end;

                src^ := ';';
              end
              else
                code := #0;
            5:
            begin
              entend := src;
              dec(entend);

              value := 0;
              k := 1;
              repeat
                rchr := entend^;
                if rchr in ['0'..'9'] then
                begin
                  value := value + (Cardinal(rchr) - 48) * k;
                  k := k * 10;
                end
                else
                  Break;

                dec(entend);
              until eternity;

              if code <= #65535 then
                code := WideChar(value)
              else
                code := #0;
            end;
            6:
            begin
              entend := src;
              dec(entend);

              value := 0;
              k := 0;
              repeat
                rchr := entend^;
                if rchr in ['0'..'9'] then
                begin
                  value := value + ((Cardinal(rchr) - 48) shl k);
                  inc(k, 4);
                end
                else if rchr in ['A'..'F'] then
                begin
                  value := value + ((Cardinal(rchr) - 65) shl k);
                  inc(k, 4);
                end
                else if rchr in ['a'..'f'] then
                begin
                  value := value + ((Cardinal(rchr) - 97) shl k);
                  inc(k, 4);
                end
                else
                  Break;

                dec(entend);
              until eternity;

              if code <= #65535 then
                code := WideChar(value)
              else
                code := #0;
            end;
            else
              code := #0;
            end;

            case code of
            #0:
            begin
              c := Src - entstart + 1;
              if c > 0 then
              begin
                s := result + c;
                if s >= DestLen then
                begin
                  DestLen := s shl 1;
                  ReallocMem(DestStr, DestLen);
                  dest := DestStr;
                  inc(dest, result);
                end;

                CopyMemory(Dest, entstart, c);
                inc(dest, c);
                inc(result, c);
              end;
            end;
            #32:
            begin
              inc(src);
              ui := 0;
              Break;
            end;
            else
            begin
              WideCharToMultiByte(CP_ACP, 0, @code, 1, @rchr, 1, nil, nil);
              if rchr > #0 then
              begin
                s := result + 1;
                if s >= DestLen then
                begin
                  DestLen := s shl 1;
                  ReallocMem(DestStr, DestLen);
                  dest := DestStr;
                  inc(dest, result);
                end;

                dest^ := rchr;
                inc(dest);
                inc(result);
              end;
            end;
            end;

            code := #0;
          end;

          ui := 0;
        end;
        else
          case ui of
          1:
            if (chr in ['a'..'z']) or
               (chr in ['A'..'Z']) or
               (chr in ['0'..'9']) then
            begin
              ui := 4;
              entdstart := src;
            end
            else
              ui := 0;
          2:
            if chr in ['0'..'9'] then
              ui := 5
            else if (chr = 'x') or (chr = 'X') then
              ui := 3
            else
              ui := 0;
          3:
            if (chr in ['a'..'f']) or
               (chr in ['A'..'F']) or
               (chr in ['0'..'9']) then
              ui := 6
            else
              ui := 0;
          4:
            if not ((chr in ['a'..'z']) or
                    (chr in ['A'..'Z']) or
                    (chr in ['0'..'9'])) then
              ui := 0;
          5:
            if not (chr in ['0'..'9']) then
              ui := 0;
          6:
            if not ((chr in ['a'..'f']) or
                    (chr in ['A'..'F']) or
                    (chr in ['0'..'9'])) then
              ui := 0;
          end;
        end;

        if ui = 0 then
          lchr := src^;

        if ReduceSpaces then
          if not (src^ in [' ', #9, #13, #10]) then
            wr := True;

        inc(src);
      until eternity;

      if ui <> 0 then
        lchr := #0;

      c := src - start;
      if c > 0 then
      begin
        s := result + c;
        if s >= DestLen then
        begin
          DestLen := s shl 1;
          ReallocMem(DestStr, DestLen);
          dest := DestStr;
          inc(dest, result);
        end;

        CopyMemory(dest, start, c);
        inc(dest, c);
        inc(result, c);
      end;

      if src^ <> #0 then
        if ReduceSpaces and (lchr <> ' ') then
        begin
          s := result + 16;
          if s >= DestLen then
          begin
            DestLen := s shl 1;
            ReallocMem(DestStr, DestLen);
            dest := DestStr;
            inc(dest, result);
          end;

          dest^ := ' ';
          inc(dest);
          inc(result);
        end;
    until src^ = #0;

    if ReduceSpaces and (not wr) then
    begin
      DestStr^ := #0;
      result := 0;
    end
    else
      dest^ := #0;

    if tmpsrc <> nil then
      FreeMem(tmpsrc);
  end
  else
    DestStr^ := #0;
end;

constructor TTXXMLNode.Create(Parent: TTXXMLNodeElement; XMLDocument: TTXXMLDocument = nil);
begin
  FNodeType := dtNone;
  FParent := Parent;
  FDocument := XMLDocument;
end;

destructor TTXXMLNode.Destroy;
begin
  inherited;
end;

procedure TTXXMLNode.Assign(Node: TTXXMLNode);
begin
  if FNodeType = Node.FNodeType then
  begin
    case FNodeType of
    dtElement:
    begin

    end;
    dtText, dtCDATA: TTXXMLNodeText(Node).FText := TTXXMLNodeText(Self).FText;
    dtComment: TTXXMLNodeComment(Node).FComment := TTXXMLNodeComment(Self).FComment;
    end;
  end
  else
    raise ETXXMLError.Create('Nodetypes are unequal.');
end;

procedure TTXXMLNode.AssignTo(Node: TTXXMLNode);
begin
  Node.Assign(Self);
end;

constructor TTXXMLNodeText.Create(Parent: TTXXMLNodeElement; XMLDocument: TTXXMLDocument = nil);
begin
  inherited Create(Parent, XMLDocument);

  FNodeType := dtText;
end;

destructor TTXXMLNodeText.Destroy;
begin
  inherited;
end;

procedure TTXXMLNodeText.SetText(const Text: AnsiString);
begin
  FText := Text;
end;

procedure TTXXMLNodeText.SetIsCDATA(IsCDATA: Boolean);
begin
  if IsCDATA then
    FNodeType := dtCDATA
  else
    FNodeType := dtText;
end;

function TTXXMLNodeText.GetIsCDATA: Boolean;
begin
  result := FNodeType = dtCDATA;
end;

constructor TTXXMLNodeComment.Create(Parent: TTXXMLNodeElement; XMLDocument: TTXXMLDocument = nil);
begin
  inherited Create(Parent, XMLDocument);

  FNodeType := dtComment;
end;

destructor TTXXMLNodeComment.Destroy;
begin
  inherited;
end;

procedure TTXXMLNodeComment.SetComment(Comment: AnsiString);
begin
  if Pos('-->', Comment) = 0 then
    FComment := Comment
  else
    raise ETXXMLError.Create('Content to comment is invalid.');
end;

constructor TTXXMLNodeElement.Create(Parent: TTXXMLNodeElement; XMLDocument: TTXXMLDocument = nil);
begin
  inherited Create(Parent, XMLDocument);

  FChildNodes := nil;
  FAttributes := nil;

  FNodeType := dtElement;
end;

destructor TTXXMLNodeElement.Destroy;
begin
  ClearAttributes;
  Clear;

  inherited;
end;

procedure TTXXMLNodeElement.LoadFromFile(const Filename: AnsiString);
var
  Stream:   TFileStream;
begin
  Stream := TFileStream.Create(Filename, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TTXXMLNodeElement.LoadFromStream(Stream: TStream);
var
  Size: Integer;
  Str:  AnsiString;
begin
  Size := Stream.Size - Stream.Position;
  System.SetString(Str, nil, Size);
  Stream.Read(Pointer(Str)^, Size);
  SetText(Str);
end;

procedure TTXXMLNodeElement.SaveToFile(const Filename: AnsiString);
var
  Stream:   TFileStream;
begin
  Stream := TFileStream.Create(Filename, fmCreate or fmShareDenyWrite);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TTXXMLNodeElement.SaveToStream(Stream: TStream);
var
  Dest:     PAnsiChar;
  DestLen:  Integer;
  l:        Integer;
begin
  Dest := AllocMem(102400);
  DestLen := 102400;

  if FDocument <> nil then
    l := InternalGetXMLText(Dest, DestLen, True, FDocument.XMLEntities, FDocument.Encoding, FDocument.WriteVersion, FDocument.FUseTabs, FDocument.Spaces, PAnsiChar(FDocument.LineFeed), Length(FDocument.LineFeed))
  else
    l := InternalGetXMLText(Dest, DestLen, True, nil, xeUTF8, True, True, 1, PAnsiChar(#13#10), 2);

  try
    Stream.WriteBuffer(Pointer(Dest)^, l);
  finally
    FreeMem(Dest);
  end;
end;

procedure TTXXMLNodeElement.SetXMLText(const Text: AnsiString; XMLEntities: TTXXMLEntities = nil; Encoding: TTXXMLEncoding = xeUTF8);
begin
  InternalSetXMLText(PAnsiChar(Text), XMLEntities, Encoding);
end;

function TTXXMLNodeElement.GetXMLText(IncludeTopNode: Boolean = True; XMLEntities: TTXXMLEntities = nil; Encoding: TTXXMLEncoding = xeUTF8; WriteVersion: Boolean = True; UseTabs: Boolean = True; Spaces: Integer = 1; const LineFeed: AnsiString = #13#10): AnsiString;
var
  Dest:     PAnsiChar;
  DestLen:  Integer;
begin
  Dest := AllocMem(102400);
  DestLen := 102400;

  InternalGetXMLText(Dest, DestLen, IncludeTopNode, XMLEntities, Encoding, WriteVersion, UseTabs, Spaces, PAnsiChar(LineFeed), Length(LineFeed));

  result := Dest;
  FreeMem(Dest);
end;

function TTXXMLNodeElement.IsSubNode(FromNode: TTXXMLNodeElement): Boolean;
var
  Node:   TTXXMLNode;
begin
  result := False;

  if Self <> FromNode then
    if FDocument = FromNode.FDocument then
    begin
      Node := FOwner;
      while Node <> nil do
      begin
        if Node = FromNode then
        begin
          result := True;
          Break;
        end;
        Node := Node.FParent;
      end;
    end;
end;

procedure TTXXMLNodeElement.Clear;
var
  i, c:   Integer;
begin
  if FChildNodes <> nil then
  begin
    c := FChildNodes.Count - 1;
    for i := 0 to c do
      case TTXXMLNode(FChildNodes.Items[i]).FNodeType of
      dtElement: TTXXMLNodeElement(FChildNodes.Items[i]).Free;
      dtText, dtCDATA: TTXXMLNodeText(FChildNodes.Items[i]).Free;
      dtComment: TTXXMLNodeComment(FChildNodes.Items[i]).Free;
      else
        TTXXMLNode(FChildNodes.Items[i]).Free;
      end;

    FreeAndNil(FChildNodes);
  end;
end;

function TTXXMLNodeElement.AddElement(const NodeName: AnsiString): TTXXMLNodeElement;
begin
  result := InsertElement(Count, NodeName);
end;

function TTXXMLNodeElement.AddText(const Text: AnsiString; IsCDATA: Boolean = False): TTXXMLNodeText;
begin
  result := InsertText(Count, Text, IsCDATA);
end;

function TTXXMLNodeElement.AddComment(const Comment: AnsiString): TTXXMLNodeComment;
begin
  result := InsertComment(Count, Comment);
end;

function TTXXMLNodeElement.InsertElement(Index: Integer; const NodeName: AnsiString): TTXXMLNodeElement;
begin
  if Index >= 0 then
    if Index <= Count then
    begin
      result := TTXXMLNodeElement.Create(Self, FDocument);

      try
        result.NodeName := NodeName;
      except
        result.Free;
        raise;
      end;

      if FChildNodes = nil then
        FChildNodes := TList.Create;

      FChildNodes.Add(Pointer(result));

      Exit;
    end;

  raise ETXXMLError.CreateFmt('Index is out of bounds (Index = %d; Count = %d).', [ Index, Count ]);
end;

function TTXXMLNodeElement.InsertText(Index: Integer; const Text: AnsiString; IsCDATA: Boolean = False): TTXXMLNodeText;
begin
  if Index >= 0 then
    if Index <= Count then
    begin
      result := TTXXMLNodeText.Create(Self, FDocument);
      if IsCDATA then
        result.FNodeType := dtCDATA;

      try
        result.Text := Text;
      except
        result.Free;
        raise;
      end;

      if FChildNodes = nil then
        FChildNodes := TList.Create;

      FChildNodes.Add(Pointer(result));

      Exit;
    end;

  raise ETXXMLError.CreateFmt('Index is out of bounds (Index = %d; Count = %d).', [ Index, Count ]);
end;

function TTXXMLNodeElement.InsertComment(Index: Integer; const Comment: AnsiString): TTXXMLNodeComment;
begin
  if Index >= 0 then
    if Index <= Count then
    begin
      result := TTXXMLNodeComment.Create(Self, FDocument);

      try
        result.Comment := Comment;
      except
        result.Free;
        raise;
      end;

      if FChildNodes = nil then
        FChildNodes := TList.Create;

      FChildNodes.Add(Pointer(result));

      Exit;
    end;

  raise ETXXMLError.CreateFmt('Index is out of bounds (Index = %d; Count = %d).', [ Index, Count ]);
end;

procedure TTXXMLNodeElement.Delete(Index: Integer);
begin
  if Index >= 0 then
    if Index < Count then
    begin
      case TTXXMLNode(FChildNodes.Items[Index]).FNodeType of
      dtElement: TTXXMLNodeElement(FChildNodes.Items[Index]).Free;
      dtText, dtCDATA: TTXXMLNodeText(FChildNodes.Items[Index]).Free;
      dtComment: TTXXMLNodeComment(FChildNodes.Items[Index]).Free;
      else
        TTXXMLNode(FChildNodes.Items[Index]).Free;
      end;

      FChildNodes.Delete(Index);

      if FChildNodes.Count = 0 then
        FreeAndNil(FChildNodes);

      Exit;
    end;

  raise ETXXMLError.CreateFmt('Index is out of bounds (Index = %d; Count = %d).', [ Index, Count ]);
end;

procedure TTXXMLNodeElement.Exchange(Index1, Index2: Integer);
begin
  if Index1 >= 0 then
    if Index1 < Count then
    begin
      if Index2 >= 0 then
        if Index2 < Count then
        begin
          FChildNodes.Exchange(Index1, Index2);

          Exit;
        end;

      raise ETXXMLError.CreateFmt('Index is out of bounds (Index2 = %d; Count = %d).', [ Index2, Count ]);
    end;

  raise ETXXMLError.CreateFmt('Index is out of bounds (Index1 = %d; Count = %d).', [ Index1, Count ]);
end;

procedure TTXXMLNodeElement.Move(CurIndex, NewIndex: Integer);
begin
  if CurIndex >= 0 then
    if CurIndex < Count then
    begin
      if NewIndex >= 0 then
        if NewIndex < Count then
        begin
          FChildNodes.Move(CurIndex, NewIndex);

          Exit;
        end;

      raise ETXXMLError.CreateFmt('Index is out of bounds (NewIndex = %d; Count = %d).', [ NewIndex, Count ]);
    end;

  raise ETXXMLError.CreateFmt('Index is out of bounds (CurIndex = %d; Count = %d).', [ CurIndex, Count ]);
end;

function TTXXMLNodeElement.IndexOfElement(const Name: AnsiString; StartIndex: Integer = 0; CaseSensitive: Boolean = True; Umlaut: Boolean = False): Integer;
var
  i, c:   Integer;
  LName:  AnsiString;
begin
  result := -1;

  if FChildNodes <> nil then
  begin
    if StartIndex < 0 then
      StartIndex := 0;

    if not CaseSensitive then
      LName := LowerCase(Name);

    c := FChildNodes.Count - 1;
    for i := StartIndex to c do
      if TTXXMLNode(FChildNodes.Items[Index]).FNodeType = dtElement then
        if CaseSensitive then
        begin
          if Name = TTXXMLNodeElement(FChildNodes.Items[Index]).FNodeName then
          begin
            result := i;
            Break;
          end;
        end
        else if LName = LowerCase(TTXXMLNodeElement(FChildNodes.Items[Index]).FNodeName) then
        begin
          result := i;
          Break;
        end;
  end;
end;

procedure TTXXMLNodeElement.ClearAttributes;
var
  i, c: Integer;
begin
  if FAttributes <> nil then
  begin
    c := FAttributes.Count - 1;
    for i := 0 to c do
      Dispose(PAnsiString(FAttributes.Objects[i]));

    FreeAndNil(FAttributes);
  end;
end;

function TTXXMLNodeElement.AddAttribute(const Name, Value: AnsiString): Integer;
begin
  result := InsertAttribute(AttributeCount, Name, Value);
end;

function TTXXMLNodeElement.InsertAttribute(Index: Integer; const Name, Value: AnsiString): Integer;
var
  Str:  PAnsiString;
begin
  if Index >= 0 then
    if Index <= AttributeCount then
      if IsValidName(Name) then
      begin
        if FAttributes = nil then
        begin
          FAttributes := TTXStringList.Create;
          FAttributes.SearchMethod := XML_ATTRIBUTES_SEARCHMETHOD;
          FAttributes.Duplicates := False;
          FAttributes.Umlaut := True;

          if FDocument <> nil then
            FAttributes.CaseSensitive := FDocument.FAttributesCaseSensitive;
        end;

        New(Str);
        Str^ := Value;

        try
          FAttributes.InsertObject(Index, Name, TObject(Str));
        except
          Dispose(Str);
          raise;
        end;

        result := Index;

        Exit;
      end
      else
        raise ETXXMLError.Create('Invalid attributename.');

  raise ETXXMLError.CreateFmt('Index is out of bounds (Index = %d; Count = %d).', [ Index, AttributeCount ]);
end;

procedure TTXXMLNodeElement.DeleteAttribute(Index: Integer);
begin
  if Index >= 0 then
    if Index < AttributeCount then
    begin
      Dispose(PAnsiString(FAttributes.Objects[Index]));
      FAttributes.Delete(Index);

      Exit;
    end;

  raise ETXXMLError.CreateFmt('Index is out of bounds (Index = %d; Count = %d)', [ Index, AttributeCount ]);
end;

procedure TTXXMLNodeElement.ExchangeAttribute(Index1, Index2: Integer);
begin
  if Index1 >= 0 then
    if Index1 < AttributeCount then
    begin
      if Index2 >= 0 then
        if Index2 < AttributeCount then
        begin
          FAttributes.Exchange(Index1, Index2);

          Exit;
        end;

      raise ETXXMLError.CreateFmt('Index is out of bounds (Index2 = %d; Count = %d)', [ Index2, AttributeCount ]);
    end;

  raise ETXXMLError.CreateFmt('Index is out of bounds (Index1 = %d; Count = %d)', [ Index1, AttributeCount ]);
end;

procedure TTXXMLNodeElement.MoveAttribute(Index1, Index2: Integer);
begin
  if Index1 >= 0 then
    if Index1 < AttributeCount then
    begin
      if Index2 >= 0 then
        if Index2 < AttributeCount then
        begin
          FAttributes.Move(Index1, Index2);

          Exit;
        end;

      raise ETXXMLError.CreateFmt('Index is out of bounds (NewIndex = %d; Count = %d)', [ Index1, AttributeCount ]);
    end;

  raise ETXXMLError.CreateFmt('Index is out of bounds (CurIndex = %d; Count = %d)', [ Index2, AttributeCount ]);
end;

function TTXXMLNodeElement.IndexOfAttribute(const Name: AnsiString): Integer;
begin
  if FAttributes <> nil then
    result := FAttributes.Find(Name)
  else
    result := -1;
end;

procedure TTXXMLNodeElement.SetChildNode(Index: Integer; Value: TTXXMLNode);
begin
  if Index >= 0 then
    if Index < Count then
    begin
      TTXXMLNode(FChildNodes.Items[Index]).Assign(Value);

      Exit;
    end;

  raise ETXXMLError.CreateFmt('Index is out of bounds (Index = %d; Count = %d)', [ Index, Count ]);
end;

function TTXXMLNodeElement.GetChildNode(Index: Integer): TTXXMLNode;
begin
  if Index >= 0 then
    if Index < Count then
    begin
      result := TTXXMLNode(FChildNodes.Items[Index]);

      Exit;
    end;

  raise ETXXMLError.CreateFmt('Index is out of bounds (Index = %d; Count = %d)', [ Index, Count ]);
end;

procedure TTXXMLNodeElement.SetElement(Index: Integer; Value: TTXXMLNodeElement);
begin
  SetChildNode(Index, Value);
end;

function TTXXMLNodeElement.GetElement(Index: Integer): TTXXMLNodeElement;
begin
  if Index >= 0 then
    if Index < Count then
    begin
      result := TTXXMLNodeElement(FChildNodes.Items[Index]);

      if result.FNodeType <> dtElement then
        raise ETXXMLError.Create('Node is not a elementnode');

      Exit;
    end;

  raise ETXXMLError.CreateFmt('Index is out of bounds (Index = %d; Count = %d)', [ Index, Count ]);
end;

procedure TTXXMLNodeElement.SetTextNode(Index: Integer; Value: TTXXMLNodeText);
begin
  SetChildNode(Index, Value);
end;

function TTXXMLNodeElement.GetTextNode(Index: Integer): TTXXMLNodeText;
begin
  if Index >= 0 then
    if Index < Count then
    begin
      result := TTXXMLNodeText(FChildNodes.Items[Index]);

      if (result.FNodeType <> dtText) and (result.FNodeType <> dtCDATA) then
        raise ETXXMLError.Create('Node is not a textnode');

      Exit;
    end;

  raise ETXXMLError.CreateFmt('Index is out of bounds (Index = %d; Count = %d)', [ Index, Count ]);
end;

procedure TTXXMLNodeElement.SetComment(Index: Integer; Value: TTXXMLNodeComment);
begin
  SetChildNode(Index, Value);
end;

function TTXXMLNodeElement.GetComment(Index: Integer): TTXXMLNodeComment;
begin
  if Index >= 0 then
    if Index < Count then
    begin
      result := TTXXMLNodeComment(FChildNodes.Items[Index]);

      if result.FNodeType <> dtComment then
        raise ETXXMLError.Create('Node is not a commentnode');

      Exit;
    end;

  raise ETXXMLError.CreateFmt('Index is out of bounds (Index = %d; Count = %d)', [ Index, Count ]);
end;

function TTXXMLNodeElement.GetNodeType(Index: Integer): TTXXMLNodeType;
begin
  if Index >= 0 then
    if Index <= Count then
    begin
      result := TTXXMLNode(FChildNodes.Items[Index]).FNodeType;

      Exit;
    end;

  raise ETXXMLError.CreateFmt('Index is out of bounds (Index = %d; Count = %d)', [ Index, Count ]);
end;

function TTXXMLNodeElement.GetCount: Integer;
begin
  if FChildNodes <> nil then
    result := FChildNodes.Count
  else
    result := 0;
end;

procedure TTXXMLNodeElement.SetAttributeName(Index: Integer; const Value: AnsiString);
begin
  if Index >= 0 then
    if Index <= AttributeCount then
      if IsValidName(Value) then
      begin
        if FAttributes.Strings[Index] = Value then
          Exit;

        if FAttributes.Find(Value) >= 0 then
          raise ETXXMLError.Create('Attribute already exists');

        FAttributes.Strings[Index] := Value;

        Exit;
      end
      else
        raise ETXXMLError.Create('Invalid attributename');

  raise ETXXMLError.CreateFmt('Index is out of bounds (Index = %d; Count = %d)', [ Index, AttributeCount ]);
end;

function TTXXMLNodeElement.GetAttributeName(Index: Integer): AnsiString;
begin
  if Index >= 0 then
    if Index <= AttributeCount then
    begin
      result := FAttributes.Strings[Index];

      Exit;
    end;

  raise ETXXMLError.CreateFmt('Index is out of bounds (Index = %d; Count = %d)', [ Index, AttributeCount ]);
end;

procedure TTXXMLNodeElement.SetAttributeValue(Index: Integer; const Value: AnsiString);
begin
  if Index >= 0 then
    if Index <= AttributeCount then
    begin
      PAnsiString(FAttributes.Objects[Index])^ := Value;

      Exit;
    end;

  raise ETXXMLError.CreateFmt('Index is out of bounds (Index = %d; Count = %d)', [ Index, AttributeCount ]);
end;

function TTXXMLNodeElement.GetAttributeValue(Index: Integer): AnsiString;
begin
  if Index >= 0 then
    if Index <= AttributeCount then
    begin
      result := PAnsiString(FAttributes.Objects[Index])^;

      Exit;
    end;

  raise ETXXMLError.CreateFmt('Index is out of bounds (Index = %d; Count = %d)', [ Index, AttributeCount ]);
end;

function TTXXMLNodeElement.GetAttributeCount: Integer;
begin
  if FAttributes <> nil then
    result := FAttributes.Count
  else
    result := 0;
end;

procedure TTXXMLNodeElement.SetAttribute(const Name, Value: AnsiString);
var
  i:  Integer;
begin
  if FAttributes <> nil then
  begin
    i := FAttributes.Find(Name);

    if i >= 0 then
      PAnsiString(FAttributes.Objects[i])^ := Value
    else
      AddAttribute(Name, Value)
  end
  else
    AddAttribute(Name, Value)
end;

function TTXXMLNodeElement.GetAttribute(const Name: AnsiString): AnsiString;
var
  i:  Integer;
begin
  if FAttributes <> nil then
  begin
    i := FAttributes.Find(Name);

    if i >= 0 then
      result := PAnsiString(FAttributes.Objects[i])^
    else
      result := '';
  end
  else
    result := '';
end;

procedure TTXXMLNodeElement.SetAttributeAsInteger(const Name: AnsiString; Value: Integer);
begin
  SetAttribute(Name, IntToStr(Value));
end;

function TTXXMLNodeElement.GetAttributeAsInteger(const Name: AnsiString): Integer;
begin
  result := TXStrToInt(GetAttribute(Name));
end;

procedure TTXXMLNodeElement.SetAttributeAsBoolean(const Name: AnsiString; Value: Boolean);
begin
  SetAttribute(Name, IntToStr(Integer(Value)));
end;

function TTXXMLNodeElement.GetAttributeAsBoolean(const Name: AnsiString): Boolean;
begin
  result := Boolean(TXStrToInt(GetAttribute(Name)));
end;

procedure TTXXMLNodeElement.SetNodeName(const NodeName: AnsiString);
begin
  if IsValidName(NodeName) then
    FNodeName := NodeName
  else
    raise ETXXMLError.Create('Invalid nodename');
end;

procedure TTXXMLNodeElement.SetText(const Text: AnsiString);
begin
  if FDocument <> nil then
    InternalSetXMLText(PAnsiChar(Text), FDocument.XMLEntities, FDocument.Encoding)
  else
    InternalSetXMLText(PAnsiChar(Text), nil, xeUTF8);
end;

function TTXXMLNodeElement.GetText: AnsiString;
var
  Dest:     PAnsiChar;
  DestLen:  Integer;
begin
  Dest := AllocMem(102400);
  DestLen := 102400;

  if FDocument <> nil then
    InternalGetXMLText(Dest, DestLen, False, FDocument.XMLEntities, FDocument.Encoding, FDocument.FWriteVersion, FDocument.FUseTabs, FDocument.Spaces, PAnsiChar(FDocument.LineFeed), Length(FDocument.LineFeed))
  else
    InternalGetXMLText(Dest, DestLen, False, nil, xeUTF8, True, True, 1, PAnsiChar(#13#10), 2);

  result := Dest;
  FreeMem(Dest);
end;

function TTXXMLNodeElement._GetXMLText: AnsiString;
var
  Dest:     PAnsiChar;
  DestLen:  Integer;
begin
  Dest := AllocMem(102400);
  DestLen := 102400;

  if FDocument <> nil then
    InternalGetXMLText(Dest, DestLen, True, FDocument.XMLEntities, FDocument.Encoding, FDocument.FWriteVersion, FDocument.FUseTabs, FDocument.Spaces, PAnsiChar(FDocument.LineFeed), Length(FDocument.LineFeed))
  else
    InternalGetXMLText(Dest, DestLen, True, nil, xeUTF8, True, True, 1, PAnsiChar(#13#10), 2);

  result := Dest;
  FreeMem(Dest);
end;

const
  XMLNameFirstChar: AnsiString = 'abcdefghijklmnopqrstuvwxyzäöüABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ_';
  XMLNameValidChars: AnsiString = 'abcdefghijklmnopqrstuvwxyzäöüABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ0123456789_-:.';

procedure TTXXMLNodeElement.InternalSetXMLText(Text: PAnsiChar; XMLEntities: TTXXMLEntities; Encoding: TTXXMLEncoding);
var
  src:                  PAnsiChar;
  start, ende, st:      PAnsiChar;
  cur:                  PAnsiChar;
  chr1, chr2:           AnsiChar;
  NodeType:             Integer;
  Quote:                Integer;
  i, c:                 Integer;
  tmp1, tmp2, tmp3:     AnsiChar;
  ptmp2, ptmp3:         PAnsiChar;
  NodeName:             PAnsiChar;
  AttributeName:        PAnsiChar;
  AttributeValue:       PAnsiChar;
  Str1, Str2:           PAnsiChar;
  StrLen1, StrLen2:     Integer;
  AttrList:             TTXStringList;
  AttrString:           PAnsiString;

  function Parse(XMLElement: TTXXMLNodeElement; Encoding: TTXXMLEncoding): TTXXMLNodeElement;
  var
    ParentElement:  TTXXMLNodeElement;
    ChildElement:   TTXXMLNodeElement;

    function Scan(const Str: PAnsiChar; Chr: AnsiChar; var StrEnd: PAnsiChar): PAnsiChar;
    var
      e:  PAnsiChar;
    begin
      result := nil;
      {$ifdef FPC}
      {$ASMMODE intel}
      {$endif}
      asm
      {$ifndef FPC}
        push esi
        {$endif}

        mov esi, [Str]
        mov al, Chr
        dec esi
@ScanSearch:
        inc esi
        mov ah, byte ptr [esi]
        cmp ah, 0
        je @ScanZeroFound
        cmp ah, al
        jne @ScanSearch
        mov [result], esi
@ScanZeroFound:
        mov [e], esi
        {$ifndef FPC}
        pop esi;
      {$endif}
      end;

      StrEnd := e;
    end;
  begin
    result := nil;

    cur := src;

    repeat
      // Tag suchen
      start := Scan(src, '<', ende);
      if start = nil then
      begin
        if _XMLTextToText(cur, Str1, StrLen1, XMLEntities, Encoding) > 0 then
          XMLElement.AddText(Str1);

        src := ende;

        Break;
      end;

      // Tag parsen

      src := start;

      // Leerzeichen, Tabulatoren und LineFeed ignorieren
      inc(src);
      while (src^ in [' ', #9, #13, #10]) do
        inc(src);

      // Ende erreicht?
      if src^ = #0 then
      begin
        if _XMLTextToText(cur, Str1, StrLen1, XMLEntities, Encoding) > 0 then
          XMLElement.AddText(Str1);

        Break;
      end;

      // NodeName bzw Typ ermitteln
      NodeName := nil;
      c := 0;

      NodeType := 0;
      while not (src^ in [' ', '>', #9, #13, #10, #0]) do
      begin
        case src^ of
        '?':
          if NodeType = 0 then
          begin
            NodeName := src + 1;
            NodeType := 3;
          end
          else
            Break;
        '!':
          if NodeType = 0 then
          begin
            NodeName := src + 1;
            NodeType := 4;
          end
          else
            Break;
        '/':
          if NodeType = 0 then
          begin
            NodeName := src + 1;
            NodeType := 2;
          end
          else
            Break;
        '<':
        begin
          NodeType := 0;
          c := 0;
          Break;
        end;
        else
          if NodeType = 0 then
          begin
            NodeName := src;
            NodeType := 1;
          end;

          inc(c);

          case NodeType of
          3:
            if c = 3 then
              Break;
          4:
            if c = 2 then
            begin
              if src^ = '-' then
                if (src - 1)^ = '-' then
                begin
                  NodeType := 5;
                  Break;
                end;
            end
            else if c = 7 then
            begin
              inc(src);
              Break;
            end;
          end;
        end;

        inc(src);
      end;

      // Gültiger Tag?
      if (NodeType <> 0) and (c > 0) then
      begin
        // CDATA-Tag?
        if NodeType = 4 then
        begin
          tmp1 := src^;
          src^ := #0;

          if UpperCase(NodeName) <> '[CDATA[' then
            NodeType := -1;

          src^ := tmp1;
        end;

        // Je nach Typ vorgehen
        case NodeType of
        1, 3: // Element und Processing Instruction
        begin
          if NodeType = 3 then
          begin
            tmp1 := src^;
            src^ := #0;

            if LowerCase(NodeName) <> 'xml' then
              NodeType := -3
            else
              Encoding := xeNone;

            src^ := tmp1;
          end;

          // Attribute parsen
          if NodeType > 0 then
          begin
            if NodeType = 1 then
            begin
              tmp1 := src^;
              src^ := #0;

              if Encoding = xeUTF8 then
              begin
                _DecodeUTF8(NodeName, Str2, StrLen2);

                NodeName := Str2;
              end;

              try
                ChildElement := TTXXMLNodeElement.Create(XMLElement, XMLElement.Document);
                ChildElement.NodeName := NodeName;
              except
                FreeAndNil(ChildElement);
              end;

              src^ := tmp1;
            end
            else
              ChildElement := nil;

            repeat
              if ChildElement = nil then
              begin
                NodeType := -1;

                break;
              end;

              // Leerzeichen, Tabulatoren und LineFeed ignorieren
              while (src^ in [' ', #9, #13, #10]) do
                inc(src);

              // Attribute-Namen ermitteln
              AttributeName := src;
              while not (src^ in [' ', '/', '<', '>', '=', #9, #13, #10, #0]) do
                inc(src);

              if src^ = '<' then
              begin
                if ChildElement <> nil then
                  ChildElement.Free;

                Break;
              end;

              if (AttributeName <> src) and (AttributeName <> nil) then
                ptmp2 := src
              else
                ptmp2 := nil;

              // Leerzeichen, Tabulatoren und LineFeed ignorieren
              while (src^ in [' ', #9, #13, #10]) do
                inc(src);

              // Attribute-Inhalt holen
              AttributeValue := nil;
              ptmp3 := nil;
              if src^ = '=' then
              begin
                inc(src);

                // Leerzeichen, Tabulatoren und LineFeed ignorieren
                while (src^ in [' ', #9, #13, #10]) do
                  inc(src);

                // Eigentlichen Attribute-Inhalt holen
                Quote := 0;
                while src^ <> #0 do
                begin
                  case src^ of
                  '"':
                    case Quote of
                    0:
                    begin
                      Quote := 1;
                      inc(src);
                      AttributeValue := src;
                      Continue;
                    end;
                    1:
                    begin
                      ptmp3 := src;
                      inc(src);
                      Break;
                    end;
                    end;
                  '''':
                    case Quote of
                    0:
                    begin
                      Quote := 2;
                      inc(src);
                      AttributeValue := src;
                      Continue;
                    end;
                    2:
                    begin
                      ptmp3 := src;
                      inc(src);
                      Break;
                    end;
                    end;
                  ' ', #9, #13, #10, '/', '<', '>':
                    if Quote <= 0 then
                    begin
                      ptmp3 := src;
                      Break;
                    end;
                  else
                    if Quote = 0 then
                    begin
                      AttributeValue := src;
                      Quote := -1;
                    end;
                  end;

                  inc(src);
                end;

                if src^ = '<' then
                begin
                  if ChildElement <> nil then
                    ChildElement.Free;

                  Break;
                end;
              end;

              // Attribute-Name vorhanden?
              if ptmp2 <> nil then
              begin
                tmp2 := ptmp2^;
                ptmp2^ := #0;

                if Encoding = xeUTF8 then
                begin
                  _DecodeUTF8(AttributeName, Str2, StrLen2);

                  AttributeName := Str2;
                end;

                if IsValidName(AttributeName) then
                begin
                  // Attribute-Inhalt auswerten und in Str1 schreiben
                  if ptmp3 <> nil then
                  begin
                    tmp3 := ptmp3^;
                    ptmp3^ := #0;

                    _XMLTextToText(AttributeValue, Str1, StrLen1, XMLEntities, Encoding, False);
                    ptmp3^ := tmp3;
                  end
                  else
                    Str1^ := #0;

                  if NodeType = 1 then
                  begin
                    if ChildElement.FAttributes = nil then
                    begin
                      AttrList := TTXStringList.Create;
                      AttrList.SearchMethod := XML_ATTRIBUTES_SEARCHMETHOD;
                      AttrList.Duplicates := False;
                      AttrList.Umlaut := True;

                      if FDocument <> nil then
                        AttrList.CaseSensitive := FDocument.FAttributesCaseSensitive;

                      ChildElement.FAttributes := AttrList;
                    end
                    else
                      AttrList := ChildElement.FAttributes;

                    try
                      i := AttrList.Add(AttributeName);
                      New(AttrString);
                      AttrString^ := Str1;
                      AttrList.Objects[i] := TObject(AttrString);
                    except
                      if AttrList.Count = 0 then
                        FreeAndNil(ChildElement.FAttributes);
                    end;
                  end
                  else if LowerCase(AttributeName) = 'encoding' then
                  begin
                    if LowerCase(Trim(AttributeValue)) = 'utf-8' then
                      Encoding := xeUTF8
                    else
                      Encoding := xeNone;
                  end;
                end;

                ptmp2^ := tmp2;
              end;

              // Leerzeichen, Tabulatoren und LineFeed ignorieren
              while (src^ in [' ', #9, #13, #10]) do
                inc(src);

              case src^ of
              #0:
              begin
                if ChildElement <> nil then
                  ChildElement.Free;

                if _XMLTextToText(cur, Str1, StrLen1, XMLEntities, Encoding) > 0 then
                  XMLElement.AddText(Str1);

                cur := src;

                Break;
              end;
              '<':
              begin
                if ChildElement <> nil then
                  ChildElement.Free;

                Break;
              end;
              end;

              if NodeType = 1 then
                case src^ of
                '/':
                begin
                  inc(src);
                  while (src^ in [' ', #9, #13, #10]) do
                    inc(src);

                  case src^ of
                  '>':
                  begin
                    inc(src);

                    // Textnode hinzufügen
                    tmp1 := start^;
                    start^ := #0;

                    if _XMLTextToText(cur, Str1, StrLen1, XMLEntities, Encoding) > 0 then
                      XMLElement.AddText(Str1);

                    start^ := tmp1;

                    cur := src;

                    // Element hinzufügen
                    if XMLElement.FChildNodes = nil then
                      XMLElement.FChildNodes := TList.Create;

                    XMLElement.FChildNodes.Add(Pointer(ChildElement));

                    Break;
                  end;
                  '<':
                  begin
                    if ChildElement <> nil then
                      ChildElement.Free;

                    Break;
                  end;
                  end;
                end;
                '>':
                begin
                  inc(src);

                  // Textnode hinzufügen
                  tmp1 := start^;
                  start^ := #0;

                  if _XMLTextToText(cur, Str1, StrLen1, XMLEntities, Encoding) > 0 then
                    XMLElement.AddText(Str1);

                  start^ := tmp1;

                  cur := src;

                  // Element hinzufügen
                  if XMLElement.FChildNodes = nil then
                    XMLElement.FChildNodes := TList.Create;

                  XMLElement.FChildNodes.Add(Pointer(ChildElement));

                  ParentElement := Parse(ChildElement, Encoding);
                  if ParentElement <> XMLElement then
                  begin
                    result := ParentElement;
                    Exit;
                  end;

                  Break;
                end;
                end
              else
                case src^ of
                '?':
                begin
                  inc(src);
                  while (src^ in [' ', #9, #13, #10]) do
                    inc(src);

                  case src^ of
                  '>':
                  begin
                    inc(src);

                    // Textnode hinzufügen
                    tmp1 := start^;
                    start^ := #0;

                    if _XMLTextToText(cur, Str1, StrLen1, XMLEntities, Encoding) > 0 then
                      XMLElement.AddText(Str1);

                    start^ := tmp1;

                    cur := src;

                    Break;
                  end;
                  '<':
                  begin
                    if ChildElement <> nil then
                      ChildElement.Free;

                    Break;
                  end;
                  end;
                end;
                '>':
                begin
                  inc(src);

                  // Textnode hinzufügen
                  tmp1 := start^;
                  start^ := #0;

                  if _XMLTextToText(cur, Str1, StrLen1, XMLEntities, Encoding) > 0 then
                    XMLElement.AddText(Str1);

                  start^ := tmp1;

                  cur := src;

                  Break;
                end;
                end;
            until eternity;
          end;
        end;
        2: // Elementende
        begin
          // Leerzeichen, Tabulatoren und LineFeed ignorieren
          while (src^ in [' ', #9, #13, #10]) do
            inc(src);

          if src^ = '>' then
          begin
            tmp2 := start^;
            start^ := #0;

            if _XMLTextToText(cur, Str1, StrLen1, XMLEntities, Encoding) > 0 then
              XMLElement.AddText(Str1);

            start^ := tmp2;

            tmp1 := src^;
            src^ := #0;

            // Existiert Elternelement?
            result := XMLElement;
            repeat
              if StrComp(NodeName, PAnsiChar(result.NodeName)) = 0 then
              begin
                src^ := tmp1;
                result := result.Parent;
                inc(src);
                cur := src;
                Exit;
              end;

              result := result.Parent;
            until result = nil;

            src^ := tmp1;

            inc(src);
            cur := src;
          end;
        end;
        4: // CDATA
        begin
          st := src;

          repeat
            src := Scan(src, ']', ende);
            if src = nil then
            begin
              tmp2 := start^;
              start^ := #0;

              if _XMLTextToText(cur, Str1, StrLen1, XMLEntities, Encoding) > 0 then
                XMLElement.AddText(Str1);

              start^ := tmp2;

              src := ende;
              cur := ende;

              Break;
            end;

            inc(src);
            chr1 := src^;
            if chr1 <> #0 then
            begin
              inc(src);
              chr2 := src^;
            end
            else
              chr2 := #0;

            if (chr1 = #0) or (chr2 = #0) then
            begin
              tmp2 := start^;
              start^ := #0;

              if _XMLTextToText(cur, Str1, StrLen1, XMLEntities, Encoding) > 0 then
                XMLElement.AddText(Str1);

              start^ := tmp2;

              cur := src;

              Break;
            end;

            if (chr1 = ']') and (chr2 = '>') then
            begin
              tmp2 := start^;
              start^ := #0;

              if _XMLTextToText(cur, Str1, StrLen1, XMLEntities, Encoding) > 0 then
                XMLElement.AddText(Str1);

              start^ := tmp2;

              ende := src;
              dec(ende, 2);

              tmp2 := ende^;
              ende^ := #0;

              if Encoding = xeUTF8 then
              begin
                _DecodeUTF8(st, Str2, StrLen2);

                st := Str2;
              end;

              if XMLElement.FChildNodes <> nil then
              begin
                if XMLElement.FChildNodes.Count > 0 then
                begin
                  if TTXXMLNode(XMLElement.FChildNodes.Items[XMLElement.FChildNodes.Count - 1]).FNodeType = dtCDATA then
                  begin
                    TTXXMLNodeText(XMLElement.FChildNodes.Items[XMLElement.FChildNodes.Count - 1]).FText :=
                    TTXXMLNodeText(XMLElement.FChildNodes.Items[XMLElement.FChildNodes.Count - 1]).FText + st;
                  end
                  else
                    XMLElement.AddText(st, True);
                end
                else
                  XMLElement.AddText(st, True);
              end
              else
                XMLElement.AddText(st, True);

              ende^ := tmp2;

              inc(src);
              cur := src;

              Break;
            end
            else
              dec(src, 1);
          until eternity;
        end;
        5: // Kommentare
        begin
          inc(src);
          st := src;

          repeat
            src := Scan(src, '-', ende);
            if src = nil then
            begin
              tmp2 := start^;
              start^ := #0;

              if _XMLTextToText(cur, Str1, StrLen1, XMLEntities, Encoding) > 0 then
                XMLElement.AddText(Str1);

              start^ := tmp2;

              src := ende;
              cur := ende;

              Break;
            end;

            inc(src);
            chr1 := src^;
            if chr1 <> #0 then
            begin
              inc(src);
              chr2 := src^;
            end
            else
              chr2 := #0;

            if (chr1 = #0) or (chr2 = #0) then
            begin
              tmp2 := start^;
              start^ := #0;

              if _XMLTextToText(cur, Str1, StrLen1, XMLEntities, Encoding) > 0 then
                XMLElement.AddText(Str1);

              start^ := tmp2;

              cur := src;

              Break;
            end;

            if (chr1 = '-') and (chr2 = '>') then
            begin
              tmp2 := start^;
              start^ := #0;

              if _XMLTextToText(cur, Str1, StrLen1, XMLEntities, Encoding) > 0 then
                XMLElement.AddText(Str1);

              start^ := tmp2;

              ende := src;
              dec(ende, 2);

              tmp2 := ende^;
              ende^ := #0;

              if Encoding = xeUTF8 then
              begin
                _DecodeUTF8(st, Str2, StrLen2);

                st := Str2;
              end;

              XMLElement.AddComment(st);

              ende^ := tmp2;

              inc(src);
              cur := src;

              Break;
            end
            else
              dec(src, 1);
          until eternity;
        end;
        end;
      end;

      // Ggf. nach dem Ende des Tags suchen
      if NodeType < 0 then
      begin
        tmp2 := start^;
        start^ := #0;

        if _XMLTextToText(cur, Str1, StrLen1, XMLEntities, Encoding) > 0 then
          XMLElement.AddText(Str1);

        start^ := tmp2;

        Quote := 0;
        while src^ <> #0 do
        begin
          case src^ of
          '"': if Quote = 0 then Quote := 1 else if Quote = 1 then Quote := 0;
          '''': if Quote = 0 then Quote := 2 else if Quote = 2 then Quote := 0;
          else
            if Quote = 0 then
              if src^ = '>' then
              begin
                inc(src);
                Break;
              end;
          end;

          inc(src);
        end;

        cur := src;
      end;
    until eternity;
  end;
begin
  Clear;

  src := Text;
  if src <> nil then
  begin
    Str1 := AllocMem(1024);
    StrLen1 := 1024;

    Str2 := AllocMem(1024);
    StrLen2 := 1024;

    Parse(Self, Encoding);

    FreeMem(Str1);
    FreeMem(Str2);
  end;
end;

function TTXXMLNodeElement.InternalGetXMLText(var DestStr: PAnsiChar; var DestSize: Integer; IncludeTopNode: Boolean; XMLEntities: TTXXMLEntities; Encoding: TTXXMLEncoding; WriteVersion: Boolean; UseTabs: Boolean; Spaces: Integer; LineFeed: PAnsiChar; LineFeedLen: Integer): Integer;
var
  ChildNode:        TTXXMLNode;

  Dest:             PAnsiChar;
  DestLen:          Integer;

  CDATABegin:       AnsiString;
  PCDATABegin:      PAnsiChar;
  PCDATABeginLen:   Integer;
  CDATAEnd:         AnsiString;
  PCDATAEnd:        PAnsiChar;
  PCDATAEndLen:     Integer;
  CDATATmp:         AnsiString;
  PCDATATmp:        PAnsiChar;
  PCDATATmpLen:     Integer;

  CommentBegin:     AnsiString;
  PCommentBegin:    PAnsiChar;
  PCommentBeginLen: Integer;
  CommentEnd:       AnsiString;
  PCommentEnd:      PAnsiChar;
  PCommentEndLen:   Integer;

  NodeNameStr:      PAnsiChar;
  NodeNameStrLen:   Integer;
  NodeNameStrSize:  Integer;
  PNodeName:        PAnsiChar;

  TmpStr:           AnsiString;

  p, l, tl:         Integer;

  procedure GrowDest(Size: Integer);
  begin
    if DestLen + Size >= DestSize then
    begin
      DestSize := (DestLen + Size) shl 1;
      ReallocMem(DestStr, DestSize);
      Dest := DestStr;
      inc(Dest, DestLen);
    end;
  end;

  procedure WriteEngage(SpaceCount: Integer);
  begin
    GrowDest(SpaceCount);

    if UseTabs then
      FillMemory(Dest, SpaceCount, 9)
    else
      FillMemory(Dest, SpaceCount, 32);

    inc(Dest, SpaceCount);
    inc(DestLen, SpaceCount);
  end;

  procedure WriteStr(PStr: PAnsiChar; StrLen: Integer);
  begin
    if StrLen > 0 then
    begin
      GrowDest(StrLen);
      CopyMemory(Dest, PStr, StrLen);
      inc(Dest, StrLen);
      inc(DestLen, StrLen);
    end;
  end;

  function WriteNodeName(XMLElement: TTXXMLNodeElement; Open: Boolean; Position, Len: Integer): Integer;
  var
    i, c, l:  Integer;
    tmp:      PAnsiChar;
  begin
    if Position < 0 then
      GrowDest(NodeNameStrLen + 3)
    else
      GrowDest(Len + 3);

    Dest^ := '<';
    inc(Dest);
    inc(DestLen);

    if not Open then
    begin
      Dest^ := '/';
      inc(Dest);
      inc(DestLen);
    end;

    if Position >= 0 then
    begin
      result := DestLen;
      tmp := DestStr;
      inc(tmp, Position);
      CopyMemory(Dest, tmp, Len);
      inc(Dest, Len);
      inc(DestLen, Len);
    end
    else
    begin
      CopyMemory(Dest, PNodeName, NodeNameStrLen);
      result := DestLen;
      inc(Dest, NodeNameStrLen);
      inc(DestLen, NodeNameStrLen);
    end;

    if Open then
    begin
      c := XMLElement.AttributeCount - 1;
      for i := 0 to c do
      begin
        GrowDest(1);
        Dest^ := ' ';
        inc(Dest);
        inc(DestLen);

        if Encoding = xeUTF8 then
        begin
          l := _EncodeUTF8(PAnsiChar(XMLElement.FAttributes.FItems[i].FString), DestStr, DestSize, DestLen);
          inc(DestLen, l);
          Dest := DestStr;
          inc(Dest, DestLen);
        end
        else
        begin
          l := Length(XMLElement.FAttributes.FItems[i].FString);
          GrowDest(l);
          CopyMemory(Dest, PAnsiChar(XMLElement.FAttributes.FItems[i].FString), l);
          inc(Dest, l);
          inc(DestLen, l);
        end;

        GrowDest(2);
        Dest^ := '=';
        inc(Dest);
        inc(DestLen);
        Dest^ := '"';
        inc(Dest);
        inc(DestLen);

        l := _TextToXMLText(PAnsiChar(PAnsiString(XMLElement.FAttributes.Objects[i])^), DestStr, DestSize, XMLEntities, Encoding, False, DestLen);
        inc(DestLen, l);
        Dest := DestStr;
        inc(Dest, DestLen);

        GrowDest(1);
        Dest^ := '"';
        inc(Dest);
        inc(DestLen);
      end;

      GrowDest(2);

      if XMLElement.Count = 0 then
      begin
        Dest^ := '/';
        inc(Dest);
        inc(DestLen);
      end;
    end;

    Dest^ := '>';
    inc(Dest);
    inc(DestLen);
  end;

  procedure WriteNode(XMLNode: TTXXMLNodeElement; SpaceCount: Integer);
  var
    ChildNode:      TTXXMLNode;
    i, c, l, p, cp: Integer;
    PTmp:           PAnsiChar;
  begin
    c := XMLNode.Count - 1;
    for i := 0 to c do
    begin
      ChildNode := XMLNode.ChildNodes[i];
      case ChildNode.NodeType of
      dtElement:
      begin
        PNodeName := PAnsiChar(TTXXMLNodeElement(ChildNode).FNodeName);
        if PNodeName = nil then
          Continue;

        case Encoding of
        xeUTF8:
        begin
          NodeNameStrLen := _EncodeUTF8(PNodeName, NodeNameStr, NodeNameStrSize);
          PNodeName := NodeNameStr;
        end;
        xeNone: NodeNameStrLen := Length(TTXXMLNodeElement(ChildNode).FNodeName);
        end;

        if NodeNameStrLen = 0 then
          Continue;

        l := NodeNameStrLen;

        WriteEngage(SpaceCount);

        p := WriteNodeName(TTXXMLNodeElement(ChildNode), True, -1, -1);

        if TTXXMLNodeElement(ChildNode).Count > 0 then
        begin
          if TTXXMLNodeElement(ChildNode).ChildNodes[0].NodeType <> dtText then
            WriteStr(LineFeed, LineFeedLen);

          WriteNode(TTXXMLNodeElement(ChildNode), SpaceCount + Spaces);

          if (TTXXMLNodeElement(ChildNode).ChildNodes[0].NodeType <> dtText) or
             (TTXXMLNodeElement(ChildNode).Count <> 1) then
            WriteEngage(SpaceCount);

          WriteNodeName(TTXXMLNodeElement(ChildNode), False, p, l);

          WriteStr(LineFeed, LineFeedLen);
        end
        else
          WriteStr(LineFeed, LineFeedLen);
      end;
      dtText:
      begin
        l := _TextToXMLText(PAnsiChar(TTXXMLNodeText(ChildNode).FText), DestStr, DestSize, XMLEntities, Encoding, True, DestLen);
        inc(DestLen, l);
        Dest := DestStr;
        inc(Dest, DestLen);
      end;
      dtCDATA:
      begin
        WriteEngage(SpaceCount);
        WriteStr(PCDATABegin, PCDATABeginLen);

        if Pos(']]>', TTXXMLNodeText(ChildNode).FText) > 0 then
        begin
          cp := 1;
          repeat
            p := TXPos(']]>', TTXXMLNodeText(ChildNode).FText, cp);
            if p > 0 then
            begin
              l := p - cp;
              if l > 0 then
              begin
                TmpStr := Copy(TTXXMLNodeText(ChildNode).FText, cp, l);

                PTmp := PAnsiChar(TmpStr);
                case Encoding of
                xeUTF8:
                begin
                  l := _EncodeUTF8(PTmp, DestStr, DestSize, DestLen);
                  inc(DestLen, l);
                  Dest := DestStr;
                  inc(Dest, DestLen);
                end;
                xeNone: WriteStr(PTmp, Length(TmpStr));
                end;

                WriteStr(PCDATAEnd, PCDATAEndLen);
              end;

              WriteStr(PCDATATmp, PCDATATmpLen);

              cp := p + 3;
            end
            else
            begin
              PTmp := PAnsiChar(TTXXMLNodeText(ChildNode).FText);
              dec(cp);
              inc(PTmp, cp);
              case Encoding of
              xeUTF8:
              begin
                l := _EncodeUTF8(PTmp, DestStr, DestSize, DestLen);
                inc(DestLen, l);
                Dest := DestStr;
                inc(Dest, DestLen);
              end;
              xeNone: WriteStr(PTmp, StrLen(PTmp));
              end;

              WriteStr(PCDATAEnd, PCDATAEndLen);
            end;
          until p = 0;
        end
        else
        begin
          PTmp := PAnsiChar(TTXXMLNodeText(ChildNode).FText);
          case Encoding of
          xeUTF8:
          begin
            l := _EncodeUTF8(PTmp, DestStr, DestSize, DestLen);
            inc(DestLen, l);
            Dest := DestStr;
            inc(Dest, DestLen);
          end;
          xeNone: WriteStr(PTmp, Length(TTXXMLNodeText(ChildNode).FText));
          end;

          WriteStr(PCDATAEnd, PCDATAEndLen);
        end;

        if i < c then
        begin
          if XMLNode.ChildNodes[i + 1].NodeType <> dtText then
            WriteStr(LineFeed, LineFeedLen);
        end
        else
          WriteStr(LineFeed, LineFeedLen);
      end;
      dtComment:
      begin
        WriteEngage(SpaceCount);
        WriteStr(PCommentBegin, PCommentBeginLen);

        PTmp := PAnsiChar(TTXXMLNodeComment(ChildNode).FComment);
        case Encoding of
        xeUTF8:
        begin
          l := _EncodeUTF8(PTmp, DestStr, DestSize, DestLen);
          inc(DestLen, l);
          Dest := DestStr;
          inc(Dest, DestLen);
        end;
        xeNone: WriteStr(PTmp, Length(TTXXMLNodeComment(ChildNode).FComment));
        end;

        WriteStr(PCommentEnd, PCommentEndLen);

        if i < c then
        begin
          if XMLNode.ChildNodes[i + 1].NodeType <> dtText then
            WriteStr(LineFeed, LineFeedLen);
        end
        else
          WriteStr(LineFeed, LineFeedLen);
      end;
      end;
    end;
  end;
begin
  Dest := DestStr;
  DestLen := 0;

  CDATABegin := '<![CDATA[';
  PCDATABegin := PAnsiChar(CDATABegin);
  PCDATABeginLen := 9;
  CDATAEnd := ']]>';
  PCDATAEnd := PAnsiChar(CDATAEnd);
  PCDATAEndLen := 3;
  CDATATmp := '<![CDATA[]]]]><![CDATA[>]]>';
  PCDATATmp := PAnsiChar(CDATATmp);
  PCDATATmpLen := 27;

  CommentBegin := '<!--';
  PCommentBegin := PAnsiChar(CommentBegin);
  PCommentBeginLen := 4;
  CommentEnd := '-->';
  PCommentEnd := PAnsiChar(CommentEnd);
  PCommentEndLen := 3;

  NodeNameStr := AllocMem(32);
  NodeNameStrSize := 32;

  if WriteVersion then
  begin
    case Encoding of
    xeNone: WriteStr('<?xml version="1.0"?>', 21);
    xeUTF8: WriteStr('<?xml version="1.0" encoding="UTF-8"?>', 38);
    end;

    WriteStr(LineFeed, LineFeedLen);
  end;

  if Parent = nil then
    IncludeTopNode := False;

  if IncludeTopNode then
  begin
    PNodeName := PAnsiChar(FNodeName);
    if PNodeName <> nil then
    begin
      case Encoding of
      xeUTF8:
      begin
        NodeNameStrLen := _EncodeUTF8(PNodeName, NodeNameStr, NodeNameStrSize);
        PNodeName := NodeNameStr;
      end;
      xeNone: NodeNameStrLen := Length(FNodeName);
      end;

      if NodeNameStrLen > 0 then
      begin
        l := NodeNameStrLen;

        case Count of
        0:
        begin
          WriteNodeName(Self, True, -1, -1);
          WriteStr(LineFeed, LineFeedLen);
        end;
        1:
        begin
          ChildNode := ChildNodes[0];

          case ChildNode.NodeType of
          dtText:
          begin
            p := WriteNodeName(Self, True, -1, -1);

            tl := _TextToXMLText(PAnsiChar(TTXXMLNodeText(ChildNode).FText), DestStr, DestSize, XMLEntities, Encoding, True, DestLen);
            inc(DestLen, tl);
            Dest := DestStr;
            inc(Dest, DestLen);

            WriteNodeName(Self, False, p, l);
            WriteStr(LineFeed, LineFeedLen);
          end;
          else
            p := WriteNodeName(Self, True, -1, -1);

            WriteNode(TTXXMLNodeElement(ChildNode), Spaces);

            WriteNodeName(TTXXMLNodeElement(ChildNode), False, p, l);
            WriteStr(LineFeed, LineFeedLen);
          end;
          end;
        else
          p := WriteNodeName(Self, True, -1, -1);

          WriteNode(Self, Spaces);

          WriteNodeName(Self, False, p, l);
          WriteStr(LineFeed, LineFeedLen);
        end;
      end;
    end;
  end
  else
    WriteNode(Self, 0);

  Dest^ := #0;

  result := DestLen;

  FreeMem(NodeNameStr);
end;

function TTXXMLNodeElement.GetLevel: Integer;
var
  Node: TTXXMLNode;
begin
  result := 0;

  Node := Self;
  while Node.FParent <> nil do
  begin
    Node := Node.FParent;
    inc(result);
  end;
end;

function TTXXMLNodeElement.GetIndex: Integer;
var
  i, c: Integer;
begin
  result := -1;

  if FOwner <> nil then
    if TTXXMLNodeElement(FOwner).FChildNodes <> nil then
    begin
      c := TTXXMLNodeElement(FOwner).Count - 1;
      for i := 0 to c do
        if TTXXMLNodeElement(FOwner).FChildNodes.Items[i] = Self then
        begin
          result := i;
          Break;
        end;
    end;
end;

function TTXXMLNodeElement.IsValidName(const Name: AnsiString): Boolean;
var
  src:  PAnsiChar;
  fchr: PAnsiChar;
  vchr: PAnsiChar;
begin
  result := False;

  src := PAnsiChar(Name);

  if src <> nil then
  begin
    fchr := PAnsiChar(XMLNameFirstChar);
    vchr := PAnsiChar(XMLNameValidChars);

    if AnsiStrScan(fchr, src^) <> nil then
    begin
      result := True;

      inc(src);

      while src^ <> #0 do
        if AnsiStrScan(vchr, src^) = nil then
        begin
          result := False;
          Break;
        end
        else
          inc(src);
    end;
  end;
end;

constructor TTXXMLDocument.Create;
begin
  FDocument := TTXXMLNodeElement.Create(nil, Self);

  FEncoding := xeUTF8;
  FWriteVersion := True;
  FSpaces := 1;
  FLineFeed := #13#10;
  FUseTabs := True;

  FAttributesCaseSensitive := True;
end;

destructor TTXXMLDocument.Destroy;
begin
  FDocument.Free;

  inherited;
end;

procedure TTXXMLDocument.LoadFromFile(const Filename: AnsiString);
begin
  FDocument.LoadFromFile(Filename);
end;

procedure TTXXMLDocument.LoadFromStream(Stream: TStream);
begin
  FDocument.LoadFromStream(Stream);
end;

procedure TTXXMLDocument.SaveToFile(const Filename: AnsiString);
begin
  FDocument.SaveToFile(Filename);
end;

procedure TTXXMLDocument.SaveToStream(Stream: TStream);
begin
  FDocument.SaveToStream(Stream);
end;

procedure TTXXMLDocument.Clear;
begin
  FDocument.Clear;
end;

procedure TTXXMLDocument.SetText(const Text: AnsiString);
begin
  FDocument.InternalSetXMLText(PAnsiChar(Text), FXMLEntities, FEncoding);
end;

function TTXXMLDocument.GetText: AnsiString;
var
  Dest:     PAnsiChar;
  DestLen:  Integer;
begin
  Dest := AllocMem(102400);
  DestLen := 102400;

  FDocument.InternalGetXMLText(Dest, DestLen, True, FXMLEntities, FEncoding, FWriteVersion, FUseTabs, FSpaces, PAnsiChar(FLineFeed), Length(LineFeed));

  result := Dest;
  FreeMem(Dest);
end;

procedure TTXXMLDocument.SetAttributesCaseSensitive(AttributesCaseSensitive: Boolean);
  procedure SetAttr(XMLNode: TTXXMLNodeElement);
  var
    i, c: Integer;
  begin
    if XMLNode.FAttributes <> nil then
      XMLNode.FAttributes.CaseSensitive := AttributesCaseSensitive;

    c := XMLNode.Count - 1;
    for i := 0 to c do
      if XMLNode.ChildNodes[i].NodeType = dtElement then
        SetAttr(TTXXMLNodeElement(XMLNode.ChildNodes[i]));
  end;
begin
  if AttributesCaseSensitive <> FAttributesCaseSensitive then
  begin
    SetAttr(FDocument);

    FAttributesCaseSensitive := AttributesCaseSensitive;
  end;
end;

function WellFilename(const Filename: AnsiString): AnsiString;
var
  Net:  Boolean;
begin
  result := ReplaceChar(Trim(Filename), '/', '\');

  Net := Copy(result, 1, 2) = '\\';

  result := LimitMultiChars(result, '\');

  if Net then
    result := '\' + result;
end;

function TXPos(const SubStr, Str: AnsiString; Offset: Integer = 1): Integer;
var
  i, j, l, ls:  Integer;
begin
  if Offset = 1 then
    Result := Pos(SubStr, Str)
  else
  begin
    i := Offset;
    ls := Length(SubStr);
    l := Length(Str) - ls + 1;
    while i <= l do
    begin
      if Str[i] = SubStr[1] then
      begin
        j := 1;
        while (j < ls) and (Str[i + j] = SubStr[j + 1]) do
          inc(j);

        if j = ls then
        begin
          result := i;
          Exit;
        end;
      end;

      inc(i);
    end;

    result := 0;
  end;
end;

function TXStrToFloat(const Str: AnsiString): Extended;
var
  i, l:   Integer;
  res:    AnsiString;
  deco:   AnsiChar;
begin
  if FormatSettings.DecimalSeparator = ',' then
    deco := '.'
  else
    deco := ',';

  res := '';
  l := Length(Str);
  for i := 1 to l do
    if ((Str[i] >= '0') and (Str[i] <= '9')) or
       (Str[i] in [ '+', '-', 'E', 'e', FormatSettings.DecimalSeparator ])
                                     then
      res := res + Str[i]
    else if Str[i] = deco then
      res := res + FormatSettings.DecimalSeparator;

  try
    result := StrToFloat(res);
  except
    result := 0;
  end;
end;

function TXHexToInt(const Str: AnsiString): Integer;
var
  src:  PAnsiChar;
  ptr:  PAnsiChar;
  i:    Integer;
begin
  result := 0;

  src := PAnsiChar(Str);
  if src <> nil then
  begin
    ptr := StrEnd(src) - 1;
    i := 0;
    while ptr >= src do
    begin
      if ptr^ in ['0'..'9'] then
        inc(result, ((Integer(ptr^) - 48) shl i))
      else if ptr^ in ['a'..'f'] then
        inc(result, ((Integer(ptr^) - 87) shl i))
      else if ptr^ in ['A'..'F'] then
        inc(result, ((Integer(ptr^) - 55) shl i))
      else
        Break;

      inc(i, 4);
      dec(ptr);
    end;
  end;
end;

function TXHexToInt64(const Str: AnsiString): Int64;
var
  src:  PAnsiChar;
  ptr:  PAnsiChar;
  i:    Integer;
begin
  result := 0;

  src := PAnsiChar(Str);
  if src <> nil then
  begin
    ptr := StrEnd(src) - 1;
    i := 0;
    while ptr >= src do
    begin
      if ptr^ in ['0'..'9'] then
        inc(result, ((Integer(ptr^) - 48) shl i))
      else if ptr^ in ['a'..'f'] then
        inc(result, ((Integer(ptr^) - 87) shl i))
      else if ptr^ in ['A'..'F'] then
        inc(result, ((Integer(ptr^) - 55) shl i))
      else
        Break;

      inc(i, 4);
      dec(ptr);
    end;
  end;
end;

function TXEncodeUTF8(const Str: AnsiString): AnsiString;
var
  pstr:       PAnsiChar;
  destStr:    PAnsiChar;
  destLen:    Integer;
  l:          Integer;
begin
  pstr := PAnsiChar(Str);
  if pstr <> nil then
  begin
    destLen := 32;
    destStr := AllocMem(destLen);

    l := _EncodeUTF8(pstr, destStr, destLen);

    SetString(result, destStr, l);

    FreeMem(destStr);
  end
  else
    result := '';
end;

function TXDecodeUTF8(const Str: AnsiString): AnsiString;
var
  pstr:       PAnsiChar;
  destStr:    PAnsiChar;
  destLen:    Integer;
  l:          Integer;
begin
  pstr := PAnsiChar(Str);
  if pstr <> nil then
  begin
    destLen := 32;
    destStr := AllocMem(destLen);

    l := _DecodeUTF8(pstr, destStr, destLen);

    SetString(result, destStr, l);

    FreeMem(destStr);
  end
  else
    result := '';
end;

function LimitString(const Text, Chars: AnsiString; AllowedChars: Boolean = True): AnsiString;
var
  i, c:   Integer;
begin
  result := '';
  c := Length(Text);
  if AllowedChars then
  begin
    for i := 1 to c do
      if TXPosChar(Text[i], Chars) > 0 then
        result := result + Text[i];
  end
  else
    for i := 1 to c do
      if TXPosChar(Text[i], Chars) = 0 then
        result := result + Text[i];
end;

function LimitMultiChars(const Text, Chars: AnsiString): AnsiString;
var
  SrcLen:     Integer;
  DestLen:    Integer;
  PSrc:       PAnsiChar;
  PDest:      PAnsiChar;
  C, LC, Chr: AnsiChar;
  i, l:       Integer;
begin
  PSrc := PAnsiChar(Text);
  if PSrc <> nil then
  begin
    SrcLen := Length(Text);
    if SrcLen > 0 then
    begin
      l := Length(Chars);
      if l > 0 then
      begin
        SetLength(result, SrcLen);
        PDest := PAnsiChar(result);

        DestLen := 0;
        LC := #0;

        if l = 1 then
        begin
          Chr := Chars[1];

          for i := 1 to SrcLen do
          begin
            C := Text[i];
            if C = LC then
              if C = Chr then
                Continue;

            LC := C;
            PDest^ := C;
            inc(PDest);
            inc(DestLen);
          end;
        end
        else
          for i := 1 to SrcLen do
          begin
            C := Text[i];
            if C = LC then
              if TXPosChar(C, Chars) > 0 then
                Continue;

            LC := C;
            PDest^ := C;
            inc(PDest);
            inc(DestLen);
          end;

        if SrcLen <> DestLen then
          SetLength(result, DestLen);
      end
      else
        result := Text;
    end
    else
      result := '';
  end
  else
    result := '';
end;

function LimitSpaces(const Text: AnsiString): AnsiString;
begin
  result := LimitMultiChars(Trim(Text), ' ');
end;

function ReplaceChar(const Text: AnsiString; FromChar, ToChar: AnsiChar): AnsiString;
var
  psrc:   PAnsiChar;
  pdest:  PAnsiChar;
  ch:     AnsiChar;
  l:      Integer;
begin
  l := Length(Text);
  SetLength(result, l);
  if l > 0 then
  begin
    psrc := PAnsiChar(Text);
    pdest := PAnsiChar(result);

    while l > 0 do
    begin
      ch := psrc^;
      if ch = FromChar then
        ch := ToChar;

      pdest^ := ch;

      inc(psrc);
      inc(pdest);
      dec(l);
    end;
  end;
end;

function DeleteChars(const Text, Chars: AnsiString): AnsiString;
var
  SrcLen:   Integer;
  DestLen:  Integer;
  PSrc:     PAnsiChar;
  PDest:    PAnsiChar;
  C, Chr:   AnsiChar;
  i, l:     Integer;
begin
  PSrc := PAnsiChar(Text);
  if PSrc <> nil then
  begin
    SrcLen := Length(Text);
    if SrcLen > 0 then
    begin
      l := Length(Chars);
      if l > 0 then
      begin
        SetLength(result, SrcLen);
        PDest := PAnsiChar(result);

        DestLen := 0;

        if l = 1 then
        begin
          Chr := Chars[1];

          for i := 1 to SrcLen do
          begin
            C := Text[i];
            if C <> Chr then
            begin
              PDest^ := C;
              inc(PDest);
              inc(DestLen);
            end;
          end;
        end
        else
          for i := 1 to SrcLen do
          begin
            C := Text[i];
            if TXPosChar(C, Chars) = 0 then
            begin
              PDest^ := C;
              inc(PDest);
              inc(DestLen);
            end;
          end;

        if SrcLen <> DestLen then
          SetLength(result, DestLen);
      end
      else
        result := Text;
    end
    else
      result := '';
  end
  else
    result := '';
end;

function DelimitedElement(const Str: AnsiString; Index: Integer; Delimiter: AnsiChar = ';'; QuoteChar: AnsiChar = #0): AnsiString;
var
  ptr:    PAnsiChar;
  start:  PAnsiChar;
  q, qe:  Boolean;
  f:      Boolean;
  i:      Integer;
begin
  i := 0;

  result := '';

  ptr := PAnsiChar(Str);
  if ptr <> nil then
  begin
    if ptr^ <> #0 then
    begin
      if QuoteChar <> #0 then
        repeat
          qe := False;
          q := False;

          f := True;

          start := ptr;
          while ptr^ <> #0 do
          begin
            if ptr^ = QuoteChar then
            begin
              qe := True;
              q := not q;

              if f then
              begin
                start := ptr;
                f := False;
              end;
            end
            else if (not q) and (ptr^ = Delimiter) then
              Break;

            inc(ptr);
          end;

          if i >= Index then
            if qe then
            begin
              result := AnsiExtractQuotedStr(start, QuoteChar);
              Break;
            end
            else
            begin
              SetString(result, start, ptr - start);
              Break;
            end;

          if ptr^ = Delimiter then
            if ptr^ <> #0 then
              inc(ptr);

          inc(i);
        until ptr^ = #0
      else if Delimiter <> #0 then
        repeat
          start := ptr;

          ptr := AnsiStrScan(ptr, Delimiter);
          if ptr <> nil then
          begin
            if i >= Index then
            begin
              SetString(result, start, ptr - start);
              Exit;
            end;

            inc(ptr);
          end
          else if i >= Index then
          begin
            SetString(result, start, StrEnd(start) - start);
            Exit;
          end;

          inc(i);
        until ptr = nil
      else if Index <= 0 then
        result := Str
      else
        result := '';
    end
    else
      result := '';
  end
  else
    result := '';
end;

function Explode(const Str: AnsiString; Delimiter: AnsiChar = ';'; QuoteChar: AnsiChar = '"'): TStringList;
var
  ptr:    PAnsiChar;
  start:  PAnsiChar;
  q, qe:  Boolean;
  f:      Boolean;
  s:      AnsiString;
begin
  result := TStringList.Create;

  ptr := PAnsiChar(Str);
  if ptr <> nil then
    if ptr^ <> #0 then
      if QuoteChar <> #0 then
        repeat
          qe := False;
          q := False;

          f := True;

          start := ptr;
          while ptr^ <> #0 do
          begin
            if ptr^ = QuoteChar then
            begin
              qe := True;
              q := not q;

              if f then
              begin
                start := ptr;
                f := False;
              end;
            end
            else if (not q) and (ptr^ = Delimiter) then
              Break;

            inc(ptr);
          end;

          if qe then
            result.Add(AnsiExtractQuotedStr(start, QuoteChar))
          else
          begin
            SetString(s, start, ptr - start);
            result.Add(s);
          end;

          if ptr^ = Delimiter then
            if ptr^ <> #0 then
              inc(ptr);
        until ptr^ = #0
      else if Delimiter <> #0 then
        repeat
          start := ptr;

          ptr := AnsiStrScan(ptr, Delimiter);
          if ptr <> nil then
          begin
            SetString(s, start, ptr - start);
            inc(ptr);
          end
          else
            SetString(s, start, StrEnd(start) - start);

          result.Add(s);
        until ptr = nil
      else
        result.Add(Str);
end;

function Implode(StrList: TStrings; Delimiter: Char = ';'; QuoteChar: Char = '"'): AnsiString;
begin
  StrList.QuoteChar := QuoteChar;
  StrList.Delimiter := Delimiter;

  result := StrList.DelimitedText;
end;

function PercentString(Value, Max: Double; DecimalPlaces: Integer = 1): AnsiString;
var
  r:    Int64;
begin
  result := '-';
  try
    if Max <> 0.0 then
    begin
      r := Trunc((DecimalPlaces + 1) * 100 * Value / Max);
      result := IntToStr(r);
      if DecimalPlaces > 0 then
        result := LeftStr(result, Length(result) - DecimalPlaces) + ',' + RightStr(result, DecimalPlaces);
    end;
  except
  end;
end;

var
  __lev_dist: array of array of Integer;

function StringDistance(const String1, String2: AnsiString; MaximumDistance: Integer = -1): Integer;
var
  n, m, i, j, ci, cj:   Integer;
  bped:                 Integer;
  cost:                 Integer;
  s1, s2:               AnsiChar;
  resize:               Boolean;

  function min(a, b, c: Integer): Integer;
  begin
    if b < a then
      a := b;
    if c < a then
      a := c;
    result := a;
  end;
begin
  n := Length(String1);
  m := Length(String2);

  if n = 0 then
  begin
    result := m;
    Exit;
  end;
  if m = 0 then
  begin
    result := n;
    Exit;
  end;

  if MaximumDistance >= 0 then
  begin
    i := n - m;
    if i < 0 then
      i := -i;
    if i > MaximumDistance then
    begin
      result := -1;
      Exit;
    end;
  end;

  if n + 1 > Length(__lev_dist) then
    resize := True
  else if m + 1 > Length(__lev_dist[0]) then
    resize := True
  else
    resize := False;

  if resize then
  begin
    ci := Length(__lev_dist);
    if ci > 0 then
      cj := Length(__lev_dist[0])
    else
      cj := 0;

    SetLength(__lev_dist, n + 1, m + 1);
    for i := ci to n do
      __lev_dist[i, 0] := i;
    for j := cj to m do
      __lev_dist[0, j] := j;
  end;

  for i := 1 to n do
  begin
    s1 := String1[i];

    bped := m;
    for j := 1 to m do
    begin
      s2 := String2[j];

      if s1 = s2 then
        cost := 0
      else
        cost := 1;

      __lev_dist[i, j] := min(__lev_dist[i - 1, j] + 1, __lev_dist[i, j - 1] + 1, __lev_dist[i - 1, j - 1] + cost);

      if MaximumDistance >= 0 then
        if __lev_dist[i, j] < bped then
          bped := __lev_dist[i, j];
    end;

    if MaximumDistance >= 0 then
      if i > MaximumDistance then
        if bped > MaximumDistance then
        begin
          result := -1;
          Exit;
        end;
  end;

  result := __lev_dist[n, m];
end;

function XMLTextToText(const Text: AnsiString; Entities: TTXXMLEntities = nil; Encoding: TTXXMLEncoding = xeUTF8; ReduceSpaces: Boolean = True): AnsiString;
var
  Src:      PAnsiChar;
  Dest:     PAnsiChar;
  DestLen:  Integer;
begin
  Src := PAnsiChar(Text);

  if Src <> nil then
  begin
    Dest := AllocMem(32);
    DestLen := 32;

    _XMLTextToText(Src, Dest, DestLen, Entities, Encoding, ReduceSpaces);
    result := Dest;

    FreeMem(Dest);
  end
  else
    result := '';
end;

function TextToXMLText(const XMLText: AnsiString; Entities: TTXXMLEntities = nil; Encoding: TTXXMLEncoding = xeUTF8; ReduceSpaces: Boolean = True): AnsiString;
var
  Src:      PAnsiChar;
  Dest:     PAnsiChar;
  DestLen:  Integer;
begin
  Src := PAnsiChar(XMLText);

  if Src <> nil then
  begin
    Dest := AllocMem(32);
    DestLen := 32;

    _TextToXMLText(Src, Dest, DestLen, Entities, Encoding, ReduceSpaces);
    result := Dest;

    FreeMem(Dest);
  end
  else
    result := '';
end;

function GetXMLText(XMLNode: TTXXMLNodeElement; IncludeSubNodes: Boolean = False): AnsiString;
var
  i, c: Integer;
begin
  result := '';

  c := XMLNode.Count - 1;
  for i := 0 to c do
    case XMLNode.NodeTypes[i] of
    dtText, dtCDATA: result := result + XMLNode.TextNodes[i].Text;
    dtElement: if IncludeSubNodes then result := result + GetXMLText(XMLNode.Elements[i]);
    end;
end;

function SearchXMLNode(XMLNode: TTXXMLNodeElement; const NodeName: AnsiString; CaseSensitive: Boolean = False): TTXXMLNodeElement;
var
  NN:   AnsiString;
  i, c: Integer;
begin
  result := nil;

  if not CaseSensitive then
    NN := LowerCase(NodeName);

  c := XMLNode.Count - 1;
  for i := 0 to c do
    if XMLNode.NodeTypes[i] = dtElement then
      if CaseSensitive then
      begin
        if XMLNode.Elements[i].NodeName = NodeName then
        begin
          result := XMLNode.Elements[i];
          Break;
        end;
      end
      else
      begin
        if LowerCase(XMLNode.Elements[i].NodeName) = NN then
        begin
          result := XMLNode.Elements[i];
          Break;
        end;
      end;
end;

function CalcDaysTotal(Day, Month, Year: Integer): Integer;
var
  d, m, y:  Integer;
begin
  if month < 3 then
  begin
    m := Month + 12;
    y := Year - 1;
  end
  else
  begin
    m := Month;
    y := Year;
  end;

  d := Day;
  inc(m);

  result := 365 * y + y div 4 - y div 100 + y div 400 + (m * 306) div 10 + d - 64;
end;

procedure CalcDate(DaysTotal: Integer; var Day, Month, Year: Integer);
var
  a, b, c, d, e, f, g, h, k, l, t, _m, _j, m, j:  Integer;

  function clMin(a, b: Integer): Integer;
  begin
    if a < b then
      result := a
    else
      result := b;
  end;
begin
  if DaysTotal < 59 then
    dec(DaysTotal);

  a := DaysTotal + 1753105;
  b := a div 146097;
	c := a mod 146097;
	d := clMin(3, c div 36524);
	e := c - 36524 * d;
	f := e div 1461;
	g := e mod 1461;
	h := clMin(3, g div 365);
	k := g - 365 * h;
	l := (111 * k + 41) div 3395;
	t := k - 30 * l - (7 * l + 7) div 12 + 1;
	_m := l + 3;
	_j := 400 * b + 100 * d + 4 * f + 1 * h - 4800;
	m := ((_m + 11) mod 12) + 1;
	j := _j + _m div 13;

	Day := t;
	Month := m;
	Year := j;
end;

procedure TXSetDateTime(var DateTime: TTXDateTime; Day, Month, Year, Hour, Minute, Second: Integer; Millisec: Integer = 0);
begin
	DateTime := TXSetDateTime(Day, Month, Year, Hour, Minute, Second, Millisec);
end;

function TXSetDateTime(Day, Month, Year, Hour, Minute, Second: Integer; Millisec: Integer = 0): TTXDateTime;
var
  d:  Int64;
begin
	result := Int64(Hour) * 3600000 + Int64(Minute) * 60000 + Int64(Second) * 1000 + Int64(Millisec);

  d := Int64(Day) + result div 86400000;
	if result < 0 then
  begin
    inc(result, 86400000);
    dec(d);
  end;

  result := result mod 86400000;
  result := result + Int64(CalcDaysTotal(d, Month, Year)) * 86400000;
end;

procedure TXSetDate(var DateTime: TTXDateTime; Day, Month, Year: Integer);
var
  d, m, y, h, n, s, ms: Integer;
begin
  TXGetDateTime(DateTime, d, m, y, h, n, s, ms);

  TXSetDateTime(DateTime,
                Day,
                Month,
                Year,
                h,
                n,
                s,
                ms);
end;

procedure TXSetTime(var DateTime: TTXDateTime; Hour, Minute, Second: Integer; Millisec: Integer = 0);
var
  d, m, y, h, n, s, ms: Integer;
begin
  TXGetDateTime(DateTime, d, m, y, h, n, s, ms);

  TXSetDateTime(DateTime,
                d,
                m,
                y,
                Hour,
                Minute,
                Second,
                Millisec);
end;

procedure TXSetDay(var DateTime: TTXDateTime; Day: Integer);
var
  d, m, y, h, n, s, ms: Integer;
begin
  TXGetDateTime(DateTime, d, m, y, h, n, s, ms);

  TXSetDateTime(DateTime,
                Day,
                m,
                y,
                h,
                n,
                s,
                ms);
end;

procedure TXSetMonth(var DateTime: TTXDateTime; Month: Integer);
var
  d, m, y, h, n, s, ms: Integer;
begin
  TXGetDateTime(DateTime, d, m, y, h, n, s, ms);

  TXSetDateTime(DateTime,
                d,
                Month,
                y,
                h,
                n,
                s,
                ms);
end;

procedure TXSetYear(var DateTime: TTXDateTime; Year: Integer);
var
  d, m, y, h, n, s, ms: Integer;
begin
  TXGetDateTime(DateTime, d, m, y, h, n, s, ms);

  TXSetDateTime(DateTime,
                d,
                m,
                Year,
                h,
                n,
                s,
                ms);
end;

procedure TXSetHour(var DateTime: TTXDateTime; Hour: Integer);
var
  d, m, y, h, n, s, ms: Integer;
begin
  TXGetDateTime(DateTime, d, m, y, h, n, s, ms);

  TXSetDateTime(DateTime,
                d,
                m,
                y,
                Hour,
                n,
                s,
                ms);
end;

procedure TXSetMinute(var DateTime: TTXDateTime; Minute: Integer);
var
  d, m, y, h, n, s, ms: Integer;
begin
  TXGetDateTime(DateTime, d, m, y, h, n, s, ms);

  TXSetDateTime(DateTime,
                d,
                m,
                y,
                h,
                Minute,
                s,
                ms);
end;

procedure TXSetSecond(var DateTime: TTXDateTime; Second: Integer);
var
  d, m, y, h, n, s, ms: Integer;
begin
  TXGetDateTime(DateTime, d, m, y, h, n, s, ms);

  TXSetDateTime(DateTime,
                d,
                m,
                y,
                h,
                n,
                Second,
                ms);
end;

procedure TXSetMillisec(var DateTime: TTXDateTime; Millisec: Integer);
var
  d, m, y, h, n, s, ms: Integer;
begin
  TXGetDateTime(DateTime, d, m, y, h, n, s, ms);

  TXSetDateTime(DateTime,
                d,
                m,
                y,
                h,
                n,
                s,
                Millisec);
end;

procedure TXGetDateTime(DateTime: TTXDateTime; var Day, Month, Year, Hour, Minute, Second, Millisec: Integer);
var
  DayMillisecs: Integer;
begin
  CalcDate(Integer(DateTime div 86400000), Day, Month, Year);

  DayMillisecs := Integer(DateTime mod 86400000);

  Hour := DayMillisecs div 3600000;
  Minute := (DayMillisecs div 60000) mod 60;
  Second := (DayMillisecs div 1000) mod 60;
  Millisec := DayMillisecs mod 1000;
end;

procedure TXGetDate(DateTime: TTXDateTime; var Day, Month, Year: Integer);
var
  h, n, s, ms:  Integer;
begin
  TXGetDateTime(DateTime, Day, Month, Year, h, n, s, ms);
end;

procedure TXGetTime(DateTime: TTXDateTime; var Hour, Minute, Second, Millisec: Integer);
var
  d, m, y:  Integer;
begin
  TXGetDateTime(DateTime, d, m, y, Hour, Minute, Second, Millisec);
end;

function TXGetDay(DateTime: TTXDateTime): Integer;
var
  m, y, h, n, s, ms:  Integer;
begin
  TXGetDateTime(DateTime, result, m, y, h, n, s, ms);
end;

function TXGetMonth(DateTime: TTXDateTime): Integer;
var
  d, y, h, n, s, ms:  Integer;
begin
  TXGetDateTime(DateTime, d, result, y, h, n, s, ms);
end;

function TXGetYear(DateTime: TTXDateTime): Integer;
var
  d, m, h, n, s, ms:  Integer;
begin
  TXGetDateTime(DateTime, d, m, result, h, n, s, ms);
end;

function TXGetHour(DateTime: TTXDateTime): Integer;
var
  d, m, y, n, s, ms:  Integer;
begin
  TXGetDateTime(DateTime, d, m, y, result, n, s, ms);
end;

function TXGetMinute(DateTime: TTXDateTime): Integer;
var
  d, m, y, h, s, ms:  Integer;
begin
  TXGetDateTime(DateTime, d, m, y, h, result, s, ms);
end;

function TXGetSecond(DateTime: TTXDateTime): Integer;
var
  d, m, y, h, n, ms:  Integer;
begin
  TXGetDateTime(DateTime, d, m, y, h, n, result, ms);
end;

function TXGetMillisec(DateTime: TTXDateTime): Integer;
var
  d, m, y, h, n, s: Integer;
begin
  TXGetDateTime(DateTime, d, m, y, h, n, s, result);
end;

function TXGetWeekDay(DateTime: TTXDateTime): Integer;
begin
  result := (Integer(DateTime div 86400000) - 362 + 4) mod 7;
end;
function TXIsLeapYear(DateTime: TTXDateTime): Boolean;
var
  y:  Integer;
begin
  y := TXGetYear(DateTime);

  result := ((y mod 4) = 0) and (((y mod 100) <> 0) or ((y mod 400) = 0));
end;

function TXGetCalenderDay(DateTime: TTXDateTime): Integer;
var
  d, m, y:  Integer;
begin
  TXGetDate(DateTime, d, m, y);

  case m of
  1: result := d;
  2: result := d + 31;
  3: result := d + 59 + Integer(TXIsLeapYear(DateTime));
  4: result := d + 90 + Integer(TXIsLeapYear(DateTime));
  5: result := d + 120 + Integer(TXIsLeapYear(DateTime));
  6: result := d + 151 + Integer(TXIsLeapYear(DateTime));
  7: result := d + 181 + Integer(TXIsLeapYear(DateTime));
  8: result := d + 212 + Integer(TXIsLeapYear(DateTime));
  9: result := d + 243 + Integer(TXIsLeapYear(DateTime));
  10: result := d + 273 + Integer(TXIsLeapYear(DateTime));
  11: result := d + 304 + Integer(TXIsLeapYear(DateTime));
  12: result := d + 334 + Integer(TXIsLeapYear(DateTime));
  else
    result := 0;
  end;
end;

function TXGetCalenderWeek(DateTime: TTXDateTime): Integer;
var
  a1, a2, b1, b2, d, cd, m, y:  Integer;
begin
  TXGetDate(DateTime, d, m, y);
  cd := TXGetCalenderDay(DateTime);

  a1 := (CalcDaysTotal(1, 1, y) - 362 + 4) mod 7;
  a2 := (CalcDaysTotal(31, 12, y) - 362 + 4) mod 7;
  d := a1 - 1;

  if a1 < 4 then
    inc(d, 7);

  result := (cd + d) div 7;
  if (result = 53) and (a2 < 3) then
    result := 1;
  if result = 0 then
  begin
    b1 := (CalcDaysTotal(1, 1, y - 1) - 362 + 4) mod 7;
    b2 := (CalcDaysTotal(31, 12, y - 1) - 362 + 4) mod 7;

    if (b1 = 3) or (b2 = 3) then
      result := 53
    else
      result := 52;
  end;
end;

function TXIncDays(DateTime: TTXDateTime; Days: Integer = 1): TTXDateTime;
var
  d, m, y, h, n, s, ms: Integer;
begin
  TXGetDateTime(DateTime, d, m, y, h, n, s, ms);

  TXSetDateTime(DateTime,
                d + Days,
                m,
                y,
                h,
                m,
                s,
                ms);

  result := DateTime;
end;

function TXIncMonths(DateTime: TTXDateTime; Months: Integer = 1): TTXDateTime;
var
  d, m, y, h, n, s, ms: Integer;
begin
  TXGetDateTime(DateTime, d, m, y, h, n, s, ms);

  TXSetDateTime(DateTime,
                d,
                m + Months,
                y,
                h,
                m,
                s,
                ms);

  result := DateTime;
end;

function TXIncYears(DateTime: TTXDateTime; Years: Integer = 1): TTXDateTime;
var
  d, m, y, h, n, s, ms: Integer;
begin
  TXGetDateTime(DateTime, d, m, y, h, n, s, ms);

  TXSetDateTime(DateTime,
                d,
                m,
                y + Years,
                h,
                m,
                s,
                ms);

  result := DateTime;
end;

function TXIncHours(DateTime: TTXDateTime; Hours: Integer = 1): TTXDateTime;
begin
  result := DateTime + Int64(Hours) * 3600000;
end;

function TXIncMinutes(DateTime: TTXDateTime; Minutes: Integer = 1): TTXDateTime;
begin
  result := DateTime + Int64(Minutes) * 60000;
end;

function TXIncSeconds(DateTime: TTXDateTime; Seconds: Integer = 1): TTXDateTime;
begin
  result := DateTime + Int64(Seconds) * 1000;
end;

function TXIncMillisecs(DateTime: TTXDateTime; Millisecs: Integer = 1): TTXDateTime;
begin
  result := DateTime + Int64(Millisecs);
end;

function TXDaysBetween(ANow, AThen: TTXDateTime): Int64;
begin
  result := (ANow - AThen) div 86400000;
end;

function TXWeeksBetween(ANow, AThen: TTXDateTime): Int64;
begin
  result := (ANow - AThen) div 604800000;
end;

function TXMonthsBetween(ANow, AThen: TTXDateTime): Int64;
begin
  result := (ANow - AThen) div 2629800000;
end;

function TXYearsBetween(ANow, AThen: TTXDateTime): Int64;
begin
  result := (ANow - AThen) div 31557600000;
end;

function TXHoursBetween(ANow, AThen: TTXDateTime): Int64;
begin
  result := (ANow - AThen) div 3600000;
end;

function TXMinutesBetween(ANow, AThen: TTXDateTime): Int64;
begin
  result := (ANow - AThen) div 60000;
end;

function TXSecondsBetween(ANow, AThen: TTXDateTime): Int64;
begin
  result := (ANow - AThen) div 1000;
end;

function TXMillisecsBetween(ANow, AThen: TTXDateTime): Int64;
begin
  result := ANow - AThen;
end;

function TXCompareDateTimes(DateTime1, DateTime2: TTXDateTime): Integer;
begin
  if DateTime1 > DateTime2 then
    result := 1
  else if DateTime1 < DateTime2 then
    result := -1
  else
    result := 0;
end;

function DateTimeToTXDateTime(DateTime: TDateTime): TTXDateTime;
begin
  TXSetDateTime(result,
                DayOf(DateTime),
                MonthOf(DateTime),
                YearOf(DateTime),
                HourOf(DateTime),
                MinuteOf(DateTime),
                SecondOf(DateTime),
                MilliSecondOf(DateTime));
end;

function TXDateTimeToDateTime(DateTime: TTXDateTime): TDateTime;
begin
  result := EncodeDateTime(Word(TXGetYear(DateTime)),
                           Word(TXGetMonth(DateTime)),
                           Word(TXGetDay(DateTime)),
                           Word(TXGetHour(DateTime)),
                           Word(TXGetMinute(DateTime)),
                           Word(TXGetSecond(DateTime)),
                           Word(TXGetMillisec(DateTime)));
end;

function TXFormatDateTime(const Format: AnsiString; DateTime: TTXDateTime): AnsiString; overload;
begin
  result := FormatDateTime(Format, TXDateTimeToDateTime(DateTime));
end;

function ParseDateTime(const Str, Format: AnsiString): TDateTime;
var
  d, m, y, h, n, s, ms: Integer;
  i, j, sl, fl:         Integer;
  o:                    AnsiString;
  done, nf:             Boolean;
begin
  d := 1;
  m := 1;
  y := 0;
  h := 0;
  n := 0;
  s := 0;
  ms := 0;

  nf := False;

  sl := Length(Str);
  fl := Length(Format);

  o := '';

  j := 1;
  for i := 1 to sl do
  begin
    if Str[i] in ['0'..'9'] then
      o := o + Str[i]
    else
      nf := True;

    if nf or (i = sl) then
    begin
      done := False;

      while (j <= fl) and (not done) do
      begin
        done := True;

        case Format[j] of
        'd': d := TXStrToInt(o);
        'm': m := TXStrToInt(o);
        'j': y := TXStrToInt(o);
        'y':
        begin
          y := TXStrToInt(o);
          if y < 100 then
            if y > 30 then
              inc(y, 1900)
            else
              inc(y, 2000);
        end;
        'h': h := TXStrToInt(o);
        'n': n := TXStrToInt(o);
        's': s := TXStrToInt(o);
        'z': ms := TXStrToInt(o);
        else
          done := False;
        end;

        inc(j);
      end;

      if j = fl + 1 then
        Break;

      o := '';

      nf := False;
		end;
	end;

  result := EncodeDateTime(Word(y), Word(m), Word(d), Word(h), Word(n), Word(s), Word(ms));
end;

function TXParseDateTime(const Str, Format: AnsiString): TTXDateTime;
var
  d, m, y, h, n, s, ms: Integer;
  i, j, sl, fl:         Integer;
  o:                    AnsiString;
  done, nf:             Boolean;
begin
  d := 1;
  m := 1;
  y := 0;
  h := 0;
  n := 0;
  s := 0;
  ms := 0;

  nf := False;

  sl := Length(Str);
  fl := Length(Format);

  o := '';

  j := 1;
  for i := 1 to sl do
  begin
    if Str[i] in ['0'..'9'] then
      o := o + Str[i]
    else
      nf := True;

    if nf or (i = sl) then
    begin
      done := False;

      while (j <= fl) and (not done) do
      begin
        done := True;

        case Format[j] of
        'd': d := TXStrToInt(o);
        'm': m := TXStrToInt(o);
        'j': y := TXStrToInt(o);
        'y':
        begin
          y := TXStrToInt(o);
          if y < 100 then
            if y > 30 then
              inc(y, 1900)
            else
              inc(y, 2000);
        end;
        'h': h := TXStrToInt(o);
        'n': n := TXStrToInt(o);
        's': s := TXStrToInt(o);
        'z': ms := TXStrToInt(o);
        else
          done := False;
        end;

        inc(j);
      end;

      if j = fl + 1 then
        Break;

      o := '';

      nf := False;
		end;
	end;

  TXSetDateTime(result, d, m, y, h, n, s, ms);
end;

function TXParseDate(const Str: AnsiString): TTXDateTime;
var
  day, month, year:   Integer;
  i, j, v, l:         Integer;
  f:                  Boolean;
  s:                  AnsiString;
begin
  day := 1;
  month := 1;
  year := 1980;

  j := 1;

  l := Length(Str);
  for i := 1 to l do
  begin
    if (Str[i] >= '0') and (Str[i] <= '9') then
    begin
      s := s + Str[i];
      f := True;
    end
    else
      f := False;

    if ((not f) and (Str[i] > #32)) or (i = l) then
    begin
      try
        v := StrToInt(s);
        case j of
        2: month := year;
        3:
        begin
          day := month;
          month := year;
          year := v;

          Break;
        end;
        end;

        year := v;

        inc(j);
      except
      end;

      s := '';
    end;
  end;

  if year < 100 then
    if year > 30 then
      inc(year, 1900)
    else
      inc(year, 2000);

  TXSetDateTime(result, day, month, year, 0, 0, 0, 0);
end;

function TXNow: TTXDateTime;
begin
  result := DateTimeToTXDateTime(Now);
end;

end.
