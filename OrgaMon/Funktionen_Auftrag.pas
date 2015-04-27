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
unit Funktionen_Auftrag;

interface

uses
  Classes,
{$IFNDEF fpc}
  IB_Components,
{$ENDIF}
  Sperre,
  dbOrgaMon, gplists, anfix32,
  globals, txHoliday;

{
  eResource:

  Basis-Routinen rund um "Monteur", "Baustelle" und "Auftrag"

}
const
  IgnoreAuftragPost: boolean = false;
  ForceHistorischer: boolean = false;
  HistorischerErzeugt: boolean = false;
  AuftragLastChangeFields: TStringList = nil;
  AuftragCriticalFields: TStringList = nil;
  AuftragLastChangeRID: Integer = 0;
  HANDLUNGSBEDARF_POSTEN_RID: Integer = 0;
  HANDLUNGSBEDARF_MEILENSTEIN_RID: Integer = 0;

procedure AuftragHistorischerDatensatz(AUFTRAG_R: Integer); overload;
procedure AuftragHistorischerDatensatz(AUFTRAG_R: TList); overload;

// Auftrag - Sachen
procedure AuftragBeforePost(Auftrag: TdboDataset; ReOrgMode: boolean = false);
function e_w_AuftragDelete(Master_R: Integer): Integer;
procedure e_w_AuftragAblage(Master_R: Integer);
procedure RecourseDeleteAUFTRAG(RIDList: TList; var DeleteCount: Integer);
function e_r_PhasenStatus(AUFTRAG_R: Integer): string;
function e_c_AuftragHeader: TStringList;
function e_r_AuftragItems(AUFTRAG_R: Integer): TStringList;
function e_r_AuftragLine(AUFTRAG_R: Integer): string;
procedure InvalidateCache_Auftrag;
procedure e_r_Sync_Auftraege(BAUSTELLE_R: Integer);
procedure e_r_Sync_AuftraegeAlle;

// Mail Sachen
procedure e_w_AuftrageMail(AUFTRAG_R: Integer);
function e_r_VorlageMail(VorlageName: string): Integer; // [EMAIL_R]

procedure EnsureHints(hints: TStrings);
procedure e_w_QAuftragEnsure(AUFTRAG_R: Integer);

// Personen Monteure
function e_r_Person(PERSON_R: Integer): string;
function e_r_Kunde(PERSON_R: Integer): string;
function e_r_Person2Zeiler(PERSON_R: Integer): TStringList;
function e_r_MonteurRIDFromKuerzel(str: string): Integer;
function e_r_MonteurRIDfromGeraeteID(str: string): Integer;
function e_r_MonteurKuerzel(rid: Integer): string;
function e_r_MonteurName(rid: Integer): string;
function e_r_MonteurHandy(rid: Integer): string;
function e_r_MonteurGeraeteID(rid: Integer): string;

procedure e_r_MonteurUrlaub(rid: Integer; Urlaub: TSperre);
// Sperre=

procedure e_r_MonteurArbeit(rid: Integer; Arbeit: TSperre);
// Arbeit und Mehrarbeit

procedure e_r_MonteurZuordnung(MONTEUR_R: Integer; Arbeit: TSperre);
function e_r_MonteureCache(Alle: boolean = true): TStringList;
function e_r_MonteureJonDa(Alle: boolean = true): TStringList;
procedure InvalidateCache_Monteur;

// Verlage
function e_r_Verlag_VERLAG_R(rid: Integer): string;
function e_r_Verlag_PERSON_R(rid: Integer): string;
function e_r_Verlag_R(s: string): Integer; overload;
function e_r_Verlag_R(rid: Integer): Integer; overload;
function e_r_VerlagPerson(Verlag: string): Integer;
function e_r_VerlagAlias(VERLAG_R: Integer): Integer;
function e_r_Verlage2: TStringList;
function e_r_Verlage1: TStringList; // NICHT FREIGEBEN
procedure InvalidateCache_Verlag;

// Baustellen
function e_r_BaustelleKuerzel(rid: Integer): string;
function e_r_BaustelleKostenstelle(BAUSTELLE_R: Integer): string;
function e_r_BaustelleBundesland(BAUSTELLE_R: Integer): Integer;

function e_r_BaustelleProtokollName(AUFTRAG_R: Integer; BAUSTELLE_R: Integer = cRID_Null): string;
function e_r_BaustelleName(rid: Integer): string;
function e_r_BaustelleCSV_QUELLE(rid: Integer): string;
function e_r_BaustelleNameFromKuerzel(KUERZEL: string): string;
function e_r_BaustelleRIDFromKuerzel(KUERZEL: string): Integer;
function e_r_BaustelleMonteure(rid: Integer): TStringList;
function e_r_Monteure(BAUSTELLE_R: Integer): TgpIntegerList;
function e_r_Baustellen: TStringList; overload;
function e_r_BaustellenLang: TStringList;
function e_r_BaustellenAktive: TStringList;
procedure e_r_Sync_Baustelle;

function e_w_BaustelleLoeschen(BAUSTELLE_R: Integer): boolean;
function e_w_BaustelleKopie(BAUSTELLE_R: Integer): boolean;

// Baustellen - Foto - Sachen
procedure e_w_GrabFotos;
function e_r_BaustelleFotoPath(BAUSTELLE_R: TDOM_Reference): string;
function e_r_BaustelleUploadPath(BAUSTELLE_R: TDOM_Reference): string;
function e_r_FotoName(AUFTRAG_R: Integer; MeldungsName: string; AktuellerWert: string = ''): string;

function e_r_TerminAnzahl_V(rid: Integer): Integer;
function e_r_TerminAnzahl_N(rid: Integer): Integer;
function e_r_TerminAnzahl_VN(rid: Integer): Integer;

function e_r_Arbeitszeit_V(rid: Integer): TAnfixTime;
function e_r_Arbeitszeit_N(rid: Integer): TAnfixTime;
function e_r_EinzelAufwand(rid: Integer): TAnfixTime;

function e_r_OrtsteilCode(BAUSTELLE_R: Integer; Ort: string): string;
procedure e_r_ProtokollExport(BAUSTELLE_R: Integer; FelderListe: TStringList);
procedure e_r_InternExport(BAUSTELLE_R: Integer; FelderListe: TStringList);

function e_r_BaustelleAddSperre(BAUSTELLE_R: Integer; Umstand: TStrings; Sperre: TSperre): Integer;
// [BUNDESLAND_IDX]
procedure InvalidateCache_Baustelle;
procedure ReCreateAktiveBaustellen;

// Auf welchen Baustellen arbeitet der Monteur "normalerweise" und in
// Wirklichkeit an dem angegebenen Datum. Dazu wird die Planungsinformation
// zu Rate gezogen. Rückgabewerte:
// -1 = Fehler, Angaben führen zu Uneindeutigkeit
// 0  = keine Arbeit
// n = RID der Baustelle auf der Gearbeitet oder geplant wurde
//
// TeWertigkeitBaustellenzuordnung = ( cwb_Keine, cwb_echteArbeit, cwb_nurZordnung );
function e_r_Baustelle(
  { } MONTEUR_R: Integer;
  { } MOMENT: TDateTime;
  { } var Wertigkeit: TeWertigkeitBaustellenzuordnung): Integer;

// Arbeit : Kurzinfo über Arbeit an diesem Tag,
// incl. Formatierungsangaben "{...}"
//
function e_r_Arbeit(MONTEUR_R: Integer; ArbeitsTag: TANFiXDate): string;
procedure EnsureCache_ArbeitBaustelle;
procedure InvalidateCache_ArbeitBaustelle;

// Einsatz : Kurzinfo über die Einsatzplanung an diesem Tag
function e_r_Einsatz(MONTEUR_R: Integer; ArbeitsTag: TANFiXDate): string;

// Arbeitshalbtage in dieser Woche
function e_r_Halbtage(MONTEUR_R, BAUSTELLE_R: Integer; ArbeitsTag: TANFiXDate): Integer;

// Geo
function DeleteGeo(AUFTRAG_R: Integer): Integer;
function dummyPLZ_R: Integer;
procedure e_w_unlocate(POSTLEITZAHL_R: Integer);

// Bearbeiter
function e_r_BearbeiterEinstellungen(BEARBEITER_R: Integer): TStringList;

// Budget
function e_w_BudgetEinfuegen(BELEG_R: Integer; SubBudget: string = '*'; PERSON_R: Integer = 0;
  moreSettings: TStringList = nil): Integer;
// Fügt unberechnetes Volumen aus offenen Bugets in den angegebenen
// Beleg ein.
procedure e_w_BudgetAbschreiben(BELEG_R: Integer; FName: string);

// Resource-String-Bearbeitung
function DoppelAngabe(v, n: string): string;

function Feiertage: TSperreOfficalHolidays;

function LieferzeitToStr(i: TAnfixTime): string;
function LieferzeitInTagen(i: Integer): Integer;
function VersendetagToStr(i: Integer): string;
function Liefertag(Liefertag: TAnfixTime): TAnfixTime;

function VormittagsToChar(vormittags: boolean): char;
function VormittagsToTime(s: string): TDateTime;
procedure ObtainStrasseHausnummerPos(const _strasseFull: string;
  var _FirstNummernPos, _LastNummernPos: Integer);
function ObtainStrassenName(const _strasseFull: string): string;
function ObtainStrassenHausNummer(const _strasseFull: string): string;
function ObtainStrassenHausNummerOhneZusatz(const _strasseFull: string): string;
function ObtainStrassenHausNummerZusatz(const _strasseFull: string): string;
function ObtainStrassenHausNummerNumerischerZusatz(const _strasseFull: string): string;
function ObtainStrassenWohnungseinheit(const _strasseFull: string): string;

function StrasseUnify(a: string): string;
function StrassenNameIdentisch(a, b: string): boolean;

function OrtIdentisch(a, b: string): boolean;
function SAP2Art(Material: string): string;
function csvCheck(const s: string): string;

// Zählernummer / Zählerstand
function KommaCheck(const s: string): string;

implementation

uses
  // Delphi
{$IFDEF fpc}
  graphics,
  fpchelper,
{$ELSE}
  System.UITypes,
  Jvgnugettext,
  IB_Access,
{$ENDIF}
  math,

  // types,
  SysUtils,

  // Tools
  html, infozip, OrientationConvert,
  CareTakerClient, Mapping, Geld,
  WordIndex, ExcelHelper,

  // OrgaMon
  JonDaExec,
  Funktionen_Beleg,
  Funktionen_Basis,
{$IFNDEF CONSOLE}
  Datenbank,
{$ENDIF}
  // Indy
  IdComponent, IdFTP, SolidFTP;

var
  { Private-Deklarationen }
  CacheMonteur: TStringList = nil;
  CacheMonteurKuerzel: TStringList = nil;
  MonteurKuerzel: TStringList = nil;
  MonteurKuerzelGeraeteID: TStringList = nil;
  MonteurKuerzel_freie: TStringList = nil;
  MonteurJonDa_freie: TStringList = nil;

  CacheBaustelle: TStringList = nil;
  CacheBaustelleMonteure: TStringList = nil;
  CacheBaustelleOrtsteile: TSearchStringList = nil;
  CacheBaustelleAufwand: Integer = 0;
  CacheBaustelleAufwandValue: Integer = 0;

  CacheBaustelleOrtsteile_BAUSTELLE_R: Integer = 0;
  CacheBaustelleMonteureLastRequestedRID: Integer = 0;

  // ArbeitszeitV_Cache
  CacheBaustelleArbeitsZeitV_RID: Integer = 0;
  CacheBaustelleArbeitsZeitV_Value: TAnfixTime = 0;

  // ArbeitszeitN_Cache
  CacheBaustelleArbeitsZeitN_RID: Integer = 0;
  CacheBaustelleArbeitsZeitN_Value: TAnfixTime = 0;

  // Feiertage-Cache
  cFeiertage: TSperreOfficalHolidays = nil;

var
  _AuftragAblage_Copy: TdboScript = nil;
  _AuftragAblage_Del: TdboScript = nil;
  _AuftragAblage_Quelle: TdboCursor = nil;
  _AuftragAblage_FieldNames: TStringList = nil;

procedure EnsureCache_Monteur; forward;
procedure EnsureCache_Baustelle; forward;
procedure EnsureCache_Verlag; forward;
function AktiveBaustellenFName: string; forward;
function gFeiertage: TSperreOfficalHolidays; forward;
function Arbeit_PERSON(MONTEUR_R: Integer): TSperre; forward;
function Sperre_PERSON(MONTEUR_R: Integer): TSperre; forward;

procedure _AuftragAblage_EnsureCache(Master_R: Integer);
var
  n: Integer;
begin

  e_x_sql('update AUFTRAG set MASTER_R=RID where MASTER_R is null');

  // Quell-Datensätze bestimmen
  _AuftragAblage_Quelle := nCursor;
  _AuftragAblage_FieldNames := TStringList.create;
  with _AuftragAblage_Quelle do
  begin
    sql.Add('select');
    sql.Add(' *');
    sql.Add('from');
    sql.Add(' AUFTRAG');
    sql.Add('where');
    sql.Add(' (MASTER_R=:CROSSREF)');
    ParamByName('CROSSREF').AsInteger := Master_R;
    open;
    // Liste der Feldnamen speichern!
    for n := 0 to pred(FieldCount) do
      _AuftragAblage_FieldNames.Add(Fields[n].FieldName);
  end;

  _AuftragAblage_Copy := nScript;
  with _AuftragAblage_Copy do
  begin
    sql.Add('insert into ABLAGE');
    sql.Add('(' + HugeSingleLine(_AuftragAblage_FieldNames, ',') + ')');
    sql.Add('SELECT');
    sql.Add(HugeSingleLine(_AuftragAblage_FieldNames, ','));
    sql.Add('FROM');
    sql.Add(' AUFTRAG');
    sql.Add('WHERE');
    sql.Add(' RID=:CROSSREF');
{$IFNDEF fpc}
    prepare;
{$ENDIF}
  end;

  _AuftragAblage_Del := nScript;
  with _AuftragAblage_Del do
  begin
    sql.Add('DELETE FROM');
    sql.Add(' ABLAGE');
    sql.Add('WHERE');
    sql.Add(' RID=:CROSSREF');
{$IFNDEF fpc}
    prepare;
{$ENDIF}
  end;

end;

procedure e_w_AuftragAblage(Master_R: Integer);

  procedure InsertCol(rid: Integer);
  begin
    with _AuftragAblage_Del do
    begin
      ParamByName('CROSSREF').AsInteger := rid;
      execute;
    end;

    with _AuftragAblage_Copy do
    begin
      ParamByName('CROSSREF').AsInteger := rid;
      execute;
    end;
  end;

begin
  if not(assigned(_AuftragAblage_Copy)) then
    _AuftragAblage_EnsureCache(Master_R);

  with _AuftragAblage_Quelle do
  begin

    ParamByName('CROSSREF').AsInteger := Master_R;

    // Zunächst die Masterdatensätze
    ApiFirst;
    while not(eof) do
    begin
      if (FieldByName('RID').AsInteger = FieldByName('MASTER_R').AsInteger) then
        InsertCol(FieldByName('RID').AsInteger);
      Apinext;
    end;

    // Nun die Historischen Datensätze
    ApiFirst;
    while not(eof) do
    begin
      if (FieldByName('RID').AsInteger <> FieldByName('MASTER_R').AsInteger) then
        InsertCol(FieldByName('RID').AsInteger);
      Apinext;
    end;

  end;

  e_w_AuftragDelete(Master_R);
end;

var
  IB_DSQL5: TdboScript = nil;

procedure RecourseDeleteAUFTRAG(RIDList: TList; var DeleteCount: Integer);
var
  n: Integer;
  RIDs: TList;
  Auftrag: TdboQuery;
begin
  //
  if not(assigned(IB_DSQL5)) then
  begin
    IB_DSQL5 := nScript;
    with IB_DSQL5 do
    begin
      sql.Add('DELETE FROM');
      sql.Add(' AUFTRAG');
      sql.Add('WHERE');
      sql.Add(' RID=:CROSSREF');
    end;
  end;

  //
  for n := 0 to pred(RIDList.count) do
  begin
    //
    // eine Liste erstellen aller, die auf den Datensatz zeigen
    // diese als erste löschen!
    //
    RIDs := TList.create;
    Auftrag := nQuery;
    with Auftrag do
    begin
      sql.Add('SELECT RID FROM AUFTRAG WHERE');
      sql.Add(' (MASTER_R=' + inttostr(Integer(RIDList[n])) + ') AND');
      sql.Add(' (MASTER_R<>RID)');
      open;
      First;
      while not(eof) do
      begin
        RIDs.Add(TObject(FieldByName('RID').AsInteger));
        next;
      end;
    end;
    Auftrag.free;
    RecourseDeleteAUFTRAG(RIDs, DeleteCount);
    RIDs.free;

    with IB_DSQL5 do
    begin
      ParamByName('CROSSREF').AsInteger := Integer(RIDList[n]);
      execute;
    end;
    inc(DeleteCount);

  end;
end;

function e_w_AuftragDelete(Master_R: Integer): Integer;
var
  RIDs: TList;
  DeleteCount: Integer;
begin
  RIDs := TList.create;
  RIDs.Add(TObject(Master_R));
  DeleteCount := 0;
  RecourseDeleteAUFTRAG(RIDs, DeleteCount);
  RIDs.free;
  result := DeleteCount;
end;

procedure ObtainStrasseHausnummerPos(const _strasseFull: string;
  var _FirstNummernPos, _LastNummernPos: Integer);
var
  n: Integer;
begin
  _FirstNummernPos := 0;
  _LastNummernPos := 0;
  for n := 1 to length(_strasseFull) do
  begin
    if (_FirstNummernPos = 0) then
    begin
      // suche den Anfang der Nummer
      if (n > 2) then // Sonderbehandlung "Mannheim" 'Q4', 'Q 4'
        if not((n = 3) and (_strasseFull[2] = ' ')) then
          // Sonderbehandlung "Mannheim" 'Q4', 'Q 4'
          if _strasseFull[n] in ['0' .. '9'] then
            _FirstNummernPos := n;
    end
    else
    begin
      if not(_strasseFull[n] in ['0' .. '9']) then
      begin
        _LastNummernPos := pred(n);
        break;
      end;
    end;
  end;
  if (_FirstNummernPos > 0) then
    if (_LastNummernPos = 0) then
      _LastNummernPos := length(_strasseFull);
end;

function ObtainStrassenName(const _strasseFull: string): string;
var
  _FirstNummernPos: Integer;
  _LastNummernPos: Integer;
begin
  ObtainStrasseHausnummerPos(_strasseFull, _FirstNummernPos, _LastNummernPos);
  if (_FirstNummernPos = 0) then
    result := _strasseFull
  else
    result := cutblank(copy(_strasseFull, 1, pred(_FirstNummernPos)));
end;

function ObtainStrassenHausNummer(const _strasseFull: string): string;
var
  _FirstNummernPos: Integer;
  _LastNummernPos: Integer;
begin
  ObtainStrasseHausnummerPos(_strasseFull, _FirstNummernPos, _LastNummernPos);
  if (_FirstNummernPos > 0) then
    result := copy(_strasseFull, _FirstNummernPos, MaxInt)
  else
    result := '';
end;

function ObtainStrassenHausNummerOhneZusatz(const _strasseFull: string): string;
var
  _FirstNummernPos: Integer;
  _LastNummernPos: Integer;
begin
  ObtainStrasseHausnummerPos(_strasseFull, _FirstNummernPos, _LastNummernPos);
  if (_FirstNummernPos > 0) then
    result := copy(_strasseFull, _FirstNummernPos, succ(_LastNummernPos - _FirstNummernPos))
  else
    result := '';
end;

function ObtainStrassenHausNummerZusatz(const _strasseFull: string): string;
var
  _FirstNummernPos: Integer;
  _LastNummernPos: Integer;
begin
  ObtainStrasseHausnummerPos(_strasseFull, _FirstNummernPos, _LastNummernPos);
  if (_FirstNummernPos > 0) then
    result := cutblank(nextp(copy(_strasseFull, succ(_LastNummernPos), MaxInt), '#', 0))
  else
    result := '';
end;

function ObtainStrassenHausNummerNumerischerZusatz(const _strasseFull: string): string;
var
  _FirstNummernPos: Integer;
  _LastNummernPos: Integer;
  HausnummerZusatz: string;
  n: Integer;
begin
  result := '';
  HausnummerZusatz := ObtainStrassenHausNummerZusatz(_strasseFull);
  if (HausnummerZusatz <> '') then
  begin

    _FirstNummernPos := 0;
    _LastNummernPos := 0;
    for n := 1 to length(HausnummerZusatz) do
    begin
      if (_FirstNummernPos = 0) then
      begin
        // suche den Anfang der Nummer
        if HausnummerZusatz[n] in ['0' .. '9'] then
          _FirstNummernPos := n;
      end
      else
      begin
        if not(HausnummerZusatz[n] in ['0' .. '9']) then
        begin
          _LastNummernPos := pred(n);
          break;
        end;
      end;
    end;

    if (_FirstNummernPos > 0) then
    begin
      if (_LastNummernPos = 0) then
        _LastNummernPos := length(_strasseFull);
      result := copy(HausnummerZusatz, _FirstNummernPos, succ(_LastNummernPos - _FirstNummernPos));
    end;

  end;
end;

function ObtainStrassenWohnungseinheit(const _strasseFull: string): string;
begin
  if (pos('#', _strasseFull) > 0) then
    result :=
    { } StrFilter(
      { } nextp(
      { } nextp(
      { } StrFilter(
      { } _strasseFull, '!?', true), '@', 0), '#', 1), cZIFFERN)
  else
    result := '';
end;

function OrtIdentisch(a, b: string): boolean;

  function Unscharf(s: string): string;
  begin
    result := noblank(s);
    ersetze('ST.', 'SANKT', result);
    ersetze('ß', 'SS', result);
    ersetze('A.D.', 'ANDER', result);
    result := AnsiUpperCase(result);
  end;

begin
  result := (a = b) or (pos(a, b) = 1) or (pos(b, a) = 1) or (pos(Unscharf(a), Unscharf(b)) = 1) or
    (pos(Unscharf(b), Unscharf(a)) = 1);
end;

function StrasseUnify(a: string): string;
var
  L: Integer;
