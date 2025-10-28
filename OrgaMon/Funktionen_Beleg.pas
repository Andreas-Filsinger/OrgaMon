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
unit Funktionen_Beleg;

{$ifdef fpc}
{$mode delphi}
{$endif}

//
// e
// e_ (=eCommerce)
//
// w,r,x
// w_ (=write) possible write (maybe deteced as "without effect" in a later state)
// r_ (=read) granted read only access (guaranteed no "w")
// x_ (=execute) SQL Satement
//
//

interface

uses
  Classes,
{$IFNDEF fpc}
  IB_Components,
  IB_Access,
{$ENDIF}
  anfix, gplists, c7zip,
  globals,
  dbOrgaMon;

type
  eSuchSubs = (eSS_Titel, eSS_Numero, eSS_PaperColor, eSS_Verlag, eSS_Serie, eSS_Komponist, eSS_Arranger, eSS_Preis,
    eSS_Schwer, eSS_Land, eSS_Menge, eSS_Lager, eSS_VersendeTag, eSS_Rang, eSS_MengeProbe, eSS_MengeDemo, eSS_VerlagNo,
    eSS_Count // Muss immer der letze sein ...
    );

const
  sAugesetzteBelege: TgpIntegerList = nil;

///////////////////
// Z A H L U N G //
///////////////////

// liefert den Zahlungstext zur jeweiligen Person
function e_r_ZahlungText(ZAHLUNGTYP_R: integer; PERSON_R: integer = 0; MoreInfo: TStringList = nil): string;

// liefert den Zahlungstext zur jeweiligen Person
function e_r_ZahlungRID(PERSON_R: integer): integer;

// liefert die Fälligkeit in Tagen einer Forderung
function e_r_ZahlungFrist(PERSON_R: integer): integer;

// liefert den Zahlungstext zur jeweiligen Person
function e_r_ZahlungBezeichnung(PERSON_R: integer): string;

/////////////////
// B E L E G E //
/////////////////

// Lagerbedarf eines Beleges berechnen, auch anhand der Auftragsmenge
// dabei wird der Bedarf an Lager-XYZ berechnet der verbraucht
// werden würde.
//
// Ist die PLATZIERUNG=LagerPlazierung_COUNT dann wird nicht kummuliert,
// sondern jeder Artikel wird einzeln in die IntegerList eingetragen
function e_r_BelegDimensionen(
 BELEG_R: Integer;
 PLATZIERUNG : eLagerPlatzierungen = LagerPlazierung_COUNT) : TgpIntegerList; // [X,Y,Z,MENGE]

// Raum eines Beleges berechnen, anhand der Auftragsmenge und der Artikeldimensionen
function e_r_BelegVolumen(BELEG_R: Integer) : int64; // [X*Y*Z*MENGE_UNGELIEFERT]


// Beleg-Löschung durchführen
procedure e_d_Belege;

// Artikel-Rang neu berechnen
procedure e_d_Rang;

// Artikel-Lieferzeit neu berechnen
procedure e_d_Lieferzeit;

// Belege aus POS Dateien erstellen
procedure e_x_BelegAusPOS;

// liefert die Nummer eines Bestellbelegs, ev. wird einer neu erzeugt
function e_w_BestellBeleg(PERSON_R: integer): integer; { BBELEG_R }

// 2 Belege zusammen führen
function e_w_JoinBeleg(BELEG_R_FROM, BELEG_R_TO: integer): integer;

// 2 Personen zusammen führen, Quellperson kann gelöscht werden
function e_w_JoinPerson(PERSON_R_FROM, PERSON_R_TO: integer): integer;

// einen Beleg von einem Verantwortlichen zum anderen führen
function e_w_MoveBeleg(BELEG_R_FROM, PERSON_R_TO: integer): integer;

// Beleg neu erstellen anhand einer Vorlage
function e_w_CopyBeleg(BELEG_R_FROM, PERSON_R_TO: integer; sTexte: TStringList = nil): integer;

// Beleg erweitern um neue Postenzeilen aus einer Vorlage
procedure e_w_MergeBeleg(BELEG_R_FROM, BELEG_R_TO: integer; sTexte: TStringList = nil);

// Gesamtpreis berechnen
function e_r_PostenPreis(EinzelPreis: double; Anz, EINHEIT_R: integer): double;

// einen Preis um einen Rabatt vermindern
function e_c_Rabatt(PREIS, Rabatt: double): double;

// Alle relevANTEN Infos rund um einen Posten ermitteln
procedure e_r_PostenInfo(IBQ: TdboDataSet; NurGeliefertes: boolean; EinzelpreisNetto: boolean;
  var _Anz, _AnzAuftrag, _AnzGeliefert, _AnzStorniert, _AnzAgent: integer;
  var _Rabatt, _EinzelPreis, _MwStSatz: double);

// Ausgabelauf für den aktuellen Beleg mit Anlage der htmls
// Es wird eine Liste aller erstellten Belichtungs-Ergebnisdateien erzeugt
function e_w_AusgabeBeleg(BELEG_R: integer; NurGeliefertes: boolean; AlsLieferschein: boolean): TStringList;

// den Druck eines Beleges verbuchen und Eintragen
procedure e_w_DruckBeleg(BELEG_R: integer);

// liefert den Netto-Umsatz dieser Position aus POSTEN
function e_r_PostenUmsatz(POSTEN_R: integer): double;

// liefert den Netto-Umsatz dieser Position aus GELIEFERT
function e_r_GeliefertUmsatz(GELIEFERT_R: integer): double;

// der Rabatt-Code des Kunden.
function e_r_RabattCode(PERSON_R: integer): string;

// ist es ein Rabatt-Kunde JA/NEIN
function e_r_RabattFaehig(PERSON_R: integer): boolean;

// vermutlicher Rabatt, den PERSON_R bei diesem VERLAG_R bekommen würde
//
// unbeachtet bleiben:
// Obergrenzen
// Sortiments-Bezogene Rabatte
// Artikel-Bezogene Rabatte
function e_r_VerlagsRabatt(VERLAG_R, PERSON_R: integer): double;

// liefert den Namen des Versenders
function e_r_Versender(BELEG_R: integer; TEILLIEFERUNG: integer): string;

// liefert das aktuelle Leergewicht der Lieferung
function e_r_PackformGewicht(BELEG_R: integer): integer;

// liefert die Menge, die fest bestellt aber noch nicht eingetroffen ist (für Kunden oder Lager)
function e_r_ErwarteteMenge(AUSGABEART_R, ARTIKEL_R: integer; sDetails: TStringList = nil): integer;

// liefert die Menge, die im Moment zu beschaffen ist (für Kunden)
function e_r_AgentMenge(AUSGABEART_R, ARTIKEL_R: integer): integer;

// liefert die Menge, die im Moment in der Schwebe ist (unbestellt+ungeliefert)
function e_r_OffeneMenge(AUSGABEART_R, ARTIKEL_R: integer): integer;

// liefert die Menge, die im Moment unbestellt ist
function e_r_UnbestellteMenge(AUSGABEART_R, ARTIKEL_R: integer): integer;

// liefert die Menge, die das System vorschlagen würde
function e_r_VorschlagMenge(AUSGABEART_R, ARTIKEL_R: integer): integer;

// liefert die überzählige Menge die vom System erwartet wird, also über "Agent" und "Mindestbestand"
// hinaus.
function e_r_UngelieferteMengeUeberBedarf(AUSGABEART_R, ARTIKEL_R: integer): integer;

// erzeugt neuen Nummernkreise und leert die Mahnkandidatenliste
//
function e_w_NeuerMahnlauf(ForceNew: boolean = false): boolean;

// liefert den Kontostand des Kunden (zu zahlen!).
// erzeugt als Nebeneffekt die aktuelle "Mahnung.html"
//
// Optionen:
// verbuchen=JA
// mahnbescheid=JA
// template=[Mahnung.html]
//
// Ergebnisse:
// OFFEN=
// VERZUG=
// SEIT=
// MAHNSTUFE=
// [GUTSCHRIFT=JA]
// [DIFFERENZ=JA]
//
function e_w_KontoInfo(PERSON_R: integer; sOptionen: TStringList = nil): TStringList;

// liefert den Lieferrückstand des Lieferanten (erwartete Mengen!)
// erzeugt als Nebeneffekt die aktuelle "Bestellung.html"
function e_r_BestellInfo(PERSON_R: integer): integer;

// Leert den aktuellen Warenkorb
procedure e_w_WarenkorbLeeren(PERSON_R: integer);

// Fügt den aktuellen Warenkorb in den angegebenen Beleg
// ein.
function e_w_WarenkorbEinfuegen(BELEG_R: integer): integer;

// Gibt es was zu verbuchen?
// BELEG_R = null -> Zeitabrechnung bei diesem Kunden
// Rückgabewert -> Anzahl der erzeugten Belege
function e_w_buchen(BELEG_R, PERSON_R: TDOM_Reference): integer;

// liefert den RID den Stemples für diese Person
function e_r_Stempel(PERSON_R, BELEG_R: integer): integer; // [STEMPEL_R]

// Anzahl der Stellen der Rechnungsnummer bestimmen
function e_r_RechnungsNummerAnzahlDerStellen: integer;

// liefert alle bisherigen Rechnungen zu diesem Beleg
function e_r_RechnungsNummern(BELEG_R: integer): TStringList;

// liefert die verwendete Rechnungsnummer zu diesem Beleg
function e_r_RechnungsNummer(BELEG_R, TEILLIEFERUNG: integer): string;

// setzt die Rechnungsnummer im Beleg falls noch leer
function e_w_RechnungsNummer(BELEG_R: integer): integer;

// Legt einen neuen Versand-Eintrag in der Versand-Tabelle an,
// oder füllt den vorbereiteten!
function e_w_BelegVersand(BELEG_R: integer; Summe: double; gewicht: integer): integer;

// setzt die MwSt auf "0"
function e_w_BelegDrittlandAusfuhr(BELEG_R: integer): boolean;

// wickelt eine Beleg wieder zurück ab
function e_w_BelegStorno(BELEG_R: integer): boolean;

///////////////////
// V E R S A N D //
///////////////////

// löschen der ungebuchten versandkosten des
// letzten Buchungslaufes
function e_w_VersandKostenClear(BELEG_R: integer): integer; { : Anzahl der entfernten }

// Versanddatensatz vorbelegen
function e_w_SetStandardVersandData(qVERSAND: TdboQuery): integer; { : VERSENDER_R }

// Individuelle Versandkosten-Berechnung
function e_r_PortoFreiAbBrutto(PERSON_R: integer): double;

//
// berechnet die VersandKosten anhand der Tabelle VREGEL
// BELEG_R: um welchen Beleg geht es
// Ergebnis ARTIKEL_R = 0, keine Versandkosten
// ARTIKEL_R = -1, Berechnung nicht möglich, Problem
// ARTIKEL_R >0 , der passende Versandkostenartikel
//
function e_r_VersandKosten(BELEG_R: integer): integer; { : ARTIKEL_R }

// ermittelt, ob es sich bei dem Angegebenen Artikel
// um einen Versandartikel handelt, dies sind solche, die
// in der VREGEL genannt werden.
function e_r_IsVersandKosten(ARTIKEL_R: integer): boolean;

// VERSENDER_R des Standard-Versenders
function e_r_StandardVersender: integer;

// Ist bei dieser Beleg komplett versandfertig (alles da!)?
function e_r_Versandfertig(ib_q: TdboDataSet): boolean;

// Ist bei diesem Beleg etwas versendbar?
function e_r_Versandfaehig(ib_q: TdboDataSet): boolean;

// Leergewicht einer bestimmten Packform
//
function e_r_LeerGewicht(PACKFORM_R: integer): integer;

///////////////////////////////////////////


// legt eine neue Person (vorläufig) an. Über sie kann der Kunde
// vorbestellungen / vormerkungen anlegen.
function e_w_PersonNeu: integer; { : RID }

function e_r_KontoInhaber(PERSON_R: integer): string;

function e_r_VornameNachname(PERSON_R: integer): string;

// B E L E G E

// Prüfung, ob ein Beleg einer Aktion entspricht!
function e_r_Aktion(Name: String; BELEG_R: integer): boolean;

// Dateiname des Belegs
function e_r_BelegFName(PERSON_R: integer; BELEG_R: integer; TEILLIEFERUNG: integer = 0;
  AsMask: boolean = false): string;
function e_r_BelegFNameCombined(PERSON_R: integer; BELEG_R: integer; TEILLIEFERUNG: integer = 0): string;
function e_r_BelegFNameExists(PERSON_R: integer; BELEG_R: integer; TEILLIEFERUNG: integer = 0): string;

// Dateiname der aktuellen Kontoübersicht / Mahnung
function e_r_MahnungFName(PERSON_R: integer): string;
function e_r_MahnungFNameCombined(PERSON_R: integer): string;

{ : diverse ermittelten Werte }
//
// BELEG_R: Belegnummer
// TEILLIEFERUNG: Nummer der Teillieferung (1. = 0)
//
// EINZELPREISNETTO=
// MWSTANZ=
// MWST<n>PR=
// MWST<n>MS=
// MWST<n>MW=
// MWST<n>KN=
// NETTO=
// SUMME=
// LIEFERSUMME=
// WARENWERT=
// AUFTRAGSSUMME=
// AUFTRAGSWERT=
// LIEFERGEWICHT=
// AUFTRAGSGEWICHT=
// ANZAHLUNG=
// BRUTTOKORREKTUR=
//
function e_r_BelegInfo(BELEG_R: integer; TEILLIEFERUNG: integer = -1): TStringList;

// true wenn keine Forderung / Gutschrift mehr
function e_r_BelegeAusgeglichen(BELEG_R: integer): boolean;

// Saldo dieser Teillieferung
// Falls Teillieferung=cRID_NULL, Saldo dieses Beleges
function e_r_BelegSaldo(BELEG_R: integer; TEILLIEFERUNG: integer = cRID_Null): double;
function e_r_BelegForderungen(BELEG_R: integer): double;
function e_r_BelegZahlungen(BELEG_R: integer): double;
function e_r_BelegTeilzahlungen(BELEG_R: integer): double;

{ : diverse ermittelte Werte }
// die Auftragsmengen entsprechend auf die Mengen verteilen Daumen, es erfolgen
// Lagerbuchungen.
// RECHNUNGSBETRAG=
// LIEFERGEWICHT=
// BUDGETVOLUMEN=
function e_w_BerechneBeleg(BELEG_R: integer; NurGeliefertes: boolean = false): TStringList;

// Vertrag anwenden
function e_w_VertragBuchen(VERTRAG_R: integer; sSettings: TStringList): TStringList; overload;

// Einen einzelnen Vertrag anwenden, ohne besondere Optionen
function e_w_VertragBuchen(VERTRAG_R: integer; Erzwingen: boolean = false): TStringList; overload;

// Alle Verträge anwenden und buchen
function e_w_VertragBuchen: TStringList; overload;

// Alle Verträge der Liste anwenden und buchen
function e_w_VertragBuchen(const lVertraege: TgpIntegerList): TStringList; overload;

// Kann für diesen Vertrag eine weitere Abrechnung erfolgen?
// Rückgabewert "ANWENDUNG": Datum der nächsten Anwendung
function e_r_VertragBuchen(VERTRAG_R: integer; var ANWENDUNG: TAnfixDate): boolean;

// Monatsname der nächsten Vertagsanwendung
function e_r_Vertrag_NaechsteAnwendung(VERTRAG_R:Integer) : string;

// Briefumschlag-Funktion in den Belegen, Berechnete Mengen werden auf
// geliefert gesetzt. Budgets werden abgeschrieben. Textelemente werden ersetzt.
function e_w_BelegBuchen(BELEG_R: integer; LabelDatensatz: boolean = false): string;

// legt einen neuen Kunden-Beleg an
function e_w_BelegNeu(PERSON_R: integer): integer; { }

// setzt den Warenkorb in einen neuen Bestellung um.
function e_w_BelegNeuAusWarenkorb(PERSON_R: integer): integer; // [BELEG_R]

// setzt den Text im Ereignis als eine neue Bestellung um.
function e_w_BelegNeuAusKasse(EREIGNIS_R: integer): integer; // [BELEG_R]

// setze einen Auszahlungsbetrag in die
// entsprechende Arbeitszeit um
function e_r_LohnKalkulation(Betrag: double; Datum: TAnfixDate): string;

// zu dem jeweiligen LOHNTABELLEN RID die passende Tabelle
function e_r_LohnFName(RID: integer): string;

// Textermittlungs Funktionen zu Personen
procedure e_r_Anschrift(PERSON_R: integer; Datensammler: TStringList; Prefix: string = '');
procedure e_r_Bank(PERSON_R: integer; sl: TStringList; Prefix: string = '');
function e_r_Adressat(PERSON_R: integer): TStringList;

// Stringermittlungs Funktionen zu Personen
function e_r_Name(ib_q: TdboDataSet): string; overload;
function e_r_Name(PERSON_R: integer): string; overload;
function e_r_NameVorname(ib_q: TdboDataSet): string; overload;
function e_r_NameVorname(PERSON_R: integer): string; overload;
function e_r_land(ib_q: TdboDataSet): string;
function e_r_PLZlength(ib_q: TdboDataSet): integer;
function e_r_plz(ib_q: TdboDataSet; PLZlength: integer = -1): string;
function e_r_Ort(PERSON_R: integer): TStringList; overload;
function e_r_Ort(dboDS: TdboDataSet): TStringList; overload;
function e_r_fax(ib_q: TdboDataSet): string; overload;
function e_r_fax(PERSON_R: integer): string; overload;
function e_r_telefon(ib_q: TdboDataSet): string; overload;

// preDelete* sind Funktionen die die Löschung einer Entität vorbereiten
// und somit erst ermöglichen
procedure e_w_preDeletePosten(POSTEN_R: integer);
procedure e_w_preDeleteBPosten(BPOSTEN_R: integer);
procedure e_w_preDeleteBeleg(BELEG_R: integer);
procedure e_w_preDeleteBBeleg(BBELEG_R: integer);
procedure e_w_preDeleteArtikel(ARTIKEL_R: integer);
procedure e_w_preDeleteEinheit(EINHEIT_R: integer; References: TStrings = nil);
procedure e_w_preDeletePerson(PERSON_R: integer);
procedure e_w_preDeleteVerlag(VERLAG_R: integer);
procedure e_w_preDeleteTier(TIER_R: integer);
procedure e_w_preDeleteLAGER(LAGER_R: integer);

function e_w_BelegStatusBuchen(BELEG_R: integer): boolean;
function e_w_BBelegStatusBuchen(BBELEG_R: integer): boolean;

// vor dem setzen weiterer Felder kann hier Standardasiert ein Artikel in
// den aktuellen Posten kopiert werden. Zentrale Funktion zum Füllen einer
// Posten zeile
procedure e_w_SetPostenData(ARTIKEL_R, PERSON_R: integer; qPosten: TdboQuery);
procedure e_w_SetPostenPreis(EINHEIT_R, AUSGABEART_R, ARTIKEL_R, PERSON_R: integer; qPosten: TdboQuery);

// Q - Funktionen sind Qualitätssicherungs-Hilfsfunktionen
function q_r_PersonWarnung(PERSON_R: integer): TStringList;

// F - Sind Download und Upload Funktionen
procedure e_f_PersonInfo(PERSON_R: integer; AusgabePfad: string);

// T - Funktions zum Integritätstest von Daten
function t_r_Beleg(BELEG_R: integer): boolean;

type
  TRegelErgebnis = class(TObject)
    gewicht: integer;
    OUT_PERSON_R: integer;
  end;

procedure WarenbewegungCleanUp;
procedure EreignisCleanUp;

implementation

uses
  // Delphi
  math,
  SysUtils,

  // Tools
{$IFNDEF fpc}
  System.UITypes,
  {$ELSE}
  graphics,
  fpchelper,
{$ENDIF}
  html, Geld, DTA,
  SimplePassword, WordIndex,

  // DataBase
{$IFNDEF CONSOLE}
  Datenbank,
{$ENDIF}
  // OrgaMon
  CareTakerClient,
  Funktionen_OLAP,
  Funktionen_LokaleDaten,
  Funktionen_Artikel,
  Funktionen_Basis,
  Funktionen_Buch,
  Funktionen_Auftrag;

const
  e_i_AusgabeBeleg: TStringList = nil;

procedure BeginTransaction;
begin
  //
end;

procedure EndTransaction;
begin
  //
end;


function e_w_BestellBeleg(PERSON_R: integer): integer;
var
  IB_r_OldOne: TdboQuery;
  IB_w_NewOne: TdboQuery;
begin

  // Einen Bestellbeleg liefern, der noch nicht abgeschickt ist!
  result := -1;
  IB_r_OldOne := nQuery;
  with IB_r_OldOne do
  begin
    sql.add('SELECT RID');
    sql.add('FROM BBELEG');
    sql.add('WHERE (PERSON_R=' + inttostr(PERSON_R) + ') AND');
    sql.add(' ((MENGE_UNBESTELLT>0) OR (MENGE_UNBESTELLT IS NULL))');
    Open;
    if not(IsEmpty) then
    begin
      result := FieldByName('RID').AsInteger;
    end;
    Close;
  end;

  // ev. einen neuen Beleg erzeugen!
  if (result = -1) then
  begin
    IB_w_NewOne := nQuery;
    with IB_w_NewOne do
    begin
      sql.add('SELECT *');
      sql.add('FROM BBELEG');
      for_update(sql);
      Open;
      Insert;
      FieldByName('PERSON_R').AsInteger := PERSON_R;
      FieldByName('RID').AsInteger := 0;
      FieldByName('ANLAGE').AsDateTime := now;
      FieldByName('BTYP').AsString := '*';
      FieldByName('BSTATUS').AsString := '*';
      Post;
      result := e_r_gen('GEN_BBELEG');
      Close;
    end;
    IB_w_NewOne.free;
  end;
end;

const
  _Buchen_BisherigeZahlungen: TStringList = nil;

function e_w_buchen(BELEG_R, PERSON_R: TDOM_Reference): integer;
var
  sDiagnose: TStringList;
  MENGE_AUFNAHME: integer;
  qBELEG: TdboQuery;
  INTERN_INFO: TStringList;
  GENERATION_POSTFIX: string;
  n: integer;
  BuchungsIndex: TWordIndex;
  SuchFName: string;
  cPERSON: TdboCursor;
  ZAHLUNGSPFLICHTIGER_R: integer;
  ZAHLUNGTYP_R: integer;
  Suchbegriff: string;
  Treffer: integer;
  EREIGNIS: TdboQuery;
  ErrorStr: string;
  BankverbindungOK: boolean;
  KontoNummer, BLZ, BankName: string;
  sBudgetSettings: TStringList;
begin
  // Multifunktions "Buchen" das in der Regel der Webshop auslöst:
  //
  // a) Erzeugung von Rechnungsbelegen und Lieferungen von Ausgabeart "7" benutzt (Musikdownloads)
  // Vorgaben
  // * Es muss zumindest ein Download vorhanden sein
  // * Es dürfen bei der "Lieferung" keine Versandkosten entstehen
  // * Die entstandene Forderung muss ordentlich abgebildet werden
  // *
  // b) Erzeugen der aktuellen Zeitabrechnung (wenn BELEG_R ungesetzt)
  //
  result := cRID_unset;
  ZAHLUNGSPFLICHTIGER_R := cRID_Null;
  MENGE_AUFNAHME := cMenge_unbestimmt;
  sDiagnose := TStringList.create;
  try
    repeat

      // Angabe der Person ist Pflicht
      if (PERSON_R < cRID_FirstValid) then
      begin
        sDiagnose.add(cERRORText + ' Die PERSON-Referenz ist ungesetzt!');
        result := cRID_Null;
        break;
      end;

      // Gültiger Beleg angegeben, wenn nicht -> Zeitabrechnung erstellen
      if (BELEG_R < cRID_FirstValid) then
      begin

        // Zeitaberechnung frisch erstellen!
        sBudgetSettings := TStringList.create;
        sBudgetSettings.add('LOHN=' + cC_True);
        e_w_BudgetEinfuegen(
          { BELEG_R } cRID_Null,
          { SubBudget } '*',
          { } PERSON_R,
          { Einstellungen } sBudgetSettings);
        sBudgetSettings.free;

        result := 1;
        break;
      end;

      // Ist überhaupt was sofort auslieferbares dabei?
      MENGE_AUFNAHME := e_r_sql(
        { } 'select SUM(MENGE_RECHNUNG) ' +
        { } 'from POSTEN where' +
        { } ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
        { } ' (AUSGABEART_R=' + inttostr(cAusgabeArt_Aufnahme_MP3) + ')');
      if (MENGE_AUFNAHME < 1) then
      begin
        sDiagnose.add(cINFOText + ' Es gibt nichts zu buchen!');
        result := 0;
        break;
      end;

      // Beleg für die "Download" Abrechnung präparieren
      qBELEG := nQuery;
      with qBELEG do
      begin
        sql.add('select INTERN_INFO,GENERATION,ZAHLUNGSPFLICHTIGER_R,ZAHLUNGTYP_R,PERSON_R from BELEG');
        sql.add('where (RID=' + inttostr(BELEG_R) + ')');
        for_update(sql);
        Open;
        First;
        if eof then
        begin
          sDiagnose.add(cERRORText + ' Die BELEG-Referenz ist ungültig!');
          qBELEG.free;
          result := cRID_Null;
          break;
        end;

        // Ist Zahlungs-Pflichtiger gesetzt?
        if FieldByName('ZAHLUNGSPFLICHTIGER_R').IsNull then
        begin
          sDiagnose.add(cERRORText + ' Es ist keine Zahlungspflichtiger eingetragen!');
          qBELEG.free;
          result := cRID_Null;
          break;
        end;
        ZAHLUNGSPFLICHTIGER_R := FieldByName('ZAHLUNGSPFLICHTIGER_R').AsInteger;

        // Ist auch ein Zahlungstyp eingetragen
        if FieldByName('ZAHLUNGTYP_R').IsNull then
        begin
          sDiagnose.add(cERRORText + ' Es ist keine Zahlungsart eingetragen!');
          qBELEG.free;
          result := cRID_Null;
          break;
        end;
        ZAHLUNGTYP_R := FieldByName('ZAHLUNGTYP_R').AsInteger;

      end;

      // Bankverbindung ermitteln
      BankverbindungOK := false;
      cPERSON := nCursor;
      with cPERSON do
      begin
        sql.add('select');
        sql.add(' Z_ELV_KONTO_INHABER,');
        sql.add(' Z_ELV_BANK_NAME,');
        sql.add(' Z_ELV_BLZ,');
        sql.add(' Z_ELV_KONTO,');
        sql.add(' Z_ELV_FREIGABE');
        sql.add('from PERSON where RID=' + inttostr(ZAHLUNGSPFLICHTIGER_R));
        ApiFirst;

        if IsHaben(FieldByName('Z_ELV_FREIGABE').AsFloat) then
        begin
          sDiagnose.add(cINFOText + ' Der Zahlungspflichtige wurde durch eine ELV Freigabe bestätigt!');
          BankverbindungOK := true;
        end;

        KontoNummer := StrFilter(FieldByName('Z_ELV_KONTO').AsString, cZiffern);
        BLZ := StrFilter(FieldByName('Z_ELV_BLZ').AsString, cZiffern);
        BankName := FieldByName('Z_ELV_BANK_NAME').AsString;

      end;
      cPERSON.free;

      // grundsätzliche Plausibilisierung der BLZ + Konto# Kombination
      if not(CheckAccount(BLZ, KontoNummer, BankName, sDiagnose)) then
      begin
        qBELEG.free;
        break;
      end;

      sDiagnose.add(format('%s Konto=%s BLZ=%s Bank=%s validiert!', [cINFOText, KontoNummer, BLZ, BankName]));

      // Suchbegriff
      Suchbegriff :=
      { } BLZ + '.' + ' ' +
      { } KontoNummer + '.';

      // Ist die Konto-Nummer + BLZ bereits bekannt?
      if not(BankverbindungOK) then
      begin

        if not(assigned(_Buchen_BisherigeZahlungen)) then
        begin
          _Buchen_BisherigeZahlungen := b_r_HBCIKonten;
          for n := 0 to pred(_Buchen_BisherigeZahlungen.count) do
          begin
            BuchungsIndex := TWordIndex.create(nil);
            SuchFName := b_r_KontoSuchindexFname(_Buchen_BisherigeZahlungen[n]);
            if FileExists(SuchFName) then
              BuchungsIndex.LoadFromFile(SuchFName);
            _Buchen_BisherigeZahlungen.Objects[n] := BuchungsIndex;
          end;
        end;

        // Die Indizes abklopfen!
        Treffer := 0;
        for n := 0 to pred(_Buchen_BisherigeZahlungen.count) do
        begin

          // Gibt es im Index Neuerungen
          BuchungsIndex := TWordIndex(_Buchen_BisherigeZahlungen.Objects[n]);
          with BuchungsIndex do
          begin
            ReloadIfNew;

            // Index prüfen
            search(Suchbegriff);
            if (FoundList.count > 0) then
              Treffer := e_r_sql(
                { } 'select count(RID) from BUCH where' +
                { } ' (PERSON_R=' + inttostr(PERSON_R) + ') and' +
                { } ' (RID in (' + FoundList.AsString + '))');

          end;
          if (Treffer > 0) then
          begin
            sDiagnose.add(cINFOText + ' Bankverbindung ist bekannt!');
            break;
          end;

        end;

        if (Treffer = 0) then
        begin
          sDiagnose.add(cWARNINGText +
            ' Die Bankverbindung muss manuell überprüft werden. Sie erhalten in Kürze eine eMail sobald die Downloads verfügbar sind!');
          qBELEG.free;
          result := cRID_Null;
          break;
        end;

      end;

      with qBELEG do
      begin
        GENERATION_POSTFIX := '-' + inttostrN(FieldByName('GENERATION').AsInteger, 2);

        INTERN_INFO := TStringList.create;
        e_r_sqlt(FieldByName('INTERN_INFO'), INTERN_INFO);

        INTERN_INFO.values['BTYP' + GENERATION_POSTFIX] := 'p'; // Portofrei
        INTERN_INFO.values['FILTER' + GENERATION_POSTFIX] :=
         {} '(ARTIKEL_R is not null) and (AUSGABEART_R=' +
         {} inttostr(cAusgabeArt_Aufnahme_MP3) + ') and';

        // Modifikation speichern
        edit;
        FieldByName('INTERN_INFO').assign(INTERN_INFO);
        Post;

      end;
      qBELEG.free;
      INTERN_INFO.free;

      //
      if (e_w_BelegBuchen(BELEG_R)='') then
       sDiagnose.add(cERRORText + ' Fehler beim Belegbuchen');

      result := 1;

    until yet;
  except
    on E: exception do
    begin
      ErrorStr := cERRORText + ' e_w_buchen(' + inttostr(BELEG_R) + ',' + inttostr(PERSON_R) + '): ' + E.Message;
      sDiagnose.add(ErrorStr);
    end;
  end;

  if (sDiagnose.count > 0) then
  begin
    EREIGNIS := nQuery;
    with EREIGNIS do
    begin
      sql.add('select * from EREIGNIS');
      for_update(sql);
{$IFNDEF fpc}
      ColumnAttributes.add('RID=NOTREQUIRED');
      ColumnAttributes.add('AUFTRITT=NOTREQUIRED');
{$ENDIF}
      Insert;
      FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
      FieldByName('ART').AsInteger := eT_WebShopBestellung;
      if (PERSON_R >= cRID_FirstValid) then
        FieldByName('PERSON_R').AsInteger := PERSON_R;
      if (BELEG_R >= cRID_FirstValid) then
        FieldByName('BELEG_R').AsInteger := BELEG_R;
      FieldByName('MENGE').AsInteger := MENGE_AUFNAHME;
      e_w_sqlt(FieldByName('INFO'), sDiagnose);
      Post;
    end;
    EREIGNIS.free;
  end;

  sDiagnose.free;
end;

function e_r_BelegDimensionen(
 BELEG_R: Integer;
 PLATZIERUNG : eLagerPlatzierungen)
 : TgpIntegerList; // [X,Y,Z,MENGE]

var
  FatalError: boolean;

 procedure Error(s:string; Panic: boolean=false);
 begin
   AppendStringsToFile(IntToStr(BELEG_R)+';'+S,ErrorFName('LAGER'));
   if Panic then
    FatalError := true;
 end;

var
 X,Y,Z : integer;
 MENGE_UNGELIEFERT : Integer;

 procedure PushOne;
 var
  XYZ : TgpIntegerList;
 begin
  if (PLATZIERUNG=LagerPlazierung_COUNT) then
  begin
   result.Add(X);
   result.Add(Y);
   result.Add(Z);
   result.Add(MENGE_UNGELIEFERT);
  end else
  begin
   if not(FatalError) then
   begin
     XYZ := TgpIntegerList.Create;
     XYZ.add(X);
     XYZ.add(Y);
     XYZ.add(Z);
     Lagern(MENGE_UNGELIEFERT, PLATZIERUNG, XYZ, result, true);
     FreeAndNil(XYZ);
   end;
  end;
 end;

var
 POSTEN, ARTIKEL_AA, ARTIKEL, LAGER : TdboCursor;
 MENGE_GESAMT: Integer;
 EINHEIT_R, ARTIKEL_R, AUSGABEART_R : Integer;
 LAGERNAME: string;
begin
 if DebugMode then
  error(
   {} 'e_r_BelegDimensionen('+IntToStr(BELEG_R)+
   {} ','+cLagerPlazierungen[PLATZIERUNG]+')');

 result := TgpIntegerList.Create;
 if (PLATZIERUNG<>LagerPlazierung_COUNT) then
 begin
   result.Add(0); // X
   result.Add(0); // Y
   result.Add(0); // Z
   result.Add(-1); // Lager-Menge
 end;

 MENGE_GESAMT := 0;
 FatalError := false;
 POSTEN := nCursor;
 with POSTEN do
 begin
  sql.Add(
   { } 'select MENGE, MENGE_AUSFALL, MENGE_GELIEFERT, '+
   { } ' EINHEIT_R, ARTIKEL_R, AUSGABEART_R, ARTIKEL '+
   { } 'from POSTEN where '+
   { } ' (BELEG_R='+IntTostr(BELEG_R)+') and '+
   { } ' ((ZUTAT is null) or (ZUTAT='+cC_False_AsString+')) and '+
   { } ' (MENGE>0) '+
   { } 'order by'+
   { } ' POSNO,RID');
   ApiFirst;
   while not(eof) do
   begin
     MENGE_UNGELIEFERT :=
       FieldByName('MENGE').AsInteger -
       (FieldByName('MENGE_AUSFALL').AsInteger +
        FieldByName('MENGE_GELIEFERT').AsInteger);
     if DebugMode then
      error(FieldByName('ARTIKEL').AsString+';'+IntToStr(MENGE_UNGELIEFERT));
     inc(MENGE_GESAMT, MENGE_UNGELIEFERT);
     EINHEIT_R := FieldByName('EINHEIT_R').AsInteger;
     ARTIKEL_R := FieldByName('ARTIKEL_R').AsInteger;
     AUSGABEART_R := FieldByName('AUSGABEART_R').AsInteger;
     repeat

       // Artikel oder Ausgabeart laden
       if (AUSGABEART_R>=cRID_FirstValid) then
       begin

         // lade aus der Ausgabeart
         ARTIKEL_AA := nCursor;
         with ARTIKEL_AA do
         begin
           sql.Add(
            {} 'select X,Y,Z from ARTIKEL_AA where '+
            {} ' (ARTIKEL_R='+IntToStr(ARTIKEL_R)+') and '+
            {} ' (AUSGABEART_R='+IntToStr(AUSGABEART_R)+')');
           ApiFirst;
           if eof then
            Error(
            'ARTIKEL_AA (ARTIKEL_R='+IntToStr(ARTIKEL_R)+
            ';AUSGABEART_R='+IntToStr(AUSGABEART_R)+') nicht gefunden!',true);
           X := FieldByName('X').AsInteger;
           Y := FieldByName('Y').AsInteger;
           Z := FieldByName('Z').AsInteger;
           if DebugMode then
             error(' (X,Y,Z)='+IntToStr(X)+','+IntToStr(Y)+','+IntToStr(Z));
           PushOne;
         end;
         ARTIKEL_AA.Free;
         break;
       end;

       // lade aus dem Artikel
       if (ARTIKEL_R>=cRID_FirstValid) then
       begin
         // Info wenn Probleme bei der Ausgabeart-Bemassung

         ARTIKEL := nCursor;
         with ARTIKEL do
         begin
           sql.Add('select X,Y,Z from ARTIKEL where RID='+IntToStr(ARTIKEL_R));
           ApiFirst;
           if eof then
             Error('ARITKEL nicht gefunden! (RID='+IntToStr(ARTIKEL_R)+')',true);
           X := FieldByName('X').AsInteger;
           Y := FieldByName('Y').AsInteger;
           Z := FieldByName('Z').AsInteger;
           if DebugMode then
            error(' (X,Y,Z)='+IntToStr(X)+','+IntToStr(Y)+','+IntToStr(Z));
           PushOne;
         end;
         ARTIKEL.Free;
        end else
        begin
         if DebugMode then
          Error('für den manuellen ARTIKEL "'+POSTEN.FieldByName('ARTIKEL').AsString+'" kann kein Maß berechnet werden');
        end;
     until yet;
     ApiNext;
   end;
 end;
 POSTEN.Free;
 if (PLATZIERUNG<>LagerPlazierung_COUNT) then
  if not(FatalError) then
   result[3] := MENGE_GESAMT;
end;

function e_r_BelegVolumen(BELEG_R: Integer) : int64; // [Summe(X*Y*Z*MENGE)]

 procedure Error(s:string);
 begin
   AppendStringsToFile(IntToStr(BELEG_R)+';'+S,ErrorFName('LAGER'));
 end;

var
 POSTEN  : TdboCursor;
 MENGE_UNGELIEFERT : Integer;
 EINHEIT_R, ARTIKEL_R, AUSGABEART_R : Integer;
 LAGERNAME: string;
 V: int64;
begin
 if DebugMode then
  error(
   {} 'e_r_BelegVolumen('+IntToStr(BELEG_R)+')');
 result := 0;

 POSTEN := nCursor;
 with POSTEN do
 begin
  sql.Add(
   { } 'select MENGE, MENGE_AUSFALL, MENGE_GELIEFERT, '+
   { } ' EINHEIT_R, ARTIKEL_R, AUSGABEART_R, ARTIKEL '+
   { } 'from POSTEN where '+
   { } ' (BELEG_R='+IntTostr(BELEG_R)+') and '+
   { } ' ((ZUTAT is null) or (ZUTAT='+cC_False_AsString+')) and '+
   { } ' (MENGE>0) '+
   { } 'order by'+
   { } ' POSNO,RID');
   ApiFirst;
   while not(eof) do
   begin
     MENGE_UNGELIEFERT :=
       FieldByName('MENGE').AsInteger -
       (FieldByName('MENGE_AUSFALL').AsInteger +
        FieldByName('MENGE_GELIEFERT').AsInteger);
     if DebugMode then
      error(FieldByName('ARTIKEL').AsString+';'+IntToStr(MENGE_UNGELIEFERT));
     EINHEIT_R := FieldByName('EINHEIT_R').AsInteger;
     ARTIKEL_R := FieldByName('ARTIKEL_R').AsInteger;
     AUSGABEART_R := FieldByName('AUSGABEART_R').AsInteger;
     repeat

       V := 0;

       // Artikel oder Ausgabeart laden
       if (AUSGABEART_R>=cRID_FirstValid) then
       begin

         // lade aus der Ausgabeart
         V := e_r_sql(
            {} 'select X*Y*Z from ARTIKEL_AA where '+
            {} ' (ARTIKEL_R='+IntToStr(ARTIKEL_R)+') and '+
            {} ' (AUSGABEART_R='+IntToStr(AUSGABEART_R)+')');

         inc(result,V*MENGE_UNGELIEFERT);
        break;
       end;

       // lade aus dem Artikel
       if (ARTIKEL_R>=cRID_FirstValid) then
       begin
         V := e_r_sql('select X*Y*Z from ARTIKEL where RID='+IntToStr(ARTIKEL_R));
         inc(result,V*MENGE_UNGELIEFERT);
       end else
       begin
         if DebugMode then
           Error('für den manuellen ARTIKEL "'+POSTEN.FieldByName('ARTIKEL').AsString+'" kann kein Maß berechnet werden');
       end;
     until yet;
     ApiNext;
   end;
 end;
 POSTEN.Free;
end;

function e_w_KontoInfo(PERSON_R: integer; sOptionen: TStringList = nil): TStringList;
var
  n: integer;

  // html - Sachen
  MahnungsBeleg: THTMLTemplate;
  DatensammlerGlobal: TStringList;
  DatensammlerLokal: TStringList;

  // Einzelne Positionen Werte
  BuchungsBetrag: double;
  BetragVerzug: double;

  // Summen
  Summe_Offen: double; // gesamtsumme aller Offenen Beträge
  Summe_Verzug: double; // gesamtsumme der Beträge in Verzug (incl. der offenen)
  Summe_Zahlungen: double; // alle Zahlungen
  Summe_Ausgleich: double; // Summe der völlig Ausgelichenen Belege
  Summe_Anzahl: integer; // Anzahl der bisher aufgelisteten Belege
  _ustid: string;
  OutPath: string;
  ActLines: integer;
  DeleteAusgeglichen: integer;
  BelegNo: string;
  RECHNUNGSNUMMER: string;
  SkipIt: boolean;
  NoBELEG_R: boolean;
  SumValue: double;
  Verzug: boolean;
  Einzelner_BELEG_R: integer;

  // Beleg-Listen
  Checked_BELEG_R: TStringList; // Saldo aller bisher berührten Belege

  // Saldo=0 Belege, oder "Ausgeblendete"
  Ausgeglichen_BELEG_R: TgpIntegerList;

  // Fälligkeit ausgesetzt
  Ausgesetzt_BELEG_R: TgpIntegerList;

  // Liste der Belege, in die das Buchungsdatum schon eingetragen wurde
  Verbucht_BELEG_R: TStringList;

  // Liste der Belege, die im Status "Verzug" stehen
  Verzug_BELEG_R: TgpIntegerList;

  Unausgeglichen: TDoubleObject;
  SaldoLautBeleg: double;
  SaldoLautKonto: double;

  // Text-Infos zu den einzelnen Buchungsinfos
  LastschriftTexte: TStringList;
  LastschriftTexteAlle: TStringList;
  KontoTexte: TStringList;
  MoreText: string;
  MoreTextManuell: boolean;

  EvenOddCounter: integer;
  FaelligSeit: integer; // [days]
  ZielLandRID: integer;
  SkipManuelleZahlungen: boolean;
  MahnGebuehr: double;
  VerzugszinsGesamt: double;
  VerzugszinsSatz: double;
  BerechneterZins: double;
  ForderungStatus: integer;

  cAUSGANGSRECHNUNG: TdboCursor;
  cPERSON: TdboCursor;
  cANSCHRIFT: TdboCursor;
  cBELEGSALDO: TdboCursor;
  qBELEG: TdboQuery;
  cBELEG: TdboCursor;
  MaxMahnstufe: integer;
  MaxTageVerzug: integer;

  // db-Caching
  BELEG_R: integer;
  AUSGANGSRECHNUNG_R: integer;
  TEILLIEFERUNG: integer;
  Adressat: TStringList;
  OneDifferenz: boolean;

  // für den Mahnbescheid-Lauf
  MahnbescheidTAN: integer;

  // weitere parameter
  pVerbuchen: boolean;
  pAuchMahnbescheid: boolean;
  pTemplateFName: string;
  pHeutigeBelege: boolean;
  pMahnMoment: TDateTime;
  pMahnGebuehr: boolean;
  pOhneAusstehende: boolean;
  pNurEinBeleg: boolean;

  // Ausgabeparameter
  RECHNUNGEN: string;
  VORGANG: string;
  BELEGE: string;
  TEILLIEFERUNGEN: string;

  function GetSaldo(BELEG_R: integer): double;
  var
    k: integer;
  begin
    k := Checked_BELEG_R.IndexOf(inttostr(BELEG_R));
    if (k = -1) then
      result := 0.0
    else
      result := TDoubleObject(Checked_BELEG_R.Objects[k]).Wert;
  end;

  procedure LoadArtikelBlock;
  begin
    if (EvenOddCounter mod 2 = 0) then
      DatensammlerLokal.add('load ARTIKEL EVEN,ARTIKEL')
    else
      DatensammlerLokal.add('load ARTIKEL ODD,ARTIKEL');

    inc(ActLines);
    inc(EvenOddCounter);
  end;

  function _KontoTexte: string;
  var
    n: integer;
  begin
    result := '';
    for n := 0 to pred(KontoTexte.count) do
      if KontoTexte[n] = '~' then
        break
      else if (pos('=', KontoTexte[n]) = 0) then
        result := result + #13 + KontoTexte[n];
  end;

  function MahnbescheidPath: string;
  begin
    if pAuchMahnbescheid then
    begin
      result := MyProgramPath + cMahnbescheidPath + inttostrN(MahnbescheidTAN, 4) + '\' + RIDasStr(PERSON_R) + '\';
      CheckCreateDir(result);
    end
    else
    begin
      result := '';
    end;
  end;

  function _BetragAsHTML(d: double): string;
  begin
    result := format('%m', [d]);
    if Verzug then
      result :=
      { } cRawHTMLPrefix +
      { } '<b>' +
      { } Ansi2html(result) +
      { } '</b>';
  end;

begin
  result := TStringList.create;
  if (PERSON_R < cRID_FirstValid) then
    exit;

  // Person Datenfelder
  cPERSON := nCursor;
  with cPERSON do
  begin
    sql.add('select * from PERSON where RID=' + inttostr(PERSON_R));
    ApiFirst;
  end;

  if cPERSON.eof then
  begin
    // Person nicht gefunden
    cPERSON.free;
    exit;
  end;

  // Vorlauf
  DatensammlerGlobal := TStringList.create;
  DatensammlerLokal := TStringList.create;
  Checked_BELEG_R := TStringList.create;
  Ausgeglichen_BELEG_R := TgpIntegerList.create;
  Ausgesetzt_BELEG_R := TgpIntegerList.create;
  Verzug_BELEG_R := TgpIntegerList.create;
  KontoTexte := TStringList.create;
  Verbucht_BELEG_R := TStringList.create;
  LastschriftTexteAlle := TStringList.create;
  qBELEG := nQuery;
  cANSCHRIFT := nCursor;
  cBELEGSALDO := nCursor;
  MahnungsBeleg := THTMLTemplate.create;
  try
    OutPath := cPersonPath(PERSON_R);
    CheckCreateDir(OutPath);

    MaxMahnstufe := 0;
    MaxTageVerzug := 0;
    VerzugszinsGesamt := 0;
    MahnbescheidTAN := 0;
    RECHNUNGEN := '';
    BELEGE := '';
    TEILLIEFERUNGEN := '';
    Einzelner_BELEG_R := cRID_unset;

    if assigned(sOptionen) then
    begin

      with sOptionen do
      begin
        pVerbuchen := (values['verbuchen'] = cIni_Activate);
        pAuchMahnbescheid := (values['mahnbescheid'] = cIni_Activate);
        pTemplateFName := values['template'];
        pHeutigeBelege := (values['aktuell'] = cIni_Activate);
        pMahnMoment := mkDateTime(values['moment']);
        pMahnGebuehr := (values['mahngebühr'] <> cIni_DeActivate);
        pOhneAusstehende := (values['ohneAusstehende'] = cIni_Activate);
        pNurEinBeleg := (values['nurEinBeleg'] = cIni_Activate);
      end;

      // ins Log
      DatensammlerGlobal.addstrings(sOptionen);

    end
    else
    begin
      // defaults
      pVerbuchen := false;
      pAuchMahnbescheid := false;
      pTemplateFName := '';
      pHeutigeBelege := false;
      pMahnMoment := now;
      pMahnGebuehr := true;
      pOhneAusstehende := false;
      pNurEinBeleg := false;
    end;

    // verbuchen -> aktuellen Mahnbeleg wegkopieren!
    if pVerbuchen then
    begin
      FileCopy(e_r_MahnungFName(PERSON_R), OutPath + 'Mahnung_' + DatumLog + chtmlextension);
    end;

    // TAN für Mahnbescheid auslesen!
    if pAuchMahnbescheid then
    begin
      MahnbescheidTAN := e_r_gen('GEN_MAHNBESCHEID');
      FileCopy(e_r_MahnungFName(PERSON_R), MahnbescheidPath + 'Mahnbescheid.html');
    end;

    // ausgesetzte Belege ermitteln
    e_r_sqlm('select RID from BELEG where ' +
      { } '(PERSON_R=' + inttostr(PERSON_R) + ') and ' +
      { } '(MAHNUNG_AUSGESETZT=''' + cC_True + ''')', Ausgesetzt_BELEG_R);

    // ausgeklammerte Belege ermitteln
    if assigned(sAugesetzteBelege) then
      Ausgeglichen_BELEG_R.append(sAugesetzteBelege);

    // manuelle Zahlungen
    cAUSGANGSRECHNUNG := nCursor;
    with cAUSGANGSRECHNUNG do
    begin
      sql.add('select sum(BETRAG) from AUSGANGSRECHNUNG where');
      sql.add(' (BELEG_R is null) and');
      sql.add(' (KUNDE_R=' + inttostr(PERSON_R) + ')');
      sql.add('group by KUNDE_R');
      ApiFirst;
      SkipManuelleZahlungen := isZeroMoney(FieldByName('SUM').AsFloat);
    end;
    cAUSGANGSRECHNUNG.free;

    // Gewerblicher Kunde?
    if (cPERSON.FieldByName('RABATT_CODE').AsString = '') then
      VerzugszinsSatz := iMahnungZinsSatzPrivat
    else
      VerzugszinsSatz := iMahnungZinsSatzGewerblich;

    // Anschriftsdaten
    with cANSCHRIFT do
    begin
      sql.add('select * from ANSCHRIFT where RID=' + cPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsString);
      ApiFirst;
    end;

    // Konto Summe "Beleg-Bezogen"
    with cBELEGSALDO do
    begin
      sql.add('select sum(BETRAG) B_SUM from AUSGANGSRECHNUNG where BELEG_R=:CROSSREF');
      prepare;
    end;

    // Alle Belege des Kunden auflisten
    with qBELEG do
    begin
      sql.add('select * from BELEG where RID=:CROSSREF ' + for_update);
      prepare;
    end;

    DatensammlerGlobal.add('Titel=' + 'Kontoinformation K#' + ' ' + cPERSON.FieldByName('NUMMER').AsString);
    DatensammlerGlobal.add('Datum=' + long2dateLocalized(DateGet));
    DatensammlerGlobal.add('AktuellesDatum=' + DatumLocalized);
    DatensammlerGlobal.add('AktuelleUhrzeit=' + Uhr);

    e_r_Anschrift(PERSON_R, DatensammlerGlobal);

    DatensammlerGlobal.add('BisDatum=' + long2dateLocalized(DatePlus(DateTime2Long(pMahnMoment),
      iMahnfreierZeitraum - 5)));

    with cANSCHRIFT do
    begin

      ZielLandRID := FieldByName('LAND_R').AsInteger;
      DatensammlerGlobal.add('KontoInhaber=' + e_r_Localize(strtol(iKontoInhaber), ZielLandRID));
      DatensammlerGlobal.add('KontoBankName=' + e_r_Localize(strtol(iKontoBankName), ZielLandRID));
      DatensammlerGlobal.add('KontoNummer=' + e_r_Localize(strtol(iKontoNummer), ZielLandRID));
      DatensammlerGlobal.add('KontoBLZ=' + e_r_Localize(strtol(iKontoBLZ), ZielLandRID));

      _ustid := FieldByName('UST_ID').AsString;
      if (_ustid <> '') then
      begin
        DatensammlerGlobal.add('USTID=' + _ustid);
      end
      else
      begin
        DatensammlerGlobal.add('delete USTID_A');
        DatensammlerGlobal.add('delete USTID_B');
      end;
    end;

    DatensammlerGlobal.add('save&delete ARTIKEL EVEN');
    DatensammlerGlobal.add('save&delete ARTIKEL ODD');
    DatensammlerGlobal.add('save&delete PUNKTE');

    EvenOddCounter := 0;
    Summe_Offen := 0;
    Summe_Verzug := 0;
    Summe_Zahlungen := 0;
    Summe_Ausgleich := 0;
    Summe_Anzahl := 0;
    ActLines := 0;
    DeleteAusgeglichen := 0;
    MoreTextManuell := false;
    OneDifferenz := false;

    cAUSGANGSRECHNUNG := nCursor;
    with cAUSGANGSRECHNUNG do
    begin

      sql.add('SELECT * FROM AUSGANGSRECHNUNG WHERE KUNDE_R=' + inttostr(PERSON_R));
      sql.add('ORDER BY BELEG_R');
      if pNurEinBeleg then
        sql.add('descending');
      sql.add(',DATUM');
      ApiFirst;
      while not(eof) do
      begin

        NoBELEG_R := FieldByName('BELEG_R').IsNull;
        BELEG_R := FieldByName('BELEG_R').AsInteger;
        TEILLIEFERUNG := FieldByName('TEILLIEFERUNG').AsInteger;
        VORGANG := FieldByName('VORGANG').AsString;
        AUSGANGSRECHNUNG_R := FieldByName('RID').AsInteger;

        if not(NoBELEG_R) then
        begin

          // prüfen, ob für diesen Beleg/Zahlung schon Ausgelichenheit geprüft wurde
          if (Ausgeglichen_BELEG_R.IndexOf(BELEG_R) = -1) then
            if (Checked_BELEG_R.IndexOf(FieldByName('BELEG_R').AsString) = -1) then
            begin

              // Prüfung eintragen
              cBELEGSALDO.ParamByName('CROSSREF').AsInteger := BELEG_R;
              cBELEGSALDO.ApiFirst;
              if not(cBELEGSALDO.eof) then
              begin

                // ermittelten Wert speichern
                SumValue := cBELEGSALDO.FieldByName('B_SUM').AsFloat;
                Unausgeglichen := TDoubleObject.create;
                Unausgeglichen.Wert := SumValue;
                Checked_BELEG_R.AddObject(FieldByName('BELEG_R').AsString, Unausgeglichen);

                // wenn ca. 0 -> Ist ausgeglichen!
                if isZeroMoney(SumValue) then
                  Ausgeglichen_BELEG_R.add(BELEG_R);

              end;
            end;

          //
          SkipIt := (Ausgeglichen_BELEG_R.IndexOf(BELEG_R) <> -1);

          if not(SkipIt) and not(FieldByName('TEILLIEFERUNG').IsNull) then
          begin
            // imp pend: Migration auf 1400
            // Micro - Ausgeglichenheit in dieser Teillieferung prüfen!
            if isZeroMoney(e_r_sqld(
              { } 'select sum(BETRAG) from AUSGANGSRECHNUNG where' +
              { } ' (KUNDE_R=' + inttostr(PERSON_R) + ') and' +
              { } ' (BELEG_R=' + FieldByName('BELEG_R').AsString + ') and' +
              { } ' (TEILLIEFERUNG=' + FieldByName('TEILLIEFERUNG').AsString + ')'
              { } )) then
              SkipIt := true;
          end;

          // Belege, die erst heute/gestern abgerechnet wurden auf der Mahnung ignorieren!
          if not(SkipIt) then
            if not(pHeutigeBelege) then
              if (VORGANG = cVorgang_Rechnung) then
                if (trunc(FieldByName('DATUM').AsDateTime) >= trunc(now) - 2) then
                  SkipIt := true;

          // Belege, die bereits in einem ausstehenden Lastschriftvolumen vorgemerkt sind!
          if not(SkipIt) then
            if (pOhneAusstehende) then
              if (VORGANG = cVorgang_Rechnung) then
                if not(FieldByName('EREIGNIS_R').IsNull) then
                  SkipIt := true;

          // mehr als ein Beleg werden ignoriert
          if not(SkipIt) then
            if (pNurEinBeleg) then
              if (Summe_Anzahl > 0) then
                if (Einzelner_BELEG_R <> BELEG_R) then
                  SkipIt := true;

        end
        else
        begin
          SkipIt := SkipManuelleZahlungen;
        end;

        // Diese Buchungszeile kommt auf die Mahnung?
        if not(SkipIt) or iMahnungAusgelicheneDazwischenAnzeigen then
        begin

          LoadArtikelBlock;
          BuchungsBetrag := FieldByName('BETRAG').AsFloat;
          KontoTexte.clear;
          MoreText := '';
          BetragVerzug := 0.0;
          Verzug := false;

          // maunellen Text laden
          if not(FieldByName('TEXT').IsNull) then
          begin

            //
            e_r_sqlt(FieldByName('TEXT'), KontoTexte);

            // Nur bis zur Geheim-Symbol
            if (KontoTexte.count > 0) then
              if (KontoTexte[0] <> '~') then
                MoreTextManuell := true;

          end;

          if (VORGANG = cVorgang_Rechnung) then
          begin

            inc(Summe_Anzahl);
            if (Einzelner_BELEG_R = cRID_unset) then
              Einzelner_BELEG_R := BELEG_R;
            BELEGE := cutblank(BELEGE + ' ' + inttostr(BELEG_R));
            TEILLIEFERUNGEN := cutblank(TEILLIEFERUNGEN + ' ' + inttostr(TEILLIEFERUNG));

            DatensammlerLokal.add('MREF=RID' + FieldByName('RID').AsString);

            // das ist ein Rechnungs-Beleg, also eine Forderung
            RECHNUNGSNUMMER := inttostrN(FieldByName('RECHNUNG').AsInteger, e_r_RechnungsNummerAnzahlDerStellen);
            FaelligSeit := DateDiff(DateTime2Long(FieldByName('VALUTA').AsDateTime), DateGet);
            BelegNo := FieldByName('BELEG_R').AsString;
            if not(FieldByName('TEILLIEFERUNG').IsNull) then
              BelegNo := BelegNo + '-' + inttostrN(FieldByName('TEILLIEFERUNG').AsInteger, 2);

            qBELEG.ParamByName('CROSSREF').AsInteger := BELEG_R;
            if not(qBELEG.Active) then
              qBELEG.Open;

            // Sachen aus dem Beleg nachladen!
            if NoBELEG_R then
            begin
              DatensammlerLokal.add('Medium=');
              DatensammlerLokal.add('Motivation=');
              DatensammlerLokal.add('LastschriftText=');
              DatensammlerLokal.add('LastschriftTextNeu=');
            end
            else
            begin

              // Medium ausgeben
              DatensammlerLokal.add('Medium=' + qBELEG.FieldByName('MEDIUM').AsString);
              DatensammlerLokal.add('Motivation=' + qBELEG.FieldByName('MOTIVATION').AsString);

              // Laschrifttexte des Beleges (Eine Art Topic)
              LastschriftTexte := e_r_sqlsl(
                { } 'select ARTIKEL from POSTEN ' +
                { } 'where' +
                { } ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
                { } ' (AUSGABEART_R=' + inttostr(iAusgabeartLastschriftText) + ')' +
                { } 'order by' +
                { } ' POSNO,RID');
              DatensammlerLokal.add('LastschriftText=' + HugeSingleLine(LastschriftTexte));
              for n := pred(LastschriftTexte.count) downto 0 do
                if (LastschriftTexteAlle.IndexOf(LastschriftTexte[n]) <> -1) then
                  LastschriftTexte.delete(n);
              DatensammlerLokal.add('LastschriftTextNeu=' + HugeSingleLine(LastschriftTexte));
              LastschriftTexteAlle.addstrings(LastschriftTexte);
              LastschriftTexte.free;
            end;

            // Rechnungsdatum dieser Teillieferung
            if FieldByName('DATUM').IsNull then
              DatensammlerLokal.add('BelegDat=' + long2dateLocalized(DateTime2Long(qBELEG.FieldByName('RECHNUNG')
                .AsDateTime)))
            else
              DatensammlerLokal.add('BelegDat=' + long2dateLocalized(DateTime2Long(FieldByName('DATUM').AsDateTime)));

            //
            if (isSomeMoney(BuchungsBetrag)) then
            begin

              if IsOther(
                { } qBELEG.FieldByName('RECHNUNGS_BETRAG').AsFloat,
                { } qBELEG.FieldByName('DAVON_BEZAHLT').AsFloat) then
              begin

                ForderungStatus := b_r_ForderungStatus(AUSGANGSRECHNUNG_R);

                if (FaelligSeit > cDTA_LastschriftVerzoegerung) then
                  if (ForderungStatus = cForderung_Lastschrift_Erhalten) then
                  begin
                    // offensichtlich zurückgebucht da schon so lange her
                    ForderungStatus := 0;
                  end;

                if (ForderungStatus < cForderung_Lastschrift_Anstehend) then
                begin
                  if (FaelligSeit > 0) then
                  begin

                    // Abbuchung
                    if not(FieldByName('EREIGNIS_R').IsNull) then
                      if (FaelligSeit < cDTA_LastschriftVerzoegerung) then
                        MoreText := MoreText + ' ' + '(wird abgebucht)'
                      else
                        MoreText := MoreText + ' ' + '(Abbuchung ohne Erfolg)';

                    // auch buchen?
                    if pVerbuchen then
                      if (Verbucht_BELEG_R.IndexOf(qBELEG.FieldByName('RID').AsString) = -1) and
                        Ausgesetzt_BELEG_R.Lacks(qBELEG.FieldByName('RID').AsInteger) then
                      begin

                        with qBELEG do
                        begin

                          //
                          edit;
                          repeat

                            // ev. Mahnbescheid Eintragen?
                            if pAuchMahnbescheid then
                            begin
                              if (FieldByName('MAHNSTUFE').AsInteger >= 3) then
                              begin

                                // eintragen/verbuchen
                                FieldByName('MAHNBESCHEID').AsDateTime := pMahnMoment;

                                // alle infos rausgeben
                                FileCopy(
                                  { } cPersonPath(PERSON_R) +
                                  { } inttostrN(FieldByName('RID').AsInteger, 10) + '-*',
                                  { } MahnbescheidPath);

                                // auch Adress-Infos ausgeben
                                e_f_PersonInfo(PERSON_R, MahnbescheidPath);
                                break;
                              end;
                            end;

                            // hier normaler Mahnlauf
                            FieldByName('MAHNUNG').AsDateTime := pMahnMoment;
                            FieldByName('MAHNSTUFE').AsInteger := FieldByName('MAHNSTUFE').AsInteger + 1;
                            repeat

                              if FieldByName('MAHNUNG1').IsNull then
                              begin
                                FieldByName('MAHNUNG1').AsDateTime := pMahnMoment;
                                break;
                              end;

                              if FieldByName('MAHNUNG2').IsNull then
                              begin
                                FieldByName('MAHNUNG2').AsDateTime := pMahnMoment;
                                break;
                              end;

                              if FieldByName('MAHNUNG3').IsNull then
                              begin
                                FieldByName('MAHNUNG3').AsDateTime := pMahnMoment;
                                break;
                              end;

                            until yet;
                          until yet;
                          Post;

                          Verbucht_BELEG_R.add(qBELEG.FieldByName('RID').AsString);
                        end;
                      end;

                    if Ausgesetzt_BELEG_R.Lacks(qBELEG.FieldByName('RID').AsInteger) then
                    begin

                      if (FaelligSeit = 1) then
                        MoreText := MoreText + ' ' + format('(seit einem Tag in Verzug)', [FaelligSeit])
                      else
                        MoreText := MoreText + ' ' + format('(seit %d Tagen in Verzug)', [FaelligSeit]);
                      MaxTageVerzug := max(MaxTageVerzug, FaelligSeit);
                      BetragVerzug := BuchungsBetrag;
                      Summe_Verzug := Summe_Verzug + BuchungsBetrag;
                      Verzug := true;
                      Verzug_BELEG_R.add(BELEG_R);

                    end
                    else
                    begin
                      MoreText := MoreText + ' ' + '(Mahnung ausgesetzt)';
                    end;

                    // externer Rechnungsempfänger?
                    if not(qBELEG.FieldByName('RECHNUNGSANSCHRIFT_R').IsNull) and
                      (qBELEG.FieldByName('RECHNUNGSANSCHRIFT_R').AsInteger <> qBELEG.FieldByName('PERSON_R').AsInteger)
                    then
                    begin
                      MoreText := MoreText + #13 + #13 +
                        format('Rechnungsempfänger war %s.' + #13 +
                        'Bitte leiten Sie diese Information an den Rechnungsempfänger weiter. Wir weisen Sie ' +
                        'darauf hin, daß bei fortdauernder Nichtzahlung, Sie als Auftraggeber letztendlich zur Zahlung verpflichtet sind.',
                        [e_r_Person(qBELEG.FieldByName('RECHNUNGSANSCHRIFT_R').AsInteger)]);
                    end;

                  end
                  else
                  begin
                    case FaelligSeit of
                      0:
                        MoreText := MoreText + ' ' + '(heute fällig)';
                      1:
                        MoreText := MoreText + ' ' + '(morgen fällig)';
                    else
                      MoreText := MoreText + ' ' + format('(in %d Tagen fällig)', [-FaelligSeit]);
                    end;
                  end;
                end
                else
                begin
                  case ForderungStatus of
                    cForderung_Lastschrift_Anstehend:
                      MoreText := MoreText + ' ' + '(wartet auf Abbuchung)';
                    cForderung_Lastschrift_Vorgemerkt:
                      MoreText := MoreText + ' ' + '(wird abgebucht)';
                    cForderung_Lastschrift_Erhalten:
                      MoreText := MoreText + ' ' + '(Bank versuchte den Einzug)';
                  else
                    MoreText := MoreText + ' ' + '(Unbekannter Abbuchungsstatus)';
                  end;
                end;
              end
              else
              begin
                MoreText := MoreText + ' ' + '(ausgeglichen)';
                Summe_Ausgleich := Summe_Ausgleich + BuchungsBetrag;
              end;

              // weitere Texte
              with qBELEG do
              begin

                if not(FieldByName('MAHNUNG1').IsNull) then
                  MoreText := MoreText + #13 + 'Mahnung 1 erhielten Sie am' + ' ' +
                    long2dateLocalized(DateTime2Long(FieldByName('MAHNUNG1').AsDateTime));

                if not(FieldByName('MAHNUNG2').IsNull) then
                  MoreText := MoreText + #13 + 'Mahnung 2 erhielten Sie am' + ' ' +
                    long2dateLocalized(DateTime2Long(FieldByName('MAHNUNG2').AsDateTime));

                if not(FieldByName('MAHNUNG3').IsNull) then
                  MoreText := MoreText + #13 + 'Mahnung 3 erhielten Sie am' + ' ' +
                    long2dateLocalized(DateTime2Long(FieldByName('MAHNUNG3').AsDateTime));

                if not(FieldByName('MAHNBESCHEID').IsNull) then
                  MoreText := MoreText + #13 + 'Mahnbescheid beantragt am' + ' ' +
                    long2dateLocalized(DateTime2Long(FieldByName('MAHNBESCHEID').AsDateTime));

                SaldoLautBeleg := FieldByName('RECHNUNGS_BETRAG').AsFloat - FieldByName('DAVON_BEZAHLT').AsFloat;
                if (SaldoLautBeleg > 0) then
                  MaxMahnstufe := max(MaxMahnstufe, FieldByName('MAHNSTUFE').AsInteger);

              end;
              SaldoLautKonto := GetSaldo(FieldByName('BELEG_R').AsInteger);

              // Zinsberechnung?
              if (SaldoLautBeleg > 0) then
                if (FaelligSeit > 1) and Ausgesetzt_BELEG_R.Lacks(FieldByName('BELEG_R').AsInteger) then
                begin

                  // wirkliche Zinsberechnung
                  BerechneterZins := cPreisRundung(
                    { } SaldoLautBeleg *
                    { } (VerzugszinsSatz / 100.0) *
                    { } (FaelligSeit / 360));
                  DatensammlerLokal.add(format('Zins.Berechnet=%m', [BerechneterZins]));

                  // Korrektur der Berechnung
                  if (iMahnungMindestZins <> 0) then
                  begin
                    if (iMahnungMindestZins > 0) then
                    begin
                      if (BerechneterZins < iMahnungMindestZins) then
                        BerechneterZins := 0;
                    end
                    else
                    begin
                      if (BerechneterZins < -iMahnungMindestZins) then
                        BerechneterZins := -iMahnungMindestZins;
                    end;
                  end;

                  if isSomeMoney(BerechneterZins) then
                  begin
                    if (iMahnstufeZinsEintritt = -1) then
                      MoreText := MoreText + #13 + format('bei Verzugszinssatz von %.1f%% = %m',
                        [VerzugszinsSatz, BerechneterZins]);
                    VerzugszinsGesamt := VerzugszinsGesamt + BerechneterZins;
                    DatensammlerLokal.add(format('Zins.Ausgewiesen=%m', [BerechneterZins]));
                  end
                  else
                  begin
                    DatensammlerLokal.add('Zins.Ausgewiesen=');
                  end;

                end;

              if not(MoreTextManuell) then
                if (SaldoLautBeleg > 0) then
                  MoreText := MoreText + #13 + 'Noch zu zahlen sind' + ' ' + format('%m', [SaldoLautBeleg])
                else
                  MoreText := MoreText + #13 + 'Zuviel bezahlt sind' + ' ' + format('%m', [-SaldoLautBeleg]);

              if isSomeMoney(SaldoLautBeleg - SaldoLautKonto) then
              begin
                MoreText := MoreText + #13 + 'ACHTUNG: Konto-Saldo ist' + ' ' + format('%m', [SaldoLautKonto]);
                if not(OneDifferenz) then
                  result.add('DIFFERENZ=' + cC_True);
                OneDifferenz := true;
              end;

              if NoBELEG_R then
                if not(MoreTextManuell) then
                  MoreText := MoreText + #13 + 'INFO: diese Zahlung konnte keinem Beleg zugeordnet werden!';

              DatensammlerLokal.add('BelegFaellig=' + long2dateLocalized(DateTime2Long(FieldByName('VALUTA').AsDateTime)
                ) + #13 + MoreText + _KontoTexte);
              DatensammlerLokal.add('BelegBetrag=' + _BetragAsHTML(BuchungsBetrag));

              DatensammlerLokal.add('Betrag.Bezahlt=');
              DatensammlerLokal.add('Betrag.Offen=' + format('%m', [BuchungsBetrag]));
              DatensammlerLokal.add('Betrag.Forderung=' + format('%m', [BuchungsBetrag]));

              Summe_Offen := Summe_Offen + BuchungsBetrag;
            end
            else
            begin

              // der Betrag ist "0"
              DatensammlerLokal.add('BelegFaellig=' + long2dateLocalized(DateTime2Long(FieldByName('VALUTA').AsDateTime)
                ) + #13 + '(kostenfreie Nachlieferung)' + _KontoTexte);
              DatensammlerLokal.add('BelegBetrag=' + _BetragAsHTML(BuchungsBetrag));

              DatensammlerLokal.add('Betrag.Bezahlt=');
              DatensammlerLokal.add('Betrag.Offen=');
              DatensammlerLokal.add('Betrag.Forderung=');

            end;

          end
          else
          begin

            // Eine Zahlung des Kunden
            BelegNo := '---';
            RECHNUNGSNUMMER := '---';
            if Ausgesetzt_BELEG_R.Lacks(BELEG_R) then
            begin
              Summe_Zahlungen := Summe_Zahlungen + -BuchungsBetrag;
              if Verzug_BELEG_R.Contains(BELEG_R) then
                Verzug := true;
            end;

            DatensammlerLokal.add('MREF=');
            DatensammlerLokal.add('Medium=');
            DatensammlerLokal.add('Motivation=');
            DatensammlerLokal.add('LastschriftText=' + 'Ihre Zahlung');
            DatensammlerLokal.add('LastschriftTextNeu=' + 'Ihre Zahlung');
            DatensammlerLokal.add('BelegDat=' + long2dateLocalized(DateTime2Long(FieldByName('DATUM').AsDateTime)));
            if MoreTextManuell then
            begin
              DatensammlerLokal.add('BelegFaellig=' + MoreText + _KontoTexte)
            end
            else
            begin
              if FieldByName('TEILLIEFERUNG').IsNull then
              begin
                DatensammlerLokal.add('BelegFaellig=' + 'Ihre Zahlung zu den Rechnungen' + ' ' +
                  HugeSingleLine(e_r_RechnungsNummern(BELEG_R), ', '));
              end
              else
              begin
                DatensammlerLokal.add('BelegFaellig=' + 'Ihre Zahlung zur Rechnung' + ' ' +
                  e_r_RechnungsNummer(BELEG_R, FieldByName('TEILLIEFERUNG').AsInteger));
              end;
            end;

            DatensammlerLokal.add('BelegBetrag=' + _BetragAsHTML(BuchungsBetrag));
            DatensammlerLokal.add('Betrag.Bezahlt=' + format('%m', [-BuchungsBetrag]));
            DatensammlerLokal.add('Betrag.Offen=');
            DatensammlerLokal.add('Betrag.Forderung=');
          end;

          // Prüfung, ob Konto bisher ausgeglichen ist!
          if isZeroMoney(Summe_Offen - Summe_Zahlungen) then
          begin
            DatensammlerLokal.add('BelegNo=' + BelegNo + '*');
            DeleteAusgeglichen := ActLines;
          end
          else
          begin
            if (KontoTexte.values['BelegNo'] <> '') then
              DatensammlerLokal.add('BelegNo=' + KontoTexte.values['BelegNo'])
            else
              DatensammlerLokal.add('BelegNo=' + BelegNo);
          end;

          DatensammlerLokal.add('Rechnung=' + RECHNUNGSNUMMER);
          if (BetragVerzug <> 0.0) then
            DatensammlerLokal.add('Betrag.Verzug=' + format('%m', [BetragVerzug]))
          else
            DatensammlerLokal.add('Betrag.Verzug=');

          RECHNUNGEN := cutblank(RECHNUNGEN + ' ' + RECHNUNGSNUMMER);

          DatensammlerLokal.add(cPageBreakHerePossible);

        end;

        ApiNext;
      end;

      case MaxMahnstufe of
        0:
          MahnGebuehr := iMahnungGebuehr1;
        1:
          MahnGebuehr := iMahnungGebuehr2;
      else
        MahnGebuehr := iMahnungGebuehr3;
      end;

      if pMahnGebuehr then
        if (MahnGebuehr > 0) then
        begin
          Summe_Verzug := Summe_Verzug + MahnGebuehr;
          Summe_Offen := Summe_Offen + MahnGebuehr;
          Verzug := true;

          LoadArtikelBlock;
          DatensammlerLokal.add('BelegNo=');
          DatensammlerLokal.add('Rechnung=');
          DatensammlerLokal.add('BelegDat=');
          DatensammlerLokal.add('Medium=');
          DatensammlerLokal.add('Motivation=');
          DatensammlerLokal.add('LastschriftText=' + 'Mahngebühr');
          DatensammlerLokal.add('LastschriftTextNeu=' + 'Mahngebühr');
          DatensammlerLokal.add('BelegFaellig=' + 'Mahngebühr');
          DatensammlerLokal.add('BelegBetrag=' + _BetragAsHTML(MahnGebuehr));
          DatensammlerLokal.add('Betrag.Bezahlt=');
          DatensammlerLokal.add('Betrag.Verzug=' + format('%m', [MahnGebuehr]));
          DatensammlerLokal.add('Betrag.Offen=');
          DatensammlerLokal.add('Betrag.Forderung=' + format('%m', [MahnGebuehr]));
          DatensammlerLokal.add(cPageBreakHerePossible);
        end;

      if pMahnGebuehr then
        if (MaxMahnstufe >= iMahnstufeZinsEintritt) then
        begin
          VerzugszinsGesamt := cPreisRundung(VerzugszinsGesamt);
          if (VerzugszinsGesamt > 0.0) then
          begin
            Summe_Verzug := Summe_Verzug + VerzugszinsGesamt;
            Summe_Offen := Summe_Offen + VerzugszinsGesamt;
            Verzug := true;

            LoadArtikelBlock;
            DatensammlerLokal.add('BelegNo=');
            DatensammlerLokal.add('Rechnung=');
            DatensammlerLokal.add('BelegDat=');
            DatensammlerLokal.add('Medium=');
            DatensammlerLokal.add('Motivation=');
            DatensammlerLokal.add('LastschriftText=' + 'Verzugszins');
            DatensammlerLokal.add('LastschriftTextNeu=' + 'Verzugszins');
            DatensammlerLokal.add('BelegFaellig=' + 'Verzugszins');
            DatensammlerLokal.add('BelegBetrag=' + _BetragAsHTML(VerzugszinsGesamt));
            DatensammlerLokal.add('Betrag.Bezahlt=');
            DatensammlerLokal.add('Betrag.Verzug=' + format('%m', [VerzugszinsGesamt]));
            DatensammlerLokal.add('Betrag.Offen=');
            DatensammlerLokal.add('Betrag.Forderung=' + format('%m', [VerzugszinsGesamt]));
            DatensammlerLokal.add(cPageBreakHerePossible);
          end;
        end;

      Summe_Offen := Summe_Offen - Summe_Zahlungen;
      Summe_Verzug := max(0, Summe_Verzug - (Summe_Zahlungen - Summe_Ausgleich));

      DatensammlerGlobal.add('ZS=' + format('%.2m', [Summe_Offen]));
      result.add(format('OFFEN=%.2f', [Summe_Offen]));
      DatensammlerGlobal.add('RB=' + format('%.2m', [Summe_Verzug]));
      result.add(format('VERZUG=%.2f', [Summe_Verzug]));
      result.add(format('MAHNSTUFE=%d', [MaxMahnstufe]));
      result.add(format('SEIT=%d', [MaxTageVerzug]));
      result.add('RECHNUNGEN=' + RECHNUNGEN);
      result.add('BELEGE=' + BELEGE);
      result.add('TEILLIEFERUNGEN=' + TEILLIEFERUNGEN);

      if (Summe_Offen < 0) then
        result.add('GUTSCHRIFT=' + cC_True);

    end;
    cAUSGANGSRECHNUNG.free;

    if iMahnungErstAbUnausgeglichenheit and (DeleteAusgeglichen > 0) then
    begin

      // ddd
      for n := 1 to 3 do
        DatensammlerLokal.add('delete ARTIKEL');

      // xxx
      for n := 0 to pred(DeleteAusgeglichen) do
        DatensammlerLokal.add('delete ARTIKEL');

    end;

    with MahnungsBeleg do
    begin

      // Load Template
      repeat

        if (pTemplateFName <> '') then
        begin
          MahnungsBeleg.LoadFromFile(MyProgramPath + cHTMLTemplatesDir + pTemplateFName);
          break;
        end;

        if (MaxMahnstufe >= 2) then
          if FileExists(MyProgramPath + cHTMLTemplatesDir + 'Mahnung3.html') then
          begin
            DatensammlerGlobal.add('Beleg Titel=' + '3. Mahnung');
            DatensammlerGlobal.add('Typ=' + '3. MAHNUNG');
            MahnungsBeleg.LoadFromFile(MyProgramPath + cHTMLTemplatesDir + 'Mahnung3.html');
            break;
          end;

        if (MaxMahnstufe = 1) then
          if FileExists(MyProgramPath + cHTMLTemplatesDir + 'Mahnung2.html') then
          begin
            DatensammlerGlobal.add('Beleg Titel=' + '2. Mahnung');
            DatensammlerGlobal.add('Typ=' + '2. MAHNUNG');
            MahnungsBeleg.LoadFromFile(MyProgramPath + cHTMLTemplatesDir + 'Mahnung2.html');
            break;
          end;

        if FileExists(MyProgramPath + cHTMLTemplatesDir + 'Mahnung.html') then
          MahnungsBeleg.LoadFromFile(MyProgramPath + cHTMLTemplatesDir + 'Mahnung.html')
        else
          MahnungsBeleg.addFatalError('Vorlage .\Mahnung.html nicht gefunden!');

        DatensammlerGlobal.add('Beleg Titel=' + 'Information über fällige Zahlungen');
        DatensammlerGlobal.add('Typ=' + 'ZAHLUNGSINFO');

      until yet;

      // Insert Data
      WriteValue(DatensammlerLokal, DatensammlerGlobal);

      if (pTemplateFName = '') then
      begin
        // normale Mahnung
        result.add('OUT=' + OutPath + cHTML_MahnungFName);
        SaveToFileCompressed(OutPath + cHTML_MahnungFName);
      end
      else
      begin
        // was besonderes
        result.add('OUT=' + OutPath + pTemplateFName);
        SaveToFileCompressed(OutPath + pTemplateFName);
      end;
    end;
  except
    on E: exception do
    begin
      AppendStringsToFile('e_w_KontoInfo(' + inttostr(PERSON_R) + '): ' + E.Message,
      errorFName('BELEG'),
      Uhr12);
    end;
  end;
  MahnungsBeleg.free;
  for n := 0 to pred(Checked_BELEG_R.count) do
    TObject(Checked_BELEG_R.Objects[n]).free;
  Checked_BELEG_R.free;
  Ausgeglichen_BELEG_R.free;
  Ausgesetzt_BELEG_R.free;
  Verzug_BELEG_R.free;
  Verbucht_BELEG_R.free;
  cBELEGSALDO.free;
  cPERSON.free;
  cANSCHRIFT.free;
  qBELEG.free;
  DatensammlerGlobal.free;
  DatensammlerLokal.free;
  KontoTexte.free;
  LastschriftTexteAlle.free;
end;

function e_r_BestellInfo(PERSON_R: integer): integer;
var
  OutPath: string;
begin
  OutPath := MyProgramPath + 'Bestellungen\' + RIDasStr(PERSON_R) + '\';
  CheckCreateDir(OutPath);
  FileCopy(AnwenderPath + cHTML_OrderFName, OutPath + cHTML_OrderFName);
  result := 999;
end;

function e_w_BelegNeuAusKasse(EREIGNIS_R: integer): integer;
var
  BELEG_R: integer;
  ARTIKEL_R: integer;
  AUSGABEART_R: integer;
  ARTIKEL_AA_R: integer;
  SORTIMENT_R: integer;
  MENGE: integer;

  sKasse: string;
  lKasse: TStringList;
  ProzentPos: integer;
  DoppelPunktPos: integer;
  n, m: integer;
  nCode: integer;
  qPosten: TdboQuery;
  sCode: String;
  sSortiment: string;
  iSortiment: integer;
  MWST: double;

begin
  result := cRID_Null;

  lKasse := e_r_sqlt(
   {} 'select INFO from EREIGNIS where'+
   {} ' (ART=' + inttostr(eT_Kasse) + ') and'+
   {} ' (RID=' + inttostr(EREIGNIS_R) + ')');

  if (lKasse.count > 0) then
  begin
    qPosten := nQuery;
    try

      with qPosten do
      begin
        sql.add('select * from POSTEN ' + for_update);
{$IFNDEF fpc}
        ColumnAttributes.add('RID=NOTREQUIRED');
{$ENDIF}
        prepare;
      end;

      sKasse := lKasse[0];
      sKasse := ExtractSegmentBetween(sKasse, '"', '"');
      repeat
        ProzentPos := pos('%', sKasse);
        if (ProzentPos = 0) then
          break;
        sKasse := copy(sKasse, 1, pred(ProzentPos)) + chr(StrtoInt('$' + copy(sKasse, succ(ProzentPos), 2))) +
          copy(sKasse, ProzentPos + 3, MaxInt);
      until eternity;
      ersetze(#$D, '', sKasse);

      // Wieder in einzelne Zeilen aufteilen
      lKasse.free;
      lKasse := split(sKasse, #$A);

      // ev. hier noch Relevanz prüfen
      BELEG_R := e_w_BelegNeu(iSchnelleRechnung_PERSON_R);
      if (BELEG_R < cRID_FirstValid) then
        raise exception.create('Neue "Schnelle Rechnung" konnte nicht erstellt werden');

      e_x_sql(
        { } 'update BELEG set MEDIUM=''Kasse''' +
        { } ' where RID=' + inttostr(BELEG_R));
      e_x_sql(
        { } 'update EREIGNIS set' +
        { } ' BELEG_R=' + inttostr(BELEG_R) + ',' +
        { } ' BEENDET=CURRENT_TIMESTAMP,' +
        { } ' MENGE=coalesce(MENGE,0)+1' +
        { } 'where RID=' + inttostr(EREIGNIS_R));

      for n := 0 to pred(lKasse.count) do
      begin

        // Aussortieren
        if (lKasse[n] = '') then
          continue;
        if (lKasse[n][1] = cKasse_Log_Prefix) then
          continue;
        if (lKasse[n] = cKasse_Wiederholung) then
          continue;
        if (pos(cKasse_Faktor, lKasse[n]) > 0) then
          continue;

        // Look ahead
        MENGE := 1;
        for m := succ(n) to pred(lKasse.count) do
          if (lKasse[m] = cKasse_Wiederholung) then
            inc(MENGE)
          else
            break;

        // Look back
        if (pred(n) >= 0) then
          if (pos(cKasse_Faktor, lKasse[pred(n)]) > 0) then
            MENGE := MENGE + pred(StrToIntDef(nextp(lKasse[pred(n)], ' ', 0), 1));

        DoppelPunktPos := pos(cKasse_Sortiment_Delimiter, lKasse[n]);
        if (DoppelPunktPos > 0) then
        begin
          sCode := copy(lKasse[n], 1, pred(DoppelPunktPos));
          if pos(',', sCode) = 0 then
          begin
            nCode := StrToIntDef(sCode, -1);
            if (nCode > 0) then
            begin

              // erst mit Ausgabeart, dann ohne
              ARTIKEL_AA_R :=
              { } e_r_sql(
                { } 'select RID from ARTIKEL_AA where KASSE=' +
                { } inttostr(nCode));
              if (ARTIKEL_AA_R >= cRID_FirstValid) then
              begin
                ARTIKEL_R :=
                { } e_r_sql(
                  { } 'select ARTIKEL_R from ARTIKEL_AA where RID=' +
                  { } inttostr(ARTIKEL_AA_R));
                AUSGABEART_R :=
                { } e_r_sql(
                  { } 'select AUSGABEART_R from ARTIKEL_AA where RID=' +
                  { } inttostr(ARTIKEL_AA_R));
              end
              else
              begin
                ARTIKEL_R := e_r_sql('select RID from ARTIKEL where KASSE=' + inttostr(nCode));
                AUSGABEART_R := cRID_Null;
              end;

              // Einfügen in den Beleg!
              with qPosten do
              begin
                Insert;
                FieldByName('BELEG_R').AsInteger := BELEG_R;
                if (AUSGABEART_R >= cRID_FirstValid) then
                  FieldByName('AUSGABEART_R').AsInteger := AUSGABEART_R;
                FieldByName('MENGE').AsInteger := MENGE;
                if (ARTIKEL_R >= cRID_FirstValid) then
                begin
                  FieldByName('ARTIKEL_R').AsInteger := ARTIKEL_R;
                  e_w_SetPostenData(ARTIKEL_R, iSchnelleRechnung_PERSON_R, qPosten);
                end
                else
                begin
                  FieldByName('ARTIKEL').AsString := lKasse[n];
                end;
                Post;
              end;
            end;
          end
          else
          begin
            // Direkte Preis-Angabe!
            // MwST aus entsprechendem Sortiment
            iSortiment := StrToIntDef(ExtractSegmentBetween(lKasse[n], '(', ')'), 0);

            SORTIMENT_R :=
            { } e_r_sql(
              { } 'select RID from SORTIMENT where ZOLLCODE=' +
              { } inttostr(iSortiment));
            if (SORTIMENT_R >= cRID_FirstValid) then
              MWST := e_r_MwSt(SORTIMENT_R)
            else
              MWST := e_r_Prozent(iMwStSatzManuelleArtikel);

            with qPosten do
            begin
              Insert;
              FieldByName('BELEG_R').AsInteger := BELEG_R;
              FieldByName('PREIS').AsFloat := StrtoDouble(sCode);
              FieldByName('MWST').AsFloat := MWST;
              FieldByName('MENGE').AsInteger := MENGE;
              sSortiment := nextp(lKasse[n], ':', 1);
              sSortiment := cutblank(nextp(sSortiment, '(', 0));
              FieldByName('ARTIKEL').AsString := sSortiment;
              Post;
            end;
          end;
        end
        else
        begin
          // besonderen Befehl auswerten!
          // "BAR", "EC", "ANGEBOT"

          // Auf alle Fälle in den Beleg übernehmen
          with qPosten do
          begin
            Insert;
            FieldByName('BELEG_R').AsInteger := BELEG_R;
            FieldByName('MENGE').AsInteger := 0;
            FieldByName('ARTIKEL').AsString := lKasse[n];
            Post;
          end;

          // Das Buzz-Wort kommt auf alle Fälle in die Motivation
          // des neuen Beleges
          e_x_sql(
            { } 'update BELEG set MOTIVATION=''' + lKasse[n] + '''' +
            { } ' where (RID=' + inttostr(BELEG_R) + ')');

          // Bei besonderen Worten noch mehr Aktionen
          if (lKasse[n] = 'ANGEBOT') then
          begin
            e_x_sql(
              { } 'update BELEG set BSTATUS=''A''' +
              { } ' where (RID=' + inttostr(BELEG_R) + ')');
          end;

        end;
      end;

      // Nur im Erfolgsfall!
      result := BELEG_R;

    except
      on E: exception do
      begin
        AppendStringsToFile('e_w_BelegNeuAusKasse('+inttostr(EREIGNIS_R)+'): ' + E.Message,
        errorFName('BELEG'),
        Uhr12);
      end;
    end;

    qPosten.free;

  end;
  lKasse.free;
end;

function e_w_BelegNeuAusWarenkorb(PERSON_R: integer): integer;
var
  ArtikelAnzahl: integer;
  BELEG_R: integer;
begin
  result := cRID_Null;
  ArtikelAnzahl := e_r_sql(
   {} 'select sum(MENGE) from WARENKORB where'+
   {} ' (PERSON_R=' + inttostr(PERSON_R) +') and'+
   {} ' (SCHRANK is null)');
  if (ArtikelAnzahl > 0) then
  begin
    try
      BELEG_R := e_w_BelegNeu(PERSON_R);
      e_x_sql('update BELEG set MEDIUM=''WebShop'' where RID=' + inttostr(BELEG_R));
      e_w_WarenkorbEinfuegen(BELEG_R);

      // Nur im Erfolgsfall!
      result := BELEG_R;
    except
      on E: exception do
      begin
        AppendStringsToFile('e_w_BelegNeuAusWarenkorb('+IntToStr(PERSON_R)+'): ' + E.Message,
        ErrorFName('BELEG'),
        Uhr12);
      end;
    end;
  end;
end;


function e_r_VerlagsRabatt(VERLAG_R, PERSON_R: integer): double;
var
  // Cache
  RABATT_CODE: string;
  _RABATT_CODE: string;

  function matchRule(pSQL: string; var Rabatt: double): boolean;
  var
    qRABATT: TdboCursor;
  begin
    result := false;
    qRABATT := nCursor;
    with qRABATT do
    begin
      sql.add(pSQL);
      ApiFirst;
      if not(eof) then
      begin
        Rabatt := FieldByName('RABATT').AsFloat;
        result := true;
      end;
    end;
    qRABATT.free;
  end;

begin

  // erst mal die Rabatt-Stufe ermitteln
  result := 0.0;
  try
    repeat

      // gehört der Kunde überhaupt einer Rabattstufe an?
      RABATT_CODE := e_r_RabattCode(PERSON_R);
      if (RABATT_CODE = '') then
        break;

      while (RABATT_CODE <> '') do
      begin

        _RABATT_CODE := nextp(RABATT_CODE, ',');

        // Rabatt Regeln

        // nur über Verlag
        if matchRule(format('select RABATT from RABATT where (CODE=''%s'') and (PERSON_R=%d) and (SORTIMENT_R is null)',
          [_RABATT_CODE, VERLAG_R]), result) then
          break;

        // über Kombination: Verlag + erstes zufälliges Sortiment
        if matchRule
          (format('select RABATT from RABATT where (CODE=''%s'') and (PERSON_R=%d) and ((SORTIMENT_R is not null))',
          [_RABATT_CODE, VERLAG_R]), result) then
          break;

        // einfach nur über den globalen Code
        if matchRule
          (format('select RABATT from RABATT where (CODE=''%s'') and (ARTIKEL_R is null) and (SORTIMENT_R is null) and (PERSON_R is null)',
          [_RABATT_CODE]), result) then
          break;

      end;

    until yet;
  except
    on E: exception do
    begin
      AppendStringsToFile('e_r_VerlagsRabatt('+IntToStr(VERLAG_R)+','+IntToStr(PERSON_R)+'): ' + E.Message,
      ErrorFName('BELEG'),
      Uhr12);
    end;
  end;
end;


function e_w_PersonNeu: integer;
var
  ANSCHRIFT: TdboQuery;
  ANSCHRIFT_R: integer;
  PERSON: TdboQuery;
  PERSON_R: integer;
  NUMMER: integer;
begin
  result := -1;
  try
    BeginTransaction;
    ANSCHRIFT := nQuery;
    with ANSCHRIFT do
    begin
      ANSCHRIFT_R := e_w_GEN('GLOBAL_GID');
      sql.add('select * from anschrift ' + for_update);
      Insert;
      FieldByName('RID').AsInteger := ANSCHRIFT_R;
      FieldByName('LAND_R').AsInteger := iHeimatLand;
      FieldByName('NAME_OBEN').AsString := bool2cC(iAnschriftNameOben);
      Post;
    end;
    ANSCHRIFT.free;

    PERSON := nQuery;
    with PERSON do
    begin
      PERSON_R := e_w_GEN('POSTEN_GID');

      // versuchen eine neue Kundennummer zu erhalten
      repeat
        NUMMER := e_w_GEN('NK_KUNDE');
      until (e_r_sql('select count(RID) from PERSON where NUMMER=' + inttostr(NUMMER)) = 0);

      // Haupt-Datensatz anlegen
      sql.add('select * from person ' + for_update);
      Insert;
      FieldByName('RID').AsInteger := PERSON_R;
      FieldByName('NUMMER').AsInteger := NUMMER;
      FieldByName('NACHNAME').AsString := 'Neuer Eintrag';
      FieldByName('PRIV_ANSCHRIFT_R').AsInteger := ANSCHRIFT_R;
      FieldByName('EINTRAG').AsDateTime := now;
      FieldByName('USER_SALT').AsString := FindANewPassword;
      Post;
    end;
    PERSON.free;
    EndTransaction;

    result := PERSON_R;
  except
    on E: exception do
    begin
      AppendStringsToFile('e_w_PersonNeu: ' + E.Message,
        ErrorFName('BELEG'),
        Uhr12);
    end;
  end;
end;

function e_r_AgentMenge(AUSGABEART_R, ARTIKEL_R: integer): integer;
var
  POSTEN: TdboCursor;
begin
  POSTEN := nCursor;
  with POSTEN do
  begin
    sql.add('SELECT SUM(MENGE_AGENT) MENGE_AGENT FROM POSTEN WHERE');
    sql.add(' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') AND');
    sql.add(' (MENGE_AGENT>0) AND');
    if (AUSGABEART_R < 1) then
      sql.add(' (AUSGABEART_R IS NULL)')
    else
      sql.add(' (AUSGABEART_R=' + inttostr(AUSGABEART_R) + ')');
    ApiFirst;
    result := FieldByName('MENGE_AGENT').AsInteger;
  end;
  POSTEN.free;
end;

function e_r_Aktion(Name: String; BELEG_R: integer): boolean;
var
  pOLAP, xOLAP, rOLAP: TStringList;
  FName: string;
begin
  FName := iSystemOlapPath + 'System.Beleg.Aktion' + cOLAPExtension;
  if FileExists(FName) then
  begin
    pOLAP := TStringList.create;
    xOLAP := TStringList.create;
    pOLAP.add('$NAME=' + Name);
    pOLAP.add('$BELEG_R=' + inttostr(BELEG_R));
    xOLAP.LoadFromFile(FName);
    rOLAP := e_r_OLAP(xOLAP, pOLAP);
    result := StrToIntDef(rOLAP.values['ANZAHL'], cRID_Null) = 0;
    pOLAP.free;
    rOLAP.free;
    xOLAP.free;
  end
  else
  begin
    result := false;
  end;
end;

function e_r_Adressat(PERSON_R: integer): TStringList;
var
  cPERSON: TdboCursor;
  cANSCHRIFT: TdboCursor;
  n: integer;
begin

  cPERSON := nCursor;
  with cPERSON do
  begin
    sql.add('select VORNAME,NACHNAME,ANREDE,PRIV_ANSCHRIFT_R from PERSON where RID=' + inttostr(PERSON_R));
    ApiFirst;
  end;

  cANSCHRIFT := nCursor;
  with cANSCHRIFT do
  begin
    sql.add('select NAME_OBEN,NAME1,NAME2 from ANSCHRIFT where RID=' + inttostr(cPERSON.FieldByName('PRIV_ANSCHRIFT_R')
      .AsInteger));
    ApiFirst;
  end;

  result := TStringList.create;

  if (cANSCHRIFT.FieldByName('NAME_OBEN').AsString = cC_True) then
  begin
    result.add(cANSCHRIFT.FieldByName('NAME1').AsString);
    result.add(cANSCHRIFT.FieldByName('NAME2').AsString);
    result.add(cPERSON.FieldByName('ANREDE').AsString);
    result.add(e_r_Name(cPERSON));
  end
  else
  begin
    result.add(cPERSON.FieldByName('ANREDE').AsString);
    result.add(e_r_Name(cPERSON));
    result.add(cANSCHRIFT.FieldByName('NAME1').AsString);
    result.add(cANSCHRIFT.FieldByName('NAME2').AsString);
  end;

  for n := pred(result.count) downto 0 do
    if result[n] = '' then
      result.delete(n);
  while (result.count < 4) do
    result.Insert(0, '');

  cPERSON.free;
  cANSCHRIFT.free;
end;

procedure e_r_Bank(PERSON_R: integer; sl: TStringList; Prefix: string = '');
var
  cPERSON: TdboCursor;
begin
  sl.add(Prefix + 'ZahlungInhaber=' + e_r_KontoInhaber(PERSON_R));
  cPERSON := nCursor;
  with cPERSON do
  begin
    sql.add('select Z_ELV_BANK_NAME,');
    sql.add(' Z_ELV_KONTO,Z_ELV_BLZ');
    sql.add('from PERSON where');
    sql.add('RID=' + inttostr(PERSON_R));
    ApiFirst;
    sl.add(Prefix + 'ZahlungBLZ=' + FieldByName('Z_ELV_BLZ').AsString);
    sl.add(Prefix + 'ZahlungKonto=' + FieldByName('Z_ELV_KONTO').AsString);
    sl.add(Prefix + 'ZahlungBank=' + FieldByName('Z_ELV_BANK_NAME').AsString);
  end;
  cPERSON.free;
end;

procedure e_r_Anschrift(PERSON_R: integer; Datensammler: TStringList; Prefix: string = '');
var
  PERSON, ANSCHRIFT: TdboCursor;
  Adressat: TStringList;
  Ort: TStringList;
  n : integer;
begin
  PERSON := nCursor;
  ANSCHRIFT := nCursor;
  try
    repeat
      PERSON.sql.add('select * from PERSON where RID=' + inttostr(PERSON_R));
      PERSON.ApiFirst;
      if PERSON.eof then
        break;
      Datensammler.add(Prefix + 'K#=' + PERSON.FieldByName('NUMMER').AsString);
      Datensammler.add(Prefix + 'H#=' + PERSON.FieldByName('HAUPT_NUMMER').AsString);
      Datensammler.add(Prefix + 'KontoAR=' + PERSON.FieldByName('KONTO_AR').AsString);
      Datensammler.add(Prefix + 'KontoER=' + PERSON.FieldByName('KONTO_ER').AsString);
      Datensammler.add(Prefix + 'Anrede=' + PERSON.FieldByName('ANREDE').AsString);
      Datensammler.add(Prefix + 'Ansprache=' + PERSON.FieldByName('ANSPRACHE').AsString);
      Datensammler.add(Prefix + 'Vorname=' + PERSON.FieldByName('VORNAME').AsString);
      Datensammler.add(Prefix + 'Nachname=' + PERSON.FieldByName('NACHNAME').AsString);
      Datensammler.add(Prefix + 'Name=' + cutblank(PERSON.FieldByName('VORNAME').AsString + ' ' +
        PERSON.FieldByName('NACHNAME').AsString));
      Datensammler.add(Prefix + 'Fax=' + e_r_fax(PERSON));
      Datensammler.add(Prefix + 'Telefon=' + e_r_telefon(PERSON));
      Datensammler.add(Prefix + 'Handy=' + PERSON.FieldByName('HANDY').AsString);
      Datensammler.add(Prefix + 'eMail=' + PERSON.FieldByName('USER_ID').AsString);
      Datensammler.add(Prefix + 'Versicherungsnummer=' + PERSON.FieldByName('VERSICHERUNGSNUMMER').AsString);

      ANSCHRIFT.sql.add('select * from ANSCHRIFT where RID=' + PERSON.FieldByName('PRIV_ANSCHRIFT_R').AsString);
      ANSCHRIFT.ApiFirst;
      if ANSCHRIFT.eof then
        break;
      Adressat := e_r_Adressat(PERSON.FieldByName('RID').AsInteger);
      Datensammler.add(Prefix + 'Adressat1=' + Adressat[0]);
      Datensammler.add(Prefix + 'Adressat2=' + Adressat[1]);
      Datensammler.add(Prefix + 'Adressat3=' + Adressat[2]);
      Datensammler.add(Prefix + 'Adressat4=' + Adressat[3]);
      Adressat.free;
      Datensammler.add(Prefix + 'Name1=' + ANSCHRIFT.FieldByName('NAME1').AsString);
      Datensammler.add(Prefix + 'Name2=' + ANSCHRIFT.FieldByName('NAME2').AsString);
      Datensammler.add(Prefix + 'Strasse=' + ANSCHRIFT.FieldByName('STRASSE').AsString);

      Ort := e_r_Ort(ANSCHRIFT);
      if (Ort.count>0) then
       Datensammler.add(Prefix + 'Ort=' + Ort[0]);
      for n := 0 to pred(Ort.Count) do
       Datensammler.add(Prefix + 'Ort' + inttostr(succ(n)) + '=' + Ort[n]);
      for n := succ(Ort.Count) to 2 do
        Datensammler.add(Prefix + 'Ort' + inttostr(n) + '=');
      Ort.free;

    until yet;
  except
    on E: exception do
    begin
      AppendStringsToFile('e_r_Anschrift: ' + E.Message,
        ErrorFName('BELEG'),
        Uhr12);
    end;
  end;
  PERSON.free;
  ANSCHRIFT.free;
end;

function e_r_UnbestellteMenge(AUSGABEART_R, ARTIKEL_R: integer): integer;
var
  BPosten: TdboCursor;
begin
  BPosten := nCursor;
  with BPosten do
  begin
    sql.add('SELECT');
    sql.add(' SUM(MENGE_UNBESTELLT) MENGE_UNBESTELLT');
    sql.add('FROM BPOSTEN WHERE');
    sql.add(' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') AND');
    sql.add(' (MENGE_UNBESTELLT>0) AND');
    if (AUSGABEART_R < 1) then
      sql.add(' (AUSGABEART_R IS NULL)')
    else
      sql.add(' (AUSGABEART_R=' + inttostr(AUSGABEART_R) + ')');
    ApiFirst;
    result := FieldByName('MENGE_UNBESTELLT').AsInteger;
  end;
  BPosten.free;
end;

function e_r_OffeneMenge(AUSGABEART_R, ARTIKEL_R: integer): integer;
var
  BPosten: TdboCursor;
begin
  // ungeliefert = "unbestelltes" + "erwartetes"
  BPosten := nCursor;
  with BPosten do
  begin
    sql.add('SELECT');
    sql.add(' SUM(MENGE_UNBESTELLT) MENGE_UNBESTELLT,');
    sql.add(' SUM(MENGE_ERWARTET) MENGE_ERWARTET');
    sql.add('FROM BPOSTEN WHERE');
    sql.add(' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') AND');
    sql.add(' ((MENGE_UNBESTELLT>0) OR (MENGE_ERWARTET>0)) AND');
    if (AUSGABEART_R < 1) then
      sql.add(' (AUSGABEART_R IS NULL)')
    else
      sql.add(' (AUSGABEART_R=' + inttostr(AUSGABEART_R) + ')');
    Open;
    ApiFirst;
    result := FieldByName('MENGE_ERWARTET').AsInteger + FieldByName('MENGE_UNBESTELLT').AsInteger;
    Close;
  end;
  BPosten.free;
end;

function e_r_ErwarteteMenge(AUSGABEART_R, ARTIKEL_R: integer; sDetails: TStringList = nil): integer;
var
  BPosten: TdboCursor;
begin
  result := 0;
  if (ARTIKEL_R > 0) then
  begin
    BPosten := nCursor;
    with BPosten do
    begin
      sql.add('SELECT');
      sql.add(' RID,BELEG_R,MENGE_ERWARTET');
      sql.add('FROM BPOSTEN WHERE');
      sql.add(' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') AND');
      sql.add(' (MENGE_ERWARTET>0) AND');
      if (AUSGABEART_R < 1) then
        sql.add(' (AUSGABEART_R IS NULL)')
      else
        sql.add(' (AUSGABEART_R=' + inttostr(AUSGABEART_R) + ')');
      ApiFirst;
      while not(eof) do
      begin
        result := result + FieldByName('MENGE_ERWARTET').AsInteger;
        if assigned(sDetails) then
          sDetails.add(FieldByName('RID').AsString + ';' + // 0 = BPOSTEN_R
            FieldByName('BELEG_R').AsString + ';' + // 1 = BBELEG_R
            FieldByName('MENGE_ERWARTET').AsString // 2 = MENGE
            );
        ApiNext;
      end;
    end;
    BPosten.free;
  end;
end;


function e_r_UngelieferteMengeUeberBedarf(AUSGABEART_R, ARTIKEL_R: integer): integer;
begin
  result := max(0, e_r_OffeneMenge(AUSGABEART_R, ARTIKEL_R) - (e_r_AgentMenge(AUSGABEART_R, ARTIKEL_R) +
    e_r_MindestMenge(AUSGABEART_R, ARTIKEL_R)));
end;

function e_r_VorschlagMenge(AUSGABEART_R, ARTIKEL_R: integer): integer;
begin
  result := (e_r_MindestMenge(AUSGABEART_R, ARTIKEL_R) + e_r_AgentMenge(AUSGABEART_R, ARTIKEL_R)) -
    (e_r_Menge(cRID_Null, AUSGABEART_R, ARTIKEL_R) + e_r_OffeneMenge(AUSGABEART_R, ARTIKEL_R));
end;

function e_r_PackformGewicht(BELEG_R: integer): integer;
var
  TEILLIEFERUNG: integer;
  VERSAND_R: integer;
  PACKFORM_R: integer;
begin
  TEILLIEFERUNG := e_r_sql('select TEILLIEFERUNG from BELEG where RID=' + inttostr(BELEG_R));
  VERSAND_R := e_r_sql(
   {} 'select RID from VERSAND where' +
   {} ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
   {} ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')');
  if (VERSAND_R >= cRID_FirstValid) then
  begin
    // Es ist bereits ein Versand-Eintrag da!
    result := e_r_sql('select LEERGEWICHT from VERSAND where RID=' + inttostr(VERSAND_R));
  end
  else
  begin
    // Es muss das default Gewicht angenommen werden!
    if (e_r_StandardVersender=0) then
    begin
      result := 0;
    end else
    begin
      PACKFORM_R := e_r_sql('select PACKFORM_R from VERSENDER where RID=' + inttostr(e_r_StandardVersender));
      result := e_r_sql('select GEWICHT from PACKFORM where RID=' + inttostr(PACKFORM_R));
    end;
  end;
end;

function e_r_VersandKosten(BELEG_R: integer): integer;
type
  TePortoModus = (ePortoUngesetzt, ePortoZwang, ePortoFrei, ePortoAuto);
var
  ARTIKEL_R: integer;
  Beleg: TdboCursor;
  eResult: TStringList;
  VREGEL: TdboCursor;
  DebugS: TStringList;
  EndlessRecurseDetection: TStringList;
  PERSON_R: integer;
  MENGE_AUFNAHMEN: integer;

  // cache
  BTYP: string;
  TL: integer;
  GENERATION_POSTFIX: string;
  INTERN_INFO: TStringList;
  PortoModus: TePortoModus;
  AuftragsWert: double;

  // V - Regel Eingangs Parameter
  IN_LAND_R: integer;
  IN_warenwert: double;
  IN_gewicht: integer;

  procedure Log(s: string); overload;
  begin
    if assigned(DebugS) then
      DebugS.add(s);
  end;

  procedure Log(s: TStrings); overload;
  begin
    if assigned(DebugS) then
      DebugS.addstrings(s);
  end;

  function VCheck(Condition: string): integer;
  var
    VREGEL: TdboCursor;
  begin
    result := -1;
    VREGEL := nCursor;
    with VREGEL do
    begin
      sql.add('SELECT');
      sql.add(' OUT_ARTIKEL_R,RID');
      sql.add('FROM');
      sql.add(' VREGEL');
      sql.add('WHERE');
      sql.add(' (IN_LAND_R=' + inttostr(IN_LAND_R) + ') AND');
      sql.add(Condition);
      Log(sql);
      ApiFirst;
      if not(eof) then
      begin
        result := FieldByName('OUT_ARTIKEL_R').AsInteger;
        Log('OUT_RID=' + FieldByName('RID').AsString);
        Log('OUT_ARTIKEL_R=' + inttostr(result));
      end
      else
      begin
        Log('!FAIL!');
      end;
    end;
    VREGEL.free;
  end;

  function doubletostr(d: double): string;
  begin
    result := format('%.2f', [d]);
    ersetze('.', '', result);
    ersetze(',', '.', result);
  end;

begin
  result := cRID_Null;
  try
    if (BELEG_R >= cRID_FirstValid) then
    begin
      //
      INTERN_INFO := TStringList.create;
      if TestMode then
        DebugS := TStringList.create
      else
        DebugS := nil;

      BTYP := '';
      Log('BELEG_R=' + inttostr(BELEG_R));

      // Belege
      Beleg := nCursor;
      with Beleg do
      begin
        sql.add('SELECT TEILLIEFERUNG,BTYP,PERSON_R,LIEFERANSCHRIFT_R,GENERATION,INTERN_INFO FROM BELEG WHERE RID=' +
          inttostr(BELEG_R));
        ApiFirst;
        BTYP := FieldByName('BTYP').AsString;
        TL := FieldByName('TEILLIEFERUNG').AsInteger;
        GENERATION_POSTFIX := '-' + inttostrN(FieldByName('GENERATION').AsInteger, 2);
        e_r_sqlt(FieldByName('INTERN_INFO'), INTERN_INFO);
        if (BTYP = '') then
          BTYP := INTERN_INFO.values['BTYP' + GENERATION_POSTFIX];

        if not(FieldByName('LIEFERANSCHRIFT_R').IsNull) then
          PERSON_R := FieldByName('LIEFERANSCHRIFT_R').AsInteger
        else
          PERSON_R := FieldByName('PERSON_R').AsInteger;
      end;
      Beleg.free;

      Log('PERSON_R=' + inttostr(PERSON_R));

      // LAND_R ermitteln
      IN_LAND_R := e_r_sql(
       { } 'select LAND_R from ANSCHRIFT where RID=(' +
       { } 'select PRIV_ANSCHRIFT_R from PERSON where RID=' + inttostr(PERSON_R) + ')');

      Log('IN_LAND_R=' + inttostr(IN_LAND_R));

      // Beleg oder Warenkorb auswerten und Warenwert ermitteln!
      eResult := e_r_BelegInfo(BELEG_R);
      Log(eResult);
      AuftragsWert := StrtoDouble(eResult.values['AUFTRAGSWERT']);
      MENGE_AUFNAHMEN := StrToIntDef(eResult.values['AUFNAHMEN'], 0);

      PortoModus := ePortoAuto;
      repeat

        if (BTYP = 'P') then
        begin
          PortoModus := ePortoZwang;
          break;
        end;

        if (BTYP = 'p') or (MENGE_AUFNAHMEN > 0) then
        begin
          PortoModus := ePortoFrei;
          break;
        end;

        if e_r_RabattFaehig(PERSON_R) then
        begin
          PortoModus := ePortoZwang;
          break;
        end;

        if (TL > 0) then
        begin
          PortoModus := ePortoFrei;
          break;
        end;

        if (IN_LAND_R <> iHeimatLand) then
        begin
          PortoModus := ePortoZwang;
          break;
        end;

        if (AuftragsWert >= e_r_PortoFreiAbBrutto(PERSON_R)) then
        begin
          PortoModus := ePortoFrei;
          break;
        end;

        // Aktion?
        if e_r_Aktion('Portofrei', BELEG_R) then
        begin
          PortoModus := ePortoFrei;
          break;
        end;

      until yet;

      if (PortoModus = ePortoAuto) and (TL = 0) then
      begin
        IN_warenwert := StrtoDouble(eResult.values['AUFTRAGSWERT']);
        IN_gewicht := StrtoInt(eResult.values['AUFTRAGSGEWICHT']);
        if iBruttoVersandGewicht then
          inc(IN_gewicht, StrtoInt(eResult.values['PACKFORMGEWICHT']));
      end
      else
      begin
        IN_warenwert := StrtoDouble(eResult.values['WARENWERT']);
        IN_gewicht := StrtoInt(eResult.values['LIEFERGEWICHT']);
      end;
      eResult.free;

      // wann soll Portologik angewendet werden?
      if (PortoModus in [ePortoZwang, ePortoAuto]) then
      begin

        // jetzt die Regeln anwenden
        EndlessRecurseDetection := TStringList.create;
        repeat

          // WARENWERT UND GEWICHT
          ARTIKEL_R := VCheck(' (' + doubletostr(IN_warenwert) + '>=IN_WARENWERT_VON) AND' + ' (' +
            doubletostr(IN_warenwert) + '<=IN_WARENWERT_BIS) AND' + ' (' + inttostr(IN_gewicht) +
            '>=IN_GEWICHT_VON) AND' + ' (' + inttostr(IN_gewicht) + '<=IN_GEWICHT_BIS)');
          if ARTIKEL_R <> -1 then
            break;

          // WARENWERT
          ARTIKEL_R := VCheck(' (' + doubletostr(IN_warenwert) + '>=IN_WARENWERT_VON) AND' + ' (' +
            doubletostr(IN_warenwert) + '<=IN_WARENWERT_BIS) AND' + ' (IN_GEWICHT_VON IS NULL) AND' +
            ' (IN_GEWICHT_BIS IS NULL)');
          if (ARTIKEL_R <> -1) then
            break;

          // GEWICHT
          ARTIKEL_R := VCheck(' (IN_WARENWERT_VON IS NULL) AND' + ' (IN_WARENWERT_BIS IS NULL) AND' + ' (' +
            inttostr(IN_gewicht) + '>=IN_GEWICHT_VON) AND' + ' (' + inttostr(IN_gewicht) + '<=IN_GEWICHT_BIS)');
          if (ARTIKEL_R <> -1) then
            break;

          // letzte Chanche: Land-Alias
          VREGEL := nCursor;
          with VREGEL do
          begin
            sql.add('select OUT_LAND_R from VREGEL where');
            sql.add(' (IN_LAND_R=' + inttostr(IN_LAND_R) + ') AND');
            sql.add(' (OUT_LAND_R IS NOT NULL)');
            Log(sql);
            ApiFirst;
            if eof then
            begin
              IN_LAND_R := 0;
              Log('!FAIL!');
            end
            else
            begin
              IN_LAND_R := FieldByName('OUT_LAND_R').AsInteger;
              Log('OUT_LAND_R=' + inttostr(IN_LAND_R));
              if EndlessRecurseDetection.IndexOf(inttostr(IN_LAND_R)) <> -1 then
              begin
                // da war ich schon mal! -> Rekursion
                Log('!RECURSE!');
                IN_LAND_R := 0;
              end
              else
              begin
                EndlessRecurseDetection.add(inttostr(IN_LAND_R));
              end;
            end;
            Close;
          end;
          VREGEL.free;
          if (IN_LAND_R = 0) then
            break;

        until eternity;
        EndlessRecurseDetection.free;
      end
      else
      begin
        // Markierung für Portofrei!
        ARTIKEL_R := 0;
      end;

      result := ARTIKEL_R;
      Log('ARTIKEL_R=' + inttostr(result));
      if assigned(DebugS) then
      begin
        DebugS.SaveToFile(DiagnosePath + 'VREGEL.txt');
        DebugS.free;
      end;
      INTERN_INFO.free;

    end;
  except
    on E: exception do
    begin
      AppendStringsToFile('e_r_VersandKosten(' + inttostr(BELEG_R) + '): ' + E.Message,
        ErrorFName('BELEG'),
        Uhr12);
    end;
  end;
end;

function e_r_Versender(BELEG_R, TEILLIEFERUNG: integer): string;
var
  VERSENDER_R: integer;
begin
  VERSENDER_R := e_r_sql(
   { } 'select VERSENDER_R from VERSAND where' +
   { } ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
   { } ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')');
  if (VERSENDER_R < cRID_FirstValid) then
    VERSENDER_R := e_r_StandardVersender;
  if (VERSENDER_R < cRID_FirstValid) then
   result := ''
  else
   result := e_r_sqls('select BEZEICHNUNG from VERSENDER where RID=' + inttostr(VERSENDER_R));
end;

function e_r_PLZlength(ib_q: TdboDataSet): integer;
var
  _LandFormatStr: string;
  k: integer;
begin
  result := cPLZlength_default;
  _LandFormatStr := e_r_LaenderOrtFormat(ib_q.FieldByName('LAND_R').AsInteger);
  k := pos('%p', _LandFormatStr);
  if (k > 0) and (k + 2 <= length(_LandFormatStr)) then
    if CharInSet(_LandFormatStr[k + 2], ['0' .. '9']) then
      result := StrToIntDef(_LandFormatStr[k + 2], cPLZlength_default);
end;

function e_r_Ort(dboDS: TdboDataSet): TStringList; overload;
// benötigt
//
// (LAND_R, STATE, ORT, PLZ, ORTSTEIL)
//
//
var
  k: integer;
  PLZlength: integer;
  sResult : string;
begin
  with dboDS do
  begin
    sResult := e_r_LaenderOrtFormat(FieldByName('LAND_R').AsInteger);

    // Postleitzahl
    k := pos('%p', sResult);
    repeat
      if (k > 0) and (k + 2 <= length(sResult)) then
      begin
        if CharInSet(sResult[k + 2], ['0' .. '9']) then
        begin
          PLZlength := StrToIntDef(sResult[k + 2], cPLZlength_default);
          System.delete(sResult, k + 2, 1);
          ersetze('%p', e_r_plz(dboDS, PLZlength), sResult);
          break;
        end;
      end;
      ersetze('%p', e_r_plz(dboDS, cPLZlength_default), sResult);
    until yet;

    ersetze('%l', e_r_land(dboDS), sResult);
    ersetze('%s', FieldByName('STATE').AsString, sResult);
    ersetze('%o', FieldByName('ORT').AsString, sResult);
    ersetze('%t', FieldByName('ORTSTEIL').AsString, sResult);
    ersetze('%c', e_r_LaenderInternational(FieldByName('LAND_R').AsInteger), sResult);

    result := split(sResult,'|');
  end;
end;

function e_r_Ort(PERSON_R: integer): TStringList; overload;
var
  ANSCHRIFT: TdboCursor;
begin
  ANSCHRIFT := nCursor;
  with ANSCHRIFT do
  begin
    sql.add('select A.LAND_R, A.STATE, A.PLZ, A.ORT, A.ORTSTEIL from PERSON P');
    sql.add('join ANSCHRIFT A on A.RID=P.PRIV_ANSCHRIFT_R');
    sql.add('where P.RID=' + inttostr(PERSON_R));
    ApiFirst;
    if not(eof) then
      result := e_r_Ort(ANSCHRIFT)
    else
      result := TStringList.Create;
  end;
  ANSCHRIFT.free;
end;

function e_r_land(ib_q: TdboDataSet): string;
begin
  result := e_r_LaenderPost(ib_q.FieldByName('LAND_R').AsInteger);
end;

function e_r_plz(ib_q: TdboDataSet; PLZlength: integer = -1): string;
var
  _land_sub: string;
  _plz_sub: string;
begin
  with ib_q do
  begin
    if not(FieldByName('PLZ').IsNull) then
    begin
      _land_sub := e_r_land(ib_q);
      _plz_sub := FieldByName('PLZ').AsString;
      if (PLZlength > 0) then
        _plz_sub := fill('0', PLZlength - length(_plz_sub)) + _plz_sub;
      result := _plz_sub;
    end
    else
    begin
      result := '';
    end;
  end;
end;

procedure e_r_PostenInfo(IBQ: TdboDataSet; NurGeliefertes: boolean; EinzelpreisNetto: boolean;
  var _Anz, _AnzAuftrag, _AnzGeliefert, _AnzStorniert, _AnzAgent: integer;
  var _Rabatt, _EinzelPreis, _MwStSatz: double);
begin
  with IBQ do
  begin

    if NurGeliefertes then
    begin
      _Anz := FieldByName('MENGE_GELIEFERT').AsInteger;
      _AnzAuftrag := _Anz;
      _AnzStorniert := 0;
      _AnzGeliefert := 0;
      _AnzAgent := 0;
    end
    else
    begin
      _Anz := FieldByName('MENGE_RECHNUNG').AsInteger;
      _AnzAuftrag := FieldByName('MENGE').AsInteger;
      _AnzStorniert := FieldByName('MENGE_AUSFALL').AsInteger;
      if (FieldByName('AUSGABEART_R').AsInteger = cAusgabeArt_Aufnahme_MP3) then
      begin
        // Freie Resource, hier gibt es keine Teillieferungen oder
        // Bestellungen
        _AnzGeliefert := 0;
        _AnzAgent := 0;
      end
      else
      begin
        _AnzGeliefert := FieldByName('MENGE_GELIEFERT').AsInteger;
        _AnzAgent := FieldByName('MENGE_AGENT').AsInteger;
      end;

      // ungebuchte Menge kommt noch hinzu
      inc(_Anz, _AnzAuftrag - (_Anz + _AnzGeliefert + _AnzStorniert + _AnzAgent));
    end;

    // Preis
    _MwStSatz := FieldByName('MWST').AsFloat;
    _EinzelPreis := FieldByName('PREIS').AsFloat;

    // MwSt raus oder dazu
    if (_MwStSatz <> 0.0) then
    begin
      if EinzelpreisNetto then
      begin
        // ggf. Preis auf Netto-runterrechnen
        if (FieldByName('NETTO').AsString <> cC_True) then
          _EinzelPreis := cNetto(_MwStSatz, _EinzelPreis);
      end
      else
      begin
        // ggf. Preis auf brutto hochrechnen
        if (FieldByName('NETTO').AsString = cC_True) then
          _EinzelPreis := cBrutto(_MwStSatz, _EinzelPreis);
      end;
    end;

    // Rabatt
    _Rabatt := FieldByName('RABATT').AsFloat;

  end;
end;

function e_r_BelegSaldo(BELEG_R: integer; TEILLIEFERUNG: integer = cRID_Null): double;
begin
  if is1400 then
  begin
    if (TEILLIEFERUNG = cRID_Null) then
      result := e_r_sqld(
        { } 'select sum(BETRAG) from BUCH where' +
        { } ' (NAME=' + cKonto_Forderungen_AsDBString + ') and' +
        { } ' (BELEG_R=' + inttostr(BELEG_R) + ')')
    else
      result := e_r_sqld(
        { } 'select sum(BETRAG) from BUCH where ' +
        { } ' (NAME=' + cKonto_Forderungen_AsDBString + ') and' +
        { } ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
        { } ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')')
  end
  else
  begin
    if (TEILLIEFERUNG = cRID_Null) then
      result := e_r_sqld('select sum(BETRAG) from AUSGANGSRECHNUNG where BELEG_R=' + inttostr(BELEG_R))
    else
      result := e_r_sqld('select sum(BETRAG) from AUSGANGSRECHNUNG where ' + '(BELEG_R=' + inttostr(BELEG_R) + ') and '
        + '(TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')')
  end;
end;

function e_r_BelegForderungen(BELEG_R: integer): double;
begin
  if is1400 then
    result := e_r_sqld(
      { } 'select sum(BETRAG) from BUCH where' +
      { } ' (NAME=' + cKonto_Forderungen_AsDBString + ') and' +
      { } ' (VORGANG=' + SQLstring(cVorgang_Rechnung) + ') and' +
      { } ' (BELEG_R=' + inttostr(BELEG_R) + ')')
  else
    result := e_r_sqld(
      { } 'select sum(BETRAG) from ' + TABELLE_AR + ' where' +
      { } ' (VORGANG=' + SQLstring(cVorgang_Rechnung) + ') and' +
      { } ' (BELEG_R=' + inttostr(BELEG_R) + ')')
end;

function e_r_BelegZahlungen(BELEG_R: integer): double;
begin
  if is1400 then
    result := e_r_sqld(
      { } 'select sum(BETRAG) from BUCH where' +
      { } ' (NAME=' + cKonto_Forderungen_AsDBString + ') and' +
      { } ' ((VORGANG<>' + SQLstring(cVorgang_Rechnung) + ') or (VORGANG is null)) and' +
      { } ' (BELEG_R=' + inttostr(BELEG_R) + ')')
  else
    result := e_r_sqld(
      { } 'select sum(BETRAG) from ' + TABELLE_AR + ' where' +
      { } ' ((VORGANG<>' + SQLstring(cVorgang_Rechnung) + ') or (VORGANG is null)) and' +
      { } ' (BELEG_R=' + inttostr(BELEG_R) + ')');
end;

function e_r_BelegTeilzahlungen(BELEG_R: integer): double;
begin
  result := e_r_sqld(
    { } 'select sum(BETRAG) from BUCH where' +
    { } ' (NAME=' + cKonto_Anzahlungen_AsDBString + ') and' +
    { } ' (BELEG_R=' + inttostr(BELEG_R) + ')');
end;

function e_r_BelegeAusgeglichen(BELEG_R: integer): boolean;
var
  SALDO_AUSGANGSRECHNUNGEN, FORDERUNG_VERSAND, FORDERUNG_BELEGE, AUSGLEICH_BELEGE: double;
begin
  result := false;
  repeat
    SALDO_AUSGANGSRECHNUNGEN := e_r_BelegSaldo(BELEG_R);
    FORDERUNG_BELEGE := e_r_sqld('select RECHNUNGS_BETRAG from BELEG where RID=' + inttostr(BELEG_R));
    AUSGLEICH_BELEGE := e_r_sqld('select DAVON_BEZAHLT from BELEG where RID=' + inttostr(BELEG_R));
    FORDERUNG_VERSAND := e_r_sqld('select sum(LIEFERBETRAG) from VERSAND where BELEG_R=' + inttostr(BELEG_R));

    if IsOther(FORDERUNG_VERSAND, FORDERUNG_BELEGE) then
      break;

    if IsOther(SALDO_AUSGANGSRECHNUNGEN, FORDERUNG_BELEGE - AUSGLEICH_BELEGE) then
      break;

    result := isZeroMoney(SALDO_AUSGANGSRECHNUNGEN);
  until yet;
end;

function e_r_BelegFName(PERSON_R: integer; BELEG_R: integer; TEILLIEFERUNG: integer = 0;
  AsMask: boolean = false): string;
begin
  if (PERSON_R >= cRID_FirstValid) then
    result :=
    { } cPersonPath(PERSON_R) +
    { } RIDasStr(BELEG_R) + '-' +
    { } inttostrN(TEILLIEFERUNG, 2)
  else
    result :=
    { } MyProgramPath + cRechnungsKopiePath + '\' +
    { } RIDasStr(BELEG_R) + '-' +
    { } inttostrN(TEILLIEFERUNG, 2);

  if AsMask then
    result := result + '*'
  else
    result := result + chtmlextension;
end;

function e_r_BelegFNameCombined(PERSON_R: integer; BELEG_R: integer; TEILLIEFERUNG: integer = 0): string;
begin
  result := e_r_BelegFName(PERSON_R, BELEG_R, TEILLIEFERUNG, true);
  ersetze('*', cCombinedExtension + chtmlextension, result);
end;

function e_r_MahnungFName(PERSON_R: integer): string;
begin
  result :=
  { } cPersonPath(PERSON_R) +
  { } cHTML_MahnungFName;
end;

function e_r_MahnungFNameCombined(PERSON_R: integer): string;
begin
  result :=
  { } cPersonPath(PERSON_R) +
  { } cHTML_MahnungFName;
  ersetze(cHTMLextension, cCombinedExtension + cHTMLextension, result);
end;

function e_r_BelegInfo(BELEG_R: integer; TEILLIEFERUNG: integer = -1): TStringList;
var
  POSTEN: TdboCursor;
  Beleg: TdboCursor;
  WARE: TdboCursor;

  // Beleg-Optionen von denen die Berechnung abhängt
  NurGeliefertes: boolean;
  EinzelpreisNetto: boolean;
  BelegDatum: TAnfixDate;

  // Posten Sachen
  Menge_Rechnung: integer;
  MENGE_RECHNUNG_SUMME: integer;
  MENGE_AUSFALL: integer;
  MENGE_GELIEFERT: integer;
  MENGE_AUFTRAG: integer;
  MENGE_AGENT: integer;
  MENGE_AUFNAHMEN: integer;
  MENGE_ZUTAT: Integer;

  MWST: double;
  Rabatt: double;
  EinzelPreis, PREIS, PreisRabattiert: double;
  AuftragsSumme, LieferSumme, Warenwert, AuftragsWert, Zutaten: double;
  Anzahlung: double;
  gewicht: integer;
  PackformGewicht, LieferGewicht, AuftragsGewicht: integer;
  n: integer;

  // Für AddLine
  MwStSaver: TMwSt;
  SATZn: integer;

  // für Glattstellung
  BruttoKorrektur: double;
  EINHEIT_R: integer;
  // errechnet aus einem Brutto-Wert den ursprünglichen Netto Preis

begin
  NurGeliefertes := false; // nicht als Parameter übergebbar
  result := TStringList.create;
  if (BELEG_R >= cRID_FirstValid) then
  begin

    // Infos vom echten "Beleg" dazuladen
    WARE := nCursor;
    with WARE do
    begin
      sql.add('select count(RID) C_RID from WARENBEWEGUNG where');
      sql.add(' (BELEG_R=' + inttostr(BELEG_R) + ') and');
      sql.add(' ((BEWEGT is null) or (BEWEGT=''' + cC_False + '''))');
      ApiFirst;
      result.add('UNBEWEGT=' + inttostr(FieldByName('C_RID').AsInteger));
    end;
    WARE.free;

    // Infos vom echten "Beleg" dazuladen
    Beleg := nCursor;
    with Beleg do
    begin
      sql.add('SELECT EINZELPREIS_NETTO,RECHNUNGS_BETRAG,DAVON_BEZAHLT FROM BELEG WHERE RID=' + inttostr(BELEG_R));
      ApiFirst;
      EinzelpreisNetto := FieldByName('EINZELPREIS_NETTO').AsString = cC_True;

      if NurGeliefertes then
        Anzahlung := FieldByName('DAVON_BEZAHLT').AsFloat
      else
        Anzahlung := FieldByName('DAVON_BEZAHLT').AsFloat - FieldByName('RECHNUNGS_BETRAG').AsFloat;

      if (Anzahlung < cGeld_KleinsterBetrag) then
        Anzahlung := 0;
    end;
    Beleg.free;

    result.add('EINZELPREISNETTO=' + bool2cC(EinzelpreisNetto));

    //
    MwStSaver := TMwSt.create;
    AuftragsSumme := 0.0;
    LieferSumme := 0.0;
    AuftragsGewicht := 0;
    PackformGewicht := e_r_PackformGewicht(BELEG_R);
    LieferGewicht := PackformGewicht;
    Warenwert := 0.0;
    AuftragsWert := 0.0;
    Zutaten := 0.0;
    MENGE_RECHNUNG_SUMME := 0;
    MENGE_AUFNAHMEN := 0;
    POSTEN := nCursor;
    with POSTEN do
    begin
      sql.add('select EINHEIT_R,MENGE,MENGE_RECHNUNG,MENGE_AUSFALL,ARTIKEL_R,AUSGABEART_R,');
      sql.add('MENGE_GELIEFERT,MENGE_AGENT,MWST,NETTO,RABATT,PREIS,GEWICHT,ZUTAT ');
      if (TEILLIEFERUNG >= 0) then
      begin
        sql.add('from GELIEFERT');
        sql.add('where');
        sql.add(' (BELEG_R=' + inttostr(BELEG_R) + ') and');
        sql.add(' (POSNO=' + inttostr(TEILLIEFERUNG) + ')');
        BelegDatum :=
          e_r_sql_Date(
                  {} 'select AUSGANG from VERSAND where '+
                  {} ' (BELEG_R='+IntToStr(BELEG_R)+') and'+
                  {} ' (TEILLIEFERUNG='+IntToStr(TEILLIEFERUNG)+')');
        if not(DateOK(BelegDatum)) then
         BelegDatum := DateGet;
      end
      else
      begin
        sql.add('from POSTEN');
        sql.add('where');
        sql.add(' (BELEG_R=' + inttostr(BELEG_R) + ')');
        BelegDatum := DateGet;
      end;
      result.Add('BELEGDATUM='+long2Date(BelegDatum));

      ApiFirst;
      while not(eof) do
      begin

        gewicht := FieldByName('GEWICHT').AsInteger;
        EINHEIT_R := FieldByName('EINHEIT_R').AsInteger;

        e_r_PostenInfo(POSTEN, NurGeliefertes, EinzelpreisNetto, Menge_Rechnung, MENGE_AUFTRAG, MENGE_GELIEFERT,
          MENGE_AUSFALL, MENGE_AGENT, Rabatt, EinzelPreis, MWST);

        // RAB!!

        PREIS := e_r_PostenPreis(EinzelPreis, Menge_Rechnung, EINHEIT_R);
        PreisRabattiert := e_c_Rabatt(PREIS, Rabatt);

        MwStSaver.add(MWST, PreisRabattiert);

        // Preis Summen
        if (FieldByName('ZUTAT').AsString <> cC_True) then
        begin
          AuftragsSumme := AuftragsSumme + e_c_Rabatt(e_r_PostenPreis(EinzelPreis, MENGE_AUFTRAG - MENGE_AUSFALL,
            EINHEIT_R), Rabatt);
          AuftragsWert := AuftragsWert + e_r_PostenPreis(EinzelPreis, MENGE_AUFTRAG - MENGE_AUSFALL, EINHEIT_R);
          LieferSumme := LieferSumme + PreisRabattiert;
          Warenwert := Warenwert + e_r_PostenPreis(EinzelPreis, Menge_Rechnung, EINHEIT_R);
        end
        else
        begin
          Zutaten := Zutaten + e_r_PostenPreis(EinzelPreis, MENGE_AUFTRAG - MENGE_AUSFALL, EINHEIT_R);
        end;

        // Gewicht Summen
        inc(LieferGewicht, gewicht * Menge_Rechnung);
        inc(AuftragsGewicht, gewicht * (MENGE_AUFTRAG - MENGE_AUSFALL));

        // Mengen
        MENGE_RECHNUNG_SUMME := MENGE_RECHNUNG_SUMME + Menge_Rechnung;
        if FieldByName('AUSGABEART_R').AsInteger = cAusgabeArt_Aufnahme_MP3 then
          MENGE_AUFNAHMEN := MENGE_AUFNAHMEN + Menge_Rechnung;

        ApiNext;
      end;
    end;
    POSTEN.free;

    result.add('MENGE_RECHNUNG=' + inttostr(MENGE_RECHNUNG_SUMME));
    result.add('MWSTANZ=' + inttostr(MwStSaver.count));

    // Jetzt die Endsummen berechnen
    MwStSaver.calc(EinzelpreisNetto);
    for n := 0 to pred(MwStSaver.count) do
      with MwStSaver.MWST[n] do
      begin
        result.add('MWST' + inttostr(succ(n)) + 'PR=' + format('%.0f', [Satz]));
        if (Summe <> 0) and (Satz > 0) then
        begin
          result.add('MWST' + inttostr(succ(n)) + 'MS=' + format('%.2m', [NettoSumme]));
          result.add('MWST' + inttostr(succ(n)) + 'MW=' + format('%.2m', [MwStSumme]));
          SATZn := e_r_Satz(Satz, BelegDatum);
          if (SATZn > 0) then
          begin
            result.add(format('NETTO%d=%.2m', [SATZn, NettoSumme]));
            result.add(format('SATZ%d=%.0f', [SATZn, Satz]));
            result.add(format('STEUER%d=%.2m', [SATZn, MwStSumme]));
          end;
        end;
      end;

    result.add('NETTO=' + format('%.2f', [MwStSaver.Netto]));

    result.add('SUMME=' + format('%.2f', [MwStSaver.brutto]));
    result.add('LIEFERSUMME=' + format('%.2f', [LieferSumme]));
    result.add('WARENWERT=' + format('%.2f', [Warenwert]));

    result.add('AUFTRAGSSUMME=' + format('%.2f', [AuftragsSumme]));
    result.add('AUFTRAGSWERT=' + format('%.2f', [AuftragsWert]));
    result.add('VOLUMEN=' + format('%.2f', [AuftragsWert]));
    result.add('ZUTATEN=' + format('%.2f', [Zutaten]));

    result.add('AUFTRAGSGEWICHT=' + inttostr(AuftragsGewicht));
    result.add('PACKFORMGEWICHT=' + inttostr(PackformGewicht));
    result.add('LIEFERGEWICHT=' + inttostr(LieferGewicht));

    result.add('AUFNAHMEN=' + inttostr(MENGE_AUFNAHMEN));

    result.add('ANZAHLUNG=' + format('%.2f', [Anzahlung]));
    BruttoKorrektur := cPreisRundung((round(MwStSaver.brutto * 10.0) / 10.0) - MwStSaver.brutto);
    result.add('BRUTTOKORREKTUR=' + format('%.2f', [BruttoKorrektur]));

    if EinzelpreisNetto then
    begin
      // nur hier ist die cent-korrektur möglich!
      for n := 0 to pred(MwStSaver.count) do
        result.add('MWST' + inttostr(succ(n)) + 'KN=' + format('%.2f',
          [cNetto(MwStSaver.MWST[n].Satz, BruttoKorrektur)]));
    end
    else
    begin
      // noch keine Idee hier, es reicht eigentlich einen B-Einzelpreis
      // mit Hilfe des "BRUTTOKORREKTUR" zu verändern.
    end;
    MwStSaver.free;

  end;
  if DebugMode then
    result.savetoFile(DiagnosePath + 'Beleg-' + inttostr(BELEG_R) + '.txt');
end;

procedure e_w_preDeletePosten(POSTEN_R: integer);
begin
  e_w_dereference(POSTEN_R, 'BPOSTEN', 'POSTEN_R');
  e_w_dereference(POSTEN_R, 'WARENBEWEGUNG', 'POSTEN_R');
  e_w_dereference(POSTEN_R, 'EREIGNIS', 'POSTEN_R');
  e_w_dereference(POSTEN_R, 'SCHRITTE', 'POSTEN_R');
end;

procedure e_w_preDeleteTier(TIER_R: integer);
begin
  e_w_dereference(TIER_R, 'POSTEN', 'TIER_R');
  e_w_dereference(TIER_R, 'POSTEN', 'TIER_R');
end;

procedure e_w_preDeleteVerlag(VERLAG_R: integer);
begin
  e_w_dereference(VERLAG_R, 'LAGER', 'VERLAG_R');
  e_w_dereference(VERLAG_R, 'PREIS', 'VERLAG_R');
end;

procedure e_w_preDeleteBPosten(BPOSTEN_R: integer);
begin
  e_w_dereference(BPOSTEN_R, 'EREIGNIS', 'BPOSTEN_R');
  e_w_dereference(BPOSTEN_R, 'WARENBEWEGUNG', 'BPOSTEN_R');
end;

procedure e_w_preDeleteLAGER(LAGER_R: integer);
begin
  e_w_dereference(LAGER_R, 'ARTIKEL', 'LAGER_ALTERNATIV_R');
  e_w_dereference(LAGER_R, 'ARTIKEL', 'LAGER_R');
  e_w_dereference(LAGER_R, 'ARTIKEL_AA', 'LAGER_ALTERNATIV_R');
  e_w_dereference(LAGER_R, 'ARTIKEL_AA', 'LAGER_R');
  e_w_dereference(LAGER_R, 'BBELEG', 'LAGER_R');
  e_w_dereference(LAGER_R, 'BELEG', 'LAGER_R');
  e_w_dereference(LAGER_R, 'EREIGNIS', 'LAGER_R');
  e_w_dereference(LAGER_R, 'WARENBEWEGUNG', 'LAGER_R');
end;

procedure e_w_preDeleteBeleg(BELEG_R: integer);
var
  PDeleteList: TgpIntegerList;
  POSTEN: TdboCursor;
  n: integer;
  POSTEN_R: Integer;
  PERSON_R: Integer;
begin

  // Person sichern, dort ist der Beleg gespeichert
  PERSON_R := e_r_sql('select PERSON_R from BELEG where RID=' +  inttostr(BELEG_R));

  // Posten Referenzen auflösen
  PDeleteList := e_r_sqlm('select RID from POSTEN where BELEG_R=' + inttostr(BELEG_R));
  for n := 0 to pred(PDeleteList.count) do
    e_w_preDeletePosten(PDeleteList[n]);
  PDeleteList.free;

  // löschen
  e_x_sql('delete from POSTEN where BELEG_R=' + inttostr(BELEG_R));
  e_x_sql('delete from GELIEFERT where BELEG_R=' + inttostr(BELEG_R));
  e_x_sql('delete from AUSGANGSRECHNUNG where BELEG_R=' + inttostr(BELEG_R));
  e_x_sql('delete from ARBEITSZEIT where BELEG_R=' + inttostr(BELEG_R));

  // Referenzen auflösen
  e_w_dereference(BELEG_R, 'BUCH', 'BELEG_R');
  e_w_dereference(BELEG_R, 'DOKUMENT', 'BELEG_R');
  e_w_dereference(BELEG_R, 'EREIGNIS', 'BELEG_R');
  e_w_dereference(BELEG_R, 'TICKET', 'BELEG_R');
  e_w_dereference(BELEG_R, 'VERSAND', 'BELEG_R');
  e_w_dereference(BELEG_R, 'WARENBEWEGUNG', 'BELEG_R');
  e_w_dereference(BELEG_R, 'AUFTRAG', 'BELEG_R');
  e_w_dereference(BELEG_R, 'ABLAGE', 'BELEG_R');
  e_w_dereference(BELEG_R, 'PAKET', 'BELEG_R');

  // Dokumente ablegen
  FileMove(
   cPersonPath(PERSON_R) +
   RIDasStr(BELEG_R) + '-*', DiagnosePath);

end;

procedure e_w_preDeleteBBeleg(BBELEG_R: integer);
var
  PDeleteList: TStringList;
  POSTEN: TdboCursor;
  n: integer;
  POSTEN_R: integer;
begin

  // Posten ermitteln
  PDeleteList := TStringList.create;
  POSTEN := nCursor;
  with POSTEN do
  begin
    sql.add('SELECT RID FROM BPOSTEN where BELEG_R=' + inttostr(BBELEG_R));
    ApiFirst;
    while not(eof) do
    begin
      PDeleteList.add(FieldByName('RID').AsString);
      ApiNext;
    end;
  end;
  POSTEN.free;

  // Posten Referenzen auflösen
  for n := 0 to pred(PDeleteList.count) do
  begin
    POSTEN_R := StrtoInt(PDeleteList[n]);
    e_w_preDeleteBPosten(POSTEN_R);
  end;
  PDeleteList.free;

  // Posten löschen
  e_x_sql('DELETE FROM BPOSTEN WHERE BELEG_R=' + inttostr(BBELEG_R));

  // BBeleg Referenzen auflösen
  e_w_dereference(BBELEG_R, 'WARENBEWEGUNG', 'BBELEG_R');
  e_w_dereference(BBELEG_R, 'EREIGNIS', 'BBELEG_R');
end;

procedure e_w_preDeleteEinheit(EINHEIT_R: integer; References: TStrings = nil);
begin
  e_w_dereference(EINHEIT_R,'ARTIKEL', 'EINHEIT_R',false,References);
  e_w_dereference(EINHEIT_R,'ARTIKEL_AA', 'EINHEIT_R',false,References);
  e_w_dereference(EINHEIT_R,'BPOSTEN', 'EINHEIT_R',false,References);
  e_w_dereference(EINHEIT_R,'GELIEFERT', 'EINHEIT_R',false,References);
  e_w_dereference(EINHEIT_R,'POSTEN', 'EINHEIT_R',false,References);
  e_w_dereference(EINHEIT_R,'WARENBEWEGUNG', 'EINHEIT_R',false,References);
end;

procedure e_w_preDeleteArtikel(ARTIKEL_R: integer);
begin
  e_w_dereference(ARTIKEL_R, 'ARTIKEL', 'PAKET_R');
  e_w_dereference(ARTIKEL_R, 'ABLAGE', 'ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'AUFTRAG', 'ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'AKTION', 'ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'BUGET', 'ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'BPOSTEN', 'ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'BREGEL', 'IN_ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'EREIGNIS', 'ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'POSTEN', 'ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'GELIEFERT', 'ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'PRORATA', 'ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'RABATT', 'ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'SOUND', 'ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'VREGEL', 'OUT_ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'WARENKORB', 'ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'WEBPROFIL', 'ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'ARTIKEL_GATTUNG', 'ARTIKEL_R', true);
  e_w_dereference(ARTIKEL_R, 'ARTIKEL_AA', 'ARTIKEL_R', true);
  e_w_dereference(ARTIKEL_R, 'ARTIKEL_MITGLIED', 'ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'ARTIKEL_MITGLIED', 'MASTER_R');
  e_w_dereference(ARTIKEL_R, 'DOKUMENT', 'ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'WARENBEWEGUNG', 'ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'EMAIL', 'ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'TICKET', 'ARTIKEL_R');
  e_w_dereference(ARTIKEL_R, 'AUSGABEART', 'ARTIKEL_R');
end;

function e_w_VersandKostenClear(BELEG_R: integer): integer;
var
  cBELEG: TdboCursor;
  cPOSTEN: TdboCursor;
  lPOSTEN: TList;
  n: integer;
  StopIt: boolean;
begin

  result := 0;

  // Daten aus dem Beleg-Kopf lesen
  cBELEG := nCursor;
  with cBELEG do
  begin
    sql.add('select BTYP from BELEG where RID=' + inttostr(BELEG_R));
    ApiFirst;
    StopIt := eof or (FieldByName('BTYP').AsString = 'p');
  end;
  cBELEG.free;

  if not(StopIt) then
  begin

    // Liste der Positionen ermitteln
    lPOSTEN := TList.create;
    cPOSTEN := nCursor;
    with cPOSTEN do
    begin
      sql.add('select rid from POSTEN where');
      sql.add(' (BELEG_R=' + inttostr(BELEG_R) + ') AND');
      sql.add(' (MENGE_GELIEFERT IS NULL) AND');
      sql.add(' (ARTIKEL_R IN');
      sql.add('     (select OUT_ARTIKEL_R from VREGEL) )');
      ApiFirst;
      while not(eof) do
      begin
        lPOSTEN.add(TObject(FieldByName('RID').AsInteger));
        ApiNext;
      end;
    end;
    cPOSTEN.free;

    // entsprechende Posten löschen
    if (lPOSTEN.count > 0) then
    begin
      for n := 0 to pred(lPOSTEN.count) do
      begin
        e_w_preDeletePosten(integer(lPOSTEN[n]));
        e_x_sql('delete from posten where rid=' + inttostr(integer(lPOSTEN[n])));
      end;
    end;

    lPOSTEN.free;
  end;
end;

const
  _VertragBuchen_NestingLevel: integer = 0;
  _VertragBuchen_EREIGNIS_R: integer = cRID_unset;

procedure VertragBuchen_Enter;
begin
  inc(_VertragBuchen_NestingLevel);
end;

procedure VertragBuchen_Leave;
begin
  dec(_VertragBuchen_NestingLevel);
  if (_VertragBuchen_NestingLevel = 0) then
    _VertragBuchen_EREIGNIS_R := cRID_unset;
end;

function VertragBuchen_EREIGNIS_R: integer;
var
  qEREIGNIS: TdboQuery;
begin
  if (_VertragBuchen_NestingLevel > 0) then
  begin

    if (_VertragBuchen_EREIGNIS_R < cRID_FirstValid) then
    begin
      // Ereignis erzeugen
      _VertragBuchen_EREIGNIS_R := e_w_GEN('EREIGNIS_GID');
      qEREIGNIS := nQuery;
      with qEREIGNIS do
      begin
        sql.add('select * from EREIGNIS');
{$IFNDEF fpc}
        ColumnAttributes.add('AUFTRITT=NOTREQUIRED');
{$ENDIF}
        Insert;
        FieldByName('RID').AsInteger := _VertragBuchen_EREIGNIS_R;
        FieldByName('ART').AsInteger := eT_VertragsAnwendung;
        FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
        Post;
      end;
      qEREIGNIS.free;
    end;
    result := _VertragBuchen_EREIGNIS_R;
  end
  else
  begin
    result := cRID_unset;
  end;
end;

function e_w_VertragBuchen(VERTRAG_R: integer; sSettings: TStringList): TStringList; overload;
var
  cVERTRAG: TdboCursor;
  GEBUCHT_BIS: TAnfixDate;
  ERSTER_ABRECHNUNGSTAG: TAnfixDate;
  LETZTER_ABRECHNUNGSTAG: TAnfixDate;
  DIESER_ABRECHNUNGSTAG: TAnfixDate;
  ANWENDUNG: TAnfixDate;
  STICHTAG: TAnfixDate;
  VON: TAnfixDate;
  BIS: TAnfixDate;
  BELEG_R: integer;
  VORSPANN_R: integer;
  WIEDERHOLUNGEN: integer;
  PERSON_R: integer;
  PERSON_RECHNUNG_R: integer;
  ZIEL_BELEG_R: integer;
  EINSTELLUNGEN: TStringList;
  KONTEXT: string;
  KONTEXT_SQL: string;
  PAPERCOLOR : Integer;

  VertragsTexte: TStringList;
  Erzwingen: boolean;
  Simulieren: boolean;
  n: integer;
const
  BAUSTELLE_R: integer = cRID_Null;

  function VertragAnwendbar(dlong: TAnfixDate): boolean;
  begin
    result := (dlong >= VON) and (dlong <= BIS);
  end;

begin
  VertragBuchen_Enter;
  // Vertrag verbuchen ....
  result := TStringList.create;
  EINSTELLUNGEN := TStringList.create;
  try
    // Vorlauf
    with sSettings do
    begin
     Erzwingen := (values['Erzwingen'] = cIni_Activate);
     Simulieren := (values['Simulieren'] = cIni_Activate);
    end;

    while (e_r_VertragBuchen(VERTRAG_R, ANWENDUNG)) or Erzwingen do
    begin

      VertragsTexte := TStringList.create;
      cVERTRAG := nCursor;
      repeat

        with cVERTRAG do
        begin
          sql.add('select * from VERTRAG where RID=' + inttostr(VERTRAG_R));
          ApiFirst;
          if eof then
          begin
            result.add('ERROR: Vertrag nicht gefunden!');
            break;
          end;
          VertragsTexte.add('VertragsReferenz=' + inttostr(VERTRAG_R));
          e_r_sqlt(FieldByName('EINSTELLUNGEN'), EINSTELLUNGEN);

          if FieldByName('VON').IsNull then
          begin
            result.add('WARNING: Vertrag VON ist null!');
            break;
          end;
          VON := DateTime2Long(FieldByName('VON').AsDateTime);

          if FieldByName('BELEG_R').IsNull then
          begin
            result.add('ERROR: BELEG_R ist null!');
            break;
          end;

          if FieldByName('PERSON_R').IsNull then
          begin
            result.add('ERROR: PERSON_R ist null!');
            break;
          end;

          if FieldByName('BAUSTELLE_R').IsNull then
          begin
            result.add('WARNING: BAUSTELLE_R ist null!');
          end
          else
          begin
            BAUSTELLE_R := FieldByName('BAUSTELLE_R').AsInteger;
            VertragsTexte.add('Objekt=' + e_r_sqls('select NAME from BAUSTELLE where RID=' + inttostr(BAUSTELLE_R)));
          end;

          if FieldByName('VORGABEN_R').IsNull then
            VORSPANN_R := cRID_Null
          else
            VORSPANN_R := FieldByName('VORGABEN_R').AsInteger;

          if FieldByName('BIS').IsNull then
            BIS := cMaxDate
          else
            BIS := DateTime2Long(FieldByName('BIS').AsDateTime);

          if FieldByName('STICHTAG').IsNull then
            STICHTAG := VON
          else
            STICHTAG := DateTime2Long(FieldByName('STICHTAG').AsDateTime);

          if FieldByName('GEBUCHT_BIS').IsNull then
            GEBUCHT_BIS := DatePlus(STICHTAG, -1)
          else
            GEBUCHT_BIS := DateTime2Long(FieldByName('GEBUCHT_BIS').AsDateTime);

          // Stichtage, die vor einer erfolgten Buchung liegen
          // werden storniert
          if (GEBUCHT_BIS > STICHTAG) then
            STICHTAG := DatePlus(GEBUCHT_BIS, 1);

          WIEDERHOLUNGEN := max(FieldByName('WIEDERHOLUNGEN').AsInteger, 1);

          // Erster Abrechnungstag bestimmen
          repeat

            ERSTER_ABRECHNUNGSTAG := date2Long(sSettings.values['Per']);
            if DateOK(ERSTER_ABRECHNUNGSTAG) then
            begin
              // Ausnahme - bei "Per" den Geltungsbereich anpassen!
              VON := ERSTER_ABRECHNUNGSTAG;
              BIS := cMaxDate;
              break;
            end;

            if (WIEDERHOLUNGEN > 1) and (STICHTAG < GEBUCHT_BIS) then
            begin
              // Für den Fall, dass der Abrechnungswunsch VOR dem
              // Vertragsbeginn stehen wird die Berechnung vorgezogen!
              ERSTER_ABRECHNUNGSTAG := STICHTAG;
              break;
            end;

            // Für den Fall einer nahtlosen Weiterberechnen oder
            // der termingerechten Einsatzes des
            ERSTER_ABRECHNUNGSTAG := DatePlus(GEBUCHT_BIS, 1);

          until yet;

          // weitere Daten bestimmen!
          PERSON_R := FieldByName('PERSON_R').AsInteger;
          BELEG_R := FieldByName('BELEG_R').AsInteger;
          PAPERCOLOR := e_r_sql(
              { } 'select PAPERCOLOR from BELEG where RID=' + inttostr(BELEG_R));
          PERSON_RECHNUNG_R := StrToIntDef(EINSTELLUNGEN.values['Rechnungsempfänger'], cRID_unset);
          if (PERSON_RECHNUNG_R < cRID_FirstValid) then
            PERSON_RECHNUNG_R := e_r_sql(
              { } 'select RECHNUNGSANSCHRIFT_R from BELEG where RID=' + inttostr(BELEG_R));

          // Vertragsanwendungsbeginn und VertragsanwendungsEnde bestimmen
          VertragsTexte.values['Beginn'] := long2date(ERSTER_ABRECHNUNGSTAG);
          VertragsTexte.values['BeginnJahr'] := inttostr(extractYear(ERSTER_ABRECHNUNGSTAG));
          VertragsTexte.values['BeginnMonat'] := inttostrN(extractMonth(ERSTER_ABRECHNUNGSTAG), 2);
          DIESER_ABRECHNUNGSTAG := ERSTER_ABRECHNUNGSTAG;
          for n := 1 to WIEDERHOLUNGEN do
            DIESER_ABRECHNUNGSTAG := DatePlus(MonthPeriod(DIESER_ABRECHNUNGSTAG, VON), 1);
          LETZTER_ABRECHNUNGSTAG := DatePlus(DIESER_ABRECHNUNGSTAG, -1);
          VertragsTexte.values['Ende'] := long2date(LETZTER_ABRECHNUNGSTAG);
          VertragsTexte.values['EndeJahr'] := inttostr(extractYear(LETZTER_ABRECHNUNGSTAG));
          VertragsTexte.values['EndeMonat'] := inttostrN(extractMonth(LETZTER_ABRECHNUNGSTAG), 2);

          // weitere Globale Infos schreiben!
          VertragsTexte.values['VorspannBeleg'] := inttostr(VORSPANN_R);
          VertragsTexte.values['VertragsBeleg'] := inttostr(BELEG_R);

          // Anschrift und Adress-Infos
          VertragsTexte.values['Vertragsnehmer.Person'] := e_r_Person(PERSON_R);
          e_r_Anschrift(PERSON_R, VertragsTexte, 'Vertragsnehmer.');

          // Logik für die Kontext / Kostenstelle
          KONTEXT := EINSTELLUNGEN.values['Kontext'];
          if (KONTEXT = '') then
          begin
            KONTEXT_SQL := '(INTERN_INFO is NULL) or (INTERN_INFO not containing ''Kontext='')';
          end
          else
          begin
            KONTEXT_SQL := 'INTERN_INFO containing ''Kontext=' + KONTEXT + '''';
            VertragsTexte.values['Kontext'] := KONTEXT;
          end;

          if (PERSON_RECHNUNG_R >= cRID_FirstValid) then
          begin
            PERSON_R := PERSON_RECHNUNG_R;
            // suche einen bereits angefangen Beleg und erweitere den
            ZIEL_BELEG_R := e_r_sql(
              { } 'select max(RID) from BELEG where' +
              { } ' (PERSON_R=' + inttostr(PERSON_R) + ') and' +
              { } ' (RECHNUNG is null) and ' +
              { } ' (BSTATUS =''*'') and ' +
              { } ' (' + KONTEXT_SQL + ') and ' +
              { } ' (BTYP <> ''0'') and ' +
              { } ' (PAPERCOLOR = '+inttostr(PAPERCOLOR)+')');
          end
          else
          begin
            ZIEL_BELEG_R := cRID_Null;
          end;
          DIESER_ABRECHNUNGSTAG := ERSTER_ABRECHNUNGSTAG;
          for n := 1 to WIEDERHOLUNGEN do
          begin

            VertragsTexte.values['von'] := long2date(DIESER_ABRECHNUNGSTAG);
            VertragsTexte.values['bis'] := long2date(MonthPeriod(DIESER_ABRECHNUNGSTAG, VON));
            VertragsTexte.values['Monat'] := cMonatNamenLang[extractMonth(DIESER_ABRECHNUNGSTAG)] + ' ' +
              inttostr(extractYear(DIESER_ABRECHNUNGSTAG));

            if VertragAnwendbar(DIESER_ABRECHNUNGSTAG) then
            begin
              if assigned(cnPERSON) then
                cnPERSON.addContext(PERSON_R);
              result.add('PERSON_R=' + inttostr(PERSON_R));

              if not(Simulieren) then
              begin
                // ev. Vorspann noch kopieren
                if (ZIEL_BELEG_R < cRID_FirstValid) and (VORSPANN_R >= cRID_FirstValid) then
                begin
                  ZIEL_BELEG_R := e_w_CopyBeleg(
                    { } VORSPANN_R,
                    { } PERSON_R,
                    { } VertragsTexte);
                  result.add('BELEG_R=' + inttostr(ZIEL_BELEG_R));
                end;

                // nun den Einzelbeleg Kopieren oder Mergen ...
                if (ZIEL_BELEG_R < cRID_FirstValid) then
                begin
                  ZIEL_BELEG_R := e_w_CopyBeleg(
                    { } BELEG_R,
                    { } PERSON_R,
                    { } VertragsTexte);
                  result.add('BELEG_R=' + inttostr(ZIEL_BELEG_R));
                end
                else
                begin
                  e_w_MergeBeleg(
                    { } BELEG_R,
                    { } ZIEL_BELEG_R,
                    { } VertragsTexte);
                end;
                if assigned(cnBELEG) then
                  cnBeleg.addContext(ZIEL_BELEG_R);
              end else
              begin
                result.AddStrings(VertragsTexte);
              end;

            end;

            DIESER_ABRECHNUNGSTAG := DatePlus(MonthPeriod(DIESER_ABRECHNUNGSTAG, VON), 1);
          end;

          // Ist ein Beleg entstanden, und soll gleich verbucht werden?
          if (EINSTELLUNGEN.values['Verbuchen'] <> cIni_DeActivate) and not(Simulieren) then
            if (ZIEL_BELEG_R >= cRID_FirstValid) then
            begin
              if (e_w_BelegBuchen(ZIEL_BELEG_R)='') then
                result.add('ERROR: Fehler beim Belegbuchen');
              result.add('Verbucht.BELEG_R=' + inttostr(ZIEL_BELEG_R));
            end;

          // Letzter Abrechnungstag verbuchen!
          LETZTER_ABRECHNUNGSTAG := DatePlus(DIESER_ABRECHNUNGSTAG, -1);
          if not(Simulieren) then
            e_x_sql(
              { } 'update VERTRAG set GEBUCHT_BIS=''' + long2date(LETZTER_ABRECHNUNGSTAG) + ''' ' +
              { } 'where' +
              { } ' (RID=' + inttostr(VERTRAG_R) + ') and' +
              { } ' ((GEBUCHT_BIS is null) or' +
              { } '  (GEBUCHT_BIS<''' + long2date(LETZTER_ABRECHNUNGSTAG) + '''))');
          result.add('GEBUCHT_BIS=' + long2date(LETZTER_ABRECHNUNGSTAG));

        end;
      until yet;
      cVERTRAG.free;
      VertragsTexte.free;
      if Erzwingen then
       break;
    end;
  except
    on E: exception do
    begin
      AppendStringsToFile('e_w_VertragBuchen(' + inttostr(VERTRAG_R) + '): ' + E.Message,
        ErrorFName('BELEG'),
        Uhr12);
    end;
  end;
  VertragBuchen_Leave;
end;

function e_w_VertragBuchen(VERTRAG_R: integer; Erzwingen: boolean = false): TStringList; overload;
var
  sSettings: TStringList;
begin
  VertragBuchen_Enter;
  sSettings := TStringList.create;
  sSettings.add('Erzwingen=' + bool2cO(Erzwingen));
  result := e_w_VertragBuchen(VERTRAG_R, sSettings);
  sSettings.free;
  VertragBuchen_Leave;
end;

function e_r_VertragBuchen(VERTRAG_R: integer; var ANWENDUNG: TAnfixDate): boolean;
var
  cVERTRAG: TdboCursor;
  GEBUCHT_BIS: TAnfixDate;
  ERSTER_ABRECHNUNGSTAG: TAnfixDate;
  STICHTAG: TAnfixDate;
  VORLAUF: integer;
  VON: TAnfixDate;
  BIS: TAnfixDate;
  WIEDERHOLUNGEN: integer;

  function VertragAnwendbar(dlong: TAnfixDate): boolean;
  begin
    result := (dlong >= VON) and (dlong <= BIS);
  end;

begin
  VertragBuchen_Enter;

  // Vertrag prüfen, ob man ihn anwenden könnte ....
  ANWENDUNG := cIllegalDate;
  result := false;
  cVERTRAG := nCursor;

  repeat

    with cVERTRAG do
    begin

      sql.add('select * from VERTRAG where RID=' + inttostr(VERTRAG_R));
      ApiFirst;
      if eof then
      begin
        // result.add('ERROR: Vertrag nicht gefunden!');
        break;
      end;

      if FieldByName('BELEG_R').IsNull then
      begin
        // result.add('ERROR: BELEG_R ist null!');
        break;
      end;

      if FieldByName('PERSON_R').IsNull then
      begin
        // result.add('ERROR: PERSON_R ist null!');
        break;
      end;

      if FieldByName('VON').IsNull then
      begin
        // result.add('WARNING: Vertrag VON ist null!');
        break;
      end;
      VON := DateTime2Long(FieldByName('VON').AsDateTime);

      if FieldByName('BIS').IsNull then
        BIS := cMaxDate
      else
        BIS := DateTime2Long(FieldByName('BIS').AsDateTime);

      if FieldByName('STICHTAG').IsNull then
        STICHTAG := VON
      else
        STICHTAG := DateTime2Long(FieldByName('STICHTAG').AsDateTime);

      if FieldByName('GEBUCHT_BIS').IsNull then
        GEBUCHT_BIS := DatePlus(STICHTAG, -1)
      else
        GEBUCHT_BIS := DateTime2Long(FieldByName('GEBUCHT_BIS').AsDateTime);

      // Stichtage, die vor einer erfolgten Buchung liegen
      // werden storniert
      if (GEBUCHT_BIS > STICHTAG) then
        STICHTAG := DatePlus(GEBUCHT_BIS, 1);

      WIEDERHOLUNGEN := max(FieldByName('WIEDERHOLUNGEN').AsInteger, 1);
      if (WIEDERHOLUNGEN > 1) and (STICHTAG < GEBUCHT_BIS) then
      begin
        // Für den Fall, dass der Abrechnungswunsch VOR dem
        // Vertragsbeginn stehen wird die Berechnung vorgezogen!
        ERSTER_ABRECHNUNGSTAG := STICHTAG;
      end
      else
      begin
        // Für den Fall einer nahtlosen Weiterberechnen oder
        // der termingerechten Einsatzes des
        ERSTER_ABRECHNUNGSTAG := DatePlus(GEBUCHT_BIS, 1);
      end;

      VORLAUF := FieldByName('VORLAUF').AsInteger;
      ANWENDUNG := DatePlus(ERSTER_ABRECHNUNGSTAG, -VORLAUF);
      result := (DateGet >= ANWENDUNG);

      // Sollte er anwendbar sein, könnte "Ruhend" die Anwendung verhindern
      // Es gibt aber eine Warnung.
      if result and (FieldByName('RUHEND').AsString = cC_True) then
      begin
        // result.add('WARNING: Vertragsanwendung ist ruhend!');
        result := false;
        break;
      end;

    end;
  until yet;
  cVERTRAG.free;
  VertragBuchen_Leave;
end;

function e_w_VertragBuchen(const lVertraege: TgpIntegerList): TStringList; overload;
var
  n: integer;
  sErgebnis: TStringList;
  VERTRAG_R: integer;
begin
  VertragBuchen_Enter;
  result := TStringList.create;
  for n := 0 to pred(lVertraege.count) do
  begin
    VERTRAG_R := lVertraege[n];
    sErgebnis := e_w_VertragBuchen(VERTRAG_R);
    if (sErgebnis.count > 0) then
    begin
      result.add('[' + inttostr(VERTRAG_R) + ']');
      result.addstrings(sErgebnis);
    end;
    sErgebnis.free;
  end;
  VertragBuchen_Leave;
end;

function e_w_VertragBuchen: TStringList; overload;
var
  lVertraege: TgpIntegerList;
begin
  VertragBuchen_Enter;
  lVertraege := e_r_sqlm('select RID from VERTRAG order by PERSON_R, RID');
  result := e_w_VertragBuchen(lVertraege);
  lVertraege.free;
  VertragBuchen_Leave;
end;

function e_r_Vertrag_NaechsteAnwendung(VERTRAG_R:Integer) : string;
var
 Settings : TStringList;
 Diagnose : TStringList;
begin
 Settings := TStringList.create;
 with Settings do
 begin
  if DebugMode then
    add('VERTRAG_R='+IntToStr(VERTRAG_R));
  add('Erzwingen=' + cIni_Activate);
  add('Simulieren=' + cIni_Activate);
 end;
 if DebugMode then
  AppendStringsToFile(Settings,ErrorFName('VERTRAG'));
 Diagnose := e_w_VertragBuchen(VERTRAG_R, Settings);
 if DebugMode then
 begin
   Diagnose.Add(fill('-',80));
   AppendStringsToFile(Diagnose,ErrorFName('VERTRAG'));
 end;
 Settings.Free;
 result := Diagnose.Values['Monat'];
 Diagnose.Free;
end;

function e_r_IsVersandKosten(ARTIKEL_R: integer): boolean;
var
  cVREGEL: TdboCursor;
begin
  cVREGEL := nCursor;
  with cVREGEL do
  begin
    sql.add('select RID from VREGEL where OUT_ARTIKEL_R=' + inttostr(ARTIKEL_R));
    ApiFirst;
    result := not(eof);
  end;
  cVREGEL.free;
end;


function e_r_KontoInhaber(PERSON_R: integer): string;
var
  cPERSON: TdboCursor;
begin
  result := '';
  cPERSON := nCursor;
  with cPERSON do
  begin
    sql.add(
     {} 'select VORNAME,NACHNAME,Z_ELV_KONTO_INHABER from PERSON where' +
     {} ' (RID=' + inttostr(PERSON_R) + ')');
    ApiFirst;
    repeat

      // Vorrang hat der Konto-Inhaber
      result := cutblank(FieldByName('Z_ELV_KONTO_INHABER').AsString);
      if (result <> '') then
        break;

      // Danach Vorname und Nachname
      result := cutblank(FieldByName('VORNAME').AsString + ' ' + FieldByName('NACHNAME').AsString);

    until yet;
  end;
  cPERSON.free;
end;

function e_r_VornameNachname(PERSON_R: integer): string;
var
  cPERSON: TdboCursor;
  cANSCHRIFT: TdboCursor;
begin
  result := '';
  cPERSON := nCursor;
  cANSCHRIFT := nCursor;
  with cPERSON do
  begin
    sql.add(
     {} 'select VORNAME,NACHNAME,PRIV_ANSCHRIFT_R from PERSON where' +
     {} ' (RID=' + inttostr(PERSON_R) + ')');
    ApiFirst;

    // Danach Vorname und Nachname
    result := cutblank(FieldByName('VORNAME').AsString + ' ' + FieldByName('NACHNAME').AsString);

  end;

  if (result = '') then
  begin
    with cANSCHRIFT do
    begin
      sql.add(
       {} 'select NAME1,NAME2 from ANSCHRIFT where'+
       {} ' (RID=' + cPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsString + ')');
      ApiFirst;
      result := cutblank(FieldByName('NAME1').AsString);
      if (result = '') then
        result := cutblank(FieldByName('NAME2').AsString);
    end;
  end;

  cPERSON.free;
  cANSCHRIFT.free;
end;

function e_w_BerechneBeleg(BELEG_R: integer; NurGeliefertes: boolean = false): TStringList;
var
  n: integer;
  _PreisProPosition: double;

  _MaxNettoWert: double;
  _NettoInDieserMwStKlasse: double;
  _groesstesMwStElementIndex: integer;
  _ArtikelMemo: TStringList;

  MwStSaver: TMwSt;

  // Mengen Logik
  _NeuBeauftragt: integer;
  _VerfuegbareMenge: integer;
  _VorgeschlageneMenge: integer;
  _MengeLager: integer;
  _MengeLagerNeu: integer;

  // Agent Menge
  _AgentImPosten: integer;
  _AgentImPostenNeu: integer;
  _AgentDiff: integer;

  // Rechnungs Menge
  _RechnungImPosten: integer;
  _RechnungImPostenNeu: integer;
  _RechnungDiff: integer;

  ZUSAMMENHANG: boolean;
  INTERN_INFO: TStringList;
  GENERATION_POSTFIX: string;

  LieferGewicht: integer;
  EinzelpreisNetto: boolean;
  TEILLIEFERUNG: integer;
  PERSON_R: integer;
  isHaendler: boolean;
  MENGE_BUDGET: integer;

  // ZUSAGE Geschichten
  ZUSAGE: TAnfixDate;
  IB_Query7: boolean;

  // Glattstellungs-Geschichten
  GlattstellungSatz: double; // bei welchem MwSt-Satz muss glattgestellt werden?
  Glattstellung: double; // um wieviele cent muss glattgestellt werden?
  eResult: TStringList;

  // POSTEN Caching
  ARTIKEL_R: integer;
  EINHEIT_R: integer;
  BUDGET_R: integer;

  // Die eigentlichen Queries, die geändert werden
  qBELEG: TdboQuery;
  qPosten: TdboQuery;

  // Ticket Erstellung zur Qualtitäts-Sicherung
  qTICKET: TdboQuery;
  TICKET_R: TDOM_Reference;

  _Anz, _AnzAuftrag, _AnzGeliefert, _AnzStorniert, _AnzNachlieferung: integer;
  _Rabatt, _EinzelPreis, _MwStSatz: double;

begin
  result := TStringList.create;
  if (BELEG_R >= cRID_FirstValid) then
  begin
    INTERN_INFO := TStringList.create;
    qBELEG := nQuery;
    qPosten := nQuery;
    MwStSaver := TMwSt.create;
    MENGE_BUDGET := 0;
    try
      ZUSAMMENHANG := false;

      // alten Versandartikel rauswerfen
      if not(NurGeliefertes) then
        e_w_VersandKostenClear(BELEG_R);

      with qBELEG do
      begin
        sql.add('select '+
        {} 'RID,PERSON_R,LIEFERANSCHRIFT_R,ANLAGE,'+
        {} 'ABSCHLUSS,BTYP,BSTATUS,RECHNUNG,FAELLIG,MAHNUNG1,'+
        {} 'MAHNUNG2,MAHNBESCHEID,RECHNUNGS_BETRAG,DAVON_BEZAHLT,'+
        {} 'KUNDEN_INFO,VERSAND_STATUS,MENGE_RECHNUNG,MENGE_AUFTRAG,'+
        {} 'MENGE_GELIEFERT,RECHNUNGSANSCHRIFT_R,TEILLIEFERUNG,'+
        {} 'LAGER_R,MENGE_AGENT,GENERATION,DRUCK,INFO_AUFTRAGGEBER,'+
        {} 'INFO_RECHNUNGSANSCHRIFT,INFO_LIEFERANSCHRIFT,MEDIUM,'+
        {} 'MOTIVATION,ZUSAGE,FAKTOR,EINZELPREIS_NETTO,MAHNUNG3,'+
        {} 'MAHNSTUFE,INTERN_INFO,VORAB_INFO,VOLUMEN,MAHNUNG,'+
        {} 'MAHNUNG_AUSGESETZT,BEARBEITER_R,ANLEGER_R,TEILUNG,'+
        {} 'TERMIN,BAUSTELLE_R,NUMMER,VORLAGE_PREFIX,PAPERCOLOR,'+
        {} 'ZUTATEN,ZAHLUNGSPFLICHTIGER_R,ZAHLUNGTYP_R,KUNDEN_AUFTRAG '+
        {} 'from BELEG where RID=' + inttostr(BELEG_R));
        for_update(sql);
        Open;
        First;
        if eof then
          raise exception.create('Beleg nicht gefunden');

        // Laden der Parameter
        EinzelpreisNetto := (FieldByName('EINZELPREIS_NETTO').AsString = cC_True);
        TEILLIEFERUNG := FieldByName('TEILLIEFERUNG').AsInteger;
        PERSON_R := FieldByName('PERSON_R').AsInteger;
        GENERATION_POSTFIX := '-' + inttostrN(FieldByName('GENERATION').AsInteger, 2);
        e_r_sqlt(FieldByName('INTERN_INFO'), INTERN_INFO);
        isHaendler := e_r_RabattFaehig(PERSON_R);
      end;

      // Basic-Programm ausführen
      e_x_basic(
        { } MyProgramPath + cDBASICPath + 'BerechneBeleg-1.txt',
        { } 'PERSON_R=' + inttostr(PERSON_R) + ';' +
        { } 'BELEG_R=' + inttostr(BELEG_R));

      with qPosten do
      begin
        sql.add('select '+
         {} 'RID,ARTIKEL_R,BELEG_R,'+
         {} 'ARTIKEL,MENGE,PREIS,MWST,'+
         {} 'RABATT,MENGE_RECHNUNG,MENGE_AUSFALL,'+
         {} 'MENGE_GELIEFERT,LIEFERANSCHRIFT_R,RECHNUNGANSCHRIFT_R,'+
         {} 'GEWICHT,VERLAG_R,ZUSAGE,AUSGABEART_R,'+
         {} 'MENGE_AGENT,AUSFUEHRUNG,FAKTOR,POSNO,'+
         {} 'NETTO,ZUTAT,INFO,EINHEIT_R,'+
         {} 'BUGET_R,BEARBEITER_R,ANLEGER_R,'+
         {} 'TERMIN,TIER_R,SERIENNUMMER,KUNDEN_AUFTRAG '+
         {} 'from POSTEN where');
        sql.add(INTERN_INFO.values['FILTER' + GENERATION_POSTFIX]);
        sql.add(' (BELEG_R=' + inttostr(BELEG_R) + ')');
        for_update(sql);
{$IFNDEF fpc}
        ColumnAttributes.add('RID=NOTREQUIRED');
{$ENDIF}
        Open;
        First;
      end;

      with qPosten do
      begin

        // a) alle "laufenden" Porto-Artikel rausschmeisen!
        if not(NurGeliefertes) then
        begin

          // Glattstellung vorbereiten!
          if iRechnungGlattstellen then
          begin
            eResult := e_r_BelegInfo(BELEG_R);
            Glattstellung := strtodoubledef(eResult.values['MWST1KN'], 0);
            GlattstellungSatz := strtodoubledef(eResult.values['MWST1PR'], 0);
            eResult.free;
          end
          else
          begin
            Glattstellung := 0.0;
          end;

          // jetzt alle Mengen verbuchen!
          // erkennen, wie die MwSt-Anteile liegen!
          First;
          while not(eof) do
          begin

            EINHEIT_R := FieldByName('EINHEIT_R').AsInteger;

            e_r_PostenInfo(qPosten, NurGeliefertes, EinzelpreisNetto, _Anz, _AnzAuftrag, _AnzGeliefert, _AnzStorniert,
              _AnzNachlieferung, _Rabatt, _EinzelPreis, _MwStSatz);

            _NeuBeauftragt := FieldByName('MENGE').AsInteger -
              (FieldByName('MENGE_GELIEFERT').AsInteger + FieldByName('MENGE_RECHNUNG').AsInteger +
              FieldByName('MENGE_AGENT').AsInteger + FieldByName('MENGE_AUSFALL').AsInteger);

            if not(FieldByName('ARTIKEL_R').IsNull) then
            begin

              // ist überhaupt was zu verbuchen
              if (_NeuBeauftragt <> 0) then
              begin

                //
                _RechnungImPosten := FieldByName('MENGE_RECHNUNG').AsInteger;
                _AgentImPosten := FieldByName('MENGE_AGENT').AsInteger;

                // Sicherstellen, dass es diesen Artikel gibt (Autoanlage)
                if iBelegArtikelNeu then
                  e_w_Artikel(FieldByName('EINHEIT_R').AsInteger, FieldByName('AUSGABEART_R').AsInteger,
                    FieldByName('ARTIKEL_R').AsInteger);

                //
                _MengeLager := e_r_Menge(FieldByName('EINHEIT_R').AsInteger, FieldByName('AUSGABEART_R').AsInteger,
                  FieldByName('ARTIKEL_R').AsInteger);

                if (_NeuBeauftragt > 0) then
                begin

                  // Zunächst aus dem Lager
                  _RechnungDiff := min(_NeuBeauftragt, _MengeLager);
                  _RechnungImPostenNeu := _RechnungImPosten + _RechnungDiff;
                  dec(_NeuBeauftragt, _RechnungDiff);

                  // Den Rest als MehrBedarf
                  _AgentDiff := _NeuBeauftragt;
                  _AgentImPostenNeu := _AgentImPosten + _AgentDiff;

                end
                else
                begin

                  // Erst mal den Bestellbedarf zurückfahren
                  _AgentDiff := max(-_AgentImPosten, _NeuBeauftragt);
                  _AgentImPostenNeu := _AgentImPosten + _AgentDiff;
                  dec(_NeuBeauftragt, _AgentDiff);

                  // Den Rest wieder aufs Lager
                  _RechnungDiff := _NeuBeauftragt;
                  _RechnungImPostenNeu := _RechnungImPosten + _RechnungDiff;

                end;

                _MengeLagerNeu := _MengeLager - _RechnungDiff;

                // Mehrbedarf anzeigen
                if (_AgentDiff <> 0) then
                begin
                  if isHaendler then
                    e_w_MehrBedarfsAnzeige(FieldByName('AUSGABEART_R').AsInteger, FieldByName('ARTIKEL_R').AsInteger,
                      FieldByName('RID').AsInteger, _AgentDiff, eT_MotivationHaendlerAuftrag)
                  else
                    e_w_MehrBedarfsAnzeige(FieldByName('AUSGABEART_R').AsInteger, FieldByName('ARTIKEL_R').AsInteger,
                      FieldByName('RID').AsInteger, _AgentDiff, eT_MotivationKundenAuftrag);
                end;

                edit;
                if (_RechnungImPostenNeu = 0) then
                  FieldByName('MENGE_RECHNUNG').clear
                else
                  FieldByName('MENGE_RECHNUNG').AsInteger := _RechnungImPostenNeu;

                // muss noch mehr bestellt werden??
                if (_AgentImPostenNeu > _AgentImPosten) then
                begin

                  // Zusage setzen!
                  ZUSAGE := Liefertag(DatePlus(DateGet, e_r_Lieferzeit(FieldByName('AUSGABEART_R').AsInteger,
                    FieldByName('ARTIKEL_R').AsInteger)));

                  FieldByName('ZUSAGE').AsDateTime := long2datetime(ZUSAGE);

                end
                else
                begin

                  // Heute lieferbar!
                  if (_RechnungImPostenNeu > _RechnungImPosten) then
                  begin
                    FieldByName('ZUSAGE').AsDateTime := long2datetime(Liefertag(DateGet));
                  end;
                end;

                if (_AgentImPosten <> _AgentImPostenNeu) then
                begin

                  // Agentmenge Veränderung!
                  if _AgentImPostenNeu = 0 then
                    FieldByName('MENGE_AGENT').clear
                  else
                    FieldByName('MENGE_AGENT').AsInteger := _AgentImPostenNeu;

                  // Besteht ein Bestellbedarf für diesen Artikel?
                  // (könnte ja sein, dass er schon geordert ist (mit Lieferzeit)
                  // Ticket 'Order Bedarf für Artikel %s'
                  qTICKET := nQuery;
                  with qTICKET do
                  begin

                    // Ticket schon vorhanden?
                    sql.add('select RID from TICKET where');
                    sql.add(e_r_sqlArtikelWhere(qPosten.FieldByName('AUSGABEART_R').AsInteger,
                      qPosten.FieldByName('ARTIKEL_R').AsInteger) + ' and ');
                    sql.add(' (ART=' + inttostr(eT_WareBestellt) + ') and');
                    sql.add(' (AUSGANG is Null)');
                    Open;
                    First;
                    if eof then
                    begin

                      // TICKET neu anlegen
                      Close;
                      sql.clear;
                      sql.add('select * from TICKET');
                      for_update(sql);
                      Insert;
                      FieldByName('RID').AsInteger := 0;
                      FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
                      FieldByName('MOMENT').AsDateTime := now;
                      FieldByName('ARTIKEL_R').AsInteger := qPosten.FieldByName('ARTIKEL_R').AsInteger;

                      //
                      if not(qPosten.FieldByName('AUSGABEART_R').IsNull) then
                        FieldByName('AUSGABEART_R').AsInteger := qPosten.FieldByName('AUSGABEART_R').AsInteger;
                      FieldByName('ART').AsInteger := eT_WareBestellt;

                      qStringsAdd(FieldByName('INFO'), format('Order für %dx Artikel %s',
                        [_AgentImPostenNeu, qPosten.FieldByName('ARTIKEL').AsString]));
                      FieldByName('VORLAGE').AsDateTime := now + 3;
                      FieldByName('ABLAUF').AsDateTime := FieldByName('VORLAGE').AsDateTime + 5;

                      Post;

                    end
                    else
                    begin

                      TICKET_R := FieldByName('RID').AsInteger;
                      Close;
                      sql.clear;
                      sql.add('select * from TICKET where RID=' + inttostr(TICKET_R));
                      for_update(sql);
                      Open;
                      First;

                      // Ticket abändern!
                      edit;
                      FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
                      FieldByName('MOMENT').AsDateTime := now;
                      qStringsAdd(FieldByName('INFO'), format('Order für %dx Artikel %s erwartet',
                        [_AgentImPostenNeu, qPosten.FieldByName('ARTIKEL').AsString]));
                      FieldByName('VORLAGE').AsDateTime := now + 3;
                      FieldByName('ABLAUF').AsDateTime := FieldByName('VORLAGE').AsDateTime + 5;
                      Post;

                    end;
                  end;
                  qTICKET.free;

                end;
                Post;

                if (_MengeLager <> _MengeLagerNeu) then
                begin
                  if not(ZUSAMMENHANG) then
                  begin
                    e_w_GEN('GEN_ZUSAMMENHANG');
                    ZUSAMMENHANG := true;
                  end;

                  e_w_Menge(
                   {} FieldByName('EINHEIT_R').AsInteger,
                   {} FieldByName('AUSGABEART_R').AsInteger,
                   {} FieldByName('ARTIKEL_R').AsInteger,
                   {} _MengeLagerNeu - _MengeLager,
                   {} qBELEG.FieldByName('RID').AsInteger,
                   {} qPosten.FieldByName('RID').AsInteger);

                end;
              end;

            end
            else
            begin
              if (_NeuBeauftragt <> 0) then
              begin
                _RechnungImPosten := FieldByName('MENGE_RECHNUNG').AsInteger;
                _RechnungImPostenNeu := _RechnungImPosten + _NeuBeauftragt;
                edit;
                if (_RechnungImPostenNeu = 0) then
                  FieldByName('MENGE_RECHNUNG').clear
                else
                  FieldByName('MENGE_RECHNUNG').AsInteger := _RechnungImPostenNeu;
                FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
                Post;
              end;
            end;

            if iRechnungGlattstellen then
              if EinzelpreisNetto then
                if (Glattstellung <> 0.0) then
                  if (_EinzelPreis > 0.0) then
                    if (GlattstellungSatz = _MwStSatz) then
                      if (FieldByName('NETTO').AsString = cC_True) then
                        if (_Anz = 1) then
                          if (Glattstellung > -0.6) and (Glattstellung < 0.6) then
                          begin
                            edit;
                            FieldByName('PREIS').AsFloat := FieldByName('PREIS').AsFloat + Glattstellung;
                            Post;
                            Glattstellung := 0.0;
                          end;

            _PreisProPosition := e_c_Rabatt(e_r_PostenPreis(_EinzelPreis, _Anz, EINHEIT_R), _Rabatt);

            MwStSaver.add(_MwStSatz, _PreisProPosition);
            Next;
          end;

          // Versand-Artikel hinzufügen!
          ARTIKEL_R := e_r_VersandKosten(BELEG_R);
          if (ARTIKEL_R >= cRID_FirstValid) then
          begin

            // Porto-Logik prüfen
            _MaxNettoWert := -1.0;
            _groesstesMwStElementIndex := -1;

            MwStSaver.calc(EinzelpreisNetto);
            for n := 0 to pred(MwStSaver.count) do
            begin
              _NettoInDieserMwStKlasse := MwStSaver.MWST[n].NettoSumme;
              if (_NettoInDieserMwStKlasse > _MaxNettoWert) then
              begin
                _MaxNettoWert := _NettoInDieserMwStKlasse;
                _groesstesMwStElementIndex := n;
              end;
            end;

            Insert;
            FieldByName('ANLEGER_R').AsInteger := sBearbeiter;
            FieldByName('BELEG_R').AsInteger := BELEG_R;
            FieldByName('ZUTAT').AsString := cC_True;
            FieldByName('ARTIKEL_R').AsInteger := ARTIKEL_R;
            FieldByName('MENGE').AsInteger := 1;
            FieldByName('MENGE_RECHNUNG').AsInteger := 1;
            e_w_SetPostenData(ARTIKEL_R, qBELEG.FieldByName('PERSON_R').AsInteger, qPosten);
            if (_groesstesMwStElementIndex <> -1) then
              if iPortoMwStLogik then
              begin
                if (e_r_sqls(
                  { } 'select' +
                  { } ' SORTIMENT.MWST_FIXIERT ' +
                  { } 'from' +
                  { } ' ARTIKEL ' +
                  { } 'join' +
                  { } ' SORTIMENT ' +
                  { } 'on' +
                  { } ' (SORTIMENT.RID=ARTIKEL.SORTIMENT_R) ' +
                  { } 'where' +
                  { } ' (ARTIKEL.RID=' + inttostr(ARTIKEL_R) + ')') <> cC_True) then
                  FieldByName('MWST').AsFloat := MwStSaver.MWST[_groesstesMwStElementIndex].Satz;
              end;
            FieldByName('ARTIKEL').AsString := FieldByName('ARTIKEL').AsString + ' (' + inttostr(succ(TEILLIEFERUNG)) +
              '. Lieferung)';
            Post;
          end;

          //
          e_w_BelegStatusBuchen(BELEG_R);

        end;

        //
        // hier schlussendlich Addierungslauf, da ggf. noch Änderungen gemacht wurden!
        //
        LieferGewicht := e_r_PackformGewicht(BELEG_R);
        MENGE_BUDGET := 0;
        MwStSaver.clear;
        First;
        while not(eof) do
        begin
          EINHEIT_R := FieldByName('EINHEIT_R').AsInteger;
          BUDGET_R := FieldByName('BUGET_R').AsInteger;
          e_r_PostenInfo(qPosten, NurGeliefertes, EinzelpreisNetto, _Anz, _AnzAuftrag, _AnzGeliefert, _AnzStorniert,
            _AnzNachlieferung, _Rabatt, _EinzelPreis, _MwStSatz);
          _PreisProPosition := e_c_Rabatt(e_r_PostenPreis(_EinzelPreis, _Anz, EINHEIT_R), _Rabatt);
          MwStSaver.add(_MwStSatz, _PreisProPosition);
          LieferGewicht := LieferGewicht + (FieldByName('GEWICHT').AsInteger * _Anz);
          if _Anz > 0 then
            if BUDGET_R >= cRID_FirstValid then
              inc(MENGE_BUDGET, _Anz);

          Next;
        end;
      end;

      MwStSaver.calc(EinzelpreisNetto);
      result.add('NETTO=' + format('%m', [MwStSaver.Netto]));
      result.add('RECHNUNGSBETRAG=' + format('%m', [MwStSaver.brutto]));
      result.add('LIEFERGEWICHT=' + format('%d', [LieferGewicht]));
      result.add('BUDGETVOLUMEN=' + inttostr(MENGE_BUDGET));
    except
      on E: exception do
      begin
        AppendStringsToFile('e_w_BerechneBeleg(' + inttostr(BELEG_R) + '): ' + E.Message,
          ErrorFName('BELEG'),
          Uhr12);
      end;
    end;
    qPosten.free;
    qBELEG.free;
    INTERN_INFO.free;
    MwStSaver.free;
  end;
end;

function e_r_Versandfertig(ib_q: TdboDataSet): boolean;
begin
  with ib_q do
    result :=
      // etwas zu liefern
      (FieldByName('MENGE_RECHNUNG').AsInteger > 0) and
      // nix mehr zu ordern
      (FieldByName('MENGE_AGENT').AsInteger = 0);
end;

function e_r_Versandfaehig(ib_q: TdboDataSet): boolean;
begin
  with ib_q do
    result := (FieldByName('MENGE_RECHNUNG').AsInteger > 0);
  // etwas zu liefern.
end;

function e_w_BelegStatusBuchen(BELEG_R: TDOM_Reference): boolean;
var
  GENERATION: integer;
  VERSAND_STATUS: integer;

  Pre_versandfertig: boolean;
  Pre_versandfaehig: boolean;
  Post_versandfertig: boolean;
  Post_versandfaehig: boolean;

  MENGE_AUFTRAG: integer;
  MENGE_RECHNUNG: integer;
  MENGE_GELIEFERT: integer;
  MENGE_AGENT: integer;
  EventText: TStringList;
  ErrorFlag: boolean;
  LAGER_R: integer;
  EMPFAENGER_R: integer;
  PERSON_R: integer;
  qEREIGNIS: TdboQuery;
  VOLUMEN: double;
  Zutaten: double;
  cPOSTEN: TdboCursor;
  qBELEG: TdboQuery;

  qTICKET: TdboQuery;
  TICKET_R: integer;

  ZUSAGE: TAnfixDate;
  ERSTERLIEFERTAG: TAnfixDate;
  TERMIN: double;
  cTerminUnset: double;

  IncGeneration: boolean;
  DoPost: boolean;

  procedure GENERATION_Log(IncGen: boolean; s: string);
  begin
    if IncGen then
    begin
      AppendStringsToFile(
        { } Uhr8 + ';' +
        { } inttostr(BELEG_R) + '-' +
        { } inttostr(GENERATION) + ';' +
        { } sBearbeiterKurz + ';' +
        { } s,
        { } DiagnosePath + 'GENERATION-' + DatumLog + cLogExtension);
      IncGeneration := true;
    end;
  end;

begin
  result := false;
  cPOSTEN := nCursor;
  qBELEG := nQuery;
  try

    VERSAND_STATUS := cV_ZeroState;
    MENGE_AUFTRAG := 0;
    MENGE_RECHNUNG := 0;
    MENGE_AGENT := 0;
    MENGE_GELIEFERT := 0;
    VOLUMEN := 0.0;
    Zutaten := 0.0;
    ErrorFlag := false;

    ZUSAGE := 0;
    ERSTERLIEFERTAG := MaxInt;
    cTerminUnset := MaxDouble;
    TERMIN := cTerminUnset;

    with cPOSTEN do
    begin

      //
      sql.add('select * from POSTEN where BELEG_R=' + inttostr(BELEG_R));
      ApiFirst;
      while not(eof) do
      begin

        if not(FieldByName('ZUSAGE').IsNull) then
        begin
          ZUSAGE := max(ZUSAGE, DateTime2Long(FieldByName('ZUSAGE').AsDateTime));
          ERSTERLIEFERTAG := min(ERSTERLIEFERTAG, DateTime2Long(FieldByName('ZUSAGE').AsDateTime));
        end;

        if not(e_r_IsVersandKosten(FieldByName('ARTIKEL_R').AsInteger)) then
        begin

          // kein Versandartikel
          if not(FieldByName('TERMIN').IsNull) then
          begin
            if (FieldByName('MENGE_RECHNUNG').AsInteger > 0) or (FieldByName('MENGE_AGENT').AsInteger > 0) then
              TERMIN := min(TERMIN, FieldByName('TERMIN').AsDateTime);
          end;

          // Summen bilden
          if (FieldByName('ZUTAT').AsString <> cC_True) then
          begin
            inc(MENGE_AUFTRAG,
              {} FieldByName('MENGE').AsInteger -
              {} FieldByName('MENGE_AUSFALL').AsInteger -
              {} min(0,FieldByName('MENGE_RECHNUNG').AsInteger));

            inc(MENGE_RECHNUNG, max(0, FieldByName('MENGE_RECHNUNG').AsInteger));
            inc(MENGE_GELIEFERT, FieldByName('MENGE_GELIEFERT').AsInteger);
            inc(MENGE_AGENT, FieldByName('MENGE_AGENT').AsInteger);
          end;

          // Regel auswerten!
          VOLUMEN :=
           VOLUMEN +
           e_r_PostenPreis(
            {} FieldByName('PREIS').AsFloat,
            {} FieldByName('MENGE').AsInteger - FieldByName('MENGE_AUSFALL').AsInteger,
            {} FieldByName('EINHEIT_R').AsInteger);

          if not(ErrorFlag) then
            ErrorFlag := (MENGE_AUFTRAG <> MENGE_RECHNUNG + MENGE_AGENT + MENGE_GELIEFERT);

        end
        else
        begin
          Zutaten :=
           {} Zutaten +
           {} e_r_PostenPreis(
           {} FieldByName('PREIS').AsFloat,
           {} FieldByName('MENGE').AsInteger - FieldByName('MENGE_AUSFALL').AsInteger,
           {} FieldByName('EINHEIT_R').AsInteger);
        end;
        ApiNext;
      end;
      Close;
    end;

    with qBELEG do
    begin

      sql.add('select * from BELEG where RID=' + inttostr(BELEG_R) + ' ' + for_update);
      Open;
      First;
      if eof then
        raise exception.create('Beleg nicht gefunden');

      GENERATION := FieldByName('GENERATION').AsInteger;

      // Bisheriges Lager auslesen
      LAGER_R := FieldByName('LAGER_R').AsInteger;

      // Status der versendbarkeit bestimmen.
      Pre_versandfertig := e_r_Versandfertig(qBELEG);
      Pre_versandfaehig := e_r_Versandfaehig(qBELEG);

      // Empfaenger bestimmen
      PERSON_R := FieldByName('PERSON_R').AsInteger;
      if (FieldByName('LIEFERANSCHRIFT_R').IsNull) then
        EMPFAENGER_R := PERSON_R
      else
        EMPFAENGER_R := FieldByName('LIEFERANSCHRIFT_R').AsInteger;

      // Konsistenz Fehler
      if ErrorFlag then
        inc(VERSAND_STATUS, cV_Fehler);

      if (MENGE_AGENT > 0) then
        inc(VERSAND_STATUS, cV_Agent);

      if (MENGE_RECHNUNG <> 0) then
        inc(VERSAND_STATUS, cV_Rechnung);

      if (MENGE_GELIEFERT > 0) then
        inc(VERSAND_STATUS, cV_Geliefert);


      // Bedingungen für einen "edit" -> somit auch Generations Wechsel
      IncGeneration := false;
      DoPost := true;
      repeat

        // Status des Beleges
        if (FieldByName('VERSAND_STATUS').IsNull) then
        begin
          GENERATION_Log(true, format('Erstmaliges setzen des VERSAND_STATUS auf %d', [VERSAND_STATUS]));
          break;
        end;
        if (VERSAND_STATUS <> FieldByName('VERSAND_STATUS').AsInteger) then
        begin
          GENERATION_Log(true, format('VERSAND_STATUS von %d auf %d', [FieldByName('VERSAND_STATUS').AsInteger,
            VERSAND_STATUS]));
          break;
        end;

        // Geld
        if IsOther(FieldByName('VOLUMEN').AsFloat, VOLUMEN) then
        begin
          GENERATION_Log(true, format('Volumen von %m nach %m', [FieldByName('VOLUMEN').AsFloat, VOLUMEN]));
          break;
        end;
        if IsOther(FieldByName('ZUTATEN').AsFloat, Zutaten) then
        begin
          GENERATION_Log(true, format('ZUTATEN von %m nach %m', [FieldByName('ZUTATEN').AsFloat, Zutaten]));
          break;
        end;

        // Mengen
        if (FieldByName('MENGE_AUFTRAG').AsInteger <> MENGE_AUFTRAG) then
        begin
          GENERATION_Log(true, format('MENGE_AUFTRAG von %d nach %d', [FieldByName('MENGE_AUFTRAG').AsInteger,
            MENGE_AUFTRAG]));
          break;
        end;
        if (FieldByName('MENGE_RECHNUNG').AsInteger <> MENGE_RECHNUNG) then
        begin
          GENERATION_Log(true, format('MENGE_RECHNUNG von %d nach %d', [FieldByName('MENGE_RECHNUNG').AsInteger,
            MENGE_RECHNUNG]));
          break;
        end;
        if (FieldByName('MENGE_AGENT').AsInteger <> MENGE_AGENT) then
        begin
          GENERATION_Log(true, format('MENGE_AGENT von %d nach %d', [FieldByName('MENGE_AGENT').AsInteger,
            MENGE_AGENT]));
          break;
        end;
        if (FieldByName('MENGE_GELIEFERT').AsInteger <> MENGE_GELIEFERT) then
        begin
          GENERATION_Log(true, format('MENGE_GELIEFERT von %d nach %d', [FieldByName('MENGE_GELIEFERT').AsInteger,
            MENGE_GELIEFERT]));
          break;
        end;

        // Datums
        if ((FieldByName('TERMIN').AsDateTime <> TERMIN) and (TERMIN <> cTerminUnset)) then
        begin
          if FieldByName('TERMIN').IsNull then
            GENERATION_Log(true, format('TERMIN von ' + cOLAPNull + ' auf %s', [dTimeStamp(TERMIN)]))
          else
            GENERATION_Log(true, format('TERMIN von %s auf %s', [dTimeStamp(FieldByName('TERMIN').AsDateTime),
              dTimeStamp(TERMIN)]));
          break;
        end;

        if (not(FieldByName('TERMIN').IsNull) and (TERMIN = cTerminUnset)) then
        begin
          GENERATION_Log(true, format('TERMIN von %s auf ' + cOLAPNull,
            [dTimeStamp(FieldByName('TERMIN').AsDateTime)]));
          break;
        end;

        if (ZUSAGE <> DateTime2Long(FieldByName('ZUSAGE').AsDateTime)) then
        begin
          GENERATION_Log(false, format('ZUSAGE von %s auf %s', [long2date(FieldByName('ZUSAGE').AsDateTime),
            long2date(ZUSAGE)]));
          break;
        end;

        if not(Pre_versandfaehig) and (MENGE_RECHNUNG=0) and (LAGER_R>=cRID_FirstValid) then
        begin
          GENERATION_Log(false, format('LAGER_R von %d auf <NULL>', [FieldByName('LAGER_R').AsInteger]));
          Pre_versandfaehig := true;
          break;
        end;

        if (LAGER_R<cRID_FirstValid) and Pre_VersandFaehig then
        begin
          GENERATION_Log(false, 'LAGER_R ist <NULL>');
          break;
        end;

        DoPost := false;
      until yet;

      if DoPost then
      begin

        // STATUS - Wechsel des Beleges!
        edit;
        FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
        if IncGeneration then
          FieldByName('GENERATION').AsInteger := succ(GENERATION);
        FieldByName('DRUCK').clear;
        FieldByName('VERSAND_STATUS').AsInteger := VERSAND_STATUS;
        FieldByName('MENGE_AUFTRAG').AsInteger := MENGE_AUFTRAG;
        FieldByName('MENGE_RECHNUNG').AsInteger := MENGE_RECHNUNG;
        FieldByName('MENGE_AGENT').AsInteger := MENGE_AGENT;
        FieldByName('MENGE_GELIEFERT').AsInteger := MENGE_GELIEFERT;
        FieldByName('VOLUMEN').AsFloat := VOLUMEN;
        FieldByName('ZUTATEN').AsFloat := Zutaten;
        if (ZUSAGE = 0) then
          FieldByName('ZUSAGE').clear
        else
          FieldByName('ZUSAGE').AsDateTime := long2datetime(ZUSAGE);
        if (TERMIN = cTerminUnset) then
          FieldByName('TERMIN').clear
        else
          FieldByName('TERMIN').AsDateTime := TERMIN;

        Post_versandfertig := e_r_Versandfertig(qBELEG);
        Post_versandfaehig := e_r_Versandfaehig(qBELEG);
        Post;
        Close;

        //
        // T I C K E T   "Warenausgang"
        //
        if (MENGE_AGENT > 0) then
        begin

          // Ticket über Warenausgang sicherstellen!
          qTICKET := nQuery;
          with qTICKET do
          begin

            //
            sql.add('select RID from TICKET where');
            sql.add(' (BELEG_R=' + inttostr(BELEG_R) + ') and');
            sql.add(' (ART=' + inttostr(eT_WareRausgegangen) + ') and');
            sql.add(' (AUSGANG is Null)');
            Open;
            First;
            if eof then
            begin

              // TICKET neu anlegen
              Close;
              sql.clear;
              sql.add('select * from TICKET ' + for_update);
              Insert;
              FieldByName('RID').AsInteger := 0;
              FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
              FieldByName('MOMENT').AsDateTime := now;
              FieldByName('BELEG_R').AsInteger := BELEG_R;
              FieldByName('PERSON_R').AsInteger := EMPFAENGER_R;
              qStringsAdd(FieldByName('INFO'), format('Warenausgang für Beleg %d erwartet', [BELEG_R]));
              FieldByName('ART').AsInteger := eT_WareRausgegangen;
              if (ERSTERLIEFERTAG < MaxInt) then
                FieldByName('VORLAGE').AsDateTime := long2datetime(ERSTERLIEFERTAG);
              FieldByName('ABLAUF').AsDateTime := FieldByName('VORLAGE').AsDateTime + 3;
              Post;

            end
            else
            begin

              // Ticket abändern!
              TICKET_R := FieldByName('RID').AsInteger;
              Close;
              sql.clear;
              sql.add('select * from TICKET where RID=' + inttostr(TICKET_R) + ' ' + for_update);
              Open;
              First;
              edit;
              FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
              FieldByName('MOMENT').AsDateTime := now;
              if (ERSTERLIEFERTAG < MaxInt) then
                FieldByName('VORLAGE').AsDateTime := long2datetime(ERSTERLIEFERTAG);
              FieldByName('ABLAUF').AsDateTime := FieldByName('VORLAGE').AsDateTime + 3;
              qStringsAdd(FieldByName('INFO'), FieldByName('MOMENT').AsString);
              // Einfach weiteren Moment hinzu!
              Post;

            end;
          end;
          qTICKET.free;

        end
        else
        begin

          // Alle WarenAusgangs Tickets abzeichnen!
          e_x_sql(
           {} 'update TICKET set AUSGANG = ''' + cC_True + ''' where ' +
           {} ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
           {} ' (ART=' + inttostr(eT_WareRausgegangen) + ') and' +
           {} ' (AUSGANG is null)');
        end;

        //
        // Übergangsfach Logik überhaupt aktiv
        //
        if (e_r_Uebergangsfach_VERLAG_R >= cRID_FirstValid) then
        begin

          //
          // L A G E R  zuteilen
          //
          if Post_versandfaehig then
          begin
            if (LAGER_R < cRID_FirstValid) then
            begin
              LAGER_R := e_r_UebergangsfachFromPerson(EMPFAENGER_R);
              if (LAGER_R>=cRID_FirstValid) then
              begin
                // BELEG.LAGER_R verändern!
                e_w_Zwischenlagern(BELEG_R, LAGER_R);
              end
              else
              begin
                raise exception.create('kein Übergangsfach mehr frei!');
              end;
            end;
          end;

          //
          // L A G E R        austragen
          //
          // E R E I G N I S  erzeugen
          //
          repeat

            if not(Pre_versandfertig) and Post_versandfertig then
            begin

              // bisher nicht versandfertig - nun aber versandfertig

              // Ereignis "versand-fertig" entsteht?!
              qEREIGNIS := nQuery;
              with qEREIGNIS do
              begin
{$IFNDEF fpc}
                ColumnAttributes.add('RID=NOTREQUIRED');
                ColumnAttributes.add('AUFTRITT=NOTREQUIRED');
{$ENDIF}
                sql.add('select * from EREIGNIS ' + for_update);
                Insert;
                FieldByName('ART').AsInteger := eT_BestellungNunVollstaendigLieferbar;
                FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
                FieldByName('BELEG_R').AsInteger := BELEG_R;
                if (LAGER_R >= cRID_FirstValid) then
                  FieldByName('LAGER_R').AsInteger := LAGER_R;
                FieldByName('PERSON_R').AsInteger := PERSON_R;
                EventText := TStringList.create;
                EventText.add(format('Versandfertig: im Übergangsfach %s!', [e_r_LagerPlatzNameFromLAGER_R(LAGER_R)]));
                FieldByName('INFO').assign(EventText);
                EventText.free;
                Post;
              end;
              qEREIGNIS.free;

              // Ticket "Auslieferung an die Post" ensteht
              break;
            end;

            if not(Pre_versandfaehig) and Post_versandfaehig then
            begin

              // bisher nicht versandfertig - nun aber versandfertig

              qEREIGNIS := nQuery;
              with qEREIGNIS do
              begin
{$IFNDEF fpc}
                ColumnAttributes.add('RID=NOTREQUIRED');
                ColumnAttributes.add('AUFTRITT=NOTREQUIRED');
{$ENDIF}
                sql.add('select * from EREIGNIS ' + for_update);
                Insert;
                FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
                FieldByName('BELEG_R').AsInteger := BELEG_R;
                if LAGER_R >= cRID_FirstValid then
                  FieldByName('LAGER_R').AsInteger := LAGER_R;
                FieldByName('PERSON_R').AsInteger := PERSON_R;
                FieldByName('ART').AsInteger := eT_BestellungNunTeilweiseLieferbar;
                EventText := TStringList.create;
                EventText.add(format('Versandfähig: Übergangsfach %s zugeteilt!',
                  [e_r_LagerPlatzNameFromLAGER_R(LAGER_R)]));
                FieldByName('INFO').assign(EventText);
                EventText.free;
                Post;
              end;
              qEREIGNIS.free;
              break;
            end;

            if Pre_versandfaehig and not(Post_versandfaehig) then
            begin
              qEREIGNIS := nQuery;
              with qEREIGNIS do
              begin
{$IFNDEF fpc}
                ColumnAttributes.add('RID=NOTREQUIRED');
                ColumnAttributes.add('AUFTRITT=NOTREQUIRED');
{$ENDIF}
                sql.add('select * from EREIGNIS ' + for_update);
                Insert;
                FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
                FieldByName('BELEG_R').AsInteger := BELEG_R;
                if (LAGER_R >= cRID_FirstValid) then
                  FieldByName('LAGER_R').AsInteger := LAGER_R;
                FieldByName('PERSON_R').AsInteger := PERSON_R;
                FieldByName('ART').AsInteger := eT_BestellungMerkmalTeilweiseLieferbarVerloren;
                EventText := TStringList.create;
                EventText.add(format('Versandfähigkeit verloren: Übergangsfach %s freigegeben!',
                  [e_r_LagerPlatzNameFromLAGER_R(LAGER_R)]));
                FieldByName('INFO').assign(EventText);
                EventText.free;
                Post;
              end;
              qEREIGNIS.free;

              // Lager austragen
              e_w_Zwischenlagern(BELEG_R, cRID_Null);

              break;
            end;

          until yet;

        end;

      end;

    end;
    result := true;

  except
    on E: exception do
    begin
      AppendStringsToFile('e_w_BelegStatusBuchen(' + inttostr(BELEG_R) + '): ' + E.Message,
        ErrorFName('BELEG'),
        Uhr12);
    end;
  end;
  cPOSTEN.free;
  qBELEG.free;

  // Basic-Programm ausführen
  if result then
   e_x_basic(
        { } MyProgramPath + cDBASICPath + 'BelegStatusBuchen-1.txt',
        { } 'PERSON_R=' + inttostr(PERSON_R) + ';' +
        { } 'BELEG_R=' + inttostr(BELEG_R));

end;

function e_w_BBelegStatusBuchen(BBELEG_R: integer): boolean;
var
  _bestell_status: integer;
  MENGE_AUFTRAG: integer;
  Menge_Unbestellt: integer;
  Menge_Erwartet: integer;
  MENGE_GELIEFERT: integer;
  Menge_Zurueck: integer;
  cBPOSTEN: TdboCursor;
  qBBELEG: TdboQuery;
begin
  result := false;
  if (BBELEG_R > 0) then
  begin

    _bestell_status := cB_ZeroState;
    MENGE_AUFTRAG := 0;
    Menge_Erwartet := 0;
    MENGE_GELIEFERT := 0;
    Menge_Zurueck := 0;
    Menge_Unbestellt := 0;

    qBBELEG := nQuery;
    cBPOSTEN := nCursor;

    try

      // Summen bilden!
      with cBPOSTEN do
      begin
        sql.add('select * from BPOSTEN where (BELEG_R=' + inttostr(BBELEG_R) + ')');
        ApiFirst;
        while not(eof) do
        begin
          MENGE_AUFTRAG := MENGE_AUFTRAG + FieldByName('MENGE').AsInteger - FieldByName('MENGE_AUSFALL').AsInteger;
          Menge_Erwartet := Menge_Erwartet + FieldByName('MENGE_ERWARTET').AsInteger;
          Menge_Zurueck := Menge_Zurueck + FieldByName('MENGE_ZURUECK').AsInteger;
          MENGE_GELIEFERT := MENGE_GELIEFERT + FieldByName('MENGE_GELIEFERT').AsInteger;
          Menge_Unbestellt := Menge_Unbestellt + FieldByName('MENGE_UNBESTELLT').AsInteger;
          ApiNext;
        end;
      end;

      // Buisseness Roules "Konsistenz Fehler"
      if (MENGE_AUFTRAG <> Menge_Unbestellt + Menge_Erwartet + MENGE_GELIEFERT + Menge_Zurueck) then
        inc(_bestell_status, cB_Fehler);

      if (Menge_Erwartet > 0) then
        inc(_bestell_status, cB_Erwartet);

      if (MENGE_GELIEFERT > 0) then
        inc(_bestell_status, cB_Geliefert);

      if (Menge_Zurueck > 0) then
        inc(_bestell_status, cB_Zurueck);

      if (Menge_Unbestellt > 0) then
        inc(_bestell_status, cB_Unbestellt);

      with qBBELEG do
      begin
        sql.add('select * from BBELEG where RID=' + inttostr(BBELEG_R) + ' ' + for_update);
        Open;
        First;
        if eof then
          raise exception.create('Beleg nicht gefunden');

        if (_bestell_status <> FieldByName('BESTELL_STATUS').AsInteger) or FieldByName('BESTELL_STATUS').IsNull or
          (FieldByName('MENGE_ERWARTET').AsInteger <> Menge_Erwartet) or
          (FieldByName('MENGE_ZURUECK').AsInteger <> Menge_Zurueck) or
          (FieldByName('MENGE_GELIEFERT').AsInteger <> MENGE_GELIEFERT) or
          (FieldByName('MENGE_UNBESTELLT').AsInteger <> Menge_Unbestellt) then
        begin
          // STATUS - Wechsel des Beleges!
          edit;
          FieldByName('BESTELL_STATUS').AsInteger := _bestell_status;
          FieldByName('MENGE_UNBESTELLT').AsInteger := Menge_Unbestellt;
          FieldByName('MENGE_ERWARTET').AsInteger := Menge_Erwartet;
          FieldByName('MENGE_GELIEFERT').AsInteger := MENGE_GELIEFERT;
          FieldByName('MENGE_ZURUECK').AsInteger := Menge_Zurueck;
          result := true;
          Post;
        end;
      end;

    except
      on E: exception do
      begin
        AppendStringsToFile('e_w_BBelegStatusBuchen(' + inttostr(BBELEG_R) + '): ' + E.Message,
          {} ErrorFName('BELEG'),
          {} Uhr12);
      end;
    end;
    cBPOSTEN.free;
    qBBELEG.free;
  end;
end;

function e_r_LeerGewicht(PACKFORM_R: integer): integer;
var
  cPACKFORM: TdboCursor;
begin
  cPACKFORM := nCursor;
  with cPACKFORM do
  begin
    sql.add('select GEWICHT from PACKFORM where RID=' + inttostr(PACKFORM_R));
    ApiFirst;
    result := FieldByName('GEWICHT').AsInteger;
  end;
  cPACKFORM.free;
end;

function e_w_SetStandardVersandData(qVERSAND: TdboQuery): integer;
// [VERSENDER_R]
var
  PACKFORM_R: integer;
  cVERSENDER: TdboCursor;
begin

  // Standard-Versender ermitteln
  cVERSENDER := nCursor;
  with cVERSENDER do
  begin
    sql.add('select RID, PACKFORM_R from VERSENDER where STANDARD=''' + cC_True + '''');
    ApiFirst;
  end;

  //
  if not(cVERSENDER.eof) then
  begin
    result := cVERSENDER.FieldByName('RID').AsInteger;
    PACKFORM_R := cVERSENDER.FieldByName('PACKFORM_R').AsInteger;
    if assigned(qVERSAND) then
      with qVERSAND do
      begin
        // Standard-Versandform eintragen!
        FieldByName('VERSENDER_R').AsInteger := result;
        if (PACKFORM_R >= cRID_FirstValid) then
        begin
          FieldByName('PACKFORM_R').AsInteger := PACKFORM_R;
          FieldByName('LEERGEWICHT').AsInteger := e_r_LeerGewicht(PACKFORM_R);
        end;
      end;
  end
  else
  begin
    result := -1;
  end;
  cVERSENDER.free;
end;

var
 _e_r_StandardVersender : integer = -1;

function e_r_StandardVersender: integer;
begin
  // Standard-Versender ermitteln
  if (_e_r_StandardVersender=-1) then
    _e_r_StandardVersender := e_r_sql('select RID from VERSENDER where STANDARD=''' + cC_True + '''');
  result := _e_r_StandardVersender;
end;

function e_r_Stempel(PERSON_R, BELEG_R: integer): integer;
var
  pOLAP, xOLAP, rOLAP: TStringList;
  FName: string;
begin
  FName := iSystemOlapPath + 'Beleg-Stempel' + cOLAPExtension;
  if FileExists(FName) then
  begin
    pOLAP := TStringList.create;
    xOLAP := TStringList.create;
    pOLAP.add('$PERSON_R=' + inttostr(PERSON_R));
    pOLAP.add('$BELEG_R=' + inttostr(BELEG_R));
    xOLAP.LoadFromFile(FName);
    rOLAP := e_r_OLAP(xOLAP, pOLAP);
    result := StrToIntDef(rOLAP.values['STEMPEL_R'], cRID_Null);
    pOLAP.free;
    rOLAP.free;
    xOLAP.free;
  end
  else
  begin
    result := cRID_Null;
  end;
end;

const
  _Cache_RechnungsNummerAnzahlDerStellen: integer = 0;

function e_r_RechnungsNummerAnzahlDerStellen: integer;
begin
  if (_Cache_RechnungsNummerAnzahlDerStellen = 0) then
    _Cache_RechnungsNummerAnzahlDerStellen := length(inttostr(e_r_gen('GEN_RECHNUNG')));
  result := _Cache_RechnungsNummerAnzahlDerStellen;
end;

function e_r_RechnungsNummer(BELEG_R, TEILLIEFERUNG: integer): string;
var
  RECHNUNGSNUMMER: integer;
begin
  RECHNUNGSNUMMER := e_r_sql(
   {} 'select RECHNUNG from VERSAND where' +
   {} ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
   {} ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')');
  if (RECHNUNGSNUMMER = 0) then
    result := ''
  else
    result := inttostrN(RECHNUNGSNUMMER, e_r_RechnungsNummerAnzahlDerStellen);
end;

function e_r_RechnungsNummern(BELEG_R: integer): TStringList;
var
  n: integer;
  RECHNUNGEN: TgpIntegerList;
begin
  result := TStringList.create;
  RECHNUNGEN := e_r_sqlm(
   {} 'select RECHNUNG from VERSAND where' +
   {} ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
   {} ' (RECHNUNG is not null) ' +
   {} 'order by RECHNUNG');
  for n := 0 to pred(RECHNUNGEN.count) do
    result.add(inttostrN(RECHNUNGEN[n], e_r_RechnungsNummerAnzahlDerStellen));
  RECHNUNGEN.free;
end;

function e_w_RechnungsNummer(BELEG_R: integer): integer;
// [RechnungsNummer]
var
  PERSON_R: integer;
  STEMPEL_R: integer;
begin
  result := e_r_sql('select NUMMER from BELEG where RID=' + inttostr(BELEG_R));
  if (result = 0) then
  begin

    // Rechnungsnummer bestimmen
    PERSON_R := e_r_sql('select PERSON_R from BELEG where RID=' + inttostr(BELEG_R));
    STEMPEL_R := e_r_Stempel(PERSON_R, BELEG_R);
    if (STEMPEL_R < cRID_FirstValid) then
      result := e_w_GEN('GEN_RECHNUNG')
    else
    begin
      result := e_w_Stempel(STEMPEL_R);
    end;

    // Rechnungsnummer in den Belegkopf eintragen
    e_x_sql('update BELEG set NUMMER=' + inttostr(result) + ' where RID=' + inttostr(BELEG_R));

  end;
end;

function e_w_BelegVersand(BELEG_R: integer; Summe: double; gewicht: integer): integer;
var
  cBELEG: TdboCursor;
  qVERSAND: TdboQuery;
  RECHNUNGSNUMMER: integer;
begin
  result := 0;
  try

    cBELEG := nCursor;
    with cBELEG do
    begin
      sql.add('select TEILLIEFERUNG, LIEFERANSCHRIFT_R, RECHNUNGSANSCHRIFT_R, NUMMER from BELEG where RID=' +
        inttostr(BELEG_R));
      ApiFirst;
      RECHNUNGSNUMMER := FieldByName('NUMMER').AsInteger;
    end;

    // erst mal entsprechende Teillieferung anlegen
    qVERSAND := nQuery;
    with qVERSAND do
    begin

      //
      sql.add('select * from VERSAND where BELEG_R=' + inttostr(BELEG_R));
      for_update(sql);
      Open;
      First;

      // Erstanlage
      if IsEmpty then
      begin

        // Hey erst mal anlegen!
        Insert;
        FieldByName('RID').AsInteger := cRID_AutoInc;
        FieldByName('ANLEGER_R').AsInteger := sBearbeiter;
        FieldByName('BELEG_R').AsInteger := BELEG_R;
        FieldByName('TEILLIEFERUNG').AsInteger := cBELEG.FieldByName('TEILLIEFERUNG').AsInteger;
        e_w_SetStandardVersandData(qVERSAND);
        Post;

      end
      else
      begin

        // Existiert diese Teillieferung?
        if not(locate('TEILLIEFERUNG', cBELEG.FieldByName('TEILLIEFERUNG').AsInteger, [])) then
        begin
          Insert;
          FieldByName('RID').AsInteger := cRID_AutoInc;
          FieldByName('ANLEGER_R').AsInteger := sBearbeiter;
          FieldByName('BELEG_R').AsInteger := BELEG_R;
          FieldByName('TEILLIEFERUNG').AsInteger := cBELEG.FieldByName('TEILLIEFERUNG').AsInteger;
          e_w_SetStandardVersandData(qVERSAND);
          Post;
        end;

      end;

      refresh; // notwendig wegen obiger selektion!

      if locate('TEILLIEFERUNG', cBELEG.FieldByName('TEILLIEFERUNG').AsInteger, []) then
      begin

        edit;
        if cBELEG.FieldByName('LIEFERANSCHRIFT_R').IsNull then
          FieldByName('LIEFERANSCHRIFT_R').clear
        else
          FieldByName('LIEFERANSCHRIFT_R').assign(cBELEG.FieldByName('LIEFERANSCHRIFT_R'));

        if cBELEG.FieldByName('RECHNUNGSANSCHRIFT_R').IsNull then
          FieldByName('RECHNUNGSANSCHRIFT_R').clear
        else
          FieldByName('RECHNUNGSANSCHRIFT_R').assign(cBELEG.FieldByName('RECHNUNGSANSCHRIFT_R'));

        FieldByName('LIEFERBETRAG').AsFloat := Summe;
        FieldByName('GEWICHT').AsInteger := gewicht;
        FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
        if (RECHNUNGSNUMMER > 0) then
          FieldByName('RECHNUNG').AsInteger := RECHNUNGSNUMMER;
        Post;

        // Rechnungsnummer austragen!
        e_x_sql('update BELEG set NUMMER=null where RID=' + inttostr(BELEG_R));

      end
      else
      begin
        AppendStringsToFile('e_w_BelegVersand(' + inttostr(BELEG_R) + '): locate misslungen!',
          {} ErrorFName('BELEG'),
          {} Uhr12);
      end;
    end;
    cBELEG.free;
    qVERSAND.free;

  except
    on E: exception do
    begin
      AppendStringsToFile('e_w_BelegVersand(' + inttostr(BELEG_R) + '): ' + E.Message,
        {} ErrorFName('BELEG'),
        {} Uhr12);
    end;
  end;
end;

procedure e_w_SetPostenPreis(EINHEIT_R, AUSGABEART_R, ARTIKEL_R, PERSON_R: integer; qPosten: TdboQuery);
var
  Satz: double;
  artikelNetto: boolean;
  artikelNettoWieBrutto: boolean;
  personNetto: boolean;
  personNettoWieBrutto: boolean;

  Rabatt: double;
  PREIS: double;
begin
  with qPosten do
  begin

    // Rabatt
    Rabatt := e_r_Rabatt(ARTIKEL_R, PERSON_R, personNetto, personNettoWieBrutto);
    if (Rabatt > 0.0) then
      FieldByName('RABATT').AsFloat := Rabatt
    else
      FieldByName('RABATT').clear;

    // Preis, MwSt, NettoWieBrutto, Rabatt neu setzen
    PREIS := e_r_Preis(EINHEIT_R, AUSGABEART_R, ARTIKEL_R, Satz, artikelNetto, artikelNettoWieBrutto);
    FieldByName('NETTO').AsString := bool2cC(artikelNetto);
    if personNetto then
      FieldByName('MWST').AsFloat := 0
    else
      FieldByName('MWST').AsFloat := Satz;
    if (PREIS <> cPreis_vergriffen) and (PREIS <> cPreis_aufAnfrage) then
    begin
      if personNetto and not(personNettoWieBrutto) and not(artikelNettoWieBrutto) and not(artikelNetto) then
        FieldByName('PREIS').AsFloat := cPreisRundung(PREIS / (1.0 + Satz / 100.0))
      else
        FieldByName('PREIS').AsFloat := PREIS;
    end
    else
    begin
      FieldByName('PREIS').clear;
    end;
  end;
end;

procedure e_w_SetPostenData(ARTIKEL_R, PERSON_R: integer; qPosten: TdboQuery);
var
  cARTIKEL: TdboCursor;
  AUSGABEART_R: integer;
  EINHEIT_R: integer;
begin
  if (ARTIKEL_R < cRID_FirstValid) then
    exit;
  // Genau
  cARTIKEL := nCursor;
  try

    //
    with cARTIKEL do
    begin
      sql.add('select EINHEIT_R,TITEL,FAKTOR,VERLAG_R');
      sql.add('from ARTIKEL where RID=' + inttostr(ARTIKEL_R));
      ApiFirst;
      if eof then
        raise exception.create('ARTIKEL_R nicht gefunden');
    end;

    //
    with qPosten do
    begin
      AUSGABEART_R := FieldByName('AUSGABEART_R').AsInteger;
      // optionale Felder belegen, falls nicht schon passiert
      if FieldByName('EINHEIT_R').IsNull then
        FieldByName('EINHEIT_R').assign(cARTIKEL.FieldByName('EINHEIT_R'));
      EINHEIT_R := FieldByName('EINHEIT_R').AsInteger;

      e_w_SetPostenPreis(EINHEIT_R, AUSGABEART_R, ARTIKEL_R, PERSON_R, qPosten);

      FieldByName('ARTIKEL_R').AsInteger := ARTIKEL_R;
      FieldByName('ARTIKEL').AsString := e_r_Ausgabeart(AUSGABEART_R) + cARTIKEL.FieldByName('TITEL').AsString;
      FieldByName('GEWICHT').AsInteger := e_r_Gewicht(AUSGABEART_R, ARTIKEL_R);
      FieldByName('FAKTOR').assign(cARTIKEL.FieldByName('FAKTOR'));
      FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
      if not(cARTIKEL.FieldByName('VERLAG_R').IsNull) then
        FieldByName('VERLAG_R').assign(cARTIKEL.FieldByName('VERLAG_R'))
      else
        FieldByName('VERLAG_R').clear;

    end;
  except
    on E: exception do
    begin
      AppendStringsToFile('e_w_SetPostenData(' + inttostr(ARTIKEL_R) + ',' + inttostr(PERSON_R) + '): ' + E.Message,
        {} ErrorFname('BELEG'),
        {} Uhr12);
    end;
  end;
  cARTIKEL.free;
end;

function e_w_WarenkorbEinfuegen(BELEG_R: integer): integer;
var
  PERSON_R: integer;
  cWARENKORB: TdboCursor;
  cBELEG: TdboCursor;
  qPosten: TdboQuery;
begin
  result := 0;
  cBELEG := nCursor;
  qPosten := nQuery;
  cWARENKORB := nCursor;
  try
    repeat

      // Ziel Beleg suchen
      with cBELEG do
      begin
        sql.add('select PERSON_R from BELEG where RID=' + inttostr(BELEG_R));
        ApiFirst;
        if eof then
        begin
          AppendStringsToFile('e_w_WarenkorbEinfuegen(' + inttostr(BELEG_R) + '): Beleg nicht gefunden',
            {} ErrorFName('BELEG'),
            {} Uhr12);
          break;
        end;
        PERSON_R := FieldByName('PERSON_R').AsInteger;
      end;

      // Posten öffnen
      with qPosten do
      begin
        sql.add('select * from POSTEN ' + for_update);
{$IFNDEF fpc}
        ColumnAttributes.add('RID=NOTREQUIRED');
{$ENDIF}
        prepare;
      end;

      // Quelle öffnen
      with cWARENKORB do
      begin
        sql.add(
         { } 'select * from WARENKORB where'+
         { } ' (PERSON_R=' + inttostr(cBELEG.FieldByName('PERSON_R').AsInteger) + ') and'+
         { } ' (SCHRANK is null) '+
         { } 'order by'+
         { } ' POSNO,RID');
        ApiFirst;
        while not(eof) do
        begin
          with qPosten do
          begin
            Insert;
            FieldByName('BELEG_R').AsInteger := BELEG_R;
            FieldByName('AUSGABEART_R').assign(cWARENKORB.FieldByName('AUSGABEART_R'));
            FieldByName('ARTIKEL_R').assign(cWARENKORB.FieldByName('ARTIKEL_R'));
            FieldByName('MENGE').assign(cWARENKORB.FieldByName('MENGE'));
            e_w_SetPostenData(FieldByName('ARTIKEL_R').AsInteger, PERSON_R, qPosten);
            if not(cWARENKORB.FieldByName('AUSGABEART_R').IsNull) then
              FieldByName('ARTIKEL').AsString := FieldByName('ARTIKEL').AsString + ' ' +
                cWARENKORB.FieldByName('BEMERKUNG').AsString;
            Post;
          end;
          ApiNext;
        end;
      end;

    until yet;
  except
    on E: exception do
    begin
      AppendStringsToFile('e_w_WarenkorbEinfuegen(' + inttostr(BELEG_R) + '): ' + E.Message,
        {} ErrorFName('BELEG'),
        {} Uhr12);
    end;
  end;
  cWARENKORB.free;
  qPosten.free;
  cBELEG.free;
end;

procedure e_w_WarenkorbLeeren(PERSON_R: integer);
begin
  //
  try
    e_x_sql('DELETE FROM WARENKORB WHERE (PERSON_R=' + inttostr(PERSON_R) + ') and (SCHRANK is null)');
  except
    on E: exception do
    begin
      AppendStringsToFile('e_w_EinkauswagenLeeren(' + inttostr(PERSON_R) + '): ' + E.Message,
        {} ErrorFName('BELEG'),
        {} Uhr12);
    end;
  end;
end;

function e_w_BelegNeu(PERSON_R: integer): integer;
var
  BELEG_R: integer;
begin
  result := cRID_Null;
  if (PERSON_R >= cRID_FirstValid) then
  begin
    try
      BELEG_R := e_w_GEN('BELEG_GID');
      e_x_sql('insert into BELEG (RID, PERSON_R, EINZELPREIS_NETTO, ANLEGER_R) ' + ' values (' +
        { } RIDtostr(BELEG_R) + ',' +
        { } RIDtostr(PERSON_R) + ',' +
        { } bool2cC_AsString(iEinzelpreisNetto) + ',' +
        { } RIDtostr(sBearbeiter) + ')');
      result := BELEG_R;
    except
      on E: exception do
      begin
        AppendStringsToFile('e_w_BelegNeu(' + inttostr(PERSON_R) + '): ' + E.Message,
          {} ErrorFName('BELEG'),
          {} Uhr12);
      end;
    end;
  end;
end;

function e_r_telefon(ib_q: TdboDataSet): string;
begin
  with ib_q do
  begin
    repeat
      result := cutblank(FieldByName('GESCH_TEL').AsString);
      if (result <> '') then
        break;
      result := cutblank(FieldByName('PRIV_TEL').AsString);
      if (result <> '') then
        break;
      result := cutblank(FieldByName('HANDY').AsString);
      if (result <> '') then
        break;
    until yet;
  end;
end;


function e_r_RabattCode(PERSON_R: integer): string;
begin
  result := noblank(e_r_sqls('select RABATT_CODE from PERSON where RID=' + inttostr(PERSON_R)));
end;

function e_r_RabattFaehig(PERSON_R: integer): boolean;
begin
  result := e_r_RabattCode(PERSON_R) <> '';
end;

function e_w_JoinBeleg(BELEG_R_FROM, BELEG_R_TO: integer): integer;
var
  _BELEG_R_FROM: string;
  _BELEG_R_TO: string;
  References: TStringList;
  qBELEG: TdboQuery;
begin
  result := 0;
  if (BELEG_R_FROM <> BELEG_R_TO) then
  begin

    //
    _BELEG_R_FROM := inttostr(BELEG_R_FROM);
    _BELEG_R_TO := inttostr(BELEG_R_TO);

    //
    References := TStringList.create;
    References.add('AUSGANGSRECHNUNG.BELEG_R');
    References.add('POSTEN.BELEG_R');
    References.add('VERSAND.BELEG_R');
    References.add('WARENBEWEGUNG.BELEG_R');
    References.add('VERTRAG.BELEG_R');
    References.add('GELIEFERT.BELEG_R');
    References.add('EREIGNIS.BELEG_R');
    References.add('ARBEITSZEIT.BELEG_R');
    References.add('BUCH.BELEG_R');
    References.add('DOKUMENT.BELEG_R');
    References.add('TICKET.BELEG_R');

    //
    e_x_dereference(References, _BELEG_R_FROM, _BELEG_R_TO);
    References.free;

    //
    qBELEG := nQuery;
    with qBELEG do
    begin

      sql.add('select RECHNUNGS_BETRAG,DAVON_BEZAHLT from BELEG where RID=' + _BELEG_R_TO + ' ' + for_update);

      edit;
      FieldByName('RECHNUNGS_BETRAG').AsFloat := FieldByName('RECHNUNGS_BETRAG').AsFloat +
        e_r_sqld('select RECHNUNGS_BETRAG from BELEG where RID=' + _BELEG_R_FROM);
      FieldByName('DAVON_BEZAHLT').AsFloat := FieldByName('DAVON_BEZAHLT').AsFloat +
        e_r_sqld('select DAVON_BEZAHLT from BELEG where RID=' + _BELEG_R_FROM);
      Post;

    end;
    qBELEG.free;

    // Neuen Beleg richtigstellen
    e_w_BelegStatusBuchen(BELEG_R_TO);

    // Ursprungsbeleg löschen!
    e_x_sql('delete from BELEG where RID=' + _BELEG_R_FROM);

  end;
end;

function e_w_MoveBeleg(BELEG_R_FROM, PERSON_R_TO: integer): integer;
var
  References: TStringList;
  PERSON_R_FROM: integer;
  _PERSON_R_TO: string;
  _PERSON_R_FROM: string;
begin
  result := 0;
  //
  PERSON_R_FROM := e_r_sql('select PERSON_R from BELEG where RID=' + inttostr(BELEG_R_FROM));

  _PERSON_R_FROM := inttostr(PERSON_R_FROM);
  _PERSON_R_TO := inttostr(PERSON_R_TO);

  CheckCreateDir(cPersonPath(PERSON_R_TO));

  // Alle Teillieferungen dieses Beleges umkopieren
  FileMove(
    { } cPersonPath(PERSON_R_FROM) +
    { } inttostrN(BELEG_R_FROM, 10) + '*',
    { } cPersonPath(PERSON_R_TO));

  // Alle Personenzugehörigkeiten umbiegen
  References := TStringList.create;
  References.add('AUSGANGSRECHNUNG.KUNDE_R where BELEG_R=' + inttostr(BELEG_R_FROM));
  References.add('BELEG.PERSON_R where RID=' + inttostr(BELEG_R_FROM));

  //
  e_x_dereference(References, _PERSON_R_FROM, _PERSON_R_TO);
  References.free;

end;

function e_w_JoinPerson(PERSON_R_FROM, PERSON_R_TO: integer): integer;
var
  References: TStringList;
  _PERSON_R_FROM: string;
  _PERSON_R_TO: string;
  lBELEGE: TgpIntegerList;
  n: integer;
  DeleteMode: boolean;
  RollBackDump: TStringList;
  RollBackDomain: string;
  ArchiveOptions: TStringList;
  ArchivePath: string;
begin
  RollBackDump := TStringList.create;
  RollBackDomain := 'Löschung-PERSON-' + RIDasStr(PERSON_R_FROM);
  result := 0;
  try
    DeleteMode := (PERSON_R_TO < cRID_FirstValid);

    //
    _PERSON_R_FROM := inttostr(PERSON_R_FROM);
    _PERSON_R_TO := inttostr(PERSON_R_TO);

    if DeleteMode then
    begin

      // Belege löschen
      lBELEGE := e_r_sqlm('select RID from BELEG where PERSON_R=' + _PERSON_R_FROM);
      for n := 0 to pred(lBELEGE.count) do
      begin
        e_w_preDeleteBeleg(lBELEGE[n]);
        e_x_sql('delete from BELEG where RID=' + inttostr(lBELEGE[n]));
      end;
      lBELEGE.free;

      fbdump('select * from AUSGANGSRECHNUNG where KUNDE_R=' + _PERSON_R_FROM, RollBackDump);
      e_x_sql('delete from AUSGANGSRECHNUNG where KUNDE_R=' + _PERSON_R_FROM);

      // Dokumentverzeichnis archivieren
      ArchivePath := cPersonPath(PERSON_R_FROM);
      if DirExists(ArchivePath) then
      begin
        ArchiveOptions := TStringList.create;
        ArchiveOptions.values[czip_set_RootPath] := ArchivePath;

        zip(nil,
          { } DiagnosePath + cROLL_BACK + RollBackDomain + cZIPExtension,
          { } ArchiveOptions);
        ArchiveOptions.free;

        DirDelete(ArchivePath);
      end
      else
      begin
        RollBackDump.add('-- empty ''' + ArchivePath + '''');
      end;

    end
    else
    begin

      // erst alle Belege verschieben
      lBELEGE := e_r_sqlm('select RID from BELEG where PERSON_R=' + _PERSON_R_FROM);

      // Einzelne Beleg umkopieren
      for n := 0 to pred(lBELEGE.count) do
        e_w_MoveBeleg(lBELEGE[n], PERSON_R_TO);

      lBELEGE.free;

      // Alle Dokumente umkopieren!
      FileMove(
        { } cPersonPath(PERSON_R_FROM) + '*',
        { } cPersonPath(PERSON_R_TO));

    end;

    //
    References := TStringList.create;
    References.add('ABLAGE.MONTEUR1_R');
    References.add('ABLAGE.MONTEUR2_R');
    References.add('AUFTRAG.MONTEUR1_R');
    References.add('AUFTRAG.MONTEUR2_R');
    References.add('ARBEITSZEIT.MONTEUR_R');
    References.add('ARTIKEL.VERLAG_R');
    References.add('AUSGANGSRECHNUNG.KUNDE_R');
    References.add('AUSGANGSRECHNUNG.MANDANT_R');
    References.add('BAUSTELLE.AUFTRAGGEBER_R');
    References.add('BBELEG.LIEFERANSCHRIFT_R');
    References.add('BBELEG.PERSON_R');
    References.add('BELEG.LIEFERANSCHRIFT_R');
    References.add('BELEG.PERSON_R');
    References.add('BELEG.RECHNUNGSANSCHRIFT_R');
    References.add('BPOSTEN.LIEFERANT_R');
    References.add('BPOSTEN.VERLAG_R');
    References.add('BREGEL.IN_VERLAG_R');
    References.add('BREGEL.OUT_PERSON_R');
    References.add('BUCH.PERSON_R');
    References.add('BUCH.MANDANT_R');
    References.add('BUGET.PERSON_R');
    References.add('BUGET.MONTEUR_R');
    References.add('DOKUMENT.PERSON_R');
    References.add('EMAIL.PERSON_R');
    References.add('EREIGNIS.PERSON_R');
    References.add('LIEFERANT.BOSS_R');
    References.add('MAHNLAUF.PERSON_R');
    References.add('MUSIKER.PERSON_R');
    References.add('POSTEN.LIEFERANSCHRIFT_R');
    References.add('POSTEN.RECHNUNGANSCHRIFT_R');
    References.add('POSTEN.VERLAG_R');
    References.add('GELIEFERT.LIEFERANSCHRIFT_R');
    References.add('GELIEFERT.RECHNUNGANSCHRIFT_R');
    References.add('GELIEFERT.VERLAG_R');
    References.add('PRORATA.PERSON_R');
    References.add('QAUFTRAG.ANFRAGER_R');
    References.add('QAUFTRAG.AUFTRAGGEBER_R');
    References.add('RABATT.PERSON_R');
    References.add('TICKET.PERSON_R');
    References.add('TICKET_ZIEL.TICKET_PERSON_R');
    References.add('TIER.PERSON_R');
    References.add('VERLAG.PERSON_R');
    References.add('VERSAND.LIEFERANSCHRIFT_R');
    References.add('VERSAND.RECHNUNGSANSCHRIFT_R');
    References.add('VERSENDER.PERSON_R');
    References.add('WARENKORB.PERSON_R');
    References.add('WEBPROFIL.PERSON_R');
    References.add('BELEG.ZAHLUNGSPFLICHTIGER_R');
    References.add('BUCH.ZAHLUNGSPFLICHTIGER_R');
    References.add('AUSGANGSRECHNUNG.ZAHLUNGSPFLICHTIGER_R');
    References.add('MITGLIEDERLISTE.PERSON_R');
    References.add('VERTRAG.PERSON_R');
    References.add('EMAIL.INITIATOR_R');
    References.add('WEBSHOPCLICKS.PERSON_R');

    //
    if DeleteMode then
    begin
      fbdump(PERSON_R_FROM, References, RollBackDump);
      e_x_dereference(References, _PERSON_R_FROM, 'NULL');
      fbdump('select * from PERSON where RID=' + _PERSON_R_FROM, RollBackDump);
      AppendStringsToFile(RollBackDump, DiagnosePath + cROLL_BACK + RollBackDomain + cSQLExtension);
    end
    else
    begin
      e_x_dereference(References, _PERSON_R_FROM, _PERSON_R_TO);
    end;

    References.free;

  except
    on E: exception do
    begin
      AppendStringsToFile(
        {} 'e_w_JoinPerson(' + inttostr(PERSON_R_FROM) + ',' + inttostr(PERSON_R_TO) + '): ' +
        {} E.Message,
        {} ErrorFName('BELEG'),
        {} Uhr12);
    end;
  end;
  RollBackDump.free;
end;

procedure e_w_preDeletePerson(PERSON_R: integer);
begin
  e_w_JoinPerson(PERSON_R, cRID_Null);
end;

function e_r_PostenUmsatz(POSTEN_R: integer): double;
var
  cPOSTEN: TdboCursor;
var
  _Anz, _AnzAuftrag, _AnzGeliefert, _AnzStorniert, _AnzAgent: integer;
var
  _Rabatt, _EinzelPreis, _MwStSatz: double;
begin
  result := cGeld_Zero;
  cPOSTEN := nCursor;
  try
    repeat
      with cPOSTEN do
      begin
        sql.add('select * from POSTEN where RID=' + inttostr(POSTEN_R));
        ApiFirst;
        if eof then
          break;

        e_r_PostenInfo(cPOSTEN, true, true, _Anz, _AnzAuftrag, _AnzGeliefert, _AnzStorniert, _AnzAgent, _Rabatt,
          _EinzelPreis, _MwStSatz);

        result := e_r_PostenPreis(_EinzelPreis, _Anz, FieldByName('EINHEIT_R').AsInteger);
        result := e_c_Rabatt(result, _Rabatt);

      end;
    until yet;
  finally

  end;
  cPOSTEN.free;
end;

// liefert den Netto-Umsatz dieser Position aus GELIEFERT
function e_r_GeliefertUmsatz(GELIEFERT_R: integer): double;
var
  cGELIEFERT: TdboCursor;
var
  _Anz, _AnzAuftrag, _AnzGeliefert, _AnzStorniert, _AnzAgent: integer;
var
  _Rabatt, _EinzelPreis, _MwStSatz: double;
begin
  result := cGeld_Zero;
  cGELIEFERT := nCursor;
  try
    repeat
      with cGELIEFERT do
      begin
        sql.add('select * from GELIEFERT where RID=' + inttostr(GELIEFERT_R));
        ApiFirst;
        if eof then
          break;

        e_r_PostenInfo(
         {} cGELIEFERT,
         {} false,
         {} true,
         {} _Anz,
         {} _AnzAuftrag,
         {} _AnzGeliefert,
         {} _AnzStorniert,
         {} _AnzAgent,
         {} _Rabatt,
         {} _EinzelPreis,
         {} _MwStSatz);

        result := e_r_PostenPreis(_EinzelPreis, _Anz, FieldByName('EINHEIT_R').AsInteger);
        result := e_c_Rabatt(result, _Rabatt);

      end;
    until yet;
  finally

  end;
  cGELIEFERT.free;
end;

function t_r_Beleg(BELEG_R: integer): boolean;
var
  Zahlungen, Zahlungen_laut_Beleg: double;
  Forderungen, Forderungen_laut_Beleg: double;
begin
  // Anzahlungen bestimmen!
  Zahlungen := -e_r_sqld(
   {} 'select SUM(BETRAG) from AUSGANGSRECHNUNG where ' +
   {} ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
   {} ' (BETRAG<0)');

  // Forderungen bestimmen!
  Forderungen := e_r_sqld(
   {} 'select SUM(BETRAG) from AUSGANGSRECHNUNG where' +
   {} ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
   {} ' (BETRAG>0)');

  Zahlungen_laut_Beleg := e_r_sqld(
   {} 'select DAVON_BEZAHLT from BELEG where' +
   {} ' (BELEG_R=' + inttostr(BELEG_R) + ')');

  Forderungen_laut_Beleg := e_r_sqld(
   {} 'select RECHNUNGS_BETRAG from BELEG where ' +
   {} ' (BELEG_R=' + inttostr(BELEG_R) + ')');

  result := isZeroMoney(Zahlungen - Zahlungen_laut_Beleg) and isZeroMoney(Forderungen - Forderungen_laut_Beleg);
end;


// Posten-Felder, die bei einem Merge / Copy NICHT kopiert werden sollen

var
 _e_r_Posten_RedList : TStringList = nil;

function e_r_Posten_RedList : TStringList;
begin
 if not(assigned(_e_r_Posten_RedList)) then
 begin
  _e_r_Posten_RedList := TStringList.Create;
  with _e_r_Posten_RedList do
  begin
   add('RID');
   add('POSNO');
   add('BELEG_R');

   add('MENGE_RECHNUNG');
   add('MENGE_AUSFALL');
   add('MENGE_GELIEFERT');
   add('MENGE_AGENT');

   add('AUSFUEHRUNG'); // <- von
   add('ZUSAGE'); // <- bis
   //add('INFO'); // <- VERTRAG_R (aus VertragsReferenz=) + "." + EREIGNIS_R

  end;
 end;
 result := _e_r_Posten_RedList;
end;

// kopiere alle Posten des Quell-Beleges in den bestehenden Beleg hinzu

procedure e_w_MergeBeleg(BELEG_R_FROM, BELEG_R_TO: integer; sTexte: TStringList = nil);
var
  cQUELL_BELEG: TdboCursor;
  cQUELL_POSTEN: TdboCursor;
  cZIEL_POSTEN: TdboCursor;

  qZIEL_POSTEN: TdboQuery;
  qZIEL_BELEG: TdboQuery;
  InternInfosQuelle: TStringList;
  InternInfosZiel: TStringList;
  DBFieldName: string;
  n: integer;
  InternInfosUpdateZwang: boolean;
  RECHNUNGSANSCHRIFT_R, LIEFERANSCHRIFT_R: integer;
  PostenTextZiel: TStringList;
  ARTIKEL, INFO: string;
  BTYP: integer;
  MONAT : string;
begin
  InternInfosQuelle := TStringList.create;
  PostenTextZiel := TStringList.create;
  cQUELL_POSTEN := nCursor;
  cQUELL_BELEG := nCursor;
  cZIEL_POSTEN := nCursor;
  qZIEL_POSTEN := nQuery;
  qZIEL_BELEG := nQuery;

  // Ersetzungs-Vorgang
  with cQUELL_BELEG do
  begin
    sql.add('select');
    sql.add(' RECHNUNGSANSCHRIFT_R,');
    sql.add(' LIEFERANSCHRIFT_R,');
    sql.add(' INTERN_INFO');
    sql.add('from BELEG');
    sql.add(' where RID=' + inttostr(BELEG_R_FROM));
    ApiFirst;
    e_r_sqlt(FieldByName('INTERN_INFO'), InternInfosQuelle);
    RECHNUNGSANSCHRIFT_R := FieldByName('RECHNUNGSANSCHRIFT_R').AsInteger;
    LIEFERANSCHRIFT_R := FieldByName('LIEFERANSCHRIFT_R').AsInteger;
  end;

  InternInfosZiel := e_r_sqlt('select INTERN_INFO from BELEG where RID=' + inttostr(BELEG_R_TO));

  // Intern-Infos abgleichen
  InternInfosUpdateZwang := false;
  for n := 0 to pred(InternInfosQuelle.count) do
    if (pos('=', InternInfosQuelle[n]) > 0) then
      if InternInfosZiel.values[nextp(InternInfosQuelle[n], '=', 0)] <> nextp(InternInfosQuelle[n], '=', 1) then
      begin
        InternInfosZiel.values[nextp(InternInfosQuelle[n], '=', 0)] := nextp(InternInfosQuelle[n], '=', 1);
        InternInfosUpdateZwang := true;
      end;

  with qZIEL_BELEG do
  begin
    sql.add('select');
    sql.add(' INTERN_INFO,');
    sql.add(' RECHNUNGSANSCHRIFT_R,');
    sql.add(' LIEFERANSCHRIFT_R,');
    sql.add(' BTYP');
    sql.add('from BELEG');
    sql.add('where (RID=' + inttostr(BELEG_R_TO) + ')');
    for_update(sql);
    Open;
    First;
    BTYP := StrToIntDef(FieldByName('BTYP').AsString, 0);

    if (BTYP > 0) then
    begin
      edit;
      FieldByName('BTYP').AsString := inttostr(BTYP - 1);
      Post;
    end;

    if InternInfosUpdateZwang then
    begin
      edit;
      FieldByName('INTERN_INFO').assign(InternInfosZiel);
      if (RECHNUNGSANSCHRIFT_R >= cRID_FirstValid) then
        FieldByName('RECHNUNGSANSCHRIFT_R').AsInteger := RECHNUNGSANSCHRIFT_R;
      if (LIEFERANSCHRIFT_R >= cRID_FirstValid) then
        FieldByName('LIEFERANSCHRIFT_R').AsInteger := LIEFERANSCHRIFT_R;
      Post;
    end;

  end;

  if assigned(sTexte) then
    InternInfosQuelle.addstrings(sTexte);

  // 'von' kann ein Filter für einzelne Vertragsposten sein
  MONAT := InternInfosQuelle.values['von'];
  if (MONAT<>'') then
   MONAT := SQLstring(MONAT);

  with cZIEL_POSTEN do
  begin
    sql.add('select * from POSTEN where');
    sql.add(' (BELEG_R=' + inttostr(BELEG_R_TO) + ') and');
    sql.add(' ((PREIS is null) or (PREIS=0.0))');
    sql.add('order by POSNO,RID');

    //
    ApiFirst;
    while not(eof) do
    begin
      PostenTextZiel.add(
        { VertragsID } FieldByName('INFO').AsString +
        { Sichtbarer Text } FieldByName('ARTIKEL').AsString);
      ApiNext;
    end;
  end;

  with qZIEL_POSTEN do
  begin
    sql.add('select * from POSTEN ' + for_update);
    Open;
  end;

  with cQUELL_POSTEN do
  begin
    sql.add('select * from POSTEN where');
    sql.Add(' (BELEG_R=' + inttostr(BELEG_R_FROM) + ')' );

    // "Alles" kopieren, sobald "Vollständig" gesetzt ist.
    if (InternInfosQuelle.values['Vollständig'] <> cIni_Activate) then
     sql.add(' and (PREIS is not null)');

    if (MONAT<>'') then
    begin
      sql.Add(' and ((' + MONAT + ' >= AUSFUEHRUNG) or (AUSFUEHRUNG is null))');
      sql.Add(' and ((ZUSAGE >= ' + MONAT + ') or (ZUSAGE is null))');
    end;
    sql.Add('order by');
    sql.Add(' POSNO,RID');

    ApiFirst;
    while not(eof) do
    begin
      with qZIEL_POSTEN do
      begin
        Insert;
        FieldByName('RID').AsInteger := 0;
        FieldByName('BELEG_R').AsInteger := BELEG_R_TO;
        ARTIKEL := '';
        INFO :=
        { } InternInfosQuelle.values['VertragsReferenz'] + '.' +
        { } inttostr(VertragBuchen_EREIGNIS_R);
        for n := 0 to pred(cQUELL_POSTEN.FieldCount) do
        begin
          DBFieldName := cQUELL_POSTEN.Fields[n].FieldName;
          if (e_r_Posten_RedList.IndexOf(DBFieldName) <> -1) then
           continue;
          if (DBFieldName='INFO') then
           continue;
          if (DBFieldName = 'ARTIKEL') and not(cQUELL_POSTEN.Fields[n].IsNull) then
          begin
            ARTIKEL := cQUELL_POSTEN.Fields[n].AsString;
            ersetze(InternInfosQuelle, ARTIKEL);
            FieldByName(DBFieldName).AsString := ARTIKEL;
          end else
          begin
            FieldByName(DBFieldName).assign(cQUELL_POSTEN.Fields[n]);
          end;
        end;

        if not(FieldByName('PREIS').IsNull) then
        begin
          FieldByName('AUSFUEHRUNG').AsDateTime := long2datetime(date2Long(InternInfosQuelle.values['von']));
          FieldByName('ZUSAGE').AsDateTime := long2datetime(date2Long(InternInfosQuelle.values['bis']));
        end;

        // Info wird immer geschrieben
        FieldByName('INFO').AsString := INFO;

        repeat
          // Text-Dubletten Erkennung
          // nur im selben Abrechnungs-Kontext wirksam
          if (ARTIKEL <> '') then
            if isZeroMoney(FieldByName('PREIS').AsFloat) then
              if PostenTextZiel.IndexOf(INFO + ARTIKEL) <> -1 then
              begin
                cancel;
                break;
              end;

          // Speichern!
          Post;
        until yet;

      end;
      ApiNext;
    end;
    Close;
  end;
  cQUELL_POSTEN.free;
  cQUELL_BELEG.free;
  cZIEL_POSTEN.free;
  qZIEL_POSTEN.free;
  qZIEL_BELEG.free;
  InternInfosQuelle.free;
  InternInfosZiel.free;
  PostenTextZiel.free;
end;

function e_w_CopyBeleg(BELEG_R_FROM, PERSON_R_TO: integer; sTexte: TStringList = nil): integer;
var
  cQUELL_BELEG: TdboCursor;
  cQUELL_POSTEN: TdboCursor;
  qZIEL_BELEG: TdboQuery;
  qZIEL_POSTEN: TdboQuery;
  Blocklist: TStringList;
  BelegOptions: TStringList;
  n: integer;
  BELEG_R: integer;
  DBFieldName: string;
  CellStr: string;
  BTYP: integer;
  MONAT: string;
begin
  result := -1;
  BELEG_R := -1;

  //
  cQUELL_BELEG := nCursor;
  cQUELL_POSTEN := nCursor;
  qZIEL_BELEG := nQuery;
  qZIEL_POSTEN := nQuery;
  Blocklist := TStringList.create;
  BelegOptions := TStringList.create;

  repeat

    // prüfe existenz des Quell-Beleges
    with cQUELL_BELEG do
    begin
      sql.add('select * from BELEG where RID=' + inttostr(BELEG_R_FROM));
      ApiFirst;
      if eof then
        raise exception.create('Quell-Beleg ' + inttostr(BELEG_R_FROM) + ' nicht gefunden');
      e_r_sqlt(FieldByName('INTERN_INFO'), BelegOptions);
      BTYP := StrToIntDef(FieldByName('BTYP').AsString, 0);
    end;

    // aktuelle Settings und Optionen mit in den Beleg nehmen
    if assigned(sTexte) then
      for n := 0 to pred(sTexte.count) do
        if (pos('=', sTexte[n]) > 0) then
          BelegOptions.values[nextp(sTexte[n], '=', 0)] := nextp(sTexte[n], '=', 1);

    // 'von' kann ein Filter für einzelne Vertragsposten sein
    MONAT := BelegOptions.values['von'];
    if (MONAT<>'') then
     MONAT := SQLstring(MONAT);

    // prüfe Existenz der Ziel-Person
    if e_r_sql('select count(RID) from PERSON where RID=' + inttostr(PERSON_R_TO)) <> 1 then
      break;

    // lege neuen Beleg an
    BELEG_R := e_w_BelegNeu(PERSON_R_TO);

    // kopiere alle entsprechenden Kopf-Felder, ausser folgende System-Felder ...
    Blocklist.add('RID');
    Blocklist.add('TEILLIEFERUNG');
    Blocklist.add('GENERATION');
    Blocklist.add('NUMMER');
    Blocklist.add('PERSON_R');
    Blocklist.add('RECHNUNGSANSCHRIFT_R');
    Blocklist.add('LIEFERANSCHRIFT_R');
    Blocklist.add('INTERN_INFO');
    Blocklist.add('ANLAGE');
    Blocklist.add('ABSCHLUSS');
    Blocklist.add('RECHNUNG');
    Blocklist.add('FAELLIG');
    Blocklist.add('MAHNUNG1');
    Blocklist.add('MAHNUNG2');
    Blocklist.add('MAHNUNG3');
    Blocklist.add('MAHNBESCHEID');
    Blocklist.add('MAHNSTUFE');
    Blocklist.add('RECHNUNGS_BETRAG');
    Blocklist.add('DAVON_BEZAHLT');
    Blocklist.add('VERSAND_STATUS');
    Blocklist.add('MENGE_RECHNUNG');
    Blocklist.add('MENGE_AUFTRAG');
    Blocklist.add('MENGE_GELIEFERT');
    Blocklist.add('MENGE_AGENT');
    Blocklist.add('LAGER_R');
    Blocklist.add('DRUCK');
    Blocklist.add('MAHNUNG');
    Blocklist.add('VOLUMEN');
    Blocklist.add('BSTATUS');
    with qZIEL_BELEG do
    begin
      sql.add('select * from BELEG where RID=' + inttostr(BELEG_R) + ' ' + for_update);
      Open;
      First;
      edit;
      for n := 0 to pred(FieldCount) do
        if (Blocklist.IndexOf(Fields[n].FieldName) = -1) then
          Fields[n].assign(cQUELL_BELEG.FieldByName(Fields[n].FieldName));
      FieldByName('INTERN_INFO').assign(BelegOptions);
      if (BTYP > 0) then
        FieldByName('BTYP').AsString := inttostr(BTYP - 1);
      Post;
    end;

    // kopiere alle Posten des Quell-Beleges in den neuen Beleg
    with qZIEL_POSTEN do
    begin
      sql.add('select * from POSTEN ' + for_update);
    end;

    with cQUELL_POSTEN do
    begin
      sql.add('select * from POSTEN where');
      sql.Add(' (BELEG_R=' + inttostr(BELEG_R_FROM) + ')' );
      if (MONAT<>'') then
      begin
        sql.Add(' and ((' + MONAT + ' >= AUSFUEHRUNG) or (AUSFUEHRUNG is null))');
        sql.Add(' and ((ZUSAGE >= ' + MONAT + ') or (ZUSAGE is null))');
      end;
      sql.Add('order by');
      sql.Add(' POSNO,RID');
      ApiFirst;
      while not(eof) do
      begin
        with qZIEL_POSTEN do
        begin
          Insert;
          FieldByName('RID').AsInteger := 0;
          FieldByName('BELEG_R').AsInteger := BELEG_R;
          if assigned(sTexte) then
            FieldByName('INFO').AsString :=
            { } sTexte.values['VertragsReferenz'] + '.' +
            { } inttostr(VertragBuchen_EREIGNIS_R);
          for n := 0 to pred(cQUELL_POSTEN.FieldCount) do
          begin
            DBFieldName := cQUELL_POSTEN.Fields[n].FieldName;
            if (e_r_Posten_RedList.IndexOf(DBFieldName) <> -1) then
              continue;
            if assigned(sTexte) then
             if (DBFieldName='INFO') then
              continue;
            if assigned(sTexte) and (DBFieldName = 'ARTIKEL') and not(cQUELL_POSTEN.Fields[n].IsNull) then
            begin
              CellStr := cQUELL_POSTEN.Fields[n].AsString;
              ersetze(sTexte, CellStr);
              FieldByName(DBFieldName).AsString := CellStr;
            end
            else
            begin
              FieldByName(DBFieldName).assign(cQUELL_POSTEN.Fields[n]);
            end;
          end;
          if assigned(sTexte) then
            if not(FieldByName('PREIS').IsNull) then
              FieldByName('AUSFUEHRUNG').AsDateTime := long2datetime(date2Long(sTexte.values['von']));
          Post;
        end;
        ApiNext;
      end;
      Close;
    end;
    result := BELEG_R;

  until yet;

  //
  cQUELL_BELEG.free;
  cQUELL_POSTEN.free;
  qZIEL_BELEG.free;
  qZIEL_POSTEN.free;
  Blocklist.free;

  if (BelegOptions.values['verbuchen'] = cIni_Activate) then
    if (e_w_BelegBuchen(BELEG_R, BelegOptions.values['label'] = cIni_Activate)='') then
     result := -1;

  BelegOptions.free;

end;

function e_r_ZahlungBezeichnung(PERSON_R: integer): string;
begin
  result := e_r_sqls('select BEZEICHNUNG from ZAHLUNGTYP where RID=' + inttostr(e_r_ZahlungRID(PERSON_R)));
end;

function e_r_ZahlungRID(PERSON_R: integer): integer;
begin
  result := e_r_sql('select ZAHLUNGTYP_R from PERSON where RID=' + inttostr(PERSON_R));
  if (result < cRID_FirstValid) then
    result := e_r_sql('select RID from ZAHLUNGTYP where STANDARD=''' + cC_True + '''');
end;

function e_r_ZahlungFrist(PERSON_R: integer): integer;
var
  ZAHLUNG_R: integer;
begin
  result := cStandard_ZahlungFrist;
  ZAHLUNG_R := e_r_ZahlungRID(PERSON_R);
  repeat
    if (ZAHLUNG_R < cRID_FirstValid) then
      break;
    result := e_r_sql(
      { } 'select coalesce(FAELLIG,' + inttostr(cStandard_ZahlungFrist) + ') ' +
      { } 'from ZAHLUNGTYP where' +
      { } ' RID=' + inttostr(ZAHLUNG_R));
  until yet;
end;

function e_r_ZahlungText(ZAHLUNGTYP_R: integer; PERSON_R: integer = 0; MoreInfo: TStringList = nil): string;

var
  TheText: TStringList;

  procedure pStrReplace(fromS, toS: string);
  var
    n: integer;
    s: string;
  begin
    for n := 0 to pred(TheText.count) do
      if pos('~', TheText[n]) > 0 then
      begin
        s := TheText[n];
        ersetze('~' + fromS + '~', toS, s);
        TheText[n] := s;
      end;
  end;

var
  cZAHLUNG: TdboCursor;
  cPERSON: TdboCursor;
  FAELLIGTAGE: integer;
  FAELLIGDATUM: TAnfixDate;
  FOLGEMONAT: integer;
  FOLGEJAHR: integer;
  SKONTOTAGE: integer;
  _MoreInfo: TStringList;
  VorlagePrefix: string;

begin
  if assigned(MoreInfo) then
  begin
    VorlagePrefix := MoreInfo.values['VorlagePraefix'];
  end
  else
  begin
    VorlagePrefix := '';
  end;

  // Personen-Zahlungs-daten nachladen
  _MoreInfo := TStringList.create;
  cPERSON := nCursor;
  with cPERSON do
  begin
    sql.add('select ZAHLUNGTYP_R,Z_ELV_BANK_NAME,');
    sql.add(' Z_ELV_KONTO,Z_ELV_BLZ');
    sql.add('from PERSON where');
    sql.add('RID=' + inttostr(PERSON_R));
    ApiFirst;
    if (ZAHLUNGTYP_R < cRID_FirstValid) then
      ZAHLUNGTYP_R := FieldByName('ZAHLUNGTYP_R').AsInteger;
    _MoreInfo.add('ZahlungBLZ=' + FieldByName('Z_ELV_BLZ').AsString);
    _MoreInfo.add('ZahlungKonto=' + FieldByName('Z_ELV_KONTO').AsString);
    _MoreInfo.add('ZahlungBank=' + FieldByName('Z_ELV_BANK_NAME').AsString);
  end;

  // Den Zahlungstyp bestimmen

  repeat

    // bereits durch die Person fest gesetzt?
    if (ZAHLUNGTYP_R >= cRID_FirstValid) then
      break;

    // Wahl durch den Vorlage-Prefix des Beleges?
    if (VorlagePrefix <> '') then
    begin
      ZAHLUNGTYP_R := e_r_sql('select RID from ZAHLUNGTYP where HTML_VORLAGE=''' + VorlagePrefix + '''');
      if (ZAHLUNGTYP_R >= cRID_FirstValid) then
        break;
    end;

    // Einfach den Standard wählen
    ZAHLUNGTYP_R := e_r_sql('select RID from ZAHLUNGTYP where STANDARD=''' + cC_True + '''');
    // if (ZAHLUNGTYP_R < cRID_FirstValid) then
    // WARNUNG: Keine Zahlungsart definiert!

  until yet;

  // Zahlungsdaten laden
  TheText := TStringList.create;
  cZAHLUNG := nCursor;
  with cZAHLUNG do
  begin
    sql.add('select BEZEICHNUNG,FAELLIG,AUTOZAHLUNG,HTML_VORLAGE,BELEG_INFO,');
    sql.add('SKONTO,SKONTO_FAELLIG from ZAHLUNGTYP where RID=' + inttostr(ZAHLUNGTYP_R));
    ApiFirst;

    e_r_sqlt(FieldByName('BELEG_INFO'), TheText);

    // Fälligkeit aus der Zahlungsart
    if FieldByName('FAELLIG').IsNull then
      FAELLIGTAGE := cStandard_ZahlungFrist
    else
      FAELLIGTAGE := FieldByName('FAELLIG').AsInteger;
    FAELLIGDATUM := DatePlus(DateGet, FAELLIGTAGE);

    FOLGEMONAT := extractMonth(FAELLIGDATUM) + 1;
    FOLGEJAHR := extractYear(FAELLIGDATUM);
    if (FOLGEMONAT = 13) then
    begin
      FOLGEMONAT := 1;
      inc(FOLGEJAHR);
    end;

    _MoreInfo.add('ZAHLUNGTYP_R=' + inttostr(ZAHLUNGTYP_R));
    _MoreInfo.add('BEZEICHNUNG=' + FieldByName('BEZEICHNUNG').AsString);
    _MoreInfo.add('FAELLIGTAGE=' + inttostr(FAELLIGTAGE));
    _MoreInfo.add('FAELLIGDATUM=' + long2dateLocalized(FAELLIGDATUM));
    _MoreInfo.add('FOLGEMONAT=' + inttostrN(FOLGEMONAT, 2));
    _MoreInfo.add('FOLGEJAHR=' + inttostrN(FOLGEJAHR, 4));

    pStrReplace('FälligTage', _MoreInfo.values['FAELLIGTAGE']);
    pStrReplace('FälligDatum', _MoreInfo.values['FAELLIGDATUM']);
    pStrReplace('FolgeMonat', _MoreInfo.values['FOLGEMONAT']);
    pStrReplace('FolgeJahr', _MoreInfo.values['FOLGEJAHR']);

    pStrReplace('ZahlungBLZ', _MoreInfo.values['ZahlungBLZ']);
    pStrReplace('ZahlungKonto', _MoreInfo.values['ZahlungKonto']);
    pStrReplace('ZahlungBank', _MoreInfo.values['ZahlungBank']);

    if not(FieldByName('SKONTO_FAELLIG').IsNull) then
    begin
      SKONTOTAGE := FieldByName('SKONTO_FAELLIG').AsInteger;
      _MoreInfo.add('SKONTOTAGE=' + inttostr(SKONTOTAGE));
      _MoreInfo.add('SKONTODATUM=' + long2dateLocalized(DatePlus(DateGet, SKONTOTAGE)));
      _MoreInfo.add(format('SKONTO=%.1f', [FieldByName('SKONTO').AsFloat]));

      pStrReplace('SkontoTage', _MoreInfo.values['SKONTOTAGE']);
      pStrReplace('SkontoDatum', _MoreInfo.values['SKONTODATUM']);
      pStrReplace('Skonto', _MoreInfo.values['SKONTO']);
    end;

  end;

  //
  if assigned(MoreInfo) then
    MoreInfo.addstrings(_MoreInfo);

  result := HugeSingleLine(TheText, '');

  cZAHLUNG.free;
  cPERSON.free;
  TheText.free;
  _MoreInfo.free;
end;

function e_w_BelegBuchen(BELEG_R: integer; LabelDatensatz: boolean = false): string;
const
  cLimiterType2 = '|';
var
  OutPath: string;
  OutFName: string;
  PaketS: TStringList;
  WerteS: TStringList;
  Wert: string;
  ParameterS: TStringList;
  PersonenDatenS: TStringList;
  OutLineS: string;
  LIEFERANSCHRIFT_R: integer;
  Name1_2: TStringList;
  _id: string;
  gewicht: integer;
  n, k: integer;
  RechnungsBetrag: double;
  RechnungsGewicht: integer;
  RechnungsBudgetVolumen: integer;
  TITEL, _titel: string;

  qBELEG: TdboQuery;
  qPosten: TdboQuery;
  qWARENBEWEGUNG: TdboQuery;
  cVERSAND: TdboCursor;
  cVERSENDER: TdboCursor;
  cPERSON: TdboCursor;
  cANSCHRIFT: TdboCursor;
  BerechneteInfos: TStringList;
  AusgabeBelege: TStringList;

  //
  Menge_Lieferung: integer;
  Menge_Rechnung: integer;
  Menge_AuftragVorLieferung: integer;
  Menge_AuftragNachLieferung: integer;
  TEILLIEFERUNG: integer;
  INTERN_INFO: TStringList;
  GENERATION_POSTFIX: string;

  function NoSemi(s: string): string;
  begin
    result := s;
    ersetze(';', ',', result);
  end;

  function NoKomma(s: string): string;
  begin
    result := s;
    ersetze(',', '', result);
  end;

begin
  result := '';
  INTERN_INFO := TStringList.create;
  AusgabeBelege := nil;
  try

    // Berechnete Infos
    BerechneteInfos := e_w_BerechneBeleg(BELEG_R, false);
    RechnungsBetrag := StrtoDouble(BerechneteInfos.values['RECHNUNGSBETRAG']);
    RechnungsGewicht := StrtoInt(BerechneteInfos.values['LIEFERGEWICHT']);
    RechnungsBudgetVolumen := StrtoInt(BerechneteInfos.values['BUDGETVOLUMEN']);
    BerechneteInfos.free;

    // Rechnungsnummer setzen
    if (iRechnungsNummerVergabeMoment = ernvm_Verbuchen) then
      if isSomeMoney(RechnungsBetrag) then
        e_w_RechnungsNummer(BELEG_R);

    // aktuellen Beleg ausgeben
    AusgabeBelege := e_w_AusgabeBeleg(BELEG_R, false, false);
    e_w_DruckBeleg(BELEG_R);

    //
    cVERSAND := nCursor;
    cVERSENDER := nCursor;
    cPERSON := nCursor;
    cANSCHRIFT := nCursor;
    qBELEG := nQuery;
    with qBELEG do
    begin
      sql.add('select * from BELEG where RID=' + inttostr(BELEG_R));
      for_update(sql);
      Open;
      First;
      Menge_AuftragVorLieferung := FieldByName('MENGE_AUFTRAG').AsInteger;
      TEILLIEFERUNG := FieldByName('TEILLIEFERUNG').AsInteger;
      GENERATION_POSTFIX := '-' + inttostrN(FieldByName('GENERATION').AsInteger, 2);
      e_r_sqlt(FieldByName('INTERN_INFO'), INTERN_INFO);
    end;

    // Ausgabebeleg dauerhaft kopieren
    OutPath := cPersonPath(qBELEG.FieldByName('PERSON_R').AsInteger);
    OutFName := inttostrN(BELEG_R, 10) + '-' + inttostrN(TEILLIEFERUNG, 2);

    // Hauptbeleg Ins Kundenverzeichnis
    CheckCreateDir(OutPath);
    FileCopy(AusgabeBelege[0], OutPath + OutFName + chtmlextension);

    // mehrere Ausgabebelege / Ausprägungsarten "#M" / "#W"
    for n := 1 to pred(AusgabeBelege.count) do
      FileCopy(
       {} AusgabeBelege[n],
       {} OutPath + OutFName +
       {} '#' +
       {} ExtractSegmentBetween(
       {}   ExtractFileName(AusgabeBelege[n]),'#', chtmlextension) +
       {} chtmlextension);

    // In das Druck-Spool-Verzeichnis
    if (INTERN_INFO.values['Druckauftrag'] = cIni_Activate) then
    begin
      CheckCreateOnce(MyProgramPath + cDruckauftragPath);
      FileCopy(AusgabeBelege[0], MyProgramPath + cDruckauftragPath + OutFName + chtmlextension);
    end;

    // Ins Rechnungskopie-Verzeichnis
    FileCopy(AusgabeBelege[0], MyProgramPath + cRechnungsKopiePath + OutFName + chtmlextension);
    result := OutPath + OutFName + chtmlextension;

    // Arbeitszeit.html in endgültigen Beleg verschieben!
    if (RechnungsBudgetVolumen <> 0) then
      if FileExists(OutPath + cHTML_ArbeitszeitFName) then
      begin
        // Alle angegeben Postionen der Arbeitszeit.html diesem Beleg zuordnen
        e_w_BudgetAbschreiben(BELEG_R, OutPath + cHTML_ArbeitszeitFName);
        FileMove(OutPath + cHTML_ArbeitszeitFName, OutPath + OutFName + '.' + cHTML_ArbeitszeitFName);
      end;

    // Sichern in GELIEFERT
    e_x_sql(
      { } 'insert into GELIEFERT ' +
      { } 'select * from POSTEN where ' +
      { } INTERN_INFO.values['FILTER' + GENERATION_POSTFIX] +
      { } ' (BELEG_R=' + inttostr(BELEG_R) + ') ' +
      { } 'order by POSNO,RID');

    // TEILLIEFERUNG wird in POSNO gespeichert
    // dadurch können die Teillieferungen klar getrennt werden
    e_x_sql(
     { } 'update GELIEFERT ' +
     { } 'set POSNO=' + inttostr(TEILLIEFERUNG) +
     { } ' where' + ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
     { } ' (POSNO is null)');

    // Für MP3 - Downloads nun die verfügbare Menge setzen
    if (iMusikDownloadsProArtikel > 0) then
      e_x_sql(
        { } 'update GELIEFERT set' +
        { } ' MENGE_AGENT=' + inttostr(iMusikDownloadsProArtikel) + ', ' +
        { } ' MENGE_GELIEFERT=null ' +
        { } 'where' +
        { } ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
        { } ' (POSNO=' + inttostr(TEILLIEFERUNG) + ') and' +
        { } ' (AUSGABEART_R=' + inttostr(cAusgabeArt_Aufnahme_MP3) + ')');

    // Liefern!
    qPosten := nQuery;
    with qPosten do
    begin
      sql.add('select * from POSTEN where');
      sql.add(INTERN_INFO.values['FILTER' + GENERATION_POSTFIX]);
      sql.add(' (BELEG_R=' + inttostr(BELEG_R) + ')');
      sql.add('order by POSNO,RID');
      for_update(sql);
      Open;
      First;
      Menge_Lieferung := 0;
      while not(eof) do
      begin
        Menge_Rechnung := FieldByName('MENGE_RECHNUNG').AsInteger;
        TITEL := FieldByName('ARTIKEL').AsString;
        _titel := TITEL;

        // ev. Platzhalter ersetzen
        ersetze(e_i_AusgabeBeleg, TITEL);

        if not(e_r_IsVersandKosten(FieldByName('ARTIKEL_R').AsInteger)) then
          inc(Menge_Lieferung, abs(Menge_Rechnung));

        if (Menge_Rechnung <> 0) then
        begin
          // Berechenbare Menge liefern
          edit;
          FieldByName('MENGE_GELIEFERT').AsInteger :=
            {} FieldByName('MENGE_GELIEFERT').AsInteger +
            {} Menge_Rechnung;
          FieldByName('MENGE_RECHNUNG').clear;
          FieldByName('ARTIKEL').AsString := TITEL;
          Post;
        end
        else
        begin
          if (_titel <> TITEL) then
          begin
            edit;
            FieldByName('ARTIKEL').AsString := TITEL;
            Post;
          end;
        end;
        Next;
      end;
    end;
    qPosten.free;

    e_w_BelegStatusBuchen(BELEG_R);

    Menge_AuftragNachLieferung := e_r_sql('select MENGE_AUFTRAG from BELEG where RID=' + inttostr(BELEG_R));

    // globale Warenbewegung schreiben!
    qWARENBEWEGUNG := nQuery;
    with qWARENBEWEGUNG do
    begin
{$IFNDEF fpc}
      ColumnAttributes.add('RID=NOTREQUIRED');
      ColumnAttributes.add('AUFTRITT=NOTREQUIRED');
{$ENDIF}
      sql.add('select * from WARENBEWEGUNG ' + for_update);
      Insert;
      FieldByName('BRISANZ').AsInteger := eT_MotivationKundenAuftrag;
      FieldByName('MENGE').AsInteger := Menge_Lieferung;
      FieldByName('MENGE_BISHER').AsInteger := Menge_AuftragNachLieferung;
      FieldByName('MENGE_NEU').AsInteger := Menge_AuftragVorLieferung;
      if (sBearbeiter > 0) then
        FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
      FieldByName('BELEG_R').AsInteger := BELEG_R;
      Post;
      Close;
    end;
    qWARENBEWEGUNG.free;

    // alle zugehörigen Warenbewegungen buchen
    e_x_sql('UPDATE WARENBEWEGUNG SET BEWEGT=''' + cC_True + ''' WHERE BELEG_R=' + inttostr(BELEG_R));

    // Buchungen im Beleg-Kopf
    repeat

      // Teillieferung mit "0" Artikeln!
      if (Menge_Lieferung = 0) then
        break;

      //
      with qBELEG do
      begin

        // Gewicht verbuchen, (und andere Details!)
        e_w_BelegVersand(BELEG_R, RechnungsBetrag, RechnungsGewicht);
        with cVERSAND do
        begin
          sql.add('select * from VERSAND where');
          sql.add(' (BELEG_R=' + inttostr(BELEG_R) + ') AND');
          sql.add(' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')');
          ApiFirst;
        end;

        if not(cVERSAND.FieldByName('VERSENDER_R').IsNull) then
        begin

          // a) Versender Infos bereitstellen
          with cVERSENDER do
          begin
            sql.add('select * from VERSENDER where RID=' + inttostr(cVERSAND.FieldByName('VERSENDER_R').AsInteger));
            ApiFirst;
          end;

          gewicht := cVERSAND.FieldByName('GEWICHT').AsInteger + cVERSAND.FieldByName('LEERGEWICHT').AsInteger;

          // a) richtige Person lokalisieren:
          LIEFERANSCHRIFT_R := 0;
          repeat

            if not(FieldByName('LIEFERANSCHRIFT_R').IsNull) then
            begin
              LIEFERANSCHRIFT_R := FieldByName('LIEFERANSCHRIFT_R').AsInteger;
              break;
            end;
            LIEFERANSCHRIFT_R := FieldByName('PERSON_R').AsInteger;

          until yet;

          // b) alle Personen-Daten laden:
          with cPERSON do
          begin
            sql.add('select * from PERSON where RID=' + inttostr(LIEFERANSCHRIFT_R));
            ApiFirst;
            if eof then;
          end;
          with cANSCHRIFT do
          begin
            sql.add('select * from ANSCHRIFT where RID=' + inttostr(cPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsInteger));
            ApiFirst;
            if eof then;
          end;

          Name1_2 := e_r_Person2Zeiler(LIEFERANSCHRIFT_R);

          PaketS := TStringList.create;
          ParameterS := TStringList.create;
          WerteS := TStringList.create;
          e_r_sqlt(cVERSENDER.FieldByName('INTERNINFO'), ParameterS);

          case cVERSENDER.FieldByName('EXPORTTYP').AsInteger of
            1:
              begin

                // German Parcel!
                PaketS.add(

                  // (1) Anrede
                  NoSemi(cPERSON.FieldByName('ANREDE').AsString) + ';' +

                  // (2) Name1
                  NoSemi(cPERSON.FieldByName('VORNAME').AsString + ' ' + cPERSON.FieldByName('NACHNAME')
                  .AsString) + ';' +

                  // (3) Name2
                  NoSemi(cANSCHRIFT.FieldByName('NAME1').AsString) + ';' +

                  // (4) Straße
                  NoSemi(cANSCHRIFT.FieldByName('STRASSE').AsString) + ';' +

                  // (5) Land
                  NoSemi(e_r_land(cANSCHRIFT)) + ';' +

                  // (6) PLZ
                  NoSemi(e_r_plz(cANSCHRIFT)) + ';' +

                  // (7) Ort
                  NoSemi(cANSCHRIFT.FieldByName('ORT').AsString) + ';' +

                  // (8) Gewicht
                  inttostr(gewicht div 100) + ';' +

                  // (9) ID
                  inttostr(FieldByName('RID').AsInteger) + inttostrN(TEILLIEFERUNG, 2) + ';' +

                  // (10) Infos an den Empfänger
                  cApplicationName);

                if LabelDatensatz then
                begin
                  AppendStringsToFile(PaketS, cVERSENDER.FieldByName('EXPORTPFAD').AsString);
                  AppendStringsToFile(PaketS, ExtractFilePath(cVERSENDER.FieldByName('EXPORTPFAD').AsString) +
                    'Historie.txt');
                end
                else
                begin
                  FreeAndNil(PaketS);
                  break;
                end;

              end;
            2:
              begin

                // "deutsche Post"
                _id := inttostr(FieldByName('RID').AsInteger) + inttostrN(TEILLIEFERUNG, 2);

                // feste Felder!
                OutLineS := { 01 } 'POOL_REFNR' + cLimiterType2 +
                { 02 } 'HEBU_EMPF_ANREDE' + cLimiterType2 +
                { 03 } 'POOL_EMPF_NAME1' + cLimiterType2 +
                { 04 } 'POOL_EMPF_NAME2' + cLimiterType2 +
                { 05 } 'POOL_EMPF_PLZ' + cLimiterType2 +
                { 06 } 'POOL_EMPF_ORT' + cLimiterType2 +
                { 07 } 'POOL_EMPF_STRASSE' + cLimiterType2 +
                { 08 } 'POOL_EMPF_LANDCODE' + cLimiterType2 +
                { 09 } 'POOL_GEWICHT' + cLimiterType2;

                // zusätzliche Felder
                PersonenDatenS := TStringList.create;
                for n := 0 to pred(ParameterS.count) do
                begin
                  k := pos('=', ParameterS[n]);
                  if k > 0 then
                  begin
                    OutLineS := OutLineS + cutblank(copy(ParameterS[n], 1, pred(k))) + cLimiterType2;
                    Wert := cutblank(copy(ParameterS[n], succ(k), MaxInt));

                    if (length(Wert) > 2) then
                      if (pos('~', Wert) = 1) then
                      begin
                        // Ein Wert aus der Datenbank
                        Wert := ExtractSegmentBetween(Wert, '~', '~');
                        if (PersonenDatenS.count = 0) then
                          e_r_Anschrift(LIEFERANSCHRIFT_R, PersonenDatenS);

                        //
                        Wert := PersonenDatenS.values[Wert];
                      end;

                    WerteS.add(Wert);
                  end;
                end;
                PersonenDatenS.free;

                // TitelZeile
                PaketS.add(OutLineS);
                try
                  if DirExists(cVERSENDER.FieldByName('EXPORTPFAD').AsString) then
                    PaketS.SaveToFile(cVERSENDER.FieldByName('EXPORTPFAD').AsString + 'DPKopf_.txt');
                except
                  on E: exception do
                  begin
                    AppendStringsToFile('e_w_BelegBuchen(' + inttostr(BELEG_R) + '): Deutsche Post : ' +
                      E.Message,
                      {} ErrorFName('BELEG'),
                      {} Uhr12);
                  end;

                end;

                PaketS.delete(0);

                // Datenzeile
                OutLineS :=

                // Belegnummer
                  _id + cLimiterType2 +

                // Anrede
                  NoKomma(cPERSON.FieldByName('ANREDE').AsString) + cLimiterType2 +

                // Name1
                  NoKomma(NoSemi(Name1_2[0])) + cLimiterType2 +

                // Name2
                  NoSemi(NoSemi(Name1_2[1])) + cLimiterType2 +

                // PLZ
                  NoSemi(e_r_plz(cANSCHRIFT)) + cLimiterType2 +

                // Ort
                  NoSemi(cANSCHRIFT.FieldByName('ORT').AsString) + cLimiterType2 +

                // Straße
                  NoSemi(cANSCHRIFT.FieldByName('STRASSE').AsString) + cLimiterType2 +

                // Land
                  NoSemi(e_r_Localize2(cANSCHRIFT.FieldByName('LAND_R').AsInteger, iHeimatLand)) + cLimiterType2 +

                // Gewicht
                  format('%.3f', [gewicht / 1000.0]) + cLimiterType2;

                // weitere Spalten
                for n := 0 to pred(WerteS.count) do
                  OutLineS := OutLineS + WerteS[n] + cLimiterType2;

                // Datenzeile
                PaketS.add(OutLineS);

                if LabelDatensatz then
                begin
                  try
                    if DirExists(cVERSENDER.FieldByName('EXPORTPFAD').AsString) then
                    begin
                      PaketS.SaveToFile(cVERSENDER.FieldByName('EXPORTPFAD').AsString + 'DP_' + _id + '.txt');
                      AppendStringsToFile(PaketS, ExtractFilePath(cVERSENDER.FieldByName('EXPORTPFAD').AsString) +
                        'Historie.txt');
                    end;
                  except
                    on E: exception do
                    begin
                      AppendStringsToFile('e_w_BelegBuchen(' + inttostr(BELEG_R) + '): Deutsche Post : ' +
                        E.Message,
                        {} ErrorFName('BELEG'),
                        {} Uhr12);
                    end;
                  end;
                end
                else
                begin
                  FreeAndNil(PaketS);
                  break;
                end;
              end;
          end;
          FreeAndNil(PaketS);
          FreeAndNil(Name1_2);
        end;
      end;
    until yet;

    cVERSAND.free;
    cVERSENDER.free;

    // nun noch das Ausgangsdatum buchen, dies ist das Zeichen für "versendet"!
    e_x_sql(
      { } 'update VERSAND set AUSGANG=''now'' where' +
      { } ' (BELEG_R=' + inttostr(BELEG_R) + ') AND' +
      { } ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')');

    qBELEG.free;

    b_w_ForderungBuchen(BELEG_R, RechnungsBetrag);

  except
    on E: exception do
    begin
      AppendStringsToFile('e_w_BelegBuchen(' + inttostr(BELEG_R) + '): ' + E.Message,
        {} ErrorFName('BELEG'),
        {} Uhr12);
    end;
  end;
  INTERN_INFO.free;
  if assigned(AusgabeBelege) then
    AusgabeBelege.free;
end;

function e_w_BelegDrittlandAusfuhr(BELEG_R: integer): boolean;
begin
  result := false;
  try
    //
    e_x_sql('update POSTEN set' + ' MWST = 0.0 ' + 'where' + ' (MWST is not null) and' + ' (BELEG_R=' +
      inttostr(BELEG_R) + ')');
    result := true;
  except
    on E: exception do
    begin
      AppendStringsToFile('e_w_BelegDrittlandAusfuhr(' + inttostr(BELEG_R) + '): ' + E.Message,
        {} ErrorFName('BELEG'),
        {} Uhr12);
    end;
  end;
end;

function e_w_BelegStorno(BELEG_R: integer): boolean;
var
  cGELIEFERT: TdboCursor;
  cVERSAND: TdboCursor;
  qTICKET: TdboQuery;
  PERSON_R: integer;
  RollBackDump: TStringList;
  RollBackDomain: string;
  BelegDokumente: TStringList;
  n: integer;
begin
  RollBackDump := TStringList.create;
  RollBackDomain := 'Storno-BELEG-' + RIDasStr(BELEG_R);
  result := false;
  try
    PERSON_R := e_r_sql('select PERSON_R from BELEG where RID=' + inttostr(BELEG_R));

    // Ticket für den Beleg-Storno erstellen
    qTICKET := nQuery;
    with qTICKET do
    begin
      sql.add('select * from TICKET ' + for_update);
      Insert;
      FieldByName('RID').AsInteger := 0;
      FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
      FieldByName('MOMENT').AsDateTime := now;
      qStringsAdd(FieldByName('INFO'), format('Storno des Beleges %d', [BELEG_R]));
      FieldByName('ART').AsInteger := eT_BelegStorno;
      Post;
    end;
    qTICKET.free;

    // Forderungen und Ausgleich-Zahlungen löschen
    fbdump('select * from AUSGANGSRECHNUNG where BELEG_R=' + inttostr(BELEG_R), RollBackDump);
    e_x_sql('delete from AUSGANGSRECHNUNG where BELEG_R=' + inttostr(BELEG_R));

    fbdump('select * from VERSAND where BELEG_R=' + inttostr(BELEG_R), RollBackDump);
    cVERSAND := nCursor;
    with cVERSAND do
    begin
      sql.add('select * from VERSAND where BELEG_R=' + inttostr(BELEG_R));
      ApiFirst;
      while not(eof) do
      begin

        // sichere "Rechnung*"
        BelegDokumente := TStringList.create;
        Dir(
          { } e_r_BelegFName(PERSON_R, BELEG_R, FieldByName('TEILLIEFERUNG').AsInteger, true),
          { } BelegDokumente,
          { } false);
        for n := 0 to pred(BelegDokumente.count) do
          FileMove(
            { } cPersonPath(PERSON_R) + BelegDokumente[n],
            { } DiagnosePath +
            { } RollBackDomain + '-' +
            { } BelegDokumente[n]);
        BelegDokumente.free;

        // lösche "Rechnungskopie*"
        FileDelete(e_r_BelegFName(cRID_Null, BELEG_R, FieldByName('TEILLIEFERUNG').AsInteger, true));

        e_w_dereference(FieldByName('RID').AsInteger, 'EREIGNIS', 'VERSAND_R');

        ApiNext;
      end;
    end;
    cVERSAND.free;

    e_x_sql('delete from VERSAND where BELEG_R=' + inttostr(BELEG_R));

    fbdump('select * from GELIEFERT where BELEG_R=' + inttostr(BELEG_R), RollBackDump);
    // Artikel wieder ins Lager nehmen
    cGELIEFERT := nCursor;
    with cGELIEFERT do
    begin
      sql.add('select * from GELIEFERT where');
      sql.add('(BELEG_R=' + inttostr(BELEG_R) + ') and');
      sql.add('(ARTIKEL_R is not NULL) and');
      sql.add('(MENGE_RECHNUNG is not NULL)');
      ApiFirst;
      while not(eof) do
      begin
        // Rückbuchen!
        e_w_Menge(
          { } FieldByName('EINHEIT_R').AsInteger,
          { } FieldByName('AUSGABEART_R').AsInteger,
          { } FieldByName('ARTIKEL_R').AsInteger,
          { } FieldByName('MENGE_RECHNUNG').AsInteger);

        ApiNext;
      end;
    end;
    cGELIEFERT.free;

    e_x_sql('delete from GELIEFERT where BELEG_R=' + inttostr(BELEG_R));

    fbdump('select * from BELEG where RID=' + inttostr(BELEG_R), RollBackDump);
    e_w_preDeleteBeleg(BELEG_R);
    e_x_sql('delete from BELEG where RID=' + inttostr(BELEG_R));

    RollBackDump.SaveToFile(DiagnosePath + RollBackDomain + cSQLExtension);
    RollBackDump.free;

    result := true;

  except
    on E: exception do
    begin
      AppendStringsToFile('e_w_BelegStorno(' + inttostr(BELEG_R) + '): ' + E.Message,
        {} ErrorFName('BELEG'),
        {} Uhr12);
    end;
  end;
end;


function e_r_PostenPreis(EinzelPreis: double; Anz, EINHEIT_R: integer): double;
var
  Divisor, Faktor: double;
begin
  result := 0.0;
  if (EINHEIT_R >= cRID_FirstValid) then
  begin
    Divisor := e_r_sql('select EINHEIT from EINHEIT where RID=' + inttostr(EINHEIT_R));
    if (Divisor<>0) then
    begin
      Faktor := e_r_sql('select FAKTOR from EINHEIT where RID=' + inttostr(EINHEIT_R));
      if (Faktor<>0) then
       result := cPreisRundung((EinzelPreis * Anz * Faktor) / Divisor)
      else
       result := cPreisRundung((EinzelPreis * Anz) / Divisor)
    end;
  end
  else
  begin
    result := EinzelPreis * Anz;
  end;
end;

function e_c_Rabatt(PREIS, Rabatt: double): double;
begin
  result := PREIS;
  if (Rabatt <> 0.0) then
    result := cPreisRundung(PREIS - (PREIS * (Rabatt / 100.0)));
end;

function e_w_AusgabeBeleg(BELEG_R: integer; NurGeliefertes: boolean; AlsLieferschein: boolean): TStringList;
const
  cSortMerkmalDelete = 'D'; // diese Postenzeile soll wegfallen
  cSortMerkmalPrefix = '?';
  // diese Postenzeile muss so einsortiert werden wie ihr erster Nachfolger mit einer Menge
var
  MyBeleg: THTMLTemplate;
  VerpackerMehrInfo: string;
  _Summe: double;
  _Gewicht: integer;
  _Anzahlung: double;
  _EndSumme: double;
  _ZwischenSumme: double;
  _SkontoAbzug: double;
  _Skontiert: double;
  MwStSaver: TMwSt;
  EvenOddCounter: integer;
  EvenOddCounterPackListe: integer;
  _AddText: string;
  _titel: string;
  _datum: TAnfixDate;
  _PreisProPosition: double;
  _Netto: double;
  _NettoInDieserMwStKlasse: double;
  _MwStInDieserKlasse: double;
  n: integer;
  _ustid: string;
  KundenInfo: TStringList;
  InternInfo: TStringList;
  ZielLandRID: integer;
  DatensammlerGlobal: TStringList;
  DatensammlerLokal: TStringList;
  DatensammlerArtikel: TStringList;
  EinzelpreisNetto: boolean;
  Adressat: TStringList;
  AusgabeFNamePreFix: string;
  ZahlungInfo: TStringList;

  PERSON_R: integer;
  AUFTRAGGEBER_R: integer;
  LIEFERANSCHRIFT_R: integer;
  RECHNUNGSANSCHRIFT_R: integer;
  EINHEIT_R: integer;
  TEILLIEFERUNG: integer;
  RECHNUNGSNUMMER: integer;
  GENERATION: integer;

  cPERSON, cANSCHRIFT, cBELEG, cPOSTEN: TdboCursor;

  //
  _Anz, _AnzAuftrag, _AnzGeliefert, _AnzStorniert, _AnzNachlieferung: integer;

  _Rabatt, _EinzelPreis, _MwStSatz: double;

  PostenzeileSortStr: string;

  ClientSorter: TStringList;
  PostenRIDs: TgpIntegerList;
  LastSortStrWas: string;
  sDuplikate: TStringList;

begin

  // Ausgabe-Lauf
  result := TStringList.create;
  InternInfo := TStringList.create;
  KundenInfo := TStringList.create;
  DatensammlerGlobal := TStringList.create;
  DatensammlerLokal := TStringList.create;
  ZahlungInfo := TStringList.create;
  ClientSorter := TStringList.create;
  PostenRIDs := TgpIntegerList.create;
  cPERSON := nCursor;
  cANSCHRIFT := nCursor;
  cBELEG := nCursor;
  cPOSTEN := nCursor;
  MwStSaver := TMwSt.create;
  sDuplikate := TStringList.create;
  try

    with cBELEG do
    begin
      sql.add('select * from BELEG where RID=' + inttostr(BELEG_R));
      ApiFirst;

      EinzelpreisNetto := FieldByName('EINZELPREIS_NETTO').AsString = 'Y';
      TEILLIEFERUNG := FieldByName('TEILLIEFERUNG').AsInteger;
      RECHNUNGSNUMMER := FieldByName('NUMMER').AsInteger;
      GENERATION := FieldByName('GENERATION').AsInteger;

      AUFTRAGGEBER_R := FieldByName('PERSON_R').AsInteger;
      if FieldByName('LIEFERANSCHRIFT_R').IsNull then
        LIEFERANSCHRIFT_R := AUFTRAGGEBER_R
      else
        LIEFERANSCHRIFT_R := FieldByName('LIEFERANSCHRIFT_R').AsInteger;

      if FieldByName('RECHNUNGSANSCHRIFT_R').IsNull then
        RECHNUNGSANSCHRIFT_R := AUFTRAGGEBER_R
      else
        RECHNUNGSANSCHRIFT_R := FieldByName('RECHNUNGSANSCHRIFT_R').AsInteger;

      // Kontext setzten für Rechnungs-Anschrift
      // Person!
      if AlsLieferschein then
      begin
        if FieldByName('LIEFERANSCHRIFT_R').IsNull then
          PERSON_R := FieldByName('PERSON_R').AsInteger
        else
          PERSON_R := FieldByName('LIEFERANSCHRIFT_R').AsInteger;
      end
      else
      begin
        if FieldByName('RECHNUNGSANSCHRIFT_R').IsNull then
        begin
          PERSON_R := FieldByName('PERSON_R').AsInteger;
        end
        else
        begin
          PERSON_R := FieldByName('RECHNUNGSANSCHRIFT_R').AsInteger;
        end;
      end;

      with cPERSON do
      begin
        sql.add('select * from PERSON where RID=' + inttostr(PERSON_R));
        ApiFirst;
      end;

      with cANSCHRIFT do
      begin
        sql.add('select * from ANSCHRIFT where RID=' + inttostr(cPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsInteger));
        ApiFirst;
      end;

      // Blocks speichern
      DatensammlerGlobal.add('save&delete PL_ARTIKEL EVEN');
      DatensammlerGlobal.add('save&delete PL_ARTIKEL ODD');
      DatensammlerGlobal.add('save&delete ARTIKEL EVEN');
      DatensammlerGlobal.add('save&delete ARTIKEL ODD');
      DatensammlerGlobal.add('save&delete MWST');
      DatensammlerGlobal.add('save&delete PUNKTE');
      DatensammlerGlobal.add('save&delete ANZAHLUNG');
      DatensammlerGlobal.add('save&delete VORAB');

      // Datenfelder ersetzen
      VerpackerMehrInfo := e_r_LagerPlatzNameFromLAGER_R(FieldByName('LAGER_R').AsInteger);
      if (VerpackerMehrInfo <> '') then
        VerpackerMehrInfo := ' nach ' + VerpackerMehrInfo + '!';

      DatensammlerGlobal.add('Titel=' + 'Beleg' + ' ' + inttostr(BELEG_R) + '-' +
        inttostrN(FieldByName('TEILLIEFERUNG').AsInteger, 2));
      DatensammlerGlobal.add('R#=' + inttostr(BELEG_R));
      DatensammlerGlobal.add('R.G#=' + inttostr(BELEG_R) + '-' + inttostr(GENERATION));
      DatensammlerGlobal.add('Medium=' + FieldByName('MEDIUM').AsString);
      DatensammlerGlobal.add('Motivation=' + FieldByName('MOTIVATION').AsString);
      DatensammlerGlobal.add('Auftrag=' + FieldByName('KUNDEN_AUFTRAG').AsString);
      DatensammlerGlobal.add('Anleger=' + e_r_BearbeiterKuerzel(FieldByName('ANLEGER_R').AsInteger));
      DatensammlerGlobal.add('Bearbeiter=' + e_r_BearbeiterKuerzel(FieldByName('BEARBEITER_R').AsInteger));
      DatensammlerGlobal.add('Ausgeber=' + e_r_BearbeiterKuerzel(sBearbeiter));
      DatensammlerGlobal.add('T#=' + inttostrN(FieldByName('TEILLIEFERUNG').AsInteger, 2));
      DatensammlerGlobal.add('GNT#=' + inttostrN(GENERATION, 2));
      DatensammlerGlobal.add('PL Beleg Titel=' + 'PACKLISTE NUMMER' + ' ' + inttostr(BELEG_R) + '-' +
        inttostrN(FieldByName('TEILLIEFERUNG').AsInteger, 2) + VerpackerMehrInfo);
      DatensammlerGlobal.add('Datum=' + long2dateLocalized(DateGet));
      DatensammlerGlobal.add('AktuellesDatum=' + DatumLocalized);
      DatensammlerGlobal.add('AktuelleUhrzeit=' + Uhr);
      if FieldByName('RECHNUNG').IsNull then
        DatensammlerGlobal.add('Rechnungsdatum=' + DatumLocalized)
      else
        DatensammlerGlobal.add('Rechnungsdatum=' + long2dateLocalized(FieldByName('RECHNUNG').AsDateTime));
      DatensammlerGlobal.add('Zahldatum=' + long2dateLocalized(DatePlus(DateGet, e_r_ZahlungFrist(PERSON_R))));
      DatensammlerGlobal.add('Hauptnummer=' + cPERSON.FieldByName('HAUPT_NUMMER').AsString);
      DatensammlerGlobal.add('VorlagePraefix=' + FieldByName('VORLAGE_PREFIX').AsString);
      ZahlungInfo.add('VorlagePraefix=' + FieldByName('VORLAGE_PREFIX').AsString);

      // Freie Felddefinitionen noch machen ...
      e_r_sqlt(FieldByName('INTERN_INFO'), InternInfo);
      for n := 0 to pred(InternInfo.count) do
        if pos('=', InternInfo[n]) > 1 then
          DatensammlerGlobal.add(InternInfo[n]);

      if NurGeliefertes then
        _Anzahlung := FieldByName('DAVON_BEZAHLT').AsFloat
      else
        _Anzahlung := (FieldByName('DAVON_BEZAHLT').AsFloat - FieldByName('RECHNUNGS_BETRAG').AsFloat);

      if (_Anzahlung < cGeld_KleinsterBetrag) then
        _Anzahlung := 0;

    end;

    with cPOSTEN do
    begin

      // sortierung der Ausgabe erstellen
      sql.add('select * from POSTEN where');
      sql.add(InternInfo.values['FILTER-' + inttostrN(inttostr(GENERATION), 2)]);
      sql.add(' (BELEG_R=' + inttostr(BELEG_R) + ')');
      sql.add('order by POSNO,RID');
      ApiFirst;
      while not(eof) do
      begin

        // richten
        e_r_PostenInfo(cPOSTEN, NurGeliefertes, EinzelpreisNetto, _Anz, _AnzAuftrag, _AnzGeliefert, _AnzStorniert,
          _AnzNachlieferung, _Rabatt, _EinzelPreis, _MwStSatz);
        // RAB!!

        if (_AnzAuftrag = 0) then
        begin
          // reine Infozeilen
          PostenzeileSortStr := cSortMerkmalPrefix;
          // sollte so wie nachfolger sein!
        end
        else
        begin

          // echte Auftragsmengen
          repeat

            // default -> gaaanz oben!
            PostenzeileSortStr := '1';

            if iUnterdrueckeGeliefertes then
              if (_AnzGeliefert = _AnzAuftrag) then
              begin
                // vollständig geliefert -> Löschmerkmal!
                PostenzeileSortStr := cSortMerkmalDelete;
                break;
              end;

            if (_Anz = 0) and (_AnzNachlieferung > 0) then
              PostenzeileSortStr := '2';
            if (_AnzGeliefert = _AnzAuftrag) then
              PostenzeileSortStr := '3';

          until yet;

        end;
        //
        ClientSorter.AddObject(PostenzeileSortStr + '.' + inttostrN(FieldByName('POSNO').AsInteger, 8) + '.' +
          inttostrN(FieldByName('RID').AsInteger, 8), Pointer(FieldByName('RID').AsInteger));

        ApiNext;
      end;

      // Blöcke löschen, sowie identität eintragen
      LastSortStrWas := 'Z';
      for n := pred(ClientSorter.count) downto 0 do
      begin
        if (ClientSorter[n][1] = cSortMerkmalPrefix) then
          ClientSorter[n] := LastSortStrWas + copy(ClientSorter[n], 2, MaxInt);

        if (ClientSorter[n][1] = cSortMerkmalDelete) then
        begin
          ClientSorter.delete(n);
          continue;
        end;

        LastSortStrWas := ClientSorter[n][1];
      end;

      // RID - Liste aufbauen
      if iBelegMengenSortierung then
        ClientSorter.sort;
      for n := 0 to pred(ClientSorter.count) do
        PostenRIDs.add(integer(ClientSorter.Objects[n]));

      // jetzt ausgeben!
      _Summe := 0.0;
      _ZwischenSumme := 0;
      _Gewicht := 0;
      EvenOddCounter := 0;
      EvenOddCounterPackListe := 0;
      Close;
      sql.clear;
      sql.add('select * from POSTEN where RID=:CROSSREF');
      for n := 0 to pred(PostenRIDs.count) do
      begin

        ParamByName('CROSSREF').AsInteger := PostenRIDs[n];
        ApiFirst;

        // richten
        e_r_PostenInfo(cPOSTEN, NurGeliefertes, EinzelpreisNetto, _Anz, _AnzAuftrag, _AnzGeliefert, _AnzStorniert,
          _AnzNachlieferung, _Rabatt, _EinzelPreis, _MwStSatz);
        // RAB!!

        EINHEIT_R := FieldByName('EINHEIT_R').AsInteger;

        // Ausgabeblock laden
        if (EvenOddCounter mod 2 = 0) then
        begin
          DatensammlerLokal.add('load ARTIKEL EVEN,ARTIKEL');
        end
        else
        begin
          DatensammlerLokal.add('load ARTIKEL ODD,ARTIKEL');
        end;
        inc(EvenOddCounter);

        if (_Rabatt > 0) then
        begin
          DatensammlerLokal.add('Einzel=' + UnbreakAble(e_r_EinzelPreisAusgabe(_EinzelPreis,
            FieldByName('EINHEIT_R').AsInteger) + format(' (-%.0f%%)', [_Rabatt])));
        end
        else
        begin
          if (_Anz = 0) and (_EinzelPreis = 0.0) then
            DatensammlerLokal.add('Einzel=')
          else
            DatensammlerLokal.add('Einzel=' + e_r_EinzelPreisAusgabe(_EinzelPreis, FieldByName('EINHEIT_R').AsInteger));
        end;

        if (_Anz = 0) then
          DatensammlerLokal.add('MwSt=')
        else
          DatensammlerLokal.add('MwSt=' + UnbreakAble(format('%2.f', [_MwStSatz])) + '%');

        if FieldByName('FAKTOR').IsNull then
        begin
          DatensammlerLokal.add('Faktor=')
        end
        else
        begin
          if iFaktorGanzzahlig then
            DatensammlerLokal.add('Faktor=' + format('%1.fx', [FieldByName('FAKTOR').AsFloat]))
          else
            DatensammlerLokal.add('Faktor=' + format('%gx', [FieldByName('FAKTOR').AsFloat]));
        end;

        if FieldByName('GEWICHT').IsNull then
        begin
          DatensammlerLokal.add('Gewicht=')
        end
        else
        begin
          DatensammlerLokal.add('Gewicht=' + format('%d g', [FieldByName('GEWICHT').AsInteger]));
        end;

        if FieldByName('AUSFUEHRUNG').IsNull then
          DatensammlerLokal.add('Ausfuehrung=')
        else
          DatensammlerLokal.add('Ausfuehrung=' + long2date8(DateTime2Long(FieldByName('AUSFUEHRUNG').AsDateTime)));

        DatensammlerLokal.add('Auftrag=' + FieldByName('KUNDEN_AUFTRAG').AsString);
        DatensammlerLokal.add('Seriennummer=' + FieldByName('SERIENNUMMER').AsString);

        if (_Anz <> _AnzAuftrag) then
        begin
          DatensammlerLokal.add(
           {} 'Anz=' +
           {} e_r_MengenAusgabe(_Anz, EINHEIT_R) +
           {} '/' +
           {} e_r_MengenAusgabe(_AnzAuftrag, EINHEIT_R));
        end
        else
        begin
          if (_Anz <> 0) and ((_Anz <> 1) or not(iEinsUnterdrueckung)) then
            DatensammlerLokal.add('Anz=' + e_r_MengenAusgabe(_Anz, EINHEIT_R))
          else
            DatensammlerLokal.add('Anz=');
        end;

        _AddText := '';

        // storniert oder nicht mehr lieferbar
        if (_AnzStorniert > 0) then
          _AddText := _AddText + #13 + e_r_MengenAusgabe(_AnzStorniert, EINHEIT_R, iNichtMehrLieferbarInfo);

        // wurde bereits geliefert
        if (_AnzGeliefert > 0) then
          _AddText := _AddText + #13 + e_r_MengenAusgabe(_AnzGeliefert, EINHEIT_R, iBereitsGeliefertInfo);

        // wird nachgeliefert
        if (_AnzNachlieferung > 0) then
          _AddText := _AddText + #13 + e_r_MengenAusgabe(_AnzNachlieferung, EINHEIT_R, iNachlieferungInfo);

        // Artikel-Text
        _titel := FieldByName('ARTIKEL').AsString;
        ersetze(DatensammlerGlobal, _titel);

        if FieldByName('MENGE').IsNull and (_Anz = 0) and (_AnzAuftrag = 0) and
          (length(FieldByName('ARTIKEL').AsString) > 0) then
          DatensammlerLokal.add('Text=@' + '<b>' + Ansi2html(_titel + _AddText) + '</b>')
        else
          DatensammlerLokal.add('Text=' + _titel + _AddText);

        // Artikel
        DatensammlerArtikel := e_r_ArtikelInfo(cPOSTEN.FieldByName('ARTIKEL_R').AsInteger);
        with DatensammlerArtikel do
        begin
          if not(FieldByName('ARTIKEL_R').IsNull) then
          begin
            // Artikel ist gesetzt
            if (_Anz = 0) then
              values['Konto'] := '';

            // Verlag - Nummer (GOT-Kürzel!)
            if not(cPOSTEN.FieldByName('INFO').IsNull) then
              values['VerlagNo'] := UnbreakAble(cPOSTEN.FieldByName('INFO').AsString);

            // Lager-Packliste ausgeben!
            if (cPOSTEN.FieldByName('MENGE_RECHNUNG').AsInteger > 0) or
              (cPOSTEN.FieldByName('MENGE_GELIEFERT').AsInteger > 0) then
            begin

              if (EvenOddCounterPackListe mod 2 = 0) then
                DatensammlerLokal.add('load PL_ARTIKEL EVEN,PL_ARTIKEL')
              else
                DatensammlerLokal.add('load PL_ARTIKEL ODD,PL_ARTIKEL');
              inc(EvenOddCounterPackListe);

              DatensammlerLokal.add(
                { } 'PL_Anz=' +
                { } inttostr(cPOSTEN.FieldByName('MENGE_RECHNUNG').AsInteger) +
                { } '/(' +
                { } inttostr(cPOSTEN.FieldByName('MENGE_GELIEFERT').AsInteger) +
                { } ') ' +
                { } values['No'] +
                { } ' @' +
                { } values['Lager']);
              DatensammlerLokal.add('PL_Name=' + values['Lager']);
              DatensammlerLokal.add('PL_Lager=' + copy(values['Verlag'], 1, 20) + '-' + values['VerlagNo']);

              DatensammlerLokal.add('PL_No=' + copy(values['Artikel'], 1, 25));
            end;
          end
          else
          begin
            // ohne Artikel Referenz
            SetValueSmart(DatensammlerArtikel, 'VerlagNo', UnbreakAble(FieldByName('INFO').AsString));
            if (_Anz <> 0) then
              SetValueSmart(DatensammlerArtikel, 'Konto', b_r_Konto(cRID_Null));
          end;
        end;
        DatensammlerLokal.addstrings(DatensammlerArtikel);
        FreeAndNil(DatensammlerArtikel);

        _PreisProPosition := e_c_Rabatt(e_r_PostenPreis(_EinzelPreis, _Anz, EINHEIT_R), _Rabatt);

        MwStSaver.add(_MwStSatz, _PreisProPosition);

        DatensammlerLokal.add('_ZW=' + UnbreakAble(format('%.2m', [_Summe])));
        _Summe := _Summe + _PreisProPosition;
        _Gewicht := _Gewicht + FieldByName('GEWICHT').AsInteger * _Anz;

        if (_Anz <> 0) then
        begin
          DatensammlerLokal.add('Brutto=' + UnbreakAble(format('%.2m', [_PreisProPosition])));
        end
        else
        begin
          DatensammlerLokal.add('Brutto=');
        end;

        DatensammlerLokal.add('set ZW ' + UnbreakAble(format('%.2m', [_Summe])));
        DatensammlerLokal.add('pagebreak');
        // Ende dieses Lokal-Blocks!

        Close;
      end;
    end;

    // jo
    MwStSaver.calc(EinzelpreisNetto);
    _Netto := _Summe;
    for n := 0 to pred(MwStSaver.count) do
      with MwStSaver.MWST[n] do
      begin
        if (Summe <> 0) and (Satz > 0) then
        begin
          DatensammlerLokal.add('load MWST');
          if EinzelpreisNetto then
          begin
            _Summe := _Summe + MwStSumme;
          end
          else
          begin
            _Netto := _Netto - MwStSumme;
          end;
          DatensammlerLokal.add('PR=' + UnbreakAble(format('%.0f', [Satz])));
          DatensammlerLokal.add('MW=' + UnbreakAble(format('%.2m', [MwStSumme])));
          DatensammlerLokal.add('MS=' + UnbreakAble(format('%.2m', [NettoSumme])));
        end;
      end;

    _EndSumme := _Summe - _Anzahlung;

    // Rechnungsnummer setzen / ausgeben
    if (iRechnungsNummerVergabeMoment = ernvm_Vorschau) then
      if not(NurGeliefertes) and not(AlsLieferschein) then
        if isSomeMoney(MwStSaver.brutto) then
          if RECHNUNGSNUMMER = 0 then
            RECHNUNGSNUMMER := e_w_RechnungsNummer(BELEG_R);

    if NurGeliefertes then
    begin
      DatensammlerGlobal.add('Rechnung=' + HugeSingleLine(e_r_RechnungsNummern(BELEG_R), ', '));
    end
    else
    begin
      if (RECHNUNGSNUMMER = 0) then
        DatensammlerGlobal.add('Rechnung=' + fill('0', e_r_RechnungsNummerAnzahlDerStellen))
      else
        DatensammlerGlobal.add('Rechnung=' + inttostr(RECHNUNGSNUMMER));
    end;

    if (_Anzahlung >= cGeld_KleinsterBetrag) then
    begin
      DatensammlerLokal.add('load ANZAHLUNG');
      DatensammlerLokal.add('RB=' + UnbreakAble(format('%.2m', [_Summe])));
      DatensammlerLokal.add('AZ=' + UnbreakAble(format('%.2m', [-_Anzahlung])));
    end;

    if AlsLieferschein then
    begin
      DatensammlerGlobal.add('Beleg Titel=' + 'LIEFERSCHEIN NUMMER' + ' ' + inttostr(BELEG_R));
      DatensammlerGlobal.add('Typ=' + 'LIEFERSCHEIN');
      DatensammlerGlobal.add('Beleg_kurz=' + 'Lieferschein');
    end
    else
    begin
      if IsSoll(_EndSumme) then
      begin
        DatensammlerGlobal.add('Beleg Titel=' + 'GUTSCHRIFT NUMMER' + ' ' + inttostr(BELEG_R));
        DatensammlerGlobal.add('Typ=' + 'GUTSCHRIFT');
        DatensammlerGlobal.add('Beleg_kurz=' + 'Gutschrift');
      end
      else
      begin
        DatensammlerGlobal.add('Beleg Titel=' + 'RECHNUNG NUMMER' + ' ' + inttostr(BELEG_R));
        DatensammlerGlobal.add('Typ=' + 'RECHNUNG');
        DatensammlerGlobal.add('Beleg_kurz=' + 'Rechnung');
      end;
    end;
    DatensammlerGlobal.add('ZS=' + UnbreakAble(format('%.2m', [_Netto])));
    DatensammlerGlobal.add('ZZ=' + UnbreakAble(format('%.2m', [_EndSumme])));
    DatensammlerGlobal.add('ZG=' + UnbreakAble(format('%d', [_Gewicht])));

    // Zahlungsart
    DatensammlerGlobal.add('Zahlung=' + cRawHTMLPrefix + e_r_ZahlungText(0, PERSON_R, ZahlungInfo));
    DatensammlerGlobal.add('Zahlung.RID=' + ZahlungInfo.values['ZAHLUNGTYP_R']);
    DatensammlerGlobal.add('Zahlung.Bezeichnung=' + ZahlungInfo.values['BEZEICHNUNG']);

    // Versender
    DatensammlerGlobal.add('Versender=' + e_r_Versender(BELEG_R, TEILLIEFERUNG));

    _SkontoAbzug := cPreisRundung(_EndSumme * (strtodoubledef(ZahlungInfo.values['SKONTO'], 0) / 100.0));
    _Skontiert := _EndSumme - _SkontoAbzug;

    // hier können noch weitere Zahlung varibale ausgewertet werden
    DatensammlerGlobal.add('SkontoAbzug=' + UnbreakAble(format('%.2m', [_SkontoAbzug])));
    DatensammlerGlobal.add('Skontiert=' + UnbreakAble(format('%.2m', [_Skontiert])));

    e_r_Anschrift(PERSON_R, DatensammlerGlobal);
    e_r_Anschrift(AUFTRAGGEBER_R, DatensammlerGlobal, 'Auftraggeber.');
    e_r_Anschrift(LIEFERANSCHRIFT_R, DatensammlerGlobal, 'Lieferanschrift.');
    e_r_Anschrift(RECHNUNGSANSCHRIFT_R, DatensammlerGlobal, 'Rechnungsanschrift.');

    with cANSCHRIFT do
    begin

      ZielLandRID := FieldByName('LAND_R').AsInteger;
      DatensammlerGlobal.add('KontoInhaber=' + e_r_Localize(strtol(iKontoInhaber), ZielLandRID));
      DatensammlerGlobal.add('KontoBankName=' + e_r_Localize(strtol(iKontoBankName), ZielLandRID));
      DatensammlerGlobal.add('KontoNummer=' + e_r_Localize(strtol(iKontoNummer), ZielLandRID));
      DatensammlerGlobal.add('KontoBLZ=' + e_r_Localize(strtol(iKontoBLZ), ZielLandRID));

      _ustid := FieldByName('UST_ID').AsString;
      if (_ustid <> '') then
      begin
        DatensammlerGlobal.add('USTID=' + _ustid);
      end
      else
      begin
        DatensammlerGlobal.add('delete USTID_A');
        DatensammlerGlobal.add('delete USTID_B');
      end;
    end;

    if not(cBELEG.FieldByName('RECHNUNGSANSCHRIFT_R').IsNull) then
    begin
      DatensammlerLokal.add('load PUNKTE');
      DatensammlerLokal.add('PunkteText=' + 'Auftrag von' + ' ' + e_r_Person(cBELEG.FieldByName('PERSON_R')
        .AsInteger));
    end;

    if not(AlsLieferschein) then
      if not(cBELEG.FieldByName('LIEFERANSCHRIFT_R').IsNull) then
      begin
        DatensammlerLokal.add('load PUNKTE');
        DatensammlerLokal.add('PunkteText=' + 'Lieferung an' + ' ' +
          e_r_Person(cBELEG.FieldByName('LIEFERANSCHRIFT_R').AsInteger));
      end;

    if (length(iStandardTextRechnung) > 0) then
    begin
      DatensammlerLokal.add('load PUNKTE');
      DatensammlerLokal.add('PunkteText=' + iStandardTextRechnung);
    end;

    // weitere Bemerkungen hinzufügen!
    if not(cBELEG.FieldByName('KUNDEN_INFO').IsNull) then
    begin
      e_r_sqlt(cBELEG.FieldByName('KUNDEN_INFO'), KundenInfo);
      if (KundenInfo.count > 0) then
      begin
        _AddText := KundenInfo[0];
        for n := 1 to pred(KundenInfo.count) do
          _AddText := _AddText + #13 + KundenInfo[n];
        _AddText := nextp(_AddText, '~', 0);
        if (_AddText <> '') then
        begin
          DatensammlerLokal.add('load PUNKTE');
          DatensammlerLokal.add('PunkteText=' + _AddText);
        end;
      end;
    end;

    if not(cBELEG.FieldByName('VORAB_INFO').IsNull) then
    begin
      e_r_sqlt(cBELEG.FieldByName('VORAB_INFO'), KundenInfo);
      if (KundenInfo.count > 0) then
      begin
        _AddText := KundenInfo[0];
        for n := 1 to pred(KundenInfo.count) do
          _AddText := _AddText + #13 + KundenInfo[n];
        _AddText := nextp(_AddText, '~', 0);
        if (_AddText <> '') then
        begin
          DatensammlerGlobal.add('load VORAB');
          DatensammlerGlobal.add('Vorab=' + _AddText);
        end;
      end;
    end;

    // Ausgabename bestimmen
    repeat

      AusgabeFNamePreFix := cBELEG.FieldByName('VORLAGE_PREFIX').AsString;

      if (cBELEG.FieldByName('BSTATUS').AsString = 'A') then
      begin
        AusgabeFNamePreFix := AusgabeFNamePreFix + 'Angebot';
        break;
      end;

      if (cBELEG.FieldByName('BSTATUS').AsString = 'G') then
      begin
        AusgabeFNamePreFix := AusgabeFNamePreFix + 'Garantie';
        break;
      end;

      if (cBELEG.FieldByName('BSTATUS').AsString = 'Z') then
      begin
        AusgabeFNamePreFix := AusgabeFNamePreFix + 'Zeitabrechnung';
        break;
      end;

      if AlsLieferschein then
      begin
        AusgabeFNamePreFix := AusgabeFNamePreFix + 'Lieferschein';
        break;
      end;

      AusgabeFNamePreFix := AusgabeFNamePreFix + 'Rechnung';

    until yet;

    // jetzt erst rausbelichten!
    MyBeleg := THTMLTemplate.create;

    repeat

      // deprecated
      if FileExists(MyProgramPath + cHTMLTemplatesDir + AusgabeFNamePreFix + '3spaltig_n.html') then
      begin
        MyBeleg.LoadFromFile(MyProgramPath + cHTMLTemplatesDir + AusgabeFNamePreFix + '3spaltig_n.html');
        break;
      end;

      if FileExists(MyProgramPath + cHTMLTemplatesDir + AusgabeFNamePreFix + '.html') then
      begin
        MyBeleg.LoadFromFile(MyProgramPath + cHTMLTemplatesDir + AusgabeFNamePreFix + '.html');
        break;
      end;

       MyBeleg.addFatalError('Vorlage .\' + cHTMLTemplatesDir + AusgabeFNamePreFix + '.html nicht gefunden');

    until yet;

    MyBeleg.WriteValue(DatensammlerLokal, DatensammlerGlobal);
    result.add(AnwenderPath + AusgabeFNamePreFix + chtmlextension);

    // ungepacktes Ergebnis speichern
    if DebugMode then
      MyBeleg.SaveToFile(DiagnosePath + 'e_r_AusgabeBeleg.html');

    MyBeleg.SortPages;
    // Für eventuelle Mehrseitigkeit (SET NUMBER OF COPIES)
    MyBeleg.SaveToFileCompressed(result[0]);
    MyBeleg.free;

    // weitere Varianten ausbelichten!
    Dir(MyProgramPath + cHTMLTemplatesDir + AusgabeFNamePreFix + '#?' + chtmlextension, sDuplikate, false);
    for n := 0 to pred(sDuplikate.count) do
    begin
      MyBeleg := THTMLTemplate.create;
      with MyBeleg do
      begin
        LoadFromFile(MyProgramPath + cHTMLTemplatesDir + sDuplikate[n]);
        WriteValue(DatensammlerLokal, DatensammlerGlobal);
        SaveToFileCompressed(AnwenderPath + sDuplikate[n]);
        result.add(AnwenderPath + sDuplikate[n]);
      end;
      MyBeleg.free;
    end;

    // Ergebnis auch informativ sichern
    if assigned(e_i_AusgabeBeleg) then
      e_i_AusgabeBeleg.clear
    else
      e_i_AusgabeBeleg := TStringList.create;
    e_i_AusgabeBeleg.addstrings(DatensammlerGlobal);

  except
    on E: exception do
    begin
      AppendStringsToFile('e_r_AusgabeBeleg(' + inttostr(BELEG_R) + '): ' + E.Message,
        {} ErrorFName('BELEG'),
        {} Uhr12);
    end;
  end;
  // Speicher freigeben
  MwStSaver.free;
  InternInfo.free;
  KundenInfo.free;
  DatensammlerGlobal.free;
  DatensammlerLokal.free;
  ZahlungInfo.free;
  ClientSorter.free;
  PostenRIDs.free;
  cPERSON.free;
  cANSCHRIFT.free;
  cBELEG.free;
  cPOSTEN.free;
  sDuplikate.free;
end;

function q_r_PersonWarnung(PERSON_R: integer): TStringList;
var
  BemerkungS: TStringList;
  WarningFound: boolean;
  n: integer;
begin
  result := TStringList.create;

  BemerkungS := e_r_sqlt('select BEMERKUNG from PERSON where RID=' + inttostr(PERSON_R));

  WarningFound := false;
  for n := pred(BemerkungS.count) downto 0 do
    if (pos('!', BemerkungS[n]) > 0) and (pos('KORREKTUR', BemerkungS[n]) = 0) then
      WarningFound := true
    else
      BemerkungS.delete(n);

  if WarningFound then
  begin
    result.add(e_r_Person(PERSON_R));
    result.add('');
    result.addstrings(BemerkungS);
  end;

  BemerkungS.free;

end;

procedure e_f_PersonInfo(PERSON_R: integer; AusgabePfad: string);
var
  OutHeaderL: TStringList;
  OutDataL: TStringList;
  Person,Ort: TStringList;
  cPERSON, cANSCHRIFT: TdboCursor;
  AllParts: TStringList;
  n: integer;
begin
  OutHeaderL := TStringList.create;
  OutDataL := TStringList.create;
  AllParts := TStringList.create;
  for n := 0 to 2 do
    AllParts.add(AusgabePfad + inttostr(n) + '.csv');

  //
  Person := e_r_Adressat(PERSON_R);
  OutHeaderL.add('Adresse1');
  OutHeaderL.add('Adresse2');
  OutHeaderL.add('Adresse3');
  OutHeaderL.add('Adresse4');
  OutDataL.addstrings(Person);
  Person.free;

  cPERSON := nCursor;
  with cPERSON do
  begin
    sql.add('select * from PERSON where RID=' + inttostr(PERSON_R));
    ApiFirst;
  end;

  cANSCHRIFT := nCursor;
  with cANSCHRIFT do
  begin
    sql.add('select * from ANSCHRIFT where RID=' + inttostr(cPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsInteger));
    ApiFirst;
    OutHeaderL.add('Adresse5');
    OutDataL.add(FieldByName('STRASSE').AsString);

    Ort := e_r_Ort(PERSON_R);
    OutHeaderL.add('Adresse6');
    if Ort.Count>=1 then
     OutDataL.add(Ort[0])
    else
     OutDataL.add('');
    OutHeaderL.add('Adresse7');
    if Ort.Count>=2 then
     OutDataL.add(Ort[1])
    else
     OutDataL.add('');
    Ort.Free;
  end;

  ExportTable(cPERSON.sql[0], AllParts[1]);
  RenameColumnHeader('RID', 'PERSON_R', AllParts[1]);

  ExportTable(cANSCHRIFT.sql[0], AllParts[2]);
  RenameColumnHeader('RID', 'ANSCHRIFT_R', AllParts[2]);

  cPERSON.free;
  cANSCHRIFT.free;

  // Hauptanschrift
  FileDelete(AllParts[0]);
  AppendStringsToFile(HugeSingleLine(OutHeaderL, cOLAPcsvSeparator), AllParts[0]);
  AppendStringsToFile(HugeSingleLine(OutDataL, cOLAPcsvSeparator), AllParts[0]);

  JoinTables(AllParts, AusgabePfad + 'PersonenDaten.csv');
  AllParts.free;

end;

function e_w_NeuerMahnlauf(ForceNew: boolean = false): boolean;
var
  AnzahlBuchen: integer;
  AnzahlOhneMahnung: integer;
  cMahnLauf: TdboCursor;

  function AnzahlGesamt: integer;
  begin
    result := AnzahlBuchen + AnzahlOhneMahnung;
  end;

begin
  //
  AnzahlBuchen := 0;
  AnzahlOhneMahnung := 0;
  if not(ForceNew) then
  begin
    cMahnLauf := nCursor;
    with cMahnLauf do
    begin
      sql.add('select BRIEF from MAHNLAUF');
      ApiFirst;
      while not(eof) do
      begin
        if (FieldByName('BRIEF').AsString = cC_True) then
          inc(AnzahlBuchen)
        else
          inc(AnzahlOhneMahnung);
        ApiNext;
      end;
    end;
    cMahnLauf.free;
  end;

  result := ForceNew or (AnzahlGesamt = AnzahlBuchen) or (AnzahlGesamt = AnzahlOhneMahnung);

  if result then
  begin
    e_x_sql('delete from mahnlauf');
    e_w_GEN('GEN_MAHNBESCHEID');
  end;

end;


function e_r_LohnKalkulation(Betrag: double; Datum: TAnfixDate): string;
const
  cMaxValue = 400.0;
var
  FName: string;
  Satz1, Satz2: string;
  cBUCHUNG_KALKULATION: TdboCursor;

  function Verteile2(r: double): string;
  type
    FileTypeStr = string[30];
  var
    InpF: file of FileTypeStr;
    s: word;
    str: FileTypeStr;
    a, b: string[7];
  begin
    if (r > cMaxValue) or (r = 0) then
    begin
      result := '';
      exit;
    end;
    s := trunc(r * 2.0);
    assignFile(InpF, FName);
    reset(InpF);
    seek(InpF, s);
    read(InpF, str);
    closeFile(InpF);
    a := copy(str, 1, 7);
    b := copy(str, 9, 7);
    if (a <> '00:00 h') and (b <> '00:00 h') then
    begin
      result := '(' + Satz1 + ' * ' + a + ') (' + Satz2 + ' * ' + b + ')';
      exit;
    end;

    if (a = '00:00 h') then
    begin
      result := '(' + Satz2 + ' * ' + b + ')';
      exit;
    end;

    if (b = '00:00 h') then
    begin
      result := '(' + Satz1 + ' * ' + a + ')';
      exit;
    end;

    result := '';
  end;

begin
  result := '';
  cBUCHUNG_KALKULATION := nCursor;
  with cBUCHUNG_KALKULATION do
  begin
    sql.add(
     {} 'select RID,SATZ1,SATZ2 from BUCHUNG_KALKULATION where' +
     {} ' (''' + long2date(Datum) +''' between VON and BIS) and' +
     {} ' (AKTIV = ''' + cC_True + ''')');
    ApiFirst;
    if not(eof) then
    begin
      FName := e_r_LohnFName(FieldByName('RID').AsInteger);
      Satz1 := format('%m', [FieldByName('SATZ1').AsFloat]);
      Satz2 := format('%m', [FieldByName('SATZ2').AsFloat]);
      if FileExists(FName) then
        result := Verteile2(Betrag);
    end;
  end;
  cBUCHUNG_KALKULATION.free;
end;

function e_r_LohnFName(RID: integer): string;
begin
  result := iLohnPath + 'Kalkulation_Lohn_' + inttostr(RID) + '.dat';
end;


procedure e_w_DruckBeleg(BELEG_R: integer);
begin
  e_x_sql('update BELEG set DRUCK=''now'' where (RID=' + inttostr(BELEG_R) + ') and (DRUCK IS NULL)');
end;

function e_r_PortoFreiAbBrutto(PERSON_R: integer): double;
var
  OLAP_Script: TStringList;
  OLAP_Parameter: TStringList;
  OLAP_Ergebnis: TStringList;
begin
  result := MaxDouble;
  repeat

    // Nichts gesetzt
    if (iPortoFreiAbBrutto = '') then
    begin
      result := MaxDouble;
      break;
    end;

    // fester Kommawert gesetzt
    if (pos(',', iPortoFreiAbBrutto) > 0) then
    begin
      result := strtodoubledef(iPortoFreiAbBrutto, MaxDouble);
      break;
    end;

    // Ermittlung über ein OLAP Statement
    // aus INTERNATIONALTEXT mit dem Id OLAP:~Id~
    if (pos('OLAP:', iPortoFreiAbBrutto) > 0) then
    begin
      OLAP_Parameter := TStringList.create;
      OLAP_Parameter.add('$PERSON_R=' + inttostr(PERSON_R));
      OLAP_Script := e_r_text(StrToIntDef(nextp(iPortoFreiAbBrutto, ':', 1), 0));
      OLAP_Ergebnis := e_r_OLAP(OLAP_Script, OLAP_Parameter);
      result := strtodoubledef(OLAP_Ergebnis.values['PORTOFREIAB'], 0);
      OLAP_Parameter.free;
      OLAP_Ergebnis.free;
      OLAP_Script.free;
    end;

  until yet;
end;

function e_r_Name(ib_q: TdboDataSet): string; overload;
begin
  result := cutblank(ib_q.FieldByName('VORNAME').AsString + ' ' + ib_q.FieldByName('NACHNAME').AsString);
end;

function e_r_Name(PERSON_R: integer): string; overload;
var
  cPERSON: TdboCursor;
begin
  cPERSON := nCursor;
  with cPERSON do
  begin
    sql.add('SELECT VORNAME,NACHNAME from person where RID=' + inttostr(PERSON_R));
    result := e_r_Name(cPERSON);
  end;
  cPERSON.free;
end;

function e_r_NameVorname(ib_q: TdboDataSet): string; overload;
var
  n, V: string;
begin
  n := cutblank(ib_q.FieldByName('NACHNAME').AsString);
  V := cutblank(ib_q.FieldByName('VORNAME').AsString);
  repeat
    if (n <> '') and (V <> '') then
    begin
      result := n + ', ' + V;
      break;
    end;
    if (n <> '') then
    begin
      result := n;
      break;
    end;

    result := V;
  until yet;
end;

function e_r_NameVorname(PERSON_R: integer): string; overload;
var
  cPERSON: TdboCursor;
begin
  cPERSON := nCursor;
  with cPERSON do
  begin
    sql.add('SELECT VORNAME,NACHNAME from person where RID=' + inttostr(PERSON_R));
    result := e_r_NameVorname(cPERSON);
  end;
  cPERSON.free;
end;

function e_r_fax(ib_q: TdboDataSet): string; overload;
begin
  result := '';
  try
    with ib_q do
      if (cutblank(FieldByName('PRIV_FAX').AsString) = '') then
        result := FieldByName('GESCH_FAX').AsString
      else
        result := FieldByName('PRIV_FAX').AsString;
  except
    on E: exception do
    begin
      AppendStringsToFile('e_r_fax: ' + E.Message,
        {} ErrorFName('BELEG'),
        {} Uhr12);
    end;
  end;
end;

function e_r_fax(PERSON_R: integer): string; overload;
var
  cPERSON: TdboCursor;
begin
  cPERSON := nCursor;
  with cPERSON do
  begin
    sql.add('select GESCH_FAX,PRIV_FAX from PERSON where RID=' + inttostr(PERSON_R));
    ApiFirst;
  end;
  result := e_r_fax(cPERSON);
  cPERSON.free;
end;

procedure e_d_Belege;

  procedure DeleteBeleg(BELEG_R: integer);
  begin
    e_w_preDeleteBeleg(BELEG_R);
    e_x_sql('delete from Beleg where RID=' + inttostr(BELEG_R));
  end;

var
  RIDS: TgpIntegerList;
  n: integer;
  sDiagnose: TStringList;
  sKassenKontos: TSearchStringList;
  sKK: TStringList;
  KontoIndex: integer;
  KontoKasse: string;
  VALUTA: TAnfixDate;
begin

  if (iSchnelleRechnung_PERSON_R >= cRID_FirstValid) then
  begin
    sDiagnose := TStringList.create;

    // alle "schnelle Rechnungen" ohne Motivation löschen
    RIDS := e_r_sqlm(
      { } 'select RID from BELEG where' +
      { } ' (PERSON_R=' + inttostr(iSchnelleRechnung_PERSON_R) + ') and' +
      { } ' (MOTIVATION is null)');

    for n := pred(RIDS.count) downto 0 do
      DeleteBeleg(RIDS[n]);
    RIDS.free;

    // alle unbezahlten "schnelle Rechnungen" ausgleichen
    RIDS := e_r_sqlm(
      { } 'select RID from BELEG where' +
      { } ' (PERSON_R=' + inttostr(iSchnelleRechnung_PERSON_R) + ') and' +
      { } ' (DAVON_BEZAHLT is null) and' +
      { } ' (MOTIVATION is not null)');

    if (RIDS.count > 0) then
    begin
      // Vorbereitung
      sKassenKontos := TSearchStringList.create;
      sKK := e_r_sqlsl(
        { } 'select (NAME||'';''||KONTO) from BUCH where' +
        { } ' (BETRAG is null) and ' +
        { } ' (KONTO containing ''Kasse'')');
      sKassenKontos.assign(sKK);
      sKK.free;

      for n := pred(RIDS.count) downto 0 do
      begin
        // Eingentliche Beleg-Anlage (so soll auch gebucht werden!)
        VALUTA := date2Long(e_r_sqls('select ANLAGE from BELEG where RID=' + inttostr(RIDS[n])));

        // Ermittlung des Ziel-Kassen Kontos
        KontoIndex := sKassenKontos.FindPos(e_r_sqls(
          { } 'select MOTIVATION from BELEG' +
          { } ' where RID=' + inttostr(RIDS[n])));
        if (KontoIndex = -1) then
          KontoKasse := cKonto_Kasse
        else
          KontoKasse := nextp(sKassenKontos[KontoIndex], ';', 0);

        // Forderungsausgleich
        b_w_ForderungAusgleich(format(
          { } cBuch_Ausgleich, [
          { } iSchnelleRechnung_PERSON_R,
          { } RIDS[n],
          { } cGeld_Zero,
          { } long2date(VALUTA),
          { } cRID_Null,
          { } 'SOFORTZAHLUNG=JA',
          { } KontoKasse,
          { * } cRID_Null,
          { } cRID_Null]), sDiagnose);

      end;
    end;
    RIDS.free;
    AppendStringsToFile(
      { } sDiagnose,
      { } DiagnosePath + 'Schnelle-Rechnung-Ausgleich-' +
      { } DatumLog + '.txt');
    sDiagnose.free;
  end;

end;

procedure e_x_BelegAusPOS;
var
  qBELEG: TdboQuery;
  qPosten: TdboQuery;
  sBELEGE: TStringList;
  n, r: integer;
  sBON: TsTable;
  sBELEG: TStringList;
  BELEG_R: integer;
  ARTIKEL_R: integer;
  BEARBEITER_R: integer;
  aUHR: TAnfixTime;
  aDATUM: TAnfixDate;
  FNameA, FNameB: string;
  R_BEARBEITER: TgpIntegerList;
  R_ARTIKEL: TgpIntegerList;
begin

  // Vorbedingungen prüfen
  if not(DirExists(KassePath)) then
    exit;
  if (iSchnelleRechnung_PERSON_R < cRID_FirstValid) then
    exit;

  sBELEGE := TStringList.create;
  Dir(KassePath + cBON_Bon + '*.ini', sBELEGE, false);
  if (sBELEGE.count > 0) then
  begin
    e_w_GEN('GEN_ZUSAMMENHANG');

    sBELEGE.sort;

    R_BEARBEITER := e_r_sqlm('select RID from BEARBEITER');
    R_ARTIKEL := e_r_sqlm('select RID from ARTIKEL');

    qBELEG := nQuery;
    qBELEG.sql.add('select * from BELEG ' + for_update);

    //
    qPosten := nQuery;
    qPosten.sql.add('select * from POSTEN ' + for_update);

    sBON := TsTable.create;
    sBELEG := TStringList.create;
    for n := 0 to pred(sBELEGE.count) do
    begin

      try

        //
        BELEG_R := StrToIntDef(StrFilter(sBELEGE[n], cZiffern), cRID_Null);
        if (BELEG_R < cRID_FirstValid) then
          continue;
        FNameA := cBON_Bon + RIDasStr(BELEG_R) + '.csv';
        FNameB := cBON_Bon + RIDasStr(BELEG_R) + '.ini';

        //
        if (e_r_sql('select RID from BELEG where RID=' + inttostr(BELEG_R)) = BELEG_R) then
        begin
          // Gab es schon!
          FileMove(KassePath + FNameA, DiagnosePath + FNameA);
          FileMove(KassePath + FNameB, DiagnosePath + FNameB);
          continue;
        end;

        // Load
        sBON.Del;
        sBON.insertFromFile(KassePath + FNameA);
        sBELEG.LoadFromFile(KassePath + FNameB);

        // Beleg anlegen
        with qBELEG do
        begin
{$IFNDEF fpc}
          ColumnAttributes.add('BTYP=NOTREQUIRED');
          ColumnAttributes.add('BSTATUS=NOTREQUIRED');
{$ENDIF}
          Insert;
          FieldByName('PERSON_R').AsInteger := iSchnelleRechnung_PERSON_R;
          FieldByName('RID').AsInteger := BELEG_R;
          FieldByName('EINZELPREIS_NETTO').AsString := cC_False;

          //
          BEARBEITER_R := StrToIntDef(sBELEG.values[cBON_Beleg_Bearbeiter], sBearbeiter);
          if (R_BEARBEITER.IndexOf(BEARBEITER_R) <> -1) then
            FieldByName('ANLEGER_R').AsInteger := BEARBEITER_R;

          FieldByName('MEDIUM').AsString := 'POS';
          FieldByName('MOTIVATION').AsString := sBELEG.values[cBON_Beleg_Gegeben];
          aDATUM := date2Long(sBELEG.values[cBON_Beleg_Datum]);
          aUHR := strtoseconds(sBELEG.values[cBON_Beleg_Uhr]);
          FieldByName('RECHNUNG').AsDateTime := mkDateTime(aDATUM, aUHR);
          FieldByName('ANLAGE').AsDateTime := mkDateTime(aDATUM, aUHR);
          Post;
        end;

        // Posten aufbauen
        for r := 1 to sBON.RowCount do
          with qPosten do
          begin
            Insert;
            FieldByName('RID').AsInteger := cRID_AutoInc;
            FieldByName('BELEG_R').AsInteger := BELEG_R;
            FieldByName('MENGE').AsInteger := StrToIntDef(sBON.readCell(r, 'ANZAHL'), 0);
            FieldByName('ARTIKEL').AsString := sBON.readCell(r, 'TITEL');
            FieldByName('PREIS').AsFloat := strtodoubledef(sBON.readCell(r, 'EURO'), 0.0);
            FieldByName('NETTO').AsString := cC_False;
            FieldByName('MWST').AsFloat := strtodoubledef(sBON.readCell(r, 'SATZ'), 0);

            //
            ARTIKEL_R := StrToIntDef(sBON.readCell(r, 'RID'), cRID_Null);
            if (R_ARTIKEL.IndexOf(ARTIKEL_R) <> -1) then
              FieldByName('ARTIKEL_R').AsInteger := ARTIKEL_R;

            Post;
          end;

        // Verbuchen!
        e_w_BelegBuchen(BELEG_R);

        FileMove(KassePath + FNameA, DiagnosePath + FNameA);
        FileMove(KassePath + FNameB, DiagnosePath + FNameB);

      except
        on E: exception do
        begin
          AppendStringsToFile('e_x_BelegAusPOS: ' + E.Message,
            {} ErrorFName('BELEG'),
            {} Uhr12);
        end;
      end;

    end;
    R_BEARBEITER.free;
    R_ARTIKEL.free;

    qBELEG.free;
    qPosten.free;
    sBON.free;
  end;
  sBELEGE.free;
end;

procedure e_d_Rang;

var
  IB_RANG: TdboCursor;
  IB_SET_ARTIKEL, IB_SET_ARTIKEL_AA: TdboScript;
  IB_ARTIKEL, IB_ARTIKEL_AA: TdboQuery;
  IB_SET_RANG: TdboQuery;
  RANG: double;
  MENGE: integer;
  ARTIKEL_R, AUSGABEART_R: integer;
  MaxMenge: integer;
  n: integer;
  Divisor: double;

begin
  IB_SET_RANG := nil;
  Divisor := 1.0;

  e_x_sql('update ARTIKEL set RANG=null, SYNC=-1');
  e_x_sql('update ARTIKEL_AA set RANG=null, SYNC=-1');

  // update mechanismus vorbereiten
  IB_SET_ARTIKEL := nScript;
  with IB_SET_ARTIKEL do
  begin
    sql.add('UPDATE ARTIKEL');
    sql.add('SET RANG=:RANG, SYNC=-1');
    sql.add('WHERE RID=:CR');
    dbLog(sql,false);
  end;

  IB_SET_ARTIKEL_AA := nScript;
  with IB_SET_ARTIKEL_AA do
  begin
    sql.add('UPDATE ARTIKEL_AA');
    sql.add('SET RANG=:RANG, SYNC=-1');
    sql.add('WHERE (ARTIKEL_R=:CR_A)');
    sql.add('AND (AUSGABEART_R=:CR_B)');
    dbLog(sql,false);
  end;

  IB_RANG := nCursor;
  with IB_RANG do
  begin
    sql.add('select');
    sql.add(' GELIEFERT.ARTIKEL_R,');
    sql.add(' GELIEFERT.AUSGABEART_R,');
    sql.add(' sum(GELIEFERT.MENGE_RECHNUNG) as VERKAUFS_MENGE,');
    sql.add(' max(VERSAND.AUSGANG) as LETZTER_VERKAUF');
    sql.add('from');
    sql.add(' GELIEFERT');
    sql.add('join');
    sql.add(' VERSAND');
    sql.add('on');
    sql.add(' (GELIEFERT.BELEG_R=VERSAND.BELEG_R) and');
    sql.add(' (GELIEFERT.POSNO=VERSAND.TEILLIEFERUNG) and');
    sql.add(' (VERSAND.AUSGANG>''' + long2date(DatePlus(DateGet, -iRangZeitfenster)) + ''')');
    sql.add('where');
    sql.add(' (GELIEFERT.ARTIKEL_R is not null) and');
    sql.add(' (GELIEFERT.MENGE_RECHNUNG is not null) and');
    sql.add(' (GELIEFERT.ZUTAT is null)');
    sql.add('group by');
    sql.add(' GELIEFERT.ARTIKEL_R,');
    sql.add(' GELIEFERT.AUSGABEART_R');
    sql.add('order by');
    sql.add(' VERKAUFS_MENGE desc,');
    sql.add(' LETZTER_VERKAUF desc');
    dbLog(sql);
    Open;
    ApiFirst;
    if not(eof) then
    begin
      // grösste Menge bestimmen!
      MaxMenge := FieldByName('VERKAUFS_MENGE').AsInteger;
      Divisor := StrtoDouble('1' + fill('0', length(inttostr(MaxMenge))));
    end;

    n := 0;
    while not(eof) do
    begin
      inc(n);

      ARTIKEL_R := FieldByName('ARTIKEL_R').AsInteger;
      MENGE := FieldByName('VERKAUFS_MENGE').AsInteger;
      RANG := n + (MENGE / Divisor);

      if FieldByName('AUSGABEART_R').IsNull then
      begin

        with IB_SET_ARTIKEL do
        begin
          Params.BeginUpdate;
          ParamByName('CR').AsInteger := ARTIKEL_R;
          ParamByName('RANG').AsFloat := RANG;
{$IFDEF fpc}
          Params.EndUpdate;
{$ELSE}
          Params.EndUpdate(true);
{$ENDIF}
          execute;
        end;

      end
      else
      begin

        AUSGABEART_R := FieldByName('AUSGABEART_R').AsInteger;
        with IB_SET_ARTIKEL_AA do
        begin
          Params.BeginUpdate;
          ParamByName('CR_A').AsInteger := ARTIKEL_R;
          ParamByName('CR_B').AsInteger := AUSGABEART_R;
          ParamByName('RANG').AsFloat := RANG;
{$IFDEF fpc}
          Params.EndUpdate;
{$ELSE}
          Params.EndUpdate(true);
{$ENDIF}
          execute;
        end;

      end;
      ApiNext;
    end;
  end;

  IB_RANG.free;
  IB_SET_ARTIKEL.free;
  IB_SET_ARTIKEL_AA.free;

  IB_ARTIKEL := nQuery;
  with IB_ARTIKEL do
  begin
    sql.add('select');
    sql.add(' RANG,');
    sql.add(' coalesce(LETZTERVERKAUF,LETZTEAENDERUNG) as AKTION');
    sql.add('from');
    sql.add(' ARTIKEL');
    sql.add('where');
    sql.add(' RANG is null');
    sql.add('order by');
    sql.add(' AKTION desc, RID desc');
    for_update(sql);
    dbLog(sql,false);
    Open;
    First;
  end;

  IB_ARTIKEL_AA := nQuery;
  with IB_ARTIKEL_AA do
  begin
    sql.add('select');
    sql.add(' RANG,');
    sql.add(' coalesce(LETZTERVERKAUF,LETZTEAENDERUNG) as AKTION');
    sql.add('from');
    sql.add(' ARTIKEL_AA');
    sql.add('where');
    sql.add(' RANG is null');
    sql.add('order by');
    sql.add(' AKTION desc, RID desc');
    for_update(sql);
    Open;
    First;
  end;

  repeat

    if (IB_ARTIKEL_AA.eof) and (IB_ARTIKEL.eof) then
      break;

    repeat

      // Ist einer der beiden Listen am Ende?
      if (IB_ARTIKEL_AA.eof) then
      begin
        IB_SET_RANG := IB_ARTIKEL;
        break;
      end;

      if (IB_ARTIKEL.eof) then
      begin
        IB_SET_RANG := IB_ARTIKEL_AA;
        break;
      end;

      // Wer hat das aktuellere Datum?
      if not(IB_ARTIKEL_AA.FieldByName('AKTION').IsNull) and not(IB_ARTIKEL.FieldByName('AKTION').IsNull) then
      begin
        if (IB_ARTIKEL_AA.FieldByName('AKTION').AsDateTime > IB_ARTIKEL.FieldByName('AKTION').AsDateTime) then
          IB_SET_RANG := IB_ARTIKEL_AA
        else
          IB_SET_RANG := IB_ARTIKEL;
        break;
      end;

      // Hat ARTIKEL.AKTION ein Datum?
      if not(IB_ARTIKEL.FieldByName('AKTION').IsNull) then
      begin
        IB_SET_RANG := IB_ARTIKEL;
        break;
      end;

      // Hat ARTIKEL_AA.AKTION ein Datum?
      if not(IB_ARTIKEL_AA.FieldByName('AKTION').IsNull) then
      begin
        IB_SET_RANG := IB_ARTIKEL_AA;
        break;
      end;

      // Beide haben scheinbar kein Datum mehr
      // ->dann Flip-Flop
      if (odd(n)) then
        IB_SET_RANG := IB_ARTIKEL_AA
      else
        IB_SET_RANG := IB_ARTIKEL;

    until yet;

    // set RANG
    inc(n);
    with IB_SET_RANG do
    begin
      edit;
      FieldByName('RANG').AsFloat := n;
      Post;
      Next;
    end;

  until eternity;

  IB_ARTIKEL_AA.Close;
  IB_ARTIKEL.Close;
  IB_ARTIKEL_AA.free;
  IB_ARTIKEL.free;
end;

procedure e_d_Lieferzeit;

type
  TLieferzeitDurchschnitt = record
    ARTIKEL_R: integer;
    AnzWarenBewegungen: integer;
    LieferzeitAsSeconds: integer;
    BonusAsSeconds: integer;
  end;

var
  EREIGNIS: TdboCursor;
  ARTIKEL: TdboQuery;
  LieferzeitDurchschnitt: TLieferzeitDurchschnitt;
  DebugStr: TStringList;
  StartD, EndeD: TAnfixDate;
  n: integer;
  LIEFERZEIT: TdboCursor;
  PERSON: TdboQuery;

  procedure MakeEntry;
  begin
    with LieferzeitDurchschnitt do
    begin
      if (ARTIKEL_R > 0) then
      begin
        DebugStr.add(format('%5d %3dx %s %s', [ARTIKEL_R, AnzWarenBewegungen,
          secondstostr9(LieferzeitAsSeconds div AnzWarenBewegungen),
          secondstostr9(BonusAsSeconds div AnzWarenBewegungen)]));
        with ARTIKEL do
        begin
          ParamByName('CROSSREF').AsInteger := ARTIKEL_R;
          if not(Active) then
            Open;
          if not(eof) then
          begin
            edit;
            FieldByName('LIEFERZEIT').AsInteger := (LieferzeitAsSeconds - BonusAsSeconds) div AnzWarenBewegungen;
            FieldByName('SYNC').AsInteger := -1;
            Post;
          end;
        end;
      end;
      AnzWarenBewegungen := 0;
      LieferzeitAsSeconds := 0;
      BonusAsSeconds := 0;
    end;
  end;

begin
  DebugStr := TStringList.create;
  ARTIKEL := nQuery;
  EREIGNIS := nCursor;
  PERSON := nQuery;
  LIEFERZEIT := nCursor;

  // Erst mal die alten Kamellen weg!
  // Es handelt sich nicht um einen gleitenden Durchschnitt!
  e_x_sql('update ARTIKEL set LIEFERZEIT=null, SYNC=-1');

  with ARTIKEL do
    sql.add('select LIEFERZEIT, SYNC from ARTIKEL where RID=:CROSSREF ' + for_update);

  with EREIGNIS do
  begin
    sql.add('SELECT');
    sql.add(' BBELEG.BESTELLT,');
    sql.add(' EREIGNIS.AUFTRITT,');
    sql.add(' EREIGNIS.ARTIKEL_R');
    sql.add('FROM EREIGNIS');
    sql.add('JOIN BBELEG ON');
    sql.add(' (BBELEG.RID=EREIGNIS.BBELEG_R)');
    sql.add('WHERE');
    sql.add(' (EREIGNIS.ARTIKEL_R is not null) AND');
    sql.add(' (EREIGNIS.ART=' + inttostr(eT_WareEingetroffen) + ') AND');
    sql.add(' (EREIGNIS.AUFTRITT>''' + long2date(DatePlus(DateGet, -iLieferzeitZeitfenster)) + ''')');
    sql.add('ORDER BY');
    sql.add(' EREIGNIS.ARTIKEL_R');
    Open;
    fillchar(LieferzeitDurchschnitt, sizeof(LieferzeitDurchschnitt), 0);
    LieferzeitDurchschnitt.ARTIKEL_R := -1;
    ApiFirst;
    while not(eof) do
    begin

      // Plausibilität des Records
      if (FieldByName('EREIGNIS.AUFTRITT').AsDateTime > FieldByName('BBELEG.BESTELLT').AsDateTime) then
      begin

        //
        StartD := DateTime2Long(FieldByName('BBELEG.BESTELLT').AsDateTime);
        EndeD := DateTime2Long(FieldByName('EREIGNIS.AUFTRITT').AsDateTime);

        if (LieferzeitDurchschnitt.ARTIKEL_R <> FieldByName('EREIGNIS.ARTIKEL_R').AsInteger) then
          MakeEntry;
        with LieferzeitDurchschnitt do
        begin
          ARTIKEL_R := FieldByName('EREIGNIS.ARTIKEL_R').AsInteger;
          inc(AnzWarenBewegungen);
          inc(LieferzeitAsSeconds, SecondsDiff(EndeD, datetime2seconds(FieldByName('EREIGNIS.AUFTRITT').AsDateTime),

            StartD, datetime2seconds(FieldByName('BBELEG.BESTELLT').AsDateTime)

            ));
          if (DateDiff(StartD, EndeD) < 5) then
            for n := 0 to pred(DateDiff(StartD, EndeD)) do
              if (WeekDay(DatePlus(StartD, n)) > 5) then
                inc(BonusAsSeconds, 24 * 60 * 60);
        end;
      end;
      ApiNext;
    end;
    MakeEntry;
    Close;
  end;
  ARTIKEL.Close;

  // Ergebnis bei den Verlagen Eintragen
  PERSON.sql.add('SELECT LIEFERZEIT, SYNC FROM PERSON WHERE RID=:CROSSREF ' + for_update);
  with LIEFERZEIT do
  begin
    sql.add('select');
    sql.add(' VERLAG_R,');
    sql.add(' avg(LIEFERZEIT) LIEFERZEIT');
    sql.add('from');
    sql.add(' ARTIKEL');
    sql.add('where');
    sql.add(' (VERLAG_R IS NOT NULL) AND');
    sql.add(' (LIEFERZEIT IS NOT NULL)');
    sql.add('group by');
    sql.add(' VERLAG_R');
    Open;
    ApiFirst;
    while not(eof) do
    begin
      with PERSON do
      begin
        ParamByName('CROSSREF').AsInteger := LIEFERZEIT.FieldByName('VERLAG_R').AsInteger;
        if not(Active) then
          Open;
        edit;
        FieldByName('LIEFERZEIT').AsInteger := LIEFERZEIT.FieldByName('LIEFERZEIT').AsInteger;
        FieldByName('SYNC').AsInteger := -1;
        Post;
      end;
      ApiNext;
    end;
  end;
  ARTIKEL.free;
  EREIGNIS.free;
  LIEFERZEIT.free;
  PERSON.free;

  // Debug Liste ausgeben
  if (DebugStr.count > 0) then
    DebugStr.SaveToFile(DiagnosePath + 'Lieferzeit.txt');
  DebugStr.free;
end;

function e_r_BelegFNameExists(PERSON_R: integer; BELEG_R: integer; TEILLIEFERUNG: integer = 0): string;
begin
  repeat
    result := e_r_BelegFNameCombined(
      { } PERSON_R,
      { } BELEG_R,
      { } TEILLIEFERUNG);
    if FileExists(result) then
     break;
    result := e_r_BelegFName(
      { } PERSON_R,
      { } BELEG_R,
      { } TEILLIEFERUNG);
    if FileExists(result) then
     break;
    result := '';
  until yet;
end;

procedure WarenbewegungCleanUp;
var
 Stichtag: TAnfixDate;
begin
 Stichtag := DatePlus(DateGet,-365*10);
 // delete
 e_x_sql(
  {} 'delete from WARENBEWEGUNG where '+
  {} '((AUFTRITT is null) or (AUFTRITT<''' + Long2Date(Stichtag) + '''))');
end;

procedure EreignisCleanUp;
var
 Stichtag: TAnfixDate;
begin
 Stichtag := DatePlus(DateGet,-365*10);
 // Prepare
 e_x_sql(
  {} 'update BUCH set BUCH.EREIGNIS_R=null where '+
  {} ' (BUCH.EREIGNIS_R in '+
  {} '  (select EREIGNIS.RID from EREIGNIS where'+
  {} '  (EREIGNIS.AUFTRITT is null or EREIGNIS.AUFTRITT<''' + Long2Date(Stichtag) + ''')'+
  {} '  )'+
  {} ' )');
 e_x_sql(
  {} 'update AUSGANGSRECHNUNG set AUSGANGSRECHNUNG.EREIGNIS_R=null where '+
  {} ' (AUSGANGSRECHNUNG.EREIGNIS_R in '+
  {} '  (select EREIGNIS.RID from EREIGNIS where'+
  {} '  (EREIGNIS.AUFTRITT is null or EREIGNIS.AUFTRITT<''' + Long2Date(Stichtag) + ''')'+
  {} '  )'+
  {} ' )');
 // delete
 e_x_sql(
  {} 'delete from EREIGNIS where '+
  {} '(AUFTRITT is null) or (AUFTRITT<''' + Long2Date(Stichtag) + ''')');
end;


end.
