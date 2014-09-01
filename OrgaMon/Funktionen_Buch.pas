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
unit Funktionen_Buch;

//
// b_r_* lesende Buchungsregeln
// b_w_* schreibende Buchungsregeln
//

//
// [[Make everything as simple as possible, but not simpler.]]
// Albert Einstein
// Gestalte alles so einfach wie möglich, aber nicht einfacher

interface

uses
  Classes, gplists,
  anfix32;

const
  cBUCH_Farbe_Kalt = $2222FF;
  cBUCH_Farbe_OK = $66FF66;
  cBUCH_Farbe_DurchlaufenderPosten = $FF99FF;
  cBUCH_Farbe_edit = $FFFF33;
  cBUCH_Farbe_Ueberzahlung = $FF9933;
  cBUCH_Farbe_Gebucht = $00FF66;
  cBUCH_Farbe_Teilzahlung = $33CCFF;
  cBUCH_Farbe_Neutral = $DDDDDD;

  { Public-Deklarationen }
function e_r_InitialerBuchungssatz(BUCH_R: integer): integer;
// stellt sicher, dass zu einem Buchungssatz der
// initiale Buchungssatz geliefert wird

procedure b_w_buche(BUCH_R: integer; Diagnose: TStrings = nil); overload;
procedure b_w_buche(BUCH_R: TgpIntegerList; Diagnose: TStrings = nil); overload;
procedure b_w_buche(Diagnose: TStrings = nil); overload;
function b_w_copy(BUCH_R: integer): integer;

procedure b_w_ForderungAusgleich(sList: TStrings;
  Diagnose: TStrings = nil); overload;
procedure b_w_ForderungAusgleich(s: String; Diagnose: TStrings = nil); overload;
// Forderungs-Ausgleichbuchung!
//
// [PERSON_R,BELEG_R,Betrag,BDatum,BUCH_R,Meldung,Konto,TEILLIEFERUNG,EREIGNIS_R]

//
// "Bezahlt" Info wieder zurücknehmen
procedure b_w_ForderungAusgleichStorno(EREIGNIS_R: integer);

function b_w_ForderungBuchen(BELEG_R: integer; RechnungsBetrag: double)
  : TStringList;
// aus einem Beleg die Gesamt-Forderung auf ein Konto buchen!
//

procedure b_w_Rechnungsdatum(BELEG_R: integer; RechnungsDatum: TAnfixDate);
// Nachträgliches Verändern des Rechnungsdatums sowie der
// Fälligkeit

function b_r_MwSt(KONTO: string): double; overload;
// liefert den "üblichen" / "vorbelegten" MwSt Satz aus dem Konto-Deckblatt

function b_r_AusgleichKonten: TStringList;
// Liste der AR ausgleichenden Konten
//

function b_r_HBCIKonten: TStringList;
// Liste der HBCI Konten
//

function b_r_Konto(SORTIMENT_R: integer): string;
// Liefert die Konto-Nummer zu einem Artikel
//

function b_r_KontoSuchindexFName(KONTO: string): string;
// Liefert den Dateinamen des TWordIndex Suchindex

function b_r_PersonSaldo(PERSON_R: integer): double;
// aktueller Saldo des "Kunden" Kontos
//

function b_r_KontoSaldo(KONTO: string; Datum: TAnfixDate = ccMaxDate): double;
// Saldo des Kontos "Konto" am "Datum"
//


function b_r_Anno(Suchbegriff: string; Von, Bis: TAnfixDate): double;
// Berechnet hochgerechnete jährliche Kosten im Zeitraum
// "Von" bis "Bis"

