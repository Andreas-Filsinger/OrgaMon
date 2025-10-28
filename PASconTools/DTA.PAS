{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 1995 - 2018  Andreas Filsinger
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
  Datenträgeraustausch zwischen Kunde und Bank
  Zun„chst spezialisiert auf LK =
  Lastschriftverfahren, Lastschrifteinzug
  Info:Kontoinhaber-Ort kann weggelassen werden

  ??.??.95 erste Version für Fa. RMP
  14.02.02 Version für Fa. Pünktlich
  Umgestellt auf EURO
  19.03.02 CSV so erzeugt, dass ein Doppelklick genügt
  14.02.05 Integration in den OrgaMon
  30.05.06 Fehlermeldungen sind jetzt abrufbar
  08.01.07 Unplausible Daten werden nicht geschrieben!
  04.01.08 Salden-Objekt
  19.03.08 UTF-8 Codierung der CSV
  29.07.14 SEPA Codierung der CSV
  30.04.15 SEPA COR1 xml (Informations-Sammlung)
  22.11.16 SEPA COR1 xml (erste .xml Datei)

}

{ SEPA-COR1-Beispiel

 <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
 <Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.008.003.02" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:iso:std:iso:20022:tech:xsd:pain.008.003.02 pain.008.003.02.xsd">
  <CstmrDrctDbtInitn>
   <GrpHdr>
    <MsgId>2015-05-08T16:30:44:0389</MsgId>
    <CreDtTm>2015-05-08T16:30:44</CreDtTm>
    <NbOfTxs>1</NbOfTxs>
    <CtrlSum>0.12</CtrlSum>
    <InitgPty><Nm>Andreas und Susanne Filsing</Nm></InitgPty>
   </GrpHdr>
   <PmtInf>
    <PmtInfId>2015-05-08T16:30:44:0389</PmtInfId>
    <PmtMtd>DD</PmtMtd>
    <BtchBookg>true</BtchBookg>
    <NbOfTxs>1</NbOfTxs>
    <CtrlSum>0.12</CtrlSum>
    <PmtTpInf>
     <SvcLvl><Cd>SEPA</Cd></SvcLvl>
     <LclInstrm><Cd>COR1|CORE</Cd></LclInstrm>
     <SeqTp>FRST</SeqTp>
    </PmtTpInf>
    <ReqdColltnDt>1999-01-01</ReqdColltnDt>
    <Cdtr><Nm>Andreas Filsinger</Nm></Cdtr>
    <CdtrAcct>
     <Id><IBAN>DE14660617240000000000</IBAN></Id>
    </CdtrAcct>
    <CdtrAgt><FinInstnId><BIC>GENODE61WGA</BIC></FinInstnId></CdtrAgt>
    <ChrgBr>SLEV</ChrgBr>
    <DrctDbtTxInf>
     <PmtId><EndToEndId>E2E0</EndToEndId></PmtId>
     <InstdAmt Ccy="EUR">0.12</InstdAmt>
     <DrctDbtTx>
      <MndtRltdInf>
       <MndtId>RID123</MndtId>
       <DtOfSgntr>2015-05-08</DtOfSgntr>
       <AmdmntInd>false</AmdmntInd>
      </MndtRltdInf>
      <CdtrSchmeId><Id><PrvtId>
       <Othr>
        <Id>DE70HIB00000200000</Id>
        <SchmeNm><Prtry>SEPA</Prtry></SchmeNm>
       </Othr>
      </PrvtId></Id></CdtrSchmeId>
     </DrctDbtTx>
     <DbtrAgt><FinInstnId><BIC>GENODE61WGA</BIC></FinInstnId></DbtrAgt>
     <Dbtr><Nm>Romeo Filsinger</Nm></Dbtr>
     <DbtrAcct><Id><IBAN>DE02660617240000000000</IBAN></Id></DbtrAcct>
     <RmtInf><Ustrd>SEPA XML Test</Ustrd></RmtInf>
    </DrctDbtTxInf>
   </PmtInf>
  </CstmrDrctDbtInitn>
 </Document>'

}

interface

uses
  classes, anfix;