begin
  result :=
  { } AnsiUpperCase(
    { } cutblank(
    { } nextp(
    { } nextp(
    { } StrFilter(
    { } a, '!?', true),
    { } '@', 0), '#', 0)));

  ersetze('ST.', 'SANKT', result);
  ersetze('ß', 'SS', result);
  ersetze('Ä', 'AE', result);
  ersetze('Ö', 'OE', result);
  ersetze('Ü', 'UE', result);
  ersetze('-', ' ', result);
  ersetze('''', ' ', result);
  ersetze('  ', ' ', result);

  // '*STR' -> '*STR.'
  L := length(result);
  if L >= 3 then
    if (result[L - 2] = 'S') then
      if (result[L - 1] = 'T') then
        if (result[L] = 'R') then
          result := result + '.';

  ersetze('STR ', 'STR.', result);
  ersetze('STRASSE', 'STR.', result);
  result := noblank(result);
end;

function StrassenNameIdentisch(a, b: string): boolean;
begin
  result := (a = b) or (StrasseUnify(a) = StrasseUnify(b));
end;

function LieferzeitToStr(i: TAnfixTime): string;
var
  Days: Integer;
  Hours: Integer;
begin
  Days := i div cOneDayInSeconds;
  Hours := i - (Days * cOneDayInSeconds);
  result := inttostr(Days) + 'd' + secondstostr5(Hours) + 'h';
end;

function Liefertag(Liefertag: TAnfixTime): TAnfixTime;
begin
  while WeekDay(Liefertag) in [6, 7] do
    Liefertag := DatePlus(Liefertag, 1);
  result := Liefertag;
end;

function VersendetagToStr(i: Integer): string;
begin
  case i of
    0:
      result := '?';
    1:
      result := 'entgültig vergriffen';
    2:
      result := 'zur Zeit vergriffen, Neuauflage jedoch ungewiss';
    3:
      result := 'zur Zeit vergriffen, Neuauflage jedoch sicher';
    11:
      result := '24 h';
    12:
      result := '48 h';
    13 .. 100:
      result := inttostr(i - 10) + ' Tage';
  else
    result := 'sofort';
  end;
end;

function LieferzeitInTagen(i: Integer): Integer;
begin
  if (i > 0) then
    result := 1 + (i div (24 * 3600))
  else
    result := 0;
end;

function e_r_Kunde(PERSON_R: Integer): string;
var
  cPERSON: TdboCursor;
  cANSCHRIFT: TdboCursor;
  BEGRIFF: string;
begin
  cPERSON := nCursor;
  with cPERSON do
  begin
    sql.Add('select VORNAME,NACHNAME,NUMMER,SUCHBEGRIFF,PRIV_ANSCHRIFT_R from PERSON where RID=' +
      inttostr(PERSON_R));
    ApiFirst;
  end;
  if not(cPERSON.eof) then
  begin

    cANSCHRIFT := nCursor;
    with cANSCHRIFT do
    begin
      sql.Add('select PLZ,STATE,ORT,LAND_R,STRASSE,NAME1,NAME2 from ANSCHRIFT where RID=' +
        cPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsString);
      ApiFirst;
    end;

    if (noblank(cPERSON.FieldByName('VORNAME').AsString + cPERSON.FieldByName('NACHNAME').AsString)
      <> '') then
    begin
      result :=
      { } e_r_NameVorname(cPERSON) +
      { } ' (' +
      { } cPERSON.FieldByName('NUMMER').AsString +
      { } ')';
    end
    else
    begin
      BEGRIFF := cANSCHRIFT.FieldByName('NAME1').AsString;
      if (BEGRIFF = '') then
        BEGRIFF := cPERSON.FieldByName('SUCHBEGRIFF').AsString;
      result := BEGRIFF + ' (' + cPERSON.FieldByName('NUMMER').AsString + ')';
    end;
    cANSCHRIFT.free;
  end
  else
  begin
    result := 'RID ' + inttostr(PERSON_R) + '?';
  end;
  cPERSON.free;
end;

var
  _e_r_Person_cPERSON: TdboCursor = nil;
  _e_r_Person_cANSCHRIFT: TdboCursor = nil;

function e_r_Person(PERSON_R: Integer): string;
var
  BEGRIFF: string;
begin

  if (PERSON_R=iSchnelleRechnung_PERSON_R) then
  begin
    result := '* schnelle Rechnung *';
    exit;
  end;

  if not(assigned(_e_r_Person_cPERSON)) then
  begin
    _e_r_Person_cPERSON := nCursor;
    with _e_r_Person_cPERSON do
    begin
      sql.Add('select');
      sql.Add(' VORNAME,');
      sql.Add(' NACHNAME,');
      sql.Add(' NUMMER,');
      sql.Add(' SUCHBEGRIFF,');
      sql.Add(' PRIV_ANSCHRIFT_R');
      sql.Add('from');
      sql.Add(' PERSON');
      sql.Add('where');
      sql.Add(' RID=:CROSSREF');
      open;
    end;

    _e_r_Person_cANSCHRIFT := nCursor;
    with _e_r_Person_cANSCHRIFT do
    begin
      sql.Add('select');
      sql.Add(' PLZ,');
      sql.Add(' STATE,');
      sql.Add(' ORT,');
      sql.Add(' LAND_R,');
      sql.Add(' STRASSE,');
      sql.Add(' NAME1,');
      sql.Add(' NAME2');
      sql.Add('from');
      sql.Add(' ANSCHRIFT');
      sql.Add('where');
      sql.Add(' RID=:CROSSREF');
      open;
    end;
  end;

  with _e_r_Person_cPERSON do
  begin
    Params[0].AsInteger := PERSON_R;
    ApiFirst;
    if not(eof) then
    begin
      if not(FieldByName('PRIV_ANSCHRIFT_R').IsNull) then
      begin
        _e_r_Person_cANSCHRIFT.Params[0].AsInteger := FieldByName('PRIV_ANSCHRIFT_R').AsInteger;
        _e_r_Person_cANSCHRIFT.ApiFirst;

        if (noblank(FieldByName('VORNAME').AsString + FieldByName('NACHNAME').AsString) <> '') then
        begin
          result :=
          { } e_r_name(_e_r_Person_cPERSON) +
          { } ' (' + FieldByName('NUMMER').AsString + ') ' +
          { } e_r_Ort(_e_r_Person_cANSCHRIFT)
        end
        else
        begin
          BEGRIFF := _e_r_Person_cANSCHRIFT.FieldByName('NAME1').AsString;
          if (BEGRIFF = '') then
            BEGRIFF := FieldByName('SUCHBEGRIFF').AsString;
          result :=
          { } BEGRIFF +
          { } ' (' + FieldByName('NUMMER').AsString + ') ' +
          { } e_r_Ort(_e_r_Person_cANSCHRIFT);
        end;
      end
      else
      begin
        if (noblank(FieldByName('VORNAME').AsString + FieldByName('NACHNAME').AsString) <> '') then
        begin
          result :=
          { } e_r_name(_e_r_Person_cPERSON) +
          { } ' (' + FieldByName('NUMMER').AsString + ')';
        end
        else
        begin
          result :=
          { } FieldByName('SUCHBEGRIFF').AsString +
          { } ' (' + FieldByName('NUMMER').AsString + ')';
        end;
      end;
    end
    else
    begin
      result := 'RID ' + inttostr(PERSON_R) + '?';
    end;
  end;
end;

function e_r_Person2Zeiler(PERSON_R: Integer): TStringList;
var
  cPERSON: TdboCursor;
  cANSCHRIFT: TdboCursor;
  n: Integer;
begin

  cPERSON := nCursor;
  with cPERSON do
  begin
    sql.Add('select * from PERSON where RID=' + inttostr(PERSON_R));
    ApiFirst;
  end;

  cANSCHRIFT := nCursor;
  with cANSCHRIFT do
  begin
    sql.Add('select * from ANSCHRIFT where RID=' + inttostr(cPERSON.FieldByName('PRIV_ANSCHRIFT_R')
      .AsInteger));
    ApiFirst;
  end;

  result := TStringList.create;

  result.Add(e_r_name(cPERSON));
  result.Add(cANSCHRIFT.FieldByName('NAME1').AsString);
  result.Add(cANSCHRIFT.FieldByName('NAME2').AsString);

  for n := pred(result.count) downto 0 do
    if result[n] = '' then
      result.Delete(n);
  while (result.count < 2) do
    result.Add('');

  cPERSON.free;
  cANSCHRIFT.free;

end;

function VormittagsToChar(vormittags: boolean): char;
begin
  if vormittags then
    result := 'V'
  else
    result := 'N';
end;

function VormittagsToTime(s: string): TDateTime;
begin
  s := s + '?';
  case s[1] of
    'V':
      result := cTime_09_00_00;
    'N':
      result := cTime_14_00_00;
  else
    result := 0;
  end;
end;

procedure AuftragBeforePost(Auftrag: TdboDataset; ReOrgMode: boolean);
var
  // PQ
  _Koordinaten: string;

  // Ortsteilcode
  _OrtsteilCode: string;
  _NewOrtsteilCode: string;

  // Strasse
  _HausNummer: Integer;
  _HausNummerNumerischerZusatz: Integer;
  _HausNummerZusatz: string;
  _FirstNummernPos: Integer;
  _LastNummernPos: Integer;
  _strasseFull: string;
  _STRASSE: string;
  _NewStrasseIndex: string;
  _strasseName: string;
  n: Integer;
  GeradeUngerade: string;
  _Wohneinheit: string;

  // Name
  _Name: string;

  TerminChanged: boolean;
  MonteurChanged: boolean;
  MakeHistCopy: boolean;

  // Nochmaliges Prüfen der Sperre
  _Sperre: TSperre;
  Umstand: TStringList;
  Kontext: Integer;

  // cached Fields
  STATUS: TePhaseStatus; // aktueller Status
  MONTEUR_R: Integer; // ein Monteur
  _STATUS: TePhaseStatus; // Status bisher
  _sBearbeiter: Integer; // Barbeiter bisher

  // DebugInfo: string;
  cOldVersion: TdboCursor;
  cAnzHistorische: TdboCursor;
  InitialChange: boolean;
  AnzHistorische: Integer;

  OneWasReallyChanged: boolean;
  // Änderung von NULL auf irgendwas oder echte Änderung?!
  ZaehlerInfo: TStringList;

  // Plausibilitätsprüfung
  ZaehlerstandExact: double;
  JahresVerbrauch: double;
  Toleranzband: double;

begin
{$IFNDEF fpc}
  HistorischerErzeugt := false;
  _STATUS := ctsLast;
  if not(IgnoreAuftragPost) then
    with Auftrag do
    begin

      //
      STATUS := TePhaseStatus(FieldByName('STATUS').AsInteger);

      if (STATUS = ctsHistorisch) then
      begin
        // man kann überhaupt nur noch "MONTEUREXPORT" ändern!
        for n := 0 to pred(FieldCount) do
          if Fields[n].IsModified then
            if (Fields[n].FieldName <> 'MONTEUREXPORT') then
              Fields[n].Revert;
      end
      else
      begin

        // Aktuellen Datensatz-RID merken
        AuftragLastChangeRID := FieldByName('RID').AsInteger;

        // Liste der geänderten Datenfelder erstellen!
        AuftragLastChangeFields.clear;
        for n := 0 to pred(FieldCount) do
          if Fields[n].IsModified then
            AuftragLastChangeFields.Add(Fields[n].FieldName);

        // muss ein Historischer Datensatz gemacht werden?
        if (state = dssedit) then
        begin

          // gleichen Datensatz in der bisherigen Version laden:
          cOldVersion := nCursor;
          with cOldVersion do
          begin
            sql.Add('select');
            for n := 0 to pred(AuftragCriticalFields.count) do
              sql.Add(AuftragCriticalFields[n] + ',');
            sql.Add('STATUS, AUSFUEHREN, VORMITTAGS, MONTEUR1_R, MONTEUR2_R,BEARBEITER_R');
            sql.Add('from AUFTRAG where RID=' + inttostr(AuftragLastChangeRID));
            ApiFirst;
          end;

          _STATUS := TePhaseStatus(cOldVersion.FieldByName('STATUS').AsInteger);
          _sBearbeiter := cOldVersion.FieldByName('BEARBEITER_R').AsInteger;

          // Bei Neu Anschreiben kann es noch keinen Termin geben!
          if (STATUS = ctsNeuAnschreiben) and (_STATUS <> ctsNeuAnschreiben) then
            if FieldByName('VORMITTAGS').IsNotNull then
              FieldByName('VORMITTAGS').clear;

          //
          MonteurChanged := false; // wurde der Monteur verändert / gelöscht
          TerminChanged := false; // wurde der Termin geändert / gelöscht?
          InitialChange := false; // war es ein Ersteintrag?
          AnzHistorische := -1;
          // war das überhaupt schon terminiert?

          // Änderung im Termin-Datum?
          repeat

            if (cOldVersion.FieldByName('AUSFUEHREN').AsDate <> FieldByName('AUSFUEHREN').AsDate)
            then
            begin
              TerminChanged := true;
              break;
            end;

            if (cOldVersion.FieldByName('VORMITTAGS').AsString <> FieldByName('VORMITTAGS').AsString)
            then
            begin
              TerminChanged := true;
              break;
            end;

          until true;

          // Änderung in der Monteur-Zuordnung?
          repeat

            if (cOldVersion.FieldByName('MONTEUR1_R').AsString <> FieldByName('MONTEUR1_R').AsString)
            then
            begin
              MonteurChanged := true;
              break;
            end;

            if (cOldVersion.FieldByName('MONTEUR2_R').AsString <> FieldByName('MONTEUR2_R').AsString)
            then
            begin
              MonteurChanged := true;
              break;
            end;

          until true;

          if TerminChanged and FieldByName('VERBRAUCH_PRO_JAHR').IsNotNull then
          begin

            // Die Plausibilitätskennzahlen neu errechnen
            JahresVerbrauch := strtodouble(FieldByName('VERBRAUCH_PRO_JAHR').AsString);

            ZaehlerstandExact := strtodouble(FieldByName('VERBRAUCH_ZAEHLER_STAND').AsString) +
              (JahresVerbrauch / 365.0) *

              DateDiff(DateTime2Long(FieldByName('VERBRAUCH_DATUM').AsDate),
              DateTime2Long(FieldByName('AUSFUEHREN').AsDate));

            Toleranzband := JahresVerbrauch * (3.0 / 12.0);

            ZaehlerInfo := TStringList.create;
            FieldByName('ZAEHLER_INFO').assignto(ZaehlerInfo);

            ZaehlerInfo.values['P0'] := inttostr(round(ZaehlerstandExact - Toleranzband));
            ZaehlerInfo.values['P1'] := inttostr(round(ZaehlerstandExact + Toleranzband));
            FieldByName('ZAEHLER_INFO').assign(ZaehlerInfo);
            ZaehlerInfo.free;
          end;

          // Verlust des Monteur-Informiert bei änderungen von
          //
          // * termin
          // * Monteur
          // * Monteur-Info
          //
          if MonteurChanged or TerminChanged or FieldByName('MONTEUR_INFO').IsModified then
          begin
            if FieldByName('MONTEUREXPORT').IsNotNull then
            begin
              ForceHistorischer := true;
              FieldByName('MONTEUREXPORT').clear;
            end;
          end;

          //
          // if TerminChanged then
          // FieldByName('WORDEXPORT').clear;  Wegfall Rev. 1.038
          // noch mal diskutieren
          //

          if TerminChanged or MonteurChanged then
          begin
            if (sBearbeiter <> cNoBearbeiter) then
              FieldByName('TERMINIERT_R').AsInteger := sBearbeiter;
          end;

          // Erzeugung eines Historischen Datensatzes ?

          MakeHistCopy := ForceHistorischer or MonteurChanged or TerminChanged or
            (sBearbeiter <> _sBearbeiter);

          if not(MakeHistCopy) then
            for n := 0 to pred(AuftragCriticalFields.count) do
              if FieldByName(AuftragCriticalFields[n]).IsModified then
              begin
                MakeHistCopy := true;
                break;
              end;

          // war zuvor alles "0"
          if MakeHistCopy and not(ForceHistorischer) then
          begin

            cAnzHistorische := nCursor;
            with cAnzHistorische do
            begin
              sql.Add('select count(rid) from AUFTRAG where (MASTER_R=' +
                inttostr(AuftragLastChangeRID) + ') and (STATUS=6)');
              ApiFirst;
              AnzHistorische := Fields[0].AsInteger;
            end;
            cAnzHistorische.free;

            repeat

              if (AnzHistorische > 0) then
                break;
              if FieldByName('AUSFUEHREN').IsModified then
                if cOldVersion.FieldByName('AUSFUEHREN').IsNotNull then
                  break;
              if FieldByName('VORMITTAGS').IsModified then
                if cOldVersion.FieldByName('VORMITTAGS').IsNotNull then
                  break;
              if FieldByName('MONTEUR1_R').IsModified then
                if cOldVersion.FieldByName('MONTEUR1_R').IsNotNull then
                  break;
              if FieldByName('MONTEUR2_R').IsModified then
                if cOldVersion.FieldByName('MONTEUR2_R').IsNotNull then
                  break;

              // sonstige Felder
              OneWasReallyChanged := false;
              for n := 0 to pred(AuftragCriticalFields.count) do
                if FieldByName(AuftragCriticalFields[n]).IsModified then
                  if cOldVersion.FieldByName(AuftragCriticalFields[n]).IsNotNull then
                  begin
                    OneWasReallyChanged := true;
                    break;
                  end;
              if OneWasReallyChanged then
                break;

              MakeHistCopy := false;
            until true;
          end;

          //
          if MakeHistCopy then
          begin

            //
            // ein historischer Datensatz wird erzeugt!
            // man bucht weiterhin auf dem original-Datensatz
            // der "historische" ist eigentlich eine Neuanlage (mit allen Daten des
            // alten Datensatzes! MASTER_R wird ja auch kopiert, somit ist die
            // Referenz auf das Original gegeben
            //
            // DebugInfo := DebugInfo + 'HistCopy ';
            AuftragHistorischerDatensatz(AuftragLastChangeRID);

            HistorischerErzeugt := true;
          end;

          cOldVersion.free;

        end;

        // Sicherstellen, dass es immer einen Hauptmonteur gibt!
        if FieldByName('MONTEUR2_R').IsNotNull then
          if FieldByName('MONTEUR1_R').IsNull then
          begin
            FieldByName('MONTEUR1_R').assign(FieldByName('MONTEUR2_R'));
            FieldByName('MONTEUR2_R').clear;
          end;

        // Meldungsdatum Monda eintragen
        if (STATUS = ctsErfolg) then
          FieldByName('MONDA_MELDUNG').assign(FieldByName('ZAEHLER_WECHSEL'));
        if (STATUS = ctsUnmoeglich) then
          if FieldByName('MONDA_MELDUNG').IsNull then
            FieldByName('MONDA_MELDUNG').AsDateTime := now;

        // leeren Aufwand setzen
        with FieldByName('AUFWAND') do
          if IsNull then
            if (FieldByName('AUFWAND_SCHUTZ').AsString <> 'Y') then
              AsInteger := e_r_EinzelAufwand(FieldByName('BAUSTELLE_R').AsInteger);

        // Word-Status wegmachen
        if (STATUS = ctsNeuAnschreiben) then
        begin

          if (_STATUS = ctsNeuAnschreiben) then
          begin

            // es ist wieder Word-Export gesetzt worden!
            if FieldByName('WORDEXPORT').IsNotNull then
            begin
              FieldByName('STATUS').AsInteger := ord(ctsMonteurInformiert);
              STATUS := ctsMonteurInformiert;
            end;

            // Ist wieder ein Termin drin, muss Neu anschreiben gelöscht werden!
            if FieldByName('VORMITTAGS').IsNotNull and FieldByName('AUSFUEHREN').IsNotNull then
              STATUS := ctsTerminiert;

          end
          else
          begin

            // Word-Export darf gelöscht werden!
            if FieldByName('WORDEXPORT').IsNotNull then
              FieldByName('WORDEXPORT').clear;
          end;

        end;

        // Names-Index aufbauen
        _Name := cutblank(FieldByName('KUNDE_NAME1').AsString);
        if (_Name = '') then
          _Name := cutblank(FieldByName('KUNDE_NAME2').AsString);
        n := revpos(' ', _Name);
        if n > 0 then
          _Name := copy(_Name, succ(n), MaxInt) + copy(_Name, 1, pred(n));
        _Name := PrepareAsIndex(_Name);

        // Geo-Lokalisierung ev. aufheben
        if FieldByName('POSTLEITZAHL_R').IsNotNull then
          if FieldByName('KUNDE_STRASSE').IsModified or FieldByName('KUNDE_ORT').IsModified then
            FieldByName('POSTLEITZAHL_R').clear;

        // Bildung des Strassen Index
        _strasseFull := AnsiUpperCase(FieldByName('KUNDE_STRASSE').AsString);
        _STRASSE := FieldByName('STRASSE').AsString;
        _OrtsteilCode := FieldByName('KUNDE_ORTSTEIL_CODE').AsString;
        _NewOrtsteilCode := e_r_OrtsteilCode(FieldByName('BAUSTELLE_R').AsInteger,
          FieldByName('KUNDE_ORTSTEIL').AsString);

        // Planquadrat, leere unten!!
        _Koordinaten := cutblank(FieldByName('PLANQUADRAT').AsString);
        _Koordinaten := copy(_Koordinaten + fill('z', cSTRASSE_PLANQUADRAT_Length -
          length(_Koordinaten)), 1, cSTRASSE_PLANQUADRAT_Length);

        // Extraction der Wohneinheit
        _Wohneinheit := ObtainStrassenWohnungseinheit(_strasseFull);
        if (_Wohneinheit <> '') then
          _Wohneinheit := fill('0', cSTRASSE_Wohneinheit_Length - length(_Wohneinheit)) +
            _Wohneinheit + ':';

        // Extraction der Hausnummer
        ObtainStrasseHausnummerPos(_strasseFull, _FirstNummernPos, _LastNummernPos);

        // Nur den Strassen Namen bestimmen
        if (_FirstNummernPos = 0) then
          _strasseName := _strasseFull
        else
          _strasseName := cutblank(copy(_strasseFull, 1, pred(_FirstNummernPos)));

        // Hausnummer numerisch bestimmen
        if (_FirstNummernPos > 0) then
          _HausNummer := strtol(cutblank(copy(_strasseFull, _FirstNummernPos,
            succ(_LastNummernPos - _FirstNummernPos))))
        else
          _HausNummer := 0;

        if (_LastNummernPos = 0) then
        begin
          _HausNummerZusatz := '';
          _HausNummerNumerischerZusatz := 0;
        end
        else
        begin
          _HausNummerZusatz :=
            cutblank(nextp(copy(_strasseFull, succ(_LastNummernPos), MaxInt), '#', 0));
          _HausNummerNumerischerZusatz :=
            strtointdef(ObtainStrassenHausNummerNumerischerZusatz(_strasseFull), 0);
        end;

        // Gerade und ungerade Hausnummern
        if odd(_HausNummer) or (FieldByName('EVENODD').AsString = cC_True) then
          GeradeUngerade := '0'
        else
          GeradeUngerade := '1';

        _NewStrasseIndex := { }
        { 1 } _NewOrtsteilCode + // length=0..2
        { 2 } _Koordinaten + // length=cPLANQUADRAT_Length
        { 3 } StrasseUnify(_strasseName) +
        { 4 } GeradeUngerade +
        { 5 } inttostrN(_HausNummer, cSTRASSE_HausNummern_Length) +
        { 6 } inttostrN(_HausNummerNumerischerZusatz, cSTRASSE_HausnummerNumerischerZusatz_Length) +
        { 7 } _HausNummerZusatz + ':' +
        { 8 } _Wohneinheit +
        { 9 } _Name +
        { 10 } '.'; // Blank am Ende kann firebird nicht speichern!
        // Workaround = '.'

        if (_OrtsteilCode <> _NewOrtsteilCode) then
        begin

          // ShowMessage(_OrtsteilCode+#13+_NewOrtsteilCode);
          if (_NewOrtsteilCode = '') then
          begin
            FieldByName('KUNDE_ORTSTEIL_CODE').clear;
          end
          else
          begin
            FieldByName('KUNDE_ORTSTEIL_CODE').AsString := _NewOrtsteilCode;
          end;

        end;

        if (_STRASSE <> _NewStrasseIndex) then
        begin
          FieldByName('STRASSE').AsString := _NewStrasseIndex;
        end;

        // Bearbeiter eintragen
        if not(ReOrgMode) and (AuftragLastChangeFields.count > 0) then
        begin
          if (sBearbeiter <> cNoBearbeiter) then
          begin
            FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
            FieldByName('GEAENDERT').AsDateTime := now;
          end;
        end;

        // EXPORT_TAN löschung sicherstellen!
        if FieldByName('EXPORT_TAN').IsNotNull then
          if not(STATUS in [ctsVorgezogen, ctsUnmoeglich, ctsErfolg, ctsHistorisch]) then
            FieldByName('EXPORT_TAN').clear;

        if not(STATUS in [ctsVorgezogen, ctsUnmoeglich, ctsErfolg, ctsRestant, ctsNeuAnschreiben])
        then
        begin
          repeat

            // den Status manipulieren!
            if ((FieldByName('AUSFUEHREN').IsNull) or (pos(FieldByName('VORMITTAGS').AsString,
              cVormittagsChar + cNachmittagsChar) = 0)) and FieldByName('ZAEHLER_WECHSEL').IsNull
            then
            begin
              // unvollständige Daten!
              FieldByName('STATUS').AsInteger := ord(ctsDatenFehlen);
              FieldByName('WORDEXPORT').clear;
              FieldByName('FITNESS').AsInteger := ord(cisOK);
              break;
            end;

            //
            if FieldByName('ZAEHLER_WECHSEL').IsNull then
            begin

              if (FieldByName('MONTEUREXPORT').IsNotNull) then
              begin
                FieldByName('STATUS').AsInteger := ord(ctsMonteurInformiert);
              end
              else
              begin
                if FieldByName('WORDEXPORT').IsNull then
                  FieldByName('STATUS').AsInteger := ord(ctsTerminiert)
                else
                  FieldByName('STATUS').AsInteger := ord(ctsAngeschrieben);
              end;

            end;

          until true;

        end;

        // Sperre setzen!
        if FieldByName('AUSFUEHREN').IsNotNull and
          (pos(FieldByName('VORMITTAGS').AsString, cVormittagsChar + cNachmittagsChar) > 0) and
          (FieldByName('AUSFUEHREN').AsDate > long2datetime(cMonDa_ErsterTermin)) then
        begin
          // Status-Flag prüfen, SPERREN!
          _Sperre := TSperre.create;
          Umstand := TStringList.create;

          // Termin wurde angelegt!
          // hier die Sperren testen!
          MONTEUR_R := FieldByName('MONTEUR1_R').AsInteger;
          if (MONTEUR_R >= cRID_FirstValid) then
          begin
            e_r_MonteurUrlaub(MONTEUR_R, _Sperre);
            Umstand.Add(e_r_MonteurKuerzel(MONTEUR_R));
          end;

          MONTEUR_R := FieldByName('MONTEUR2_R').AsInteger;
          if (MONTEUR_R >= cRID_FirstValid) then
          begin
            e_r_MonteurUrlaub(MONTEUR_R, _Sperre);
            Umstand.Add(e_r_MonteurKuerzel(MONTEUR_R));
          end;

          Kontext := e_r_BaustelleAddSperre(FieldByName('BAUSTELLE_R').AsInteger, Umstand, _Sperre);
          if not(FieldByName('SPERRE_VON').IsNull) and not(FieldByName('SPERRE_BIS').IsNull) then
          begin
            _Sperre.Add(FieldByName('SPERRE_VON').AsDate, FieldByName('SPERRE_BIS').AsDate, true,
              cSperreZaehler);
          end;

          if not(FieldByName('ZEITRAUM_VON').IsNull) and not(FieldByName('ZEITRAUM_BIS').IsNull)
          then
          begin
            _Sperre.Add(FieldByName('ZEITRAUM_VON').AsDate, FieldByName('ZEITRAUM_BIS').AsDate,
              false, cSperreZaehler);
          end;

          if _Sperre.CheckIt(FieldByName('AUSFUEHREN').AsDate +
            VormittagsToTime(FieldByName('VORMITTAGS').AsString), Kontext) <> TColors.SysDefault
          then
            FieldByName('FITNESS').AsInteger := ord(cisSperreVerletzt)
          else
            FieldByName('FITNESS').AsInteger := ord(cisOK);

          _Sperre.free;
          Umstand.free;
        end
        else
        begin
          FieldByName('FITNESS').AsInteger := ord(cisOK);
        end;

        // ungesetzer Master?
        if FieldByName('MASTER_R').IsNull then
        begin
          if (FieldByName('RID').AsInteger <> 0) then
            FieldByName('MASTER_R').AsInteger := FieldByName('RID').AsInteger;
        end
        else
        begin
          if (FieldByName('RID').AsInteger <> 0) then
          begin
            if FieldByName('MASTER_R').AsInteger <> FieldByName('RID').AsInteger then
              FieldByName('STATUS').AsInteger := ord(ctsHistorisch);
          end;
        end;

      end;
      //
      // AppendStringsToFile(DebugInfo, ContextPath + inttostr(DateGet) + '.txt');
    end;
  ForceHistorischer := false;
  IgnoreAuftragPost := false;
{$ENDIF}
end;

const
  IB_DSQL1: TdboScript = nil;
  IB_DSQL2: TdboScript = nil;

procedure AuftragHistorischerDatensatz(AUFTRAG_R: Integer);
begin
  if not(assigned(IB_DSQL1)) then
  begin
    IB_DSQL1 := nScript;
    with IB_DSQL1 do
    begin
      sql.Add('INSERT INTO');
      sql.Add(' AUFTRAG');
      sql.Add('SELECT');
      sql.Add(' *');
      sql.Add('FROM');
      sql.Add(' AUFTRAG');
      sql.Add('WHERE ');
      sql.Add(' RID=:CROSSREF');
{$IFNDEF fpc}
      prepare;
{$ENDIF}
    end;
    IB_DSQL2 := nScript;
    with IB_DSQL2 do
    begin
      sql.Add('UPDATE');
      sql.Add(' AUFTRAG');
      sql.Add('SET');
      sql.Add(' STATUS_BISHER=STATUS,');
      sql.Add(' STATUS=6');
      sql.Add('WHERE');
      sql.Add(' (MASTER_R=:CROSSREF) AND');
      sql.Add(' (MASTER_R<>RID) AND');
      sql.Add(' (STATUS_BISHER is null)');
    end;
  end;

  // Kopie anlegen
  with IB_DSQL1 do
  begin
    ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
    execute;
  end;

  // nun in den historischen Status versetzen
  with IB_DSQL2 do
  begin
    ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
    execute;
  end;

end;

procedure AuftragHistorischerDatensatz(AUFTRAG_R: TList);
var
  n: Integer;
begin
  for n := 0 to pred(AUFTRAG_R.count) do
    AuftragHistorischerDatensatz(Integer(AUFTRAG_R[n]));
end;

function SAP2Art(Material: string): string;

begin
  result := '??';
  Material := noblank(AnsiUpperCase(Material));
  repeat

    // WA = Wasser
    if (pos('WASSER', Material) > 0) or (pos('QN', Material) > 0) or (Material = 'W') or
      (Material = 'WA') then
    begin
      result := 'WA';
      break;
    end;

    // D = Drehstrom
    if (pos('DREH', Material) > 0) and (pos('STROM', Material) > 0) then
    begin
      result := 'D';
      break;
    end;
    if (pos('DE-', Material) > 0) or (pos('DZ-', Material) > 0) then
    begin
      result := 'D';
      break;
    end;
    if (pos('230/400V', Material) > 0) then
    begin
      result := 'D';
      break;
    end;
    if (pos('220/380V', Material) > 0) then
    begin
      result := 'D';
      break;
    end;

    // WE = Wechselstrom
    if (pos('WECHSEL', Material) > 0) and (pos('STROM', Material) > 0) then
    begin
      result := 'WE';
      break;
    end;
    if (pos('WE-', Material) > 0) or (pos('WZ-', Material) > 0) then
    begin
      result := 'WE';
      break;
    end;
    if (pos('230V', Material) > 0) then
    begin
      result := 'WE';
      break;
    end;
    if (pos('220V', Material) > 0) then
    begin
      result := 'WE';
      break;
    end;

    // E = Strom beliebig
    if (pos('STROM', Material) > 0) then
    begin
      result := 'E';
      break;
    end;

    // G = Gas
    if (pos('GAS', Material) > 0) or (pos('G', Material) = 1) then
    begin
      result := 'G';
      break;
    end;

    if (pos('BGZ', Material) > 0) or (pos('G4', Material) > 1) or (pos('G6', Material) > 1) or
      (pos('G10', Material) > 1) or (pos('G16', Material) > 1) or (pos('G25', Material) > 1) or
      (pos('BK4', Material) > 0) or (pos('BK6', Material) > 0) then
    begin
      result := 'G';
      break;
    end;

    //
    if (pos('WÄRME', Material) > 0) then
    begin
      result := 'WM';
      break;
    end;
    if (pos('VOLUMEN', Material) > 0) then
    begin
      result := 'G';
      break;
    end;
    if (pos('RC', Material) > 0) then
    begin
      result := 'RS';
      break;
    end;
    if (pos('M3', Material) > 0) then
    begin
      result := 'G';
      break;
    end;
    if (pos('KW', Material) > 0) then
    begin
      result := 'E';
      break;
    end;
    if (pos('MW', Material) > 0) then
    begin
      result := 'E';
      break;
    end;
    if (pos('WIRK', Material) > 0) then
    begin
      result := 'E';
      break;
    end;
    if (pos('BLIND', Material) > 0) then
    begin
      result := 'E';
      break;
    end;
  until true;
end;

function ReadLongStr(BlockName: string; ArtikelInfo: TStringList; delimiter: char = #13): string;
var
  MachineState: byte;
  n, k: Integer;
begin
  result := '';
  MachineState := 0;
  for n := 0 to pred(ArtikelInfo.count) do
  begin
    case MachineState of
      0:
        begin
          k := pos(BlockName + '=', ArtikelInfo[n]);
          if (k = 1) then
          begin
            result := copy(ArtikelInfo[n], length(BlockName) + 2, MaxInt);
            MachineState := 1;
          end;
        end;
      1:
        begin
          k := pos('=', ArtikelInfo[n]);
          if (k = 0) or (k > 11) then
            result := result + delimiter + ArtikelInfo[n]
          else
            exit;
        end;
    end;
  end;
end;

procedure EnsureHints(hints: TStrings);
var
  n: Integer;
begin
  hints.clear;
  for n := low(cQueryHint) to high(cQueryHint) do
    hints.Add(cQueryHint[n]);
end;

procedure e_w_AuftrageMail(AUFTRAG_R: Integer);
var
  cBAUSTELLE: TdboCursor;
  cAUFTRAG: TdboCursor;
begin
  // Baustellen-Vorlage laden
  cBAUSTELLE := nCursor;
  cAUFTRAG := nCursor;
  repeat

    //
    with cAUFTRAG do
    begin
      sql.Add('select * from AUFTRAG where RID=' + inttostr(AUFTRAG_R));
      ApiFirst;
      if eof then
        break;
    end;

    //
    with cBAUSTELLE do
    begin
      sql.Add('select * from BAUSTELLE where RID=' + cAUFTRAG.FieldByName('BAUSTELLE_R').AsString);
      ApiFirst;
      if eof then
        break;
    end;

  until true;
  // Ausbelichten
  // eMail mit html-Attachement versenden
  cBAUSTELLE.free;
  cAUFTRAG.free;
end;

function e_r_BaustelleFotoPath(BAUSTELLE_R: TDOM_Reference): string;
begin
  result :=
  { } iBaustellenPath +
  { } e_r_BaustelleKuerzel(BAUSTELLE_R) +
  { } '\' + cFotosPath;
end;

function e_r_BaustelleUploadPath(BAUSTELLE_R: TDOM_Reference): string;
begin
  result :=
  { } iBaustellenPath +
  { } e_r_BaustelleKuerzel(BAUSTELLE_R) +
  { } '\Upload\';
end;

procedure e_w_GrabFotos;
const
  cBildFName = 'Bilder.ini';
var
  lBAUSTELLEN: TgpIntegerList;
  LokaleBilder: TStringList;
  RemoteBilder: TStringList;
  RemoteFotos: TStringList;
  RemoteBilderUnbenannt: TStringList;
  ZipOptions: TStringList;
  WorkPath: string;
  FotoFTP: TIdFTP;
  settings: TStringList;
  n: Integer;
  ZipFileCount: Integer;
  m: Integer;
  LocalFSize, RemoteFSize: Int64;
begin
  //
  if (FotoPath <> '') then
  begin

    lBAUSTELLEN :=
      e_r_sqlm('select RID from BAUSTELLE where NUMMERN_PREFIX starts with ''+'' order by NUMMERN_PREFIX');

    for m := 0 to pred(lBAUSTELLEN.count) do
    begin

      LokaleBilder := TStringList.create;
      RemoteBilder := TStringList.create;
      RemoteFotos := TStringList.create;
      RemoteBilderUnbenannt := TStringList.create;
      ZipOptions := TStringList.create;
      FotoFTP := TIdFTP.create;

      // checks
      settings := e_r_sqlt('select EXPORT_EINSTELLUNGEN from BAUSTELLE where RID=' +
        inttostr(lBAUSTELLEN[m]));

      CheckCreateDir(FotoPath);
      WorkPath := FotoPath + e_r_BaustellenPfadFoto(settings) + '\';
      CheckCreateDir(WorkPath);
      if FileExists(WorkPath + cBildFName) then
        LokaleBilder.LoadFromFile(WorkPath + cBildFName);

      SolidInit(FotoFTP);
      with FotoFTP do
      begin
        Host := e_r_ParameterFoto(settings, cE_FTPHOST);
        UserName := nextp(e_r_ParameterFoto(settings, cE_FTPUSER), '\', 0);
        Password := e_r_ParameterFoto(settings, cE_FTPPASSWORD);
      end;
      ZipOptions.Add('Password=' + e_r_ParameterFoto(settings, cE_ZIPPASSWORD));

      SolidBeginTransaction;
      try
        //
        SolidLog(cINFOText + ' ' + FotoFTP.UserName + ' ...');

        // Prüfungen
        if (FotoFTP.Host = '') then
          raise Exception.create('FTP-Host hat keinen Eintrag');
        if (FotoFTP.UserName = '') then
          raise Exception.create('FTP-Username hat keinen Eintrag');
        if (FotoFTP.Password = '') then
          raise Exception.create('FTP-Password hat keinen Eintrag');
        if (WorkPath = '') then
          raise Exception.create('Verzeichnis hat keinen Eintrag');

        // Check if some news ...
        SolidDir(FotoFTP, '', '????-Bilder.zip', RemoteBilder);
        SolidDir(FotoFTP, '', 'Fotos-????.zip', RemoteFotos);
        SolidDir(FotoFTP, '', '????-Bilder_Unbenannt.zip', RemoteBilderUnbenannt);
        RemoteBilder.AddStrings(RemoteBilderUnbenannt);
        RemoteBilder.AddStrings(RemoteFotos);
        for n := 0 to pred(RemoteBilder.count) do
        begin
          if LokaleBilder.values[RemoteBilder[n]] = '' then
          begin

            // Prüfen ob es die Datei ev. schon gibt
            LocalFSize := FSize(WorkPath + RemoteBilder[n]);

            if (LocalFSize > cFSize_NotExists) then
              RemoteFSize := SolidSize(FotoFTP, '', RemoteBilder[n])
            else
              RemoteFSize := cFSize_Null;

            if (LocalFSize = RemoteFSize) then
            begin
              // skip ...
              LokaleBilder.values[RemoteBilder[n]] := inttostr(0) + ';' + sTimeStamp;
              LokaleBilder.SaveToFile(WorkPath + cBildFName);
              continue;
            end;

            SolidLog(cINFOText + ' get ' + RemoteBilder[n]);
            // lade ...
            if SolidGet(FotoFTP, '', RemoteBilder[n], WorkPath) then
            begin
              ZipFileCount := unzip(WorkPath + RemoteBilder[n], WorkPath, ZipOptions);
              if (ZipFileCount > 0) then
              begin
                LokaleBilder.values[RemoteBilder[n]] := inttostr(ZipFileCount) + ';' + sTimeStamp;
                LokaleBilder.SaveToFile(WorkPath + cBildFName);
              end;
            end;

          end;
        end;
      except
        on E: Exception do
        begin
          SolidLog(cERRORText + ' Fotos laden: ' + E.Message);
        end;
      end;
      SolidLog(cINFOText + ' ... OK');
      SolidEndTransaction;

      //
      LokaleBilder.free;
      RemoteBilder.free;
      RemoteFotos.free;
      RemoteBilderUnbenannt.free;
      settings.free;
      ZipOptions.free;
      FotoFTP.free;
    end;
    lBAUSTELLEN.free;

  end;
end;

type
  TFotoCallBacks = class(TObject)
    function ZaehlerNummerNeu(rid: Integer; FotoGeraeteNo: string): string;
  end;

  { TFotoCallBacks }

function TFotoCallBacks.ZaehlerNummerNeu(rid: Integer; FotoGeraeteNo: string): string;
begin
  result := '';
end;

const
  FotoName_JonDaX: TJonDaExec = nil;
  FotoName_CallBacks: TFotoCallBacks = nil;

function e_r_FotoName(AUFTRAG_R: Integer; MeldungsName: string; AktuellerWert: string = ''): string;
var
  cAUFTRAG: TdboCursor;
  sResult: TStringList;
  sParameter: TStringList;
  sZaehlerInfo: TStringList;
  BAUSTELLE_R: Integer;
  sSettings: TStringList;
begin

  if (FotoName_JonDaX = nil) then
  begin
    FotoName_JonDaX := TJonDaExec.create;
    FotoName_CallBacks := TFotoCallBacks.create;
    FotoName_JonDaX.callback_ZaehlerNummerNeu := FotoName_CallBacks.ZaehlerNummerNeu;
  end;

  sParameter := TStringList.create;
  sZaehlerInfo := TStringList.create;
  cAUFTRAG := nCursor;
  sParameter.values[cParameter_foto_parameter] := MeldungsName;
  sParameter.values[cParameter_foto_RID] := inttostr(AUFTRAG_R);
  sParameter.values[cParameter_foto_Pfad] := AuftragMobilServerPath;

  with cAUFTRAG do
  begin
    sql.Add('select ');
    sql.Add(' AUFTRAG.ART,');
    sql.Add(' AUFTRAG.KUNDE_STRASSE,');
    sql.Add(' AUFTRAG.KUNDE_ORT,');
    sql.Add(' AUFTRAG.ZAEHLER_INFO,');
    sql.Add(' AUFTRAG.ZAEHLER_NUMMER,');
    sql.Add(' AUFTRAG.ZAEHLER_NR_NEU,');
    sql.Add(' AUFTRAG.BAUSTELLE_R,');
    sql.Add(' BAUSTELLE.NUMMERN_PREFIX');
    sql.Add('from AUFTRAG');
    sql.Add('join BAUSTELLE on');
    sql.Add(' (AUFTRAG.BAUSTELLE_R=BAUSTELLE.RID)');
    sql.Add('where');
    sql.Add(' (AUFTRAG.RID=' + inttostr(AUFTRAG_R) + ')');
    ApiFirst;
    BAUSTELLE_R := FieldByName('BAUSTELLE_R').AsInteger;
    sParameter.values[cParameter_foto_baustelle] := FieldByName('NUMMERN_PREFIX').AsString;
    sParameter.values[cParameter_foto_ART] := copy(FieldByName('ART').AsString, 1, 2);
    sParameter.values[cParameter_foto_strasse] := FieldByName('KUNDE_STRASSE').AsString;
    sParameter.values[cParameter_foto_ort] := FieldByName('KUNDE_ORT').AsString;
    e_r_sqlt(FieldByName('ZAEHLER_INFO'), sZaehlerInfo);
    sParameter.values[cParameter_foto_zaehler_info] := HugeSingleLine(sZaehlerInfo, '|');
    sParameter.values[cParameter_foto_zaehlernummer_alt] := FieldByName('ZAEHLER_NUMMER').AsString;
    sParameter.values[cParameter_foto_zaehlernummer_neu] := FieldByName('ZAEHLER_NR_NEU').AsString;
    // cParameter_foto_geraet = 'GERAET';
  end;

  // Modus noch ermitteln
  sSettings := e_r_sqlt('select EXPORT_EINSTELLUNGEN from BAUSTELLE where RID=' +
    inttostr(BAUSTELLE_R));
  sParameter.values[cParameter_foto_Modus] := sSettings.values[cE_FotoBenennung];
  sParameter.values[JonDaExec.cParameter_foto_Datei] := FotoPath + e_r_BaustellenPfad(sSettings) +
    '\' + nextp(AktuellerWert, ',', 0);
  sSettings.free;

  // Funktion ausführen
  sResult := FotoName_JonDaX.foto(sParameter);

  result := sResult.values[cParameter_foto_Fehler];
  if (result = '') then
    result :=
    { } sResult.values[cParameter_foto_neu] + ',' +
    { } sResult.values[cParameter_foto_fertig];

  sParameter.free;
  sZaehlerInfo.free;
  cAUFTRAG.free;

end;

procedure e_w_QAuftragEnsure(AUFTRAG_R: Integer);
var

  // SQL-Querys
  Auftrag: TdboQuery;
  POSTEN: TdboQuery;
  MEILENSTEIN: TdboQuery;

  //
  MeilenSteinDauer: Integer;
  MeilenSteinHatDauerInfo: boolean;
  MaxPostenDauer: Integer;
  StartDatum: TANFiXDate;
  _StartDatum: TANFiXDate;
  _DAUER: Integer;
  _GRUPPE: Integer;
  OneHasDauer: boolean;
  Verfall: TStringList;
  // Datum ; Posten-RID ; Meilenstein-RID
  OneLine: string;
  ErsterVerfall: boolean;
  OneHasNoAbschluss: boolean;
  ErsterVerfallAm: TANFiXDate;
  MaxAbschluss: TANFiXDate;
  VerfallGruppe_R: Integer;
begin

  Auftrag := nQuery;
  POSTEN := nQuery;
  MEILENSTEIN := nQuery;

  MaxPostenDauer := 0;
  MaxAbschluss := 0;
  OneHasDauer := false;
  Verfall := TStringList.create;
  OneHasNoAbschluss := false;
  StartDatum := 0;
  VerfallGruppe_R := cRID_Unset;
  ErsterVerfallAm := cIllegalDate;

  with Auftrag do
  begin
    sql.Add('SELECT * FROM QAUFTRAG WHERE RID=' + inttostr(AUFTRAG_R));
    for_update(sql);
    open;
    if eof then
      Exception.create('AUFTRAG nicht gefunden!');
    repeat

      if not(FieldByName('BEGINN').IsNull) then
      begin
        StartDatum := DateTime2Long(FieldByName('EINGANG').AsDateTime);
        break;
      end;

      if not(FieldByName('EINGANG').IsNull) then
      begin
        StartDatum := DateTime2Long(FieldByName('EINGANG').AsDateTime);
        break;
      end;

    until true;

  end;

  with POSTEN do
  begin
    sql.Add('SELECT * FROM QPOSTEN WHERE QAUFTRAG_R=' + inttostr(AUFTRAG_R));
    for_update(sql);
    open;
  end;

  with MEILENSTEIN do
  begin
    sql.Add('SELECT * FROM MEILENSTEIN WHERE QPOSTEN_R=:CROSSREF');
    sql.Add('ORDER BY POSNR,RID');
    for_update(sql);
    open;
  end;

  POSTEN.First;
  while not(POSTEN.eof) do
  begin

    MEILENSTEIN.ParamByName('CROSSREF').AsInteger := POSTEN.FieldByName('RID').AsInteger;
    MeilenSteinHatDauerInfo := false;
    MeilenSteinDauer := 0;
    _StartDatum := StartDatum;
    ErsterVerfall := true;

    // ABSCHLUSS_AKTUELL

    MEILENSTEIN.First;
    while not(MEILENSTEIN.eof) do
    begin

      // Dauer erhöhen
      if not(MEILENSTEIN.FieldByName('DAUER').IsNull) then
      begin
        _DAUER := MEILENSTEIN.FieldByName('DAUER').AsInteger;
        MeilenSteinHatDauerInfo := true;
        OneHasDauer := true;
        MeilenSteinDauer := MeilenSteinDauer + _DAUER;
      end
      else
      begin
        _DAUER := 0;
      end;

      // Start-Datum Sachen
      if (_StartDatum <> 0) then
      begin

        // neuen Begin buchen
        if (_StartDatum <> DateTime2Long(MEILENSTEIN.FieldByName('BEGINN').AsDateTime)) then
        begin
          MEILENSTEIN.edit;
          MEILENSTEIN.FieldByName('BEGINN').AsDateTime := long2datetime(_StartDatum);
          MEILENSTEIN.post;
        end;
        _StartDatum := WerktagDatePlus(_StartDatum, _DAUER);

        // Verfall berechnen
        if MEILENSTEIN.FieldByName('ABSCHLUSS').IsNull then
        begin
          OneHasNoAbschluss := true;

          if ErsterVerfall then
          begin
            ErsterVerfallAm := _StartDatum;
            VerfallGruppe_R := MEILENSTEIN.FieldByName('GRUPPE_R').AsInteger;
          end;

          Verfall.addobject(inttostr(_StartDatum) + ';' + POSTEN.FieldByName('RID').AsString + ';' +
            MEILENSTEIN.FieldByName('RID').AsString,
            TObject(MEILENSTEIN.FieldByName('GRUPPE_R').AsInteger));
          ErsterVerfall := false;
        end
        else
        begin
          MaxAbschluss := max(MaxAbschluss, DateTime2Long(MEILENSTEIN.FieldByName('ABSCHLUSS')
            .AsDateTime));
        end;
      end;

      // nächster Datensatz
      MEILENSTEIN.next;
    end;

    with POSTEN do
    begin

      edit;

      // DAUER
      if MeilenSteinHatDauerInfo then
        FieldByName('DAUER').AsInteger := MeilenSteinDauer
      else
        FieldByName('DAUER').clear;

      // VERFALL
      if not(ErsterVerfall) then
      begin
        FieldByName('VERFALL').AsDateTime := long2datetime(ErsterVerfallAm);
        if (VerfallGruppe_R >= cRID_FirstValid) then
          FieldByName('GRUPPE_R').AsInteger := VerfallGruppe_R
        else
          FieldByName('GRUPPE_R').clear;
      end
      else
      begin
        FieldByName('VERFALL').clear;
        FieldByName('GRUPPE_R').clear;
      end;

      // BESITZ-ÜBERNAHME
      if FieldByName('OWNER_R').IsNull then
        if not(Auftrag.FieldByName('OWNER_R').IsNull) then
          FieldByName('OWNER_R').AsInteger := Auftrag.FieldByName('OWNER_R').AsInteger;

      post;

      MaxPostenDauer := max(MaxPostenDauer, MeilenSteinDauer);
    end;

    POSTEN.next;
  end;

  // Im Auftrag die Daten setzen
  with Auftrag do
  begin

    edit;

    if not(OneHasNoAbschluss) and DateOK(MaxAbschluss) then
    begin
      FieldByName('ABSCHLUSS').AsDateTime := long2datetime(MaxAbschluss);
    end
    else
    begin
      FieldByName('ABSCHLUSS').clear;
    end;

    // Autoset Begin
    if not(FieldByName('EINGANG').IsNull) then
      FieldByName('BEGINN').assign(FieldByName('EINGANG'));

    //
    FieldByName('DAUER').AsInteger := MaxPostenDauer;
    if not(FieldByName('EINGANG').IsNull) and OneHasDauer then
      FieldByName('ABSCHLUSS_C').AsDateTime :=
        long2datetime(WerktagDatePlus(DateTime2Long(FieldByName('EINGANG').AsDateTime),
        MaxPostenDauer))
    else
      FieldByName('ABSCHLUSS_C').clear;

    // Verfall
    if (Verfall.count > 0) then
    begin
      Verfall.sort;
      OneLine := Verfall[0];
      FieldByName('VERFALL').AsDateTime := long2datetime(strtoint(nextp(OneLine, ';')));

      HANDLUNGSBEDARF_POSTEN_RID := strtoint(nextp(OneLine, ';'));
      HANDLUNGSBEDARF_MEILENSTEIN_RID := strtoint(nextp(OneLine, ';'));

      _GRUPPE := Integer(Verfall.Objects[0]);
      if (_GRUPPE <> 0) then
        FieldByName('GRUPPE_R').AsInteger := _GRUPPE
      else
        FieldByName('GRUPPE_R').clear;
    end
    else
    begin
      FieldByName('VERFALL').clear;
      FieldByName('GRUPPE_R').clear;
    end;

    post;
  end;
  Verfall.free;

  MEILENSTEIN.close;
  MEILENSTEIN.free;
  POSTEN.close;
  POSTEN.free;
  Auftrag.close;
  Auftrag.free;
end;

function EnsureSQL(s: string): string;
begin
  result := s;
  ersetze('''', '''''', result);
end;

function TruncateLeadingZeros(s: string): string;
begin
  result := noblank(s);
  while pos('0', result) = 1 do
    Delete(result, 1, 1);
end;

procedure EnsureCache_Monteur;
begin
  if not(assigned(CacheMonteur)) then
    e_r_MonteurRIDFromKuerzel('');
end;

function e_r_MonteurRIDfromGeraeteID(str: string): Integer;
var
  n: Integer;
  Subs: TStringList;
begin
  //
  result := cRID_Null;
  EnsureCache_Monteur;
  for n := 0 to pred(CacheMonteurKuerzel.count) do
  begin
    Subs := TStringList(CacheMonteurKuerzel.Objects[n]);
    if (Subs[2] = str) then
    begin
      result := strtointdef(CacheMonteurKuerzel[n], cRID_Unset);
      break;
    end;
  end;

end;

function e_r_MonteurRIDFromKuerzel(str: string): Integer;
var
  SubItem: TStringList;
  IsFrei: boolean;
  cMonteur: TdboCursor;
begin
  if not(assigned(CacheMonteur)) then
  begin
    CacheMonteur := TStringList.create;
    CacheMonteurKuerzel := TStringList.create;
    MonteurKuerzel := TStringList.create;
    MonteurKuerzelGeraeteID := TStringList.create;
    MonteurKuerzel_freie := TStringList.create;
    MonteurJonDa_freie := TStringList.create;
    cMonteur := nCursor;
    with cMonteur do
    begin

      sql.Add('SELECT');
      sql.Add('       PERSON.RID');
      sql.Add('     , PERSON.KUERZEL');
      sql.Add('     , PERSON.MONDA');
      sql.Add('     , PERSON.A00');
      sql.Add('     , ANSCHRIFT.NAME1');
      sql.Add('     , PERSON.HANDY');
      sql.Add('     , PERSON.ANREDE');
      sql.Add('     , ANSCHRIFT.NAME2');
      sql.Add('     , ANSCHRIFT.STRASSE');
      sql.Add('     , ANSCHRIFT.ORTSTEIL');
      sql.Add('     , PERSON.ANSPRACHE');
      sql.Add('     , PERSON.PRIV_TEL');
      sql.Add('     , PERSON.PRIV_FAX');
      sql.Add('     , PERSON.EMAIL');
      sql.Add('     , PERSON.BEMERKUNG');
      sql.Add('FROM');
      sql.Add(' PERSON');
      sql.Add('left join');
      sql.Add(' ANSCHRIFT');
      sql.Add('on');
      sql.Add(' (PERSON.PRIV_ANSCHRIFT_R=ANSCHRIFT.RID)');
      sql.Add('where');
      sql.Add(' (PERSON.KUERZEL is not null) and');
      sql.Add(' (PERSON.KUERZEL<>'''')');
      sql.Add('ORDER BY');
      sql.Add(' PERSON.KUERZEL');

      ApiFirst;
      while not(eof) do
      begin
        IsFrei := FieldByName('A00').AsString <> cC_False;
        CacheMonteur.addobject(FieldByName('NAME1').AsString,
          TObject(FieldByName('RID').AsInteger));
        MonteurKuerzel.addobject(FieldByName('KUERZEL').AsString,
          TObject(FieldByName('RID').AsInteger));
        if IsFrei then
          MonteurKuerzel_freie.addobject(FieldByName('KUERZEL').AsString,
            TObject(FieldByName('RID').AsInteger));

        if (FieldByName('MONDA').AsString <> '') then
        begin
          MonteurKuerzelGeraeteID.addobject(FieldByName('KUERZEL').AsString,
            TObject(FieldByName('RID').AsInteger));
          if IsFrei then
            MonteurJonDa_freie.addobject(FieldByName('KUERZEL').AsString,
              TObject(FieldByName('RID').AsInteger));
        end;

        //
        SubItem := TStringList.create;
        SubItem.Add(FieldByName('KUERZEL').AsString);
        // [0]
        SubItem.Add(FieldByName('NAME1').AsString); // [1]
        SubItem.Add(FieldByName('MONDA').AsString); // [2]
        SubItem.Add(FieldByName('HANDY').AsString); // [3]

        CacheMonteurKuerzel.addobject(FieldByName('RID').AsString, SubItem);
        next;
      end;
    end;
    cMonteur.free;
    CacheMonteur.sort;
    CacheMonteur.sorted := true;
    CacheMonteurKuerzel.sort;
    CacheMonteurKuerzel.sorted := true;
    MonteurKuerzel.sort;
    MonteurKuerzelGeraeteID.sort;
    RemoveDuplicates(MonteurKuerzel);
    RemoveDuplicates(MonteurKuerzelGeraeteID);
    MonteurKuerzel.sorted := true;
    MonteurKuerzelGeraeteID.sorted := true;
  end;
  str := cutblank(str);
  result := MonteurKuerzel.indexof(str);
  if (result <> -1) then
    result := Integer(MonteurKuerzel.Objects[result]);
