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
unit eConnect;

interface

uses
  classes, WordIndex,

  // Pascal Skript
  uPSUtils, uPSCompiler;

type
  TeConnect = class(TObject)
  public
    WebShopClicks: integer;
    sArtikelSuche: TStringList;

    pMonatlichesLog: string;

  public
    function CheckLoadSuchIndex(NameSpace: string): TWordIndex;

    procedure Log(s: string);
    procedure Init;

    function rpc_e_r_ArtikelSuche(sParameter: TStringList): TStringList;
    function rpc_e_r_ArtikelPreis(sParameter: TStringList): TStringList;
    function rpc_e_r_KontoInfo(sParameter: TStringList): TStringList;
    function rpc_e_r_BestellInfo(sParameter: TStringList): TStringList;
    function rpc_e_r_Land(sParameter: TStringList): TStringList;
    function rpc_e_r_ArtikelVersendetag(sParameter: TStringList): TStringList;
    function rpc_e_r_Verlag(sParameter: TStringList): TStringList;
    function rpc_e_r_Versandkosten(sParameter: TStringList): TStringList;
    function rpc_e_r_ArtikelInfo(sParameter: TStringList): TStringList;
    function rpc_e_r_BasePlug(sParameter: TStringList): TStringList;
    function rpc_e_r_ArtikelRabattPreis(sParameter: TStringList): TStringList;
    function rpc_e_r_Ort(sParameter: TStringList): TStringList;
    function rpc_e_r_Rabatt(sParameter: TStringList): TStringList;
    function rpc_e_r_Preis(sParameter: TStringList): TStringList;

    function rpc_e_w_Vormerken(sParameter: TStringList): TStringList;
    function rpc_e_w_Bestellen(sParameter: TStringList): TStringList;
    function rpc_e_w_PersonNeu(sParameter: TStringList): TStringList;
    function rpc_e_w_Miniscore(sParameter: TStringList): TStringList;
    function rpc_e_w_LoginInfo(sParameter: TStringList): TStringList;
    function rpc_e_w_Buchen(sParameter: TStringList): TStringList;
    function rpc_e_w_Skript(sParameter: TStringList): TStringList;
  end;

function _Uses(Sender: TPSPascalCompiler; const Name: tbtString): Boolean;

implementation

uses
  // Delphi
  SysUtils,

  // IBO
  IB_Components, IB_Access,

  // Tools
  anfix32, srvXMLRPC, Geld,
  html, dbOrgaMon,

  // OrgaMon
  globals,
{$IFNDEF CONSOLE}
  Datenbank,
{$ENDIF}
  CareTakerClient,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Buch,
  Funktionen_Auftrag,

  // Pascal Skript
  uPSRuntime,
  // PS "System"
  uPSC_Std, uPSR_Std,

  // PS "Classes"
  uPSC_Classes, uPSR_Classes,

  // PS "TDateTime"
  uPSC_dateutils, uPSR_dateutils,

  // PS "OrgaMon"
  uPSI_Funktionen_Basis,
  uPSI_Funktionen_Beleg,
  uPSI_Funktionen_Buch,
  uPSI_Funktionen_Auftrag,
  uPSI_eConnect;

const
  oCompiler: TPSPascalCompiler = nil;
  oExecute: TPSExec = nil;
  oImporter: TPSRuntimeClassImporter = nil;

