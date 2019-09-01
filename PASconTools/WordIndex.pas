(*

  TWordIndex - Full Text Search Object
  TsTable - String Table (CSV-Objekt)
  TSearchStringList - Binäre Suche & Incrementelle & "Pos=1" Suche
  TExtendedList - "AND" "OR" fähige Liste

  Copyright (C) 2007 - 2018  Andreas Filsinger

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

  http://orgamon.org/

  todo:

  Umstellung der Type-Casts auf PtrUint

*)
unit WordIndex;

{$ifdef fpc}
{$codepage cp1252}
{$mode objfpc}{$H+}
{$endif}

interface

uses
  Classes, Contnrs,
  math, gplists;

const
  WordIndexVersion: single = 1.026; // ..\rev\WordIndex.rev.txt

  {$H-}
  c_wi_TranslateFrom      = 'ßÄËÖÜÁÀÉÈÚÙÓÍÊÇÅ';
  c_wi_TranslateTo        = 'SAEOUAAEEUUOIECA';
  c_wi_ValidChars         = '~ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789' + c_wi_TranslateFrom;
  c_wi_ValidCharsSort     = '~ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789' + c_wi_TranslateTo;
  c_wi_TranslateLast      = 37;

  c_wi_WhiteSpace_noblank = '_()*+-:&§",/!?=;<>#{}$%''´`^' + #$0D;
  c_wi_WhiteSpace_exact   = ' ' + c_wi_WhiteSpace_noblank;
  c_wi_WhiteSpace         = '.' + c_wi_WhiteSpace_exact;
  {$H+}

  c_st_DefaultSeparator   = ';';
  c_wi_FileExtension      = '.Suchindex';
  c_wi_RID_Suche          = 'RID'; // "RID" n [ { "," n } ]

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
    // 1) ein String mit vielen Suchbegriffen wird zusammen mit einem RID
    //    per AddWords(S,R) übergeben. 1 AddWords pro Datensatz
    // 2) per JoinDuplicates wird der eigentliche Suchindex aufgebaut.
    //    Dieser Aufruf führt dazu dass alle Objects[] der Liste auf eine
    //    Liste der Vorkommen von einzelnen Worten umgestellt wird. Erst
    //    danach ist "SaveToFile" oder "SaveToDiagfile" erlaubt.
    // 3) Nun kann mit "Search(S)" in der Liste gesucht werden, dabei
    //    wird die Ergebnisliste "FoundList" gefüllt mit einer Liste aus
    //    RIDs. Also die Datensätze befinden sich in der Liste die passend
    //    zu allen Suchworten sind (UND - Logik)
    //

  private
    pMinWordLenght: integer;
    LastFileAge: integer;
    LastChecked: longword;

    // Am Anfang sind die Objects[] RIDs (ObjectsAreLists=false)
    // Später sind die Objects TExentedLists mit den RIDs als Elemente
    ObjectsAreLists: Boolean;

    procedure ClearTheList;

  public
    LastFileName: string;
    Version: integer; // File-Version der aktuell geladenen Version
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
    procedure AddWords(BigWordStr: RawByteString; AObject: TObject);

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

  end;

const
  sRID_NULL = '<NULL>';

