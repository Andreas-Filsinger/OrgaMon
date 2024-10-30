{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2021  Andreas Filsinger
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
unit basic;
{
  D - BASIC - Interpreter
  (D ~ Druckvorlagen)

  Copyright (c) '12.91 by FILSINGER SOFTWARE
  Copyright (c) '12.03 by Andreas Filsinger

  12.12.91 erste Version fürs RAGAL.
  17.12.91 Interpreter ok.  Einbindung in LISED.
  21.01.92 kennt nur noch den Variablentyp "String"
  12.03.92 Bug: Überschreiben von Variablen-Inhalten
  10.04.92 Bug: RETURN, >, <, und andere
  11.04.92 Bug: PRN und NUL eingeführt
  20.04.92 INPUT eingeführt
  21.04.92 FILL-Bug
  02.06.92 ALIAS
  03.06.92 Bug: ClearBasic undefiniert
  16.02.93 Erweiterung für TÜV Hanover "CALL"
  02.03.93 Erweiterung "lange Varibalen-Namen"
  03.03.93 Bug: Variable am Ende einer Token-Line
  08.06.93 Erweiterung "FILE"-Funktions
  15.06.93 Erweiterung "END" und "SYSTEM"
  17.06.93 FSORT Implementierung
  02.07.93 E_BASIC.SYP und BASIC.ERR im "Ausführenden" Verzeichnis suchen
  Erweiterung für ASR-Basic
  05.05.95 NUL / PRN leiten jetzt "druckeraw" um, und nicht "drucke"
  16.12.03 Basic32,
  * Objekt(TStringList)
  * ausschliesslich für das Drucken
  * neu "FONT"
  * neu "MOVE"
  * neu für OrgaMon als Label-Druck-Prozessor
  12.12.06 erweitert um PREIS ( ) Funktion (erstmalige Anbindung an eCommerce)
  19.07.10 integration in OLAP
  08.06.11 PAGE (Seitenumbruch), Bugfixes im Dokumenthandling
  25.02.15 FPC Port
  05.03.18 Bug bei if string=string
  01.08.19 Bug in der Fehlerdatei, falsche Zeilennummer
           Bug beim Zusammenfügen von Zeilen
  27.01.20 Integration in die CareTakerClient Fehler Infrastruktur
  17.02.21 nicht mehr "32" im Quelltextdateiname
}

{$ifdef fpc}
{$mode delphi}
{$endif}

interface

uses
  classes;

const
  cPREDEF_FORMULAR = 'FORMULAR';
  cPREDEF_ANZAHL = 'ANZAHL';
  cPREDEF_TITEL = 'TITEL';
  cPREDEF_ZEILE = 'ZEILE';

  TOOMANYIDS = 1; { zuviele Objekte pro Zeile }
  NOMACROCLOSE = 2; { "¯" nicht vorhanden }
  NOQUOTECLOSE = 3; { """ nicht vorhanden }
  LABELTOOLONG = 4; { Sprungmarken-Bezeichnung zu lang }
  DUPLABEL = 5; { Sprungmarke bereits vergeben }
  TOOMANYLABELS = 6; { Zu viele Sprungmarken }
  GOSUBSTACKOVERFLOW = 7; { Zu tiefe Verschachtelung oder Rekursion }
  GOSUBSTACKUNDERFLOW = 8; { RETURN ohne vorherigen GOSUB-Aufruf }
  UNKOWNLABEL = 9; { Sprungmarke unbekannt }
  SYNTAXERROR = 10; { Anweisung unverst„ndlich }
  VAREXPECTED = 11; { Variabel erwartet }
  ERRORINLABEL = 12; { Fehler in Sprungmarke }
  USERBREAK = 13; { Abbruch durch ABORT }
  VARFORMERROR = 14; { kein gltiger Variablen-Eintrag }
  DIVISIONBYZERRO = 15; { Division durch "0" }
  NOTANUMBER = 16; { Fehler beim wandeln in eine Zahl }
  EOFBASIC = 17; { Basic-Source vorzeitig zuende }
  NONUL = 18; { PRN, ohne nach NUL zu schalten }
  ALREADYNUL = 19; { NUL nach NUL }
  ALIASTOLONG = 20; { AliasName ist zu lang }
  VDDNOTFOUND = 21; { VDD-Datei nicht gefunden }
  ILLEGALFCCALL = 22; { Funktions-Aufruf nicht bekannt }
  DRVLOADERROR = 23; { Fehler beim Laden }
  DRVNOTEXIST = 24; { DRV-Datei nicht gefunden }
  SQLERROR = 25; { SQL nicht ausführbar }

  BASICLASTERROR = 25;

  USERERR = 240; { keine besondere Message }
  BASICSYSTEM = 241; { Ende durch "SYSTEM"-Statement }
  BASICEND = 242; { Ende durch "END"-Statement }

  NameLen = 32; { Max L„nge des Varibalen-Bezeichners }
  StringLen = 130;
  AliasLen = 20; { Jede Variable kann einen Alias-Bezeichner haben }
  GosubStackSize = 10;
  ObjectsPerLine = 35;
  LabelLen = 20;
  LabelAnz = 200;
  OIdOpenMakro = '[';
  OIdCloseMakro = ']';
  OIdQuote = '"';
  BasicErrorStrings: array [0 .. BASICLASTERROR] of AnsiString = (
    { } 'OK',
    { } 'zuviele Objekte pro Zeile',
    { } OIdCloseMakro + ' erwartet',
    { } OIdQuote + ' erwartet',
    { } 'Sprungmarke zu lang',
    { } 'Sprungmarke bereits vergeben',
    { } 'Zu viele Sprungmarke',
    { } 'Zu tiefe GOSUB-Verschachtelung oder Rekursion',
    { } 'RETURN ohne vorherigen GOSUB-Aufruf',
    { } 'Sprungmarke unbekannt',
    { } 'Anweisung unverständlich',
    { } 'Variable erwartet',
    { } 'Sprungmarke falsch formuliert',
    { } 'Abbruch durch Tastendruck',
    { } 'Bitte gültige Variable angeben',
    { } 'Division durch "0"',
    { } 'Variable ergibt keine Zahl',
    { } 'Bitte ®ENDE-BASIC¯ einfügen',
    { } 'PRN ohne NUL',
    { } 'NUL bereits eingeschaltet',
    { } 'AliasName ist zu lang',
    { } 'VDD-Datei nicht gefunden',
    { } 'Funktions-Aufruf nicht bekannt',
    { } 'Fehler beim Laden',
    { } 'DRV-Datei nicht gefunden',
    { } 'Fehler im SQL');

type
  p2s = ^AnsiString;
  p2r = ^double;
  StringRecTypeP = ^StringRecType;

  StringRecType = record
    name: string[NameLen];
    data: string[StringLen];
    alias: string[AliasLen];
    nxt: StringRecTypeP;
  end;

  GosubStackType = array [1 .. GosubStackSize] of word;

  ObjectType = record
    Oid: byte; { Objekt-Id }
    VarOp: string; { Objekt-Pointer }
    VarName: string[NameLen]; { Zusatzinformation für Variable }
  end;

  ObjectLineType = array [1 .. ObjectsPerLine] of ObjectType;

  LabelType = record
    LName: string[LabelLen];
    LineNo: word;
  end;

  LabelArrayType = array [1 .. LabelAnz] of LabelType;

  TObjectLine = object
    line: ObjectLineType;
    EOLPos: byte;
    ok: boolean;
    function full: boolean;
    function empty: boolean;
    procedure insert(id: byte; PosNo: byte);
    procedure delete(PosNo: byte);
    procedure clear;
    constructor init;
  end;

  SemantikProc = procedure(No: byte) of object;
  { No ist Position im der Object-Line }
  TResolveProc = function(const Request: String): String;

  TBasicProcessor = class(TStringList)
  private
    MyFileOpen: boolean; { Aus- EingabeFile ge”ffnet? }
    BasicFile: text;
    StringVars: StringRecTypeP;
    ObjectLine: ^TObjectLine;
    GosubStack: ^GosubStackType;
    GosubStackPoi: byte;
    LabelArray: ^LabelArrayType;
{$IFNDEF DOSBASE}
    eob: boolean;
{$ENDIF}
    { gesicherte "alte" Werte beim Drucken auf NUL }
    //_drucke: procedure(x: string);
    _pX, _pY: integer; { aktueller Text-Cursor im Druckcontext }

    BasicError: byte; { Fehlernummer }
    BasicLine: integer;
    BasicDebug: boolean;
    ExternalCall: procedure(x: string);

    function strtob(s: string): byte;
    function strtow(s: string): word;
    function rtos(r: double): string;
    procedure ClearGotoMarks;
    function CollectGotoMarks: boolean;
    procedure BasicClear;
    function SearchVarP(VarName: string): StringRecTypeP;
    procedure CreateVarP(var p: StringRecTypeP; VarName: string);
    procedure Err(No: byte; AddInfo: string);
    function FindLabel(x: string): integer;
    function gets(No: byte): string;
    function geti(No: byte): integer;
    procedure puts(x: string; No: byte);
    function Resolve(name: string): string;
    procedure ASCII2ObjectLine(var x: string);
    procedure PrintIt(x: string);
    procedure PrintItln(x: string);

    // Semantic-Procs
    procedure ProcPrintStringSemi(No: byte);
    procedure ProcPrintString(No: byte);
    procedure ProcPrint(No: byte);
    procedure ProcPrintPicture(No: byte);

    procedure ProcRem(No: byte);
    procedure ProcDelBraket(No: byte);
    procedure ProcStringConcat(No: byte); { s&s->s }
    procedure ProcLabel(No: byte);
    procedure ProcLen(No: byte); { len(s)->s }
    procedure ProcSQL(No: byte); { SQL(s)->s }
    procedure ProcChr(No: byte); { chr(s)->s }
    procedure ProcRound(No: byte); { round(s)->s }
    procedure ProcGoto(No: byte);
    procedure ProcGosub(No: byte);
    procedure ProcReturn(No: byte);
    procedure ProcCall(No: byte); { cs->e }
    procedure ProcFontp(No: byte); { cs->e }
    procedure ProcFontpp(No: byte); { cs->e }
    procedure ProcFontppp(No: byte); { cs->e }
    procedure ProcMove(No: byte); { cs->e }
    procedure ProcStrId(No: byte); { s=s -> s }
    procedure ProcStrGreater(No: byte); { s>s -> s }
    procedure ProcStrLess(No: byte); { s<s -> s }
    procedure ProcLetss(No: byte); { l s=s -> s }
    procedure ProcIf(No: byte);
    procedure ProcIfGosub(No: byte);
    procedure ProcMid(No: byte); { m(s,s,s) -> s }
    procedure ProcVal(No: byte); { v(s,s,s) -> s }
    procedure Procfill(No: byte); { f(s,s) -> s }
    procedure ProcPos(No: byte); { p(s,s) -> s }
    procedure ProcRechne(No: byte; var a, b: double);
    procedure ProcMul(No: byte); { s*s->s }
    procedure ProcDiv(No: byte); { s/s -> s }
    procedure ProcPlus(No: byte); { s+s -> s }
    procedure ProcMinus(No: byte);
    procedure ProcNot(No: byte);
    procedure ProcOr(No: byte); { s or s -> s }
    procedure ProcAnd(No: byte); { sas->s }
    procedure ProcTrue(No: byte); { TRUE -> s }
    procedure ProcFalse(No: byte); { FALSE -> s }
    procedure ProcNul(No: byte);
    procedure ProcPrn(No: byte);
    procedure ProcDebug(No: byte);
    procedure ProcInput(No: byte); { piks -> - }
    procedure ProcAlias(No: byte); { alias var=s }
    procedure ProcFINPUT(No: byte);
    procedure ProcFCLOSE(No: byte);
    procedure ProcFSORT(No: byte);
    procedure ProcSYSTEM(No: byte);
    procedure ProcEnd(No: byte);
    procedure ProcFOPEN(No: byte);
    procedure ProcFCReate(No: byte);
    procedure ProcFPrintStringSemi(No: byte);
    procedure ProcFPrintString(No: byte);
    procedure ProcFPrintLN(No: byte);
    procedure ProcDevice(No: byte);
    procedure ProcDeviceForm(No: byte);
    procedure ProcDevicePagebreak(No: byte);

    procedure ExecuteObjectLine;
    function BasicMsg: string;
    procedure EnsurePrinting;

  public
    ValError: boolean;
    ValChanged: boolean;
    FileName: string;
    PicturePath: string;
    // Überschreiben des Druckers, auf den gedruckt werden soll!
    DeviceOverride: string;
    BasicErrors: TStringList;
    BasicOutPut: TStringList;
    ResolveData: TResolveProc;
    ResolveSQL: TResolveProc;
    ShouldRUN: boolean;

    constructor create; virtual;
    destructor Destroy; override;

    function ReadVal(VarName: string): string;
    function ReadVali(VarName: string): integer;

    procedure WriteVal(VarName: string; NewVal: string);

    function RUN(StartLineNumber: integer = 0): boolean;
    procedure CLS;

  end;

implementation

uses
  winspool, windows, math,
  graphics, Printers, SysUtils,
  System.UITypes,
{$IFNDEF CONSOLE}
  wanfix,
{$ENDIF}
  anfix;

const
  OpenMakroId = 011;
  CloseMakroId = 012;

  NestedIncludes = 4;
  LongestIdLen = 7;

  OIdConcat = '&';
  ConcatId = 001;
  OIdPlus = '+';
  PlusId = 002;
  OIdMinus = '-';
  MinusId = 003;
  OIdMal = '*';
  MalId = 004;
  OIdDiv = '/';
  DivId = 005;
  OIdEq = '=';
  EqId = 006;
  OIdBraOpen = '(';
  BraOpenId = 008;
  OIdBraClose = ')';
  BraCloseId = 009;
  QuoteId = 010;
  OIdSemi = ';';
  SemiId = 013;
  OIdKomma = ',';
  KommaId = 014;
  OIdGreater = '>';
  GreaterId = 034;
  OIdLess = '<';
  LessId = 035;

  OIdIf = 'IF';
  IfId = 014;
  OIdOr = 'OR';
  OrId = 015;

  OIdLet = 'LET';
  LetId = 016;
  OIdRem = 'REM';
  RemId = 017;
  OIdAnd = 'AND';
  AndId = 018;
  OIdNot = 'NOT';
  NotId = 019;
  Oidlen = 'LEN';
  lenId = 020;
  Oidmid = 'MID';
  midId = 021;
  Oidval = 'VAL';
  valId = 022;
  OidPos = 'POS';
  posId = 023;
  OidNul = 'NUL';
  NulId = 036;
  OidPrn = 'PRN';
  PrnId = 037;
  OidSQL = 'SQL';
  SQLId = 057;

  OIdThen = 'THEN';
  ThenId = 024;
  Oidfill = 'FILL';
  fillId = 025;
  OIdGoto = 'GOTO';
  GotoId = 026;
  OIdCall = 'CALL';
  CallId = 041;
  OIdFont = 'FONT';
  FontId = 054;
  OIdMove = 'MOVE';
  MoveId = 055;
  OIdPageBreak = 'PAGE';
  PageBreakId = 058;

  OIdPrint = 'PRINT';
  PrintId = 027;
  OIdGosub = 'GOSUB';
  GosubId = 028;
  OIdInput = 'INPUT';
  InputId = 038;
  OIdAlias = 'ALIAS';
  AliasId = 039;
  OIdRound = 'ROUND';
  RoundId = 040;
  OIdDebug = 'DEBUG';
  DebugId = 042;
  OIdAbort = 'ABORT';
  AbortId = 059;

  OIdReturn = 'RETURN';
  ReturnId = 029;
  OIdDevice = 'DEVICE';
  DeviceId = 056;

  OIdFCREATE = 'FCREATE';
  FCREATEId = 043;

  OIdFOPEN = 'FOPEN';
  FOPENId = 044;
  OIdFPRINT = 'FPRINT';
  FPRINTId = 045;
  OIdFINPUT = 'FINPUT';
  FINPUTId = 046;
  OIdFCLOSE = 'FCLOSE';
  FCLOSEId = 047;
  OIdFSORT = 'FSORT';
  FSORTId = 048;
  OIdSYSTEM = 'SYSTEM';
  SYSTEMId = 049;
  OIdEND = 'END';
  ENDId = 050;
  OIdTrue = 'TRUE';
  TrueId = 051;
  OIdFalse = 'FALSE';
  FalseId = 052;
  OIdChr = 'CHR';
  chrID = 053;

  sId = 030;
  EOLId = 031;

  DruckStueckZaehler: integer = 0;

  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    Type Casting Utils
    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

function TBasicProcessor.strtob(s: string): byte;
var
  r: double;
begin
  r := StrToDouble(s);
  strtob := round(r);
end;

function TBasicProcessor.strtow(s: string): word;
var
  r: double;
begin
  r := StrToDouble(s);
  strtow := round(r);
end;

function TBasicProcessor.rtos(r: double): string;
var
  s: string;
begin
  str(r, s);
  rtos := s;
end;

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Utils fr Heap-Management
  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TBasicProcessor.ClearGotoMarks;
var
  OwnPoi: byte;
begin
  for OwnPoi := 1 to LabelAnz do
    LabelArray^[OwnPoi].LName := '';
end;

procedure TBasicProcessor.BasicClear;
var
  p: StringRecTypeP;
begin
  GosubStackPoi := 0;
  p := StringVars; { Start der Variablen-Liste }
  while (p <> nil) do
  begin
    StringVars := p;
    p := StringVars^.nxt;
    dispose(StringVars);
  end;
  StringVars := nil;
end;

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  allgemeiner Variablen-Zugriff
  ReadVal und WriteVal sind allgemein zug„nglich

  User-Level
  ReadVal    : lieát den Wert einer BASIC-Varibale aus
  WriteVal   : schreibt einen neuen Wert einer BASIC-Variable

  Low-Level
  CreateVarP : erzeugt eine neu BASIC-Variable im Speicher
  SerachVarP : sucht mit Hilfe eines Variablen-Names die Location im
  Speicher.
  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

function TBasicProcessor.SearchVarP(VarName: string): StringRecTypeP;
var
  p: StringRecTypeP;
begin
  p := StringVars;
  while (p <> nil) do
  begin
    if (p^.name = VarName) then
      break;
    p := p^.nxt;
  end;
  result := p;
end;

procedure TBasicProcessor.CreateVarP(var p: StringRecTypeP; VarName: string);
begin
  new(p);
  p^.name := VarName;
  p^.data := '';
  p^.alias := '';
  p^.nxt := StringVars;
  StringVars := p;
end;

function TBasicProcessor.ReadVal(VarName: string): string;
var
  p: StringRecTypeP;
begin
  p := SearchVarP(VarName);
  if p = nil then
    ReadVal := ''
  else
    ReadVal := p^.data;
end;

function TBasicProcessor.ReadVali(VarName: string): integer;
var
  s: string;
begin
  s := ReadVal(VarName);
  result := round(strtodoubledef(s, 0));
end;

procedure TBasicProcessor.WriteVal(VarName: string; NewVal: string);
var
  p: StringRecTypeP;
begin
  p := StringVars;
  while (p <> nil) do
  begin
    if (p^.name = VarName) then
    begin
      if p^.data <> NewVal then
      begin
        p^.data := NewVal;
        ValChanged := true;
      end;
      exit;
    end;
    p := p^.nxt;
  end;
  { neue anlegen }
  CreateVarP(p, VarName);
  p^.data := NewVal;
end;

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Allgemeine BASIC Utils
  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TBasicProcessor.Err(No: byte; AddInfo: string);
begin
  if (BasicError = 0) then
  begin
    BasicError := No;
    if (No<>BASICEND) then
      BasicErrors.add(
        { Line-Number } 'Zeile ' + inttostr(succ(BasicLine)) + ':' + ';' +
        { Error } BasicMsg + ';' +
        { Hint } AddInfo + ';' +
        { Source } strings[BasicLine]);
  end;
end;

function TBasicProcessor.FindLabel(x: string): integer;
var
  OwnPoi: word;
begin
  for OwnPoi := 1 to LabelAnz do
  begin
    if LabelArray^[OwnPoi].LName = x then
    begin
      {
        message('',x+btostr(LabelArray^[OwnPoi].lineno,0));
      }
      FindLabel := LabelArray^[OwnPoi].LineNo;
      exit;
    end;
  end;
  FindLabel := -1;
end;

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  gets, puts
  lesen und schreiben von Strings, Variable jedoch auch konstante Strings
  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

function TBasicProcessor.gets(No: byte): string;
begin
  with ObjectLine^.line[No] do
    if (VarName <> '') then
    begin
      { Ist eine String-Variable }
      { message('var','-->'+VarName); }
      result := ReadVal(VarName);
    end
    else
    begin
      { Normaler String inerhalb der Auswertung }
      result := VarOp;
    end;
end;

function TBasicProcessor.geti(No: byte): integer;
var
  s: string;
begin
  s := gets(No);
  result := round(strtodoubledef(s, 0));
end;

procedure TBasicProcessor.puts(x: string; No: byte);
begin
  with ObjectLine^.line[No] do
    if (VarName <> '') then
    begin
      { Ist eine String-Variable }
      WriteVal(VarName, x);
    end
    else
    begin
      { Normaler String inerhalb der Auswertung }
      VarOp := x;
    end;
end;

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Utils zum Handeln der Objekt-Line
  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

function TObjectLine.full: boolean;
begin
  full := (EOLPos = ObjectsPerLine);
end;

function TObjectLine.empty: boolean;
begin
  empty := (EOLPos = 0);
end;

procedure TObjectLine.insert(id: byte; PosNo: byte);
var
  OwnPoi: byte;
begin
  ok := not(full) and (PosNo <= EOLPos);
  if ok then
  begin
    if PosNo = 0 then
      PosNo := 1;
    for OwnPoi := EOLPos downto PosNo do
      line[succ(OwnPoi)] := line[OwnPoi];
    inc(EOLPos);
    with line[PosNo] do
    begin
      Oid := id;
      VarName := '';
      VarOp := '';
    end;
  end;
end;

procedure TObjectLine.delete(PosNo: byte);
var
  OwnPoi: byte;
begin
  ok := not(empty) and (PosNo > 0) and (PosNo <= EOLPos);
  if ok then
  begin
    dec(EOLPos);
    for OwnPoi := PosNo to EOLPos do
      line[OwnPoi] := line[succ(OwnPoi)];
  end;
end;

procedure TObjectLine.clear;
begin
  if not(empty) then
  begin
    EOLPos := 0;
  end;
end;

constructor TObjectLine.init;
begin
  ok := true;
  EOLPos := 0;
end;

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Normaler Text wird in die Objectline umgewandelt.
  llr(1)-Eigenschaft notwendig.

  PRINT
  ³  ³
  FirstPos
  ³
  StrPoi -->  immer nach rechts bis erkannt
  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TBasicProcessor.ASCII2ObjectLine(var x: string);
var
  len,               { Länge von x }
  unknownpos,        { Start der unkown Ids }
  StrPoi,            { Aktuelle Scan Position }
  FirstPos: Integer; { Startposition im }

  ObjZae: byte; { Anz der erkannten Objekte }
  id: byte; { Id des erkannten Objektes }
  eop: boolean; { End of Parsing }

label error;
label cut;

  function GetIdof: byte;
  var
    len: byte;
    s: string[LongestIdLen];
  begin
    len := succ(StrPoi - FirstPos);
    s := copy(x, FirstPos, len);
    case len of
      1:
        begin
          if s = OIdEq then
          begin
            GetIdof := EqId;
            exit;
          end;
          if s = OIdConcat then
          begin
            GetIdof := ConcatId;
            exit;
          end;
          if s = OIdPlus then
          begin
            GetIdof := PlusId;
            exit;
          end;
          if s = OIdMinus then
          begin
            GetIdof := MinusId;
            exit;
          end;
          if s = OIdMal then
          begin
            GetIdof := MalId;
            exit;
          end;
          if s = OIdDiv then
          begin
            GetIdof := DivId;
            exit;
          end;
          if s = OIdBraOpen then
          begin
            GetIdof := BraOpenId;
            exit;
          end;
          if s = OIdBraClose then
          begin
            GetIdof := BraCloseId;
            exit;
          end;
          if s = OIdSemi then
          begin
            GetIdof := SemiId;
            exit;
          end;
          if s = OIdKomma then
          begin
            GetIdof := KommaId;
            exit;
          end;
          if s = OIdGreater then
          begin
            GetIdof := GreaterId;
            exit;
          end;
          if s = OIdLess then
          begin
            GetIdof := LessId;
            exit;
          end;
        end;
      2:
        begin
          if s = OIdIf then
          begin
            GetIdof := IfId;
            exit;
          end;
          if s = OIdOr then
          begin
            GetIdof := OrId;
            exit;
          end;
        end;
      3:
        begin
          if s = OIdLet then
          begin
            GetIdof := LetId;
            exit;
          end;
          if s = OIdRem then
          begin
            GetIdof := RemId;
            exit;
          end;
          if s = OIdAnd then
          begin
            GetIdof := AndId;
            exit;
          end;
          if s = OIdNot then
          begin
            GetIdof := NotId;
            exit;
          end;
          if s = Oidlen then
          begin
            GetIdof := lenId;
            exit;
          end;
          if s = Oidmid then
          begin
            GetIdof := midId;
            exit;
          end;
          if s = Oidval then
          begin
            GetIdof := valId;
            exit;
          end;
          if s = OidPos then
          begin
            GetIdof := posId;
            exit;
          end;
          if s = OidNul then
          begin
            GetIdof := NulId;
            exit;
          end;
          if s = OidPrn then
          begin
            GetIdof := PrnId;
            exit;
          end;
          if s = OIdEND then
          begin
            GetIdof := ENDId;
            exit;
          end;
          if s = OIdChr then
          begin
            GetIdof := chrID;
            exit;
          end;
          if s = OidSQL then
          begin
            GetIdof := SQLId;
            exit;
          end;
        end;
      4:
        begin
          if s = OIdThen then
          begin
            GetIdof := ThenId;
            exit;
          end;
          if s = Oidfill then
          begin
            GetIdof := fillId;
            exit;
          end;
          if s = OIdGoto then
          begin
            GetIdof := GotoId;
            exit;
          end;
          if s = OIdCall then
          begin
            GetIdof := CallId;
            exit;
          end;
          if s = OIdTrue then
          begin
            GetIdof := TrueId;
            exit;
          end;
          if s = OIdFont then
          begin
            GetIdof := FontId;
            exit;
          end;
          if s = OIdMove then
          begin
            GetIdof := MoveId;
            exit;
          end;
          if s = OIdPageBreak then
          begin
            GetIdof := PageBreakId;
            exit;
          end;
        end;
      5:
        begin
          if s = OIdPrint then
          begin
            GetIdof := PrintId;
            exit;
          end;
          if s = OIdGosub then
          begin
            GetIdof := GosubId;
            exit;
          end;
          if s = OIdInput then
          begin
            GetIdof := InputId;
            exit;
          end;
          if s = OIdAlias then
          begin
            GetIdof := AliasId;
            exit;
          end;
          if s = OIdRound then
          begin
            GetIdof := RoundId;
            exit;
          end;
          if s = OIdDebug then
          begin
            GetIdof := DebugId;
            exit;
          end;
          if s = OIdFOPEN then
          begin
            GetIdof := FOPENId;
            exit;
          end;
          if s = OIdFSORT then
          begin
            GetIdof := FSORTId;
            exit;
          end;
          if s = OIdFalse then
          begin
            GetIdof := FalseId;
            exit;
          end;
          if s = OIdAbort then
          begin
            GetIdof := AbortId;
            exit;
          end;

        end;
      6:
        begin
          if s = OIdReturn then
          begin
            GetIdof := ReturnId;
            exit;
          end;
          if s = OIdFPRINT then
          begin
            GetIdof := FPRINTId;
            exit;
          end;
          if s = OIdFINPUT then
          begin
            GetIdof := FINPUTId;
            exit;
          end;
          if s = OIdFCLOSE then
          begin
            GetIdof := FCLOSEId;
            exit;
          end;
          if s = OIdSYSTEM then
          begin
            GetIdof := SYSTEMId;
            exit;
          end;
          if s = OIdDevice then
          begin
            GetIdof := DeviceId;
            exit;
          end;
        end;
      7:
        begin
          if s = OIdFCREATE then
          begin
            GetIdof := FCREATEId;
            exit;
          end;
        end;
    end;
    GetIdof := 0;
  end;

  procedure VarEintrag;
  var
    MyVar: string[NameLen]; { Zwischenspeicher fr Variable-Name }
  begin
    MyVar := noblank(copy(x, unknownpos, FirstPos - unknownpos));
    { String-Variable }
    ObjectLine^.insert(sId, ObjZae);
    ObjectLine^.line[ObjZae].VarName := MyVar;
    inc(ObjZae);
  end;

begin
  ObjectLine^.clear;
  FirstPos := 1;
  StrPoi := 0;
  ObjZae := 1;
  len := length(x);
  eop := false;

  ObjectLine^.insert(EOLId, ObjectLine^.EOLPos);

  repeat { für jeweils einen Token }

    { 1. Blanks überlesen }
    repeat
      inc(StrPoi);
      if (StrPoi > len) then
      begin
        eop := true;
        goto cut;
      end;
    until (x[StrPoi] <> ' ');

    FirstPos := StrPoi;

    { 2. Stringkonstanten einlesen }
    if (x[StrPoi] = OIdQuote) then
    begin
      inc(StrPoi);
      while (StrPoi < len) and (x[StrPoi] <> OIdQuote) do
        inc(StrPoi);
      if (x[StrPoi] <> OIdQuote) then
        Err(NOQUOTECLOSE, '')
      else
      begin
        ObjectLine^.insert(sId, ObjZae);
        puts(copy(x, succ(FirstPos), pred(StrPoi - FirstPos)), ObjZae);
        inc(ObjZae);
      end;
      goto cut;
    end;

    { 3. Makrokonstanten einlesen }
    if (x[StrPoi] = OIdOpenMakro) then
    begin
      inc(StrPoi);
      while (StrPoi < len) and (x[StrPoi] <> OIdCloseMakro) do
        inc(StrPoi);
      if (x[StrPoi] <> OIdCloseMakro) then
        Err(NOMACROCLOSE, '')
      else
      begin
        ObjectLine^.insert(sId, ObjZae);
        puts(Resolve(copy(x, succ(FirstPos), pred(StrPoi - FirstPos))), ObjZae);
        inc(ObjZae);
      end;
      goto cut;
    end;

    { 4. Einen id einlesen }

    unknownpos := FirstPos;
    repeat
      id := GetIdof;

      if id > 0 then
      begin

        if (unknownpos <> FirstPos) then
        begin
          { M”glicher Weise eine variable voranstellen }
          VarEintrag;
        end;

        ObjectLine^.insert(id, ObjZae);
        inc(ObjZae);
        if id = RemId then
          eop := true;
        goto cut;
      end;

      if (succ(StrPoi - FirstPos) = LongestIdLen) or (StrPoi = len) then
      begin
        inc(FirstPos);
        StrPoi := FirstPos;
      end
      else
        inc(StrPoi);

      if (FirstPos > len) then
      begin
        { Variable am Ende? }
        if (FirstPos - unknownpos >= 1) then
          VarEintrag;
        goto cut;
      end;

    until eternity;

  cut:
  until (eop) or (BasicError > 0);
error:
end;

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Semantik - Routinen:
  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TBasicProcessor.PrintIt(x: string);
begin
  if (BasicOutPut.count = 0) then
    BasicOutPut.add('');
  BasicOutPut[pred(BasicOutPut.count)] := BasicOutPut[pred(BasicOutPut.count)] + x;
  if (DeviceOverride <> 'null') then
  begin
    EnsurePrinting;
    with printer.canvas do
    begin
      TextOut(
        { } strtointdef(ReadVal('X'), 0) + _pX,
        { } strtointdef(ReadVal('Y'), 0) + _pY,
        { } x);
      inc(_pX, TextWidth(x));
    end;
  end;
end;

procedure TBasicProcessor.PrintItln(x: string);
begin
  PrintIt(x);
  BasicOutPut.add('');
  if (DeviceOverride <> 'null') then
  begin
    _pX := 0;
    inc(_pY, abs(printer.canvas.font.height) + strtointdef(ReadVal('LY'), 0));
  end;
end;

procedure TBasicProcessor.ProcPrintPicture(No: byte);
var
  FName: string;
  BMP: TBitmap;
  x, y: integer;
begin
{$IFNDEF CONSOLE}
  {$ifndef FPC}
  FName := PicturePath + gets(No + 5);
  x := ReadVali('X') + geti(No + 1);
  y := ReadVali('Y') + geti(No + 3);
  if FileExists(FName) then
  begin
    EnsurePrinting;
    try
      BMP := LoadGraphicsFile(FName);
      // printer.Canvas.Draw(x,y,BMP);
      DrawImage(printer.canvas, Rect(x, y, x + BMP.width, y + BMP.height), BMP);
      BMP.free;
    except
      BasicErrors.add('interner Fehler beim Bild lade/druck Vorgang!');
    end;
  end
  else
  begin
    BasicErrors.add('Datei "' + FName + '" nicht gefunden!');
  end;
  {$else}
  // imp pend
  {$endif}
{$ELSE}
  BasicErrors.add('Diese Konsolen-Anwendung kann keine Bilder drucken!');
{$ENDIF}
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcPrintStringSemi(No: byte);
begin
  PrintIt(gets(succ(No)));
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcPrintString(No: byte);
begin
  PrintItln(gets(succ(No)));
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcPrint(No: byte);
begin
  PrintItln('');
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcRem(No: byte);
begin
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcDelBraket(No: byte);
begin
  with ObjectLine^ do
  begin
    delete(No);
    delete(succ(No));
  end;
end;

procedure TBasicProcessor.ProcStringConcat(No: byte); { s&s->s }
begin
  with ObjectLine^ do
  begin
    delete(succ(No)); { ss -> s }
    insert(sId, No); { rss -> r }
    puts(gets(succ(No)) + gets(No + 2), No);
    delete(succ(No));
    delete(succ(No));
  end;
end;

procedure TBasicProcessor.ProcLabel(No: byte);
begin
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcLen(No: byte); { len(s)->s }
var
  ThatLen: byte;
begin
  with ObjectLine^ do
  begin
    delete(No);
    delete(No); { s) }
    ThatLen := length(gets(No));
    delete(No);
    delete(No);
    insert(sId, No);
    puts(btostr(ThatLen, 0), No);
  end;
end;

procedure TBasicProcessor.ProcSQL(No: byte); { SQL(s)->s }
var
  ThatSQL: string;
begin
  with ObjectLine^ do
  begin
    delete(No);
    delete(No); { s) }
    ThatSQL := gets(No);
    delete(No);
    delete(No);
    insert(sId, No);
    if assigned(ResolveSQL) then
    begin
     try
      puts(ResolveSQL(ThatSQL), No);
     except
      on E: Exception do
      begin
        Err(SQLERROR, E.Message);
      end;
     end;
    end;
  end;
end;

procedure TBasicProcessor.ProcChr(No: byte); { chr(s)->s }
var
  ThatChar: byte;
begin
  with ObjectLine^ do
  begin
    delete(No);
    delete(No); { s) }
    ThatChar := strtob(gets(No));
    delete(No);
    delete(No);
    insert(sId, No);
    puts(btostr(ThatChar, 0), No);
  end;
end;

procedure TBasicProcessor.ProcRound(No: byte); { round(s)->s }
var
  r: double;
begin
  with ObjectLine^ do
  begin
    delete(No);
    delete(No); { s) }
    r := StrToDouble(gets(No),ValError);
    if ValError then
      Err(NOTANUMBER, '')
    else
    begin
      delete(No);
      delete(No);
      insert(sId, No);
      puts(rtos(round(r + 0.0001)), No);
    end;
  end;
end;

procedure TBasicProcessor.ProcGoto(No: byte);
var
  l: integer;
begin
  l := FindLabel(gets(succ(No)));
  if (l = -1) then
    Err(UNKOWNLABEL, gets(succ(No)))
  else
    BasicLine := l;
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcGosub(No: byte);
begin
  if GosubStackPoi = GosubStackSize then
    Err(GOSUBSTACKOVERFLOW, '')
  else
  begin
    inc(GosubStackPoi);
    GosubStack^[GosubStackPoi] := BasicLine;
    ProcGoto(No);
  end;
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcReturn(No: byte);
begin
  if (GosubStackPoi = 0) then
    Err(GOSUBSTACKUNDERFLOW, '')
  else
  begin
    BasicLine := GosubStack^[GosubStackPoi];
    dec(GosubStackPoi);
  end;
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcCall(No: byte); { cs->e }
begin
  ExternalCall(gets(No + 1));
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcStrId(No: byte); { s=s -> s }
var
  a, b: double;
  x, y: string;
  AlphaIden: boolean;
  NumIden: boolean;
begin
  with ObjectLine^ do
  begin
    delete(No + 1); { ss -> s }
    insert(sId, No); { rss -> s }
    x := gets(No + 1);
    y := gets(No + 2);
    AlphaIden := (x = y);
    if not(AlphaIden) then
    begin
      NumIden := true;
      a := StrToDouble(x,ValError);
      if ValError then
        NumIden := false
      else
      begin
        b := StrToDouble(y,ValError);
        if ValError then
          NumIden := false
        else
        begin
          NumIden := (a = b);
        end;
      end;
      puts(booltostr(NumIden), No);
    end else
    begin
     puts(booltostr(true), No);
    end;
    delete(No + 1);
    delete(No + 1);
  end;
end;

procedure TBasicProcessor.ProcStrGreater(No: byte); { s>s -> s }
var
  a, b: double;
  AlphaIden: boolean;
  NumIden: boolean;
begin
  with ObjectLine^ do
  begin
    delete(No + 1); { ss -> s }
    insert(sId, No); { rss -> s }
    AlphaIden := gets(No + 1) > gets(No + 2);
    NumIden := true;
    a := StrToDouble(gets(No + 1),ValError);
    if ValError then
      NumIden := false
    else
    begin
      b := StrToDouble(gets(No + 2),ValError);
      if ValError then
        NumIden := false
      else
      begin
        NumIden := (a > b);
      end;
    end;
    puts(booltostr(NumIden { or AlphaIden } ), No);
    delete(No + 1);
    delete(No + 1);
  end;
end;

procedure TBasicProcessor.ProcStrLess(No: byte); { s<s -> s }
var
  a, b: double;
  AlphaIden: boolean;
  NumIden: boolean;
begin
  with ObjectLine^ do
  begin
    delete(No + 1); { ss -> s }
    insert(sId, No); { rss -> s }
    AlphaIden := gets(No + 1) < gets(No + 2);
    NumIden := true;
    a := StrToDouble(gets(No + 1),ValError);
    if ValError then
      NumIden := false
    else
    begin
      b := StrToDouble(gets(No + 2),ValError);
      if ValError then
        NumIden := false
      else
      begin
        NumIden := (a < b);
      end;
    end;
    puts(booltostr(NumIden { or AlphaIden } ), No);
    delete(No + 1);
    delete(No + 1);
  end;
end;

procedure TBasicProcessor.ProcLetss(No: byte); { l s=s -> s }
begin
  with ObjectLine^.line[succ(No)] do
    if VarName = '' then
      Err(VAREXPECTED, '')
    else
      WriteVal(VarName, gets(No + 3));
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcIf(No: byte);
begin
  with ObjectLine^ do
    if gets(succ(No)) = booltostr(true) then
    begin
      delete(1);
      delete(1);
      delete(1);
      insert(GotoId, 1);
    end
    else
    begin
      clear;
    end;
end;

procedure TBasicProcessor.ProcIfGosub(No: byte);
begin
  with ObjectLine^ do
    if gets(succ(No)) = booltostr(true) then
    begin
      delete(1);
      delete(1);
      delete(1);
      delete(1);
      insert(GosubId, 1);
    end
    else
    begin
      clear;
    end;
end;

procedure TBasicProcessor.ProcMid(No: byte); { m(s,s,s) -> s }
begin
  with ObjectLine^ do
  begin
    delete(No);
    delete(No);
    delete(succ(No)); { ss,s) }
    delete(No + 2); { sss) }
    delete(No + 3); { sss }
    insert(sId, No); { rsss -> r }
    puts(copy(gets(succ(No)), strtob(gets(No + 2)), strtob(gets(No + 3))), No);
    delete(succ(No));
    delete(succ(No));
    delete(succ(No));
  end;
end;

procedure TBasicProcessor.ProcVal(No: byte); { v(s,s,s) -> s }
var
  v, n: byte;
  r: double;
begin
  with ObjectLine^ do
  begin
    delete(No);
    delete(No);
    delete(succ(No));
    delete(No + 2);
    delete(No + 3);
    insert(sId, No); { rsss -> r }
    v := strtob(gets(No + 2));
    n := strtob(gets(No + 3));
    r := StrToDouble(gets(succ(No)));
    if n > 0 then
    begin
      puts(rtostr(r, v, n), No)
    end
    else
      puts(ltostr(trunc(r), v), No);
    delete(succ(No));
    delete(succ(No));
    delete(succ(No));
  end;
end;

procedure TBasicProcessor.Procfill(No: byte); { f(s,s) -> s }
begin
  with ObjectLine^ do
  begin
    delete(No);
    delete(No);
    delete(succ(No));
    delete(No + 2); { ss }
    insert(sId, No); { rss }
    puts(anfix.fill(gets(succ(No)), strtob(gets(No + 2))), No);
    delete(succ(No));
    delete(succ(No)); { r }
  end;
end;

procedure TBasicProcessor.ProcPos(No: byte); { p(s,s) -> s }
begin
  with ObjectLine^ do
  begin
    delete(No);
    delete(No);
    delete(succ(No)); { ss) }
    delete(No + 2);
    insert(sId, No); { rss -> r }
    puts(btostr(pos(gets(succ(No)), gets(No + 2)), 0), No);
    delete(succ(No));
    delete(succ(No));
  end;
end;

procedure TBasicProcessor.ProcRechne(No: byte; var a, b: double);
var
  astr, bstr: string[64];
begin
  with ObjectLine^ do
  begin
    delete(succ(No));
    insert(sId, No); { rss -> r }

    astr := cutblank(gets(succ(No)));
    if (astr <> '') then
    begin
      a := StrToDouble(astr,ValError);
      if ValError then
        Err(NOTANUMBER, astr)
    end
    else
    begin
      a := 0.0;
    end;

    bstr := cutblank(gets(No + 2));
    if (bstr <> '') then
    begin
      b := StrToDouble(bstr,ValError);
      if ValError then
        Err(NOTANUMBER, bstr)
    end
    else
    begin
      b := 0.0;
    end;

    delete(succ(No));
    delete(succ(No));
  end;
end;

procedure TBasicProcessor.ProcMul(No: byte); { s*s->s }
var
  x, y: double;
begin
  ProcRechne(No, x, y);
  puts(rtos(x * y), No);
end;

procedure TBasicProcessor.ProcDiv(No: byte); { s/s -> s }
var
  x, y: double;
begin
  ProcRechne(No, x, y);
  if y = 0.0 then
    Err(DIVISIONBYZERRO, '')
  else
    puts(rtos(x / y), No);
end;

procedure TBasicProcessor.ProcPlus(No: byte); { s+s -> s }
var
  x, y: double;
begin
  ProcRechne(No, x, y);
  puts(rtos(x + y), No);
end;

procedure TBasicProcessor.ProcMinus(No: byte);
var
  x, y: double;
begin
  ProcRechne(No, x, y);
  puts(rtos(x - y), No);
end;

procedure TBasicProcessor.ProcNot(No: byte);
begin
  with ObjectLine^ do
  begin
    insert(sId, No); { rns -> r }
    puts(booltostr(not(gets(No + 2) = booltostr(true))), No);
    delete(succ(No));
    delete(succ(No));
  end;
end;

procedure TBasicProcessor.ProcOr(No: byte); { s or s -> s }
begin
  with ObjectLine^ do
  begin
    delete(succ(No));
    insert(sId, No); { rss -> r }
    puts(booltostr((gets(succ(No)) = booltostr(true)) or (gets(No + 2) = booltostr(true))), No);
    delete(succ(No));
    delete(succ(No));
  end;
end;

procedure TBasicProcessor.ProcAnd(No: byte); { sas->s }
begin
  with ObjectLine^ do
  begin
    delete(succ(No));
    insert(sId, No); { rss -> r }
    puts(booltostr((gets(succ(No)) = booltostr(true)) and (gets(No + 2) = booltostr(true))), No);
    delete(succ(No));
    delete(succ(No));
  end;
end;

procedure TBasicProcessor.ProcTrue(No: byte); { TRUE -> s }
begin
  with ObjectLine^ do
  begin
    delete(No);
    insert(sId, No);
    puts(booltostr(true), No);
  end;
end;

procedure TBasicProcessor.ProcFalse(No: byte); { FALSE -> s }
begin
  with ObjectLine^ do
  begin
    delete(No);
    insert(sId, No);
    puts(booltostr(false), No);
  end;
end;

procedure TBasicProcessor.ProcNul(No: byte);
begin
  // nicht mehr notwendig
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcPrn(No: byte);
begin
  // nicht mehr notwendig
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcDebug(No: byte);
begin
  BasicDebug := true;
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcInput(No: byte); { piks -> - }
var
  InpStr: string;
  VarName: string[NameLen];
begin
  VarName := ObjectLine^.line[No + 3].VarName;
  if VarName = '' then
    Err(VAREXPECTED, '')
  else
  begin
{$IFNDEF CONSOLE}
{$IFNDEF win32}
{$ifndef FPC}
    InpLen := length(gets(succ(No))) + 1;
    repeat
      dec(InpLen);
      Slen := length(gets(succ(No))) + InpLen + 3;
    until (Slen <= ScreenX - 2) or (InpLen = 1);

    if not(ANSI) then
    begin
      smart_window(succ((ScreenX div 2) - (Slen div 2)), 12, Slen, 2, 'BASIC-Eingabe');
      Fkeys_cls;
      ClearKeys;
      Fkeys_let(8, 'Ende');
      ExitKeys^[1] := KF8;
      ExitKeys^[2] := KESC;

      colour(col_normal);
      trenner(1);
      writexy(1, 2, gets(succ(No)) + ' : ');
      InpStr := gets(No + 3);
      DelFirst := true;
      inputxy(succ(Slen - InpLen), 2, InpLen, InpStr);
      wodniw;
    end
    else
    begin
      InpStr := OIdOpenMakro + 'BASIC-INPUT' + OIdCloseMakro;
    end;
{$ENDIF}
{$ENDIF}
{$ENDIF}
    WriteVal(VarName, cutrblank(InpStr));
  end;
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcAlias(No: byte); { alias var=s }
var
  VarName: string[NameLen];
  p: StringRecTypeP;
begin
  VarName := ObjectLine^.line[succ(No)].VarName;
  if VarName = '' then
    Err(VAREXPECTED, '')
  else
  begin
    if length(gets(No + 3)) > AliasLen then
      Err(ALIASTOLONG, '')
    else
    begin
      p := SearchVarP(VarName);
      if p = nil then
        CreateVarP(p, VarName);
      p^.alias := gets(No + 3);
    end;
  end;
  ObjectLine^.clear;
end;

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  File IO fr D-Basic
  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  MyFileOpen    : boolean          Aus- EingabeFile ge”ffnet?
  BasicFile     : text             Ein- Ausgabe-Datei
  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TBasicProcessor.ProcFINPUT(No: byte);
var
  InpStr: string;
begin
  if MyFileOpen then
  begin
    with ObjectLine^.line[succ(No)] do
      if VarName = '' then
        Err(VAREXPECTED, '')
      else
      begin
        if not(eof(BasicFile)) then
        begin
          readln(BasicFile, InpStr);
          WriteVal(VarName, InpStr);
          eob := false;
        end
        else
        begin
          eob := true;
        end;
      end;
  end
  else
  begin
    eob := true;
  end;
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcFCLOSE(No: byte);
begin
  if MyFileOpen then
  begin
    CloseFile(BasicFile);
    eob := false;
    MyFileOpen := false;
  end
  else
  begin
    eob := true;
  end;
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcFSORT(No: byte);
begin
  // imp pend
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcSYSTEM(No: byte);
begin
  // imp pend
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcEnd(No: byte);
begin
  Err(BASICEND, '');
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcFOPEN(No: byte);
begin
  if MyFileOpen then
  begin
    eob := true;
  end
  else
  begin
    assignFile(BasicFile, gets(succ(No)));
    reset(BasicFile);
    eob := false;
    MyFileOpen := true;
  end;
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcFCReate(No: byte);
begin
  if MyFileOpen then
  begin
    eob := true;
  end
  else
  begin
    assignFile(BasicFile, gets(succ(No)));
    rewrite(BasicFile);
    eob := false;
    MyFileOpen := true;
  end;
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcFPrintStringSemi(No: byte);
begin
  if MyFileOpen then
  begin
    write(BasicFile, gets(succ(No)));
    eob := false;
  end
  else
  begin
    eob := true;
  end;
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcFPrintString(No: byte);
begin
  if MyFileOpen then
  begin
    writeln(BasicFile, gets(succ(No)));
    eob := false;
  end
  else
  begin
    eob := true;
  end;
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcFPrintLN(No: byte);
begin
  if MyFileOpen then
  begin
    writeln(BasicFile);
    eob := false;
  end
  else
  begin
    eob := true;
  end;
  ObjectLine^.clear;
end;

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  Eine Zeile durchlaufen, und globale Semantik-Aktionen durchfhren.
  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TBasicProcessor.ExecuteObjectLine;
var
  eoe: boolean; { End of Execute }
label cut;

  function InSideLine(ostr: string): byte;
  var
    OwnPoi: byte; { Z„hler fr die ObjectLine }
    wPoi: byte; { Z„hler ab der "Match"-Stelle }
    sPoi: byte; { Z„hler im Suchstring }
    found: boolean; { weitere šbereinstimmung? }
  begin
    with ObjectLine^ do
    begin
      OwnPoi := 1;
      while (OwnPoi <= EOLPos) do
      begin
        if (ord(ostr[1]) = line[OwnPoi].Oid) then
        begin
          found := true;
          sPoi := 2;
          wPoi := succ(OwnPoi);
          while (sPoi <= length(ostr)) and (found) do
          begin
            if (wPoi > EOLPos) or (ord(ostr[sPoi]) <> line[wPoi].Oid) then
            begin
              found := false
            end
            else
            begin
              inc(sPoi);
              inc(wPoi);
            end;
          end;
          if found then { bereits fertig }
          begin
            InSideLine := OwnPoi;
            exit;
          end;
        end;
        inc(OwnPoi);
      end;
    end;
    InSideLine := 0;
  end;

  function TstMatch(x: string; Semantik: SemantikProc): boolean;
  var
    sPos: byte;
  begin
    sPos := InSideLine(x);
    if (sPos > 0) then
      Semantik(sPos);
    TstMatch := (sPos > 0)
  end;

  function TstFix(x: string; Semantik: SemantikProc): boolean;
  var
    sPos: byte;
  begin
    sPos := InSideLine(x);
    if (sPos = 1) then
      Semantik(sPos);
    TstFix := (sPos = 1)
  end;

  procedure ShowOline;
  var
    IdPos: byte;
    OutpStr: string;
    id: byte;
  begin
    OutpStr := '';
    with ObjectLine^ do
    begin
      IdPos := 1;
      while (line[IdPos].Oid <> EOLId) do
      begin
        id := line[IdPos].Oid;
        if id <> sId then
          OutpStr := OutpStr + btostr(id, 0) + ','
        else
        begin
          if line[IdPos].VarName <> '' then
            OutpStr := OutpStr + line[IdPos].VarName + ','
          else
            OutpStr := OutpStr + '"' + gets(IdPos) + '",';
        end;
        inc(IdPos);
      end;
    end;
    BasicErrors.add(OutpStr);
  end;

begin

  eoe := false;
  repeat

    if BasicDebug then
      ShowOline;

    if (ObjectLine^.EOLPos <= 1) then
      goto cut;

    { RemId EOLId -> eps }
    if TstFix(chr(RemId) + chr(EOLId), ProcRem) then
      goto cut;

    { sId EOLId -> eps }
    if TstFix(chr(sId) + chr(EOLId), ProcLabel) then
      goto cut;

    { ReturnId EOLId -> eps }
    if TstFix(chr(ReturnId) + chr(EOLId), ProcReturn) then
      goto cut;

    { PageBreakId EOLId -> eps }
    if TstFix(chr(PageBreakId) + chr(EOLId), ProcDevicePagebreak) then
      goto cut;

    { sId concatid sId -> sId }
    if TstMatch(chr(sId) + chr(ConcatId) + chr(sId), ProcStringConcat) then
      goto cut;

    { trueId -> sId }
    if TstMatch(chr(TrueId), ProcTrue) then
      goto cut;

    { falseId -> sId }
    if TstMatch(chr(FalseId), ProcFalse) then
      goto cut;

    { lenId BraOpenId sId BraCloseId -> sId }
    if TstMatch(chr(lenId) + chr(BraOpenId) + chr(sId) + chr(BraCloseId), ProcLen) then
      goto cut;

    { SQLId BraOpenId sId BraCloseId -> sId }
    if TstMatch(chr(SQLId) + chr(BraOpenId) + chr(sId) + chr(BraCloseId), ProcSQL) then
      goto cut;

    { chrId BraOpenId sId BraCloseId -> sId }
    if TstMatch(chr(chrID) + chr(BraOpenId) + chr(sId) + chr(BraCloseId), ProcChr) then
      goto cut;

    { RoundId BraOpenId sId BraCloseId -> sId }
    if TstMatch(chr(RoundId) + chr(BraOpenId) + chr(sId) + chr(BraCloseId), ProcRound) then
      goto cut;

    { midId BraOpenId sId kommaId sId kommaId sId BraCloseId -> sId }
    if TstMatch(chr(midId) + chr(BraOpenId) + chr(sId) + chr(KommaId) + chr(sId) + chr(KommaId) + chr(sId) +
      chr(BraCloseId), ProcMid) then
      goto cut;

    { valId BraOpenId sId kommaId sId kommaId sId BraCloseId -> sId }
    if TstMatch(chr(valId) + chr(BraOpenId) + chr(sId) + chr(KommaId) + chr(sId) + chr(KommaId) + chr(sId) +
      chr(BraCloseId), ProcVal) then
      goto cut;

    { posId BraOpenId sId kommaId sId BraCloseId -> sId }
    if TstMatch(chr(posId) + chr(BraOpenId) + chr(sId) + chr(KommaId) + chr(sId) + chr(BraCloseId), ProcPos) then
      goto cut;

    { fillId BraOpenId sId kommaId sId BraCloseId -> sId }
    if TstMatch(chr(fillId) + chr(BraOpenId) + chr(sId) + chr(KommaId) + chr(sId) + chr(BraCloseId), Procfill) then
      goto cut;

    { BraOpenId sId BraCloseId -> sId }
    if TstMatch(chr(BraOpenId) + chr(sId) + chr(BraCloseId), ProcDelBraket) then
      goto cut;

    { NotId sId -> sId }
    if TstMatch(chr(NotId) + chr(sId), ProcNot) then
      goto cut;

    { sId andId sId -> sId }
    if TstMatch(chr(sId) + chr(AndId) + chr(sId), ProcAnd) then
      goto cut;

    { sId orId sId -> sId }
    if TstMatch(chr(sId) + chr(OrId) + chr(sId), ProcOr) then
      goto cut;

    { sId MalId sId -> sId }
    if TstMatch(chr(sId) + chr(MalId) + chr(sId), ProcMul) then
      goto cut;

    { sId DivId sId -> sId }
    if TstMatch(chr(sId) + chr(DivId) + chr(sId), ProcDiv) then
      goto cut;

    { sId PlusId sId -> sId }
    if TstMatch(chr(sId) + chr(PlusId) + chr(sId), ProcPlus) then
      goto cut;

    { sId MinusId sId -> sId }
    if TstMatch(chr(sId) + chr(MinusId) + chr(sId), ProcMinus) then
      goto cut;

    { letid sId eqId sId EOLId -> eps }
    if TstFix(chr(LetId) + chr(sId) + chr(EqId) + chr(sId) + chr(EOLId), ProcLetss) then
      goto cut;

    { AliasId Sid eqId Sid EOLId -> eps }
    if TstFix(chr(AliasId) + chr(sId) + chr(EqId) + chr(sId) + chr(EOLId), ProcAlias) then
      goto cut;

    { sId EqId sId -> sId }
    if TstMatch(chr(sId) + chr(EqId) + chr(sId), ProcStrId) then
      goto cut;

    { sId GreaterId sId -> sId }
    if TstMatch(chr(sId) + chr(GreaterId) + chr(sId), ProcStrGreater) then
      goto cut;

    { sId LessId sId -> sId }
    if TstMatch(chr(sId) + chr(LessId) + chr(sId), ProcStrLess) then
      goto cut;

    { ifId sId thenId gosubid sid EOLId -> eps }
    if TstFix(chr(IfId) + chr(sId) + chr(ThenId) + chr(GosubId) + chr(sId) + chr(EOLId), ProcIfGosub) then
      goto cut;

    { ifId sId thenId sid EOLId -> eps }
    if TstFix(chr(IfId) + chr(sId) + chr(ThenId) + chr(sId) + chr(EOLId), ProcIf) then
      goto cut;

    { printId sId SemiId EOLId -> eps }
    if TstFix(chr(PrintId) + chr(sId) + chr(SemiId) + chr(EOLId), ProcPrintStringSemi) then
      goto cut;

    { printId sId EOLId -> eps }
    if TstFix(chr(PrintId) + chr(sId) + chr(EOLId), ProcPrintString) then
      goto cut;

    { printId EOLId -> eps }
    if TstFix(chr(PrintId) + chr(EOLId), ProcPrint) then
      goto cut;

    { printId s,s,s EOLId -> eps }
    if TstFix(chr(PrintId) + chr(sId) + chr(KommaId) + chr(sId) + chr(KommaId) + chr(sId) + chr(EOLId), ProcPrintPicture)
    then
      goto cut;

    { gotoId sId EOLId -> eps }
    if TstFix(chr(GotoId) + chr(sId) + chr(EOLId), ProcGoto) then
      goto cut;

    { CallId sId EOLId -> eps }
    if TstFix(chr(CallId) + chr(sId) + chr(EOLId), ProcCall) then
      goto cut;

    { FontId sId [ [,sId], sId] }
    if TstFix(chr(FontId) + chr(sId) + chr(EOLId), ProcFontp) then
      goto cut;
    if TstFix(chr(FontId) + chr(sId) + chr(KommaId) + chr(sId) + chr(EOLId), ProcFontpp) then
      goto cut;
    if TstFix(chr(FontId) + chr(sId) + chr(KommaId) + chr(sId) + chr(KommaId) + chr(sId) + chr(EOLId), ProcFontppp) then
      goto cut;

    { MoveId sId,sId }
    if TstFix(chr(MoveId) + chr(sId) + chr(KommaId) + chr(sId) + chr(EOLId), ProcMove) then
      goto cut;

    { gosubId sId EOLId -> eps }
    if TstFix(chr(GosubId) + chr(sId) + chr(EOLId), ProcGosub) then
      goto cut;

    { nulid EOLId -> eps }
    if TstFix(chr(NulId) + chr(EOLId), ProcNul) then
      goto cut;

    { prnId EOLId -> eps }
    if TstFix(chr(PrnId) + chr(EOLId), ProcPrn) then
      goto cut;

    { debugID EOLId -> eps }
    if TstFix(chr(DebugId) + chr(EOLId), ProcDebug) then
      goto cut;

    { InputId Sid kommaid Sid EOLId -> eps }
    if TstFix(chr(InputId) + chr(sId) + chr(KommaId) + chr(sId) + chr(EOLId), ProcInput) then
      goto cut;

    { FINPUTId sId EOLId -> eps }
    if TstFix(chr(FINPUTId) + chr(sId) + chr(EOLId), ProcFINPUT) then
      goto cut;

    { FCLOSEId EOLId -> eps }
    if TstFix(chr(FCLOSEId) + chr(EOLId), ProcFCLOSE) then
      goto cut;

    { FSORTId sId EOLId -> eps }
    if TstFix(chr(FSORTId) + chr(sId) + chr(EOLId), ProcFSORT) then
      goto cut;

    { FOPENId sId EOLId -> eps }
    if TstFix(chr(FOPENId) + chr(sId) + chr(EOLId), ProcFOPEN) then
      goto cut;

    { FCREATE sId EOLId -> eps }
    if TstFix(chr(FCREATEId) + chr(sId) + chr(EOLId), ProcFCReate) then
      goto cut;

    { deviceID sID EOLId -> eps }
    if TstFix(chr(DeviceId) + chr(sId) + chr(EOLId), ProcDevice) then
      goto cut;

    { deviceID sID,sID EOLId -> eps }
    if TstFix(chr(DeviceId) + chr(sId) + chr(KommaId) + chr(sId) + chr(EOLId), ProcDeviceForm) then
      goto cut;

    { FprintId sId SemiId EOLId -> eps }
    if TstFix(chr(FPRINTId) + chr(sId) + chr(SemiId) + chr(EOLId), ProcFPrintStringSemi) then
      goto cut;

    { FprintId sId EOLId -> eps }
    if TstFix(chr(FPRINTId) + chr(sId) + chr(EOLId), ProcFPrintString) then
      goto cut;

    { FprintId EOLId -> eps }
    if TstFix(chr(FPRINTId) + chr(EOLId), ProcFPrintLN) then
      goto cut;

    { SYSTEMId sid EOLId -> eps }
    if TstFix(chr(SYSTEMId) + chr(sId) + chr(EOLId), ProcSYSTEM) then
      goto cut;

    { END EOLid }
    if TstFix(chr(ENDId) + chr(EOLId), ProcEnd) then
      goto cut;

    { ABORT EOLid }
    if TstFix(chr(AbortId) + chr(EOLId), ProcEnd) then
    begin
      Err(USERBREAK, '');
      goto cut;
    end;

    ObjectLine^.clear;
    Err(SYNTAXERROR, '');

  cut:
    eoe := (ObjectLine^.EOLPos <= 1);
  until (eoe) or (BasicError > 0);
end;

function TBasicProcessor.RUN(StartLineNumber: integer = 0): boolean;
var
  x: string;
  l: Integer;
begin
  // Clear Errors from last run
  BasicError := 0;
  BasicErrors.Clear;

  ShouldRUN := false;
  inc(DruckStueckZaehler);
  CollectGotoMarks;
  if (BasicError = 0) then
  begin
    BasicLine := pred(StartLineNumber);
    repeat
      inc(BasicLine);
      if (BasicLine = count) then
        break;
      x := cutblank(strings[BasicLine]);


      repeat
        l := length(x);
        if (l=0) then
         break;
        if (x[l]<>'#') then
         break;
        // concat lines
        inc(BasicLine);
        if (BasicLine = count) then
          break;
        x := copy(x,1,pred(l)) + cutblank(strings[BasicLine]);
      until eternity;

      ASCII2ObjectLine(x);
      if (BasicError = 0) then
      begin
        if DebugMode then
         WriteVal(cPREDEF_ZEILE,inttostr(succ(BasicLine)));
        ExecuteObjectLine;
      end;
    until (BasicError > 0);
  end;
  result := (BasicError = 0) or (BasicError=BASICEND);

  // Automatischer Abschluss den Druckens
  if (printer.printing) then
  begin
    if result then
      printer.EndDoc
    else
      printer.Abort;
  end;
  ValChanged := false;
end;

procedure TBasicProcessor.CLS;
begin
 BasicOutPut.Clear;
end;

function TBasicProcessor.CollectGotoMarks: boolean;
var
  x: string;
  l : Integer;
  StrPos: byte;
  OwnPoi: word;
  n: word;
  IgnoreLine : boolean;
begin
  ClearGotoMarks;
  BasicLine := -1;
  IgnoreLine := false;
  repeat
    inc(BasicLine);
    if (BasicLine = count) then
      break;
    l := length(strings[BasicLine]);

    { empty Lines <> Label Lines }
    if (l=0) then
     continue;

    { concat Lines <> Label Lines }
    if (strings[BasicLine][l]='#') then
     continue;

    { minimaler Label: "1" }
    if (l<3) then
     continue;

    { line is "* ? }
    if (pos('"', strings[BasicLine]) = 1) then
    begin
      x := strings[BasicLine];

      { neuen Label eintragen }
      x[1] := ' ';
      StrPos := pos('"', x);
      if (StrPos = 0) then
        Err(ERRORINLABEL, '');
      if (StrPos - 2 > LabelLen) then
        Err(LABELTOOLONG, '');
      OwnPoi := 1;
      while (LabelArray^[OwnPoi].LName <> '') and (OwnPoi < LabelAnz) do
        inc(OwnPoi);
      if (LabelArray^[OwnPoi].LName <> '') then
        Err(TOOMANYLABELS, '')
      else
      begin

        { OK, insert the new Label }
        with LabelArray^[OwnPoi] do
        begin
          LName := copy(x, 2, StrPos - 2);
          LineNo := BasicLine;
        end;

        { check for duplicates }
        for n := 1 to pred(OwnPoi) do
          if (LabelArray^[n].LName = LabelArray^[OwnPoi].LName) then
            Err(DUPLABEL, '');
      end;
    end;
  until (BasicError > 0);
  result := (BasicError = 0);
end;

{ TBasicPrintProcessor }

constructor TBasicProcessor.create;
begin
  inherited;

  // ExternalCall := DummyExternalCall;
  BasicErrors := TStringList.create;
  BasicOutPut := TStringList.create;
  new(ObjectLine, init);
  new(GosubStack);
  new(LabelArray);
  ClearGotoMarks;
  WriteVal(cPREDEF_ANZAHL, '1');
  WriteVal(cPREDEF_FORMULAR, 'LABEL');
end;

destructor TBasicProcessor.Destroy;
begin
  dispose(ObjectLine);
  dispose(GosubStack);
  dispose(LabelArray);
  BasicErrors.free;
  BasicOutPut.free;
  BasicClear;
  inherited;
end;

function TBasicProcessor.Resolve(name: string): string;
var
  p: StringRecTypeP;
begin
  result := '';
  p := StringVars;
  while (p <> nil) do
  begin
    if (Name = p^.alias) then
    begin
      result := p^.data;
      break;
    end;
    p := p^.nxt;
  end;
  if (result = '') then
    if assigned(ResolveData) then
      result := ResolveData(Name);
end;

function TBasicProcessor.BasicMsg: string;
begin
  if (BasicError <= BASICLASTERROR) then
    result := BasicErrorStrings[BasicError]
  else
    result := '?';
end;

procedure TBasicProcessor.ProcFontp(No: byte);
var
  p1: string;
begin
  EnsurePrinting;
  p1 := gets(No + 1);
  if (p1 <> '') then
  begin
    printer.canvas.font.name := p1;
    printer.canvas.font.PixelsPerInch := GetDeviceCaps(printer.canvas.Handle, LOGPIXELSY);
  end;
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcFontpp(No: byte);
var
  p1, p2: string;
begin
  EnsurePrinting;
  p1 := gets(No + 1);
  if (p1 <> '') then
    printer.canvas.font.name := p1;
  p2 := gets(No + 3);
  if (p2 <> '') then
  begin
    printer.canvas.font.size := -strtointdef(p2, 0);
    printer.canvas.font.PixelsPerInch := GetDeviceCaps(printer.canvas.Handle, LOGPIXELSY);
  end;
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcFontppp(No: byte);
var
  p1, p2, p3, p4: string;

  function NextP(var s: string; Delimiter: string): string;
  var
    k: integer;
  begin
    k := pos(Delimiter, s);
    if (k > 0) then
    begin
      result := copy(s, 1, pred(k));
      system.delete(s, 1, pred(k + length(Delimiter)));
    end
    else
    begin
      result := s;
      s := '';
    end;
  end;

begin
  EnsurePrinting;
  p1 := gets(No + 1);
  if (p1 <> '') then
    printer.canvas.font.name := p1;
  p2 := gets(No + 3);
  if (p2 <> '') then
    printer.canvas.font.height := -strtointdef(p2, 0);
  p3 := gets(No + 5);
  while (p3 <> '') do
  begin
    printer.canvas.font.style := [];
    p4 := NextP(p3, ',');
    if (p4 = 'bold') then
      printer.canvas.font.style := printer.canvas.font.style + [fsbold];
    if (p4 = 'underline') then
      printer.canvas.font.style := printer.canvas.font.style + [fsunderline];
    if (p4 = 'italic') then
      printer.canvas.font.style := printer.canvas.font.style + [fsitalic];
  end;
  printer.canvas.font.PixelsPerInch := GetDeviceCaps(printer.canvas.Handle, LOGPIXELSY);

  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcMove(No: byte);
begin
  _pX := strtointdef(gets(No + 1), 0);
  _pY := strtointdef(gets(No + 3), 0);
  ObjectLine^.clear;
end;

procedure TBasicProcessor.EnsurePrinting;
var
  _FormName, Device, Driver, Port: array [0 .. MAX_PATH] of Char;
  DevMode: THandle;
  pDevmode: PDeviceMode;
  DruckStueckTitel: string;
begin
  with printer do
    if not(printing) then
    begin

      // Titel festlegen
      DruckStueckTitel := ReadVal(cPREDEF_TITEL);
      if (DruckStueckTitel = '') then
        DruckStueckTitel := 'RUN#' + inttostr(DruckStueckZaehler);
      Title := DruckStueckTitel;

{$IFNDEF FPC}
      //
      GetPrinter(Device, Driver, Port, DevMode);
      // force reload of DEVMODE
      SetPrinter(Device, Driver, Port, 0);
      // get DEVMODE handle
      GetPrinter(Device, Driver, Port, DevMode);
      if (DevMode <> 0) then
      begin
        // lock it to get pointer to DEVMODE record
        pDevmode := GlobalLock(DevMode);
        if (pDevmode <> nil) then
          try
            with pDevmode^ do
            begin

              // Druckmedium ändern
              StrLCopy(dmFormName, StrPCopy(_FormName, ReadVal(cPREDEF_FORMULAR)), CCHFORMNAME - 1);
              dmFields := dmFields or DM_FORMNAME;

              // Anzahl der Kopien ändern
              dmCopies := max(1, strtointdef(ReadVal(cPREDEF_ANZAHL), 0));
              dmFields := dmFields or DM_COPIES;

            end;
          finally
            GlobalUnlock(DevMode); // unlock devmode handle.
          end;
      end; { If }
{$ENDIF}
      BeginDoc;
      canvas.font.size := -8;
      canvas.font.PixelsPerInch := GetDeviceCaps(printer.canvas.Handle, LOGPIXELSY);
      _pX := 0;
      _pY := 0;
    end;
end;

procedure TBasicProcessor.ProcDevice(No: byte);
var
  k: integer;
begin
  if (DeviceOverride <> 'null') then
  begin
    if DeviceOverride = '' then
      k := printer.Printers.indexof(gets(No + 1))
    else
      k := printer.Printers.indexof(DeviceOverride);
    if (k <> -1) then
      printer.printerIndex := k
    else
      BasicErrors.add('Drucker unbekannt!');
  end;
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcDeviceForm(No: byte);
var
  k: integer;
begin
  if (DeviceOverride <> 'null') then
  begin
    if printer.printing then
    begin
      BasicErrors.add('DEVICE kommt zu spät. Es wird schon gedruckt!');
    end
    else
    begin
      if (DeviceOverride = '') then
        k := printer.Printers.indexof(gets(No + 1))
      else
        k := printer.Printers.indexof(DeviceOverride);
      WriteVal(cPREDEF_FORMULAR, gets(No + 3));
      if (k <> -1) then
        printer.printerIndex := k
      else
        BasicErrors.add('Drucker unbekannt!');
    end;
  end;
  ObjectLine^.clear;
end;

procedure TBasicProcessor.ProcDevicePagebreak(No: byte);
begin
  if (DeviceOverride <> 'null') then
  begin
    EnsurePrinting;
    printer.NewPage;
    _pX := 0;
    _pY := 0;
  end;
  ObjectLine^.clear;
end;

end.
