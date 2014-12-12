{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007  Andreas Filsinger
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
unit html;

{$I jcl.inc}
// ------------------------------------------------------------------
//
// (c)'18.04.00 by Andreas Filsinger, http://OrgaMon.org
//
// ------------------------------------------------------------------

// to-do: Block-Consumption angebbar machen, das ist die Anzahl der Zeilen
// oder die aktuelle Höhe, die der eingesetzt Block braucht, im Momnet
// ist das immer "1". Ev. noch prüfen, da er schon korret die <br>
// Zählt.
//
// Konzept der "Optionalen Fragmente", entweder Ankreuzbar oder
// eine grundsätzliche Klassifizierung.
// S=Single Page
// F=First Page (of n)
// N=Next Page (of n)
// L=Last Page (of n)
//
// Dokument = S | F [{ N }] L
//
// |S|F|N|L|
// LLLLLLLLL   |X|X| | |  Anschrift
// LLLLLLLL  |X|X| | |  Header
// LLLLLLLL  | | |X|X|  Übertrag
// LLLLLLLL  |X|X|X|X|  Positionen
// LLLLLL     | |X|X| |  Zwischensumme
// LLLLLL     |X| | |X|  Summe
//
// ----------------------------------------------------------------------------------------
// bei Tabellen besteht das Problem im Moment des letzten Datensatzes oft nicht
// zu wissen, dass es weiter geht. Dann muss im Nachhinein der letzt "load ZEILE MID"
// in ein load ZEILE LAST umgesetzt werden. Dies macht diese Routinen
// for n := pred(DatensammlerLokal.count) downto 0 do
// begin
// if (pos(chtml_MIDAUFTRAG, DatensammlerLokal[n]) = 1) then
// begin
// DatensammlerLokal[n] := 'load AUFTRAG LAST,AUFTRAG';
// break;
// end;
// end;
//
// ----------------------------------------------------------------------------------------
// bei Blöcken die even/odd sind, die also eine unterschiedliche ausprägung haben
// abhängig von ihrer Position besteht ein Problem beim sortieren:
// wird die Reihenfolge verändert wird die even/odd eigenschaft belassen, aber
// even kann u.U. nun auf even folgen, was unschön aussieht!
// Die Lösung ist eigentlich ein "$ifpos" Konstruct inerhalb eines Fragmentes
// Die ganze Logik für die Ausprägungsunterschiede müssen also im Fragement selbst
// formuluiert werden können. Es werden dann nicht mehr 2 alternative Blöcke zur
// verfügung gestellt, sondern nur noch einer, aber mit allen möglichen Varianten
// schon per Logikausdrücken in sich drin.
// ----------------------------------------------------------------------------------------
// Optimierung des Writevalue, besonders bei grossen Ausbelichtungen:
//
// Bei CheckreplaceOne könnte man einen SuchCache Namens "~" benutzen. Es müssen nicht
// immer alle Zeilen durchsucht werden, sondern die, die ein "~" enthalten. "Stufe 1"
// [Lines]
// Man könnte auch die Stellen (Zeilennummern) verzeichnen wo bestimmte werte noch stehen
// ~XX~ in 0,2,3,4 kommen Zeilen hinzu muss der Cache erweitert werden, finden Ersetzungen statt
// so muss der Cache gekürzt werden. Also eine SearchString@[Lines] Datenstruktur "Stufe 2"
// Immer bei einem Zugang (insert, load, add) könnte man den Cache erweitern
// ----------------------------------------------------------------------------------------

//
// ..\..\rev\anfix32.rev
interface

uses
  classes,
  anfix32,
  gplists

{$IFNDEF FPC}
    ,
  System.UITypes
{$ELSE}
    , Graphics, fpchelper
{$ENDIF}
    ;

const
  cVarDelimiter = '~';
  cReferenceDelimiterBegin = cVarDelimiter + '(';
  cReferenceDelimiterEnd = ')' + cVarDelimiter;
  cPageBreakHerePossible = 'pagebreak';
  cNonBreakableSpace = #160;
  cRawHTMLPrefix = '@'; { @... unterdrückt die "ascii -> html"-Umsetzung }
  cSeite = 'Seite';
  cSeiten = 'Seiten';

  // set ...
  // Allgemeine Optionen
  cSet_Context = 'Kontext'; // damit kann ein Umgebungswert gesetzt werden
  // Base64 Quellpfad
  cSet_AnlagePath = 'Anlagenverzeichnis';

  //
  // Referenz-Sachen
  cSet_Quelle = 'Referenzquelle';
  cSet_Key = 'Referenz';
  cSet_KeyPrefix = 'Referenz-Prefix';
  cSet_KeyPostfix = 'Referenz-Postfix';
  cSet_KeyNumeric = 'Referenz-Numerisch'; // default = JA | NEIN
  cSet_KeyBegin = 'Block-Start-Tag';
  cSet_KeyEnd = 'Block-End-Tag';
  cSet_KeyUTF8 = 'Referenz-utf8'; // default = JA | NEIN

  // html - Konstanten
  cColor_Rosa = '#FF99FF';
  cColor_Gruen = '#00FF66';
  cColor_Braun = '#CC9933';
  cColor_Rot = '#FF6600';
  cHTML_FormFeed = '<p class="breakhere">&nbsp;</p>';

  // Prefix-Tags im html
  cHTML_BeginBlock = '<!-- BEGIN ';
  cHTML_EndBlock = '<!-- END ';
  cHTML_InsertMark = '<!-- INSERT ';
  cHTML_IncludeFile = '<!-- INCLUDE ';

  cHTML_MaxLines = '<!-- SET MAXLINES ';
  cHTML_Copies = '<!-- SET NUMBER OF COPIES ';
  cHTML_ComputeFile = '<!-- COMPUTE ';
  cHTML_Let = '<!-- LET ';
  cHTML_ANSI = '<!-- ANSI ';
  cHTML_OHNE_ROHDATEN = '<!-- OHNE ROHDATEN ';
  cHTML_SortInfo = '<!-- SORT ';
  cHTML_RohdatenStart = '<!-- START DER ROHDATEN';
  cHTML_IncludesStart = '<!-- START DER INCLUDES';
  cHTML_MessagesStart = '<!-- START DER MELDUNGEN';

  // Kommentar Postfix
  cHTML_Comment_PreFix = '<!-- ';
  cHTML_Comment_PostFix = ' -->';

  c_xml_CRLF = '&#xA;';
  c_xml_ampersand = '&amp;';
  c_xml_lessthan = '&lt;';
  c_xml_greaterthan = '&gt;';
  c_xml_apostrophe = '&apos;';
  c_xml_quote = '&quot;';

type
  THTMLTemplate = class(TStringList)
  private
    FileName: string;
    _BlockStart: integer;
    _BlockEnd: integer;
    _Reference: string;
    PhaseCount: integer;
    Blocks: TStringList;
    DatenSammlerLocal: TStringList;
    DatenSammlerGlobal: TStringList;
    SystemHeap: TStringList;
    InputForms: TStringList;
    InputActions: TStringList;
    IncludeList: TStringList;
    AnsiAusgabe: boolean;
    OhneRohdaten: boolean; // unterdrückt die Hinzunahme der Rohdaten
    Diagnose: TStringList;
    Reference: TStringList;

    function CheckReplaceOne(n: integer;
      const CheckStr, toValue: string): boolean;
  public
    DateA, DateB: TAnfixDate;
    CanUseQuick: boolean;
    CountForms: integer; // 28.09.2004 TS
    forceUTF8: boolean;
    DiagnoseModus: boolean;
    FatalErrors: integer;
    Messages: TStringList;

    //
    function Context: string;
    function ERRORprefix: string;
    function WARNINGprefix: string;
    procedure addFatalError(cause: string);
    procedure addWarning(cause: string);

    procedure WriteValue(BlockName, VarName, NewValue: string); overload;
    function WriteValue(VarName, NewValue: string): integer; overload;
    procedure WriteValue(BlockName, VarName: string;
      NewValue: TStrings); overload;
    procedure WriteValue(FullPage: TStrings); overload;
    procedure WriteValue(FullPageLokal, FullPageGlobal: TStrings); overload;
    procedure WriteValueOnce(VarName, NewValue: string);
    procedure WriteValueQuick(VarName, NewValue: string);
    procedure Write2Value(VarName, NewValue1, NewValue2: string);
    procedure WriteValue; overload;

    procedure WriteLocal(OneLine: string);
    procedure WriteGlobal(OneLine: string);
    procedure WritePageBreak;

    // Block-Logik
    function findBlockBegin(Block: string): integer;
    function findBlockEnd(Block: string): integer;
    function findInsertMark(Block: string): integer;

    procedure ClearBlock(Block: string);
    procedure DeleteBlock(Block: string);

    procedure SaveBlock(Block: string); overload;
    procedure SaveBlock(Block, AsBlock: string); overload;
    procedure SaveBlock(Block, NewBlock, AsBlock: string); overload;
    procedure SaveBlockToFile(Block, FName: string); overload;
    procedure SaveBlockToFile(Block, NewBlock, FName: string); overload;

    procedure SaveDeleteBlock(Block: string);

    procedure LoadBlock(atIndex: integer; NewStrings: TStrings); overload;
    procedure LoadBlock(Block: string); overload;
    procedure LoadBlock(FromBlock, AsBlock: string;
      KillInsertMark: boolean = false); overload;
    procedure LoadBlock(FromBlock, AsBlock: string; NewStrings: TStrings;
      KillInsertMark: boolean = false); overload;
    procedure LoadBlock(Block: string; NewStrings: TStrings;
      KillInsertMark: boolean = false); overload;
    procedure LoadBlockFromFile(Block, FName: string);
    procedure LoadFromFile(const FileName: string); override;

    procedure SaveToFileCompressed(FName: string);
    procedure InsertDocument(FName: string);

    // Sorting
    procedure SortPages;
    procedure SortBlocks(Block: string);

    // Dereference by static xml DB
    procedure Dereference(Options: string);

    // set Dates
    procedure setDatesFromFile(FName: string);

    // Forms
    procedure Parse;
    procedure ClearForms;
    procedure SaveForms(FName: string);
    function GetForm(FormName: string): TStringList; overload;
    function GetForm(index: integer): TStringList; overload; // 28.09.2004 TS
    function GetFormName(index: integer): string; // 28.09.2004 TS
    function GetFormAction(FormName: string): string; overload;
    function GetFormAction(index: integer): string; overload;
    function GetFormQuery(FormName: string): string;
    // 16.08.2004 Thorsten Schroff, Result = Query-String hinter dem Fragezeichen
    function GetFormURL(FormName: string): string;
    function GetJavaParams(FunctionName: string): TStringList;

    constructor create; virtual;
    destructor Destroy; override;
  end;

  THTMLAusgabe = class(TStringList)
    constructor create; virtual;
    destructor Destroy; override;
    function AsIntegerList(Values: string): TgpIntegerList;
  end;

function TColor2HTMLColor(Value: TColor): string;
function HTMLColor2TColor(Value: integer): TColor; overload;
function HTMLColor2TColor(Value: string): TColor; overload;
function HTMLColor2RGBConst(Value: string): string; overload;
function HTMLColor2RGBConst(Value: integer): string; overload;
function UnbreakAble(s: string): string;

// immer prüfen, ob nicht "nowrap" möglich ist

{

  Info über html-Farben

  HTML                  TColor
  COLOR="#rrggbb"       $00bbggrr
  #AEC6F6               $00F6C6AE

}

function Ansi2html(s: AnsiString): string;
function html2Ansi(x: string): string;
function AnsiToRFC1738(s: string): string;
function RFC1738ToAnsi(s: string): string;
function html2raw(x: string): string; overload;
function html2raw(x: TStrings): TStrings; overload;
function eMailAdresseOK(e: string): boolean; overload;

implementation

uses
  windows, SysUtils, math,
  IniFiles,
{$IFNDEF fpc}
  Soap.EncdDecd,
{$ENDIF}
  JclSimpleXML,
  JclStreams;

const
  cERRORText = 'ERROR:';
  cWARNINGText = 'WARNING:';

  // für das belichten mehrseitiger Dokumente
  cPageSingle = 'PAGE_SINGLE';
  cPageFirst = 'PAGE_FIRST';
  cPageNext = 'PAGE_NEXT';
  cPageLast = 'PAGE_LAST';

type
  TPageBlock = class(TObject)
    SortStr: string;
    StartPage: integer;
    EndPage: integer;
  end;

function THTMLTemplate.Context: string;
begin
  result := SystemHeap.Values[cSet_Context];
end;

function THTMLTemplate.ERRORprefix: string;
var
  _Context: string;
begin
  _Context := Context;
  if (_Context <> '') then
    result := cERRORText + ' (RID=' + _Context + ') '
  else
    result := cERRORText + ' ';
end;

function THTMLTemplate.WARNINGprefix: string;
var
  _Context: string;
begin
  _Context := Context;
  if (_Context <> '') then
    result := cWARNINGText + ' (RID=' + _Context + ') '
  else
    result := cWARNINGText + ' ';
end;

procedure THTMLTemplate.addFatalError(cause: string);
begin
  Messages.add(ERRORprefix + cause);
  inc(FatalErrors);
  if DebugMode then
  begin
    AppendStringsToFile(
      { } ERRORprefix + cause,
      { } ExtractFilePath(FileName) +
      { } 'Command.log');
  end;
end;

procedure THTMLTemplate.addWarning(cause: string);
begin
  Messages.add(WARNINGprefix + cause);
  inc(FatalErrors);
  if DebugMode then
  begin
    AppendStringsToFile(
      { } WARNINGprefix + cause,
      { } ExtractFilePath(FileName) +
      { } 'Command.log');
  end;
end;

function THTMLTemplate.CheckReplaceOne(n: integer;
  const CheckStr, toValue: string): boolean;

  function Komma_F(s: string): string;
  var
    d: double;
  begin
    result := s;
    if (result <> '') then
    begin
      d := strtodoubledef(result, 0);
      result := FloatToStrISO(d, 1);
    end
    else
    begin
      result := '0.0';
    end;
  end;

  function Boolean_F(s: string): string;
  begin
    if pos(s, 'xXyYjJ1') > 0 then
      result := 'true'
    else
      result := 'false'
  end;

  function Null_F(s: string; StellenAnz: integer): string;
  begin
    result := noblank(s);
    result := fill('0', StellenAnz - length(result)) + result;
  end;

  function zeit_F(s: string): string;
  var
    DiagDump: string;
  begin
    if DiagnoseModus then
      DiagDump := '''' + s + '''';

    result := StrFilter(s, '0123456789,');
    if (pos(',', result) > 0) then
      result := IntToStr(round(strtodoubledef(result, 0) * 100.0));

    if (result <> '') then
    begin
      result := copy(result, 1, 4);
      case length(result) of
        1:
          result := '0' + result + '00'; // Beispiel: 8
        2:
          result := result + '00'; // Beispiel: 11
        3:
          result := '0' + result; // Beispiel 732
      end;
      result := copy(result, 1, 2) + ':' + copy(result, 3, 2) + ':' + '00';
    end;
    if DiagnoseModus then
    begin
      DiagDump := DiagDump + ' -> ''' + result + '''';
      Diagnose.add(DiagDump);
    end;
  end;

  function datum_f(s: string): string;
  begin
    result := '';
    if dateOK(s) then
    begin
      result := long2date(date2long(s));
      result := copy(result, 7, 4) + '-' + copy(result, 3, 2) + '-' +
        copy(result, 1, 2);
    end;
  end;

  function EncodeFile(FName: string): string;
  var
    Inf: TFileStream;
    OutF: TStringStream;
    AnlagenPath: string;
  begin

    // Ermittlung des Anlagen-Verzeichnis
    AnlagenPath := SystemHeap.Values[cSet_AnlagePath];
    if (AnlagenPath = '.\') then
      AnlagenPath := ExtractFilePath(SystemHeap.Values[cSet_Quelle]);

    // Anlage-Dateiname
    FName :=
    { } AnlagenPath +
    { } FName;

    // wenn Anlage nicht gefunden -> Fehler-Bild
    if not(FileExists(FName)) then
    begin
      addWarning('Datei "' + FName + '" nicht gefunden!');
      FName := ExtractFilePath(SystemHeap.Values[cSet_Quelle]) + 'ERROR.jpg';
    end;

    if not(FileExists(FName)) then
      FName := AnlagenPath + 'ERROR.jpg';

    // codieren
{$IFNDEF FPC}
    Inf := TFileStream.create(FName, fmOpenRead);
    OutF := TStringStream.create;
    EncodeStream(Inf, OutF);
    result := OutF.DataString;
    Inf.Free;
    OutF.Free;
{$ENDIF}
  end;

var
  Rest: string;

  function isCommand(Command: string): boolean;
  begin
    result := (pos(Command, Rest) = 2);
    if result then
      System.delete(Rest, 1, succ(length(Command)));
  end;

var
  k: integer;
  RawMode: boolean;
  NewValue: string;
begin
  k := pos(CheckStr, strings[n]);
  if (k = 0) then
  begin
    result := false;
  end
  else
  begin
    // gefunden!
    NewValue := toValue;
    RawMode := pos('@', NewValue) = 1;
    if RawMode then
      System.delete(NewValue, 1, 1);

    Rest := copy(strings[n], k + length(CheckStr), MaxInt);

    // Formatierungen
    while (pos('!', Rest) = 1) do
    begin

      if isCommand('1') then
      begin
        NewValue := nextp(NewValue, ',', 0);
        continue;
      end;

      if isCommand('EchtesKomma') then
      begin
        NewValue := Komma_F(NewValue);
        ersetze('.', ',', NewValue);
        continue;
      end;

      if isCommand('Komma') then
      begin
        NewValue := Komma_F(NewValue);
        continue;
      end;

      if isCommand('Boolean') then
      begin
        NewValue := Boolean_F(NewValue);
        continue;
      end;

      if isCommand('Null') then
      begin
        NewValue := Null_F(NewValue, StrtoIntDef('$' + copy(Rest, 1, 1), 0));
        System.delete(Rest, 1, 1);
        continue;
      end;

      if isCommand('ZeitDefault') then
      begin
        NewValue := zeit_F(NewValue);
        if (NewValue = '') then
          NewValue := '12:00:00';
        continue;
      end;

      if isCommand('Zeit') then
      begin
        NewValue := zeit_F(NewValue);
        continue;
      end;

      if isCommand('Datum') then
      begin
        NewValue := datum_f(NewValue);
        continue;
      end;

      if isCommand('^Y') then
      begin
        if NewValue = '' then
        begin
          Rest := '';
          strings[n] := '';
        end;
        continue;
      end;

      if isCommand('Base64') then
      begin
        NewValue := nextp(NewValue, ',', 0);
        if NewValue = '' then
        begin
          // weglöschen!!
          Rest := '';
          strings[n] := '';
        end
        else
        begin
          //
          NewValue := EncodeFile(NewValue);
        end;
        continue;
      end;

      // Keines der Kommandos gefunden!
      break;

    end;

    if RawMode then
      strings[n] := copy(strings[n], 1, pred(k)) + NewValue + Rest
    else
      strings[n] := copy(strings[n], 1, pred(k)) + Ansi2html(NewValue) + Rest;

    result := true;
  end;
end;

procedure THTMLTemplate.WriteValue(BlockName, VarName, NewValue: string);
var
  n: integer;
  InsideBlock: boolean;
  CheckStr: string;
begin
  InsideBlock := false;
  CheckStr := cVarDelimiter + VarName + cVarDelimiter;
  for n := 0 to pred(count) do
  begin
    if InsideBlock then
    begin
      while CheckReplaceOne(n, CheckStr, NewValue) do;
      if pos(cHTML_EndBlock + BlockName, strings[n]) = 1 then
        InsideBlock := false;
    end
    else
    begin
      if pos(cHTML_BeginBlock + BlockName, strings[n]) = 1 then
        InsideBlock := true;
    end;
  end;
end;

function THTMLTemplate.WriteValue(VarName, NewValue: string): integer;
var
  n: integer;
  CheckStr: string;
begin
  result := 0;
  CheckStr := cVarDelimiter + VarName + cVarDelimiter;

  for n := 0 to pred(count) do
    while CheckReplaceOne(n, CheckStr, NewValue) do
      inc(result);
end;

procedure THTMLTemplate.WriteValueQuick(VarName, NewValue: string);
var
  n: integer;
  OneHit: boolean;
  CheckStr: string;
begin
  OneHit := false;
  CheckStr := cVarDelimiter + VarName + cVarDelimiter;
  for n := pred(count) downto 0 do
  begin
    while CheckReplaceOne(n, CheckStr, NewValue) do
      OneHit := true;
    if OneHit then
      break;
  end;
end;

procedure THTMLTemplate.WriteValueOnce(VarName, NewValue: string);
var
  n: integer;
  CheckStr: string;
begin
  CheckStr := cVarDelimiter + VarName + cVarDelimiter;
  for n := succ(_BlockStart) to pred(_BlockEnd) do
    if CheckReplaceOne(n, CheckStr, NewValue) then
      break;
end;

procedure THTMLTemplate.WriteValue(FullPage: TStrings);
var
  n: integer;

  // verfügbare Zeilen
  FreiCount_Single: integer;
  FreiCount_First: integer;
  FreiCount_Next: integer;
  FreiCount_Last: integer;

  FreiCount_Single_Killer: string;
  FreiCount_First_Killer: string;
  FreiCount_Next_Killer: string;
  FreiCount_Last_Killer: string;

  ActPageFilled: integer; // aufgefüllt Bisher
  LookForwardBlock: integer;
  Seiten: integer;
  Seite: integer;

  LastExecuted: integer;

  procedure DebugSave(Comment: string);
  begin
    SaveToFile(
      { } ExtractFilePath(FileName) +
      { } 'Phase-' + IntToStrN(PhaseCount, 3) + '-' + Comment + '.ml');
    inc(PhaseCount);
  end;

  function CalcFreiraum(PageName: string; var FreiraumKiller: string): integer;
  var
    n: integer;
  begin
    result := MaxInt;
    for n := succ(findBlockBegin(PageName)) to pred(findBlockEnd(PageName)) do
      if pos(cHTML_MaxLines, strings[n]) = 1 then
      begin
        FreiraumKiller := strings[n];
        nextp(FreiraumKiller, cHTML_MaxLines);
        result := strtoint(nextp(FreiraumKiller, ' '));
        FreiraumKiller := nextp(FreiraumKiller, ' ');
        break;
      end;
  end;

//

var
  CB_Producer: string; // wer frisst Zeilen?

  // =0..pred(FullPage.count), wie weit wurde gesucht?
  // =FullPage.count, bereits zu Ende gesucht!
  CB_LastChecked: integer;

  CB_FreiCount: integer;

  // gehe zum nächsten "pagebreak" und zähle dabei
  // alle "killer", also alle Elemente, die Platz
  // kosten.
  function CBnext: integer;
  var
    k: integer;
    pName: string;
  begin
    result := 0;
    repeat

      if not(CB_LastChecked < FullPage.count) then
        break;

      k := pos('=', FullPage[CB_LastChecked]);
      if k > 0 then
      begin
        pName := copy(FullPage[CB_LastChecked], 1, pred(k));

        // "verbotene" Konsumenten haben soo hohe Kosten
        // dass deren vorkommen sofort zum PageBreak führt
        if (pos('!' + pName + ',', CB_Producer + ',') > 0) then
          inc(result, 1024);

        // normale Konsumer verbrauchen so viel wie er
        // Zeilen liefert
        if (pos(pName + ',', CB_Producer + ',') > 0) then
          inc(result, charCount(#13, copy(FullPage[CB_LastChecked], succ(k),
            MaxInt)) + 1);
      end;
      inc(CB_LastChecked);
      if (CB_LastChecked = FullPage.count) then
        break;

    until (result > 0) and
      (pos(cPageBreakHerePossible, FullPage[CB_LastChecked]) = 1);

  end;

// nur spekulatives Vorantasten, wieder zurückspringen
  function _CBnext: integer;
  var
    _CB_LastChecked: integer;
  begin
    _CB_LastChecked := CB_LastChecked;
    result := CBnext;
    CB_LastChecked := _CB_LastChecked;
  end;

  function CalcBedarf(BedarfProducer: string; FromLine: integer): integer;
  var
    _CB_LastChecked: integer;
    _CB_Producer: string;
  begin
    result := 0;
    _CB_LastChecked := CB_LastChecked;
    _CB_Producer := CB_Producer;
    CB_LastChecked := FromLine;
    CB_Producer := BedarfProducer;
    repeat
      inc(result, CBnext);
    until (CB_LastChecked = FullPage.count);
    CB_LastChecked := _CB_LastChecked;
    CB_Producer := _CB_Producer;
  end;

var
  FD_local: integer;

  function ExecAndFill(FullRun: boolean; FromLine, ToLine: integer): integer;
  var
    Command: string;
    OneLine: string;
    n: integer;
    CommandAccepted: boolean;
  begin
    for n := FromLine to min(ToLine, pred(FullPage.count)) do
      if (FullPage[n] <> '') then
      begin
        OneLine := FullPage[n];
        if (pos('=', OneLine) = 0) then
        begin

          if DebugMode then
            AppendStringsToFile(
              { } IntToStrN(PhaseCount, 3) + '-' + IntToStrN(n, 4) + ' '
              + OneLine,
              { } ExtractFilePath(FileName) +
              { } 'Command.log');

          //
          Command := nextp(OneLine, ' ');

          if (pos('local', Command) > 0) then
          begin
            FD_local := n;
            if not(FullRun) then
              break;
          end
          else
          begin

            repeat

              // nicht kombinierbare Kommandos werden mit break beendet
              if (pos(cPageBreakHerePossible, Command) > 0) then
              begin
                if DebugMode then
                  DebugSave('pagebreak');
                break;
              end;

              if (pos('save&delete', Command) > 0) then
              begin
                SaveDeleteBlock(nextp(OneLine, ',', 0));
                break;
              end;

              if (pos('set', Command) > 0) then
              begin
                SystemHeap.Values[nextp(OneLine, ' ')] := OneLine;
                break;
              end;

              // Kommandos können u.U. mit dem & Operator verbunden werden
              // also command='save&delete' -> also ab hier ohne break
              CommandAccepted := false;

              if (pos('load', Command) > 0) then
              begin
                LoadBlock(nextp(OneLine, ',', 0), nextp(OneLine, ',', 1));
                CommandAccepted := true;
              end;

              if (pos('write', Command) > 0) then
              begin
                LoadBlock(nextp(OneLine, ',', 0), nextp(OneLine, ',', 1), true);
                CommandAccepted := true;
              end;

              if (pos('save', Command) > 0) then
              begin
                SaveBlock(nextp(OneLine, ',', 0));
                CommandAccepted := true;
              end;

              if (pos('clear', Command) > 0) then
              begin
                ClearBlock(nextp(OneLine, ',', 0));
                CommandAccepted := true;
              end;

              if (pos('delete', Command) > 0) then
              begin
                DeleteBlock(nextp(OneLine, ',', 0));
                CommandAccepted := true;
              end;

              if (pos('dereference', Command) > 0) then
              begin
                Dereference(OneLine);
                CommandAccepted := true;
              end;

              if not(CommandAccepted) then
                addFatalError('html.Command "' + Command + '" unknown!');

            until true;
          end;
        end
        else
        begin
          if CanUseQuick then
            WriteValueQuick(nextp(OneLine, '='), OneLine)
          else
            WriteValue(nextp(OneLine, '='), OneLine);
        end;
      end;
    result := n;
  end;

  procedure WriteHeap;
  var
    n: integer;
  begin
    // alle Werte des Systemsheaps im Dokument belichten
    for n := 0 to pred(SystemHeap.count) do
    begin
      WriteValueQuick(nextp(SystemHeap[n], '=', 0),
        nextp(SystemHeap[n], '=', 1));
      WriteValueQuick('_' + nextp(SystemHeap[n], '=', 0),
        nextp(SystemHeap[n], '=', 1));
    end;
  end;

  procedure FillGlobalData;
  begin
    ExecAndFill(false, 0, MaxInt);
    WriteValue(cSeite, IntToStr(Seite));
    WriteValue(cSeiten, IntToStr(Seiten));
  end;

  function insideComment(const s: string): string;
  var
    n: integer;
  begin
    result := '';
    for n := 1 to length(s) do
      if ord(s[n]) > 127 then
        result := result + '#$' + inttohex(ord(s[n]), 2)
      else
        result := result + s[n];
    ersetze(#13, cLineSeparator, result);
    ersetze('-->', '--&gt;', result);
  end;

  procedure Compute;
  var
    OneComputeFound: boolean;
    m, n, k: integer;
    FName: string;
    PreFName: string;
    ComputeVorlage: THTMLTemplate;
  begin

    repeat

      //
      OneComputeFound := false;
      for n := 0 to pred(count) do
        if (pos(cHTML_ComputeFile, strings[n]) = 1) then
        begin
          k := pos(cHTML_Comment_PostFix, strings[n]);
          if (k > 0) then
          begin

            FName := copy(strings[n], succ(length(cHTML_ComputeFile)),
              pred(k - length(cHTML_ComputeFile)));
            PreFName := FileName + '.';
            if not(FileExists(PreFName + FName)) then
              PreFName := ExtractFilePath(FileName);
            IncludeList.add(PreFName + FName);

            ComputeVorlage := THTMLTemplate.create;
            ComputeVorlage.LoadFromFile(PreFName + FName);
            ComputeVorlage.OhneRohdaten := true;
            ComputeVorlage.WriteValue(FullPage);
            ComputeVorlage.insert(0, cHTML_BeginBlock + FName +
              cHTML_Comment_PostFix);
            ComputeVorlage.add(cHTML_EndBlock + FName + cHTML_Comment_PostFix);

            for m := 0 to pred(ComputeVorlage.count) do
              if (m = 0) then
                strings[n] := ComputeVorlage[0]
              else
                insert(n + m, ComputeVorlage[m]);
            ComputeVorlage.Free;
            OneComputeFound := true;
            break;
          end;
        end;
    until not(OneComputeFound);
  end;

begin
  if DebugMode then
  begin
    DebugSave('Init');
    AppendStringsToFile(
      { } FileName,
      { } ExtractFilePath(FileName) +
      { } 'Command.log');
  end;
  Compute;

  // Bedarf aller Seiten bestimmen
  FreiCount_Single := CalcFreiraum(cPageSingle, FreiCount_Single_Killer);
  FreiCount_First := CalcFreiraum(cPageFirst, FreiCount_First_Killer);
  FreiCount_Next := CalcFreiraum(cPageNext, FreiCount_Next_Killer);
  FreiCount_Last := CalcFreiraum(cPageLast, FreiCount_Last_Killer);

  repeat
    // a) prüfen, ob erste Seite reicht?
    if CalcBedarf(FreiCount_Single_Killer, 0) <= FreiCount_Single then
    begin
      // single page fits all!!
      Seiten := 1;
      Seite := 1;
      DeleteBlock(cPageFirst);
      DeleteBlock(cPageNext);
      DeleteBlock(cPageLast);
      ExecAndFill(true, 0, MaxInt);
      WriteValue(cSeite, IntToStr(Seite));
      WriteValue(cSeiten, IntToStr(Seiten));
      break;
    end
    else
    begin
      // erst mal alles durchrechnen
      Seiten := 2;

      CB_Producer := FreiCount_First_Killer;
      CB_LastChecked := 0;

      // erste Seite vollständig füllen!
      ActPageFilled := 0;
      repeat
        LookForwardBlock := _CBnext;
        if (LookForwardBlock = 0) then // keinerlei Bedarf mehr
          break;
        if (LookForwardBlock + ActPageFilled > FreiCount_First) and
          (ActPageFilled > 0) then // eben voll geworden
          break; // raus ohne zu füllen
        inc(ActPageFilled, CBnext);
      until false;

      // Rest auf "next" und "Last" verteilen
      // passt der Rest auf "last"?
      CB_Producer := FreiCount_Next_Killer;
      repeat
        if CalcBedarf(FreiCount_Last_Killer, CB_LastChecked) <= FreiCount_Last
        then
        begin
          // ja -> das wird die letzte Seite
          break;
        end
        else
        begin
          // nein -> "next" - Seite proforma belichten!
          inc(Seiten);
          ActPageFilled := 0;
          repeat
            LookForwardBlock := _CBnext;
            if (LookForwardBlock = 0) then
              break;
            if (LookForwardBlock + ActPageFilled > FreiCount_Next) and
              (ActPageFilled > 0) then
              break; // raus ohne zu füllen
            inc(ActPageFilled, CBnext);
          until false;
          if (LookForwardBlock = 0) then
            // ich bringe auf next nichts mehr unter ->
            // es muss sich um Daten handeln, die nur auf die
            // letzte Seite passen!
            break;
        end;
      until false;

      // must use "first" Page
      DeleteBlock(cPageSingle);

      SaveBlock(cPageNext);
      DeleteBlock(cPageNext);

      SaveBlock(cPageLast);
      DeleteBlock(cPageLast);

      // Jetzt tatsächlich ausgeben
      Seite := 1;
      CB_LastChecked := 0;
      LastExecuted := 0;
      repeat

        // Seite laden
        if (Seite > 1) then
        begin
          WriteHeap;

          if (Seite <> Seiten) then
          begin
            LoadBlock(cPageNext, 'PAGE');
            CB_Producer := FreiCount_Next_Killer;
            CB_FreiCount := FreiCount_Next;
          end
          else
          begin
            LoadBlock(cPageLast, 'PAGE');
            CB_Producer := FreiCount_Last_Killer;
            CB_FreiCount := FreiCount_Last;
          end;
        end
        else
        begin
          CB_Producer := FreiCount_First_Killer;
          CB_FreiCount := FreiCount_First;
        end;

        // globale Daten schreiben
        // rohe Blöcke vorbereiten
        FillGlobalData;

        // wie weit darf ich ausgeben?
        ActPageFilled := 0;
        repeat
          LookForwardBlock := _CBnext;
          {
            Wenn LookForwardBlock 0 ist gab es in diesem Block keine "consumer!"
            Dann suchen wir halt weiter, und geben nicht auf, wie es früher war!
            if (LookForwardBlock = 0) then
            break; // nix mehr zu tun -> raus!
          }

          //
          if // Mehr als erlaubt?
          { } (LookForwardBlock + ActPageFilled > CB_FreiCount) and
          // Zumindest ein Consumer gefunden?
          { } (ActPageFilled > 0) then
            break;
          inc(ActPageFilled, CBnext);
          if (CB_LastChecked = FullPage.count) then
            break;
        until false;

        // lokale Daten füllen
        ExecAndFill(false, max(succ(FD_local), LastExecuted), CB_LastChecked);
        LastExecuted := CB_LastChecked;

        // weiter
        inc(Seite);

      until (Seite > Seiten);

      WriteHeap;
      break; // fertig

    end;

  until false;

  // The Value Data
  if (count = 0) then
  begin
    add('<html>');
    add(HugeSingleLine(Messages, '<br>'));
    add('</html>');
  end;

  // Save raw data to the Dokument
  // imp pend: Save all the html-templates to Dokument as base64 Comment,
  // to extract the original template and with the data:
  // do a full  re-WriteValue
  if not(OhneRohdaten) then
  begin

    // Zwangszeile, wenn völlig leer
    if (count = 0) then
      add('');

    // Rohdaten an sich
    insert(count - 1, cHTML_RohdatenStart);
    for n := 0 to pred(FullPage.count) do
      insert(count - 1, insideComment(FullPage[n]));
    insert(count - 1, '-->');

    // Include File List
    insert(count - 1, cHTML_IncludesStart);
    for n := 0 to pred(IncludeList.count) do
      if TestMode then
        insert(count - 1, insideComment(ExtractFileName(IncludeList[n])))
      else
        insert(count - 1, insideComment(IncludeList[n]));
    insert(count - 1, '-->');

    // Messages
    if (Messages.count > 0) then
    begin
      insert(count - 1, cHTML_MessagesStart);
      for n := 0 to pred(Messages.count) do
        insert(count - 1, insideComment(Messages[n]));
      insert(count - 1, '-->');
    end;

  end;

end;

procedure THTMLTemplate.WriteValue(FullPageLokal, FullPageGlobal: TStrings);
var
  FullPage: TStringList;
begin
  FullPage := TStringList.create;
  FullPage.addStrings(FullPageGlobal);
  FullPage.add('local');
  FullPage.addStrings(FullPageLokal);
  if DebugMode then
    FullPage.SaveToFile(DebugLogPath + 'WriteValue.txt');
  WriteValue(FullPage);
  FullPage.Free;
end;

procedure THTMLTemplate.Write2Value(VarName, NewValue1, NewValue2: string);
var
  n, k: integer;
begin
  for n := 0 to pred(count) do
  begin
    while true do
    begin
      k := pos('~' + VarName + '~', strings[n]);
      if (k = 0) then
        break;
      strings[n] := copy(strings[n], 1, pred(k)) + Ansi2html(NewValue1) + '<br>'
        + Ansi2html(NewValue2) + copy(strings[n], k + length(VarName) +
        2, MaxInt);
    end;
  end;
end;

procedure THTMLTemplate.WriteValue(BlockName, VarName: string;
  NewValue: TStrings);
var
  n, k, l: integer;
  InsideBlock: boolean;
  SourceStr: string;
begin
  InsideBlock := false;
  for n := 0 to pred(count) do
  begin
    if InsideBlock then
    begin
      while true do
      begin
        k := pos('~' + VarName + '~', strings[n]);
        if (k = 0) then
          break;
        SourceStr := strings[n];
        delete(n);
        for l := pred(NewValue.count) downto 0 do
          insert(n, copy(SourceStr, 1, pred(k)) + Ansi2html(NewValue[l]) +
            copy(SourceStr, k + length(VarName) + 2, MaxInt));
      end;
      if pos(cHTML_EndBlock + BlockName, strings[n]) = 1 then
        InsideBlock := false;
    end
    else
    begin
      if pos(cHTML_BeginBlock + BlockName, strings[n]) = 1 then
        InsideBlock := true;
    end;
  end;
end;

// SAVE BLOCK ----------------------------------------------------------------------

procedure THTMLTemplate.SaveBlockToFile(Block, FName: string);
var
  OutStrings: TStringList;
  n: integer;
begin
  OutStrings := TStringList.create;
  for n := findBlockBegin(Block) to findBlockEnd(Block) do
    if (n <> -1) then
      OutStrings.add(strings[n]);
  OutStrings.SaveToFile(FName);
  OutStrings.Free;
end;

procedure THTMLTemplate.SaveBlockToFile(Block, NewBlock, FName: string);
var
  OutStrings: TStringList;
  n: integer;
begin
  OutStrings := TStringList.create;
  OutStrings.add(cHTML_BeginBlock + NewBlock + cHTML_Comment_PostFix);
  for n := succ(findBlockBegin(Block)) to pred(findBlockEnd(Block)) do
    OutStrings.add(strings[n]);
  OutStrings.add(cHTML_EndBlock + NewBlock + cHTML_Comment_PostFix);
  OutStrings.SaveToFile(FName);
  OutStrings.Free;
end;

// save&delete
procedure THTMLTemplate.SaveDeleteBlock(Block: string);
var
  bs, be, n, k: integer;
begin
  if DebugMode then
  begin
    AppendStringsToFile(
      { } IntToStrN(PhaseCount, 3) + ': SaveDeleteBlock(' + Block + ')',
      { } ExtractFilePath(FileName) +
      { } 'Command.log');
  end;

  bs := findBlockBegin(Block);
  be := findBlockEnd(Block);

  // save
  k := Blocks.indexof(Block);
  if (k = -1) then
    k := Blocks.AddObject(Block, TStringList.create);
  with Blocks.Objects[k] as TStringList do
  begin
    clear;
    for n := succ(bs) to pred(be) do
      add(self.strings[n]);
    if DebugMode then
    begin
      SaveToFile(
        { } ExtractFilePath(FileName) +
        { } 'Block-' + IntToStrN(PhaseCount, 3) +
        { } '-' + Block + '.ml');
      inc(PhaseCount);
    end;
  end;

  // delete
  if (bs >= 0) and (be >= 0) then
    for n := be downto bs do
      delete(n);
end;

procedure THTMLTemplate.SaveBlock(Block, AsBlock: string);
begin
  SaveBlock(Block, '', AsBlock);
end;

procedure THTMLTemplate.SaveBlock(Block, NewBlock, AsBlock: string);
var
  n, k: integer;
begin
  k := Blocks.indexof(AsBlock);
  if (k = -1) then
    k := Blocks.AddObject(AsBlock, TStringList.create);
  with Blocks.Objects[k] as TStringList do
  begin
    clear;
    if (NewBlock <> '') then
      add(cHTML_BeginBlock + NewBlock + cHTML_Comment_PostFix);
    for n := succ(findBlockBegin(Block)) to pred(findBlockEnd(Block)) do
      add(self.strings[n]);
    if (NewBlock <> '') then
      add(cHTML_EndBlock + NewBlock + cHTML_Comment_PostFix);
    if DebugMode then
    begin
      AppendStringsToFile(
        { } IntToStrN(PhaseCount, 3) + ': saveBlock(' + AsBlock + ')',
        { } ExtractFilePath(FileName) +
        { } 'Command.log');
      SaveToFile(
        { } ExtractFilePath(FileName) +
        { } 'Block-' + IntToStrN(PhaseCount, 3) +
        { } '-' + AsBlock + '.ml');
      inc(PhaseCount);
    end;
  end;
end;

procedure THTMLTemplate.SaveBlock(Block: string);
begin
  SaveBlock(Block, Block);
end;

// LOAD BLOCKs ----------------------------------------------------------------------

procedure THTMLTemplate.LoadBlock(atIndex: integer; NewStrings: TStrings);
var
  n: integer;
begin
  _BlockStart := min(atIndex, count - 1);
  _BlockEnd := pred(_BlockStart + NewStrings.count);

  for n := 0 to pred(NewStrings.count) do
    insert(_BlockStart + n, NewStrings[n]);
end;

procedure THTMLTemplate.LoadBlock(FromBlock, AsBlock: string;
  KillInsertMark: boolean = false);
var
  k: integer;
begin
  if (FromBlock = '') then
    FromBlock := AsBlock;
  // Suche Block, den man einfügen muss
  k := Blocks.indexof(FromBlock);
  if (k <> -1) then
  begin
    if DebugMode then
      AppendStringsToFile(
        { } IntToStrN(PhaseCount, 3) + ': loadBlock(' + FromBlock + ')',
        { } ExtractFilePath(FileName) +
        { } 'Command.log');
    LoadBlock(FromBlock, AsBlock, TStringList(Blocks.Objects[k]),
      KillInsertMark);
  end
  else
  begin
    addFatalError('html.Block "' + FromBlock + '" nicht gefunden!');
  end;
end;

procedure THTMLTemplate.LoadBlock(FromBlock, AsBlock: string;
  NewStrings: TStrings; KillInsertMark: boolean = false);
var
  InsertAt: integer;
begin
  InsertAt := -1;
  if (FromBlock = '') then
    FromBlock := AsBlock;

  // Einfügeposition bestimmen
  repeat

    // 1. Rang
    if (AsBlock <> '') then
    begin
      InsertAt := findInsertMark(AsBlock);
      if InsertAt >= 0 then
        break;
    end;

    // 2. Rang
    if (FromBlock <> '') and (FromBlock <> AsBlock) then
    begin
      InsertAt := findInsertMark(FromBlock);
      if InsertAt >= 0 then
        break;
    end;

    // 3. Rang
    if (FromBlock <> '') then
    begin
      InsertAt := findBlockEnd(FromBlock);
      if (InsertAt >= 0) then
        break;
    end;

    // Fehler!
    addFatalError('"[!-- INSERT|END ' + FromBlock + '|' + AsBlock +
      ' --]" nicht gefunden!');

  until true;

  // Gefundene Marke löschen?!
  if KillInsertMark then
    if (InsertAt <> -1) then
      delete(InsertAt);

  // Daten laden
  if (InsertAt <> -1) then
    LoadBlock(InsertAt, NewStrings)
end;

procedure THTMLTemplate.LoadBlock(Block: string; NewStrings: TStrings;
  KillInsertMark: boolean = false);
begin
  LoadBlock(Block, '', NewStrings, KillInsertMark);
end;

procedure THTMLTemplate.LoadBlock(Block: string);
begin
  LoadBlock(Block, '');
end;

procedure THTMLTemplate.LoadBlockFromFile(Block, FName: string);
var
  NewStrings: TStringList;
begin
  NewStrings := TStringList.create;
  NewStrings.LoadFromFile(FName);
  LoadBlock(Block, '', NewStrings);
  NewStrings.Free;
end;

// WriteValue

procedure THTMLTemplate.WriteValue;
begin
  DatenSammlerGlobal.add('local');
  DatenSammlerGlobal.addStrings(DatenSammlerLocal);
  WriteValue(DatenSammlerGlobal);
end;

procedure THTMLTemplate.WriteLocal(OneLine: string);
begin
  DatenSammlerLocal.add(OneLine);
end;

procedure THTMLTemplate.WriteGlobal(OneLine: string);
begin
  DatenSammlerGlobal.add(OneLine);
end;

// ------------------------------------------------------------------------------

function THTMLTemplate.findBlockBegin(Block: string): integer;
var
  n: integer;
begin
  result := -1;
  for n := 0 to pred(count) do
    if pos(cHTML_BeginBlock + Block + cHTML_Comment_PostFix, strings[n]) = 1
    then
    begin
      result := n;
      break;
    end;
end;

function THTMLTemplate.findBlockEnd(Block: string): integer;
var
  n: integer;
begin
  result := -1;
  for n := pred(count) downto 0 do
    if pos(cHTML_EndBlock + Block + cHTML_Comment_PostFix, strings[n]) = 1 then
    begin
      result := n;
      break;
    end;
end;

procedure THTMLTemplate.ClearBlock(Block: string);
var
  n: integer;
begin
  for n := pred(findBlockEnd(Block)) downto succ(findBlockBegin(Block)) do
    delete(n);
end;

procedure THTMLTemplate.SaveToFileCompressed(FName: string);
var
  OutS: TStringList;
  n: integer;
  DeleteLine: boolean;
  LineBuffer: string;
  LineBufferCollector: boolean;
begin
  OutS := TStringList.create;
  OutS.assign(self);

  //
  LineBufferCollector := false;
  for n := pred(OutS.count) downto 0 do
  begin
    if AnsiAusgabe then
    begin
      // Kommentare
      DeleteLine := (pos('<!--', OutS[n]) = 1) and (pos('-->', OutS[n]) > 1);
      if DeleteLine then
        OutS.delete(n)
      else
      begin
        OutS[n] := html2Ansi(OutS[n]);
        // die nonbreakables durch "normale" Blanks ersetzten
        ersetze(#160, #32, OutS, n);
        // auch das Euro-Symbol ist in der eMail-Zeichsatz-Welt unbekannt
        ersetze('€', 'EUR', OutS, n);
      end;
    end
    else
    begin
      DeleteLine := OutS[n] = '';

      if not(DeleteLine) then
        DeleteLine := (pos('<!--', OutS[n]) = 1) and (pos('-->', OutS[n]) > 1);

      if not(DeleteLine) then
        if pos('</line>', OutS[n]) > 0 then
        begin
          DeleteLine := true;
          LineBufferCollector := true;
          LineBuffer := '</line>';
        end;

      if not(DeleteLine) then
        if (pos('<line>', OutS[n]) > 0) then
        begin
          OutS[n] := '<line>' + LineBuffer;
          LineBufferCollector := false;
        end;

      if LineBufferCollector and not(DeleteLine) then
        LineBuffer := cutblank(OutS[n]) + LineBuffer;

      if DeleteLine or LineBufferCollector then
        OutS.delete(n);

    end;
  end;
{$IFDEF SUPPORTS_UNICODE}
  if forceUTF8 then
    OutS.SaveToFile(FName, TEncoding.UTF8)
  else
    OutS.SaveToFile(FName);
{$ELSE}
  OutS.SaveToFile(FName);
{$ENDIF}
  if Diagnose.count > 0 then
    Diagnose.SaveToFile(ExtractFilePath(FName) + 'html-Diagnose.txt');

  OutS.Free;
end;

procedure THTMLTemplate.setDatesFromFile(FName: string);
var
  n, l: integer;
  NewStrings: TStringList;
  DatumBlock: string;
begin
  NewStrings := TStringList.create;
  NewStrings.LoadFromFile(FName);
  DateA := cIllegalDate;
  DateB := cIllegalDate;
  for n := 0 to pred(NewStrings.count) do
  begin
    if (DateA = cIllegalDate) then
    begin
      l := pos(' Rev ', NewStrings[n]);
      if (l > 0) then
      begin
        DatumBlock := ExtractSegmentBetween(copy(NewStrings[n], l + 4, MaxInt),
          '(', ')');
        if DatumBlock <> '' then
        begin
          if pos('-', DatumBlock) > 0 then
          begin
            DateA := date2long(nextp(DatumBlock, '-', 0));
            DateB := date2long(nextp(DatumBlock, '-', 1));
          end
          else
          begin
            DateA := date2long(DatumBlock);
            DateB := DateA;
          end;
        end;
      end;
    end;
  end;
  NewStrings.Free;
end;

function THTMLTemplate.findInsertMark(Block: string): integer;
var
  n: integer;
  FindStr: string;
begin
  result := -1;
  FindStr := cHTML_InsertMark + Block + cHTML_Comment_PostFix;
  for n := pred(count) downto 0 do
    if pos(FindStr, strings[n]) = 1 then
    begin
      result := n;
      break;
    end;
end;

(*
  procedure THTMLTemplate.DuplicateBlock(Block : string);
  var
  n,m,k : integer;
  begin
  n := BlockStart(Block);
  m := BlockEnd(Block);
  for k := 0 to m-n do
  insert(succ(m+k),strings[n+k]);
  end;
*)

function HTMLColor2RGBConst(Value: string): string;
begin
  result := format('$%x', [HTMLColor2TColor(Value)]);
end;

function HTMLColor2RGBConst(Value: integer): string;
begin
  result := format('$%x', [HTMLColor2TColor(Value)]);
end;

const
  cHTMLCodes: array [0 .. 256] of String = (#000 (* - *) , #001
    (* - *) , #002 (* - *) , #003 (* - *) , #004 (* - *) , #005 (* - *) , #006
    (* - *) , #007 (* - *) , #008 (* - *) , #009 (* - *) , #010 (* - *) , #011
    (* - *) , #012 (* - *) , '<br>' (* #13 *) , #014 (* - *) , #015
    (* - *) , #016 (* - *) , #017 (* - *) , #018 (* - *) , #019 (* - *) , #020
    (* - *) , #021 (* - *) , #022 (* - *) , #023 (* - *) , #024 (* - *) , #025
    (* - *) , #026 (* - *) , #027 (* - *) , #028 (* - *) , #029 (* - *) , #030
    (* - *) , #031 (* - *) , #032 (* *) , #033 (* ! *) , '&quot;'
    (* " *) , #035 (* # *) , #036 (* $ *) , #037 (* % *) , '&amp;'
    (* & *) , #039 (* ' *) , #040 (* ( *) , #041 (* ) *) , #042 (* * *) , #043
    (* + *) , #044 (* , *) , #045 (* - *) , #046 (* . *) , #047 (* / *) , #048
    (* 0 *) , #049 (* 1 *) , #050 (* 2 *) , #051 (* 3 *) , #052 (* 4 *) , #053
    (* 5 *) , #054 (* 6 *) , #055 (* 7 *) , #056 (* 8 *) , #057 (* 9 *) , #058
    (* : *) , #059 (* ; *) , '&lt;' (* < *) , #061 (* = *) , '&gt;'
    (* > *) , #063 (* ? *) , #064 (* @ *) , #065 (* A *) , #066 (* B *) , #067
    (* C *) , #068 (* D *) , #069 (* E *) , #070 (* F *) , #071 (* G *) , #072
    (* H *) , #073 (* I *) , #074 (* J *) , #075 (* K *) , #076 (* L *) , #077
    (* M *) , #078 (* N *) , #079 (* O *) , #080 (* P *) , #081 (* Q *) , #082
    (* R *) , #083 (* S *) , #084 (* T *) , #085 (* U *) , #086 (* V *) , #087
    (* W *) , #088 (* X *) , #089 (* Y *) , #090 (* Z *) , #091 (* [ *) , #092
    (* \ *) , #093 (* ] *) , #094 (* ^ *) , #095 (* _ *) , #096 (* ` *) , #097
    (* a *) , #098 (* b *) , #099 (* c *) , #100 (* d *) , #101 (* e *) , #102
    (* f *) , #103 (* g *) , #104 (* h *) , #105 (* i *) , #106 (* j *) , #107
    (* k *) , #108 (* l *) , #109 (* m *) , #110 (* n *) , #111 (* o *) , #112
    (* p *) , #113 (* q *) , #114 (* r *) , #115 (* s *) , #116 (* t *) , #117
    (* u *) , #118 (* v *) , #119 (* w *) , #120 (* x *) , #121 (* y *) , #122
    (* z *) , #123 (* { *) , #124 (* | *) , #125 (* } *) , #126 (* ~ *) , #127
    (*  *) , '&euro;' (* € *) , #129 (*  *) , #130 (* ‚ *) , #131
    (* ƒ *) , '&quot;' (* „ *) , #133 (* … *) , #134 (* † *) , #135
    (* ‡ *) , #136 (* ˆ *) , #137 (* ‰ *) , #138 (* Š *) , #139 (* ‹ *) , #140
    (* Œ *) , #141 (*  *) , #142 (* Ž *) , #143 (*  *) , #144 (*  *) , #145
    (* ‘ *) , #146 (* ’ *) , '&quot;' (* “ *) , '&quot;' (* ” *) , #149
    (* • *) , '&mdash;' (* – *) , #151 (* — *) , #152 (* ˜ *) , '&trade;'
    (* ™ *) , #154 (* š *) , #155 (* › *) , #156 (* œ *) , #157
    (*  *) , #158 (* ž *) , #159 (* Ÿ *) , '&nbsp;' (* *) , #161
    (* ¡ *) , #162 (* ¢ *) , #163 (* £ *) , #164 (* ¤ *) , #165 (* ¥ *) , #166
    (* ¦ *) , #167 (* § *) , #168 (* ¨ *) , '&copy;' (* © *) , #170
    (* ª *) , '&quot;' (* « *) , #172 (* ¬ *) , '&shy;' (* ­ *) , '&reg;'
    (* ® *) , #175 (* ¯ *) , #176 (* ° *) , #177 (* ± *) , #178
    (* ² *) , #179 (* ³ *) , '&acute;' (* ´ *) , #181 (* µ *) , #182
    (* ¶ *) , #183 (* · *) , #184 (* ¸ *) , #185 (* ¹ *) , #186
    (* º *) , '&quot;' (* » *) , #188 (* ¼ *) , #189 (* ½ *) , #190
    (* ¾ *) , #191 (* ¿ *) , '&Agrave;' (* À *) , '&Aacute;'
    (* Á *) , '&Acirc;' (* Â *) , '&Atilde;' (* Ã *) , '&Auml;'
    (* Ä *) , '&Aring;' (* Å *) , '&AElig;' (* Æ *) , '&Ccedil;'
    (* Ç *) , '&Egrave;' (* È *) , '&Eacute;' (* É *) , '&Ecirc;'
    (* Ê *) , '&Euml;' (* Ë *) , '&Igrave;' (* Ì *) , '&Iacute;'
    (* Í *) , '&Icirc;' (* Î *) , '&Iuml;' (* Ï *) , '&ETH;'
    (* Ð *) , '&Ntilde;' (* Ñ *) , '&Ograve;' (* Ò *) , '&Oacute;'
    (* Ó *) , '&Ocirc;' (* Ô *) , '&Otilde;' (* Õ *) , '&Ouml;' (* Ö *) , #215
    (* × *) , '&Oslash;' (* Ø *) , '&Ugrave;' (* Ù *) , '&Uacute;'
    (* Ú *) , '&Ucirc;' (* Û *) , '&Uuml;' (* Ü *) , '&Yacute;'
    (* Ý *) , '&THORN;' (* Þ *) , '&szlig;' (* ß *) , '&agrave;'
    (* à *) , '&aacute;' (* á *) , '&acirc;' (* â *) , '&atilde;'
    (* ã *) , '&auml;' (* ä *) , '&aring;' (* å *) , '&aelig;'
    (* æ *) , '&ccedil;' (* ç *) , '&egrave;' (* è *) , '&eacute;'
    (* é *) , '&ecirc;' (* ê *) , '&euml;' (* ë *) , '&igrave;'
    (* ì *) , '&iacute;' (* í *) , '&icirc;' (* î *) , '&iuml;'
    (* ï *) , '&eth;' (* ð *) , '&ntilde;' (* ñ *) , '&oacute;'
    (* ò *) , '&ograve;' (* ó *) , '&ocirc;' (* ô *) , '&otilde;'
    (* õ *) , '&ouml;' (* ö *) , #247 (* ÷ *) , '&oslash;'
    (* ø *) , '&ugrave;' (* ù *) , '&uacute;' (* ú *) , '&ucirc;'
    (* û *) , '&uuml;' (* ü *) , '&yacute;' (* ý *) , '&thorn;'
    (* þ *) , '&yuml;' (* ÿ *) , '');

function Ansi2html(s: AnsiString): string;
var
  n: integer;
begin

  repeat

    // Unverändert lassen?
    if (length(s) > 0) then
      if (s[1] = cRawHTMLPrefix) then
      begin
        result := copy(s, 2, MaxInt);
        break;
      end;

    // führende (=zwingende) Blanks!
    for n := 1 to length(s) do
      if (s[n] = ' ') then
        s[n] := cNonBreakableSpace
      else
        break;

    // ersetze Zwischenräume, bei Doppelblanks zu vermuten
    ersetze('  ', cNonBreakableSpace + cNonBreakableSpace, s);

    // jetzt umsetzen!, Wegen dieser Umsetzung muss S ein AnsiString sein!
    result := '';
    for n := 1 to length(s) do
      result := result + cHTMLCodes[ord(s[n])];

  until true;

end;

function AnsiToRFC1738(s: string): string;
var
  n: integer;
begin
  result := '';
  for n := 1 to length(s) do
    if CharInSet(s[n], ['-', '.', ',', '?', ':', '&', '@', '=', ';', '/', '_',
      '0' .. '9', 'a' .. 'z', 'A' .. 'Z']) then
      result := result + s[n]
    else
      result := result + '%' + format('%2x', [ord(s[n])]);
end;

function RFC1738ToAnsi(s: string): string;
var
  k: integer;
begin
  result := s;
  repeat
    k := pos('%', result);
    if (k = 0) then
      break;
    result := copy(result, 1, pred(k)) +
      chr(strtoint('$' + copy(result, k + 1, 2))) + copy(result, k + 3, MaxInt);
  until false;
end;

procedure THTMLTemplate.DeleteBlock(Block: string);
var
  bs, be, n: integer;
begin
  if DebugMode then
  begin
    AppendStringsToFile(
      { } IntToStrN(PhaseCount, 3) + ': deleteBlock(' + Block + ')',
      { } ExtractFilePath(FileName) +
      { } 'Command.log');
  end;
  bs := findBlockBegin(Block);
  be := findBlockEnd(Block);
  if (bs >= 0) and (be >= 0) then
    for n := be downto bs do
      delete(n);
end;

procedure THTMLTemplate.Dereference(Options: string);
var
  iStart, iEnd: integer;
  sXML: TStringStream;
  XML: TJclSimpleXML;

  // Parameter
  pFName: string;
  pKeyPrefix, pKeyPostfix: string;
  pKeyNumeric, pKeyUtf8: boolean;
  pKeyBegin, pKeyEnd: string;

  function blow(Tag: string): string;
  var
    i: TJclSimpleXMLElem;
    FoundTags: string;
    cTag: string;
    k: integer;

  begin
    i := XML.Root;
    FoundTags := 'root';
    repeat
      cTag := nextp(Tag, '.');
      if (cTag <> '') then
        i := i.items.ItemNamed[cTag];
      if not(assigned(i)) then
      begin
        result := '<!-- Element <' + cTag + '> in ' + FoundTags +
          ' not found! -->';
        break;
      end;

      if (Tag = '') then
      begin

        // Suche Beendet, das Ergebnis ist der String
        result := i.SaveToString;

        // entferne den künstlich Zugefügten #0d#0a am Ende
        k := revpos(sLineBreak, result);
        if (k > 0) then
          if (k = succ(length(result) - length(sLineBreak))) then
            result := copy(result, 1, pred(k));

        break;
      end;

      if (Tag = 'value') then
      begin
        result := i.Value;
        break;
      end;

      if (Tag[1] = '#') then
      begin
        result := i.Properties.ItemNamed[copy(Tag, 2, MaxInt)].Value;
        break;
      end;

      FoundTags := FoundTags + '.' + cTag;

    until false;
  end;

var
  n, k, l: integer;
  Automatastate: integer;
  Key, Tag: string;

begin

  // Parameter einlesen!
  pFName := SystemHeap.Values[cSet_Quelle];
  pKeyPrefix := SystemHeap.Values[cSet_KeyPrefix];
  if pKeyPrefix = '' then
    pKeyPrefix := '<Serialnummer>';
  pKeyPostfix := SystemHeap.Values[cSet_KeyPostfix];
  if pKeyPostfix = '' then
    pKeyPostfix := '</Serialnummer>';
  pKeyNumeric := (SystemHeap.Values[cSet_KeyNumeric] <> 'NEIN');
  pKeyBegin := SystemHeap.Values[cSet_KeyBegin];
  if pKeyBegin = '' then
    pKeyBegin := '<Auftrag Vorgangsnummer=';
  pKeyEnd := SystemHeap.Values[cSet_KeyEnd];
  if pKeyEnd = '' then
    pKeyEnd := '</Auftrag>';
  pKeyUtf8 := (SystemHeap.Values[cSet_KeyUTF8] <> 'NEIN');

  if (pFName <> '') then
  begin

    if (pFName <> _Reference) then
    begin
      if not(FileExists(pFName)) then
      begin
        if TestMode then
          addFatalError('Referenzquelle "' + ExtractFileName(pFName) +
            '" nicht gefunden')
        else
          addFatalError('Referenzquelle "' + pFName + '" nicht gefunden');

        exit;
      end;
      Reference.LoadFromFile(pFName);
      _Reference := pFName;
    end;

    Key := SystemHeap.Values[cSet_Key];
    if pKeyNumeric then
      Key := StrFilter(Key, cZiffern)
    else
      Key := fill('0', 14 - length(Key)) + Key;

    Key := pKeyPrefix + Key + pKeyPostfix;

    // Erst mal den Abschnitt bestimmen der relevant ist
    iStart := -1;
    iEnd := -1;
    Automatastate := 0;
    for n := 0 to pred(Reference.count) do
      case Automatastate of
        0:
          // search for start tag
          begin
            if pos(pKeyBegin, Reference[n]) > 0 then
            begin
              iStart := n;
              iEnd := -1;
              Automatastate := 1;
            end;
          end;
        1:
          // search for "Blockend" or "correct" key
          begin
            if pos(pKeyEnd, Reference[n]) > 0 then
            begin
              Automatastate := 0;
            end;
            if pos(Key, Reference[n]) > 0 then
            begin
              Automatastate := 2;
            end;
          end;
        2: // correct Key already found! search for "BlockEnd"
          begin
            if pos(pKeyEnd, Reference[n]) > 0 then
            begin
              iEnd := n;
              break;
            end;

          end;
      end;

    // Found!
    if (iStart < iEnd) then
    begin

{$IFNDEF FPC}
      sXML := TStringStream.create;
      XML := TJclSimpleXML.create;
      try
        for n := iStart to iEnd do
          sXML.WriteString(Reference[n]);
        sXML.seek(0, soBeginning);
        XML.Options := XML.Options - [sxoAutoEncodeValue];
        if pKeyUtf8 then
          XML.LoadFromStream(sXML, seUTF8, CP_UTF8)
        else
          XML.LoadFromStream(sXML);

      except
        on e: exception do
        begin
          addFatalError(e.Message);
          for n := iStart to iEnd do
            Messages.add(Reference[n]);
        end;
      end;
      sXML.Free;
{$ENDIF}
      // Erfolg! nun ist klar, in welchem Block gesucht werden muss
      n := 0;
      repeat
        if (n >= count) then
          break;

        k := pos(cReferenceDelimiterBegin, strings[n]);
        if k = 0 then
        begin
          inc(n);
          continue;
        end;

        l := pos(cReferenceDelimiterEnd, strings[n]);
        if (l = 0) or (l < k + length(cReferenceDelimiterBegin)) then
        begin
          // ERROR:
          addFatalError(' "~(" gefunden aber ")~" fehlt');
          inc(n);
          continue;
        end;

        Tag := copy(strings[n], k + length(cReferenceDelimiterBegin),
          l - k - length(cReferenceDelimiterBegin));
        if Tag = '' then
        begin
          inc(n);
          continue;
        end;

        strings[n] :=
        { } copy(strings[n], 1, pred(k)) +
        { } blow(Tag) +
        { } copy(strings[n], l + length(cReferenceDelimiterEnd), MaxInt);

      until false;
      XML.Free;

    end
    else
    begin
      addFatalError('"' + Key + '" in Datei "' + pFName + '" nicht gefunden');
    end;
  end;
end;

constructor THTMLTemplate.create;
begin
  inherited;
  Blocks := TStringList.create;
  Blocks.casesensitive := true;
  DatenSammlerLocal := TStringList.create;
  DatenSammlerGlobal := TStringList.create;
  SystemHeap := TStringList.create;
  InputForms := TStringList.create;
  InputActions := TStringList.create;
  IncludeList := TStringList.create;
  Diagnose := TStringList.create;
  Reference := TStringList.create;
  Messages := TStringList.create;
end;

destructor THTMLTemplate.Destroy;
var
  n: integer;
begin
  for n := 0 to pred(Blocks.count) do
    Blocks.Objects[n].Free;
  Blocks.Free;
  DatenSammlerLocal.Free;
  DatenSammlerGlobal.Free;
  SystemHeap.Free;
  InputForms.Free;
  InputActions.Free;
  IncludeList.Free;
  Diagnose.Free;
  Reference.Free;
  Messages.Free;
  inherited;
end;

procedure THTMLTemplate.WritePageBreak;
begin
  DatenSammlerLocal.add(cPageBreakHerePossible);
end;

var
  cHTMLAnsiTab: TStringList;

function html2Ansi(x: string): string;
var
  n: integer;
  k, l: integer;
  fromS: string;
  c: AnsiChar;
begin
  result := x;
  if pos('&', result) > 0 then
  begin
    for n := 0 to pred(cHTMLAnsiTab.count) do
      while pos(cHTMLAnsiTab[n], result) > 0 do
      begin
        c := AnsiChar(cHTMLAnsiTab.Objects[n]);
        ersetze(cHTMLAnsiTab[n], c, result);
        if pos('&', result) = 0 then
          break;
      end;
  end;
  repeat
    k := pos('&#', result);
    if (k = 0) then
      break;
    fromS := copy(result, k, MaxInt);
    l := pos(';', fromS);
    if (l = 0) or (l > 6) then
      break;
    ersetze(copy(result, k, l), chr(StrtoIntDef(copy(result, k + 2, l - 3),
      ord('?'))), result);
  until false;
end;

procedure THTMLTemplate.LoadFromFile(const FileName: string);
var
  n, m, k: integer;
  IncludeS: TStringList;
  //
  PreFName: string;
  IncludeFName: string;
begin
  AnsiAusgabe := false;
  self.FileName := FileName;
  inherited LoadFromFile(FileName);
  IncludeList.clear;
  IncludeList.add(FileName);
  // blow up with "INCLUDEs", may be nested!
  IncludeS := nil;
  n := 0;
  repeat
    if (n >= pred(count)) then
      break;
    if (pos(cHTML_ANSI, strings[n]) = 1) then
    begin
      AnsiAusgabe := true;
      OhneRohdaten := true;
    end;
    if (pos(cHTML_OHNE_ROHDATEN, strings[n]) = 1) then
    begin
      OhneRohdaten := true;
    end;

    if (pos(cHTML_IncludeFile, strings[n]) = 1) then
    begin
      k := pos(cHTML_Comment_PostFix, strings[n]);
      if (k > 0) then
      begin
        if not(assigned(IncludeS)) then
          IncludeS := TStringList.create;
        IncludeFName := copy(strings[n], succ(length(cHTML_IncludeFile)),
          pred(k - length(cHTML_IncludeFile)));
        PreFName := FileName + '.';
        if not(FileExists(PreFName + IncludeFName)) then
          PreFName := ExtractFilePath(FileName);
        IncludeS.LoadFromFile(PreFName + IncludeFName);
        IncludeList.add(PreFName + IncludeFName);

        for m := 0 to pred(IncludeS.count) do
          if (m = 0) then
            strings[n] := IncludeS[0]
          else
            insert(n + m, IncludeS[m]);
      end;
    end;
    inc(n);
  until false;
  if assigned(IncludeS) then
    IncludeS.Free;
end;

//
// imp pend: Seiten, denen KEIN Sortierbegriff zugeordnet wurde?
// -> BREAK
//

procedure THTMLTemplate.SortPages;
var
  ClientSorter: TStringList;
  BodyStart, BodyEnd: integer;
  n, m: integer;
  State: integer;
  ActPage: TPageBlock;
  NewOrder: TStringList;
  NewLine: string;

  DokumentNumberOfCopies: integer;
  InsertPos: integer;
begin

  //
  State := 0;
  ActPage := nil;
  BodyStart := 0;
  BodyEnd := 0;
  DokumentNumberOfCopies := 1;

  ClientSorter := TStringList.create;
  for n := 0 to pred(count) do
  begin
    case State of
      0:
        begin

          //
          if (pos(cHTML_Copies, strings[n]) = 1) then
          begin
            DokumentNumberOfCopies :=
              StrtoIntDef(nextp(copy(strings[n], length(cHTML_Copies) + 1,
              MaxInt), ' ', 0), 0);
            continue;
          end;

          // Suche des Anfangs
          if (pos('<body', strings[n]) = 1) then
          begin
            BodyStart := n;

            ActPage := TPageBlock.create;
            ActPage.StartPage := succ(n);

            inc(State);
          end;

        end;
      1:
        begin

          //
          if (pos('class="breakhere">', strings[n]) > 0) then
          begin
            ActPage.EndPage := n;
            ClientSorter.AddObject(ActPage.SortStr, ActPage);

            ActPage := TPageBlock.create;
            ActPage.StartPage := succ(n);

            continue;
          end;

          //
          if (pos('</body', strings[n]) = 1) then
          begin
            ActPage.EndPage := pred(n);
            ClientSorter.AddObject(ActPage.SortStr, ActPage);

            BodyEnd := n;
            break;
          end;

          //
          if (pos(cHTML_SortInfo, strings[n]) = 1) then
          begin
            ActPage.SortStr := copy(strings[n], length(cHTML_SortInfo), MaxInt);
            continue;
          end;

        end;
    end;

  end;

  // compress, Seiten ohne Sortierbegriff fliegen raus!
  with ClientSorter do
    for n := pred(count) downto 0 do
      if strings[n] = '' then
      begin
        Objects[n].Free;
        delete(n);
      end;

  if (ClientSorter.count > 0) then
  begin
    // Überhaupt etwas zu sortieren?!

    ClientSorter.sort;
    NewOrder := TStringList.create;

    // Header
    for n := 0 to BodyStart do
      NewOrder.add(strings[n]);

    // letzte Seite, letzten formfeed wegmachen!
    with ClientSorter.Objects[pred(ClientSorter.count)] as TPageBlock do
    begin
      //
      if (pos('class="breakhere">', strings[EndPage]) > 0) then
        dec(EndPage);
    end;

    // Body
    for n := 0 to pred(ClientSorter.count) do
      with ClientSorter.Objects[n] as TPageBlock do
        for m := StartPage to EndPage do
        begin
          NewLine := strings[m];
          ersetze('~Seite~', IntToStr(succ(n)), NewLine);
          ersetze('~Seiten~', IntToStr(ClientSorter.count), NewLine);
          NewOrder.add(NewLine);
        end;

    // Footer
    for n := BodyEnd to pred(count) do
      NewOrder.add(strings[n]);

    //
    assign(NewOrder);
    NewOrder.Free;
  end;

  if (DokumentNumberOfCopies <> 1) and (BodyStart <> 0) and (BodyEnd <> 0) then
  begin
    InsertPos := BodyEnd;
    for m := 2 to DokumentNumberOfCopies do
    begin
      for n := pred(BodyEnd) downto succ(BodyStart) do
        insert(InsertPos, strings[n]);
      insert(InsertPos, cHTML_FormFeed);

      inc(InsertPos, BodyEnd - BodyStart);
    end;

  end;

  //
  for n := 0 to pred(ClientSorter.count) do
    ClientSorter.Objects[n].Free;

  ClientSorter.Free;
end;

procedure THTMLTemplate.Parse;

// tag
// attribute
// attribute-values
var
  Pline: integer;

  function ReadAttrValue(AttributeName: string): string;
  var
    k, m: integer;
  begin
    k := pos(AttributeName + '=', strings[Pline]);
    if k <> 0 then
    begin
      result := copy(strings[Pline], succ(k + length(AttributeName)), MaxInt);

      k := pos(' ', result);
      m := pos('>', result);
      if (k <> 0) and (m <> 0) then
        k := min(k, m)
      else
        k := max(k, m);

      result := copy(result, 1, pred(k));
      ersetze('"', '', result);
    end
    else
      result := '';
  end;

var
  MachineState: integer;
  k: integer;
  SingleForm: TStringList;

begin
  ClearForms;
  Pline := 0;
  MachineState := 0;
  SingleForm := nil;
  repeat
    if (Pline >= count) then
      break;
    case MachineState of
      0:
        begin

          // search for "<body"
          k := max(pos('<body ', strings[Pline]),
            pos('</head>', strings[Pline]));
          if (k > 0) then
            inc(MachineState);
        end;
      1:
        begin

          // search for "<form"
          k := pos('<form ', strings[Pline]);
          if (k > 0) then
          begin
            SingleForm := TStringList.create;
            InputForms.AddObject(ReadAttrValue('name'), SingleForm);
            InputActions.add(ReadAttrValue('action'));
            inc(MachineState);
          end;

        end;
      2:
        begin
          repeat

            //
            k := pos('</form>', strings[Pline]);
            if (k > 0) then
            begin
              dec(MachineState);
              break;
            end;

            if not(assigned(SingleForm)) then
              break;

            //
            k := pos('<input ', strings[Pline]);
            if (k > 0) then
            begin
              // name und value
              SingleForm.add(ReadAttrValue('name') + '=' +
                ReadAttrValue('value'));
              break;
            end;

            k := pos('<textarea ', strings[Pline]);
            if (k > 0) then
            begin
              // name und value
              SingleForm.add(ReadAttrValue('name') + '=');
              break;
            end;

          until true;
        end;

    end;
    if pos('</body>', strings[Pline]) > 0 then
      break;
    inc(Pline);
  until false;
  CountForms := InputForms.count;
end;

procedure THTMLTemplate.ClearForms;
var
  n: integer;
begin
  with InputForms do
  begin
    for n := 0 to pred(count) do
      Objects[n].Free;
    clear;
  end;
  InputActions.clear;
  CountForms := 0;
end;

function THTMLTemplate.GetForm(FormName: string): TStringList;
var
  k: integer;
begin
  if ((FormName = '') or (FormName = '*')) and (InputForms.count > 0) then
  begin
    result := TStringList(InputForms.Objects[0]);
  end
  else
  begin
    k := InputForms.indexof(FormName);
    if (k <> -1) then
      result := TStringList(InputForms.Objects[k])
    else
      result := nil;
  end;
end;

function THTMLTemplate.GetForm(index: integer): TStringList;
begin
  if index < InputForms.count then
    result := TStringList(InputForms.Objects[index])
  else
    result := nil;
end;

function THTMLTemplate.GetFormName(index: integer): string;
begin
  if index < InputForms.count then
    result := InputForms.strings[index]
  else
    result := '';
end;

function THTMLTemplate.GetFormAction(FormName: string): string;
var
  k: integer;
begin
  if ((FormName = '') or (FormName = '*')) and (InputForms.count > 0) then
  begin
    result := InputActions[0];
  end
  else
  begin
    k := InputForms.indexof(FormName);
    if (k <> -1) then
      result := InputActions[k]
    else
      result := '';
  end;
end;

// 28.09.2004 Thorsten Schroff

function THTMLTemplate.GetFormAction(index: integer): string;
begin
  if index < InputForms.count then
    result := InputActions[index]
  else
    result := '';
end;

// 16.08.2004 Thorsten Schroff

function THTMLTemplate.GetFormQuery(FormName: string): string;
var
  TheAttributes: TStringList;
  AttribVal: string;
  ValCount: integer;
  n: integer;
begin
  ValCount := 0;
  TheAttributes := GetForm(FormName);
  for n := 0 to pred(TheAttributes.count) do
  begin
    AttribVal := nextp(TheAttributes[n], '=', 1);
    if (AttribVal <> '') then
    begin
      if (ValCount > 0) then
        result := result + '&';
      result := result + nextp(TheAttributes[n], '=', 0) + '=' +
        AnsiToRFC1738(nextp(TheAttributes[n], '=', 1));

      // k := pos('=',TheAttributes[n]);
      // result := result + nextp(TheAttributes[n], '=', 0) + '=' + rfc1738(copy(TheAttributes[n],k+1,MaxInt));
      inc(ValCount);
    end;
  end;
end;

// 16.08.2004 Thorsten Schroff
// Query wird jetzt in eigener Funktion GetFormQuery erzeugt

function THTMLTemplate.GetFormURL(FormName: string): string;
begin
  result := GetFormAction(FormName) + '?' + GetFormQuery(FormName);
end;

procedure THTMLTemplate.SaveForms(FName: string);
begin
end;

function THTMLTemplate.GetJavaParams(FunctionName: string): TStringList;
var
  line: integer;
  str: string;
  params: string;
  param: string;
  MachineState: integer;
  k: integer;
begin
  result := TStringList.create;
  line := 0;
  MachineState := 0;
  params := '';
  repeat
    if (line >= count) then
      break;
    case MachineState of
      0:
        begin
          k := pos('javascript:' + FunctionName, strings[line]);
          if (k > 0) then
          begin
            str := copy(strings[line], k, MaxInt);
            inc(MachineState);
          end;
        end;
      1:
        begin
          k := pos('(', str);
          if (k > 0) then
          begin
            params := ExtractSegmentBetween(str, '(', ')');
            break;
          end
          else
            dec(MachineState);
        end;
    end;
    inc(line);
  until false;
  param := params;

  k := 0;
  while param <> '' do
  begin
    param := nextp(params, ',', k);
    ersetze('''', '', param);
    result.add(param);
    inc(k);
  end;
end;

procedure THTMLTemplate.InsertDocument(FName: string);

  function StartTokenIs(s: string; n: integer; const o: TStrings): boolean;
  var
    p, pp: integer;
  begin

    // das erste Zeichen muss passen
    p := pos(s[1], o[n]);
    if (p = 0) then
    begin
      result := false;
      exit;
    end;

    // vor dem ersten Zeichen darf es nur Leerschritte geben
    if (p > 1) then
      if (noblank(copy(s[n], 1, pred(n))) <> '') then
      begin
        result := false;
        exit;

      end;

    // Allen weiteren Zeichen müssen passen
    pp := pos(s, o[n]);

    // Im Notfall: uppercase
    if (pp <> p) then
      pp := pos(s, uppercase(o[n]));

    // Immer noch nicht?
    if (pp <> p) then
    begin
      result := false;
      exit;
    end;

    // Ansonsten: Nichts zu beanstanden
    result := true;

  end;

var
  // Line-Numbers
  HomeLine, NewLine, InsertPos: integer;
  Body_Start, Body_end, HTML_end: integer;
  n: integer;

  nDocument: TStringList;
  nStyle: TStringList;

  // Automata
  Automatastate: integer;
  Mission_complete: boolean;

begin

  // Dokument-Fortsetzung laden
  nDocument := TStringList.create;
  nDocument.LoadFromFile(FName);

  //
  Body_Start := -1;
  Body_end := -1;
  HTML_end := -1;

  // die ganzen Tag-Lines den "neuen" Dokumentes bestimmen!
  Automatastate := 0;
  nStyle := nil;
  Mission_complete := false;
  HomeLine := 0;
  while true do
  begin

    if (HomeLine = nDocument.count) then
      break;

    case Automatastate of
      0:
        if StartTokenIs('<STYLE', HomeLine, nDocument) then
        begin
          nStyle := TStringList.create;
          inc(Automatastate);
        end;
      1:
        if StartTokenIs('</STYLE', HomeLine, nDocument) then
        begin
          inc(Automatastate);
        end
        else
        begin
          if (nDocument[HomeLine] <> '<!--') then
            if (nDocument[HomeLine] <> '-->') then
              nStyle.add(nDocument[HomeLine]);
        end;
      2:
        if StartTokenIs('<BODY', HomeLine, nDocument) then
        begin
          Body_Start := HomeLine;
          inc(Automatastate);
        end;
      3:
        if StartTokenIs('</BODY', HomeLine, nDocument) then
        begin
          Body_end := HomeLine;
          inc(Automatastate);
        end;
      4:
        if StartTokenIs('</HTML', HomeLine, nDocument) then
        begin
          HTML_end := HomeLine;
          Mission_complete := true;
          break;
        end;
    end;
    inc(HomeLine);
  end;

  if Mission_complete then
  begin

    //
    // Header     1:1     delete
    // Style      1:1     add if unkown
    // Body       1:1     add
    // Comment
    HomeLine := 0;
    Automatastate := 5;
    Mission_complete := false;
    while true do
    begin

      if (HomeLine = count) then
        break;

      case Automatastate of
        5:
          if StartTokenIs('</STYLE', HomeLine, self) then
          begin
            for n := 0 to pred(nStyle.count) do
            begin
              insert(HomeLine, nStyle[n]);
              inc(HomeLine);
            end;
            inc(Automatastate);
          end;
        6:
          begin
            if StartTokenIs('</BODY', HomeLine, self) then
            begin
              insert(HomeLine, '<P class=breakhere></P>');
              inc(HomeLine);
              for n := succ(Body_Start) to pred(Body_end) do
              begin
                insert(HomeLine, nDocument[n]);
                inc(HomeLine);
              end;
              inc(Automatastate);
            end;
          end;
        7:
          begin
            if StartTokenIs('</HTML', HomeLine, self) then
            begin
              for n := succ(Body_end) to pred(HTML_end) do
              begin
                insert(HomeLine, nDocument[n]);
                inc(HomeLine);
              end;
              Mission_complete := true;
              break;
            end;
          end;
      end;

      inc(HomeLine);

    end;
  end;

  // Clean Up
  if assigned(nStyle) then
    FreeAndNil(nStyle);

  if not(Mission_complete) then
  begin
    // Fehler im B Dokument
    addFatalError('Parser steckt im Status ' +
      IntToStr(Automatastate) + ' fest');
  end;

  // Es gab Fehler?
  if Messages.count > 0 then
  begin
    clear;
    add('<html>');
    add(HugeSingleLine(Messages, '<br>'));
    add('</html>');
    Messages.clear;
  end;

end;

procedure THTMLTemplate.SortBlocks(Block: string);
var
  ClientSorter: TStringList;
  BodyStart, BodyEnd: integer;
  n, m: integer;
  State: integer;
  ActPage: TPageBlock;
  NewOrder: TStringList;
  NewLine: string;
begin

  //
  State := 0;
  ActPage := nil;
  BodyStart := 0;
  BodyEnd := 0;
  ClientSorter := TStringList.create;
  for n := 0 to pred(count) do
  begin
    case State of
      0:
        begin
          // Suche den Blockanfang

          if (pos(cHTML_BeginBlock + Block, strings[n]) = 1) then
          begin
            BodyStart := n;

            ActPage := TPageBlock.create;
            ActPage.StartPage := succ(n);

            inc(State);
          end;

        end;
      1:
        begin // Suche das Blockende

          //
          if (pos(cHTML_EndBlock + Block, strings[n]) = 1) then
          begin
            ActPage.EndPage := pred(n);
            ClientSorter.AddObject(ActPage.SortStr, ActPage);

            BodyEnd := n;
            break;
          end;

          //
          if (pos(cHTML_SortInfo, strings[n]) = 1) then
          begin
            ActPage.SortStr := copy(strings[n], length(cHTML_SortInfo), MaxInt);
            continue;
          end;

        end;
    end;

  end;

  // compress, Seiten ohne Sortierbegriff fliegen raus!
  with ClientSorter do
    for n := pred(count) downto 0 do
      if strings[n] = '' then
      begin
        Objects[n].Free;
        delete(n);
      end;

  if (ClientSorter.count > 0) then
  begin

    ClientSorter.sort;
    NewOrder := TStringList.create;

    // Header
    for n := 0 to BodyStart do
      NewOrder.add(strings[n]);

    // letzte Seite, letzten formfeed wegmachen!
    with ClientSorter.Objects[pred(ClientSorter.count)] as TPageBlock do
    begin
      //
      if (pos('class="breakhere">', strings[EndPage]) > 0) then
        dec(EndPage);
    end;

    // Body
    for n := 0 to pred(ClientSorter.count) do
      with ClientSorter.Objects[n] as TPageBlock do
        for m := StartPage to EndPage do
        begin
          NewLine := strings[m];
          ersetze('~Seite~', IntToStr(succ(n)), NewLine);
          ersetze('~Seiten~', IntToStr(ClientSorter.count), NewLine);
          NewOrder.add(NewLine);
        end;

    // Footer
    for n := BodyEnd to pred(count) do
      NewOrder.add(strings[n]);

    //
    assign(NewOrder);
    NewOrder.Free;
  end;

  //
  for n := 0 to pred(ClientSorter.count) do
    ClientSorter.Objects[n].Free;

  ClientSorter.Free;

end;

{ THTMLAusgabe }

function THTMLAusgabe.AsIntegerList(Values: string): TgpIntegerList;
var
  s1: integer;
  NumericValue: string;
  n: integer;
begin
  result := TgpIntegerList.create;
  s1 := indexof(cHTML_RohdatenStart);
  for n := succ(s1) to pred(count) do
    if (pos(Values + '=', strings[n]) = 1) then
    begin
      NumericValue := nextp(strings[n], '=', 1);
      if (NumericValue <> '') then
        result.add(StrtoIntDef(NumericValue, 0));
    end;
end;

constructor THTMLAusgabe.create;
begin
  inherited;
  // code
end;

destructor THTMLAusgabe.Destroy;
begin
  // code
  inherited;
end;

function html2raw(x: string): string; overload;
var
  p1, p2: integer;
begin
  result := html2Ansi(x);
  while true do
  begin
    p1 := pos('<', result);
    if (p1 = 0) then
      break;
    p2 := pos('>', result);
    if (p2 < p1) then
      break;
    delete(result, p1, succ(p2 - p1));
  end;
end;

function html2raw(x: TStrings): TStrings; overload;
var
  n: integer;
begin
  result := x;
  for n := pred(x.count) downto 0 do
  begin
    x[n] := cutblank(html2raw(x[n]));
    if (x[n] = '') then
      x.delete(n);
  end;
end;

function eMailAdresseOK(e: string): boolean; overload;
begin
  result := (charCount('@', e) = 1) and (charCount('.', e) > 0);
end;

function TColor2HTMLColor(Value: TColor): string;
begin
  with tagRGBQUAD(Value) do
    result := '#' + inttohex(RGB(rgbRed, rgbGreen, rgbBlue), 6);
end;

function HTMLColor2TColor(Value: integer): TColor;
begin
  with tagRGBQUAD(Value) do
    result := RGB(rgbRed, rgbGreen, rgbBlue);
end;

function HTMLColor2TColor(Value: string): TColor;
var
  ColValue: integer;
begin
  ersetze('#', '', Value);
  ColValue := StrtoIntDef('$' + Value, 0);
  result := HTMLColor2TColor(ColValue);
end;

function UnbreakAble(s: string): string;
begin
  result := s;
  ersetze(' ', cNonBreakableSpace, result);
end;

var
  n: integer;

initialization

StartDebug('html');
cHTMLAnsiTab := TStringList.create;
for n := low(cHTMLCodes) to high(cHTMLCodes) do
  if (length(cHTMLCodes[n]) > 1) then
    cHTMLAnsiTab.AddObject(cHTMLCodes[n], TObject(n));

finalization

cHTMLAnsiTab.Free;

end.
