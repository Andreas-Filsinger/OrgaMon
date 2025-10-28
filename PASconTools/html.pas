{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2000 - 2024  Andreas Filsinger
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
  |    https://wiki.orgamon.org/
  |
}
unit html;

{$ifndef FPC}
{$I jcl.inc}
{$endif}

{$ifdef fpc}
{$mode delphi}
{$endif}

interface

uses
  classes,
  anfix,
  gplists

{$IFNDEF FPC}
    ,
  System.UITypes
{$ELSE}
  , lazutf8
  , fpchelper
{$ifndef console}
  ,Graphics
{$endif}
{$ENDIF}
    ;

const
  cVarDelimiter = '~';
  cReferenceDelimiterBegin = cVarDelimiter + '(';
  cReferenceDelimiterEnd = ')' + cVarDelimiter;
  cPageBreakHerePossible = 'pagebreak';
  cNonBreakableSpace = #160;
  cAmpersand = #28; { durch dieses Spezial-Zeichen kann ein echtes raw "&" in HTML ausgegeben werden }
  cRawHTMLPrefix = '@'; { @... unterdrückt die "ascii -> html"-Umsetzung }
  cSeite = 'Seite';
  cSeiten = 'Seiten';

  // Allgemeine Optionen die in der Vorlage transportiert werden können
  //
  // <!-- set <key> <value> -->
  //
  cSet_Context = 'Kontext'; // damit kann ein Umgebungswert gesetzt werden, in der Regel Datenbank RIDs
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
  cHTML_FormFeed_Class = 'class="breakhere">';
  cHTML_FormFeed = '<P ' + cHTML_FormFeed_Class + '&nbsp;</P>';

  // Prefix-Tags im html
  // ACHTUNG: Im Quelltext immer an erster Stelle im String - keine Einrückung!!
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

    function CheckReplaceOne(n: integer; const CheckStr, toValue: string): boolean;
    function ensureContent(Block:String):String;
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
    procedure WriteValue(BlockName, VarName: string; NewValue: TStrings); overload;
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
    procedure LoadBlock(FromBlock, AsBlock: string; KillInsertMark: boolean = false); overload;
    procedure LoadBlock(FromBlock, AsBlock: string; NewStrings: TStrings; KillInsertMark: boolean = false); overload;
    procedure LoadBlock(Block: string; NewStrings: TStrings; KillInsertMark: boolean = false); overload;
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

function Uni2html(code:Integer):string;
function Ansi2html(s: AnsiString): string;
function html2Ansi(x: string): string;
function AnsiToRFC1738(s: string): string;
function RFC1738ToAnsi(s: string): string;
function html2raw(x: string): string; overload;
function html2raw(x: TStrings): TStrings; overload;
function eMailAdresseOK(e: string): boolean; overload;
function XMLEmpty(s: string): string;

implementation

uses
  CareTakerClient,
  windows, SysUtils, math,
{$IFNDEF fpc}
  Soap.EncdDecd,
  JclSimpleXML,
  JclStreams,
{$ENDIF}
  IniFiles;

const
  cERRORText = 'ERROR:';
  cWARNINGText = 'WARNING:';
  cCommandLogFName = 'Command'+cLogExtension;

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
      { } DebugLogPath +
      { } cCommandLogFName);
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
      { } DebugLogPath +
      { } cCommandLogFName);
  end;
end;

