{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2019 - 2023  Andreas Filsinger
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
unit Funktionen_Artikel;

{$ifdef fpc}
{$mode delphi}
{$endif}

interface

uses
  Classes,
  anfix,
  gplists,
  c7zip,
  globals,
  dbOrgaMon;

///////////////////
// A R T I K E L //
///////////////////

// liefert den Rabatt, mit dem dieser Artikel eingekauft wird
function e_r_ekRabatt(ARTIKEL_R: integer): double;

// liefert den Rabatt, den diese Person bei diesem Artikel erhält
// nebenbei:
// wird bei dieser Person ohne MwSt-Ausweisgearbeitet (Ausländer)?
// soll dabei einfach der eigentliche Bruttopreis als Nettopreis ausgewiesen werden?
function e_r_Rabatt(ARTIKEL_R, PERSON_R: integer; var Netto: boolean; var NettoWieBrutto: boolean): double;

// MwSt: liefert die MwSt des Artikels
function e_r_MwSt(AUSGABEART_R, ARTIKEL_R: integer): double; overload;

// MwSt: liefert die MwSt wie in diesem Sortiment üblich
function e_r_MwSt(SORTIMENT_R: integer): double; overload;

// MwSt: liefert den Prozentwert eines Steuersatzes
function e_r_Prozent(Satz: integer; mDatum: TAnfixDate = cIllegalDate): double; Overload;
function e_r_Prozent(Satz: string; mDatum: TAnfixDate = cIllegalDate): double; Overload;

// MwSt: liefert die Satznummer (1,2, ...) anhand eines gegebenen Prozentwertes
function e_r_Satz(Prozent: double; mDatum: TAnfixDate): integer;

// Gewicht eines Artikels
function e_r_Gewicht(AUSGABEART_R, ARTIKEL_R: integer): integer;

// Mindestbestellmenge des Artikels
function e_r_MindestBestellmenge(AUSGABEART_R, ARTIKEL_R: integer): integer;
function e_r_Artikel(AUSGABEART_R, ARTIKEL_R: integer): string;
function e_r_ArtikelDokument(AUSGABEART_R, ARTIKEL_R, MEDIUM_R: integer): integer;
function e_r_ArtikelBild(AUSGABEART_R, ARTIKEL_R: integer; DoFileCheck: boolean = true): string;
function e_r_ArtikelVorschaubild(AUSGABEART_R, ARTIKEL_R: integer; DoFileCheck: boolean = true): string;
function e_r_ArtikelMusik(AUSGABEART_R, ARTIKEL_R: integer): string;
function e_r_ArtikelKontext(AUSGABEART_R, ARTIKEL_R: integer): string;

// gibts infos über den Versendetag aus, es werden spezielle Status Codes
// verwendet. Siehe Doku.
function e_r_ArtikelVersendetag(AUSGABEART_R, ARTIKEL_R: integer): integer;

// [Tage]
// gibts infos über den Versendetag aus, es werden spezielle Status Codes
// verwendet. Siehe Doku.
function e_r_Lieferzeit(AUSGABEART_R, ARTIKEL_R: integer): integer;

// legt einen Artikel im angegebenen Sortiment an
// liefert den neuen RID zurück!
function e_w_ArtikelNeu(SORTIMENT_R: integer): integer; { : RID }

{ : Musste angelegt werden }
// legt die Kombination Einheit.Ausgabeart.Artikel eines Artikels an, falls dieser
// noch nicht existiert.
function e_w_Artikel(EINHEIT_R, AUSGABEART_R, ARTIKEL_R: integer): boolean;

// bucht eine Lagermenge ab oder zu
// liefert die neue Lagermenge
function e_w_Menge(EINHEIT_R, AUSGABEART_R, ARTIKEL_R, MENGE: integer; BELEG_R: integer = 0; POSTEN_R: integer = 0)
  : integer; { MENGE }

function e_w_GTIN(AUSGABEART_R, ARTIKEL_R: integer) : int64;

// kleinere Tools für Artikel Selektion
function e_r_sqlArtikelWhere(AUSGABEART_R, ARTIKEL_R: integer; TableName: string = ''): string;

// Für Belege
function e_r_ArtikelInfo(ARTIKEL_R: integer; Prefix: string = ''): TStringList;

// Standard-Sortierung von ARTIKEL_Rs
procedure e_r_ArtikelSortieren(const RIDS: TList);

// berechnet den URL für einen Artikel
function e_r_ArtikelLink(ARTIKEL_R: integer): string;

// liefert den Namen dieser Ausgabeart
function e_r_Ausgabeart(AUSGABEART_R: integer): string;
function e_r_AusgabeartKurz(AUSGABEART_R: integer): string;

// Ermittelt den Lieferanten zu diesem Artikel
function e_r_Lieferant(ARTIKEL_R, MENGE: integer): integer; { PERSON_R }

{ MENGE }
// liefert die Lagermenge dieses Artikels in der angegebenen
// Ausprägungsart
function e_r_Menge(EINHEIT_R, AUSGABEART_R, ARTIKEL_R: integer): integer;

// Caching
procedure e_r_Preis_ensureCache;
procedure e_r_PreisTabelle_ensureCache;
procedure e_r_SortimentSatz_EnsureCache;
procedure e_r_PreisNativ_ensureCache;

// Liest den Preiswert aus der Tabelle aus
function e_r_PreisTabelle(PREIS_R: integer): double;

// liefert den Preis des Artikels
// Satz ist der Mwst-Satz
// Netto liefert Info, ob dieser Preis ein Netto oder Brutto-Preis ist
function e_r_Preis(EINHEIT_R, AUSGABEART_R, ARTIKEL_R: integer; var Satz: double; var Netto: boolean;
  var NettoWieBrutto: boolean): double;

// liefert den Preis des Artikels, fertig als String
// - es kann auch "auf Anfrage" geben
function e_r_PreisText(AUSGABEART_R, ARTIKEL_R: integer): string;

// liefert den Preis des Artikels
function e_r_PreisBrutto(AUSGABEART_R, ARTIKEL_R: integer): double;

// liefert die Preisangabe für diesen Artikel
// unabhängig von netto/brutto Problematik so wie er in der
// Datenbank steht.
function e_r_PreisNativ(AUSGABEART_R, ARTIKEL_R: integer): double;

// liefert den Preis des Artikels
function e_r_EndPreis(PERSON_R, AUSGABEART_R, ARTIKEL_R: integer): double;

// liefert den United States Dollar Preis aus der Preistabelle
function e_r_USD(ARTIKEL_R: integer): double;

// liefert den Preis des Artikels
function e_r_PreisNetto(AUSGABEART_R, ARTIKEL_R: integer): double;

// liefert den Preis des Artikels
function e_r_PaketPreis(AUSGABEART_R, ARTIKEL_R: integer): double;

// Menge rausbelichten
function e_r_MengenAusgabe(MENGE, EINHEIT_R: integer; FormatStr: string = '%d'): string;

// Einzelpreis rausbelichten
function e_r_EinzelPreisAusgabe(PREIS: double; EINHEIT_R: integer): string;

///////////////
// L A G E R //
///////////////

// Lagerplatz vorschlagen
function e_r_LagerVorschlag(EINHEIT_R, AUSGABEART_R, ARTIKEL_R : Integer): Integer; // [LAGER_R]

// Lagerplatz eintragen
function e_w_EinLagern(EINHEIT_R, AUSGABEART_R, ARTIKEL_R: integer): integer; // [LAGER_R]

// Ist ein Lager aktiv?
function e_r_LagerVorhanden(SORTIMENT_R: integer): boolean;

// Die Verlag-RID der speziellen PERSON "Freies Lager"
function e_r_FreiesLager_VERLAG_R: integer;

// Names eines Lagerplatzes anhand des LAGER_R
function e_r_LagerPlatzNameFromLAGER_R(LAGER_R: integer): string;

// gibt Lagerplätze frei, bei denen 14 Tage keine Bewegung mehr ist und Menge=0
procedure e_w_LagerFreigeben;

// Liefert den Lager-Platz des Artikels
function e_r_Lager(EINHEIT_R, AUSGABEART_R, ARTIKEL_R: integer): integer;

// liefert die Mindest-Menge, die auf Lager sein sollte
function e_r_MindestMenge(AUSGABEART_R, ARTIKEL_R: integer): integer;

// dem Agenten signalisieren, dass ein um MENGE erhöhter Bestell-Bedarf besteht
procedure e_w_MehrBedarfsAnzeige(AUSGABEART_R, ARTIKEL_R, POSTEN_R, MENGE: integer; Motivation: integer);

// dem Agenten signalisieren, dass sich der Bestell-Bedarf um MENGE vermindert hat! (er nun nicht mehr besteht!)
procedure e_w_MinderBedarfsAnzeige(AUSGABEART_R, ARTIKEL_R, POSTEN_R, MENGE: integer);

// schreibt Soll- Lagerbewegungen nach WE.csv
function e_r_Bewegungen(PERSON_R: Integer = cRID_unset): boolean;

// Order-Posten-Anz
// Reihenfolge der Befriedigung von Erwarteten Mengen voreinstellen
function e_w_SetFolge(AUSGABEART_R, ARTIKEL_R: integer): integer;

// Waren im System verteilen
function e_w_Wareneingang(AUSGABEART_R, ARTIKEL_R, MENGE: integer): integer; // [ZUSAMMENHANG]

// Ware als vergriffen verbuchen
function e_w_Vergriffen(AUSGABEART_R, ARTIKEL_R: Integer): integer; // [ZUSAMMENHANG]

// Funktion die einen Artikel einer gewissen Dimension in einen Lagerplatz
// stapelt oder entnimmt. Dabei vermindert/vergrössert sich die Lagerplatzgrösse,
// je nach Vorzeichen der MENGE:
//
// + Einlagern
// - Entnahme
function Lagern(
 MENGE: integer;
 PLATZIERUNG : eLagerPlatzierungen;
 ARTIKEL, LAGER : TgpIntegerList;
 AutoSize : boolean = false) : boolean;

///////////////////////////////////
// Ü B E R G A N G S F Ä C H E R //
///////////////////////////////////

// Ist LAGER_R ein Übergangsfach
function e_r_IsUebergangsfach(LAGER_R: integer): boolean;

// Die Verlag-RID der speziellen PERSON "Übergangsfach"
function e_r_Uebergangsfach_VERLAG_R: integer; // [VERLAG_R]

// Alle freien Übergangsfächer sortiert
function e_r_Uebergangsfaecher_oeffentlich: TgpIntegerList; // [array of LAGER_R] Do not .Free

// Alle reservierten Übergangsfächer sortiert
function e_r_Uebergangsfaecher_reserviert: TgpIntegerList; // [array of LAGER_R] Do not .Free

// [LAGER_R in Übergangsfach]
// Übergangsfach ermitteln
function e_r_UebergangsfachFromPerson(PERSON_R: integer): integer;

// LAGER_R in den Beleg eintragen!
procedure e_w_Zwischenlagern(BELEG_R: integer; LAGER_R: integer);


procedure e_w_InvalidateLagerCaches;

////////////////////////
// Lager_i-Funktionen //
////////////////////////

//
// Ein Artikel wird im Lager in einer Gewissen Orientierung
// abgelegt. Dabei ergibt sich eine Stellfläche die mit
// iX und iZ angegeben wird. Der Artikel hat dabei die
// Höhe iY.
//
// iFill gibt wiederum an in welcher Dimension der Lagerzuwachs
// für jede weitere Plazierung erfolgt. z.B. iFill="0" bedeutet "X"
// bedeutet der Lagerplatz wird von links nach rechts
// horizontal befüllt. Wie bei einem Bücherregal.
//
// Grundsätzlich gibt es bei der Platzierung 6 Möglichkeiten
// die Werte beschreiben die die Seitenbezeichnungen des Artikels
// in der Reihenfolge (X,Y,Z) des Lagers
//
// (X,Y,Z) "nativ"
// (X,Z,Y)
// (Y,X,Z)
// (Y,Z,X)
// (Z,X,Y)
// (Z,Y,X)
//
// im OrgaMon-Wiki "Lager" gibt es hier mehr Infos
//

// Index für Artikel-Stellfläche "X"-Dimension
function Lager_iX(PLATZIERUNG : eLagerPlatzierungen):Byte; // ARTIKEL_XYZ[.]

// Index für Artikel-Höhe "Y"-Dimension
function Lager_iY(PLATZIERUNG : eLagerPlatzierungen):Byte; // ARTIKEL_XYZ[.]

// Index für Artikel-Stellfläche "Z"-Dimension
function Lager_iZ(PLATZIERUNG : eLagerPlatzierungen):Byte; // ARTIKEL_XYZ[.]

// Aus LAGER Sichtweise: Index für Wachstums-Dimension
function Lager_iFill(PLATZIERUNG : eLagerPlatzierungen):Byte;

// Aus ARTIKEL Sichtweise: Index für Wachstums-Dimension
function Artikel_iFill(PLATZIERUNG : eLagerPlatzierungen):Byte;

// Liefert die Anzahl verschiedener Artikel auf einem Lagerplatz
function e_r_LagerDiversitaet(LAGER_R: integer): integer; // [MENGE]

// Liefert den Raum eines Lagers unabhängig von dessen Belegung
function e_r_LagerVolumen(LAGER_R: Integer): int64; // [x*y*z³]

// Liefert die grundsätzliche Grösse und Platzierung eines Lagers unabhängig von dessen Belegung
function e_r_LagerDimensionen(LAGER_R: Integer): TgpIntegerList; // [X,Y,Z,PLATZIERUNG]

// verbleibende Dimension errechnen
// [0] = verbleibendes X
// [1] = verbleibendes Y
// [2] = verbleibendes Z
// [3] = eingelagerte Menge
// [4] = FREI=-1,0..100%
//       -1 = Fehler
function e_r_LagerFreiraum(LAGER_R: integer): TgpIntegerList; // [X,Y,Z,LAGERNDE_MENGE,FREI%]

// Artikel in der Form { X,Y,Z,MENGE,X,Y,Z,MENGE ... }
// Es wird geprüft, ob diese in ein Lager passen
function e_r_LagerPasst(LAGER_R: Integer; ARTIKEL:TgpIntegerList):boolean;

// Lagerbedarf eines Artikels berechnen, anhand einer gegebenen Menge
function e_r_ArtikelDimensionen(
  { } EINHEIT_R, AUSGABEART_R, ARTIKEL_R : Integer;
  { } MENGE: Integer = 1): TgpIntegerList; // [X,Y,Z,MENGE]

implementation

uses
{$IFNDEF fpc}
   IB_Components,
{$ENDIF}
 Math,
 SysUtils,
 // Blowfish
 DCPcrypt2, DCPblockciphers, DCPblowfish, DCPbase64,
 html,
 Geld,
 WordIndex,
 CareTakerClient,
 Funktionen_Basis,
 Funktionen_Beleg,
 Funktionen_Auftrag,
 Funktionen_Buch;


const
  _e_r_Uebergangsfach: integer = cRID_unset;

function e_r_Uebergangsfach_VERLAG_R: integer;
begin
  if (_e_r_Uebergangsfach = cRID_unset) then
    _e_r_Uebergangsfach := e_r_VERLAG_R_fromVerlag(cVerlagUebergangsfach);
  result := _e_r_Uebergangsfach;
end;

const
 _e_r_Uebergangsfaecher_reserviert: TgpIntegerList = nil;

function e_r_Uebergangsfaecher_reserviert: TgpIntegerList;
var
 sql : TStringList;
begin
 if not(assigned(_e_r_Uebergangsfaecher_reserviert)) then
 begin
   _e_r_Uebergangsfaecher_reserviert := e_r_sqlm(
    {} 'select distinct LAGER_R from PERSON '+
    {} 'where'+
    {} ' (LAGER_R is not null)');
 end;
 result := _e_r_Uebergangsfaecher_reserviert;
end;

const
 _e_r_Uebergangsfaecher_oeffentlich: TgpIntegerList = nil;

function e_r_Uebergangsfaecher_oeffentlich: TgpIntegerList;
var
 sql : TStringList;
 n,i : Integer;
begin
  if not(assigned(_e_r_Uebergangsfaecher_oeffentlich)) then
  begin
   sql := TStringList.Create;
   with sql do
   begin
     add('select RID');
     add('from LAGER');
     add('where');
     add(' (VERLAG_R='+IntToStr(e_r_Uebergangsfach_VERLAG_R)+')');
     if (iLagerPraemisse=LagerPraemisse_Heimweg) then
      add('order by NAME');
     if (iLagerPraemisse=LagerPraemisse_GastWeg) then
      add('order by NAME descending');
   end;
   _e_r_Uebergangsfaecher_oeffentlich := e_r_sqlm(sql);
   sql.Free;

   // reduzieren um die Reservierten
   for n := 0 to pred(e_r_Uebergangsfaecher_reserviert.Count) do
   begin
     i := _e_r_Uebergangsfaecher_oeffentlich.IndexOf(e_r_Uebergangsfaecher_reserviert[n]);
     if (i<>-1) then
      _e_r_Uebergangsfaecher_oeffentlich.Delete(i);
   end;

  end;
  result := _e_r_Uebergangsfaecher_oeffentlich;
end;

function e_r_IsUebergangsfach(LAGER_R: integer): boolean;
begin
  if (e_r_Uebergangsfach_VERLAG_R >= cRID_FirstValid) then
    result :=
     {} (e_r_Uebergangsfaecher_oeffentlich.IndexOf(LAGER_R)<>-1) or
     {} (e_r_Uebergangsfaecher_reserviert.IndexOf(LAGER_R)<>-1)
  else
    result := false;
end;

const
  _e_r_FreiesLager: integer = cRID_unset;

function e_r_FreiesLager_VERLAG_R: integer;
begin
  if (_e_r_FreiesLager = cRID_unset) then
    _e_r_FreiesLager := e_r_VERLAG_R_fromVerlag(cVerlagFreiesLager);
  result := _e_r_FreiesLager;
end;

procedure e_w_InvalidateLagerCaches;
begin
  // Caches ungültig machen!
  _e_r_Uebergangsfach := cRID_unset;
  _e_r_FreiesLager := cRID_unset;
  if assigned(_e_r_Uebergangsfaecher_oeffentlich) then
   FreeAndNil(_e_r_Uebergangsfaecher_oeffentlich);
  if assigned(_e_r_Uebergangsfaecher_reserviert) then
   FreeAndNil(_e_r_Uebergangsfaecher_reserviert);
end;

function e_r_LagerPlatzNameFromLAGER_R(LAGER_R: integer): string;
begin
 if (LAGER_R>=cRID_FirstValid) then
  result := e_r_sqls('select NAME from LAGER where RID=' + inttostr(LAGER_R))
 else
  result := '';
end;

function e_r_UebergangsfachFromPerson(PERSON_R: integer): integer; // [LAGER_R]

  function sucheFach(LAGER, ARTIKEL: TgpIntegerList): Integer; // [LAGER_R]
  var
   UebergangsfachSelected: integer;
   TriedCount: integer;
   LAGER_R: integer;
  begin
    result := cRID_NULL;
    if (LAGER.Count>0) then
    begin

      // Startpunkt für Suche nach leerem Übergangsfach setzen
      repeat
        if (iLagerPraemisse=LagerPraemisse_Fluten) then
        begin
          UebergangsfachSelected := e_w_GEN('UEBERGANGSFACH_GID') mod LAGER.Count;
          break;
        end;
        if (iLagerPraemisse=LagerPraemisse_Zufall) then
        begin
          UebergangsfachSelected := random(LAGER.Count);
          break;
        end;
        UebergangsfachSelected := 0;
      until yet;

      // leeres Fach suchen
      TriedCount := 0;
      repeat
         // overrun?
         if (UebergangsfachSelected=LAGER.Count) then
          UebergangsfachSelected := 0;

         // test LAGER_R!
         LAGER_R := LAGER[UebergangsfachSelected];
         inc(TriedCount);
         if (TriedCount>LAGER.Count) then
          break;
         if (e_r_sql(
          {} 'select count(RID) from BELEG where LAGER_R=' +
          {} IntToStr(LAGER_R) ) = 0) then
          begin
            // Im Fach liegt kein Beleg - aber passt es auch?
            if e_r_LagerPasst(LAGER_R, ARTIKEL) then
            begin
              result := LAGER_R;
              break;
            end;
          end;
          inc(UebergangsfachSelected);
      until eternity;
    end;
  end;

var
  n : Integer;
  BELEGE: TgpIntegerList;
  A,ARTIKEL: TgpIntegerList;

begin
  result := cRID_NULL;
  repeat

    // hat der Kunde ein persönliches Übergangsfach?
    result := e_r_sql('select LAGER_R from PERSON where RID='+IntToStr(PERSON_R));
    if (result>=cRID_FirstValid) then
     break;

    // ohne aktivierte Übergangsfach-Logik sind weitere Schritte sinnlos
    if (e_r_Uebergangsfach_VERLAG_R<cRID_FirstValid) then
     break;

    // welche Belege kommen in Frage (versandfähige)
    BELEGE := e_r_sqlm(
     {} 'select RID from BELEG where' +
     {} ' (MENGE_RECHNUNG>0) and'+
     {} ' ((LIEFERANSCHRIFT_R='+IntToStr(PERSON_R)+') or'+
     {} '  ((PERSON_R='+IntToStr(PERSON_R)+') and (LIEFERANSCHRIFT_R is null))'+
     {} ' )');

    // Alle Artikel-Dimensionen sammeln
    ARTIKEL := TgpIntegerList.Create;
    for n := 0 to pred(BELEGE.Count) do
    begin
      A := e_r_BelegDimensionen(BELEGE[n]);
      ARTIKEL.append(A);
      A.Free;
    end;

    // hat der Kunde schon ein Übergangsfach in Belegung?
    result := e_r_sql(
      {} 'select LAGER_R '+
      {} 'from BELEG '+
      {} 'where'+
      {} ' not(LAGER_R is null) and'+
      {} ' ((LIEFERANSCHRIFT_R=' + inttostr(PERSON_R) + ') or'+
      {} '  ((PERSON_R=' + inttostr(PERSON_R) + ') and (LIEFERANSCHRIFT_R is null))'+
      {} ' )');

    // würde das auch passen?
    if (result >= cRID_FirstValid) then
      if e_r_LagerPasst(result, ARTIKEL) then
        break;

    // vorrangig oeffentlich suchen
    result := sucheFach(e_r_Uebergangsfaecher_oeffentlich, ARTIKEL);
    if (result >= cRID_FirstValid) then
     break;

    // zur Not auch in reservierten suchen
    result := sucheFach(e_r_Uebergangsfaecher_reserviert, ARTIKEL);

  until yet;
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
      sql.add('select');
      sql.add(' OUT_PERSON_R');
      sql.add('from');
      sql.add(' BREGEL');
      sql.add('where');
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

  until yet;

end;

procedure e_w_MinderBedarfsAnzeige(AUSGABEART_R, ARTIKEL_R, POSTEN_R, MENGE: integer);
begin
end;

procedure e_w_MehrBedarfsAnzeige(AUSGABEART_R, ARTIKEL_R, POSTEN_R, MENGE: integer; Motivation: integer);

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
              FieldByName('MENGE_UNBESTELLT').AsInteger := FieldByName('MENGE_UNBESTELLT').AsInteger + MENGE;

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

function e_r_LagerVorhanden(SORTIMENT_R: integer): boolean;
begin
  result := (e_r_Uebergangsfach_VERLAG_R <> cRID_Null);
end;

function e_r_LagerDiversitaet(LAGER_R: integer): integer; // [ANZAHL]
begin
  result := e_r_sql('select count(RID) from ARTIKEL where LAGER_R=' + inttostr(LAGER_R));
end;

function e_r_LagerVolumen(LAGER_R: Integer): int64; // [x*y*z³]
begin
  result := e_r_sql('select X*Y*Z from LAGER where RID='+IntToStr(LAGER_R));
end;

function e_r_LagerDimensionen(LAGER_R: Integer): TgpIntegerList; // X,Y,Z,PLATZIERUNG

 procedure Error(s:string);
 begin
   AppendStringsToFile(IntToStr(LAGER_R) + ';' + S, ErrorFName('LAGER'));
 end;

var
 LAGER: TdboCursor;
 LAGERNAME: string;
begin
 result := TgpIntegerList.Create;
 result.Add(0);
 result.Add(0);
 result.Add(0);
 result.Add(0);
 if (LAGER_R>=cRID_FirstValid) then
 begin
   LAGER := nCursor;
   with LAGER do
   begin
    sql.add('select X,Y,Z,PLATZIERUNG,NAME from LAGER where RID='+IntToStr(LAGER_R));
    ApiFirst;
    if not(eof) then
    begin
      result[0] := FieldByName('X').AsInteger;
      result[1] := FieldByName('Y').AsInteger;
      result[2] := FieldByName('Z').AsInteger;
      result[3] := FieldByName('PLATZIERUNG').AsInteger;
      LAGERNAME := FieldByName('NAME').AsString;

      if DebugMode then
      begin
        error('e_r_LagerDimensionen('+LAGERNAME+')');
        error(' X,Y,Z='+IntToStr(result[0])+','+IntToStr(result[1])+','+IntToStr(result[2]));
        error(' PLATZIERUNG='+cLagerPlazierungen[eLagerPlatzierungen(result[3])]);
      end;

      if (result[0]<1) or (result[1]<1) or (result[2]<1) then
       Error(LAGERNAME + ': X|Y|Z=0');
    end else
    begin
      Error('e_r_LagerDimensionen('+IntToStr(LAGER_R)+')');
      Error(' nicht gefunden');
    end;
   end;
   LAGER.Free;
 end;
end;

function e_r_LagerPasst(LAGER_R: Integer;ARTIKEL:TgpIntegerList):boolean;

 procedure Error(s:string; Info: boolean = false);
 begin
   AppendStringsToFile(IntToStr(LAGER_R)+';'+S,ErrorFName('LAGER',Info));
 end;

const
 ARTIKEL_SingleSize = 4;
var
 XYZP,A : TgpIntegerList;
 PLATZIERUNG : eLagerPlatzierungen;
 n : Integer;
 FatalError : boolean;
begin
  FatalError := false;
  if DebugMode then
  begin
   error('e_r_LagerPasst('+IntToStr(LAGER_R)+')',true);
   error(' '+ARTIKEL.AsDelimitedText(','),true);
  end;
  XYZP := e_r_LagerDimensionen(LAGER_R);
  PLATZIERUNG := eLagerPlatzierungen(XYZP[3]);
  for n := 0 to pred(ARTIKEL.Count div ARTIKEL_SingleSize) do
  begin
   A := TgpIntegerList.Create;
   A.add(ARTIKEL[n*ARTIKEL_SingleSize+cLiX]);
   A.add(ARTIKEL[n*ARTIKEL_SingleSize+cLiY]);
   A.add(ARTIKEL[n*ARTIKEL_SingleSize+cLiZ]);
   if Lagern(
    -ARTIKEL[n*ARTIKEL_SingleSize+cLiZ+1],
    PLATZIERUNG,
    A, XYZP ) then
    begin
     if DebugMode then
       Error(IntToStr(A[0])+','+IntToStr(A[1])+','+IntTostr(A[2])+' passt',true);
    end else
    begin
     if DebugMode then
      Error(IntToStr(A[0])+','+IntToStr(A[1])+','+IntTostr(A[2])+' unpassend',true);
     FatalError := true;
    end;
    FreeAndNil(A);
    if FatalError then
     break;
  end;
  FreeAndNil(XYZP);
  result := not(FatalError);
end;

function e_r_LagerFreiraum(LAGER_R: integer) : TgpIntegerList; // [X,Y,Z,LAGERNDE_MENGE,FREI%]

var
  FatalError: boolean;

 procedure Error(s:string; Panic: boolean=false);
 begin
   AppendStringsToFile(IntToStr(LAGER_R)+';'+S,ErrorFName('LAGER'));
   if Panic then
    FatalError := true;
 end;

var
 i : Integer;
 LAGER, POSTEN, ARTIKEL, ARTIKEL_AA : TdboCursor;
 A : TgpIntegerList;

 // Lager-Infos
 VERLAG_R, BELEG_R : Integer;
 BELEGE : TgpIntegerList;
 XYZ : TgpIntegerList;
 X,Y,Z : integer;

 // Füllstandberechnung
 F,F_ : Integer;
 dF,dF_ : double;
 PERCENT : Integer;

 // Lager-Infos
 LAGERNAME: string;
 PLATZIERUNG: eLagerPlatzierungen;
 MENGE, GESAMT_MENGE: Integer;
 ARTIKEL_R, AUSGABEART_R, EINHEIT_R : integer;

begin
 result := TgpIntegerList.create;
 {X} result.Add(0);
 {Y} result.Add(0);
 {Z} result.Add(0);
 {LAGERNDE_MENGE} result.Add(0);
 {FREI%} result.Add(-1); // return Error Condition

 GESAMT_MENGE := 0;
 XYZ := nil;
 FatalError := false;

 repeat

   LAGER := nCursor;
   with LAGER do
   begin
    sql.add('select VERLAG_R,X,Y,Z,NAME,PLATZIERUNG from LAGER where RID='+IntToStr(LAGER_R));
    ApiFirst;
    if eof then
     error('LAGER_R '+IntToStr(LAGER_R)+' nicht gefunden',true);
    result[cLiX] := FieldByName('X').AsInteger;
    result[cLiY] := FieldByName('Y').AsInteger;
    result[cLiZ] := FieldByName('Z').AsInteger;
    VERLAG_R := FieldByName('VERLAG_R').AsInteger;
    LAGERNAME := FieldByName('NAME').AsString;
    PLATZIERUNG := eLagerPlatzierungen(FieldByName('PLATZIERUNG').AsInteger);
    if DebugMode then
     error('e_r_LagerFreiraum('+LAGERNAME+')');
    F := result[Lager_iFill(PLATZIERUNG)];
    dF := F;
    if (result[cLiX]<1) or (result[cLiY]<1) or (result[cLiZ]<1) then
     Error(LAGERNAME + ': X|Y|Z=0',true);
   end;
   LAGER.Free;
   if FatalError then
    break;

   // a) Belege, die im Übergangsfach liegen
   if (VERLAG_R=e_r_Uebergangsfach_VERLAG_R) then
   begin
     BELEGE := e_r_sqlm('select RID from BELEG where LAGER_R='+IntToStr(LAGER_R));

     // BELEGE iterieren
     for i := 0 to pred(BELEGE.Count) do
     begin
       BELEG_R := BELEGE[i];
       if DebugMode then
        error('BELEG_R='+IntToStr(BELEG_R));

       POSTEN := nCursor;
       with POSTEN do
       begin
        sql.Add(
         { } 'select RID,MENGE_RECHNUNG, EINHEIT_R, ARTIKEL_R, AUSGABEART_R, ARTIKEL '+
         { } 'from POSTEN where '+
         { } ' (BELEG_R='+IntTostr(BELEG_R)+') and '+
         { } ' ((ZUTAT is null) or (ZUTAT='+cC_False_AsString+')) and '+
         { } ' (MENGE_RECHNUNG>0)');
         ApiFirst;
         while not(eof) do
         begin

           MENGE := FieldByName('MENGE_RECHNUNG').AsInteger;
           inc(GESAMT_MENGE, MENGE);
           EINHEIT_R := FieldByName('EINHEIT_R').AsInteger;
           AUSGABEART_R := FieldByName('AUSGABEART_R').AsInteger;
           ARTIKEL_R := FieldByName('ARTIKEL_R').AsInteger;

           if DebugMode then
            Error(
             {} 'POSTEN_R='+FieldByName('RID').AsString+';'+
             {} 'EINHEIT_R='+IntToStr(EINHEIT_R)+';'+
             {} 'AUSGABEART_R='+IntToStr(AUSGABEART_R)+';'+
             {} 'ARTIKEL_R='+IntToStr(ARTIKEL_R));

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
                 if not(FatalError) then
                 begin
                   XYZ := TgpIntegerList.Create;
                   XYZ.add(X);
                   XYZ.add(Y);
                   XYZ.add(Z);
                   if not(Lagern(-MENGE, PLATZIERUNG, XYZ, result)) then
                    FatalError := true;
                 end;
               end;
               ARTIKEL_AA.Free;
               break;
             end;

             // lade aus dem Artikel
             if (ARTIKEL_R>=cRID_FirstValid) then
             begin

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
                 if not(FatalError) then
                 begin
                   XYZ := TgpIntegerList.Create;
                   XYZ.add(X);
                   XYZ.add(Y);
                   XYZ.add(Z);
                   if not(Lagern(-MENGE, PLATZIERUNG, XYZ,result)) then
                    FatalError := true;
                   FreeAndNil(XYZ);
                 end;
               end;
               ARTIKEL.Free;
              end else
              begin
                Error('für ARTIKEL "'+POSTEN.FieldByName('ARTIKEL').AsString+'" kann kein Maß berechnet werden');
              end;
           until yet;
           ApiNext;
         end;
       end;
       POSTEN.Free;
     end;
     BELEGE.Free;
   end;
   if FatalError then
     break;

   // b) eingelagerte ARTIKEL
   ARTIKEL := nCursor;
   with ARTIKEL do
   begin
     sql.add('select RID,X,Y,Z,MENGE from ARTIKEL where LAGER_R='+IntToStr(LAGER_R));
     ApiFirst;
     while not(eof) do
     begin
       if DebugMode then
        Error('ARTIKEL_R='+FieldByName('RID').AsString);

       A := TgpIntegerList.Create;
       A.Add(FieldByName('X').AsInteger);
       A.Add(FieldByName('Y').AsInteger);
       A.Add(FieldByName('Z').AsInteger);
       MENGE := FieldByName('MENGE').AsInteger;
       inc(GESAMT_MENGE,MENGE);

       if not(Lagern(-MENGE, PLATZIERUNG, A, result)) then
       begin
        Error('... bei ARTIKEL '+FieldByName('RID').AsString, true);
        break;
       end;

       FreeAndNil(A);
       ApiNext;
     end;
   end;
   ARTIKEL.free;

   // c) ARTIKEL_AA
   ARTIKEL_AA := nCursor;
   with ARTIKEL_AA do
   begin
    sql.add('select RID,X,Y,Z,MENGE,ARTIKEL_R,AUSGABEART_R from ARTIKEL_AA where LAGER_R='+IntToStr(LAGER_R));
    ApiFirst;
    while not(eof) do
    begin

       A := TgpIntegerList.Create;
       A.Add(FieldByName('X').AsInteger);
       A.Add(FieldByName('Y').AsInteger);
       A.Add(FieldByName('Z').AsInteger);
       MENGE := FieldByName('MENGE').AsInteger;
       inc(GESAMT_MENGE,MENGE);

       if DebugMode then
        Error(
         {} 'ARTIKEL_AA='+FieldByName('RID').AsString+';'+
         {} 'AUSGABEART_R='+IntToStr(AUSGABEART_R)+';'+
         {} 'ARTIKEL_R='+IntToStr(ARTIKEL_R)+';'
         );

       if not(Lagern(-MENGE,PLATZIERUNG, A,result)) then
       begin
        Error(FieldByName('RID').AsString+';'+'Das Lager ist bereits überfüllt',true);
        break;
       end;

      FreeAndNil(A);
      ApiNext;
    end;
   end;
   ARTIKEL_AA.Free;

 until yet;

 result[3] := GESAMT_MENGE;

 // die nun erreichte Höhe
 F_ := result[Lager_iFill(PLATZIERUNG)];
 dF_ := F_;

 // Berechnen wie hoch y steht
 if (F=F_) then
 begin
   // es ist keine Fülländerung feststellbar
   if (GESAMT_MENGE>0) then
    PERCENT := 0
   else
    PERCENT := 100;
 end else
 begin
   if (dF<=0) then
    PERCENT := 0
   else
    PERCENT := round((dF_ / dF) * 100.0);
 end;

 // die verbleibende Resthöhe zurückgeben
 if not(FatalError) then
  result[4] := PERCENT; // was noch frei ist

 if DebugMode then
 begin
  if (GESAMT_MENGE=1) then
   Error(LAGERNAME + ' ist mit einem Artikel zu ' + IntToStr(PERCENT) + '% frei')
  else
   Error(LAGERNAME + ' ist mit ' + IntToStr(GESAMT_MENGE) + ' Artikeln zu ' + INtTOstr(PERCENT) + '% frei');
 end;

end;

function e_r_LagerVorschlag(EINHEIT_R, AUSGABEART_R, ARTIKEL_R : Integer): Integer;
var
  FatalError: boolean;

 procedure Error(s:string; Panic: boolean=false);
 begin
   AppendStringsToFile(S,ErrorFName('LAGER'));
   if Panic then
    FatalError := true;
 end;

var
  SORTIMENT_R: Integer;
  VERLAG_R: integer;
  LAGER_R: Integer;
  X,Y,Z : Integer;
  MENGE: Integer;
  LAGER_PLAETZE: Integer;

  // Entscheidungshilfen
  DecideStrL: TStringList;

  //
  cARTIKEL: TdboCursor;

  // default
  procedure viaDiversitaet;
  var
    cLAGER: TdboCursor;
    FREI: integer;
    XYZ: TgpIntegerList;
    DecideStr: string;
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
      case iLagerPraemisse of
       LagerPraemisse_Heimweg:sql.add('order by NAME');
       LagerPraemisse_GastWeg:sql.add('order by NAME descending');
      else
       sql.add('order by NAME');
      end;
      ApiFirst;
      while not(eof) do
      begin

        // SORTIMENT+MINUS+PUNKTE.LAGER.NAME

        // "FREI" im Sinne von Übriger Diversität (klein=gut)
        FREI := FieldByName('DIVERSITAET').AsInteger - FieldByName('BELEGUNG').AsInteger;

        // Ist überhaupt noch Platz?
        if (FREI > 0) then
        begin

          // Stimmt das Sortiment überein?
          if (FieldByName('SORTIMENT_R').AsInteger = SORTIMENT_R) then
            DecideStr := 'A' // gut
          else
            DecideStr := 'B'; // schlechter

          repeat

           if (iLagerPraemisse=LagerPraemisse_Fluten) then
           begin
            DecideStr := DecideStr + '+' + inttostrN(FREI, 4);
            break;
           end;

           DecideStr := DecideStr + '+' + inttostrN(FieldByName('BELEGUNG').AsInteger, 4);
          until yet;

          // Der NAME sollte von links nach rechts verlaufen
          DecideStr := DecideStr + '+' + FieldByName('NAME').AsString;

          DecideStrL.AddObject(DecideStr, TObject(FieldByName('RID').AsInteger));

        end;
        ApiNext;
        XYZ.Free;
      end;
    end;
    cLAGER.free;
  end;

  procedure viaStapel;
  var
    cLAGER: TdboCursor;
    XYZ,LAGER : TgpIntegerList;
    DecideStr: string;
    SORTIMENT_R: Integer;
    PLATZIERUNG: eLagerPlatzierungen;
  begin
    //
    DecideStrL.clear;
    XYZ := e_r_ArtikelDimensionen(EINHEIT_R, AUSGABEART_R, ARTIKEL_R, MENGE);

    cLAGER := nCursor;
    with cLAGER do
    begin
      sql.add('select');
      sql.add(' RID,');
      sql.Add(' SORTIMENT_R,');
      sql.Add(' PLATZIERUNG');
      sql.add('from');
      sql.add(' Lager');
      sql.add('where');
      sql.add(' (VERLAG_R=' + inttostr(VERLAG_R) + ') AND');
      sql.add(' ((SORTIMENT_R=' + inttostr(SORTIMENT_R) + ') OR (SORTIMENT_R IS NULL))');
      case iLagerPraemisse of
       LagerPraemisse_Heimweg:sql.add('order by NAME');
       LagerPraemisse_GastWeg:sql.add('order by NAME descending');
      else
       sql.add('order by NAME');
      end;
      ApiFirst;
      while not(eof) do
      begin
        // "FREI" im Sinne von % des Platzes, die leer sind
        PLATZIERUNG := eLagerPlatzierungen(FieldByName('PLATZIERUNG').AsInteger);
        LAGER := e_r_LagerFreiraum(FieldByName('RID').AsInteger);
        if (LAGER[4]<>-1) then
        begin
         if Lagern(MENGE,PLATZIERUNG,XYZ,LAGER) then
         begin

           // Stimmt das Sortiment überein?
           if (FieldByName('SORTIMENT_R').AsInteger = SORTIMENT_R) then
             DecideStr := 'A' // gut
           else
             DecideStr := 'B'; // schlechter

           // Lagern ist möglich, was ist noch frei?
           if (iLagerPraemisse=LagerPraemisse_Fluten) then
            DecideStr := DecideStr + IntToStrN(99999-LAGER[Lager_iFill(PLATZIERUNG)],5)
           else
            DecideStr := DecideStr + IntToStrN(LAGER[Lager_iFill(PLATZIERUNG)],5);

           DecideStrL.AddObject(DecideStr, TObject(FieldByName('RID').AsInteger));
         end;
        end else
        begin
          Error(' Lagerplatz bleibt unberücksichtigt!');
        end;
        ApiNext;
      end;
    end;
    cLAGER.Free;
  end;

  procedure viaMenge;
  begin
  end;

  procedure viaMasse;
  begin
  end;

  procedure viaVolumen;
  begin
  end;

begin
  result := -1;
  FatalError:= false;
  if DebugMode then
    Error('e_r_LagerVorschlag('+
    {} 'EINHEIT_R='+IntToStr(EINHEIT_R)+', '+
    {} 'AUSGABEART_R='+IntToStr(AUSGABEART_R)+', '+
    {} 'ARTIKEL_R='+IntToStr(ARTIKEL_R)+')');

  // weitere Daten nachladen
  cARTIKEL := nCursor;
  with cARTIKEL do
  begin
    if (AUSGABEART_R>=cRID_FirstValid) then
    begin
      sql.add('select');
      sql.add(' SORTIMENT_R,');
      sql.add(' VERLAG_R,');
      sql.add(' LAGER_R,');
      sql.Add(' X,Y,Z,');
      sql.Add(' MENGE');
      sql.add('from');
      sql.add(' ARTIKEL_AA');
      sql.add('where');
      sql.add(' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') and');
      sql.add(' (AUSGABEART_R' + isRID(AUSGABEART_R) + ') and');
      sql.add(' (EINHEIT_R' + isRID(EINHEIT_R) + ')');
      ApiFirst;
    end else
    begin
      sql.add('select');
      sql.add(' SORTIMENT_R,');
      sql.add(' VERLAG_R,');
      sql.add(' LAGER_R,');
      sql.Add(' X,Y,Z,');
      sql.Add(' MENGE');
      sql.add('from');
      sql.add(' ARTIKEL');
      sql.add('where');
      sql.add(' (RID=' + inttostr(ARTIKEL_R) + ')');
      ApiFirst;
    end;
    SORTIMENT_R:= FieldByName('SORTIMENT_R').AsInteger;
    VERLAG_R := e_r_VERLAG_R_fromVerlag(FieldByName('VERLAG_R').AsInteger);
    LAGER_R:= FieldByName('LAGER_R').AsInteger;
    X := FieldByName('X').AsInteger;
    Y := FieldByName('Y').AsInteger;
    Z := FieldByName('Z').AsInteger;
    MENGE := FieldByName('MENGE').AsInteger;
  end;
  cARTIKEL.free;


  // Grundvoraussetzung: Lagerungsfähigkeit im Sortiment
  if (e_r_sqls('select LAGER from SORTIMENT where RID=' + inttostr(SORTIMENT_R)) = cC_True) then
  begin

    repeat

      // gibt es dezidierte Lagerplätze?
      LAGER_PLAETZE := e_r_sql('select count(RID) from LAGER where VERLAG_R='+IntToStr(VERLAG_R));
      if (LAGER_PLAETZE>0) then
       break;

      // gibt es freies Lager?
      VERLAG_R := e_r_FreiesLager_VERLAG_R;
      LAGER_PLAETZE := e_r_sql('select count(RID) from LAGER where VERLAG_R='+IntToStr(VERLAG_R));
      if (LAGER_PLAETZE>0) then
       break;

      // leider nein!
      VERLAG_R := cRID_unset;

    until yet;

    //
    if (VERLAG_R >= cRID_FirstValid) then
    begin

      //
      DecideStrL := TStringList.create;
      repeat

        case iLagerPrinzip of
         LagerPrinzip_Volumen:viaVolumen;
         LagerPrinzip_Stapel:viaStapel;
         LagerPrinzip_Menge:viaMenge;
         LagerPrinzip_Masse:viaMasse;
         LagerPrinzip_Diversitaet:viaDiversitaet;
        end;

        if (DecideStrL.count > 0) then
        begin
          DecideStrL.sort;
          if DebugMode then
           AppendIntegerStringsToFile(DecideStrL, ErrorFName('LAGER'), Uhr8);
          result := integer(DecideStrL.Objects[0]);
          break;
        end;
        if (VERLAG_R = e_r_FreiesLager_VERLAG_R) then
          break;
        VERLAG_R := e_r_FreiesLager_VERLAG_R;
      until eternity;
      DecideStrL.free;
    end;
  end;
end;

function e_w_EinLagern(EINHEIT_R, AUSGABEART_R, ARTIKEL_R: integer): integer;
var
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
    SORTIMENT_R := FieldByName('SORTIMENT_R').AsInteger;
  end;
  cARTIKEL.free;

  // Lager muss leer sein
  if not(result > 0) then
  begin

    // es muss ein Lagerplatz ermittelt werden
    result := e_r_LagerVorschlag(EINHEIT_R, AUSGABEART_R, ARTIKEL_R);
    if (result > 0) then
    begin

      // die eigentliche Einlagerung machen!
      e_x_sql('update ARTIKEL set LAGER_R=' + inttostr(result) + ' where RID=' + inttostr(ARTIKEL_R));

      // Erfolg verbuchen!
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
        EventText.add('Lagerplatz ' + e_r_sqls('select NAME from LAGER where RID=' + inttostr(result)) + ' zugeteilt!');
        FieldByName('INFO').assign(EventText);
        EventText.free;
        Post;
      end;
      qEREIGNIS.free;
    end;
  end;
end;

function e_r_Lager(EINHEIT_R, AUSGABEART_R, ARTIKEL_R: integer): integer; // [LAGER_R]
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

function e_w_Menge(
 { was } EINHEIT_R, AUSGABEART_R, ARTIKEL_R,
 { wieviel} MENGE: integer;
 { Kontext } BELEG_R: integer = 0; POSTEN_R: integer = 0): integer;
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
              raise exception.create('Bei Entnahme aus Alternativ-Lager muss der Lagerplatz definiert sein!');

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
          if (MENGE<0) then
           AlternativLagerEntnahme := true;
        until yet;

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

            if AlternativLagerEntnahme and (MENGE_BISHER_0 = 0) and (MENGE_BISHER_1 > 0) and (MENGE < 0) then
            begin

              MENGE_NEU := MENGE_BISHER_1 + MENGE;

              // Aus dem Alternativ-Lager entnehmen!
              // Nur Einzelverkäufe möglich
              if (MENGE <> -1) then
                raise exception.create('Entnahmemenge aus Alternativ-Lager kann nur 1 sein!');

              // Lager muss bekannt sein, damit die Markierung gelingt
              LAGER_R := FieldByName('LAGER_ALTERNATIV_R').AsInteger;
              if (LAGER_R < cRID_FirstValid) then
                raise exception.create('Bei Entnahme aus Alternativ-Lager muss der Lagerplatz definiert sein!');

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

                // nur beim Einlagern: LAGER_R zuteilen, wenn benötigt!
                if (MENGE > 0) and (LAGER_R < cRID_FirstValid) and (MENGE_BISHER_0 <= 0) then
                begin
                  LAGER_R := e_w_EinLagern(EINHEIT_R, AUSGABEART_R, ARTIKEL_R);
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

        if (EINHEIT_R >= cRID_FirstValid) then
          FieldByName('EINHEIT_R').AsInteger := EINHEIT_R;
        if (AUSGABEART_R >= cRID_FirstValid) then
          FieldByName('AUSGABEART_R').AsInteger := AUSGABEART_R;
        FieldByName('ARTIKEL_R').AsInteger := ARTIKEL_R;

        if (MENGE>0) then
         FieldByName('BRISANZ').AsInteger := (eT_MotivationMindestbestand + eT_MotivationManuell) div 2
        else
         FieldByName('BRISANZ').AsInteger := eT_MotivationKundenAuftrag;
        FieldByName('MENGE').AsInteger := MENGE;
        FieldByName('MENGE_BISHER').AsInteger := MENGE_BISHER_0 + MENGE_BISHER_1;
        FieldByName('MENGE_NEU').AsInteger := result;

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
      AppendStringsToFile(E.Message,ErrorFName('ARTIKEL'),Uhr12);
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

  until yet;

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
const
 e_w_GTIN_Stempel_Name : string = '';
 e_w_GTIN_STEMPEL_R : integer = 0;

//    0: Neue GTIN wurde eingetragen
//   -1: Stempel "+" ist nicht definiert
//   -2: Bestehende GTIN enthält ungültige Zeichen
//   -3: Bestehende GTIN hat eine falsche Prüfziffer
//   -4: Bestehende GTIN ist OK

function e_w_GTIN(AUSGABEART_R, ARTIKEL_R: integer) : int64;
var
 _GTIN, GTIN : string;
 NUMERO : string;
 GTIN_COUNT: integer;
begin
 result := 0;
 repeat

   if (AUSGABEART_R=0) then
   begin
    _GTIN := e_r_sqls('select GTIN from ARTIKEL where RID='+IntToStr(ARTIKEL_R));
   end else
   begin
    _GTIN := e_r_sqls(
     {} 'select GTIN from ARTIKEL_AA where'+
     {} ' (ARTIKEL_R='+IntToStr(ARTIKEL_R)+') and'+
     {} ' (AUSGABEART_R='+IntToStr(AUSGABEART_R)+')');
   end;

   repeat
    if (_GTIN='') then
     break;

    if (StrFilter(GTIN,cZiffern)<>GTIN) then
    begin
     result := -2;
     break;
    end;

    NUMERO := e_r_sqls('select NUMERO from ARTIKEL where RID='+IntToStr(ARTIKEL_R));

    if (_GTIN=NUMERO) then
     break;

    if PruefZifferOK(StrToInt64Def(_GTIN,0)) then
    begin
      result := -4;
      break;
    end;

    result := -3;

   until yet;

   if result<>0 then
    break;

   // Jetzt mal einen Wert aus dem Stempel holen
   if (e_w_GTIN_Stempel_Name='') then
   begin
    e_w_GTIN_Stempel_Name := e_r_sqls('select PREFIX from STEMPEL where PREFIX starts with ''+''');
    if (e_w_GTIN_Stempel_Name='') then
    begin
      result := -1;
      break;
    end;
    e_w_GTIN_STEMPEL_R := e_r_sql('select RID from STEMPEL where PREFIX='''+e_w_GTIN_Stempel_Name+'''');
   end;

   repeat

     // Neue GTIN berechnen
     GTIN :=
       {} StrFilter(e_w_GTIN_Stempel_Name,cZiffern)+
       {} INtToStrN (e_w_Stempel(e_w_GTIN_STEMPEL_R),CharCount('n',e_w_GTIN_Stempel_Name));
     GTIN := GTIN + Int64ToStr(PruefZiffer(StrToInt64(GTIN)));

     GTIN_COUNT := e_r_sql('select count(RID) from ARTIKEL where GTIN='''+GTIN+'''');
     if (GTIN_COUNT>0) then
      continue;

     GTIN_COUNT := e_r_sql('select count(RID) from ARTIKEL_AA where GTIN='''+GTIN+'''');
     if (GTIN_COUNT>0) then
      continue;

   until yet;

   // Neuen Wert setzen
   if (AUSGABEART_R=0) then
   begin
    e_x_sql(
    {} 'update ARTIKEL set GTIN='''+GTIN+''' where' +
    {} ' (RID='+INtToStr(ARTIKEL_R)+')');
   end else
   begin
    e_x_sql(
    {} 'update ARTIKEL_AA set GTIN='''+GTIN+''' where' +
    {} ' (ARTIKEL_R='+INtToStr(ARTIKEL_R)+') and' +
    {} ' (AUSGABEART_R='+INtToStr(AUSGABEART_R)+')');
   end;
 until yet;
end;

function e_r_Bewegungen (PERSON_R: Integer = cRID_unset) : boolean;
var
  sql: TStringList;
begin
  result := true;
  sql := TStringList.create;
  sql.add('SELECT');
  sql.add('       WARENBEWEGUNG.MENGE');
  sql.add('     , ARTIKEL.MENGE LAGER_MENGE');
  sql.add('     , ARTIKEL.MINDESTBESTAND');
  sql.add('     , WARENBEWEGUNG.AUFTRITT');
  sql.add('     , WARENBEWEGUNG.AUSGABEART_R');
  sql.add('     , ARTIKEL.NUMERO');
  sql.add('     , ARTIKEL.VERLAGNO');
  sql.add('     , ARTIKEL.TITEL');
  sql.add('     , LAGER.NAME');
  sql.add('     , (SELECT LAGER.NAME FROM LAGER WHERE LAGER.RID=BELEG.LAGER_R) ZIEL');
  sql.add('     , WARENBEWEGUNG.BEWEGT');
  sql.add('     , WARENBEWEGUNG.MENGE_BISHER');
  sql.add('     , WARENBEWEGUNG.MENGE_NEU');
  sql.add('     , WARENBEWEGUNG.ZUSAMMENHANG');
  sql.add('     , WARENBEWEGUNG.BRISANZ');
  sql.add('     , WARENBEWEGUNG.RID');
  sql.add('     , WARENBEWEGUNG.ARTIKEL_R');
  sql.add('     , WARENBEWEGUNG.BELEG_R');
  sql.add('     , WARENBEWEGUNG.POSTEN_R');
  sql.add('     , WARENBEWEGUNG.BBELEG_R');
  sql.add('     , WARENBEWEGUNG.BPOSTEN_R');
  sql.Add('     , (''S1(1+''||WARENBEWEGUNG.LAGER_R||'')'') S1');
  sql.Add('     , (''S2(1+''||BELEG.LAGER_R||'')'') S2');
  sql.Add('     , AUSGABEART.NAME AA');
  sql.add('FROM');
  sql.add(' WARENBEWEGUNG');
  sql.add('LEFT JOIN');
  sql.add(' ARTIKEL');
  sql.add('ON');
  sql.add(' WARENBEWEGUNG.ARTIKEL_R=ARTIKEL.RID');
  sql.Add('LEFT JOIN');
  sql.add(' AUSGABEART');
  sql.add('ON');
  sql.add(' WARENBEWEGUNG.AUSGABEART_R=AUSGABEART.RID');
  sql.Add('LEFT JOIN');
  sql.Add(' BELEG');
  sql.add('ON');
  sql.Add(' WARENBEWEGUNG.BELEG_R=BELEG.RID');
  sql.add('LEFT JOIN');
  sql.add(' LAGER');
  sql.add('ON');
  sql.add(' WARENBEWEGUNG.LAGER_R=LAGER.RID');
  sql.add('WHERE');
  sql.add(' (WARENBEWEGUNG.BEWEGT<>''Y'') OR');
  sql.add(' (WARENBEWEGUNG.BEWEGT IS NULL)');
  sql.add('ORDER BY');
  sql.add(' LAGER.NAME, BELEG.RID, ARTIKEL.TITEL, AUSGABEART.NAME');
  ExportTable(sql, DiagnosePath + 'WE.csv');
  sql.free;
end;

function e_w_Wareneingang(AUSGABEART_R, ARTIKEL_R, MENGE: integer): integer; // [ZUSAMMENHANG]

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
  _Menge: integer;
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
    //                    das geschieht in einer schleife
    // 2) BELEG.POSTEN: MENGE_AGENT auf MENGE_RECHNUNG buchen
    // 3) Restmenge in das Mengen-Feld des Artikels (LAGER)
    //

    // erst mal die erwarteten Menge zurücksetzen
    // dabei sollte mögliche Reihenfolge in FOLGE vorgegeben sein
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
          FieldByName('MENGE_ERWARTET').AsInteger := FieldByName('MENGE_ERWARTET').AsInteger - AtomMenge;
        FieldByName('MENGE_GELIEFERT').AsInteger := FieldByName('MENGE_GELIEFERT').AsInteger + AtomMenge;
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
          FieldByName('PERSON_R').AsInteger := e_r_sql('select PERSON_R from BBELEG where RID=' + inttostr(BBELEG_R));
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
        FieldByName('MENGE_RECHNUNG').AsInteger := FieldByName('MENGE_RECHNUNG').AsInteger + AtomMenge;
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

    //
    QueryPOSTEN.free;
    QueryBPOSTEN.free;

    // Rest einlagern
    if (_Menge > 0) then
     e_w_Menge(cRID_Null, AUSGABEART_R, ARTIKEL_R, _Menge);


  except
    on E: exception do
    begin
      AppendStringsToFile('e_w_WarenEingang'+inttostr(result)+':'+E.Message,ErrorFName('ARTIKEL'),Uhr12);
      result := -1;
    end;
  end;
end;

function Lager_iX(PLATZIERUNG : eLagerPlatzierungen):Byte;
begin
  case PLATZIERUNG of
   LagerPlazierung_Stehend: result := cLiZ;
   LagerPlazierung_Stapel: result := cLiX;
   LagerPlazierung_Seitlich: result := cLiZ;
   LagerPlazierung_Nativ,
   LagerPlazierung_Supermarkt: result  := cLiX;
  else
   result := cLiX;
  end;
end;

function Lager_iY(PLATZIERUNG : eLagerPlatzierungen):Byte;
begin
  case PLATZIERUNG of
   LagerPlazierung_Stehend: result := cLiY;
   LagerPlazierung_Stapel: result := cLiZ;
   LagerPlazierung_Seitlich: result := cLiX;
   LagerPlazierung_Nativ,
   LagerPlazierung_Supermarkt: result  := cLiY;
  else
   result := cLiY;
  end;
end;

function Lager_iZ(PLATZIERUNG : eLagerPlatzierungen):Byte; // ARTIKEL_XYZ[.]
begin
  case PLATZIERUNG of
   LagerPlazierung_Stehend: result := cLiX;
   LagerPlazierung_Stapel: result := cLiY;
   LagerPlazierung_Seitlich: result := cLiY;
   LagerPlazierung_Nativ,
   LagerPlazierung_Supermarkt: result := cLiZ;
  else
   result := cLiZ;
  end;
end;

// Aus LAGER Sichtweise
function Lager_iFill(PLATZIERUNG : eLagerPlatzierungen):Byte;
begin
  case PLATZIERUNG of
   LagerPlazierung_Stehend: result := cLiX;
   LagerPlazierung_Stapel: result := cLiY;
   LagerPlazierung_Seitlich: result := cLiX;
   LagerPlazierung_Nativ: result := cLiY;
   LagerPlazierung_Supermarkt: result := cLiZ;
  end;
end;

// Aus ARTIKEL Sichtweise
function Artikel_iFill(PLATZIERUNG : eLagerPlatzierungen):Byte;
begin
  case Lager_iFill(PLATZIERUNG) of
   cLiX:result := Lager_iX(PLATZIERUNG);
   cLiY:result := Lager_iY(PLATZIERUNG);
   cLiZ:result := Lager_iZ(PLATZIERUNG);
  end;
end;

function Lagern(
 {} MENGE: integer;
 {} PLATZIERUNG : eLagerPlatzierungen;
 {} ARTIKEL, LAGER : TgpIntegerList;
 {} AutoSize : boolean = false) : boolean;
var
 ErrorFlag: boolean;

 procedure Error(s:string;SetErrorFlag:boolean=false);
 begin
   AppendStringsToFile(S,ErrorFName('LAGER'));
   if SetErrorFlag then
    ErrorFlag := true;
 end;

begin
  result := false;
  ErrorFlag := false;

  repeat

    // Automatisch drehen
    if (PLATZIERUNG=LagerPlazierung_Stapel) then
     if (ARTIKEL[cLiX]>ARTIKEL[cLiY]) then
     begin
      if DebugMode then
       Error(' Landscape-Artikel gedreht!');
      ARTIKEL.Exchange(cLiX, cLiY);
     end;

    // Ist das Lager bereits voll?
    if (MENGE<0) then
     if (LAGER[cLiX]<1) or (LAGER[cLiY]<1) or (LAGER[cLiZ]<1) then
     begin
      if DebugMode then
        Error(' das Maß LAGER.X|Y|Z=0',true);
      break;
     end;

    if AutoSize then
    begin
     // AutoSize der Kontakt-Fläche
     case Lager_iFill(PLATZIERUNG) of
      cLiX:begin
            LAGER[cLiY] := max(LAGER[cLiY], ARTIKEL[Lager_iY(PLATZIERUNG)]);
            LAGER[cLiZ] := max(LAGER[cLiZ], ARTIKEL[Lager_iZ(PLATZIERUNG)]);
           end;
      cLiY:begin
            LAGER[cLiX] := max(LAGER[cLiX], ARTIKEL[Lager_iX(PLATZIERUNG)]);
            LAGER[cLiZ] := max(LAGER[cLiZ], ARTIKEL[Lager_iZ(PLATZIERUNG)]);
           end;
      cLiZ:begin
            LAGER[cLiX] := max(LAGER[cLiX], ARTIKEL[Lager_iX(PLATZIERUNG)]);
            LAGER[cLiY] := max(LAGER[cLiY], ARTIKEL[Lager_iY(PLATZIERUNG)]);
           end;
     end;
    end else
    begin

      if (LAGER[cLiX]<ARTIKEL[Lager_iX(PLATZIERUNG)]) then
      begin
       if DebugMode then
        error(' LAGER.X ist nur '+IntToStr(LAGER[cLiX])+', sollte aber >='+IntToStr(ARTIKEL[Lager_iX(PLATZIERUNG)])+' sein',true);
       ErrorFlag := true;
      end;

      if (LAGER[cLiY]<ARTIKEL[Lager_iY(PLATZIERUNG)]) then
      begin
       if DebugMode then
        error(' LAGER.Y ist nur '+IntToStr(LAGER[cLiY])+', sollte aber >='+IntToStr(ARTIKEL[Lager_iY(PLATZIERUNG)])+' sein',true);
       ErrorFlag := true;
      end;

      if (LAGER[cLiZ]<ARTIKEL[Lager_iZ(PLATZIERUNG)]) then
      begin
       if DebugMode then
        error(' LAGER.Z ist nur '+IntToStr(LAGER[cLiZ])+', sollte aber >='+IntToStr(ARTIKEL[Lager_iZ(PLATZIERUNG)])+' sein',true);
       ErrorFlag := true;
      end;

    end;

    (*
    // Wie oft passt der Artikel in seiner X-Ausdehnung
    SX := LAGER[cLiX] div ARTIKEL[0];
    if (SX=0) then
    begin
      Error('das Maß X des Artikels ist für diesen Lagerplatz zu gross ...');
      break;
    end;

    // Wie oft passt der Artikel in seiner Z-Ausdehnung
    SZ := LAGER[cLiZ] div ARTIKEL[2];
    if (SZ=0) then
    begin
      Error('das Maß Z des Artikels ist für diesen Lagerplatz zu gross ...');
      break;
    end;

    // Anzahl der möglichen Stapel
    STAPEL := SX * SZ;
    STAPEL := 1;
    *)

    //
    LAGER[Lager_iFill(PLATZIERUNG)] :=
     LAGER[Lager_iFill(PLATZIERUNG)] +
     (ARTIKEL[Artikel_iFill(PLATZIERUNG)] * MENGE);

    if ErrorFlag then
     break;

    result := true;

  until yet;
end;

function e_w_Vergriffen(AUSGABEART_R, ARTIKEL_R: Integer): Integer; // [ZUSAMMENHANG]

  function AusgabeArtCompare: string;
  begin
    if (AUSGABEART_R <= cAUSGABEART_OHNE) then
      result := ' is null'
    else
      result := ' = ' + inttostr(AUSGABEART_R);
  end;

var
  QueryPOSTEN: TdboQuery;
  QueryBPOSTEN: TdboQuery;
  EREIGNIS: TdboQuery;
  BBELEG_R: integer;
  BELEG_R: integer;
  MENGE: Integer;
begin

  // neuen Zusammenhang beginnen
  result := e_w_GEN('GEN_ZUSAMMENHANG');
  try

    //
    // 1) BBELEG.BPOSTEN: MENGE_ERWARTET auf MENGE_AUSFALL verschieben
    // 2) BELEG.POSTEN: MENGE_AGENT auf MENGE_AUSFALL verschieben
    // 3) in den Artikel Preis:= -1, Mindestbestand := 0
    //

    // erst mal die erwarteten Menge zurücksetzen
    // dabei sollte mögliche Reihenfolge in FOLGE vorgegeben sein
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
      sql.add(' (MENGE_ERWARTET>0)');
      for_update(sql);
      Open;

      // den aktuellen Zusammenhang festlegen!
      while not(eof) do
      begin

        // beliebige Mengen von "ERWARET" nach "AUSFALL" verschieben
        MENGE := FieldByName('MENGE_ERWARTET').AsInteger;
        edit;
        FieldByName('MENGE_AUSFALL').AsInteger :=
         {} FieldByName('MENGE_AUSFALL').AsInteger +
         {} MENGE;
        FieldByName('MENGE_ERWARTET').clear;
        Post;

        //
        BBELEG_R := FieldByName('BELEG_R').AsInteger;

        //
        e_w_BBelegStatusBuchen(BBELEG_R);

        // Ereignis "vergriffen" buchen!
        EREIGNIS := nQuery;
        with EREIGNIS do
        begin
{$IFNDEF fpc}
          ColumnAttributes.add('RID=NOTREQUIRED');
          ColumnAttributes.add('AUFTRITT=NOTREQUIRED');
{$ENDIF}
          sql.add('select * from EREIGNIS ' + for_update);
          Insert;
          FieldByName('ART').AsInteger := eT_Vergriffen;
          FieldByName('ZUSAMMENHANG').AsInteger := result;
          FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
          FieldByName('PERSON_R').AsInteger := e_r_sql('select PERSON_R from BBELEG where RID=' + inttostr(BBELEG_R));
          FieldByName('ARTIKEL_R').AsInteger := ARTIKEL_R;
          FieldByName('AUSGABEART_R').assign(QueryBPOSTEN.FieldByName('AUSGABEART_R'));
          FieldByName('BBELEG_R').AsInteger := BBELEG_R;
          FieldByName('BPOSTEN_R').assign(QueryBPOSTEN.FieldByName('RID'));
          FieldByName('MENGE').AsInteger := MENGE;
          Post;
        end;
        EREIGNIS.free;
        Next;
      end;
      Close;
    end;

    // nun die Agent Mengen->auf Ü-Fächer verteilen!
    QueryPOSTEN := nQuery;
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
      for_update(sql);

      Open;
      while not(eof) do
      begin

        // Menge zurückbuchen
        MENGE := FieldByName('MENGE_AGENT').AsInteger;
        edit;
        FieldByName('MENGE_AUSFALL').AsInteger :=
         {} FieldByName('MENGE_AUSFALL').AsInteger +
         {} MENGE;
        FieldByName('MENGE_AGENT').clear;
        Post;

        // dem Beleg die Änderung bekanntmachen
        BELEG_R := FieldByName('BELEG_R').AsInteger;
        e_w_BelegStatusBuchen(BELEG_R);

        // Ereignis "Vergriffen" buchen!
        EREIGNIS := nQuery;
        with EREIGNIS do
        begin
{$IFNDEF fpc}
          ColumnAttributes.add('RID=NOTREQUIRED');
          ColumnAttributes.add('AUFTRITT=NOTREQUIRED');
{$ENDIF}
          sql.add('select * from EREIGNIS ' + for_update);
          Insert;
          FieldByName('ART').AsInteger := eT_vergriffen;
          FieldByName('ZUSAMMENHANG').AsInteger := result;
          FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
          FieldByName('PERSON_R').AsInteger := e_r_sql('select PERSON_R from BELEG where RID=' + inttostr(BELEG_R));
          FieldByName('ARTIKEL_R').AsInteger := ARTIKEL_R;
          FieldByName('AUSGABEART_R').assign(QueryPOSTEN.FieldByName('AUSGABEART_R'));
          FieldByName('BELEG_R').AsInteger := BELEG_R;
          FieldByName('POSTEN_R').assign(QueryPOSTEN.FieldByName('RID'));
          FieldByName('MENGE').AsInteger := MENGE;
          Post;
        end;
        EREIGNIS.free;
        Next;
      end;
      Close;
    end;

    //
    QueryPOSTEN.free;
    QueryBPOSTEN.free;

    // im Artikel,  PREIS := -1, MINDESTBESTAND := 0
    if (AUSGABEART_R <= cAUSGABEART_OHNE) then
      e_x_sql(
       {} 'update ARTIKEL set ' +
       {} ' EURO=' + FloatToStrISO(cPreis_vergriffen,1) +','+
       {} ' MINDESTBESTAND=null '+
       {} 'where'+
       {} ' RID=' + inttostr(ARTIKEL_R))
    else
      e_x_sql(
       {} 'update ARTIKEL_AA set ' +
       {} ' EURO=' + FloatToStrISO(cPreis_vergriffen,1) +','+
       {} ' MINDESTBESTAND=null '+
       {} 'where'+
       {} ' (RID=' + inttostr(ARTIKEL_R) + ') and' +
       {} ' (AUSGABEART_R=' + inttostr(AUSGABEART_R) + ')');

  except
    on E: exception do
    begin
      AppendStringsToFile('e_w_WarenEingang'+inttostr(result)+':'+E.Message,ErrorFName('ARTIKEL'),Uhr12);
      result := -1;
    end;
  end;
end;
procedure e_w_LagerFreigeben;
var
  cARTIKEL: TdboCursor;
  FreeList: TgpIntegerList;
  DateTimeOut: TAnfixDate;
  n: integer;
begin
  cARTIKEL := nCursor;
  FreeList := TgpIntegerList.create;

  DateTimeOut := DatePlus(DateGet, -14);
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

procedure e_w_Zwischenlagern(BELEG_R, LAGER_R: integer);
begin
  if (LAGER_R < cRID_FirstValid) then
    e_x_sql('update BELEG set LAGER_R=null where RID=' + inttostr(BELEG_R))
  else
    e_x_sql('update BELEG set LAGER_R=' + inttostr(LAGER_R) + ' where RID=' + inttostr(BELEG_R));
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

    until yet;

  except
    on E: exception do
    begin
      AppendStringsToFile('e_r_Gewicht: ' + E.Message,
        {} ErrorFName('ARTIKEL'),
        {} Uhr12);
    end;
  end;
end;

function e_r_MindestBestellMenge(AUSGABEART_R, ARTIKEL_R: integer): integer;
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
          sql.add('select MINDESTBESTELLMENGE from ARTIKEL_AA');
          sql.add('where');
          sql.add(' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') and');
          sql.add(' (AUSGABEART_R=' + inttostr(AUSGABEART_R) + ')');
          ApiFirst;
          if not(eof) then
          begin
            if not FieldByName('MINDESTBESTELLMENGE').IsNull then
            begin
              result := FieldByName('MINDESTBESTELLMENGE').AsInteger;
              cGEWICHT.free;
              break;
            end;
          end;
        end;
        cGEWICHT.free;

        // über den Standard-Eintrag in der AUSGABEART
        result := e_r_sql('select MINDESTBESTELLMENGE from AUSGABEART where RID=' + inttostr(AUSGABEART_R));
        break;

      end;

      result := e_r_sql('select MINDESTBESTELLMENGE from ARTIKEL where RID=' + inttostr(ARTIKEL_R));

    until yet;

  except
    on E: exception do
    begin
      AppendStringsToFile('e_r_MindestBestellmenge: ' + E.Message,
        {} ErrorFName('ARTIKEL'),
        {} Uhr12);
    end;
  end;
end;

function e_r_Rabatt(ARTIKEL_R, PERSON_R: integer; var Netto: boolean; var NettoWieBrutto: boolean): double;
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
        sql.add('SELECT RABATT_CODE,NETTO,NETTO_WIE_BRUTTO FROM PERSON WHERE RID=' + inttostr(PERSON_R));
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
      MaxRabatt := e_r_sqld(format(
       {} 'select RABATT from RABATT where' +
       {} ' (CODE is null) and ' +
       {} ' ((SORTIMENT_R=%d) or (ARTIKEL_R=%d))',
       {} [SORTIMENT_R, ARTIKEL_R]),
       {} 100.0);
      if MaxRabatt = 0.0 then
        break;

      if (MaxRabatt > result) then
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
            if matchRule(format('select RABATT from RABATT where (CODE=''%s'') and (SORTIMENT_R=%d) and (PERSON_R=%d)',
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

    until yet;
  except
    on E: exception do
    begin
      AppendStringsToFile('e_r_Rabatt: ' + E.Message,
      ErrorFName('ARTIKEL'),
      Uhr12);
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

  until yet;

  result := Rabatt;

end;

function e_w_Artikel(EINHEIT_R, AUSGABEART_R, ARTIKEL_R: integer): boolean;
var
  MINDESTBESTAND: string;
begin
  result := false;
  if (ARTIKEL_R >= cRID_FirstValid) and (AUSGABEART_R >= cRID_FirstValid) then
  begin
    if (e_r_sql(
     { } 'select count(RID) from ARTIKEL_AA where ' +
     { } ' (ARTIKEL_R' + isRID(ARTIKEL_R) + ') and ' +
     { } ' (AUSGABEART_R' + isRID(AUSGABEART_R) + ') and ' +
     { } ' (EINHEIT_R' + isRID(EINHEIT_R) + ')') = 0) then
    begin

      if (AUSGABEART_R = cAusgabeArt_Aufnahme_MP3) then
        MINDESTBESTAND := inttostr(cMenge_unbegrenzt)
      else
        MINDESTBESTAND := 'null';

      e_x_sql('insert into ARTIKEL_AA (RID, EINHEIT_R, AUSGABEART_R, ARTIKEL_R, MINDESTBESTAND, LETZTEAENDERUNG) ' +
        ' values (' +
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
      sql.add('SELECT NAECHSTE_NUMMER FROM SORTIMENT WHERE RID=' + inttostr(SORTIMENT_R) + ' ' + for_update);
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
      sql.add('select RID,SORTIMENT_R,NUMERO,ERSTEINTRAG,MINDESTBESTAND,GEWICHT from ARTIKEL ' + for_update);
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
      AppendStringsToFile('e_w_ArtikelNeu(' + inttostr(SORTIMENT_R) + '): ' + E.Message,
      ErrorFname('ARTIKEL'),
      Uhr12);
    end;
  end;
  ARTIKEL.free;
  Sortiment.free;
  ArtikelNo.free;
end;

function e_r_ArtikelDimensionen(
  { } EINHEIT_R, AUSGABEART_R, ARTIKEL_R : Integer;
  { } MENGE: Integer = 1): TgpIntegerList; // [X,Y,Z,MENGE]
var
 FatalError : boolean;

 procedure Error(s:string; Panic: boolean=false);
 begin
   AppendStringsToFile(S,ErrorFName('LAGER'));
   if Panic then
    FatalError := true;
 end;

 function ParamAsString : string;
 begin
   result :=
    '(EINHEIT_R=' + IntToStr(EINHEIT_R) + ',' +
    'AUSGABEART_R=' + IntToStr(AUSGABEART_R) + ',' +
    'ARTIKEL_R=' + IntToStr(ARTIKEL_R)+')';
 end;

var
 cARTIKEL : TdboCursor;
begin
  if DebugMode then
   Error('e_r_ArtikelDimensionen'+ParamAsString);
  FatalError := false;
  result := TgpIntegerList.Create;
  result.Add(0);
  result.Add(0);
  result.Add(0);
  result.Add(-1);
  cARTIKEL := nCursor;
  with cARTIKEL do
  begin
   if (AUSGABEART_R>=cRID_FirstValid) then
   begin
     sql.Add(
     {} 'select X,Y,Z,MENGE from ARTIKEL_AA where '+
     {} ' (ARTIKEL_R='+IntToStr(ARTIKEL_R)+') and '+
     {} ' (AUSGABEART_R='+IntToStr(AUSGABEART_R)+') and '+
     {} ' (EINHEIT_R '+isRID(EINHEIT_R)+')');
   end else
   begin
     sql.Add(
     {} 'select X,Y,Z,MENGE from ARTIKEL where '+
     {} ' (RID='+IntToStr(ARTIKEL_R)+')');
   end;
   ApiFirst;
   if not(eof) then
   begin
     result[cLiX] := FieldByName('X').AsInteger;
     result[cLiY] := FieldByName('Y').AsInteger;
     result[cLiZ] := FieldByName('Z').AsInteger;
     result[3] := FieldByName('MENGE').AsInteger;
   end;
  end;
  cARTIKEL.Free;
end;

function e_r_MwSt(SORTIMENT_R: integer): double; overload;
begin
  result := e_r_Prozent(
   {} e_r_sqls(
   {} 'select MWST_NAME from SORTIMENT WHERE RID=' +
   {} inttostr(SORTIMENT_R)));
end;

function e_r_MwSt(AUSGABEART_R, ARTIKEL_R: integer): double; overload;
begin
  if (ARTIKEL_R >= cRID_FirstValid) then
  begin
    result := e_r_MwSt(e_r_sql('select SORTIMENT_R from ARTIKEL where RID=' + inttostr(ARTIKEL_R)));
  end
  else
  begin
    result := 0.0;
  end;
end;

// Preis-Tabelle-Caching

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

        if FieldByName('EURO').IsNull and not(FieldByName('PREIS').IsNull) and not(FieldByName('WAEHRUNG_R').IsNull)
        then
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
      AppendStringsToFile(
       'e_r_PreisNativ(' + inttostr(AUSGABEART_R) + ',' + inttostr(ARTIKEL_R) + '): '+
       E.Message,ErrorFName('ARTIKEL'),Uhr12);
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

  until yet;
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
      sql.add('from SORTIMENT');
      sql.add('left JOIN MWST ON');
      sql.add(' (SORTIMENT.MWST_NAME=MWST.NAME) and');
      sql.Add(' (CURRENT_DATE between MWST.VON_DATUM and MWST.BIS_DATUM)');

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

function e_r_Preis(EINHEIT_R, AUSGABEART_R, ARTIKEL_R: integer; var Satz: double; var Netto: boolean;
  var NettoWieBrutto: boolean): double;
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

        until yet;
      end;
    end;
  except
    on E: exception do
    begin
       AppendStringsToFile(
        'e_r_Preis(' + inttostr(AUSGABEART_R) + ',' + inttostr(ARTIKEL_R) + '): ' + E.Message,
        errorFName('ARTIKEL'),
        Uhr12);
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
        sql.add(
        {} 'select PREIS.USD from ARTIKEL ' +
        {} 'join PREIS on' +
        {} ' (ARTIKEL.PREIS_R=PREIS.RID)' +
        {} 'where' +
        {} ' (ARTIKEL.RID=' + inttostr(ARTIKEL_R) + ') and' +
        {} ' (ARTIKEL.PREIS_R is not null) and' +
        {} ' (PREIS.USD is not null)');
        ApiFirst;
        if not(eof) then
          result := FieldByName('USD').AsFloat;
      end;
      cPREIS.free;
    end;
  except
    on E: exception do
    begin
      AppendStringsToFile('e_r_USD(' + inttostr(ARTIKEL_R) + '): ' + E.Message,
      errorFName('ARTIKEL'),
      uhr12);
    end;
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

function e_r_Prozent(Satz: String; mDatum: TAnfixDate = cIllegalDate): double;
begin
  if (mDatum = cIllegalDate) then
    mDatum := DateGet;
  result := e_r_sqld(
    { } 'select SATZ from MWST where ' +
    { } ' (NAME=' + SqlString(Satz) + ') and ' +
    { } ' (''' + long2date(mDatum) + ''' between VON_DATUM and BIS_DATUM)');
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

    until yet;

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

function e_r_ArtikelVorschaubild(AUSGABEART_R, ARTIKEL_R: integer; DoFileCheck: boolean = true): string;
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
      until yet;
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
        until yet;
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
      AppendStringsToFile('e_r_Lieferzeit(' + inttostr(AUSGABEART_R) + ',' + inttostr(ARTIKEL_R) + '): ' +
        E.Message, ErrorFName('ARTIKEL'), Uhr12);

    end;
  end;
end;

function e_r_ArtikelInfo(ARTIKEL_R: integer; Prefix: string = ''): TStringList;
var
  cARTIKEL: TdboCursor;
  n: integer;
begin
  result := TStringList.create;
  if (ARTIKEL_R >= cRID_FirstValid) then
  begin

    cARTIKEL := nCursor;
    with cARTIKEL do
    begin
      sql.add('select * from ARTIKEL where RID=' + inttostr(ARTIKEL_R));
      ApiFirst;

      // aus dem Artikelstamm übernommene Felder
      result.add('Artikel=' + FieldByName('TITEL').AsString);
      result.add('No=' + FieldByName('NUMERO').AsString);

      result.add('Komponist=' + e_r_MusikerName(FieldByName('KOMPONIST_R').AsInteger));
      result.add('KomponistNachname=' + e_r_MusikerNachname(FieldByName('KOMPONIST_R').AsInteger));

      result.add('Arrangeur=' + e_r_MusikerName(FieldByName('ARRANGEUR_R').AsInteger));
      result.add('ArrangeurNachname=' + e_r_MusikerNachname(FieldByName('ARRANGEUR_R').AsInteger));

      result.add('Verlag=' + e_r_Verlag(FieldByName('VERLAG_R').AsInteger));
      result.add('VerlagNo=' + UnbreakAble(FieldByName('VERLAGNO').AsString));
      result.add('Konto=' + b_r_Konto(FieldByName('SORTIMENT_R').AsInteger));
      result.add('Lager=' + e_r_LagerPlatzNameFromLAGER_R(FieldByName('LAGER_R').AsInteger));

      result.add('GEMA_WN=' + FieldByName('GEMA_WN').AsString);

    end;
    cARTIKEL.free;
  end
  else
  begin
    result.add('Artikel=');
    result.add('No=');

    result.add('Komponist=');
    result.add('KomponistNachname=');

    result.add('Arrangeur=');
    result.add('ArrangeurNachname=');

    result.add('Verlag=');
    result.add('VerlagNo=');
    result.add('Konto=');
    result.add('Lager=');

    result.add('GEMA_WN=');
  end;

  if (Prefix <> '') then
    for n := 0 to pred(result.count) do
      result[n] := Prefix + result[n];
end;

function e_r_MindestMenge(AUSGABEART_R, ARTIKEL_R: integer): integer;
begin
  if (AUSGABEART_R > 0) then
  begin
    result := 0;
  end
  else
  begin
    result := max(0, e_r_sql('SELECT MINDESTBESTAND FROM ARTIKEL WHERE RID=' + inttostr(ARTIKEL_R)));
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
    sLinkList := e_r_sqlt('select BEMERKUNG from DOKUMENT where' + ' (RID=' + inttostr(MUSIK_R) + ')');
    if (sLinkList.count > 0) then
      result := HugeSingleLine(sLinkList, cOLAPcsvLineBreak);
    sLinkList.free;
  until yet;
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
    ResultL.add(e_r_sqls('select TITEL from ARTIKEL where' + ' (RID=' + inttostr(KontextL[n]) + ')'));
  result := HugeSingleLine(ResultL, cOLAPcsvLineBreak);
  KontextL.free;
  ResultL.free;
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
    cARTIKEL := nCursor;
    ClientSorter := TStringList.create;

    // TITEL ermitteln
    with cARTIKEL do
    begin
      sql.add('select');
      if iGOT then
        sql.add(' A00,');
      sql.add(' TITEL');
      sql.add('from ARTIKEL where RID=:CROSSREF');
      prepare;
    end;
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

    // Sortieren und ausgeben
    ClientSorter.sort;
    for n := 0 to pred(ClientSorter.count) do
      RIDS[n] := ClientSorter.Objects[n];

    ClientSorter.free;
    cARTIKEL.free;
  end;
end;

function e_r_AusgabeartKurz(AUSGABEART_R: integer): string;
begin
  result := e_r_sqls('select KUERZEL from AUSGABEART where RID=' + inttostr(AUSGABEART_R));
end;

function e_r_Artikel(AUSGABEART_R, ARTIKEL_R: integer): string;
begin
  result := e_r_sqls('select TITEL from ARTIKEL where RID=' + inttostr(ARTIKEL_R));
  if (AUSGABEART_R >= cRID_FirstValid) then
    result := e_r_AusgabeartKurz(AUSGABEART_R) + ' ' + result;
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
      sql.add('SELECT RID,PAKET_MENGE,PAKET_ARTIKEL_R FROM ARTIKEL WHERE PAKET_R=' + inttostr(ARTIKEL_R));
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
      AppendStringsToFile(
       {} 'e_r_PaketPreis(' + inttostr(AUSGABEART_R) + ',' + inttostr(ARTIKEL_R) + '): ' +
       {} E.Message,
       {} ErrorFName('ARTIKEL'),
       {} Uhr12);
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

  until yet;
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
function e_r_MengenAusgabe(MENGE, EINHEIT_R: integer; FormatStr: string = '%d'): string;
var
  KommaZahl: double;
  cEINHEIT: TdboCursor;
  AusgabeS: string;
  MENGEN_EINHEIT : string;
  MENGEN_EINHEIT_SINGULAR : string;
  MENGEN_EINHEIT_PLURAL: string;
  k : integer;
  EINHEIT,NENNER,FAKTOR : Integer;
begin
  cEINHEIT := nil;
  AusgabeS := inttostr(MENGE);
  repeat
   if (EINHEIT_R < cRID_FirstValid) then
    break;

    cEINHEIT := nCursor;
    with cEINHEIT do
    begin
      sql.add('select * from EINHEIT where RID=' + inttostr(EINHEIT_R));
      ApiFirst;

      if eof then
       break;

      EINHEIT := FieldByName('EINHEIT').AsInteger;
      FAKTOR := FieldByName('FAKTOR').AsInteger;

      if (EINHEIT <= 0) then
       break;

      if (FAKTOR>1) then
       MENGE := MENGE * FAKTOR;

      if (EINHEIT=3600) then
      begin
          // Sonderfall "Stunden", die hier angegebenen Sekunden werden in
          // Stunden umgewandelt
          AusgabeS := secondstostr(MENGE) + ' h';
          break;
      end;

       NENNER := FieldByName('NENNER').AsInteger;

       if (MENGE<>0) then
       begin

         if (NENNER=2) then
         begin
          if (MENGE<NENNER) then
           AusgabeS := ''
          else
           AusgabeS := inttostr(MENGE DIV NENNER);
          if (MENGE MOD NENNER=1) then
           AusgabeS := cutblank(AusgabeS + ' ½');
         end;

         if (NENNER=3) then
         begin
          if (MENGE<NENNER) then
           AusgabeS := ''
          else
           AusgabeS := inttostr(MENGE DIV NENNER);
           case (MENGE MOD NENNER) of
            1:AusgabeS := cutblank(AusgabeS + ' '+Uni2Html(8531)); { ⅓ }
            2:AusgabeS := cutblank(AusgabeS + ' '+Uni2Html(8532)); { ⅔ }
           end;
         end;

         if (NENNER=4) then
         begin
          if (MENGE<NENNER) then
           AusgabeS := ''
          else
           AusgabeS := inttostr(MENGE DIV NENNER);
          case (MENGE MOD NENNER) of
           1:AusgabeS := cutblank(AusgabeS + ' '+Uni2Html(188)); { ¼ }
           2:AusgabeS := cutblank(AusgabeS + ' ½');
           3:AusgabeS := cutblank(AusgabeS + ' '+Uni2HTML(190)); { ¾ }
          end;
         end;

       end;

       MENGEN_EINHEIT := ExtractSegmentBetween(FieldByName('ART').AsString,'[',']');
       if (MENGEN_EINHEIT<>'') then
       begin
        k := pos('|',MENGEN_EINHEIT);
        if (k>0) then
        begin
         MENGEN_EINHEIT_SINGULAR := nextp(MENGEN_EINHEIT,'|');
         MENGEN_EINHEIT_PLURAL := nextp(MENGEN_EINHEIT,'|');
        end else
        begin
         MENGEN_EINHEIT_SINGULAR := MENGEN_EINHEIT;
         MENGEN_EINHEIT_PLURAL := MENGEN_EINHEIT;
        end;
        if
         {} ((NENNER=0) and (MENGE=1)) or
         {} ((NENNER<>0) and (MENGE>0) and (MENGE<=NENNER) ) then
        begin
         AusgabeS := cutblank(AusgabeS + ' ' + MENGEN_EINHEIT_SINGULAR);
        end else
        begin
         AusgabeS := cutblank(AusgabeS + ' ' + MENGEN_EINHEIT_PLURAL);
        end;
       end else
       begin
        KommaZahl := MENGE;
        KommaZahl := KommaZahl / EINHEIT;
        AusgabeS :=  cutblank(
         { } format('%.' + inttostr(max(1,pred(length(FieldByName('EINHEIT').AsString)))) + 'f', [KommaZahl]) +
         { } ' ' +
         { } FieldByName('BASIS').AsString);
       end;
    end;

  until yet;

  if assigned(cEINHEIT) then
   cEINHEIT.free;

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

end.
