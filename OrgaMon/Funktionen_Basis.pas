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
unit Funktionen_Basis;

{$ifdef fpc}
{$mode delphi}
{$endif}

interface

uses
  // System
  Classes,
{$ifndef fpc}
  // IB-Objects
  IB_Access,
  IB_Components,
  {$ifndef IBO_OLD}
  IB_ClientLib,
  {$endif}
 // XLS
  FlexCel.xlsAdapter,
{$endif}

  // Tools
  gplists, CareTakerClient, anfix,
  html,

  // OrgaMon
  globals;

{
  Basis: Grundlegende Funktionen des OrgaMon
}

{ System }
function e_r_BasePlug: TStringList;
function e_r_Bearbeiter: integer; // [TReference]
function e_r_LadeParameter: TStringList; { }

// besondere Aufgaben bei Programm-Updates
procedure MigrateFrom(BringTo: integer);

// Liefert das Kürzel des Bearbeiters.
function e_r_BearbeiterKuerzel(BEARBEITER_R: integer): string;

// Länder
function e_r_LandRID(ISO: string): integer;

// Erstellt und prüft ein Backup der aktuellen Datenbank
function SicherungDatenbank(BackupGID: integer): boolean;

// aus einem Memo-Feld einen Value lesen, der aber über
// mehrere Zeilen gehen kann.
function ReadLongStr(BlockName: string; ArtikelInfo: TStringList;
  delimiter: char = #13): string;

{ System Ereignisse }
procedure e_w_EreignisAbschluss(EREIGNIS_R: integer; INFO: string = '');

{ Person }
procedure e_w_PersonSetPassword(PERSON_R: integer);
procedure e_w_PersonEnsurePassword(PERSON_R: integer);
function e_r_Person_BLZ_Konto(BLZ, Konto: string): TgpIntegerList;

{ Verlag }
// RID eines Verlages bestimmen!
function e_r_VERLAG_R_fromVerlag(Verlag: string): integer; overload; { VERLAG_R }

function e_r_VERLAG_R_fromVerlag(PERSON_R : Integer): integer; overload; { VERLAG_R }

// Name eines Verlage bestimmen
function e_r_Verlag(PERSON_R: integer): string; { SUCHBEGRIFF }


{ Baustelle }
function e_r_ParameterFoto(settings: TStrings; p: string): string; { PARAMETER VALUE }

// Verzeichnis für die Ergebnismeldung
function e_r_BaustellenPfad(settings: TStrings): string; { PFAD }

// Verzeichnis für die Fotos in "Build" oder "Deliver"
function e_r_BaustellenPfadFoto(Phase: TeFotoPhase; settings: TStrings): string; { PFAD }

function e_w_Medium: string;
function e_x_ensureMedium(Name: string): TDOM_Reference;

procedure e_a_Infos(s: TStrings);
function cAusgabeArt_Aufnahme_MP3: TDOM_Reference;

{ Musiker }
function e_r_MusikerName(MUSIKER_R: integer): string;
function e_r_MusikerNachnameKommaVorname(MUSIKER_R: integer): string;
function e_r_MusikerNachname(MUSIKER_R: integer): string;
function e_r_MusikerUeber(MUSIKER_R: integer): string;
function e_r_MusikerCache: TStringList;
function e_r_MusikerNachnamenKommaVornamen: TStringList;
function e_r_MusikerGroup(MUSIKER_R: integer): TList;
function e_r_MusikerGroupRID(RID: integer): integer;
function e_r_MusikerWerke(MUSIKER_R: integer): TList;
procedure e_w_MusikerChangeRef(FROM_RID, TO_RID: string);
function e_w_MusikerCheckCreate(MusikerListe: string): integer;
procedure InvalidateCache_Musiker;

{ Länder }
procedure InvalidateCache_Laender;
function e_r_LaenderRIDfromALT(ALT: string): integer;
function e_r_LaenderRIDfromISO(ISO: string): integer;
function e_r_LaenderISO(RID: integer): string;
function e_r_LaenderPost(RID: integer): string;
function e_r_LaenderInternational(RID: integer): string;
function e_r_LaenderOrtFormat(RID: integer): string;
function e_r_LaenderCache: TStringList;
// liefert das ISO Landeskennzeichen
function e_r_ObtainISOfromRID(LAND_R: integer): string;

// Landesspezifiesche Strings

function e_r_Localize(RID, LAND_R: integer): string;
function e_r_Localize2(RID, LANGUAGE: integer): string;

// System Texte
function e_r_text(RID: integer; LAND_R: integer = 0): TStringList;

{ Artikel }
function e_r_ArtikelPDF(ARTIKEL_R: integer): TStringList;

// Abgeschrieben
// --------------------------------------------------------------------------

// Eine Abschreibe-Menge wird an einem Volumen abgeschrieben. Es wird
// im Prinzip gerechnet:

// dec(GesamtVolumen,AbschreibeMenge);

// Folgende Besonderheiten
// Es kann nicht über das Gesamtvolumen hinaus abgeschrieben werden
// Es wird zurückgeliefert, was wirklich abgeschrieben werden konnte
// --------------------------------------------------------------------------
function MengeAbschreiben(var GesamtVolumen, AbschreibeMenge: integer): integer;

// Barcode Prüfziffer Berechnung "Modulo 10"
function PruefZiffer(n : int64):byte;
function PruefZifferOK(zahl: Int64): Boolean;

procedure EnsureCache_Musiker;
procedure EnsureCache_Laender;

implementation

uses
  Types, Math, SysUtils,

  // wegen der Versionsnummern
{$IFDEF fpc}
  ZClasses,
  ZConnection,
  ZDatasetUtils,
  ZCompatibility,
  ZDbcIntfs,
  ZSequence,
  graphics,
  // fbintf
  IB,
  // IBX4Lazarus
  IBVersion, IBXServices,
  fpchelper,
{$ELSE}
  FlexCel.Core,
  CCR.Exif.Consts,
  JclBase,
  IBOServices,
  IB_Session,
  graphics,
  System.UITypes,
{$ENDIF}
{$IFNDEF CONSOLE}
  Datenbank,
{$ifndef FPC}
  JvclVer,
{$endif}
{$ENDIF}
  idglobal, SolidFTP,

  c7zip, WordIndex, ExcelHelper,
  dbOrgaMon, SimplePassword, DTA, OpenStreetMap,
  OpenOfficePDF, srvXMLRPC, memcache,
  tgputtysftp;

const
  CacheMusikerLiveTime = 2 * 60 * 60 * 1000; // 2 Stunden
  { Private-Deklarationen }
  { Cache Musiker }
  CacheMusikerBirth: dword = 0;
  CacheMusikerName: TStringList = nil;
  CacheMusikerNachnameKommaVorname: TStringList = nil;
  CacheMusikerNachname: TStringList = nil;

  { Cache Laender }
  CacheLaender: TStringList = nil;
  CacheLaenderFull: TStringList = nil;


function e_r_MusikerName(MUSIKER_R: integer): string;
var
  k: integer;
begin
  if (MUSIKER_R > 0) then
  begin
    EnsureCache_Musiker;
    k := CacheMusikerName.indexofobject(TObject(MUSIKER_R));
    if (k <> -1) then
      Result := CacheMusikerName[k]
    else
      Result := '?';
  end
  else
  begin
    Result := '';
  end;
end;

function e_r_MusikerNachnameKommaVorname(MUSIKER_R: integer): string;
var
  k: integer;
begin
  if (MUSIKER_R > 0) then
  begin
    EnsureCache_Musiker;
    k := CacheMusikerNachnameKommaVorname.indexofobject(TObject(MUSIKER_R));
    if (k <> -1) then
      Result := CacheMusikerNachnameKommaVorname[k]
    else
      Result := '?';
  end
  else
  begin
    Result := '';
  end;
end;

function e_r_MusikerNachName(MUSIKER_R: integer): string;
var
  k: integer;
begin
  if (MUSIKER_R > 0) then
  begin
    EnsureCache_Musiker;
    k := CacheMusikerNachname.indexofobject(TObject(MUSIKER_R));
    if (k <> -1) then
      Result := CacheMusikerNachname[k]
    else
      Result := '?';
  end
  else
  begin
    Result := '';
  end;
end;

procedure InvalidateCache_Musiker;
begin
  if assigned(CacheMusikerName) then
  begin
    FreeAndNil(CacheMusikerName);
    FreeAndNil(CacheMusikerNachnameKommaVorname);
    FreeAndNil(CacheMusikerNachname);
  end;
end;

procedure EnsureCache_Musiker;
var
  cMUSIKER: TdboCursor;
  RID: integer;
  Kette: string;
  KetteNachname: string;
  KetteNurNachname: string;
  KettenStartL: TgpIntegerList;
  n: integer;

  function strValidate(s: string): string;
  begin
    Result := StrFilter(cutblank(s), #13#10#9, True);
  end;

begin
  if frequently(CacheMusikerBirth, CacheMusikerLiveTime) or (CacheMusikerName=nil) then
  begin
    InvalidateCache_Musiker;
    CacheMusikerName := TStringList.Create;
    CacheMusikerNachnameKommaVorname := TStringList.Create;
    CacheMusikerNachname := TStringList.Create;

    // Vorlauf
      // das sind die Anfangs-Punkte der Musiker-Verkettungen
      // Bedingungen: MUSIKER_R hat einen Inhalt
      // auf diesen RID zeigt kein anderer!
    KettenStartL := e_r_sqlm(
     {} 'select RID from MUSIKER where'+
     {} ' MUSIKER_R IS NOT NULL and'+
     {} ' RID NOT IN (select EVL_R from MUSIKER where EVL_R is not null) order by'+
     {} ' RID');

    cMUSIKER := nCursor;
    with cMUSIKER do
    begin
      // erster Druchlauf "Einzelmusiker"
      sql.add('select RID,VORNAME,NACHNAME,EVL_TRENNER');
      sql.add('from MUSIKER');
      sql.add('where MUSIKER_R is null');
      sql.add('order by NACHNAME');
      ApiFirst;
      while not (EOF) do
      begin
        CacheMusikerName.AddObject(
         {} strValidate(
         {}  FieldByName('VORNAME').AsString + ' ' +
         {}  FieldByName('NACHNAME').AsString),
         {} TObject(FieldByName('RID').AsInteger));

        CacheMusikerNachnameKommaVorname.AddObject(
         {} strValidate(
         {}  FieldByName('NACHNAME').AsString + ', ' +
         {}  FieldByName('VORNAME').AsString),
         {} TObject(FieldByName('RID').AsInteger));

        CacheMusikerNachname.AddObject(
         {} strValidate(FieldByName('NACHNAME').AsString),
         {} TObject(FieldByName('RID').AsInteger));

        ApiNext;
      end;

      if DebugMode then
      begin
        CacheMusikerName.Add('--Ketten--;--Ketten--');
        CacheMusikerNachnameKommaVorname.Add('--Ketten--;--Ketten--');
        CacheMusikerNachname.Add('--Ketten--;--Ketten--');
      end;

      for n := 0 to pred(KettenStartL.Count) do
      begin
        Kette := '';
        KetteNachname := '';
        KetteNurNachname := '';
        RID := KettenStartL[n];
        repeat
          Close;
          sql.Clear;
          sql.add('select MUSIKER_R,EVL_R,EVL_TRENNER from MUSIKER where RID=' +
            IntToStr(RID));
          ApiFirst;
          Kette :=
            {} cutblank(Kette + ' ' +
            {} e_r_MusikerName(FieldByName('MUSIKER_R').AsInteger) + ' ' +
            {} FieldByName('EVL_TRENNER').AsString);
          KetteNachname :=
            {} cutblank(KetteNachname + ' ' +
            {} e_r_MusikerNachnameKommaVorname(FieldByName('MUSIKER_R').AsInteger) + ' ' +
            {} FieldByName('EVL_TRENNER').AsString);
          KetteNurNachname :=
            {} cutblank(KetteNurNachname + ' ' +
            {} e_r_MusikerNachName(FieldByName('MUSIKER_R').AsInteger) + ' ' +
            {} FieldByName('EVL_TRENNER').AsString);
          if FieldByName('EVL_R').IsNull then
            break
          else
            RID := FieldByName('EVL_R').AsInteger;
        until eternity;
        CacheMusikerName.AddObject(Kette, pointer(KettenStartL[n]));
        CacheMusikerNachnameKommaVorname.AddObject(KetteNachname, pointer(KettenStartL[n]));
        CacheMusikerNachname.AddObject(KetteNurNachname, pointer(KettenStartL[n]));
      end;
    end;

    cMUSIKER.Free;
    KettenStartL.Free;

    if DebugMode then
    begin
      SaveToFileCSV(CacheMusikerName,DiagnosePath+'Musiker.Cache.csv','RID;NAME');
      SaveToFileCSV(CacheMusikerNachnameKommaVorname,DiagnosePath+'Musiker-Nachname.Cache.csv','RID;NACHNAME');
      SaveToFileCSV(CacheMusikerNachname,DiagnosePath+'Musiker-Nur-Nachname.Cache.csv','RID;NURNACHNAME');
    end;
  end;
end;

function e_w_Medium: string;
begin
  Result := inttostrN(e_w_GEN('GEN_MEDIUM'), 8);
end;

const
  _e_x_ensureMedium_Cache_R: TDOM_Reference = cRID_Null;
  _e_x_ensureMedium_Cache_S: string = '';

function e_x_ensureMedium(Name: string): TDOM_Reference;
begin
  if (Name = _e_x_ensureMedium_Cache_S) then
  begin
    Result := _e_x_ensureMedium_Cache_R;
    exit;
  end;

  Result := e_r_sql('select RID from MEDIUM where DATEI_ERWEITERUNG=' +
    SQLstring(Name));

  if (Result < cRID_FirstValid) then
  begin
    e_x_sql(
      'insert into MEDIUM (RID,DATEI_ERWEITERUNG) values (0,' + SQLstring(Name) + ')');
    Result := e_x_ensureMedium(Name);
  end;

  _e_x_ensureMedium_Cache_R := Result;
  _e_x_ensureMedium_Cache_S := Name;

end;

procedure e_w_MusikerChangeRef(FROM_RID, TO_RID: string);
begin
  e_x_sql('update MUSIKER set EVL_R=NULL where EVL_R=' + FROM_RID);
  e_x_sql('update MUSIKER set MUSIKER_R=' + TO_RID + ' where (MUSIKER_R=' +
    FROM_RID + ') AND (RID<>' + TO_RID + ')');
  e_x_sql('update ARTIKEL set KOMPONIST_R=' + TO_RID + ' where KOMPONIST_R=' + FROM_RID);
  e_x_sql('update ARTIKEL set ARRANGEUR_R=' + TO_RID + ' where ARRANGEUR_R=' + FROM_RID);
end;

function e_r_MusikerUeber(MUSIKER_R: integer): string;
var
  txt: TStringList;

  procedure AddOne(RID: integer);
  var
    cMUSIKER: TdboCursor;
    OneTxt: TStringList;
  begin
    if (txt.Count > 0) then
      if (txt[pred(txt.Count)] <> '') then
        txt.add('');
    txt.add(e_r_MusikerName(RID));
    OneTxt := TStringList.Create;
    cMUSIKER := nCursor;
    with cMUSIKER do
    begin
      sql.add('select UEBER_INFO from MUSIKER where RID=' + IntToStr(RID));
      ApiFirst;
      e_r_sqlt(FieldByName('UEBER_INFO'), OneTxt);
    end;
    cMUSIKER.Free;
    txt.addstrings(OneTxt);
    OneTxt.Free;
  end;

var
  cREF: TdboCursor;
begin
  txt := TStringList.Create;
  cREF := nCursor;
  with cREF do
  begin
    repeat
      sql.Clear;
      sql.add('select MUSIKER_R,EVL_R from MUSIKER where RID=' + IntToStr(MUSIKER_R));
      ApiFirst;
      if FieldByName('MUSIKER_R').IsNull then
        AddOne(MUSIKER_R)
      else
        AddOne(FieldByName('MUSIKER_R').AsInteger);
      MUSIKER_R := FieldByName('EVL_R').AsInteger;
      if (MUSIKER_R < 1) then
        break;
      Close;
    until eternity;
  end;
  cREF.Free;
  Result := HugeSingleLine(txt);
  txt.Free;
end;

function e_r_MusikerCache: TStringList;
begin
  EnsureCache_Musiker;
  Result := CacheMusikerName;
end;

function e_r_MusikerGroup(MUSIKER_R: integer): TList;
var
  cREF: TdboCursor;
begin
  Result := TList.Create;
  cREF := nCursor;
  with cREF do
  begin
    repeat
      sql.Clear;
      sql.add('select MUSIKER_R,EVL_R from MUSIKER where RID=' + IntToStr(MUSIKER_R));
      ApiFirst;
      if FieldByName('MUSIKER_R').IsNull then
        Result.add(TObject(MUSIKER_R))
      else
        Result.add(TObject(FieldByName('MUSIKER_R').AsInteger));
      MUSIKER_R := FieldByName('EVL_R').AsInteger;
      if (MUSIKER_R < 1) then
        break;
      Close;
    until eternity;
  end;
  cREF.Free;
end;

function e_r_MusikerWerke(MUSIKER_R: integer): TList;
var
  cARTIKEL: TdboCursor;
  cREF: TdboCursor;
  lRID: string;
begin
  Result := TList.Create;

  // Alle RIDs dieses MUSIKERs sammeln
  lRID := IntToStr(MUSIKER_R);

  cREF := nCursor;
  with cREF do
  begin
    sql.add('select RID from MUSIKER where MUSIKER_R=' + lRID);
    ApiFirst;
    while not (EOF) do
    begin
      lRID := lRID + ',' + IntToStr(e_r_MusikerGroupRID(FieldByName('RID').AsInteger));
      ApiNext;
    end;
  end;
  cREF.Free;


  cARTIKEL := nCursor;
  with cARTIKEL do
  begin
    sql.add('select distinct RID from ARTIKEL where');
    sql.add(' KOMPONIST_R in (' + lRID + ') or');
    sql.add(' ARRANGEUR_R in (' + lRID + ')');
    ApiFirst;
    while not (EOF) do
    begin
      Result.add(TObject(FieldByName('RID').AsInteger));
      ApiNext;
    end;
  end;
  cARTIKEL.Free;

end;

function e_r_MusikerGroupRID(RID: integer): integer;
var
  cREF: TdboCursor;
begin
  // der ersten Datensatz einer Liste ermitteln (sich zurückarteien)
  cREF := nCursor;
  with cREF do
  begin
    repeat
      sql.Clear;
      sql.add('select RID from MUSIKER where EVL_R=' + IntToStr(RID));
      ApiFirst;
      if EOF then
        break
      else
        RID := FieldByName('RID').AsInteger;
      Close;
    until eternity;
  end;
  cREF.Free;
  Result := RID;
end;

function e_r_MusikerNachnamenKommaVornamen: TStringList;
begin
  EnsureCache_Musiker;
  Result := CacheMusikerNachnameKommaVorname;
end;

function e_w_MusikerCheckCreate(MusikerListe: string): integer;
var
  k: integer;
begin
  EnsureCache_Musiker;
  repeat

   // Rang 1: "Otto M. Schwarz"
   k := CacheMusikerName.indexof(MusikerListe);
   if (k<>-1) then
   begin
    Result := integer(CacheMusikerName.objects[k]);
    break;
   end;

   // Rang 2: "Schwarz, Otto M."
   k := CacheMusikerNachnameKommaVorname.indexof(MusikerListe);
   if (k<>-1) then
   begin
    Result := integer(CacheMusikerNachnameKommaVorname.objects[k]);
    break;
   end;

   Result := succ(e_r_GEN('GEN_MUSIKER'));
   if (pos(', ',MusikerListe)=0) then
   begin
    e_x_sql('insert into MUSIKER (RID,NACHNAME) values (0,' +
     {} '''' + MusikerListe + ''')');
   end else
   begin
    e_x_sql('insert into MUSIKER (RID,NACHNAME,VORNAME) values (0,' +
    {} '''' + nextp(MusikerListe,', ',0) + ''','+
    {} '''' + nextp(MusikerListe,', ',1) + ''')');
   end;
   InvalidateCache_Musiker;


  until yet;

end;

procedure InvalidateCache_Laender;
var
  n: integer;
begin
  if assigned(CacheLaender) then
  begin
    for n := 0 to pred(CacheLaender.Count) do
      TStringList(CacheLaender.objects[n]).Free;
    FreeAndNil(CacheLaender);

    for n := 0 to pred(CacheLaenderFull.Count) do
      TStringList(CacheLaenderFull.objects[n]).Free;
    FreeAndNil(CacheLaenderFull);
  end;
end;

var
  _AusgabeArt_Aufnahme_MP3: TDOM_Reference = cRID_Unset;

function cAusgabeArt_Aufnahme_MP3: TDOM_Reference;
begin
  if (_AusgabeArt_Aufnahme_MP3 = cRID_Unset) then
  begin
    _AusgabeArt_Aufnahme_MP3 :=
      e_r_sql('select RID from AUSGABEART where KUERZEL=''MP3''');
    if (_AusgabeArt_Aufnahme_MP3 < cRID_FirstValid) then
      _AusgabeArt_Aufnahme_MP3 := cRID_Impossible;
  end;
  Result := _AusgabeArt_Aufnahme_MP3;
end;

procedure EnsureCache_Laender;
var
  cLAND: TdboCursor;

  function AddOne: TStringList;
  begin
    Result := TStringList.Create;
    with cLAND do
    begin
      { [0] }
      Result.add(FieldByName('ISO_KURZZEICHEN').AsString);
      { [1] }
      Result.add(FieldByName('KURZ_ALT').AsString);
      { [2] }
      Result.add(FieldByName('ORT_FORMAT').AsString);
      if (Result[2] = '') then
        Result[2] := iOrtFormat;
      { [3] }
      Result.add(nextp(FieldByName('INT_TEXT').AsString,#13#10,0));
    end;
  end;

begin
  if not (assigned(CacheLaender)) then
  begin
    CacheLaender := TStringList.Create;
    CacheLaenderFull := TStringList.Create;

    cLAND := nCursor;
    with cLAND do
    begin
      sql.add('select');
      sql.add(' LAND.RID,');
      sql.add(' LAND.ARTIKEL_RELEVANT,');
      sql.add(' LAND.ISO_KURZZEICHEN,');
      sql.add(' LAND.KURZ_ALT,');
      sql.add(' LAND.ORT_FORMAT,');
      sql.add(' INTERNATIONALTEXT.INT_TEXT');
      sql.add('from');
      sql.add(' LAND');
      sql.add('left join');
      sql.add(' INTERNATIONALTEXT');
      sql.add('on');
      sql.add(' (INTERNATIONALTEXT.RID=LAND.INT_NAME_R) and');
      sql.add(' (INTERNATIONALTEXT.LAND_R=' + IntToStr(iHeimatLand) + ')');
      ApiFirst;
      while not (EOF) do
      begin
        if (FieldByName('ARTIKEL_RELEVANT').AsString = 'Y') then
          CacheLaender.AddObject(IntToStr(FieldByName('RID').AsInteger), AddOne);
        CacheLaenderFull.AddObject(IntToStr(FieldByName('RID').AsInteger), AddOne);
        ApiNext;
      end;
    end;
    cLAND.Free;
    CacheLaender.sort;
    CacheLaender.sorted := True;

    CacheLaenderFull.sort;
    CacheLaenderFull.sorted := True;
  end;
end;

function e_r_LaenderRIDfromALT(ALT: string): integer;
var
  n: integer;
begin
  Result := cRID_Null;
  EnsureCache_Laender;
  ALT := nextp(ALT, '-');
  for n := 0 to pred(CacheLaender.Count) do
    if (TStringList(CacheLaender.objects[n])[1] = ALT) then
    begin
      Result := StrToInt(CacheLaender[n]);
      break;
    end;
end;

function e_r_LaenderRIDfromISO(ISO: string): integer;
var
  n: integer;
begin
  EnsureCache_Laender;
  for n := 0 to pred(CacheLaender.Count) do
    if TStringList(CacheLaender.objects[n])[0] = ISO then
    begin
      Result := StrToInt(CacheLaender[n]);
      exit;
    end;
  Result := -1;
end;

function e_r_LaenderInternational(RID: integer): string;
var
  k: integer;
begin
  EnsureCache_Laender;
  k := CacheLaenderFull.indexof(IntToStr(RID));
  if (k <> -1) then
    Result := TStringList(CacheLaenderFull.objects[k])[3]
  else
    Result := IntToStr(RID) + '?';
end;

function e_r_LaenderISO(RID: integer): string;
var
  k: integer;
begin
  EnsureCache_Laender;
  k := CacheLaenderFull.indexof(IntToStr(RID));
  if (k <> -1) then
    Result := TStringList(CacheLaenderFull.objects[k])[0]
  else
    Result := IntToStr(RID) + '?';
end;

function e_r_LaenderCache: TStringList;
var
  n: integer;
begin
  EnsureCache_Laender;
  Result := TStringList.Create;
  for n := 0 to pred(CacheLaender.Count) do
    Result.add(TStringList(CacheLaender.objects[n])[0]);
  Result.sort;
end;

function e_r_LaenderPost(RID: integer): string;
var
  k: integer;
begin
  EnsureCache_Laender;
  k := CacheLaenderFull.indexof(IntToStr(RID));
  if (k <> -1) then
    Result := TStringList(CacheLaenderFull.objects[k])[1]
  else
    Result := IntToStr(RID) + '?';
end;

function e_r_LaenderOrtFormat(RID: integer): string;
var
  k: integer;
begin
  EnsureCache_Laender;
  k := CacheLaenderFull.indexof(IntToStr(RID));
  if (k <> -1) then
    Result := TStringList(CacheLaenderFull.objects[k])[2]
  else
    Result := IntToStr(RID) + '?';
end;

const
  CacheBasePlug: TStringList = nil;

procedure e_a_Infos(s: TStrings);
begin
  with s do
  begin
    add('Copyright=' + cOrgaMonCopyright);
    add('Datum=' + long2dateLocalized(DateGet));
    add('AktuellesDatum=' + DatumLocalized);
    add('AktuelleUhrzeit=' + Uhr);
    add('DatumLog=' + DatumLog);
    add('ZeitLog=' + Uhr8);
  end;
end;

function e_r_ParameterFoto(settings: TStrings; p: string): string;
begin
  Result := settings.Values[p + cE_Postfix_Foto];
  if (Result = '') then
    Result := settings.Values[p];
  if (Result = cExplizitEmpty) then
    Result := '';
end;

function e_r_BaustellenPfad(settings: TStrings): string;
begin
  Result := settings.Values[cE_VERZEICHNIS];
  if (Result = '') then
    Result := settings.Values[cE_FTPUSER];
  if (Result = cExplizitEmpty) then
    Result := '';
end;

function e_r_BaustellenPfadFoto(Phase: TeFotoPhase; settings: TStrings): string;
begin
  repeat
    if (Phase=fp_Deliver) then
    begin
      Result := settings.Values[cE_FotoZiel];
      if (Result <> '') then
        break;
    end;

    Result := settings.Values[cE_VERZEICHNIS + cE_Postfix_Foto];
    if (Result <> '') then
      break;

    Result := settings.Values[cE_FTPUSER + cE_Postfix_Foto];
    if (Result <> '') then
      break;

    Result := e_r_BaustellenPfad(settings);

  until yet;
  if (Result = cExplizitEmpty) then
    Result := '';
end;

function e_r_BasePlug: TStringList;
begin
  Result := TStringList.Create;
  if not (assigned(CacheBasePlug)) then
  begin
    CacheBasePlug := TStringList.Create;
    with CacheBasePlug do
    begin
      // ==========================================================
      // ACHTUNG: geht auch über XML-RPC "BasePlug" raus!
      // ACHTUNG: Reihenfolge nicht verändern, nur erweitern!
      // ==========================================================
      { 01 } add(cAppName);
{$IFDEF fpc}
      { 02 } add('Zeos Rev. ' + ZEOS_VERSION);
{$ELSE}
{$IFDEF CONSOLE}
      { 02 } add('IBO Rev. ' + fbConnection.Version);
{$ELSE}
      { 02 } add('IBO Rev. ' + Datamoduledatenbank.IB_connection1.Version);
{$ENDIF}
{$ENDIF}
      { 03 } add(gsIdProductName + ' Rev. ' + gsIdVersion); // Indy
      { 04 } add(iPDFPathPublicShop);
      { 05 } add(iMusicPathShop);
      { 06 } add(iHTMLPath);
      { 07 } add(iBildURL);
{$IFDEF CONSOLE}
      { 08 } AddObject(
        cServerFunctions_Meta_CallCount,
        TXMLRPC_Server.oMetaString);
{$ELSE}
      { 08 } add('N/A');
{$ENDIF}
{$IFDEF fpc}
      { 09 } add('fpspreadsheet Rev. ' + 'N/A');
{$ELSE}
      { 09 } add('TMS FlexCel Rev. ' + FlexCelVersion);
{$ENDIF}
{$IFDEF fpc}
      { 10 } add('IBX Rev. ' + IBX_VERSION);
{$ELSE}
      { 10 } add('jcl Rev. ' + IntToStr(JclVersionMajor) + '.' +
        IntToStr(JclVersionMinor));
{$ENDIF}
{$ifdef FPC}
      { 11 } add('fpc Rev. //imp pend');
{$else}
{$IFDEF CONSOLE}
      { 11 } add('jvcl Rev. N/A');
{$ELSE}
      { 11 } add('jvcl Rev. ' + JVCL_VERSIONSTRING);
{$ENDIF}
{$endif}
      { 12 } add(iShopArtikelBilderURL);
      { 13 } add('7zip Rev. ' +  c7zip.Version);
      { 14 } add(tgputtysftp_Version);
      { 15 } add(
        e_r_Kontext + '@' + ComputerName + ':' + iXMLRPCPort);
      { 16 } add(
        'memcache Rev. ' + RevToStr(memcache.Version) + '@' +
        imemcachedHost);
      { 17 } add(iDataBaseUser);
      { 18 } add(iDataBasePassword);
      { 19 } add(iDataBasePassword);
      { 20 } add(e_r_fbClientVersion);
      { 21 } add('Portable Network Graphics Delphi ' + 'N/A');
      { 22 } add(i_c_DataBaseHost);
      { 23 } add(i_c_DataBaseFName);
{$IFDEF CONSOLE}
      { 24 } AddObject(
        cServerFunctions_Meta_UpTime,
        TXMLRPC_Server.oMetaString);
{$ELSE}
      { 24 } add('N/A');
{$ENDIF}
{$IFDEF fpc}
      { 25 } add('exiftool Rev. ' + 'N/A');
{$ELSE}
      { 25 } add('CCR.Exif Rev. ' + CCR.Exif.Consts.CCRExifVersion);
{$ENDIF}
      { 26 } add(e_r_Kontext);
      { 27 } add(Betriebssystem);
    end;
  end;
  Result.Assign(CacheBasePlug);
end;

function e_r_Bearbeiter: integer;
begin
  Result := e_r_sql('select RID from BEARBEITER where UPPER(USERNAME)=''' +
    AnsiUpperCase(UserName) + '''');
end;

function e_r_BearbeiterKuerzel(BEARBEITER_R: integer): string;
begin
  Result := e_r_sqls('select KUERZEL from BEARBEITER where RID=' +
    IntToStr(BEARBEITER_R));
end;

procedure MigrateFrom(BringTo: integer);
begin
  case BringTo of
    2000:
    begin
      // ShowMessage('Willkommen in der Rev. 2.000');
    end;
    7129:
      FileMove(MyProgramPath + 'favorites.xml', iOlapPath + cAuftragLupeFavoritenFName);
    7681:
      if not (iOLAPpublic) then
      begin
        CheckCreateDir(iOlapPath);
        FileMove(MyApplicationPath + 'OLAP\*', iOlapPath);
      end;
  end;
end;

function ReadLongStr(BlockName: string; ArtikelInfo: TStringList;
  delimiter: char = #13): string;
var
  MachineState: byte;
  n, k: integer;
begin
  Result := '';
  MachineState := 0;
  for n := 0 to pred(ArtikelInfo.Count) do
  begin
    case MachineState of
      0:
      begin
        k := pos(BlockName + '=', ArtikelInfo[n]);
        if (k = 1) then
        begin
          Result := copy(ArtikelInfo[n], length(BlockName) + 2, MaxInt);
          MachineState := 1;
        end;
      end;
      1:
      begin
        k := pos('=', ArtikelInfo[n]);
        if (k = 0) or (k > 11) then
          Result := Result + delimiter + ArtikelInfo[n]
        else
          exit;
      end;
    end;
  end;
end;

function MengeAbschreiben(var GesamtVolumen, AbschreibeMenge: integer): integer;
  // Abgeschrieben
var
  Verminderung: integer;
begin
  Verminderung := min(GesamtVolumen, AbschreibeMenge);
  Dec(GesamtVolumen, Verminderung);
  Dec(AbschreibeMenge, Verminderung);
  Result := Verminderung;
end;

procedure e_w_PersonSetPassword(PERSON_R: integer);
begin
  e_x_sql('update PERSON set' + ' USER_PWD=''' + FindANewPassword +
    ''',' + ' USER_SALT=''' + FindANewPassword + '''' + ' where RID=' +
    IntToStr(PERSON_R));
end;

procedure e_w_PersonEnsurePassword(PERSON_R: integer);
var
  pwd, salt: string;
begin

  // Salt sicherstellen
  salt := e_r_sqls('select USER_SALT from PERSON where RID=' + IntToStr(PERSON_R));
  if (salt = '') then
    e_x_sql('update PERSON set USER_SALT=''' + FindANewPassword +
      ''' where RID=' + IntToStr(PERSON_R));

  // Passwort sicherstellen
  pwd := e_r_sqls('select USER_PWD from PERSON where RID=' + IntToStr(PERSON_R));
  if (pwd = '') then
    e_w_PersonSetPassword(PERSON_R);

end;

const
  e_r_ArtikelPDF_Cache: TStringList = nil;

function e_r_ArtikelPDF(ARTIKEL_R: integer): TStringList;
var
  Numero: string;

  procedure AddPath(Path: string);
  var
    sDir: TStringList;
    n: integer;
  begin
    if (Path <> '') then
      if (Path <> MyProgramPath) then
      begin
        sDir := TStringList.Create;
        dir(Path + Numero + '*' + cPDFExtension, sDir, False);
        if (sDir.Count = 0) then
        begin

          // 2. Option, Numero ist Bestandteil des Dateinamens <Numero> { "_" <Numero> } ".pdf"
          if not (assigned(e_r_ArtikelPDF_Cache)) then
          begin
            e_r_ArtikelPDF_Cache := TStringList.Create;
            dir(Path + '*' + cPDFExtension, e_r_ArtikelPDF_Cache, False);
          end;
          for n := 0 to pred(e_r_ArtikelPDF_Cache.Count) do
          begin
            if pos('_' + Numero + '_', e_r_ArtikelPDF_Cache[n]) > 0 then
            begin
              sDir.add(Path + e_r_ArtikelPDF_Cache[n]);
              continue;
            end;
            if pos('_' + Numero + '.', e_r_ArtikelPDF_Cache[n]) > 0 then
            begin
              sDir.add(Path + e_r_ArtikelPDF_Cache[n]);
              continue;
            end;
          end;

        end
        else
        begin
          for n := 0 to pred(sDir.Count) do
            sDir[n] := Path + sDir[n];
        end;
        Result.addstrings(sDir);
        sDir.Free;
      end;
  end;

begin
  Result := TStringList.Create;
  Numero := e_r_sqls('select NUMERO from ARTIKEL where RID=' + IntToStr(ARTIKEL_R));
  AddPath(iPDFPathApp);
  AddPath(iPDFPathPublicApp);
end;

procedure e_w_EreignisAbschluss(EREIGNIS_R: integer; INFO: string = '');
begin
  // das Ereignis abzeichnen
  if (INFO <> '') then
    e_x_sql(
      {} 'update EREIGNIS set' +
      {} ' BEARBEITER_R=' + IntToStr(sBearbeiter) + ',' +
      {} ' BEENDET=CURRENT_TIMESTAMP,' +
      {} ' INFO=INFO' + cC_CRLF+ SQLString(INFO) + ' ' +
      {} 'where RID=' + IntToStr(EREIGNIS_R))
  else
    e_x_sql(
      {} 'update EREIGNIS set' +
      {} ' BEARBEITER_R=' + IntToStr(sBearbeiter) + ',' +
      {} ' BEENDET=CURRENT_TIMESTAMP ' +
      {} 'where RID=' + IntToStr(EREIGNIS_R));
end;

function e_r_Person_BLZ_Konto(BLZ, Konto: string): TgpIntegerList;
begin
  Result := e_r_sqlm(
   {} 'select RID from PERSON where ' +
   {} '((Z_ELV_KONTO=''' + Konto + ''') and ' +
   {} ' (Z_ELV_BLZ=''' +    BLZ + ''')) or ' +
   {} '(Z_ELV_KONTO containing ''' + BLZ +  inttostrN(Konto, 10) + ''')');
end;

function e_r_text(RID: integer; LAND_R: integer = 0): TStringList;
var
  cINTERNATIONALTEXT: TdboCursor;
begin
  Result := TStringList.Create;
  cINTERNATIONALTEXT := nCursor;
  with cINTERNATIONALTEXT do
  begin
    sql.add('SELECT INT_TEXT');
    sql.add('FROM INTERNATIONALTEXT');
    sql.add('WHERE RID=' + IntToStr(RID));
    if LAND_R > 0 then
      sql.add('and (LAND_R=' + IntToStr(LAND_R) + ')');
    ApiFirst;
    if EOF then
    begin
      Result.add(IntToStr(RID) + '.' + e_r_ObtainISOfromRID(LAND_R));
    end
    else
    begin
      e_r_sqlt(FieldByName('INT_TEXT'), Result);
    end;
  end;
  cINTERNATIONALTEXT.Free;
end;

function e_r_ObtainISOfromRID(LAND_R: integer): string;
begin
  Result := e_r_sqls('select ISO_KURZZEICHEN from LAND where RID=' + IntToStr(LAND_R));
end;

function e_r_Localize(RID, LAND_R: integer): string;
var
  InfoText: TStringList;
  cINTERNATIONALTEXT: TdboCursor;
begin
  cINTERNATIONALTEXT := nCursor;
  with cINTERNATIONALTEXT do
  begin
    sql.add('SELECT INT_TEXT');
    sql.add('FROM INTERNATIONALTEXT');
    sql.add('WHERE RID=' + IntToStr(RID) + ' AND');
    sql.add('LAND_R=' + IntToStr(LAND_R));
    ApiFirst;
    if EOF then
    begin
      Result := IntToStr(RID) + '.' + e_r_ObtainISOfromRID(LAND_R);
    end
    else
    begin
      InfoText := TStringList.Create;
      e_r_sqlt(FieldByName('INT_TEXT'), InfoText);
      if InfoText.Count > 0 then
        Result := InfoText[0]
      else
        Result := '';
      InfoText.Free;
    end;
  end;
  cINTERNATIONALTEXT.Free;
end;

function e_r_Localize2(RID, LANGUAGE: integer): string;
var
  Land: TdboCursor;
  IntTxt: TdboCursor;
  Bigmemo: TStringList;
begin
  if (RID <= 0) then
  begin
    Result := '';
    exit;
  end;

  Bigmemo := TStringList.Create;
  Land := nCursor;
  IntTxt := nCursor;

  Land.sql.add('SELECT INT_NAME_R FROM LAND WHERE RID=' + IntToStr(RID));
  Land.First;
  IntTxt.sql.add(
   {} 'SELECT INT_TEXT FROM INTERNATIONALTEXT WHERE'+
   {} ' (RID=' + Land.FieldByName('INT_NAME_R').AsString + ') and'+
   {} ' (LAND_R=' + IntToStr(LANGUAGE) + ')');
  IntTxt.First;
  e_r_sqlt(IntTxt.FieldByName('INT_TEXT'), Bigmemo);
  Bigmemo.add('');
  Result := cutblank(Bigmemo[0]);

  Bigmemo.Free;
  Land.Close;
  Land.Free;
  IntTxt.Close;
  IntTxt.Free;
end;

function SicherungDatenbank(BackupGID: integer): boolean;

const
  cScript_List_Generators =
    'select RDB$GENERATOR_NAME from RDB$GENERATORS where (RDB$SYSTEM_FLAG=0) or (RDB$SYSTEM_FLAG is null)';

  // Parameter
  pUpload: boolean = False; {ehemals "checkbox1"}
  pNurFbakErstellen: boolean = False; {ehemals "checkbox2"}
  pNurArchiveErstellen: boolean = False; {ehemals "checkbox3"}
  pNurRestore: boolean = False; {ehemals "checkbox12"}

var
  sBericht: TStringList;
  fbak_Full_FName: string;
  fbak_FName: string;
  ResultFName: string;
  ErrorCount: integer;
  sGENERATORS: TStringList;
  cGENERATORS: TdboCursor;
  cINDEX: TdboCursor;
  FTP: TSolidFTP;

  {$ifdef FPC}
  svcBackup: TIBXBackupService;
  svcRestore: TIBXRestoreService;
  rCONNECTION: TZConnection;
  {$else}
  rCONNECTION: TIB_Connection;
  rTRANSACTION: TIB_Transaction;
  svcBackup: TIBOBackupService;
  svcRestore: TIBORestoreService;
  {$endif}
  GenName: string;
  GenValIst: int64;
  GenValSoll: int64;
  OneLine: string;
  ZipFileList: TStringList;

  procedure Log(s: string);
  begin
    if (Pos(cERRORText, s) > 0) then
      inc(ErrorCount);
    sBericht.add(s);
  end;

  procedure SaveLog;
  begin
    if (sBericht.Count > 0) then
    begin
      AppendStringsToFile(sBericht,
        DiagnosePath + 'Datensicherung-' + inttostrN(BackupGID, 8) + cLogExtension);
      sBericht.Clear;
    end;
  end;

  {$ifndef FPC}
  procedure SetUpService(dbService: TIBOBackupRestoreService);
  {$else}
  procedure SetUpService(dbService: TIBXBackupRestoreService);
  {$endif}
  begin
    with dbService do
    begin
{$ifdef FPC}
     (*
     if (i_c_DataBaseHost = '') then
      Protocol := TProtocol.local
    else
      Protocol := TProtocol.TCP;
      *)
{$else}
      ServerName := i_c_DataBaseHost;
      if (i_c_DataBaseHost = '') then
        Protocol := cpLocal
      else
        Protocol := cpTCP_IP;
      LoginPrompt := False;
      Params.Values['user_name'] := 'SYSDBA';
      Params.Values['password'] := deCrypt_Hex(iDataBasePassword);
      Verbose := True;
{$endif}
    end;
  end;

  function doUpload(ResultFName: string): boolean;
  var
    FtpDestFName: string;
  begin
    Result := False;
    FtpDestFName := ExtractFileName(ResultFName);
    FTP := TSolidFTP.Create;
    with FTP do
    begin
      Host := cFTP_Host;
      UserName := cFTP_UserName;
      Password := cFTP_Password;
      result := Upload(
       {} ResultFName,
       {} cSolidFTP_DirCurrent,
       {} FtpDestFName);
    end;
    FTP.Free;
  end;

  procedure ReadGenerators;
  begin
    sGENERATORS := TStringList.Create;

    try
      Log('###############################');
      Log('# G E N - E V A L U A T I O N #');
      Log('###############################');
      cGENERATORS := nCursor;
      with cGENERATORS do
      begin
        sql.add(cScript_List_Generators);
        ApiFirst;
        while not (EOF) do
        begin
          GenName := Fields[0].AsString;
          sGENERATORS.add(GenName + '=' + IntToStr(e_r_GEN(GenName)));
          Log(sGENERATORS[pred(sGENERATORS.Count)]);
          ApiNext;
        end;
      end;
      cGENERATORS.Free;
    except
      on E: Exception do
      begin
        Log(cERRORText + ' IQ-Evaluation Exception: ' + E.Message);
      end;
    end;
  end;

  procedure DoBackup;
  begin
    with svcBackup do
    begin
{$ifdef fpc}
{$else}
      Log(ServerName);
      try
        DatabaseName := i_c_DataBaseFName;
        Log(fbak_Full_FName);
        Log(iTranslatePath + fbak_FName);
        BackupFile.Clear;
        BackupFile.add(fbak_Full_FName);

        Log('###############');
        Log('# B A C K U P #');
        Log('###############');
        Log('läuft ...');
        Active := True;
        ServiceStart;
        repeat
          try
            while not EOF do
            begin
              OneLine := GetNextLine;

              // SF Bug #
              ersetze(#10, '', OneLine);

              // SF Bug #
              OneLine := cutrblank(OneLine);

              Log(OneLine);
            end;
          except
            on E: Exception do
            begin
              Log(cERRORText + ' Backup Exception: ' + E.Message);
            end;
          end;
        until EOF;

      finally
        Active := False;
      end;
{$endif}
    end;
  end;

  procedure DoRestore;
  begin
    with svcRestore do
    begin
{$ifdef fpc}
{$else}
      try
        PageSize := 16384;
        DatabaseName.Clear;
        DatabaseName.add(fbak_Full_FName + '.fdb');
        BackupFile.Clear;
        BackupFile.add(fbak_Full_FName);


        Log('#################');
        Log('# R E S T O R E #');
        Log('#################');
        Log('läuft ...');

        Active := True;
        ServiceStart;
        repeat
          try
            while not EOF do
            begin
              OneLine := GetNextLine;

              // SF Bug #
              ersetze(#10, '', OneLine);

              // SF Bug #
              OneLine := cutrblank(OneLine);

              Log(OneLine);
            end;
          except
            on E: Exception do
            begin
              Log(cERRORText + ' Restore Exception: ' + E.Message);
            end;
          end;
        until EOF;

      finally
        Active := False;
      end;
{$endif}
    end;
  end;

  procedure DoCheckGenerators;
{$ifdef FPC}
var
  rGEN: TZSequence;
{$endif}
  begin
    Log('#########################');
    Log('# G E N - C O M P A R E #');
    Log('#########################');

    try
        // Verbindung mit der frisch erstellten Datenbank
        {$ifdef FPC}

        rCONNECTION := TZConnection.Create(nil);
        with rCONNECTION do
        begin
          ClientCodePage := 'ISO8859_1';
          ControlsCodePage := cCP_UTF8;
          Protocol := 'firebird-2.5';
          TransactIsolationLevel := tiReadCommitted;
          ReadOnly := true;
          User := 'SYSDBA';
          HostName := i_c_DataBaseHost;
          Database := fbak_Full_FName + '.fdb';
          Password := deCrypt_Hex(iDataBasePassword);
          connect;
        end;

        {$else}

        rTRANSACTION := TIB_Transaction.Create(nil);
        with rTRANSACTION do
        begin
          Isolation := tiCommitted;
          AutoCommit := True;
          ReadOnly := True;
        end;

        rCONNECTION := TIB_Connection.Create(nil);
        with rCONNECTION do
        begin
          DefaultTransaction := rTRANSACTION;
          LoginDBReadOnly := True;
          Protocol := cpTCP_IP;
          if (i_c_DataBaseHost = '') then
            DatabaseName := fbak_Full_FName + '.fdb'
          else
            DatabaseName := i_c_DataBaseHost + ':' + fbak_Full_FName + '.fdb';
          UserName := 'SYSDBA';
          Password := deCrypt_Hex(iDataBasePassword);
        end;

        with rTRANSACTION do
        begin
          IB_Connection := rCONNECTION;
        end;

        rCONNECTION.connect;

        {$endif}

      cGENERATORS := nCursor;
      with cGENERATORS do
      begin
          {$ifdef FPC}
          connection := rCONNECTION;
          {$else}
          IB_Connection := rCONNECTION;
          IB_Transaction := rTRANSACTION;
          {$endif}
        sql.add(cScript_List_Generators);
        ApiFirst;
        if (RecordCount <> sGENERATORS.Count) then
          Log(cERRORText + ' Anzahl der GENERATORen stimmt nicht!');

        while not (EOF) do
        begin
          GenName := Fields[0].AsString;
            {$ifdef FPC}
              rGEN := TZSequence.create(nil);
              with rGEN do
              begin
                connection := rCONNECTION;
                SequenceName := GenName;
                GenValIst := GetCurrentValue;
              end;
              rGEN.free;
            {$else}
          GenValIst := GEN_ID(GenName, 0);
            {$endif}
          GenValSoll := strtoint64def(sGENERATORS.values[GenName], 0);
          if (GenValIst >= GenValSoll) then
          begin
            Log(GenName + ' OK');
          end
          else
          begin
            Log(cERRORText + ' GENERATOR ' + GenName + ': Ist=' +
              IntToStr(GenValIst) + ' Soll=' + IntToStr(GenValSoll));
          end;
          ApiNext;
        end;
      end;
      cGENERATORS.Free;
      sGENERATORS.Free;

      cINDEX := nCursor;
      with cINDEX do
      begin
          {$ifdef FPC}
          connection := rConnection;
          {$else}
        IB_Connection := rCONNECTION;
        IB_Transaction := rTRANSACTION;
          {$endif}
        sql.add('SELECT');
        sql.add(' RDB$INDICES.RDB$RELATION_NAME,');
        sql.add(' RDB$INDICES.RDB$INDEX_NAME,');
        sql.add(' RDB$INDEX_SEGMENTS.RDB$FIELD_NAME');
        sql.add('FROM');
        sql.add(' RDB$INDICES');
        sql.add('JOIN');
        sql.add(' RDB$INDEX_SEGMENTS');
        sql.add('ON');
        sql.add(' RDB$INDICES.RDB$INDEX_NAME=RDB$INDEX_SEGMENTS.RDB$INDEX_NAME');
        sql.add('WHERE');
        sql.add(' (RDB$INDICES.RDB$SYSTEM_FLAG=0) AND');
        sql.add(' (RDB$INDICES.RDB$INDEX_INACTIVE=1)');
        ApiFirst;
        if (RecordCount <> 0) then
          Log(cERRORText + ' Es gibt inaktive Indizes');
        while not (EOF) do
        begin
          Log(
            cWARNINGtext + ' Index ' +
            FieldByName('RDB$RELATION_NAME').AsString + '.' +
            FieldByName('RDB$INDEX_NAME').AsString +
            ' ist nicht aktiv');
          ApiNext;
        end;
      end;
      cINDEX.Free;

      rCONNECTION.disconnect;
      rCONNECTION.Free;
      {$ifndef FPC}
      rTRANSACTION.Free;
      {$endif}
    except
      on E: Exception do
      begin
        Log(cERRORText + ' IQ-Compare Exception: ' + E.Message);
      end;
    end;

  end;

  procedure doCompress;
  begin
    repeat

      ResultFName := DatensicherungPath + fbak_FName + cZIPExtension;

      Log('zip ' + ResultFName + ' ...');

      ZipFileList := TStringList.Create;
      ZipFileList.add(DatensicherungPath + fbak_FName);
      FileDelete(ResultFName);
      if (zip(ZipFileList, ResultFName) <> 1) then
      begin
        Log(cERRORText + ' zip Archiv sollte eine Datei beinhalten!');
        break;
      end;
      ZipFileList.Free;

      // hat das Komprimieren geklappt?
      if not (FileExists(ResultFName)) then
      begin
        Log(cERRORText + ' Archiv ' + ResultFName + ' nicht gefunden!');
        break;
      end;

      // nun das Datenbank-Backup löschen!
      FileDelete(DatensicherungPath + fbak_FName);
      if FileExists(DatensicherungPath + fbak_FName) then
      begin
        Log(cERRORText + ' Datenbank-Datei ' + DatensicherungPath +
          fbak_FName + ' nicht löschbar!');
        break;
      end;

    until yet;

  end;

begin
  Result := False;
  if (BackupGID < 0) then
    exit;

  sBericht := TStringList.Create;

  ErrorCount := 0;
  fbak_FName := cSicherungsPrefix + inttostrN(BackupGID, 8) + '.fbak';
  Log('Datensicherung - ' + IntToStr(BackupGID));
  if (iDataBaseBackUpDir = '') then
  begin
    fbak_Full_FName := i_c_DataBasePath + fbak_FName;
  end
  else
  begin
    fbak_Full_FName := iDataBaseBackUpDir + fbak_FName;
  end;

  repeat
    CheckCreateDir(DatensicherungPath);

    if not (pNurArchiveErstellen) then
    begin

      ReadGenerators;
      if (ErrorCount > 0) then
        break;

      {$ifdef FPC}
      svcBackup := TIBXBackupService.Create(nil);
      svcRestore := TIBXRestoreService.Create(nil);
      {$else}
      svcBackup := TIBOBackupService.Create(nil);
      svcRestore := TIBORestoreService.Create(nil);
      {$endif}

      SetUpService(svcBackup);
      SetUpService(svcRestore);

      // BACKUP
      if not (pNurRestore) then
      begin
        DoBackup;
        SaveLog;
      end;

      if (ErrorCount > 0) then
        break;
      if pNurFbakErstellen then
        break;

      // ist das Backup angekommen? Prüfen über die Windows-Welt
      if not (FileExists(iTranslatePath + fbak_FName)) then
      begin
        Log(cERRORText + ' Datei ' + iTranslatePath + fbak_FName +
          ' fehlt. FreigabePfad= definieren!');
        break;
      end;

    end;
    SaveLog;
    if (ErrorCount > 0) then
      break;

    if not (pUpload) and not (pNurArchiveErstellen) then
    begin

      // restore to proof validty
      DoRestore;
      SaveLog;

      if (ErrorCount > 0) then
        break;

      if not (FileExists(iTranslatePath + fbak_FName + '.fdb')) then
      begin
        Log(cERRORText + ' Datei ' + iTranslatePath + fbak_FName +
          '.fdb' + ' fehlt!');
      end;

      if (ErrorCount > 0) then
        break;
      DoCheckGenerators;
      if (ErrorCount > 0) then
        break;

      // Datenbankdatei aus Sicht der Backup-Routine löschen
      FileDelete(iTranslatePath + fbak_FName + '.fdb');
      if FileExists(iTranslatePath + fbak_FName + '.fdb') then
      begin
        Log(cERRORText + ' Datei ' + iTranslatePath + fbak_FName +
          '.fdb' + ' nicht löschbar!');
      end;

    end;
    SaveLog;
    if (ErrorCount > 0) then
      break;

    svcBackup.Free;
    svcRestore.Free;
    ResultFName := DatensicherungPath + fbak_FName;

    // a) in den Windows Bereich kopieren (falls es nicht schon dort ist!)
    if (iTranslatePath <> DatensicherungPath) then
     if not (FileExists(DatensicherungPath + fbak_FName)) then
     begin
          Log('mv ' + iTranslatePath + fbak_FName + ' ' +
            DatensicherungPath + fbak_FName + ' ...');
          FileMove(iTranslatePath + fbak_FName,
            DatensicherungPath + fbak_FName);
     end;
    SaveLog;

    // Existenz der Ergebnisdatei prüfen!
    if not (FileExists(DatensicherungPath + fbak_FName)) then
    begin
      Log(cERRORText + ' Datei ' + DatensicherungPath + fbak_FName +
        ' nicht gefunden!');
      break;
    end;

    // b) im Windows Bereich komprimieren!
    doCompress;

  until yet;
  SaveLog;

  // FTP Upload?
  if pUpload and (ErrorCount = 0) then
  begin
    Log('FTP Upload ...');
    doUpload(ResultFName);
  end;
  SaveLog;

  // Ergebnis!
  if (ErrorCount = 0) then
  begin
    Log('Erfolgreich beendet');
    Result := True;
  end
  else
  begin
    Log('Es gab Fehler!');
  end;
  SaveLog;

  FreeAndNil(sBericht);
end;

//Errechnet eine Prüfziffer nach Modulo 10
// (c) Frank Rosendahl

function modulo10(zahl: Int64): Int64;
{
    Nach diesem Verfahren werden z.B. die Prüfziffern
    von EAN-Codes (immer die ganz rechte Stelle) berechnet.
    Das System funktioniert wie folgt:
    Angenommener Code 4205 4504 (Camel Filter)
    Die letzte Stelle wollen wir berechnen, diese
    wird also nicht mit einbezogen.
    Die einzelen Stellen werden abwechselnd mit
    3 und 1 multipliziert wobei rechts immer mit
    3 begonnen wird. Die Summe der Produkte wird
    durch 10 (dem Modul) geteilt, der Rest wird von
    10 abgezogen. Sollte hierbei 10 übrigbleiben
    ist die Prüfziffer 0. Hier das Beispiel:

    Stelle      Wert    Wichtung    Produkt
      1           4   *    3          12
      2           2   *    1           2
      3           0   *    3           0
      4           5   *    1           5
      5           4   *    3          12
      6           5   *    1           5
      7           0   *    3           0
                                    -------
    Summe                             36

    Summe / 10(Modul) = 3 Rest 6

    10(Modul) - 6(Rest) = 4  <- Die Prüfziffer
    Wenn der Rest 0 ist wäre die Prüfziffer also 10.
    Da aber nur eine Stelle zur Verfügung steht,
    wird die Prüfziffer 0.
}
var
  wert: Longint;
  multi: Word;
begin
  //Rechte Stelle wird immer mit 3 multipliziert
  multi := 3;
  wert  := 0;
  repeat
    //Wert erhöhen um den Wert der letzten Stelle * Multiplikator
    wert := wert + (zahl - trunc(zahl / 10) * 10) * multi;
    //Multiplikator ist abwechselnd 3 und 1
    if multi = 3 then
      multi := 1
    else
      multi := 3;
    //Letzte Stelle der Zahl abschneiden
    zahl := trunc(zahl / 10);
  until zahl = 0;

  //Prüfziffer ermitteln
  Result := 10 - (wert - trunc(wert / 10) * 10);
  //Wenn
  if (Result = 10) then
    Result := 0;
end;

function PruefZifferOK(zahl: Int64): Boolean;
  //Prüft mit Hilfe von "modulo 10", ob die letzte
  //(rechte) Stelle als Prüfziffer korrekt ist.
begin
  //letzte Stelle Abschneiden und Prüfziffer errechnen,
  //dann mit letzter Stelle der übergebenen Zahl vergleichen
  Result := modulo10(trunc(zahl / 10)) = zahl - (trunc(zahl / 10) * 10);
end;

function PruefZiffer(n : int64):byte;
begin
  result := modulo10(n);
end;

function e_r_Verlag(PERSON_R: integer): string;
begin
  if (PERSON_R < cRID_FirstValid) then
    result := ''
  else
    result := e_r_sqls('select SUCHBEGRIFF from PERSON where RID=' + inttostr(PERSON_R));
end;

function e_r_VERLAG_R_fromVerlag(Verlag: string): integer; // [VERLAG_R]
begin
  result := e_r_sql(
   {} 'select RID from VERLAG where PERSON_R='+
   {} '(SELECT RID from PERSON where '+
   {} 'SUCHBEGRIFF=''' + Verlag + ''')');
  if (result = 0) then
    result := cRID_Null;
end;

function e_r_VERLAG_R_fromVerlag(PERSON_R: Integer): integer; // [VERLAG_R]
begin
  result := e_r_sql(
   {} 'select RID from VERLAG where PERSON_R='+
   {} IntToStr(PERSON_R) );
  if (result = 0) then
    result := cRID_Null;
end;

function e_r_LandRID(ISO: string): integer;
begin
  result := e_r_sql('select RID from LAND where ISO_KURZZEICHEN=''' + ISO + '''');
end;

function e_r_LadeParameter: TStringList;

  procedure EnsureEntry(EntryName: string; Lines: TStrings; var OneChanged: boolean);
  var
    n: integer;
    LineSettingFound: boolean;
  begin
    if Lines.values[EntryName] = '' then
    begin
      LineSettingFound := false;
      for n := 0 to pred(Lines.count) do
        if pos(AnsiUpperCase(EntryName + '='), AnsiUpperCase(Lines[n])) = 1 then
        begin
          LineSettingFound := true;
          break;
        end;
      if not(LineSettingFound) then
      begin
        OneChanged := true;
        Lines.values[EntryName] := '';
        Lines.add(EntryName + '=');
      end;
    end;
  end;

  procedure ReadAndSetColor(p: string; var c: TColor);
  begin
    if (p <> '') then
      c := HTMLColor2TColor(p);
  end;

var
  sSystemSettings: TStringList;

  function localized_parameter(p: string; default : string = ''): string;
  begin
   repeat
     result := sSystemSettings.Values[p+'.'+UserName+'@'+ComputerName];
     if (result<>'') then
      break;

     result := sSystemSettings.Values[p+'.'+UserName];
     if (result<>'') then
      break;

     result := sSystemSettings.Values[p+'@'+ComputerName];
     if (result<>'') then
      break;

     result := sSystemSettings.Values[p];
     if (result<>'') then
      break;

     result := default;

   until yet;

  end;

var
{$IFDEF CONSOLE}
  cSETTINGS: TdboCursor;
{$ELSE}
  qSETTINGS: TdboQuery;
{$ENDIF}
  n: integer;
  SettingsChanged: boolean;
  s : string;
begin
  sSystemSettings := nil;
  try
    repeat

{$IFDEF CONSOLE}
      sSystemSettings := e_r_sqlt('select SETTINGS from EINSTELLUNG');
{$ELSE}
      sSystemSettings := TStringList.create;
      qSETTINGS := nQuery;
      with qSETTINGS do
      begin
        sql.add('select * from EINSTELLUNG ' + for_update);
        Open;
        if not(HasFieldName(qSETTINGS, 'SETTINGS')) then
          break;
        First;
        if not(eof) then
        begin
          e_r_sqlt(FieldByName('SETTINGS'), sSystemSettings);
        end
        else
        begin
          Insert;
          sSystemSettings.add('Erstanlage=' + long2dateLocalized(DateGet));
          FieldByName('SETTINGS').assign(sSystemSettings);
          FieldByName('RID').AsInteger := 0;
          Post;
          refresh;
          First;
        end;
        SettingsChanged := cutblank(sSystemSettings);
        for n := 0 to pred(cAllSettingsAnz) do
          EnsureEntry(cAllSettings[n], sSystemSettings, SettingsChanged);
        if SettingsChanged then
        begin
          edit;
          FieldByName('SETTINGS').assign(sSystemSettings);
          Post;
        end;
      end;
      qSETTINGS.free;
{$ENDIF}
    until yet;
  except
    on E: exception do
    begin
      AppendStringsToFile('e_r_LadeParameter: ' + E.Message,
        {} ErrorFName('BELEG'),
        {} Uhr12);
    end;

  end;

  // völlig ohne Konfiguration?
  if not(assigned(sSystemSettings)) then
    sSystemSettings := TStringList.create;

  // selbst berechenbare PArameter
  is1400 := not(TableExists('AUSGANGSRECHNUNG'));

  // Systemparameter
  iMwStSatzManuelleArtikel := sSystemSettings.values['MwStSatzManuelleArtikel'];
  iNachlieferungInfo := sSystemSettings.values['NachlieferungInfo'];
  iBereitsGeliefertInfo := sSystemSettings.values['BereitsGeliefertInfo'];
  iStandardTextRechnung := sSystemSettings.values['StandardTextRechnung'];
  iTranslatePath := sSystemSettings.values['FreigabePfad'];
  iSicherungsPfad := sSystemSettings.values['SicherungsPfad'];
  FotoPath := sSystemSettings.values['FotoPfad'];
  iSicherungsPrefix := sSystemSettings.values['SicherungsPrefix'];
  iSicherungenAnzahl := sSystemSettings.values['SicherungenAnzahl'];
  iSicherungLokalesZwischenziel := sSystemSettings.values['SicherungLokalesZwischenziel'] <> cIni_DeActivate;
  iSicherungsTyp := sSystemSettings.values['SicherungsTyp'];
  iNichtMehrLieferbarInfo := sSystemSettings.values['NichtMehrLieferbarInfo'];
  iDataBaseBackUpDir := sSystemSettings.values['DatenbankBackupPfad'];
  iTagesAbschlussUm := strtoseconds(sSystemSettings.values['TagesabschlussUm']);
  iTagesAbschlussAuf := cutblank(sSystemSettings.values['TagesabschlussAuf']);
  iIdleProzessPrioritaetAbschluesse := cutblank(sSystemSettings.values['TagesabschlussIdle']) <> cIni_DeActivate;
  iNachTagesAbschlussHerunterfahren := sSystemSettings.values['NachTagesAbschlussHerunterfahren'] = cIni_Activate;
  iNachTagesAbschlussRechnerNeustarten := sSystemSettings.values['NachTagesAbschlussRechnerNeuStarten'] = cIni_Activate;
  iNachTagwacheRechnerNeustarten := sSystemSettings.values['NachTagwacheRechnerNeuStarten'] = cIni_Activate;
  iNachTagesAbschlussAnwendungNeustart := sSystemSettings.values['NachTagesAbschlussAnwendungNeustart'] = cIni_Activate;
  iNachTagwacheAnwendungNeustart := sSystemSettings.values['NachTagwacheAnwendungNeustart'] = cIni_Activate;
  iTagesabschlussRang := sSystemSettings.values['TagesabschlussBerechneRang'] <> cIni_DeActivate;
  iAblage := sSystemSettings.values['Ablage'] <> cIni_DeActivate;
  iTagwacheWochentage := sSystemSettings.values['TagwacheWochentage'];
  iTagwacheBaustelle := StrToIntDef(sSystemSettings.values['TagwacheBaustelle'], cRID_Null);
  iTagesabschlussWochentage := sSystemSettings.values['TagesabschlussWochentage'];

  iArtikelDatenbankSucheAktiv := sSystemSettings.values['ArtikelDatenbankSucheAktiv'] = cIni_Activate;
  iSuchlimitMaxSuchtreffer := StrToIntDef(sSystemSettings.values['SuchlimitMaxSuchtreffer'], 100);
  iSuchworteAnzahlMax := StrToIntDef(sSystemSettings.values['SuchworteAnzahlMax'], 9);


  iFaktorGanzzahlig := sSystemSettings.values['FaktorGanzzahlig'] <> cIni_DeActivate;
  iEinsUnterdrueckung := sSystemSettings.values['EinsUnterdrückung'] = cIni_Activate;
  iOpenOfficePDF := sSystemSettings.values['OpenOfficePDF'] = cIni_Activate;
  iAutoUpRevDir := sSystemSettings.values['AutoUpRevPfad'];

  // FTP-Sachen
  iAutoUpFTP := sSystemSettings.values['AutoUpFTP'];
  iDiagnoseFTP := sSystemSettings.values['DiagnoseFTP'];
  iMobilFTP := sSystemSettings.values['MobilFTP'];
  iFTPAlias := sSystemSettings.values['FTPServer'];
  iFtpProxyHost := sSystemSettings.values['FTPProxyHost'];
  iFtpProxyPort := StrToIntDef(sSystemSettings.values['FTPProxyPort'], 0);

  iTagwacheUm := strtoseconds(sSystemSettings.values['TagwacheUm']);
  iTagwacheAuf := cutblank(sSystemSettings.values['TagwacheAuf']);
  iNachTagwacheHerunterfahren := sSystemSettings.values['NachTagwacheHerunterfahren'] = cIni_Activate;
  iKontoInhaber := sSystemSettings.values['KontoInhaber'];
  iGlaeubigerID := sSystemSettings.values['GläubigerID'];
  iKontoBankName := sSystemSettings.values['KontoBankName'];
  iKontoNummer := sSystemSettings.values['KontoNummer'];
  iKontoBLZ := sSystemSettings.values['KontoBLZ'];
  iKontoPIN := sSystemSettings.values['KontoPIN'];
  iKontoSEPAFrist := StrToIntDef(sSystemSettings.values['KontoSEPAFrist'], cDTA_LastschriftVerzoegerung);
  iKontoLSErkennung := sSystemSettings.values['KontoSEPAFrist'] <> cIni_DeActivate;
  iKontenHBCI := sSystemSettings.values['KontenHBCI'];
  iHBCIRest := sSystemSettings.values['HBCIRest'];
  iBuchFokus := StrToIntDef(sSystemSettings.values['BuchFokus'], -1);
  if (iBuchFokus > 0) then
    iBuchFokus := DatePlus(DateGet, -iBuchFokus)
  else
    iBuchFokus := date2Long(sSystemSettings.values['BuchFokus']);
  SpoolDir := sSystemSettings.values['SpoolPath'];
  iTestDrucker := sSystemSettings.values['TestDrucker'];
  iMusicPath := sSystemSettings.values['MusicPath'];
  iMusicPathShop := sSystemSettings.values['ShopMusicPath'];
  iTPicUpload := sSystemSettings.values['TPicUploadPfad'];
  iVerlagsdatenabgleich := sSystemSettings.values['VerlagsdatenabgleichPfad'];
  iHTMLPath := sSystemSettings.values['htmlPath'];
  iBildURL := sSystemSettings.values['BilderURL'];
  iShopArtikelBilderURL := sSystemSettings.values['ShopArtikelBilderURL'];
  iShopArtikelBilderPath := sSystemSettings.values['ShopArtikelBilderPfad'];
  iPDFPathShop := sSystemSettings.values['PDFPathShop'];
  iPDFPathApp := sSystemSettings.values['PDFPathApp'];
  iMailHost := sSystemSettings.values['PDFVersender'];
  iPDFAdmin := sSystemSettings.values['PDFAdmin'];
  iPDFSend := sSystemSettings.values['PDFSend'];
  iPDFZoom := localized_parameter ('PDFZoom', '3.0');
  iTagesabschlussAusschluss := ','+noblank(localized_parameter('TagesabschlussAusschluss'))+',';
  iTagwacheAusschluss := ','+noblank(localized_parameter('TagwacheAusschluss'))+',';

  iShopDomain := sSystemSettings.values['ShopHost'];
  iShopQRPath := sSystemSettings.values['ShopQRPfad'];
  iXMLRPCHost := sSystemSettings.values['XMLRPCHost'];
  iXMLRPCPort := sSystemSettings.values['XMLRPCPort'];
  iXMLRPCGeroutet := sSystemSettings.values['XMLRPCGeroutet'] = cIni_Activate;
  imemcachedHost := sSystemSettings.values['memcachedHost'];
  if (imemcachedHost='') then
   imemcachedHost := sSystemSettings.values['memcacheHost'];
  iRESTHost := sSystemSettings.values['RESTHost'];
  iRESTPort := sSystemSettings.values['RESTPort'];
  iRESTGeroutet := sSystemSettings.values['RESTGeroutet'] = cIni_Activate;
  iShopKey := sSystemSettings.values['ShopKey'];
  iShopKonto := sSystemSettings.values['ShopKonto'];
  iShopLink := sSystemSettings.values['ShopLink'];
  iShopMP3 := sSystemSettings.values['ShopMP3'];
  iArtikelAusgang_ScannerHost := sSystemSettings.values['ScannerHost'];
  iArtikelEingang_ScannerHost := sSystemSettings.values['ArtikelEingangScannerHost'];
  iScannerAutoBuchen := sSystemSettings.values['ScannerAutoBuchen'] <> cIni_DeActivate;
  iLabelHost := sSystemSettings.values['LabelHost'];
  iKasseHost := sSystemSettings.values['KassenHost'];
  iMagnetoHost := sSystemSettings.values['MagnetoHost'];
  iSchubladePort := sSystemSettings.values['SchubladePort'];
  iPortoFreiAbBrutto := sSystemSettings.values['PortoFreiAbBrutto'];
  iPortoMwStLogik := sSystemSettings.values['PortoMwStLogik'] <> cIni_DeActivate;
  iAuftragsmedium := sSystemSettings.values['Auftragsmedium'];
  iAuftragsmotivation := sSystemSettings.values['Auftragsmotivation'];
  iAuftragsGrundRueckfrage := sSystemSettings.values['AuftragsGrundRückfrage'] <> cIni_DeActivate;
  iRangZeitfenster := StrToIntDef(sSystemSettings.values['RangZeitfenster'], 60);
  iLieferzeitZeitfenster := StrToIntDef(sSystemSettings.values['LieferzeitZeitfenster'], 365);
  iStandardLieferZeit := StrToIntDef(sSystemSettings.values['StandardLieferzeit'], 5);
  iSchnelleRechnung_PERSON_R := StrToIntDef(sSystemSettings.values['PersonSchnelleRechnung'], 0);
  iFormColor := HTMLColor2TColor(sSystemSettings.values['Farbe']);
  iReplikation := sSystemSettings.values['Replikation'] = cIni_Activate;
  iGOT := sSystemSettings.values['GOT'] = cIni_Activate;
  iBelegAutoSetMengeNull := sSystemSettings.values['BelegSetzeMengeNullBeiPreisNull'] = cIni_Activate;
  iBelegArtikelNeu := sSystemSettings.values['BelegArtikelNeu'] = cIni_Activate;
  iBruttoVersandGewicht := sSystemSettings.values['BruttoVersandGewicht'] = cIni_Activate;
  iRechnungGlattstellen := sSystemSettings.values['BelegRechnungGlattstellen'] = cIni_Activate;
  iUnterdrueckeGeliefertes := sSystemSettings.values['BelegUnterdrückeGeliefertes'] = cIni_Activate;
  iBelegMengenSortierung := sSystemSettings.values['BelegMengenSortierung'] = cIni_Activate;
  iEinzelpreisNetto := sSystemSettings.values['EinzelpreisNetto'] = cIni_Activate;
  iEinzelPositionNetto := sSystemSettings.values['EinzelPositionNetto'];
  iMahnSchwelle := strtodoubledef(sSystemSettings.values['Mahnschwelle'], 6.00);
  iMahnFaelligkeitstoleranz := StrToIntDef(sSystemSettings.values['Mahnfälligkeitstoleranz'], 5);
  iMahnungAusgelicheneDazwischenAnzeigen := sSystemSettings.values['MahnungAusgelicheneDazwischenAnzeigen']
    = cIni_Activate;
  iMahnungErstAbUnausgeglichenheit := sSystemSettings.values['MahnungErstAbUnausgeglichenheit'] = cIni_Activate;
  iMahnlaufbeiTagesabschluss := sSystemSettings.values['MahnlaufbeiTagesabschluss'] <> cIni_DeActivate;
  iAnschriftNameOben := sSystemSettings.values['AnschriftNameOben'] = cIni_Activate;
  iMahnungGebuehr1 := strtodoubledef(sSystemSettings.values['MahnungGebuehr1'], 0.0);
  iMahnungGebuehr2 := strtodoubledef(sSystemSettings.values['MahnungGebuehr2'], 0.0);
  iMahnungGebuehr3 := strtodoubledef(sSystemSettings.values['MahnungGebuehr3'], 0.0);
  iMahnungZinsSatzPrivat := strtodoubledef(sSystemSettings.values['MahnungZinsSatzPrivat'], 0.0);
  iMahnungZinsSatzGewerblich := strtodoubledef(sSystemSettings.values['MahnungZinsSatzGewerblich'], 0.0);
  iMahnungMindestZins := strtodoubledef(sSystemSettings.values['MahnungMindestZins'], 0.0);
  iMahnstufeZinsEintritt := StrToIntDef(sSystemSettings.values['MahnungMahnstufeZinsEintritt'], pred(MaxInt));
  // [Tage], solange wird nochmaliges Mahnen verhindert
  iMahnfreierZeitraum := StrToIntDef(sSystemSettings.values['MahnungAbstand'], 14);
  iKommaFaktor := sSystemSettings.values['KommaFaktor'] = cIni_Activate;
  iBelegAnzeigeNachBuchen := (sSystemSettings.values['BelegAnzeigeNachBuchen'] = cIni_Activate) or
    (sSystemSettings.values['BelegAnzeigeNachBuchen'] = '');
  iWikiServer := sSystemSettings.values['WikiServer'];
  iTextDocumentExtension := sSystemSettings.values['TextdokumentDateierweiterung'];
  iAuftragsObjektPath := sSystemSettings.values['AuftragsObjektPfad'];
  iAuftragsAblagePath := sSystemSettings.values['AuftragsAblagePfad'];
  ReadAndSetColor(sSystemSettings.values['FarbeStufe1'], iWarnFarbe_L0);
  ReadAndSetColor(sSystemSettings.values['FarbeStufe2'], iWarnFarbe_L1);
  ReadAndSetColor(sSystemSettings.values['FarbeStufe3'], iWarnFarbe_L2);
  ReadAndSetColor(sSystemSettings.values['FarbeStufe4'], iWarnFarbe_L3);
  ReadAndSetColor(sSystemSettings.values['FarbeStufe5'], iWarnFarbe_L4);
  iCSVOpenPath := sSystemSettings.values['csvQuelle'];
  iTagesArbeitszeit := strtosecondsdef(sSystemSettings.values['TagesArbeitszeit'], 8 * 60 * 60);
  iJonDaVorlauf := strtol(sSystemSettings.values['MonDaVorlauf']);
  iOLAPpublic := sSystemSettings.values['OLAPIstÖffentlich'] = cIni_Activate;
  iAblageZeitraum := strtol(sSystemSettings.values['AblageVerzögerung']);
  if (iAblageZeitraum = 0) then
    iAblageZeitraum := 70;
  iAusgabeartLastschriftText := StrToIntDef(sSystemSettings.values['AusgabeartLastschriftText'], cRID_Null);
  iBuchSonstigeErloese := sSystemSettings.values['BuchSonstigeErlöse'];
  iBaustellenPfad := sSystemSettings.values['BaustellenPfad'];
  iMusikDownloadsProArtikel := StrToIntDef(sSystemSettings.values['MaxDownloadsProArtikel'], 0);

  // Relative Pfade erweitern
  ersetze('.\', MyProgramPath, iPDFPathApp);

  //
  iRechnungsNummerVergabeMoment := ernvm_Verbuchen;
  if (sSystemSettings.values['RechnungsNummerVergabeMoment'] = 'Anlage') then
    iRechnungsNummerVergabeMoment := ernvm_Anlage;
  if (sSystemSettings.values['RechnungsNummerVergabeMoment'] = 'Berechnen') then
    iRechnungsNummerVergabeMoment := ernvm_Berechnen;
  if (sSystemSettings.values['RechnungsNummerVergabeMoment'] = 'Vorschau') then
    iRechnungsNummerVergabeMoment := ernvm_Vorschau;
  if (sSystemSettings.values['RechnungsNummerVergabeMoment'] = 'Verbuchen') then
    iRechnungsNummerVergabeMoment := ernvm_Verbuchen;

  // Profil-Texte
  iProfilTexte.clear;
  for n := 0 to 17 do
    iProfilTexte.add(sSystemSettings.values['Profil' + inttostrN(succ(n), 2)]);

  // Profil-Texte
  iSchalterTexte.clear;
  for n := 0 to 19 do
    iSchalterTexte.add(sSystemSettings.values['Schalter' + inttostrN(succ(n), 2)]);

  s := sSystemSettings.values['LagerPrinzip'];
  iLagerPrinzip := LagerPrinzip_Diversitaet;
  for n := 0 to pred(ord(LagerPrinzip_COUNT)) do
   if (s=cLagerPrinzipien[eLagerPrinzipien(n)]) then
   begin
    iLagerPrinzip := eLagerPrinzipien(n);
    break;
   end;

  s := sSystemSettings.values['LagerPrämisse'];
  iLagerPraemisse := LagerPraemisse_Fluten;
  for n := 0 to pred(ord(LagerPraemisse_COUNT)) do
   if (s=cLagerPraemissen[eLagerPraemissen(n)]) then
   begin
    iLagerPraemisse := eLagerPraemissen(n);
    break;
   end;

  iNeuanlageZeitraum := StrToIntDef(sSystemSettings.values['NeuanlageZeitraum'], 3);
  // [Tage], solange Artikel/Personen als Neuanlage gelten
  iKartenPfad := sSystemSettings.values['KartenPfad'];
  iKartenHost := sSystemSettings.values['KartenHost'];
  iKartenProfil := sSystemSettings.values['KartenProfil'];
  iKartenQuota := StrToInt64Def(sSystemSettings.values['KartenQuota'], 0);

  iJonDaAdmin := StrToIntDef(sSystemSettings.values['JonDaAdmin'], cRID_Null);
  iJonDaServer := sSystemSettings.values['AppServerURL'];
  iAppServerPfad := sSystemSettings.values['AppServerPfad'];
  iAppServerId := sSystemSettings.values['AppServerId'];
  iFSPath := localized_parameter('FunktionsSicherungstellungsPfad', EigeneOrgaMonDateienPfad + 'fs\');
  iFotoRecherchePfad := sSystemSettings.values['FotoRecherchePfad'];
  iInternetAblagenPfad := sSystemSettings.values['InternetAblagenPfad'];

  // defaults
 if (iSicherungenAnzahl='') then
  iSicherungenAnzahl := '10';
 if (iSicherungenAnzahl='-1') then
  iSicherungenAnzahl := cIni_DeActivate;

  if (iMwStSatzManuelleArtikel='') then
   iMwStSatzManuelleArtikel := 'SATZ3';
  if (iAppServerPfad<>'') then
   ProtokollePath := iAppServerPfad + 'dat\Protokolle\';
  iOrtFormat := sSystemSettings.values['OrtFormat'];
  if (iOrtFormat = '') then
    iOrtFormat := '%l-%p %o %s';
  iHeimatLand := e_r_LandRID(sSystemSettings.values['BearbeiterSprache']);
  if (iHeimatLand < cRID_FirstValid) then
    iHeimatLand := e_r_LandRID('DE');
  if (iAuftragsmedium = '') then
    iAuftragsmedium := 'Telefon,Fax,Persönlich,Brief,Webshop';
  if (iAuftragsmotivation = '') then
    iAuftragsmotivation := 'Werbung,Katalog,Empfehlung';
  if (iKontoInhaber = '') then
    iKontoInhaber := '-1';
  if (iKontoBankName = '') then
    iKontoBankName := '-1';
  if (iKontoNummer = '') then
    iKontoNummer := '-1';
  if (iKontoBLZ = '') then
    iKontoBLZ := '-1';
  if (iSicherungsPrefix = '') then
    iSicherungsPrefix := nextp(MyProgramPath, '\', CharCount('\', MyProgramPath) - 1) + '_';
  if (iSicherungsTyp='') then
    iSicherungsTyp := 'Zip';
  if (iFormColor = 0) then
    iFormColor := TColors.SysBtnFace;

  // AutoUp und FS
  iAutoUpRevDir := evalPath(iAutoUpRevDir);
  if (iAutoUpRevDir = '') then
    iAutoUpRevDir := '..\rev\';
  if (pos(':', iAutoUpRevDir) = 0) then
    iAutoUpRevDir := ExpandFileName(MyApplicationPath + iAutoUpRevDir);

  if (iTextDocumentExtension = '') then
    iTextDocumentExtension := cDOCextension;
  if (iKartenPfad = '') then
    iKartenPfad := EigeneOrgaMonDateienPfad + 'Karten\';
  if (iKartenHost = '') then
    iKartenHost := cOpenStreetMap_TileURL;

  if (iAuftragsAblagePath = '') then
    iAuftragsAblagePath := iAuftragsObjektPath;
  if (iKontenHBCI = '') then
    if (iKontoNummer <> '') and (iKontoPIN <> '') then
      iKontenHBCI := iKontoNummer + ':' + iKontoPIN;
  if (iBildURL = '') then
    iBildURL := './images/upload/';
  if (iShopArtikelBilderURL = '') then
    iShopArtikelBilderURL := iBildURL;
  if (iTestDrucker = '') then
    iTestDrucker := 'FreePDF';
  if (iTestDrucker = cIni_DeActivate) then
    iTestDrucker := '';

  // defaults für "FreigabePfad="
  if (iTranslatePath='') then
   repeat

     if (i_c_DataBaseHost<>'') and (pos('/',i_c_DataBasePath)>0) then
     begin
      // We have a Linux-Server
      iTranslatePath := i_c_DataBasePath;
      ersetze('/srv/firebird/','',iTranslatePath);
      ersetze('/','\',iTranslatePath);
      iTranslatePath :=
        {} '\\' + i_c_DataBaseHost +
        {} '\' + 'firebird' + '\' +
        {} iTranslatePath;
      break;
     end;

     if (iDataBaseBackUpDir = '') then
       iTranslatePath := i_c_DataBasePath
     else
       iTranslatePath := DatensicherungPath;

    until yet;

  if (iSicherungsPfad = '') then
   iSicherungsPfad := EigeneOrgaMonDateienPfad;

  cSperreUrlaub := HTMLColor2TColor($00FF00);
  cSperreAuszeit := HTMLColor2TColor($669933);
  cSperreFeiertag := HTMLColor2TColor($9999FF);

  // Sperr Wertigkeiten für Sperre
  sSperre_Wert_Baustelle.clear;
  sSperre_Wert_Baustelle.add('SPERRE;JA;' + TColor2HTMLColor(cSperreBaustelle) + ';' +
    inttostr(cPrio_BaustellenSperre));
  sSperre_Wert_Baustelle.add('AUSZEIT;JA;' + TColor2HTMLColor(cSperreAuszeit) + ';' + inttostr(cPrio_BaustellenSperre));
  sSperre_Wert_Baustelle.add('BAUSTOPP;JA;#C0C0C0' + ';' + inttostr(cPrio_BaustellenSperre + 1));

  sSperre_Wert_Person.clear;
  sSperre_Wert_Person.add('SPERRE;JA;' + TColor2HTMLColor(cSperreUrlaub) + ';' + inttostr(cPrio_MonteurSperre));
  sSperre_Wert_Person.add('AUSZEIT;JA;' + TColor2HTMLColor(cSperreAuszeit) + ';' + inttostr(cPrio_MonteurSperre));

  sSperre_Wert_Arbeit.clear;
  sSperre_Wert_Arbeit.add('ARBEIT;JA;' + TColor2HTMLColor(cSperreArbeit) + ';' + inttostr(cPrio_ArbeitSperre));
  sSperre_Wert_Arbeit.add('MEHRARBEIT;JA;' + TColor2HTMLColor(cSperreMehrarbeit) + ';' +
    inttostr(cPrio_ArbeitSperre + 1));

  sSperre_Wert_Baustopp.clear;
  sSperre_Wert_Baustopp.add('BAUSTOPP;JA;#C0C0C0;1');

  sSperre_Wert_Zuordnung.clear;
  sSperre_Wert_Zuordnung.add('ZUORDNUNG;JA;' + TColor2HTMLColor(cSperreArbeit) + ';' + inttostr(cPrio_ArbeitSperre));

  result := sSystemSettings;
end;


begin
  // Datenbank - Zugriffselemente erzeugen!

{$IFDEF CONSOLE}
{$IFDEF fpc}
  fbConnection := TZConnection.Create(nil);
  with fbConnection do
  begin
    ClientCodePage := 'ISO8859_1';
    ControlsCodePage := cCP_UTF8;
    Protocol := 'firebird-2.5';
    TransactIsolationLevel := tiReadCommitted;
  end;
{$ELSE}
  {$ifndef IBO_OLD}
  fbClientLib := TIB_ClientLib.Create(nil);
  with fbClientLib do
  begin
    Filename := ExtractFilePath(ParamStr(0)) + globals.GetFBClientLibName;
  end;
  {$endif}

  fbSession := TIB_Session.Create(nil);
  fbTransaction := TIB_Transaction.Create(nil);
  fbConnection := TIB_Connection.Create(nil);


  with fbSession do
  begin
    {$ifndef IBO_OLD}
    IB_ClientLib := fbClientLib;
    {$endif}
    AllowDefaultConnection := True;
    AllowDefaultTransaction := True;
    DefaultConnection := fbConnection;
    StoreActive := False;
    UseCursor := False;
  end;

  with fbConnection do
  begin
    IB_Session := fbSession;
    CacheStatementHandles := False;
    DefaultTransaction := fbTransaction;
    SQLDialect := 3;
    ParameterOrder := poNew;
    CharSet := 'NONE';
  end;

  with fbTransaction do
  begin
    IB_Session := fbSession;
    IB_Connection := fbConnection;
    ServerAutoCommit := True;
    Isolation := tiCommitted;
    RecVersion := True;
    LockWait := True;
  end;
{$ENDIF}
{$ENDIF}

end.