end;

function e_r_MonteurKuerzel(rid: Integer): string;
var
  _idx: Integer;
begin
  EnsureCache_Monteur;
  _idx := CacheMonteurKuerzel.indexof(inttostr(rid));
  if _idx <> -1 then
    result := TStringList(CacheMonteurKuerzel.Objects[_idx])[0]
  else
    result := inttostr(rid);
end;

function e_r_MonteurName(rid: Integer): string;
var
  _idx: Integer;
begin
  EnsureCache_Monteur;
  _idx := CacheMonteurKuerzel.indexof(inttostr(rid));
  if _idx <> -1 then
    result := TStringList(CacheMonteurKuerzel.Objects[_idx])[1]
  else
    result := inttostr(rid);
end;

function e_r_MonteurHandy(rid: Integer): string;
var
  _idx: Integer;
begin
  EnsureCache_Monteur;
  _idx := CacheMonteurKuerzel.indexof(inttostr(rid));
  if _idx <> -1 then
    result := TStringList(CacheMonteurKuerzel.Objects[_idx])[3]
  else
    result := inttostr(rid);
end;

procedure InvalidateCache_Monteur;
begin
  freeandnil(CacheMonteur);
  freeandnil(CacheMonteurKuerzel);
  freeandnil(MonteurKuerzel);
  freeandnil(MonteurKuerzelGeraeteID);
  freeandnil(MonteurKuerzel_freie);
  freeandnil(MonteurJonDa_freie);
  InvalidateCache_Baustelle;
