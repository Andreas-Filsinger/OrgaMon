{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2012 - 2018  Andreas Filsinger
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
unit Funktionen_LokaleDaten;

interface

uses
  SysUtils, Classes, ContextBase;

{
  Erzeugt und speichert 2 Dateien: "*.Cache.Items" und "*.Cache.Values",
  diese können dann von anderen Programmteilen verwendet werden. Tagesabschluss
  oder spezielle Ereignisse im OrgaMon erzwingen die Neubildung dieser Dateien.
}

// Cache Datei-Namen
function Sortiment(Purge: boolean = false): string;
function Laender(Purge: boolean = false): string;
function Kreative(Purge: boolean = false): string;
function VertragsVarianten(Purge: boolean = false): string;

// einmalige (pro Programmlauf) Überprüfung von Dateipfaden
// incl. automatischer Erstellung falls noch nicht angelegt!
procedure CheckCreateOnce(sPath: string);

// Alle Caches löschen und somit Neuerstellung erzwingen
procedure ReBuild;

// Suchindex Cache neu erstellen
procedure PersonSuchindex;
procedure ArtikelSuchindex;

// Kartenverzeichnis auf Quota bringen
procedure KartenQuota;

var
 cnPERSON, cnBELEG, cnBAUSTELLE: TContext;

implementation

uses
  Globals, Anfix32,
{$IFNDEF fpc}
  IB_Components,
{$ENDIF}
  dbOrgaMon, Funktionen_Basis, gplists,
{$IFNDEF CONSOLE}
  Datenbank,
{$ENDIF}
  Funktionen_Auftrag,
  Funktionen_Buch,
  wordindex;

const
  AlreadyCheckedPath: TStringList = nil;

procedure CheckCreateOnce(sPath: string);
var
  MustReallyCheck: boolean;
begin
  MustReallyCheck := true;
  repeat

    if not(assigned(AlreadyCheckedPath)) then
    begin
      AlreadyCheckedPath := TStringList.create;
      break;
    end;

    if (AlreadyCheckedPath.indexof(sPath) = -1) then
      break;

    MustReallyCheck := false;

  until yet;
  if MustReallyCheck then
  begin
    CheckCreateDir(sPath);
    AlreadyCheckedPath.add(sPath);
  end;
end;

function Kreative(Purge: boolean): string;
var
  cache: TStringList;
  n: integer;
  AusgabeItems: TStringList;
  AusgabeValues: TStringList;
begin
  if Purge then
  begin
    InvalidateCache_Musiker;
    FileDelete(SearchDir + cKreativeCacheFName + cItemsCacheFExtension);
    FileDelete(SearchDir + cKreativeCacheFName + cValueCacheFExtension);
    result := '';
  end
  else
  begin
    if not(FileExists(SearchDir + cKreativeCacheFName + cItemsCacheFExtension)) or
      not(FileExists(SearchDir + cKreativeCacheFName + cValueCacheFExtension)) then
    begin
      AusgabeItems := TStringList.create;
      AusgabeValues := TStringList.create;
      AusgabeItems.add(cRefComboOhneEintrag);
      AusgabeValues.add('');
      cache := e_r_MusikerNachnamenKommaVornamen;
      for n := 0 to pred(cache.count) do
      begin
        AusgabeItems.add(cache[n]);
        AusgabeValues.add(inttostr(integer(cache.objects[n])));
      end;
      AusgabeItems.SaveToFile(SearchDir + cKreativeCacheFName + cItemsCacheFExtension);
      AusgabeValues.SaveToFile(SearchDir + cKreativeCacheFName + cValueCacheFExtension);
      AusgabeItems.free;
      AusgabeValues.free;
    end;
    result := SearchDir + cKreativeCacheFName;
  end;
end;

function Laender(Purge: boolean): string;
var
  AusgabeItems: TStringList;
begin
  //
  if Purge then
  begin
    FileDelete(SearchDir + cLaenderCacheFName);
    result := '';
  end
  else
  begin
    if not(FileExists(SearchDir + cLaenderCacheFName)) then
    begin
      AusgabeItems := e_r_LaenderCache;
      AusgabeItems.SaveToFile(SearchDir + cLaenderCacheFName);
      AusgabeItems.free;
    end;
    result := SearchDir + cLaenderCacheFName;
  end;
end;

procedure PersonSuchindex;
var
  SpeedIndex: TWordIndex;
  cPERSON: TdboCursor;
  cANSCHRIFT: TdboCursor;
begin

  SpeedIndex := TWordIndex.create(nil);
  cPERSON := nCursor;
  cANSCHRIFT := nCursor;

  // ANSCHRIFT SQL
  with cANSCHRIFT do
  begin
    sql.add('select');
    sql.add(' NAME1,');
    sql.add(' NAME2,');
    sql.add(' STRASSE,');
    sql.add(' STATE,');
    sql.add(' PLZ,');
    sql.add(' LAND_R,');
    sql.add(' ORT,');
    sql.add(' ORTSTEIL');
    sql.add('from');
    sql.add(' ANSCHRIFT');
    sql.add('where');
    sql.add(' RID=:CROSSREF');
  end;

  // PERSON SQL
  with cPERSON do
  begin
    sql.add('select');
    sql.add(' RID,');
    sql.add(' VORNAME,');
    sql.add(' NACHNAME,');
    sql.add(' SUCHBEGRIFF,');
    sql.add(' KUERZEL,');
    sql.add(' MONDA,');
    sql.add(' PRIV_ANSCHRIFT_R,');
    sql.add(' NUMMER,');
    sql.add(' Z_ELV_KONTO_INHABER,');
    sql.add(' Z_ELV_BLZ,');
    sql.add(' Z_ELV_KONTO,');
    sql.add(' KONTO_ER,');
    sql.add(' KONTO_AR,');
    sql.add(' HANDY');
    sql.add('from');
    sql.add(' PERSON');
    APIFirst;
    while not(eof) do
    begin
      with cANSCHRIFT do
      begin
        ParamByName('CROSSREF').AsInteger := cPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsInteger;
        if not(Active) then
          Open;
        APIFirst;
        if not(eof) then
        begin

          SpeedIndex.AddWords(
            // PERSON Felder
            { } cPERSON.FieldByName('VORNAME').AsString + ' ' +
            { } cPERSON.FieldByName('NACHNAME').AsString + ' ' +
            { } cPERSON.FieldByName('SUCHBEGRIFF').AsString + ' ' +
            { } cPERSON.FieldByName('KUERZEL').AsString + ' ' +
            { } cPERSON.FieldByName('MONDA').AsString + ' ' +
            { } cPERSON.FieldByName('NUMMER').AsString + ' ' +
            { } cPERSON.FieldByName('Z_ELV_KONTO_INHABER').AsString + ' ' +
            { } Bank_IDs(cPERSON.FieldByName('Z_ELV_BLZ').AsString) + ' ' +
            { } Bank_IDs(cPERSON.FieldByName('Z_ELV_KONTO').AsString) + ' ' +
            { } IBAN_BLZ_Konto(
            { } cPERSON.FieldByName('Z_ELV_KONTO').AsString) + ' ' +
            { } cPERSON.FieldByName('KONTO_ER').AsString + ' ' +
            { } cPERSON.FieldByName('KONTO_AR').AsString + ' ' +
            { } strFilter(cPERSON.FieldByName('HANDY').AsString, cZiffern) + ' ' +

            // ANSCHRIFT Felder
            { } FieldByName('NAME1').AsString + ' ' +
            { } FieldByName('NAME2').AsString + ' ' +
            { } FieldByName('STRASSE').AsString + ' ' +
            { } FieldByName('PLZ').AsString + ' ' +
            { } FieldByName('ORT').AsString + ' ' +
            { } FieldByName('ORTSTEIL').AsString + ' ' +
            { } FieldByName('STATE').AsString,

            TObject(cPERSON.FieldByName('RID').AsInteger)

            );
        end;
      end;
      ApiNext;
    end;
  end;
  cANSCHRIFT.free;
  cPERSON.free;

  SpeedIndex.JoinDuplicates(false);
  SpeedIndex.SaveToFile(SearchDir + 'Kunden' + c_wi_FileExtension);
  SpeedIndex.free;
end;

procedure PersonSuchindexX;
var
  SpeedIndex: TWordIndex;
begin
  SpeedIndex := TWordIndex.create(nil);
//  SpeedIndex.AddWords('Antonín Dvorák Über', TObject(33) );
//  SpeedIndex.AddWords('Über Unter', TObject(44) );
{$H-}
SpeedIndex.AddWords('ü', TObject(44) );
{$H+}
  SpeedIndex.JoinDuplicates(false);
  SpeedIndex.SaveToFile(SearchDir + 'Kunden' + c_wi_FileExtension);
  SpeedIndex.free;
end;

procedure ReBuild;
begin
  Sortiment(true);
  Laender(true);
  Kreative(true);
  VertragsVarianten(true);
  ReCreateAktiveBaustellen;
  FreeAndNil(AlreadyCheckedPath);
end;

function Sortiment(Purge: boolean): string;
var
  cSORTIMENT: TdboCursor;
  AusgabeItems: TStringList;
  AusgabeValues: TStringList;
begin
  if Purge then
  begin
    FileDelete(SearchDir + cSortimentCacheFName + cItemsCacheFExtension);
    FileDelete(SearchDir + cSortimentCacheFName + cValueCacheFExtension);
    result := '';
  end
  else
  begin
    if not(FileExists(SearchDir + cSortimentCacheFName + cItemsCacheFExtension)) or
      not(FileExists(SearchDir + cSortimentCacheFName + cValueCacheFExtension)) then
    begin
      AusgabeItems := TStringList.create;
      AusgabeValues := TStringList.create;
      cSORTIMENT := nCursor;
      with cSORTIMENT do
      begin
        sql.add('select s.rid,s.bezeichnung,m.satz from sortiment S');
        sql.add('join Mwst M on s.MWST_R=m.RID');
        sql.add('order by S.bezeichnung');
        APIFirst;
        while not(eof) do
        begin
          AusgabeItems.add(format('%s (%.2f%% MwSt)', [FieldByName('BEZEICHNUNG').AsString,
            FieldByName('SATZ').AsFloat]));
          AusgabeValues.add(FieldByName('RID').AsString);
          ApiNext;
        end;
      end;
      cSORTIMENT.free;
      AusgabeItems.SaveToFile(SearchDir + cSortimentCacheFName + cItemsCacheFExtension);
      AusgabeValues.SaveToFile(SearchDir + cSortimentCacheFName + cValueCacheFExtension);
      AusgabeItems.free;
      AusgabeValues.free;
    end;
    result := SearchDir + cSortimentCacheFName;
  end;
end;

function VertragsVarianten(Purge: boolean): string;
var
  cVertragsVarianten: TdboCursor;
  AusgabeItems: TStringList;
  AusgabeValues: TgpIntegerList;
begin
  if Purge then
  begin
    FileDelete(SearchDir + cVertragsVariantenCacheFName + cItemsCacheFExtension);
    FileDelete(SearchDir + cVertragsVariantenCacheFName + cValueCacheFExtension);
    result := '';
  end
  else
  begin
    if not(FileExists(SearchDir + cVertragsVariantenCacheFName + cItemsCacheFExtension)) or
      not(FileExists(SearchDir + cVertragsVariantenCacheFName + cValueCacheFExtension)) then
    begin
      AusgabeItems := TStringList.create;
      AusgabeValues := TgpIntegerList.create;
      cVertragsVarianten := nCursor;
      with cVertragsVarianten do
      begin
        // Hier ein SYSTEM-OLAP laden?
        sql.add('select MOTIVATION,RID from BELEG');
        sql.add('where RID in (select distinct BELEG_R from VERTRAG)');
        sql.add('order by MOTIVATION');
        APIFirst;
        while not(eof) do
        begin
          AusgabeItems.add(FieldByName('MOTIVATION').AsString);
          AusgabeValues.add(FieldByName('RID').AsInteger);
          ApiNext;
        end;
      end;
      cVertragsVarianten.free;
      AusgabeItems.SaveToFile(SearchDir + cVertragsVariantenCacheFName + cItemsCacheFExtension);
      AusgabeValues.SaveToFile(SearchDir + cVertragsVariantenCacheFName + cValueCacheFExtension);
      AusgabeItems.free;
      AusgabeValues.free;
    end;
    result := SearchDir + cVertragsVariantenCacheFName;
  end;
end;

procedure KartenQuota;
begin
  if (iKartenPfad <> '') and (iKartenQuota > 0) then
    DirQuota(iKartenPfad + '*.png', iKartenQuota);
end;

procedure ArtikelSuchindex;
var
  ArtikelInfo: TStringList;
  cARTIKEL: TdboCursor;
  WebShopRedList: TgpIntegerList;
  s: string;
  n: integer;
  SearchIndex: TWordIndex;

  // cache
  ARTIKEL_R : integer;

  // verschiedene Suchstrings
  ArtikelContext1: string;
  ArtikelContext2: string;

  // die verschiedenen OLAPs für die verschiedenen Name-Spaces
  OLAPs: TStringList;
  RIDs: TList;
  SearchIndexs: TList;

  function ReadLongStr(BlockName: string): string;
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
          k := pos('=', ArtikelINfo[n]);
          if (k = 0) or (k > 11) then
            result := result + #13 + ArtikelInfo[n]
          else
            exit;
        end;
      end;
    end;
  end;

begin

  ArtikelInfo := TStringList.create;
  OLAPs := TStringList.create;
  RIDs := TList.create;
  SearchIndexs := TList.create;
  cARTIKEL := nCursor;
  SearchIndex := TWordIndex.create(nil);

  // OLAPs ausführen!
  dir(iSystemOLAPPath+'System.WebShop.*'+cOLAPExtension,OLAPs,false);
  for n := 0 to pred(OLAPs.count) do
  begin
    RIDs.add(e_r_OLAP(iSystemOLAPPath+OLAPs[n]));
    SearchIndexs.add(TWordIndex.create(nil));
  end;

  // den Namespace extrahieren!
  ersetze('System.WebShop.','',OLAPs);
  ersetze(cOLAPExtension,'',OLAPs);

  // den Namespace "abu" erzwingen!
  if (OLAPs.indexof('abu')=-1) then
  begin
    OLAPs.add('abu');
    RIDs.add(e_r_sqlm('select RID from ARTIKEL'));
    SearchIndexs.add(TWordIndex.create(nil));
  end;

  // Verbot für den WebShop "rote Liste"
  WebShopRedList := e_r_sqlm(
   {} 'select '+
   {} ' ARTIKEL.RID '+
   {} 'from '+
   {} ' ARTIKEL '+
   {} 'where '+
   {} ' (ARTIKEL.WEBSHOP=''N'') or '+
   {} ' (ARTIKEL.SORTIMENT_R in ('+
   {} 'select RID from SORTIMENT where WEBSHOP=''N'''+
    ')) ');


  with cARTIKEL do
  begin
    sql.add('SELECT');
    sql.add(' RID,INTERN_INFO,TITEL,VERLAG_R,');
    sql.add(' KOMPONIST_R,ARRANGEUR_R,CODE,');
    sql.add(' NUMERO,VERLAGNO,SORTIMENT_R,LAUFNUMMER,');
    sql.add(' WEBSHOP,GEMA_WN,GTIN');
    sql.add('FROM');
    sql.add(' ARTIKEL');
    sql.add('WHERE');
    sql.add(' PAKET_R IS NULL');
    APIfirst;
    while not (eof) do
    begin

      ARTIKEL_R := FieldByName('RID').AsINteger;


      e_r_sqlt(FieldByName('INTERN_INFO'), ArtikelInfo);

      // Grundvolumen aller Clients
      S :=
        FieldByName('TITEL').AsString + ' ' +
        e_r_Verlag_PERSON_R(FieldByName('VERLAG_R').AsInteger) + ' ' +
        e_r_MusikerName(FieldByName('KOMPONIST_R').AsInteger) + ' ' +
        e_r_MusikerName(FieldByName('ARRANGEUR_R').AsInteger) + ' ' +
        FieldByName('GEMA_WN').AsString + ' ' +
        FieldByName('GTIN').AsString;

      // intern "vollumfänglich"
      ArtikelContext1 :=
        S + ' ' +
        FieldByName('CODE').AsString + ' ' +
        FieldByName('NUMERO').AsString + ' ' +
        FieldByName('VERLAGNO').AsString + ' ' +
        StrFilter(FieldByName('VERLAGNO').AsString,c_wi_WhiteSpace,true) + ' ' +
        '~' + FieldByName('SORTIMENT_R').AsString + 's ' +
        ArtikelInfo.Values['SERIE'] + ' ' +
        ReadLongStr('BEM') + ' ' +
        ArtikelInfo.Values['GATTUNG'];

      // extern "teilinfo"
      ArtikelContext2 :=
        S + ' ' +
        FieldByName('LAUFNUMMER').AsString;

      SearchIndex.AddWords(ArtikelContext1, TObject(ARTIKEL_R));

      // ist die Aufnahme des Artikels in den WebShop OK?
      if (WebShopRedList.indexof(ARTIKEL_R)=-1) then
      begin

        // alle OLAPs durchlaufen und Wortlisten aufbauen ...
        for n := 0 to pred(OLAPs.count) do
          if (TgpIntegerList(RIDs[n]).IndexOf(ARTIKEL_R)<>-1) then
          begin
            if (pos('2',OLAPs[n])>0) then
              TWordIndex(SearchIndexs[n]).AddWords(ArtikelContext2, TObject(ARTIKEL_R))
            else
              TWordIndex(SearchIndexs[n]).AddWords(ArtikelContext1, TObject(ARTIKEL_R));
          end;

      end;

      ApiNext;

    end;
  end;

  cARTIKEL.Free;
  ArtikelInfo.free;

  // Suchindex "intern"
  SearchIndex.JoinDuplicates(false);
  SearchIndex.SaveToFile(SearchDir + format(cArtikelSuchindexFName,[cArtikelSuchindexIntern]));
  SearchIndex.free;

  // die anderen Suchindizes speichern
  for n := 0 to pred(OLAPs.Count) do
  begin
    with TWordIndex(SearchIndexs[n]) do
    begin
      JoinDuplicates(false);
      SaveToFile(SearchDir + format(cArtikelSuchindexFName,[OLAPs[n]]));
    end;
    TWordIndex(SearchIndexs[n]).free;
    TgpIntegerList(RIDs[n]).free;
  end;

  // Free
  RIDs.free;
  OLAPs.free;
  SearchIndexs.free;
end;

begin
  cnPERSON := TContext.create(ContextPath + 'Person');
  cnBELEG := TContext.create(ContextPath + 'Beleg');
  cnBAUSTELLE := TContext.create(ContextPath + 'Baustelle');
end.
