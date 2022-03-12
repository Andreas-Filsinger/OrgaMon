{
  |������___                  __  __
  |�����/ _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |����| | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |����| |_| | | | (_| | (_| | |  | | (_) | | | |
  |�����\___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |���������������|___/
  |
  |    Copyright (C) 2012 - 2020  Andreas Filsinger
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

{$ifdef fpc}
{$mode delphi}
{$endif}

interface

uses
  SysUtils, Classes,
  anfix, ContextBase;

{
  Erzeugt und speichert 2 Dateien: "*.Cache.Items" und "*.Cache.Values",
  diese k�nnen dann von anderen Programmteilen verwendet werden. Tagesabschluss
  oder spezielle Ereignisse im OrgaMon erzwingen die Neubildung dieser Dateien.
}

// Erstellt ein ZIP des OrgaMon-Verzeichnisses
function SicherungDateisystem(BackupGID: Integer; fb : TFeedBack = nil): boolean;

// Cache Datei-Namen
function Sortiment(Purge: boolean = false): string;
function Laender(Purge: boolean = false): string;
function Kreative(Purge: boolean = false): string;
function VertragsVarianten(Purge: boolean = false): string;

// einmalige (pro Programmlauf) �berpr�fung von Dateipfaden
// incl. automatischer Erstellung falls noch nicht angelegt!
procedure CheckCreateOnce(sPath: string);

// Alle Caches l�schen und somit Neuerstellung erzwingen
procedure ReBuild;

// Suchindex Cache neu erstellen
procedure PersonSuchindex;
procedure ArtikelSuchindex;

// Kartenverzeichnis auf Quota bringen
procedure KartenQuota;
procedure SicherungenQuota;

var
 cnPERSON, cnBELEG, cnBAUSTELLE: TContext;

implementation

uses
  Math, Globals,
{$IFNDEF fpc}
  IB_Components,
{$ENDIF}
  c7zip, dbOrgaMon, CareTakerClient, gplists,
{$IFNDEF CONSOLE}
  Datenbank,
{$ENDIF}
  Funktionen_Basis,
  Funktionen_Artikel,
  Funktionen_OLAP,
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
    sql.add(' HANDY,');
    sql.add(' VERSICHERUNGSNUMMER');
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
            { } cPERSON.FieldByName('VERSICHERUNGSNUMMER').AsString + ' ' +
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
//  SpeedIndex.AddWords('Anton�n Dvor�k �ber', TObject(33) );
//  SpeedIndex.AddWords('�ber Unter', TObject(44) );
{$H-}
SpeedIndex.AddWords('�', TObject(44) );
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
        sql.add('select RID,BEZEICHNUNG,MWST_NAME from SORTIMENT');
        sql.add('order by BEZEICHNUNG');
        APIFirst;
        while not(eof) do
        begin
          AusgabeItems.add(format('%s (%.1f%% MwSt)', [
            {} FieldByName('BEZEICHNUNG').AsString,
            {} e_r_Prozent(FieldByName('MWST_NAME').AsString)]));
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

const
 Phasen = 'TWMQY';
 PhaseT = 0;
 PhaseW = 1;
 PhaseM = 2;
 PhaseQ = 3;
 PhaseY = 4;

 PhaseSizeEternal = -1;
 PhaseSizeUnwanted = 0;

type
 TPhase = class(TObject)
            NewestDate, OldestDate: TAnfixDate;
            ZipCount: Integer;
            function typical(d:TANfixDate):TAnfixDate; virtual; abstract;
            function next(d:TANfixDate):TAnfixDate; virtual; abstract;
            function prev(d:TANfixDate):TAnfixDate; virtual; abstract;
            function Id: String; virtual; abstract;

            function promote(PERFECT:TsTable;d:TAnfixDate): TAnfixDate;
            constructor Create(oldest, newest: TAnfixDate; count:Integer);
          end;

 TPhaseT = class(TPhase)
            function typical(d:TANfixDate):TAnfixDate; override;
            function next(d:TANfixDate):TAnfixDate; override;
            function prev(d:TANfixDate):TAnfixDate; override;
            function Id: String; override;
           end;

 TPhaseW = class(TPhase)
            function typical(d:TANfixDate):TAnfixDate; override;
            function next(d:TANfixDate):TAnfixDate; override;
            function prev(d:TANfixDate):TAnfixDate; override;
            function Id: String; override;
           end;

 TPhaseM = class(TPhase)
            function typical(d:TANfixDate):TAnfixDate; override;
            function next(d:TANfixDate):TAnfixDate; override;
            function prev(d:TANfixDate):TAnfixDate; override;
            function Id: String; override;
           end;

 TPhaseQ = class(TPhase)
            function typical(d:TANfixDate):TAnfixDate; override;
            function next(d:TANfixDate):TAnfixDate; override;
            function prev(d:TANfixDate):TAnfixDate; override;
            function Id: String; override;
           end;

 TPhaseY = class(TPhase)
            function typical(d:TANfixDate):TAnfixDate; override;
            function next(d:TANfixDate):TAnfixDate; override;
            function prev(d:TANfixDate):TAnfixDate; override;
            function Id: String; override;
           end;

 constructor TPhase.Create(oldest, newest: TAnfixDate; count: Integer);
 begin
  inherited Create;
  OldestDate := oldest;
  NewestDate := newest;
  ZipCount := count;
 end;

 function TPhase.promote(PERFECT:TsTable;d:TAnfixDate): TAnfixDate;
 var
  protegeDate, exitDate: TANfixDate;
  n : Integer;
 begin
   if (ZipCount<>PhaseSizeUnwanted) then
   begin
     d := typical(d);

     // Trage die Proteg�s ein
     protegeDate := d;
     repeat
      protegeDate := next(protegeDate);
      if (protegeDate>NewestDate) then
       break
      else
       PERFECT.AddRow(split(Long2date(protegeDate)+';'+Id+';0'));
     until eternity;

     if (ZipCount=PhaseSizeEternal) then
     begin
       exitDate := typical(OldestDate);
       n := 1;
       repeat
        PERFECT.AddRow(split(Long2date(d)+';'+Id+';'+IntToStr(n)));
        inc(n);
        d := prev(d);
       until (d<exitDate);
     end else
     begin
       for n := 1 to ZipCount do
       begin
        PERFECT.AddRow(split(Long2date(d)+';'+Id+';'+IntToStr(n)));
        if (n<ZipCount) then
          d := prev(d)
        else
          d := DatePlus(d,-1);
       end;
     end;
   end;
   result := d;
 end;

 function TPhaseT.Id: String;
 begin
   result := 'T';
 end;

 function TPhaseT.typical(d: Integer): TAnfixDate;
 begin
  result := d;
 end;

 function TPhaseT.next(d: Integer): TAnfixDate;
 begin
  result := DatePlus(d,1);
 end;

 function TPhaseT.prev(d: Integer): TAnfixDate;
 begin
  result := DatePlus(d,-1);
 end;

 function TPhaseW.Id: String;
 begin
   result := 'W';
 end;

  function TPhaseW.typical(d:TANfixDate): TAnfixDate;
  begin
    if (WeekDay(d)<>cDATE_SONNTAG) then
      result := DatePlus(d,-WeekDay(d))
    else
      result := d;
  end;

  function TPhaseW.next(d:TANfixDate): TAnfixDate;
  begin
    result := DatePlus(d,7);
  end;

  function TPhaseW.prev(d:TANfixDate): TAnfixDate;
  begin
    result := DatePlus(d,-7)
  end;

 function TPhaseM.Id: String;
 begin
   result := 'M';
 end;

  function TPhaseM.typical(d:TANfixDate): TAnfixDate;
  begin
    result := ThisMonth(d);
  end;

  function TPhaseM.next(d:TANfixDate): TAnfixDate;
  begin
    result := NextMonth(d);
  end;

  function TPhaseM.prev(d:TANfixDate): TAnfixDate;
  begin
    result := PrevMonth(d);
  end;

 function TPhaseQ.Id: String;
 begin
   result := 'Q';
 end;

  function TPhaseQ.typical(d:TANfixDate): TAnfixDate;
  begin
    result := ThisQuartal(d);
  end;

  function TPhaseQ.next(d:TANfixDate): TAnfixDate;
  begin
    result := NextQuartal(d);
  end;

  function TPhaseQ.prev(d:TANfixDate): TAnfixDate;
  begin
    result := PrevQuartal(d);
  end;

 function TPhaseY.Id: String;
 begin
   result := 'Y';
 end;

  function TPhaseY.typical(d:TANfixDate): TAnfixDate;
  begin
    result := ThisYear(d);
  end;

  function TPhaseY.next(d:TANfixDate): TAnfixDate;
  begin
    result := NextYear(d);
  end;

  function TPhaseY.prev(d:TANfixDate): TAnfixDate;
  begin
    result := PrevYear(d);
  end;

procedure SicherungenQuota;
const
 cTestFName = 'R:\Kundendaten\FKD\Bug-DaSi\dasi.csv';

 function LogFName : string;
 begin
   result :=
    { } DiagnosePath +
    { } 'SICHERUNGEN-QUOTA-' +
    { } e_r_Kontext + '-' +
    { } DatumLog +
    { } cLogExtension;
 end;

var
 T : TPhaseT;
 W : TPhaseW;
 M : TPhaseM;
 Q : TPhaseQ;
 Y : TPhaseY;
 PhaseSize: array of Integer;
 ParseStr, PhaseSingle: String;
 PhaseNo, n: Integer;
 PhaseMax: Integer;
 AnzahlMax: Integer;
 REALITY, PERFECT: TsTable;
 r, r2, rBest: Integer;
 NewestDate, OldestDate: TAnfixDate;
 d,  ProtegeDate, ExitDate: TAnfixDate;
 dd, ddBest: Integer;
 sDir : TStringList;
begin
  // �berhaupt Sicherungen gew�nscht?
  if (iSicherungenAnzahl=cIni_DeActivate) then
    exit;

  // Parameter nach "PhaseSize" parsen
  PhaseMax := length(Phasen);
  SetLength(PhaseSize, PhaseMax);
  ParseStr := iSicherungenAnzahl;
  PhaseNo := PhaseT;
  while (ParseStr<>'') do
  begin
    PhaseSingle := noblank(nextp(ParseStr,','));
    if (PhaseSingle='*') then
     PhaseSize[PhaseNo] := PhaseSizeEternal
    else
     PhaseSize[PhaseNo] := StrToIntDef(PhaseSingle,0);

    inc(PhaseNo);
    if (PhaseNo=PhaseMax) then
     break;
  end;
  for n := PhaseNo to pred(PhaseMax) do
    PhaseSize[n] := PhaseSizeUnwanted;

  // keinerlei Beschr�nkung
  if (PhaseSize[PhaseT]=PhaseSizeEternal) then
    exit;

  // Erlaubte Datei-Anzahl bestimmen
  AnzahlMax := 0;
  for n := PhaseT to PhaseY do
  case PhaseSize[n] of
    PhaseSizeEternal : inc(AnzahlMax); // "1" for "*"
    PhaseSizeUnwanted :;
  else
   inc(AnzahlMax, PhaseSize[n]);
  end;

  // nur einfache "T"- Beschr�nkung auf AnzahlMax, -> ganz einfacher Fall
  if (PhaseSize[PhaseT]=AnzahlMax) then
  begin
    // runterl�schen bis auf n-1 damit f�r die neue
    // Sicherung Platz ist
    sDir := TStringList.Create;
    FileDeleteUntil(
      { } iSicherungsPfad + iSicherungsPreFix + '*' + cZIPExtension,
      { } pred(AnzahlMax),
      { } sDir);
    if (sDir.Count>1) then
      sDir.SaveToFile(LogFName);
    sDir.Free;
    exit;
  end;

  // Verzeichnis-Info laden
  REALITY := nil;
  repeat
   if assigned(REALITY) then
    REALITY.Free;

   REALITY := TsTable.Create;
   with REALITY do
   begin

     if TestMode then
     begin
       insertFromFile(cTestFName);
       if not(isHeader('FILE')) then
       begin
         insert(0,split('FILE;SIZE;DATE'));
         SaveToFile(cTestFName);
         Continue;
       end;
       addCol('DELETE');
     end else
     begin
       sDir := TStringList.create;
       dir(iSicherungsPfad + iSicherungsPreFix + '*' + cZIPExtension,sDir,false);
       addCol('FILE');
       addCol('DATE');
       addCol('DELETE');
       for n := 0 to pred(sDir.Count) do
        addRow(split(
         {} sDir[n]+';'+
         {} Long2date(FDate(iSicherungsPfad+sDir[n]))+';'));
       SortBy('date DATE');
     end;
     if DebugMode then
       SaveToFile(DiagnosePath+'dasi-0.csv');

     PERFECT := TsTable.Create;
     PERFECT.addCol('DATE');
     PERFECT.addCol('PHASE');
     PERFECT.addCol('NUMBER');
     PERFECT.addCol('FILE');
     PERFECT.addCol('DISTANCE');

     OldestDate := Date2Long(readCell(1,'DATE'));
     NewestDate := Date2Long(readCell(RowCount,'DATE'));

     // Entwickeln der perfekten Sicherungsreihe
     // Richtung
     d := NewestDate;

     T := TPhaseT.Create(OldestDate, NewestDate, PhaseSize[PhaseT]);
     W := TPhaseW.Create(OldestDate, NewestDate, PhaseSize[PhaseW]);
     M := TPhaseM.Create(OldestDate, NewestDate, PhaseSize[PhaseM]);
     Q := TPhaseQ.Create(OldestDate, NewestDate, PhaseSize[PhaseQ]);
     Y := TPhaseY.Create(OldestDate, NewestDate, PhaseSize[PhaseY]);

     d := T.promote(PERFECT,d);
     d := W.promote(PERFECT,d);
     d := M.promote(PERFECT,d);
     d := Q.promote(PERFECT,d);
     d := Y.promote(PERFECT,d);

     Y.Free;
     Q.Free;
     M.Free;
     W.Free;
     T.Free;

     PERFECT.SortBy(split('descending date DATE'));
     PERFECT.aggregate('DATE');

     // REALITY nun mit PERFECT abgleichen

     // a) alle Volltreffer eintragen
     for r := 1 to REALITY.RowCount do
     begin
       r2 := PERFECT.locate('DATE',REALITY.readCell(r,'DATE'));
       if (r2<>-1) then
       begin
         PERFECT.writeCell(r2,'FILE',REALITY.readCell(r,'FILE'));
         PERFECT.writeCell(r2,'DISTANCE','0');
       end;
     end;

     if DebugMode then
       PERFECT.SaveToFile(DiagnosePath+'perfect-1.csv');

     // b) alle Unscharfen eintragen (nearest fit best!)
     for r := 1 to PERFECT.RowCount do
     begin
       d := date2long(PERFECT.readCell(r,'DATE'));
       if not(DateOk(d)) then
        break;
       if (PERFECT.readCell(r,'FILE')='') then
       begin
         ddBest := MaxInt;
         rBest := -1;

         // suche den kleinsten Abstand
         for r2 := RowCount downto 1 do
         begin
           dd := DateDiff(d,date2long(readCell(r2,'DATE')));

           // Abwertung bei Sicherungen davor, "danach" ist besser
           // Davor-Sicherungen haben das Problem, da ist noch nicht alles
           // Passiert was man ev. haben will
           if (dd<0) then
            dd := dd - 2;

           if (abs(dd)<ddBest) then
           begin
             ddBest := abs(dd);
             rBest := r2;
           end;
         end;

         // entscheide Dich f�r den Besten
         if (rBest<>-1) then
         begin
          PERFECT.writeCell(r,'FILE',readCell(rBest,'FILE'));
          PERFECT.writeCell(r,'DISTANCE',IntToStr(ddBest)+' ('+readCell(rBest,'DATE')+')');
         end;
       end;
     end;

     if DebugMode then
       PERFECT.SaveToFile(DiagnosePath+'perfect-2.csv');

     // c) Erstelle die L�schliste
     for r := RowCount downto 1 do
      if (PERFECT.locate('FILE',readCell(r,'FILE'))<>-1) then
        // hier noch Amnestie-Pr�fung?
          del(r);
     if DebugMode then
       SaveToFile(DiagnosePath+'dasi-1.csv');

     // d) L�sche aber nur bis PERFECT.count - PERFECT.files also
     //    wenn das Volumen noch nicht ausgesch�pft ist, kann er
     //    aktuelle Sicherungen noch unberechtigt behalten, also beim
     //    L�schen: alte Sicherungen zuerst.
     r2 := max(0,AnzahlMax - PERFECT.distinct('FILE'));
     for r := 1 to RowCount-r2 do
       writeCell(r,'DELETE',cIni_Activate);
     if DebugMode then
       SaveToFile(DiagnosePath+'dasi-2.csv');

     // e) Jetzt die echte L�schung
      // delete the File
  //      FileDelete(readcell(r,'FILE'));
     if not(TestMode) then
     begin
       n := 0;
       for r := 1 to RowCount do
         if (readCell(r,'DELETE')=cIni_Activate) then
         begin
           if FileDelete(iSicherungsPfad+readCell(r,'FILE')) then
             writeCell(r,'DELETE','DELETED');
           inc(n);
         end;
       if (n>0) then
        SaveToFile(LogFName);
     end;
     PERFECT.Free;
   end;
   break;
  until eternity;
  REALITY.Free;
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

  // die verschiedenen OLAPs f�r die verschiedenen Name-Spaces
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

  // OLAPs ausf�hren!
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

  // Verbot f�r den WebShop "rote Liste"
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

      ARTIKEL_R := FieldByName('RID').AsInteger;

      e_r_sqlt(FieldByName('INTERN_INFO'), ArtikelInfo);

      // Grundvolumen aller Clients
      S :=
        FieldByName('TITEL').AsString + ' ' +
        e_r_Verlag_PERSON_R(FieldByName('VERLAG_R').AsInteger) + ' ' +
        e_r_MusikerName(FieldByName('KOMPONIST_R').AsInteger) + ' ' +
        e_r_MusikerName(FieldByName('ARRANGEUR_R').AsInteger) + ' ' +
        FieldByName('GEMA_WN').AsString + ' ' +
        FieldByName('GTIN').AsString;

      // intern "vollumf�nglich"
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

function SicherungDateisystem(BackupGID: Integer; fb : TFeedBack = nil): boolean;

{$I feedback.inc}

var
  DestFName, TmpFName: string;
  DestFiles: TStringList;
  n: Integer;
  ArchiveFSize: int64;
  ArchiveFiles: Integer;
  zipOptions: TStringList;

  procedure Log(s: string);
  begin
    _(cFeedBack_ListBox_add+2,s);
    _(cFeedBack_ProcessMessages);
  end;

begin
  ArchiveFiles := 0;
  result := false;
  if (BackupGID >= 0) then
  begin
    _(cFeedBack_ListBox_clear+2);
    _(cFeedBack_ProgressBar_Position+1);

    CheckCreateOnce(iSicherungsPfad);
    CheckCreateOnce(EigeneOrgaMonDateienPfad);

    if not(DirExists(iSicherungsPfad)) then
      raise Exception.create('Gesamtsicherung: Verzeichnis "' + iSicherungsPfad
        + '" existiert nicht');

    DestFName := iSicherungsPfad + iSicherungsPreFix + inttostrN(BackupGID, 8);
    Log('Endziel: ' + DestFName);

    if iSicherungLokalesZwischenziel then
    begin
      TmpFName :=
       { } EigeneOrgaMonDateienPfad +
       { } iSicherungsPreFix +
       { } inttostrN(BackupGID, 8);
      Log('Zwischenziel: ' + TmpFName);
      // alte zip-Fragmente entfernen
      FileDelete(EigeneOrgaMonDateienPfad + '*' + cTmpFileExtension);
    end else
    begin
      Log('kein Zwischenziel!');
      TmpFName := DestFName;
      // alte zip-Fragmente entfernen
      FileDelete(iSicherungsPfad + '*' + cTmpFileExtension);
    end;

    // Platz schaffen
    SicherungenQuota;

    // ZIP
    zipOptions := TStringList.create;
    zipOptions.values[czip_set_RootPath] := MyProgramPath;
    _(cFeedBack_ProgressBar_Max+1,'100');
    _(cFeedBack_ProgressBar_Position+1,'50');

    ArchiveFiles := zip(nil, TmpFName + cTmpFileExtension, zipOptions);
    zipOptions.free;

    _(cFeedBack_ProgressBar_Position+1);
    Log('Archiv mit ' + inttostr(ArchiveFiles) + ' Dateien erzeugt');

    if (ArchiveFiles = 0) then
      raise Exception.create('Gesamtsicherung: Archiv ist leer');

    // Nun vom lokalen Pfad auf das Sicherungsmedium kopieren!
    if (DestFName = TmpFName) then
    begin
      Log('Archiv wird umbenannt!');

      // Einfach nur umbenennen
      if not(RenameFile(
        {} TmpFName + cTmpFileExtension,
        {} DestFName + cZIPExtension)) then
        raise Exception.create('Gesamtsicherung: Umbenennen nicht m�glich');

    end
    else
    begin
      Log('Archiv wird umkopiert!');

      // Schreibbarkeit zun�chst mal auf Medium testen!
      FileDelete(DestFName + cTmpFileExtension);
      if FileExists(DestFName + cTmpFileExtension) then
        raise Exception.create('Gesamtsicherung: Verzeichnis "' +
          iSicherungsPfad + '" ist schreibgesch�tzt');
      FileAlive(DestFName + cTmpFileExtension);
      if not(FileExists(DestFName + cTmpFileExtension)) then
        raise Exception.create('Gesamtsicherung: Verzeichnis "' +
          iSicherungsPfad + '" ist schreibgesch�tzt');
      FileDelete(DestFName + cTmpFileExtension);
      if FileExists(DestFName + cTmpFileExtension) then
        raise Exception.create('Gesamtsicherung: Verzeichnis "' +
          iSicherungsPfad + '" ist schreibgesch�tzt');

      // Nun draufkopieren
      if not(FileMove(
        {} TmpFName + cTmpFileExtension,
        {} DestFName + cZIPExtension)) then
        raise Exception.create(
         {} 'Gesamtsicherung: Verschieben von '+
         {} '"' + TmpFName + cTmpFileExtension + '"'+
         {} ' nach '+
         {} '"' + DestFName + cZIPExtension + '"' +
         {} ' nicht m�glich');

    end;

    // Pr�fung, ob was angekommen
    DestFiles := TStringList.create;
    dir(DestFName + '*', DestFiles, false);
    ArchiveFSize := 0;
    for n := 0 to pred(DestFiles.count) do
      inc(ArchiveFSize, FSize(ExtractFilePath(DestFName) + DestFiles[n]));
    DestFiles.free;

    Log('Archiv hat ' + inttostr(ArchiveFSize DIV 1024 DIV 1024) +
      ' MByte(s)!');

    if (ArchiveFSize <= 0) then
    begin
      raise Exception.create('Gesamtsicherung: "' + DestFName + '" ist leer');
    end
    else
    begin
      Log('Erfolgreich beendet');
      result := true;
    end;

    _(cFeedBack_ProgressBar_Position+1);
  end;
end;

begin
  cnPERSON := TContext.create(ContextPath +  'Person');
  cnBELEG := TContext.create(ContextPath + 'Beleg');
  cnBAUSTELLE := TContext.create(ContextPath + 'Baustelle');
end.
