{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007-2014  Andreas Filsinger
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
unit Funktionen_Beleg;

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
  dbOrgaMon,
  anfix32,
  globals,
  gplists,
  InfoZIP;

type
  eSuchSubs = (eSS_Titel, eSS_Numero, eSS_PaperColor, eSS_Verlag, eSS_Serie, eSS_Komponist,
    eSS_Arranger, eSS_Preis, eSS_Schwer, eSS_Land, eSS_Menge, eSS_Lager, eSS_VersendeTag, eSS_Rang,
    eSS_MengeProbe, eSS_MengeDemo, eSS_VerlagNo, eSS_Count // Muss immer der letze sein ...
    );

const
  sAugesetzteBelege: TgpIntegerList = nil;

function e_r_sqlArtikelWhere(AUSGABEART_R, ARTIKEL_R: integer; TableName: string = ''): string;
// kleinere Tools für Artikel Selektion

function e_r_Artikel(AUSGABEART_R, ARTIKEL_R: integer): string;
//

procedure e_r_ArtikelSortieren(const RIDS: TList);
//

function e_r_ArtikelLink(ARTIKEL_R: integer): string;
//

function e_r_Lager(EINHEIT_R, AUSGABEART_R, ARTIKEL_R: integer): integer;
// Liefert den Lager-Platz des Artikels

function e_r_ErwarteteMenge(AUSGABEART_R, ARTIKEL_R: integer; sDetails: TStringList = nil): integer;
// liefert die Menge, die fest bestellt aber noch nicht eingetroffen ist (für Kunden oder Lager)

function e_r_AgentMenge(AUSGABEART_R, ARTIKEL_R: integer): integer;
// liefert die Menge, die im Moment zu beschaffen ist (für Kunden)

function e_r_OffeneMenge(AUSGABEART_R, ARTIKEL_R: integer): integer;
// liefert die Menge, die im Moment in der Schwebe ist (unbestellt+ungeliefert)

function e_r_UnbestellteMenge(AUSGABEART_R, ARTIKEL_R: integer): integer;
// liefert die Menge, die im Moment unbestellt ist

function e_r_VorschlagMenge(AUSGABEART_R, ARTIKEL_R: integer): integer;
// liefert die Menge, die das System vorschlagen würde

function e_r_UngelieferteMengeUeberBedarf(AUSGABEART_R, ARTIKEL_R: integer): integer;
// liefert die überzählige Menge die vom System erwartet wird, also über "Agent" und "Mindestbestand"
// hinaus.

function e_r_MindestMenge(AUSGABEART_R, ARTIKEL_R: integer): integer;
// liefert die Mindest-Menge, die auf Lager sein sollte

procedure e_w_MehrBedarfsAnzeige(AUSGABEART_R, ARTIKEL_R, POSTEN_R, MENGE: integer;
  Motivation: integer);
// dem Agenten signalisieren, dass ein um MENGE erhöhter Bestell-Bedarf besteht

procedure e_w_MinderBedarfsAnzeige(AUSGABEART_R, ARTIKEL_R, POSTEN_R, MENGE: integer);
// dem Agenten signalisieren, dass sich der Bestell-Bedarf um MENGE vermindert hat! (er nun nicht mehr besteht!)

function e_w_SetFolge(AUSGABEART_R, ARTIKEL_R: integer): integer;
// Order-Posten-Anz
// Reihenfolge der Befriediung von Erwarteten Mengen voreinstellen

function e_w_Wareneingang(AUSGABEART_R, ARTIKEL_R, MENGE: integer): integer;
// [ZUSAMMENHANG]
// Waren im System verteilen

function e_r_ZahlungText(ZAHLUNGTYP_R: integer; PERSON_R: integer = 0;
  MoreInfo: TStringList = nil): string;
// liefert den Zahlungstext zur jeweiligen Person

function e_r_ZahlungRID(PERSON_R: integer): integer;
// liefert den Zahlungstext zur jeweiligen Person

function e_r_ZahlungFrist(PERSON_R: integer): integer;
// liefert die Fälligkeit in Tagen einer Forderung

function e_r_ZahlungBezeichnung(PERSON_R: integer): string;
// liefert den Zahlungstext zur jeweiligen Person

function e_r_Versender(BELEG_R: integer; TEILLIEFERUNG: integer): string;
// liefert den Namen des Versenders

function e_r_PackformGewicht(BELEG_R: integer): integer;
// liefert das aktuelle Leergewicht der Lieferung

function e_r_VERLAG_R_fromVerlag(Verlag: string): integer; { RID }
// RID eines Verlages bestimmen!

function e_r_Verlag(VERLAG_R: integer): string; { SUCHBEGRIFF }
// Name eines Verlage bestimmen

function e_r_Lieferant(ARTIKEL_R, MENGE: integer): integer; { PERSON_R }
// Ermittelt den Lieferanten zu diesem Artikel

procedure e_d_Belege;
// Beleg-Löschung durchführen

procedure e_d_Rang;
// Artikel-Rang neu berechnen

procedure e_d_Lieferzeit;
// Artikel-Lieferzeit neu berechnen

procedure e_x_BelegAusPOS;
// Belege aus POS Dateien erstellen

function e_w_BestellBeleg(PERSON_R: integer): integer; { BBELEG_R }
// liefert die Nummer eines Bestellbelegs, ev. wird einer neu erzeugt

function e_w_JoinBeleg(BELEG_R_FROM, BELEG_R_TO: integer): integer;
// 2 Belege zusammen führen

function e_w_JoinPerson(PERSON_R_FROM, PERSON_R_TO: integer): integer;
// 2 Personen zusammen führen, Quellperson kann gelöscht werden

function e_w_MoveBeleg(BELEG_R_FROM, PERSON_R_TO: integer): integer;
// einen Beleg von einem Verantwortlichen zum anderen führen

function e_w_CopyBeleg(BELEG_R_FROM, PERSON_R_TO: integer; sTexte: TStringList = nil): integer;
// Beleg neu erstellen anhand einer Vorlage

procedure e_w_MergeBeleg(BELEG_R_FROM, BELEG_R_TO: integer; sTexte: TStringList = nil);
// Beleg erweitern um neue Postenzeilen

function e_r_MengenAusgabe(MENGE, EINHEIT_R: integer; FormatStr: string = '%d'): string;
// Menge rausbelichten

function e_r_EinzelPreisAusgabe(PREIS: double; EINHEIT_R: integer): string;
// Einzelpreis rausbelichten

function e_r_PostenPreis(EinzelPreis: double; Anz, EINHEIT_R: integer): double;
// Gesamtpreis berechnen

function e_c_Rabatt(PREIS, Rabatt: double): double;
// einen Preis um einen Rabatt vermindern

procedure e_r_PostenInfo(IBQ: TdboDataSet; NurGeliefertes: boolean; EinzelpreisNetto: boolean;
  var _Anz, _AnzAuftrag, _AnzGeliefert, _AnzStorniert, _AnzAgent: integer;
  var _Rabatt, _EinzelPreis, _MwStSatz: double);
// Alle relevANTEN Infos rund um einen Posten ermitteln

function e_w_AusgabeBeleg(BELEG_R: integer; NurGeliefertes: boolean; AlsLieferschein: boolean)
  : TStringList;
// Ausgabelauf für den aktuellen Beleg mit Anlage der htmls
// Es wird eine Liste aller erstellten Belichtungs-Ergebnisdateien erzeugt

procedure e_w_DruckBeleg(BELEG_R: integer);
// den Druck eines Beleges verbuchen und Eintragen

function e_r_Ausgabeart(AUSGABEART_R: integer): string;
// liefert den text dieser Ausgabeart

function e_r_Menge(EINHEIT_R, AUSGABEART_R, ARTIKEL_R: integer): integer;
{ MENGE }
// liefert die Lagermenge dieses Artikels in der angegebenen
// Ausprägungsart

function e_r_PreisTabelle(PREIS_R: integer): double;
// Liest den Preiswert aus der Tabelle aus

function e_r_PreisValid(p: double): boolean;
// Ist es auch ein echter preis, oder nur ein Tag

function e_r_Preis(EINHEIT_R, AUSGABEART_R, ARTIKEL_R: integer; var Satz: double;
  var Netto: boolean; var NettoWieBrutto: boolean): double;
// liefert den Preis des Artikels
// Satz ist der Mwst-Satz
// Netto liefert Info, ob dieser Preis ein Netto oder Brutto-Preis ist

function e_r_PreisText(AUSGABEART_R, ARTIKEL_R: integer): string;
// liefert den Preis des Artikels, fertig als String
// - es kann auch "auf Anfrage" geben

function e_r_PreisBrutto(AUSGABEART_R, ARTIKEL_R: integer): double;
// liefert den Preis des Artikels

function e_r_PreisNativ(AUSGABEART_R, ARTIKEL_R: integer): double;
// liefert die Preisangabe für diesen Artikel
// unabhängig von netto/brutto Problematik so wie er in der
// Datenbank steht.

function e_r_EndPreis(PERSON_R, AUSGABEART_R, ARTIKEL_R: integer): double;
// liefert den Preis des Artikels

function e_r_PreisNetto(AUSGABEART_R, ARTIKEL_R: integer): double;
// liefert den Preis des Artikels

function e_r_PaketPreis(AUSGABEART_R, ARTIKEL_R: integer): double;
// liefert den Preis des Artikels

function e_r_Umsatz(POSTEN_R: integer): double;
// liefert den Netto-Umsatz dieser Position

function e_r_USD(ARTIKEL_R: integer): double;
// liefert den United States Dollar Preis aus der Preistabelle

function e_r_RabattCode(PERSON_R: integer): string;
// der Rabatt-Code des Kunden.

function e_r_RabattFaehig(PERSON_R: integer): boolean;
// ist es ein Rabatt-Kunde JA/NEIN

function e_r_Rabatt(ARTIKEL_R, PERSON_R: integer; var Netto: boolean;
  var NettoWieBrutto: boolean): double;
// liefert den Rabatt, den diese Person bei diesem Artikel erhält
// nebenbei:
// wird bei dieser Person ohne MwSt-Ausweisgearbeitet (Ausländer)?
// soll dabei einfach der eigentliche Bruttopreis als Nettopreis ausgewiesen werden?

function e_r_VerlagsRabatt(VERLAG_R, PERSON_R: integer): double;
// vermutlicher Rabatt, den PERSON_R bei diesem VERLAG_R bekommen würde
//
// unbeachtet bleiben:
// Obergrenzen
// Sortiments-Bezogene Rabatte
// Artikel-Bezogene Rabatte

function e_r_ekRabatt(ARTIKEL_R: integer): double;
// liefert den Rabatt, mit dem dieser Artikel eingekauft wird

function e_r_MwSt(AUSGABEART_R, ARTIKEL_R: integer): double; overload;
// MwSt: liefert die MwSt des Artikels

function e_r_MwSt(SORTIMENT_R: integer): double; overload;
// MwSt: liefert die MwSt wie in diesem Sortiment üblich

function e_r_Prozent(Satz: integer; mDatum: TAnfixDate = cIllegalDate): double;
// MwSt: liefert den Prozentwert eines Steuersatzes

function e_r_Satz(Prozent: double; mDatum: TAnfixDate): integer;
// MwSt: liefert die Satznummer (1,2, ...) anhand eines gegebenen Prozentwertes

function e_w_EinLagern(ARTIKEL_R: integer): integer; // [LAGER_R]
// Lagerplatz eintragen

procedure e_w_Zwischenlagern(BELEG_R: integer; LAGER_R: integer);
// LAGER_R in den Beleg eintragen!
//

function e_r_LagerVorschlag(SORTIMENT_R: integer; PERSON_R: integer
  { VERLAG_R } ): integer; // [LAGER_R]
// Lagerplatz vorschlagen

function e_r_LagerDiversitaet(LAGER_R: integer): integer; // [MENGE]
// Liefert die Anzahl verschiedener Artikel auf einem Lagerplatz

function e_r_IsUebergangsfach(LAGER_R: integer): boolean;
//

function e_r_Uebergangsfach_VERLAG_R: integer; // [[VERLAG_R]]
// Die Verlag-RID der speziellen PERSON "Übergangsfach"

function e_r_LagerVorhanden(SORTIMENT_R: integer): boolean;
// Ist ein Lager aktiv?

function e_r_FreiesLager_VERLAG_R: integer;
// Die Verlag-RID der speziellen PERSON "Freies Lager"

function e_r_LagerPlatzNameFromLAGER_R(LAGER_R: integer): string;
// Names eines Lagerplatzes anhand des LAGER_R

function e_r_UebergangsfachFromPerson(PERSON_R: integer): integer;
// [LAGER_R in Übergangsfach]
// Übergangsfach ermitteln

procedure e_w_LagerFreigeben;
// gibt Lagerplätze frei, bei denen 14 Tage keine Bewegung mehr ist und Menge=0

function e_w_Menge(EINHEIT_R, AUSGABEART_R, ARTIKEL_R, MENGE: integer; BELEG_R: integer = 0;
  POSTEN_R: integer = 0): integer; { MENGE }
// bucht eine Lagermenge ab oder zu
// liefert die neue Lagermenge

function e_w_NeuerMahnlauf(ForceNew: boolean = false): boolean;
// erzeugt neuen Nummernkreise und leert die Mahnkandidatenliste
//

function e_w_KontoInfo(PERSON_R: integer; sOptionen: TStringList = nil): TStringList;
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

function e_r_BestellInfo(PERSON_R: integer): integer;
// liefert den Lieferrückstand des Lieferanten (erwartete Mengen!)
// erzeugt als Nebeneffekt die aktuelle "Bestellung.html"

procedure e_w_WarenkorbLeeren(PERSON_R: integer);
// Leert den aktuellen Warenkorb

function e_w_WarenkorbEinfuegen(BELEG_R: integer): integer;
// Fügt den aktuellen Warenkorb in den angegebenen Beleg
// ein.

function e_w_buchen(BELEG_R, PERSON_R: TDOM_Reference): integer;
// Gibt es was zu verbuchen?
// BELEG_R = null -> Zeitabrechnung bei diesem Kunden
// Rückgabewert -> Anzahl der erzeugten Belege

function e_r_Stempel(PERSON_R, BELEG_R: integer): integer; // [STEMPEL_R]
// liefert den RID den Stemples für diese Person

function e_r_RechnungsNummerAnzahlDerStellen: integer;
// Anzahl der Stellen der Rechnungsnummer bestimmen

function e_r_RechnungsNummern(BELEG_R: integer): TStringList;
// liefert alle bisherigen Rechnungen zu diesem Beleg

function e_r_RechnungsNummer(BELEG_R, TEILLIEFERUNG: integer): string;
// liefert die verwendete Rechnungsnummer zu diesem Beleg

function e_w_RechnungsNummer(BELEG_R: integer): integer;
// setzt die Rechnungsnummer im Beleg falls noch leer

function e_r_Versandfertig(ib_q: TdboDataSet): boolean;
// Ist bei dieser Beleg komplett versandfertig (alles da!)?

function e_r_Versandfaehig(ib_q: TdboDataSet): boolean;
// Ist bei diesem Beleg etwas versendbar?

// Legt einen neuen Versand-Eintrag in der Versand-Tabelle an,
// oder füllt den vorbereiteten!
function e_w_BelegVersand(BELEG_R: integer; Summe: double; gewicht: integer): integer;

function e_w_BelegDrittlandAusfuhr(BELEG_R: integer): boolean;
// setzt die MwSt auf "0"

function e_w_BelegStorno(BELEG_R: integer): boolean;
// wickelt eine Beleg wieder zurück ab

function e_r_StandardVersender: integer;
// VERSENDER_R des Standard-Versenders

function e_r_LeerGewicht(PACKFORM_R: integer): integer;
// Leergewicht einer bestimmten Packform
//

function e_r_Gewicht(AUSGABEART_R, ARTIKEL_R: integer): integer;
// Gewicht eines Artikels
//

function e_r_ArtikelVersendetag(AUSGABEART_R, ARTIKEL_R: integer): integer;
// gibts infos über den Versendetag aus, es werden spezielle Status Codes
// verwendet. Siehe Doku.

function e_r_Lieferzeit(AUSGABEART_R, ARTIKEL_R: integer): integer;
// [Tage]
// gibts infos über den Versendetag aus, es werden spezielle Status Codes
// verwendet. Siehe Doku.

function e_w_ArtikelNeu(SORTIMENT_R: integer): integer; { : RID }
// legt einen Artikel im angegebenen Sortiment an
// liefert den neuen RID zurück!

function e_w_Artikel(EINHEIT_R, AUSGABEART_R, ARTIKEL_R: integer): boolean;
{ : Musste angelegt werden }
// legt die Kombination Einheit.Ausgabeart.Artikel eines Artikels an, falls dieser
// noch nicht existiert.

function e_w_PersonNeu: integer; { : RID }
// legt eine neue Person (vorläufig) an. Über sie kann der Kunde
// vorbestellungen / vormerkungen anlegen.

function e_w_SetStandardVersandData(qVERSAND: TdboQuery): integer;
{ : VERSENDER_R }
// Versanddatensatz vorbelegen

function e_r_PortoFreiAbBrutto(PERSON_R: integer): double;
//

//
// berechnet die VersandKosten anhand der Tabelle VREGEL
// BELEG_R: um welchen Beleg geht es
// Ergebnis ARTIKEL_R = 0, keine Versandkosten
// ARTIKEL_R = -1, Berechnung nicht möglich, Problem
// ARTIKEL_R >0 , der passende Versandkostenartikel
//
function e_r_VersandKosten(BELEG_R: integer): integer; { : ARTIKEL_R }

function e_r_IsVersandKosten(ARTIKEL_R: integer): boolean;
// ermittelt, ob es sich bei dem Angegebenen Artikel
// um einen Versandartikel handelt, dies sind solche, die
// in der VREGEL genannt werden.

function e_w_VersandKostenClear(BELEG_R: integer): integer;
{ : Anzahl der entfernten }
// löschen der ungebuchten versandkosten des
// letzten Buchungslaufes

function e_r_KontoInhaber(PERSON_R: integer): string;
//

function e_r_VornameNachname(PERSON_R: integer): string;
//

function e_r_ArtikelDokument(AUSGABEART_R, ARTIKEL_R, MEDIUM_R: integer): integer;
function e_r_ArtikelBild(AUSGABEART_R, ARTIKEL_R: integer; DoFileCheck: boolean = true): string;
function e_r_ArtikelVorschaubild(AUSGABEART_R, ARTIKEL_R: integer;
  DoFileCheck: boolean = true): string;
function e_r_ArtikelMusik(AUSGABEART_R, ARTIKEL_R: integer): string;
function e_r_ArtikelKontext(AUSGABEART_R, ARTIKEL_R: integer): string;

// B E L E G E

// Prüfung, ob ein Beleg einer Aktion entspricht!
function e_r_Aktion(Name: String; BELEG_R: integer): boolean;

// Dateiname des Belegs
function e_r_BelegFName(PERSON_R: integer; BELEG_R: integer; TEILLIEFERUNG: integer = 0;
  AsMask: boolean = false): string;

// Dateiname des Belegs
function e_r_MahnungFName(PERSON_R: integer): string;

function e_r_BelegInfo(BELEG_R: integer; TEILLIEFERUNG: integer = -1): TStringList;
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

function e_r_BelegeAusgeglichen(BELEG_R: integer): boolean;
// true wenn keine Forderung / Gutschrift mehr

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

//
//
function e_w_VertragBuchen(VERTRAG_R: integer; sSettings: TStringList): TStringList; overload;

// Einen einzelnen Vertrag buchen, ohne besondere Optionen
//
function e_w_VertragBuchen(VERTRAG_R: integer; Erzwingen: boolean = false): TStringList; overload;

// Alle Verträge anwenden und buchen
//
function e_w_VertragBuchen: TStringList; overload;

// Alle Verträge der Liste anwenden und buchen
//
function e_w_VertragBuchen(const lVertraege: TgpIntegerList): TStringList; overload;

// Kann für diesen Vertrag eine Abrechnung erfolgen?
//
function e_r_VertragBuchen(VERTRAG_R: integer): boolean;

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

function e_r_LandRID(ISO: string): integer;

// zu dem jeweiligen LOHNTABELLEN RID die passende Tabelle
function e_r_LohnFName(RID: integer): string;

function e_r_LadeParameter: TStringList; { }
//

// Textermittlungs Funktionen zu Personen
procedure e_r_Anschrift(PERSON_R: integer; sl: TStringList; Prefix: string = '');
procedure e_r_Bank(PERSON_R: integer; sl: TStringList; Prefix: string = '');

function e_r_Adressat(PERSON_R: integer): TStringList;
function e_r_Ort(PERSON_R: integer): string; overload;
function e_r_Ort(dboDS: TdboDataSet): string; overload;
function e_r_Name(ib_q: TdboDataSet): string; overload;
function e_r_Name(PERSON_R: integer): string; overload;
function e_r_NameVorname(ib_q: TdboDataSet): string; overload;
function e_r_NameVorname(PERSON_R: integer): string; overload;
function e_r_land(ib_q: TdboDataSet): string;
function e_r_PLZlength(ib_q: TdboDataSet): integer;
function e_r_plz(ib_q: TdboDataSet; PLZlength: integer = -1): string;
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
procedure e_w_preDeletePerson(PERSON_R: integer);
procedure e_w_preDeleteVerlag(VERLAG_R: integer);
procedure e_w_preDeleteTier(TIER_R: integer);

function e_w_BelegStatusBuchen(BELEG_R: integer): boolean;
function e_w_BBelegStatusBuchen(BBELEG_R: integer): boolean;

// vor dem setzen weiterer Felder kann hier Standardasiert ein Artikel in
// den aktuellen Posten kopiert werden. Zentrale Funktion zum Füllen einer
// Posten zeile
procedure e_w_SetPostenData(ARTIKEL_R, PERSON_R: integer; qPosten: TdboQuery);
procedure e_w_SetPostenPreis(EINHEIT_R, AUSGABEART_R, ARTIKEL_R, PERSON_R: integer;
  qPosten: TdboQuery);

// Caching
procedure e_w_InvalidateCaches;

procedure e_r_Preis_ensureCache;
procedure e_r_PreisTabelle_ensureCache;
procedure e_r_SortimentSatz_EnsureCache;
procedure e_r_PreisNativ_ensureCache;

// Q - Funktionen sind Qualitätssicherungs-Hilfsfunktionen
function q_r_PersonWarnung(PERSON_R: integer): TStringList;

// F - Sind Download und Upload Funktionen
procedure e_f_PersonInfo(PERSON_R: integer; AusgabePfad: string);

// T - Funktions zum Integritätstest von Daten
function t_r_Beleg(BELEG_R: integer): boolean;

// P - Umfeldparameter auslesen

// Auftrags Sachen
function e_r_AuftragNummer(BAUSTELLE_R: integer): integer; // [max(NUMMER)]
function e_r_Schritte(AUFTRAG_R: integer): TStringList;
function e_r_AuftragPlausi(AUFTRAG_R: integer): string; // Plausi-Prüfung
function e_r_Sparte(Art: string): string; // Ermittlung der Sparte

// Qualitäts-Sicherungs Sachen
procedure e_w_Ticket(sContext: string); overload;
procedure e_w_Ticket(slContext: TStringList); overload;
//

// erhöht den Stempel um eins und liefert nun diesen Wert.
//
function e_w_Stempel(STEMPEL_R: integer): integer;

type
  TRegelErgebnis = class(TObject)
    gewicht: integer;
    OUT_PERSON_R: integer;
  end;

implementation

uses
  // Delphi
  math,
  SysUtils,

  // Tools
{$IFNDEF fpc}
  System.UITypes,
  Jvgnugettext,
{$ELSE}
  graphics,
  fpchelper,
{$ENDIF}
  html, Geld, DTA,
  SimplePassword, WordIndex, OpenStreetMap,

  // DC-Crypt
  DCPcrypt2, DCPblockciphers, DCPblowfish, DCPbase64,

  // DataBase
{$IFNDEF CONSOLE}
  Datenbank,
{$ENDIF}
  // OrgaMon
  CareTakerClient,
  Funktionen_LokaleDaten,
  Funktionen_Basis,
  Funktionen_Buch,
  Funktionen_Auftrag;

CONST
  cAllSettingsAnz = 182;
  cAllSettings: array [0 .. pred(cAllSettingsAnz)] of string = ('MwStSatzManuelleArtikel',
    'NachlieferungInfo', 'BereitsGeliefertInfo', 'StandardTextRechnung', 'FreigabePfad',
    'SicherungsPfad', 'SicherungsPrefix', 'SicherungenAnzahl', 'NichtMehrLieferbarInfo',
    'DatenbankBackupPfad', 'TagesabschlussUm', 'TagesabschlussAuf',
    'NachTagesAbschlussHerunterfahren', 'TagWacheUm', 'TagWacheAuf', 'NachTagwacheHerunterfahren',
    'KontoInhaber', 'KontoBankName', 'KontoNummer', 'KontoBLZ', 'KontoPIN', 'SpoolPath',
    'MusicPath', 'PDFPathShop', 'PDFPathApp', 'PDFVersender', 'PDFAdmin', 'PDFSend', 'ShopHost',
    'XMLRPCHost', 'XMLRPCPort', 'XMLRPCGeroutet', 'ScannerHost', 'ScannerAutoBuchen', 'LabelHost',
    'MagnetoHost', 'PortoFreiAbBrutto', 'PortoMwStLogik', 'Auftragsmedium', 'Auftragsmotivation',
    'AuftragsGrundRückfrage', 'SysdbaPasswort', 'RangZeitfenster', 'LieferzeitZeitfenster',
    'StandardLieferzeit', 'PersonSchnelleRechnung', 'Farbe', 'Replikation', 'OrtFormat', 'GOT',
    'BelegSetzeMengeNullBeiPreisNull', 'BelegRechnungGlattstellen', 'BelegUnterdrückeGeliefertes',
    'BelegMengenSortierung', 'BelegArtikelNeu', 'BearbeiterSprache', 'EinzelpreisNetto',
    'Mahnschwelle', 'Mahnfälligkeitstoleranz', 'MahnungAusgelicheneDazwischenAnzeigen',
    'MahnungErstAbUnausgeglichenheit', 'MahnungGebuehr1', 'MahnungGebuehr2', 'MahnungGebuehr3',
    'MahnungZinsSatzPrivat', 'MahnungZinsSatzGewerblich', 'MahnungMindestZins',
    'MahnungMahnstufeZinsEintritt', 'MahnungAbstand', 'MahnlaufbeiTagesabschluss', 'Profil01',
    'Profil02', 'Profil03', 'Profil04', 'Profil05', 'Profil06', 'Profil07', 'Profil08', 'Profil09',
    'Profil10', 'Profil11', 'Profil12', 'Profil13', 'Profil14', 'Profil15', 'Profil16', 'Profil17',
    'Profil18', 'LagerHoheDiversität', 'EinzelPositionNetto', 'KommaFaktor',
    'BelegAnzeigeNachBuchen', 'NachTagesAbschlussAnwendungNeustart', 'htmlPath', 'BilderURL',
    'WikiServer', 'PrivaterWikiServer', 'AuftragsObjektPfad', 'FarbeStufe1', 'FarbeStufe2',
    'FarbeStufe3', 'FarbeStufe4', 'FarbeStufe5', 'csvQuelle', 'AblageVerzögerung',
    'TagesArbeitszeit', 'MonDaVorlauf', 'NeuanlageZeitraum', 'Schalter01', 'Schalter02',
    'Schalter03', 'Schalter04', 'Schalter05', 'Schalter06', 'Schalter07', 'Schalter08',
    'Schalter09', 'Schalter10', 'Schalter11', 'Schalter12', 'Schalter13', 'Schalter14',
    'Schalter15', 'Schalter16', 'Schalter17', 'Schalter18', 'Schalter19', 'Schalter20',
    'TagesabschlussBerechneRang', 'FaktorGanzzahlig', 'CareTaker', 'AutoUpRevPfad',
    'OLAPIstÖffentlich', 'KartenPfad', 'KartenHost', 'NachTagesAbschlussRechnerNeuStarten',
    'AutoUpFTP', 'ShopKey', 'ShopKonto', 'ShopLink', 'ShopArtikelBilderURL',
    'ShopArtikelBilderPfad', 'ShopQRPfad', 'OpenOfficePDF', 'AuftragsAblagePfad',
    'TagWacheWochentage', 'TagesabschlussWochentage', 'NachTagwacheAnwendungNeustart',
    'FTPProxyHost', 'FTPProxyPort', 'TextdokumentDateierweiterung', 'AusgabeartLastschriftText',
    'KontoVorlauf', 'KontenHBCI', 'JonDaAdmin', 'RechnungenFortlaufend', 'AnschriftNameOben',
    'BruttoVersandGewicht', 'RESTHost', 'RESTPort', 'RESTGeroutet', 'HBCIRest', 'BaustellenPfad',
    'EinsUnterdrückung', 'RechnungsNummerVergabeMoment', 'NachTagwacheRechnerNeuStarten',
    'TestDrucker', 'FunktionsSicherungstellungsPfad', 'KassenHost', 'MobilFTP', 'FotoPfad',
    'BuchFokus', 'ShopMusicPath', 'MaxDownloadsProArtikel', 'TPicUploadPfad',
    'VerlagsdatenabgleichPfad', 'KartenProfil', 'SchubladePort', 'TagwacheBaustelle',
    'memcacheHost', 'Ablage', 'KontoSEPAFrist');

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

function e_r_Lieferant(ARTIKEL_R, MENGE: integer): integer;
var
  VERLAG_R: integer;
  SORTIMENT_R: integer;

  function BCheck(Condition: string): integer;
  var
    BREGEL: TdboCursor;
  begin
    result := -1;
    BREGEL := nCursor;
    with BREGEL do
    begin
      sql.add('SELECT');
      sql.add(' OUT_PERSON_R');
      sql.add('FROM');
      sql.add(' BREGEL');
      sql.add('WHERE');
      sql.add(Condition);
      ApiFirst;
      if not(eof) then
        result := FieldByName('OUT_PERSON_R').AsInteger;
      Close;
    end;
    BREGEL.free;
  end;

  procedure LoadMoreARTIKELData;
  var
    ARTIKEL: TdboCursor;
  begin
    ARTIKEL := nCursor;
    with ARTIKEL do
    begin
      sql.add('SELECT');
      sql.add(' VERLAG_R,');
      sql.add(' SORTIMENT_R');
      sql.add('FROM');
      sql.add(' ARTIKEL');
      sql.add('WHERE');
      sql.add(' RID=' + inttostr(ARTIKEL_R));
      ApiFirst;
      if not(eof) then
      begin
        VERLAG_R := FieldByName('VERLAG_R').AsInteger;
        SORTIMENT_R := FieldByName('SORTIMENT_R').AsInteger;
      end;
    end;
    ARTIKEL.free;
  end;

begin

  // zunächst kein Ergebnis
  VERLAG_R := -1;
  SORTIMENT_R := -1;

  repeat

    // ARTIKEL
    result := BCheck('IN_ARTIKEL_R=' + inttostr(ARTIKEL_R));
    if (result > 0) then
      break;

    // Artikeldaten VERLAG_R, SORTIMENT_R nachladen
    LoadMoreARTIKELData;

    // VERLAG & SORTIMENT
    result := BCheck('(IN_VERLAG_R=' + inttostr(VERLAG_R) + ') AND (' + 'IN_SORTIMENT_R=' +
      inttostr(SORTIMENT_R) + ')');
    if (result > 0) then
      break;

    // VERLAG
    result := BCheck('(IN_VERLAG_R=' + inttostr(VERLAG_R) + ') AND (IN_SORTIMENT_R IS NULL)');
    if (result > 0) then
      break;

    // SORTIMENT
    result := BCheck('(IN_SORTIMENT_R=' + inttostr(SORTIMENT_R) + ') AND (IN_VERLAG_R IS NULL)');
    if (result > 0) then
      break;

    // nichts hat gegriffen -> den eigenen Verlag liefern
    result := VERLAG_R;

    // Level 2: Regeln mit Mengen ...
    // Nach anwendung des ersten levels erfolgt noch eine 2. runde
    // -> todo:
    //
    // Es wird so funktionieren:
    //
    // IN_MENGE_ARTIKEL    : Regel wirkt, sobald MENGE_AGENT (für diesen Artikel) >= IN_MENGE_ARTIKEL
    // IN_MENGE_VERLAG     : Regel wirkt, sobald MENGE_AGENT (für diesen Lieferanten) >= IN_MENGE_VERLAG
    // IN_MENGE_SORTIMENT  : Regel wirkt, sobald MENGE_AGENT (für dieses Sortiment) >= IN_MENGE_VERLAG

    // LoadMoreMENGENData

  until true;

end;

procedure e_w_MinderBedarfsAnzeige(AUSGABEART_R, ARTIKEL_R, POSTEN_R, MENGE: integer);
begin
end;

procedure e_w_MehrBedarfsAnzeige(AUSGABEART_R, ARTIKEL_R, POSTEN_R, MENGE: integer;
  Motivation: integer);

var
  cPOSTEN: TdboCursor;
  _titel: string;
  BPosten: TdboQuery;
  ARTIKEL: TdboQuery;
  ZUSAGE: TDateTime;
  ArtikelTextFromArtikel: boolean;
begin
  ArtikelTextFromArtikel := true;

  dec(MENGE, e_r_UngelieferteMengeUeberBedarf(AUSGABEART_R, ARTIKEL_R));
  if (MENGE <> 0) then
  begin

    // Zusage-Default bestimmen
    if (Motivation = eT_MotivationMindestbestand) then
      ZUSAGE := long2datetime(DatePlusWorking(DateGet, iStandardLieferZeit * 2))
    else
      ZUSAGE := long2datetime(DatePlusWorking(DateGet, iStandardLieferZeit));

    BPosten := nQuery;
    with BPosten do
    begin

      if (POSTEN_R > 0) then
      begin

        // ZUSAGE und ARTIKEL-Bezeichnung nachladen!
        cPOSTEN := nCursor;
        with cPOSTEN do
        begin
          sql.add('SELECT ARTIKEL,ZUSAGE FROM POSTEN WHERE RID=' + inttostr(POSTEN_R));
          ApiFirst;
          if not(eof) then
          begin
            ArtikelTextFromArtikel := false;
            _titel := FieldByName('ARTIKEL').AsString;

            // ev. Zusage aus dem Posten übernehmen
            if not(FieldByName('ZUSAGE').IsNull) then
              ZUSAGE := FieldByName('ZUSAGE').AsDateTime;

          end;
        end;
        cPOSTEN.free;

        sql.add('SELECT * FROM BPOSTEN WHERE');
        sql.add(' (POSTEN_R=' + inttostr(POSTEN_R) + ') AND');
        if (AUSGABEART_R > 0) then
          sql.add(' (AUSGABEART_R=' + inttostr(AUSGABEART_R) + ') AND')
        else
          sql.add(' (AUSGABEART_R IS NULL) AND');
        sql.add(' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') AND');
        sql.add(' (MENGE_UNBESTELLT>0) AND');
        sql.add(' (MOTIVATION=' + inttostr(ord(Motivation)) + ')');
        for_update(sql);
      end
      else
      begin
        sql.add('SELECT * FROM BPOSTEN WHERE');
        if (AUSGABEART_R > 0) then
          sql.add(' (AUSGABEART_R=' + inttostr(AUSGABEART_R) + ') AND')
        else
          sql.add(' (AUSGABEART_R IS NULL) AND');
        sql.add(' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') AND');
        sql.add(' (MENGE_UNBESTELLT>0) AND');
        sql.add(' (MOTIVATION=' + inttostr(ord(Motivation)) + ')');
        for_update(sql);
      end;

      Open;
      case RecordCount of
        0:
          begin
            // im Moment kein _UNBESTELLTER Bedarf -> Neuanlage
            Insert;

            ARTIKEL := nQuery;

            // Werte aus Artikel
            with ARTIKEL do
            begin
              sql.add('SELECT');
              sql.add(' TITEL,');
              sql.add(' GEWICHT,');
              sql.add(' NUMERO,');
              sql.add(' VERLAGNO,');
              sql.add(' VERLAG_R');
              sql.add('FROM');
              sql.add(' ARTIKEL');
              sql.add('WHERE');
              sql.add(' RID=' + inttostr(ARTIKEL_R));
              Open;
              if ArtikelTextFromArtikel then
                BPosten.FieldByName('ARTIKEL').assign(FieldByName('TITEL'));
              BPosten.FieldByName('GEWICHT').AsInteger := e_r_Gewicht(AUSGABEART_R, ARTIKEL_R);
              BPosten.FieldByName('NUMERO').assign(FieldByName('NUMERO'));
              BPosten.FieldByName('VERLAG_R').assign(FieldByName('VERLAG_R'));
              BPosten.FieldByName('VERLAGNO').assign(FieldByName('VERLAGNO'));
              BPosten.FieldByName('PREIS').AsFloat := e_r_PreisBrutto(AUSGABEART_R, ARTIKEL_R);
              BPosten.FieldByName('MWST').AsFloat := e_r_MwSt(AUSGABEART_R, ARTIKEL_R);
              BPosten.FieldByName('RABATT').AsFloat := e_r_ekRabatt(ARTIKEL_R);
              Close;
            end;
            ARTIKEL.free;

            // Artikel-Daten
            if not(ArtikelTextFromArtikel) then
              FieldByName('ARTIKEL').AsString := _titel;

            FieldByName('RID').AsInteger := 0;
            FieldByName('ARTIKEL_R').AsInteger := ARTIKEL_R;
            FieldByName('ZUSAGE').AsDateTime := ZUSAGE;
            if (AUSGABEART_R > 0) then
              FieldByName('AUSGABEART_R').AsInteger := AUSGABEART_R;
            if (POSTEN_R > 0) then
              FieldByName('POSTEN_R').AsInteger := POSTEN_R;
            FieldByName('MENGE').AsInteger := MENGE;
            FieldByName('MENGE_UNBESTELLT').AsInteger := MENGE;
            FieldByName('MOTIVATION').AsInteger := Motivation;
            Post;

          end;
        1:
          begin
            // Es gibt schon unbestellte
            if (FieldByName('MENGE').AsInteger + MENGE < 1) then
            begin
              // Es gibt keinen Bedarf mehr -> Zeile löschen
              delete;
            end
            else
            begin
              edit;

              // Bedarf erhöhen
              FieldByName('MENGE').AsInteger := FieldByName('MENGE').AsInteger + MENGE;
              FieldByName('MENGE_UNBESTELLT').AsInteger := FieldByName('MENGE_UNBESTELLT')
                .AsInteger + MENGE;

              // Zusage ev. vorstellen! Es wird etwas dringlicher
              if (FieldByName('ZUSAGE').AsDateTime > ZUSAGE) then
                FieldByName('ZUSAGE').AsDateTime := ZUSAGE;

              Post;
            end;
          end;
      else
        exception.create('Mehrere identischen Bestellpositionen!');
      end;
    end;
    BPosten.free;
  end;
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
      // imp pend: NOT MULTIUSER VALIDATED
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
          sDiagnose.add(cINFOText +
            ' Der Zahlungspflichtige wurde durch eine ELV Freigabe bestätigt!');
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

      sDiagnose.add(format('%s Konto=%s BLZ=%s Bank=%s validiert!', [cINFOText, KontoNummer, BLZ,
        BankName]));

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
          '(ARTIKEL_R is not null) and (AUSGABEART_R=' + inttostr(cAusgabeArt_Aufnahme_MP3)
          + ') and';

        // Modifikation speichern
        edit;
        FieldByName('INTERN_INFO').assign(INTERN_INFO);
        Post;

      end;
      qBELEG.free;
      INTERN_INFO.free;

      //
      e_w_BelegBuchen(BELEG_R);

      result := 1;

    until true;
  except
    on E: exception do
    begin
      ErrorStr := cERRORText + ' e_w_buchen(' + inttostr(BELEG_R) + ',' + inttostr(PERSON_R) + '): '
        + E.Message;
      sDiagnose.add(ErrorStr);
      CareTakerLog(ErrorStr);
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

function e_r_Lager(EINHEIT_R, AUSGABEART_R, ARTIKEL_R: integer): integer;
begin

  result := e_r_sql(
    { } 'select LAGER_R from ARTIKEL_AA where' +
    { } ' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') and' +
    { } ' (AUSGABEART_R' + isRID(AUSGABEART_R) + ') and' +
    { } ' (EINHEIT_R' + isRID(EINHEIT_R) + ')');

  if (result < cRID_FirstValid) then
    result := e_r_sql('select LAGER_R from ARTIKEL where' +
      { } ' RID=' + inttostr(ARTIKEL_R));