const
  cDTA_csvSeparator = ';';
  cDTA_DatumAutomatisch = cIllegalDate;
  cDTA_LastschriftPosten_Header =
  { } 'RID' + cDTA_csvSeparator +
  { } 'Name' + cDTA_csvSeparator +
  { } 'Ort' + cDTA_csvSeparator +
  { } 'BLZ' + cDTA_csvSeparator +
  { } 'Konto' + cDTA_csvSeparator +
  { } 'Betrag' + cDTA_csvSeparator +
  { } 'VZ1' + cDTA_csvSeparator +
  { } 'VZ2' + cDTA_csvSeparator +
  { } 'VZ3' + cDTA_csvSeparator +
  { } 'VZ4' + cDTA_csvSeparator +
  { } 'VZ5' + cDTA_csvSeparator +
  { } 'VZ6' + cDTA_csvSeparator +
  { } 'VZ7' + cDTA_csvSeparator +
  { } 'AusfuehrungsDatum' + cDTA_csvSeparator +
  { } 'MandatsDatum';

  cDTA_Umsatz_Header =
  { } 'PosNo' + cDTA_csvSeparator + // *** Veränderlich ***
  { } 'Datum' + cDTA_csvSeparator +
  { } 'Valuta' + cDTA_csvSeparator + // *** Veränderlich ***
  { } 'Betrag' + cDTA_csvSeparator +
  { } 'Waehrung' + cDTA_csvSeparator +
  { } 'Typ' + cDTA_csvSeparator +
  { } 'VorgangID' + cDTA_csvSeparator +
  { } 'VorgangText' + cDTA_csvSeparator +
  { } 'PrimaNota' + cDTA_csvSeparator +
  { } 'VonBLZ' + cDTA_csvSeparator +
  { } 'VonKonto' + cDTA_csvSeparator +
  { } 'VonREF' + cDTA_csvSeparator +
  { } 'VonName1' + cDTA_csvSeparator +
  { } 'VonName2' + cDTA_csvSeparator +
  { } 'Buchungstext1' + cDTA_csvSeparator +
  { } 'Buchungstext2' + cDTA_csvSeparator +
  { } 'Buchungstext3' + cDTA_csvSeparator +
  { } 'Buchungstext4' + cDTA_csvSeparator +
  { } 'Buchungstext5' + cDTA_csvSeparator +
  { } 'Buchungstext6' + cDTA_csvSeparator +
  { } 'Buchungstext7' + cDTA_csvSeparator +
  { } 'MandatsReferenz' + cDTA_csvSeparator +
  { } 'GlaeubigerID' + cDTA_csvSeparator +
  { } 'EndeZuEndeReferenz';

  cDTA_Saldo_Header =
  { } 'Betrag' + cDTA_csvSeparator +
  { } 'Waehrung';

  cDTA_XML_FName = 'COR1.XML';

  // Parameter
  cDTA_LastschriftVerzoegerung: integer = 5;
  cDTA_HTML_Vorlagen_Path : string = '';
  cDTA_XML_Ausgabe_Path : string = '';


type
  // Kopf-Daten: Eigenes Konto
  DtaDataType = record
    RID: integer;
    FName: string; { File-Name }
    BankName: string[27];
    blz: string[8];
    ktonr: string[10];
    KontoInhaberName: string[27];
    KontoInhaberOrt: string[27];
    GlaeubigerID: string[18]; // CRED = Gläubiger-ID
    Lastschrift: boolean;
    AusfuehrungsDatum: TANFixDate; //
  end;

  // EREF+ = Ende-zu-Ende-Referenz, xml: <EndToEndId>
  //
  // Posten-Daten: Fremde Konten die belastet werden
  CSatzType = record
    RID: integer;
    // wird MREF (Mandatsreferenz) ist i.d.R. RID des BUCH oder AUSGANGSRECHNUNG
    blz: string[8];
    ktonr: string[10];
    betrag: real;
    zahlerName: string[27];
    zahlerOrt: string[27];
    VZweck: array [1 .. 7] of string[27]; // SVWZ = Verwendungszweck
    MandatsID: string;
    MandatsDatum: TANFixDate;
    AusfuehrungsDatum: TANFixDate; // Default aus dem Kopf
    // +MandatID: string[27];
  end;

// Lastschrift Funktionen
procedure DtaOpen(header: DtaDataType);
procedure DtaPut(CSatz: CSatzType);
function DtaClose: TStringList;