function THTMLTemplate.CheckReplaceOne(n: integer; const CheckStr, toValue: string): boolean;

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
    result := anfix.fill('0', StellenAnz - length(result)) + result;
  end;

  function zeitstempel_F(s: string): string;
  begin
    // JJJJ "-" MM "-" TT "T" HH ":" MM ":" SS ":"
    // Beispiel: 2015-05-11T10:23:18
    //
    result := dTimeStampISO(mkDateTime(s));
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
      result := copy(result, 7, 4) + '-' + copy(result, 4, 2) + '-' + copy(result, 1, 2);
    end;
  end;

  function EncodeFile(FName: string): string;
  var
    Inf: TFileStream;
    OutF: TStringStream;
    AnlagenPath: string;
  begin

    // Ermittlung des Anlagen-Verzeichnis
    if TestMode then
    begin
      AnlagenPath := anfix.DebugLogPath;
    end else
    begin
      AnlagenPath := SystemHeap.Values[cSet_AnlagePath];
      if (AnlagenPath = '.\') then
        AnlagenPath := ExtractFilePath(SystemHeap.Values[cSet_Quelle]);
    end;

    // Anlage-Dateiname
    FName :=
      { } AnlagenPath +
      { } FName;

    // wenn Anlage nicht gefunden -> Fehler-Bild
    if not(FileExists(FName)) then
    begin
      addWarning('Datei "' + FName + '" nicht gefunden!');
      result := '/9j/4AAQSkZJRgABAQEAYABgAAD/4QCMRXhpZgAATU0AKgAAAAgABwEaAAUAAAABAAAAYgEbAAUA' + #$0D#$0A +
        'AAABAAAAagEoAAMAAAABAAIAAAExAAIAAAASAAAAclEQAAEAAAABAQAAAFERAAQAAAABAAAAAFES' + #$0D#$0A +
        'AAQAAAABAAAAAAAAAAAAAABgAAAAAQAAAGAAAAABUGFpbnQuTkVUIHYzLjUuMTAA/9sAQwAEAgMD' + #$0D#$0A +
        'AwIEAwMDBAQEBAUJBgUFBQULCAgGCQ0LDQ0NCwwMDhAUEQ4PEw8MDBIYEhMVFhcXFw4RGRsZFhoU' + #$0D#$0A +
        'FhcW/9sAQwEEBAQFBQUKBgYKFg8MDxYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYW' + #$0D#$0A +
        'FhYWFhYWFhYWFhYWFhYW/8AAEQgBAAEAAwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAAB' + #$0D#$0A +
        'AgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNC' + #$0D#$0A +
        'scEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0' + #$0D#$0A +
        'dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY' + #$0D#$0A +
        '2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//E' + #$0D#$0A +
        'ALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoW' + #$0D#$0A +
        'JDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWG' + #$0D#$0A +
        'h4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp' + #$0D#$0A +
        '6vLz9PX29/j5+v/aAAwDAQACEQMRAD8A+/qKK8R/as/aBs/hXNFoWlWcN/r1xB5zeeT5FmhyFLhc' + #$0D#$0A +
        'F2Yg4QFeBksOM51q0KUHObsjswGAxGPxEcPh43k/6uz26ivzzvv2qPi9NctJF4qngUniOGwsgo+g' + #$0D#$0A +
        'e3c/mxqH/hqP4xf9Dle/+AWn/wDyLXm/2zh+z/D/ADPsl4dZu18dP75f/In6JUV+dv8Aw1H8Yv8A' + #$0D#$0A +
        'ocr3/wAAtP8A/kWj/hqP4xf9Dle/+AWn/wDyLR/bOH7P8P8AMP8AiHObf8/Kf3y/+RP0Sor87f8A' + #$0D#$0A +
        'hqP4xf8AQ5Xv/gFp/wD8i0f8NR/GL/ocr3/wC0//AORaP7Zw/Z/h/mH/ABDnNv8An5T++X/yJ+iV' + #$0D#$0A +
        'Ffnb/wANR/GL/ocr3/wC0/8A+RaP+Go/jF/0OV7/AOAWn/8AyLR/bOH7P8P8w/4hzm3/AD8p/fL/' + #$0D#$0A +
        'AORP0Sor87f+Go/jF/0OV7/4Baf/APItH/DUfxi/6HK9/wDALT//AJFo/tnD9n+H+Yf8Q5zb/n5T' + #$0D#$0A +
        '++X/AMifolRX52/8NR/GL/ocr3/wC0//AORaP+Go/jF/0OV7/wCAWn//ACLR/bOH7P8AD/MP+Ic5' + #$0D#$0A +
        't/z8p/fL/wCRP0Sor87f+Go/jF/0OV7/AOAWn/8AyLR/w1H8Yv8Aocr3/wAAtP8A/kWj+2cP2f4f' + #$0D#$0A +
        '5h/xDnNv+flP75f/ACJ+iVFfnb/w1H8Yv+hyvf8AwC0//wCRaP8AhqP4xf8AQ5Xv/gFp/wD8i0f2' + #$0D#$0A +
        'zh+z/D/MP+Ic5t/z8p/fL/5E/RKivzt/4aj+MX/Q5Xv/AIBaf/8AItH/AA1H8Yv+hyvf/ALT/wD5' + #$0D#$0A +
        'Fo/tnD9n+H+Yf8Q5zb/n5T++X/yJ+iVFfnb/AMNR/GL/AKHK9/8AALT/AP5FrV8J/tZ/FLT9Ujm1' + #$0D#$0A +
        'LV49VgDfPBfWVuFYdxugjiZfrzj0PShZxh29n/XzJn4d5vGLalB+Sb/WKR9+0Vw/wB+J2j/FTwMu' + #$0D#$0A +
        'v6ZC1rPDJ5N9ZO4dreXAOA2BuUggq2BkdQCCB3FepCcZxUou6Z8TiMPVw1WVGrG0ouzQUUUVRiFF' + #$0D#$0A +
        'FFABRRRQAUUUUAFfnN+3pIzftSeKVZiQkloFBPQfYLY4/Mn86/Rmvzg/b1bH7VPiv/rtaf8Apvta' + #$0D#$0A +
        '8rOP93Xr+jPu/Dx2zaf+B/8ApUTyPdRuqHcPWjcPWvmbH7TzE26jdUO4etG4etFg5ibdRuqHcPWj' + #$0D#$0A +
        'cPWiwcxNuo3VDuHrRuHrRYOYm3Ubqh3D1o3D1osHMTbqN1Q7h60bh60WDmJt1G6odw9aNw9aLBzE' + #$0D#$0A +
        '26jdUO4etG4etFg5ibdRuqHcPWjcPWiwcxNuo3VDuHrRuHrRYOY+x/8AgldIzL43QsdqxaaQM8Al' + #$0D#$0A +
        'rwE/oPyr66r5B/4JUHLeOf8Arjpn/od7X19X1uW/7pD5/mz8C4y/5HuI/wC3f/SYhRRRXcfMBRRR' + #$0D#$0A +
        'QAUUUUAFFFFABX5t/t9Nj9qzxYP+m1p/6b7Sv0kr81f2/mx+1f4tH/Ta0/8ATfaV5ebf7uvX/M+4' + #$0D#$0A +
        '4Ads2l/gf5xPId1G6oN9G+vm7H7JzH378O/gH8B/+Gf9C8b+KvCf/MsW2q6rd/2lff8APqsssmyO' + #$0D#$0A +
        'X/eO1V9gO1R/Dv4Pfsp/FTRtQPgOwkuPsZWO4nt76/jmtmcHadlw2OdrYJUjg+lel/Do6B/wx3oR' + #$0D#$0A +
        '8V/8gH/hA7b+1vv/APHr9gXzv9X8/wBzd935vTmsL9lvUPgM1vrWkfAu7s4buSNZ7xZIrxnOMrG7' + #$0D#$0A +
        'C5Ku6KWPCsB83UE5r6dUaV4LljZrtr8j8SqZlj3TxFRVq3NGWjUn7NK/2u3kfJOk+Cvhx8Of2q9V' + #$0D#$0A +
        '8F/Fu6+1eGdLVwJyLgGTfEskBYW/zhtrrnHGc1v/APCO/Avxf+174P8ADfw7s/tng7ULTZqUHm3s' + #$0D#$0A +
        'e+5AuGYbpiJR8qw/dIH612vwU8P+LfDn/BRq+t/GmoQ6jqd9YXN59tgQpHPG8Y2FVPKBQNm05xsx' + #$0D#$0A +
        'kjk9N8cD/wAbLPhsP+oEn/od/XBGguS/Krc9ttd+59XXzSo8RyqrJyeHcrqdoN8r1Ubb31Turdjy' + #$0D#$0A +
        'T/goL8M/A/w01vwxb+CtE/syPUbe5e5X7XNN5hRowp/eu2Mbj0x1r523V9v/ALdXhq08Y/tEfCbw' + #$0D#$0A +
        'vfuy2mqTzQ3Ow4Yx+ZEXAPYlQRn3rsP2mPij4H+A3hnQvCUfw+stU03WBIraZEI4beKGPYGZlMbL' + #$0D#$0A +
        'Ix3DgjnByR3VfBwlVqTuoxVunki8r4kxFHA4Sgqcq1aopPWVnZSl1d76L8Nzzn9ob4HfC3wz+yHd' + #$0D#$0A +
        'eNtE8L/Zddj0/Tplu/7QuXw8s0CyHY0hTkSOPu8Z4xxXxtur9F/22prGf9iPXbjTIvKspbTTXtY9' + #$0D#$0A +
        'u3ZEbu2KjHbAxX5w76yzOnGFWKiraLb5nfwXjK+JwNWdebk/aNe822laOmp9c/sK/s/+BvH3w5uf' + #$0D#$0A +
        'GXjezuNT829ktbWzW6khiREC5cmNlYsWYjGcADoc143+1MPhBF40sY/g2zPpX2PdeOWuSon8xhtH' + #$0D#$0A +
        '2j5sBQpyMg7utfdv7Inj3/hYnwO0vWv7K/s37J/xL/K+0edu8lVXfu2rjPXGOPU149+zTb+GP2if' + #$0D#$0A +
        'jJ4i+L3ifwrBGulxWljY6TcXAu4VlCsWmfKKGIAXaCuBknkgEdVTC05UadOna8uttfW/6Hg4TPcX' + #$0D#$0A +
        'SzHGYvGc/JS05VNcqbdkuXrfurWs73uj4l3V6l+xr4S8O+Ovj9pXhvxTp/2/S7mC5aW386SLcUhd' + #$0D#$0A +
        'l+aNlYYIB4Nfogttrt1qb6NqPhLwyfDPzIjjU3llZADtBtWtRGM9x5px714LH8NdC+H/APwUD8KX' + #$0D#$0A +
        'nhmyjsdO8Q6XfXBs4hiOGdIZBJ5Y/hUhkO3oCTjjAGf9mulOEr3V1fQ7P9c1jcPXoqDpz9nJxakn' + #$0D#$0A +
        'sm91az6nh37fnw98HfDf4laNpXgzR/7NtLvSBcTR/aZZt0nnSLuzK7EcKOAccV4Rur9Gfj18VPCP' + #$0D#$0A +
        'w9/aA8I6beeCl1bXtfjhtRqpkVX0+2ecovl7lbcd7OSAUyAMk8Y8u/4KoeFNEttB8O+MLWwt7fU5' + #$0D#$0A +
        'r97O6nijCtcoYy67yPvFShwTz8xqcXgo3qVISWnSxtkHElflwuExNOX7xO03K7bV+m/ldv5WF/bc' + #$0D#$0A +
        '+B3wt8AfA2bxD4S8L/2fqS6hBCJ/7QuZvkYncNskjLzgdq4z4G/s26XrXwC1D4p+J9WknjfR7y70' + #$0D#$0A +
        '3TbXKBWiWQBpnPJ+ZM7Vx2yxzivef+CjVx9k/ZzN1t3eTrVm+3OM4YnGfwrufAPxN/4SX9ndfin/' + #$0D#$0A +
        'AGJ9lzpd1f8A9nfa9/8AqfM+Tzdg6+X128Z6HFdksLQliZJq1ltb8T52jnua0slpShOUnKo05OV3' + #$0D#$0A +
        'srR1u9ddVtbzPy33Ubq6v4/+P/8AhZvxc1bxv/ZX9l/2p5H+h/aPP8ry4I4vv7Vzny8/dGM47Zrj' + #$0D#$0A +
        'd9fPyilJpO6P1mhVqTpRlUjyyaV1e9n1V+tu59m/8EoTlvHX/XHTP/Q76vsKvjn/AIJNnLeO/wDr' + #$0D#$0A +
        'jpf/AKHfV9jV9Tl3+6w/rqfhnF7vnlf5f+koKKKK7T5sKKKKACiiigAooooAK/NH/goE2P2svFw/' + #$0D#$0A +
        '6bWn/putK/S6vzL/AOCgzY/a28X/APXaz/8ATdaV5ua/wF6n2nAjtmsv8D/NHju+jfUG73o3e9fO' + #$0D#$0A +
        'WP1/mP0F+HP7QfwC/wCGe9B8D+K/F3/Mr22latZ/2bff8+qxTR744v8AeG5W9we9Ufh38WP2QfhX' + #$0D#$0A +
        'Jd6j4DuJIbu8jEc5gstQmldAc7Q1yMKCQOARkgZ6V8Ebvejd716P9o1NPdV11t/wT5J8IYN86Vao' + #$0D#$0A +
        'ozd2lJJP1XKfVXgj9oTwtrX7bTfE3xLLJoPh+LS5LC0MsDzSKgTCF1iVjuZix4BAzjJxk6PxV+NH' + #$0D#$0A +
        'w11j9uTwP8QNN8Sed4b0fSVt76++w3C+TIGuzt8tow7f62PlVI+b2OPkTd70bvesfrlXls7b3+Z3' + #$0D#$0A +
        'Ph3Be1VSLkrQ9nZNW5bNdVe+u9z6s/bO+OvhLXvip4B8YfDXXF1abwvJJcSh7SeBQ/mRMqMJUUkM' + #$0D#$0A +
        'FYHHavR/iF8e/wBl74meD9P1Hx7Y3l7e6WWmttIls7gXEchC7lWSIiJlJUcM+DtGRXwZu96N3vVf' + #$0D#$0A +
        'XqvNJtJ83ToYvhjBeyowjOcXSvaSdpWbbabS8+lj7d/ac/aI+Fnj39k3UvDui60IfEGpWlgw0dbG' + #$0D#$0A +
        '4At5FuIJJIhKYljOwK4yDg7eOor4p31Bu96N3vWOIrzryUpb2sejlOV4fK6MqNBtxbctdd0l2Wmh' + #$0D#$0A +
        '9r/sOfHj4U/D/wCBMPh7xf4q/s7Ul1C4mMH9nXU3yMRtO6ONl5we9eP/ALFPx4g+DviXULXXbO4u' + #$0D#$0A +
        '/D+tCP7T9mAM1tKmdsiqSAwwxDDIPQjpg+Ebvejd71p9cq+5bTl2Ob/V/BP6zz3artOSb2abatZK' + #$0D#$0A +
        '2r8z7q1D4ifsWN4ivfGs+mWepazfs8tzBNot3MJZGyWPkyr9nDk5Jbjk5zXk3ws+MngFP2yLLx5N' + #$0D#$0A +
        'oum+CfCVla3FtbwWOmBdqmGRVeVLdCWkZm5IBxkDOFzXzdu96N3vTljJyafKlZ30RlR4dw1KnUg6' + #$0D#$0A +
        'k5c0XH3pXsnpppZfcz6d/a4+K/gHxp+0p4F8VeGde+3aRo4tft1z9jni8nZdtI3yOis2EIPyg/nW' + #$0D#$0A +
        '9/wUE+NHw1+JPw30TS/BPiT+1Luz1b7RPH9huIdkflOu7Msag8sOAc18ibvejd70pYypJTTS97c0' + #$0D#$0A +
        'pcP4SlPDyUpXo3UdVrfvp+Vj7X/bj+PHwp+IHwJm8PeEPFX9o6k2oW8wg/s66h+RSdx3SRqvGR3o' + #$0D#$0A +
        '/ZP/AGh/hPpn7O9v8O/iLfzaa9pBcWcwNnPLHeQSu7fK0KsynbIVOcdMg88fFG73o3e9X9fq+19r' + #$0D#$0A +
        'ZXtbyOdcLYFYBYLmlyqXMndXTtbe1vwO7/aCm8ASfFjUpPherp4XKwiyRllG0iFBJ/rSXOXDHLet' + #$0D#$0A +
        'cXvqDd70bveuOT5pN2tc+hox9lSjT5m7JK71bt1b6vufan/BJU5fx5/1x0v/ANDvq+ya+Mv+CR5y' + #$0D#$0A +
        '/j7/AK46V/6Hf19m19Pl/wDu0P66n4lxW751X9V/6SgooorsPngooooAKKKKACiiigAr84/+CkXh' + #$0D#$0A +
        'jVdN/aT1bXJraT7FrkdvPaTbflcx2sMLoD/eUxAkejg1+jlcr8QPB/hrxvo95onirSLbUrJ5w3lz' + #$0D#$0A +
        'pnYwjTDKeqsPUc1z4qgq9PkuevkmavLMYsQo3VrNeTPyI5pMmv0O1T9jb4T3Nw0ltPrlohJIjS+M' + #$0D#$0A +
        'gA9MuCf1qr/wxd8L/wDoK6//AOBKf/E15H9l1u6P0FcdZc1rCX3L/M/PvJoya/QT/hi74X/9BXX/' + #$0D#$0A +
        'APwJT/4mj/hi74X/APQV1/8A8CU/+Jpf2XW7of8Ar1l38svuX+Z+feTRk1+gn/DF3wv/AOgrr/8A' + #$0D#$0A +
        '4Ep/8TR/wxd8L/8AoK6//wCBKf8AxNH9l1u6D/XrLv5Zfcv8z8+8mjJr9BP+GLvhf/0Fdf8A/AlP' + #$0D#$0A +
        '/iaP+GLvhf8A9BXX/wDwJT/4mj+y63dB/r1l38svuX+Z+feTRk1+gn/DF3wv/wCgrr//AIEp/wDE' + #$0D#$0A +
        '0f8ADF3wv/6Cuv8A/gSn/wATR/Zdbug/16y7+WX3L/M/PvJoya/QT/hi74X/APQV1/8A8CU/+Jo/' + #$0D#$0A +
        '4Yu+F/8A0Fdf/wDAlP8A4mj+y63dB/r1l38svuX+Z+feTRk1+gn/AAxd8L/+grr/AP4Ep/8AE0f8' + #$0D#$0A +
        'MXfC/wD6Cuv/APgSn/xNH9l1u6D/AF6y7+WX3L/M/PvJoya/QT/hi74X/wDQV1//AMCU/wDiaP8A' + #$0D#$0A +
        'hi74X/8AQV1//wACU/8AiaP7Lrd0H+vWXfyy+5f5n595NGTX6Cf8MXfC/wD6Cuv/APgSn/xNH/DF' + #$0D#$0A +
        '3wv/AOgrr/8A4Ep/8TR/Zdbug/16y7+WX3L/ADPz7yadGru21QWJ7AV+gX/DF3wv/wCgrr//AIEp' + #$0D#$0A +
        '/wDE1seFP2RvhBpF7Hc3dlqGr+WciK+vGMTHP8SLhWHsQRTWV1r6tEz46wCi+WEm/l/mch/wSk8M' + #$0D#$0A +
        '6ppnhPxV4ivIHis9YezgsmYY84QG4Luvqu6bbn1Q19a1m6DaWtgBZWNvFb21vbRJFDEgVEUM4AAH' + #$0D#$0A +
        'QVpV7dGmqVNQXQ/Ncxxssdi54mSs5MKKKK0OIKKKKACiiigAooooAKz2/wCPi4/67f8AtNK0KzpP' + #$0D#$0A +
        '+Pm4/wCu/wD7TSgBaKbRQA6im0UAOoptFADqKbRQA6im0UAOoptFADqKbRQA6im0UAOoptFADqKb' + #$0D#$0A +
        'RQBNY/8AH9J/1xj/APQpKuVS0/8A4/pP+uEf/oUlXaACiiigAooooAKKKKACiiigArNk/wCPq5/6' + #$0D#$0A +
        '7/8AtOOtKsub/j6uf+u//tOOgAoptFADqKbRQA6im0UAOoptFADqKbRQA6im0UAOoptFADqKbRQA' + #$0D#$0A +
        '6im0UAOoptFAFjTf+P2T/rhH/wChSVeqjpn/AB+yf9cI/wD0OSr1ABRRRQAUUUUAFFFFABRRRQAV' + #$0D#$0A +
        'lXH/AB9XP/Xf/wBpx1q1kXJ/0q5/6+P/AGnHQAmaM03IoyKAHZozTcijIoAdmjNNyKMigB2a5z4h' + #$0D#$0A +
        '+PPCfgeyS58TazDZ+cD5MAVpJpsddkSAs2MjJAwM84q3478Q2HhTwbqfiTUifsumWrzyKp+Z9o4R' + #$0D#$0A +
        'c/xMcKPcivzc+KfjXXPG3jK+13WbppLi7f5lU/JGg+7Eg7IvQD6k5JJPn4/HfVopJXkz6zhbhl5z' + #$0D#$0A +
        'VlKpJxpR3a3b7L9WfbR/aa+FoOPtWrf+C16T/hpr4W/8/Orf+C16+AM0ZryP7YxHZf18z9A/4h7k' + #$0D#$0A +
        '/wDNP71/8iff/wDw018Lf+fnVv8AwWvR/wANNfC3/n51b/wWvXwBmjNH9sYjsv6+Y/8AiHuT/wA0' + #$0D#$0A +
        '/vX/AMiff/8Aw018Lf8An51b/wAFr0f8NNfC3/n51b/wWvXwBmjNH9sYjsv6+Yf8Q9yf+af3r/5E' + #$0D#$0A +
        '+/8A/hpr4W/8/Orf+C16P+Gmvhb/AM/Orf8AgtevgDNGaP7YxHZf18w/4h7k/wDNP71/8iff/wDw' + #$0D#$0A +
        '018Lf+fnVv8AwWvR/wANNfC3/n51b/wWvXwBmjNH9sYjsv6+Yf8AEPcn/mn96/8AkT7/AP8Ahpr4' + #$0D#$0A +
        'W/8APzq3/gtej/hpr4W/8/Orf+C16+AM0Zo/tjEdl/XzD/iHuT/zT+9f/In6C2P7T3wriuXd7rVs' + #$0D#$0A +
        'NEij/iWv1DOT/wChCrf/AA1L8Jv+fvV//BZJX535ozR/bGI7L+vmL/iHmT/zT+9f/In6If8ADUvw' + #$0D#$0A +
        'm/5+9X/8FklH/DUvwm/5+9X/APBZJX535ozR/bGI7L+vmH/EPMn/AJp/ev8A5E/RD/hqX4Tf8/er' + #$0D#$0A +
        '/wDgsko/4al+E3/P3q//AILJK/O/NGaP7YxHZf18w/4h5k/80/vX/wAifoh/w1L8Jv8An71f/wAF' + #$0D#$0A +
        'klbvgX4/fC7xVq0emWWvtaXczBIY9Qtnt1mY8BVdhsLE9F3ZPYV+aWafBPJExKNwwww7MPQjuKcc' + #$0D#$0A +
        '4rp6pWIq+HeVSg1Cc0+jun+Fj9dqK+f/ANgX4q3fjjwNceGNcunuNW8PonlTytmS4tWyFLHqzIVK' + #$0D#$0A +
        'knqChOSSa+gK+ho1o1qanHZn5JmWX1svxc8NV+KL+/s/mgrHuz/pVz/18f8AtKOtisW8P+l3P/Xx' + #$0D#$0A +
        '/wC0o61OEZmjNNzRmgB2aM03NGaAHZozTc0ZoA8Q/wCCgmrTad8A1tYjhdU1e3t5PdVWSf8AnAtf' + #$0D#$0A +
        'CO73r7a/4KRH/iyej/8AYxJ/6R3dfEGa+Yze7xHyP23gCKjlF11k/wBCXd70bveos0Zry7H2/MS7' + #$0D#$0A +
        'veu5+Bvwp8UfFfVr7TvC8mnrNp8CzTfbJmjXaW2jBCnJzXA5r6o/4JYH/i4Hir/sGRf+ja6cJRjV' + #$0D#$0A +
        'rxhLZnj5/j62ByyriaPxRStf1SOS8Rfsl/FPRfD99rN5ceHzb6dayXMwjvnLbEUs2B5fJwDXhO73' + #$0D#$0A +
        'r9WPjL/yR/xX/wBgK9/9EPX5RZrpzHCU8PKKh1PF4Pz7F5tRqyxNrxaSsrbnrfwY/Z+8efE/wg3i' + #$0D#$0A +
        'Tw3NpC2aXT2xF3dNG+9QpPAQ8YYd663/AIY5+Ln/AD8+HP8AwPf/AON17p/wTP8A+TdZ/wDsO3H/' + #$0D#$0A +
        'AKLhr2vx94u8OeCfDra74p1OPTtPSRYmndGYBm6DCgnn6V24fLcPOhGpPt3Pmc14xzihmdXCYdJp' + #$0D#$0A +
        'Ssly3f56nxB/wxz8XP8An58Of+B7/wDxuquofsh/GO3z5Ntot3hc/udRAyfT51Xn9K+rv+Gkvgj/' + #$0D#$0A +
        'AND9Z/8AgLcf/G66zwH8SfAXjS4e28LeLNL1S4jXc1vBcDzQv97YcNj3xirjl+Bk7Rlr6owqcXcT' + #$0D#$0A +
        'UI89WhaK7wkl+h+a/wATPht46+H1wkXi/wANXmmLKdsczASQyHrhZUJQnHYHNcpu96/WzxXoWkeJ' + #$0D#$0A +
        'fD91oevafBf6feRlJ7eZdysP6EHkEcggEV+Z/wC078NpfhX8XL7wyJJJrB1W602aT70lu5O3d6sp' + #$0D#$0A +
        'VkJ7lScDOK8/HZe8PaUXeJ9bwvxas3boVoqNVK+mzXlfa3bU4Pd71JaQz3V1HbWsMk00zhI4o0LM' + #$0D#$0A +
        '7E4AAHJJPajR7C91bVrXS9NtpLm8vJlgt4IxlpJGICqPckiv0T/ZV+Aeg/CvQYNR1CC31DxXcR5u' + #$0D#$0A +
        'r9l3C1yOYoM/dUcgt1bnoMAYYTBzxMrLRLdnpZ/xFh8noKU1zTl8Me/m+yPlr4efsofFrxNaR3l7' + #$0D#$0A +
        'ZWPh63kAZf7VmKzEf9ckVmU+z7TXe2/7EGtmEGf4g2CSd1TTXYD8S4/lX1v408UeHfCOitq/ibWb' + #$0D#$0A +
        'PSrJDjzrqUIGbGdqg8s3B4GSfSvJdQ/a1+CtteGCPW9QulB/10GmS7Ov+0Af0r2HgMDS0qPXzZ+e' + #$0D#$0A +
        'w4p4ox7c8JT93+7C6+9png/in9i/4iWNu02ia9oerbRxEzyW8j/TcpX06sK8K+IXgrxZ4G1j+y/F' + #$0D#$0A +
        'uhXmlXJGUE6fJKPVHGVce6kiv0u+FvxR8BfEWF28IeJLXUJYk3y22GjnjHTLROA2M8Zxj3q/8TPB' + #$0D#$0A +
        'Xhzx94TuPDvijTo7yznB2kjEkD4IEkbdVcZ4I+hyCRU1MqoVIc1CX6o2wfHeZ4TEeyzKndddOWS+' + #$0D#$0A +
        'W3ysvU/KPd70bveur+O3gDUvhl8TdR8Jak3nC2YPa3IXAuYG5SQDtkcEdmDDJxXH5rwJQlCTjLdH' + #$0D#$0A +
        '6vQxFOvSjVpu8ZK6fkz3n/gnlrE+n/tJ6XZxt8mqWt3aSD1XyWn/AJ261+hFfnD+wUf+MqPCn/Xa' + #$0D#$0A +
        '7/8ASC6r9Hq+lydv6u/X/I/GfEGKWbxa6wX5yCsS+P8Apdz/ANfH/tKKtusPUD/plz/18f8AtKKv' + #$0D#$0A +
        'UPhiLNGaZk0ZNAD80ZpmTRk0APzRmmZNGTQB8/f8FJG/4sno/wD2MSf+kd3Xw9u96+3v+Ckxx8Ed' + #$0D#$0A +
        'H/7GJP8A0ju6+HN1fM5t/vHyP2rgOX/CR/28yXd70bveot1G6vNPtOYl3e9fVX/BKs5+IHiv/sFw' + #$0D#$0A +
        '/wDo2vlDdX1b/wAEpzn4heK/+wXD/wCja7Mv/wB6h/XQ+c4sl/wiYj0X/pSPrn4zf8kf8V/9gK9/' + #$0D#$0A +
        '9EPX5Pbvev1h+NH/ACR3xZ/2Ab3/ANEPX5M7q7c5+OHzPmvDp2w+I9V+TP0F/wCCZZz+znP/ANh2' + #$0D#$0A +
        '5/8ARcNXP+CkBx+zLdf9hS1/9CNUf+CY5z+zjcf9h65/9Fw11/7aXgfxJ8Q/gfP4c8K2cd1qL30E' + #$0D#$0A +
        'yxvOkQ2qSWO5iB3rtjFyy+yWvKfM16sKXFjqVHaKqXbey1PzS3e9XvDWtap4f1601vRb6ay1CxlE' + #$0D#$0A +
        'tvcQttaNh/nBHQgkGvXR+yV8cScf8I3Zj3/tW3/+Lrvvg3+xf4ol8TW178RNS0600m3kDy2VlO00' + #$0D#$0A +
        '9yAfuFtoVFPcgk4zwOo8OGCxLkrQa/A/UMTxJk9OlJzrxkrbJp38rI+yfBOpya34L0jWZovKk1HT' + #$0D#$0A +
        '4Lp4/wC4ZI1Yj8M18j/8FXLOCPVvA+oqP39xBfQufVY2gZf1lb86+yoY44YUhhjWOONQqIi4VQOA' + #$0D#$0A +
        'AB0FfAn/AAUv8a2niH402fhywmWaLwzZmGdlOQLmUhnXPsojB9DuHavdzNpYVp7ux+X8F05VM8hO' + #$0D#$0A +
        'mrRipN+SaaX4tGr/AMExfA0Ws/EjVPG99CHh8OwLDZ7l4+0zBhuHusauP+2gNfbXifV7Hw/4b1DX' + #$0D#$0A +
        'dTl8uy0y1kurlwMlY0UsxA7nANeCf8EyNPjtP2dbi8AHmahrlxKx74VIowP/ABwn8a6f9vjUpdN/' + #$0D#$0A +
        'ZV8TNAWV7r7NbbgeivcRhvzXcPxowiVDBcy7Nhn85ZnxI6EnpzRgvJXSf43Z8IfHj4neIPil48uv' + #$0D#$0A +
        'EGtXEiwb2WwsQ5MVlDnhFHTOANzfxHJ9AOK3e9Rbq2/h/wCEvEnjfxEuheFdLk1LUXjaVbeN1UlV' + #$0D#$0A +
        '5Y5YgcfWvmm51J3erZ+zU40MJQUY2jCK9EkiPwj4g1fwv4ls9f0K+lstQsJRLBPEcFSOx9QRkEHg' + #$0D#$0A +
        'gkHg190W/wC2V8LofCen3l9Hq1xq01pG97ZWFllYJyo3oHkZQQGzggnivlf/AIZr+OP/AET+9/8A' + #$0D#$0A +
        'Aq3/APjlH/DNfxx/6J/e/wDgVb//AByu7DyxeHTUIPXyZ83m+HyDNZQlia8bx7Tivk/I0v2wvjLo' + #$0D#$0A +
        'Xxi8QaTqGkeG7nS5NLhlge4uZ1Z7mNmDIpVRhdp3n7x++a8b3e9dd8SvhR8Q/h/pVvqXjDwzcaXa' + #$0D#$0A +
        '3U3kQyyTROHfaW24RiegJ/CuM3VyV5VJVHKotX8j3Msp4SjhIUsHJOmtrPm697s9p/YHb/jKvwmP' + #$0D#$0A +
        '+m13/wCm+7r9Iq/Nn9gQ/wDGVvhL/rtd/wDpvu6/Savfyj/d36/5H5T4gO+bR/wL85BWDqP/AB+X' + #$0D#$0A +
        'P/Xz/wC0oq3q5/Uz/plz/wBfJ/8ARUVeofDkOaM03IoyKAHZozTcijIoAdmjNNyKMigD57/4KUnH' + #$0D#$0A +
        'wR0b/sY0/wDSK7r4b3V9wf8ABSs4+CGjf9jGn/pFeV8M7q+bzT/ePkfsnAsv+En/ALef6E26jdXt' + #$0D#$0A +
        '37AfgLwR8SPi5qOgeN9MbULeHR5Lu2hF1JADIssSnJjZWJxITjPY+lfXXjD9m34TRfD7XbTw54B0' + #$0D#$0A +
        '6PU59LuY7GVmeWSOZoWVGVpGbDBsEHseazoZfUrU+eLVjtzTivCZdivqtSEnLTXS2vz/AEPzX3V9' + #$0D#$0A +
        'Xf8ABKI5+IXiz/sFw/8Ao2vk2QPHI0cilXUkMrDBBHYivr7/AIJM6bO+veM9ZKsIYra1tQezMzSM' + #$0D#$0A +
        'R+AQfmKnL1/tMP66F8WVEslr37L/ANKR9YfGn/kjniz/ALAN7/6IevyV3V+r37RF8mm/APxreuyr' + #$0D#$0A +
        '5Xh6927s4LmBwo49WIH41+Te6uzOPjgfP+Ht1hq781+R+hn/AATDOf2b7j/sPXP/AKLhr3bxf4j0' + #$0D#$0A +
        'Hwrozat4k1ez0uxV1Q3N3KI4wzdBk9zXg/8AwS/Of2bbj/sP3P8A6Lhq7/wUsOP2X7r/ALCtr/6E' + #$0D#$0A +
        'a9CjUdPBKa6I+TzDCxxfEc6EnZSqW+9noH/C8fg9/wBFK8Nf+DGP/GqGrftE/BPTldrj4iaS4j6/' + #$0D#$0A +
        'ZvMuD0zwI1bP4fSvy33Ubq83+16v8qPsI+H+BvrVl+H+R9r/ALQP7aGmjS7jR/hTaXE11KCh1q9h' + #$0D#$0A +
        '8uOEH+KGJvmZueC4UAj7rV8ZXlzPd3ct1dTSTTzuZJZZGLM7E5LEnqSSTmqu6jdXBXxFSvK82fVZ' + #$0D#$0A +
        'VlGDyum4YaNr7t6t+r/pH6Ff8EwtTjvf2drmyDL5mna5PGy98MkTgn/voj8K6z9vLS5dV/ZV8VRw' + #$0D#$0A +
        'KzSWscF0AP7sdxGzk/RAx/Cvm3/glz48g0b4mar4HvpgkXiO3Waz3Hj7TCGOwe7Rs5/7Zgd6+5vE' + #$0D#$0A +
        'Wl2WueH77RdShE1lqNtJbXMZ6PG6lWH4gmvfwjVbB8nk0flefRll3ETrtac0ZrzV03+N0fj3ur3D' + #$0D#$0A +
        '/gnnq+laN+0ha32sanZ6fajTblTPdzrDGCVGBuYgZNcH+0H8MPEHwn+IVz4d1qF2tmZn02+2YjvY' + #$0D#$0A +
        'M8Op6BugZeqn2wTwu6vn4c1Cqm1qmfrOIjRzPAShCfuVI2uuzP1w/wCFjfD3/ofPDP8A4OIP/i63' + #$0D#$0A +
        'NH1LT9X02PUNKv7W+s5s+XcWsyyxvglThlJBwQR9Qa/HWMPJIscalnYgKqjJJPYCv09/Yg0XVvD/' + #$0D#$0A +
        'AOy34V0rXNOuNPvokuXktrmMpIgku5pE3KeQSjqcHnmveweOliJuLjZWPyriLhijlOGjVjVcm5Ws' + #$0D#$0A +
        '0lpZu/4fieZ/8FVjj4O+Hf8AsPD/ANES18Jbq+6/+CrZx8HfDn/YeH/oiWvg7dXl5n/vL+R9xwTK' + #$0D#$0A +
        '2TQ9Zfme2fsAn/jLDwl/12u//Tfd1+lVfmj/AME/Wz+1l4R/67Xf/puu6/S6vTyn/d36/wCR8Xx6' + #$0D#$0A +
        '75rH/AvzkFc9qp/0y5/6+T/6Kiroa5vWm23lx/18n/0TDXpnxJBmjNReZR5lAEuaM1F5lHmUAS5o' + #$0D#$0A +
        'zUXmUeZQB8+f8FLj/wAWP0X/ALGRP/SK8r4X3V93/wDBRiymvvgJazxrlbDXIJpCP4VaKaEH/vqZ' + #$0D#$0A +
        'R+NfBm4187mi/f8AyP17gaaeVtdpP9D0P9mH4hf8Ky+NuieLJtzWMMxg1BFGS1tINkhAHUqDvA7l' + #$0D#$0A +
        'RX6p6PqFjq2k22p6Zdw3dneRLNb3ELhklRhkMpHUEGvxp3e9eqfAX9ob4j/CeD+z9C1CC+0feWOl' + #$0D#$0A +
        '6khlgUk8mMghoyeT8pAJOSDRgcaqF4yWjK4o4clmfLXoNKpFW12a/wA0fcPxM/ZX+EfjbxZP4ivd' + #$0D#$0A +
        'Nv8AT728kMt3/Zt15Mdw56syFWAJ7lcZJJPJzXo3wr8BeFfhz4Tj8OeENLSwsVcyONxeSaQ9Xd2y' + #$0D#$0A +
        'WY4AyegAAwABXybYft83SWyre/C6Gab+J4deMan6KYGI/OuQ+I37bnxJ1zT5LLw1pGk+G1kXDXKb' + #$0D#$0A +
        'rm4XjHys+EHf+Anpgiu/65goNzjv6HysuH+JMTCOHrN8i2vNNfcm3p6Hr3/BTH4sWGi/D0/DLS7q' + #$0D#$0A +
        'OXV9cZH1FEYE2lqrBwGx91nYLgf3Q3qM/Be6pdY1K/1XVLjUtTvZ7y8upDJPcXEhkklc9WZjyT9a' + #$0D#$0A +
        'rbvevGxWIdepzs/RMlyunleEVCLu92+7/rQ/RH/gl2c/s13H/Yfuf/RcNXf+CmBx+y7df9hW0/8A' + #$0D#$0A +
        'QjXyN8Bf2mfHfwk8Dv4W8OaT4durN7x7syahbTvLvdVBGUmQYwg7evNS/HP9qDx98VfAUnhLxDpH' + #$0D#$0A +
        'hu1spLiOcyWFtOku5CSBl5nGOfSvQWMpfVPZdbWPk5cOY9599dsvZ8/Nvra/Y8Z3Ubqj3e9G73rx' + #$0D#$0A +
        'z9D5iTdRuqPd70bvegOYv6FquoaLrVpq+lXctpfWM6T21xE2GikUgqw9wQK/Sr9k39oHw78XfDsN' + #$0D#$0A +
        'jdTwWHi22h/07TSdomIHMsGT8yHqRyV6HjDH8xt3vUtjeXNleRXdncy29xA4eKaFyjxsDkMrDkEe' + #$0D#$0A +
        'orqwuKnh5XWqfQ8LPMjoZtRUZvlmtpfo+6P2A8eeEPDHjXQW0XxXolnq1ix3eVcx7tjf3kbqje6k' + #$0D#$0A +
        'GvFdQ/Yx+C1xffaIYNetI85+zw6lmPr0y6s3t96vmT4Z/ti/F7wtbx2eqXOn+JrWPgf2pCfPC+gl' + #$0D#$0A +
        'jKkn3cMa9Js/2+rlYALv4Wwyyd2i14xr+Rt2/nXrPGYKrrUWvmj4SHD/ABJgG4YWfu/3ZWX3No+k' + #$0D#$0A +
        'vhX8C/hZ8PLhLzw14StUv4+Vv7stc3Cn1V5Cdh/3MV397c29nZyXd3cRW9vCheWWVwiIo6lmPAA9' + #$0D#$0A +
        'TXwl4s/bt8b3cLR+HfBuiaWWBHmXc0l2y+4x5Yz9Qa8I+K3xf+I/xHkI8X+K72+ttwZbJWEVqpHQ' + #$0D#$0A +
        'iFMJkepBPvSlmOHpRtSV/wAEOlwfm2Nq+0xtS3m3zP8Ay/E93/4KLfG/wd4/s9N8FeD7g6nHpN8b' + #$0D#$0A +
        'u61OM/6OzbGQRxH+P7xJYfLwMbs5HytuqPd70bvevGrVpVpuctz9IyzAUcuwscPRvZd99T23/gn0' + #$0D#$0A +
        'f+MtPCH/AF2vP/Tdd1+mVfmx/wAE4tOnvv2qNBuY1LLp8F5dSkfwr9mkhz/31cKPxr9J69zK1bD/' + #$0D#$0A +
        'ADPy7jialmqt0ivzYVyviVtt7P8A9fR/9Ew11Vcd4wbbey/9fTf+iYa9I+OKXmUeZVTzKPMoAt+Z' + #$0D#$0A +
        'R5lVPMo8ygC35lHmVU8yjzKAMz4peG7Txr8PdX8LXr7I9UtWiWTGTE/VHA9VcK34V+aPjrw7qvhj' + #$0D#$0A +
        'xPe6NrNqba8spjHcR9lb1HqpGCD3Br9QfMrhPjD8J/BnxIiR9esWS+hXbDf2z+XMg9Cf4h7NkVxY' + #$0D#$0A +
        'zCe3irPVH0vDmfvKqklNXpy37p90fnDkUZFfZjfsgeDCxI8Wa8ATwPKtTj/yFR/wyB4N/wCht17/' + #$0D#$0A +
        'AL82v/xqvL/suv5H2/8ArxlnaX3f8E+M8ijIr7M/4ZA8G/8AQ269/wB+bX/41R/wyB4N/wCht17/' + #$0D#$0A +
        'AL82v/xqj+y6/kH+u+Wdpfd/wT4zyKMivsz/AIZA8G/9Dbr3/fm1/wDjVH/DIHg3/obde/782v8A' + #$0D#$0A +
        '8ao/suv5B/rvlnaX3f8ABPjPIoyK+zP+GQPBv/Q269/35tf/AI1R/wAMgeDf+ht17/vza/8Axqj+' + #$0D#$0A +
        'y6/kH+u+Wdpfd/wT4zyKMivsz/hkDwb/ANDbr3/fm1/+NUf8MgeDf+ht17/vza//ABqj+y6/kH+u' + #$0D#$0A +
        '+Wdpfd/wT4zyKMivsz/hkDwb/wBDbr3/AH5tf/jVH/DIHg3/AKG3Xv8Avza//GqP7Lr+Qf675Z2l' + #$0D#$0A +
        '93/BPjPIoyK+5vDv7E3gXUFzL4x8Rr+5V/litOpeRf8Anj/sD8zWn/wwp4A/6HTxN/36s/8A4zR/' + #$0D#$0A +
        'ZdfyD/XfLO0vu/4J8DZFGRX3z/wwp4A/6HTxN/36s/8A4zR/wwp4A/6HTxN/36s//jNH9l1/IP8A' + #$0D#$0A +
        'XfLO0vu/4J8DZFGRX3z/AMMKeAP+h08Tf9+rP/4zR/wwp4A/6HTxN/36s/8A4zR/ZdfyD/XfLO0v' + #$0D#$0A +
        'u/4J8DZFOjVpG2qOf5V97/8ADCngD/odPE3/AH6s/wD4zXT/AAz/AGPvhZ4U1qLU75tS8QyW7h4o' + #$0D#$0A +
        'tSdBCGB4LRxqqt9GBFOOV1m9WiKnHOXRg3CMm/RL9TnP+CZnwru/C/g6+8f6zbNDd+IIkg02ORcM' + #$0D#$0A +
        'top3GTHUeY2Dj+7Gh719S02NEjjWONQqqMKqjAA9BTq9ylTjSgoLofmOPxlTG4meIqbyf9IK4nxw' + #$0D#$0A +
        '2L6T/r6b/wBEwV21cL8QCRev/wBfT/8AomCtDkMbfRvqtuNG40BYs76N9Vtxo3GgLFnfRvqtuNG4' + #$0D#$0A +
        '0BYs76N9Vtxo3GgLFnfRvqtuNG40BYs76N9Vtxo3GgLFnfRvqtuNG40BYs76N9Vtxo3GgLFnfRvq' + #$0D#$0A +
        'tuNG40BYs76N9Vtxo3GgLHd+AzmHP/TrH/6Nnroa5v4fnFqM/wDPqn/o2eujyPWgBaKTI9aXIoAK' + #$0D#$0A +
        'KKKACiiigAooooAK5XxvYNcSN5Yy0hDx/wC+Bgr+K7cf7vvXUt92sbXYjLC0bLuVhyCOtAHnkisj' + #$0D#$0A +
        'FXUqwPII6Ulb18dRj4SeUgdA/wA+P++s1m3F3rK/dkH/AH6T/CgdynRSy6nry9JF/wC/Kf4VXk1j' + #$0D#$0A +
        'xCvSRP8Avwn+FAXJ6KpSa74kHSSP/vwv+FRN4g8TD/lpH/4Dp/hQFzSorKbxF4nH/LSP/wAB1/wp' + #$0D#$0A +
        'h8S+KP8AnpF/4Dr/AIUBc2KKxT4m8UD/AJaRf+A6/wCFJ/wlHin/AJ6Rf+A6/wCFAXNuisI+KfFX' + #$0D#$0A +
        '/PSL/wAB1/wpP+Eq8Vf89If/AAHX/CgLm9RWD/wlXir/AJ6Q/wDgOv8AhR/wlXir/npD/wCA6/4U' + #$0D#$0A +
        'Bc3qKwf+Ep8Vf89If/Adf8KcvijxT/z0i/8AAdf8KAublFYg8T+Kf+ekX/gOv+FOHibxQf8AlpF/' + #$0D#$0A +
        '4Dr/AIUBc2amsbaa6nEUK5Pc9lHqT2FYa+JPFB/5aRf+A6/4VFf6v4kvoPInupPKJyY0G1T9QKAu' + #$0D#$0A +
        'd5p2vWlkzxwyAooWNT6hR1/Elj+NXV8Uwn+MfnXlMcF//tVYjgv/APaoEeqR+JoT/GKmj8Qwn+MV' + #$0D#$0A +
        '5fDBf/7VXLeC+/2qAPTItbhb+IVbt9RjkPDV53ZQ3med1b+jx3AZd2aAOyikDjipKp6eGEYzVygA' + #$0D#$0A +
        'ooooAKimhV+oqWigChLp0TclaryaPC38IrXooAw30KA/wD8qibw9Af4B+VdDRQBzLeG4P7g/KmN4' + #$0D#$0A +
        'ZgP/ACzH5V1OBSYHpQByjeGIP7g/KmHwtB/zzH5V12B6UYHpQBx58Kwf88x+VN/4RSD/AJ5j8q7L' + #$0D#$0A +
        'A9KNo9KAOMbwnD/zzH5U3/hEoP8AnmPyrtNo9KNo9KAOL/4RKD/nmPyo/wCESg/55j8q7TaPSjaP' + #$0D#$0A +
        'SgDi/wDhE4f+eY/KnL4Tg/55j8q7LaPSjaPSgDjx4Ug/55j8qcPCsH/PMflXX7R6UYHpQByQ8LQD' + #$0D#$0A +
        '/lmPyp6+GIB/yzFdVgelGB6UAcwvhqAfwD8qkXw5AP4B+VdHgelLQBz66BAP4B+VTJokA/gFbVFA' + #$0D#$0A +
        'GXHpMK/wirENjGnRauUUANjQL0p1FFABRRRQB//Z' + #$0D#$0A;

    end
    else
    begin
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

      if isCommand('Zeitstempel') then
      begin
        NewValue := zeitstempel_F(NewValue);
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

      if isCommand('^E') then
      begin
        if (NewValue = '') then
        begin
          strings[n] := XMLEmpty(copy(strings[n], 1, pred(k)) + Rest);
          Rest := '';
          k := 0;
        end;
        continue;
      end;

      // remove tailing and inner Double-Blanks
      if isCommand('^T') then
      begin
        ersetze('  ', ' ', self, n);
        continue;
      end;

      if isCommand('^Y') then
      begin
        if (NewValue = '') then
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

    // Aufbereitung des strings[n] überhaupt noch gewünscht?
    if (k > 0) then
    begin
      if RawMode then
        strings[n] := copy(strings[n], 1, pred(k)) + NewValue + Rest
      else
        strings[n] := copy(strings[n], 1, pred(k)) + Ansi2html(NewValue) + Rest;
    end;

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
      { } DebugLogPath +
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
      if (k > 0) then
      begin
        pName := copy(FullPage[CB_LastChecked], 1, pred(k));

        // "verbotene" Konsumenten haben soo hohe Kosten
        // dass deren vorkommen sofort zum PageBreak führt
        if (pos('!' + pName + ',', CB_Producer + ',') > 0) then
          inc(result, 1024);

        // normale Konsumer verbrauchen so viel wie er
        // Zeilen liefert
        if (pos(pName + ',', CB_Producer + ',') > 0) then
          inc(result, charCount(#13, copy(FullPage[CB_LastChecked], succ(k), MaxInt)) + 1);
      end;
      inc(CB_LastChecked);
      if (CB_LastChecked = FullPage.count) then
        break;

    until (result > 0) and (pos(cPageBreakHerePossible, FullPage[CB_LastChecked]) = 1);

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
              { } IntToStrN(PhaseCount, 3) + '-' + IntToStrN(n, 4) + ' ' + OneLine,
              { } DebugLogPath +
              { } cCommandLogFName);

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
                addFatalError('html.Command "' + Command + '" unknown');

            until yet;
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
      WriteValueQuick(nextp(SystemHeap[n], '=', 0), nextp(SystemHeap[n], '=', 1));
      WriteValueQuick('_' + nextp(SystemHeap[n], '=', 0), nextp(SystemHeap[n], '=', 1));
    end;
  end;

  procedure FillGlobalData;
  begin
    ExecAndFill(false, 0, MaxInt);
    WriteValue(cSeite, IntToStr(Seite));
    WriteValue(cSeiten, IntToStr(Seiten));
  end;

  function insideComment(const s: AnsiString): string;
  var
    n: integer;
  begin
    result := '';
    for n := 1 to length(s) do
      if (ord(s[n]) > 127) then
        result := result + '#$' + inttohex(ord(s[n]), 2)
      else
        result := result + String(s[n]);
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

            FName := copy(strings[n], succ(length(cHTML_ComputeFile)), pred(k - length(cHTML_ComputeFile)));
            PreFName := FileName + '.';
            if not(FileExists(PreFName + FName)) then
              PreFName := ExtractFilePath(FileName);
            IncludeList.add(PreFName + FName);

            ComputeVorlage := THTMLTemplate.create;
            ComputeVorlage.LoadFromFile(PreFName + FName);
            ComputeVorlage.OhneRohdaten := true;
            ComputeVorlage.WriteValue(FullPage);
            ComputeVorlage.insert(0, cHTML_BeginBlock + FName + cHTML_Comment_PostFix);
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
    FullPage.SaveToFile(DebugLogPath + 'WriteValue.txt');
    DebugSave('Init');
    AppendStringsToFile(
      { } FileName,
      { } DebugLogPath +
      { } cCommandLogFName);
  end;
  Compute;

  // Bedarf aller Seiten bestimmen
  FreiCount_Single := CalcFreiraum(cPageSingle, FreiCount_Single_Killer);
  FreiCount_First := CalcFreiraum(cPageFirst, FreiCount_First_Killer);
  FreiCount_Next := CalcFreiraum(cPageNext, FreiCount_Next_Killer);
  FreiCount_Last := CalcFreiraum(cPageLast, FreiCount_Last_Killer);

  repeat
    // a) prüfen, ob erste Seite reicht?
    if (CalcBedarf(FreiCount_Single_Killer, 0) <= FreiCount_Single) then
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
        if (LookForwardBlock + ActPageFilled > FreiCount_First) and (ActPageFilled > 0) then // eben voll geworden
          break; // raus ohne zu füllen
        inc(ActPageFilled, CBnext);
      until eternity;

      // Rest auf "next" und "Last" verteilen
      // passt der Rest auf "last"?
      CB_Producer := FreiCount_Next_Killer;
      repeat
        if (CalcBedarf(FreiCount_Last_Killer, CB_LastChecked) <= FreiCount_Last) then
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
            if (LookForwardBlock + ActPageFilled > FreiCount_Next) and (ActPageFilled > 0) then
              break; // raus ohne zu füllen
            inc(ActPageFilled, CBnext);
          until eternity;
          if (LookForwardBlock = 0) then
            // ich bringe auf next nichts mehr unter ->
            // es muss sich um Daten handeln, die nur auf die
            // letzte Seite passen!
            break;
        end;
      until eternity;

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
        until eternity;

        // lokale Daten füllen
        ExecAndFill(false, max(succ(FD_local), LastExecuted), CB_LastChecked);
        LastExecuted := CB_LastChecked;

        // weiter
        inc(Seite);

      until (Seite > Seiten);

      WriteHeap;
      break; // fertig

    end;

  until eternity;

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
      strings[n] := copy(strings[n], 1, pred(k)) + Ansi2html(NewValue1) + '<br>' + Ansi2html(NewValue2) +
        copy(strings[n], k + length(VarName) + 2, MaxInt);
    end;
  end;
end;

procedure THTMLTemplate.WriteValue(BlockName, VarName: string; NewValue: TStrings);
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
          insert(n, copy(SourceStr, 1, pred(k)) + Ansi2html(NewValue[l]) + copy(SourceStr,
            k + length(VarName) + 2, MaxInt));
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
      { } DebugLogPath +
      { } cCommandLogFName);
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
        { } DebugLogPath +
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
        { } DebugLogPath +
        { } cCommandLogFName);
      SaveToFile(
        { } DebugLogPath +
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

// LOAD BLOCKs
//
// get a Block from serveral sources and insert it at _BlockStart
//

procedure THTMLTemplate.LoadBlock(atIndex: integer; NewStrings: TStrings);
var
  n: integer;
begin
  _BlockStart := min(atIndex, count - 1);
  _BlockEnd := pred(_BlockStart + NewStrings.count);

  for n := 0 to pred(NewStrings.count) do
    insert(_BlockStart + n, NewStrings[n]);
end;

procedure THTMLTemplate.LoadBlock(FromBlock, AsBlock: string; KillInsertMark: boolean = false);
var
  k: integer;
  BlockName: string;
begin
  FromBlock := ensureContent(FromBlock);

  if (FromBlock = '') then
    FromBlock := AsBlock;
  // Suche Block, den man einfügen muss
  repeat

   k := Blocks.indexof(FromBlock);
   if (k<>-1) then
   begin
     BlockName := FromBlock;
     break;
   end;

   if FromBLock=AsBlock then
    break;

   k := Blocks.indexof(AsBlock);
   if (k<>-1) then
   begin
     BlockName := AsBlock;
     break;
   end;

  until yet;

  if (k <> -1) then
  begin
    if DebugMode then
      AppendStringsToFile(
        { } IntToStrN(PhaseCount, 3) + ': loadBlock(' + BlockName + ')',
        { } DebugLogPath +
        { } cCommandLogFName);
    LoadBlock(BlockName, AsBlock, TStringList(Blocks.Objects[k]), KillInsertMark);
  end
  else
  begin
    if (FromBlock=AsBlock) then
     addFatalError('Block "' + FromBlock + '" nicht gefunden')
    else
     addFatalError('Block "' + FromBlock + '" (sowie Fallback "' + AsBlock + '") nicht gefunden');
  end;
end;

procedure THTMLTemplate.LoadBlock(FromBlock, AsBlock: string; NewStrings: TStrings; KillInsertMark: boolean = false);
var
  InsertAt: integer;
begin
  InsertAt := -1;
  FromBlock := ensureContent(FromBlock);
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
    addFatalError('"[!-- INSERT|END ' + FromBlock + '|' + AsBlock + ' --]" nicht gefunden!');

  until yet;

  // Gefundene Marke löschen?!
  if KillInsertMark then
    if (InsertAt <> -1) then
      delete(InsertAt);

  // Daten laden
  if (InsertAt <> -1) then
    LoadBlock(InsertAt, NewStrings)
end;

procedure THTMLTemplate.LoadBlock(Block: string; NewStrings: TStrings; KillInsertMark: boolean = false);
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
  SearchStr: String;
begin
  result := -1;
  SearchStr := cHTML_BeginBlock + Block + cHTML_Comment_PostFix;
  for n := 0 to pred(count) do
    if (pos(SearchStr, strings[n]) = 1) then
    begin
      result := n;
      break;
    end;
end;

function THTMLTemplate.findBlockEnd(Block: string): integer;
var
  n: integer;
  SearchStr: String;
begin
  result := -1;
  SearchStr := cHTML_EndBlock + Block + cHTML_Comment_PostFix;
  for n := pred(count) downto 0 do
    if (pos(SearchStr, strings[n]) = 1) then
    begin
      result := n;
      break;
    end;
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
  if forceUTF8 then
    Outs.SaveToFile(FName, TEncoding.UTF8)
  else
    OutS.SaveToFile(FName);
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
        DatumBlock := ExtractSegmentBetween(copy(NewStrings[n], l + 4, MaxInt), '(', ')');
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
    (* - *) , #026 (* - *) , #027 (* - *) , #038 (* raw & *) , #029 (* - *) , #030
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

  until yet;

end;

function AnsiToRFC1738(s: string): string;
var
  n: integer;
begin
  result := '';
  for n := 1 to length(s) do
    if CharInSet(s[n], ['-', '.', ',', '?', ':', '&', '@', '=', ';', '/', '_', '0' .. '9', 'a' .. 'z', 'A' .. 'Z']) then
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
    result := copy(result, 1, pred(k)) + chr(strtoint('$' + copy(result, k + 1, 2))) + copy(result, k + 3, MaxInt);
  until eternity;
end;

procedure THTMLTemplate.ClearBlock(Block: string);
var
  n: integer;
begin
  for n := pred(findBlockEnd(Block)) downto succ(findBlockBegin(Block)) do
    delete(n);
end;

procedure THTMLTemplate.DeleteBlock(Block: string);
var
  bs, be, n: integer;
begin
  if DebugMode then
  begin
    AppendStringsToFile(
      { } IntToStrN(PhaseCount, 3) + ': deleteBlock(' + Block + ')',
      { } DebugLogPath +
      { } cCommandLogFName);
  end;
  bs := findBlockBegin(Block);
  be := findBlockEnd(Block);
  if (bs >= 0) and (be >= 0) then
    for n := be downto bs do
      delete(n);
end;

procedure THTMLTemplate.Dereference(Options: string);
{$IFNDEF fpc}
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
        result := '<!-- Element <' + cTag + '> in ' + FoundTags + ' not found! -->';
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

    until eternity;
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
          addFatalError('Referenzquelle "' + ExtractFileName(pFName) + '" nicht gefunden')
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

        Tag := copy(strings[n], k + length(cReferenceDelimiterBegin), l - k - length(cReferenceDelimiterBegin));
        if Tag = '' then
        begin
          inc(n);
          continue;
        end;

        strings[n] :=
        { } copy(strings[n], 1, pred(k)) +
        { } blow(Tag) +
        { } copy(strings[n], l + length(cReferenceDelimiterEnd), MaxInt);

      until eternity;
      XML.Free;

    end
    else
    begin
      addFatalError('"' + Key + '" in Datei "' + pFName + '" nicht gefunden');
    end;
  end;
end;
{$ELSE}

begin
  raise exception.create('Error');
end;

{$ENDIF}

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
    ersetze(copy(result, k, l), chr(StrtoIntDef(copy(result, k + 2, l - 3), ord('?'))), result);
  until eternity;
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
        IncludeFName := copy(strings[n], succ(length(cHTML_IncludeFile)), pred(k - length(cHTML_IncludeFile)));
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
  until eternity;
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
            DokumentNumberOfCopies := StrtoIntDef(nextp(copy(strings[n], length(cHTML_Copies) + 1, MaxInt), ' ', 0), 0);
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
          if (pos(cHTML_FormFeed_Class, strings[n]) > 0) then
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
      if (pos(cHTML_FormFeed_Class, strings[EndPage]) > 0) then
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
          k := max(pos('<body ', strings[Pline]), pos('</head>', strings[Pline]));
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
              SingleForm.add(ReadAttrValue('name') + '=' + ReadAttrValue('value'));
              break;
            end;

            k := pos('<textarea ', strings[Pline]);
            if (k > 0) then
            begin
              // name und value
              SingleForm.add(ReadAttrValue('name') + '=');
              break;
            end;

          until yet;
        end;

    end;
    if pos('</body>', strings[Pline]) > 0 then
      break;
    inc(Pline);
  until eternity;
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
      result := result + nextp(TheAttributes[n], '=', 0) + '=' + AnsiToRFC1738(nextp(TheAttributes[n], '=', 1));

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
  until eternity;
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
  HomeLine: integer;
  Body_Start, Body_end, HTML_end: integer;
  n: integer;
  FirstNewStyle: Integer;

  nDocument: TStringList;
  nStyle: TStringList;

  // Automata
  Automatastate: integer;
  Mission_complete: boolean;
  LineString: string;

begin
  // aktuelles Dokument parsen
  nStyle := nil;
  FirstNewStyle := 0;
  Automatastate := 0;
  for n := 0 to pred(Count) do
    case Automatastate of
     0 :
        if StartTokenIs('<STYLE', n, self) then
        begin
          nStyle := TStringList.create;
          inc(Automatastate);
        end;
     1 :
        if StartTokenIs('</STYLE', n, self) then
        begin
          FirstNewStyle := nStyle.count;
          break;
        end
        else
        begin
          if (Strings[n] <> '<!--') then
            if (Strings[n] <> '-->') then
            begin
             LineString := cutblank(Strings[n]);
             if (nStyle.IndexOf(LineString)=-1) then
               nStyle.add(LineString);
            end;
        end;

    end;


  // Dokument-Fortsetzung laden
  nDocument := TStringList.create;
  nDocument.LoadFromFile(FName);

  //
  Body_Start := -1;
  Body_end := -1;
  HTML_end := -1;

  // die ganzen Tag-Lines den "neuen" Dokumentes bestimmen!
  Automatastate := 0;
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
          if not(assigned(nStyle)) then
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
            begin
             LineString := cutblank(nDocument[HomeLine]);
             if (nStyle.IndexOf(LineString)=-1) then
               nStyle.add(LineString);
            end;
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
            for n := FirstNewStyle to pred(nStyle.count) do
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
              insert(HomeLine, cHTML_FormFeed);
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
  FreeAndNil(nDocument);
  if assigned(nStyle) then
    FreeAndNil(nStyle);

  if not(Mission_complete) then
  begin
    // Fehler im B Dokument
    addFatalError('Parser steckt im Status ' + IntToStr(Automatastate) + ' fest');
  end;

  // Es gab Fehler?
  if (Messages.count > 0) then
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
      if (pos(cHTML_FormFeed_Class, strings[EndPage]) > 0) then
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

function THTMLTemplate.ensureContent(Block:String):String;
// Block has the Syntax
// BlockName[{"|"BlockName}]
var
 CheckBlock : String;
 k : Integer;
begin

   // some work to do?
   if (pos('|',Block)=0) then
   begin
     // no alternatives -> exit
     result := Block;
     exit;
   end;

   CheckBlock := nextp(Block,'|');
   while (CheckBlock<>'') do
   begin
     // check if exists and has content
     k := Blocks.IndexOf(CheckBlock);
     if (k<>-1) then
      if assigned(Blocks.Objects[k]) then
       if (TStringList(Blocks.Objects[k]).Count>0) then
       begin
         result := CheckBlock;
         exit;
       end;
     CheckBlock := nextp(Block,'|');
   end;
   result := '';
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

//
// detects an empty element and repalce it to the short form
// <tag></tag> -> <tag/>
//

function XMLEmpty(s: string): string;
var
  i, j: integer;
begin
  result := s;
  i := pos('<', result);
  j := pos('></', result);
  if (i > 0) and (j > 0) then
    result :=
    { blanks, tag-name } copy(result, 1, pred(j)) +
    { empty element mark } '/>';
end;

function Uni2html(code:Integer):string;
begin
  result := cAmpersand+'#'+IntTostr(code)+';';
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