procedure b_w_preDeleteBuch(BUCH_R: integer);
procedure b_w_DeleteBuch(BUCH_R: integer);

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
  globals,

  CareTakerClient, Geld, dbOrgaMon,
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
    e_x_sql('update BUCH set BETRAG=' + FloatToStrISO(Betrag, 2) + ' where RID='
      + inttostr(BUCH_R));
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

  function SteuerBuchung(pSteuer: string; BruttoBetrag: double;
    mDatum: TAnfixDate; NETTO_R: integer): double; // [gebuchte Steuer]
  var
    pSatz: integer;
    pBetrag: double;
    pSkonto: double;
    SteuerSatz: double;
    Vorgang: string;
  begin
    Vorgang := '';
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
        Vorgang := format('MWST FIXIERT (%d) -%f.1%% Skonto', [pSatz, pSkonto]);
      end
      else
      begin
        Vorgang := format('MWST FIXIERT (%d)', [pSatz]);
      end;

      // Vorzeichen aus BruttoBetrag übernehmen!
      if ((BruttoBetrag > 0) and (pBetrag < 0)) or
        ((BruttoBetrag < 0) and (pBetrag > 0)) then
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
        Vorgang := format('MWST %.1f%% (%d)', [SteuerSatz, pSatz]);
        result := BruttoBetrag - cPreisRundung
          (BruttoBetrag / (1.0 + (SteuerSatz / 100.0)));
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
      FieldByName('VORGANG').AsString := Vorgang;

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
  Ziel: string;
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
          raise Exception.create('Ich kann kein STEMPEL= im Deckblatt "' + Ziel
            + '" finden!');
        if (StempelName = cIni_DeActivate) then
          exit;
        STEMPEL_R := e_r_sql('select RID from STEMPEL where PREFIX=''' +
          StempelName + '''');
        if (STEMPEL_R < cRID_FirstValid) then
          raise Exception.create('Der Stempel ' + StempelName +
            ' existiert nicht!');
        e_x_sql('update BUCH set STEMPEL_R=' + inttostr(STEMPEL_R) +
          ' where RID=' + inttostr(BUCH_R));
      end;

      // neuen Wert eintragen Stempel erhöhen
      e_x_sql('update BUCH set STEMPEL_DOKUMENT=' +
        inttostr(e_w_Stempel(STEMPEL_R)) + ' where RID=' + inttostr(BUCH_R));

      // lese die neuen Werte auch in den cINITAL ein!
      cINITIAL.Refresh;
    end;

  end;

  function BucheBeleg: double;

    procedure bucheTeilzahlung(BELEG_R, TEILLIEFERUNG: integer;
      BruttoBetrag, Forderung: double);
    var
      Teilzahlungen: double;
      AUSGLEICH_R: integer;
      AUSGLEICH_ALT_R: integer;
      ScriptText: TStringList;
    begin
      ScriptText := TStringList.create;

      // ggf. alte Gegenbuchung löschen! (Falls vorhanden!)
      AUSGLEICH_ALT_R := e_r_sql('select RID from BUCH where ' + ' (NAME=''' +
        cKonto_Anzahlungen + ''') and' + ' (BELEG_R=' + inttostr(BELEG_R) +
        ') and' + ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ') and' +
        ' (GEGENKONTO=''' + cKonto_Erloese + ''')');
      if (AUSGLEICH_ALT_R = BUCH_R) then
        raise Exception.create('Löschung der alten ' + cKonto_Anzahlungen +
          '-Ausgleichsbuchung würde zur Löschung des initialen Buchungssatzes (RID='
          + inttostr(BUCH_R) + ') führen');
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
        ' (NAME=''' + cKonto_Anzahlungen + ''') and' + ' (BELEG_R=' +
        inttostr(BELEG_R) + ') and' + ' (TEILLIEFERUNG=' +
        inttostr(TEILLIEFERUNG) + ')');

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
          ScriptText.add(format('BELEG=%d;%d;%m', [BELEG_R, TEILLIEFERUNG,
            Forderung]));

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

    procedure bucheVollausgleich(BELEG_R, TEILLIEFERUNG: integer;
      BruttoBetrag: double);
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
    begin

      MwSt_Konto_Saver := TMwSt.create;
      MwSt_Satz_Saver := TMwSt.create;

      // Gibt es diese Teillieferung
      VERSAND_R := e_r_sql('select RID from VERSAND where ' + ' (BELEG_R=' +
        inttostr(BELEG_R) + ') and ' + ' (TEILLIEFERUNG=' +
        inttostr(TEILLIEFERUNG) + ')');
      if (VERSAND_R < cRID_FirstValid) then
        raise Exception.create(format('Die Teillieferung (%d) existiert nicht',
          [TEILLIEFERUNG]));

      // Stimmt der Gesamt-Betrag?
      VersandGesamtSumme :=
        e_r_sqld('select SUM(LIEFERBETRAG) from VERSAND where ' + ' (BELEG_R=' +
        inttostr(BELEG_R) + ') and ' + ' (TEILLIEFERUNG=' +
        inttostr(TEILLIEFERUNG) + ')');
      if isOther(VersandGesamtSumme, BruttoBetrag) then
        Log(cWARNINGText, format('Betrag (%m) aus VERSAND ist abweichend',
          [VersandGesamtSumme]));

      // Übergeordnete Einstellung ermitteln
      EinzelpreisNetto :=
        (e_r_sqls('select EINZELPREIS_NETTO from BELEG where RID=' +
        inttostr(BELEG_R)) = cC_True);

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
          Log(cWARNINGText,
            'Es gibt hierzu keine Posten in der Tabelle GELIEFERT');
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
                raise Exception.create('Beim Sortiment "' +
                  FieldByName('BEZEICHNUNG').AsString +
                  '" fehlt die Kontozuordnung');

            e_r_PostenInfo(cPOSTEN, false, EinzelpreisNetto, _Anz, _AnzAuftrag,
              _AnzGeliefert, _AnzStorniert, _AnzAgent, _Rabatt, _EinzelPreis,
              _MwStSatz);
            _PreisProPosition := e_c_Rabatt(e_r_PostenPreis(_EinzelPreis, _Anz,
              FieldByName('EINHEIT_R').AsInteger), _Rabatt);

            // MwSt Tabellen pflegen
            MwSt_Satz_Saver.add(_MwStSatz, _PreisProPosition);
            MwSt_Konto_Saver.add(_MwStSatz, _PreisProPosition,
              FieldByName('KONTO').AsString);

            ApiNext;
          end;
        end;
        close;
      end;

      // Jetzt die Endsummen berechnen
      MwSt_Satz_Saver.calc(EinzelpreisNetto);
      MwSt_Konto_Saver.calc(EinzelpreisNetto);

      // Stimmt eigentlich der Betrag?
      if (abs(MwSt_Satz_Saver.Brutto - BruttoBetrag) >= cGeld_KleinsterBetrag)
      then
        raise Exception.create
          (format('Betrag (%m) aus GELIEFERT ist abweichend',
          [MwSt_Satz_Saver.Brutto]));

      // aufgeteilt auf die Konten
      for n := 0 to pred(MwSt_Konto_Saver.count) do
        with MwSt_Konto_Saver.MwSt[n] do
          for m := 0 to pred(MwSt_Satz_Saver.count) do
          begin
            if (Satz = MwSt_Satz_Saver.MwSt[m].Satz) then
            begin
              MwSt_Satz_Saver.MwSt[m].NettoSumme := MwSt_Satz_Saver.MwSt[m]
                .NettoSumme - NettoSumme;
              MwSt_Satz_Saver.MwSt[m].MwStSumme := MwSt_Satz_Saver.MwSt[m]
                .MwStSumme - MwStSumme;
              break; // abziehen ist nur einmal notwendig
            end;
          end;

      // Die Reste (=die Rundungsfehler) nun wieder auf die Konten verteilen!
      while isSomeMoney(MwSt_Satz_Saver.Netto) or
        isSomeMoney(MwSt_Satz_Saver.Steuer) do
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
                    MwSt_Konto_Saver.MwSt[n].NettoSumme := MwSt_Konto_Saver.MwSt
                      [n].NettoSumme + cGeld_KleinsterBetrag;
                    NettoSumme := NettoSumme - cGeld_KleinsterBetrag;
                  end
                  else
                  begin
                    MwSt_Konto_Saver.MwSt[n].NettoSumme := MwSt_Konto_Saver.MwSt
                      [n].NettoSumme - cGeld_KleinsterBetrag;
                    NettoSumme := NettoSumme + cGeld_KleinsterBetrag;
                  end;
                end;

                // Im Brutto-Bereich korriegieren
                if isSomeMoney(MwStSumme) then
                begin
                  if MwStSumme > 0 then
                  begin
                    MwSt_Konto_Saver.MwSt[n].MwStSumme := MwSt_Konto_Saver.MwSt
                      [n].MwStSumme + cGeld_KleinsterBetrag;
                    MwStSumme := MwStSumme - cGeld_KleinsterBetrag;
                  end
                  else
                  begin
                    MwSt_Konto_Saver.MwSt[n].MwStSumme := MwSt_Konto_Saver.MwSt
                      [n].MwStSumme - cGeld_KleinsterBetrag;
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
                raise Exception.create
                  (format('MwSt Satz mit %.1f%% nicht gefunden', [Satz]));

              // Satz - Buchung durchführen
              insert;
              FieldByName('RID').AsInteger := cRID_AutoInc;
              FieldByName('MASTER_R').AsInteger := BUCH_R;
              FieldByName('ZUSAMMENHANG_R').AsInteger := NETTO_R;
              FieldByName('NAME').AsString := cKonto_SatzPrefix +
                inttostr(SatzN);
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

    function bucheBelegAusgleich(BELEG_R, TEILLIEFERUNG: integer;
      BruttoBetrag: double): double;
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

          if isSomeMoney(Forderung - BruttoBetrag) then
            raise Exception.create
              (format('Betrag (%m) aus VERSAND ist abweichend', [Forderung]));

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
        Forderung := e_r_sqld('select SUM(LIEFERBETRAG) from VERSAND where ' +
          ' (BELEG_R=' + inttostr(BELEG_R) + ') and' + ' (TEILLIEFERUNG=' +
          inttostr(TEILLIEFERUNG) + ')');

        if isSomeMoney(Forderung - BruttoBetrag) then
          bucheTeilzahlung(BELEG_R, TEILLIEFERUNG, BruttoBetrag, Forderung)
        else
          bucheVollausgleich(BELEG_R, TEILLIEFERUNG, BruttoBetrag);

      until true;
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
        BetragUnberuecksichtigt := BruttoBetrag -
          strtodoubledef(nextp(Skript[n], '=', 1), cGeld_Zero);
        result := result + bucheRest(
          { } BetragUnberuecksichtigt,
          { } nextp(Skript[n], ';', 1));
        continue;
      end;

    end;

    if (AnzahlBuchungen = 0) then
      raise Exception.create('BELEG= wurde nicht angegeben');

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
      FieldByName('NAME').AsString := Ziel;

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
        SteuerAnteil := SteuerAnteil + SteuerBuchung(nextp(Skript[n], '=', 1),
          BruttoBetrag, bDatum, NETTO_R);
        SATZfound := true;
      end;

    // über die Vorlage angegebene Satzbuchung
    if not(SATZfound) then
    begin
      for n := 0 to pred(Regel.count) do
        if (pos(cKonto_SatzPrefix + '=', Regel[n]) = 1) then
          SteuerAnteil := SteuerAnteil + SteuerBuchung(nextp(Regel[n], '=', 1),
            BruttoBetrag, bDatum, NETTO_R);
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
        Regel := e_r_sqlt('select SKRIPT from BUCH where (NAME=''' + ZielKonto +
          ''') and (BETRAG is null)');
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
          raise Exception.create
            (format(cKonto_SatzPrefix + '= im Deckblatt "%s" nicht gefunden',
            [ZielKonto]));

        setBetrag(NETTO_R, TeilBetragBrutto - TeilSteuerAnteil);

        TeilBetragNettoSumme := TeilBetragNettoSumme + TeilBetragBrutto -
          TeilSteuerAnteil;
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
          raise Exception.create('Angegebene Referenz (' + inttostr(BUCH_R) +
            ') existiert nicht');

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
          e_x_sql('update BUCH set ' + ' ZUSAMMENHANG_R=null ' + 'where' +
            ' (MASTER_R=' + inttostr(BUCH_R) + ') and' +
            ' (ZUSAMMENHANG_R is not null)');
          e_x_sql('delete from BUCH where' + ' (MASTER_R=' + inttostr(BUCH_R) +
            ') and' + ' (RID<>MASTER_R)');

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
        Ziel := FieldByName('GEGENKONTO').AsString;

      end;
      if (Ziel = '') then
        break;

      // Vorlagensatz laden, fehlende Parameter ersetzen
      with cDECKBLATT do
      begin
        sql.add('select SKRIPT from BUCH where');
        sql.add(' (BETRAG is null) and');
        sql.add(' (NAME=''' + Ziel + ''')');
        ApiFirst;
        if eof then
          raise Exception.create('Deckblatt "''' + Ziel +
            '''" existiert nicht!');
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

    until true;

    // Das ganze Geld muss verbraucht sein!
    if isSomeMoney(GebuchterBetrag) then
      if isSomeMoney(GebuchterBetrag - BruttoBetrag) then
        raise Exception.create
          (format('(RID=%d) Summe der gebuchten Beträge (%m) ist abweichend vom Gesamtbetrag (%m)',
          [BUCH_R, GebuchterBetrag, BruttoBetrag]));

    // Erfolg verbuchen!
    e_x_sql('update BUCH set GEBUCHT=CURRENT_TIMESTAMP where RID=' +
      inttostr(BUCH_R));

  except
    on E: Exception do
    begin
      Log(cERRORText, E.Message);
    end;
  end;

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
    sql.add(' ERTRAG,BEARBEITER_R,EREIGNIS_R');
    sql.add('from BUCH');
    sql.add(' where RID=:CROSSREF');
    sql.add('for update');
  end;

  // Komplette Liste buchen
  for n := 0 to pred(sList.count) do
  begin

    s := sList[n];
    PERSON_R := strtointdef(nextp(s, cOLAPcsvSeparator), cRID_Null);
    if (PERSON_R >= cRID_FirstValid) then
    begin

      // Parameter-Liste einholen
      BELEG_R := strtoint(nextp(s, cOLAPcsvSeparator));
      Betrag := cPreisRundung(nextp(s, cOLAPcsvSeparator));
      VALUTA := date2long(nextp(s, cOLAPcsvSeparator));
      BUCH_R := strtointdef(nextp(s, cOLAPcsvSeparator), cRID_Null);
      Meldung := nextp(s, cOLAPcsvSeparator);
      KONTO := nextp(s, cOLAPcsvSeparator);
      TEILLIEFERUNG := strtointdef(nextp(s, cOLAPcsvSeparator), cRID_Null);
      EREIGNIS_R := strtointdef(nextp(s, cOLAPcsvSeparator), cRID_Null);

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
          edit;
          FieldByName('DAVON_BEZAHLT').AsFloat :=
            cPreisRundung(FieldByName('DAVON_BEZAHLT').AsFloat + Betrag);

          if isZeroMoney(FieldByName('RECHNUNGS_BETRAG').AsFloat -
            FieldByName('DAVON_BEZAHLT').AsFloat) then
          begin
            // jetzt als vollständig bezahlt markieren.
            FieldByName('MAHNUNG1').clear;
            FieldByName('MAHNUNG2').clear;
            FieldByName('MAHNUNG3').clear;
            FieldByName('MAHNBESCHEID').clear;
            FieldByName('MAHNSTUFE').clear;
          end;

          post;
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
                ScriptText.Values['COLOR'] := '#00FF66'; // grün
                edit;
                FieldByName('GEGENKONTO').AsString := cKonto_Erloese;
                FieldByName('ERTRAG').AsString := cC_True;

                FieldByName('PERSON_R').AsInteger := PERSON_R;
                if (EREIGNIS_R >= cRID_FirstValid) then
                  FieldByName('EREIGNIS_R').AsInteger := EREIGNIS_R;
                ScriptText.add(format('BELEG=%d;%d;%m', [BELEG_R, TEILLIEFERUNG,
                  Betrag]));
                ScriptText.add(Meldung);
                FieldByName('SKRIPT').Assign(ScriptText);
                post;
              end;
              close;
            end;

          end
          else
          begin

            // Neuanlage (meist bei Zahlung via Kasse)!
            BUCH_R := e_w_Gen('GEN_BUCH');
            e_x_sql('insert into BUCH (RID,DATUM) values(' + inttostr(BUCH_R) +
              ',CURRENT_TIMESTAMP)');

            // Infos zum Beleg bilden!
            InfoText.clear;
            ScriptText.clear;

            InfoText.add(e_r_Person(PERSON_R));
            InfoText.add(format(cRECHNUNGStr + '%d',
              [e_r_sql('select RECHNUNG from VERSAND where ' + ' (BELEG_R=' +
              inttostr(BELEG_R) + ') and' + ' (TEILLIEFERUNG=' +
              inttostr(TEILLIEFERUNG) + ')')]));

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
                FieldByName('BELEG_R').AsInteger := BELEG_R;
                FieldByName('TEILLIEFERUNG').AsInteger := TEILLIEFERUNG;
                if (EREIGNIS_R >= cRID_FirstValid) then
                  FieldByName('EREIGNIS_R').AsInteger := EREIGNIS_R;

                ScriptText.add(format('BELEG=%d;%d;%m', [BELEG_R, TEILLIEFERUNG,
                  Betrag]));
                ScriptText.add(Meldung);

                FieldByName('GEGENKONTO').AsString := cKonto_Erloese;
                FieldByName('ERTRAG').AsString := cC_True;

                FieldByName('BETRAG').AsFloat := Betrag;
                if DateOK(VALUTA) then
                  FieldByName('WERTSTELLUNG').AsDateTime :=
                    long2datetime(VALUTA);
                FieldByName('TEXT').Assign(InfoText);
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
  result := e_r_sql('select COALESCE(MASTER_R,RID) from BUCH where RID=' +
    inttostr(BUCH_R));
end;

function b_w_ForderungBuchen(BELEG_R: integer; RechnungsBetrag: double)
  : TStringList;
var
  cBELEG: TdboCursor;
  qBELEG: TdboQuery;
  qAUSGANGSRECHNUNG: TdboQuery;
  sPARAMETER: TStringList;
  ForderungsFrist: integer;

  // cache
  RECHNUNGSDATUM: TDateTime;
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
  RECHNUNGSDATUM := cIllegalDate;
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
        RECHNUNGSDATUM := FieldByName('RECHNUNG').AsDateTime
      else
        RECHNUNGSDATUM := now;
    end;

    if (PERSON_R >= cRID_FirstValid) then
    begin

      // den Zahlungstyp bestimmen
      ForderungsFrist := e_r_ZahlungFrist(PERSON_R);

      // hier noch erweiterte Fälligkeitslogik einfügen
      FAELLIG := long2datetime(DatePlus(datetime2long(RECHNUNGSDATUM),
        ForderungsFrist));

      // (muss noch in das normale Kontenschema verschoben werden!)
      with qAUSGANGSRECHNUNG do
      begin
        sql.add('select * from AUSGANGSRECHNUNG for update');
        insert;
        FieldByName('RID').AsInteger := cRID_AutoInc;
        FieldByName('DATUM').AsDateTime := RECHNUNGSDATUM;
        FieldByName('VORGANG').AsString := cVorgang_Rechnung;
        FieldByName('VALUTA').AsDateTime := FAELLIG;
        FieldByName('BELEG_R').AsInteger := BELEG_R;
        FieldByName('KUNDE_R').AsInteger := PERSON_R;
        if (RECHNUNGSANSCHRIFT_R >= cRID_FirstValid) then
          FieldByName('MANDANT_R').AsInteger := RECHNUNGSANSCHRIFT_R;
        if (ZAHLUNGSPFLICHTIGER_R >= cRID_FirstValid) then
          FieldByName('ZAHLUNGSPFLICHTIGER_R').AsInteger :=
            ZAHLUNGSPFLICHTIGER_R;
        if (ZAHLUNGTYP_R >= cRID_FirstValid) then
          FieldByName('ZAHLUNGTYP_R').AsInteger := ZAHLUNGTYP_R;
        FieldByName('TEILLIEFERUNG').AsInteger := TEILLIEFERUNG;
        FieldByName('BETRAG').AsFloat := RechnungsBetrag;
        FieldByName('RECHNUNG').AsInteger :=
          e_r_sql('select RECHNUNG from VERSAND where' + ' (BELEG_R=' +
          inttostr(BELEG_R) + ') and' + ' (TEILLIEFERUNG=' +
          inttostr(TEILLIEFERUNG) + ')');
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
        FieldByName('RECHNUNGS_BETRAG').AsFloat :=
          FieldByName('RECHNUNGS_BETRAG').AsFloat + RechnungsBetrag;
        FieldByName('TEILLIEFERUNG').AsInteger := succ(TEILLIEFERUNG);
        FieldByName('RECHNUNG').AsDateTime := RECHNUNGSDATUM;
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
      CareTakerLog(cERRORText + ' b_w_ForderungBuchen(' + inttostr(BELEG_R) +
        '): ' + E.Message);
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
  ALL := e_r_sqlm('select RID from BUCH where' +
    ' (RID=MASTER_R) and (BETRAG is not null)');
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
      CareTakerLog(cERRORText + ' b_w_Copy(' + inttostr(BUCH_R) + '): ' +
        E.Message);
    end;

  end;
  cBUCH.Free;
  qBUCH.Free;
  BlackList.Free;
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
    result := e_r_sqls('select KONTO from SORTIMENT where RID=' +
      inttostr(SORTIMENT_R));
end;

function b_r_KontoSaldo(KONTO: string; Datum: TAnfixDate): double;
var
  cBUCH: TdboCursor;
  Abschluss: double;
  ABSCHLUSSper: TAnfixDate;
  saldo: TSaldo;

  // Cache
  _DATUM: TAnfixDate;
  UeberweisungsText: TStringList;
begin

  UeberweisungsText := TStringList.create;
  saldo := TSaldo.create;
  cBUCH := nCursor;

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
      // ...
      e_r_sqlt(FieldByName('TEXT'), UeberweisungsText);
      _DATUM := datetime2long(FieldByName('DATUM').AsDateTime);

      // Saldo fortführen ...
      repeat

        if (FieldByName('VORGANG').AsString = cVorgang_Abschluss) then
          if (UeberweisungsText.count >= 3) then
          begin
            ABSCHLUSSper :=
              date2long(nextp(UeberweisungsText[UeberweisungsText.count - 3],
              'PER', 1));
            Abschluss := strtodoubledef
              (UeberweisungsText[pred(UeberweisungsText.count)],
              cGeld_KeinElement);

            if DateOK(ABSCHLUSSper) and (Abschluss <> cGeld_KeinElement) then
            begin
              saldo.addAbschluss(ABSCHLUSSper, Abschluss);
              break;
            end
            else
            begin
              // imp pend: Über diesen Fehler berichten!
              // dabei BUCH_R verwenden
            end;

          end;

        saldo.addUmsatz(_DATUM, FieldByName('BETRAG').AsFloat);
      until true;
      ApiNext;
    end;
  end;
  result := saldo.saldo(Datum);

  cBUCH.Free;
  UeberweisungsText.Free;
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
  BUCH_R: integer;
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
      { } format('%s|%d', [long2date(ErstesDatum) + '-' + long2date(Bis),
      round(d1)]) + ';' +
      { } format('%m', [result]), DiagnosePath + b_r_Anno_LogFile);
end;

function b_r_PersonSaldo(PERSON_R: integer): double;
begin
  //
  result := e_r_sqld('select sum(BETRAG) from AUSGANGSRECHNUNG where KUNDE_R=' +
    inttostr(PERSON_R));
  // Zukunft
  (*
    e_r_sqld(
    'select sum(BETRAG) from BUCH where (PERSON_R='+inttostr(PERSON_R)+') and '+
    ' NAME in ('+cKonto_Forderungen+cKonto_Anzahlungen+')

  *)
end;

procedure b_w_preDeleteBuch(BUCH_R: integer);
begin

  // zunächst die Zusammenhang-Referenz entfernen
  e_x_sql('update BUCH set ' + ' ZUSAMMENHANG_R=null ' + 'where' + ' (MASTER_R='
    + inttostr(BUCH_R) + ') and' + ' (ZUSAMMENHANG_R is not null)');

  // nun die Folgebuchungssätze löschen
  e_x_sql('delete from BUCH where ' + ' (MASTER_R=' + inttostr(BUCH_R) + ') and'
    + ' (RID<>' + inttostr(BUCH_R) + ')');

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

end.