type
  eTsCompareType = (TsIdentical, TsIgnoreLeadingZeros);

  // Eine CSV-Tabelle im Speicher
  // Anzahl der Datensätze: RowCount = pred(count)
  // Row = 1..pred(count) : die Datenzeilen, alias:
  // Row = 1..RowCount : die Datenzeilen
  // Col = 0..pred(header.count) : die Datenspalten
  //
  // interne Organisation
  // Tlist = array of TStringList ~ eine Zeile = eine Row
  // TList[13][2] -> Zelle der "Zeile 13" "Spalte 3"
  TsTable = class(TObjectList)
    Changed: boolean;

    // Options
    oNoblank: boolean; // noblank to all the cells on "load"
    oDistinct: boolean; // sort and remove duplicates on "load"
    oNoAutoQuote: boolean; // do NOT remove all the Quotes  ;"aaa"; -> ;aaa;
    oTextHasLF: boolean; // Text Cells can have internal Line Breaks (LF)
    oSeparator: string; // Trenner zwischen den Spalten
    oHTML_Prefix: string;
    oHTML_Postfix: string;

    function getSeparator: string;
    procedure insertFromFile(FName: string; StaticHeader: string = '');
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

    function readCell(Row, Col: integer): string; overload;
    function readCell(Row: integer; Col: string): string; overload;

    procedure writeCell(Row, Col: integer; s: string); overload;
    procedure writeCell(Row: integer; Col: string; s: string); overload;
    procedure concatCell(Row, Col: integer; s: string); overload;
    procedure concatCell(Row: integer; Col: string; s: string); overload;
    procedure incCell(Row, Col: integer); overload;
    procedure incCell(Row: integer; Col: string); overload;
    procedure SortBy(sFields: TStrings); overload;
    procedure SortBy(sFields: String); overload;

    function isHeader(HeaderName: string): boolean;
    function colOf(HeaderName: string; RaiseIfNotExists: boolean = false): integer;
    function addCol(HeaderName: string; DefaultValue: string = ''): integer; overload;
    function addCol(HeaderName: string; Values: TStringList): integer; overload;
    function Col(c: integer): TStringList;

    // Rechenfunktionen
    function sumCol(HeaderName: string): double;

    // Höhere Funktionen
    procedure BlowUp(SearchCol: string; FName: string; ExtCol: string);

    function readRow(r: integer): TStringList;

    // Ersetze in einem String alle Spaltenwerte
    procedure ersetze(Row: integer; var s: string);

    // ACHTUNG: r darf nach addRow nicht freigegeben werden
    function addRow(r: TStringList = nil): integer;
    function RowCount: integer;
    function ColCount: integer;
    function md5: string;

    constructor Create; virtual;
    destructor Destroy; override;
  end;

function ParameterValid(a, b: string): boolean;
function PrepareForSearch(s: string): string;
function PrepareAsIndex(s: string): string;
function Distinct(s: string): string;
procedure SaveToFileCSV(s:TStringList; FName: string; Header : string = '');

implementation

uses
  {$ifdef fpc}
  fpchelper,
  {$endif}
{$IFNDEF CONSOLE}
  Dialogs,
{$ENDIF}
  SysUtils, Anfix32, html,

  IdGlobal, IdHash, IdHashMessageDigest;

const
  cTWordIndex_File_Tag: integer = (ord('T') shl 0) + (ord('W') shl 8) + (ord('I') shl 16) + (26 shl 24);
  cWordIndex_GlobalSequence: integer = 0;

type
  TBinaereSucheResult = (BS_Found, BS_NotFound, BS_SimilarFound);

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
        if k = 0 then
          AddWords(Mother[n], Mother.Objects[n])
        else
          AddWords(system.copy(Mother[n], 1, pred(k)), Mother.Objects[n]);
      end;
    end;
    JoinDuplicates(true);
    EndUpdate;
  end;
end;

procedure TWordIndex.AddWords(BigWordStr: RawBytestring; AObject: TObject);
var
  sLen: integer;
  wStart, wEnd: integer;
  AutomataState: integer;
  Candidates: TStringList;

  procedure WordOut;
  begin
    if (wEnd - wStart >= pMinWordLenght) then
      Candidates.AddObject(system.copy(BigWordStr, wStart, wEnd - wStart), AObject);
  end;

  function ValidChar(Index : Integer): boolean;
  var
    k: integer;
  begin

    // nicht Teil eines Zusammenhängenden Wortes
    if pos(BigWordStr[Index], c_wi_WhiteSpace) > 0 then
    begin
      result := false;
      exit;
    end;

    k := pos(BigWordStr[Index], c_wi_ValidChars);
    if (k > 0) then
    begin
      if (k>c_wi_TranslateLast) then
       BigWordStr[Index] := AnsiChar(c_wi_ValidCharsSort[k]);
      result := true;
      exit;
    end
    else
    begin
      result := false;
    end;
  end;

 {$ifdef fpc}
  var
     s: UTF8String;
     b : string;
     r : RawByteString;
     by : Byte;
 {$endif}
