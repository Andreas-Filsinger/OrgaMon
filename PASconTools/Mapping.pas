{
  |������___                  __  __
  |�����/ _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |����| | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |����| |_| | | | (_| | (_| | |  | | (_) | | | |
  |�����\___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |���������������|___/
  |
  |    Copyright (C) 2009  Ronny Schupeta
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
unit Mapping;

{

  Mapping bietet Wert Umsetzer an, dabei ist die linke Seite der alte Wert,
  die rechte Seite der Neue.

  Hallo Welt=Hello world
  h=Hello

  Ist ein Umsetzer definiert, so m�ssen auch alle vorkommenden Werte genau
  definiert sein, ansonsten kommt ein Fehler. z.B. muss auch der leere Wert
  angegeben werden

  =<NULL>

  Man kann den leeren wert erlauben und auch so belassen:

  =

  Eine Besonderheit ist jedoch der "*" Platzhalter hier wird jeder Wert erlaubt

  *=Alles andere

  oder Wert-erhaltend

  *=*

  Gro�- und Kleinschreibung spielt bei der linken Seite KEINE Rolle

  v=x
  V=y

  ist nicht m�glich. Es kommt die Fehlermeldung dass "v" bereits definiert ist.

  Anwendung
  =========

  TFieldMapping bietet verschiedene Namensr�ume, in denen die Umsetzung erfolgen
  muss. Jeder Namensraum besteht dabei aus einer eigenen Datei. Beispiel

  with TFieldMapping.create do
  begin
    // Initialisierung
    Path := SystemSettingsPath;
    //
  end;
  New := Umsetzer[Namespace,Alt];

}

interface

uses
  SysUtils, Classes, txlib;

const
 cMapping_FileExtension = '.ini';
type
  EMappingException = class(Exception);
  EMappingNoOwner = class(EMappingException);
  EMappingKeyUndefined = class(EMappingException);
  EMappingItemAlreadyExists = class(EMappingException);
  EMappingInternalError = class(EMappingException);

  TFieldMappingKeys = class;

  TFieldMappingValue = class
  private
    FOwner: TFieldMappingKeys;
    FKey: String;
    FValue: String;
    FComment: String;
    FWikiDiscription: String;

    procedure SetKey(const Key: String);
    function GetIndex: Integer;
  public
    constructor Create(AOwner: TFieldMappingKeys);

    property Key: String read FKey write SetKey;
    property Value: String read FValue write FValue;
    property Comment: String read FComment write FComment;
    property WikiDiscription: String read FWikiDiscription
      write FWikiDiscription;
    property Index: Integer read GetIndex;
    property Owner: TFieldMappingKeys read FOwner;
  end;

  TFieldMapping = class;

  TFieldMappingKeys = class
  private
    FOwner: TFieldMapping;
    FItems: TTXStringList;
    FFieldname: String;
    FWikiHeadline: String;
    FWikiTableHeads: TStringList;
    FWikiText: TStringList;
    FFileNotFound: Boolean;

    procedure SetFieldname(const Fieldname: String);
    function GetWikiString: String;
    function GetItem(Index: Integer): TFieldMappingValue;
    function GetCount: Integer;
    function GetIndex: Integer;
  public
    constructor Create(AOwner: TFieldMapping);
    destructor Destroy; override;

    procedure Clear;
    function IndexOf(const Key: String): Integer;
    function ItemOf(const Key: String): TFieldMappingValue;
    function GetValue(const Key: String): String;
    function Add(const Key: String): TFieldMappingValue;
    function WikiTable: TStringList;

    property Fieldname: String read FFieldname write SetFieldname;
    property WikiHeadline: String read FWikiHeadline write FWikiHeadline;
    property WikiTableHeads: TStringList read FWikiTableHeads;
    property WikiText: TStringList read FWikiText;
    property WikiString: String read GetWikiString;
    property FileNotFound: Boolean read FFileNotFound;
    property Value[const Key: String]: String read GetValue;
    property Items[Index: Integer]: TFieldMappingValue read GetItem;
    property Count: Integer read GetCount;
    property Index: Integer read GetIndex;
    property Owner: TFieldMapping read FOwner;
  end;

  TFieldMapping = class
  private
    FItems: TTXStringList;
    FPath: String;
    FFilePrefix: String;

    function GetItem(Index: Integer): TFieldMappingKeys;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    function IndexOf(const Fieldname: String): Integer;
    function ItemOf(const Fieldname: String): TFieldMappingKeys;
    function GetValue(const Fieldname, Key: String): String;
    function AddByIniFile(const Fieldname, Filename: String): TFieldMappingKeys;
    function Add(const Fieldname: String): TFieldMappingKeys;

    property Value[const Fieldname, Key: String]: String read GetValue; default;
    property Items[Index: Integer]: TFieldMappingKeys read GetItem;
    property Count: Integer read GetCount;
    property Path: String read FPath write FPath;
    property FilePrefix: String read FFilePrefix write FFilePrefix;
  end;

implementation

uses
  anfix32;

constructor TFieldMappingValue.Create(AOwner: TFieldMappingKeys);
begin
  FOwner := AOwner;
end;

procedure TFieldMappingValue.SetKey(const Key: String);
var
  I: Integer;
begin
  if Assigned(FOwner) then
  begin
    I := FOwner.IndexOf(Key);
    if I < 0 then
      FOwner.FItems.Strings[I] := Key
    else if I <> Index then
      raise EMappingItemAlreadyExists.CreateFmt
        ('Schl�ssel "%s" ist bereits vorhanden.', [Key]);

    FKey := Key;
  end
  else
    EMappingNoOwner.Create('Eigent�mer dieses Objekts nicht gesetzt.');
end;

function TFieldMappingValue.GetIndex: Integer;
begin
  if Assigned(FOwner) then
  begin
    Result := FOwner.IndexOf(FKey);
    if Result < 0 then
      raise EMappingInternalError.Create
        ('(Interner Fehler) Index konnte anhand des Schl�ssels nicht gefunden werden.');
  end
  else
    raise EMappingNoOwner.Create('Eigent�mer dieses Objekts nicht gesetzt.');
end;

constructor TFieldMappingKeys.Create(AOwner: TFieldMapping);
begin
  FOwner := AOwner;

  FItems := TTXStringList.Create;
  FItems.SearchMethod := smHash;
  FItems.CaseSensitive := False;
  FItems.Trimmed := True;
  FItems.Umlaut := True;

  FWikiTableHeads := TStringList.Create;
  FWikiText := TStringList.Create;

  FFileNotFound := False;
end;

destructor TFieldMappingKeys.Destroy;
begin
  Clear;

  FItems.Free;
  FWikiTableHeads.Free;
  FWikiText.Free;

  inherited;
end;

procedure TFieldMappingKeys.Clear;
var
  I: Integer;
begin
  for I := 0 to pred(Count) do
    Items[I].Free;
  FItems.Clear;
end;

function TFieldMappingKeys.IndexOf(const Key: String): Integer;
begin
  Result := FItems.Find(Key);
end;

function TFieldMappingKeys.ItemOf(const Key: String): TFieldMappingValue;
var
  I: Integer;
begin
  I := IndexOf(Key);
  if I >= 0 then
    Result := Items[I]
  else
    Result := nil;
end;

function TFieldMappingKeys.GetValue(const Key: String): String;
var
  Item: TFieldMappingValue;
begin
  if FFileNotFound then
    Result := Key
  else
  begin
    Item := ItemOf(Key);
    if Assigned(Item) then
      Result := Item.Value
    else
    begin
      Item := ItemOf('*');
      if not Assigned(Item) then
        raise EMappingKeyUndefined.CreateFmt('%s: "%s=" ist undefiniert.',
          [Fieldname, Key])
      else if Trim(Item.Value) = '*' then
        Result := Key
      else
        Result := Item.Value;
    end;
  end;
end;

function TFieldMappingKeys.Add(const Key: String): TFieldMappingValue;
begin
  if not Assigned(ItemOf(Key)) then
  begin
    Result := TFieldMappingValue.Create(Self);
    Result.FKey := Key;

    FItems.AddObject(Key, Result);
  end
  else
    raise EMappingItemAlreadyExists.CreateFmt
      ('Schl�ssel "%s" ist bereits vorhanden.', [Key]);
end;

procedure TFieldMappingKeys.SetFieldname(const Fieldname: String);
var
  I: Integer;
begin
  if Assigned(FOwner) then
  begin
    I := FOwner.IndexOf(Fieldname);
    if I < 0 then
      FOwner.FItems.Strings[I] := Fieldname
    else if I <> Index then
      raise EMappingItemAlreadyExists.CreateFmt
        ('Feldname "%s" ist bereits vorhanden.', [Fieldname]);

    FFieldname := Fieldname;
  end
  else
    EMappingNoOwner.Create('Eigent�mer dieses Objekts nicht gesetzt.');
end;

function TFieldMappingKeys.WikiTable: TStringList;
var
  I, C: Integer;

  function GetWikiTableHead: String;
  var
    I, C: Integer;
  begin
    Result := '!';

    C := FWikiTableHeads.Count;
    for I := 0 to 2 do
    begin
      if I > 0 then
        Result := Result + '!!';

      if I < C then
        Result := Result + ' ' + Trim(FWikiTableHeads.Strings[I]) + ' '
      else
        Result := Result + ' ';
    end;
  end;

begin
  Result := TStringList.Create;

  Result.Add('=== ' + FWikiHeadline + ' ===');

  C := FWikiText.Count - 1;
  for I := 0 to C do
    Result.Add(FWikiText.Strings[I]);

  Result.Add
    ('{| border="1" cellpadding="2" style="margin: 1em 1em 1em 0; background: #f9f9f9; border: 1px #AAA solid; border-collapse: collapse; empty-cells:show"');
  Result.Add('|- style="background-color: #e0e0e0"');
  Result.Add(GetWikiTableHead);

  C := Count - 1;
  for I := 0 to C do
  begin
    Result.Add('|-');
    { ResList.Add('| style="text-align:center" | ' + Items[I].FKey);
      ResList.Add('| style="text-align:left" | ' + Items[I].FWikiDiscription);
      ResList.Add('| style="text-align:center" | ' + Items[I].FValue); }
    Result.Add('| ' + Items[I].FKey);
    Result.Add('| ' + Items[I].FWikiDiscription);
    Result.Add('| ' + Items[I].FValue);
  end;

  Result.Add('|}');

end;

function TFieldMappingKeys.GetWikiString: String;
var
  ResList: TStringList;

begin
  ResList := WikiTable;
  Result := WikiTable.text;
  ResList.Free;

end;

function TFieldMappingKeys.GetItem(Index: Integer): TFieldMappingValue;
begin
  CheckIndex(Index, Count);

  Result := TFieldMappingValue(FItems.Objects[Index]);
end;

function TFieldMappingKeys.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TFieldMappingKeys.GetIndex: Integer;
begin
  if Assigned(FOwner) then
  begin
    Result := FOwner.IndexOf(FFieldname);
    if Result < 0 then
      raise EMappingInternalError.Create
        ('Index konnte anhand des Feldnamens nicht gefunden werden.');
  end
  else
    raise EMappingNoOwner.Create('Eigent�mer dieses Objekts nicht gesetzt.');
end;

constructor TFieldMapping.Create;
begin
  FItems := TTXStringList.Create;
  FItems.SearchMethod := smHash;
  FItems.CaseSensitive := False;
  FItems.Trimmed := True;
  FItems.Umlaut := True;
end;

destructor TFieldMapping.Destroy;
begin
  Clear;

  FItems.Free;

  inherited;
end;

procedure TFieldMapping.Clear;
var
  I, C: Integer;
begin
  C := Count - 1;
  for I := 0 to C do
    Items[I].Free;

  FItems.Clear;
end;

function TFieldMapping.IndexOf(const Fieldname: String): Integer;
begin
  Result := FItems.Find(Fieldname);
end;

function TFieldMapping.ItemOf(const Fieldname: String): TFieldMappingKeys;
var
  I: Integer;
begin
  I := IndexOf(Fieldname);
  if I >= 0 then
    Result := Items[I]
  else
    Result := nil;
end;

function TFieldMapping.GetValue(const Fieldname, Key: String): String;
var
  Item: TFieldMappingKeys;
  FN: String;
begin
  Item := ItemOf(Fieldname);
  if not Assigned(Item) then
  begin
    FN := ValidatePathName(FPath) + '\';
    if (Trim(FFilePrefix) <> '') then
      FN := FN + Trim(FFilePrefix) + '.';
    FN := FN + Fieldname + cMapping_FileExtension;

    Item := AddByIniFile(Fieldname, WellFilename(FN));
  end;

  Result := Item.Value[Key];
end;

function TFieldMapping.AddByIniFile(const Fieldname, Filename: String)
  : TFieldMappingKeys;
var
  Content: TStringList;
  IsNewItem: Boolean;
  AKey: String;
  AValue: String;
  AComment: String;
  AParam: String;
  LookForWikiHeadline: Boolean;
  I, C: Integer;

  function ExtractKeyAndValue(S: String;
    var Key, Value, Comment: String): Boolean;
  var
    PEqual: Integer;
    PEndLine: Integer;
  begin
    Result := False;
    Key := '';
    Value := '';
    Comment := '';

    S := ReplaceChar(S, #9, ' ');

    PEndLine := pos(' #', S);
    if PEndLine=0 then
    PEndLine := pos(' ;', S);
    if PEndLine = 0 then
      PEndLine := Length(S) + 1
    else
      Comment := Copy(S, PEndLine + 1, Length(S) - PEndLine);

    PEqual := TXPosChar('=', S);
    if PEqual > 0 then
    begin
      if PEqual < PEndLine then
      begin
        Key := Copy(S, 1, PEqual - 1);
        Value := Trim(Copy(S, PEqual + 1, PEndLine - PEqual - 1));

        Result := True;
      end;
    end;
  end;

  function ExtractParam(S, Keyword: String; var Param: String): Boolean;
  var
    L: Integer;
  begin
    S := Trim(S);
    Keyword := Keyword + ':';
    L := Length(Keyword);

    if TXLowerCase(Copy(S, 1, L)) = TXLowerCase(Keyword) then
    begin
      Param := Trim(Copy(S, L + 1, Length(S) - L));

      Result := True;
    end
    else
    begin
      Param := '';
      Result := False;
    end;
  end;

  procedure AddToWikiTableHeadsByString(const S: String;
    WikiTableHeads: TStrings);
  var
    ResList: TStringList;
  begin
    ResList := TStringList.Create;

    try
      ResList := Explode(S, '|', #0);

      WikiTableHeads.Clear;
      WikiTableHeads.AddStrings(ResList);
    finally
      ResList.Free;
    end;
  end;

begin
  Result := ItemOf(Fieldname);
  if not Assigned(Result) then
  begin
    Result := Add(Fieldname);
    IsNewItem := True;
  end
  else
    IsNewItem := False;

  try
    if FileExists(Filename) then
    begin
      Content := TStringList.Create;

      try
        LookForWikiHeadline := IsNewItem;

        Content.LoadFromFile(Filename);

        C := Content.Count - 1;
        for I := 0 to C do
          if ExtractKeyAndValue(Content.Strings[I], AKey, AValue, AComment) then
          begin
            with Result.Add(AKey) do
            begin
              Value := AValue;
              Comment := AComment;

              if ExtractParam(AComment, 'wikidscr', AParam) then
                WikiDiscription := AParam;
            end;

            LookForWikiHeadline := False;
          end
          else if LookForWikiHeadline then
          begin
            AComment := Trim(AComment);
            if ExtractParam(AComment, 'wikiheadline', AParam) then
              Result.WikiHeadline := AParam
            else if ExtractParam(AComment, 'wikitablehead', AParam) then
              AddToWikiTableHeadsByString(AParam, Result.WikiTableHeads)
            else if ExtractParam(AComment, 'wikicomment', AParam) then
              Result.WikiText.Add(AParam);
          end;
      finally
        Content.Free;
      end;
    end
    else
      Result.FFileNotFound := True;
  except
    if IsNewItem then
      Result.Free;

    raise;
  end;
end;

function TFieldMapping.Add(const Fieldname: String): TFieldMappingKeys;
begin
  if not Assigned(ItemOf(Fieldname)) then
  begin
    Result := TFieldMappingKeys.Create(Self);
    Result.FFieldname := Fieldname;

    FItems.AddObject(Fieldname, Result);
  end
  else
    raise EMappingItemAlreadyExists.CreateFmt
      ('Feldname "%s" ist bereits vorhanden.', [Fieldname]);
end;

function TFieldMapping.GetItem(Index: Integer): TFieldMappingKeys;
begin
  CheckIndex(Index, Count);

  Result := TFieldMappingKeys(FItems.Objects[Index]);
end;

function TFieldMapping.GetCount: Integer;
begin
  Result := FItems.Count;
end;

end.