end;

function e_w_Menge(EINHEIT_R, AUSGABEART_R, ARTIKEL_R, MENGE: integer; BELEG_R: integer = 0;
  POSTEN_R: integer = 0): integer;
var
  ARTIKEL: TdboQuery;
  AA: TdboQuery;
  WARENBEWEGUNG: TdboQuery;
  MENGE_FieldName: string;
  MENGE_BISHER_0, MENGE_BISHER_1: integer;
  MENGE_NEU: integer;
  LAGER_R: integer;
  AlternativLagerEntnahme: boolean;
begin
  MENGE_BISHER_0 := cMenge_unbestimmt;
  MENGE_BISHER_1 := cMenge_unbestimmt;
  MENGE_NEU := cMenge_unbestimmt;
  LAGER_R := cRID_unset;
  result := 0;
  AlternativLagerEntnahme := false;
  try
    if (AUSGABEART_R >= cAusgabeArt_FirstRID) then
    begin

      // Menge in der Ausgabeart buchen
      AA := nQuery;
      with AA do
      begin
        sql.add('SELECT');
        sql.add(' MENGE_ALTERNATIV_LAGER,');
        sql.add(' LETZTERVERKAUF,');
        sql.add(' MINDESTBESTAND,');
        sql.add(' LAGER_R,');
        sql.add(' LAGER_ALTERNATIV_R,');
        sql.add(' MENGE');
        sql.add('FROM');
        sql.add(' ARTIKEL_AA');
        sql.add('WHERE');
        sql.add(' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') and');
        sql.add(' (AUSGABEART_R' + isRID(AUSGABEART_R) + ') and');
        sql.add(' (EINHEIT_R' + isRID(EINHEIT_R) + ')');
        for_update(sql);
        Open;
        if not(eof) then
        begin

          MENGE_BISHER_0 := FieldByName('MENGE').AsInteger;
          MENGE_BISHER_1 := FieldByName('MENGE_ALTERNATIV_LAGER').AsInteger;

          if (MENGE_BISHER_0 = 0) and (MENGE < 0) and (MENGE_BISHER_1 > 0) then
          begin

            // Nur Einzelverkäufe möglich
            if (MENGE <> -1) then
              raise exception.create('Entnahme aus Alternativ-Lager kann nur 1 sein!');

            // Lager muss bekannt sein, damit die Markierung gelingt
            LAGER_R := FieldByName('LAGER_ALTERNATIV_R').AsInteger;
            if (LAGER_R < cRID_FirstValid) then
              raise exception.create
                ('Bei Entnahme aus Alternativ-Lager muss der Lagerplatz definiert sein!');

            AlternativLagerEntnahme := true;
          end
          else
          begin
            LAGER_R := FieldByName('LAGER_R').AsInteger;
          end;

          if (FieldByName('MINDESTBESTAND').AsInteger = cMenge_unbegrenzt) then
          begin
            // keine Mengenbuchung, nur "letzer Verkauf" - Buchung
            if (MENGE < 0) then
            begin
              edit;
              FieldByName('LETZTERVERKAUF').AsDateTime := now;
              Post;
            end;
            result := MENGE_BISHER_0 + MENGE_BISHER_1;
          end
          else
          begin
            if AlternativLagerEntnahme then
              MENGE_NEU := MENGE_BISHER_1 + MENGE
            else
              MENGE_NEU := MENGE_BISHER_0 + MENGE;

            if (MENGE <> 0) then
            begin
              edit;
              if AlternativLagerEntnahme then
                FieldByName('MENGE_ALTERNATIV_LAGER').AsInteger := MENGE_NEU
              else
                FieldByName('MENGE').AsInteger := MENGE_NEU;
              if (MENGE < 0) then
                FieldByName('LETZTERVERKAUF').AsDateTime := now;
              Post;
            end;
            result := MENGE_NEU;
          end;
        end;
      end;
      AA.free;

    end
    else
    begin
      result := MaxInt;

      ARTIKEL := nQuery;
      with ARTIKEL do
      begin

        // MENGEN-Feld bestimmen
        repeat

          if (AUSGABEART_R = cAusgabeArt_Probestimme_PDF) then
          begin
            MENGE_FieldName := 'MENGE_PROBE';
            LAGER_R := e_r_Lager(EINHEIT_R, AUSGABEART_R, ARTIKEL_R);
            break;
          end;

          if (AUSGABEART_R = cAusgabeArt_Demoaufnahme_MP3) then
          begin
            MENGE_FieldName := 'MENGE_DEMO';
            LAGER_R := e_r_Lager(EINHEIT_R, AUSGABEART_R, ARTIKEL_R);
            break;
          end;

          MENGE_FieldName := 'MENGE';
          AlternativLagerEntnahme := true;
        until true;

        sql.add('SELECT');
        sql.add(' MENGE_ALTERNATIV_LAGER,');
        sql.add(' LETZTERVERKAUF,');
        sql.add(' MINDESTBESTAND,');
        sql.add(' LAGER_R,');
        sql.add(' LAGER_ALTERNATIV_R,');
        sql.add(' ' + MENGE_FieldName);
        sql.add('FROM');
        sql.add(' ARTIKEL');
        sql.add('WHERE');
        sql.add(' (RID=' + inttostr(ARTIKEL_R) + ')');
        for_update(sql);
        Open;
        if not(eof) then
        begin
          //
          if (LAGER_R < cRID_FirstValid) then
            LAGER_R := FieldByName('LAGER_R').AsInteger;

          //
          MENGE_BISHER_0 := FieldByName(MENGE_FieldName).AsInteger;
          MENGE_BISHER_1 := FieldByName('MENGE_ALTERNATIV_LAGER').AsInteger;

          if (FieldByName('MINDESTBESTAND').AsInteger = cMenge_unbegrenzt) then
          begin
            // keine Mengenbuchung, nur "letzer Verkauf" - Buchung
            if (MENGE < 0) then
            begin
              edit;
              FieldByName('LETZTERVERKAUF').AsDateTime := now;
              Post;
            end;
            result := MENGE_BISHER_0 + MENGE_BISHER_1;
          end
          else
          begin

            if AlternativLagerEntnahme and (MENGE_BISHER_0 = 0) and (MENGE_BISHER_1 > 0) and
              (MENGE < 0) then
            begin

              MENGE_NEU := MENGE_BISHER_1 + MENGE;

              // Aus dem Alternativ-Lager entnehmen!
              // Nur Einzelverkäufe möglich
              if (MENGE <> -1) then
                raise exception.create('Entnahmemenge aus Alternativ-Lager kann nur 1 sein!');

              // Lager muss bekannt sein, damit die Markierung gelingt
              LAGER_R := FieldByName('LAGER_ALTERNATIV_R').AsInteger;
              if (LAGER_R < cRID_FirstValid) then
                raise exception.create
                  ('Bei Entnahme aus Alternativ-Lager muss der Lagerplatz definiert sein!');

              edit;
              FieldByName('MENGE_ALTERNATIV_LAGER').AsInteger := MENGE_NEU;
              FieldByName('LETZTERVERKAUF').AsDateTime := now;
              Post;

              result := MENGE_BISHER_0 + MENGE_NEU;
            end
            else
            begin
              AlternativLagerEntnahme := false;
              MENGE_NEU := MENGE_BISHER_0 + MENGE;
              if (MENGE <> 0) and (MENGE_NEU <> MENGE_BISHER_0) then
              begin
                edit;

                // nur eim Einlagern
                // LAGER zuteilen, wenn benötigt!
                if (MENGE > 0) and (LAGER_R < cRID_FirstValid) and (MENGE_BISHER_0 <= 0) then
                begin
                  LAGER_R := e_w_EinLagern(ARTIKEL_R);
                  if (LAGER_R >= cRID_FirstValid) then
                    FieldByName('LAGER_R').AsInteger := LAGER_R;
                end;

                // MENGE_NEU
                FieldByName(MENGE_FieldName).AsInteger := MENGE_NEU;
                if (MENGE < 0) then
                  FieldByName('LETZTERVERKAUF').AsDateTime := now;

                Post;
                result := MENGE_BISHER_1 + MENGE_NEU;
              end;
            end;
          end;
        end;
      end;
      ARTIKEL.free;

    end;

    if (MENGE <> 0) then
    begin
      //
      // --- Warenbewegung Log schreiben ---
      //
      // Situationen: Mengenbuchungen durch Abverkäufe!
      //
      //
      WARENBEWEGUNG := nQuery;
      with WARENBEWEGUNG do
      begin
{$IFDEF fpc}
        Raise exception.create('Columnattributes');
{$ELSE}
        ColumnAttributes.add('RID=NOTREQUIRED');
        ColumnAttributes.add('AUFTRITT=NOTREQUIRED');
{$ENDIF}
        sql.add('select * from WARENBEWEGUNG ' + for_update);
        Insert;
        FieldByName('BRISANZ').AsInteger := eT_MotivationKundenAuftrag;
        FieldByName('MENGE').AsInteger := MENGE;
        FieldByName('MENGE_BISHER').AsInteger := MENGE_BISHER_0 + MENGE_BISHER_1;
        FieldByName('MENGE_NEU').AsInteger := result;

        FieldByName('ARTIKEL_R').AsInteger := ARTIKEL_R;
        if (AUSGABEART_R >= cRID_FirstValid) then
          FieldByName('AUSGABEART_R').AsInteger := AUSGABEART_R;
        if (EINHEIT_R >= cRID_FirstValid) then
          FieldByName('EINHEIT_R').AsInteger := EINHEIT_R;

        if (sBearbeiter >= cRID_FirstValid) then
          FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
        if (POSTEN_R >= cRID_FirstValid) then
          FieldByName('POSTEN_R').AsInteger := POSTEN_R;
        if (BELEG_R >= cRID_FirstValid) then
          FieldByName('BELEG_R').AsInteger := BELEG_R;
        if (LAGER_R >= cRID_FirstValid) then
          FieldByName('LAGER_R').AsInteger := LAGER_R;
        FieldByName('ALTERNATIV').AsString := bool2cC(AlternativLagerEntnahme);

        Post;
        Close;
      end;
      WARENBEWEGUNG.free;
    end;
  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_w_Menge: ' + E.Message);
    end;
  end;
end;

function e_r_ArtikelDokument(AUSGABEART_R, ARTIKEL_R, MEDIUM_R: integer): integer;
begin
  result := e_r_sql(
    { } 'select MAX(RID) from DOKUMENT where' +
    { } ' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') and' +
    { } ' (MEDIUM_R=' + inttostr(MEDIUM_R) + ')');
end;

function e_r_Menge(EINHEIT_R, AUSGABEART_R, ARTIKEL_R: integer): integer;

  procedure GetFromArtikelField(FieldN: string; AuchAlternativLager: boolean = true);
  var
    cARTIKEL: TdboCursor;
  begin
    cARTIKEL := nCursor;
    with cARTIKEL do
    begin
      sql.add('SELECT');
      if AuchAlternativLager then
        sql.add(' MENGE_ALTERNATIV_LAGER,');
      sql.add(' MINDESTBESTAND,');
      sql.add(' ' + FieldN);
      sql.add('FROM');
      sql.add(' ARTIKEL');
      sql.add('WHERE');
      sql.add(' (RID=' + inttostr(ARTIKEL_R) + ')');
      ApiFirst;
      if eof then
      begin
        result := cMenge_unbestimmt;
      end
      else
      begin
        if (FieldByName('MINDESTBESTAND').AsInteger <> cMenge_unbegrenzt) then
        begin
          result := FieldByName(FieldN).AsInteger;
          if AuchAlternativLager then
            inc(result, FieldByName('MENGE_ALTERNATIV_LAGER').AsInteger);
        end;
      end;
    end;
    cARTIKEL.free;
  end;

  procedure GetFromAA;
  var
    cAA: TdboCursor;
  begin
    cAA := nCursor;
    with cAA do
    begin
      sql.add('SELECT');
      sql.add(' MENGE_ALTERNATIV_LAGER,');
      sql.add(' MINDESTBESTAND,');
      sql.add(' MENGE');
      sql.add('FROM');
      sql.add(' ARTIKEL_AA');
      sql.add('WHERE');
      sql.add(' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') and');
      sql.add(' (AUSGABEART_R' + isRID(AUSGABEART_R) + ') and');
      sql.add(' (EINHEIT_R' + isRID(EINHEIT_R) + ')');
      ApiFirst;
      if not(eof) then
      begin
        if (FieldByName('MINDESTBESTAND').AsInteger <> cMenge_unbegrenzt) then
          result :=
          { } FieldByName('MENGE').AsInteger +
          { } FieldByName('MENGE_ALTERNATIV_LAGER').AsInteger;
      end;
    end;
    cAA.free;
  end;

begin

  // unbegrenzte Anzahl vorhanden!
  result := cMenge_max;

  //
  repeat

    // nicht existierende Artikel gibt es in unbegrenzter Anzahl
    if (ARTIKEL_R < cRID_FirstValid) then
      break;

    // ohne Ausgabeart
    if (AUSGABEART_R < cRID_FirstValid) then
    begin
      GetFromArtikelField('MENGE');
      break;
    end;

    // Ausgabeart "1"
    if (AUSGABEART_R = cAusgabeArt_Probestimme_PDF) then
    begin
      GetFromArtikelField('MENGE_PROBE', false);
      break;
    end;

    // Ausgabeart "2"
    if (AUSGABEART_R = cAusgabeArt_Demoaufnahme_MP3) then
    begin
      GetFromArtikelField('MENGE_DEMO', false);
      break;
    end;

    // Ausgabeart "9"
    if (AUSGABEART_R = cAusgabeArt_Aufnahme_MP3) then
      break;

    // weitere konkrete Ausgabearten
    GetFromAA;

  until true;

end;

function e_w_SetFolge(AUSGABEART_R, ARTIKEL_R: integer): integer; // Beleg-Anz
var
  RIDS: TgpIntegerList;
  RecN: integer;
  cFOLGE: TdboQuery;
begin
  // Ermitteln der "ursprünglichen Reihenfolge"
  RIDS := TgpIntegerList.create;
  cFOLGE := nQuery;
  with cFOLGE do
  begin

    //
    sql.add('select RID,FOLGE from BPOSTEN where ');
    sql.add(' (MENGE_ERWARTET>0) AND');
    sql.add(e_r_sqlArtikelWhere(AUSGABEART_R, ARTIKEL_R));
    sql.add('order by ZUSAGE,RID');
    for_update(sql);
    Open;
    First;
    while not(eof) do
    begin
      RIDS.add(FieldByName('RID').AsInteger);
      Next;
    end;

    //
    result := RIDS.count;
    if (RIDS.count > 0) then
    begin
      RIDS.sort;
      RecN := 0;
      First;
      while not(eof) do
      begin
        edit;
        FieldByName('FOLGE').AsInteger := RIDS[RecN];
        inc(RecN);
        Post;
        Next;
      end;
    end;
    Close;

  end;
  RIDS.free;
  cFOLGE.free;
end;

function e_w_Wareneingang(AUSGABEART_R, ARTIKEL_R, MENGE: integer): integer;
// ZUSAMMENHANG

  function AusgabeArtCompare: string;
  begin
    if (AUSGABEART_R <= cAUSGABEART_OHNE) then
      result := ' IS NULL'
    else
      result := ' = ' + inttostr(AUSGABEART_R);
  end;

var
  QueryPOSTEN: TdboQuery;
  QueryBPOSTEN: TdboQuery;
  ARTIKEL: TdboQuery;
  DontBook: boolean;
  _Menge: integer;
  MENGE_BISHER, MENGE_NEU: integer;
  AtomMenge: integer;
  WARENBEWEGUNG: TdboQuery;
  EREIGNIS: TdboQuery;
  EventText: TStringList;
  LAGER_R: integer;
  BBELEG_R: integer;
  BELEG_R: integer;
