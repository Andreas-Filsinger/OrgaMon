{
This unit contains Delphi-Replacements for the Free-Pascal-Compiler.
}

(*------------------------------------------------------------------------------
The Original Code is JcfStringUtils, released October 2008.
The Initial Developer of the Original Code is Paul Ishenin
Portions created by Paul Ishenin are Copyright (C) 1999-2008 Paul Ishenin
All Rights Reserved.
Contributor(s): Anthony Steele.

The contents of this file are subject to the Mozilla Public License Version 1.1
(the "License"). you may not use this file except in compliance with the License.
You may obtain a copy of the License at http://www.mozilla.org/NPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied.
See the License for the specific language governing rights and limitations
under the License.

Alternatively, the contents of this file may be used under the terms of
the GNU General Public License Version 2 or later (the "GPL")
See http://www.gnu.org/licenses/gpl.html
------------------------------------------------------------------------------*)

{
This unit contains string utility code
For use when the JCL string functions are not avaialable
}
unit fpchelper;

{$mode delphi}

interface

uses
  SysUtils, Classes,
  {$ifdef MSWINDOWS}
  Windows, activex,
  {$endif}
  {$ifndef console}
  Graphics,
  {$endif}
  gettext, DCPcrypt2, DCPmd5;

const
     PIPE_UNLIMITED_INSTANCES = 255;
     SW_HIDE = 0;
     MOVEFILE_WRITE_THROUGH = 8;
     {$ifdef console}
     console_red : RawByteString = #27'[91m';
     console_green : RawByteString = #27'[92m';
     console_white : RawByteString = #27'[0m';
     {$endif}