// Umsatz Funktionen
function DtaUmsatzMD5(UmsatzLine: string): string;

implementation

uses
  SysUtils, Geld, html,
  OrientationConvert, DCPcrypt2, dcpmd5;
//


var

  { Prüf-Summen }
  DtaEC: LongInt;
  DtaEBetrag: real;
  DtaEKtoNr: Comp;
  DtaEblz: Comp;

  { Konto-Inhaber }
  DTAInhaber: DtaDataType;

  { für XML }
  DatensammlerGlobal: TStringList;
  DatensammlerLokal: TStringList;

const
  NumSet: set of Ansichar = ['0' .. '9'];
  AlphaSet: set of Ansichar = ['0' .. '9', 'A' .. 'Z', ' ', '.', ',', '&', '-', '+', '*', '%', '/',
    '$', 'Ä', 'Ö', 'Ü', 'ß'];
  AlphaSetSEPA: set of Ansichar = ['0' .. '9', 'a' .. 'z', 'A' .. 'Z', ' ', '/', '?', ':', '(', ')',
    '.', ',', '''', '+', '-'];

  (*
  AlphaSetXML: set of WideChar = [
   { } '0' .. '9',
   { } 'A' .. 'Z',
   { } 'a' .. 'z',
   { } 'Ä', 'ä', 'Ö', 'ö', 'Ü', 'ü', 'ß',
   { } ' ', '''', ':', '?', '-', '(', '+', '.', ')', '/', '&', '*', ',', '$', '%' ];
   *)
   cAlphaSetXML = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜabcdefghijklmnopqrstuvwxyzäöüß '':?-(+.)/&*,$%';
  {
    ANSI-, UTF-8-, DTA- Kodierungen, SEPA
    'Ä' 0x8E -> 0xC3,0x84 -> '[' 0x5B -> AE
    'Ö' 0x99 -> 0xC3,0x96 -> '\' 0x5C -> OE
    'Ü' 0x9A -> 0xC3,0x9C -> ']' 0x5D -> UE
    'ß' 0xE1 -> 0xC3,0x9F -> '~' 0x7E -> SZ
    '&' -> '&' -> 'UND'
    '$' -> '$' -> 'DOLLAR'

  }

  UmlautAnsi: string[4] = 'ÄÖÜß';
  UmlautDTA: string[4] = '[\]~';
  cUTF8Prefix = #$C3;
  UmlautUTF8: string[4] = #$84#$96#$9C#$9F;
  sLog: TStringList = nil;
  DtaXMLDoc : THTMLTemplate = nil;

var
  DtaDatei: file of Ansichar;
  DtaData: DtaDataType;
  DtaListeRAW: TextFile; // DTA Zeichensatz
  DtaListeAnsi: TextFile; // ANSI Zeichensatz
  DtaListeUTF8: TextFile; // UTF8 Zeichensatz
  DtaListeSEPA: TextFile; // SEPA Zeichensatz

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
    if not(InStr[i] in AlphaSet) then
      InStr[i] := ' ';
    k := pos(InStr[i], UmlautAnsi);
    if (k > 0) then
      InStr[i] := UmlautDTA[k];
  end;
  result := InStr;
end;

function Ansi2UTF8(InStr: string): string;
var
  i: integer;
begin
  result := InStr;
  for i := 1 to 4 do
    ersetze(UmlautAnsi[i], cUTF8Prefix + UmlautUTF8[i], result);
end;

function Ansi2SEPA(InStr: string): string;
begin
  result := InStr;
  ersetze('Ä', 'AE', result);
  ersetze('Ö', 'OE', result);
  ersetze('Ü', 'UE', result);
  ersetze('ß', 'SZ', result);
  ersetze('&', 'UND', result);
  ersetze('$', 'DOLLAR', result);
  result := StrFilter(result, AlphaSetSEPA + [';']);
end;

function ValidNum(InStr: string): string;
var
  i: byte;
begin
  for i := 1 to length(InStr) do
    if not CharInSet(InStr[i], NumSet) then
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
  Count_LeererVerwendungszweck: integer;
