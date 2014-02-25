{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2012  Andreas Filsinger
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
  SysUtils, Classes;

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
procedure Rebuild;

// Suchindex Cache neu erstellen
procedure PersonSuchindex;

implementation

uses
  Globals, Anfix32, IB_Components,
  dbOrgaMon,Funktionen_Basis, gplists,
{$IFNDEF CONSOLE}
  Datenbank,
{$ENDIF}
  Funktionen_Auftrag, wordindex;

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

  until true;
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
    FileDelete(SearchDir + cKreativeCacheFName + cItemsCacheFExtension);
    FileDelete(SearchDir + cKreativeCacheFName + cValueCacheFExtension);
    result := '';
  end
  else
  begin
    if not(FileExists(SearchDir + cKreativeCacheFName + cItemsCacheFExtension))
      or not(FileExists(SearchDir + cKreativeCacheFName + cValueCacheFExtension))
    then
    begin
      AusgabeItems := TStringList.create;
      AusgabeValues := TStringList.create;
      AusgabeItems.add(cRefComboOhneEintrag);
      AusgabeValues.add('');
      cache := e_r_MusikerNachnamen;
      for n := 0 to pred(cache.count) do
      begin
        AusgabeItems.add(cache[n]);
        AusgabeValues.add(inttostr(integer(cache.objects[n])));
      end;
      AusgabeItems.SaveToFile(SearchDir + cKreativeCacheFName +
        cItemsCacheFExtension);
      AusgabeValues.SaveToFile(SearchDir + cKreativeCacheFName +
        cValueCacheFExtension);
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
  cPERSON: TIB_Cursor;
  cANSCHRIFT: TIB_Cursor;
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
    sql.add(' ORT');
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
    sql.Add(' HANDY');
    sql.add('from');
    sql.add(' PERSON');
    APIFirst;
    while not(eof) do
    begin
      with cANSCHRIFT do
      begin
        ParamByName('CROSSREF').AsInteger :=
          cPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsInteger;
        if not(Active) then
          Open;
        APIFirst;
        if not(eof) then
        begin

          SpeedIndex.AddWords(
            // PERSON Felder
            cPERSON.FieldByName('VORNAME').AsString + ' ' +
            cPERSON.FieldByName('NACHNAME').AsString + ' ' +
            cPERSON.FieldByName('SUCHBEGRIFF').AsString + ' ' +
            cPERSON.FieldByName('KUERZEL').AsString + ' ' +
            cPERSON.FieldByName('MONDA').AsString + ' ' +
            cPERSON.FieldByName('NUMMER').AsString + ' ' +
            cPERSON.FieldByName('Z_ELV_KONTO_INHABER').AsString + ' ' +
            noblank(cPERSON.FieldByName('Z_ELV_BLZ').AsString +
            cPERSON.FieldByName('Z_ELV_KONTO').AsString) + ' ' +
            cPERSON.FieldByName('KONTO_ER').AsString + ' ' +
            cPERSON.FieldByName('KONTO_AR').AsString + ' ' +
            strFilter(cPERSON.FieldByName('HANDY').AsString,cZiffern) + ' ' +
            // ANSCHRIFT Felder
            FieldByName('NAME1').AsString + ' ' + FieldByName('NAME2').AsString
            + ' ' + FieldByName('STRASSE').AsString + ' ' + FieldByName('PLZ')
            .AsString + ' ' + FieldByName('ORT').AsString + ' ' +
            FieldByName('STATE').AsString,

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

procedure Rebuild;
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
  cSORTIMENT: TIB_Cursor;
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
    if not(FileExists(SearchDir + cSortimentCacheFName + cItemsCacheFExtension))
      or not(FileExists(SearchDir + cSortimentCacheFName +
      cValueCacheFExtension)) then
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
          AusgabeItems.add(format('%s (%.2f%% MwSt)',
            [FieldByName('BEZEICHNUNG').AsString,
            FieldByName('SATZ').AsDouble]));
          AusgabeValues.add(FieldByName('RID').AsString);
          Apinext;
        end;
      end;
      cSORTIMENT.free;
      AusgabeItems.SaveToFile(SearchDir + cSortimentCacheFName +
        cItemsCacheFExtension);
      AusgabeValues.SaveToFile(SearchDir + cSortimentCacheFName +
        cValueCacheFExtension);
      AusgabeItems.free;
      AusgabeValues.free;
    end;
    result := SearchDir + cSortimentCacheFName;
  end;
end;

function VertragsVarianten(Purge: boolean): string;
var
  cVertragsVarianten: TIB_Cursor;
  AusgabeItems: TStringList;
  AusgabeValues: TgpIntegerList;
begin
  if Purge then
  begin
    FileDelete(SearchDir + cVertragsVariantenCacheFName +
      cItemsCacheFExtension);
    FileDelete(SearchDir + cVertragsVariantenCacheFName +
      cValueCacheFExtension);
    result := '';
  end
  else
  begin
    if not(FileExists(SearchDir + cVertragsVariantenCacheFName +
      cItemsCacheFExtension)) or
      not(FileExists(SearchDir + cVertragsVariantenCacheFName +
      cValueCacheFExtension)) then
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
          Apinext;
        end;
      end;
      cVertragsVarianten.free;
      AusgabeItems.SaveToFile(SearchDir + cVertragsVariantenCacheFName +
        cItemsCacheFExtension);
      AusgabeValues.SaveToFile(SearchDir + cVertragsVariantenCacheFName +
        cValueCacheFExtension);
      AusgabeItems.free;
      AusgabeValues.free;
    end;
    result := SearchDir + cVertragsVariantenCacheFName;
  end;
end;

end.