function _Uses(Sender: TPSPascalCompiler; const Name: tbtString): Boolean;
begin
  result := true;
  repeat

    if (Name = 'SYSTEM') then
    begin
      // Sender.AddDelphiFunction('procedure HelloOrgaMon(Data: string)');
      RegisterDateTimeLibrary_C(Sender);
      Sender.AddTypeS('TANFIXDATE', 'Longint');
      Sender.AddTypeS('TANFIXTIME', 'Longint');
      Sender.AddTypeS('TDOM_REFERENCE', 'Longint'); // eigentlich int64 !!
      break;
    end;

    if (Name = 'CLASSES') then
    begin
      SIRegister_Std(Sender);
      SIRegister_Classes(Sender, true);
      break;
    end;

    if (Name = 'BASIS') then
    begin
      SIRegister_Funktionen_Basis(Sender);
      break;
    end;

    if (Name = 'BUCH') then
    begin
      SIRegister_Funktionen_Buch(Sender);
      break;
    end;

    if (Name = 'BELEG') then
    begin
      SIRegister_Funktionen_Beleg(Sender);
      break;
    end;

    if (Name = 'AUFTRAG') then
    begin
      SIRegister_Funktionen_Auftrag(Sender);
      break;
    end;

    if (Name = 'CONNECT') then
    begin
      SIRegister_eConnect(Sender);
      break;
    end;

    // Falscher Unit-Name
    result := False;
    Sender.MakeError('', ecUnknownIdentifier, Name);

  until true;
end;

function TeConnect.CheckLoadSuchIndex(NameSpace: string): TWordIndex;
var
  k: integer;
  FName: string;
begin
  //
  result := nil;
  if not(assigned(sArtikelSuche)) then
    sArtikelSuche := TStringList.create;
  k := sArtikelSuche.IndexOf(NameSpace);
  if (k = -1) then
  begin
    FName := SearchDir + format(cArtikelSuchindexFName, [NameSpace]);
    result := TWordIndex.create(nil);

    //
    if Not(FileExists(FName)) then
      srvXMLRPC.Log(cERRORText + ' Suchindex "' + FName + '" nicht gefunden!');

    result.LoadFromFile(FName);
    sArtikelSuche.AddObject(NameSpace, result);
  end
  else
  begin
    result := TWordIndex(sArtikelSuche.Objects[k]);
    result.ReloadIfNew;
  end;
end;

procedure TeConnect.Init;
begin
  pMonatlichesLog := copy(datumLog, 1, 4) + '-' + copy(datumLog, 5, 2);
end;

procedure TeConnect.Log(s: string);
begin
  //
end;

function TeConnect.rpc_e_r_ArtikelInfo(sParameter: TStringList): TStringList;
var
  LAND_R: integer;
  VERLAG_R: integer;
  AUSGABEART_R: integer;
  ARTIKEL_R: integer;
  res_d: double;
  res_s: string;
begin
  result := TStringList.create;
  LAND_R := cRID_unset;
  VERLAG_R := cRID_unset;
  AUSGABEART_R := cRID_unset;
  ARTIKEL_R := cRID_unset;
  res_d := 9.9;
  res_s := '99';

  Inc(WebShopClicks);

  //
  if (sParameter.count > 1) then
    AUSGABEART_R := StrToIntDef(sParameter[1], cRID_unset);
  if (sParameter.count > 2) then
    ARTIKEL_R := StrToIntDef(sParameter[2], cRID_unset);
  if (sParameter.count > 3) then
    LAND_R := StrToIntDef(sParameter[3], cRID_unset);
  if (sParameter.count > 4) then
    VERLAG_R := StrToIntDef(sParameter[4], cRID_unset);

  res_d := e_r_PreisBrutto(AUSGABEART_R, ARTIKEL_R);
  res_s := e_r_ObtainISOfromRID(LAND_R) + '-' + e_r_Verlag(VERLAG_R);

  // Ergebnis übertragen
  with TXMLRPC_Server do
  begin
    result.AddObject(fromDouble(res_d), oDouble);
    result.AddObject(res_s, oString);
  end;

end;

function TeConnect.rpc_e_r_ArtikelPreis(sParameter: TStringList): TStringList;
var
  ARTIKEL_R: integer;
  AUSGABEART_R: integer;
  DieserPreis: double;
begin
  result := TStringList.create;
  DieserPreis := cPreis_Unbekannt;
  ARTIKEL_R := cRID_unset;
  AUSGABEART_R := cRID_unset;
  Inc(WebShopClicks);
  if (sParameter.count > 1) then
    AUSGABEART_R := StrToIntDef(sParameter[1], cRID_Null);
  if (sParameter.count > 2) then
    ARTIKEL_R := StrToIntDef(sParameter[2], cRID_Null);
  DieserPreis := e_r_PreisBrutto(AUSGABEART_R, ARTIKEL_R);

  with TXMLRPC_Server do
  begin
    result.AddObject(fromDouble(DieserPreis), oDouble);
  end;
