{
  |††††††___                  __  __
  |†††††/ _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |††††| | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |††††| |_| | | | (_| | (_| | |  | | (_) | | | |
  |†††††\___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |†††††††††††††††|___/
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
unit DTA;

{

  Tools zum Disketten-Clearing-Verfahren
  Datentr‰geraustausch zwischen Kunde und Bank
  ZunÑchst spezialisiert auf LK =
  Lastschriftverfahren, Lastschrifteinzug
  Info:Kontoinhaber-Ort kann weggelassen werden

  ??.??.95 erste Version fÅr Fa. RMP
  14.02.02 Version fÅr Fa. PÅnktlich
           Umgestellt auf EURO
  19.03.02 CSV so erzeugt, dass ein Doppelklick genÅgt
  14.02.05 Integration in den OrgaMon
  30.05.06 Fehlermeldungen sind jetzt abrufbar
  08.01.07 Unplausible Daten werden nicht geschrieben!
  04.01.08 Salden-Objekt
  19.03.08 UTF-8 Codierung der CSV

}

interface

uses
  classes, Anfix32;

const
  cDTA_csvSeparator = ';';
  cHeaderLine =
    'RID' + cDTA_csvSeparator +
    'Name' + cDTA_csvSeparator +
    'Ort' + cDTA_csvSeparator +
    'BLZ' + cDTA_csvSeparator +
    'Konto' + cDTA_csvSeparator +
    'Betrag' + cDTA_csvSeparator +
    'VZ1' + cDTA_csvSeparator +
    'VZ2' + cDTA_csvSeparator +
    'VZ3' + cDTA_csvSeparator +
    'VZ4' + cDTA_csvSeparator +
    'VZ5' + cDTA_csvSeparator +
    'VZ6' + cDTA_csvSeparator +
    'VZ7';
  cUmsatzHeader =
    'PosNo;Datum;Valuta;Betrag;Waehrung;Typ;VorgangID;VorgangText;PrimaNota;VonBLZ;VonKonto;VonREF;VonName1;VonName2;Buchungstext1;Buchungstext2;Buchungstext3;Buchungstext4;Buchungstext5;Buchungstext6;Buchungstext7';
  cSaldoHeader =
    'Betrag;Waehrung';
  cFilterPositiveGanzzahl = '0123456789';


type
  // Kopf-Daten: Eigenes Konto
  DtaDataType = record
    FName: string; { File-Name }
    BankName: string[27];
    blz: string[8];
    ktonr: string[10];
    KontoInhaberName: string[27];
    KontoInhaberOrt: string[27];
    Lastschrift: boolean;
  end;

  // Posten-Daten: Fremde Konten die belastet werden
  CSatzType = record
    RID: integer;
    blz: string[8];
    ktonr: string[10];
    betrag: real;
    zahlerName: string[27];
    zahlerOrt: string[27];
    VZweck: array[1..7] of string[27];
  end;

procedure DtaOpen(header: DtaDataType);
procedure DtaPut(CSatz: CSatzType);
function DtaClose: TStringList;

implementation

uses
  SysUtils;

var

 { Pr¸f-Summen }
  DtaEC: LongInt;
  DtaEBetrag: real;
  DtaEKtoNr: Comp;
  DtaEblz: Comp;

 { Konto-Inhaber }
  DTAInhaber: DtaDataType;

const
  NumSet: set of Ansichar = ['0'..'9'];
  AlphaSet: set of Ansichar = ['0'..'9',
    'A'..'Z',
    ' ',
    '.',
    ',',
    '&',
    '-',
    '+',
    '*',
    '%',
    '/',
    '$',
    'ƒ',
    '÷',
    '‹',
    'ﬂ'];


{
  ANSI-, UTF-8-, DTA- Kodierungen
 'ƒ' 0x8E -> 0xC3,0x84 -> '[' 0x5B
 '÷' 0x99 -> 0xC3,0x96 -> '\' 0x5C
 '‹' 0x9A -> 0xC3,0x9C -> ']' 0x5D
 'ﬂ' 0xE1 -> 0xC3,0x9F -> '~' 0x7E

  }

  UmlautAnsi: string[4] = 'ƒ÷‹ﬂ';
  UmlautDTA: string[4] = '[\]~';
  cUTF8Prefix = #$C3;
  UmlautUTF8: string[4] = #$84#$96#$9C#$9F;
  sLog: TStringList = nil;

var
  DtaDatei: file of AnsiChar;
  DtaData: DtaDataType;
  DtaListeRAW: TextFile; // DTA Zeichensatz
  DtaListeAnsi: TextFile; // ANSI Zeichensatz
  DtaListeUTF8 : TextFile; // UTF8 Zeichensatz

function DTA2Ansi(s: AnsiString): string;
var
  b, k: byte;
begin
  for b := 1 to length(s) do
  begin
    k := pos(s[b], UmlautDTA);
    if k > 0 then
      s[b] := UmlautAnsi[k];
  end;
  result := s;
end;

function Ansi2DTA(InStr: AnsiString): string;
var
  i, k: byte;
begin
  for i := 1 to length(InStr) do
  begin
    if not (InStr[i] in AlphaSet) then
      InStr[i] := ' ';
    k := pos(InStr[i], UmlautAnsi);
    if (k > 0) then
      InStr[i] := UmlautDTA[k];
  end;
  result := InStr;
end;

function Ansi2UTF8(InStr: string): string;
var
  i : integer;
begin
  result := InStr;
  for I := 1 to 4 do
    ersetze(UmlautAnsi[i],cUTF8Prefix+UmlautUTF8[i],result);
end;

function ValidNum(InStr: string): string;
var
  i: byte;
begin
  for i := 1 to length(InStr) do
    if not (InStr[i] in NumSet) then
      InStr[i] := ' ';
  result := InStr;
end;

procedure LogMessage(Msg: string);
begin
  sLog.add(Msg);
end;

procedure WriteInfo(Param, sValue: string);
begin
  sLog.add(Param + '=' + sValue);
end;

procedure ValidHeader(var header: DtaDataType);
begin
  with header do
  begin
    FName := noblank(FName);

    blz := noblank(ValidNum(blz));
    if (length(blz) <> 8) then
      LogMessage('ERROR: Kontoinhaber-BLZ bei ' + KontoInhaberName + ' falsch');


    ktonr := noblank(ValidNum(ktonr));
    ktonr := fill('0', 10 - length(ktonr)) + ktonr;


    BankName := Ansi2DTA(cutblank(AnsiUpperCase(BankName)));
    BankName := BankName + fill(' ', 27 - length(BankName));

    KontoInhaberName := Ansi2DTA(cutblank(AnsiUpperCase(KontoInhaberName)));
    KontoInhaberName := KontoInhaberName + fill(' ', 27 - length(KontoInhaberName));

    KontoInhaberOrt := Ansi2DTA(cutblank(AnsiUpperCase(KontoInhaberOrt)));
    KontoInhaberOrt := KontoInhaberOrt + fill(' ', 27 - length(KontoInhaberOrt));
  end;
end;

function ValidCSatz(var CSatz: CSatzType): boolean;
var
  nr: byte;
  Count_LeererVerwendungszweck: Integer;
begin
  result := true;
  with CSatz do
  begin

    { BLZ }
    blz := noblank(ValidNum(blz));
    if (length(blz) <> 8) then
    begin
      result := false;
      Logmessage('ERROR: (RID=' + inttostr(RID) + ') BLZ "' + blz + '" bei ' + ZahlerName + ' falsch');
    end;

    ktonr := noblank(ValidNum(ktonr));
    ktonr := fill('0', 10 - length(ktonr)) + ktonr;

    { Betrag }
    if (betrag <= 0.0) then
    begin
      result := false;
      Logmessage('ERROR: (RID=' + inttostr(RID) + ') Betrag bei ' + ZahlerName + ' ist <=0');
    end;

    ZahlerName := Ansi2DTA(cutblank(AnsiUpperCase(ZahlerName)));
    ZahlerName := ZahlerName + fill(' ', 27 - length(ZahlerName));

    ZahlerOrt := Ansi2DTA(cutblank(AnsiUpperCase(ZahlerOrt)));
    ZahlerOrt := ZahlerOrt + fill(' ', 27 - length(ZahlerOrt));

    Count_LeererVerwendungszweck := 0;
    for nr := 1 to 7 do
    begin
      VZweck[nr] := Ansi2DTA(cutblank(AnsiUpperCase(VZweck[nr])));
      VZweck[nr] := VZweck[nr] + fill(' ', 27 - length(VZweck[nr]));
      if (cutblank(VZweck[nr])='') then
        inc(Count_LeererVerwendungszweck);
    end;

    { Verwendungszweck }
    if (Count_LeererVerwendungszweck=7) then
    begin
      result := false;
      Logmessage('ERROR: (RID=' + inttostr(RID) + ') kein Verwendungszweck angegeben bei ' + ZahlerName );
    end;

  end;
end;

function RealToDta(r: real; Size: byte): string;
var
  hstr: string;
begin
  str(r: size + 2: 2, hstr);
  hstr := noblank(hstr);
  ersetze('.', '', hstr);
  RealToDta := fill('0', size - length(hstr)) + hstr;
end;

function CompToDta(c: Comp; Size: byte): string;
var
  hstr: string;
  Komma: byte;
  dummy: integer;
begin
  str(c, hstr);
  val(copy(hstr, 22, 2), Komma, dummy);
  ersetze('.', '', hstr);
  hstr := noblank(copy(hstr, 1, 16));
  while (length(hstr) > 1) and (hstr[length(hstr)] = '0') do
    delete(hstr, length(hstr), 1);
  hstr := hstr + fill('0', succ(komma) - length(hstr));
  hstr := fill('0', Size - length(hstr)) + hstr;
  CompToDta := hstr;
end;

function StrToComp(NrStr: string): Comp;
var
  co: Comp;
  dummy: integer;
begin
  val(noblank(NrStr), co, dummy);
  StrToComp := co;
end;

procedure WriteData(OutStr: AnsiString);
var
  i: byte;
begin
  for i := 1 to length(OutStr) do
    write(DtaDatei, OutStr[i]);
end;

procedure DtaOpen(header: DtaDataType);
var
  hstr: string;
begin
  // Log vorbereiten
  if assigned(sLog) then
    sLog.clear
  else
    sLog := TStringList.create;
  // Header verarbeiten
  DtaData := header;
  ValidHeader(DtaData);
  with DtaData do
  begin
    { DTA Datei an sich }
    assignFile(DtaDatei, FName);
    rewrite(DtaDatei);

    { "LOG" Datei fÅr die Ablage }
    assignFile(DtaListeAnsi, FName + '.CSV');
    rewrite(DtaListeAnsi);
    assignFile(DtaListeUTF8, FName + '.UTF-8.csv');
    rewrite(DtaListeUTF8);
    assignFile(DtaListeRAW, FName + '.raw.csv');
    rewrite(DtaListeRAW);


    writeln(DtaListeAnsi, cHeaderLine);
    writeln(DtaListeUTF8,cHeaderLine);
    writeln(DtaListeRAW,cHeaderLine);

    { Schreibe Datensatz A }
    if LastSchrift then
      WriteData('0128ALK')
    else
      WriteData('0128AGK');

    WriteData(blz);
    WriteData(fill('0', 8));
    WriteData(KontoInhaberName);
    hstr := datum;
    ersetze('.', '', hstr);
    WriteData(hstr);
    WriteData(fill(' ', 4));
    WriteData(ktonr);
    WriteData(fill('0', 10));
    WriteData(fill(' ', 15));
    WriteData(fill(' ', 8)); { Ausf¸hrungsdatum }
    WriteData(fill(' ', 24));
    WriteData('1'); { EURO }
  end;
  DtaEC := 0;
  DtaEBetrag := 0.0;
  DtaEKtoNr := 0;
  DtaEblz := 0;
  DTAInhaber := DtaData;
end;

procedure DtaPut(CSatz: CSatzType);

type
  TxtExtensionType = record
    Typ: string[2];
    Txt: string[27];
  end;


  var
  TxtExtension: array[1..6] of TxtExtensionType;
  Extension: byte;
  VZCount: byte;
  hstr: string[27];
  sAusgabe: string;
  Count: byte;
  WriteAnz: byte;

begin

 { ‹berpr¸fung des Satzes }
  if ValidCsatz(CSatz) then
  begin

 { Log - Ausgabe }
    with CSatz do
    begin

      hstr := StrFilter(rtostr(betrag, 13, 2),'0123456789,');
      sAusgabe := inttostr(RID) + cDTA_csvSeparator +
        '"' + cutblank(zahlerName) + '"' + cDTA_csvSeparator +
        '"' + cutblank(zahlerOrt) + '"' + cDTA_csvSeparator +
        blz + cDTA_csvSeparator +
        ktonr + cDTA_csvSeparator +
        hstr + cDTA_csvSeparator +
        '"' + cutblank(VZweck[1]) + '"' + cDTA_csvSeparator +
        '"' + cutblank(VZweck[2]) + '"' + cDTA_csvSeparator +
        '"' + cutblank(VZweck[3]) + '"' + cDTA_csvSeparator +
        '"' + cutblank(VZweck[4]) + '"' + cDTA_csvSeparator +
        '"' + cutblank(VZweck[5]) + '"' + cDTA_csvSeparator +
        '"' + cutblank(VZweck[6]) + '"' + cDTA_csvSeparator +
        '"' + cutblank(VZweck[7]) + '"';

      writeln(DtaListeRAW, sAusgabe);
      writeln(DtaListeAnsi, DTA2Ansi(sAusgabe));
      writeln(DtaListeUTF8, Ansi2UTF8(DTA2Ansi(sAusgabe)));
    end;


 { Kontroll Summen }
    DtaEblz := DtaEblz + StrToComp(CSatz.blz);
    DtaEKtoNr := DtaEKtoNr + StrToComp(CSatz.ktonr);
    DtaEBetrag := DtaEBetrag + CSatz.Betrag;
    inc(DtaEC);

 { Bestimmen der Satzanzahl }
    Extension := 0;
    if noblank(CSatz.zahlerOrt) <> '' then
    begin
      inc(Extension);
      with TxtExtension[Extension] do
      begin
        Typ := '01';
        Txt := CSatz.ZahlerOrt;
      end;
    end;

    for VZCount := 2 to 4 do
    begin
      if noblank(CSatz.VZweck[VZCount]) <> '' then
      begin
        inc(Extension);
        with TxtExtension[Extension] do
        begin
          Typ := '02';
          Txt := CSatz.VZweck[VZCount];
        end;
      end;
    end;

    if noblank(DtaData.KontoInhaberOrt) <> '' then
    begin
      inc(Extension);
      with TxtExtension[Extension] do
      begin
        Typ := '03';
        Txt := DtaData.KontoInhaberOrt;
      end;
    end;

    WriteData('0');
    str((187 + Extension * 29), hstr);
    WriteData(hstr);
    WriteData('C');
    WriteData(DtaData.blz);

    WriteData(CSatz.blz);

    WriteData(CSatz.KtoNr);
    WriteData(Fill('0', 13));
    if DTAInhaber.Lastschrift then
     WriteData('05000')
    else
     WriteData('51000');

    WriteData(' ');
    WriteData(fill('0', 11));

    WriteData(DtaData.blz);

    WriteData(DtaData.KtoNr);
    WriteData(RealToDta(CSatz.Betrag, 11));
    WriteData(fill(' ', 3));
    WriteData(CSatz.ZahlerName);
    WriteData(fill(' ', 8));

    WriteData(DtaData.KontoInhaberName);
    WriteData(CSatz.VZweck[1]);
    WriteData('1');
    WriteData(fill(' ', 2));

    Str(Extension, hstr);
    WriteData('0' + hstr);

    if (Extension > 2) then
      WriteAnz := 6
    else
      WriteAnz := 2;

    for Count := 1 to WriteAnz do
    begin
      if (Count > Extension) then
        WriteData(fill(' ', 29))
      else
        with TXTExtension[Count] do
          WriteData(Typ + Txt);

      if (Count = 2) then
        WriteData(Fill(' ', 11));
      if (Count = 6) then
        WriteData(Fill(' ', 12));
    end;
  end;
end;

function DtaClose: TStringList;
var
  hstr: string[17];
  BerichtF: TextFile;
begin
  WriteInfo('ANZAHL',inttostr(DTAec));
  WriteInfo('BETRAG',format('%m',[DtaEBetrag]));
  result := sLog;
 { Schreibe Endsatz }
  WriteData('0128E');
  WriteData(Fill(' ', 5));
  str(DtaEC, hstr);
  WriteData(Fill('0', 7 - length(hstr)) + hstr);
  WriteData(fill('0', 13));
  WriteData(comptodta(DtaEKtoNr, 17));
  WriteData(comptodta(DtaEblz, 17));
  WriteData(RealToDta(DtaEBetrag, 13));
  WriteData(fill(' ', 51));
  closeFile(DtaDatei);
  closeFile(DtaListeAnsi);
  closeFile(DtaListeUTF8);
  closeFile(DtaListeRAW);

 { DatentrÑger-Begleitzettel }
  with DtaData do
  begin
    assignFile(BerichtF, Fname + '.ini');
    rewrite(BerichtF);

    writeln(BerichtF, '');
    writeln(BerichtF, 'Begleitzettel zum Datentraegeraustausch');
    writeln(BerichtF, '=======================================');
    writeln(BerichtF, '');
    writeln(BerichtF, 'Datei                       : DTAUS.DTA');
    if Lastschrift then
    writeln(BerichtF, 'Einziehungsauftrag LK       : JA ')
    else
    writeln(BerichtF, 'Sammelueberweisung GK       : JA ');
    writeln(BerichtF, 'Erstellungsdatum            : ' + datum);
    writeln(BerichtF, '');

    str(DtaEC, hstr);
    writeln(BerichtF, 'Anzahl der Datensaetze "C"  : ' + hstr);
    writeln(BerichtF, 'Summe EURO                  : ' + RealToDta(DtaEBetrag, 17) + ' CENT');
    writeln(BerichtF, 'Kontroll-Summe Kontonummern : ' + comptodta(DtaEKtoNr, 17));
    writeln(BerichtF, 'Kontroll-Summe BLZ          : ' + comptodta(DtaEblz, 17));
    writeln(BerichtF, '');
    writeln(BerichtF, 'Name der Bank               : ' + DTA2Ansi(BankName));
    writeln(BerichtF, 'BLZ                         : ' + blz);
    writeln(BerichtF, 'Konto-Nummer                : ' + ktonr);
    writeln(BerichtF, 'Auftraggeber                : ' + DTA2Ansi(KontoInhaberName));
    writeln(BerichtF, '');
    writeln(BerichtF, '');
    writeln(BerichtF, '_____________________________________________________');
    writeln(BerichtF, DTA2Ansi(KontoInhaberOrt) + ', ' + datum);
    writeln(BerichtF, '');

    closeFile(BerichtF);
  end;
end;



end.