type
  {$ifdef console}
  TColor = Integer;
  {$endif}
  TColorRec = record
    const
  SystemColor = $FF000000;
  // System Colors (Windows only)
  cSCROLLBAR = 0;
  cBACKGROUND = 1;
  cACTIVECAPTION = 2;
  cINACTIVECAPTION = 3;
  cMENU = 4;
  cWINDOW = 5;
  cWINDOWFRAME = 6;
  cMENUTEXT = 7;
  cWINDOWTEXT = 8;
  cCAPTIONTEXT = 9;
  cACTIVEBORDER = 10;
  cINACTIVEBORDER = 11;
  cAPPWORKSPACE = 12;
  cHIGHLIGHT = 13;
  cHIGHLIGHTTEXT = 14;
  cBTNFACE = 15;
  cBTNSHADOW = $10;
  cGRAYTEXT = 17;
  cBTNTEXT = 18;
  cINACTIVECAPTIONTEXT = 19;
  cBTNHIGHLIGHT = 20;
  c3DDKSHADOW = 21;
  c3DLIGHT = 22;
  cINFOTEXT = 23;
  cINFOBK = 24;
  cHOTLIGHT = 26;
  cGRADIENTACTIVECAPTION = 27;
  cGRADIENTINACTIVECAPTION = 28;
  cMENUHILIGHT = 29;
  cMENUBAR = 30;
  cENDCOLORS = cMENUBAR;
  cDESKTOP = cBACKGROUND;
  c3DFACE = cBTNFACE;
  c3DSHADOW = cBTNSHADOW;
  c3DHIGHLIGHT = cBTNHIGHLIGHT;
  c3DHILIGHT = cBTNHIGHLIGHT;
  cBTNHILIGHT = cBTNHIGHLIGHT;
  SysScrollBar = TColor(SystemColor or cSCROLLBAR);
  SysBackground = TColor(SystemColor or cBACKGROUND);
  SysActiveCaption = TColor(SystemColor or cACTIVECAPTION);
  SysInactiveCaption = TColor(SystemColor or cINACTIVECAPTION);
  SysMenu = TColor(SystemColor or cMENU);
  SysWindow = TColor(SystemColor or cWINDOW);
  SysWindowFrame = TColor(SystemColor or cWINDOWFRAME);
  SysMenuText = TColor(SystemColor or cMENUTEXT);
  SysWindowText = TColor(SystemColor or cWINDOWTEXT);
  SysCaptionText = TColor(SystemColor or cCAPTIONTEXT);
  SysActiveBorder = TColor(SystemColor or cACTIVEBORDER);
  SysInactiveBorder = TColor(SystemColor or cINACTIVEBORDER);
  SysAppWorkSpace = TColor(SystemColor or cAPPWORKSPACE);
  SysHighlight = TColor(SystemColor or cHIGHLIGHT);
  SysHighlightText = TColor(SystemColor or cHIGHLIGHTTEXT);
  SysBtnFace = TColor(SystemColor or cBTNFACE);
  SysBtnShadow = TColor(SystemColor or cBTNSHADOW);
  SysGrayText = TColor(SystemColor or cGRAYTEXT);
  SysBtnText = TColor(SystemColor or cBTNTEXT);
  SysInactiveCaptionText = TColor(SystemColor or cINACTIVECAPTIONTEXT);
  SysBtnHighlight = TColor(SystemColor or cBTNHIGHLIGHT);
  Sys3DDkShadow = TColor(SystemColor or c3DDKSHADOW);
  Sys3DLight = TColor(SystemColor or c3DLIGHT);
  SysInfoText = TColor(SystemColor or cINFOTEXT);
  SysInfoBk = TColor(SystemColor or cINFOBK);
  SysHotLight = TColor(SystemColor or cHOTLIGHT);
  SysGradientActiveCaption = TColor(SystemColor or cGRADIENTACTIVECAPTION);
  SysGradientInactiveCaption = TColor(SystemColor or cGRADIENTINACTIVECAPTION);
  SysMenuHighlight = TColor(SystemColor or cMENUHILIGHT);
  SysMenuBar = TColor(SystemColor or cMENUBAR);
  SysNone = TColor($1FFFFFFF);
  SysDefault = TColor($20000000);
  // Actual colors
  Aliceblue = TColor($FFF8F0);
  Antiquewhite = TColor($D7EBFA);
  Aqua = TColor($FFFF00);
  Aquamarine = TColor($D4FF7F);
  Azure = TColor($FFFFF0);
  Beige = TColor($DCF5F5);
  Bisque = TColor($C4E4FF);
  Black = TColor($000000);
  Blanchedalmond = TColor($CDEBFF);
  Blue = TColor($FF0000);
  Blueviolet = TColor($E22B8A);
  Brown = TColor($2A2AA5);
  Burlywood = TColor($87B8DE);
  Cadetblue = TColor($A09E5F);
  Chartreuse = TColor($00FF7F);
  Chocolate = TColor($1E69D2);
  Coral = TColor($507FFF);
  Cornflowerblue = TColor($ED9564);
  Cornsilk = TColor($DCF8FF);
  Crimson = TColor($3C14DC);
  Cyan = TColor($FFFF00);
  Darkblue = TColor($8B0000);
  Darkcyan = TColor($8B8B00);
  Darkgoldenrod = TColor($0B86B8);
  Darkgray = TColor($A9A9A9);
  Darkgreen = TColor($006400);
  Darkgrey = TColor($A9A9A9);
  Darkkhaki = TColor($6BB7BD);
  Darkmagenta = TColor($8B008B);
  Darkolivegreen = TColor($2F6B55);
  Darkorange = TColor($008CFF);
  Darkorchid = TColor($CC3299);
  Darkred = TColor($00008B);
  Darksalmon = TColor($7A96E9);
  Darkseagreen = TColor($8FBC8F);
  Darkslateblue = TColor($8B3D48);
  Darkslategray = TColor($4F4F2F);
  Darkslategrey = TColor($4F4F2F);
  Darkturquoise = TColor($D1CE00);
  Darkviolet = TColor($D30094);
  Deeppink = TColor($9314FF);
  Deepskyblue = TColor($FFBF00);
  Dimgray = TColor($696969);
  Dimgrey = TColor($696969);
  Dodgerblue = TColor($FF901E);
  Firebrick = TColor($2222B2);
  Floralwhite = TColor($F0FAFF);
  Forestgreen = TColor($228B22);
  Fuchsia = TColor($FF00FF);
  Gainsboro = TColor($DCDCDC);
  Ghostwhite = TColor($FFF8F8);
  Gold = TColor($00D7FF);
  Goldenrod = TColor($20A5DA);
  Gray = TColor($808080);
  Green = TColor($008000);
  Greenyellow = TColor($2FFFAD);
  Grey = TColor($808080);
  Honeydew = TColor($F0FFF0);
  Hotpink = TColor($B469FF);
  Indianred = TColor($5C5CCD);
  Indigo = TColor($82004B);
  Ivory = TColor($F0FFFF);
  Khaki = TColor($8CE6F0);
  Lavender = TColor($FAE6E6);
  Lavenderblush = TColor($F5F0FF);
  Lawngreen = TColor($00FC7C);
  Lemonchiffon = TColor($CDFAFF);
  Lightblue = TColor($E6D8AD);
  Lightcoral = TColor($8080F0);
  Lightcyan = TColor($FFFFE0);
  Lightgoldenrodyellow = TColor($D2FAFA);
  Lightgray = TColor($D3D3D3);
  Lightgreen = TColor($90EE90);
  Lightgrey = TColor($D3D3D3);
  Lightpink = TColor($C1B6FF);
  Lightsalmon = TColor($7AA0FF);
  Lightseagreen = TColor($AAB220);
  Lightskyblue = TColor($FACE87);
  Lightslategray = TColor($998877);
  Lightslategrey = TColor($998877);
  Lightsteelblue = TColor($DEC4B0);
  Lightyellow = TColor($E0FFFF);
  LtGray = TColor($C0C0C0);
  MedGray = TColor($A4A0A0);
  DkGray = TColor($808080);
  MoneyGreen = TColor($C0DCC0);
  LegacySkyBlue = TColor($F0CAA6);
  Cream = TColor($F0FBFF);
  Lime = TColor($00FF00);
  Limegreen = TColor($32CD32);
  Linen = TColor($E6F0FA);
  Magenta = TColor($FF00FF);
  Maroon = TColor($000080);
  Mediumaquamarine = TColor($AACD66);
  Mediumblue = TColor($CD0000);
  Mediumorchid = TColor($D355BA);
  Mediumpurple = TColor($DB7093);
  Mediumseagreen = TColor($71B33C);
  Mediumslateblue = TColor($EE687B);
  Mediumspringgreen = TColor($9AFA00);
  Mediumturquoise = TColor($CCD148);
  Mediumvioletred = TColor($8515C7);
  Midnightblue = TColor($701919);
  Mintcream = TColor($FAFFF5);
  Mistyrose = TColor($E1E4FF);
  Moccasin = TColor($B5E4FF);
  Navajowhite = TColor($ADDEFF);
  Navy = TColor($800000);
  Oldlace = TColor($E6F5FD);
  Olive = TColor($008080);
  Olivedrab = TColor($238E6B);
  Orange = TColor($00A5FF);
  Orangered = TColor($0045FF);
  Orchid = TColor($D670DA);
  Palegoldenrod = TColor($AAE8EE);
  Palegreen = TColor($98FB98);
  Paleturquoise = TColor($EEEEAF);
  Palevioletred = TColor($9370DB);
  Papayawhip = TColor($D5EFFF);
  Peachpuff = TColor($B9DAFF);
  Peru = TColor($3F85CD);
  Pink = TColor($CBC0FF);
  Plum = TColor($DDA0DD);
  Powderblue = TColor($E6E0B0);
  Purple = TColor($800080);
  Red = TColor($0000FF);
  Rosybrown = TColor($8F8FBC);
  Royalblue = TColor($E16941);
  Saddlebrown = TColor($13458B);
  Salmon = TColor($7280FA);
  Sandybrown = TColor($60A4F4);
  Seagreen = TColor($578B2E);
  Seashell = TColor($EEF5FF);
  Sienna = TColor($2D52A0);
  Silver = TColor($C0C0C0);
  Skyblue = TColor($EBCE87);
  Slateblue = TColor($CD5A6A);
  Slategray = TColor($908070);
  Slategrey = TColor($908070);
  Snow = TColor($FAFAFF);
  Springgreen = TColor($7FFF00);
  Steelblue = TColor($B48246);
  Tan = TColor($8CB4D2);
  Teal = TColor($808000);
  Thistle = TColor($D8BFD8);
  Tomato = TColor($4763FF);
  Turquoise = TColor($D0E040);
  Violet = TColor($EE82EE);
  Wheat = TColor($B3DEF5);
  White = TColor($FFFFFF);
  Whitesmoke = TColor($F5F5F5);
  Yellow = TColor($00FFFF);
  Yellowgreen = TColor($32CD9A);
  Null = TColor($00000000);


  class var ColorToRGB: function (Color: TColor): Longint;
  case LongWord of
    0:
      (Color: TColor);
    2:
      (HiWord, LoWord: Word);
    3:
{$IFDEF BIGENDIAN}
      (A, B, G, R: System.Byte);
{$ELSE}
      (R, G, B, A: System.Byte);
{$ENDIF}
end;
  TColors = TColorRec;