end;

procedure e_r_MonteurUrlaub(rid: Integer; Urlaub: TSperre);
var
  MemoInfo: TStringList;
begin
  if (rid >= cRID_FirstValid) then
  begin
    MemoInfo := e_r_sqlt('select BEMERKUNG from PERSON where RID=' + inttostr(rid));
    Urlaub.ReadFromMemo(MemoInfo, sSperre_Wert_Person);
    MemoInfo.free;
  end;
end;

procedure e_r_MonteurArbeit(rid: Integer; Arbeit: TSperre);
var
  MemoInfo: TStringList;
begin
  if (rid >= cRID_FirstValid) then
  begin
    MemoInfo := e_r_sqlt('select BEMERKUNG from PERSON where RID=' + inttostr(rid));
    Arbeit.ReadFromMemo(MemoInfo, sSperre_Wert_Arbeit);
    MemoInfo.free;
  end;
end;

procedure e_r_MonteurZuordnung(MONTEUR_R: Integer; Arbeit: TSperre);
var
  MemoInfo: TStringList;
  Umstand: TStringList;
begin
  if (MONTEUR_R >= cRID_FirstValid) then
  begin
    // imp pend: "Umstand" wird pro Monteur aufgerufen -> dies noch cachen!
    Umstand := e_r_sqlslo('select NUMMERN_PREFIX, RID from BAUSTELLE');
    Umstand.Add('ColorAusUmstand=JA');
    MemoInfo := e_r_sqlt('select BEMERKUNG from PERSON where RID=' + inttostr(MONTEUR_R));
    Arbeit.ReadFromMemo(MemoInfo, sSperre_Wert_Zuordnung, Umstand);
    MemoInfo.free;
    Umstand.free;
  end;
end;

function e_r_MonteurGeraeteID(rid: Integer): string;
var
  _idx: Integer;
begin
  EnsureCache_Monteur;
  _idx := CacheMonteurKuerzel.indexof(inttostr(rid));
  if (_idx <> -1) then
    result := TStringList(CacheMonteurKuerzel.Objects[_idx])[2]
  else
    result := inttostr(rid);
end;

