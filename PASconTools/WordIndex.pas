(*

  TSearchStringList - binary search & incrementelle & "Pos=1" search
  TExtendedList - "AND" "OR" -able persistent List
  TWordIndex - Full text persistent search object
  TsTable - Persistent string table (CSV-Objekt)

  Copyright (C) 2007 - 2024  Andreas Filsinger

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.

  https://wiki.orgamon.org/

*)
unit WordIndex;

{$ifdef fpc}
{$mode objfpc}{$H+}
{$endif}

interface

uses
  Classes, Contnrs,
  math, gplists;

const
  WordIndexVersion: single = 1.031; // ..\rev\WordIndex.rev.txt
  c_st_DefaultSeparator    = ';';
  c_wi_FileExtension       = '.Suchindex';
  c_wi_RID_Suche           = 'RID'; // "RID" n [ { "," n } ]
  c_sT_SecuredHashSubDir   = 'hash\';
  sRID_NULL                = '<NULL>';

type
  TSearchStringList = class(TStringList)
    function FindNear(const SearchStr: string): integer;
    function FindInc(const SearchStr: string): integer;
    function FindPos(const SearchStr: string): integer;
    procedure IncRef(Index: integer);
    procedure SaveToFileWithReferences(const FName: string);
    function EnsureValues(ValueList: TStrings; RemoveUnknown: boolean = true): boolean;
    function Find(const SearchStr: string): TgpIntegerList;
  end;

type
  TExtendedList = class(TList)
    procedure LogicalOR(L: TList);
    procedure LogicalAND(L: TList);
    procedure SaveToFile(var f: file); overload;
    procedure LoadFromFile(var f: file); overload;
    procedure SaveToFile(FName: string); overload;
    procedure LoadFromFile(FName: string); overload;
    function AsString: string;

    constructor Create;
    destructor Destroy; override;
  end;

  function ExtendedListSortCompare (Item1, Item2: Pointer) : Integer;

type
  TWordIndex = class(TStringList)

    //
    // 1) ein String mit vielen Suchbegriffen wird zusammen mit einem (Integer)RID
    //    per AddWords(S,RID) übergeben. 1 AddWords pro Datensatz
    // 2) per JoinDuplicates wird der eigentliche Suchindex aufgebaut.
    //    Dieser Aufruf führt dazu dass alle Objects[] der Liste auf eine
    //    Liste der Vorkommen von einzelnen Worten umgestellt wird. Erst
    //    danach ist "SaveToFile" oder "SaveToDiagfile" erlaubt.
    // 3) Nun kann mit "Search(S)" in der Liste gesucht werden, dabei
    //    wird die Ergebnisliste "FoundList" gefüllt mit einer Liste aus
    //    RIDs. Also die Datensätze befinden sich in der Liste die passend
    //    zu allen Suchworten sind (UND - Logik)
    //
  protected
     {$ifdef FPC}
     Function DoCompareText(const s1,s2 : string) : PtrInt; override;
     {$endif}


  private
    pMinWordLenght: integer;
    LastFileAge: TDateTime;
    LastChecked: LongWord;
    AllF: TextFile;
    DumpMode: boolean;

    // Am Anfang sind die Objects[] RIDs (ObjectsAreLists=false)
    // Später sind die Objects TExentedLists mit den RIDs als Elemente
    ObjectsAreLists: Boolean;

    procedure ClearTheList;

  public
    LastFileName: string;
    Version: Integer; // File-Version der aktuell geladenen Version
    FoundList: TExtendedList;
    S_WordDuplicates: integer;
    S_GlobalClones: integer;
    S_LocalClones: integer;
    OptionDiagFile_IncludeCount: boolean;
    Generation: integer;

    constructor Create(Mother: TStringList; MinWordLenght: word = 2; SearchDelimiter: string = '');
    destructor Destroy; override;
    procedure Search(s: string);
    procedure SaveToFile(const FName: string); override;
    procedure LoadFromFile(const FName: string); override;
    function ReloadIfNew: boolean;
    procedure SaveToDiagFile(FName: string); overload;
    procedure SaveToDiagFile(FName: string; MinSubElementCount, MaxSubElementCount: integer); overload;
    procedure SaveToDiagFile(OutF: TStrings); overload;

    //
    procedure AddWords(BigWordStr: String; RID: TObject);

    //
    // LookForClones: muss gesetzt werden wenn ein einzelner
    // Datensatz ev 2 identische Trefferworte
    // enthalten kann. Dann muss sichergestellt
    // werden dass diese "Clones" entfernt werden.

    // Beispiel: "Welt Gruppe Welt Klartext" -> "Welt" führt zu 2
    // Treffern, aber aus dem selben Datensatzes, also Clones, somit muss
    // LookForClones gesetzt werden.
    //
    procedure JoinDuplicates(LookForClones: boolean);
    procedure Filter(sFilter: string; MaxLength: integer);
    function Words: string;
    procedure Dump(FileName: String);

    // Char-Austausch in Vorbereitung fürs ASCII-Sortieren
    //  Á->A
    class function AsTranslate(s: string): string;

    // ein um alle White-Spaces reduzierter String
    // in Vorbereitung vor "addwords". Dies garantiert
    // dass ressult als einzelnes Wort in den Suchindex
    // aufgenommen wird.
    class function AsOneWord(s: string): string;

    // wie es im Index gespeichert ist
    // Upper+Translate+Filter(0..9,A..Z,#)
    class function AsIndex(s: string): string;

    // ein um unnötige Zeichen erleichterer String
    // entfernt sogar den Punkt, trennt aber alle Worte
    // durch <SPACE>
    class function AsWords(s: string): string;

    // ein um unnötige Zeichen erleichterer String jedoch
    // wird '.' belassen und nicht durch <SPACE>
    // ersetzt
    class function AsWordsDot(s: string): string;

  end;

  eTsCompareType = (TsIdentical, TsIgnoreLeadingZeros);
  TsTable = class(TObjectList)
    // Eine CSV-Tabelle im Speicher
    // Anzahl der Datensätze: RowCount = pred(count)
    // Row = 1..pred(count) : die Datenzeilen, alias:
    // Row = 1..RowCount : die Datenzeilen
    // Col = 0..pred(header.count) : die Datenspalten
    //
    // interne Organisation
    // Tlist = array of TStringList ~ eine Zeile = eine Row
    // TList[13][2] -> Zelle der "Zeile 13" "Spalte 3"
    Changed: boolean;

    // Options
    oNoblank: boolean; // noblank to all the cells on "load"
    oDistinct: boolean; // sort and remove duplicates on "load"
    oNoAutoQuote: boolean; // do NOT remove all the Quotes  ;"aaa"; -> ;aaa;
    oNoClipColums: boolean; // do NOT clip additional Columns on load
    oSeparator: string; // Trenner zwischen den Spalten
    oSalt: string; // Ensure a Salt-Value on load/save
    oMD5: string; // The MD5(data+Salt)
    oHTML_Prefix: string;
    oHTML_Postfix: string;

    function getSeparator: string;
    procedure insertFromFile(FName: string; StaticHeader: string = '');
    procedure insertFromHash(Path, FName : string; StaticHeader: string = '');
    procedure insertFromStrings(sl: TStrings);
    procedure SaveToFile(FName: string);
    procedure SaveToHTML(FName: string; sFormats: TStringList = nil);
    procedure Del(Row: integer = -1); // delete Row
    procedure Rem(Col: integer = -1); // remove Col
    function header: TStringList;
    function data: TStringList;
    function locate(Col: integer; sValue: string): integer; overload; // [row]
    function locate(Col: string; sValue: string): integer; overload; // [row]
    function locateDuplicates(Col: integer; sValue: string; CompareType: eTsCompareType = TsIdentical): TgpIntegerList;
    // [array of row]

    // Search for "sValue" in Col, starting at Row, return first Hit!
    function next(Row, Col: integer; sValue: string): integer; overload; // [row]
    function next(Row: integer; Col, sValue: string): integer; overload; // [row]

    // lesender Zugriff auf ein Feld, einfach '' wenn Spalte nicht existiert
    function readCell(Row, Col: integer): string; overload;
    function readCell(Row: integer; Col: string): string; overload;

    // schreibender Zugriff auf ein Feld
    procedure writeCell(Row, Col: integer; s: string); overload;
    procedure writeCell(Row: integer; Col: string; s: string); overload;

    // Feld := Feld+s
    procedure concatCell(Row, Col: integer; s: string); overload;
    procedure concatCell(Row: integer; Col: string; s: string); overload;

    // inc(numeric(Feld))
    procedure incCell(Row, Col: integer); overload;
    procedure incCell(Row: integer; Col: string); overload;

    // aggregate, must be sorted
    procedure aggregate(Col: string); overload;
    procedure aggregate(Col: Integer); overload;

    procedure SortBy(sFields: TStrings); overload;
    procedure SortBy(sFields: String); overload;

    function isHeader(HeaderName: string): boolean;
    function colOf(HeaderName: string; RaiseIfNotExists: boolean = false): integer;
    function addCol(HeaderName: string; DefaultValue: string = ''): integer; overload;
    function addCol(HeaderName: string; Values: TStringList): integer; overload;
    function Col(c: integer): TStringList; overload;
    function Col(HeaderName: String): TStringList; overload;
    function readRow(r: integer): TStringList;

    // Spaltensumme
    function sumCol(HeaderName: string): double;
    // MD5 Prüfsumme
    function md5: string;

    // Ergänzungsfunktion: Schlage einen Wert in einer anderen Tabelle nach
    procedure BlowUp(SearchCol: string; FName: string; ExtCol: string);

    // Ersetze in einem String alle Spaltenwerte
    procedure ersetze(Row: integer; var s: string);

    // ACHTUNG: r darf nach addRow nicht freigegeben werden
    function addRow(r: TStringList = nil): integer;
    function RowCount: integer;
    function distinct(c: string) : Integer; overload;
    function distinct(c: Integer) : Integer; overload;
    function ColCount: integer;

    constructor Create; virtual;
    destructor Destroy; override;
  end;