const
  MaxWord = 65535;
  NativeNull           = Char(#0);
  NativeSoh            = Char(#1);
  NativeStx            = Char(#2);
  NativeEtx            = Char(#3);
  NativeEot            = Char(#4);
  NativeEnq            = Char(#5);
  NativeAck            = Char(#6);
  NativeBell           = Char(#7);
  NativeBackspace      = Char(#8);
  NativeTab            = Char(#9);
  NativeLineFeed       = AnsiChar(#10);
  NativeVerticalTab    = Char(#11);
  NativeFormFeed       = Char(#12);
  NativeCarriageReturn = AnsiChar(#13);
  NativeCrLf           = AnsiString(#13#10);
  NativeSo             = Char(#14);
  NativeSi             = Char(#15);
  NativeDle            = Char(#16);
  NativeDc1            = Char(#17);
  NativeDc2            = Char(#18);
  NativeDc3            = Char(#19);
  NativeDc4            = Char(#20);
  NativeNak            = Char(#21);
  NativeSyn            = Char(#22);
  NativeEtb            = Char(#23);
  NativeCan            = Char(#24);
  NativeEm             = Char(#25);
  NativeEndOfFile      = Char(#26);
  NativeEscape         = Char(#27);
  NativeFs             = Char(#28);
  NativeGs             = Char(#29);
  NativeRs             = Char(#30);
  NativeUs             = Char(#31);
  NativeSpace          = Char(' ');
  NativeComma          = Char(',');
  NativeBackslash      = Char('\');
  NativeForwardSlash   = Char('/');

  {$IFDEF MSWINDOWS}
  NativeLineBreak = NativeCrLf;
  PathSeparator    = '\';
  {$ENDIF MSWINDOWS}
  {$IFDEF UNIX}
  NativeLineBreak = NativeLineFeed;
  PathSeparator    = '/';
  {$ENDIF UNIX}
  DirDelimiter = PathSeparator;
  NativeHexDigits      = ['0'..'9', 'A'..'F', 'a'..'f'];
  NativeWhiteSpace     = [NativeTab, NativeLineFeed, NativeVerticalTab,
    NativeFormFeed, NativeCarriageReturn, NativeSpace];

  NativeDoubleQuote = Char('"');
  NativeSingleQuote = Char('''');


{$IFNDEF DELPHI12}
{$IFNDEF DELPHI14}
function CharInSet(const C: Char; const testSet: TSysCharSet): Boolean;
{$ENDIF}
{$ENDIF}
function CharIsControl(const C: Char): Boolean;
function CharIsAlpha(const C: Char): Boolean;
function CharIsAlphaNum(const C: Char): Boolean;
function CharIsDigit(const C: Char): Boolean;
function CharIsReturn(const C: Char): Boolean;
function CharIsWhiteSpace(const C: Char): Boolean;

function CharUpper(const C: Char): Char; 

function StrIsAlpha(const S: string): Boolean;
function StrIsAlphaNum(const S: string): Boolean;

function StrTrimQuotes(const S: string): string;

function StrAfter(const SubStr, S: string): string;
function StrBefore(const SubStr, S: string): string;
function StrChopRight(const S: string; N: Integer): string;
function StrLastPos(const SubStr, S: string): Integer;
function StrIPos(const SubStr, S: string): integer;

function StrLeft(const S: string; Count: Integer): string;
function StrRestOf(const S: string; N: Integer ): string;
function StrRight(const S: string; Count: Integer): string;

function StrDoubleQuote(const S: string): string;
function StrSmartCase(const S: string; Delimiters: TSysCharSet): string;

function StrCharCount(const S: string; C: Char): Integer;
function StrStrCount(const S, SubS: string): Integer;
function StrRepeat(const S: string; Count: Integer): string;

procedure StrReplace(var S: string; const Search, Replace: string; Flags: TReplaceFlags = []);
function StrSearch(const Substr, S: string; const Index: Integer = 1): Integer;

function BooleanToStr(B: Boolean): string;
function StrToBoolean(const S: string): Boolean;

function StrFind(const Substr, S: string; const Index: Integer = 1): Integer;
function StrIsOneOf(const S: string; const List: array of string): Boolean;

procedure TrimStrings(const List: TStrings; DeleteIfEmpty: Boolean = True);

function FileToString(const FileName: string): AnsiString;
procedure StringToFile(const FileName: string; const Contents: AnsiString);
function StrFillChar(const C: Char; Count: Integer): string;
function IntToStrZeroPad(Value, Count: Integer): String;
function StrPadLeft(const pcOriginal: string;
  const piDesiredLength: integer; const pcPad: Char): string;

function WideStringReplace(const S, OldPattern, NewPattern: WideString; Flags: TReplaceFlags): WideString;

function PathExtractFileNameNoExt(const Path: string): string;

function PadNumber(const pi: integer): string;
function StrHasAlpha(const str: String): boolean;
procedure RegisterExpectedMemoryLeak(var a);

function GetProgramFilesFolder : string;
{$ifdef MSWINDOWS}

function GetPersonalFolder : string;
function GetAppdataFolder : string;
{$endif}

function TDCP_hash_FromFile(pHash: TDCP_hash; FileName: string): string; {public}
function TDCP_hash_FromStrings(pHash : TDCP_hash; Str: TStrings): string;

type
  EJcfConversionError = class(Exception)
  end;

  function _(s:string):string;

implementation

uses
{$ifdef MSWINDOWS}
  ShellApi
{$endif}
{$ifdef Unix}
  Unix
{$endif}
{$ifdef fpc}
  , fileutil
{$ifndef console}
, LCLIntf
{$endif}
{$endif};

{$IFNDEF DELPHI12}
{$IFNDEF DELPHI14}
// define  CharInSet for Delphi 2007 or earlier
function CharInSet(const C: Char; const testSet: TSysCharSet): Boolean;
begin
  Result := C in testSet;
end;
{$ENDIF}
{$ENDIF}

function CharIsAlpha(const C: Char): Boolean;
begin
  Result := CharInSet(C, ['a'..'z','A'..'Z']);
end;

function CharIsAlphaNum(const C: Char): Boolean;
begin
  Result := CharIsAlpha(C) or CharIsDigit(C);
end;

function CharIsControl(const C: Char): Boolean;
begin
  Result := C <= #31;
end;

function CharIsDigit(const C: Char): Boolean;
begin
  Result := CharInSet(C, ['0'..'9']);
end;

function CharIsReturn(const C: Char): Boolean;
begin
  Result := CharInSet(C, [NativeLineFeed, NativeCarriageReturn]);
end;

function CharIsWhiteSpace(const C: Char): Boolean;
begin
  Result := CharInSet(C, NativeWhiteSpace) ;
end;

function CharUpper(const C: Char): Char;
begin
  // Paul: original code used char case table
  Result := UpCase(C);
end;

function StrIsAlpha(const S: string): Boolean;
var
  I, L: integer;
begin
  L := Length(S);
  Result := L > 0;
  for I := 1 to L do
    if not CharIsAlpha(S[I]) then
    begin
      Result := False;
      break;
    end;
end;

function StrIsAlphaNum(const S: string): Boolean;
var
  I, L: integer;
begin
  L := Length(S);
  Result := L > 0;
  for I := 1 to L do
    if not CharIsAlphaNum(S[I]) then
    begin
      Result := False;
      break;
    end;
end;

function StrTrimQuotes(const S: string): string;
var
  C1, C2: Char;
  L: Integer;
begin
  Result := S;
  L := Length(Result);
  if L >= 2 then
  begin
    C1 := Result[1];
    C2 := Result[L];
    if (C1 = C2) and (CharInSet(C1, [NativeSingleQuote, NativeDoubleQuote])) then
    begin
      Delete(Result, L, 1);
      Delete(Result, 1, 1);
    end;
  end;
end;

function StrAfter(const SubStr, S: string): string;
var
  P: Integer;
begin
  P := StrSearch(SubStr, S, 1);
  if P > 0 then
    Result := Copy(S, P + Length(SubStr), Length(S))
  else
    Result := '';
end;

function StrBefore(const SubStr, S: string): string;
var
  P: Integer;
begin
  P := StrSearch(SubStr, S, 1);
  if P > 0 then
    Result := Copy(S, 1, P - 1)
  else
    Result := S;
end;

function StrChopRight(const S: string; N: Integer): string;
begin
  Result := Copy(S, 1, Length(S) - N);
end;

function StrLastPos(const SubStr, S: string): Integer;
var
  NewPos: Integer;
begin
  Result := 0;
  while Result < Length(S) do
  begin
    NewPos := StrSearch(SubStr, S, Result + 1);
    if NewPos > 0 then
      Result := NewPos
    else
      break;
  end;
end;

{ case-insensitive "pos" }
function StrIPos(const SubStr, S: string): integer;
begin
  // simple and inneficient implmentation
  Result := Pos(UpperCase(SubStr), UpperCase(s));
end;

function StrLeft(const S: string; Count: Integer): string;
begin
  Result := Copy(S, 1, Count);
end;

function StrRestOf(const S: string; N: Integer ): string;
begin
  Result := Copy(S, N, (Length(S) - N + 1));
end;

function StrRight(const S: string; Count: Integer): string;
begin
  Result := Copy(S, Length(S) - Count + 1, Count);
end;

function StrDoubleQuote(const S: string): string;
begin
  Result := NativeDoubleQuote + S + NativeDoubleQuote;
end;

function StrSmartCase(const S: string; Delimiters: TSysCharSet): string;
var
  i: integer;
begin
  // if no delimiters passed then use default set
  if Delimiters = [] then
    Delimiters := NativeWhiteSpace;
  Result := S;
  for i := 1 to Length(Result) do
    if (i = 1) or (CharInSet(Result[i - 1], Delimiters)) then
      Result[i] := UpCase(Result[i]);
end;

function StrCharCount(const S: string; C: Char): Integer;
var
  i: integer;
begin
  Result := 0;
  for i := 1 to Length(S) do
    if S[i] = C then
      inc(Result);
end;

function StrStrCount(const S, SubS: string): Integer;
var
  P: integer;
begin
  Result := 0;
  P := 1;
  while P < Length(S) do
  begin
    P := StrSearch(Subs, S, P);
    if P > 0 then
    begin
      inc(Result);
      inc(P);
    end
    else
      break;
  end;
end;

function StrRepeat(const S: string; Count: Integer): string;
begin
  Result := '';
  while Count > 0 do
  begin
    Result := Result + S;
    Dec(Count);
  end;
end;

procedure StrReplace(var S: string; const Search, Replace: string; Flags: TReplaceFlags = []);
begin
  S := StringReplace(S, Search, Replace, Flags);
end;

function StrSearch(const Substr, S: string; const Index: Integer = 1): Integer;
begin
  // Paul: I expect original code was more efficient :)
  Result := Pos(SubStr, Copy(S, Index, Length(S)));

  if Result > 0 then
    Result := Result + Index - 1;
end;

function BooleanToStr(B: Boolean): string;
const
  BoolToStrMap: array[Boolean] of String =
  (
 { false } 'False',
 { true  } 'True'
  );
begin
  Result := BoolToStrMap[B];
end;

function StrToBoolean(const S: string): Boolean;
var
  LowerS: String;
begin
  LowerS := LowerCase(S);
  if (LowerS = 'false') or (LowerS = 'no') or (LowerS = '0') then
    Result := False
  else
  if (LowerS = 'true') or (LowerS = 'yes') or (LowerS = '1') or (LowerS = '-1') then
    Result := True
  else
    raise EJcfConversionError.Create('Cannot convert string [' + S + '] to boolean');
end;


function StrFind(const Substr, S: string; const Index: Integer = 1): Integer;
begin
  // Paul: original code used comparision by char case table
  Result := StrSearch(LowerCase(SubStr), LowerCase(S), Index);
end;

function StrIsOneOf(const S: string; const List: array of string): Boolean;
var
  i: integer;
begin
  for i := Low(List) to High(List) do
    if CompareStr(List[i], S) = 0 then
    begin
      Result := True;
      Exit;
    end;
  Result := False;
end;

procedure TrimStrings(const List: TStrings; DeleteIfEmpty: Boolean = True);
var
  i: integer;
begin
  if List <> nil then
    for i := List.Count - 1 downto 0 do
    begin
      List[i] := Trim(List[i]);
      if DeleteIfEmpty and (List[i] = '') then
        List.Delete(i);
    end;
end;

function FileToString(const FileName: string): AnsiString;
var
  S: TStream;
begin
  S := nil;
  try
    S := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
    SetLength(Result, S.Size);
    S.Read(PAnsiChar(Result)^, S.Size);
  finally
    S.Free;
  end;
end;

procedure StringToFile(const FileName: string; const Contents: AnsiString);
var
  S: TStream;
begin
  S := nil;
  try
    S := TFileStream.Create(FileName, fmCreate);
    S.Write(PAnsiChar(Contents)^, Length(Contents));
  finally
    S.Free;
  end;
end;

function StrFillChar(const C: Char; Count: Integer): string;
begin
  SetLength(Result, Count);
  if Count > 0 then
    FillChar(Result[1], Count, C);
end;

function IntToStrZeroPad(Value, Count: Integer): String;
begin
  Result := IntToStr(Value);
  while Length(Result) < Count do
    Result := '0' + Result;
end;

{ pad the string on the left had side until it fits }
function StrPadLeft(const pcOriginal: string;
  const piDesiredLength: integer; const pcPad: Char): string;
begin
  Result := pcOriginal;

  while (Length(Result) < piDesiredLength) do
  begin
    Result := pcPad + Result;
  end;

end;

// Based on FreePascal version of StringReplace
function WideStringReplace(const S, OldPattern, NewPattern: WideString; Flags: TReplaceFlags): WideString;
var
  Srch, OldP, RemS: WideString; // Srch and Oldp can contain uppercase versions of S,OldPattern
  P: Integer;
begin
  Srch := S;
  OldP := OldPattern;
  if rfIgnoreCase in Flags then
  begin
    Srch := WideUpperCase(Srch);
    OldP := WideUpperCase(OldP);
  end;
  RemS := S;
  Result := '';
  while (Length(Srch) <> 0) do
  begin
    P := Pos(OldP, Srch);
    if P = 0 then
    begin
      Result := Result + RemS;
      Srch := '';
    end
    else
    begin
      Result := Result + Copy(RemS, 1, P - 1) + NewPattern;
      P := P + Length(OldP);
      RemS := Copy(RemS, P, Length(RemS) - P + 1);
      if not (rfReplaceAll in Flags) then
      begin
        Result := Result + RemS;
        Srch := '';
      end
      else
        Srch := Copy(Srch, P, Length(Srch) - P + 1);
    end;
  end;
end;

function PadNumber(const pi: integer): string;
begin
  Result := IntToStrZeroPad(pi, 3);
end;

function StrHasAlpha(const str: String): boolean;
var
  liLoop: integer;
begin
  Result := False;

  for liLoop := 1 to Length(str) do
  begin
    if CharIsAlpha(str[liLoop]) then
    begin
      Result := True;
      break;
    end;
  end;
end;

{------------------------------------------------------
  functions to manipulate file paths in strings }

function PathRemoveExtension(const Path: string): string;
var
  p: Integer;
begin
  // from Lazarus FileUtil
  Result := Path;
  p := Length(Result);
  while (p>0) do
  begin
    case Result[p] of
      PathDelim: Exit;
      '.': Result := copy(Result, 1, p-1);
    end;
    Dec(p);
  end;
end;

function PathExtractFileNameNoExt(const Path: string): string;
begin
  Result := PathRemoveExtension(ExtractFileName(Path));
end;

function PathRemoveSeparator(const Path: string): string;
begin
  Result := Path;
  if (Result <> '') and (Result[Length(Result)] = PathDelim) then
    Delete(Result, Length(Result), 1);
end;

function _(s:string):string;
begin
  result := s;
end;

procedure RegisterExpectedMemoryLeak(var a);
begin
end;

function GetProgramFilesFolder : string;
begin
  result := '// imp pend';
end;

procedure StrResetLength(var S: AnsiString);
var
  I: SizeInt;
begin
  for I := 0 to Length(S) - 1 do
    if S[I + 1] = #0 then
    begin
      SetLength(S, I);
      Exit;
    end;
end;
{$ifdef MSWINDOWS}

function PidlToPath(IdList: PItemIdList): string;
begin
  SetLength(Result, MAX_PATH);
  if SHGetPathFromIdList(IdList, PChar(Result)) then
    StrResetLength(Result)
  else
    Result := '';
end;

//----------------------------------------------------------------------------

function GetSpecialFolderLocation(const Folder: Integer): string;
var
  FolderPidl: PItemIdList;
begin
  FolderPidl := nil;
  if Succeeded(SHGetSpecialFolderLocation(0, Folder, FolderPidl)) then
  begin
    try
      Result := PidlToPath(FolderPidl);
    finally
      CoTaskMemFree(FolderPidl);
    end;
  end
  else
    Result := '';
end;


function GetPersonalFolder : string;
begin
  {$IFDEF UNIX}
  Result := GetEnvironmentVariable('HOME') + '/';
  {$ENDIF UNIX}
  {$IFDEF MSWINDOWS}
  Result := GetSpecialFolderLocation(CSIDL_PERSONAL) + '\';
  {$ENDIF MSWINDOWS}
end;

function GetAppdataFolder : string;
begin
  result := '// imp pend';
end;
{$endif}

{$ifdef MSWINDOWS}
Const
  LF_FACESIZE = 32;

  // FONT WEIGHT (BOLD) VALUES
  FW_DONTCARE         = 0;
//  FW_NORMAL           = 400;
  FW_BOLD             = 700;

Type
  CONSOLE_FONT_INFOEX = record
    cbSize     : ULONG;
    nFont      : DWORD;
    dwFontSize : COORD;
    FontFamily : UINT;
    FontWeight : UINT;
    FaceName   : array [0..LF_FACESIZE-1] of WCHAR;
  end;

{ Only supported in Vista and onwards!}

function SetCurrentConsoleFontEx(hConsoleOutput: HANDLE; bMaximumWindow: BOOL; var CONSOLE_FONT_INFOEX): BOOL; stdcall; external kernel32;

var
  New_CONSOLE_FONT_INFOEX: CONSOLE_FONT_INFOEX;
  _SystemCodePage : DWORD;
  _TextCodePage : DWORD;
  {$endif}

  function TDCP_hash_FromFile(pHash: TDCP_hash; FileName: string): string; {public}
  var
    HashSizeInBytes: integer;
    Hash: array of Byte;
    HashS: array of AnsiChar;
    DataF: TFileStream;
  begin
    with pHash do
    begin

    // init hash, prepare buffers
    Init;
    HashSizeInBytes := GetHashSize DIV 8;
    SetLength(Hash,HashSizeInBytes);
    SetLength(HashS,HashSizeInBytes*2+1);

    // Open File
    DataF := TFileStream.create(FileName,fmOpenRead,fmShareDenyNone);
    UpdateStream(DataF,DataF.Size);
    DataF.Free;

    // make a finger print string from hash
    // lower-case seem to be common
    Final(Hash[0]);
    BinToHex(PAnsiChar(Hash),PAnsiChar(HashS),HashSizeInBytes);
    result := AnsiLowerCase(PAnsiChar(HashS));
    end;
  end;

  function TDCP_hash_FromStrings(pHash : TDCP_hash; Str: TStrings): string;
  var
    HashSizeInBytes: integer;
    Hash: array of Byte;
    HashS: array of AnsiChar;
    n : integer;
  begin
    with pHash do
    begin
    // init hash, prepare buffers
    Init;
    HashSizeInBytes := GetHashSize DIV 8;
    SetLength(Hash,HashSizeInBytes);
    SetLength(HashS,HashSizeInBytes*2+1);

    // Open File
    for n := 0 to pred(Str.count) do
     updateStr(Str[n]);

    // make a finger print string from hash
    // lower-case seem to be common
    Final(Hash[0]);
    BinToHex(PAnsiChar(Hash),PAnsiChar(HashS),HashSizeInBytes);
    result := AnsiLowerCase(PAnsiChar(HashS));
    end;
  end;

var
   dwMode:DWORD ;

initialization

  {$ifdef WINDOWS}
  _SystemCodePage := DefaultSystemCodePage;
  _TextCodePage := GetTextCodePage(Output);

  // The whole World: UTF-8 only
  DefaultSystemCodePage := CP_UTF8;
  SetConsoleOutputCP(CP_UTF8);
  SetTextCodePage(Output, CP_UTF8);
  SetConsoleCP(CP_UTF8);

  // set another Font for the Console
  FillChar(New_CONSOLE_FONT_INFOEX, SizeOf(CONSOLE_FONT_INFOEX), 0);
  New_CONSOLE_FONT_INFOEX.cbSize := SizeOf(CONSOLE_FONT_INFOEX);
  New_CONSOLE_FONT_INFOEX.FaceName := 'Source Code Pro Semibold'; //'';
  New_CONSOLE_FONT_INFOEX.FontWeight := FW_NORMAL;
  New_CONSOLE_FONT_INFOEX.dwFontSize.Y := 20;
  SetCurrentConsoleFontEx(StdOutputHandle, False, New_CONSOLE_FONT_INFOEX);

  // activate ANSI Color
  GetConsoleMode(StdOutputHandle, dwMode);
  SetConsoleMode(StdOutputHandle, dwMode Or ENABLE_VIRTUAL_TERMINAL_PROCESSING);

  // we start first output
  {$ifdef console}
  Writeln('default system codepage: ', DefaultSystemCodePage, ' (was ',_SystemCodePage,')');
  Writeln('console output codepage: ', GetTextCodePage(Output), ' (was ',_TextCodePage,')');
  {$endif}

  {$endif}
end.