function e_r_VorlageMail(VorlageName: string): Integer;
begin
  result := e_r_sql('select RID from EMAIL where ' + '(VORLAGE_R IS NULL) and ' + '(UID=''' +
    VorlageName + ''')');
end;

function e_r_MonteureCache(Alle: boolean = true): TStringList;
begin
  EnsureCache_Monteur;
  if Alle then
    result := MonteurKuerzel
  else
    result := MonteurKuerzel_freie;
end;

function e_r_MonteureJonDa(Alle: boolean = true): TStringList;
begin
  EnsureCache_Monteur;
  if Alle then
    result := MonteurKuerzelGeraeteID
  else
    result := MonteurJonDa_freie;
end;

const
  _ObtainKuerzelFromRID_LastRID: Integer = -1;
  _ObtainKuerzelFromRID_LastResult: string = '';

function e_r_BaustelleKuerzel(rid: Integer): string;
var
  FoundIndex: Integer;
begin
  if (rid = _ObtainKuerzelFromRID_LastRID) then
  begin
    result := _ObtainKuerzelFromRID_LastResult;
  end
  else
  begin
    EnsureCache_Baustelle;
    FoundIndex := CacheBaustelle.indexof(inttostr(rid));
    if (FoundIndex <> -1) then
    begin
      result := TStringList(CacheBaustelle.Objects[FoundIndex])[0];
      _ObtainKuerzelFromRID_LastRID := rid;
      _ObtainKuerzelFromRID_LastResult := result;
    end
    else
      result := inttostr(rid);
  end;
end;

const
  _ObtainKostenstelleFromRID_LastRID: Integer = -1;
  _ObtainKostenstelleFromRID_LastResult: string = '';

function e_r_BaustelleKostenstelle(BAUSTELLE_R: Integer): string;
var
  FoundIndex: Integer;
begin
  if (BAUSTELLE_R = _ObtainKostenstelleFromRID_LastRID) then
  begin
    result := _ObtainKostenstelleFromRID_LastResult;
  end
  else
  begin
    EnsureCache_Baustelle;
    FoundIndex := CacheBaustelle.indexof(inttostr(BAUSTELLE_R));
    if (FoundIndex <> -1) then
    begin
      result := TStringList(CacheBaustelle.Objects[FoundIndex])[9];
      _ObtainKostenstelleFromRID_LastRID := BAUSTELLE_R;
      _ObtainKostenstelleFromRID_LastResult := result;
    end
    else
      result := inttostr(BAUSTELLE_R);
  end;
end;

const
  _ObtainBundeslandFromRID_LastRID: Integer = -1;
  _ObtainBundeslandFromRID_LastResult: Integer = 0;

function e_r_BaustelleBundesland(BAUSTELLE_R: Integer): Integer;
var
  FoundIndex: Integer;
begin
  if (BAUSTELLE_R = _ObtainBundeslandFromRID_LastRID) then
  begin
    result := _ObtainBundeslandFromRID_LastResult;
  end
  else
  begin
    EnsureCache_Baustelle;
    FoundIndex := CacheBaustelle.indexof(inttostr(BAUSTELLE_R));
    if (FoundIndex <> -1) then
    begin
      result := strtointdef(TStringList(CacheBaustelle.Objects[FoundIndex])[10], 0);
      _ObtainBundeslandFromRID_LastRID := BAUSTELLE_R;
      _ObtainBundeslandFromRID_LastResult := result;
    end
    else
      result := cRID_Null;
  end;
end;

function e_r_BaustelleName(rid: Integer): string;
var
  FoundIndex: Integer;
begin
  EnsureCache_Baustelle;
  FoundIndex := CacheBaustelle.indexof(inttostr(rid));
  if (FoundIndex <> -1) then
    result := TStringList(CacheBaustelle.Objects[FoundIndex])[1]
  else
    result := inttostr(rid);
end;

function e_r_BaustelleCSV_QUELLE(rid: Integer): string;
var
  FoundIndex: Integer;
begin
  EnsureCache_Baustelle;
  FoundIndex := CacheBaustelle.indexof(inttostr(rid));
  if (FoundIndex <> -1) then
    result := TStringList(CacheBaustelle.Objects[FoundIndex])[4]
  else
    result := inttostr(rid);
end;

function e_r_BaustelleNameFromKuerzel(KUERZEL: string): string;
var
  n: Integer;
begin
  EnsureCache_Baustelle;
  for n := 0 to pred(CacheBaustelle.count) do
    if KUERZEL = TStringList(CacheBaustelle.Objects[n])[0] then
    begin
      result := TStringList(CacheBaustelle.Objects[n])[1];
      exit;
    end;
  result := '?';
end;

function e_r_BaustelleRIDFromKuerzel(KUERZEL: string): Integer;
var
  n: Integer;
begin
  result := cRID_Null;
  KUERZEL := AnsiUpperCase(cutblank(KUERZEL));
  if (KUERZEL <> '') then
  begin
    EnsureCache_Baustelle;
    for n := 0 to pred(CacheBaustelle.count) do
      if KUERZEL = AnsiUpperCase(TStringList(CacheBaustelle.Objects[n])[0]) then
      begin
        result := strtoint(CacheBaustelle[n]);
        break;
      end;
  end;
end;

function e_r_BearbeiterEinstellungen(BEARBEITER_R: Integer): TStringList;
begin
  result := e_r_sqlt('select STATUS from BEARBEITER where RID=' + inttostr(BEARBEITER_R));
end;

procedure InvalidateCache_Baustelle;
var
  n: Integer;
begin
  // Objecte freigeben
  if assigned(CacheBaustelle) then
  begin
    for n := 0 to pred(CacheBaustelle.count) do
      CacheBaustelle.Objects[n].free;
    freeandnil(CacheBaustelle);
    freeandnil(CacheBaustelleOrtsteile);
    freeandnil(CacheBaustelleMonteure);
    CacheBaustelleOrtsteile_BAUSTELLE_R := -1;
  end;

  if assigned(cFeiertage) then
    freeandnil(cFeiertage);

  // cache dirty flags setzen
  CacheBaustelleMonteureLastRequestedRID := -1;
  CacheBaustelleOrtsteile_BAUSTELLE_R := -1;
  CacheBaustelleAufwand := -1;
  CacheBaustelleArbeitsZeitV_RID := -1;
  CacheBaustelleArbeitsZeitN_RID := -1;

  _ObtainKuerzelFromRID_LastRID := -1;
  _ObtainKostenstelleFromRID_LastRID := -1;
  _ObtainBundeslandFromRID_LastRID := -1;

end;

procedure EnsureCache_Baustelle;
var
  _SubItem: TStringList;
  _Ortsteile: TStringList;
  cBAUSTELLE: TdboCursor;
begin
  //
  // Idee, Haltbarkeitsdatum des Cache einführen, danach
  // !muss! neu geladen werden -> AutoInvalidate
  //
  if not(assigned(CacheBaustelle)) then
  begin
    // CACHE
    CacheBaustelle := TStringList.create;
    CacheBaustelleOrtsteile := TSearchStringList.create;

    _Ortsteile := TStringList.create;
    cBAUSTELLE := nCursor;
    with cBAUSTELLE do
    begin
      sql.Add('select * from BAUSTELLE');
      ApiFirst;
      while not(eof) do
      begin
        _SubItem := TStringList.create;
        { [0] } _SubItem.Add(FieldByName('NUMMERN_PREFIX').AsString);
        { [1] } _SubItem.Add(FieldByName('NAME').AsString);
        { [2] } _SubItem.Add(inttostr(FieldByName('LAST_V').AsInteger));
        { [3] } _SubItem.Add(inttostr(FieldByName('LAST_N').AsInteger));
        { [4] } _SubItem.Add(FieldByName('CSV_QUELLE').AsString);
        if (FieldByName('ORTE_AKTIV').AsString = 'Y') then
        begin
          e_r_sqlt(FieldByName('ORTE'), _Ortsteile);
          { [5] } _SubItem.Add(';' + HugeSingleLine(_Ortsteile, ';'));
        end
        else
        begin
          { [5] } _SubItem.Add('');
        end;
        { [6] } _SubItem.Add(FieldByName('PROTOKOLLEXPORT').AsString);
        { [7] } _SubItem.Add(FieldByName('REGEL_ARBEITSZEIT_V').AsString);
        { [8] } _SubItem.Add(FieldByName('REGEL_ARBEITSZEIT_N').AsString);

        { [9] } _SubItem.Add(FieldByName('KOSTENSTELLE').AsString);
        if (_SubItem[9] = '') then
          _SubItem[9] := _SubItem[0];

        { [10] } _SubItem.Add(FieldByName('BUNDESLAND_IDX').AsString);

        CacheBaustelle.addobject(inttostr(FieldByName('RID').AsInteger), _SubItem);
        Apinext;
      end;
      CacheBaustelle.sort;
      CacheBaustelle.sorted := true;
      _Ortsteile.free;
    end;
    cBAUSTELLE.free;
  end;
end;

function e_r_Monteure(BAUSTELLE_R: Integer): TgpIntegerList;
var
  INFO: TStringList;
  MonteurSubs: string;
  n: Integer;
  MONTEUR_R: Integer;
begin
  result := TgpIntegerList.create;
  INFO := e_r_sqlt('select INFO from BAUSTELLE where RID=' + inttostr(BAUSTELLE_R));
  MonteurSubs := INFO.values['MONTEURE'];
  INFO.free;

  // Text hinter den Zahlen wegschneiden
  n := pos('[', MonteurSubs);
  if n > 0 then
    MonteurSubs := cutblank(copy(MonteurSubs, 1, pred(n)));

  // Monteure holen
  while (MonteurSubs <> '') do
  begin
    MONTEUR_R := strtointdef(nextp(MonteurSubs, ','), cRID_Null);
    if (MONTEUR_R >= cRID_FirstValid) then
      result.Add(MONTEUR_R);
  end;

end;

function e_r_BaustelleMonteure(rid: Integer): TStringList;
var
  n: Integer;
  MemoField: TStringList;
  MonteurSubs: string;
  MONTEUR_RID: Integer;
  MonteurPositive: TStringList;
  AlleMonteure: TStringList;
  cBAUSTELLE: TdboCursor;
begin
  if (rid <> CacheBaustelleMonteureLastRequestedRID) then
  begin
    freeandnil(CacheBaustelleMonteure);
    cBAUSTELLE := nCursor;
    with cBAUSTELLE do
    begin
      sql.Add('select INFO from BAUSTELLE where RID=' + inttostr(rid));
      ApiFirst;

      // Monteure holen (RID)
      MemoField := TStringList.create;
      e_r_sqlt(FieldByName('INFO'), MemoField);
      MonteurSubs := MemoField.values['MONTEURE'];
      // Text hinter den Zahlen wegschneiden
      n := pos('[', MonteurSubs);
      if n > 0 then
        MonteurSubs := cutblank(copy(MonteurSubs, 1, pred(n)));
      MemoField.free;

      // Monteure holen (Text)
      MonteurPositive := TStringList.create;
      while (MonteurSubs <> '') do
      begin
        MONTEUR_RID := strtointdef(nextp(MonteurSubs, ','), cRID_Null);
        if (MONTEUR_RID >= cRID_FirstValid) then
          MonteurPositive.Add(e_r_MonteurKuerzel(MONTEUR_RID));
      end;

      CacheBaustelleMonteure := TStringList.create;
      CacheBaustelleMonteureLastRequestedRID := rid;

      // erst die beliebten
      AlleMonteure := e_r_MonteureCache(true);
      for n := 0 to pred(AlleMonteure.count) do
        if (MonteurPositive.indexof(AlleMonteure[n]) <> -1) then
          CacheBaustelleMonteure.addobject(AlleMonteure[n], AlleMonteure.Objects[n]);
      CacheBaustelleMonteure.addobject(cMonteurTrenner, nil);

      // nun die freien
      AlleMonteure := e_r_MonteureCache(false);
      for n := 0 to pred(AlleMonteure.count) do
        if (MonteurPositive.indexof(AlleMonteure[n]) = -1) then
          CacheBaustelleMonteure.addobject(AlleMonteure[n], AlleMonteure.Objects[n]);
      MonteurPositive.free;

    end;
    cBAUSTELLE.free;
  end;
  result := CacheBaustelleMonteure;
end;

function e_r_Baustellen: TStringList;
var
  n: Integer;
begin
  result := TStringList.create;
  EnsureCache_Baustelle;
  for n := 0 to pred(CacheBaustelle.count) do
    result.addobject(TStringList(CacheBaustelle.Objects[n])[0],
      TObject(strtoint(CacheBaustelle[n])));
  result.sort;
end;

function e_r_BaustellenLang: TStringList;
var
  n: Integer;
begin
  result := TStringList.create;
  EnsureCache_Baustelle;
  for n := 0 to pred(CacheBaustelle.count) do
    result.addobject(TStringList(CacheBaustelle.Objects[n])[1],
      TObject(strtoint(CacheBaustelle[n])));
  result.sort;
end;

function e_r_BaustelleProtokollName(AUFTRAG_R: Integer; BAUSTELLE_R: Integer = cRID_Null): string;
var
  Baustelle, Art, ProtokollName: string;

  function check(s: string): boolean;
  begin
    //
    ProtokollName := s;

    //
    result := FileExists(ProtokollePath + s + cProtExtension);
  end;

begin
  if (BAUSTELLE_R < cRID_FirstValid) then
    BAUSTELLE_R := e_r_sql('select BAUSTELLE_R from AUFTRAG where RID=' + inttostr(AUFTRAG_R));

  Baustelle := e_r_BaustelleKuerzel(BAUSTELLE_R);
  Art := e_r_sqls('select ART from AUFTRAG where RID=' + inttostr(AUFTRAG_R));

  repeat
    if check(Baustelle + Art) then
      break;
    if check(Baustelle) then
      break;
    if check(cProtPrefix + Art) then
      break;
    if check(cProtPrefix) then
      break;
    ProtokollName := '';

  until true;
  result := ProtokollName;

end;

function e_r_BaustelleAddSperre(BAUSTELLE_R: Integer; Umstand: TStrings; Sperre: TSperre): Integer;
var
  MemoInfo: TStringList;
  cBAUSTELLE: TdboCursor;
begin
  result := cRID_Null;
  cBAUSTELLE := nCursor;
  with cBAUSTELLE do
  begin
    sql.Add('select VON,BIS,INFO,BUNDESLAND_IDX from BAUSTELLE where RID=' + inttostr(BAUSTELLE_R));
    ApiFirst;
    if not(eof) then
    begin
      // Bundesland für weitere Prüfungen zurückgeben
      result := FieldByName('BUNDESLAND_IDX').AsInteger;

      // ganz normale Ausführung laden
      if not(FieldByName('VON').IsNull) and not(FieldByName('BIS').IsNull) then
        Sperre.Add(FieldByName('VON').AsDateTime, FieldByName('BIS').AsDateTime, false,
          cSperreAusfuehren, cPrio_BaustellenSperre);

      // einzelne Sperren dazwischen
      MemoInfo := TStringList.create;
      e_r_sqlt(FieldByName('INFO'), MemoInfo);
      Sperre.ReadFromMemo(MemoInfo, sSperre_Wert_Baustelle, Umstand);

      // Feiertage
      Feiertage.AddToSperre(cSperreFeiertag, cPrio_FeiertagSperre, Sperre);

      MemoInfo.free;
    end;
  end;
  cBAUSTELLE.free;
end;

function e_r_TerminAnzahl_V(rid: Integer): Integer;
var
  FoundIndex: Integer;
begin
  EnsureCache_Baustelle;
  FoundIndex := CacheBaustelle.indexof(inttostr(rid));
  if (FoundIndex <> -1) then
    result := strtoint(TStringList(CacheBaustelle.Objects[FoundIndex])[2])
  else
    result := -1;
end;

function e_r_TerminAnzahl_N(rid: Integer): Integer;
var
  FoundIndex: Integer;
begin
  EnsureCache_Baustelle;
  FoundIndex := CacheBaustelle.indexof(inttostr(rid));
  if (FoundIndex <> -1) then
    result := strtoint(TStringList(CacheBaustelle.Objects[FoundIndex])[3])
  else
    result := -1;
end;

var
  _c2_Ortsteil: string;
  _c2_BAUSTELLE_R: Integer;
  _c2_Code: string;

function e_r_OrtsteilCode(BAUSTELLE_R: Integer; Ort: string): string;
var
  FoundIndex: Integer;
  AlleOrte: string;
begin
  if (Ort = '') then
  begin
    result := '';
  end
  else
  begin
    EnsureCache_Baustelle;

    // prepare cache
    if (BAUSTELLE_R <> CacheBaustelleOrtsteile_BAUSTELLE_R) then
    begin

      CacheBaustelleOrtsteile.clear;
      FoundIndex := CacheBaustelle.indexof(inttostr(BAUSTELLE_R));
      if (FoundIndex <> -1) then
      begin
        AlleOrte := TStringList(CacheBaustelle.Objects[FoundIndex])[5];
        while (AlleOrte <> '') do
          CacheBaustelleOrtsteile.Add(nextp(AlleOrte, ';'));
      end
      else
      begin
        // Fehler, unbekannter BAUSTELLE_R
      end;

    end;

    repeat

      // Turbo Cache
      if (BAUSTELLE_R = _c2_BAUSTELLE_R) and (Ort = _c2_Ortsteil) then
      begin
        result := _c2_Code;
        break;
      end;

      // find result
      if (CacheBaustelleOrtsteile.count = 0) then
      begin
        // es wird gar keine Ortsteil-Logik benutzt!
        // oder die Orteile sind leer!
        _c2_Ortsteil := Ort;
        _c2_BAUSTELLE_R := BAUSTELLE_R;
        _c2_Code := '';
        result := _c2_Code;
      end
      else
      begin
        FoundIndex := CacheBaustelleOrtsteile.FindInc(Ort + '=');
        if (FoundIndex <> -1) then
        begin
          //
          _c2_Ortsteil := Ort;
          _c2_BAUSTELLE_R := BAUSTELLE_R;
          _c2_Code := copy(nextp(CacheBaustelleOrtsteile[FoundIndex], '=', 1) + '--', 1,
            cSTRASSE_OrtsteilcodeLength);
          result := _c2_Code;
        end
        else
        begin
          // Neues Ortsteil?
          result := fill('?', cSTRASSE_OrtsteilcodeLength);
        end;
      end;
    until true;
  end;
end;

procedure e_r_ProtokollExport(BAUSTELLE_R: Integer; FelderListe: TStringList);
var
  n, FoundIndex: Integer;
  cBAUSTELLE: TdboCursor;
begin
  //
  EnsureCache_Baustelle;

  // prepare cache
  FoundIndex := CacheBaustelle.indexof(inttostr(BAUSTELLE_R));
  if (FoundIndex <> -1) then
  begin
    if TStringList(CacheBaustelle.Objects[FoundIndex])[6] = 'Y' then
    begin
      cBAUSTELLE := nCursor;
      with cBAUSTELLE do
      begin
        sql.Add('select PROTOKOLLFELDER from BAUSTELLE where RID=' + inttostr(BAUSTELLE_R));
        ApiFirst;
        e_r_sqlt(FieldByName('PROTOKOLLFELDER'), FelderListe);
      end;
      cBAUSTELLE.free;

      for n := pred(FelderListe.count) downto 0 do
      begin
        FelderListe[n] := nextp(FelderListe[n], ' ', 0);
        if (FelderListe[n] = '') then
          FelderListe.Delete(n);
      end;
    end;
  end;
end;

function e_r_PhasenStatus(AUFTRAG_R: Integer): string;
var
  cAUFTRAG: TdboCursor;
  STATUS: Integer;
begin
  cAUFTRAG := nCursor;
  with cAUFTRAG do
  begin
    sql.Add('select');
    sql.Add(' STATUS,');
    sql.Add(' MONDA_ABRUF,');
    sql.Add(' WIEDERVORLAGE,');
    sql.Add(' WORDEXPORT,');
    sql.Add(' MONTEUREXPORT,');
    sql.Add(' EXPORT_TAN');
    sql.Add('from');
    sql.Add(' AUFTRAG');
    sql.Add('where');
    sql.Add(' RID=' + inttostr(AUFTRAG_R));
    ApiFirst;
    STATUS := FieldByName('STATUS').AsInteger;
    repeat
      // ab hier werden die virtuellen Stati berechnet

      // "ungemeldet"
      if (STATUS in [4, 7, 9]) then
        if FieldByName('EXPORT_TAN').IsNull then
        begin
          STATUS := ord(ctsLast) + 4;
          break;
        end;

      // "gemeldet"
      if (STATUS <> ord(ctsHistorisch)) then
        if not(FieldByName('EXPORT_TAN').IsNull) then
        begin
          STATUS := ord(ctsLast) + 3;
          break;
        end;

    until true;
  end;
  result := cPhasenStatusText[STATUS];
  cAUFTRAG.free;
end;

procedure e_r_InternExport(BAUSTELLE_R: Integer; FelderListe: TStringList);
var
  n, FoundIndex: Integer;
  cBAUSTELLE: TdboCursor;
begin
  //
  EnsureCache_Baustelle;

  // prepare cache
  FoundIndex := CacheBaustelle.indexof(inttostr(BAUSTELLE_R));
  if (FoundIndex <> -1) then
  begin
    if TStringList(CacheBaustelle.Objects[FoundIndex])[6] = 'Y' then
    begin
      cBAUSTELLE := nCursor;
      with cBAUSTELLE do
      begin
        sql.Add('select INTERNFELDER from BAUSTELLE where RID=' + inttostr(BAUSTELLE_R));
        ApiFirst;
        e_r_sqlt(FieldByName('INTERNFELDER'), FelderListe);
      end;
      cBAUSTELLE.free;
      for n := pred(FelderListe.count) downto 0 do
      begin
        FelderListe[n] := nextp(FelderListe[n], ' ', 0);
        if (FelderListe[n] = '') then
          FelderListe.Delete(n);
      end;
    end;
  end;

end;

function e_r_EinzelAufwand(rid: Integer): TAnfixTime;
var
  Gesamt: double;
begin
  //
  EnsureCache_Baustelle;
  if (rid <> CacheBaustelleAufwand) then
  begin
    CacheBaustelleAufwand := rid;
    Gesamt := e_r_TerminAnzahl_VN(rid);
    if (Gesamt > 0) then
      CacheBaustelleAufwandValue := round(iTagesArbeitszeit / Gesamt)
    else
      CacheBaustelleAufwandValue := round(iTagesArbeitszeit / 10.0);
  end;
  result := CacheBaustelleAufwandValue;
end;

function e_r_TerminAnzahl_VN(rid: Integer): Integer;
begin
  result := e_r_TerminAnzahl_V(rid) + e_r_TerminAnzahl_N(rid);
end;

function e_r_Arbeitszeit_V(rid: Integer): TAnfixTime;
var
  FoundIndex: Integer;
begin
  if (rid <> CacheBaustelleArbeitsZeitV_RID) then
  begin
    EnsureCache_Baustelle;
    FoundIndex := CacheBaustelle.indexof(inttostr(rid));
    if (FoundIndex <> -1) then
      CacheBaustelleArbeitsZeitV_Value :=
        strtointdef(TStringList(CacheBaustelle.Objects[FoundIndex])[7], 0)
    else
      CacheBaustelleArbeitsZeitV_Value := 0;
  end;
  result := CacheBaustelleArbeitsZeitV_Value;
end;

var
  e_r_AuftragItems_cAUFTRAG: TdboCursor = nil;
  e_r_AuftragItems_LastRequestedRID: Integer = cRID_Unset;
  e_r_AuftragItems_LastRequestedSub: TStringList = nil;

function e_r_AuftragItems(AUFTRAG_R: Integer): TStringList;
var
  n, m: Integer;
  _Datum: string;
  _Monteur: string;
  _Ausfuehren: TANFiXDate;
  MoreInfo: TStringList;
  TmpStr: string;
  BAUSTELLE_R: Integer;

  function vStatus(_STATUS: Integer): string;
  begin
    with e_r_AuftragItems_cAUFTRAG do
    begin
      repeat

        if (_STATUS <> ord(ctsHistorisch)) then
          if not(FieldByName('MONDA_ABRUF').IsNull) then
          begin
            _STATUS := ord(ctsLast) + 8;
            break;
          end;

        if (_STATUS <> ord(ctsHistorisch)) then
          if not(FieldByName('WIEDERVORLAGE').IsNull) then
          begin
            _STATUS := ord(ctsLast) + 9;
            break;
          end;

        if (_STATUS = ord(ctsAngeschrieben)) or (_STATUS = ord(ctsMonteurInformiert)) then
          if not(FieldByName('WORDEXPORT').IsNull) then
            if not(FieldByName('MONTEUREXPORT').IsNull) then
              _STATUS := ord(ctsLast);

        if (_STATUS = ord(ctsHistorisch)) then
          if not(FieldByName('MONTEUREXPORT').IsNull) then
            _STATUS := ord(ctsLast) + 1;

        // schon gemeldet:
        if (_STATUS = ord(ctsErfolg)) then
          if not(FieldByName('EXPORT_TAN').IsNull) then
            if FieldByName('EXPORT_TAN').AsInteger > 0 then
              _STATUS := ord(ctsLast) + 2
            else
              _STATUS := ord(ctsLast) + 5;

        if (_STATUS = ord(ctsUnmoeglich)) then
          if not(FieldByName('EXPORT_TAN').IsNull) then
            if FieldByName('EXPORT_TAN').AsInteger > 0 then
              _STATUS := ord(ctsLast) + 3
            else
              _STATUS := ord(ctsLast) + 6;

        if (_STATUS = ord(ctsVorgezogen)) then
          if not(FieldByName('EXPORT_TAN').IsNull) then
            if FieldByName('EXPORT_TAN').AsInteger > 0 then
              _STATUS := ord(ctsLast) + 4
            else
              _STATUS := ord(ctsLast) + 7;

      until true;

      result := inttostr(_STATUS);
    end;
  end;

begin

  // Element im Cache?
  if (e_r_AuftragItems_LastRequestedRID = AUFTRAG_R) then
  begin
    result := e_r_AuftragItems_LastRequestedSub;
  end
  else
  begin

    // Clear "old" Cache
    if assigned(e_r_AuftragItems_LastRequestedSub) then
      freeandnil(e_r_AuftragItems_LastRequestedSub);

    result := TStringList.create;
    MoreInfo := TStringList.create;

    e_r_AuftragItems_LastRequestedSub := result;
    e_r_AuftragItems_LastRequestedRID := AUFTRAG_R;

    if not(assigned(e_r_AuftragItems_cAUFTRAG)) then
    begin
      e_r_AuftragItems_cAUFTRAG := nCursor;
      with e_r_AuftragItems_cAUFTRAG do
      begin
        sql.Add('select * from AUFTRAG where RID=:CROSSREF');
      end;
    end;

    with e_r_AuftragItems_cAUFTRAG do
    begin
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      ApiFirst;

      if eof then
      begin
        for n := 0 to 100 do
          result.Add('');
      end
      else
      begin

        _Ausfuehren := DateTime2Long(FieldByName('AUSFUEHREN').AsDateTime);
        BAUSTELLE_R := FieldByName('BAUSTELLE_R').AsInteger;
        _Datum := long2date8(_Ausfuehren);

        { [0] }
        result.Add(_Datum);

        { [1] }
        result.Add(FieldByName('KUNDE_NUMMER').AsString);

        { [2] }
        if not(FieldByName('MONTEUR1_R').IsNull) then
        begin
          _Monteur := e_r_MonteurKuerzel(FieldByName('MONTEUR1_R').AsInteger);
          if not(FieldByName('MONTEUR2_R').IsNull) then
            _Monteur := _Monteur + c2Monteure + e_r_MonteurKuerzel
              (FieldByName('MONTEUR2_R').AsInteger);
          result.Add(_Monteur);
        end
        else
        begin
          result.Add('');
        end;

        { [3] }
        e_r_sqlt(FieldByName('MONTEUR_INFO'), MoreInfo);
        if (MoreInfo.count > 0) then
          result.Add(HugeSingleLine(MoreInfo, cOLAPcsvLineBreak))
        else
          result.Add('-');

        { [4] }
        result.Add(FieldByName('ART').AsString);
        { [5] }
        result.Add(FieldByName('ZAEHLER_NUMMER').AsString);
        { [6] }
        result.Add(noDoubleBlank(FieldByName('BRIEF_NAME1').AsString));
        { [7] }
        result.Add(StrassePostalisch(FieldByName('BRIEF_STRASSE').AsString));
        { [8] }
        result.Add(OrtPostalisch(FieldByName('KUNDE_ORT').AsString));
        { [9] }
        if FieldByName('KUNDE_NAME1').IsNull then
          result.Add(result[6])
        else
          result.Add(noDoubleBlank(FieldByName('KUNDE_NAME1').AsString));
        { [10] }
        result.Add(StrassePostalisch(FieldByName('KUNDE_STRASSE').AsString));
        { [11] }
        result.Add(FieldByName('BRIEF_ORT').AsString);
        { [12] }
        result.Add(FieldByName('VORMITTAGS').AsString);
        { [13] }
        result.Add(long2date8(DateTime2Long(FieldByName('GEAENDERT').AsDateTime)));
        { [14] }
        result.Add(inttostrN(FieldByName('NUMMER').AsInteger, cAuftragsNummer_Length));
        { [15] Status1 }
        result.Add(vStatus(FieldByName('STATUS').AsInteger));
        { [16] Status2 }
        result.Add(inttostr(FieldByName('FITNESS').AsInteger));
        { [17] }
        if DateOK(_Ausfuehren) then
          result.Add(cTageNamenKurz[WeekDay(_Ausfuehren)])
        else
          result.Add('');
        { [18] }
        TmpStr := noDoubleBlank(FieldByName('KUNDE_NAME2').AsString);
        if (TmpStr = result[9]) then
          result.Add('')
        else
          result.Add(TmpStr);
        { [19] }
        TmpStr := noDoubleBlank(FieldByName('BRIEF_NAME2').AsString);
        if (TmpStr = result[6]) then
          result.Add('')
        else
          result.Add(TmpStr);
        { [20] }
        if DateOK(_Ausfuehren) then
          result.Add(cTageNamenLang[WeekDay(_Ausfuehren)])
        else
          result.Add('');
        { [21] }
        if not(FieldByName('MONTEUR1_R').IsNull) then
        begin
          _Monteur := e_r_MonteurName(FieldByName('MONTEUR1_R').AsInteger);
          if not(FieldByName('MONTEUR2_R').IsNull) then
            _Monteur := _Monteur + ' oder ' + e_r_MonteurName(FieldByName('MONTEUR2_R').AsInteger);
          result.Add(_Monteur);
        end
        else
        begin
          result.Add('');
        end;
        { [22] }
        repeat
          if result[12] = cVormittagsChar then
          begin
            result.Add('vormittags');
            break;
          end;
          if result[12] = cNachmittagsChar then
          begin
            result.Add('nachmittags');
            break;
          end;
          result.Add('?');
          break;
        until true;
        { [23] }
        result.Add(long2datetext(_Ausfuehren));
        { [24] }
        result.Add(e_r_BaustelleKuerzel(BAUSTELLE_R));
        { [25] }
        result.Add(inttostr(FieldByName('BEARBEITER_R').AsInteger) + '/' +
          inttostr(FieldByName('TERMINIERT_R').AsInteger));
        { [26] }
        result.Add(long2date8(DateTime2Long(FieldByName('SPERRE_VON').AsDateTime)) + '-' +
          long2date8(DateTime2Long(FieldByName('SPERRE_BIS').AsDateTime)));
        { [27] }
        result.Add(FieldByName('PLANQUADRAT').AsString);

        { [28]..[37] }
        e_r_sqlt(FieldByName('ZAEHLER_INFO'), MoreInfo);
        for n := 0 to pred(MoreInfo.count) do
          if pos('v1=', MoreInfo[n]) > 0 then
          begin
            for m := pred(MoreInfo.count) downto n do
              MoreInfo.Delete(m);
            break;
          end;
        for n := 0 to 9 do
          if (MoreInfo.count > n) then
            result.Add(MoreInfo[n])
          else
            result.Add('');

        { [38] }
        result.Add(FieldByName('KUNDE_ORTSTEIL').AsString);
        { [39] }
        result.Add(FieldByName('ZAEHLER_NR_KORREKTUR').AsString);
        { [40] }
        result.Add(FieldByName('ZAEHLER_NR_NEU').AsString);
        { [41] }
        TmpStr := FieldByName('ZAEHLER_STAND_ALT').AsString;
        result.Add(KommaCheck(TmpStr));
        { [42] }
        TmpStr := FieldByName('ZAEHLER_STAND_NEU').AsString;
        result.Add(KommaCheck(TmpStr));
        { [43] }
        e_r_sqlt(FieldByName('PROTOKOLL'), MoreInfo);
        result.Add(HugeSingleLine(MoreInfo, cProtokollTrenner));
        { [44] }// Datum Zählerwechsel
        result.Add(Long2date(DateTime2Long(FieldByName('ZAEHLER_WECHSEL').AsDateTime)));
        { [45] }// Uhr Zählerwechsel
        result.Add(secondstostr(datetime2seconds(FieldByName('ZAEHLER_WECHSEL').AsDateTime)));
        { [46] }
        result.Add(FieldByName('REGLER_NR').AsString);
        { [47] }
        result.Add(FieldByName('REGLER_NR_KORREKTUR').AsString);
        { [48] }
        result.Add(FieldByName('REGLER_NR_NEU').AsString);
        { [49] }
        result.Add(ObtainStrassenName(result[10]));
        { [50] }
        result.Add(ObtainStrassenHausNummerOhneZusatz(result[10]));
        { [51] }
        result.Add(ObtainStrassenHausNummerZusatz(result[10]));
        { [52] }
        result.Add(FieldByName('WORDEMPFAENGER').AsString);
        { [53] }
        result.Add(inttostr(AUFTRAG_R));
        { [54] }
        result.Add(FieldByName('WORDANZ').AsString);
        { [55] }
        result.Add(FieldByName('KUNDE_ORTSTEIL_CODE').AsString);
        { [56] }
        result.Add(long2date5(DateTime2Long(FieldByName('SPERRE_VON').AsDateTime)) + '-' +
          long2date5(DateTime2Long(FieldByName('SPERRE_BIS').AsDateTime)));
        { [57] }
        if not(FieldByName('MONTEUR1_R').IsNull) then
        begin
          _Monteur := e_r_MonteurHandy(FieldByName('MONTEUR1_R').AsInteger);
          if not(FieldByName('MONTEUR2_R').IsNull) then
            _Monteur := _Monteur + ' oder ' + e_r_MonteurHandy(FieldByName('MONTEUR2_R').AsInteger);
          result.Add(_Monteur);
        end
        else
        begin
          result.Add('');
        end;
        { [58..67] }
        e_r_sqlt(FieldByName('INTERN_INFO'), MoreInfo);
        for n := 0 to 9 do
          if (MoreInfo.count > n) then
            result.Add(MoreInfo[n])
          else
            result.Add('');
        { [68] Status3 }
        result.Add(vStatus(FieldByName('STATUS_BISHER').AsInteger));
        { [69] }
        result.Add(long2date5(DateTime2Long(FieldByName('ZEITRAUM_VON').AsDateTime)) + '..' +
          long2date5(DateTime2Long(FieldByName('ZEITRAUM_BIS').AsDateTime)));
      end;
    end;
    MoreInfo.free;
  end;

end;

function e_r_AuftragLine(AUFTRAG_R: Integer): string;

  function NoSemi(n: Integer; const s: string): string;
  var
    k: Integer;
  begin
    result := s;
    if (n >= 28) and (n <= 36) then
    begin
      k := pos('_', result);
      if (k > 0) then
        result := copy(result, succ(k), MaxInt);
    end;
    ersetze(';', '*', result);
    ersetze('"', '''''', result);
  end;

var
  SubItems: TStringList;
  n: Integer;
begin
  SubItems := e_r_AuftragItems(AUFTRAG_R);
  result := '';
  for n := 0 to pred(SubItems.count) do
    result := result + NoSemi(n, SubItems[n]) + ';';
end;

function e_c_AuftragHeader: TStringList;
var
  s: string;
begin
  result := TStringList.create;
  s := cWordHeaderLine;
  while (s <> '') do
    result.Add(nextp(s, ';'));
end;


//
// gemeinsamer Cache für "e_r_Arbeit", "e_r_Baustelle" "e_r_Einsatz"
//

var
  //

  e_r_Arbeit_MonteurSperre: TGpIntegerObjectList = nil;
  // Person.Sperre / Auszeit
  e_r_Arbeit_MonteurArbeit: TGpIntegerObjectList;
  // Person.Arbeit + Person.Mehrarbeit
  e_r_Arbeit_MonteurZuordnung: TGpIntegerObjectList;
  // Person.Zuordnung= bei den Monteuren

  e_r_Arbeit_Umsetzer: TFieldMapping; // Farben und Texte Umsetzer
  e_r_Arbeit_Feiertag: TSperre; // die gesamte Feiertagsdatenbank

  // [Kontext=Monteur] Baustellen-Laufzeit als "Sperre"
  e_r_Baustelle_VonBis: TSperre; // Baustellen-Laufzeiten

  // Liste der vorrangigen Baustellen
  e_r_Baustelle_Vorrang: TgpIntegerList;

  // echte Arbeit
  e_r_Baustelle_Einsatz: TSperre;

  // Arbeitszeitmodell
  e_r_Baustelle_mitModell: TgpIntegerList; // Prüfung, ob ein Modell vorliegt
  // [Kontext=Baustelle] Arbeitstage sind eingetragen
  e_r_Baustelle_Modell: TSperre; // Arbeit= bei Baustellen

  e_r_Baustelle_Stopp: TSperre; // Baustopp= bei Baustellen

  // speichert den letzten Tag der Einplanung für jeden Monteur
  e_r_PlanungsEndeMonteure: TgpIntegerList;
  e_r_PlanungsEndeDatum: array of TDateTime;

  //

function Arbeit_PERSON(MONTEUR_R: Integer): TSperre;
var
  i: Integer;
begin
  i := e_r_Arbeit_MonteurArbeit.indexof(MONTEUR_R);
  if (i = -1) then
  begin
    result := TSperre.create;
    e_r_MonteurArbeit(MONTEUR_R, result);
    e_r_Arbeit_MonteurArbeit.addobject(MONTEUR_R, result);
  end
  else
    result := TSperre(e_r_Arbeit_MonteurArbeit.Objects[i]);
end;

function Sperre_PERSON(MONTEUR_R: Integer): TSperre;
var
  i: Integer;
begin
  i := e_r_Arbeit_MonteurSperre.indexof(MONTEUR_R);
  if (i = -1) then
  begin
    result := TSperre.create;
    e_r_MonteurUrlaub(MONTEUR_R, result);
    e_r_Arbeit_MonteurSperre.addobject(MONTEUR_R, result);
  end
  else
    result := TSperre(e_r_Arbeit_MonteurSperre.Objects[i]);
end;

function e_r_Arbeit(MONTEUR_R: Integer; ArbeitsTag: TANFiXDate): string;

  function e_r_Arbeit_detail(MONTEUR_R: Integer; DATUM: TDateTime): string;
  var
    BAUSTELLE_R: Integer;
    Kontext: Integer;

    Sperre_Farbwert: TColor;
    Sperre_Prefix: string;

    Wertigkeit: TeWertigkeitBaustellenzuordnung;
  begin
    Kontext := 0;

    // Debug Sache
    // if (MONTEUR_R = 1026) and (ArbeitsTag = 20110620) then
    // beep;

    // Ist das angefragte Datum NACH seiner letzten Einplanung?
    (*
      n := e_r_PlanungsEndeMonteure.indexof(MONTEUR_R);
      if (n <> -1) then
      if (DATUM > e_r_PlanungsEndeDatum[n]) then
      begin
      result := '?{Farbe=#FFCC99|Zentriert=JA}';
      exit;
      end;
    *)

    // Prio "0" - wo wurde gearbeitet?
    BAUSTELLE_R := e_r_Baustelle(MONTEUR_R, DATUM, Wertigkeit);
    case BAUSTELLE_R of
      - 1:
        begin

          // keine Ahnung auf welcher Baustelle
          // wenn es jetzt noch Sperren gibt ist das ein Fehler!
          Sperre_Farbwert := Arbeit_PERSON(MONTEUR_R).CheckIt(DATUM);
          if (Sperre_Farbwert <> TColors.SysDefault) then
          begin
            result := '?' + Arbeit_PERSON(MONTEUR_R).Grund +
              '{Farbe=#FF0000|Zentriert=JA|Hinweis=Arbeit= oder Mehrarbeit= ohne Baustelle}';
            exit;
          end;

          Sperre_Farbwert := Sperre_PERSON(MONTEUR_R).CheckIt(DATUM);
          if (Sperre_Farbwert <> TColors.SysDefault) then
          begin
            result := '?' + Sperre_PERSON(MONTEUR_R).Grund +
              '{Farbe=#FF0000|Zentriert=JA|Hinweis=Serre= oder Auszeit= ohne Baustelle}';
            exit;
          end;

        end;
      0:
        begin
          // die Baustelle weis ich wohl, ist jedoch kein Werktag
        end;
    else
      Kontext := e_r_BaustelleBundesland(BAUSTELLE_R);
    end;

    // Prio "1" - Ist ein Feiertag?
    if (e_r_Arbeit_Feiertag.CheckIt(DATUM, Kontext) <> TColors.SysDefault) then
    begin
      if (Kontext = 0) then
        result := 'f{Farbe=#9999FF|Zentriert=JA}'
      else
        result := 'F{Farbe=#9999FF|Zentriert=JA}';
      exit;
    end;

    // PRIO "2": Arbeit / Mehrarbeit der Person!
    Sperre_Farbwert := Arbeit_PERSON(MONTEUR_R).CheckIt(DATUM);
    if (Sperre_Farbwert <> TColors.SysDefault) then
    begin

      //
      repeat

        if (Sperre_Farbwert = cSperreArbeit) then
        begin
          if (BAUSTELLE_R >= cRID_FirstValid) then
            Sperre_Prefix := 'Arbeit'
          else
            Sperre_Prefix := '';
          break;
        end;

        if (Sperre_Farbwert = cSperreMehrArbeit) then
        begin
          Sperre_Prefix := 'Mehrarbeit';
          break;
        end;

        Sperre_Prefix := 'Sonstige';

      until true;
      if Sperre_Prefix <> '' then
      begin
        result := e_r_Arbeit_Umsetzer[Sperre_Prefix, Arbeit_PERSON(MONTEUR_R).Grund];
        if (pos('{', result) = 0) then
          result := result + e_r_Arbeit_Umsetzer[Sperre_Prefix, 'StandardFormat'];

        exit;
      end;
    end;

    // PRIO "3": ist auf der Baustelle gerade "BAUSTOPP?"
    if (BAUSTELLE_R >= cRID_FirstValid) then
    begin
      Sperre_Farbwert := e_r_Baustelle_Stopp.CheckIt(DATUM, BAUSTELLE_R);
      if (Sperre_Farbwert <> TColors.SysDefault) then
      begin
        Sperre_Prefix := 'Baustopp';
        result := e_r_Arbeit_Umsetzer[Sperre_Prefix, e_r_Baustelle_Stopp.Grund];
        if (pos('{', result) = 0) then
          result := result + e_r_Arbeit_Umsetzer[Sperre_Prefix, 'StandardFormat'];
        exit;
      end;
    end;

    // PRIO "4": Sperren jeder Art (erst mal sicherstellen!)
    if (Wertigkeit <> cwb_Keine) then
    begin

      Sperre_Farbwert := Sperre_PERSON(MONTEUR_R).CheckIt(DATUM);
      if (Sperre_Farbwert <> TColors.SysDefault) then
      begin

        //
        repeat

          if (Sperre_Farbwert = cSperreUrlaub) then
          begin
            Sperre_Prefix := 'Urlaub';
            break;
          end;

          if (Sperre_Farbwert = cSperreAuszeit) then
          begin
            Sperre_Prefix := 'Auszeit';
            break;
          end;

          if (Sperre_Farbwert = cSperreWochentag) then
          begin
            Sperre_Prefix := 'Wochentag';
            break;
          end;

          Sperre_Prefix := 'Sonstige';

        until true;
        result := e_r_Arbeit_Umsetzer[Sperre_Prefix, Sperre_PERSON(MONTEUR_R).Grund];
        if (pos('{', result) = 0) then
          result := result + e_r_Arbeit_Umsetzer[Sperre_Prefix, 'StandardFormat'];

        exit;
      end;
    end;

    // Prio "5": normale Arbeit bzw. Arbeit nach Arbeitszeitmodell
    if (BAUSTELLE_R >= cRID_FirstValid) then
    begin
      if (Wertigkeit = cwb_echteArbeit) then
      begin
        // ohne Vermutungen, echte Arbeit
        Sperre_Prefix := 'Baustelle';
        result := e_r_Arbeit_Umsetzer[Sperre_Prefix, e_r_BaustelleKostenstelle(BAUSTELLE_R)];
        if (pos('{', result) = 0) then
          result := result + e_r_Arbeit_Umsetzer[Sperre_Prefix, 'StandardFormat'];
      end
      else
      begin
        // Anhand von Vermutungen -> ROT
        // result := e_r_BaustelleKostenstelle(BAUSTELLE_R) +
        // '{Farbe=#FF0000|Zentriert=JA|Hinweis=keine echte Arbeit}';
        //
        // neu: einfach nix!
        result := '{Farbe=#C0C0C0|Zentriert=JA}';
      end;
      exit;
    end;

    // Prio "6": Fehler bei der Baustellenbestimmung
    if (BAUSTELLE_R = -1) then
    begin
      result := e_r_Einsatz(MONTEUR_R, ArbeitsTag);
      exit;
    end;

    // keine Arbeit, kein passendes Arbeits-Modell, keine aktive Sperre -> einfach NIX
    if WeekDay(ArbeitsTag) = 7 then
      result := '{Farbe=#9999FF|Zentriert=JA}'
      // Sonntag
    else
      result := '{Farbe=#99CC00|Zentriert=JA}'; // Wochentag

  end;

var
  v, n: string;
begin
  EnsureCache_ArbeitBaustelle;
  v := e_r_Arbeit_detail(MONTEUR_R, long2datetime(ArbeitsTag) + cTime_09_00_00);
  n := e_r_Arbeit_detail(MONTEUR_R, long2datetime(ArbeitsTag) + cTime_14_00_00);
  result := DoppelAngabe(v, n);
end;

function e_r_Halbtage(MONTEUR_R, BAUSTELLE_R: Integer; ArbeitsTag: TANFiXDate): Integer;
var
  WT: Integer;
  w, n: Integer;
  DATUM: TDateTime;
  EchteEinplanung: TgpIntegerList;
begin
  // Berechnung der Anzahl der Halbtage wo gearbeitet wird
  result := 0;

  WT := WeekDay(ArbeitsTag);
  for w := 1 to 7 do
  begin
    DATUM := long2datetime(DatePlus(ArbeitsTag, w - WT)) + cTime_09_00_00;

    EchteEinplanung := e_r_Baustelle_Einsatz.CheckEm(DATUM, MONTEUR_R);
    for n := 0 to pred(EchteEinplanung.count) do
      if EchteEinplanung[n] = BAUSTELLE_R then
        inc(result);
    EchteEinplanung.free;
    DATUM := long2datetime(DatePlus(ArbeitsTag, w - WT)) + cTime_14_00_00;

    EchteEinplanung := e_r_Baustelle_Einsatz.CheckEm(DATUM, MONTEUR_R);
    for n := 0 to pred(EchteEinplanung.count) do
      if EchteEinplanung[n] = BAUSTELLE_R then
        inc(result);
    EchteEinplanung.free;

  end;

end;

function e_r_Baustelle(MONTEUR_R: Integer; MOMENT: TDateTime;
  var Wertigkeit: TeWertigkeitBaustellenzuordnung): Integer;
var
  EchteEinplanung: TgpIntegerList;
  EchteEinplanungAndererHalbtag: TgpIntegerList;
  HauptBaustellen: TgpIntegerList;
  n: Integer;
  BAUSTELLE_R: Integer;
  BAUSTELLE_R_ZUORDNUNG: Integer;

  // Enthält die Liste immer wieder dieselbe Kostenstelle, so darf
  // sie auf eine reduziert werden
  procedure Reduziere(const Baustellen: TgpIntegerList);

    procedure reduceFrom(i: Integer);
    var
      Kostenstelle: string;
      n: Integer;
    begin
      if (i < Baustellen.count) then
      begin
        Kostenstelle := e_r_BaustelleKostenstelle(Baustellen[i]);
        for n := pred(Baustellen.count) downto succ(i) do
          if (Kostenstelle = e_r_BaustelleKostenstelle(Baustellen[n])) then
            Baustellen.Delete(n);
        reduceFrom(succ(i));
      end;
    end;

  begin
    if (Baustellen.count > 1) then
      reduceFrom(0);
  end;

var
  VorrangIndex: Integer;
  Zuordnung_PERSON: TSperre;
  AndererHalbtagGueltig: boolean;
  ArbeitsTag: boolean;

begin
  result := -1;
  Wertigkeit := cwb_Keine;
  EnsureCache_ArbeitBaustelle;

  repeat

    // Zuordnung aufbereiten!
    n := e_r_Arbeit_MonteurZuordnung.indexof(MONTEUR_R);
    if (n = -1) then
    begin
      Zuordnung_PERSON := TSperre.create;
      e_r_MonteurZuordnung(MONTEUR_R, Zuordnung_PERSON);
      e_r_Arbeit_MonteurZuordnung.addobject(MONTEUR_R, Zuordnung_PERSON);
    end
    else
      Zuordnung_PERSON := TSperre(e_r_Arbeit_MonteurZuordnung.Objects[n]);

    BAUSTELLE_R_ZUORDNUNG := Zuordnung_PERSON.CheckIt(MOMENT);

    // "Prio 0" Hat der Monteur hier gearbeitet?
    EchteEinplanung := e_r_Baustelle_Einsatz.CheckEm(MOMENT, MONTEUR_R);

    // Reduzierung auf Baustellen identischer Kostenstellen
    Reduziere(EchteEinplanung);

    if (EchteEinplanung.count > 1) then
    begin
      // Einsatz auf 2 oder mehr Baustellen
      if (BAUSTELLE_R_ZUORDNUNG <> TColors.SysDefault) then
      begin
        // Die vorhandene Zuordnung überstrahlt nun dieses Problem ...
        result := BAUSTELLE_R_ZUORDNUNG;
        // ... mit entsprechender Wertigkeit
        if (EchteEinplanung.indexof(BAUSTELLE_R_ZUORDNUNG) <> -1) then
          Wertigkeit := cwb_echteArbeit
        else
          Wertigkeit := cwb_Zuordnung;
        break;
      end
      else
      begin
        // Fehler: Es kann nicht entschieden werden auf welcher
        // Baustelle gearbeitet wurde
        EchteEinplanung.free;
        break;
      end;
    end;

    if (EchteEinplanung.count = 1) then
    begin
      // Einsatz auf einer Baustelle
      Wertigkeit := cwb_echteArbeit;
      result := EchteEinplanung[0];
      EchteEinplanung.free;
      break;
    end;

    // OK, wenn es keine echte Einplanung gibt - ev. am anderen
    // Halbtag?

    AndererHalbtagGueltig := false;

    if (EchteEinplanung.count = 0) then
    begin
      EchteEinplanungAndererHalbtag := e_r_Baustelle_Einsatz.CheckEm(e_r_AndererHalbtag(MOMENT),
        MONTEUR_R);

      if (EchteEinplanungAndererHalbtag.count > 0) then
      begin

        repeat

          // Eingetragene Arbeit, Mehrarbeit oder so
          if (Arbeit_PERSON(MONTEUR_R).CheckIt(MOMENT) <> TColors.SysDefault) then
            break;

          // Eingetragene Sperren
          if (Sperre_PERSON(MONTEUR_R).CheckIt(MOMENT) <> TColors.SysDefault) then
            break;

          for n := 0 to pred(EchteEinplanungAndererHalbtag.count) do
          begin

            BAUSTELLE_R := EchteEinplanungAndererHalbtag[n];

            // Arbeitszeitmodell verhindert Arbeit
            if (e_r_Baustelle_mitModell.indexof(BAUSTELLE_R) <> -1) then
              if (e_r_Baustelle_Modell.CheckIt(MOMENT, BAUSTELLE_R) = TColors.SysDefault) then
                continue;

            // Baustopp verhindert Arbeit
            if (e_r_Baustelle_Stopp.CheckIt(MOMENT, BAUSTELLE_R) <> TColors.SysDefault) then
              continue;

            // Alles passt!
            result := BAUSTELLE_R;
            AndererHalbtagGueltig := true;
            break;

          end;

        until true;
      end;
      EchteEinplanungAndererHalbtag.free;
    end;

    EchteEinplanung.free;
    if AndererHalbtagGueltig then
    begin
      Wertigkeit := cwb_echteArbeit;
      break;
    end;

    // "Prio 1" Zuordnung: etwas "schwächer" als echte Arbeit, aber stärker als
    // Vorrangbaustellen und Hauptbaustellen
    if (BAUSTELLE_R_ZUORDNUNG <> TColors.SysDefault) then
    begin

      ArbeitsTag := true;
      // Jetzt muss das Arbeitszeitmodell noch passen!
      if (e_r_Baustelle_mitModell.indexof(BAUSTELLE_R_ZUORDNUNG) <> -1) then
        // heute keine Arbeit?
        if (e_r_Baustelle_Modell.CheckIt(MOMENT, BAUSTELLE_R_ZUORDNUNG) = TColors.SysDefault) then
          // keine Arbeit!
          ArbeitsTag := false;

      if ArbeitsTag then
      begin
        // Zuordnung gültig
        result := BAUSTELLE_R_ZUORDNUNG;
        Wertigkeit := cwb_Zuordnung;
        break;
      end;

    end;

    // "Prio 2" Von Bis Baustellen
    HauptBaustellen := e_r_Baustelle_VonBis.CheckEm(MOMENT, MONTEUR_R);

    if (HauptBaustellen.count = 0) then
    begin
      BAUSTELLE_R := e_r_Baustelle_Einsatz.CheckNear(MOMENT, MONTEUR_R);
      if (BAUSTELLE_R <> TColors.SysDefault) then
        HauptBaustellen.Add(BAUSTELLE_R);
    end;

    if (HauptBaustellen.count = 0) then
    begin
      // Keine Favoriten Baustelle -> Fehler
      HauptBaustellen.free;
      break;
    end;

    // Suche eine Baustelle die überhaupt Arbeit an diesem Tag anbietet
    for n := pred(HauptBaustellen.count) downto 0 do
      // nur Baustellen mit Arbeitszeitmodell
      if (e_r_Baustelle_mitModell.indexof(HauptBaustellen[n]) <> -1) then
        // heute keine Arbeit
        if (e_r_Baustelle_Modell.CheckIt(MOMENT, HauptBaustellen[n]) = TColors.SysDefault) then
          // löschen
          HauptBaustellen.Delete(n);

    // Reduziere, wenn identische Kostenstellen
    Reduziere(HauptBaustellen);

    if (HauptBaustellen.count > 1) then
    begin

      // Hat eine der Baustellen Vorrang?
      VorrangIndex := -1;
      for n := 0 to pred(e_r_Baustelle_Vorrang.count) do
      begin
        VorrangIndex := HauptBaustellen.indexof(e_r_Baustelle_Vorrang[n]);
        if (VorrangIndex <> -1) then
          break;
      end;
      if (VorrangIndex <> -1) then
      begin
        result := HauptBaustellen[VorrangIndex];
        HauptBaustellen.free;
        Wertigkeit := cwb_Vermutung;
        break;
      end;

      // Es gibt mehrere Favoriten -> wähle die Baustelle, die
      // einer mit einem Einplanungsdatum am nächsten liegt!
      BAUSTELLE_R := e_r_Baustelle_Einsatz.CheckNear(MOMENT, MONTEUR_R);
      if (BAUSTELLE_R <> TColors.SysDefault) then
        for n := pred(HauptBaustellen.count) downto 0 do
          if (HauptBaustellen[n] <> BAUSTELLE_R) then
            if (HauptBaustellen.count > 1) then
              HauptBaustellen.Delete(n);
    end;

    if (HauptBaustellen.count = 1) then
    begin
      // genau für eine Baustelle ein Favorit
      result := HauptBaustellen[0];
      HauptBaustellen.free;
      Wertigkeit := cwb_Vermutung;
      break;
    end;

    if (HauptBaustellen.count = 0) then
    begin
      result := 0;
      HauptBaustellen.free;
      break;
    end;

    HauptBaustellen.free;

  until true;

end;

function e_r_Einsatz(MONTEUR_R: Integer; ArbeitsTag: TANFiXDate): string;

  function e_r_Einsatz_Detail(MONTEUR_R: Integer; DATUM: TDateTime): string;
  var
    Baustellen: TStringList;
    AnzahlKlammer: Integer;
    AnzahlFavoriten: Integer;

    procedure addBaustelleAs(BAUSTELLE_R: Integer; Markierung: string = '');
    var
      sBaustelle: string;
    begin

      // String bilden
      sBaustelle := e_r_BaustelleKuerzel(BAUSTELLE_R) + Markierung;
      if (e_r_Baustelle_Vorrang.indexof(BAUSTELLE_R) <> -1) then
        sBaustelle := sBaustelle + '§';

      if (e_r_Baustelle_mitModell.indexof(BAUSTELLE_R) <> -1) then
      begin
        // Die Baustelle hat ein Arbeitszeitmodell!
        if (e_r_Baustelle_Modell.CheckIt(DATUM, BAUSTELLE_R) = TColors.SysDefault) then
        begin
          // heute jedoch nicht!
          Baustellen.Add('(' + sBaustelle + ')');
          inc(AnzahlKlammer);
        end
        else
        begin
          // mit Modell
          Baustellen.Add(sBaustelle + '*');
          inc(AnzahlFavoriten);
        end;
      end
      else
      begin
        // ohne Modell
        Baustellen.Add(sBaustelle);
        inc(AnzahlFavoriten);
      end;

    end;

  var
    EchteEinplanung: TgpIntegerList;
    EchteEinplanungAndererHalbtag: TgpIntegerList;
    HauptBaustellen: TgpIntegerList;
    n: Integer;
    BAUSTELLE_R: Integer;
    sFormatierung: string;
    // Statistik
    Zuordnung_PERSON: TSperre;
  begin
    Baustellen := TStringList.create;

    sFormatierung := '{Farbe=#C0C0C0}'; // grau: einfach nix!

    repeat

      // Ist das angefragte Datum NACH seiner letzten Einplanung?
      (*
        n := e_r_PlanungsEndeMonteure.indexof(MONTEUR_R);
        if (n <> -1) then
        if (DATUM > e_r_PlanungsEndeDatum[n]) then
        begin
        Baustellen.add('?');
        sFormatierung := '{Farbe=#FFCC99}';
        break;
        end;
      *)

      // Init
      AnzahlKlammer := 0;
      AnzahlFavoriten := 0;

      // Gebe alle Baustellen auf denen hat der Monteur am DATUM gearbeitet?
      EchteEinplanung := e_r_Baustelle_Einsatz.CheckEm(DATUM, MONTEUR_R);
      for n := 0 to pred(EchteEinplanung.count) do
        addBaustelleAs(EchteEinplanung[n], '!!');

      // Sollte es keinen Termin geben, Berechne mal den komplementär-Termin
      if (EchteEinplanung.count = 0) then
      begin
        EchteEinplanungAndererHalbtag := e_r_Baustelle_Einsatz.CheckEm(e_r_AndererHalbtag(DATUM),
          MONTEUR_R);
        for n := 0 to pred(EchteEinplanungAndererHalbtag.count) do
          addBaustelleAs(EchteEinplanungAndererHalbtag[n], '!');
        EchteEinplanungAndererHalbtag.free;
      end;
      EchteEinplanung.free;

      // Zuordnungen
      n := e_r_Arbeit_MonteurZuordnung.indexof(MONTEUR_R);
      if (n = -1) then
      begin
        Zuordnung_PERSON := TSperre.create;
        e_r_MonteurZuordnung(MONTEUR_R, Zuordnung_PERSON);
        e_r_Arbeit_MonteurZuordnung.addobject(MONTEUR_R, Zuordnung_PERSON);
      end
      else
        Zuordnung_PERSON := TSperre(e_r_Arbeit_MonteurZuordnung.Objects[n]);

      BAUSTELLE_R := Zuordnung_PERSON.CheckIt(DATUM);
      if (BAUSTELLE_R <> TColors.SysDefault) then
        addBaustelleAs(BAUSTELLE_R, '@');

      // Wie ist er eingeplant?
      HauptBaustellen := e_r_Baustelle_VonBis.CheckEm(DATUM, MONTEUR_R);

      // Suche eine Baustelle die Arbeit an diesem Tag anbietet
      for n := pred(HauptBaustellen.count) downto 0 do
        addBaustelleAs(HauptBaustellen[n]);
      HauptBaustellen.free;

      if (AnzahlFavoriten > 0) then
        sFormatierung := '{Farbe=#FFFFFF}';

      //
      if (AnzahlFavoriten > 1) or (Baustellen.count = 0) then
      begin
        BAUSTELLE_R := e_r_Baustelle_Einsatz.CheckNear(DATUM, MONTEUR_R);
        if (BAUSTELLE_R <> TColors.SysDefault) then
          addBaustelleAs(BAUSTELLE_R, '+');
      end;

      // Sind ALLE eingeklammert ist es ausserhalb des Arbeitszeit
      // Modelles
      if (Baustellen.count > 0) then
        if (Baustellen.count = AnzahlKlammer) then
          if (WeekDay(ArbeitsTag) = 7) then
            sFormatierung := '{Farbe=#9999FF}'
          else
            sFormatierung := '{Farbe=#99CC00}';

    until true;
    result := HugeSingleLine(Baustellen, '|') + sFormatierung;
    Baustellen.free;

  end;

var
  v, n: string;

begin
  EnsureCache_ArbeitBaustelle;
  v := e_r_Einsatz_Detail(MONTEUR_R, long2datetime(ArbeitsTag) + cTime_09_00_00);
  n := e_r_Einsatz_Detail(MONTEUR_R, long2datetime(ArbeitsTag) + cTime_14_00_00);
  result := DoppelAngabe(v, n);
end;

procedure EnsureCache_ArbeitBaustelle;
var
  cBAUSTELLE: TdboCursor;
  cAUFTRAG: TdboCursor;
  D: TDateTime;
  VON, BIS: TANFiXDate;
  vormittags: string;
  BAUSTELLE_R: Integer;
  i: Integer;
  Sperre: TSperreRecord;
  m: TgpIntegerList;
  INFO: TStringList;
  StandardArbeitszeitModell: TStringList;
  AnzahlModellAngaben: Integer;
begin
  if not(assigned(e_r_Arbeit_MonteurSperre)) then
  begin

    e_r_Arbeit_MonteurSperre := TGpIntegerObjectList.create;
    e_r_Arbeit_MonteurArbeit := TGpIntegerObjectList.create;
    e_r_Arbeit_MonteurZuordnung := TGpIntegerObjectList.create;

    e_r_Arbeit_Umsetzer := TFieldMapping.create;
    with e_r_Arbeit_Umsetzer do
    begin
      Path := SystemPath;
      FilePrefix := 'Arbeit';
    end;

    e_r_Arbeit_Feiertag := TSperre.create;
    Feiertage.AddToSperre(cSperreFeiertag, cPrio_FeiertagSperre, e_r_Arbeit_Feiertag);

    // Umfassendes Caching aufbauen, der Cache umfasst:
    //
    // * die Laufzeiten der Baustelle (VON,BIS)
    // * die Hauptmonteure der Baustelle (MONTEURE=)
    // * die Arbeitszeitmodelle der Baustelle (Arbeit=)
    // *

    //
    e_r_Baustelle_VonBis := TSperre.create;

    e_r_Baustelle_Vorrang := e_r_sqlm(
      { } 'select RID from BAUSTELLE where' +
      { } ' (VORRANG=''' + cC_True + ''')');

    e_r_Baustelle_Einsatz := TSperre.create;
    e_r_Baustelle_Modell := TSperre.create;
    e_r_Baustelle_Stopp := TSperre.create;

    // Alle Baustellen-Dinge einlesen
    TSperre.Reset(Sperre);
    INFO := TStringList.create;
    StandardArbeitszeitModell := TStringList.create;
    with StandardArbeitszeitModell do
    begin
      Add('Arbeit=Mo');
      Add('Arbeit=Di');
      Add('Arbeit=Mi');
      Add('Arbeit=Do');
    end;
    cBAUSTELLE := nCursor;
    with cBAUSTELLE do
    begin
      sql.Add('select RID, INFO, VON, BIS from BAUSTELLE');
      ApiFirst;
      while not(eof) do
      begin
        BAUSTELLE_R := FieldByName('RID').AsInteger;
        VON := DateTime2Long(FieldByName('VON').AsDateTime);
        BIS := DateTime2Long(FieldByName('BIS').AsDateTime);
        e_r_sqlt(FieldByName('INFO'), INFO);

        // Baustopp=
        e_r_Baustelle_Stopp.ReadFromMemo(
          { } INFO,
          { } sSperre_Wert_Baustopp,
          { } nil,
          { } BAUSTELLE_R);

        // Arbeit=, Mehrarbeit=
        AnzahlModellAngaben := e_r_Baustelle_Modell.ReadFromMemo(
          { } INFO,
          { } sSperre_Wert_Arbeit,
          { } nil,
          { } BAUSTELLE_R);
        (* ggf. das Standard-Arbeitszeitmodell nachladen
          if (AnzahlModellAngaben = 0) then
          e_r_Baustelle_Modell.ReadFromMemo(
          { } StandardArbeitszeitModell,
          { } sSperre_Wert_Arbeit,
          { } nil,
          { } BAUSTELLE_R);
        *)
        m := e_r_Monteure(BAUSTELLE_R);
        if DateOK(VON) and DateOK(BIS) then
        begin
          with Sperre do
          begin
            StartD := long2datetime(VON);
            EndeD := long2datetime(BIS) + cTime_23_59_59;
            BadColor := BAUSTELLE_R;
          end;
          for i := 0 to pred(m.count) do
          begin
            Sperre.Kontext := m[i];
            e_r_Baustelle_VonBis.Add(Sperre);
          end;
        end;
        m.free;
        Apinext;
      end;
    end;
    cBAUSTELLE.free;
    INFO.free;
    StandardArbeitszeitModell.free;

    e_r_Baustelle_mitModell := e_r_Baustelle_Modell.Kontexte;

    // Die komplette echt Arbeit einlesen
    cAUFTRAG := nCursor;
    with cAUFTRAG do
    begin
      sql.Add('select');
      sql.Add(' BAUSTELLE_R,');
      sql.Add(' MONTEUR1_R,');
      sql.Add(' MONTEUR2_R,');
      sql.Add(' AUSFUEHREN,');
      sql.Add(' VORMITTAGS');
      sql.Add('from');
      sql.Add(' AUFTRAG');
      sql.Add('where');
      sql.Add(' (STATUS<5) and');
      sql.Add(' (AUSFUEHREN>''' + Long2date(cMonDa_ErsterTermin) + ''') and');
      sql.Add(' (MONTEUR1_R is not null)');
      sql.Add('group by');
      sql.Add(' AUSFUEHREN, VORMITTAGS, BAUSTELLE_R, MONTEUR1_R, MONTEUR2_R');

      TSperre.Reset(Sperre);
      ApiFirst;
      while not(eof) do
      begin
        //
        with Sperre do
        begin
          vormittags := FieldByName('VORMITTAGS').AsString;
          D := FieldByName('AUSFUEHREN').AsDateTime;
          repeat

            //
            if (vormittags = cVormittagsChar) then
            begin
              StartD := D;
              EndeD := D + cTime_12_00_00;
              break;
            end;

            //
            if (vormittags = cNachmittagsChar) then
            begin
              StartD := D + cTime_12_00_00;
              EndeD := D + cTime_23_59_59;
              break;
            end;

            // ACHTUNG-Trick: default: ganzer Tag
            // Ich denke das kann ein guter Trick sein, KEINEN echten
            // Monteurs-Termin zu definieren aber dennoch den Monteur auf
            // diesen ganzen Tag einzuplanen
            StartD := D;
            EndeD := D + cTime_23_59_59;
          until true;

          BadColor := FieldByName('BAUSTELLE_R').AsInteger;
          Kontext := FieldByName('MONTEUR1_R').AsInteger;
        end;
        e_r_Baustelle_Einsatz.Add(Sperre);

        if not(FieldByName('MONTEUR2_R').IsNull) then
        begin
          Sperre.Kontext := FieldByName('MONTEUR2_R').AsInteger;
          e_r_Baustelle_Einsatz.Add(Sperre);
        end;

        Apinext;
      end;
    end;
    cAUFTRAG.free;

    // Jetzt für alle Monteure das maximale Planungs-Datum bestimmen
    // darüber hinaus, wird das Arbeitszeitmodell nicht angewendet!
    e_r_PlanungsEndeMonteure := e_r_Baustelle_Einsatz.Kontexte;
    SetLength(e_r_PlanungsEndeDatum, e_r_PlanungsEndeMonteure.count);
    for i := 0 to pred(e_r_PlanungsEndeMonteure.count) do
      e_r_PlanungsEndeDatum[i] := e_r_Baustelle_Einsatz.MaxDate(e_r_PlanungsEndeMonteure[i]);

    //
    if TestMode then
    begin
      e_r_Baustelle_VonBis.SaveToFile(
        { } DiagnosePath +
        { } 'Sperre.Baustelle-VonBis.csv');
      e_r_Baustelle_Einsatz.SaveToFile(
        { } DiagnosePath +
        { } 'Sperre.Einsatz.csv');
      e_r_Baustelle_Modell.SaveToFile(
        { } DiagnosePath +
        { } 'Sperre.Modell.csv');
    end;
  end;

end;

procedure InvalidateCache_ArbeitBaustelle;
begin
  if assigned(e_r_Arbeit_MonteurSperre) then
  begin
    // Arbeit
    freeandnil(e_r_Arbeit_MonteurSperre);
    e_r_Arbeit_MonteurArbeit.free;
    e_r_Arbeit_Umsetzer.free;
    e_r_Arbeit_Feiertag.free;
    e_r_Baustelle_VonBis.free;
    e_r_Baustelle_Vorrang.free;
    e_r_Baustelle_Einsatz.free;
    e_r_Baustelle_Modell.free;
    e_r_Baustelle_mitModell.free;
    e_r_Baustelle_Stopp.free;
    e_r_PlanungsEndeMonteure.free;
    e_r_Arbeit_MonteurZuordnung.free;
    // imp pend: Prüfen, ob Objects freigegeben werden
    SetLength(e_r_PlanungsEndeDatum, 0);
  end;
end;

procedure InvalidateCache_Auftrag;
begin
  if assigned(e_r_AuftragItems_LastRequestedSub) then
    freeandnil(e_r_AuftragItems_LastRequestedSub);
  e_r_AuftragItems_LastRequestedRID := -1;
end;

function e_r_Arbeitszeit_N(rid: Integer): TAnfixTime;
var
  FoundIndex: Integer;
begin
  if (rid <> CacheBaustelleArbeitsZeitN_RID) then
  begin
    EnsureCache_Baustelle;
    FoundIndex := CacheBaustelle.indexof(inttostr(rid));
    if (FoundIndex <> -1) then
      CacheBaustelleArbeitsZeitN_Value :=
        strtointdef(TStringList(CacheBaustelle.Objects[FoundIndex])[8], 0)
    else
      CacheBaustelleArbeitsZeitN_Value := 0;
  end;
  result := CacheBaustelleArbeitsZeitN_Value;
end;

function e_r_BaustellenAktive: TStringList;
begin
  result := TStringList.create;
  if not(FileExists(AktiveBaustellenFName)) then
    ReCreateAktiveBaustellen;
  result.LoadFromFile(AktiveBaustellenFName);
end;

procedure e_r_Sync_Baustelle;
var
  // Baustellen Infos
  cBAUSTELLE: TdboCursor;
  EXPORT_EINSTELLUNGEN: TStringList;
  tBAUSTELLE: TsTable;
  Row: TStringList;

begin
  cBAUSTELLE := nCursor;
  EXPORT_EINSTELLUNGEN := TStringList.create;
  tBAUSTELLE := TsTable.create;
  with tBAUSTELLE do
  begin
    addCol('NUMMERN_PREFIX');
    addCol(cE_FTPHOST);
    addCol(cE_FTPUSER);
    addCol(cE_FTPPASSWORD);
    addCol(cE_FTPVerzeichnis);
    addCol(cE_ZIPPASSWORD);
    addCol(cE_FotoBenennung);
  end;

  with cBAUSTELLE do
  begin
    sql.Add('select NUMMERN_PREFIX,EXPORT_EINSTELLUNGEN from BAUSTELLE');
    sql.Add('where EXPORT_MONDA=' + cC_True_AsString);
    ApiFirst;
    while not(eof) do
    begin
      Row := TStringList.create;
      e_r_sqlt(FieldByName('EXPORT_EINSTELLUNGEN'), EXPORT_EINSTELLUNGEN);
      with Row do
      begin
        Add(FieldByName('NUMMERN_PREFIX').AsString);
        Add(e_r_ParameterFoto(EXPORT_EINSTELLUNGEN, cE_FTPHOST));
        Add(e_r_ParameterFoto(EXPORT_EINSTELLUNGEN, cE_FTPUSER));
        Add(enCrypt_Hex(e_r_ParameterFoto(EXPORT_EINSTELLUNGEN, cE_FTPPASSWORD)));
        Add(e_r_ParameterFoto(EXPORT_EINSTELLUNGEN, cE_FTPVerzeichnis));
        Add(enCrypt_Hex(e_r_ParameterFoto(EXPORT_EINSTELLUNGEN, cE_ZIPPASSWORD)));
        Add(EXPORT_EINSTELLUNGEN.values[cE_FotoBenennung]);
      end;
      tBAUSTELLE.addRow(Row);
      Apinext;
    end;
    tBAUSTELLE.SaveToFile(MdePath + cMonDaServer_Baustelle);
  end;

  tBAUSTELLE.free;
  cBAUSTELLE.free;
  EXPORT_EINSTELLUNGEN.free;
end;

procedure e_r_Sync_AuftraegeAlle;
var
  RIDs: TgpIntegerList;
  n: Integer;
begin
  RIDs := e_r_sqlm(
    { } 'select RID from BAUSTELLE where ' +
    { } ' (EXPORT_EINSTELLUNGEN containing ''FotoBenennung=6'') ' +
    { } 'order by' +
    { } ' NUMMERN_PREFIX');
  for n := 0 to pred(RIDs.count) do
    e_r_Sync_Auftraege(RIDs[n]);
  RIDs.free;
end;

procedure e_r_Sync_Auftraege(BAUSTELLE_R: Integer);
var
  RIDs: TgpIntegerList;
  AllOutData: TStringList;
  OneLine: string;
  n, k: Integer;
  AUFTRAG_R: Integer;
  SubItems: TStringList;
  Protokoll: TStringList;
  INTERN_INFO: TStringList;
  ProtokollStr: string;

  ProtokollFelder: TStringList;
  ProtokollOut: TStringList;
  InternFelder: TStringList;
  InternOut: TStringList;

  Baustelle: string;

  // Für Excel
  xTable: TList;
  xSubs: TStringList;
  xOneLine: string;
  xOptions: TStringList;
  xFName, xPath: string;

  ErrorOnGenerate: boolean;
  IdFTP1: TIdFTP;

  procedure xNewLine;
  begin
    xSubs := TStringList.create;
    xTable.Add(xSubs);
  end;

begin

  //
  RIDs := e_r_sqlm(
    { } 'select RID from AUFTRAG where' +
    { } ' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') and' +
    { } ' (STATUS<>6) ' +
    { } 'order by ' +
    { } ' STRASSE,NUMMER');

  xTable := TList.create;
  xOptions := TStringList.create;
  Protokoll := TStringList.create;
  ProtokollFelder := TStringList.create;
  InternFelder := TStringList.create;
  ProtokollOut := TStringList.create;
  AllOutData := TStringList.create;

  Baustelle := e_r_BaustelleKuerzel(BAUSTELLE_R);
  e_r_ProtokollExport(BAUSTELLE_R, ProtokollFelder);
  e_r_InternExport(BAUSTELLE_R, InternFelder);

  // Kopf Zeile für Excel
  xNewLine;
  xOneLine := cWordHeaderLine;
  while xOneLine <> '' do
    xSubs.Add(nextp(xOneLine, ';'));

  // Spalten Optionen für Excel
  with xOptions do
  begin
    Add('Datum=DATE');
    Add('KundeNummer=');
    Add('Monteur=');
    Add('Bemerkung=');
    Add('Art=');
    Add('Zaehler_Nummer=STRING');
    Add('Anschreiben_Name=');
    Add('Anschreiben_Strasse=');
    Add('Verbraucher_Ort=');
    Add('Verbraucher_Name=');
    Add('Verbraucher_Strasse=');
    Add('Anschreiben_Ort=');
    Add('Zeit=STRING');
    Add('Geaendert=DATETIME');
    Add('Auftrags_Nummer=');
    Add('Status1=');
    Add('Status2=');
    Add('WochentagKurz=');
    Add('Verbraucher_Name2=');
    Add('Anschreiben_Name2=');
    Add('WochentagLang=');
    Add('MonteurText=');
    Add('ZeitText=');
    Add('DatumText=');
    Add('Baustelle=');
    Add('Bearbeiter=');
    Add('Sperre=');
    Add('Planquadrat=');
    Add('ZaehlerInfo1=');
    Add('ZaehlerInfo2=');
    Add('ZaehlerInfo3=');
    Add('ZaehlerInfo4=');
    Add('ZaehlerInfo5=');
    Add('ZaehlerInfo6=');
    Add('ZaehlerInfo7=');
    Add('ZaehlerInfo8=');
    Add('ZaehlerInfo9=');
    Add('ZaehlerInfo10=');
    Add('Verbraucher_Ortsteil=');
    Add('ZaehlerNummerKorrektur=');
    Add('ZaehlerNummerNeu=');
    Add('ZaehlerStandAlt=');
    Add('ZaehlerStandNeu=');
    Add('Protokoll=');
    Add('WechselDatum=DATE');
    Add('WechselZeit=TIME');
    Add('ReglerNummerAlt=');
    Add('ReglerNummerKorrektur=');
    Add('ReglerNummerNeu=');
    Add('Verbaucher_Strasse_Teil1=');
    Add('Verbaucher_Strasse_Teil2=');
    Add('Verbaucher_Strasse_Teil3=');
    Add('WordEmpfaenger=');
    Add('ReferenzIdentitaet=ORDINAL');
    Add('WordAnzahl=');
    Add('OrtsteilCode=');
    Add('SperreKurz=');
    Add('MonteurHandy=');
    Add('InternInfo1=');
    Add('InternInfo2=');
    Add('InternInfo3=');
    Add('InternInfo4=');
    Add('InternInfo5=');
    Add('InternInfo6=');
    Add('InternInfo7=');
    Add('InternInfo8=');
    Add('InternInfo9=');
    Add('InternInfo10=');
    Add('V1=DATETIME');
    Add('V2=DATETIME');
    Add('V3=DATETIME');
  end;

  xSubs.AddStrings(ProtokollFelder);
  xSubs.AddStrings(InternFelder);
  OneLine := cWordHeaderLine + ';' + HugeSingleLine(ProtokollFelder, ';');
  if (InternFelder.count > 0) then
    OneLine := OneLine + ';' + HugeSingleLine(InternFelder, ';');

  AllOutData.Add(OneLine);

  for n := 0 to pred(RIDs.count) do
  begin
    AUFTRAG_R := RIDs[n];

    // die "default" Spalten
    SubItems := e_r_AuftragItems(AUFTRAG_R);

    // gleich nach Excel ausgeben
    xSubs := TStringList.create;
    xTable.Add(xSubs);
    xSubs.AddStrings(SubItems);
    xSubs.Add(''); // grrrr!

    // Protokoll laden
    ProtokollStr := SubItems[twh_Protokoll];
    Protokoll.clear;
    while (ProtokollStr <> '') do
      Protokoll.Add(nextp(ProtokollStr, cProtokollTrenner));
    SubItems[twh_Protokoll] := '';

    ProtokollOut.clear;
    for k := 0 to pred(ProtokollFelder.count) do
    begin
      ProtokollOut.Add(csvCheck(KommaCheck(Protokoll.values[ProtokollFelder[k]])));
    end;

    if (InternFelder.count > 0) then
    begin
      INTERN_INFO := e_r_sqlt('select INTERN_INFO from AUFTRAG where RID=' + inttostr(AUFTRAG_R));
      for k := 0 to pred(InternFelder.count) do
        ProtokollOut.Add(csvCheck(KommaCheck(INTERN_INFO.values[InternFelder[k]])));
      INTERN_INFO.free;
    end;

    xSubs.AddStrings(ProtokollOut);

    AllOutData.Add(e_r_AuftragLine(AUFTRAG_R) + ';' + HugeSingleLine(ProtokollOut, ';'));

  end;

  xPath := AuftragMobilServerPath + Baustelle + '\';
  CheckCreateDir(xPath);

  // Speichern als XLS
  xFName := xPath + Baustelle + '.xls';
  ExcelExport(xFName, xTable, nil, xOptions);

  if FileExists(xPath + 'Vorlage.xls') then
  begin
    repeat
      ErrorOnGenerate := true;

      // Konvertieren mit einer Vorlage.xls
      if not(doConversion(Content_Mode_xls2xls, xFName)) then
        break;

      // Diagnose wegsichern
      FileCopy(xPath + 'Diagnose.txt', xPath + 'Diagnose-Vorlage.txt');

      // Wir brauchen eine csv
      if not(doConversion(Content_Mode_xls2csv, conversionOutFName)) then
        break;

      // Wir brauchen den richtigen Dateinamen
      if not(FileCopy(conversionOutFName, xPath + cE_FotoBenennung + '-' + Baustelle + '.csv')) then
        break;

      // Löschen der "doppelten" Datei
      if not(FileDelete(conversionOutFName)) then
        break;

      ErrorOnGenerate := false;
    until true;
  end
  else
  begin

    // Speichern direkt als .csv
    AllOutData.SaveToFile(xPath + cE_FotoBenennung + '-' + Baustelle + '.csv');
  end;

  // Versioned Copy
  if not(FileCompare(
    { } xPath + cE_FotoBenennung + '-' + Baustelle + '.csv',
    { } xPath + cE_FotoBenennung + '.csv')) then
    FileVersionedCopy(
      { } xPath + cE_FotoBenennung + '-' + Baustelle + '.csv',
      { } xPath + cE_FotoBenennung + '.csv');

  freeandnil(AllOutData);
  freeandnil(ProtokollFelder);
  freeandnil(ProtokollOut);
  freeandnil(Protokoll);
  freeandnil(xTable);
  freeandnil(xOptions);
  freeandnil(InternFelder);
  freeandnil(InternOut);
  freeandnil(RIDs);

  xFName := cE_FotoBenennung + '-' + Baustelle + '.csv';

  // Datei hochladen
  IdFTP1 := TIdFTP.create(nil);
  SolidFTP_Retries := 5;
  SolidInit(IdFTP1);
  with IdFTP1 do
  begin
    Host := nextp(iMobilFTP, ';', 0);
    UserName := nextp(iMobilFTP, ';', 1);
    Password := nextp(iMobilFTP, ';', 2);
  end;

  SolidBeginTransaction;
  SolidPut(IdFTP1, xPath + xFName, '', xFName);
  SolidEndTransaction;

  try
    IdFTP1.Disconnect;
  except
  end;

  try
    IdFTP1.free;
  except
  end;

end;

procedure ReCreateAktiveBaustellen;
var
  cAUFTRAG: TdboCursor;
  cBAUSTELLE: TdboCursor;
  RIDs: string;
  AktiveBaustellen: TStringList;
begin
  AktiveBaustellen := TStringList.create;

  // Baustellen mit Aufträgen suchen
  cAUFTRAG := nCursor;
  with cAUFTRAG do
  begin
    sql.Add('select distinct BAUSTELLE_R from AUFTRAG');
    RIDs := '';
    ApiFirst;
    while not(eof) do
    begin
      if (RIDs = '') then
        RIDs := Fields[0].AsString
      else
        RIDs := RIDs + ',' + Fields[0].AsString;
      Apinext;
    end;
  end;
  cAUFTRAG.free;

  // Baustellen sortiert ausgeben
  if (RIDs <> '') then
  begin
    cBAUSTELLE := nCursor;
    with cBAUSTELLE do
    begin
      //
      sql.Add('select NUMMERN_PREFIX from BAUSTELLE where RID in (' + RIDs +
        ') order by NUMMERN_PREFIX');
      ApiFirst;
      while not(eof) do
      begin
        AktiveBaustellen.Add(FieldByName('NUMMERN_PREFIX').AsString);
        Apinext;
      end;
    end;
    cBAUSTELLE.free;
  end;

  AktiveBaustellen.SaveToFile(AktiveBaustellenFName);
  AktiveBaustellen.free;
end;

function AktiveBaustellenFName: string;
begin
  result := SearchDir + 'AktiveBaustellen.txt';
end;

procedure e_w_unlocate(POSTLEITZAHL_R: Integer);
begin
  if (POSTLEITZAHL_R >= cRID_FirstValid) and (dummyPLZ_R <> POSTLEITZAHL_R) then
  begin
    e_x_sql('update auftrag set ' + ' POSTLEITZAHL_R = NULL ' + 'where POSTLEITZAHL_R =' +
      inttostr(POSTLEITZAHL_R));

    e_x_sql('update ablage set ' + ' POSTLEITZAHL_R = NULL ' + 'where POSTLEITZAHL_R =' +
      inttostr(POSTLEITZAHL_R));

    e_x_sql('delete from postleitzahlen where rid = ' + inttostr(POSTLEITZAHL_R));
  end;

end;

function gFeiertage: TSperreOfficalHolidays;
begin
  if (cFeiertage = nil) then
  begin
    cFeiertage := TSperreOfficalHolidays.create;
    cFeiertage.LoadFromFile(SystemPath + '\' + cFeiertageFName);
  end;
  result := cFeiertage;
end;

function DeleteGeo(AUFTRAG_R: Integer): Integer;
var
  POSTLEITZAHL_R: Integer;
begin
  result := 0;
  // Alte Referenzen aufheben
  POSTLEITZAHL_R := e_r_sql('select POSTLEITZAHL_R from AUFTRAG where RID=' + inttostr(AUFTRAG_R));

  e_w_unlocate(POSTLEITZAHL_R);
end;

function DoppelAngabe(v, n: string): string;
var
  sFormat: string;
begin
  if (v = n) then
    result := v
  else
  begin
    sFormat := nextp(n, '{', 1);
    if (sFormat <> '') then
      sFormat := '{' + sFormat;
    result :=
    { } AnsiLowerCase(nextp(v, '{', 0)) +
    { } ' / ' +
    { } AnsiLowerCase(nextp(n, '{', 0)) +
    { } sFormat;
  end;
end;

const
  _dummyPLZ: Integer = -1;

function dummyPLZ_R: Integer;
var
  Anzahl: Integer;
  lRID: TgpIntegerList;
  n: Integer;
begin
  if (_dummyPLZ < cRID_FirstValid) then
  begin
    Anzahl := e_r_sql('select count(RID) from POSTLEITZAHLEN where PLZ=' + cImpossiblePLZ);
    case Anzahl of
      0:
        begin
          _dummyPLZ := e_w_GEN('GEN_POSTLEITZAHLEN');
          e_x_sql('insert into POSTLEITZAHLEN (RID,PLZ,X,Y,EINTRAG) values (' +
            { RID } inttostr(_dummyPLZ) + ',' +
            { PLZ } cImpossiblePLZ + ',' +
            { X } '0,' +
            { Y } '0,' +
            { Eintrag } 'CURRENT_TIMESTAMP)');

        end;
      1:
        begin
          _dummyPLZ := e_r_sql('select RID from POSTLEITZAHLEN where PLZ=' + cImpossiblePLZ);
        end;
    else

      lRID := e_r_sqlm('select RID from POSTLEITZAHLEN where PLZ=' + cImpossiblePLZ);
      for n := 0 to pred(lRID.count) do
      begin
        e_x_sql('update auftrag set ' + ' POSTLEITZAHL_R = NULL ' + 'where POSTLEITZAHL_R =' +
          inttostr(lRID[n]));

        e_x_sql('update ablage set ' + ' POSTLEITZAHL_R = NULL ' + 'where POSTLEITZAHL_R =' +
          inttostr(lRID[n]));

      end;
      lRID.free;

      e_x_sql('delete from POSTLEITZAHLEN where PLZ=' + cImpossiblePLZ);
      _dummyPLZ := dummyPLZ_R;
    end;
  end;
  result := _dummyPLZ;
end;

procedure e_w_BudgetAbschreiben(BELEG_R: Integer; FName: string);
var
  Arbeitszeiten: THTMLAusgabe;
  ARBEITSZEIT_R: TgpIntegerList;
  n: Integer;
begin
  Arbeitszeiten := THTMLAusgabe.create;
  Arbeitszeiten.LoadFromFile(FName);
  ARBEITSZEIT_R := Arbeitszeiten.AsIntegerList('ARBEITSZEIT_R');
  for n := 0 to pred(ARBEITSZEIT_R.count) do
    e_x_sql('update ARBEITSZEIT set BELEG_R=' + inttostr(BELEG_R) + ' ' + ' where RID=' +
      inttostr(ARBEITSZEIT_R[n]));
  Arbeitszeiten.free;
end;

function e_w_BudgetEinfuegen(BELEG_R: Integer; SubBudget: string = '*'; PERSON_R: Integer = 0;
  moreSettings: TStringList = nil): Integer;
const
  chtml_MIDAUFTRAG = 'load AUFTRAG MID,AUFTRAG';
  chtml_HEADER = 'load HEADER,HEADER';
var
  cARBEIT, cPERSON, cANSCHRIFT: TdboCursor;

  pDateFrom: TANFiXDate;
  pDateTo: TANFiXDate;
  pSchaetzung: boolean;
  pLohn: boolean;
  pSteuer: boolean;
  pBeleg: string;
  pBUDGET: Integer;
  pStundensatz: boolean;

  BUDGET_R: Integer;
  ARTIKEL_R: Integer;
  ZEIT: Integer;
  ZEITSUMME: Integer;
  TITEL: string;

  //
  _Datum: TANFiXDate;
  pFromDatum: TANFiXDate;
  _BUDGET_R: Integer;
  DatensammlerLokal, DatensammlerGlobal: TStringList;
  StundenSaetze: TStringList;
  //
  ArbeitsDetails: TStringList;
  ZeitAbschnittVerwenden: boolean;
  n: Integer;

  // Summierung Über Kostenstellen, die am Anfang der Info
  // in eckigen Klammern angegeben werden müssen
  sKostenstellen: TStringList;
  // in Objects : Arbeitszeitsumme in diesem Budget!

  // Arbeitszeit dieser Position
  function SingleArbeitsZeit: Integer;
  begin
    with cARBEIT do
    begin
      result := SecondsDiff(FieldByName('ZEIT_N').AsInteger, FieldByName('ZEIT_V').AsInteger);
    end;
  end;

// ermittelter Stundensatz für diese Arbeit
  function Stundensatz: double;
  begin
    with cARBEIT do
    begin
      // erst mal über den Abrechnungsbeleg versuchen!
      if not(FieldByName('BELEG_R').IsNull) then
        result := e_r_sqld('select PREIS from POSTEN where ' + ' (BELEG_R=' + FieldByName('BELEG_R')
          .AsString + ') and ' + ' (ARTIKEL_R=' + FieldByName('ARTIKEL_R').AsString + ')')
      else
        result := e_r_PreisNativ(0, FieldByName('ARTIKEL_R').AsInteger);
    end;
  end;

  procedure AddOneLine;
  var
    InfoS: TStringList;
    DATUM: TANFiXDate;
    _Stundensatz: string;
    _SingleArbeitszeit: Integer;
    Kostenstelle: string;
    i: Integer;
  begin
    DatensammlerLokal.Add(chtml_MIDAUFTRAG);
    with cARBEIT do
    begin

      // Zwischenwerte berechnen
      DATUM := DateTime2Long(FieldByName('DATUM').AsDateTime);
      if (DATUM <> _Datum) then
        DatensammlerLokal.Add('DATUM=' + long2datetext(DATUM))
      else
        DatensammlerLokal.Add('DATUM=');
      _Datum := DATUM;
      _Stundensatz := format('%m', [Stundensatz]);
      _SingleArbeitszeit := SingleArbeitsZeit;
      StundenSaetze.values[_Stundensatz] :=
        inttostr(strtointdef(StundenSaetze.values[_Stundensatz], 0) + _SingleArbeitszeit);

      // Ausgabe
      DatensammlerLokal.Add('ARBEITSZEIT_R=' + FieldByName('RID').AsString);
      DatensammlerLokal.Add('ARTIKEL_R=' + FieldByName('ARTIKEL_R').AsString);
      DatensammlerLokal.Add('ZEIT_V=' + secondstostr(FieldByName('ZEIT_V').AsInteger));
      DatensammlerLokal.Add('ZEIT_N=' + secondstostr(FieldByName('ZEIT_N').AsInteger));
      DatensammlerLokal.Add('ZEIT=' + secondstostr(_SingleArbeitszeit));
      DatensammlerLokal.Add('SEKUNDEN=' + inttostr(_SingleArbeitszeit));
      if pStundensatz then
        DatensammlerLokal.Add('STUNDENSATZ=' + _Stundensatz)
      else
        DatensammlerLokal.Add('STUNDENSATZ=');
      DatensammlerLokal.Add('BELEG_R=' + FieldByName('BELEG_R').AsString);
      InfoS := TStringList.create;
      e_r_sqlt(FieldByName('INFO'), InfoS);
      if (InfoS.count > 0) then
        if (pos('[', InfoS[0]) >= 1) and (pos(']', InfoS[0]) > 0) then
        begin
          //
          Kostenstelle := ExtractSegmentBetween(InfoS[0], '[', ']');
          i := sKostenstellen.indexof(Kostenstelle);
          if (i = -1) then
            sKostenstellen.addobject(Kostenstelle, TObject(_SingleArbeitszeit))
          else
            sKostenstellen.Objects[i] := TObject(
              { } Integer(sKostenstellen.Objects[i]) +
              { } _SingleArbeitszeit);
        end;

      DatensammlerLokal.Add('Details=' + HugeSingleLine(InfoS));
      InfoS.free;

    end;
    DatensammlerLokal.Add('pagebreak');
  end;

  procedure SaveLohn;
  var
    n: Integer;
    Stundensatz: double;
    LetzterStundenSatz: double;
    Sekunden: Integer;
    Lohn: double;
    LohnSumme: double;
    SchaetzSumme: double;
  begin
    LohnSumme := 0.0;
    LetzterStundenSatz := 0.0;

    if (StundenSaetze.count = 1) then
    begin
      //
      // imp pend: Kostenstellen bei mehreren Stundensätzen!!!
      //
      Stundensatz := strtodoubledef(nextp(StundenSaetze[0], '=', 0), 0);
      sKostenstellen.sort;
      for n := 0 to pred(sKostenstellen.count) do
      begin
        DatensammlerLokal.Add('load SUMME');
        DatensammlerLokal.Add('STUNDENSATZ=' + format('%m', [Stundensatz]));
        Sekunden := Integer(sKostenstellen.Objects[n]);
        DatensammlerLokal.Add('KOSTENSTELLE=' + sKostenstellen[n]);
        DatensammlerLokal.Add('SEKUNDEN=' + inttostr(Sekunden));
        DatensammlerLokal.Add('ZEIT=' + _('Kostenstelle') + #160 + sKostenstellen[n] + #160#160#160
          + secondstostr(Sekunden));
        Lohn := cPreisRundung((Sekunden * Stundensatz) / 3600.0);
        DatensammlerLokal.Add('LOHN=' + format('%m', [Lohn]));
      end;
    end;

    for n := 0 to (StundenSaetze.count - 1) do
    begin
      Stundensatz := strtodoubledef(nextp(StundenSaetze[n], '=', 0), 0);
      if Stundensatz > 0 then
        LetzterStundenSatz := Stundensatz;
      Sekunden := strtointdef(nextp(StundenSaetze[n], '=', 1), 0);
      DatensammlerLokal.Add('load SUMME');
      DatensammlerLokal.Add('STUNDENSATZ=' + format('%m', [Stundensatz]));
      DatensammlerLokal.Add('SEKUNDEN=' + inttostr(Sekunden));
      DatensammlerLokal.Add('ZEIT=' + secondstostr(Sekunden));
      Lohn := cPreisRundung((Sekunden * Stundensatz) / 3600.0);
      LohnSumme := LohnSumme + Lohn;
      DatensammlerLokal.Add('LOHN=' + format('%m', [Lohn]));
    end;

    //
    if pSchaetzung then
    begin

      SchaetzSumme := (LohnSumme * LastDayOfMonth(pDateFrom)) / extractDay(pDateTo) - LohnSumme;
      Sekunden := round(SchaetzSumme / (LetzterStundenSatz / 3600.0));
      Lohn := cPreisRundung((Sekunden * LetzterStundenSatz) / 3600.0);

      DatensammlerLokal.Add('load SUMME');
      DatensammlerLokal.Add('STUNDENSATZ=' + format('%m', [LetzterStundenSatz]));
      DatensammlerLokal.Add('SEKUNDEN=' + inttostr(Sekunden));
      DatensammlerLokal.Add('ZEIT=' + _('voraussichtlich') + #160 + secondstostr(Sekunden));
      LohnSumme := LohnSumme + Lohn;
      DatensammlerLokal.Add('LOHN=' + _('voraussichtlich') + #160 + format('%m', [Lohn]));

    end;
    DatensammlerGlobal.Add('LOHNSUMME=' + format('%m', [LohnSumme]));
    DatensammlerGlobal.Add('ZEITSUMME=' + secondstostr(ZEITSUMME));
    DatensammlerGlobal.Add('SEKUNDENSUMME=' + inttostr(ZEITSUMME));
  end;

  procedure SaveBeleg;
  var
    Bericht: THTMLTemplate;
    OutPath: string;
    InFName: string;
  begin
    repeat
      InFName :=
      { } MyProgramPath + cRechnungPath +
      { } RIDasStr(PERSON_R) + '\' +
      { } cHTMLTemplatesDir + cHTML_ArbeitszeitFName;
      if FileExists(InFName) then
        break;

      InFName := MyProgramPath + cHTMLTemplatesDir + cHTML_ArbeitszeitFName;
    until true;

    if FileExists(InFName) then
    begin
      Bericht := THTMLTemplate.create;
      with Bericht do
      begin
        LoadFromFile(InFName);
        // CanUseQuick := true;
        WriteValue(DatensammlerLokal, DatensammlerGlobal);
        SortPages;
        OutPath := MyProgramPath + cRechnungPath + RIDasStr(PERSON_R) + '\';
        CheckCreateDir(OutPath);
        SaveToFileCompressed(OutPath + cHTML_ArbeitszeitFName);
      end;
      Bericht.free;
    end;
  end;

  procedure OpenBudget;
  begin
    with cARBEIT do
    begin
      TITEL := FieldByName('TITEL').AsString;
      _BUDGET_R := FieldByName('BUGET_R').AsInteger;
      ARTIKEL_R := FieldByName('ARTIKEL_R').AsInteger;
      ZEIT := SingleArbeitsZeit;
    end;

    if (pDateFrom <> cIllegalDate) and (pDateTo <> cIllegalDate) then
    begin
      TITEL := TITEL + ' (' + long2dateLocalized(pDateFrom) + ' .. ' +
        long2dateLocalized(pDateTo) + ')';
    end;

    if (SubBudget <> '*') then
    begin
      TITEL := TITEL + #13 + 'Budget: ' + SubBudget;
    end;

    DatensammlerLokal.Add('Tabelle Titel=' + TITEL);
    DatensammlerLokal.Add('Sortierbegriff=' + inttostrN(BUDGET_R, 10));
    AddOneLine;
  end;

  procedure processBudget;
  begin
    AddOneLine;
    inc(ZEIT, SingleArbeitsZeit);
  end;

  procedure CloseBudget;
  var
    qPosten: TdboQuery;
    wasRabatt: double;
  begin

    // nun schreibend zugreifen!
    if (BELEG_R >= cRID_FirstValid) then
    begin
      wasRabatt := 0;
      qPosten := nQuery;
      with qPosten do
      begin
        sql.Add('select * from POSTEN');
        sql.Add('where');
        sql.Add(' (BELEG_R=' + inttostr(BELEG_R) + ') and');
        sql.Add(' (BUGET_R=' + inttostr(_BUDGET_R) + ') and');
        sql.Add(' (MENGE_GELIEFERT is null)');
        for_update(sql);
        open;
        First;
        if eof then
        begin
          insert;
          FieldByName('RID').AsInteger := 0;
          FieldByName('BELEG_R').AsInteger := BELEG_R;
        end
        else
        begin
          wasRabatt := FieldByName('RABATT').AsFloat;
          edit;
        end;
        e_w_SetPostenData(ARTIKEL_R, PERSON_R, qPosten);
        FieldByName('BUGET_R').AsInteger := _BUDGET_R;
        FieldByName('MENGE_RECHNUNG').clear;
        FieldByName('MENGE').AsInteger := ZEIT;
        FieldByName('ARTIKEL').AsString := TITEL;
        if (wasRabatt <> 0) then
          FieldByName('RABATT').AsFloat := wasRabatt;
        post;
        close;
      end;
      qPosten.free;
    end;

    // Summe unten hinzunehmen
    DatensammlerLokal.Add('load AUFTRAG LAST,AUFTRAG');
    DatensammlerLokal.Add('SUMME_ZEIT=' + secondstostr(ZEIT));
    DatensammlerLokal.Add('SUMME_SEKUNDEN=' + inttostr(ZEIT));
    DatensammlerLokal.Add('pagebreak');

    inc(ZEITSUMME, ZEIT);

  end;

begin
  // to - do
  //
  // Unten eine kleine Zusammenfassungstabelle:
  //
  // | Zeit 1 | Stundensatz 1 | Auszahlungsbetrag 1
  // | Zeit 2 | Stundensatz 2 | Auszahlungsbetrag 2
  // Auszahlungsbetrag Summe
  //
  // Unten noch eine kleine Sozialversicherungs-Tabelle
  //
  // KV, RV, PV Berechnungen!
  //

  result := -1;
  ZEITSUMME := 0;
  ArbeitsDetails := TStringList.create;
  DatensammlerLokal := TStringList.create;
  DatensammlerGlobal := TStringList.create;
  cARBEIT := nCursor;
  cPERSON := nCursor;
  cANSCHRIFT := nCursor;
  StundenSaetze := TStringList.create;
  sKostenstellen := TStringList.create;

  if assigned(moreSettings) then
  begin
    pDateFrom := date2Long(moreSettings.values['VON']);
    pDateTo := date2Long(moreSettings.values['BIS']);
    pLohn := moreSettings.values['LOHN'] = cC_True;
    pSchaetzung := (moreSettings.values['SCHAETZUNG'] = cC_True) and pLohn;
    pSteuer := (moreSettings.values['STEUER'] = cC_True) and pLohn;
    pBeleg := moreSettings.values['BELEG'];
    pBUDGET := strtointdef(moreSettings.values['BUDGET'], cRID_Null);
    pStundensatz := moreSettings.values['STUNDENSATZ'] <> cC_False;
  end
  else
  begin
    pDateFrom := cIllegalDate;
    pDateTo := cIllegalDate;
    pSchaetzung := false;
    pLohn := false;
    pSteuer := false;
    pBeleg := '';
    pBUDGET := cRID_Null;
    pStundensatz := true;
  end;

  pFromDatum := date2Long(nextp(SubBudget, ';', 1));
  SubBudget := nextp(SubBudget, ';', 0);
  try

    //
    DatensammlerGlobal.Add('save&delete AUFTRAG MID');
    DatensammlerGlobal.Add('save&delete AUFTRAG LAST');
    DatensammlerGlobal.Add('save&delete TRENNER');
    DatensammlerGlobal.Add('save&delete SUMME');
    if not(pLohn) then
    begin
      DatensammlerGlobal.Add('save&delete LOHNKOPF');
      DatensammlerGlobal.Add('save&delete LOHNSUMME');
    end;
    if not(pSteuer) then
      DatensammlerGlobal.Add('save&delete STEUER');

    if (PERSON_R < 1) then
      PERSON_R := e_r_sql('select PERSON_R from BELEG where RID=' + inttostr(BELEG_R));

    // Personendaten
    with cPERSON do
    begin
      sql.Add('SELECT * FROM PERSON WHERE RID=' + inttostr(PERSON_R));
      ApiFirst;
    end;

    // Anschriftsdaten
    with cANSCHRIFT do
    begin
      sql.Add('select * from ANSCHRIFT where RID=' +
        inttostr(cPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsInteger));
      ApiFirst;
    end;

    // Anschrift extrahieren!
    DatensammlerGlobal.Add('Titel=' + _('Arbeitszeit'));
    DatensammlerGlobal.Add('MehrInfo=' + cOrgaMonCopyright);
    DatensammlerGlobal.Add('AktuellesDatum=' + DatumLocalized);
    DatensammlerGlobal.Add('AktuelleUhrzeit=' + Uhr);

    e_r_Anschrift(PERSON_R, DatensammlerGlobal);

    // weitere Globale Felder:
    DatensammlerGlobal.Add('Geburtstag=' + long2dateLocalized(cPERSON.FieldByName('GEBURTSTAG')
      .AsDateTime));
    DatensammlerGlobal.Add('Versicherungsnummer=' + cPERSON.FieldByName('VERSICHERUNGSNUMMER')
      .AsString);

    // Nun die Arbeitszeit an sich!
    with cARBEIT do
    begin
      sql.Add('select');
      sql.Add(' ARBEITSZEIT.RID,');
      sql.Add(' ARBEITSZEIT.DATUM,');
      sql.Add(' ARBEITSZEIT.zeit_v,');
      sql.Add(' ARBEITSZEIT.zeit_n,');
      sql.Add(' ARBEITSZEIT.info,');
      sql.Add(' ARBEITSZEIT.BUGET_R,');
      sql.Add(' ARBEITSZEIT.BELEG_R,');
      sql.Add(' BUGET.BEGRIFF TITEL,');
      sql.Add(' BUGET.ARTIKEL_R');
      sql.Add('from');
      sql.Add(' ARBEITSZEIT');
      sql.Add('left join');
      sql.Add(' buget');
      sql.Add('on');
      sql.Add(' (BUGET.RID=ARBEITSZEIT.BUGET_R)');
      sql.Add('where');

      if (pDateFrom <> cIllegalDate) and (pDateTo <> cIllegalDate) then
      begin
        sql.Add(' (ARBEITSZEIT.DATUM between ''' + Long2date(pDateFrom) + ''' and ''' +
          Long2date(pDateTo) + ''') AND');
      end
      else
      begin
        sql.Add(' (ARBEITSZEIT.DATUM IS NOT NULL) AND');
      end;

      if (pBUDGET >= cRID_FirstValid) then
      begin
        sql.Add(' (ARBEITSZEIT.BUGET_R=' + inttostr(pBUDGET) + ') and');
      end;

      repeat

        // leer (=default) "unabgerechnetes"
        if (pBeleg = '') then
        begin
          sql.Add(' (ARBEITSZEIT.BELEG_R IS NULL) AND');
          break;
        end;

        // Alles
        if (pBeleg = '*') then
          break;

        //
        if (pBeleg = '!') then
        begin
          sql.Add(' (ARBEITSZEIT.BELEG_R is not NULL) and');
          break;
        end;

        sql.Add(' (ARBEITSZEIT.BELEG_R in (' + pBeleg + ')) and');

      until true;

      sql.Add(' (ARBEITSZEIT.ZEIT_V IS NOT NULL) AND');
      sql.Add(' (ARBEITSZEIT.ZEIT_N IS NOT NULL) AND');
      sql.Add(' (BUGET.PERSON_R=' + inttostr(PERSON_R) + ') AND');
      sql.Add(' (BUGET.ARTIKEL_R IS NOT NULL)');
      sql.Add('order by');
      sql.Add(' ARBEITSZEIT.buget_r, ARBEITSZEIT.DATUM, ARBEITSZEIT.ZEIT_V');
      ApiFirst;
      _BUDGET_R := -1;
      _Datum := -1;

      while not(eof) do
      begin

        // Diese Posten überhaupt nehmen?
        // Nachsehen, ob das angegebene Wort im Subbudget enthalten ist.
        ZeitAbschnittVerwenden := (SubBudget = '*') and (pFromDatum = cIllegalDate);

        if not(ZeitAbschnittVerwenden) then
        begin

          if (SubBudget <> '*') then
          begin
            e_r_sqlt(FieldByName('INFO'), ArbeitsDetails);
            for n := 0 to pred(ArbeitsDetails.count) do
              if (pos(SubBudget, ArbeitsDetails[n]) > 0) then
              begin
                ZeitAbschnittVerwenden := true;
                break;
              end;
          end;

          if (pFromDatum <> cIllegalDate) and ZeitAbschnittVerwenden then
          begin
            ZeitAbschnittVerwenden := DateTime2Long(FieldByName('DATUM').AsDateTime) >= pFromDatum;
          end;

        end;

        // Arbeitszeitposten hinzufügen
        if ZeitAbschnittVerwenden then
        begin

          BUDGET_R := FieldByName('BUGET_R').AsInteger;
          if (_BUDGET_R <> BUDGET_R) then
          begin
            if (_BUDGET_R <> -1) then
              CloseBudget;
            OpenBudget;
          end
          else
          begin
            processBudget;
          end;

        end;
        Apinext;
      end;
    end;
    if (_BUDGET_R <> -1) then
      CloseBudget;

    // aktuelle Summen ausgeben
    if pLohn then
      SaveLohn;

    // Ausgaben in einen Beleg
    SaveBeleg;

  except
    on E: Exception do
    begin
      CareTakerLog(cERRORText + ' e_w_BudgetEinfuegen: ' + E.Message);
    end;
  end;
  cARBEIT.free;
  cPERSON.free;
  cANSCHRIFT.free;
  ArbeitsDetails.free;
  DatensammlerLokal.free;
  DatensammlerGlobal.free;
  StundenSaetze.free;
  sKostenstellen.free;
end;

// V E R L A G

const
  _AllVerlage: TStringList = nil;
  // via PERSON_R (unique), start by ensurecache
  _AllVerlage2: TStringList = nil; // via RID (unique), start by ensurecache

procedure EnsureCache_Verlag;
var
  PERSON_R: Integer;
  VERLAG_R: Integer;
  SUCHBEGRIFF: string;
  cVERLAG: TdboCursor;
begin
  if not(assigned(_AllVerlage2)) then
  begin
    _AllVerlage := TStringList.create;
    _AllVerlage2 := TStringList.create;

    cVERLAG := nCursor;
    with cVERLAG do
    begin
      sql.Add('SELECT RID,PERSON_R FROM VERLAG order by RID');
      ApiFirst;
      while not(eof) do
      begin
        VERLAG_R := FieldByName('RID').AsInteger;
        PERSON_R := FieldByName('PERSON_R').AsInteger;
        SUCHBEGRIFF :=
        { } e_r_sqls(
          { } 'select SUCHBEGRIFF from PERSON where RID=' +
          { } inttostr(PERSON_R));

        if (_AllVerlage.indexof(SUCHBEGRIFF) <> -1) then
          SUCHBEGRIFF := SUCHBEGRIFF + ' [' + inttostr(VERLAG_R) + ']';

        _AllVerlage2.addobject(SUCHBEGRIFF, pointer(VERLAG_R));
        _AllVerlage.addobject(SUCHBEGRIFF, pointer(PERSON_R));
        Apinext;
      end;
    end;
    cVERLAG.free;
    _AllVerlage2.sort;
    _AllVerlage.sort;
  end;
end;

procedure InvalidateCache_Verlag;
begin
  if assigned(_AllVerlage2) then
  begin
    freeandnil(_AllVerlage2);
    freeandnil(_AllVerlage);
  end;
end;

function e_r_VerlagPerson(Verlag: string): Integer;
var
  k: Integer;
begin
  EnsureCache_Verlag;
  k := e_r_Verlage1.indexof(Verlag);
  if (k = -1) then
    result := -1
  else
    result := Integer(_AllVerlage.Objects[k]);
end;

function e_r_Verlag_PERSON_R(rid: Integer): string;
var
  n: Integer;
begin
  EnsureCache_Verlag;
  for n := 0 to pred(_AllVerlage.count) do
    if rid = Integer(_AllVerlage.Objects[n]) then
    begin
      result := _AllVerlage[n];
      exit;
    end;
  result := '';
end;

function e_r_Verlag_VERLAG_R(rid: Integer): string;
var
  n: Integer;
begin
  EnsureCache_Verlag;
  for n := 0 to pred(_AllVerlage2.count) do
    if rid = Integer(_AllVerlage2.Objects[n]) then
    begin
      result := _AllVerlage2[n];
      exit;
    end;
  result := '';
end;

function e_r_Verlag_R(s: string): Integer;
var
  k: Integer;
begin
  EnsureCache_Verlag;
  k := _AllVerlage2.indexof(s);
  if k <> -1 then
    k := Integer(_AllVerlage2.Objects[k]);
  result := k;
end;

function e_r_Verlage2: TStringList;
begin
  EnsureCache_Verlag;
  result := _AllVerlage2;
end;

function e_r_Verlage1: TStringList;
begin
  EnsureCache_Verlag;
  result := _AllVerlage;
end;

function e_r_Verlag_R(rid: Integer): Integer;
var
  Verlag: TdboCursor;
begin
  Verlag := nCursor;
  with Verlag do
  begin
    sql.Add('select RID from VERLAG where PERSON_R=' + inttostr(rid));
    First;
    if eof then
      result := -1
    else
      result := FieldByName('RID').AsInteger;
  end;
  Verlag.free;
end;

function e_r_VerlagAlias(VERLAG_R: Integer): Integer;
var
  ALIAS: TdboCursor;
  Visited_Verlag_R: TStringList;
begin
  ALIAS := nCursor;
  with ALIAS do
  begin
    Visited_Verlag_R := TStringList.create;
    repeat
      sql.clear;
      sql.Add('SELECT ALIAS_R FROM PREIS WHERE (VERLAG_R=' + inttostr(VERLAG_R) +
        ') AND (ALIAS_R IS NOT NULL)');
      First;
      if eof then
        break;
      Visited_Verlag_R.Add(inttostr(VERLAG_R));
      VERLAG_R := FieldByName('ALIAS_R').AsInteger;
      if (Visited_Verlag_R.indexof(inttostr(VERLAG_R)) <> -1) then
      begin
        // imp pend: alias loop detected
        break;
      end;
    until false;
    close;
    Visited_Verlag_R.free;
  end;
  ALIAS.free;
  result := VERLAG_R;
end;

function Feiertage: TSperreOfficalHolidays;
begin
  result := gFeiertage;
end;

function e_w_BaustelleLoeschen(BAUSTELLE_R: Integer): boolean;
begin
  result := false;
  try
    // Bei allen Daten die Referenz zerstören
    e_x_sql(
      { } 'update AUFTRAG set MASTER_R=null where' +
      { Datensätze der Hauptbaustelle } ' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') or' +
      { Historische Datensätze in anderen Baustellen } ' (MASTER_R in ' +
      { } '(select RID from AUFTRAG where (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ')))');

    // Alle löschen, die auf die Datensätze zeigen mit "MASTER_R" = null
    e_x_sql(
      { } 'delete from AUFTRAG where MASTER_R in (select RID from AUFTRAG where MASTER_R is null)');

    // Die Datensätze an sich löschen
    e_x_sql(
      { } 'delete from AUFTRAG where MASTER_R is null');

    result := true;
  except
    on E: Exception do
    begin
      CareTakerLog(cERRORText + ' e_w_BaustelleLoeschen: ' + E.Message);
    end;

  end;
end;

function e_w_BaustelleKopie(BAUSTELLE_R: Integer): boolean;
var
  QUELLE_R: Integer;
  lKOPIE_RIDs: TgpIntegerList;
  lKOPIE_IMPORTs: TgpIntegerList;
  lKOPIE_EXPORT_TANs: TgpIntegerList;

  cZIEL: TdboCursor;
  qZIEL: TdboQuery;
  cQUELLE: TdboCursor;

  settings: TStringList;
  rid, EXPORT_TAN: Integer;
  n: Integer;
  OldIndex: Integer;
begin
  result := false;
  try
    settings := e_r_sqlt('select EXPORT_EINSTELLUNGEN from BAUSTELLE where RID=' +
      inttostr(BAUSTELLE_R));
    QUELLE_R := strtointdef(settings.values[cE_KopieVon], cRID_Null);

    if (QUELLE_R >= cRID_FirstValid) then
    begin

      lKOPIE_RIDs := TgpIntegerList.create;
      lKOPIE_IMPORTs := TgpIntegerList.create;
      lKOPIE_EXPORT_TANs := TgpIntegerList.create;
      cZIEL := nCursor;
      qZIEL := nQuery;
      cQUELLE := nCursor;
      repeat
        // Alte Daten aus der ZIEL Baustelle sichern
        with cZIEL do
        begin
          sql.Add('select RID, RID_AT_IMPORT,EXPORT_TAN from AUFTRAG where');
          sql.Add('(BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') and');
          sql.Add('(MASTER_R=RID)');
          ApiFirst;
          while not(eof) do
          begin
            lKOPIE_RIDs.Add(FieldByName('RID').AsInteger);
            lKOPIE_IMPORTs.Add(FieldByName('RID_AT_IMPORT').AsInteger);
            if FieldByName('EXPORT_TAN').IsNull then
              EXPORT_TAN := cRID_Null
            else
              EXPORT_TAN := FieldByName('EXPORT_TAN').AsInteger;
            lKOPIE_EXPORT_TANs.Add(EXPORT_TAN);
            Apinext;
          end;
        end;

        // ZIEL Baustelle löschen
        if (lKOPIE_RIDs.count > 0) then
          if not e_w_BaustelleLoeschen(BAUSTELLE_R) then
            break;

        // ZIEL Baustelle anlegen
        with qZIEL do
        begin
          sql.Add('select * from AUFTRAG');
          for_update(sql);
          open;
        end;
        with cQUELLE do
        begin
          sql.Add('select * from AUFTRAG where');
          sql.Add('(BAUSTELLE_R=' + inttostr(QUELLE_R) + ') and');
          sql.Add(settings.values[cE_SQL_Filter]);
          sql.Add('(MASTER_R=RID)');
          ApiFirst;
          while not(eof) do
          begin
            //
            rid := FieldByName('RID').AsInteger;
            OldIndex := lKOPIE_IMPORTs.indexof(rid);

            qZIEL.insert;
            for n := 0 to pred(FieldCount) do
              if not(Fields[n].IsNull) then
                qZIEL.FieldByName(Fields[n].FieldName).assign(Fields[n])
              else
                qZIEL.FieldByName(Fields[n].FieldName).clear;

            // Baustelle ist anders
            qZIEL.FieldByName('BAUSTELLE_R').AsInteger := BAUSTELLE_R;

            // Baustelle hier sichern wir den Original RID
            qZIEL.FieldByName('RID_AT_IMPORT').AsInteger := rid;

            // Kopie soll Aufwandsneutral sein
            qZIEL.FieldByName('AUFWAND').clear;
            qZIEL.FieldByName('AUFWAND_SCHUTZ').AsString := 'Y';

            if (OldIndex <> -1) then
            begin
              // war schon mal im System, RID und EXPORT-TAN bleiben erhalten
              EXPORT_TAN := lKOPIE_EXPORT_TANs[OldIndex];
              if (EXPORT_TAN = cRID_Null) then
                qZIEL.FieldByName('EXPORT_TAN').clear
              else
                qZIEL.FieldByName('EXPORT_TAN').AsInteger := EXPORT_TAN;
              qZIEL.FieldByName('RID').AsInteger := lKOPIE_RIDs[OldIndex];
              qZIEL.FieldByName('MASTER_R').AsInteger := lKOPIE_RIDs[OldIndex];
              qZIEL.FieldByName('PROTECT_RID').AsInteger := 1;
            end
            else
            begin
              // ist neu für die Zielbaustelle
              qZIEL.FieldByName('RID').AsInteger := 0;
              qZIEL.FieldByName('MASTER_R').clear;
              qZIEL.FieldByName('EXPORT_TAN').clear;
            end;

            qZIEL.post;

            Apinext;

          end;
          close;
        end;
        result := true;
      until true;

      cQUELLE.free;
      cZIEL.free;
      qZIEL.free;
      lKOPIE_RIDs.free;
      lKOPIE_IMPORTs.free;
      lKOPIE_EXPORT_TANs.free;
    end;
    settings.free;
  except
    on E: Exception do
    begin
      CareTakerLog(cERRORText + ' e_w_Baustellekopie: ' + E.Message);
    end;
  end;
end;

function KommaCheck(const s: string): string;
var
  k: Integer;
begin
  result := s;

  // Ist irgendwo ein einzelner Punkt eingegeben?
  // -> in ein echtes Komma "," wandeln
  k := pos('.', s);
  if ((k > 1) and (k < length(s))) then
    if (CharCount('.', s) = 1) then
    begin
      if s[k - 1] in ['0' .. '9'] then
        if s[k + 1] in ['0' .. '9'] then
          result[k] := ',';
    end;

end;

function csvCheck(const s: string): string;
begin
  result := s;
  ersetze('"', '''''', result);
  ersetze(';', ',', result);
end;

begin
  // create
  AuftragLastChangeFields := TStringList.create;
  AuftragCriticalFields := TStringList.create;
  AuftragCriticalFields.Add('MONTEUR_INFO');
  AuftragCriticalFields.Add('INTERN_INFO');
  AuftragCriticalFields.Add('KUNDE_NAME1');
  AuftragCriticalFields.Add('KUNDE_NAME2');
  AuftragCriticalFields.Add('KUNDE_STRASSE');
  AuftragCriticalFields.Add('KUNDE_ORT');
  AuftragCriticalFields.Add('KUNDE_ORTSTEIL');
  AuftragCriticalFields.Add('BRIEF_NAME1');
  AuftragCriticalFields.Add('BRIEF_NAME2');
  AuftragCriticalFields.Add('BRIEF_STRASSE');
  AuftragCriticalFields.Add('BRIEF_ORT');
  CacheBaustelleMonteureLastRequestedRID := -1;

end.