end;

function TeConnect.rpc_e_r_ArtikelRabattPreis(sParameter: TStringList)
  : TStringList;
var
  AUSGABEART_R: integer;
  ARTIKEL_R: integer;
  PERSON_R: integer;
  pNetto, pNettoWieBrutto: Boolean;
  Preis, Rabatt: double;
begin
  result := TStringList.create;
  AUSGABEART_R := cRID_unset;
  ARTIKEL_R := cRID_unset;
  PERSON_R := cRID_unset;
  Preis := cPreis_ungesetzt;
  Rabatt := 0.0;
  if (sParameter.count > 1) then
    AUSGABEART_R := StrToIntDef(sParameter[1], cRID_Null);
  if (sParameter.count > 2) then
    ARTIKEL_R := StrToIntDef(sParameter[2], cRID_Null);
  if (sParameter.count > 3) then
    PERSON_R := StrToIntDef(sParameter[3], cRID_Null);

  Preis := e_r_PreisBrutto(AUSGABEART_R, ARTIKEL_R);
  if (AUSGABEART_R < cRID_FirstValid) then
    Rabatt := e_r_Rabatt(ARTIKEL_R, PERSON_R, pNetto, pNettoWieBrutto);

  with TXMLRPC_Server do
  begin
    result.AddObject(fromDouble(Preis), oDouble);
    result.AddObject(fromDouble(Rabatt), oDouble);
  end;

end;

function TeConnect.rpc_e_r_ArtikelSuche(sParameter: TStringList): TStringList;
var
  szSent: string;
  SORTIMENT_R: integer;
  n: integer;
  cAKTION: TIB_Cursor;
  MASTER_R: integer;
  ArtikelSuche: TWordIndex;
  _RDTSCmc: int64;
  NameSpace: string;
begin
  result := TStringList.create;
  Inc(WebShopClicks);
  SORTIMENT_R := cRID_unset;
  if (sParameter.count > 0) then
    NameSpace := nextp(sParameter[0], cXML_NameSpaceDelimiter, 0);
  if (sParameter.count > 1) then
    szSent := html2ansi(sParameter[1]);
  if (sParameter.count > 2) then
    SORTIMENT_R := StrToIntDef(sParameter[2], cRID_Null);

  // Suchstring aufbereitung
  if (SORTIMENT_R >= cRID_FirstValid) then
    szSent := szSent + ' ~' + inttostr(SORTIMENT_R) + 'S.';

  // Quelle der Suchanfrage bestimmen
  if (nextp(szSent, ' ', 0) = '_') then
  begin
    szSent := copy(szSent, 3, MaxInt);
    NameSpace := NameSpace + '2';
  end;

  // Suchindex festlegen (wird ggf. neu geladen)
  ArtikelSuche := CheckLoadSuchIndex(NameSpace);

  if (pos('~', szSent) = 1) and (pos('a', szSent) = length(szSent)) then
  begin
    ArtikelSuche.FoundList.clear;
    MASTER_R := e_r_sql('select ARTIKEL_R from AKTION where RID=' + copy(szSent,
      2, length(szSent) - 2));
    cAKTION := nCursor;
    with cAKTION do
    begin
      sql.Add('select ARTIKEL_R from ARTIKEL_MITGLIED where MASTER_R=' +
        inttostr(MASTER_R) + ' order by POSNO');
      ApiFirst;
      while not(eof) do
      begin
        ArtikelSuche.FoundList.Add(pointer(FieldByName('ARTIKEL_R').AsINteger));
        ApiNext;
      end;
    end;
    cAKTION.free;
  end
  else
  begin
    ArtikelSuche.Search(szSent);
    if (pos(c_wi_RID_Suche, szSent) <> 1) then
      e_r_ArtikelSortieren(ArtikelSuche.FoundList);
  end;

  with TXMLRPC_Server do
  begin
    result.AddObject('', oBeginArray);
    for n := 0 to pred(ArtikelSuche.FoundList.count) do
      result.AddObject(fromObject(ArtikelSuche.FoundList[n]), oInteger);
    result.AddObject('', oEndArray);
  end;

  AppendStringsToFile(Datum10 + ';' + // 0
    Uhr8 + ';' + // 1
    szSent + ';' + // 2, Suchanfrage
    inttostr(result.count) + ';' + // Anzahl der Suchtreffer
    inttostr(RDTSCms - _RDTSCmc) // Benötigte Zeit
    , SearchDir + 'Webshop-Suche.' + pMonatlichesLog + '.' + NameSpace
    + '.csv');
