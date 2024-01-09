{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2016  Andreas Filsinger
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
unit Sperre;

{$ifdef fpc}
{$mode delphi}
{$endif}

interface

uses
  {$ifndef fpc}
  System.UITypes,
  {$else}
  fpchelper, graphics,
  {$endif}
  classes,
  anfix,
  dateutils,
  gplists;

{ S P E R R E

  "Sperren" sind Zeitfenster in denen andere Bedingungen gelten als ausserhalb
  dieser Zeitfenster. Im Resource-Management haben Sperren eine
  zentrale Bedeutung für Verfügbarkeitsprüfung und Steuerung von
  Ausnahmen und Feinheiten. Sperren werden verwendet für z.B.

  * Laufzeit einer Baustelle
  * Urlaub eines Monteures
  * Arbeitszeitmodelle
  * Feiertage

  TSperre ist eine Objekt-Klasse die Sperren einlesen und speichern kann.
  TSperre ermöglicht ein schnelles Testen, ob ein Datum inerhalb einer Sperre
  liegt oder nicht.

  Sperren können als Text formuliert und in die TSperre eingelesen werden:

  Sperre = ZeitraumSperre|WochentagsSperre
  WochentagsSperre = 'Mo'|'Di'|'Mi'|'Do'|'Fr'|'Sa'|'So' [ 'V' | 'N' ]
  ZeitraumSperre = Datum [ '-' Datum ] [ WochentagsSperre ] [Wiederholungen]
  Datum = 'TT.MM.JJJJ' [ 'V' | 'N' ]
  Wiederholungen = Anzahl 'X'

}

const
  cSperre_ZeitAngabe_Vormittag = 'V';
  cSperre_ZeitAngabe_Nachmittag = 'N';
  cSperre_ZeitAngabe_Mittag = 'M';
  cSperre_ZeitAngabe = [
  { } cSperre_ZeitAngabe_Vormittag,
  { } cSperre_ZeitAngabe_Nachmittag,
  { } cSperre_ZeitAngabe_Mittag];
{$ifdef fpc}
cSperre_ColourDefault = $20000000;
cSperre_ColourRed = $0000FF;
{$else}
cSperre_ColourDefault =     TColors.SysDefault;
cSperre_ColourRed =     TColors.Red;
{$endif}


var
  sDiagnose: TStringList;
  TestMode: boolean = false;

type
  PSperreRecord = ^TSperreRecord;

  TSperreRecord = record
    // Ist der angegebene Zeitraum gesperrt (true) oder
    // ist alles ausserhalb des angegebenen Zeitraums gesperrt
    // default=true
    BadPeriod: boolean;

    // Ergebnis Bei Prüfung: Es wird immer die passende Sperre mit der höchsten
    // Prioritaet geliefert
    //
    Prioritaet: Integer;

    // Beginn der Sperre (Datum, Uhrzeit)
    // dieser Startpunkt ist bereits gesperrt
    StartD: TDateTime;

    // Ende der Sperre (Datum, Uhrzeit)
    // dieser Endpunkt ist noch gesperrt
    EndeD: TDateTime;

    // Ist es eine Wochentag-Bezogene also repetierende Sperre
    // Ist Wochentag<>0 so gilt die Sperre nur an diesem Wochentag und NICHT
    // an den anderen Tagen des angegebenen Zeitraumes StartD und EndeD
    // die Zeitangaben in StartD und EndeD beziehen sich auch auf diesen Wochentag
    //
    // 0 = keine Einschränkung auf gewissen Wochentag
    // 1..7 = Sonntag..Samstag
    //
    Wochentag: Integer;

    // Gültigkeitskontext  (ehemals z.B. StateIndex)
    // Damit kann man zusätzliche Sperr-Zeiträume markieren, die nur
    // in einem gewissen Kontext sichtbar sind. Somit kann man in
    // einer gemeinsamen Sperre verschiedene Kontexte abspeichern.
    //
    // 0 = Für alle Sperr-Anfragen uneingeschränkt gültig
    // >0 = Greift zusätzlich für genau diesen Kontext gültig
    // <0 = Eingangsschwellwert
    Kontext: Integer;

    // rein informatives Textfeld, z.B.
    // * Grund, warum die Sperre besteht
    // * Verursacher der Sperre usw.
    // * Kommentar zur Sperre
    GrundKurz: ShortString;

    // Farbe, die im Fall der Verletzung der Sperre ausgegeben wird!
    BadColor: TColor;
  end;

  TSperre = class(TObject)
  private
    FGrund: string;
    TheData: array of TSperreRecord;
    procedure put(Index: Integer; d: TSperreRecord);
    function get(Index: Integer): TSperreRecord;
  public
    destructor Destroy; virtual;
    constructor Create;

    class function DateTimeInside(TheDate, a, b: TDateTime): boolean;
    class function DateInside(TheDate, a, b: TDateTime): boolean;
    class function DateAbstand(TheDate, a, b: TDateTime): Integer;
    class function TimeInside(TheDate, a, b: TDateTime): boolean;
    class function WochenTagAsInt(s: string): Integer;
    class function HitAt(const sr: TSperreRecord; const pDatum: TDateTime;
      const pKontext: Integer): boolean;
    // Rückgabewert: Abstand des Prüflings zum angegebenen Datensatz
    // "-1" Vorbedingungen nicht erfüllt - kein Abstand gemessen
    // "0" passt 100%
    // n Abstand in Tagen
    class function Distance(const sr: TSperreRecord; const pDatum: TDateTime;
      const pKontext: Integer): Integer;
    class procedure Reset(var r: TSperreRecord);

    procedure Clear;
    procedure Add(StartDatum, EndeDatum: TDateTime; IsBadPeriod: boolean;
      ColorIfBad: TColor; AnzeigePrioritaet: Integer = 0); overload;
    procedure Add(StartDatum, EndeDatum: TANFIXDAte; IsBadPeriod: boolean;
      ColorIfBad: TColor; AnzeigePrioritaet: Integer = 0); overload;
    function Add: Integer; overload;
    procedure Add(const sr: TSperreRecord); overload;
    function AsString(const sr: TSperreRecord): string;

    // Rückgabewert: cldefault für "kein" Treffer, ansonsten die "BadColor" des
    // Treffers mit der höchsten Priorität
    function CheckIt(pDatum: TDateTime; pKontext: Integer = -1): TColor;

    // Rückgabewert: "leer" für "kein" Treffer, ansonsten alle Treffer
    function CheckEm(pDatum: TDateTime; pKontext: Integer = -1): TgpIntegerList;

    // Rückgabewert: BadColor des am nächsten liegenden Termines
    // Logisch: Kontext muss stimmen
    function CheckNear(pDatum: TDateTime; pKontext: Integer = -1): TColor;

    function ReadfromMemo(
      { } M: TStrings;
      { } Wertigkeit: TStrings;
      { } Umstand: TStrings = nil;
      { } pKontext: Integer = 0): Integer; // [Count]

    procedure SaveToFile(FName: string);
    function Count: Integer;
    function Kontexte: TgpIntegerList;
    function MinDate(pKontext: Integer = -1): TDateTime;
    function MaxDate(pKontext: Integer = -1): TDateTime;

    property Grund: string read FGrund;
    property Sperre[Index: Integer]: TSperreRecord read get write put; default;
  end;

  TAuslastungZelle = class(TObject) // eine einzelne Zelle
  public

    // Terminanzahl-Angaben
    AnzahlIst: Integer; // Diese sind schon erledigt AnzahlIst<=AnzahlSoll
    AnzahlSoll: Integer;
    // In wievielen Aufträgen wurde Aufwand summiert (nur bei AUFWAND>0)

    // Zeitangaben
    Aufwand: TAnfixTime; // an diesem Halbtag
    Kapazitaet: TAnfixTime;

    // Auf welchen Baustellen?
    Baustellen: TList;

    function TerminAnzahl: string;
    function TerminDauer: string;
    function Last: string;
    procedure BaustelleAdd(BAUSTELLE_R: Integer);
    destructor Destroy; virtual;
    constructor Create;
    procedure Clear;
  end;

  TAuslastungRow = class(TObject)
  private
    fBaustellen: TList;
    fBaustellenAssigned: boolean;
    Cols: array of TAuslastungZelle;
    fTitle: string;
    procedure put(Index: Integer; const s: TAuslastungZelle); virtual;
    function get(Index: Integer): TAuslastungZelle; virtual;
    function GetBaustellen: TList;
    function Count: Integer;
  public

    property Title: string read fTitle write fTitle;
    property Column[Index: Integer]: TAuslastungZelle read get
      write put; default;
    property Baustellen: TList read GetBaustellen;
    function EigeneBaustelle(RID: Integer): boolean;
    function AnzahlIst: Integer;
    function AnzahlSoll: Integer;
    destructor Destroy; virtual;
    constructor Create;
    procedure Clear;
  end;

  TAuslastung = class(TObject)
  private
    Monteure: TStringList;
    Rows: array of TAuslastungRow;
    procedure put(Index: Integer; const s: TAuslastungRow); virtual;
    function get(Index: Integer): TAuslastungRow; virtual;
    function GetRID(Index: Integer): Integer;
    procedure PutRID(Index: Integer; const Value: Integer);
  public
    Mode: Integer;

    function Count: Integer;
    property Row[Index: Integer]: TAuslastungRow read get write put; default;
    property RID[Index: Integer]: Integer read GetRID write PutRID;
    procedure Add(s: string; RID: Integer);
    function IndexOf(s: string): Integer; overload;
    function IndexOf(RID: Integer): Integer; overload;
    procedure SortBy(BAUSTELLE_R: Integer);
    destructor Destroy; virtual;
    constructor Create;
    procedure Clear;
    procedure Pack;
    procedure Delete(Index: Integer);
  end;




function cTime_23_59_59: TDateTime;
function cTime_12_00_00: TDateTime;
function cTime_14_00_00: TDateTime;
function cTime_09_00_00: TDateTime;

// Wenn morgens -> dann Nachmittags
// Wenn nachmittags -> dann Morgens
function e_r_AndererHalbtag(DATUM: TDateTime): TDateTime;

// Routinen für die Qualitätsbeurteilung

const
  cQ_Prefix = '[Q';
  cQ_Postfix = ']';
  cQ_Delimiter = '|';
  cQ_erloesend = 'erlösend';
  cQ_unkritisch = 'unkritisch';
  cQ_kritisch = 'kritisch'; // ist default, wird nicht explizit geprüft!!

function QS_gut(const sQS: string; const BrisanzTabelle: TStringList): boolean;
function QS_kritisch(const sQS: string; const BrisanzTabelle: TStringList)
  : TStringList;
procedure QS_add(qAktuell: string; var qAlle: string);

implementation

uses
  math, html, SysUtils;

class function TSperre.WochenTagAsInt(s: String): Integer;
begin
  if (s = 'SO') or (s = 'SONNTAG') then
    Result := 1
  else if (s = 'MO') or (s = 'MONTAG') then
    Result := 2
  else if (s = 'DI') or (s = 'DIENSTAG') then
    Result := 3
  else if (s = 'MI') or (s = 'MITTWOCH') then
    Result := 4
  else if (s = 'DO') or (s = 'DONNERSTAG') then
    Result := 5
  else if (s = 'FR') or (s = 'FREITAG') then
    Result := 6
  else if (s = 'SA') or (s = 'SAMSTAG') then
    Result := 7
  else
    Result := -1;
end;

class function TSperre.DateTimeInside(TheDate, a, b: TDateTime): boolean;
begin
  Result := (TheDate >= a) and (TheDate <= b);
end;

class function TSperre.DateAbstand(TheDate, a, b: TDateTime): Integer;
begin
  Result := Min(trunc(abs(TheDate - a)), trunc(abs(TheDate - b)));
end;

class function TSperre.DateInside(TheDate, a, b: TDateTime): boolean;
begin
  TheDate := trunc(TheDate);
  a := trunc(a);
  b := trunc(b);
  Result := (TheDate >= a) and (TheDate <= b);
end;

class function TSperre.TimeInside(TheDate, a, b: TDateTime): boolean;
begin
  TheDate := TheDate - trunc(TheDate);
  a := a - trunc(a);
  b := b - trunc(b);
  Result := (TheDate >= a) and (TheDate <= b);
end;

procedure TSperre.Add(StartDatum, EndeDatum: TDateTime; IsBadPeriod: boolean;
  ColorIfBad: TColor; AnzeigePrioritaet: Integer = 0);
begin
  with TheData[Add] do
  begin
    StartD := StartDatum;
    if (dateTime2Seconds(EndeDatum) = 0) then
      EndeD := EndeDatum + cTime_23_59_59
    else
      EndeD := EndeDatum;
    BadPeriod := IsBadPeriod;
    BadColor := ColorIfBad;
    Prioritaet := AnzeigePrioritaet;
    Kontext := 0;
    Wochentag := 0;
    GrundKurz := '';
  end;
end;

procedure TSperre.Add(StartDatum, EndeDatum: TANFIXDAte; IsBadPeriod: boolean;
  ColorIfBad: TColor; AnzeigePrioritaet: Integer = 0);
begin
  Add(long2dateTime(StartDatum), long2dateTime(EndeDatum) + cTime_23_59_59,
    IsBadPeriod, ColorIfBad, AnzeigePrioritaet);
end;

function TSperre.CheckIt(pDatum: TDateTime; pKontext: Integer = -1): TColor;
var
  n: Integer;
  HigestPrio: Integer;
begin
  Result := cSperre_ColourDefault;
  FGrund := '';
  HigestPrio := -1;
  for n := 0 to high(TheData) do
    if HitAt(TheData[n], pDatum, pKontext) then
      with TheData[n] do
      begin
        if (Prioritaet > HigestPrio) then
        begin
          Result := BadColor;
          FGrund := GrundKurz;
          HigestPrio := Prioritaet;
        end;
      end;
end;

function TSperre.CheckNear(pDatum: TDateTime; pKontext: Integer): TColor;
var
  n: Integer;
  d, NearestDistance: Integer;
begin
  Result := cSperre_ColourDefault;
  FGrund := '';
  NearestDistance := MaxInt;
  for n := 0 to high(TheData) do
  begin
    d := Distance(TheData[n], pDatum, pKontext);
    if (d <> -1) and (d <= NearestDistance) then
    begin
      NearestDistance := d;
      with TheData[n] do
      begin
        Result := BadColor;
        FGrund := GrundKurz;
      end;
    end;
  end;
  // Imp pend: nachdem die beste (=kleinste) Differenz bestimmt ist
  //           muss bei mehreren Kandidaten identischer Differnez
  //           der mit der grössenten Priorität gewählt werden
end;

function TSperre.CheckEm(pDatum: TDateTime; pKontext: Integer): TgpIntegerList;
var
  n: Integer;
  r: TColor;
begin
  Result := TgpIntegerList.Create;
  FGrund := '';
  for n := 0 to high(TheData) do
    if HitAt(TheData[n], pDatum, pKontext) then
    begin
      r := TheData[n].BadColor;
      if (Result.IndexOf(r) = -1) then
        Result.Add(r);
    end;
end;

procedure TSperre.Clear;
begin
  SetLength(TheData, 0);
end;

function TSperre.Count: Integer;
begin
  Result := Length(TheData);
end;

destructor TSperre.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TSperre.get(Index: Integer): TSperreRecord;
begin
  Result := TheData[Index];
end;

class function TSperre.HitAt(const sr: TSperreRecord; const pDatum: TDateTime;
  const pKontext: Integer): boolean;
begin
  Result := false;
  repeat
    with sr do
    begin

      // wenn eine Kontextprüfung überhaupt erwünscht ist
      if (pKontext <> -1) then
        // und ein Kontext ist hier vorhanden
        if (Kontext <> 0) then
          // dann muss er stimmen sonst gilt das nicht für uns!
          if (Kontext <> pKontext) then
            Break;

      // Wochentag prüfen
      if (Wochentag > 0) then
      begin
        // Datum prüfen
        if (DateInside(pDatum, StartD, EndeD) <> BadPeriod) then
          Break;
        if ((DayOfWeek(pDatum) = Wochentag) <> BadPeriod) or
          (TimeInside(pDatum, StartD, EndeD) <> BadPeriod) then
          Break;
      end
      else
      begin
        // Zeitraum prüfen
        if (DateTimeInside(pDatum, StartD, EndeD) <> BadPeriod) then
          Break;
      end;

    end;
    Result := True;
  until yet;

end;

function TSperre.Kontexte: TgpIntegerList;
var
  n: Integer;
begin
  Result := TgpIntegerList.Create;
  for n := 0 to high(TheData) do
    if Result.IndexOf(TheData[n].Kontext) = -1 then
      Result.Add(TheData[n].Kontext);
end;

function TSperre.MaxDate(pKontext: Integer): TDateTime;
var
  n: Integer;
begin
  Result := cIllegalDate;
  for n := 0 to high(TheData) do
    with TheData[n] do
    begin
      // wenn eine Kontextprüfung überhaupt erwünscht ist
      if (pKontext <> -1) then
        // und ein Kontext ist hier vorhanden
        if (Kontext <> 0) then
          // dann muss er stimmen sonst gilt das nicht für uns!
          if (Kontext <> pKontext) then
            continue;
      if EndeD > Result then
        Result := EndeD;
    end;
end;

function TSperre.MinDate(pKontext: Integer): TDateTime;
var
  n: Integer;
begin
  Result := cMaxDateTime;
  for n := 0 to high(TheData) do
    with TheData[n] do
    begin
      // wenn eine Kontextprüfung überhaupt erwünscht ist
      if (pKontext <> -1) then
        // und ein Kontext ist hier vorhanden
        if (Kontext <> 0) then
          // dann muss er stimmen sonst gilt das nicht für uns!
          if (Kontext <> pKontext) then
            continue;
      if EndeD < Result then
        Result := EndeD;
    end;
  if (Result = cMaxDateTime) then
    Result := cIllegalDate;
end;

class function TSperre.Distance(const sr: TSperreRecord;
  const pDatum: TDateTime; const pKontext: Integer): Integer;
begin
  Result := -1;
  repeat
    with sr do
    begin

      // wenn eine Kontextprüfung überhaupt erwünscht ist
      if (pKontext <> -1) then
        // und ein Kontext ist hier vorhanden
        if (Kontext <> 0) then
          // dann muss er stimmen sonst gilt das nicht für uns!
          if (Kontext <> pKontext) then
            Break;

      // Ab hier: Kontext passt schon mal!
      Result := DateAbstand(pDatum, StartD, EndeD);

      // Wochentag prüfen
      if (Wochentag > 0) then
      begin
        // Datum prüfen
        if (DateInside(pDatum, StartD, EndeD) <> BadPeriod) then
          Break;
        if ((DayOfWeek(pDatum) = Wochentag) <> BadPeriod) or
          (TimeInside(pDatum, StartD, EndeD) <> BadPeriod) then
          Break;
      end
      else
      begin
        // Zeitraum prüfen
        if (DateTimeInside(pDatum, StartD, EndeD) <> BadPeriod) then
          Break;
      end;

    end;
    Result := 0;
  until yet;

end;

procedure TSperre.put(Index: Integer; d: TSperreRecord);
begin
  TheData[Index] := d;
end;

function TSperre.ReadfromMemo(M: TStrings; Wertigkeit: TStrings;
  Umstand: TStrings = nil; pKontext: Integer = 0): Integer;

var
  pColorAusUmstand: boolean;
  _ColorIfBad: TColor;

  function MatchUmstand(UmstandSperre: string): boolean;
  var
    sUmstand: TStringList;
    n: Integer;
  begin
    Result := false;
    if pColorAusUmstand then
    begin
      n := Umstand.IndexOf(UmstandSperre);
      if (n <> -1) then
      begin
        Result := True;
        _ColorIfBad := Integer(Umstand.Objects[n]);
      end;
    end
    else
    begin
      sUmstand := split(UmstandSperre, ',');
      sUmstand.Sort;
      // Gehe alle Umstände des Filters durch - gibt es einen Treffer -> alles OK
      for n := 0 to pred(Umstand.Count) do
        if (sUmstand.IndexOf(Umstand[n]) <> -1) then
        begin
          Result := True;
          Break;
        end;
      sUmstand.Free;
    end;
  end;

  function NextDelimiter(const s: string): Integer;
  begin
    Result := Pos('-', s);
    if (Result = 0) then
      Result := Pos(' ', s);
    if (Result = 0) then
      Result := succ(Length(s));
  end;

var
  n, I, r, s: Integer;
  DateA: string;

  dateB: string;

  d: TANFIXDAte;
  _DateA: TDateTime;
  _TimeA: Char;
  _DateB: TDateTime;
  _TimeB: Char;
  _Grund: string; // (Grund) warum es die Sperre gibt, der Zweck
  _Umstand: string; // [Umstand] wann/für wen die Sperre überhaupt gilt!
  _IsBadPeriod: boolean;
  _AnzeigePrioritaet: Integer;
  _Wochentag: Integer;
  EndOfStatement: boolean;

  OneLine: string;

  Repetitor: Integer;
  EqualPos: Integer;
  WertigkeitIndex: Integer;
  SperrBezeichnung: string;

begin
  Result := 0;
  if not(Assigned(sDiagnose)) then
    sDiagnose := TStringList.Create;

  pColorAusUmstand := false;
  repeat
    if not(Assigned(Umstand)) then
      Break;
    if (Umstand.Count = 0) then
      Break;
    if (Umstand.IndexOf('ColorAusUmstand=JA')=-1) then
      Break;

    pColorAusUmstand := True;
  until yet;

  for n := 0 to pred(M.Count) do
  begin

    // schnell! mal die Grundvoraussetzung prüfen
    EqualPos := Pos('=', M[n]);
    if (EqualPos = 0) then
      continue;

    try

      OneLine := AnsiUpperCase(Trim(M[n]));
      SperrBezeichnung := nextp(OneLine, '=', 0);
      WertigkeitIndex := -1;
      for I := 0 to pred(Wertigkeit.Count) do
        if SperrBezeichnung = nextp(Wertigkeit[I], ';', 0) then
        begin
          WertigkeitIndex := I;
          Break;
        end;

      // ist es eine bekannte Sperre, bzw. eine, die im Moment einen Wert hat?
      if (WertigkeitIndex <> -1) then
      begin

        // Parameter dieser Wertigkeit nun laden
        _IsBadPeriod := nextp(Wertigkeit[WertigkeitIndex], ';', 1) = 'JA';
        _ColorIfBad := HTMLColor2TColor
          (nextp(Wertigkeit[WertigkeitIndex], ';', 2));
        _AnzeigePrioritaet := strtointdef(nextp(Wertigkeit[WertigkeitIndex],
          ';', 3), 0);

        // Original noch dokumentieren
        if TestMode then
          sDiagnose.Add(OneLine);

        // sind Umstände angegeben?
        r := Pos('[', OneLine);
        if (r > 0) then
        begin
          s := Pos(']', OneLine);
          if (s < r) then
            raise Exception.Create('"[" gefunden, aber "]" fehlt in '+M[n]);
          _Umstand := Copy(OneLine, r + 1, s - r - 1);
          if not(Assigned(Umstand)) then
            continue;
          if not(MatchUmstand(_Umstand)) then
            continue;
          Delete(OneLine, r, s - r + 1);
        end
        else
        begin
          _Umstand := '';
        end;

        // Prefix wegschneiden
        nextp(OneLine, '=');

        // Grund Angegeben
        r := Pos('(', OneLine);
        if (r > 0) then
        begin
          s := Pos(')', OneLine);
          if s < r then
            raise Exception.Create('"(" gefunden, aber ")" fehlt in '+M[n]);
          _Grund := Copy(OneLine, r + 1, s - r - 1);
          // Delete(OneLine, r, s - r + 1);
          Delete(OneLine, r, MaxInt);
        end
        else
        begin
          _Grund := '';
        end;

        //
        if _Grund = 'TEST' then
          _Grund := 'TST';

        // Kommentare wegschneiden
        r := Pos(':', OneLine);
        if (r > 0) then
          OneLine := Copy(OneLine, 1, pred(r));
        r := Pos(';', OneLine);
        if (r > 0) then
          OneLine := Copy(OneLine, 1, pred(r));

        OneLine := Trim(OneLine);

        if (Length(OneLine) < 2) then
          continue;

        // ************
        // Parser INIT
        // ************
        _TimeA := #0;
        _TimeB := #0;
        _Wochentag := 0;
        EndOfStatement := false;

        // Suche den nächste Ausdruck-Separator
        r := NextDelimiter(OneLine);

        // Look-Ahead: Ist eine Zeitangabe als Postfix mit dabei?
        if CharInSet(OneLine[pred(r)], cSperre_ZeitAngabe) then
        begin
          _TimeA := OneLine[pred(r)];
          system.Delete(OneLine, pred(r), 1);
          dec(r);
        end;

        // Look-Ahead: Ist es ein Datum oder ein Wochentag?
        if (OneLine[1] >= '0') and (OneLine[1] <= '9') then
        begin
          // ! Ein Start-Datum
          d := date2long(Copy(OneLine, 1, pred(r)));
          if DateOK(d) then
          begin
            _DateA := long2dateTime(d);

            // defaults für "B"
            _DateB := _DateA;
            if (_TimeA = cSperre_ZeitAngabe_Vormittag) then
              _TimeB := cSperre_ZeitAngabe_Mittag;
          end
          else
          begin
            sDiagnose.Add('ERROR: Unverständliches Start-Datum in '+M[n]);
            continue;
          end;
          system.Delete(OneLine, 1, pred(r));
          EndOfStatement := Pos('-', OneLine) <> 1;
        end
        else
        begin
          // ! Ein Wochentag
          _Wochentag := WochenTagAsInt(Copy(OneLine, 1, pred(r)));
          if (_Wochentag <= 0) then
          begin
            sDiagnose.Add('ERROR: Unverständlicher Wochentag in '+M[n]);
            continue;
          end;
          EndOfStatement := True;
          _DateA := long2dateTime(ccMinDate);
          _DateB := long2dateTime(ccMaxDate);
        end;

        if not(EndOfStatement) then
        begin

          // ! "-"
          system.Delete(OneLine, 1, 1);

          // ! Ein End-Datum
          r := NextDelimiter(OneLine);

          if CharInSet(OneLine[pred(r)], cSperre_ZeitAngabe) then
          begin
            _TimeB := OneLine[pred(r)];
            system.Delete(OneLine, pred(r), 1);
            dec(r);
          end;

          // ! Ein Datum
          d := date2long(Copy(OneLine, 1, pred(r)));
          if DateOK(d) then
          begin
            _DateB := long2dateTime(d);
          end
          else
          begin
            sDiagnose.Add('ERROR: Unverständliches End-Datum in '+M[n]);
            continue;
          end;
          system.Delete(OneLine, 1, pred(r));
          EndOfStatement := Pos(' ', OneLine) <> 1;

        end;

        if not(EndOfStatement) then
        begin

          // ! " "
          system.Delete(OneLine, 1, 1);

          // Suche den nächste Ausdruck-Separator
          r := NextDelimiter(OneLine);

          // Look-Ahead: Ist eine Zeitangabe als Postfix mit dabei?
          if CharInSet(OneLine[pred(r)], cSperre_ZeitAngabe) then
          begin
            _TimeA := OneLine[pred(r)];
            system.Delete(OneLine, r, 1);
            dec(r);
          end;

          // ! Ein Wochentag
          _Wochentag := WochenTagAsInt(Copy(OneLine, 1, pred(r)));
          if (_Wochentag <= 0) then
          begin
            sDiagnose.Add('WARNING: Unverständlicher Wochentag in '+M[n]);
          end
          else
          begin
            system.Delete(OneLine, 1, pred(r));
          end;

        end;

        // Vervollständigen der Sperren
        if (_Wochentag > 0) then
          if _TimeA = cSperre_ZeitAngabe_Vormittag then
            _TimeB := cSperre_ZeitAngabe_Mittag;

        // Nun die Zeitangaben in das Datum eintragen
        case _TimeA of
          cSperre_ZeitAngabe_Nachmittag, cSperre_ZeitAngabe_Mittag:
            _DateA := _DateA + cTime_12_00_00;
        end;
        case _TimeB of
          cSperre_ZeitAngabe_Vormittag, cSperre_ZeitAngabe_Mittag:
            _DateB := _DateB + cTime_12_00_00;
        else
          _DateB := _DateB + cTime_23_59_59;
        end;

        Repetitor := strtointdef(nextp(OneLine, 'X', 1), 1);

        // Sperre(n) anlegen ...
        if (_DateA > 0) and (_DateB > 0) then
        begin

          for r := 1 to Repetitor do
          begin
            inc(Result);
            with TheData[Add] do
            begin
              StartD := _DateA + pred(r);
              EndeD := _DateB + pred(r);
              BadPeriod := _IsBadPeriod;
              BadColor := _ColorIfBad;
              Prioritaet := _AnzeigePrioritaet;
              Wochentag := _Wochentag;
              GrundKurz := _Grund;
              Kontext := pKontext;
            end;
            if TestMode then
              sDiagnose.Add(AsString(TheData[ high(TheData)]))
          end;
        end;
      end;

    except
      on E: Exception do
        sDiagnose.Add(
        {} 'ERROR: TSperre.ReadfromMemo: ' +
        {}  E.Message);
    end;
  end;
end;

class procedure TSperre.Reset(var r: TSperreRecord);
begin
  FillChar(r, sizeof(TSperreRecord), 0);

  with r do
  begin
    // Default Werte, die abweichend von "0" sind
    BadPeriod := True;
  end;
end;

constructor TSperre.Create;
begin
  inherited Create;
  SetLength(TheData, 0);
end;

{ TAuslastungZelle }

constructor TAuslastungZelle.Create;
begin
  inherited Create;
  Baustellen := TList.Create;
end;

procedure TAuslastungZelle.Clear;
begin
  Baustellen.Clear;
  AnzahlIst := 0;
  AnzahlSoll := 0;
  Aufwand := 0;
  Kapazitaet := 0;
end;

destructor TAuslastungZelle.Destroy;
begin
  Baustellen.Free;
  inherited Destroy;
end;

procedure TAuslastungZelle.BaustelleAdd(BAUSTELLE_R: Integer);
begin
  if (Baustellen.IndexOf(TObject(BAUSTELLE_R)) = -1) then
    Baustellen.Add(TObject(BAUSTELLE_R));
end;

function TAuslastungZelle.Last: string;
begin

end;

function TAuslastungZelle.TerminAnzahl: string;
begin
  if (Baustellen.Count > 0) then
  begin
    if (AnzahlIst > 0) then
    begin
      if Odd(AnzahlIst) then
        Result := IntToStr(AnzahlIst div 2) + '½'
      else
        Result := IntToStr(AnzahlIst div 2);
    end
    else
    begin
      Result := '';
    end;
  end
  else
  begin
    Result := IntToStr(AnzahlIst div 2) + '|' + IntToStr(AnzahlSoll div 2);
  end;
end;

function TAuslastungZelle.TerminDauer: string;
begin
  if (Aufwand > 0) then
    Result := secondstostr5(Aufwand) + '/' + secondstostr5(Kapazitaet)
  else
    Result := '';
end;

{ TAuslastungRow }

constructor TAuslastungRow.Create;
var
  n: Integer;
begin
  inherited Create;
  fBaustellen := TList.Create;
  SetLength(Cols, Count);
  for n := 0 to pred(Count) do
    Cols[n] := TAuslastungZelle.Create;
end;

procedure TAuslastungRow.Clear;
var
  n: Integer;
begin
  fBaustellen.Clear;
  fBaustellenAssigned := false;
  for n := 0 to pred(Count) do
    Column[n].Clear;
end;

destructor TAuslastungRow.Destroy;
var
  n: Integer;
begin
  for n := 0 to pred(Count) do
    Column[n].Free;

  fBaustellen.Free;
  inherited Destroy;
end;

procedure TAuslastungRow.put(Index: Integer; const s: TAuslastungZelle);
begin
  Cols[Index] := s;
end;

function TAuslastungRow.get(Index: Integer): TAuslastungZelle;
begin
  Result := Cols[Index];
end;

function TAuslastungRow.AnzahlIst: Integer;
var
  n: Integer;
begin
  Result := 0;
  for n := 0 to pred(Count) do
    inc(Result, Cols[n].AnzahlIst);
end;

function TAuslastungRow.AnzahlSoll: Integer;
var
  n: Integer;
begin
  Result := 0;
  for n := 0 to pred(Count) do
    inc(Result, Cols[n].AnzahlSoll);
end;

{ TAuslastung }

constructor TAuslastung.Create;
begin
  inherited Create;
  SetLength(Rows, 0);
  Monteure := TStringList.Create;
end;

procedure TAuslastung.Clear;
var
  n: Integer;
begin
  for n := 0 to pred(Monteure.Count) do
    Rows[n].Free;
  SetLength(Rows, 0);
  Monteure.Clear;
end;

destructor TAuslastung.Destroy;
var
  n: Integer;
begin
  for n := 0 to pred(Monteure.Count) do
    Rows[n].Free;
  Monteure.Free;
  inherited Destroy;
end;

procedure TAuslastung.SortBy(BAUSTELLE_R: Integer);
begin
  // oben die blauen
  // Trenner
  // nun alle anderen
end;

procedure TAuslastung.Add(s: string; RID: Integer);
var
  Index: Integer;
begin
  Index := Monteure.Count;
  Monteure.addObject(s, TObject(RID));
  SetLength(Rows, succ(Index));
  Rows[Index] := TAuslastungRow.Create;
  with Rows[Index] do
  begin
    Title := s;
  end;
end;

function TAuslastung.get(Index: Integer): TAuslastungRow;
begin
  Result := Rows[Index];
end;

function TAuslastung.IndexOf(s: string): Integer;
begin
  Result := Monteure.IndexOf(s);
end;

function TAuslastung.IndexOf(RID: Integer): Integer;
begin
  Result := Monteure.Indexofobject(TObject(RID));
end;

procedure TAuslastung.put(Index: Integer; const s: TAuslastungRow);
begin
  Rows[Index] := s;
end;

function TAuslastung.Count: Integer;
begin
  Result := Monteure.Count;
end;

function TAuslastung.GetRID(Index: Integer): Integer;
begin
  Result := Integer(Monteure.Objects[Index]);
end;

procedure TAuslastung.PutRID(Index: Integer; const Value: Integer);
begin
  Monteure.Objects[Index] := TObject(Value);
end;

function TAuslastungRow.EigeneBaustelle(RID: Integer): boolean;
begin
  Result := (Baustellen.IndexOf(TObject(RID)) <> -1);
end;

function TAuslastungRow.GetBaustellen: TList;
var
  n, M: Integer;
begin
  if not(fBaustellenAssigned) then
  begin
    for n := 0 to pred(Count) do
      with Cols[n] do
        for M := 0 to pred(Baustellen.Count) do
          if (fBaustellen.IndexOf(Baustellen[M]) = -1) then
            fBaustellen.Add(Baustellen[M]);
    fBaustellenAssigned := True;
  end;
  Result := fBaustellen;
end;

function TAuslastungRow.Count: Integer;
begin
  Result := 7 * 2;
end;

procedure TAuslastung.Pack;
var
  n: Integer;
begin
  for n := pred(Count) downto 0 do
    if (Row[n].AnzahlIst = 0) and (Row[n].AnzahlSoll = 0) then
      Delete(n);
end;

procedure TAuslastung.Delete(Index: Integer);
var
  n: Integer;
begin
  //
  Rows[Index].Free;
  for n := Index to Count - 2 do
    Rows[n] := Rows[n + 1];
  Monteure.Delete(Index);
  SetLength(Rows, Monteure.Count);
end;

var
  _c_23_59_59: TDateTime = 0.0;
  _c_14_00_00: TDateTime = 0.0;
  _c_09_00_00: TDateTime = 0.0;

function cTime_23_59_59: TDateTime;
begin
  if (_c_23_59_59 = 0.0) then
    tryencodetime(23, 59, 59, 999, _c_23_59_59);
  Result := _c_23_59_59;
end;

function cTime_14_00_00: TDateTime;
begin
  if (_c_14_00_00 = 0.0) then
    tryencodetime(14, 00, 00, 000, _c_14_00_00);
  Result := _c_14_00_00;
end;

function cTime_09_00_00: TDateTime;
begin
  if (_c_09_00_00 = 0.0) then
    tryencodetime(09, 00, 00, 000, _c_09_00_00);
  Result := _c_09_00_00;
end;

function cTime_12_00_00: TDateTime;
begin
  Result := 0.5;
end;

function e_r_AndererHalbtag(DATUM: TDateTime): TDateTime;
var
  TAGE: TDateTime;
begin
  TAGE := trunc(DATUM);
  if (DATUM - TAGE < cTime_12_00_00) then
    result := TAGE + cTime_14_00_00
  else
    result := TAGE + cTime_09_00_00;
end;

procedure TSperre.SaveToFile(FName: string);
var
  TextOuts: TStringList;
  n: Integer;
begin
  TextOuts := TStringList.Create;
  TextOuts.Add
    ('VON_DATUM;VON_ZEIT;BIS_DATUM;BIS_ZEIT;WOCHENTAG;KONTEXT;ZEITRAUM_GESPERRT;FARBE;PRIORITAET;GRUND');
  for n := 0 to high(TheData) do
    TextOuts.Add(AsString(TheData[n]));
  TextOuts.SaveToFile(FName);
  TextOuts.Free;
end;

function TSperre.Add: Integer;
begin
  SetLength(TheData, succ(Length(TheData)));
  Result := high(TheData);
end;

procedure TSperre.Add(const sr: TSperreRecord);
begin
  TheData[Add] := sr;
end;

function TSperre.AsString(const sr: TSperreRecord): string;

  function Period2Str(BadPeriod: boolean): string;
  begin
    if BadPeriod then
      Result := 'JA'
    else
      Result := 'NEIN';
  end;

begin
  with sr do
    Result := format('%s;%s;%s;%s;%d;%d;%s;%s;%d;%s', [
      { } long2date(datetime2long(StartD)),
      { } secondstostr(dateTime2Seconds(StartD)),
      { } long2date(datetime2long(EndeD)),
      { } secondstostr(dateTime2Seconds(EndeD)),
      { } Wochentag,
      { } Kontext,
      { } Period2Str(BadPeriod),
      { } TColor2HTMLColor(BadColor),
      { } Prioritaet,
      { } GrundKurz]);
end;

//
// Urteil über Qualitätsmerkmale anhand einer Brisanz-Tabelle:
//
// Beispiel einer Tabelle:
// =======================
//
//  Q22=kritisch
//  Q23=unkritisch
//  Q24=erlösend
//
// Funktionen:
// ===========
//
// QS_add: Jeder einzelne Qualitätscheck Qnn ruft dies auf wenn die Prüfung misslingt
// QS_gut: Abschliessende Prüffunktion, die das OK für alle gesammelten Merkmale ist
// QS_kritisch: Ermittelt die Liste der Probleme
//

function QS_gut(const sQS: string; const BrisanzTabelle: TStringList): boolean;
var
  q: string;
  SingleQ: string;
  Q_kritische: Integer;
  Q_Urteil: string;
begin

  //
  Result := True;
  if (sQS = '') then
    Exit;
  if (Pos(cQ_Prefix, sQS) = 0) then
    Exit;

  //
  q := sQS;
  Q_kritische := 0;
  while (q <> '') do
  begin
    nextp(q, cQ_Prefix);
    if (Pos(cQ_Postfix, q) = 3) then
    begin
      SingleQ := 'Q' + Copy(q, 1, 2);
      Q_Urteil := BrisanzTabelle.Values[SingleQ];
      if (Q_Urteil = cQ_erloesend) then
        Exit;
      if (Q_Urteil <> cQ_unkritisch) then
        inc(Q_kritische);
    end;

  end;
  Result := (Q_kritische = 0)

end;

function QS_kritisch(const sQS: string; const BrisanzTabelle: TStringList)
  : TStringList;
var
  q: string;
  SingleQ: string;
  Q_Urteil: string;
begin

  //
  Result := TStringList.Create;
  if (sQS = '') then
    Exit;
  if (Pos(cQ_Prefix, sQS) = 0) then
    Exit;

  //
  q := sQS;
  while (q <> '') do
  begin
    nextp(q, cQ_Prefix);
    if (Pos(cQ_Postfix, q) = 3) then
    begin
      SingleQ := 'Q' + Copy(q, 1, 2);
      Q_Urteil := BrisanzTabelle.Values[SingleQ];
      if (Q_Urteil <> cQ_erloesend) then
        if (Q_Urteil <> cQ_unkritisch) then
          Result.Add(cQ_Prefix + nextp(q, cQ_Delimiter, 0));
    end;
  end;

end;

procedure QS_add(qAktuell: string; var qAlle: string);
begin
  if (qAlle = '') then
  begin
    qAlle := qAktuell
  end
  else
  begin
    // Mehrfaches Melden des Problems verhindern
    if Pos(qAktuell, qAlle) = 0 then
      qAlle := qAlle + cQ_Delimiter + qAktuell;
  end;
end;

end.
