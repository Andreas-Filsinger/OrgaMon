{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2022  Andreas Filsinger
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
unit Funktionen_Transaktion;

{$ifdef fpc}
{$mode delphi}
{$endif}

interface

uses
 // System
 SysUtils, Classes,

 // anfix
 gplists, anfix;

// doBO1 - Caching - Elemente
const
 BO1_RechercheList : TStringList = nil;

procedure doHA12(AuchZaehlerStaende: boolean);

//
// Transaktionen: Dies sind Kundenprogrammierungen, die es
// in den festen Transaktions-Umfang des OrgaMon geschafft
// haben.
//

// (c) Corinna Haag 2012

// Ableseergebnisse aus .csv lesen und eintragen (mit Zählerstand)
procedure doHA1;

// Ableseergebnisse aus .csv lesen und eintragen (ohne Zählerstand)
procedure doHA2;

// aus den Interninfos diverse felder rauslöschen!
procedure doHA3(lRID: TgpIntegerList);

// EXPORT_TAN löschen
procedure doHA4(lRID: TgpIntegerList);

// EXPORT_TAN setzen (auf manuelle Meldung)
procedure doHA5(lRID: TgpIntegerList);

// aus den Zaehler_infos Werte in Feld BRIEF_NAME2 übertragen
procedure doHA6(lRID: TgpIntegerList);

// Beurteilung via QS und Ergebnis in "Jahresverbrauch"
procedure doHA7(lRID: TgpIntegerList);

// QS deaktivieren durch Eintrag von "QS_UMGANGEN"
procedure doHA8(lRID: TgpIntegerList);

// Ablesehinweise und Vorgezogen aktualisieren
procedure doHA9(lRID: TgpIntegerList);

// alle Markieren, die in externer XLS Liste vorhanden sind "Bericht.xls"
procedure doHAA(lRID: TgpIntegerList; fb : TFeedback);

// IDOC Schreibweisen in den InternInfos anpassen
procedure doHAB(lRID: TgpIntegerList);

// bei "Sparte=Einbau" wird FA=, gemacht
procedure doHAC(lRID: TgpIntegerList);

// (c) Andreas Filsinger

// FA= im Protokoll einfach setzen auf <ZaehlerNummerAlt>.jpg
procedure doFI1(lRID: TgpIntegerList);

// cOrgaMon Id "App": Log Dateien auswerten und "Calls" in die Artikel eintragen
procedure doFI2(lRID: TgpIntegerList);

// (c) Sengül Aynaci 2012

// imp pend: Move "TFormAuftragArbeitsplatz.doAynaci1" to doAY1
// imp pend: Move "TFormAuftragArbeitsplatz.doAynaci2" to doAY2

// Daten aus den Historischen rücksichern
procedure doAY3(lRID: TgpIntegerList);

// Daten aus den Historischen rücksichern
procedure doAY4(lRID: TgpIntegerList);

// Ein Bilder.zip im Anwenderverzeichnis zusammenstellen
procedure doAY5(lRID: TgpIntegerList);

// (c) Saskia Ahrens 2012

// EXPORT*xml überprüfen
procedure doAH1(lRID: TgpIntegerList);

// "Monteur informiert" in der Historie zurücksetzen
procedure doAH2(lRID: TgpIntegerList);

// alle auflisten, die in einer externen XLS Liste vorhanden sind
// auch die Ablage wird berücksichtigt "Bericht.xls"
procedure doAH3(lRID: TgpIntegerList);

// (c) Nadine Keiber 2014

// "550G" zur Zählernummer wieder dazumachen
procedure doKE1(lRID: TgpIntegerList);

// Die Sperren aus einer Zusatz-Baustelle anhand der Ableseeinheit korriegieren
procedure doKE2(lRID: TgpIntegerList; fb : TFeedback);

// BRIEF_STRASSE aus KUNDE_STRASSE übernehmen falls Hausnummer fehlt
procedure doKE3(lRID: TgpIntegerList);

// aus den Zaehler_infos Werte in das Feld ZAEHLER_NUMMER übertragen
procedure doKE4(lRID: TgpIntegerList);

// Zähler-Infos um Konstante "Quelle=xml" ergänzen!
procedure doKE5(lRID: TgpIntegerList);

// erneute Geolokalisierung erzwingen
procedure doKE6(lRID: TgpIntegerList; fb : TFeedback);

// =Schreibweisen in den InternInfos anpassen
procedure doKE7(lRID: TgpIntegerList);

// "60" zur Zählernummer-neu dazumachen
procedure doKE8(lRID: TgpIntegerList);

// N1, N2, N3, N4 aus einer Excel-Datei korrigieren!
procedure doKE9(lRID: TgpIntegerList);

// N2, aus den Werten R#neu, R#Korrektur, R#alt füllen
procedure doKEA(lRID: TgpIntegerList);

// Objektschlüssel=nnnnnnXnn -> Objektschlüssel=nnnnnnn nn
procedure doKEB(lRID: TgpIntegerList);

// INTERN_INFOS.aknr -> REGLER_NR
procedure doKEC(lRID: TgpIntegerList);

// (c) FKD GmbH

// INTERN_INFOS.tgw_obiscode sammeln nach ZAEHLWERKE_AUSBAU / ZAEHLWERKE_EINBAU
procedure doFK1(lRID: TgpIntegerList);

// (c) Biggi Hildebrand 2013

procedure doBI1(lRID: TgpIntegerList);

// (c) Nadine Heiter 2012

// PROTOKOLL - Schreibweisen Ersetzung aus "Protokoll-Ersetzungen.txt"
procedure doHE1(lRID: TgpIntegerList);

// (c) Alexander Knam 2010

// ersetze(',',':',Dauer);
procedure doKN1(lRID: TgpIntegerList);

// Buche Wareneingang "OK"
procedure doKN2(lRID: TgpIntegerList);

// (c) Dr. Mangler 2013

// gehe eine Mahnstufe zurück
procedure doMA1(lRID: TgpIntegerList);

// (c) Anke Bockmeyer 2020

// Ordne die Bilder aus Recherche-Verzeichnissen neu zu (wie LU1 aber mit Webverzeichnisse der Ablage)
procedure doBO1(lRID: TgpIntegerList = nil);

// Trage die Ausbaunummer nach in BAUSTELLE_R=
procedure doBO2;

// Flexible Datenkorrektur anhand der RID
procedure doBO3;

// (c) John Lüder 2020

// Ordne die Bilder aus Recherche-Verzeichnissen neu zu (wie BO1 aber ohne Webverzeichnisse der Ablage)
procedure doLU1(lRID: TgpIntegerList = nil);

// (c) Kim Schneider 2022

// korrigiere die Schreibweise der Foto-Parameter
procedure doSC1(lRID: TgpIntegerList = nil);

//
// Transaktion anhand ihres Namens (als String) aufrufen
//

procedure e_x_Transaktion(TransaktionsName: string; lRID: TgpIntegerList = nil; Feedback : TFeedback = nil);

implementation

uses
  // System
  graphics,

  // Tools
  c7zip, html,
  WordIndex,

{$ifdef fpc}
{$else}
  // IB-Objects
  IB_Components, IB_Access,
  // XLS Sachen
  FlexCel.Core, FlexCel.xlsAdapter,
{$endif}

  // OrgaMon
  globals, dbOrgaMon, Sperre,
  Funktionen_Basis,
  Funktionen_LokaleDaten,
  Funktionen_Auftrag,
  CareTakerClient;

{ TDataModuleTransaktionen }

procedure e_x_Transaktion(TransaktionsName: string; lRID: TgpIntegerList = nil; Feedback : TFeedback = nil);
begin
  repeat

    if (TransaktionsName = 'HA1') then
    begin
      doHA1;
      break;
    end;

    if (TransaktionsName = 'HA2') then
    begin
      doHA2;
      break;
    end;

    if (TransaktionsName = 'AY3') then
    begin
      doAY3(lRID);
      break;
    end;

    if (TransaktionsName = 'HA3') then
    begin
      doHA3(lRID);
      break;
    end;

    if (TransaktionsName = 'HA4') then
    begin
      doHA4(lRID);
      break;
    end;

    if (TransaktionsName = 'HA5') then
    begin
      doHA5(lRID);
      break;
    end;

    if (TransaktionsName = 'KE1') then
    begin
      doKE1(lRID);
      break;
    end;

    if (TransaktionsName = 'HA6') then
    begin
      doHA6(lRID);
      break;
    end;

    if (TransaktionsName = 'KE2') then
    begin
      doKE2(lRID,FeedBack);
      break;
    end;

    if (TransaktionsName = 'AH1') then
    begin
      doAH1(lRID);
      break;
    end;

    if (TransaktionsName = 'AH2') then
    begin
      doAH2(lRID);
      break;
    end;

    if (TransaktionsName = 'KE3') then
    begin
      doKE3(lRID);
      break;
    end;

    if (TransaktionsName = 'HA7') then
    begin
      doHA7(lRID);
      break;
    end;

    if (TransaktionsName = 'KE4') then
    begin
      doKE4(lRID);
      break;
    end;

    if (TransaktionsName = 'KE5') then
    begin
      doKE5(lRID);
      break;
    end;

    if (TransaktionsName = 'HA8') then
    begin
      doHA8(lRID);
      break;
    end;

    if (TransaktionsName = 'KE6') then
    begin
      doKE6(lRID, Feedback);
      break;
    end;

    if (TransaktionsName = 'HA9') then
    begin
      doHA9(lRID);
      break;
    end;

    if (TransaktionsName = 'HAA') then
    begin
      doHAA(lRID, Feedback);
      break;
    end;

    if (TransaktionsName = 'AH3') then
    begin
      doAH3(lRID);
      break;
    end;

    if (TransaktionsName = 'KE7') then
    begin
      doKE7(lRID);
      break;
    end;

    if (TransaktionsName = 'HAB') then
    begin
      doHAB(lRID);
      break;
    end;

    if (TransaktionsName = 'KE8') then
    begin
      doKE8(lRID);
      break;
    end;

    if (TransaktionsName = 'KE9') then
    begin
      doKE9(lRID);
      break;
    end;

    if (TransaktionsName = 'HE1') then
    begin
      doHE1(lRID);
      break;
    end;

    if (TransaktionsName = 'AY4') then
    begin
      doAY4(lRID);
      break;
    end;

    if (TransaktionsName = 'KEA') then
    begin
      doKEA(lRID);
      break;
    end;

    if (TransaktionsName = 'HAC') then
    begin
      doHAC(lRID);
      break;
    end;

    if (TransaktionsName = 'KEB') then
    begin
      doKEB(lRID);
      break;
    end;

    if (TransaktionsName = 'KEC') then
    begin
      doKEC(lRID);
      break;
    end;

    if (TransaktionsName = 'FK1') then
    begin
      doFK1(lRID);
      break;
    end;

    if (TransaktionsName = 'KN1') then
    begin
      doKN1(lRID);
      break;
    end;

    if (TransaktionsName = 'KN2') then
    begin
      doKN2(lRID);
      break;
    end;

    if (TransaktionsName = 'AY5') then
    begin
      doAY5(lRID);
      break;
    end;

    if (TransaktionsName = 'FI1') then
    begin
      doFI1(lRID);
      break;
    end;

    if (TransaktionsName = 'FI2') then
    begin
      doFI2(lRID);
      break;
    end;

    if (TransaktionsName = 'MA1') then
    begin
      doMA1(lRID);
      break;
    end;

    if (TransaktionsName = 'BO1') then
    begin
      doBO1(lRID);
      break;
    end;

    if (TransaktionsName = 'BO2') then
    begin
      doBO2;
      break;
    end;

    if (TransaktionsName = 'BO3') then
    begin
      doBO3;
      break;
    end;

    if (TransaktionsName = 'LU1') then
    begin
      doLU1(lRID);
      break;
    end;

    if (TransaktionsName = 'SC1') then
    begin
      doSC1(lRID);
      break;
    end;

  until yet;
end;

procedure doAH1(lRID: TgpIntegerList);

  procedure refreshEXPORT(sPath: string);
  var
    sFiles: TStringList;
    sOneFile: TStringList;
    n, m: integer;
    sOrderID: string;
    sResult: TStringList;
  begin
    sResult := TStringList.create;
    sFiles := TStringList.create;
    sOneFile := TStringList.create;
    dir(sPath + 'EXPORT*.xml', sFiles, false);
    for n := 0 to pred(sFiles.count) do
    begin
      sOneFile.LoadFromFile(sPath + sFiles[n]);
      for m := 0 to pred(sOneFile.count) do
        if (pos('<ORDER id="', sOneFile[m]) > 0) then
        begin
          sOrderID := ExtractSegmentBetween(sOneFile[m], 'id="', '" ');
          sResult.add(cutblank(sOrderID) + ';' + sFiles[n]);
        end;
    end;
    sResult.sort;
    RemoveDuplicates(sResult);
    sResult.Insert(0, 'ORDER.id;EXPORT.Dateiname');
    sResult.SaveToFile(DiagnosePath + 'EXPORT.Cache.txt');
    sFiles.free;
    sOneFile.free;
  end;

var
  cAUFTRAG: TdboCursor;
  AUFTRAG_R: integer;
  n, k: integer;

  sResult: TStringList;
  sOrderListe: TSearchStringList;
  sOrgaMon: TSearchStringList;

  // Ergebnis-Spalten
  sRID: string;
  OrderId: string;
  FName: string;
  Status: string;

begin
  if not(FileExists(DiagnosePath + 'EXPORT.Cache.txt')) then
    refreshEXPORT(cAuftragErgebnisPath + 'rwe-rz-sieg\');

  sResult := TStringList.create;
  sResult.add('RID;ORDER.id;EXPORT.Dateiname;RWSI');
  sOrderListe := TSearchStringList.create;
  sOrderListe.LoadFromFile(DiagnosePath + 'EXPORT.Cache.txt');
  ExportTable(
   {} 'select REGLER_NR, RID, EXPORT_TAN from AUFTRAG where' +
   {} ' (BAUSTELLE_R=312) and ' +
   {} ' (RID=MASTER_R)',
   {} DiagnosePath + 'RWSI.Status.csv');

  sOrgaMon := TSearchStringList.create;
  sOrgaMon.LoadFromFile(DiagnosePath + 'RWSI.Status.csv');

  cAUFTRAG := nCursor;
  with cAUFTRAG do
  begin
    sql.add('select REGLER_NR from AUFTRAG where RID=:CROSSREF');
    OPen;
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      ApiFirst;
      if not(eof) then
      begin

        OrderId := FieldByName('REGLER_NR').AsString;
        if (OrderId <> '') then
        begin

          k := sOrgaMon.findInc('"' + OrderId + '";');
          if (k = -1) then
          begin
            Status := 'NEIN';
            sRID := '0';
          end
          else
          begin
            Status := nextp(sOrgaMon[k], ';', 2);;
            sRID := nextp(sOrgaMon[k], ';', 1);
          end;

          k := sOrderListe.findInc(OrderId + ';');
          if (k = -1) then
            FName := '### keine Datenlieferung ###'
          else
            FName := nextp(sOrderListe[k], ';', 1);

          sResult.add(sRID + ';' + OrderId + ';' + FName + ';' + Status);
        end;
      end;
    end;
  end;
  sResult.SaveToFile(DiagnosePath + 'RWE.csv');
  cAUFTRAG.free;
  sResult.free;
  sOrderListe.free;
  sOrgaMon.free;
end;

procedure doAH2(lRID: TgpIntegerList);
var
  n: integer;
begin
  for n := 0 to pred(lRID.count) do
    e_x_sql('update AUFTRAG set ' + ' MONTEUREXPORT=null ' + 'where' + ' (MASTER_R=' + inttostr(integer(lRID[n])) +
      ') and' + ' (STATUS=6)');
end;

procedure doAY3(lRID: TgpIntegerList);
var
  n, m, k: integer;
  AUFTRAG_R: integer;
  lHistorische: TgpIntegerList;
  cHIST: TdboCursor;
  qAUFTRAG: TdboQuery;
  lRestoreFelder: TStringList;
  OneIsNUll: boolean;
begin

  cHIST := nCursor;
  qAUFTRAG := nQuery;
  lRestoreFelder := TStringList.create;

  with cHIST do
  begin
    sql.add('select * from AUFTRAG where RID=:CROSSREF');
  end;
  with qAUFTRAG do
  begin
    sql.add('select * from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;

  lRestoreFelder.add('MONTEUR1_R');
  lRestoreFelder.add('AUSFUEHREN');
  lRestoreFelder.add('VORMITTAGS');

  for n := 0 to pred(lRID.count) do
  begin
    AUFTRAG_R := integer(lRID[n]);
    lHistorische := e_r_sqlm(
     {} 'select RID from AUFTRAG where' +
     {} ' (MASTER_R=' + inttostr(AUFTRAG_R) + ') and' +
     {} ' (STATUS=6) ' +
     {} 'order by' +
     {} ' RID descending');

    for m := 0 to pred(lHistorische.count) do
    begin
      with cHIST do
      begin
        ParamByName('CROSSREF').AsInteger := lHistorische[m];
        OPen;
        ApiFirst;
        if not(eof) then
        begin
          OneIsNUll := false;
          for k := 0 to pred(lRestoreFelder.count) do
            if FieldByName(lRestoreFelder[k]).IsNull then
              OneIsNUll := true;
          if OneIsNUll then
          begin
            close;
            continue;
          end;

          // Nun kopieren
          with qAUFTRAG do
          begin
            ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
            OPen;
            first;
            if not(eof) then
            begin
              edit;
              for k := 0 to pred(lRestoreFelder.count) do
                FieldByName(lRestoreFelder[k]).assign(cHIST.FieldByName(lRestoreFelder[k]));
              AuftragBeforePost(qAUFTRAG);
              post;
            end;
            close;
          end;
          cHIST.close;
          break;

        end;
        close;
      end;
    end;
    lHistorische.free;
  end;
  cHIST.free;
  qAUFTRAG.free;
  lRestoreFelder.free;

end;

procedure doAY4(lRID: TgpIntegerList);
var
  n, m: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  lInternInfo: TStringList;
  sCommandSet: TStringList;
begin
  // aus den Interninfos diverse Stringersetzungen ersetzten

  sCommandSet := TStringList.create;
  sCommandSet.LoadFromFile(AnwenderPath + 'AY4.txt');
  qAUFTRAG := nQuery;
  lInternInfo := TStringList.create;
  with qAUFTRAG do
  begin
    sql.add('select ' + sCommandSet[0] + ' from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;
  with qAUFTRAG do
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      OPen;
      first;
      if not(eof) then
      begin
        e_r_sqlt(FieldByName(sCommandSet[0]),lInternInfo);
        edit;
        for m := 1 to pred(sCommandSet.count) do
          if pos('|', sCommandSet[m]) > 0 then
            ersetze(nextp(sCommandSet[m], '|', 0), nextp(sCommandSet[m], '|', 1), lInternInfo);
        FieldByName(sCommandSet[0]).assign(lInternInfo);
        post;
      end;
      close;
    end;
  qAUFTRAG.free;
  lInternInfo.free;
  sCommandSet.free;

end;

procedure doAY5(lRID: TgpIntegerList);
var
  n: integer;
  AUFTRAG_R: integer;
  cAUFTRAG: TdboCursor;
  lSettings: TStringList;
  lProtokoll: TStringList;
  FName: string;
  lZips: TStringList;
begin
  // aus den Interninfos diverse felder rauslöschen!

  cAUFTRAG := nCursor;
  lSettings := TStringList.create;
  lProtokoll := TStringList.create;
  lZips := TStringList.create;
  with cAUFTRAG do
  begin
    sql.add('select');
    sql.add(' AUFTRAG.PROTOKOLL, BAUSTELLE.EXPORT_EINSTELLUNGEN');
    sql.add('from AUFTRAG');
    sql.add('join BAUSTELLE on');
    sql.add(' BAUSTELLE.RID=AUFTRAG.BAUSTELLE_R');
    sql.add('where AUFTRAG.RID=:CROSSREF');
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      OPen;
      first;
      while not(eof) do
      begin
        e_r_sqlt(FieldByName('PROTOKOLL'),lProtokoll);

        FName := nextp(lProtokoll.Values['FA'], ',', 0);
        if (FName <> '') then
        begin
          e_r_sqlt(FieldByName('EXPORT_EINSTELLUNGEN'),lSettings);
          FName := e_r_FotoPfad(fp_Deliver, AUFTRAG_R) + FName;
          if FileExists(FName) then
            lZips.add(FName);
        end;

        FName := nextp(lProtokoll.Values['FN'], ',', 0);
        if (FName <> '') then
        begin
          e_r_sqlt(FieldByName('EXPORT_EINSTELLUNGEN'),lSettings);
          FName := e_r_FotoPfad(fp_Deliver, AUFTRAG_R) + FName;
          if FileExists(FName) then
            lZips.add(FName);
        end;
        next;
      end;
    end;
  end;

  if (lZips.count > 0) then
    zip(
      { } lZips,
      { } AnwenderPath + 'Bilder.zip',
      { } czip_set_Level + '=' + '0')
  else
    FileDelete(AnwenderPath + 'Bilder.zip');

  cAUFTRAG.free;
  lSettings.free;
  lProtokoll.free;
  lZips.free;
end;

procedure doBI1(lRID: TgpIntegerList);
var
  qBuch: TdboQuery;
  Skript: TStringList;
  n: integer;
begin

  // Migrationshilfe Belegzuordnung
  Skript := TStringList.create;
  qBuch := nQuery;
  with qBuch do
  begin
    sql.add('select');
    sql.add(' RID,MASTER_R,STEMPEL_DOKUMENT,BELEG_R,BETRAG,SKRIPT');
    sql.add('from BUCH where');
    sql.add(' RID=:CROSSREF');
    for_update(sql);

    for n := 0 to pred(lRID.count) do
    begin
      ParamByName('CROSSREF').AsInteger := lRID[n];
      if not(Active) then
        OPen;
      if not(eof) then
      begin
        repeat
          if (FieldByName('RID').AsInteger <> FieldByName('MASTER_R').AsInteger) then
            break;
          if (FieldByName('STEMPEL_DOKUMENT').IsNull) then
            break;
          if (FieldByName('STEMPEL_DOKUMENT').AsInteger <> 0) then
            break;
          if (FieldByName('BELEG_R').IsNull) then
            break;

          // machs
          e_r_sqlt(FieldByName('Skript'),Skript);
          Skript.add(format('BELEG=%d;%d;%m', [
            {} FieldByName('BELEG_R').AsInteger,
            {} FieldByName('STEMPEL_DOKUMENT').AsInteger,
            {} FieldByName('BETRAG').AsCurrency]));

          edit;
          FieldByName('SKRIPT').assign(Skript);
          FieldByName('STEMPEL_DOKUMENT').clear;
          post;
        until yet;
      end;
    end;
  end;
  Skript.free;
  qBuch.free;
end;

procedure doHA3(lRID: TgpIntegerList);
var
  n: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  lInternInfo: TStringList;
begin
  // aus den Interninfos diverse felder rauslöschen!

  qAUFTRAG := nQuery;
  lInternInfo := TStringList.create;

  with qAUFTRAG do
  begin
    sql.add('select * from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;

  with qAUFTRAG do
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      OPen;
      first;
      if not(eof) then
      begin
        e_r_sqlt(FieldByName('INTERN_INFO'),lInternInfo);
        edit;
        lInternInfo.Values['Auftragseinheit'] := '';
        lInternInfo.Values['Auftragsnummer'] := '';
        lInternInfo.Values['MobiBelegNr'] := '';
        lInternInfo.Values['Auftragsart'] := '';
        lInternInfo.Values['Montageart'] := '';
        FieldByName('INTERN_INFO').assign(lInternInfo);
        post;
      end;
      close;
    end;
  qAUFTRAG.free;
  lInternInfo.free;

end;

procedure doHA4(lRID: TgpIntegerList);
var
  n: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
begin

  qAUFTRAG := nQuery;

  with qAUFTRAG do
  begin
    sql.add('select * from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;

  with qAUFTRAG do
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      OPen;
      first;
      if not(eof) then
      begin
        if not(FieldByName('EXPORT_TAN').IsNull) then
        begin
          edit;
          FieldByName('EXPORT_TAN').clear;
          post;
        end;
      end;
      close;
    end;
  qAUFTRAG.free;

end;

procedure doHA5(lRID: TgpIntegerList);
var
  n: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
begin

  qAUFTRAG := nQuery;

  with qAUFTRAG do
  begin
    sql.add('select * from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;

  with qAUFTRAG do
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      OPen;
      first;
      if not(eof) then
      begin
        if FieldByName('EXPORT_TAN').IsNull then
        begin
          edit;
          FieldByName('EXPORT_TAN').AsInteger := 0;
          post;
        end;
      end;
      close;
    end;
  qAUFTRAG.free;

end;

procedure doHA12(AuchZaehlerStaende: boolean);
var
  sWerte: TStringList;
  sLog: TStringList;
  ZaehlerNummer: string;
  Stat_Aenderungen: integer;

  function getValue(Row: integer; Col: integer): string;
  begin
    if (Row >= sWerte.count) then
      result := ''
    else
      result := cutblank(nextp(sWerte[Row], ';', Col));
  end;

var
  n: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  sProtokoll: TStringList;
  DontTouch: boolean;

  // Ablesewerte
  ZaehlerStandHT, ZaehlerStandNT: string;
  AbleseDatum: TAnfixDate;
begin

  //
  sProtokoll := TStringList.create;
  sWerte := TStringList.create;
  sWerte.LoadFromFile(MyProgramPath + 'NonDa/Nachmeldung Werte.xls.csv');
  sLog := TStringList.create;
  qAUFTRAG := nQuery;
  with qAUFTRAG do
  begin
    //
    sql.add('select * from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
    prepare;
  end;

  //
  n := 0;
  Stat_Aenderungen := 0;
  repeat

    ZaehlerNummer := StrFilter(getValue(n, 0), '0123456789');

    if (ZaehlerNummer <> '') then
    begin

      //
      AUFTRAG_R := e_r_sql(
       {} 'select RID from AUFTRAG where' +
       {} ' (ZAEHLER_NUMMER=''' + ZaehlerNummer + ''') and ' +
       {} ' (STATUS<>6)');

      if (AUFTRAG_R > 0) then
      begin

        ZaehlerStandHT := getValue(n, 1);
        ZaehlerStandNT := getValue(n, 2);
        AbleseDatum := date2long(getValue(n, 3));

        with qAUFTRAG do
        begin
          ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
          OPen;
          first;
          if not(eof) then
          begin

            //
            e_r_sqlt(FieldByName('PROTOKOLL'),sProtokoll);
            DontTouch := false;
            repeat
              if (FieldByName('ZAEHLER_STAND_ALT').AsString <> ZaehlerStandHT) then
                break;
              if (FieldByName('ZAEHLER_STAND_NEU').AsString <> ZaehlerStandNT) then
                break;
              if (FieldByName('ZAEHLER_WECHSEL').AsDateTime <> Long2datetime(AbleseDatum)) then
                break;
              if (sProtokoll.Values['SA'] <> 'X') then
                break;
              if (FieldByName('STATUS').AsInteger <> ord(ctsErfolg)) then
                break;
              if (FieldByName('MONDA_SCHUTZ').AsString <> cC_True) then
                break;

              DontTouch := true;
            until yet;

            if not(DontTouch) then
            begin
              repeat

                //
                if (ZaehlerStandHT = '') then
                begin
                  sLog.add('Zählernummer ' + ZaehlerNummer + ' HT fehlt');
                  break;
                end;

                //
                if (pos('2', FieldByName('ART').AsString) > 0) then
                  if (ZaehlerStandNT = '') then
                  begin
                    sLog.add('Zählernummer ' + ZaehlerNummer + ' NT fehlt');
                    break;
                  end;
                if (FieldByName('ZAEHLER_STAND_ALT').AsString <> '') and
                  (FieldByName('ZAEHLER_STAND_ALT').AsString <> ZaehlerStandHT) then
                begin
                  sLog.add(ZaehlerNummer + '.HT: Änderung von ' + FieldByName('ZAEHLER_STAND_ALT').AsString + ' auf ' +
                    ZaehlerStandHT);
                end;

                if (FieldByName('ZAEHLER_STAND_NEU').AsString <> '') and
                  (FieldByName('ZAEHLER_STAND_NEU').AsString <> ZaehlerStandNT) then
                begin
                  sLog.add(ZaehlerNummer + '.NT: Änderung von ' + FieldByName('ZAEHLER_STAND_NEU').AsString + ' auf ' +
                    ZaehlerStandNT);
                end;

                edit;
                //
                sProtokoll.Values['SA'] := 'X';
                FieldByName('PROTOKOLL').assign(sProtokoll);
                if AuchZaehlerStaende then
                begin
                  FieldByName('ZAEHLER_STAND_ALT').AsString := ZaehlerStandHT;
                  FieldByName('ZAEHLER_STAND_NEU').AsString := ZaehlerStandNT;
                end;
                if DateOK(AbleseDatum) then
                  FieldByName('ZAEHLER_WECHSEL').AsDateTime := Long2datetime(AbleseDatum)
                else
                  FieldByName('ZAEHLER_WECHSEL').AsDateTime := now;
                FieldByName('STATUS').AsInteger := ord(ctsErfolg);
                FieldByName('EXPORT_TAN').clear;
                FieldByName('MONDA_SCHUTZ').AsString := cC_True;

                AuftragBeforePost(qAUFTRAG);
                post;
                inc(Stat_Aenderungen);
              until yet;
            end;

          end
          else
          begin
            sLog.add('Zählernummer ' + ZaehlerNummer + ' nicht wiedergefunden!');
          end;
          close;
        end;

      end
      else
      begin
        sLog.add('Zählernummer ' + ZaehlerNummer + ' nicht gefunden!');
      end;

    end;

    inc(n);
    if (n >= sWerte.count) then
      break;

  until false;
  sLog.add(inttostr(Stat_Aenderungen) + ' Änderungen!');
  sLog.SaveToFile(DiagnosePath + 'HA1'+cLogExtension);

  sWerte.free;
  sLog.free;
  sProtokoll.free;
end;

procedure doHA1;
begin
  doHA12(true);
end;

procedure doHA2;
begin
  doHA12(false);
end;

procedure doKE1(lRID: TgpIntegerList);
var
  n: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  ZaehlerNummer: string;
begin

  // 550G wieder dazumachen

  qAUFTRAG := nQuery;

  with qAUFTRAG do
  begin
    sql.add('select * from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;

  with qAUFTRAG do
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      OPen;
      first;
      if not(eof) then
      begin
        ZaehlerNummer := FieldByName('ZAEHLER_NUMMER').AsString;
        if (pos('550', ZaehlerNummer) = 1) and (pos('G', ZaehlerNummer) = 0) then
        begin
          edit;
          FieldByName('ZAEHLER_NUMMER').AsString := '550G' + copy(ZaehlerNummer, 4, MaxInt);
          post;
        end;
      end;
      close;
    end;
  qAUFTRAG.free;

end;

procedure doKE2(lRID: TgpIntegerList; fb : TFeedBack);

{$I Feedback.inc}

const
  cAbleseEinheit = 'Ableseeinheit';
var
  n: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  cAUFTRAG: TdboCursor;
  InternInfos: TStringList;
  AbleseEinheit: string;
  sBericht: TStringList;
  SperreVon, SperreBis: TAnfixDate;
  _SperreVon, _SperreBis: TAnfixDate;
  AktuellesJahr: integer;
  FehlendeAbleseEinheiten: TStringList;
begin

  sBericht := TStringList.create;
  FehlendeAbleseEinheiten := TStringList.create;
  qAUFTRAG := nQuery;
  cAUFTRAG := nCursor;
  InternInfos := TStringList.create;

  with cAUFTRAG do
  begin
    sql.add('select SPERRE_VON,SPERRE_BIS from AUFTRAG where');
    sql.add(' (BAUSTELLE_R=355) and');
    sql.add(' (STATUS<>6) and');
    sql.add(' (ZAEHLER_NUMMER=:CROSSREF)');
    Open;
  end;

  with qAUFTRAG do
  begin
    sql.add('select ZAEHLER_NUMMER,INTERN_INFO,SPERRE_VON,SPERRE_BIS from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
    OPen;
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      if not(eof) then
      begin

        // Ermittlung der AbleseEinheit noch unsicher!
        e_r_sqlt(FieldByName('INTERN_INFO'),InternInfos);
        AbleseEinheit := InternInfos.Values[cAbleseEinheit];
        _SperreVon := DateTime2long(FieldByName('SPERRE_VON').AsDateTime);
        _SperreBis := DateTime2long(FieldByName('SPERRE_BIS').AsDateTime);
        SperreVon := _SperreVon;
        SperreBis := _SperreBis;

        if (AbleseEinheit <> '') then
        begin
          cAUFTRAG.ParamByName('CROSSREF').AsString := AbleseEinheit;
          cAUFTRAG.ApiFirst;
          if not(cAUFTRAG.eof) then
          begin
            SperreVon := DateTime2long(cAUFTRAG.FieldByName('SPERRE_VON').AsDateTime);
            SperreBis := DateTime2long(cAUFTRAG.FieldByName('SPERRE_BIS').AsDateTime);
          end
          else
          begin
            sBericht.add(cERRORTEXT +
              { } FieldByName('ZAEHLER_NUMMER').AsString +
              { } ': Ableseeinheit "' + AbleseEinheit +
              { } '" ist unbekannt!');
            if (FehlendeAbleseEinheiten.indexof(AbleseEinheit) = -1) then
              FehlendeAbleseEinheiten.add(AbleseEinheit);

          end;
        end
        else
        begin
          sBericht.add(cWARNINGText + ' ' + FieldByName('ZAEHLER_NUMMER').AsString + ': Ableseeinheit ist leer!');
        end;

        if DateOK(SperreVon) and DateOK(SperreBis) then
        begin
          AktuellesJahr := extractYear(DateGet);

          // Die Sperre auf das aktuelle Jahr setzen
          SperreVon :=
          { } Details2Long(AktuellesJahr,
            { } extractMonth(SperreVon),
            { } extractDay(SperreVon));
          SperreBis :=
          { } Details2Long(AktuellesJahr,
            { } extractMonth(SperreBis),
            { } extractDay(SperreBis));
          if (SperreBis < SperreVon) then
            SperreBis :=
            { } Details2Long(AktuellesJahr + 1,
              { } extractMonth(SperreBis),
              { } extractDay(SperreBis));

          if (_SperreVon <> SperreVon) or (_SperreBis <> SperreBis) then
          begin

            sBericht.add(cINFOText + ' ' + FieldByName('ZAEHLER_NUMMER').AsString + ' Änderung von ' +
              long2date(_SperreVon) + '-' + long2date(_SperreBis) + ' auf ' + long2date(SperreVon) + '-' +
              long2date(SperreBis));

            edit;
            FieldByName('SPERRE_VON').AsDateTime := Long2datetime(SperreVon);
            FieldByName('SPERRE_BIS').AsDateTime := Long2datetime(SperreBis);
            post;
          end;
        end;

      end;
    end;
    close;
  end;

  //
  if (FehlendeAbleseEinheiten.count > 0) then
  begin
    sBericht.add('');
    sBericht.add('Zusammenfassung aller fehlenden Ableseeinheiten:');
    sBericht.add('');
    FehlendeAbleseEinheiten.sort;
    sBericht.addstrings(FehlendeAbleseEinheiten);
  end;
  sBericht.SaveToFile(DiagnosePath + 'KE2.txt');
  InternInfos.free;
  qAUFTRAG.free;
  sBericht.free;
  FehlendeAbleseEinheiten.free;
  _(cFeedBack_OpenShell,DiagnosePath + 'KE2.txt');
end;

procedure doKE3(lRID: TgpIntegerList);
var
  n: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
begin

  qAUFTRAG := nQuery;

  with qAUFTRAG do
  begin
    sql.add('select * from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;

  with qAUFTRAG do
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      OPen;
      first;
      if not(eof) then
      begin
        if (FieldByName('KUNDE_ORT').AsString = FieldByName('BRIEF_ORT').AsString) then
          if (FieldByName('BRIEF_STRASSE').AsString <> '') then
            if (pos(FieldByName('BRIEF_STRASSE').AsString, FieldByName('KUNDE_STRASSE').AsString) = 1) then
              if (length(FieldByName('BRIEF_STRASSE').AsString) < length(FieldByName('KUNDE_STRASSE').AsString)) then
              begin
                edit;
                FieldByName('BRIEF_STRASSE').AsString := FieldByName('KUNDE_STRASSE').AsString;
                post;
              end;
      end;
      close;
    end;
  qAUFTRAG.free;

end;

procedure doKE4(lRID: TgpIntegerList);
var
  n, k: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  ZaehlerInfos: TStringList;
  InternInfos: TStringList;
  ZAEHLER_NUMMER: string;
  QUELLE: string;
begin

  qAUFTRAG := nQuery;
  ZaehlerInfos := TStringList.create;
  InternInfos := TStringList.create;

  with qAUFTRAG do
  begin
    sql.add('select ZAEHLER_INFO,ZAEHLER_NUMMER,INTERN_INFO from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
    OPen;
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      if not(eof) then
      begin
        e_r_sqlt(FieldByName('ZAEHLER_INFO'),ZaehlerInfos);
        e_r_sqlt(FieldByName('INTERN_INFO'),InternInfos);
        for k := pred(ZaehlerInfos.count) downto 0 do
        begin

          repeat

            if pos('NummerAlt:_', ZaehlerInfos[k]) = 1 then
            begin
              ZAEHLER_NUMMER := nextp(ZaehlerInfos[k], 'NummerAlt:_', 1);
              if (ZAEHLER_NUMMER <> '') then
              begin
                ZaehlerInfos.delete(k);
                edit;
                FieldByName('ZAEHLER_NUMMER').AsString := ZAEHLER_NUMMER;
                FieldByName('ZAEHLER_INFO').assign(ZaehlerInfos);
                post;
                break;
              end;
            end;

            if pos('QUELLE:_', ZaehlerInfos[k]) = 1 then
            begin
              QUELLE := nextp(ZaehlerInfos[k], 'QUELLE:_', 1);
              if (QUELLE <> '') then
              begin
                ZaehlerInfos.delete(k);
                edit;
                InternInfos.add('Quelle=' + QUELLE);
                FieldByName('INTERN_INFO').assign(InternInfos);
                FieldByName('ZAEHLER_INFO').assign(ZaehlerInfos);
                post;
                break;
              end;
            end;

          until yet;

        end;
      end;
    end;
    close;
  end;
  ZaehlerInfos.free;
  InternInfos.free;
  qAUFTRAG.free;

end;

procedure doKE5(lRID: TgpIntegerList);
const
  cNachtrag = 'Quelle=XML';
var
  n: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  ZaehlerInfos: TStringList;
begin

  qAUFTRAG := nQuery;
  ZaehlerInfos := TStringList.create;

  with qAUFTRAG do
  begin
    sql.add('select ZAEHLER_INFO from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
    Open;
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      if not(eof) then
      begin
        e_r_sqlt(FieldByName('ZAEHLER_INFO'),ZaehlerInfos);
        if (ZaehlerInfos.indexof(cNachtrag) = -1) then
        begin
          ZaehlerInfos.Insert(0, cNachtrag);
          edit;
          FieldByName('ZAEHLER_INFO').assign(ZaehlerInfos);
          post;
        end;
      end;
    end;
    close;
  end;
  ZaehlerInfos.free;
  qAUFTRAG.free;

end;

procedure doHA6(lRID: TgpIntegerList);
var
  n: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  StandplatzInfo: string;
  ZaehlerInfos: TStringList;
begin

  qAUFTRAG := nQuery;
  ZaehlerInfos := TStringList.create;

  with qAUFTRAG do
  begin
    sql.add('select ZAEHLER_INFO,BRIEF_NAME2 from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
    OPen;
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      if not(eof) then
      begin
        e_r_sqlt(FieldByName('ZAEHLER_INFO'),ZaehlerInfos);
        StandplatzInfo := HugeSingleLine(ZaehlerInfos, ' ');
        StandplatzInfo := AnsiUpperCase(noblank(nextp(StandplatzInfo, 'v1=')));
        if (pos('IM', StandplatzInfo) = 1) then
          StandplatzInfo := copy(StandplatzInfo, 3, MaxInt);
        if (pos('INDER', StandplatzInfo) = 1) then
          StandplatzInfo := copy(StandplatzInfo, 6, MaxInt);
        if (StandplatzInfo = '') then
          StandplatzInfo := 'KELLER';
        edit;
        FieldByName('BRIEF_NAME2').AsString := StandplatzInfo;
        post;
      end;
    end;
    close;
  end;
  ZaehlerInfos.free;
  qAUFTRAG.free;

end;

procedure doHA7(lRID: TgpIntegerList);
var
  n: integer;
  sQS: string;
  sCSV: TStringList;
  AUFTRAG_R: integer;
  BAUSTELLE_R: integer;
  sSettings: TStringList;
begin
  if lRID.count > 0 then
  begin


    // Baustellen Settings holen
    AUFTRAG_R := integer(lRID[0]);
    BAUSTELLE_R := e_r_sql('select BAUSTELLE_R from AUFTRAG where RID=' + inttostr(AUFTRAG_R));
    sSettings := e_r_BaustelleEinstellungen(BAUSTELLE_R);

    // QS - Liste frisch erzeugen
    sCSV := TStringList.create;
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      sQS := e_r_AuftragPlausi(AUFTRAG_R);
      if (sQS <> '') then
        sCSV.addobject(sQS, pointer(AUFTRAG_R));

      if QS_gut(sQS, sSettings) then
      begin
        e_x_sql('update AUFTRAG set VERBRAUCH_PRO_JAHR=null where RID=' + inttostr(AUFTRAG_R));
      end
      else
      begin
        e_x_sql('update AUFTRAG set VERBRAUCH_PRO_JAHR=''N' + ''' where RID=' + inttostr(AUFTRAG_R));
      end;
    end;
    sCSV.sort;
    for n := 0 to pred(sCSV.count) do
      sCSV[n] := '(RID=' + inttostr(integer(sCSV.objects[n])) + ') ' + sCSV[n];
    sCSV.Insert(0, 'Bericht der Qualitätssicherung');
    sCSV.SaveToFile(DiagnosePath + 'QS.csv');
    sCSV.free;
  end;
end;

procedure doHA8(lRID: TgpIntegerList);
var
  n: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  lInternInfo: TStringList;
  sQSmerkmal: string;
begin

  sQSmerkmal := 'QS_UMGANGEN=' + datum + ';' + secondstostr(SecondsGet) + ';' + sBearbeiterKurz;
  qAUFTRAG := nQuery;
  lInternInfo := TStringList.create;

  with qAUFTRAG do
  begin
    sql.add('select INTERN_INFO from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;

  with qAUFTRAG do
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      OPen;
      first;
      if not(eof) then
      begin
        e_r_sqlt(FieldByName('INTERN_INFO'),lInternInfo);
        lInternInfo.add(sQSmerkmal);
        edit;
        FieldByName('INTERN_INFO').assign(lInternInfo);
        post;
      end;
      close;
    end;
  qAUFTRAG.free;
  lInternInfo.free;

end;

procedure doHA9(lRID: TgpIntegerList);
var
  BAUSTELLE_R: integer;
{$ifdef fpc}
{$else}
  xImport: TXLSFile;
{$endif}
  qAUFTRAG: TdboQuery;
  sDiagnose: TStringList;

  procedure setVorgezogen(ZaehlerNummer: string);
  begin
    with qAUFTRAG do
    begin
      repeat
        if ZaehlerNummer = '' then
          break;

        ParamByName('CROSSREF').AsString := ZaehlerNummer;
        first;

        if eof then
        begin
          sDiagnose.add(cERRORTEXT + ' +Vorgezogen: ' + ZaehlerNummer + ' nicht gefunden');
          break;
        end;

        if Recordcount <> 1 then
        begin
          sDiagnose.add(cERRORTEXT + ' +Vorgezogen: ' + ZaehlerNummer + ' gibt es mehrfach');
          break;
        end;

        if FieldByName('STATUS').AsInteger <> cs_Vorgezogen then
        begin
          edit;
          FieldByName('STATUS').AsInteger := cs_Vorgezogen;
          AuftragBeforePost(qAUFTRAG);
          post;
        end;

      until yet;

    end;
  end;

  procedure setHinweise(ZaehlerNummer, Hinweis: string);
  var
    sInfo: TStringList;
  begin
    sInfo := TStringList.create;
    with qAUFTRAG do
    begin
      repeat
        if ZaehlerNummer = '' then
          break;

        ParamByName('CROSSREF').AsString := ZaehlerNummer;
        first;

        if eof then
        begin
          sDiagnose.add(cERRORTEXT + ' +Hinweis: ' + ZaehlerNummer + ' nicht gefunden');
          break;
        end;

        if (Recordcount <> 1) then
        begin
          sDiagnose.add(cERRORTEXT + ' +Hinweis: ' + ZaehlerNummer + ' gibt es mehrfach');
          break;
        end;

        e_r_sqlt(FieldByName('MONTEUR_INFO'),sInfo);
        if sInfo.indexof(Hinweis) = -1 then
        begin
          sInfo.add(Hinweis);
          edit;
          FieldByName('MONTEUR_INFO').assign(sInfo);
          AuftragBeforePost(qAUFTRAG);
          post;
        end;

      until yet;

    end;
    sInfo.free;
  end;

  function rC { readCell } (r, c: integer): string;
  begin
   {$ifdef fpc}
   // imp pend
   {$else}
    result := cutblank(xImport.getCellValue(r, c).ToStringInvariant);
   {$endif}
  end;

var
  r: integer;

begin

  // um welche Baustelle geht es
  BAUSTELLE_R := e_r_sql('select BAUSTELLE_R from AUFTRAG where RID=' + inttostr(integer(lRID[0])));

  // Excel-Dokument öffnen
  qAUFTRAG := nQuery;
  with qAUFTRAG do
  begin
    sql.add('select * from');
    sql.add('AUFTRAG');
    sql.add('where');
    sql.add(' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') and');
    sql.add(' (STATUS<>6) and');
    sql.add(' (ZAEHLER_NUMMER=:CROSSREF)');
    for_update(sql);
    OPen;
  end;

  {$ifdef fpc}
  {$else}
  xImport := TXLSFile.create(true);
  sDiagnose := TStringList.create;

  with xImport do
  begin
    OPen(MyProgramPath + 'NonDa/Nachtrag.xls');
    ActiveSheet := 1;
    for r := 2 to RowCount do
      setHinweise(rC(r, 5), rC(r, 6));
    ActiveSheet := 2;
    for r := 2 to RowCount do
      setVorgezogen(rC(r, 5));
  end;

  xImport.free;
  {$endif}
  qAUFTRAG.free;
  sDiagnose.SaveToFile(DiagnosePath + 'Nachtrag.txt');

end;

procedure doHAA(lRID: TgpIntegerList; fb : TFeedBack);

{$I Feedback.inc}

var
  BAUSTELLE_R: integer;
{$ifdef fpc}
{$else}
  xImport: TXLSFile;
{$endif}
  cAUFTRAG: TdboCursor;
  cAUFTRAG2: TdboCursor;
  sDiagnose: TStringList;

  procedure setMarkiert(ZaehlerNummer: string);
  var
    AUFTRAG_R: integer;
  begin
    if (ZaehlerNummer <> '') then
      with cAUFTRAG do
      begin
        ParamByName('CROSSREF').AsString := ZaehlerNummer;
        first;
        if eof then
        begin
          with cAUFTRAG2 do
          begin
            ParamByName('CROSSREF').AsString := ZaehlerNummer;
            first;
            if eof then
            begin
              sDiagnose.add(cERRORTEXT + ' Zählernummer "' + ZaehlerNummer + '" nicht gefunden');
            end
            else
            begin
              while not(eof) do
              begin
                AUFTRAG_R := FieldByName('RID').AsInteger;
                _(cFeedBack_Function,IntToStr(AUFTRAG_R));
                next;
              end;
            end;
          end;
        end
        else
        begin
          while not(eof) do
          begin
            AUFTRAG_R := FieldByName('RID').AsInteger;
            _(cFeedBack_Function,IntToStr(AUFTRAG_R));
            next;
          end;
        end;
      end;
  end;

  function rC { readCell } (r, c: integer): string;
  begin
   {$ifdef fpc}
   // imp pend
   {$else}
    result := cutblank(xImport.getCellValue(r, c).ToStringInvariant);
   {$endif}
  end;

var
  r: integer;

begin

  // um welche Baustelle geht es
  BAUSTELLE_R := e_r_sql('select BAUSTELLE_R from AUFTRAG where RID=' + inttostr(integer(lRID[0])));
  _(cFeedBack_Function+1);
  lRID.clear;
  // Excel-Dokument öffnen
  cAUFTRAG := nCursor;
  with cAUFTRAG do
  begin
    sql.add('select RID from');
    sql.add('AUFTRAG');
    sql.add('where');
    sql.add(' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') and');
    sql.add(' (STATUS<>6) and');
    sql.add(' (ZAEHLER_NUMMER=:CROSSREF)');
    OPen;
  end;

  cAUFTRAG2 := nCursor;
  with cAUFTRAG2 do
  begin
    sql.add('select RID from');
    sql.add('AUFTRAG');
    sql.add('where');
    sql.add(' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') and');
    sql.add(' (STATUS<>6) and');
    sql.add(' (ZAEHLER_NUMMER containing :CROSSREF)');
    OPen;
  end;

  {$ifdef fpc}
  // imp pend
  {$else}
  xImport := TXLSFile.create(true);
  sDiagnose := TStringList.create;

  with xImport do
  begin
    OPen(MyProgramPath + 'NonDa/Bericht.xls');
    ActiveSheet := 1;
    for r := 2 to RowCount do
      setMarkiert(rC(r, 4)); // Excel Spalte D
  end;

  xImport.free;
  {$endif}
  cAUFTRAG.free;
  cAUFTRAG2.free;
  sDiagnose.SaveToFile(DiagnosePath + 'Nachtrag.txt');
  if (sDiagnose.count > 0) then
   _(cFeedBack_openShell, DiagnosePath + 'Nachtrag.txt');
  sDiagnose.free;
end;

procedure doAH3(lRID: TgpIntegerList);
var
  {$ifdef fpc}
  {$else}
  xImport: TXLSFile;
  {$endif}
  cAUFTRAG: TdboCursor;
  cABLAGE: TdboCursor;

  sRIDs: TStringList;
  sABLAGE: TStringList;

  ZAEHLER_NUMMER: string;
  PLZ: string;
  AUFTRAG_R: integer;

  function rC { readCell } (r, c: integer): string;
  begin
   {$ifdef fpc}
   // imp pend
   {$else}
    result := cutblank(xImport.getCellValue(r, c).ToStringInvariant);
   {$endif}
  end;

var
  r: integer;

begin


  // um welche Baustelle geht es

  cAUFTRAG := nCursor;
  with cAUFTRAG do
  begin
    sql.add('select RID from');
    sql.add(' AUFTRAG');
    sql.add('where');
    sql.add(' (STATUS<>6) and');
    sql.add(' (ZAEHLER_NUMMER=:CR1) and');
    sql.add(' (KUNDE_ORT starts with :CR2)');
    OPen;
  end;

  cABLAGE := nCursor;
  with cABLAGE do
  begin
    sql.add('select RID from');
    sql.add(' ABLAGE');
    sql.add('where');
    sql.add(' (STATUS<>6) and');
    sql.add(' (ZAEHLER_NUMMER=:CR1) and');
    sql.add(' (KUNDE_ORT starts with :CR2)');
    OPen;
  end;

  {$ifdef fpc}
  // imp pend
  {$else}
  // Excel-Dokument öffnen
  xImport := TXLSFile.create(true);

  sRIDs := TStringList.create;
  sRIDs.add('RID');
  sABLAGE := TStringList.create;
  sABLAGE.add('RID');

  with xImport do
  begin
    OPen(MyProgramPath + 'NonDa/Bericht.xls');
    ActiveSheet := 1;
    for r := 2 to RowCount do
    begin
      AUFTRAG_R := -1;

      PLZ := rC(r, 3); // Spalte C
      ZAEHLER_NUMMER := rC(r, 4); // Spalte D

      repeat

        if (ZAEHLER_NUMMER = '') then
          break;
        if (PLZ = '') then
          break;

        with cAUFTRAG do
        begin
          ParamByName('CR1').AsString := ZAEHLER_NUMMER;
          ParamByName('CR2').AsString := PLZ;
          ApiFirst;
          if not(eof) then
          begin
            AUFTRAG_R := FieldByName('RID').AsInteger;
            break;
          end;
        end;

        with cABLAGE do
        begin
          ParamByName('CR1').AsString := ZAEHLER_NUMMER;
          ParamByName('CR2').AsString := PLZ;
          ApiFirst;
          if not(eof) then
          begin
            AUFTRAG_R := FieldByName('RID').AsInteger;
            sABLAGE.add(inttostr(AUFTRAG_R));
          end;
        end;

      until yet;

      sRIDs.add(inttostr(AUFTRAG_R));
      if (r MOD 10 = 0) then
      begin
        sRIDs.SaveToFile(DiagnosePath + 'AH3-AUFTRAG-' + inttostr(r) + '.csv');
        sABLAGE.SaveToFile(DiagnosePath + 'AH3-ABLAGE-' + inttostr(r) + '.csv');
      end;

    end;
  end;

  xImport.free;
  {$endif}
  cAUFTRAG.free;
  cABLAGE.free;
  sRIDs.SaveToFile(DiagnosePath + 'AH3-AUFTRAG.csv');
  sABLAGE.SaveToFile(DiagnosePath + 'AH3-ABLAGE.csv');
  sRIDs.free;
  sABLAGE.free;

end;

procedure doKE6(lRID: TgpIntegerList; fb : TFeedback);

{$I Feedback.inc}

var
  n: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  POSTLEITZAHL_R: integer;
begin

  qAUFTRAG := nQuery;

  with qAUFTRAG do
  begin
    sql.add('select POSTLEITZAHL_R, KUNDE_STRASSE, KUNDE_ORT, KUNDE_ORTSTEIL from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;

  with qAUFTRAG do
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      OPen;
      first;
      if not(eof) then
      begin
        POSTLEITZAHL_R := FieldByName('POSTLEITZAHL_R').AsInteger;

        if (POSTLEITZAHL_R > 0) then
          e_w_unlocate(POSTLEITZAHL_R);

        // referenzen wieder eintragen
        _(cFeedback_Function+2,FieldByName('KUNDE_STRASSE').AsString);
        _(cFeedback_Function+3,FieldByName('KUNDE_ORT').AsString);
        POSTLEITZAHL_R := _(cFeedback_Function+4, FieldByName('KUNDE_ORTSTEIL').AsString);

        // Ergebnis eintragen
        if (POSTLEITZAHL_R > 0) then
        begin
          edit;
          FieldByName('POSTLEITZAHL_R').AsInteger := POSTLEITZAHL_R;
          if (FieldByName('KUNDE_ORTSTEIL').AsString = '') then
            FieldByName('KUNDE_ORTSTEIL').AsString := _FeedBack_String;
          post;
        end

      end;
      close;
    end;
  qAUFTRAG.free;

end;

procedure doKE7(lRID: TgpIntegerList);
var
  n, m, l: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  lInternInfo: TStringList;
begin
  // aus den Interninfos diverse felder rauslöschen!

  qAUFTRAG := nQuery;
  lInternInfo := TStringList.create;
  with qAUFTRAG do
  begin
    sql.add('select INTERN_INFO from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;
  with qAUFTRAG do
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      OPen;
      first;
      if not(eof) then
      begin
        e_r_sqlt(FieldByName('INTERN_INFO'),lInternInfo);
        edit;
        for m := 0 to pred(lInternInfo.count) do
        begin
          l := pos('=', lInternInfo[m]);
          if l > 0 then
            lInternInfo[m] := StrFilter(copy(lInternInfo[m], 1, pred(l)), ' ;:,*?/\', true) +
              copy(lInternInfo[m], l, MaxInt);
        end;
        FieldByName('INTERN_INFO').assign(lInternInfo);
        post;
      end;
      close;
    end;
  qAUFTRAG.free;
  lInternInfo.free;

end;

procedure doKE8(lRID: TgpIntegerList);
var
  n: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  lInternInfo: TStringList;
  ZAEHLER_NR_NEU: string;
begin
  // aus den Interninfos diverse felder rauslöschen!

  qAUFTRAG := nQuery;
  lInternInfo := TStringList.create;
  with qAUFTRAG do
  begin
    sql.add('select ZAEHLER_NR_NEU from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;
  with qAUFTRAG do
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      OPen;
      first;
      if not(eof) then
      begin
        ZAEHLER_NR_NEU := FieldByName('ZAEHLER_NR_NEU').AsString;
        if (pos('60', ZAEHLER_NR_NEU) <> 1) then
        begin
          edit;
          FieldByName('ZAEHLER_NR_NEU').AsString := '60' + FieldByName('ZAEHLER_NR_NEU').AsString;
          post;
        end;
      end;
      close;
    end;
  qAUFTRAG.free;
  lInternInfo.free;

end;

procedure doKE9(lRID: TgpIntegerList);
var
  BAUSTELLE_R: integer;
{$ifdef fpc}
{$else}
  xImport: TXLSFile;
{$endif}
  qAUFTRAG: TdboQuery;
  sDiagnose: TStringList;
  sProtokoll: TStringList;

  function rC { readCell } (r, c: integer): string;
  begin
    {$ifdef fpc}
    // imp pend
    {$else}
    result := cutblank(xImport.getCellValue(r, c).ToStringInvariant);
    {$endif}
  end;

var
  c, r: integer;
  Col_ZaehlerNummer: integer;
  Col_Quelle: integer;
  ZAEHLER_NUMMER: string;
  sHeader: TStringList;
  HeaderFieldName: string;

begin

  sHeader := TStringList.create;
  sProtokoll := TStringList.create;

  // um welche Baustelle geht es
  BAUSTELLE_R := e_r_sql('select BAUSTELLE_R from AUFTRAG where RID=' + inttostr(integer(lRID[0])));

  // Excel-Dokument öffnen
  qAUFTRAG := nQuery;
  with qAUFTRAG do
  begin
    sql.add('select PROTOKOLL from');
    sql.add('AUFTRAG');
    sql.add('where');
    sql.add(' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') and');
    sql.add(' (STATUS<>6) and');
    sql.add(' (ZAEHLER_NUMMER=:CROSSREF)');
    for_update(sql);
    OPen;
  end;

  {$ifdef fpc}
  {$else}
  xImport := TXLSFile.create(true);
  sDiagnose := TStringList.create;

  with xImport do
  begin
    OPen(MyProgramPath + 'NonDa/Nachtrag.xls');
    ActiveSheet := 1;

    Col_ZaehlerNummer := -1;
    for c := 1 to ColCountInRow(1) do
    begin
      HeaderFieldName := rC(1, c);
      if (HeaderFieldName = 'Zaehler_Nummer') then
        Col_ZaehlerNummer := c;
      if pos('!', HeaderFieldName) > 0 then
        sHeader.add(inttostr(c) + ';' + StrFilter(HeaderFieldName, '!', true));
    end;

    with qAUFTRAG do
      for r := 2 to RowCount do
      begin
        repeat

          ZAEHLER_NUMMER := rC(r, Col_ZaehlerNummer);
          if ZAEHLER_NUMMER = '' then
            break;

          ParamByName('CROSSREF').AsString := ZAEHLER_NUMMER;
          first;

          if eof then
          begin
            sDiagnose.add(cERRORTEXT + ' Z# "' + ZAEHLER_NUMMER + '" nicht gefunden');
            break;
          end;

          FieldByName('PROTOKOLL').AssignTo(sProtokoll);

          for c := 0 to pred(sHeader.count) do
          begin
            Col_Quelle := strtointdef(nextp(sHeader[c], ';', 0), -1);
            sProtokoll.Values[nextp(sHeader[c], ';', 1)] := rC(r, Col_Quelle);
          end;
          edit;
          FieldByName('PROTOKOLL').assign(sProtokoll);
          post;

        until yet;

      end;

  end;

  xImport.free;
  {$endif}
  qAUFTRAG.free;
  sDiagnose.SaveToFile(DiagnosePath + 'Nachtrag.txt');

  sHeader.free;
  sProtokoll.free;


end;

procedure doHAB(lRID: TgpIntegerList);
var
  n: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  lInternInfo: TStringList;
begin
  // aus den Interninfos diverse felder rauslöschen!

  qAUFTRAG := nQuery;
  lInternInfo := TStringList.create;
  with qAUFTRAG do
  begin
    sql.add('select INTERN_INFO from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;
  with qAUFTRAG do
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      OPen;
      first;
      if not(eof) then
      begin
        e_r_sqlt(FieldByName('INTERN_INFO'),lInternInfo);
        edit;
        ersetze('aegpl_devloc=', 'GeraeteplatzAlt=', lInternInfo);
        ersetze('aeastl_anlage=', 'AnlageAlt=', lInternInfo);
        ersetze('aeger_matnr=', 'MaterialnummerZaehlerAlt=', lInternInfo);
        ersetze('aeger_sparte=', 'Sparte=', lInternInfo);
        FieldByName('INTERN_INFO').assign(lInternInfo);
        post;
      end;
      close;
    end;
  qAUFTRAG.free;
  lInternInfo.free;

end;

procedure doFI1(lRID: TgpIntegerList);
var
  n: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  lProtokoll: TStringList;
  FA: string;
begin
  // FA eintragen!

  qAUFTRAG := nQuery;
  lProtokoll := TStringList.create;
  with qAUFTRAG do
  begin
    sql.add('select ZAEHLER_NUMMER,PROTOKOLL from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;
  with qAUFTRAG do
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      OPen;
      first;
      if not(eof) then
      begin
        e_r_sqlt(FieldByName('PROTOKOLL'),lProtokoll);
        FA := lProtokoll.Values['FA'];
        edit;
        lProtokoll.Values['FA'] :=
        { } FieldByName('ZAEHLER_NUMMER').AsString + cImageExtension;
        if (FA <> '') and (FA <> lProtokoll.Values['FA']) then
          lProtokoll.Values['FA-' + datum10] := FA;
        FieldByName('PROTOKOLL').assign(lProtokoll);
        post;
        close;
      end;
    end;
  qAUFTRAG.free;
  lProtokoll.free;

end;

procedure doFI2(lRID: TgpIntegerList);
var
  IMEI_Hits: TStringList;
  IMEI_LastCall: TStringList;
  StopDatum: TAnfixDate;

  procedure WorkLog(FName: string);
  var
    n, m: integer;
    Log: TStringList;
    datum: TAnfixDate;
    IMEI: string;
    LastCall: string;
  begin
    Log := TStringList.create;
    Log.LoadFromFile(FName);
    for n := pred(Log.count) downto 0 do
    begin

      if (length(Log[n]) = 23) then
        if
        { } (Log[n][5] = '.') and
        { } (Log[n][8] = '.') then
        begin
          datum := date2long(copy(Log[n], 3, 8));
          LastCall := long2date(datum) + ' ' + copy(Log[n], 12, 8);
          if (datum < StopDatum) then
            break;
        end;

      if (pos('    IMEI ', Log[n]) = 1) then
      begin
        IMEI := StrFilter(copy(Log[n], 10, 15), cZiffern);
        if (length(IMEI) = 15) then
        begin
          m := IMEI_Hits.indexof(IMEI);
          if (m = -1) then
          begin
            IMEI_Hits.addobject(IMEI, TObject(integer(1)));
            IMEI_LastCall.add(LastCall);
          end
          else
            IMEI_Hits.objects[m] := TObject(succ(integer(IMEI_Hits.objects[m])));
        end;
      end;
    end;
    Log.free;

  end;

var
  n, o: integer;
  qARTIKEL: TdboQuery;
  IMEI: string;

begin

  StopDatum := DatePlus(DateGet, -60);
  IMEI_Hits := TStringList.create;
  IMEI_LastCall := TStringList.create;

  WorkLog(DiagnosePath+'JonDaServer.log');
  WorkLog(DiagnosePath+'log\JonDaServer.log');

  qARTIKEL := nQuery;
  with qARTIKEL do
  begin
    sql.add('select VERLAGNO,DAUER,LETZTERVERKAUF from ARTIKEL where RID=:CROSSREF');
    for_update(sql);
    OPen;
    for n := 0 to pred(lRID.count) do
    begin
      ParamByName('CROSSREF').AsInteger := lRID[n];
      if not(eof) then
      begin
        IMEI := FieldByName('VERLAGNO').AsString;
        if (length(IMEI) = 15) then
        begin
          o := IMEI_Hits.indexof(IMEI);
          edit;
          if (o <> -1) then
          begin
            FieldByName('DAUER').AsString := inttostrN(integer(IMEI_Hits.objects[o]), 4);
            FieldByName('LETZTERVERKAUF').AsString := IMEI_LastCall[o];
            IMEI_Hits.delete(o);
            IMEI_LastCall.delete(o);
          end
          else
          begin
            FieldByName('DAUER').clear;
          end;
          post;
        end;
      end;
    end;
  end;
  qARTIKEL.free;

  // Um die Anzahl der Treffer ergänzen
  for n := 0 to pred(IMEI_Hits.count) do
    IMEI_Hits[n] :=
    { } IMEI_Hits[n] + ';' +
    { } inttostr(integer(IMEI_Hits.objects[n])) + ';' +
    { } IMEI_LastCall[n];
  IMEI_Hits.Insert(0, 'IMEI;COUNT;LASTCALL');

  // Speichern
  IMEI_Hits.SaveToFile(DiagnosePath + 'IMEI-unbekannt.csv');

  IMEI_Hits.free;

end;

procedure doHAC(lRID: TgpIntegerList);
var
  n: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  lInternInfo: TStringList;
  lProtokoll: TStringList;
begin
  // aus den Interninfos diverse felder rauslöschen!

  qAUFTRAG := nQuery;
  lInternInfo := TStringList.create;
  lProtokoll := TStringList.create;
  with qAUFTRAG do
  begin
    sql.add('select INTERN_INFO,PROTOKOLL from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;
  with qAUFTRAG do
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      OPen;
      first;
      if not(eof) then
      begin
        e_r_sqlt(FieldByName('INTERN_INFO'),lInternInfo);
        e_r_sqlt(FieldByName('PROTOKOLL'),lProtokoll);
        if lInternInfo.indexof('Sparte=Einbau') <> -1 then
        begin
          if (lProtokoll.Values['FA'] = '') then
          begin
            edit;
            lProtokoll.Values['FA'] := ',';
            FieldByName('PROTOKOLL').assign(lProtokoll);
            post;
          end;
        end;
        close;
      end;
    end;
  qAUFTRAG.free;
  lInternInfo.free;
  lProtokoll.free;

end;

procedure doKEA(lRID: TgpIntegerList);
var
  n: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  lProtokoll: TStringList;
  SomeChange: boolean;
  N2: string;
begin
  // aus den Interninfos diverse felder rauslöschen!

  qAUFTRAG := nQuery;
  lProtokoll := TStringList.create;
  with qAUFTRAG do
  begin
    sql.add('select REGLER_NR, REGLER_NR_KORREKTUR, REGLER_NR_NEU, PROTOKOLL from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;
  with qAUFTRAG do
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      OPen;
      first;
      if not(eof) then
      begin
        e_r_sqlt(FieldByName('PROTOKOLL'),lProtokoll);
        SomeChange := false;
        repeat
          if (lProtokoll.Values['N2'] <> '') then
            break;

          N2 := FieldByName('REGLER_NR_NEU').AsString;
          if N2 <> '' then
          begin
            SomeChange := true;
            break;
          end;

          N2 := FieldByName('REGLER_NR_KORREKTUR').AsString;
          if N2 <> '' then
          begin
            SomeChange := true;
            break;
          end;

          N2 := FieldByName('REGLER_NR').AsString;
          if N2 <> '' then
          begin
            SomeChange := true;
            break;
          end;

        until yet;
        if SomeChange then
        begin
          lProtokoll.Values['N2'] := N2;
          edit;
          FieldByName('PROTOKOLL').assign(lProtokoll);
          post;
        end;
      end;
      close;
    end;
  qAUFTRAG.free;
  lProtokoll.free;

end;

procedure doKEB(lRID: TgpIntegerList);
const
  cReplaceTag = 'Objektschlüssel';
var
  n: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  lInternInfo: TStringList;
  ObjektSchluessel: string;
begin
  // aus den Interninfos diverse felder rauslöschen!

  qAUFTRAG := nQuery;
  lInternInfo := TStringList.create;

  with qAUFTRAG do
  begin
    sql.add('select * from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;

  with qAUFTRAG do
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      OPen;
      first;
      if not(eof) then
      begin
        e_r_sqlt(FieldByName('INTERN_INFO'),lInternInfo);
        edit;
        ObjektSchluessel := lInternInfo.Values[cReplaceTag];
        ersetze('X', ' ', ObjektSchluessel);
        lInternInfo.Values[cReplaceTag] := ObjektSchluessel;
        FieldByName('INTERN_INFO').assign(lInternInfo);
        post;
      end;
      close;
    end;
  qAUFTRAG.free;
  lInternInfo.free;
end;

procedure doKEC(lRID: TgpIntegerList);
var
  n: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  lProtokoll: TStringList;
begin

  qAUFTRAG := nQuery;
  lProtokoll := TStringList.create;
  with qAUFTRAG do
  begin
    sql.add('select REGLER_NR, INTERN_INFO from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;
  with qAUFTRAG do
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      OPen;
      first;
      if not(eof) then
      begin
        e_r_sqlt(FieldByName('INTERN_INFO'),lProtokoll);
        edit;
        FieldByName('REGLER_NR').AsString := lProtokoll.Values['aknr'];
        post;
      end;
      close;
    end;
  qAUFTRAG.free;
  lProtokoll.free;
end;

procedure doFK1(lRID: TgpIntegerList);
var
  n,m: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  INTERN_INFO: TStringList;
  sINTERN_INFO: String;
  lValues: TStringList;
  lAll: TStringList;
  lRIDs: TStringList;
  ParameterName, BigID: string;
begin

  qAUFTRAG := nQuery;
  INTERN_INFO := TStringList.create;
  lValues := TStringList.Create;
  lAll := TStringList.Create;
  lRIDs := TStringList.create;
  with qAUFTRAG do
  begin
    sql.add('select INTERN_INFO, ZAEHLWERKE_AUSBAU, ZAEHLWERKE_EINBAU from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;
  with qAUFTRAG do
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      Open;
      first;
      if not(eof) then
      begin
        e_r_sqlt(FieldByName('INTERN_INFO'),INTERN_INFO);
        lValues.Clear;

        // EDIS=, EDIS.1=, EDIS.2=, usw. auslesen!
        for m := 0 to pred(INTERN_INFO.Count) do
        begin
          sINTERN_INFO := AnsiUpperCase(INTERN_INFO[m]);
          if {Wilken} (pos('TGW_OBISCODE',sINTERN_INFO)=1) or
             {MEA   } (pos('EDIS',sINTERN_INFO)=1) then
          begin
           ParameterName := nextp(INTERN_INFO[m],'=',0);
           if (lValues.IndexOf(ParameterName)=-1) then
            lValues.Add(ParameterName);
          end;
        end;

        // In der Art die Werte bestimmen wie es die Ergebnis-
        // Meldung machen würde
        for m := 0 to pred(lValues.Count) do
         lValues[m] := INTERN_INFO.Values[lValues[m]];

        // Lücken wollen wir eigentlich nicht sehen!
        for m := pred(lValues.Count) downto 0 do
         if (lValues[m]='') then
          lValues.delete(m);

        // Ausgeben
        BigID := HugeSingleLine(lValues,', ');
        if (lAll.IndexOf(BigID)=-1) then
        begin
         lAll.Add(BigID);
         lRIDs.Add(IntToStr(AUFTRAG_R));
        end;

        edit;
        FieldByName('ZAEHLWERKE_AUSBAU').AsString := BigID;
        FieldByName('ZAEHLWERKE_EINBAU').AsString := BigID;
        post;

      end;
      close;
    end;
  for n := 0 to pred(lAll.Count) do
   lAll[n] := 'RID'+lRIDs[n]+':'+lAll[n];
  qAUFTRAG.free;
  INTERN_INFO.free;
  lAll.SaveToFile(DiagnosePath+'FK1.log.txt');
  lValues.Free;
  lAll.Free;
  lRIDs.Free;
end;

procedure doKN1(lRID: TgpIntegerList);
var
  qARTIKEL: TdboQuery;
  DAUER: string;
  n: integer;
  sBericht: TStringList;
  ARTIKEL_R: integer;
begin
  sBericht := TStringList.create;
  sBericht.add('RID;DAUER-BISHER;DAUER-NEU');
  qARTIKEL := nQuery;
  with qARTIKEL do
  begin
    sql.add('select DAUER from ARTIKEL where RID=:CROSSREF');
    for_update(sql);
    OPen;
    for n := 0 to pred(lRID.count) do
    begin
      ARTIKEL_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := ARTIKEL_R;
      DAUER := FieldByName('DAUER').AsString;
      if (pos(',', DAUER) > 0) then
      begin
        ersetze(',', ':', DAUER);
        sBericht.add(inttostr(ARTIKEL_R) + ';' + FieldByName('DAUER').AsString + ';' + DAUER);
        edit;
        FieldByName('DAUER').AsString := DAUER;
        post;
      end;
    end;
  end;
  sBericht.SaveToFile(DiagnosePath + 'DAUER.txt');
  qARTIKEL.free;
  sBericht.free;
end;

procedure doKN2(lRID: TgpIntegerList);
var
  n: integer;
  AUFTRAG_R: integer;
  WARENBEWEGUNG_R: integer;
  cAUFTRAG: TdboCursor;
  dWARENBEWEGUNG: TdboScript;
  lProtokoll: TStringList;
  S1, S2: string;
begin
  cAUFTRAG := nCursor;
  dWARENBEWEGUNG := nScript;
  lProtokoll := TStringList.create;
  with dWARENBEWEGUNG do
  begin
    sql.add('update WARENBEWEGUNG set BEWEGT=''Y'' where RID=:CROSSREF');
    prepare;
  end;
  with cAUFTRAG do
  begin
    sql.add('select ZAEHLER_NUMMER,PROTOKOLL from AUFTRAG where RID=:CROSSREF');
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      Open;
      first;
      if not(eof) then
      begin

        // Ev. hier noch Plausibilisieren
        e_r_sqlt(FieldByName('PROTOKOLL'),lProtokoll);
        S1 := lProtokoll.Values['S1'];
        S2 := lProtokoll.Values['S2'];

        WARENBEWEGUNG_R := strtointdef(
          { } FieldByName('ZAEHLER_NUMMER').AsString,
          { } cRID_Null);

        if (WARENBEWEGUNG_R >= cRID_FirstValid) then
          with dWARENBEWEGUNG do
          begin
            ParamByName('CROSSREF').AsInteger := WARENBEWEGUNG_R;
            execute;
          end;

      end;
      close;
    end;
  end;
  lProtokoll.free;
  dWARENBEWEGUNG.free;
  cAUFTRAG.free;
end;

procedure doHE1(lRID: TgpIntegerList);
var
  n, m: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TdboQuery;
  lInternInfo: TStringList;
  sErsetze: TStringList;
begin
  qAUFTRAG := nQuery;
  lInternInfo := TStringList.create;
  sErsetze := TStringList.create;

  sErsetze.LoadFromFile(AnwenderPath + 'Protokoll-Ersetzungen.txt');
  for n := pred(sErsetze.count) downto 0 do
    if pos(';', sErsetze[n]) = 0 then
      sErsetze.delete(n);

  with qAUFTRAG do
  begin
    sql.add('select PROTOKOLL from AUFTRAG where RID=:CROSSREF');
    for_update(sql);
  end;
  with qAUFTRAG do
    for n := 0 to pred(lRID.count) do
    begin
      AUFTRAG_R := integer(lRID[n]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      OPen;
      first;
      if not(eof) then
      begin
        e_r_sqlt(FieldByName('PROTOKOLL'),lInternInfo);
        edit;
        for m := 0 to pred(sErsetze.count) do
          ersetze(nextp(sErsetze[m], ';', 0), nextp(sErsetze[m], ';', 1), lInternInfo);
        FieldByName('PROTOKOLL').assign(lInternInfo);
        post;
      end;
      close;
    end;
  qAUFTRAG.free;
  lInternInfo.free;
end;

procedure doMA1(lRID: TgpIntegerList); // Beleg: gehe eine Mahnstufe zurück
var
  qBELEG: TdboQuery;
  n: integer;
begin
  qBELEG := nQuery;
  with qBELEG do
  begin
    sql.add('select RID,MAHNSTUFE,MAHNUNG,MAHNUNG1,MAHNUNG2,MAHNUNG3,MAHNBESCHEID ');
    sql.add('from BELEG');
    sql.add('where RID=:CROSSREF');
    for_update(sql);
    OPen;
    for n := 0 to pred(lRID.count) do
    begin
      ParamByName('CROSSREF').AsInteger := lRID[n];
      if not(eof) then
      begin
        edit;
        case FieldByName('MAHNSTUFE').AsInteger of
          1:
            begin
              FieldByName('MAHNSTUFE').clear;
              FieldByName('MAHNUNG').clear;
              FieldByName('MAHNUNG1').clear;
            end;
          2:
            begin
              FieldByName('MAHNSTUFE').AsInteger := 1;
              FieldByName('MAHNUNG').assign(FieldByName('MAHNUNG1'));
              FieldByName('MAHNUNG2').clear;
            end;
          3:
            begin
              FieldByName('MAHNSTUFE').AsInteger := 2;
              FieldByName('MAHNUNG').assign(FieldByName('MAHNUNG2'));
              FieldByName('MAHNUNG3').clear;
            end;
        end;
        post;
      end;
    end;
    close;
  end;
  qBELEG.free;
end;

procedure doBO_LU(lRID: TgpIntegerList = nil; MitWeb: boolean = true);

var
 AUFTRAG_R : Integer;
 PARAMETER : string;

 procedure Error(Msg:string;Only4yi:boolean=false);
 begin
   AppendStringsToFile(
    {} IntToStr(AUFTRAG_R) + ';'+
    {} PARAMETER + ';' +
    {} Msg,
    {} ErrorFname('BO1',Only4yi));
 end;

var
 SearchPathList: TStringList;
 MoreSearchPathes: TStringList;
 sFiles: TSTringList;
 spl,sf,n,p,q,o : Integer;
 BAUSTELLE_R, _BAUSTELLE_R: Integer;
 PROTOKOLL,EINSTELLUNGEN,PARAM: TSTringList;
 CharEqual, CharF : Integer;
 RawFotoFName, FotoFName : string;
 FotosOK, AblageOK : boolean;
 CopyToFotosFName, CopyToAblageFName : string;
 CopyToFotosPath, CopyToAblagePath : string;
 FullSuccess: boolean;
 Mask, Root, Suffix: String;
begin
 if (iFotoRecherchePfad<>'') and (iInternetAblagenPfad<>'') then
 begin

   if not(DirExists(iInternetAblagenPfad)) then
   begin
    Error(iInternetAblagenPfad+' existiert nicht!');
    exit;
   end;

   if not(assigned(BO1_RechercheList)) then
   begin

     // Wissensbasis aufbauen
     BO1_RechercheList := TStringList.Create;
     SearchPathList := split(iFotoRecherchePfad);

     // Reduce to valid path names
     for spl := pred(SearchPathList.count) downto 0 do
     begin

      SearchPathList[spl] := cutblank(SearchPathList[spl]);

      if (length(SearchPathList[spl])<2) then
      begin
       SearchPathList.Delete(spl);
       continue;
      end;

      if (SearchPathList[spl][length(SearchPathList[spl])]<>'\') then
      begin
       Error(SearchPathList[spl]+' muss mit einem Backslash (\) enden!');
       SearchPathList.Delete(spl);
       continue;
      end;

      p := pos('*',SearchPathList[spl]);
      if (p>0) then
      begin
       MoreSearchPathes := TStringList.Create;

       Mask := copy(SearchPathList[spl], 1, pred(p));
       Suffix := copy(SearchPathList[spl], succ(p), MaxInt);
       Root := copy(Mask, 1, RevPos('\',Mask));

       dir(Root + cDirMask_Directory,MoreSearchPathes,false,false);
       for o := 0 to pred(MoreSearchPathes.Count) do
        if (pos(Mask, Root+MoreSearchPathes[o])=1) then
          if DirExists(Root+MoreSearchPathes[o]+Suffix) then
            SearchPathList.Add(Root+MoreSearchPathes[o]+Suffix);

       MoreSearchPathes.Free;
       SearchPathList.Delete(spl);
       continue;
      end;

      if not(DirExists(SearchPathList[spl])) then
      begin
       Error(SearchPathList[spl]+' existiert nicht!');
       SearchPathList.Delete(spl);
       continue;
      end;

     end;
     if DebugMode then
      SearchPathList.SaveToFile(DiagnosePath+'BO1-Pfade.txt');

     for spl := 0 to pred(SearchPathList.count) do
     begin

      // alle Bilder hinzufügen (FullPath+FileName)
      sFiles := TStringList.Create;
      dir(SearchPathList[spl]+'*.jpg',sFiles,false);
      for sf := 0 to pred(sFiles.Count) do
        BO1_RechercheList.Add(SearchPathList[spl]+sFiles[sf]);
      sFiles.Free;

     end;
     BO1_rechercheList.sort;
     RemoveDuplicates(BO1_rechercheList);

     if DebugMode then
      BO1_rechercheList.SaveToFile(DiagnosePath+'BO1.txt');
   end;

   if assigned(lRID) then
   begin
     // Welche Bilder sollte es geben?
     _BAUSTELLE_R := cRID_unset;
     EINSTELLUNGEN := nil;
     PARAMETER := '';
     for n := 0 to pred(lRID.Count) do
     begin
      FullSuccess := false;
      AUFTRAG_R := e_r_FotoRID(lRID[n]);
      PROTOKOLL := e_r_sqlt('select PROTOKOLL from AUFTRAG where RID='+IntToStr(AUFTRAG_R));

      // Suche alle "F*"- Parameter
      PARAM := TStringList.Create;
      for p := 0 to pred(PROTOKOLL.count) do
      begin
       CharF := pos('F',PROTOKOLL[p]);
       if (CharF<>1) then
        continue;
       CharEqual := pos('=',PROTOKOLL[p]);
       if (CharEqual<>3) then
        continue;
       PARAM.add(copy(PROTOKOLL[p],1,2));
      end;

      // Überhaupt Arbeit da?
      if (PARAM.Count>0) then
      begin

        PARAM.sort;
        RemoveDuplicates(PARAM);

        BAUSTELLE_R := e_r_sql('select BAUSTELLE_R from AUFTRAG where RID='+IntToStr(AUFTRAG_R));
        if (BAUSTELLE_R<>_BAUSTELLE_R) then
        begin
         EINSTELLUNGEN := e_r_BaustelleEinstellungen(BAUSTELLE_R);
         _BAUSTELLE_R := BAUSTELLE_R;
        end;

        // Prüfe alle "F*" Parameter
        for p := 0 to pred(PARAM.count) do
        begin
          PARAMETER := PARAM[p];
          RawFotoFName := PROTOKOLL.Values[PARAMETER];

          // Errechne den zukünftigen Foto-Namen
          FotoFName :=
           { } nextp (
           { } e_r_FotoName(
           { } fp_Deliver,
           { } AUFTRAG_R,
           { } PARAMETER,
           { } RawFotoFName),
           { } ',', 0);

          // extend search?
          if (pos('000-',RawFotoFName)=1) then
           // Ignore the GeräteID, this will later find the any Foto
           // matching the RID and Parameter
           RawFotoFName := copy(RawFotoFName, 4, MaxInt);

          CopyToFotosPath := e_r_FotoPfad(fp_Deliver, AUFTRAG_R);
          CopyToAblagePath := e_r_FotoAblagePfad(AUFTRAG_R,PARAMETER);

          CopyToFotosFName :=
              { } CopyToFotosPath +
              { } FotoFName;

          CopyToAblageFName :=
              { } CopyToAblagePath +
              { } FotoFName;

          FotosOK := FileExists(CopyToFotosFName);
          AblageOK := FileExists(CopyToAblageFName);

          // Beide Bilder sind da!
          if FotosOK and AblageOK then
          begin
           Error('keine Recherche notwendig',reinInformativ);
           continue;
          end;

          // Eines der Bilder ist da!
          if FotosOK or AblageOK then
          begin
            if FotosOK then
            begin
             if MitWeb then
             begin
               CheckCreateOnce(CopyToAblagePath);
               Error('cp '+CopyToFotosFName+' '+CopyToAblageFName,reinInformativ);
               FileCopy(CopyToFotosFName,CopyToAblageFName);
             end;
             FullSuccess := true;
            end;
            if AblageOK then
            begin
             CheckCreateOnce(CopyToFotosPath);
             Error('cp '+CopyToAblageFName+' '+CopyToFotosFName,reinInformativ);
             FileCopy(CopyToAblageFName, CopyToFotosFName);
             FullSuccess := true;
            end;
            continue;
          end;

          // Recherche ist notwendig!
          for o := pred(BO1_RechercheList.Count) downto 0 do
          begin
            if (pos(RawFotoFName, BO1_RechercheList[o])>0) then
            begin
              if (o>0) then
               if (pos(RawFotoFName, BO1_RechercheList[o-1])>0) then
               begin
                 // Multible Kandidate - exit
                 Error('Es gibt mehrere Kandidaten:',reinInformativ);
                 Error(' '+BO1_RechercheList[o-1],reinInformativ);
                 Error(' '+BO1_RechercheList[o]);
                 break;
               end;

              CheckCreateOnce(CopyToFotosPath);
              Error('cp '+BO1_RechercheList[o]+' '+CopyToFotosFName,reinInformativ);
              FileCopy(BO1_RechercheList[o],CopyToFotosFName);

              if MitWeb then
              begin
                CheckCreateOnce(CopyToAblagePath);
                Error('cp '+BO1_RechercheList[o]+' '+CopyToAblageFName, reinInformativ);
                FileCopy(BO1_RechercheList[o],CopyToAblageFName);
              end;

              FullSuccess := true;
              break;
            end;
          end;
          if not(FullSuccess) then
            Error(RawFotoFName+' nicht gefunden');
        end;
      end else
      begin
        Error('ohne F*=',reinInformativ);
      end;

      PARAM.Free;
      PROTOKOLL.Free;
     end;
  end;
 end;
end;

procedure doBO1(lRID: TgpIntegerList = nil);
begin
 doBO_LU(lRID, true);
end;

procedure doLU1(lRID: TgpIntegerList = nil);
begin
 doBO_LU(lRID, false);
end;

procedure doSC1(lRID: TgpIntegerList = nil);
var
 AUFTRAG_R: Integer;
 PROTOKOLL : TStringList;
 OneLine, New: String;
 HaveUpdates: Boolean;
 n, p, CharF, CharEqual: Integer;
 qAUFTRAG: TdboQuery;
begin
   if assigned(lRID) then
   begin

     qAUFTRAG := nQuery;
     with qAUFTRAG do
     begin
       sql.add('select PROTOKOLL from AUFTRAG where RID=:CROSSREF');
       sql.add(for_update);
     end;

     // Welche Bilder sollte es geben?
     for n := 0 to pred(lRID.Count) do
     begin

      AUFTRAG_R := e_r_FotoRID(lRID[n]);
      PROTOKOLL := e_r_sqlt('select PROTOKOLL from AUFTRAG where RID='+IntToStr(AUFTRAG_R));

      // Suche alle "F*"- Parameter
      HaveUpdates := false;
      for p := 0 to pred(PROTOKOLL.count) do
      begin
       CharF := pos('F',PROTOKOLL[p]);
       if (CharF<>1) then
        continue;
       OneLine := PROTOKOLL[p];
       CharEqual := pos('=',OneLine);
       if (CharEqual<>3) then
        continue;
       // we have F?=*
       New := {} copy(OneLine,1,3)+
              {} '000-'+
              {} IntToStr(AUFTRAG_R)+'-'+
              {} copy(OneLine,1,2)+
              {} '.jpg';
       if (copy(OneLine,7,MaxInt)<>copy(New,7,MaxInt)) then
       begin
         HaveUpdates := true;
         PROTOKOLL[p] := new;
       end;
      end;

      // Save
      if HaveUpdates then
      begin
        with qAUFTRAG do
        begin
          ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
          Open;
          first;
          if not(eof) then
          begin
            edit;
            FieldByName('PROTOKOLL').assign(PROTOKOLL);
            post;
          end;
          close;
        end;
      end;
      PROTOKOLL.Free;
     end;
     qAUFTRAG.Free;
  end;
end;

procedure doBO2;
var
 T : TsTable;
 r : Integer;
 ZaehlerNummerNeu, ZaehlerNummerAlt : string;
begin
 T := TsTable.create;
 with T do
 begin
  InsertFromFile(DiagnosePath+'BO2.csv');
  for r := 1 to RowCount do
  begin
    ZaehlerNummerNeu := readCell(r,'zae_nr_neu');
    if (ZaehlerNummerNeu<>'') then
    begin
      ZaehlerNummerAlt := e_r_sqls(
       'select ZAEHLER_NUMMER from AUFTRAG where '+
       ' (STATUS<>6) and'+
       ' (BAUSTELLE_R=127) and'+
       ' (ZAEHLER_NR_NEU='+SQLstring(ZaehlerNummerNeu)+')');
      if (ZAehlerNummerAlt<>'') then
       writeCell(r-1, 'zae_nr_neu',ZAehlerNummerAlt);
    end;
  end;
  SaveToFile(DiagnosePath+'BO2-out.csv');
 end;
 T.Free;
end;

procedure doBO3;
var
 T : TsTable;
 r,c : Integer;
begin
 T := TsTable.create;
 with T do
 begin
  InsertFromFile(DiagnosePath+'BO3.csv');
  for r := 1 to RowCount do
    for c := 0 to pred(header.Count) do
     if (Header[c]<>'RID') then
       e_x_sql(
        {} 'update AUFTRAG set '+
        {} ' '+header[c]+'='+ SQLstring(readCell(r,c)) + ' '+
        {} 'where'+
        {} ' RID='+ readCell(r,'RID') );
    end;
 T.Free;
end;

end.