begin
  result := true;
  with CSatz do
  begin

    { BLZ }
    blz := noblank(ValidNum(blz));
    if (length(blz) <> 8) then
    begin
      result := false;
      LogMessage('ERROR: (RID=' + inttostr(RID) + ') BLZ "' + blz + '" bei ' + zahlerName +
        ' falsch');
    end;

    ktonr := noblank(ValidNum(ktonr));
    ktonr := fill('0', 10 - length(ktonr)) + ktonr;

    { Betrag }
    if (betrag <= 0.0) then
    begin
      result := false;
      LogMessage('ERROR: (RID=' + inttostr(RID) + ') Betrag bei ' + zahlerName + ' ist <=0');
    end;

    zahlerName := Ansi2DTA(cutblank(AnsiUpperCase(zahlerName)));
    zahlerName := zahlerName + fill(' ', 27 - length(zahlerName));

    zahlerOrt := Ansi2DTA(cutblank(AnsiUpperCase(zahlerOrt)));
    zahlerOrt := zahlerOrt + fill(' ', 27 - length(zahlerOrt));

    Count_LeererVerwendungszweck := 0;
    for nr := 1 to 7 do
    begin
      VZweck[nr] := Ansi2DTA(cutblank(AnsiUpperCase(VZweck[nr])));
      VZweck[nr] := VZweck[nr] + fill(' ', 27 - length(VZweck[nr]));
      if (cutblank(VZweck[nr]) = '') then
        inc(Count_LeererVerwendungszweck);
    end;

    { Verwendungszweck }
    if (Count_LeererVerwendungszweck = 7) then
    begin
      result := false;
      LogMessage('ERROR: (RID=' + inttostr(RID) + ') kein Verwendungszweck angegeben bei ' +
        zahlerName);
    end;

    { Datum }
    if (MandatsDatum = cIllegalDate) then
      MandatsDatum := DateGet;

    if (AusfuehrungsDatum = cIllegalDate) then
      AusfuehrungsDatum := DTAInhaber.AusfuehrungsDatum;

  end;
end;

function RealToDta(r: real; Size: byte): string;
var
  hstr: string;
begin
  str(r: Size + 2: 2, hstr);
  hstr := noblank(hstr);
  ersetze('.', '', hstr);
  RealToDta := fill('0', Size - length(hstr)) + hstr;
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
  hstr := hstr + fill('0', succ(Komma) - length(hstr));
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

    { Verschiedene Ausprägungen der Datei }
    assignFile(DtaListeAnsi, FName + '.CSV');
    rewrite(DtaListeAnsi);
    assignFile(DtaListeUTF8, FName + '.UTF-8.csv');
    rewrite(DtaListeUTF8);
    assignFile(DtaListeRAW, FName + '.raw.csv');
    rewrite(DtaListeRAW);
    assignFile(DtaListeSEPA, FName + '.SEPA.csv');
    rewrite(DtaListeSEPA);

    writeln(DtaListeAnsi, cDTA_LastschriftPosten_Header);
    writeln(DtaListeUTF8, cDTA_LastschriftPosten_Header);
    writeln(DtaListeRAW, cDTA_LastschriftPosten_Header);
    writeln(DtaListeSEPA, cDTA_LastschriftPosten_Header);

    if (cDTA_HTML_Vorlagen_Path<>'') then
     if FileExists(cDTA_HTML_Vorlagen_Path + cDTA_XML_FName) then
     begin
       DtaXMLDoc := THTMLTemplate.create;
       DtaXMLDoc.LoadFromFile(cDTA_HTML_Vorlagen_Path + cDTA_XML_FName);
       DatensammlerGlobal := TStringList.create;
       DatensammlerGlobal.add('save&delete POSTEN');
       DatensammlerLokal := TStringList.create;
     end;

    { Schreibe Datensatz A }
    if Lastschrift then
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
    WriteData(fill(' ', 8)); { Ausführungsdatum }
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
  TxtExtension: array [1 .. 6] of TxtExtensionType;
  Extension: byte;
  VZCount: byte;
  hstr: string[27];
  sAusgabe: string;
  sBetrag: string;
  Count: byte;
  WriteAnz: byte;
  n : integer;