end;

function TeConnect.rpc_e_r_ArtikelVersendetag(sParameter: TStringList)
  : TStringList;
var
  AUSGABEART_R: integer;
  ARTIKEL_R: integer;
  m: integer;
begin
  result := TStringList.create;
  AUSGABEART_R := cRID_unset;
  ARTIKEL_R := cRID_unset;
  Inc(WebShopClicks);

  if (sParameter.count > 1) then
    AUSGABEART_R := StrToIntDef(sParameter[1], cRID_Null);
  if (sParameter.count > 2) then
    ARTIKEL_R := StrToIntDef(sParameter[2], cRID_Null);

  m := e_r_ArtikelVersendeTag(AUSGABEART_R, ARTIKEL_R);

  with TXMLRPC_Server do
    result.AddObject(frominteger(m), oInteger);
end;

const
  CacheBasePlug: TStringList = nil;

function TeConnect.rpc_e_r_BasePlug(sParameter: TStringList): TStringList;
begin
  result := TStringList.create;
  if not(assigned(CacheBasePlug)) then
  begin
    CacheBasePlug := e_r_BasePlug;
    if iXMLRPCGeroutet then
      CacheBasePlug.insert(0, 'XMLRPC:' + i_c_DataBaseFName)
    else
      CacheBasePlug.insert(0, iDataBaseName);
    with TXMLRPC_Server do
    begin
      CacheBasePlug.insertObject(0, '', oBeginArray);
      CacheBasePlug.AddObject('', oEndArray);
    end;
  end;
  result.Assign(CacheBasePlug);
end;

function TeConnect.rpc_e_w_Bestellen(sParameter: TStringList): TStringList;
var
  PERSON_R: integer;
  BELEG_R: integer;
begin
  result := TStringList.create;
  Inc(WebShopClicks);
  if (sParameter.count > 1) then
  begin
    PERSON_R := StrToIntDef(sParameter[1], cRID_Null);
    BELEG_R := e_w_BelegNeuAusWarenkorb(PERSON_R);
  end
  else
  begin
    PERSON_R := cRID_unset;
    BELEG_R := cRID_unset;
  end;

  if (BELEG_R >= cRID_FirstValid) then
  begin
    e_w_WarenkorbLeeren(PERSON_R);
    e_w_BerechneBeleg(BELEG_R).free;
  end
  else
  begin
    // Aktuellen Beleg zurückgeben
    BELEG_R := e_r_sql(
      { } 'select max(RID) from BELEG where PERSON_R=' +
      { } inttostr(PERSON_R));
  end;
  with TXMLRPC_Server do
    result.AddObject(frominteger(BELEG_R), oInteger);
end;

function TeConnect.rpc_e_w_Vormerken(sParameter: TStringList): TStringList;
var
  PERSON_R: integer;
  BELEG_R: integer;
