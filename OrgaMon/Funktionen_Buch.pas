{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2018  Andreas Filsinger
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
unit Funktionen_Buch;

//
// b_r_* lesende Buchungsfunktionen
// b_w_* schreibende Buchungsfunktionen
//

//
// [[Make everything as simple as possible, but not simpler.]]
// Albert Einstein
// Gestalte alles so einfach wie möglich, aber nicht einfacher
//

interface

uses
  Classes, gplists,
  anfix32, Geld, dbOrgaMon;

const
  cBUCH_Farbe_Kalt = $2222FF;
  cBUCH_Farbe_OK = $66FF66;
  cBUCH_Farbe_DurchlaufenderPosten = $FF99FF;
  cBUCH_Farbe_edit = $FFFF33;
  cBUCH_Farbe_Ueberzahlung = $FF9933;
  cBUCH_Farbe_Gebucht = $00FF66;
  cBUCH_Farbe_Teilzahlung = $33CCFF;
  cBUCH_Farbe_Neutral = $DDDDDD;

  // stellt sicher, dass zu einem Buchungssatz der
  // initiale Buchungssatz geliefert wird
function e_r_InitialerBuchungssatz(BUCH_R: integer): integer;

// Verbuchen
procedure b_w_buche(BUCH_R: integer; Diagnose: TStrings = nil); overload;
procedure b_w_buche(BUCH_R: TgpIntegerList; Diagnose: TStrings = nil); overload;
procedure b_w_buche(Diagnose: TStrings = nil); overload;

// Kopie erstellen
function b_w_copy(BUCH_R: integer): integer;

// Status einer Forderung
//
function b_r_ForderungStatus(BELEG_R, TEILLIEFERUNG: integer): integer; overload;
function b_r_ForderungStatus(AUSGANGSRECHNUNG_R: integer): integer; overload;

// Forderungs-Ausgleichbuchung!
//
// [PERSON_R,BELEG_R,Betrag,BDatum,BUCH_R,Meldung,Konto,TEILLIEFERUNG,EREIGNIS_R]
//
// Ausgleich über beliebige Zahlungen
//
procedure b_w_ForderungAusgleich(sList: TStrings; Diagnose: TStrings = nil); overload;
procedure b_w_ForderungAusgleich(s: String; Diagnose: TStrings = nil); overload;

// Forderungs-Ausgleichbuchung!
//
// [EREIGNIS_R]
//
// Ausgleich über einen vollständig erhaltenen Lastschrift-Einzug
//
procedure b_w_ForderungAusgleich(EREIGNIS_R: integer; fb : TFeedBack = nil); overload;

//
// Storno des ganzen oder teilweise
//
function b_w_ForderungsAusfall(BELEG_R: integer; Betrag: double = 0.0): double;

//
// Stapel Ausgleich von eingegangenen Lastschrift-Einzügen
procedure b_w_LastschriftAusgleich(sList: TStrings; Diagnose: TStrings = nil);

//
// "Bezahlt" Info wieder zurücknehmen
procedure b_w_ForderungAusgleichStorno(EREIGNIS_R: integer);

// aus einem Beleg die Gesamt-Forderung auf ein Konto buchen!
function b_w_ForderungBuchen(BELEG_R: integer; RechnungsBetrag: double): TStringList;

// eine unbare Konto-Buchung wieder in den Original, unverbuchten Zustand versetzen
procedure b_w_reset(BUCH_R: integer);

// Nachträgliches Verändern des Rechnungsdatums sowie der
// Fälligkeit
procedure b_w_Rechnungsdatum(BELEG_R: integer; RechnungsDatum: TAnfixDate);

// liefert den "üblichen" / "vorbelegten" MwSt Satz aus dem Konto-Deckblatt
function b_r_MwSt(KONTO: string): double; overload;

// Konto überhaupt vorhanden?
function isKonto(KONTO: string): boolean;

// Liste der AR ausgleichenden Konten
function b_r_AusgleichKonten: TStringList;

// Liste der HBCI Konten
function b_r_HBCIKonten: TStringList;

// Liefert die Konto-Nummer zu einem Artikel
function b_r_Konto(SORTIMENT_R: integer): string;

// Liefert den Dateinamen des TWordIndex Suchindex
function b_r_KontoSuchindexFName(KONTO: string): string;

// aktueller Saldo des "Kunden" Kontos
function b_r_PersonSaldo(PERSON_R: integer): double;

// aktueller Saldo ausstehender Lastschrift Einzüge
function b_r_LastschriftSaldo: double;

function b_r_Person_ELV_BLZ(Z_ELV_BLZ, Z_ELV_KONTO: string): string;
function b_r_Person_ELV_Konto(Z_ELV_BLZ, Z_ELV_KONTO: string): string;

// Saldo des Kontos "Konto" am "Datum"
function b_r_KontoSaldo(KONTO: string; Datum: TAnfixDate = ccMaxDate): double;
procedure b_r_SaldenFortschreibung(var ABSCHLUSS : TAnfixDate; cBUCH: TdboCursor; Saldo: TSaldo;  DebugAbschluss : TStringList = nil);

// Berechnet hochgerechnete jährliche Kosten im Zeitraum
// "Von" bis "Bis"
function b_r_Anno(Suchbegriff: string; Von, Bis: TAnfixDate): double;

procedure b_w_preDeleteBuch(BUCH_R: integer);
procedure b_w_DeleteBuch(BUCH_R: integer);

// Funktionen für Zeichenraum Prüfung BIC & IBAN
function Bank_IDs(s: string): string;

// Funktionen für Zeichenraum Prüfung KontoNummer
function Bank_Konto(s: string): string;

// Funktionen zur Infosammlung aus dem Konto-Auszug-Inhalt
function b_r_Auszug_KontoIBAN(s: TStrings): string;
function b_r_Auszug_BLZBIC(s: TStrings): string;
function b_r_Auszug_Inhaber(s: TStrings): string;
function b_r_Auszug_BelegTeillieferung(s: TStrings): TStringList; // BELEG-TL
function b_r_Auszug_Rechnung(s: TStrings): TStringList; // Rechnungsnummer
procedure b_r_Auszug_Homogenisiert(s: TStrings); // Überweisungstext mehrzeilig darstellen

// cVorgang_Lastschrift
function b_r_GutschriftAusLS(VORGANG: string): boolean;

// deutsche IBAN zerlegen in BLZ und Kontonummer
function IBAN_BLZ_Konto(IBAN: string): string;

// Stempel
function b_r_Stempel(STEMPEL_R: Integer):string;
function b_r_Stempel_CheckFile(Needle,Haystack: string):boolean;

// Alle PDF zu einem Buchungssatz
function b_r_PDF(BUCH_R: Integer) : TStringList;

implementation

uses
  Math, SysUtils,
  Funktionen_Basis,
  Funktionen_Auftrag,
  Funktionen_Beleg,
{$IFDEF fpc}
  fpchelper,
{$ELSE}
  IB_Access,
  IB_Components,
{$ENDIF}
{$IFNDEF CONSOLE}
  Datenbank,
{$ENDIF}
  globals, html,

  CareTakerClient,
  WordIndex, DCPcrypt2, DCPmd5;

{ TDataModuleBuchungsMotor }

procedure b_w_buche(BUCH_R: integer; Diagnose: TStrings = nil);

var
  ErrorCount: integer;

  procedure Log(m, s: string);
  begin
    //
    if assigned(Diagnose) then
      Diagnose.add(m + ' b_w_buche(' + inttostr(BUCH_R) + '): ' + s);
    if m = cERRORText then
      inc(ErrorCount);
  end;

var
  qFOLGE: TdboQuery;
  cINITIAL: TdboCursor;
  cPOSTEN: TdboCursor;
  cDECKBLATT: TdboCursor;

  function setBetrag(BUCH_R: integer; Betrag: double): double;
  begin
    result := 0;
    e_x_sql('update BUCH set BETRAG=' + FloatToStrISO(Betrag, 2) + ' where RID=' + inttostr(BUCH_R));
    result := Betrag;
  end;

  procedure FolgeFelderErben;
  begin
    with qFOLGE do
    begin
      FieldByName('TEXT').Assign(cINITIAL.FieldByName('TEXT'));
      FieldByName('BEMERKUNG').Assign(cINITIAL.FieldByName('BEMERKUNG'));
      FieldByName('DATUM').Assign(cINITIAL.FieldByName('DATUM'));
      FieldByName('ERTRAG').Assign(cINITIAL.FieldByName('ERTRAG'));
    end;
  end;

  function SteuerBuchung(pSteuer: string; BruttoBetrag: double; mDatum: TAnfixDate; NETTO_R: integer): double;
  // [gebuchte Steuer]
  var
    pSatz: integer;
    pBetrag: double;
    pSkonto: double;
    SteuerSatz: double;
    VORGANG: string;
  begin
    VORGANG := '';
    result := 0.0;

    // Auf welchen Satz soll gebucht werden
    pSatz := strtointdef(nextp(pSteuer, ';', 0), -1);
    if (pSatz = -1) then
      exit;

    // Welcher Betrag soll gebucht werden
    pBetrag := strtodoubledef(nextp(pSteuer, ';', 1), 0);
    if (pBetrag <> 0) then
    begin

      // ups, eine fixe Vorgabe

      //
      pSkonto := strtodoubledef(nextp(pSteuer, ';', 2), 0);
      if (pSkonto <> 0) then
      begin
        pBetrag := cSkonto(pSkonto, pBetrag);
        VORGANG := format('MWST FIXIERT (%d) -%f.1%% Skonto', [pSatz, pSkonto]);
      end
      else
      begin
        VORGANG := format('MWST FIXIERT (%d)', [pSatz]);
      end;

      // Vorzeichen aus BruttoBetrag übernehmen!
      if ((BruttoBetrag > 0) and (pBetrag < 0)) or ((BruttoBetrag < 0) and (pBetrag > 0)) then
        pBetrag := -pBetrag;

      result := pBetrag;

    end
    else
    begin
      SteuerSatz := e_r_Prozent(pSatz, mDatum);

      if (SteuerSatz <> 0.0) then
      begin
        // den Steueranteil selbst anhand
        // des aktuell gültigen Satzes berechnen
        VORGANG := format('MWST %.1f%% (%d)', [SteuerSatz, pSatz]);
        result := BruttoBetrag - cPreisRundung(BruttoBetrag / (1.0 + (SteuerSatz / 100.0)));
      end;

    end;

    if (result = 0.0) then
      exit;

    // ->auf MwSt-Konto buchen
    with qFOLGE do
    begin
      insert;
      FieldByName('RID').AsInteger := cRID_AutoInc;
      FieldByName('MASTER_R').AsInteger := BUCH_R;
      FieldByName('ZUSAMMENHANG_R').AsInteger := NETTO_R;
      FieldByName('NAME').AsString := cKonto_SatzPrefix + inttostr(pSatz);
      FieldByName('BETRAG').AsFloat := result;
      FieldByName('VORGANG').AsString := VORGANG;

      // copy fields
      FolgeFelderErben;
      post;
    end;

  end;

var

  //
  BruttoBetrag: double;
  GebuchterBetrag: double;
  bDatum: TAnfixDate;
  Quelle: string;
  GEGENKONTO: string;
  Skript: TStringList; // Skript des Master-Buchungssatz
  Regel: TStringList; // Skript des Deckblattes des Zielkontos
  _Betrag: string;
  STEMPEL_R: integer;
  StempelName: string;
  BenderProgramm: string;
  SATZfound: boolean;
  NachBuchen_R: TgpIntegerList;

  procedure BucheStempel;
  begin

    // Stempel laden!
    if cINITIAL.FieldByName('STEMPEL_DOKUMENT').IsNull then
    begin

      // STEMPEL_R sicherstellen!
      STEMPEL_R := cINITIAL.FieldByName('STEMPEL_R').AsInteger;
      if (STEMPEL_R < cRID_FirstValid) then
      begin
        StempelName := Skript.Values['STEMPEL'];
        if (StempelName = '') then
          StempelName := Regel.Values['STEMPEL'];
        if (StempelName = '') then
          raise Exception.create('Ich kann kein STEMPEL= im Deckblatt "' + GEGENKONTO + '" finden');
        if (StempelName = cIni_DeActivate) then
          exit;
        STEMPEL_R := e_r_sql('select RID from STEMPEL where PREFIX=''' + StempelName + '''');
        if (STEMPEL_R < cRID_FirstValid) then
          raise Exception.create('Der Stempel ' + StempelName + ' existiert nicht');
        e_x_sql('update BUCH set STEMPEL_R=' + inttostr(STEMPEL_R) + ' where RID=' + inttostr(BUCH_R));
      end;

      // neuen Wert eintragen Stempel erhöhen
      e_x_sql('update BUCH set STEMPEL_DOKUMENT=' + inttostr(e_w_Stempel(STEMPEL_R)) + ' where RID=' +
        inttostr(BUCH_R));

      // lese die neuen Werte auch in den cINITAL ein!
      cINITIAL.Refresh;
    end;

  end;

  function BucheBeleg: double;

    procedure bucheTeilzahlung(BELEG_R, TEILLIEFERUNG: integer; BruttoBetrag, Forderung: double);
    var
      Teilzahlungen: double;
      AUSGLEICH_R: integer;
      AUSGLEICH_ALT_R: integer;
      ScriptText: TStringList;
    begin
      ScriptText := TStringList.create;

      // ggf. alte Gegenbuchung löschen! (Falls vorhanden!)
      AUSGLEICH_ALT_R := e_r_sql(
        { } 'select RID from BUCH where ' +
        { } ' (NAME=''' + cKonto_Anzahlungen + ''') and' +
        { } ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
        { } ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ') and' +
        { } ' (GEGENKONTO=''' + cKonto_Erloese + ''')');
      if (AUSGLEICH_ALT_R = BUCH_R) then
        raise Exception.create('Löschung der alten ' + cKonto_Anzahlungen +
          '-Ausgleichsbuchung würde zur Löschung des initialen Buchungssatzes (RID=' + inttostr(BUCH_R) + ') führen');
      if (AUSGLEICH_ALT_R >= cRID_FirstValid) then
        b_w_DeleteBuch(AUSGLEICH_ALT_R);

      // Die Teilzahlung als Folgebuchungssatz einbuchen!
      with qFOLGE do
      begin
        insert;
        FieldByName('RID').AsInteger := cRID_AutoInc;
        FieldByName('MASTER_R').AsInteger := BUCH_R;
        FieldByName('NAME').AsString := cKonto_Anzahlungen;
        FieldByName('BETRAG').AsFloat := BruttoBetrag;
        FieldByName('BELEG_R').AsInteger := BELEG_R;
        FieldByName('TEILLIEFERUNG').AsInteger := TEILLIEFERUNG;

        // copy fields
        FolgeFelderErben;
        post;
      end;

      Teilzahlungen := e_r_sqld('select SUM(BETRAG) from BUCH where ' +
        { } ' (NAME=''' + cKonto_Anzahlungen + ''') and' +
        { } ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
        { } ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')');

      // Ist Summe(Anzahlungen)=-Forderung wird ein (neuer) Ausgleichs-Folgesatz erstellt!
      // Dies ist ein automatischer Initialer Buchungssatz, dieser musss
      // jedoch weitergeführt werden
      if isEqual(Forderung, Teilzahlungen) then
      begin
        with qFOLGE do
        begin

          // Wiederverwendung des alten RID
          if (AUSGLEICH_ALT_R < cRID_FirstValid) then
            AUSGLEICH_R := e_w_Gen('GEN_BUCH')
          else
            AUSGLEICH_R := AUSGLEICH_ALT_R;

          //
          ScriptText.add('VORZEICHENWECHSEL=' + cIni_Activate);
          // ScriptText.add('ZWISCHENSATZ=' + cIni_Activate);
          ScriptText.add(format('BELEG=%d;%d;%m', [BELEG_R, TEILLIEFERUNG, Forderung]));

          insert;
          FieldByName('RID').AsInteger := AUSGLEICH_R;
          FieldByName('MASTER_R').AsInteger := AUSGLEICH_R;
          FieldByName('NAME').AsString := cKonto_Anzahlungen;
          FieldByName('GEGENKONTO').AsString := cKonto_Erloese;
          FieldByName('ERTRAG').AsString := cC_True;

          FieldByName('SKRIPT').Assign(ScriptText);
          FieldByName('BETRAG').AsFloat := -Forderung;
          FieldByName('BELEG_R').AsInteger := BELEG_R;
          FieldByName('TEILLIEFERUNG').AsInteger := TEILLIEFERUNG;

          // copy fields
          FolgeFelderErben;
          post;

        end;

        NachBuchen_R.add(AUSGLEICH_R);
      end;

      ScriptText.Free;
    end;

    procedure bucheVollausgleich(BELEG_R, TEILLIEFERUNG: integer; BruttoBetrag: double);
    var
      _Anz, _AnzAuftrag, _AnzGeliefert, _AnzStorniert, _AnzAgent: integer;
      _Rabatt, _EinzelPreis, _MwStSatz: double;
      n, m: integer;
      VersandGesamtSumme: double;
      EinzelpreisNetto: boolean;
      NETTO_R: integer;
      MwSt_Konto_Saver: TMwSt;
      MwSt_Satz_Saver: TMwSt;
      SatzN: integer;
      VERSAND_R: integer;
      _PreisProPosition: double;
      FName, FName_PDF: string;
    begin

      MwSt_Konto_Saver := TMwSt.create;
      MwSt_Satz_Saver := TMwSt.create;

      // Gibt es diese Teillieferung
      VERSAND_R := e_r_sql('select RID from VERSAND where ' +
        { } ' (BELEG_R=' + inttostr(BELEG_R) + ') and ' +
        { } ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')');
      if (VERSAND_R < cRID_FirstValid) then
        raise Exception.create(format('Die Teillieferung (%d) existiert nicht', [TEILLIEFERUNG]));

      // Gibt es das PDF?
      if (not cINITIAL.FieldByName('PERSON_R').IsNull) and
         (not cINITIAL.FieldByName('STEMPEL_R').IsNull) and
         (not cINITIAL.FieldByName('STEMPEL_DOKUMENT').IsNull) then
      begin
        repeat
          FName := e_r_BelegFNameCombined(
            { } cINITIAL.FieldByName('PERSON_R').AsInteger,
            { } BELEG_R,
            { } TEILLIEFERUNG);
          if FileExists(FName) then
           break;
          FName := e_r_BelegFName(
            { } cINITIAL.FieldByName('PERSON_R').AsInteger,
            { } BELEG_R,
            { } TEILLIEFERUNG);
          if FileExists(FName) then
           break;
          FName := '';
        until yet;

        repeat
         if (Fname='') then
          break;
         Fname := ExtractFileNameWithoutExtension(FName)+ '.pdf';
         if not(FileExists(FName)) then
          break;
         FName_PDF :=
           {} cPersonPath(cINITIAL.FieldByName('PERSON_R').AsInteger) +
           {} b_r_Stempel(cINITIAL.FieldByName('STEMPEL_R').AsInteger) +
           {} '-'+
           {} cINITIAL.FieldByName('STEMPEL_DOKUMENT').AsString+
           {} '-'+
           {} ExtractFileName(FName);
         if FileExists(FName_PDF) then
          break;
          FileCopy(Fname,FName_PDF);
        until yet;
      end;

      // Stimmt der Gesamt-Betrag?
      VersandGesamtSumme := e_r_sqld('select SUM(LIEFERBETRAG) from VERSAND where ' +
        { } ' (BELEG_R=' + inttostr(BELEG_R) + ') and ' +
        { } ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')');
      if isOther(VersandGesamtSumme, BruttoBetrag) then
        Log(cWARNINGText, format('Betrag (%m) aus VERSAND ist abweichend', [VersandGesamtSumme]));

      // Übergeordnete Einstellung ermitteln
      EinzelpreisNetto := (e_r_sqls('select EINZELPREIS_NETTO from BELEG where RID=' + inttostr(BELEG_R)) = cC_True);

      // Posten laden und über ihr Sortiment iterieren, netto und Satz buchen!
      with cPOSTEN do
      begin
        sql.clear;
        sql.add('select');
        sql.add(' GELIEFERT.MENGE,');
        sql.add(' GELIEFERT.MENGE_RECHNUNG,');
        sql.add(' GELIEFERT.MENGE_GELIEFERT,');
        sql.add(' GELIEFERT.MENGE_AUSFALL,');
        sql.add(' GELIEFERT.MENGE_AGENT,');
        sql.add(' GELIEFERT.ARTIKEL_R,');
        sql.add(' GELIEFERT.AUSGABEART_R,');
        sql.add(' GELIEFERT.EINHEIT_R,');
        sql.add(' GELIEFERT.PREIS,');
        sql.add(' GELIEFERT.NETTO,');
        sql.add(' GELIEFERT.RABATT,');
        sql.add(' GELIEFERT.MWST,');
        sql.add(' GELIEFERT.FAKTOR,');
        sql.add(' SORTIMENT.KONTO,');
        sql.add(' SORTIMENT.BEZEICHNUNG');
        sql.add('from GELIEFERT');
        sql.add('left join ARTIKEL on');
        sql.add(' (GELIEFERT.ARTIKEL_R=ARTIKEL.RID)');
        sql.add('left join SORTIMENT on');
        sql.add(' (ARTIKEL.SORTIMENT_R=SORTIMENT.RID)');
        sql.add('where');
        sql.add(' (GELIEFERT.BELEG_R=' + inttostr(BELEG_R) + ') and');
        sql.add(' (GELIEFERT.POSNO=' + inttostr(TEILLIEFERUNG) + ') and');
        sql.add(' (GELIEFERT.MENGE_RECHNUNG is not null) and');
        sql.add(' (GELIEFERT.MENGE_RECHNUNG<>0)');
        ApiFirst;
        if eof then
        begin
          Log(cWARNINGText, 'Es gibt hierzu keine Posten in der Tabelle GELIEFERT');
          MwSt_Satz_Saver.add(e_r_Prozent(1, DateGet), BruttoBetrag);
          MwSt_Konto_Saver.add(e_r_Prozent(1, DateGet), BruttoBetrag, '');
        end
        else
        begin
          while not(eof) do
          begin

            // Zwang zur Konto-Zuordnung
            if not(FieldByName('ARTIKEL_R').IsNull) then
              if FieldByName('KONTO').AsString = '' then
                raise Exception.create('Beim Sortiment "' + FieldByName('BEZEICHNUNG').AsString +
                  '" fehlt die Kontozuordnung');

            e_r_PostenInfo(cPOSTEN, false, EinzelpreisNetto, _Anz, _AnzAuftrag, _AnzGeliefert, _AnzStorniert, _AnzAgent,
              _Rabatt, _EinzelPreis, _MwStSatz);
            _PreisProPosition := e_c_Rabatt(e_r_PostenPreis(_EinzelPreis, _Anz,
              FieldByName('EINHEIT_R').AsInteger), _Rabatt);

            // MwSt Tabellen pflegen
            MwSt_Satz_Saver.add(_MwStSatz, _PreisProPosition);
            MwSt_Konto_Saver.add(_MwStSatz, _PreisProPosition, FieldByName('KONTO').AsString);

            ApiNext;
          end;
        end;
        close;
      end;

      // Jetzt die Endsummen berechnen
      MwSt_Satz_Saver.calc(EinzelpreisNetto);
      MwSt_Konto_Saver.calc(EinzelpreisNetto);

      // Stimmt eigentlich der Betrag?
      if (abs(MwSt_Satz_Saver.Brutto - BruttoBetrag) >= cGeld_KleinsterBetrag) then
        raise Exception.create(format('Betrag (%m) aus GELIEFERT ist abweichend', [MwSt_Satz_Saver.Brutto]));

      // aufgeteilt auf die Konten
      for n := 0 to pred(MwSt_Konto_Saver.count) do
        with MwSt_Konto_Saver.MwSt[n] do
          for m := 0 to pred(MwSt_Satz_Saver.count) do
          begin
            if (Satz = MwSt_Satz_Saver.MwSt[m].Satz) then
            begin
              MwSt_Satz_Saver.MwSt[m].NettoSumme := MwSt_Satz_Saver.MwSt[m].NettoSumme - NettoSumme;
              MwSt_Satz_Saver.MwSt[m].MwStSumme := MwSt_Satz_Saver.MwSt[m].MwStSumme - MwStSumme;
              break; // abziehen ist nur einmal notwendig
            end;
          end;

      // Die Reste (=die Rundungsfehler) nun wieder auf die Konten verteilen!
      while isSomeMoney(MwSt_Satz_Saver.Netto) or isSomeMoney(MwSt_Satz_Saver.Steuer) do
      begin

        for m := 0 to pred(MwSt_Satz_Saver.count) do
          with MwSt_Satz_Saver.MwSt[m] do
          begin
            for n := 0 to pred(MwSt_Konto_Saver.count) do
              if (Satz = MwSt_Konto_Saver.MwSt[n].Satz) then
              begin

                // Im Netto Bereich korriegieren
                if isSomeMoney(NettoSumme) then
                begin
                  if NettoSumme > 0 then
                  begin
                    MwSt_Konto_Saver.MwSt[n].NettoSumme := MwSt_Konto_Saver.MwSt[n].NettoSumme + cGeld_KleinsterBetrag;
                    NettoSumme := NettoSumme - cGeld_KleinsterBetrag;
                  end
                  else
                  begin
                    MwSt_Konto_Saver.MwSt[n].NettoSumme := MwSt_Konto_Saver.MwSt[n].NettoSumme - cGeld_KleinsterBetrag;
                    NettoSumme := NettoSumme + cGeld_KleinsterBetrag;
                  end;
                end;

                // Im Brutto-Bereich korriegieren
                if isSomeMoney(MwStSumme) then
                begin
                  if MwStSumme > 0 then
                  begin
                    MwSt_Konto_Saver.MwSt[n].MwStSumme := MwSt_Konto_Saver.MwSt[n].MwStSumme + cGeld_KleinsterBetrag;
                    MwStSumme := MwStSumme - cGeld_KleinsterBetrag;
                  end
                  else
                  begin
                    MwSt_Konto_Saver.MwSt[n].MwStSumme := MwSt_Konto_Saver.MwSt[n].MwStSumme - cGeld_KleinsterBetrag;
                    MwStSumme := MwStSumme + cGeld_KleinsterBetrag;
                  end;
                end;
              end;
          end;
      end;

      // Jetzt die eigentliche Verbuchung
      with qFOLGE do
      begin
        for n := 0 to pred(MwSt_Konto_Saver.count) do
          with MwSt_Konto_Saver.MwSt[n] do
          begin
            NETTO_R := e_w_Gen('GEN_BUCH');

            // ->auf Gegenkonto buchen!
            insert;
            FieldByName('RID').AsInteger := NETTO_R;
            FieldByName('MASTER_R').AsInteger := BUCH_R;
            FieldByName('NAME').AsString := KONTO;
            FieldByName('BETRAG').AsFloat := NettoSumme;
            FieldByName('BELEG_R').AsInteger := BELEG_R;
            FieldByName('TEILLIEFERUNG').AsInteger := TEILLIEFERUNG;

            // copy fields
            FolgeFelderErben;
            post;

            if (MwStSumme <> 0) then
            begin

              // Nachsehen, welcher Satz hier zugeordnet ist
              SatzN := e_r_Satz(Satz, bDatum);
              if (SatzN < 1) then
                raise Exception.create(format('MwSt Satz mit %.1f%% nicht gefunden', [Satz]));

              // Satz - Buchung durchführen
              insert;
              FieldByName('RID').AsInteger := cRID_AutoInc;
              FieldByName('MASTER_R').AsInteger := BUCH_R;
              FieldByName('ZUSAMMENHANG_R').AsInteger := NETTO_R;
              FieldByName('NAME').AsString := cKonto_SatzPrefix + inttostr(SatzN);
              FieldByName('BETRAG').AsFloat := MwStSumme;
              FieldByName('BELEG_R').AsInteger := BELEG_R;
              FieldByName('TEILLIEFERUNG').AsInteger := TEILLIEFERUNG;

              // copy fields
              FolgeFelderErben;
              post;
            end;

          end;
      end;

      MwSt_Konto_Saver.Free;
      MwSt_Satz_Saver.Free;
    end;

    function bucheBelegAusgleich(BELEG_R, TEILLIEFERUNG: integer; BruttoBetrag: double): double;
    var
      Forderung: double;
      cVERSAND: TdboCursor;
    begin
      result := 0;
      repeat

        // Ist der Gesamtbetrag für alle Rechnungen des Beleges
        // zu betrachten?
        if (TEILLIEFERUNG = cTEILLIEFERUNG_FILTER_ALLE) then
        begin

          // Forderungsbetrag ermitteln
          Forderung := e_r_sqld(
            { } 'select SUM(LIEFERBETRAG) from VERSAND where ' +
            { } ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
            { } ' (RECHNUNG is not null)');

          if isZeroMoney(Forderung) then
            if not(e_r_IsRID('BELEG_R', BELEG_R)) then
              raise Exception.create(format('Beleg (%d) existiert nicht', [BELEG_R]));

          if isSomeMoney(Forderung - BruttoBetrag) then
            raise Exception.create(format('Betrag (%m) aus VERSAND ist abweichend', [Forderung]));

          cVERSAND := nCursor;
          with cVERSAND do
          begin
            sql.add(
              { } 'select TEILLIEFERUNG,LIEFERBETRAG from VERSAND where ' +
              { } ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
              { } ' (RECHNUNG is not null) ' +
              { } 'order by' +
              { } ' TEILLIEFERUNG');
            ApiFirst;
            while not(eof) do
            begin
              bucheVollausgleich(
                { } BELEG_R,
                { } FieldByName('TEILLIEFERUNG').AsInteger,
                { } FieldByName('LIEFERBETRAG').AsFloat);
              ApiNext;
            end;

          end;
          cVERSAND.Free;
          break;
        end;

        // Forderungsbetrag ermitteln
        Forderung := e_r_sqld(
          { } 'select SUM(LIEFERBETRAG) from VERSAND where ' +
          { } ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
          { } ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')');

        if isZeroMoney(Forderung) then
          if not(e_r_IsRID('BELEG_R', BELEG_R)) then
            raise Exception.create(format('Beleg (%d) existiert nicht', [BELEG_R]));

        if isSomeMoney(Forderung - BruttoBetrag) then
          bucheTeilzahlung(BELEG_R, TEILLIEFERUNG, BruttoBetrag, Forderung)
        else
          bucheVollausgleich(BELEG_R, TEILLIEFERUNG, BruttoBetrag);

      until yet;
      result := BruttoBetrag;
    end;

    function bucheRest(Betrag: double; KONTO: string = ''): double;
    begin
      if (KONTO = '') then
        KONTO := cKonto_DurchlaufenderPosten;

      with qFOLGE do
      begin
        insert;
        FieldByName('RID').AsInteger := cRID_AutoInc;
        FieldByName('MASTER_R').AsInteger := BUCH_R;
        FieldByName('NAME').AsString := KONTO;
        FieldByName('BETRAG').AsFloat := Betrag;

        // copy fields
        FolgeFelderErben;
        post;
      end;
      result := Betrag;
    end;

  var
    n: integer;
    AnzahlBuchungen: integer;
    sData: string;
    BetragUnberuecksichtigt: double;
    BELEG_R: integer;
    _TEILLIEFERUNG: string;
    TEILLIEFERUNG: integer;
    Betrag: double;
  begin
    result := cGeld_Zero;
    BucheStempel;

    if (Quelle = cKonto_Forderungsverlust) then
    begin
      result := result - bucheRest(-BruttoBetrag);
    end
    else
    begin

      AnzahlBuchungen := 0;

      for n := 0 to pred(Skript.count) do
      begin

        // Beleg-Ausgleich
        if (pos('BELEG=', Skript[n]) = 1) then
        begin
          sData := nextp(Skript[n], 'BELEG=', 1);

          BELEG_R := strtointdef(nextp(sData, ';', 0), cRID_Null);
          _TEILLIEFERUNG := nextp(sData, ';', 1);
          Betrag := strtodoubledef(nextp(sData, ';', 2), BruttoBetrag);
          if (_TEILLIEFERUNG = '*') then
            TEILLIEFERUNG := cTEILLIEFERUNG_FILTER_ALLE
          else
            TEILLIEFERUNG := strtointdef(_TEILLIEFERUNG, 0);

          result :=
          { } result +
          { } bucheBelegAusgleich(
            { } BELEG_R,
            { } TEILLIEFERUNG,
            { } Betrag);
          inc(AnzahlBuchungen);
          continue;
        end;

        // Restbetrag auf Ausbuchungskonto
        if (pos('BETRAG=', Skript[n]) = 1) then
        begin
          BetragUnberuecksichtigt := BruttoBetrag - strtodoubledef(nextp(Skript[n], '=', 1), cGeld_Zero);
          result := result + bucheRest(
            { } BetragUnberuecksichtigt,
            { } nextp(Skript[n], ';', 1));
          continue;
        end;

      end;
      if (AnzahlBuchungen = 0) then
        raise Exception.create('BELEG= wurde nicht angegeben');

    end;

  end;

  function BucheStandard: double;
  var
    n: integer;
    SteuerAnteil: double;
    NETTO_R: integer;
  begin
    result := 0;
    BucheStempel;

    //
    NETTO_R := e_w_Gen('GEN_BUCH');

    // ->auf Gegenkonto buchen!
    with qFOLGE do
    begin
      insert;
      FieldByName('RID').AsInteger := NETTO_R;
      FieldByName('MASTER_R').AsInteger := BUCH_R;
      FieldByName('NAME').AsString := GEGENKONTO;

      // Ereignis gesetzt?
      if (Skript.Values['EREIGNIS'] <> '') then
      begin
        FieldByName('EREIGNIS_R').AsInteger := StrToInt(Skript.Values['EREIGNIS']);
        FieldByName('POSNO').AsInteger := 0;
      end;

      // copy fields
      FolgeFelderErben;
      post;
    end;

    // ev. anderen Betrag verbuchen:
    SteuerAnteil := 0;
    _Betrag := Skript.Values['BETRAG'];
    if (_Betrag <> '') then
      BruttoBetrag := strtodoubledef(_Betrag, 0);

    // direkt angegebene Satz-Buchung!
    SATZfound := false;
    for n := 0 to pred(Skript.count) do
      if (pos(cKonto_SatzPrefix + '=', Skript[n]) = 1) then
      begin
        SteuerAnteil := SteuerAnteil + SteuerBuchung(nextp(Skript[n], '=', 1), BruttoBetrag, bDatum, NETTO_R);
        SATZfound := true;
      end;

    // über die Vorlage angegebene Satzbuchung
    if not(SATZfound) then
    begin
      for n := 0 to pred(Regel.count) do
        if (pos(cKonto_SatzPrefix + '=', Regel[n]) = 1) then
          SteuerAnteil := SteuerAnteil + SteuerBuchung(nextp(Regel[n], '=', 1), BruttoBetrag, bDatum, NETTO_R);
    end;

    // jetzt noch den fehlenden Netto-Anteil verbuchen!
    result := SteuerAnteil + setBetrag(NETTO_R, BruttoBetrag - SteuerAnteil);

  end;

  function BucheFolge: double;
  var
    n, m: integer;
    sBetragParameter: string;
    TeilSteuerAnteil: double;
    TeilSteuerAnteilSumme: double;
    TeilBetragBrutto: double;
    TeilBetragNettoSumme: double;
    ZielKonto: string;
    Regel: TStringList;
    RegelOverwrite: TStringList;
    NETTO_R: integer;
  begin
    result := 0;

    // ev. anderen Betrag verbuchen:
    TeilSteuerAnteilSumme := 0;
    TeilBetragNettoSumme := 0;
    for n := 0 to pred(Skript.count) do
    begin

      if (pos('BETRAG=', Skript[n]) = 1) then
      begin

        // Parameter lesen
        sBetragParameter := nextp(Skript[n], 'BETRAG=', 1);
        TeilBetragBrutto := strtodoubledef(nextp(sBetragParameter, ';', 0), 0);
        ZielKonto := nextp(sBetragParameter, ';', 1);
        RegelOverwrite := split(nextp(sBetragParameter, ';', 2), '|');

        // Deckblatt holen
        Regel := e_r_sqlt('select SKRIPT from BUCH where (NAME=''' + ZielKonto + ''') and (BETRAG is null)');
        RegelOverwrite.AddStrings(Regel);
        Regel.Free;

        // Stempel buchen!
        BucheStempel;

        // Schon mal den RID bestimmen
        NETTO_R := e_w_Gen('GEN_BUCH');

        with qFOLGE do
        begin
          insert;
          FieldByName('RID').AsInteger := NETTO_R;
          FieldByName('MASTER_R').AsInteger := BUCH_R;
          FieldByName('NAME').AsString := ZielKonto;

          // copy fields
          FolgeFelderErben;
          post;
        end;

        // SATZ buchen
        SATZfound := false;
        TeilSteuerAnteil := 0;
        for m := 0 to pred(RegelOverwrite.count) do
          if (pos(cKonto_SatzPrefix + '=', RegelOverwrite[m]) = 1) then
          begin
            TeilSteuerAnteil :=
            { } SteuerBuchung(
              { } nextp(RegelOverwrite[m], '=', 1),
              { } TeilBetragBrutto,
              { } bDatum,
              { } NETTO_R);
            SATZfound := true;
            break;
          end;

        RegelOverwrite.Free;

        if not(SATZfound) then
          raise Exception.create(format(cKonto_SatzPrefix + '= im Deckblatt "%s" nicht gefunden', [ZielKonto]));

        setBetrag(NETTO_R, TeilBetragBrutto - TeilSteuerAnteil);

        TeilBetragNettoSumme := TeilBetragNettoSumme + TeilBetragBrutto - TeilSteuerAnteil;
        TeilSteuerAnteilSumme := TeilSteuerAnteilSumme + TeilSteuerAnteil;
      end;
    end;

    result := TeilBetragNettoSumme + TeilSteuerAnteilSumme;

  end;

begin
  ErrorCount := 0;
  cINITIAL := nCursor;
  cDECKBLATT := nCursor;
  cPOSTEN := nCursor;
  qFOLGE := nQuery;
  Skript := TStringList.create;
  Regel := TStringList.create;
  NachBuchen_R := TgpIntegerList.create;
  GebuchterBetrag := 0;

  try
    repeat

      // vorbereiten für neue Folge-Sätze
      qFOLGE.sql.add('select * from BUCH for update');

      // initialen Buchungssatz laden
      with cINITIAL do
      begin

        sql.add('select * from BUCH where RID=' + inttostr(BUCH_R));
        ApiFirst;
        if eof then
          raise Exception.create('Angegebene Referenz (' + inttostr(BUCH_R) + ') existiert nicht');

        e_r_sqlt(FieldByName('SKRIPT'), Skript);
        if (Skript.Values['ZWISCHENSATZ'] = cIni_Activate) then
        begin

          // es handelt sich um einen Zwischensatz, der im Rahmen einer
          // Folgebuchung enstanden ist. Er ist selbst ein Folgesatz, dessen
          // Brüder bereits gelöscht sind.
          BUCH_R := e_r_InitialerBuchungssatz(BUCH_R);

          // wird bisher nicht verwendet!

        end
        else
        begin
          // prüfen, ob es ein initialer Buchungssatz ist!
          if (BUCH_R <> e_r_InitialerBuchungssatz(BUCH_R)) then
            raise Exception.create('Dies ist kein initialer Buchungssatz');

          // zunächst mal "alte" Folge - Buchungssätze löschen (neues Spiel, neues Glück!)
          e_x_sql(
            { } 'update BUCH set ' +
            { } ' ZUSAMMENHANG_R=null ' +
            { } 'where' +
            { } ' (MASTER_R=' + inttostr(BUCH_R) + ') and' +
            { } ' (ZUSAMMENHANG_R is not null)');
          e_x_sql(
            { } 'delete from BUCH where' +
            { } ' (MASTER_R=' + inttostr(BUCH_R) + ') and' +
            { } ' (RID<>MASTER_R)');

        end;

        // Wichtige Parameter!
        if FieldByName('BETRAG').IsNull then
          raise Exception.create('Betrag ist leer');

        // Ev. Warnungen ausgeben
        if FieldByName('NAME').IsNull then
          Log(cWARNINGText, 'NAME ist leer');
        if FieldByName('GEGENKONTO').IsNull and FieldByName('MD5').IsNull then
          Log(cWARNINGText, 'GEGENKONTO und MD5 ist leer');
        if FieldByName('DATUM').IsNull then
        begin
          Log(cWARNINGText, 'DATUM ist leer');
          bDatum := DateGet;
        end
        else
        begin
          bDatum := datetime2long(FieldByName('DATUM').AsDateTime);
        end;

        // Parameter füllen!
        BruttoBetrag := FieldByName('BETRAG').AsFloat;
        Quelle := FieldByName('NAME').AsString;
        GEGENKONTO := FieldByName('GEGENKONTO').AsString;

      end;
      if (GEGENKONTO = '') then
        break;

      // Vorlagensatz laden, fehlende Parameter ersetzen
      with cDECKBLATT do
      begin
        sql.add('select SKRIPT from BUCH where');
        sql.add(' (BETRAG is null) and');
        sql.add(' (NAME=''' + GEGENKONTO + ''')');
        ApiFirst;
        if eof then
          raise Exception.create('Deckblatt "''' + GEGENKONTO + '''" existiert nicht');
        e_r_sqlt(FieldByName('SKRIPT'), Regel);
      end;

      // auf der anderen Seite Buchen?
      if (Regel.Values['VORZEICHENWECHSEL'] = cIni_Activate) then
        BruttoBetrag := -BruttoBetrag;
      if (Skript.Values['VORZEICHENWECHSEL'] = cIni_Activate) then
        BruttoBetrag := -BruttoBetrag;

      // Buchungs-Programm wählen (Schema)
      // Zunächst aus dem initialen Buchungssatz
      // Zweitrangig aus dem Deckblatt
      BenderProgramm := Skript.Values['Schema'];
      if (BenderProgramm = '') then
        BenderProgramm := Regel.Values['Schema'];

      // Nun das Geld auf andere Konten verteilen
      // (oder nicht!)
      if (BenderProgramm = 'Beleg') then
      begin
        GebuchterBetrag := BucheBeleg;
        break;
      end;

      if (BenderProgramm = 'Folge') then
      begin
        GebuchterBetrag := BucheFolge;
        break;
      end;

      GebuchterBetrag := BucheStandard;

    until yet;

    // Das ganze Geld muss verbraucht sein!
    if isSomeMoney(GebuchterBetrag) then
      if isSomeMoney(GebuchterBetrag - BruttoBetrag) then
        raise Exception.create(format('(RID=%d) Summe der gebuchten Beträge (%m) ist abweichend vom Gesamtbetrag (%m)',
          [BUCH_R, GebuchterBetrag, BruttoBetrag]));

    // Erfolg verbuchen!
    if (GEGENKONTO <> '') then
      e_x_sql('update BUCH set GEBUCHT=CURRENT_TIMESTAMP where RID=' + inttostr(BUCH_R));

  except
    on E: Exception do
    begin
      Log(cERRORText, E.Message);
    end;
  end;

  // Fehler eintragen?
  if (ErrorCount > 0) then
    e_x_sql('update BUCH set GEBUCHT=null where RID=' + inttostr(BUCH_R));

  cINITIAL.Free;
  cDECKBLATT.Free;
  cPOSTEN.Free;
  qFOLGE.Free;
  Skript.Free;
  Regel.Free;

  // Nachbuchungen
  b_w_buche(NachBuchen_R, Diagnose);

  NachBuchen_R.Free;

end;

procedure b_w_buche(BUCH_R: TgpIntegerList; Diagnose: TStrings);
var
  n: integer;
begin
  for n := 0 to pred(BUCH_R.count) do
    b_w_buche(BUCH_R[n], Diagnose);
end;

procedure b_w_reset(BUCH_R: integer);
var
  qBUCH: TdboQuery;
  ScriptText: TStringList;
begin
  qBUCH := nQuery;
  with qBUCH do
  begin
    sql.add('select * from BUCH');
    sql.add('where RID=' + inttostr(BUCH_R));
    for_update(sql);
    open;
    first;
    if not(eof) then
    begin
      ScriptText := TStringList.create;
      e_r_sqlt(FieldByName('SKRIPT'), ScriptText);
      ScriptText.Values['COLOR'] := '';
      ScriptText.Values['BELEG'] := '';
      edit;
      e_w_sqlt(FieldByName('SKRIPT'), ScriptText);
      FieldByName('EREIGNIS_R').clear;
      FieldByName('PERSON_R').clear;
      FieldByName('GEGENKONTO').clear;
      FieldByName('ERTRAG').clear;
      ScriptText.Free;
      post;
    end;
  end;
  qBUCH.Free;
  b_w_buche(BUCH_R);
end;

procedure b_w_ForderungAusgleich(sList: TStrings; Diagnose: TStrings);
var
  n: integer;
  s: string;
  qBELEG: TdboQuery;
  qAUSGANGSRECHNUNG: TdboQuery;
  qBUCH: TdboQuery;
  PERSON_R: integer;
  BELEG_R: integer;
  VALUTA: TANFiXTime;
  Betrag: double;
  BUCH_R: integer;
  EREIGNIS_R: integer;
  KONTO: string;
  TEILLIEFERUNG: integer;
  ScriptText: TStringList;
  InfoText: TStringList;
  Meldung: string;
  lBUCH: TgpIntegerList;
  POSNO: integer;
begin
  lBUCH := TgpIntegerList.create;
  qBELEG := nQuery;
  qBUCH := nQuery;
  qAUSGANGSRECHNUNG := nQuery;
  ScriptText := TStringList.create;
  InfoText := TStringList.create;

  // Forderungen (massenhaft) ausgleichen!
  with qBELEG do
  begin
    sql.add('select');
    sql.add(' RECHNUNGS_BETRAG,');
    sql.add(' DAVON_BEZAHLT,');
    sql.add(' MAHNUNG1,');
    sql.add(' MAHNUNG2,');
    sql.add(' MAHNUNG3,');
    sql.add(' MAHNBESCHEID,');
    sql.add(' MAHNSTUFE');
    sql.add('from BELEG where RID=:CROSSREF');
    sql.add('for update');
  end;

  with qAUSGANGSRECHNUNG do
  begin
    sql.add('select * from AUSGANGSRECHNUNG');
    sql.add('for update');
  end;

  with qBUCH do
  begin
    sql.add('select');
    sql.add(' RID,NAME,SKRIPT,GEGENKONTO,PERSON_R,TEXT,');
    sql.add(' BELEG_R,TEILLIEFERUNG,WERTSTELLUNG,BETRAG,');
    sql.add(' ERTRAG,BEARBEITER_R,EREIGNIS_R,POSNO');
    sql.add('from BUCH');
    sql.add(' where RID=:CROSSREF');
    sql.add('for update');
  end;

  // Komplette Liste buchen
  for n := 0 to pred(sList.count) do
  begin

    // Parameter
    s := sList[n];
    PERSON_R := strtointdef(nextp(s, cOLAPcsvSeparator), cRID_Null);
    BELEG_R := strtointdef(nextp(s, cOLAPcsvSeparator), cRID_Null);
    Betrag := cPreisRundung(nextp(s, cOLAPcsvSeparator));
    VALUTA := date2long(nextp(s, cOLAPcsvSeparator));
    BUCH_R := strtointdef(nextp(s, cOLAPcsvSeparator), cRID_Null);
    Meldung := nextp(s, cOLAPcsvSeparator);
    KONTO := nextp(s, cOLAPcsvSeparator);
    TEILLIEFERUNG := strtointdef(nextp(s, cOLAPcsvSeparator), cRID_Null);
    EREIGNIS_R := strtointdef(nextp(s, cOLAPcsvSeparator), cRID_Null);

    // Autogenerate
    if (BUCH_R < 0) then
      POSNO := -BUCH_R
    else
      POSNO := 0;

    if (PERSON_R = cRID_Person_Lastschrift) then
    begin
      // Vorhandene Buchung (Konto meist Giro) nur ergänzen!
      with qBUCH do
      begin
        ParamByName('CROSSREF').AsInteger := BUCH_R;
        open;
        first;
        if not(eof) then
        begin
          e_r_sqlt(FieldByName('SKRIPT'), ScriptText);
          ScriptText.Values['COLOR'] := cColor_Gruen;
          ScriptText.Values['EREIGNIS'] := inttostr(BELEG_R);
          edit;
          FieldByName('GEGENKONTO').AsString := cKonto_Bank;
          ScriptText.add(Meldung);
          FieldByName('SKRIPT').Assign(ScriptText);
          post;
        end;
        close;
      end;

      // verbuchen sicherstellen
      lBUCH.add(BUCH_R);
    end;

    if (PERSON_R >= cRID_FirstValid) then
    begin

      // Defaults
      if isZeroMoney(Betrag) then
        Betrag := e_r_BelegSaldo(BELEG_R, TEILLIEFERUNG);

      if (BELEG_R >= cRID_FirstValid) then
      begin

        // dumme Redundanz im Beleg buchen
        with qBELEG do
        begin
          ParamByName('CROSSREF').AsInteger := BELEG_R;
          open;
          first;
          if not(eof) then
          begin
            edit;
            FieldByName('DAVON_BEZAHLT').AsFloat := cPreisRundung(FieldByName('DAVON_BEZAHLT').AsFloat + Betrag);

            if isZeroMoney(FieldByName('RECHNUNGS_BETRAG').AsFloat - FieldByName('DAVON_BEZAHLT').AsFloat) then
            begin
              // jetzt als vollständig bezahlt markieren.
              FieldByName('MAHNUNG1').clear;
              FieldByName('MAHNUNG2').clear;
              FieldByName('MAHNUNG3').clear;
              FieldByName('MAHNBESCHEID').clear;
              FieldByName('MAHNSTUFE').clear;
            end;

            post;
          end
          else
          begin
            // Beleg nicht (mehr) gefunden
            BELEG_R := cRID_Null;
          end;
          close;
        end;

        // ggf. noch Konto-Datensatz buchen!
        if (KONTO <> '') then
        begin

          if (BUCH_R >= cRID_FirstValid) then
          begin

            // Vorhandene Buchung (Konto meist Giro) nur ergänzen!
            with qBUCH do
            begin
              ParamByName('CROSSREF').AsInteger := BUCH_R;
              open;
              first;
              if not(eof) then
              begin
                e_r_sqlt(FieldByName('SKRIPT'), ScriptText);
                ScriptText.Values['COLOR'] := cColor_Gruen;
                edit;
                FieldByName('GEGENKONTO').AsString := cKonto_Erloese;
                FieldByName('ERTRAG').AsString := cC_True;

                FieldByName('PERSON_R').AsInteger := PERSON_R;
                if (EREIGNIS_R >= cRID_FirstValid) then
                  FieldByName('EREIGNIS_R').AsInteger := EREIGNIS_R;
                ScriptText.add(format('BELEG=%d;%d;%m', [BELEG_R, TEILLIEFERUNG, Betrag]));
                ScriptText.add(Meldung);
                FieldByName('SKRIPT').Assign(ScriptText);
                post;
              end;
              close;
            end;

          end
          else
          begin

            // Neuanlage wenn Quelle "Kasse", "Lastschrift", oder "Forderungsverlust" ist
            BUCH_R := e_w_Gen('GEN_BUCH');
            e_x_sql('insert into BUCH (RID,DATUM) values(' +
              { } inttostr(BUCH_R) +
              { } ',CURRENT_TIMESTAMP)');

            // Infos zum Beleg bilden!
            InfoText.clear;
            ScriptText.clear;

            InfoText.add(e_r_Person(PERSON_R));
            InfoText.add(format(cRECHNUNGStr + '%d', [e_r_sql(
              { } 'select RECHNUNG from VERSAND where ' +
              { } ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
              { } ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')')]));

            with qBUCH do
            begin
              ParamByName('CROSSREF').AsInteger := BUCH_R;
              open;
              first;
              if not(eof) then
              begin
                edit;
                FieldByName('NAME').AsString := KONTO;
                FieldByName('PERSON_R').AsInteger := PERSON_R;
                if (BELEG_R >= cRID_FirstValid) then
                  FieldByName('BELEG_R').AsInteger := BELEG_R;
                FieldByName('TEILLIEFERUNG').AsInteger := TEILLIEFERUNG;
                if (EREIGNIS_R >= cRID_FirstValid) then
                  FieldByName('EREIGNIS_R').AsInteger := EREIGNIS_R;
                if (POSNO > 0) then
                  FieldByName('POSNO').AsInteger := POSNO;
                ScriptText.add(format('BELEG=%d;%d;%m', [BELEG_R, TEILLIEFERUNG, Betrag]));
                FieldByName('GEGENKONTO').AsString := cKonto_Erloese;
                FieldByName('ERTRAG').AsString := cC_True;
                FieldByName('BETRAG').AsFloat := Betrag;
                if DateOK(VALUTA) then
                  FieldByName('WERTSTELLUNG').AsDateTime := long2datetime(VALUTA);
                FieldByName('TEXT').Assign(InfoText);
                ScriptText.add(Meldung);
                FieldByName('SKRIPT').Assign(ScriptText);
                post;
              end;
              close;
            end;

          end;

          if (lBUCH.indexof(BUCH_R) = -1) then
            lBUCH.add(BUCH_R);

        end;

      end;

      with qAUSGANGSRECHNUNG do
      begin
        insert;

        // Muss Felder
        FieldByName('RID').AsInteger := cRID_AutoInc;
        FieldByName('KUNDE_R').AsInteger := PERSON_R;
        FieldByName('BETRAG').AsFloat := -Betrag;
        if DateOK(VALUTA) then
        begin
          FieldByName('DATUM').AsDateTime := long2datetime(VALUTA);
          FieldByName('VALUTA').AsDateTime := long2datetime(VALUTA);
        end;

        // Optionale Felder
        if (BELEG_R >= cRID_FirstValid) then
          FieldByName('BELEG_R').AsInteger := BELEG_R;
        if (TEILLIEFERUNG <> cRID_Null) then
          FieldByName('TEILLIEFERUNG').AsInteger := TEILLIEFERUNG;
        if (BUCH_R >= cRID_FirstValid) then
          FieldByName('RECHNUNG').AsInteger := BUCH_R;
        if (EREIGNIS_R >= cRID_FirstValid) then
          FieldByName('EREIGNIS_R').AsInteger := EREIGNIS_R;
        post;
      end;

    end;
  end;

  qBELEG.Free;
  qAUSGANGSRECHNUNG.Free;
  qBUCH.Free;
  ScriptText.Free;
  InfoText.Free;

  // Folgebuchungen sicherstellen
  for n := 0 to pred(lBUCH.count) do
    b_w_buche(lBUCH[n], Diagnose);

  lBUCH.Free;
end;

procedure b_w_ForderungAusgleich(s: String; Diagnose: TStrings);
var
  sl: TStringList;
begin
  sl := TStringList.create;
  sl.add(s);
  b_w_ForderungAusgleich(sl, Diagnose);
  sl.Free;
end;

procedure b_w_ForderungAusgleich(EREIGNIS_R: integer; fb : TFeedBack = nil);

{$I Feedback.inc}

var
  BELEG_R, BUCH_R: integer;
  PERSON_R: integer;
  TEILLIEFERUNG: integer;
  Betrag, MandatsSumme: double;
  VALUTA: string;
  sCSV: TStringList;
  sVOLUMEN: TsTable;
  StartRow, r: integer;
begin

  sVOLUMEN := TsTable.create;
  sCSV := e_r_sqlt('select BEMERKUNG from DOKUMENT where EREIGNIS_R=' + inttostr(EREIGNIS_R));
  if (sCSV.count > 1) then
    sVOLUMEN.insertFromStrings(sCSV)
  else
    sVOLUMEN.insertFromFile(MyProgramPath + cHBCIPath + 'DTAUS-' + inttostrN(EREIGNIS_R, 8) + '.csv');
  MandatsSumme := 0.0;

  if DebugMode then
   sVOLUMEN.SaveToFile(DiagnosePath+'VOLUMEN.csv');

  _(cFeedBack_Progressbar_Max,IntToStr(sVOLUMEN.RowCount+2));
  _(cFeedBack_Progressbar_Position);

  StartRow := e_r_sql('select POSNO from EREIGNIS where RID='+IntToStr(EREIGNIS_R));

  _(cFeedBack_Progressbar_Position,IntToStr(StartRow+1));

  with sVOLUMEN do
  begin

    // Valuta aus der Kontobuchung ermitteln
    BUCH_R := e_r_sql(
      { } 'select MASTER_R from BUCH ' +
      { } 'where ' +
      { } ' (EREIGNIS_R=' + inttostr(EREIGNIS_R) + ') and' +
      { } ' (GEGENKONTO is null)');

    VALUTA := e_r_sqls(
      { } 'select CAST(WERTSTELLUNG as DATE) from ' +
      { } 'BUCH where RID=' + inttostr(BUCH_R));

    _(cFeedBack_Progressbar_StepIt);

    long2date(DatePlus(DateGet, 10));
    for r := 1 to RowCount do
    begin

      // Nun die einzelnen Zahlungsereignisse
      PERSON_R := strtointdef(readCell(r, 'PERSON_R'), cRID_Null);
      BELEG_R := strtointdef(readCell(r, 'BELEG_R'), cRID_Null);
      TEILLIEFERUNG := strtointdef(readCell(r, 'TEILLIEFERUNG'), 0);
      Betrag := StrToMoneyDef(readCell(r, 'BETRAG'));

      if (r>StartRow) then
      begin

        // Jetzt den ganzen Rattenschwanz buchen
        b_w_ForderungAusgleich(format(cBuch_Ausgleich, [
          { } PERSON_R,
          { } BELEG_R,
          { } Betrag,
          { } VALUTA,
          { BUCH_R } -r,
          { } 'Lastschrift',
          { } cKonto_Bank,
          { } TEILLIEFERUNG,
          { } EREIGNIS_R]));

        // Bei der Person die Freigabe wieder zurücksetzen
        e_x_sql(
          { } 'update PERSON set ' +
          { } ' Z_ELV_FREIGABE=' +
          { } ' (Z_ELV_FREIGABE - ' + FloatToStrISO(Betrag, 2) + ') ' +
          { } 'where' +
          { } ' (RID=' + inttostr(PERSON_R) + ') and' +
          // wenn überhaupt darüber gebucht wurde
          { } ' (Z_ELV_FREIGABE is not null)');

        // Nun diesen Teilerfolg eintragen
        e_x_sql(
          { } 'update EREIGNIS ' +
          { } 'set' +
          { } ' POSNO='+IntToStr(r)+' ' +
          { } 'where' +
          { } ' (RID=' + inttostr(EREIGNIS_R) + ')');
      end;

      // Falls über ein Mandat gebucht wird, ebenfalls die Summe bilden
      // jedoch der tatsächlich benutzte Betrag, nicht die Mandatshöhe
      if e_r_sql(
        { } 'select count(RID) from BUCH where' +
        { } ' (NAME=' + SQLString(cKonto_Mandat) + ') and' +
        { } ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
        { } ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')')
      { } > 0 then
        MandatsSumme := MandatsSumme + Betrag;

      _(cFeedBack_Progressbar_StepIt);
    end;
  end;

  if isHaben(MandatsSumme) then
  begin
    // Mandat erfüllt
    BUCH_R := e_w_Gen('GEN_BUCH');
    e_x_sql('insert into BUCH (' +
      { 1 } 'RID,' +
      { 2 } 'DATUM,' +
      { 3 } 'NAME,' +
      { 4 } 'EREIGNIS_R,' +
      { 5 } 'BETRAG' +
      { - } ') values(' +
      { 1 } inttostr(BUCH_R) + ',' +
      { 2 } 'CURRENT_TIMESTAMP,' +
      { 3 } SQLString(cKonto_Mandat) + ',' +
      { 4 } inttostr(EREIGNIS_R) + ',' +
      { 5 } FloatToStrISO(-MandatsSumme) + ')');
  end;

  // Ereignis beenden
  e_x_sql(
    { } 'update EREIGNIS ' +
    { } 'set' +
    { } ' BEENDET=CURRENT_TIMESTAMP ' +
    { } 'where' +
    { } ' (RID=' + inttostr(EREIGNIS_R) + ')');

  _(cFeedBack_Progressbar_Position);

  sVOLUMEN.Free;
  sCSV.Free;
end;

function b_w_ForderungsAusfall(BELEG_R: integer; Betrag: double = 0.0): double;
var
  Teilzahlungen, Forderung: double;
  qAUSGLEICH: TdboQuery;
  AUSGLEICH_R: integer;
  ScriptText: TStringList;
begin
  result := Betrag;

  // wenn es Teilzahlungen gab ist nun alles ausgeglichen
  Teilzahlungen := e_r_BelegTeilzahlungen(BELEG_R);

  repeat
    if isZeroMoney(Teilzahlungen) then
     break;

      // Forderungsverlust in den Beleg eintragen
      e_x_sql('insert into POSTEN (BELEG_R,MENGE,ARTIKEL,PREIS,MWST) values (' +
        { } inttostr(BELEG_R) + ',' +
        { } '1,' +
        { } SQLString('Forderungsverlust') + ',' +
        { } FloatToStrISO(-Betrag) + ',' +
        { } FloatToStrISO(iMwStSatzManuelleArtikel) + ')');

      // eine weitere Teillieferung buchen
      if (e_w_BelegBuchen(BELEG_R)='') then
      begin
        result := cGeld_KeinElement;
        break;
      end;

      // nun die "neue" Gesamtforderung berechnen
      Forderung := e_r_BelegForderungen(BELEG_R);

      if isOther(Teilzahlungen, Forderung) then
        break;

        // Es ist Zeit für einen Vollausgelich!
        ScriptText := TStringList.create;
        qAUSGLEICH := nQuery;
        AUSGLEICH_R := e_w_Gen('GEN_BUCH');
        with qAUSGLEICH do
        begin
          sql.add('select * from BUCH for update');

          //
          ScriptText.add('VORZEICHENWECHSEL=' + cIni_Activate);
          // ScriptText.add('ZWISCHENSATZ=' + cIni_Activate);
          ScriptText.add(format('BELEG=%d;*;%m', [BELEG_R, Forderung]));

          insert;
          FieldByName('RID').AsInteger := AUSGLEICH_R;
          FieldByName('MASTER_R').AsInteger := AUSGLEICH_R;
          FieldByName('NAME').AsString := cKonto_Anzahlungen;
          FieldByName('GEGENKONTO').AsString := cKonto_Erloese;
          FieldByName('ERTRAG').AsString := cC_True;
          FieldByName('DATUM').AsDateTime := now;
          FieldByName('SKRIPT').Assign(ScriptText);
          FieldByName('BETRAG').AsFloat := -Forderung;
          FieldByName('BELEG_R').AsInteger := BELEG_R;
          post;

        end;
        qAUSGLEICH.Free;
        ScriptText.Free;
        b_w_buche(AUSGLEICH_R);
        result := cGeld_Zero;

  until yet;
end;

procedure b_w_LastschriftAusgleich(sList: TStrings; Diagnose: TStrings = nil);
var
  n: integer;
  PERSON_R, EREIGNIS_R: integer;
  s: string;
begin
  for n := 0 to pred(sList.count) do
  begin
    s := sList[n];
    PERSON_R := strtointdef(nextp(s, cOLAPcsvSeparator), cRID_Null);
    EREIGNIS_R := strtointdef(nextp(s, cOLAPcsvSeparator), cRID_Null);
    if (PERSON_R = cRID_Person_Lastschrift) then
      b_w_ForderungAusgleich(EREIGNIS_R);
  end;
end;

procedure b_w_ForderungAusgleichStorno(EREIGNIS_R: integer);
var
  cBUCH: TdboCursor;
  BELEG_R, TEILLIEFERUNG: integer;
  n: integer;
  Betrag: double;
  lBUCH: TgpIntegerList;
begin

  //
  lBUCH := TgpIntegerList.create;
  cBUCH := nCursor;
  with cBUCH do
  begin
    sql.add(
      { } 'select' +
      { } ' RID,BELEG_R,TEILLIEFERUNG,BETRAG from BUCH ' +
      { } 'where ' +
      { } ' (EREIGNIS_R=' + inttostr(EREIGNIS_R) + ') and ' +
      { } ' (RID=MASTER_R)');

    ApiFirst;
    while not(eof) do
    begin

      //
      lBUCH.add(FieldByName('RID').AsInteger);
      BELEG_R := FieldByName('BELEG_R').AsInteger;
      TEILLIEFERUNG := FieldByName('TEILLIEFERUNG').AsInteger;
      Betrag := FieldByName('BETRAG').AsFloat;

      // Betrag in dem Beleg vermindern
      e_x_sql(
        { } 'update BELEG set' +
        { } ' DAVON_BEZAHLT = DAVON_BEZAHLT - ' + FloatToStrISO(Betrag) + ' ' +
        { } 'where' +
        { } ' (RID=' + inttostr(BELEG_R) + ')');

      // Zahlung in den Ausgangsrechnungen stornieren
      e_x_sql(
        { } 'delete from AUSGANGSRECHNUNG ' +
        { } 'where' +
        { } ' (EREIGNIS_R=' + inttostr(EREIGNIS_R) + ') and' +
        { } ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
        { } ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ') and' +
        { } ' (VORGANG is null)');

      ApiNext;
    end;
  end;
  cBUCH.Free;

  // 1200 -> 8200 Buchungen löschen
  for n := 0 to pred(lBUCH.count) do
    b_w_DeleteBuch(lBUCH[n]);

end;

procedure b_w_Rechnungsdatum(BELEG_R: integer; RechnungsDatum: TAnfixDate);
begin

end;

function e_r_InitialerBuchungssatz(BUCH_R: integer): integer;
begin
  result := e_r_sql('select COALESCE(MASTER_R,RID) from BUCH where RID=' + inttostr(BUCH_R));
end;

function b_w_ForderungBuchen(BELEG_R: integer; RechnungsBetrag: double): TStringList;
var
  cBELEG: TdboCursor;
  qBELEG: TdboQuery;
  qAUSGANGSRECHNUNG: TdboQuery;
  sPARAMETER: TStringList;
  ForderungsFrist: integer;

  // cache
  RechnungsDatum: TDateTime;
  TEILLIEFERUNG: integer;
  PERSON_R: integer;
  RECHNUNGSANSCHRIFT_R: TDOM_Reference;
  ZAHLUNGSPFLICHTIGER_R: TDOM_Reference;
  ZAHLUNGTYP_R: TDOM_Reference;
  FAELLIG: TDateTime;
begin
  result := nil;
  sPARAMETER := TStringList.create;
  qAUSGANGSRECHNUNG := nQuery;
  qBELEG := nQuery;
  cBELEG := nCursor;
  RechnungsDatum := cIllegalDate;
  try

    with cBELEG do
    begin
      sql.add('select RECHNUNG, TEILLIEFERUNG, PERSON_R, RECHNUNGSANSCHRIFT_R, ');
      sql.add(' INTERN_INFO, ZAHLUNGSPFLICHTIGER_R, ZAHLUNGTYP_R');
      sql.add('from BELEG where RID=' + inttostr(BELEG_R));
      ApiFirst;
      TEILLIEFERUNG := FieldByName('TEILLIEFERUNG').AsInteger;
      PERSON_R := FieldByName('PERSON_R').AsInteger;
      RECHNUNGSANSCHRIFT_R := FieldByName('RECHNUNGSANSCHRIFT_R').AsInteger;
      ZAHLUNGSPFLICHTIGER_R := FieldByName('ZAHLUNGSPFLICHTIGER_R').AsInteger;
      ZAHLUNGTYP_R := FieldByName('ZAHLUNGTYP_R').AsInteger;
      e_r_sqlt(FieldByName('INTERN_INFO'), sPARAMETER);

      // Rechnungsdatum bestimmen, Vorbelegung bei TL=0 möglich!
      if (TEILLIEFERUNG = 0) and not(FieldByName('RECHNUNG').IsNull) then
        RechnungsDatum := FieldByName('RECHNUNG').AsDateTime
      else
        RechnungsDatum := now;
    end;

    if (PERSON_R >= cRID_FirstValid) then
    begin

      // den Zahlungstyp bestimmen
      ForderungsFrist := e_r_ZahlungFrist(PERSON_R);

      // hier noch erweiterte Fälligkeitslogik einfügen
      FAELLIG := long2datetime(DatePlus(datetime2long(RechnungsDatum), ForderungsFrist));

      // (muss noch in das normale Kontenschema verschoben werden!)
      with qAUSGANGSRECHNUNG do
      begin
        sql.add('select * from AUSGANGSRECHNUNG for update');
        insert;
        FieldByName('RID').AsInteger := cRID_AutoInc;
        FieldByName('DATUM').AsDateTime := RechnungsDatum;
        FieldByName('VORGANG').AsString := cVorgang_Rechnung;
        FieldByName('VALUTA').AsDateTime := FAELLIG;
        FieldByName('BELEG_R').AsInteger := BELEG_R;
        FieldByName('KUNDE_R').AsInteger := PERSON_R;
        if (RECHNUNGSANSCHRIFT_R >= cRID_FirstValid) then
          FieldByName('MANDANT_R').AsInteger := RECHNUNGSANSCHRIFT_R;
        if (ZAHLUNGSPFLICHTIGER_R >= cRID_FirstValid) then
          FieldByName('ZAHLUNGSPFLICHTIGER_R').AsInteger := ZAHLUNGSPFLICHTIGER_R;
        if (ZAHLUNGTYP_R >= cRID_FirstValid) then
          FieldByName('ZAHLUNGTYP_R').AsInteger := ZAHLUNGTYP_R;
        FieldByName('TEILLIEFERUNG').AsInteger := TEILLIEFERUNG;
        FieldByName('BETRAG').AsFloat := RechnungsBetrag;
        FieldByName('RECHNUNG').AsInteger := e_r_sql('select RECHNUNG from VERSAND where' + ' (BELEG_R=' +
          inttostr(BELEG_R) + ') and' + ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')');
        if (sPARAMETER.count > 0) then
          FieldByName('TEXT').Assign(sPARAMETER);
        post;
      end;

      // Jetzt noch im Beleg buchen (Redundanz in "RECHNUNGS_BETRAG", entfällt langfristig!)
      with qBELEG do
      begin
        sql.add('select');
        sql.add(' TEILLIEFERUNG, ZAHLUNGSPFLICHTIGER_R,');
        sql.add(' RECHNUNGS_BETRAG, RECHNUNG, FAELLIG,');
        sql.add(' INTERN_INFO, NUMMER, ZAHLUNGTYP_R');
        sql.add('from BELEG where RID=' + inttostr(BELEG_R) + ' for update');
        open;
        edit;
        FieldByName('RECHNUNGS_BETRAG').AsFloat := FieldByName('RECHNUNGS_BETRAG').AsFloat + RechnungsBetrag;
        FieldByName('TEILLIEFERUNG').AsInteger := succ(TEILLIEFERUNG);
        FieldByName('RECHNUNG').AsDateTime := RechnungsDatum;
        FieldByName('FAELLIG').AsDateTime := FAELLIG;
        if (RechnungsBetrag > 0) then
        begin
          FieldByName('NUMMER').clear;
          FieldByName('ZAHLUNGSPFLICHTIGER_R').clear;
          FieldByName('ZAHLUNGTYP_R').clear;
        end;
        post;
      end;
    end;

  except
    on E: Exception do
    begin
     AppendStringsToFile(E.Message, DiagnosePath+'BUCH-ERROR-'+inttostr(DateGet)+'.log.txt', Uhr8);
    end;
  end;
  qBELEG.Free;
  cBELEG.Free;
  qAUSGANGSRECHNUNG.Free;
  sPARAMETER.Free;
end;

procedure b_w_buche(Diagnose: TStrings);
var
  ALL: TgpIntegerList;
begin
  ALL := e_r_sqlm('select RID from BUCH where' + ' (RID=MASTER_R) and (BETRAG is not null)');
  b_w_buche(ALL, Diagnose);
  ALL.Free;
end;

function b_w_copy(BUCH_R: integer): integer;
var
  cBUCH: TdboCursor;
  qBUCH: TdboQuery;
  BlackList: TStringList;
  n: integer;
begin
  result := cRID_Null;
  cBUCH := nCursor;
  qBUCH := nQuery;
  BlackList := TStringList.create;
  try
    result := e_w_Gen('GEN_BUCH');

    BlackList.add('RID');
    BlackList.add('MASTER_R');
    BlackList.add('ZUSAMMENHANG_R');
    BlackList.add('EREIGNIS_R');
    BlackList.add('STEMPEL_R');
    BlackList.add('STEMPEL_NO');
    BlackList.add('STEMPEL_DOKUMENT');
    BlackList.add('GEBUCHT');
    BlackList.add('MOMENT');
    BlackList.add('MD5');

    with cBUCH do
    begin
      sql.add('select * from BUCH where RID=' + inttostr(BUCH_R));
      ApiFirst;
      if eof then
        raise Exception.create('BUCH_R nicht gefunden');
    end;

    with qBUCH do
    begin
      sql.add('select * from BUCH for update');
      insert;
      for n := 0 to pred(FieldCount) do
        if (BlackList.indexof(Fields[n].FieldName) = -1) then
          Fields[n].Assign(cBUCH.FieldByName(Fields[n].FieldName));
      FieldByName('RID').AsInteger := result;
      post;
    end;

  except
    on E: Exception do
    begin
      AppendStringsToFile(E.Message + '(' + inttostr(BUCH_R) + ')', ErrorFName('b_w_Copy'), Uhr8);
    end;

  end;
  cBUCH.Free;
  qBUCH.Free;
  BlackList.Free;
end;

const
  isKonto_Cache: TStringList = nil;

function isKonto(KONTO: string): boolean;
var
  i: integer;
begin

  if not(assigned(isKonto_Cache)) then
    isKonto_Cache := TStringList.create;

  with isKonto_Cache do
  begin
    i := indexof(KONTO);

    if (i = -1) then
    begin
      AddObject(
        { } KONTO,
        { } TObject(
        { } e_r_sql('select count(RID) from BUCH where (BETRAG is null) and NAME=' +
        { } SQLString(KONTO))));
      isKonto_Cache.Sort;
      i := indexof(KONTO);
    end;

    result := integer(Objects[i]) > 0;
  end;
end;

function b_r_AusgleichKonten: TStringList;
begin
  result := b_r_HBCIKonten;
  result.add(cKonto_Kasse); // Kasse
end;

function b_r_HBCIKonten: TStringList;
var
  s: string;
  OneKonto: string;
begin
  result := TStringList.create;
  s := noblank(iKontenHBCI);
  while (s <> '') do
  begin
    OneKonto := nextp(s, ';');
    result.add(nextp(OneKonto, ':', 0));
  end;
end;

function b_r_Konto(SORTIMENT_R: integer): string;
begin
  if (SORTIMENT_R < cRID_FirstValid) then
    result := cKonto_FreierErloes
  else
    result := e_r_sqls('select KONTO from SORTIMENT where RID=' + inttostr(SORTIMENT_R));
end;

procedure b_r_SaldenFortschreibung(var ABSCHLUSS : TAnfixDate; cBUCH: TdboCursor; Saldo: TSaldo; DebugAbschluss : TStringList = nil);
var
 DATUM : TAnfixDate;
 UeberweisungsText: TStringList;
 BETRAG: double;
 AbschlussBetrag: double;
begin
  with cBUCH do
  begin
    DATUM := datetime2long(FieldByName('DATUM').AsDateTime);
    BETRAG := FieldByName('BETRAG').AsFloat;

    if (FieldByName('VORGANG').AsString = cVorgang_Abschluss) then
    begin
      UeberweisungsText := TStringList.create;
      e_r_sqlt(FieldByName('TEXT'), UeberweisungsText);

      if (UeberweisungsText.count = 1) then
        b_r_Auszug_Homogenisiert(UeberweisungsText);
      if (UeberweisungsText.count >= 3) then
      begin
        ABSCHLUSS := Date2Long(nextp(UeberweisungsText[UeberweisungsText.count - 3], 'PER', 1));
        AbschlussBetrag := StrToDoubledef(UeberweisungsText[pred(UeberweisungsText.count)], cGeld_keinElement);

        if DateOK(ABSCHLUSS) and (AbschlussBetrag <> cGeld_keinElement) then
        begin
          saldo.addUmsatz(ABSCHLUSS, BETRAG);
          saldo.addAbschluss(ABSCHLUSS, AbschlussBetrag);
          if DebugMode then
           if assigned(DebugAbschluss) then
           DebugAbschluss.Add(
            {} long2date(DATUM)+';'+
            {} long2date(ABSCHLUSS)+';'+
            {} MoneyToStr(AbschlussBetrag));
        end
        else
        begin
          saldo.addUmsatz(DATUM, BETRAG);
          if DebugMode then
           if assigned(DebugAbschluss) then
           DebugAbschluss.Add(
            {} long2date(DATUM)+';'+
            {} cERRORText+';'+
            {} cERRORText);
        end;
      end;
      UeberweisungsText.Free;
    end else
    begin
     if (DATUM=ABSCHLUSS) then
       saldo.addNachtrag(DATUM, BETRAG)
     else
       saldo.addUmsatz(DATUM, BETRAG);
    end;
  end;
end;

function b_r_KontoSaldo(KONTO: string; Datum: TAnfixDate): double;
var
  cBUCH: TdboCursor;
  ABSCHLUSS: TAnfixDate;
  saldo: TSaldo;
begin
  saldo := TSaldo.create;
  cBUCH := nCursor;
  ABSCHLUSS:= 0;
  with cBUCH do
  begin
    sql.add('select');
    sql.add(' TEXT,BETRAG,DATUM,VORGANG');
    sql.add('from');
    sql.add(' BUCH');
    sql.add('where');
    if DateOK(iBuchFokus) then
      sql.add(' (DATUM >= ''' + long2date(iBuchFokus) + ''') and');
    sql.add(' (NAME=''' + KONTO + ''') and');
    sql.add(' (BETRAG is not null)');
    sql.add('order by');
    sql.add(' DATUM, POSNO');

    ApiFirst;
    while not(eof) do
    begin
      b_r_SaldenFortschreibung(ABSCHLUSS,cBUCH,saldo);
      ApiNext;
    end;
  end;
  result := saldo.saldo(Datum);
  cBUCH.Free;
  saldo.Free;
end;

function b_r_KontoSuchindexFName(KONTO: string): string;
begin
  result :=
  { } SearchDir +
  { } format(
    { } cKontoSuchindexFName,
    { } [ValidateFName(KONTO)]);
end;

const
  b_r_Anno_Konto = '7200';
  b_r_Anno_LogFile = 'b_r_Anno.log.txt';
  b_r_Anno_SearchIndex: TWordIndex = nil;

function b_r_Anno(Suchbegriff: string; Von, Bis: TAnfixDate): double;
var
  FoundElements: TExtendedList;
  i: integer;
  Datum: TAnfixDate;
  Betrag: double;
  cBUCH: TdboCursor;

  // gebildete Werte
  ErstesDatum: TAnfixDate;
  Summe, d1, d2: double;
begin
  if not(assigned(b_r_Anno_SearchIndex)) then
  begin
    b_r_Anno_SearchIndex := TWordIndex.create(nil);
    b_r_Anno_SearchIndex.LoadFromFile(b_r_KontoSuchindexFName(b_r_Anno_Konto));
    if DebugMode then
      FileDelete(DiagnosePath + b_r_Anno_LogFile);
  end;
  ErstesDatum := Bis;
  FoundElements := TExtendedList.create;
  b_r_Anno_SearchIndex.Search(Suchbegriff);
  FoundElements.LogicalOR(b_r_Anno_SearchIndex.FoundList);
  b_r_Anno_SearchIndex.Search(StrFilter(Suchbegriff, cZiffern));
  FoundElements.LogicalOR(b_r_Anno_SearchIndex.FoundList);
  cBUCH := nCursor;
  with cBUCH do
  begin
    sql.add('select DATUM, BETRAG from BUCH where RID=:CROSSREF');
    open;
    Summe := 0.0;
    for i := 0 to pred(FoundElements.count) do
    begin
      ParamByName('CROSSREF').AsInteger := integer(FoundElements[i]);
      ApiFirst;
      Datum := datetime2long(FieldByName('DATUM').AsDateTime);
      Betrag := FieldByName('BETRAG').AsFloat;

      if (Datum >= Von) and (Datum <= Bis) then
      begin
        if DebugMode then
          AppendStringsToFile(
            { } Suchbegriff + ';' +
            { } 'Y' + ';' +
            { } long2date(Datum) + ';' +
            { } format('%m', [Betrag]), DiagnosePath + b_r_Anno_LogFile);
        Summe := Summe + Betrag;
        ErstesDatum := min(ErstesDatum, Datum);
      end
      else
      begin
        if DebugMode then
          AppendStringsToFile(
            { } Suchbegriff + ';' +
            { } 'N' + ';' +
            { } long2date(Datum) + ';' +
            { } format('%m', [Betrag]), DiagnosePath + b_r_Anno_LogFile);
      end;
    end;
  end;
  cBUCH.Free;
  FoundElements.Free;
  d1 := DateDiff(ErstesDatum, Bis);
  if (d1 > 30.0) then
  begin
    d2 := 365.0;
    // Am Ende des Betrachtungszeitraumes haben die Personen immer noch
    // ein Guthaben! Im Schnitt nehme ich 25,00 Euro an!
    Summe := Summe + 25.0;
    result := cPreisRundung((Summe / d1) * d2);
  end
  else
  begin
    result := 0.0;
  end;
  if DebugMode then
    AppendStringsToFile(
      { } Suchbegriff + ';' +
      { } 'S' + ';' +
      { } format('%s|%d', [long2date(ErstesDatum) + '-' + long2date(Bis), round(d1)]) + ';' +
      { } format('%m', [result]), DiagnosePath + b_r_Anno_LogFile);
end;

function b_r_PersonSaldo(PERSON_R: integer): double;
begin
  //
  result := e_r_sqld('select sum(BETRAG) from AUSGANGSRECHNUNG where KUNDE_R=' + inttostr(PERSON_R));
  // Zukunft
  (*
    e_r_sqld(
    'select sum(BETRAG) from BUCH where (PERSON_R='+inttostr(PERSON_R)+') and '+
    ' NAME in ('+cKonto_Forderungen+cKonto_Anzahlungen+')

  *)
end;

function b_r_LastschriftSaldo: double;
var
  cEREIGNIS: TdboCursor;
  sINFO: TStringList;
begin
  result := 0.0;
  cEREIGNIS := nCursor;
  sINFO := TStringList.create;
  with cEREIGNIS do
  begin
    sql.add('select INFO from EREIGNIS where');
    sql.add(' (ART=11) and');
    sql.add(' (BEENDET is NULL)');
    ApiFirst;
    while not(eof) do
    begin
      e_r_sqlt(FieldByName('INFO'), sINFO);
      result := result + StrToMoneyDef(sINFO.Values['BETRAG']);
      ApiNext;
    end;
  end;
  cEREIGNIS.Free;
  sINFO.Free;
end;

procedure b_w_preDeleteBuch(BUCH_R: integer);
begin

  // zunächst die Zusammenhang-Referenz entfernen
  e_x_sql('update BUCH set ' +
    { } ' ZUSAMMENHANG_R=null ' +
    { } 'where' +
    { } ' (MASTER_R=' + inttostr(BUCH_R) + ') and' +
    { } ' (ZUSAMMENHANG_R is not null)');

  // nun die Folgebuchungssätze löschen
  e_x_sql('delete from BUCH where ' +
    { } ' (MASTER_R=' + inttostr(BUCH_R) + ') and' +
    { } ' (RID<>' + inttostr(BUCH_R) + ')');

  // Referenzen auf den Hauptdatensatz nullen
  e_w_dereference(BUCH_R, 'DOKUMENT', 'BUCH_R');
  e_w_dereference(BUCH_R, 'TICKET', 'BUCH_R');
end;

procedure b_w_DeleteBuch(BUCH_R: integer);
begin
  // MASTER_R holen!
  BUCH_R := e_r_InitialerBuchungssatz(BUCH_R);

  // Folge Buchungssätze löschen
  if BUCH_R >= cRID_FirstValid then
  begin
    b_w_preDeleteBuch(BUCH_R);

    // Den eigentlichen Buchungssatz löschen
    e_x_sql('delete from BUCH where RID=' + inttostr(BUCH_R));
  end;
end;

function b_r_MwSt(KONTO: string): double; overload;
var
  Skript: TStringList;
  Satz: string;
begin
  Skript := e_r_sqlt(
    { } 'select SKRIPT from BUCH where ' +
    { } '(BETRAG is null) and ' +
    { } '(NAME = ''' + KONTO + ''')');
  Satz := Skript.Values[cKonto_SatzPrefix];
  Skript.Free;
  if (Satz = '') then
    result := cSatz_keinElement
  else
    result := e_r_Prozent(strtointdef(Satz, 0));
end;

function Bank_IDs(s: string): string;
begin
  result := StrFilter(s, cZiffern + cBuchstaben);
  while (pos('0', result) = 1) do
    system.Delete(result, 1, 1);
end;

function Bank_Konto(s: string): string;
begin
  result := StrFilter(s, cZiffern);
  while (pos('0', result) = 1) do
    system.Delete(result, 1, 1);
end;

function b_r_Auszug_KontoIBAN(s: TStrings): string;
var
  n: integer;
begin
  result := '';
  for n := 0 to pred(s.count) do
    if pos(cKontoStr, s[n]) > 0 then
    begin
      result := Bank_IDs(ExtractSegmentBetween(s[n], cKontoStr, cBLZStr));
      break;
    end;
end;

function b_r_Auszug_BLZBIC(s: TStrings): string;
var
  n, k: integer;
begin
  result := '';
  for n := 0 to pred(s.count) do
  begin
    k := pos(cBLZStr, s[n]);
    if (k > 0) then
    begin
      result := Bank_IDs(copy(s[n], k + length(cBLZStr), MaxInt));
      break;
    end;
  end;
end;

function b_r_Auszug_Inhaber(s: TStrings): string;
var
  n: integer;
  ganzesPaket: string;
begin
  result := '';
  ganzesPaket := HugeSingleLine(s, ' ');
  if (pos(cBLZStr, ganzesPaket) > 0) or (pos(cRECHNUNGStr, ganzesPaket) > 0) then
    for n := 0 to pred(s.count) do
    begin
      if (pos(cBLZStr, s[n]) = 0) and (pos(cRECHNUNGStr, s[n]) = 0) then
        result := cutblank(result + ' ' + s[n])
      else
        break;
    end;
  ersetze('''', '', result);
  ersetze('"', '', result);
  result := copy(result, 1, 45);
end;

function b_r_Auszug_BelegTeillieferung(s: TStrings): TStringList; // BELEG-TL
var
  n, k, l, m: integer;
  c: Char;
begin

  // k Position des '-'
  // l Positions des String Anfangs
  result := TStringList.create;
  for n := 0 to pred(s.count) do
  begin
    k := pos('-0', s[n]);
    if (k > 0) then
    begin

      // Nun den Anfang suchen!
      l := k;
      while (l > 1) do
      begin
        c := s[n][l - 1]; // Look ahead!
        if not(c in ['0' .. '9']) then
          break;
        dec(l);
      end;

      // Nun das Ende suchen
      m := k + 1;
      while (m < length(s[n])) do
      begin
        c := s[n][m + 1]; // Look ahead!
        if not(c in ['0' .. '9']) then
          break;
        inc(m);
      end;

      result.add(copy(s[n], l, m - l + 1));
    end;
  end;
end;

function b_r_Auszug_Rechnung(s: TStrings): TStringList; // Rechnungsnummer
var
  sWords: TWordIndex;
  n: integer;
begin
  result := TStringList.create;
  if (s.count > 0) then
  begin
    sWords := TWordIndex.create(nil, e_r_RechnungsNummerAnzahlDerStellen);
    with sWords do
    begin
      // Überweisungstexte hinzunehmen
      for n := pred(s.count) downto 0 do
        if (pos(cBLZStr, s[n]) = 0) then
          // bitte nicht die Kontonummern-Zeile!
          addwords(s[n], nil);

      // Führende Nullen löschen
      for n := 0 to pred(count) do
        while (pos('0', strings[n]) = 1) do
          strings[n] := copy(strings[n], 2, MaxInt);

      JoinDuplicates(false);

      // nur zahlen der vereinbarten Länge benutzen
      Filter(cZiffern, e_r_RechnungsNummerAnzahlDerStellen + 1);
    end;
    result.AddStrings(sWords);
    sWords.Free;
  end;
end;

procedure b_r_Auszug_Homogenisiert(s: TStrings); // Überweisungstext mehrzeilig darstellen

  function SplitIfHit(Token: string; Before: boolean): boolean;
  var
    c, k: integer;
    FullLine: string;
  begin
    result := false;
    c := s.count;
    if (c > 0) then
    begin
      k := pos(Token, s[pred(c)]);
      if (k > 0) then
      begin
        FullLine := s[pred(c)];
        if Before then
        begin
          s[pred(c)] := copy(FullLine, 1, pred(k));
          s.add(copy(FullLine, k, MaxInt));
        end
        else
        begin
          s[pred(c)] := copy(FullLine, 1, pred(k) + length(Token));
          s.add(copy(FullLine, k + length(Token), MaxInt));
        end;
        result := true;
      end;
    end;
  end;

begin
  // schaue immer auf die letzte Zeile, wenn das Element vorkommt -> mache den Split
  if SplitIfHit('SALDO', true) then
  begin
    SplitIfHit('RECHNUNGSABSCHLUSS', false);
    SplitIfHit('INCL. ', true);
    SplitIfHit('ABSCHLUSSBETRAG', false);
  end;
end;

function b_r_Person_ELV_BLZ(Z_ELV_BLZ, Z_ELV_KONTO: string): string;
begin

  result := '';
  repeat
    // Alte BLZ?
    result := StrFilter(Z_ELV_BLZ, cZiffern);
    if (length(result) = 8) then
      break;

    // aus IBAN?
    if length(Z_ELV_KONTO) > 0 then
      if (pos(Z_ELV_KONTO[1], cBuchstaben) > 0) then
        result := StrFilter(copy(Z_ELV_KONTO, 5, 8), cZiffern);

    if (length(result) = 8) then
      break;

    result := '';

  until yet;
end;

function b_r_Person_ELV_Konto(Z_ELV_BLZ, Z_ELV_KONTO: string): string;
begin
  result := '';
  repeat

    if length(Z_ELV_KONTO) < 11 then
    begin
      result := Bank_Konto(Z_ELV_KONTO);
      break;
    end;

    // DEppBBBBBBBBkkkkkkkkkK
    if (pos('DE', Z_ELV_KONTO) = 1) then
    begin
      result := Bank_Konto(copy(Z_ELV_KONTO, 13, 10));
      break;
    end;

  until yet;
end;

function IBAN_BLZ_Konto(IBAN: string): string;
begin
  result := '';
  if (pos('DE', IBAN) = 1) then
  begin
    IBAN := Bank_IDs(IBAN);
    result :=
    { } copy(IBAN, 5, 8) + ' ' +
    { } Bank_Konto(copy(IBAN, 13, 10));
  end;
end;

var
  b_r_ForderungStatus_cAR1: TdboCursor = nil;
  b_r_ForderungStatus_cAR2: TdboCursor = nil;
  b_r_ForderungStatus_cAR3: TdboCursor = nil;
  b_r_ForderungStatus_EREIGNIS_R: integer = cRID_Unset;
  b_r_ForderungStatus_cER: TdboCursor = nil;

function b_r_ForderungStatus(AUSGANGSRECHNUNG_R: integer): integer;
var
  EREIGNIS_R: integer;
  n: integer;
begin
  if not(assigned(b_r_ForderungStatus_cAR1)) then
  begin

    b_r_ForderungStatus_cAR1 := nCursor;
    with b_r_ForderungStatus_cAR1 do
    begin
      sql.add('select EREIGNIS_R from AUSGANGSRECHNUNG ');
      sql.add('where');
      sql.add(' (RID=:CR)');
      open;
    end;

    b_r_ForderungStatus_cAR2 := nCursor;
    with b_r_ForderungStatus_cAR2 do
    begin
      sql.add('select');
      sql.add(' count(AR.RID) ');
      sql.add('from');
      sql.add(' AUSGANGSRECHNUNG AR ');
      sql.add('join');
      sql.add(' BELEG ');
      sql.add('on');
      sql.add(' (AR.BELEG_R=BELEG.RID) and');
      sql.add(' ((BELEG.DAVON_BEZAHLT IS NULL) or');
      sql.add('  (BELEG.RECHNUNGS_BETRAG - BELEG.DAVON_BEZAHLT >= 0.01)');
      sql.add(' ) ');
      sql.add('join');
      sql.add(' PERSON ');
      sql.add('on');
      sql.add(' (COALESCE(BELEG.RECHNUNGSANSCHRIFT_R,BELEG.PERSON_R)=PERSON.RID) ');
      sql.add('left join');
      sql.add(' ZAHLUNGTYP ');
      sql.add('on');
      sql.add(' (PERSON.ZAHLUNGTYP_R=ZAHLUNGTYP.RID) ');
      sql.add('left join');
      sql.add(' BUCH');
      sql.add('ON');
      sql.add(' (BUCH.NAME=' + SQLString(cKonto_Mandat) + ') and');
      sql.add(' (BUCH.GEBUCHT is null) and');
      sql.add(' (AR.BELEG_R=BUCH.BELEG_R) and');
      sql.add(' (AR.TEILLIEFERUNG=BUCH.TEILLIEFERUNG)');
      sql.add('where');
      sql.add(' (AR.RID=:CR) and');
      sql.add(' (AR.ZAHLUNGTYP_R is null) and');
      sql.add(' (AR.DATUM between (CURRENT_TIMESTAMP-365) and CURRENT_TIMESTAMP) and');
      sql.add(' ((ZAHLUNGTYP.AUTOZAHLUNG=''Y'') or');
      sql.add('  (PERSON.Z_ELV_FREIGABE>=0.01) or');
      sql.add('  (BUCH.BETRAG is not null))');
      open;
    end;

    b_r_ForderungStatus_cER := nCursor;
    with b_r_ForderungStatus_cER do
    begin
      sql.add('select');
      sql.add(' ART,');
      sql.add(' BEENDET');
      sql.add('from');
      sql.add(' EREIGNIS');
      sql.add('where');
      sql.add(' RID=:CR');
      open;
    end;

  end;

  result := cForderung_Unklar;
  repeat

    // Ist ein Ereignis bereits eingetragen
    if (b_r_ForderungStatus_EREIGNIS_R <> cRID_Unset) then
    begin
      EREIGNIS_R := b_r_ForderungStatus_EREIGNIS_R
    end
    else
    begin
      with b_r_ForderungStatus_cAR1 do
      begin
        Params[0].AsInteger := AUSGANGSRECHNUNG_R;
        ApiFirst;
        EREIGNIS_R := Fields[0].AsInteger;
      end;
    end;

    // Es ist noch KEIN Ereignis eingetragen
    if (EREIGNIS_R < cRID_FirstValid) then
    begin

      // Könnte das ein Autozahlungs-Kandidat sein?
      with b_r_ForderungStatus_cAR2 do
      begin
        Params[0].AsInteger := AUSGANGSRECHNUNG_R;
        ApiFirst;
        n := Fields[0].AsInteger;
      end;
      if (n = 1) then
        result := cForderung_Lastschrift_Anstehend
      else
        result := cForderung_Zahlungsart_Frei;
      break;
    end;

    with b_r_ForderungStatus_cER do
    begin
      Params[0].AsInteger := EREIGNIS_R;
      ApiFirst;
      if (Fields[0].AsInteger <> eT_ZahlungPerLastschrift) then
      begin
        result := cForderung_Zahlungsart_Unbekannt;
        break;
      end;
      if (Fields[1].IsNull) then
        result := cForderung_Lastschrift_Vorgemerkt
      else
        result := cForderung_Lastschrift_Erhalten;
    end;

  until yet;
  b_r_ForderungStatus_EREIGNIS_R := cRID_Unset;
end;

function b_r_ForderungStatus(BELEG_R, TEILLIEFERUNG: integer): integer; overload;
var
  AUSGANGSRECHNUNG_R: integer;
begin

  if not(assigned(b_r_ForderungStatus_cAR3)) then
  begin
    b_r_ForderungStatus_cAR3 := nCursor;
    with b_r_ForderungStatus_cAR3 do
    begin
      sql.add('select');
      sql.add(' RID,');
      sql.add(' EREIGNIS_R');
      sql.add('from');
      sql.add(' AUSGANGSRECHNUNG');
      sql.add('where');
      sql.add(' (BELEG_R=:CR1) and');
      sql.add(' (TEILLIEFERUNG=:CR2) and');
      sql.add(' (VORGANG=' + SQLString(cVorgang_Rechnung) + ')');
      open;
    end;
  end;

  with b_r_ForderungStatus_cAR3 do
  begin
    Params.BeginUpdate;
    Params[0].AsInteger := BELEG_R;
    Params[1].AsInteger := TEILLIEFERUNG;
{$IFDEF fpc}
    Params.EndUpdate;
{$ELSE}
    Params.EndUpdate(true);
{$ENDIF}
    ApiFirst;
    if not(eof) then
    begin
      b_r_ForderungStatus_EREIGNIS_R := Fields[1].AsInteger;
      result := b_r_ForderungStatus(Fields[0].AsInteger)
    end
    else
      result := cForderung_Unklar;
  end;

end;

function b_r_GutschriftAusLS(VORGANG: string): boolean;
begin
  if iKontoLSErkennung then
    result := (pos(VORGANG, cVorgang_Lastschrift) > 0)
  else
    result := false;
end;

function b_r_Stempel(STEMPEL_R: Integer):string;
begin
  if (STEMPEL_R >= cRID_FirstValid) then
    result := e_r_sqls('select PREFIX from STEMPEL where RID=' + inttostr(STEMPEL_R))
  else
    result := '';
end;

function b_r_Stempel_CheckFile(Needle,Haystack: string):boolean;
var
k : integer;
begin
 repeat
  k := pos(Needle,HayStack);
  if (k=0) then
  begin
    result := false;
    break;
  end;
  result := (pos(HayStack[k+length(Needle)],cZiffern)=0);
 until yet;
end;

function b_r_PDF(BUCH_R: Integer) : TStringList;
var
  cBUCH: TdboCursor;
  STEMPEL : String;
  AlleDokumente : TStringList;
  sPath: string;
  n : integer;
begin
  AlleDokumente := TStringList.create;
  result := TStringList.Create;
  cBUCH := nCursor;
  with cBUCH do
  begin
    sql.add(
      { } 'select' +
      { } ' STEMPEL_R,STEMPEL_DOKUMENT,PERSON_R from BUCH ' +
      { } 'where ' +
      { } ' (RID=' + inttostr(BUCH_R) + ') ' );
    ApiFirst;
    if not FieldByName('PERSON_R').IsNull then
    begin
      sPAth :=  cPersonPath(FieldByName('PERSON_R').AsInteger);
      STEMPEL := b_r_Stempel(FieldByName('STEMPEL_R').AsInteger) + '-' + FieldByName('STEMPEL_DOKUMENT').AsString;
      dir(sPath + STEMPEL + '*.pdf', AlleDokumente);
      for n := 0 to pred(AlleDokumente.Count) do
        if b_r_Stempel_CheckFile(STEMPEL,AlleDokumente[n]) then
         result.Add(sPath+AlleDokumente[n]);
    end;
  end;
  cBUCH.Free;
  AlleDokumente.Free;
end;

end.
