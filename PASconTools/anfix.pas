(* anfix - low level Tools

  Copyright (C) 2007 - 2023  Andreas Filsinger

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
unit anfix;

{$ifdef FPC}
 {$mode objfpc}{$H+}
{$else}
 {$I jcl.inc}
{$endif}

interface

uses
{$IFDEF MSWINDOWS}
  windows,
  shlobj,
{$ENDIF}
  classes,
  SysUtils;

const
  VersionAnfix: single = 1.073; // ..\rev\anfix.rev.txt
  cRevNotAValidProject: single = 0.000;

  NVAC = #255; // not valid char

  // Leaving Settings "empty" means they are
  // replaced by a default Value. If you explicit want
  // the empty String (='') (length=0) use "" in
  // this case - Situation must support this!
  cExplizitEmpty = '""'; // If you dont want the default but ''

type
  TDateTimeBorlandPascal = record
    Year, Month, Day, Hour, Min, Sec: Word;
  end;

  // Zeit
type
  TAnfixTime = longint; // [Sekunden]

const
  cOneMinuteInSeconds = 60;
  cOneHourInSeconds = 60 * cOneMinuteInSeconds;
  cOneDayInSeconds = 24 * cOneHourInSeconds;
  cNoon = cOneDayInSeconds div 2;
  cUhr = ' Uhr ';
  cIllegalSeconds = longint(Low(longint));

  // Datum
type
  TDatum_Granularitaet = (TDG_Tag, TDG_Woche, TDG_Monat, TDG_Quartal, TDG_Jahr);
  TAnfixDate = longint;

const
  cDATE_YEAR_FAKTOR = 10000;
  cDATE_MONTH_FAKTOR = 100;
  cDATE_DAY_FAKTOR = 1;

  cDATE_MONTAG = 1;
  cDATE_DIENSTAG = 2;
  cDATE_MITTWOCH = 3;
  cDATE_DONNERSTAG = 4;
  cDATE_FREITAG = 5;
  cDATE_SAMSTAG = 6;
  cDATE_SONNTAG = 7;

  cIllegalDate = 0;
  cIllegalDateTime : TDateTime = -700000;

  cMinDate: longint = 0 * cDATE_YEAR_FAKTOR + 1 * cDATE_MONTH_FAKTOR + 1;
  // 01.01.0000
  cMaxDate: longint = 9999 * cDATE_YEAR_FAKTOR + 12 * cDATE_MONTH_FAKTOR + 31;
  ccMinDate = 19000101;
  // Eigentlich  0=30.12.1899 erste "g¸ltige" Datum also der 31.12.1899
  ccMaxDate = 99991231;
  cMaxDateTime: double = 9999 * 365;
  cTageNamenKurz: array [1 .. 7] of string = ('MON', 'DIE', 'MIT', 'DON', 'FRE', 'SAM', 'SON');
  cTageNamenLang: array [1 .. 7] of string = ('Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag',
    'Sonntag');
  cMonatNamenLang: array [1 .. 12] of string = ('Januar', 'Februar', 'M‰rz', 'April', 'Mai', 'Juni', 'Juli', 'August',
    'September', 'Oktober', 'November', 'Dezember');
  cMonatWeb: array [1 .. 12] of string = ('Jan', 'Feb', 'M‰r', 'Apr', 'Mai', 'Jun', 'Jul', 'Aug', 'Sep', 'Okt',
    'Nov', 'Dez');

const
  // Win32
  BELOW_NORMAL_PRIORITY_CLASS = $4000;
  ABOVE_NORMAL_PRIORITY_CLASS = $8000;

  // FSize()
  cFSize_NotExists = -1;
  cFSize_Null = -2;

  // Filter: Basis
  cZiffern = '0123456789';
  cBuchstaben = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  cZeichen = '!"#$%&''()*+,-./:;<=>?@[\]^_`{|}~';

  // Filter: Dateinamen
  cInvalidFNameChars = ':/\?*"<>|';
  cInvalidPathNameChars = '.:?*"<>|';
  cValidFNameChars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-';

  // Filter: Sonderzeichen in Strings (0..31, ausser <TAB>,<LF>,<CR>)
  cASCIISteuerzeichen = #0#1#2#3#4#5#6#7#8#11#12#14#15#16#17#18#19#20#21#22#23#24#25#26#27#28#29#30#31;

  // diverses
  cLineSeparator = '|';
  cMonetarySymbol = 'Ä';

  // TMP-Dateien
  cTmpFileExtension = '.$$$';

  // dir Datei Masken
  cDirMask_Directory = '*.';
  cDirMask_All       = '*'; // DO NOT USE '*.*'

  //
  // Erhˆhung der Lesbarkeit des Quelltextes
  //
  // 1) repeat schleife

  // until eternity; = Endlosschleife
  eternity = false;

  // until yet; = Sofortiges Ende
  yet = true;

// Feedback-Infrastruktur
// ======================
//
// Ermˆglicht einer NON-GUI Funktion im Rahmen ihrer lange andauernden
// Verarbeitung ab und an Feedback an die Aufrufende Funktion zur¸ckzugeben.
// Dabei gibt der Aufrufer schon beim Funktions-Aufruf ein Feedback Callback
// Objekt als Parameter an. Dahinter verbirgt sich dann eine Funktion die
// Anzeigen an das UI ausgibt.
// Dabei wird immer ein numerischer Key (Integer) und ein Value (String) ¸bergeben
// ‹ber den "key" kann ein Namespace-Shift gelegt werden, dadurch ist ¸ber ein
// case Statement eine schnelle Implementierung zahlreicher GUI-Elemente mˆglich
//
// Im worker: feeback(cFeedBack_Label + 23, 'fast fertig');
//
// Im Caller: case key of
//             cFeedBack_Label + 21 : label21.caption := value;
//             cFeedBack_Label + 22 : label22.caption := value;
//             cFeedBack_Label + 23 : label23.caption := value;
//            end;
//

const
 // keys
 cFeedBack_SingleElement_MaxCount = 1000;
 cFeedBack_ProcessMessages = 0*cFeedBack_SingleElement_MaxCount;
 cFeedBack_Log = 1*cFeedBack_SingleElement_MaxCount;
 cFeedBack_ProgressBar_Position = 2*cFeedBack_SingleElement_MaxCount;
 cFeedBack_ProgressBar_Max = 3*cFeedBack_SingleElement_MaxCount;
 cFeedBack_ProgressBar_stepit = 4*cFeedBack_SingleElement_MaxCount;
 cFeedBack_Label = 5*cFeedBack_SingleElement_MaxCount;
 cFeedBack_ListBox_clear = 6*cFeedBack_SingleElement_MaxCount;
 cFeedBack_ListBox_add = 7*cFeedBack_SingleElement_MaxCount;
 cFeedBack_ShowMessage = 8*cFeedBack_SingleElement_MaxCount;
 cFeedBack_Function = 9*cFeedBack_SingleElement_MaxCount;
 cFeedBack_doit = 10*cFeedBack_SingleElement_MaxCount;
 cFeedBack_Edit = 11*cFeedBack_SingleElement_MaxCount;
 cFeedBack_Result = 12*cFeedBack_SingleElement_MaxCount;
 cFeedBack_OpenShell = 13*cFeedBack_SingleElement_MaxCount;

 // return codes, Feedback can "break" long Calculations
 cFeedBack_CONT = 0;
 cFeedBack_BREAK = 1;
 cFeedBack_TRUE = 2;
 cFeedBack_FALSE = 3;

var
 // persistent String Value
 _FeedBack_String : string = '';

type
 TFeedback = function (key : Integer; value : string = '') : Integer;
 TOFeedback = function (key : Integer; value : string = '') : Integer of object;

var
  MandantName: string = 'offline';
  cNachfrage: string = 'Nachfrage';
  // Das zuletzt ¸bergebene Dokument (print,open,exec,...)
  _Document: string = '';
  iPDFZoom: string = '3.0';

  // log startup of app
  StartDebugger: boolean = false;

  // bring prediction inside self-tests
  TestMode: boolean = false;

  // log verbose
  DebugMode: boolean = false;
  DebugLogPath: string = '';
  FileRetireDate: TAnfixDate;

  // Debug-Sachen
procedure StartDebug(s: string);

// String - Utils: Manipulation
procedure ersetze(const find_str, ersetze_str: string; var d: String); overload;
{$ifndef FPC}
procedure ersetze(const find_str, ersetze_str: string; var d: AnsiString); overload;
{$endif}
procedure ersetze(const find_str, ersetze_str: string; var d: Shortstring); overload;
procedure ersetze(s: TStrings; var d: string); overload;
procedure ersetze(const find_str, ersetze_str: string; s: TStrings); overload;
procedure ersetze(const find_str, ersetze_str: string; s: TStrings; Index: integer); overload;
procedure ersetzeUpper(find_str, ersetze_str: string; var d: string);
function ExtractSegmentBetween(const InpStr, prefix, postfix: string; Upper: boolean = false): string;
function StrFilter(s, Filter: string; DeleteHits: boolean = false): string; overload;
function StrFilter(s, Filter: string; Hit: char): string; overload;
function StrFilter(s: string; Filter: TSysCharSet; DeleteHits: boolean = false): string; Overload;
function noblank(const InpStr: string): string; overload;
procedure noblank(const sl: TStringList); overload;
function noDoubleBlank(s: string): string;

function nosemi(const s: string): string;

// Stringgewichtung rumdrehen
function reverseSort(s: string): string;

function cutblank(const InpStr: string): string; overload;
function cutblank(s: TStrings): boolean; overload;
function cutrblank(const InpStr: string): string;
function cutlblank(const InpStr: string): string;
function CharCount(c: char; const InpStr: string): integer;
function fill(ch: string; i: integer): string;
function killLeadingZero(s: string): string;
procedure bfill(var x: string; Size: byte);

function bstr(const x: string; Size: byte): string;
function revPos(const substr: string; const s: string): integer;
// Pos backwards
function revCopy(const s: string; start, len: integer): string;
// Copy backwards
procedure SwapStr(var s: string; Start1, len, Start2: integer);

// 1,2,5-10 wird umgesetzt in 1,2,5,6,7,8,9,10
function StrRange(s: string): string;

// Str - Utils : Datenkonvertierung
function btostr(b: byte; st: byte): string;
function ltostr(l: longint; st: byte): string;
function rtostr(r: real; stv, stn: byte): string; { pretty-Format }
function boolToStr(b: boolean; _true: string = 'Y'; _false: string = 'N'): string;
function IntToStrN(const i: int64; n: byte): string; overload;
function IntToStrN(const s: string; n: byte): string; overload;
function int64tostr(i: int64): string; // nur wrapper f¸r inttostr
function strtol(x: string): longint;
function str2int(const s: string): integer;
function str2int64(const s: string): integer;
function strtodword(s: string): dword;

// Revision-Sachen (Versions-Verwaltung)
function RevToStr(r: single): string;
function RevAsInteger(Rev: single): integer; overload;
function RevAsInteger(Rev: double): integer; overload;
function RevIsFrom(Rev, From: single): boolean; //
function RevIsBefore(Rev, Before: single): boolean; //
function GetRevision(const ProjectName: string): single;
procedure SetRevision(const ProjectName: string; Rev: single);

// Floating Point Sachen
function IntToExtended(const i: integer): extended;
function FloatToStrISO(Value: extended; Nachkommastellen: integer = 0): string;
function StrToDouble(x: string): double; overload;
function StrToDouble(x: string; var ValError : Boolean): double; overload;
function StrToDoubleDef(x: string; d: double): double;

// Str - Utils : Charsets
function asci(const x: string): string;

function Mac2Ansi(const x: AnsiString): AnsiString;

function Oem2Ansi(const x: AnsiString): AnsiString;
function Oem2asci(const x: AnsiString): AnsiString;
function Oem2utf8(const x: AnsiString): string;

function ANSI2OEM(x: AnsiString): AnsiString;
function ANSI2Mac(const x: AnsiString): AnsiString;
function ANSI_upper(const S: string): string;
function ANSI_lower(const S: string): string;

// Str - Utils : Delimter getrennte Daten
function NextP(var s: string; Delimiter: string = ';'): string; overload;
{$IFNDEF fpc}
function NextP(var s: AnsiString; Delimiter: string = ';'): AnsiString; overload;
{$ENDIF}
function NextP(var s: Shortstring; Delimiter: Shortstring = ';'): Shortstring; overload;
function NextP(s: string; Delimiter: string; SkipCount: integer): string; overload;
function FromP(s: string; Delimiter: string; SkipCount: integer): string;
function rNextP(var s: string; Delimiter: string): string;
function ReplaceP(s: string; Delimiter: string; SkipCount: integer; NewP: string): string;
function FieldCount(const s: string; Delimiter: char): integer;
function HugeSingleLine(s: TStrings; Delimiter: string = #13; MaxLines: integer = MaxInt; sFree: boolean = false): string;
function Split(s: string; Delimiter: string = ';'; Quote: string = ''; Trim: boolean = false): TStringList;
procedure WordWrap(s: TStrings; Columns:Integer);
procedure SetValueSmart(s: TStrings; Name: string; Value: string);

// TString Utils
function RemoveDuplicates(s: TStrings): integer; overload;
procedure RemoveDuplicates(s: TStrings; out DeleteCount: integer); overload;
procedure RemoveDuplicates(s: TStrings; out DeleteCount: integer; Dups: TStrings); overload;

// TStringList File-Utils
procedure LoadFromFileHugeLines(clear: boolean; s: TStrings; const FName: string);
procedure LoadFromFileCSV(clear: boolean; s: TStrings; const FName: string); // LF aware
procedure SaveToUnixFile(s: TStrings; const FName: string);
procedure AppendStringsToFile(s: TStrings; const FName: string; Encapsulate: string = ''); overload;
procedure AppendStringsToFile(s: string; const FName: string; Encapsulate: string = ''); overload;
procedure AppendIntegerStringsToFile(s: TStringList; FName: string; Encapsulate: string = '');

// DOS Utils
procedure UnpackTime(P: longint; var T: TDateTimeBorlandPascal);
procedure PackTime(T: TDateTimeBorlandPascal; var P: longint);

// aktuelles Datum und oder Uhrzeit
function JahresZahl: string; // YYYY
function sTimeStamp: string; // YYYYMMTT hh:mm:ss
procedure GetDate(var Year, Month, Day, dow: Word);
function NOW: TDateTime; // analog "now" ber¸cksichtigt aber TestMode

// deutsche Datumsangaben
function Datum: string; // TT.MM.YY
function Datum10: string; // TT.MM.YYYY
function DatumLog: string; // YYYYMMTT

// Wandlung Datum -> String
function long2date { 10 } (dlong: TAnfixDate): string; overload; // TT.MM.JJJJ
function long2date { 10 } (dlong: TDateTime): string; overload; // TT.MM.JJJJ
function long2date5(dlong: TAnfixDate): string; // TT.MM
function long2date6(dlong: longint): string; // JJMMTT
function long2date6r(dlong: longint): string; // TTMMJJ (r f¸r reverse!)
function long2date7(dlong: TAnfixDate): string; // MM.JJJJ
function long2date8(dlong: TAnfixDate): string; overload; // TT.MM.JJ
function long2date8(dlong: TDateTime): string; overload; // TT.MM.JJ
function long2dateLog(dlong: TAnfixDate): string; overload; // JJJJMMTT
function long2dateLog(dlong: TDateTime): string; overload; // JJJJMMTT
function long2dateText(dlong: TAnfixDate): string; //

// Lokalisierte Datumsangaben
function long2dateLocalized(dlong: TAnfixDate): string; overload;
function long2dateLocalized(dt: TDateTime): string; overload;
function DatumLocalized: string;

function long2datetime(dlong: TAnfixDate): TDateTime;
procedure long2datetimeBorlandPascal(dlong: TAnfixDate; var date: TDateTimeBorlandPascal);
procedure long2details(dlong: TAnfixDate; var j, m, T: integer);
function Details2Long(j, m, T: integer): TAnfixDate;
function extractYear(dlong: TAnfixDate): integer;
function extractMonth(dlong: TAnfixDate): integer;
function extractDay(dlong: TAnfixDate): integer;
function date2long(date: string): TAnfixDate;
function TimeStamp2long(date: string): TAnfixDate; // JJJJMMDD -> TAnfixDate
function DateGet: TAnfixDate; //
function WeekGet(ADate: TDateTime): integer; overload; // Wochen Nummer 1..53, Wechselt am Montag
function WeekGet(ADate: TAnfixDate): integer; overload; // Wochen Nummer
function WeekDay(ADate: TAnfixDate): byte; overload; // 1 = Montag .. 7 = Sonntag
function WeekDay(ADate: TDateTime): byte; overload; // 1 = Montag .. 7 = Sonntag
function WeekDayS(ADate: TAnfixDate): string;
function WeekDayL(ADate: TAnfixDate): string;

function FDate(const FName: string): TAnfixDate; // via "findfirst", alternativ "FileDate"
function DateTime2long(const dt: TDateTime): TAnfixDate; overload;
function DateTime2long(date: TDateTimeBorlandPascal): TAnfixDate; overload;
function DateTime2long(const dt: TDateTime; var ADate: TAnfixDate; var ASeconds: TAnfixTime): TAnfixDate; overload;
function LastDayOfMonth(dlong: TAnfixDate): integer;
function LastDateOfMonth(dlong: TAnfixDate): TAnfixDate; // Datum des letzten Tages dieses Monats
function MonthPeriod(Start: TAnfixDate; InitialStart: TAnfixDate = cIllegalDate): TAnfixDate; // result := Start + 1 Monat - 1 Tag
function DaysInYear(dlong: TAnfixDate): integer;
function dateDiff(d1, d2: TAnfixDate): longint; // d1<d2, computes the number of days between two dates
function datePlus(dlong: TAnfixDate; plus: integer): TAnfixDate;
function datePlusWorking(dlong: TAnfixDate; plus: integer): TAnfixDate;
function WerktagDatePlus(StartD: TAnfixDate; plus: integer): TAnfixDate;
function ThisMonth(dlong: TAnfixDate): TAnfixDate;
function NextMonth(dlong: TAnfixDate): TAnfixDate;
function PrevMonth(dlong: TAnfixDate): TAnfixDate;
function ThisQuartal(dlong: TAnfixDate): TAnfixDate;
function NextQuartal(dlong: TAnfixDate): TAnfixDate;
function PrevQuartal(dlong: TAnfixDate) : TAnfixDate;
function ThisYear(dlong: TAnfixDate): TAnfixDate;
function PrevYear(dlong: TAnfixDate) : TAnfixDate;
function NextYear(dlong: TAnfixDate) : TAnfixDate;
function NearestDate(dlong: TAnfixDate; WeekDay: integer): TAnfixDate;
function DateInside(d, dStart, dEnd: TAnfixDate): boolean;
function DateCollision(aStart, aEnd, bStart, bEnd: TAnfixDate): boolean;
function dateOK(dlong: TAnfixDate): boolean; overload;
function dateNotOK(dlong: TAnfixDate): boolean; overload;
function dateOK(dlong: string): boolean; overload;
function dateNotOK(dlong: string): boolean; overload;
function DateExact(dlong: TAnfixDate): boolean;

// Kalenderfunktionen
function Feiertag(ADate: TAnfixDate): boolean; // imp pend: Feiertage
function Kalenderwoche(ADate: TAnfixDate): integer; //
function Kalenderwochen(const Year: Word): Word;
function Kalenderwoche53(const Year: Word): boolean; overload;
function Kalenderwoche53(const DateTime: TDateTime): boolean; overload;
function Quartal(ADate: TAnfixDate): integer; //
function Schaltjahr(dlong: TAnfixDate): boolean;

// Zeit-Routinen ("Seconds"-Funktionen, komplette Zeitangaben in LongInts speichern)
function uhr: string; // HH " Uhr " SS
function uhr8: string; // HH:MM:SS
function uhr12: string; // HH:MM:SS:MMM
function ShortenTime(Zeit:string): String; // schneidet ":00" weg
procedure GetTime(var hr, Min, Sec, sec100: Word);
function TimeGet: TAnfixTime;
function Long2Time(x: TAnfixTime): string;
function UhrOK(secs: TAnfixTime): boolean;
function SecondsGet: TAnfixTime;
function UpTime: TAnfixTime;
function RunTime: TAnfixTime;
function FSeconds(const FName: string): TAnfixTime; // via "FindFirst", alternativ "FileSeconds"
function SecondsToStr(secs: longint): string; overload; // hh:mm:ss
function SecondsToStr(secs: TDateTime): string; overload; // hh:mm:ss
function SecondsToStr5(secs: TAnfixTime): string; // hh:mm
function SecondsToStr6(secs: TAnfixTime): string; // hhmmss
function SecondsToStr8(secs: TAnfixTime): string; // (h)hh:mm:ss
function SecondsToStr9(secs: TAnfixTime): string; // hhh:mm:ss
function StrToSeconds(Sstr: string): TAnfixTime; // aus hh, hh:mm, hh:mm:ss, hh Uhr mm
function StrToSecondsdef(Sstr: string; def: TAnfixTime): TAnfixTime;
function SecondsDiff(s1, s2: TAnfixTime): longint; overload; // s1>s2
function SecondsDiff(s1, s2: TDateTime): longint; overload; // s1>s2
function SecondsDiffABS(s1, s2: TAnfixTime): longint; overload; // s1>,=,<s2
function SecondsDiff(d1, s1, d2, s2: TAnfixTime): longint; overload; // s1>s2
function SecondsDiffABS(d1, s1, d2, s2: longint): longint; overload; // s1>,=,<s2
function SecondsOK(secs: TAnfixTime): boolean;
function SecondsAdd(s1, s2: longint): longint;
function dateTime2Seconds(dt: TDateTimeBorlandPascal): longint; overload;
function dateTime2Seconds(dt: TDateTime): TAnfixTime; overload;
function SecondsInside(s, s1, s2: TAnfixTime): boolean;
function VeryClose(d1,d2: TDateTime): boolean;

// kombinierte Datum+Uhr Routinen
procedure SecondsAddLong(d1, s1, plus: longint; var d2, s2: longint);
function mkDateTime(date: TAnfixDate; Time: TAnfixTime): TDateTime; overload;
function mkDateTime(s: string; dTimeStamp: boolean = false): TDateTime; overload;
function DatumUhr: string; // Zeitstempel Datum " " Uhr
function dTimeStamp(d: TDateTime): string; // JJJJMMTT hh:mm:ss (f¸r Logs und Sortierbarkeit / Vergleichbarkeit )
function dTimeStampISO(d: TDateTime): string; // JJJJ-MM-TT"T"hh:mm:ss

// File-Funktionen
function FileDelete(const Mask: string): boolean; overload;
function FileDelete(const Mask: string; OlderThan: TAnfixDate): boolean; overload;
function FileDelete(const Mask: string; OlderThan: TAnfixDate; RemainingFileCount: integer): boolean; overload;
function FileDeleteUntil(const Mask: string; RemainingFileCount: integer; sDiagnose : TStringList = nil): boolean;
function FileRetire(const FileName: string; OlderThan: TAnfixDate): boolean;
function FileCopy(const Mask, Dest: string; Move: boolean = false; Touch: boolean = false): boolean;
function FileVersionedCopy(const SourceFName, DestFName: string): boolean;
function FileMove(const Mask, Dest: string): boolean;
function FileOperationMove(Source, Destination: string): boolean;
function FileConcat(const Source1, Source2, Dest: string): boolean;
procedure FileLimitTo(const TextFName: string; MaximumSize: int64);
function FileReduce(const TextFName: string; MaximumSize: int64) : TStringList;
procedure FileEmpty(const FName: string);
procedure FileAlive(const FName: string);

function FileCompare(const FName1, FName2: string): boolean;
function FSize(FName: string): int64;
function FileDate(FName: string): TAnfixDate;
function FileSeconds(FName: string): TAnfixTime;
function FileDateTime(FName: string): TDateTime;
function FileTouched(FName: string): TDateTime;
function ValidateFName(x: string): string;
function ValidatePathName(x: string): string; // Pfadname OHNE Slash am Ende
function FileTouch(FName: string): boolean; overload; // Datei-Zeitstempel auf "now"
function FileTouch(FName: string; ToDate: TAnfixDate): boolean; overload;
function FileTouch(FName: string; ToDate: TAnfixDate; ToTime: TAnfixTime): boolean; overload;
function FileTouch(FileName: string; date: TDateTime): boolean; overload;
procedure FileRemoveBOM(FileName: string);
procedure SystemLog(Event: string); // system sysutils

// Directory Funktionen
procedure dir(const Mask: string; FileNames: TStrings; uppercase: boolean = true; ClearList: boolean = true); overload;
function dir(const Mask: string): integer; overload; // Anzahl von Dateien in diesem Verzeichnis
function dirs(const Path: string): TStringList; // List Sub{\Sub} Dirs without ".", "..", ".*" (recursively)
function DirExists(const dir: string): boolean;
function DirSize(dir: string): int64; // WARNING: Time consuming
function DirQuota(const Mask: string; SizeLimit: int64): boolean; // WARNING: Delete oldest Files to Ensure Quota
procedure CheckCreateDir(dir: string); // create dir (recursively)
function DirDelete(const Mask: string): boolean; overload;
function DirDelete(const Mask: string; OlderThan: TAnfixDate): boolean; overload;

// Drive-Function
function FSerial(DriveName: string): string;
function FVolume(DriveName: string): string;
function FisCD(DriveName: string): boolean;
function FisNetwork(DriveName: string): boolean;
function ExtractFileNameWithoutExtension(FileName: string): string;

// Time & Performance
function Frequently: LongWord; overload;
function Frequently(var LastTime: LongWord; DelayCount: LongWord): boolean; overload; // DelayCount [ms]
function RDTSC: int64; // ReaD Time Stamp Counter in [CPU-Clocks]
function RDTSCms: int64; // ReaD Time Stamp Counter in [ms]
procedure perfBegin(FName: string);
procedure perfStep(JobDescription: string = '');
procedure perfEnd;

// Command Line Parameter
function IsParam(x: string): boolean;
function getParam(x: string): string;

// Program Termination
function AlreadyRunning(ApplicationName: string): boolean;
procedure CloseAppSem;

{$ifdef MSWINDOWS}

// Win32 Sachen
function IsAdmin: boolean;
function SetPrivilege(privilegeName: string; enable: boolean): boolean;
procedure WindowsHerunterfahren;
procedure WindowsNeuStarten;
procedure WindowsAbmelden;
Procedure PostKeyEx32(key: Word; Const shift: TShiftState; specialkey: boolean);

// System Information
function CPUMhz: integer; // Frequence of CPU-Clock [MHz]
{$ifndef fpc}
function CPUUsage: integer; // 0-100 [%] !pending integration!
function FileVersion(const FName: string): string;
{$endif}
function UserName: string;
function ComputerName: string;
function Domain: string;
function Betriebssystem: string;

// spezielle Pfade , im Moment noch ¸ber JclSysInfo, mit Slash am Ende!
function ProgramFilesDir: string;
function ApplicationDataDir: string;

// aus eigener Kraft, wine Kompatibel
function PersonalDataDir: string;

// CD-Player Utils
function GetCDAutoRun: boolean;
procedure SetCDAutoRun(vAutoRun: boolean);
{$endif}

// Graphische Utils
function rXL(r: TRect): integer;
function rYL(r: TRect): integer;
function SizeCorrect(r: TRect): TRect;
function Sub2Rects(const r1, r2: TRect; var o1, o2: TRect): boolean;
procedure rInc(var r: TRect; xl, yl: integer);
function rValid(const r: TRect): boolean;
procedure rMoveto(var r: TRect; x, y: integer);
procedure rMove(var r: TRect; dx, dy: integer);
procedure rSize(const s: TRect; var d: TRect);
procedure rSetSize(xl, yl: integer; var d: TRect);
procedure rPercent(P: byte; cent: extended; var r: TRect);
procedure rZero(var r: TRect);

function mkrect(x, y, xl, yl: integer): TRect;
function InSide(const x, y: integer; const r: TRect): boolean; overload;
function InSide(const x, y: integer; Polygon: array of TPoint): boolean; overload;

function RectCollision(const a, b: TRect): boolean;
function Str2Rect(ValueStr: string): TRect;
function Str2Point(ValueStr: string): TPoint;
function rNull(const r: TRect): boolean;

// verschl¸sselung bin‰r
procedure DataScramble(var data; datasize: integer); overload;
procedure DataScramble(var data; datasize: integer; const key: string); overload;

// verschl¸sselung String
function StrEncode(const s: string; key: string): string;
function StrDecode(const s: string; key: string): string;
procedure AddStringsCR(s: TStrings; lines: string);
// Passwˆrter
function GeneratePwd(FromSet: string; PwdLength: integer): string;

// Datentypen-Konvertierung "bin‰re Strings"
// function dwordToBStr ( d : dword ) : string;
function IntToBStr(i: integer): string;
function WordToBStr(w: Word): string;
function BStrToInt(const s: string): integer;
function BStrToWord(const s: string): Word;

// function BStrTodword (const s : string ) : dword;
function Bin2HexStr(s: AnsiString): string; overload;
function Bin2HexStr(var d; DataLen: integer): string; overload;

function HexStr2Bin(s: string): string; overload;
procedure HexStr2Bin(s: string; var d); overload;

implementation

{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}

uses
{$IFDEF fpc}
  DateUtils, LConvEncoding,
{$IFDEF UNIX}
  BaseUnix,
{$ENDIF}
  fpchelper,
{$ELSE}
  JclSysInfo,
  System.Types,
{$ENDIF}
  math,
{$ifdef MSWINDOWS}
  shellapi,
{$endif}
  registry;

type
  montharray = array [1 .. 13] of integer;

  juldate = record
    yr: longint; { 0 .. 9999 }
    Day: longint; { 1 .. 366 }
  end;

  {$ifndef fpc}
  PtrUInt = dword;
  {$endif}

const
  monthtotal: montharray = (0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365);

var
  DateSeparator: char = '.';
  baseyear: Word = 1976;
  CPUUsageInit: boolean = false;
  AppSem: THandle;

function ExtractFileNameWithoutExtension(FileName: string): string;
begin
  result := copy(FileName, 1, pred(revPos('.', FileName)));
end;

function ExtractFilePath(const FileName: string): string;
var
  k: integer;
begin
  k := pos('\*\', FileName);
  if k > 0 then
    result := copy(FileName, 1, k)
  else
    result := SysUtils.ExtractFilePath(FileName);
end;

procedure Log(s:string; IsError: boolean=false);
begin
  if DebugMode or IsError then
   if (DebugLogPath<>'') then
   begin
{$ifdef CONSOLE}
    writeln(s);
{$endif}
    AppendStringsToFile(s,DebugLogPath+'anfix.log.txt');
   end;
end;

procedure UnpackTime(P: longint; var T: TDateTimeBorlandPascal);
var
  Wow: TDateTime;
  MSec: Word;
begin
  Wow := FileDateToDateTime(P);
  with T do
  begin
    decodedate(Wow, Year, Month, Day);
    decodetime(Wow, Hour, Min, Sec, MSec);
  end;
end;

{$ifdef fpc}

// Results of Freepascal-FileAge(fn,dt) <> Delphi-FileAge(fn, dt), it differs by
// 1 second (delphi value is correct) - so automated OrgaMon-Testing fails
// This overloaded FileAge do a better job

function FileAge(FileName: UnicodeString; out DT: TDateTime):boolean;
var
  Handle: THandle;
  FindData: TWin32FindDataW;
  lft: TFileTime;
  sft: Windows.SYSTEMTIME;
begin
 result := false;
 Handle := FindFirstFileW(Pwidechar(FileName), FindData);
  if (Handle <> INVALID_HANDLE_VALUE) then
  begin
    Windows.FindClose(Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
      if FileTimeToLocalFileTime(FindData.ftLastWriteTime, lft) then
        if FileTimeToSystemTime(lft, sft) then
        begin
          DT := EncodeDateTime(sft.Year, sft.Month, sft.Day, sft.Hour, sft.Minute, sft.Second, sft.MilliSecond);
          result := true;
        end;
  end;
end;
{$endif}

function FileDate(FName: string): TAnfixDate;
var
  _FileDateTime: TDateTime;
begin
  if FileAge(FName, _FileDateTime) then
    result := DateTime2long(_FileDateTime)
  else
    result := cIllegalDate;
end;

function FileSeconds(FName: string): TAnfixTime;
var
  _FileDateTime: TDateTime;
begin
  if FileAge(FName, _FileDateTime) then
    result := dateTime2Seconds(_FileDateTime)
  else
    result := 0;
end;

function FileDateTime(FName: string): TDateTime;
begin
  if not(FileAge(FName, result)) then
    result := 0;
end;

function FileTouched(FName: string): TDateTime;
var
 fh : THandle;
 SystemTimeValue: LongInt;
begin
 result := 0;
 repeat
  fh := FileOpen(FName, fmOpenRead or fmShareDenyNone);
  if (fh=INVALID_HANDLE_VALUE) then
   break;
  SystemTimeValue := FileGetDate(fh);
  if (SystemTimeValue<>-1) then
   result := FileDateToDateTime(SystemTimeValue);
  FileClose(fh);
 until yet;
end;

function FDate(const FName: string): TAnfixDate;
var
  sr: TSearchRec;
  DosError: integer;
begin
  result := 0;
  DosError := findfirst(FName, faAnyFile, sr);
  if (DosError = 0) then
  begin
{$IFDEF fpc}    //
    result := DateTime2long(sr.Time);
{$ELSE}
    result := DateTime2long(sr.TimeStamp);
{$ENDIF}
  end;
  findclose(sr);
end;

function FSeconds(const FName: string): TAnfixTime;
var
  sr: Tsearchrec;
  DosError: integer;
begin
  result := 0;
  DosError := findfirst(FName, faAnyFile, sr);
  if (DosError = 0) then
  begin
{$IFDEF fpc}    //
    result := dateTime2Seconds(sr.Time);
{$ELSE}
    result := dateTime2Seconds(sr.TimeStamp);
{$ENDIF}
  end;
  findclose(sr);
end;

function DateTime2long(const dt: TDateTime): TAnfixDate;
var
  y, m, d: Word;
begin
  decodedate(dt, y, m, d);
  result := Details2Long(y, m, d);
  if (result = 18991230) then
    result := cIllegalDate;
end;

function DateTime2long(const dt: TDateTime; var ADate: TAnfixDate; var ASeconds: TAnfixTime): TAnfixDate;
begin
  result := DateTime2long(dt);
  ADate := result;
  ASeconds := dateTime2Seconds(dt);
end;

function DateTime2long(date: TDateTimeBorlandPascal): TAnfixDate;
begin
  with date do
    result := Details2Long(Year, Month, Day);
end;

procedure PackTime(T: TDateTimeBorlandPascal; var P: longint);
begin
  // with t do
  // wow := encodedate(year,month,day) + encodetime(Hour,Min,Sec,0);
  // p := DateTimeToFileDate(now);
end;

function NOW: TDateTime;
begin
  if TestMode then
    result := encodedate(9999, 12, 31) + 0.5
  else
    result := SysUtils.NOW;
end;

function Datum: string;
var
  Year, Month, Day: Word;
begin
  if TestMode then
  begin
    result := '31.12.99';
  end
  else
  begin
    // Date tdatetime
    decodedate(SysUtils.NOW, Year, Month, Day);
    result := format('%2d.%2d.%4d', [Day, Month, Year]);
    ersetze(' ', '0', result);
    delete(result, 7, 2);
  end;
end;

function Datum10: string;
var
  Year, Month, Day: Word;
begin
  if TestMode then
  begin
    result := '31.12.9999';
  end
  else
  begin
    // Date tdatetime
    decodedate(SysUtils.NOW, Year, Month, Day);
    result := format('%2d.%2d.%4d', [Day, Month, Year]);
    ersetze(' ', '0', result);
  end;
end;

function DatumLog: string;
var
  Year, Month, Day: Word;
begin
  // Date tdatetime
  decodedate(SysUtils.NOW, Year, Month, Day);
  result := format('%4d%2d%2d', [Year, Month, Day]);
  ersetze(' ', '0', result);
end;

function sTimeStamp: string;
begin
  result := DatumLog + ' ' + uhr8;
end;

function dTimeStamp(d: TDateTime): string;
begin
  result := long2dateLog(d) + ' ' + SecondsToStr(d);
end;

function dTimeStampISO(d: TDateTime): string;
begin
  result := long2dateLog(d);
  insert('-',result,7);
  insert('-',result,5);
  result := result + 'T' + SecondsToStr(d);
end;

function JahresZahl: string;
var
  Year, Month, Day: Word;
begin
  // Date tdatetime
  if TestMode then
  begin
    result := '9999';
  end
  else
  begin
    decodedate(SysUtils.NOW, Year, Month, Day);
    result := format('%4d', [Year]);
    ersetze(' ', '0', result);
  end;
end;

function uhr: string;
var
  zeit: string;
begin
  zeit := SecondsToStr5(SecondsGet);
  result := copy(zeit, 1, 2) + cUhr + copy(zeit, 4, 2);
end;

function uhr8: string;
begin
  result := SecondsToStr(SecondsGet);
end;

function uhr12: string;
var
  h, m, s, ms: Word;
begin
  GetTime(h, m, s, ms);
  result := format('%2d:%2d:%2d:%3d',[h, m, s, ms]);
  ersetze(' ','0',result);
end;

function date2long(date: string): longint;
var
  Res: longint;
  T, m, j: Word;
  p1, p2: byte;
  dummy: integer;
  jStart, jEnde, jCheck: integer;
  cStart, cEnde: integer;
  _J: string;

  function ActJahr: integer;
  var
    dummy: integer;
  begin
    long2details(DateGet, result, dummy, dummy);
  end;

begin
  result := cIllegalDate;

  { String aufbereiten und in Format t.m.j bringen }
  date := cutblank(date);
  if length(date) = 0 then
    exit;

  // JJJJ-MM-TT
  if length(date) = 10 then
    if pos('-', date) = 5 then
      date := NextP(date, '-', 2) + DateSeparator + NextP(date, '-', 1) + DateSeparator + NextP(date, '-', 0);

  ersetze(',', DateSeparator, date);
  ersetze('-', DateSeparator, date);
  ersetze('/', DateSeparator, date);
  ersetze(' ', DateSeparator, date);

  p1 := pos(DateSeparator, date);
  if p1 = 0 then
  begin
    case length(date) of
      2:
        begin
          // interpretiert als "JJ"
          date := '01' + DateSeparator + '01' + DateSeparator + date;
        end;
      4:
        begin
          // interpretiert als "MMJJ"
          m := strtol(copy(date, 1, 2));
          if m <= 12 then
            date := '01' + DateSeparator + copy(date, 1, 2) + DateSeparator + copy(date, 3, 2)
          else
          begin
            result := strtol(date) * 10000;
            exit;
          end;
        end;
      5:
        begin
          // interpretiert als "TMMJJ"
          date := '0' + copy(date, 1, 1) + DateSeparator + copy(date, 2, 2) + DateSeparator + copy(date, 4, 2);
        end;
      6:
        begin
          // interpretiert als "TTMMJJ"
          date := copy(date, 1, 2) + DateSeparator + copy(date, 3, 2) + DateSeparator + copy(date, 5, 2);
        end;
      8:
        begin
          // interpretiert als "TTMMJJJJ"
          date := copy(date, 1, 2) + DateSeparator + copy(date, 3, 2) + DateSeparator + copy(date, 5, 4);
        end;
    end;
    p1 := pos(DateSeparator, date);
  end;

  if p1 = 0 then
    exit;

  date[p1] := '#';
  p2 := pos(DateSeparator, date);
  if (p2 > 0) then
  begin
    val(copy(date, 1, p1 - 1), T, dummy);
    if (T = 0) then
      T := 1;
    if (T < 1) or (T > 31) then
      exit;
  end
  else
  begin
    // MM.JJJ Interpretation
    T := 0;
    p2 := p1;
    p1 := 0;
  end;

  // Monat
  val(copy(date, p1 + 1, (p2 - p1) - 1), m, dummy);
  if (m = 0) then
    m := 1;
  if (m < 1) or (m > 12) then
    exit;

  // Jahr
  _J := copy(date, p2 + 1, 4);
  if (_J = '') then
    j := ActJahr
  else
    val(_J, j, dummy);

  if (dummy <> 0) then
  begin
    _J := copy(date, p2 + 1, 2);
    val(_J, j, dummy);
  end;

  if (j < 100) and (length(_J) < 3) then
  begin

    // Lˆsung : Das gleitenden Zeitfensters, Dokumentation siehe
    // https://wiki.orgamon.org/?title=Entwickler#Datum

    // Zeitfenster berechnen
    jStart := ActJahr - 75;
    jEnde := ActJahr + 24;

    // Start und Ende Jahrhundert berechnen
    cStart := (jStart DIV 100) * 100;
    cEnde := (jEnde DIV 100) * 100;

    // Nachsehen, welches Jahrhundert angebracht ist
    jCheck := cStart + j;
    repeat
      if (jStart <= jCheck) and (jCheck <= jEnde) then
        break;
      jCheck := cEnde + j;
    until yet;
    j := jCheck;

  end;

  Res :=
  { Jahr } longint(j) * cDATE_YEAR_FAKTOR +
  { Monat } longint(m) * cDATE_MONTH_FAKTOR +
  { Tag } longint(T);
  if dateOK(Res) then
    result := Res;
end;

function TimeStamp2long(date: string): TAnfixDate; // JJJJMMDD -> TAnfixDate
begin

  result := date2long(
    { } copy(date, 7, 2) + '.' +
    { } copy(date, 5, 2) + '.' +
    { } copy(date, 1, 4));
end;

// Gerald Rohr
// function leapyear

function Schaltjahr(dlong: longint): boolean;
var
  dat: TDateTimeBorlandPascal;
  yr: Word;
begin
  if (dlong < 9999) then
  begin
    yr := dlong;
  end
  else
  begin
    long2datetimeBorlandPascal(dlong, dat);
    yr := dat.Year;
  end;
  Schaltjahr := ((yr mod 4 = 0) and (not(yr mod 100 = 0))) or (yr mod 400 = 0);
end;

procedure long2datetimeBorlandPascal(dlong: longint; var date: TDateTimeBorlandPascal);
var
  r: longint;
begin
  with date do
  begin
    Day := (dlong mod 100);
    r := dlong div 100;
    Month := (r mod 100);
    Year := (r div 100);
  end;
end;

function DaysInYear(dlong: TAnfixDate): integer;
var
  j, m, T: integer;
begin
  long2details(dlong, j, m, T);
  if Schaltjahr(j) then
    result := 366
  else
    result := 365;
end;

function LastDateOfMonth(dlong: TAnfixDate): TAnfixDate;
var
  j, m, T: integer;
begin
  long2details(dlong, j, m, T);
  result := Details2Long(j, m, LastDayOfMonth(dlong));
end;

function MonthPeriod(Start: TAnfixDate; InitialStart: TAnfixDate = cIllegalDate): TAnfixDate;
// F¸r monatliche Abrechnungen wird ein passender Zeitraum berechent:
// MonthPeriod(01.01.,01.) = 31.01.
// MonthPeriod(01.02.,01.) = 30.02.
// MonthPeriod(30.01.,30.) = 27.02. | (28.02) = 29.03 | (30.03) - 29
// Es werden 2 Pr‰missen beachtet:
// 1) der 'folgende' Tag, sollte maximal aus dem nachfolgenden Monat sein
// 2) der 'folgende' Tag, nach dem berechneten *sollte*
//    wiederum der Tag des 'InitialStart' sein
var
  j, m, T, d: integer;
  d1, d2: TAnfixDate;
begin
  long2details(Start, j, m, T);
  if DateOK(InitialStart) then
    d := extractDay(InitialStart)
  else
    d := T;
  if (d=1) then
  begin
   // Beginn am Monats Ersten ist einfach!
   result := LastDateOfMonth(Start);
   exit;
  end;
  // versuche d-1.m+1.j wobei es NICHT der letzte Tag des Monats sein darf
  inc(m);
  if (m>12) then
  begin
    inc(j);
    m := 1;
  end;
  // theoretisch optimales Datum, jedoch u.U. zu weit in der Zukunft
  d2 := Details2Long(j, m, d-1);
  // reales Datum welches das folgende Datum im selben Monat l‰sst!
  d1 := DatePlus(LastDateOfMonth(d2), -1);
  result := min(d1, d2);
end;

function LastDayOfMonth(dlong: TAnfixDate): integer;
var
  j, m, T: integer;
begin
  long2details(dlong, j, m, T);
  case m of
    2:
      if Schaltjahr(j) then
        result := 29
      else
        result := 28;
    4, 6, 9, 11:
      result := 30;
  else
    result := 31;
  end;
end;

function dateOK(dlong: string): boolean;
begin
  result := dateOK(date2long(dlong));
end;

function dateNotOK(dlong: string): boolean;
begin
  result := not(dateOK(dlong));
end;

function dateOK(dlong: longint): boolean;
{ tests a string-date }
var
  yr, mm, dd: integer;
  ok: boolean;
  bufdat: TDateTimeBorlandPascal;
label raus;
begin
  ok := false;
  if (dlong = cIllegalDate) then
    goto raus;

  long2datetimeBorlandPascal(dlong, bufdat);

  yr := bufdat.Year;
  if (yr < 0) or (yr > 9999) then
    goto raus;

  mm := bufdat.Month;
  if (mm < 0) or (mm > 12) then
    goto raus;

  dd := bufdat.Day;
  if (mm = 0) and (dd <> 0) then
    goto raus;
  if dd = 0 then
    dd := 1;
  if (dd < 1) or (dd > 31) then
    goto raus;

  case mm of
    2:
      if dd > 28 then
      begin
        if dd > 29 then
        begin
          goto raus;
        end
        else
        begin
          if not Schaltjahr(yr) then
            goto raus;
        end;
      end;
    4, 6, 9, 11:
      begin
        if dd > 30 then
          goto raus;
      end;
  end;
  ok := true;
raus:
  dateOK := ok;
end;

function UhrOK(secs: TAnfixTime): boolean;
begin
  result := (secs >= 0) and (secs < cOneDayInSeconds);
end;

function dateNotOK(dlong: longint): boolean;
begin
  result := not(dateOK(dlong));
end;

function DateExact(dlong: TAnfixDate): boolean;
var
  m, T: integer;
begin
  dlong := dlong mod 10000;
  m := dlong div 100;
  dlong := dlong mod 100;
  T := dlong;
  result := dateOK(dlong) and (m > 0) and (T > 0);
end;

function long2dateLog(dlong: TAnfixDate): string; // JJJJMMJJ
var
  j, m, T: Word;
  ZStr: string;
begin
  if (dlong < 0) or (dlong > cMaxDate) then
    dlong := 0;
  if (dlong = 0) then
  begin
    result := fill(' ', 10);
    exit;
  end;

  j := dlong div 10000;
  dlong := dlong mod 10000;
  m := dlong div 100;
  dlong := dlong mod 100;
  T := dlong;

  // Jahr
  str(j: 4, ZStr);
  ersetze(' ', '0', ZStr);
  result := ZStr;

  // Monat
  str(m: 2, ZStr);
  ersetze(' ', '0', ZStr);
  result := result + ZStr;

  // Tag
  str(T: 2, ZStr);
  ersetze(' ', '0', ZStr);
  result := result + ZStr;

end;

function long2date { 10 } (dlong: longint): string; overload;
var
  j, m, T: Word;
  ZStr: string;
  Res: string[10];
begin
  if (dlong < 0) or (dlong > cMaxDate) then
    dlong := 0;
  if (dlong = 0) then
  begin
    long2date := fill(' ', 10);
    exit;
  end;
  j := dlong div 10000;
  dlong := dlong mod 10000;
  m := dlong div 100;
  dlong := dlong mod 100;
  T := dlong;
  // Tag
  if T > 0 then
  begin
    str(T: 2, ZStr);
    ersetze(' ', '0', ZStr);
    Res := ZStr + DateSeparator;
  end
  else
  begin
    Res := '';
  end;
  // Monat
  if (m > 0) then
  begin
    str(m: 2, ZStr);
    ersetze(' ', '0', ZStr);
    Res := Res + ZStr + DateSeparator;
  end
  else
  begin
    Res := '';
  end;
  // Jahr
  str(j: 4, ZStr);
  ersetze(' ', '0', ZStr);
  Res := Res + ZStr;
  long2date := Res;
end;

function long2dateLog(dlong: TDateTime): string; // JJJJMMJJ
begin
  result := long2dateLog(DateTime2long(dlong));
end;

function long2date(dlong: TDateTime): string; overload;
begin
  result := long2date(DateTime2long(dlong));
end;

function long2dateLocalized(dlong: TAnfixDate): string; overload;
begin
  //
  if (dlong <> cIllegalDate) then
  begin
    result := long2date(dlong);
    // Nur internationalisieren wenn vollst‰ndiges Datum
    if (length(result) = 10) then
      result := long2dateLocalized(long2datetime(dlong));
  end
  else
    result := '';
end;

function long2dateLocalized(dt: TDateTime): string; overload;
begin
  //
  result := '';
  try
    if (dt > 0) and (dt < cMaxDateTime) then
      result := DateToStr(dt);
  except
    ;
  end;
end;

function long2date8(dlong: longint): string;
begin
  result := long2date(dlong);
  delete(result, length(result) - 3, 2);
end;

function long2date8(dlong: TDateTime): string;
begin
  result := long2date(dlong);
  delete(result, length(result) - 3, 2);
end;

function long2date7(dlong: longint): string;
begin
  result := long2date(dlong);
  delete(result, 1, 3);
end;

function long2date5(dlong: longint): string;
begin
  result := copy(long2date(dlong), 1, 5);
end;

function long2date6(dlong: longint): string; // JJMMTT
begin
  result := long2date(dlong);
  result := copy(result, 8, 2) + copy(result, 3, 2) + copy(result, 1, 2);
end;

function long2date6r(dlong: longint): string; // TTMMJJ
begin
  result := long2date(dlong);
  result := copy(result, 1, 2) + copy(result, 4, 2) + copy(result, 9, 2);
end;

function long2dateText(dlong: TAnfixDate): string;
var
  j, m, T, d: Word;
begin
  if (dlong < 0) or (dlong > cMaxDate) then
    dlong := 0;
  if dlong = 0 then
  begin
    result := '';
    exit;
  end;
  d := WeekDay(dlong);
  j := dlong div 10000;
  dlong := dlong mod 10000;
  m := dlong div 100;
  dlong := dlong mod 100;
  T := dlong;
  result := cTageNamenLang[d] + ', ' + inttostr(T) + '. ' + cMonatNamenLang[m] + ' ' + inttostr(j);
end;

function long2datetime(dlong: TAnfixDate): TDateTime;
var
  Mydate: TDateTimeBorlandPascal;
begin
  // fillchar(MyDate,sizeof(MyDate),0);
  long2datetimeBorlandPascal(dlong, Mydate);
  with Mydate do
    result := encodedate(Year, Month, Day);
end;

procedure GetDate(var Year, Month, Day, dow: Word);
var
  Mydate: TDateTime;
begin
  Mydate := SysUtils.NOW;
  decodedate(Mydate, Year, Month, Day); // encodetime
  dow := DayOfWeek(Mydate);
end;

function WeekDay(ADate: TAnfixDate): byte; // 1= Montag, 7=Sonntag
begin
  result := pred(DayOfWeek(long2datetime(ADate)));
  if (result = 0) then
    result := cDATE_SONNTAG;
end;

function WeekDay(ADate: TDateTime): byte; // 1= Montag, 7=Sonntag
begin
  result := pred(DayOfWeek(ADate));
  if (result = 0) then
    result := cDATE_SONNTAG;
end;

function WeekDayS(ADate: TAnfixDate): string;
var
  d: integer;
begin
  d := WeekDay(ADate);
  if (d > 0) then
    result := cTageNamenKurz[d]
  else
    result := '???';
end;

function WeekDayL(ADate: TAnfixDate): string;
var
  d: integer;
begin
  d := WeekDay(ADate);
  if (d > 0) then
    result := cTageNamenLang[d]
  else
    result := '???';
end;
// Calculates and returns Easter Day for specified year.
// Originally from Mark Lussier, AppVision <MLussier att best dott com>.
// Corrected to prevent integer overflow if it is inadvertedly
// passed a year of 6554 or greater.

function EasterSunday(const Year: integer): TDateTime;
var
  Month, Day, Moon, Epact, Sunday, Gold, cent, Corx, Corz: integer;
begin
  { The Golden Number of the year in the 19 year Metonic Cycle: }
  Gold := Year mod 19 + 1;
  { Calculate the Century: }
  cent := Year div 100 + 1;
  { Number of years in which leap year was dropped in order... }
  { to keep in step with the sun: }
  Corx := (3 * cent) div 4 - 12;
  { Special correction to syncronize Easter with moon's orbit: }
  Corz := (8 * cent + 5) div 25 - 5;
  { Find Sunday: }
  Sunday := (longint(5) * Year) div 4 - Corx - 10;
  { ^ To prevent overflow at year 6554 }
  { Set Epact - specifies occurrence of full moon: }
  Epact := (11 * Gold + 20 + Corz - Corx) mod 30;
  if Epact < 0 then
    Epact := Epact + 30;
  if ((Epact = 25) and (Gold > 11)) or (Epact = 24) then
    Epact := Epact + 1;
  { Find Full Moon: }
  Moon := 44 - Epact;
  if Moon < 21 then
    Moon := Moon + 30;
  { Advance to Sunday: }
  Moon := Moon + 7 - ((Sunday + Moon) mod 7);
  if Moon > 31 then
  begin
    Month := 4;
    Day := Moon - 31;
  end
  else
  begin
    Month := 3;
    Day := Moon;
  end;
  result := encodedate(Year, Month, Day);
end;

function Feiertag(ADate: TAnfixDate): boolean;
var
  m, d, y: integer;
  KarFreitag, OsterSonntag, OsterMOntag: TAnfixDate;

  (*
    Feiertage nach Target2, z.B. 2014
    =================================
    1. Januar 2014 , Neujahr
    18. April 2014 , Karfreitag
    21. April 2014 , Ostermontag
    1. Mai 2014, Tag der Arbeit
    25. Dezember 2014, 1. Weichnachtsfeiterg
    26. Dezember 2014, 2. Weihnachtsfeiertag

    Optimierung
    ===========
    Ostersonntag kann nur zwischen 22. M‰rz und dem 25. April sein
    Karfreitag w‰re dann fr¸hestens am 20. M‰rz
    Ostermontag w‰re dann sp‰testens am 26. April
  *)

begin

  // Sonntag
  result := (WeekDay(ADate) = 7);
  if result then
    exit;

  long2details(ADate, y, m, d);

  // Neujahr
  result := (m = 1) and (d = 1);
  if result then
    exit;

  // 1. Mai
  result := (m = 5) and (d = 1);
  if result then
    exit;

  // Weihnacht
  result := (m = 12) and ((d = 25) or (d = 26));
  if result then
    exit;

  // im Osterzeitraum?
  if
  { } (m < 3) or
  { } (m > 4) or
  { } ((m = 3) and (d < 20)) or
  { } ((m = 4) and (d > 26)) then
    exit;

  OsterSonntag := DateTime2long(EasterSunday(y));

  OsterMOntag := datePlus(OsterSonntag, 1);
  result := (ADate = OsterMOntag);
  if result then
    exit;

  KarFreitag := datePlus(OsterSonntag, -2);
  result := (ADate = KarFreitag);
  if result then
    exit;

end;

// Determines if the ISO Year is ordinary  (52 weeks) or Long (53 weeks). Uses a rule first
// suggested by Sven Pran (Norway) and Lars Nordentoft (Denmark) - according to
// http://www.phys.uu.nl/~vgent/calendar/isocalendar.htm

function Kalenderwoche53(const Year: Word): boolean;
var
  TmpWeekday: Word;
  dt: TDateTime;
begin
  dt := encodedate(Year, 1, 1);
  TmpWeekday := WeekDay(dt);
  result := (IsLeapYear(Year) and ((TmpWeekday = 3) or (TmpWeekday = 4))) or (TmpWeekday = 4);
end;

function Kalenderwoche53(const DateTime: TDateTime): boolean;
var
  y, m, d: Word;
begin
  decodedate(DateTime, y, m, d);
  result := Kalenderwoche53(y);
end;

function Kalenderwochen(const Year: Word): Word;
begin
  if Kalenderwoche53(Year) then
    result := 53
  else
    result := 52;
end;

// ISOWeekNumber function returns Integer 1..7 equivalent to Sunday..Saturday.
// ISO 8601 weeks start with Monday and the first week of a year is the one which
// includes the first Thursday

function ISOWeekNumber(dt: TDateTime): integer;
var
  January4th: TDateTime;
  FirstMonday: TDateTime;

  _y, y, YearOfWeekNumber, m, d, wd: Word;
begin
  // Applying the rule: The first calender week is the week that includes January, 4th
  decodedate(dt, y, m, d);
  _y := y;

  wd := WeekDay(dt);
  // adjust if we are between 12/29 and 12/31
  if (m = 12) and (d >= 29) and (wd <= 3) then
    y := y + 1;

  January4th := encodedate(y, 1, 4);
  FirstMonday := January4th + 1 - WeekDay(January4th);

  // If our date is < FirstMonday we are in the last week of the previous year
  if dt < FirstMonday then
  begin
    result := Kalenderwochen(y - 1);
    YearOfWeekNumber := y - 1;
    exit;
  end
  else
  begin
    YearOfWeekNumber := y;
    result := (Trunc(dt - FirstMonday) div 7) + 1;
  end;

  if result > Kalenderwochen(_y) then
    result := Kalenderwochen(_y);
end;

function Kalenderwoche(ADate: TAnfixDate): integer; //
begin
  if dateOK(ADate) then
    result := ISOWeekNumber(long2datetime(ADate))
  else
    result := 0;
end;

function Quartal(ADate: TAnfixDate): integer; //
begin
  if dateOK(ADate) then
    result := succ(extractMonth(ADate) DIV 3)
  else
    result := 0;
end;

function WeekGet(ADate: TAnfixDate): integer;
var
  dt: TDateTime;
begin
  if dateOK(ADate) then
  begin
    dt := long2datetime(ADate);
    result := WeekGet(dt);
  end
  else
  begin
    result := 0;
  end;
end;

function WeekGet(ADate: TDateTime): integer;
//
// Calculates calendar week assuming:
// - Monday is the 1st day of the week.
// - The 1st calendar week is the 1st week
// of the year that contains a Thursday.
//
// If result is 53, then previous year is assumed.
//
var
  Day: Word;
  dayOne: Word;
  firstOfYear: TDateTime;
  Month: Word;
  monthOne: Word;
  Year: Word;
begin
  decodedate(ADate, Year, Month, Day);

  case DayOfWeek(encodedate(Year, 1, 1)) of
    1:
      dayOne := 2; // Sunday
    2:
      dayOne := 1; // Monday
    3:
      dayOne := 31; // Tuesday
    4:
      dayOne := 30; // Wednesday
    5:
      dayOne := 29; // Thursday
    6:
      dayOne := 4; // Friday
  else
    dayOne := 3; // Saturday
  end;

  if (dayOne > 4) then
  begin
    Dec(Year);
    monthOne := 12
  end
  else
    monthOne := 1;

  firstOfYear := encodedate(Year, monthOne, dayOne);

  if (ADate < firstOfYear) then
    result := 53
  else
    result := (Trunc(ADate - firstOfYear) div 7) + 1;
end;

function DateGet: TAnfixDate;
begin
  result := DateTime2long(date);
end;

procedure GetTime(var hr, Min, Sec, sec100: Word);
begin
  decodetime(SysUtils.NOW, hr, Min, Sec, sec100);
end;

function SecondsGet: longint;
var
  h, m, s, ms: Word;
begin
  if TestMode then
  begin
    result := cNoon;
  end
  else
  begin
    GetTime(h, m, s, ms);
    SecondsGet := longint(h) * cOneHourInSeconds + longint(m) * cOneMinuteInSeconds + longint(s);
  end;
end;

function SecondsAdd(s1, s2: longint): longint;
begin
  SecondsAdd := (s1 + s2) mod (24 * cOneHourInSeconds);
end;

procedure SecondsAddLong(d1, s1, plus: longint; var d2, s2: longint);
var
  FullDays: integer;
begin
  FullDays := (s1 + plus) div (24 * cOneHourInSeconds);
  s2 := SecondsAdd(s1, plus);
  d2 := datePlus(d1, FullDays);
end;

function VeryClose(d1,d2: TDateTime): boolean;
const
  TwoSecondsPeriodAsDateTime : double = 2.0 / pred(cOneDayInSeconds);
begin
  result := (abs(d1-d2)<TwoSecondsPeriodAsDateTime);
end;

function SecondsOK(secs: TAnfixTime): boolean;
begin
  result := (secs >= 0) and (secs < 24 * cOneHourInSeconds);
end;

function SecondsInside(s, s1, s2: TAnfixTime): boolean;
begin
  if s2 > s1 then
  begin
    result := (s >= s1) and (s <= s2);
  end
  else
  begin
    result := (s >= s1) or (s <= s2);
  end;
end;

function SecondsDiff(s1, s2: TAnfixTime): longint;
begin
  if (s1 < s2) then
    inc(s1, 24 * cOneHourInSeconds);
  result := s1 - s2;
end;

function SecondsDiffABS(s1, s2: TAnfixTime): longint; overload;
begin
  result := abs(s1 - s2);
end;

function SecondsDiff(d1, s1, d2, s2: longint): longint;
var
  FullDays: integer;
begin
  if (d1 = d2) then
  begin
    result := s1 - s2;
  end
  else
  begin
    FullDays := Min(pred(dateDiff(d2, d1)), 40); //
    result := (24 * cOneHourInSeconds - s2) + (FullDays * 24 * cOneHourInSeconds) + s1;
  end;
end;

function SecondsDiff(s1, s2: TDateTime): longint; overload;
begin
  result := SecondsDiff(
    { } DateTime2long(s1),
    { } dateTime2Seconds(s1),
    { } DateTime2long(s2),
    { } dateTime2Seconds(s2));
end;

function SecondsDiffABS(d1, s1, d2, s2: longint): longint;
var
  FullDays: integer;
begin
  if (d1 = d2) then
  begin
    result := abs(s1 - s2);
  end
  else
  begin
    FullDays := Min(pred(dateDiff(d2, d1)), 40); //
    result := abs((24 * cOneHourInSeconds - s2) + (FullDays * 24 * cOneHourInSeconds) + s1);
  end;
end;

function fill(ch: string; i: integer): string;
var
  n: integer;
begin
  result := '';
  for n := 1 to i do
    result := result + ch;
end;

function killLeadingZero(s: string): string;
begin
  result := s;
  repeat
    if length(result) < 2 then
      break;
    if (result[1] = '0') then
      system.delete(result, 1, 1)
    else
      break;
  until eternity;
end;

procedure bfill(var x: string; Size: byte);
begin
  x := copy(x, 1, Size);
  x := x + fill(' ', Size - length(x));
end;

function bstr(const x: string; Size: byte): string;
begin
  result := copy(x, 1, Size);
  bfill(result, Size);
end;

procedure ersetze(s: TStrings; var d: string); overload;
var
  n: integer;
begin
  if (pos('~', d) > 0) then
  begin
    for n := 0 to pred(s.Count) do
      if pos('=', s[n]) > 0 then
        ersetze('~' + NextP(s[n], '=', 0) + '~', NextP(s[n], '=', 1), d);
  end;
end;

procedure ersetze(const find_str, ersetze_str: string; var d: String);
var
  i: integer;
  l: integer;
  WorkStr: String;
begin
  i := pos(find_str, d);
  if (i = 0) then
    exit;
  if (find_str = ersetze_str) or (find_str = '') or (d = '') then
    exit;
  WorkStr := d;
  d := '';
  l := length(find_str);
  while (i > 0) do
  begin
    d := d + copy(WorkStr, 1, pred(i)) + ersetze_str;
    WorkStr := copy(WorkStr, i + l, MaxInt);
    i := pos(find_str, WorkStr);
  end;
  d := d + WorkStr;
end;

{$ifndef FPC}
procedure ersetze(const find_str, ersetze_str: string; var d: AnsiString);
var
  i: integer;
  l: integer;
  WorkStr: AnsiString;
begin
  i := pos(find_str, d);
  if (i = 0) then
    exit;
  if (find_str = ersetze_str) or (find_str = '') or (d = '') then
    exit;
  WorkStr := d;
  d := '';
  l := length(find_str);
  while (i > 0) do
  begin
    d := d + copy(WorkStr, 1, pred(i)) + ersetze_str;
    WorkStr := copy(WorkStr, i + l, MaxInt);
    i := pos(find_str, WorkStr);
  end;
  d := d + WorkStr;
end;
{$endif}

procedure ersetze(const find_str, ersetze_str: string; var d: Shortstring);
var
  WorkStr: string;
begin
  WorkStr := d;
  ersetze(find_str, ersetze_str, WorkStr);
  d := WorkStr;
end;

procedure ersetze(const find_str, ersetze_str: string; s: TStrings; Index: integer); overload;
var
  _s: string;
begin
  _s := s[Index];
  ersetze(find_str, ersetze_str, _s);
  s[Index] := _s;
end;

procedure ersetze(const find_str, ersetze_str: string; s: TStrings); overload;
var
  n: integer;
begin
  for n := 0 to pred(s.Count) do
    ersetze(find_str, ersetze_str, s, n);
end;

procedure ersetzeUpper(find_str, ersetze_str: string; var d: string);
var
  Mystr: string;
  OffsetByNow: integer;
  PatchList: TList;
  n, k: integer;
  Fl, dl: integer; // findLength, DifferenceLength
begin
  //
  Fl := length(find_str);
  dl := length(find_str) - length(ersetze_str);
  PatchList := TList.create;
  OffsetByNow := 0;
  Mystr := AnsiUpperCase(d);
  find_str := AnsiUpperCase(find_str);

  // erst mal alle Vorkommnisse abchecken
  repeat
    k := pos(find_str, Mystr);
    if k = 0 then
      break;
    PatchList.add(pointer(OffsetByNow + k));
    delete(Mystr, 1, pred(k + Fl));
    inc(OffsetByNow, pred(k + Fl));
  until eternity;

  // jetzt das resultat patchen
  OffsetByNow := 0;
  for n := 0 to pred(PatchList.Count) do
  begin
    d := copy(d, 1, pred(integer(PatchList[n]) - OffsetByNow)) + ersetze_str +
      copy(d, (integer(PatchList[n]) - OffsetByNow) + Fl, MaxInt);
    inc(OffsetByNow, dl);
  end;
  PatchList.free;

end;

function reverseSort(s: string): string;
const
  sReverse = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
  i, n: integer;
begin
  result := AnsiUpperCase(s);
  ersetze('ƒ', 'A', result);
  ersetze('÷', 'O', result);
  ersetze('‹', 'U', result);
  ersetze('ﬂ', 'S', result);
  for i := 1 to length(s) do
  begin
    n := pos(result[i], sReverse);
    if (n > 0) then
      result[i] := sReverse[length(sReverse) - pred(n)]
    else
      result[i] := '*'
  end;
end;

function btostr(b: byte; st: byte): string;
var
  s: string;
begin
  str(b: st, s);
  btostr := s;
end;

function TimeGet: longint;
var
  h, m, s, ms: Word;
begin
  GetTime(h, m, s, ms);
  TimeGet := longint(h) * 1000000 + longint(m) * 10000 + longint(s) * 100 + longint(ms);
end;

function Long2Time(x: TAnfixTime): string;
var
  OutStr: string;
  h, m, s: byte;
begin
  h := x div 1000000;
  x := x mod 1000000;
  m := x div 10000;
  x := x mod 10000;
  s := x div 100;
  OutStr := btostr(h, 2) + ':' + btostr(m, 2) + ':' + btostr(s, 2);
  ersetze(' ', '0', OutStr);
  Long2Time := OutStr;
end;

function dateTime2Seconds(dt: TDateTimeBorlandPascal): TAnfixTime;
begin
  dateTime2Seconds := longint(dt.Hour) * cOneHourInSeconds + longint(dt.Min) * cOneMinuteInSeconds + longint(dt.Sec);
end;

function dateTime2Seconds(dt: TDateTime): TAnfixTime;
var
  h, m, s, ms: Word;
begin
  decodetime(dt, h, m, s, ms);
  result := longint(h) * cOneHourInSeconds + longint(m) * cOneMinuteInSeconds + longint(s);
end;

function SecondsToStr(secs: longint): string;
var
  h, m, s: integer;
  OutStr: string;
  Negative: boolean;
begin
  //
  if (secs < 0) then
  begin
    Negative := true;
    secs := abs(secs);
  end
  else
    Negative := false;

  h := secs div (cOneHourInSeconds);
  secs := secs - (h * cOneHourInSeconds);
  m := secs div cOneMinuteInSeconds;
  secs := secs - (m * cOneMinuteInSeconds);
  s := secs;
  OutStr := IntToStrN(h, 2) + ':' + IntToStrN(m, 2) + ':' + IntToStrN(s, 2);

  if Negative then
    SecondsToStr := '-' + OutStr
  else
    SecondsToStr := OutStr;

end;

function SecondsToStr(secs: TDateTime): string;
begin
  result := SecondsToStr(dateTime2Seconds(secs));
end;

function SecondsToStr9(secs: longint): string;
var
  h, m, s: integer;
  OutStr: string;
  Negative: boolean;
begin
  //
  if (secs < 0) then
  begin
    Negative := true;
    secs := abs(secs);
  end
  else
    Negative := false;

  h := secs div (cOneHourInSeconds);
  secs := secs - (h * cOneHourInSeconds);
  m := secs div cOneMinuteInSeconds;
  secs := secs - (m * cOneMinuteInSeconds);
  s := secs;
  OutStr := IntToStrN(h, 3) + ':' + IntToStrN(m, 2) + ':' + IntToStrN(s, 2);
  ersetze(' ', '0', OutStr);

  if Negative then
    SecondsToStr9 := '-' + OutStr
  else
    SecondsToStr9 := OutStr;
end;

function SecondsToStr8(secs: longint): string;
begin
  SecondsToStr8 := copy(SecondsToStr9(secs), 2, 8);
end;

function SecondsToStr6(secs: longint): string;
var
  _OutStr: string;
begin
  _OutStr := SecondsToStr9(secs);
  result := copy(_OutStr, 2, 2) + copy(_OutStr, 5, 2) + copy(_OutStr, 8, 2);
end;

function SecondsToStr5(secs: longint): string;
begin
  SecondsToStr5 := copy(SecondsToStr(secs), 1, 5)
end;

function StrToSeconds(Sstr: string): longint;
var
  h, m, s: Word;
  Faktor: integer;

  procedure ReadNext(var w: Word);
  var
    dpos: byte;
    NumStr: string[3];
    dummy: integer;
  begin
    if Sstr = '' then
    begin
      w := 0;
    end
    else
    begin
      dpos := pos(':', Sstr);
      if (dpos > 0) then
      begin
        NumStr := copy(Sstr, 1, pred(dpos));
        Sstr := copy(Sstr, succ(dpos), 255);
        val(NumStr, w, dummy);
      end
      else
      begin
        val(Sstr, w, dummy);
        Sstr := '';
      end;
    end;
  end;

begin
  ersetze(cUhr, ':', Sstr);
  Sstr := noblank(Sstr);
  if pos('-', Sstr) > 0 then
  begin
    Faktor := -1;
    ersetze('-', '', Sstr);
  end
  else
  begin
    Faktor := 1;
  end;

  ReadNext(h);
  ReadNext(m);
  ReadNext(s);
  StrToSeconds := (longint(h) * longint(cOneHourInSeconds) + longint(m) * longint(cOneMinuteInSeconds) + longint(s)
    ) * Faktor;
end;

function StrToSecondsdef(Sstr: string; def: longint): longint;
begin
  result := StrToSeconds(Sstr);
  if result = 0 then
    result := def;
end;

function noblank(const InpStr: string): string; overload;
var
  i: integer;
begin
  result := InpStr;
  repeat
    i := pos(' ', result);
    if i = 0 then
      i := pos(#9, result);
    if i = 0 then
      break;
    delete(result, i, 1);
  until eternity;
end;

procedure noblank(const sl: TStringList); overload;
var
  n: integer;
begin
  for n := pred(sl.Count) downto 0 do
  begin
    sl[n] := noblank(sl[n]);
    if (length(sl[n]) = 0) then
      sl.delete(n);
  end;
end;

function noDoubleBlank(s: string): string;
var
  k: integer;
begin
  repeat
    k := pos('  ', s);
    if k = 0 then
      break;
    system.delete(s, k, 1);
  until eternity;
  result := s;
end;

function cutblank(const InpStr: string): string;
var
  OutStr: string;
begin
  OutStr := InpStr;
  while (OutStr <> '') and ((OutStr[1] = ' ') or (OutStr[1] = #160)) do
    delete(OutStr, 1, 1);
  while (OutStr <> '') and ((OutStr[length(OutStr)] = ' ') or (OutStr[length(OutStr)] = #160)) do
    delete(OutStr, length(OutStr), 1);
  cutblank := OutStr;
end;

function cutblank(s: TStrings): boolean;
var
  n, l: integer;
  Aenderungen: integer;
begin
  Aenderungen := 0;
  for n := 0 to pred(s.Count) do
  begin
    l := length(s[n]);
    if (l > 0) then
    begin
      s[n] := cutblank(s[n]);
      if (length(s[n]) <> l) then
        inc(Aenderungen);
    end;
  end;
  result := (Aenderungen > 0);
end;

function cutrblank(const InpStr: string): string;
var
  OutStr: string;
begin
  OutStr := InpStr;
  while (OutStr <> '') and (OutStr[length(OutStr)] = ' ') do
    delete(OutStr, length(OutStr), 1);
  cutrblank := OutStr;
end;

function cutlblank(const InpStr: string): string;
var
  OutStr: string;
begin
  OutStr := InpStr;
  while (OutStr <> '') and (OutStr[1] = ' ') do
    delete(OutStr, 1, 1);
  cutlblank := OutStr;
end;

function CharCount(c: char; const InpStr: string): integer;
var
  n: integer;
begin
  result := 0;
  for n := 1 to length(InpStr) do
    if InpStr[n] = c then
      inc(result);
end;

function FileDelete(const Mask: string): boolean;
var
  SelectedFiles: TStringList;
  PathName: string;
  n: integer;
  ErrorCount: integer;
begin
  ErrorCount := 0;
  SelectedFiles := TStringList.create;
  dir(Mask, SelectedFiles, false);
  PathName := ExtractFilePath(Mask);
  for n := 0 to pred(SelectedFiles.Count) do
  begin
    FileSetAttr(PathName + SelectedFiles[n], 0);
    if not(DeleteFile(PathName + SelectedFiles[n])) then
      inc(ErrorCount);
  end;
  SelectedFiles.free;
  result := (ErrorCount = 0);
end;

function FileDelete(const Mask: string; OlderThan: TAnfixDate): boolean;
var
  SelektedFiles: TStringList;
  PathName: string;
  n: integer;
  ErrorCount: integer;
begin
  if (OlderThan < 1000) then
    OlderThan := datePlus(DateGet, -OlderThan);
  ErrorCount := 0;
  SelektedFiles := TStringList.create;
  dir(Mask, SelektedFiles, false);
  PathName := ExtractFilePath(Mask);
  for n := 0 to pred(SelektedFiles.Count) do
    if (FileDate(PathName + SelektedFiles[n]) < OlderThan) then
    begin
      if (FileSetAttr(PathName + SelektedFiles[n], 0) <> 0) then
        inc(ErrorCount);
      if not(DeleteFile(PathName + SelektedFiles[n])) then
        inc(ErrorCount);
    end;
  SelektedFiles.free;
  result := (ErrorCount = 0);
end;

function FileRetire(const FileName: string; OlderThan: TAnfixDate): boolean;
begin
  if (OlderThan < 1000) then
    OlderThan := datePlus(DateGet, -OlderThan);
  FileRetireDate := FileDate(FileName);
  result := (FileRetireDate < OlderThan) and (FileRetireDate <> cIllegalDate);
end;

function FileDelete(const Mask: string; OlderThan: TAnfixDate; RemainingFileCount: integer): boolean;
{
  Lˆsche eventuell nur solche Dateien die ‰lter sind als "OlderThan"
  pr¸fe aber ob zumindest insgesamt "RemainingFileCount" Dateien dabei
  ¸brigbleiben.

  "OlderThan" kann als Datum ¸bergeben werden oder
  als ganzzahlige positive Anzahl der Tage (=Alter aus heutiger Sicht)
}
var
  SelektedFiles: TStringList;
  PathName: string;
  n: integer;
  ErrorCount: integer;
begin
  ErrorCount := 0;
  SelektedFiles := TStringList.create;
  dir(Mask, SelektedFiles, false);
  if (SelektedFiles.Count > RemainingFileCount) then
  begin
    SelektedFiles.sort;
    PathName := ExtractFilePath(Mask);
    for n := 0 to pred(SelektedFiles.Count - RemainingFileCount) do
      if not(FileDelete(PathName + SelektedFiles[n], OlderThan)) then
        inc(ErrorCount);
  end;
  SelektedFiles.free;
  result := (ErrorCount = 0);
end;

function FileDeleteUntil(const Mask: string; RemainingFileCount: integer; sDiagnose : TStringList = nil): boolean;
{
  Lˆsche Dateianzahl runter bis auf "RemainingFileCount"
  Die mit Mask ermittelte Liste wird namentlich sortiert (Dateidatum spielt keine Rolle),
  dabei wird vom Start der Liste in Richtung Ende gelˆscht. Beispiel:

  FileDeleteUntil('*.zip',3);
   A.zip : wird gelˆscht
   C.zip : wird gelˆscht
   D.zip : bleibt bestehen (1)
   E.zip : bleibt bestehen (2)
   G.zip : bleibt bestehen (3)

  Parameter sDiagnose (optional): Es wird ein Bericht erstellt welche Dateien
  gelˆscht worden sind (oder das Lˆschen unmˆglich war)
   FILE;DATE;DELETE
   hv_00001007.zip;12.06.2018;"DELETED"|"ERROR"
}
var
  SelektedFiles: TStringList;
  PathName: string;
  n: integer;
  ErrorCount: integer;
  FileD : TAnfixDate;
begin
  ErrorCount := 0;
  if assigned(sDiagnose) then
  begin
   if (sDiagnose.Count=0) then
    sDiagnose.Add('FILE;DATE;DELETE');
  end;
  SelektedFiles := TStringList.create;
  dir(Mask, SelektedFiles, false);
  if (SelektedFiles.Count > RemainingFileCount) then
  begin
    SelektedFiles.sort;
    PathName := ExtractFilePath(Mask);
    for n := 0 to pred(SelektedFiles.Count - RemainingFileCount) do
    begin
      FileD := FDate(PathName + SelektedFiles[n]);
      if not(FileDelete(PathName + SelektedFiles[n])) then
      begin
        inc(ErrorCount);
        if assigned(sDiagnose) then
         sDiagnose.Add(SelektedFiles[n]+';'+long2date(FileD)+';ERROR');
      end else
      begin
        if assigned(sDiagnose) then
         sDiagnose.Add(SelektedFiles[n]+';'+long2date(FileD)+';DELETED');
      end;
    end;
  end;
  SelektedFiles.free;
  result := (ErrorCount = 0);
end;

function DelTree(PathName: string): boolean;

  function _DelTree(Path: TFileName): boolean;
  var
    SRec: Tsearchrec;
    Res: integer;
  begin
    result := true;
    Path := Path + '\';
    Res := findfirst(Path + '*', faAnyFile, SRec);
    while Res = 0 do
    begin

      with SRec do
      begin
        if (Attr and faDirectory) = faDirectory then
        begin
          if (Name <> '.') and (Name <> '..') then
            result := _DelTree(Path + SRec.Name);
        end
        else
        begin
          FileSetAttr(Path + SRec.Name, 0);
          result := DeleteFile(Path + SRec.Name);
          if not result then
          begin
            findclose(SRec);
            exit;
          end;
        end;
      end;
      Res := FindNext(SRec);
    end;
    findclose(SRec);
    try
      FileSetAttr(ValidatePathName(Path), 0);
      RmDir(ValidatePathName(Path));
    except
      result := false;
    end;
  end;

begin
  PathName := ValidatePathName(PathName);
  result := true;
  if not SysUtils.DirectoryExists(PathName) then
    exit;
  result := _DelTree(PathName);
end;

function DirDelete(const Mask: string): boolean; overload;
var
  AllTheDirs: TStringList;
  n: integer;
  sr: Tsearchrec;
  DosError: integer;
  PathName: string;
begin
  AllTheDirs := TStringList.create;
  PathName := ExtractFilePath(Mask);
  DosError := findfirst(Mask, faDirectory, sr);
  while (DosError = 0) do
  begin
    if (sr.Name <> '.') and (sr.Name <> '..') then
      AllTheDirs.add(sr.Name);
    DosError := FindNext(sr);
  end;
  findclose(sr);
  for n := 0 to pred(AllTheDirs.Count) do
    DelTree(PathName + AllTheDirs[n]);
  AllTheDirs.free;
  result := true;
end;

function DirDelete(const Mask: string; OlderThan: TAnfixDate): boolean; overload;
var
  AllTheDirs: TStringList;
  n: integer;
  sr: Tsearchrec;
  DosError: integer;
  PathName: string;
begin
  if (OlderThan < 1000) then
    OlderThan := datePlus(DateGet, -OlderThan);
  AllTheDirs := TStringList.create;
  PathName := ExtractFilePath(Mask);
  DosError := findfirst(Mask, faDirectory, sr);
  while (DosError = 0) do
  begin
{$IFDEF fpc}
    if (sr.Name <> '.') and (sr.Name <> '..') then
      if DateTime2long(sr.Time) < OlderThan then
        AllTheDirs.add(sr.Name);
{$ELSE}
    if (sr.Name <> '.') and (sr.Name <> '..') then
      if DateTime2long(sr.TimeStamp) < OlderThan then
        AllTheDirs.add(sr.Name);
{$ENDIF}
    DosError := FindNext(sr);
  end;
  findclose(sr);
  for n := 0 to pred(AllTheDirs.Count) do
    DelTree(PathName + AllTheDirs[n]);
  AllTheDirs.free;
  result := true;
end;

function DirQuota(const Mask: string; SizeLimit: int64): boolean;
var
  sDir: TStringList;
  n: integer;
  Path: string;
  Size: int64;
  FName: string;
begin
  result := true;
  sDir := TStringList.create;
  Path := ExtractFilePath(Mask);
  dir(Mask, sDir, false);
  for n := 0 to pred(sDir.Count) do
    sDir[n] := dTimeStamp(FileDateTime(Path + sDir[n])) + '*' + sDir[n];
  sDir.sort;
  Size := 0;
  for n := pred(sDir.Count) downto 0 do
  begin
    FName := Path + NextP(sDir[n], '*', 1);
    if (Size >= SizeLimit) then
    begin
      if not(DeleteFile(FName)) then
        result := false;
    end
    else
    begin
      inc(Size, FSize(FName));
    end;
  end;
  sDir.free;
end;

function Frequently: LongWord; // [ms] since boot
begin
  result := GetTickCount;
end;

function Frequently(var LastTime: LongWord; DelayCount: LongWord): boolean;
var
  MyTick: LongWord;
begin
  result := false;
  MyTick := GetTickCount;
  if (LastTime = 0) or (MyTick > LastTime + DelayCount) or (MyTick < LastTime) then
  begin
    result := true;
    LastTime := MyTick;
  end;
end;

function FSize(FName: string): int64;
var
  F: Tsearchrec;
{$ifndef MSWINDOWS}
  H : File of Byte;
{$endif}
begin
  result := cFSize_NotExists;
  if (SysUtils.findfirst(FName, faAnyFile, F) = 0) then
  begin
    try
      {$ifdef MSWINDOWS}
      result := F.FindData.nFileSizeLow or (F.FindData.nFileSizeHigh shl 32);
      {$else}
      Assign(H,FName);
      reset(H);
      result := FileSize(H);
      close(H);
      {$endif}
    finally
      SysUtils.findclose(F);
    end;
  end;
end;

function RevToStr(r: single): string;
var
  s: string;
begin
  if TestMode then
  begin
    result := '9.999';
  end
  else
  begin
    if r = cRevNotAValidProject then
    begin
      result := '?.???';
    end
    else
    begin
      str(r: 4: 3, s);
      result := s;
    end;
  end;
end;

const
  RevInfoFileNameExtension = '.REV';

function GetRevision(const ProjectName: string): single;
var
  InpFile: text;
  dummy: integer;
  Rev: single;
  InpStr: string[5];
begin
  assign(InpFile, ProjectName + RevInfoFileNameExtension);
{$I-}
  reset(InpFile);
{$I+}
  if (ioresult <> 0) then
  begin
    Rev := cRevNotAValidProject;
  end
  else
  begin
    readln(InpFile, InpStr);
    val(noblank(InpStr), Rev, dummy);
    close(InpFile);
  end;
  GetRevision := Rev;
end;

procedure SetRevision(const ProjectName: string; Rev: single);
var
  OutFile: text;
begin
  assign(OutFile, ProjectName + RevInfoFileNameExtension);
  rewrite(OutFile);
  writeln(OutFile, RevToStr(Rev));
  close(OutFile);
end;

function RevAsInteger(Rev: single): integer; overload;
begin
  result := round(Rev * 1000);
end;

function RevAsInteger(Rev: double): integer; overload;
begin
  result := round(Rev * 1000);
end;

function RevIsFrom(Rev, From: single): boolean; //
begin
  result := (RevAsInteger(Rev) >= RevAsInteger(From));
end;

function RevIsBefore(Rev, Before: single): boolean; //
begin
  result := not(RevIsFrom(Rev, Before));
end;

function IsParam(x: string): boolean;
var
  n: byte;
begin
  result := false;
  if (pos('*', x) > 0) then
  begin
    x := copy(x, 1, pred(pos('*', x)));
    for n := 1 to ParamCount do
      if (pos(AnsiUpperCase(x), AnsiUpperCase(Paramstr(n))) = 1) then
      begin
        result := true;
        exit;
      end;
  end
  else
  begin
    for n := 1 to ParamCount do
      if (AnsiUpperCase(x) = AnsiUpperCase(Paramstr(n))) then
      begin
        result := true;
        exit;
      end;
  end;
end;

function getParam(x: string): string;
var
  n: byte;
begin
  result := '';
  x := '--' + AnsiUpperCase(x) + '=';
  for n := 1 to ParamCount do
    if (pos(x, AnsiUpperCase(Paramstr(n))) = 1) then
    begin
      result := NextP(Paramstr(n), '=', 1);
      break;
    end;
end;

function FisNetwork(DriveName: string): boolean;
var
  ClearedDriveName: array [0 .. 1023] of char;
begin
  StrPCopy(ClearedDriveName, DriveName[1] + ':\');
  {$ifdef MSWINDOWS}
  result := (GetDriveType(ClearedDriveName) = DRIVE_REMOTE);
  {$else}
  // imp pend: linux
  {$endif}
end;

var
  RemoteNameInfo: array [0 .. 1023] of char;

function FSerial(DriveName: string): string;
var
  SerialNum: dword;
  d1, d2: dword;

  ClearedDriveName: array [0 .. 1023] of char;
  Size: dword;
  ErrCode: integer;
begin
  result := '????????';
  if length(DriveName) > 0 then
  begin
    StrPCopy(ClearedDriveName, DriveName[1] + ':\');
    {$ifdef MSWINDOWS}
    if GetDriveType(ClearedDriveName) = DRIVE_REMOTE then
    begin
      Size := SizeOf(RemoteNameInfo);
      ErrCode := WNetGetUniversalName(ClearedDriveName, UNIVERSAL_NAME_INFO_LEVEL, @RemoteNameInfo, Size);
      if (ErrCode = NO_ERROR) then
        StrPCopy(ClearedDriveName, PRemoteNameInfo(@RemoteNameInfo)^.lpUniversalName + '\');
    end;
    if GetVolumeInformation(ClearedDriveName, nil, 0, @SerialNum, d1, d2, nil, 0) then
      result := format('%.8x', [SerialNum]);
    {$else}
    // imp pend: linux
    {$endif}
  end;
end;

function FVolume(DriveName: string): string;
var
  SerialNum: pdword;
  a, b, c: dword;
  Buffer: array [0 .. 255] of char;
  b2: array [0 .. 255] of char;
begin
  if (DriveName = '') then
  begin
    result := '';
    exit;
  end;
  if DriveName[length(DriveName)] <> '\' then
    DriveName := DriveName + '\';

  StrPCopy(b2, DriveName);
  SerialNum := @c;
  {$ifdef MSWINDOWS}
  GetVolumeInformation(b2, Buffer, SizeOf(Buffer), SerialNum, a, b, nil, 0);
  {$else}
  // imp pend: linux
  {$endif}
  result := Buffer;
end;

function InSide(const x, y: integer; const r: TRect): boolean;
begin
  // may use PtInRect
  InSide := (x >= r.left) and (x <= r.right) and (y >= r.top) and (y <= r.Bottom);
end;

function InSide(const x, y: integer; Polygon: array of TPoint): boolean;
{$ifdef MSWINDOWS}

var
  PolyHandle: HRGN;
begin
  PolyHandle := CreatePolygonRgn(Polygon[0], length(Polygon), Winding);
  result := PtInRegion(PolyHandle, x, y);
  DeleteObject(PolyHandle);
end;
{$else}
begin
  // imp pend:
  result := false;
end;

{$endif}


function InSideRect(const a, b: TRect): boolean;
begin
  result := InSide(a.left, a.top, b) or InSide(a.left, a.Bottom, b) or InSide(a.right, a.top, b) or
    InSide(a.right, a.Bottom, b);
end;

function RectCollision(const a, b: TRect): boolean;
begin
  result := InSideRect(a, b) or InSideRect(b, a);
end;

function rXL(r: TRect): integer;
begin
  with r do
    result := succ(r.right - r.left);
end;

function rYL(r: TRect): integer;
begin
  with r do
    result := succ(r.Bottom - r.top);
end;

// SizeCorrect, leider notwendig f¸r
//
// FrameRect
// FillRect
//

function SizeCorrect(r: TRect): TRect;
begin
  result.left := r.left;
  result.top := r.top;
  result.right := succ(r.right);
  result.Bottom := succ(r.Bottom);
end;

function Sub2Rects(const r1, r2: TRect; var o1, o2: TRect): boolean;
begin

  if InSide(r2.left, r2.top, r1) then
  begin
    o1.left := r1.left;
    o1.top := r1.top;
    o1.right := r1.right;
    o1.Bottom := pred(r2.top);

    o2.left := r1.left;
    o2.top := r2.top;
    o2.right := pred(r2.left);
    o2.Bottom := r1.Bottom;

    result := true;
    exit;
  end;

  if InSide(r2.right, r2.Bottom, r1) then
  begin

    o1.left := succ(r2.right);
    o1.top := r1.top;
    o1.right := r1.right;
    o1.Bottom := r2.Bottom;

    o2.left := r1.left;
    o2.top := succ(r2.Bottom);
    o2.right := r1.right;
    o2.Bottom := r1.Bottom;

    result := true;
    exit;
  end;

  if InSide(r2.left, r2.Bottom, r1) then
  begin

    o1.left := r1.left;
    o1.top := r1.top;
    o1.right := pred(r2.left);
    o1.Bottom := r2.Bottom;

    o2.left := r1.left;
    o2.top := succ(r2.Bottom);
    o2.right := r1.right;
    o2.Bottom := r1.Bottom;

    result := true;
    exit;
  end;

  if InSide(r2.right, r2.top, r1) then
  begin

    o1.left := r1.left;
    o1.top := r1.top;
    o1.right := r1.right;
    o1.Bottom := pred(r2.top);

    o2.left := succ(r2.right);
    o2.top := r2.top;
    o2.right := r1.right;
    o2.Bottom := r1.Bottom;

    result := true;
    exit;
  end;
  result := false;
end;


// Resize a TRect

procedure rInc(var r: TRect; xl, yl: integer);
begin
  inc(r.right, xl);
  inc(r.Bottom, yl);
end;

// Hat ein rect ¸berhaupt eine Grˆﬂe?

function rValid(const r: TRect): boolean;
begin
  result := (r.top <= r.Bottom) and (r.left <= r.right);
end;

// Ist es ein Leeres Rect?

function rNull(const r: TRect): boolean;
begin
  result := (r.top = 0) and (r.Bottom = 0) and (r.left = 0) and (r.right = 0);
end;

// Move a TRect to the fixed point, save its !Size!

procedure rMoveto(var r: TRect; x, y: integer);
var
  a, b: integer;
begin
  a := r.right - r.left;
  b := r.Bottom - r.top;
  r.left := x;
  r.top := y;
  r.right := x + a;
  r.Bottom := y + b;
end;

procedure rMove(var r: TRect; dx, dy: integer);
begin
  inc(r.left, dx);
  inc(r.right, dx);
  inc(r.top, dy);
  inc(r.Bottom, dy);
end;

// Copy the Size of a Rect to another

procedure rSize(const s: TRect; var d: TRect);
begin
  d.right := pred(d.left + rXL(s));
  d.Bottom := pred(d.top + rYL(s));
end;

// Copy the Size of a Rect to another

procedure rSetSize(xl, yl: integer; var d: TRect);
begin
  d.right := pred(d.left + xl);
  d.Bottom := pred(d.top + yl);
end;

function Str2Rect(ValueStr: string): TRect;
var
  k: integer;
begin
  if ValueStr = '' then
  begin
    result := rect(0, 0, 0, 0);
    exit;
  end;

  // left
  k := pos(',', ValueStr);
  result.left := strtoint(copy(ValueStr, 1, pred(k)));
  delete(ValueStr, 1, k);

  // top
  k := pos(',', ValueStr);
  result.top := strtoint(copy(ValueStr, 1, pred(k)));
  delete(ValueStr, 1, k);

  // FullXL
  k := pos(',', ValueStr);
  result.right := result.left + strtoint(copy(ValueStr, 1, pred(k)));
  delete(ValueStr, 1, k);

  // FullYL
  result.Bottom := result.top + strtoint(copy(ValueStr, 1, MaxInt));
end;

function Str2Point(ValueStr: string): TPoint;
var
  k: integer;
begin
  k := pos(',', ValueStr);
  result := point(strtoint(copy(ValueStr, 1, pred(k))), strtoint(copy(ValueStr, succ(k), MaxInt)));
end;

function revCopy(const s: string; start, len: integer): string;
var
  _start: integer;
  StrL: integer;
begin
  StrL := length(s);
  _start := StrL - (pred(start) + pred(len));
  if _start < 1 then
  begin
    inc(len, start);
    _start := 1;
  end;
  len := max(0, len);
  result := copy(s, _start, len);
end;

procedure SwapStr(var s: string; Start1, len, Start2: integer);
begin
  if (Start1 = Start2) or (len < 1) then
    exit;
end;

function revPos(const substr: string; const s: string): integer;
{
  Identisch zu pos, jedoch wird nicht von links nach rechts,
  sondern von rechts nach links gesucht.
  Anwendung:

  8 = revpos ('\','C:\XDOS\HELLO.TXT');
  6 = revpos ('jo','jjolojodel');

  usf.
}
var
  ls, l, SearchPos: integer;
  SubPos: integer;
  SeemsToBeOk: boolean;
begin
  result := 0;
  repeat
    if (pos(substr, s) = 0) then
      break;
    ls := length(substr);
    if (ls = 0) then
      break;
    l := length(s);
    if (ls > l) then
      break;
    for SearchPos := l downto ls do
    begin
      if (substr[ls] = s[SearchPos]) then
      begin
        { Erstes Zeichen stimmt schon, stimmen auch die anderen? }
        SeemsToBeOk := true;
        for SubPos := ls - 1 downto 1 do
          if (substr[SubPos] <> s[SearchPos - ls + SubPos]) then
          begin
            SeemsToBeOk := false;
            break;
          end;
        if SeemsToBeOk then
        begin
          result := SearchPos + 1 - ls;
          break;
        end;
      end;
    end;
  until yet;
end;

function FileOperation(const Source, Dest: string; op, flags: integer): boolean;
{$ifdef MSWINDOWS}

var
  shf: TSHFileOpStruct;
  s1, s2: string;
begin
  FillChar(shf, SizeOf(shf), #0);
  s1 := Source + #0#0;
  s2 := Dest + #0#0;
  shf.Wnd := 0;
  shf.wFunc := op;
  shf.pFrom := PCHAR(s1);
  shf.pTo := PCHAR(s2);
  shf.fFlags := flags;
  result := (SHFileOperation(shf) = 0);
end (* FileOperation *);
{$else}
begin
  // imp pend: linux
end;

{$endif}

function FileOperationMove(Source, Destination: string): boolean;
begin
{$ifdef MSWINDOWS}
  result := FileOperation(Source, Destination, FO_MOVE, FOF_NOCONFIRMATION + FOF_NOCONFIRMMKDIR + FOF_NOERRORUI);
{$else}
// imp pend:
result := false;
{$endif}
end;

function FileCopy(const Mask, Dest: string; Move: boolean = false; Touch: boolean = false): boolean;

  //
  // Anwendungsfall 1 ("Mask" ohne "*" oder "?")
  // ===========================================
  //
  // Kopiert eine vollst‰ndig benannte Datei (mit vollst‰ndigem Pfad) "Mask"
  // in eine neu zu erstellende Datei "Dest", soll der Dateiname unver‰ndert
  // bleiben, so ist dennoch der Dateiname zu wiederholen!
  //
  // Anwendungsfall 2 ("Mask" mit "*" oder "?")
  // ==========================================
  //
  // Kopiert alle Dateien (nicht Verzeichnisse!) die per "Mask" angegeben
  // sind, in einen das Zielverzeichnis "Dest", existiert es nicht wird es
  // zuvor angelegt.
  //

var
  FileL: TStringList;
  ErrorCount: integer;
  n: integer;
  _Source: string;
  _Dest: string;
  dt : TDateTime;
begin
  if (pos('*', Mask) = 0) and (pos('?', Mask) = 0) then
  begin
    {$ifdef MSWINDOWS}
    result := CopyFile(PCHAR(Mask), PCHAR(Dest), false);
    {$else}
    result := CopyFile(Mask, Dest, [cffOverwriteFile, cffPreserveTime])
    {$endif}

    // ready only Source -> Writeable Dest
    if result then
     if (FileGetAttr(Mask) and faReadOnly=faReadOnly) then
      result := (FileSetAttr(Dest, 0) = 0);

    // explicit Touch?
    if result and Touch then
      FileTouch(Dest);

    // do we loose FileDate or FileTime?
    if result and not(Touch) then
    begin
     dt := FileTouched(Mask);
     if not(VeryClose(FileTouched(Dest),dt)) then
       FileTouch(Dest,dt);
    end;

    // Should we Delete Source?
    if result and Move then
      result := FileDelete(Mask);

  end
  else
  begin
    ErrorCount := 0;
    FileL := TStringList.create;
    dir(Mask, FileL, false);
    _Dest := ValidatePathName(Dest);
    _Source := ExtractFilePath(Mask);
    CheckCreateDir(Dest);
    for n := 0 to pred(FileL.Count) do
      if not(FileCopy(_Source + FileL[n], _Dest + '\' + FileL[n], Move, Touch)) then
        inc(ErrorCount);
    result := (ErrorCount = 0);
    FileL.free;
  end;
end;

function FileVersionedCopy(const SourceFName, DestFName: string): boolean;

  //
  // Kopiert eine Dateiname.Extension, "sichert" aber die alte Version der Datei
  // nach Dateiname-n.Extension. Dabei wird n zun‰chst aus
  // des bisher bestehenden Sicherungen bestimmt, aber auch nach
  // Dateiname.ini gespeichert um sp‰tere Zugriffe zu beschleunigen
  // Ist Dateiname.ini vorhanden wird die Existenz der alten Versionen
  // nicht mehr gepr¸ft, nur noch die der aktuellen Nummer. Ist die Datei
  // bereits vorhanden wird weitergez‰hlt bis eine freie Nummer gefunden ist.
  // Ist DestFName=Dateiname.ini weicht der Dateiname f¸r die Nummer auf
  // Dateiname#.ini aus.
  //

const
  cINI_Sequenz = 'DateiAblageSequenz';

var
  ZielPath: string;
  ZielIdentifier: string;
  ZielNamensraum: string;
  ZielExtension: string;
  ZielExtensionLength: integer;
  ExtensionPos: integer;

  // .ini Sachen
  IniFName: string;
  sIni: TStringList;

  // Maximaler Durchnummerierungswert
  n, j, MaxCount, _MaxCount: integer;
  sRecordVersion: string;

  // Sicherungswert
  SicherungFName: string;

begin
  result := false;

  // 1) Sicherung der alten Datei anlegen
  if FileExists(DestFName) then
  begin
    ZielPath := ExtractFilePath(DestFName);
    ZielIdentifier := ExtractFileName(DestFName);
    ExtensionPos := revPos('.', ZielIdentifier);
    if (ExtensionPos < 3) then
      raise Exception.create('FileVersionedCopy: keine g¸ltige Dateinamen-Erweiterung der Zieldatei');
    ZielExtension := copy(ZielIdentifier, ExtensionPos, MaxInt);
    ZielNamensraum := copy(ZielIdentifier, 1, pred(ExtensionPos));

    // avoid IniFName=DestFName
    if (ZielExtension='.ini') then
     IniFName := ZielPath + ZielNamensraum + '#.ini'
    else
     IniFName := ZielPath + ZielNamensraum + '.ini';

    sIni := TStringList.create;
    if FileExists(IniFName) then
    begin
      sIni.LoadFromFile(IniFName);
      MaxCount := StrToIntDef(sIni.Values[cINI_Sequenz], 0);
    end
    else
    begin
      MaxCount := 0;
      ZielExtensionLength := length(ZielExtension);

      // das Dateisystem befragen
      dir(ZielPath + ZielNamensraum + '-' + '*' + ZielExtension, sIni, false);

      // die Maximale Zahl rausextrahieren!
      for n := 0 to pred(sIni.Count) do
      begin
        sRecordVersion := copy(sIni[n], 1, length(sIni[n]) - ZielExtensionLength);
        j := revPos('-', sRecordVersion);
        _MaxCount := StrToIntDef(copy(sRecordVersion, succ(j), MaxInt), MaxCount);
        MaxCount := max(_MaxCount, MaxCount);
      end;

    end;

    // Suche nach einem ordentlichen Sicherungsdateinamen
    repeat
     inc(MaxCount);

     // Sicherungsname zusammenbauen
     SicherungFName := ZielPath + ZielNamensraum + '-' + inttostr(MaxCount) + ZielExtension;
     if not(FileExists(SicherungFName)) then
      break;
    until eternity;

    // Die alte Datei entsprechend der Nummer umbenennen
    if not(RenameFile(DestFName, SicherungFName)) then
      raise Exception.create('FileVersionedCopy: konnte ' + DestFName + ' nicht wegsichern');

    // Zuletzt benutzer Wert abspeichern
    sIni.clear;
    sIni.Values[cINI_Sequenz] := inttostr(MaxCount);
    sIni.SaveToFile(IniFName);
    sIni.free;
  end;

  // 2) Umkopieren
  if not(FileCopy(SourceFName, DestFName)) then
    raise Exception.create('FileVersionedCopy: konnte ' + DestFName + ' nicht erstellen');

  result := true;
end;

// FConcat
// F¸gt 2 Dateien zu einer neuen zusammen.

function FileConcat(const Source1, Source2, Dest: string): boolean;
var
  FromF, ToF: file;
{$IFDEF win32}
  NumRead, NumWritten: integer;
{$ELSE}
  NumRead, NumWritten: Word;
{$ENDIF}
  buf: array [1 .. 2048] of char;
begin
  if FileCopy(Source1, Dest) then
  begin

    { Open input file }
    assign(FromF, Source2);

    { Record size = 1 }
{$I-}
    reset(FromF, 1);
{$I+}
    if ioresult <> 0 then
    begin
      result := false;
      exit;
    end;

    { Open output file }
    assign(ToF, Dest);

    { Record size = 1 }
    reset(ToF, 1);
    seek(ToF, filesize(ToF));

    repeat
      BlockRead(FromF, buf, SizeOf(buf), NumRead);
      BlockWrite(ToF, buf, NumRead, NumWritten);
    until (NumRead = 0) or (NumWritten <> NumRead);
    close(FromF);
    close(ToF);
    result := (NumWritten = NumRead);

  end
  else
  begin
    result := false;
  end;
end;

function FileMove(const Mask, Dest: string): boolean;
begin
  result := FileCopy(Mask, Dest, true);
end;

function AlreadyRunning(ApplicationName: string): boolean;
begin
{$ifdef MSWINDOWS}
  AppSem := CreateSemaphore(nil, 0, 1, PCHAR(ApplicationName));
  result := (AppSem <> 0) and (GetLastError = ERROR_ALREADY_EXISTS);
  {$else}
  // imp pend:
  {$endif}
end;

procedure CloseAppSem;
begin
{$ifdef MSWINDOWS}
  CloseHandle(AppSem);
{$else}
// imp pend:
{$endif}
end;

function FisCD(DriveName: string): boolean;
var
  _DriveName: array [0 .. 63] of char;
begin
  StrPCopy(_DriveName, AnsiUpperCase(DriveName[1]) + ':\');
  {$ifdef MSWINDOWS}
  result := GetDriveType(_DriveName) = DRIVE_CDROM;
  {$else}
  // imp pend
  {$endif}
end;

procedure SetCDAutoRun(vAutoRun: boolean);
(* this code comes from Delphi Developer Support *)
var
  reg: TRegistry;
  AutoRunSetting: integer;
begin
  reg := TRegistry.create;
  with reg do
  begin
    RootKey := HKEY_CURRENT_USER;
    LazyWrite := false;
    OpenKey('Software\Microsoft\Windows\CurrentVersion\Policies\Explorer', false);
    ReadBinaryData('NoDriveTypeAutoRun', AutoRunSetting, SizeOf(AutoRunSetting));
    if vAutoRun then
      AutoRunSetting := AutoRunSetting and not(1 shl 5)
    else
      AutoRunSetting := AutoRunSetting or (1 shl 5);
    reg.WriteBinaryData('NoDriveTypeAutoRun', AutoRunSetting, SizeOf(AutoRunSetting));
    CloseKey;
    free;
  end;
end;

function GetCDAutoRun: boolean;
(* this code comes from Delphi Developer Support *)
var
  reg: TRegistry;
  AutoRunSetting: integer;
begin
  reg := TRegistry.create;
  with reg do
  begin
    RootKey := HKEY_CURRENT_USER;
    OpenKey('Software\Microsoft\Windows\CurrentVersion\Policies\Explorer', false);
    ReadBinaryData('NoDriveTypeAutoRun', AutoRunSetting, SizeOf(AutoRunSetting));
    CloseKey;
    free;
  end;
  result := not((AutoRunSetting and (1 shl 5)) <> 0);
end;

{$ifdef MSWINDOWS}

// Hier gehts los, alles f¸r das CPU-Usage Tool!

{ * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  CPU Usage Measurement routines for Delphi and C++ Builder

  Author:       Alexey A. Dynnikov
  EMail:        aldyn@chat.ru
  WebSite:      http://www.aldyn.ru/
  Support:      Use the e-mail aldyn@chat.ru
  or support@aldyn.ru

  Creation:     Jul 8, 2000
  Version:      1.02

  Legal issues: Copyright (C) 2000 by Alexey A. Dynnikov <aldyn@chat.ru>

  This software is provided 'as-is', without any express or
  implied warranty.  In no event will the author be held liable
  for any  damages arising from the use of this software.

  Permission is granted to anyone to use this software for any
  purpose, including commercial applications, and to alter it
  and redistribute it freely, subject to the following
  restrictions:

  1. The origin of this software must not be misrepresented,
  you must not claim that you wrote the original software.
  If you use this software in a product, an acknowledgment
  in the product documentation would be appreciated but is
  not required.

  2. Altered source versions must be plainly marked as such, and
  must not be misrepresented as being the original software.

  3. This notice may not be removed or altered from any source
  distribution.

  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  USAGE:

  1. Include this unit into project.

  2. Call GetCPUCount to obtain the numbr of processors in the system

  3. Each time you need to know the value of CPU usage call the CollectCPUData
  to refresh the CPU usage information. Then call the GetCPUUsage to obtain
  the CPU usage for given processor. Note that succesive calls of GetCPUUsage
  without calling CollectCPUData will return the same CPU usage value.

  Example:

  procedure TTestForm.TimerTimer(Sender: TObject);
  var i: Integer;
  begin
  CollectCPUData; // Get the data for all processors

  for i:=0 to GetCPUCount-1 do // Show data for each processor
  MInfo.Lines[i]:=Format('CPU #%d - %5.2f%%',[i,GetCPUUsage(i)*100]);
  end;
  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * }

type
  PInt64 = ^int64;

  TPERF_DATA_BLOCK = record
    Signature: array [0 .. 4 - 1] of WCHAR;
    LittleEndian: dword;
    Version: dword;
    Revision: dword;
    TotalByteLength: dword;
    HeaderLength: dword;
    NumObjectTypes: dword;
    DefaultObject: longint;
    SystemTime: TSystemTime;
    Reserved: dword;
    PerfTime: int64;
    PerfFreq: int64;
    PerfTime100nSec: int64;
    SystemNameLength: dword;
    SystemNameOffset: dword;
  end;

  PPERF_DATA_BLOCK = ^TPERF_DATA_BLOCK;

  TPERF_OBJECT_TYPE = record
    TotalByteLength: dword;
    DefinitionLength: dword;
    HeaderLength: dword;
    ObjectNameTitleIndex: dword;
    ObjectNameTitle: LPWSTR;
    ObjectHelpTitleIndex: dword;
    ObjectHelpTitle: LPWSTR;
    DetailLevel: dword;
    NumCounters: dword;
    DefaultCounter: longint;
    NumInstances: longint;
    CodePage: dword;
    PerfTime: int64;
    PerfFreq: int64;
  end;

  PPERF_OBJECT_TYPE = ^TPERF_OBJECT_TYPE;

  TPERF_COUNTER_DEFINITION = record
    ByteLength: dword;
    CounterNameTitleIndex: dword;
    CounterNameTitle: LPWSTR;
    CounterHelpTitleIndex: dword;
    CounterHelpTitle: LPWSTR;
    DefaultScale: longint;
    DetailLevel: dword;
    CounterType: dword;
    CounterSize: dword;
    CounterOffset: dword;
  end;

  PPERF_COUNTER_DEFINITION = ^TPERF_COUNTER_DEFINITION;

  TPERF_COUNTER_BLOCK = record
    ByteLength: dword;
  end;

  PPERF_COUNTER_BLOCK = ^TPERF_COUNTER_BLOCK;

  TPERF_INSTANCE_DEFINITION = record
    ByteLength: dword;
    ParentObjectTitleIndex: dword;
    ParentObjectInstance: dword;
    UniqueID: longint;
    NameOffset: dword;
    NameLength: dword;
  end;

  PPERF_INSTANCE_DEFINITION = ^TPERF_INSTANCE_DEFINITION;

  // ------------------------------------------------------------------------------

const
  Processor_IDX_Str = '238';
  Processor_IDX = 238;
  CPUUsageIDX = 6;

type
  AInt64F = array [0 .. $FFFF] of int64;
  PAInt64F = ^AInt64F;

var
  _PerfData: PPERF_DATA_BLOCK;
  _BufferSize: integer;
  _POT: PPERF_OBJECT_TYPE;
  _PCD: PPERF_COUNTER_DEFINITION;
  _ProcessorsCount: integer;
  _Counters: PAInt64F;
  _PrevCounters: PAInt64F;
  _SysTime: int64;
  _PrevSysTime: int64;
  _IsWinNT: boolean;
  _IsWin2000: boolean;
  _W9xCollecting: boolean;
  _W9xCpuUsage: dword;
  _W9xCpuKey: HKEY;
  _CPUcount: integer;

  // ------------------------------------------------------------------------------

procedure ReleaseCPUData;
var
  h: HKEY;
  r: dword;
  dwDataSize, dwType: dword;
begin
  if _IsWinNT then
    exit;
  if not _W9xCollecting then
    exit;
  _W9xCollecting := false;

  RegCloseKey(_W9xCpuKey);

  r := RegOpenKeyEx(HKEY_DYN_DATA, 'PerfStats\StopStat', 0, KEY_ALL_ACCESS, h);

  if r <> ERROR_SUCCESS then
    exit;

  dwDataSize := SizeOf(dword);

  RegQueryValueEx(h, 'KERNEL\CPUUsage', nil, @dwType, PBYTE(@_W9xCpuUsage), @dwDataSize);

  RegCloseKey(h);

end;

var
  _UserName: string = '';

function UserName: string;
var
  NameBuf: array [0 .. 1023] of char;
  NameBufSize: dword;
  fret: bool;
  ErrorCode: dword;
begin
  if (_UserName = '') then
  begin
    if IsParam('--g') then
    begin
      _UserName := 'Gast';
    end
    else
    begin
      NameBufSize := SizeOf(NameBuf);
      fret := GetUserName(NameBuf, NameBufSize);
      if not(fret) then
      begin
        ErrorCode := GetLastError;
        SysErrorMessage(ErrorCode);
      end;
      _UserName := NameBuf;
    end;
  end;
  result := _UserName;
end;

var
  _Domain: string = '';

function Domain: string;
type
  // missing in windows.pas?!
  PTOKEN_USER = ^TOKEN_USER;

  TOKEN_USER = record
    user: SID_AND_ATTRIBUTES;
  end;
var
  reg: TRegistry;
  hToken: THandle;
  InfoBuffer: array [0 .. 511] of byte;
  cbInfoBuffer: dword;
  UserName: array [0 .. 1023] of char;
  cchUserName: dword;
  DomainName: array [0 .. 1023] of char;
  cchDomainName: dword;
  snu: SID_NAME_USE;
begin
  if (_Domain = '') then
  begin
    _Domain := '?';
    if (Win32Platform = VER_PLATFORM_WIN32_NT) then
    begin
      // Lˆsung mit NT
      repeat

        // ObtainToken
        if not(OpenThreadToken(GetCurrentThread, TOKEN_QUERY, true, hToken)) then
        begin
          if (GetLastError = ERROR_NO_TOKEN) then
          begin
            if not(OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, hToken)) then
              break;
          end
          else
          begin
            break;
          end;
        end;

        // ObtainSID
        cbInfoBuffer := SizeOf(InfoBuffer);
        if not(GetTokenInformation(hToken, TokenUser, @InfoBuffer, cbInfoBuffer, cbInfoBuffer)) then
          break;
        CloseHandle(hToken);

        // ObtainDomain
        cchUserName := SizeOf(UserName);
        cchDomainName := SizeOf(DomainName);
        if not(LookupAccountSid(nil, PTOKEN_USER(@InfoBuffer)^.user.sid, UserName, cchUserName, DomainName,
          cchDomainName, snu)) then
          break;
        _Domain := DomainName;
      until yet;
    end
    else
    begin
      // win95, win98
      reg := TRegistry.create;
      with reg do
      begin
        RootKey := HKEY_LOCAL_MACHINE;
        OpenKey('System\CurrentControlSet\Services\VxD\VNETSUP', false);
        _Domain := ReadString('Workgroup');
      end;
      reg.free;
    end;
  end;
  result := _Domain;
end;

var
  _ComputerName: string = '';

function ComputerName: string;
var
  NameBuf: array [0 .. 1023] of char;
  NameBufSize: dword;
  fret: bool;
  ErrorCode: dword;
begin
  if (_ComputerName = '') then
  begin
    NameBufSize := SizeOf(NameBuf);
    fret := GetComputerName(NameBuf, NameBufSize);
    if not(fret) then
    begin
      ErrorCode := GetLastError;
      StrPCopy(NameBuf, SysErrorMessage(ErrorCode));
    end;
    _ComputerName := NameBuf;
  end;
  result := _ComputerName;
  // alternativ: CurrentControlSet\Control\ComputerName\ComputerName
end;

{$else}

// imp pend:

function ComputerName: string;
begin
  // *read (/proc/sys/kernel/hostname)
  // read (/proc/sys/kernel/version)
  // read (/proc/sys/kernel/domainname)
  // read (/proc/sys/kernel/osrelease
 result := '';
end;

function NetworkInstalled: boolean;
begin
  result := true;
end;

{$endif}

function dir(const Mask: string): integer; overload;
var
  x: TStringList;
begin
  x := TStringList.create;
  dir(Mask, x, false, false);
  result := x.Count;
  x.free;
end;

procedure dir(const Mask: string; FileNames: TStrings; uppercase: boolean = true; ClearList: boolean = true); overload;
var
  sr: Tsearchrec;
  fr: integer;
  SubDirs: TStringList;
  AllResults: TStringList;
  NewMask: string;
  n, k, m: integer;
begin
  if ClearList then
    FileNames.clear;
  k := pos('\*\', Mask);
  if (k > 0) then
  begin
    // beliebige Unterverzeichnisse mit ausgeben!
    SubDirs := TStringList.create;
    AllResults := TStringList.create;
    dir(copy(Mask, 1, k) + cDirMask_Directory, SubDirs, false, false);
    for n := 0 to pred(SubDirs.Count) do
    begin
      NewMask := Mask;
      ersetze('\*\', '\' + SubDirs[n] + '\', NewMask);
      dir(NewMask, FileNames, uppercase);
      for m := 0 to pred(FileNames.Count) do
        AllResults.add(SubDirs[n] + '\' + FileNames[m]);
    end;
    FileNames.AddStrings(AllResults);
    AllResults.free;
    SubDirs.free;
  end
  else
  begin

    // suchen nach Verzeichnissen? In der Regel angezeigt durch
    // *. als ein Punkt am Ende. *X. oder X*. sind auch Suchen
    // nach Unterverzeichnis-Namen
    k := revPos('.', Mask);

    if (k = length(Mask)) then
    begin
      fr := findfirst(copy(Mask,1,pred(k)), faDirectory, sr);
      while (fr = 0) do
      begin
        // sorry, have to double check the Attribute!
        // The Mask in findfirst means "additional" things to "Files"
        if (sr.Attr and faDirectory = faDirectory) then
          // unwanted, hidden subDirs
          // we dont want ".","..",".help", ".wine"
          // these are hidden SubDirs
          if (pos('.',sr.Name)<>1) then
          begin
            if uppercase then
              FileNames.add(AnsiUpperCase(sr.Name))
            else
              FileNames.add(sr.Name);
          end;
        fr := FindNext(sr);
      end;
    end else
    begin
      fr := findfirst(Mask, faAnyFile - faDirectory, sr);
      while (fr = 0) do
      begin
        if uppercase then
          FileNames.add(AnsiUpperCase(sr.Name))
        else
          FileNames.add(sr.Name);
        fr := FindNext(sr);
      end;
    end;
    findclose(sr);
  end;
end;

function dirs(const Path: string): TStringList;

  procedure addSubs(const Path: string);
  var
    sPath: TStringList;
    n: integer;
  begin
    sPath := TStringList.create;
    dir(Path + cDirMask_Directory, sPath, false);
    for n := 0 to pred(sPath.Count) do
      if (sPath[n] <> '.') and (sPath[n] <> '..') then
        result.add(sPath[n]);
    sPath.free;
  end;

var
  n, m: integer;
  s: TStringList;
begin
  result := TStringList.create;
  addSubs(Path);
  for n := 0 to pred(result.Count) do
  begin
    s := dirs(Path + result[n] + '\');
    for m := 0 to pred(s.Count) do
      result.add(result[n] + '\' + s[m]);
    s.free;
  end;
end;

function boolToStr(b: boolean; _true: string = 'Y'; _false: string = 'N'): string;
begin
  if b then
    result := _true
  else
    result := _false;
end;

procedure DataScramble(var data; datasize: integer; const key: string);
const
  CRYPT_1 = 2; { must be 0-5    divisor }
  CRYPT_2 = 53; { must be 0-255  modifier }
type
  ScrambleCast = array [0 .. MaxInt div 2] of byte;
var
  n, l: integer;
  c, T: byte;
begin
  l := length(key);
  c := 0;
  for n := 0 to pred(datasize) do
  begin
    if c = 255 then
      c := 0
    else
      inc(c);
    if (c mod 2) = 0 then
      T := (c shr CRYPT_1) xor byte(key[(c mod l) + 1])
    else
      T := (abs(CRYPT_2 - c)) xor byte(key[((c mod l) + 1) shr 1]);
    ScrambleCast(data)[n] := ScrambleCast(data)[n] xor T;
  end;
end;

procedure DataScramble(var data; datasize: integer);
begin
  DataScramble(data, datasize, 'ANFiSOFT');
end;

procedure RemoveDuplicates(s: TStrings; out DeleteCount: integer; Dups: TStrings);
var
  n: integer;
begin
  DeleteCount := 0;
  for n := pred(s.Count) downto 1 do
    if s[pred(n)] = s[n] then
    begin
      Dups.addobject(s[n], s.objects[n]);
      s.delete(n);
      inc(DeleteCount);
    end;
end;

procedure RemoveDuplicates(s: TStrings; out DeleteCount: integer);
// must be sorted
var
  n: integer;
begin
  DeleteCount := 0;
  for n := pred(s.Count) downto 1 do
    if (s[pred(n)] = s[n]) then
    begin
      s.delete(n);
      inc(DeleteCount);
    end;
end;

function RemoveDuplicates(s: TStrings): integer;
begin
  RemoveDuplicates(s, result);
end;

procedure LoadFromFileHugeLines(clear: boolean; s: TStrings; const FName: string);
var
  InF: file;
  _fsize: integer;
  Buffer, P, i, Last: PAnsiChar;
begin
  if clear then
    s.clear;

  assignFile(InF, FName);
{$I-}
  FileMode := fmOpenRead; // read only, from CDR for example
  reset(InF, 1);
  FileMode := fmOpenReadWrite; // restore FileMode
  if (ioresult <> 0) then
    exit;
{$I+}
  _fsize := filesize(InF);

  if (_fsize > 0) then
  begin
    GetMem(Buffer, _fsize + 3);
    Buffer^ := #0;
    P := Buffer + 1;
    BlockRead(InF, P^, _fsize);
    CloseFile(InF);

    Last := P + _fsize;
    Last^ := #$0A; // letzte Zeile wird sicher gefunden!
    (Last + 1)^ := #$00; // letze NULL wird sicher gefunden!

    // Null-Bytes in Blanks #32 verwandeln
    repeat
      i := StrScan(P, #$00);
      if (i > Last) then
        break;
      i^ := #$20;
      P := i + 1;
    until eternity;

    // In einzelne Zeilen auftrennen
    P := Buffer + 1;
    repeat
      i := StrScan(P, #$0A);
      if (i = nil) then
      begin
        i := Last;
      end
      else
      begin
        i^ := #0;
        if (i - 1)^ = #$0D then
          (i - 1)^ := #0;
      end;
      s.append(P);
      P := i + 1;
    until (P >= Last);
    FreeMem(Buffer);
  end
  else
  begin
    CloseFile(InF);
  end;

  {
    while OneLine<>'' do
    begin
    NewLine := nextp(OneLine,#$0A);
    l := length(NewLine);
    if l>0 then
    if NewLine[l]=#$0D then
    delete(NewLine,l,1);
    s.add(NewLine);
    end;


    while not(eof(InF)) do
    begin
    readln(InF,OneLine);
    while true do
    begin
    k := pos(#$0A,OneLine);
    if (k=0) then
    break;
    s.add(copy(OneLine,1,pred(k)));
    delete(OneLine,1,k);
    end;
    s.add(OneLine);
    end;
  }
end;

procedure LoadFromFileCSV(clear: boolean; s: TStrings; const FName: string);
var
  Stream: TFileStream;
  Buffer: array [0 .. 32767] of AnsiChar; // 32k Buffer
  {$ifdef fpc}
  TempStr: RawByteString;
  Encoded: boolean;
  {$else}
  TempStr: string;
  {$endif}
  i: integer;
  BufferUse: integer;
  LastWasCR: boolean;

  procedure add;
  begin
    {$ifdef fpc}
    s.add(ConvertEncodingToUTF8(TempStr,EncodingCP1252, Encoded));
    {$else}
    s.add(TempStr);
    {$endif}
  end;

begin
  if clear then
    s.clear;
  LastWasCR := false;
  TempStr := '';
  Stream := TFileStream.create(FName, fmOpenRead or fmShareDenyNone);
  repeat
    BufferUse := Stream.Read(Buffer, SizeOf(Buffer));
    for i := 0 to pred(BufferUse) do
    begin
      if (Buffer[i] = #$0D) then
      begin
        LastWasCR := true;
        add;
        TempStr := '';
      end
      else
      begin
        if (Buffer[i] = #$0A) then
        begin
          if not(LastWasCR) then
            TempStr := TempStr + cLineSeparator;
        end
        else
        begin
          TempStr := TempStr + Buffer[i];
        end;
        LastWasCR := false;
      end;
    end;
    if (BufferUse < SizeOf(Buffer)) then
      break;
  until eternity;
  if (TempStr <> '') then
    add;
  Stream.free;
end;

var
 _Betriebssystem : string = '';

function Betriebssystem: string;

{$IFDEF fpc}
{$IFDEF UNIX}
var
  Name: UtsName;
begin
  FpUname(name);
  with name do
    result := Sysname + Release + Version;
end;
{$ELSE}
begin
  result := 'Windows';
end;
{$ENDIF}
{$ELSE}

type
  Twine_get_version = function: PAnsiChar; stdcall;
var
  HNtDll: HMODULE;
  wine_get_version: Twine_get_version;
begin
 if (_Betriebssystem='') then
 begin
  HNtDll := LoadLibrary('ntdll.dll');
  if (HNtDll > HINSTANCE_ERROR) then
  begin
    wine_get_version := GetProcAddress(HNtDll, 'wine_get_version');
    if assigned(wine_get_version) then
      _Betriebssystem := 'wine-' + wine_get_version
    else
      _Betriebssystem := GetOSVersionString;
    FreeLibrary(HNtDll);
  end;
 end;
 result := _Betriebssystem;
end;
{$ENDIF}
// WIN REBOOT

{$ifdef MSWINDOWS}

function SetPrivilege(privilegeName: string; enable: boolean): boolean;
var
  tpPrev, tp: TTokenPrivileges;
  token: THandle;
  dwRetLen: dword;
begin
  result := false;
  OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, token);
  tp.PrivilegeCount := 1;
  if LookupPrivilegeValue(nil, PCHAR(privilegeName), tp.Privileges[0].LUID) then
  begin
    if enable then
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
    else
      tp.Privileges[0].Attributes := 0;
    dwRetLen := 0;
    result := windows.AdjustTokenPrivileges(token, false, tp, SizeOf(tpPrev), tpPrev, dwRetLen);
  end;
  CloseHandle(token);
end;

(*
  WinReboot1.WinExit(EW_REBOOTSYSTEM); windows
  WinReboot1.WinExit(EWX_SHUTDOWN or EWX_FORCE);

  {$EXTERNALSYM EW_RESTARTWINDOWS}
  EW_RESTARTWINDOWS        = $0042;
  {$EXTERNALSYM EW_REBOOTSYSTEM}
  EW_REBOOTSYSTEM          = $0043;
  {$EXTERNALSYM EW_EXITANDEXECAPP}
  EW_EXITANDEXECAPP        = $0044;

  {$EXTERNALSYM ENDSESSION_LOGOFF}
  ENDSESSION_LOGOFF        = DWORD($80000000);

  {$EXTERNALSYM EWX_LOGOFF}
  EWX_LOGOFF = 0;
  {$EXTERNALSYM EWX_SHUTDOWN}
  EWX_SHUTDOWN = 1;
  {$EXTERNALSYM EWX_REBOOT}
  EWX_REBOOT = 2;
  {$EXTERNALSYM EWX_FORCE}
  EWX_FORCE = 4;
  {$EXTERNALSYM EWX_POWEROFF}
  EWX_POWEROFF = 8;
  {$EXTERNALSYM EWX_FORCEIFHUNG}
  EWX_FORCEIFHUNG = $10;
*)

function WinNT: boolean;
begin
  result := (Win32Platform = VER_PLATFORM_WIN32_NT);
end;

function WindowsClose(flags: integer): boolean;
begin
  if WinNT then
    SetPrivilege('SeShutdownPrivilege', true);
  result := ExitWindowsEx(flags, 0);
  if WinNT then
    SetPrivilege('SeShutdownPrivilege', false);
end;

procedure WindowsHerunterfahren;
begin
  WindowsClose(EWX_SHUTDOWN or EWX_FORCE);
end;

// procedure WindowsNeuStarten;
// begin
// WindowsClose(EW_REBOOTSYSTEM);
// end;

function NewAdjustTokenPrivileges(TokenHandle: THandle; DisableAllPrivileges: bool; const NewState: TTokenPrivileges;
  BufferLength: dword; PreviousState: PTokenPrivileges; ReturnLength: pdword): bool; stdcall;
  external advapi32 name 'AdjustTokenPrivileges';

procedure WindowsNeuStarten;
{ Restarts the computer. The function will NOT return if it is successful,
  since Windows kills the process immediately after sending it a WM_ENDSESSION
  message. }

  procedure RestartErrorMessage;
  begin
    MessageBox(0, PCHAR('Neustart nicht mˆglich'), PCHAR('Fehler'), MB_OK or MB_ICONEXCLAMATION);
  end;

var
  token: THandle;
  TokenPriv: TTokenPrivileges;
const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege'; { don't localize }
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    if not OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, token) then
    begin
      RestartErrorMessage;
      exit;
    end;

    LookupPrivilegeValue(nil, SE_SHUTDOWN_NAME, TokenPriv.Privileges[0].LUID);

    TokenPriv.PrivilegeCount := 1;
    TokenPriv.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;

    NewAdjustTokenPrivileges(token, false, TokenPriv, 0, nil, nil);

    { Cannot test the return value of AdjustTokenPrivileges. }
    if GetLastError <> ERROR_SUCCESS then
    begin
      RestartErrorMessage;
      exit;
    end;
  end;
  if not ExitWindowsEx(EWX_REBOOT or EWX_FORCE or EWX_FORCEIFHUNG, 0) then
    RestartErrorMessage;

  { If ExitWindows/ExitWindowsEx were successful, program execution halts here
    (at least on Win95) }
end;

procedure WindowsAbmelden;
begin
  // %windir%\system32\rundll32.exe user32.dll,LockWorkStation
end;

{$ENDIF}

const
  MacCodeTable: array [0 .. 255] of AnsiChar =

    ( { 000 }{ } NVAC, { , } #044, { } NVAC, { } NVAC, { } NVAC, { } NVAC,
    { } NVAC, { } NVAC,
    { 008 }{ } NVAC, { } NVAC, { } NVAC, { c } #013, { } NVAC, { } NVAC,
    { } NVAC, { } NVAC,
    { 016 }{ } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC,
    { } NVAC, { } NVAC,
    { 024 }{ } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC,
    { } NVAC, { } NVAC,
    { 032 }{ } #032, { ! } #033, { " } #034, { # } #035, { d } #036,
    { % } #037, { & } #038, { ' } #039,
    { 040 }{ ( } #040, { ) } #041, { * } #042, { + } #043, { , } #044,
    { - } #045, { . } #046, { / } #047,
    { 048 }{ 0 } #048, { 1 } #049, { 2 } #050, { 3 } #051, { 4 } #052,
    { 5 } #053, { 6 } #054, { 7 } #055,
    { 056 }{ 8 } #056, { 9 } #057, { : } #058, { ; } #059, { < } #060,
    { = } #061, { > } #062, { ? } #063,
    { 064 }{ @ } #064, { A } #065, { B } #066, { C } #067, { D } #068,
    { E } #069, { F } #070, { G } #071,
    { 072 }{ H } #072, { I } #073, { J } #074, { K } #075, { L } #076,
    { M } #077, { N } #078, { O } #079,
    { 080 }{ P } #080, { Q } #081, { R } #082, { S } #083, { T } #084,
    { U } #085, { V } #086, { W } #087,
    { 088 }{ X } #088, { Y } #089, { Z } #090, { [ } #091, { \ } #092,
    { ] } #093, { ^ } #094, { _ } #095,
    { 096 }{ ` } #096, { a } #097, { b } #098, { c } #099, { d } #100,
    { e } #101, { f } #102, { g } #103,
    { 104 }{ h } #104, { i } #105, { j } #106, { k } #107, { l } #108,
    { m } #109, { n } #110, { o } #111,
    { 112 }{ p } #112, { q } #113, { r } #114, { s } #115, { t } #116,
    { u } #117, { v } #118, { w } #119,
    { 120 }{ x } #120, { y } #121, { z } #122, { ( } #123, { } NVAC,
    { ) } #125, { } NVAC, { } NVAC,
    { 128 }{ ƒ } #196, { } '≈', { } NVAC, { … } #201, { } NVAC, { ÷ } #214,
    { ‹ } #220, { · } #225,
    { 136 }{ ‡ } #224, { ‚ } #226, { ‰ } #228, { } NVAC, { } 'Â', { Á } #231,
    { È } #233, { Ë } #232,
    { 144 }{ Í } #234, { Î } #235, { Ì } #237, { } NVAC, { } 'Ó', { } 'Ô',
    { } NVAC, { Û } #243,
    { 152 }{ Ú } #242, { } 'Ù', { ˆ } #246, { } NVAC, { ˙ } #250, { } '˘',
    { ˚ } #251, { ¸ } #252,
    { 160 }{ } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC,
    { } NVAC, { ﬂ } #223,
    { 168 }{ } NVAC, { } '©', { } NVAC, { ' } #039, { } NVAC, { } NVAC,
    { } NVAC, { } NVAC,
    { 176 }{ } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC,
    { } NVAC, { } NVAC,
    { 184 }{ } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC,
    { } NVAC, { } '¯',
    { 192 }{ } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC,
    { } NVAC, { } NVAC,
    { 200 }{ } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC,
    { } NVAC, { } NVAC,
    { 208 }{ } NVAC, { } NVAC, { " } #034, { " } #034, { ' } #039, { ' } #039,
    { } NVAC, { } NVAC,
    { 216 }{ } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC,
    { } NVAC, { } NVAC,
    { 224 }{ } NVAC, { } NVAC, { } NVAC, { " } #034, { } NVAC, { } NVAC,
    { } NVAC, { } NVAC,
    { 232 }{ } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC,
    { } NVAC, { } NVAC,
    { 240 }{ } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC,
    { } NVAC, { } NVAC,
    { 248 }{ } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC, { } NVAC,
    { } NVAC, { } NVAC);

function Ansi2Mac(const x: AnsiString): AnsiString;
const
  MacStr: AnsiString = 'âûÉíóòçëêúèÄéÜáàÖüößä„“”‘´’'#$0B#$01;
  WinStr: AnsiString = '‚˚…ÌÛÚÁÎÍ˙ËƒÈ‹·‡÷¸ˆﬂ‰"""'''''''#$0D',';
var
  n, k: integer;
begin
  result := x;
  for n := 1 to length(result) do
  begin
    k := pos(result[n], WinStr);
    if k > 0 then
      result[n] := MacStr[k];
  end;
end;

function Mac2Ansi(const x: AnsiString): AnsiString;

(*
  MacCodeTable : array[0..255] of char =
  const
  MacStr     : string[35] = 'âûÉíóòçëêúèÄéÜáàÖüößä„“”‘´’'#$0B#$01;
  WinStr     : string[35] = '‚˚…ÌÛÚÁÎÍ˙ËƒÈ‹·‡÷¸ˆﬂ‰"""'''''''#$0D',';

  ( { }#000,{ }#001,{ }#002,{ }#003,{ }#004,{ }#005,{ }#006,{ }#007,
  { }#008,{ }#009,{ }#010,{ }#011,{ }#012,{ }#013,{ }#014,{ }#015,
  { }#016,{ }#017,{ }#018,{ }#019,{ }#020,{ }#021,{ }#022,{ }#023,
  { }#024,{ }#025,{ }#026,{ }#027,{ }#028,{ }#029,{ }#030,{ }#031,
  { }#032,{!}#033,{"}#034,{#}#035,{$}#036,{%}#037,{&}#038,{'}#039,
  {(}#040,{)}#041,{*}#042,{+}#043,{,}#044,{-}#045,{.}#046,{/}#047,
  {0}#048,{1}#049,{2}#050,{3}#051,{4}#052,{5}#053,{6}#054,{7}#055,
  {8}#056,{9}#057,{:}#058,{;}#059,{<}#060,{=}#061,{>}#062,{?}#063,
  {@}#064,{A}#065,{B}#066,{C}#067,{D}#068,{E}#069,{F}#070,{G}#071,
  {H}#072,{I}#073,{J}#074,{K}#075,{L}#076,{M}#077,{N}#078,{O}#079,
  {P}#080,{Q}#081,{R}#082,{S}#083,{T}#084,{U}#085,{V}#086,{W}#087,
  {X}#088,{Y}#089,{Z}#090,{[}#091,{\}#092,{]}#093,{^}#094,{_}#095,
  {`}#096,{a}#097,{ }#098,{ }#099,{ }#100,{ }#101,{ }#102,{ }#103,
  {h}#104,{ }#105,{ }#106,{ }#107,{ }#108,{ }#109,{ }#110,{ }#111,
  {p}#112,{ }#113,{ }#114,{ }#115,{ }#116,{ }#117,{ }#118,{ }#119,
  {x}#120,{y}#121,{z}#122,{ }#123,{ }#124,{ }#125,{ }#126,{ }#127,
  {«}#128,{ }#129,{ }#130,{ }#131,{ }#132,{ }#133,{ }#134,{ }#135,
  { }#136,{ }#137,{ }#138,{ }#139,{ }#140,{ }#141,{ }#142,{ }#143,
  { }#144,{ }#145,{ }#146,{ }#147,{ }#148,{ }#149,{ }#150,{ }#151,
  { }#152,{ }#153,{ }#154,{ }#155,{ }#156,{ }#157,{ }#158,{ }#159,
  { }#160,{ }#161,{ }#162,{ }#163,{ }#164,{ }#165,{ }#166,{ }#167,
  { }#168,{ }#169,{ }#170,{ }#171,{ }#172,{ }#173,{ }#174,{ }#175,
  { }#176,{ }#177,{ }#178,{ }#179,{ }#180,{ }#181,{ }#182,{ }#183,
  { }#184,{ }#185,{ }#186,{ }#187,{ }#188,{ }#189,{ }#190,{ }#191,
  { }#192,{ }#193,{ }#194,{ }#195,{ }#196,{ }#197,{ }#198,{ }#199,
  { }#200,{ }#201,{ }#202,{ }#203,{ }#204,{ }#205,{ }#206,{ }#207,
  { }#208,{ }#209,{ }#210,{ }#211,{ }#212,{ }#213,{ }#214,{ }#215,
  { }#216,{ }#217,{ }#218,{ }#219,{ }#220,{ }#221,{ }#222,{ }#223,
  { }#224,{ }#225,{ }#226,{ }#227,{ }#228,{ }#229,{ }#230,{ }#231,
  { }#232,{ }#233,{ }#234,{ }#235,{ }#236,{ }#237,{ }#238,{ }#239,
  { }#240,{ }#241,{ }#242,{ }#243,{ }#244,{ }#245,{ }#246,{ }#247,
  { }#248,{ }#249,{ }#250,{ }#251,{ }#252,{ }#253,{ }#254,{ }#255);

*)

var
  n: integer;
begin
  SetLength(result, length(x));
  for n := 1 to length(x) do
    result[n] := MacCodeTable[ord(x[n])];
end;

var
  CPUMhzCalculated: boolean = false;
  ClockStart: int64;
  _CPUkhz: int64;
  TickStart: dword;

function UpTime: TAnfixTime;
begin
  result := GetTickCount div 1000;
end;

function RunTime: TAnfixTime;
begin
  result := (GetTickCount - TickStart) div 1000;
end;

{$ifdef fpc}
function RDTSC: int64;
begin
  asm
    // DB 0FH
    // DB 31H
    rdtsc
  end;
end;

{$else}
function RDTSC: int64;
asm
  // DB 0FH
  // DB 31H
  rdtsc
end;
{$endif}

function CPUMhz: integer; // Frequence of CPU-Clock [MHz]
var
 t : cardinal;
begin
  if not(CPUMhzCalculated) then
  begin
    t := GetTickCount - TickStart;
    if (t>0) then
      _CPUkhz := (RDTSC - ClockStart) div t
    else
      _CPUkhz := (RDTSC - ClockStart);
    CPUMhzCalculated := true;
  end;
  result := _CPUkhz div 1000;
end;

function RDTSCms: int64; // ReaD Time Stamp Counter in [ms] since system-StartUp
begin
  if not(CPUMhzCalculated) then
    CPUMhz;
  if _CPUkhz>0 then
   result := (RDTSC - ClockStart) div _CPUkhz
  else
   result := (RDTSC - ClockStart)
end;

/// ///////////////

function fmMonetary(x: string): string;
begin
  x := StrFilter(x, '0123456789.,-+E');

  if (pos(',', x) > 0) and (pos('.', x) > 0) and (pos('.', x) < pos(',', x)) then
  begin
    // DE-Tausender-Punkte lˆschen!
    ersetze('.', '', x);
  end;

  if (pos(',', x) > 0) and (pos('.', x) > 0) and (pos(',', x) < pos('.', x)) then
  begin
    // US-Tausender-Kommas lˆschen!
    ersetze(',', '', x);
  end;

  ersetze(',', '.', x);
  result := x;
end;

function StrToDouble(x: string): double; overload;
var
  dummy: integer;
begin
  x := fmMonetary(x);
  val(x, result, dummy);
end;

function StrToDouble(x: string; var ValError : Boolean): double; overload;
var
  dummy: integer;
begin
  x := fmMonetary(x);
  val(x, result, dummy);
  ValError := (x='') or (dummy<>0)
end;

function StrToDoubleDef(x: string; d: double): double;
var
  dummy: integer;
begin
  x := fmMonetary(x);
  if (x = '') then
  begin
    result := d
  end
  else
  begin
    val(x, result, dummy);
    if dummy <> 0 then
      result := d;
  end;
end;

procedure greg_to_jul(dt: TDateTimeBorlandPascal; var jdt: juldate);
{ Gerald Rohr }
{ converts a tested gregorian date to a julian date }
begin
  with dt do
  begin
    jdt.yr := Year;
    if (Year = 0) and (Month = 0) and (Day = 0) then
      jdt.Day := 0
    else
    begin
      if (Schaltjahr(Year)) and (Month > 2) then
        jdt.Day := 1
      else
        jdt.Day := 0;
      jdt.Day := jdt.Day + monthtotal[Month] + Day;
    end;
  end;
end; { --- procedure greg_to_jul --- }

procedure jul_to_greg(jdt: juldate; var dt: TDateTimeBorlandPascal);
{ Gerald Rohr }
{ converts a tested julian date to a gregorian date }
var
  i, workday: integer;
begin
  with dt do
  begin
    Year := jdt.yr;
    if (jdt.yr = 0) and (jdt.Day = 0) then
    begin
      Month := 0;
      Day := 0;
    end
    else
    begin
      workday := jdt.Day;
      if (Schaltjahr(jdt.yr)) and (workday > 59) then
        workday := workday - 1; { make it look like a non-leap year }
      i := 1;
      repeat
        i := i + 1
      until not(workday > monthtotal[i]);
      i := i - 1;
      Month := i;
      Day := workday - monthtotal[i];
      if Schaltjahr(jdt.yr) and (jdt.Day = 60) then
        Day := Day + 1
    end;
  end;
end; { --- procedure jul_to_greg --- }

function dateDiff(d1, d2: longint): longint; { d1<d2 }
{ (c) Gerald Rohr }
{ computes the number of days between two dates }
var
  dt1, dt2: TDateTimeBorlandPascal;
  jdt1, jdt2: juldate;
  i, num_leap_yrs: longint;
begin

  if dateOK(d1) and dateOK(d2) then
  begin
    long2datetimeBorlandPascal(d1, dt1);
    long2datetimeBorlandPascal(d2, dt2);
    greg_to_jul(dt1, jdt1);
    greg_to_jul(dt2, jdt2);
    num_leap_yrs := 0; { adjust for leap years }
    if dt2.Year > dt1.Year then
    begin
      for i := dt1.Year to dt2.Year - 1 do
        if Schaltjahr(i) then
          num_leap_yrs := num_leap_yrs + 1
    end;

    if dt1.Year > dt2.Year then
    begin
      for i := dt2.Year to dt1.Year - 1 do
        if Schaltjahr(i) then
          num_leap_yrs := num_leap_yrs - 1;
    end;

    dateDiff := jdt2.Day - jdt1.Day + ((jdt2.yr - jdt1.yr) * 365) + num_leap_yrs;
  end
  else
    dateDiff := maxlongint; { something's wrong }
end;

function countdays2long(d: longint): longint; { Rudolf Regez }

{ converts d days from BASEYEAR, where: 1901<=BASEYEAR<=2100, in a
  DATE10_STR; valid date range: 1.1.0004<=DATE<=???? (at least 5101!)
  When DATE_DIFF is used to compute the days, add 1 day to include the starting
  point: d:=DATE_DIFF(baseyear_date,DATE)+1 in order to get the same date
  DATE back from DAYS_SINCE(d); BASEYEAR must be: 1.1.BASEYEAR,
  where: 1901<=BASEYEAR<=2100; example in FAR_DATE below }

var
  buf_baseyear, buf_d, x, y, z, i, jahr: longint;
  julia: juldate;
  dt: TDateTimeBorlandPascal;
begin
  if (baseyear < 1901) or (baseyear > 2100) then
    baseyear := 1901;
  { chose between:  1901<=baseyear<=2100! }
  buf_baseyear := baseyear;
  buf_d := d;

  if d <= 0 then
  begin
    if d mod 1461 = 0 then
      buf_baseyear := buf_baseyear - (abs(d) div 1461) * 4
    else
      buf_baseyear := buf_baseyear - (abs(d) div 1461 + 1) * 4;
    { move baseyear by whole leap-periods }
    if d mod 1461 = 0 then
      d := 0
    else
      d := d + (abs(d) div 1461 + 1) * 1461;
    buf_d := d;
  end;
  if buf_baseyear >= 0 then
  begin
    z := buf_baseyear mod 4;
    if z = 0 then
      z := 4; { leapyear }
    d := d + (z - 1) * 365; { standardize to year following a leapyear }
    x := d div 1461; { past whole leap-periods }
    jahr := buf_baseyear + (buf_d - x) div 365; { ca year }
    d := d - (x * 1461); { days in last (broken) period }
    if ((buf_d - x) mod 365 = 0) then
    begin
      Dec(jahr);
      if d = 0 then
      begin
        if (jahr >= 2100) then
        begin
          inc(jahr);
        end
        else if Schaltjahr(jahr) then
          d := 366
        else
          d := 365;
      end
      else
        d := 365; { 31.12.xxxx }
    end
    else
      d := buf_d - (jahr - buf_baseyear) * 365 - x; { days }

    y := (1900 div 100) - ((buf_baseyear - 1) div 100);
    { correct dates before
      1900 for non-leapyears 1900,1800,1700... }
    i := (buf_baseyear + 4) - 100 * (buf_baseyear div 100);
    if z <> 4 then
      i := i - 100;
    if z = i then
    begin
      if z = 2 then
        if (buf_d > 1095) then
          Dec(y);
      if z = 3 then
        if (buf_d > 730) then
          Dec(y);
      if (z = 4) then
        if (buf_d > 365) then
          Dec(y);
    end;

    y := y - (y div 4);
    if y < 0 then
      y := 0;
    for i := 1 to y do
    begin
      Dec(d);
      if d = 0 then
      begin
        Dec(jahr);
        if Schaltjahr(jahr) then
          d := 366
        else
          d := 365;
      end;
    end;

    y := ((jahr - 1) div 100) - (1900 div 100) - 1; { correct dates beyond
      2100 for non-leapyears 2200,2300,2500... }
    y := y - (y div 4);
    if y < 0 then
      y := 0;
    for i := 1 to y do
    begin
      if (d < 365) then
        inc(d)
      else if Schaltjahr(jahr) then
      begin
        if d = 366 then
        begin
          inc(jahr);
          d := 1;
        end
        else
          inc(d);
      end
      else if d = 365 then
      begin
        inc(jahr);
        d := 1;
      end;
    end;

    with julia do
    begin
      yr := jahr;
      Day := d;
    end;
    FillChar(dt, SizeOf(dt), 0);
    jul_to_greg(julia, dt); { build datetime-date }
    countdays2long := DateTime2long(dt);
    { build DD.MM.YYYY-string }
  end
  else
    countdays2long := maxlongint;
end; { function days_since }
(* ***************************** *)

function long2countdays(dlong: longint): longint; { Rudolf Regez }
{ calculate number of days from 1.1.BASEYEAR; the result fed as "d" into
  COUNTDAYS_INTO_DT should return same dt }
var
  base_dt: TDateTimeBorlandPascal;
  blong: longint;
begin
  if dateOK(dlong) then
  begin
    with base_dt do
    begin
      Year := baseyear;
      Month := 1;
      Day := 1;
    end;
    blong := DateTime2long(base_dt);
    long2countdays := dateDiff(blong, dlong) + 1;
    { add 1 day, it's number of the }
  end
  { days not the difference! } else
    long2countdays := maxlongint;
end;

function datePlus(dlong: TAnfixDate; plus: longint): TAnfixDate;
begin
  result := dlong;
  repeat

    // Sofort raus bei keiner Arbeit
    if (plus = 0) then
      break;

    // Wenn Datum an sich OK, das Ergebnis
    if dateOK(dlong) then
    begin
      result := countdays2long(long2countdays(dlong) + plus);
      break;
    end;

    //
    result := maxlongint;
  until yet;
end;

function NextMonth(dlong: TAnfixDate): TAnfixDate;
var
  m, d, y: integer;
begin
  long2details(dlong, y, m, d);
  d := 1;
  inc(m);
  if (m = 13) then
  begin
    m := 1;
    inc(y);
  end;
  result := Details2Long(y, m, d);
end;

function PrevMonth(dlong: TAnfixDate): TAnfixDate;
var
  m, d, y: integer;
begin
  long2details(dlong, y, m, d);
  d := 1;
  Dec(m);
  if (m = 0) then
  begin
    m := 12;
    Dec(y);
  end;
  result := Details2Long(y, m, d);
end;

function PrevQuartal(dlong: TAnfixDate) : TAnfixDate;
begin
  result := PrevMonth(PrevMonth(PrevMonth(dlong)));
end;

function NextQuartal(dlong: TAnfixDate) : TAnfixDate;
begin
  result := NextMonth(NextMonth(NextMonth(dlong)));
end;

function PrevYear(dlong: TAnfixDate) : TAnfixDate;
begin
  result := Details2Long(pred(extractYear(dlong)),1,1);
end;

function NextYear(dlong: TAnfixDate) : TAnfixDate;
begin
  result := Details2Long(succ(extractYear(dlong)),1,1);
end;

function Details2Long(j, m, T: integer): TAnfixDate;
begin
  result := (j * cDATE_YEAR_FAKTOR) + (m * cDATE_MONTH_FAKTOR) + (T * cDATE_DAY_FAKTOR);
end;

function ThisMonth(dlong: TAnfixDate): TAnfixDate;
var
  m, d, y: integer;
begin
  long2details(dlong, y, m, d);
  result := Details2Long(y, m, 1);
end;

function ThisQuartal(dlong: TAnfixDate): TAnfixDate;
var
  m, d, y: integer;
begin
  long2details(dlong, y, m, d);
  case m of
    2,3 : m := 1;
    5,6 : m := 4;
    8,9 : m := 7;
    11,12 : m := 10;
  end;
  result := details2Long(y,m,1);
end;

function ThisYear(dlong: TAnfixDate): TAnfixDate;
begin
  result := Details2Long(ExtractYear(dlong), 1, 1);
end;

function extractDay(dlong: TAnfixDate): integer;
var
  m, d, y: integer;
begin
  long2details(dlong, y, m, d);
  result := d;
end;

function extractMonth(dlong: TAnfixDate): integer;
var
  m, d, y: integer;
begin
  long2details(dlong, y, m, d);
  result := m;
end;

function extractYear(dlong: TAnfixDate): integer;
var
  m, d, y: integer;
begin
  long2details(dlong, y, m, d);
  result := y;
end;

procedure long2details(dlong: TAnfixDate; var j, m, T: integer);
begin
  j := dlong div cDATE_YEAR_FAKTOR;
  dlong := dlong mod cDATE_YEAR_FAKTOR;
  m := dlong div cDATE_MONTH_FAKTOR;
  dlong := dlong mod cDATE_MONTH_FAKTOR;
  T := dlong;
end;

function WerktagDatePlus(StartD: TAnfixDate; plus: integer): TAnfixDate;
var
  Werktage: integer;
begin
  Werktage := 0;
  while (Werktage < plus) do
  begin
    StartD := datePlus(StartD, 1);
    if WeekDay(StartD) < 6 then
      inc(Werktage);
  end;
  result := StartD;
end;

function datePlusWorking(dlong: TAnfixDate; plus: integer): TAnfixDate;
var
  Richtung: integer;
begin
  result := dlong;
  if (plus = 0) then
    exit;

  if (plus > 0) then
    Richtung := 1
  else
    Richtung := -1;

  repeat
    result := datePlus(result, Richtung);
    if (WeekDay(result) < cDATE_SAMSTAG) and not(Feiertag(result)) then
      plus := plus - Richtung;
  until (plus = 0);
end;

function NearestDate(dlong: TAnfixDate; WeekDay: integer): TAnfixDate;
begin
  result := 0;
end;

function DateInside(d, dStart, DEnd: longint): boolean;
begin
  { no date, not inside at all }
  if d = 0 then
  begin
    DateInside := false;
    exit;
  end;

  DateInside := true;

  { Fact: d<>0 }
  if (dStart = 0) and (DEnd = 0) then
    exit;

  { Fact: d<>0, one of (dStart,dEnd)<>0 }
  if (dStart = 0) and (d <= DEnd) then
    exit;

  { Fact: d<>0, one of (dStart,dEnd)<>0 }
  if (DEnd = 0) and (d >= dStart) then
    exit;

  if (dStart <> 0) and (DEnd <> 0) and (d >= dStart) and (d <= DEnd) then
    exit;

  DateInside := false;
end;

function DateCollision(aStart, aEnd, bStart, bEnd: TAnfixDate): boolean;
begin
  result := (aStart <= bEnd) and (aEnd >= bStart);
end;

function IntToStrN(const i: int64; n: byte): string;
begin
  result := inttostr(i);
  result := fill('0', n - length(result)) + result;
end;

function IntToStrN(const s: string; n: byte): string;
begin
  result := IntToStrN(StrToIntDef(s, 0), n);
end;

function int64tostr(i: int64): string;
begin
  result := inttostr(i);
end;

function IntToBStr(i: integer): string;
begin
  SetLength(result, SizeOf(integer));
  Move(i, result[1], SizeOf(integer));
end;

function WordToBStr(w: Word): string;
begin
  SetLength(result, SizeOf(Word));
  Move(w, result[1], SizeOf(Word));
end;

function BStrToInt(const s: string): integer;
begin
  if length(s) >= SizeOf(integer) then
    Move(s[1], result, SizeOf(integer))
  else
    result := MaxInt;
end;

function BStrToWord(const s: string): Word;
begin
  if length(s) >= SizeOf(Word) then
    Move(s[1], result, SizeOf(Word))
  else
    result := MaxWord;
end;

function NextP(var s: string; Delimiter: string): string;
var
  k: integer;
begin
  k := pos(Delimiter, s);
  if k > 0 then
  begin
    result := copy(s, 1, pred(k));
    delete(s, 1, pred(k + length(Delimiter)));
  end
  else
  begin
    result := s;
    s := '';
  end;
end;

{$IFNDEF fpc}

function NextP(var s: AnsiString; Delimiter: string): AnsiString;
var
  k: integer;
begin
  k := pos(Delimiter, s);
  if k > 0 then
  begin
    result := copy(s, 1, pred(k));
    delete(s, 1, pred(k + length(Delimiter)));
  end
  else
  begin
    result := s;
    s := '';
  end;
end;
{$ENDIF}

function rNextP(var s: string; Delimiter: string): string;
var
  k: integer;
begin
  k := revPos(Delimiter, s);
  result := copy(s, succ(k), MaxInt);
  s := copy(s, 1, pred(k));
end;

function NextP(var s: Shortstring; Delimiter: Shortstring): Shortstring;
var
  k: integer;
begin
  k := pos(Delimiter, s);
  if (k > 0) then
  begin
    result := copy(s, 1, pred(k));
    delete(s, 1, pred(k + length(Delimiter)));
  end
  else
  begin
    result := s;
    s := '';
  end;
end;

function NextP(s: string; Delimiter: string; SkipCount: integer): string;
var
  n, k: integer;
begin

  // Felder am Anfang lˆschen
  for n := 1 to SkipCount do
  begin
    k := pos(Delimiter, s);
    if (k > 0) then
    begin
      delete(s, 1, pred(k + length(Delimiter)))
    end
    else
    begin
      result := '';
      exit;
    end;
  end;

  // Rest bis Delimiter rausschneiden!
  k := pos(Delimiter, s);
  if k > 0 then
  begin
    result := copy(s, 1, pred(k));
  end
  else
  begin
    result := s;
  end;
end;

function FromP(s: string; Delimiter: string; SkipCount: integer): string;
var
  n, k: integer;
begin

  // Felder am Anfang lˆschen
  for n := 1 to SkipCount do
  begin
    k := pos(Delimiter, s);
    if (k > 0) then
    begin
      delete(s, 1, pred(k + length(Delimiter)))
    end
    else
    begin
      result := '';
      exit;
    end;
  end;
  result := s;

end;

function ReplaceP(s: string; Delimiter: string; SkipCount: integer; NewP: string): string;
var
  Pre: string;
begin
  Pre := '';
  while (SkipCount > 0) do
  begin
    Pre := Pre + NextP(s, Delimiter) + Delimiter;
    Dec(SkipCount);
  end;
  NextP(s, Delimiter);
  result := Pre + NewP + Delimiter + s;
end;

function FieldCount(const s: string; Delimiter: char): integer;
var
  n: integer;
begin
  result := 0;
  for n := 1 to length(s) do
    if Delimiter = s[n] then
      inc(result);
end;

// split('A;;C') -> Count=3, ['A','','C']
// split('') -> Count=1, ['']
// split(';') -> Count=2, ['','']

function Split(s: string; Delimiter: string = ';'; Quote: string = ''; Trim: boolean = false): TStringList;
var
  QuoteLength: integer;
  QuoteEnd: integer;
begin
  QuoteLength := length(Quote);
  result := TStringList.create;
  if (QuoteLength = 0) then
  begin
    repeat

      if (pos(Delimiter, s) = 0) then
      begin
        result.add(s);
        break;
      end
      else
      begin
        result.add(NextP(s, Delimiter));
      end;
    until eternity;
  end
  else
  begin
    repeat

      if (pos(Quote, s) = 1) then
      begin
        system.delete(s, 1, QuoteLength);
        QuoteEnd := pos(Quote, s);
        if QuoteEnd = 0 then
        begin
          // ERROR: closing Quote expected
          result.add(s);
          s := '';
        end
        else
        begin
          result.add(copy(s, 1, pred(QuoteEnd)));
          system.delete(s, 1, pred(QuoteEnd + QuoteLength));
          NextP(s, Delimiter);
        end;
      end
      else
      begin
        if (pos(Delimiter, s) = 0) then
        begin
          result.add(s);
          break;
        end
        else
        begin
          result.add(NextP(s, Delimiter));
        end;
      end;
    until eternity;
  end;
  if Trim then
    noblank(result);
end;

// values['Name'] := '' delete this Line completely - i dont want this

procedure SetValueSmart(s: TStrings; Name, Value: string);
var
  i: integer;
begin
  with s do
  begin
    i := IndexOfName(Name);
    if (i < 0) then
      i := add('');
    s[i] := Name + NameValueSeparator + Value;
  end;
end;

procedure WordWrap(s: TStrings; Columns:Integer);
var
 t,l,w: string;
begin
    // Word Wrap, split Lines that are too long
  // full new Arangement of the strings
  t := HugeSingleLine(s,' ');
  s.Clear;

  l := '';
  repeat
   if (t='') then
    break;
   w := nextp(t,' ');
   if (length(l+' '+w)>Columns) then
   begin
    s.Add(l);
    // Begin a new line
    l := w;
   end else
   begin
     // Add the Word to "l"
     if (l='') then
      l := w
     else
      l := l + ' ' + w;
   end;
  until eternity;
  s.Add(l);
end;

function HugeSingleLine(s: TStrings; Delimiter: string = #13; MaxLines: integer = MaxInt; sFree: boolean = false): string;
var
  n: integer;

  function freeDelimiter(s: string): string;
  begin
    result := s;
    if (Delimiter <> ' ') then
      ersetze(Delimiter, '*', result);
  end;

begin
  if (s.Count > 0) then
  begin
    result := freeDelimiter(s[0]);
    for n := 1 to Min(pred(s.Count), pred(MaxLines)) do
      result := result + Delimiter + freeDelimiter(s[n]);
  end
  else
  begin
    result := '';
  end;
  if sFree then
   s.Free;
end;

{$ifdef MSWINDOWS}

var
  _ProgramFilesDir: string = '';

function ProgramFilesDir: string;
begin
  if (_ProgramFilesDir = '') then
  begin
    _ProgramFilesDir := GetProgramFilesFolder;
    if (_ProgramFilesDir = '') then
      _ProgramFilesDir := 'C:\Program Files';
    _ProgramFilesDir := _ProgramFilesDir + '\';
  end;
  result := _ProgramFilesDir;
end;

function ApplicationDataDir: string;
begin
  result := ValidatePathName(GetAppdataFolder) + '\';
end;

function WindowsPfad(CSIDL : integer) : string;
var
   DirArray : array[0..MAX_PATH] of Char;
   PIDL : PItemIDList;
begin
  SHGetSpecialFolderLocation(0, CSIDL, PIDL);
  SHGetPathFromIDList(PIDL, DirArray);
  Result := DirArray;
end;

function PersonalDataDir_By_CSIDL: string;
begin
 result := ValidatePathName(WindowsPfad(CSIDL_PERSONAL)) + '\';
end;

function PersonalDataDir_By_Reg: string;
var
  reg: TRegistry;
begin
  reg := TRegistry.create;
  with reg do
  begin
    RootKey := HKEY_CURRENT_USER;
    OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders', false);
    result := ReadString('Personal')+'\';
    ersetze('%USERPROFILE%', GetEnvironmentVariable('USERPROFILE'), result);
    CloseKey;
  end;
  reg.Free;
end;

var
 _PersonalDataDir: String = '';

function PersonalDataDir: string;
begin
 if (_PersonalDataDir='') then
 begin
   _PersonalDataDir := PersonalDataDir_By_CSIDL;
   if (pos('::', _PersonalDataDir)>0) then
    _PersonalDataDir := PersonalDataDir_By_Reg;
 end;
 result := _PersonalDataDir;
end;

{$endif}

function DirExists(const dir: string): boolean;
var
  _FileGetAttr: integer;
begin
  _FileGetAttr := FileGetAttr(ValidatePathName(dir));
  result := (_FileGetAttr <> -1) and (_FileGetAttr and faDirectory = faDirectory);
end;

function DirSize(dir: string): int64; // WARNING: Time consuming
var
  sr: Tsearchrec;
  DosError: integer;
  l: integer;
begin
  result := 0;
  l := length(dir);
  if (l > 0) then
  begin
    if (dir[l] <> PathDelim) then
      dir := dir + PathDelim;
    DosError := findfirst(dir + '*', faAnyFile, sr);
    while (DosError = 0) do
    begin
      repeat
        if (sr.Name = '.') then
          break;
        if (sr.Name = '..') then
          break;
        if (sr.Attr and faDirectory = faDirectory) then
          inc(result, DirSize(dir + sr.Name))
        else
          inc(result, sr.Size);
      until yet;
      DosError := FindNext(sr);
    end;
    findclose(sr);
  end;
end;

procedure CheckCreateDir(dir: string);
var
  l: integer;
begin
  l := length(dir);
  if (l = 0) then
    exit;
  if (dir[l] = PathDelim) then
    SetLength(dir, pred(l));
  if DirExists(dir) or (length(dir) < 3) then
    exit;
  CheckCreateDir(ExtractFilePath(dir));
  // imp pend: Migration auf CreateDir(dir);
{$I-}
  MkDir(dir);
{$I+}
  if (ioresult <> 0) then
   Log('ERROR: mkdir '+dir, true);
end;

function strtol(x: string): longint;
var
  l: longint;
  dummy: integer;
begin
  ersetze('.', ' ', x);
  x := noblank(x);
  val(x, l, dummy);
  if (x = '') or (dummy <> 0) then
    l := 0;
  strtol := l;
end;

function strtodword(s: string): dword;
var
  dummy: integer;
begin
  ersetze('.', ' ', s);
  s := noblank(s);
  val(s, result, dummy);
  if (s = '') or (dummy <> 0) then
    result := 0;
end;

function Oem2Ansi(const x: AnsiString): AnsiString;
var
  Dest: PAnsiChar;
begin
  GetMem(Dest, succ(length(x)));
  {$ifdef MSWINDOWS}
  OemToCharA(PAnsiChar(x), Dest);
  {$endif}
  result := Dest;
  FreeMem(Dest, succ(length(x)));
end;

function Oem2asci(const x: AnsiString): AnsiString;
begin
  result := x;
  ersetze('Å', 'ue', result);
  ersetze('î', 'oe', result);
  ersetze('Ñ', 'ae', result);
  ersetze('ö', 'Ue', result);
  ersetze('ô', 'Oe', result);
  ersetze('é', 'Ae', result);
  ersetze('·', 'sz', result);
end;

function Oem2utf8(const x: AnsiString): string;
begin
  result := x;
  ersetze('Å', '¸', result);
  ersetze('î', 'ˆ', result);
  ersetze('Ñ', '‰', result);
  ersetze('ö', '‹', result);
  ersetze('ô', '÷', result);
  ersetze('é', 'ƒ', result);
  ersetze('·', 'ﬂ', result);
end;

function asci(const x: string): string;
begin
  result := x;
  if length(result) > 0 then
  begin
    ersetze('¸', 'ue', result);
    ersetze('ˆ', 'oe', result);
    ersetze('‰', 'ae', result);
    ersetze('‹', 'Ue', result);
    ersetze('÷', 'Oe', result);
    ersetze('ƒ', 'Ae', result);
    ersetze('ﬂ', 'sz', result);
  end;
end;

function ANSI2OEM(x: AnsiString): AnsiString;
var
  Dest: PAnsiChar;
begin
  GetMem(Dest, succ(length(x)));
  {$ifdef MSWINDOWS}
  CharToOemA(PAnsiChar(x), Dest);
  {$endif}
  result := Dest;
  FreeMem(Dest, succ(length(x)));
end;

{
  const
  _ansi =             '¸ˆ‰‹÷ƒﬂ';
  _oem  : string[7] = 'ÅîÑöôé·';
  var
  n,p : integer;
  begin
  for n := 1 to length(x) do
  begin
  p := pos(x[n],_ansi);
  if p>0 then
  x[n] := _oem[p];
  end;
  ANSI2OEM := x;
  end;
}

function ltostr(l: longint; st: byte): string;
var
  s: string;
begin
  str(l: st, s);
  if (l >= 1000) then
  begin
    insert('.', s, length(s) - 2);
    if s[1] = ' ' then
      delete(s, 1, 1);
  end;
  if l >= 1000000 then
  begin
    insert('.', s, length(s) - 6);
    if s[1] = ' ' then
      delete(s, 1, 1);
  end;
  ltostr := s;
end;

function StreamsEqual(s1, s2: TStream): boolean;
const
  BLOCK_SIZE = 4096;
type
  TBlockBuffer = array [0 .. BLOCK_SIZE - 1] of char;
var
  Buff1: TBlockBuffer;
  Buff2: TBlockBuffer;
  Size, left: integer;
begin
  result := true;
  while true do
  begin
    left := s1.Size - s1.Position;
    if (left = 0) then
      exit;
    if (left > SizeOf(Buff1)) then
      Size := SizeOf(Buff1)
    else
      Size := left;
    s1.Read(Buff1, Size);
    s2.Read(Buff2, Size);
    if not CompareMem(@Buff1, @Buff2, Size) then
    begin
      result := false;
      exit;
    end;
  end;
end;

function FileCompare(const FName1, FName2: string): boolean;
var
  a, b: TFileStream;
begin
  result := false;
  if (FSize(FName1) = FSize(FName2)) then
  begin
    try
      a := TFileStream.create(FName1, fmOpenRead + fmShareDenyNone);
      b := TFileStream.create(FName2, fmOpenRead + fmShareDenyNone);
      result := StreamsEqual(a, b);
      a.free;
      b.free;
    except
    end;
  end;
end;

procedure FileRemoveBOM(FileName: string);
const
  Buffer: array [1 .. 3] of byte = (32, 32, 32);
var
  a: TFileStream;
begin
  a := TFileStream.create(FileName, fmOpenReadWrite + fmShareExclusive);
  a.Write(Buffer, 3);
  a.free;
end;

procedure FileEmpty(const FName: string);
var
  OutF: file;
begin
  assignFile(OutF, FName);
  rewrite(OutF);
  CloseFile(OutF);
end;

procedure FileAlive(const FName: string);
begin
  if not(FileExists(FName)) then
    FileEmpty(FName);
end;

procedure FileLimitTo(const TextFName: string; MaximumSize: int64);
var
  MyStrings: TStringList;
  StartFrom: int64;
  SizeByNow: int64;
  n: integer;
  OutF: TextFile;
  SetSizeTo: int64;
begin
  if (FSize(TextFName) > MaximumSize) then
  begin
    MyStrings := TStringList.create;
    SetSizeTo := max((MaximumSize div 4) * 3, MaximumSize - (8 * 1024));
    StartFrom := 0;
    SizeByNow := 0;
    MyStrings.LoadFromFile(TextFName);
    for n := pred(MyStrings.Count) downto 0 do
    begin
      inc(SizeByNow, length(MyStrings[n]) + 2);
      if SizeByNow >= SetSizeTo then
      begin
        StartFrom := n;
        break;
      end;
    end;
    assignFile(OutF, TextFName);
    rewrite(OutF);
    for n := StartFrom to pred(MyStrings.Count) do
      writeln(OutF, MyStrings[n]);
    CloseFile(OutF);
    MyStrings.free;
  end;
end;

function FileReduce(const TextFName: string; MaximumSize: int64) : TStringList;
var
 FullStrings : TStringList;
 OverSize, UnLoadSize, UnLoadSizeSoll : int64;
 n, m: integer;
begin
  result := nil;

  // wie viel ist es dr¸ber?
  OverSize := FSize(TextFName) - MaximumSize;

  // ist die Handlungsschwelle erreicht?
  if (OverSize > 0) then
  begin

    // die Datei wird verkleinert auf unter "MaximumSize"
    // mindestens jedoch 10% der MaximumSize
    UnLoadSizeSoll := Max(OverSize, MaximumSize DIV 10);
    UnLoadSize := 0;

    result := TStringList.Create;
    result.LoadFromFile(TextFName);
    for n := 0 to pred(result.Count) do
    begin
      // Es gilt folgende Unsch‰rfe:
      // Platz einer Zeile auf dem Datentr‰ger = length(s) + 2
      inc (UnLoadSize, length(result[n]) + 2);
      if (UnLoadSize>=UnLoadSizeSoll) then
      begin
        FullStrings := TStringList.Create;
        FullStrings.Assign(result);

        // verkleinere bis zum Punkt "n"
        for m := n downto 0 do
          FullStrings.Delete(m);

        // ‹berschreibe die alte Version
        FullStrings.SaveToFile(TextFName);

        // sichere im "Result" die gelˆschten Zeilen
        for m := pred(result.Count) downto succ(n) do
          result.delete(m);
        break;
      end;
    end;
  end;
end;

function ExtractSegmentBetween(const InpStr, prefix, postfix: string; Upper: boolean = false): string;
var
  PrefixIndex, PostfixIndex: integer;
  InpStr2: string;
begin
  result := '';
  if Upper then
  begin
    InpStr2 := AnsiUpperCase(InpStr);
    PrefixIndex := pos(AnsiUpperCase(prefix), InpStr2);
    if (PrefixIndex = 0) then
      exit;
    inc(PrefixIndex, length(prefix));
    PostfixIndex := pos(AnsiUpperCase(postfix), InpStr2);
  end
  else
  begin
    PrefixIndex := pos(prefix, InpStr);
    if (PrefixIndex = 0) then
      exit;
    inc(PrefixIndex, length(prefix));
    PostfixIndex := pred(PrefixIndex + pos(postfix, copy(InpStr, PrefixIndex, MaxInt)));
  end;
  if (PostfixIndex = 0) then
    exit;
  if (PostfixIndex < PrefixIndex) then
    exit;
  result := copy(InpStr, PrefixIndex, PostfixIndex - PrefixIndex);
end;

function ValidateFName(x: string): string;
var
  n: integer;
begin
  result := '';
  for n := 1 to length(x) do
    if pos(x[n], cValidFNameChars) > 0 then
      result := result + x[n];
end;

function ValidatePathName(x: string): string; // Pfadname OHNE Slash am Ende
var
 l : Integer;
begin
  result := x;
  l := length(result);
  if (l>0) then
    if (pos(result[l], '/\') > 0) then
      delete(result, l, 1);
end;

procedure AppendStringsToFile(s: TStrings; const FName: string; Encapsulate: string = '');
var
  OutF: TextFile;
  n: integer;
begin
  assignFile(OutF, FName);
  ioresult;
{$I-}
  append(OutF);
{$I+}
  try
    if (ioresult <> 0) then
      rewrite(OutF);
    if (Encapsulate <> '') then
      writeln(OutF, Encapsulate + ' : {');
    for n := 0 to pred(s.Count) do
      writeln(OutF, s[n]);
    if (Encapsulate <> '') then
      writeln(OutF, '}');
    CloseFile(OutF);
  except
    // kann nicht (mehr) protokollieren
  end;
end;

procedure AppendIntegerStringsToFile(s: TStringList; FName: string; Encapsulate: string = '');
var
  OutF: TextFile;
  n: integer;
begin
  assignFile(OutF, FName);
  ioresult;
{$I-}
  append(OutF);
{$I+}
  try
    if ioresult <> 0 then
      rewrite(OutF);
    if (Encapsulate <> '') then
      writeln(OutF, Encapsulate + ' : {');
    for n := 0 to pred(s.Count) do
      writeln(OutF, IntToStr(PtrUInt(s.Objects[n])) + ';'  + s[n]);
    if (Encapsulate <> '') then
      writeln(OutF, '}');
    CloseFile(OutF);
  except
    // kann nicht (mehr) protokollieren
  end;
end;

procedure AppendStringsToFile(s: string; const FName: string; Encapsulate: string = '');
var
  OutF: TextFile;
begin
  assignFile(OutF, FName);
  ioresult;
{$I-}
  append(OutF);
{$I+}
  if (ioresult <> 0) then
    rewrite(OutF);
  if (Encapsulate <> '') then
    writeln(OutF, Encapsulate + ' : {');
  writeln(OutF, s);
  if (Encapsulate <> '') then
    writeln(OutF, '}');
  CloseFile(OutF);
end;

function IntToExtended(const i: integer): extended;
begin
  result := i;
end;

function mkrect(x, y, xl, yl: integer): TRect;
begin
  result := rect(x, y, x + xl, y + yl);
end;

procedure rZero(var r: TRect);
begin
  r := rect(0, 0, 0, 0);
end;

procedure rPercent(P: byte; cent: extended; var r: TRect);
var
  FullX: extended;
  Percent: extended;
  NewXL: integer;
begin
  FullX := rXL(r);
  Percent := P / cent;
  FullX := FullX * Percent;
  NewXL := round(FullX);
  rSetSize(NewXL, rYL(r), r);
end;

function Bin2HexStr(s: AnsiString): string;
var
  n: integer;
begin
  result := '';
  for n := 1 to length(s) do
    result := result + inttohex(ord(s[n]), 2);
end;

function Bin2HexStr(var d; DataLen: integer): string; overload;
var
  s: string;
begin
  SetLength(s, DataLen);
  Move(d, s[1], DataLen);
  result := Bin2HexStr(s);
end;

function HexStr2Bin(s: string): string;
begin
  result := '';
  s := cutblank(s);
  while (s <> '') do
  begin
    result := result + Chr(strtoint('$' + copy(s, 1, 2)));
    delete(s, 1, 2);
  end;
end;

procedure HexStr2Bin(s: string; var d); overload;
var
  ds: string;
begin
  ds := HexStr2Bin(s);
  Move(ds[1], d, length(ds));
end;

function GeneratePwd(FromSet: string; PwdLength: integer): string;
var
  n: integer;
begin
  randomize;
  result := '';
  for n := 1 to PwdLength do
    result := result + FromSet[succ(random(length(FromSet)))];
end;

//
// default: removes all chars except the well known in the filter (DeleteHits=false);
// removes chars the filter contain (DeleteHits=true)
//
// vorhandene Filter:
//
// cZiffern wird gerne als Filter verwendet

function StrFilter(s, Filter: string; DeleteHits: boolean = false): string;
var
  n: integer;
begin
  result := '';
  for n := 1 to length(s) do
    if ((pos(s[n], Filter) = 0) = DeleteHits) then
      result := result + s[n];
end;

function StrFilter(s, Filter: string; Hit: char): string;
var
  n: integer;
begin
  result := s;
  for n := 1 to length(s) do
    if (pos(s[n], Filter) > 0) then
      result[n] := Hit;
end;

function StrFilter(s: string; Filter: TSysCharSet; DeleteHits: boolean = false): string;
var
  n: integer;
begin
  result := '';
  for n := 1 to length(s) do
    if (not(CharInSet(s[n], Filter)) = DeleteHits) then
      result := result + s[n];
end;

function StrEncode(const s: string; key: string): string;
var
  DataBuffer: string;
begin
  DataBuffer := s;
  DataScramble(DataBuffer[1], length(s), key);
  result := Bin2HexStr(DataBuffer);
end;

function StrDecode(const s: string; key: string): string;
var
  DataBuffer: string;
begin
  DataBuffer := HexStr2Bin(s);
  DataScramble(DataBuffer[1], length(s) div 2, key);
  result := DataBuffer;
end;

function str2int(const s: string): integer;
begin
  if (s = '') then
    result := 0
  else
    result := strtoint(cutblank(s));
end;

function str2int64(const s: string): integer;
begin
  if (s = '') then
    result := 0
  else
    result := strtoint64(cutblank(s));
end;

procedure AddStringsCR(s: TStrings; lines: string);
begin
  while (lines <> '') do
    s.add(NextP(lines, #13));
end;

function FileTouch(FileName: string; date: TDateTime): boolean;
var
 fh : THandle;
 Res: Integer;
begin
 Log(FileName+':');
 result := false;
 repeat
  fh := FileOpen(FileName, fmOpenReadWrite Or fmShareExclusive);
  Log(' Handle='+IntToStr(fh));
  if (fh=INVALID_HANDLE_VALUE) then
   break;

  Res := FileSetDate(fh,DateTimeToFileDate(date));
  Log(' FileSetDate='+IntToStr(Res));

  result := (Res=0);
  FileClose(fh);
 until yet;
end;

function FileTouch(FName: string): boolean; // now
begin
  result := FileTouch(FName, SysUtils.NOW);
end;

function FileTouch(FName: string; ToDate: TAnfixDate): boolean;
begin
  result := FileTouch(FName, ToDate, 0);
end;

function FileTouch(FName: string; ToDate: TAnfixDate; ToTime: TAnfixTime): boolean;
var
  date: TDateTime;
begin
  date := mkDateTime(ToDate, ToTime);
  result := FileTouch(FName, date);
end;

function DatumUhr: string;
begin
  result := Datum10 + ' ' + uhr8;
end;

function mkDateTime(date: TAnfixDate; Time: TAnfixTime): TDateTime; overload;
var
  ye, mo, da, ho, mi, se, ms: Word;
begin
  //
  if SecondsOK(Time) then
  begin
    ho := Time div cOneHourInSeconds;
    Time := Time mod cOneHourInSeconds;
    mi := Time div cOneMinuteInSeconds;
    Time := Time mod cOneMinuteInSeconds;
    se := Time;
  end
  else
  begin
    ho := 0;
    mi := 0;
    se := 0;
  end;
  ms := 0;
  if dateOK(date) then
  begin
    ye := date div 10000;
    date := date mod 10000;
    mo := date div 100;
    date := date mod 100;
    da := date;
    result := encodedate(ye, mo, da) + EncodeTime(ho, mi, se, ms);
  end
  else
  begin
    result := EncodeTime(ho, mi, se, ms);
  end;
end;

function mkDateTime(s: string; dTimeStamp: boolean = false): TDateTime; overload;
var
  pDatum: TAnfixDate;
  pUhr: TAnfixTime;
begin
  if dTimeStamp then
    pDatum := TimeStamp2long(NextP(s, ' ', 0))
  else
    pDatum := date2long(NextP(s, ' ', 0));
  pUhr := StrToSeconds(NextP(s, ' ', 1));
  if dateOK(pDatum) and UhrOK(pUhr) then
    result := mkDateTime(pDatum, pUhr)
  else
    result := SysUtils.NOW;
end;

procedure SaveToUnixFile(s: TStrings; const FName: string);
var
  F: file;
  OneLine: string;
  n, PredLineCount: integer;
begin
  PredLineCount := pred(s.Count);
  assignFile(F, FName);
  rewrite(F, 1);
  for n := 0 to PredLineCount do
  begin
    if (n = PredLineCount) then
      OneLine := s[n]
    else
      OneLine := s[n] + #$0A;
    BlockWrite(F, OneLine[1], length(OneLine));
  end;
  CloseFile(F);
end;

{$ifdef MSWINDOWS}
{$ifndef fpc}
procedure CollectCPUData;
var
  BS: integer;
  i: integer;
  _PCB_Instance: PPERF_COUNTER_BLOCK;
  _PID_Instance: PPERF_INSTANCE_DEFINITION;
  st: TFileTime;

var
  h: HKEY;
  r: dword;
  dwDataSize, dwType: dword;
begin
  if _IsWinNT then
  begin
    BS := _BufferSize;
    while (RegQueryValueEx(HKEY_PERFORMANCE_DATA, Processor_IDX_Str, nil, nil, PBYTE(_PerfData), @BS)
      = ERROR_MORE_DATA) do
    begin
      // Get a buffer that is big enough.
      inc(_BufferSize, $1000);
      BS := _BufferSize;
      ReallocMem(_PerfData, _BufferSize);
    end;

    // Locate the performance object
    _POT := PPERF_OBJECT_TYPE(dword(_PerfData) + _PerfData.HeaderLength);
    for i := 1 to _PerfData.NumObjectTypes do
    begin
      if _POT.ObjectNameTitleIndex = Processor_IDX then
        break;
      _POT := PPERF_OBJECT_TYPE(dword(_POT) + _POT.TotalByteLength);
    end;

    // Check for success
    if _POT.ObjectNameTitleIndex <> Processor_IDX then
      raise Exception.create('Unable to locate the "Processor" performance object');

    if _ProcessorsCount < 0 then
    begin
      _ProcessorsCount := _POT.NumInstances;
      if _IsWin2000 then
        Dec(_ProcessorsCount);
      GetMem(_Counters, _ProcessorsCount * SizeOf(int64));
      GetMem(_PrevCounters, _ProcessorsCount * SizeOf(int64));
    end;

    // Locate the "% CPU usage" counter definition
    _PCD := PPERF_COUNTER_DEFINITION(dword(_POT) + _POT.HeaderLength);
    for i := 1 to _POT.NumCounters do
    begin
      if _PCD.CounterNameTitleIndex = CPUUsageIDX then
        break;
      _PCD := PPERF_COUNTER_DEFINITION(dword(_PCD) + _PCD.ByteLength);
    end;

    // Check for success
    if _PCD.CounterNameTitleIndex <> CPUUsageIDX then
      raise Exception.create('Unable to locate the "% of CPU usage" performance counter');

    // Collecting coutners
    _PID_Instance := PPERF_INSTANCE_DEFINITION(dword(_POT) + _POT.DefinitionLength);
    for i := 0 to _ProcessorsCount - 1 do
    begin
      _PCB_Instance := PPERF_COUNTER_BLOCK(dword(_PID_Instance) + _PID_Instance.ByteLength);

      _PrevCounters[i] := _Counters[i];
      _Counters[i] := int64(PInt64(dword(_PCB_Instance) + _PCD.CounterOffset)^);

      _PID_Instance := PPERF_INSTANCE_DEFINITION(dword(_PCB_Instance) + _PCB_Instance.ByteLength);
    end;

    _PrevSysTime := _SysTime;
    SystemTimeToFileTime(_PerfData.SystemTime, st);
    _SysTime := int64(int64(st));
  end
  else
  begin
    if not _W9xCollecting then
    begin
      r := RegOpenKeyEx(HKEY_DYN_DATA, 'PerfStats\StartStat', 0, KEY_ALL_ACCESS, h);
      if (r <> ERROR_SUCCESS) then
        raise Exception.create('Unable to start performance monitoring');

      dwDataSize := SizeOf(dword);

      RegQueryValueEx(h, 'KERNEL\CPUUsage', nil, @dwType, PBYTE(@_W9xCpuUsage), @dwDataSize);

      RegCloseKey(h);

      r := RegOpenKeyEx(HKEY_DYN_DATA, 'PerfStats\StatData', 0, KEY_READ, _W9xCpuKey);

      if (r <> ERROR_SUCCESS) then
        raise Exception.create('Unable to read performance data');

      _W9xCollecting := true;
    end;

    dwDataSize := SizeOf(dword);
    RegQueryValueEx(_W9xCpuKey, 'KERNEL\CPUUsage', nil, @dwType, PBYTE(@_W9xCpuUsage), @dwDataSize);
  end;
end;
{$O+}

function GetCPUCount: integer;
begin
  if _IsWinNT then
  begin
    if _ProcessorsCount < 0 then
      CollectCPUData;
    result := _ProcessorsCount;
  end
  else
  begin
    result := 1;
  end;
end;

function GetCPUUsage(Index: integer): double;
begin
  if _IsWinNT then
  begin
    if _ProcessorsCount < 0 then
      CollectCPUData;
    if (Index >= _ProcessorsCount) or (Index < 0) then
      raise Exception.create('CPU index out of bounds');
    if _PrevSysTime = _SysTime then
      result := 0
    else
      result := 1 - (_Counters[index] - _PrevCounters[index]) / (_SysTime - _PrevSysTime);
  end
  else
  begin
    if Index <> 0 then
      raise Exception.create('CPU index out of bounds');
    if not _W9xCollecting then
      CollectCPUData;
    result := _W9xCpuUsage / 100;
  end;
end;

function CPUUsage: integer;
var
  n: integer;
  VI: TOSVERSIONINFO;
begin
  if not(CPUUsageInit) then
  begin
    CPUUsageInit := true;
    _ProcessorsCount := -1;
    _BufferSize := $2000;
    _PerfData := AllocMem(_BufferSize);
    VI.dwOSVersionInfoSize := SizeOf(VI);
    if not GetVersionEx(VI) then
      raise Exception.create('Can''t get the Windows version');
    _IsWinNT := VI.dwPlatformId = VER_PLATFORM_WIN32_NT;
    _IsWin2000 := _IsWinNT and (VI.dwMajorVersion >= 5);
    _CPUcount := GetCPUCount;
  end;
  CollectCPUData; // Get the data for all processors

  result := 0;
  for n := 0 to pred(_CPUcount) do
    inc(result, round(GetCPUUsage(n) * 100));

  result := result div _CPUcount;

end;

function FileVersion(const FName: string): string;
var
  aFileName: array [0 .. MAX_PATH] of char;
  pdwHandle: dword;
  nInfoSize: dword;
  pFileInfo: pointer;
  pFixFInfo: PVSFixedFileInfo;
  nFixFInfo: dword;
  // pVarFInfo: PChar;
  // nVarFInfo: DWORD;
  // nVarTrans: DWORD;
  // aVarFPath: array[0..MAX_PATH] of Char;
begin

  // Gibt Versionsnummer zur¸ck
  StrPCopy(aFileName, FName);
  pdwHandle := 0;
  nInfoSize := GetFileVersionInfoSize(aFileName, pdwHandle);
  result := '0';
  if nInfoSize <> 0 then
    pFileInfo := GetMemory(nInfoSize)
  else
    pFileInfo := nil;
  if assigned(pFileInfo) then
    try
      if GetFileVersionInfo(aFileName, pdwHandle, nInfoSize, pFileInfo) then
      begin
        pFixFInfo := nil;
        nFixFInfo := 0;
        if VerQueryValue(pFileInfo, '\', pointer(pFixFInfo), nFixFInfo) then
        begin
          result := format('%d.%d.%d.%d', [
            { } HiWord(pFixFInfo^.dwFileVersionMS),
            { } LoWord(pFixFInfo^.dwFileVersionMS),
            { } HiWord(pFixFInfo^.dwFileVersionLS),
            { } LoWord(pFixFInfo^.dwFileVersionLS)]);
        end;
      end;
    finally
      FreeMemory(pFileInfo);
    end;
end;
{$endif}
{$endif}

procedure SystemLog(Event: string);
var
  OutF: TextFile;
begin
  assign(OutF, ExtractFilePath(Paramstr(0)) + ExtractFileNameWithoutExtension(ExtractFileName(Paramstr(0))) + '.log');
{$I-}
  append(OutF);
{$I+}
  if (ioresult <> 0) then
    rewrite(OutF);
  writeln(OutF, Event);
  CloseFile(OutF);
end;
{$ifdef MSWINDOWS}

function IsAdmin: boolean;
const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  DOMAIN_ALIAS_RID_ADMINS = $00000220;
var
  hAccessToken: THandle;
  ptgGroups: PTokenGroups;
  dwInfoBufferSize: Cardinal;
  psidAdministrators: PSID;
  x: integer;
begin
  result := false;
  if Win32Platform <> VER_PLATFORM_WIN32_NT then
  begin
    result := true;
    exit;
  end;
  if not OpenThreadToken(GetCurrentThread, TOKEN_QUERY, true, hAccessToken) then
  begin
    if GetLastError <> ERROR_NO_TOKEN then
      exit;
    if not OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, hAccessToken) then
      exit;
  end;
  try
    GetTokenInformation(hAccessToken, TokenGroups, nil, 0, dwInfoBufferSize);
    if GetLastError <> ERROR_INSUFFICIENT_BUFFER then
      exit;
    GetMem(ptgGroups, dwInfoBufferSize);
    try
      if not GetTokenInformation(hAccessToken, TokenGroups, ptgGroups, dwInfoBufferSize, dwInfoBufferSize) then
        exit;
      if not AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2, SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS, 0,
        0, 0, 0, 0, 0, psidAdministrators) then
        exit;
      try
        for x := 0 to ptgGroups^.GroupCount - 1 do
        begin
          if EqualSid(psidAdministrators, ptgGroups^.Groups[x].sid) then
          begin
            result := true;
            break;
          end;
        end;
      finally
        FreeSid(psidAdministrators);
      end;
    finally
      FreeMem(ptgGroups);
    end;
  finally
    CloseHandle(hAccessToken);
  end;
end; { Michael Winter }
{$endif}

function FloatToStrISO(Value: extended; Nachkommastellen: integer = 0): string;
var
  _DecimalSeparator: char;
  _ThousandSeparator: char;
begin
  _DecimalSeparator := FormatSettings.DecimalSeparator;
  _ThousandSeparator := FormatSettings.ThousandSeparator;

  // xml-usa
  FormatSettings.DecimalSeparator := '.';
  FormatSettings.ThousandSeparator := #0; // NO seperator!

  result := FloatToStr(Value);
  if (pos(FormatSettings.DecimalSeparator, result) = 0) then
    result := result + FormatSettings.DecimalSeparator + '0';

  if (Nachkommastellen > 0) then
  begin
    result := result + fill('0', Nachkommastellen - (length(result) - pos(FormatSettings.DecimalSeparator, result)));
  end;

  //
  FormatSettings.DecimalSeparator := _DecimalSeparator;
  FormatSettings.ThousandSeparator := _ThousandSeparator;
end;

function rtostr(r: real; stv, stn: byte): string;
var
  nstr, hstr: string;
  kpos: byte;
begin
  { Umwandlung in normalen String }
  if stn > 0 then
    str(r: (stv + stn + 1): stn, nstr)
  else
    str(r: stv: 0, nstr);
  nstr := noblank(nstr);
  kpos := pos('.', nstr);
  if (kpos <> 0) then
  begin
    nstr[kpos] := ',';
    hstr := copy(nstr, 1, kpos - 1);
  end
  else
    hstr := nstr;
  { Setzen der "Tausender" Punkte, Mio-Punkte }

  if (r >= 1000.0) or (r <= -1000.0) then
  begin
    if (r >= 0.0) then
    begin
      { r positiv }
      if (length(hstr) > 3) then
        insert('.', hstr, length(hstr) - 2);
      if (length(hstr) > 7) then
        insert('.', hstr, length(hstr) - 6);
    end
    else
    begin
      if (length(hstr) > 4) then
        insert('.', hstr, length(hstr) - 2);
      if (length(hstr) > 8) then
        insert('.', hstr, length(hstr) - 6);
    end;
  end;

  if length(hstr) > stv then
    hstr := 'ÒE';
  { Montieren des Endanfistr }
  if kpos = 0 then
    rtostr := fill(' ', stv - length(hstr)) + hstr
  else
    rtostr := fill(' ', stv - length(hstr)) + hstr + copy(nstr, kpos, 255);
end;

function DatumLocalized: string;
begin
  result := DateToStr(SysUtils.NOW);
end;

// Performance-Utils

var
  _perfFName: string = '';
  _perfms: int64 = 0;
  _Step: string = '';

procedure perfBegin(FName: string);
begin
  _perfFName := FName;
  _perfms := RDTSCms;
end;

procedure perfStep(JobDescription: string = '');
var
  Needed: integer;
begin
  Needed := RDTSCms - _perfms;
  if (_Step <> '') and (_perfFName <> '') then
    AppendStringsToFile(format('%s: %d ms', [_Step, Needed]), _perfFName);
  _Step := JobDescription;
  _perfms := RDTSCms;
end;

procedure perfEnd;
begin
  perfStep;
  _perfFName := '';
end;
{$ifdef MSWINDOWS}

Procedure PostKeyEx32(key: Word; Const shift: TShiftState; specialkey: boolean);
{ ************************************************************
  * Procedure PostKeyEx32
  *
  * Parameters:
  *  key    : virtual keycode of the key to send. For printable
  *           keys this is simply the ANSI code (Ord(character)).
  *  shift  : state of the modifier keys. This is a set, so you
  *           can set several of these keys (shift, control, alt,
  *           mouse buttons) in tandem. The TShiftState type is
  *           declared in the Classes Unit.
  *  specialkey: normally this should be False. Set it to True to
  *           specify a key on the numeric keypad, for example.
  * Description:
  *  Uses keybd_event to manufacture a series of key events matching
  *  the passed parameters. The events go to the control with focus.
  *  Note that for characters key is always the upper-case version of
  *  the character. Sending without any modifier keys will result in
  *  a lower-case character, sending it with [ssShift] will result
  *  in an upper-case character!
  ************************************************************ }

// JvKeyBoardStates
// JvgUtils

Type
  TShiftKeyInfo = Record
    shift: byte;
    vkey: byte;
  End;

  byteset = Set of 0 .. 7;
Const
  shiftkeys: Array [1 .. 3] of TShiftKeyInfo = ((shift: ord(ssCtrl); vkey: VK_CONTROL), (shift: ord(ssShift);
    vkey: VK_SHIFT), (shift: ord(ssAlt); vkey: VK_MENU));
Var
  flag: dword;
  bShift: byteset absolute shift;
  i: integer;
Begin
  For i := 1 To 3 Do
  Begin
    If shiftkeys[i].shift In bShift Then
      keybd_event(shiftkeys[i].vkey, MapVirtualKey(shiftkeys[i].vkey, 0), 0, 0);
  End; { For }
  if specialkey Then
    flag := KEYEVENTF_EXTENDEDKEY
  Else
    flag := 0;

  keybd_event(key, MapVirtualKey(key, 0), flag, 0);
  flag := flag or KEYEVENTF_KEYUP;
  keybd_event(key, MapVirtualKey(key, 0), flag, 0);

  For i := 3 DownTo 1 Do
  Begin
    If shiftkeys[i].shift In bShift Then
      keybd_event(shiftkeys[i].vkey, MapVirtualKey(shiftkeys[i].vkey, 0), KEYEVENTF_KEYUP, 0);
  End; { For }
End; { PostKeyEx32 }
{$endif}

var
 _StartDebugFName : string = '';
 _StartTime : int64;

procedure StartDebug(s: string);
const
 StartDebugLogFName = 'StartDebug.log';
begin
  if StartDebugger then
  begin
    if (_StartDebugFName='') then
    begin
     {$ifdef fpc}
     _StartDebugFName := GetUserDir + StartDebugLogFName;
     {$else}
     _StartDebugFName := GetEnvironmentVariable('USERPROFILE') + '\' + StartDebugLogFName;
     {$endif}
     {$ifdef CONSOLE}
     writeln('Start-Debug-Log ... ' + _StartDebugFName);
     {$endif}
     FileEmpty(_StartDebugFName);
     _StartTime := RDTSCms;
    end;
    AppendStringsToFile(IntTostr(RDTSCms-_StartTime)+'ms;'+s, _StartDebugFName);
  end;
end;

function nosemi(const s: string): string;
begin
  result := s;
  ersetze(';', ',', result);
  ersetze('"', '''', result);
end;

function StrRange(s: string): string;
var
  Sub: string;
  n, r1, r2: integer;

  procedure push(s: string);
  begin
    if (result = '') then
      result := cutblank(s)
    else
      result := result + ',' + cutblank(s);
  end;

begin
  result := '';
  while (s <> '') do
  begin
    Sub := NextP(s, ',');
    if pos('-', Sub) > 0 then
    begin
      r1 := StrToIntDef(noblank(NextP(Sub, '-', 0)), 0);
      r2 := StrToIntDef(noblank(NextP(Sub, '-', 1)), 0);
      for n := r1 to r2 do
        push(inttostr(n));
    end
    else
    begin
      push(Sub);
    end;
  end;
end;

function ShortenTime(Zeit:string): String;
begin
  result := Zeit;
  if (RevPos(':00',result)=6) then
   result := copy(result,1,5);
  if (RevPos(':00',result)=3) then
   result := copy(result,1,2);
end;

function ANSI_upper(const S: string): string;
const
 ANSI_8859_15_Upper : array[0..255] of char = (#$00, #$01,
  #$02, #$03, #$04, #$05, #$06, #$07, #$08, #$09, #$0A, #$0B, #$0C, #$0D, #$0E, #$0F, #$10, #$11,
  #$12, #$13, #$14, #$15, #$16, #$17, #$18, #$19, #$1A, #$1B, #$1C, #$1D, #$1E, #$1F, #$20, #$21,
  #$22, #$23, #$24, #$25, #$26, #$27, #$28, #$29, #$2A, #$2B, #$2C, #$2D, #$2E, #$2F, #$30, #$31,
  #$32, #$33, #$34, #$35, #$36, #$37, #$38, #$39, #$3A, #$3B, #$3C, #$3D, #$3E, #$3F, #$40, #$41,
  #$42, #$43, #$44, #$45, #$46, #$47, #$48, #$49, #$4A, #$4B, #$4C, #$4D, #$4E, #$4F, #$50, #$51,
  #$52, #$53, #$54, #$55, #$56, #$57, #$58, #$59, #$5A, #$5B, #$5C, #$5D, #$5E, #$5F, #$60, {#$61->}#$41,
  {#$62->}#$42, {#$63->}#$43, {#$64->}#$44, {#$65->}#$45, {#$66->}#$46, {#$67->}#$47, {#$68->}#$48, {#$69->}#$49, {#$6A->}#$4A, {#$6B->}#$4B, {#$6C->}#$4C, {#$6D->}#$4D, {#$6E->}#$4E, {#$6F->}#$4F, {#$70->}#$50, {#$71->}#$51,
  {#$72->}#$52, {#$73->}#$53, {#$74->}#$54, {#$75->}#$55, {#$76->}#$56, {#$77->}#$57, {#$78->}#$58, {#$79->}#$59, {#$7A->}#$5A, #$7B, #$7C, #$7D, #$7E, #$7F, #$80, #$81,
  #$82, #$83, #$84, #$85, #$86, #$87, #$88, #$89, #$8A, #$8B, #$8C, #$8D, #$8E, #$8F, #$90, #$91,
  #$92, #$93, #$94, #$95, #$96, #$97, #$98, #$99, #$9A, #$9B, #$9C, #$9D, #$9E, #$9F, #$A0, #$A1,
  #$A2, #$A3, #$A4, #$A5, #$A6, #$A7, {#$A8->}#$A6, #$A9, #$AA, #$AB, #$AC, #$AD, #$AE, #$AF, #$B0, #$B1,
  #$B2, #$B3, #$B4, #$B5, #$B6, #$B7, {#$B8->}#$B4, #$B9, #$BA, #$BB, #$BC, {#$BD->}#$BC, #$BE, #$BF, #$C0, #$C1,
  #$C2, #$C3, #$C4, #$C5, #$C6, #$C7, #$C8, #$C9, #$CA, #$CB, #$CC, #$CD, #$CE, #$CF, #$D0, #$D1,
  #$D2, #$D3, #$D4, #$D5, #$D6, #$D7, #$D8, #$D9, #$DA, #$DB, #$DC, #$DD, #$DE, #$DF, {#$E0->}#$C0, {#$E1->}#$C1,
  {#$E2->}#$C2, {#$E3->}#$C3, {#$E4->}#$C4, {#$E5->}#$C5, {#$E6->}#$C6, {#$E7->}#$C7, {#$E8->}#$C8, {#$E9->}#$C9, {#$EA->}#$CA, {#$EB->}#$CB, {#$EC->}#$CC, {#$ED->}#$CD, {#$EE->}#$CE, {#$EF->}#$CF, {#$F0->}#$D0, {#$F1->}#$D1,
  {#$F2->}#$D2, {#$F3->}#$D3, {#$F4->}#$D4, {#$F5->}#$D5, {#$F6->}#$D6, #$F7, {#$F8->}#$D8, {#$F9->}#$D9, {#$FA->}#$DA, {#$FB->}#$DB, {#$FC->}#$DC, {#$FD->}#$DD, {#$FE->}#$DE, {#$FF->}#$BE);
var
 l,n : Integer;
begin
 l := length(S);
 SetLength(result,l);
 for n := 1 to l do
  result[n] := ANSI_8859_15_Upper[ord(S[n])];
end;

function ANSI_lower(const S: string): string;
 const
ANSI_8859_15_Lower : array[0..255] of char = (#$00, #$01,
  #$02, #$03, #$04, #$05, #$06, #$07, #$08, #$09, #$0A, #$0B, #$0C, #$0D, #$0E, #$0F, #$10, #$11,
  #$12, #$13, #$14, #$15, #$16, #$17, #$18, #$19, #$1A, #$1B, #$1C, #$1D, #$1E, #$1F, #$20, #$21,
  #$22, #$23, #$24, #$25, #$26, #$27, #$28, #$29, #$2A, #$2B, #$2C, #$2D, #$2E, #$2F, #$30, #$31,
  #$32, #$33, #$34, #$35, #$36, #$37, #$38, #$39, #$3A, #$3B, #$3C, #$3D, #$3E, #$3F, #$40, {#$41->}#$61,
  {#$42->}#$62, {#$43->}#$63, {#$44->}#$64, {#$45->}#$65, {#$46->}#$66, {#$47->}#$67, {#$48->}#$68, {#$49->}#$69, {#$4A->}#$6A, {#$4B->}#$6B, {#$4C->}#$6C, {#$4D->}#$6D, {#$4E->}#$6E, {#$4F->}#$6F, {#$50->}#$70, {#$51->}#$71,
  {#$52->}#$72, {#$53->}#$73, {#$54->}#$74, {#$55->}#$75, {#$56->}#$76, {#$57->}#$77, {#$58->}#$78, {#$59->}#$79, {#$5A->}#$7A, #$5B, #$5C, #$5D, #$5E, #$5F, #$60, #$61,
  #$62, #$63, #$64, #$65, #$66, #$67, #$68, #$69, #$6A, #$6B, #$6C, #$6D, #$6E, #$6F, #$70, #$71,
  #$72, #$73, #$74, #$75, #$76, #$77, #$78, #$79, #$7A, #$7B, #$7C, #$7D, #$7E, #$7F, #$80, #$81,
  #$82, #$83, #$84, #$85, #$86, #$87, #$88, #$89, #$8A, #$8B, #$8C, #$8D, #$8E, #$8F, #$90, #$91,
  #$92, #$93, #$94, #$95, #$96, #$97, #$98, #$99, #$9A, #$9B, #$9C, #$9D, #$9E, #$9F, #$A0, #$A1,
  #$A2, #$A3, #$A4, #$A5, {#$A6->}#$A8, #$A7, #$A8, #$A9, #$AA, #$AB, #$AC, #$AD, #$AE, #$AF, #$B0, #$B1,
  #$B2, #$B3, {#$B4->}#$B8, #$B5, #$B6, #$B7, #$B8, #$B9, #$BA, #$BB, {#$BC->}#$BD, #$BD, {#$BE->}#$FF, #$BF, {#$C0->}#$E0, {#$C1->}#$E1,
  {#$C2->}#$E2, {#$C3->}#$E3, {#$C4->}#$E4, {#$C5->}#$E5, {#$C6->}#$E6, {#$C7->}#$E7, {#$C8->}#$E8, {#$C9->}#$E9, {#$CA->}#$EA, {#$CB->}#$EB, {#$CC->}#$EC, {#$CD->}#$ED, {#$CE->}#$EE, {#$CF->}#$EF, {#$D0->}#$F0, {#$D1->}#$F1,
  {#$D2->}#$F2, {#$D3->}#$F3, {#$D4->}#$F4, {#$D5->}#$F5, {#$D6->}#$F6, #$D7, {#$D8->}#$F8, {#$D9->}#$F9, {#$DA->}#$FA, {#$DB->}#$FB, {#$DC->}#$FC, {#$DD->}#$FD, {#$DE->}#$FE, #$DF, #$E0, #$E1,
  #$E2, #$E3, #$E4, #$E5, #$E6, #$E7, #$E8, #$E9, #$EA, #$EB, #$EC, #$ED, #$EE, #$EF, #$F0, #$F1,
  #$F2, #$F3, #$F4, #$F5, #$F6, #$F7, #$F8, #$F9, #$FA, #$FB, #$FC, #$FD, #$FE, #$FF);
var
 l,n : Integer;
begin
 l := length(S);
 SetLength(result,l);
 for n := 1 to l do
  result[n] := ANSI_8859_15_Lower[ord(S[n])];
end;

initialization
 ClockStart := RDTSC;
 TickStart := GetTickCount;

 StartDebugger := IsParam('--d');
 StartDebug('anfix');

finalization

{$ifdef MSWINDOWS}
 if CPUUsageInit then
 begin
   ReleaseCPUData;
   FreeMem(_PerfData);
 end;
{$endif}

end.
