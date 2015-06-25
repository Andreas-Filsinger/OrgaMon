{
  |������___                  __  __
  |�����/ _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |����| | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |����| |_| | | | (_| | (_| | |  | | (_) | | | |
  |�����\___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |���������������|___/
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
unit Geld;

//
// SS = SteuerSatz [in Prozent]
//
// Brutto = Netto + Steuer
// Steuer = Netto * 0.SS
// Netto = Brutto / 1.SS
// Brutto = Netto * 1.SS
//

interface

uses
  classes, anfix32;

const
  // kleinste St�ckelung des Euros = 1 Cent
  cGeld_KleinsterBetrag = 0.01;
  cGeld_Schwellwert = cGeld_KleinsterBetrag / 2;
  cGeld_KeinElement = cGeld_Schwellwert;
  // Geldwert, der durch Addition niemals entstehen kann!

  // M.MMggGGGG#
  cGeld_Bedeutungslos = 0.000000001;
  cGeld_Max = 999000000000.00; // 999 Billiarden

  // Ein Zahlenwert, der kein Geldbetrag ist
  cGeld_Zero = 0.0;

  // Preis Konstanten
  cPreis_vergriffen = -1.0;
  cPreis_aufAnfrage = -2.0;
  cPreis_unbekannt = -3.0;
  cPreis_ungesetzt = -4.0;

  // vom OrgaMon intern benutzte Konten
  cKonto_Erloese = '8200';

  // Verzweigungskonto zur weiteren Verbuchung von Erl�sen!
  cKonto_FreierErloes = '8450';

  // Hauptkonto f�r ELV (Bank)
  cKonto_Bank = '1200';

  // erteilte SEPA Mandate (Kunde)
  cKonto_Mandat = '1260';

  // Hauptkonto f�r Bar Ausgaben / Einnahmen
  cKonto_Kasse = '1000';

  // Konto f�r bedeutungslose/private/durchlaufende Buchungen
  cKonto_DurchlaufenderPosten = '1590';

  // Forderungen (ehemals Tabelle "AUSGANGSRECHNUNGEN")
  cKonto_Forderungen = '1400';

  // Aktueller Status einer Forderung
  cForderung_Unklar = 0;
  cForderung_Zahlungsart_Frei = 1;
  cForderung_Zahlungsart_Unbekannt = 2;
  cForderung_Lastschrift_Anstehend = 3;
  cForderung_Lastschrift_Vorgemerkt = 4;
  cForderung_Lastschrift_Erhalten = 5;

  // Teilzahlung / Anzahlung / Gutscheine
  cKonto_Anzahlungen = '1710';

  // Konto f�r Umsatz- Vor- Mehrwert- Steuer
  cKonto_SatzPrefix = 'SATZ';
  cSatz_keinElement = -1.0; // da es keine negativen Prozents�tze gibt

  // vom OrgaMon benutzte Vorgangscodes f�r die Buchhaltung
  cVorgang_Rechnung = 'RECHNUNG (73)';
  cVorgang_Abschluss = 'ABSCHLUSS (805)';
  cVorgang_Lastschrift =
  { } 'LASTSCHR. (71);' +
  { } 'SAMMEL-LS-EINZUG (192);' +
  { } 'LASTSCHRIFTEINR (71);' +
  { } 'EINZELLASTSCHRIFTSEINZUG (171)';

  // Pfad f�r BLZ Dateien
  iSystemPath: string = '';

function cPreisRundung(d: double): double; overload;
function cPreisRundung(s: string): double; overload;
function cNetto(Satz, Wert: double): double;
function cBrutto(Satz, Wert: double): double;
function cPercent(Satz, Wert: double): double;
function cSkonto(Satz, Wert: double): double;
function cCent(Betrag: double): int64;

function isSomeMoney(Betrag: double): boolean; // <>0 ?
function isSoll(Betrag: double): boolean; // <0 ?
function isZeroMoney(Betrag: double): boolean; // =0 ?
function isHaben(Betrag: double): boolean; // >0 ?
function isEqual(Betrag1, Betrag2: double): boolean;
function isOther(Betrag1, Betrag2: double): boolean;
function isNoMoney(Betrag: double): boolean; // = cGeld_KeinElement

// String-Funktionen
function StrToMoney(x: string): double; // strto
function StrToMoneyDef(x: string; d: double = cGeld_Zero): double;
function MoneyToStr(d: double): string;

// Object-Funktionen
function MoneyAsObject(Wert: double): TObject;
function ObjectAsMoney(Wert: TObject): double;

// Integer-Funktionen
function MoneyAsCent(Wert: double): integer;
function CentAsMoney(Wert: integer): double;

// Banken-Funktionen
function checkAccount(BLZ, Konto, Name: string; sDiagnose: TStrings): boolean;
function checkIBAN(const sIban: String): boolean;
function calcIBAN_DE(const sBlz, sKto: String): String;
function getBIC(BLZ_oder_IBAN: string): string;
function getBank(BLZ_oder_IBAN: string): string;

type
  // Salden-Objekt, zur Bestimmung des Endsaldo eines Kontos
  TUmsatz = record
    Datum: TAnfixdate;
    AbschlussBetrag: boolean;
    Betrag: double;
  end;

  TSaldo = class
    Umsatz: array of TUmsatz;
    sorted: boolean;
  protected
    procedure sort;
  public
    constructor Create;
    destructor Destroy; override;
    procedure addUmsatz(bDatum: TAnfixdate; bBetrag: double);
    procedure addAbschluss(bDatum: TAnfixdate; bBetrag: double);
    function Saldo(bDatum: TAnfixdate = ccMaxDate): double;
  end;

  TGeldBetrag = class(TObject)
    Betrag: double;
  end;

  TSteuerSatz = class(TObject)
    Satz: double;
    Netto: boolean;
    NettoWieBrutto: boolean;
  end;

  // MwSt-Objekt zur Datenhaltung und Bestimmung der einzelnen MwSt Summen

type
  TMwstRecord = record
    Satz: double;
    summe: double;
    NettoSumme: double;
    MwStSumme: double;
    Konto: string;
  end;

  TMwSt = class
  protected
    procedure log(titel, msg: string);
  public
    MwSt: array of TMwstRecord;
    constructor Create;
    destructor Destroy; override;
    function add(pSatz, pSumme: double; pKonto: string = ''): integer;
    function count: integer;
    procedure calc(EinzelpreisNetto: boolean);
    procedure clear;
    function Netto: double;
    function Steuer: double;
    function Brutto: double;
  end;

implementation

uses
  math, CareTakerClient, SysUtils,
  WordIndex;

function cPreisRundung(d: double): double;
begin
  (*
    M.MMggGGGG#
    cRauschen = 0.000000001;

    M = Monet�re Stellen
    g = geforderte Genauigkeit der IEEE Finanzdatentypen
    G = Bessere Genauigkeit des OrgaMon
    # = injiziertes Rauschen

    Geforderte Genauigkeit laut IEEE, 4 Stellen NACH den Monit�ren Stellen

    Hintergrund: "Double" stellt zwar eine sehr hohe Rechen-Genauigkeit zur
    Verf�gung, es kann aber 0,075 NICHT darstellen.
    Es kann nur 0,07499999... darstellen, was bei der direkten Betrachtung der
    Zahl sofort auff�llt. W�rde man jedoch mit dieser Zahl weiterrechen k�me man
    dennoch auf ein richtiges Endergebnis, Da zum Beispiel 0,0749999*2 wiederum
    eine gut darstellbare Zahl (0,16) ergibt.
    ABER: Beim einem direkten Runden der (0,075 * 100.0)
    passiert der Fehler, dass nach 0,07 als Ergebnis herauskommt, was
    falsch ist! Richtig ist 0,08

    L�sung: Durch ein k�nstliches Rauschen, das ausserhalb des geforderten
    Genauigkeits-Bereiches liegt, und somit vernachl�ssigt werden kann,
    wird sichergestellt, dass die Rundung gesichert so gelingt wie es
    erwartet wird:
    Im Prinzip verhilft man den Zahlen, die hoffnungslos in der Perioden-
    Darstellung gefangen sind durch einen leichten Schups �ber den Rundungs-Zaun.
    Bei Zahlen die eigentlich den Schups nicht ben�tigt h�tten und
    gerne nicht gesprungen w�ren machen wir einen Fehler, RICHTIG, aber
    dieser liegt ausserhalb der geforderten Genauigkeit, so dass das
    ungerechtfertigte Springen �ber den Zaun mit der geforderten Ungenauigkeit
    gerechtfertigt werden kann.

    Beispiel:

    1.0 + 0.0000001 = 1.0000001 immer noch 1
    1.5 + 0.0000001 = 1.5000001 immer noch 2
    1.49993 + 0.0000001 = 1.4999301 immer noch 1

    Wir verhelfen praktisch der Zahl 0,4Periode9 die
    mathematisch eigentlich nach runden 0 ist �ber die
    Grenze zu 0,5 die nach runden 1 ist!

    entstehender Fehler:

    Wir rechnen ja Zwischenschritte (vor einer Rundung) mit dem mehr
    als ausreichenden double Typ. Hier passiert also kein Fehler,
    wird jedoch gerundet schleussen wir einen konstanten Offset ein, der
    nur einem 100stel der geforderten Genauigkeit entspricht. Also
    akzeptabel und inerhalb eines gegebenen Toleranzbandes.

  *)
  result := round((d + cGeld_Bedeutungslos) * 100.0) / 100.0;
end;

function cPreisRundung(s: string): double; overload;
begin
  result := cPreisRundung(strtodouble(s));
end;

function cNetto(Satz, Wert: double): double;
begin
  result := cPreisRundung(Wert / (1.0 + Satz / 100.0));
end;

function cBrutto(Satz, Wert: double): double;
begin
  result := cPreisRundung(Wert * (1.0 + Satz / 100.0));
end;

function cPercent(Satz, Wert: double): double;
begin
  result := cPreisRundung(Wert * Satz / 100.0);
end;

function cSkonto(Satz, Wert: double): double;
begin
  if (Satz <> 0) then
    result := cPercent(100.0 - Satz, Wert)
  else
    result := Wert;
end;

{ TSaldo }

procedure TSaldo.addAbschluss(bDatum: TAnfixdate; bBetrag: double);
begin
  SetLength(Umsatz, High(Umsatz) + 2);
  with Umsatz[High(Umsatz)] do
  begin
    Datum := bDatum;
    Betrag := bBetrag;
    AbschlussBetrag := true;
  end;
  sorted := false;
end;

procedure TSaldo.addUmsatz(bDatum: TAnfixdate; bBetrag: double);
begin
  SetLength(Umsatz, High(Umsatz) + 2);
  with Umsatz[High(Umsatz)] do
  begin
    Datum := bDatum;
    Betrag := bBetrag;
    AbschlussBetrag := false;
  end;
  sorted := false;
end;

constructor TSaldo.Create;
begin

end;

destructor TSaldo.Destroy;
begin

  inherited;
end;

function TSaldo.Saldo(bDatum: TAnfixdate = ccMaxDate): double;
var
  n: integer;
begin
  sort;
  result := 0;
  for n := High(Umsatz) downto 0 do
    with Umsatz[n] do
    begin
      if (Datum < bDatum) then
      begin
        result := result + Betrag;
        if AbschlussBetrag then
          break;
      end;
    end;
end;

procedure TSaldo.sort;

  function SwapIfWrong(i, j: integer): boolean;
  var
    tmp: TUmsatz;
  begin
    result := (Umsatz[i].Datum > Umsatz[j].Datum) or
      ((Umsatz[i].Datum = Umsatz[j].Datum) and (Umsatz[i].AbschlussBetrag) and
      not(Umsatz[j].AbschlussBetrag));
    if result then
    begin
      tmp := Umsatz[i];
      Umsatz[i] := Umsatz[j];
      Umsatz[j] := tmp;
    end;
  end;

var
  n: integer;
begin
  if not(sorted) then
  begin
    repeat
      sorted := true;
      for n := 1 to High(Umsatz) do
        if SwapIfWrong(n - 1, n) then
          sorted := false;
    until sorted;
  end;
end;

{ TMwSt }

procedure TMwSt.calc(EinzelpreisNetto: boolean);
var
  n: integer;
begin
  for n := 0 to pred(count) do
    with MwSt[n] do
    begin

      // MwSt-Anteil rausrechnen
      if (Satz > 0) then
      begin
        if EinzelpreisNetto then
        begin
          NettoSumme := summe;
          MwStSumme := cPreisRundung(summe * (Satz / 100.0));
        end
        else
        begin
          NettoSumme := cPreisRundung(summe / (1.0 + Satz / 100.0));
          MwStSumme := summe - NettoSumme;
        end;
      end
      else
      begin
        NettoSumme := summe;
        MwStSumme := cGeld_Zero;
      end;

      // Info
      log(cINFOText, format('Konto %s;%.1f;%.3f;%.3f;%.3f', [Konto, Satz, summe, NettoSumme,
        MwStSumme]));

    end;
end;

procedure TMwSt.clear;
begin
  SetLength(MwSt, 0);
end;

function TMwSt.count: integer;
begin
  result := succ(High(MwSt));
end;

constructor TMwSt.Create;
begin
  clear;
end;

destructor TMwSt.Destroy;
begin
  clear;
  inherited;
end;

procedure TMwSt.log(titel, msg: string);
begin

end;

function TMwSt.Netto: double;
var
  n: integer;
begin
  result := cGeld_Zero;
  for n := 0 to pred(count) do
    result := result + MwSt[n].NettoSumme;
end;

function TMwSt.Steuer: double;
var
  n: integer;
begin
  result := cGeld_Zero;
  for n := 0 to pred(count) do
    result := result + MwSt[n].MwStSumme;
end;

function TMwSt.Brutto: double;
var
  n: integer;
begin
  result := cGeld_Zero;
  for n := 0 to pred(count) do
    result := result + MwSt[n].MwStSumme + MwSt[n].NettoSumme;
end;

function TMwSt.add(pSatz, pSumme: double; pKonto: string): integer;
var
  n: integer;
  MwStFound: boolean;
begin
  result := -1;
  if (pSumme <> 0.0) then
  begin

    // Konto-Buchung erzwingen!
    pKonto := noblank(pKonto);
    if (pKonto = '') then
      pKonto := cKonto_FreierErloes; // einfach nur "Erl�se!"

    // Suche den entsprechenden Satz
    MwStFound := false;
    for n := 0 to pred(count) do
      with MwSt[n] do
        if (pSatz = Satz) and (pKonto = Konto) then
        begin
          result := n;
          summe := summe + pSumme;
          MwStFound := true;
          break;
        end;

    // Gruppe neu anlegen!
    if not(MwStFound) then
    begin
      SetLength(MwSt, succ(count));
      result := pred(count);
      with MwSt[result] do
      begin
        Satz := pSatz;
        summe := pSumme;
        Konto := pKonto;
        NettoSumme := 0.0;
        MwStSumme := 0.0;
      end;
    end;

  end;
end;

function isZeroMoney(Betrag: double): boolean;
begin
  result := cPreisRundung(Betrag) = cGeld_Zero;
end;

function isSomeMoney(Betrag: double): boolean;
begin
  result := not(isZeroMoney(Betrag));
end;

function isNoMoney(Betrag: double): boolean; // = cGeld_KeinElement
begin
  result := (Betrag + cGeld_Bedeutungslos >= cGeld_KeinElement) and
    (Betrag - cGeld_Bedeutungslos <= cGeld_KeinElement);
end;

function cAbschreiben(var GesamtVolumen, AbschreibeMenge: double): double;
// Abgeschrieben
var
  Verminderung: double;
begin
  Verminderung := min(GesamtVolumen, AbschreibeMenge);
  GesamtVolumen := GesamtVolumen - Verminderung;
  AbschreibeMenge := AbschreibeMenge - Verminderung;
  result := Verminderung;
end;

function isSoll(Betrag: double): boolean;
begin
  result := (cPreisRundung(Betrag) <= -cGeld_KleinsterBetrag);
end;

function isHaben(Betrag: double): boolean;
begin
  result := (cPreisRundung(Betrag) >= cGeld_KleinsterBetrag);
end;

function isEqual(Betrag1, Betrag2: double): boolean;
begin
  result := isZeroMoney(cPreisRundung(Betrag1) - cPreisRundung(Betrag2));
end;

function isOther(Betrag1, Betrag2: double): boolean;
begin
  result := not(isEqual(Betrag1, Betrag2));
end;

function cCent(Betrag: double): int64;
begin
  result := round(cPreisRundung(Betrag) * 100);
end;

// BLZ Sachen

var
  sBLZs: TSearchStringList = nil;

procedure ensureBLZ;
begin
  if not(assigned(sBLZs)) then
  begin
    sBLZs := TSearchStringList.Create;
    if (iSystemPath <> '') then
    begin
      dir(iSystemPath + '\BLZ_*.txt', sBLZs, false);
      if (sBLZs.count > 0) then
      begin
        sBLZs.sort;
        sBLZs.LoadFromFile(iSystemPath + '\' + sBLZs[pred(sBLZs.count)]);
      end;
    end;
  end;

end;

function checkAccount(BLZ, Konto, Name: string; sDiagnose: TStrings): boolean;

  procedure log(s: string);
  begin
    if assigned(sDiagnose) then
      sDiagnose.add(s);
  end;

var
  i: integer;
  NameLautBundesBank: string;

begin
  result := false;

  BLZ := StrFilter(BLZ, cZiffern);
  Konto := StrFilter(Konto, cZiffern);

  repeat

    if (BLZ = '') then
    begin
      log('ERROR: Die BLZ ist leer!');
      break;
    end;

    if (Konto = '') then
    begin
      log('ERROR: Die Kontonummer ist leer!');
      break;
    end;

    //
    if (length(BLZ) <> 8) then
    begin
      log('ERROR: BLZ sollte 8 Stellen haben!');
      break;
    end;

    //
    if (length(Konto) < 3) then
    begin
      log('ERROR: Kontonummer sollte zumindest 3 Stellen haben!');
      break;
    end;

    //
    if (length(Konto) > 10) then
    begin
      log('ERROR: Kontonummer sollte maximal 10 Stellen haben!');
      break;
    end;

    //
    ensureBLZ;

    //
    NameLautBundesBank := '';
    if (sBLZs.count > 0) then
    begin
      i := sBLZs.findinc(BLZ);
      if (i <> -1) then
      begin
        NameLautBundesBank := cutblank(copy(sBLZs[i], 10, 58));
      end
      else
      begin
        log('ERROR: Die BLZ ist der Bundesbank nicht bekannt!');
        break;
      end;
    end
    else
    begin
      log('WARNING: Es liegt keine BLZ_ Datei im System-Verzeichnis vor!');
    end;

    //
    if (NameLautBundesBank <> '') then
      if (AnsiUpperCase(Name) <> AnsiUpperCase(NameLautBundesBank)) then
        log('WARNING: Der Name der Bank sollte "' + NameLautBundesBank + '" sein, ist aber "' +
          Name + '"!');

    result := true;
  until true;

end;

// Pr�fung einer IBAN auf formale Korrektheit (ohne Pr�fung der G�ltigkeit des L�nderk�rzels)
// Autor: Dr. Michael Schramm
function checkIBAN(const sIban: String): boolean;
var
  k, n, rest: integer;
  c: char;
begin
  result := false;
  n := length(sIban);
  if (n < 5) or (n > 34) then
    exit;
  rest := 0;
  k := 5;
  repeat // Zeichen der IBAN in ge�nderter Reihenfolge per Modulo-97 pr�fen
    c := sIban[k];
    case c of
      '0' .. '9':
        rest := (rest * 10 + ord(c) - 48) mod 97; // Ziffer als solche einbeziehen
      'A' .. 'Z':
        rest := (rest * 100 + ord(c) - 55) mod 97 // 'A' wie '10, 'B' wie '11' usw.
    else
      exit
    end;
    inc(k);
    if (k > n) then
      k := 1;
  until (k = 5);
  result := (rest = 1)
end;

// IBAN f�r deutsches Konto aus BLZ und Kontonummer konstruieren
// Autor: Dr. Michael Schramm
function calcIBAN_DE(const sBlz, sKto: String): String;
var
  k, i: integer;
  sK, s: String;
begin
  result := '';
  k := length(sKto);
  if (k = 0) or (k > 10) or (length(sBlz) <> 8) then
    exit;
  if k = 10 then
    sK := sKto
  else
    sK := stringOfChar('0', 10 - k) + sKto;
  s := sBlz + sK + '131400'; // "D" "E" "*"
  i := 0;
  for k := 1 to 24 do
  begin
    i := (10 * i + ord(s[k]) - 48) mod 97;
  end;
  s := intToStr(98 - i);
  if length(s) = 1 then
    s := '0' + s;
  result := 'DE' + s + sBlz + sK
end;

function getBIC(BLZ_oder_IBAN: string): string;
var
  BLZ: string;
  i: integer;
begin
  if (pos('DE', blz_oder_IBAN) = 1) then
    BLZ := copy(blz_oder_IBAN, 5, 6)
  else
    BLZ := blz_oder_IBAN;
  ensureBLZ;
  i := sBLZs.findinc(BLZ);
  if (i <> -1) then
    result := copy(sBLZs[i], 140, 11)
  else
    result := '';
end;

function getBank(BLZ_oder_IBAN: string): string;
var
  sDir: TStringList;
  i: integer;
  BLZ: string;
begin
  if (pos('DE', blz_oder_IBAN) = 1) then
    BLZ := copy(blz_oder_IBAN, 5, 6)
  else
    BLZ := blz_oder_IBAN;
  ensureBLZ;
  i := sBLZs.findinc(BLZ);
  if (i <> -1) then
    result := cutblank(copy(sBLZs[i], 10, 58))
  else
    result := '';
end;

function StrToMoney(x: string): double; // strto
begin
  result := strtodouble(x);
end;

function StrToMoneyDef(x: string; d: double = cGeld_Zero): double;
begin
  result := StrToDoubleDef(x, d);
end;

function MoneyToStr(d: double): string;
begin
  result := format('%m', [d]);
end;

function MoneyAsObject(Wert: double): TObject;
begin
  result := TObject(integer(round(Wert * 100.0)));
end;

function ObjectAsMoney(Wert: TObject): double;
begin
  result := integer(Wert);
  result := result / 100.0;
end;

function MoneyAsCent(Wert: double): integer;
begin
  result := round(Wert * 100.0);
end;

function CentAsMoney(Wert: integer): double;
begin
  result := Wert;
  result := result / 100.0;
end;

end.
