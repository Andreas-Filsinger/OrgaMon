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
unit Funktionen_Basis;

interface

uses
{$IFNDEF fpc}
  IB_Access,
  IB_Components,
{$ENDIF}
  Classes, gplists, globals,
  CareTakerClient;

{
  eBasis: Grundlegende Funktionen des OrgaMon ohne besondere Zuordnung zu

  eCommerce, eResource

}

{ System }
function e_r_BasePlug: TStringList;
function e_r_Bearbeiter: integer; // [TReference]

function e_r_BearbeiterKuerzel(BEARBEITER_R: integer): string;
// Liefert das Kürzel des Bearbeiters.
//

{ Datenbank }
function SysDBApassword: string;

function dbBackup(BackupGID: Integer): boolean;
// Erstellt und prüft ein Backup der aktuellen Datenbank
//

function ReadLongStr(BlockName: string; ArtikelInfo: TStringList; delimiter: char = #13): string;
// aus einem Memo-Feld einen Value lesen, der aber über
// mehrere Zeilen gehen kann.
// Wirtschafts und Lager Logik


{ System Ereignisse }
procedure e_w_EreignisAbschluss(EREIGNIS_R: integer; INFO: string = '');

{ Person }
procedure e_w_PersonSetPassword(PERSON_R: integer);
procedure e_w_PersonEnsurePassword(PERSON_R: integer);
function e_r_Person_BLZ_Konto(BLZ, Konto: string): TgpIntegerList;

{ Baustelle }
function e_r_ParameterFoto(settings: TStringList; p: string): string;
function e_r_BaustellenPfadFoto(settings: TStrings): String;
function e_r_BaustellenPfad(settings: TStrings): String;

function e_w_Medium: string;
function e_x_ensureMedium(Name: string): TDOM_Reference;

procedure e_a_Infos(s: TStrings);
function cAusgabeArt_Aufnahme_MP3: TDOM_Reference;

{ Musiker }
function e_r_MusikerName(MUSIKER_R: integer): string;
function e_r_MusikerNachName(MUSIKER_R: integer): string;
function e_r_MusikerNurNachName(MUSIKER_R: integer): string;
function e_r_MusikerUeber(MUSIKER_R: integer): string;
function e_r_MusikerCache: TStringList;
function e_r_MusikerNachnamen: TStringList;
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

function enCrypt_Hex(s: string): string;
function deCrypt_Hex(s: string): string;
procedure MigrateFrom(BringTo: integer);

// Landesspezifiesche Strings
//
function e_r_Localize(RID, LAND_R: integer): string;
function e_r_Localize2(RID, LANGUAGE: integer): string;

// System Texte
function e_r_text(RID: integer; LAND_R: integer = 0): TStringList;


{ Artikel }

function e_r_ArtikelPDF(ARTIKEL_R: integer): TStringList;

function MengeAbschreiben(var GesamtVolumen, AbschreibeMenge: integer): integer;
// Abgeschrieben
// --------------------------------------------------------------------------
//
// Eine Abschreibe-Menge wird an einem Volumen abgeschrieben. Es wird
// im Prinzip gerechnet:
//
// dec(GesamtVolumen,AbschreibeMenge);
//
// Folgende Besonderheiten
// Es kann nicht über das Gesamtvolumen hinaus abgeschrieben werden
// Es wird zurückgeliefert, was wirklich abgeschrieben werden konnte
// --------------------------------------------------------------------------




implementation

uses
  Windows, SysUtils,
  DCPcrypt2, DCPblockciphers, DCPblowfish,

  math,
  anfix32, dbOrgaMon, SimplePassword,

  // wegen der Versionsnummern
{$IFDEF fpc}
  ZClasses,
  ZConnection,
  ZCompatibility,
  ZDbcIntfs,
  FBAdmin,
{$ELSE}
  JclFileUtils,
  FlexCel.Core,
  CCR.Exif.Consts,
  GHD_pngimage,
  JclBase,
{$ENDIF}
{$IFNDEF CONSOLE}
  Datenbank,
  TPUMain,
  JvclVer,
{$ENDIF}
  idglobal,
  InfoZIP,
  srvXMLRPC,
  memcache;

const
  CacheMusikerLiveTime = 2 * 60 * 60 * 1000; // 2 Stunden
  { Private-Deklarationen }
  { Cache Musiker }
  CacheMusikerBirth: dword = 0;
  CacheMusiker: TStringList = nil;
  CacheMusikerNachname: TStringList = nil;
  CacheMusikerNurNachname: TStringList = nil;

  { Cache Laender }
  CacheLaender: TStringList = nil;
  CacheLaenderFull: TStringList = nil;

  { Pwd Crypt }
  CryptKeyLength: integer = 0;

var
  CryptKey: array [0 .. 1023] of AnsiChar;

procedure EnsureCache_Musiker; forward;
procedure EnsureCache_Laender; forward;

function e_r_MusikerName(MUSIKER_R: integer): string;
var
  k: integer;
begin
  if (MUSIKER_R > 0) then
  begin
    EnsureCache_Musiker;
    k := CacheMusiker.indexofobject(TObject(MUSIKER_R));
    if (k <> -1) then
      result := CacheMusiker[k]
    else
      result := '?';
  end
  else
  begin
    result := '';
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
      result := CacheMusikerNachname[k]
    else
      result := '?';
  end
  else
  begin
    result := '';
  end;
end;

function e_r_MusikerNurNachName(MUSIKER_R: integer): string;
var
  k: integer;
begin
  if (MUSIKER_R > 0) then
  begin
    EnsureCache_Musiker;
    k := CacheMusikerNurNachname.indexofobject(TObject(MUSIKER_R));
    if (k <> -1) then
      result := CacheMusikerNurNachname[k]
    else
      result := '?';
  end
  else
  begin
    result := '';
  end;
end;

procedure InvalidateCache_Musiker;
begin
  CacheMusikerBirth := 0;
  FreeAndNil(CacheMusiker);
  FreeAndNil(CacheMusikerNachname);
  FreeAndNil(CacheMusikerNurNachname);
end;

procedure EnsureCache_Musiker;
var
  cMUSIKER: TdboCursor;
  RID: integer;
  Kette: string;
  KetteNachname: string;
  KetteNurNachname: string;
  KettenStartL: TList;
  n: integer;

  function strValidate(s: string): string;
  begin
    result := StrFilter(cutblank(s), #13#10#9, true);
  end;

begin
  if frequently(CacheMusikerBirth, CacheMusikerLiveTime) then
  begin
    FreeAndNil(CacheMusiker);
    FreeAndNil(CacheMusikerNachname);
    FreeAndNil(CacheMusikerNurNachname);
    CacheMusiker := TStringList.create;
    CacheMusikerNachname := TStringList.create;
    CacheMusikerNurNachname := TStringList.create;
    cMUSIKER := nCursor;
    with cMUSIKER do
    begin
      // erster Druchlauf "Einzelmusiker"
      sql.add('select RID,VORNAME,NACHNAME,EVL_TRENNER');
      sql.add('from MUSIKER');
      sql.add('where MUSIKER_R is null');
      sql.add('order by NACHNAME');
      ApiFirst;
      while not(eof) do
      begin
        CacheMusiker.AddObject(strValidate(FieldByName('VORNAME').AsString + ' ' + FieldByName('NACHNAME').AsString),
          TObject(FieldByName('RID').AsInteger));

        CacheMusikerNachname.AddObject(strValidate(FieldByName('NACHNAME').AsString + ', ' + FieldByName('VORNAME')
          .AsString), TObject(FieldByName('RID').AsInteger));

        CacheMusikerNurNachname.AddObject(strValidate(FieldByName('NACHNAME').AsString),
          TObject(FieldByName('RID').AsInteger));

        ApiNext;
      end;

      KettenStartL := TList.create;
      // zweiter Durchlauf "Verkettungen"
      close;
      sql.clear;
      // das sind die Anfangs-Punkte der Musiker-Verkettungen
      // Bedingungen: MUSIKER_R hat einen Inhalt
      // auf diesen RID zeigt kein anderer!
      sql.add('select RID from MUSIKER where MUSIKER_R IS NOT NULL and RID NOT IN (select EVL_R from MUSIKER) order by RID');
      ApiFirst;
      while not(eof) do
      begin
        KettenStartL.add(TObject(FieldByName('RID').AsInteger));
        ApiNext;
      end;

      // Jetzt immer die Musiker zusammenstellen!
      // Listbox1.items.beginupdate;
      // Listbox1.items.clear;
      for n := 0 to pred(KettenStartL.count) do
      begin
        Kette := '';
        KetteNachname := '';
        KetteNurNachname := '';
        RID := integer(KettenStartL[n]);
        repeat
          close;
          sql.clear;
          sql.add('select MUSIKER_R,EVL_R,EVL_TRENNER from MUSIKER where RID=' + inttostr(RID));
          ApiFirst;
          Kette := cutblank(Kette + ' ' + e_r_MusikerName(FieldByName('MUSIKER_R').AsInteger) + ' ' +
            FieldByName('EVL_TRENNER').AsString);
          KetteNachname := cutblank(KetteNachname + ' ' + e_r_MusikerNachName(FieldByName('MUSIKER_R').AsInteger) + ' '
            + FieldByName('EVL_TRENNER').AsString);
          KetteNurNachname := cutblank(KetteNurNachname + ' ' + e_r_MusikerNurNachName(FieldByName('MUSIKER_R')
            .AsInteger) + ' ' + FieldByName('EVL_TRENNER').AsString);
          if FieldByName('EVL_R').IsNull then
            break
          else
            RID := FieldByName('EVL_R').AsInteger;
        until eternity;
        CacheMusiker.AddObject(Kette, KettenStartL[n]);
        CacheMusikerNachname.AddObject(KetteNachname, KettenStartL[n]);
        CacheMusikerNurNachname.AddObject(KetteNurNachname, KettenStartL[n]);
        // listbox1.items.addobject(Kette, KettenStartL[n]);
      end;
      // Listbox1.items.endupdate;
      KettenStartL.free;
    end;
    cMUSIKER.free;
  end;
end;

function e_w_Medium: string;
begin
  result := inttostrN(e_w_GEN('GEN_MEDIUM'), 8);
end;

const
  _e_x_ensureMedium_Cache_R: TDOM_Reference = cRID_Null;
  _e_x_ensureMedium_Cache_S: string = '';

function e_x_ensureMedium(Name: string): TDOM_Reference;
begin
  if (Name = _e_x_ensureMedium_Cache_S) then
  begin
    result := _e_x_ensureMedium_Cache_R;
    exit;
  end;

  result := e_r_sql(
    { } 'select RID from MEDIUM where DATEI_ERWEITERUNG=' +
    { } SQLstring(Name));

  if (result < cRID_FirstValid) then
  begin
    e_x_sql(
      { } 'insert into MEDIUM (RID,DATEI_ERWEITERUNG) values (0,' + SQLstring(Name) + ')');
    result := e_x_ensureMedium(Name);
  end;

  _e_x_ensureMedium_Cache_R := result;
  _e_x_ensureMedium_Cache_S := Name;

end;

procedure e_w_MusikerChangeRef(FROM_RID, TO_RID: string);
begin
  e_x_sql('update MUSIKER set EVL_R=NULL where EVL_R=' + FROM_RID);
  e_x_sql('update MUSIKER set MUSIKER_R=' + TO_RID + ' where (MUSIKER_R=' + FROM_RID + ') AND (RID<>' + TO_RID + ')');
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
    if (txt.count > 0) then
      if (txt[pred(txt.count)] <> '') then
        txt.add('');
    txt.add(e_r_MusikerName(RID));
    OneTxt := TStringList.create;
    cMUSIKER := nCursor;
    with cMUSIKER do
    begin
      sql.add('select UEBER_INFO from MUSIKER where RID=' + inttostr(RID));
      ApiFirst;
      e_r_sqlt(FieldByName('UEBER_INFO'), OneTxt);
    end;
    cMUSIKER.free;
    txt.addstrings(OneTxt);
    OneTxt.free;
  end;

var
  cREF: TdboCursor;
begin
  txt := TStringList.create;
  cREF := nCursor;
  with cREF do
  begin
    repeat
      sql.clear;
      sql.add('select MUSIKER_R,EVL_R from MUSIKER where RID=' + inttostr(MUSIKER_R));
      ApiFirst;
      if FieldByName('MUSIKER_R').IsNull then
        AddOne(MUSIKER_R)
      else
        AddOne(FieldByName('MUSIKER_R').AsInteger);
      MUSIKER_R := FieldByName('EVL_R').AsInteger;
      if (MUSIKER_R < 1) then
        break;
      close;
    until eternity;
  end;
  cREF.free;
  result := HugeSingleLine(txt);
  txt.free;
end;

function e_r_MusikerCache: TStringList;
begin
  EnsureCache_Musiker;
  result := CacheMusiker;
end;

function e_r_MusikerGroup(MUSIKER_R: integer): TList;
var
  cREF: TdboCursor;
begin
  result := TList.create;
  cREF := nCursor;
  with cREF do
  begin
    repeat
      sql.clear;
      sql.add('select MUSIKER_R,EVL_R from MUSIKER where RID=' + inttostr(MUSIKER_R));
      ApiFirst;
      if FieldByName('MUSIKER_R').IsNull then
        result.add(TObject(MUSIKER_R))
      else
        result.add(TObject(FieldByName('MUSIKER_R').AsInteger));
      MUSIKER_R := FieldByName('EVL_R').AsInteger;
      if (MUSIKER_R < 1) then
        break;
      close;
    until eternity;
  end;
  cREF.free;
end;

function e_r_MusikerWerke(MUSIKER_R: integer): TList;
var
  cARTIKEL: TdboCursor;
  cREF: TdboCursor;
  lRID: string;
begin
  result := TList.create;

  // Alle RIDs dieses MUSIKERs sammeln
  lRID := inttostr(MUSIKER_R);

  cREF := nCursor;
  with cREF do
  begin
    sql.add('select RID from MUSIKER where MUSIKER_R=' + lRID);
    ApiFirst;
    while not(eof) do
    begin
      lRID := lRID + ',' + inttostr(e_r_MusikerGroupRID(FieldByName('RID').AsInteger));
      ApiNext;
    end;
  end;
  cREF.free;

  //
  cARTIKEL := nCursor;
  with cARTIKEL do
  begin
    sql.add(' select distinct RID from ARTIKEL where');
    sql.add('   KOMPONIST_R IN (' + lRID + ') OR');
    sql.add('   ARRANGEUR_R IN (' + lRID + ')');
    ApiFirst;
    while not(eof) do
    begin
      result.add(TObject(FieldByName('RID').AsInteger));
      ApiNext;
    end;
  end;
  cARTIKEL.free;

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
      sql.clear;
      sql.add('select RID from MUSIKER where EVL_R=' + inttostr(RID));
      ApiFirst;
      if eof then
        break
      else
        RID := FieldByName('RID').AsInteger;
      close;
    until eternity;
  end;
  cREF.free;
  result := RID;
end;

function e_r_MusikerNachnamen: TStringList;
begin
  EnsureCache_Musiker;
  result := CacheMusikerNachname;
end;

function e_w_MusikerCheckCreate(MusikerListe: string): integer;
var
  k: integer;
begin
  EnsureCache_Musiker;
  k := CacheMusiker.indexof(MusikerListe);
  if (k = -1) then
  begin
    result := succ(e_r_GEN('GEN_MUSIKER'));
    e_x_sql('insert into MUSIKER (RID,NACHNAME) values (0,' + '''' + MusikerListe + ''')');
    InvalidateCache_Musiker;
  end
  else
  begin
    result := integer(CacheMusiker.objects[k]);
  end;
end;

procedure InvalidateCache_Laender;
var
  n: integer;
begin
  if assigned(CacheLaender) then
  begin
    for n := 0 to pred(CacheLaender.count) do
      TStringList(CacheLaender.objects[n]).free;
    FreeAndNil(CacheLaender);

    for n := 0 to pred(CacheLaenderFull.count) do
      TStringList(CacheLaenderFull.objects[n]).free;
    FreeAndNil(CacheLaenderFull);
  end;
end;

var
  _AusgabeArt_Aufnahme_MP3: TDOM_Reference = cRID_Unset;

function cAusgabeArt_Aufnahme_MP3: TDOM_Reference;
begin
  if (_AusgabeArt_Aufnahme_MP3 = cRID_Unset) then
  begin
    _AusgabeArt_Aufnahme_MP3 := e_r_sql('select RID from AUSGABEART where KUERZEL=''MP3''');
    if (_AusgabeArt_Aufnahme_MP3 < cRID_FirstValid) then
      _AusgabeArt_Aufnahme_MP3 := cRID_Impossible;
  end;
  result := _AusgabeArt_Aufnahme_MP3;
end;

procedure EnsureCache_Laender;
var
  cLAND: TdboCursor;

  function AddOne: TStringList;
  begin
    result := TStringList.create;
    with cLAND do
    begin
      { [0] }
      result.add(FieldByName('ISO_KURZZEICHEN').AsString);
      { [1] }
      result.add(FieldByName('KURZ_ALT').AsString);
      { [2] }
      result.add(FieldByName('ORT_FORMAT').AsString);
      if (result[2] = '') then
        result[2] := iOrtFormat;
      { [3] }
      result.add(FieldByName('INT_TEXT').AsString);
    end;
  end;

begin
  if not(assigned(CacheLaender)) then
  begin
    CacheLaender := TStringList.create;
    CacheLaenderFull := TStringList.create;

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
      sql.add(' (INTERNATIONALTEXT.LAND_R=' + inttostr(iHeimatLand) + ')');
      ApiFirst;
      while not(eof) do
      begin
        if FieldByName('ARTIKEL_RELEVANT').AsString = 'Y' then
          CacheLaender.AddObject(inttostr(FieldByName('RID').AsInteger), AddOne);
        CacheLaenderFull.AddObject(inttostr(FieldByName('RID').AsInteger), AddOne);
        ApiNext;
      end;
    end;
    cLAND.free;
    CacheLaender.sort;
    CacheLaender.sorted := true;

    CacheLaenderFull.sort;
    CacheLaenderFull.sorted := true;
  end;
end;

function e_r_LaenderRIDfromALT(ALT: string): integer;
var
  n: integer;
begin
  result := cRID_Null;
  EnsureCache_Laender;
  ALT := nextp(ALT, '-');
  for n := 0 to pred(CacheLaender.count) do
    if (TStringList(CacheLaender.objects[n])[1] = ALT) then
    begin
      result := strtoint(CacheLaender[n]);
      break;
    end;
end;

function e_r_LaenderRIDfromISO(ISO: string): integer;
var
  n: integer;
begin
  EnsureCache_Laender;
  for n := 0 to pred(CacheLaender.count) do
    if TStringList(CacheLaender.objects[n])[0] = ISO then
    begin
      result := strtoint(CacheLaender[n]);
      exit;
    end;
  result := -1;
end;

function e_r_LaenderInternational(RID: integer): string;
var
  k: integer;
begin
  EnsureCache_Laender;
  k := CacheLaenderFull.indexof(inttostr(RID));
  if (k <> -1) then
    result := TStringList(CacheLaenderFull.objects[k])[3]
  else
    result := inttostr(RID) + '?';
end;

function e_r_LaenderISO(RID: integer): string;
var
  k: integer;
begin
  EnsureCache_Laender;
  k := CacheLaenderFull.indexof(inttostr(RID));
  if (k <> -1) then
    result := TStringList(CacheLaenderFull.objects[k])[0]
  else
    result := inttostr(RID) + '?';
end;

function e_r_LaenderCache: TStringList;
var
  n: integer;
begin
  EnsureCache_Laender;
  result := TStringList.create;
  for n := 0 to pred(CacheLaender.count) do
    result.add(TStringList(CacheLaender.objects[n])[0]);
  result.sort;
end;

function e_r_LaenderPost(RID: integer): string;
var
  k: integer;
begin
  EnsureCache_Laender;
  k := CacheLaenderFull.indexof(inttostr(RID));
  if (k <> -1) then
    result := TStringList(CacheLaenderFull.objects[k])[1]
  else
    result := inttostr(RID) + '?';
end;

function e_r_LaenderOrtFormat(RID: integer): string;
var
  k: integer;
begin
  EnsureCache_Laender;
  k := CacheLaenderFull.indexof(inttostr(RID));
  if (k <> -1) then
    result := TStringList(CacheLaenderFull.objects[k])[2]
  else
    result := inttostr(RID) + '?';
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

function e_r_ParameterFoto(settings: TStringList; p: string): string;
begin
  result := settings.Values[p + cE_Postfix_Foto];
  if (result = '') then
    result := settings.Values[p];
end;

function e_r_BaustellenPfad(settings: TStrings): String;
begin
  result := settings.Values[cE_VERZEICHNIS];
  if (result = '') then
    result := settings.Values[cE_FTPUSER];
end;

function e_r_BaustellenPfadFoto(settings: TStrings): String;
begin
  repeat

    result := settings.Values[cE_VERZEICHNIS + cE_Postfix_Foto];
    if (result <> '') then
      break;

    result := settings.Values[cE_FTPUSER + cE_Postfix_Foto];
    if (result <> '') then
      break;

    result := settings.Values[cE_VERZEICHNIS];
    if (result <> '') then
      break;

    result := settings.Values[cE_FTPUSER]

  until yet;
end;

{$ifdef FPC}
function cBuildNumber : string;
begin
  result := '0';
end;
{$else}
function cBuildNumber : string;
var
 v : TJclFileVersionInfo;
begin
 v := TJclFileVersionInfo.create( HInstance);
  result := v.FileVersionBuild;
  v.Free;
end;
{$endif}


function e_r_BasePlug: TStringList;
begin
  result := TStringList.create;
  if not(assigned(CacheBasePlug)) then
  begin
    CacheBasePlug := TStringList.create;
    with CacheBasePlug do
    begin
      // ==========================================================
      // ACHTUNG: geht auch über XML-RPC "BasePlug" raus!
      // ACHTUNG: Reihenfolge nicht verändern, nur erweitern!
      // ==========================================================
      { 01 } add(cAppName+' (Build '+cBuildNumber+')');
{$IFDEF CONSOLE}
{$IFDEF fpc}
      { 02 } add('Zeos Rev. ' + fbConnection.Version);
{$ELSE}
      { 02 } add('IBO Rev. ' + fbConnection.Version);
{$ENDIF}
{$ELSE}
      { 02 } add('IBO Rev. ' + Datamoduledatenbank.IB_connection1.Version);
{$ENDIF}
      { 03 } add(gsIdProductName + ' Rev. ' + gsIdVersion);
      { 04 } add(iPDFPathPublicShop);
      { 05 } add(iMusicPathShop);
      { 06 } add(iHTMLPath);
      { 07 } add(iBildURL);
{$IFDEF CONSOLE}
      { 08 } AddObject(
        { } cServerFunctions_Meta_CallCount,
        { } TXMLRPC_Server.oMetaString);
{$ELSE}
      { 08 } add('TPicUpload Rev. ' + TPUMain.REV);
{$ENDIF}
{$IFDEF fpc}
      { 09 } add('fpspreadsheet Rev. ' + 'N/A');
{$ELSE}
      { 09 } add('TMS FlexCel Rev. ' + FlexCelVersion);
{$ENDIF}
{$IFDEF fpc}
      { 10 } add('jcl Rev. N/A');
{$ELSE}
      { 10 } add('jcl Rev. ' + inttostr(JclVersionMajor) + '.' + inttostr(JclVersionMinor));
{$ENDIF}
{$IFDEF CONSOLE}
      { 11 } add('jvcl Rev. N/A');
{$ELSE}
      { 11 } add('jvcl Rev. ' + JVCL_VERSIONSTRING);
{$ENDIF}
      { 12 } add(iShopArtikelBilderURL);
      { 13 } add('infozip Rev. ' + RevToStr(infozip_version) + ' ' + zip_Version);
      { 14 } add('infozip Rev. ' + RevToStr(infozip_version) + ' ' + unzip_Version);
      { 15 } add(
        { } e_r_Kontext + '@' +
        { } ComputerName + ':' +
        { } iXMLRPCPort);
      { 16 } add(
        { } 'memcache Rev. ' +
        { } RevToStr(memcache.Version) + '@' +
        { } imemcachedHost);
      { 17 } add(iDataBaseUser);
      { 18 } add(iDataBasePassword); // connect PWD
      { 19 } add(iDataBase_SYSDBA_pwd); // SYSDBA PWD
      { 20 } add(e_r_fbClientVersion); //
{$IFDEF fpc}
      { 21 } add('Portable Network Graphics Delphi ' + 'N/A');
{$ELSE}
      { 21 } add('Portable Network Graphics Delphi ' + GHD_pngimage.LibraryVersion);
{$ENDIF}
      { 22 } add(iDataBaseHost);
      { 23 } add(i_c_DataBaseFName);
{$IFDEF CONSOLE}
      { 24 } AddObject(
        { } cServerFunctions_Meta_UpTime,
        { } TXMLRPC_Server.oMetaString);
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
  result.Assign(CacheBasePlug);
end;

function e_r_Bearbeiter: integer;
begin
  result := e_r_sql('select RID from BEARBEITER where UPPER(USERNAME)=''' + AnsiUpperCase(UserName) + '''');
end;

function e_r_BearbeiterKuerzel(BEARBEITER_R: integer): string;
begin
  result := e_r_sqls('select KUERZEL from BEARBEITER where RID=' + inttostr(BEARBEITER_R));
end;

var
  DCP_blowfish1: TDCP_Blowfish = nil;

function deCrypt_Hex(s: string): string;
begin
  if not(assigned(DCP_blowfish1)) then
    DCP_blowfish1 := TDCP_Blowfish.create(nil);
  with DCP_blowfish1 do
  begin
    Init(CryptKey, CryptKeyLength, nil);
    result := cutrblank(decryptstring(hexstr2bin(s)));
  end;
end;

function enCrypt_Hex(s: string): string;
begin
  if not(assigned(DCP_blowfish1)) then
    DCP_blowfish1 := TDCP_Blowfish.create(nil);
  with DCP_blowfish1 do
  begin
    Init(CryptKey, CryptKeyLength, nil);
    result := bin2hexstr(encryptstring(s + fill(' ', 16 - length(s))));
  end;
end;

function SysDBApassword: string;
var
  cEINSTELLUNGEN: TdboCursor;
  settings: TStringList;
begin
  cEINSTELLUNGEN := nCursor;
  with cEINSTELLUNGEN do
  begin
    sql.add('select * from EINSTELLUNG');
    ApiFirst;
    settings := TStringList.create;
    e_r_sqlt(FieldByName('SETTINGS'), settings);
    result := settings.Values[cSettings_SysdbaPAssword];
    if (result = '') then
      result := 'masterkey'
    else
      result := deCrypt_Hex(result);
    settings.free;
  end;
  cEINSTELLUNGEN.free;
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
      if not(iOLAPpublic) then
      begin
        CheckCreateDir(iOlapPath);
        FileMove(MyApplicationPath + 'OLAP\*', iOlapPath);
      end;
  end;
end;

function ReadLongStr(BlockName: string; ArtikelInfo: TStringList; delimiter: char = #13): string;
var
  MachineState: byte;
  n, k: integer;
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

function MengeAbschreiben(var GesamtVolumen, AbschreibeMenge: integer): integer;
// Abgeschrieben
var
  Verminderung: integer;
begin
  Verminderung := min(GesamtVolumen, AbschreibeMenge);
  dec(GesamtVolumen, Verminderung);
  dec(AbschreibeMenge, Verminderung);
  result := Verminderung;
end;

procedure e_w_PersonSetPassword(PERSON_R: integer);
begin
  e_x_sql('update PERSON set' +
    { } ' USER_PWD=''' + FindANewPassword + ''',' +
    { } ' USER_SALT=''' + FindANewPassword + '''' +
    { } ' where RID=' + inttostr(PERSON_R));
end;

procedure e_w_PersonEnsurePassword(PERSON_R: integer);
var
  pwd, salt: string;
begin

  // Salt sicherstellen
  salt := e_r_sqls('select USER_SALT from PERSON where RID=' + inttostr(PERSON_R));
  if (salt = '') then
    e_x_sql('update PERSON set USER_SALT=''' + FindANewPassword + ''' where RID=' + inttostr(PERSON_R));

  // Passwort sicherstellen
  pwd := e_r_sqls('select USER_PWD from PERSON where RID=' + inttostr(PERSON_R));
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
        sDir := TStringList.create;
        dir(Path + Numero + '*' + cPDFExtension, sDir, false);
        if (sDir.count = 0) then
        begin

          // 2. Option, Numero ist Bestandteil des Dateinamens <Numero> { "_" <Numero> } ".pdf"
          if not(assigned(e_r_ArtikelPDF_Cache)) then
          begin
            e_r_ArtikelPDF_Cache := TStringList.create;
            dir(Path + '*' + cPDFExtension, e_r_ArtikelPDF_Cache, false);
          end;
          for n := 0 to pred(e_r_ArtikelPDF_Cache.count) do
          begin
            if pos('_' + Numero + '_', e_r_ArtikelPDF_Cache[n]) > 0 then
            begin
              sDir.add ( Path + e_r_ArtikelPDF_Cache[n]);
              continue;
            end;
            if pos('_' + Numero + '.', e_r_ArtikelPDF_Cache[n]) > 0 then
            begin
              sDir.add ( Path + e_r_ArtikelPDF_Cache[n]);
              continue;
            end;
          end;

        end
        else
        begin
          for n := 0 to pred(sDir.count) do
            sDir[n] := Path + sDir[n];
        end;
        result.addstrings(sDir);
        sDir.free;
      end;
  end;

begin
  result := TStringList.create;
  Numero := e_r_sqls('select NUMERO from ARTIKEL where RID=' + inttostr(ARTIKEL_R));
  AddPath(iPDFPathApp);
  AddPath(iPDFPathPublicApp);
end;

procedure e_w_EreignisAbschluss(EREIGNIS_R: integer; INFO: string = '');
begin
  // das Ereignis abzeichnen
  if (INFO <> '') then
    e_x_sql(
      { } 'update EREIGNIS set' +
      { } ' BEARBEITER_R=' + inttostr(sBearbeiter) + ', ' +
      { } ' INFO=''' + INFO + ''' ' +
      { } 'where RID=' + inttostr(EREIGNIS_R))
  else
    e_x_sql(
      { } 'update EREIGNIS set' +
      { } ' BEARBEITER_R=' + inttostr(sBearbeiter) +
      { } 'where RID=' + inttostr(EREIGNIS_R))
end;

function e_r_Person_BLZ_Konto(BLZ, Konto: string): TgpIntegerList;
begin
  result := e_r_sqlm(
    { } 'select RID from PERSON where ' +
    { } '((Z_ELV_KONTO=''' + Konto + ''') and ' +
    { } '(Z_ELV_BLZ=''' + BLZ + ''')) or ' +
    { } '(Z_ELV_KONTO containing ''' + BLZ + inttostrN(Konto, 10) +
    { } ''')');
end;

function e_r_text(RID: integer; LAND_R: integer = 0): TStringList;
var
  cINTERNATIONALTEXT: TdboCursor;
begin
  result := TStringList.create;
  cINTERNATIONALTEXT := nCursor;
  with cINTERNATIONALTEXT do
  begin
    sql.add('SELECT INT_TEXT');
    sql.add('FROM INTERNATIONALTEXT');
    sql.add('WHERE RID=' + inttostr(RID));
    if LAND_R > 0 then
      sql.add('and (LAND_R=' + inttostr(LAND_R) + ')');
    ApiFirst;
    if eof then
    begin
      result.add(inttostr(RID) + '.' + e_r_ObtainISOfromRID(LAND_R));
    end
    else
    begin
      e_r_sqlt(FieldByName('INT_TEXT'), result);
    end;
  end;
  cINTERNATIONALTEXT.free;
end;

function e_r_ObtainISOfromRID(LAND_R: integer): string;
begin
  result := e_r_sqls('select ISO_KURZZEICHEN from LAND where RID=' + inttostr(LAND_R));
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
    sql.add('WHERE RID=' + inttostr(RID) + ' AND');
    sql.add('LAND_R=' + inttostr(LAND_R));
    ApiFirst;
    if eof then
    begin
      result := inttostr(RID) + '.' + e_r_ObtainISOfromRID(LAND_R);
    end
    else
    begin
      InfoText := TStringList.create;
      e_r_sqlt(FieldByName('INT_TEXT'), InfoText);
      if InfoText.count > 0 then
        result := InfoText[0]
      else
        result := '';
      InfoText.free;
    end;
  end;
  cINTERNATIONALTEXT.free;
end;

function e_r_Localize2(RID, LANGUAGE: integer): string;
var
  Land: TdboCursor;
  IntTxt: TdboCursor;
  Bigmemo: TStringList;
begin
  if (RID <= 0) then
  begin
    result := '';
    exit;
  end;
  //
  Bigmemo := TStringList.create;
  Land := nCursor;
  IntTxt := nCursor;
  //
  Land.sql.add('SELECT INT_NAME_R FROM LAND WHERE RID=' + inttostr(RID));
  Land.First;
  IntTxt.sql.add('SELECT INT_TEXT FROM INTERNATIONALTEXT WHERE (RID=' + Land.FieldByName('INT_NAME_R').AsString +
    ') AND (LAND_R=' + inttostr(LANGUAGE) + ')');
  IntTxt.First;
  e_r_sqlt(IntTxt.FieldByName('INT_TEXT'), Bigmemo);
  Bigmemo.add('');
  result := cutblank(Bigmemo[0]);
  //
  Bigmemo.free;
  Land.close;
  Land.free;
  IntTxt.close;
  IntTxt.free;
end;

type
  dbBackupLogCallBack = class (TObject)
    class procedure Log(Sender: TObject; msg: string; IBAdminAction: string);
  end;

class procedure dbBackupLogCallBack.Log(Sender: TObject; msg: string; IBAdminAction: string);
begin
   // Log(msg);
end;

function dbBackup(BackupGID: Integer): boolean;
  const
    cScript_List_Generators =
      'select RDB$GENERATOR_NAME from RDB$GENERATORS where (RDB$SYSTEM_FLAG=0) or (RDB$SYSTEM_FLAG is null)';
  var
    fbak_Full_FName: string;
    fbak_FName: string;
    ResultFName: string;
    CommandLine: string;
    ErrorCount: Integer;
    sGENERATORS: TStringList;
    cGENERATORS: TdboCursor;
    cINDEX: TdboCursor;

    {$ifdef FPC}
    Admin:TFBAdmin;
    {$else}
    rCONNECTION: TIB_Connection;
    rTRANSACTION: TIB_Transaction;
    {$endif}
    GenName: string;
    GenValIst: int64;
    GenValSoll: int64;
    OneLine: string;
    ZipFileList: TStringList;

    procedure Log(s:string);
    begin
    end;


    procedure ReadGenerators;
    begin
      sGENERATORS := TStringList.create;

      try
        Log('###############################');
        Log('# G E N - E V A L U A T I O N #');
        Log('###############################');
        cGENERATORS := nCursor;
        with cGENERATORS do
        begin
          sql.add(cScript_List_Generators);
          ApiFirst;
          while not(eof) do
          begin
            GenName := Fields[0].AsString;
            sGENERATORS.add(GenName + '=' + inttostr(e_r_GEN(GenName)));
            Log(sGENERATORS[pred(sGENERATORS.count)]);
            ApiNext;
          end;
        end;
        cGENERATORS.free;
      except
        on E: Exception do
        begin
          Log(cERRORText + ' IQ-Evaluation Exception: ' + E.Message);
        end;
      end;
    end;

    procedure DoBackup;
    begin
      {$ifdef FPC}
      with Admin do
      {$else}
      with IBOBackupService1 do
      {$endif}
      begin

        {$ifdef FPC}
        Log(Host);
        {$else}
        Log(ServerName);
        {$endif}
        try

          {$ifndef FPC}
          DatabaseName := i_c_DataBaseFName;
          {$endif}


          Log(fbak_Full_FName);
          Log(iTranslatePath + fbak_FName);
          {$ifdef FPC}

          {$else}
          BackupFile.clear;
          BackupFile.add(fbak_Full_FName);
          application.processmessages;
          {$endif}
          Log('###############');
          Log('# B A C K U P #');
          Log('###############');
          Log('läuft ...');
          {$ifdef FPC}
          OnOutput:= dbBackupLogCallBack.Log;
          User := 'SYSDBA';
          Password := SysDBAPassword;
          Connect;
          backup(i_c_DataBaseFName,fbak_Full_FName,[]);
          {$else}
          Active := true;
          ServiceStart;
          repeat
            try
              while not eof do
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
          until eof;
          {$endif}

        finally
         {$ifdef FPC}
         Disconnect;
         {$else}
         Active := false;
         {$endif}
        end;

      end;
    end;

    procedure DoRestore;
    begin
      {$ifdef FPC}
      with Admin do
      {$else}
      with IBORestoreService1 do
      {$endif}
      begin

        try
          {$ifdef FPC}

          {$else}
          PageSize := 16384;
          DatabaseName.clear;
          DatabaseName.add(fbak_Full_FName + '.fdb');
          BackupFile.clear;
          BackupFile.add(fbak_Full_FName);
          application.processmessages;
          {$endif}

          Log('#################');
          Log('# R E S T O R E #');
          Log('#################');
          Log('läuft ...');

          {$ifdef FPC}
          Connect;
          Restore(fbak_Full_FName + '.fdb', fbak_Full_FName, [IBResVerbose, IBResReplace]);
          {$else}
          Active := true;
          ServiceStart;
          repeat
            try
              while not eof do
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
          until eof;
          {$endif}

        finally
         {$ifdef FPC}
         Disconnect;
         {$else}
         Active := false;
         {$endif}
        end;
      end;
    end;

    procedure DoCheckGenerators;
    begin
      Log('#########################');
      Log('# G E N - C O M P A R E #'); // Information Quantity/Quality
      Log('#########################');

      try

        {$ifdef FPC}
        {$else}
        //
        rTRANSACTION := TIB_Transaction.create(self);
        with rTRANSACTION do
        begin
          Isolation := tiCommitted;
          AutoCommit := true;
          ReadOnly := true;
        end;

        //
        rCONNECTION := TIB_Connection.create(self);
        with rCONNECTION do
        begin
          DefaultTransaction := rTRANSACTION;
          LoginDBReadOnly := true;
          Protocol := cpTCP_IP;
          if (iDataBaseHost = '') then
            DatabaseName := fbak_Full_FName + '.fdb'
          else
            DatabaseName := iDataBaseHost + ':' + fbak_Full_FName + '.fdb';
          UserName := 'SYSDBA';
          Password := SysDBAPassword;
        end;

        with rTRANSACTION do
        begin
          IB_Connection := rCONNECTION;
        end;

        rCONNECTION.connect;
        {$endif}


        //
        cGENERATORS := nCursor;
        with cGENERATORS do
        begin
          {$ifdef FPC}
          {$else}
          IB_Connection := rCONNECTION;
          {$endif}
          sql.add(cScript_List_Generators);
          ApiFirst;
          if (RecordCount <> sGENERATORS.count) then
          begin
            Log(cERRORText + ' Anzahl der GENERATORen stimmt nicht!');
          end;

          while not(eof) do
          begin
            GenName := Fields[0].AsString;
            {$ifdef FPC}
            GenValIst := -1;
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
                inttostr(GenValIst) + ' Soll=' + inttostr(GenValSoll));
            end;
            ApiNext;
          end;
        end;
        sGENERATORS.free;
        cGENERATORS.free;

        cINDEX := nCursor;
        with cINDEX do
        begin
          {$ifdef FPC}
          {$else}
          IB_Connection := rCONNECTION;
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
          while not(eof) do
          begin
            Log(
              { } cWARNINGtext +
              { } ' Index ' +
              { } FieldByName('RDB$RELATION_NAME').AsString + '.' +
              { } FieldByName('RDB$INDEX_NAME').AsString +
              { } ' ist nicht aktiv');
            ApiNext;
          end;
        end;
        cINDEX.free;

        {$ifdef FPC}
        {$else}
        rCONNECTION.disconnect;
        rCONNECTION.free;
        rTRANSACTION.free;
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

        ResultFName := DatensicherungPath + fbak_FName + '.zip';

        Log('zip ' + ResultFName + ' ...');

        ZipFileList := TStringList.create;
        ZipFileList.add(DatensicherungPath + fbak_FName);
        FileDelete(ResultFName);
        FileDelete(DatensicherungPath + cZIPTempFileMask);
        if (infozip.zip(ZipFileList, ResultFName) <> 1) then
        begin
          Log(cERRORText + ' zip Archiv sollte eine Datei beinhalten!');
          break;
        end;
        ZipFileList.free;

        // hat das Komprimieren geklappt?
        if not(FileExists(ResultFName)) then
        begin

          Log(cERRORText + ' Archiv ' + ResultFName + ' nicht gefunden!');
          break;
        end;

        // nun das Datenbank-Backup löschen!
        FileDelete(DatensicherungPath + fbak_FName);
        if FileExists(DatensicherungPath + fbak_FName) then
        begin
          Log(cERRORText + ' Datenbank-Datei ' + DatensicherungPath + fbak_FName +
            ' nicht löschbar!');
          break;
        end;

      until true;

    end;

  begin
    result := false;
    if (BackupGID < 0) then exit;
    {$ifndef FPC}
    if assigned(IBC) then exit;
    {$endif}


        ErrorCount := 0;
        fbak_FName := cSicherungsPrefix + inttostrN(BackupGID, 8) + '.fbak';
        Log( 'Datensicherung - ' + inttostr(BackupGID));
        if (iDataBaseBackUpDir = '') then
        begin
          fbak_Full_FName := i_c_DataBasePath + fbak_FName;
        end
        else
        begin
          fbak_Full_FName := iDataBaseBackUpDir + fbak_FName;
        end;


        repeat


          //
          CheckCreateDir(DatensicherungPath);

          if not(CheckBox3.Checked) then
          begin

            ReadGenerators;
            if (ErrorCount > 0) then
              break;

            SetUpService(IBOBackupService1);
            SetUpService(IBORestoreService1);

            // BACKUP
            if not(CheckBox12.Checked) then
            begin
              DoBackup;
              SaveLog;
            end;

            if (ErrorCount > 0) then
              break;
            if CheckBox2.Checked then
              break;

            // ist das Backup angekommen? Prüfen über die Windows-Welt
            if not(FileExists(iTranslatePath + fbak_FName)) then
            begin
              Log(cERRORText + ' Datei ' + iTranslatePath + fbak_FName +
                ' fehlt. FreigabePfad= definieren!');
              break;
            end;

          end;
          SaveLog;
          if (ErrorCount > 0) then
            break;

          if not(CheckBox1.Checked) and not(CheckBox3.Checked) then
          begin

            // restore to proof validty
            DoRestore;
            SaveLog;

            if (ErrorCount > 0) then
              break;

            if not(FileExists(iTranslatePath + fbak_FName + '.fdb')) then
            begin
              Log(cERRORText + ' Datei ' + iTranslatePath + fbak_FName + '.fdb' +
                ' fehlt!');
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
              Log(cERRORText + ' Datei ' + iTranslatePath + fbak_FName + '.fdb' +
                ' nicht löschbar!');
            end;

          end;
          SaveLog;
          if (ErrorCount > 0) then
            break;

          ResultFName := DatensicherungPath + fbak_FName;

          // a) in den Windows Bereich kopieren (falls es nicht schon dort ist!)
          if (iTranslatePath <> DatensicherungPath) then
          begin
            if (Pos(';', iTranslatePath) = 0) then
            begin
              if not(FileExists(DatensicherungPath + fbak_FName)) then
              begin
                Log('mv ' + iTranslatePath + fbak_FName + ' ' + DatensicherungPath
                  + fbak_FName + ' ...');
                FileMove(iTranslatePath + fbak_FName,
                  DatensicherungPath + fbak_FName);
              end;
            end
            else
            begin
              SolidInit(IdFTP1);
              with IdFTP1 do
              begin
                Host := nextp(iTranslatePath, ';', 0);
                UserName := nextp(iTranslatePath, ';', 1);
                Password := nextp(iTranslatePath, ';', 2);
              end;
              SolidGet(IdFTP1, nextp(iTranslatePath, ';', 3), fbak_FName,'',
                DatensicherungPath, true);
            end;
          end;
          SaveLog;

          // Existenz der Ergebnisdatei prüfen!
          if not(FileExists(DatensicherungPath + fbak_FName)) then
          begin
            Log(cERRORText + ' Datei ' + DatensicherungPath + fbak_FName +
              ' nicht gefunden!');
            break;
          end;

          // b) im Windows Bereich komprimieren!
          doCompress;

        until true;
        SaveLog;

        // FTP Upload?
        if CheckBox1.Checked and (ErrorCount = 0) then
        begin
          Log('FTP Upload ...');

          CheckBox1.Checked := false;
          doUpload(ResultFName);
        end;
        SaveLog;


        // Ergebnis!
        if (ErrorCount = 0) then
        begin
          Log('Erfolgreich beendet');
          result := true;
          close;
        end
        else
        begin
          Log('Es gab Fehler!');
        end;
        SaveLog;

      end;

end;

const
  cKey = 'anfisoft' + cApplicationName;

begin

  // Verschlüsselungs Namespace
  CryptKey := cKey;
  CryptKeyLength := length(cKey) * 8;

{$IFDEF CONSOLE}
{$IFDEF fpc}
  // fbTransaction := TZTransaction.create;
  fbConnection := TZConnection.create(nil);
  with fbConnection do
  begin
    ClientCodePage := 'ISO8859_1';
    ControlsCodePage := cCP_UTF8;
    Protocol := 'firebird-2.5';
    TransactIsolationLevel := tiReadCommitted;

  end;
{$ELSE}
  // Datenbank - Zugriffselemente erzeugen!
  fbSession := TIB_Session.create(nil);
  fbTransaction := TIB_Transaction.create(nil);
  fbConnection := TIB_Connection.create(nil);

  with fbSession do
  begin
    AllowDefaultConnection := true;
    AllowDefaultTransaction := true;
    DefaultConnection := fbConnection;
    StoreActive := false;
    UseCursor := false;
  end;

  with fbConnection do
  begin
    IB_Session := fbSession;
    CacheStatementHandles := false;
    DefaultTransaction := fbTransaction;
    SQLDialect := 3;
    ParameterOrder := poNew;
    CharSet := 'NONE';
  end;

  with fbTransaction do
  begin
    IB_Session := fbSession;
    IB_Connection := fbConnection;
    ServerAutoCommit := true;
    Isolation := tiCommitted;
    RecVersion := true;
    LockWait := true;
  end;
{$ENDIF}
{$ENDIF}

end.