begin

  { Überprüfung des Satzes }
  if ValidCSatz(CSatz) then
  begin

    { Ausgabe }
    with CSatz do
    begin

      sBetrag := StrFilter(rtostr(betrag, 13, 2), '0123456789,');
      sAusgabe :=
      { } inttostr(RID) + cDTA_csvSeparator +
      { } '"' + cutblank(zahlerName) + '"' + cDTA_csvSeparator +
      { } '"' + cutblank(zahlerOrt) + '"' + cDTA_csvSeparator +
      { } blz + cDTA_csvSeparator +
      { } ktonr + cDTA_csvSeparator +
      { } sBetrag + cDTA_csvSeparator +
      { } '"' + cutblank(VZweck[1]) + '"' + cDTA_csvSeparator +
      { } '"' + cutblank(VZweck[2]) + '"' + cDTA_csvSeparator +
      { } '"' + cutblank(VZweck[3]) + '"' + cDTA_csvSeparator +
      { } '"' + cutblank(VZweck[4]) + '"' + cDTA_csvSeparator +
      { } '"' + cutblank(VZweck[5]) + '"' + cDTA_csvSeparator +
      { } '"' + cutblank(VZweck[6]) + '"' + cDTA_csvSeparator +
      { } '"' + cutblank(VZweck[7]) + '"' + cDTA_csvSeparator +
      { } long2dateLog(AusfuehrungsDatum) + cDTA_csvSeparator +
      { } long2dateLog(MandatsDatum);

      writeln(DtaListeRAW, sAusgabe);
      writeln(DtaListeAnsi, DTA2Ansi(sAusgabe));
      writeln(DtaListeUTF8, Ansi2UTF8(DTA2Ansi(sAusgabe)));
      writeln(DtaListeSEPA, Ansi2SEPA(DTA2Ansi(sAusgabe)));
    end;

    { Kontroll Summen }
    DtaEblz := DtaEblz + StrToComp(CSatz.blz);
    DtaEKtoNr := DtaEKtoNr + StrToComp(CSatz.ktonr);
    DtaEBetrag := DtaEBetrag + CSatz.betrag;
    inc(DtaEC);

    { Bestimmen der Satzanzahl }
    Extension := 0;
    if noblank(CSatz.zahlerOrt) <> '' then
    begin
      inc(Extension);
      with TxtExtension[Extension] do
      begin
        Typ := '01';
        Txt := CSatz.zahlerOrt;
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

    WriteData(CSatz.ktonr);
    WriteData(fill('0', 13));
    if DTAInhaber.Lastschrift then
      WriteData('05000')
    else
      WriteData('51000');

    WriteData(' ');
    WriteData(fill('0', 11));

    WriteData(DtaData.blz);

    WriteData(DtaData.ktonr);
    WriteData(RealToDta(CSatz.betrag, 11));
    WriteData(fill(' ', 3));
    WriteData(CSatz.zahlerName);
    WriteData(fill(' ', 8));

    WriteData(DtaData.KontoInhaberName);
    WriteData(CSatz.VZweck[1]);
    WriteData('1');
    WriteData(fill(' ', 2));

    str(Extension, hstr);
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
        with TxtExtension[Count] do
          WriteData(Typ + Txt);

      if (Count = 2) then
        WriteData(fill(' ', 11));
      if (Count = 6) then
        WriteData(fill(' ', 12));
    end;

    if (assigned(DtaXMLDoc)) then
    begin
      with CSatz, DatensammlerLokal do
      begin
        add('load POSTEN');
        add('EndeZuEndeReferenz='+inttostr(RID));
        add('Name=' + StrFilter(cutblank(zahlerName),cAlphaSetXML));
        add('IBAN='+calcIBAN_DE(blz,ktonr ) );
        add('Betrag='+FloatToStrISO(betrag));
        sAusgabe := cutblank(VZweck[1]);
        for n := 2 to 7 do
         if (cutblank(VZweck[n])<>'') then
           sAusgabe := sAusgabe + '/+/' + cutblank(VZweck[n]);
        ersetze('  ',' ',sAusgabe);
        add('VZ='+StrFilter(sAusgabe,cAlphaSetXML));
        add('MandatsDatum='+Long2Date(Mandatsdatum));
        add('RID='+StrFilter(MandatsID,cAlphaSetXML));
        add('Einreicher.ID=' + DtaData.GlaeubigerID);
      end;
    end;

  end;
end;

function DtaClose: TStringList;
var
  hstr: string[17];
  BerichtF: TextFile;
  OutFileName : string;
  WorkPath : string;
