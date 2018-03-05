{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2017  Andreas Filsinger
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

{$ifdef fpc}
{$mode delphi}
{$endif}


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


{ Datenbank }
function SysDBApassword: string;

function dbBackup(BackupGID: integer): boolean;
// Erstellt und prüft ein Backup der aktuellen Datenbank


function ReadLongStr(BlockName: string; ArtikelInfo: TStringList;
  delimiter: char = #13): string;
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
function e_r_BaustellenPfadFoto(settings: TStrings): string;
function e_r_BaustellenPfad(settings: TStrings): string;

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

function enCrypt_Hex(s: string): string;
function deCrypt_Hex(s: string): string;
procedure MigrateFrom(BringTo: integer);

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

function PruefZiffer(n : int64):byte;
function PruefZifferOK(zahl: Int64): Boolean;


procedure EnsureCache_Musiker;
procedure EnsureCache_Laender;


implementation

uses
  Math, SysUtils,
  DCPcrypt2, DCPblockciphers, DCPblowfish,
  WordIndex,
  anfix32, dbOrgaMon, SimplePassword,

  // wegen der Versionsnummern
{$IFDEF fpc}
  ZClasses,
  ZConnection,
  ZCompatibility,
  ZDbcIntfs,
  ZSequence,
  IB, IBServices, IBVersion,
{$ELSE}
  JclFileUtils,
  FlexCel.Core,
  CCR.Exif.Consts,
  GHD_pngimage,
  JclBase,
  IBOServices,
  IB_Session,
{$ENDIF}
{$IFNDEF CONSOLE}
  Datenbank,
  TPUMain,
  JvclVer,
{$ENDIF}
  idglobal,
  IdStack, IdComponent, IdFTP, solidFTP,
  InfoZIP,
  srvXMLRPC,
  memcache;

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

  { Pwd Crypt }
  CryptKeyLength: integer = 0;

var
  CryptKey: array [0 .. 1023] of AnsiChar;


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
    KettenStartL := e_r_sqlm('select RID from MUSIKER where MUSIKER_R IS NOT NULL and RID NOT IN (select EVL_R from MUSIKER where EVL_R is not null) order by RID');

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
    sql.add(' select distinct RID from ARTIKEL where');
    sql.add('   KOMPONIST_R IN (' + lRID + ') OR');
    sql.add('   ARRANGEUR_R IN (' + lRID + ')');
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

function e_r_ParameterFoto(settings: TStringList; p: string): string;
begin
  Result := settings.Values[p + cE_Postfix_Foto];
  if (Result = '') then
    Result := settings.Values[p];
end;

function e_r_BaustellenPfad(settings: TStrings): string;
begin
  Result := settings.Values[cE_VERZEICHNIS];
  if (Result = '') then
    Result := settings.Values[cE_FTPUSER];
end;

function e_r_BaustellenPfadFoto(settings: TStrings): string;
begin
  repeat

    Result := settings.Values[cE_VERZEICHNIS + cE_Postfix_Foto];
    if (Result <> '') then
      break;

    Result := settings.Values[cE_FTPUSER + cE_Postfix_Foto];
    if (Result <> '') then
      break;

    Result := settings.Values[cE_VERZEICHNIS];
    if (Result <> '') then
      break;

    Result := settings.Values[cE_FTPUSER]

  until yet;
end;

{$ifdef FPC}
function cBuildNumber: string;
begin
  Result := '0';
end;

{$else}
function cBuildNumber: string;
var
  v: TJclFileVersionInfo;
begin
  v := TJclFileVersionInfo.Create(HInstance);
  Result := v.FileVersionBuild;
  v.Free;
end;

{$endif}


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
      { 01 } add(cAppName + ' (Build ' + cBuildNumber + ')');
{$IFDEF CONSOLE}
{$IFDEF fpc}
      { 02 } add('Zeos Rev. ' + ZEOS_VERSION);
{$ELSE}
      { 02 } add('IBO Rev. ' + fbConnection.Version);
{$ENDIF}
{$ELSE}
      { 02 } add('IBO Rev. ' + Datamoduledatenbank.IB_connection1.Version);
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
      { 08 } add('TPicUpload Rev. ' + TPUMain.REV);
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
{$IFDEF CONSOLE}
      { 11 } add('jvcl Rev. N/A');
{$ELSE}
      { 11 } add('jvcl Rev. ' + JVCL_VERSIONSTRING);
{$ENDIF}
      { 12 } add(iShopArtikelBilderURL);
      { 13 } add('infozip Rev. ' + RevToStr(infozip_version) + ' ' + zip_Version);
      { 14 } add('infozip Rev. ' + RevToStr(infozip_version) + ' ' + unzip_Version);
      { 15 } add(
        e_r_Kontext + '@' + ComputerName + ':' + iXMLRPCPort);
      { 16 } add(
        'memcache Rev. ' + RevToStr(memcache.Version) + '@' +
        imemcachedHost);
      { 17 } add(iDataBaseUser);
      { 18 } add(iDataBasePassword); // connect PWD
      { 19 } add(iDataBase_SYSDBA_pwd); // SYSDBA PWD
      { 20 } add(e_r_fbClientVersion);
{$IFDEF fpc}
      { 21 } add('Portable Network Graphics Delphi ' + 'N/A');
{$ELSE}
      { 21 } add('Portable Network Graphics Delphi ' + GHD_pngimage.LibraryVersion);
{$ENDIF}
      { 22 } add(iDataBaseHost);
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

var
  DCP_blowfish1: TDCP_Blowfish = nil;

function deCrypt_Hex(s: string): string;
begin
  if not (assigned(DCP_blowfish1)) then
    DCP_blowfish1 := TDCP_Blowfish.Create(nil);
  with DCP_blowfish1 do
  begin
    Init(CryptKey, CryptKeyLength, nil);
    Result := cutrblank(decryptstring(hexstr2bin(s)));
  end;
end;

function enCrypt_Hex(s: string): string;
begin
  if not (assigned(DCP_blowfish1)) then
    DCP_blowfish1 := TDCP_Blowfish.Create(nil);
  with DCP_blowfish1 do
  begin
    Init(CryptKey, CryptKeyLength, nil);
    Result := bin2hexstr(encryptstring(s + fill(' ', 16 - length(s))));
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
    settings := TStringList.Create;
    e_r_sqlt(FieldByName('SETTINGS'), settings);
    Result := settings.Values[cSettings_SysdbaPAssword];
    if (Result = '') then
      Result := 'masterkey'
    else
      Result := deCrypt_Hex(Result);
    settings.Free;
  end;
  cEINSTELLUNGEN.Free;
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
  IntTxt.sql.add('SELECT INT_TEXT FROM INTERNATIONALTEXT WHERE (RID=' +
    Land.FieldByName('INT_NAME_R').AsString + ') AND (LAND_R=' +
    IntToStr(LANGUAGE) + ')');
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

function dbBackup(BackupGID: integer): boolean;

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
  FTP: TIdFTPRestart;
  FTP_StartOffset: int64;

  {$ifdef FPC}
  svcBackup: TIBBackupService;
  svcRestore: TIBRestoreService;
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
        DiagnosePath + 'Datensicherung-' + inttostrN(BackupGID, 8) + '.log.txt');
      sBericht.Clear;
    end;
  end;

  {$ifndef FPC}
  procedure SetUpService(dbService: TIBOBackupRestoreService);
  {$else}
  procedure SetUpService(dbService: TIBBackupRestoreService);
  {$endif}
  begin
    with dbService do
    begin
      ServerName := iDataBaseHost;
{$ifdef FPC}
    if (iDataBaseHost = '') then
      Protocol := IB.local
    else
      Protocol := IB.TCP;
{$else}
      if (iDataBaseHost = '') then
        Protocol := cpLocal
      else
        Protocol := cpTCP_IP;
{$endif}
      LoginPrompt := False;
      Params.Values['user_name'] := 'SYSDBA';
      Params.Values['password'] := SysDBAPassword;
      Verbose := True;
    end;
  end;

  function doUpload(ResultFName: string): boolean;
  var
    FtpDestFName: string;
    rSize: int64;
    lSize: int64;
  begin

    Result := False;
    lSize := FSize(ResultFName);
    SolidInit(FTP);
    with FTP do
    begin

      Host := cFTP_Host;
      UserName := cFTP_UserName;
      Password := cFTP_Password;

      try

        if connected then
        begin
          try
            Abort;
          except

            on E: EIdSocketError do
            begin
              solidLog(cEXCEPTIONText + ' [DaSi-1254] Socket Error: ' +
                IntToStr(E.LastError));
            end;

            on E: Exception do
            begin
              solidLog(cEXCEPTIONText + ' [DaSi-1254] ' + E.Message);
            end;

          end;
        end;

        connect;

        // atomic.begin
        FtpDestFName := ExtractFileName(ResultFName);
        repeat

          rSize := Size(FtpDestFName + cTmpFileExtension);
          if rSize = lSize then
            break;
          if rSize > lSize then
            raise Exception.Create('FTP: remote Datei ist ' +
              IntToStr(rSize - lSize) + ' Bytes grösser als die lokale');

          if (rSize < 1) then
          begin
            FTP_StartOffset := 0;
            Put(ResultFName, FtpDestFName + cTmpFileExtension);
          end
          else
          begin
            FTP_StartOffset := rSize;
            PutRestart(ResultFName, FtpDestFName + cTmpFileExtension, rSize);
          end;

        until True;

        rSize := Size(FtpDestFName + cTmpFileExtension);
        if (lSize = rSize) then
        begin
          if (Size(FtpDestFName) >= 0) then
            Delete(FtpDestFName);
          Rename(FtpDestFName + cTmpFileExtension, FtpDestFName);
          Result := True;
        end
        else
        begin
          if (rSize > lSize) then
            raise Exception.Create('FTP: remote Datei ist ' +
              IntToStr(rSize - lSize) + ' Bytes grösser als die lokale')
          else
            raise Exception.Create('FTP: remote Datei ist ' +
              IntToStr(lSize - rSize) + ' Bytes kleiner als die lokale');
        end;
        // atomic.end
        try
          disconnect;
        except
          on E: EIdSocketError do
          begin
            solidLog(cEXCEPTIONText + ' [DaSi-1315] Socket Error: ' +
              IntToStr(E.LastError));
          end;

          on E: Exception do
          begin
            solidLog(cEXCEPTIONText + ' [DaSi-1321] ' + E.Message);
          end;
        end;
      except
        on E: EIdSocketError do
        begin
          solidLog(cEXCEPTIONText + ' [DaSi-1327] Socket Error: ' +
            IntToStr(E.LastError));
        end;

        on E: Exception do
        begin
          solidLog(cEXCEPTIONText + ' [DaSi-1327] ' + E.Message);
        end;
        on E: Exception do
        begin
          Log(cERRORText + ' Ftp Upload Error: ' + E.Message);
        end;
      end;
    end;
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

    end;
  end;

  procedure DoRestore;
  begin
    with svcRestore do
    begin

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
          HostName := iDataBaseHost;
          Database := fbak_Full_FName + '.fdb';
          Password := SysDBAPassword;
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

      ResultFName := DatensicherungPath + fbak_FName + '.zip';

      Log('zip ' + ResultFName + ' ...');

      ZipFileList := TStringList.Create;
      ZipFileList.add(DatensicherungPath + fbak_FName);
      FileDelete(ResultFName);
      FileDelete(DatensicherungPath + cZIPTempFileMask);
      if (InfoZIP.zip(ZipFileList, ResultFName) <> 1) then
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

    until True;

  end;

begin
  Result := False;
  if (BackupGID < 0) then
    exit;

  if not (assigned(cConnection)) then
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
      svcBackup := TIBBackupService.Create(nil);
      svcRestore := TIBRestoreService.Create(nil);
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
    begin
      if (Pos(';', iTranslatePath) = 0) then
      begin
        if not (FileExists(DatensicherungPath + fbak_FName)) then
        begin
          Log('mv ' + iTranslatePath + fbak_FName + ' ' +
            DatensicherungPath + fbak_FName + ' ...');
          FileMove(iTranslatePath + fbak_FName,
            DatensicherungPath + fbak_FName);
        end;
      end
      else
      begin
        SolidInit(FTP);
        with FTP do
        begin
          Host := nextp(iTranslatePath, ';', 0);
          UserName := nextp(iTranslatePath, ';', 1);
          Password := nextp(iTranslatePath, ';', 2);
        end;
        SolidGet(FTP, nextp(iTranslatePath, ';', 3), fbak_FName, '',
          DatensicherungPath, True);
      end;
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

  until True;
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

//Errechnet eine Prüfziffer nach Modula 10
//(c) Frank Rosendahl

function modula10(zahl: Int64): Int64;
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
  //Prüft mit Hilfe von "modula10", ob die letzte
  //(rechte) Stelle als Prüfziffer korrekt ist.
begin
  //letzte Stelle Abschneiden und Prüfziffer errechnen,
  //dann mit letzter Stelle der übergebenen Zahl vergleichen
  Result := modula10(trunc(zahl / 10)) = zahl - (trunc(zahl / 10) * 10);
end;

function PruefZiffer(n : int64):byte;
begin
  result := modula10(n);
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
  fbConnection := TZConnection.Create(nil);
  with fbConnection do
  begin
    ClientCodePage := 'ISO8859_1';
    ControlsCodePage := cCP_UTF8;
    Protocol := 'firebird-2.5';
    TransactIsolationLevel := tiReadCommitted;

  end;
{$ELSE}
  // Datenbank - Zugriffselemente erzeugen!
  fbSession := TIB_Session.Create(nil);
  fbTransaction := TIB_Transaction.Create(nil);
  fbConnection := TIB_Connection.Create(nil);

  with fbSession do
  begin
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