function ParameterValid(a, b: string): boolean;
function Distinct(s: string): string;
procedure SaveToFileCSV(s:TStringList; FName: string; Header : string = '');
procedure AddTableHash(FName: string; salt : string);
function AddTableHashFName(FName: String): String;

implementation

uses
  {$ifdef fpc}
  fpchelper,
  {$endif}
{$IFNDEF CONSOLE}
  Dialogs,
  WinApi.Windows,
{$ENDIF}
  SysUtils, Anfix, html,
  // imp pend: migrate to DCPCrypt
  IdGlobal, IdHash, IdHashMessageDigest;

const
  cTWordIndex_File_Tag: integer = (ord('T') shl 0) + (ord('W') shl 8) + (ord('I') shl 16) + (26 shl 24);

  // ANSI_8859_15 Zeichen ...
  c_wi_TranslateFrom       = #$7E#$DF#$C4#$CB#$D6#$DC#$C1#$C0#$C9#$C8+
                             #$DA#$D9#$D3#$CD#$CA#$C7#$C5#$D4#$D1#$D8+
                             #$DD#$A6#$D2#$C6#$D5#$C2#$CE;
  //                         '~ßÄËÖÜÁÀÉÈÚÙÓÍÊÇÅÔÑØÝŠÒÆÕÂÎ'

  // ... und deren Mapping fürs Sortieren
  c_wi_TranslateTo         = '#SAEOUAAEEUUOIECAONOYSOAOAI';

  // Zeichen die im Index verwendet werden
  c_wi_ValidCharsIntern    = '#0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  c_wi_ValidCharsSearch    = ' .' + c_wi_ValidCharsIntern;

  // WhiteSpace Character führen
  // zum Auftrennen von Worten also
  // aa%bb wird zu aa bb, also mit
  // einem echten Space-Character(#$20)!
  c_wi_WhiteSpace_noblank  = '_()*+-:&§",/!?=;<>#{}$%''`^[]' + #$0D;
  c_wi_WhiteSpace_Dot      = '.' + c_wi_WhiteSpace_noblank;
  c_wi_WhiteSpace_All      = ' ' + c_wi_WhiteSpace_Dot;

type
  TBinaereSucheResult = (BS_Found, BS_NotFound, BS_SimilarFound);

{$ifdef FPC}
//
// result := s1 - s2  (String Distance)
//
// A - A = 0                    (equal)
// B - A = 1                    (s1>s2)
// A - B = -1                   (s1<s2)
// <EMPTY> - <EMPTY> = 0        (s1=s2)
// <EMPTY> - * = -1             (s1<s2)
// * - <EMPTY> = 1              (s1>s2)
// AA - AAA = -1                (s1<s2)
// AAA - AA = 1                 (s1>s2)
//

function TWordIndex.DoCompareText(const s1, s2: string): PtrInt;
var
 l1,l2,n: PtrInt;
begin
  // store sizes, they matters
  l1 := length(s1);
  l2 := length(s2);

  // if l1=0 or l2=0 or l1=l2=0, this loop is never entered!
  for n := 1 to min(l1,l2) do
  begin
    result := ord(s1[n]) - ord(s2[n]);
    if (result<>0) then
     exit;
  end;

  // if we finally get here, pos(s1,s2)=1 or pos(s2,s1)=1 so let the length decide
  // if both are equal, we get "0" wich is good
  result := l1 - l2;
end;
{$endif}

class function TWordIndex.AsTranslate(s: string): string;
var
 i,k : Integer;
begin
  result := s;
  for i := 1 to length(result) do
  begin
    k := pos(result[i], c_wi_TranslateFrom);
    if (k > 0) then
      result[i] := c_wi_TranslateTo[k];
  end;
end;

class function TWordIndex.AsIndex(s: string): string;
var
  i, k: integer;
begin
  result := ANSI_upper(s);
  for i := 1 to length(result) do
  begin
    k := pos(result[i], c_wi_TranslateFrom);
    if (k > 0) then
      result[i] := c_wi_TranslateTo[k];
  end;
  result := StrFilter(s, c_wi_ValidCharsIntern);
end;

class function TWordIndex.AsWords(s: string): string;
var
  n: integer;
