{
  |        ___
  |       / _ \  ___
  |      | | | |/ __|
  |      | |_| | (__
  |       \___/ \___|
  |
  |    Orientation Convert
  |
  |    Copyright (C) 2007 - 2024  Andreas Filsinger
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
unit OrientationConvert;

{$ifdef FPC}
{$mode delphi}
{$endif}

interface

uses
  Classes;

const
  Version: single = 1.296; // ../rev/Oc.rev.txt

  Content_Mode_Michelbach = 1;
  Content_Mode_xls2xls = 3; // xls+Vorlage.xls -> xls
  Content_Mode_xls2csv = 4; // xls+[Fixed-Formats.ini] -> csv
  Content_Mode_KK20 = 5; // txt -> csv
  Content_Mode_KK22 = 6; // xls -> txt
  Content_Mode_csv = 7;
  Content_Mode_txt = 8;
  Content_Mode_xml2csv = 9; // .xml + Mapping.txt -> .csv
  Content_Mode_tab2csv = 10; // .tab + Mapping.txt -> .csv
  Content_Mode_xls2idoc = 11; // .xls + IDOC.Mappings.ini -> .idoc
  Content_Mode_xls2Argos2007 = 12; // xls -> Argos-2007 XML (mit XML.BLA)
  Content_Mode_xls2ml = 13; // xls+Vorlage.(ht)ml -> html /xml
  Content_Mode_enBW = 14;
  Content_Mode_Datev = 15; // xls+Datev.xls -> .xls
  Content_Mode_xsd = 16; // Prüfe xml Datei gegen eine "Schema.xsd"
  Content_Mode_dtd = 17; // Prüfe xml Datei gegen eine "*.dtd"
  Content_Mode_xls2flood = 18; // xls+Fixed-Flood.ini -> Auftrag füllen
  Content_Mode_csvMap = 19; // .csv Datei mit Mappings nach -> -mapped.csv Datei
  Content_Mode_xls2gm = 20; // GM
  Content_Mode_xls2html = 21; // xls+Vorlage.html -> multible html
  Content_Mode_Huffman = 22; // .huff -> .pas
  Content_Mode_xls2xml = 23; // xls+Vorlage.xml -> multible xml
  Content_Mode_xls2Argos2018 = 24; // xls -> Argos-2018 XML (mit XML-2018.BLA)

  ErrorCount: integer = 0;
  conversionOutFName: string = '';

  // Parameter Dateien
  cOc_LogFName = 'Diagnose.txt';
  cXML_Extension = '.xml';
  c_Mapping = 'Mapping.txt';
  c_XLS_VorlageFName = 'Vorlage.xls';
  p_XLS_VorlageFName: string = '';
  c_ML_VorlageFName = 'Vorlage.ml'; // xls -> xml (mehrere Datensätze in einer xml)
  c_XML_VorlageFName = 'Vorlage.xml'; // xls -> xml (pro Datensatz eine xml Datei)
  c_HTML_VorlageFName = 'Vorlage.html'; // xls -> html (pro Datensatz eine html Datei)
  p_HTML_VorlageFName: string = '';
  cFixedFormatsFName = 'Fixed-Formats.ini';
  cFixedFloodFName = 'Fixed-Flood.ini';
  c_ML_SchemaFName = 'Schema.xsd';
  cXLS_Referenzdatei = 'Zaehlerdaten_Referenz.csv';
  c_ML_CheckFName = 'Check' + cXML_Extension;
  cOc_FehlerMeldung = ' Oc misslungen - (mehr Infos in ' + cOc_LogFName + ') !';
  cARGOS_TYP = 'ARGOS_TEXT';

  // Parameter Spaltenüberschriften
  cOc_HTMLBenennung = 'HTML-Benennung';

function doConversion(Mode: integer; InFName: string; sBericht: TStringList = nil): boolean;
function CheckContent(InFName: string): integer;

// Dient der Zusammenfassung von mehreren Oc-Schritten
// in eine Diagnose.txt. Im Batch-Betrieb, oder kaskadierenden Betrieb
// würde sonst die Diagnose.txt immer wieder überschrieben. Durch
// eine Klammerung durch BeginOc oc(1) oc(2) EndOc bleibt die Diagnose.txt
// für beide Vorgänge in einer Diagnose.txt erhalten.
procedure BeginOc;
procedure EndOc;

implementation

uses
  // Core
  Windows, SysUtils, IniFiles,
  math,

  // OrgaMon - Tools
  geld, Mapping, anfix,
  html, WordIndex, gplists,
  binlager, ExcelHelper,

  {$ifdef fpc}
  // fpSpreadsheet
  fpspreadsheet, fpsTypes, fpsUtils,
  xlsbiff8, fpsNumFormat
  {$else}
  // libxml2
  libxml2, System.UITypes,
  // FlexCel
  FlexCel.Core, FlexCel.xlsAdapter
  {$endif}
  ;

const
  // Allgemeinwissen
  cERRORText = 'ERROR:';
  cWARNINGText = 'WARNING:';
  cINFOText = 'INFO:';
  cOLAPcsvSeperator = ';';
  cRID_FirstValid = 1;
  cRID_Null = -1;

  // für den Argos Mode
  cARGOS_KOPF = 'Zählernummer alt';
  cARGOS_Mappings = 'Oc.Mappings.ini';

  // erweiterte Einstellungen in der Mappings-Datei
  cMappings_Ergebnis = 'Ergebnis';
  cMappings_Auftrag = 'Auftrag';

  // für den IDOC Mode
  cIDOC_Mappings = 'IDOC.Mappings.ini';
  cIDOC_Extension = '.idoc';

  // für den XML Argos Mode
  cARGOS_2007_XML_SAVE = 'XML';
  cARGOS_2018_XML_SAVE = 'XML-2018';

type
 eXML_Converter_Mode = (eXML_XML_Single, eXML_HTML_Multi, eXML_XML_Multi);

var
  sDiagnose: TStringList; // details and ERRORs of conversion
  sDiagFiles: TStringList; // all Sources and the Result-File-Name
  WorkPath: string; // Oc - Working Directory
  OcTransaktionsTiefe : Integer = 0;
  OcFirstTime: Boolean = false;

{$ifdef fpc}
procedure xmlXxsd(InFName: string; sBericht: TStringList);
begin
  // imp pend
end;

procedure xmlXdtd(InFName: string; sBericht: TStringList);
begin
  // imp pend
end;
{$else}
procedure xmlXxsd(InFName: string; sBericht: TStringList); forward;
procedure xmlXdtd(InFName: string; sBericht: TStringList); forward;
{$endif}

procedure Error(s: string);
begin
  sDiagnose.add(cERRORText + ' ' + s);
  inc(ErrorCount);
end;

procedure tab2csv(InFName: string);
const
  cTAB = #9;
var
  Mapping: TStringList;
  sl: TStringList;
  ColumnCount: integer;
  HeaderLine: string;
  MappingsFName: string;
begin
  MappingsFName := ExtractFilePath(InFName) + c_Mapping;

  Mapping := TStringList.create;
  sl := TStringList.create;

  Mapping.loadFromFile(MappingsFName);
  sl.loadFromFile(InFName);
  ColumnCount := CharCount(cTAB, sl[0]);
  HeaderLine := Mapping.values[inttostr(ColumnCount)];
  ersetze(';', ',', sl);
  ersetze(cTAB, ';', sl);
  if (HeaderLine = '') then
  begin
    Mapping.add(inttostr(ColumnCount) + '=' + sl[0]);
    Mapping.SaveToFile(MappingsFName);
  end
  else
  begin
    sl.insert(0, HeaderLine);
  end;
  sl.SaveToFile(InFName + '.csv');

  Mapping.Free;
  sl.Free;
end;

function rweformat(ART, ZaehlerNummerNeu: string): string;
var
  PreMinus: string;
  PostMinus: string;
begin
  repeat

    // Blanks raus, Alles in Grossbuchstaben
    ZaehlerNummerNeu := AnsiupperCase(noblank(ZaehlerNummerNeu));
    ersetze(',', '.', ZaehlerNummerNeu);

    // Punkt-Eingabe des Monteurs
    if (pos('.', ZaehlerNummerNeu) > 0) then
    begin
      PreMinus := nextp(ZaehlerNummerNeu, '.', 0);
      PostMinus := nextp(ZaehlerNummerNeu, '.', 1);
      result := IntToStrN(PreMinus, 6) + '-' + PostMinus;
      break;
    end;

    // Sind Buchstaben enthalten?
    if length(StrFilter(ZaehlerNummerNeu, cZiffern + '-', true)) > 0 then
    begin
      result := ZaehlerNummerNeu;
      break;
    end;

    //
    if (pos('-', ZaehlerNummerNeu) = 0) then
    begin
      if (ART = 'WA') or (ART = 'G') then
      begin
        result := ZaehlerNummerNeu;
      end
      else
      begin
        result := copy(ZaehlerNummerNeu, 1, 6) + '-' + copy(ZaehlerNummerNeu, 7, MaxInt)
      end;
      break;
    end;

    // default
    result := ZaehlerNummerNeu;
  until yet;

end;

procedure xml2csv_Multi(InFName: string; sBericht: TStringList = nil); forward;

procedure xml2csv(InFName: string; sBericht: TStringList = nil);
const
  cARGOS_MaxSize = 1024 * 1024;
  sHeader: TStringList = nil;
var
  // XML
  sMapping: TStringList;
  sMESSAGE: TStringList;
  sTagList: TStringList;
  sTagAdd: boolean;
  NewFName: string;

  // CSV
  sCSV: TStringList;
  Umsetzer: TFieldMapping;

  sZaehlwerkeAusbau: TStringList;
  sZaehlwerkeEinbau: TStringList;
  sOrderIDs: TStringList;
  FNameKurz: string;

  // PARSEr Sachen
  NameSpace: TStringList;
  AutoMataState: integer;
  id: string;
  ActParserValue: string;
  CloseTag: boolean;
  CSVWriteSuppress: boolean;
  Stat_doubleORDERid: integer;
  LineNo: integer;
  Quote: string;

  // ARGOS
  sArgosTaetigkeiten: TStringList;
  sArgosMsg: TStringList;
  SpeedSave: TBLager;
  ArgosXML_P: pointer;
  Stat_Lager_Bisher: integer;
  Stat_Lager_Neu: integer;
  Stat_Lager_Ersetzt: integer;
  Stat_Lager_Endstand: integer;
  Anzahl_Geraete: integer;

  // Parameter
  pArgosMode: boolean;
  pArgos2018Mode: boolean;
  pMixedMode: boolean;
  pUTF8: boolean;
  pWriteAt: TStringList;
  pAddZw: TStringList;
  pDebug: boolean;
  pIgnoreZaehlwerke: TStringList;
  pSplitNameSpace: string;
  pTakeFirstValue: boolean;
  pReplaceNameSpace: string;
  pZW_SAME_NAME_OK: boolean;

  procedure push(Name: string);
  begin
    NameSpace.add(Name);
    ActParserValue := '';
  end;

  function fullName: string;
  var
    n: integer;
  begin
    if (NameSpace.count = 0) then
    begin
      result := '';
    end
    else
    begin
      result := NameSpace[0];
      for n := 1 to pred(NameSpace.count) do
        result := result + '.' + NameSpace[n]
    end;
    if pDebug then
      if sTagAdd then
        if sTagList.indexof(result) = -1 then
          sTagList.add(result);
  end;

  function nosemi(s: string): String;
  begin
    result := s;
    ersetze(';', ',', result);
    ersetze('"', '''', result);
  end;

  function oneLine: AnsiString;
  var
    n: integer;
    value: string;
  begin

    /// ////////////////////////////////////////////
    /// /////////// d e f a u l t s

    // bei leerer Zählernummer: Zählernummer mit dem Primary Key füllen (=DLAN-Position)
    if (sMESSAGE.values['FILE.MESSAGE.POSITION.ARTICLE.id'] = '') then
      sMESSAGE.values['FILE.MESSAGE.POSITION.ARTICLE.id'] := sMESSAGE.values['PK'];

    // bei leere Zähler (neu) Beschreibung, kommt die Info aus dem Zähler alt.
    if (sMESSAGE.values['FILE.MESSAGE.POSITION.ARTICLE_TYPE.type_description'] = '') then
      sMESSAGE.values['FILE.MESSAGE.POSITION.ARTICLE_TYPE.type_description'] :=
        sMESSAGE.values['FILE.MESSAGE.POSITION.ARTICLE.type_description'];

    /// /////////// d e f a u l t s
    /// ////////////////////////////////////////////

    for n := 0 to pred(sMapping.count) do
    begin
      value := sMESSAGE.values[sMapping[n]];
      try
        value := Umsetzer[sHeader[n], value];
      except
        on e: exception do
          Error('Umsetzer ' + sHeader[n] + ':' + e.message);
      end;
      if n = 0 then
        result := nosemi(value)
      else
        result := result + ';' + nosemi(value);
    end;
  end;

  procedure outOne;
  var
    n: integer;

    // der letzte ID in den Tätigkeiten
    ARGOSID: int64;
    ArgosSave: TMemoryStream;
    ZaehlwerkZeile : String;
  begin

    sTagAdd := false;

    if not(CSVWriteSuppress) then
    begin

      if pArgosMode then
      begin
        ARGOSID := strtointdef(sMESSAGE.values['TOUR.KUNDE.GERAETEPLATZ.GERAET.TAET.ID'], -1);
        if (ARGOSID=-1) then
         ARGOSID := strtointdef(sMESSAGE.values['DSP.OBJ.ACT.TAE_ID'], -1);

        if (ARGOSID > -1) then
        begin
          if (ARGOSID > MaxInt) then
            raise exception.create('TAET.ID > MaxInt');
          if (sArgosMsg.count > 0) then
          begin
            ArgosSave := TMemoryStream.create;
            sArgosMsg.savetoStream(ArgosSave);
            ArgosSave.Position := 0;
            move(ArgosSave.Memory^, ArgosXML_P^, ArgosSave.size);
            if SpeedSave.exist(ARGOSID) then
              inc(Stat_Lager_Ersetzt)
            else
              inc(Stat_Lager_Neu);
            SpeedSave.insert(ARGOSID, ArgosSave.size);
            sArgosMsg.clear;
            ArgosSave.Free;
          end;
        end;
      end;

      if (sZaehlwerkeAusbau.count + sZaehlwerkeEinbau.count= 0) then
      begin
        sCSV.add(FNameKurz + ';' + oneLine + ';' + '1' + ';;' + ';;');
      end
      else
      begin
        for n := 0 to pred(max(sZaehlwerkeAusbau.count,sZaehlwerkeEinbau.count)) do
        begin

          if (n<sZaehlwerkeAusbau.count) then
           ZaehlwerkZeile := sZaehlwerkeAusbau[n]
          else
           ZaehlwerkZeile := ';;';

          if (n<sZaehlwerkeEinbau.count) then
           ZaehlwerkZeile := ZaehlwerkZeile + ';' + sZaehlwerkeEinbau[n]
          else
           ZaehlwerkZeile := ZaehlwerkZeile + ';' + ';;';

          sCSV.add(FNameKurz + ';' + oneLine + ';' + inttostr(succ(n)) + ';' + ZaehlwerkZeile);
        end;
      end;
    end
    else
    begin
      CSVWriteSuppress := false;
      inc(Stat_doubleORDERid);
    end;
  end;

  procedure clearOne;
  begin
    if pDebug then
      sMESSAGE.SaveToFile(WorkPath + 'pre-Clear.tmp');
    sMESSAGE.clear;
    sZaehlwerkeAusbau.clear;
    sZaehlwerkeEinbau.clear;
    Anzahl_Geraete := 0;
  end;

  procedure writeOne;
  begin
    outOne;
    clearOne;
  end;

  procedure addZaehlwerkAusbau(zw: string);
  begin
    if (pIgnoreZaehlwerke.indexof(zw) = -1) then
      if (sZaehlwerkeAusbau.indexof(zw) = -1) or pZW_SAME_NAME_OK then
        sZaehlwerkeAusbau.add(zw);
  end;

  procedure addZaehlwerkEinbau(zw: string);
  begin
    if (pIgnoreZaehlwerke.indexof(zw) = -1) then
      if (sZaehlwerkeEinbau.indexof(zw) = -1) or pZW_SAME_NAME_OK then
        sZaehlwerkeEinbau.add(zw);
  end;

  procedure CheckDouble;
  var
    PK: string;
  begin
    PK :=
    { } sMESSAGE.values['FILE.MESSAGE.HEAD.order_id'] + '-' +
    { } sMESSAGE.values['FILE.MESSAGE.POSITION.order_position'];

    if (sOrderIDs.indexof(PK) = -1) then
    begin
      sOrderIDs.add(PK);
      sMESSAGE.values['PK'] := PK;
    end
    else
    begin
      sDiagnose.add('WARNUNG: Schlüssel "' + PK + '" ist doppelt, Auftrag wurde ignoriert!');
      CSVWriteSuppress := true;
    end;
  end;

  procedure pop;
  var
    _FullName: string;
    Argos_KurzBez: string;
    _Sperre: string;

  begin
    _FullName := fullName;

    // ###########################
    // onClose(Tag) - EVENTS !!!!!
    repeat

      // Argos
      if pArgosMode then
      begin

        if (pWriteAt.count > 0) then
        begin

          if (_FullName = 'dispo.auftrag.sperrzeit') then
          begin
            _Sperre := nextp(sMESSAGE.values['dispo.auftrag.sperrzeit'], ' ', 0);
            if DateOK(_Sperre) then
              sMESSAGE.values['dispo.auftrag.sperre_von'] := _Sperre
            else
              sMESSAGE.values['dispo.auftrag.sperre_von'] := '';

            _Sperre := nextp(sMESSAGE.values['dispo.auftrag.sperrzeit'], ' ', 2);
            if DateOK(_Sperre) then
              sMESSAGE.values['dispo.auftrag.sperre_bis'] := _Sperre
            else
              sMESSAGE.values['dispo.auftrag.sperre_bis'] := '';

          end;

          // Zählwerkbezeichnung dazu machen
          if (pAddZw.indexof(_FullName) <> -1) then
            addZaehlwerkAusbau(sMESSAGE.values[_FullName]);

          if (pWriteAt.indexof(_FullName) <> -1) then
          begin
            outOne;
            clearOne;
          end;

        if (_FullName = 'DSP.OBJ.ACT') then
        begin
           pArgos2018Mode := true;

          if (sMESSAGE.Values['DSP.OBJ.ACT.MERKMAL']='MECH-ZW') then
            if (sMESSAGE.Values['DSP.OBJ.ACT.KNOPFGRUPPE']='AGERAET') then
              addZaehlwerkAusbau(
               sMESSAGE.Values['DSP.OBJ.ACT.KENNZIFFER1'] + ';' +
               sMESSAGE.Values['DSP.OBJ.ACT.EINHEIT'] );

          if (sMESSAGE.Values['DSP.OBJ.ACT.MERKMAL']='MECH-SERINFO') then
           if (sMESSAGE.Values['DSP.OBJ.ACT.KNOPFGRUPPE']='AGERAET') then
            sMESSAGE.Values['DSP.OBJ.SERIAL'] := sMESSAGE.Values['DSP.OBJ.ACT.ERG'];

          if (sMESSAGE.Values['DSP.OBJ.ACT.MERKMAL']='CHANGE-GPL_STANDORTTXT') then
            sMESSAGE.Values['DSP.OBJ.STANDORTTXT'] := sMESSAGE.Values['DSP.OBJ.ACT.ERG'];

          if (sMESSAGE.Values['DSP.OBJ.ACT.MERKMAL']='CHANGE-VS_LGZUSATZ') then
            sMESSAGE.Values['DSP.OBJ.LGZUSATZ'] := sMESSAGE.Values['DSP.OBJ.ACT.ERG'];

          if (sMESSAGE.Values['DSP.OBJ.ACT.MERKMAL']='MECH-INFO') then
           if (noblank(sMESSAGE.Values['DSP.OBJ.ACT.ERG'])<>'') then
            if (sMESSAGE.Values['DSP.OBJ.ACT.KNOPFGRUPPE']='AGERAET') then
            begin
             if pos(sMESSAGE.Values['DSP.OBJ.ACT.ERG'],sMESSAGE.Values['DSP.OBJ.INFO_AUSBAU'])=0 then
              sMESSAGE.Values['DSP.OBJ.INFO_AUSBAU'] := sMESSAGE.Values['DSP.OBJ.INFO_AUSBAU'] + ' ' + sMESSAGE.Values['DSP.OBJ.ACT.ERG']
            end else
            begin
             if pos(sMESSAGE.Values['DSP.OBJ.ACT.ERG'],sMESSAGE.Values['DSP.OBJ.INFO_EINBAU'])=0 then
              sMESSAGE.Values['DSP.OBJ.INFO_EINBAU'] := sMESSAGE.Values['DSP.OBJ.INFO_EINBAU'] + ' ' + sMESSAGE.Values['DSP.OBJ.ACT.ERG'];
            end;

          if (sMESSAGE.Values['DSP.OBJ.ACT.MERKMAL']='MECH-MATNRNEU') then
             sMESSAGE.Values['DSP.OBJ.MATNRNEU'] := sMESSAGE.Values['DSP.OBJ.ACT.ERG'];

          break;
        end;

        // <ACT> <HOSTKEY>ZM_KLASSEN</HOSTKEY><MERKMAL></MERKMAL><KNOPFGRUPPE>AGERAET</KNOPFGRUPPE><TAE_ID>36102160</TAE_ID><ABLBELEGNR></ABLBELEGNR><KENNZIFFER1></KENNZIFFER1><ALTERG></ALTERG><DATALTERG>1899-12-30T00:00:00</DATALTERG><PLAUSITYP>0</PLAUSITYP><STELLEN>0</STELLEN><NACHKOMMA>0</NACHKOMMA><TOLERANZPLUS>0</TOLERANZPLUS><TOLERANZMINUS>0</TOLERANZMINUS><OBERGRENZE>0</OBERGRENZE><UNTERGRENZE>0</UNTERGRENZE><ZWNUMMER>000</ZWNUMMER><TAGESWERT>0.000000</TAGESWERT><TARIF></TARIF><EINHEIT></EINHEIT><ERG>G12390344</ERG>



          break;
        end;

        if (_FullName = 'TOUR.KUNDE.GERAETEPLATZ.GERAET.TAET') then
        begin
          Argos_KurzBez := sMESSAGE.values['TOUR.KUNDE.GERAETEPLATZ.GERAET.TAET.KURZBEZ'];

          if (sArgosTaetigkeiten.indexof(Argos_KurzBez) = -1) then
            sArgosTaetigkeiten.add(Argos_KurzBez);
          if (Argos_KurzBez = 'StandHT') or // Elektro
            (Argos_KurzBez = 'StandNT') or // Elektro
            (Argos_KurzBez = 'Stand') // Gas / Wasser
          then
            addZaehlwerkAusbau(sMESSAGE.values['TOUR.KUNDE.GERAETEPLATZ.GERAET.TAET.OBIS'] + ';' + sMESSAGE.values
              ['TOUR.KUNDE.GERAETEPLATZ.GERAET.TAET.EINHEIT']);

          break;
        end;

        if (_FullName = 'TOUR.KUNDE.GERAETEPLATZ.GERAET') or
          (_FullName = 'Schnittstelle_VA_EDM.Mandant.Laufweg.Verbrauchsstelle.Kunde.Geraet') then
        begin
          inc(Anzahl_Geraete);
          sMESSAGE.values['TOUR.KUNDE.GERAETEPLATZ.ANZAHL_GERAETE'] := inttostr(Anzahl_Geraete);
          outOne;
          break;
        end;

        if (_FullName = 'TOUR.KUNDE') or (_FullName = 'Schnittstelle_VA_EDM.Mandant.Laufweg') then
        begin
          clearOne;
          break;
        end;

        if (_FullName = 'Schnittstelle_VA_EDM.Mandant.Laufweg.Verbrauchsstelle.Kunde.Geraet.Zaehlwerk.ZWBezeichnung')
        then
        begin
          addZaehlwerkAusbau(sMESSAGE.values
            ['Schnittstelle_VA_EDM.Mandant.Laufweg.Verbrauchsstelle.Kunde.Geraet.Zaehlwerk.ZWBezeichnung']);
        end;

      end;

      // RWE - Einbau
      if (_FullName = 'FILE.MESSAGE.POSITION.ARTICLE_TYPE.COUNTER') then
      begin
        addZaehlwerkEinbau(sMESSAGE.values['FILE.MESSAGE.POSITION.ARTICLE_TYPE.COUNTER.edis_key'] + ';' +
          sMESSAGE.values['FILE.MESSAGE.POSITION.ARTICLE_TYPE.COUNTER.unit']);
        break;
      end;

      // RWE - Ausbau
      if (_FullName = 'FILE.MESSAGE.POSITION.ARTICLE.COUNTER') then
      begin
        addZaehlwerkAusbau(sMESSAGE.values['FILE.MESSAGE.POSITION.ARTICLE.COUNTER.edis_key'] + ';' + sMESSAGE.values
          ['FILE.MESSAGE.POSITION.ARTICLE.COUNTER.unit']);
        break;
      end;

      if (_FullName = 'FILE.MESSAGE') then
      begin
        writeOne;
        break;
      end;

      if (_FullName = 'FILE.MESSAGE.POSITION') then
      begin
        CheckDouble;
        break;
      end;

      if (pWriteAt.indexof(_FullName) <> -1) then
      begin
        outOne;
        clearOne;
        break;
      end;

    until yet;
    // onClose(Tag) - EVENTS !!!!!
    // ###########################

    NameSpace.delete(pred(NameSpace.count));
  end;

  procedure InitParse;
  begin
    NameSpace.clear;
    AutoMataState := 0;
    CloseTag := false;
    CSVWriteSuppress := false;
    Stat_doubleORDERid := 0;
    Quote := '''';
  end;

  function FormatValue(s: string): string;
  begin
    result := s;
    ersetze(c_xml_CRLF, '|', result);
    ersetze(c_xml_ampersand, '&', result);
    result := html2ansi(result);
    ersetze(';', ',', result);
  end;

  procedure setMessage(const Name, value: string);
  var
    OldValue: string;
  begin
    // Regel:
    // wenn bisher leer -> Jeder Wert OK
    // wenn bisher ein Wert -> Neuer Wert wird ignoriert
    if pTakeFirstValue then
    begin
      // sDiagnose.add(Name+'='+value);
      if (value <> '') then
      begin
        OldValue := sMESSAGE.values[Name];
        if (OldValue = '') then
          sMESSAGE.values[Name] := value;
      end;
    end
    else
    begin
      sMESSAGE.values[Name] := value;
    end;
  end;

  procedure parse(Line: string);
  var
    k, l, m: integer;
    tmp: string;
  begin
    try
      if pArgosMode then
        sArgosMsg.add(cutblank(Line));
      repeat

        //
        if (Line <> '') then
          case AutoMataState of
            0:
              begin // suche ein open Tag "<", ansonsten kommt alles in "value"!

                k := pos('<', Line);
                if (k > 0) then
                begin
                  if (k > 1) then
                  begin
                    if pArgosMode or pMixedMode then
                      ActParserValue := ActParserValue + copy(Line, 1, pred(k));
                  end;
                  delete(Line, 1, k);
                  AutoMataState := 1;
                end
                else
                begin
                  ActParserValue := ActParserValue + Line + '|';
                  Line := '';
                end;

              end;
            1:
              begin // Art des Tag bestimmen

                if (pos('!--', Line) = 1) then
                begin
                  AutoMataState := 2;
                  continue;
                end;

                if (pos('!', Line) = 1) then
                begin
                  AutoMataState := 3;
                  continue;
                end;

                if (pos('?', Line) = 1) then
                begin
                  AutoMataState := 3;
                  ActParserValue := '';
                  continue;
                end;

                if (pos('/', Line) = 1) then
                begin
                  if pArgosMode or pMixedMode then
                  begin
                    setMessage(fullName, FormatValue(ActParserValue));
                    ActParserValue := '';
                  end;
                  CloseTag := true;
                  delete(Line, 1, 1);
                end;

                AutoMataState := 4;

              end;
            2:
              begin // Suche den comment Close Tag
                k := pos('-->', Line);
                if (k > 0) then
                begin
                  delete(Line, 1, k + 2);
                  AutoMataState := 0;
                  continue;
                end;
                Line := '';
              end;
            3:
              begin // es ist ein reiner XML interner Tag
                k := pos('>', Line);
                if (k > 0) then
                begin
                  delete(Line, 1, k);
                  AutoMataState := 0;
                  continue;
                end;

                Line := '';
              end;
            4:
              begin // Name eines echten Tags einlesen,

                if CloseTag then
                begin

                  CloseTag := false;
                  k := pos('>', Line);
                  delete(Line, 1, k);
                  pop;
                  AutoMataState := 0;

                end
                else
                begin

                  k := pos(' ', Line);
                  l := pos('>', Line);
                  m := pos('/>', Line);

                  // nach dem Namen kommt ein leerschritt? -> Es gibt Werte!
                  if (k > 0) and ((k < l) or (l = 0)) then
                  begin
                    push(copy(Line, 1, pred(k)));
                    delete(Line, 1, k);
                    AutoMataState := 5;
                    continue;
                  end;

                  // nach dem Namen kommt sofort der CloseTag?
                  if (l > 0) and ((l < k) or (k = 0)) then
                  begin
                    if (m <> l - 1) then
                    begin
                      // Beginn eines neuen Wertes
                      push(copy(Line, 1, pred(l)));
                      delete(Line, 1, l);
                    end
                    else
                    begin
                      // Beginn und gleichzeitiges Ende eines Wertes
                      push(copy(Line, 1, pred(m)));
                      setMessage(fullName, '');
                      pop;
                      delete(Line, 1, m);
                    end;
                    AutoMataState := 0;
                    continue;
                  end;

                end;
              end;
            5:
              begin // Identifier eines einzelnen Tags sammeln

                while (pos(' ', Line) = 1) do
                  delete(Line, 1, 1);

                if (pos('/>', Line) = 1) then
                begin
                  pop;
                  delete(Line, 1, 2);
                  AutoMataState := 0;
                  continue;
                end;

                if (pos('>', Line) = 1) then
                begin
                  delete(Line, 1, 1);
                  AutoMataState := 0;
                  continue;
                end;

                k := pos('=', Line);
                id := copy(Line, 1, pred(k));
                ActParserValue := '';
                delete(Line, 1, k);
                AutoMataState := 6;

              end;
            6:
              begin // Sammeln eines id="embedded" !

                  if (pos('"',Line)=1) then
                   Quote := '"';
                  if (pos('''',Line)=1) then
                   Quote := '''';

                  if (pos(Quote, Line) = 1) then
                  begin

                    // Wert herausschneiden, Linie verkürzen!
                    ActParserValue := copy(Line, 2, MaxInt);
                    k := pos(Quote, ActParserValue);
                    if (k = 0) then
                    begin
                      AutoMataState := 7;
                      Line := '';
                    end
                    else
                    begin
                      delete(Line, 1, succ(k));
                      ActParserValue := copy(ActParserValue, 1, pred(k));
                      AutoMataState := 5;
                    end;
                  end;

                setMessage(fullName + '.' + id, FormatValue(ActParserValue));

              end;
            7:
              begin // Es kommen noch Zeilen hinzu!

                k := pos(Quote, Line);
                if (k > 0) then
                begin
                  // Wert herausschneiden, Linie verkürzen!
                  tmp := copy(Line, 1, pred(k));
                  delete(Line, 1, succ(k));
                  ActParserValue := ActParserValue + c_xml_CRLF + tmp;
                  AutoMataState := 5;
                end
                else
                begin
                  ActParserValue := ActParserValue + c_xml_CRLF + Line;
                  Line := '';
                end;

                setMessage(fullName + '.' + id, FormatValue(ActParserValue));

              end;
          end;
      until Line = '';
    except
      on e: exception do
        Error('Parse: Line ' + inttostr(LineNo) + ':' + e.message);
    end;
  end;

  procedure CreateHeader;
  var
    n: integer;
    header: string;
    colName: string;
    Mapping: string;

    function takeLast(Mapping: string; Anzahl: integer): string;
    var
      sTags: TStringList;
      n: integer;
    begin
      result := '';
      sTags := TStringList.create;
      while (Mapping <> '') do
        sTags.add(nextp(Mapping, '.'));
      for n := pred(sTags.count) downto max(0, pred(sTags.count) - pred(Anzahl)) do
        if (result = '') then
          result := sTags[n]
        else
          result := sTags[n] + '.' + result;
      sTags.Free;
    end;

  begin
    sMapping.loadFromFile(ExtractFilePath(InFName) + c_Mapping);

    pArgosMode := sMapping.values['ARGOS'] = 'JA';
    pMixedMode := sMapping.Values['MIXED'] = 'JA';
    pUTF8 := sMapping.values['UTF8'] = 'JA';
    pWriteAt := Split(sMapping.values['WRITE_AT'], '|', '', true);
    if pArgosMode then
      pArgos2018Mode := (pWriteAt.IndexOf('DSP.OBJ')<>-1)
    else
      pArgos2018Mode := false;
    pAddZw := Split(sMapping.values['ADD_ZW'], '|', '', true);
    pDebug := sMapping.values['DEBUG'] = 'JA';
    pIgnoreZaehlwerke := Split(sMapping.values['IGNORE'], '|', '', true);
    pSplitNameSpace := sMapping.values['NAMESPACE'];
    pTakeFirstValue := sMapping.values['COALESCE'] = 'JA';
    pReplaceNameSpace := sMapping.values['REPLACE'];
    pZW_SAME_NAME_OK := sMapping.values['ZW_SAME_NAME_OK'] = 'JA';

    // Leerzeilen aus der Mapping definition löschen!
    for n := pred(sMapping.count) downto 0 do
      if
      { } (pos(';', sMapping[n]) = 0) or
      { } (pos('#', sMapping[n]) = 1) or
      { } (pos('=', sMapping[n]) > 0) then
        sMapping.delete(n);

    // Kopfzeile zusammenbauen!
    for n := 0 to pred(sMapping.count) do
    begin
      Mapping := nextp(sMapping[n], ';', 0);
      colName := nextp(sMapping[n], ';', 1);
      repeat
        if (colName = '2') then
        begin
          colName := takeLast(Mapping, 2);
          break;
        end;
        if (colName = '1') then
        begin
          colName := takeLast(Mapping, 1);
          break;
        end;
      until yet;

      if (n = 0) then
        header := colName
      else
        header := header + ';' + colName;

      sMapping[n] := Mapping;
    end;
    sCSV.add('Quelle;' + header + ';Zaehlwerk;edis_key_ausbau;unit_ausbau;edis_key_einbau;unit_einbau');

    // Header nochmal schnell als TStringList
    sHeader := Split(header);
  end;

  function NameSpaceSave(sCSV: TStrings): string;
  var
    iNameSpaces: TgpIntegerList;
    iReplace: TStringList;
    NameSpaceIndex: integer;
    OneHeaderName: string;
    SplitNameSpace: string;
    ReplaceNameSpace: string;

    sNames: TStringList;
    Name: string;
    n, m: integer;
    sOut: TStringList;
    OutFName: string;

    function getName(l: string): string;
    var
      n, m: integer;
      NameSegment: string;
    begin

      // Ergebnis zusammenaddieren
      result := '_';
      for n := 0 to pred(iNameSpaces.count) do
      begin
        NameSegment := nextp(l, ';', iNameSpaces[n]);

        // Suchen & Ersetzen "REPLACE="
        for m := 0 to pred(iReplace.count) do
          ersetze(nextp(iReplace[m], '=', 0), nextp(iReplace[m], '=', 1), NameSegment);
        NameSegment := cutblank(NameSegment);

        if (NameSegment = '') then
          continue;
        if (result = '_') then
          result := NameSegment
        else
          result := result + '-' + NameSegment;
      end;

      // Ergebnis filtern, so dass ein Dateiname draus werden kann
      result := StrFilter(result, cInvalidFNameChars, true);

    end;

  begin
    iNameSpaces := TgpIntegerList.create;
    iReplace := TStringList.create;
    SplitNameSpace := pSplitNameSpace;
    ReplaceNameSpace := pReplaceNameSpace;

    // Welche Spalten soll als Basis verwendet werden?
    while (SplitNameSpace <> '') do
    begin
      OneHeaderName := nextp(SplitNameSpace, ';');
      NameSpaceIndex := sHeader.indexof(OneHeaderName) + 1;
      if (NameSpaceIndex = 0) then
      begin
        Error('NameSpace: Spalte "' + OneHeaderName + '" nicht gefunden!');
        exit;
      end;
      iNameSpaces.add(NameSpaceIndex);
    end;

    // Replace
    while (ReplaceNameSpace <> '') do
    begin
      OneHeaderName := nextp(ReplaceNameSpace, ')');

      iReplace.add(
        { } copy(nextp(OneHeaderName, '|', 0), 2, MaxInt) + '=' +
        { } nextp(OneHeaderName, '|', 1));
    end;

    // erst mal alle Name-Spaces bestimmen
    sNames := TStringList.create;
    for n := 1 to pred(sCSV.count) do
    begin
      Name := getName(sCSV[n]);
      if (sNames.indexof(Name) = -1) then
        sNames.add(Name);
    end;

    // Nun nach den Namespaces sortiert speichern!
    for n := 0 to pred(sNames.count) do
    begin
      sOut := TStringList.create;

      sOut.add(sCSV[0]);
      for m := 1 to pred(sCSV.count) do
        if (sNames[n] = getName(sCSV[m])) then
          sOut.add(sCSV[m]);

      // Ausgabe-Dateiname
      OutFName := ExtractFilePath(InFName) + sNames[n] + '.csv';

      // Ausgabe hinten dran hängen
      if FileExists(OutFName) then
      begin
        sOut.delete(0);
        AppendStringsToFile(sOut, OutFName);
      end
      else
        sOut.SaveToFile(OutFName);

      sOut.Free;
    end;
    result := HugeSingleLine(sNames, '_');
    sNames.Free;
    iNameSpaces.Free;
    iReplace.Free;
  end;

var
  fXML: Text;
  OneL: string;
  SplitNameSpace: string;

begin
  if (pos('*', InFName) > 0) then
  begin
    xml2csv_Multi(InFName, sBericht);
    exit;
  end;

  if not(FileExists(InFName)) then
  begin
    Error(InFName + ' nicht gefunden');
    exit;
  end;

  Stat_Lager_Bisher := -1;
  Stat_Lager_Neu := 0;
  Stat_Lager_Ersetzt := 0;
  Stat_Lager_Endstand := -1;

  sMapping := TStringList.create;
  sMESSAGE := TStringList.create;
  sTagList := TStringList.create;
  sTagAdd := true;

  sCSV := TStringList.create;
  sZaehlwerkeAusbau := TStringList.create;
  sZaehlwerkeEinbau := TStringList.create;
  NameSpace := TStringList.create;
  sOrderIDs := TStringList.create;
  sArgosTaetigkeiten := TStringList.create;
  sArgosMsg := TStringList.create;
  SpeedSave := TBLager.create;

  FNameKurz := ExtractFileName(InFName);

  // CSV-Sachen
  CreateHeader;
  Umsetzer := TFieldMapping.create;
  Umsetzer.Path := WorkPath;

  // Quell-Datei öffnen
  if pUTF8 then
    AssignFile(fXML, InFName, CP_UTF8)
  else
    AssignFile(fXML, InFName, 28591 {CP_iso_8859_1});
  reset(fXML);

  // reset Parser
  InitParse;

  if pArgosMode then
  begin
    GetMem(ArgosXML_P, cARGOS_MaxSize);
    if pArgos2018Mode then
     SpeedSave.init(WorkPath + cARGOS_2018_XML_SAVE, ArgosXML_P^, 1024 * 1024)
    else
     SpeedSave.init(WorkPath + cARGOS_2007_XML_SAVE, ArgosXML_P^, 1024 * 1024);
    SpeedSave.BeginTransaction;
    Stat_Lager_Bisher := SpeedSave.CountRecs;
  end;

  LineNo := 0;
  while not(eof(fXML)) do
  begin
    readln(fXML, OneL);
    inc(LineNo);
    parse(OneL);
    if (ErrorCount > 0) then
      break;
  end;
  CloseFile(fXML);

  if (ErrorCount = 0) then
  begin
    if (pSplitNameSpace = '') then
    begin
      sCSV.SaveToFile(InFName + '.csv');
    end
    else
    begin
      SplitNameSpace := NameSpaceSave(sCSV);
      repeat

        // 1. Versuch
        NewFName := InFName;
        ersetze('EXPORT-', 'EXPORT_[' + SplitNameSpace + ']_', NewFName);
        FileMove(InFName, NewFName);
        if FileExists(NewFName) then
          break;

        // 2. Versuch
        NewFName := InFName;
        ersetze('EXPORT-', 'EXPORT_[' + distinct(SplitNameSpace) + ']_', NewFName);
        FileMove(InFName, NewFName);
        if FileExists(NewFName) then
          break;

        // 3. Versuch
        NewFName := InFName;
        ersetze('EXPORT-', 'EXPORT_[' + copy(SplitNameSpace, 1, 25) + ']_', NewFName);
        FileMove(InFName, NewFName);
        if FileExists(NewFName) then
          break;

        // 4. Versuch
        NewFName := InFName;
        ersetze('EXPORT-', 'EXPORT_', NewFName);
        FileMove(InFName, NewFName);
        if FileExists(NewFName) then
          break;

        // Umbenennen misslungen
        raise exception.create('Umbenennen der EXPORT- Datei nicht möglich!');

      until yet;
    end;
  end
  else
    DeleteFile(InFName + '.csv');

  if pArgosMode then
  begin
    // sArgosTaetigkeiten.SaveToFile(InFname+'.Taetigkeiten.txt');
    Stat_Lager_Endstand := SpeedSave.CountRecs;
    SpeedSave.EndTransaction;
    sDiagnose.add('BLA-Bisher=' + inttostr(Stat_Lager_Bisher));
    sDiagnose.add('BLA-Zugang=' + inttostr(Stat_Lager_Neu));
    sDiagnose.add('BLA-Ersetzt=' + inttostr(Stat_Lager_Ersetzt));
    sDiagnose.add('BLA-Neu=' + inttostr(Stat_Lager_Endstand));
  end;

  if pDebug then
  begin
    sTagList.SaveToFile(WorkPath + 'Mapping.tmp');
    sMESSAGE.SaveToFile(WorkPath + 'Values.tmp');
  end;

  sArgosTaetigkeiten.Free;
  sArgosMsg.Free;
  sMapping.Free;
  sMESSAGE.Free;
  sTagList.Free;
  sCSV.Free;
  sZaehlwerkeAusbau.Free;
  sZaehlwerkeEinbau.Free;
  NameSpace.Free;
  sOrderIDs.Free;
  SpeedSave.Free;
  if assigned(sHeader) then
    sHeader.Free;
  Umsetzer.Free;
  pIgnoreZaehlwerke.Free;
  pWriteAt.Free;
  pAddZw.Free;
end;

procedure xml2csv_Multi(InFName: string; sBericht: TStringList = nil);
var
  sDir: TStringList;
  n: integer;
begin
  sDir := TStringList.create;
  dir(InFName, sDir, false);
  sDir.Sort;
  for n := 0 to pred(sDir.count) do
    xml2csv(ExtractFilePath(InFName) + sDir[n], sBericht);
  sDir.Free;
end;

procedure xls2gm(InFName: string; sBericht: TStringList);
const
  cSTATUS_Unmoeglich = 9;
  cSTATUS_Vorgezogen = 7;
  cSTATUS_Erfolg = 4;
  cSTATUS_ErfolgGemeldet = 12;
  cSTATUS_UnmoeglichGemeldet = 13;
  cSTATUS_VorgezogenGemeldet = 14;

  EDIS_Ignore =
   { a } '1-1:0.2.0;' +
   { a } '1-0:1.7.1;' +
   { b } '1-0:0.0.9*255;' +
   { b } '1-0:21.7.0;' +
   { b } '1-0:41.7.0;' +
   { b } '1-0:61.7.0';

  EDIS_Reihenfolge_Ausbau = 'ZaehlerstandAlt;A181;NA;A280;A281;A282';
  EDIS_Reihenfolge_Einbau = 'ZaehlerstandNeu;E181;NN;E280;E281;E282';

var
  sSource: TStringList;
  sMappings: TStringList;
  xlsHeaders: TStringList;

  sResult: TStringList;
  sStack: TStringList;
  RollBack: boolean;

  // Cache
  xmlToday: string;
  xmlMESSAGE: integer;
  xml_BeginIndex: integer;
  xml_EndIndex: integer;

  // XLS-Sachen
{$ifdef fpc}
  xImport: TsWorkbook;
{$else}
  xImport: TXLSFile;
{$endif}
  r, c: integer;

  // Spalten Konstante
  cORDER_id: integer;
  cORDER_Position: integer;
  cART: integer;
  cSPARTE: integer;
  cRID: integer;
  cStatus: integer;
  cZaehlerNummer: integer;
  cZaehlwerke_Ausbau: integer;
  cZaehlwerke_Einbau: integer;

  // Datenfelder Cache
  OrderId: string;
  OrderPosition: string;
  ART: string;
  ART_Zaehlwerke: integer;
  ZAEHLWERKE_AUSBAU: TStringList;
  ZAEHLWERKE_EINBAU: TStringList;

  Sparte: string;
  RID: string;
  ZAEHLER_NUMMER: string;
  STATUS: integer;
  ZaehlwerkeAusbauXML: TStringList;
  ZaehlwerkeEinbauXML: TStringList;

  ZaehlwerkeIgnoriert: TStringList;
  type_id: string;

  // Ablauf - Parameter
  pBilder: boolean;
  pKommentare: boolean;

  procedure failBecause(Msg: string);
  begin
    if assigned(sBericht) then
      sBericht.add('(RID=' + RID + ') ' + Msg)
    else
      sDiagnose.add(cERRORText + ' (RID=' + RID + ') ' + Msg);
    RollBack := true;
  end;

  procedure speak(s: string = '');
  begin
    if (cutblank(s) = '') then
      sResult.add('')
    else
      sResult.add(fill(' ', sStack.count) + s);
  end;

  procedure whisper(s: string = '');
  begin
    if pKommentare then
     speak(s);
  end;

  procedure push(tag: string);
  begin
    speak('<' + tag + '>');
    sStack.add(nextp(tag, ' ', 0));
  end;

  procedure pop;
  var
    tag: string;
  begin
    tag := sStack[pred(sStack.count)];
    sStack.delete(pred(sStack.count));
    speak('</' + tag + '>');
  end;

  procedure single(tag: string);
  begin
    speak('<' + tag + ' />');
  end;

  procedure COUNTER(Quelle, odis, Stand: string);
  begin
    if (Quelle <> '') then
      whisper('<!-- source="' + Quelle + '" -->');

    single('COUNTER ' +
      { } 'edis_key="' + odis + '" ' +
      { } 'quantity="' + Stand + '"');
  end;

  function l { ocate } (id, Position: string): boolean;
  var
    n, m: integer;
    FoundIt: boolean;
  begin
    // im ersten UND im 2. Rang wird gesucht!
    // 1: <ORDER id=~ID~
    // 2: <POSITION order_position=~Position~

    //
    xml_BeginIndex := -1;
    xml_EndIndex := -1;
    FoundIt := false;

    for n := 0 to pred(sSource.count) do
    begin
      if (pos('<ORDER ', sSource[n]) = 0) and (pos('<HEAD ', sSource[n]) = 0) then
        continue;

      // Trick: and (pos('order_id="' + id + '"', sSource[n]) = 0) wurde gespart weil
      // id="" auch bei order_id="" passt
      if (pos('id="' + id + '"', sSource[n]) = 0) then
        continue;
      xml_BeginIndex := n;
      for m := xml_BeginIndex to pred(sSource.count) do
      begin
        if (m > xml_BeginIndex) then
          if pos('</MESSAGE>', sSource[m]) > 0 then
          begin
            xml_EndIndex := m;
            break;
          end;
        if (pos('<POSITION ', sSource[m]) = 0) then
          continue;
        if pos('order_position="' + Position + '"', sSource[m]) = 0 then
          continue;
        FoundIt := true;

      end;

      if FoundIt then
        break;
    end;

    result := (xml_BeginIndex <> -1) and (xml_EndIndex <> -1) and FoundIt;
  end;

  function e { xists } (tag, value: string): boolean;
  var
    n: integer;
    k: integer;
    oneLine: string;
  begin
    result := false;
    for n := xml_BeginIndex to xml_EndIndex do
    begin

      k := pos('<' + tag + ' ', sSource[n]);
      if (k = 0) then
        continue;
      oneLine := copy(sSource[n], k, MaxInt);
      k := pos(' ' + value + '="', oneLine);
      if (k = 0) then
        k := pos(' ' + value + ' = "', oneLine);

      if (k = 0) then
        continue;
      oneLine := copy(oneLine, k + length(value) + 3, MaxInt);
      k := pos('"', oneLine);
      if (k = 0) then
        continue;
      result := true;
      break;
    end;
  end;

  function ep { xists with Parameter } (tag, Param, value: string): boolean;
  var
    n, k, l: integer;
    oneLine: string;
  begin
    result := false;
    for n := xml_BeginIndex to xml_EndIndex do
    begin
      k := pos('<' + tag + ' ', sSource[n]);
      if (k = 0) then
        continue;
      l := pos(Param, sSource[n]);
      if (l < k) then
        continue;

      oneLine := copy(sSource[n], k, MaxInt);
      k := pos(' ' + value + '="', oneLine);
      if (k = 0) then
        k := pos(' ' + value + ' = "', oneLine);

      if (k = 0) then
        continue;
      oneLine := copy(oneLine, k + length(value) + 3, MaxInt);
      k := pos('"', oneLine);
      if (k = 0) then
        continue;
      result := true;
      break;
    end;
  end;

  function q { uestion } (tag, value: string): string;
  var
    n, m: integer;
    k: integer;
    oneLine: string;
    FoundTag: boolean;
  begin

    result := '"<ReferenceFailed>"';
    FoundTag := false;
    for n := xml_BeginIndex to xml_EndIndex do
    begin
      k := pos('<' + tag + ' ', sSource[n]);
      if (k = 0) then
        continue;
      oneLine := copy(sSource[n], k, MaxInt);
      for m := succ(n) to succ(xml_EndIndex) do
      begin
        k := pos(' ' + value + '="', oneLine);
        if (k = 0) then
          k := pos(' ' + value + ' = "', oneLine);
        if (k > 0) or (m > xml_EndIndex) then
          break;
        // nichts gefunden, ggf. in weiteren Zeilen suchen ...
        oneLine := sSource[m];
      end;

      if (k = 0) then
        continue;
      oneLine := copy(oneLine, k + length(value) + 3, MaxInt);
      k := pos('"', oneLine);
      if (k = 0) then
        continue;
      result := '"' + copy(oneLine, 1, k);
      FoundTag := true;
      break;
    end;

    if not(FoundTag) then
      failBecause(OrderId + ': q(' + tag + '.' + value + '): nicht gefunden!');
  end;

  function Logzaehlwerke: string;
  begin
    result := '(' + inttostr(ZaehlwerkeAusbauXML.count) + ':' + inttostr(ZaehlwerkeEinbauXML.count) + ')';
  end;

  function qp { uestion with parameter } (tag, Param, value: string): string;
  var
    n, k, l: integer;
    oneLine: string;
    FoundTag: boolean;
  begin

    result := '"<ReferenceFailed>"';
    FoundTag := false;
    for n := xml_BeginIndex to xml_EndIndex do
    begin
      k := pos('<' + tag + ' ', sSource[n]);
      if (k = 0) then
        continue;
      l := pos(Param, sSource[n]);
      if (l < k) then
        continue;

      oneLine := copy(sSource[n], k, MaxInt);
      k := pos(' ' + value + '="', oneLine);
      if (k = 0) then
        k := pos(' ' + value + ' = "', oneLine);

      if (k = 0) then
        continue;
      oneLine := copy(oneLine, k + length(value) + 3, MaxInt);
      k := pos('"', oneLine);
      if (k = 0) then
        continue;
      result := '"' + copy(oneLine, 1, k);
      FoundTag := true;
      break;
    end;

    if not(FoundTag) then
      failBecause(OrderId + Logzaehlwerke + ': ' + tag + '.' + value + ' bei ' + Param + ': nicht gefunden!');
  end;

  procedure fillAufgaben;
  var
    n: integer;
    AlterZaehler: boolean;
    NeuerZaehler: boolean;
    zw: string;
  begin
    ZaehlwerkeAusbauXML.clear;
    ZaehlwerkeEinbauXML.clear;
    AlterZaehler := false;
    NeuerZaehler := false;
    for n := xml_BeginIndex to xml_EndIndex do
    begin

      // Erkennung Einbau-Zähler
      if (pos('<ARTICLE_TYPE ', sSource[n]) > 0) then
      begin
        AlterZaehler := false;
        NeuerZaehler := true;
        continue;
      end;

      if (pos('<ARTICLE ', sSource[n]) > 0) and (pos('new_article="TRUE"', sSource[n]) > 0) then
      begin
        AlterZaehler := false;
        NeuerZaehler := true;
        continue;
      end;

      // Erkennung Ausbau-Zähler
      if (pos('<ARTICLE ', sSource[n]) > 0) then
      begin
        AlterZaehler := true;
        NeuerZaehler := false;
        continue;
      end;

      // Nun die Zählwerke sammeln!
      if (pos('<COUNTER ', sSource[n]) > 0) then
      begin
        zw := ExtractSegmentBetween(sSource[n], 'edis_key="', '"');

        // Zählwerke, die ignoriert werden
        if (ZaehlwerkeIgnoriert.indexof(zw) <> -1) then
          continue;

        // Zählwerk nun hinzufügen!
        if AlterZaehler then
          ZaehlwerkeAusbauXML.add(zw);
        if NeuerZaehler then
          ZaehlwerkeEinbauXML.add(zw);
        continue;

      end;

    end;
  end;

  function x { celValue } (r, c: integer): string; overload;
  begin
    {$ifdef fpc}
    result := xImport.ActiveWorksheet.ReadAsText(pred(r), c);
    {$else}
    result := xImport.getCellValue(r, succ(c)).ToString;
    {$endif}
    ersetze('"', '''', result);
    ersetze('&', c_xml_ampersand, result);
  end;

  function xs (r,c: Integer): string;
  begin
{$ifdef fpc}
    result := xImport.ActiveWorksheet.ReadAsText(pred(r),pred(c));
{$else}
    result := xImport.getCellValue(r, c).ToStringInvariant;
{$endif}
  end;

  function x { celValue } (r: integer; c: string): string; overload;
  var
    _c: integer;
  begin
    _c := xlsHeaders.indexof(c);
    if (_c = -1) then
    begin
      result := '?';
      sDiagnose.add(cERRORText + ' Spalte "' + c + '" nicht gefunden!');
      inc(ErrorCount);
    end
    else
    begin
      result := x(r, _c);
    end;
  end;

  function xd(r: integer): string; overload;
  var
    _cd: integer;
    _ct: integer;
    d, t: TDateTime;
  begin
    _cd := xlsHeaders.indexof('WechselDatum');
    _ct := xlsHeaders.indexof('WechselZeit');

    if (_cd = -1) or (_ct = -1) then
    begin
      result := '?';
      sDiagnose.add(cERRORText + ' Spalte "WechselDatum" oder "WechselZeit" nicht gefunden!');
      inc(ErrorCount);
    end
    else
    begin

      // Datum auslesen
      {$ifdef fpc}
      d := getDateValue(xImport.ActiveWorksheet, pred(r), _cd);
      {$else}
      d := getDateValue(xImport, r, succ(_cd));
      {$endif}

      // Uhr auslesen
      {$ifdef fpc}
      t := getTimeValue(xImport.ActiveWorksheet, pred(r), _cd);
      {$else}
      t := getTimeValue(xImport, r, succ(_ct));
      {$endif}

      if (d = 0) then
        d := anfix.now;

      result := long2date(d) + SecondsToStr(t);

      result :=
       { yyyy } copy(result, 7, 4) +
       { mm } copy(result, 4, 2) +
       { tt } copy(result, 1, 2) +
       { hh } copy(result, 11, 2) +
       { mm } copy(result, 14, 2) +
       { ss } copy(result, 17, 2);
    end;
  end;

  function xd(r: integer; c: string): string; overload;
  var
    _cdt: integer;
    d: TDateTime;
  begin
    _cdt := xlsHeaders.indexof(c);
    if (_cdt = -1) then
    begin
      result := '?';
      sDiagnose.add(cERRORText + ' Spalte "' + c + '" nicht gefunden!');
      inc(ErrorCount);
    end
    else
    begin

      result := '';
      try
        {$ifdef fpc}
        d := getDateTimeValue(xImport.ActiveWorksheet, pred(r), _cdt);
        {$else}
        d := getDateTimeValue(xImport, r, succ(_cdt));
        {$endif}

        if (d > 0) then
        begin

          result := long2date(d) + SecondsToStr(d);

          result :=
          { yyyy } copy(result, 7, 4) +
          { mm } copy(result, 4, 2) +
          { tt } copy(result, 1, 2) +
          { hh } copy(result, 11, 2) +
          { mm } copy(result, 14, 2) +
          { ss } copy(result, 17, 2);
        end;
      except
      end;
    end;
  end;

  function x_optional(r: integer; c: string): string; overload;
  begin
    if (xlsHeaders.indexof(c) <> -1) then
      result := x(r, c)
    else
      result := '';
  end;

  function x_mussfeld(r: integer; c: string): string; overload;
  begin
    result := x(r, c);
    if result = '' then
      failBecause('Das Eingabefeld "' + c + '" ist leer');
  end;

  procedure OneFound(r: integer);

  var
    Zaehlwerksumme: double;

    function edis(SpalteName: string): string;
    begin
      result := '1-1:' +
      { } copy(SpalteName, 2, 1) + '.' +
      { } copy(SpalteName, 3, 1) + '.' +
      { } copy(SpalteName, 4, 1);
    end;

    function rSpaltenName (Map: string): string;
    begin
      result := sMappings.Values[Map];
      if (result='') then
      begin
        sDiagnose.add(
         {} cWARNINGText + ' Zeile "' + Map + '=~SpaltenName~" in xls2xml.ini nicht definiert, verwende "ZaehlerstandAlt/Neu"');
        if (pos('Ausbau',Map)>0) then
         result := 'ZaehlerstandAlt'
        else
         result := 'ZaehlerstandNeu';
      end;
    end;

    function MeldeZaehlwerk(r: integer; SpalteName, edis: string): boolean; overload;
    var
      Stand: string;
      StandAsDouble: double;
    begin
      result := false;
      Stand := x(r, SpalteName);

      // Melde nur wenn was drinsteht!
      if (Stand <> '') then
      begin

        // nicht numerische Eingaben werden zu "0"
        StandAsDouble := StrToDoubleDef(Stand, 0.0);

        // Ausgabe nur wenn 0 oder Positiv
        if (StandAsDouble >= 0.0) then
        begin
          COUNTER(SpalteName, edis, Stand);
          result := true;
        end;

      end;
    end;

    procedure MeldeSumme(Index_Summe: integer; const Zaehlwerke: TStringList);
    begin

      // Ausgabe
      if (Zaehlwerksumme > 0.0) then
        COUNTER('calculated value', Zaehlwerke[Index_Summe], inttostr(round(Zaehlwerksumme)));

      // verbrenne das Zählwerk
      Zaehlwerke.delete(Index_Summe);

    end;

  var
    // Wichtiger Hinweis, geht immer über die Schnittstelle!
    WichtigerHinweis: string;

    // Bermerkung und MehrInfos geht nicht mehr zwangsläufig über die Schnittstelle
    Bemerkung: string;
    MehrInfos: string;

    Bild: string;
    RollBackPosition, n: integer;
    Index_ET_HT, Index_NT, Index_Summe: integer;
    operation: string;
  begin
    RollBackPosition := sResult.count;
    RollBack := false;
    WichtigerHinweis := '';
    Bemerkung := '';
    MehrInfos := '';

    push('MESSAGE number="' + inttostr(xmlMESSAGE) + '"');

    single('HEAD order_id="' + OrderId + '"');

    push('POSITION ' +
      { } 'order_position=' + q('POSITION', 'order_position') + ' ' +
      { } 'reason_for_creation=' + q('POSITION', 'planning_reason') + ' ' +
      { } 'service_id=' + q('POSITION', 'service_id') + ' ' +
      { } 'service=' + q('POSITION', 'service'));

    if (ZaehlwerkeAusbauXML.count > 0) then
    begin

      // melde AUSBAU
      push('ARTICLE ' +
        { } 'new_article="FALSE" ' +
        { } 'id="' + x(r, 'Zaehler_Nummer') + '" ' +
        { } 'type_id=' + qp('ARTICLE', 'new_article="FALSE"', 'type_id') + ' ' +
        { } 'multiplication_constant="1" ' +
        { } 'assembly="NONE"');


      for n := 0 to pred(ZAEHLWERKE_AUSBAU.count) do
       if (ZaehlwerkeAusbauXML.IndexOf(ZAEHLWERKE_AUSBAU[n])<>-1) then
        MeldeZaehlwerk(r, rSpaltenName(
         {} 'Ausbau ' +
         {} IntToStr(succ(n))+'/'+IntToStr(ZAEHLWERKE_AUSBAU.count)+' '+
         {} ZAEHLWERKE_AUSBAU[n] )
          ,ZAEHLWERKE_AUSBAU[n]);

      pop;

    end
    else
    begin
      // Es sollte nichts abgelesen werden ...

      (*
      for n := 0 to 5 do
        if (x(r, cZaehlwerk[n]) <> '') then
          WichtigerHinweis :=
          { } WichtigerHinweis + c_xml_CRLF +
          { } edis(ZaehlwerkeMobil[n]) + '=' +
          { } x(r, cZaehlwerk[n]);
      *)
    end;

    if (x(r, 'ZaehlerNummerNeu') <> '') then
    begin

      if e('ARTICLE_TYPE', 'type_id') then
      begin
        type_id := q('ARTICLE_TYPE', 'type_id');
      end
      else
      begin
        if ep('ARTICLE', 'new_article="TRUE"', 'type_id') then
          type_id := qp('ARTICLE', 'new_article="TRUE"', 'type_id')
        else
          type_id := '?';
      end;

      if (type_id <> '?') then
      begin

        // melde EINBAU
        push('ARTICLE ' +
          { } 'new_article="TRUE" ' +
          { } 'id="' + rweformat(ART, x(r, 'ZaehlerNummerNeu')) + '" ' +
          { } 'type_id=' + type_id + ' ' +
          { } 'multiplication_constant="1" ' +
          { } 'assembly="NONE"');

        for n := 0 to pred(ZAEHLWERKE_EINBAU.count) do
          if (ZaehlwerkeEinbauXML.IndexOf(ZAEHLWERKE_EINBAU[n])<>-1) then
            MeldeZaehlwerk(r, rSpaltenName (
             {} 'Einbau ' +
             {} IntToStr(succ(n))+'/'+IntToStr(ZAEHLWERKE_EINBAU.count)+' '+
             {} ZAEHLWERKE_EINBAU[n] )
             , ZAEHLWERKE_EINBAU[n]);

        pop;

      end
      else
      begin

        WichtigerHinweis := WichtigerHinweis + c_xml_CRLF +
        { } 'Eingebaut wurde: ' + rweformat(ART, x(r, 'ZaehlerNummerNeu'));
       (*
        for n := 6 to 11 do
          if (x(r, cZaehlwerk[n]) <> '') then
            WichtigerHinweis :=
            { } WichtigerHinweis + c_xml_CRLF +
            { } edis(ZaehlwerkeMobil[n]) + '=' +
            { } x(r, cZaehlwerk[n]);
        *)
      end;
    end;

    // operation Umsetzer, Designfehler RWE
    operation := q('TASK', 'operation');
    if (operation = '"Kontrolle/Überprüfung"') then
      operation := '"Kontrolle"';

    push('TASK ' +
      { } 'id=' + q('TASK', 'id') + ' ' +
      { } 'operation=' + operation + ' ' +
      { } 'operator_id=' + q('TASK', 'operator_id') + ' ' +
      { } 'operator=' + q('TASK', 'operator') + ' ' +
      { } 'date="' + xd(r) + '"');

    whisper;
    whisper('<!-- ### our unmapped tags: please include them in next dtd ### -->');
    whisper('<!-- operator_order_id="' + RID + '" -->');
    whisper('<!-- article_real_id="' + rweformat(ART, x(r, 'ZaehlerNummerKorrektur')) + '" -->');
    whisper('<!-- vain_attempt_1="' + xd(r, 'V1') + '" -->');
    whisper('<!-- vain_attempt_2="' + xd(r, 'V2') + '" -->');
    whisper('<!-- vain_attempt_3="' + xd(r, 'V3') + '" -->');
    whisper('<!-- order_source="' + x_optional(r, 'AuftragsQuelle') + '" -->');
    whisper('<!-- order_message="' + x_optional(r, 'Meldung') + '" -->');
    whisper;

    MehrInfos := x(r, 'MonteurText') + ' (' + x(r, 'MonteurHandy') + ')';

    if (x(r, 'ZaehlerNummerKorrektur') <> '') then
      WichtigerHinweis := WichtigerHinweis + c_xml_CRLF + 'Wirkliche Zählernummer: ' + x(r, 'ZaehlerNummerKorrektur');

    Bemerkung := cutblank(x(r, 'I3') + ' ' + x(r, 'I4') + ' ' + x(r, 'I5'));

    WichtigerHinweis := cutblank(x(r, 'I6') + ' ' + x(r, 'I7') + ' ' + x(r, 'I8')) + WichtigerHinweis;

    repeat

      if (STATUS = cSTATUS_Vorgezogen) then // vorgezogen
      begin
        single('INDICATION ' + 'id="999"' + ' ' + 'text="' + 'Wurde bereits erledigt: ' + Bemerkung + c_xml_CRLF +
          WichtigerHinweis + c_xml_CRLF + MehrInfos + '"');
        break;
      end;

      if (STATUS = cSTATUS_Unmoeglich) then // unmöglich
      begin
        if (Bemerkung = '') and (WichtigerHinweis = '') then
        begin
          failBecause('Bei Status "unmöglich" ist eine Bemerkung des Monteurs erforderlich!');
          break;
        end;

        single('INDICATION ' + 'id="999"' + ' ' + 'text="' + 'Ausführung unmöglich: ' + Bemerkung + c_xml_CRLF +
          WichtigerHinweis + c_xml_CRLF + MehrInfos + '"');
        break;
      end;

      if (WichtigerHinweis <> '') then
      begin
        single('INDICATION ' + 'id="001"' + ' ' + 'text="' + Bemerkung + c_xml_CRLF + WichtigerHinweis + c_xml_CRLF +
          MehrInfos + '"');
        break;
      end;

      if (Bemerkung <> '') then
      begin
        single('INDICATION ' + 'id="000"' + ' ' + 'text="' + Bemerkung + c_xml_CRLF + MehrInfos + '"');
        break;
      end;

      // Einfach nur die Infos
      single('INDICATION ' + 'id="000"' + ' ' + 'text="' + MehrInfos + '"');

    until yet;

    // (1) Protokoll-Bild (unbenutzt)
    // ...
    // push('INITIATION_PROTOCOL');
    // ...

    // (2) Ausbau-Bild
    Bild := cutblank(nextp(x(r, 'FA'), ',', 0));
    if (pos('.', Bild) > 0) then
    begin
      if pBilder then
      begin
        push('COUNTER_PICTURE');
        single('DATA_FILE ' + 'file_name="' + StrFilter(Bild, 'öäüÖÄÜß', true) + '"');
        pop;
      end
      else
      begin
        whisper('<!-- bild_ausbau="' + Bild + '"' + ' -->');
      end;
    end;

    // (3) Einbau-Bild
    Bild := cutblank(nextp(x(r, 'FN'), ',', 0));
    if (pos('.', Bild) > 0) then
    begin
      if pBilder then
      begin
        push('INSTALLATION_PICTURE');
        single('DATA_FILE ' + 'file_name="' + StrFilter(Bild, 'öäüÖÄÜß', true) + '"');
        pop;
      end
      else
      begin
        whisper('<!-- bild_einbau="' + Bild + '"' + ' -->');
      end;
    end;

    pop; // TASK
    pop; // POSITION
    pop; // MESSAGE
    if RollBack then
    begin
      for n := pred(sResult.count) downto RollBackPosition do
        sResult.delete(n);
      whisper('<!-- catched ' + OrderId + ' before finish line, because of quality policies -->');
      whisper('<!-- operator_order_id="' + RID + '" -->');
      if assigned(sBericht) then
      begin
        for n := pred(sBericht.count) downto 0 do
          if (pos('(RID=' + RID + ')', sBericht[n]) > 0) then
            whisper('<!-- policy_fail_reason="' + sBericht[n] + '" -->')
          else
            break;
      end;
    end else
    begin
      inc(xmlMESSAGE);
    end;
  end;

  procedure AppendSource(FName: string);
  var
    sXML: TStringList;
  begin
    sXML := TStringList.create;
    sXML.loadFromFile(FName);
    sSource.addStrings(sXML);
    sXML.Free;
  end;

  function AuftragsMaske: string;
  begin
    result := WorkPath + 'EXPORT*' + cXML_Extension;
  end;

  procedure LoadSource;
  var
    sDir: TStringList;
    n: integer;
  begin
    sDir := TStringList.create;
    dir(AuftragsMaske, sDir);
    for n := 0 to pred(sDir.count) do
    begin
      AppendSource(WorkPath + sDir[n]);
      sDiagFiles.add(WorkPath + sDir[n]);
    end;
    sDir.Free;
  end;

  procedure SetOutFname;
  var
    k: integer;
  begin
    conversionOutFName := InFName;
    k := revPos('.', conversionOutFName);
    conversionOutFName := copy(conversionOutFName, 1, pred(k)) + cXML_Extension;
  end;

begin
  sResult := TStringList.Create;
  sMappings := TStringList.Create;
  sStack := TStringList.create;
  sSource := TSearchStringList.create;
{$ifdef fpc}
  xImport := TsWorkbook.Create;
//  xImport.AddWorksheet('Tabelle1');
{$else}
  xImport := TXLSFile.create(true);
{$endif}
  xlsHeaders := TStringList.create;
  ZaehlwerkeAusbauXML := TStringList.create;
  ZaehlwerkeEinbauXML := TStringList.create;
  ZaehlwerkeIgnoriert := Split(EDIS_Ignore, ';', '', true);
  xmlToday := Datum10;
  xmlToday :=
  { } copy(xmlToday, 7, 4) +
  { } copy(xmlToday, 4, 2) +
  { } copy(xmlToday, 1, 2);
  xmlMESSAGE := 1;

  // Optionen laden
  if FileExists(WorkPath + 'xls2xml.ini') then
    sMappings.loadFromFile(WorkPath + 'xls2xml.ini');
  pBilder := sMappings.values['Bilder'] = 'JA';
  pKommentare := sMappings.values['Kommentare'] <> 'NEIN';

  LoadSource;
  SetOutFname;

  with sResult do
  begin

    add('<?xml version = "1.0" encoding = "UTF-8"?>');
    add('<!DOCTYPE FILE SYSTEM "ArbeitsschritteImport-v24.dtd" []>');
    whisper;
    whisper('<!--   ___                                  -->');
    whisper('<!--  / _ \  ___                            -->');
    whisper('<!-- | | | |/ __|  Orientation Convert      -->');
    whisper('<!-- | |_| | (__   (c)1987-' + JahresZahl + ' OrgaMon.org -->');
    whisper('<!--  \___/ \___|  Rev. ' + RevToStr(Version) + '               -->');
    whisper('<!--                                        -->');
    whisper;
    whisper('<!--<Datum> ' + Datum10 + ' -->');
    whisper('<!--<Zeit> ' + Uhr8 + ' -->');
    whisper('<!--<TAN> ' + StrFilter(ExtractFileName(InFName), '0123456789') + ' -->');
    whisper;

    push('FILE');

    with xImport do
    begin

      try
{$ifdef fpc}
        xImport.ReadFromFile(InFName,sfExcel8);
{$else}
        Open(InFName);
{$endif}
      except
        on e: exception do
        begin
          inc(ErrorCount);
          sDiagnose.add(cERRORText + ' ' + e.message);
          sDiagnose.add(cERRORText + ' ' + InFName + ' ist durch andere Anwendung geöffnet?');
        end;
      end;

      sDiagFiles.add(InFName);
      sDiagFiles.add(conversionOutFName);

      {$ifdef fpc}
      for c := 0 to ActiveWorksheet.GetLastColIndex do
        xlsHeaders.add(ActiveWorksheet.ReadAsText(0,c));
      {$else}
      for c := 1 to ColCountInRow(1) do
        xlsHeaders.add(getCellValue(1, c).ToStringInvariant);
      {$endif}

      cORDER_id := xlsHeaders.indexof('ORDER.id');
      if (cORDER_id = -1) then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "ORDER.id" nicht gefunden!');
        exit;
      end;

      cORDER_Position := xlsHeaders.indexof('ORDER.Position');
      if (cORDER_Position = -1) then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "ORDER.Position" nicht gefunden!');
      end;

      cART := xlsHeaders.indexof('Art');
      if (cART = -1) then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "Art" nicht gefunden!');
      end;

      cSPARTE := xlsHeaders.indexof('Sparte');
      if (cSPARTE = -1) then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "Sparte" nicht gefunden!');
      end;

      cRID := xlsHeaders.indexof('ReferenzIdentitaet');
      if (cRID = -1) then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "ReferenzIdentitaet" nicht gefunden!');
      end;

      cStatus := xlsHeaders.indexof('Status1');
      if (cStatus = -1) then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "Status1" nicht gefunden!');
      end;

      cZaehlerNummer := xlsHeaders.indexof('Zaehler_Nummer');
      if (cZaehlerNummer = -1) then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "Zaehler_Nummer" nicht gefunden!');
      end;

      cZaehlwerke_Ausbau := xlsHeaders.indexof('Zaehlwerke_Ausbau');
      if (cZaehlwerke_Ausbau = -1) then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "Zaehlwerke_Ausbau" nicht gefunden!');
      end;

      cZaehlwerke_Einbau := xlsHeaders.indexof('Zaehlwerke_Einbau');
      if (cZaehlwerke_Einbau = -1) then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "Zaehlwerke_Einbau" nicht gefunden!');
      end;

      if (ErrorCount > 0) then
        exit;

      r := 2;
      repeat

        // den Key zusammenbauen
        OrderId := cutblank(xs(r, succ(cORDER_id)));
        OrderId := anfix.fill('0', 9 - length(OrderId)) + OrderId;

        OrderPosition := cutblank(
          { } xs(r, succ(cORDER_Position)));
        if OrderPosition = '' then
          OrderPosition := '1';

        ART := cutblank(xs(r, succ(cART)));
        ART_Zaehlwerke := strtointdef(StrFilter(ART, '0123456789'), 1);
        ZAEHLWERKE_AUSBAU := split(xs(r, succ(cZaehlwerke_Ausbau)));
        cutblank(ZAEHLWERKE_AUSBAU);
        ZAEHLWERKE_EINBAU := split(xs(r, succ(cZaehlwerke_Einbau)));
        cutblank(ZAEHLWERKE_EINBAU);

        Sparte := cutblank(xs(r, succ(cSPARTE)));
        RID := cutblank(xs(r, succ(cRID)));
        STATUS := strtointdef(
          { } xs(r, succ(cStatus)), -1);
        ZAEHLER_NUMMER := cutblank(
          { } xs(r, succ(cZaehlerNummer)));

        // Status bei bereits gemeldeten umsetzen!
        if (STATUS = cSTATUS_ErfolgGemeldet) then
          STATUS := cSTATUS_Erfolg;
        if (STATUS = cSTATUS_UnmoeglichGemeldet) then
          STATUS := cSTATUS_Unmoeglich;
        if (STATUS = cSTATUS_VorgezogenGemeldet) then
          STATUS := cSTATUS_Vorgezogen;

        if (OrderId <> '') then
        begin
          if (STATUS in [cSTATUS_Unmoeglich, cSTATUS_Vorgezogen, cSTATUS_Erfolg]) then
          begin
            if l(OrderId, OrderPosition) then
            begin
              fillAufgaben;
              OneFound(r);
              // Mehrtarif-Zähler werden immer in 2 Zeilen ausgegeben (im Excel)!
              if (ART_Zaehlwerke > 1) then
                inc(r);
            end
            else
            begin
              if assigned(sBericht) then
                sBericht.add(
                 {} '(RID=' + RID + ') '+
                 {} 'ORDER.id/ORDER.Position'  +
                 {} '"' + OrderId + '"/"' + OrderPosition + '" ' +
                 {} 'in ' + AuftragsMaske + ' nicht gefunden!');
            end;
          end
          else
          begin
            if assigned(sBericht) then
              sBericht.add('(RID=' + RID + ') STATUS sollte in (Unmöglich,Vorgezogen,Erfolg) sein!');
          end;
        end
        else
        begin
          if assigned(sBericht) then
            sBericht.add('(RID=' + RID + ') ORDER.id ist leer!');
        end;


        ZAEHLWERKE_AUSBAU.Free;
        ZAEHLWERKE_EINBAU.Free;

        inc(r);
{$ifdef fpc}
      until (r > xImport.ActiveWorksheet.GetLastRowIndex);
{$else}
      until (r > RowCount);
{$endif}
    end;
    pop; // FILE
    if (sStack.count <> 0) then
    begin
      inc(ErrorCount);
      sDiagnose.add(cERRORText + ' Stack nicht abgearbeitet!');
    end;

  end;

  //
  if (ErrorCount = 0) then
  begin
    sResult.SaveToFile(conversionOutFName, Tencoding.UTF8);
    xmlXdtd(conversionOutFName, sBericht);
  end
  else
  begin
    FileDelete(conversionOutFName);
  end;
  sResult.Free;
  sSource.Free;
  sStack.Free;
  xImport.Free;
  xlsHeaders.Free;
  ZaehlwerkeAusbauXML.Free;
  ZaehlwerkeEinbauXML.Free;
  ZaehlwerkeIgnoriert.Free;
end;

procedure xls2idoc(InFName: string; sBericht: TStringList);
const
  cSTATUS_Unmoeglich = 9;
  cSTATUS_Vorgezogen = 7;
  cSTATUS_Erfolg = 4;
  cSTATUS_ErfolgGemeldet = 12;
  cSTATUS_UnmoeglichGemeldet = 13;
  cSTATUS_VorgezogenGemeldet = 14;
var
  sZaehlwerke: TStringList;
  xlsHeaders: TStringList;

  sResult: TStringList;
  sMapping: TStringList;
  RollBack: boolean;

  SequenceNo: integer;
  IDOCNo: integer;

  // Optionen
  pMEA_Naming: boolean;
  pFileName: string;

  // XLS-Sachen
{$ifdef fpc}
  xImport: TsWorkbook;
{$else}
  xImport: TXLSFile;
{$endif}
  r, c: integer;

  // Spalten Konstante
  cART: integer;
  cStatus: integer;
  cRID: integer;

  // Datenfelder Cache
  ART: string;
  RID: string;
  STATUS: integer;
  ZaehlwerkeAusbauSoll: integer;
  ZaehlwerkeEinbauSoll: integer;
  ZaehlwerkeIst: integer;

  procedure failBecause(Msg: string);
  begin
    if assigned(sBericht) then
      sBericht.add('(RID=' + RID + ') ' + Msg);
    RollBack := true;
  end;

  function Logzaehlwerke: string;
  begin
    result := '(' + inttostr(ZaehlwerkeAusbauSoll) + ':' + inttostr(ZaehlwerkeEinbauSoll) + ')';
  end;

  function FileName (TAN,SEQUENCE:string):string;
  begin
    result := pFileName;
    ersetze('~TAN~', TAN, result);
    ersetze('~SEQUENCE~', SEQUENCE, result);
  end;

  procedure SetOutFname;
  var
    k: integer;
  begin
    repeat

      if (pFileName<>'') then
      begin
        conversionOutFName :=
        { } WorkPath +
        { TAN } FileName(sMapping.values['TAN'],
        { SEQUENCE }IntToStrN(IDOCNo, 4) );
        break;
      end;

      if pMEA_Naming then
      begin
        conversionOutFName :=
        { } WorkPath +
        { } 'z1isu_meau_' +
        { } sMapping.values['TAN'] + '-' +
        { } IntToStrN(IDOCNo, 4);
        break;
      end;

      conversionOutFName := InFName;
      k := revPos('.', conversionOutFName);
      conversionOutFName := copy(conversionOutFName, 1, pred(k)) + '.' + IntToStrN(IDOCNo, 4) + cIDOC_Extension;

    until yet;
  end;

//
// EXCEL Access Routine
//

  function x { celValue } (r: integer; c: string): string;
  var
    _c: integer;
  begin
    _c := xlsHeaders.indexof(c);
    if (_c = -1) then
    begin
      result := '?';
      sDiagnose.add(cERRORText + ' Spalte "' + c + '" nicht gefunden!');
      inc(ErrorCount);
    end
    else
    begin
{$ifdef fpc}
      result := cutblank(xImport.ActiveWorksheet.ReadAsText(pred(r),_c));
{$else}
      result := cutblank(xImport.getCellValue(r, succ(_c)).ToString);
{$endif}
      ersetze(#160, ' ', result);
      ersetze('#', '', result);
      ersetze('"', '''', result);
      ersetze('&', c_xml_ampersand, result);
    end;
  end;

  function xs (r,c: Integer): string;
  begin
{$ifdef fpc}
    result := xImport.ActiveWorksheet.ReadAsText(pred(r),pred(c));
{$else}
    result := xImport.getCellValue(r, c).ToStringInvariant;
{$endif}
  end;

  function xd(r: integer): string; overload;
  var
    _cd: integer;
    _ct: integer;
    d, t: TDateTime;
  begin
    _cd := xlsHeaders.indexof('WechselDatum');
    _ct := xlsHeaders.indexof('WechselZeit');

    if (_cd = -1) or (_ct = -1) then
    begin
      result := '?';
      sDiagnose.add(cERRORText + ' Spalte "WechselDatum" oder "WechselZeit" nicht gefunden!');
      inc(ErrorCount);
    end
    else
    begin
      {$ifdef fpc}
      d := getDateValue(xImport.ActiveWorksheet, pred(r), _cd);
      t := getTimeValue(xImport.ActiveWorksheet, pred(r), _ct);
      {$else}
      d := getDateValue(xImport, r, succ(_cd));
      t := getTimeValue(xImport, r, succ(_ct));
      {$endif}

      if (d = 0) then
        d := now;

      result := long2date(d) + SecondsToStr(t);

      result :=
      { yyyy } copy(result, 7, 4) +
      { mm } copy(result, 4, 2) +
      { tt } copy(result, 1, 2) +
      { hh } copy(result, 11, 2) +
      { mm } copy(result, 14, 2) +
      { ss } copy(result, 17, 2);
    end;
  end;

  function xd(r: integer; c: string): string; overload;
  var
    _cdt: integer;
    d: TDateTime;
  begin
    _cdt := xlsHeaders.indexof(c);
    if (_cdt = -1) then
    begin
      result := '?';
      sDiagnose.add(cERRORText + ' Spalte "' + c + '" nicht gefunden!');
      inc(ErrorCount);
    end
    else
    begin

      result := '';
      d := 0;
      try
{$ifdef fpc}
        d := getDateTimeValue(xImport.ActiveWorksheet, pred(r), _cdt);
{$else}
        d := getDateTimeValue(xImport, r, succ(_cdt));
{$endif}
        if (d > 0) then
        begin

          result := long2date(d) + SecondsToStr(d);

          result :=
          { yyyy } copy(result, 7, 4) +
          { mm } copy(result, 4, 2) +
          { tt } copy(result, 1, 2) +
          { hh } copy(result, 11, 2) +
          { mm } copy(result, 14, 2) +
          { ss } copy(result, 17, 2);
        end;
      except
      end;
    end;

  end;

  function x_optional(r: integer; c: string): string; overload;
  begin
    if (xlsHeaders.indexof(c) <> -1) then
      result := x(r, c)
    else
      result := '';
  end;

  procedure OneFound(r: integer);
  var
    n: integer;
    Segment: string;
    SegmentParent: string;

    function populate(s: String): string;

      function doformat(s, sParameter: string): string;
      var
        FormatParameter: string;
        SizeSoll: integer;
        FormatCommand: string;
        // "0" für Auffüllen mit Nullen links
        // " " für Auffüllen mit Blanks rechts
        // "N" wie " " aber Nachkommastellen abschneiden
        FillChar: char;
        RechtsBuendig: boolean;
      begin
        if (pos('"', s) = 1) then
          s := copy(s, 2, length(s) - 2);

        SizeSoll := 0;
        FillChar := #0;
        FormatParameter := sMapping.values[sParameter + '.F'];
        if (FormatParameter <> '') then
        begin

          FormatCommand := nextp(FormatParameter, ';', 0);
          SizeSoll := strtointdef(nextp(FormatParameter, ';', 1), 0);

          repeat

            if (FormatCommand = '0') then
            begin
              if (StrFilter(AnsiupperCase(s), cBuchstaben + cZeichen) = '') then
              begin
                // rein numerisch
                FillChar := '0';
                RechtsBuendig := true;
              end
              else
              begin
                // Buchstaben entdeckt
                FillChar := ' ';
                RechtsBuendig := false;
              end;
              break;
            end;

            if (FormatCommand = 'N') then
            begin
              // Lösche Nachkommastellen
              s := nextp(s, ',', 0);
              FillChar := ' ';
              RechtsBuendig := false;
              break;
            end;

            // default
            FillChar := ' ';
            RechtsBuendig := false;

          until yet;

        end;

        // Format Informationen sind anzuwenden
        if (length(s) < SizeSoll) then
        begin
          if RechtsBuendig then
            s := fill(FillChar, SizeSoll - length(s)) + s
          else
            s := s + fill(FillChar, SizeSoll - length(s));
        end;

        result := s;
      end;

    var
      k1, k2: integer;
      sParameter: string;
      sValue: string;

    begin
      if (pos('"', s) = 1) then
        s := copy(s, 2, length(s) - 2);
      repeat
        k1 := pos('~', s);
        if (k1 = 0) then
          break;
        k2 := pos('~', copy(s, succ(k1), MaxInt));
        sParameter := copy(s, succ(k1), pred(k2));

        sValue := sMapping.values[ART + '.' + sParameter];
        if (sValue = '') then
          sValue := sMapping.values[sParameter];

        ersetze('~' + sParameter + '~', doformat(sValue, sParameter), s);

      until eternity;
      result := s;
    end;

  begin
    RollBack := false;

    with sMapping do
    begin

      //
      values['Zaehler_Nummer'] := x(r, 'Zaehler_Nummer');
      values['ZaehlerStandAlt'] := x(r, 'ZaehlerStandAlt');
      values['NA'] := x_optional(r, 'NA');

      values['ZaehlerNummerNeu'] := x(r, 'ZaehlerNummerNeu');
      values['ZaehlerStandNeu'] := x(r, 'ZaehlerStandNeu');
      values['MaterialNummerNeu'] := x(r, 'MaterialNummerNeu');
      values['NN'] := x_optional(r, 'NN');

      values['WechselMoment'] := xd(r);
      values['WechselDatum'] := copy(values['WechselMoment'], 1, 8);

      values['Werk'] := x(r, 'Werk');
      values['Lager'] := x(r, 'Lager');
      values['AnlageAlt'] := x(r, 'AnlageAlt');
      values['GeraeteplatzAlt'] := x(r, 'GeraeteplatzAlt');
      values['MaterialnummerZaehlerAlt'] := x(r, 'MaterialnummerZaehlerAlt');
      values['Document'] := IntToStrN(IDOCNo, 4);

      sResult.add(populate(values['HEADER']));

      for n := 1 to 20 do
      begin
        Segment := values[inttostr(n)];
        if (Segment = '') then
          break;

        // Nächstes Segment ausgeben
        SegmentParent := ExtractSegmentBetween(Segment, '(', ')');
        Segment := nextp(Segment, '(');

        values['Parent'] := values[SegmentParent + '.Sequence'];
        values['Sequence'] := inttostr(SequenceNo);
        values[Segment + '.Sequence'] := inttostr(SequenceNo);

        // Jetzt alle Values Extrahieren
        sResult.add(populate(values[Segment]));

        inc(SequenceNo);
      end;
    end;

    SetOutFname;
    if not(RollBack) then
    begin
      //
      sResult.SaveToFile(conversionOutFName);
      inc(IDOCNo);
    end
    else
    begin
      FileDelete(conversionOutFName);
    end;
    sResult.clear;
    SequenceNo := 1;

  end;

var
  n: integer;

begin
  sResult := TStringList.create;
  sMapping := TStringList.create;
  sZaehlwerke := TStringList.create;
{$ifdef fpc}
  xImport := TsWorkbook.Create;
{$else}
  xImport := TXLSFile.create(true);
{$endif}
  xlsHeaders := TStringList.create;
  SequenceNo := 1;
  IDOCNo := 1;

  sDiagFiles.add(WorkPath + cIDOC_Mappings);
  sMapping.loadFromFile(WorkPath + cIDOC_Mappings);

  for n := pred(sMapping.count) downto 0 do
  begin
    if (pos('#', sMapping[n]) = 1) or (pos('[', sMapping[n]) = 1) or (sMapping[n] = '') then
      sMapping.delete(n)
    else
      sMapping[n] := cutblank(sMapping[n]);
  end;

  with sMapping do
  begin
    values['NIL' + '.Sequence'] := '0';
    // Nur die Ziffern interessieren
    values['TAN'] := StrFilter(ExtractFileName(InFName), '0123456789');
    // Nur die letzten 4 Ziffern sind die TAN
    values['TAN'] := copy(values['TAN'], length(values['TAN']) - pred(4), MaxInt);

    values['TimeStamp'] := copy(Datum10, 7, 4) + copy(Datum10, 4, 2) + copy(Datum10, 1, 2) + SecondsToStr6(SecondsGet);
    pMEA_Naming := (values['MEA'] = 'JA');
    pFileName := values['FileName'];
  end;

  // Überbleibsel aus der letzten gleichnamigen Datenlieferung löschen
  repeat

    if (pFileName<>'') then
    begin
     FileDelete(WorkPath + FileName(sMapping.Values['TAN'],'????'));
     break;
    end;

    if pMEA_Naming then
    begin
      FileDelete(WorkPath + 'z1isu_meau_' + sMapping.values['TAN'] + '-*');
      break;
    end;

    // default
    n := revPos('.', InFName);
    FileDelete(copy(InFName, 1, pred(n)) + '.????' + cIDOC_Extension);

  until yet;

  SetOutFname;

  with xImport do
  begin

    try
{$ifdef fpc}
      xImport.ReadFromFile(InFName,sfExcel8);
{$else}
      Open(InFName);
{$endif}
    except
      on e: exception do
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' ' + e.message);
        sDiagnose.add(cERRORText + ' ' + InFName + ' ist durch andere Anwendung geöffnet?');
      end;
    end;

    sDiagFiles.add(InFName);
    sDiagFiles.add(conversionOutFName);

{$ifdef fpc}
    for c := 0 to ActiveWorksheet.GetLastColIndex do
      xlsHeaders.add(ActiveWorksheet.ReadAsText(0,c));
{$else}
    for c := 1 to ColCountInRow(1) do
      xlsHeaders.add(getCellValue(1, c).ToStringInvariant);
{$endif}

    cART := xlsHeaders.indexof('Art');
    if (cART = -1) then
    begin
      inc(ErrorCount);
      sDiagnose.add(cERRORText + ' Spalte "Art" nicht gefunden!');
      exit;
    end;

    cStatus := xlsHeaders.indexof('Status1');
    if (cStatus = -1) then
    begin
      inc(ErrorCount);
      sDiagnose.add(cERRORText + ' Spalte "Status1" nicht gefunden!');
      exit;
    end;

    cRID := xlsHeaders.indexof('ReferenzIdentitaet');
    if (cRID = -1) then
    begin
      inc(ErrorCount);
      sDiagnose.add(cERRORText + ' Spalte "ReferenzIdentitaet" nicht gefunden!');
      exit;
    end;

    r := 2;
    repeat
      RID := cutblank(xs(r, succ(cRID)));
      if (strtointdef(RID, cRID_Null) >= cRID_FirstValid) then
      begin
        ART := cutblank(xs(r, succ(cART)));
        ZaehlwerkeIst := strtointdef(StrFilter(ART, '0123456789'), 1);
        STATUS := strtointdef(xs(r, succ(cStatus)), -1);

        // Status bei bereits gemeldeten umsetzen!
        if (STATUS = cSTATUS_ErfolgGemeldet) then
          STATUS := cSTATUS_Erfolg;
        if (STATUS = cSTATUS_UnmoeglichGemeldet) then
          STATUS := cSTATUS_Unmoeglich;
        if (STATUS = cSTATUS_VorgezogenGemeldet) then
          STATUS := cSTATUS_Vorgezogen;

        if (STATUS = cSTATUS_Erfolg) then
        begin
          if (ZaehlwerkeIst > 1) then
          begin
            // Mehrtarif-Zähler werden immer in 2 Zeilen ausgegeben!
            OneFound(r);
            inc(r);
          end
          else
          begin
            OneFound(r);
          end;
        end
        else
        begin
          if assigned(sBericht) then
            sBericht.add('(RID=' + RID + ') via IDOC können wir nur den Status Erfolg melden!');
        end;
      end;

      inc(r);
    {$ifdef fpc}
    until (r > xImport.ActiveWorksheet.GetLastRowIndex);
    {$else}
    until (r > RowCount);
    {$endif}
  end;


  sResult.Free;
  sMapping.Free;
  xImport.Free;
  xlsHeaders.Free;
end;

procedure xls2csv(InFName: string; sBericht: TStringList = nil);
var
{$ifdef fpc}
  xImport: TsWorkbook;
{$else}
  xImport: TXLSFile;
{$endif}
  Auftrag: TsTable;
  Separator: String;
  RID: String;
  RollBack: boolean; // do NOT write Output-Line
  header, AllHeader: TStringList;

  // weitere Parameter
  pWilken: boolean;
  pKK22: boolean;
  pAuftrag: string;
  pAuftragAnker: TStringList;
  pFileName: string;
  pFileNamePlus: string;
  pRespectFormats: boolean;
  pDebugFormats: boolean;

  procedure checkSpalte(var col: integer; sName: string; Pflichtspalte: boolean = true);
  begin
    col := AllHeader.indexof(sName);
    if Pflichtspalte then
      if (col = -1) then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte ' + sName + ' nicht gefunden!');
      end;
  end;

  function getCell(r, c: integer): string; overload;
  var
    IsConverted: boolean;
    v: Variant;
    {$ifdef fpc}
    Cell: PCell;
    {$else}
    xFmt: TFlxFormat;
    {$endif}
    FormatStr: string;
    d: TDateTime;
  begin
    with xImport do
    begin
      try

        repeat

          if pDebugFormats then
          begin
            {$ifdef fpc}
            result := ReadFormatStr(xImport, r, c);
            {$else}
            xFmt := GetFormat(getCellFormat(r, c));
            result := xFmt.format;
            {$endif}
            // unfify results
            if (result='') then
            begin
              result := 'General';
            end else
            begin
              ersetze('dd', 'DD', result);
              ersetze('mm/', 'MM/', result);
              ersetze('yy', 'YY', result);
            end;
            IsConverted := true;
            break;
          end;

          if pRespectFormats then
          begin
            {$ifdef fpc}
            result := ActiveWorksheet.ReadAsText(pred(r), pred(c));
            {$else}
            result := GetStringFromCell(r, c);
            {$endif}
            IsConverted := true;
            break;
          end;

          {$ifdef fpc}
          Cell := ActiveWorksheet.Cells.FindCell(pred(r),pred(c));
          repeat
            //
            if not(assigned(Cell)) then
            begin
              v := '';
              break;
            end;

            if (Cell^.ContentType=cctNumber) or (Cell^.ContentType=cctDateTime) then
            begin
              v := ActiveWorksheet.ReadAsNumber(pred(r), pred(c));
              break;
            end;

            v := ActiveWorksheet.ReadAsText(pred(r), pred(c));
          until yet;
          {$else}
          v := getCellValue(r, c);
          {$endif}

          IsConverted := false;

          // 1. Es muss Double sein
          if (TVarData(v).VType <> varDouble) then
            break;

          // 2a. Es muss ein FormatIndex haben
          {$ifdef fpc}
          FormatStr := AnsiUpperCase(ReadFormatStr(xImport, r, c));
          {$else}
          if (getCellFormat(r, c) < 0) or (getCellFormat(r, c) >= FormatCount) then
            break;
          xFmt := GetFormat(getCellFormat(r, c));
          FormatStr := AnsiupperCase(xFmt.format);
          {$endif}

          // 2b. Es muss ein Format haben
          if (FormatStr = '') then
            break;

          // 3. Es muss ein Datumsformat haben
          if (pos('YY', FormatStr) > 0) and (pos('H', FormatStr) > 0) then
          begin
            // ganzer Timestamp
            d := v;
            result := long2date(d) + ' ' + SecondsToStr(d);
            IsConverted := true;
            break;
          end;

          if (pos('YY', FormatStr) > 0) then
          begin
            // Datum
            d := v;
            result := long2date(d);
            IsConverted := true;
            break;
          end;

          if (pos('H', FormatStr) > 0) then
          begin
            // Uhrzeit
            d := v;
            result := SecondsToStr(d);
            IsConverted := true;
            break;
          end;

        until yet;

        //
        if not(IsConverted) then
          result := v;

      except
        on e: exception do
        begin
          inc(ErrorCount);
          sDiagnose.add(cERRORText + ' ' + e.message);
          result := cERRORText + ' ' + e.message;
        end;
      end;

      // Überzählige Semikolons entfernen!
      ersetze(Separator, '', result);

      // "LF" durch "|" ersetzen
      ersetze(#$0A, '|', result);
    end;
  end;

  function getCell(r: Integer; c: string): string; overload;
  var
   Col : Integer;
  begin
   CheckSpalte(Col,c,false);
   if (Col<>-1) then
    result := getCell(r,succ(Col))
   else
    result := '';
  end;

  procedure failBecause(Msg: string);
  begin
    if assigned(sBericht) then
      sBericht.add('(RID=' + RID + ') ' + Msg)
    else
      sDiagnose.add(cWARNINGText + ' (RID=' + RID + ') ' + Msg);
    // Ausgabe des Datensatzes unterdrücken
    RollBack := true;
  end;

  function FillFromAuftrag(s: string): string;
  var
    sResult: TStringList;
    i, n: integer;
    cErgebnis, cAuftrag, rAuftrag: integer;
    TrefferZeilenGesamt, TrefferZeilen: TgpIntegerList;
    sValues: TStringList;
  begin
    sValues := TStringList.create;
    sResult := Split(s, Separator);
    TrefferZeilenGesamt := nil;

    // Suche die aktuelle Zeile im Auftrag
    for i := 0 to pred(pAuftragAnker.count) do
    begin
      // Spalten bestimmen
      cErgebnis := header.indexof(pAuftragAnker[i]);
      if (cErgebnis = -1) then
        raise exception.create(format('Auftrags-Referenzspalte "%s" im Ergebnis nicht gefunden!', [pAuftragAnker[i]]));
      cAuftrag := Auftrag.header.indexof(pAuftragAnker[i]);
      if (cAuftrag = -1) then
        raise exception.create(format('Auftrags-Referenzspalte "%s" im Auftrag nicht gefunden!', [pAuftragAnker[i]]));
      // Wert suchen
      sValues.add('''' + sResult[cErgebnis] + '''');
      TrefferZeilen := Auftrag.locateDuplicates(cAuftrag, sResult[cErgebnis]);
      if assigned(TrefferZeilenGesamt) then
      begin
        // TrefferzeilenGesamt && TrefferZeilen
        for n := pred(TrefferZeilenGesamt.count) downto 0 do
          if TrefferZeilen.indexof(TrefferZeilenGesamt[n]) = -1 then
            TrefferZeilenGesamt.delete(n);
      end
      else
      begin
        TrefferZeilenGesamt := TgpIntegerList.create;
        TrefferZeilenGesamt.append(TrefferZeilen);
      end;
      TrefferZeilen.Free;
    end;

    if TrefferZeilenGesamt.count = 0 then
      raise exception.create(format(
        { } 'Suche von [%s values (%s)] im Auftrag ohne Treffer', [
        { } HugeSingleLine(pAuftragAnker, ','),
        { } HugeSingleLine(sValues, ',')]));
    if TrefferZeilenGesamt.count > 1 then
      raise exception.create(format(
        { } 'Suche von [%s values (%s)] im Auftrag brachte mehrere Treffer', [
        { } HugeSingleLine(pAuftragAnker, ','),
        { } HugeSingleLine(sValues, ',')]));

    rAuftrag := TrefferZeilenGesamt[0];

    // Nun Alle leeren Datenfelder füllen
    for cErgebnis := 0 to pred(sResult.count) do
      if (sResult[cErgebnis] = '') then
      begin
        // Spalte im Auftrag suchen
        cAuftrag := Auftrag.header.indexof(header[cErgebnis]);
        if (cAuftrag = -1) then
          raise exception.create(format('Spalte "%s" im Auftrag nicht gefunden', [header[cErgebnis]]));
        sResult[cErgebnis] := Auftrag.readCell(rAuftrag, cAuftrag);
      end;

    // Ergebnis
    result := HugeSingleLine(sResult, Separator);

    // Aufräumen
    sResult.Free;
    sValues.Free;
    TrefferZeilenGesamt.Free;
  end;

  function HitMask(Item, MaskList: string): String;
  var
   Mask,Mask_Internal: String;
   Item_Internal: String;
   n : Integer;
  begin
    result := '';
    repeat
      Mask := noblank(nextp(MaskList,','));
      if (Mask='') then
       break;
      if length(Item)<>length(Mask) then
       continue;
      Mask_Internal := Mask;
      Item_Internal := Item;
      ersetze('%','?',Mask_Internal);
      ersetze('*','?',Mask_Internal);
      for n := 1 to length(Mask_Internal) do
        if (Mask_Internal[n]='?') then
          Item_Internal[n] := '?';
      if (Mask_Internal=Item_Internal) then
      begin
        result := Mask;
        break;
      end;

    until eternity;
  end;

var
  Content: TStringList;
  OneCell: string;
  Content_S: string;
  r, c, z: integer;

  FixedFormats: TStringList;
  col_Alternative: integer;
  EmptyLine: string;
  ExcelFormats: TStringList;
  NoHeader: boolean;
  JoinColumn: string;

  // cache
  ZaehlerStandAlt, NA: string;
  ZaehlerStandNeu, NN: string;

  // Zählwerk-Logik
  ZaehlwerkNummer: Integer;
  Zaehlwerk, Zaehlwerk_Option, Zaehlwerk_Mask: String;
  Zaehlwerke, Zaehlwerke_Lager, Zaehlwerke_Einbau, Zaehlwerke_Optionen, Zaehlwerke_Work: String;
  Zaehlwerk_Option_AutoNull: boolean;
  Zaehlwerk_Option_Optional: boolean;
  Wilken_Zaehlwerke: TStringList;

  // Parameter
  MaxSpalte: integer;

  // Wilken
  slContent: TStringList;
  newContent: TStringList;
  col_tgw_altzaehlerflag: integer;
  col_tgw_id: integer;
  col_zae_nr_neu: integer;
  col_tgw_teilgeraetenr: integer;
  col_tgw_wandlerfaktor: integer;
  col_tgws_ablesestand: integer;
  col_tgws_ableseinfo: integer;
  col_gtw_lagerort_alt: integer;
  col_tgws_ablesedatum: integer;
  col_tgw_obiscode: integer;
  col_tgw_nachkomma: integer; // optionale Spalte
  col_tgw_vorkomma: integer; // optionale Spalte

  // weitere besondere Spalten die aus der EFRE Datei kommen
  col_Obis: integer;
  OBIS: string;
  TGW_ID: int64;

  col_Werk: integer;
  col_Lager: integer;
  col_Zaehlwerke_Ausbau, col_Zaehlwerke_Einbau, col_Zaehlwerke_Lager : Integer;
  // ============================================

  // ============================================
  // KK22
  ZaehlwerkeAusbau, ZaehlwerkeEinbau : Integer;
  col_Zaehler_Nummer: integer;
  col_ZaehlerStandAlt: integer;
  col_ZaehlerNummerNeu: integer;

  // ============================================

  {$ifdef fpc}
  n: TsWorkbook;
  {$else}
  n: TXLSFile;
  {$endif}

  // Formatierungen
  SonderFormat: string;
  AlternativeZelle: string;
  sDate: TAnFixDate;

  //
  FileNamePlus, FileNameBruchstueck, FileNameNeuerText : string;

begin
  header := TStringList.create;
  AllHeader := TStringList.create;
  FixedFormats := TStringList.create;
  Content := TStringList.create;
  ExcelFormats := TStringList.create;
  {$ifdef fpc}
  xImport := TsWorkbook.Create;
  {$else}
  xImport := TXLSFile.create(true);
  {$endif}
  ZaehlerStandAlt := '';
  NA := '';
  ZaehlerStandNeu := '';
  NN := '';
  Auftrag := TsTable.create;
  Wilken_Zaehlwerke := nil;

  with xImport do
  begin

    try
      {$ifdef fpc}
      xImport.ReadFromFile(InFName,sfExcel8);
      {$else}
      Open(InFName);
      {$endif}
    except
      on e: exception do
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' ' + e.message);
        sDiagnose.add(cERRORText + ' ' + InFName + ' ist durch andere Anwendung geöffnet?');
      end;
    end;

    sDiagFiles.add(InFName);

    if FileExists(WorkPath + cFixedFormatsFName) then
    begin
      sDiagFiles.add(WorkPath + cFixedFormatsFName);
      FixedFormats.loadFromFile(WorkPath + cFixedFormatsFName);
    end;

    // weitere Parameter
    Separator := FixedFormats.values['Separator'];
    if (Separator = '') then
      Separator := ';';
    NoHeader := FixedFormats.values['NoHeader'] = 'JA';
    JoinColumn := FixedFormats.values['JoinColumn'];
    MaxSpalte := strtointdef(FixedFormats.values['MaxColumn'], MaxInt);
    {$ifdef fpc}
    MaxSpalte := min(MaxSpalte, succ(ActiveWorksheet.GetLastColIndex));
    {$else}
    MaxSpalte := min(MaxSpalte, ColCountInRow(1));
    {$endif}
    pRespectFormats := FixedFormats.values['RespectFormats'] = 'JA';
    pDebugFormats := FixedFormats.values['OnlyFormats'] = 'JA';
    pWilken := FixedFormats.values['Wilken'] = 'JA';
    if not(pWilken) then
      pKK22 := FixedFormats.values['KK22'] = 'JA'
    else
      pKK22 := false;
    pAuftrag := FixedFormats.values['Auftrag'];
    if (pAuftrag <> '') then
      Auftrag.insertFromFile(WorkPath + pAuftrag);
    pAuftragAnker := Split(FixedFormats.values['AuftragReferenzSpalten'], ';', '', true);

    // Bestimmung des Ausgabe-Dateinamens
    pFileName := FixedFormats.values['FileName'];
    pFileNamePlus := FixedFormats.values['FileNamePlus'];
    if (pFileNamePlus='') then
     pFileNamePlus := '.unmoeglich|u';

    repeat

      if pKK22 then
      begin
        conversionOutFName := WorkPath + 'KK22_' + StrFilter(InFName, cZiffern);
        break;
      end;

      if (pFileName <> '') then
      begin

        // den Zusatz berechnen
        FileNamePlus := '';
        while (pFileNamePlus<>'') do
        begin
         FileNameBruchstueck := nextp(pFileNamePlus,'|');
         FileNameNeuerText := nextp(pFileNamePlus,';');
         if (pos(FileNameBruchstueck,InFName)>0) then
          FileNamePlus := FileNamePlus + FileNameNeuerText;
        end;

        ersetze('*',StrFilter(InFName, cZiffern),pFileName);
        ersetze('+',FileNamePlus,pFileName);
        conversionOutFName := WorkPath + pFileName;
        break;
      end;

      conversionOutFName := InFName + '.csv';

    until yet;

    // Init
    sDiagFiles.add(conversionOutFName);
    EmptyLine := fill(Separator, pred(MaxSpalte));

    {$ifdef fpc}
    if (ActiveWorksheet.GetLastRowIndex>=0) then
    for c := 1 to succ(ActiveWorksheet.GetLastColIndex) do
      AllHeader.add(getCell(1, c));
    {$else}
    if (RowCount >= 1) then
      for c := 1 to ColCountInRow(1) do
        AllHeader.add(getCell(1, c));
    {$endif}

    {$ifdef fpc}
    for r := 1 to succ(ActiveWorksheet.GetLastRowIndex) do
    {$else}
    for r := 1 to RowCount do
    {$endif}
    begin

      ZaehlwerkeAusbau := 0;
      ZaehlwerkeEinbau := 0;
      Content_S := '';

      {$ifdef fpc}
      for c := 1 to succ(ActiveWorksheet.GetLastColIndex) do
      {$else}
      for c := 1 to ColCountInRow(1) do
      {$endif}
      begin

        OneCell := getCell(r, c);

        if (r = 1) then
        begin

          // Spaltenname-Zelle der Kopfzeile
          if (c <= MaxSpalte) then
            header.add(OneCell);
        end
        else
        begin

          // Alternative ?
          if (OneCell = '') then
          begin
            AlternativeZelle := FixedFormats.values['Alternative_' + AllHeader[pred(c)]];
            while (AlternativeZelle <> '') do
            begin
              col_Alternative := AllHeader.indexof(nextp(AlternativeZelle, ';'));
              if (col_Alternative <> -1) then
                OneCell := OneCell + getCell(r, col_Alternative + 1)
              else
                raise exception.create('Alternative Spalte "' + AlternativeZelle + '" nicht gefunden!');
            end;
          end;

          // Zelle einer Datenzeile
          SonderFormat := FixedFormats.values['Column_' + inttostr(c)];
          if (SonderFormat = '') then
            SonderFormat := FixedFormats.values[AllHeader[pred(c)]];
          if (SonderFormat <> '') then
            repeat

              // für Dezimalpunkt mit 5 Nachkommastellen
              if (SonderFormat = '#.#####') then
              begin

                // Überhaupt was drin?
                if (OneCell = '') then
                  break;

                // Ist Wandlung Möglich?
                if (StrtoFloatdef(OneCell, -1) = -1) then
                  break;

                // Jetzt wandeln!
                OneCell := FloatToStrISO(StrtoFloatdef(OneCell, 0), 5);
                break;
              end;

              // Für Konstanten
              if (pos('''', SonderFormat) = 1) then
              begin
                OneCell := copy(SonderFormat, 2, MaxInt);
                break;
              end;

              // Filter ...
              if (pos('-', SonderFormat) = 1) then
              begin
                OneCell := StrFilter(OneCell, copy(SonderFormat, 2, MaxInt));
                break;
              end;
              if (pos('+', SonderFormat) = 1) then
              begin
                OneCell := StrFilter(OneCell, copy(SonderFormat, 2, MaxInt), true);
                break;
              end;

              // mit führenden Null auffüllen
              if (pos('0', SonderFormat) = 1) then
              begin

                // Überhaupt was drin?
                if (OneCell = '') then
                  break;

                OneCell := fill('0', strtointdef(copy(SonderFormat, 2, MaxInt), 0) - length(OneCell)) + OneCell;
                break;
              end;

              // Spezielle Datumsausgabe 1
              if (SonderFormat = 'TTMMJJ') then
              begin
                sDate := date2long(OneCell);
                if DateOK(sDate) then
                  OneCell := long2date6r(sDate);
                break;
              end;

              // Spezielle Datumsausgabe 2
              if (SonderFormat = 'JJJJ') then
              begin
                sDate := date2long(OneCell);
                if DateOK(sDate) then
                  OneCell := copy(long2date(sDate),7,4);
                break;
              end;

              // Spezielle Zeitangabe
              if (SonderFormat = 'hhmm') then
              begin
                OneCell := copy(StrFilter(OneCell, cZiffern), 1, 4);
                break;
              end;

            until yet;

          SonderFormat := FixedFormats.values['Max' + AllHeader[pred(c)]];
          if (SonderFormat <> '') then
          begin
            // Zellen-Länge beschränken
            OneCell := copy(OneCell, 1, strtointdef(SonderFormat, 0));
          end;

        end;

        repeat

          if (AllHeader[pred(c)] = 'ZaehlerStandAlt') then
          begin
            ZaehlerStandAlt := OneCell;
            if (OneCell <> '') then
              inc(ZaehlwerkeAusbau);
            break;
          end;

          if (AllHeader[pred(c)] = 'ReferenzIdentitaet') then
          begin
            RID := OneCell;
            break;
          end;

          if (AllHeader[pred(c)] = 'NA') then
          begin
            NA := OneCell;
            if (OneCell <> '') then
              inc(ZaehlwerkeAusbau);
            break;
          end;

          if (AllHeader[pred(c)] = 'ZaehlerStandNeu') then
          begin
            ZaehlerStandNeu := OneCell;
            if (OneCell <> '') then
              inc(ZaehlwerkeEinbau);
            break;
          end;

          if (AllHeader[pred(c)] = 'NN') then
          begin
            NN := OneCell;
            if (OneCell <> '') then
              inc(ZaehlwerkeEinbau);
            break;
          end;

        until yet;

        if (c <= MaxSpalte) then
        begin

          // Jetzt zu einer Zeile addieren!
          Content_S := Content_S + OneCell;

          // Separator nur dazumachen, wenn nicht unterdrückt!
          if (c <> MaxSpalte) then
            if (pos(IntToStrN(c, 3), JoinColumn) = 0) then
              Content_S := Content_S + Separator;

        end;

      end;

      // Erste Zeile überhaupt schreiben?
      if (r = 1) then
      begin
        if pWilken then
        begin
          Wilken_Zaehlwerke:= TStringList.create;
          with Wilken_Zaehlwerke do
          begin
           add('1-1:1.8.0');
           add('1-1:1.8.1');
           add('1-1:1.8.2');
           add('1-1:2.8.0');
           add('1-1:2.8.1');
           add('1-1:2.8.2');

           add('1-0:1.8.0');
           add('1-0:1.8.1');
           add('1-0:1.8.2');
           add('1-0:2.8.0');
           add('1-0:2.8.1');
           add('1-0:2.8.2');
          end;

          checkSpalte(col_tgw_altzaehlerflag, 'tgw_altzaehlerflag');
          checkSpalte(col_tgw_id, 'tgw_id');
          checkSpalte(col_zae_nr_neu, 'zae_nr_neu');
          checkSpalte(col_tgw_teilgeraetenr, 'tgw_teilgeraetenr');
          checkSpalte(col_tgw_wandlerfaktor, 'tgw_wandlerfaktor');
          checkSpalte(col_tgws_ablesestand, 'tgws_ablesestand');
          checkSpalte(col_tgws_ableseinfo, 'tgws_ableseinfo');
          checkSpalte(col_gtw_lagerort_alt, 'gtw_lagerort_alt');
          checkSpalte(col_tgws_ablesedatum, 'tgws_ablesedatum');
          checkSpalte(col_tgw_obiscode, 'tgw_obiscode');

          // weitere notwendige Spalten
          checkSpalte(col_Obis, 'Obis');
          checkSpalte(col_Werk, 'Werk');
          checkSpalte(col_Lager, 'Lager');

          // optionale Spalten
          checkSpalte(col_tgw_nachkomma, 'tgw_nachkomma', false);
          checkSpalte(col_tgw_vorkomma, 'tgw_vorkomma', false);
          checkSpalte(col_Zaehlwerke_Ausbau,'Zaehlwerke_Ausbau',false);
          checkSpalte(col_Zaehlwerke_Einbau,'Zaehlwerke_Einbau',false);
          checkSpalte(col_Zaehlwerke_Lager,'Zaehlwerke_Lager',false);

        end;

        if pKK22 then
        begin
          checkSpalte(col_Zaehler_Nummer, 'Zaehler_Nummer');
          checkSpalte(col_ZaehlerStandAlt, 'ZaehlerStandAlt');
          checkSpalte(col_ZaehlerNummerNeu, 'ZaehlerNummerNeu');
        end;

        if NoHeader then
          continue;
      end;

      // Ausgabe des Content
      if (Content_S = EmptyLine) then
        continue;

      if pWilken and (r > 1) then
      begin
        Rollback := false;
        newContent := TStringList.create;

        // 1. Block: AUSBAU
        slContent := Split(Content_S);

        // Modifier
        slContent[col_tgw_altzaehlerflag] := '0';
        slContent[col_zae_nr_neu] := '';
        slContent[col_tgw_wandlerfaktor] := '';
        if (col_tgw_nachkomma <> -1) then
          slContent[col_tgw_nachkomma] := '';
        if (col_tgw_vorkomma <> -1) then
          slContent[col_tgw_vorkomma] := '';

        if (col_Zaehlwerke_Ausbau<>-1) then
         Zaehlwerke := getCell(r,col_Zaehlwerke_Ausbau + 1)
        else
         Zaehlwerke := '';
        TGW_ID := StrToIntDef(slContent[col_tgw_id],0);
        ZaehlwerkNummer := 0;
        repeat
         inc(ZaehlwerkNummer);
         Zaehlwerk := noblank(nextp(Zaehlwerke,','));

         slContent[col_tgw_id] := IntToStr(TGW_ID + pred(ZaehlwerkNummer));
         slContent[col_tgw_teilgeraetenr] := IntToStr(ZaehlwerkNummer);
         slContent[col_tgw_obiscode] := Zaehlwerk;

         case Wilken_Zaehlwerke.IndexOf(Zaehlwerk) of
          {1-?:1.8.0}0,6:slContent[col_tgws_ablesestand] := ZaehlerStandAlt;
          {1-?:1.8.1}1,7:slContent[col_tgws_ablesestand] := getCell(r,'A181');
          {1-?:1.8.2}2,8:slContent[col_tgws_ablesestand] := getCell(r,'NA');
          {1-?:2.8.0}3,9:slContent[col_tgws_ablesestand] := getCell(r,'A280');
          {1-?:2.8.1}4,10:slContent[col_tgws_ablesestand] := getCell(r,'A281');
          {1-?:2.8.2}5,11:slContent[col_tgws_ablesestand] := getCell(r,'A282');
         else
           slContent[col_tgws_ablesestand] := ZaehlerStandAlt;
         end;
         if (slContent[col_tgws_ablesestand]='') then
         begin
          failBecause('Ausbau ' + Zaehlwerk + ' ist ohne Eintrag');
         end else
         begin
          newContent.add(HugeSingleLine(slContent, Separator));
         end;
        until (Zaehlwerke='');
        slContent.Free;

        // 2. Block EINBAU
        slContent := Split(Content_S);

        // Modifier
        slContent[col_tgw_altzaehlerflag] := '1';
        slContent[col_tgw_id] := '';
        slContent[col_tgws_ableseinfo] := '';
        slContent[col_gtw_lagerort_alt] := '';
        slContent[col_tgws_ablesedatum] := long2date(DatePlus(date2long(slContent[col_tgws_ablesedatum]), 1));

        if (col_tgw_nachkomma <> -1) then
          slContent[col_tgw_nachkomma] := getCell(r, succ(col_Werk));
        if (col_tgw_vorkomma <> -1) then
          slContent[col_tgw_vorkomma] := getCell(r, succ(col_Lager));

        // aus Lager
        if (col_Zaehlwerke_Lager<>-1) then
          Zaehlwerke_Lager := getCell(r,col_Zaehlwerke_Lager + 1)
        else
          Zaehlwerke_Lager := '';

        // vom OrgaMon
        if (col_Zaehlwerke_Einbau<>-1) then
          Zaehlwerke_Einbau := getCell(r,col_Zaehlwerke_Einbau + 1)
        else
          Zaehlwerke_Einbau := '';

        // aus Lager+OrgaMon nun Zählwerke berechnen
        repeat

           if (Zaehlwerke_Lager='') then
           begin
            Zaehlwerke := Zaehlwerke_Einbau;
            break;
           end;

           // wir haben Lager-Zählwerke
           Zaehlwerke := '';
           Zaehlwerke_Optionen := '';
           Zaehlwerke_Work := Zaehlwerke_Lager;
           repeat
             Zaehlwerk := noblank(nextp(Zaehlwerke_Work,','));
             if (Zaehlwerk='') then
              break;
             Zaehlwerk_Mask := HitMask(Zaehlwerk,Zaehlwerke_Einbau);

              if (Zaehlwerk_Mask<>'') then
              begin
                if (Zaehlwerke='') then
                begin
                 Zaehlwerke := Zaehlwerk;
                 Zaehlwerke_Optionen := Zaehlwerk_Mask;
                end else
                begin
                 Zaehlwerke := Zaehlwerke + ',' + Zaehlwerk;
                 Zaehlwerke_Optionen := Zaehlwerke_Optionen + ',' + Zaehlwerk_Mask;
                end;
              end;

           until eternity;

        until yet;

        if (ZaehlWerke='') then
        begin
          FailBecause(
           {} 'keine Zählwerksbezeichnung passt:'+
           {} ' aus Einbau="'+Zaehlwerke_Einbau+'"'+
           {} ' aus Lager="'+Zaehlwerke_Lager+'"');
        end else
        begin
          ZaehlwerkNummer := 0;
          repeat

            inc(ZaehlwerkNummer);
            Zaehlwerk := noblank(nextp(Zaehlwerke,','));
            Zaehlwerk_Option := noblank(nextp(Zaehlwerke_Optionen,','));

            Zaehlwerk_Option_AutoNull:= (pos('%',Zaehlwerk_Option)>0);
            Zaehlwerk_Option_Optional:= (pos('*',Zaehlwerk_Option)>0);

            slContent[col_tgw_obiscode] := Zaehlwerk;
            slContent[col_tgw_teilgeraetenr] := IntToStr(ZaehlwerkNummer);

            case Wilken_Zaehlwerke.IndexOf(Zaehlwerk) of
             {1-?:1.8.0}0,6:slContent[col_tgws_ablesestand] := ZaehlerStandNeu;
             {1-?:1.8.1}1,7:slContent[col_tgws_ablesestand] := getCell(r,'E181');
             {1-?:1.8.2}2,8:slContent[col_tgws_ablesestand] := getCell(r,'NN');
             {1-?:2.8.0}3,9:slContent[col_tgws_ablesestand] := getCell(r,'E280');
             {1-?:2.8.1}4,10:slContent[col_tgws_ablesestand] := getCell(r,'E281');
             {1-?:2.8.2}5,11:slContent[col_tgws_ablesestand] := getCell(r,'E282');
            else
              slContent[col_tgws_ablesestand] := ZaehlerStandNeu;
            end;

            if Zaehlwerk_Option_AutoNull then
              if (slContent[col_tgws_ablesestand]='') then
                slContent[col_tgws_ablesestand] := '0';

            if (slContent[col_tgws_ablesestand]='') then
            begin
              if not(Zaehlwerk_Option_Optional) then
                FailBecause('Einbau ' + Zaehlwerk + ' ist ohne Eintrag');
            end else
            begin
              newContent.add(HugeSingleLine(slContent, Separator));
            end;

          until (Zaehlwerke='');
        end;
        slContent.Free;

        if not(Rollback) then
         Content.AddStrings(newContent);

        newContent.Free;

        continue;
      end;

      if pKK22 and (r > 1) then
      begin

        // 1. Block: AUSBAU
        for z := 1 to max(1, ZaehlwerkeAusbau) do
        begin
          slContent := Split(Content_S);

          // Modifier
          case z of
            1:
              slContent[col_ZaehlerStandAlt] := ZaehlerStandAlt;
            2:
              slContent[col_ZaehlerStandAlt] := NA;
          end;

          Content.add(HugeSingleLine(slContent, Separator));
          slContent.Free;
        end;

        // 2. Block EINBAU
        for z := 1 to max(1, ZaehlwerkeEinbau) do
        begin
          slContent := Split(Content_S);

          // Modifier
          slContent[col_Zaehler_Nummer] := getCell(r, succ(col_ZaehlerNummerNeu));

          case z of
            1:
              slContent[col_ZaehlerStandAlt] := ZaehlerStandNeu;

            2:
              slContent[col_ZaehlerStandAlt] := NN;
          end;

          Content.add(HugeSingleLine(slContent, Separator));
          slContent.Free;
        end;

        continue;
      end;

      // natives Erstellen, ohne "Wilken" oder "KK22"
      if (pAuftrag <> '') and (r > 1) then
        Content_S := FillFromAuftrag(Content_S);
      Content.add(Content_S);

    end;
  end;
  xImport.Free;
  try
    {$ifdef fpc}
    Content.SaveToFile(conversionOutFName,Tencoding.ANSI);
    {$else}
    Content.SaveToFile(conversionOutFName);
    {$endif}
  except
    on e: exception do
    begin
      inc(ErrorCount);
      sDiagnose.add(cERRORText + ' ' + e.message);
      sDiagnose.add(cERRORText + ' ' + conversionOutFName + ' ist durch andere Anwendung geöffnet?');
    end;
  end;
  sDiagnose.addStrings(ExcelFormats);
  ExcelFormats.Free;
  Content.Free;
  header.Free;
  AllHeader.Free;
  FixedFormats.Free;
  Auftrag.Free;
  pAuftragAnker.Free;
  if assigned(Wilken_Zaehlwerke) then
   Wilken_Zaehlwerke.Free;
end;

procedure csvMap(InFName: string);
var
  CSV: TsTable;
  Umsetzer: TFieldMapping;
  c, r, zaehlwerk: integer;
  UmsetzerFName: string;
  k: integer;
begin
  CSV := TsTable.create;
  Umsetzer := TFieldMapping.create;
  Umsetzer.Path := WorkPath;
  CSV.insertFromFile(InFName);
  sDiagFiles.add(InFName);

  // prüfen, ob eine Zählwerksspalte angehängt werden soll
  with CSV do
  begin
    if isHeader('ID') then
      if isHeader('Zählernummer') then
        if not(isHeader('Zählwerk')) then
        begin
          sDiagnose.Add('MEA: Spalte "Zählwerk" wird ergänzt!');
          addCol('Zählwerk','1');
          Zaehlwerk := 2;
          for r := 2 to RowCount do
            if (readCell(r,'Zählernummer')=readCell(pred(r),'Zählernummer')) then
            begin
              writeCell(r,'Zählwerk',IntToStr(Zaehlwerk));
              inc(Zaehlwerk);
            end else
            begin
              Zaehlwerk := 2;
            end;
        end;
  end;

  conversionOutFName := InFName;
  k := revPos('.', conversionOutFName);
  conversionOutFName := copy(conversionOutFName, 1, pred(k)) + '-mapped.csv';
  sDiagFiles.add(conversionOutFName);

  with CSV do
  begin
    //
    for c := 0 to pred(header.count) do
    begin
      UmsetzerFName := WorkPath + header[c] + cMapping_FileExtension;
      if FileExists(UmsetzerFName) then
        sDiagFiles.add(UmsetzerFName);
      for r := 1 to RowCount do
        writeCell(r, c, Umsetzer[header[c], readCell(r, c)]);
    end;

    //
    SaveToFile(conversionOutFName);
  end;

  CSV.Free;
  Umsetzer.Free;
  sDiagnose.AddStrings(sDiagFiles);
end;

procedure xls2Flood(InFName: string);
var
  {$ifdef fpc}
  xImport: TsWorkBook;
  {$else}
  xImport: TXLSFile;
  {$endif}
  Auftrag: TsTable;
  pSeparator: string;
  header, AllHeader: TStringList;

  // weitere Parameter
  pAuftrag: TStringList;
  pAuftragAnker: TStringList;
  pAuftragFlood: TStringList;

  function getCell(r, c: integer): string;
  var
    IsConverted: boolean;
    v: Variant;
    {$ifdef fpc}
    Cell: PCell;
    {$else}
    xFmt: TFlxFormat;
    {$endif}
    FormatStr: string;
    d: TDateTime;
  begin
    with xImport do
    begin
      try

        {$ifdef fpc}
        Cell := ActiveWorksheet.Cells.FindCell(pred(r),pred(c));
        repeat
          //
          if not(assigned(Cell)) then
          begin
            v := '';
            break;
          end;

          if (Cell^.ContentType=cctNumber) or (Cell^.ContentType=cctDateTime) then
          begin
            v := ActiveWorksheet.ReadAsNumber(pred(r), pred(c));
            break;
          end;

          v := ActiveWorksheet.ReadAsText(pred(r), pred(c));
         until yet;
        {$else}
        v := getCellValue(r, c);
        {$endif}
        IsConverted := false;
        repeat

          // 1. Es muss Double sein
          if (TVarData(v).VType <> varDouble) then
            break;

          // 2a. Es muss ein Format haben
          {$ifdef fpc}
          FormatStr := AnsiUpperCase(ReadFormatStr(xImport, r, c));
          {$else}
          if (getCellFormat(r, c) < 0) or (getCellFormat(r, c) >= FormatCount) then
            break;
          xFmt := GetFormat(getCellFormat(r, c));
          FormatStr := AnsiupperCase(xFmt.format);
          {$endif}

          // 2b. Es muss ein Format haben
          if (FormatStr = '') then
            break;

          // 3. Es muss ein Datumsformat haben
          if (pos('YY', FormatStr) > 0) and (pos('H', FormatStr) > 0) then
          begin
            // ganzer Timestamp
            d := v;
            result := long2date(d) + ' ' + SecondsToStr(d);
            IsConverted := true;
            break;
          end;

          if (pos('YY', FormatStr) > 0) then
          begin
            // Datum
            d := v;
            result := long2date(d);
            IsConverted := true;
            break;
          end;

          if (pos('H', FormatStr) > 0) then
          begin
            // Uhrzeit
            d := v;
            result := SecondsToStr(d);
            IsConverted := true;
            break;
          end;

        until yet;

        //
        if not(IsConverted) then
          result := v;

      except
        on e: exception do
        begin
          inc(ErrorCount);
          sDiagnose.add(cERRORText + ' ' + e.message);
          result := cERRORText + ' ' + e.message;
        end;
      end;

      // Überzählige Semikolons entfernen!
      ersetze(pSeparator, '', result);

      // "LF" durch "|" ersetzen
      ersetze(#$0A, '|', result);
    end;
  end;

  procedure checkSpalte(var col: integer; sName: string);
  begin
    col := header.indexof(sName);
    if col = -1 then
    begin
      inc(ErrorCount);
      sDiagnose.add(cERRORText + ' Spalte ' + sName + ' nicht gefunden!');
    end;
  end;

  function FillIntoAuftrag(s: string): string;
  var
    sResult: TStringList;
    i, n, a: integer;
    cErgebnis, cAuftrag, rAuftrag: integer;
    TrefferZeilenGesamt, TrefferZeilen: TgpIntegerList;
    sValues: TStringList;
    cErgebnisIndex: TgpIntegerList;
  begin
    sValues := TStringList.create;
    cErgebnisIndex := TgpIntegerList.create;
    sResult := Split(s, pSeparator);

    // Suche vorbereiten
    for i := 0 to pred(pAuftragAnker.count) do
    begin
      // Spalten bestimmen
      cErgebnis := header.indexof(pAuftragAnker[i]);
      if (cErgebnis = -1) then
        raise exception.create(format('Referenzspalte "%s" im Ergebnis nicht gefunden!', [pAuftragAnker[i]]));
      sValues.add(killLeadingZero(sResult[cErgebnis]));
      cErgebnisIndex.add(cErgebnis);
    end;

    TrefferZeilenGesamt := nil;

    // Alle Aufträge durchsuchen
    for a := 0 to pred(pAuftrag.count) do
    begin
      Auftrag := pAuftrag.Objects[a] as TsTable;

      if assigned(TrefferZeilenGesamt) then
        FreeAndNil(TrefferZeilenGesamt);

      // Suche die aktuelle Zeile im Auftrag
      for i := 0 to pred(pAuftragAnker.count) do
      begin

        // In welcher Spalte muss hier gesucht werden?
        cAuftrag := Auftrag.header.indexof(pAuftragAnker[i]);
        if (cAuftrag = -1) then
          raise exception.create(format('Referenzspalte "%s" im Auftrag "%s" nicht gefunden!',
            [pAuftragAnker[i], pAuftrag[a]]));

        // Wert suchen
        TrefferZeilen := Auftrag.locateDuplicates(cAuftrag, sValues[i], TsIgnoreLeadingZeros);

        if assigned(TrefferZeilenGesamt) then
        begin
          // TrefferzeilenGesamt && TrefferZeilen
          for n := pred(TrefferZeilenGesamt.count) downto 0 do
            if TrefferZeilen.indexof(TrefferZeilenGesamt[n]) = -1 then
              TrefferZeilenGesamt.delete(n);
        end
        else
        begin
          TrefferZeilenGesamt := TgpIntegerList.create;
          TrefferZeilenGesamt.append(TrefferZeilen);
        end;
        TrefferZeilen.Free;

        // ! Short cut bei 0 Treffern
        if (TrefferZeilenGesamt.count = 0) then
          break;

      end;

      if assigned(TrefferZeilenGesamt) then
        if (TrefferZeilenGesamt.count = 1) then
          break;

    end;

    if not(assigned(TrefferZeilenGesamt)) then
      TrefferZeilenGesamt := TgpIntegerList.create;

    if (TrefferZeilenGesamt.count = 0) then
      raise exception.create(format(
        { } 'Suche von [%s values (%s)] im Auftrag ohne Treffer', [
        { } HugeSingleLine(pAuftragAnker, ','),
        { } HugeSingleLine(sValues, ',')]));

    if (TrefferZeilenGesamt.count > 1) then
      raise exception.create(format(
        { } 'Suche von [%s values (%s)] im Auftrag brachte mehrere Treffer', [
        { } HugeSingleLine(pAuftragAnker, ','),
        { } HugeSingleLine(sValues, ',')]));

    // Zeile, in die eingetragen wird
    rAuftrag := TrefferZeilenGesamt[0];

    // Nun alle leeren Datenfelder füllen
    for i := 0 to pred(pAuftragFlood.count) do
    begin
      // Quell-Spalte ermitteln
      cErgebnis := header.indexof(pAuftragFlood[i]);
      if (cErgebnis = -1) then
        raise exception.create(format('Floodspalte "%s" im Ergebnis nicht gefunden', [pAuftragFlood[i]]));

      // Ziel-Spalte im Auftrag suchen
      cAuftrag := Auftrag.header.indexof(pAuftragFlood[i]);
      if (cAuftrag = -1) then
        raise exception.create(format('Zielspalte "%s" im Auftrag nicht gefunden', [pAuftragFlood[i]]));

      // vom Ergebnis in den Auftrag übertragen
      Auftrag.writeCell(rAuftrag, cAuftrag, sResult[cErgebnis]);
    end;

    // Ergebnis
    result := HugeSingleLine(sResult, pSeparator);

    // Aufräumen
    sResult.Free;
    sValues.Free;
    TrefferZeilenGesamt.Free;
  end;

  procedure SaveAuftrag;
  var
    FName: string;
    i: integer;
  begin
    for i := 0 to pred(pAuftrag.count) do
    begin
      Auftrag := pAuftrag.Objects[i] as TsTable;
      FName := conversionOutFName;
      ersetze('.xls.csv', '-' + inttostr(i + 1) + '.xls', FName);
      Auftrag.SaveToFile(FName);
      sDiagFiles.add(FName);
    end;
  end;

var
  Content: TStringList;
  OneCell: string;
  Content_S: string;
  i, r, c, z: integer;

  FixedFloods: TStringList;
  col_Alternative: integer;
  ExcelFormats: TStringList;
  NoHeader: boolean;

  // cache
  ZaehlerStandAlt, NA: string;
  ZaehlerStandNeu, NN: string;

  // Wilken
  ZaehlwerkeEinbau: integer;
  ZaehlwerkeAusbau: integer;

  {$ifdef fpc}
  n: TsWorkbook;
  {$else}
  n: TXLSFile;
  {$endif}
  Content_Wilken: TStringList;

  // Formatierungen
  SonderFormat: string;
  AlternativeZelle: string;
  sDate: TAnFixDate;

begin
  header := TStringList.create;
  AllHeader := TStringList.create;
  FixedFloods := TStringList.create;
  Content := TStringList.create;
  ExcelFormats := TStringList.create;
  pAuftrag := TStringList.create;
  {$ifdef fpc}
  xImport := TsWorkbook.Create;
  {$else}
  xImport := TXLSFile.create(true);
  {$endif}
  ZaehlerStandAlt := '';
  NA := '';
  ZaehlerStandNeu := '';
  NN := '';
  Auftrag := TsTable.create;

  with xImport do
  begin

    try
      {$ifdef fpc}
      xImport.ReadFromFile(InFName,sfExcel8);
      {$else}
      Open(InFName);
      {$endif}
    except
      on e: exception do
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' ' + e.message);
        sDiagnose.add(cERRORText + ' ' + InFName + ' ist durch andere Anwendung geöffnet?');
      end;
    end;

    sDiagFiles.add(InFName);
    conversionOutFName := InFName + '.csv';
    sDiagFiles.add(conversionOutFName);

    if FileExists(WorkPath + cFixedFloodFName) then
    begin
      sDiagFiles.add(WorkPath + cFixedFloodFName);
      {$ifdef fpc}
      FixedFloods.loadFromFile(WorkPath + cFixedFloodFName, TEncoding.ANSI);
      {$else}
      FixedFloods.loadFromFile(WorkPath + cFixedFloodFName);
      {$endif}
    end;

    // weitere Parameter
    pSeparator := FixedFloods.values['Separator'];
    if (pSeparator = '') then
      pSeparator := ';';
    NoHeader := FixedFloods.values['NoHeader'] = 'JA';

    dir(WorkPath + FixedFloods.values['Auftrag'], pAuftrag, false);
    for i := 0 to pred(pAuftrag.count) do
    begin
      Auftrag := TsTable.create;
      Auftrag.oSeparator := pSeparator;
      Auftrag.insertFromFile(WorkPath + pAuftrag[i]);
      pAuftrag.Objects[i] := Auftrag;
    end;

    pAuftragAnker := Split(FixedFloods.values['AuftragReferenzSpalten'], ';', '', false);
    pAuftragFlood := Split(FixedFloods.values['AuftragFlood'], ';', '', false);

    {$ifdef fpc}
    if (ActiveWorksheet.GetLastRowIndex>=0) then
      for c := 1 to succ(ActiveWorksheet.GetLastColIndex) do
        AllHeader.add(getCell(1, c));
    {$else}
    if (RowCount >= 1) then
      for c := 1 to ColCountInRow(1) do
        AllHeader.add(getCell(1, c));
    {$endif}

    {$ifdef fpc}
    for r := 1 to succ(ActiveWorksheet.GetLastRowIndex) do
    {$else}
    for r := 1 to RowCount do
    {$endif}
    begin

      Content_S := '';
      ZaehlwerkeAusbau := 0;
      ZaehlwerkeEinbau := 0;

      {$ifdef fpc}
      for c := 1 to succ(ActiveWorksheet.GetLastColIndex) do
      {$else}
      for c := 1 to ColCountInRow(1) do
      {$endif}
      begin

        OneCell := getCell(r, c);

        if (r = 1) then
        begin

          // Zelle einer Kopfzeile
          header.add(OneCell);
        end
        else
        begin

          // Alternative ?
          if (OneCell = '') then
          begin
            AlternativeZelle := FixedFloods.values['Alternative_' + AllHeader[pred(c)]];
            if (AlternativeZelle <> '') then
            begin
              col_Alternative := AllHeader.indexof(AlternativeZelle);
              if (col_Alternative <> -1) then
                OneCell := getCell(r, col_Alternative + 1)
              else
                raise exception.create('Alternative Spalte "' + AlternativeZelle + '" nicht gefunden!');
            end;
          end;

          // Zelle einer Datenzeile
          SonderFormat := FixedFloods.values['Column_' + inttostr(c)];
          if (SonderFormat = '') then
            SonderFormat := FixedFloods.values[AllHeader[pred(c)]];
          if (SonderFormat <> '') then
            repeat

              // für SÜWAG
              if (SonderFormat = '#.#####') then
              begin

                // Überhaupt was drin?
                if (OneCell = '') then
                  break;

                // Wandelung Möglich?
                if (StrtoFloatdef(OneCell, -1) = -1) then
                  break;

                // Jetzt wandeln!
                OneCell := FloatToStrISO(StrtoFloatdef(OneCell, 0), 5);
                break;
              end;

              // Für Konstanten
              if (pos('''', SonderFormat) = 1) then
              begin
                OneCell := copy(SonderFormat, 2, MaxInt);
                break;
              end;

              // Filter ...
              if (pos('-', SonderFormat) = 1) then
              begin
                OneCell := StrFilter(OneCell, copy(SonderFormat, 2, MaxInt));
                break;
              end;
              if (pos('+', SonderFormat) = 1) then
              begin
                OneCell := StrFilter(OneCell, copy(SonderFormat, 2, MaxInt), true);
                break;
              end;

              // mit führenden Null auffüllen
              if (pos('0', SonderFormat) = 1) then
              begin

                // Überhaupt was drin?
                if (OneCell = '') then
                  break;

                OneCell := fill('0', strtointdef(copy(SonderFormat, 2, MaxInt), 0) - length(OneCell)) + OneCell;
                break;
              end;

              // Spezielle Datumsausgabe
              if (SonderFormat = 'TTMMJJ') then
              begin
                sDate := date2long(OneCell);
                if DateOK(sDate) then
                  OneCell := long2date6r(sDate);
                break;
              end;

            until yet;

          SonderFormat := FixedFloods.values['Max' + AllHeader[pred(c)]];
          if (SonderFormat <> '') then
          begin
            // Zellen-Länge beschränken
            OneCell := copy(OneCell, 1, strtointdef(SonderFormat, 0));
          end;

        end;

        if (AllHeader[pred(c)] = 'ZaehlerStandAlt') then
        begin
          ZaehlerStandAlt := OneCell;
          if (OneCell <> '') then
            inc(ZaehlwerkeAusbau);
        end;

        if (AllHeader[pred(c)] = 'NA') then
        begin
          NA := OneCell;
          if (OneCell <> '') then
            inc(ZaehlwerkeAusbau);
        end;

        if (AllHeader[pred(c)] = 'ZaehlerStandNeu') then
        begin
          ZaehlerStandNeu := OneCell;
          if (OneCell <> '') then
            inc(ZaehlwerkeEinbau);
        end;

        if (AllHeader[pred(c)] = 'NN') then
        begin
          NN := OneCell;
          if (OneCell <> '') then
            inc(ZaehlwerkeEinbau);
        end;

        // Jetzt zu einer Zeile addieren!
        Content_S := Content_S + OneCell;

        // Separator nur dazumachen, wenn nicht unterdrückt!
        Content_S := Content_S + pSeparator;

      end;

      // Erste Zeile überhaupt schreiben?
      if (r = 1) then
      begin
        if NoHeader then
          continue;
      end;

      if (r > 1) then
        Content_S := FillIntoAuftrag(Content_S);

      Content.add(Content_S);

    end;
  end;
  xImport.Free;
  try
    {$ifdef fpc}
    Content.SaveToFile(conversionOutFName, Tencoding.ANSI);
    {$else}
    Content.SaveToFile(conversionOutFName);
    {$endif}
    SaveAuftrag;
  except
    on e: exception do
    begin
      inc(ErrorCount);
      sDiagnose.add(cERRORText + ' ' + e.message);
      sDiagnose.add(cERRORText + ' ' + conversionOutFName + ' ist durch andere Anwendung geöffnet?');
    end;
  end;

  sDiagnose.addStrings(ExcelFormats);
  ExcelFormats.Free;
  Content.Free;
  header.Free;
  AllHeader.Free;
  FixedFloods.Free;
  Auftrag.Free;
  pAuftragAnker.Free;
  pAuftrag.Free;
end;

procedure KK20toCSV(InFName: string; sBericht: TStringList = nil);

const
  // Infos zum Objekt und Zähler
  KK20_Header = 'ckk20;bukrs;meterreadingunit;vertrag;v_name1;v_name2;v_pstlz;v_ort01;v_stra;einzdat;' +
    'vbez;portion;abwann;street;hausnum;plz;city;vorname;nachname;' +
    'text;tariftyp;code_sparte;text30;tplnr;gp_pstlz;gp_ort01;gp_stras;' +
    'gp_haus_num;gp_haus_alph;swerk;st_ktext;stortzus;hinweis;istablart;' +
    'gasdru;gastem;brwgeb;tempgeb;drugeb;kombinat;matnr;herst_kz;ansjj;baujj;' +
    'bgljahr;einbdat;sernr;equnr;herst;besitz;lager;gangfolge;mrreason;ausdat;' +
    'austim;usid;targetmrdate;meterreader;maktx;preiskla;zwgruppe;kzwechsel;ext_ui;' +
    'kk20_resv1;kk20_resv2;kk20_resv3;kk20_resv4;kk20_resv5;v_telnr;v_house_num2;house_num2;' +
    'exvko;kk20_resv6;rolle_partner;anrede;kk20_resv7;kk20_resv8;typ;art';

  // Infos zum Zählwerk
  KK21_Header = 'ckk21;kk21_bukrs;ablbelnr;pruefzahl;zwart;register;zwtyp;stanzvor;stanznac;zwfakt;zwkenn;abrfakt;' +
    'thgber;l_adat;l_zstand;l_ablesgr;l_ablhinw;aemme;aemmen;aempc;scode;erwzstd_min;erwzstd_max;kennziff;' +
    'anzart;bliwirk;massread;kk21_resv1;kk21_resv2;kk21_resv3;kk21_resv4';

  function header: string;
  begin
    result := KK20_Header + ';zaehlwerk;' + KK21_Header;
  end;

  procedure EnsureCountTo(s: TStrings; FixedCount: integer);
  var
    r: integer;
  begin
    for r := succ(s.count) to FixedCount do
      s.add('');
    for r := pred(s.count) downto FixedCount do
      s.delete(r);
  end;

var
  sImport: TStringList;
  sOut: TStringList;
  n, z: integer;
  MainLine, FormatTag: string;
  slObjekt, slZaehlwerk: TStringList;
  KK20_Columns, KK21_Columns: integer;

begin
  conversionOutFName := InFName + '.csv';

  KK20_Columns := succ(CharCount(';', KK20_Header));
  KK21_Columns := succ(CharCount(';', KK21_Header));

  sImport := TStringList.create;
  sOut := TStringList.create;
  sImport.loadFromFile(InFName);
  MainLine := '';
  z := -1;
  slObjekt := nil;
  slZaehlwerk := nil;
  sOut.add(header);
  for n := 0 to pred(sImport.count) do
  begin
    FormatTag := nextp(sImport[n], ';', 0);
    if (FormatTag = 'KK20') then
    begin
      z := 1;
      if assigned(slObjekt) then
        FreeAndNil(slObjekt);
      slObjekt := Split(sImport[n]);
      EnsureCountTo(slObjekt, KK20_Columns);
    end
    else
    begin

      slZaehlwerk := Split(sImport[n]);
      EnsureCountTo(slZaehlwerk, KK21_Columns);

      sOut.add(
        { } HugeSingleLine(slObjekt, ';') +
        { } ';' + inttostr(z) + ';' +
        { } HugeSingleLine(slZaehlwerk, ';'));
      slZaehlwerk.Free;
      inc(z);
    end;
  end;
  sOut.SaveToFile(conversionOutFName);
  sOut.Free;
  sImport.Free;
end;

procedure doKK22(InFName: string; sBericht: TStringList = nil);
const
  c_KK20_Sparte = 21;
  c_KK20_SerialNo = 46;
  c_KK20_ext_ui = 62;
  c_KK20_kombinat = 39;

  //
  c_KK21_bukrs = 1;
  c_KK21_ablbelnr = 2;
  c_KK21_pruefzahl = 3;
  c_KK21_zwtyp = 4;
  c_KK21_register = 5;
  c_KK21_NachKommaStellen = 8;

  //
  c_KK21_l_zstand = 14;
  c_KK21_erwstd_min = 21;
  c_KK21_erwstd_max = 22;
  c_KK21_kennzif = 23;
  c_KK21_massread = 26;
  c_KK21_resv2 = 28;

var
  Content: TStringList;
  sZaehler: TStringList;
  sZaehlerIndex: integer;
  {$ifdef fpc}
  xImport: TsWorkbook;
  {$else}
  xImport: TXLSFile;
  {$endif}
  r, c: integer;
  header: TStringList;
  FixedFormats: TStringList;

  //
  xls_col_ZaehlerNummer: integer;
  xls_col_Art: integer;
  xls_col_AbleseDatum: integer;
  xls_col_AbleseUhr: integer;
  xls_col_AbleseWertHT: integer;
  xls_col_AbleseWertNT: integer;
  xls_col_RID: integer;
  xls_col_ZZ: integer;

  procedure createKK22;
  var
    MySourceStrings: TStringList;
    n, xls_Row: integer;
    K21_count: integer;
    K21_HT_ok: boolean;
    K21_NT_ok: boolean;

    Stat_ergebnisse: integer;
    Stat_Restanten: integer;
    Stat_Zaehler: integer;
    Stat_Unplausibel: integer;
    Stat_NegativerVerbrauch: integer;
    Stat_OhneWert: integer;
    Stat_NT_fehlt: integer;
    // Zwischenwerte
    ZAEHLER_NUMMER: string;
    Zaehler_Stand: string;
    iSparte: integer;
    sSparte: string;

    AUFTRAG_R: integer;
    ZZ: boolean;

    EingabeDatum: string;
    EingabeDatumAsAnfix: TAnFixDate;
    EingabeUhr: string;
    xDateTime: TDateTime;
    ext_ui: string;
    kombinat: string;

    SAPmapping: string;

    // Plausibilität
    LowerBound: double;
    HigherBound: double;
    LetzterStand: double;
    ZaehlerStand: double;

    _lowerBound: string;
    _HigherBound: string;
    _letzterStand: string;
    kennzif: string;
    NachKommaStellen: integer;
    Plausibel: boolean;
    d1, d2, d3: double;

    function Format_ZaehlerNummer(z: string): string;
    begin
      if (pos('-', z) > 0) then
        z := nextp(z, '-', 1);
      result := fill('0', 10 - length(z)) + z;
    end;

    function Format_ZaehlerStand(s: string): string;
    begin
      if (K21_count = 7) then
      begin
        //
        result := noblank(s);
      end
      else
      begin
        //
        if (NachKommaStellen = 0) then
          result := nextp(s, '.', 0)
        else
          result := s;
        result := fill(' ', 12 - length(result)) + result;
      end;
    end;

    function Format_Eingabedatum(s: string): string;
    begin
      result := copy(s, 1, 2) + copy(s, 4, 2) + copy(s, 7, 4);
    end;

    function Format_Eingabezeit(s: string): string;
    begin
      result := copy(s, 1, 2) + copy(s, 4, 2);
    end;

    function Format_herkunft(s: string): string;
    begin
      if (s = '00:00:00') or ZZ then
        result := '02'
        // Kundenablesung
      else
        result := '01'; // Ableser
    end;

    function shortenSerial(s: string): string;
    begin
      result := s;
      while (pos('0', result) = 1) do
        delete(result, 1, 1);
    end;

    procedure AppendSource(FName: string);
    var
      sXML: TStringList;
    begin
      sXML := TStringList.create;
      sXML.loadFromFile(FName);
      MySourceStrings.addStrings(sXML);
      sXML.Free;
    end;

    function AuftragsMaske: string;
    begin
      result := WorkPath + 'EXPORT*.txt';
    end;

    procedure LoadSource;
    var
      sDir: TStringList;
      n: integer;
    begin
      sDir := TStringList.create;
      dir(AuftragsMaske, sDir);
      for n := 0 to pred(sDir.count) do
      begin
        AppendSource(WorkPath + sDir[n]);
        sDiagFiles.add(WorkPath + sDir[n]);
      end;
      sDir.Free;
    end;

  begin

    //
    Stat_ergebnisse := 0;
    Stat_Restanten := 0;
    Stat_Zaehler := 0;
    Stat_Unplausibel := 0;
    Stat_OhneWert := 0;
    Stat_NT_fehlt := 0;
    Stat_NegativerVerbrauch := 0;

    //
    MySourceStrings := TStringList.create;

    LoadSource;

    ZAEHLER_NUMMER := '';
    xls_Row := -1;
    AUFTRAG_R := -1;
    for n := 0 to pred(MySourceStrings.count) do
    begin

      // suche der Kopf Datensatz
      if (pos('KK20', MySourceStrings[n]) = 1) then
      begin
        inc(Stat_Zaehler);

        // Sparte ansehen
        iSparte := strtointdef(nextp(MySourceStrings[n], ';', c_KK20_Sparte), -1);
        case iSparte of
          13:
            sSparte := 'E';
          23:
            sSparte := 'G';
          30:
            sSparte := 'WA';
          40:
            sSparte := 'WM';
        else
          sSparte := '?';
        end;

        //
        ZAEHLER_NUMMER := sSparte + '-' + shortenSerial(nextp(MySourceStrings[n], ';', c_KK20_SerialNo));

        sZaehlerIndex := sZaehler.indexof(ZAEHLER_NUMMER);
        if (sZaehlerIndex = -1) then
          xls_Row := -1
        else
        begin
          xls_Row := integer(sZaehler.Objects[sZaehlerIndex]);

          // Diese Zählernummer löschen, da nur einmal verwendbar!!
          sZaehler.delete(sZaehlerIndex);
        end;

        if (xls_Row <> -1) then
        begin

          // Referenzidentität
          {$ifdef fpc}
          // imp pend
          {$else}
          AUFTRAG_R := strtointdef(
            { } xImport.getCellValue(xls_Row, xls_col_RID).ToStringInvariant, -1);
          ZZ := (xImport.getCellValue(xls_Row, xls_col_ZZ).ToStringInvariant = 'X');
          {$endif}

          // Ablesedatum!
          {$ifdef fpc}
          // imp pend
          {$else}
          xDateTime := xImport.getCellValue(xls_Row, xls_col_AbleseDatum).ToDateTime(false);
          {$endif}
          EingabeDatum := long2date(xDateTime);
          EingabeDatumAsAnfix := date2long(EingabeDatum);

          // Ableseuhrzeit!
          {$ifdef fpc}
          // imp pend
          {$else}
          xDateTime := xImport.getCellValue(xls_Row, xls_col_AbleseUhr).ToDateTime(false);
          {$endif}
          EingabeUhr := SecondsToStr(xDateTime);

          if (EingabeDatumAsAnfix < 20060831) or not(DateOK(EingabeDatumAsAnfix)) then
          begin
            sDiagnose.add('WARNUNG: ' + ZAEHLER_NUMMER + ': Ablesedatum falsch!');
            ZAEHLER_NUMMER := '';
          end;

          ext_ui := nextp(MySourceStrings[n], ';', c_KK20_ext_ui);
          kombinat := nextp(MySourceStrings[n], ';', c_KK20_kombinat);
          inc(Stat_ergebnisse);
          K21_count := 1;
          K21_HT_ok := false;
          K21_NT_ok := false;
        end
        else
        begin
          ZAEHLER_NUMMER := '';
        end;

      end;

      // Liste die Zählwerke auf!
      if (pos('KK21', MySourceStrings[n]) = 1) and (ZAEHLER_NUMMER <> '') then
      begin

        try

          // jetzt kommen einzelne Zeilen!
          kennzif := nextp(MySourceStrings[n], ';', c_KK21_kennzif);
          NachKommaStellen := strtointdef(nextp(MySourceStrings[n], ';', c_KK21_NachKommaStellen), -1);
          SAPmapping := nextp(kennzif, ':', 1);

          _lowerBound := nextp(MySourceStrings[n], ';', c_KK21_erwstd_min);
          LowerBound := StrToDoubleDef(_lowerBound, -1);

          _HigherBound := nextp(MySourceStrings[n], ';', c_KK21_erwstd_max);
          HigherBound := StrToDoubleDef(_HigherBound, -1);

          _letzterStand := nextp(MySourceStrings[n], ';', c_KK21_l_zstand);
          LetzterStand := StrToDoubleDef(_letzterStand, -1);

          // zunächst aus MDE Erfassung versuchen
          case K21_count of
            1:
              {$ifdef fpc}
              // imp pend
              ;
              {$else}
              Zaehler_Stand := xImport.getCellValue(xls_Row, xls_col_AbleseWertHT).ToStringInvariant;
              {$endif}
            2:
              begin
                {$ifdef fpc}
                // imp pend
                {$else}
                Zaehler_Stand := xImport.getCellValue(xls_Row, xls_col_AbleseWertNT).ToStringInvariant;
                {$endif}
                if not(K21_HT_ok) and (Zaehler_Stand <> '') then
                begin
                  Zaehler_Stand := '';
                  sDiagnose.add('WARNUNG: ' + ZAEHLER_NUMMER + ': NT unbeachtet da HT fehlt!');
                end;
              end;
          else
            Zaehler_Stand := '';
          end;

          if (Zaehler_Stand = '') then
          begin
            ZaehlerStand := -1;
            inc(Stat_OhneWert);
            if (K21_count = 2) then
            begin
              inc(Stat_NT_fehlt);
              sDiagnose.add('WARNUNG: ' + ZAEHLER_NUMMER + ': NT fehlt!');
              if K21_HT_ok then
              begin
                sDiagnose.add('WARNUNG: ' + ZAEHLER_NUMMER + ': Rollback der HT Meldung!');
                Content.delete(pred(Content.count));
              end;
            end;
          end
          else
          begin
            ZaehlerStand := StrToDoubleDef(Zaehler_Stand, -1);
          end;

          // Plausibilitätsnachricht!
          if (ZaehlerStand >= 0) then
          begin

            case K21_count of
              1:
                K21_HT_ok := true;
              2:
                K21_NT_ok := true;
            end;

            Zaehler_Stand := FloatToStrISO(ZaehlerStand);

            repeat

              Plausibel := false;

              if (ZaehlerStand < LetzterStand) then
                inc(Stat_NegativerVerbrauch);

              if (LowerBound > 0) then
                if (ZaehlerStand < LowerBound) then
                  break;

              if (HigherBound > 0) then
                if (ZaehlerStand > HigherBound) then
                  break;

              if (LetzterStand > 0) then
              begin

                if (LetzterStand = ZaehlerStand) then
                  break;

                if (ZaehlerStand < LetzterStand) then
                  break;
              end;

              Plausibel := true;

            until yet;
            if not(Plausibel) then
              inc(Stat_Unplausibel);

            Content.add(
              { } 'KK22;' +
              { } nextp(MySourceStrings[n], ';', c_KK21_bukrs) + ';' +
              { } nextp(MySourceStrings[n], ';', c_KK21_ablbelnr) + ';' +
              { } nextp(MySourceStrings[n], ';', c_KK21_pruefzahl) + ';' +
              { } ext_ui + ';' +
              { } kennzif + ';' +
              { } nextp(MySourceStrings[n], ';', c_KK21_register) + ';' +
              { } kombinat + ';' +
              { } Format_ZaehlerNummer(ZAEHLER_NUMMER) + ';' +
              { } Format_Eingabedatum(EingabeDatum) + ';' +
              { } ';' +
              { } Format_Eingabezeit(EingabeUhr) + ';' +
              { } ';' +
              { } Format_ZaehlerStand(Zaehler_Stand) + ';' +
              { } ';' +
              { } '101;' +
              { } Format_herkunft(EingabeUhr));
          end;

        except
          on e: exception do
          begin
            inc(ErrorCount);
            sDiagnose.add(cERRORText + ' ' + e.message);
            sDiagnose.add(cERRORText + ' bei Zählernummer "' + ZAEHLER_NUMMER + '"');
          end;
        end;

        inc(K21_count);
      end;

    end;

    //
    sDiagnose.add(inttostr(Stat_ergebnisse) + '/' + inttostr(Stat_Zaehler) + ' Zähler verarbeitet!');

    d1 := Stat_Unplausibel;
    d2 := Content.count;
    d3 := (d1 / d2) * 100.0;

    sDiagnose.add(inttostr(Stat_Unplausibel) + '/' + inttostr(Content.count) + ' unplausibel (' + format('%.1f%%',
      [d3]) + ')!');

    d1 := Stat_NegativerVerbrauch;
    d2 := Content.count;
    d3 := (d1 / d2) * 100.0;

    sDiagnose.add(inttostr(Stat_NegativerVerbrauch) + '/' + inttostr(Content.count) + ' negativer Verbrauch (' +
      format('%.1f%%', [d3]) + ')!');

    sDiagnose.add(inttostr(Stat_OhneWert) + ' ohne Eingabe!');
    sDiagnose.add(inttostr(Stat_NT_fehlt) + ' NT fehlen!');
  end;

  procedure SetColInfo(var c: integer; sName: string);
  begin
    c := header.indexof(sName);
    if (c = -1) then
    begin
      inc(ErrorCount);
      sDiagnose.add(cERRORText + ' Spalte "' + sName + '" nicht gefunden!');
    end;
  end;

var
  xls_Sparte, xls_ZNummer: string;
  xls_Row: integer;
  AUFTRAG_R: integer;

begin
  header := TStringList.create;
  sZaehler := TStringList.create;
  FixedFormats := TStringList.create;
  Content := TStringList.create;
  {$ifdef fpc}
  xImport := TsWorkbook.Create;
  {$else}
  xImport := TXLSFile.create(true);
  {$endif}
  with xImport do
  begin

    try
      {$ifdef fpc}
      xImport.ReadFromFile(InFName,sfExcel8);
      {$else}
      Open(InFName);
      {$endif}
    except
      on e: exception do
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' ' + e.message);
        sDiagnose.add(cERRORText + ' ' + InFName + ' ist durch andere Anwendung geöffnet?');
      end;
    end;

    sDiagFiles.add(InFName);
    sDiagFiles.add(InFName + '.txt');

    header.add('<NULL>');
    {$ifdef fpc}
    // imp pend
    {$else}
    for c := 1 to ColCountInRow(1) do
      header.add(getCellValue(1, c).ToStringInvariant);
    {$endif}

    // Muss Spalten abfragen!
    SetColInfo(xls_col_ZaehlerNummer, 'Zaehler_Nummer');
    SetColInfo(xls_col_AbleseDatum, 'WechselDatum');
    SetColInfo(xls_col_AbleseUhr, 'WechselZeit');
    SetColInfo(xls_col_AbleseWertHT, 'ZaehlerStandAlt');
    SetColInfo(xls_col_AbleseWertNT, 'ZaehlerStandNeu');
    SetColInfo(xls_col_Art, 'Art');
    SetColInfo(xls_col_RID, 'ReferenzIdentitaet');
    SetColInfo(xls_col_ZZ, 'ZZ');

    //
    if (ErrorCount > 0) then
      exit;

    // Jetzt alle Zählernummern in sZaehler sammeln
    {$ifdef fpc}
    // imp pend
    {$else}
    for r := 2 to RowCount do
    {$endif}
    begin
      {$ifdef fpc}
      // imp pend
      {$else}
      xls_Sparte := getCellValue(r, xls_col_Art).ToStringInvariant;
      xls_ZNummer := getCellValue(r, xls_col_ZaehlerNummer).ToStringInvariant;
      {$endif}
      ersetze('#', '', xls_ZNummer);
      sZaehler.addobject(StrFilter(xls_Sparte, '0123456789', true) + '-' + xls_ZNummer, pointer(r));
    end;

    createKK22;

    // Hier kommen die übrig gebliebenen
    for r := 0 to pred(sZaehler.count) do
    begin
      xls_Row := integer(sZaehler.Objects[r]);
      {$ifdef fpc}
      // imp pend
      {$else}
      AUFTRAG_R := strtointdef(getCellValue(xls_Row, xls_col_RID).ToStringInvariant, -1);
      {$endif}
      sBericht.add('(RID=' + inttostr(AUFTRAG_R) + ') Zählernummer "' + sZaehler[r] + '"in EXPORT* nicht gefunden');
    end;

  end;
  xImport.Free;
  try
    Content.SaveToFile(InFName + '.txt');
  except
    on e: exception do
    begin
      inc(ErrorCount);
      sDiagnose.add(cERRORText + ' ' + e.message);
      sDiagnose.add(cERRORText + ' ' + InFName + '.csv ist durch andere Anwendung geöffnet?');
    end;
  end;
  Content.Free;
  header.Free;
  FixedFormats.Free;
  sZaehler.Free;
end;

procedure xls_2_xls(InFName: string; sBericht: TStringList = nil);

var
  {$ifdef fpc}
  xImport, xVorlage: TsWorkbook;
  xFmt: TsCellFormat;
  {$else}
  xImport: TXLSFile;
  xFmt: TFlxFormat;
  xVorlage: TXLSFile;
  {$endif}
  inHeaders: TStringList;
  Command: string;
  TargetRow: integer;
  TargetStartRow: integer;

  // Referenz-Datei
  sREF: TStringList;
  sHeader: TStringList;
  sREFERENCECol_Source: integer; // Ankerspalte in der Quelle
  sREFERENCECol_Referenced: integer; // Ankerspalte im Ergebnis
  mitRegler: boolean;
  AusgabeRotiert: boolean;

  procedure sBerichte(s:string);
  begin
    if assigned(sBericht) then
     sBericht.add(s)
    else
     sDiagnose.add(s);
  end;

  // hide
  //  sDiagnose, sBericht;

  function getRef(Row: integer; ColumnNameAtReference: string): string;
  var
    Key, oneLine: string;
    sCOL: TStringList;
    n, k: integer;
    TakeTodayCol: integer;
    FoundRowToday: integer;
    KeyDuplicates: integer;
  begin
    if not(assigned(sREF)) then
    begin

      // erstmalige Referenzierung
      sREF := TStringList.create;
      sHeader := TStringList.create;
      sDiagFiles.add(WorkPath + cXLS_Referenzdatei);
      sREF.loadFromFile(WorkPath + cXLS_Referenzdatei);
      oneLine := sREF[0];
      k := 0;
      while (oneLine <> '') do
      begin
        sCOL := TStringList.create;
        sHeader.addobject(nextp(oneLine, ';'), sCOL);
        for n := 1 to pred(sREF.count) do
          sCOL.add(nextp(sREF[n], ';', k));
        inc(k);
      end;

      // Zuweisung der Ankerspalte
      sREFERENCECol_Source := -1;
      for n := 0 to pred(inHeaders.count) do
      begin
        k := sHeader.indexof(inHeaders[n]);
        if (k <> -1) then
        begin
            if (sREFERENCECol_Source = -1) then
             sBerichte(cINFOText + ' "' + inHeaders[n] + '" ist Ankerspalte')
            else
             sBerichte(cWARNINGText + ' ' + 'überzählige Ankerspalte "' + inHeaders[n] + '" wird ignoriert');
          if (sREFERENCECol_Source = -1) then
          begin
           sREFERENCECol_Source := n + 1;
           sREFERENCECol_Referenced := k;
          end;
        end;
      end;
      if (sREFERENCECol_Source = -1) then
        raise exception.create('keine identisch benannte Spaltenüberschrift gefunden!');

    end;
    TakeTodayCol := sHeader.indexof(ColumnNameAtReference);
    if (TakeTodayCol = -1) then
      raise exception.create('gewünschte Spalte ' + ColumnNameAtReference + ' ist im Nachschlagewerk nicht vorhanden!');

    {$ifdef fpc}
    // imp pend
    {$else}
    Key := xImport.getCellValue(Row, sREFERENCECol_Source).ToStringInvariant;
    {$endif}
    sCOL := TStringList(sHeader.Objects[sREFERENCECol_Referenced]);
    FoundRowToday := sCOL.indexof(Key);
    if (FoundRowToday = -1) then
      raise exception.create('Ankerwert ' + Key + ' konnte nicht lokalisiert werden!');

    // ist der Anker eindeutig
    KeyDuplicates := 0;
    for n := 0 to pred(sCOL.count) do
      if n <> FoundRowToday then
        if (Key = sCOL[n]) then
          inc(KeyDuplicates);

    if (KeyDuplicates > 0) then
        sBerichte(cWARNINGText + ' Ankerwert "' + Key + '" kommt ' + inttostr(KeyDuplicates + 1) + ' mal vor!');

    sCOL := TStringList(sHeader.Objects[TakeTodayCol]);
    result := sCOL[FoundRowToday];
  end;

  function MonDaCode(s: string): string;
  begin
    result := s;
    ersetze('³', 'ü', result);
    ersetze('÷', 'ö', result);
    ersetze('õ', 'ä', result);
    ersetze('¯', 'ß', result);
    ersetze('Í', 'Ö', result);
    ersetze('Ó', 'Ä', result);
  end;

  function getParamValue(n: integer): string;
  begin
    result := nextp(Command, '.', n + 1);
  end;

  function getHeaderIndex(Name: string): integer;
  begin
    result := inHeaders.indexof(name) + 1;
    if (result = 0) then
    begin
      sBerichte(cERRORText + ' Spalte "' + name + '" nicht gefunden!');
      inc(ErrorCount);
      result := 1; // nur Proforma!
    end;
  end;

  function read(r, c: integer): string; overload;
  var
    v: Variant;
    d: TDateTime;
    IsConverted: boolean;
    FormatStr: string;
  begin
    result := '';
    try
      with xImport do
      begin

        {$ifdef fpc}
        // imp pend
        {$else}
        v := getCellValue(r, c);
        {$endif}
        IsConverted := false;
        repeat

          // 1. Es muss Double sein
          if (TVarData(v).VType <> varDouble) then
            break;

          // 2. Es muss ein Format haben
          {$ifdef fpc}
          // imp pend
          {$else}
          if getCellFormat(r, c) < 0 then
            break;
          xFmt := GetFormat(getCellFormat(r, c));
          FormatStr := AnsiupperCase(xFmt.format);
          {$endif}

          // 3. Es muss ein Datumsformat haben
          if (pos('YY', FormatStr) > 0) and (pos('HH', FormatStr) > 0) then
          begin
            // ganzer Timestamp
            d := v;
            result := long2date(d) + ' ' + SecondsToStr(d);
            IsConverted := true;
            break;
          end;

          if (pos('YY', FormatStr) > 0) then
          begin
            // Datum
            d := v;
            result := long2date(d);
            IsConverted := true;
            break;

          end;

          if (pos('HH', FormatStr) > 0) then
          begin
            // Uhrzeit
            d := v;
            result := SecondsToStr(d);
            IsConverted := true;
            break;

          end;

        until yet;

        //
        if not(IsConverted) then
          result := v;
      end;
    except
      on e: exception do
      begin
        sBerichte('WARNING: ' + e.message);
        sBerichte('WARNING: Zelle ' + inttostr(r) + ',' + inttostr(c) + ' konnte nicht gelesen werden!');
      end;
    end;
  end;

  function read(r: integer; c: string): string; overload;
  begin
    result := read(r, getHeaderIndex(c));
  end;

  function oemFunction(r: integer; FunctionName: string): string;
  var
    ah, ag: double;
    WechselDatum: TAnFixDate;
  begin
    result := '';
    repeat

      if (FunctionName = 'ISL1') then
      begin
        ag := strtointdef(read(r, 'AG'), 0);
        ah := strtointdef(read(r, 'AH'), 0);
        WechselDatum := date2long(read(r, 'WechselDatum'));
        if (ag <> 0) and (ah <> 0) and DateOK(WechselDatum) then
        begin
          result := inttostr(round(ag + (ah / 365) * DateDiff(20051231, WechselDatum) * 0.7));
        end;
        break;
      end;

      if (FunctionName = 'ISL2') then
      begin
        ag := strtointdef(read(r, 'AG'), 0);
        ah := strtointdef(read(r, 'AH'), 0);
        WechselDatum := date2long(read(r, 'WechselDatum'));
        if (ag <> 0) and (ah <> 0) and DateOK(WechselDatum) then
        begin
          result := inttostr(round(ag + (ah / 365) * DateDiff(20051231, WechselDatum) * 1.3));
        end;
        break;
      end;
      sBerichte(cERRORText + ' Funktion "' + FunctionName + '" ist unbekannt!');
      inc(ErrorCount);
    until yet;
  end;

  function komma_F(s: string): string;
  var
    d: double;
  begin
    result := s;
    if (result <> '') then
    begin
      d := StrToDoubleDef(result, 0);
      result := format('%.1f', [d]);
    end;
  end;

  function zeit_F(s: string): string;
  begin
    result := StrFilter(s, '0123456789');
    if (result <> '') then
    begin
      result := copy(result, 1, 4);
      case length(result) of
        1:
          result := '0' + result + '00';
        2:
          result := result + '00';
        3:
          result := '0' + result;
      end;
      result := copy(result, 1, 2) + ':' + copy(result, 3, 2);
    end;
  end;

  function parseLogik(r: integer; s: string): string;
  var
    k: integer;
    SingleField: string;
    SpeedExpr: string;
    _SpeedExpr: string;
  begin

    // alle Feldinhalte füllen
    SpeedExpr := '';
    while (s <> '') do
    begin
      SingleField := nextp(s, '.');
      repeat

        if (SingleField = 'und') then
        begin
          SpeedExpr := SpeedExpr + '+';
          break;
        end;

        if (SingleField = 'oder') then
        begin
          SpeedExpr := SpeedExpr + '*';
          break;
        end;

        if (SingleField = 'nicht') then
        begin
          SpeedExpr := SpeedExpr + '!';
          break;
        end;

        k := inHeaders.indexof(SingleField);
        if (k <> -1) then
        begin
          // Ein Wert
          if read(r, k + 1) = 'X' then
            SpeedExpr := SpeedExpr + '1'
          else
            SpeedExpr := SpeedExpr + '0';
          break;
        end;

        SpeedExpr := SpeedExpr + SingleField;

      until yet;

    end;

    repeat

      _SpeedExpr := SpeedExpr;

      // nicht
      ersetze('!1', '0', SpeedExpr);
      ersetze('!0', '1', SpeedExpr);

      // und
      ersetze('0+0', '0', SpeedExpr);
      ersetze('0+1', '0', SpeedExpr);
      ersetze('1+0', '0', SpeedExpr);
      ersetze('1+1', '1', SpeedExpr);

      // oder
      ersetze('0*0', '0', SpeedExpr);
      ersetze('0*1', '1', SpeedExpr);
      ersetze('1*0', '1', SpeedExpr);
      ersetze('1*1', '1', SpeedExpr);

      // Klammern
      ersetze('(0)', '0', SpeedExpr);
      ersetze('(1)', '1', SpeedExpr);
      ersetze('()', '', SpeedExpr);

      if (SpeedExpr = _SpeedExpr) then
        break;

    until eternity;

    result := cERRORText + ' Parsen scheitert bei "' + SpeedExpr + '"';
    if (SpeedExpr = '1') then
      result := 'X';
    if (SpeedExpr = '0') then
      result := '';

  end;

  procedure writeLine(r: integer; const OutCommands: TStrings);
  var
    c: integer;
    ContentAsWideString: WideString;
    ContentRaw: String;
    // .+
    k: integer;
    NextSubFieldName: string;
    kk: integer;
    FormatIndex: integer;
    ForceFormat: boolean;
  begin
    ForceFormat := false;
    for c := 1 to OutCommands.count do
    begin
      try
        Command := OutCommands[pred(c)];
        FormatIndex := integer(OutCommands.Objects[pred(c)]);

        if (Command <> '') then
        begin

          // Content ermitteln
          ContentAsWideString := '';
          repeat

            // Referenz auf ein externes Feld
            // Syntax >Anker-Fremd.Anker-Lokal.Spalte
            //
            if (pos('>', Command) = 1) then
            begin
              ContentAsWideString := getRef(r, copy(Command, 2, MaxInt));
              break;
            end;

            // ein konstanter String!
            if (pos('"', Command) = 1) or (pos('\', Command) = 1) then
            begin
              ContentAsWideString := copy(Command, 2, MaxInt);
              break;
            end;

            // 1. Teil einer Blankseparierung
            if (pos('.1', Command) = 1) then
            begin
              k := getHeaderIndex(getParamValue(1));
              ContentRaw := read(r, k);
              if (pos(' - ', ContentRaw) > 0) then
                ContentAsWideString := nextp(ContentRaw, ' - ', 0)
              else
                ContentAsWideString := nextp(ContentRaw, ' ', 0);
              break;
            end;

            // 2. Teil einer Blankseparierung
            if (pos('.2', Command) = 1) then
            begin
              k := getHeaderIndex(getParamValue(1));
              ContentRaw := read(r, k);
              if (pos(' - ', ContentRaw) > 0) then
                ContentAsWideString := nextp(ContentRaw, ' - ', 1)
              else
                ContentAsWideString := nextp(ContentRaw, ' ', 1);
              break;
            end;

            // falsche j/n Felder (autofill)
            if (pos('.ja', Command) = 1) then
            begin
              k := getHeaderIndex(getParamValue(1));
              if (pos(read(r, k), 'xXjJyYkKlL5') > 0) then
                ContentAsWideString := 'ja'
              else
                ContentAsWideString := 'nein';
              break;
            end;

            // falsche j/n Felder (autofill)
            if (pos('.j', Command) = 1) then
            begin
              k := getHeaderIndex(getParamValue(1));
              if (pos(read(r, k), 'xXjJyYkKlL5') > 0) then
                ContentAsWideString := 'j'
              else
                ContentAsWideString := 'n';
              break;
            end;

            // echte j/n Felder
            if (pos('.J', Command) = 1) then
            begin
              k := getHeaderIndex(getParamValue(1));
              repeat

                if (pos(read(r, k), 'xXjJyYkKlL51') > 0) then
                begin
                  ContentAsWideString := 'j';
                  break;
                end;

                if (pos(read(r, k), 'nNmMoO60') > 0) then
                begin
                  ContentAsWideString := 'n';
                  break;
                end;

                ContentAsWideString := ' ';

              until yet;
              break;
            end;

            // Komma-Zwang
            if (pos('.komma', Command) = 1) then
            begin
              k := getHeaderIndex(getParamValue(1));
              ContentAsWideString := komma_F(read(r, k));
              break;
            end;

            // Zeit-Angaben
            if (pos('.zeit', Command) = 1) then
            begin
              k := getHeaderIndex(getParamValue(1));
              ContentAsWideString := zeit_F(read(r, k));
              break;
            end;

            // interne Sonderfunktionen
            if (pos('.t', Command) = 1) then
            begin
              ContentAsWideString := oemFunction(r, getParamValue(1));
              break;
            end;

            // Felder addieren
            if (pos('.+', Command) = 1) then
            begin
              k := 0;
              repeat
                inc(k);
                NextSubFieldName := getParamValue(k);
                if (NextSubFieldName = '') then
                  break;

                if CharInSet(NextSubFieldName[1], ['''', '"']) then
                begin
                  // Konstanter Wert!
                  ContentAsWideString := ContentAsWideString + copy(NextSubFieldName, 2, length(NextSubFieldName) - 2);
                  continue;
                end;

                if pos('!', NextSubFieldName) = 1 then
                begin
                  kk := getHeaderIndex(copy(NextSubFieldName, 2, MaxInt));
                  ContentAsWideString := cutblank(ContentAsWideString + read(r, kk));
                  continue;
                end;

                if (pos('>', NextSubFieldName) = 1) then
                begin
                  ContentAsWideString :=
                    cutblank(ContentAsWideString + ' ' + getRef(r, copy(NextSubFieldName, 2, MaxInt)));
                  continue;
                end;

                if (NextSubFieldName = 'coalesce') then
                begin
                  if (noblank(ContentAsWideString) = '') then
                    continue
                  else
                    break;
                end;

                // default-Wert
                kk := getHeaderIndex(NextSubFieldName);
                ContentAsWideString := cutblank(ContentAsWideString + ' ' + read(r, kk));
              until eternity;
              break;
            end;

            // Multible Choice mit .*
            if (pos('.*', Command) = 1) then
            begin
              //
              k := 1;
              repeat
                NextSubFieldName := getParamValue(k);
                if (NextSubFieldName = '') then
                  break;

                // der default Parameter
                if (NextSubFieldName = '*') then
                begin
                  ContentAsWideString := getParamValue(k + 1);
                  break;
                end;

                // der exacte Parameter
                kk := getHeaderIndex(NextSubFieldName);
                if (read(r, kk) = 'X') then
                begin
                  ContentAsWideString := getParamValue(k + 1);
                  break;
                end;
                inc(k, 2);
              until eternity;
              break;
            end;

            // Logik mit "X" Feldern
            if (pos('.l', Command) = 1) then
            begin
              ContentAsWideString := parseLogik(r, copy(Command, 4, MaxInt));
              break;
            end;

            // Erzwingen des Text Formates
            if (pos('''', Command) = 1) then
            begin
              ForceFormat := true;
              system.delete(Command, 1, 1);
            end;

            // letzte Möglichkeit 1:1 Beziehung
            k := getHeaderIndex(Command);
            if (k > 0) then
            begin
              ContentAsWideString := read(r, k);
              break;
            end;

          until yet;

          if (ErrorCount = 0) then
          begin
            if AusgabeRotiert then
            begin
              {$ifdef fpc}
              // imp pend
              {$else}
              xVorlage.setColWidth(TargetRow, xVorlage.getColWidth(TargetStartRow));
              xVorlage.SetCellFromString(c, TargetRow, MonDaCode(ContentAsWideString), FormatIndex);
              {$endif}
            end
            else
            begin
              if ForceFormat then
              begin
                {$ifdef fpc}
                // imp pend
                {$else}
                xVorlage.SetCellFormat(TargetRow, c, FormatIndex);
                xVorlage.SetCellValue(TargetRow, c, MonDaCode(ContentAsWideString));
                {$endif}
                ForceFormat := false;
              end
              else
              begin
                {$ifdef fpc}
                // imp pend
                {$else}
                xVorlage.SetCellFromString(TargetRow, c, MonDaCode(ContentAsWideString), FormatIndex);
                {$endif}
              end;
            end;
          end
          else
          begin
            if AusgabeRotiert then
              {$ifdef fpc}
              // imp pend
              {$else}
              xVorlage.SetCellValue(c, TargetRow, 'ERROR', -1)
              {$endif}
            else
              {$ifdef fpc}
              // imp pend
              {$else}
              xVorlage.SetCellValue(TargetRow, c, 'ERROR', -1);
              {$endif}
          end;
        end;

      except
        on e: exception do
        begin
          inc(ErrorCount);
          sBerichte(format(cERRORText + ' %s(%d,%d): %s', [Command, r, c, e.message]));
        end;
      end;

      if (ErrorCount > 0) then
        break;
    end;

  end;

var
  //
  OutCommands: TStringList;
  OutCommandsRegler: TStringList;

  // xls Quelle
  {$ifdef fpc}
  xExportRegler: TsWorkbook;
  {$else}
  xExportRegler: TXLSFile;
  {$endif}
  TemplateFname: string;
  r, c, k: integer;
  TargetMaxCol: integer;

  // Erkennung, ob ein Wert drin ist
  v: Variant;
  FormatIndex: integer;

begin

  if FileExists(InFName) then
  begin

    // Init
    sREF := nil;
    mitRegler := false;
    AusgabeRotiert := false;
    TargetStartRow := 5;
    inHeaders := TStringList.create;
    OutCommands := TStringList.create;
    OutCommandsRegler := TStringList.create;

    sDiagFiles.add(InFName);

    {$ifdef fpc}
    xImport := TsWorkbook.Create;
    xVorlage := TsWorkbook.Create;
    {$else}
    xImport := TXLSFile.create(true);
    xVorlage := TXLSFile.create(true);
    {$endif}

    repeat

      // Name der Vorlage.xls bestimmen!
      // 1. Rang: p_XLS_VorlageFName, falls nicht existiert
      // 2. Rang: "Vorlage.xls"
      repeat

        if (p_XLS_VorlageFName <> '') then
        begin
          TemplateFname := WorkPath + p_XLS_VorlageFName;
          p_XLS_VorlageFName := '';
          if FileExists(TemplateFname) then
            break;
        end;

        TemplateFname := WorkPath + c_XLS_VorlageFName;

      until yet;

      if not(FileExists(TemplateFname)) then
      begin
        sBerichte(cERRORText + ' Datei "' + TemplateFname + '" fehlt!');
        break;
      end;

      if FileExists(WorkPath + 'Vorlage-Regler.xls') then
      begin
        {$ifdef fpc}
        // imp pend
        {$else}
        xExportRegler := TXLSFile.create(true);
        xExportRegler.Open(WorkPath + 'Vorlage-Regler.xls');
        {$endif}
        mitRegler := true;
      end;

      sDiagFiles.add(TemplateFname);

      //
      try
        {$ifdef fpc}
        // imp pend
        {$else}
        xImport.Open(InFName);
        xVorlage.Open(TemplateFname);
        {$endif}
      except
        on e: exception do
        begin
          inc(ErrorCount);
          sBerichte(cERRORText + ' ' + e.message);
          sBerichte(cERRORText + ' ' + InFName + ' ist durch andere Anwendung geöffnet?');
        end;
      end;
      if (ErrorCount > 0) then
        break;

      with xVorlage do
      begin

        // zunächst ermitteln, ab welcher Zeile es los geht!
        {$ifdef fpc}
        // imp pend
        {$else}
        for r := RowCount downto 1 do
          if getCellValue(r, 1).HasValue then
          begin
            TargetStartRow := r - 1;
            break;
          end;
        {$endif}

        // Könnte die Ausgabe rotiert sein?
        if (TargetStartRow > 10) then
        begin
          AusgabeRotiert := true;
          {$ifdef fpc}
          // imp pend
          {$else}
          for c := ColCountInRow(1) downto 1 do
            if getCellValue(1, c).HasValue then
            begin
              TargetStartRow := c - 1;
              break;
            end;
          {$endif}
        end;

        // die Commandos in den Zellen aufsammeln
        {$ifdef fpc}
        // imp pend
        {$else}
        if AusgabeRotiert then
        begin
          for r := 1 to RowCount do
          begin
            OutCommands.add(getCellValue(r, TargetStartRow + 1).ToStringInvariant);
            if mitRegler then
              OutCommandsRegler.add(xExportRegler.getCellValue(r, TargetStartRow + 1).ToStringInvariant);

            SetCellValue(r, TargetStartRow, '');
            SetCellValue(r, TargetStartRow + 1, '');
          end;
        end
        else
        begin
          for c := 1 to ColCountInRow(1) do
          begin

            // Das Format aus Zeile 2
            FormatIndex := getCellFormat(TargetStartRow, c);

            // a) clear Cell from "Format-Line"
            SetCellFromString(TargetStartRow, c, '', FormatIndex);

            // Das Commando aus Zeile 3
            OutCommands.addobject(
              { } getCellValue(
              { } TargetStartRow + 1, c).ToStringInvariant,
              { } TObject(FormatIndex));
            // b) clear Cell from "Command-Line"
            SetCellFromString(TargetStartRow + 1, c, '', FormatIndex);

            // weitere Zeile
            if mitRegler then
            begin
              FormatIndex := AddFormat(xExportRegler.GetFormat(xExportRegler.getCellFormat(TargetStartRow, c)));
              OutCommandsRegler.addobject(
                { } xExportRegler.getCellValue(
                { } TargetStartRow + 1, c).ToStringInvariant,
                { } TObject(FormatIndex));
            end;
          end;
        end;
        {$endif}
      end;

      TargetRow := TargetStartRow;
      with xImport do
      begin

        // die Datenfeld-Namen alle lesen!
        {$ifdef fpc}
        // imp pend
        {$else}
        for c := 1 to ColCountInRow(1) do
          inHeaders.add(getCellValue(1, c).ToStringInvariant);
        {$endif}

        {$ifdef fpc}
        for r := 2 to succ(ActiveWorksheet.GetLastRowIndex) do
        {$else}
        for r := 2 to RowCount do
        {$endif}
        begin

          writeLine(r, OutCommands);
          inc(TargetRow);

          // 2. Zeile für den neuen Regler schreiben
          if mitRegler then
            if (read(r, 'ReglerNummerAlt') <> '') then
              if (read(r, 'ReglerNummerAlt') <> read(r, 'ReglerNummerNeu')) then
              begin
                if (read(r, 'ReglerNummerNeu') <> '') then
                begin
                  writeLine(r, OutCommandsRegler);
                  inc(TargetRow);
                end
                else
                begin
                  // Eigentlich hätte man einen Regler erfassen müssen
                  // gar keine Eingabe ist meldewürdig
                  sBerichte('WARNING: (RID=' + read(r, 'Referenzidentitaet') + ') ReglerNummerNeu ist leer!');
                end;
              end;

          // x / y drehen
          if AusgabeRotiert then
            if (TargetRow = 253) then
            begin
              sBerichte('WARNING: Could not write all the data due Excel Column-Limitation');
              break;
            end;
        end;
      end;

      // save it as ...
      conversionOutFName := InFName;
      if (pos('Zaehlerdaten', conversionOutFName) > 0) then
      begin
        ersetze('Zaehlerdaten', 'Konvertiert', conversionOutFName);
      end
      else
      begin
        k := revPos('.', conversionOutFName);
        conversionOutFName := copy(conversionOutFName, 1, k) + 'Konvertiert.xls';
      end;

      FileDelete(conversionOutFName);
      try
        {$ifdef fpc}
        // imp pend
        {$else}
        xVorlage.Save(conversionOutFName);
        {$endif}
      except
        on e: exception do
        begin
          inc(ErrorCount);
          sBerichte(cERRORText + ' ' + e.message);
          sBerichte(cERRORText + ' ' + conversionOutFName + ' ist durch andere Anwendung geöffnet?');
        end;
      end;

    until yet;


    xImport.Free;
    xVorlage.Free;
    if mitRegler then
      xExportRegler.Free;

    inHeaders.Free;
    OutCommands.Free;
    OutCommandsRegler.Free;
    if assigned(sREF) then
    begin
      sREF.Free;
      sHeader.Free;
    end;

  end;
end;

procedure xls_Datev_xls(InFName: string);

var
  {$ifdef fpc}
  xImport: TsWorkbook;
  xFmt: TsCellFormat;
  {$else}
  xImport: TXLSFile;
  xFmt: TFlxFormat;
  {$endif}
  inHeaders: TStringList;
  Command: string;

  sREF: TStringList;
  sHeader: TStringList;
  sREFERENCECol_Source: integer;
  sREFERENCECol_Referenced: integer;

  _NETTO, _SATZ, _STEUER, _BRUTTO, _KONTO: WideString;

  function getRef(Row: integer; s: string): string;
  var
    Key, oneLine: string;

    sCOL: TStringList;
    n, k: integer;
    TakeTodayCol: integer;
    FoundRowToday: integer;
  begin
    if not(assigned(sREF)) then
    begin
      sREF := TStringList.create;
      sHeader := TStringList.create;
      sDiagFiles.add(WorkPath + cXLS_Referenzdatei);
      sREF.loadFromFile(WorkPath + cXLS_Referenzdatei);
      oneLine := sREF[0];
      k := 0;
      while (oneLine <> '') do
      begin
        sCOL := TStringList.create;
        sHeader.addobject(nextp(oneLine, ';'), sCOL);
        for n := 1 to pred(sREF.count) do
          sCOL.add(nextp(sREF[n], ';', k));
        inc(k);
      end;
      sREFERENCECol_Source := -1;
      for n := 0 to pred(inHeaders.count) do
      begin
        k := sHeader.indexof(inHeaders[n]);
        if (k <> -1) then
        begin
          sREFERENCECol_Source := n + 1;
          sREFERENCECol_Referenced := k;
          break;
        end;
      end;
      if (sREFERENCECol_Source = -1) then
        raise exception.create('keine Ankerspalte mit identischem Namen gefunden!');
    end;
    TakeTodayCol := sHeader.indexof(s);
    if (TakeTodayCol = -1) then
      raise exception.create('gewünschte Spalte ' + s + ' ist im Nachschlagewerk nicht vorhanden!');
    {$ifdef fpc}
    // imp pend
    {$else}
    Key := xImport.getCellValue(Row, sREFERENCECol_Source).ToStringInvariant;
    {$endif}
    sCOL := TStringList(sHeader.Objects[sREFERENCECol_Referenced]);
    FoundRowToday := sCOL.indexof(Key);
    if (FoundRowToday = -1) then
      raise exception.create('Ankerwert ' + Key + ' konnte nicht lokalisiert werden!');
    sCOL := TStringList(sHeader.Objects[TakeTodayCol]);
    result := sCOL[FoundRowToday];
  end;

  function MonDaCode(s: string): string;
  begin
    result := s;
    ersetze('³', 'ü', result);
    ersetze('÷', 'ö', result);
    ersetze('õ', 'ä', result);
    ersetze('¯', 'ß', result);
    ersetze('Í', 'Ö', result);
    ersetze('Ó', 'Ä', result);
  end;

  function getParamValue(n: integer): string;
  begin
    result := nextp(Command, '.', n + 1);
  end;

  function getHeaderIndex(Name: string): integer;
  begin
    result := inHeaders.indexof(name) + 1;
    if (result = 0) then
    begin
      sDiagnose.add(cERRORText + ' Spalte "' + name + '" nicht gefunden!');
      inc(ErrorCount);
      result := 1; // nur Proforma!
    end;
  end;

  function read(r, c: integer): string; overload;
  var
    v: Variant;
    d: TDateTime;
    IsConverted: boolean;
    FormatStr: string;
  begin
    result := '';
    try
      with xImport do
      begin

        {$ifdef fpc}
        // imp pend
        {$else}
        v := getCellValue(r, c);
        {$endif}
        IsConverted := false;
        repeat

          // 1. Es muss Double sein
          if (TVarData(v).VType <> varDouble) then
            break;

          // 2. Es muss ein Format haben
          {$ifdef fpc}
          // imp pend
          {$else}
          if getCellFormat(r, c) < 0 then
            break;
          xFmt := GetFormat(getCellFormat(r, c));
          FormatStr := AnsiupperCase(xFmt.format);
          {$endif}
          // FormatStr := AnsiUpperCase(FormatList[getCellFormat(r, c]].format);

          // 3. Es muss ein Datumsformat haben
          if (pos('YY', FormatStr) > 0) and (pos('HH', FormatStr) > 0) then
          begin
            // ganzer Timestamp
            d := v;
            result := long2date(d) + ' ' + SecondsToStr(d);
            IsConverted := true;
            break;
          end;

          if (pos('YY', FormatStr) > 0) then
          begin
            // Datum
            d := v;
            result := long2date(d);
            IsConverted := true;
            break;

          end;

          if (pos('HH', FormatStr) > 0) then
          begin
            // Uhrzeit
            d := v;
            result := SecondsToStr(d);
            IsConverted := true;
            break;

          end;

        until yet;

        //
        if not(IsConverted) then
          result := v;
      end;
    except
      on e: exception do
      begin
        sDiagnose.add('WARNING: ' + e.message);
        sDiagnose.add('WARNING: Zelle ' + inttostr(r) + ',' + inttostr(c) + ' konnte nicht gelesen werden!');
      end;
    end;
  end;

  function read(r: integer; c: string): string; overload;
  begin
    result := read(r, getHeaderIndex(c));
  end;

  function oemFunction(r: integer; FunctionName: string): string;
  var
    ah, ag: double;
    WechselDatum: TAnFixDate;
  begin
    result := '';
    repeat

      if (FunctionName = 'ISL1') then
      begin
        ag := strtointdef(read(r, 'AG'), 0);
        ah := strtointdef(read(r, 'AH'), 0);
        WechselDatum := date2long(read(r, 'WechselDatum'));
        if (ag <> 0) and (ah <> 0) and DateOK(WechselDatum) then
        begin
          result := inttostr(round(ag + (ah / 365) * DateDiff(20051231, WechselDatum) * 0.7));
        end;
        break;
      end;

      if (FunctionName = 'ISL2') then
      begin
        ag := strtointdef(read(r, 'AG'), 0);
        ah := strtointdef(read(r, 'AH'), 0);
        WechselDatum := date2long(read(r, 'WechselDatum'));
        if (ag <> 0) and (ah <> 0) and DateOK(WechselDatum) then
        begin
          result := inttostr(round(ag + (ah / 365) * DateDiff(20051231, WechselDatum) * 1.3));
        end;
        break;
      end;
      sDiagnose.add(cERRORText + ' Funktion "' + FunctionName + '" ist unbekannt!');
      inc(ErrorCount);
    until yet;
  end;

  function parseLogik(r: integer; s: string): string;
  var
    k: integer;
    SingleField: string;
    SpeedExpr: string;
    _SpeedExpr: string;
  begin

    // alle Feldinhalte füllen
    SpeedExpr := '';
    while (s <> '') do
    begin
      SingleField := nextp(s, '.');
      repeat

        if (SingleField = 'und') then
        begin
          SpeedExpr := SpeedExpr + '+';
          break;
        end;

        if (SingleField = 'oder') then
        begin
          SpeedExpr := SpeedExpr + '*';
          break;
        end;

        if (SingleField = 'nicht') then
        begin
          SpeedExpr := SpeedExpr + '!';
          break;
        end;

        k := inHeaders.indexof(SingleField);
        if (k <> -1) then
        begin
          // Ein Wert
          if read(r, k + 1) = 'X' then
            SpeedExpr := SpeedExpr + '1'
          else
            SpeedExpr := SpeedExpr + '0';
          break;
        end;

        SpeedExpr := SpeedExpr + SingleField;

      until yet;

    end;

    repeat

      _SpeedExpr := SpeedExpr;

      // nicht
      ersetze('!1', '0', SpeedExpr);
      ersetze('!0', '1', SpeedExpr);

      // und
      ersetze('0+0', '0', SpeedExpr);
      ersetze('0+1', '0', SpeedExpr);
      ersetze('1+0', '0', SpeedExpr);
      ersetze('1+1', '1', SpeedExpr);

      // oder
      ersetze('0*0', '0', SpeedExpr);
      ersetze('0*1', '1', SpeedExpr);
      ersetze('1*0', '1', SpeedExpr);
      ersetze('1*1', '1', SpeedExpr);

      // Klammern
      ersetze('(0)', '0', SpeedExpr);
      ersetze('(1)', '1', SpeedExpr);
      ersetze('()', '', SpeedExpr);

      if (SpeedExpr = _SpeedExpr) then
        break;

    until eternity;

    result := cERRORText + ' Parsen scheitert bei "' + SpeedExpr + '"';
    if (SpeedExpr = '1') then
      result := 'X';
    if (SpeedExpr = '0') then
      result := '';

  end;

var
  //
  OutCommands: TStringList;

  // xls Quelle
  {$ifdef fpc}
  Cell: PCell;
  xExport: TsWorkbook;
  {$else}
  xExport: TXLSFile;
  {$endif}
  TemplateFname: string;
  r, s, c: integer;
  TargetRow: integer;
  TargetStartRow: integer;
  TargetMaxCol: integer;
  ContentAsWideString: WideString;
  k: integer;
  AusgabeRotiert: boolean;

  // Erkennung, ob ein Wert drin ist
  v: Variant;

  // .+
  NextSubFieldName: string;
  kk: integer;

begin

  if FileExists(InFName) then
  begin

    //
    AusgabeRotiert := false;
    TargetStartRow := 5;
    inHeaders := TStringList.create;
    OutCommands := TStringList.create;

    // Für die externe Referenz
    sREF := nil;

    sDiagFiles.add(InFName);

    {$ifdef fpc}
    xImport := TsWorkbook.Create;
    xExport := TsWorkbook.Create;
    {$else}
    xImport := TXLSFile.create(true);
    xExport := TXLSFile.create(true);
    {$endif}
    repeat
      TemplateFname := WorkPath + 'Datev.xls';

      if not(FileExists(TemplateFname)) then
      begin
        sDiagnose.add(cERRORText + ' Datei "' + TemplateFname + '" fehlt!');
        break;
      end;

      sDiagFiles.add(TemplateFname);

      //
      try
        {$ifdef fpc}
        // imp pend
        {$else}
        xImport.Open(InFName);
        xExport.Open(TemplateFname);
        {$endif}
      except
        on e: exception do
        begin
          inc(ErrorCount);
          sDiagnose.add(cERRORText + ' ' + e.message);
          sDiagnose.add(cERRORText + ' ' + InFName + ' ist durch andere Anwendung geöffnet?');
        end;
      end;
      if (ErrorCount > 0) then
        break;

      with xExport do
      begin

        // zunächst ermitteln, ab welcher Zeile es los geht!
        {$ifdef fpc}
        // imp pend
        for r := 1 downto 1 do
        {$else}
        for r := RowCount downto 1 do
        {$endif}
        begin
          {$ifdef fpc}
          Cell := ActiveWorksheet.Cells.FindCell(pred(r),0);
          repeat
            //
            if not(assigned(Cell)) then
            begin
              v := '';
              break;
            end;

            if (Cell^.ContentType=cctNumber) or (Cell^.ContentType=cctDateTime) then
            begin
              v := ActiveWorksheet.ReadAsNumber(pred(r), 0);
              break;
            end;

            v := ActiveWorksheet.ReadAsText(pred(r), 0);
          until yet;
          {$else}
          v := getCellValue(r, 1);
          {$endif}
          if (TVarData(v).VType = varDouble) then
          begin
            if (v <> 0) then
            begin
              TargetStartRow := r - 1;
              break;
            end;
          end
          else
          begin
            if (v <> '') then
            begin
              TargetStartRow := r - 1;
              break;
            end;
          end;
        end;

        // Könnte die Ausgabe rotiert sein?
        if TargetStartRow > 10 then
        begin
          AusgabeRotiert := true;
          {$ifdef fpc}
          for c := ActiveWorksheet.GetLastColIndex downto 0 do
          {$else}
          for c := ColCountInRow(1) downto 1 do
          {$endif}
          begin
            {$ifdef fpc}
            Cell := ActiveWorksheet.Cells.FindCell(pred(r),c);
            repeat
              //
              if not(assigned(Cell)) then
              begin
                v := '';
                break;
              end;

              if (Cell^.ContentType=cctNumber) or (Cell^.ContentType=cctDateTime) then
              begin
                v := ActiveWorksheet.ReadAsNumber(pred(r), c);
                break;
              end;

              v := ActiveWorksheet.ReadAsText(pred(r), c);
            until yet;
            {$else}
            v := getCellValue(1, c);
            {$endif}
            if (TVarData(v).VType = varDouble) then
            begin
              if (v <> 0) then
              begin
                TargetStartRow := c - 1;
                break;
              end;
            end
            else
            begin
              if (v <> '') then
              begin
                TargetStartRow := c - 1;
                break;
              end;
            end;
          end;
        end;

        // die Befehlszeile aufsammeln
        if AusgabeRotiert then
        begin
          {$ifdef fpc}
          for r := 1 to succ(ActiveWorksheet.GetLastRowIndex) do
          begin
            OutCommands.add(ActiveWorksheet.ReadAsText(pred(r), TargetStartRow));
            ActiveWorksheet.WriteBlank(pred(r), pred(TargetStartRow), true);
            ActiveWorksheet.WriteBlank(pred(r), TargetStartRow, true);
          end;
          {$else}
          for r := 1 to RowCount do
          begin
            OutCommands.add(getCellValue(r, TargetStartRow + 1).ToStringInvariant);
            SetCellValue(r, TargetStartRow, '');
            SetCellValue(r, TargetStartRow + 1, '');
          end;
          {$endif}
        end
        else
        begin
          {$ifdef fpc}
          for c := 0 to ActiveWorksheet.GetLastColIndex do
          begin
            OutCommands.add(ActiveWorksheet.ReadAsText(TargetStartRow, c));
            ActiveWorksheet.WriteBlank(pred(TargetStartRow), c, true);
            ActiveWorksheet.WriteBlank(TargetStartRow, c, true);
          end;
          {$else}
          for c := 1 to ColCountInRow(1) do
          begin
            OutCommands.add(getCellValue(TargetStartRow + 1, c).ToStringInvariant);
            SetCellValue(TargetStartRow, c, '');
            SetCellValue(TargetStartRow + 1, c, '');
          end;
          {$endif}
        end;
      end;

      TargetRow := TargetStartRow;
      with xImport do
      begin

        // die Datenfeld-Namen alle lesen!
        {$ifdef fpc}
        // imp pend
        {$else}
        for c := 1 to ColCountInRow(1) do
          inHeaders.add(getCellValue(1, c).ToStringInvariant);
        {$endif}

        {$ifdef fpc}
        // imp pend
        for r := 2 to 2 do
        {$else}
        for r := 2 to RowCount do
        {$endif}
          for s := 0 to 3 do
          begin

            case s of
              0:
                begin
                  _NETTO := format('%.2f', [
                    { } StrToDoubleDef(read(r, 'LIEFERBETRAG'), 0) -
                    { } StrToDoubleDef(read(r, 'NETTO1'), 0) -
                    { } StrToDoubleDef(read(r, 'NETTO2'), 0) -
                    { } StrToDoubleDef(read(r, 'NETTO3'), 0) -
                    { } StrToDoubleDef(read(r, 'STEUER1'), 0) -
                    { } StrToDoubleDef(read(r, 'STEUER2'), 0) -
                    { } StrToDoubleDef(read(r, 'STEUER3'), 0)]);
                  _SATZ := '';
                  _STEUER := '';
                  _KONTO := '4200';
                end;
              1:
                begin
                  _NETTO := read(r, 'NETTO1');
                  _SATZ := read(r, 'SATZ1');
                  _STEUER := read(r, 'STEUER1');
                  _KONTO := '4400';
                end;
              2:
                begin
                  _NETTO := read(r, 'NETTO2');
                  _SATZ := read(r, 'SATZ2');
                  _STEUER := read(r, 'STEUER2');
                  _KONTO := '4300';
                end;
              3:
                begin
                  _NETTO := read(r, 'NETTO3');
                  _SATZ := read(r, 'SATZ3');
                  _STEUER := read(r, 'STEUER3');
                  _KONTO := '4500';
                end;
            end;

            _BRUTTO := format('%.2f', [StrToDoubleDef(_NETTO, 0) + StrToDoubleDef(_STEUER, 0)]);

            if isZeroMoney(StrToDoubleDef(_BRUTTO, 0)) then
              continue;

            if read(r, 'LAND') <> 'DE' then
            begin
              // nur bei Ausländern prüfen!
              if (read(r, 'EU') = 'Y') and (read(r, 'UST_ID') <> '') then
                _KONTO := '4125';
              //
              if read(r, 'EU') <> 'Y' then
                _KONTO := '4120';
            end;

            for c := 1 to OutCommands.count do
            begin
              Command := OutCommands[pred(c)];

              if (Command <> '') then
              begin

                // Content ermitteln
                ContentAsWideString := '';
                repeat

                  // Referenz auf ein externes Feld
                  // Syntax >Anker-Fremd.Anker-Lokal.Spalte
                  //
                  if (pos('>', Command) = 1) then
                  begin
                    ContentAsWideString := getRef(r, copy(Command, 2, MaxInt));
                    break;
                  end;

                  // ein konstanter String!
                  if (pos('"', Command) = 1) or (pos('\', Command) = 1) then
                  begin
                    ContentAsWideString := copy(Command, 2, MaxInt);
                    break;
                  end;

                  // 1. Teil einer Blankseparierung
                  if (pos('.1', Command) = 1) then
                  begin
                    k := getHeaderIndex(getParamValue(1));
                    ContentAsWideString := nextp(read(r, k), ' ', 0);
                    break;
                  end;

                  // 2. Teil einer Blankseparierung
                  if (pos('.2', Command) = 1) then
                  begin
                    k := getHeaderIndex(getParamValue(1));
                    ContentAsWideString := nextp(read(r, k), ' ', 1);
                    break;
                  end;

                  // falsche j/n Felder (autofill)
                  if (pos('.ja', Command) = 1) then
                  begin
                    k := getHeaderIndex(getParamValue(1));
                    if (pos(read(r, k), 'xXjJyYkKlL5') > 0) then
                      ContentAsWideString := 'ja'
                    else
                      ContentAsWideString := 'nein';
                    break;
                  end;

                  // falsche j/n Felder (autofill)
                  if (pos('.j', Command) = 1) then
                  begin
                    k := getHeaderIndex(getParamValue(1));
                    if (pos(read(r, k), 'xXjJyYkKlL5') > 0) then
                      ContentAsWideString := 'j'
                    else
                      ContentAsWideString := 'n';
                    break;
                  end;

                  // echte j/n Felder
                  if (pos('.J', Command) = 1) then
                  begin
                    k := getHeaderIndex(getParamValue(1));
                    repeat

                      if (pos(read(r, k), 'xXjJyYkKlL51') > 0) then
                      begin
                        ContentAsWideString := 'j';
                        break;
                      end;

                      if (pos(read(r, k), 'nNmMoO60') > 0) then
                      begin
                        ContentAsWideString := 'n';
                        break;
                      end;

                      ContentAsWideString := ' ';

                    until yet;
                    break;
                  end;

                  // interne Sonderfunktionen
                  if (pos('.t', Command) = 1) then
                  begin
                    ContentAsWideString := oemFunction(r, getParamValue(1));
                    break;
                  end;

                  // Felder addieren
                  if (pos('.+', Command) = 1) then
                  begin
                    k := 1;
                    repeat
                      NextSubFieldName := getParamValue(k);
                      if (NextSubFieldName = '') then
                        break;
                      if CharInSet(NextSubFieldName[1], ['''', '"']) then
                      begin
                        // Konstanter Wert!
                        ContentAsWideString := ContentAsWideString +
                          copy(NextSubFieldName, 2, length(NextSubFieldName) - 2);
                      end
                      else
                      begin
                        if pos('!', NextSubFieldName) = 1 then
                        begin
                          kk := getHeaderIndex(copy(NextSubFieldName, 2, MaxInt));
                          ContentAsWideString := cutblank(ContentAsWideString + read(r, kk));
                        end
                        else
                        begin
                          kk := getHeaderIndex(NextSubFieldName);
                          ContentAsWideString := cutblank(ContentAsWideString + ' ' + read(r, kk));
                        end;
                      end;
                      inc(k);
                    until eternity;
                    break;
                  end;

                  // Multible Choice mit .*
                  if (pos('.*', Command) = 1) then
                  begin
                    //
                    k := 1;
                    repeat
                      NextSubFieldName := getParamValue(k);
                      if (NextSubFieldName = '') then
                        break;

                      // der default Parameter
                      if (NextSubFieldName = '*') then
                      begin
                        ContentAsWideString := getParamValue(k + 1);
                        break;
                      end;

                      // der exacte Parameter
                      kk := getHeaderIndex(NextSubFieldName);
                      if (read(r, kk) = 'X') then
                      begin
                        ContentAsWideString := getParamValue(k + 1);
                        break;
                      end;
                      inc(k, 2);
                    until eternity;
                    break;
                  end;

                  // Logik mit "X" Feldern
                  if (pos('.l', Command) = 1) then
                  begin
                    ContentAsWideString := parseLogik(r, copy(Command, 4, MaxInt));
                    break;
                  end;

                  if Command = 'NETTO' then
                  begin
                    ContentAsWideString := _NETTO;
                    break;
                  end;

                  if Command = 'SATZ' then
                  begin
                    ContentAsWideString := _SATZ;

                    break;
                  end;

                  if Command = 'STEUER' then
                  begin
                    ContentAsWideString := _STEUER;

                    break;
                  end;

                  if Command = 'BRUTTO' then
                  begin
                    ContentAsWideString := _BRUTTO;

                    break;
                  end;

                  if Command = 'KONTO' then
                  begin
                    ContentAsWideString := _KONTO;

                    break;
                  end;

                  // letzte Möglichkeit 1:1 Beziehung
                  k := getHeaderIndex(Command);
                  if (k > 0) then
                  begin
                    ContentAsWideString := read(r, k);
                    break;
                  end;

                until yet;

                if (ErrorCount = 0) then
                begin
                  {$ifdef fpc}
                  // imp pend
                  {$else}
                  if AusgabeRotiert then
                    xExport.SetCellValue(c, TargetRow, MonDaCode(ContentAsWideString))
                  else
                    xExport.SetCellValue(TargetRow, c, MonDaCode(ContentAsWideString));
                  {$endif}
                end
                else
                begin
                  {$ifdef fpc}
                  // imp pend
                  {$else}
                  if AusgabeRotiert then
                    xExport.SetCellValue(c, TargetRow, 'ERROR')
                  else
                    xExport.SetCellValue(TargetRow, c, 'ERROR');
                  {$endif}
                end;

              end;
              if (TargetStartRow <> TargetRow) then
              begin
                {$ifdef fpc}
                // imp pend
                {$else}
                if AusgabeRotiert then
                begin
                  xExport.SetCellFormat(c, TargetRow, xExport.getCellFormat(c, TargetStartRow));
                  xExport.setColWidth(TargetRow, xExport.getColWidth(TargetStartRow));
                end
                else
                  xExport.SetCellFormat(TargetRow, c, xExport.getCellFormat(TargetStartRow, c));
                {$endif}
              end;
              if (ErrorCount > 0) then
                break;
            end;
            inc(TargetRow);
          end;
      end;

      // save it as ...
      conversionOutFName := InFName;
      if (pos('Zaehlerdaten', conversionOutFName) > 0) then
      begin
        ersetze('Zaehlerdaten', 'Konvertiert', conversionOutFName);
      end
      else
      begin
        k := revPos('.', conversionOutFName);
        conversionOutFName := copy(conversionOutFName, 1, k) + 'Konvertiert.xls';
      end;

      FileDelete(conversionOutFName);
      try
        {$ifdef fpc}
        // imp pend
        {$else}
        xExport.Save(conversionOutFName);
        {$endif}
      except
        on e: exception do
        begin
          inc(ErrorCount);
          sDiagnose.add(cERRORText + ' ' + e.message);
          sDiagnose.add(cERRORText + ' ' + conversionOutFName + ' ist durch andere Anwendung geöffnet?');
        end;
      end;

    until yet;
    xImport.Free;
    xExport.Free;
  end;
end;

procedure yTOx(InFName: string);
var
  //
  {$ifdef fpc}
  oImport: TsWorkBook;
  oExport: TsWorkBook;
  {$else}
  oImport: TXLSFile;
  oExport: TXLSFile;
  {$endif}

  rInput, rOutput: integer;
  c, LastC: integer;
  HeaderNames: TStringList;
  HeaderCollectState: boolean;
  FieldName: string;
  FieldValue: string;

begin
  if (InFName = '') or not(FileExists(InFName)) then
  begin
    Error('Usage: Oc <FName>');
  end
  else
  begin

    //
    conversionOutFName := InFName + '.Oc.xls';
    //
    {$ifdef fpc}
    // imp pend
    {$else}
    oImport := TXLSFile.create(true);
    oExport := TXLSFile.create(true);
    FileDelete(conversionOutFName);
    oExport.NewFile(1, TExcelFileFormat.v2003);
    {$endif}

    //
    HeaderNames := TStringList.create;
    HeaderCollectState := true;
    rOutput := 1;
    LastC := MaxInt;
    with oImport do
    begin
      {$ifdef fpc}
      // imp pend
      {$else}
      Open(InFName);
      for rInput := 1 to RowCount do
      begin
        FieldName := cutblank(getCellValue(rInput, 1).ToStringInvariant);
        FieldValue := cutblank(getCellValue(rInput, 2).ToStringInvariant);
        if (FieldName <> '') and (FieldValue <> '') then
        begin
          c := HeaderNames.indexof(FieldName);
          if (c = -1) then
          begin
            if HeaderCollectState then
            begin
              HeaderNames.add(FieldName);
              oExport.SetCellValue(rOutput, HeaderNames.count, FieldValue);
            end;
          end
          else
          begin
            HeaderCollectState := false;
            if (c < LastC) then
              inc(rOutput);
            oExport.SetCellValue(rOutput, c + 1, FieldValue);
            LastC := c;
          end;
        end;
      end;
      oExport.Save(conversionOutFName);
      {$endif}
    end;
    oImport.Free;
    oExport.Free;
    HeaderNames.Free;
  end;
end;

procedure yTOx2(InFName: string);
var
  //
  {$ifdef fpc}
  oImport: TsWorkbook;
  oExport: TsWorkbook;
  {$else}
  oImport: TXLSFile;
  oExport: TXLSFile;
  {$endif}

  rInput, cInput, rOutput: integer;
  c, LastC: integer;
  HeaderNames: TStringList;
  FieldName: string;
  FieldValue: string;

begin

  //
  conversionOutFName := InFName + '.Oc.xls';

  //
  {$ifdef fpc}
  // imp pend
  {$else}
  oImport := TXLSFile.create(true);
  oExport := TXLSFile.create(true);
  FileDelete(conversionOutFName);
  oExport.NewFile(1, TExcelFileFormat.v2003);
  {$endif}

  //
  HeaderNames := TStringList.create;
  rOutput := 1;
  LastC := MaxInt;
  with oImport do
  begin
    {$ifdef fpc}
    // imp pend
    {$else}
    Open(InFName);
    for cInput := 1 to ColCountInRow(1) do
    begin
      if getCellValue(1, cInput).IsEmpty then
        break;
      for rInput := 1 to RowCount do
        oExport.SetCellValue(cInput, rInput, getCellValue(rInput, cInput));
    end;
    oExport.SetCellValue(1, 1, 'ID');
    oExport.Save(conversionOutFName);
    {$endif}
  end;
  oImport.Free;
  oExport.Free;
  HeaderNames.Free;
end;

procedure csvTOcsv(InFName: string);
var
  BK: TStringList;
  csvTABELLE: TStringList;
  ColTyp: integer;
  header, Ueberschrift: string;
  HeaderPointFound: boolean;
  n: integer;
  sLine: string;
  TYP: string;
  csvTABELLE2: TsTable;
begin
  if FileExists(InFName) then
  begin
    BK := TStringList.create;
    csvTABELLE := TStringList.create;
    LoadFromFileCSV(false, BK, InFName);
    if BK.count > 1 then
    begin

      header := BK[0];
      csvTABELLE.add('ZAEHLER_ART;' + BK[0]);
      ColTyp := 0;
      HeaderPointFound := false;
      while (header <> '') do
      begin
        Ueberschrift := cutblank(nextp(header, ';'));
        if (Ueberschrift = cARGOS_TYP) then
        begin
          HeaderPointFound := true;
          break;
        end;
        inc(ColTyp);
      end;

      if not(HeaderPointFound) then
      begin
        Error('Spalten-Ueberschrift ' + cARGOS_TYP + ' nicht gefunden!');
        exit;
      end;
      sLine := '';
      for n := 1 to pred(BK.count) do
      begin
        Ueberschrift := cutblank(nextp(BK[n], ';', ColTyp));
        if (pos(cARGOS_KOPF, Ueberschrift) > 0) then
        begin
          if (sLine <> '') then
            csvTABELLE.add(TYP + ';' + sLine);
          TYP := 'ET';
          sLine := BK[n];
        end;
        if (Ueberschrift = 'Wirkarbeit HT alt') or (Ueberschrift = 'Wirkarbeit NT neu') then
        begin
          TYP := 'DT';
        end;
      end;
      if (sLine <> '') then
        csvTABELLE.add(TYP + ';' + sLine);

      csvTABELLE.SaveToFile(InFName + '.Oc.csv');

      // weitere Konvertierungen durchführen!
      csvTABELLE2 := TsTable.create;
      with csvTABELLE2 do
      begin
        insertFromFile(InFName + '.Oc.csv');
        for n := 1 to pred(count) do
        begin

          //
          writeCell(n, colof('STRASSE_GP'), cutblank(cutblank(readCell(n, colof('STRASSE_GP'))) + ' ' +
            cutblank(readCell(n, colof('HAUS_NR_GP')))));

          //
          writeCell(n, colof('STRASSE'), cutblank(cutblank(readCell(n, colof('STRASSE'))) + ' ' + cutblank(readCell(n,
            colof('HAUS_NR')))));

          //

        end;
        SaveToFile(InFName + '.Oc.csv');
      end;
      csvTABELLE2.Free;

    end
    else
    begin

      Error('Datei ' + InFName + ' ist leer, durch eine andere Anwendung gesperrt oder keine .csv!');
    end;
    BK.Free;
    csvTABELLE.Free;
  end;
end;

procedure txtTOxls(InFName: string);
var
  AutoMataState: integer;
  TheLines: TStringList;
  oneLine: string;
  n: integer;
  FirstLine: boolean;

  // Export Sachen
  {$ifdef fpc}
  // imp pend
  oExport: TsWorkbook;
  {$else}
  oExport: TXLSFile;
  {$endif}

  // Export Datenfelder
  aBestNo: string;
  aTitel: string;
  aOrchester: string;
  aHauptDarsteller: string;
  aWerk: string;
  aKomponist: string;
  nRow: integer;

  procedure writeOne;
  var
    nCol: integer;
  begin
    inc(nRow);
    {$ifdef fpc}
    // imp pend
    {$else}
    oExport.SetCellValue(nRow, 1, aBestNo);
    oExport.SetCellValue(nRow, 2, aTitel);
    oExport.SetCellValue(nRow, 3, aOrchester);
    oExport.SetCellValue(nRow, 4, aWerk);
    nCol := 5;
    while (aKomponist <> '') do
    begin
      oExport.SetCellValue(nRow, nCol, cutblank(nextp(aKomponist, '/')));
      inc(nCol);
    end;
    {$endif}
  end;

  procedure parse(State: integer);
  var
    Werk: string;
  begin
    case State of
      0:
        begin
          if FirstLine and (oneLine <> '') then
          begin
            aOrchester := '';
            aBestNo := nextp(oneLine, ' ');
            aHauptDarsteller := ExtractSegmentBetween(oneLine, '[', ']');
            ersetze('[', '', oneLine);
            ersetze(']', '', oneLine);
            aTitel := cutblank(oneLine);
            FirstLine := false;
            AutoMataState := 1;
          end;
        end;
      1:
        begin
          if FirstLine then
            AutoMataState := 0
          else
          begin
            if (pos(' - ', oneLine) = 0) then
            begin

              //
              if (aOrchester = '') then
                aOrchester := cutblank(oneLine)
              else
                aOrchester := aOrchester + ' ' + cutblank(oneLine);

            end
            else
            begin
              AutoMataState := 2;
              parse(AutoMataState);
            end;
          end;
        end;
      2:
        begin
          while (oneLine <> '') do
          begin
            Werk := nextp(oneLine, ' - ');
            aWerk := nextp(Werk, '/');
            Werk := cutblank(Werk);
            if (Werk <> '') then
              aKomponist := Werk
            else
              aKomponist := aHauptDarsteller;

            writeOne;
          end;
          AutoMataState := 0;
        end;
    end;

  end;

begin

  conversionOutFName := InFName + '.Oc.xls';
  FileDelete(conversionOutFName);

  //
  {$ifdef fpc}
  // imp pend
  oExport := TsWorkbook.Create;
  oExport.AddWorksheet('Tabelle1');
  {$else}
  oExport := TXLSFile.create(true);
  oExport.NewFile(1, TExcelFileFormat.v2003);
  {$endif}

  TheLines := TStringList.create;
  TheLines.loadFromFile(InFName);
  nRow := 0;
  AutoMataState := 0;
  FirstLine := true;

  for n := 0 to pred(TheLines.count) do
  begin
    oneLine := cutblank(TheLines[n]);
    if (oneLine = '') then
      FirstLine := true;
    parse(AutoMataState);

  end;

  {$ifdef fpc}
  // imp pend
  {$else}
  oExport.Save(conversionOutFName);
  {$endif}
  oExport.Free;
  // open(conversionOutFName);
  TheLines.Free;
end;

function CheckContent(InFName: string): integer;
// Export Sachen
var
  {$ifdef fpc}
  xImport: TsWorkbook;
  {$else}
  xImport: TXLSFile;
  {$endif}
  sImport: TStringList;
  c: integer;
  xmlFiles: TStringList;
  FExtension: string;
begin
  result := -1;
  if FileExists(InFName) then
  begin

    // Arbeitspfad öffnen
    WorkPath := ValidatePathName(ExtractFilePath(InFName)) + '\';
    FExtension := ExtractFileExt(InFName);

    if (LowerCase(FExtension) = '.txt') then
    begin
      sImport := TStringList.create;
      sImport.loadFromFile(InFName);
      if (sImport.count > 0) then
        if (pos('KK20', sImport[0]) = 1) then
          result := Content_Mode_KK20
        else
          result := Content_Mode_txt;
      sImport.Free;
      exit;
    end;

    // Vorlage.xls Modus?
    if FileExists(WorkPath + c_XLS_VorlageFName) then
    begin
      result := Content_Mode_xls2xls;
      exit;
    end;

    if FileExists(WorkPath + cFixedFloodFName) then
    begin
      result := Content_Mode_xls2flood;
      exit;
    end;

    // Vorlage.ml Modus?
    if FileExists(WorkPath + c_ML_VorlageFName) then
    begin
      result := Content_Mode_xls2ml;
      exit;
    end;

    // Vorlage.html Modus?
    if FileExists(WorkPath + c_HTML_VorlageFName) then
    begin
      result := Content_Mode_xls2html;
      exit;
    end;

    // IDOC Mode?
    if FileExists(WorkPath + cIDOC_Mappings) then
    begin
      result := Content_Mode_xls2idoc;
      exit;
    end;

    // ARGOS-2007 Mode?
    if FileExists(WorkPath + cARGOS_2007_XML_SAVE + cBL_FileExtension) then
    begin
      result := Content_Mode_xls2Argos2007;
      exit;
    end;

    // ARGOS-2018 Mode?
    if FileExists(WorkPath + cARGOS_2018_XML_SAVE + cBL_FileExtension) then
    begin
      result := Content_Mode_xls2Argos2018;
      exit;
    end;

    // RWE 2.1 - Modus ?
    if FileExists(WorkPath + 'ArbeitsschritteImport-v24.dtd') then
    begin
      result := Content_Mode_xls2gm;
      exit;
    end;

    // In der XLS Datei nach Merkmalen schauen!
    {$ifdef fpc}
    // imp pend
    {$else}
    xImport := TXLSFile.create(true);
    try
      with xImport do
      begin

        Open(InFName);
        result := Content_Mode_xls2csv;
        for c := 1 to ColCountInRow(1) do
        begin

          //
          if (getCellValue(1, c).ToStringInvariant = 'KK22') then
          begin
            result := Content_Mode_KK22;
            break;
          end;

          //
          if (getCellValue(1, c).ToStringInvariant = 'SAP ID') then
          begin
            result := Content_Mode_enBW;
            break;
          end;

          //
          if (getCellValue(1, c).ToStringInvariant = 'KONTO_AR') then
          begin
            result := Content_Mode_Datev;
            break;
          end;

        end;
      end;
    except
      on e: exception do
      begin
        sDiagnose.add(cERRORText + ' ' + e.message);
        sDiagnose.add(cERRORText + ' ' + InFName + ' ist durch andere Anwendung geöffnet?');
      end;
    end;
    xImport.Free;
    {$endif}
  end;
end;

procedure xls2ml(InFName: string; sBericht: TStringList; iModus: eXML_Converter_Mode = eXML_XML_Single);
const
  cSTATUS_Unmoeglich = 9;
  cSTATUS_Vorgezogen = 7;
  cSTATUS_Erfolg = 4;
  cSTATUS_ErfolgGemeldet = 12;
  cSTATUS_UnmoeglichGemeldet = 13;
  cSTATUS_VorgezogenGemeldet = 14;
var
  xlsHeaders: TStringList;
  sResult: THTMLTemplate;
  sCheck: THTMLTemplate;

  // Cache
  xmlToday: string;
  xmlMESSAGE: integer;
  xmlCursor: integer;

  // XLS-Sachen
  {$ifdef fpc}
  xImport: TsWorkbook;
  {$else}
  xImport: TXLSFile;
  {$endif}
  r, c, n: integer;

  // Spalten-Index Konstante
  col_ART: integer;
  col_RID: integer;
  col_Status: integer;
  col_ZaehlerNummer: integer;
  col_ZaehlerNummerNeu: integer;
  col_Quelle: integer; // xml Referenzierungsquelle angegeben?
  col_Anlagen: integer; // Quellpfad für Anlagen angegeben?
  col_HTMLBenennung: integer; // Name der Ausgabe-Datei
  col_Vorlagen: integer; // alternative Vorlagen.html

  // Datenfelder Cache
  ART: string;
  RID: string;
  ZAEHLER_NUMMER: string;
  ZAEHLER_NUMMER_NEU: string;
  STATUS: integer;
  Quelle: string;
  ANLAGENVERZEICHNIS: string;
  ZaehlwerkeLautArt: integer;
  ZaehlwerkeAusbauSoll: integer;
  ZaehlwerkeEinbauSoll: integer;
  ZaehlwerkeAusbauIst: integer;
  ZaehlwerkeEinbauIst: integer;
  ZaehlwerkPostfix: char;
  type_id: string;

  //
  sAlleBloecke: TStringList;
  DatenSammlerEinzel: TStringList;
  DatenSammlerLokal: TStringList;
  DatenSammlerGlobal: TStringList;
  DatenSammlerInit: TStringList;

  // Check-Sachen
  doSchemaCheck: boolean;
  sCheckErgebnis: TStringList;
  iCheckIndex: integer;
  bCheckOK: boolean;

  // weitere Parameter
  isUTF8: boolean;
  ErrorFName: string;
  OutFName: string;
  isAnlagenPathAlreadySet: boolean;
  AlternativeVorlagen: string;
  Vorlage: string;
  VorlageFName: string;
  _FileTouch: TDateTime;

  // über das "INSERT" Statement die Blocks erkennen
  procedure AutoFillBlocks;
  var
    BlockName: string;
    n: integer;
  begin
    // obligatorische Blocks
    with sAlleBloecke do
    begin
      add('G');
      add('E');
      add('E2');
      add('WA');
      add('VORGEZOGEN');
      add('UNMOEGLICH');
    end;

    // Automatisch an den insert-Marken erkennen
    // welche Blocks noch zusätzlich definiert sind (AUFTRAG, ...)
    for n := 0 to pred(sResult.count) do
      if (pos(cHTML_InsertMark, sResult[n]) > 0) then
      begin
        BlockName := ExtractSegmentBetween(sResult[n], cHTML_InsertMark, cHTML_Comment_PostFix);
        if (sAlleBloecke.indexof(BlockName) = -1) then
          sAlleBloecke.add(BlockName);
      end;
    for n := 0 to pred(sAlleBloecke.count) do
      DatenSammlerGlobal.add('save&delete ' + sAlleBloecke[n]);
  end;

  procedure failBecause(Msg: string);
  begin
    if assigned(sBericht) then
      sBericht.add('(RID=' + RID + ') ' + Msg);
  end;

  function x { celValue } (r: integer; c: string): string;
  var
    _c: integer;
  begin
    _c := xlsHeaders.indexof(c);
    if (_c = -1) then
    begin
      result := '?';
      sDiagnose.add(cERRORText + ' Spalte "' + c + '" nicht gefunden!');
      inc(ErrorCount);
    end
    else
    begin
      // result := xImport.getCellValue(r, succ(_c)).ToString;
      {$ifdef fpc}
      // imp pend
      {$else}
      result := xImport.GetStringFromCell(r, succ(_c));
      {$endif}
      ersetze('"', '''', result);
      ersetze('&', c_xml_ampersand, result);
      if isUTF8 then
        result := AnsitoUTF8(result);
    end;
  end;

  function xd_datum(r: integer): string; overload;
  var
    _cd: integer;
    _ct: integer;
    d, t: TDateTime;
    v: Variant;
    s: string;
  begin
    _cd := xlsHeaders.indexof('WechselDatum');
    _ct := xlsHeaders.indexof('WechselZeit');

    if (_cd = -1) or (_ct = -1) then
    begin
      result := '?';
      sDiagnose.add(cERRORText + ' Spalte "WechselDatum" oder "WechselZeit" nicht gefunden!');
      inc(ErrorCount);
    end
    else
    begin

      {$ifdef fpc}
      // imp pend
      {$else}
      d := getDateValue(xImport, r, succ(_cd));
      t := getTimeValue(xImport, r, succ(_ct));
      {$endif}

      if (d = 0) then
      begin
        result := '';
      end else
      begin
        result := long2date(d) + SecondsToStr(t);
        result :=
         { yyyy } copy(result, 7, 4) + '-' +
         { mm } copy(result, 4, 2) + '-' +
         { tt } copy(result, 1, 2);
      end;
    end;
  end;

  function xd_datum2(r: integer): string;
  begin
    result := StrFilter(xd_datum(r), '0123456789');
  end;

  function xd_uhr(r: integer): string; overload;
  var
    _ct: integer;
     t: TDateTime;
    v: Variant;
    s: string;
  begin
    _ct := xlsHeaders.indexof('WechselZeit');

    if (_ct = -1) then
    begin
      result := '?';
      sDiagnose.add(cERRORText + ' Spalte "WechselZeit" nicht gefunden!');
      inc(ErrorCount);
    end
    else
    begin
      {$ifdef fpc}
      // imp pend
      {$else}
      t := getTimeValue(xImport, r, succ(_ct));
      {$endif}

      if (t = 0) then
      begin
        result := '';
      end else
      begin
        result := SecondsToStr(t);
      end;
    end;
  end;

  function xWechselMoment(r: integer): TDateTime;
  var
    _cd: integer;
    _ct: integer;
    d, t: TDateTime;
    v: Variant;
    s: string;
  begin
    _cd := xlsHeaders.indexof('WechselDatum');
    _ct := xlsHeaders.indexof('WechselZeit');

    if (_cd = -1) or (_ct = -1) then
    begin
      result := 0;
      sDiagnose.add(cERRORText + ' Spalte "WechselDatum" oder "WechselZeit" nicht gefunden!');
      inc(ErrorCount);
    end
    else
    begin
      {$ifdef fpc}
      // imp pend
      {$else}
      d := getDateValue(xImport, r, succ(_cd));
      t := getTimeValue(xImport, r, succ(_ct));
      {$endif}

      // ensure Date+Time, but not in any case
      repeat
        result := 0;
        if (d=0) and (t=0) then
          break;

        if (d=0) and (t<>0) then
          d := trunc(now);
        if (d<>0) and (t=0) then
          t := 0.5;

        result := d + t;
      until yet;

    end;
  end;

  function x_timestamp(r: integer; c: string): string; overload;
  var
    _cdt: integer;
    d: TDateTime;
    s: string;
    v: Variant;
  begin
    _cdt := xlsHeaders.indexof(c);
    if (_cdt = -1) then
    begin
      result := '?';
      sDiagnose.add(cERRORText + ' Spalte "' + c + '" nicht gefunden!');
      inc(ErrorCount);
    end
    else
    begin

      result := '';
      d := 0;
      try
        {$ifdef fpc}
        // imp pend
        {$else}
        d := getDateTimeValue(xImport, r, succ(_cdt));
        {$endif}

        if (d > 0) then
        begin

          result := long2date(d) + SecondsToStr(d);

          result :=
          { yyyy } copy(result, 7, 4) +
          { mm } copy(result, 4, 2) +
          { tt } copy(result, 1, 2) +
          { hh } copy(result, 11, 2) +
          { mm } copy(result, 14, 2) +
          { ss } copy(result, 17, 2);
        end;
      except
      end;
    end;
  end;

  function x_optional(r: integer; c: string): string; overload;
  begin
    if (xlsHeaders.indexof(c) <> -1) then
      result := x(r, c)
    else
      result := '';
  end;

  procedure SetOutFname;
  var
    k: integer;
  begin
    conversionOutFName := InFName;
    k := revPos('.', conversionOutFName);
    conversionOutFName := copy(conversionOutFName, 1, pred(k)) + cXML_Extension;
  end;

begin
  sResult := THTMLTemplate.create;
  sAlleBloecke := TStringList.create;
  sAlleBloecke.casesensitive := true;
  DatenSammlerEinzel := TStringList.create;
  DatenSammlerLokal := TStringList.create;
  DatenSammlerGlobal := TStringList.create;
  DatenSammlerInit := TStringList.create;

  {$ifdef fpc}
  xImport := TsWorkbook.Create;
  {$else}
  xImport := TXLSFile.create(true);
  {$endif}
  xlsHeaders := TStringList.create;

  xmlToday := Datum10;
  xmlToday :=
  { } copy(xmlToday, 7, 4) + '-' +
  { } copy(xmlToday, 4, 2) + '-' +
  { } copy(xmlToday, 1, 2);
  xmlMESSAGE := 1;
  bCheckOK := true;
  isAnlagenPathAlreadySet := false;

  DatenSammlerGlobal.add('');

  SetOutFname;

  //
  doSchemaCheck := FileExists(WorkPath + c_ML_SchemaFName) and assigned(sBericht);

  if doSchemaCheck then
    FileDelete(WorkPath + 'Oc-ERROR-*.xml');

  // die Vorlage laden ...
  case iModus of
   eXML_XML_Single: begin
                      sDiagFiles.add(WorkPath + c_ML_VorlageFName);
                      sResult.loadFromFile(WorkPath + c_ML_VorlageFName);
                    end;
   eXML_HTML_Multi: begin
                     repeat
                      if (p_HTML_VorlageFName<>'') then
                       if FileExists(WorkPath + p_HTML_VorlageFName) then
                       begin
                        sDiagFiles.add(WorkPath + p_HTML_VorlageFName);
                        sResult.loadFromFile(WorkPath + p_HTML_VorlageFName);
                        break;
                       end;
                      sDiagFiles.add(WorkPath + c_HTML_VorlageFName);
                      sResult.loadFromFile(WorkPath + c_HTML_VorlageFName);
                     until yet;
                    end;
   eXML_XML_Multi: begin
                    sDiagFiles.add(WorkPath + c_XML_VorlageFName);
                    sResult.loadFromFile(WorkPath + c_XML_VorlageFName);
                   end;
  end;
  p_HTML_VorlageFName := '';

  // UTF-8 Erkennung
  isUTF8 := false;
  if (sResult.count > 0) then
  begin
    if pos('UTF-8', UpperCase(sResult[0])) > 0 then
      isUTF8 := true;
  end;
  if (sResult.count > 1) then
  begin
    if pos('UTF-8', UpperCase(sResult[1])) > 0 then
      isUTF8 := true;
  end;
  if isUTF8 then
    sResult.forceUTF8 := true;

  // weitere Sonderwerte!
  for n := 0 to pred(sResult.count) do
    if (pos(cHTML_Comment_PreFix + 'set ', sResult[n]) = 1) then
    begin
      DatenSammlerInit.add(
        { } 'set ' +
        { } ExtractSegmentBetween(sResult[n], cHTML_Comment_PreFix + 'set ', cHTML_Comment_PostFix));
      if (pos('set ' + cSet_AnlagePath, sResult[n]) > 0) then
      begin
        sDiagFiles.Add(ExtractSegmentBetween(sResult[n],cSet_AnlagePath+' ',cHTML_Comment_PostFix));
        isAnlagenPathAlreadySet := true;
      end;
    end;

  AutoFillBlocks;

  DatenSammlerGlobal.add('AusgabeDatum=' + Datum10);
  DatenSammlerGlobal.add('AusgabeTAN=' + StrFilter(ExtractFileName(InFName), '0123456789'));
  DatenSammlerGlobal.add('AusgabeUhr=' + Uhr8);
  if TestMode then
    DatenSammlerGlobal.add(cSet_AnlagePath + '=' + '.\')
  else
    DatenSammlerGlobal.add(cSet_AnlagePath + '=' + WorkPath);

  with xImport do
  begin

    try
      {$ifdef fpc}
      // imp pend
      {$else}
      Open(InFName);
      {$endif}
    except
      on e: exception do
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' ' + e.message);
        sDiagnose.add(cERRORText + ' ' + InFName + ' ist durch andere Anwendung geöffnet?');
      end;
    end;

    sDiagFiles.add(InFName);

    {$ifdef fpc}
    // imp pend
    {$else}
    for c := 1 to ColCountInRow(1) do
      xlsHeaders.add(getCellValue(1, c).ToStringInvariant);
    {$endif}

    col_ART := xlsHeaders.indexof('Art');
    if (col_ART = -1) then
    begin
      inc(ErrorCount);
      sDiagnose.add(cERRORText + ' Spalte "Art" nicht gefunden!');
      exit;
    end;

    col_RID := xlsHeaders.indexof('ReferenzIdentitaet');
    if (col_RID = -1) then
    begin
      inc(ErrorCount);
      sDiagnose.add(cERRORText + ' Spalte "ReferenzIdentitaet" nicht gefunden!');
      exit;
    end;

    col_Status := xlsHeaders.indexof('Status1');
    if (col_Status = -1) then
    begin
      inc(ErrorCount);
      sDiagnose.add(cERRORText + ' Spalte "Status1" nicht gefunden!');
      exit;
    end;

    col_ZaehlerNummer := xlsHeaders.indexof('Zaehler_Nummer');
    if (col_ZaehlerNummer = -1) then
    begin
      inc(ErrorCount);
      sDiagnose.add(cERRORText + ' Spalte "Zaehler_Nummer" nicht gefunden!');
      exit;
    end;

    // optionale Spalten
    col_Quelle := xlsHeaders.indexof('Quelle');
    col_Anlagen := xlsHeaders.indexof(cSet_AnlagePath);
    col_ZaehlerNummerNeu := xlsHeaders.indexof('ZaehlerNummerNeu');
    col_HTMLBenennung := xlsHeaders.indexof(cOc_HTMLBenennung);
    col_Vorlagen := xlsHeaders.indexof('Vorlagen');

    r := 2;
    repeat
      {$ifdef fpc}
      // imp pend
      {$else}
      ART := cutblank(getCellValue(r, succ(col_ART)).ToStringInvariant);
      ZaehlwerkeLautArt := strtointdef(StrFilter(ART, '0123456789'), 1);
      RID := cutblank(getCellValue(r, succ(col_RID)).ToStringInvariant);
      STATUS := strtointdef(getCellValue(r, succ(col_Status)).ToStringInvariant, -1);
      {$endif}

      // Status bei bereits gemeldeten umsetzen!
      if (STATUS = cSTATUS_ErfolgGemeldet) then
        STATUS := cSTATUS_Erfolg;
      if (STATUS = cSTATUS_UnmoeglichGemeldet) then
        STATUS := cSTATUS_Unmoeglich;
      if (STATUS = cSTATUS_VorgezogenGemeldet) then
        STATUS := cSTATUS_Vorgezogen;

      {$ifdef fpc}
      // imp pend
      {$else}
      ZAEHLER_NUMMER := cutblank(getCellValue(r, succ(col_ZaehlerNummer)).ToStringInvariant);
      if (col_ZaehlerNummerNeu <> -1) then
        ZAEHLER_NUMMER_NEU := cutblank(getCellValue(r, succ(col_ZaehlerNummerNeu)).ToStringInvariant)
      else
        ZAEHLER_NUMMER_NEU := '';
      {$endif}

      if (ART <> '') then
      begin
        DatenSammlerEinzel.clear;
        DatenSammlerEinzel.addStrings(DatenSammlerInit);

        // den RID transportieren, damit man im Fehlerfall
        // etwas genauer lokalisieren an "wem" es gelegen hat!
        DatenSammlerEinzel.add('set ' + cSet_Context + ' ' + RID);
        DatenSammlerEinzel.add('set ' + cSet_Key + ' ' + ZAEHLER_NUMMER);

        // Referenzquelle
        if (col_Quelle <> -1) then
        begin
          {$ifdef fpc}
          // imp pend
          {$else}
          Quelle := cutblank(getCellValue(r, succ(col_Quelle)).ToStringInvariant);
          {$endif}
          if (Quelle <> '') then
            DatenSammlerEinzel.add(
              { } 'set ' + cSet_Quelle + ' ' +
              { } WorkPath + Quelle);
        end
        else
        begin
          Quelle := '';
        end;

        if not(isAnlagenPathAlreadySet) then
          if not(TestMode) then
          begin
            if (col_Anlagen <> -1) then
              {$ifdef fpc}
              // imp pend
              {$else}
              ANLAGENVERZEICHNIS := cutblank(getCellValue(r, succ(col_Anlagen)).ToStringInvariant)
              {$endif}
            else
              ANLAGENVERZEICHNIS := '';

            if (ANLAGENVERZEICHNIS = '') or (ANLAGENVERZEICHNIS = '.') then
              ANLAGENVERZEICHNIS := WorkPath;

            DatenSammlerEinzel.add(
              { } 'set ' + cSet_AnlagePath + ' ' +
              { } ANLAGENVERZEICHNIS);
          end;

        // Die Zählwerke werden gezählt, dabei
        // werden Context-Variable gesetzt, die beim
        // Include wieder Verwendung finden!
        ZaehlwerkeAusbauIst := 1;
        for ZaehlwerkPostfix := 'A' to 'M' do
        begin
          if (x_optional(r, 'N' + ZaehlwerkPostfix) <> '') then
            inc(ZaehlwerkeAusbauIst)
          else
            break;
        end;
        DatenSammlerEinzel.add('set ZählwerkeAusbauIst ' + inttostr(ZaehlwerkeAusbauIst));

        ZaehlwerkeEinbauIst := 1;
        for ZaehlwerkPostfix := 'N' to 'Z' do
        begin
          if (x_optional(r, 'N' + ZaehlwerkPostfix) <> '') then
            inc(ZaehlwerkeEinbauIst)
          else
            break;
        end;
        DatenSammlerEinzel.add('set ZählwerkeEinbauIst ' + inttostr(ZaehlwerkeEinbauIst));

        // Block laden
        case STATUS of
          cSTATUS_Unmoeglich, cSTATUS_UnmoeglichGemeldet:
            DatenSammlerEinzel.add('load UNMOEGLICH|AUFTRAG,AUFTRAG');
          cSTATUS_Vorgezogen, cSTATUS_VorgezogenGemeldet:
            DatenSammlerEinzel.add('load VORGEZOGEN|AUFTRAG,AUFTRAG');
          cSTATUS_Erfolg, cSTATUS_ErfolgGemeldet:
            begin
              DatenSammlerEinzel.add('load ' + ART + '|AUFTRAG,AUFTRAG');

              if (pos('E', ART) = 1) then
              begin

                // Ev. noch Ausbau
                if (sAlleBloecke.indexof('AUSBAU_' + inttostr(ZaehlwerkeAusbauIst)) <> -1) then
                  DatenSammlerEinzel.add('write AUSBAU_' + inttostr(ZaehlwerkeAusbauIst) + ',AUSBAU');

                // Ev. noch Einbau
                if (sAlleBloecke.indexof('EINBAU_' + inttostr(ZaehlwerkeEinbauIst)) <> -1) then
                  DatenSammlerEinzel.add('write EINBAU_' + inttostr(ZaehlwerkeEinbauIst) + ',EINBAU');

              end;
            end;
        end;

        // ev. bei Bedarf dereferenzieren
        if (Quelle <> '') then
          DatenSammlerEinzel.add('dereference');

        // Daten
        for n := 0 to pred(xlsHeaders.count) do
          DatenSammlerEinzel.add(xlsHeaders[n] + '=@' + x(r, xlsHeaders[n]));
        DatenSammlerEinzel.add('WechselDatum_2=' + xd_datum(r));
        DatenSammlerEinzel.add('WechselDatum_3=' + xd_datum2(r));
        DatenSammlerEinzel.add('WechselZeit_2=' + xd_uhr(r));
        DatenSammlerEinzel.add(cPageBreakHerePossible);

        // Wenn es ein Schema gibt nun so vorgehen.
        // a) Zur "Probe" muss leider eine Einzelausbelichtung gemacht werden!
        // b) Diese Einzelbelichtung muss gegen das schema geprüft werden
        // c-1) ist alles "OK" -> weiter im Text
        // c-2) wenn nicht muss die Fehlermeldung in den Bericht!

        if doSchemaCheck then
        begin

          // a)
          sCheck := THTMLTemplate.create;
          if isUTF8 then
            sCheck.forceUTF8 := true;
          sCheck.addStrings(sResult);
          sCheck.WriteValue(DatenSammlerEinzel, DatenSammlerGlobal);
          sCheck.SavetoFileCompressed(WorkPath + c_ML_CheckFName);
          sCheck.Free;

          // b)
          sCheckErgebnis := TStringList.create;
          xmlXxsd(WorkPath + c_ML_CheckFName, sCheckErgebnis);
          bCheckOK := true;
          for iCheckIndex := 0 to pred(sCheckErgebnis.count) do
            if pos(cERRORText, sCheckErgebnis[iCheckIndex]) > 0 then
            begin
              // c-2: Fehlermeldung in einen Context bringen!
              sBericht.add('(RID=' + RID + ') ' + sCheckErgebnis[iCheckIndex]);
              bCheckOK := false;
            end;

          // c)
          if bCheckOK then
          begin
            FileDelete(WorkPath + c_ML_CheckFName)
          end
          else
          begin
            ErrorFName := WorkPath + 'Oc-ERROR-' + RID + '.xml';
            RenameFile(WorkPath + c_ML_CheckFName, ErrorFName);
            AppendStringsToFile(sCheckErgebnis, ErrorFName);
          end;
          sCheckErgebnis.Free;

        end;

        // c-1: nun zum ganzen Volumen dazu!
        if bCheckOK then
        begin

          case iModus of

            eXML_HTML_Multi:begin

              // weitere/alternative Vorlagen?
              AlternativeVorlagen := '';
              Vorlage := '';
              if (col_Vorlagen <> -1) then
              {$ifdef fpc}
              // imp pend
              {$else}
              AlternativeVorlagen := getCellValue(r, succ(col_Vorlagen)).ToStringInvariant;
              {$endif}

              repeat

                // Name der HTML Ausgabe-Datei berechnen
                if (col_HTMLBenennung <> -1) then
                begin
                  {$ifdef fpc}
                  // imp pend
                  {$else}
                  OutFName := getCellValue(r, succ(col_HTMLBenennung)).ToStringInvariant;
                  {$endif}
                end
                else
                begin
                  if (ZAEHLER_NUMMER_NEU <> '') then
                    OutFName :=
                    { } ZAEHLER_NUMMER + '-' +
                    { } ZAEHLER_NUMMER_NEU
                  else
                    OutFName :=
                    { } ZAEHLER_NUMMER;
                end;

                OutFName := StrFilter(OutFName, cInvalidFNameChars, true);

                Vorlage := StrFilter(cutblank(nextp(AlternativeVorlagen)), cInvalidFNameChars, true);
                if (Vorlage<>'') then
                  OutFName := OutFName + '-' + Vorlage;

                // unschöne "leere" Parameter werden entfernt!
                ersetze('--','-',OutFName);

                OutFName := OutFName + '.html';

                // bisheriges eventuell vorhandenes PDF ist nicht mehr gültig!
                FileDelete(WorkPath + OutFName + '.pdf');

                // Ausgabe speichern!
                sCheck := THTMLTemplate.create;
                if isUTF8 then
                  sCheck.forceUTF8 := true;
                if (Vorlage='') then
                 sCheck.addStrings(sResult)
                else
                begin
                 VorlageFName := WorkPath + 'Vorlage-' + Vorlage + '.html';
                 if FileExists(VorlageFName) then
                 begin
                  sDiagFiles.add(VorlageFName);
                  sCheck.LoadFromFile(VorlageFName);
                 end else
                  failBecause('Vorlage "'+VorlageFName+'" nicht gefunden');
                end;
                sCheck.WriteValue(DatenSammlerEinzel, DatenSammlerGlobal);

                if assigned(sBericht) then
                begin
                  sBericht.addStrings(sCheck.Messages);
                  sBericht.add(cINFOText + ' save ' + OutFName);
                end
                else
                begin
                  sDiagnose.addStrings(sCheck.Messages);
                  sDiagnose.add(cINFOText + ' save ' + OutFName);
                end;

                // .html speichern
                sCheck.SavetoFileCompressed(WorkPath + OutFName);
                sCheck.Free;

                // Auf das aktuelle Wechseldatum setzen
                _FileTouch := xWechselMoment(r);
                if (_FileTouch<>0) then
                  FileTouch(
                    { } WorkPath + OutFName,
                    { } _FileTouch);

              until (AlternativeVorlagen='');

            end;
           eXML_XML_Multi:begin

              // Name der HTML Ausgabe-Datei
              if (col_HTMLBenennung <> -1) then
              begin
                {$ifdef fpc}
                // imp pend
                {$else}
                OutFName := getCellValue(r, succ(col_HTMLBenennung)).ToStringInvariant;
                {$endif}
              end
              else
              begin
                if (ZAEHLER_NUMMER_NEU <> '') then
                  OutFName :=
                  { } ZAEHLER_NUMMER + '-' +
                  { } ZAEHLER_NUMMER_NEU
                else
                  OutFName :=
                  { } ZAEHLER_NUMMER;
              end;

              OutFName := StrFilter(OutFName, cInvalidFNameChars, true) + '.xml';

              // Ausgabe speichern!
              sCheck := THTMLTemplate.create;
              if isUTF8 then
                sCheck.forceUTF8 := true;
              sCheck.addStrings(sResult);
              sCheck.WriteValue(DatenSammlerEinzel, DatenSammlerGlobal);

              if assigned(sBericht) then
              begin
                sBericht.addStrings(sCheck.Messages);
                sBericht.add(cINFOText + ' save ' + OutFName);
              end
              else
              begin
                sDiagnose.addStrings(sCheck.Messages);
                sDiagnose.add(cINFOText + ' save ' + OutFName);
              end;

              // speichern
              sCheck.SavetoFileCompressed(WorkPath + OutFName);
              sCheck.Free;

              // Auf das aktuelle Wechseldatum setzen
              _FileTouch := xWechselMoment(r);
              if (_FileTouch<>0) then
                FileTouch(
                  { } WorkPath + OutFName,
                  { } _FileTouch);

           end;
           eXML_XML_Single: DatenSammlerLokal.addStrings(DatenSammlerEinzel);
          end;
        end;
      end;
      inc(r);
      {$ifdef fpc}
      // imp pend
    until (r > 1);
      {$else}
    until (r > RowCount);
      {$endif}
  end;

  // Belichtung des Resultates
  if (iModus=eXML_XML_Single) then
    sResult.WriteValue(DatenSammlerLokal, DatenSammlerGlobal);

  inc(ErrorCount, sResult.FatalErrors);

  if (ErrorCount = 0) then
  begin
    if (iModus=eXML_XML_Single) then
    begin
      sDiagFiles.add(conversionOutFName);
      sResult.SavetoFileCompressed(conversionOutFName);
    end;
  end
  else
  begin
    FileDelete(conversionOutFName);
    sResult.SaveToFile(WorkPath + 'Diagnose.xml');
  end;

  if assigned(sBericht) then
    sBericht.addStrings(sResult.Messages)
  else
    sDiagnose.addStrings(sResult.Messages);

  //
  sAlleBloecke.Free;
  DatenSammlerLokal.Free;
  DatenSammlerGlobal.Free;
  DatenSammlerEinzel.Free;
  DatenSammlerInit.Free;
  sResult.Free;
  xImport.Free;
  xlsHeaders.Free;
end;

// XSD - Validierung

{$ifndef fpc}
procedure _xmlSchemaValidityErrorFunc(ctx: pointer; const msg1, msg2, msg3, msg4: wasPChar); cdecl;
var
  s: string;
begin
  s := StrFilter(format(msg1, [msg2, msg3, msg4]), #$0A#$0D, true);
  with TStringList(ctx) do
  begin
    add(cERRORText + ' ' + 'VALIDITY: ' + s);
  end;
end;

procedure _xmlSchemaValidityWarningFunc(ctx: pointer; const msg1, msg2, msg3, msg4: wasPChar); cdecl;
var
  s: string;
begin
  s := StrFilter(format(msg1, [msg2, msg3, msg4]), #$0A#$0D, true);
  with TStringList(ctx) do
  begin
    add(cWARNINGText + ' ' + 'VALIDITY: ' + s);
  end;
end;

procedure _xmlStructuredErrorFunc(userData: pointer; Error: xmlErrorPtr); cdecl;
var
  sPreFix: string;
begin
  case Error.level of
    XML_ERR_NONE, XML_ERR_WARNING:
      begin
        sPreFix := cWARNINGText;
      end;
    XML_ERR_ERROR, XML_ERR_FATAL:
      begin
        sPreFix := cERRORText;
      end;
  end;
  TStringList(userData).add(format(sPreFix + ' ' + 'NICHT VALIDE ZEILE %d,%d: %s',
    [Error.Line, Error.int2, Error.message]));
end;

procedure xmlXxsd(InFName: string; sBericht: TStringList);
var
  schema_doc: xmlDocPtr;
  parser_ctxt: xmlSchemaParserCtxtPtr;
  schema: xmlSchemaPtr;
  valid_ctxt: xmlSchemaValidCtxtPtr;
  Res: LongInt;
  xmlFileName: array [0 .. 1023] of AnsiChar;
  xsdFileName: array [0 .. 1023] of AnsiChar;
begin
  //
  if not(assigned(sBericht)) then
    exit;

  StrPCopy(xsdFileName, ExtractFilePath(InFName) + 'Schema.xsd');
  StrPCopy(xmlFileName, InFName);

  repeat

    schema_doc := xmlReadFile(xsdFileName, nil, integer(XML_PARSE_NONET));
    if (schema_doc = nil) then
    begin
      sBericht.add(cERRORText + ' ' + 'Schema "' + xsdFileName + '" konnte nicht geöffnet werden!');
      break;
    end;

    parser_ctxt := xmlSchemaNewDocParserCtxt(schema_doc);
    if (parser_ctxt = nil) then
    begin
      sBericht.add(cERRORText + ' ' + 'unable to create a parser context for the schema "' + xsdFileName + '"!');
      xmlFreeDoc(schema_doc);
      break;
    end;

    schema := xmlSchemaParse(parser_ctxt);
    if (schema = nil) then
    begin
      sBericht.add(cERRORText + ' ' + 'the schema itself is not valid "' + xsdFileName + '"!');
      xmlSchemaFreeParserCtxt(parser_ctxt);
      xmlFreeDoc(schema_doc);
      break;
    end;

    valid_ctxt := xmlSchemaNewValidCtxt(schema);
    if (valid_ctxt = nil) then
    begin

      sBericht.add(cERRORText + ' ' + 'unable to create a validation context for the schema "' + xsdFileName + '"!');
      xmlSchemaFree(schema);
      xmlSchemaFreeParserCtxt(parser_ctxt);
      xmlFreeDoc(schema_doc);
      break;
    end;
    (*
      xmlSchemaSetValidErrors(valid_ctxt,
      xmlSchemaValidityErrorFunc(@_xmlSchemaValidityErrorFunc),
      xmlSchemaValidityWarningFunc(@_xmlSchemaValidityWarningFunc),pointer(sBericht));
    *)
    xmlSchemaSetValidStructuredErrors(valid_ctxt, _xmlStructuredErrorFunc, pointer(sBericht));

    Res := xmlSchemaValidateFile(valid_ctxt, xmlFileName, 0);
    xmlSchemaFreeValidCtxt(valid_ctxt);
    xmlSchemaFree(schema);
    xmlSchemaFreeParserCtxt(parser_ctxt);
    xmlFreeDoc(schema_doc);

  until yet;

end;

// DTD - Validierung
procedure _xmlTextReaderErrorFunc(arg: pointer; const Msg: PAnsiChar; severity: xmlParserSeverities;
  locator: xmlTextReaderLocatorPtr); cdecl;
var
  s: string;
begin
  s := StrFilter(Msg, #$0A#$0D, true);
  with TStringList(arg) do
  begin
    case severity of
      XML_PARSER_SEVERITY_VALIDITY_WARNING:
        add('Validity warning: ' + s);
      XML_PARSER_SEVERITY_VALIDITY_ERROR:
        add(cERRORText + ' ' + 'VALIDITY: ' + s);
      XML_PARSER_SEVERITY_WARNING:
        add('Warning: ' + s);
      XML_PARSER_SEVERITY_ERROR:
        add(cERRORText + ' ' + s);
    end;
  end;
end;

procedure xmlXdtd(InFName: string; sBericht: TStringList);
var
  Reader: xmlTextReaderPtr;
  Res: LongInt;
  xmlFileName: array [0 .. 1023] of AnsiChar;
begin
  if not(assigned(sBericht)) then
    exit;

  StrPCopy(xmlFileName, InFName);
  Reader := xmlReaderForFile(xmlFileName, nil, 0);
  if (Reader <> nil) then
  begin
    try
      xmlTextReaderSetErrorHandler(Reader, _xmlTextReaderErrorFunc, pointer(sBericht));
      xmlTextReaderSetParserProp(Reader, integer(xmlParserProperties.XML_PARSER_VALIDATE), 1);

      Res := xmlTextReaderRead(Reader);
      while Res = 1 do
        Res := xmlTextReaderRead(Reader);

    finally
      xmlFreeTextReader(Reader);
    end;
  end
  else
    sBericht.add(cERRORText + ' ' + 'XML-Datei "' + xmlFileName + '" konnte nicht geöffnet werden!');
end;
{$endif}

procedure Huffman(InFName: string);
var
 sTable : TStringList;
 BitCount: TgpIntegerList;
 n,m: integer;
 s: string;
 sResult : TStringList;

  function IntToBinByte(Value: Byte): string;
  var
    i: Integer;
  begin
    SetLength(Result, 8);
    for i := 1 to 8 do begin
      if (Value shl (i-1) and $ff) shr 7 = 0 then begin
        Result[i] := '0'
      end else begin
        Result[i] := '1';
      end;
    end;
  end;

  function known(s:string):boolean;
  var
   n : integer;
  begin
    if (s='') then
    begin
      result := true;
      exit;
    end else
    begin
      result := false;
      for n := 0 to pred(sTable.count) do
       if pos(' '+s,sTable[n])>0 then
       begin
         result := true;
         break;
       end;
    end;
  end;

var
 RecurseLevel: integer;

  function findFull(s:string):INteger;
  var
   n : integer;
   sym : string;
  begin
    result := -1;
    if (length(s)>=5) then
      for n := 0 to pred(sTable.count) do
       if pos(' '+s+' ',sTable[n])>0 then
       begin
         result := n;
         sym := cutblank(ExtractSegmentBetween(copy(sTable[n],1,5),'(',')'));

         if (sym='EOS') then
         begin
          sResult.Add(fill(' ',ReCurseLevel)+' result := true;');
          sResult.Add(fill(' ',ReCurseLevel)+' break;');
         end else
         begin
          { unconditional symbol generation}
          sResult.Add(fill(' ',ReCurseLevel)+' sym('+sym+');');
          {}
          { conditional symbol generation
          sResult.Add(fill(' ',ReCurseLevel)+' if sym('+sym+') then');
          sResult.Add(fill(' ',ReCurseLevel)+'  continue');
          sResult.Add(fill(' ',ReCurseLevel)+' else');
          sResult.Add(fill(' ',ReCurseLevel)+'  break;')
          }
         end;
         sTable.Delete(n);
         break;
       end;
  end;

  procedure Check(s:string='');
  var
   TableIndex: integer;
  begin
   if known(s) and (RecurseLevel<35) then
   begin
    inc(RecurseLevel);
    sResult.Add(fill(' ',ReCurseLevel)+'if B then');
    sResult.Add(fill(' ',ReCurseLevel)+'begin { '+s+'1 }');
    TableIndex := findFull(s+'1');
    if (TableIndex=-1) then
     Check(s+'1');
    sResult.Add(fill(' ',ReCurseLevel)+'end else');
    sResult.Add(fill(' ',ReCurseLevel)+'begin { '+s+'0 }');
    TableIndex := findFull(s+'0');
    if (TableIndex=-1) then
     Check(s+'0');
    sResult.Add(fill(' ',ReCurseLevel)+'end;');
    dec(RecurseLevel);
   end;
  end;

var
 decoderName : string;
begin
  sResult := TStringList.create;

  sTable := TStringList.Create;
  sTable.LoadfromFile(InFname);

  decoderName := ExtractFileName(InFname);
  n := RevPos('.', decoderName);
  if (n>0) then
   decoderName := copy(decodername,1,pred(n));

  sResult.add('');

  BitCount:= TgpIntegerList.create;
  for n := 0 to pred(sTable.Count) do
  begin
    if (pos('[',sTable[n])=0) then
     continue;
    s := noblank(ExtractSegmentBetween(sTable[n],'[',']'));
    m := StrToIntDef(s,-1);
    if (m<>-1) then
     if (BitCount.IndexOf(m)=-1) then
      BitCount.Add(m);
  end;
  BitCount.Sort;

  sResult.add('function decode_'+decoderName+' : boolean;');
  sResult.Add('{ this huffman decoder was generated by Oc Rev. '+RevToStr(Version)+' }');
  sResult.Add('{ '+dTimeStamp(FileDateTime(InFName))+' }');
  sResult.add('begin');
  sResult.Add(' result := false;');
  sResult.Add(' while (Octets>0) do');
  sResult.Add(' begin');
  RecurseLevel := 1;
  Check;
  sResult.Add(' end;');
  sResult.Add('end;');

  for n := 0 to pred(sTable.Count) do
   sDiagnose.Add('ERROR: unfound: '+sTable[n]);

  sResult.SaveToFile(ExtractFilePath(InFname)+decoderName+'.pas');
  {
  HaveNotStart := 0;
  for n := 1 to Bitcount.Last do
  begin
    s := IntToStr(n);
    s := fill(' ',2-length(s)) + s;
    HaveIt := false;
    for m := 0 to pred(sTable.Count) do
     if pos('['+s+']',sTable[m])>0 then
     begin
      sBericht.Add(sTable[m]);
      HaveIt := true;
     end;
    if HaveIt then
    begin
      CaseWidth := n - HaveNotStart;
      if CaseWidth>1 then
      begin
       sBericht.add('case int'+inttostr(CaseWidth)+' of');
       for o := 0 to trunc(Power(2,CaseWidth)) do
        sBericht.add(' %' + IntToBin(o) + ':');
       sBericht.add('end');
      end else
      begin
        sBericht.add('if int1=0 then');
      end;
      HaveNotStart := n;
    end;
  end;
  }


  sTable.Free;
  sResult.Free;
end;

procedure xls2argos2007(InFName: string; sBericht: TStringList);
const
  cSTATUS_Unmoeglich = 9;
  cSTATUS_Vorgezogen = 7;
  cSTATUS_Erfolg = 4;
  cSTATUS_ErfolgGemeldet = 12;
  cSTATUS_UnmoeglichGemeldet = 13;
  cSTATUS_VorgezogenGemeldet = 14;
var
  sSource: TStringList;
  xlsHeaders: TStringList;

  sResult: TStringList;
  sStack: TStringList;
  RollBack: boolean;

  // Auftrag
  bXML: TBLager;
  pXML: pointer;

  // Cache
  xmlToday: string;
  xmlMESSAGE: integer;
  xmlCursor: integer;

  // XLS-Sachen
  {$ifdef fpc}
  xImport: TsWorkBook;
  {$else}
  xImport: TXLSFile;
  {$endif}
  r, c: integer;

  // Spalten Konstante
  cARGOS: integer;
  cART: integer;
  cRID: integer;
  cStatus: integer;

  // Datenfelder Cache
  Argos: int64;
  ART: string;
  RID: string;
  STATUS: integer;
  ZaehlwerkeIst: integer;

  // TAET
  TAET_BEGIN: integer;
  TAET_END: integer;

  // Schnittstellen-Optionen
  Optionen : string;
  p_Melde_Eintarif_in_NT : boolean;


  procedure speak(s: string = '');
  begin
    if (cutblank(s) = '') then
      sResult.add('')
    else
      sResult.add(fill(' ', sStack.count) + s);
  end;

  procedure rollbackBecause(Msg: string);
  begin
    if assigned(sBericht) then
      sBericht.add('(RID=' + RID + ') ' + Msg)
    else
     sDiagnose.add(cERRORText + ' (RID=' + RID + ') ' + Msg);
    RollBack := true;
  end;

  procedure push(tag: string);
  begin
    speak('<' + tag + '>');
    sStack.add(nextp(tag, ' ', 0));
  end;

  procedure pop;
  var
    tag: string;
  begin
    tag := sStack[pred(sStack.count)];
    sStack.delete(pred(sStack.count));
    speak('</' + tag + '>');
  end;

  procedure single(tag, value: string);
  begin
    speak('<' + tag + '>' + value + '</' + tag + '>');
  end;

  function f { ocus } (tag: string): boolean;
  var
    n: integer;
    AutoMataState: integer;
  begin

    //
    TAET_BEGIN := -1;
    TAET_END := -1;
    AutoMataState := 0;
    result := false;
    for n := xmlCursor to pred(sSource.count) do
    begin
      case AutoMataState of
        0:
          begin
            if (pos('<TAET>', sSource[n]) > 0) then
            begin
              TAET_BEGIN := n;
              continue;
            end;
            if (pos('<BEZEICHNUNG>' + tag + '</BEZEICHNUNG>', sSource[n]) > 0) then
            begin
              AutoMataState := 1;
              continue;
            end;
          end;
        1:
          begin
            if (pos('</TAET>', sSource[n]) > 0) then
            begin
              TAET_END := n;
              break;
            end;
          end;
      end;

    end;

    if (TAET_END <= TAET_BEGIN) then
    begin
      // rollbackBecause(inttostr(ARGOS) + ': Bezeichnung "' + Tag + '" nicht gefunden!');
      if assigned(sBericht) then
        sBericht.add('WARNUNG: Bei ' + inttostr(Argos) + ': Bezeichnung "' + tag + '" nicht gefunden!');
    end
    else
    begin
      result := true;
    end;

  end;

  function k { urzBez } (tag: string): boolean;
  var
    n: integer;
    AutoMataState: integer;
  begin

    //
    TAET_BEGIN := -1;
    TAET_END := -1;
    AutoMataState := 0;
    result := false;
    for n := xmlCursor to pred(sSource.count) do
    begin
      case AutoMataState of
        0:
          begin
            if (pos('<TAET>', sSource[n]) > 0) then
            begin
              TAET_BEGIN := n;
              continue;
            end;
            if (pos('<KURZBEZ>' + tag + '</KURZBEZ>', sSource[n]) > 0) then
            begin
              AutoMataState := 1;
              continue;
            end;
          end;
        1:
          begin
            if (pos('</TAET>', sSource[n]) > 0) then
            begin
              TAET_END := n;
              break;
            end;
          end;
      end;

    end;

    if (TAET_END <= TAET_BEGIN) then
    begin
      rollbackBecause(inttostr(Argos) + ': KURZBEZ "' + tag + '" nicht gefunden!');
    end
    else
    begin
      result := true;
    end;

  end;

  function q { uestion } (tag: string; CloseTag: string = 'GERAET'): string;
  var
    n: integer;
    k: integer;
    oneLine: string;
    FoundTag: boolean;
    FullTag: string;
  begin
    result := '"<ReferenceFailed>"';
    FoundTag := false;
    FullTag := '<' + tag + '>';
    for n := succ(TAET_BEGIN) to pred(TAET_END) do
    begin
      if (pos('</' + CloseTag + '>', sSource[n]) > 0) then
        break;
      k := pos(FullTag, sSource[n]);
      if (k = 0) then
        continue;
      oneLine := copy(sSource[n], k + length(FullTag), MaxInt);
      k := pos('</' + tag + '>', oneLine);
      if (k > 0) then
        oneLine := copy(oneLine, 1, pred(k));
      result := oneLine;
      FoundTag := true;
      break;
    end;

    if not(FoundTag) then
      rollbackBecause(inttostr(Argos) + '[' + inttostr(TAET_BEGIN) + ',' + inttostr(TAET_END) + ']' + ': ' + tag +
        ' nicht gefunden!');
  end;

  function qo { uestion optional } (tag: string; CloseTag: string = 'GERAET'): boolean;
  var
    n: integer;
    k: integer;
    oneLine: string;
    FullTag: string;
  begin
    result := false;
    FullTag := '<' + tag + '>';
    for n := succ(TAET_BEGIN) to pred(TAET_END) do
    begin
      if (pos('</' + CloseTag + '>', sSource[n]) > 0) then
        break;
      k := pos(FullTag, sSource[n]);
      if (k = 0) then
        continue;
      oneLine := copy(sSource[n], k + length(FullTag), MaxInt);
      k := pos('</' + tag + '>', oneLine);
      if (k > 0) then
        oneLine := copy(oneLine, 1, pred(k));
      result := true;
      break;
    end;
  end;

  function qao { uestion auftrag optional } (tag: string): string;
  // Frage einen Feldinhalt aus dem originalen Auftrag ab
  // der Auftrag befindet sich vor den Tätigkeitshülsen
  var
    n: integer;
    k: integer;
    oneLine: string;
    FullTag: string;
    Found: boolean;
  begin
    Found := false;
    result := '';
    FullTag := '<' + tag + '>';
    for n := 0 to pred(TAET_BEGIN) do
    begin
      k := pos(FullTag, sSource[n]);
      if (k = 0) then
        continue;
      oneLine := copy(sSource[n], k + length(FullTag), MaxInt);
      k := pos('</' + tag + '>', oneLine);
      if (k > 0) then
      begin
        result := copy(oneLine, 1, pred(k));
        Found := true;
        break;
      end;
    end;
    if Found then
    begin
      if (result = '') then
        speak('<!-- ' + tag + ' war leer -->')
      else
        speak('<!-- ' + tag + ' war ' + result + ' -->');
    end
    else
    begin
      speak('<!-- ' + tag + ' fehlt im Auftrag -->');
    end;
  end;

  procedure fillAufgaben(CloseTag: string = 'GERAET');
  var
    n: integer;
    sXML: TMemoryStream;
  begin

    // sSource mit den richtigen Werten füllen
    bXML.get;
    sXML := TMemoryStream.create;
    sXML.Write(pXML^, bXML.RecordSize);
    sXML.Position := 0;
    sSource.LoadFromStream(sXML);
    sXML.Free;

    // oberen Kopf-Teil der Source übergehen
    xmlCursor := -1;
    for n := 0 to pred(sSource.count) do
      if (pos('<TAET>', sSource[n]) > 0) then
      begin
        xmlCursor := n;
        break;
      end;
    if (xmlCursor < 0) then
    begin
      sDiagnose.add(cERRORText + ' <TAET> nicht gefunden!');
      inc(ErrorCount);
    end;

  end;

  function x { celValue } (r: integer; c: string): string;
  var
    _c: integer;
  begin
    _c := xlsHeaders.indexof(c);
    if (_c = -1) then
    begin
      result := '?';
      sDiagnose.add(cERRORText + ' Spalte "' + c + '" nicht gefunden!');
      inc(ErrorCount);
    end
    else
    begin
      {$ifdef fpc}
      // imp pend
      {$else}
      result := xImport.getCellValue(r, succ(_c)).ToString;
      {$endif}
      ersetze('"', '''', result);
      ersetze('&', c_xml_ampersand, result);
    end;
  end;

  function xd(r: integer): string; overload;
  var
    _cd: integer;
    _ct: integer;
    d, t: TDateTime;
  begin
    _cd := xlsHeaders.indexof('WechselDatum');
    _ct := xlsHeaders.indexof('WechselZeit');

    if (_cd = -1) or (_ct = -1) then
    begin
      result := '?';
      sDiagnose.add(cERRORText + ' Spalte "WechselDatum" oder "WechselZeit" nicht gefunden!');
      inc(ErrorCount);
    end
    else
    begin
      {$ifdef fpc}
      // imp pend
      {$else}
      d := getDateValue(xImport, r, succ(_cd));
      t := getTimeValue(xImport, r, succ(_ct));
      {$endif}

      if (d = 0) then
        d := now;

      result := long2date(d) + SecondsToStr(t);

      result :=
      { tt } copy(result, 1, 2) + '.' +
      { mm } copy(result, 4, 2) + '.' +
      { yyyy } copy(result, 7, 4) + ' ' +
      { hh } copy(result, 11, 2) + ':' +
      { mm } copy(result, 14, 2) + ':' +
      { ss } copy(result, 17, 2);
    end;
  end;

  procedure timeStampBlock(r: integer);
  var
    ts: string;
  begin
    ts := xd(r);
    single('ERGEBNISDATUM', ts);
    single('ERFASSUNGSDATUM', ts);
  end;

  function xd(r: integer; c: string): string; overload;
  var
    _cdt: integer;
    d: TDateTime;
  begin
    _cdt := xlsHeaders.indexof(c);
    if (_cdt = -1) then
    begin
      result := '?';
      sDiagnose.add(cERRORText + ' Spalte "' + c + '" nicht gefunden!');
      inc(ErrorCount);
    end
    else
    begin

      result := '';
      try
        {$ifdef fpc}
        // imp pend
        {$else}
        d := getDateTimeValue(xImport, r, succ(_cdt));
        {$endif}

        if (d > 0) then
        begin

          result := long2date(d) + SecondsToStr(d);

          result :=
          { yyyy } copy(result, 7, 4) +
          { mm } copy(result, 4, 2) +
          { tt } copy(result, 1, 2) +
          { hh } copy(result, 11, 2) +
          { mm } copy(result, 14, 2) +
          { ss } copy(result, 17, 2);

        end;
      except
      end;
    end;

  end;

  function x_optional(r: integer; c: string): string; overload;
  begin
    if (xlsHeaders.indexof(c) <> -1) then
      result := x(r, c)
    else
      result := '';
  end;

  function x_optional_upper(r: integer; c: string): string; overload;
  begin
    if (xlsHeaders.indexof(c) <> -1) then
      result := AnsiupperCase(x(r, c))
    else
      result := '';
  end;

  function x_optional_JNX(r: integer; c: string): string; overload;
  begin
    if (xlsHeaders.indexof(c) <> -1) then
    begin
      result := AnsiupperCase(x(r, c));
      if result = 'X' then
        result := 'ja';
      if result = 'J' then
        result := 'ja';
      if result = 'N' then
        result := 'nein';
    end
    else
      result := '';
  end;

  function x_optional_X(r: integer; c: string): string; overload;
  begin
    if (xlsHeaders.indexof(c) <> -1) then
    begin
      result := AnsiupperCase(x(r, c));
      if result = 'X' then
        result := 'ja'
      else
        result := 'nein';
    end
    else
      result := '';
  end;

  procedure clone(tag: string);
  begin
    single(tag, q(tag));
  end;

  procedure clone_optional(tag: string);
  begin
    if qo(tag) then
      single(tag, q(tag));
  end;

  procedure taet(Bezeichnung, Ergebnis: string; r: integer);
  begin
    if f(Bezeichnung) then
    begin
      push('TAET');
      clone('ID');
      clone('BEZEICHNUNG');
      clone_optional('KURZBEZ');
      single('ERGEBNIS', Ergebnis);
      timeStampBlock(r);
      clone_optional('HOSTKEY');
      pop;
    end;
  end;

  procedure kurz(KurzBez, Ergebnis: string; r: integer);
  begin
    if k(KurzBez) then
    begin
      push('TAET');
      clone('ID');
      clone('BEZEICHNUNG');
      clone_optional('KURZBEZ');
      single('ERGEBNIS', Ergebnis);
      timeStampBlock(r);
      clone_optional('HOSTKEY');
      pop;
    end;
  end;

  procedure OptTaet(Bezeichnung, Ergebnis: string; r: integer);
  begin
    if (Ergebnis <> '') then
      taet(Bezeichnung, Ergebnis, r);
  end;

  procedure OptDiff(Bisher, Bezeichnung, Ergebnis: string; r: integer);
  // nur etwas melden wenn es in Abänderung zum Auftrag steht
  begin
    if (Ergebnis <> '') then
      if (qao(Bisher) <> Ergebnis) then
        taet(Bezeichnung, Ergebnis, r);
  end;

  procedure OneFound(r: integer);
  var
    RollBackPosition, n: integer;
  begin
    RollBackPosition := sResult.count;
    RollBack := false;

    if (ART = 'G') or (ART = 'WA') then
    begin
      // Gas / Wasser
      kurz('Stand', x(r, 'ZaehlerStandAlt'), r);
      kurz('Stand neu', x(r, 'ZaehlerStandNeu'), r);
    end
    else
    begin
      // Strom
      if (ZaehlwerkeIst = 2) then
      begin

        // Ausbau
        kurz('StandHT', x(r, 'ZaehlerStandAlt'), r);
        kurz('StandNT', x(r, 'NA'), r);

        // Einbau
        kurz('StandHTneu', x(r, 'ZaehlerStandNeu'), r);
        kurz('StandNT neu', x(r, 'NN'), r);

      end
      else
      begin
        if p_Melde_Eintarif_in_NT then
        begin

          // Ausbau
          kurz('StandNT', x(r, 'ZaehlerStandAlt'), r);

          // Einbau
          kurz('StandNT neu', x(r, 'ZaehlerStandNeu'), r);

        end else
        begin

          // Ausbau
          kurz('StandHT', x(r, 'ZaehlerStandAlt'), r);

          // Einbau
          kurz('StandHTneu', x(r, 'ZaehlerStandNeu'), r);

        end;
      end;
    end;

    taet('Serial-Nr. neu', x(r, 'ZaehlerNummerNeu'), r);
    taet('Vorgangsgrund', '11', r);
    taet('Gerät ausgebaut', 'ja', r);

    OptTaet('1. gescheiterter Versuch', x(r, 'V1'), r);
    OptTaet('2. gescheiterter Versuch', x(r, 'V2'), r);
    OptTaet('Unterschrift Monteur', x(r, 'MonteurText') + '(' + x(r, 'MonteurHandy') + ')', r);

    OptTaet('Bemerkung', cutblank(x(r, 'I1') + ' ' + x(r, 'I2') + ' ' + x(r, 'I3')), r);

    //
    OptDiff('MOTAGEKENN', 'Korr. MontagekennzeichenNr', x_optional(r, 'SA'), r);
    OptTaet('PlombierungOK', x_optional_X(r, 'SB'), r);
    OptTaet('Mangel sichtbar', x_optional_X(r, 'SC'), r);

    OptDiff('SPERRMKENN', 'Korr. Sperrmöglichkeitnr.', x_optional(r, 'A1'), r);

    OptTaet('Korr. Verbrauchsstelle', x_optional(r, 'A2'), r);

    OptTaet('Korr. Standortnr', x_optional(r, 'A3'), r);
    OptTaet('Korr. Standortzusatz', x_optional(r, 'A4'), r);
    OptTaet('Korr. Standortzusatz Freitext', x_optional(r, 'A5'), r);

    OptTaet('Mängelkarte', x_optional_X(r, 'A6'), r);
    OptTaet('Mängelart', x_optional(r, 'A7'), r);

    OptTaet('Spannungsunterbrechung', x_optional(r, 'SD'), r);
    OptTaet('Dauer Spannungsausfall', x_optional(r, 'N1'), r);

    // Opttaet('TRE Einbau',x_optional(r,'N2'),r);
    OptTaet('Rundsteuerempfänger Ausbau', x_optional(r, 'N2'), r);
    // Opttaet('TRE-Huckepack neu',x_optional(r,'TA'),r);
    OptTaet('Huckepack-TRE', x_optional(r, 'TA'), r);
    // Opttaet('TRE-Kommando Einzeln neu',x_optional(r,'TB'),r);
    OptTaet('TRE-Kommando Einzeln', x_optional(r, 'TB'), r);

    //
    repeat

      if x_optional_upper(r, 'B1') = 'X' then
      begin
        taet('KFR-Ventile', 'RVN', r);
        break;
      end;

      if x_optional_upper(r, 'B2') = 'X' then
      begin
        taet('KFR-Ventile', 'RVD', r);
        break;
      end;

      if x_optional_upper(r, 'B3') = 'J' then
      begin
        taet('KFR-Ventile', 'RVP', r);
        break;
      end;

      if x_optional_upper(r, 'B3') = 'N' then
      begin
        taet('KFR-Ventile', 'RVO', r);
        break;
      end;

    until yet;

    (*
      OptTaet('Korr. Verbrauchsstelle',x_optional(r,'I1'),r);
      OptTaet('Korr. Standortzusatz Freitext',
      cutblank(
      x_optional(r,'I2')+' '+
      x_optional(r,'I3') ),r);
      OptTaet('Anschlussobjekthinweis',x_optional(r,'I4'),r);
    *)

    (*
      taet('Korr. Standort TXT',
      cutblank(
      x(r, 'I3') + '|' +
      x(r, 'I4') + '|' +
      x(r, 'N5') + ' ' + x(r, 'I6')
      ), r);
    *)

    if RollBack then
    begin
      for n := pred(sResult.count) downto RollBackPosition do
        sResult.delete(n);
      speak('<!-- catched ' + inttostr(Argos) + ' before finish line, because of quality policies -->');
      speak('<!-- operator_order_id="' + RID + '" -->');
      if assigned(sBericht) then
      begin
        for n := pred(sBericht.count) downto 0 do
          if (pos('(RID=' + RID + ')', sBericht[n]) > 0) then
            speak('<!-- policy_fail_reason="' + sBericht[n] + '" -->')
          else
            break;
      end;
    end
    else
    begin
      inc(xmlMESSAGE);
    end;
  end;

  procedure SetOutFname;
  var
    k: integer;
  begin
    conversionOutFName := InFName;
    k := revPos('.', conversionOutFName);
    conversionOutFName := copy(conversionOutFName, 1, pred(k)) + cXML_Extension;
  end;

begin
  sResult := TStringList.create;
  sStack := TStringList.create;
  sSource := TSearchStringList.create;

  {$ifdef fpc}
  xImport := TsWorkbook.Create;
  {$else}
  xImport := TXLSFile.create(true);
  {$endif}
  xlsHeaders := TStringList.create;
  bXML := TBLager.create;
  GetMem(pXML, 1024 * 1024);

  xmlToday := Datum10;
  xmlToday := copy(xmlToday, 7, 4) + copy(xmlToday, 4, 2) + copy(xmlToday, 1, 2);
  xmlMESSAGE := 1;

  if FileExists(WorkPath + '_' + cARGOS_2007_XML_SAVE + cBL_FileExtension) then
    bXML.init(WorkPath + '_' + cARGOS_2007_XML_SAVE, pXML^, 1024 * 1024)
  else
    bXML.init(WorkPath + cARGOS_2007_XML_SAVE, pXML^, 1024 * 1024);
  bXML.ReadOnly := true;
  bXML.BeginTransaction;

  SetOutFname;

  with sResult do
  begin

    add('<?xml version="1.0" encoding="iso-8859-1" ?>');

    speak;
    speak('<!--   ___                                  -->');
    speak('<!--  / _ \  ___                            -->');
    speak('<!-- | | | |/ __|  Orientation Convert      -->');
    speak('<!-- | |_| | (__   (c)1987-' + JahresZahl + ' OrgaMon.org -->');
    speak('<!--  \___/ \___|  Rev. ' + RevToStr(Version) + '               -->');
    speak('<!--                                        -->');
    speak;

    speak('<!--<Datum> ' + Datum10 + ' -->');
    speak('<!--<Zeit> ' + Uhr8 + ' -->');
    speak('<!--<TAN> ' + StrFilter(ExtractFileName(InFName), '0123456789') + ' -->');
    speak;

    push('TOUR');
    push('KUNDE');
    push('GERAETEPLATZ');
    push('GERAET');

    with xImport do
    begin

      try
        {$ifdef fpc}
        // imp pend
        {$else}
        Open(InFName);
        {$endif}
      except
        on e: exception do
        begin
          inc(ErrorCount);
          sDiagnose.add(cERRORText + ' ' + e.message);
          sDiagnose.add(cERRORText + ' ' + InFName + ' ist durch andere Anwendung geöffnet?');
        end;
      end;

      sDiagFiles.add(InFName);
      sDiagFiles.add(conversionOutFName);

      {$ifdef fpc}
      // imp pend
      {$else}
      for c := 1 to ColCountInRow(1) do
        xlsHeaders.add(getCellValue(1, c).ToStringInvariant);
      {$endif}


      cARGOS := xlsHeaders.indexof('ARGOS-Optionen');
      if (cARGOS = -1) then
      begin

        // defaults ohne die Spalte "ARGOS-Optionen"
        p_Melde_Eintarif_in_NT := true;

      end else
      begin

        // alternative defaults gültig bei reiner Existenz der Spalte "ARGOS-Optionen"
        p_Melde_Eintarif_in_NT := false;
        // Optionen einlesen
        {$ifdef fpc}
        // imp pend
        {$else}
        Optionen := cutblank(getCellValue(2, succ(cARGOS)).ToStringInvariant);
        {$endif}

        // Optionen setzen ...
        if pos('x',Optionen)>0 then
         p_Melde_Eintarif_in_NT := true;
      end;

      cARGOS := xlsHeaders.indexof('ARGOS');
      if cARGOS = -1 then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "ARGOS" nicht gefunden!');
        exit;
      end;

      cART := xlsHeaders.indexof('Art');
      if (cART = -1) then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "Art" nicht gefunden!');
        exit;
      end;

      cRID := xlsHeaders.indexof('ReferenzIdentitaet');
      if (cRID = -1) then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "ReferenzIdentitaet" nicht gefunden!');
        exit;
      end;

      cStatus := xlsHeaders.indexof('Status1');
      if (cStatus = -1) then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "Status1" nicht gefunden!');
        exit;
      end;

      r := 2;
      repeat
        {$ifdef fpc}
        // imp pend
        {$else}
        Argos := strtoint(cutblank(getCellValue(r, succ(cARGOS)).ToStringInvariant));
        ART := cutblank(getCellValue(r, succ(cART)).ToStringInvariant);
        ZaehlwerkeIst := strtointdef(StrFilter(ART, '0123456789'), 1);
        RID := cutblank(getCellValue(r, succ(cRID)).ToStringInvariant);
        STATUS := strtointdef(getCellValue(r, succ(cStatus)).ToStringInvariant, -1);
        {$endif}

        // Status bei bereits gemeldeten umsetzen!
        if (STATUS = cSTATUS_ErfolgGemeldet) then
          STATUS := cSTATUS_Erfolg;
        if (STATUS = cSTATUS_UnmoeglichGemeldet) then
          STATUS := cSTATUS_Unmoeglich;
        if (STATUS = cSTATUS_VorgezogenGemeldet) then
          STATUS := cSTATUS_Vorgezogen;

        if (Argos > 0) and (Argos < MaxInt) then
        begin
          if (STATUS in [cSTATUS_Unmoeglich, cSTATUS_Vorgezogen, cSTATUS_Erfolg]) then
          begin
            if bXML.exist(Argos) then
            begin

              fillAufgaben;
              OneFound(r);

            end
            else
            begin
              if assigned(sBericht) then
                sBericht.add('(RID=' + RID + ') ARGOS "' + inttostr(Argos) + '" in '+cARGOS_2007_XML_SAVE + cBL_FileExtension+' nicht gefunden!');
            end;
          end
          else
          begin
            if assigned(sBericht) then
              sBericht.add('(RID=' + RID + ') STATUS sollte in (Unmöglich,Vorgezogen,Erfolg) sein!');
          end;
        end
        else
        begin
          if assigned(sBericht) then
            sBericht.add('(RID=' + RID + ') ARGOS ist leer!');
        end;
        inc(r);
        {$ifdef fpc}
        // imp pend
      until (r > 1);
        {$else}
      until (r > RowCount);
        {$endif}
    end;
    pop;
    pop;
    pop;
    pop;
    if (sStack.count <> 0) then
    begin
      inc(ErrorCount);
      sDiagnose.add(cERRORText + ' Stack nicht abgearbeitet!');
    end;

  end;

  //
  if (ErrorCount = 0) then
    sResult.SaveToFile(conversionOutFName)
  else
    FileDelete(conversionOutFName);


  bXML.EndTransaction;

  FreeMem(pXML);
  bXML.Free;
  sResult.Free;
  sSource.Free;
  sStack.Free;
  xImport.Free;
  xlsHeaders.Free;
end;

procedure xls2argos2018(InFName: string; sBericht: TStringList);
const
  cSTATUS_Unmoeglich = 9;
  cSTATUS_Vorgezogen = 7;
  cSTATUS_Erfolg = 4;
  cSTATUS_ErfolgGemeldet = 12;
  cSTATUS_UnmoeglichGemeldet = 13;
  cSTATUS_VorgezogenGemeldet = 14;
var
  sSource: TStringList;
  xlsHeaders: TStringList;

  sResult: TStringList;
  sStack: TStringList;
  RollBack: boolean;

  // Auftrag
  bXML: TBLager;
  pXML: pointer;

  // Cache
  xmlToday: string;
  xmlMESSAGE: integer;
  xmlCursor: integer;

  // XLS-Sachen
  {$ifdef fpc}
  xImport: TsWorkbook;
  {$else}
  xImport: TXLSFile;
  {$endif}
  r, c: integer;

  // Spalten Konstante
  cARGOS: integer;
  cART: integer;
  cRID: integer;
  cStatus: integer;

  // Datenfelder Cache
  Argos: int64;
  ART: string;
  RID: string;
  STATUS: integer;
  ZaehlwerkeIst: integer;
  LagezusatzNeu: string;

  // TAET
  TAET_BEGIN: integer;
  TAET_END: integer;
  TAET_NACHKOMMA: integer;

  // Schnittstellen-Optionen
  Optionen : string;
  p_Melde_Eintarif_in_NT : boolean;

  procedure speak(s: string = '');
  begin
    if (cutblank(s) = '') then
      sResult.add('')
    else
      sResult.add(fill(' ', sStack.count) + s);
  end;

  procedure rollbackBecause(Msg: string);
  begin
    if assigned(sBericht) then
      sBericht.add('(RID=' + RID + ') ' + Msg)
    else
     sDiagnose.add(cERRORText + ' (RID=' + RID + ') ' + Msg);
    RollBack := true;
  end;

  procedure push(tag: string);
  begin
    speak('<' + tag + '>');
    sStack.add(nextp(tag, ' ', 0));
  end;

  procedure pop;
  var
    tag: string;
  begin
    tag := sStack[pred(sStack.count)];
    sStack.delete(pred(sStack.count));
    speak('</' + tag + '>');
  end;

  procedure single(tag, value: string);
  begin
    speak('<' + tag + '>' + value + '</' + tag + '>');
  end;

  function f { ocus } (tag: string): boolean;
  var
    n: integer;
    AutoMataState: integer;
  begin

    //
    TAET_BEGIN := -1;
    TAET_END := -1;
    AutoMataState := 0;
    result := false;
    for n := xmlCursor to pred(sSource.count) do
    begin
      case AutoMataState of
        0:
          begin
            if (pos('<TAET>', sSource[n]) > 0) then
            begin
              TAET_BEGIN := n;
              continue;
            end;
            if (pos('<BEZEICHNUNG>' + tag + '</BEZEICHNUNG>', sSource[n]) > 0) then
            begin
              AutoMataState := 1;
              continue;
            end;
          end;
        1:
          begin
            if (pos('</TAET>', sSource[n]) > 0) then
            begin
              TAET_END := n;
              break;
            end;
          end;
      end;

    end;

    if (TAET_END <= TAET_BEGIN) then
    begin
      // rollbackBecause(inttostr(ARGOS) + ': Bezeichnung "' + Tag + '" nicht gefunden!');
      if assigned(sBericht) then
        sBericht.add('WARNUNG: Bei ' + inttostr(Argos) + ': Bezeichnung "' + tag + '" nicht gefunden!');
    end
    else
    begin
      result := true;
    end;

  end;

  function hmkt { HOSTKEY+MERKMAL+KNOPFGRUPPE+ZWNUMMER } (HOSTKEY, MERKMAL, KNOPFGRUPPE, ZWNUMMER: string): boolean;
  var
    n: integer;
    AutoMataState: integer;
    END_SEARCH: boolean;
  begin
    //
    TAET_BEGIN := -1;
    TAET_END := -1;
    END_SEARCH := false;
    AutoMataState := 0;
    result := false;
    for n := xmlCursor to pred(sSource.count) do
    begin
      repeat
        case AutoMataState of
          0: // 'ACT' suchen
              if (pos('<ACT>', sSource[n]) > 0) then
              begin
                TAET_BEGIN := n;
                inc(AutoMataState);
              end else
              begin
                break;
              end;
          1: // 'Treffer' H + M + K + T suchen
             begin
              if ((pos('<HOSTKEY>' + HOSTKEY + '</HOSTKEY>', sSource[n]) >0) or (HOSTKEY='')) and
                 ((pos('<MERKMAL>' + MERKMAL + '</MERKMAL>', sSource[n]) > 0) or (MERKMAL='')) and
                 ((pos('<KNOPFGRUPPE>' + KNOPFGRUPPE + '</KNOPFGRUPPE>', sSource[n]) >0) or (KNOPFGRUPPE='')) and
                 ((pos('<ZWNUMMER>' + ZWNUMMER + '</ZWNUMMER>', sSource[n]) > 0) or (ZWNUMMER='')) then
              begin
                TAET_NACHKOMMA := StrToIntDef(ExtractSegmentBetween(sSource[n], '<NACHKOMMA>', '</NACHKOMMA>'),-1);
                inc(AutoMataState);
              end else
              begin
                if (pos('</ACT>', sSource[n]) > 0) then
                begin
                  // Tag ist zu Ende, Suche weiter!
                  AutoMataState := 0;
                end;
                break;
              end;
             end;
          2: // '/ACT' suchen
             begin
              if (pos('</ACT>', sSource[n]) > 0) then
              begin
                TAET_END := n;
                END_SEARCH := true;
              end;
              break;
             end;
         end;
       until eternity;
       if END_SEARCH then
        break;
    end;
    if (TAET_END <= TAET_BEGIN) then
    begin
      rollbackBecause(
       {} inttostr(Argos) +
       {} ': HOSTKEY+MERKMAL+KNOPFGRUPPE+ZWNUMMER "' +
       {} HOSTKEY + '+' +
       {} MERKMAL + '+' +
       {} KNOPFGRUPPE + '+' +
       {} ZWNUMMER +
       {} '" nicht gefunden!');
    end
    else
    begin
      result := true;
    end;
  end;

  function q { uestion } (tag: string; CloseTag: string = 'ACT'): string;
  var
    n: integer;
    k: integer;
    oneLine: string;
    FoundTag: boolean;
    FullTag: string;
  begin
    result := '"<ReferenceFailed>"';
    FoundTag := false;
    FullTag := '<' + tag + '>';
    for n := TAET_BEGIN to pred(TAET_END) do
    begin
      if (pos('</' + CloseTag + '>', sSource[n]) > 0) then
        break;
      k := pos(FullTag, sSource[n]);
      if (k = 0) then
        continue;
      oneLine := copy(sSource[n], k + length(FullTag), MaxInt);
      k := pos('</' + tag + '>', oneLine);
      if (k > 0) then
        oneLine := copy(oneLine, 1, pred(k));
      result := oneLine;
      FoundTag := true;
      break;
    end;

    if not(FoundTag) then
      rollbackBecause(inttostr(Argos) + '[' + inttostr(TAET_BEGIN) + ',' + inttostr(TAET_END) + ']' + ': ' + tag +
        ' nicht gefunden!');
  end;

  (*
  function qo { uestion optional } (tag: string; CloseTag: string = 'GERAET'): boolean;
  var
    n: integer;
    k: integer;
    oneLine: string;
    FullTag: string;
  begin
    result := false;
    FullTag := '<' + tag + '>';
    for n := succ(TAET_BEGIN) to pred(TAET_END) do
    begin
      if (pos('</' + CloseTag + '>', sSource[n]) > 0) then
        break;
      k := pos(FullTag, sSource[n]);
      if (k = 0) then
        continue;
      oneLine := copy(sSource[n], k + length(FullTag), MaxInt);
      k := pos('</' + tag + '>', oneLine);
      if (k > 0) then
        oneLine := copy(oneLine, 1, pred(k));
      result := true;
      break;
    end;
  end;

  function qao { uestion auftrag optional } (tag: string): string;
  // Frage einen Feldinhalt aus dem originalen Auftrag ab
  // der Auftrag befindet sich vor den Tätigkeitshülsen
  var
    n: integer;
    k: integer;
    oneLine: string;
    FullTag: string;
    Found: boolean;
  begin
    Found := false;
    result := '';
    FullTag := '<' + tag + '>';
    for n := 0 to pred(TAET_BEGIN) do
    begin
      k := pos(FullTag, sSource[n]);
      if (k = 0) then
        continue;
      oneLine := copy(sSource[n], k + length(FullTag), MaxInt);
      k := pos('</' + tag + '>', oneLine);
      if (k > 0) then
      begin
        result := copy(oneLine, 1, pred(k));
        Found := true;
        break;
      end;
    end;
    if Found then
    begin
      if result = '' then
        speak('<!-- ' + tag + ' war leer -->')
      else
        speak('<!-- ' + tag + ' war ' + result + ' -->');
    end
    else
    begin
      speak('<!-- ' + tag + ' fehlt im Auftrag -->');
    end;
  end;
  *)
  function fillAufgaben : boolean;
  var
    n: integer;
    sXML: TMemoryStream;
  begin
    result := false;

    // sSource mit den richtigen Werten füllen
    bXML.get;
    sXML := TMemoryStream.create;
    sXML.Write(pXML^, bXML.RecordSize);
    sXML.Position := 0;
    sSource.LoadFromStream(sXML);
    sXML.Free;

    // oberen Kopf-Teil der Source übergehen
    xmlCursor := -1;
    for n := 0 to pred(sSource.count) do
      if (pos('<ACT>', sSource[n]) > 0) then
      begin
        xmlCursor := n;
        break;
      end;
    if (xmlCursor < 0) then
    begin
      sDiagnose.add(cERRORText + ' <ACT> nicht gefunden!');
      inc(ErrorCount);
      if assigned(sBericht) then
       sBericht.add('(RID=' + RID + ') <ACT> nicht gefunden');
    end else
    begin
      result := true;
    end;

  end;

  function x { celValue } (r: integer; c: string): string;
  var
    _c: integer;
  begin
    _c := xlsHeaders.indexof(c);
    if (_c = -1) then
    begin
      result := '?';
      sDiagnose.add(cERRORText + ' Spalte "' + c + '" nicht gefunden!');
      inc(ErrorCount);
    end
    else
    begin
      {$ifdef fpc}
      // imp pend
      {$else}
      result := xImport.getCellValue(r, succ(_c)).ToString;
      {$endif}
      ersetze('"', '''', result);
      ersetze('&', c_xml_ampersand, result);
    end;
  end;

  function xd(r: integer): string; overload;
  var
    _cd: integer;
    _ct: integer;
    d, t: TDateTime;
  begin
    _cd := xlsHeaders.indexof('WechselDatum');
    _ct := xlsHeaders.indexof('WechselZeit');

    if (_cd = -1) or (_ct = -1) then
    begin
      result := '?';
      sDiagnose.add(cERRORText + ' Spalte "WechselDatum" oder "WechselZeit" nicht gefunden!');
      inc(ErrorCount);
    end
    else
    begin
      {$ifdef fpc}
      // imp pend
      {$else}
      d := getDateValue(xImport, r, succ(_cd));
      t := getTimeValue(xImport, r, succ(_ct));
      {$endif}

      if (d = 0) then
        d := now;

      result := long2date(d) + SecondsToStr(t);

      result :=
        { yyyy } copy(result, 7, 4) + '-' +
        { mm } copy(result, 4, 2) + '-' +
        { tt } copy(result, 1, 2) +
        { 'T' } 'T' +
        { hh } copy(result, 11, 2) + ':' +
        { mm } copy(result, 14, 2) + ':' +
        { ss } copy(result, 17, 2);
    end;
  end;

  procedure timeStampBlock(r: integer);
  var
    ts: string;
  begin
(*
<DATERG>2017-04-19T12:30:00</DATERG>
<DATERF>2017-04-19T12:30:00</DATERF>
*)
    ts := xd(r);
    single('DATERG', ts);
    single('DATERF', ts);
  end;

  function xd(r: integer; c: string): string; overload;
  var
    _cdt: integer;
    d: TDateTime;
  begin
    _cdt := xlsHeaders.indexof(c);
    if (_cdt = -1) then
    begin
      result := '?';
      sDiagnose.add(cERRORText + ' Spalte "' + c + '" nicht gefunden!');
      inc(ErrorCount);
    end
    else
    begin

      result := '';
      try
        {$ifdef fpc}
        // imp pend
        {$else}
        d := getDateTimeValue(xImport, r, succ(_cdt));
        {$endif}

        if (d > 0) then
        begin

          result := long2date(d) + SecondsToStr(d);

          result :=
          { yyyy } copy(result, 7, 4) +
          { mm } copy(result, 4, 2) +
          { tt } copy(result, 1, 2) +
          { hh } copy(result, 11, 2) +
          { mm } copy(result, 14, 2) +
          { ss } copy(result, 17, 2);

        end;
      except
      end;
    end;

  end;

  function x_optional(r: integer; c: string): string; overload;
  begin
    if (xlsHeaders.indexof(c) <> -1) then
      result := x(r, c)
    else
      result := '';
  end;

  function x_optional_upper(r: integer; c: string): string; overload;
  begin
    if (xlsHeaders.indexof(c) <> -1) then
      result := AnsiupperCase(x(r, c))
    else
      result := '';
  end;

  function x_optional_JNX(r: integer; c: string): string; overload;
  begin
    if (xlsHeaders.indexof(c) <> -1) then
    begin
      result := AnsiupperCase(x(r, c));
      if result = 'X' then
        result := 'ja';
      if result = 'J' then
        result := 'ja';
      if result = 'N' then
        result := 'nein';
    end
    else
      result := '';
  end;

  function x_optional_X(r: integer; c: string): string; overload;
  begin
    if (xlsHeaders.indexof(c) <> -1) then
    begin
      result := AnsiupperCase(x(r, c));
      if result = 'X' then
        result := 'ja'
      else
        result := 'nein';
    end
    else
      result := '';
  end;

  procedure clone(tag: string);
  begin
    single(tag, q(tag));
  end;

  (*
  procedure clone_optional(tag: string);
  begin
    if qo(tag) then
      single(tag, q(tag));
  end;
  *)

  procedure ACT(BEZEICHNER, HOSTKEY, MERKMAL, KNOPFGRUPPE, ZWNUMMER, Ergebnis: string; r: integer; NumberFormat:boolean = false);
  var
   k : integer;
  begin
    if hmkt(HOSTKEY,MERKMAL,KNOPFGRUPPE,ZWNUMMER) then
    begin
      push('ACT');
      single('BEZEICHNER', BEZEICHNER);
      if NumberFormat then
      begin
       speak('<!-- '+IntToStr(TAET_NACHKOMMA)+' Nachkommastellen'+' -->');
       Ersetze(',','.',Ergebnis);
       if (TAET_NACHKOMMA<1) then
       begin
         // keine Nachkommastellen
         k := pos('.',Ergebnis);
         if (k>0) then
          Ergebnis := copy(Ergebnis,1,pred(k));
       end else
       begin
         // hat Nachkommastellen
         k := pos('.',Ergebnis);
         repeat

           if (k=0) then
           begin
            // bisher gar keine Nachkommastellen
            Ergebnis := Ergebnis + '.' + fill('0',TAET_NACHKOMMA);
            break;
           end;

           k := length(Ergebnis)-k;

           if (k=TAET_NACHKOMMA) then
            break;

           if (k>TAET_NACHKOMMA) then
           begin
            // zu vielen Stellen -> abschneiden
            Ergebnis := copy(Ergebnis,1,length(Ergebnis)-(k-TAET_NACHKOMMA));
            break;
           end;

           // zu wenig stellen -> auffüllen
           Ergebnis := Ergebnis + fill('0',TAET_NACHKOMMA-k);

         until yet;
       end;
       Ersetze('.',',',Ergebnis);
      end;
      clone('TAE_ID');
      single('ERG', Ergebnis);
      timeStampBlock(r);
      pop;
    end;
  end;

  procedure OptACT(BEZEICHNER,HOSTKEY,MERKMAL,KNOPFGRUPPE,ZWNUMMER, Ergebnis: string; r: integer; NumberFormat:boolean = false);
  begin
    if (Ergebnis <> '') then
      ACT(BEZEICHNER, HOSTKEY, MERKMAL, KNOPFGRUPPE, ZWNUMMER, Ergebnis, r, NumberFormat);
  end;

  (*
  procedure OptDiff(Bisher, Spaltenname,HOSTKEY,MERKMAL,KNOPFGRUPPE,ZWNUMMER, Ergebnis: string; r: integer);
  // nur etwas melden wenn es in Abänderung zum Auftrag steht
  begin
    if (Ergebnis <> '') then
      if (qao(Bisher) <> Ergebnis) then
        ACT(Spaltenname,HOSTKEY, MERKMAL, KNOPFGRUPPE, ZWNUMMER, Ergebnis, r);
  end;
  *)

  procedure OneFound(r: integer);
  var
    RollBackPosition, n: integer;
  begin
    RollBackPosition := sResult.count;
    RollBack := false;


    speak;
    speak('<!-- RID'+RID+': -->');
    if (x(r,'V1')<>'') then
     speak('<!-- 1. gescheiterter Versuch: '+ x(r, 'V1') + ' -->');
    if (x(r,'V2')<>'') then
     speak('<!-- 2. gescheiterter Versuch: '+ x(r, 'V2') + ' -->');
    speak('<!-- Unterschrift Monteur: '+ x(r, 'MonteurText') + '(' + x(r, 'MonteurHandy') + ') -->');

    push('OBJ');
    single('AUF_ID',x(r,'AUF_ID'));
    single('BN_ID',x(r,'BN_ID'));
    single('AUF_ISTBEARB',xd(r));

    ACT('Rückmeldegrund','ZM_RMG','','','','100',r);
    ACT('Text zum Rückmeldegrund','ZM_RMGTXT','','','','Auftrag bearbeitet',r);
    ACT('Sachverhalt','ZM_SACHVERHALTNR','','','','0000',r);
    ACT('Sachverhaltstext','ZM_SACHVERHALTTXT','','','','Auftrag fertig bearbeitet',r);
    case STATUS of
     cSTATUS_Unmoeglich:ACT('Sachverhalt Freitext','ZM_SACHVERHALTFREI','','','','unmöglich',r);
     cSTATUS_Vorgezogen:ACT('Sachverhalt Freitext','ZM_SACHVERHALTFREI','','','','vorgezogen',r);
     cSTATUS_Erfolg:ACT('Sachverhalt Freitext','ZM_SACHVERHALTFREI','','','','erfolgreich',r);
    end;
    ACT('Nummer des Vorgangsgrundes','ZM_VORGANGSGRUND','','','','11',r);
    ACT('Text des Vorgangsgrundes','ZM_VORGANGSGRUNDTXT','','','','Turnuswechsel', r);

    // statisch! nur technische Schnittstellen Erfordernisse, keine Inhaltliche Bedeutung
    ACT('Zähler ausgebaut', 'ZM_KLASSEN', 'MECH-AUSGEBAUT', 'AGERAET', '', 'ja', r);
    ACT('Plombierung i.O.', 'CHANGE-PLOMBIERUNG', 'CHANGE-PLOMBIERUNG', 'PRUEF', '', 'ja', r);
    ACT('Mangel vorhanden', 'CHANGE-MANGEL', 'CHANGE-MANGEL', 'PRUEF', '', 'nein', r);

    repeat

       if (ART='G') then
       begin
         ACT('Versorg. Unterbrechung', 'CHANGE-SPGUNTER', 'CHANGE-SPGUNTER', 'PRUEF', '', 'ja', r);
         break;
       end;

       if (ART='WA') then
       begin
         ACT('Versorg. Unterbrechung', 'CHANGE-SPGUNTER', 'CHANGE-SPGUNTER', 'PRUEF', '', 'ja', r);
         break;
       end;
       // Elektro!

       ACT('Versorg. Unterbrechung','CHANGE-SPGUNTERDAUER','CHANGE-SPGUNTERDAUER','PRUEF','','1,0',r);

    until yet;

    if hmkt('ZM_KLASSEN', 'CHANGE-VS_LGZUSATZ', 'PRUEF', '') then
    begin
     LagezusatzNeu := q('ERG');
     if (LagezusatzNeu='') then
       LagezusatzNeu := 'Zählerraum';
    end else
    begin
     LagezusatzNeu := 'Zählerraum';
    end;

    ACT('Verbrauchsstelle Lagezusatz NEU', 'ZM_KLASSEN', 'CHANGE-VS_LGZUSATZ_NEU', 'PRUEF', '', LagezusatzNeu, r);

    OptACT('Hinweis an Disponenten','ZM_HINWEIS','','','', cutblank(x(r, 'I1') + ' ' + x(r, 'I2') + ' ' + x(r, 'I3')), r);

    repeat

     if (ART='G') or (ART='WA') then
     begin
       ACT('Seriennummer Ausbaugerät','','MECH-SERINFO','AGERAET', '',x(r, 'Zaehler_Nummer'), r);
       ACT('Zählerstand Ausbaugerät','','MECH-ZW','AGERAET', '',x(r, 'ZaehlerStandAlt'), r, true);
       ACT('Seriennummer Einbaugerät','','MECH-SERNRNEU','EGERAET','',x(r, 'ZaehlerNummerNeu'), r);
       ACT('Zählerstand Einbaugerät','','MECH-ZW','EGERAET', '',x(r, 'ZaehlerStandNeu'), r, true);
       break;
     end;

     if (ZaehlwerkeIst = 2) then
     begin
       ACT('Seriennummer Ausbaugerät','','MECH-SERINFO','AGERAET','', x(r, 'Zaehler_Nummer'), r);
       ACT('Zählerstand Ausbaugerät','','MECH-ZW','AGERAET','001', x(r, 'ZaehlerStandAlt'), r, true);
       ACT('Zählerstand Ausbaugerät','','MECH-ZW','AGERAET','002', x(r, 'NA'), r, true);

       ACT('Seriennummer Einbaugerät','','MECH-SERNRNEU','EGERAET','',x(r, 'ZaehlerNummerNeu'), r);
       ACT('Zählerstand Einbaugerät','','MECH-ZW','EGERAET','001', x(r, 'ZaehlerStandNeu'), r, true);
       ACT('Zählerstand Einbaugerät','','MECH-ZW','EGERAET','002', x(r, 'NN'), r, true);
       break;
     end;

     if p_Melde_Eintarif_in_NT then
     begin
       ACT('Seriennummer Ausbaugerät','','MECH-SERINFO','AGERAET','', x(r, 'Zaehler_Nummer'), r);
       ACT('Zählerstand Ausbaugerät','','MECH-ZW','AGERAET','002', x(r, 'ZaehlerStandAlt'), r, true);
       ACT('Seriennummer Einbaugerät','','MECH-SERNRNEU','EGERAET','',x(r, 'ZaehlerNummerNeu'), r);
       ACT('Zählerstand Einbaugerät','','MECH-ZW','EGERAET','002', x(r, 'ZaehlerStandNeu'), r, true);
       break;
     end;

     ACT('Seriennummer Ausbaugerät','','MECH-SERINFO','AGERAET', '',x(r, 'Zaehler_Nummer'), r);
     ACT('Zählerstand Ausbaugerät','','MECH-ZW','AGERAET', '',x(r, 'ZaehlerStandAlt'), r, true);
     ACT('Seriennummer Einbaugerät','','MECH-SERNRNEU','EGERAET','',x(r, 'ZaehlerNummerNeu'), r);
     ACT('Zählerstand Einbaugerät','','MECH-ZW','EGERAET', '',x(r, 'ZaehlerStandNeu'), r, true);

    until yet;

    Pop;

    if RollBack then
    begin
      for n := pred(sResult.count) downto RollBackPosition do
        sResult.delete(n);
      speak('<!-- catched ' + inttostr(Argos) + ' before finish line, because of quality policies -->');
      speak('<!-- operator_order_id="' + RID + '" -->');
      if assigned(sBericht) then
      begin
        for n := pred(sBericht.count) downto 0 do
          if (pos('(RID=' + RID + ')', sBericht[n]) > 0) then
            speak('<!-- policy_fail_reason="' + sBericht[n] + '" -->')
          else
            break;
      end;
    end
    else
    begin
      inc(xmlMESSAGE);
    end;
  end;

  function value_dt(D:TAnfixDate;T:TAnfixTime):string;
  begin
    result := long2dateLog(D);
    insert('-',result,5);
    insert('-',result,8);
    result := result + 'T' + SecondsToStr(T);
  end;

  procedure SetOutFname;
  var
    k: integer;
  begin
    conversionOutFName := InFName;
    k := revPos('.', conversionOutFName);
    conversionOutFName := copy(conversionOutFName, 1, pred(k)) + cXML_Extension;
  end;

begin
  sResult := TStringList.create;
  sStack := TStringList.create;
  sSource := TSearchStringList.create;

  {$ifdef fpc}
  xImport := TsWorkBook.Create;
  {$else}
  xImport := TXLSFile.create(true);
  {$endif}
  xlsHeaders := TStringList.create;
  bXML := TBLager.create;
  GetMem(pXML, 1024 * 1024);

  xmlToday := Datum10;
  xmlToday := copy(xmlToday, 7, 4) + copy(xmlToday, 4, 2) + copy(xmlToday, 1, 2);
  xmlMESSAGE := 1;

  if FileExists(WorkPath + '_' + cARGOS_2018_XML_SAVE + cBL_FileExtension) then
    bXML.init(WorkPath + '_' + cARGOS_2018_XML_SAVE, pXML^, 1024 * 1024)
  else
    bXML.init(WorkPath + cARGOS_2018_XML_SAVE, pXML^, 1024 * 1024);
  bXML.ReadOnly := true;
  bXML.BeginTransaction;

  SetOutFname;

  with sResult do
  begin


    //
    with xImport do
    begin

      try
        {$ifdef fpc}
        // imp pend
        {$else}
        Open(InFName);
        {$endif}
      except
        on e: exception do
        begin
          inc(ErrorCount);
          sDiagnose.add(cERRORText + ' ' + e.message);
          sDiagnose.add(cERRORText + ' ' + InFName + ' ist durch andere Anwendung geöffnet?');
        end;
      end;

      sDiagFiles.add(InFName);
      sDiagFiles.add(conversionOutFName);

      {$ifdef fpc}
      // imp pend
      {$else}
      for c := 1 to ColCountInRow(1) do
        xlsHeaders.add(getCellValue(1, c).ToStringInvariant);
      {$endif}

      cARGOS := xlsHeaders.indexof('ARGOS-Optionen');
      if cARGOS = -1 then
      begin

        // defaults ohne die Spalte "ARGOS-Optionen"
        p_Melde_Eintarif_in_NT := true;

      end else
      begin

        // alternative defaults gültig bei reiner Existenz der Spalte "ARGOS-Optionen"
        p_Melde_Eintarif_in_NT := false;
        // Optionen einlesen
        {$ifdef fpc}
        // imp pend
        {$else}
        Optionen := cutblank(getCellValue(2, succ(cARGOS)).ToStringInvariant);
        {$endif}

        // Optionen setzen ...
        if (pos('x',Optionen)>0) then
         p_Melde_Eintarif_in_NT := true;
      end;

      cARGOS := xlsHeaders.indexof('ARGOS');
      if cARGOS = -1 then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "ARGOS" nicht gefunden!');
      end;

      cART := xlsHeaders.indexof('Art');
      if (cART = -1) then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "Art" nicht gefunden!');
      end;

      cRID := xlsHeaders.indexof('ReferenzIdentitaet');
      if (cRID = -1) then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "ReferenzIdentitaet" nicht gefunden!');
      end;

      cStatus := xlsHeaders.indexof('Status1');
      if (cStatus = -1) then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "Status1" nicht gefunden!');
      end;

      c := xlsHeaders.indexof('AUF_ID');
      if (c = -1) then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "AUF_ID" nicht gefunden!');
      end;

      c := xlsHeaders.indexof('BN_ID');
      if (c = -1) then
      begin
        inc(ErrorCount);
        sDiagnose.add(cERRORText + ' Spalte "BN_ID" nicht gefunden!');
      end;

      if (ErrorCount>0) then
       exit;

    // Header
    add('<?xml version="1.0" encoding="utf-8"?>');
    speak;
    speak('<!--   ___                                  -->');
    speak('<!--  / _ \  ___                            -->');
    speak('<!-- | | | |/ __|  Orientation Convert      -->');
    speak('<!-- | |_| | (__   (c)1987-' + JahresZahl + ' OrgaMon.org -->');
    speak('<!--  \___/ \___|  Rev. ' + RevToStr(Version) + '               -->');
    speak('<!--                                        -->');
    speak;
    speak('<!-- Modus '+IntToStr(Content_Mode_xls2Argos2018)+': Argos-2018 -->');
    speak('<!-- Info: https://wiki.orgamon.org/?title=Schnittstelle.Argos.2018 -->');
    speak('<!-- Quelltexte: https://github.com/Andreas-Filsinger/OrgaMon/blob/master/PASconTools/OrientationConvert.pas -->');
    speak;
    push('DSP');


      r := 2;
      repeat
        {$ifdef fpc}
        // imp pend
        {$else}
        Argos := strtoint(cutblank(getCellValue(r, succ(cARGOS)).ToStringInvariant));
        ART := cutblank(getCellValue(r, succ(cART)).ToStringInvariant);
        ZaehlwerkeIst := strtointdef(StrFilter(ART, '0123456789'), 1);
        RID := cutblank(getCellValue(r, succ(cRID)).ToStringInvariant);
        STATUS := strtointdef(getCellValue(r, succ(cStatus)).ToStringInvariant, -1);
        {$endif}


        // Status bei bereits gemeldeten umsetzen!
        if (STATUS = cSTATUS_ErfolgGemeldet) then
          STATUS := cSTATUS_Erfolg;
        if (STATUS = cSTATUS_UnmoeglichGemeldet) then
          STATUS := cSTATUS_Unmoeglich;
        if (STATUS = cSTATUS_VorgezogenGemeldet) then
          STATUS := cSTATUS_Vorgezogen;

        if (Argos > 0) and (Argos < MaxInt) then
        begin
          if (STATUS in [cSTATUS_Unmoeglich, cSTATUS_Vorgezogen, cSTATUS_Erfolg]) then
          begin
            if bXML.exist(Argos) then
            begin
              if fillAufgaben then
               OneFound(r);
            end
            else
            begin
              if assigned(sBericht) then
                sBericht.add('(RID=' + RID + ') ARGOS "' + inttostr(Argos) + '" in '+cARGOS_2018_XML_SAVE + cBL_FileExtension+' nicht gefunden!');
            end;
          end
          else
          begin
            if assigned(sBericht) then
              sBericht.add('(RID=' + RID + ') STATUS sollte in (Unmöglich,Vorgezogen,Erfolg) sein!');
          end;
        end
        else
        begin
          if assigned(sBericht) then
            sBericht.add('(RID=' + RID + ') ARGOS ist leer!');
        end;
        inc(r);
        {$ifdef fpc}
        // imp pend
      until (r > 1);
        {$else}
      until (r > RowCount);
        {$endif}
    end;
    pop;
    if (sStack.count <> 0) then
    begin
      inc(ErrorCount);
      sDiagnose.add(cERRORText + ' Stack nicht abgearbeitet!');
    end;

  end;

  //
  if (ErrorCount = 0) then
    sResult.SaveToFile(conversionOutFName, Tencoding.UTF8)
  else
    FileDelete(conversionOutFName);


  bXML.EndTransaction;

  FreeMem(pXML);
  bXML.Free;
  sResult.Free;
  sSource.Free;
  sStack.Free;
  xImport.Free;
  xlsHeaders.Free;
end;

function doConversion(Mode: integer; InFName: string; sBericht: TStringList = nil): boolean;

var
  n: integer;
begin
  sDiagnose := TStringList.create;
  sDiagFiles := TStringList.create;

  try

    ErrorCount := 0;
    conversionOutFName := '';

    // Arbeitspfad bestimmen
    WorkPath := ValidatePathName(ExtractFilePath(InFName)) + '\';

    if (OcTransaktionsTiefe>0) then
    begin
      if OcFirstTime then
      begin
        sDiagnose.add('Oc Rev. ' + RevToStr(Version) + ' transaction mode');
        sDiagnose.add(Datum + ' ' + Uhr8);
        sDiagnose.add('Path: '+WorkPath);
        FileEmpty(WorkPath+cOc_LogFName);
        OcFirstTime := false;
      end;
      sDiagnose.add('Source: '+ExtractFileName(InFName));
    end else
    begin
      sDiagnose.add('Oc Rev. ' + RevToStr(Version));
      sDiagnose.add(Datum + ' ' + Uhr8);
    end;

    case Mode of
      Content_Mode_Michelbach:
        begin
          sDiagnose.add('Modus: yTOx');
          yTOx(InFName);
        end;
      Content_Mode_KK22:
        begin
          sDiagnose.add('Modus: KK22');
          doKK22(InFName, sBericht);
        end;
      Content_Mode_xls2xls:
        begin
          sDiagnose.add('Modus: xls & Vorlage -> xls');
          xls_2_xls(InFName, sBericht);
        end;
      Content_Mode_Datev:
        begin
          sDiagnose.add('Modus: xls & Datev -> xls');
          xls_Datev_xls(InFName);
        end;
      Content_Mode_xls2csv:
        begin
          sDiagnose.add('Modus: xls -> csv');
          xls2csv(InFName, sBericht);
        end;
      Content_Mode_xls2flood:
        begin
          sDiagnose.add('Modus: xls & Fixed-Flood.ini -> csv');
          xls2Flood(InFName);
        end;
      Content_Mode_csvMap:
        begin
          sDiagnose.add('Modus: csv & Umsetzer -> csv');
          csvMap(InFName);
        end;
      Content_Mode_xls2gm:
        begin
          sDiagnose.add('Modus: xls -> gm');
          xls2gm(InFName, sBericht);
        end;
      Content_Mode_csv:
        begin
          sDiagnose.add('Modus: csv -> csv');
          csvTOcsv(InFName);
        end;
      Content_Mode_KK20:
        begin
          sDiagnose.add('Modus: KK20');
          KK20toCSV(InFName);
        end;
      Content_Mode_txt:
        begin
          sDiagnose.add('Modus: txt');
          txtTOxls(InFName);
        end;
      Content_Mode_xml2csv:
        begin
          sDiagnose.add('Modus: xml -> csv');
          xml2csv(InFName, sBericht);
        end;
      Content_Mode_tab2csv:
        begin
          sDiagnose.add('Modus: tab -> csv');
          tab2csv(InFName);
        end;
      Content_Mode_xls2idoc:
        begin
          sDiagnose.add('Modus: xls -> idoc');
          xls2idoc(InFName, sBericht);
        end;
      Content_Mode_xls2Argos2007:
        begin
          sDiagnose.add('Modus: xls -> ARGOS-2007 XML');
          xls2argos2007(InFName, sBericht);
        end;
      Content_Mode_xls2Argos2018:
        begin
          sDiagnose.add('Modus: xls -> ARGOS-2018 XML');
          xls2argos2018(InFName, sBericht);
        end;
      Content_Mode_xls2ml:
        begin
          sDiagnose.add('Modus: xls -> *ml');
          xls2ml(InFName, sBericht);
        end;
      Content_Mode_xls2html:
        begin
          sDiagnose.add('Modus: xls -> html, html, ...');
          xls2ml(InFName, sBericht, eXML_HTML_Multi);
        end;
      Content_Mode_xls2xml:
        begin
          sDiagnose.add('Modus: xls -> xml, xml, ...');
          xls2ml(InFName, sBericht, eXML_XML_Multi);
        end;
      Content_Mode_xsd:
        begin
          sDiagnose.add('Modus: xml & xsd');
          xmlXxsd(InFName, sBericht);
        end;
      Content_Mode_dtd:
        begin
          sDiagnose.add('Modus: xml & dtd');
          xmlXdtd(InFName, sBericht);
        end;
      Content_Mode_enBW:
        begin
          sDiagnose.add('Modus: yTOx enBW');
          yTOx2(InFName);
        end;
      Content_Mode_Huffman:
        begin
          sDiagnose.add('Modus: Huffman');
          Huffman(InFName);
        end;
    end;

  except
    on e: exception do
    begin
      sDiagnose.add(cERRORText + ' ' + e.message);
    end;
  end;

  for n := 0 to pred(sDiagnose.count) do
    if (pos(cERRORText, sDiagnose[n]) = 1) then
      inc(ErrorCount);

  if assigned(sBericht) then
    sDiagnose.addStrings(sBericht);

  if (ErrorCount>0) or DebugMode then
   for n := 0 to pred(sDiagFiles.Count) do
    sDiagnose.Add('Used: "'+sDiagFiles[n]+'"');

  if (OcTransaktionsTiefe=0) then
  begin
   sDiagnose.SaveToFile(WorkPath + cOc_LogFName) // overwrite outside a transaction
  end else
  begin
   sDiagnose.add('');
   AppendStringsToFile(sDiagnose, WorkPath + cOc_LogFName); // inside append!
  end;

  FreeAndNil(sDiagFiles);
  FreeAndNil(sDiagnose);
  result := (ErrorCount = 0);
end;

procedure BeginOc;
begin
  inc(OcTransaktionsTiefe);
  if (OcTransaktionsTiefe=1) then
   OcFirstTime := true;
end;

procedure EndOc;
begin
 OcTransaktionsTiefe := max(0,OcTransaktionsTiefe-1);
 if (OcTransaktionsTiefe=0) then
  OcFirstTime := false;
end;

end.