begin

  // neuen Zusammenhang beginnen
  result := e_w_GEN('GEN_ZUSAMMENHANG');
  try

    //
    // 1) BBELEG.BPOSTEN: MENGE_ERWARTET auf MENGE_GELIEFERT buchen
    // das geschieht in einer schleife
    // 2) BELEG.POSTEN: MENGE_AGENT auf MENGE_RECHNUNG buchen
    // 3) Restmenge in das Mengen Feld des Artikels (LAGER)
    //

    // erst mal die erwarteten Menge zurücksetzen
    // dabei sollte der User eine mögliche Reihenfolge vorgeben können
    _Menge := MENGE;
    QueryBPOSTEN := nQuery;
    with QueryBPOSTEN do
    begin
      sql.add('SELECT');
      sql.add(' *');
      sql.add('FROM');
      sql.add(' BPOSTEN');
      sql.add('WHERE');
      sql.add(' (BELEG_R IS NOT NULL) AND');
      sql.add(' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') AND');
      sql.add(' (AUSGABEART_R' + AusgabeArtCompare + ') AND');
      sql.add(' (MENGE_ERWARTET>0) AND');
      sql.add(' (MOTIVATION>=10)');
      sql.add('ORDER BY');
      sql.add(' FOLGE,ZUSAGE,RID');
      for_update(sql);

      Open;

      // den aktuellen Zusammenhang festlegen!
      while not(eof) do
      begin

        // Erwartete Mengen befriedigen
        AtomMenge := min(FieldByName('MENGE_ERWARTET').AsInteger, _Menge);
        edit;
        if FieldByName('MENGE_ERWARTET').AsInteger = AtomMenge then
          FieldByName('MENGE_ERWARTET').clear
        else
          FieldByName('MENGE_ERWARTET').AsInteger := FieldByName('MENGE_ERWARTET').AsInteger -
            AtomMenge;
        FieldByName('MENGE_GELIEFERT').AsInteger := FieldByName('MENGE_GELIEFERT').AsInteger +
          AtomMenge;
        Post;

        //
        BBELEG_R := FieldByName('BELEG_R').AsInteger;

        //
        e_w_BBelegStatusBuchen(BBELEG_R);

        // Ereignis "Wareneingang" buchen!
        EREIGNIS := nQuery;
        with EREIGNIS do
        begin
{$IFNDEF fpc}
          ColumnAttributes.add('RID=NOTREQUIRED');
          ColumnAttributes.add('AUFTRITT=NOTREQUIRED');
{$ENDIF}
          sql.add('select * from EREIGNIS ' + for_update);
          Insert;
          FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
          FieldByName('ART').AsInteger := eT_WareEingetroffen;
          FieldByName('PERSON_R').AsInteger :=
            e_r_sql('select PERSON_R from BBELEG where RID=' + inttostr(BBELEG_R));
          FieldByName('ARTIKEL_R').assign(QueryBPOSTEN.FieldByName('ARTIKEL_R'));
          FieldByName('AUSGABEART_R').assign(QueryBPOSTEN.FieldByName('AUSGABEART_R'));
          FieldByName('BBELEG_R').AsInteger := BBELEG_R;
          FieldByName('BPOSTEN_R').assign(QueryBPOSTEN.FieldByName('RID'));
          FieldByName('MENGE').AsInteger := AtomMenge;
          EventText := TStringList.create;
          EventText.add(format('Wareneingang: %dx %s!',
            [AtomMenge, e_r_Artikel(QueryBPOSTEN.FieldByName('AUSGABEART_R').AsInteger,
            QueryBPOSTEN.FieldByName('ARTIKEL_R').AsInteger)]));
          FieldByName('INFO').assign(EventText);
          EventText.free;
          Post;
        end;
        EREIGNIS.free;

        dec(_Menge, AtomMenge);
        if (_Menge = 0) then
          break;
        Next;
      end;
      Close;
    end;

    // nun die Agent Mengen->auf Ü-Fächer verteilen!
    QueryPOSTEN := nQuery;
    _Menge := MENGE;
    with QueryPOSTEN do
    begin
      sql.add('SELECT');
      sql.add(' *');
      sql.add('FROM');
      sql.add(' POSTEN');
      sql.add('WHERE');
      sql.add(' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') AND');
      sql.add(' (AUSGABEART_R' + AusgabeArtCompare + ') AND');
      sql.add(' (MENGE_AGENT>0)');
      sql.add('ORDER BY');
      sql.add(' ZUSAGE');
      for_update(sql);

      Open;
      while not(eof) do
      begin

        // Menge zurückbuchen
        AtomMenge := min(FieldByName('MENGE_AGENT').AsInteger, _Menge);
        edit;
        if (FieldByName('MENGE_AGENT').AsInteger = AtomMenge) then
          FieldByName('MENGE_AGENT').clear
        else
          FieldByName('MENGE_AGENT').AsInteger := FieldByName('MENGE_AGENT').AsInteger - AtomMenge;
        FieldByName('MENGE_RECHNUNG').AsInteger := FieldByName('MENGE_RECHNUNG').AsInteger +
          AtomMenge;
        Post;

        // dem Beleg die Änderung bekanntmachen
        BELEG_R := FieldByName('BELEG_R').AsInteger;
        e_w_BelegStatusBuchen(BELEG_R);

        // das aktuelle Übergangsfach des Belegs bestimmen
        LAGER_R := e_r_sql('select LAGER_R from BELEG where RID=' + inttostr(BELEG_R));

        // Warenbewegung dokumentieren
        WARENBEWEGUNG := nQuery;
        with WARENBEWEGUNG do
        begin
{$IFNDEF fpc}
          ColumnAttributes.add('RID=NOTREQUIRED');
          ColumnAttributes.add('AUFTRITT=NOTREQUIRED');
{$ENDIF}
          sql.add('SELECT * FROM WARENBEWEGUNG ' + for_update);
          Insert;
          if (AUSGABEART_R > 0) then
            FieldByName('AUSGABEART_R').AsInteger := AUSGABEART_R;
          FieldByName('ARTIKEL_R').AsInteger := ARTIKEL_R;
          FieldByName('MENGE').AsInteger := AtomMenge;
          FieldByName('POSTEN_R').AsInteger := QueryPOSTEN.FieldByName('RID').AsInteger;
          FieldByName('BELEG_R').AsInteger := BELEG_R;
          // Ü-Fach
          if LAGER_R > 0 then
            FieldByName('LAGER_R').AsInteger := LAGER_R;
          if (sBearbeiter > 0) then
            FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
          FieldByName('BRISANZ').AsInteger := eT_MotivationKundenAuftrag;
          Post;
        end;
        WARENBEWEGUNG.free;

        dec(_Menge, AtomMenge);
        if (_Menge = 0) then
          break;
        Next;
      end;
      Close;
    end;

    if (_Menge > 0) then
    begin

      LAGER_R := e_r_Lager(cRID_Null, AUSGABEART_R, ARTIKEL_R);

      // Rest auf Lager!!
      ARTIKEL := nQuery;
      with ARTIKEL do
      begin
        sql.add('SELECT');
        sql.add(' LAGER_R,');

        DontBook := false;
        repeat

          if (AUSGABEART_R = cAUSGABEART_OHNE) then
          begin
            sql.add('MENGE M');
            break;
          end;

          if (AUSGABEART_R = cAusgabeArt_Probestimme_PDF) then
          begin
            sql.add('MENGE_PROBE M');
            break;
          end;

          if (AUSGABEART_R = cAusgabeArt_Demoaufnahme_MP3) then
          begin
            sql.add('MENGE_DEMO M');
            break;
          end;

          DontBook := true;

        until true;

        if not(DontBook) then
        begin
          sql.add('FROM ARTIKEL WHERE (RID=' + inttostr(ARTIKEL_R) + ')');
          for_update(sql);
          Open;

          MENGE_BISHER := FieldByName('M').AsInteger;
          MENGE_NEU := MENGE_BISHER + _Menge;
          if (LAGER_R < cRID_FirstValid) then
            LAGER_R := e_w_EinLagern(ARTIKEL_R);

          // Warenbewegung eintragen
          WARENBEWEGUNG := nQuery;
          with WARENBEWEGUNG do
          begin
{$IFNDEF fpc}
            ColumnAttributes.add('RID=NOTREQUIRED');
            ColumnAttributes.add('AUFTRITT=NOTREQUIRED');
{$ENDIF}
            sql.add('SELECT * FROM WARENBEWEGUNG ' + for_update);
            Insert;
            if (AUSGABEART_R > 0) then
              FieldByName('AUSGABEART_R').AsInteger := AUSGABEART_R;
            FieldByName('ARTIKEL_R').AsInteger := ARTIKEL_R;
            if (sBearbeiter > 0) then
              FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
            FieldByName('MENGE_BISHER').AsInteger := MENGE_BISHER;
            FieldByName('MENGE_NEU').AsInteger := MENGE_NEU;
            FieldByName('MENGE').AsInteger := _Menge;
            if (LAGER_R >= cRID_FirstValid) then
              FieldByName('LAGER_R').AsInteger := LAGER_R;
            FieldByName('BRISANZ').AsInteger :=
              (eT_MotivationMindestbestand + eT_MotivationManuell) div 2;
            Post;
          end;
          WARENBEWEGUNG.free;

          // Mengen Buchung
          edit;
          FieldByName('M').AsInteger := MENGE_NEU;
          if (LAGER_R >= cRID_FirstValid) then
            FieldByName('LAGER_R').AsInteger := LAGER_R;
          Post;
          Close;
        end;
      end;
      ARTIKEL.free;
    end;

    //
    QueryPOSTEN.free;
    QueryBPOSTEN.free;

  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_w_WarenEingang.' + inttostr(result) + ': ' + E.Message);
      result := -1;
    end;
  end;
end;

procedure e_w_Zwischenlagern(BELEG_R, LAGER_R: integer);
begin
  if (LAGER_R < cRID_FirstValid) then
    e_x_sql('update BELEG set LAGER_R=null where RID=' + inttostr(BELEG_R))
  else
    e_x_sql('update BELEG set LAGER_R=' + inttostr(LAGER_R) + ' where RID=' + inttostr(BELEG_R));
end;

function e_r_MwSt(SORTIMENT_R: integer): double; overload;
begin
  result := e_r_sqld('select MWST.SATZ from MWST where RID=(select MWST_R from SORTIMENT WHERE RID='
    + inttostr(SORTIMENT_R) + ')');
end;

function e_r_MwSt(AUSGABEART_R, ARTIKEL_R: integer): double; overload;
begin
  if (ARTIKEL_R > 0) then
  begin
    result := e_r_MwSt(e_r_sql('select SORTIMENT_R from ARTIKEL where RID=' + inttostr(ARTIKEL_R)));
  end
  else
  begin
    result := 0;
  end;
end;


// Preis-Tabelle-Caching
// dieser Code sollte Autogeneriert sein, is aber nicht!

const
  e_r_PreisTabelle_CacheL: TGpIntegerObjectList = nil;

procedure invalidate_e_r_PreisTabelleCache;
begin
  if assigned(e_r_PreisTabelle_CacheL) then
    FreeAndNil(e_r_PreisTabelle_CacheL);
end;

procedure e_r_PreisTabelle_ensureCache;
var
  cPREIS: TdboCursor;
  cLAND: TdboCursor;
  p: double;
  g: TGeldBetrag;
begin

  if not(assigned(e_r_PreisTabelle_CacheL)) then
  begin

    //
    e_r_PreisTabelle_CacheL := TGpIntegerObjectList.create();
    cPREIS := nCursor;
    cLAND := nCursor;

    with cLAND do
    begin
      sql.add('SELECT KURS FROM LAND WHERE RID=:CROSSREF');
      Open;
    end;

    with cPREIS do
    begin
      sql.add('select RID,WAEHRUNG_R,PREIS,EURO from PREIS');
      ApiFirst;
      while not(eof) do
      begin

        p := cPreis_aufAnfrage;

        if FieldByName('EURO').IsNull and not(FieldByName('PREIS').IsNull) and
          not(FieldByName('WAEHRUNG_R').IsNull) then
        begin
          // Umrechnen der Auslandswährung auf €
          cLAND.ParamByName('CROSSREF').AsInteger := FieldByName('WAEHRUNG_R').AsInteger;
          p := cPreisRundung(FieldByName('PREIS').AsFloat * cLAND.FieldByName('KURS').AsFloat);

        end
        else
        begin
          //
          if not(FieldByName('EURO').IsNull) then
            p := FieldByName('EURO').AsFloat
        end;

        g := TGeldBetrag.create;
        g.Betrag := p;
        e_r_PreisTabelle_CacheL.AddObject(FieldByName('RID').AsInteger, g);
        ApiNext;
      end;
      e_r_PreisTabelle_CacheL.sort;

    end;
    cPREIS.free;
    cLAND.free;
  end;
end;

function e_r_PreisTabelle(PREIS_R: integer): double;
var
  i: integer;
begin
  e_r_PreisTabelle_ensureCache;
  i := e_r_PreisTabelle_CacheL.IndexOf(PREIS_R);
  if (i <> -1) then
    result := TGeldBetrag(e_r_PreisTabelle_CacheL.Objects[i]).Betrag
  else
    result := cPreis_aufAnfrage;
end;

const
  e_r_PreisNativ_cARTIKEL: TdboCursor = nil;
  e_r_PreisNativ_cAA: TdboCursor = nil;

procedure e_r_PreisNativ_ensureCache;
begin
  // SQL schon offen?
  if not(assigned(e_r_PreisNativ_cARTIKEL)) then
  begin
    e_r_PreisNativ_cARTIKEL := nCursor;
    with e_r_PreisNativ_cARTIKEL do
    begin
      sql.add('SELECT');
      sql.add(' PREIS_R,');
      sql.add(' EURO');
      sql.add('FROM');
      sql.add(' ARTIKEL');
      sql.add('WHERE');
      sql.add(' RID=:CR_AR');
      Open;
    end;
    e_r_PreisNativ_cAA := nCursor;
    with e_r_PreisNativ_cAA do
    begin
      sql.add('SELECT');
      sql.add(' PREIS_R,');
      sql.add(' EURO');
      sql.add('FROM');
      sql.add(' ARTIKEL_AA');
      sql.add('WHERE');
      sql.add(' (ARTIKEL_R=:CR_AR) and');
      sql.add(' (AUSGABEART_R=:CR_AA)');
      Open;
    end;
  end;
end;

function e_r_PreisNativ(AUSGABEART_R, ARTIKEL_R: integer): double;
var
  cARTIKEL: TdboCursor;
begin
  result := cPreis_aufAnfrage;
  try

    e_r_PreisNativ_ensureCache;
    // Artikel Infos laden
    if (AUSGABEART_R < cRID_FirstValid) then
    begin
      cARTIKEL := e_r_PreisNativ_cARTIKEL;
      cARTIKEL.ParamByName('CR_AR').AsInteger := ARTIKEL_R;
    end
    else
    begin
      cARTIKEL := e_r_PreisNativ_cAA;
      with cARTIKEL do
      begin
        Params.BeginUpdate;
        ParamByName('CR_AR').AsInteger := ARTIKEL_R;
        ParamByName('CR_AA').AsInteger := AUSGABEART_R;
{$IFDEF fpc}
        Params.EndUpdate;
{$ELSE}
        Params.EndUpdate(true);
{$ENDIF}
      end;
    end;

    with cARTIKEL do
    begin

      ApiFirst;
      if not(eof) then
      begin
        //
        if not(FieldByName('PREIS_R').IsNull) then
        begin
          result := e_r_PreisTabelle(FieldByName('PREIS_R').AsInteger);
        end
        else
        begin
          if not(FieldByName('EURO').IsNull) then
            result := FieldByName('EURO').AsFloat
          else
            result := cPreis_aufAnfrage;
        end;
      end
      else
      begin
        // EOF!!
        if (AUSGABEART_R < cRID_FirstValid) then
          result := cPreis_vergriffen
        else
          result := cPreis_aufAnfrage;
      end;
    end;
  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_r_PreisNativ(' + inttostr(AUSGABEART_R) + ',' +
        inttostr(ARTIKEL_R) + '): ' + E.Message);
    end;
  end;
end;

const
  e_r_PreisAusgabeart_MUSTER_R: TDOM_Reference = cRID_unset;

function e_r_PreisAusgabeart(AUSGABEART_R: TDOM_Reference): TDOM_Reference;
begin
  result := cRID_Null;
  repeat

    if (AUSGABEART_R <> cAusgabeArt_Aufnahme_MP3) then
      break;

    if (e_r_PreisAusgabeart_MUSTER_R = cRID_unset) then
    begin
      e_r_PreisAusgabeart_MUSTER_R := e_r_sql(
        { } 'select ARTIKEL_R ' +
        { } 'from AUSGABEART ' +
        { } 'where' +
        { } ' (RID=' + inttostr(cAusgabeArt_Aufnahme_MP3) + ')');
    end;

    result := e_r_PreisAusgabeart_MUSTER_R;

  until true;
end;

const
  e_r_SortimentSatz_Steuer: TGpIntegerObjectList = nil;

procedure e_r_SortimentSatz_EnsureCache;
var
  cSORTIMENT: TdboCursor;
  s: TSteuerSatz;
begin
  if not(assigned(e_r_SortimentSatz_Steuer)) then
  begin

    e_r_SortimentSatz_Steuer := TGpIntegerObjectList.create;

    // default Datensatz anlegen
    s := TSteuerSatz.create;
    with s do
    begin
      Satz := 0.0;
      Netto := false;
      NettoWieBrutto := false;
    end;
    e_r_SortimentSatz_Steuer.AddObject(0, s);

    cSORTIMENT := nCursor;
    with cSORTIMENT do
    begin
      sql.add('select');
      sql.add(' SORTIMENT.RID, SORTIMENT.NETTO, SORTIMENT.NETTO_WIE_BRUTTO, MWST.SATZ');
      sql.add('from ARTIKEL');
      sql.add('left JOIN SORTIMENT ON');
      sql.add(' (ARTIKEL.SORTIMENT_R=SORTIMENT.RID)');
      sql.add('left JOIN MWST ON');
      sql.add(' (SORTIMENT.MWST_R=MWST.RID)');
      ApiFirst;
      while not(eof) do
      begin
        s := TSteuerSatz.create;
        with s do
        begin
          Satz := FieldByName('SATZ').AsFloat;
          Netto := (FieldByName('NETTO').AsString = cC_True);
          NettoWieBrutto := (FieldByName('NETTO_WIE_BRUTTO').AsString = cC_True);
        end;
        e_r_SortimentSatz_Steuer.AddObject(
          { } FieldByName('RID').AsInteger,
          { } s);
        ApiNext;
      end;
    end;
    cSORTIMENT.free;
    e_r_SortimentSatz_Steuer.sort;
  end;

end;

function e_r_SortimentSatz(SORTIMENT_R: integer): TSteuerSatz;
var
  i: integer;
begin
  e_r_SortimentSatz_EnsureCache;
  i := e_r_SortimentSatz_Steuer.IndexOf(SORTIMENT_R);
  if (i <> -1) then
    result := TSteuerSatz(e_r_SortimentSatz_Steuer.Objects[i])
  else
    result := TSteuerSatz(e_r_SortimentSatz_Steuer.Objects[0]);
end;

const
  e_r_Preis_ARTIKEL: TdboCursor = nil;
  e_r_Preis_AA: TdboCursor = nil;
  e_r_Preis_AA_EINHEIT: TdboCursor = nil;

procedure e_r_Preis_ensureCache;
begin
  if not(assigned(e_r_Preis_ARTIKEL)) then
  begin

    e_r_Preis_ARTIKEL := nCursor;
    with e_r_Preis_ARTIKEL do
    begin
      sql.add('SELECT');
      sql.add(' PREIS_R,');
      sql.add(' EURO,');
      sql.add(' SORTIMENT_R');
      sql.add('FROM');
      sql.add(' ARTIKEL');
      sql.add('WHERE');
      sql.add(' (RID=:CROSSREF)');
      Open;
    end;

    e_r_Preis_AA := nCursor;
    with e_r_Preis_AA do
    begin
      sql.add('SELECT');
      sql.add(' PREIS_R,');
      sql.add(' EURO');
      sql.add('FROM');
      sql.add(' ARTIKEL_AA');
      sql.add('WHERE');
      sql.add(' (EINHEIT_R is null) and');
      sql.add(' (ARTIKEL_R=:CR_AR) and');
      sql.add(' (AUSGABEART_R=:CR_AA)');
      Open;
    end;

    e_r_Preis_AA_EINHEIT := nCursor;
    with e_r_Preis_AA_EINHEIT do
    begin
      sql.add('SELECT');
      sql.add(' PREIS_R,');
      sql.add(' EURO');
      sql.add('FROM');
      sql.add(' ARTIKEL_AA');
      sql.add('WHERE');
      sql.add(' (EINHEIT_R=:CR_ER) and');
      sql.add(' (ARTIKEL_R=:CR_AR) and');
      sql.add(' (AUSGABEART_R=:CR_AA)');
      Open;
    end;

  end;

end;

function e_r_Preis(EINHEIT_R, AUSGABEART_R, ARTIKEL_R: integer; var Satz: double;
  var Netto: boolean; var NettoWieBrutto: boolean): double;
var
  s: TSteuerSatz;
  cARTIKEL: TdboCursor;
begin

  //
  result := cPreis_aufAnfrage;

  // Es kann sein, dass mit (ARTIKEL_R=cRID_Null) gerufen wird
  if (ARTIKEL_R < cRID_FirstValid) then
    exit;

  try

    e_r_Preis_ensureCache;

    // Sortiment-Infos laden
    with e_r_Preis_ARTIKEL do
    begin
      ParamByName('CROSSREF').AsInteger := ARTIKEL_R;
      ApiFirst;
      s := e_r_SortimentSatz(FieldByName('SORTIMENT_R').AsInteger);
      Satz := s.Satz;
      Netto := s.Netto;
      NettoWieBrutto := s.NettoWieBrutto;
    end;

    // Abfrage-Methode bestimmen
    if (AUSGABEART_R < cRID_FirstValid) then
    begin
      cARTIKEL := e_r_Preis_ARTIKEL;
    end
    else
    begin
      if (EINHEIT_R < cRID_FirstValid) then
      begin
        cARTIKEL := e_r_Preis_AA;
        with cARTIKEL do
        begin
          Params.BeginUpdate;
          ParamByName('CR_AR').AsInteger := ARTIKEL_R;
          ParamByName('CR_AA').AsInteger := AUSGABEART_R;
{$IFDEF fpc}
          Params.EndUpdate;
{$ELSE}
          Params.EndUpdate(true);
{$ENDIF}
          ApiFirst;
        end;
      end
      else
      begin
        cARTIKEL := e_r_Preis_AA_EINHEIT;
        with cARTIKEL do
        begin
          Params.BeginUpdate;
          ParamByName('CR_ER').AsInteger := EINHEIT_R;
          ParamByName('CR_AR').AsInteger := ARTIKEL_R;
          ParamByName('CR_AA').AsInteger := AUSGABEART_R;
{$IFDEF fpc}
          Params.EndUpdate;
{$ELSE}
          Params.EndUpdate(true);
{$ENDIF}
          ApiFirst;
        end;
      end;
    end;

    with cARTIKEL do
    begin

      if not(eof) then
      begin

        // info ok
        if not(FieldByName('PREIS_R').IsNull) then
        begin
          result := e_r_PreisTabelle(FieldByName('PREIS_R').AsInteger);
        end
        else
        begin
          if not(FieldByName('EURO').IsNull) then
          begin
            result := FieldByName('EURO').AsFloat
          end
          else
            result := e_r_Preis(
              { } EINHEIT_R,
              { } cRID_Null,
              { } e_r_PreisAusgabeart(AUSGABEART_R),
              { } Satz,
              { } Netto,
              { } NettoWieBrutto);
        end;
      end
      else
      begin
        // EOF in ARTIKEL oder ARTIKEL_AA!!
        repeat

          // Artikel eben gar nicht mehr gefunden!
          if (AUSGABEART_R < cRID_FirstValid) then
          begin
            result := cPreis_vergriffen;
            break;
          end;

          result := e_r_Preis(
            { } EINHEIT_R,
            { } cRID_Null,
            { } e_r_PreisAusgabeart(AUSGABEART_R),
            { } Satz,
            { } Netto,
            { } NettoWieBrutto);

        until true;
      end;
    end;
  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_r_Preis(' + inttostr(AUSGABEART_R) + ',' + inttostr(ARTIKEL_R) +
        '): ' + E.Message);
    end;
  end;
end;

function e_r_PreisNetto(AUSGABEART_R, ARTIKEL_R: integer): double;
var
  Satz: double;
  Netto: boolean;
  NettoWieBrutto: boolean;
begin
  result := e_r_Preis(cRID_Null, AUSGABEART_R, ARTIKEL_R, Satz, Netto, NettoWieBrutto);
  if not(Netto) then
    if e_r_PreisValid(result) then
      result := cNetto(Satz, result);
end;

function e_r_PreisBrutto(AUSGABEART_R, ARTIKEL_R: integer): double;
var
  Satz: double;
  Netto: boolean;
  NettoWieBrutto: boolean;
begin
  result := e_r_Preis(cRID_Null, AUSGABEART_R, ARTIKEL_R, Satz, Netto, NettoWieBrutto);
  if Netto then
    if e_r_PreisValid(result) then
      result := cBrutto(Satz, result);
end;

function e_r_USD(ARTIKEL_R: integer): double;
var
  Satz: double;
  Netto: boolean;
  NettoWieBrutto: boolean;
  cPREIS: TdboCursor;