begin
  result := s;
  // Alle Sonderzeichen werden Blank (=Wort-Trenner)
  for n := 1 to length(s) do
    if (pos(s[n], c_wi_WhiteSpace_Dot) > 0) then
      result[n] := ' ';

  // "unechte" Wort-trenner entfernen
  repeat
    n := pos(#32#32, result);
    if (n = 0) then
      break;
    system.delete(result, n, 1);
  until eternity;

  // Blanks am Anfang und am Ende löschen
  result := cutblank(result);
end;

class function TWordIndex.AsWordsDot(s: string): string;
var
  n: integer;
begin
  result := s;
  // Alle Sonderzeichen werden Blank (=Wort-Trenner)
  for n := 1 to length(s) do
    if (pos(s[n], c_wi_WhiteSpace_noblank) > 0) then
      result[n] := ' ';

  // "unechte" Wort-trenner entfernen
  repeat
    n := pos(#32#32, result);
    if (n = 0) then
      break;
    system.delete(result, n, 1);
  until eternity;

  // Blanks am Anfang und am Ende löschen
  result := cutblank(result);
end;

class function TWordIndex.AsOneWord(s: string): string;
begin
  result := StrFilter(s, c_wi_WhiteSpace_All);
end;

constructor TWordIndex.Create(Mother: TStringList; MinWordLenght: word; SearchDelimiter: string);
var
  n, k: integer;
begin
  inherited Create;
  pMinWordLenght := MinWordLenght;
  FoundList := TExtendedList.Create;
  if assigned(Mother) then
  begin
    BeginUpdate;
    if (SearchDelimiter = '') then
    begin
      for n := 0 to pred(Mother.Count) do
        AddWords(Mother[n], Mother.Objects[n]);
    end
    else
    begin
      for n := 0 to pred(Mother.Count) do
      begin
        k := pos(SearchDelimiter, Mother[n]);
        if (k = 0) then
          AddWords(Mother[n], Mother.Objects[n])
        else
          AddWords(system.copy(Mother[n], 1, pred(k)), Mother.Objects[n]);
      end;
    end;
    JoinDuplicates(true);
    EndUpdate;
  end;
end;

procedure TWordIndex.AddWords(BigWordStr: String; RID: TObject);
var
  Candidates: TStringList;
  OneWord: string;
begin
 BigWordStr := AsWords(BigWordStr);
 BigWordStr := ANSI_upper(BigWordStr);
 BigWordStr := AsTranslate(BigWordStr);
 Candidates := TStringList.Create;
 try
   repeat
     // Word by Word into the Index
     OneWord := nextp(BigWordStr,' ');
     if (OneWord='') then
      break;
     // Last Stage: Only valid Chars #+0..9+A..Z
     OneWord := StrFilter(OneWord,c_wi_ValidCharsIntern);

     if (length(OneWord)<pMinWordLenght) then
      continue;

     Candidates.AddObject(OneWord, RID);
     if DumpMode then
      writeln(AllF, OneWord, ';', PtrUInt(RID));

   until eternity;

   if (Candidates.Count > 1) then
   begin
     Candidates.Sort;
     inc(S_LocalClones, removeduplicates(Candidates));
   end;
   AddStrings(Candidates);
 finally
   Candidates.free;
 end;
end;

procedure TWordIndex.JoinDuplicates(LookForClones: boolean);
var
  AddIndex: Integer;
  ChkIndex: Integer;
  ReferenceList: TExtendedList;
  RID: PtrUInt;
begin
  if DumpMode then
  begin
    CloseFile(AllF);
    DumpMode := false;
  end;

  if (Count > 0) then
  begin

    BeginUpdate;
    Sort;

    AddIndex := pred(Count);
    while true do
    begin

      // neues Wort anfangen, auf alle Fälle dieses mit
      // aktuellen RID anfügen!
      ReferenceList := TExtendedList.Create;
      ReferenceList.add(pointer(Objects[AddIndex]));
      Objects[AddIndex] := ReferenceList;

      ChkIndex := pred(AddIndex);
      if (ChkIndex < 0) then
        break;
      while true do
      begin

        if (strings[AddIndex] = strings[ChkIndex]) then
        begin

          // A double entry was found
          inc(S_WordDuplicates);

          RID := PtrUInt(Objects[ChkIndex]);
          with ReferenceList do
          begin
            // check possibility of locale Clones
            if LookForClones and (Count > 1) then
            begin
              if (indexof(Pointer(RID)) = -1) then
                add(Pointer(RID))
              else
                inc(S_GlobalClones); // double words inside same row
            end
            else
            begin
              // Store the reference
              add(Pointer(RID));
            end;
          end;

          // But delete the double entry
          delete(ChkIndex);
          dec(ChkIndex);
          if (ChkIndex < 0) then
            break;
          dec(AddIndex);
        end
        else
        begin
          break;
        end;

      end;
      ReferenceList.Sort(@ExtendedListSortCompare);
      if (ChkIndex < 0) then
        break;
      AddIndex := ChkIndex;

    end;
    EndUpdate;
  end;
  {
    for ChkIndex := 1 to pred(count) do
    if strings[pred(ChkIndex)]>=strings[ChkIndex] then
    ShowMessage(format('Fehler! %s>=%s',[strings[pred(ChkIndex)],strings[ChkIndex]]));
  }
  ObjectsAreLists := true;
  if DebugMode then
   SaveToDiagFile(DebugLogPath+'Join.txt');
end;

procedure TWordIndex.ClearTheList;
var
  n: integer;
begin
  for n := 0 to pred(Count) do
  begin
    Objects[n].free;
    Objects[n] := nil;
  end;
  ObjectsAreLists := false;
end;

destructor TWordIndex.Destroy;
begin
  ClearTheList;
  FoundList.free;
  inherited Destroy;
end;

procedure TWordIndex.Filter(sFilter: string; MaxLength: integer);
var
  n: integer;
  s: string;
begin
  for n := pred(Count) downto 0 do
  begin
    s := StrFilter(strings[n], sFilter);
    if (s = '') or (length(s) > MaxLength) then
      delete(n)
    else
      strings[n] := s;
  end;
end;

procedure TWordIndex.SaveToFile(const FName: string);
var
  OutF: file;
  n, m: integer;
  ItemList: TList;
  _ListCount: integer;
  _StrLen: integer;
  _refNo: integer;
  StartTime: longword;
  FirstTime: boolean;
  Temp: AnsiString;
begin
  //
  AssignFile(OutF, FName + cTmpFileExtension);
  rewrite(OutF, 1);

  // 1. Integer: "TWI" & ^Z
  BlockWrite(OutF, cTWordIndex_File_Tag, sizeof(integer));

  // 2. Integer: ~TWordIndex~ Version
  if TestMode then
   Version := $FFFFFFFF
  else
   Version := round(WordIndexVersion * 1000);
  BlockWrite(OutF, Version, sizeof(integer));

  // 3. Integer: pMinWordLength
  BlockWrite(OutF, pMinWordLenght, sizeof(integer));

  // 4. Integer: Anzahl der Elemente
  _ListCount := Count;
  BlockWrite(OutF, _ListCount, sizeof(integer));

  // 5. Alle Elemente
  //
  // 5.1 Integer: Anzahl der RIDs
  // 5.2 Integer, Integer, ...: die RIDs
  // 5.3 Integer: String-Länge
  // 5.4 Byte-Array 1..String-Länge
  for n := 0 to pred(Count) do
  begin
    ItemList := TList(Objects[n]);
    _ListCount := ItemList.Count;
    BlockWrite(OutF, _ListCount, sizeof(integer));
    for m := 0 to pred(ItemList.Count) do
    begin
      _refNo := integer(ItemList[m]);
      BlockWrite(OutF, _refNo, sizeof(integer));
    end;
    _StrLen := length(strings[n]);
    BlockWrite(OutF, _StrLen, sizeof(integer));
    if _StrLen > 0 then
    begin
      Temp := strings[n];
      BlockWrite(OutF, PAnsiChar(Temp)^, _StrLen);
    end;
  end;
  CloseFile(OutF);

  StartTime := Frequently;
  FirstTime := true;
  repeat
    if not(FirstTime) then
    begin
      sleep(100);
      if Frequently(StartTime, 10000) then
        break;
    end
    else
    begin
      FirstTime := false;
    end;
    if FileExists(FName) then
    begin
      if not(DeleteFile(FName)) then
        continue;
    end;
    if not(renameFile(FName + cTmpFileExtension, FName)) then
      continue;
  until yet;

  FileAge(FName, LastFileAge);
end;

procedure TWordIndex.LoadFromFile(const FName: string);
var
  InF: file;
  n, m: integer;
  _ListCount: integer;
  _SubCount: integer;
  _StrLen: integer;
  _refNo: integer;
  _FSize: integer;
  SubItems: TExtendedList;
  InpStr: AnsiString;
  ReadP: pointer;
  _ReadP: pointer;
begin
  if FileExists(FName) then
  begin
    BeginUpdate;
    FileAge(FName, LastFileAge);
    LastFileName := FName;

    ClearTheList;
    clear;

    // gleichzeitiger Start mehrerer OrgaMons kommt vor!
    FileMode := fmOpenRead or fmShareDenyWrite;
    AssignFile(InF, FName);
    reset(InF, 1);
    _FSize := FileSize(InF);
    GetMem(ReadP, _FSize);
    _ReadP := ReadP;
    // page into RAM!!
    Blockread(InF, ReadP^, _FSize);
    CloseFile(InF);
    FileMode := fmOpenReadWrite;

    // Evaluate Version
    _ListCount := PInteger(ReadP)^;
    {$ifdef FPC}
    inc(ReadP, 4);
    {$else}
    inc(integer(ReadP), 4);
    {$endif}
    if (_ListCount = cTWordIndex_File_Tag) then
    begin
      Version := PInteger(ReadP)^;
      inc({$ifndef FPC}integer{$endif}(ReadP), 4);
      pMinWordLenght := PInteger(ReadP)^;
      inc({$ifndef FPC}integer{$endif}(ReadP), 4);
      _ListCount := PInteger(ReadP)^;
      inc({$ifndef FPC}integer{$endif}(ReadP), 4);
    end;

    capacity := _ListCount;
    for n := 0 to pred(_ListCount) do
    begin
      _SubCount := PInteger(ReadP)^;
      inc({$ifndef FPC}integer{$endif}(ReadP), 4);
      SubItems := TExtendedList.Create;
      SubItems.capacity := _SubCount;
      for m := 0 to pred(_SubCount) do
      begin
        _refNo := PInteger(ReadP)^;
        inc({$ifndef FPC}integer{$endif}(ReadP), 4);
        SubItems.add(Pointer(_refNo));
      end;
      _StrLen := PInteger(ReadP)^;
      inc({$ifndef FPC}integer{$endif}(ReadP), 4);
      SetLength(InpStr, _StrLen);
      if (_StrLen > 0) then
        system.move(ReadP^, InpStr[1], _StrLen);
      inc({$ifndef FPC}integer{$endif}(ReadP), _StrLen);
      AddObject(InpStr, SubItems);
    end;
    FreeMem(_ReadP, _FSize);
    ObjectsAreLists := true;

    EndUpdate;
  end;
end;

function TWordIndex.ReloadIfNew: boolean;
var
 _LastFileAge: TDateTime;
begin
  result := false;
  if (LastFileName <> '') then
    if Frequently(LastChecked, 10000) then // 10 Sec
    begin
      FileAge(LastFileName, _LastFileAge);
      if (_LastFileAge > LastFileAge) then
      begin
        LoadFromFile(LastFileName);
        result := true;
      end;
    end;
end;

procedure TWordIndex.SaveToDiagFile(FName: string; MinSubElementCount, MaxSubElementCount: integer);
var
  n, m: integer;
  OutStr: string;
  OutF: TStringList;
  TheList: TList;
begin
 OutF := TStringList.Create;
 if ObjectsAreLists then
 begin
  for n := 0 to pred(Count) do
  begin
    TheList := TList(Objects[n]);
    if assigned(TheList) then
      if (TheList.Count >= MinSubElementCount) then
      begin
        OutStr := '"' + strings[n] + '"' + ' ';
        if OptionDiagFile_IncludeCount then
          OutStr := OutStr + '[' + inttostr(TheList.Count) + '] ';
        for m := 0 to min(pred(TheList.Count), pred(MaxSubElementCount)) do
          OutStr := OutStr + inttostr(PtrUInt(TheList[m])) + ' ';
        if (TheList.Count > MaxSubElementCount) then
          OutStr := OutStr + '... (' + inttostr(TheList.Count) + 'x)';
        OutF.add(OutStr);
      end;
  end;
 end else
 begin
  for n := 0 to pred(Count) do
   OutF.add (inttostr(PtrUint(Objects[n])) + ';' + strings[n]);
 end;
 OutF.SaveToFile(FName);
 OutF.free;
end;

procedure TWordIndex.SaveToDiagFile(OutF: TStrings);
var
  TheList: TList;
  n, m: integer;
  RIDs: string;
begin
 if ObjectsAreLists then
 begin
  for n := 0 to pred(Count) do
  begin
    TheList := TList(Objects[n]);
    RIDs := '';
    for m := 0 to pred(TheList.Count) do
      RIDs := RIDs + ';' + inttostr(PtrUInt(TheList[m]));
    OutF.add(inttostrN(TheList.Count, 8) + ';' + strings[n] + RIDs + ':');
  end;
 end else
 begin

 end;
end;

procedure TWordIndex.SaveToDiagFile(FName: string);
begin
  SaveToDiagFile(FName, 1, MaxInt);
end;

procedure TWordIndex.Search(s: string);
var
  k: integer;
  ExactWord: boolean;
  ActSearchStr: string;
  FoundIndex: integer;
  FirstTime: boolean;
  SubResult: TExtendedList;
  CompareResult: integer;

  function BinaereSuche(SearchStr: string; out m: integer): TBinaereSucheResult;
  var
    s, e: integer;
  begin

    if Count = 0 then
    begin
      result := BS_NotFound;
      exit;
    end;

    s := 0;
    e := pred(Count);
    while (s < e) do
    begin
      // bestimme das mittlere Element
      // m := s + ((e - s) div 2);
      m := (s + e) shr 1;

      // vergleiche mit diesem Element
      {$ifdef FPC}
      CompareResult := DoCompareText(strings[m], SearchStr);
      {$else}
      CompareResult := AnsiCompareText(strings[m], SearchStr);
      {$endif}

      //
      if (CompareResult < 0) then
      begin
        s := succ(m);
      end
      else
      begin
        if (CompareResult > 0) then
        begin
          e := pred(m);
        end
        else
        begin
          // wow Identität, nix wie raus
          result := BS_Found;
          exit;
        end;
      end;
    end;

    // s==e !!!

    // Ist das Wort eigentlich OK?
    m := s;
    if (SearchStr = strings[m]) then
    begin
      result := BS_Found;
      exit;
    end;

    if ExactWord then
    begin
      result := BS_NotFound;
      exit;
    end;

    result := BS_SimilarFound;

    if pos(SearchStr, strings[m]) = 1 then
      exit;

    // nicht so ganz gefunden, eins nach oben gucken!
    if (pred(m) >= 0) then
    begin
      if pos(SearchStr, strings[pred(m)]) = 1 then
      begin
        m := pred(m);
        exit;
      end;
    end;

    // nicht so ganz gefunden, eins nach unten gucken!
    if (succ(m) < Count) then
    begin
      if pos(SearchStr, strings[succ(m)]) = 1 then
      begin
        m := succ(m);
        exit;
      end;
    end;

    result := BS_NotFound;
  end;

begin
  FoundList.clear; // TList
  if (pos(c_wi_RID_Suche, s) = 1) then
  begin
    nextp(s, c_wi_RID_Suche);
    while (s <> '') do
      FoundList.add(pointer(strtol(nextp(s, ','))));
  end
  else
  begin
    SubResult := TExtendedList.Create;
    FirstTime := true;

    s := AsWordsDot(s);  // *-><SPACE>
    s := ANSI_upper(s);  // a->A
    s := AsTranslate(s); // Á->A

    // ok sind nur noch: 0..9,A..Z,' ','.'
    s := StrFilter(s, c_wi_ValidCharsSearch);

    // nun nach allen einzelnen Worten suchen!
    while true do
    begin

      k := pos(' ', s);
      if (k = 0) then
      begin
        ActSearchStr := s;
        s := '';
      end
      else
      begin
        ActSearchStr := system.copy(s, 1, pred(k));
        system.delete(s, 1, k);
      end;

      if (length(ActSearchStr) >= pMinWordLenght) then
      begin

        SubResult.clear;

        ExactWord := (ActSearchStr[length(ActSearchStr)] = '.');
        if ExactWord then
          system.delete(ActSearchStr, length(ActSearchStr), 1);

        case BinaereSuche(ActSearchStr, FoundIndex) of
          BS_SimilarFound, BS_Found:
            begin
              while pos(ActSearchStr, strings[FoundIndex]) = 1 do
              begin
                SubResult.LogicalOR(TList(Objects[FoundIndex]));
                if ExactWord then
                  break; // nicht mehr weiter suchen
                inc(FoundIndex);
                if (FoundIndex = Count) then
                  break;
              end;
            end;
          BS_NotFound:
            ;
        end;

        if FirstTime then
        begin
          FoundList.LogicalOR(SubResult);
          FirstTime := false;
        end
        else
        begin
          FoundList.LogicalAND(SubResult);
        end;

      end;

      if (s = '') then
        break;
    end;
    SubResult.free;
  end;
end;

function TWordIndex.Words: string;
begin
  result := HugeSingleLine(self, ' ');
end;

procedure TWordIndex.Dump(FileName: String);
begin
 if not(DumpMode) then
 begin
   AssignFile(AllF,FileName);
   rewrite(AllF);
   {$ifdef FPC}
   SetTextLineEnding(AllF,#$0A);
   {$endif}
   DumpMode := true;
 end;
end;

// =============
// TExtendedList
// =============

function ExtendedListSortCompare (Item1, Item2: Pointer) : Integer;
begin
  result := CompareValue( PtrUInt(Item1), PtrUInt(Item2) );
end;

procedure TExtendedList.LogicalOR(L: TList);
var
  n: integer;
begin
  for n := 0 to pred(L.Count) do
    if (indexof(L[n]) = -1) then
      add(L[n]);
end;

procedure TExtendedList.LogicalAND(L: TList);
var
  n: integer;
begin
  if (L.Count = 0) then
  begin
    clear;
  end
  else
  begin
    for n := 0 to pred(Count) do
      if (L.indexof(Items[n]) = -1) then
        Items[n] := nil;
    pack;
  end;
end;

procedure TExtendedList.SaveToFile(var f: file);
begin
  BlockWrite(f, Count, sizeof(integer));
  BlockWrite(f, List[0], sizeof(pointer) * Count);
end;

procedure TExtendedList.LoadFromFile(var f: file);
var
  _count: integer;
begin
  Blockread(f, _count, sizeof(integer));
  Count := _count;
  Blockread(f, List[0], Count * sizeof(pointer));
end;

function TSearchStringList.EnsureValues(ValueList: TStrings; RemoveUnknown: boolean = true): boolean;

  procedure EnsureEntry(EntryName: string; var OneChanged: boolean);
  var
    n: integer;
    LineSettingFound: boolean;
  begin
    if (Values[EntryName] = '') then
    begin
      LineSettingFound := false;
      for n := 0 to pred(Count) do
        if pos(ANSI_upper(EntryName + '='), ANSI_upper(strings[n])) = 1 then
        begin
          LineSettingFound := true;
          break;
        end;
      if not(LineSettingFound) then
      begin
        OneChanged := true;
        Values[EntryName] := '';
        add(EntryName + '=');
      end;
    end;
  end;

var
  n: integer;

begin
  result := false;
  for n := 0 to pred(ValueList.Count) do
    EnsureEntry(ValueList[n], result);
end;

function TSearchStringList.Find(const SearchStr: string): TgpIntegerList;
var
  k, l: integer;
begin
  result := TgpIntegerList.Create;
  k := indexof(SearchStr);
  if k <> -1 then
  begin
    result.add(PtrUInt(Objects[k]));
    for l := pred(k) downto 0 do
      if (SearchStr = strings[l]) then
        result.add(PtrUInt(Objects[l]))
      else
        break;
    for l := succ(k) to pred(Count) do
      if (SearchStr = strings[l]) then
        result.add(PtrUInt(Objects[l]))
      else
        break;
  end;
end;

function TSearchStringList.FindInc(const SearchStr: string): integer;
begin
  if (SearchStr = '') then
  begin
    for result := 0 to pred(Count) do
      if (strings[result] = '') then
        exit;
    result := -1;
  end
  else
  begin
    for result := 0 to pred(Count) do
      if pos(SearchStr, strings[result]) = 1 then
        exit;
    result := -1;
  end;
end;

function TSearchStringList.FindNear(const SearchStr: string): integer;
var
  sl, s, e, c: integer;
  CheckStr: string;
begin
  sl := length(SearchStr);
  s := 0;
  e := pred(Count);
  while (s <= e) do
  begin
    result := s + ((e - s) div 2); // bestimme das mittlere Element
    CheckStr := system.copy(strings[result], 1, sl);
    c := AnsiCompareStr(CheckStr, SearchStr);
    if (c = 0) then
      exit;
    if (c < 0) then
      s := succ(result)
    else
      e := pred(result);
  end;
  result := -1;
end;

function TSearchStringList.FindPos(const SearchStr: string): integer;
var
  n: integer;
begin
  result := -1;
  for n := 0 to pred(Count) do
    if (pos(SearchStr, strings[n]) > 0) then
    begin
      result := n;
      break;
    end;
end;

procedure TSearchStringList.IncRef(Index: integer);
begin
  Objects[Index] := TObject(PtrUInt(Objects[Index]) + 1);
end;

procedure TSearchStringList.SaveToFileWithReferences(const FName: string);
var
  n: integer;
  OutF: TextFile;
begin
  AssignFile(OutF, FName);
  rewrite(OutF);
  for n := 0 to pred(Count) do
    writeln(OutF, inttostr(PtrUInt(Objects[n])) + ';' + strings[n]);
  CloseFile(OutF);
end;

procedure TExtendedList.SaveToFile(FName: string);
var
  f: file;
begin
  AssignFile(f, FName);
  rewrite(f, sizeof(pointer));
  BlockWrite(f, List[0], Count);
  CloseFile(f);
end;

procedure TExtendedList.LoadFromFile(FName: string);
var
  f: file;
begin
  if FileExists(FName) then
  begin
    AssignFile(f, FName);
    reset(f, sizeof(pointer));
    Count := FileSize(f);
    Blockread(f, List[0], Count);
    CloseFile(f);
  end
  else
    clear;
end;

function ParameterValid(a, b: string): boolean;

begin
  // Strings bereinigen
  a := ANSI_upper(StrFilter(a, c_wi_WhiteSpace_noblank, ' '));
  ersetze('  ', ' ', a);
  b := ANSI_upper(StrFilter(b, c_wi_WhiteSpace_noblank, ' '));
  ersetze('  ', ' ', b);

  // Jedes el(a) mus mit el(b) übereinstimmen
  // Im Moment noch vereinfach, 1:1 UND 2:2 es sollte aber auch z.B.
  // 1:5 UND 2:10 UND 2:23 ein Treffer sein.
  result := true;
  repeat
    if (pos(nextp(a, ' '), nextp(b, ' ')) = 0) then
    begin
      result := false;
      break;
    end;
  until a = '';

end;

function TExtendedList.AsString: string;
var
  i: integer;
begin
  result := '';
  for i := 0 to pred(Count) do
    if i = 0 then
      result := inttostr(PtrUInt(Items[i]))
    else
      result := result + ',' + inttostr(PtrUInt(Items[i]));
end;

constructor TExtendedList.Create;
begin
  inherited;
end;

destructor TExtendedList.Destroy;
begin
  inherited Destroy;
end;

// =======
// TsTable
// =======

constructor TsTable.Create;
begin
  inherited Create(true);
end;

destructor TsTable.Destroy;
begin
  inherited Destroy;
end;

procedure TsTable.ersetze(Row: integer; var s: string);
var
  c: integer;
begin
  for c := 0 to pred(header.Count) do
  begin
    if pos('$', s) = 0 then
      break;
    Anfix.ersetze('$' + header[c], readCell(Row, c), s);
  end;
end;

function TsTable.getSeparator: string;
begin
  if (oSeparator <> '') then
    result := oSeparator
  else
    result := c_st_DefaultSeparator;
end;

procedure TsTable.writeCell(Row, Col: integer; s: string);
begin
  if (Col >= 0) then
    if (TStringList(Items[Row])[Col]<>s) then
    begin
      TStringList(Items[Row])[Col] := s;
      Changed := true;
    end;
end;

procedure TsTable.writeCell(Row: integer; Col: string; s: string);
begin
  writeCell(Row, colOf(Col), s);
end;

procedure TsTable.concatCell(Row, Col: integer; s: string);
begin
  if (Col >= 0) and (s<>'') then
  begin
    TStringList(Items[Row])[Col] := TStringList(Items[Row])[Col] + s;
    Changed := true;
  end;
end;

procedure TsTable.concatCell(Row: integer; Col: string; s: string);
begin
  concatCell(Row, colOf(Col), s);
end;

procedure TsTable.Del(Row: integer);
var
  n: integer;
begin
  if (Row = -1) then
  begin
    if (RowCount > 0) then
      Changed := true;

    for n := pred(Count) downto 1 do
      delete(n);
  end
  else
  begin
    delete(Row);
    Changed := true;
  end;
end;

function TsTable.isHeader(HeaderName: string): boolean;
begin
  result := colOf(HeaderName) <> -1;
end;

function TsTable.addCol(HeaderName: string; DefaultValue: string): integer;
var
  r: integer;
begin
  // auto generate a empty header line
  if (Count = 0) then
    add(TStringList.Create);

  result := colOf(HeaderName);
  if (result = -1) then
  begin
    result := header.Count;
    header.add(HeaderName);
    for r := 1 to pred(Count) do
     with Items[r] as TStringList do
      if (succ(result)>count) then // preserve already existing colums
       add(DefaultValue);
    Changed := true;
  end;
end;

function TsTable.addCol(HeaderName: string; Values: TStringList): integer;
var
  r: integer;
begin
  result := -1;
  if assigned(Values) then
  begin
    // auto generate a empty header line
    if (Count = 0) then
    begin
      add(TStringList.Create);
    end
    else
    begin
      // check if already exists
      result := colOf(HeaderName);
    end;

    // add Column
    if (result = -1) then
    begin
      result := header.Count;
      header.add(HeaderName);
      for r := 0 to pred(Values.Count) do
      begin
        if (r + 1 = Count) then
          add(TStringList.Create);
        TStringList(Items[r + 1]).add(Values[r]);
      end;
      Changed := true;
    end;
  end;
end;

function TsTable.sumCol(HeaderName: string): double;
var
  c, r: integer;
begin
  result := 0.0;
  c := colOf(HeaderName, true);
  for r := 1 to pred(Count) do
    result := result + StrToDoubleDef(TStringList(Items[r])[c], 0.0);
end;

function TsTable.addRow(r: TStringList): integer;
var
  NewRow: TStringList;
  n: integer;
begin
  if assigned(r) then
  begin
    // Sicherstellen dass genug Spalten vorhanden sind
    for n := r.Count to pred(header.Count) do
      r.add('');

    add(r);
  end
  else
  begin
    NewRow := TStringList.Create;
    for n := 0 to pred(header.Count) do
      NewRow.add('');
    add(NewRow);
  end;
  Changed := true;
  result := pred(Count);
end;

procedure TsTable.BlowUp(SearchCol, FName, ExtCol: string);
var
  b: TsTable;
  refCol, cB, rA, rB: integer;
begin
  b := TsTable.Create;
  b.insertFromFile(FName);
  for cB := 0 to pred(b.header.Count) do
    if (colOf(SearchCol + '.' + b.header[cB]) = -1) then
      addCol(SearchCol + '.' + b.header[cB]);
  refCol := colOf(SearchCol, true);
  for rA := 1 to RowCount do
  begin
    rB := b.locate(ExtCol, readCell(rA, refCol));
    if (rB <> -1) then
      for cB := 0 to pred(b.header.Count) do
        writeCell(rA, SearchCol + '.' + b.header[cB], b.readCell(rB, cB));
  end;
  b.free;
end;

function TsTable.Col(c: integer): TStringList;
var
  r: integer;
begin
  result := TStringList.Create;
  for r := 1 to pred(Count) do
  {$ifdef FPC}
    result.AddObject(TStringList(Items[r])[c], TObject(PtrUInt (r))); //64-Bit
  {$ELSE}
    result.AddObject(TStringList(Items[r])[c], TObject(UInt64 (r))); //32 Bit
  {$ENDIF}
end;

function TsTable.Col(HeaderName: String): TStringList;
var
 c : Integer;
begin
  c := colOf(HeaderName);
  if (c=-1) then
   result := nil
  else
   result := Col(c);
end;

function TsTable.ColCount: integer;
begin
  result := header.Count;
end;

function TsTable.colOf(HeaderName: string; RaiseIfNotExists: boolean = false): integer;
begin
  if (Count=0) then
   result := -1
  else
   result := header.indexof(HeaderName);
  if RaiseIfNotExists then
    if (result = -1) then
      raise Exception.Create('Spalte ' + HeaderName + ' nicht gefunden');
end;

function TsTable.data: TStringList;
var
  r: integer;
begin
  result := TStringList.Create;
  for r := 0 to pred(Count) do
    result.add(HugeSingleLine(TStringList(Items[r]), getSeparator));
end;

procedure TsTable.SaveToFile(FName: string);
var
  OutS: TStringList;
begin
  OutS := data;
  if (oSalt<>'') then
   OutS.Insert(0,md5);
  OutS.SaveToFile(FName{$ifdef fpc},TEncoding.ANSI{$endif});
  OutS.free;
end;

procedure TsTable.SaveToHTML(FName: string; sFormats: TStringList = nil);
const
  cPagebreak = '<div class="breakhere">&nbsp;</div>';
var
  r, c, col_PAPERCOLOR: integer;
  lastRow, lastCol: integer;
  OutS: TStringList;
  sRow: TStringList;
  tdExtras: string;
  tdData: string;
  tdPaperColor: string;
  tdFunction: array of boolean;
  JavaScript: string;
  _script, script : TStringList;
begin
  lastRow := pred(Count);
  col_PAPERCOLOR := colOf('PAPERCOLOR');
  lastCol := pred(ColCount);
  if (col_PAPERCOLOR = lastCol) then
    lastCol := pred(lastCol);

  setlength(tdFunction, ColCount);
  for c := 0 to pred(ColCount) do
   tdFunction[c] := false;

  OutS := TStringList.Create;
  with OutS do
  begin
    add('<!DOCTYPE html>');
    add('<html lang="de">');
    add('<head>');
    add('<meta charset="ISO-8859-1">');
    add('<meta http-equiv="Pragma" content="no-cache">');
    add('<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">');
    add('<meta http-equiv="Expires" content="0">');
    add('<style type="text/css">');
    add('.breakhere {page-break-before: always}');
    add('table.border {border-color:#000000; border-style:solid; border-width:0pt;}');
    add('td.gdef { border-color:#000000; border-style:solid; border-left-width:1pt; border-right-width:0pt; border-bottom-width:0pt; border-top-width:1pt; font-family:Verdana; font-size:-1; }');
    add('td.gend { border-color:#000000; border-style:solid; border-left-width:1pt; border-right-width:1pt; border-bottom-width:0pt; border-top-width:1pt; font-family:Verdana; font-size:-1; }');
    add('td.gfoot { border-color:#000000; border-style:solid; border-left-width:1pt; border-right-width:0pt; border-bottom-width:1pt; border-top-width:1pt; font-family:Verdana; font-size:-1; }');
    add('td.gright { border-color:#000000; border-style:solid; border-left-width:1pt; border-right-width:1pt; border-bottom-width:1pt; border-top-width:1pt; font-family:Verdana; font-size:-1; }');
    add('</style>');
    if assigned(sFormats) then
    begin
      // title
      add('<title>' + Ansi2HTML(sFormats.Values['TITEL']) + '</title>');

      // script
      script := TStringList.Create;
      for c := 0 to pred(ColCount) do
      begin
        JavaScript := sFormats.Values[Header[c]];
        if (JavaScript<>'') then
        begin
          tdFunction[c] := true;
          _script := split(JavaScript,'|');
          script.AddStrings(_script);
          _script.Free;
        end;
      end;
      if (script.Count>0) then
      begin
        add('<script>');
        addStrings(script);
        add('</script>');
      end;
      script.Free;

    end else
      add('<title>' + Ansi2HTML(ExtractFileName(FName)) + '</title>');

    add('</head>');
    add('<body bgcolor="#ffffff" text="#000000" link="#cc0000" vlink="#999999" alink="#ffcc00">');
    if (oHTML_Prefix <> '') then
      add(oHTML_Prefix);
    add('<font face="Verdana" size=2>');
    add('<table class=border cellpadding=1 cellspacing=0 border=1>');

    tdPaperColor := '';
    for r := 0 to lastRow do
    begin
      add(' <tr>');
      sRow := TStringList(Items[r]);

      if (col_PAPERCOLOR <> -1) then
        if (r > 0) then
        begin
          tdPaperColor := sRow[col_PAPERCOLOR];
          if (pos('#', tdPaperColor) = 1) then
            tdPaperColor := ' bgcolor="' + tdPaperColor + '"'
          else
            tdPaperColor := '';
        end;

      for c := 0 to pred(sRow.Count) do
      begin
        // Versteckte Spalte
        if (c = col_PAPERCOLOR) then
          continue;

        repeat
          if (r = lastRow) and (c = lastCol) then
          begin
            tdExtras := 'class=gright';
            break;
          end;

          if (c = lastCol) then
          begin
            tdExtras := 'class=gend';
            break;
          end;

          if (r = lastRow) then
          begin
            tdExtras := 'class=gfoot';
            break;
          end;

          // Im Falle des erfolgreichen Versuches könnte
          // hier das setzen der Class unterbleiben
          tdExtras := 'class=gdef';

        until yet;

        if (r = 0) then
          tdExtras := tdExtras + ' bgcolor="#C8D8E0"'
        else
          tdExtras := tdExtras + tdPaperColor;

        tdData := sRow[c];

        if (tdData = sRID_NULL) then
        begin
          tdExtras := tdExtras + ' bgcolor="#CCCCCC"';
          tdData := #160;
        end;

        if (tdData = '') then
          tdData := #160;

        if (tdExtras <> '') then
          tdExtras := ' ' + cutblank(tdExtras);

        if tdFunction[c] and (r>0) then
          add(
            { } '  <td' + tdExtras + '>' +
            { } '<script>'+TStringList(Items[0])[c]+'('+
            { } '''' + Ansi2HTML(tdData) + '''' +
            { } ');</script>'+
            { } '</td>')
        else
          add(
            { } '  <td' + tdExtras + '>' +
            { } Ansi2HTML(tdData) +
            { } '</td>');

      end;
      add(' </tr>');
    end;
    add('</table>');
    add('</font>');
    if (oHTML_Postfix <> '') then
      add(oHTML_Postfix);
    add('</body>');
    add('</html>');
    SaveToFile(FName);
  end;
  OutS.free;
end;

procedure TsTable.insertFromStrings(sl: TStrings);
var
  n, m: integer;
  Cols: TStringList;
  ThisHeader: string;
  SingleHeader: string;
  ThisData: string;
  ColAnzahl: integer;
  c, r: integer;
  //
  ColIndex: TgpIntegerList;
  HeaderL: TStringList;
  NewL: TStringList;

begin
  // clean Quoting entfernen
  if not(oNoAutoQuote) then
    if sl.Count > 1 then
      if (pos('"' + getSeparator, sl[0]) > 0) or (pos('"' + getSeparator, sl[1]) > 0) then
        Anfix.ersetze('"', '', sl);

  // Noblank aller Zeilen?!
  if oNoblank then
  begin
    for n := 0 to pred(sl.Count) do
      sl[n] := noblank(sl[n]);
  end;

  // distinct
  if oDistinct then
    if (sl.Count > 1) then
    begin
      ThisHeader := sl[0];
      sl.delete(0);
      if sl is TStringList then
        TStringList(sl).Sort;
      removeduplicates(sl);
      sl.Insert(0, ThisHeader);
    end;

  if (Count = 0) then
  begin
    // erste Tabelle einfach laden
    add(TStringList.Create);
    if (sl.Count > 0) then
    begin
      ThisHeader := sl[0];
      while (ThisHeader <> '') do
        TStringList(Items[0]).add(nextp(ThisHeader, getSeparator));
      ColAnzahl := TStringList(Items[0]).Count;
      for n := 1 to pred(sl.Count) do
      begin
        ThisData := sl[n];
        Cols := TStringList.Create;
        for m := 0 to pred(ColAnzahl) do
          Cols.add(nextp(ThisData, getSeparator));
        add(Cols);
      end;
    end;
  end
  else
  begin

    // weitere Tabellen spaltenkonform hinten dranhängen!
    if (sl.Count > 0) then
    begin

      ColIndex := TgpIntegerList.Create;
      HeaderL := header;
      ThisHeader := sl[0];
      while (ThisHeader <> '') do
      begin
        SingleHeader := nextp(ThisHeader, getSeparator);

        c := colOf(SingleHeader);
        if (c = -1) then
        begin
          // sDiagnose.add('+' + SingleHeader);
          HeaderL.add(SingleHeader);
          ColIndex.add(pred(HeaderL.Count));
        end
        else
        begin
          ColIndex.add(c);
        end;
        //
      end;

      for r := 1 to pred(sl.Count) do
      begin
        NewL := TStringList.Create;
        for c := 0 to pred(HeaderL.Count) do
          NewL.add('');
        c := 0;
        try
          ThisData := sl[r];
          while (ThisData <> '') do
          begin
            NewL[ColIndex[c]] := nextp(ThisData, getSeparator);
            inc(c);
            if (c >= ColIndex.Count) and (ThisData <> '') then
            begin
              // sDiagnose.add('Zeile: ' + JoinL[r]);
              // sDiagnose.add('WARNING: zu viele Felder. Rest: "'+ThisData+'"');
              break;
            end;
          end;
        except
          on e: Exception do
          begin
            // sDiagnose.add('Zeile: ' + JoinL[r]);
            // sDiagnose.add('ERROR: ' + e.message);
            break;
          end;
        end;

        add(NewL);
      end;

      ColIndex.free;
    end;
  end;
  Changed := false;
end;

procedure TsTable.incCell(Row, Col: integer);
begin
  if (Col >= 0) then
  begin
    TStringList(Items[Row])[Col] := inttostr(succ(StrToIntDef(TStringList(Items[Row])[Col], 0)));
    Changed := true;
  end;
end;

procedure TsTable.incCell(Row: integer; Col: string);
begin
  incCell(Row, colOf(Col));
end;

procedure TsTable.aggregate(Col: string);
begin
 aggregate(colOf(Col));
end;

procedure TsTable.aggregate(Col: Integer);
var
 r,c : Integer;
 s,d: String;
begin
 if (Col >= 0) then
  for r := RowCount downto 2 do
   if ReadCell(r,Col)=ReadCell(pred(r),Col) then
   begin
    for c := 0 to pred(header.count) do
     if (c<>Col) then
     begin
      s := readCell(r,c);
      repeat
        if (s='') then
         break;
        d := readCell(pred(r),c);
        if (d='') then
         writecell(pred(r),c,s)
        else
         writecell(pred(r),c,d+'+'+s); // or s+d ?
      until yet;
     end;
     Del(r);
   end;
end;

procedure TsTable.insertFromFile(FName: string; StaticHeader: string = '');
var
  n, m: integer;
  Cols: TStringList;
  ThisHeader: string;
  SingleHeader: string;
  ThisData: string;
  ColAnzahl: integer;
  SingleCol: boolean;
  JoinL: TStringList;
  c, r: integer;
  //
  ColIndex: TgpIntegerList;
  HeaderL: TStringList;
  NewL: TStringList;

begin

  JoinL := TStringList.Create;

  // csv laden
  LoadFromFileCSV(false, JoinL, FName);

  // md5-Hash sichern
  if (JoinL.Count>0) then
   if (length(JoinL[0])=32) then
    if (pos(getSeparator,JoinL[0])=0) then
    begin
      oMD5 := JoinL[0];
      JoinL.Delete(0);
    end;

  // Header hinzu?
  if (StaticHeader <> '') then
    JoinL.insert(0,StaticHeader);

  // Quoting entfernen, "xxx";3 -> xxx;3
  if not(oNoAutoQuote) then
  begin

    repeat
      if (JoinL.Count = 0) then
        break;
      SingleCol := (pos(getSeparator, JoinL[0]) = 0);

      if SingleCol then
        ThisData := '"'
      else
        ThisData := '"' + getSeparator;

      // Nur eine Headerzeile und sonst nix?
      if (JoinL.Count = 1) then
        if pos(ThisData, JoinL[0]) = 0 then
          break;

      if (pos(ThisData, JoinL[0]) = 0) and (pos(ThisData, JoinL[1]) = 0) then
        break;

      Anfix.ersetze('"', '', JoinL);

    until yet;
  end;

  // Noblank aller Zeilen?!
  if oNoblank then
  begin
    for n := 0 to pred(JoinL.Count) do
      JoinL[n] := noblank(JoinL[n]);
  end;

  // distinct
  if oDistinct then
    if (JoinL.Count > 1) then
    begin
      ThisHeader := JoinL[0];
      JoinL.delete(0);
      JoinL.Sort;
      removeduplicates(JoinL);
      JoinL.Insert(0, ThisHeader);
    end;

  if (Count = 0) then
  begin
    // erste Tabelle einfach laden
    add(TStringList.Create);
    if (JoinL.Count > 0) then
    begin
      ThisHeader := JoinL[0];
      while (ThisHeader <> '') do
        TStringList(Items[0]).add(nextp(ThisHeader, getSeparator));
      ColAnzahl := TStringList(Items[0]).Count;
      for n := 1 to pred(JoinL.Count) do
      begin
        ThisData := JoinL[n];
        Cols := TStringList.Create;
        for m := 0 to pred(ColAnzahl) do
          Cols.add(nextp(ThisData, getSeparator));
        if oNoClipColums then
         while (ThisData<>'') do
          Cols.add(nextp(ThisData, getSeparator));
        add(Cols);
      end;
    end;
    if (oSalt<>'') then
     if (md5<>oMD5) then
      raise Exception.Create('MD5 Prüfsumme falsch');
  end
  else
  begin

    // weitere Tabellen spaltenkonform hinten dranhängen!
    if (JoinL.Count > 0) then
    begin

      ColIndex := TgpIntegerList.Create;
      HeaderL := header;
      ThisHeader := JoinL[0];
      while (ThisHeader <> '') do
      begin
        SingleHeader := nextp(ThisHeader, getSeparator);

        c := colOf(SingleHeader);
        if (c = -1) then
        begin
          // sDiagnose.add('+' + SingleHeader);
          HeaderL.add(SingleHeader);
          ColIndex.add(pred(HeaderL.Count));
        end
        else
        begin
          ColIndex.add(c);
        end;
        //
      end;

      for r := 1 to pred(JoinL.Count) do
      begin
        NewL := TStringList.Create;
        for c := 0 to pred(HeaderL.Count) do
          NewL.add('');
        c := 0;
        try
          ThisData := JoinL[r];
          while (ThisData <> '') do
          begin
            NewL[ColIndex[c]] := nextp(ThisData, getSeparator);
            inc(c);
            if (c >= ColIndex.Count) and (ThisData <> '') then
            begin
              // sDiagnose.add('Zeile: ' + JoinL[r]);
              // sDiagnose.add('WARNING: zu viele Felder. Rest: "'+ThisData+'"');
              break;
            end;
          end;
        except
          on e: Exception do
          begin
            // sDiagnose.add('Zeile: ' + JoinL[r]);
            // sDiagnose.add('ERROR: ' + e.message);
            break;
          end;
        end;

        add(NewL);
      end;

      ColIndex.free;
    end;
  end;
  JoinL.free;
  Changed := false;
end;

procedure TsTable.insertFromHash(Path, FName : string; StaticHeader: string = '');
begin
  if FileExists(Path+c_sT_SecuredHashSubDir+FName) then
   insertFromFile(Path+c_sT_SecuredHashSubDir+FName,StaticHeader)
  else
   insertFromFile(Path+FName,StaticHeader);
end;

function TsTable.header: TStringList;
begin
  if (count=0) then
   result := nil
  else
   result := TStringList(Items[0]);
end;

function TsTable.readCell(Row, Col: integer): string;
begin
  if (Col >= 0) then
    result := TStringList(Items[Row])[Col]
  else
    result := '';
end;

function TsTable.readCell(Row: integer; Col: string): string;
begin
  result := readCell(Row, colOf(Col));
end;

procedure TsTable.Rem(Col: integer);
var
  r: integer;
begin
  for r := 0 to pred(Count) do
    TStringList(Items[r]).delete(Col);
end;

function TsTable.readRow(r: integer): TStringList;
begin
  result := TStringList.Create;
  result.addstrings(TStringList(Items[r]));
end;

function TsTable.RowCount: integer;
begin
  result := pred(Count);
end;

function TsTable.distinct(C: string) : Integer;
begin
  result := distinct(colof(c));
end;

function TsTable.distinct(C: Integer) : Integer;
var
 sCol : TStringList;
begin
 sCol := col(C);
 sCol.sort;
 removeduplicates(sCol);
 result := sCol.Count;
 sCol.Free;
end;

function TsTable.locate(Col: integer; sValue: string): integer;
var
  r: integer;
begin
  result := -1;
  if (Col>-1) then
    for r := 1 to pred(Count) do
      if (TStringList(Items[r])[Col] = sValue) then
      begin
        result := r;
        break;
      end;
end;

function TsTable.locate(Col: string; sValue: string): integer;
begin
  result := locate(colOf(Col,true), sValue);
end;

function TsTable.next(Row, Col: integer; sValue: string): integer;
var
  r: integer;
begin
  result := -1;
  for r := Row to pred(Count) do
    if (TStringList(Items[r])[Col] = sValue) then
    begin
      result := r;
      exit;
    end;
  for r := 1 to pred(Row) do
    if (TStringList(Items[r])[Col] = sValue) then
    begin
      result := r;
      exit;
    end;
end;

function TsTable.next(Row: integer; Col, sValue: string): integer;
begin
  result := next(Row, colOf(Col), sValue);
end;

procedure TsTable.SortBy(sFields: TStrings);
var
  ClientSorter: TStringList;
  k, m, n: integer;
  SortColumn, SortStr: string;
  FormatNumeric, DoReverse, FormatDate: boolean;
  eSave: TObjectList;
  LogFName: string;
  SortierenNotwendig: boolean;
begin
  if (Count > 2) then
  begin

    if TestMode then
    begin
      LogFName := DebugLogPath + 'sort.log';
    end;

    // Die Sortierkriterien bilden
    ClientSorter := TStringList.Create;
    eSave := TObjectList.Create(false);

    for n := 0 to pred(sFields.Count) do
    begin
      SortColumn := sFields[n];

      FormatDate := pos('date', SortColumn) > 0;
      if FormatDate then
        Anfix.ersetze('date', '', SortColumn);

      FormatNumeric := pos('numeric', SortColumn) > 0;
      if FormatNumeric then
        Anfix.ersetze('numeric', '', SortColumn);

      DoReverse := pos('descending', SortColumn) > 0;
      if DoReverse then
        Anfix.ersetze('descending', '', SortColumn)
      else
        Anfix.ersetze('ascending', '', SortColumn);

      SortColumn := cutblank(SortColumn);
      k := header.indexof(SortColumn);
      if (k = -1) then
        k := 0;
      for m := 1 to pred(Count) do
      begin
        SortStr := readCell(m, k);
        if FormatDate then
         SortStr := inttoStr(date2long(SortStr));
        if FormatNumeric then
          SortStr := inttostrN(round(StrToDoubleDef(SortStr, 0) * 100.0), 15);
        if DoReverse then
          SortStr := reverseSort(SortStr);
        if (n = 0) then
          ClientSorter.AddObject(SortStr, TObject(pointer(m)))
        else
          ClientSorter[pred(m)] := ClientSorter[pred(m)] + SortStr;
      end;
    end;

    // Sind alle Sortierkriterien (zufällig) schon in der richtigen Reihenfolge?
    //
    // In diesem Fall braucht nicht sortiert zu werden das ist sogar eher
    // schädlich:
    // Sort with identical Items can destroy original order
    // so we need to avoid unneeded sort attemps
    SortierenNotwendig := false;
    for m := 0 to ClientSorter.Count - 2 do
      // imp pend: sollte hier nicht "compare" des ClientSorters verwendet werden, ist aber nicht public!
      if (ClientSorter[m] > ClientSorter[succ(m)]) then
      begin
        SortierenNotwendig := true;
        break;
      end;

    if SortierenNotwendig then
    begin

      // sortieren
      ClientSorter.Sort;

      // Diagnose
      if TestMode then
      begin
        for n := 0 to pred(ClientSorter.Count) do
          ClientSorter[n] :=
          { } format('%d "%s"', [
            { } PtrUInt(ClientSorter.Objects[n]),
            { } ClientSorter[n]]);
        ClientSorter.SaveToFile(LogFName);
      end;

      // Reihenfolge übernehmen
      OwnsObjects := false;
      eSave.Assign(self);
      for m := 1 to pred(Count) do
      begin
        n := PtrUInt(ClientSorter.Objects[pred(m)]);
        if (n <> m) then
        begin
          if TestMode then
            AppendStringsToFile('overwrite Items[' + inttostr(m) + '] with _Items[' + inttostr(n) + ']', LogFName);
          Items[m] := eSave[n];
          Changed := true;
        end;
      end;
      OwnsObjects := true;
    end;

    // Finalize
    eSave.free;
    ClientSorter.free;
  end;
end;

procedure TsTable.SortBy(sFields: String);
var
  slFields: TStringList;
begin
  slFields := split(sFields);
  SortBy(slFields);
  slFields.free;
end;

function TsTable.locateDuplicates(Col: integer; sValue: string; CompareType: eTsCompareType = TsIdentical)
  : TgpIntegerList;
var
  Row: integer;
begin
  result := TgpIntegerList.Create;
  case CompareType of
    TsIdentical:
      begin
        for Row := 1 to pred(Count) do
          if (readCell(Row, Col) = sValue) then
            result.add(Row);
      end;
    TsIgnoreLeadingZeros:
      begin
        sValue := killLeadingZero(sValue);
        for Row := 1 to pred(Count) do
          if (killLeadingZero(readCell(Row, Col)) = sValue) then
            result.add(Row);
      end;
  end;
end;

function TsTable.md5: string;
var
  hashMessageDigest5: TIdHashMessageDigest5;
  TableDump: TStringList;
begin
  TableDump := data;
  hashMessageDigest5 := TIdHashMessageDigest5.Create;
  result := IdGlobal.IndyLowerCase(hashMessageDigest5.HashStringAsHex(TableDump.Text+oSalt));
  hashMessageDigest5.free;
  TableDump.free;
end;

function Distinct(s: string): string;
var
  w: TWordIndex;
begin
  w := TWordIndex.Create(nil);
  with w do
  begin
    AddWords(s, nil);
    JoinDuplicates(true);
    result := Words;
  end;
  w.free;
end;

procedure SaveToFileCSV(s:TStringList;FName : string; Header : string = '');
var
 OutS : TStringList;
 n : integer;
 o : string;
begin
 OutS := TStringList.create;
 if (Header<>'') then
  OutS.add(Header)
 else
  OutS.add('RID;TEXT');
 for n := 0 to pred(s.count) do
 begin
   o := s[n];
   ersetze('"','''',o);
   ersetze(';','&',o);
   OutS.add(
    { RID } InttoStr(PtrUInt(s.objects[n]))+';'+
    { TEXT } '"' + o + '"');
 end;
 Outs.SaveToFile(FName);
 Outs.free;
end;

function AddTableHashFName(FName: String): String;
begin
  result := ExtractFilePath(FName)+c_sT_SecuredHashSubDir+ExtractFileName(FName);
end;

procedure AddTableHash(FName: string; salt: string);
var
 t : TsTable;
 Path : string;
begin
 t := TsTable.Create;
 with t do
 begin
   insertfromFile(Fname);
   oSalt := salt;
   Path := ExtractFilePath(FName);
   CheckCreateDir(Path+c_sT_SecuredHashSubDir);
   SaveToFile(Path+c_sT_SecuredHashSubDir+ExtractFileName(FName));
 end;
 t.Free;
end;

end.