begin
  WriteInfo('ANZAHL', inttostr(DtaEC));
  WriteInfo('BETRAG', format('%m', [DtaEBetrag]));
  result := sLog;
  { Schreibe Endsatz }
  WriteData('0128E');
  WriteData(fill(' ', 5));
  str(DtaEC, hstr);
  WriteData(fill('0', 7 - length(hstr)) + hstr);
  WriteData(fill('0', 13));
  WriteData(CompToDta(DtaEKtoNr, 17));
  WriteData(CompToDta(DtaEblz, 17));
  WriteData(RealToDta(DtaEBetrag, 13));
  WriteData(fill(' ', 51));
  closeFile(DtaDatei);
  closeFile(DtaListeAnsi);
  closeFile(DtaListeUTF8);
  closeFile(DtaListeRAW);
  closeFile(DtaListeSEPA);

  // XML
  if (assigned(DtaXMLDoc)) then
  begin
    OutFileName := DtaData.FName + '.xml';
    with DtaData, DatenSammlerGlobal do
    begin
      add('EREIGNIS_R='+ IntToStr(RID));
      add('MOMENT=' + sTimeStamp);
      add('ANZAHL=' + IntToStr(DtaEC));
      add('SUMME=' + FloatToStrISO(DtaEBetrag));
      add('Einreicher.Name=' + StrFilter(cutblank(KontoInhaberName),cAlphaSetXML));
      add('Einreicher.IBAN=' + calcIBAN_DE(blz, ktonr));
      add('AusfuehrungsDatum=' + long2date(Ausfuehrungsdatum));
    end;
    with DtaXMLDoc do
    begin
     // Fill with Values
     WriteValue(DatenSammlerLokal, DatenSammlerGlobal);

     // Save
     SaveToFileCompressed(OutFileName);
    end;
    DatenSammlerLokal.Free;
    DatenSammlerGlobal.Free;
    FreeAndNil(DtaXMLDoc);

    // Check the xml File
    WorkPath := ExtractFilePath(DtaData.FName + '.xml' );
    if not(FileExists(WorkPath+c_ML_SchemaFName)) then
     FileCopy(cDTA_HTML_Vorlagen_Path + 'pain.008.003.02.xsd',WorkPath+c_ML_SchemaFName);
    doConversion(Content_Mode_xsd, DtaData.FName + '.xml', sLog);

  end;

  { Datenträger-Begleitzettel }
  with DtaData do
  begin
    assignFile(BerichtF, FName + '.ini');
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
    writeln(BerichtF, 'Kontroll-Summe Kontonummern : ' + CompToDta(DtaEKtoNr, 17));
    writeln(BerichtF, 'Kontroll-Summe BLZ          : ' + CompToDta(DtaEblz, 17));
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

const
  DtaMD5_UmsatzHeader: TStringList = nil;
  DtaMD5_Blocklist: TStringList = nil;
  DtaMD5_MD5: TDCP_md5 = nil;

function DtaUmsatzMD5(UmsatzLine: string): string;
var
  HashSizeInBytes: integer;
  Hash: array of byte;
  HashS: array of Ansichar;
  n: integer;
begin

  if (DtaMD5_UmsatzHeader = nil) then
  begin
    DtaMD5_UmsatzHeader := split(cDTA_Umsatz_Header);
    DtaMD5_Blocklist := split('PosNo;Valuta');
    DtaMD5_MD5 := TDCP_md5.create(nil);
  end;

  with DtaMD5_MD5 do
  begin
    Init;
    HashSizeInBytes := GetHashSize DIV 8;
    SetLength(Hash, HashSizeInBytes);
    SetLength(HashS, HashSizeInBytes * 2 + 1);

    for n := 0 to pred(DtaMD5_UmsatzHeader.Count) do
      if (DtaMD5_Blocklist.indexof(DtaMD5_UmsatzHeader[n]) = -1) then
        updateStr(nextp(UmsatzLine))
      else
        nextp(UmsatzLine);

    Final(Hash[0]);
    BinToHex(PAnsiChar(Hash), PAnsiChar(HashS), HashSizeInBytes);
    result := AnsiLowerCase(PAnsiChar(HashS));
  end;
end;

end.