begin
  Inc(WebShopClicks);

  result := TStringList.create;

  if (sParameter.count > 1) then
    PERSON_R := StrToIntDef(sParameter[1], cRID_Null)
  else
    PERSON_R := cRID_unset;

  if (PERSON_R >= cRID_FirstValid) then
  begin
    BELEG_R := e_w_GEN('BELEG_GID');

    e_x_sql('insert into EREIGNIS (RID,ART,PERSON_R,INFO) values (' +
      { } '0,' +
      { } inttostr(eT_Vormerken) + ',' +
      { } inttostr(PERSON_R) + ',' +
      { } '''BELEG_R=' + inttostr(BELEG_R) + '''' +
      { } ')');

  end
  else
  begin
    BELEG_R := cRID_unset;
  end;

  // liefere den geplanten Beleg zurück
  with TXMLRPC_Server do
    result.AddObject(frominteger(BELEG_R), oInteger);
end;

function TeConnect.rpc_e_w_Buchen(sParameter: TStringList): TStringList;
var
  BELEG_R: integer;
  PERSON_R: integer;
begin
  result := TStringList.create;

  if (sParameter.count > 1) then
    BELEG_R := StrToIntDef(sParameter[1], cRID_Null)
  else
    BELEG_R := cRID_unset;

  if (sParameter.count > 2) then
    PERSON_R := StrToIntDef(sParameter[2], cRID_Null)
  else
    PERSON_R := cRID_unset;

  with TXMLRPC_Server do
    result.AddObject(frominteger(e_w_buchen(BELEG_R, PERSON_R)), oInteger);

end;

function TeConnect.rpc_e_r_BestellInfo(sParameter: TStringList): TStringList;
var
  PERSON_R: integer;
begin
  result := TStringList.create;
  PERSON_R := cRID_unset;
  Inc(WebShopClicks);
  if (sParameter.count > 1) then
    PERSON_R := StrToIntDef(sParameter[1], cRID_Null);
  with TXMLRPC_Server do
    result.AddObject(frominteger(e_r_BestellInfo(PERSON_R)), oInteger);
end;

function TeConnect.rpc_e_r_KontoInfo(sParameter: TStringList): TStringList;
var
  BetragOffen: double;
  Bericht: TStringList;
  PERSON_R: integer;
begin
  result := TStringList.create;
  BetragOffen := cPreis_Unbekannt;
  PERSON_R := cRID_unset;
  Inc(WebShopClicks);
  if (sParameter.count > 1) then
    PERSON_R := StrToIntDef(sParameter[1], cRID_Null);

  // aktuelle "Mahnung" erstellen
  Bericht := e_w_KontoInfo(PERSON_R);
  Bericht.free;

  // Rückgabewert ist der Kontostand des Kunden
  BetragOffen := -b_r_PersonSaldo(PERSON_R);

  with TXMLRPC_Server do
    result.AddObject(fromDouble(BetragOffen), oDouble);
end;

function TeConnect.rpc_e_r_Land(sParameter: TStringList): TStringList;
var
  LAND_R: integer;
begin
  result := TStringList.create;
  LAND_R := cRID_unset;
  Inc(WebShopClicks);
  if (sParameter.count > 1) then
    LAND_R := StrToIntDef(sParameter[1], cRID_Null);
  with TXMLRPC_Server do
    result.AddObject(e_r_ObtainISOfromRID(LAND_R), oString);
end;

function TeConnect.rpc_e_r_Ort(sParameter: TStringList): TStringList;
var
  PERSON_R: integer;
begin
  result := TStringList.create;
  PERSON_R := cRID_unset;
  if (sParameter.count > 1) then
    PERSON_R := StrToIntDef(sParameter[1], cRID_Null);
  with TXMLRPC_Server do
    result.AddObject(e_r_ort(PERSON_R), oString);
end;

function TeConnect.rpc_e_r_Preis(sParameter: TStringList): TStringList;
var
  ARTIKEL_R: integer;
  AUSGABEART_R: integer;
  PERSON_R: integer;
  Preis: double;
  Rabatt: double;
  Netto: Boolean;
  NettoWieBrutto: Boolean;