begin
 {$ifdef fpc_console_test}

 write('1:'); writeln(#$C3#$9c); // do not Work!

 SetLength(r,2);
 r[1] := #$C3;
 r[2] := #$9c;
 write('1:'); writeln(r); // do not Work!

 by := 27;
 write(output,AnsiChar(by));
 by := ord('[');
 write(output,AnsiChar(by));
 by := ord('4');
 write(output,AnsiChar(by));
 by := ord('3');
 write(output,AnsiChar(by));
 by := ord('m');
 write(output,AnsiChar(by));


 write('2:'); writeln('Ü'); // Works

 {$H-}
 write('3-:'); writeln(c_wi_ValidChars);

 r := c_wi_ValidChars;
 write('4-:'); writeln(r);

 r := SystoUTF8(c_wi_ValidChars);
 write('5-:'); writeln(r);

 {$H+}
 write('3+:'); writeln(c_wi_ValidChars);

 r := c_wi_ValidChars;
 write('4+:'); writeln(r);

 r := SystoUTF8(c_wi_ValidChars);
 write('5+:'); writeln(r);

 writeln('3:' + 'Ü'); // not Work
 writeln('4:' + 'üü'+'ää'); // not Work
 {$H-}
 writeln('5:' + 'Ü'); // Works
 writeln('6:' + 'üü'+'ää'); // not Work

 {$H+}

 s := '+++Ü+++';
 write('6+:'); writeln(s);
 write('6+:'); writeln(RawByteString(s));
 write('6+:'); writeln(AnsiToUTF8(s));

 {$H-}
 s := '+++Ü+++';
 write('6-:'); writeln(s);

 {$H+}
 write('6:'); writeln(s);

 {$H-}
 b := 'Ü';
 write('7:'); writeln(b);
 {$H+}

 b := 'Ü';
 write('8:'); writeln(b);
 write('9:'); writeln(s);


// BigWordStr := AnsiUpperCase(BigWordStr);
// BigWordStr := UTF8UpperCase(BigWordStr);
 {$endif}


 {$ifdef fpc}
 case StringCodePage(BigWordStr) of
   0:SetCodePage(BigWordStr, 1252, false);
   1252:;
   CP_UTF8: SetCodePage(BigWordStr, 1252, true);
 else
  Halt(1);
 end;
 {$endif}

// writeln(BigWordStr);
 BigWordStr := {$ifdef fpc}fpchelper.{$endif}AnsiUpperCase(BigWordStr);
// writeln(BigWordStr);

 sLen := length(BigWordStr);
 wStart := 0;
 wEnd := 0;
 AutomataState := 0;
 Candidates := TStringList.Create;

 while true do
 begin
    case AutomataState of
      0:
        begin // search for word start!
          inc(wStart);
          if (wStart > sLen) then
            break;
          if ValidChar(wStart) then
          begin
            AutomataState := 1;
            wEnd := wStart;
          end;
        end;
      1:
        begin // search for word end!
          inc(wEnd);
          if (wEnd > sLen) then
          begin
            WordOut;
            break;
          end;
          if not(ValidChar(wEnd)) then
          begin
            WordOut;
            AutomataState := 0;
            wStart := wEnd;
          end;
        end;
    end;
 end;

 // .addstrings
 if (Candidates.Count > 1) then
 begin
   Candidates.Sort;
   inc(S_LocalClones, removeduplicates(Candidates));
 end;
 addstrings(Candidates);
 Candidates.free;
end;

procedure TWordIndex.JoinDuplicates(LookForClones: boolean);
var
  AddIndex: integer;
  CheckIndex: integer;
  ReferenceList: TExtendedList;
  StoreP: pointer;
begin

  if (Count > 0) then
  begin

    BeginUpdate;
    Sort;

    AddIndex := pred(Count);
    while true do
    begin

      // neues Wort anfangen, auf alle Fälle anfügen!
      ReferenceList := TExtendedList.Create;
      ReferenceList.add(pointer(Objects[AddIndex]));
      Objects[AddIndex] := ReferenceList;

      CheckIndex := pred(AddIndex);
      if (CheckIndex < 0) then
        break;
      while true do
      begin

        if (strings[AddIndex] = strings[CheckIndex]) then
        begin

          // A double entry was found
          inc(S_WordDuplicates);

          if LookForClones then
          begin
            // check possibility of locale Clones
            StoreP := pointer(Objects[CheckIndex]);
            with ReferenceList do
            begin
              if Count > 1 then
              begin
                if indexof(StoreP) = -1 then
                  add(StoreP)
                else
                  inc(S_GlobalClones); // double words inside same row
              end
              else
              begin
                // Store the reference
                add(StoreP);
              end;
            end;
          end
          else
          begin
            // Store the reference
            ReferenceList.add(pointer(Objects[CheckIndex]));
          end;

          // But delete the double entry
          delete(CheckIndex);
          dec(CheckIndex);
          if (CheckIndex < 0) then
            break;
          dec(AddIndex);
        end
        else
        begin
          break;
        end;

      end;
      ReferenceList.Sort(@ExtendedListSortCompare);
      if (CheckIndex < 0) then
        break;
      AddIndex := CheckIndex;

    end;
    EndUpdate;
  end;
  {
    for CheckIndex := 1 to pred(count) do
    if strings[pred(CheckIndex)]>=strings[CheckIndex] then
    ShowMessage(format('Fehler! %s>=%s',[strings[pred(CheckIndex)],strings[CheckIndex]]));
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
  Version := round(WordIndexVersion * 1000);
  BlockWrite(OutF, Version, sizeof(integer));

  // 3. Integer: pMinWordLength
  BlockWrite(OutF, pMinWordLenght, sizeof(integer));

  // 4. Integer: Anzahl der Strings!
  _ListCount := Count;
  BlockWrite(OutF, _ListCount, sizeof(integer));
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

  LastFileAge := FileAge(FName);
end;

procedure TWordIndex.LoadFromFile(const FName: string);
type
  Pi = ^integer;
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
  LastFileAge := FileAge(FName);
  LastFileName := FName;
  if (LastFileAge <> -1) then
  begin
    BeginUpdate;

    ClearTheList;
    clear;

    // page into!!
    FileMode := fmOpenRead or fmShareDenyWrite;
    AssignFile(InF, FName);
    reset(InF, 1);
    _FSize := FileSize(InF);
    GetMem(ReadP, _FSize);
    _ReadP := ReadP;
    Blockread(InF, ReadP^, _FSize);
    CloseFile(InF);
    FileMode := fmOpenReadWrite;

    // Evaluate Version
    _ListCount := Pi(ReadP)^;
    {$ifdef FPC}
    inc(ReadP, 4);
    {$else}
    inc(integer(ReadP), 4);
    {$endif}
    if (_ListCount = cTWordIndex_File_Tag) then
    begin
      Version := Pi(ReadP)^;
      inc({$ifndef FPC}integer{$endif}(ReadP), 4);
      pMinWordLenght := Pi(ReadP)^;
      inc({$ifndef FPC}integer{$endif}(ReadP), 4);
      _ListCount := Pi(ReadP)^;
      inc({$ifndef FPC}integer{$endif}(ReadP), 4);
    end;

    capacity := _ListCount;
    for n := 0 to pred(_ListCount) do
    begin
      _SubCount := Pi(ReadP)^;
      inc({$ifndef FPC}integer{$endif}(ReadP), 4);
      SubItems := TExtendedList.Create;
      SubItems.capacity := _SubCount;
      for m := 0 to pred(_SubCount) do
      begin
        _refNo := Pi(ReadP)^;
        inc({$ifndef FPC}integer{$endif}(ReadP), 4);
        SubItems.add(Pointer(_refNo));
      end;
      _StrLen := Pi(ReadP)^;
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
begin
  result := false;
  if (LastFileName <> '') then
    if Frequently(LastChecked, 300) then
      if (FileAge(LastFileName) <> LastFileAge) then
      begin
        LoadFromFile(LastFileName);
        result := true;
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
          OutStr := OutStr + inttostr(integer(TheList[m])) + ' ';
        if TheList.Count > MaxSubElementCount then
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
      RIDs := RIDs + ';' + inttostr(integer(TheList[m]));
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

  function BinaereSuche(SearchStr: string; var m: integer): TBinaereSucheResult;
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
      CompareResult := AnsiCompareText(strings[m], SearchStr);

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

  function ChangeSpecialChars(const s: string): string;
  var
    n, k: integer;
  begin
    result := s;
    for n := 1 to length(s) do
    begin
      k := pos(s[n], c_wi_ValidChars);
      if (k > 0) then
        result[n] := c_wi_ValidCharsSort[k];
    end;
  end;

  function DeleteWhiteSpace(s: string): string;
  var
    n: integer;
  begin
    result := s;
    for n := 1 to length(s) do
      if pos(s[n], c_wi_WhiteSpace) > 1 then
        result[n] := ' ';
  end;

  function DeleteWhiteSpace_exact(s: string): string;
  var
    n: integer;
  begin
    result := s;
    for n := 1 to length(s) do
      if pos(s[n], c_wi_WhiteSpace_exact) > 1 then
        result[n] := ' ';
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

    s := AnsiUpperCase(s);
    s := ChangeSpecialChars(s);
    s := DeleteWhiteSpace_exact(s);

    // "unechte" Wort-trenner entfernen
    while true do
    begin
      k := pos(#32#32, s);
      if (k = 0) then
        break;
      system.delete(s, k, 1);
    end;

    // nach allen einzelnen Worten suchen!
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

procedure TExtendedList.LogicalOR(L: TList);
var
  n: integer;
begin
  for n := 0 to pred(L.Count) do
    if indexof(L[n]) = -1 then
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
      if L.indexof(Items[n]) = -1 then
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
        if pos(AnsiUpperCase(EntryName + '='), AnsiUpperCase(strings[n])) = 1 then
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
        result.add(PtrUInt(Objects[l]))  // result.add(integer(Objects[l]))
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
    if pos(SearchStr, strings[n]) > 0 then
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
  a := AnsiUpperCase(StrFilter(a, c_wi_WhiteSpace_noblank, ' '));
  ersetze('  ', ' ', a);
  b := AnsiUpperCase(StrFilter(b, c_wi_WhiteSpace_noblank, ' '));
  ersetze('  ', ' ', b);

  // Jedes el(a) mus mit el(b) übereinstimmen
  // Im Moment noch vereinfach, 1:1 UND 2:2 es sollte aber auch z.B.
  // 1:5 UND 2:10 UND 2:23 ein Treffer sein.
  result := true;
  repeat
    if pos(nextp(a, ' '), nextp(b, ' ')) = 0 then
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
      result := inttostr(integer(Items[i]))
    else
      result := result + ',' + inttostr(integer(Items[i]));
end;

constructor TExtendedList.Create;
begin
  inherited;
end;

destructor TExtendedList.Destroy;
begin
  inherited;
end;

constructor TsTable.Create;
begin
  inherited Create(true);
end;

destructor TsTable.Destroy;
begin
  inherited;
end;

procedure TsTable.ersetze(Row: integer; var s: string);
var
  c: integer;
begin
  for c := 0 to pred(header.Count) do
  begin
    if pos('$', s) = 0 then
      break;
    Anfix32.ersetze('$' + header[c], readCell(Row, c), s);
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
  if (Col >= 0) then
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
      TStringList(Items[r]).add(DefaultValue);
    Changed := true;
  end;
end;

function TsTable.addCol(HeaderName: string; Values: TStringList): integer;
var
  r: integer;
begin
  // auto generate a empty header line
  if (Count = 0) then
  begin
    add(TStringList.Create);
    result := -1;
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
    result.AddObject(TStringList(Items[r])[c], TObject(uint64(r)));
end;

function TsTable.ColCount: integer;
begin
  result := header.Count;
end;

function TsTable.colOf(HeaderName: string; RaiseIfNotExists: boolean = false): integer;
begin
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
  OutS.SaveToFile(FName);
  OutS.free;
end;

procedure TsTable.SaveToHTML(FName: string; sFormats: TStringList = nil);
const
  cPagebreak = '<div class="breakhere">&nbsp;</div>';
var
  r, c, cPAPERCOLOR: integer;
  lastRow, lastCol: integer;
  OutS: TStringList;
  sRow: TStringList;
  tdExtras: string;
  tdData: string;
  tdPaperColor: string;
begin
  lastRow := pred(Count);
  cPAPERCOLOR := colOf('PAPERCOLOR');
  lastCol := pred(ColCount);
  if (cPAPERCOLOR = lastCol) then
    lastCol := pred(lastCol);

  OutS := TStringList.Create;
  with OutS do
  begin
    add('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"');
    add('          "http://www.w3.org/TR/html4/loose.dtd">');
    add('<html>');
    add('<head>');
    add('<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">');
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

    (*

      //
      // Versuch, die gültigkeit des td-Defaults nur auf "border" zu beziehen und nicht global!
      // Versuch, die "Sonder" td nur inerhalb von "border" sichtbar zu machen
      //
      // -> Funktion noch bisher nicht bewiesen
      //

      add('table.border {border-color:#000000; border-style:solid; border-width:0pt;');
      add(' td { border-color:#000000; border-style:solid; border-left-width:1pt; border-right-width:0pt; border-bottom-width:0pt; border-top-width:1pt; font-family:Verdana; font-size:-1; }');
      add(' td.gend { border-color:#000000; border-style:solid; border-left-width:1pt; border-right-width:1pt; border-bottom-width:0pt; border-top-width:1pt; font-family:Verdana; font-size:-1; }');
      add(' td.gfoot { border-color:#000000; border-style:solid; border-left-width:1pt; border-right-width:0pt; border-bottom-width:1pt; border-top-width:1pt; font-family:Verdana; font-size:-1; }');
      add(' td.gright { border-color:#000000; border-style:solid; border-left-width:1pt; border-right-width:1pt; border-bottom-width:1pt; border-top-width:1pt; font-family:Verdana; font-size:-1; }');
      add('}');

    *)

    add('</style>');
    if assigned(sFormats) then
      add('<title>' + Ansi2HTML(sFormats.Values['TITEL']) + '</title>')
    else
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

      if (r > 0) then
        if (cPAPERCOLOR <> -1) then
        begin
          tdPaperColor := sRow[cPAPERCOLOR];
          if (pos('#', tdPaperColor) = 1) then
            tdPaperColor := ' bgcolor="' + tdPaperColor + '"'
          else
            tdPaperColor := '';
        end;

      for c := 0 to pred(sRow.Count) do
      begin
        if (c = cPAPERCOLOR) then
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

        add(
          { } '  <td' + tdExtras + '>' + Ansi2HTML(tdData) +
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
        Anfix32.ersetze('"', '', sl);

  // Noblank aller Zeilen?!
  if oNoblank then
  begin
    for n := 0 to pred(sl.Count) do
      sl[n] := noblank(sl[n]);
  end;

  // distinct
  if oDistinct then
    if sl.Count > 1 then
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

  // Header vorbereiten
  JoinL := TStringList.Create;
  if (StaticHeader <> '') then
    JoinL.add(StaticHeader);

  // csv laden
  if oTextHasLF then
    LoadFromFileCSV_LF(false, JoinL, FName)
  else
    LoadFromFileCSV(false, JoinL, FName);

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

      Anfix32.ersetze('"', '', JoinL);

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
    if JoinL.Count > 1 then
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
        add(Cols);
      end;
    end;
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

function TsTable.header: TStringList;
begin
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

function TsTable.locate(Col: integer; sValue: string): integer;
var
  r: integer;
begin
  result := -1;
  for r := 1 to pred(Count) do
    if (TStringList(Items[r])[Col] = sValue) then
    begin
      result := r;
      break;
    end;
end;

function TsTable.locate(Col: string; sValue: string): integer;
begin
  result := locate(colOf(Col), sValue);
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
  FormatNumeric, DoReverse: boolean;
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
      FormatNumeric := pos('numeric', SortColumn) > 0;
      if FormatNumeric then
        Anfix32.ersetze('numeric', '', SortColumn);
      DoReverse := pos('descending', SortColumn) > 0;
      if DoReverse then
        Anfix32.ersetze('descending', '', SortColumn)
      else
        Anfix32.ersetze('ascending', '', SortColumn);
      SortColumn := cutblank(SortColumn);
      k := header.indexof(SortColumn);
      if (k = -1) then
        k := 0;
      for m := 1 to pred(Count) do
      begin
        SortStr := readCell(m, k);
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
  result := IdGlobal.IndyLowerCase(hashMessageDigest5.HashStringAsHex(TableDump.Text));
  hashMessageDigest5.free;
  TableDump.free;
end;

function PrepareForSearch(s: string): string;
var
  n: integer;
begin
  result := AnsiUpperCase(s);
  for n := 1 to length(result) do
    if (pos(result[n], c_wi_ValidChars) = 0) then
      result[n] := ' ';
  ersetze('  ', ' ', result);
  result := ' ' + cutblank(result) + ' ';
end;

function PrepareAsIndex(s: string): string;
var
  i, k: integer;
begin
  result := StrFilter(AnsiUpperCase(s), c_wi_ValidChars);
  for i := 1 to length(result) do
  begin
    k := pos(result[i], c_wi_TranslateFrom);
    if (k > 0) then
      result[i] := c_wi_TranslateTo[k];
  end;
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


function ExtendedListSortCompare (Item1, Item2: Pointer) : Integer;
begin
  result := CompareValue( PtrUInt(Item1), PtrUInt(Item2) );
end;


end.