begin
  result := cPreis_unbekannt;
  try
    result := e_r_Preis(cRID_Null, 0, ARTIKEL_R, Satz, Netto, NettoWieBrutto);
    if e_r_PreisValid(result) then
    begin
      result := cPreis_aufAnfrage;
      cPREIS := nCursor;
      with cPREIS do
      begin
        sql.add('select PREIS.USD from ARTIKEL ' + 'join PREIS on ' + ' (ARTIKEL.PREIS_R=PREIS.RID)'
          + 'where ' + ' (ARTIKEL.RID=' + inttostr(ARTIKEL_R) + ') and' +
          ' (ARTIKEL.PREIS_R is not null) and' + ' (PREIS.USD is not null)');
        ApiFirst;
        if not(eof) then
          result := FieldByName('USD').AsFloat;
      end;
      cPREIS.free;
    end;
  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_r_USD.' + inttostr(ARTIKEL_R) + ': ' + E.Message);
    end;
  end;
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
      result := MyProgramPath + cMahnbescheidPath + inttostrN(MahnbescheidTAN, 4) + '\' +
        RIDasStr(PERSON_R) + '\';
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
      FileCopy(e_r_MahnungFName(PERSON_R), OutPath + 'Mahnung_' + inttostr(DateGet) +
        chtmlextension);
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
      sql.add('select * from ANSCHRIFT where RID=' + cPERSON.FieldByName('PRIV_ANSCHRIFT_R')
        .AsString);
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

    DatensammlerGlobal.add('Titel=' + _('Kontoinformation K#') + ' ' + cPERSON.FieldByName('NUMMER')
      .AsString);
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

            // Micro - Ausgeglichenheit in dieser Teillieferung prüfen!
            if isZeroMoney(e_r_sqld(
              { } 'select sum(BETRAG) from AUSGANGSRECHNUNG where' +
              { } ' (KUNDE_R=' + inttostr(PERSON_R) + ') and' +
              { } ' (BELEG_R=' + FieldByName('BELEG_R').AsString + ') and' +
              { } ' (TEILLIEFERUNG=' + FieldByName('TEILLIEFERUNG').AsString + ')'
              { } )) then
              SkipIt := true;
          end;

          // Belege, die erst heute abgerechnet wurden auf der Mahnung ignorieren!
          if not(SkipIt) then
            if not(pHeutigeBelege) then
              if (VORGANG = cVorgang_Rechnung) then
                if (FieldByName('DATUM').AsDateTime >= now - 2) then
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
            RECHNUNGSNUMMER := inttostrN(FieldByName('RECHNUNG').AsInteger,
              e_r_RechnungsNummerAnzahlDerStellen);
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
              DatensammlerLokal.add
                ('BelegDat=' + long2dateLocalized(DateTime2Long(qBELEG.FieldByName('RECHNUNG')
                .AsDateTime)))
            else
              DatensammlerLokal.add
                ('BelegDat=' + long2dateLocalized(DateTime2Long(FieldByName('DATUM').AsDateTime)));

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
                        MoreText := MoreText + ' ' + _('(wird abgebucht)')
                      else
                        MoreText := MoreText + ' ' + _('(Abbuchung ohne Erfolg)');

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
                            FieldByName('MAHNSTUFE').AsInteger := FieldByName('MAHNSTUFE')
                              .AsInteger + 1;
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

                            until true;
                          until true;
                          Post;

                          Verbucht_BELEG_R.add(qBELEG.FieldByName('RID').AsString);
                        end;
                      end;

                    if Ausgesetzt_BELEG_R.Lacks(qBELEG.FieldByName('RID').AsInteger) then
                    begin

                      if (FaelligSeit = 1) then
                        MoreText := MoreText + ' ' + format(_('(seit einem Tag in Verzug)'),
                          [FaelligSeit])
                      else
                        MoreText := MoreText + ' ' + format(_('(seit %d Tagen in Verzug)'),
                          [FaelligSeit]);
                      MaxTageVerzug := max(MaxTageVerzug, FaelligSeit);
                      BetragVerzug := BuchungsBetrag;
                      Summe_Verzug := Summe_Verzug + BuchungsBetrag;
                      Verzug := true;
                      Verzug_BELEG_R.add(BELEG_R);

                    end
                    else
                    begin
                      MoreText := MoreText + ' ' + _('(Mahnung ausgesetzt)');
                    end;

                    // externer Rechnungsempfänger?
                    if not(qBELEG.FieldByName('RECHNUNGSANSCHRIFT_R').IsNull) and
                      (qBELEG.FieldByName('RECHNUNGSANSCHRIFT_R').AsInteger <>
                      qBELEG.FieldByName('PERSON_R').AsInteger) then
                    begin
                      MoreText := MoreText + #13 + #13 +
                        format(_('Rechnungsempfänger war %s.' + #13 +
                        'Bitte leiten Sie diese Information an den Rechnungsempfänger weiter. Wir weisen Sie '
                        + 'darauf hin, daß bei fortdauernder Nichtzahlung, Sie als Auftraggeber letztendlich zur Zahlung verpflichtet sind.'),
                        [e_r_Person(qBELEG.FieldByName('RECHNUNGSANSCHRIFT_R').AsInteger)]);
                    end;

                  end
                  else
                  begin
                    case FaelligSeit of
                      0:
                        MoreText := MoreText + ' ' + _('(heute fällig)');
                      1:
                        MoreText := MoreText + ' ' + _('(morgen fällig)');
                    else
                      MoreText := MoreText + ' ' + format(_('(in %d Tagen fällig)'),
                        [-FaelligSeit]);
                    end;
                  end;
                end
                else
                begin
                  case ForderungStatus of
                    cForderung_Lastschrift_Anstehend:
                      MoreText := MoreText + ' ' + _('(wartet auf Abbuchung)');
                    cForderung_Lastschrift_Vorgemerkt:
                      MoreText := MoreText + ' ' + _('(wird abgebucht)');
                    cForderung_Lastschrift_Erhalten:
                      MoreText := MoreText + ' ' + _('(Bank versuchte den Einzug)');
                  else
                    MoreText := MoreText + ' ' + _('(Unbekannter Abbuchungsstatus)');
                  end;
                end;
              end
              else
              begin
                MoreText := MoreText + ' ' + _('(ausgeglichen)');
                Summe_Ausgleich := Summe_Ausgleich + BuchungsBetrag;
              end;

              // weitere Texte
              with qBELEG do
              begin

                if not(FieldByName('MAHNUNG1').IsNull) then
                  MoreText := MoreText + #13 + _('Mahnung 1 erhielten Sie am') + ' ' +
                    long2dateLocalized(DateTime2Long(FieldByName('MAHNUNG1').AsDateTime));

                if not(FieldByName('MAHNUNG2').IsNull) then
                  MoreText := MoreText + #13 + _('Mahnung 2 erhielten Sie am') + ' ' +
                    long2dateLocalized(DateTime2Long(FieldByName('MAHNUNG2').AsDateTime));

                if not(FieldByName('MAHNUNG3').IsNull) then
                  MoreText := MoreText + #13 + _('Mahnung 3 erhielten Sie am') + ' ' +
                    long2dateLocalized(DateTime2Long(FieldByName('MAHNUNG3').AsDateTime));

                if not(FieldByName('MAHNBESCHEID').IsNull) then
                  MoreText := MoreText + #13 + _('Mahnbescheid beantragt am') + ' ' +
                    long2dateLocalized(DateTime2Long(FieldByName('MAHNBESCHEID').AsDateTime));

                SaldoLautBeleg := FieldByName('RECHNUNGS_BETRAG').AsFloat -
                  FieldByName('DAVON_BEZAHLT').AsFloat;
                if (SaldoLautBeleg > 0) then
                  MaxMahnstufe := max(MaxMahnstufe, FieldByName('MAHNSTUFE').AsInteger);

              end;
              SaldoLautKonto := GetSaldo(FieldByName('BELEG_R').AsInteger);

              // Zinsberechnung?
              if (SaldoLautBeleg > 0) then
                if (FaelligSeit > 1) and Ausgesetzt_BELEG_R.Lacks(FieldByName('BELEG_R').AsInteger)
                then
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
                      MoreText := MoreText + #13 + format(_('bei Verzugszinssatz von %.1f%% = %m'),
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
                  MoreText := MoreText + #13 + _('Noch zu zahlen sind') + ' ' +
                    format('%m', [SaldoLautBeleg])
                else
                  MoreText := MoreText + #13 + _('Zuviel bezahlt sind') + ' ' +
                    format('%m', [-SaldoLautBeleg]);

              if isSomeMoney(SaldoLautBeleg - SaldoLautKonto) then
              begin
                MoreText := MoreText + #13 + _('ACHTUNG: Konto-Saldo ist') + ' ' +
                  format('%m', [SaldoLautKonto]);
                if not(OneDifferenz) then
                  result.add('DIFFERENZ=' + cC_True);
                OneDifferenz := true;
              end;

              if NoBELEG_R then
                if not(MoreTextManuell) then
                  MoreText := MoreText + #13 +
                    _('INFO: diese Zahlung konnte keinem Beleg zugeordnet werden!');

              DatensammlerLokal.add('BelegFaellig=' +
                long2dateLocalized(DateTime2Long(FieldByName('VALUTA').AsDateTime)) + #13 + MoreText
                + _KontoTexte);
              DatensammlerLokal.add('BelegBetrag=' + _BetragAsHTML(BuchungsBetrag));

              DatensammlerLokal.add('Betrag.Bezahlt=');
              DatensammlerLokal.add('Betrag.Offen=' + format('%m', [BuchungsBetrag]));
              DatensammlerLokal.add('Betrag.Forderung=' + format('%m', [BuchungsBetrag]));

              Summe_Offen := Summe_Offen + BuchungsBetrag;
            end
            else
            begin

              // der Betrag ist "0"
              DatensammlerLokal.add('BelegFaellig=' +
                long2dateLocalized(DateTime2Long(FieldByName('VALUTA').AsDateTime)) + #13 +
                _('(kostenfreie Nachlieferung)') + _KontoTexte);
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
            DatensammlerLokal.add('LastschriftText=' + _('Ihre Zahlung'));
            DatensammlerLokal.add('LastschriftTextNeu=' + _('Ihre Zahlung'));
            DatensammlerLokal.add('BelegDat=' + long2dateLocalized
              (DateTime2Long(FieldByName('DATUM').AsDateTime)));
            if MoreTextManuell then
            begin
              DatensammlerLokal.add('BelegFaellig=' + MoreText + _KontoTexte)
            end
            else
            begin
              if FieldByName('TEILLIEFERUNG').IsNull then
              begin
                DatensammlerLokal.add('BelegFaellig=' + _('Ihre Zahlung zu den Rechnungen') + ' ' +
                  HugeSingleLine(e_r_RechnungsNummern(BELEG_R), ', '));
              end
              else
              begin
                DatensammlerLokal.add('BelegFaellig=' + _('Ihre Zahlung zur Rechnung') + ' ' +
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
          DatensammlerLokal.add('LastschriftText=' + _('Mahngebühr'));
          DatensammlerLokal.add('LastschriftTextNeu=' + _('Mahngebühr'));
          DatensammlerLokal.add('BelegFaellig=' + _('Mahngebühr'));
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
            DatensammlerLokal.add('LastschriftText=' + _('Verzugszins'));
            DatensammlerLokal.add('LastschriftTextNeu=' + _('Verzugszins'));
            DatensammlerLokal.add('BelegFaellig=' + _('Verzugszins'));
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
            DatensammlerGlobal.add('Beleg Titel=' + _('3. Mahnung'));
            MahnungsBeleg.LoadFromFile(MyProgramPath + cHTMLTemplatesDir + 'Mahnung3.html');
            break;
          end;

        if (MaxMahnstufe = 1) then
          if FileExists(MyProgramPath + cHTMLTemplatesDir + 'Mahnung2.html') then
          begin
            DatensammlerGlobal.add('Beleg Titel=' + _('2. Mahnung'));
            MahnungsBeleg.LoadFromFile(MyProgramPath + cHTMLTemplatesDir + 'Mahnung2.html');
            break;
          end;

        if FileExists(MyProgramPath + cHTMLTemplatesDir + 'Mahnung.html') then
          MahnungsBeleg.LoadFromFile(MyProgramPath + cHTMLTemplatesDir + 'Mahnung.html')
        else
          MahnungsBeleg.addFatalError('Vorlage .\Mahnung.html nicht gefunden!');

        DatensammlerGlobal.add('Beleg Titel=' + _('Information über fällige Zahlungen'));

      until true;

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
      CareTakerLog(cERRORText + ' e_w_KontoInfo(' + inttostr(PERSON_R) + '): ' + E.Message);
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

const
  _iShopArtikelBilderPathChecked: boolean = false;
  _iShopArtikelBilderPathOK: boolean = false;

function e_r_ArtikelBild(AUSGABEART_R, ARTIKEL_R: integer; DoFileCheck: boolean = true): string;
var
  BILD_R: integer;
  FName: string;
begin
  if DoFileCheck then
  begin

    result := '';
    repeat

      // Existenz den Pfades geprüft?!
      if not(_iShopArtikelBilderPathChecked) then
      begin
        _iShopArtikelBilderPathOK := DirExists(iShopArtikelBilderPath);
        _iShopArtikelBilderPathChecked := true;
      end;

      // Bilder-Pfad grundsätzlich OK?
      if not(_iShopArtikelBilderPathOK) then
        break;

      // Dokument bekannt?
      BILD_R := e_r_ArtikelDokument(AUSGABEART_R, ARTIKEL_R, cMediumBild);
      if (BILD_R < cRID_FirstValid) then
        break;

      FName := inttostrN(BILD_R, 8) + cImageExtension;
      if FileExists(iShopArtikelBilderPath + FName) then
        result := FName;

    until true;

  end
  else
  begin
    // Dokument bekannt?
    BILD_R := e_r_ArtikelDokument(AUSGABEART_R, ARTIKEL_R, cMediumBild);
    if (BILD_R < cRID_FirstValid) then
      result := ''
    else
      result := inttostrN(BILD_R, 8) + cImageExtension;
  end;
end;

function e_r_ArtikelVorschaubild(AUSGABEART_R, ARTIKEL_R: integer;
  DoFileCheck: boolean = true): string;
var
  FName: string;
begin
  if DoFileCheck then
  begin
    result := '';
    FName := e_r_ArtikelBild(AUSGABEART_R, ARTIKEL_R, true);
    if (FName <> '') then
    begin
      ersetze(cImageExtension, 'th' + cImageExtension, FName);
      if FileExists(iShopArtikelBilderPath + FName) then
        result := FName;
    end;
  end
  else
  begin
    result := e_r_ArtikelBild(AUSGABEART_R, ARTIKEL_R, false);
    if (result <> '') then
      ersetze(cImageExtension, 'th' + cImageExtension, result);
  end;
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

  lKasse := e_r_sqlt('select INFO from EREIGNIS where (ART=' + inttostr(eT_Kasse) + ') and (RID=' +
    inttostr(EREIGNIS_R) + ')');

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
        sKasse := copy(sKasse, 1, pred(ProzentPos)) +
          chr(StrtoInt('$' + copy(sKasse, succ(ProzentPos), 2))) +
          copy(sKasse, ProzentPos + 3, MaxInt);
      until false;
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
        { } ' MENGE=COALESCE(MENGE,0)+1' +
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
              MWST := iMwStSatzManuelleArtikel;

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
        CareTakerLog(cERRORText + ' e_w_BelegNeuAusKasse: ' + E.Message);
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
  ArtikelAnzahl := e_r_sql('select sum(MENGE) from WARENKORB where (PERSON_R=' + inttostr(PERSON_R)
    + ') and (SCHRANK is null)');
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
        CareTakerLog(cERRORText + ' e_w_BelegNeuAusWarenkorb: ' + E.Message);
      end;
    end;
  end;
end;

function e_r_ArtikelVersendetag(AUSGABEART_R, ARTIKEL_R: integer): integer;
var
  m: integer;
  LIEFERZEIT: TdboCursor;
begin

  if (AUSGABEART_R = cAusgabeArt_Aufnahme_MP3) then
  begin
    result := 5;
    exit;
  end;

  m := e_r_Menge(cRID_Null, AUSGABEART_R, ARTIKEL_R);

  if (m > 0) then
  begin
    result := min(
      { } pred(cVersendetag_ErstesDatum),
      { } m + cVersendetag_OffsetLagernd);
  end
  else
  begin

    result := 0;
    LIEFERZEIT := nCursor;
    with LIEFERZEIT do
    begin
      sql.add('SELECT');
      sql.add(' ARTIKEL.LIEFERZEIT as ARTIKEL_LIEFERZEIT,');
      sql.add(' ARTIKEL.EURO,');
      sql.add(' ARTIKEL.MINDESTBESTAND,');
      sql.add(' PERSON.LIEFERZEIT as PERSON_LIEFERZEIT');
      sql.add('FROM ARTIKEL');
      sql.add('left JOIN PERSON ON');
      sql.add(' (ARTIKEL.VERLAG_R=PERSON.RID)');
      sql.add('WHERE');
      sql.add(' (ARTIKEL.RID=' + inttostr(ARTIKEL_R) + ')');
      ApiFirst;
      repeat
        if eof then
          break;
        if (FieldByName('EURO').AsFloat = cPreis_vergriffen) then
        begin
          result := 1;
          break;
        end;
        if (FieldByName('MINDESTBESTAND').AsInteger = cMenge_unbegrenzt) then
        begin
          result := cVersendetag_OffsetTage;
          break;
        end;
        result := FieldByName('ARTIKEL_LIEFERZEIT').AsInteger;
        if (result > 0) then
        begin
          result := min(
            { } cVersendetag_OffsetLagernd,
            { } cVersendetag_OffsetTage + LieferzeitInTagen(result));
          break;
        end;
        result := FieldByName('PERSON_LIEFERZEIT').AsInteger;
        if (result > 0) then
        begin
          result := min(
            { } cVersendetag_OffsetLagernd,
            { } cVersendetag_OffsetTage + LieferzeitInTagen(result));
          break;
        end;
      until true;
    end;
    LIEFERZEIT.free;
  end;
end;

function e_r_Lieferzeit(AUSGABEART_R, ARTIKEL_R: integer): integer; // [Tage]
var
  m: integer;
  LIEFERZEIT: TdboCursor;
begin
  result := 0; // sofort
  try
    m := e_r_Menge(cRID_Null, AUSGABEART_R, ARTIKEL_R);
    if (m <= 0) then
    begin
      LIEFERZEIT := nCursor;
      with LIEFERZEIT do
      begin
        sql.add('SELECT');
        sql.add(' ARTIKEL.LIEFERZEIT as ARTIKEL_LIEFERZEIT,');
        sql.add(' PERSON.LIEFERZEIT as PERSON_LIEFERZEIT');
        sql.add('FROM ARTIKEL');
        sql.add('left JOIN PERSON ON');
        sql.add(' (ARTIKEL.VERLAG_R=PERSON.RID)');
        sql.add('WHERE');
        sql.add(' (ARTIKEL.RID=' + inttostr(ARTIKEL_R) + ')');
        ApiFirst;
        repeat
          if eof then
            break;
          result := FieldByName('ARTIKEL_LIEFERZEIT').AsInteger;
          if (result > 0) then
            break;
          result := FieldByName('PERSON_LIEFERZEIT').AsInteger;
          if (result > 0) then
            break;
        until true;
        if (result > 0) then
          result := LieferzeitInTagen(result)
        else
          result := iStandardLieferZeit;
      end;
      LIEFERZEIT.free;
    end;
  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_r_Lieferzeit(' + inttostr(AUSGABEART_R) + ',' +
        inttostr(ARTIKEL_R) + '): ' + E.Message);
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
        if matchRule
          (format('select RABATT from RABATT where (CODE=''%s'') and (PERSON_R=%d) and (SORTIMENT_R is null)',
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

    until true;
  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_r_VerlagsRabatt: ' + E.Message);
    end;
  end;
end;

function e_r_Rabatt(ARTIKEL_R, PERSON_R: integer; var Netto: boolean;
  var NettoWieBrutto: boolean): double;
var
  //
  qARTIKEL: TdboCursor;
  qRABATT_CODE: TdboCursor;

  // Cache
  RABATT_CODE: string;
  VERLAG_R: integer;
  SORTIMENT_R: integer;
  _RABATT_CODE: string;
  MaxRabatt: double;

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
  MaxRabatt := 0.0;
  try
    repeat

      // gehört der Kunde überhaupt einer Rabattstufe an?
      qRABATT_CODE := nCursor;
      with qRABATT_CODE do
      begin
        sql.add('SELECT RABATT_CODE,NETTO,NETTO_WIE_BRUTTO FROM PERSON WHERE RID=' +
          inttostr(PERSON_R));
        ApiFirst;
        RABATT_CODE := noblank(FieldByName('RABATT_CODE').AsString);
        Netto := (FieldByName('NETTO').AsString = cC_True);
        NettoWieBrutto := (FieldByName('NETTO_WIE_BRUTTO').AsString = cC_True);
      end;
      qRABATT_CODE.free;
      if (RABATT_CODE = '') then
        break;

      // den Verlag suchen
      qARTIKEL := nCursor;
      with qARTIKEL do
      begin
        sql.add('SELECT VERLAG_R,SORTIMENT_R FROM ARTIKEL WHERE RID=' + inttostr(ARTIKEL_R));
        Open;
        First;
        VERLAG_R := FieldByName('VERLAG_R').AsInteger;
        SORTIMENT_R := FieldByName('SORTIMENT_R').AsInteger;
        Close;
      end;
      qARTIKEL.free;

      // Rabatt-Obergrenze
      MaxRabatt := e_r_sqld(format('select RABATT from RABATT where' + ' (CODE is null) and ' +
        ' ((SORTIMENT_R=%d) or (ARTIKEL_R=%d))', [SORTIMENT_R, ARTIKEL_R]), 100.0);
      if MaxRabatt = 0.0 then
        break;

      if MaxRabatt > result then
        while (RABATT_CODE <> '') do
        begin

          _RABATT_CODE := nextp(RABATT_CODE, ',');

          // Rabatt Regeln

          // nur über ARTIKEL_R, eigentlich ganz weg vom Verlag
          if matchRule(format('select RABATT from RABATT where (CODE=''%s'') and (ARTIKEL_R=%d)',
            [_RABATT_CODE, ARTIKEL_R]), result) then
            break;

          if (VERLAG_R >= cRID_FirstValid) then
          begin

            // über Kombination: Sortiment & Verlag
            if matchRule
              (format('select RABATT from RABATT where (CODE=''%s'') and (SORTIMENT_R=%d) and (PERSON_R=%d)',
              [_RABATT_CODE, SORTIMENT_R, VERLAG_R]), result) then
              break;

            // nur über Verlag
            if matchRule
              (format('select RABATT from RABATT where (CODE=''%s'') and (PERSON_R=%d) and (SORTIMENT_R is null)',
              [_RABATT_CODE, VERLAG_R]), result) then
              break;

          end;

          // nur über Sortiment
          if matchRule
            (format('select RABATT from RABATT where (CODE=''%s'') and (SORTIMENT_R=%d) and (PERSON_R is null)',
            [_RABATT_CODE, SORTIMENT_R]), result) then
            break;

          // einfach nur über den Code
          if matchRule
            (format('select RABATT from RABATT where (CODE=''%s'') and (ARTIKEL_R is null) and (SORTIMENT_R is null) and (PERSON_R is null)',
            [_RABATT_CODE]), result) then
            break;

        end;

    until true;
  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_r_Rabatt: ' + E.Message);
    end;
  end;
  result := min(MaxRabatt, result);
end;

function e_r_ekRabatt(ARTIKEL_R: integer): double;
var
  qARTIKEL: TdboCursor;
  qPERSON: TdboCursor;
  VERLAG_R: integer;
  Rabatt: double;
  ResultResolved: boolean;

begin
  ResultResolved := false;
  Rabatt := 0.0;
  repeat

    // a) im Artikel
    qARTIKEL := nCursor;
    with qARTIKEL do
    begin
      sql.add('SELECT VERLAG_R,RABATT FROM ARTIKEL WHERE RID=' + inttostr(ARTIKEL_R));
      Open;
      VERLAG_R := FieldByName('VERLAG_R').AsInteger;
      if not(FieldByName('RABATT').IsNull) then
      begin
        Rabatt := FieldByName('RABATT').AsFloat;
        ResultResolved := true;
      end;
      Close;
    end;
    qARTIKEL.free;

    if ResultResolved then
      break;

    // b) im Verlag
    qPERSON := nCursor;
    with qPERSON do
    begin
      sql.add('SELECT RABATT FROM PERSON WHERE RID=' + inttostr(VERLAG_R));
      Open;
      if not(FieldByName('RABATT').IsNull) then
      begin
        Rabatt := FieldByName('RABATT').AsFloat;
        ResultResolved := true;
      end;
      Close;
    end;
    qPERSON.free;

  until true;

  result := Rabatt;

end;

function e_w_Artikel(EINHEIT_R, AUSGABEART_R, ARTIKEL_R: integer): boolean;
var
  MINDESTBESTAND: string;
begin
  result := false;
  if (ARTIKEL_R >= cRID_FirstValid) and (AUSGABEART_R >= cRID_FirstValid) then
  begin
    if (e_r_sql('select count(RID) from ARTIKEL_AA where ' + ' (ARTIKEL_R' + isRID(ARTIKEL_R) +
      ') and ' + ' (AUSGABEART_R' + isRID(AUSGABEART_R) + ') and ' + ' (EINHEIT_R' +
      isRID(EINHEIT_R) + ')') = 0) then
    begin

      if (AUSGABEART_R = cAusgabeArt_Aufnahme_MP3) then
        MINDESTBESTAND := inttostr(cMenge_unbegrenzt)
      else
        MINDESTBESTAND := 'null';

      e_x_sql('insert into ARTIKEL_AA (RID, EINHEIT_R, AUSGABEART_R, ARTIKEL_R, MINDESTBESTAND, LETZTEAENDERUNG) '
        + ' values (' +
        { } sRID_AutoInc + ',' +
        { } RIDtostr(EINHEIT_R) + ',' +
        { } RIDtostr(AUSGABEART_R) + ',' +
        { } RIDtostr(ARTIKEL_R) + ',' +
        { } MINDESTBESTAND + ',' +
        { } 'CURRENT_TIMESTAMP' + ')');
      result := true;
    end;
  end;
end;

function e_w_ArtikelNeu(SORTIMENT_R: integer): integer;
var
  ARTIKEL: TdboQuery;
  Sortiment: TdboQuery;
  ArtikelNo: TdboCursor;
  NUMERO: integer;
begin

  //
  result := -1;

  Sortiment := nQuery;
  ArtikelNo := nCursor;
  ARTIKEL := nQuery;
  try

    // nächste Nummer ermitteln
    with Sortiment do
    begin

      // "NÄCHSTE NUMMER"
      sql.add('SELECT NAECHSTE_NUMMER FROM SORTIMENT WHERE RID=' + inttostr(SORTIMENT_R) + ' ' +
        for_update);
      Open;
      First;
      if eof then
        raise exception.create('SORTIMENT_R nicht gefunden');

      // neuer ARTIKEL_R
      result := e_w_GEN('ARTIKEL_GID');
      NUMERO := FieldByName('NAECHSTE_NUMMER').AsInteger;
      if (NUMERO = -1) then
        NUMERO := result;

    end;

    // Prüfen, ob die Nummer nicht schon belegt ist!
    with ArtikelNo do
    begin
      sql.add('SELECT RID FROM ARTIKEL WHERE NUMERO=:CROSSREF');
      while true do
      begin
        ParamByName('CROSSREF').AsInteger := NUMERO;
        Open;
        ApiFirst;
        if eof then
          break;
        inc(NUMERO);
        Close;
      end;
    end;

    //
    with ARTIKEL do
    begin
      sql.add('select RID,SORTIMENT_R,NUMERO,ERSTEINTRAG,MINDESTBESTAND,GEWICHT from ARTIKEL ' +
        for_update);
      Insert;
      if (SORTIMENT_R <> -1) then
        FieldByName('SORTIMENT_R').AsInteger := SORTIMENT_R;
      FieldByName('NUMERO').AsInteger := NUMERO;
      FieldByName('ERSTEINTRAG').AsDateTime := now;
      FieldByName('RID').AsInteger := result;

      // Defaults / Customer Defaults
      if not(e_r_LagerVorhanden(SORTIMENT_R)) then
      begin
        FieldByName('MINDESTBESTAND').AsInteger := -1;
        FieldByName('GEWICHT').AsInteger := -1;
      end;

      Post;
    end;

    with Sortiment do
    begin
      edit;
      FieldByName('NAECHSTE_NUMMER').AsInteger := NUMERO + 1;
      Post;
      Close;
    end;
  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_w_ArtikelNeu(' + inttostr(SORTIMENT_R) + '): ' + E.Message);
    end;
  end;
  ARTIKEL.free;
  Sortiment.free;
  ArtikelNo.free;
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
      FieldByName('NACHNAME').AsString := _('Neuer Eintrag');
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
      CareTakerLog(cERRORText + ' e_w_PersonNeu: ' + E.Message);
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
    sql.add('select VORNAME,NACHNAME,ANREDE,PRIV_ANSCHRIFT_R from PERSON where RID=' +
      inttostr(PERSON_R));
    ApiFirst;
  end;

  cANSCHRIFT := nCursor;
  with cANSCHRIFT do
  begin
    sql.add('select NAME_OBEN,NAME1,NAME2 from ANSCHRIFT where RID=' +
      inttostr(cPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsInteger));
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

procedure e_r_Anschrift(PERSON_R: integer; sl: TStringList; Prefix: string = '');
var
  PERSON, ANSCHRIFT: TdboCursor;
  Adressat: TStringList;
begin
  PERSON := nCursor;
  ANSCHRIFT := nCursor;
  try
    repeat
      PERSON.sql.add('select * from PERSON where RID=' + inttostr(PERSON_R));
      PERSON.ApiFirst;
      if PERSON.eof then
        break;
      sl.add(Prefix + 'K#=' + PERSON.FieldByName('NUMMER').AsString);
      sl.add(Prefix + 'H#=' + PERSON.FieldByName('HAUPT_NUMMER').AsString);
      sl.add(Prefix + 'KontoAR=' + PERSON.FieldByName('KONTO_AR').AsString);
      sl.add(Prefix + 'KontoER=' + PERSON.FieldByName('KONTO_ER').AsString);
      sl.add(Prefix + 'Anrede=' + PERSON.FieldByName('ANREDE').AsString);
      sl.add(Prefix + 'Ansprache=' + PERSON.FieldByName('ANSPRACHE').AsString);
      sl.add(Prefix + 'Vorname=' + PERSON.FieldByName('VORNAME').AsString);
      sl.add(Prefix + 'Nachname=' + PERSON.FieldByName('NACHNAME').AsString);
      sl.add(Prefix + 'Name=' + cutblank(PERSON.FieldByName('VORNAME').AsString + ' ' +
        PERSON.FieldByName('NACHNAME').AsString));
      sl.add(Prefix + 'Fax=' + e_r_fax(PERSON));
      sl.add(Prefix + 'Telefon=' + e_r_telefon(PERSON));
      sl.add(Prefix + 'Handy=' + PERSON.FieldByName('HANDY').AsString);
      sl.add(Prefix + 'Versicherungsnummer=' + PERSON.FieldByName('VERSICHERUNGSNUMMER').AsString);

      ANSCHRIFT.sql.add('select * from ANSCHRIFT where RID=' +
        PERSON.FieldByName('PRIV_ANSCHRIFT_R').AsString);
      ANSCHRIFT.ApiFirst;
      if ANSCHRIFT.eof then
        break;
      Adressat := e_r_Adressat(PERSON.FieldByName('RID').AsInteger);
      sl.add(Prefix + 'Adressat1=' + Adressat[0]);
      sl.add(Prefix + 'Adressat2=' + Adressat[1]);
      sl.add(Prefix + 'Adressat3=' + Adressat[2]);
      sl.add(Prefix + 'Adressat4=' + Adressat[3]);
      Adressat.free;
      sl.add(Prefix + 'Name1=' + ANSCHRIFT.FieldByName('NAME1').AsString);
      sl.add(Prefix + 'Name2=' + ANSCHRIFT.FieldByName('NAME2').AsString);
      sl.add(Prefix + 'Strasse=' + ANSCHRIFT.FieldByName('STRASSE').AsString);
      sl.add(Prefix + 'Ort=' + e_r_Ort(ANSCHRIFT));
    until true;
  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_r_Anschrift: ' + E.Message);
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

function e_r_MindestMenge(AUSGABEART_R, ARTIKEL_R: integer): integer;
begin
  if (AUSGABEART_R > 0) then
  begin
    result := 0;
  end
  else
  begin
    result := max(0, e_r_sql('SELECT MINDESTBESTAND FROM ARTIKEL WHERE RID=' +
      inttostr(ARTIKEL_R)));
  end;
end;

function e_r_ArtikelMusik(AUSGABEART_R, ARTIKEL_R: integer): string;
var
  MUSIK_R: integer;
  sLinkList: TStringList;
begin
  result := '';
  repeat
    MUSIK_R := e_r_ArtikelDokument(AUSGABEART_R, ARTIKEL_R, cMediumWebLink);
    if (MUSIK_R < cRID_FirstValid) then
      break;
    sLinkList := e_r_sqlt('select BEMERKUNG from DOKUMENT where' + ' (RID=' +
      inttostr(MUSIK_R) + ')');
    if (sLinkList.count > 0) then
      result := HugeSingleLine(sLinkList, cOLAPcsvLineBreak);
    sLinkList.free;
  until true;
end;

function e_r_UngelieferteMengeUeberBedarf(AUSGABEART_R, ARTIKEL_R: integer): integer;
begin
  result := max(0, e_r_OffeneMenge(AUSGABEART_R, ARTIKEL_R) - (e_r_AgentMenge(AUSGABEART_R,
    ARTIKEL_R) + e_r_MindestMenge(AUSGABEART_R, ARTIKEL_R)));
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
  VERSAND_R := e_r_sql('select RID from VERSAND where' + ' (BELEG_R=' + inttostr(BELEG_R) + ') and'
    + ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')');
  if (VERSAND_R >= cRID_FirstValid) then
  begin
    // Es ist bereits ein Versand-Eintrag da!
    result := e_r_sql('select LEERGEWICHT from VERSAND where RID=' + inttostr(VERSAND_R));
  end
  else
  begin
    // Es muss das default Gewicht angenommen werden!
    PACKFORM_R := e_r_sql('select PACKFORM_R from VERSENDER where RID=' +
      inttostr(e_r_StandardVersender));
    result := e_r_sql('select GEWICHT from PACKFORM where RID=' + inttostr(PACKFORM_R));
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
        sql.add('SELECT TEILLIEFERUNG,BTYP,PERSON_R,LIEFERANSCHRIFT_R,GENERATION,INTERN_INFO FROM BELEG WHERE RID='
          + inttostr(BELEG_R));
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
      IN_LAND_R := e_r_sql('SELECT LAND_R FROM ANSCHRIFT WHERE RID=(' +
        'SELECT PRIV_ANSCHRIFT_R FROM PERSON WHERE RID=' + inttostr(PERSON_R) + ')');

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

      until true;

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
            doubletostr(IN_warenwert) + '<=IN_WARENWERT_BIS) AND' + ' (IN_GEWICHT_VON IS NULL) AND'
            + ' (IN_GEWICHT_BIS IS NULL)');
          if (ARTIKEL_R <> -1) then
            break;

          // GEWICHT
          ARTIKEL_R := VCheck(' (IN_WARENWERT_VON IS NULL) AND' + ' (IN_WARENWERT_BIS IS NULL) AND'
            + ' (' + inttostr(IN_gewicht) + '>=IN_GEWICHT_VON) AND' + ' (' + inttostr(IN_gewicht) +
            '<=IN_GEWICHT_BIS)');
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

        until false;
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
      CareTakerLog(cERRORText + ' e_r_VersandKosten(' + inttostr(BELEG_R) + '): ' + E.Message);
    end;
  end;
end;

function e_r_Versender(BELEG_R, TEILLIEFERUNG: integer): string;
var
  VERSENDER_R: integer;
begin
  VERSENDER_R := e_r_sql('select VERSENDER_R from VERSAND where ' + '(BELEG_R=' + inttostr(BELEG_R)
    + ') and ' + '(TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')');
  if (VERSENDER_R < cRID_FirstValid) then
    VERSENDER_R := e_r_StandardVersender;
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
    if (_LandFormatStr[k + 2] in ['0' .. '9']) then
      result := StrToIntDef(_LandFormatStr[k + 2], cPLZlength_default);
end;

function e_r_Ort(dboDS: TdboDataSet): string; overload;
// benötigt
//
// (LAND_R, STATE, ORT, PLZ)
//
//
var
  k: integer;
  PLZlength: integer;
begin
  with dboDS do
  begin
    result := e_r_LaenderOrtFormat(FieldByName('LAND_R').AsInteger);

    // Postleitzahl
    k := pos('%p', result);
    repeat
      if (k > 0) and (k + 2 <= length(result)) then
      begin
        if (result[k + 2] in ['0' .. '9']) then
        begin
          PLZlength := StrToIntDef(result[k + 2], cPLZlength_default);
          System.delete(result, k + 2, 1);
          ersetze('%p', e_r_plz(dboDS, PLZlength), result);
          break;
        end;
      end;
      ersetze('%p', e_r_plz(dboDS, cPLZlength_default), result);
    until true;

    ersetze('%l', e_r_land(dboDS), result);
    ersetze('%s', FieldByName('STATE').AsString, result);
    ersetze('%o', FieldByName('ORT').AsString, result);
    ersetze('%c', e_r_LaenderInternational(FieldByName('LAND_R').AsInteger), result);
  end;
end;

function e_r_Ort(PERSON_R: integer): string; overload;
var
  ANSCHRIFT: TdboCursor;
begin
  ANSCHRIFT := nCursor;
  with ANSCHRIFT do
  begin
    sql.add('select A.LAND_R, A.STATE, A.PLZ, A.ORT from PERSON P');
    sql.add('join ANSCHRIFT A on A.RID=P.PRIV_ANSCHRIFT_R');
    sql.add('where P.RID=' + inttostr(PERSON_R));
    ApiFirst;
    if not(eof) then
      result := e_r_Ort(ANSCHRIFT)
    else
      result := '';
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
      _plz_sub := inttostr(FieldByName('PLZ').AsInteger);
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
      result := e_r_sqld('select sum(BETRAG) from AUSGANGSRECHNUNG where BELEG_R=' +
        inttostr(BELEG_R))
    else
      result := e_r_sqld('select sum(BETRAG) from AUSGANGSRECHNUNG where ' + '(BELEG_R=' +
        inttostr(BELEG_R) + ') and ' + '(TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')')
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
    FORDERUNG_BELEGE := e_r_sqld('select RECHNUNGS_BETRAG from BELEG where RID=' +
      inttostr(BELEG_R));
    AUSGLEICH_BELEGE := e_r_sqld('select DAVON_BEZAHLT from BELEG where RID=' + inttostr(BELEG_R));
    FORDERUNG_VERSAND := e_r_sqld('select sum(LIEFERBETRAG) from VERSAND where BELEG_R=' +
      inttostr(BELEG_R));

    if IsOther(FORDERUNG_VERSAND, FORDERUNG_BELEGE) then
      break;

    if IsOther(SALDO_AUSGANGSRECHNUNGEN, FORDERUNG_BELEGE - AUSGLEICH_BELEGE) then
      break;

    result := isZeroMoney(SALDO_AUSGANGSRECHNUNGEN);
  until true;
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

function e_r_MahnungFName(PERSON_R: integer): string;
begin
  result :=
  { } cPersonPath(PERSON_R) +
  { } cHTML_MahnungFName;
end;

function e_r_BelegInfo(BELEG_R: integer; TEILLIEFERUNG: integer = -1): TStringList;
var
  POSTEN: TdboCursor;
  Beleg: TdboCursor;
  WARE: TdboCursor;

  // Beleg-Optionen von denen die Berechnung abhängt
  NurGeliefertes: boolean;
  EinzelpreisNetto: boolean;

  // Posten Sachen
  Menge_Rechnung: integer;
  MENGE_RECHNUNG_SUMME: integer;
  MENGE_AUSFALL: integer;
  MENGE_GELIEFERT: integer;
  MENGE_AUFTRAG: integer;
  MENGE_AGENT: integer;
  MENGE_AUFNAHMEN: integer;

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
      sql.add('  (BELEG_R=' + inttostr(BELEG_R) + ') AND');
      sql.add('  ((BEWEGT IS NULL) OR (BEWEGT=''' + cC_False + '''))');
      ApiFirst;
      result.add('UNBEWEGT=' + inttostr(FieldByName('C_RID').AsInteger));
    end;
    WARE.free;

    // Infos vom echten "Beleg" dazuladen
    Beleg := nCursor;
    with Beleg do
    begin
      sql.add('SELECT EINZELPREIS_NETTO,RECHNUNGS_BETRAG,DAVON_BEZAHLT FROM BELEG WHERE RID=' +
        inttostr(BELEG_R));
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
    AuftragsSumme := 0;
    LieferSumme := 0;
    AuftragsGewicht := 0;
    PackformGewicht := e_r_PackformGewicht(BELEG_R);
    LieferGewicht := PackformGewicht;
    Warenwert := 0;
    AuftragsWert := 0;
    Zutaten := 0;
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
      end
      else
      begin
        sql.add('from POSTEN');
        sql.add('where');
        sql.add(' (BELEG_R=' + inttostr(BELEG_R) + ')');
      end;

      ApiFirst;
      while not(eof) do
      begin

        gewicht := FieldByName('GEWICHT').AsInteger;
        EINHEIT_R := FieldByName('EINHEIT_R').AsInteger;

        e_r_PostenInfo(POSTEN, NurGeliefertes, EinzelpreisNetto, Menge_Rechnung, MENGE_AUFTRAG,
          MENGE_GELIEFERT, MENGE_AUSFALL, MENGE_AGENT, Rabatt, EinzelPreis, MWST);

        // RAB!!

        PREIS := e_r_PostenPreis(EinzelPreis, Menge_Rechnung, EINHEIT_R);
        PreisRabattiert := e_c_Rabatt(PREIS, Rabatt);

        MwStSaver.add(MWST, PreisRabattiert);

        // Preis Summen
        if (FieldByName('ZUTAT').AsString <> cC_True) then
        begin
          AuftragsSumme := AuftragsSumme +
            e_c_Rabatt(e_r_PostenPreis(EinzelPreis, MENGE_AUFTRAG - MENGE_AUSFALL,
            EINHEIT_R), Rabatt);
          AuftragsWert := AuftragsWert + e_r_PostenPreis(EinzelPreis, MENGE_AUFTRAG - MENGE_AUSFALL,
            EINHEIT_R);
          LieferSumme := LieferSumme + PreisRabattiert;
          Warenwert := Warenwert + e_r_PostenPreis(EinzelPreis, Menge_Rechnung, EINHEIT_R);
        end
        else
        begin
          Zutaten := Zutaten + e_r_PostenPreis(EinzelPreis, MENGE_AUFTRAG - MENGE_AUSFALL,
            EINHEIT_R);
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
          SATZn := e_r_Satz(Satz, DateGet);
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
  // result.savetoFile(DiagnosePath + 'Beleg-' + inttostr(BELEG_R) + '.txt');
end;

function e_r_PaketPreis(AUSGABEART_R, ARTIKEL_R: integer): double;
var
  PAKET: TdboCursor;
  MENGE: integer;
  EinzelPreis, GesamtPreis: double;
begin
  // Kopf-Artikel
  GesamtPreis := 0;
  try
    EinzelPreis := e_r_PreisBrutto(AUSGABEART_R, ARTIKEL_R);
    if e_r_PreisValid(EinzelPreis) then
      GesamtPreis := GesamtPreis + EinzelPreis;
    // ev. noch weitere Artikel
    PAKET := nCursor;
    with PAKET do
    begin
      sql.add('SELECT RID,PAKET_MENGE,PAKET_ARTIKEL_R FROM ARTIKEL WHERE PAKET_R=' +
        inttostr(ARTIKEL_R));
      ApiFirst;
      while not(eof) do
      begin

        if FieldByName('PAKET_ARTIKEL_R').IsNull then
          EinzelPreis := e_r_PreisBrutto(AUSGABEART_R, FieldByName('RID').AsInteger)
        else
          EinzelPreis := e_r_PreisBrutto(AUSGABEART_R, FieldByName('PAKET_ARTIKEL_R').AsInteger);

        if e_r_PreisValid(EinzelPreis) then
        begin
          if FieldByName('PAKET_MENGE').IsNull then
            MENGE := 1
          else
            MENGE := FieldByName('PAKET_MENGE').AsInteger;
          GesamtPreis := GesamtPreis + EinzelPreis * MENGE;
        end;

        ApiNext;
      end;
    end;
    PAKET.free;

  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_r_PaketPreis(' + inttostr(AUSGABEART_R) + ',' +
        inttostr(ARTIKEL_R) + '): ' + E.Message);
    end;
  end;
  result := GesamtPreis;
end;

function e_r_PreisText(AUSGABEART_R, ARTIKEL_R: integer): string;
var
  PREIS: double;
begin
  PREIS := e_r_PaketPreis(AUSGABEART_R, ARTIKEL_R);
  repeat

    // normale Preise
    if (PREIS >= 0.0) then
    begin
      result := format('%m', [PREIS]);
      break;
    end;

    if (PREIS = cPreis_vergriffen) then
    begin
      result := 'vergriffen';
      break;
    end;

    result := 'auf Anfrage';

  until true;
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

procedure e_w_preDeleteBeleg(BELEG_R: integer);
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
    sql.add('SELECT RID FROM POSTEN where BELEG_R=' + inttostr(BELEG_R));
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
    e_w_preDeletePosten(POSTEN_R);
  end;
  PDeleteList.free;

  // Posten löschen
  e_x_sql('delete from POSTEN where BELEG_R=' + inttostr(BELEG_R));
  e_x_sql('delete from GELIEFERT where BELEG_R=' + inttostr(BELEG_R));
  e_x_sql('delete from AUSGANGSRECHNUNG where BELEG_R=' + inttostr(BELEG_R));

  // Beleg Referenzen auflösen
  e_w_dereference(BELEG_R, 'ARBEITSZEIT', 'BELEG_R');
  e_w_dereference(BELEG_R, 'BUCH', 'BELEG_R');
  e_w_dereference(BELEG_R, 'DOKUMENT', 'BELEG_R');
  e_w_dereference(BELEG_R, 'EREIGNIS', 'BELEG_R');
  e_w_dereference(BELEG_R, 'TICKET', 'BELEG_R');
  e_w_dereference(BELEG_R, 'VERSAND', 'BELEG_R');
  e_w_dereference(BELEG_R, 'WARENBEWEGUNG', 'BELEG_R');
  e_w_dereference(BELEG_R, 'ABLAGE', 'BELEG_R');
  e_w_dereference(BELEG_R, 'AUFTRAG', 'BELEG_R');
  e_w_dereference(BELEG_R, 'PAKET', 'BELEG_R');

  // BPOSTEN?
  // VERTRAG!

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

function e_w_VertragBuchen(VERTRAG_R: integer; sSettings: TStringList): TStringList; overload;
var
  cVERTRAG: TdboCursor;
  GEBUCHT_BIS: TAnfixDate;
  ERSTER_ABRECHNUNGSTAG: TAnfixDate;
  LETZTER_ABRECHNUNGSTAG: TAnfixDate;
  DIESER_ABRECHNUNGSTAG: TAnfixDate;
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

  VertragsTexte: TStringList;
  Erzwingen: boolean;
  n: integer;
const
  BAUSTELLE_R: integer = cRID_Null;

  function VertragAnwendbar(dlong: TAnfixDate): boolean;
  begin
    result := (dlong >= VON) and (dlong <= BIS);
  end;

begin

  // Vertrag verbuchen ....
  result := TStringList.create;
  EINSTELLUNGEN := TStringList.create;
  try
    // Vorlauf
    Erzwingen := sSettings.values['Erzwingen'] = cIni_Activate;

    while (e_r_VertragBuchen(VERTRAG_R)) or Erzwingen do
    begin

      // es ist nur ein "Erzwingen"-Lauf möglich
      Erzwingen := false;
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
            VertragsTexte.add('Objekt=' + e_r_sqls('select NAME from BAUSTELLE where RID=' +
              inttostr(BAUSTELLE_R)));
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

          until true;

          // weitere Daten bestimmen!
          PERSON_R := FieldByName('PERSON_R').AsInteger;
          BELEG_R := FieldByName('BELEG_R').AsInteger;
          PERSON_RECHNUNG_R := e_r_sql(
            { } 'select RECHNUNGSANSCHRIFT_R from BELEG where RID=' + inttostr(BELEG_R));

          // Vertragsanwendungsbeginn und VertragsanwendungsEnde bestimmen
          VertragsTexte.values['Beginn'] := long2date(ERSTER_ABRECHNUNGSTAG);
          VertragsTexte.values['BeginnJahr'] := inttostr(extractYear(ERSTER_ABRECHNUNGSTAG));
          VertragsTexte.values['BeginnMonat'] := inttostrN(extractMonth(ERSTER_ABRECHNUNGSTAG), 2);
          DIESER_ABRECHNUNGSTAG := ERSTER_ABRECHNUNGSTAG;
          for n := 1 to WIEDERHOLUNGEN do
            DIESER_ABRECHNUNGSTAG := DatePlus(MonthPeriod(DIESER_ABRECHNUNGSTAG), 1);
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
            ZIEL_BELEG_R := e_r_sql(
              { } 'select max(RID) from BELEG where' +
              { } ' (PERSON_R=' + inttostr(PERSON_R) + ') and' +
              { } ' (RECHNUNG is null) and ' +
              { } ' (BSTATUS =''*'') and ' +
              { } ' (' + KONTEXT_SQL + ') and ' +
              { } ' (BTYP <> ''0'')');
          end
          else
          begin
            ZIEL_BELEG_R := cRID_Null;
          end;
          DIESER_ABRECHNUNGSTAG := ERSTER_ABRECHNUNGSTAG;
          for n := 1 to WIEDERHOLUNGEN do
          begin

            VertragsTexte.values['von'] := long2date(DIESER_ABRECHNUNGSTAG);
            VertragsTexte.values['bis'] := long2date(MonthPeriod(DIESER_ABRECHNUNGSTAG));
            VertragsTexte.values['Monat'] := cMonatNamenLang[extractMonth(DIESER_ABRECHNUNGSTAG)] +
              ' ' + inttostr(extractYear(DIESER_ABRECHNUNGSTAG));

            if VertragAnwendbar(DIESER_ABRECHNUNGSTAG) then
            begin
              result.add('PERSON_R=' + inttostr(PERSON_R));

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

            end;

            DIESER_ABRECHNUNGSTAG := DatePlus(MonthPeriod(DIESER_ABRECHNUNGSTAG), 1);
          end;

          // Ist ein Beleg entstanden, und soll gleich verbucht werden?
          if (EINSTELLUNGEN.values['Verbuchen'] <> cIni_DeActivate) then
            if (ZIEL_BELEG_R >= cRID_FirstValid) then
            begin
              e_w_BelegBuchen(ZIEL_BELEG_R);
              result.add('Verbucht.BELEG_R=' + inttostr(ZIEL_BELEG_R));
            end;

          // Letzter Abrechnungstag verbuchen!
          LETZTER_ABRECHNUNGSTAG := DatePlus(DIESER_ABRECHNUNGSTAG, -1);
          e_x_sql('update VERTRAG set GEBUCHT_BIS=''' + long2date(LETZTER_ABRECHNUNGSTAG) +
            ''' where ' + ' (RID=' + inttostr(VERTRAG_R) + ') and' +
            ' ((GEBUCHT_BIS is null) or (GEBUCHT_BIS<''' + long2date(LETZTER_ABRECHNUNGSTAG)
            + '''))');
          result.add('GEBUCHT_BIS=' + long2date(LETZTER_ABRECHNUNGSTAG));

        end;
      until true;
      cVERTRAG.free;
      VertragsTexte.free;
    end;
  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_w_VertragBuchen(' + inttostr(VERTRAG_R) + '): ' + E.Message);
    end;
  end;
end;

function e_w_VertragBuchen(VERTRAG_R: integer; Erzwingen: boolean = false): TStringList; overload;
var
  sSettings: TStringList;
begin
  sSettings := TStringList.create;
  sSettings.add('Erzwingen=' + bool2cO(Erzwingen));
  result := e_w_VertragBuchen(VERTRAG_R, sSettings);
  sSettings.free;
end;

function e_r_VertragBuchen(VERTRAG_R: integer): boolean;
var
  cVERTRAG: TdboCursor;
  GEBUCHT_BIS: TAnfixDate;
  ERSTER_ABRECHNUNGSTAG: TAnfixDate;
  STICHTAG: TAnfixDate;
  TAG_DER_BELEGERSTELLUNG: TAnfixDate;
  VORLAUF: integer;
  VON: TAnfixDate;
  BIS: TAnfixDate;
  WIEDERHOLUNGEN: integer;

  function VertragAnwendbar(dlong: TAnfixDate): boolean;
  begin
    result := (dlong >= VON) and (dlong <= BIS);
  end;

begin

  // Vertrag prüfen, ob man ihn anwenden könnte ....
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
      TAG_DER_BELEGERSTELLUNG := DatePlus(ERSTER_ABRECHNUNGSTAG, -VORLAUF);
      result := (DateGet >= TAG_DER_BELEGERSTELLUNG);

      // Sollte er anwendbar sein, könnte "Ruhend" die Anwendung verhindern
      // Es gibt aber eine Warnung.
      if result and (FieldByName('RUHEND').AsString = cC_True) then
      begin
        // result.add('WARNING: Vertragsanwendung ist ruhend!');
        result := false;
        break;
      end;

    end;
  until true;
  cVERTRAG.free;
end;

function e_w_VertragBuchen(const lVertraege: TgpIntegerList): TStringList; overload;
var
  n: integer;
  sErgebnis: TStringList;
  VERTRAG_R: integer;
begin
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
end;

function e_w_VertragBuchen: TStringList; overload;
var
  lVertraege: TgpIntegerList;
begin
  lVertraege := e_r_sqlm('select RID from VERTRAG');
  result := e_w_VertragBuchen(lVertraege);
  lVertraege.free;
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

function e_r_ArtikelKontext(AUSGABEART_R, ARTIKEL_R: integer): string;
var
  KontextL: TgpIntegerList;
  ResultL: TStringList;
  n: integer;
begin
  ResultL := TStringList.create;
  KontextL := e_r_sqlm('select DISTINCT MASTER_R from ARTIKEL_MITGLIED where' + ' (ARTIKEL_R=' +
    inttostr(ARTIKEL_R) + ')');
  for n := 0 to pred(KontextL.count) do
    ResultL.add(e_r_sqls('select TITEL from ARTIKEL where' + ' (RID=' +
      inttostr(KontextL[n]) + ')'));
  result := HugeSingleLine(ResultL, cOLAPcsvLineBreak);
  KontextL.free;
  ResultL.free;
end;

function e_r_KontoInhaber(PERSON_R: integer): string;
var
  cPERSON: TdboCursor;
begin
  result := '';
  cPERSON := nCursor;
  with cPERSON do
  begin
    sql.add('select VORNAME,NACHNAME,Z_ELV_KONTO_INHABER from PERSON where ' + ' (RID=' +
      inttostr(PERSON_R) + ')');
    ApiFirst;
    repeat

      // Vorrang hat der Konto-Inhaber
      result := cutblank(FieldByName('Z_ELV_KONTO_INHABER').AsString);
      if (result <> '') then
        break;

      // Danach Vorname und Nachname
      result := cutblank(FieldByName('VORNAME').AsString + ' ' + FieldByName('NACHNAME').AsString);

    until true;
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
    sql.add('select VORNAME,NACHNAME,PRIV_ANSCHRIFT_R from PERSON where ' + ' (RID=' +
      inttostr(PERSON_R) + ')');
    ApiFirst;

    // Danach Vorname und Nachname
    result := cutblank(FieldByName('VORNAME').AsString + ' ' + FieldByName('NACHNAME').AsString);

  end;

  if (result = '') then
  begin
    with cANSCHRIFT do
    begin
      sql.add('select NAME1,NAME2 from ANSCHRIFT where RID=' +
        cPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsString);
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
        sql.add('select * from BELEG where RID=' + inttostr(BELEG_R));
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
      e_x_basic(MyProgramPath + cDBASICPath + 'BerechneBeleg-1.txt',
        { } 'PERSON_R=' + inttostr(PERSON_R) + ';' +
        { } 'BELEG_R=' + inttostr(BELEG_R));

      with qPosten do
      begin
        sql.add('select * from POSTEN where');
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

            e_r_PostenInfo(qPosten, NurGeliefertes, EinzelpreisNetto, _Anz, _AnzAuftrag,
              _AnzGeliefert, _AnzStorniert, _AnzNachlieferung, _Rabatt, _EinzelPreis, _MwStSatz);

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
                  e_w_Artikel(FieldByName('EINHEIT_R').AsInteger, FieldByName('AUSGABEART_R')
                    .AsInteger, FieldByName('ARTIKEL_R').AsInteger);

                //
                _MengeLager := e_r_Menge(FieldByName('EINHEIT_R').AsInteger,
                  FieldByName('AUSGABEART_R').AsInteger, FieldByName('ARTIKEL_R').AsInteger);

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
                    e_w_MehrBedarfsAnzeige(FieldByName('AUSGABEART_R').AsInteger,
                      FieldByName('ARTIKEL_R').AsInteger, FieldByName('RID').AsInteger, _AgentDiff,
                      eT_MotivationHaendlerAuftrag)
                  else
                    e_w_MehrBedarfsAnzeige(FieldByName('AUSGABEART_R').AsInteger,
                      FieldByName('ARTIKEL_R').AsInteger, FieldByName('RID').AsInteger, _AgentDiff,
                      eT_MotivationKundenAuftrag);
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
                  ZUSAGE := Liefertag
                    (DatePlus(DateGet, e_r_Lieferzeit(FieldByName('AUSGABEART_R').AsInteger,
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
                      FieldByName('ARTIKEL_R').AsInteger := qPosten.FieldByName('ARTIKEL_R')
                        .AsInteger;

                      //
                      if not(qPosten.FieldByName('AUSGABEART_R').IsNull) then
                        FieldByName('AUSGABEART_R').AsInteger := qPosten.FieldByName('AUSGABEART_R')
                          .AsInteger;
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

                  // Warenbewegung jetzt ausdrucken!
                  e_w_Menge(FieldByName('EINHEIT_R').AsInteger, FieldByName('AUSGABEART_R')
                    .AsInteger, FieldByName('ARTIKEL_R').AsInteger, _MengeLagerNeu - _MengeLager,
                    qBELEG.FieldByName('RID').AsInteger, qPosten.FieldByName('RID').AsInteger);

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
                            FieldByName('PREIS').AsFloat := FieldByName('PREIS').AsFloat +
                              Glattstellung;
                            Post;
                            Glattstellung := 0.0;
                          end;

            _PreisProPosition := e_c_Rabatt(e_r_PostenPreis(_EinzelPreis, _Anz, EINHEIT_R),
              _Rabatt);

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
                if (e_r_sqls('select' + ' SORTIMENT.MWST_FIXIERT ' + 'from' + ' ARTIKEL ' + 'join' +
                  ' SORTIMENT ' + 'on' + ' (SORTIMENT.RID=ARTIKEL.SORTIMENT_R) ' + 'where' +
                  ' (ARTIKEL.RID=' + inttostr(ARTIKEL_R) + ')') <> cC_True) then
                  FieldByName('MWST').AsFloat := MwStSaver.MWST[_groesstesMwStElementIndex].Satz;
              end;
            FieldByName('ARTIKEL').AsString := FieldByName('ARTIKEL').AsString + ' (' +
              inttostr(succ(TEILLIEFERUNG)) + '. Lieferung)';
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
          e_r_PostenInfo(qPosten, NurGeliefertes, EinzelpreisNetto, _Anz, _AnzAuftrag,
            _AnzGeliefert, _AnzStorniert, _AnzNachlieferung, _Rabatt, _EinzelPreis, _MwStSatz);
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
        CareTakerLog(cERRORText + ' e_w_BerechneBeleg(' + inttostr(BELEG_R) + '): ' + E.Message);
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
    result := (FieldByName('MENGE_RECHNUNG').AsInteger > 0) and
    // etwas zu liefern
      (FieldByName('MENGE_AGENT').AsInteger = 0); // nix mehr zu ordern
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
  Menge_Rechnung: integer;
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
        { } DiagnosePath + 'GENERATION-' + DatumLog + '.log');
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
    Menge_Rechnung := 0;
    MENGE_AGENT := 0;
    MENGE_GELIEFERT := 0;
    VOLUMEN := 0.0;
    Zutaten := 0.0;
    ErrorFlag := false;

    ZUSAGE := 0;
    ERSTERLIEFERTAG := MaxInt;
    // Delphi Bug "MaxDouble" umschifft
    // d := MaxDouble;
    // if d=MaxDouble then ok    <--- this fails
    //
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

        // Problematisch: Eigentlich sollte das "if" über das Flag "ZUTAT"
        // entscheiden
        if not(e_r_IsVersandKosten(FieldByName('ARTIKEL_R').AsInteger)) then
        begin

          if not(FieldByName('TERMIN').IsNull) then
          begin
            if (FieldByName('MENGE_RECHNUNG').AsInteger > 0) or
              (FieldByName('MENGE_AGENT').AsInteger > 0) then
              TERMIN := min(TERMIN, FieldByName('TERMIN').AsDateTime);
          end;

          // Summen bilden
          inc(MENGE_AUFTRAG, FieldByName('MENGE').AsInteger - FieldByName('MENGE_AUSFALL').AsInteger
            - min(0, FieldByName('MENGE_RECHNUNG').AsInteger));

          inc(Menge_Rechnung, max(0, FieldByName('MENGE_RECHNUNG').AsInteger));
          inc(MENGE_GELIEFERT, FieldByName('MENGE_GELIEFERT').AsInteger);
          inc(MENGE_AGENT, FieldByName('MENGE_AGENT').AsInteger);

          // Regel auswerten!
          VOLUMEN := VOLUMEN + e_r_PostenPreis(FieldByName('PREIS').AsFloat,
            FieldByName('MENGE').AsInteger - FieldByName('MENGE_AUSFALL').AsInteger,
            FieldByName('EINHEIT_R').AsInteger);

          if not(ErrorFlag) then
            ErrorFlag := (MENGE_AUFTRAG <> Menge_Rechnung + MENGE_AGENT + MENGE_GELIEFERT);

        end
        else
        begin
          Zutaten := Zutaten + e_r_PostenPreis(FieldByName('PREIS').AsFloat,
            FieldByName('MENGE').AsInteger - FieldByName('MENGE_AUSFALL').AsInteger,
            FieldByName('EINHEIT_R').AsInteger);
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

      // Status der versendbarkeit bestimmen.
      Pre_versandfertig := e_r_Versandfertig(qBELEG);
      Pre_versandfaehig := e_r_Versandfaehig(qBELEG);

      // Empfaenger bestimmen
      PERSON_R := FieldByName('PERSON_R').AsInteger;
      if (FieldByName('LIEFERANSCHRIFT_R').IsNull) then
        EMPFAENGER_R := PERSON_R
      else
        EMPFAENGER_R := FieldByName('LIEFERANSCHRIFT_R').AsInteger;

      // Bisheriges Lager auslesen
      LAGER_R := FieldByName('LAGER_R').AsInteger;

      // Konsistenz Fehler
      if ErrorFlag then
        inc(VERSAND_STATUS, cV_Fehler);

      if (MENGE_AGENT > 0) then
        inc(VERSAND_STATUS, cV_Agent);

      if (Menge_Rechnung <> 0) then
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
          GENERATION_Log(true, format('Erstmaliges setzen des VERSAND_STATUS auf %d',
            [VERSAND_STATUS]));
          break;
        end;
        if (VERSAND_STATUS <> FieldByName('VERSAND_STATUS').AsInteger) then
        begin
          GENERATION_Log(true, format('VERSAND_STATUS von %d auf %d',
            [FieldByName('VERSAND_STATUS').AsInteger, VERSAND_STATUS]));
          break;
        end;

        // Geld
        if IsOther(FieldByName('VOLUMEN').AsFloat, VOLUMEN) then
        begin
          GENERATION_Log(true, format('Volumen von %m nach %m', [FieldByName('VOLUMEN').AsFloat,
            VOLUMEN]));
          break;
        end;
        if IsOther(FieldByName('ZUTATEN').AsFloat, Zutaten) then
        begin
          GENERATION_Log(true, format('ZUTATEN von %m nach %m', [FieldByName('ZUTATEN').AsFloat,
            Zutaten]));
          break;
        end;

        // Mengen
        if (FieldByName('MENGE_AUFTRAG').AsInteger <> MENGE_AUFTRAG) then
        begin
          GENERATION_Log(true, format('MENGE_AUFTRAG von %d nach %d',
            [FieldByName('MENGE_AUFTRAG').AsInteger, MENGE_AUFTRAG]));
          break;
        end;
        if (FieldByName('MENGE_RECHNUNG').AsInteger <> Menge_Rechnung) then
        begin
          GENERATION_Log(true, format('MENGE_RECHNUNG von %d nach %d',
            [FieldByName('MENGE_RECHNUNG').AsInteger, Menge_Rechnung]));
          break;
        end;
        if (FieldByName('MENGE_AGENT').AsInteger <> MENGE_AGENT) then
        begin
          GENERATION_Log(true, format('MENGE_AGENT von %d nach %d',
            [FieldByName('MENGE_AGENT').AsInteger, MENGE_AGENT]));
          break;
        end;
        if (FieldByName('MENGE_GELIEFERT').AsInteger <> MENGE_GELIEFERT) then
        begin
          GENERATION_Log(true, format('MENGE_GELIEFERT von %d nach %d',
            [FieldByName('MENGE_GELIEFERT').AsInteger, MENGE_GELIEFERT]));
          break;
        end;

        // Datums
        if ((FieldByName('TERMIN').AsDateTime <> TERMIN) and (TERMIN <> cTerminUnset)) then
        begin
          if FieldByName('TERMIN').IsNull then
            GENERATION_Log(true, format('TERMIN von ' + cOLAPNull + ' auf %s',
              [dTimeStamp(TERMIN)]))
          else
            GENERATION_Log(true, format('TERMIN von %s auf %s',
              [dTimeStamp(FieldByName('TERMIN').AsDateTime), dTimeStamp(TERMIN)]));
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
          GENERATION_Log(false, format('ZUSAGE von %s auf %s',
            [long2date(FieldByName('ZUSAGE').AsDateTime), long2date(ZUSAGE)]));
          break;
        end;

        DoPost := false;
      until true;

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
        FieldByName('MENGE_RECHNUNG').AsInteger := Menge_Rechnung;
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
              qStringsAdd(FieldByName('INFO'), format('Warenausgang für Beleg %d erwartet',
                [BELEG_R]));
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
          e_x_sql('update TICKET set AUSGANG = ''' + cC_True + ''' where ' + ' (BELEG_R=' +
            inttostr(BELEG_R) + ') and' + ' (ART=' + inttostr(eT_WareRausgegangen) + ') and' +
            ' (AUSGANG is null)');
        end;

        //
        // Übergangsfach Logik überhaupt aktiv
        //
        if (e_r_Uebergangsfach_VERLAG_R > 0) then
        begin

          //
          // L A G E R  zuteilen
          //
          if Post_versandfaehig then
          begin
            if (LAGER_R < cRID_FirstValid) then
            begin
              LAGER_R := e_r_UebergangsfachFromPerson(EMPFAENGER_R);
              if (LAGER_R > 0) then
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
                EventText.add(format('Versandfertig: im Übergangsfach %s!',
                  [e_r_LagerPlatzNameFromLAGER_R(LAGER_R)]));
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

          until true;

        end;

      end;

    end;
    result := true;

  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_w_BelegStatusBuchen(' + inttostr(BELEG_R) + '): ' + E.Message);
    end;
  end;
  cPOSTEN.free;
  qBELEG.free;
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
        sql.add('SELECT * FROM BPOSTEN WHERE (BELEG_R=' + inttostr(BBELEG_R) + ')');
        ApiFirst;
        while not(eof) do
        begin
          MENGE_AUFTRAG := MENGE_AUFTRAG + FieldByName('MENGE').AsInteger -
            FieldByName('MENGE_AUSFALL').AsInteger;
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

        if (_bestell_status <> FieldByName('BESTELL_STATUS').AsInteger) or
          FieldByName('BESTELL_STATUS').IsNull or
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
        CareTakerLog(cERRORText + ' e_w_BBelegStatusBuchen(' + inttostr(BBELEG_R) + '): ' +
          E.Message);
      end;
    end;
    cBPOSTEN.free;
    qBBELEG.free;
  end;
end;

function e_r_Verlag(VERLAG_R: integer): string;
begin
  if VERLAG_R < cRID_FirstValid then
    result := ''
  else
    result := e_r_sqls('select SUCHBEGRIFF from PERSON where RID=' + inttostr(VERLAG_R));
end;

function e_r_VERLAG_R_fromVerlag(Verlag: string): integer;
{ RID }
begin
  result := e_r_sql
    ('select RID from VERLAG where PERSON_R=(SELECT RID from PERSON where SUCHBEGRIFF=''' +
    Verlag + ''')');
  if (result = 0) then
    result := cRID_Null;
end;

function e_r_UebergangsfachFromPerson(PERSON_R: integer): integer;
var
  UEBERGANGSFACH_VERLAG_R: integer;
  UebergangsfaecherAnz: integer;
  UebergangsfachSelected: integer;
  TriedCount: integer;
  n: integer;
  cBELEG: TdboCursor;
  cLAGER: TdboCursor;
begin
  UEBERGANGSFACH_VERLAG_R := e_r_Uebergangsfach_VERLAG_R;

  // Ist die Übergangsfach-Logik überhaupt aktiv?
  if (UEBERGANGSFACH_VERLAG_R > 0) then
  begin

    //
    // hat der Kunde schon ein Übergangsfach
    //
    cBELEG := nCursor;
    with cBELEG do
    begin
      sql.add('SELECT LAGER_R');
      sql.add('FROM BELEG');
      sql.add('WHERE NOT(LAGER_R IS NULL) AND');
      sql.add('      ( (LIEFERANSCHRIFT_R=' + inttostr(PERSON_R) + ') OR');
      sql.add('        ((PERSON_R=' + inttostr(PERSON_R) + ') AND (LIEFERANSCHRIFT_R IS NULL))');
      sql.add('      )');
      ApiFirst;
      result := FieldByName('LAGER_R').AsInteger;
    end;
    cBELEG.free;
    if (result > 0) then
      exit;

    //
    // Übergangsfächer auflisten
    //
    cLAGER := nCursor;
    with cLAGER do
    begin

      //
      sql.add('select RID from LAGER where');
      sql.add(' (VERLAG_R=' + inttostr(UEBERGANGSFACH_VERLAG_R) + ')');

      //
      TriedCount := 0;
      UebergangsfaecherAnz := RecordCount;
      if (UebergangsfaecherAnz > 0) then
      begin
        UebergangsfachSelected := e_w_GEN('UEBERGANGSFACH_GID') mod UebergangsfaecherAnz;
        ApiFirst;
        // Nun den Einstiegspunkt anfahren!
        for n := 0 to pred(UebergangsfachSelected) do
          ApiNext;

        repeat
          if eof then
            ApiFirst;
          inc(TriedCount);
          if e_r_sql('select count(RID) from BELEG where LAGER_R=' + FieldByName('RID').AsString) = 0
          then
            break;
          ApiNext;
        until (TriedCount > UebergangsfaecherAnz);
      end;

      if not(eof) then
      begin
        result := FieldByName('RID').AsInteger
      end
      else
      begin
        // nix mehr frei!
        result := -1;
      end;
    end;
    cLAGER.free;

  end
  else
  begin
    // Übergangsfach-Verwaltung ist gar nicht aktiv!
    result := -1;
  end;

end;

function e_r_LandRID(ISO: string): integer;
begin
  result := e_r_sql('select RID from LAND where ISO_KURZZEICHEN=''' + ISO + '''');
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

function e_r_StandardVersender: integer;
begin
  // Standard-Versender ermitteln
  result := e_r_sql('select RID from VERSENDER where STANDARD=''' + cC_True + '''');
end;

function e_r_LagerPlatzNameFromLAGER_R(LAGER_R: integer): string;
begin
  result := e_r_sqls('select NAME from LAGER where RID=' + inttostr(LAGER_R));
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
  RECHNUNGSNUMMER := e_r_sql('select RECHNUNG from VERSAND where' + ' (BELEG_R=' + inttostr(BELEG_R)
    + ') and' + ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')');
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
  RECHNUNGEN := e_r_sqlm('select RECHNUNG from VERSAND where' + ' (BELEG_R=' + inttostr(BELEG_R) +
    ') and' + ' (RECHNUNG is not null) ' + 'order by RECHNUNG');
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

function e_w_Stempel(STEMPEL_R: integer): integer;
begin
  // imp pend : RETURNING
  // oder eine tranaktion machen, dieses Statement ist nicht thread save!
  e_x_sql('update STEMPEL set STAND=STAND+1 where RID=' + inttostr(STEMPEL_R));
  result := e_r_sql('select STAND from STEMPEL where RID=' + inttostr(STEMPEL_R));
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
      sql.add('select TEILLIEFERUNG, LIEFERANSCHRIFT_R, RECHNUNGSANSCHRIFT_R, NUMMER from BELEG where RID='
        + inttostr(BELEG_R));
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
        CareTakerLog(cERRORText + ' e_w_BelegVersand(' + inttostr(BELEG_R) +
          '): locate misslungen!');
      end;
    end;
    cBELEG.free;
    qVERSAND.free;

  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_w_BelegVersand(' + inttostr(BELEG_R) + '): ' + E.Message);
    end;
  end;
end;

procedure e_w_SetPostenPreis(EINHEIT_R, AUSGABEART_R, ARTIKEL_R, PERSON_R: integer;
  qPosten: TdboQuery);
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
    PREIS := e_r_Preis(EINHEIT_R, AUSGABEART_R, ARTIKEL_R, Satz, artikelNetto,
      artikelNettoWieBrutto);
    FieldByName('NETTO').AsString := bool2cC(artikelNetto);
    if personNetto then
      FieldByName('MWST').AsFloat := 0
    else
      FieldByName('MWST').AsFloat := Satz;
    if (PREIS <> cPreis_vergriffen) and (PREIS <> cPreis_aufAnfrage) then
    begin
      if personNetto and not(personNettoWieBrutto) and not(artikelNettoWieBrutto) and
        not(artikelNetto) then
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
      FieldByName('ARTIKEL').AsString := e_r_Ausgabeart(AUSGABEART_R) +
        cARTIKEL.FieldByName('TITEL').AsString;
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
      CareTakerLog(cERRORText + ' e_w_SetPostenData(' + inttostr(ARTIKEL_R) + ',' +
        inttostr(PERSON_R) + '): ' + E.Message);
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
          CareTakerLog(cERRORText + ' e_w_WarenkorbEinfuegen(' + inttostr(BELEG_R) +
            '): Beleg nicht gefunden');
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
        sql.add('select * from WARENKORB where (PERSON_R=' + inttostr(cBELEG.FieldByName('PERSON_R')
          .AsInteger) + ') and (SCHRANK is null) order by POSNO,RID');
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

    until true;
  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_w_EinkauswagenEinfuegen(' + inttostr(BELEG_R) + '): ' +
        E.Message);
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
    e_x_sql('DELETE FROM WARENKORB WHERE (PERSON_R=' + inttostr(PERSON_R) +
      ') and (SCHRANK is null)');
  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_w_EinkauswagenLeeren(' + inttostr(PERSON_R) + '): ' +
        E.Message);
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
        CareTakerLog(cERRORText + ' e_w_BelegNeu(' + inttostr(PERSON_R) + '): ' + E.Message);
      end;
    end;
  end;
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
{$IFDEF CONSOLE}
  cSETTINGS: TdboCursor;
{$ELSE}
  qSETTINGS: TdboQuery;
{$ENDIF}
  n: integer;
  SettingsChanged: boolean;
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
          FieldByName('SETTINGS').AssignTo(sSystemSettings);
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
    until true;
  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_r_LadeParameter: ' + E.Message);
    end;

  end;

  // völlig ohne Konfiguration?
  if not(assigned(sSystemSettings)) then
    sSystemSettings := TStringList.create;

  // selbst berechenbare PArameter
  is1400 := not(TableExists('AUSGANGSRECHNUNG'));

  // Systemparameter
  iMwStSatzManuelleArtikel := strtofloatdef(sSystemSettings.values['MwStSatzManuelleArtikel'], 0.0);
  iNachlieferungInfo := sSystemSettings.values['NachlieferungInfo'];
  iBereitsGeliefertInfo := sSystemSettings.values['BereitsGeliefertInfo'];
  iStandardTextRechnung := sSystemSettings.values['StandardTextRechnung'];
  iTranslatePath := sSystemSettings.values['FreigabePfad'];
  iSicherungsPfad := sSystemSettings.values['SicherungsPfad'];
  FotoPath := sSystemSettings.values['FotoPfad'];
  iSicherungsPrefix := sSystemSettings.values['SicherungsPrefix'];
  iSicherungenAnzahl := StrToIntDef(sSystemSettings.values['SicherungenAnzahl'], 10);
  iNichtMehrLieferbar := sSystemSettings.values['NichtMehrLieferbarInfo'];
  iDataBaseBackUpDir := sSystemSettings.values['DatenbankBackupPfad'];
  iTagesAbschlussUm := strtoseconds(sSystemSettings.values['TagesabschlussUm']);
  iTagesAbschlussAuf := cutblank(sSystemSettings.values['TagesabschlussAuf']);
  iCronAuf := cutblank(sSystemSettings.values['CronAuf']);
  iNachTagesAbschlussHerunterfahren := sSystemSettings.values['NachTagesAbschlussHerunterfahren']
    = cIni_Activate;
  iNachTagesAbschlussRechnerNeustarten := sSystemSettings.values
    ['NachTagesAbschlussRechnerNeuStarten'] = cIni_Activate;
  iNachTagwacheRechnerNeustarten := sSystemSettings.values['NachTagwacheRechnerNeuStarten']
    = cIni_Activate;
  iNachTagesAbschlussAnwendungNeustart := sSystemSettings.values
    ['NachTagesAbschlussAnwendungNeustart'] = cIni_Activate;
  iNachTagwacheAnwendungNeustart := sSystemSettings.values['NachTagwacheAnwendungNeustart']
    = cIni_Activate;
  iTagesabschlussRang := sSystemSettings.values['TagesabschlussBerechneRang'] <> cIni_DeActivate;
  iAblage := sSystemSettings.values['Ablage'] <> cIni_DeActivate;
  iTagWacheWochentage := sSystemSettings.values['TagWacheWochentage'];
  iTagwacheBaustelle := StrToIntDef(sSystemSettings.values['TagwacheBaustelle'], cRID_Null);
  iTagesabschlussWochentage := sSystemSettings.values['TagesabschlussWochentage'];

  iFaktorGanzzahlig := sSystemSettings.values['FaktorGanzzahlig'] <> cIni_DeActivate;
  iEinsUnterdrueckung := sSystemSettings.values['EinsUnterdrückung'] = cIni_Activate;
  iCareTakerOffline := sSystemSettings.values['CareTaker'] = cIni_DeActivate;
  iOpenOfficePDF := sSystemSettings.values['OpenOfficePDF'] = cIni_Activate;
  iAutoUpRevDir := sSystemSettings.values['AutoUpRevPfad'];
  iAutoUpFTP := sSystemSettings.values['AutoUpFTP'];
  iMobilFTP := sSystemSettings.values['MobilFTP'];
  iFtpProxyHost := sSystemSettings.values['FTPProxyHost'];
  iFtpProxyPort := StrToIntDef(sSystemSettings.values['FTPProxyPort'], 0);
  iTagWacheUm := strtoseconds(sSystemSettings.values['TagWacheUm']);
  iTagWacheAuf := cutblank(sSystemSettings.values['TagWacheAuf']);
  iNachTagwacheHerunterfahren := sSystemSettings.values['NachTagwacheHerunterfahren']
    = cIni_Activate;
  iKontoInhaber := sSystemSettings.values['KontoInhaber'];
  iKontoBankName := sSystemSettings.values['KontoBankName'];
  iKontoNummer := sSystemSettings.values['KontoNummer'];
  iKontoBLZ := sSystemSettings.values['KontoBLZ'];
  iKontoPIN := sSystemSettings.values['KontoPIN'];
  iKontoSEPAFrist := StrToIntDef(sSystemSettings.values['KontoSEPAFrist'],
    cDTA_LastschriftVerzoegerung);
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
  iPDFVersender := sSystemSettings.values['PDFVersender'];
  iPDFAdmin := sSystemSettings.values['PDFAdmin'];
  iPDFSend := sSystemSettings.values['PDFSend'];
  iShopDomain := sSystemSettings.values['ShopHost'];
  iShopQRPath := sSystemSettings.values['ShopQRPfad'];
  iXMLRPCHost := sSystemSettings.values['XMLRPCHost'];
  iXMLRPCPort := sSystemSettings.values['XMLRPCPort'];
  iXMLRPCGeroutet := sSystemSettings.values['XMLRPCGeroutet'] = cIni_Activate;
  imemcacheHost := sSystemSettings.values['memcacheHost'];
  iRESTHost := sSystemSettings.values['RESTHost'];
  iRESTPort := sSystemSettings.values['RESTPort'];
  iRESTGeroutet := sSystemSettings.values['RESTGeroutet'] = cIni_Activate;
  iShopKey := sSystemSettings.values['ShopKey'];
  iShopKonto := sSystemSettings.values['ShopKonto'];
  iShopLink := sSystemSettings.values['ShopLink'];
  iShopMP3 := sSystemSettings.values['ShopMP3'];
  iScannerHost := sSystemSettings.values['ScannerHost'];
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
  iDataBase_SYSDBA_Pwd := sSystemSettings.values['SysdbaPasswort'];
  iRangZeitfenster := StrToIntDef(sSystemSettings.values['RangZeitfenster'], 60);
  iLieferzeitZeitfenster := StrToIntDef(sSystemSettings.values['LieferzeitZeitfenster'], 365);
  iStandardLieferZeit := StrToIntDef(sSystemSettings.values['StandardLieferzeit'], 5);
  iSchnelleRechnung_PERSON_R := StrToIntDef(sSystemSettings.values['PersonSchnelleRechnung'], 0);
  iFormColor := HTMLColor2TColor(sSystemSettings.values['Farbe']);
  iReplikation := sSystemSettings.values['Replikation'] = cIni_Activate;
  iGOT := sSystemSettings.values['GOT'] = cIni_Activate;
  iBelegAutoSetMengeNull := sSystemSettings.values['BelegSetzeMengeNullBeiPreisNull']
    = cIni_Activate;
  iBelegArtikelNeu := sSystemSettings.values['BelegArtikelNeu'] = cIni_Activate;
  iBruttoVersandGewicht := sSystemSettings.values['BruttoVersandGewicht'] = cIni_Activate;
  iRechnungGlattstellen := sSystemSettings.values['BelegRechnungGlattstellen'] = cIni_Activate;
  iUnterdrueckeGeliefertes := sSystemSettings.values['BelegUnterdrückeGeliefertes'] = cIni_Activate;
  iBelegMengenSortierung := sSystemSettings.values['BelegMengenSortierung'] = cIni_Activate;
  iEinzelpreisNetto := sSystemSettings.values['EinzelpreisNetto'] = cIni_Activate;
  iEinzelPositionNetto := sSystemSettings.values['EinzelPositionNetto'];
  iMahnSchwelle := strtodoubledef(sSystemSettings.values['Mahnschwelle'], 6.00);
  iMahnFaelligkeitstoleranz := StrToIntDef(sSystemSettings.values['Mahnfälligkeitstoleranz'], 5);
  iMahnungAusgelicheneDazwischenAnzeigen := sSystemSettings.values
    ['MahnungAusgelicheneDazwischenAnzeigen'] = cIni_Activate;
  iMahnungErstAbUnausgeglichenheit := sSystemSettings.values['MahnungErstAbUnausgeglichenheit']
    = cIni_Activate;
  iMahnlaufbeiTagesabschluss := sSystemSettings.values['MahnlaufbeiTagesabschluss'] <>
    cIni_DeActivate;
  iAnschriftNameOben := sSystemSettings.values['AnschriftNameOben'] = cIni_Activate;
  iMahnungGebuehr1 := strtodoubledef(sSystemSettings.values['MahnungGebuehr1'], 0.0);
  iMahnungGebuehr2 := strtodoubledef(sSystemSettings.values['MahnungGebuehr2'], 0.0);
  iMahnungGebuehr3 := strtodoubledef(sSystemSettings.values['MahnungGebuehr3'], 0.0);
  iMahnungZinsSatzPrivat := strtodoubledef(sSystemSettings.values['MahnungZinsSatzPrivat'], 0.0);
  iMahnungZinsSatzGewerblich :=
    strtodoubledef(sSystemSettings.values['MahnungZinsSatzGewerblich'], 0.0);
  iMahnungMindestZins := strtodoubledef(sSystemSettings.values['MahnungMindestZins'], 0.0);
  iMahnstufeZinsEintritt := StrToIntDef(sSystemSettings.values['MahnungMahnstufeZinsEintritt'],
    pred(MaxInt));
  // [Tage], solange wird nochmaliges Mahnen verhindert
  iMahnfreierZeitraum := StrToIntDef(sSystemSettings.values['MahnungAbstand'], 14);
  iKommaFaktor := sSystemSettings.values['KommaFaktor'] = cIni_Activate;
  iBelegAnzeigeNachBuchen := (sSystemSettings.values['BelegAnzeigeNachBuchen'] = cIni_Activate) or
    (sSystemSettings.values['BelegAnzeigeNachBuchen'] = '');
  iWikiServer := sSystemSettings.values['WikiServer'];
  iWikiServer2 := sSystemSettings.values['PrivaterWikiServer'];
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
  iAusgabeartLastschriftText := StrToIntDef(sSystemSettings.values['AusgabeartLastschriftText'],
    cRID_Null);
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

  iLagerHoheDiversitaet := sSystemSettings.values['LagerHoheDiversität'] = cIni_Activate;
  iNeuanlageZeitraum := StrToIntDef(sSystemSettings.values['NeuanlageZeitraum'], 3);
  // [Tage], solange Artikel/Personen als Neuanlage gelten
  iKartenPfad := sSystemSettings.values['KartenPfad'];
  iKartenHost := sSystemSettings.values['KartenHost'];
  iKartenProfil := sSystemSettings.values['KartenProfil'];
  iJonDaAdmin := StrToIntDef(sSystemSettings.values['JonDaAdmin'], cRID_Null);
  iFSPath := sSystemSettings.values['FunktionsSicherungstellungsPfad'];

  // defaults
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
  if (iFormColor = 0) then
    iFormColor := TColors.SysBtnFace;

  // AutoUp und FS
  iAutoUpRevDir := evalPath(iAutoUpRevDir);
  if (iAutoUpRevDir = '') then
    iAutoUpRevDir := '..\rev\';
  if (pos(':', iAutoUpRevDir) = 0) then
    iAutoUpRevDir := ExpandFileName(MyApplicationPath + iAutoUpRevDir);
  if (iFSPath = '') then
    iFSPath := EigeneOrgaMonDateienPfad + 'fs\';

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

  cSperreUrlaub := HTMLColor2TColor($00FF00);
  cSperreAuszeit := HTMLColor2TColor($669933);
  cSperreFeiertag := HTMLColor2TColor($9999FF);

  // Sperr Wertigkeiten für Sperre
  sSperre_Wert_Baustelle.clear;
  sSperre_Wert_Baustelle.add('SPERRE;JA;' + TColor2HTMLColor(cSperreBaustelle) + ';' +
    inttostr(cPrio_BaustellenSperre));
  sSperre_Wert_Baustelle.add('AUSZEIT;JA;' + TColor2HTMLColor(cSperreAuszeit) + ';' +
    inttostr(cPrio_BaustellenSperre));
  sSperre_Wert_Baustelle.add('BAUSTOPP;JA;#C0C0C0' + ';' + inttostr(cPrio_BaustellenSperre + 1));

  sSperre_Wert_Person.clear;
  sSperre_Wert_Person.add('SPERRE;JA;' + TColor2HTMLColor(cSperreUrlaub) + ';' +
    inttostr(cPrio_MonteurSperre));
  sSperre_Wert_Person.add('AUSZEIT;JA;' + TColor2HTMLColor(cSperreAuszeit) + ';' +
    inttostr(cPrio_MonteurSperre));

  sSperre_Wert_Arbeit.clear;
  sSperre_Wert_Arbeit.add('ARBEIT;JA;' + TColor2HTMLColor(cSperreArbeit) + ';' +
    inttostr(cPrio_ArbeitSperre));
  sSperre_Wert_Arbeit.add('MEHRARBEIT;JA;' + TColor2HTMLColor(cSperreMehrarbeit) + ';' +
    inttostr(cPrio_ArbeitSperre + 1));

  sSperre_Wert_Baustopp.clear;
  sSperre_Wert_Baustopp.add('BAUSTOPP;JA;#C0C0C0;1');

  sSperre_Wert_Zuordnung.clear;
  sSperre_Wert_Zuordnung.add('ZUORDNUNG;JA;' + TColor2HTMLColor(cSperreArbeit) + ';' +
    inttostr(cPrio_ArbeitSperre));

  result := sSystemSettings;
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
    until true;
  end;
end;

function e_r_EndPreis(PERSON_R, AUSGABEART_R, ARTIKEL_R: integer): double;
var
  pNetto: boolean;
  pNettoWieBrutto: boolean;
begin
  result := e_r_PreisBrutto(AUSGABEART_R, ARTIKEL_R);
  if (result > 0) then
    result := result * (100.0 - e_r_Rabatt(ARTIKEL_R, PERSON_R, pNetto, pNettoWieBrutto)) / 100.0;
end;

function e_r_RabattCode(PERSON_R: integer): string;
begin
  result := noblank(e_r_sqls('SELECT RABATT_CODE FROM PERSON WHERE RID=' + inttostr(PERSON_R)));
end;

function e_r_RabattFaehig(PERSON_R: integer): boolean;
begin
  result := e_r_RabattCode(PERSON_R) <> '';
end;

function e_r_Gewicht(AUSGABEART_R, ARTIKEL_R: integer): integer;
var
  cGEWICHT: TdboCursor;
begin
  result := 0;
  try
    repeat

      if (AUSGABEART_R > 0) then
      begin

        // Über Artikel - AA
        cGEWICHT := nCursor;
        with cGEWICHT do
        begin
          sql.add('select GEWICHT from ARTIKEL_AA');
          sql.add('where');
          sql.add(' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') and');
          sql.add(' (AUSGABEART_R=' + inttostr(AUSGABEART_R) + ')');
          ApiFirst;
          if not(eof) then
          begin
            if not(FieldByName('GEWICHT').IsNull) then
            begin
              result := FieldByName('GEWICHT').AsInteger;
              cGEWICHT.free;
              break;
            end;
          end;
        end;
        cGEWICHT.free;

        // über den Standard-Eintrag in der AUSGABEART
        result := e_r_sql('select GEWICHT from AUSGABEART where RID=' + inttostr(AUSGABEART_R));
        break;

      end;

      result := e_r_sql('select GEWICHT from ARTIKEL where RID=' + inttostr(ARTIKEL_R));

    until true;

  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_r_Gewicht: ' + E.Message);
    end;
  end;
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

      sql.add('select RECHNUNGS_BETRAG,DAVON_BEZAHLT from BELEG where RID=' + _BELEG_R_TO + ' ' +
        for_update);

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

      fbdump('select * from AUSGANGSRECHNUNG where KUNDE_R=' + _PERSON_R_FROM, RollBackDump);

      // Imp pend: das ist viel komplizierter hier einen gesamten Kunden zu
      // löschen, bzw. alle dessen Kundenbezogene Buchungen!

      e_x_sql('delete from AUSGANGSRECHNUNG where KUNDE_R=' + _PERSON_R_FROM);

      ArchivePath := cPersonPath(PERSON_R_FROM);
      if DirExists(ArchivePath) then
      begin
        ArchiveOptions := TStringList.create;
        // Imp pend: prüfen, ob infozip mit dem Slash am Ende klarkommt
        ArchiveOptions.values[infozip_RootPath] := ArchivePath;

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

    //
    if DeleteMode then
    begin
      fbdump(PERSON_R_FROM, References, RollBackDump);
      e_x_dereference(References, _PERSON_R_FROM, 'NULL');
      fbdump('select * from PERSON where RID=' + _PERSON_R_FROM, RollBackDump);
      RollBackDump.SaveToFile(DiagnosePath + cROLL_BACK + RollBackDomain + cSQLExtension);
    end
    else
    begin
      e_x_dereference(References, _PERSON_R_FROM, _PERSON_R_TO);
    end;

    References.free;

  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_w_JoinPerson(' + inttostr(PERSON_R_FROM) + ',' +
        inttostr(PERSON_R_TO) + '): ' + E.Message);
    end;
  end;
  RollBackDump.free;
end;

procedure e_w_preDeletePerson(PERSON_R: integer);
begin
  e_w_JoinPerson(PERSON_R, cRID_Null);
end;

function e_r_IsUebergangsfach(LAGER_R: integer): boolean;
var
  UEBERGANGSFACH_VERLAG_R: integer;
begin
  UEBERGANGSFACH_VERLAG_R := e_r_Uebergangsfach_VERLAG_R;
  if (UEBERGANGSFACH_VERLAG_R > 0) then
    result := e_r_sql('select VERLAG_R from LAGER where RID=' + inttostr(LAGER_R))
      = UEBERGANGSFACH_VERLAG_R
  else
    result := false;
end;

const
  _e_r_Uebergangsfach: integer = 0;

function e_r_Uebergangsfach_VERLAG_R: integer;
begin
  if (_e_r_Uebergangsfach = 0) then
    _e_r_Uebergangsfach := e_r_VERLAG_R_fromVerlag(cVerlagUebergangsfach);
  result := _e_r_Uebergangsfach;
end;

function e_r_Umsatz(POSTEN_R: integer): double;
var
  cPOSTEN: TdboCursor;
var
  _Anz, _AnzAuftrag, _AnzGeliefert, _AnzStorniert, _AnzAgent: integer;
var
  _Rabatt, _EinzelPreis, _MwStSatz: double;
begin
  result := 0.0;
  cPOSTEN := nCursor;
  try
    repeat
      with cPOSTEN do
      begin
        sql.add('select * from POSTEN where RID=' + inttostr(POSTEN_R));
        ApiFirst;
        if eof then
          break;

        e_r_PostenInfo(cPOSTEN, true, true, _Anz, _AnzAuftrag, _AnzGeliefert, _AnzStorniert,
          _AnzAgent, _Rabatt, _EinzelPreis, _MwStSatz);

        result := e_r_PostenPreis(_EinzelPreis, _Anz, FieldByName('EINHEIT_R').AsInteger);
        result := e_c_Rabatt(result, _Rabatt);

      end;
    until true;
  finally

  end;
  cPOSTEN.free;
end;

const
  _e_r_FreiesLager: integer = MaxInt;

function e_r_FreiesLager_VERLAG_R: integer;
begin
  if (_e_r_FreiesLager = MaxInt) then
    _e_r_FreiesLager := e_r_VERLAG_R_fromVerlag(cVerlagFreiesLager);
  result := _e_r_FreiesLager;
end;

function t_r_Beleg(BELEG_R: integer): boolean;
var
  Zahlungen, Zahlungen_laut_Beleg: double;
  Forderungen, Forderungen_laut_Beleg: double;
begin
  // Anzahlungen bestimmen!
  Zahlungen := -e_r_sqld('select SUM(BETRAG) from AUSGANGSRECHNUNG where ' + ' (BELEG_R=' +
    inttostr(BELEG_R) + ') and' + ' (BETRAG<0)');

  // Forderungen bestimmen!
  Forderungen := e_r_sqld('select SUM(BETRAG) from AUSGANGSRECHNUNG where ' + ' (BELEG_R=' +
    inttostr(BELEG_R) + ') and' + ' (BETRAG>0)');

  Zahlungen_laut_Beleg := e_r_sqld('select DAVON_BEZAHLT from BELEG where ' + ' (BELEG_R=' +
    inttostr(BELEG_R) + ')');

  Forderungen_laut_Beleg := e_r_sqld('select RECHNUNGS_BETRAG from BELEG where ' + ' (BELEG_R=' +
    inttostr(BELEG_R) + ')');

  result := isZeroMoney(Zahlungen - Zahlungen_laut_Beleg) and
    isZeroMoney(Forderungen - Forderungen_laut_Beleg);

end;

procedure e_w_InvalidateCaches;
begin
  // Caches ungültig machen!
  _e_r_Uebergangsfach := MaxInt;
  _e_r_FreiesLager := MaxInt;
end;

function e_r_LagerVorhanden(SORTIMENT_R: integer): boolean;
begin
  result := (e_r_Uebergangsfach_VERLAG_R <> cRID_Null);
end;

function e_r_LagerDiversitaet(LAGER_R: integer): integer;
begin
  result := e_r_sql('select count(RID) from ARTIKEL where LAGER_R=' + inttostr(LAGER_R));
end;

function e_r_LagerVorschlag(SORTIMENT_R: integer; PERSON_R: integer): integer;
var
  VERLAG_R: integer;

  // Entscheidungshilfen
  DecideStr: string;
  DecideStrL: TStringList;

  //
  procedure PruefeVerlag(VERLAG_R: integer);
  var
    cLAGER: TdboCursor;
    FREI: integer;
  begin
    //
    DecideStrL.clear;
    cLAGER := nCursor;

    // Für diesen Verlag ist ein Lager vorgesehen !
    with cLAGER do
    begin
      sql.add('select');
      sql.add(' L.NAME,');
      sql.add(' L.SORTIMENT_R,');
      sql.add(' L.RID,');
      sql.add(' L.DIVERSITAET,');
      sql.add(' (select count(A.RID) from ARTIKEL A where A.LAGER_R=L.RID) BELEGUNG');
      sql.add('from');
      sql.add(' Lager L');
      sql.add('where');
      sql.add(' (VERLAG_R=' + inttostr(VERLAG_R) + ') AND');
      sql.add(' ((SORTIMENT_R=' + inttostr(SORTIMENT_R) + ') OR (SORTIMENT_R IS NULL))');
      sql.add('order by');
      sql.add(' NAME');
      ApiFirst;
      while not(eof) do
      begin

        FREI := FieldByName('DIVERSITAET').AsInteger - FieldByName('BELEGUNG').AsInteger;

        if (FREI > 0) then
        begin

          // Stimmt das Sortiment überein?
          if (FieldByName('SORTIMENT_R').AsInteger = SORTIMENT_R) then
            DecideStr := 'A' // gut
          else
            DecideStr := 'B'; // schlechter

          // Die BELEGUNG sollte möglichst gering sein
          if iLagerHoheDiversitaet then
            DecideStr := DecideStr + '.' + inttostrN(FREI, 4)
          else
            DecideStr := DecideStr + '.' + inttostrN(FieldByName('BELEGUNG').AsInteger, 4);

          // Der NAME sollte von links nach rechts verlaufen
          DecideStr := DecideStr + '.' + FieldByName('NAME').AsString;

          DecideStrL.AddObject(DecideStr, TObject(FieldByName('RID').AsInteger));

        end;
        ApiNext;

      end;
    end;
    cLAGER.free;
  end;

begin
  // Grundvoraussetzung: Lagerungsfähigkeit
  result := -1;
  if (e_r_sqls('select LAGER from SORTIMENT where RID=' + inttostr(SORTIMENT_R)) = cC_True) then
  begin
    // Grundvoraussetzung OK
    VERLAG_R := e_r_sql('select RID from VERLAG where (PERSON_R=' + inttostr(PERSON_R) + ') AND ' +
      '(RID IN (select distinct VERLAG_R from LAGER))');
    // ev. in freies Lager
    if not(VERLAG_R > 0) then
      VERLAG_R := e_r_FreiesLager_VERLAG_R;
    //
    if (VERLAG_R > 0) then
    begin
      //
      DecideStrL := TStringList.create;
      repeat
        PruefeVerlag(VERLAG_R);
        if (DecideStrL.count > 0) then
        begin
          DecideStrL.sort;
          result := integer(DecideStrL.Objects[0]);
          break;
        end;
        if (VERLAG_R = e_r_FreiesLager_VERLAG_R) then
          break;
        VERLAG_R := e_r_FreiesLager_VERLAG_R;
      until false;
      DecideStrL.free;
    end;
  end;
end;

function e_w_EinLagern(ARTIKEL_R: integer): integer;
var
  PERSON_R: integer;
  SORTIMENT_R: integer;
  cARTIKEL: TdboCursor;
  qEREIGNIS: TdboQuery;
  EventText: TStringList;
begin
  // noch mehr Infos nachladen
  cARTIKEL := nCursor;
  with cARTIKEL do
  begin
    sql.add('select VERLAG_R,SORTIMENT_R,LAGER_R from ARTIKEL where RID=' + inttostr(ARTIKEL_R));
    ApiFirst;
    result := FieldByName('LAGER_R').AsInteger;
    PERSON_R := FieldByName('VERLAG_R').AsInteger;
    SORTIMENT_R := FieldByName('SORTIMENT_R').AsInteger;
  end;
  cARTIKEL.free;

  // Lager muss leer sein
  if not(result > 0) then
  begin

    // es muss ein Lagerplatz ermittelt werden
    result := e_r_LagerVorschlag(SORTIMENT_R, PERSON_R);
    if (result > 0) then
    begin

      // die eigentliche Einlagerung machen!
      e_x_sql('update ARTIKEL set LAGER_R=' + inttostr(result) + ' where RID=' +
        inttostr(ARTIKEL_R));

      // erfolg verbuchen!
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
        FieldByName('ART').AsInteger := eT_LagerPlatzZugeteilt;
        FieldByName('ARTIKEL_R').AsInteger := ARTIKEL_R;
        FieldByName('LAGER_R').AsInteger := result;
        EventText := TStringList.create;
        EventText.add('Lagerplatz ' + e_r_sqls('select NAME from LAGER where RID=' +
          inttostr(result)) + ' zugeteilt!');
        FieldByName('INFO').assign(EventText);
        EventText.free;
        Post;
      end;
      qEREIGNIS.free;
    end;
  end;
end;

procedure e_w_Ticket(sContext: string); overload;
begin
  // create a Ticket
end;

procedure e_w_Ticket(slContext: TStringList); overload;
begin
  // create a Ticket
end;

function e_r_Schritte(AUFTRAG_R: integer): TStringList;
var
  cSCHRITTE: TdboCursor;
  BELEG_R: integer;
  BAUSTELLE_R: integer;
begin
  result := TStringList.create;

  //
  BAUSTELLE_R := e_r_sql('select BAUSTELLE_R from AUFTRAG where RID=' + inttostr(AUFTRAG_R));
  BELEG_R := e_r_sql('select max(RID) from BELEG where BAUSTELLE_R=' + inttostr(BAUSTELLE_R));

  cSCHRITTE := nCursor;
  with cSCHRITTE do
  begin
    sql.add('select');
    sql.add(' SCHRITTE.MENGE_MONTAGE,POSTEN.ARTIKEL,SCHRITTE.RID,POSTEN.RID');
    sql.add('from POSTEN');
    sql.add('left join SCHRITTE on');
    sql.add(' (SCHRITTE.POSTEN_R=POSTEN.RID)');
    sql.add('where');
    sql.add(' (POSTEN.BELEG_R=' + inttostr(BELEG_R) + ')');
    sql.add('order by');
    sql.add(' POSTEN.POSNO,POSTEN.RID');
    ApiFirst;
    while not(eof) do
    begin
      result.add(FieldByName('MENGE_MONTAGE').AsString + ';' + FieldByName('ARTIKEL').AsString + ';'
        + FieldByName('SCHRITTE.RID').AsString + ';' + FieldByName('POSTEN.RID').AsString + ';' +
        inttostr(BELEG_R));
      ApiNext;
    end;
  end;
  cSCHRITTE.free;
end;

function e_r_Sparte(Art: string): string;
begin
  repeat

    if (pos('G', Art) = 1) then
    begin
      result := 'Gas';
      break;
    end;

    if (pos('WM', Art) = 1) then
    begin
      result := 'Wärme';
      break;
    end;

    if pos('W', Art) = 1 then
    begin
      result := 'Wasser';
      break;
    end;

    result := 'Strom';

  until true;
end;

procedure e_w_MergeBeleg(BELEG_R_FROM, BELEG_R_TO: integer; sTexte: TStringList = nil);
//
// Imp pend: KUNDEN_INFO := VORLAGE.KUNDEN_INFO + VORSPANN.KUNDEN_INFO
// Bsp: Wir beachten Ihre besonderen Anforderungen laut ROS (aus Vorlage! -> an 1. Position)
// Frohe Weihnacht und ein gutes neue Jahr (aus Vorspann! -> an 2. Position)
//

// kopiere alle Posten des Quell-Beleges in den bestehenden Beleg hinzu
var
  cQUELL_BELEG: TdboCursor;
  cQUELL_POSTEN: TdboCursor;
  cZIEL_POSTEN: TdboCursor;

  qZIEL_POSTEN: TdboQuery;
  qZIEL_BELEG: TdboQuery;
  RoteListe: TStringList;
  InternInfosQuelle: TStringList;
  InternInfosZiel: TStringList;
  DBFieldName: string;
  n: integer;
  InternInfosUpdateZwang: boolean;
  RECHNUNGSANSCHRIFT_R, LIEFERANSCHRIFT_R: integer;
  PostenTextZiel: TStringList;
  ARTIKEL: string;
  BTYP: integer;
begin
  RoteListe := TStringList.create;
  InternInfosQuelle := TStringList.create;
  PostenTextZiel := TStringList.create;
  cQUELL_POSTEN := nCursor;
  cQUELL_BELEG := nCursor;
  cZIEL_POSTEN := nCursor;
  qZIEL_POSTEN := nQuery;
  qZIEL_BELEG := nQuery;

  RoteListe.add('BELEG_R');
  RoteListe.add('RID');
  RoteListe.add('POSNO');
  RoteListe.add('MENGE_RECHNUNG');
  RoteListe.add('MENGE_AUSFALL');
  RoteListe.add('MENGE_GELIEFERT');
  RoteListe.add('MENGE_AGENT');
  RoteListe.add('ZUSAGE');

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
      if InternInfosZiel.values[nextp(InternInfosQuelle[n], '=', 0)] <>
        nextp(InternInfosQuelle[n], '=', 1) then
      begin
        InternInfosZiel.values[nextp(InternInfosQuelle[n], '=', 0)] :=
          nextp(InternInfosQuelle[n], '=', 1);
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

  with cZIEL_POSTEN do
  begin

    //
    sql.add('select * from POSTEN where');
    sql.add(' (BELEG_R=' + inttostr(BELEG_R_TO) + ') and');
    sql.add(' ((PREIS is null) or (PREIS=0.0))');
    sql.add('order by POSNO,RID');

    //
    ApiFirst;
    while not(eof) do
    begin
      PostenTextZiel.add(FieldByName('ARTIKEL').AsString);
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
    sql.add('select * from POSTEN where ' + ' (BELEG_R=' + inttostr(BELEG_R_FROM) + ')');

    // "Alles" kopieren, sobald "Vollständig" gesetzt ist.
    if (InternInfosQuelle.values['Vollständig'] <> cIni_Activate) then
      sql.add(' and (PREIS is not null)');

    sql.add('order by POSNO,RID');
    ApiFirst;
    while not(eof) do
    begin
      with qZIEL_POSTEN do
      begin
        Insert;
        FieldByName('RID').AsInteger := 0;
        FieldByName('BELEG_R').AsInteger := BELEG_R_TO;
        ARTIKEL := '';
        for n := 0 to pred(cQUELL_POSTEN.FieldCount) do
        begin
          DBFieldName := cQUELL_POSTEN.Fields[n].FieldName;
          if (RoteListe.IndexOf(DBFieldName) = -1) then
          begin
            if (DBFieldName = 'ARTIKEL') and not(cQUELL_POSTEN.Fields[n].IsNull) then
            begin
              ARTIKEL := cQUELL_POSTEN.Fields[n].AsString;
              ersetze(InternInfosQuelle, ARTIKEL);
              FieldByName(DBFieldName).AsString := ARTIKEL;
            end
            else
            begin
              FieldByName(DBFieldName).assign(cQUELL_POSTEN.Fields[n]);
            end;
          end;
        end;
        if not(FieldByName('PREIS').IsNull) then
          FieldByName('AUSFUEHRUNG').AsDateTime :=
            long2datetime(date2Long(InternInfosQuelle.values['von']));

        repeat
          if (ARTIKEL <> '') then
            if isZeroMoney(FieldByName('PREIS').AsFloat) then
              if PostenTextZiel.IndexOf(ARTIKEL) <> -1 then
              begin
                // Text-Dublette erkannt -> cancel
                cancel;
                break;
              end;

          // Speichern!
          Post;
        until true;

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
  RoteListe.free;
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
  BlackList: TStringList;
  BelegOptions: TStringList;
  n: integer;
  BELEG_R: integer;
  DBFieldName: string;
  CellStr: string;
  BTYP: integer;
begin
  result := -1;
  BELEG_R := -1;

  //
  cQUELL_BELEG := nCursor;
  cQUELL_POSTEN := nCursor;
  qZIEL_BELEG := nQuery;
  qZIEL_POSTEN := nQuery;
  BlackList := TStringList.create;
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

    // prüfe Existenz der Ziel-Person
    if e_r_sql('select count(rid) from person where RID=' + inttostr(PERSON_R_TO)) <> 1 then
      break;

    // lege neuen Beleg an
    BELEG_R := e_w_BelegNeu(PERSON_R_TO);

    // kopiere alle entsprechenden Felder, ausser folgende System-Felder ...
    BlackList.add('RID');
    BlackList.add('TEILLIEFERUNG');
    BlackList.add('GENERATION');
    BlackList.add('NUMMER');
    BlackList.add('PERSON_R');
    BlackList.add('INTERN_INFO');
    BlackList.add('ANLAGE');
    BlackList.add('ABSCHLUSS');
    BlackList.add('RECHNUNG');
    BlackList.add('FAELLIG');
    BlackList.add('MAHNUNG1');
    BlackList.add('MAHNUNG2');
    BlackList.add('MAHNUNG3');
    BlackList.add('MAHNBESCHEID');
    BlackList.add('MAHNSTUFE');
    BlackList.add('RECHNUNGS_BETRAG');
    BlackList.add('DAVON_BEZAHLT');
    BlackList.add('VERSAND_STATUS');
    BlackList.add('MENGE_RECHNUNG');
    BlackList.add('MENGE_AUFTRAG');
    BlackList.add('MENGE_GELIEFERT');
    BlackList.add('MENGE_AGENT');
    BlackList.add('LAGER_R');
    BlackList.add('DRUCK');
    BlackList.add('MAHNUNG');
    BlackList.add('VOLUMEN');
    BlackList.add('BSTATUS');
    with qZIEL_BELEG do
    begin
      sql.add('select * from BELEG where RID=' + inttostr(BELEG_R) + ' ' + for_update);
      Open;
      First;
      edit;
      for n := 0 to pred(FieldCount) do
        if (BlackList.IndexOf(Fields[n].FieldName) = -1) then
          Fields[n].assign(cQUELL_BELEG.FieldByName(Fields[n].FieldName));
      FieldByName('INTERN_INFO').assign(BelegOptions);
      if (BTYP > 0) then
        FieldByName('BTYP').AsString := inttostr(BTYP - 1);
      Post;
    end;

    // kopiere alle Posten des Quell-Beleges in den neuen Beleg
    BlackList.clear;
    BlackList.add('BELEG_R');
    BlackList.add('RID');

    BlackList.add('MENGE_RECHNUNG');
    BlackList.add('MENGE_AUSFALL');
    BlackList.add('MENGE_GELIEFERT');
    BlackList.add('MENGE_AGENT');
    BlackList.add('ZUSAGE');
    BlackList.add('POSNO');

    with qZIEL_POSTEN do
    begin
      sql.add('select * from POSTEN ' + for_update);
    end;

    with cQUELL_POSTEN do
    begin
      sql.add('select * from POSTEN where BELEG_R=' + inttostr(BELEG_R_FROM) +
        ' order by POSNO,RID');
      ApiFirst;
      while not(eof) do
      begin
        with qZIEL_POSTEN do
        begin
          Insert;
          FieldByName('RID').AsInteger := 0;
          FieldByName('BELEG_R').AsInteger := BELEG_R;
          for n := 0 to pred(cQUELL_POSTEN.FieldCount) do
          begin
            DBFieldName := cQUELL_POSTEN.Fields[n].FieldName;
            if (BlackList.IndexOf(DBFieldName) = -1) then
            begin
              if assigned(sTexte) and (DBFieldName = 'ARTIKEL') and
                not(cQUELL_POSTEN.Fields[n].IsNull) then
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
          end;
          if assigned(sTexte) then
            if not(FieldByName('PREIS').IsNull) then
              FieldByName('AUSFUEHRUNG').AsDateTime :=
                long2datetime(date2Long(sTexte.values['von']));
          Post;
        end;
        ApiNext;
      end;
      Close;
    end;
    result := BELEG_R;

  until true;

  //
  cQUELL_BELEG.free;
  cQUELL_POSTEN.free;
  qZIEL_BELEG.free;
  qZIEL_POSTEN.free;
  BlackList.free;

  if (BelegOptions.values['verbuchen'] = cIni_Activate) then
    e_w_BelegBuchen(BELEG_R, BelegOptions.values['label'] = cIni_Activate);

  BelegOptions.free;

end;

function e_r_ZahlungBezeichnung(PERSON_R: integer): string;
begin
  result := e_r_sqls('select BEZEICHNUNG from ZAHLUNGTYP where RID=' +
    inttostr(e_r_ZahlungRID(PERSON_R)));
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
  // Default
  result := 10;
  ZAHLUNG_R := e_r_ZahlungRID(PERSON_R);
  repeat

    if (ZAHLUNG_R < cRID_FirstValid) then
      break;

    result := e_r_sql('select COALESCE(FAELLIG,' + inttostr(cStandard_ZahlungFrist) +
      ') from ZAHLUNGTYP where RID=' + inttostr(ZAHLUNG_R));

  until true;
end;

function e_r_ZahlungText(ZAHLUNGTYP_R: integer; PERSON_R: integer = 0;
  MoreInfo: TStringList = nil): string;

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
      ZAHLUNGTYP_R := e_r_sql('select RID from ZAHLUNGTYP where HTML_VORLAGE=''' +
        VorlagePrefix + '''');
      if (ZAHLUNGTYP_R >= cRID_FirstValid) then
        break;
    end;

    // Einfach den Standard wählen
    ZAHLUNGTYP_R := e_r_sql('select RID from ZAHLUNGTYP where STANDARD=''' + cC_True + '''');
    // if (ZAHLUNGTYP_R < cRID_FirstValid) then
    // WARNUNG: Keine Zahlungsart definiert!

  until true;

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

procedure e_w_LagerFreigeben;
var
  cARTIKEL: TdboCursor;
  FreeList: TgpIntegerList;
  DateTimeOut: TAnfixDate;
  n: integer;
begin
  DateTimeOut := DatePlus(DateGet, -14);
  FreeList := TgpIntegerList.create;
  cARTIKEL := nCursor;
  with cARTIKEL do
  begin
    sql.add('select A.RID,');
    sql.add('max(W.AUFTRITT) AUFTRITT');
    sql.add('from artikel A');
    sql.add('left join warenbewegung W on');
    sql.add(' A.RID=W.ARTIKEL_R');
    sql.add('left join Lager L on');
    sql.add(' A.LAGER_R=L.RID');
    sql.add('where');
    sql.add(' ((A.mindestbestand is null) or (A.mindestbestand=0)) AND');
    sql.add(' ((A.menge is null) or (A.menge=0)) AND');
    sql.add(' (A.LAGER_R IS NOT NULL) AND');
    sql.add(' (L.FREIGABE=''' + cC_True + ''')');
    sql.add('group by');
    sql.add(' A.RID');
    ApiFirst;
    while not(eof) do
    begin
      if (DateTime2Long(FieldByName('AUFTRITT').AsDateTime) < DateTimeOut) then
        FreeList.add(FieldByName('RID').AsInteger);
      ApiNext;
    end;
  end;

  for n := 0 to pred(FreeList.count) do
    e_x_sql('update ARTIKEL set LAGER_R = NULL where RID=' + inttostr(FreeList[n]));

  FreeList.free;
  cARTIKEL.free;
end;

function e_r_sqlArtikelWhere(AUSGABEART_R, ARTIKEL_R: integer; TableName: string = ''): string;
begin
  result :=
  { } '(' +
  { } '(' + useTable(TableName) + 'ARTIKEL_R' + isRID(ARTIKEL_R) + ') and ' +
  { } '(' + useTable(TableName) + 'AUSGABEART_R' + isRID(AUSGABEART_R) + ')' +
  { } ')';
end;

procedure e_r_ArtikelSortieren(const RIDS: TList);
var
  ClientSorter: TStringList;
  n: integer;
  s, a: string;
  cARTIKEL: TdboCursor;
begin
  if (RIDS.count > 1) then
  begin
    // TITEL ermitteln
    cARTIKEL := nCursor;
    with cARTIKEL do
    begin
      sql.add('select');
      if iGOT then
        sql.add(' A00,');
      sql.add(' TITEL');
      sql.add('from ARTIKEL where RID=:CROSSREF');
      prepare;
    end;
    ClientSorter := TStringList.create;
    for n := 0 to pred(RIDS.count) do
    begin
      cARTIKEL.ParamByName('CROSSREF').AsInteger := integer(RIDS[n]);
      cARTIKEL.ApiFirst;

      // Aus Titel
      s := AnsiUpperCase(cARTIKEL.FieldByName('TITEL').AsString);
      ersetze('#', 'ZZ', s);

      // Aus dem "Lager" Flag bei iGOT Modus
      if iGOT then
      begin
        a := cARTIKEL.FieldByName('A00').AsString + '?';
        case a[1] of
          'Y':
            a := '0';
          '?':
            a := '1';
          'N':
            a := '2';
        end;
        s := a + s;
      end;

      ClientSorter.AddObject(s, Pointer(RIDS[n]));
    end;
    cARTIKEL.free;

    // Sortieren und ausgeben
    ClientSorter.sort;
    for n := 0 to pred(ClientSorter.count) do
      RIDS[n] := ClientSorter.Objects[n];

    ClientSorter.free;
  end;
end;

function e_w_BelegBuchen(BELEG_R: integer; LabelDatensatz: boolean = false): string;
const
  cLimiterType2 = '|';
var
  OutPath: string;
  OutFName: string;
  PaketS: TStringList;
  WerteS: TStringList;
  ParameterS: TStringList;
  OutLineS: string;
  LieferAnschriftRID: integer;
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
      FileCopy(AusgabeBelege[n], OutPath + OutFName + '#' +
        ExtractSegmentBetween(ExtractFileName(AusgabeBelege[n]), '#', chtmlextension) +
        chtmlextension);

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
        FileMove(OutPath + cHTML_ArbeitszeitFName, OutPath + OutFName + '.' +
          cHTML_ArbeitszeitFName);
      end;

    // Sichern in GELIEFERT
    e_x_sql(
      { } 'insert into GELIEFERT ' +
      { } 'select * from POSTEN where ' +
      { } INTERN_INFO.values['FILTER' + GENERATION_POSTFIX] +
      { } ' (BELEG_R=' + inttostr(BELEG_R) + ') ' +
      { } 'order by POSNO,RID');

    // Die einzelnen Teillieferungen über POSNO klar trennen
    e_x_sql('update GELIEFERT ' + 'set POSNO=' + inttostr(TEILLIEFERUNG) + ' where' + ' (BELEG_R=' +
      inttostr(BELEG_R) + ') and' + ' (POSNO is null)');

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
          FieldByName('MENGE_GELIEFERT').AsInteger := FieldByName('MENGE_GELIEFERT').AsInteger +
            Menge_Rechnung;
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

    Menge_AuftragNachLieferung := e_r_sql('select MENGE_AUFTRAG from BELEG where RID=' +
      inttostr(BELEG_R));

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
    e_x_sql('UPDATE WARENBEWEGUNG SET BEWEGT=''' + cC_True + ''' WHERE BELEG_R=' +
      inttostr(BELEG_R));

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
            sql.add('select * from VERSENDER where RID=' +
              inttostr(cVERSAND.FieldByName('VERSENDER_R').AsInteger));
            ApiFirst;
          end;

          gewicht := cVERSAND.FieldByName('GEWICHT').AsInteger + cVERSAND.FieldByName('LEERGEWICHT')
            .AsInteger;

          // a) richtige Person lokalisieren:
          LieferAnschriftRID := 0;
          repeat

            if not(FieldByName('LIEFERANSCHRIFT_R').IsNull) then
            begin
              LieferAnschriftRID := FieldByName('LIEFERANSCHRIFT_R').AsInteger;
              break;
            end;
            LieferAnschriftRID := FieldByName('PERSON_R').AsInteger;

          until true;

          // b) alle Personen-Daten laden:
          with cPERSON do
          begin
            sql.add('select * from PERSON where RID=' + inttostr(LieferAnschriftRID));
            ApiFirst;
            if eof then;
          end;
          with cANSCHRIFT do
          begin
            sql.add('select * from ANSCHRIFT where RID=' +
              inttostr(cPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsInteger));
            ApiFirst;
            if eof then;
          end;

          Name1_2 := e_r_Person2Zeiler(LieferAnschriftRID);

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
                  NoSemi(cPERSON.FieldByName('VORNAME').AsString + ' ' +
                  cPERSON.FieldByName('NACHNAME').AsString) + ';' +

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
                  AppendStringsToFile(PaketS, ExtractFilePath(cVERSENDER.FieldByName('EXPORTPFAD')
                    .AsString) + 'Historie.txt');
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
                for n := 0 to pred(ParameterS.count) do
                begin
                  k := pos('=', ParameterS[n]);
                  if k > 0 then
                  begin
                    OutLineS := OutLineS + cutblank(copy(ParameterS[n], 1, pred(k))) +
                      cLimiterType2;
                    WerteS.add(cutblank(copy(ParameterS[n], succ(k), MaxInt)));
                  end;
                end;

                // TitelZeile
                PaketS.add(OutLineS);
                try
                  if DirExists(cVERSENDER.FieldByName('EXPORTPFAD').AsString) then
                    PaketS.SaveToFile(cVERSENDER.FieldByName('EXPORTPFAD').AsString +
                      'DPKopf_.txt');
                except
                  on E: exception do
                  begin
                    CareTakerLog(cERRORText + ' e_w_BelegBuchen(' + inttostr(BELEG_R) +
                      '): Deutsche Post : ' + E.Message);
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
                  NoSemi(e_r_Localize2(cANSCHRIFT.FieldByName('LAND_R').AsInteger, iHeimatLand)) +
                  cLimiterType2 +

                // Gewicht
                  format('%.3f', [gewicht / 1000.0]) + cLimiterType2;

                for n := 0 to pred(WerteS.count) do
                  OutLineS := OutLineS + WerteS[n] + cLimiterType2;

                // Datenzeile
                PaketS.add(OutLineS);

                if LabelDatensatz then
                begin
                  try
                    if DirExists(cVERSENDER.FieldByName('EXPORTPFAD').AsString) then
                    begin
                      PaketS.SaveToFile(cVERSENDER.FieldByName('EXPORTPFAD').AsString + 'DP_' + _id
                        + '.txt');
                      AppendStringsToFile(PaketS,
                        ExtractFilePath(cVERSENDER.FieldByName('EXPORTPFAD').AsString) +
                        'Historie.txt');
                    end;
                  except
                    on E: exception do
                    begin
                      CareTakerLog(cERRORText + ' e_w_BelegBuchen(' + inttostr(BELEG_R) +
                        '): Deutsche Post : ' + E.Message);
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
    until true;

    cVERSAND.free;
    cVERSENDER.free;

    // nun noch das Ausgangsdatum buchen, dies ist das Zeichen für "versendet"!
    e_x_sql('update VERSAND set AUSGANG=''now'' where (BELEG_R=' + inttostr(BELEG_R) +
      ') AND (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')');

    qBELEG.free;

    b_w_ForderungBuchen(BELEG_R, RechnungsBetrag);

  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_w_BelegBuchen(' + inttostr(BELEG_R) + '): ' + E.Message);
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
    e_x_sql('update POSTEN set' + ' MWST = 0.0 ' + 'where' + ' (MWST is not null) and' +
      ' (BELEG_R=' + inttostr(BELEG_R) + ')');
    result := true;
  except
    on E: exception do
    begin
      CareTakerLog(cERRORText + ' e_w_BelegDrittlandAusfuhr(' + inttostr(BELEG_R) + '): ' +
        E.Message);
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
        FileDelete(e_r_BelegFName(cRID_Null, BELEG_R, FieldByName('TEILLIEFERUNG')
          .AsInteger, true));

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
      CareTakerLog(cERRORText + ' e_w_BelegStorno(' + inttostr(BELEG_R) + '): ' + E.Message);
    end;
  end;
end;

function e_r_MengenAusgabe(MENGE, EINHEIT_R: integer; FormatStr: string = '%d'): string;
var
  KommaZahl: double;
  cEINHEIT: TdboCursor;
  AusgabeS: string;
begin
  AusgabeS := inttostr(MENGE);
  if (EINHEIT_R > 0) then
  begin
    cEINHEIT := nCursor;
    with cEINHEIT do
    begin
      sql.add('select * from EINHEIT where RID=' + inttostr(EINHEIT_R));
      ApiFirst;
      if not(eof) then
      begin
        if (FieldByName('EINHEIT').AsInteger > 0) then
        begin
          if (FieldByName('EINHEIT').AsInteger = 3600) then
          begin
            // Sonderfall "Stunden"
            AusgabeS := secondstostr(MENGE);
          end
          else
          begin
            KommaZahl := MENGE;
            KommaZahl := KommaZahl / FieldByName('EINHEIT').AsFloat;
            AusgabeS := format('%.' + inttostr(pred(length(FieldByName('EINHEIT').AsString))) + 'f',
              [KommaZahl]);
          end;
        end;
        AusgabeS := cutblank(AusgabeS + ' ' + FieldByName('BASIS').AsString);
      end;
    end;
    cEINHEIT.free;
  end;
  result := FormatStr;
  ersetze('%d', AusgabeS, result);
  result := UnbreakAble(result);
end;

function e_r_EinzelPreisAusgabe(PREIS: double; EINHEIT_R: integer): string;
var
  Basis: string;
begin
  result := format('%.2m', [PREIS]);
  if (EINHEIT_R > 0) then
  begin
    Basis := e_r_sqls('select BASIS from EINHEIT where RID=' + inttostr(EINHEIT_R));
    if (Basis <> '') then
      result := result + cNonBreakableSpace + '/' + cNonBreakableSpace + Basis;
  end;
  result := UnbreakAble(result);
end;

function e_r_PostenPreis(EinzelPreis: double; Anz, EINHEIT_R: integer): double;
var
  Divisor: double;
begin
  result := 0.0;
  if (EINHEIT_R > 0) then
  begin
    Divisor := e_r_sql('select EINHEIT from EINHEIT where RID=' + inttostr(EINHEIT_R));
    if (Divisor <> 0) then
      result := cPreisRundung((EinzelPreis * Anz) / Divisor);
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

function e_w_AusgabeBeleg(BELEG_R: integer; NurGeliefertes: boolean; AlsLieferschein: boolean)
  : TStringList;
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
  ArtikelInfo: TStringList;
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

  cPERSON, cANSCHRIFT, cBELEG, cPOSTEN, cARTIKEL: TdboCursor;

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
  ArtikelInfo := TStringList.create;
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
  cARTIKEL := nCursor;
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
        sql.add('select * from ANSCHRIFT where RID=' +
          inttostr(cPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsInteger));
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

      DatensammlerGlobal.add('Titel=' + _('Beleg') + ' ' + inttostr(BELEG_R) + '-' +
        inttostrN(FieldByName('TEILLIEFERUNG').AsInteger, 2));
      DatensammlerGlobal.add('R#=' + inttostr(BELEG_R));
      DatensammlerGlobal.add('R.G#=' + inttostr(BELEG_R) + '-' + inttostr(GENERATION));
      DatensammlerGlobal.add('Medium=' + FieldByName('MEDIUM').AsString);
      DatensammlerGlobal.add('Motivation=' + FieldByName('MOTIVATION').AsString);
      DatensammlerGlobal.add('Anleger=' + e_r_BearbeiterKuerzel(FieldByName('ANLEGER_R')
        .AsInteger));
      DatensammlerGlobal.add('Bearbeiter=' + e_r_BearbeiterKuerzel(FieldByName('BEARBEITER_R')
        .AsInteger));
      DatensammlerGlobal.add('Ausgeber=' + e_r_BearbeiterKuerzel(sBearbeiter));
      DatensammlerGlobal.add('T#=' + inttostrN(FieldByName('TEILLIEFERUNG').AsInteger, 2));
      DatensammlerGlobal.add('GNT#=' + inttostrN(GENERATION, 2));
      DatensammlerGlobal.add('PL Beleg Titel=' + _('PACKLISTE NUMMER') + ' ' + inttostr(BELEG_R) +
        '-' + inttostrN(FieldByName('TEILLIEFERUNG').AsInteger, 2) + VerpackerMehrInfo);
      DatensammlerGlobal.add('Datum=' + long2dateLocalized(DateGet));
      DatensammlerGlobal.add('AktuellesDatum=' + DatumLocalized);
      DatensammlerGlobal.add('AktuelleUhrzeit=' + Uhr);
      if FieldByName('RECHNUNG').IsNull then
        DatensammlerGlobal.add('Rechnungsdatum=' + DatumLocalized)
      else
        DatensammlerGlobal.add('Rechnungsdatum=' + long2dateLocalized(FieldByName('RECHNUNG')
          .AsDateTime));
      DatensammlerGlobal.add('Zahldatum=' + long2dateLocalized(DatePlus(DateGet,
        e_r_ZahlungFrist(PERSON_R))));
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
        _Anzahlung := (FieldByName('DAVON_BEZAHLT').AsFloat -
          FieldByName('RECHNUNGS_BETRAG').AsFloat);

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
        e_r_PostenInfo(cPOSTEN, NurGeliefertes, EinzelpreisNetto, _Anz, _AnzAuftrag, _AnzGeliefert,
          _AnzStorniert, _AnzNachlieferung, _Rabatt, _EinzelPreis, _MwStSatz);
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

          until true;

        end;
        //
        ClientSorter.AddObject(PostenzeileSortStr + '.' + inttostrN(FieldByName('POSNO').AsInteger,
          8) + '.' + inttostrN(FieldByName('RID').AsInteger, 8),
          Pointer(FieldByName('RID').AsInteger));

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
        e_r_PostenInfo(cPOSTEN, NurGeliefertes, EinzelpreisNetto, _Anz, _AnzAuftrag, _AnzGeliefert,
          _AnzStorniert, _AnzNachlieferung, _Rabatt, _EinzelPreis, _MwStSatz);
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
            DatensammlerLokal.add('Einzel=' + e_r_EinzelPreisAusgabe(_EinzelPreis,
              FieldByName('EINHEIT_R').AsInteger));
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
          DatensammlerLokal.add('Ausfuehrung=' + long2date8(DateTime2Long(FieldByName('AUSFUEHRUNG')
            .AsDateTime)));

        if (_Anz <> _AnzAuftrag) then
        begin
          DatensammlerLokal.add('Anz=' + e_r_MengenAusgabe(_Anz, EINHEIT_R) + '/' +
            e_r_MengenAusgabe(_AnzAuftrag, EINHEIT_R));
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
          _AddText := _AddText + #13 + e_r_MengenAusgabe(_AnzStorniert, EINHEIT_R,
            iNichtMehrLieferbar);

        // wurde bereits geliefert
        if (_AnzGeliefert > 0) then
          _AddText := _AddText + #13 + e_r_MengenAusgabe(_AnzGeliefert, EINHEIT_R,
            iBereitsGeliefertInfo);

        // wird nachgeliefert
        if (_AnzNachlieferung > 0) then
          _AddText := _AddText + #13 + e_r_MengenAusgabe(_AnzNachlieferung, EINHEIT_R,
            iNachlieferungInfo);

        // Artikel-Text
        _titel := FieldByName('ARTIKEL').AsString;
        ersetze(DatensammlerGlobal, _titel);

        if FieldByName('MENGE').IsNull and (_Anz = 0) and (_AnzAuftrag = 0) and
          (length(FieldByName('ARTIKEL').AsString) > 0) then
          DatensammlerLokal.add('Text=@' + '<b>' + Ansi2html(_titel + _AddText) + '</b>')
        else
          DatensammlerLokal.add('Text=' + _titel + _AddText);

        if not(FieldByName('ARTIKEL_R').IsNull) then
        begin

          with cARTIKEL do
          begin
            sql.clear;
            sql.add('select * from ARTIKEL where RID=' + inttostr(cPOSTEN.FieldByName('ARTIKEL_R')
              .AsInteger));
            ApiFirst;

            // Artikel-Daten holen!
            e_r_sqlt(FieldByName('INTERN_INFO'), ArtikelInfo);

            // aus dem Artikelstamm übernommene Felder
            DatensammlerLokal.add('No=' + FieldByName('NUMERO').AsString);
            DatensammlerLokal.add('KomponistNachname=' + e_r_MusikerNurNachName
              (FieldByName('KOMPONIST_R').AsInteger));
            DatensammlerLokal.add('ArrangeurNachname=' + e_r_MusikerNurNachName
              (FieldByName('ARRANGEUR_R').AsInteger));
            DatensammlerLokal.add('GEMA_WN=' + FieldByName('GEMA_WN').AsString);
            DatensammlerLokal.add('Verlag=' + e_r_Verlag(FieldByName('VERLAG_R').AsInteger));
            if (_Anz <> 0) then
              DatensammlerLokal.add('Konto=' + b_r_Konto(FieldByName('SORTIMENT_R').AsInteger))
            else
              DatensammlerLokal.add('Konto=');

            // Verlag - Nummer (GOT-Kürzel!)
            if cPOSTEN.FieldByName('INFO').IsNull then
              DatensammlerLokal.add('VerlagNo=' + UnbreakAble(FieldByName('VERLAGNO').AsString))
            else
              DatensammlerLokal.add('VerlagNo=' + UnbreakAble(cPOSTEN.FieldByName('INFO')
                .AsString));

            // Lager-Packliste ausgeben!
            if (cPOSTEN.FieldByName('MENGE_RECHNUNG').AsInteger > 0) or
              (cPOSTEN.FieldByName('MENGE_GELIEFERT').AsInteger > 0) then
            begin

              if (EvenOddCounterPackListe mod 2 = 0) then
                DatensammlerLokal.add('load PL_ARTIKEL EVEN,PL_ARTIKEL')
              else
                DatensammlerLokal.add('load PL_ARTIKEL ODD,PL_ARTIKEL');
              inc(EvenOddCounterPackListe);

              DatensammlerLokal.add('PL_Anz=' + inttostr(cPOSTEN.FieldByName('MENGE_RECHNUNG')
                .AsInteger) + '/(' + inttostr(cPOSTEN.FieldByName('MENGE_GELIEFERT').AsInteger) +
                ') ' + FieldByName('NUMERO').AsString + ' @' + e_r_LagerPlatzNameFromLAGER_R
                (FieldByName('LAGER_R').AsInteger));
              DatensammlerLokal.add('PL_Name=' + e_r_LagerPlatzNameFromLAGER_R
                (FieldByName('LAGER_R').AsInteger));
              DatensammlerLokal.add
                ('PL_Lager=' + copy(e_r_Verlag(FieldByName('VERLAG_R').AsInteger), 1, 20) + '-' +
                FieldByName('VERLAGNO').AsString);

              DatensammlerLokal.add('PL_No=' + copy(FieldByName('TITEL').AsString, 1, 25));
            end;
            Close;
          end;

        end
        else
        begin
          DatensammlerLokal.add('No=');
          DatensammlerLokal.add('VerlagNo=' + UnbreakAble(FieldByName('INFO').AsString));
          DatensammlerLokal.add('Verlag=');
          DatensammlerLokal.add('KomponistNachname=');
          DatensammlerLokal.add('ArrangeurNachname=');
          DatensammlerLokal.add('GEMA_WN=');
          if (_Anz <> 0) then
            DatensammlerLokal.add('Konto=' + b_r_Konto(cRID_Null))
          else
            DatensammlerLokal.add('Konto=');
        end;

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
      DatensammlerGlobal.add('Beleg Titel=' + _('LIEFERSCHEIN NUMMER') + ' ' + inttostr(BELEG_R));
      DatensammlerGlobal.add('Beleg_kurz=' + _('Lieferschein'));
    end
    else
    begin
      if (_EndSumme >= 0) then
      begin
        DatensammlerGlobal.add('Beleg Titel=' + _('RECHNUNG NUMMER') + ' ' + inttostr(BELEG_R));
        DatensammlerGlobal.add('Beleg_kurz=' + _('Rechnung'));
      end
      else
      begin
        DatensammlerGlobal.add('Beleg Titel=' + _('GUTSCHRIFT NUMMER') + ' ' + inttostr(BELEG_R));
        DatensammlerGlobal.add('Beleg_kurz=' + _('Gutschrift'));
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

    _SkontoAbzug := cPreisRundung(_EndSumme * (strtodoubledef(ZahlungInfo.values['SKONTO'],
      0) / 100.0));
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
      DatensammlerLokal.add('PunkteText=' + _('Auftrag von') + ' ' +
        e_r_Person(cBELEG.FieldByName('PERSON_R').AsInteger));
    end;

    if not(AlsLieferschein) then
      if not(cBELEG.FieldByName('LIEFERANSCHRIFT_R').IsNull) then
      begin
        DatensammlerLokal.add('load PUNKTE');
        DatensammlerLokal.add('PunkteText=' + _('Lieferung an') + ' ' +
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

    until true;

    // jetzt erst rausbelichten!
    MyBeleg := THTMLTemplate.create;
    if FileExists(MyProgramPath + cHTMLTemplatesDir + AusgabeFNamePreFix + '3spaltig_n.html') then
      MyBeleg.LoadFromFile(MyProgramPath + cHTMLTemplatesDir + AusgabeFNamePreFix +
        '3spaltig_n.html')
    else if FileExists(MyProgramPath + cHTMLTemplatesDir + AusgabeFNamePreFix + '.html') then

      MyBeleg.LoadFromFile(MyProgramPath + cHTMLTemplatesDir + AusgabeFNamePreFix + '.html')
    else
      MyBeleg.addFatalError('Vorlage .\' + cHTMLTemplatesDir + AusgabeFNamePreFix +
        '.html nicht gefunden');

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
    Dir(MyProgramPath + cHTMLTemplatesDir + AusgabeFNamePreFix + '#?' + chtmlextension,
      sDuplikate, false);
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
      CareTakerLog(cERRORText + ' e_r_AusgabeBeleg(' + inttostr(BELEG_R) + '): ' + E.Message);
    end;
  end;
  // Speicher freigeben
  MwStSaver.free;
  InternInfo.free;
  ArtikelInfo.free;
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
  cARTIKEL.free;
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
  P4: TStringList;
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
  P4 := e_r_Adressat(PERSON_R);
  OutHeaderL.add('Adresse1');
  OutHeaderL.add('Adresse2');
  OutHeaderL.add('Adresse3');
  OutHeaderL.add('Adresse4');
  OutDataL.addstrings(P4);
  P4.free;

  cPERSON := nCursor;
  with cPERSON do
  begin
    sql.add('select * from PERSON where RID=' + inttostr(PERSON_R));
    ApiFirst;
  end;

  cANSCHRIFT := nCursor;
  with cANSCHRIFT do
  begin
    sql.add('select * from ANSCHRIFT where RID=' + inttostr(cPERSON.FieldByName('PRIV_ANSCHRIFT_R')
      .AsInteger));
    ApiFirst;
    OutHeaderL.add('Adresse5');
    OutDataL.add(FieldByName('STRASSE').AsString);

    OutHeaderL.add('Adresse6');
    OutDataL.add(e_r_Ort(PERSON_R));

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

const
  _e_r_Ausgabeart_Cache: TsTable = nil;
  // imp pend: registrieren des Cache in einer globalen "flush" Routine

function e_r_Ausgabeart(AUSGABEART_R: integer): string;
var
  row: integer;
begin
  (* // no cache
    result := e_r_sqls('select NAME from AUSGABEART where RID=' +
    inttostr(AUSGABEART_R));
  *)
  if not(assigned(_e_r_Ausgabeart_Cache)) then
    _e_r_Ausgabeart_Cache := csTable(
      { } 'select ' +
      { 0 } ' RID,' +
      { 1 } ' NAME ' +
      { } 'from AUSGABEART');

  row := _e_r_Ausgabeart_Cache.locate(0, inttostr(AUSGABEART_R));
  if (row = -1) then
    result := ''
  else
    result := _e_r_Ausgabeart_Cache.readCell(row, 1) + ' ';

end;

function e_r_PreisValid(p: double): boolean;
begin
  result := (p <> cPreis_vergriffen) and (p <> cPreis_aufAnfrage);
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
    sql.add('select RID,SATZ1,SATZ2 from BUCHUNG_KALKULATION where ' + ' (''' + long2date(Datum) +
      ''' between VON and BIS) and' + ' (AKTIV = ''' + cC_True + ''')');
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

function e_r_AuftragNummer(BAUSTELLE_R: integer): integer;
begin
  result := e_r_sql('select max(NUMMER) from AUFTRAG where ' + ' (BAUSTELLE_R=' +
    inttostr(BAUSTELLE_R) + ') AND ' + ' (STATUS<>6)');
end;

function e_r_AuftragPlausi(AUFTRAG_R: integer): string;
var
  cAUFTRAG: TdboCursor;
  sProtokoll: TStringList;
  sZaehlerInfo: TStringList;
  sIntern: TStringList;
  sResult: string;

  procedure Log(s: string);
  begin
    if (sResult = cOLAPNull) then
      sResult := s
    else
      sResult := sResult + cOLAPcsvLineBreak + s;
  end;

  procedure CheckIt(V, b, a, ZWS: double; Prefix: string);

    function MoreInfo: string;
    begin
      result := ' (' + Prefix + ': ' + inttostr(round(a)) + ', ' + inttostr(round(V)) + ' - ' +
        inttostr(round(b)) + ': ' + inttostr(round(ZWS)) + ')';
    end;

  var
    BandErweiterung: double;

  begin
    repeat

      //
      if (V < 0) then
      begin
        Log('[Q16] keine "Untere Grenze" definiert' + MoreInfo);
      end;
      if (b < 0) then
      begin
        Log('[Q17] keine "Obere Grenze" definiert' + MoreInfo);
      end;
      if (a < 0) then
      begin
        Log('[Q18] kein "Letzter Stand" definiert' + MoreInfo);
      end;

      //
      if (ZWS < 0) then
      begin
        Log('[Q01] Ablesestand fehlt' + MoreInfo);
        break;
      end;
      if (a > 0) and (ZWS < a) then
      begin
        if (ZWS + 10 >= a) then
          Log('[Q13] Ablesestand unterschreitet leicht letzten Stand' + MoreInfo)
        else
          Log('[Q19] Ablesestand kleiner als letzter Stand' + MoreInfo);
        break;
      end;

      if (b - V < 0) then
      begin
        Log('[Q06] Zählwerk-Überlauf erwartet' + MoreInfo);
      end;

      BandErweiterung := max((b - V) * 3, 1000);

      if (ZWS < V) then
      begin
        if (ZWS < V - BandErweiterung) then
          Log('[Q07] Ablesestand unterschreitet massiv untere Grenze' + MoreInfo)
        else
          Log('[Q08] Ablesestand unterschreitet leicht untere Grenze' + MoreInfo);

        break;
      end;

      if (ZWS > b) then
      begin
        if (ZWS > b + BandErweiterung) then
          Log('[Q09] Ablesestand überschreitet massiv obere Grenze' + MoreInfo)
        else
          Log('[Q10] Ablesestand überschreitet leicht obere Grenze' + MoreInfo);
        break;
      end;

    until true;
  end;

var
  v1, b1, v2, b2, ht, nt: double;
  a1, a2: double;
  ZAEHLER_WECHSEL: TAnfixDate;

begin
  try
    // Singen!
    sResult := cOLAPNull;
    cAUFTRAG := nCursor;
    sProtokoll := TStringList.create;
    sZaehlerInfo := TStringList.create;
    sIntern := TStringList.create;
    with cAUFTRAG do
    begin
      // SQL
      sql.add('select');
      sql.add(' ART, STATUS, PROTOKOLL, INTERN_INFO, ZAEHLER_INFO, ZAEHLER_WECHSEL, ZAEHLER_STAND_ALT, ZAEHLER_STAND_NEU');
      sql.add('from');
      sql.add(' AUFTRAG');
      sql.add('where');
      sql.add(' (RID=' + inttostr(AUFTRAG_R) + ')');

      ApiFirst;
      if (FieldByName('STATUS').AsInteger = cs_Erfolg) then
      begin
        e_r_sqlt(FieldByName('PROTOKOLL'), sProtokoll);
        e_r_sqlt(FieldByName('ZAEHLER_INFO'), sZaehlerInfo);
        e_r_sqlt(FieldByName('INTERN_INFO'), sIntern);

        // AF-Patch eCommerce.pas 10678 +
        // ZAEHLER_WECHSEL : TANFiXDate;
        ZAEHLER_WECHSEL := DateTime2Long(FieldByName('ZAEHLER_WECHSEL').AsDateTime);
        if (ZAEHLER_WECHSEL > DateGet) then
          Log('[Q14] Ablesedatum liegt in der Zukunft');
        if (ZAEHLER_WECHSEL < 20080822) then
          Log('[Q15] Ablesedatum liegt vor Baustellenbeginn');

        if (sIntern.values['UNGEMELDET'] <> '') then
          Log('[Q11] Lief schon mal über die Schnittstelle');
        if (sIntern.values['QS_UMGANGEN'] <> '') then
          Log('[Q12] Qualitätssicherung übergangen');

        v1 := round(strtodoubledef(sZaehlerInfo.values['v1'], -1));
        b1 := round(strtodoubledef(sZaehlerInfo.values['b1'], -1));
        a1 := round(strtodoubledef(sZaehlerInfo.values['a1'], -1));
        ht := trunc(strtodoubledef(FieldByName('ZAEHLER_STAND_ALT').AsString, -1));

        if (pos('2', FieldByName('ART').AsString) > 0) then
        begin
          CheckIt(v1, b1, a1, ht, 'HT');
          // E2
          v2 := round(strtodoubledef(sZaehlerInfo.values['v2'], -1));
          b2 := round(strtodoubledef(sZaehlerInfo.values['b2'], -1));
          a2 := round(strtodoubledef(sZaehlerInfo.values['a2'], -1));
          nt := trunc(strtodoubledef(FieldByName('ZAEHLER_STAND_NEU').AsString, -1));
          CheckIt(v2, b2, a2, nt, 'NT');
        end
        else
        begin
          CheckIt(v1, b1, a1, ht, 'ET');
          // E

        end;

      end
      else
      begin
        sResult := '';
      end;

    end;
    if (sResult = cOLAPNull) then
      result := ''
    else
      result := sResult;
    cAUFTRAG.free;
    sProtokoll.free;
    sZaehlerInfo.free;
    sIntern.free;
  except
    on E: exception do
    begin
      result := E.Message;
    end;
  end;
end;

procedure e_w_DruckBeleg(BELEG_R: integer);
begin
  e_x_sql('update BELEG set DRUCK=''now'' where (RID=' + inttostr(BELEG_R) +
    ') and (DRUCK IS NULL)');
end;

function e_r_Artikel(AUSGABEART_R, ARTIKEL_R: integer): string;
begin
  result := e_r_sqls('select TITEL from ARTIKEL where RID=' + inttostr(ARTIKEL_R));
  if (AUSGABEART_R > 0) then
    result := e_r_sqls('select KUERZEL from AUSGABEART where RID=' + inttostr(AUSGABEART_R)) +
      ' ' + result;
end;

function e_r_ArtikelLink(ARTIKEL_R: integer): string;
var
  s: AnsiString;
  str: AnsiString;
  cBLOWFISH: TDCP_blowfish;
  CryptKey: array [0 .. 1023] of AnsiChar;
begin
  cBLOWFISH := TDCP_blowfish.create(nil);
  with cBLOWFISH do
  begin
    StrPCopy(CryptKey, iShopKey);
    Init(CryptKey, length(iShopKey) * 8, nil);
    str := Int64asKeyStr(ARTIKEL_R);
    SetLength(s, 8);
    EncryptCFB8bit(str[1], s[1], 8);
    result := AnsiTorfc1738(Base64EncodeStr(s));
  end;
  cBLOWFISH.free;
end;

function e_r_PortoFreiAbBrutto(PERSON_R: integer): double;
var
  xOLAP: TStringList;
  pOLAP: TStringList;
  rOLAP: TStringList;
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
      pOLAP := TStringList.create;
      pOLAP.add('$PERSON_R=' + inttostr(PERSON_R));
      xOLAP := e_r_text(StrToIntDef(nextp(iPortoFreiAbBrutto, ':', 1), 0));
      rOLAP := e_r_OLAP(xOLAP, pOLAP);
      result := strtodoubledef(rOLAP.values['PORTOFREIAB'], 0);
      pOLAP.free;
      rOLAP.free;
      xOLAP.free;
    end;

  until true;
end;

function e_r_Name(ib_q: TdboDataSet): string; overload;
begin
  result := cutblank(ib_q.FieldByName('VORNAME').AsString + ' ' + ib_q.FieldByName('NACHNAME')
    .AsString);
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
  until true;
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
      CareTakerLog(cERRORText + ' e_r_fax: ' + E.Message);
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

    //
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

function e_r_Prozent(Satz: integer; mDatum: TAnfixDate = cIllegalDate): double;
begin
  if (Satz = 0) then
    result := 0
  else
  begin
    if (mDatum = cIllegalDate) then
      mDatum := DateGet;

    result := e_r_sqld(
      { } 'select SATZ from MWST where ' +
      { } ' (NAME=''SATZ' + inttostr(Satz) + ''') and ' +
      { } ' (''' + long2date(mDatum) + ''' between VON_DATUM and BIS_DATUM)');
  end;
end;

function e_r_Satz(Prozent: double; mDatum: TAnfixDate): integer;
begin
  if (Prozent = 0) then
    result := 0
  else
    result := StrToIntDef(
      { } StrFilter('0123456789', e_r_sqls(
      { } 'select NAME from MWST where ' +
      { } ' (SATZ=' + FloatToStrISO(Prozent) + ') and ' +
      { } ' (''' + long2date(mDatum) + ''' between VON_DATUM and BIS_DATUM)')), 0);
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
          CareTakerLog(cERRORText + ' e_x_BelegAusPOS: ' + E.Message);
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

  e_x_sql('update ARTIKEL set RANG=null');
  e_x_sql('update ARTIKEL_AA set RANG=null');

  // update mechanismus vorbereiten
  IB_SET_ARTIKEL := nScript;
  with IB_SET_ARTIKEL do
  begin
    sql.add('UPDATE ARTIKEL');
    sql.add('SET RANG=:RANG');
    sql.add('WHERE RID=:CR');
    // prepare;
  end;

  IB_SET_ARTIKEL_AA := nScript;
  with IB_SET_ARTIKEL_AA do
  begin
    sql.add('UPDATE ARTIKEL_AA');
    sql.add('SET RANG=:RANG');
    sql.add('WHERE (ARTIKEL_R=:CR_A)');
    sql.add('AND (AUSGABEART_R=:CR_B)');
    // prepare;
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
    sql.add(' COALESCE(LETZTERVERKAUF,LETZTEAENDERUNG) as AKTION');
    sql.add('from');
    sql.add(' ARTIKEL');
    sql.add('where');
    sql.add(' RANG is null');
    sql.add('order by');
    sql.add(' AKTION desc, RID desc');
    for_update(sql);
    Open;
    First;
  end;

  IB_ARTIKEL_AA := nQuery;
  with IB_ARTIKEL_AA do
  begin
    sql.add('select');
    sql.add(' RANG,');
    sql.add(' COALESCE(LETZTERVERKAUF,LETZTEAENDERUNG) as AKTION');
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
      if not(IB_ARTIKEL_AA.FieldByName('AKTION').IsNull) and
        not(IB_ARTIKEL.FieldByName('AKTION').IsNull) then
      begin
        if (IB_ARTIKEL_AA.FieldByName('AKTION').AsDateTime > IB_ARTIKEL.FieldByName('AKTION')
          .AsDateTime) then
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

    until true;

    // set RANG
    inc(n);
    with IB_SET_RANG do
    begin
      edit;
      FieldByName('RANG').AsFloat := n;
      Post;
      Next;
    end;

  until false;

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
            FieldByName('LIEFERZEIT').AsInteger := (LieferzeitAsSeconds - BonusAsSeconds)
              div AnzWarenBewegungen;
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
  e_x_sql('update ARTIKEL set LIEFERZEIT=null');

  with ARTIKEL do
    sql.add('select LIEFERZEIT from ARTIKEL where RID=:CROSSREF ' + for_update);

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
    sql.add(' (EREIGNIS.AUFTRITT>''' + long2date(DatePlus(DateGet, -iLieferzeitZeitfenster)
      ) + ''')');
    sql.add('ORDER BY');
    sql.add(' EREIGNIS.ARTIKEL_R');
    Open;
    fillchar(LieferzeitDurchschnitt, sizeof(LieferzeitDurchschnitt), 0);
    LieferzeitDurchschnitt.ARTIKEL_R := -1;
    ApiFirst;
    while not(eof) do
    begin

      // Plausibilität des Records
      if (FieldByName('EREIGNIS.AUFTRITT').AsDateTime > FieldByName('BBELEG.BESTELLT').AsDateTime)
      then
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
          inc(LieferzeitAsSeconds, SecondsDiff(EndeD,
            datetime2seconds(FieldByName('EREIGNIS.AUFTRITT').AsDateTime),

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
  PERSON.sql.add('SELECT LIEFERZEIT FROM PERSON WHERE RID=:CROSSREF ' + for_update);
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

end.