begin
  result := TStringList.create;

  Inc(WebShopClicks);
  Netto := False;
  NettoWieBrutto := False;
  Preis := cPreis_Unbekannt;
  Rabatt := 0.0;
  ARTIKEL_R := cRID_unset;
  AUSGABEART_R := cRID_unset;
  PERSON_R := cRID_unset;

  if (sParameter.count > 1) then
    AUSGABEART_R := StrToIntDef(sParameter[1], cRID_Null);
  if (sParameter.count > 2) then
    ARTIKEL_R := StrToIntDef(sParameter[2], cRID_Null);
  if (sParameter.count > 3) then
    PERSON_R := StrToIntDef(sParameter[3], cRID_Null);
  Preis := e_r_PreisBrutto(AUSGABEART_R, ARTIKEL_R);
  Rabatt := e_r_Rabatt(ARTIKEL_R, PERSON_R, Netto, NettoWieBrutto);
  //

  with TXMLRPC_Server do
  begin
    result.AddObject('', oBeginArray);
    result.AddObject(fromDouble(Preis), oDouble);
    result.AddObject(fromDouble(Rabatt), oDouble);
    if Netto then
      result.AddObject(fromDouble(1.0), oDouble)
    else
      result.AddObject(fromDouble(0.0), oDouble);

    if NettoWieBrutto then
      result.AddObject(fromDouble(1.0), oDouble)
    else
      result.AddObject(fromDouble(0.0), oDouble);
    result.AddObject('', oEndArray);
  end;

end;

function TeConnect.rpc_e_r_Rabatt(sParameter: TStringList): TStringList;
var
  PERSON_R: integer;
begin
  result := TStringList.create;
  PERSON_R := cRID_unset;
  //
  Inc(WebShopClicks);
  if (sParameter.count > 1) then
    PERSON_R := StrToIntDef(sParameter[1], cRID_Null);
  with TXMLRPC_Server do
    result.AddObject(fromboolean(e_r_RabattFaehig(PERSON_R)), oBoolean);
end;

function TeConnect.rpc_e_r_Verlag(sParameter: TStringList): TStringList;
var
  LAND_R, VERLAG_R: integer;
begin
  result := TStringList.create;
  LAND_R := cRID_unset;
  VERLAG_R := cRID_unset;
  Inc(WebShopClicks);
  if (sParameter.count > 1) then
    LAND_R := StrToIntDef(sParameter[1], cRID_Null);
  if (sParameter.count > 2) then
    VERLAG_R := StrToIntDef(sParameter[2], cRID_Null);
  with TXMLRPC_Server do
    result.AddObject(e_r_ObtainISOfromRID(LAND_R) + '-' +
      e_r_Verlag(VERLAG_R), oString);
end;

function TeConnect.rpc_e_r_Versandkosten(sParameter: TStringList): TStringList;
var
  versandkosten: double;
  PERSON_R: integer;
  ARTIKEL_R: integer;
  BELEG_R: integer;
begin
  result := TStringList.create;
  Inc(WebShopClicks);
  versandkosten := cPreis_Unbekannt;
  PERSON_R := cRID_unset;

  repeat
    // Parameter "PERSON_R" lesen
    if (sParameter.count > 1) then
      PERSON_R := StrToIntDef(sParameter[1], cRID_Null);

    // Zwischen-Beleg erstellen
    BELEG_R := e_w_BelegNeuAusWarenkorb(PERSON_R);
    if (BELEG_R < cRID_FirstValid) then
      break;

    // Versandartikel bestimmen
    ARTIKEL_R := e_r_VersandKosten(BELEG_R);

    // Zwischen-Beleg löschen
    e_w_preDeleteBeleg(BELEG_R);
    e_x_sql('delete from BELEG where RID=' + inttostr(BELEG_R));

    // Preis berechnen
    if (ARTIKEL_R >= cRID_FirstValid) then
      versandkosten := e_r_PreisBrutto(0, ARTIKEL_R);

  until true;

  with TXMLRPC_Server do
    result.AddObject(fromDouble(versandkosten), oDouble);
end;

function TeConnect.rpc_e_w_LoginInfo(sParameter: TStringList): TStringList;
var
  PERSON_R: integer;
  VORLAGE_R: integer;
