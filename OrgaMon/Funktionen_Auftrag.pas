{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2023  Andreas Filsinger
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
unit Funktionen_Auftrag;

{$ifdef fpc}
{$mode delphi}
{$endif}

{
  Basis-Routinen rund um "Monteur", "Baustelle" und "Auftrag"
}

interface

uses
  Classes, anfix, gplists,
  globals, dbOrgaMon, Sperre,
  txHoliday;

const
  IgnoreAuftragPost: boolean = false;
  ForceHistorischer: boolean = false;
  HistorischerErzeugt: boolean = false;
  AuftragLastChangeFields: TStringList = nil;
  AuftragCriticalFields: TStringList = nil;
  AuftragLastChangeRID: Integer = 0;
  HANDLUNGSBEDARF_POSTEN_RID: Integer = 0;
  HANDLUNGSBEDARF_MEILENSTEIN_RID: Integer = 0;

var
 // Statistik
 Stat_Erfolg: TgpIntegerList;
 Stat_Vorgezogen: TgpIntegerList;
 Stat_Unmoeglich: TgpIntegerList;
 Stat_Fail: TgpIntegerList;
 Stat_meldungen: integer;
 Stat_nichtEFRE: integer;
 Stat_Attachments: TStringList;
 Stat_FehlendeResourcen: TStringList;

 Ergebnis_MaxAnzahl: integer;

procedure AuftragHistorischerDatensatz(AUFTRAG_R: Integer); overload;
procedure AuftragHistorischerDatensatz(AUFTRAG_R: TList); overload;

// Auftrag - Sachen
function e_r_AuftragNummer(BAUSTELLE_R: integer): integer; // [max(NUMMER)]
function e_r_Schritte(AUFTRAG_R: integer): TStringList;
function e_r_AuftragPlausi(AUFTRAG_R: integer): string; // Plausi-Prüfung
function e_r_Sparte(Art: string): string; // Ermittlung der Sparte
procedure AuftragBeforePost(Auftrag: TdboDataset; ReOrgMode: boolean = false);
function e_w_AuftragDelete(Master_R: Integer): Integer;
procedure e_w_AuftragAblage(Master_R: Integer);
procedure RecourseDeleteAUFTRAG(RIDList: TList; var DeleteCount: Integer);
function e_r_PhasenStatus(AUFTRAG_R: Integer): string;
function e_c_AuftragHeader: TStringList;
function e_r_AuftragItems(AUFTRAG_R: Integer): TStringList; // DO NOT FREE
function e_r_AuftragLine(AUFTRAG_R: Integer): string;
procedure InvalidateCache_Auftrag;
procedure e_r_Sync_Auftraege(BAUSTELLE_R: Integer; WithUpload: boolean = true);
procedure e_r_Sync_AuftraegeAlle; // Bereitstellung von Infos für den Foto-Server
function e_r_InfoBlatt(
      { } Datum_RIDs,
      { } Monteur_RIDs,
      { } Single_RIDs: TgpIntegerList;
      { } ItemInformiert: TList;
      { } MondaMode: boolean = false;
      { } FaxMode: boolean = false;
      { } fb: TFeedBack = nil): TStringList;
function nichtEFREFName(Settings: TStringList): string;
//
// AnzahlTermine=
// MonteurRIDsCount=
//
function e_w_CreateFiles(
 { } Settings: TStringList;
 { } RIDs: TgpIntegerList;
 { } FailL: TgpIntegerList;
 { } Files: TStringList;
 { } fb: TFeedBack = nil): boolean;

procedure ClearStat;

// Ergebnis Meldung
function e_w_Ergebnis(
 { } BAUSTELLE_R: integer;
 { } pOptions: TStringList = nil;
 { } fb: TFeedBack = nil): boolean;

function e_w_Import(
 { } BAUSTELLE_R: integer;
 { } pOptions: TStringList = nil;
 { } fb: TFeedBack = nil): boolean;

// Mail Sachen
procedure e_w_AuftrageMail(AUFTRAG_R: Integer);
function e_r_eMailVorlage(VorlageName: string): Integer; // [EMAIL_R]
function e_r_eMailVorlagen : TgpIntegerList; // (EMAIL_R, EMAIL_R, ...)
procedure eMailCleanUp;

procedure EnsureHints(hints: TStrings);
procedure e_w_QAuftragEnsure(AUFTRAG_R: Integer);

// Personen Monteure
function e_r_Person(PERSON_R: Integer): string;
function e_r_Person2Zeiler(PERSON_R: Integer): TStringList;
function e_r_MonteurRIDFromKuerzel(str: string): Integer;
function e_r_MonteurRIDfromGeraeteID(str: string): Integer;
function e_r_MonteurKuerzel(PERSON_R: Integer): string;
function e_r_MonteurName(PERSON_R: Integer): string;
function e_r_MonteurHandy(PERSON_R: Integer): string;
function e_r_MonteurGeraeteID(PERSON_R: Integer): string;

// Sperre=
procedure e_r_MonteurUrlaub(PERSON_R: Integer; Urlaub: TSperre);

// Arbeit und Mehrarbeit
procedure e_r_MonteurArbeit(PERSON_R: Integer; Arbeit: TSperre);

procedure e_r_MonteurZuordnung(MONTEUR_R: Integer; Arbeit: TSperre);
function e_r_MonteureCache: TStringList;
function e_r_MonteureJonDa: TStringList;
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
procedure EnsureCache_Verlag;

// Baustellen, schneller Datenzugriff
function e_r_BaustelleKuerzel(BAUSTELLE_R: TDOM_Reference): string;
function e_r_BaustelleKostenstelle(BAUSTELLE_R: TDOM_Reference): string;
function e_r_BaustelleBundesland(BAUSTELLE_R: TDOM_Reference): Integer;
function e_r_BaustelleProtokollName(AUFTRAG_R: TDOM_Reference; BAUSTELLE_R: Integer = cRID_Null): string;
function e_r_BaustelleVormittagsVon(BAUSTELLE_R: TDOM_Reference): string;
function e_r_BaustelleVormittagsBis(BAUSTELLE_R: TDOM_Reference): string;
function e_r_BaustelleNachmittagsVon(BAUSTELLE_R: TDOM_Reference): string;
function e_r_BaustelleNachmittagsBis(BAUSTELLE_R: TDOM_Reference): string;
function e_r_BaustelleName(BAUSTELLE_R: TDOM_Reference): string;
function e_r_BaustelleCSV_QUELLE(BAUSTELLE_R: TDOM_Reference): string;
function e_r_BaustelleNameFromKuerzel(KUERZEL: string): string;
function e_r_BaustelleRIDFromKuerzel(KUERZEL: string): Integer;
function e_r_BaustelleMonteure(BAUSTELLE_R: TDOM_Reference): TStringList;
function e_r_BaustelleEinstellungen(BAUSTELLE_R: TDOM_Reference): TStringList; // DONT FREE IT!!

function e_r_Monteure(BAUSTELLE_R: Integer): TgpIntegerList;
function e_r_Baustellen: TStringList; overload;
function e_r_BaustellenLang: TStringList;
function e_r_AktiveBaustellen: TStringList;
function e_r_OrtsteilCode(BAUSTELLE_R: Integer; Ort: string): string;
procedure e_r_ProtokollExport(BAUSTELLE_R: Integer; FelderListe: TStringList);
procedure e_r_InternExport(BAUSTELLE_R: Integer; FelderListe: TStringList);
function e_r_EinzelAufwand(BAUSTELLE_R: Integer): TAnfixTime;
function e_r_Arbeitszeit_V(BAUSTELLE_R: Integer; Wochentag: Integer): TAnfixTime;
function e_r_Arbeitszeit_N(BAUSTELLE_R: Integer; Wochentag: Integer): TAnfixTime;

// Baustelle, Verwaltung
procedure e_r_Sync_Baustelle;
function e_w_BaustelleLoeschen(BAUSTELLE_R: Integer): boolean;
function e_w_BaustelleKopie(BAUSTELLE_R: Integer): boolean;
function e_w_BaustelleAblegen(BAUSTELLE_R: Integer): boolean;
procedure e_w_Baustelle_add_SQL_Filter(Settings, sql : TStrings);

// Baustellen - Foto - Sachen
function e_w_FotoDownload(BAUSTELLE_R : TDOM_Reference = cRID_Unset) : TStringList;
function e_r_BaustelleFotoPath(BAUSTELLE_R: TDOM_Reference): string;
function e_r_BaustelleUploadPath(BAUSTELLE_R: TDOM_Reference): string;
function e_r_FotoPfad(Phase : TeFotoPhase; AUFTRAG_R : Integer): string;
function e_r_FotoAblagePfad(AUFTRAG_R: Integer; PARAMETER: string): string;
function e_r_FotoName(Phase : TeFotoPhase; AUFTRAG_R: Integer; Parameter: string; AktuellerWert: string = ''; Optionen: string = ''): string;
function e_r_FotoRID(AUFTRAG_R: Integer): Integer; // [AUFTRAG_R]

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

// OrgaMon-App: Neuigkeiten der Monteure vom InterNet downloaden, und in die
// Datenbank einlesen
function e_w_ReadMobil(pOptions : TStringList = nil; fb : TFeedback = nil): boolean;

// OrgaMon-App: Terminplanungen aus der Datenbank in das Mobil-Format
// bringen und ins InterNet uploaden
function e_w_WriteMobil(pOptions : TStringList = nil; fb : TFeedback = nil): boolean; overload;
function e_w_WriteMobil(PERSON_R : Integer): boolean; overload;

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
procedure ObtainStrasseHausnummerPos(const _strasseFull: string; var _FirstNummernPos, _LastNummernPos: Integer);
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

procedure AuftragSuchindex(BAUSTELLE_R:Integer=cRID_null);

implementation

uses
  SysUtils,
  math,
  Graphics, Types,
{$IFDEF fpc}
  fpchelper,
{$ELSE}
  System.UITypes,
  IB_Access,
  IB_Components,
  // FlexCel
  FlexCel.Core, FlexCel.xlsAdapter,
{$ENDIF}

  // Tools
  html, OrientationConvert, c7zip,
  CareTakerClient, Mapping, Geld,
  WordIndex, ExcelHelper, systemd,
  SolidFTP,

  // OrgaMon
{$IFNDEF CONSOLE}
  Datenbank,
{$ENDIF}
  Funktionen_App,
  Funktionen_Beleg,
  Funktionen_Basis,
  Funktionen_Artikel,
  Funktionen_Transaktion;

var
  { Private-Deklarationen }
  CacheMonteur: TStringList = nil;
  CacheMonteurKuerzel: TStringList = nil;
  MonteurKuerzel: TStringList = nil;
  MonteurKuerzelGeraeteID: TStringList = nil;

  CacheBaustelle: TStringList = nil;
  CacheBaustelleMonteure: TStringList = nil;
  CacheBaustelleOrtsteile: TSearchStringList = nil;
  CacheBaustelleAufwand: Integer = cRID_Unset;
  CacheBaustelleAufwandValue: Integer = 0;

  CacheBaustelleOrtsteile_BAUSTELLE_R: Integer = cRID_Unset;
  CacheBaustelleMonteureLastRequestedRID: Integer = cRID_Unset;

  // ArbeitszeitV_Cache
  CacheBaustelleArbeitsZeitV_RID: Integer = cRID_Unset;
  CacheBaustelleArbeitsZeitV_Value: TStringList = nil;

  // ArbeitszeitN_Cache
  CacheBaustelleArbeitsZeitN_RID: Integer = cRID_Unset;
  CacheBaustelleArbeitsZeitN_Value: TStringList = nil;

  // Feiertage-Cache
  cFeiertage: TSperreOfficalHolidays = nil;

var
  _AuftragAblage_Copy: TdboScript = nil;
  _AuftragAblage_Del: TdboScript = nil;
  _AuftragAblage_Quelle: TdboCursor = nil;
  _AuftragAblage_FieldNames: TStringList = nil;
  _HugeTransactionN: Integer = 0;

procedure EnsureCache_Monteur; forward;
procedure EnsureCache_Baustelle; forward;
function AktiveBaustellenFName: string; forward;
function gFeiertage: TSperreOfficalHolidays; forward;
function Arbeit_PERSON(MONTEUR_R: Integer): TSperre; forward;
function Sperre_PERSON(MONTEUR_R: Integer): TSperre; forward;

function ErgebnisLogFName : string;
begin
  result :=
   {} DiagnosePath +
   {} cErgebnisPrefix +
   {} inttostrN(_HugeTransactionN, 6) +
   {} cLogExtension;
end;

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
      sql.Add(' (MASTER_R=' + inttostr(Integer(RIDList[n])) + ') and');
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

procedure ObtainStrasseHausnummerPos(const _strasseFull: string; var _FirstNummernPos, _LastNummernPos: Integer);
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
          if CharInSet(_strasseFull[n], ['0' .. '9']) then
            _FirstNummernPos := n;
    end
    else
    begin
      if not CharInSet(_strasseFull[n], ['0' .. '9']) then
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
        if CharInSet(HausnummerZusatz[n], ['0' .. '9']) then
          _FirstNummernPos := n;
      end
      else
      begin
        if not CharInSet(HausnummerZusatz[n], ['0' .. '9']) then
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

var
  _e_r_Person_cPERSON: TdboCursor = nil;
  _e_r_Person_cANSCHRIFT: TdboCursor = nil;

function e_r_Person(PERSON_R: Integer): string;
var
  BEGRIFF: string;
begin

  if (PERSON_R = iSchnelleRechnung_PERSON_R) then
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
      sql.Add(' ORTSTEIL,');
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
          { } HugeSingleLine(e_r_Ort(_e_r_Person_cANSCHRIFT),'|',3,true)
        end
        else
        begin
          BEGRIFF := _e_r_Person_cANSCHRIFT.FieldByName('NAME1').AsString;
          if (BEGRIFF = '') then
            BEGRIFF := FieldByName('SUCHBEGRIFF').AsString;
          result :=
          { } BEGRIFF +
          { } ' (' + FieldByName('NUMMER').AsString + ') ' +
          { } HugeSingleLine(e_r_Ort(_e_r_Person_cANSCHRIFT),'|',3,true);
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
    sql.Add('select * from ANSCHRIFT where RID=' + inttostr(cPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsInteger));
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
    result := cVormittagsChar
  else
    result := cNachmittagsChar;
end;

function VormittagsToTime(s: string): TDateTime;
begin
  s := s + '?';
  case s[1] of
    cVormittagsChar:
      result := cTime_09_00_00;
    cNachmittagsChar:
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
  WOCHENTAG: Integer; // Wochentag der Ausführung
  _STATUS: TePhaseStatus; // Status bisher
  _sBearbeiter: Integer; // Barbeiter bisher

  cOldVersion: TdboCursor;
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
  if not(assigned(AuftragCriticalFields)) then
  begin
    AuftragCriticalFields := TStringList.create;
    with AuftragCriticalFields do
    begin
      Add('MONTEUR_INFO');
      Add('INTERN_INFO');
      Add('KUNDE_NAME1');
      Add('KUNDE_NAME2');
      Add('KUNDE_STRASSE');
      Add('KUNDE_ORT');
      Add('KUNDE_ORTSTEIL');
      Add('BRIEF_NAME1');
      Add('BRIEF_NAME2');
      Add('BRIEF_STRASSE');
      Add('BRIEF_ORT');
    end;
  end;

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
        if assigned(AuftragLastChangeFields) then
         AuftragLastChangeFields.clear
        else
         AuftragLastChangeFields := TStringList.create;
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
            sql.Add('STATUS, MONTEUR1_R, MONTEUR2_R, BEARBEITER_R,');
            sql.Add('AUSFUEHREN, VORMITTAGS, ZEIT_VON, ZEIT_BIS');
            sql.Add('from AUFTRAG where RID=' + inttostr(AuftragLastChangeRID));
            dblog(sql);
            ApiFirst;
          end;

          _STATUS := TePhaseStatus(cOldVersion.FieldByName('STATUS').AsInteger);
          _sBearbeiter := cOldVersion.FieldByName('BEARBEITER_R').AsInteger;

          // Bei Wechsel auf "Neu Anschreiben" kann es noch keinen Termin geben!
          if (STATUS = ctsNeuAnschreiben) and (_STATUS <> ctsNeuAnschreiben) then
          begin
            FieldByName('VORMITTAGS').clear;
            FieldByName('ZEIT_VON').Clear;
            FieldByName('ZEIT_BIS').Clear;
          end;

          // Flags, welche Änderung besser klassifizieren
          MonteurChanged := false; // wurde der Monteur verändert / gelöscht
          TerminChanged := false; // wurde der Termin geändert / gelöscht?
          InitialChange := false; // war es ein Ersteintrag?
          AnzHistorische := -1; // war das überhaupt schon terminiert?

          // Änderung im Termin-Datum?
          repeat

            if (cOldVersion.FieldByName('AUSFUEHREN').AsDate <> FieldByName('AUSFUEHREN').AsDate) then
            begin
              TerminChanged := true;
              break;
            end;

            if (cOldVersion.FieldByName('VORMITTAGS').AsString <> FieldByName('VORMITTAGS').AsString) then
            begin
              TerminChanged := true;
              break;
            end;

            if (cOldVersion.FieldByName('ZEIT_VON').AsString <> FieldByName('ZEIT_VON').AsString) then
            begin
              TerminChanged := true;
              break;
            end;

            if (cOldVersion.FieldByName('ZEIT_BIS').AsString <> FieldByName('ZEIT_BIS').AsString) then
            begin
              TerminChanged := true;
              break;
            end;

          until yet;

          // Änderung in der Monteur-Zuordnung?
          repeat

            if (cOldVersion.FieldByName('MONTEUR1_R').AsString <> FieldByName('MONTEUR1_R').AsString) then
            begin
              MonteurChanged := true;
              break;
            end;

            if (cOldVersion.FieldByName('MONTEUR2_R').AsString <> FieldByName('MONTEUR2_R').AsString) then
            begin
              MonteurChanged := true;
              break;
            end;

          until yet;

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

          // Verlust des Monteur-Informiert bei Änderungen von ...
          //
          // * Termin
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

          if TerminChanged or MonteurChanged then
          begin
            if (sBearbeiter <> cNoBearbeiter) then
              FieldByName('TERMINIERT_R').AsInteger := sBearbeiter;
          end;

          // Erzeugung eines Historischen Datensatzes ?
          MakeHistCopy := ForceHistorischer or MonteurChanged or TerminChanged or (sBearbeiter <> _sBearbeiter);

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

            AnzHistorische := e_r_sql(
             {} 'select count(rid) from AUFTRAG where'+
             {} ' (MASTER_R=' + inttostr(AuftragLastChangeRID) + ') and (STATUS=6)');

            repeat

              if (AnzHistorische > 0) then
                break;
              if FieldByName('AUSFUEHREN').IsModified then
                if cOldVersion.FieldByName('AUSFUEHREN').IsNotNull then
                  break;
              if FieldByName('VORMITTAGS').IsModified then
                if cOldVersion.FieldByName('VORMITTAGS').IsNotNull then
                  break;
              if FieldByName('ZEIT_VON').IsModified then
                if cOldVersion.FieldByName('ZEIT_VON').IsNotNull then
                  break;
              if FieldByName('ZEIT_BIS').IsModified then
                if cOldVersion.FieldByName('ZEIT_BIS').IsNotNull then
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
            until yet;
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
            if (FieldByName('AUFWAND_SCHUTZ').AsString <> cC_True) then
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
        _Name := TWordIndex.AsIndex(_Name);

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
        _Koordinaten := copy(_Koordinaten + fill('z', cSTRASSE_PLANQUADRAT_Length - length(_Koordinaten)), 1,
          cSTRASSE_PLANQUADRAT_Length);

        // Extraction der Wohneinheit
        _Wohneinheit := ObtainStrassenWohnungseinheit(_strasseFull);
        if (_Wohneinheit <> '') then
          _Wohneinheit := fill('0', cSTRASSE_Wohneinheit_Length - length(_Wohneinheit)) + _Wohneinheit + ':';

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
          _HausNummerZusatz := cutblank(nextp(copy(_strasseFull, succ(_LastNummernPos), MaxInt), '#', 0));
          _HausNummerNumerischerZusatz := strtointdef(ObtainStrassenHausNummerNumerischerZusatz(_strasseFull), 0);
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
        if assigned(AuftragLastChangeFields) then
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

        if not(STATUS in [ctsVorgezogen, ctsUnmoeglich, ctsErfolg, ctsRestant, ctsNeuAnschreiben]) then
        begin
          repeat

            // den Status manipulieren!
            if ((FieldByName('AUSFUEHREN').IsNull) or (pos(FieldByName('VORMITTAGS').AsString,
              cVormittagsChar + cNachmittagsChar) = 0)) and FieldByName('ZAEHLER_WECHSEL').IsNull then
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

          until yet;

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
            _Sperre.Add(FieldByName('SPERRE_VON').AsDate, FieldByName('SPERRE_BIS').AsDate, true, cSperreZaehler);
          end;

          if not(FieldByName('ZEITRAUM_VON').IsNull) and not(FieldByName('ZEITRAUM_BIS').IsNull) then
          begin
            _Sperre.Add(FieldByName('ZEITRAUM_VON').AsDate, FieldByName('ZEITRAUM_BIS').AsDate, false, cSperreZaehler);
          end;

          // imp pend: ZEIT_VON + ZEIT_BIS incl. defaults beachten
          if _Sperre.CheckIt(FieldByName('AUSFUEHREN').AsDate + VormittagsToTime(FieldByName('VORMITTAGS').AsString),
            Kontext) <> TColors.SysDefault then
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
      sql.Add(' (MASTER_R=:CROSSREF) and');
      sql.Add(' (MASTER_R<>RID) and');
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
    if
    { } (pos('WASSER', Material) > 0) or
    { } (pos('QN', Material) > 0) or
    { } (Material = 'W') or
    { } (Material = 'WA') or
    { } (Material = 'WZ') then
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
    if (Material='DSET') then
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
    if (Material='WSET') then
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
  until yet;
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

  until yet;
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
  { } '\' +
  { } 'Fotos\';
end;

function e_r_BaustelleUploadPath(BAUSTELLE_R: TDOM_Reference): string;
begin
  result :=
  { } iBaustellenPath +
  { } e_r_BaustelleKuerzel(BAUSTELLE_R) +
  { } '\Upload\';
end;

// Phase 1: Building Fotos
function e_w_FotoDownload(BAUSTELLE_R : TDOM_Reference = cRID_Unset) : TStringList;
var
  lBAUSTELLEN: TgpIntegerList;
  RID: Integer;
  RemoteBilder: TStringList;
  RemoteFotos: TStringList;
  RemoteBilderUnbenannt: TStringList;
  ZipOptions: TStringList;
  WorkPath: string;
  JpgPath: string;
  FTP: TSolidFTP;
  SourcePath: string; // Quell-FTP-Unterverzeichnis
  settings: TStringList;
  n: Integer;
  ZipFileCount: Integer;
  m: Integer;
  LocalFSize, RemoteFSize: Int64;
  ErrorCount: Integer;
begin
  result := TStringList.Create;
  ErrorCount := 0;
  //
  if (FotoPath <> '') then
  begin

    if (BAUSTELLE_R>=cRID_FirstValid) then
    begin
     lBAUSTELLEN := TgpIntegerList.Create;
     lBAUSTELLEN.Add(BAUSTELLE_R);
    end else
    begin
     lBAUSTELLEN := e_r_sqlm(
      {} 'select RID from BAUSTELLE where'+
      {} ' (NUMMERN_PREFIX starts with ''+'') or'+
      {} ' (FOTOS_LADEN='+cC_True_AsString+') '+
      {} 'order by NUMMERN_PREFIX');
    end;

    for m := 0 to pred(lBAUSTELLEN.count) do
    begin

      RID := lBAUSTELLEN[m];
      RemoteBilder := TStringList.create;
      RemoteFotos := TStringList.create;
      RemoteBilderUnbenannt := TStringList.create;
      ZipOptions := TStringList.create;
      FTP := TSolidFTP.create;

      // checks
      settings := e_r_sqlt(
       {} 'select EXPORT_EINSTELLUNGEN from BAUSTELLE where RID=' + inttostr(RID));

      CheckCreateDir(FotoPath);
      WorkPath := FotoPath + e_r_BaustellenPfadFoto(fp_Build, settings) + '\';
      JpgPath := e_r_ParameterFoto(settings, cE_FotoZiel);
      if (JpgPath='') then
       JpgPath := WorkPath
      else
      begin
       JpgPath := FotoPath + JpgPath + '\';
       CheckCreateDir(JpgPath);
      end;

      result.Add('Abgleich von '+WorkPath+' ...');
      CheckCreateDir(WorkPath);

      with FTP do
      begin
        Host := e_r_ParameterFoto(settings, cE_FTPHOST);
        UserName := e_r_FTP_LoginUser(e_r_ParameterFoto(settings, cE_FTPUSER));
        SourcePath := e_r_FTP_SourcePath(e_r_ParameterFoto(settings, cE_FTPUSER));
        Password := e_r_ParameterFoto(settings, cE_FTPPASSWORD);
        result.Add(' login '+UserName);
        if (SourcePath<>'') then
          result.Add(' cd '+SourcePath);
        ZipOptions.Add('Password=' + e_r_ParameterFoto(settings, cE_ZIPPASSWORD));

        try
          //
          BeginTransaction;

          // Prüfungen
          if (Host = '') then
            raise Exception.create(cE_FTPHOST+' hat keinen Eintrag');
          if (UserName = '') then
            raise Exception.create(cE_FTPUSER+' hat keinen Eintrag');
          if (Password = '') then
            raise Exception.create(cE_FTPPASSWORD+' hat keinen Eintrag');

          //
          if not(CheckDir(SourcePath)) then
            raise Exception.create('Verzeichnis "'+SourcePath+'" existiert nicht!');

          // Check if some news ...
          Dir(SourcePath, '*-Bilder.zip', '????-Bilder.zip', RemoteBilder);
          Dir(SourcePath, 'Fotos-*.zip', 'Fotos-????.zip', RemoteFotos);
          Dir(SourcePath, '*-Bilder_Unbenannt.zip', '????-Bilder_Unbenannt.zip', RemoteBilderUnbenannt);
          RemoteBilder.AddStrings(RemoteBilderUnbenannt);
          RemoteBilder.AddStrings(RemoteFotos);
          for n := 0 to pred(RemoteBilder.count) do
          begin

            // Prüfen ob es die Datei ev. schon gibt
            LocalFSize := FSize(WorkPath + RemoteBilder[n]);

            if (LocalFSize > cFSize_NotExists) then
              RemoteFSize := Size(SourcePath, RemoteBilder[n])
            else
              RemoteFSize := cFSize_Null;

            if (LocalFSize = RemoteFSize) then
              continue;

            result.Add(' download '+RemoteBilder[n]);

            // lade ...
            if Get(SourcePath, RemoteBilder[n], '', WorkPath) then
            begin
              ZipFileCount := unzip(WorkPath + RemoteBilder[n], JpgPath, ZipOptions);
              if (ZipFileCount=czip_ERROR_STATUS) then
              begin
                raise Exception.create(
                 {} 'unzip "'+WorkPath + RemoteBilder[n]+
                 {} '" to "'+JpgPath+ '" failed');
              end else
              begin
                result.Add(' unzip to '+JpgPath)
              end;
            end;

          end;
          EndTransaction;
        except
            on E: Exception do
            begin
              result.Add(cERRORText + ' RID'+IntToStr(RID)+': '+E.Message);
              inc(ErrorCount);
            end;
        end;
      end;

      RemoteBilder.free;
      RemoteFotos.free;
      RemoteBilderUnbenannt.free;
      settings.free;
      ZipOptions.free;
      FTP.free;

      result.Add('OK');
    end;
    lBAUSTELLEN.free;
    if (ErrorCount>0) then
      AppendStringsToFile(result,
        {} ErrorFName('FOTODOWNLOAD'),
        {} Uhr8);
  end else
  begin
   result.Add(cINFOText+' '+'kein FotoPfad= definiert!')
  end;
  if DebugMode then
    AppendStringsToFile(result,
      {} ErrorFName('FOTODOWNLOAD',true),
      {} Uhr8);
end;

type
  TFotoCallBacks = class(TObject)
    function ResultEmpty(rid: Integer; FotoGeraeteNo: string): string;
  end;

  { TFotoCallBacks }

function TFotoCallBacks.ResultEmpty(rid: Integer; FotoGeraeteNo: string): string;
begin
  result := '';
end;

type
 TFotoName_JonDaX = class(TOrgaMonApp)
       procedure FotoLog(s: string); override;
 end;

procedure TFotoName_JonDaX.FotoLog(s: string);
begin
  AppendStringsToFile(
    { } s,
    { } ErrorFName('FOTO',true));
end;

const
  FotoName_JonDaX: TFotoName_JonDaX = nil;
  FotoName_CallBacks: TFotoCallBacks = nil;

procedure ensureJonDaX;
begin
  if (FotoName_JonDaX = nil) then
  begin
    FotoName_JonDaX := TFotoName_JonDaX.create;
    if (iAppServerId<>'') and (iAppServerPfad<>'') then
      FotoName_JonDaX.readIni(iAppServerId, iAppServerPfad + 'dat\');
    FotoName_CallBacks := TFotoCallBacks.create;
    FotoName_JonDaX.callback_ZaehlerNummerNeu := FotoName_CallBacks.ResultEmpty;
    FotoName_JonDaX.callback_ReglerNummerNeu := FotoName_CallBacks.ResultEmpty;
  end;
end;

function e_r_FotoName(Phase: TeFotoPhase; AUFTRAG_R: Integer; Parameter: string; AktuellerWert: string = ''; Optionen: string = ''): string;
var
  cAUFTRAG: TdboCursor;
  sResult: TStringList;
  sParameter: TStringList;
  sZaehlerInfo: TStringList;
  BAUSTELLE_R: Integer;
  sSettings: TStringList;
begin
  AUFTRAG_R := e_r_FotoRID(AUFTRAG_R);

  ensureJonDaX;

  sParameter := TStringList.create;
  sZaehlerInfo := TStringList.create;
  cAUFTRAG := nCursor;
  sParameter.values[cParameter_foto_parameter] := Parameter;
  sParameter.values[cParameter_foto_RID] := inttostr(AUFTRAG_R);
  sParameter.values[cParameter_foto_Pfad] := AuftragMobilServerPath;
  sParameter.Values[cParameter_foto_Optionen] := Optionen;
  sParameter.Values[cParameter_foto_Phase] := cFotoPhasen[Phase];

  with cAUFTRAG do
  begin
    sql.Add('select ');
    sql.Add(' AUFTRAG.ART,');
    sql.Add(' AUFTRAG.KUNDE_STRASSE,');
    sql.Add(' AUFTRAG.KUNDE_ORT,');
    sql.Add(' AUFTRAG.ZAEHLER_INFO,');
    sql.Add(' AUFTRAG.ZAEHLER_NUMMER,');
    sql.Add(' AUFTRAG.ZAEHLER_NR_NEU,');
    sql.Add(' AUFTRAG.REGLER_NR_NEU,');
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
    sParameter.values[cParameter_foto_reglernummer_neu] := FieldByName('REGLER_NR_NEU').AsString;
  end;

  // Modus noch ermitteln
  sSettings := e_r_BaustelleEinstellungen(BAUSTELLE_R);
  sParameter.values[cParameter_foto_Modus] := sSettings.values[cE_FotoBenennung];
  sParameter.values[cParameter_foto_Datei] :=
   {} FotoPath + e_r_BaustellenPfadFoto(Phase, sSettings) + '\' +
   {} nextp(AktuellerWert, ',', 0);

  if DebugMode then
   AppendStringsToFile(sParameter, DiagnosePath + 'Fotos-' + DatumLog + cLogExtension,'foto(');

  // Funktion ausführen
  sResult := FotoName_JonDaX.foto(sParameter);

  if DebugMode then
   AppendStringsToFile(sResult, DiagnosePath + 'Fotos-' + DatumLog + cLogExtension,')=');

  result := sResult.values[cParameter_foto_Fehler];
  if (result = '') then
    result :=
    { } sResult.values[cParameter_foto_neu] + ',' +
    { } sResult.values[cParameter_foto_fertig];

  sParameter.free;
  sZaehlerInfo.free;
  cAUFTRAG.free;
end;

function e_r_FotoPfad(Phase : TeFotoPhase; AUFTRAG_R : Integer): string;
var
 BAUSTELLE_R: Integer;
 EINSTELLUNGEN: TStringList; // do NOT FREE
begin
 AUFTRAG_R := e_r_FotoRID(AUFTRAG_R);
 BAUSTELLE_R := e_r_sql('select BAUSTELLE_R from AUFTRAG where RID='+IntToStr(AUFTRAG_R));
 EINSTELLUNGEN := e_r_BaustelleEinstellungen(BAUSTELLE_R);
 result := FotoPath + e_r_BaustellenPfadFoto(Phase, EINSTELLUNGEN) + '\';
end;

function e_r_FotoAblagePfad(AUFTRAG_R: Integer; PARAMETER: string): string;
var
  BAUSTELLE_R: Integer;
  EINSTELLUNGEN: TStringList; // do NOT FREE
  sCall : TStringList;
begin
  sCall := TStringList.Create;
  ensureJonDaX;
  AUFTRAG_R := e_r_FotoRID(AUFTRAG_R);
  BAUSTELLE_R := e_r_sql('select BAUSTELLE_R from AUFTRAG where RID='+IntToStr(AUFTRAG_R));
  EINSTELLUNGEN := e_r_BaustelleEinstellungen(BAUSTELLE_R);
  with sCall do
  begin
    add(cParameter_foto_parameter + '=' + PARAMETER);
    add(cParameter_foto_baustelle + '=' + e_r_BaustelleKuerzel(BAUSTELLE_R));
    add(cParameter_foto_ART + '=' + e_r_sqls('select ART from AUFTRAG where RID='+IntToStr(AUFTRAG_R)));
    add(cParameter_foto_geraet + '=999');
  end;
  result :=
   { } iInternetAblagenPfad +
   { } e_r_ParameterFoto(EINSTELLUNGEN,cE_FTPUSER) + '\' ;
  FotoName_JonDaX.foto_path(sCall,result);

  sCall.Free;
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

    until yet;

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
            MEILENSTEIN.FieldByName('RID').AsString, TObject(MEILENSTEIN.FieldByName('GRUPPE_R').AsInteger));
          ErsterVerfall := false;
        end
        else
        begin
          MaxAbschluss := max(MaxAbschluss, DateTime2Long(MEILENSTEIN.FieldByName('ABSCHLUSS').AsDateTime));
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
        long2datetime(WerktagDatePlus(DateTime2Long(FieldByName('EINGANG').AsDateTime), MaxPostenDauer))
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

function TruncateLeadingZeros(s: string): string;
begin
  result := noblank(s);
  while pos('0', result) = 1 do
    Delete(result, 1, 1);
end;

procedure EnsureCache_Monteur;
var
  SubItem: TStringList;
  cMonteur: TdboCursor;
begin
  if not(assigned(CacheMonteur)) then
  begin
    CacheMonteur := TStringList.create;
    CacheMonteurKuerzel := TStringList.create;
    MonteurKuerzel := TStringList.create;
    MonteurKuerzelGeraeteID := TStringList.create;
    cMonteur := nCursor;
    with cMonteur do
    begin
      sql.Add('SELECT');
      sql.Add('       PERSON.RID');
      sql.Add('     , PERSON.KUERZEL');
      sql.Add('     , PERSON.MONDA');
      sql.Add('     , ANSCHRIFT.NAME1');
      sql.Add('     , PERSON.HANDY');
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
        CacheMonteur.addobject(FieldByName('NAME1').AsString, TObject(FieldByName('RID').AsInteger));
        MonteurKuerzel.addobject(FieldByName('KUERZEL').AsString, TObject(FieldByName('RID').AsInteger));

        if (FieldByName('MONDA').AsString <> '') then
          MonteurKuerzelGeraeteID.addobject(FieldByName('KUERZEL').AsString, TObject(FieldByName('RID').AsInteger));

        //
        SubItem := TStringList.create;
        SubItem.Add(FieldByName('KUERZEL').AsString); // [0]
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
begin
  EnsureCache_Monteur;
  result := MonteurKuerzel.indexof(cutblank(str));
  if (result <> -1) then
    result := Integer(MonteurKuerzel.Objects[result]);
end;

function e_r_MonteurKuerzel(PERSON_R: Integer): string;
var
  _idx: Integer;
begin
  EnsureCache_Monteur;
  _idx := CacheMonteurKuerzel.indexof(inttostr(PERSON_R));
  if _idx <> -1 then
    result := TStringList(CacheMonteurKuerzel.Objects[_idx])[0]
  else
    result := inttostr(PERSON_R);
end;

function e_r_MonteurName(PERSON_R: Integer): string;
var
  _idx: Integer;
begin
  EnsureCache_Monteur;
  _idx := CacheMonteurKuerzel.indexof(inttostr(PERSON_R));
  if (_idx <> -1) then
    result := TStringList(CacheMonteurKuerzel.Objects[_idx])[1]
  else
    result := inttostr(PERSON_R);
end;

function e_r_MonteurHandy(PERSON_R: Integer): string;
var
  _idx: Integer;
begin
  EnsureCache_Monteur;
  _idx := CacheMonteurKuerzel.indexof(inttostr(PERSON_R));
  if (_idx <> -1) then
    result := TStringList(CacheMonteurKuerzel.Objects[_idx])[3]
  else
    result := inttostr(PERSON_R);
end;

procedure InvalidateCache_Monteur;
begin
  freeandnil(CacheMonteur);
  freeandnil(CacheMonteurKuerzel);
  freeandnil(MonteurKuerzel);
  freeandnil(MonteurKuerzelGeraeteID);
  InvalidateCache_Baustelle;
end;

procedure e_r_MonteurUrlaub(PERSON_R: Integer; Urlaub: TSperre);
var
  MemoInfo: TStringList;
begin
  if (PERSON_R >= cRID_FirstValid) then
  begin
    MemoInfo := e_r_sqlt('select BEMERKUNG from PERSON where RID=' + inttostr(PERSON_R));
    Urlaub.ReadFromMemo(MemoInfo, sSperre_Wert_Person);
    MemoInfo.free;
  end;
end;

procedure e_r_MonteurArbeit(PERSON_R: Integer; Arbeit: TSperre);
var
  MemoInfo: TStringList;
begin
  if (PERSON_R >= cRID_FirstValid) then
  begin
    MemoInfo := e_r_sqlt('select BEMERKUNG from PERSON where RID=' + inttostr(PERSON_R));
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

function e_r_MonteurGeraeteID(PERSON_R: Integer): string;
var
  _idx: Integer;
begin
  EnsureCache_Monteur;
  _idx := CacheMonteurKuerzel.indexof(inttostr(PERSON_R));
  if (_idx <> -1) then
    result := TStringList(CacheMonteurKuerzel.Objects[_idx])[2]
  else
    result := inttostr(PERSON_R);
end;

function e_r_eMailVorlage(VorlageName: string): Integer;
begin
  result := e_r_sql(
   {} 'select RID from EMAIL where' +
   {} ' (VORLAGE_R IS NULL) and' +
   {} ' (UID=''' + VorlageName + ''')');
end;

function e_r_eMailVorlagen : TgpIntegerList;
begin
  result := e_r_sqlm(
      {} 'select RID from EMAIL where '+
      {} ' (VORLAGE_R is null) and '+
      {} ' (UID is not null) and '+
      {} ' (UID<>'+SQLstring(cMail_Blocked)+') and '+
      {} ' ((UID not containing ''@'') or (UID containing ''Versand'')) ');
end;

procedure eMailCleanUp;
var
 VORLAGEN: TgpIntegerList;
 Stichtag: TAnfixDate;
begin
 VORLAGEN := e_r_eMailVorlagen;
 Stichtag := DatePlus(DateGet,-365*6);
 // prepare
 e_x_sql(
  {} 'update EMAIL set '+
  {} ' VORLAGE_R = null '+
  {} 'where VORLAGE_R in '+
  {} '(select RID from EMAIL where'+
  {} ' (RID not in ' + ListAsSQL(VORLAGEN)+') and '+
  {} ' ( (EINTRAG is null) or (EINTRAG<''' + Long2Date(Stichtag) + '''))'+
  {} ')');
 // delete
 e_x_sql(
  {} 'delete from EMAIL where '+
  {} '(RID not in ' + ListAsSQL(VORLAGEN)+') and '+
  {} '( (EINTRAG is null) or (EINTRAG<''' + Long2Date(Stichtag) + '''))');
 VORLAGEN.free;
end;

function e_r_MonteureCache: TStringList;
begin
  EnsureCache_Monteur;
  result := MonteurKuerzel;
end;

function e_r_MonteureJonDa: TStringList;
begin
  EnsureCache_Monteur;
  result := MonteurKuerzelGeraeteID;
end;

// BAUSTELLEN

const
 CacheBaustelle_NUMMERN_PREFIX = 0;
 CacheBaustelle_NAME = 1;
 CacheBaustelle_LAST_V = 2;
 CacheBaustelle_LAST_N = 3;
 CacheBaustelle_CSV_QUELLE = 4;
 CacheBaustelle_ORTE = 5;
 CacheBaustelle_PROTOKOLLEXPORT = 6;
 CacheBaustelle_REGEL_ARBEITSZEIT_V = 7;
 CacheBaustelle_REGEL_ARBEITSZEIT_N = 8;
 CacheBaustelle_KOSTENSTELLE = 9;
 CacheBaustelle_BUNDESLAND_IDX = 10;
 CacheBaustelle_EINZEL_AUFWAND = 11;
 CacheBaustelle_VORMITTAGS_ZEIT_VON = 12;
 CacheBaustelle_VORMITTAGS_ZEIT_BIS = 13;
 CacheBaustelle_NACHMITTAGS_ZEIT_VON = 14;
 CacheBaustelle_NACHMITTAGS_ZEIT_BIS = 15;

procedure EnsureCache_Baustelle;
var
  _SubItem: TStringList;
  _Ortsteile: TStringList;
  AUFWAND: TStringList;
  EINZEL_AUFWAND: Integer;
  cBAUSTELLE: TdboCursor;
  ZEIT: string;

  function GanzeWoche (Vormittags:boolean) : string;
  var
   Wochentag : Integer;
   VN : string;
   MaxAnzahlTermine : Integer;
   MaxAnzahlTermineAsString: string;
   REGEL_AUFWAND, HALBTAGES_AUFWAND : Integer;
  begin
   result := '';

   with cBAUSTELLE do
   begin

     VN := VormittagsToChar(Vormittags);

     // default Wert
     REGEL_AUFWAND := FieldByName('REGEL_ARBEITSZEIT_'+VN).AsInteger;

     for Wochentag := cDATE_MONTAG to cDATE_SONNTAG do
     begin

      MaxAnzahlTermineAsString := AUFWAND.Values[cTageNamenKurz[Wochentag]+'-'+VN];
      if (MaxAnzahlTermineAsString<>'') then
       HALBTAGES_AUFWAND := StrToIntDef(MaxAnzahlTermineAsString,0) * EINZEL_AUFWAND
      else
       HALBTAGES_AUFWAND := REGEL_AUFWAND;

       result := result + IntToStr(HALBTAGES_AUFWAND);
       if (Wochentag<>cDATE_SONNTAG) then
        result := result + ';';
    end;
   end;
  end;

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
      dblog(sql);
      ApiFirst;
      while not(eof) do
      begin
        AUFWAND := TStringList.create;
        e_r_sqlt(FieldByName('AUFWAND'), AUFWAND);

        EINZEL_AUFWAND := FieldByName('LAST_V').AsInteger + FieldByName('LAST_N').AsInteger;
        if (EINZEL_AUFWAND > 0) then
          EINZEL_AUFWAND := round(iTagesArbeitszeit / EINZEL_AUFWAND)
        else
          EINZEL_AUFWAND := round(iTagesArbeitszeit / 10.0);

        _SubItem := TStringList.create;
        { CacheBaustelle_NUMMERN_PREFIX }
        { [0] } _SubItem.Add(FieldByName('NUMMERN_PREFIX').AsString);

        { CacheBaustelle_NAME }
        { [1] } _SubItem.Add(FieldByName('NAME').AsString);

        { CacheBaustelle_LAST_V }
        { [2] } _SubItem.Add(inttostr(FieldByName('LAST_V').AsInteger));

        { CacheBaustelle_LAST_N }
        { [3] } _SubItem.Add(inttostr(FieldByName('LAST_N').AsInteger));

        { CacheBaustelle_CSV_QUELLE }
        { [4] } _SubItem.Add(FieldByName('CSV_QUELLE').AsString);
        if (FieldByName('ORTE_AKTIV').AsString = cC_True) then
        begin
          e_r_sqlt(FieldByName('ORTE'), _Ortsteile);

          { CacheBaustelle_ORTE }
          { [5] } _SubItem.Add(';' + HugeSingleLine(_Ortsteile, ';'));
        end
        else
        begin

          { CacheBaustelle_ORTE }
          { [5] } _SubItem.Add('');
        end;

        { CacheBaustelle_PROTOKOLLEXPORT }
        { [6] } _SubItem.Add(FieldByName('PROTOKOLLEXPORT').AsString);

        { CacheBaustelle_REGEL_ARBEITSZEIT_V }
        { [7] } _SubItem.Add(GanzeWoche(true));

        { CacheBaustelle_REGEL_ARBEITSZEIT_N }
        { [8] } _SubItem.Add(GanzeWoche(false));

        { CacheBaustelle_KOSTENSTELLE }
        { [9] } _SubItem.Add(FieldByName('KOSTENSTELLE').AsString);
        if (_SubItem[9] = '') then
          _SubItem[9] := _SubItem[0];

        { CacheBaustelle_BUNDESLAND_IDX }
        { [10] } _SubItem.Add(FieldByName('BUNDESLAND_IDX').AsString);

        { CacheBaustelle_EINZEL_AUFWAND }
        { [11] } _SubItem.Add(IntToStr(EINZEL_AUFWAND));

        { CacheBaustelle_VORMITTAGS_ZEIT_VON =
        { [12] } Zeit := FieldByName('VORMITTAGS_ZEIT_VON').AsString;
        if (Zeit='') then
          Zeit := '08:00:00';
        _SubItem.Add(Zeit);

        { CacheBaustelle_VORMITTAGS_ZEIT_BIS =
        { [13] } Zeit := FieldByName('VORMITTAGS_ZEIT_BIS').AsString;
        if (Zeit='') then
          Zeit := '13:00:00';
        _SubItem.Add(Zeit);

        { CacheBaustelle_NACHMITTAGS_ZEIT_VON =
        { [14] } Zeit := FieldByName('NACHMITTAGS_ZEIT_VON').AsString;
        if (Zeit='') then
          Zeit := '12:00:00';
        _SubItem.Add(Zeit);

        { CacheBaustelle_NACHMITTAGS_ZEIT_BIS =
        { [15] } Zeit := FieldByName('NACHMITTAGS_ZEIT_BIS').AsString;
        if (Zeit='') then
          Zeit := '18:00:00';
        _SubItem.Add(Zeit);

        CacheBaustelle.addobject(inttostr(FieldByName('RID').AsInteger), _SubItem);

        AUFWAND.Free;
        ApiNext;
      end;
      CacheBaustelle.sort;
      CacheBaustelle.sorted := true;
      _Ortsteile.free;
    end;
    cBAUSTELLE.free;
  end;
end;

const
  _ObtainKuerzelFromRID_LastRID: Integer = -1;
  _ObtainKuerzelFromRID_LastResult: string = '';

function e_r_BaustelleKuerzel(BAUSTELLE_R: Integer): string;
var
  FoundIndex: TDOM_Reference;
begin
  if (BAUSTELLE_R = _ObtainKuerzelFromRID_LastRID) then
  begin
    result := _ObtainKuerzelFromRID_LastResult;
  end
  else
  begin
    EnsureCache_Baustelle;
    FoundIndex := CacheBaustelle.indexof(inttostr(BAUSTELLE_R));
    if (FoundIndex <> -1) then
    begin
      result := TStringList(CacheBaustelle.Objects[FoundIndex])[CacheBaustelle_NUMMERN_PREFIX];
      _ObtainKuerzelFromRID_LastRID := BAUSTELLE_R;
      _ObtainKuerzelFromRID_LastResult := result;
    end
    else
      result := inttostr(BAUSTELLE_R);
  end;
end;

const
  _ObtainZeitFromRID_LastRID: Integer = cRID_Unset;
  _ObtainZeitFromRID_VormittagsVon : String = '';
  _ObtainZeitFromRID_VormittagsBis : String = '';
  _ObtainZeitFromRID_NachmittagsVon : String = '';
  _ObtainZeitFromRID_NachmittagsBis : String = '';

procedure BaustelleZeit(BAUSTELLE_R: TDOM_Reference);
var
 I : Integer;
 Subs: TStringList;
begin
  if (BAUSTELLE_R <> _ObtainZeitFromRID_LastRID) then
  begin
    _ObtainZeitFromRID_LastRID := BAUSTELLE_R;
    EnsureCache_Baustelle;
    I := CacheBaustelle.indexof(inttostr(BAUSTELLE_R));
    if (I <> -1) then
    begin
      Subs := TStringList(CacheBaustelle.Objects[I]);
      _ObtainZeitFromRID_VormittagsVon := Subs[CacheBaustelle_VORMITTAGS_ZEIT_VON];
      _ObtainZeitFromRID_VormittagsBis := Subs[CacheBaustelle_VORMITTAGS_ZEIT_BIS];
      _ObtainZeitFromRID_NachmittagsVon := Subs[CacheBaustelle_NACHMITTAGS_ZEIT_VON];
      _ObtainZeitFromRID_NachmittagsBis := Subs[CacheBaustelle_NACHMITTAGS_ZEIT_BIS];
    end else
    begin
      _ObtainZeitFromRID_VormittagsVon := '';
      _ObtainZeitFromRID_VormittagsBis := '';
      _ObtainZeitFromRID_NachmittagsVon := '';
      _ObtainZeitFromRID_NachmittagsBis := '';
    end;
  end;
end;

function e_r_BaustelleVormittagsVon(BAUSTELLE_R: TDOM_Reference): string;
begin
 BaustelleZeit(BAUSTELLE_R);
 result := _ObtainZeitFromRID_VormittagsVon;
end;

function e_r_BaustelleVormittagsBis(BAUSTELLE_R: TDOM_Reference): string;
begin
 BaustelleZeit(BAUSTELLE_R);
 result := _ObtainZeitFromRID_VormittagsBis;
end;

function e_r_BaustelleNachmittagsVon(BAUSTELLE_R: TDOM_Reference): string;
begin
 BaustelleZeit(BAUSTELLE_R);
 result := _ObtainZeitFromRID_NachmittagsVon;
end;

function e_r_BaustelleNachmittagsBis(BAUSTELLE_R: TDOM_Reference): string;
begin
 BaustelleZeit(BAUSTELLE_R);
 result := _ObtainZeitFromRID_NachmittagsBis;
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
      result := TStringList(CacheBaustelle.Objects[FoundIndex])[CacheBaustelle_KOSTENSTELLE];
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
      result := strtointdef(TStringList(CacheBaustelle.Objects[FoundIndex])[CacheBaustelle_BUNDESLAND_IDX], 0);
      _ObtainBundeslandFromRID_LastRID := BAUSTELLE_R;
      _ObtainBundeslandFromRID_LastResult := result;
    end
    else
      result := cRID_Null;
  end;
end;

function e_r_Arbeitszeit_V(BAUSTELLE_R: Integer; Wochentag: Integer): TAnfixTime;
var
  FoundIndex: Integer;
begin
  if (BAUSTELLE_R <> CacheBaustelleArbeitsZeitV_RID) then
  begin
    if assigned(CacheBaustelleArbeitsZeitV_Value) then
      CacheBaustelleArbeitsZeitV_Value.Free;
    EnsureCache_Baustelle;
    FoundIndex := CacheBaustelle.indexof(inttostr(BAUSTELLE_R));
    if (FoundIndex <> -1) then
      CacheBaustelleArbeitsZeitV_Value := split(TStringList(CacheBaustelle.Objects[FoundIndex])[CacheBaustelle_REGEL_ARBEITSZEIT_V])
     else
      CacheBaustelleArbeitsZeitV_Value := nil;
  end;
  if assigned(CacheBaustelleArbeitsZeitV_Value) then
   result := strtoIntDef( CacheBaustelleArbeitsZeitV_Value[pred(WochenTag)], 0)
  else
   result := 0;
end;

function e_r_Arbeitszeit_N(BAUSTELLE_R: Integer; Wochentag: Integer): TAnfixTime;
var
  FoundIndex: Integer;
begin
  if (BAUSTELLE_R <> CacheBaustelleArbeitsZeitN_RID) then
  begin
    if assigned(CacheBaustelleArbeitsZeitN_Value) then
      CacheBaustelleArbeitsZeitN_Value.Free;
    EnsureCache_Baustelle;
    FoundIndex := CacheBaustelle.indexof(inttostr(BAUSTELLE_R));
    if (FoundIndex <> -1) then
      CacheBaustelleArbeitsZeitN_Value := split(TStringList(CacheBaustelle.Objects[FoundIndex])[CacheBaustelle_REGEL_ARBEITSZEIT_N])
     else
      CacheBaustelleArbeitsZeitN_Value := nil;
  end;
  if assigned(CacheBaustelleArbeitsZeitN_Value) then
   result := strtoIntDef( CacheBaustelleArbeitsZeitN_Value[pred(WochenTag)], 0)
  else
   result := 0;
end;

function e_r_BaustelleName(BAUSTELLE_R: Integer): string;
var
  FoundIndex: Integer;
begin
  EnsureCache_Baustelle;
  FoundIndex := CacheBaustelle.indexof(inttostr(BAUSTELLE_R));
  if (FoundIndex <> -1) then
    result := TStringList(CacheBaustelle.Objects[FoundIndex])[CacheBaustelle_NAME]
  else
    result := inttostr(BAUSTELLE_R);
end;

function e_r_BaustelleCSV_QUELLE(BAUSTELLE_R: Integer): string;
var
  FoundIndex: Integer;
begin
  EnsureCache_Baustelle;
  FoundIndex := CacheBaustelle.indexof(inttostr(BAUSTELLE_R));
  if (FoundIndex <> -1) then
    result := TStringList(CacheBaustelle.Objects[FoundIndex])[CacheBaustelle_CSV_QUELLE]
  else
    result := inttostr(BAUSTELLE_R);
end;

function e_r_BaustelleNameFromKuerzel(KUERZEL: string): string;
var
  n: Integer;
begin
  EnsureCache_Baustelle;
  for n := 0 to pred(CacheBaustelle.count) do
    if (KUERZEL = TStringList(CacheBaustelle.Objects[n])[CacheBaustelle_NUMMERN_PREFIX]) then
    begin
      result := TStringList(CacheBaustelle.Objects[n])[CacheBaustelle_NAME];
      exit;
    end;
  result := '?';
end;

function e_r_BaustelleRIDFromKuerzel(KUERZEL: string): Integer;
var
  n: Integer;
begin
  result := cRID_Null;
  KUERZEL := cutblank(KUERZEL);
  if (KUERZEL <> '') then
  begin
    EnsureCache_Baustelle;
    if (StrFilter(KUERZEL,cZiffern)=KUERZEL) then
    begin
      // Numerische Suche, über RID
      // Nicht wirklich suchen, nur sicherstellen dass es den RID gibt
      if (CacheBaustelle.IndexOf(KUERZEL)<>-1) then
       result := StrToIntDef(KUERZEL, cRID_Null);
    end else
    begin
      // Alphanumerische Suche
      KUERZEL := AnsiUpperCase(KUERZEL);
      for n := 0 to pred(CacheBaustelle.count) do
        if (KUERZEL = AnsiUpperCase(TStringList(CacheBaustelle.Objects[n])[CacheBaustelle_NUMMERN_PREFIX])) then
        begin
          result := strtoint(CacheBaustelle[n]);
          break;
        end;
    end;
  end;
end;

function e_r_Baustellen: TStringList;
var
  n: Integer;
begin
  result := TStringList.create;
  EnsureCache_Baustelle;
  for n := 0 to pred(CacheBaustelle.count) do
    result.addobject(TStringList(CacheBaustelle.Objects[n])[CacheBaustelle_NUMMERN_PREFIX], TObject(strtoint(CacheBaustelle[n])));
  result.sort;
end;

function e_r_BaustellenLang: TStringList;
var
  n: Integer;
begin
  result := TStringList.create;
  EnsureCache_Baustelle;
  for n := 0 to pred(CacheBaustelle.count) do
    result.addobject(TStringList(CacheBaustelle.Objects[n])[CacheBaustelle_NAME], TObject(strtoint(CacheBaustelle[n])));
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
  until yet;
  result := ProtokollName;
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

function e_r_BaustelleMonteure(BAUSTELLE_R: Integer): TStringList;
var
  n: Integer;
  MemoField: TStringList;
  MonteurSubs: string;
  MONTEUR_RID: Integer;
  MonteurPositive: TStringList;
  AlleMonteure: TStringList;
  cBAUSTELLE: TdboCursor;
begin
  if (BAUSTELLE_R <> CacheBaustelleMonteureLastRequestedRID) then
  begin
    if assigned(CacheBaustelleMonteure) then
      freeandnil(CacheBaustelleMonteure);
    cBAUSTELLE := nCursor;
    with cBAUSTELLE do
    begin
      sql.Add('select INFO from BAUSTELLE where RID=' + inttostr(BAUSTELLE_R));
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
      CacheBaustelleMonteureLastRequestedRID := BAUSTELLE_R;

      // Runde 1: erst die beliebten
      AlleMonteure := e_r_MonteureCache;
      for n := 0 to pred(AlleMonteure.count) do
        if (MonteurPositive.indexof(AlleMonteure[n]) <> -1) then
          CacheBaustelleMonteure.addobject(AlleMonteure[n], AlleMonteure.Objects[n]);
      CacheBaustelleMonteure.addobject(cMonteurTrenner, nil);

      // Runde 2: nun die freien
      for n := 0 to pred(AlleMonteure.count) do
        if (MonteurPositive.indexof(AlleMonteure[n]) = -1) then
          CacheBaustelleMonteure.addobject(AlleMonteure[n], AlleMonteure.Objects[n]);
      MonteurPositive.free;

    end;
    cBAUSTELLE.free;
  end;
  result := CacheBaustelleMonteure;
end;

const
 _e_r_BaustelleEinstellungen_RID : TDOM_Reference = cRID_unset;
 _e_r_BaustelleEinstellungen : TStringList = nil;

function e_r_BaustelleEinstellungen(BAUSTELLE_R: TDOM_Reference): TStringList; // NOT NOT FREE!!!
begin
  if (BAUSTELLE_R<>_e_r_BaustelleEinstellungen_RID) then
  begin
    if assigned(_e_r_BaustelleEinstellungen) then
     _e_r_BaustelleEinstellungen.Free;
    _e_r_BaustelleEinstellungen :=
     e_r_sqlt('select EXPORT_EINSTELLUNGEN from BAUSTELLE where RID=' + inttostr(BAUSTELLE_R));
    _e_r_BaustelleEinstellungen_RID := BAUSTELLE_R;
  end;
  result := _e_r_BaustelleEinstellungen;
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
        Sperre.Add(FieldByName('VON').AsDateTime, FieldByName('BIS').AsDateTime, false, cSperreAusfuehren,
          cPrio_BaustellenSperre);

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

function e_r_RegelTerminAnzahl_V(BAUSTELLE_R: Integer): Integer;
var
  FoundIndex: Integer;
begin
  EnsureCache_Baustelle;
  FoundIndex := CacheBaustelle.indexof(inttostr(BAUSTELLE_R));
  if (FoundIndex <> -1) then
    result := strtoint(TStringList(CacheBaustelle.Objects[FoundIndex])[CacheBaustelle_LAST_V])
  else
    result := -1;
end;

function e_r_RegelTerminAnzahl_N(BAUSTELLE_R: Integer): Integer;
var
  FoundIndex: Integer;
begin
  EnsureCache_Baustelle;
  FoundIndex := CacheBaustelle.indexof(inttostr(BAUSTELLE_R));
  if (FoundIndex <> -1) then
    result := strtoint(TStringList(CacheBaustelle.Objects[FoundIndex])[CacheBaustelle_LAST_N])
  else
    result := -1;
end;

function e_r_RegelTerminAnzahl_VN(BAUSTELLE_R: Integer): Integer;
begin
  result :=
   e_r_RegelTerminAnzahl_V(BAUSTELLE_R) +
   e_r_RegelTerminAnzahl_N(BAUSTELLE_R);
end;

const
  _c2_Ortsteil: string = '';
  _c2_BAUSTELLE_R: Integer = 0;
  _c2_Code: string = '';

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
        AlleOrte := TStringList(CacheBaustelle.Objects[FoundIndex])[CacheBaustelle_ORTE];
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
          _c2_Code := copy(nextp(CacheBaustelleOrtsteile[FoundIndex], '=', 1) + '--', 1, cSTRASSE_OrtsteilcodeLength);
          result := _c2_Code;
        end
        else
        begin
          // Neues Ortsteil?
          result := fill('?', cSTRASSE_OrtsteilcodeLength);
        end;
      end;
    until yet;
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
    if (TStringList(CacheBaustelle.Objects[FoundIndex])[CacheBaustelle_PROTOKOLLEXPORT] = 'Y') then
    begin
      cBAUSTELLE := nCursor;
      with cBAUSTELLE do
      begin
        sql.Add('select PROTOKOLLFELDER from BAUSTELLE where RID=' + inttostr(BAUSTELLE_R));
        dblog(sql);
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

function e_r_EinzelAufwand(BAUSTELLE_R: Integer): TAnfixTime;
var
  FoundIndex: Integer;
begin
  //
  if (BAUSTELLE_R <> CacheBaustelleAufwand) then
  begin
    EnsureCache_Baustelle;

    FoundIndex := CacheBaustelle.indexof(inttostr(BAUSTELLE_R));
    if (FoundIndex <> -1) then
     CacheBaustelleAufwandValue := StrToIntDef(TStringList(CacheBaustelle.Objects[FoundIndex])[CacheBaustelle_EINZEL_AUFWAND],0)
    else
     CacheBaustelleAufwandValue := 0;

    // cache
    CacheBaustelleAufwand := BAUSTELLE_R;
  end;
  result := CacheBaustelleAufwandValue;
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

    until yet;
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
    if (TStringList(CacheBaustelle.Objects[FoundIndex])[CacheBaustelle_PROTOKOLLEXPORT] = cC_True) then
    begin
      cBAUSTELLE := nCursor;
      with cBAUSTELLE do
      begin
        sql.Add('select INTERNFELDER from BAUSTELLE where RID=' + inttostr(BAUSTELLE_R));
        dblog(sql);
        ApiFirst;
        e_r_sqlt(FieldByName('INTERNFELDER'), FelderListe);
      end;
      cBAUSTELLE.free;
      for n := pred(FelderListe.count) downto 0 do
      begin
        FelderListe[n] := cutblank(nextp(FelderListe[n], ' ', 0));
        if (FelderListe[n] = '') then
          FelderListe.Delete(n);
      end;
    end;
  end;
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
  ZEIT_VON, ZEIT_BIS: String;
  _ZEIT_VON, _ZEIT_BIS: String;

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

      until yet;

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
      dblog('select * from AUFTRAG where RID='+IntToStr(AUFTRAG_R));
      ApiFirst;

      if eof then
      begin
        for n := 0 to pred(twh_Leer) do
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

        { [2] twh_Monteur }
        if not(FieldByName('MONTEUR1_R').IsNull) then
        begin
          _Monteur := e_r_MonteurKuerzel(FieldByName('MONTEUR1_R').AsInteger);
          if not(FieldByName('MONTEUR2_R').IsNull) then
            _Monteur := _Monteur + c2Monteure + e_r_MonteurKuerzel(FieldByName('MONTEUR2_R').AsInteger);
          result.Add(_Monteur);
        end
        else
        begin
          result.Add('');
        end;

        { [3] twh_MonteurInfo }
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
        { [12] twh_Zeit }
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
        { [21] twh_MonteurText }
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
        { [22] twh_ZeitText }
        repeat
          if result[twh_Zeit] = cVormittagsChar then
          begin
            result.Add('vormittags');
            break;
          end;
          if result[twh_Zeit] = cNachmittagsChar then
          begin
            result.Add('nachmittags');
            break;
          end;
          result.Add('?');
          break;
        until yet;
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
        { [68] twh_Status3 }
        result.Add(vStatus(FieldByName('STATUS_BISHER').AsInteger));
        { [69] twh_ZeitraumKurz }
        result.Add(long2date5(DateTime2Long(FieldByName('ZEITRAUM_VON').AsDateTime)) + '..' +
          long2date5(DateTime2Long(FieldByName('ZEITRAUM_BIS').AsDateTime)));
        { [70] twh_Zaehlwerke_Ausbau }
        result.Add(FieldByName('ZAEHLWERKE_AUSBAU').AsString);
        { [71] twh_Zaehlwerke_Einbau }
        result.Add(FieldByName('ZAEHLWERKE_EINBAU').AsString);
        { [72] twh_Zeit_Von }
        ZEIT_VON := FieldByName('ZEIT_VON').AsString;
        repeat
          if (result[twh_Zeit]=cVormittagsChar) then
          begin
            _ZEIT_VON := e_r_BaustelleVormittagsVon(BAUSTELLE_R);
            break;
          end;
          if (result[twh_Zeit]=cNachmittagsChar) then
          begin
            _ZEIT_VON := e_r_BaustelleNachmittagsVon(BAUSTELLE_R);
            break;
          end;
          _ZEIT_VON := '';
        until yet;
        if (ZEIT_VON='') then
         result.Add(_ZEIT_VON)
        else
         result.Add(ZEIT_VON);
        { [73] twh_Zeit_Bis }
        ZEIT_BIS := FieldByName('ZEIT_BIS').AsString;
        repeat
          if (result[twh_Zeit]=cVormittagsChar) then
          begin
            _ZEIT_BIS := e_r_BaustelleVormittagsBis(BAUSTELLE_R);
            break;
          end;
          if (result[twh_Zeit]=cNachmittagsChar) then
          begin
            _ZEIT_BIS := e_r_BaustelleNachmittagsBis(BAUSTELLE_R);
            break;
          end;
          _ZEIT_BIS := '';
        until yet;
        if (ZEIT_BIS='') then
         result.Add(_ZEIT_BIS)
        else
         result.Add(ZEIT_BIS);
        { [74] twh_Zeitfenster }
        repeat
          if (ZEIT_VON='') and (ZEIT_BIS='') then
          begin
            result.Add('');
            break;
          end;
          if (ZEIT_VON='') then
            ZEIT_VON := _ZEIT_VON;
          if (ZEIT_BIS='') then
            ZEIT_BIS := _ZEIT_BIS;
          if (ZEIT_VON<>_ZEIT_VON) or (ZEIT_BIS<>_ZEIT_BIS) then
          begin
           result.Add(
             {} 'zw. ' +
             {} ShortenTime(ZEIT_VON) + '-' +
             {} ShortenTime(ZEIT_BIS) +
             {} ' Uhr');
           break;
          end;
          result.Add('');
        until yet;

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

      until yet;
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

        until yet;
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

function e_r_Baustelle(MONTEUR_R: Integer; MOMENT: TDateTime; var Wertigkeit: TeWertigkeitBaustellenzuordnung): Integer;
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
      EchteEinplanungAndererHalbtag := e_r_Baustelle_Einsatz.CheckEm(e_r_AndererHalbtag(MOMENT), MONTEUR_R);

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

        until yet;
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

  until yet;

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
        EchteEinplanungAndererHalbtag := e_r_Baustelle_Einsatz.CheckEm(e_r_AndererHalbtag(DATUM), MONTEUR_R);
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

    until yet;
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
          until yet;

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
    _ObtainZeitFromRID_LastRID := -1;
    SetLength(e_r_PlanungsEndeDatum, 0);
  end;
end;

procedure InvalidateCache_Auftrag;
begin
  if assigned(e_r_AuftragItems_LastRequestedSub) then
    freeandnil(e_r_AuftragItems_LastRequestedSub);
  e_r_AuftragItems_LastRequestedRID := -1;
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
 {NIU}   addCol(cE_FTPHOST);
    addCol(cE_FTPUSER);
 {NIU}   addCol(cE_FTPPASSWORD); // wird nicht mehr ausgewertet
 {NIU}    addCol(cE_FTPVerzeichnis); // wird nicht mehr ausgewertet
    addCol(cE_ZIPPASSWORD);
    addCol(cE_FotoBenennung);
    addCol('BAUSTELLE_KUERZEL');
  end;

  with cBAUSTELLE do
  begin
    sql.Add('select NUMMERN_PREFIX,EXPORT_EINSTELLUNGEN from BAUSTELLE');
    sql.Add('where EXPORT_MONDA=' + cC_True_AsString);
    dblog(sql);
    ApiFirst;
    while not(eof) do
    begin
      Row := TStringList.create;
      e_r_sqlt(FieldByName('EXPORT_EINSTELLUNGEN'), EXPORT_EINSTELLUNGEN);
      with Row do
      begin
        Add(FieldByName('NUMMERN_PREFIX').AsString); // wird später gekürzt
 {NIU}  Add(e_r_ParameterFoto(EXPORT_EINSTELLUNGEN, cE_FTPHOST));
        Add(e_r_ParameterFoto(EXPORT_EINSTELLUNGEN, cE_FTPUSER));
 {NIU}  Add(enCrypt_Hex(e_r_ParameterFoto(EXPORT_EINSTELLUNGEN, cE_FTPPASSWORD)));
 {NIU}  Add(e_r_ParameterFoto(EXPORT_EINSTELLUNGEN, cE_FTPVerzeichnis));
        Add(enCrypt_Hex(e_r_ParameterFoto(EXPORT_EINSTELLUNGEN, cE_ZIPPASSWORD)));
        Add(EXPORT_EINSTELLUNGEN.values[cE_FotoBenennung]);
        Add(FieldByName('NUMMERN_PREFIX').AsString); // bleibt in der vollen Länge
      end;
      tBAUSTELLE.addRow(Row);
      ApiNext;
    end;
    tBAUSTELLE.SaveToFile(MdePath + cFotoService_BaustelleFName);
  end;

  tBAUSTELLE.free;
  cBAUSTELLE.free;
  EXPORT_EINSTELLUNGEN.free;
end;

procedure e_r_Sync_AuftraegeAlle;
var
  RIDs: TgpIntegerList;
  n: Integer;
  settings: TStringList;
  pFotoBenennung: string;
begin
  // erste unscharfe Liste aller betroffenen Baustellen
  RIDs := e_r_sqlm(
    { } 'select RID from BAUSTELLE where ' +
    { } ' (EXPORT_EINSTELLUNGEN containing ''' + cE_FotoBenennung + '=6'') or ' +
    { } ' (EXPORT_EINSTELLUNGEN containing ''' + cE_FotoBenennung + '=' + cIni_Activate + ''') ' +
    { } 'order by' +
    { } ' NUMMERN_PREFIX');

  for n := 0 to pred(RIDs.count) do
  begin
    settings := e_r_BaustelleEinstellungen(RIDs[n]);

    // nur bei einer echten, nicht deaktivierten Baustelle
    pFotoBenennung := settings.values[cE_FotoBenennung];
    if (pFotoBenennung = '6') or (pFotoBenennung = cIni_Activate) then
      e_r_Sync_Auftraege(RIDs[n]);

  end;
  RIDs.free;
end;

procedure e_r_Sync_Auftraege(BAUSTELLE_R: Integer; WithUpload: boolean = true);
var
  RIDs: TgpIntegerList;
  SETTINGS: TStringList;
  pFotoBenennung: String;
  AllOutData: TStringList;
  OneLine, OneValue, OneSetting: string;
  n, k, col_index, row_index: Integer;
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
  Benennung, BenennungParameterName, FieldName: string;
  c: char;
  iFotoBenennung: TStringList;
  FotoBenennung_Header: TStringList;
  AllColumns: TStringList;
  UsedColumns: TgpIntegerList;
  TableRow: TStringList;
  CSV: TsTable;

  // Für Excel
  xTable: TList;
  xSubs: TStringList;
  xOneLine: string;
  xOptions: TStringList;
  xFName, xPath: string;

  ErrorOnGenerate: boolean;

  // Für den Upload
  FTP: TSolidFTP;
  FTP_LocalFiles : TStringList;
  FTP_RemoteFiles : TStringList;

  procedure xNewLine;
  begin
    xSubs := TStringList.create;
    xTable.Add(xSubs);
  end;

  procedure add_ProtokollItems(s: TStringList);
  var
   ProtokollStr: String;
   PROTOKOLL: TStringList;
   n: Integer;
  begin
    PROTOKOLL := TStringList.Create;
    ProtokollStr := SubItems[twh_Protokoll];
    while (ProtokollStr <> '') do
      PROTOKOLL.Add(nextp(ProtokollStr, cProtokollTrenner));
    for n := 0 to pred(ProtokollFelder.count) do
      s.Add(csvCheck(KommaCheck(Protokoll.values[ProtokollFelder[n]])));
  end;

  procedure add_InternItems(s : TStringList);
  var
   n : Integer;
  begin
    if (InternFelder.count > 0) then
    begin
      INTERN_INFO := e_r_sqlt('select INTERN_INFO from AUFTRAG where RID=' + inttostr(AUFTRAG_R));
      for n := 0 to pred(InternFelder.count) do
        s.Add(csvCheck(KommaCheck(INTERN_INFO.values[InternFelder[n]])));
      INTERN_INFO.free;
    end;
  end;

  procedure FB_AddHeader(FieldName:String);
  begin
    if (FotoBenennung_Header.Indexof(FieldName)=-1) then
    begin
      if (AllColumns.IndexOf(FieldName)=-1) then
        AppendStringsToFile(
          {} 'e_r_Sync_Auftraege: '+
          {} BenennungParameterName+': '+
          {} FieldName +' ist unbekannt',
          {} ErrorFName('e_r_Sync_Auftraege'),Uhr8)
      else
        FotoBenennung_Header.Add(FieldName);
    end;
  end;

begin

  SETTINGS := e_r_BaustelleEinstellungen(BAUSTELLE_R);

  //
  RIDs := e_r_sqlm(
    { } 'select RID from AUFTRAG where' +
    { } ' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') and' +
    { } ' (STATUS<>6) ' +
    { } 'order by ' +
    { } ' STRASSE,NUMMER');

  // init
  ProtokollFelder := TStringList.create;
  InternFelder := TStringList.create;
  e_r_ProtokollExport(BAUSTELLE_R, ProtokollFelder);
  e_r_InternExport(BAUSTELLE_R, InternFelder);

  // Output Path
  Baustelle := e_r_BaustelleKuerzel(BAUSTELLE_R);
  xPath := AuftragMobilServerPath + Baustelle + '\';
  CheckCreateDir(xPath);

  pFotoBenennung := SETTINGS.values[cE_FotoBenennung];

  if (pFotoBenennung=cIni_Activate) then
  begin

    // init
    iFotoBenennung := TStringList.Create;
    OneValue := SETTINGS.Values[cE_ZielBaustelle];
    if (OneValue<>'') then
     iFotoBenennung.Add(cE_Zielbaustelle+'='+OneValue);

    FotoBenennung_Header := TStringList.Create;
    // Pflichtfelder
    FotoBenennung_Header.Add(cRID_Suchspalte);

    // wichtige Felder, die wir brauchen wenn definiert
    if (InternFelder.IndexOf(cE_Zielbaustelle)<>-1) then
     FotoBenennung_Header.Add(cE_Zielbaustelle);

    AllColumns := split(cWordHeaderLine0);
    with AllColumns do
    begin
     AddStrings(Protokollfelder);
     AddStrings(InternFelder);
    end;
    if DebugMode then
     iFotoBenennung.Add('Header='+HugeSingleLine(AllColumns,';'));

    // calculate used Fields
    for c := 'A' to 'Z' do
    begin

     // Zielbaustelle
     OneSetting := 'F'+c+'-'+cE_Zielbaustelle;
     OneValue := SETTINGS.Values[OneSetting];
     if (OneValue<>'') then
       iFotoBenennung.add(OneSetting+'='+OneValue);

     // Benennung
     BenennungParameterName := 'F'+c+'-Benennung';
     Benennung := SETTINGS.Values[BenennungParameterName];
     if (Benennung<>'') then
      iFotoBenennung.add(BenennungParameterName+'='+Benennung)
     else
      Benennung := TOrgaMonApp.Fx_default('F'+c);

      // prüfe, ob es alle Felder gibt, und nehme Sie hinzu
      repeat
        k := pos('~',Benennung);
        if (k=0) then
         break;
        Benennung := copy(Benennung, succ(k), MaxInt);
        k := pos('~',Benennung);
        if (k=0) then
         break;
        FieldName := copy(Benennung,1,pred(k));
        Benennung := copy(Benennung, succ(k), MaxInt);

        repeat

          // "symbolische" Spalten erfordern keine Entsprechung
          if (FieldName='#') then
            break;

          // "berechnete" Spalten implizieren andere Spalten
          if (FieldName='TTMMJJJJ') or (FieldName='JJJJMMTT') or (FieldName='TT.MM.JJJJ') then
          begin
            FB_addHeader('Datum');
            FB_addHeader('WechselDatum');
            break;
          end;

          // nehme die Spalte 1:1 auf
          FB_addHeader(FieldName);

        until yet;

      until eternity;
    end;

    // create the table
    CSV := TsTable.create;
    with CSV do
    begin

      UsedColumns := TgpIntegerList.create;
      for col_index := 0 to pred(FotoBenennung_Header.Count) do
      begin
        // create Mapping to Fullsize Table
        UsedColumns.Add(AllColumns.IndexOf(FotoBenennung_Header[col_index]));
        // Create New Column
        addCol(FotoBenennung_Header[col_index]);
      end;

      // Rows
      for n := 0 to pred(RIDs.count) do
      begin
        AUFTRAG_R := RIDs[n];

        // Build Full Data
        SubItems := e_r_AuftragItems(AUFTRAG_R);
        add_ProtokollItems(SubItems);
        add_InternItems(SubItems{,AUFTRAG_R});

        TableRow := TStringList.Create;
        for col_index := 0 to pred(UsedColumns.Count) do
         TableRow.add(SubItems[UsedColumns[col_index]]);
        addRow(TableRow);

        if DebugMode then
          iFotoBenennung.Add(IntToStr(n)+'='+HugeSingleLine(SubItems,';'));
      end;
      SaveToFile(xPath + cE_FotoBenennung + '-' + Baustelle + '.csv');
    end;
    CSV.Free;
    UsedColumns.free;

    // save
    iFotoBenennung.SaveToFile(xPath + cE_FotoParameter + '-' + Baustelle + '.ini' );

    AllColumns.free;
    FotoBenennung_Header.Free;
    iFotoBenennung.Free;
  end else
  begin

    // init
    xTable := TList.create;
    xOptions := TStringList.create;
    Protokoll := TStringList.create;
    ProtokollOut := TStringList.create;
    AllOutData := TStringList.create;

    // Kopf Zeile für Excel
    xNewLine;
    xOneLine := cWordHeaderLine;
    while (xOneLine <> '') do
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
      Add('cWechselMoment=DATETIME');
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
      Add('Zeit_Von=TIME');
      Add('Zeit_Bis=TIME');
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

    xFName := xPath + Baustelle + cSpreadSheetExtension;

    if FileExists(xPath + 'Vorlage' + cSpreadSheetExtension) then
    begin
      repeat
        ErrorOnGenerate := true;

        // Speichern als Spredsheet
        ExcelExport(xFName, xTable, nil, xOptions);

        //
        BeginOc;

        // Konvertieren mit einer Vorlage
        if not(doConversion(Content_Mode_xls2xls, xFName)) then
          break;

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
      until yet;

      EndOc;

    end
    else
    begin
      // Alte Excel Datei löschen
      FileDelete(xFName);
      // Speichern direkt als .csv
      AllOutData.SaveToFile(xPath + cE_FotoBenennung + '-' + Baustelle + '.csv');
    end;

    freeandnil(AllOutData);
    freeandnil(ProtokollOut);
    freeandnil(Protokoll);
    freeandnil(xTable);
    freeandnil(xOptions);
    freeandnil(InternOut);
  end;

  freeandnil(InternFelder);
  freeandnil(ProtokollFelder);
  freeandnil(RIDs);

  FTP_LocalFiles := TStringList.create;
  FTP_RemoteFiles := TStringList.create;

  xFName := cE_FotoParameter + '-' + Baustelle + '.ini';
  if FileExists(xPath+xFName) then
  begin

    FTP_LocalFiles.Add(xPath + xFName);
    FTP_RemoteFiles.Add(xFName);

    if not(FileCompare(
      { } xPath + xFName,
      { } xPath + cE_FotoParameter + '.ini')) then
      FileVersionedCopy(
        { } xPath + xFName,
        { } xPath + cE_FotoParameter + '.ini');
  end;

  xFName := cE_FotoBenennung + '-' + Baustelle + '.csv';
  if FileExists(xPath+xFName) then
  begin

    FTP_LocalFiles.Add(xPath + xFName);
    FTP_RemoteFiles.Add(xFName);

    if not(FileCompare(
      { } xPath + xFName,
      { } xPath + cE_FotoBenennung + '.csv')) then
      FileVersionedCopy(
        { } xPath + xFName,
        { } xPath + cE_FotoBenennung + '.csv');

  end;

 if WithUpload then
 begin
   // Datei hochladen
   FTP := TSolidFTP.Create;
   with FTP do
   begin
     Host := nextp(iMobilFTP, ';', 0);
     UserName := nextp(iMobilFTP, ';', 1);
     Password := nextp(iMobilFTP, ';', 2);
     BeginTransaction;
     for n := 0 to pred(min(FTP_LocalFiles.Count,FTP_RemoteFiles.Count)) do
       Put(FTP_LocalFiles[n], '', FTP_RemoteFiles[n]);
     EndTransaction;
     try
       Disconnect;
     except
     end;
   end;
   try
     FTP.free;
   except
   end;
 end;

 FTP_LocalFiles.Free;
 FTP_RemoteFiles.Free;

end;

function AktiveBaustellenFName: string;
begin
  result := SearchDir + 'AktiveBaustellen.txt';
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
    sql.Add('select');
    sql.Add(' distinct BAUSTELLE_R');
    sql.Add('from');
    sql.Add(' AUFTRAG');
    sql.Add('where');
    sql.Add(' (STATUS<>'+IntToStr(cs_Historisch)+')');
    ApiFirst;
    RIDs := '';
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
      sql.Add('select NUMMERN_PREFIX from BAUSTELLE where RID in (' + RIDs + ') order by NUMMERN_PREFIX');
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

function e_r_AktiveBaustellen: TStringList;
begin
  result := TStringList.create;
  if not(FileExists(AktiveBaustellenFName)) then
    ReCreateAktiveBaustellen;
  result.LoadFromFile(AktiveBaustellenFName);
end;

procedure e_w_unlocate(POSTLEITZAHL_R: Integer);
begin
  if (POSTLEITZAHL_R >= cRID_FirstValid) and (dummyPLZ_R <> POSTLEITZAHL_R) then
  begin
    e_x_sql('update auftrag set ' + ' POSTLEITZAHL_R = NULL ' + 'where POSTLEITZAHL_R =' + inttostr(POSTLEITZAHL_R));

    e_x_sql('update ablage set ' + ' POSTLEITZAHL_R = NULL ' + 'where POSTLEITZAHL_R =' + inttostr(POSTLEITZAHL_R));

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
        e_x_sql('update auftrag set ' + ' POSTLEITZAHL_R = NULL ' + 'where POSTLEITZAHL_R =' + inttostr(lRID[n]));

        e_x_sql('update ablage set ' + ' POSTLEITZAHL_R = NULL ' + 'where POSTLEITZAHL_R =' + inttostr(lRID[n]));

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
    e_x_sql('update ARBEITSZEIT set BELEG_R=' + inttostr(BELEG_R) + ' ' + ' where RID=' + inttostr(ARBEITSZEIT_R[n]));
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
        result := e_r_sqld(
        {} 'select PREIS from POSTEN where ' +
        {} ' (BELEG_R=' + FieldByName('BELEG_R').AsString + ') and ' +
        {} ' (ARTIKEL_R=' + FieldByName('ARTIKEL_R').AsString + ')')
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
      StundenSaetze.values[_Stundensatz] := inttostr(strtointdef(StundenSaetze.values[_Stundensatz], 0) +
        _SingleArbeitszeit);

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
        DatensammlerLokal.Add('ZEIT=' + 'Kostenstelle' + #160 + sKostenstellen[n] + #160#160#160 +
          secondstostr(Sekunden));
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
      DatensammlerLokal.Add('ZEIT=' + 'voraussichtlich' + #160 + secondstostr(Sekunden));
      LohnSumme := LohnSumme + Lohn;
      DatensammlerLokal.Add('LOHN=' + 'voraussichtlich' + #160 + format('%m', [Lohn]));

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
      { } cPersonPath(PERSON_R) +
      { } cHTMLTemplatesDir + cHTML_ArbeitszeitFName;
      if FileExists(InFName) then
        break;

      InFName := MyProgramPath + cHTMLTemplatesDir + cHTML_ArbeitszeitFName;
    until yet;

    if FileExists(InFName) then
    begin
      Bericht := THTMLTemplate.create;
      with Bericht do
      begin
        LoadFromFile(InFName);
        // CanUseQuick := true;
        WriteValue(DatensammlerLokal, DatensammlerGlobal);
        SortPages;
        OutPath := cPersonPath(PERSON_R);
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
      TITEL := TITEL + ' (' + long2dateLocalized(pDateFrom) + ' .. ' + long2dateLocalized(pDateTo) + ')';
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
      dblog(sql);
      ApiFirst;
    end;

    // Anschriftsdaten
    with cANSCHRIFT do
    begin
      sql.Add('select * from ANSCHRIFT where RID=' + inttostr(cPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsInteger));
      dblog(sql);
      ApiFirst;
    end;

    // Anschrift extrahieren!
    DatensammlerGlobal.Add('Titel=' + 'Arbeitszeit');
    DatensammlerGlobal.Add('MehrInfo=' + cOrgaMonCopyright);
    DatensammlerGlobal.Add('AktuellesDatum=' + DatumLocalized);
    DatensammlerGlobal.Add('AktuelleUhrzeit=' + Uhr);

    e_r_Anschrift(PERSON_R, DatensammlerGlobal);

    // weitere Globale Felder:
    DatensammlerGlobal.Add('Geburtstag=' + long2dateLocalized(cPERSON.FieldByName('GEBURTSTAG').AsDateTime));
    DatensammlerGlobal.Add('Versicherungsnummer=' + cPERSON.FieldByName('VERSICHERUNGSNUMMER').AsString);

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
        sql.Add(' (ARBEITSZEIT.DATUM between ''' + Long2date(pDateFrom) + ''' and ''' + Long2date(pDateTo) + ''') and');
      end
      else
      begin
        if DateOK(iBuchFokus) then
          sql.add(' (ARBEITSZEIT.DATUM >= ''' + long2date(iBuchFokus) + ''') and')
        else
          sql.Add(' (ARBEITSZEIT.DATUM is not null) and');
      end;

      if (pBUDGET >= cRID_FirstValid) then
      begin
        sql.Add(' (ARBEITSZEIT.BUGET_R=' + inttostr(pBUDGET) + ') and');
      end;

      repeat

        // leer (=default) "unabgerechnetes"
        if (pBeleg = '') then
        begin
          sql.Add(' (ARBEITSZEIT.BELEG_R IS NULL) and');
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

      until yet;


      sql.Add(' (ARBEITSZEIT.ZEIT_V is not null) and');
      sql.Add(' (ARBEITSZEIT.ZEIT_N is not null) and');
      sql.Add(' (BUGET.PERSON_R=' + inttostr(PERSON_R) + ') and');
      sql.Add(' (BUGET.ARTIKEL_R is not null)');

      sql.Add('order by');
      sql.Add(' ARBEITSZEIT.BUGET_R, ARBEITSZEIT.DATUM, ARBEITSZEIT.ZEIT_V');
      dblog(sql);
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
      AppendStringsToFile(E.Message,ErrorFName('e_w_BudgetEinfuegen'),Uhr8);
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
      sql.Add('SELECT ALIAS_R FROM PREIS WHERE (VERLAG_R=' + inttostr(VERLAG_R) + ') and (ALIAS_R is not null)');
      First;
      if eof then
        break;
      Visited_Verlag_R.Add(inttostr(VERLAG_R));
      VERLAG_R := FieldByName('ALIAS_R').AsInteger;
      // loop detection
      if (Visited_Verlag_R.indexof(inttostr(VERLAG_R)) <> -1) then
        break;
    until eternity;
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

function e_r_BearbeiterEinstellungen(BEARBEITER_R: Integer): TStringList;
begin
  result := e_r_sqlt('select STATUS from BEARBEITER where RID=' + inttostr(BEARBEITER_R));
end;

function e_w_BaustelleLoeschen(BAUSTELLE_R: Integer): boolean;
begin
  result := false;
  try
    // Bei allen Daten die KOPIE_R Referenz zerstören
    e_x_sql(
      { } 'update AUFTRAG set KOPIE_R=null where' +
      { } ' (KOPIE_R in ' +
      { } ' (select RID from AUFTRAG where (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ')))');

    // Bei allen Daten die MASTER_R Referenz zerstören
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
      AppendStringsToFile('e_w_BaustelleLoeschen: ' + E.Message,
        {} ErrorFName('AUFTRAG'),
        {} Uhr8);
    end;

  end;
end;

function e_w_BaustelleKopie(BAUSTELLE_R: Integer): boolean;
var
  QUELLE_R: Integer; // BAUSTELLE.RID der Quellbaustelle

  qZIEL: TdboQuery;
  cQUELLE: TdboCursor;

  settings: TStringList;
  AUFTRAG_R, EXPORT_TAN: Integer;
  n: Integer;
  OldIndex: Integer;

  // gesicherte bisherige Daten
  cZIEL: TdboCursor;
  lKOPIE_RIDs: TgpIntegerList; // die RIDs, damit nicht immer wieder und wieder neue
                               // RIDs verbraucht werden
  lKOPIE_EXPORT_TANs: TgpIntegerList; // die EXPORT_TANS, darum geht es ja
  lKOPIE_Rs: TgpIntegerList; // die Referenz auf die Quell-RIDs

begin
  result := false;
  try
    settings := e_r_BaustelleEinstellungen(BAUSTELLE_R);
    QUELLE_R := e_r_BaustelleRIDFromKuerzel(settings.values[cE_KopieVon]);

    if (QUELLE_R >= cRID_FirstValid) then
    begin

      lKOPIE_RIDs := TgpIntegerList.create;
      lKOPIE_EXPORT_TANs := TgpIntegerList.create;
      lKOPIE_Rs := TgpIntegerList.create;
      cZIEL := nCursor;
      qZIEL := nQuery;
      cQUELLE := nCursor;
      repeat
        // alte Daten aus der Kopiebaustelle sichern
        with cZIEL do
        begin
          sql.Add('select RID, KOPIE_R, EXPORT_TAN from AUFTRAG where');
          sql.Add('(BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') and');
          sql.Add('(MASTER_R=RID)');
          ApiFirst;
          while not(eof) do
          begin
            if not(FieldByName('KOPIE_R').IsNull) then
            begin
             lKOPIE_RIDs.Add(FieldByName('RID').AsInteger);
             lKOPIE_Rs.Add(FieldByName('KOPIE_R').AsInteger);
             if FieldByName('EXPORT_TAN').IsNull then
               EXPORT_TAN := cRID_Null
             else
               EXPORT_TAN := FieldByName('EXPORT_TAN').AsInteger;
             lKOPIE_EXPORT_TANs.Add(EXPORT_TAN);
            end;
            ApiNext;
          end;
        end;

        // Kopiebaustelle löschen
        if not e_w_BaustelleLoeschen(BAUSTELLE_R) then
          break;

        // Kopiebaustelle aus Originalbaustelle befüllen
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
          e_w_Baustelle_add_SQL_Filter(Settings,sql);
          sql.Add('(MASTER_R=RID)');
          dbLog(sql);
          ApiFirst;
          while not(eof) do
          begin
            //
            AUFTRAG_R := FieldByName('RID').AsInteger;
            OldIndex := lKOPIE_Rs.indexof(AUFTRAG_R);

            qZIEL.insert;
            // Alle Felder kopieren!
            for n := 0 to pred(FieldCount) do
              if not(Fields[n].IsNull) then
                qZIEL.FieldByName(Fields[n].FieldName).assign(Fields[n])
              else
                qZIEL.FieldByName(Fields[n].FieldName).clear;

            // a) Baustelle ist anders
            qZIEL.FieldByName('BAUSTELLE_R').AsInteger := BAUSTELLE_R;

            // b) Original-Auftrag RID (Quell-RID) sichern
            qZIEL.FieldByName('KOPIE_R').AsInteger := AUFTRAG_R;

            // c) Kopie soll Aufwandsneutral sein
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
              // ist neu für die Zielbaustelle, wurde also bisher
              // nie gemeldet
              qZIEL.FieldByName('RID').AsInteger := cRID_AutoInc;
              qZIEL.FieldByName('MASTER_R').clear;
              qZIEL.FieldByName('EXPORT_TAN').clear;
            end;
            qZIEL.post;

            ApiNext;
          end;
          close;
        end;
        result := true;
      until yet;

      cQUELLE.free;
      cZIEL.free;
      qZIEL.free;
      lKOPIE_RIDs.free;
      lKOPIE_EXPORT_TANs.free;
      lKOPIE_Rs.free;
    end;
  except
    on E: Exception do
    begin
      AppendStringsToFile('e_w_Baustellekopie: ' + E.Message,
        {} ErrorFName('AUFTRAG'),
        {} Uhr8);
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
      if CharInSet(s[k - 1], ['0' .. '9']) then
        if CharInSet(s[k + 1], ['0' .. '9']) then
          result[k] := ',';
    end;

end;

function csvCheck(const s: string): string;
begin
  result := s;
  ersetze('"', '''''', result);
  ersetze(';', ',', result);
end;

function e_w_BaustelleAblegen(BAUSTELLE_R: Integer): boolean;
var
  RecN: Integer;
  InsertN: Integer;
  DSQL_ABLAGE_Copy: TdboScript;
  DSQL_ABLAGE_Del: TdboScript;
  DSQL_AUFTRAG_Clear: TdboScript;
  cAUFTRAG: TdboCursor;
  n: Integer;
  AUFTRAG_FieldNames: TStringList;
  ABLAGE_R: Integer;

  procedure InsertCol(RID: Integer);
  begin
    with DSQL_ABLAGE_Del do
    begin
      ParamByName('CROSSREF').AsInteger := RID;
      execute;
    end;

    with DSQL_ABLAGE_Copy do
    begin
      ParamByName('CROSSREF').AsInteger := RID;
      execute;
    end;

    inc(InsertN);
  end;

begin
  result := false;

  ABLAGE_R := e_w_GEN('GEN_ZUSAMMENHANG');

  // Quell-Datensätze bestimmen
  cAUFTRAG := nCursor;
  AUFTRAG_FieldNames := TStringList.create;
  with cAUFTRAG do
  begin
    sql.Add('select');
    sql.Add(' *');
    sql.Add('from');
    sql.Add(' AUFTRAG');
    sql.Add('where');
    sql.Add(' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') or ');
    sql.Add(' (MASTER_R in (select RID from AUFTRAG where (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ')))');
    Open;
    // Liste der Feldnamen speichern!
    for n := 0 to pred(FieldCount) do
      AUFTRAG_FieldNames.Add(Fields[n].FieldName);
  end;

  DSQL_ABLAGE_Copy := nScript;
  with DSQL_ABLAGE_Copy do
  begin
    sql.Add('insert into ABLAGE');
    sql.Add('(' + HugeSingleLine(AUFTRAG_FieldNames, ',') + ')');
    sql.Add('SELECT');
    sql.Add(HugeSingleLine(AUFTRAG_FieldNames, ','));
    sql.Add('FROM');
    sql.Add(' AUFTRAG');
    sql.Add('WHERE');
    sql.Add(' RID=:CROSSREF');
    prepare;
  end;

  DSQL_ABLAGE_Del := nScript;
  with DSQL_ABLAGE_Del do
  begin
    sql.Add('DELETE FROM');
    sql.Add(' ABLAGE');
    sql.Add('WHERE');
    sql.Add(' RID=:CROSSREF');
    prepare;
  end;

  DSQL_AUFTRAG_Clear := nScript;
  with DSQL_AUFTRAG_Clear do
  begin
    sql.Add('update');
    sql.Add(' AUFTRAG');
    sql.Add('set');
    sql.Add(' MASTER_R=RID');
    sql.Add('where');
    sql.Add(' MASTER_R is null');
    execute;
  end;

  InsertN := 0;
  RecN := 0;

  with cAUFTRAG do
  begin

    // Zunächst die Masterdatensätze
      APiFirst;
      while not(eof) do
      begin
        if (FieldByName('RID').AsInteger = FieldByName('MASTER_R').AsInteger) then
          InsertCol(FieldByName('RID').AsInteger);
        ApiNext;
        inc(RecN);
      end;

    // Nun die Historischen Datensätze
      APiFirst;
      while not(eof) do
      begin
        if (FieldByName('RID').AsInteger <> FieldByName('MASTER_R').AsInteger) then
          InsertCol(FieldByName('RID').AsInteger);
        ApiNext;
        inc(RecN);
      end;

  end;

  cAUFTRAG.free;
  DSQL_ABLAGE_Copy.free;
  DSQL_ABLAGE_Del.free;
  DSQL_AUFTRAG_Clear.free;
  AUFTRAG_FieldNames.free;

  result := true;
end;

function e_w_ReadMobil(pOptions : TStringList = nil; fb : TFeedBack = nil):boolean;

{$I feedback.inc}

var
  AuftragArray: array of TMDErec;
  ERGEBNIS_TAN: integer;
  MdeRecordCount: integer;
  INf: file of TMDErec; // Ergebnisdaten als mderec
  sTAN: TSearchStringList; // Ergebnisdaten als csv-Datei
  DirList: TStringList;
  Bericht: TStringList;
  Aenderungen: TStringList;
  AUSFUEHREN: TAnfixDate;

  Stat_Meldungen: integer;
  Stat_Aenderungen: integer;
  Stat_FehlendeRIDS: integer;

  ErrorCount: integer;
  StartTime: dword;
  Ergaenzungsmodus: boolean;
  FTP : TSolidFTP;

  // Parameter
  pDownloadTANs: boolean; // was "CheckBox5.Checked"
  pPreserveTANsOnServer: boolean; // was "CheckBox6.Checked"
  pMoveTANsToDiagnose: boolean; // was "CheckBox10.Checked"

  function toDataBaseString(s: string; len: integer): string;
  begin
    result := s;
    ersetze('''', '', result);
    ersetze('"', '', result);
    result := '''' + copy(result, 1, len) + '''';
  end;

  function VNfromTime(t: TAnfixTime): string;
  begin
    if (t <= cNoon) then
      result := cVormittagsChar
    else
      result := cNachmittagsChar;
  end;

  function NeuerAuftrag(var mderec: TMDErec): integer;
  var
    qAUFTRAG: TdboQuery;
    BAUSTELLE_R: integer;
    MONTEUR_R: integer;
    Protokoll: TStringList;
    OneLine: string;
  begin
    result := -1;
    Protokoll := TStringList.create;
    with mderec do
    begin

      repeat

        // Protokoll mal einlesen
        Protokoll.clear;
        OneLine := Oem2ansi(TOrgaMonApp.getTTBT(ProtokollInfo));
        while (OneLine <> '') do
          Protokoll.add(nextp(OneLine, ';'));

        // Überhaupt Daten vorhanden?
        if (Protokoll.Values['BG'] = '') and (ausfuehren_ist_Datum <= 0) then
          break;

        // Vorbelegung der Werte
        if (RID > 0) then
        begin
          BAUSTELLE_R := e_r_sql('select BAUSTELLE_R from AUFTRAG where RID=' + inttostr(RID));
          MONTEUR_R := e_r_sql('select MONTEUR1_R from AUFTRAG where RID=' + inttostr(RID));
        end
        else
        begin
          BAUSTELLE_R := 279; // grrrrrrrrrrrrr - argh -
          MONTEUR_R := e_r_sql('select RID from PERSON where MONDA=''' + Baustelle + '''');
        end;

        // ohne Monteur / Baustelle geht nix!
        if (MONTEUR_R <= 0) or (BAUSTELLE_R <= 0) then
          break;

        if (ausfuehren_ist_Datum <= 0) then
        begin
          ausfuehren_ist_Datum := date2long(nextp(TOrgaMonApp.getTTBT(Monteur_Info), ' - ', 0));
          ausfuehren_ist_uhr := StrToSeconds(nextp(TOrgaMonApp.getTTBT(Monteur_Info), ' - ', 1));
        end;

        if (ausfuehren_ist_Datum <= cMonDa_ImmerAusfuehren) then
        begin
          ausfuehren_ist_Datum := DateGet;
          ausfuehren_ist_uhr := SecondsGet;
        end;

        // eindeutiges Handle erzeugen
        RID := e_w_gen('GEN_AUFTRAG');

        // den Auftrag einfach mal anlegen
        e_x_sql('insert into auftrag (ZAEHLER_NUMMER,KUNDE_STRASSE,KUNDE_ORT,AUSFUEHREN,VORMITTAGS,MONTEUR1_R,BAUSTELLE_R,RID_AT_IMPORT)  values ('
          +

          // aufgenommene Regler Nummer
          toDataBaseString(cutblank(Protokoll.Values['BG']), 15) + ',' +

          // aufgenommene Strasse
          toDataBaseString(cutblank(cutblank(Protokoll.Values['I5']) + ' ' + cutblank(Protokoll.Values['I6']) + ' ' +
          cutblank(Protokoll.Values['I7']) + ' '), 45) + ',' +

          // aufgenommener Ort
          toDataBaseString(cutblank(cutblank(Protokoll.Values['I3']) + ' ' + cutblank(Protokoll.Values['I4'])),
          45) + ',' +

          // Ausführungsdatum
          toDataBaseString(long2date(ausfuehren_ist_Datum), 10) + ',' +

          // Ausführungsuhrzeit
          toDataBaseString(VNfromTime(ausfuehren_ist_uhr), 1) + ',' +

          inttostr(MONTEUR_R) + ',' + inttostr(BAUSTELLE_R) + ',' + inttostr(RID) + ')');

        // den Auftrag durch den Kernel absegnen lassen
        qAUFTRAG := nQuery;
        with qAUFTRAG do
        begin
          sql.add('select * from auftrag where');
          sql.add(' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') and');
          sql.add(' (MONTEUR1_R=' + inttostr(MONTEUR_R) + ') and');
          sql.add(' (RID_AT_IMPORT=' + inttostr(RID) + ')');
          sql.add('for update');
          open;
          first;
          if not(eof) then
          begin
            result := FieldByName('RID').AsInteger;
            edit;
            AuftragBeforePost(qAUFTRAG);
            post;
          end;
        end;
        qAUFTRAG.free;

      until true;
    end;
    Protokoll.free;
  end;

  procedure ProcessNewData(pPath: string; pTAN: string);
  var
    qAUFTRAG: TdboQuery;

    // gecachte Datenbankfelder
    ERGEBNIS_INFO: TStringList;
    Protokoll: TStringList;
    V, V_Neu: TStringList;
    V_OldCount: integer;
    STATUS: integer;
    VMITTAGS: string;

    Stat_Wert_Ueberschreibungen: integer;
    Stat_Wert_Beitrag: integer;
    Stat_Changes: string;

    procedure updateField(sFieldName: string; NewValue: string);
    var
      OldValue: string;
    begin
      OldValue := qAUFTRAG.FieldByName(sFieldName).AsString;
      repeat

        // keine Wertänderung
        if (OldValue = NewValue) then
        begin
          // keine weitere Aktion notwendig!!
          break;
        end;

        // etwas soll durch nichts ersetzt werden -> nicht möglich
        if (NewValue = '') and (OldValue <> '') then
        begin
          // Eine Löschung der Eintragung wird nicht zugelassen (Einbahnstrasse)
          break;
        end;

        // der Normal-Fall: bisher keine Eintrag, nun jedoch füllen, erstmaliger Eintrag
        if (OldValue = '') and (NewValue <> '') then
        begin
          // Ersteintrag!!
          qAUFTRAG.FieldByName(sFieldName).AsString := NewValue;
          inc(Stat_Wert_Beitrag);
          Stat_Changes := Stat_Changes + sFieldName + '=' + NewValue + cProtokollTrenner;
          break;
        end;

        // eine Abänderung eines bestehenden Wertes!
        if not(Ergaenzungsmodus) then
          if (OldValue <> NewValue) then
          begin
            // Änderung!!
            qAUFTRAG.FieldByName(sFieldName).AsString := NewValue;
            inc(Stat_Wert_Ueberschreibungen);
            inc(Stat_Wert_Beitrag);
            Stat_Changes := Stat_Changes + sFieldName + '*' + NewValue + cProtokollTrenner;
            break;
          end;

      until true;

    end;

    procedure neuerSTATUS(NewStatus: integer);
    begin
      repeat

        // keine Wertänderung
        if (STATUS = NewStatus) then
        begin
          // keine weitere Aktion notwendig!!
          break;
        end;

        // eine Abänderung eines bestehenden Wertes!
        if not(Ergaenzungsmodus) then
          if (STATUS <> NewStatus) then
          begin
            // Änderung!!
            qAUFTRAG.FieldByName('STATUS').AsInteger := NewStatus;
            inc(Stat_Wert_Ueberschreibungen);
            inc(Stat_Wert_Beitrag);
            Stat_Changes := Stat_Changes + 'STATUS' + '*' + inttostr(NewStatus) + cProtokollTrenner;
            break;
          end;

      until true;
    end;

    procedure V_add(s: string);
    begin
      repeat
        if (s = '') then
          break;
        if (V.indexof(s) <> -1) then
          break;
        V.add(s);
      until true;
    end;

  var
    n, m, k: integer;
    OneLine: string;
    ProtParameterName: string;
    ProtValue: string;
    OldValue: string;
    _RID: integer;

  begin

    // Anzeigen, um was es geht!
    _(cFeedBack_Label + 3, inttostrN(ERGEBNIS_TAN, 6) + '.' + pTAN);
    _(cFeedBack_ProcessMessages);

    ERGEBNIS_INFO := TStringList.create;
    Protokoll := TStringList.create;
    V := TStringList.create;
    V_Neu := TStringList.create;
    sTAN := TSearchStringList.create;

    // Einlesen der TAN Daten als Text
    if FileExists(pPath + pTAN + cUTF8DataExtension) then
      sTAN.LoadFromFile(pPath + pTAN + cUTF8DataExtension);

    // Einlesen der TAN Datei (alte Art!)
    AssignFile(INf, pPath + pTAN + cDATExtension);
    reset(INf);
    MdeRecordCount := FileSize(INf);
    inc(Stat_Meldungen, MdeRecordCount);

    //
    Bericht.add('[I] Verarbeite Monteur TAN ' + pTAN + ' mit ' + inttostr(MdeRecordCount) + ' Datensätzen');

    SetLength(AuftragArray, MdeRecordCount);
    for n := 0 to pred(MdeRecordCount) do
      read(INf, AuftragArray[n]);
    CloseFile(INf);

    // Übertragen in die Datenbank
    // Verfahren dabei:
    // MONDA_SCHUTZ verhindert jegliche Manipulation durch Monda
    //
    // Problem 1:
    // Tag1 : Monteur setzt auf Neu Anschreiben
    // Tag2 : Büro vereinbart neuen Termin
    // Tag3 : es wird nochmals "Neu Anschreiben" gemeldet
    //
    // wichtig: hat das Büro dann schon umterminiert darf am Termin
    // nichts mehr gemacht werden.
    // -> Sonderbehandlung der Stati "Restat" und "Neu Anschreiben"
    //
    // Problem 2:
    // Tag1: Monteur liefert V1=xxx, V2=yyy
    // Tag2: Der Termin wird vom Büro NEU eingeplant
    // Tag3: Monteur liefert V1=zzz
    // -> V1 darf hier nicht überschrieben werden es muss angereiht werden (Implementiert!)
    //
    qAUFTRAG := nQuery;
    with qAUFTRAG do
    begin
      sql.add('SELECT * FROM');
      sql.add(' AUFTRAG');
      sql.add('WHERE');

      // der Meister!
      sql.add(' (RID=(select MASTER_R from AUFTRAG where RID=:CROSSREF)) and');

      // ungesetzer Monda Schutz
      sql.add(' ((MONDA_SCHUTZ IS NULL) OR (MONDA_SCHUTZ=''' + cC_False + ''')) and');

      // nicht ein ewiger Termin (die haben auch einen Schutz!)
      sql.add(' ((AUSFUEHREN IS NULL) OR (AUSFUEHREN <> ''01.01.2000''))');

      sql.add('for update');

      for n := 0 to pred(MdeRecordCount) do
      begin
        with AuftragArray[n] do
        begin
          if {} (ausfuehren_ist_Datum <> cMonDa_Status_Wegfall) and
             {} (ausfuehren_ist_Datum <> cMonDa_Status_Info) and
             {} (ausfuehren_ist_Datum <> cMonDa_Status_unbearbeitet) then
          begin

            // Orginal-Daten retten
            _RID := RID;

            // Daten vorbereiten
            zaehlernummer_neu := TOrgaMonApp.formatZaehlerNummerNeu(zaehlernummer_neu);

            // Neuen Auftrag anlegen?
            if (RID = -1) or (ausfuehren_soll = cMonDa_ImmerAusfuehren) then
              RID := NeuerAuftrag(AuftragArray[n]);

            ParamByName('CROSSREF').AsInteger := RID;
            if not(Active) then
              open;
            first;

            if IsEmpty then
              if (iTagwacheBaustelle >= cRID_FirstValid) then
              begin

                //
                RID :=
                { } e_r_sql(
                  { } 'select MASTER_R from AUFTRAG where' +
                  { } ' (ZAEHLER_NUMMER=''' + zaehlernummer_alt + ''') and' +
                  { } ' (BAUSTELLE_R=' + inttostr(iTagwacheBaustelle) + ')');

                if (RID >= cRID_FirstValid) then
                  ParamByName('CROSSREF').AsInteger := RID;
              end;

            if not(IsEmpty) then
            begin

              // Init
              Stat_Wert_Ueberschreibungen := 0;
              Stat_Wert_Beitrag := 0;
              Stat_Changes := '';

              // bisherige Werte auslesen
              AUSFUEHREN := DateTime2long(FieldByName('AUSFUEHREN').AsDateTime);
              VMITTAGS := FieldByName('VORMITTAGS').AsString;
              STATUS := FieldByName('STATUS').AsInteger;
              Ergaenzungsmodus := not(FieldByName('EXPORT_TAN').IsNull);
              e_r_sqlt(FieldByName('ERGEBNIS_INFO'),ERGEBNIS_INFO);
              e_r_sqlt(FieldByName('PROTOKOLL'),Protokoll);

              // Vergebliche Besuche
              V_Neu.clear;
              V.clear;
              for m := 1 to 10 do
                V_add(Protokoll.Values['V' + inttostr(m)]);
              V_OldCount := V.count;

              // gehe in den Edit-Modus
              edit;

              // wird immer Eingetragen: der Ergebnis-Kontakt
              ERGEBNIS_INFO.add('ERGEBNIS.' + inttostrN(ERGEBNIS_TAN, 6) + '=' + pTAN);

              // Protokoll-String aufbereiten, vorzugsweise aus dem UTF8
              k := sTAN.FindInc(inttostr(RID));
              if (k <> -1) then
              begin
                OneLine := nextp(sTAN[k], ';', cMobileMeldung_COLUMN_PROTOKOLL);
                ersetze(cJondaProtokollDelimiter, ';', OneLine);
              end
              else
              begin
                OneLine := Oem2ansi(TOrgaMonApp.getTTBT(ProtokollInfo));
              end;

              // Parameter für Parameter!
              while (OneLine <> '') do
              begin

                ProtValue := nextp(OneLine, ';');
                ProtParameterName := nextp(ProtValue, '=');
                OldValue := Protokoll.Values[ProtParameterName];

                if (ProtParameterName <> '') then
                begin
                  repeat

                    // Spezialbehandlung für V1,V2,V3
                    if (pos('V', ProtParameterName) = 1) then
                    begin
                      V_Neu.add(ProtParameterName + '=' + ProtValue);
                      break;
                    end;

                    // keine Wertänderung
                    if (OldValue = ProtValue) then
                    begin
                      // keine weitere Aktion notwendig!!
                      break;
                    end;

                    // etwas soll durch nichts ersetzt werden -> nicht möglich
                    if (ProtValue = '') and (OldValue <> '') then
                    begin
                      // Eine Löschung der Eintragung wird nicht zugelassen (Einbahnstrasse)
                      break;
                    end;

                    // der Normal-Fall: bisher keine Eintrag, nun jedoch füllen
                    if (OldValue = '') and (ProtValue <> '') then
                    begin
                      // Ersteintrag!!
                      Protokoll.Values[ProtParameterName] := ProtValue;
                      inc(Stat_Wert_Beitrag);
                      Stat_Changes := Stat_Changes + ProtParameterName + '=' + ProtValue + cProtokollTrenner;
                      break;
                    end;

                    // eine Abänderung eines bestehenden Wertes!
                    if not(Ergaenzungsmodus) then
                      if (OldValue <> ProtValue) then
                      begin
                        // Änderung!!
                        Protokoll.Values[ProtParameterName] := ProtValue;
                        inc(Stat_Wert_Ueberschreibungen);
                        inc(Stat_Wert_Beitrag);
                        Stat_Changes := Stat_Changes + ProtParameterName + '*' + ProtValue + cProtokollTrenner;
                        break;
                      end;

                  until true;
                end;
              end;

              // Alle neuen V nun Hinzunehmen
              V_Neu.sort; // V1, V2 Reihenfolge sicherstellen!
              for m := 0 to pred(V_Neu.count) do
                V_add(nextp(V_Neu[m], '=', 1));

              // imp pend: Alle Vs, nun in Hinsicht auf den Zeitstempel-Wert sortieren!

              // Alle Vs nun dauerhaft Speichern
              for m := 0 to 9 do
              begin

                // Name=Value ermitteln
                ProtParameterName := 'V' + inttostr(succ(m));
                OldValue := Protokoll.Values[ProtParameterName];
                if (m < V.count) then
                  ProtValue := V[m]
                else
                  ProtValue := '';

                // speichern bzw. leeren
                if (OldValue <> ProtValue) then
                begin
                  Protokoll.Values[ProtParameterName] := ProtValue;
                  inc(Stat_Wert_Beitrag);
                  Stat_Changes := Stat_Changes + ProtParameterName + '=' + ProtValue + cProtokollTrenner;
                end;

              end;

              // Status Berechnungen
              case ausfuehren_ist_Datum of

                cMonDa_Status_FallBack, cMonDa_Status_Restant:
                  begin

                    // Meint der Monteur auch diese Variante?
                    if (ausfuehren_soll = AUSFUEHREN) and (VormittagsToChar(vormittags) = VMITTAGS) and

                    // Neu-Anschreiben schützt vor Status Restant
                      (STATUS <> cs_NeuAnschreiben) and (STATUS <> cs_Erfolg) and (STATUS <> cs_Vorgezogen) and
                      (STATUS <> cs_Unmoeglich) and

                    // Termin liegt in der Vergangenheit
                      (AUSFUEHREN < DateGet) then
                      neuerSTATUS(cs_Restant);

                  end;

                cMonDa_Status_NeuAnschreiben:
                  begin

                    // Meint der Monteur auch diese Variante?
                    if (ausfuehren_soll = AUSFUEHREN) and (VormittagsToChar(vormittags) = VMITTAGS) and
                      (STATUS <> cs_Erfolg) and (STATUS <> cs_Vorgezogen) and (STATUS <> cs_Unmoeglich)

                    then
                      neuerSTATUS(cs_NeuAnschreiben);
                  end;

                cMonDa_Status_Unmoeglich:
                  begin
                    neuerSTATUS(cs_Unmoeglich);
                  end;
                cMonDa_Status_Vorgezogen:
                  begin

                    if (STATUS <> cs_Erfolg) then
                      neuerSTATUS(cs_Vorgezogen);

                  end;

              else

                // Erfolgs-Status!
                neuerSTATUS(cs_Erfolg);

                if DateOK(ausfuehren_ist_Datum) then
                begin
                  if (ausfuehren_ist_Datum < 20040000) then
                  begin
                    ausfuehren_ist_Datum := ausfuehren_soll;
                    ausfuehren_ist_uhr := 0;
                  end;
                  if not(Ergaenzungsmodus) then
                    FieldByName('ZAEHLER_WECHSEL').AsDateTime := mkDateTime(ausfuehren_ist_Datum, ausfuehren_ist_uhr);
                end;

              end;

              // In allen Fälle: diese Fehler gehören MonDa
              updateField('REGLER_NR_KORREKTUR', reglernummer_korr);
              updateField('REGLER_NR_NEU', reglernummer_neu);
              updateField('ZAEHLER_NR_KORREKTUR', zaehlernummer_korr);
              updateField('ZAEHLER_NR_NEU', zaehlernummer_neu);
              updateField('ZAEHLER_STAND_ALT', zaehlerstand_alt);
              updateField('ZAEHLER_STAND_NEU', zaehlerstand_neu);

              // Weitere Zuweisungen
              FieldByName('PROTOKOLL').Assign(Protokoll);
              FieldByName('ERGEBNIS_INFO').Assign(ERGEBNIS_INFO);

              // Speichern
              if (Stat_Wert_Beitrag > 0) then
              begin
                Aenderungen.add(inttostr(RID) + ';' + Stat_Changes);
                ForceHistorischer := (Stat_Wert_Ueberschreibungen > 0);
                AuftragBeforePost(qAUFTRAG);
                inc(Stat_Aenderungen);
              end;
              post;

            end
            else
            begin
              // Log, dass dieser RID nicht gefunden wurde!
              inc(Stat_FehlendeRIDS);
              Bericht.add('[E] (RID=' + inttostr(_RID) + ') (Z#=' + zaehlernummer_alt + ') Datensatz nicht gefunden!');
            end;

          end;
        end;
        if frequently(StartTime, 222) then
          _(cFeedBack_ProcessMessages);
      end;
      close;
    end;
    qAUFTRAG.close;
    ERGEBNIS_INFO.Free;
    Protokoll.free;
    V.free;
    V_Neu.free;
    sTAN.free;
  end;

var
  n: integer;
  _sBearbeiter: integer; // typeof(sBearbeiter)
  TAN: string;
begin
  result := true;
  ERGEBNIS_TAN := 0;

  if not(FileExists(HtmlVorlagenPath + cMonDaIndex)) then
    exit;

  //
  _(cFeedBack_Label+3,'Vorlauf ...');
  _(cFeedBack_ProcessMessages);

  // Parameter auswerten
  if assigned(pOptions) then
  begin
   with pOptions do
   begin
     pDownLoadTANs := Values['DownLoadTANs']<>cIni_Deactivate;
     pPreserveTANsOnServer:= Values['PreserveTANsOnServer']=cIni_Activate;
     pMoveTANsToDiagnose:= Values['MoveTANsToDiagnose']<>cIni_Deactivate;
   end;
  end else
  begin
   // defaults
   pDownloadTANs := true;
   pPreserveTANsOnServer:= false;
   pMoveTANsToDiagnose:= true;
  end;


  CheckCreateDir(AuftragMobilServerPath);
  CheckCreateDir(MdePath);
  ErrorCount := 0;
  DirList := TStringList.create;
  Bericht := TStringList.create;
  Aenderungen := TStringList.create;
  FTP := TSolidFTP.create;
  Aenderungen.add('RID;INFO');

  Bericht.add(datum + ' ' + uhr);
  Stat_Meldungen := 0;
  Stat_Aenderungen := 0;
  Stat_FehlendeRIDS := 0;
  StartTime := 0;

  with FTP do
  begin
    Host := nextp(iMobilFTP, ';', 0);
    UserName := nextp(iMobilFTP, ';', 1);
    Password := nextp(iMobilFTP, ';', 2);
  end;

  // neue TANs downloaden
  if pDownloadTANs then
  begin
    _(cFeedBack_Label+3, 'FTP ...');
    _(cFeedBack_ProcessMessages);

    FTP.Get(
      { } '',
      { } cJonDa_ErgebnisMaske_deprecated_FTP,
      { } cJonDa_ErgebnisMaske_deprecated,
      { } AuftragMobilServerPath,
      { } not(pPreserveTANsOnServer));

    FTP.Get(
      { } '',
      { } cJonDa_ErgebnisMaske_utf8_FTP,
      { } cJonDa_ErgebnisMaske_utf8,
      { } AuftragMobilServerPath,
      { } not(pPreserveTANsOnServer));
    try
      FTP.Disconnect;
    except
    end;
  end;

  // TANs auflisten und verarbeiten
  dir(AuftragMobilServerPath + cJonDa_ErgebnisMaske_deprecated, DirList);
  DirList.sort;

  // jede einzelne TAN abarbeiten
  _(cFeedBack_ProgressBar_Max+1, IntToStr( DirList.count));

  // Reihenfolge: Ältestes zuerst verarbeiten!
  if (DirList.count > 0) then
  begin

    _sBearbeiter := sBearbeiter;
    if (iJonDaAdmin >= cRID_FirstValid) then
      sBearbeiter := iJonDaAdmin;

    ERGEBNIS_TAN := e_w_gen('GEN_ERGEBNIS');
    for n := 0 to pred(DirList.count) do
    begin

      try

        // Verarbeiten!
        TAN := ExtractFileNameWithoutExtension(DirList[n]);
        ProcessNewData(AuftragMobilServerPath, TAN);

        // Lokal löschen!
        if pMoveTANsToDiagnose then
          FileMove(AuftragMobilServerPath + TAN + '.*', DiagnosePath);

      except
        on e: exception do
        begin
          inc(ErrorCount);
          _(cFeedBack_Log,cERRORText + ' ReadMobil: ' + 'TAN: ' + TAN + ': ' + e.message);
          Bericht.add('[E] ' + DirList[n]);
        end;
      end;

      _(cFeedBack_ProgressBar_Position+1, intToStr( n));
      _(cFeedBAck_ProcessMessages);
    end;
    sBearbeiter := _sBearbeiter;
  end;

  //
  Bericht.add('[I] Meldungen: ' + inttostr(Stat_Meldungen));
  Bericht.add('[I] Änderungen: ' + inttostr(Stat_Aenderungen));
  if (Stat_FehlendeRIDS > 0) then
    Bericht.add('[I] WARNUNG: fehlende RIDS: ' + inttostr(Stat_FehlendeRIDS));

  Bericht.add('-----------');
  Bericht.SaveToFile(DiagnosePath + 'MobilAuslesen_' + inttostrN(ERGEBNIS_TAN, 6) + cLogExtension);
  Aenderungen.SaveToFile(DiagnosePath + 'MobilAuslesen_' + inttostrN(ERGEBNIS_TAN, 6) + '.csv');


  DirList.free;
  Bericht.free;
  Aenderungen.free;
  FTP.free;

  _(cFeedBack_ProgressBar_Position+1);
  _(cFeedBack_Label+3);

  // Im Verzeichnis aufräumen!
  FileDelete(AuftragMobilServerPath + '*.DAT', 10);

  result := (ErrorCount = 0);

end;

function e_w_WriteMobil(PERSON_R : Integer): boolean; overload;
var
 pOptions : TStringList;
begin
 if (PERSON_R>=cRID_FirstValid) then
 begin
   pOptions := TStringList.create;
   pOptions.values['Monteure'] := e_r_MonteurKuerzel(PERSON_R);
   result := e_w_WriteMobil(pOptions);
   pOptions.Free;
 end else
 begin
   result := e_w_WriteMobil;
 end;
end;

function e_w_WriteMobil(pOptions : TStringList = nil; fb : TFeedback = nil):boolean;

{$I feedback.inc}

var
  ActionCount: integer;
  BerichtL: TStringList;
  LastTime: dword;
  DatumsL: TgpIntegerList;
  EinMonteurL: TgpIntegerList;
  n: integer;
  IndexH: THTMLTemplate;
  Monteur: string;
  LastGeraeteNo: string;
  GeraeteNo: string;
  ErrorCount: integer;
  _Datum: TAnfixDate;
  JONDA_TAN: integer;
  cPERSON: TdboCursor;
  lAbgearbeitet: TgpIntegerList;
  lAbgezogen: TgpIntegerList;
  lMonteure: TgpIntegerList;
  PERSON_R: integer;
  FTPup: TStringList;
  sMONTEUR_R: string;
  MONTEUR_R: integer;
  InfoBlattResults: TStringList;

  // Parameter
  pFTPDiagnose: boolean; // war CheckBox7.Checked
  pPurgeZero: boolean; // war CheckBox8.Checked
  pUploadBaustellenInfos: boolean; // was CheckBox12.Checked
  pUploadAbgearbeitete: boolean; // was CheckBox9.Checked
  pUploadAbgezogene: boolean; // was CheckBox11.Checked
  pAsHTML: boolean; // was CheckBox2.Checked
  pFTPup: boolean; // was CheckBox1.Checked
  pMonteure: string; // Kürzel, Kürzel ...

  procedure ShowStep;
  begin
    inc(ActionCount);
    if frequently(LastTime, 333) then
    begin
      _(cFeedBack_ProgressBar_Position+1,IntToStr(ActionCount));
      _(cFeedBack_ProcessMessages);
    end;
  end;

  procedure doFTPup;
  var
    lUeberzaehligeGeraete: TStringList;
    n, k: integer;
    FTP: TSolidFTP;
  begin

    lUeberzaehligeGeraete := TStringList.create;
    FTP := TSolidFTP.Create;
    //
    _(cFeedBack_Label+3,'FTP-Upload ...');
    _(cFeedBack_ProcessMessages);

    with FTP do
    begin
      if pFTPDiagnose then
      begin
        // Test Zugangsdaten
        Host := cFTP_Host;
        UserName := cFTP_UserName;
        Password := cFTP_Password;
      end else
      begin
        Host := nextp(iMobilFTP, ';', 0);
        UserName := nextp(iMobilFTP, ';', 1);
        Password := nextp(iMobilFTP, ';', 2);
      end;
    end;

    //
    repeat

      // alle alten ???.DAT löschen!
      if pPurgeZero then
        if (lMonteure.count = 0) then
        begin

          //
          if not(FTP.Dir('', '*.DAT', '???.DAT', lUeberzaehligeGeraete)) then
          begin
            _(cFeedBack_Log,cERRORText + ' [7057] FTP FAILED');
            break;
          end;
          lUeberzaehligeGeraete.sort;

          // die heute übertragenen Schützen, alles andere löschen!
          for n := 0 to pred(FTPup.count) do
          begin
            k := lUeberzaehligeGeraete.indexof(nextp(FTPup[n], ';', 2));
            if (k <> -1) then
              lUeberzaehligeGeraete.delete(k);
          end;

        end;

      //
      if not(FTP.Put(FTPup)) then
      begin
        _(cFeedBack_Log,cERRORText + ' [7075] FTP FAILED');
        break;
      end;

      //
      if pPurgeZero then
        if not(FTP.Del('', lUeberzaehligeGeraete)) then
        begin
          _(cFeedBack_Log,cERRORText + ' [7083] FTP FAILED');
          break;
        end;
      try
        FTP.Disconnect;
      except
      end;
      try
        FTP.free;
      except
      end;
    until true;

    lUeberzaehligeGeraete.free;
  end;

begin
  result := true;

  if not(FileExists(HtmlVorlagenPath + cMonDaIndex)) then
    exit;

  if assigned(pOptions) then
  begin
   with pOptions do
   begin
    pFTPDiagnose:= values['FTPDiagnose']=cINI_Activate;
    pPurgeZero:= values['PurgeZero']<>cINI_DeActivate;
    pUploadBaustellenInfos:= values['UploadBaustellenInfos']<>cINI_DeActivate;
    pUploadAbgearbeitete:= values['UploadAbgearbeitete']<>cINI_DeActivate;
    pUploadAbgezogene:= values['UploadAbgezogene']<>cINI_DeActivate;
    pAsHTML:= values['AsHTML']=cINI_Activate;
    pFTPup:= values['FTPup']<>cINI_DeActivate;
    pMonteure := values['Monteure'];
   end;
  end else
  begin
    pFTPDiagnose := false;
    pPurgeZero := true;
    pUploadBaustellenInfos := true;
    pUploadAbgearbeitete := true;
    pUploadAbgezogene := true;
    pAsHTML := false;
    pFTPup := true;
    pMonteure := ''; // =alle
  end;

  JONDA_TAN := e_w_gen('GEN_JONDA');

  //
  _(cFeedBack_Label+3, 'Vorlauf ...');
  _(cFeedBack_ProcessMessages);

  ErrorCount := 0;
  InfoBlattResults := nil;
  BerichtL := TStringList.create;
  FTPup := TStringList.create;

  IndexH := THTMLTemplate.create;
  DatumsL := TgpIntegerList.create;
  EinMonteurL := TgpIntegerList.create;
  cPERSON := nCursor;
  lAbgearbeitet := TgpIntegerList.create;
  lMonteure := TgpIntegerList.create;

  ActionCount := 0;
  LastTime := 0;
  for n := 0 to pred(JonDaVorlauf) do
    DatumsL.add(DatePlus(DateGet, n));
  FileDelete(MdePath + 'MonDa*.html');
  InvalidateCache_Monteur;

  while (pMonteure<>'') do
  begin
    PERSON_R := e_r_MonteurRIDFromKuerzel(nextp(pMonteure, ','));
    if (PERSON_R > 0) then
      lMonteure.add(PERSON_R);
  end;

  if pUploadBaustellenInfos then
  begin
    // App-Server über die Baustellen informieren
    _(cFeedBack_Label+3, 'Baustellen-Infos ...');
    _(cFeedBack_ProcessMessages);
    e_r_Sync_Baustelle;
    FTPup.add(MdePath + cFotoService_BaustelleFName + ';' + ';' + cFotoService_BaustelleFName);
  end;

  // App-Server über abgearbeitete informieren
  if pUploadAbgearbeitete then
  begin
    _(cFeedBack_Label+3, 'Abgearbeitete ...');
    _(cFeedBack_ProcessMessages);
    lAbgearbeitet := e_r_sqlm(
      { } 'select AUFTRAG.RID from AUFTRAG ' +
      { } 'join BAUSTELLE on ' +
      { } ' (BAUSTELLE.RID=AUFTRAG.BAUSTELLE_R) and' +
      { } ' (BAUSTELLE.EXPORT_MONDA=''' + cC_True + ''')' +
      { } 'where' +
      { } ' (AUFTRAG.STATUS in (' +
      { } inttostr(cs_Erfolg) + ',' +
      { } inttostr(cs_NeuAnschreiben) + ',' +
      { } inttostr(cs_Vorgezogen) + ',' +
      { } inttostr(cs_Unmoeglich) + '))');
    lAbgearbeitet.SaveToFile(MdePath + 'abgearbeitet.dat');
    FTPup.add(MdePath + 'abgearbeitet.dat' + ';' + ';' + 'abgearbeitet.dat');
  end;

  with cPERSON do
  begin
    // alle Monteure mit Geräten ...
    sql.add('select');
    sql.add(' PERSON.RID,');
    sql.add(' PERSON.MONDA,');
    sql.add(' PERSON.VORNAME,');
    sql.add(' PERSON.NACHNAME,');
    sql.add(' ANSCHRIFT.NAME1');
    sql.add('from');
    sql.add(' PERSON');
    sql.add('join');
    sql.add(' ANSCHRIFT');
    sql.add('on');
    sql.add(' PERSON.PRIV_ANSCHRIFT_R=ANSCHRIFT.RID');
    sql.add('where');
    if (lMonteure.count > 0) then
      sql.add(' (PERSON.RID in ' + ListasSQL(lMonteure) + ') and');
    sql.add(' (PERSON.MONDA is not null) and');
    sql.add(' (PERSON.MONDA<>'''')');
    sql.add('order by');
    sql.add(' PERSON.MONDA, PERSON.KUERZEL');

    //
    IndexH.LoadFromFile(HtmlVorlagenPath + cMonDaIndex);
    IndexH.WriteGlobal('save&delete GERÄT');
    IndexH.WriteGlobal('Titel=' + long2dateText(DateGet) + ' bis ' + long2dateText(DatePlus(DateGet, pred(JonDaVorlauf))));

    ApiFirst;
    _(cFeedBack_ProgressBar_Max+1,IntToStr( RecordCount));
    LastGeraeteNo := '?';
    while not(eof) do
    begin

      MONTEUR_R := FieldByName('RID').AsInteger;

      //
      IndexH.WriteLocal('load GERÄT');

      // Monteure
      EinMonteurL.clear;
      EinMonteurL.add(MONTEUR_R);
      Monteur := e_r_MonteurKuerzel(FieldByName('RID').AsInteger);

      // Datums
      DatumsL.clear;

      // für "ewige" Termine, die auf das MDE drauf sollen!
      DatumsL.add(cMonDa_ImmerAusfuehren);

      // für nicht fixierte Termine, die der Monteur selbst wählen kann!
      DatumsL.add(cMonDa_FreieTerminWahl);

      // Heutiger Tag bis zum pred("Heutiger Tag" + Vorlauf)
      for n := 0 to pred(JonDaVorlauf) do
        DatumsL.add(DatePlus(DateGet, n));

      // Geräte ID
      GeraeteNo := FieldByName('MONDA').AsString;

      // ev. noch weitere Tage hinzu?!
      if assigned(pOptions) then
        for n := 0 to pred(pOptions.count) do
          if pos(Monteur + ',', pOptions[n]) = 1 then
          begin
            _Datum := date2long(nextp(pOptions[n], ',', 1));
            if (DatumsL.indexof(_Datum) = -1) then
              DatumsL.add(_Datum);
          end;

      // Neue Auftragsdatei anfangen?!
      if (LastGeraeteNo <> GeraeteNo) then
      begin
        FileDelete(MdePath + GeraeteNo + '.DAT');
        FileAlive(MdePath + GeraeteNo + '.DAT');
        LastGeraeteNo := GeraeteNo;
      end;

      _(cFeedBack_Label+3, Monteur + '-' + GeraeteNo + ' ...');
      _(cFeedBack_ProcessMessages);

      // Ganz normale Terminliste erzeugen!
      // imp pend
      InfoBlattResults := e_r_InfoBlatt(DatumsL, EinMonteurL, nil, nil, true);

      // Geräte-Daten hochladen
      FTPup.add(MdePath + GeraeteNo + '.DAT' + ';' + ';' + GeraeteNo + '.DAT');

      // Abgezogene
      if pUploadAbgezogene then
      begin

        //
        sMONTEUR_R := inttostr(MONTEUR_R);
        lAbgezogen := e_r_sqlm(
          { } 'select distinct ' +
          { } ' H.MASTER_R ' +
          { } 'from ' +
          { } ' AUFTRAG H ' +
          { } 'join AUFTRAG A on ' +
          { } ' (A.STATUS<>6) and ' +
          { } ' (A.RID=H.MASTER_R) and ' +
          { } ' ( ' +
          { } '  (A.MONTEUR1_R is null) or ' +
          { } '  ((A.MONTEUR1_R<>' + sMONTEUR_R + ') and (A.MONTEUR2_R is null)) or ' +
          { } '  ((A.MONTEUR1_R<>' + sMONTEUR_R + ') and (A.MONTEUR2_R<>' + sMONTEUR_R + ')) ' +
          { } ' ) ' +
          { } 'where ' +
          { } ' (H.STATUS=6) and ' +
          { } ' (H.MONTEUREXPORT is not null) and ' +
          { } ' ((H.MONTEUR1_R=' + sMONTEUR_R + ') or (H.MONTEUR2_R=' +
          { } sMONTEUR_R + ')) ');

        lAbgezogen.SaveToFile(MdePath + 'abgezogen.' + GeraeteNo + '.dat');

        FTPup.add(MdePath + 'abgezogen.' + GeraeteNo + '.dat' + ';' + ';' + 'abgezogen.' + GeraeteNo + '.dat');

        lAbgezogen.free;
      end;

      // Monteure-Kurz-Info
      if pAsHTML then
        FTPup.add(
         {} MdePath + 'MonDa' + inttostr(EinMonteurL[0]) + cHTMLextension + ';' +
         {} ';' +
         {} 'MonDa' + inttostr(EinMonteurL[0]) + cHTMLextension);

      //
      with IndexH do
      begin
        if (FieldByName('NAME1').AsString='') then
          WriteLocal('Monteur=' + FieldByName('VORNAME').AsString + ' ' + FieldByName('NACHNAME').AsString)
        else
          WriteLocal('Monteur=' + FieldByName('NAME1').AsString);
        WriteLocal('Link=MonDa' + FieldByName('RID').AsString + cHTMLextension);
        WriteLocal('Gerät=' + GeraeteNo);
        if assigned(InfoBlattResults) then
          WriteLocal('AnzTermine=' + InfoBlattResults.values['LastTerminCount']);
        WritePageBreak;
      end;

      //
      ShowStep; { 3. }
      ApiNext;
    end;

    with IndexH do
    begin
      WriteValue;
      SaveToFileCompressed(MdePath + 'Index.html');
    end;

    // FTP - Up
    if pAsHTML then
      FTPup.add(MdePath + 'Index.html' + ';' + ';' + 'index.html');

  end;

  // Wenn gewünscht FTP Upload!
  if pFTPup then
    doFTPup;

  //
  BerichtL.addstrings(IndexH);
  BerichtL.SaveToFile(DiagnosePath + 'MobilVolumen_' + inttostrN(JONDA_TAN, 6) + cLogExtension);

  cPERSON.free;
  DatumsL.free;
  EinMonteurL.free;
  IndexH.free;
  BerichtL.free;
  lAbgearbeitet.free;
  lMonteure.free;
  FTPup.free;
  if assigned(InfoBlattResults) then
   InfoBlattResults.Free;

  _(cFeedBack_ProgressBar_Position+1);
  _(cFeedBack_Label+3);

  result := (ErrorCount = 0);
end;

function e_r_InfoBlatt(
 {} Datum_RIDs,
 {} Monteur_RIDs,
 {} Single_RIDs: TgpIntegerList;
 {} ItemInformiert: TList;
 {} MondaMode: boolean = false;
 {} FaxMode: boolean = false;
 {} fb: TFeedback = nil): TStringList;

{$I feedback.inc}

const
  chtml_MIDAUFTRAG = 'load AUFTRAG MID,AUFTRAG';
  chtml_HEADER = 'load HEADER,HEADER';
var
  OutR: TMDERec;
  StartTime: dword;
  MonDaOutF: file of TMDERec;
  InfoBlatt: THTMLTemplate;
  RecN: Integer;
  Auftrag_RID: Integer;
  Master_RID: Integer;
  SubItems: TStringlist;
  AnschriftText: TStringlist;
  BriefText: TStringlist;
  Zaehlertext: TStringlist;
  InfoText: TStringlist;
  FirstNachmittag: boolean;
  FirstData: boolean;
  Baustellen: TStringlist;
  n, m: Integer;
  d: Integer;
  FName: string;
  _a, _b, _c: string;
  InfoAboutOld: boolean;
  TrueMonteurRIDs: TgpIntegerList;
  _OrgterminStr: string;
  LastTerminStr: string;
  LastMaster_RID: Integer;
  DatensammlerLokal: TStringlist;
  DatensammlerGlobal: TStringlist;
  cAUFTRAG, cHISTORISCH: TdboCursor;
  PreLookl: TStringlist;
  PreN, PreM: Integer;
  Headers: Integer;
  STATUS: TePhaseStatus;
  STATUS_MASTER: TeVirtualPhaseStatus;
  MondaBaustellenL: TgpIntegerList;
  cBAUSTELLE: TdboCursor;
  BAUSTELLE_R: Integer;
  RawMode: boolean;
  ZEITRAUM_VON: TANFiXDate;
  ZEITRAUM_BIS: TANFiXDate;
  ZEIT_VON, _ZEIT_VON : string;
  ZEIT_BIS, _ZEIT_BIS : string;
  AUSFUEHREN_SOLL: TANFiXDate;
  Protokoll: TStringlist;
  _RueckKanal: string;
  sVorlagen: TStringlist;

  // geht wieder raus
  _MonteurRIDsCount: Integer;
  _LastTerminCount: Integer;
  v_MonteurTag: TANFiXDate;

  // aus dem aktuellen Datensatz einen eindeutigen Termin-String zaubern
  function TerminStr: string;
  begin
    result :=
      {} SubItems[twh_Monteur] + ' ' + // Monteur
      {} SubItems[twh_WochentagKurz] + ' ' + // Wochentag
      {} copy(SubItems[twh_Datum], 1, 5) + // Datum
      AnsiUpperCase(SubItems[twh_ZeitText][1]) + '-' + // V/N
      'KW' + //
      inttostr(WeekGet(Date2Long(SubItems[twh_Datum])));
  end;

  function Hauptbaustelle: string;
  begin
    if (Baustellen.count = 0) then
      result := SubItems[twh_Baustelle]
    else
      result := Baustellen[0];
  end;

  function FaxAusschluss: string;
  var
    AusschlussL: TgpIntegerList;
  begin
    result := '';
    AusschlussL := e_r_sqlm('select RID from BAUSTELLE where TERMINLISTE_AUS=''' + cC_True + '''');
    if (AusschlussL.count > 0) then
    begin
      result := ' (BAUSTELLE_R not in ' + ListasSQL(AusschlussL) + ') and';
    end;
    AusschlussL.free;
  end;

  function SortierBegriffStr: string;
  begin
    if (Monteur_RIDs.count > 1) then
      result := AnsiUpperCase(Hauptbaustelle + '.' + // Baustelle
        SubItems[twh_Monteur] + '.' + // Monteur
        inttostr(Date2Long(SubItems[twh_Datum])) + '.' + // Datum
        inttostr(CharCount('N', SubItems[twh_Zeit])) // V=0, N=1
        )
    else
      result := AnsiUpperCase(inttostr(Date2Long(SubItems[twh_Datum])) + '.' +
        // Datum
        inttostr(CharCount('N', SubItems[twh_Zeit])) // V=0, N=1
        );
  end;

  function TitelStr: string;
  var
    DatumsStr: string;
  begin
    DatumsStr := SubItems[twh_DatumText];
    ersetze(',', ' ' + SubItems[twh_ZeitText] + ',', DatumsStr);
    result :=
      {} e_r_BaustelleNameFromKuerzel(Hauptbaustelle) + ': ' +
      {} SubItems[twh_MonteurText] + ' ' +
      {} DatumsStr +
      {} ' (KW ' + inttostr(WeekGet(Date2Long(SubItems[twh_Datum]))) + ')';
  end;

  procedure OpenHeader;
  begin
    //
    DatensammlerLokal.Add(chtml_HEADER);
    DatensammlerLokal.Add('Tabelle Titel=' + TitelStr);
    DatensammlerLokal.Add('Sortierbegriff=' + SortierBegriffStr);
    inc(Headers);
  end;

  procedure CloseHeader(vormittags: boolean);
  var
    n: Integer;
  begin
    for n := pred(DatensammlerLokal.count) downto 0 do
    begin
      if (pos(chtml_HEADER, DatensammlerLokal[n]) = 1) then
        break;
      if (pos(chtml_MIDAUFTRAG, DatensammlerLokal[n]) = 1) then
      begin
        DatensammlerLokal[n] := 'load AUFTRAG LAST' + VormittagsToChar(vormittags) + ',AUFTRAG';
        dec(Headers);
        break;
      end;
    end;
  end;

  procedure ErmittleBaustellen;
  var
    n: Integer;
  begin
    Baustellen.clear;
    for n := 0 to pred(PreLookl.count) do
    begin
      if not(TePhaseStatus(strtol(nextp(PreLookl[n], ';', 3))) in [ctsHistorisch, ctsUnmoeglich, ctsVorgezogen]) then
        Baustellen.Add(e_r_BaustelleKuerzel(strtointdef(nextp(PreLookl[n], ';', 4), 0)));
    end;
    Baustellen.sort;
    removeDuplicates(Baustellen);
  end;

begin
  // Vorlauf
  Baustellen := TStringlist.create;
  AnschriftText := TStringlist.create;
  BriefText := TStringlist.create;
  Zaehlertext := TStringlist.create;
  InfoText := TStringlist.create;
  Protokoll := TStringlist.create;
  TrueMonteurRIDs := TgpIntegerList.create;
  DatensammlerLokal := TStringlist.create;
  DatensammlerGlobal := TStringlist.create;
  PreLookl := TStringlist.create;

  if assigned(ItemInformiert) then
    ItemInformiert.clear; // Auftrags-Sammler
  _LastTerminCount:=0;
  result := TStringList.Create;

  cAUFTRAG := nCursor;
  with cAUFTRAG do
  begin
    sql.Add('select');
    sql.Add(' RID,VORMITTAGS,MASTER_R,STATUS,MONTEUREXPORT,');
    sql.Add(' ZAEHLER_WECHSEL,ZAEHLER_INFO,MONTEUR_INFO,BAUSTELLE_R,');
    sql.Add(' ZEITRAUM_VON,ZEITRAUM_BIS,PROTOKOLL,ZEIT_VON,ZEIT_BIS');
    sql.Add('from AUFTRAG');
    if assigned(Single_RIDs) then
    begin
      // ##
      Monteur_RIDs := TgpIntegerList.create;
      Monteur_RIDs.Add(1);
      Datum_RIDs := TgpIntegerList.create;
      Datum_RIDs.Add(1);

      sql.Add(' where RID in (');
      for n := pred(Single_RIDs.count) downto 0 do
        if (n > 0) then
          sql.Add(inttostr(Integer(Single_RIDs[n])) + ',')
        else
          sql.Add(inttostr(Integer(Single_RIDs[n])) + ')');
    end
    else
    begin
      sql.Add('where');
      if FaxMode then
        sql.Add(FaxAusschluss);
      sql.Add(' (AUSFUEHREN=:AUSF) and');
      sql.Add(' (VORMITTAGS is not null) and');
      sql.Add(' ((MONTEUR1_R=:MON) OR (MONTEUR2_R=:MON)) and');
      sql.Add(' ((STATUS in (' +
       {} inttostr(ord(ctsTerminiert)) + ',' +
       {} inttostr(ord(ctsAngeschrieben)) + ',' +
       {} inttostr(ord(ctsMonteurinformiert)) + ',' +
       {} inttostr(ord(ctsNeuAnschreiben)) + ',' +
       {} inttostr(ord(ctsRestant)) + ',' +
       {} inttostr(ord(ctsVorgezogen)) + ',' +
       {} inttostr(ord(ctsErfolg)) + ',' +
       {} inttostr(ord(ctsUnmoeglich))
        + ')) or');
      sql.Add('       ((STATUS=' + inttostr(ord(ctsHistorisch)) + ') and MONTEUREXPORT is not null)');
      sql.Add('      )');
    end;
    sql.Add('order by');
    sql.Add(' VORMITTAGS descending,'); // V..N
    sql.Add(' BAUSTELLE_R,'); // Baustelle
    sql.Add(' STRASSE,'); // PQ-Strassen
    sql.Add(' NUMMER'); // AB-Nummern
    dblog(sql);
    prepare;
  end;

  cHISTORISCH := nCursor;
  with cHISTORISCH do
  begin
    sql.Add('select RID from AUFTRAG');
    sql.Add('where (MASTER_R=:CROSSREF) and');
    sql.Add('      (RID<>MASTER_R) and');
    sql.Add('      (MONTEUREXPORT is not null) and');
    sql.Add('      (AUSFUEHREN is not null)');
    sql.Add('order by RID descending');
    dblog(sql);
    prepare;
  end;

  if MondaMode then
  begin

    // Datei anlegen
    CheckCreateDir(MDEPath);
    if (Monteur_RIDs.count = 1) then
    begin
      assignFile(MonDaOutF, MDEPath + e_r_MonteurGeraeteID(Monteur_RIDs[0]) + '.DAT');
{$I-}
      reset(MonDaOutF);
{$I+}
      if (ioresult <> 0) then
        rewrite(MonDaOutF);
      // Ans Dateiende positionieren!
      seek(MonDaOutF, FileSize(MonDaOutF));
    end
    else
    begin
      assignFile(MonDaOutF, MDEPath + 'NEUES.DAT');
      rewrite(MonDaOutF);
    end;

    // mögliche Baustellen auflisten
    MondaBaustellenL := e_r_sqlm('select RID from BAUSTELLE where EXPORT_MONDA=''' + cC_True + '''');

  end;

  // !prepare!
  DatensammlerGlobal.Add('save&delete AUFTRAG MID');
  DatensammlerGlobal.Add('save&delete AUFTRAG LASTV');
  DatensammlerGlobal.Add('save&delete AUFTRAG LASTN');
  DatensammlerGlobal.Add('save&delete HEADER');

  Headers := 0;
  _MonteurRIDsCount := 0;
  EnsureHourGlass;
  _(cFeedBack_ProgressBar_max+1,IntToStr( Datum_RIDs.count * Monteur_RIDs.count));
  _(cFeedBack_ProgressBar_Position+1);
  for n := 0 to pred(Monteur_RIDs.count) do
  begin

    for d := 0 to pred(Datum_RIDs.count) do
    begin

      v_MonteurTag := Integer(Datum_RIDs[d]);

      _(cFeedBack_ProgressBar_stepit+1);;
      _(cFeedBack_processmessages);

      with cAUFTRAG do
      begin

        if not(assigned(Single_RIDs)) then
        begin
          params.BeginUpdate;
          ParamByName('AUSF').AsDate := long2datetime(v_MonteurTag);
          ParamByName('MON').AsInteger := Monteur_RIDs[n];
          {$ifdef fpc}
          params.EndUpdate;
          {$else}
          params.EndUpdate(true);
          {$endif}
        end;

        if (RecordCount = 0) then
          continue;

        // Vorlauf
        PreLookl.clear;
        ApiFirst;
        while not(eof) do
        begin
          PreLookl.AddObject(
            { [00] } FieldByName('RID').AsString + ';' +
            { [01] } FieldByName('VORMITTAGS').AsString + ';' +
            { [02] } FieldByName('MASTER_R').AsString + ';' +
            { [03] } FieldByName('STATUS').AsString + ';' +
            { [04] } FieldByName('BAUSTELLE_R').AsString, TObject(FieldByName('RID').AsInteger));
          APInext;
        end;

        // Prüfung, ob was schief geht
        // PreLookl.SaveToFile(DiagnosePath+'pre.0.txt');
        PreM := 0;
        repeat

          if (nextp(PreLookl[PreM], ';', 3) <> '6') then
          begin
            // echter Datensatz! -> lösche alle historischen!
            for PreN := pred(PreLookl.count) downto 0 do
              if (PreN <> PreM) then
                if (nextp(PreLookl[PreN], ';', 1) = nextp(PreLookl[PreM], ';', 1)) and // V/N
                  (nextp(PreLookl[PreN], ';', 2) = nextp(PreLookl[PreM], ';', 2)) then // gleicher !master!
                begin
                  PreLookl.Delete(PreN);
                  if (PreN < PreM) then
                    dec(PreM);
                end;

          end
          else
          begin

            // historischer! -> lösche alle älteren historischen
            for PreN := pred(PreLookl.count) downto 0 do
              if (PreN <> PreM) then
                if (nextp(PreLookl[PreN], ';', 1) = nextp(PreLookl[PreM], ';', 1)) and // V/N
                  (nextp(PreLookl[PreN], ';', 2) = nextp(PreLookl[PreM], ';', 2)) and // gleicher !master!
                  (nextp(PreLookl[PreN], ';', 3) = inttostr(ord(ctsHistorisch))) and // Staus=6
                  (strtointdef(nextp(PreLookl[PreN], ';', 0), 0) < strtointdef(nextp(PreLookl[PreM], ';', 0), 0)) then
                // RID kleiner
                begin
                  PreLookl.Delete(PreN);
                  if (PreN < PreM) then
                    dec(PreM);
                end;
          end;
          inc(PreM);
        until (PreM >= PreLookl.count);
        // PreLookl.SaveToFile(DiagnosePath+'pre.1.txt');

        // Ermittlung der aktive Baustellen!
        ErmittleBaustellen;

        // Jetzt kommt die Tatsächliche Ausgabe
        RecN := 0;
        FirstNachmittag := true;
        FirstData := true;
        LastTerminStr := '';
        LastMaster_RID := -1;
        ApiFirst;
        while not(eof) do
        begin

          repeat

            // Ein historischer Datensatz, jedoch ohne Monteur-Info
            // d.h. der Monteur weis nix davon
            Auftrag_RID := FieldByName('RID').AsInteger;
            if (PreLookl.indexofobject(TObject(Auftrag_RID)) = -1) then
              break;

            // Bei freier Terminwahl kommen nur die "offenen"
            // auf das Gerät!
            STATUS := TePhaseStatus(FieldByName('STATUS').AsInteger);
            if (v_MonteurTag = cMonDa_FreieTerminWahl) then
              if STATUS in [ctsDatenFehlen, ctsErfolg, ctsNeuAnschreiben, ctsHistorisch, ctsVorgezogen, ctsUnmoeglich]
              then
                break;

            Master_RID := FieldByName('MASTER_R').AsInteger;
            BAUSTELLE_R := FieldByName('BAUSTELLE_R').AsInteger;
            SubItems := e_r_AuftragItems(Auftrag_RID);

            // OK, die Zeile kommt dazu
            inc(RecN);
            if assigned(ItemInformiert) then
             ItemInformiert.Add(pointer(Auftrag_RID));

            // Monda Daten erstellen
            fillchar(OutR, sizeof(OutR), #0);
            with OutR do
            begin

              { Feld-Besitzer: OrgaMon }
              RID := Auftrag_RID;
              Baustelle := Ansi2Oem(SubItems[twh_Baustelle]);
              ABNummer := SubItems[twh_Auftrags_Nummer];
              Monteur := Ansi2Oem(SubItems[twh_Monteur]);
              Art := SubItems[twh_Art];
              if (length(SubItems[twh_Zaehler_Nummer]) > cMonDa_FieldLength_ZaehlerNummer) then
                zaehlernummer_alt := revCopy(SubItems[twh_Zaehler_Nummer], 1, cMonDa_FieldLength_ZaehlerNummer)
              else
                zaehlernummer_alt := SubItems[twh_Zaehler_Nummer];
              reglernummer_alt := SubItems[twh_ReglerNummerAlt];
              AUSFUEHREN_SOLL := Date2Long(SubItems[twh_Datum]);
              vormittags := (SubItems[twh_Zeit] = cVormittagsChar);
              Zaehler_Name1 := Ansi2Oem(SubItems[twh_Verbraucher_Name]);
              Zaehler_Name2 := Ansi2Oem(SubItems[twh_Verbraucher_Name2]);
              Zaehler_Strasse := Ansi2Oem(SubItems[twh_Verbraucher_Strasse]);
              Zaehler_Ort := Ansi2Oem(SubItems[twh_Verbraucher_Ort]);

              { Feld-Besitzer: OrgaMon-App }
              zaehlerstand_alt := '';
              zaehlernummer_korr := '';
              zaehlernummer_neu := '';
              zaehlerstand_neu := '';
              reglernummer_korr := '';
              reglernummer_neu := '';
              TOrgaMonApp.setTTBT('', ProtokollInfo );
              ausfuehren_ist_uhr := 0;
              case STATUS of
                ctsHistorisch:
                  ausfuehren_ist_datum := cMonDa_Status_Wegfall;
                ctsRestant:
                  ausfuehren_ist_datum := cMonDa_Status_Restant;
                ctsVorgezogen:
                  ausfuehren_ist_datum := cMonDa_Status_Vorgezogen;
                ctsUnmoeglich:
                  ausfuehren_ist_datum := cMonDa_Status_Unmoeglich;
                ctsErfolg:
                  begin
                    if FieldByName('ZAEHLER_WECHSEL').IsNull then
                      ausfuehren_ist_datum := DateGet
                    else
                      ausfuehren_ist_datum := DateTime2long(FieldByName('ZAEHLER_WECHSEL').AsDateTime);
                  end;
              else
                ausfuehren_ist_datum := cMonDa_Status_unbearbeitet;
              end;

            end;

            repeat

              if FirstData then
              begin

                // wenn es keine "v" Termine gibt ist das die letzte Tabelle
                if (SubItems[twh_ZeitText][1] = 'n') then
                  FirstNachmittag := false;

                // Jetzt die Anzahl der informierten Monteure zählen
                if (TrueMonteurRIDs.indexof(Monteur_RIDs[n]) = -1) then
                begin
                  inc(_MonteurRIDsCount);
                  TrueMonteurRIDs.Add(Monteur_RIDs[n]);
                end;

                // Jetzt ev. eine neue Tabelle laden (incl. FF)
                OpenHeader;

                FirstData := false;
                break;
              end;

              if FirstNachmittag then
                if (SubItems[twh_ZeitText][1] = 'n') then
                begin
                  CloseHeader(true);
                  OpenHeader;
                  FirstNachmittag := false;
                end;

            until true;

            // Auftrag laden
            DatensammlerLokal.Add(chtml_MIDAUFTRAG);

            if assigned(Single_RIDs) then
            begin
              _a := SubItems[twh_DatumText] + ':' + SubItems[twh_Monteur] + #13;
            end
            else
            begin
              _a := '';
            end;

            case STATUS of
              ctsRestant, ctsHistorisch, ctsErfolg, ctsVorgezogen, ctsUnmoeglich:
                DatensammlerLokal.Add('No=' + _a + '(' + SubItems[twh_Baustelle] + '-' + SubItems[twh_Auftrags_Nummer] +
                  ')' + #13 + SubItems[twh_Zaehler_Nummer])
            else
              if (SubItems[twh_WordEmpfaenger] <> '') then
              begin
                DatensammlerLokal.Add('No=@' + Ansi2html(_a) + '<u>' + Ansi2html(SubItems[twh_Baustelle] + '-' +
                  SubItems[twh_Auftrags_Nummer]) + '</u><br>' + Ansi2html(SubItems[twh_Zaehler_Nummer]));
              end
              else
                DatensammlerLokal.Add('No=' + _a + SubItems[twh_Baustelle] + '-' + SubItems[twh_Auftrags_Nummer] + #13 +
                  SubItems[twh_Zaehler_Nummer])

            end;

            DatensammlerLokal.Add('VN=' + AnsiUpperCase(SubItems[twh_ZeitText][1]) + #13 + SubItems[twh_Art]);

            // zwingendes Blank
            AnschriftText.clear;
            _a := cutblank(SubItems[twh_Verbraucher_Strasse]);
            ersetze(' ', cNonBreakableSpace, _a);
            _b := cutblank(SubItems[twh_Verbraucher_Name]);
            ersetze(' ', cNonBreakableSpace, _b);
            _c := cutblank(SubItems[twh_Verbraucher_Name2]);
            ersetze(' ', cNonBreakableSpace, _c);
            AnschriftText.Add(cutblank(_a + ' ' + _b + ' ' + _c));

            _a := cutblank(SubItems[twh_Verbraucher_Ort]);
            ersetze(' ', cNonBreakableSpace, _a);
            _b := cutblank(SubItems[twh_Verbraucher_Ortsteil]);
            ersetze(' ', cNonBreakableSpace, _b);
            AnschriftText.Add(cutblank(_a + ' ' + _b));

            DatensammlerLokal.Add('Anschrift=' + HugeSingleLine(AnschriftText));

            // Anschreiben
            if
            { } (
              { } (SubItems[twh_Anschreiben_Strasse] <> '') or
              { } (SubItems[twh_Anschreiben_Name] <> '') or
              { } (SubItems[twh_Anschreiben_Name2] <> '') or
              { } (SubItems[twh_Anschreiben_Ort] <> '')
              { } ) and
            { } (
              { } (SubItems[twh_Verbraucher_Strasse] <> SubItems[twh_Anschreiben_Strasse]) or
              { } (SubItems[twh_Verbraucher_Name] <> SubItems[twh_Anschreiben_Name]) or
              { } (SubItems[twh_Verbraucher_Name2] <> SubItems[twh_Anschreiben_Name2]) or
              { } (SubItems[twh_Verbraucher_Ort] <> SubItems[twh_Anschreiben_Ort])
              { } ) then
            begin
              // Brief-Text
              BriefText.clear;
              _a := cutblank(SubItems[twh_Anschreiben_Strasse]);
              ersetze(' ', cNonBreakableSpace, _a);
              _b := cutblank(SubItems[twh_Anschreiben_Name]);
              ersetze(' ', cNonBreakableSpace, _b);
              _c := cutblank(SubItems[twh_Anschreiben_Name2]);
              ersetze(' ', cNonBreakableSpace, _c);
              BriefText.Add(cutblank(_a + ' ' + _b + ' ' + _c));
              _a := cutblank(SubItems[twh_Anschreiben_Ort]);
              ersetze(' ', cNonBreakableSpace, _a);
              BriefText.Add(cutblank(_a));

              DatensammlerLokal.Add('Brief=' + HugeSingleLine(BriefText));
            end
            else
            begin
              DatensammlerLokal.Add('Brief=');
            end;

            e_r_sqlt(FieldByName('ZAEHLER_INFO'),Zaehlertext);
            DatensammlerLokal.Add('Zähler=' + HugeSingleLine(Zaehlertext, ', '));

            e_r_sqlt(FieldByName('MONTEUR_INFO'),InfoText);

            // besondere, abweichende Uhrzeit
            if (SubItems[twh_Zeitfenster]<>'') then
             InfoText.insert(0, SubItems[twh_Zeitfenster]);

            // Werte aus dem Protokoll zurück in die Terminänderunsliste
            e_r_sqlt(FieldByName('PROTOKOLL'),Protokoll);
            with Protokoll do
              _RueckKanal := cutblank(values['I1'] + ' ' + values['I2'] + ' ' + values['I6'] + ' ' + values['I7'] + ' '
                + values['I8']);
            if (_RueckKanal <> '') then
              InfoText.Add('[' + _RueckKanal + ']');

            _OrgterminStr := TerminStr;

            repeat

              // historische
              if (STATUS = ctsHistorisch) then
              begin

                // Nachladen des aktuellen Masters
                SubItems := e_r_AuftragItems(Master_RID);
                STATUS_MASTER := TeVirtualPhaseStatus(strtol(SubItems[twh_Status1]));
                e_r_sql('select MONTEUR_INFO from AUFTRAG where RID=' + inttostr(Master_RID), InfoText);

                repeat

                  // - -
                  if (STATUS_MASTER in [ctvTerminiert, ctvAngeschrieben, ctvMonteurinformiert, ctvRestant,
                    ctvNeuAnschreiben, ctvAngeschriebenInformiert]) and (SubItems[twh_Monteur] <> '') then
                  begin
                    if (SubItems[twh_ZeitText] <> '?') then
                      InfoText.insert(0, '   (neuer Termin:' + TerminStr + ')');
                    InfoText.insert(0, '   !!!WEGFALL!!!');
                    break;
                  end;

                  // - -
                  case STATUS_MASTER of
                    ctvErfolg, ctvErfolgGemeldet:
                      begin
                        InfoText.insert(0, '   (bereits durchgeführt!)');
                        InfoText.insert(0, '   !!!WEGFALL!!!');
                      end;
                    ctvUnmoeglich, ctvUnmoeglichGemeldet:
                      InfoText.insert(0, '   !!!UNMÖGLICH!!!');
                    ctvVorgezogen, ctvVorgezogenGemeldet:
                      InfoText.insert(0, '   !!!VORGEZOGEN!!!');
                  else
                    InfoText.insert(0, '   (kein neuer Termin!)');
                    InfoText.insert(0, '   !!!WEGFALL!!!');
                  end;

                until true;
                break;
              end;

              // unmögliche
              if (STATUS = ctsUnmoeglich) then
              begin
                InfoText.insert(0, '   !!!UNMÖGLICH!!!');
                break;
              end;

              // Restant
              if (STATUS = ctsRestant) then
              begin
                InfoText.insert(0, '   !!!RESTANT!!!');
                break;
              end;

              // Vorgezogen
              if (STATUS = ctsVorgezogen) then
              begin
                InfoText.insert(0, '   !!!VORGEZOGEN!!!');
                break;
              end;

              // Erledigt
              if (STATUS = ctsErfolg) then
              begin
                InfoText.insert(0, '   !!!FERTIG!!!');
                break;
              end;

              InfoAboutOld := false;
              with cHISTORISCH do
              begin
                // den entsprechenden Historische Datensätze suchen
                ParamByName('CROSSREF').AsInteger := Auftrag_RID;
                ApiFirst;
                while not(eof) do
                begin
                  InfoAboutOld := true; // es gibt alte!
                  SubItems := e_r_AuftragItems(FieldByName('RID').AsInteger);
                  if (TerminStr <> _OrgterminStr) then
                  begin
                    InfoText.insert(0, TerminStr);
                    InfoText.insert(0, 'TERMIN ALT:');
                    break;
                  end;
                  APInext;
                end;
              end;

              // Wechselzeitraum!
              if not(FieldByName('ZEITRAUM_VON').IsNull) or not(FieldByName('ZEITRAUM_BIS').IsNull) then
              begin
                ZEITRAUM_VON := DateTime2long(FieldByName('ZEITRAUM_VON').AsDateTime);
                ZEITRAUM_BIS := DateTime2long(FieldByName('ZEITRAUM_BIS').AsDateTime);
                if (abs(DateDiff(ZEITRAUM_VON, v_MonteurTag)) <= 7) or (abs(DateDiff(ZEITRAUM_BIS, v_MonteurTag)) <= 7)
                then
                  InfoText.insert(0,
                   {} 'zwischen ' + copy(Long2date(ZEITRAUM_VON), 1, 6) + ' und ' +
                   {} copy(Long2date(ZEITRAUM_BIS), 1, 6));
              end;

              // keine weiteren Texte bei Sonder-Terminen
              if (OutR.AUSFUEHREN_SOLL <= cMonDa_FreieTerminWahl) then
                break;

              //
              if FieldByName('MONTEUREXPORT').IsNull then
              begin
                if not(InfoAboutOld) then
                  InfoText.insert(0, '   Neu!');
                break;
              end;

              if not(InfoAboutOld) then
                InfoText.insert(0, '   wie vereinbart');

            until true;

            if assigned(Single_RIDs) then
              InfoText.insert(0, 'EINZELNE NACHMELDUNG:');

            // Info ausgeben
            if (InfoText.count > 0) then
            begin

              // ermitteln ob mit html gearbeitet wird
              // das kann nicht in einzelnen Zeilen, sondern nur im ganzen
              // Block gemacht werden
              RawMode := false;
              for m := 0 to pred(InfoText.count) do
                if pos('@', InfoText[m]) = 1 then
                begin
                  RawMode := true;
                  InfoText[m] := copy(InfoText[m], 2, MaxInt);
                end;

              if RawMode then
                DatensammlerLokal.Add('Info=@' + HugeSingleLine(InfoText, '<br>'))
              else
                DatensammlerLokal.Add('Info=' + HugeSingleLine(InfoText));

              TOrgaMonApp.setTTBT( Ansi2Oem(HugeSingleLine(InfoText)), OutR.Monteur_Info);
            end
            else
            begin
              DatensammlerLokal.Add('Info=' + cNonBreakableSpace);
            end;
            DatensammlerLokal.Add('pagebreak');

            TOrgaMonApp.setTTBT(Ansi2Oem(HugeSingleLine(Zaehlertext, ' ')), OutR.Zaehler_info );
            if MondaMode then
              if (MondaBaustellenL.indexof(BAUSTELLE_R) <> -1) then
                write(MonDaOutF, OutR);

            inc(_LastTerminCount);
          until true;
          APInext;
        end;

        // Ende des ganzen Tages erreicht!
        if (RecN > 0) then
        begin
          CloseHeader(false);
          case Baustellen.count of
            0:
              DatensammlerLokal.Add('MehrInfo=' + 'An diesem Tag sind keine Termine vorhanden!');
            1:
              DatensammlerLokal.Add('MehrInfo=' + 'An diesem Tag kein Wechsel der Baustelle!');
          else
            DatensammlerLokal.Add('MehrInfo=' + 'Sie arbeiten heute auf ' + inttostr(Baustellen.count) + ' Baustellen ('
              + HugeSingleLine(Baustellen, ',') + ')!');
          end;
          DatensammlerLokal.Add('NochMehrInfo=' + cOrgaMonCopyright);
        end;

      end;
    end;
  end;

  cAUFTRAG.close;
  cHISTORISCH.close;

  cAUFTRAG.free;
  cHISTORISCH.free;

  if MondaMode then
  begin
    CloseFile(MonDaOutF);
  end;

  Baustellen.free;
  AnschriftText.free;
  BriefText.free;
  Zaehlertext.free;
  InfoText.free;
  Protokoll.free;
  TrueMonteurRIDs.free;
  PreLookl.free;
  MondaBaustellenL.free;

  // hier jetzt noch den Index-HTML neu erzeugen!
  if (Headers <> 0) then
    _(cFeedBack_ShowMessage,'ERROR: html nicht vollständig korrekt!');

  //
  sVorlagen := TStringlist.create;
  dir(HtmlVorlagenPath + 'Monteur.?.???.html', sVorlagen, false);
  sVorlagen.sort;

  // Jetzt belichten
  InfoBlatt := THTMLTemplate.create;
  InfoBlatt.LoadFromFile(HtmlVorlagenPath + sVorlagen[pred(sVorlagen.count)]);
  sVorlagen.free;

  with InfoBlatt do
  begin
    CanUseQuick := true;
    WriteValue(DatensammlerLokal, DatensammlerGlobal);
    if MondaMode then
    begin
      FName := MDEPath + 'MonDa' + inttostr(Monteur_RIDs[0]) + '.html';
    end
    else
    begin
      if (Monteur_RIDs.count > 1) then
      begin
        if (Datum_RIDs.count > 1) then
          FName := WebPath + 'w' + inttostr(WeekGet(Integer(Datum_RIDs[0]))) + '.html'
        else
          FName := WebPath + 'g' + inttostr(v_MonteurTag) + '.html';
      end
      else
        FName := WebPath + 'm' + inttostr(Monteur_RIDs[0]) + '-' + inttostr(v_MonteurTag) + '.html';
    end;
    SortPages;
    SaveToFileCompressed(FName);
  end;

  InfoBlatt.free;
  DatensammlerLokal.free;
  DatensammlerGlobal.free;

  _(cFeedBack_ProgressBar_Position+1);
  if not(MondaMode) then
   if assigned(ItemInformiert) then
    if (ItemInformiert.count > 0) then
     _(cFeedBack_OpenShell,FName);

  with result do
  begin
    values['MonteurRIDsCount'] := IntTostr(_MonteurRIDsCount);
    values['LastTerminCount'] := IntTostr(_LastTerminCount);
    values['v_MonteurTag'] := IntTostr(v_MonteurTag);
  end;
end;

function nichtEFREFName(Settings: TStringList): string;
begin
  // Datei mit der Liste der nicht einbaufähigen Neugeräte
  result :=
   { } cAuftragErgebnisPath +
   { } e_r_BaustellenPfad(Settings) + '\' +
   { } 'nicht-EFRE-' + Settings.values[cE_BAUSTELLE_KURZ] + '.csv';
end;

function e_w_CreateFiles(
 {} Settings: TStringList;
 {} RIDs: TgpIntegerList;
 {} FailL: TgpIntegerList;
 {} Files: TStringList;
 {} fb : TFeedBack = nil): boolean;

  {$I Feedback.inc}

var
  ExcelWriteRow: integer;

  // Kopf-Zeile
  Header: TStringList;
  Header_col_Scan: integer;

  // Strings: A|B|C|A Objects: [0,3]|[1]|[2]|[0,3] so geht das Ding raus!!!
  HeaderDefault: TStringList; // vordefiniert
  HeaderSuppress: TStringList; // nicht erwünschte Daten
  HeaderFromIntern: TStringList; // Spalten aus dem INTERN Feld
  HeaderTextFormat: TStringList; // xls Ausgabe Zellformats soll Text sein

  LinesL: TList;
  ErrorCount: integer;
  cAUFTRAG: TdboCursor;
  cINTERNINFO: TdboCursor;
  OutFName, SingleFName: string;
  Oc_Bericht: TStringList;
  Oc_Result: boolean;

  // Qualitäts-Sicherung
  sPlausi: string;
  PlausiMode: integer;
  sQS_kritisch: TStringList;

  // Foto mit im Zip?!
  AuchMitFoto: boolean;
  FotoSpalten, _FotoSpalten, FotoSpalte: string; // "FA;FN;FH"
  FilesCandidates: TStringList;
  FotoFName, _FotoFName: string;

  // Zwischenspeicher
  ActColumn: TStringList;
  ActValue: string;
  ActColIndex: integer;

  // für die Gesamtausgabe
  HeaderLine: string;
  HeaderName: string;
  DataLine: string;
  ProtokollLine: string;
  Zaehlwerk: string;
  ProtokollFeldNamen: TStringList;
  MussFelder: TStringList;
  MussFelder_Mehr: TStringList;
  RauteFelder: TStringList;
  OhneInhaltFelder: TStringList;
  IstEinMussFeld: boolean;
  IstEinRauteFeld: boolean;
  ProtokollMode: boolean;
  ProtokollWerte: TStringList;
  Umsetzer: TFieldMapping;

  // Zählernummer Neu Umkonvertierungen
  Zaehler_nr_neu_filter: string;
  Zaehler_nr_neu_zeichen: string;

  zaehler_stand_neu: double;
  zaehler_stand_neu_soll: double;
  material_nummer_alt: string;
  FoundLine: integer;
  FAIL_R: integer;
  writePermission: boolean;

  // Mehrtarif
  zweizeilig: boolean; // Modus: einfach immer 2 Zeilen, NA, NN
  zaehlwerke: boolean; // Modus: über ZAEHLWERKE_AUSBAU, ZAEHLWERKE_EINBAU
  Settings_Zaehlwerke: TStringList; // Optionen und Einstellungen
  Settings_Zaehlwerke_FName : String;
  col_ZaehlwerkName_Ausbau : Integer;
  col_ZaehlwerkName_Einbau : Integer;
  col_ZaehlerStandAlt : Integer;
  col_ZaehlerStandNeu : Integer;

  // Cache-Felder von Werten aus dem Datensatz
  // oder Parameter
  AUFTRAG_R: integer;
  BAUSTELLE_R: integer;
  N1, NA, NN, Sparte, A1: string;
  vSTATUS: TeVirtualPhaseStatus;
  ART: string;
  ZAEHLER_NR_NEU: string;
  ZAEHLWERKE_AUSBAU, ZW_AUSBAU : string;
  ZAEHLWERKE_EINBAU, ZW_EINBAU : string;
  ZW_Value: String;
  ZaehlerNummerNeuPreFix: string;
  ZaehlwerkeIst: integer; // aus der Art
  INTERN_INFO: TStringList;
  ERGEBNIS_INFO: TStringList;
  HTMLBenennung: string;
  ZAEHLERSTANDALT, ZAEHLERSTANDNEU : string;

  // Dinge für die freien Zähler "EFRE"
  FreieResourcen: TsTable;
  Sparten: TFieldMapping;
  EFRE_ZAEHLER_NR_NEU: string;
  EFRE: TgpIntegerList;

  // EFRE - Column Cache
  FreieZaehlerCol_ZaehlerNummer: integer;
  FreieZaehlerCol_MaterialNummer: integer;
  FreieZaehlerCol_Zaehlwerk: integer;
  FreieZaehlerCol_Zaehlerstand: integer;
  FreieZaehlerCol_Lager: integer;
  FreieZaehlerCol_Werk: integer;
  FreieZaehlerCol_Sparte: integer;
  FreieZaehlerCol_Obis: integer;

  {$ifdef fpc}
  {$else}
  // Excel-Ausgabe
  FlexCelXLS: TXLSFile;
  {$endif}

  // Excel-Formate
  // Dinge für Protokoll-Text Feld
  fmProtokollText: integer;
  fmInternText: integer;

  // Prüfung doppelte Zählernummer neu
  ZaehlerNummernNeuAusN1: boolean;
  ZaehlerNummernNeuMitA1: boolean;
  ZaehlerNummernNeu: TSearchStringList;
  lZNN_Dupletten: TgpIntegerList;
  DublettenPruefling: string;

  procedure Log(s: string; BAUSTELLE_R: integer = 0; TAN: string = ''); overload;
  begin
    if (BAUSTELLE_R > 0) then
      s := s + ' ' + e_r_BaustelleKuerzel(BAUSTELLE_R);
    if (TAN <> '') then
      s := s + ' ' + TAN;
    _(cFeedBack_ListBox_Add+1,s);
    _(cFeedBack_processmessages);
    AppendStringsToFile(s, ErgebnisLogFName);
  end;

  procedure LogFail(s:string);
  begin
            writePermission := false;
            Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' ' + s, BAUSTELLE_R, Settings.values[cE_TAN]);
            if (FailL.indexof(AUFTRAG_R) = -1) then
              FailL.add(AUFTRAG_R);
  end;

  procedure Log(s: TStrings; BAUSTELLE_R: integer = 0; TAN: string = ''); overload;
  var
    n: integer;
  begin
    for n := 0 to pred(s.count) do
    begin
      if (pos(cE_ZIPPASSWORD, s[n]) = 1) then
        continue;
      if (pos(cE_FTPPASSWORD, s[n]) = 1) then
        continue;
      Log(s[n], BAUSTELLE_R, TAN);
    end;
  end;

  procedure FuelleZaehlerNummerNeu;
  var
    AUFTRAG_R: integer;
    cAUFTRAG: TdboCursor;
    PROTOKOLL: TStringList;
    ART: string;
    z: string;
    PreFix: string;
  begin
    ZaehlerNummernNeu.clear;
    cAUFTRAG := nCursor;
    PROTOKOLL := TStringList.create;
    with cAUFTRAG do
    begin
      sql.add('select RID,ART,ZAEHLER_NR_NEU,PROTOKOLL from AUFTRAG where'); //
      sql.add(' (STATUS<>6) and');
      sql.add(' (BAUSTELLE_R=' + Settings.values[cE_Datenquelle] + ')');
      ApiFirst;
      while not(eof) do
      begin

        // Init
        AUFTRAG_R := FieldByName('RID').AsInteger;
        ART := FieldByName('ART').AsString;
        z := FieldByName('ZAEHLER_NR_NEU').AsString;
        e_r_sqlt(FieldByName('PROTOKOLL'),PROTOKOLL);

        if ZaehlerNummernNeuMitA1 then
          PreFix := PROTOKOLL.values['A1']
        else
          PreFix := '';

        if (z <> '') then
          ZaehlerNummernNeu.addobject(ART + '~' + PreFix + z, pointer(AUFTRAG_R));

        if ZaehlerNummernNeuAusN1 then
        begin
          z := PROTOKOLL.values['N1'];
          if (z <> '') then
            ZaehlerNummernNeu.addobject(ART + '~' + PreFix + z, pointer(AUFTRAG_R));
        end;

        ApiNext;
      end;
    end;
    cAUFTRAG.free;
    PROTOKOLL.free;
    ZaehlerNummernNeu.sort;
  end;

  function EFRE_Filter_ZaehlerNummerNeu(s: string): string;
  var
    _Filter: string;
  begin
    // EFRE- Filter für "Zählernummer Neu"
    _Filter := Settings.values[cE_ZaehlerNummerNeuZeichen];
    if (_Filter <> '') then
      result := StrFilter(s, _Filter)
    else
      result := s;
  end;

//
  function getColumn(ColumnName: string): string;
  var
    RawColumn: integer;
  begin
    RawColumn := Header.indexof(ColumnName);
    if (RawColumn <> -1) then
    begin
      result := ActColumn[RawColumn];
      ersetze(',', '.', result);
      ersetze(';', '', result);
    end
    else
    begin
      result := '';
    end;
  end;

  procedure Fill_EFRE(Row: integer);

    function CheckSet(FieldName: string; Col: integer; valueDefault: string = '') : string;
    begin
      result := '';
      if (FieldName <> '') then
      begin
        result := FreieResourcen.readCell(Row, Col);
        if (result = '') then
          result := valueDefault;
        INTERN_INFO.add(FieldName + '=' + result);
      end;
    end;

    function CheckSetIdentische(FieldName: string; R,C: integer; valueDefault: string = '') : string;
    begin
      result := '';
      if (FieldName <> '') then
      begin
        result := FreieResourcen.readCell(R, C);
        if (result = '') then
          result := valueDefault;
        INTERN_INFO.add(
         { } FieldName +
         { } '.' + IntToStr(succ(R-Row)) +
         { } '=' + result);
      end;
    end;

  var
   IdentischeRow: Integer;
   ZAEHLWERKE_LAGER: string;
  begin
    ZAEHLWERKE_LAGER := '';

    // folgende - zwingend notwendige - Spalten vervollständigen
    CheckSet(Settings.values[cE_MaterialNummerNeu], FreieZaehlerCol_MaterialNummer);
    CheckSet(Settings.values[cE_ZaehlwerkNeu], FreieZaehlerCol_Zaehlwerk, '1');

    // optionale Spalten
    if (FreieZaehlerCol_Lager <> -1) then
      CheckSet('Lager', FreieZaehlerCol_Lager);
    if (FreieZaehlerCol_Werk <> -1) then
      CheckSet('Werk', FreieZaehlerCol_Werk);
    if (FreieZaehlerCol_Obis <> -1) then
      ZAEHLWERKE_LAGER := CheckSet('Obis', FreieZaehlerCol_Obis);

    // gibt es weitere Zeilen mit genau dieser Zählernummer?
    for IdentischeRow := succ(Row) to FreieResourcen.RowCount do
      if (FreieResourcen.readCell(IdentischeRow, FreieZaehlerCol_ZaehlerNummer)=EFRE_ZAEHLER_NR_NEU) then
      begin
        if (FreieZaehlerCol_Lager <> -1) then
          CheckSetIdentische('Lager', IdentischeRow, FreieZaehlerCol_Lager);
        if (FreieZaehlerCol_Werk <> -1) then
          CheckSetIdentische('Werk', IdentischeRow, FreieZaehlerCol_Werk);
        if (FreieZaehlerCol_Obis <> -1) then
          ZAEHLWERKE_LAGER := ZAEHLWERKE_LAGER + ',' + CheckSetIdentische('Obis', IdentischeRow, FreieZaehlerCol_Obis);
     end else
     begin
       break;
     end;

    INTERN_INFO.add(
         { } 'Zaehlwerke_Lager' +
         { } '=' + ZAEHLWERKE_LAGER);

  end;

  procedure PrepareFormat;
  {$ifdef fpc}
  begin

  end;
  {$else}
  var
    fmfm: TFlxFormat;
  begin
    with FlexCelXLS do
    begin

      fmfm := GetDefaultFormat;
      with fmfm do
      begin
        Font.name := 'Courier New';
        Font.Size20 := round(8.0 * 20);
        borders.Left.style := TFlxBorderStyle.Thin;
        borders.Left.color := clblack;
        FillPattern.Pattern := TFlxPatternStyle.Solid;
        FillPattern.BgColor := 0;
        VAlignment := TVFlxAlignment.top;
        FillPattern.FgColor := HTMLColor2TColor($99CCFF);
        WrapText := true;
      end;
      fmProtokollText := addformat(fmfm);

      fmfm := GetDefaultFormat;
      with fmfm do
      begin
        format := '@';
      end;
      fmInternText := addformat(fmfm);

    end;
  end;
  {$endif}

  procedure WriteLine;
  var
    n,c: integer;
    fm: integer;
    s: String;
  begin

    c := 1;
    for n := 0 to pred(ActColumn.count) do
    begin

      // <NULL> -> ''
      s := ActColumn[n];
      if (s=cOLAPnull) then
       s := '';

      // Zell-Formatierung
      fm := -1;
      if (n < Header.count) then
      begin

        if (HeaderSuppress.IndexOf(Header[n])<>-1) then
         continue;

        repeat

          // ganzes Protokoll
          if (Header[n] = 'ProtokollText') then
          begin
            fm := fmProtokollText;
            {$ifdef fpc}
            {$else}
            FlexCelXLS.setcolwidth(c, 340 * 18);
            {$endif}
            break;
          end;

          // q* Felder im Textformat, damit sie keine schadhafte Formatierung erhalten
          if (pos('q', Header[n]) = 1) then
          begin
            fm := fmInternText;
            break;
          end;

          // Ausdrückliche Textfelder
          if (HeaderTextFormat.indexof(Header[n]) <> -1) then
          begin
            fm := fmInternText;
            break;
          end;

        until true;

      end;

      try
        if (fm = -1) then
        begin
          {$ifdef fpc}
          {$else}
          FlexCelXLS.setCellFromString(ExcelWriteRow, c, s, fm);
          {$endif}
        end
        else
        begin
          {$ifdef fpc}
          {$else}
          FlexCelXLS.SetCellFormat(ExcelWriteRow, c, fm);
          FlexCelXLS.SetCellValue(ExcelWriteRow, c, s);
          {$endif}
        end;
      except
        {$ifdef fpc}
        {$else}
        FlexCelXLS.SetCellValue(ExcelWriteRow, c, 'ERROR');
        {$endif}
      end;
      inc(c);
    end;
    inc(ExcelWriteRow);
  end;

  function ZaehlerNrNeuFilter(Zaehler_Nummer_neu: string): string;
  var
    allFilter: string;
    Filter: string;
    Raster: string;
    Maske: string;
    n: integer;
    quellIndex: integer;
    RasterMatch: boolean;
    FilterMatch: boolean;
    ZaehlerNummerNeu_AnzahlStellen: integer;
  begin
    result := Zaehler_Nummer_neu;
    repeat

      // Zeichen für einen Eintrag durch einen Scan
      if (pos('#', Zaehler_Nummer_neu) = 1) then
      begin

        // Original-Scan sichern und unbehandelt kopieren
        if (Header_col_Scan <> -1) then
          ActColumn[Header_col_Scan] := Zaehler_Nummer_neu;

        // Filter-Beispiele
        //
        // #B2********=xxx!!!!!!!x
        // #B2******=xxx!!!!!!

        allFilter := Zaehler_nr_neu_filter;
        FilterMatch := false;
        while (allFilter <> '') do
        begin
          Filter := nextp(allFilter, ',');
          Raster := nextp(Filter, '=', 0);

          // erst mal sehn, ob das Raster passt!
          if (length(Raster) = length(Zaehler_Nummer_neu)) then
          begin

            // Maske anwenden!
            Maske := nextp(Filter, '=', 1);

            RasterMatch := true;
            for n := 1 to length(Zaehler_Nummer_neu) do
            begin
              if (Raster[n] <> '*') then
                if (Raster[n] <> Zaehler_Nummer_neu[n]) then
                begin
                  RasterMatch := false;
                  break;
                end;
            end;

            if RasterMatch then
            begin
              quellIndex := 1;
              result := '';
              for n := 1 to length(Maske) do
              begin
                case Maske[n] of
                  'x':
                    begin
                      inc(quellIndex);
                    end;
                  '!':
                    begin
                      result := result + Zaehler_Nummer_neu[quellIndex];
                      inc(quellIndex);
                    end;
                else
                  result := result + Maske[n];
                end;
              end;
              FilterMatch := true;
              break;
            end;
          end;
        end;

        if not(FilterMatch) then
        begin
          log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' Zählernummer Neu "' + Zaehler_Nummer_neu +
            '" hat keine Filter-Regel!', BAUSTELLE_R, Settings.values[cE_TAN]);
          writePermission := false;
          if (FailL.indexof(AUFTRAG_R) = -1) then
            FailL.add(AUFTRAG_R);
        end;
        break;
      end;

      if (pos(':', Zaehler_nr_neu_filter) = 1) then
      begin

        // Filter= ":" ~AnzahlDerStellen~ {[ "," ":" ~AnzahlDerStellen~ ]}
        FilterMatch := false;
        ZaehlerNummerNeu_AnzahlStellen := length(result);

        allFilter := noblank(Zaehler_nr_neu_filter);
        while (allFilter <> '') do
        begin
          Filter := nextp(allFilter, ',');
          Raster := nextp(Filter, ':', 1);

          if (ZaehlerNummerNeu_AnzahlStellen = StrToIntDef(Raster, -1)) then
          begin
            // Länge passt
            FilterMatch := true;
            break;
          end;
        end;

        if (vSTATUS in [ctvErfolg, ctvErfolgGemeldet]) then
          if not(FilterMatch) then
          begin
            QS_add('[Q27] Anzahl der Stellen ":' + inttostr(ZaehlerNummerNeu_AnzahlStellen) +
              '" von "Zählernummer-Neu" ist nicht erlaubt', sPlausi);
          end;

        break;
      end;

      if (Header_col_Scan <> -1) then
        ActColumn[Header_col_Scan] := '';

    until true;

    // abschliessendes Filtern
    // im Filter sind alle erlaubten Zeichen angegeben
    if (Zaehler_nr_neu_zeichen <> '') then
      result := StrFilter(result, Zaehler_nr_neu_zeichen);

  end;

  procedure SetHeaderNames;
  var
    n, m, c: integer;
    HeaderAliasNames: TStringList;
    AliasNames: string;
    OhneInhaltNames: string;
    NewHeaderName: string;
    InternFelder: TStringList;
    IsMuss, IsRaute: boolean;
    AllCols: TgpIntegerList;
  begin

    // Liste aufbereiten, wie Sie vom System kommt
    HeaderLine := cWordHeaderLine;
    while (HeaderLine <> '') do
      HeaderDefault.add(nextp(HeaderLine, ';'));

    // Red - List mit default füllen!
    HeaderLine := cRedHeaderLine;
    while (HeaderLine <> '') do
      HeaderSuppress.add(nextp(HeaderLine, ';'));

    // Red - List erweitern!
    HeaderLine := cutblank(Settings.values[cE_verboteneSpalten]);
    while (HeaderLine <> '') do
      HeaderSuppress.add(cutblank(nextp(HeaderLine, ';')));

    // am Anfang stehen die vorgegebenen Titelspalten.
    // kommt es nicht vom "System" muss es ein "Intern"-Feld sein.
    HeaderLine := Settings.values[cE_SAPReihenfolge];
    while (HeaderLine <> '') do
    begin
      HeaderName := cutblank(nextp(HeaderLine, ';'));
      if (HeaderName <> '') then
      begin

        IsMuss := false;
        IsRaute := false;

        if (pos('!', HeaderName) > 0) then
        begin
          ersetze('!', '', HeaderName);
          IsMuss := true;
        end;

        if (pos('#', HeaderName) > 0) then
        begin
          ersetze('#', '', HeaderName);
          IsRaute := true;
        end;

        // Steht der Name ausdrücklich in der Spaltenreihenfolge
        // so wird er nicht mehr unterdrückt!
        n := HeaderSuppress.indexof(HeaderName);
        if (n<>-1) then
          HeaderSuppress.delete(n);

        // Den Feldnamen jetzt zu den einzelnen Listen hinzunehmen!
        if (HeaderDefault.indexof(HeaderName) = -1) then
          if (ProtokollFeldNamen.indexof(HeaderName) = -1) then
            HeaderFromIntern.add(HeaderName);

        Header.add(HeaderName);
        if IsMuss then
          MussFelder.add(HeaderName);
        if IsRaute then
          RauteFelder.add(HeaderName);

      end;
    end;

    // nun alle fehlenden Spaltenüberschriften hinzunehmen (wenn nicht schon vorhanden)
    for n := 0 to pred(HeaderDefault.count) do
    begin
      if (HeaderSuppress.indexof(HeaderDefault[n]) = -1) then
        if (Header.indexof(HeaderDefault[n]) = -1) then
          Header.add(HeaderDefault[n]);
    end;

    // nun alle Protokollfelder hinzunehmen (wenn nicht schon vorhanden)
    for n := 0 to pred(ProtokollFeldNamen.count) do
      if (HeaderSuppress.indexof(ProtokollFeldNamen[n]) = -1) then
        if (Header.indexof(ProtokollFeldNamen[n]) = -1) then
          Header.add(ProtokollFeldNamen[n]);

    // nun alle InternFelder hinzunehmen (wenn nicht schon vorhanden)
    if (Settings.values[cE_InternInfos] = cINI_Activate) then
    begin
      InternFelder := TStringList.create;
      e_r_InternExport(BAUSTELLE_R, InternFelder);
      for n := 0 to pred(InternFelder.count) do
      begin
        HeaderName := InternFelder[n];
        if (HeaderSuppress.indexof(HeaderName) = -1) then
          if (Header.indexof(HeaderName) = -1) then
          begin
            Header.add(HeaderName);
            HeaderFromIntern.add(HeaderName);
          end;
      end;
      InternFelder.free;
    end;

    // nun noch errechnete Spalten hinzunehmen
    if (Zaehler_nr_neu_filter <> '') then
    begin
      //
      if (Header.indexof('Scan_Zaehler_Nummer_Neu') = -1) then
        Header.add('Scan_Zaehler_Nummer_Neu');
      Header_col_Scan := Header.indexof('Scan_Zaehler_Nummer_Neu');
    end;

    // Alias / Umbenennung der Spaltenüberschriften
    HeaderAliasNames := TStringList.create;
    AliasNames := Settings.values[cE_SpaltenAlias];
    while (AliasNames <> '') do
      HeaderAliasNames.add(nextp(AliasNames, ';'));
    c := 1;
    for n := 0 to pred(Header.count) do
    begin
        if (HeaderSuppress.IndexOf(Header[n])<>-1) then
         continue;
        NewHeaderName := HeaderAliasNames.values[Header[n]];
        if (NewHeaderName = '') then
          NewHeaderName := Header[n];
{$ifdef fpc}
        // imp pend
{$else}
        FlexCelXLS.SetCellValue(1, c, NewHeaderName);
{$endif}
        inc(c);
    end;
    HeaderAliasNames.free;

    // Spalten ohne Inhalt
    OhneInhaltNames := Settings.values[cE_SpaltenOhneInhalt];
    if (OhneInhaltNames = '') then
      OhneInhaltNames := 'Bemerkung';
    OhneInhaltFelder.free;
    OhneInhaltFelder := Split(OhneInhaltNames);

    // "Index-Liste" aufbauen, Beispiel:
    // A;B;C;A -> [0,3];[1];[2];[0,3]
    //
    for n := 0 to pred(Header.count) do
    begin
      AllCols := TgpIntegerList.create;
      for m := 0 to pred(Header.count) do
        if Header[n] = Header[m] then
          AllCols.add(m);
      Header.objects[n] := AllCols;
    end;

  end;

  function SetCell(ActColIndex: integer; Value: string): boolean; overload;
  var
    n: integer;
    AllCols: TgpIntegerList;
    c: integer;
    UmsetzerName: string;
    _Value: string;
  begin
    result := false;
    if (ActColIndex <> -1) then
    begin

      // Zwang zu ohne Inhalt
      if (Value <> '') then
        if (OhneInhaltFelder.indexof(Header[ActColIndex]) <> -1) then
          Value := '';

      // Raute
      if (Value <> '') then
        if (RauteFelder.indexof(Header[ActColIndex]) <> -1) then
        begin
          if (pos('E', Value) > 0) then
            Value := inttostr(round(strtodouble(Value)));

          if (pos('#', Value) <> 1) then
            Value := '#' + Value;
        end;

      // Umsetzer
      try
        Value := Umsetzer[Header[ActColIndex], Value];
      except
        on e: exception do
        begin
          writePermission := false;
          Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ') Umsetzer "' + Header[ActColIndex] + '.ini":' + e.message,
            BAUSTELLE_R, Settings.values[cE_TAN]);
          if (FailL.indexof(AUFTRAG_R) = -1) then
            FailL.add(AUFTRAG_R);
        end;
      end;

      AllCols := TgpIntegerList(Header.objects[ActColIndex]);
      for n := 0 to pred(AllCols.count) do
      begin
        c := AllCols[n];
        UmsetzerName := 'Column_' + inttostr(succ(c));
        try
          _Value := Umsetzer[UmsetzerName, Value];
        except
          on e: exception do
          begin
            writePermission := false;
            Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ') Umsetzer "' + UmsetzerName + '.ini":' + e.message,
              BAUSTELLE_R, Settings.values[cE_TAN]);
            if (FailL.indexof(AUFTRAG_R) = -1) then
              FailL.add(AUFTRAG_R);
          end;
        end;
        ActColumn[c] := _Value;
      end;
      result := true;
    end;
  end;

  function SetCell(ColumName: string; Value: string): boolean; overload;
  begin
    result := SetCell(Header.indexof(ColumName), Value);
  end;

  function evalColumnExpression(e: string): string;
  var
    Token, Value: string;
    Col: integer;
  begin
    result := e;
    while (pos('~', result) > 0) do
    begin
      Token := ExtractSegmentBetween(result, '~', '~');
      Col := Header.indexof(Token);
      if (Col <> -1) then
        Value := ActColumn[Col]
      else
        Value := 'REF!';
      ersetze('~' + Token + '~', Value, result);
    end;
  end;

  procedure Q_CheckFotoFile(f: string; AUFTRAG_R: integer; Parameter: string);
  var
    FNameA, FNameB, FNameC: string;
  begin
    FNameA := nextp(f, ',', 0);
    if (FNameA <> '') then
    begin

      repeat

        // Prüfung A
        FNameA := e_r_FotoPfad(fp_Deliver, AUFTRAG_R) + FNameA;
        if FileExists(FNameA) then
          break;

        // Prüfung B
        FNameB :=
          e_r_FotoPfad(fp_Deliver, AUFTRAG_R) + nextp(
          e_r_FotoName(
            fp_Deliver,
            AUFTRAG_R,
            Parameter,
            '',
            cFoto_Option_AktuelleNummer), ',', 0);
        if FileExists(FNameB) then
          break;

        // Prüfung C
        FNameC :=
          e_r_FotoPfad(fp_Deliver,AUFTRAG_R) + nextp(
          e_r_FotoName(
           fp_Deliver,
           AUFTRAG_R,
           Parameter,
           '',
           cFoto_Option_AktuelleNummer+';'+cFoto_Option_NeuLeer), ',', 0);
        if (FNameC<>FNameB) then
         if FileExists(FNameC) then
         begin
           FileMove(FNameC, FNameB);
           break;
         end;

        if (FNameA = FNameB) and (FNameB = FNameC) then
        begin
          QS_add('[Q25] '+Parameter+': Bild-Datei "' + FNameA + '" existiert nicht', sPlausi);
          break;
        end;

        if (FNameA<>FNameB) and (FNameB=FNameC) then
        begin
          QS_add('[Q25] '+Parameter+': Bild-Datei "' + FNameA + '" sowie "' + FNameB + '" existieren nicht', sPlausi);
          break;
        end;

        QS_add('[Q25] '+Parameter+': Bild-Datei "' + FNameA + '" sowie "' + FNameB + '" und "' + FNameC + '" existieren nicht', sPlausi);

      until yet;
    end;
  end;

  procedure CheckFailElements;
  var
   n : Integer;
   FAIL_R: Integer;
  begin
    for n := 0 to pred(Oc_Bericht.count) do
      if (pos('(RID=', Oc_Bericht[n]) > 0) then
      begin
        FAIL_R := StrToIntDef(ExtractSegmentBetween(Oc_Bericht[n], '(RID=', ')'), cRID_unset);
        if (FAIL_R<>cRID_unset) then
        begin
         if (FailL.indexof(FAIL_R) = -1) then
         begin
           FailL.add(FAIL_R);
           Log(cERRORText + ' ' + Oc_Bericht[n], BAUSTELLE_R, Settings.values[cE_TAN]);
         end else
         begin
           Log(cERRORText + ' +' + Oc_Bericht[n], BAUSTELLE_R, Settings.values[cE_TAN]);
         end;
        end else
        begin
           Log(cERRORText + ' ?' + Oc_Bericht[n], BAUSTELLE_R, Settings.values[cE_TAN]);
        end;
      end;
  end;

  function getFrom(zSetting: String):string;
  var
   ColList: string;
   SingleCol: string;
   ActColIndex: Integer;
  begin
    ColList := Settings_Zaehlwerke.Values[zSetting];
    if (ColList<>'') then
    begin
      repeat
        SingleCol := nextp(ColList,',');
        ActColIndex := Header.indexof(SingleCol);
        if (ActColIndex<>-1) then
        begin
          result := ActColumn[ActColIndex];
          if (result<>'') then
           exit;
        end else
        begin
          LogFail('Spalte "'+SingleCol+'" wird benötigt');
          ZW_Value := '';
        end;
      until eternity;
    end else
    begin
      LogFail(zSetting+'= nicht in "' + Settings_Zaehlwerke_FName + '" gefunden');
      result := '';
    end;
  end;

var
  Q_Umfang: TStringList;

  procedure Q_Umfang_FillFrom(Setting: String);
  begin
    Q_Umfang := split(Settings.Values[Setting+'-'+ART]);
    noblank(Q_Umfang);
    if (Q_Umfang.Count=0) then
    begin
     Q_Umfang.Free;
     Q_Umfang := split(Settings.Values[Setting]);
     noblank(Q_Umfang);
    end;
  end;

var
  n, k, y: integer;
  Cmd: string;
  PDF: TStringList;
  PDF_ResultInfoStr : string;
  PDF_FromWhat: string;

  Q_CheckTarget: String;

begin
  ErrorCount := 0;
  BAUSTELLE_R := 0;
  vSTATUS := ctvDatenFehlen;

  //
  FreieZaehlerCol_ZaehlerNummer := -1;
  FreieZaehlerCol_MaterialNummer := -1;
  FreieZaehlerCol_Zaehlwerk := -1;
  FreieZaehlerCol_Zaehlerstand := -1;
  FreieZaehlerCol_Lager := -1;
  FreieZaehlerCol_Werk := -1;
  FreieZaehlerCol_Sparte := -1;
  FreieZaehlerCol_Obis := -1;
  col_ZaehlwerkName_Ausbau := -1;
  col_ZaehlwerkName_Einbau := -1;
  col_ZaehlerStandAlt := -1;
  col_ZaehlerStandNeu := -1;

  LinesL := TList.create;
  ProtokollFeldNamen := TStringList.create;
  ProtokollWerte := TStringList.create;
  Settings_Zaehlwerke := TStringList.create;
  FreieResourcen := TsTable.create;
  Sparten := TFieldMapping.create;

  ActColumn := TStringList.create;
  MussFelder := TStringList.create;
  RauteFelder := TStringList.create;
  OhneInhaltFelder := TStringList.create;

  ZaehlerNummernNeu := TSearchStringList.create;
{$ifdef fpc}
{$else}
  FlexCelXLS := TXLSFile.create(true);
{$endif}

  try
    _(cFeedBack_ProgressBar_max+1,IntTOStr( RIDs.count));
    _(cFeedBack_ProgressBar_position+1);

{$ifdef fpc}
// imp pend
{$else}
    with FlexCelXLS do
{$endif}
    begin

      if (Settings.values[cE_FreieZaehler] <> '') then
      begin

        // Freie Zähler laden
        if FileExists(cAuftragErgebnisPath + Settings.values[cE_FreieZaehler]) then
        begin

          // Sparten Umsetzer (im normalen Export-Verzeichnis)
          Sparten.Path := cAuftragErgebnisPath + e_r_BaustellenPfad(Settings);

          // FehlendeResourcen
          FileDelete(nichtEFREFName(Settings));

          // Laden der EFRE - Datei
          with FreieResourcen do
          begin

            oNoBlank := Settings.values[cE_FreieZaehler_ErhalteBlanks] <> cIni_Activate;
            oDistinct := true;
            insertFromFile(cAuftragErgebnisPath + Settings.values[cE_FreieZaehler]);

            FreieZaehlerCol_ZaehlerNummer := colof('Serialnummer');
            if (FreieZaehlerCol_ZaehlerNummer = -1) then
              raise exception.create(Settings.values[cE_FreieZaehler] + ': Spalte "Serialnummer" fehlt');

            //
            FreieZaehlerCol_MaterialNummer := colof('MaterialNo');
            if (FreieZaehlerCol_MaterialNummer = -1) then
              raise exception.create(Settings.values[cE_FreieZaehler] + ': Spalte "MaterialNo" fehlt');

            //
            FreieZaehlerCol_Zaehlwerk := colof('ZWrk');
            if (FreieZaehlerCol_Zaehlwerk = -1) then
              raise exception.create(Settings.values[cE_FreieZaehler] + ': Spalte "ZWrk" fehlt');

            //
            FreieZaehlerCol_Zaehlerstand := colof('Stand');
            if (FreieZaehlerCol_Zaehlerstand = -1) then
              raise exception.create(Settings.values[cE_FreieZaehler] + ': Spalte "Stand" fehlt');

            // Optionale Felder!
            FreieZaehlerCol_Lager := colof('Lager');
            FreieZaehlerCol_Werk := colof('Werk');
            FreieZaehlerCol_Sparte := colof('Sparte');
            FreieZaehlerCol_Obis := colof('Obis');

            // Umkonvertierungen
            for n := 1 to pred(count) do
            begin

              // Zählernummer Neu
              WriteCell(n, FreieZaehlerCol_ZaehlerNummer,
                EFRE_Filter_ZaehlerNummerNeu(readCell(n, FreieZaehlerCol_ZaehlerNummer)));

              // Sparten
              if (FreieZaehlerCol_Sparte <> -1) then
                WriteCell(n, FreieZaehlerCol_Sparte, Sparten[cMapping_EFRE_Sparten,
                  readCell(n, FreieZaehlerCol_Sparte)]);

            end;
          end;

          // Diagnose speichern
          FreieResourcen.SaveToFile(
            { } cAuftragErgebnisPath +
            { } e_r_BaustellenPfad(Settings) + '\' +
            { } 'Diagnose-EFRE.csv');
        end
        else
        begin
          raise exception.create(cAuftragErgebnisPath + Settings.values[cE_FreieZaehler] + ' fehlt!');
        end;

      end;

      // Datei neu erstellen
      {$ifdef fpc}
      {$else}
      NewFile(1);
      {$endif}
      PrepareFormat;

      // Einstellungen laden
      BAUSTELLE_R := strtoint(Settings.values[cE_BAUSTELLE_R]);
      Zaehlwerk := Settings.values[cE_Zaehlwerk];
      zaehlwerke := (Zaehlwerk=cINI_Activate);
      if zaehlwerke then
      begin
        Settings_Zaehlwerke_FName :=
          {} cAuftragErgebnisPath + e_r_BaustellenPfad(Settings) +
          {} '\' +
          {} 'Zaehlwerke.ini';
        if FileExists(Settings_Zaehlwerke_FName) then
          Settings_Zaehlwerke.LoadFromFile(Settings_Zaehlwerke_FName)
        else
          Log(cERRORText + ' Datei "' + Settings_Zaehlwerke_FName + '" fehlt!', BAUSTELLE_R, Settings.values[cE_TAN]);
      end;

      Zaehler_nr_neu_filter := Settings.values[cE_Filter];
      Zaehler_nr_neu_zeichen := Settings.values[cE_ZaehlerNummerNeuZeichen];
      // das hier gar nicht mehr cachen
      // imp pend: sondern immer frisch lesen, also mit
      // Settings.values[cE_HTMLBenennung+'-'+Vorgang];
      HTMLBenennung := Settings.values[cE_HTMLBenennung];
      PlausiMode := StrToIntDef(Settings.values[cE_QS_Mode], 4);

      // =JA oder =FA oder =FA;FN
      AuchMitFoto :=
      { } (Settings.values[cE_AuchMitFoto] <> cIni_DeActivate) and
      { } (Settings.values[cE_AuchMitFoto] <> '') and
      { } (FotoPath <> '');
      if AuchMitFoto then
      begin
        if (Settings.values[cE_AuchMitFoto] = cINI_Activate) then
          FotoSpalten := 'FA'
        else
          FotoSpalten := Settings.values[cE_AuchMitFoto];
      end
      else
        FotoSpalten := '';


      ZaehlerNummernNeuAusN1 := (Settings.values[cE_ZaehlerNummerNeuAusN1] <> cIni_DeActivate);
      ZaehlerNummernNeuMitA1 := (Settings.values[cE_ZaehlerNummerNeuMitA1] = cINI_Activate);

      cINTERNINFO := nCursor;
      cINTERNINFO.sql.add(
       {} 'select '+
       {} ' INTERN_INFO,'+
       {} ' ERGEBNIS_INFO,'+
       {} ' ZAEHLER_NR_NEU,'+
       {} ' ZAEHLER_STAND_NEU '+
       {} 'from AUFTRAG where RID=:CROSSREF');
      INTERN_INFO := TStringList.create;
      ERGEBNIS_INFO := TStringList.create;

      // Header ermitteln und schreiben
      HeaderDefault := TStringList.create; // so kommt es vom System!
      Header := TStringList.create; // so nehmen wir es!
      Header_col_Scan := -1;

      HeaderFromIntern := TStringList.create;
      // die kommen aus den intern Feldern
      HeaderSuppress := TStringList.create; // unerwünschte Daten
      Umsetzer := TFieldMapping.create;
      // Spalten, die als "Text" formatiert werden müssen
      HeaderTextFormat := Split(Settings.values[cE_SpalteAlsText]);
      HeaderTextFormat.sort;
      Umsetzer.Path := cAuftragErgebnisPath + e_r_BaustellenPfad(Settings);
      e_r_ProtokollExport(BAUSTELLE_R, ProtokollFeldNamen);
      ProtokollMode := (ProtokollFeldNamen.count > 0);

      // Excel-Titel-Zeile erzeugen
      SetHeaderNames;

      // Liste der bisherigen Z# Neu erstellen
      FuelleZaehlerNummerNeu;

      // "leere" Zeile vorbereiten
      ActColumn.clear;
      for n := 0 to pred(Header.count) do
        ActColumn.add('');

      // Spaltenindex bestimmen
      if zaehlwerke then
      begin
        col_ZaehlwerkName_Ausbau := Header.indexof(Settings_Zaehlwerke.values['Ausbau']);
        col_ZaehlwerkName_Einbau := Header.indexof(Settings_Zaehlwerke.values['Einbau']);
        col_ZaehlerStandAlt := Header.indexof('ZaehlerStandAlt');
        col_ZaehlerStandNeu := Header.indexof('ZaehlerStandNeu');
      end;

      // nun die einzelnen Daten schreiben
      ExcelWriteRow := 2;
      for n := 0 to pred(RIDs.count) do
      begin

        AUFTRAG_R := integer(RIDs[n]);
        zweizeilig := false;
        writePermission := true;
        sPlausi := ''; // Qualitätssicherung [Qnn] System initialisieren

        _(cFeedBack_ProgressBar_position + 1, IntToStr(n));
        _(cFeedBack_processmessages);

        // normale Daten - Spalten
        ProtokollWerte.clear;
        DataLine := e_r_AuftragLine(AUFTRAG_R);
        k := 0;
        while (DataLine <> '') do
        begin
          ActValue := nextp(DataLine, ';');
          repeat

            if (k = twh_Protokoll) then
            begin
              while (ActValue <> '') do
                ProtokollWerte.add(nextp(ActValue, cProtokollTrenner));
              break;
            end;

            if (k = twh_ZaehlerNummerNeu) then
            begin
              ActValue := ZaehlerNrNeuFilter(ActValue);
              ZAEHLER_NR_NEU := ActValue;
            end;

            if (k = twh_Status1) then
              vSTATUS := TeVirtualPhaseStatus(StrToIntDef(ActValue, ord(ctvDatenFehlen)));

            if (k = twh_ART) then
            begin
              ART := ActValue;
              Sparte := Sparten[cMapping_EFRE_Sparten, ART];
            end;

            SetCell(HeaderDefault[k], ActValue);

          until true;
          inc(k);
        end;

        // N1, A1 aus Protokollspalten
        // KommaCheck für alle Protokollspalten
        for k := 0 to pred(ProtokollFeldNamen.count) do
        begin
          ActValue := KommaCheck(ProtokollWerte.values[ProtokollFeldNamen[k]]);

          if (ProtokollFeldNamen[k] = 'N1') then
            N1 := ActValue;
          if (ProtokollFeldNamen[k] = 'A1') then
            A1 := ActValue;

          SetCell(ProtokollFeldNamen[k], ActValue);
        end;

        // Protokoll als Text auffüllen
        ActColIndex := Header.indexof('ProtokollText');
        if (ActColIndex <> -1) then
          SetCell(ActColIndex,'PROT');

        // Zusätzliche Felder lesen
        with cINTERNINFO do
        begin
          ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
          ApiFirst;
          e_r_sqlt(FieldByName('INTERN_INFO'),INTERN_INFO);
          if (Zaehlwerk <> '') then
          begin
            INTERN_INFO.add('ZaehlwerkMitArt=' + ART + '-1');
            INTERN_INFO.add(Zaehlwerk + '=1');
          end;

          e_r_sqlt(FieldByName('ERGEBNIS_INFO'),ERGEBNIS_INFO);
          // Q-System umgehen
          if (ERGEBNIS_INFO.values['QS_UMGANGEN'] <> '') then
            QS_add('[Q12] Qualitätssicherung übergangen', sPlausi);

          // Q-System soll einen Stop auslösen
          if (ERGEBNIS_INFO.values['QS_NOGO'] <> '') then
            QS_add('[Q26] QS_NOGO ist gesetzt, ev. Nacharbeiten notwendig', sPlausi);

          // aus den normalen Daten
          EFRE_ZAEHLER_NR_NEU := EFRE_Filter_ZaehlerNummerNeu(FieldByName('ZAEHLER_NR_NEU').AsString);
          zaehler_stand_neu := strtodoubledef(FieldByName('ZAEHLER_STAND_NEU').AsString, 0);

          // aus den intern Feldern
          material_nummer_alt := INTERN_INFO.values[Settings.values[cE_MaterialNummerAlt]];
          close;
        end;

        // Nun noch die Intern Infos übernehmen
        if (HeaderFromIntern.count > 0) then
        begin

          if (FreieResourcen.count > 0) and (EFRE_ZAEHLER_NR_NEU <> '') then
          begin

            // Gib die Liste der Einträge mit passender Zählernummer
            EFRE := FreieResourcen.locateDuplicates(FreieZaehlerCol_ZaehlerNummer, EFRE_ZAEHLER_NR_NEU);

            FoundLine := -1;
            repeat

              if (FreieZaehlerCol_Sparte <> -1) then
              begin

                // Wenn die Spalte "Sparte" vorhanden ist wird sie auch ausgewertet
                // Es Treffer MUSS dann auch in der Sparte passen
                for k := 0 to pred(EFRE.count) do
                  if (FreieResourcen.readCell(EFRE[k], FreieZaehlerCol_Sparte) = Sparte) then
                  begin
                    FoundLine := EFRE[k];
                    Fill_EFRE(FoundLine);
                    break;
                  end;

              end
              else
              begin

                // erst Kombination "SerialNummer" & "MaterialNummer" versuchen!
                if (material_nummer_alt<>'') then
                  for k := 0 to pred(EFRE.count) do
                    if (FreieResourcen.readCell(EFRE[k], FreieZaehlerCol_MaterialNummer) = material_nummer_alt) then
                    begin
                      FoundLine := EFRE[k];
                      Fill_EFRE(FoundLine);
                      break;
                    end;
                if (FoundLine <> -1) then
                  break;

                // Jetzt einfach nur den ersten Treffer nehmen
                if (EFRE.count > 0) then
                begin
                  FoundLine := EFRE[0];
                  Fill_EFRE(FoundLine);
                  break;
                end;

              end;

            until true;

            EFRE.free;

            if (FoundLine = -1) then
            begin

              writePermission := false;
              inc(Stat_nichtEFRE);

              // Fehler Berichten

              // Sparte relevant JA/NEIN
              if (FreieZaehlerCol_Sparte <> -1) then
              begin
                Stat_FehlendeResourcen.add(
                  { } Sparte + ';' +
                  { } EFRE_ZAEHLER_NR_NEU + ';' +
                  { } material_nummer_alt + ';' +
                  { } Settings.values[cE_TAN] + ';' +
                  { } inttostr(AUFTRAG_R) + ';' +
                  { } ZAEHLER_NR_NEU);
                Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' Resource Sparte+Zählernummer "' + Sparte +
                  '"+"' + EFRE_ZAEHLER_NR_NEU + '" nicht gefunden!', BAUSTELLE_R, Settings.values[cE_TAN])
              end
              else
              begin
                Stat_FehlendeResourcen.add(
                  { } '*' + ';' +
                  { } EFRE_ZAEHLER_NR_NEU + ';' +
                  { } material_nummer_alt + ';' +
                  { } Settings.values[cE_TAN] + ';' +
                  { } inttostr(AUFTRAG_R) + ';' +
                  { } ZAEHLER_NR_NEU);
                Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' Resource Zählernummer "' + EFRE_ZAEHLER_NR_NEU
                  + '" nicht gefunden!', BAUSTELLE_R, Settings.values[cE_TAN]);
              end;

              //
              if (FailL.indexof(AUFTRAG_R) = -1) then
              begin
                FailL.add(AUFTRAG_R);
              end;

            end
            else
            begin

              // Plausibilität Zählerstand "neu" prüfen
              zaehler_stand_neu_soll :=
                strtodoubledef(FreieResourcen.readCell(FoundLine, FreieZaehlerCol_Zaehlerstand), -1);

              if (zaehler_stand_neu_soll > 0) then
              begin
                if (abs(zaehler_stand_neu - zaehler_stand_neu_soll) > 35.0) then
                  QS_add(format('[Q22] Einbaustand falsch (Zählerstand-EFRE=%.0f <> Zählerstand-Monteur=%.0f)',
                    [zaehler_stand_neu_soll, zaehler_stand_neu]), sPlausi);
              end;

              // zumindest für dieses Mal diese Zeile löschen
              FreieResourcen.del(FoundLine);
            end;

          end;

          // Jetzt noch die Intern-Namen einfügen!
          for k := 0 to pred(HeaderFromIntern.count) do
          begin
            HeaderName := HeaderFromIntern[k];
            ActColIndex := Header.indexof(HeaderName);
            if (ActColIndex <> -1) then
            begin
              repeat

                // "c" Felder (calculated, berechnet)

                // custom: aus dem neuen Zähler "+009" wegschneiden
                if (HeaderName = 'cZaehlerNummerEinbau') then
                begin
                  if (length(ZAEHLER_NR_NEU) = 11) then
                    if (pos('+009', ZAEHLER_NR_NEU) = 1) then
                    begin
                      ActValue := copy(ZAEHLER_NR_NEU, 2, 9);
                      break;
                    end;
                end;

                // WechselMoment als DateTime-Feld
                if (HeaderName = 'cWechselMoment') then
                begin
                 ActValue :=
                  {} ActColumn[Header.indexof('WechselDatum')] + ' ' +
                  {} ActColumn[Header.indexof('WechselZeit')];
                 break;
                end;

                // cFA, cFN, cFH ...
                if (length(HeaderName) = 3) then
                  if (pos('cF', HeaderName) = 1) then
                  begin
                    ActValue := nextp(e_r_FotoName(
                      { } fp_Deliver,
                      { } AUFTRAG_R,
                      { } copy(HeaderName, 2, 2),
                      { } '',
                      { } cFoto_Option_AktuelleNummer),
                      { } ',', 0);
                    break;
                  end;

                // dFA, dFN, dFH ...
                if (length(HeaderName) = 3) then
                  if (pos('dF', HeaderName) = 1) then
                  begin
                    ActValue := nextp(e_r_FotoName(
                      { } fp_Deliver,
                      { } AUFTRAG_R,
                      { } copy(HeaderName, 2, 2),
                      { } '',
                      { } cFoto_Option_AktuelleNummer),
                      { } ',', 0);
                    if not(FileExists(
                      e_r_FotoPfad(fp_Deliver,AUFTRAG_R)+ActValue)) then
                      ActValue := '';
                    break;
                  end;

                // Dateiname für die HTML Ausgabe
                if (HeaderName = cE_HTMLBenennung) then
                  if (HTMLBenennung <> '') then
                  begin
                    ActValue := StrFilter(evalColumnExpression(HTMLBenennung),cInvalidFNameChars+'.',true);
                    break;
                  end;

                ActValue := KommaCheck(INTERN_INFO.values[HeaderName]);
              until yet;
              SetCell(ActColIndex, ActValue);
            end;
          end;

          // Jetzt noch ev. das Zw = 2 schreiben
          if not(zaehlwerke) then
            if (Zaehlwerk <> '') then
            begin


              // Bei der Art "2" sollten Nebentarif-Stände da sein!
              ZaehlwerkeIst := StrToIntDef(StrFilter(ART, '0123456789'), 1);

              if (ZaehlwerkeIst > 1) then
              begin

                zweizeilig := true;

                // Nebentarif alter Zähler
                ActColIndex := Header.indexof('NA');
                if (ActColIndex <> -1) then
                  NA := ActColumn[ActColIndex];

                // Nebentarif neuer Zähler
                ActColIndex := Header.indexof('NN');
                if (ActColIndex <> -1) then
                  NN := ActColumn[ActColIndex];

                ActColIndex := Header.indexof('Sparte');
                if (ActColIndex <> -1) then
                  Sparte := ActColumn[ActColIndex]
                else
                  Sparte := '?';

                if (Settings.values[cE_EinsZuEins] <> cIni_DeActivate) and (vSTATUS in [ctvErfolg, ctvErfolgGemeldet])
                then
                begin
                  // HIER DIE PLAUSIBILITÄTSPRÜFUNGEN

                  // Plausi für Nebentarif Alt
                  if (Sparte <> 'Einbau') then
                    if (NA = '') then
                    begin
                      writePermission := false;
                      Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' Alter Zähler: Nebentarif NA fehlt!',
                        BAUSTELLE_R, Settings.values[cE_TAN]);
                      if (FailL.indexof(AUFTRAG_R) = -1) then
                        FailL.add(AUFTRAG_R);
                    end;

                  // Plausi für Nebentarif Neu
                  if (Sparte <> 'Ausbau') then
                    if (NN = '') then
                    begin
                      writePermission := false;
                      Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' Neuer Zähler: Nebentarif NN fehlt!',
                        BAUSTELLE_R, Settings.values[cE_TAN]);
                      if (FailL.indexof(AUFTRAG_R) = -1) then
                        FailL.add(AUFTRAG_R);
                    end;
                end;
              end;

          end;
        end; // Aufgaben von Internfeldern

        // Überprüfung der Zwangsfelder, Mussfelder, ('!'), 'HeaderName!'
        if writePermission then
        begin
          if (vSTATUS in [ctvErfolg, ctvErfolgGemeldet]) then
          begin

            // Mussfelder zusammenbauen
            Mussfelder_Mehr := split(
             Settings.values['Mussfelder-'+ART] + ';' +
             Settings.values['Mussfelder'] );
            noblank(Mussfelder_Mehr);
            Mussfelder_Mehr.AddStrings(MussFelder);

            // Mussfelder Einzelprüfung
            for k := 0 to pred(MussFelder_Mehr.count) do
            begin
              ActColIndex := Header.indexof(MussFelder_Mehr[k]);
              if (ActColIndex <> -1) then
                if (noblank(ActColumn[ActColIndex]) = '') then
                begin
                  writePermission := false;
                  Log(
                    {} cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ')' +
                    {} ' Mussfeld "' + MussFelder_Mehr[k] + '" hat keinen Eintrag',
                    {} BAUSTELLE_R, Settings.values[cE_TAN]);
                  if (FailL.indexof(AUFTRAG_R) = -1) then
                    FailL.add(AUFTRAG_R);
                end;
            end;
            Mussfelder_Mehr.free;

          end;
        end;

        if writePermission then
        begin

          case PlausiMode of
            0:
              ; // Aus!
            1:
              QS_add(e_r_AuftragPlausi(AUFTRAG_R), sPlausi);
            2:
              begin
                if (vSTATUS in [ctvErfolg, ctvErfolgGemeldet]) then
                begin

                  ActColIndex := Header.indexof('ZaehlerStandAlt');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    QS_add('[Q01] Kein Ausbaustand', sPlausi);

                  ActColIndex := Header.indexof('ZaehlerNummerNeu');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                  begin
                    ActColIndex := Header.indexof('N1');
                    if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                      QS_add('[Q02] Kein Einbauzähler', sPlausi);
                  end;

                  ActColIndex := Header.indexof('ZaehlerStandNeu');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    QS_add('[Q03] Kein Einbaustand', sPlausi);

                  ActColIndex := Header.indexof('Art');
                  ZaehlwerkeIst := StrToIntDef(StrFilter(ActColumn[ActColIndex], '0123456789'), 1);

                  if (ZaehlwerkeIst > 1) then
                  begin

                    // Nebentarif alter Zähler
                    ActColIndex := Header.indexof('NA');
                    if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                      QS_add('[Q04] Kein Nebentarif Ausbaustand', sPlausi);

                    // Nebentarif neuer Zähler
                    ActColIndex := Header.indexof('NN');
                    if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                      QS_add('[Q05] Kein Nebentarif Einbaustand', sPlausi);

                  end;

                end;
              end;
            3:
              begin
                if (vSTATUS in [ctvErfolg, ctvErfolgGemeldet]) then
                begin

                  ActColIndex := Header.indexof('ZaehlerStandAlt');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    QS_add('[Q01] Kein Ausbaustand', sPlausi);

                  ActColIndex := Header.indexof('ZaehlerNummerNeu');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                  begin
                    ActColIndex := Header.indexof('N1');
                    if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                      QS_add('[Q02] Kein Einbauzähler', sPlausi);
                  end;

                  ActColIndex := Header.indexof('ZaehlerStandNeu');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    QS_add('[Q03] Kein Einbaustand', sPlausi);

                end;

                if (vSTATUS in [ctvVorgezogen, ctvUnmoeglich, ctvVorgezogenGemeldet, ctvUnmoeglichGemeldet]) then
                begin
                  k := 0;
                  ActColIndex := Header.indexof('I3');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    inc(k);
                  ActColIndex := Header.indexof('I6');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    inc(k);
                  ActColIndex := Header.indexof('I7');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    inc(k);
                  if (k = 3) then
                    QS_add('[Q20] Keine Anmerkung des Monteurs', sPlausi);
                end;

              end;
            4: // Default!
              begin

                if (vSTATUS in [ctvErfolg, ctvErfolgGemeldet]) then
                begin

                  ActColIndex := Header.indexof('ZaehlerStandAlt');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    QS_add('[Q01] Kein Ausbaustand', sPlausi);

                  ActColIndex := Header.indexof('ZaehlerNummerNeu');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                  begin
                    ActColIndex := Header.indexof('N1');
                    if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                      QS_add('[Q02] Kein Einbauzähler', sPlausi);
                  end;

                  ActColIndex := Header.indexof('ZaehlerStandNeu');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    QS_add('[Q03] Kein Einbaustand', sPlausi);

                  ZaehlwerkeIst := StrToIntDef(StrFilter(ART, cZiffern), 1);

                  Q_Umfang_FillFrom('Q04-Umfang');
                  if (Q_Umfang.Count=0) then
                  begin
                    // default Prüfung
                    if (ZaehlwerkeIst > 1) then
                    begin
                      // Nebentarif alter Zähler
                      ActColIndex := Header.indexof('NA');
                      if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                        QS_add('[Q04] Kein Nebentarif Ausbaustand', sPlausi);
                    end;
                  end else
                  begin
                    for k := 0 to pred(Q_Umfang.Count) do
                    begin
                      Q_CheckTarget := cutblank(Q_Umfang[k]);
                      ActColIndex := Header.indexof(Q_CheckTarget);
                      if (ActColIndex=-1) then
                       QS_add('[Q04] Spalte '+Q_CheckTarget+' ist nicht vorhanden', sPlausi);
                      if (ActColIndex<>-1) then
                        if (ActColumn[ActColIndex] = '') then
                          QS_add('[Q04] '+Q_CheckTarget+' ist leer im Status Erfolg', sPlausi);
                    end;
                  end;
                  Q_Umfang.Free;

                  Q_Umfang_FillFrom('Q05-Umfang');
                  if (Q_Umfang.Count=0) then
                  begin
                    // default Prüfung
                    if (ZaehlwerkeIst > 1) then
                    begin

                      // Nebentarif neuer Zähler
                      ActColIndex := Header.indexof('NN');
                      if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                        QS_add('[Q05] Kein Nebentarif Einbaustand', sPlausi);
                    end;
                  end else
                  begin
                    for k := 0 to pred(Q_Umfang.Count) do
                    begin
                      Q_CheckTarget := cutblank(Q_Umfang[k]);
                      ActColIndex := Header.indexof(Q_CheckTarget);
                      if (ActColIndex=-1) then
                       QS_add('[Q05] Spalte '+Q_CheckTarget+' ist nicht vorhanden', sPlausi);
                      if (ActColIndex<>-1) then
                        if (ActColumn[ActColIndex] = '') then
                          QS_add('[Q05] '+Q_CheckTarget+' ist leer im Status Erfolg', sPlausi);
                    end;
                  end;
                  Q_Umfang.Free;

                  Q_Umfang_FillFrom('Q23-Umfang');
                  if (Q_Umfang.Count=0) then
                   Q_Umfang.Add('FA');
                  for k := 0 to pred(Q_Umfang.Count) do
                  begin
                    Q_CheckTarget := cutblank(Q_Umfang[k]);
                    ActColIndex := Header.indexof(Q_CheckTarget);
                    if (ActColIndex <> -1) then
                      if (ActColumn[ActColIndex] = '') then
                        QS_add('[Q23] '+Q_CheckTarget+' ist leer im Status Erfolg', sPlausi);
                  end;
                  Q_Umfang.Free;

                end;

                if (vSTATUS in [ctvVorgezogen, ctvUnmoeglich, ctvVorgezogenGemeldet, ctvUnmoeglichGemeldet]) then
                begin
                  k := 0;
                  ActColIndex := Header.indexof('I3');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    inc(k);
                  ActColIndex := Header.indexof('I6');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    inc(k);
                  ActColIndex := Header.indexof('I7');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    inc(k);
                  if (k = 3) then
                    QS_add('[Q20] Keine Anmerkung des Monteurs', sPlausi);

                  Q_Umfang_FillFrom('Q24-Umfang');
                  if (Q_Umfang.Count=0) then
                   Q_Umfang.Add('FA');
                  for k := 0 to pred(Q_Umfang.Count) do
                  begin
                    Q_CheckTarget := cutblank(Q_Umfang[k]);
                    ActColIndex := Header.indexof(Q_CheckTarget);
                    if (ActColIndex <> -1) then
                      if (ActColumn[ActColIndex] = '') then
                        QS_add('[Q24] '+Q_CheckTarget+' ist leer im Status Unmöglich oder Vorgezogen', sPlausi);
                  end;
                  Q_Umfang.Free;

                end;

                Q_Umfang_FillFrom('Q25-Umfang');
                if (Q_Umfang.Count=0) then
                begin
                 Q_Umfang.Add('FA');
                 Q_Umfang.Add('FN');
                end;
                for k := 0 to pred(Q_Umfang.Count) do
                begin
                  Q_CheckTarget := cutblank(Q_Umfang[k]);
                  ActColIndex := Header.indexof(Q_CheckTarget);
                  if (ActColIndex <> -1) then
                    Q_CheckFotoFile(ActColumn[ActColIndex], e_r_FotoRID(AUFTRAG_R), Q_CheckTarget);
                end;
                Q_Umfang.Free;

              end;
          else
            QS_add('[Q99] Bewertungsmodell unbekannt', sPlausi);
          end;

        end;

        // Dubletten-Prüfung
        if (PlausiMode > 0) then
          if
          { } ((ZAEHLER_NR_NEU <> '0') and
            { } (ZAEHLER_NR_NEU <> '')) or
          { } ((N1 <> '0') and (N1 <> '') and ZaehlerNummernNeuAusN1) then
          begin

            // Alphanumerischer Vorsatz
            if ZaehlerNummernNeuMitA1 then
              ZaehlerNummerNeuPreFix := A1
            else
              ZaehlerNummerNeuPreFix := '';

            // Zählernumer Neu
            if (ZAEHLER_NR_NEU <> '') then
            begin
              DublettenPruefling := ART + '~' + ZaehlerNummerNeuPreFix + ZAEHLER_NR_NEU;
              lZNN_Dupletten := ZaehlerNummernNeu.find(DublettenPruefling);
              for k := 0 to pred(lZNN_Dupletten.count) do
                if (lZNN_Dupletten[k] <> AUFTRAG_R) then
                begin
                  Log(cINFOText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' RID=' + inttostr(lZNN_Dupletten[k]) +
                    ' ist die "Zählernummer Neu"-Dublette (' + DublettenPruefling + ')', BAUSTELLE_R,
                    Settings.values[cE_TAN]);

                  QS_add('[Q21] Einbauzähler gibt es bereits', sPlausi);
                end;
              lZNN_Dupletten.free;
            end;

            // N1
            if (N1 <> '') and ZaehlerNummernNeuAusN1 then
            begin
              DublettenPruefling := ART + '~' + ZaehlerNummerNeuPreFix + N1;
              lZNN_Dupletten := ZaehlerNummernNeu.find(DublettenPruefling);
              for k := 0 to pred(lZNN_Dupletten.count) do
                if (lZNN_Dupletten[k] <> AUFTRAG_R) then
                begin
                  Log(cINFOText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' RID=' + inttostr(lZNN_Dupletten[k]) +

                    ' ist die "N1"-Dublette (' + DublettenPruefling + ')', BAUSTELLE_R, Settings.values[cE_TAN]);

                  QS_add('[Q21] Einbauzähler gibt es bereits', sPlausi);
                end;
              lZNN_Dupletten.free;
            end;

          end;

        // abschliessende Bewertung
        if not(QS_gut(sPlausi, Settings)) then
        begin
          writePermission := false;
          sQS_kritisch := QS_kritisch(sPlausi, Settings);
          for k := 0 to pred(sQS_kritisch.count) do
            Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' ' + sQS_kritisch[k], BAUSTELLE_R,
              Settings.values[cE_TAN]);
          sQS_kritisch.free;
          if (FailL.indexof(AUFTRAG_R) = -1) then
            FailL.add(AUFTRAG_R);
        end;

        if writePermission then
          // ist Ergebnis_MaxAnzahl überschritten?
          if (Stat_Erfolg.count + Stat_Vorgezogen.count + Stat_Unmoeglich.count >= Ergebnis_MaxAnzahl) then
          begin
            writePermission := false;
            Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' ' + ' Limit (' + inttostr(Ergebnis_MaxAnzahl) +
              ') der Meldungen ist erreicht!', BAUSTELLE_R, Settings.values[cE_TAN]);
            if (FailL.indexof(AUFTRAG_R) = -1) then
              FailL.add(AUFTRAG_R);
          end;

        // Bild dazumachen!
        if writePermission and AuchMitFoto then
        begin
          FilesCandidates := TStringList.create;

          _FotoSpalten := noblank(FotoSpalten);
          while (_FotoSpalten <> '') do
          begin
            FotoSpalte := nextp(_FotoSpalten);

            ActColIndex := Header.indexof(FotoSpalte);
            if (ActColIndex <> -1) then
            begin

              FotoFName := nextp(ActColumn[ActColIndex], ',', 0);
              if (FotoFName <> '') then
              begin
                repeat

                  if not(FileExists(e_r_FotoPfad(fp_Deliver,AUFTRAG_R) + FotoFName)) then
                  begin
                    FotoFName := e_r_FotoName(fp_Build,AUFTRAG_R, FotoSpalte);

                    // Ev. in letzter Sekunde einfach für das Bild sorgen
                    if not(FileExists(e_r_FotoPfad(fp_Build,AUFTRAG_R) + FotoFName)) then
                    begin
                     _FotoFName := e_r_FotoName(fp_Build,AUFTRAG_R, FotoSpalte, '',cFoto_Option_NeuLeer);
                     if (_FotoFName<>FotoFName) then
                       if FileExists(e_r_FotoPfad(fp_Build,AUFTRAG_R) + _FotoFName) then
                         FileMove(
                          {} e_r_FotoPfad(fp_Build,AUFTRAG_R) + _FotoFName,
                          {} e_r_FotoPfad(fp_Deliver,AUFTRAG_R) + FotoFName);
                    end;

                    // Rückwärtiges Ändern der Spalte der Ergebnisdatei
                    ActColumn[ActColIndex] := FotoFName;
                    FotoFName := nextp(FotoFName, ',', 0);
                  end;

                  if not(FileExists(e_r_FotoPfad(fp_Deliver,AUFTRAG_R) + FotoFName)) then
                  begin
                    writePermission := false;
                    Log(
                      {} cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' ' +
                      {} FotoSpalte +
                      {} '-Bild "' + FotoFName + '" fehlt!',
                      {} BAUSTELLE_R,
                      {} Settings.values[cE_TAN]);
                    if (FailL.indexof(AUFTRAG_R) = -1) then
                      FailL.add(AUFTRAG_R);
                    break;
                  end;

                  // Ev. eine vom Bilddateinamen vereinfachte Datei-Dublette anlegen
                  _FotoFName := StrFilter(FotoFName, 'öäüÖÄÜß', true);
                  if not(FileExists(e_r_FotoPfad(fp_Deliver,AUFTRAG_R) + _FotoFName)) then
                    FileCopy(
                      {} e_r_FotoPfad(fp_Deliver,AUFTRAG_R) + FotoFName,
                      {} e_r_FotoPfad(fp_Deliver,AUFTRAG_R) + _FotoFName);

                  // Erfolg! Foto muss mit ins ZIP
                  FilesCandidates.add(e_r_FotoPfad(fp_Deliver,AUFTRAG_R) + _FotoFName);

                until true;
              end;
            end;
          end;

          // Nur bei Fehlerfreiheit alles dazu
          if writePermission then
            Files.AddStrings(FilesCandidates);
          FilesCandidates.free;

        end;

        if writePermission then
        begin

          if zaehlwerke then
          begin
            ActColIndex := Header.indexof('Zaehlwerke_Ausbau');
            if (ActColIndex <> -1) then
              ZAEHLWERKE_AUSBAU := ActColumn[ActColIndex];
            ActColIndex := Header.indexof('Zaehlwerke_Einbau');
            if (ActColIndex <> -1) then
              ZAEHLWERKE_EINBAU := ActColumn[ActColIndex];

            // Original Feld INhalte retten
            ZAEHLERSTANDALT := ActColumn[col_ZaehlerstandAlt];
            ZAEHLERSTANDNEU := ActColumn[col_ZaehlerstandNeu];

            repeat
              // Einzelnes Zählwerk lesen
              ZW_AUSBAU := cutblank(nextp(ZAEHLWERKE_AUSBAU,','));
              ZW_EINBAU := cutblank(nextp(ZAEHLWERKE_EINBAU,','));

              // Modifier
              if (ZW_AUSBAU<>'') then
              begin
                // schreibe die Kundenbezeichnung des Zählwerkes
                if (col_ZaehlwerkName_Ausbau<>-1) then
                  SetCell(col_ZaehlwerkName_Ausbau, ZW_AUSBAU);

                ZW_Value := getFrom('Ausbau-'+ZW_AUSBAU);
                ActColIndex := Header.indexof('ZaehlerStandAlt');
                if (ActColIndex <> -1) then
                  SetCell(ActColIndex, ZW_Value);
              end;

              if (ZW_EINBAU<>'') then
              begin
                // schreibe die Kundenbezeichnung des Zählwerkes
                if (col_ZaehlwerkName_Einbau<>-1) then
                 SetCell(col_ZaehlwerkName_Einbau, ZW_EINBAU);

                ZW_Value := getFrom('Einbau-'+ZW_EINBAU);
                ActColIndex := Header.indexof('ZaehlerStandNeu');
                if (ActColIndex <> -1) then
                  SetCell(ActColIndex, ZW_Value);
              end;

              // Ausgabe
              if WritePermission then
                WriteLine;

              // Originalzustand wiederherstellen
              ActColumn[col_ZaehlerstandAlt] := ZAEHLERSTANDALT;
              ActColumn[col_ZaehlerstandNeu] := ZAEHLERSTANDNEU;

            until (ZAEHLWERKE_AUSBAU='') and (ZAEHLWERKE_EINBAU='');

          end else
          begin

            // rausschreiben der Daten!
            WriteLine;

            if zweizeilig then
            begin

              // Zählwerke auf "2" setzen
              ActColIndex := Header.indexof(Zaehlwerk);
              if (ActColIndex <> -1) then
                SetCell(ActColIndex, '2');
              if (Settings.values[cE_ZaehlwerkNeu] <> '') then
              begin
                ActColIndex := Header.indexof(Settings.values[cE_ZaehlwerkNeu]);
                if (ActColIndex <> -1) then
                  SetCell(ActColIndex, '2');
              end;
              ActColIndex := Header.indexof('ZaehlwerkMitArt');
              SetCell(ActColIndex, ART + '-2');

              ActColIndex := Header.indexof('ZaehlerStandAlt');
              if (ActColIndex <> -1) then
                SetCell(ActColIndex, NA);

              ActColIndex := Header.indexof('ZaehlerStandNeu');
              if (ActColIndex <> -1) then
                SetCell(ActColIndex, NN);

              // Jetzt noch die "Intern-Namen.2" einfügen!
              for k := 0 to pred(HeaderFromIntern.count) do
              begin
                HeaderName := HeaderFromIntern[k];
                ActColIndex := Header.indexof(HeaderName);
                if (ActColIndex <> -1) then
                begin
                  ActValue := KommaCheck(INTERN_INFO.values[HeaderName + '.2']);
                  if (ActValue <> '') then
                    SetCell(ActColIndex, ActValue);
                end;
              end;

              WriteLine;

            end;
          end;
        end;

        if WritePermission then
        begin
          case vSTATUS of
            ctvErfolg, ctvErfolgGemeldet:
              Stat_Erfolg.add(AUFTRAG_R);
            ctvVorgezogen, ctvVorgezogenGemeldet:
              Stat_Vorgezogen.add(AUFTRAG_R);
            ctvUnmoeglich, ctvUnmoeglichGemeldet:
              Stat_Unmoeglich.add(AUFTRAG_R);
          end;
        end;

        Log(
          { } inttostr(succ(n)) + '/' + inttostr(RIDs.count) + ' ' +
          { } anfix.booltostr(zweizeilig, 'x2 ', '') +
          { } '(' + inttostr(integer(RIDs[n])) + ' : ' + booltostr(FailL.indexof(RIDs[n]) = -1) + ')');

      end; // for RIDS..

      HeaderDefault.free;
      for n := 0 to pred(Header.count) do
        TgpIntegerList(Header.objects[n]).free;
      Header.free;
      HeaderFromIntern.free;
      HeaderSuppress.free;
      HeaderTextFormat.free;
      INTERN_INFO.free;
      ERGEBNIS_INFO.free;
      cINTERNINFO.free;

      // Ausgabe in die neue Datei
      OutFName :=
       { } cAuftragErgebnisPath +
       { } e_r_BaustellenPfad(Settings) + '\' +
       { } noblank(Settings.values[cE_Praefix]) +
       { } 'Zaehlerdaten_' + Settings.values[cE_TAN] +
       { } noblank(Settings.values[cE_Postfix]) + cSpreadSheetExtension;

      CheckCreateDir(cAuftragErgebnisPath + e_r_BaustellenPfad(Settings));
      FileDelete(OutFName);
      {$ifdef fpc}
      {$else}
      save(OutFName);
      {$endif}
      if (Settings.values[cE_OhneStandardXLS] <> cINI_Activate) then
        Files.add(OutFName);

      repeat

        // Wenn es gar nix mehr zu melden gibt? Ist hier Ende
        if (RIDs.Count<=FailL.Count) then
         break;

        // Oc noch rufen, um wieder eine csv draus zu machen?
        if {}(Settings.values[cE_AuchAlsCSV] = cINI_Activate) and
           {}(Settings.values[cE_AuchAlsXLS] <> cINI_Activate) and
           {}not((Settings.values[cE_AuchAlsCSVunmoeglich] = cIni_DeActivate) and (pos('.unmoeglich', OutFName) > 0)) then
        begin

          // Bestimmen des Konvertierungs-Modus
          if FileExists(
            { } cAuftragErgebnisPath +
            { } e_r_BaustellenPfad(Settings) + '\' +
            { } cFixedFloodFName) then
            n := Content_Mode_xls2Flood
          else
            n := Content_Mode_xls2csv;

          // Konvertieren
          Oc_Bericht := TStringList.create;
          if not(doConversion(n, OutFName, Oc_Bericht)) then
          begin
            // Fatal+Full Stop
            inc(ErrorCount);
            Log(cERRORText + cOc_FehlerMeldung, BAUSTELLE_R);
            Log(Oc_Bericht, BAUSTELLE_R);
            break;
          end
          else
          begin
            // partitial or full Success

            // Die Fehlermeldungen aus der Datenlieferung rausnehmen
            CheckFailElements;

            // Normales Oc Ergebnis
            Files.add(conversionOutFName);

            // weitere Dateien dazu
            Files.add(copy(OutFName, 1, length(OutFName) - 4) + '-*' + cSpreadSheetExtension);
          end;
          Oc_Bericht.free;
        end;

        // XML
        if (Settings.values[cE_AuchAlsXML] = cINI_Activate) and (pos('.unmoeglich', OutFName) = 0) then
        begin
          Oc_Bericht := TStringList.create;
          case CheckContent(OutFName) of
            Content_Mode_xls2Argos2007:
              Oc_Result := doConversion(Content_Mode_xls2Argos2007, OutFName, Oc_Bericht);
            Content_Mode_xls2Argos2018:
              Oc_Result := doConversion(Content_Mode_xls2Argos2018, OutFName, Oc_Bericht);
            Content_Mode_xls2ml:
              Oc_Result := doConversion(Content_Mode_xls2ml, OutFName, Oc_Bericht);
          else
            Oc_Result := doConversion(Content_Mode_xls2gm, OutFName, Oc_Bericht);
          end;
          if not(Oc_Result) then
          begin
            inc(ErrorCount);
            Log(cERRORText + cOc_FehlerMeldung, BAUSTELLE_R);
            Log(Oc_Bericht, BAUSTELLE_R);
            break;
          end
          else
          begin
            CheckFailElements;
            Files.add(copy(OutFName, 1, length(OutFName) - 4) + '.xml');
          end;
          Oc_Bericht.free;
        end;

        // XML, XML, ...
        if (Settings.values[cE_AuchAlsEinzelXML] = cINI_Activate) and (pos('.unmoeglich', OutFName) = 0) then
        begin
          Oc_Bericht := TStringList.create;
          Oc_Result := doConversion(Content_Mode_xls2xml, OutFName, Oc_Bericht);
          if not(Oc_Result) then
          begin
            inc(ErrorCount);
            Log(cERRORText + cOc_FehlerMeldung, BAUSTELLE_R);
            Log(Oc_Bericht, BAUSTELLE_R);
            break;
          end
          else
          begin

            for n := 0 to pred(Oc_Bericht.count) do
            begin
              // Dateinamen des .xml bestimmen
              if (pos('INFO: save ', Oc_Bericht[n]) > 0) then
              begin
                SingleFName :=
                { } cAuftragErgebnisPath +
                { } e_r_BaustellenPfad(Settings) + '\' +
                { } nextp(Oc_Bericht[n], 'INFO: save ', 1);
                Files.add(SingleFName);
              end;

              if (pos('(RID=', Oc_Bericht[n]) > 0) then
              begin
                FAIL_R := StrToIntDef(ExtractSegmentBetween(Oc_Bericht[n], '(RID=', ')'), 0);
                if (FailL.indexof(FAIL_R) = -1) then
                  FailL.add(FAIL_R);
                Log(cERRORText + ' ' + Oc_Bericht[n], BAUSTELLE_R, Settings.values[cE_TAN]);
              end;
              _(cFeedBack_processmessages);
            end;
          end;
          Oc_Bericht.free;
        end;

        // HTML, HTML, ...
        if (Settings.values[cE_AuchAlsHTML] = cINI_Activate) and
          not((Settings.values[cE_AuchAlsHTMLunmoeglich] = cIni_DeActivate) and (pos('.unmoeglich', OutFName) > 0)) then
        begin

          if (pos('.unmoeglich', OutFName) > 0) then
            p_HTML_VorlageFName := 'Vorlage.unmoeglich.html'
          else
            p_HTML_VorlageFName := '';

          Oc_Bericht := TStringList.create;
          Oc_Result := doConversion(Content_Mode_xls2html, OutFName, Oc_Bericht);
          if not(Oc_Result) then
          begin
            inc(ErrorCount);
            Log(cERRORText + cOc_FehlerMeldung, BAUSTELLE_R);
            Log(Oc_Bericht, BAUSTELLE_R);
            break;
          end
          else
          begin
            for n := 0 to pred(Oc_Bericht.count) do
            begin
              // Dateinamen des .html bestimmen
              if (pos('INFO: save ', Oc_Bericht[n]) > 0) then
              begin
                SingleFName :=
                { } cAuftragErgebnisPath +
                { } e_r_BaustellenPfad(Settings) + '\' +
                { } nextp(Oc_Bericht[n], 'INFO: save ', 1);
                Files.add(SingleFName);

                // Noch ein PDF hinzu?
                if (Settings.values[cE_AuchAlsPDF] = cINI_Activate) then
                begin
                  PDF_FromWhat := SingleFName;
                  PDF := html2pdf(PDF_FromWhat, false);
                  PDF_ResultInfoStr := PDF.Values['ERROR'];
                  if (PDF_ResultInfoStr<>'') then
                  begin
                    inc(ErrorCount);
                    Log(cERRORText + ' HTML zu PDF Konvertierung: ' + PDF_ResultInfoStr, BAUSTELLE_R);
                  end else
                  begin
                    if (Settings.values[cE_OhneHTML] = cINI_Activate) then
                      Files.delete(pred(Files.count));
                    SingleFname := PDF.Values['ConversionOutFName'];
                    FileTouch(SingleFName, FileDateTime(PDF_FromWhat));
                    Files.add(SingleFName);
                  end;
                  PDF.Free;
                end;
                continue;
              end;

              if (pos(cWARNINGText, Oc_Bericht[n])=0) then
                if (pos('(RID=', Oc_Bericht[n]) > 0) then
                begin
                  FAIL_R := StrToIntDef(ExtractSegmentBetween(Oc_Bericht[n], '(RID=', ')'), 0);
                  if (FailL.indexof(FAIL_R) = -1) then
                    FailL.add(FAIL_R);
                  Log(cERRORText + ' ' + Oc_Bericht[n], BAUSTELLE_R, Settings.values[cE_TAN]);
                 continue;
                end;
              _(cFeedback_processmessages);
            end;
          end;
          Oc_Bericht.free;
        end;

        // Vorlage, Variante 1/2 (=JA)
        if (Settings.values[cE_AuchAlsXLS] = cINI_Activate) and
          not((Settings.values[cE_AuchAlsXLSunmoeglich] = cIni_DeActivate) and (pos('.unmoeglich', OutFName) > 0)) then
        begin

          if (pos('.unmoeglich', OutFName) > 0) then
            p_XLS_VorlageFName := 'Vorlage.unmoeglich' + cSpreadSheetExtension
          else
            p_XLS_VorlageFName := '';

          Oc_Bericht := TStringList.create;
          if not(doConversion(Content_Mode_xls2xls, OutFName, Oc_Bericht)) then
          begin
            inc(ErrorCount);
            Log(cERRORText + cOc_FehlerMeldung, BAUSTELLE_R);
            Log(Oc_Bericht, BAUSTELLE_R);
            break;
          end
          else
          begin
            if (Settings.values[cE_OhneKonvertiertXLS] <> cINI_Activate) then
              Files.add(conversionOutFName);
          end;
          Oc_Bericht.free;

          // die Konvertierte auch als CSV?
          if (Settings.values[cE_AuchAlsCSV] = cINI_Activate) then
          begin
            Oc_Bericht := TStringList.create;
            if not(doConversion(Content_Mode_xls2csv, conversionOutFName, Oc_Bericht)) then
            begin
              inc(ErrorCount);
              Log(cERRORText + cOc_FehlerMeldung, BAUSTELLE_R);
              Log(Oc_Bericht, BAUSTELLE_R);
              break;
            end
            else
            begin
              Files.add(conversionOutFName);
            end;
            Oc_Bericht.free;
          end;

        end;

        // Vorlage, Variante 2/2 (=SEPARAT)
        if (Settings.values[cE_AuchAlsXLS] = cINI_Distinct) and
          not((Settings.values[cE_AuchAlsXLSunmoeglich] = cIni_DeActivate) and (pos('.unmoeglich', OutFName) > 0)) then
        begin

          if (pos('.unmoeglich', OutFName) > 0) then
            p_XLS_VorlageFName := 'Vorlage.unmoeglich' + cSpreadSheetExtension
          else
            p_XLS_VorlageFName := '';

          Oc_Bericht := TStringList.create;
          if not(doConversion(Content_Mode_xls2xls, OutFName, Oc_Bericht)) then
          begin
            inc(ErrorCount);
            Log(cERRORText + cOc_FehlerMeldung, BAUSTELLE_R);
            Log(Oc_Bericht, BAUSTELLE_R);
            break;
          end
          else
          begin
            Files.add(conversionOutFName);
          end;
          Oc_Bericht.free;

        end;

        // IDOC
        if (Settings.values[cE_AuchAlsIDOC] = cINI_Activate) and (pos('.unmoeglich', OutFName) = 0) then
        begin
          Oc_Bericht := TStringList.create;
          if not(doConversion(Content_Mode_xls2idoc, OutFName, Oc_Bericht)) then
          begin
            inc(ErrorCount);
            Log(cERRORText + cOc_FehlerMeldung, BAUSTELLE_R);
            Log(Oc_Bericht, BAUSTELLE_R);
            break;
          end
          else
          begin
            Files.add(copy(OutFName, 1, length(OutFName) - 4) + '.????.idoc');
            Files.add(ExtractFilePath(OutFName) + 'z1isu_meau_' + Settings.values[cE_TAN] + '-*');
            for n := 0 to pred(Oc_Bericht.count) do
              if (pos('(RID=', Oc_Bericht[n]) > 0) then
              begin
                FAIL_R := StrToIntDef(ExtractSegmentBetween(Oc_Bericht[n], '(RID=', ')'), 0);
                if (FailL.indexof(FAIL_R) = -1) then
                  FailL.add(FAIL_R);
                Log(cERRORText + ' ' + Oc_Bericht[n], BAUSTELLE_R, Settings.values[cE_TAN]);
              end;
          end;
          Oc_Bericht.free;
        end;

      until yet;
    end;
  except
    on e: exception do
    begin
      inc(ErrorCount);
      Log(cERRORText + ' ' + e.message, BAUSTELLE_R);
    end;
  end;
  p_XLS_VorlageFName := '';

  LinesL.free;
  ProtokollFeldNamen.free;
  ProtokollWerte.free;
  Settings_Zaehlwerke.free;
  FreieResourcen.free;
  Sparten.free;
  ActColumn.free;
  MussFelder.free;
  RauteFelder.free;
  OhneInhaltFelder.free;
  ZaehlerNummernNeu.free;

  _(cFeedBack_ProgressBar_position+1);
  result := (ErrorCount = 0);
end;

procedure ClearStat;
begin
  if not(assigned(Stat_Erfolg)) then
  begin
    Stat_Erfolg := TgpIntegerList.create;
    Stat_Vorgezogen := TgpIntegerList.create;
    Stat_Unmoeglich := TgpIntegerList.create;
    Stat_Fail := TgpIntegerList.create;
    Stat_FehlendeResourcen := TStringList.create;
    Stat_Attachments := TStringList.create;
  end
  else
  begin
    Stat_Erfolg.clear;
    Stat_Vorgezogen.clear;
    Stat_Unmoeglich.clear;
    Stat_Fail.clear;
    Stat_FehlendeResourcen.clear;
    Stat_Attachments.clear;
  end;
  Stat_meldungen := 0;
  Stat_nichtEFRE := 0;
  Stat_FehlendeResourcen.add('Sparte;ZaehlerNummerNeu;MaterialNummerAlt;MeldungsTAN;RID;TextZaehlerNummerNeu');
end;

function e_w_Ergebnis(
 { } BAUSTELLE_R: integer;
 { } pOptions: TStringList = nil;
 { } fb: TFeedBack = nil): boolean;

  {$I Feedback.inc}

  procedure Log(s: string; BAUSTELLE_R: integer = 0; TAN: string = ''); overload;
  begin
    if (BAUSTELLE_R > 0) then
      s := s + ' ' + e_r_BaustelleKuerzel(BAUSTELLE_R);
    if (TAN <> '') then
      s := s + ' ' + TAN;
    _(cFeedBack_Log,s);
    _(cFeedBack_processmessages);
    AppendStringsToFile(s, ErgebnisLogFName);
  end;

  procedure Log(s: TStrings; BAUSTELLE_R: integer = 0; TAN: string = ''); overload;
  var
    n: integer;
  begin
    for n := 0 to pred(s.count) do
    begin
      if (pos(cE_ZIPPASSWORD, s[n]) = 1) then
        continue;
      if (pos(cE_FTPPASSWORD, s[n]) = 1) then
        continue;
      Log(s[n], BAUSTELLE_R, TAN);
    end;
  end;

var
  qMail: TdboQuery;
  eMailParameter: TStringList;
  PERSON_R: integer;
  VORLAGE_R: integer;
  TAN: integer;
  Settings: TStringList;
  ErrorCount: integer;
  n: integer;
  BaustelleKurz: string;
  {$ifdef fpc}
  {$else}
  FlexCelXLS: TXLSFile;
  {$endif}

  // FTP: upload einzelner Dateien
  FTP_UploadFName: string;
  FTP_UploadFiles: TStringList;
  FTP_UploadMasks: TStringList;
  FTP_DeleteLocal: TStringList;
  iSourcePathAdditionalFiles: string;

  // Commit - Code
  CommitL: TgpIntegerList;

  // Eingangsparameter
  pTAN_wiederholen      : boolean; // was CheckBox5.checked
  pTAN                  : string;  // was edit2
  pSQL                  : string;  // was Memo1.lines
  pAUFTRAG_R            : Integer; // was Edit1.Text / Checkbox4
  pFTP_Diagnose         : boolean; // was CheckBox1.checked
  pReport               : boolean; // was not(CheckBox2.checked)
  pTAN_statisch         : boolean; // was CheckBox3.checked
  pManuell              : boolean; // was ManuellInitiiert

  procedure doCommit;
  var
    dAUFTRAG: TdboScript;
    n: integer;
    TransaktionsName: string;
  begin

    // Erfolg in die Auftragsdaten eintragen: "COMMIT!"
    dAUFTRAG := nScript;
    with dAUFTRAG do
    begin
      sql.add('update AUFTRAG set');
      sql.add(' EXPORT_TAN = ' + inttostr(TAN));
      sql.add('where RID = :CROSSREF');
      prepare;
      for n := 0 to pred(CommitL.count) do
      begin
        ParamByName('CROSSREF').AsInteger := integer(CommitL[n]);
        execute;
      end;
    end;
    dAUFTRAG.free;

    // Abschluss-Transaktion durchführen
    TransaktionsName := Settings.values[cE_AbschlussTransaktion];
    while (TransaktionsName <> '') do
      e_x_Transaktion(nextp(TransaktionsName), CommitL);

  end;

  procedure doFTP;
  var
    FTP: TSolidFTP;
    n: integer;
    NativeFileName: string;
    qTICKET: TdboQuery;
    FTP_Infos: TStringList;
  begin

    // gar nicht gewünscht?
    if pFTP_Diagnose then
     exit;

    // gar nichts zu tun?
    if (FTP_UploadMasks.Count=0) and (FTP_UploadFiles.Count=0) then
     exit;

    // gar kein Upload in den Einstellungen?
    if (Settings.values[cE_FTPHOST]='') then
    begin
     Log(cWARNINGText + ' ' + BaustelleKurz + ':Kein Eintrag in '+cE_FTPHOST+'= somit kein Upload in eine Internet-Ablage');
     exit;
    end;

    FTP := TSolidFTP.Create;
    with FTP do
    begin
      Host := Settings.values[cE_FTPHOST];
      Username := e_r_FTP_LoginUser(Settings.values[cE_FTPUSER]);
      Password := Settings.values[cE_FTPPASSWORD];

      // Prüfung der FTP Daten
      if (Host <> '') then
      begin

        if (Username = '') then
          Log(cERRORText + ' ' + BaustelleKurz + ':Kein Eintrag in '+cE_FTPUSER+'=');

        if (Password = '') then
          Log(cWARNINGText + ' ' + BaustelleKurz + ':Kein Eintrag in '+cE_FTPPASSWORD+'=');

      end;

    end;

    FTP.BeginTransaction;
    repeat

      // Dateien hochladen
      for n := 0 to pred(FTP_UploadFiles.count) do
      begin

        NativeFileName := ExtractFileName(FTP_UploadFiles[n]);
        _(cFeedback_Log,'Upload "' + NativeFileName + '" ' + inttostr(FSize(FTP_UploadFiles[n])) + ' Byte(s) ...');

        if not(FTP.Upload(
          { } FTP_UploadFiles[n],
          { } Settings.values[cE_FTPVerzeichnis],
          { } NativeFileName)) then
        begin

          // FTP - ERROR
          inc(ErrorCount);
          Log(cERRORText + ' [10533] FTP FAILED', BAUSTELLE_R);

          // FTP - Ticket erstellen
          qTICKET := nQuery;
          FTP_Infos := TStringList.create;

          with FTP_Infos do
          begin
            values[cE_FTPHOST] := FTP.Host;
            values[cE_FTPUSER] := FTP.Username;
            values[cE_FTPPASSWORD] := FTP.Password;
            values[cE_FTPVerzeichnis] := Settings.values[cE_FTPVerzeichnis];
            values['Datei'] := FTP_UploadFiles[n];
            values['NachUploadLöschen'] := bool2cO(FTP_DeleteLocal.indexof(FTP_UploadFiles[n]) <> -1);
            values['Fehler'] := 'FTP';
          end;

          with qTICKET do
          begin
            // ein Ticket, durch das System erzeugt
            sql.add('select * from TICKET for update');
            insert;
            FieldByName('RID').AsInteger := 0;
            FieldByName('ART').AsInteger := eT_FTP;
            FieldByName('INFO').Assign(FTP_Infos);
            post;
          end;

          qTICKET.free;
          FTP_Infos.free;

          break;
        end
        else
        begin
          inc(Stat_meldungen);
          // Nach Erfolg ev. löschen? Nicht bei allen Dateien
          if (FTP_DeleteLocal.indexof(FTP_UploadFiles[n]) <> -1) then
            FileDelete(FTP_UploadFiles[n]);
        end;
      end;

      // Dateien hochladen über die Alternative CoreFTP
      for n := 0 to pred(FTP_UploadMasks.count) do
        if not(CoreFTP_Up(
          { Profile } e_r_FTP_LoginUser(Settings.values[cE_FTPUSER]),
          { Mask } nextp(FTP_UploadMasks[n], ';', 0),
          { Path } nextp(FTP_UploadMasks[n], ';', 1))) then
        begin
          // FTP - ERROR
          inc(ErrorCount);
          Log(cERRORText + ' Ursache siehe CoreFTP-' + inttostr(DateGet) + cLogExtension);
          break;
        end;

    until yet;
    FTP.EndTransaction;

    // FTP Verbindung beenden
    with FTP do
    begin
      if connected then
      begin
        try
          Disconnect;
        Except
          // do not handle this
        end;
      end;
    end;
    try
     FTP.Free;
    Except
      // do not handle this
    end;
  end;

  function ReportBlock(Erfolgsmeldungen, Unmoeglichmeldungen: boolean; AUFTRAG_R: Integer): integer;
  // [Anzahl der Meldungen]
  var
    cAUFTRAG: TdboCursor;
    _Expected_TAN: integer;
    ExportL: TgpIntegerList;
    FailL: TgpIntegerList;
    FilesUp: TStringList;
    n: integer;
  begin
    result := 0;
    if { } pTAN_wiederholen and
    { } (pTAN <> '') and
    { } (pos(',', pTAN) = 0) and
    { } (pos('-', pTAN) = 0) then
      _Expected_TAN := StrToIntDef(pTAN, -1)
    else
      _Expected_TAN := StrToIntDef(Settings.values[cE_EXPORT_TAN], -2) + 1;

    // Es könnte sein, dass bei der Datenquelle= die TAN rasugenommen wurde
    if (_Expected_TAN = -1) then
    begin
      inc(ErrorCount);
      Log(cERRORText + ' Die neue TAN konnte nicht ermittelt werden|Letzte TAN leer oder keine Zahl');
      exit;
    end;

    cAUFTRAG := nCursor;
    with cAUFTRAG do
    begin
      sql.add('select RID from AUFTRAG where'); //
      sql.add(' (BAUSTELLE_R=' + Settings.values[cE_Datenquelle] + ') and');

      // diese Baustelle
      repeat

        if Erfolgsmeldungen and Unmoeglichmeldungen then
        begin
          sql.add(' ((STATUS=' + inttostr(ord(ctsErfolg)) + ') or');
          sql.add('  (STATUS=' + inttostr(ord(ctsVorgezogen)) + ') or');
          sql.add('  (STATUS=' + inttostr(ord(ctsUnmoeglich)) + ')) and');
          break;
        end;

        if Erfolgsmeldungen then
        begin
          sql.add(' (STATUS=' + inttostr(ord(ctsErfolg)) + ') and');
          break;
        end;

        sql.add(' ((STATUS=' + inttostr(ord(ctsVorgezogen)) + ') or');
        sql.add('  (STATUS=' + inttostr(ord(ctsUnmoeglich)) + ')) and');

      until true;

      // +SQL_Filter
      e_w_Baustelle_add_SQL_Filter(Settings, sql);

      // +heutiges manuelle SQL
      if (pSQL<>'') then
       sql.Add(pSQL);

      repeat

        if (AUFTRAG_R >= cRID_FirstValid) then
        begin
          sql.add(' (RID=' + inttostr(AUFTRAG_R) + ')');
          break;
        end;

        if pTAN_wiederholen and (pTAN <> '') then
        begin
          if (pos(',', pTAN) > 0) or (pos('-', pTAN) > 0) then
            sql.add(' (EXPORT_TAN in (' + StrRange(pTAN) + '))')
          else
            sql.add(' (EXPORT_TAN=' + pTAN + ')');
          break;
        end;

        // ungemeldet oder das "aktuelle" Volumen
        sql.add(' ((EXPORT_TAN is null) or (EXPORT_TAN=' + inttostr(_Expected_TAN) + '))')

      until true;
      sql.add('order by');
      if Erfolgsmeldungen then
       sql.add(' ZAEHLER_WECHSEL, RID')
      else
       sql.add(' RID');

      // übers SQL informieren
      dbLog(sql);
      Log(sql);

      repeat

        // ermittelte Anzahl der Datensätze
        try
         open;
         Log('Anz=' + inttostr(RecordCount));
        except
          inc(ErrorCount);
          Log(cERRORText + ' Fehler im '+cE_SQL_Filter+'=');
          break;
        end;

        // Melden
        ApiFirst;
        if not(eof) then
        begin

          // hey! überhaupt was zu melden!
          ExportL := TgpIntegerList.create;
          FailL := TgpIntegerList.create;
          FilesUp := TStringList.create;

          // Vorlauf
          try
            repeat

              TAN := _Expected_TAN;
              Settings.values[cE_TAN] := inttostrN(TAN, cE_TANLENGTH);
              FTP_UploadFName :=
              { } noblank(Settings.values[cE_Praefix]) +
              { } Settings.values[cE_TAN] +
              { } noblank(Settings.values[cE_Postfix]) +
              { } cZIPExtension;

              // Liste aufbauen
              while not(eof) do
              begin
                ExportL.add(FieldByName('RID').AsInteger);
                ApiNext;
              end;

              BeginOc;

              // Dateien erzeugen
              if not(e_w_CreateFiles(Settings, ExportL, FailL, FilesUp, fb)) then
              begin
                EndOc;
                inc(ErrorCount);
                // Create-Files sollte bereits über den Fehler berichtet haben
                break;
              end else
              begin
                EndOc;
              end;

              // Hey, gar nix geschrieben?!
              if (ExportL.count - FailL.count < 1) then
              begin
               if (ExportL.Count>0) then
                Log(cINFOText + ' Es gibt wegen 100% Fehlerquote ('+IntToStr(FailL.count)+'/'+IntToStr(ExportL.count)+') nichts zu melden');
               break;
              end;

              // Berichten über Anzahl
              if (ExportL.Count>0) then
               if (FailL.count>0) then
                Log(cINFOText + ' Es werden nur '+IntToStr(ExportL.count - FailL.count)+'/'+IntToStr(ExportL.count)+' gemeldet');

              // FilesUp aufräumen
              FilesUp.sort;
              RemoveDuplicates(FilesUp);

              if DebugMode then
                FilesUp.SaveToFile(cAuftragErgebnisPath + e_r_BaustellenPfad(Settings) + '\' + 'Files-For-Zip.txt');

              // Zip "FilesUp"
              if (zip(
               { } FilesUp,
               { } cAuftragErgebnisPath + FTP_UploadFName,
               { } czip_set_Password + '=' + Settings.values[cE_ZIPPASSWORD])<1) then
              begin
               inc(ErrorCount);
               Log(cERRORText + ' Erstelltes ZIP-Archiv sollte zumindest eine Datei enthalten.');
               break;
              end;

              Stat_Attachments.add(cAuftragErgebnisPath + FTP_UploadFName);

              // ev. FTP-Masken hinzufügen (nur CoreFTP)
              if (Settings.values[cE_AuchAlsIDOC] = cINI_Activate) then
                if (Settings.values[cE_CoreFTP] <> '') then
                begin
                  if Erfolgsmeldungen then
                    FTP_UploadMasks.add(
                    { } cAuftragErgebnisPath +
                    { } e_r_BaustellenPfad(Settings) + '\' +
                    { } noblank(Settings.values[cE_Praefix]) +
                    { } 'Zaehlerdaten_' + Settings.values[cE_TAN] +
                    { } '.????.idoc' +
                    { } ';' +
                    { } '/IDOC');
                  if Unmoeglichmeldungen then
                    FTP_UploadMasks.add(
                    { } cAuftragErgebnisPath +
                    { } e_r_BaustellenPfad(Settings) + '\' +
                    { } noblank(Settings.values[cE_Praefix]) +
                    { } 'Zaehlerdaten_' + Settings.values[cE_TAN] +
                    { } '*' + cSpreadSheetExtension +
                    { } ';' +
                    { } '/TEXT');
                end;

              FTP_UploadFiles.add(cAuftragErgebnisPath + FTP_UploadFName);

            until true;

            result := ExportL.count - FailL.count;
          except
            on e: exception do
            begin
              inc(ErrorCount);
              Log(cERRORText + ' ' + e.message);
            end;
          end;

          Stat_Fail.Append(FailL);

          // die erfolgreichen Mitteilen
          for n := 0 to pred(ExportL.count) do
            if FailL.indexof(ExportL[n]) = -1 then
              CommitL.add(ExportL[n]);

          ExportL.free;
          FailL.free;
          FilesUp.free;

        end;
      until yet;
    end;
    cAUFTRAG.free;
  end;

var
  cBAUSTELLE: TdboCursor;

begin
  _HugeTransactionN := e_w_GEN('GEN_EXPORT');

  // optionale Zusatz-Optionen bei diesem Durchlauf
  if assigned(pOptions) then
  begin
     with pOptions do
     begin
       pTAN_wiederholen := values['TAN_wiederholen']=cIni_Activate;
       pTAN             := values['TAN'];
       pSQL             := values['SQL'];
       pAUFTRAG_R       := StrToIntDef(values['AUFTRAG_R'],cRID_unset);
       pFTP_Diagnose    := values['FTP_Diagnose']=cIni_Activate;
       pReport          := values['Report']<>cIni_Deactivate;
       pTAN_statisch    := values['TAN_statisch']=cIni_Activate;
       pManuell         := values['Manuell']=cIni_Activate;
     end;
  end else
  begin
    // defaults
    pTAN_wiederholen := false;
    pTAN             := '';
    pSQL             := '';
    pAUFTRAG_R       := cRID_unset;
    pFTP_Diagnose := false;
    pReport := true;
    pTAN_statisch := false;
    pManuell:= false;
  end;

  {$ifdef fpc}
  {$else}
  FlexCelXLS := TXLSFile.create;
  {$endif}

  Log('[Info]');
  Log('Beginn=' + sTimeStamp);
  Log('Bearbeiter=' + sBearbeiterKurz);
  Log('Manuell=' + bool2cO(pManuell));
  Log('pBAUSTELLE_R=' + inttostr(BAUSTELLE_R));
  Log('pAUFTRAG_R=' + IntToStr(pAUFTRAG_R));

  InvalidateCache_Baustelle;

  Settings := TStringList.create;
  eMailParameter := TStringList.create;
  qMail := nQuery;
  cBAUSTELLE := nCursor;
  FTP_UploadMasks := TStringList.create;
  FTP_UploadFiles := TStringList.create;
  FTP_DeleteLocal := TStringList.create;
  CommitL := TgpIntegerList.create;

  // Autoset BAUSTELLE_R
  if (BAUSTELLE_R<cRID_FirstValid) then
    if (pAUFTRAG_R>=cRID_FirstValid) then
    begin
      BAUSTELLE_R := e_r_sql(
       {} 'select BAUSTELLE_R from AUFTRAG where RID='+
       {} inttostr(pAUFTRAG_R) );
      Log('BAUSTELLE_R=' + inttostr(BAUSTELLE_R));
    end;

  with qMail do
  begin
    sql.add('select * from EMAIL for update');
  end;

  with cBAUSTELLE do
  begin

    // Baustellen-Selektion aufbauen
    repeat
      sql.add('select NUMMERN_PREFIX, RID, EXPORT_EINSTELLUNGEN');
      sql.add('from BAUSTELLE where');

      if (BAUSTELLE_R >= cRID_FirstValid) then
      begin
        sql.add(' (RID=' + inttostr(BAUSTELLE_R) + ')');
        break;
      end;

      sql.add(' (EXPORT_TAN is not null) and');
      sql.add(' ((ERGEBNISMELDUNG_PAUSIEREN='+cC_False_AsString+') or (ERGEBNISMELDUNG_PAUSIEREN is null))');

    until yet;

    Log(sql);

    Open;
    ApiFirst;
    _(cFeedback_ProgressBar_max+2, IntToStr(RecordCount + 1));
    _(cFeedback_ProgressBar_position+2, IntToStr(1));
    while not(eof) do
    begin
      BaustelleKurz := FieldByName('NUMMERN_PREFIX').AsString;

      _(cFeedback_Label+3, BaustelleKurz);
      Log('[' + BaustelleKurz + ']');
      Log('Beginn=' + sTimeStamp);

      // init
      e_r_sqlt(FieldByName('EXPORT_EINSTELLUNGEN'),Settings);

      // defaults!
      Settings.values[cE_BAUSTELLE_R] := FieldByName('RID').AsString;
      Settings.values[cE_BAUSTELLE_KURZ] := BaustelleKurz;
      if (Settings.values[cE_Datenquelle] = '') then
        Settings.values[cE_Datenquelle] := Settings.values[cE_BAUSTELLE_R]
      else
        Settings.values[cE_Datenquelle] := inttostr(e_r_BaustelleRIDFromKuerzel(Settings.values[cE_Datenquelle]));
      if (Settings.values['Q12'] = '') then
        Settings.values['Q12'] := cQ_erloesend;
      Ergebnis_MaxAnzahl := StrToIntDef(Settings.values[cE_MaxperLoad], MaxInt);

      // die aktuelle Export-TAN ermitteln
      Settings.values[cE_EXPORT_TAN] := e_r_sqls(
        { } 'select EXPORT_TAN from BAUSTELLE ' +
        { } 'where RID=' + Settings.values[cE_Datenquelle]);

      Log(Settings);

      repeat

        if not(pManuell) then
          if (Settings.values[cE_Wochentage] <> '') then
            if (pos(WeekDayS(DateGet), Settings.values[cE_Wochentage]) = 0) then
            begin
              Log(
                { } cWARNINGText + ' ' + BaustelleKurz + ': ' +
                { } 'Heute nicht, ' +
                { } 'da ∉ [' + Settings.values[cE_Wochentage] + ']!');
              break;
            end;

        // Init
        ErrorCount := 0;
        TAN := 0;
        ClearStat;
        eMailParameter.clear;
        FTP_UploadFiles.clear;
        FTP_UploadMasks.clear;
        FTP_DeleteLocal.clear;
        CommitL.clear;

        // noch weitere Einzel-Upload Dateien übertragen
        iSourcePathAdditionalFiles := Settings.values[cE_ZusaetzlicheZips];
        if (iSourcePathAdditionalFiles = cINI_Activate) then
          iSourcePathAdditionalFiles := e_r_BaustelleUploadPath(BAUSTELLE_R);

        if (iSourcePathAdditionalFiles <> '') then
        begin
          // zusätzliche Zips ...
          dir(iSourcePathAdditionalFiles + '*.zip', FTP_UploadFiles, false);
          for n := 0 to pred(FTP_UploadFiles.count) do
          begin
            FTP_UploadFiles[n] :=
            { } iSourcePathAdditionalFiles +
            { } FTP_UploadFiles[n];
            FTP_DeleteLocal.add(FTP_UploadFiles[n]);

            // Das funktioniert nicht, da die Dateien gelöscht werden ...
            // Stat_Attachments.add(FTP_UploadFiles[n]);
          end;
        end;

        // Eine Kopie-Baustelle?
        if (Settings.values[cE_KopieVon] <> '') then
        begin
          if not e_w_BaustelleKopie(
            { } StrToIntDef(
            { } Settings.values[cE_Datenquelle],
            { } cRID_Null)) then
          begin
            inc(ErrorCount);
            Log(cERRORText + ' Fehler bei e_w_BaustelleKopie', BAUSTELLE_R);
          end;
        end;

        // neue Erfolgs-TANS übergeben
        if pReport then
        begin
          if (Settings.values[cE_EineDatei] = cINI_Activate) then
          begin
            inc(Stat_meldungen, ReportBlock(true, true, pAUFTRAG_R));
          end
          else
          begin
            inc(Stat_meldungen, ReportBlock(true, false, pAUFTRAG_R));
            if (ErrorCount = 0) then
            begin
              Settings.values[cE_Postfix] := '.unmoeglich';
              inc(Stat_meldungen, ReportBlock(false, true, pAUFTRAG_R));
            end;
          end;
        end;

        if (Stat_nichtEFRE > 0) then
        begin
          Stat_FehlendeResourcen.SaveToFile(nichtEFREFName(Settings));
          Settings.values[cE_nichtEFRE] := nichtEFREFName(Settings);
        end;

        if (ErrorCount = 0) then
          doFTP;

        // Erfolg in die einzelnen Datensätze eintragen
        if (ErrorCount = 0) and (CommitL.count > 0) then
          doCommit;

        if (TAN > 0) and (ErrorCount = 0) and (Stat_meldungen > 0) then
        begin

          // Erfolg in die Quell-Baustelle eintragen
          if not(pTAN_statisch) then
          begin
            e_x_sql(
              { } 'update BAUSTELLE set ' +
              { } 'EXPORT_TAN=' + inttostr(TAN) + ' ' +
              { } 'where RID=' + Settings.values[cE_Datenquelle]);
          end;

        end;

        // Mail verschicken
        if (Settings.values[cE_eMail] <> '') and not(pFTP_Diagnose) then
          if (ErrorCount = 0) then
            if (Stat_meldungen > 0) or (Stat_nichtEFRE > 0) then
            begin

              PERSON_R := StrToIntDef(Settings.values[cE_eMail], -1);
              if not(e_r_IsRID('PERSON_R', PERSON_R)) then
              begin
                Log(cWARNINGText + ' ' + BaustelleKurz + ':' + cE_eMail + ' ungültig');
                PERSON_R := cRID_Null;
              end;
              VORLAGE_R := e_r_eMailVorlage(cMailvorlage_Ergebnis);

              if (PERSON_R >= cRID_FirstValid) and (VORLAGE_R >= cRID_FirstValid) then
              begin

                // informative Werte
                with eMailParameter do
                begin
                  values['ERFOLGREICH'] := inttostr(Stat_Erfolg.count);
                  values['VORGEZOGEN'] := inttostr(Stat_Vorgezogen.count);
                  values['UNMOEGLICH'] := inttostr(Stat_Unmoeglich.count);
                  values['NICHT_EFRE'] := inttostr(Stat_nichtEFRE);

                  values['ERFOLGREICH_GEMELDET'] := inttostr(Stat_Erfolg.countReducedBy(Stat_Fail));
                  values['VORGEZOGEN_GEMELDET'] := inttostr(Stat_Vorgezogen.countReducedBy(Stat_Fail));
                  values['UNMOEGLICH_GEMELDET'] := inttostr(Stat_Unmoeglich.countReducedBy(Stat_Fail));

                  values['ERFOLGREICH_FEHLER'] := inttostr(Stat_Erfolg.count - Stat_Erfolg.countReducedBy(Stat_Fail));
                  values['VORGEZOGEN_FEHLER'] :=
                    inttostr(Stat_Vorgezogen.count - Stat_Vorgezogen.countReducedBy(Stat_Fail));
                  values['UNMOEGLICH_FEHLER'] :=
                    inttostr(Stat_Unmoeglich.count - Stat_Unmoeglich.countReducedBy(Stat_Fail));

                  values['FEHLER'] := inttostr(Stat_Fail.count);
                  values['ABLAGE'] := e_r_FTP_LoginUser(Settings.values[cE_FTPUSER]);
                  values['TAN'] := Settings.values[cE_TAN];
                  values['BAUSTELLE'] := Settings.values[cE_BAUSTELLE_KURZ];

                end;

                // Datei-Anlagen hinzufügen
                if (Settings.values[cE_ZipAnlage] = cINI_Activate) then
                  for n := 0 to pred(Stat_Attachments.count) do
                    eMailParameter.add('Anlage:' + Stat_Attachments[n]);

                // Fehler-Anlagen hinzufügen
                if (Settings.values[cE_nichtEFRE] <> '') then
                  eMailParameter.add('Anlage:' + Settings.values[cE_nichtEFRE]);

                // Sendung beantragen
                with qMail do
                begin
                  insert;
                  FieldByName('RID').AsInteger := cRID_AutoInc;
                  FieldByName('PERSON_R').AsInteger := PERSON_R;
                  FieldByName('VORLAGE_R').AsInteger := VORLAGE_R;
                  FieldByName('NACHRICHT').Assign(eMailParameter);
                  post;
                end;

              end;
            end;

      until yet;
      ApiNext;

      Log('Ende=' + sTimeStamp);

      // qBAUSTELLE
      _(cFeedback_processmessages);
      _(cFeedback_ProgressBar_StepIt+2);
    end;
    Log('Ende=' + sTimeStamp);
  end;

  cBAUSTELLE.free;
  qMail.free;
  eMailParameter.free;
  Settings.free;
  FTP_UploadMasks.free;
  FTP_UploadFiles.free;
  FTP_DeleteLocal.free;
  CommitL.free;

  result := (ErrorCount = 0);
  _(cFeedback_ProgressBar_position+2);
  {$ifdef fpc}
  {$else}
  FlexCelXLS.Free;
  {$endif}
end;

function e_w_Import(
 {} BAUSTELLE_R: integer;
 {} pOptions: TStringList = nil;
 {} fb: TFeedBack = nil): boolean;

{$I Feedback.inc}

var
  InpStr: string;
  n, m, k, l: integer;
  STime: dword;

  _Monteur_r: integer;
  _Monteur: string;
  _Nummer: string;

  _Name: string;
  _Strasse: string;
  _HausNummer: string;

  _plz: string;
  _ort: string;
  _Art: string;
  _Zeile: string;
  _Zaehlwerke: integer;
  Zaehlwerk: integer;
  Anzahl_Zaehlwerk_0: integer;
  Anzahl_Zaehlwerk_nicht_1: integer;

  _ZaehlerMehrInfo: TStringList;
  _MonteurMehrInfo: TStringList;
  _InternMehrInfo: TStringList;
  _ProtokollMehrInfo: TStringList;
  _ZaehlwerkeAusbau: TStringList;
  _ZaehlwerkeEinbau: TStringList;

  _ZaehlerTyp: string;
  edis: string;
  MoreTextInfo: TStringList;

  // Parameter aus der Baustelle
  Baustelle_StellenAnzZaehlerNummer: integer;
  Baustelle_Ortsteilcodes: boolean;
  Baustelle_Kuerzel: string;

  _Verbraucher_r: integer;
  ThisDate: TANFiXDate;
  SpaltenWerte_Primaer: TStringList;
  SpaltenWerte_Sekundaer: TStringList;
  SubItemIndex: integer;
  SchemaRaw: TStringList;
  InfoFile: TStringList;
  ParameterItems: TStringList;
  AllParameter: string;
  UmsetzerNo: integer;
  ParameterError: boolean;
  AUFTRAG_R: integer;
  qAUFTRAG, qAUFTRAG2: TdboQuery;
  cBAUSTELLE: TdboCursor;
  RID_AT_IMPORT: integer;
  _Date, _Date1, _Date2: TANFiXDate;
  _planquadrat: string;
  MONTEUR_R: integer;
  ImportFileFName: string;
  ImportFile : TStringList;
  Schema : TStringList;
  cAUFTRAG: TdboCursor;

  //
  MoreInfo: TWordIndex;
  OrgCount: integer;
  DeleteCount: integer;
  AllCount: integer;

  // Zählernummer Verwaltung
  ZaehlerNummernInCSV: TStringList;
  ZaehlerNummernImBestand: TStringList; // [<Art> "-" ] Nummer
  Abgelehnte: TStringList;
  _ZaehlerNummer: string; // Zählernummer aus dem Import
  ZaehlerNummerAbgeschnittenCount: integer;

  // ermittelte Spalten Index
  ZaehlerNummer_FieldIndex: integer;
  ZaehlerArt_FieldIndex: integer;
  MaterialNummer_FieldIndex: integer;
  Zaehlwerk_FieldIndex: integer;
  OrtsTeil_FieldIndex: integer;
  VorberechnetePlausibilitaetVon_FieldIndex: integer;
  VorberechnetePlausibilitaetBis_FieldIndex: integer;
  LetzterAblesestand_FieldIndex: integer;
  ZaehlwerkAusbau_FieldIndex, ZaehlwerkEinbau_FieldIndex: Integer;

  Importierte: TStringList;
  lImportierte: TgpIntegerList;
  _zaehler_nummer: string;
  _importFile: TStringList;
  OrtsteileDerQuelle: TStringList;

  // Für Strassen / Planquadrat Informationen
  _LastLocation: string;
  _DieseStrasse: string;
  _DieserOrt: string;
  _HausZusatz: string;
  StrassenListeMitPlanquadrat: TSearchStringList;

  r1AsString: string;
  ABNummer: integer;

  // Verbrauchs Geschichten
  Verbrauch_0_Datum: TANFiXDate;
  Verbrauch_1_Datum: TANFiXDate;
  Verbrauch_0_Zaehler_Stand: int64;
  Verbrauch_1_Zaehler_Stand: int64;

  // Post-Transaktionen
  Transaktionen: TStringList;

  // Parameter
  pSchemaFName : string;
  pDataFName : string;
  pNurDenLetztenBlock : boolean;
  pNurZiffern : boolean;
  pQuellHeaderLines: Integer;
  pNummerConcatArt: boolean;
  pNummerConcatMaterial: boolean;
  pPlanquadrat: string;
  pIgnoreEmptyArt: boolean;
  pQuellDelimiter: Char;
  pEindeutig : boolean;
  pSimulieren : boolean;
  pDeleteMarked: boolean;
  pMarkImported: boolean;
  pOEM : boolean;

  procedure SaveSchema(FName: string);
  var
   OutLines : TStringList;
  begin
   OutLines := TStringList.create;
   OutLines.Add(ImportFileFName);
   OutLines.AddStrings(Schema);
   OutLines.SaveToFile(FName);
   OutLines.Free;
  end;

  procedure LoadImportFile(sFileName:string);
  var
    SpalteNo: integer;
    SpalteNo2: integer;
    OneLine: string;
    n, k: integer;
    sExcelFileName: string;
  begin

    k := revpos('.', sFileName);
    if (k > 0) then
    begin

      // Aus Excel konvertieren?!
      sExcelFileName := copy(sFileName, 1, pred(k));
      k := revpos('.', sExcelFileName);
      if (AnsiUpperCase(copy(sExcelFileName, k, MaxInt)) = AnsiUpperCase(cSpreadsheetExtension)) then
        if FileExists(sExcelFileName) then
          if (FileAge(sFileName) < FileAge(sExcelFileName)) then
            doConversion(Content_Mode_xls2csv, sExcelFileName);

    end;

    if FileExists(sFileName) then
    begin

      LoadFromFileCSV(true, ImportFile, sFileName);

      if (ImportFile.count > 0) then
      begin

        if pOEM then
        begin
          for n := 0 to pred(ImportFile.count) do
            ImportFile[n] := Oem2Ansi(ImportFile[n]);
        end;

        _(cFeedBack_ListBox_clear+3);
        OneLine := ImportFile[0];
        SpalteNo := 0;
        while (OneLine <> '') do
        begin
          inc(SpalteNo);
          _(cFeedBack_ListBox_add+3,
            {} inttostrN(SpalteNo, 2) + ':' + nextp(OneLine, pQuellDelimiter));
        end;
        SpalteNo := CharCount(pQuellDelimiter, ImportFile[0]);

        if (ImportFile.count > 1) then
          SpalteNo2 := CharCount(pQuellDelimiter, ImportFile[1])
        else
          SpalteNo2 := 0;

        // Caches
        _(cFeedBack_ListBox_clear+4);

        //
        _(cFeedBack_Label+14,
         { } '(' + inttostr(ImportFile.count - pQuellHeaderLines) +
         { } ' Datensätze / ' + inttostr(SpalteNo) + '(' + inttostr(SpalteNo2) + ') Spalten)');
      end
      else
      begin
        _(cFeedback_ShowMessage,'Eine andere Anwendung sperrt diese Datei (Excel?!)!' + #13 + 'Oder die Datei ist leer!');
      end;
    end else
    begin
      pQuellHeaderLines := 0;
    end;
  end;

  function sSpaltenWert(i: integer): string;
  begin
    if (i >= 0) and (i < SpaltenWerte_Primaer.count) then
      result := SpaltenWerte_Primaer[i]
    else
      result := '';
  end;

  function sSpaltenWert_Sekundaer(i: integer): string;
  begin
    if (i >= 0) and (i < SpaltenWerte_Sekundaer.count) then
      result := SpaltenWerte_Sekundaer[i]
    else
      result := '';
  end;

  function rSpaltenWert(n: byte): string;
  begin
    result := sSpaltenWert(strtol(ParameterItems[pred(n)]) - 1);
  end;

  function rSpaltenWert_Sekundaer(n: byte): string;
  begin
    result := sSpaltenWert_Sekundaer(strtol(ParameterItems[pred(n)]) - 1);
  end;

  function FormatZaehlerNummer(s: string): string;
  var
    ZaehlerNummer: int64;
    n: integer;
    zn: string;
  begin
    if (Baustelle_StellenAnzZaehlerNummer < 99) then
    begin

      // Grundsätzliche Aktionen
      s := noblank(s);

      // nur den letzten Ziffernblok?
      if pNurDenLetztenBlock then
      begin
        zn := '';
        for n := length(s) downto 1 do
          if CharInSet(s[n], ['0' .. '9']) then
            zn := s[n] + zn
          else
            break;
        s := zn;
      end;

      // Nur Ziffern?
      if pNurZiffern then
        s := StrFilter(s, '0123456789');

      ZaehlerNummer := strtoint64def(s, 0);
      if (ZaehlerNummer <> 0) then
        result := inttostrN(ZaehlerNummer, Baustelle_StellenAnzZaehlerNummer)
      else
        result := Fill('0', Baustelle_StellenAnzZaehlerNummer - length(s)) + s;
    end
    else
    begin
      result := noblank(s);
    end;
    if length(result) > cZaehlerNummerFieldLength then
      inc(ZaehlerNummerAbgeschnittenCount);
  end;

  function FormatZaehlerNummerAsOneWord(s: string): string;
  begin
    // sicherstellen, dass das Word-Index Objekt die Zählernummern nicht zerreist
    result := FormatZaehlerNummer(s);
    ersetze('-', '~', result);
  end;

  function ObtainOrtCode(const _ort: string): string;
  begin
    result := e_r_OrtsteilCode(BAUSTELLE_R, _ort);
  end;

  function artA: string;
  begin
    result := sSpaltenWert(ZaehlerArt_FieldIndex);
    if (Zaehlwerk_FieldIndex <> -1) then
      result := SAP2art(result);
  end;

  function artB: string;
  begin
    result := sSpaltenWert_Sekundaer(ZaehlerArt_FieldIndex);
    if (Zaehlwerk_FieldIndex <> -1) then
      result := SAP2art(result);
  end;

  function Format_HausZusatz(s: string): string;
  begin
    result := cutblank(s) + ' ';
    if CharInSet(result[1], ['0' .. '9']) then
      result := '/' + result;
    result := cutblank(result);
  end;

  function Format_HausNummer(s: string): string;
  begin
    result := cutblank(s);
    while (pos('0', result) = 1) do
      delete(result, 1, 1);
  end;

  function date_JJJJMMTT_2long(s: string): TANFiXDate;
  var
    i: integer;
  begin
    result := 0;
    i := strtointdef(s, 0);
    if (i > date2long(cOrgaMonBirthDay)) then
      result := date2long(copy(s, 7, 2) + '.' + copy(s, 5, 2) + '.' + copy(s, 1, 4))
  end;

  procedure readMinMax(Zaehlwerk: integer; sMin, sMax, sAlt: string);

    function MinMaxToDouble(const s: string): double;
    begin
      result := strtodoubledef(s, -1);
    end;

  var
    dMin, dMax, dAlt: double;
  begin
    dMin := MinMaxToDouble(sMin);
    dMax := MinMaxToDouble(sMax);
    dAlt := MinMaxToDouble(sAlt);
    if (dMin >= 0) and (dMax >= dMin) then
    begin
      _ZaehlerMehrInfo.add('v' + inttostr(Zaehlwerk) + '=' + format('%.2f', [dMin]));
      _ZaehlerMehrInfo.add('b' + inttostr(Zaehlwerk) + '=' + format('%.2f', [dMax]));
      _ZaehlerMehrInfo.add('a' + inttostr(Zaehlwerk) + '=' + format('%.2f', [dAlt]));
    end;
  end;

begin
  result := false;
  // Parameter
  if assigned(pOptions) then
  begin
   with pOptions do
   begin
    pSchemaFName := values['SchemaFileName'];
    pDataFName := values['DataFileName'];
    pNurDenLetztenBlock := (values['NurDenLetztenBlock']=cIni_Activate);
    pNurZiffern := (values['NurZiffern']=cIni_Activate);
    pQuellHeaderLines:= StrToIntDef(values['QuellHeaderLines'],1);
    pNummerConcatArt:= (values['NummerConcatArt']=cIni_Activate);
    pNummerConcatMaterial:= (values['NummerConcatMaterial']=cIni_Activate);
    pPlanquadrat:= values['Planquadrat'];
    pIgnoreEmptyArt:= (values['IgnoreEmptyArt']=cIni_Activate);
    InpStr := values['QuellDelimiter'];
    if (length(InpStr)<>1) then
     pQuellDelimiter := ';'
    else
     pQuellDelimiter := InpStr[1];
    pEindeutig := (values['Eindeutig']<>cIni_DeActivate);
    pSimulieren := (values['Simulieren']=cIni_Activate);
    pDeleteMarked:= (values['DeleteMarked']=cIni_Activate);
    pMarkImported:= (values['MarkImported']<>cIni_DeActivate);
    pOEM := (values['OEM']=cIni_Activate);
   end;
  end else
  begin
    // defaults
    pSchemaFName := '';
    pDataFName := '';
    pNurDenLetztenBlock := false;
    pNurZiffern := false;
    pQuellHeaderLines:= 1;
    pNummerConcatArt:= false;
    pNummerConcatMaterial:= false;
    pPlanquadrat:= '';
    pIgnoreEmptyArt:= false;
    pQuellDelimiter:= ';';
    pEindeutig := true;
    pSimulieren := false;
    pDeleteMarked:= false;
    pMarkImported:= true;
    pOEM := false;
  end;

  // Baustelle ermitteln
  if (BAUSTELLE_R < cRID_FirstValid) then
  begin
    _(cFeedback_ShowMessage,'Keine Baustelle zugeordnet!');
    exit;
  end;

  // Baustellen-Daten einlesen
  cBAUSTELLE := nCursor;
  with cBAUSTELLE do
  begin
    sql.Add('select * from BAUSTELLE where RID=' + IntToStr(BAUSTELLE_R));
    ApiFirst;
    Baustelle_StellenAnzZaehlerNummer := FieldByName('ZAEHLER_NR_STELLEN').AsInteger;
    Baustelle_Ortsteilcodes := (FieldByName('ORTE_AKTIV').AsString = 'Y');
    Baustelle_Kuerzel := FieldByName('NUMMERN_PREFIX').AsString;
    close;
  end;
  FreeAndNil(cBAUSTELLE);

  // Default-Schema setzen
  if (pSchemaFName='') then
   pSchemaFName := SchemaPath+Baustelle_Kuerzel+cSchemaExtension;

  if not(FileExists(pSchemaFName)) then
  begin
    _(cFeedBack_ShowMessage,cERRORText+' Import-Schema "'+pSchemaFName+'" nicht gefunden');
    exit;
  end else
  begin
   Schema := TStringList.Create;
   Schema.LoadFromFile(pSchemaFName);
   ImportFileFName := Schema[0];
   Schema.delete(0);
  end;

  // Overwrite Data-FileName
  if (pDataFName<>'') then
   if (ImportFileFName<>pDataFName) then
   begin
     _(cFeedBack_ShowMessage,
       {} cWARNINGText +
       {} ' lade ' + pDataFName +
       {} ' anstelle von ' + ImportFileFName);
     ImportFileFName := pDataFName;
   end;

  // Load Data
  ImportFile := TStringList.Create;
  LoadImportFile(ImportFileFName);

  ZaehlerNummernInCSV := TStringList.create;
  ZaehlerNummernImBestand := TStringList.create;
  OrtsteileDerQuelle := TStringList.create;
  Transaktionen := TStringList.create;
  SpaltenWerte_Primaer := nil;

  ZaehlerNummerAbgeschnittenCount := 0;
  DeleteCount := 0;
  OrgCount := ImportFile.count - pQuellHeaderLines;
  ZaehlerNummer_FieldIndex := -1;
  ZaehlerArt_FieldIndex := -1;
  MaterialNummer_FieldIndex := -1;
  Zaehlwerk_FieldIndex := -1;
  OrtsTeil_FieldIndex := -1;
  VorberechnetePlausibilitaetVon_FieldIndex := -1;
  VorberechnetePlausibilitaetBis_FieldIndex := -1;
  LetzterAblesestand_FieldIndex := -1;
  ZaehlwerkAusbau_FieldIndex:= -1;
  ZaehlwerkEinbau_FieldINdex:= -1;


  for n := 0 to pred(Schema.count) do
  begin

    InpStr := Schema[n];
    nextp(InpStr, '(');

    repeat

      if pos('Art' + '(', Schema[n]) = 1 then
      begin
        ZaehlerArt_FieldIndex := pred(strtol(nextp(InpStr, ')')));
        break;
      end;

      if pos('SAP_Art_#_#' + '(', Schema[n]) = 1 then
      begin
        ZaehlerArt_FieldIndex := pred(strtol(nextp(InpStr, ',')));
        Zaehlwerk_FieldIndex := pred(strtol(nextp(InpStr, ')')));
        pNummerConcatArt := true;
        break;
      end;

      if pos('Zähler_Nummer' + '(', Schema[n]) = 1 then
      begin
        ZaehlerNummer_FieldIndex := pred(strtol(nextp(InpStr, ')')));
        break;
      end;

      if pos('Material_Nummer' + '(', Schema[n]) = 1 then
      begin
        MaterialNummer_FieldIndex := pred(strtol(nextp(InpStr, ')')));
        break;
      end;

      if pos('Zähler_Ort_Ortsteil' + '(', Schema[n]) = 1 then
      begin
        OrtsTeil_FieldIndex := pred(strtol(nextp(InpStr, ')')));
        break;
      end;

      if pos('C_Zähler_Ort_Ortsteil' + '(', Schema[n]) = 1 then
      begin
        OrtsteileDerQuelle.add(nextp(InpStr, ')'));
        break;
      end;

      if pos('Plausibilität_Min_Max_#_#_#' + '(', Schema[n]) = 1 then
      begin
        VorberechnetePlausibilitaetVon_FieldIndex := pred(strtol(nextp(InpStr, ',')));
        VorberechnetePlausibilitaetBis_FieldIndex := pred(strtol(nextp(InpStr, ',')));
        LetzterAblesestand_FieldIndex := pred(strtol(nextp(InpStr, ')')));
        break;
      end;

      if pos('Zählwerk-Ausbau' + '(', Schema[n]) = 1 then
      begin
        ZaehlwerkAusbau_FieldIndex := pred(strtol(nextp(InpStr, ')')));
        break;
      end;

      if pos('Zählwerk-Einbau' + '(', Schema[n]) = 1 then
      begin
        ZaehlwerkEinbau_FieldIndex := pred(strtol(nextp(InpStr, ')')));
        break;
      end;


    until yet;
  end;

  // P r ü f u n g e n
  if (ZaehlerNummer_FieldIndex = -1) then
  begin
    _(cFeedback_ShowMessage,'Das Feld Zähler_Nummer muss importiert werden!');
    ZaehlerNummernImBestand.free;
    exit;
  end;

  if pNummerConcatArt and (ZaehlerArt_FieldIndex = -1) then
  begin
    _(cFeedback_ShowMessage,'Das Feld Art muss importiert werden!');
    ZaehlerNummernImBestand.free;
    exit;
  end;

  if pNummerConcatMaterial and (MaterialNummer_FieldIndex = -1) then
  begin
    _(cFeedback_ShowMessage,'Das Feld Material_Nummer muss importiert werden!');
    ZaehlerNummernImBestand.free;
    exit;
  end;

  cAUFTRAG := nCursor;
  with cAUFTRAG do
  begin
    sql.add('SELECT');
    sql.add(' ZAEHLER_NUMMER,');
    sql.add(' MATERIAL_NUMMER,');
    sql.add(' RID,');
    sql.add(' ART,');
    sql.add(' PLANQUADRAT,');
    sql.add(' KUNDE_STRASSE,');
    sql.add(' KUNDE_ORT,');
    sql.add(' STATUS,');
    sql.add(' KUNDE_ORTSTEIL');
    sql.add('FROM');
    sql.add(' AUFTRAG');
    sql.add('WHERE');
    sql.add(' (BAUSTELLE_R='+IntToStr(BAUSTELLE_R)+') and');
    sql.add(' (RID=MASTER_R)');
    sql.add('ORDER BY');
    sql.add(' STRASSE');
    ApiFirst;
    while not(eof) do
    begin

      // Zählernummern sammeln
      repeat

        // ab verwendet und OK?
        if (pPlanquadrat <> '') then
          if (FieldByName('PLANQUADRAT').AsString < pPlanquadrat) then
            break;

        // hinzunehmen
        _ZaehlerNummer := FormatZaehlerNummer(FieldByName('ZAEHLER_NUMMER').AsString);

        if pNummerConcatArt then
          _ZaehlerNummer := e_r_Sparte(FieldByName('ART').AsString) + '~' + _ZaehlerNummer;

        if pNummerConcatMaterial then
          _ZaehlerNummer := FieldByName('MATERIAL_NUMMER').AsString + '~' + _ZaehlerNummer;

        ZaehlerNummernImBestand.addobject(_ZaehlerNummer, TObject(FieldByName('RID').AsInteger));

      until true;

      next;
    end;
    close;
  end;
  ZaehlerNummernImBestand.Sort;
  RemoveDuplicates(ZaehlerNummernImBestand, DeleteCount);

  if (DeleteCount > 0) then
  begin
    if (
        _(cFeedback_Doit,
       { } 'Info: Die angegebene Baustelle hat schon' + #13 +
       { } 'ohne diesen Import doppelte Zählernummern!' + #13 +
       { } 'Mit dem Schalter 33/33 können Sie die doppelten' + #13 +
       { } 'anzeigen. Wollen Sie dennoch importieren')=cFeedBack_FALSE) then
    begin
      ZaehlerNummernInCSV.free;
      ZaehlerNummernImBestand.free;
      exit;
    end;
  end;

  // Spalte "Zählernummer" nun laden:
  if pNummerConcatArt then
  begin
    _zaehler_nummer := '#';
    // mit Art
    for m := pQuellHeaderLines to pred(ImportFile.count) do
    begin
      SpaltenWerte_Primaer := Split(ImportFile[m], pQuellDelimiter, '"');
      _Art := artA;
      repeat

        // Leere Art weglassen!
        if pIgnoreEmptyArt then
          if (_Art = '') then
            break;

        // Zählwerke<>'1' weglassen
        if (Zaehlwerk_FieldIndex <> -1) then
        begin
          // es wird nur EINE Zeile eines identischen Blocks importiert, danach
          // wird ignoriert!
          if (_zaehler_nummer = sSpaltenWert(ZaehlerNummer_FieldIndex)) then
            break;
          k := strtointdef(sSpaltenWert(Zaehlwerk_FieldIndex), 0);
          if (k <> 1) then
            break;

          // keine gültige Zeile -> löschen
          _zaehler_nummer := sSpaltenWert(ZaehlerNummer_FieldIndex);
          ZaehlerNummernInCSV.addobject(e_r_Sparte(_Art) + FormatZaehlerNummerAsOneWord(_zaehler_nummer), TObject(m));

        end
        else
        begin

          //
          ZaehlerNummernInCSV.addobject(e_r_Sparte(_Art) + FormatZaehlerNummerAsOneWord
            (sSpaltenWert(ZaehlerNummer_FieldIndex)), TObject(m));
        end;
      until true;
      FreeAndNil(SpaltenWerte_Primaer);
    end;
  end
  else
  begin
    // ohne Art-Ergänzung
    for m := pQuellHeaderLines to pred(ImportFile.count) do
    begin
      SpaltenWerte_Primaer := Split(ImportFile[m], pQuellDelimiter, '"');
      _Art := artA;
      repeat
        // Leere Art weglassen!
        if pIgnoreEmptyArt then
          if (_Art = '') then
            break;

        ZaehlerNummernInCSV.addobject(FormatZaehlerNummerAsOneWord(sSpaltenWert(ZaehlerNummer_FieldIndex)), TObject(m));
      until true;
      FreeAndNil(SpaltenWerte_Primaer);
    end;
  end;

  // Schreibe Diagnose-Datei
  AllCount := ZaehlerNummernInCSV.count;
  MoreInfo := TWordIndex.create(ZaehlerNummernInCSV, 1);
  MoreInfo.saveToDiagFile(DiagnosePath + 'Import-Doppelte.txt', 2, MaxInt);
  ZaehlerNummernInCSV.Sort;
  ZaehlerNummernInCSV.SaveToFile(DiagnosePath + 'Import-ZaehlerNummern.txt');
  RemoveDuplicates(ZaehlerNummernInCSV, DeleteCount);
  MoreInfo.free;

  // auf die eindeutigen reduzieren!
  if (ZaehlerNummerAbgeschnittenCount > 0) then
  begin
    if (_(cFeedback_doit,
     { } 'Die Baustelle hat keinen Eintrag ' + #13 +
     { } 'in "Anzahl der Stellen Zählernummer".' + #13 +
     { } 'Es mussten daher sehr lange Zählernummern' + #13 +
     { } '(>15 Zeichen) abgeschnitten werden.' + #13 +
     { } 'Drücken Sie jetzt <ABBRECHEN> um dennoch zu importieren!' + #13 +
     { } 'Zurück')=cFeedBack_TRUE) then
    begin
      ZaehlerNummernInCSV.free;
      ZaehlerNummernImBestand.free;
      exit;
    end;
  end;

  if (DeleteCount > 0) then
  begin
    if (_(cFeedBack_doit,
      {} 'Es gibt ' + inttostr(DeleteCount) + ' doppelte Zählernummern in der csv!' + #13 + inttostr(AllCount) +
      {} ' Nummern insgesamt!' + #13 + 'Drücken Sie jetzt <OK> für eine Diagnose!' + #13 +
      {} ' Sie erhalten eine Aufstellung der Doppelten und sollten' + #13 +
      {} ' im Anschluss die "falschen" doppelten entfernen!' + #13 +
      {} 'Drücken Sie jetzt <ABBRECHEN> um dennoch zu importieren!' + #13 +
      {} ' Doppelte Nummern werden dabei nicht importiert!' + #13)=cFeedBack_TRUE) then
    begin
      ZaehlerNummernInCSV.free;
      ZaehlerNummernImBestand.free;
      _(cFeedBack_openShell,DiagnosePath + 'Import-Doppelte.txt');
      exit;
    end;
  end;

  ZaehlerNummernInCSV.free;

  // noch sehen, ob es alle Ortsteile in der Baustelle schon gibt!
  if Baustelle_Ortsteilcodes then
  begin

    if (OrtsTeil_FieldIndex > -1) then
      for m := pQuellHeaderLines to pred(ImportFile.count) do
        OrtsteileDerQuelle.add(cutblank(nextp(ImportFile[m], pQuellDelimiter, OrtsTeil_FieldIndex)));
    // NIX NIX ^
    OrtsteileDerQuelle.Sort;
    RemoveDuplicates(OrtsteileDerQuelle);

    for m := pred(OrtsteileDerQuelle.count) downto 0 do
    begin
      if (e_r_OrtsteilCode(BAUSTELLE_R, OrtsteileDerQuelle[m]) <> '??') or (OrtsteileDerQuelle[m] = '') then
        OrtsteileDerQuelle.delete(m);
    end;

    if (OrtsteileDerQuelle.count > 0) then
    begin
      for m := 0 to pred(OrtsteileDerQuelle.count) do
        OrtsteileDerQuelle[m] := OrtsteileDerQuelle[m] + '=';
      OrtsteileDerQuelle.Insert(0, '// ');
      OrtsteileDerQuelle.Insert(1, '// Unten sind neue Ortsteile angegeben, die in der Baustelle noch');
      OrtsteileDerQuelle.Insert(2, '// nicht eingetragen sind. Kopieren Sie die Zeilen in die ');
      OrtsteileDerQuelle.Insert(3, '// Zwischenablage. Wählen Sie Baustelle->richtige Baustelle');
      OrtsteileDerQuelle.Insert(4, '// auswählen->Verabeiten. Fügen Sie die neuen Orsteile aus');
      OrtsteileDerQuelle.Insert(5, '// der Zwischenablage ein. Versehen Sie die Ortsteile mit');
      OrtsteileDerQuelle.Insert(6, '// einem Code. Versuchen Sie den Import danach nochmals.');
      OrtsteileDerQuelle.Insert(7, '// ');
      OrtsteileDerQuelle.SaveToFile(DiagnosePath + 'NeueOrtsteile.txt');
      _(cFeedBack_ShowMessage,'Es gibt Ortsteile, die noch nicht eingetragen sind!');
      _(cFeedBack_openShell,DiagnosePath + 'NeueOrtsteile.txt');
      exit;
    end;

  end;

  // wow, eigentlicher Import startet hier
  SchemaRaw := TStringList.create;
  InfoFile := TStringList.create;
  StrassenListeMitPlanquadrat := TSearchStringList.create;

  InfoFile.add('Benutzer ' + sBearbeiterKurz + ' mit Rev. ' + RevToStr(globals.Version));
  InfoFile.add('Datum ' + datum);
  InfoFile.add('Uhr ' + uhr);
  InfoFile.add('Baustelle ' + inttostr(BAUSTELLE_R) + '=' + e_r_BaustelleKuerzel(BAUSTELLE_R));
  InfoFile.add(' Ortsteillogik [' + booltostr(Baustelle_Ortsteilcodes) + ']');
  InfoFile.add('doppelte ablehnen [' + booltostr(pEindeutig) + ']');
  InfoFile.add('numerisch [' + booltostr(pNurZiffern) + ']');
  InfoFile.add('letzter Block [' + booltostr(pNurDenLetztenBlock) + ']');
  InfoFile.add('nur simulieren [' + booltostr(pSimulieren) + ']');

  ParameterError := false;

  SchemaRaw.AddStrings(Schema);
  for n := 0 to pred(SchemaRaw.count) do
  begin

    AllParameter := SchemaRaw[n];
    AllParameter := copy(AllParameter, succ(pos('(', AllParameter)), MaxInt);
    delete(AllParameter, length(AllParameter), 1);

    // Umsetzer Nummer ermitteln!
    for m := 0 to high(cImportFields) do
      if pos(cImportFields[m] + '(', SchemaRaw[n]) = 1 then
      begin
        SchemaRaw[n] := inttostrN(m, 2) + ':' + SchemaRaw[n];
        break;
      end;

    // Alle Parameter in eine Stringliste
    ParameterItems := TStringList.create;
    SchemaRaw.objects[n] := ParameterItems;

    for m := 1 to 3 do
      ParameterItems.add(nextp(AllParameter, ','));
  end;

  if not(ParameterError) then
  begin
    _(cFeedBack_ProgressBar_max+1,IntToStr( ImportFile.count));

    // neue Nummer erzeugen
    RID_AT_IMPORT := e_w_GEN('GEN_AUFTRAG');
    _(cFeedBack_Edit+1,inttostr(RID_AT_IMPORT));
    _(cFeedBack_Function+3,inttostr(RID_AT_IMPORT));

    // in qAUFTRAG wird importiert
    qAUFTRAG := nQuery;
    with qAUFTRAG do
    begin
      sql.add('SELECT *');
      sql.add('FROM AUFTRAG');
      sql.add('FOR UPDATE');
      open;
    end;
    ABNummer := e_r_AuftragNummer(BAUSTELLE_R) + 1;

    // Sicherungskopieren anlegen
    CheckCreateDir(ImportePath + inttostr(RID_AT_IMPORT));
    SaveSchema(ImportePath + inttostr(RID_AT_IMPORT) + '\Schema' + cSchemaExtension);
    ImportFile.SaveToFile(ImportePath + inttostr(RID_AT_IMPORT) + '\Daten.csv');

    InfoFile.Insert(0, 'Import-RID: ' + inttostr(RID_AT_IMPORT));
    STime := 0;
    Anzahl_Zaehlwerk_0 := 0;
    Anzahl_Zaehlwerk_nicht_1 := 0;

    MoreTextInfo := TStringList.create;
    _ZaehlerMehrInfo := TStringList.create;
    _MonteurMehrInfo := TStringList.create;
    _InternMehrInfo := TStringList.create;
    _ProtokollMehrInfo := TStringList.create;
    _ZaehlwerkeAusbau := TStringList.create;
    _ZaehlwerkeEinbau := TStringList.create;

    Abgelehnte := TStringList.create;
    Importierte := TStringList.create;

    for m := 0 to pred(pQuellHeaderLines) do
      Abgelehnte.add(ImportFile[m]);
    for m := 0 to pred(pQuellHeaderLines) do
      Importierte.add(ImportFile[m]);

    InfoFile.add('Import-Quelle: ursprüngliche Anzahl ' + inttostr(OrgCount));
    InfoFile.add('Import-Quelle: doppelte Zählernummern ' + inttostr(DeleteCount));
    InfoFile.add('Import-Quelle: Anzahl reduziert auf ' + inttostr(ImportFile.count - pQuellHeaderLines));
    _LastLocation := '!null!';

    ZaehlerNummernImBestand.add('### neue Nummern ###');

    // tatsächlicher Import
    with qAUFTRAG do
      for n := pQuellHeaderLines to pred(ImportFile.count) do
      begin

        // Ab jetzt kommt ein echter Datensatz!
        if assigned(SpaltenWerte_Primaer) then
          FreeAndNil(SpaltenWerte_Primaer);
        SpaltenWerte_Primaer := Split(ImportFile[n], pQuellDelimiter, '"');

        if pIgnoreEmptyArt then
          if (artA = '') then
            continue;

        if (Zaehlwerk_FieldIndex <> -1) then
        begin
          // Nur Zeilen mit Zaehlwerk=1 wird beachtet!!
          Zaehlwerk := strtointdef(sSpaltenWert(Zaehlwerk_FieldIndex), 0);
          if (Zaehlwerk = 0) then
            inc(Anzahl_Zaehlwerk_0);
          if (Zaehlwerk <> 1) then
          begin
            inc(Anzahl_Zaehlwerk_nicht_1);

            // für dieses Zählwerk die InternInfos erweitern
            qAUFTRAG2 := nQuery;
            with qAUFTRAG2 do
            begin
              sql.add('SELECT INTERN_INFO FROM AUFTRAG WHERE RID=' + inttostr(AUFTRAG_R) + ' for update');
              open;
              first;
              edit;
              e_r_sqlt(FieldByName('INTERN_INFO'),_InternMehrInfo);
              for m := 0 to pred(SchemaRaw.count) do
              begin
                UmsetzerNo := strtoint(copy(SchemaRaw[m], 1, 2));
                if (UmsetzerNo = 39) then
                begin
                  ParameterItems := SchemaRaw.objects[m] as TStringList;
                  _InternMehrInfo.add(cutblank(
                    { } ParameterItems[0] +
                    { } '.' + inttostr(Zaehlwerk) +
                    { } '=' +
                    { } rSpaltenWert(2)));
                end;
              end;
              FieldByName('INTERN_INFO').assign(_InternMehrInfo);
              post;
            end;
            FreeAndNil(qAUFTRAG2);

            // ansonsten nix mehr machen
            continue;
          end;
        end;

        _ZaehlerMehrInfo.clear;
        _MonteurMehrInfo.clear;
        _InternMehrInfo.clear;
        _ProtokollMehrInfo.clear;
        _ZaehlwerkeAusbau.clear;
        _ZaehlwerkeEinbau.clear;

        AUFTRAG_R := e_w_GEN('GEN_AUFTRAG');

        Insert; // neue Auftragszeile!

        // setze Standards
        FieldByName('RID').AsInteger := AUFTRAG_R;
        FieldByName('PROTECT_RID').AsInteger := 1; //cC_True;  //Fix Fehlermeldung Import 14102024/MJ
        FieldByName('BAUSTELLE_R').AsInteger := BAUSTELLE_R;
        FieldByName('RID_AT_IMPORT').AsInteger := RID_AT_IMPORT;
        FieldByName('EVENODD').AsString := cC_True;

        // jetzt die Feld-Umsetzer
        try
          for m := 0 to pred(SchemaRaw.count) do
          begin
            UmsetzerNo := strtoint(copy(SchemaRaw[m], 1, 2));
            ParameterItems := SchemaRaw.objects[m] as TStringList;
            case UmsetzerNo of
              00:
                begin
                  // 'Art',
                  FieldByName('ART').AsString := rSpaltenWert(1);
                end;
              01:
                begin
                  // 'Zähler_Nummer',
                  _zaehler_nummer := FormatZaehlerNummer(rSpaltenWert(1));
                  FieldByName('ZAEHLER_NUMMER').AsString := _zaehler_nummer;
                end;
              02:
                begin
                  // 'Zähler_Ort_Name1',
                  FieldByName('KUNDE_NAME1').AsString := rSpaltenWert(1);
                end;
              03:
                begin
                  // 'Zähler_Ort_Name2',
                  FieldByName('KUNDE_NAME2').AsString := rSpaltenWert(1);
                end;
              04:
                begin
                  // 'Zähler_Ort_Strasse',
                  FieldByName('KUNDE_STRASSE').AsString := rSpaltenWert(1);
                end;
              05:
                begin
                  // 'Zähler_Ort_Strasse_#_#_#',
                  FieldByName('KUNDE_STRASSE').AsString :=
                    cutblank(cutblank(rSpaltenWert(1)) + ' ' + Format_HausNummer(rSpaltenWert(2)) +
                    Format_HausZusatz(rSpaltenWert(3)));
                end;
              06:
                begin
                  // 'Zähler_Ort_Ort',
                  FieldByName('KUNDE_ORT').AsString := rSpaltenWert(1);
                end;
              07:
                begin
                  // 'Zähler_Ort_Ort_#_#',
                  FieldByName('KUNDE_ORT').AsString := cutblank(rSpaltenWert(1)) + ' ' + rSpaltenWert(2);
                end;
              08:
                begin
                  // 'Zähler_Info_#_#', // Konstante + Feld -> eine Zeile
                  if (ParameterItems[0] <> '') then
                  begin
                    if (strtointdef(ParameterItems[1], -1) = -1) then
                      _ZaehlerMehrInfo.add(ParameterItems[0] + '_' + ParameterItems[1])
                    else
                      _ZaehlerMehrInfo.add(ParameterItems[0] + '_' + rSpaltenWert(2));
                  end
                  else
                  begin
                    if (rSpaltenWert(2) <> '') then
                      _ZaehlerMehrInfo.add(rSpaltenWert(2));
                  end;
                end;
              09:
                begin
                  // 'Zähler_Planquadrat',
                  _planquadrat := noblank(rSpaltenWert(1));
                  if (length(_planquadrat) < cAutoPlanquadratLength) then
                    _planquadrat := Fill('0', cAutoPlanquadratLength - length(_planquadrat)) + _planquadrat;
                  FieldByName('PLANQUADRAT').AsString := _planquadrat;
                end;
              10:
                begin
                  // 'Kunde_Brief_Nummer',
                  FieldByName('KUNDE_NUMMER').AsString := rSpaltenWert(1);
                end;
              11:
                begin
                  // 'Kunde_Brief_Name1',
                  FieldByName('BRIEF_NAME1').AsString := rSpaltenWert(1);
                end;
              12:
                begin
                  // 'Kunde_Brief_Name2',
                  FieldByName('BRIEF_NAME2').AsString := rSpaltenWert(1);
                end;
              13:
                begin
                  // 'Kunde_Brief_Straße',
                  FieldByName('BRIEF_STRASSE').AsString := rSpaltenWert(1);
                end;
              14:
                begin
                  // 'Kunde_Brief_Ort',
                  FieldByName('BRIEF_ORT').AsString := rSpaltenWert(1);
                end;
              15:
                begin
                  // 'Kunde_Brief_Ort_#_#' );
                  FieldByName('BRIEF_ORT').AsString := cutblank(rSpaltenWert(1)) + ' ' + rSpaltenWert(2);
                end;
              16:
                begin
                  // 'Monteur_Info_#_#'
                  if (ParameterItems[0] = '') then
                  begin
                    _Zeile := cutblank(rSpaltenWert(2));
                    while (_Zeile <> '') do
                      _MonteurMehrInfo.add(cutblank(nextp(_Zeile, cLineSeparator)));
                  end
                  else
                  begin
                    _MonteurMehrInfo.add(cutblank(ParameterItems[0] + '_' + rSpaltenWert(2)))
                  end;
                end;
              17:
                begin
                  // 'C_Art_Info'
                  FieldByName('ART').AsString := ParameterItems[0];
                end;
              18:
                begin
                  // 'C_Zähler_Ort_Info'
                  FieldByName('KUNDE_ORT').AsString := ParameterItems[0];
                end;
              19:
                begin
                  _Date := date2long(rSpaltenWert(1));
                  if DateOK(_Date) then
                    FieldByName('SPERRE_VON').AsDateTime := long2datetime(_Date);
                end;
              20:
                begin
                  _Date := date2long(rSpaltenWert(1));
                  if DateOK(_Date) then
                    FieldByName('SPERRE_BIS').AsDateTime := long2datetime(_Date);
                end;
              21:
                begin
                  FieldByName('BRIEF_STRASSE').AsString :=
                    { } cutblank(cutblank(rSpaltenWert(1)) + ' ' +
                    { } Format_HausNummer(rSpaltenWert(2)) +
                    { } Format_HausZusatz(rSpaltenWert(3)));
                end;
              22:
                begin
                  // Kunde_Brief_Name1_#_#
                  FieldByName('BRIEF_NAME1').AsString := cutblank(rSpaltenWert(1)) + ' ' + rSpaltenWert(2);
                end;
              23:
                begin
                  // Intern_Info_#_#
                  if (pos('=',ParameterItems[0])=0) then
                   _InternMehrInfo.add(cutblank(ParameterItems[0] + '_' + rSpaltenWert(2)))
                  else
                   _InternMehrInfo.add(cutblank(ParameterItems[0] + rSpaltenWert(2)));
                end;
              24:
                begin
                  FieldByName('KUNDE_ORTSTEIL').AsString := rSpaltenWert(1);
                end;
              25:
                begin
                  FieldByName('BRIEF_ORT').AsString := cutblank(rSpaltenWert(1)) + ' ' + cutblank(rSpaltenWert(2)) + ' '
                    + rSpaltenWert(3);
                end;
              26:
                begin
                  FieldByName('PLANQUADRAT').AsString := rSpaltenWert(1) + rSpaltenWert(2);
                end;
              27:
                begin
                  Verbrauch_1_Datum := 0;
                  if DateOK(date2long(rSpaltenWert(1))) then
                  begin
                    Verbrauch_1_Datum := date2long(rSpaltenWert(1));
                    appendstringstofile(
                      rSpaltenWert(1) + ';' + inttostr(Verbrauch_1_Datum),
                      ImportePath + 'datums.txt');

                    FieldByName('VERBRAUCH_DATUM').AsDateTime := long2datetime(date2long(rSpaltenWert(1)));
                  end;
                end;
              28:
                begin
                  Verbrauch_1_Zaehler_Stand := strtoint64def(rSpaltenWert(1), -1);
                  FieldByName('VERBRAUCH_ZAEHLER_STAND').AsString := inttostr(Verbrauch_1_Zaehler_Stand);
                end;
              29:
                begin
                  FieldByName('VERBRAUCH_PRO_JAHR').AsString := rSpaltenWert(1);
                end;
              30:
                begin
                  FieldByName('REGLER_NR').AsString := rSpaltenWert(1);
                end;
              31:
                begin
                  MONTEUR_R := e_r_MonteurRIDFromKuerzel(ParameterItems[0]);
                  if (MONTEUR_R > 0) then
                    FieldByName('MONTEUR1_R').AsInteger := MONTEUR_R;
                end;
              32:
                begin
                  MONTEUR_R := e_r_MonteurRIDFromKuerzel(ParameterItems[0]);
                  if (MONTEUR_R > 0) then
                    FieldByName('MONTEUR2_R').AsInteger := MONTEUR_R;
                end;
              33:
                begin
                  // numerische Angabe?
                  MONTEUR_R := strtointdef(rSpaltenWert(1), cRID_Unset);
                  if MONTEUR_R < cRID_FirstValid then
                    // Kürzel angegeben?
                    MONTEUR_R := e_r_MonteurRIDFromKuerzel(rSpaltenWert(1));
                  if (MONTEUR_R >= cRID_FirstValid) then
                    FieldByName('MONTEUR1_R').AsInteger := MONTEUR_R;
                end;
              34:
                begin
                  MONTEUR_R := strtointdef(rSpaltenWert(1), cRID_Unset);
                  if MONTEUR_R < cRID_FirstValid then
                    MONTEUR_R := e_r_MonteurRIDFromKuerzel(rSpaltenWert(1));
                  if (MONTEUR_R >= cRID_FirstValid) then
                    FieldByName('MONTEUR2_R').AsInteger := MONTEUR_R;
                end;
              35:
                begin
                  r1AsString := noblank(AnsiUpperCase(rSpaltenWert(1)));
                  if r1AsString <> '' then
                    FieldByName('WORDEMPFAENGER').AsString := r1AsString;
                end;
              36:
                begin
                  // C_Zähler_Ort_Ortsteil
                  FieldByName('KUNDE_ORTSTEIL').AsString := ParameterItems[0];
                end;
              37:
                begin
                  // 'Verbrauch_0_Datum',
                  Verbrauch_0_Datum := 0;
                  if DateOK(date2long(rSpaltenWert(1))) then
                  begin
                    Verbrauch_0_Datum := date2long(rSpaltenWert(1));
                  end;
                end;
              38:
                begin
                  // 'Verbrauch_0_Zähler_Stand'
                  Verbrauch_0_Zaehler_Stand := strtoint64def(rSpaltenWert(1), -1);
                  //

                  if (Verbrauch_1_Zaehler_Stand > 0) then
                    if (Verbrauch_0_Zaehler_Stand > 0) then
                      if DateOK(Verbrauch_0_Datum) then
                        if DateOK(Verbrauch_1_Datum) then
                          if (Verbrauch_0_Datum < Verbrauch_1_Datum) then
                          begin
                            FieldByName('VERBRAUCH_PRO_JAHR').AsString :=
                              inttostr(round((Verbrauch_1_Zaehler_Stand - Verbrauch_0_Zaehler_Stand) /
                              DateDiff(Verbrauch_0_Datum, Verbrauch_1_Datum) * 365));
                          end;

                end;
              39: // SAP_Info_#_#
                begin
                  _InternMehrInfo.add(cutblank(ParameterItems[0] + '=' + rSpaltenWert(2)));
                end;
              40: // SAP Art
                begin

                  _Art := SAP2art(rSpaltenWert(1));
                  _Zaehlwerke := 1;

                  if (ZaehlwerkAusbau_FieldIndex<>-1) then
                  begin
                    edis := noblank(sSpaltenWert(ZaehlwerkAusbau_FieldIndex));
                    if (edis<>'') then
                     _ZaehlwerkeAusbau.Add(edis);
                  end;

                  if (ZaehlwerkEinbau_FieldIndex<>-1) then
                  begin
                    edis := noblank(sSpaltenWert(ZaehlwerkEinbau_FieldIndex));
                    if (edis<>'') then
                     _ZaehlwerkeEinbau.Add(edis);
                  end;

                  SpaltenWerte_Sekundaer := nil;
                  for k := succ(n) to pred(ImportFile.count) do
                  begin

                    if assigned(SpaltenWerte_Sekundaer) then
                      FreeAndNil(SpaltenWerte_Sekundaer);
                    SpaltenWerte_Sekundaer := Split(ImportFile[k], pQuellDelimiter, '"');

                    l := strtointdef(sSpaltenWert_Sekundaer(Zaehlwerk_FieldIndex), 0);

                    // weitere Zeilen müssen Werte >1 haben
                    if (l < 2) then
                      break;

                    // das grösste Zählwerk ermitteln!
                    if (l > _Zaehlwerke) then
                      _Zaehlwerke := l;

                    if (ZaehlwerkAusbau_FieldIndex<>-1) then
                    begin
                      edis := noblank(sSpaltenWert_Sekundaer(ZaehlwerkAusbau_FieldIndex));
                      if (edis<>'') then
                       _ZaehlwerkeAusbau.Add(edis);
                    end;

                    if (ZaehlwerkEinbau_FieldIndex<>-1) then
                    begin
                      edis := noblank(sSpaltenWert_Sekundaer(ZaehlwerkEinbau_FieldIndex));
                      if (edis<>'') then
                       _ZaehlwerkeEinbau.Add(edis);
                    end;

                    _ZaehlerNummer := FormatZaehlerNummer(sSpaltenWert_Sekundaer(ZaehlerNummer_FieldIndex));
                    if (_ZaehlerNummer <> _zaehler_nummer) then
                    begin
                      if (l = 2) then
                        FieldByName('REGLER_NR').AsString := _ZaehlerNummer
                      else
                        break;
                    end;

                  end;
                  if assigned(SpaltenWerte_Sekundaer) then
                    FreeAndNil(SpaltenWerte_Sekundaer);

                  // Zählwerk eintragen!
                  if (_Zaehlwerke > 1) then
                    _Art := _Art + inttostr(min(9, _Zaehlwerke));
                  FieldByName('ART').AsString := _Art;

                end;
              41:
                begin
                  FieldByName('ZAEHLER_STAND_ALT').AsString := rSpaltenWert(1);
                end;
              42:
                begin
                  FieldByName('ZAEHLER_STAND_NEU').AsString := rSpaltenWert(1);
                end;
              43:
                begin
                  FieldByName('KUNDE_NAME1').AsString :=
                    cutblank(cutblank(rSpaltenWert(1)) + ' ' + cutblank(rSpaltenWert(2)));
                end;
              44:
                begin
                  FieldByName('KUNDE_NAME2').AsString :=
                    cutblank(cutblank(rSpaltenWert(1)) + ' ' + cutblank(rSpaltenWert(2)));
                end;
              45:
                begin
                  _Date := date2long(rSpaltenWert(1));
                  if DateOK(_Date) then
                    FieldByName('ZEITRAUM_VON').AsDateTime := long2datetime(_Date);
                end;
              46:
                begin
                  _Date := date2long(rSpaltenWert(1));
                  if DateOK(_Date) then
                    FieldByName('ZEITRAUM_BIS').AsDateTime := long2datetime(_Date);
                end;
              47:
                begin
                  r1AsString := noblank(rSpaltenWert(1));
                  if (length(r1AsString) = 8) then
                    r1AsString := copy(r1AsString, 7, 2) + { TT }
                      copy(r1AsString, 5, 2) + { MM }
                      copy(r1AsString, 1, 4) { JJJJ }
                      ;
                  _Date := date2long(r1AsString);
                  if DateOK(_Date) then
                  begin
                    _Date1 := DatePlus(_Date, -strtointdef(ParameterItems[1], 0));
                    _Date2 := DatePlus(_Date, strtointdef(ParameterItems[2], 0));
                    FieldByName('ZEITRAUM_VON').AsDateTime := long2datetime(_Date1);
                    FieldByName('ZEITRAUM_BIS').AsDateTime := long2datetime(_Date2);
                  end;
                end;
              48:
                begin
                  r1AsString := noblank(rSpaltenWert(1));
                  if (length(r1AsString) = 8) then
                    r1AsString := copy(r1AsString, 7, 2) + { TT }
                      copy(r1AsString, 5, 2) + { MM }
                      copy(r1AsString, 1, 4) { JJJJ }
                      ;
                  _Date := date2long(r1AsString);
                  if DateOK(_Date) then
                  begin
                    _Date1 := DatePlus(_Date, -strtointdef(ParameterItems[1], 0));
                    _Date2 := DatePlus(_Date, strtointdef(ParameterItems[2], 0));
                    FieldByName('SPERRE_VON').AsDateTime := long2datetime(_Date1);
                    FieldByName('SPERRE_BIS').AsDateTime := long2datetime(_Date2);
                  end;
                end;
              49:
                begin
                  _Date := date_JJJJMMTT_2long(rSpaltenWert(1));
                  if DateOK(_Date) then
                    FieldByName('SPERRE_VON').AsDateTime := long2datetime(_Date);
                end;
              50:
                begin
                  _Date := date_JJJJMMTT_2long(rSpaltenWert(1));
                  if DateOK(_Date) then
                    FieldByName('SPERRE_BIS').AsDateTime := long2datetime(_Date);
                end;
              51:
                begin

                  // vorberechnete Plausi
                  readMinMax(1, rSpaltenWert(1), rSpaltenWert(2), rSpaltenWert(3));
                  _Zaehlwerke := 1;

                  SpaltenWerte_Sekundaer := nil;
                  for k := succ(n) to pred(ImportFile.count) do
                  begin
                    if assigned(SpaltenWerte_Sekundaer) then
                      FreeAndNil(SpaltenWerte_Sekundaer);
                    SpaltenWerte_Sekundaer := Split(ImportFile[k], pQuellDelimiter, '"');

                    l := strtointdef(sSpaltenWert_Sekundaer(Zaehlwerk_FieldIndex), 0);
                    if (l > _Zaehlwerke) then
                    begin
                      readMinMax(l, sSpaltenWert_Sekundaer(VorberechnetePlausibilitaetVon_FieldIndex),
                        sSpaltenWert_Sekundaer(VorberechnetePlausibilitaetBis_FieldIndex),
                        sSpaltenWert_Sekundaer(LetzterAblesestand_FieldIndex));
                      _Zaehlwerke := l;
                    end
                    else
                      break;
                  end;
                  if assigned(SpaltenWerte_Sekundaer) then
                    FreeAndNil(SpaltenWerte_Sekundaer);

                end;
              52:
                begin
                  // 'Strassen_erst_ungerade',
                  // Unterdrückung ausschalten!
                  FieldByName('EVENODD').AsString := cC_False;
                end;
              53:
                begin
                  // 'Nummer_Auto',
                  // +Fixe Vorgabe der Reihenfolge
                  FieldByName('NUMMER').AsInteger := ABNummer;
                  FieldByName('PLANQUADRAT').AsString := inttostrN(ABNummer, 5);
                  inc(ABNummer);
                end;
              54:
                begin
                  // {54}'Termin'
                  if (ParameterItems[0] = 'now') then
                    FieldByName('AUSFUEHREN').AsDateTime := now
                  else
                    FieldByName('AUSFUEHREN').AsDateTime := long2datetime(date2long(rSpaltenWert(1)));
                  FieldByName('VORMITTAGS').AsString := cVormittagsChar;
                end;
              55:
                begin
                  // Zusatzarbeiten
                  SpaltenWerte_Sekundaer := nil;
                  for k := succ(n) to pred(ImportFile.count) do
                  begin

                    if assigned(SpaltenWerte_Sekundaer) then
                      FreeAndNil(SpaltenWerte_Sekundaer);
                    SpaltenWerte_Sekundaer := Split(ImportFile[k], pQuellDelimiter, '"');

                    if (artB <> '') then
                      break;

                    if (_MonteurMehrInfo.indexof(rSpaltenWert_Sekundaer(1)) = -1) then
                      _MonteurMehrInfo.add(rSpaltenWert_Sekundaer(1));

                  end;
                  if assigned(SpaltenWerte_Sekundaer) then
                    FreeAndNil(SpaltenWerte_Sekundaer);

                end;
              56: // C_SAP_INFO_#_#
                begin
                  // ''
                  _InternMehrInfo.add(cutblank(ParameterItems[0] + '=' + ParameterItems[1]));
                end;
              57: // Transaktion
                begin
                  // die Angegebene Transaktion ausführen
                  if (Transaktionen.indexof(ParameterItems[0]) = -1) then
                    Transaktionen.add(ParameterItems[0]);
                end;
              58:
                begin
                  // Material_Nummer
                  FieldByName('MATERIAL_NUMMER').AsString := rSpaltenWert(1);
                end;
              59:
                begin
                  // Protokoll_#
                  _ProtokollMehrInfo.add(rSpaltenWert(1));
                end;
              60:
                begin
                  // Protokoll_C_#
                  _ProtokollMehrInfo.add(ParameterItems[0] + '=' + rSpaltenWert(2));
                end;
              61:
                begin
                  // Protokoll_C_C
                  _ProtokollMehrInfo.add(ParameterItems[0] + '=' + ParameterItems[1]);
                end;
              62: // Zählwerk-Ausbau
                begin
                  FieldByName('ZAEHLWERKE_AUSBAU').AsString := HugeSingleLine(_ZaehlwerkeAusbau,', ');
                end;
              63: // Zählwerk-Einbau
                begin
                  FieldByName('ZAEHLWERKE_EINBAU').AsString := HugeSingleLine(_ZaehlwerkeEinbau,', ');
                end;
            else
              // Fehler!
            end;
          end; // for Import-Tags do
        except
          ParameterError := true;
          InfoFile.add('Exception');
        end;

        // die Texte
        FieldByName('ZAEHLER_INFO').assign(_ZaehlerMehrInfo);
        FieldByName('MONTEUR_INFO').assign(_MonteurMehrInfo);
        FieldByName('INTERN_INFO').assign(_InternMehrInfo);
        FieldByName('PROTOKOLL').assign(_ProtokollMehrInfo);

        //
        if (FieldByName('BRIEF_NAME1').AsString = '') and (FieldByName('BRIEF_NAME2').AsString = '') and
          (FieldByName('BRIEF_STRASSE').AsString = '') and (FieldByName('BRIEF_ORT').AsString = '') then
        begin
          FieldByName('BRIEF_NAME1').assign(FieldByName('KUNDE_NAME1'));
          FieldByName('BRIEF_NAME2').assign(FieldByName('KUNDE_NAME2'));
          FieldByName('BRIEF_STRASSE').assign(FieldByName('KUNDE_STRASSE'));
          FieldByName('BRIEF_ORT').assign(FieldByName('KUNDE_ORT'));
        end;

        repeat

          if pEindeutig then
          begin
            // Detectierung der Zählernummern
            _ZaehlerNummer := FieldByName('ZAEHLER_NUMMER').AsString;
            if pNummerConcatArt then
              _ZaehlerNummer := e_r_Sparte(FieldByName('ART').AsString) + '~' + _ZaehlerNummer;

            if (ZaehlerNummernImBestand.indexof(_ZaehlerNummer) <> -1) then
            begin
              Abgelehnte.add(ImportFile[n]);
              cancel;
              break;
            end;
            ZaehlerNummernImBestand.add(_ZaehlerNummer);
          end;

          Importierte.add(ImportFile[n]);

          // Save it!
          if not(pSimulieren) then // "simulation"
          begin
            AuftragBeforePost(qAUFTRAG);
            post;
          end
          else
          begin
            cancel;
          end;

        until true;

        if frequently(STime, 400) or (n = pred(ImportFile.count)) then
        begin
          _(cFeedBack_ProgressBar_position+1,IntTostr( n));
          _(cFeedBack_processmessages);
        end;

      end; // for all the import line

    qAUFTRAG.close;
    FreeAndNil(qAUFTRAG);

    if pDeleteMarked then
      _(cFeedBack_Function+1);
    if pMarkImported then
      if (Importierte.count - pQuellHeaderLines > 0) then
        _(cFeedBack_Function+2,IntToStr(RID_AT_IMPORT));

    // Post-Transaktionen durchführen
    if (Transaktionen.count > 0) then
      if (Importierte.count - pQuellHeaderLines > 0) then
      begin
        lImportierte := e_r_sqlm(
          { } 'select RID from AUFTRAG where' +
          { } ' (RID_AT_IMPORT=' + inttostr(RID_AT_IMPORT) + ') and' +
          { } ' (RID=MASTER_R)');
        for n := 0 to pred(Transaktionen.count) do
        begin
          InfoFile.add('Transaktion "' + Transaktionen[n] + '"');
          e_x_Transaktion(Transaktionen[n], lImportierte);
        end;
        lImportierte.free;
      end;

    if assigned(SpaltenWerte_Primaer) then
      FreeAndNil(SpaltenWerte_Primaer);
    MoreTextInfo.free;
    _ZaehlerMehrInfo.free;
    _MonteurMehrInfo.free;
    _InternMehrInfo.free;
    _ProtokollMehrInfo.free;
    _ZaehlwerkeEinbau.free;
    _ZaehlwerkeAusbau.free;

    InfoFile.add(cINFOText + 'Abgelehnte ' + inttostr(Abgelehnte.count - pQuellHeaderLines));
    InfoFile.add('Importierte ' + inttostr(Importierte.count - pQuellHeaderLines));
    InfoFile.add(cWARNINGText + 'Zählwerk_ist_"0" ' + inttostr(Anzahl_Zaehlwerk_0));
    InfoFile.add(cWARNINGText + 'Zählwerk_ist_nicht_"1" ' + inttostr(Anzahl_Zaehlwerk_nicht_1));

    InfoFile.SaveToFile(ImportePath + inttostr(RID_AT_IMPORT) + '\Info.txt');
    Abgelehnte.SaveToFile(ImportePath + inttostr(RID_AT_IMPORT) + '\Abgelehnte.csv');
    Importierte.SaveToFile(ImportePath + inttostr(RID_AT_IMPORT) + '\Importierte.csv');
    ZaehlerNummernImBestand.SaveToFile(ImportePath + inttostr(RID_AT_IMPORT) + '\ZaehlerNummern.txt');

    if (Abgelehnte.count > pQuellHeaderLines) then
      _(cFeedBack_ShowMessage,
       {} 'Es wurden ' + inttostr(Abgelehnte.count - pQuellHeaderLines) + ' von ' +
       {} inttostr(Importierte.count + Abgelehnte.count - pQuellHeaderLines - pQuellHeaderLines) +
       {} ' Zählernummern abgelehnt!');
    if (Anzahl_Zaehlwerk_0 > 0) then
      _(cFeedBack_ShowMessage,
       {} inttostr(Anzahl_Zaehlwerk_0) + ' Zeilen wurden überlesen ' + #13 +
       {} 'da die Spalte Zählwerk (angegeben im 2. Parameter der SAP_Art_#_#())' + #13 +
       {} 'leer ist, oder den Wert "0" hat.');

    if (Importierte.count - pQuellHeaderLines) = 0 then
      _(cFeedBack_openShell,ImportePath + inttostr(RID_AT_IMPORT) + '\Info.txt');

  end;
  for n := 0 to pred(SchemaRaw.count) do
    SchemaRaw.objects[n].free;
  FreeAndNil(SchemaRaw);
  FreeAndNil(InfoFile);
  FreeAndNil(Abgelehnte);
  FreeAndNil(Importierte);
  FreeAndNil(ZaehlerNummernImBestand);
  FreeAndNil(OrtsteileDerQuelle);
  FreeAndNil(StrassenListeMitPlanquadrat);
  FreeAndNil(Transaktionen);
  _(cFeedBack_ProgressBar_position+1);
  result := true;
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
    CacheBaustelleOrtsteile_BAUSTELLE_R := cRID_Unset;
  end;

  if assigned(cFeiertage) then
    freeandnil(cFeiertage);

  // cache dirty flags setzen
  CacheBaustelleMonteureLastRequestedRID := cRID_Unset;
  CacheBaustelleOrtsteile_BAUSTELLE_R := cRID_Unset;
  CacheBaustelleAufwand := cRID_Unset;
  CacheBaustelleArbeitsZeitV_RID := cRID_Unset;
  CacheBaustelleArbeitsZeitN_RID := cRID_Unset;
  _ObtainZeitFromRID_LastRID:= cRID_Unset;
  _ObtainKuerzelFromRID_LastRID := cRID_Unset;
  _ObtainKostenstelleFromRID_LastRID := cRID_Unset;
  _ObtainBundeslandFromRID_LastRID := cRID_Unset;
  _e_r_BaustelleEinstellungen_RID := cRID_unset;
end;

function e_r_AuftragNummer(BAUSTELLE_R: integer): integer;
begin
  result := e_r_sql(
   { } 'select max(NUMMER) from AUFTRAG where' +
   { } ' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') and' +
   { } ' (STATUS<>6)');
end;

function e_r_AuftragPlausi(AUFTRAG_R: integer): string;
var
  cAUFTRAG: TdboCursor;
  sProtokoll: TStringList;
  sZaehlerInfo: TStringList;
  sIntern: TStringList;
  sErgebnis: TStringList;
  sResult: string;

  procedure Log(s: string);
  begin
    if (sResult = cOLAPNull) then
      sResult := s
    else
      sResult := sResult + cOLAPcsvLineBreak + s;
  end;

  procedure CheckIt(V, b, a, ZWS: double; Prefix: string);

    function MoreInfo: string;
    begin
      result := ' (' + Prefix + ': ' + inttostr(round(a)) + ', ' + inttostr(round(V)) + ' - ' + inttostr(round(b)) +
        ': ' + inttostr(round(ZWS)) + ')';
    end;

  var
    BandErweiterung: double;

  begin
    repeat

      //
      if (V < 0) then
      begin
        Log('[Q16] keine "Untere Grenze" definiert' + MoreInfo);
      end;
      if (b < 0) then
      begin
        Log('[Q17] keine "Obere Grenze" definiert' + MoreInfo);
      end;
      if (a < 0) then
      begin
        Log('[Q18] kein "Letzter Stand" definiert' + MoreInfo);
      end;

      //
      if (ZWS < 0) then
      begin
        Log('[Q01] Ablesestand fehlt' + MoreInfo);
        break;
      end;
      if (a > 0) and (ZWS < a) then
      begin
        if (ZWS + 10 >= a) then
          Log('[Q13] Ablesestand unterschreitet leicht letzten Stand' + MoreInfo)
        else
          Log('[Q19] Ablesestand kleiner als letzter Stand' + MoreInfo);
        break;
      end;

      if (b - V < 0) then
      begin
        Log('[Q06] Zählwerk-Überlauf erwartet' + MoreInfo);
      end;

      BandErweiterung := max((b - V) * 3, 1000);

      if (ZWS < V) then
      begin
        if (ZWS < V - BandErweiterung) then
          Log('[Q07] Ablesestand unterschreitet massiv untere Grenze' + MoreInfo)
        else
          Log('[Q08] Ablesestand unterschreitet leicht untere Grenze' + MoreInfo);

        break;
      end;

      if (ZWS > b) then
      begin
        if (ZWS > b + BandErweiterung) then
          Log('[Q09] Ablesestand überschreitet massiv obere Grenze' + MoreInfo)
        else
          Log('[Q10] Ablesestand überschreitet leicht obere Grenze' + MoreInfo);
        break;
      end;

    until yet;
  end;

var
  v1, b1, v2, b2, ht, nt: double;
  a1, a2: double;
  ZAEHLER_WECHSEL: TAnfixDate;

begin
  try
    sResult := cOLAPNull;
    cAUFTRAG := nCursor;
    sProtokoll := TStringList.create;
    sZaehlerInfo := TStringList.create;
    sIntern := TStringList.create;
    sErgebnis := TStringList.create;
    with cAUFTRAG do
    begin
      // SQL
      sql.add('select');
      sql.add(' ART, STATUS, PROTOKOLL, INTERN_INFO, ZAEHLER_INFO, ZAEHLER_WECHSEL, ZAEHLER_STAND_ALT, ZAEHLER_STAND_NEU');
      sql.add('from');
      sql.add(' AUFTRAG');
      sql.add('where');
      sql.add(' (RID=' + inttostr(AUFTRAG_R) + ')');

      ApiFirst;
      if (FieldByName('STATUS').AsInteger = cs_Erfolg) then
      begin
        e_r_sqlt(FieldByName('PROTOKOLL'), sProtokoll);
        e_r_sqlt(FieldByName('ZAEHLER_INFO'), sZaehlerInfo);
        e_r_sqlt(FieldByName('INTERN_INFO'), sIntern);
        e_r_sqlt(FieldByName('ERGEBNIS_INFO'), sErgebnis);

        ZAEHLER_WECHSEL := DateTime2Long(FieldByName('ZAEHLER_WECHSEL').AsDateTime);
        if (ZAEHLER_WECHSEL > DateGet) then
          Log('[Q14] Ablesedatum liegt in der Zukunft');
        if (ZAEHLER_WECHSEL < 20080822) then
          Log('[Q15] Ablesedatum liegt vor Baustellenbeginn');

        if (sErgebnis.values['UNGEMELDET'] <> '') then
          Log('[Q11] Lief schon mal über die Schnittstelle');
        if (sErgebnis.values['QS_UMGANGEN'] <> '') then
          Log('[Q12] Qualitätssicherung übergangen');

        v1 := round(strtodoubledef(sZaehlerInfo.values['v1'], -1));
        b1 := round(strtodoubledef(sZaehlerInfo.values['b1'], -1));
        a1 := round(strtodoubledef(sZaehlerInfo.values['a1'], -1));
        ht := trunc(strtodoubledef(FieldByName('ZAEHLER_STAND_ALT').AsString, -1));

        if (pos('2', FieldByName('ART').AsString) > 0) then
        begin
          CheckIt(v1, b1, a1, ht, 'HT');
          // E2
          v2 := round(strtodoubledef(sZaehlerInfo.values['v2'], -1));
          b2 := round(strtodoubledef(sZaehlerInfo.values['b2'], -1));
          a2 := round(strtodoubledef(sZaehlerInfo.values['a2'], -1));
          nt := trunc(strtodoubledef(FieldByName('ZAEHLER_STAND_NEU').AsString, -1));
          CheckIt(v2, b2, a2, nt, 'NT');
        end
        else
        begin
          CheckIt(v1, b1, a1, ht, 'ET');
          // E

        end;

      end
      else
      begin
        sResult := '';
      end;

    end;
    if (sResult = cOLAPNull) then
      result := ''
    else
      result := sResult;
    cAUFTRAG.free;
    sProtokoll.free;
    sZaehlerInfo.free;
    sIntern.free;
    sErgebnis.Free;
  except
    on E: exception do
    begin
      result := E.Message;
    end;
  end;
end;

function e_r_Sparte(Art: string): string;
begin
  repeat

    if (pos('G', Art) = 1) then
    begin
      result := 'Gas';
      break;
    end;

    if (pos('WM', Art) = 1) then
    begin
      result := 'Wärme';
      break;
    end;

    if pos('W', Art) = 1 then
    begin
      result := 'Wasser';
      break;
    end;

    result := 'Strom';

  until yet;
end;

function e_r_Schritte(AUFTRAG_R: integer): TStringList;
var
  cSCHRITTE: TdboCursor;
  BELEG_R: integer;
  BAUSTELLE_R: integer;
begin
  result := TStringList.create;

  //
  BAUSTELLE_R := e_r_sql('select BAUSTELLE_R from AUFTRAG where RID=' + inttostr(AUFTRAG_R));
  BELEG_R := e_r_sql('select max(RID) from BELEG where BAUSTELLE_R=' + inttostr(BAUSTELLE_R));

  cSCHRITTE := nCursor;
  with cSCHRITTE do
  begin
    sql.add('select');
    sql.add(' SCHRITTE.MENGE_MONTAGE,POSTEN.ARTIKEL,SCHRITTE.RID,POSTEN.RID');
    sql.add('from POSTEN');
    sql.add('left join SCHRITTE on');
    sql.add(' (SCHRITTE.POSTEN_R=POSTEN.RID)');
    sql.add('where');
    sql.add(' (POSTEN.BELEG_R=' + inttostr(BELEG_R) + ')');
    sql.add('order by');
    sql.add(' POSTEN.POSNO,POSTEN.RID');
    ApiFirst;
    while not(eof) do
    begin
      result.add(
       {} FieldByName('MENGE_MONTAGE').AsString + ';' +
       {} FieldByName('ARTIKEL').AsString + ';' +
       {} FieldByName('SCHRITTE.RID').AsString + ';' +
       {} FieldByName('POSTEN.RID').AsString + ';' +
       {} inttostr(BELEG_R));
      ApiNext;
    end;
  end;
  cSCHRITTE.free;
end;

procedure e_w_Baustelle_add_SQL_Filter(Settings, sql : TStrings);
var
 SQL_Filter: String;
 n: Integer;
begin
  SQL_Filter := cutblank(Settings.values[cE_SQL_Filter]);
  if (SQL_Filter <> '') then
  begin
    n := RevPos('AND',UpperCase(SQL_Filter));
    if (n=length(SQL_Filter)-2) then
     SQL_Filter := cutblank(copy(SQL_Filter,1,pred(n)));
    if (pos('(',SQL_Filter)<>1) or (revpos(')',SQL_Filter)<>length(SQL_Filter)) then
     SQL_Filter := '(' + SQL_Filter + ')';
    sql.add(' ' + SQL_Filter + ' and');
  end;
end;

const
 _e_r_FotoRID_Cache: Integer = cRID_Unset;
 _e_r_FotoRID_Result: Integer = cRID_Unset;

function e_r_FotoRID(AUFTRAG_R: Integer): Integer;
begin
 if (AUFTRAG_R<>_e_r_FotoRID_Cache) then
 begin
   _e_r_FotoRID_Result := e_r_sql('select COALESCE(KOPIE_R,RID) from AUFTRAG where RID='+IntToStr(AUFTRAG_R));
   _e_r_FotoRID_Cache := AUFTRAG_R;
 end;
 result := _e_r_FotoRID_Result;
end;

procedure AuftragSuchindex(BAUSTELLE_R:Integer=cRID_null);
var
  cAUFTRAEGE: TdboCursor;
  lBAUSTELLE: TgpIntegerList;
  _hnr_part: string;

  function _str_part(s: string): string;
  var
    _FirstNummernPos: integer;
    n: integer;
  begin
    _FirstNummernPos := 0;
    for n := 1 to length(s) do
      if CharInSet(s[n], ['0' .. '9']) then
      begin
        _FirstNummernPos := n;
        break;
      end;

    if _FirstNummernPos > 0 then
    begin
      result := cutblank(copy(s, 1, pred(_FirstNummernPos)));
      _hnr_part := 'h' + noblank(copy(s, _FirstNummernPos, MaxInt));
    end
    else
    begin
      result := s;
      _hnr_part := '';
    end;

  end;

  procedure SaveAs(FName: string);
  var
    TheSearch: TWordIndex;
    AddStr: string;
    _monteur: string;
    ZaehlerNummerS: string;
    ReglerNummerS: string;
  begin
    TheSearch := TWordIndex.create(nil, 1);
    with cAUFTRAEGE do
    begin
      Open;
      //
      dbLog(sql);
      APIfirst;
      while not(eof) do
      begin
        // Monteur
        if not(FieldByName('MONTEUR1_R').IsNull) then
        begin
          _monteur := e_r_MonteurKuerzel
            (FieldByName('MONTEUR1_R').AsInteger);
          if not(FieldByName('MONTEUR2_R').IsNull) then
            _monteur := _monteur + ' ' + e_r_MonteurKuerzel
              (FieldByName('MONTEUR2_R').AsInteger);
        end
        else
        begin
          _monteur := '';
        end;

        // Zaehlernummer
        ZaehlerNummerS := noblank(FieldByName('ZAEHLER_NUMMER').AsString);
        while (pos('0', ZaehlerNummerS) = 1) do
          system.delete(ZaehlerNummerS, 1, 1);
        ersetze('-', '', ZaehlerNummerS);

        // Reglernummer
        ReglerNummerS := noblank(FieldByName('REGLER_NR').AsString);
        while (pos('0', ReglerNummerS) = 1) do
          system.delete(ReglerNummerS, 1, 1);
        ersetze('-', '', ReglerNummerS);

        // aufaddieren ...
        AddStr :=
          {} ZaehlerNummerS + ' ' +
          {} ReglerNummerS + ' ' +
          {} _monteur + ' ' +
          {} FieldByName('KUNDE_NUMMER').AsString + ' ' +
          {} FieldByName('BRIEF_NAME1').AsString + ' ' +
          {} FieldByName('BRIEF_NAME2').AsString + ' ' +
          {} FieldByName('BRIEF_STRASSE').AsString + ' ' +
          {} FieldByName('BRIEF_ORT').AsString + ' ' +
          {} FieldByName('KUNDE_NAME1').AsString + ' ' +
          {} FieldByName('KUNDE_NAME2').AsString + ' ' +
          {} _str_part(FieldByName('KUNDE_STRASSE').AsString) + ' ' +
          {} _hnr_part + ' ' +
          {} FieldByName('KUNDE_ORT').AsString + ' ' +
          {} e_r_BaustelleKuerzel(FieldByName('BAUSTELLE_R').AsInteger) +
          {} inttostrN(FieldByName('NUMMER').AsInteger, cAuftragsNummer_Length) + ' ' +
          {} inttostrN(FieldByName('NUMMER').AsInteger, cAuftragsNummer_Length);

        TheSearch.AddWords(AddStr, TObject(FieldByName('RID').AsInteger));

        APInext;
      end;
      close;
    end;
    //
    TheSearch.JoinDuplicates(false);
    TheSearch.SaveToFile(FName);
    TheSearch.free;
  end;

var
  n: integer;
begin
  try

    if (BAUSTELLE_R >= cRID_FirstValid) then
    begin
      lBAUSTELLE := TgpIntegerList.create;
      lBAUSTELLE.add(BAUSTELLE_R);
    end else
    begin
      lBAUSTELLE := e_r_sqlm(
        'select RID from BAUSTELLE where SUCHINDEX_AUS=''' + cC_True + '''');
    end;

    //
    cAUFTRAEGE := nCursor;
    with cAUFTRAEGE do
    begin
      sql.add('select');
      sql.add(' RID,');
      sql.add(' MONTEUR1_R,');
      sql.add(' MONTEUR2_R,');
      sql.add(' KUNDE_NUMMER,');
      sql.add(' ZAEHLER_NUMMER,');
      sql.add(' REGLER_NR,');
      sql.add(' BRIEF_NAME1,');
      sql.add(' BRIEF_NAME2,');
      sql.add(' BRIEF_STRASSE,');
      sql.add(' BRIEF_ORT,');
      sql.add(' KUNDE_NAME1,');
      sql.add(' KUNDE_NAME2,');
      sql.add(' KUNDE_STRASSE,');
      sql.add(' KUNDE_ORT,');
      sql.add(' BAUSTELLE_R,');
      sql.add(' NUMMER');
      sql.add('from');
      sql.add(' AUFTRAG');
      sql.add('where');
      sql.add(' (STATUS<>6)');

      if (BAUSTELLE_R < cRID_FirstValid) then
      begin
        if (lBAUSTELLE.count > 0) then
          sql.add(' and (BAUSTELLE_R not in ' + ListasSQL(lBAUSTELLE) + ')');
        SaveAs(SearchDir + cAuftragsIndexFName);
      end
      else
      begin
        sql.add(' and TRUE');
      end;

      for n := 0 to pred(lBAUSTELLE.count) do
      begin
        sql[pred(sql.count)] := ' and (BAUSTELLE_R=' + inttostr(lBAUSTELLE[n])
          + ')';
        SaveAs(SearchDir + format(cBaustelleIndexFName, [lBAUSTELLE[n]]));
      end;

    end;
    cAUFTRAEGE.free;
    lBAUSTELLE.free;

  except
    on E: Exception do
    begin
      AppendStringsToFile('c_w_AuftragSuchindex(' + inttostr
          (BAUSTELLE_R) + '): ' + E.Message,
          {} ErrorFName('SUCHINDEX'),
          {} Uhr8);
    end;
  end;

end;


end.
