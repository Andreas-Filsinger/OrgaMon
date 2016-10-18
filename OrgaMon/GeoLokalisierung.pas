{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2016  Andreas Filsinger
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
unit GeoLokalisierung;

//
// Umsetzung von "Strasse, PLZ Ort" zu "X, Y"
//

// Fatale Fehler
//
// # "Geo Dienst Offline"
// # "Andere PLZ"
// # Andere Strasse wurde übermittelt
//
// Warnungen, was sollen wir da machen
//
// # "Mehrere Möglichkeiten zur Auswahl"
// # Anderer Ortsteil wurde übermittelt
// # Anderer Ort wurde übermittelt
//


// Umstellung auf OpenStreet-Map

// Anfrage:
// ========
//
// wget "http://nominatim.openstreetmap.org/search?country=de&city=Ubstadt-Weiher&postalcode=76698&street=44 Stettfelder Str.&format=xml"
//
// Antwort:
// ========
//
// <?xml version="1.0" encoding="UTF-8" ?>
// <searchresults timestamp='Tue, 11 Oct 16 15:13:07 +0000'
//                attribution='Data © OpenStreetMap contributors, ODbL 1.0. http://www.openstreetmap.org/copyright'
//                querystring='44 Stettfelder Str., Ubstadt-Weiher, 76698, de'
//                polygon='false' exclude_place_ids='49820555'
//                more_url='http://nominatim.openstreetmap.org/search.php?format=xml&amp;exclude_place_ids=49820555&amp;q=44+Stettfelder+Str.%2C+Ubstadt-Weiher%2C+76698%2C+de'>
// <place place_id='49820555' osm_type='node' osm_id='3666171924' place_rank='30'
//        boundingbox="49.162616,49.162716,8.6335616,8.6336616"
//        lat='49.162666' lon='8.6336116'
//        display_name='44, Stettfelder Straße, Ubstadt, Ubstadt-Weiher, Landkreis Karlsruhe, Regierungsbezirk Karlsruhe, Baden-Württemberg, 76698, Deutschland'
//        class='place' type='house' importance='0.511'/>
// </searchresults>
//

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ComCtrls,
  FastGEO,
  IB_Components, Buttons, Vcl.ExtCtrls;

type
  TFormGeoLokalisierung = class(TForm)
    Memo1: TMemo;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Label1: TLabel;
    Label2: TLabel;
    Label7: TLabel;
    Label3: TLabel;
    Button4: TButton;
    Button1: TButton;
    Edit2: TEdit;
    Edit4: TEdit;
    Button3: TButton;
    Button5: TButton;
    CheckBox2: TCheckBox;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Image2: TImage;
    Button2: TButton;
    ComboBox2: TComboBox;
    Label4: TLabel;
    CheckBox3: TCheckBox;
    Edit3: TEdit;
    Label5: TLabel;
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
    RequestTime: dword;
    DisableCache: boolean;
    IgnorePLZ: boolean;
    Initialized: boolean;

    procedure ShowResult(p: Tpoint2D);
    procedure Init;

  public
    { Public-Deklarationen }
    Diagnose_Ergebnis: boolean;
    Diagnose_PHP: boolean;
    p_OffLineMode: boolean;
    p_OSM: boolean;
    p_PTV: boolean;
    p_Google: boolean;
    // =false*: ist nix in der Datenbank, so wird online nachgehakt!
    // =true: nur in der Datenbank suchen!

    // Ursprüngliche Fragestellung
    q_plz: string;

    // Ergebnise aus WebService "Locate"
    r_strasse: string;
    r_plz: string;
    r_ort: string;
    r_ortsteil: string;
    r_error: string;

    // locate mit Anhauen des
    function locate(Strasse, PLZ, Ort, Ortsteil: string; var p: Tpoint2D): integer;
    { [POSTLEITZAHLEN_R] } overload;
    function locate(Strasse, PLZ_Ort, Ortsteil: string; var p: Tpoint2D): integer;
    { [POSTLEITZAHLEN_R] } overload;

    // Diagnose + Problembehebung
    procedure SetDiagMode;
    procedure UnSetDiagMode;

  end;

var
  FormGeoLokalisierung: TFormGeoLokalisierung;

implementation

uses
  anfix32, globals, wanfix32,
  OpenStreetMap, OrientationConvert, WordIndex,
  IdURI, IdGlobal,

  // Indy
  IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP,

  gplists, CareTakerClient, dbOrgaMon,
  geoCache, html, SimplePassword,

  // OrgaMon
  Datenbank,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  Funktionen_LokaleDaten;

{$R *.dfm}

procedure TFormGeoLokalisierung.Button4Click(Sender: TObject);
var
  p: Tpoint2D;
begin
  StaticText1.caption := '';
  DisableCache := CheckBox2.Checked;
  IgnorePLZ := CheckBox3.Checked;
  SetDiagMode;
  locate(Edit4.text, Edit2.text, Edit1.text, p);
  UnSetDiagMode;
  DisableCache := false;
  ShowResult(p);
end;

procedure TFormGeoLokalisierung.Button1Click(Sender: TObject);
begin
  ShowMessage(format('%g', [Distance(8.41177, 49.00937, 8.39295, 49.01005) * 111.136]));
end;

function TFormGeoLokalisierung.locate(Strasse, PLZ, Ort, Ortsteil: string; var p: Tpoint2D)
  : integer;
var
  StrassenName: string;
  StrasseHausnummer: string;
  httpRequest: string;
  StartTime: dword;
  EntryFound: boolean;
  POSTLEITZAHLEN_R: integer;
  locateResponse: TStringList;

  ParamF: TMemoryStream;
  httpC: TIdHTTP;
  rList: TStringList;
  rLine: string;
  //
  Diversitaet: boolean;
  StrasseID: int64;
  PLZl: TgpIntegerList;
  n: integer;
  PLZasInteger: integer;

  StrasseRelevant: boolean;
  OrtsteilRelevant: boolean;

  // OSM
  sRESULT : TsTable;
  OSMid : string;
  r : integer;

  procedure CacheCheck(PLZ: integer);
  var
    cPLZ: TIB_Cursor;
  begin

    // in der Datenbank nach einem Eintrag mit Koordinaten suchen
    // es geht nur um die Strasse, nicht um die Hausnummerngenaue
    // Position, obwohl diese eingetragen ist!
    cPLZ := DataModuleDatenbank.nCursor;
    with cPLZ do
    begin

      //
      sql.add(
        { } 'select ' +
        { } 'RID,ORT,STRASSE,STRASSEID,X,Y,PLZ_DIVERSITAET,ORTSTEIL ' +
        { } 'from POSTLEITZAHLEN ' +
        { } 'where PLZ=' + inttostr(PLZ) + ' ' +
        { } 'order by RID descending');

      ApiFirst;
      while not(eof) do
      begin

        if OrtIdentisch(Ort, FieldByName('ORT').AsString) or (Ort = '') then
        begin

          //
          if not(Diversitaet) then
            Diversitaet := (FieldByName('PLZ_DIVERSITAET').AsString = cc_True);

          //
          if StrassenNameIdentisch(StrassenName, ObtainStrassenName(FieldByName('STRASSE').AsString))
          then
          begin

            //
            if FieldByName('STRASSEID').IsNotNull then
              StrasseID := trunc(FieldByName('STRASSEID').AsDouble);

            p.x := FieldByName('X').AsDouble;
            p.y := FieldByName('Y').AsDouble;
            if (p.x > 0) and (p.y > 0) then
            begin
              POSTLEITZAHLEN_R := FieldByName('RID').AsInteger;
              r_plz := inttostrN(PLZ, 5);
              r_ortsteil := FieldByName('ORTSTEIL').AsString;
              r_ort := FieldByName('ORT').AsString;
              r_strasse := FieldByName('STRASSE').AsString;
              r_error := 'OK (Cache)';
              EntryFound := true;
              break;
            end;
          end;

        end;
        ApiNext;

      end;
    end;
    cPLZ.free;
  end;

  function WebClear(s: string): string;
  begin
    Result := noblank(s);
    ersetze('<br/>', '', Result);
    ersetze('<br>', '', Result);
  end;

  function pFormat(s: string): string;
  begin
    Result := s;
    if p_PTV then
    begin
      ersetze('ü', 'ue', Result);
      ersetze('ä', 'ae', Result);
      ersetze('ö', 'oe', Result);
      ersetze('Ü', 'Ue', Result);
      ersetze('Ä', 'Ae', Result);
      ersetze('Ö', 'Oe', Result);
      ersetze('ß', 'ss', Result);
    end;
    ersetze(#160, ' ', Result);
    ersetze('!', '', Result);
    ersetze('?', '', Result);
    Result := TIdURI.ParamsEncode(result, IndyTextEncoding(encUTF8));
  end;

  function parseResult_PTV(s: TStringList): TStringList;
  var
    AutomataState, n: integer;
  begin
    AutomataState := 0;
    Result := TStringList.create;
    for n := 0 to pred(s.count) do
    begin
      case AutomataState of
        0:
          if (pos('<!-- BEGIN DATA -->', s[n]) = 1) then
            inc(AutomataState);
        1:
          inc(AutomataState); // überlese "Kommentar"
        2:
          begin
            if Diagnose_Ergebnis then
              Memo1.Lines.add(s[n]);

            inc(AutomataState); // überlese "Titelzeile"
          end;
        3:
          begin
            // erste Zeile
            Result.add(s[n]);
            inc(AutomataState);
          end;
        4:
          begin
            if (pos(';', s[n]) > 0) then
            begin
              Result.add(s[n]);
            end
            else
            begin
              break;
            end;
          end;
      end;
    end;
  end;

  function parseResult_OSM(s: TStringList): TStringList;
  var
    AutomataState, n: integer;
    Bericht: TStringList;
  begin
    result := nil;
    try
    locateResponse.saveToFile(iKartenPfad+'locate.xml');
    Result := TStringList.create;
    Bericht:= TStringList.create;
    if doConversion(Content_Mode_xml2csv,iKartenPfad+'locate.xml',Bericht) then
     Result.loadFromFile(iKartenPfad+'locate.xml.csv');
    except
      on E: exception do
      begin
        r_error := cErrorText + ' ' + E.Message;
      end;
    end;
  end;

begin

  // Init!
  r_plz := cImpossiblePLZ;
  r_ort := '';
  r_ortsteil := '';
  r_strasse := '';
  r_error := 'OK (Webservice)';
  rList := nil;
  StartTime := 0;
  Init;

  //
  q_plz := PLZ;
  POSTLEITZAHLEN_R := cRID_Null;
  p.x := -1;
  p.y := -1;

  // Jetzt gehts wirklich los ...
  if Diagnose_Ergebnis then
  begin
    BeginHourGlass;
    // Eingangsparameter zurück in die Controls
    Edit4.text := Strasse;
    Edit2.text := PLZ + ' ' + Ort;
    Edit1.text := Ortsteil;

    StartTime := RDTSCms;
    Memo1.Lines.clear;
  end;

  repeat

    // Orte mit Fragezeichen sollen nicht geolokalisiert werden!
    if (pos('?', PLZ) > 0) or (pos('?', Ort) > 0) then
    begin
      r_error := 'OK (nicht erwünscht)';
      break;
    end;

    // erste Prüfung:
    PLZasInteger := strtointdef(PLZ, 0);
    if (PLZasInteger < 1) then
    begin
      // Fehler: Formatfehler in der PLZ
      r_error := cErrorText + ' PLZ unverständlich';
      break;
    end;

    // Split des Strassennamens von der Hausnummer!
    n := pos('@', Strasse);
    if (n > 0) then
      Strasse := copy(Strasse, succ(n), MaxInt);

    // Prüfen, ob <leer> oder Fragezeichen
    StrasseRelevant := (Strasse <> '') and (pos('?', Strasse) = 0);

    // Wohneinheit-Zusatz weg!
    n := pos('#', Strasse);
    if (n > 0) then
      Strasse := copy(Strasse, 1, pred(n));

    // Relevant?
    if StrasseRelevant then
    begin
      StrassenName := EnsureSQL(ObtainStrassenName(Strasse));
      StrasseHausnummer := EnsureSQL(ObtainStrassenHausNummer(Strasse));
    end;

    OrtsteilRelevant := pos('!', Ortsteil) > 0;

    EntryFound := false;
    Diversitaet := false;
    StrasseID := -1;

    // schon in der PLZ Tabelle?
    if not(DisableCache) and (PLZ <> cImpossiblePLZ) then
      CacheCheck(PLZasInteger);

    if EntryFound then
      break;

    // nicht gefunden
    if Diversitaet then
    begin

      // Lister aller Alternativ PLZ abfragen!
      if (StrasseID > 0) then
      begin
        PLZl := e_r_sqlm(
         {} 'select distinct PLZ from POSTLEITZAHLEN' +
         {} 'where' +
         {} ' (STRASSEID=' + inttostr(StrasseID) + ') and' +
         {} ' (PLZ_DIVERSITAET IS NOT NULL) and' +
         {} ' (PLZ<>' +   PLZ + ')');
        for n := 0 to pred(PLZl.count) do
        begin
          CacheCheck(PLZl[n]);
          if EntryFound then
            break;
        end;
        PLZl.free;
      end
      else
      begin
        // WARNUNG: In einer vollständig bekannten PLZ (alle Strassen müssten da sein)
        // wird eine Neue Strasse gesucht!
      end;
    end;

    if EntryFound then
      break;

    if p_OffLineMode then
      break;

    // call PHP
    if Diagnose_Ergebnis then
      if not(visible) then
      begin
        show;
        Application.ProcessMessages;
      end;

    if p_PTV then
    begin
      httpRequest := iKartenHost + cLocateScript + '?tan=' + pFormat(FindANewPassword);

      if (PLZ <> '') and (PLZ <> cImpossiblePLZ) then
      begin
         httpRequest := httpRequest + '&zip=' + PLZ;

        if (pos('!', Ort) > 0) then
          httpRequest := httpRequest + '&city=' + pFormat(Ort);

        if not(StrasseRelevant) then
          if (Ortsteil <> '') then
            OrtsteilRelevant := true;

      end
      else
      begin

        if (Ort <> '') then
          httpRequest := httpRequest + '&city=' + pFormat(Ort);

        if (Ortsteil <> '') then
          OrtsteilRelevant := true;
      end;

      if StrasseRelevant then
      begin
        httpRequest := httpRequest + '&street=' + pFormat(StrassenName);
        if (StrasseHausnummer <> '') then
          httpRequest := httpRequest + '&number=' + pFormat(StrasseHausnummer);
      end;

      if OrtsteilRelevant then
        httpRequest := httpRequest + '&district=' + pFormat(Ortsteil);

      if (iKartenProfil <> '') then
        httpRequest := httpRequest + '&profile=' + iKartenProfil;
    end;

    if p_OSM then
    begin

      // Usage Policy
      delay(1000);

      httpRequest := cOpenStreetMap_GeoURL + 'email=andreas.filsinger@orgamon.org&format=xml&country=de';
      if (edit3.Text='') then
      begin
        if (PLZ <> '') and (PLZ <> cImpossiblePLZ) then
        begin

          if not(IgnorePLZ) then
            httpRequest := httpRequest + '&postalcode=' + PLZ;


          if not(StrasseRelevant) then
            if (Ortsteil <> '') then
              OrtsteilRelevant := true;

          if OrtsteilRelevant then
            httpRequest := httpRequest + '&city=' + pFormat(Ortsteil+ ', ' + Ort)
           else
            httpRequest := httpRequest + '&city=' + pFormat(Ort);

        end
        else
        begin

          if (Ortsteil <> '') then
            OrtsteilRelevant := true;

          if (Ort <> '') then
           if OrtsteilRelevant then
            httpRequest := httpRequest + '&city=' + pFormat(Ortsteil + ', ' + Ort)
           else
            httpRequest := httpRequest + '&city=' + pFormat(Ort);

          if (Ort = '') then
           if OrtsteilRelevant then
            httpRequest := httpRequest + '&city=' + pFormat(Ortsteil);

        end;

        if StrasseRelevant then
        begin
          if (StrasseHausnummer <> '') then
            httpRequest := httpRequest + '&street=' + pFormat(StrasseHausnummer+' '+StrassenName)
           else
            httpRequest := httpRequest + '&street=' + pFormat(StrassenName);
        end;
      end else
      begin
        httpRequest := httpRequest +'&q=' + PFormat(edit3.Text);
      end;
    end;


    if Diagnose_Ergebnis then
    begin
      Memo1.Lines.add(httpRequest);
      Memo1.Lines.add('');
    end;

    locateResponse := TStringList.create;
    httpC := TIdHTTP.create(nil);
    if p_OSM then
      with httpC do
      begin
        // Die Accept Angabe definiert, welche Formen von Daten der Client akzeptiert
        Request.Accept :=
          'text/html, application/xml;q=0.9, application/xhtml+xml, image/png, image/jpeg, image/gif, image/x-xbitmap, */*;q=0.1';
        // Der AcceptCharSet Wert definiert, welche Zeichen-Formate der Client akzeptiert
        Request.AcceptCharSet := 'utf-8, iso-8859-1, utf-16, *;q=0.1';
        Request.AcceptLanguage := 'de-de,de;q=0.8,en-us;q=0.5,en;q=0.3';
        // Die AcceptEncoding Angabe definiert, welche Kompressionsformate der Client akzeptiert
        Request.AcceptEncoding := 'deflate, identity, *;q=0';
        Request.Connection := 'keep-alive';
        // Der Referer definiert, auf welcher Webseite wir zuvor waren. Gerade dieser Wert
        // wird gerne von Webseiten abgefragt um ungewünschte Bots zu blocken.
        Request.Referer := cOpenStreetMap_GeoURL;
        // Die Clientkennung
        Request.UserAgent := cAgent;

      end;
    ParamF := TMemoryStream.create;
    try

      // den PHP - Webservice Wrapper anhauen!
      httpC.get(httpRequest, ParamF);

      ParamF.Position := 0;

      if p_PTV then
        locateResponse.LoadFromStream(ParamF);

      if p_OSM then
        locateResponse.LoadFromStream(ParamF,TEncoding.UTF8);

      if Diagnose_PHP then
        Memo1.Lines.addstrings(locateResponse);

      if p_PTV then
        rList := parseResult_PTV(locateResponse);

      if p_OSM then
        rList := parseResult_OSM(locateResponse);

    except

      // Fehler: Probleme mit Netz / PHP
      on E: exception do
      begin
        r_error := cErrorText + ' ' + E.Message;
        break;
      end;
    end;
    ParamF.free;
    httpC.free;
    locateResponse.free;

    if (rList=nil) then
     break;

    if Diagnose_Ergebnis then
    begin
      Memo1.Lines.addstrings(rList);
      Memo1.Lines.add('');
    end;

    if p_ptv then
    begin
      if (rList.count = 1) then
      begin
        rLine := rList[0];
      end
      else
      begin

        // Wenn es mehrere Möglichkeiten gibt, dann muss der
        // Ort zusätzlich stimmen
        // Warum: Beispiel
        // Schulstrasse 7
        // 38312 Heiningen
        // -> hier gibt es 7 Möglichkeiten, gleiche PLZ - aber anderer Ortsnane
        //
        rLine := '';
        repeat

          // Lauf "1", PLZ,Ort,Strasse muss passen
          for n := 0 to pred(rList.count) do
            if
            { PLZ } (PLZ = nextp(rList[n], ';', 4)) and
            { Ort } OrtIdentisch(Ort, nextp(rList[n], ';', 5)) and
            { Strasse } (not(StrasseRelevant) or StrassenNameIdentisch(nextp(rList[n], ';', 5),
              StrassenName)) then
            begin
              EntryFound := true;
              rLine := rList[n];
              break;
            end;
          if EntryFound then
            break;

          // Lauf "2", nur Ort muss passen
          for n := 0 to pred(rList.count) do
            if OrtIdentisch(Ort, nextp(rList[n], ';', 5)) then
            begin
              rLine := rList[n];
              break;
            end;

        until true;
      end;
      rList.free;

      if (rLine = '') then
      begin
        r_error := cErrorText + ' keine Idee bei mehreren Möglichkeiten';
        break;
      end;

      // Ergebnisse extrahieren
      { X           0 } p.x := strtodoubledef(nextp(rLine, ';'), 0) / cGEODEZIMAL_Faktor;
      { Y           1 } p.y := strtodoubledef(nextp(rLine, ';'), 0) / cGEODEZIMAL_Faktor;
      { Strasse     2 } r_strasse := nextp(rLine, ';');
      { Hausnummer  3 } nextp(rLine, ';');
      { PLZ         4 } r_plz := nextp(rLine, ';');
      { Ort         5 } r_ort := nextp(rLine, ';');
      { Ortsteil    6 } r_ortsteil := nextp(rLine, ';');

      EntryFound := true;
    end;

    if p_OSM then
    begin
     sRESULT := TsTable.create;
     with sRESULT do
     begin

      insertfromfile(iKartenPfad+'locate.xml.csv');

      for r := RowCount downto 1 do
       if readcell(r,'class')='shop' then
        Del(r);

      if (RowCount = 0) then
      begin
       r_error := cErrorText + ' kein Resultat';
       break;
      end;


//      if (RowCount>1) then
//      begin
//        r_error := cErrorText + ' mehrere Treffer';
//        break;
//      end;

      // pst: nimm einfach das erste!
      r := 1;

      { X           0 } p.x := strtodoubledef(readcell(r,'lon'),0);
      { Y           1 } p.y := strtodoubledef(readcell(r,'lat'),0);
      OSMid := readcell(r, 'display_name');
      anfix32.ersetze(', ','|',OSMid);

      r := CharCount('|',OSMid);
      if (r=7) then
       if StrFilter(nextp(OSMid,'|',0), cZiffern)='' then

            if (StrassenNameIdentisch(nextp(OSMid,'|',0), StrassenName)) then
begin
   inc(r);
   OSMID := '0|'+OSMid;
end;


      // 0              1                2                3                           4                  5                           6       7       8
      // 9r            , Stömmerstraße  , Schubert&Salzer, Nordost                   , Ingolstadt       , Oberbayern                , Bayern, 85055, Deutschland
      // 5e            , Aussiger Straße, Königstädten   , Rüsselsheim am Main       , Kreis Groß-Gerau , Regierungsbezirk Darmstadt, Hessen, 65428, Deutschland
      // 128           , Drosselweg, Quellental, Pinneberg, Kreis Pinneberg, Schleswig-Holstein, 25421, Deutschland
      case r of
      5: begin
     //   Eichenplatz, Rellingen, Kreis Pinneberg, Schleswig-Holstein, 25462, Deutschland

       r_strasse := nextp(OSMid,'|',0);
       r_ortsteil := ''; // is Dorf
       r_ort := nextp(OSMid,'|',1);
       r_plz := nextp(OSMid,'|',4);

      end;
      6 : begin

      // Atzelhofstraße, Waldhof        , Mannheim       , Regierungsbezirk Karlsruhe, Baden-Württemberg, 68305, Deutschland
      // 125, Hauptstraße, Rellingen, Kreis Pinneberg, Schleswig-Holstein, 25462, Deutschland
       if (StrFilter(nextp(OSMid,'|',0),cZiffern)='') then
       begin

       r_strasse := nextp(OSMid,'|',0);
       r_ortsteil := nextp(OSMid,'|',1);
       r_ort := nextp(OSMid,'|',2);
       r_plz := nextp(OSMid,'|',5);
            end else
            begin
       r_strasse := nextp(OSMid,'|',1);
       r_ortsteil := ''; // is Dorf
       r_ort := nextp(OSMid,'|',2);
       r_plz := nextp(OSMid,'|',5);

            end;

      end;
      7 : begin
       r_strasse := nextp(OSMid,'|',1);
       r_ortsteil := nextp(OSMid,'|',2);
       r_ort := nextp(OSMid,'|',3);
       r_plz := nextp(OSMid,'|',6);

      end;
      8:begin
      { Strasse     2 } r_strasse := nextp(OSMid,'|',1);
      { PLZ         4 } r_plz := nextp(OSMid,'|',7);
      { Ort         5 } r_ort := nextp(OSMid,'|',4);

      if pos('Kreis ',r_ort)=1 then
      begin
       r_ort := nextp(OSMid,'|',3);
      { Ortsteil    6 } r_ortsteil := nextp(OSMid,'|',2);
           end else
           begin
      { Ortsteil    6 } r_ortsteil := nextp(OSMid,'|',3);
           end;
      end;

      else
       r_error := cErrorText + ' nicht implementiertes Antwort-Schema';
       break;
      end;

      if length(r_plz)<>5 then
      begin
        r_error := cErrorText + ' PLZ im Ergebnis hat keine 5 Stellen';
        break;
      end;

      EntryFound := true;

     end;

     (*

     Quelle;
     place_id;
     osm_type;
     osm_id;
     place_rank;
     boundingbox;
     display_name;
     class;
     type;
     importance;
     // Zaehlwerk;
     // edis_key;
     // unit
     *)

     if Diagnose_Ergebnis then
     begin
      Memo1.Lines.add('OSMID: ' + OSMid);
     end;

    end;

    //
    if Diagnose_Ergebnis then
    begin
      Memo1.Lines.add('Strasse: ' + r_strasse);
      Memo1.Lines.add('PLZ: ' + r_plz);
      Memo1.Lines.add('ORT: ' + r_ort);
      Memo1.Lines.add('ORTSTEIL: ' + r_ortsteil);
    end;

    // letzte Plausibilitätskontrolle
    if (PLZ <> r_plz) and (PLZ <> cImpossiblePLZ) then
    begin
      r_error := cErrorText + ' OrgaMon PLZ falsch';
      // Fehler: Umlokalisierung durch den Geo Webservice
      // ups? was ist passiert!
      // Das Ergebnis wurde in einen anderen Bereich umverlegt!
      // Gibt es diese PLZ nicht?! PLZ sind eigentlich unser Anker!
      p.x := 0;
      p.y := 0;
      if Diagnose_Ergebnis then
      begin
        Memo1.Lines.add('Neue PLZ: ' + r_plz + ' ' + r_ort);
      end;
      break;
    end;

    if (StrasseRelevant) then
    begin
      if not(StrassenNameIdentisch(r_strasse, StrassenName)) then
      begin
        if r_strasse = '' then
          r_error := cErrorText + ' Strasse ist unbekannt'
        else
          r_error := cErrorText + ' Strasse ist unterschiedlich';
        p.x := 0;
        p.y := 0;
        break;
      end;
    end;

    if not(EntryFound) then
      break;

    if (PLZ = cImpossiblePLZ) then
    begin
      POSTLEITZAHLEN_R := dummyPLZ_R;
      break;
    end;

    // Ergebnis dauerhaft in DB abspeichern!
    try

      // primärer Eintrag
      n := e_w_GEN('GEN_POSTLEITZAHLEN');
      e_x_sql('insert into POSTLEITZAHLEN (RID,PLZ,ORT,ORTSTEIL,STRASSE,X,Y,EINTRAG) values (' +
        { RID } inttostr(n) + ',' +
        { PLZ } PLZ + ',' +
        { Ort } '''' + EnsureSQL(r_ort) + ''',' +
        { Ortsteil } '''' + EnsureSQL(r_ortsteil) + ''',' +
        { Strasse } '''' + EnsureSQL(Strasse) + ''',' +
        { X } FloatToStrISO(p.x) + ',' +
        { Y } FloatToStrISO(p.y) + ',' +
        { Eintrag } 'CURRENT_TIMESTAMP)');
      POSTLEITZAHLEN_R := n;

      if not(OrtIdentisch(Ort, r_ort)) then
      begin

        // Alias Eintrag
        e_x_sql('insert into POSTLEITZAHLEN (RID,PLZ,ORT,ORTSTEIL,STRASSE,X,Y,EINTRAG) values (' +
          { RID } inttostr(e_w_GEN('GEN_POSTLEITZAHLEN')) + ',' +
          { PLZ } PLZ + ',' +
          { Ort } '''' + EnsureSQL(Ort) + '?'',' + // **!!**
          { Ortsteil } '''' + EnsureSQL(r_ortsteil) + ''',' +
          { Strasse } '''' + EnsureSQL(Strasse) + ''',' +
          { X } FloatToStrISO(p.x) + ',' +
          { Y } FloatToStrISO(p.y) + ',' +
          { Eintrag } 'CURRENT_TIMESTAMP)');

        // **!!**
        // Das Fragezeichen wird für folgenden Umstand eingetragen:
        // Die Adresse konnte eben vom Webservice mit hinreichender
        // Treffsicherheit geolokalisiert werden. ABER: Die Ortsbezeichnung
        // ist nicht identisch, also spätere Adressen mit selben (falsch)
        // abweichendem Ortsnamen können im Cache NICHT gefunden werden. Folge ist,
        // dass immer wieder neue Geo-Web-Anfragen immer wieder neue Einträge
        // in der Datenbank entstehen, die Einträge sind dann individuell und
        // hausnummerngenau.
        // Die Lösung ist dieser "?" Alias Eintrag, der zur Güte entsteht
        // Er befriedigt spätere Anfragen, macht durch sein "?" aber
        // deutlich, dass es ein Problem bei der Ortsangabe gibt!
        if Diagnose_Ergebnis then
        begin
          Memo1.Lines.add(
            { } 'INFO: Alias-Eintrag mit Ort "' +
            { } Ort +
            { } '?" wurde gespeichert, da die Lokalisierung einen anderen Ort ergeben hat (' +
            { } r_ort + ')!');
        end;

      end;
    except

      on E: exception do
      begin
        r_error := cErrorText + ' ' + E.Message;
        break;
      end;

      // Fehler: Datenbank Eintrag war nicht möglich!
    end;

  until true;

  Result := POSTLEITZAHLEN_R;
  p_OffLineMode := false;

  if Diagnose_Ergebnis then
  begin
    RequestTime := RDTSCms - StartTime;
    if (visible) then
      ShowResult(p);
    Memo1.Lines.add('R_Error: ' + r_error);
    Memo1.Lines.add('POSTLEITZAHL_R: ' + inttostr(Result));
    EndHourGlass;
  end;
end;

function TFormGeoLokalisierung.locate(Strasse, PLZ_Ort, Ortsteil: string; var p: Tpoint2D): integer;
var
  pStrasse, pPLZ_Ort, pOrtsteil: string;
  k: integer;

  function quickCheck(s: string): string;
  begin
    Result := cutblank(s);
    ersetze(#160, ' ', Result);
  end;

begin
  p.x := -1;
  p.y := -1;
  pStrasse := quickCheck(Strasse);

  // '@' Lösung im Ort
  k := pos('@', PLZ_Ort);
  if (k > 0) then
    pPLZ_Ort := quickCheck(copy(PLZ_Ort, succ(k), MaxInt))
  else
    pPLZ_Ort := quickCheck(PLZ_Ort);

  // vergessener Leerschritt zwischen PLZ und Ort
  if (length(pPLZ_Ort) > 5) then
    if (pPLZ_Ort[5 + 1] <> ' ') then
      insert(' ', pPLZ_Ort, 6);

  //
  pOrtsteil := quickCheck(Ortsteil);
  if (pos(' ', pPLZ_Ort) = 6) or (length(pPLZ_Ort) = 5) then
    Result := locate(pStrasse, copy(pPLZ_Ort, 1, 5), copy(pPLZ_Ort, 7, MaxInt), pOrtsteil, p)
  else
    Result := locate(pStrasse, cImpossiblePLZ, copy(pPLZ_Ort, 1, MaxInt), pOrtsteil, p);
end;

procedure TFormGeoLokalisierung.SetDiagMode;
begin
  Diagnose_Ergebnis := true;
end;

procedure TFormGeoLokalisierung.UnSetDiagMode;
begin
  CheckBox1.Checked := false;
  Diagnose_PHP := false;
  Diagnose_Ergebnis := false;
end;

procedure TFormGeoLokalisierung.ShowResult(p: Tpoint2D);
begin
  StaticText1.caption := format('%g;%g', [p.x, p.y]);
  StaticText2.caption := format('%d ms Abfragedauer', [RequestTime]);
end;

procedure TFormGeoLokalisierung.Button2Click(Sender: TObject);
begin
  KartenQuota;
end;

procedure TFormGeoLokalisierung.Button3Click(Sender: TObject);
var
  cPOSTLEITZAHLEN: TIB_Cursor;

  RIDS: TgpIntegerList;
  n: integer;
  CompareStr: string;
  _CompareStr: string;
  p: Tpoint2D;
begin
  BeginHourGlass;

  //
  // 1) * Identische Geodateneinträge löschen
  // * Punkte ausserhalb Deutschlands löschen
  //
  RIDS := TgpIntegerList.create;
  cPOSTLEITZAHLEN := DataModuleDatenbank.nCursor;
  with cPOSTLEITZAHLEN do
  begin
    sql.add('select RID,plz,ort,strasse,x,y from POSTLEITZAHLEN where');
    sql.add(' (x is not null) and');
    sql.add(' (y is not null)');
    sql.add('order by x,y,eintrag desc');
    _CompareStr := '';
    ApiFirst;
    while not(eof) do
    begin
      p.x := FieldByName('X').AsDouble;
      p.y := FieldByName('Y').AsDouble;

      CompareStr := FieldByName('PLZ').AsString + ';' + FieldByName('ORT').AsString + ';' +
        FieldByName('STRASSE').AsString;

      repeat

        // das gleiche wie eben?!
        if (CompareStr = _CompareStr) then
        begin
          RIDS.add(FieldByName('RID').AsInteger);
          break;
        end
        else
        begin
          _CompareStr := CompareStr;
        end;

        // ev. ausserhalb von Deutschland?
        if not(inDE(p)) then
        begin
          RIDS.add(FieldByName('RID').AsInteger);
        end;

      until true;

      ApiNext;
    end;
  end;
  cPOSTLEITZAHLEN.free;

  // eigentliche Löschung durchführen!
  for n := 0 to pred(RIDS.count) do
  begin
    e_x_dereference('ABLAGE.POSTLEITZAHL_R', inttostr(RIDS[n]));
    e_x_dereference('AUFTRAG.POSTLEITZAHL_R', inttostr(RIDS[n]));
    e_x_sql('delete from POSTLEITZAHLEN where RID=' + inttostr(RIDS[n]));
  end;
  RIDS.free;

  EndHourGlass;
end;

procedure TFormGeoLokalisierung.Button5Click(Sender: TObject);
var
  cPLZ: TIB_Cursor;
  POSTLEITZAHL_R: integer;
  StartTime: dword;
  p: Tpoint2D;
begin
  //
  BeginHourGlass;
  StartTime := 0;
  cPLZ := DataModuleDatenbank.nCursor;
  with cPLZ do
  begin
    //
    sql.add('select PLZ,ORT,STRASSE from POSTLEITZAHLEN where PLZ_DIVERSITAET IS NOT NULL');
    ApiFirst;
    while not(eof) do
    begin
      repeat
        p_OffLineMode := true;
        POSTLEITZAHL_R := locate(FieldByName('STRASSE').AsString, FieldByName('PLZ').AsString,
          FieldByName('ORT').AsString, '', p);
        if (POSTLEITZAHL_R > 0) then
        begin

          // a) Deref!
          e_x_dereference('ABLAGE.POSTLEITZAHL_R', inttostr(POSTLEITZAHL_R));
          e_x_dereference('AUFTRAG.POSTLEITZAHL_R', inttostr(POSTLEITZAHL_R));

          // b) set x,y = null
          e_x_sql('update POSTLEITZAHLEN set X=null,y=null,eintrag=null where RID=' +
            inttostr(POSTLEITZAHL_R));

        end
        else
        begin
          break;
        end;
      until false;
      ApiNext;
      if frequently(StartTime, 333) or eof then
      begin
        application.processmessages;
        StaticText2.caption := FieldByName('PLZ').AsString + ' ' + FieldByName('STRASSE').AsString;
      end;
    end;
  end;
  cPLZ.free;
  EndHourGlass;
end;

procedure TFormGeoLokalisierung.CheckBox1Click(Sender: TObject);
begin
  Diagnose_PHP := CheckBox1.Checked;
end;

procedure TFormGeoLokalisierung.Init;
begin
  if not(Initialized) then
  begin
    p_OSM:= false;
    p_PTV:= false;
    p_Google:= false;
    with ComboBox2 do
      repeat

        if (pos('tile', iKartenHost) > 0) then
        begin
          ItemIndex := 2;
          p_OSM := true;
          break;
        end;

        if (pos('google', iKartenHost) > 0) then
        begin
          ItemIndex := 1;
          p_Google:= true;
          break;
        end;

        p_PTV:= true;
        ItemIndex := 0;

      until yet;

    Initialized := true;
  end;
end;

procedure TFormGeoLokalisierung.FormActivate(Sender: TObject);
begin
 Init;
end;

procedure TFormGeoLokalisierung.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Geolokalisierung');
end;

end.