begin
  result := TStringList.create;
  PERSON_R := cRID_unset;
  if (sParameter.count > 1) then
    PERSON_R := StrToIntDef(sParameter[1], cRID_Null);
  VORLAGE_R := e_r_VorlageMail(cMailVorlage_Login);
  if (VORLAGE_R >= cRID_FirstValid) then
    e_x_sql(format
      ('insert into EMAIL (PERSON_R,VORLAGE_R,NACHRICHT) values (%d,%d,''%s'')',
      [PERSON_R, VORLAGE_R, ceMail_ResetPasswort]))
  else
    e_w_Ticket('eMail-Vorlage "LOGIN" nicht gefunden!');
  //
  with TXMLRPC_Server do
    result.AddObject(fromboolean(true), oBoolean);
end;

function TeConnect.rpc_e_w_Miniscore(sParameter: TStringList): TStringList;
var
  ARTIKEL_R: integer;
  PERSON_R: integer;
begin
  result := TStringList.create;
  ARTIKEL_R := cRID_unset;
  PERSON_R := cRID_unset;

  //
  if (sParameter.count > 1) then
    PERSON_R := StrToIntDef(sParameter[1], cRID_Null);
  if (sParameter.count > 2) then
    ARTIKEL_R := StrToIntDef(sParameter[2], cRID_Null);

  //
  e_x_sql('insert into EREIGNIS (RID,PERSON_R,ARTIKEL_R,ART) values (0,' +
    inttostr(PERSON_R) + ',' + inttostr(ARTIKEL_R) + ',' +
    inttostr(eT_Miniscore) + ')');

  //
  with TXMLRPC_Server do
    result.AddObject(fromboolean(true), oBoolean);
end;

function TeConnect.rpc_e_w_PersonNeu(sParameter: TStringList): TStringList;
begin
  result := TStringList.create;
  with TXMLRPC_Server do
    result.AddObject(frominteger(e_w_PersonNeu), oInteger);
end;

// empfangenes Skript lokal ausführen

function TeConnect.rpc_e_w_Skript(sParameter: TStringList): TStringList;
var
  Data: AnsiString;
  n: integer;
begin
  result := TStringList.create;
  result.AddObject('', TXMLRPC_Server.oBeginArray);
  if not(assigned(oCompiler)) then
  begin
    oCompiler := TPSPascalCompiler.create;
    with oCompiler do
    begin
      onUses := _Uses;
    end;

    //
    oImporter := TPSRuntimeClassImporter.create;
    with oImporter do
    begin
    end;

    // Compiler.OnUses := ScriptOnUses; // assign the OnUses event.
    oExecute := TPSExec.create; // Create an instance of the executer.
    RegisterClassLibraryRuntime(oExecute, oImporter);
    RegisterDateTimeLibrary_R(oExecute);
    RIRegister_Funktionen_Basis_Routines(oExecute);
    RIRegister_Funktionen_Buch_Routines(oExecute);
    RIRegister_Funktionen_Beleg_Routines(oExecute);
    RIRegister_Funktionen_Auftrag_Routines(oExecute);
    RIRegister_eConnect(oImporter);
    with oExecute do
    begin
      // RegisterDelphiFunction(@ShMsg, 'HELLOORGAMON', cdRegister);
      RIRegister_Std(oImporter);
      RIRegister_Classes(oImporter, true);
    end;

  end;

  if oCompiler.Compile(sParameter.Text) then
  begin
    oCompiler.GetOutput(Data);

    // Save the output of the compiler in the string Data.
    if oExecute.LoadData(Data) then // Load the data from the Data string.
    begin
      result.Add('Run ' + inttostr(length(Data)) + ' Bytes of Code ...');
      oExecute.RunScript; // Run the script.
    end;

  end
  else
  begin
    with oCompiler do
    begin
      if (MsgCount = 0) then
        oCompiler.MakeError('', ecUnexpectedEndOfFile, 'Ursache unklar');
      for n := 0 to pred(MsgCount) do
        result.Add(Msg[n].MessageToString);
    end;
  end;
  //
  result.AddObject('', TXMLRPC_Server.oEndArray);

end;

end.
