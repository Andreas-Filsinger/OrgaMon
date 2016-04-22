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
unit AuftragErgebnis;

interface

uses
  Windows, Messages, SysUtils,
  Buttons, ExtCtrls, Variants,
  Classes, Graphics, Controls,
  Forms, Dialogs, ComCtrls,
  StdCtrls,

  // FlexCell
  FlexCel.Core, FlexCel.xlsAdapter,

  // Indy
  IdComponent, IdFTP,

  gplists;

type
  TFormAuftragErgebnis = class(TForm)
    Button1: TButton;
    ProgressBar1: TProgressBar;
    ListBox1: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    ProgressBar2: TProgressBar;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    RadioButton1: TRadioButton;
    RadioButton3: TRadioButton;
    ComboBox1: TComboBox;
    CheckBox1: TCheckBox;
    Label4: TLabel;
    Button2: TButton;
    CheckBox2: TCheckBox;
    SpeedButton1: TSpeedButton;
    Image2: TImage;
    Memo1: TMemo;
    Label1: TLabel;
    CheckBox3: TCheckBox;
    Edit2: TEdit;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Label5: TLabel;
    CheckBox6: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
  private
    { Private-Deklarationen }

    // Zentrale Upload - TAN
    HugeTransactionN: integer;
    IdFTP1: TIdFTP;
    FlexCelXLS: TXLSFile;

    // Statistik
    Stat_Erfolg: TgpIntegerList;
    Stat_Vorgezogen: TgpIntegerList;
    Stat_Unmoeglich: TgpIntegerList;
    Stat_Fail: TgpIntegerList;
    Stat_meldungen: integer;
    Stat_nichtEFRE: integer;
    Stat_Attachments: TStringList;
    Stat_FehlendeResourcen: TStringList;

    MaxAnzahl: integer;

    procedure ClearStat;

    // FTP
    procedure IdFTP1Status(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
    procedure IdFTP1BannerAfterLogin(ASender: TObject; const AMsg: string);
    procedure IdFTP1BannerBeforeLogin(ASender: TObject; const AMsg: string);

    //
    function CreateFiles(Settings: TStringList; RIDs: TgpIntegerList; FailL: TgpIntegerList;
      Files: TStringList): boolean;
    function nichtEFREFName(Settings: TStringList): string;
    procedure Log(s: string; BAUSTELLE_R: integer = 0; TAN: string = ''); overload;
    procedure Log(s: TStrings; BAUSTELLE_R: integer = 0; TAN: string = ''); overload;
    function AUFTRAG_R: integer;
    function EinzelMeldeErlaubnis: boolean;

  public
    { Public-Deklarationen }
    function UploadNewTANS(BAUSTELLE_R: integer; ManuellInitiiert: boolean): boolean;
    procedure SetDefaults(ResetRadioButton: boolean);
  end;

var
  FormAuftragErgebnis: TFormAuftragErgebnis;

implementation

uses
  // lib
  anfix32, globals, OrientationConvert,
  CareTakerClient, Sperre, PEM,
  wanfix32, SolidFTP, html,
  JclMiscel,

  // IBO
  IB_Components, IB_Access,

  // OrgaMon-Core
  dbOrgaMon,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  Funktionen_Transaktion,

  // Forms
  Bearbeiter, AuftragArbeitsplatz, Datenbank,
  Mapping, InfoZIP, WordIndex;
{$R *.dfm}

function TFormAuftragErgebnis.CreateFiles(Settings: TStringList; RIDs: TgpIntegerList; FailL: TgpIntegerList;
  Files: TStringList): boolean;
var
  ExcelWriteRow: integer;

  // Kopf-Zeile
  Header: TStringList;
  Header_col_Scan: integer;

  // Strings: A|B|C|A Objects: [0,3]|[1]|[2]|[0,3] so geht das Ding raus!!!
  HeaderDefault: TStringList; // vordefiniert
  HeaderSuppress: TStringList; // nicht erwünschte Daten
  HeaderFromIntern: TStringList; // Spalten aus dem INTERN Feld
  HeaderTextFormat: TStringList; // xls Ausgabe Zellformats soll Text sein

  LinesL: TList;
  ErrorCount: integer;
  cAUFTRAG: TIB_Cursor;
  cINTERNINFO: TIB_Cursor;
  OutFName: string;
  Oc_Bericht: TStringList;
  Oc_Result: boolean;

  // Qualitäts-Sicherung
  sPlausi: string;
  PlausiMode: integer;
  sQS_kritisch: TStringList;

  // Foto mit im Zip?!
  AuchMitFoto: boolean;
  FotoSpalten, _FotoSpalten, FotoSpalte: string; // "FA;FN;FH"
  FilesCandidates: TStringList;
  FotoFName: string;
  _FotoFName: string;

  // Zwischenspeicher
  ActColumn: TStringList;
  ActValue: string;
  ActColIndex: integer;
  zweizeilig: boolean;

  // für die Gesamtausgabe
  HeaderLine: string;
  HeaderName: string;
  DataLine: string;
  ProtokollLine: string;
  Zaehlwerk: string;
  ProtokollFeldNamen: TStringList;
  MussFelder: TStringList;
  RauteFelder: TStringList;
  OhneInhaltFelder: TStringList;
  IstEinMussFeld: boolean;
  IstEinRauteFeld: boolean;
  ProtokollMode: boolean;
  ProtokollWerte: TStringList;
  Umsetzer: TFieldMapping;

  // Zählernummer Neu Umkonvertierungen
  Zaehler_nr_neu_filter: string;
  Zaehler_nr_neu_zeichen: string;

  zaehler_stand_neu: double;
  zaehler_stand_neu_soll: double;
  material_nummer_alt: string;
  FoundLine: integer;
  FAIL_R: integer;
  writePermission: boolean;

  // Cache-Felder von Werten aus dem Datensatz
  // oder Parameter
  AUFTRAG_R: integer;
  BAUSTELLE_R: integer;
  N1, NA, NN, Sparte, A1: string;
  vSTATUS: TeVirtualPhaseStatus;
  ART: string;
  ZAEHLER_NR_NEU: string;
  ZaehlerNummerNeuPreFix: string;
  ZaehlwerkeIst: integer; // aus der Art
  INTERN_INFO: TStringList;
  HTMLBenennung: string;

  // Dinge für die freien Zähler "EFRE"
  FreieResourcen: TsTable;
  Sparten: TFieldMapping;
  EFRE_ZAEHLER_NR_NEU: string;
  EFRE: TgpIntegerList;

  // EFRE - Column Cache
  FreieZaehlerCol_ZaehlerNummer: integer;
  FreieZaehlerCol_MaterialNummer: integer;
  FreieZaehlerCol_Zaehlwerk: integer;
  FreieZaehlerCol_Zaehlerstand: integer;
  FreieZaehlerCol_Lager: integer;
  FreieZaehlerCol_Werk: integer;
  FreieZaehlerCol_Sparte: integer;

  // Excel-Formate
  // Dinge für Protokoll-Text Feld
  fmProtokollText: integer;
  fmInternText: integer;

  // Prüfung doppelte Zählernummer neu
  ZaehlerNummernNeuAusN1: boolean;
  ZaehlerNummernNeuMitA1: boolean;
  ZaehlerNummernNeu: TSearchStringList;
  lZNN_Dupletten: TgpIntegerList;
  DublettenPruefling: string;

  procedure FuelleZaehlerNummerNeu;
  var
    AUFTRAG_R: integer;
    cAUFTRAG: TIB_Cursor;
    PROTOKOLL: TStringList;
    ART: string;
    z: string;
    PreFix: string;
  begin
    ZaehlerNummernNeu.clear;
    cAUFTRAG := DataModuleDatenbank.nCursor;
    PROTOKOLL := TStringList.create;
    with cAUFTRAG do
    begin
      sql.add('select RID,ART,ZAEHLER_NR_NEU,PROTOKOLL from AUFTRAG where'); //
      sql.add(' (STATUS<>6) and');
      sql.add(' (BAUSTELLE_R=' + Settings.values[cE_Datenquelle] + ')');
      ApiFirst;
      while not(eof) do
      begin

        // Init
        AUFTRAG_R := FieldByName('RID').AsInteger;
        ART := FieldByName('ART').AsString;
        z := FieldByName('ZAEHLER_NR_NEU').AsString;
        FieldByName('PROTOKOLL').AssignTo(PROTOKOLL);

        if ZaehlerNummernNeuMitA1 then
          PreFix := PROTOKOLL.values['A1']
        else
          PreFix := '';

        if (z <> '') then
          ZaehlerNummernNeu.addobject(ART + '~' + PreFix + z, pointer(AUFTRAG_R));

        if ZaehlerNummernNeuAusN1 then
        begin
          z := PROTOKOLL.values['N1'];
          if (z <> '') then
            ZaehlerNummernNeu.addobject(ART + '~' + PreFix + z, pointer(AUFTRAG_R));
        end;

        ApiNext;
      end;
    end;
    cAUFTRAG.free;
    PROTOKOLL.free;
    ZaehlerNummernNeu.sort;
  end;

// EFRE- Filter für "Zählernummer Neu"
  function EFRE_Filter_ZaehlerNummerNeu(s: string): string;
  begin
    result := StrFilter(s, '0123456789');
  end;

//
  function getColumn(ColumnName: string): string;
  var
    RawColumn: integer;
  begin
    RawColumn := Header.indexof(ColumnName);
    if (RawColumn <> -1) then
    begin
      result := ActColumn[RawColumn];
      ersetze(',', '.', result);
      ersetze(';', '', result);
    end
    else
    begin
      result := '';
    end;
  end;

  procedure Fill_EFRE(Row: integer);

    procedure CheckSet(FieldName: string; Col: integer; valueDefault: string = '');
    var
      valueFreieZaehler: string;
    begin
      if (FieldName <> '') then
      begin
        valueFreieZaehler := FreieResourcen.readCell(Row, Col);
        if (valueFreieZaehler = '') then
          valueFreieZaehler := valueDefault;
        INTERN_INFO.add(FieldName + '=' + valueFreieZaehler);
      end;
    end;

  begin
    // folgende Spalten vervollständigen:
    CheckSet(Settings.values[cE_MaterialNummerNeu], FreieZaehlerCol_MaterialNummer);
    CheckSet(Settings.values[cE_ZaehlwerkNeu], FreieZaehlerCol_Zaehlwerk, '1');
    if (FreieZaehlerCol_Lager <> -1) then
      CheckSet('Lager', FreieZaehlerCol_Lager);
    if (FreieZaehlerCol_Werk <> -1) then
      CheckSet('Werk', FreieZaehlerCol_Werk);
  end;

  procedure PrepareFormat;
  var
    fmfm: TFlxFormat;
  begin
    with FlexCelXLS do
    begin

      fmfm := GetDefaultFormat;
      with fmfm do
      begin
        Font.name := 'Courier New';
        Font.Size20 := round(8.0 * 20);
        borders.Left.style := TFlxBorderStyle.Thin;
        borders.Left.color := clblack;
        FillPattern.Pattern := TFlxPatternStyle.Solid;
        FillPattern.BgColor := 0;
        VAlignment := TVFlxAlignment.top;
        FillPattern.FgColor := HTMLColor2TColor($99CCFF);
        WrapText := true;
      end;
      fmProtokollText := addformat(fmfm);

      fmfm := GetDefaultFormat;
      with fmfm do
      begin
        format := '@';
      end;
      fmInternText := addformat(fmfm);

    end;
  end;

  procedure WriteLine;
  var
    n: integer;
    fm: integer;
  begin

    for n := 0 to pred(ActColumn.count) do
    begin

      // Zell-Formatierung
      fm := -1;
      if (n < Header.count) then
      begin
        repeat

          // ganzes Protokoll
          if (Header[n] = 'ProtokollText') then
          begin
            fm := fmProtokollText;
            FlexCelXLS.setcolwidth(succ(n), 340 * 18);
            break;
          end;

          // q* Felder im Textformat, damit sie keine schadhafte Formatierung erhalten
          if (pos('q', Header[n]) = 1) then
          begin
            fm := fmInternText;
            break;
          end;

          // Ausdrückliche Textfelder
          if (HeaderTextFormat.indexof(Header[n]) <> -1) then
          begin
            fm := fmInternText;
            break;
          end;

        until true;

      end;

      try
        if (fm = -1) then
        begin
          FlexCelXLS.setCellFromString(ExcelWriteRow, succ(n), ActColumn[n], fm);
        end
        else
        begin
          FlexCelXLS.SetCellFormat(ExcelWriteRow, succ(n), fm);
          FlexCelXLS.SetCellValue(ExcelWriteRow, succ(n), ActColumn[n]);
        end;
      except
        FlexCelXLS.SetCellValue(ExcelWriteRow, succ(n), 'ERROR');
      end;

    end;

    inc(ExcelWriteRow);
  end;

  function ZaehlerNrNeuFilter(Zaehler_Nummer_neu: string): string;
  var
    allFilter: string;
    Filter: string;
    Raster: string;
    Maske: string;
    n: integer;
    quellIndex: integer;
    RasterMatch: boolean;
    FilterMatch: boolean;
    ZaehlerNummerNeu_AnzahlStellen: integer;
  begin
    result := Zaehler_Nummer_neu;
    repeat

      // Zeichen für einen Eintrag durch einen Scan
      if (pos('#', Zaehler_Nummer_neu) = 1) then
      begin

        // Original-Scan sichern und unbehandelt kopieren
        if (Header_col_Scan <> -1) then
          ActColumn[Header_col_Scan] := Zaehler_Nummer_neu;

        // Filter-Beispiele
        //
        // #B2********=xxx!!!!!!!x
        // #B2******=xxx!!!!!!

        allFilter := Zaehler_nr_neu_filter;
        FilterMatch := false;
        while (allFilter <> '') do
        begin
          Filter := nextp(allFilter, ',');
          Raster := nextp(Filter, '=', 0);

          // erst mal sehn, ob das Raster passt!
          if (length(Raster) = length(Zaehler_Nummer_neu)) then
          begin

            // Maske anwenden!
            Maske := nextp(Filter, '=', 1);

            RasterMatch := true;
            for n := 1 to length(Zaehler_Nummer_neu) do
            begin
              if (Raster[n] <> '*') then
                if (Raster[n] <> Zaehler_Nummer_neu[n]) then
                begin
                  RasterMatch := false;
                  break;
                end;
            end;

            if RasterMatch then
            begin
              quellIndex := 1;
              result := '';
              for n := 1 to length(Maske) do
              begin
                case Maske[n] of
                  'x':
                    begin
                      inc(quellIndex);
                    end;
                  '!':
                    begin
                      result := result + Zaehler_Nummer_neu[quellIndex];
                      inc(quellIndex);
                    end;
                else
                  result := result + Maske[n];
                end;
              end;
              FilterMatch := true;
              break;
            end;
          end;
        end;

        if not(FilterMatch) then
        begin
          Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' Zählernummer Neu "' + Zaehler_Nummer_neu +
            '" hat keine Filter-Regel!', BAUSTELLE_R, Settings.values[cE_TAN]);
          writePermission := false;
          if (FailL.indexof(AUFTRAG_R) = -1) then
            FailL.add(AUFTRAG_R);
        end;
        break;
      end;

      if (pos(':', Zaehler_nr_neu_filter) = 1) then
      begin

        // Filter= ":" ~AnzahlDerStellen~ {[ "," ":" ~AnzahlDerStellen~ ]}
        FilterMatch := false;
        ZaehlerNummerNeu_AnzahlStellen := length(result);

        allFilter := noblank(Zaehler_nr_neu_filter);
        while (allFilter <> '') do
        begin
          Filter := nextp(allFilter, ',');
          Raster := nextp(Filter, ':', 1);

          if (ZaehlerNummerNeu_AnzahlStellen = StrToIntDef(Raster, -1)) then
          begin
            // Länge passt
            FilterMatch := true;
            break;
          end;
        end;

        if (vSTATUS in [ctvErfolg, ctvErfolgGemeldet]) then
          if not(FilterMatch) then
          begin
            QS_add('[Q27] Anzahl der Stellen ":' + inttostr(ZaehlerNummerNeu_AnzahlStellen) +
              '" von "Zählernummer-Neu" ist nicht erlaubt', sPlausi);
          end;

        break;
      end;

      if (Header_col_Scan <> -1) then
        ActColumn[Header_col_Scan] := '';

    until true;

    // abschliessendes Filtern
    // im Filter sind alle erlaubten Zeichen angegeben
    if (Zaehler_nr_neu_zeichen <> '') then
      result := StrFilter(result, Zaehler_nr_neu_zeichen);

  end;

  procedure SetHeaderNames;
  var
    n, m: integer;
    HeaderAliasNames: TStringList;
    AliasNames: string;
    OhneInhaltNames: string;
    NewHeaderName: string;
    InternFelder: TStringList;
    IsMuss, IsRaute: boolean;
    AllCols: TgpIntegerList;
  begin

    // Liste aufbereiten, wie Sie vom System kommt
    HeaderLine := cWordHeaderLine;
    while (HeaderLine <> '') do
      HeaderDefault.add(nextp(HeaderLine, ';'));

    // Red - List aufbereiten!
    HeaderLine := cRedHeaderLine;
    while (HeaderLine <> '') do
      HeaderSuppress.add(nextp(HeaderLine, ';'));

    // Red - List erweitern!
    HeaderLine := cutblank(Settings.values[cE_verboteneSpalten]);
    while (HeaderLine <> '') do
      HeaderSuppress.add(cutblank(nextp(HeaderLine, ';')));

    // am Anfang stehen die vorgegebenen Titelspalten.
    // kommt es nicht vom "System" muss es ein "Intern"-Feld sein.
    HeaderLine := Settings.values[cE_SAPReihenfolge];
    while (HeaderLine <> '') do
    begin
      HeaderName := cutblank(nextp(HeaderLine, ';'));
      if (HeaderName <> '') then
      begin

        IsMuss := false;
        IsRaute := false;

        if (pos('!', HeaderName) > 0) then
        begin
          ersetze('!', '', HeaderName);
          IsMuss := true;
        end;

        if (pos('#', HeaderName) > 0) then
        begin
          ersetze('#', '', HeaderName);
          IsRaute := true;
        end;

        // Den Feldnamen jetzt zu den einzelnen Listen hinzunehmen!
        if (HeaderDefault.indexof(HeaderName) = -1) then
          if (ProtokollFeldNamen.indexof(HeaderName) = -1) then
            HeaderFromIntern.add(HeaderName);

        Header.add(HeaderName);
        if IsMuss then
          MussFelder.add(HeaderName);
        if IsRaute then
          RauteFelder.add(HeaderName);

      end;
    end;

    // nun alle fehlenden Spaltenüberschriften hinzunehmen (wenn nicht schon vorhanden)
    for n := 0 to pred(HeaderDefault.count) do
    begin
      if (HeaderSuppress.indexof(HeaderDefault[n]) = -1) then
        if (Header.indexof(HeaderDefault[n]) = -1) then
          Header.add(HeaderDefault[n]);
    end;

    // nun alle Protokollfelder hinzunehmen (wenn nicht schon vorhanden)
    for n := 0 to pred(ProtokollFeldNamen.count) do
      if (HeaderSuppress.indexof(ProtokollFeldNamen[n]) = -1) then
        if (Header.indexof(ProtokollFeldNamen[n]) = -1) then
          Header.add(ProtokollFeldNamen[n]);

    // nun alle InternFelder hinzunehmen (wenn nicht schon vorhanden)
    if (Settings.values[cE_InternInfos] = cINI_Activate) then
    begin
      InternFelder := TStringList.create;
      e_r_InternExport(BAUSTELLE_R, InternFelder);
      for n := 0 to pred(InternFelder.count) do
      begin
        HeaderName := InternFelder[n];
        if (HeaderSuppress.indexof(HeaderName) = -1) then
          if (Header.indexof(HeaderName) = -1) then
          begin
            Header.add(HeaderName);
            HeaderFromIntern.add(HeaderName);
          end;
      end;
      InternFelder.free;
    end;

    // nun noch errechnete Spalten hinzunehmen
    if (Zaehler_nr_neu_filter <> '') then
    begin
      //
      if (Header.indexof('Scan_Zaehler_Nummer_Neu') = -1) then
        Header.add('Scan_Zaehler_Nummer_Neu');
      Header_col_Scan := Header.indexof('Scan_Zaehler_Nummer_Neu');
    end;

    // Alias / Umbenennung der Spaltenüberschriften
    HeaderAliasNames := TStringList.create;
    AliasNames := Settings.values[cE_SpaltenAlias];
    while (AliasNames <> '') do
      HeaderAliasNames.add(nextp(AliasNames, ';'));
    with FlexCelXLS do
      for n := 0 to pred(Header.count) do
      begin
        NewHeaderName := HeaderAliasNames.values[Header[n]];
        if (NewHeaderName = '') then
          NewHeaderName := Header[n];
        SetCellValue(1, succ(n), NewHeaderName);
      end;
    HeaderAliasNames.free;

    // Spalten ohne Inhalt
    OhneInhaltNames := Settings.values[cE_SpaltenOhneInhalt];
    if (OhneInhaltNames = '') then
      OhneInhaltNames := 'Bemerkung';
    OhneInhaltFelder.free;
    OhneInhaltFelder := Split(OhneInhaltNames);

    // "Index-Liste" aufbauen, Beispiel:
    // A;B;C;A -> [0,3];[1];[2];[0,3]
    //
    for n := 0 to pred(Header.count) do
    begin
      AllCols := TgpIntegerList.create;
      for m := 0 to pred(Header.count) do
        if Header[n] = Header[m] then
          AllCols.add(m);
      Header.objects[n] := AllCols;
    end;

  end;

  function SetCell(ActColIndex: integer; Value: string): boolean; overload;
  var
    n: integer;
    AllCols: TgpIntegerList;
    c: integer;
    UmsetzerName: string;
    _Value: string;
  begin
    result := false;
    if (ActColIndex <> -1) then
    begin

      // Zwang zu ohne Inhalt
      if (Value <> '') then
        if (OhneInhaltFelder.indexof(Header[ActColIndex]) <> -1) then
          Value := '';

      // Raute
      if (Value <> '') then
        if (RauteFelder.indexof(Header[ActColIndex]) <> -1) then
        begin
          if (pos('E', Value) > 0) then
            Value := inttostr(round(strtodouble(Value)));

          if (pos('#', Value) <> 1) then
            Value := '#' + Value;
        end;

      // Umsetzer
      try
        Value := Umsetzer[Header[ActColIndex], Value];
      except
        on e: exception do
        begin
          writePermission := false;
          Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ') Umsetzer "' + Header[ActColIndex] + '.ini":' + e.message,
            BAUSTELLE_R, Settings.values[cE_TAN]);
          if (FailL.indexof(AUFTRAG_R) = -1) then
            FailL.add(AUFTRAG_R);
        end;
      end;

      AllCols := TgpIntegerList(Header.objects[ActColIndex]);
      for n := 0 to pred(AllCols.count) do
      begin
        c := AllCols[n];
        UmsetzerName := 'Column_' + inttostr(succ(c));
        try
          _Value := Umsetzer[UmsetzerName, Value];
        except
          on e: exception do
          begin
            writePermission := false;
            Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ') Umsetzer "' + UmsetzerName + '.ini":' + e.message,
              BAUSTELLE_R, Settings.values[cE_TAN]);
            if (FailL.indexof(AUFTRAG_R) = -1) then
              FailL.add(AUFTRAG_R);
          end;
        end;
        ActColumn[c] := _Value;
      end;
      result := true;
    end;
  end;

  function evalColumnExpression(e: string): string;
  var
    Token, Value: string;
    Col: integer;
  begin
    result := e;
    while (pos('~', result) > 0) do
    begin
      Token := ExtractSegmentBetween(result, '~', '~');
      Col := Header.indexof(Token);
      if (Col <> -1) then
        Value := ActColumn[Col]
      else
        Value := 'REF!';
      ersetze('~' + Token + '~', Value, result);
    end;
  end;

  function SetCell(ColumName: string; Value: string): boolean; overload;
  begin
    result := SetCell(Header.indexof(ColumName), Value);
  end;

  procedure Q_CheckFotoFile(f: string; AUFTRAG_R: integer; Parameter: string);
  var
    FNameA: string;
    FNameB: string;
  begin
    FNameA := nextp(f, ',', 0);
    if (FNameA <> '') then
    begin

      repeat

        // Prüfung A
        FNameA := FotoPath + e_r_BaustellenPfad(Settings) + '\' + FNameA;
        if FileExists(FNameA) then
          break;

        // Prüfung B
        FNameB := FotoPath + e_r_BaustellenPfad(Settings) + '\' + nextp(e_r_FotoName(AUFTRAG_R, Parameter), ',', 0);
        if FileExists(FNameB) then
          break;

        if (FNameA = FNameB) then
          QS_add('[Q25] Bild-Datei "' + FNameA + '" existiert nicht', sPlausi)
        else
          QS_add('[Q25] Bild-Datei "' + FNameA + '" sowie "' + FNameB + '" existieren nicht', sPlausi);

      until true;
    end;
  end;

var
  n, k, y: integer;

begin
  ErrorCount := 0;
  BAUSTELLE_R := 0;
  vSTATUS := ctvDatenFehlen;

  //
  FreieZaehlerCol_ZaehlerNummer := -1;
  FreieZaehlerCol_MaterialNummer := -1;
  FreieZaehlerCol_Zaehlwerk := -1;
  FreieZaehlerCol_Zaehlerstand := -1;
  FreieZaehlerCol_Lager := -1;
  FreieZaehlerCol_Werk := -1;
  FreieZaehlerCol_Sparte := -1;

  LinesL := TList.create;
  ProtokollFeldNamen := TStringList.create;
  ProtokollWerte := TStringList.create;
  FreieResourcen := TsTable.create;
  Sparten := TFieldMapping.create;

  ActColumn := TStringList.create;
  MussFelder := TStringList.create;
  RauteFelder := TStringList.create;
  OhneInhaltFelder := TStringList.create;

  ZaehlerNummernNeu := TSearchStringList.create;

  try
    ProgressBar1.max := RIDs.count;
    ProgressBar1.position := 0;

    with FlexCelXLS do
    begin

      if (Settings.values[cE_SAPQUELLE] <> '') then
      begin

        // Freie Zähler laden
        if FileExists(cAuftragErgebnisPath + Settings.values[cE_SAPQUELLE]) then
        begin

          // Sparten Umsetzer (im normalen Export-Verzeichnis)
          Sparten.Path := cAuftragErgebnisPath + e_r_BaustellenPfad(Settings);

          // FehlendeResourcen
          FileDelete(nichtEFREFName(Settings));

          // Laden der EFRE - Datei
          with FreieResourcen do
          begin

            oNoBlank := true;
            oDistinct := true;
            insertFromFile(cAuftragErgebnisPath + Settings.values[cE_SAPQUELLE]);

            FreieZaehlerCol_ZaehlerNummer := colof('Serialnummer');
            if (FreieZaehlerCol_ZaehlerNummer = -1) then
              raise exception.create(Settings.values[cE_SAPQUELLE] + ': Spalte "Serialnummer" fehlt');

            //
            FreieZaehlerCol_MaterialNummer := colof('MaterialNo');
            if (FreieZaehlerCol_MaterialNummer = -1) then
              raise exception.create(Settings.values[cE_SAPQUELLE] + ': Spalte "MaterialNo" fehlt');

            //
            FreieZaehlerCol_Zaehlwerk := colof('ZWrk');
            if (FreieZaehlerCol_Zaehlwerk = -1) then
              raise exception.create(Settings.values[cE_SAPQUELLE] + ': Spalte "ZWrk" fehlt');

            //
            FreieZaehlerCol_Zaehlerstand := colof('Stand');
            if (FreieZaehlerCol_Zaehlerstand = -1) then
              raise exception.create(Settings.values[cE_SAPQUELLE] + ': Spalte "Stand" fehlt');

            // Optionale Felder!
            FreieZaehlerCol_Lager := colof('Lager');
            FreieZaehlerCol_Werk := colof('Werk');
            FreieZaehlerCol_Sparte := colof('Sparte');

            // Umkonvertierungen
            for n := 1 to pred(count) do
            begin

              // Zählernummer Neu
              WriteCell(n, FreieZaehlerCol_ZaehlerNummer,
                EFRE_Filter_ZaehlerNummerNeu(readCell(n, FreieZaehlerCol_ZaehlerNummer)));

              // Sparten
              if (FreieZaehlerCol_Sparte <> -1) then
                WriteCell(n, FreieZaehlerCol_Sparte, Sparten[cMapping_EFRE_Sparten,
                  readCell(n, FreieZaehlerCol_Sparte)]);

            end;
          end;

          // Diagnose speichern
          FreieResourcen.SaveToFile(
            { } cAuftragErgebnisPath +
            { } e_r_BaustellenPfad(Settings) + '\' +
            { } 'Diagnose-EFRE.csv');
        end
        else
        begin
          raise exception.create(cAuftragErgebnisPath + Settings.values[cE_SAPQUELLE] + ' fehlt!');
        end;

      end;

      // Datei neu erstellen
      NewFile(1);
      PrepareFormat;

      // Einstellungen laden
      BAUSTELLE_R := strtoint(Settings.values[cE_BAUSTELLE_R]);
      Zaehlwerk := Settings.values[cE_Zaehlwerk];
      Zaehler_nr_neu_filter := Settings.values[cE_Filter];
      Zaehler_nr_neu_zeichen := Settings.values[cE_ZaehlerNummerNeuZeichen];
      HTMLBenennung := Settings.values[cE_HTMLBenennung];
      PlausiMode := StrToIntDef(Settings.values[cE_QS_Mode], 4);

      // =JA oder =FA oder =FA;FN
      AuchMitFoto :=
      { } (Settings.values[cE_AuchMitFoto] <> cIni_DeActivate) and
      { } (Settings.values[cE_AuchMitFoto] <> '') and
      { } (FotoPath <> '');
      if AuchMitFoto then
      begin
        if (Settings.values[cE_AuchMitFoto] = cINI_Activate) then
          FotoSpalten := 'FA'
        else
          FotoSpalten := Settings.values[cE_AuchMitFoto];
      end
      else
        FotoSpalten := '';

      ZaehlerNummernNeuAusN1 := (Settings.values[cE_ZaehlerNummerNeuAusN1] <> cIni_DeActivate);
      ZaehlerNummernNeuMitA1 := (Settings.values[cE_ZaehlerNummerNeuMitA1] = cINI_Activate);

      cINTERNINFO := DataModuleDatenbank.nCursor;
      cINTERNINFO.sql.add('select INTERN_INFO, ZAEHLER_NR_NEU, ZAEHLER_STAND_NEU from AUFTRAG where RID=:CROSSREF');
      INTERN_INFO := TStringList.create;

      // Header ermitteln und schreiben
      HeaderDefault := TStringList.create; // so kommt es vom System!
      Header := TStringList.create; // so nehmen wir es!
      Header_col_Scan := -1;

      HeaderFromIntern := TStringList.create;
      // die kommen aus den intern Feldern
      HeaderSuppress := TStringList.create; // unerwünschte Daten
      Umsetzer := TFieldMapping.create;
      // Spalten, die als "Text" formatiert werden müssen
      HeaderTextFormat := Split(Settings.values[cE_SpalteAlsText]);
      HeaderTextFormat.sort;

      // Umsetzer.Path := SAPPath + settings.values[cE_FTPUSER];
      Umsetzer.Path := cAuftragErgebnisPath + e_r_BaustellenPfad(Settings);

      Settings.values[cE_Filter];

      e_r_ProtokollExport(BAUSTELLE_R, ProtokollFeldNamen);
      ProtokollMode := (ProtokollFeldNamen.count > 0);

      // Excel-Titel-Zeile erzeugen
      SetHeaderNames;

      // Liste der bisherigen Z# Neu erstellen
      FuelleZaehlerNummerNeu;

      // "leere" Zeile vorbereiten
      ActColumn.clear;
      for n := 0 to pred(Header.count) do
        ActColumn.add('');

      // nun die einzelnen Daten schreiben
      ExcelWriteRow := 2;
      for n := 0 to pred(RIDs.count) do
      begin

        AUFTRAG_R := integer(RIDs[n]);
        zweizeilig := false;
        writePermission := true;
        sPlausi := ''; // Qualitätssicherung [Qnn] System initialisieren

        ProgressBar1.position := n;
        application.processmessages;

        // normale Daten - Spalten
        ProtokollWerte.clear;
        DataLine := e_r_AuftragLine(AUFTRAG_R);
        k := 0;
        while (DataLine <> '') do
        begin
          ActValue := nextp(DataLine, ';');
          repeat

            if (k = twh_Protokoll) then
            begin
              while (ActValue <> '') do
                ProtokollWerte.add(nextp(ActValue, cProtokollTrenner));
              break;
            end;

            if (k = twh_ZaehlerNummerNeu) then
            begin
              ActValue := ZaehlerNrNeuFilter(ActValue);
              ZAEHLER_NR_NEU := ActValue;
            end;

            if (k = twh_Status1) then
              vSTATUS := TeVirtualPhaseStatus(StrToIntDef(ActValue, ord(ctvDatenFehlen)));

            if (k = twh_ART) then
            begin
              ART := ActValue;
              Sparte := Sparten[cMapping_EFRE_Sparten, ART];
            end;

            SetCell(HeaderDefault[k], ActValue);

          until true;
          inc(k);
        end;

        // Protokollspalten füllen
        for k := 0 to pred(ProtokollFeldNamen.count) do
        begin
          ActValue := KommaCheck(ProtokollWerte.values[ProtokollFeldNamen[k]]);

          if (ProtokollFeldNamen[k] = 'N1') then
            N1 := ActValue;
          if (ProtokollFeldNamen[k] = 'A1') then
            A1 := ActValue;

          SetCell(ProtokollFeldNamen[k], ActValue);
        end;

        // Protokoll als Text auffüllen
        ActColIndex := Header.indexof('ProtokollText');
        if (ActColIndex <> -1) then
          SetCell(ActColIndex, HugeSingleLine(pem_show(ProtokollePath + ActColumn[Header.indexof('Baustelle')] +
            ActColumn[Header.indexof('Art')], ProtokollWerte), #10));

        // Zusätzliche Felder lesen
        with cINTERNINFO do
        begin
          ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
          ApiFirst;
          FieldByName('INTERN_INFO').AssignTo(INTERN_INFO);
          if (Zaehlwerk <> '') then
          begin
            INTERN_INFO.add('ZaehlwerkMitArt=' + ART + '-1');
            INTERN_INFO.add(Zaehlwerk + '=1');
          end;

          // Q-System umgehen
          if (INTERN_INFO.values['QS_UMGANGEN'] <> '') then
            QS_add('[Q12] Qualitätssicherung übergangen', sPlausi);

          // Q-System soll einen Stop auslösen
          if (INTERN_INFO.values['QS_NOGO'] <> '') then
            QS_add('[Q26] QS_NOGO ist gesetzt, ev. Nacharbeiten notwendig', sPlausi);

          // aus den normalen Daten
          EFRE_ZAEHLER_NR_NEU := EFRE_Filter_ZaehlerNummerNeu(FieldByName('ZAEHLER_NR_NEU').AsString);
          zaehler_stand_neu := strtodoubledef(FieldByName('ZAEHLER_STAND_NEU').AsString, 0);

          // aus den intern Feldern
          material_nummer_alt := INTERN_INFO.values[Settings.values[cE_MaterialNummerAlt]];
          close;
        end;

        // Nun noch die Intern Infos übernehmen
        if (HeaderFromIntern.count > 0) then
        begin

          if (FreieResourcen.count > 0) and (EFRE_ZAEHLER_NR_NEU <> '') then
          begin

            // Gib die Liste der Einträge mit passender Zählernummer
            EFRE := FreieResourcen.locateDuplicates(FreieZaehlerCol_ZaehlerNummer, EFRE_ZAEHLER_NR_NEU);

            FoundLine := -1;
            repeat

              if (FreieZaehlerCol_Sparte <> -1) then
              begin

                // Wenn die Spalte "Sparte" vorhanden ist wird sie auch ausgewertet
                // Es Treffer MUSS dann auch in der Sparte passen
                for k := 0 to pred(EFRE.count) do
                  if (FreieResourcen.readCell(EFRE[k], FreieZaehlerCol_Sparte) = Sparte) then
                  begin
                    FoundLine := EFRE[k];
                    Fill_EFRE(FoundLine);
                    break;
                  end;

              end
              else
              begin

                // Kombination "SerialNummer" & "MaterialNummer" versuchen!
                for k := 0 to pred(EFRE.count) do
                  if FreieResourcen.readCell(EFRE[k], FreieZaehlerCol_MaterialNummer) = material_nummer_alt then
                  begin
                    FoundLine := EFRE[k];
                    Fill_EFRE(FoundLine);
                    break;
                  end;
                if (FoundLine <> -1) then
                  break;

                // Jetzt einfach nur den ersten Treffer nehmen
                if (EFRE.count > 0) then
                begin
                  FoundLine := EFRE[0];
                  Fill_EFRE(FoundLine);
                  break;
                end;

              end;

            until true;

            EFRE.free;

            if (FoundLine = -1) then
            begin

              writePermission := false;
              inc(Stat_nichtEFRE);

              // Fehler Berichten
              Stat_FehlendeResourcen.add(
                { } EFRE_ZAEHLER_NR_NEU + ';' +
                { } material_nummer_alt + ';' +
                { } Settings.values[cE_TAN] + ';' +
                { } inttostr(AUFTRAG_R) + ';' +
                { } ZAEHLER_NR_NEU);

              //
              Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' Resource Zählernummer "' + EFRE_ZAEHLER_NR_NEU +
                '" nicht gefunden!', BAUSTELLE_R, Settings.values[cE_TAN]);

              //
              if (FailL.indexof(AUFTRAG_R) = -1) then
              begin
                FailL.add(AUFTRAG_R);
              end;

            end
            else
            begin

              // Plausibilität Zählerstand "neu" prüfen
              zaehler_stand_neu_soll :=
                strtodoubledef(FreieResourcen.readCell(FoundLine, FreieZaehlerCol_Zaehlerstand), -1);

              if (zaehler_stand_neu_soll > 0) then
              begin
                if (abs(zaehler_stand_neu - zaehler_stand_neu_soll) > 35.0) then
                  QS_add(format('[Q22] Einbaustand falsch (Zählerstand-EFRE=%.0f <> Zählerstand-Monteur=%.0f)',
                    [zaehler_stand_neu_soll, zaehler_stand_neu]), sPlausi);
              end;

              // zumindest für dieses Mal diese Zeile löschen
              FreieResourcen.del(FoundLine);
            end;

          end;

          // Jetzt noch die Intern-Namen einfügen!
          for k := 0 to pred(HeaderFromIntern.count) do
          begin
            HeaderName := HeaderFromIntern[k];
            ActColIndex := Header.indexof(HeaderName);
            if (ActColIndex <> -1) then
            begin
              repeat

                // "c" Felder (calculated)
                if (HeaderName = 'cZaehlerNummerEinbau') then
                begin
                  if (length(ZAEHLER_NR_NEU) = 11) then
                    if (pos('+009', ZAEHLER_NR_NEU) = 1) then
                    begin
                      ActValue := copy(ZAEHLER_NR_NEU, 2, 9);
                      break;
                    end;
                end;

                // cFA, cFN, cFH ...
                if (length(HeaderName) = 3) then
                  if (pos('cF', HeaderName) = 1) then
                  begin
                    ActValue := e_r_FotoName(
                      { } AUFTRAG_R, copy(
                      { } HeaderName, 2, MaxInt));
                    break;
                  end;

                // Dateiname für die HTML Ausgabe
                if (HeaderName = 'HTML-Benennung') then
                  if (HTMLBenennung <> '') then
                  begin
                    ActValue := evalColumnExpression(HTMLBenennung);
                    break;
                  end;

                ActValue := KommaCheck(INTERN_INFO.values[HeaderName]);
              until true;
              SetCell(ActColIndex, ActValue);
            end;
          end;

          // Jetzt noch ev. das Zw = 2 schreiben
          if (Zaehlwerk <> '') then
          begin

            // Bei der Art "2" sollten Nebentarif-Stände da sein!
            ZaehlwerkeIst := StrToIntDef(StrFilter(ART, '0123456789'), 1);

            if (ZaehlwerkeIst > 1) then
            begin

              zweizeilig := true;

              // Nebentarif alter Zähler
              ActColIndex := Header.indexof('NA');
              if (ActColIndex <> -1) then
                NA := ActColumn[ActColIndex];

              // Nebentarif neuer Zähler
              ActColIndex := Header.indexof('NN');
              if (ActColIndex <> -1) then
                NN := ActColumn[ActColIndex];

              ActColIndex := Header.indexof('Sparte');
              if (ActColIndex <> -1) then
                Sparte := ActColumn[ActColIndex]
              else
                Sparte := '?';

              if (Settings.values[cE_EinsZuEins] <> cIni_DeActivate) and (vSTATUS in [ctvErfolg, ctvErfolgGemeldet])
              then
              begin
                // HIER DIE PLAUSIBILITÄTSPRÜFUNGEN

                // Plausi für Nebentarif Alt
                if (Sparte <> 'Einbau') then
                  if (NA = '') then
                  begin
                    writePermission := false;
                    Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' Alter Zähler: Nebentarif NA fehlt!',
                      BAUSTELLE_R, Settings.values[cE_TAN]);
                    if (FailL.indexof(AUFTRAG_R) = -1) then
                      FailL.add(AUFTRAG_R);
                  end;

                // Plausi für Nebentarif Neu
                if (Sparte <> 'Ausbau') then
                  if (NN = '') then
                  begin
                    writePermission := false;
                    Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' Neuer Zähler: Nebentarif NN fehlt!',
                      BAUSTELLE_R, Settings.values[cE_TAN]);
                    if (FailL.indexof(AUFTRAG_R) = -1) then
                      FailL.add(AUFTRAG_R);
                  end;
              end;

            end;

          end;
        end; // Aufgaben von Internfeldern

        // Überprüfung der Zwangsfelder!
        if writePermission then
        begin
          if (vSTATUS in [ctvErfolg, ctvErfolgGemeldet]) then
            for k := 0 to pred(MussFelder.count) do
            begin
              ActColIndex := Header.indexof(MussFelder[k]);
              if (ActColIndex <> -1) then
                if (noblank(ActColumn[ActColIndex]) = '') then
                begin
                  writePermission := false;
                  Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' Mussfeld "' + MussFelder[k] +
                    '" hat keinen Eintrag', BAUSTELLE_R, Settings.values[cE_TAN]);
                  if (FailL.indexof(AUFTRAG_R) = -1) then
                    FailL.add(AUFTRAG_R);
                end;
            end;
        end;

        if writePermission then
        begin

          case PlausiMode of
            0:
              ; // Aus!
            1:
              QS_add(e_r_AuftragPlausi(AUFTRAG_R), sPlausi);
            2:
              begin
                if (vSTATUS in [ctvErfolg, ctvErfolgGemeldet]) then
                begin

                  ActColIndex := Header.indexof('ZaehlerStandAlt');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    QS_add('[Q01] Kein Ausbaustand', sPlausi);

                  ActColIndex := Header.indexof('ZaehlerNummerNeu');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                  begin
                    ActColIndex := Header.indexof('N1');
                    if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                      QS_add('[Q02] Kein Einbauzähler', sPlausi);
                  end;

                  ActColIndex := Header.indexof('ZaehlerStandNeu');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    QS_add('[Q03] Kein Einbaustand', sPlausi);

                  ActColIndex := Header.indexof('Art');
                  ZaehlwerkeIst := StrToIntDef(StrFilter(ActColumn[ActColIndex], '0123456789'), 1);

                  if (ZaehlwerkeIst > 1) then
                  begin

                    // Nebentarif alter Zähler
                    ActColIndex := Header.indexof('NA');
                    if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                      QS_add('[Q04] Kein Nebentarif Ausbaustand', sPlausi);

                    // Nebentarif neuer Zähler
                    ActColIndex := Header.indexof('NN');
                    if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                      QS_add('[Q05] Kein Nebentarif Einbaustand', sPlausi);

                  end;

                end;
              end;
            3:
              begin
                if (vSTATUS in [ctvErfolg, ctvErfolgGemeldet]) then
                begin

                  ActColIndex := Header.indexof('ZaehlerStandAlt');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    QS_add('[Q01] Kein Ausbaustand', sPlausi);

                  ActColIndex := Header.indexof('ZaehlerNummerNeu');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                  begin
                    ActColIndex := Header.indexof('N1');
                    if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                      QS_add('[Q02] Kein Einbauzähler', sPlausi);
                  end;

                  ActColIndex := Header.indexof('ZaehlerStandNeu');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    QS_add('[Q03] Kein Einbaustand', sPlausi);

                end;

                if (vSTATUS in [ctvVorgezogen, ctvUnmoeglich, ctvVorgezogenGemeldet, ctvUnmoeglichGemeldet]) then
                begin
                  k := 0;
                  ActColIndex := Header.indexof('I3');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    inc(k);
                  ActColIndex := Header.indexof('I6');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    inc(k);
                  ActColIndex := Header.indexof('I7');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    inc(k);
                  if (k = 3) then
                    QS_add('[Q20] Keine Anmerkung des Monteurs', sPlausi);
                end;

              end;
            4: // das default Modell!
              begin
                if (vSTATUS in [ctvErfolg, ctvErfolgGemeldet]) then
                begin

                  ActColIndex := Header.indexof('ZaehlerStandAlt');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    QS_add('[Q01] Kein Ausbaustand', sPlausi);

                  ActColIndex := Header.indexof('ZaehlerNummerNeu');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                  begin
                    ActColIndex := Header.indexof('N1');
                    if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                      QS_add('[Q02] Kein Einbauzähler', sPlausi);
                  end;

                  ActColIndex := Header.indexof('ZaehlerStandNeu');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    QS_add('[Q03] Kein Einbaustand', sPlausi);

                  ZaehlwerkeIst := StrToIntDef(StrFilter(ART, cZiffern), 1);

                  if (ZaehlwerkeIst > 1) then
                  begin

                    // Nebentarif alter Zähler
                    ActColIndex := Header.indexof('NA');
                    if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                      QS_add('[Q04] Kein Nebentarif Ausbaustand', sPlausi);

                    // Nebentarif neuer Zähler
                    ActColIndex := Header.indexof('NN');
                    if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                      QS_add('[Q05] Kein Nebentarif Einbaustand', sPlausi);

                  end;

                  ActColIndex := Header.indexof('FA');
                  if (ActColIndex <> -1) then
                    if (ActColumn[ActColIndex] = '') then
                      QS_add('[Q23] FA ist leer im Status Erfolg', sPlausi);

                end;

                if (vSTATUS in [ctvVorgezogen, ctvUnmoeglich, ctvVorgezogenGemeldet, ctvUnmoeglichGemeldet]) then
                begin
                  k := 0;
                  ActColIndex := Header.indexof('I3');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    inc(k);
                  ActColIndex := Header.indexof('I6');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    inc(k);
                  ActColIndex := Header.indexof('I7');
                  if (ActColIndex = -1) or (ActColumn[ActColIndex] = '') then
                    inc(k);
                  if (k = 3) then
                    QS_add('[Q20] Keine Anmerkung des Monteurs', sPlausi);

                  ActColIndex := Header.indexof('FA');
                  if (ActColIndex <> -1) then
                    if (ActColumn[ActColIndex] = '') then
                      QS_add('[Q24] FA ist leer im Status Unmöglich oder Vorgezogen', sPlausi);

                end;

                ActColIndex := Header.indexof('FA');
                if (ActColIndex <> -1) then
                  Q_CheckFotoFile(ActColumn[ActColIndex], AUFTRAG_R, 'FA');

                ActColIndex := Header.indexof('FN');
                if (ActColIndex <> -1) then
                  Q_CheckFotoFile(ActColumn[ActColIndex], AUFTRAG_R, 'FN');

              end;
          else
            QS_add('[Q99] Bewertungsmodell unbekannt', sPlausi);
          end;

        end;

        // Dubletten-Prüfung
        if (PlausiMode > 0) then
          if
          { } ((ZAEHLER_NR_NEU <> '0') and
            { } (ZAEHLER_NR_NEU <> '')) or
          { } ((N1 <> '0') and (N1 <> '') and ZaehlerNummernNeuAusN1) then
          begin

            // Alphanumerischer Vorsatz
            if ZaehlerNummernNeuMitA1 then
              ZaehlerNummerNeuPreFix := A1
            else
              ZaehlerNummerNeuPreFix := '';

            // Zählernumer Neu
            if (ZAEHLER_NR_NEU <> '') then
            begin
              DublettenPruefling := ART + '~' + ZaehlerNummerNeuPreFix + ZAEHLER_NR_NEU;
              lZNN_Dupletten := ZaehlerNummernNeu.find(DublettenPruefling);
              for k := 0 to pred(lZNN_Dupletten.count) do
                if (lZNN_Dupletten[k] <> AUFTRAG_R) then
                begin
                  Log(cINFOText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' RID=' + inttostr(lZNN_Dupletten[k]) +
                    ' ist die "Zählernummer Neu"-Dublette (' + DublettenPruefling + ')', BAUSTELLE_R,
                    Settings.values[cE_TAN]);

                  QS_add('[Q21] Einbauzähler gibt es bereits', sPlausi);
                end;
              lZNN_Dupletten.free;
            end;

            // N1
            if (N1 <> '') and ZaehlerNummernNeuAusN1 then
            begin
              DublettenPruefling := ART + '~' + ZaehlerNummerNeuPreFix + N1;
              lZNN_Dupletten := ZaehlerNummernNeu.find(DublettenPruefling);
              for k := 0 to pred(lZNN_Dupletten.count) do
                if (lZNN_Dupletten[k] <> AUFTRAG_R) then
                begin
                  Log(cINFOText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' RID=' + inttostr(lZNN_Dupletten[k]) +

                    ' ist die "N1"-Dublette (' + DublettenPruefling + ')', BAUSTELLE_R, Settings.values[cE_TAN]);

                  QS_add('[Q21] Einbauzähler gibt es bereits', sPlausi);
                end;
              lZNN_Dupletten.free;
            end;

          end;

        // abschliessende Bewertung
        if not(QS_gut(sPlausi, Settings)) then
        begin
          writePermission := false;
          sQS_kritisch := QS_kritisch(sPlausi, Settings);
          for k := 0 to pred(sQS_kritisch.count) do
            Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' ' + sQS_kritisch[k], BAUSTELLE_R,
              Settings.values[cE_TAN]);
          sQS_kritisch.free;
          if (FailL.indexof(AUFTRAG_R) = -1) then
            FailL.add(AUFTRAG_R);
        end;

        if writePermission then
          // ist MaxAnzahl überschritten?
          if (Stat_Erfolg.count + Stat_Vorgezogen.count + Stat_Unmoeglich.count >= MaxAnzahl) then
          begin
            writePermission := false;
            Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' ' + ' Limit (' + inttostr(MaxAnzahl) +
              ') der Meldungen ist erreicht!', BAUSTELLE_R, Settings.values[cE_TAN]);
            if (FailL.indexof(AUFTRAG_R) = -1) then
              FailL.add(AUFTRAG_R);
          end;

        // Bild dazumachen!
        if writePermission and AuchMitFoto then
        begin
          FilesCandidates := TStringList.create;

          _FotoSpalten := noblank(FotoSpalten);
          while (_FotoSpalten <> '') do
          begin
            FotoSpalte := nextp(_FotoSpalten);

            ActColIndex := Header.indexof(FotoSpalte);
            if (ActColIndex <> -1) then
            begin

              FotoFName := nextp(ActColumn[ActColIndex], ',', 0);
              if (FotoFName <> '') then
              begin
                repeat

                  if not(FileExists(FotoPath + e_r_BaustellenPfad(Settings) + '\' + FotoFName)) then
                  begin
                    FotoFName := e_r_FotoName(AUFTRAG_R, FotoSpalte);

                    // Rückwärtiges Ändern
                    ActColumn[ActColIndex] := FotoFName;
                    FotoFName := nextp(FotoFName, ',', 0);
                  end;

                  if not(FileExists(FotoPath + e_r_BaustellenPfad(Settings) + '\' + FotoFName)) then
                  begin
                    writePermission := false;
                    Log(cERRORText + ' (RID=' + inttostr(AUFTRAG_R) + ')' + ' ' + FotoSpalte + '-Bild "' + FotoFName +
                      '" fehlt!', BAUSTELLE_R, Settings.values[cE_TAN]);
                    if (FailL.indexof(AUFTRAG_R) = -1) then
                      FailL.add(AUFTRAG_R);
                    break;
                  end;

                  // Ev. Dublette anlegen (RWE-Problem!)
                  _FotoFName := StrFilter(FotoFName, 'öäüÖÄÜß', true);
                  if not(FileExists(FotoPath + e_r_BaustellenPfad(Settings) + '\' + _FotoFName)) then
                    FileCopy(FotoPath + e_r_BaustellenPfad(Settings) + '\' + FotoFName,
                      FotoPath + e_r_BaustellenPfad(Settings) + '\' + _FotoFName);

                  // Erfolg! Foto muss mit ins ZIP
                  FilesCandidates.add(FotoPath + e_r_BaustellenPfad(Settings) + '\' + _FotoFName);

                until true;
              end;
            end;
          end;

          // Nur bei Fehlerfreiheit alles dazu
          if writePermission then
            Files.AddStrings(FilesCandidates);
          FilesCandidates.free;

        end;

        if writePermission then
        begin
          // rausschreiben der Daten!
          WriteLine;

          if zweizeilig then
          begin

            // Zählwerke auf "2" setzen
            ActColIndex := Header.indexof(Zaehlwerk);
            if (ActColIndex <> -1) then
              SetCell(ActColIndex, '2');
            if (Settings.values[cE_ZaehlwerkNeu] <> '') then
            begin
              ActColIndex := Header.indexof(Settings.values[cE_ZaehlwerkNeu]);
              if (ActColIndex <> -1) then
                SetCell(ActColIndex, '2');
            end;
            ActColIndex := Header.indexof('ZaehlwerkMitArt');
            SetCell(ActColIndex, ART + '-2');

            ActColIndex := Header.indexof('ZaehlerStandAlt');
            if (ActColIndex <> -1) then
              SetCell(ActColIndex, NA);

            ActColIndex := Header.indexof('ZaehlerStandNeu');
            if (ActColIndex <> -1) then
              SetCell(ActColIndex, NN);

            // Jetzt noch die "Intern-Namen.2" einfügen!
            for k := 0 to pred(HeaderFromIntern.count) do
            begin
              HeaderName := HeaderFromIntern[k];
              ActColIndex := Header.indexof(HeaderName);
              if (ActColIndex <> -1) then
              begin
                ActValue := KommaCheck(INTERN_INFO.values[HeaderName + '.2']);
                if (ActValue <> '') then
                  SetCell(ActColIndex, ActValue);
              end;
            end;

            WriteLine;

          end;

          case vSTATUS of
            ctvErfolg, ctvErfolgGemeldet:
              Stat_Erfolg.add(AUFTRAG_R);
            ctvVorgezogen, ctvVorgezogenGemeldet:
              Stat_Vorgezogen.add(AUFTRAG_R);
            ctvUnmoeglich, ctvUnmoeglichGemeldet:
              Stat_Unmoeglich.add(AUFTRAG_R);
          end;

        end;

        Log(
          { } inttostr(succ(n)) + '/' + inttostr(RIDs.count) + ' ' +
          { } booltostr(zweizeilig, 'x2 ', '') +
          { } '(' + inttostr(integer(RIDs[n])) + ' : ' + booltostr(FailL.indexof(RIDs[n]) = -1) + ')');

      end; // for RIDS..

      HeaderDefault.free;
      for n := 0 to pred(Header.count) do
        TgpIntegerList(Header.objects[n]).free;
      Header.free;
      HeaderFromIntern.free;
      HeaderSuppress.free;
      HeaderTextFormat.free;
      INTERN_INFO.free;
      cINTERNINFO.free;

      // Ausgabe in die neue Datei
      OutFName :=
      { } cAuftragErgebnisPath +
      { } e_r_BaustellenPfad(Settings) + '\' +
      { } noblank(Settings.values[cE_Praefix]) +
      { } 'Zaehlerdaten_' + Settings.values[cE_TAN] +
      { } noblank(Settings.values[cE_Postfix]) + '.xls';

      CheckCreateDir(cAuftragErgebnisPath + e_r_BaustellenPfad(Settings));
      FileDelete(OutFName);
      save(OutFName);
      if (Settings.values[cE_OhneStandardXLS] <> cINI_Activate) then
        Files.add(OutFName);

      repeat

        // Oc noch rufen, um wieder eine csv draus zu machen?
        if (Settings.values[cE_AuchAlsCSV] = cINI_Activate) and (Settings.values[cE_AuchAlsXLS] <> cINI_Activate) then
        begin

          // Bestimmen des Konvertierungs-Modus
          if FileExists(
            { } cAuftragErgebnisPath +
            { } e_r_BaustellenPfad(Settings) + '\' +
            { } cFixedFloodFName) then
            n := Content_Mode_xls2Flood
          else
            n := Content_Mode_xls2csv;

          //
          Oc_Bericht := TStringList.create;
          if not(doConversion(n, OutFName, Oc_Bericht)) then
          begin
            inc(ErrorCount);
            Log(cERRORText + cOc_FehlerMeldung, BAUSTELLE_R);
            Log(Oc_Bericht, BAUSTELLE_R);
            break;
          end
          else
          begin

            // Normales Oc Ergebnis
            Files.add(OutFName + '.csv');

            // weitere Dateien dazu
            Files.add(copy(OutFName, 1, length(OutFName) - 4) + '-*.xls');
          end;
          Oc_Bericht.free;
        end;

        // Oc noch rufen, um eine KK22 draus zu machen?
        if (Settings.values[cE_AuchAlsKK22] = cINI_Activate) and (pos('.unmoeglich', OutFName) = 0) then
        begin
          Oc_Bericht := TStringList.create;
          if not(doConversion(Content_Mode_KK22, OutFName, Oc_Bericht)) then
          begin
            inc(ErrorCount);
            Log(cERRORText + cOc_FehlerMeldung, BAUSTELLE_R);
            Log(Oc_Bericht, BAUSTELLE_R);
            break;
          end
          else
          begin
            // Gelungenes Oc
            Files.add(OutFName + '.txt');
            for n := 0 to pred(Oc_Bericht.count) do
              if (pos('(RID=', Oc_Bericht[n]) > 0) then
              begin
                FAIL_R := StrToIntDef(ExtractSegmentBetween(Oc_Bericht[n], '(RID=', ')'), 0);
                if (FailL.indexof(FAIL_R) = -1) then
                  FailL.add(FAIL_R);
                Log(cERRORText + ' ' + Oc_Bericht[n], BAUSTELLE_R, Settings.values[cE_TAN]);
              end;
          end;
          Oc_Bericht.free;
        end;

        // XML
        if (Settings.values[cE_AuchAlsXML] = cINI_Activate) and (pos('.unmoeglich', OutFName) = 0) then
        begin
          Oc_Bericht := TStringList.create;
          case CheckContent(OutFName) of
            Content_Mode_xls2Argos:
              Oc_Result := doConversion(Content_Mode_xls2Argos, OutFName, Oc_Bericht);
            Content_Mode_xls2ml:
              Oc_Result := doConversion(Content_Mode_xls2ml, OutFName, Oc_Bericht);
          else
            Oc_Result := doConversion(Content_Mode_xls2rwe, OutFName, Oc_Bericht);
          end;
          if not(Oc_Result) then
          begin
            inc(ErrorCount);
            Log(cERRORText + cOc_FehlerMeldung, BAUSTELLE_R);
            Log(Oc_Bericht, BAUSTELLE_R);
            break;
          end
          else
          begin
            Files.add(copy(OutFName, 1, length(OutFName) - 4) + '.xml');
            for n := 0 to pred(Oc_Bericht.count) do
              if (pos('(RID=', Oc_Bericht[n]) > 0) then
              begin
                FAIL_R := StrToIntDef(ExtractSegmentBetween(Oc_Bericht[n], '(RID=', ')'), 0);
                if (FailL.indexof(FAIL_R) = -1) then
                  FailL.add(FAIL_R);
                Log(cERRORText + ' ' + Oc_Bericht[n], BAUSTELLE_R, Settings.values[cE_TAN]);
              end;
          end;
          Oc_Bericht.free;
        end;

        // HTML
        if (Settings.values[cE_AuchAlsHTML] = cINI_Activate) and (pos('.unmoeglich', OutFName) = 0) then
        begin
          Oc_Bericht := TStringList.create;
          Oc_Result := doConversion(Content_Mode_xls2html, OutFName, Oc_Bericht);
          if not(Oc_Result) then
          begin
            inc(ErrorCount);
            Log(cERRORText + cOc_FehlerMeldung, BAUSTELLE_R);
            Log(Oc_Bericht, BAUSTELLE_R);
            break;
          end
          else
          begin
            for n := 0 to pred(Oc_Bericht.count) do
            begin
              if (pos('INFO: save ', Oc_Bericht[n]) > 0) then
              begin
                OutFName :=
                { } cAuftragErgebnisPath +
                { } e_r_BaustellenPfad(Settings) + '\' +
                { } nextp(Oc_Bericht[n], 'INFO: save ', 1);
                Files.add(OutFName);
                if (Settings.values[cE_AuchAlsPDF] = cINI_Activate) then
                begin
                  WinExec32AndWait(
                    { } '"' + 'C:\Program Files (x86)\wkhtmltopdf\bin\wkhtmltopdf.exe ' + '" ' +
                    // ggf. "--zoom 0.0..9.9" verwenden
                    { } '"' + OutFName + '"' + ' ' +
                    { } '"' + OutFName + '.pdf' + '"',
                    { } SW_SHOWDEFAULT);

                  Files.add(OutFName + '.pdf');

                end;
              end;
              if (pos('(RID=', Oc_Bericht[n]) > 0) then
              begin
                FAIL_R := StrToIntDef(ExtractSegmentBetween(Oc_Bericht[n], '(RID=', ')'), 0);
                if (FailL.indexof(FAIL_R) = -1) then
                  FailL.add(FAIL_R);
                Log(cERRORText + ' ' + Oc_Bericht[n], BAUSTELLE_R, Settings.values[cE_TAN]);
              end;
              application.processmessages;
            end;
          end;
          Oc_Bericht.free;
        end;

        // Vorlage.xls
        if (Settings.values[cE_AuchAlsXLS] = cINI_Activate) and
          not((Settings.values[cE_AuchAlsXLSunmoeglich] = cIni_DeActivate) and (pos('.unmoeglich', OutFName) > 0)) then
        begin

          if (pos('.unmoeglich', OutFName) > 0) then
            p_XLS_VorlageFName := 'Vorlage.unmoeglich.xls'
          else
            p_XLS_VorlageFName := '';

          Oc_Bericht := TStringList.create;
          if not(doConversion(Content_Mode_xls2xls, OutFName, Oc_Bericht)) then
          begin
            inc(ErrorCount);
            Log(cERRORText + cOc_FehlerMeldung, BAUSTELLE_R);
            Log(Oc_Bericht, BAUSTELLE_R);
            break;
          end
          else
          begin
            Files.add(conversionOutFName);
          end;
          Oc_Bericht.free;

          // die Konvertierte auch als CSV?
          if (Settings.values[cE_AuchAlsCSV] = cINI_Activate) then
          begin
            Oc_Bericht := TStringList.create;
            if not(doConversion(Content_Mode_xls2csv, conversionOutFName, Oc_Bericht)) then
            begin
              inc(ErrorCount);
              Log(cERRORText + cOc_FehlerMeldung, BAUSTELLE_R);
              Log(Oc_Bericht, BAUSTELLE_R);
              break;
            end
            else
            begin
              Files.add(conversionOutFName);
            end;
            Oc_Bericht.free;
          end;

        end;

        // ARGOS
        if (Settings.values[cE_AuchAlsARGOS] = cINI_Activate) then
        begin
          Oc_Bericht := TStringList.create;
          if not(doConversion(Content_Mode_ARGOS, OutFName, Oc_Bericht)) then
          begin
            inc(ErrorCount);
            Log(cERRORText + cOc_FehlerMeldung, BAUSTELLE_R);
            Log(Oc_Bericht, BAUSTELLE_R);
            break;
          end
          else
          begin
            Files.add(conversionOutFName);
            for n := 0 to pred(Oc_Bericht.count) do
              if (pos('(RID=', Oc_Bericht[n]) > 0) then
              begin
                FAIL_R := StrToIntDef(ExtractSegmentBetween(Oc_Bericht[n], '(RID=', ')'), 0);
                if (FailL.indexof(FAIL_R) = -1) then
                  FailL.add(FAIL_R);
                Log(cERRORText + ' ' + Oc_Bericht[n], BAUSTELLE_R, Settings.values[cE_TAN]);
              end;
          end;
          Oc_Bericht.free;
        end;

        // IDOC
        if (Settings.values[cE_AuchAlsIDOC] = cINI_Activate) and (pos('.unmoeglich', OutFName) = 0) then
        begin
          Oc_Bericht := TStringList.create;
          if not(doConversion(Content_Mode_xls2idoc, OutFName, Oc_Bericht)) then
          begin
            inc(ErrorCount);
            Log(cERRORText + cOc_FehlerMeldung, BAUSTELLE_R);
            Log(Oc_Bericht, BAUSTELLE_R);
            break;
          end
          else
          begin
            Files.add(copy(OutFName, 1, length(OutFName) - 4) + '.????.idoc');
            Files.add(ExtractFilePath(OutFName) + 'z1isu_meau_' + Settings.values[cE_TAN] + '-*');
            for n := 0 to pred(Oc_Bericht.count) do
              if (pos('(RID=', Oc_Bericht[n]) > 0) then
              begin
                FAIL_R := StrToIntDef(ExtractSegmentBetween(Oc_Bericht[n], '(RID=', ')'), 0);
                if (FailL.indexof(FAIL_R) = -1) then
                  FailL.add(FAIL_R);
                Log(cERRORText + ' ' + Oc_Bericht[n], BAUSTELLE_R, Settings.values[cE_TAN]);
              end;
          end;
          Oc_Bericht.free;
        end;

      until true;
    end;
  except
    on e: exception do
    begin
      inc(ErrorCount);
      Log(cERRORText + ' ' + e.message, BAUSTELLE_R);
    end;
  end;
  p_XLS_VorlageFName := '';

  LinesL.free;
  ProtokollFeldNamen.free;
  ProtokollWerte.free;
  FreieResourcen.free;
  Sparten.free;
  ActColumn.free;
  MussFelder.free;
  RauteFelder.free;
  OhneInhaltFelder.free;
  ZaehlerNummernNeu.free;

  ProgressBar1.position := 0;
  result := (ErrorCount = 0);
end;

function TFormAuftragErgebnis.UploadNewTANS(BAUSTELLE_R: integer; ManuellInitiiert: boolean): boolean;
var
  qMail: TIB_Query;
  eMailParameter: TStringList;
  PERSON_R: integer;
  VORLAGE_R: integer;
  TAN: integer;
  Settings: TStringList;
  FTP_UploadFName: string;
  ErrorCount: integer;
  n: integer;
  BaustelleKurz: string;

  // upload einzelner Dateien
  FTP_UploadFiles: TStringList;
  FTP_UploadMasks: TStringList;
  FTP_DeleteLocal: TStringList;
  iSourcePathAdditionalFiles: string;
  CloseLater: boolean;

  // Commit - Code
  CommitL: TgpIntegerList;

  procedure doCommit;
  var
    dAUFTRAG: TIB_DSQL;
    n: integer;
    TransaktionsName: string;
  begin

    // Erfolg in die Auftragsdaten eintragen: "COMMIT!"
    dAUFTRAG := DataModuleDatenbank.nDSQL;
    with dAUFTRAG do
    begin
      sql.add('update AUFTRAG set');
      sql.add(' EXPORT_TAN = ' + inttostr(TAN));
      sql.add('where RID = :CROSSREF');
      prepare;
      for n := 0 to pred(CommitL.count) do
      begin
        ParamByName('CROSSREF').AsInteger := integer(CommitL[n]);
        execute;
      end;
    end;
    dAUFTRAG.free;

    // Eine Abschluss-Transaktion durchführen
    if (Settings.values[cE_AbschlussTransaktion] <> '') then
    begin
      TransaktionsName := Settings.values[cE_AbschlussTransaktion];
      while (TransaktionsName <> '') do
        Funktionen_Transaktion.Dispatch(nextp(TransaktionsName), CommitL);
    end;

  end;

  procedure doFTP;
  var
    n: integer;
    NativeFileName: string;
    Local_FSize: int64;
    FTP_FSize: int64;
    qTICKET: TIB_Query;
    FTP_Infos: TStringList;
  begin

    repeat

      // Dateien hochladen
      for n := 0 to pred(FTP_UploadFiles.count) do
      begin

        Local_FSize := FSize(FTP_UploadFiles[n]);
        NativeFileName := ExtractFileName(FTP_UploadFiles[n]);

        Log('Upload "' + NativeFileName + '" ' + inttostr(Local_FSize) + ' Byte(s) ...');

        if not(SolidPut(
          { } IdFTP1,
          { } FTP_UploadFiles[n],
          { } Settings.values[cE_FTPVerzeichnis],
          { } NativeFileName)) then
        begin

          // FTP - ERROR
          inc(ErrorCount);
          Log(cERRORText + ' ' + SolidFTP_LastError);

          // FTP - Ticket erstellen
          qTICKET := DataModuleDatenbank.nQuery;
          FTP_Infos := TStringList.create;

          with FTP_Infos do
          begin
            values[cE_FTPHOST] := IdFTP1.Host;
            values[cE_FTPUSER] := IdFTP1.Username;
            values[cE_FTPPASSWORD] := IdFTP1.Password;
            values[cE_FTPVerzeichnis] := Settings.values[cE_FTPVerzeichnis];
            values['Datei'] := FTP_UploadFiles[n];
            values['NachUploadLöschen'] := bool2cO(FTP_DeleteLocal.indexof(FTP_UploadFiles[n]) <> -1);
            values['Fehler'] := SolidFTP_LastError;
          end;

          with qTICKET do
          begin
            // ein Ticket, durch das System erzeugt
            sql.add('select * from TICKET for update');
            insert;
            FieldByName('RID').AsInteger := 0;
            FieldByName('ART').AsInteger := eT_FTP;
            FieldByName('INFO').Assign(FTP_Infos);
            post;
          end;

          qTICKET.free;
          FTP_Infos.free;

          break;
        end
        else
        begin

          FTP_FSize := SolidSize(
            { } IdFTP1,
            { } Settings.values[cE_FTPVerzeichnis],
            { } NativeFileName);

          if (FTP_FSize = Local_FSize) then
          begin
            inc(Stat_meldungen);
            // Nach Erfolg ev. löschen? Nicht bei allen Dateien
            if (FTP_DeleteLocal.indexof(FTP_UploadFiles[n]) <> -1) then
              FileDelete(FTP_UploadFiles[n]);
          end
          else
          begin
            inc(ErrorCount);
            Log(cERRORText + ' Datei "' + FTP_UploadFiles[n] + '" belegt auf der FTP-Ablage ' + inttostr(FTP_FSize) +
              ' Byte(s) - es sollten aber ' + inttostr(Local_FSize) + ' Byte(s) sein');
          end;

        end;
      end;

      // Dateien hochladen über die Alternative CoreFTP
      for n := 0 to pred(FTP_UploadMasks.count) do
        if not(CoreFTP_Up(
          { Profile } nextp(Settings.values[cE_FTPUSER], '\', 0),
          { Mask } nextp(FTP_UploadMasks[n], ';', 0),
          { Path } nextp(FTP_UploadMasks[n], ';', 1))) then
        begin
          // FTP - ERROR
          inc(ErrorCount);
          Log(cERRORText + ' Ursache siehe CoreFTP-' + inttostr(DateGet) + '.log.txt');
          break;
        end;

    until true;
  end;

  function ReportBlock(Erfolgsmeldungen, Unmoeglichmeldungen: boolean): integer;
  // [Anzahl der Meldungen]
  var
    cAUFTRAG: TIB_Cursor;
    _Expected_TAN: integer;
    ExportL: TgpIntegerList;
    FailL: TgpIntegerList;
    FilesUp: TStringList;
    n: integer;
  begin
    result := 0;
    if { } CheckBox5.checked and
    { } (Edit2.Text <> '') and
    { } (pos(',', Edit2.Text) = 0) and
    { } (pos('-', Edit2.Text) = 0) then
      _Expected_TAN := StrToIntDef(Edit2.Text, -1)
    else
      _Expected_TAN := StrToIntDef(Settings.values[cE_EXPORT_TAN], -2) + 1;

    // Es könnte sein, dass bei der Datenquelle= die TAN rasugenommen wurde
    if (_Expected_TAN = -1) then
    begin
      inc(ErrorCount);
      Log(cERRORText + ' Die neue TAN konnte nicht ermittelt werden|Letzte TAN leer oder keine Zahl');
      exit;
    end;

    cAUFTRAG := DataModuleDatenbank.nCursor;
    with cAUFTRAG do
    begin
      sql.add('select RID from AUFTRAG where'); //

      sql.add(' (BAUSTELLE_R=' + Settings.values[cE_Datenquelle] + ') AND');
      // diese Baustelle
      repeat

        if Erfolgsmeldungen and Unmoeglichmeldungen then
        begin
          sql.add(' ((STATUS=' + inttostr(ord(ctsErfolg)) + ') OR ');
          sql.add('  (STATUS=' + inttostr(ord(ctsVorgezogen)) + ') OR ');
          sql.add('  (STATUS=' + inttostr(ord(ctsUnmoeglich)) + ')) AND');
          break;
        end;

        if Erfolgsmeldungen then
        begin
          sql.add(' (STATUS=' + inttostr(ord(ctsErfolg)) + ') and');
          break;
        end;

        sql.add(' ((STATUS=' + inttostr(ord(ctsVorgezogen)) + ') OR');
        sql.add('  (STATUS=' + inttostr(ord(ctsUnmoeglich)) + ')) and');

      until true;

      // Filter-SQL noch dazu ...
      if (Settings.values[cE_SQL_Filter] <> '') then
        sql.add(Settings.values[cE_SQL_Filter]);

      sql.AddStrings(Memo1.lines);
      repeat

        if (AUFTRAG_R >= cRID_FirstValid) then
        begin
          sql.add(' (RID=' + inttostr(AUFTRAG_R) + ')');
          break;
        end;

        if CheckBox5.checked and (Edit2.Text <> '') then
        begin
          if (pos(',', Edit2.Text) > 0) or (pos('-', Edit2.Text) > 0) then
            sql.add(' (EXPORT_TAN in (' + StrRange(Edit2.Text) + '))')
          else
            sql.add(' (EXPORT_TAN=' + Edit2.Text + ')');
          break;
        end;

        sql.add(' ((EXPORT_TAN is null) or (EXPORT_TAN=' + inttostr(_Expected_TAN) + '))')
        // ungemeldet

      until true;
      sql.add('order by');
      sql.add(' ZAEHLER_WECHSEL,RID');

      // übers SQL informieren
      Log(sql);

      // ermittelte Anzahl
      Log('Anz=' + inttostr(RecordCount));

      ApiFirst;
      if not(eof) then
      begin

        // hey! überhaupt was zu melden!
        ExportL := TgpIntegerList.create;
        FailL := TgpIntegerList.create;
        FilesUp := TStringList.create;

        // Vorlauf
        try
          repeat

            TAN := _Expected_TAN;
            Settings.values[cE_TAN] := inttostrN(TAN, cE_TANLENGTH);
            FTP_UploadFName :=
            { } noblank(Settings.values[cE_Praefix]) +
            { } Settings.values[cE_TAN] +
            { } noblank(Settings.values[cE_Postfix]) +
            { } '.zip';

            while not(eof) do
            begin
              // Liste aufbauen
              ExportL.add(FieldByName('RID').AsInteger);
              ApiNext;
            end;

            // Dateien erzeugen
            if not(CreateFiles(Settings, ExportL, FailL, FilesUp)) then
            begin
              inc(ErrorCount);
              break;
            end;

            // Hey, gar nix geschrieben?!
            if (ExportL.count - FailL.count < 1) then
              break;

            // FilesUp aufräumen
            FilesUp.sort;
            RemoveDuplicates(FilesUp);

            if DebugMode then
              FilesUp.SaveToFile(cAuftragErgebnisPath + e_r_BaustellenPfad(Settings) + '\' + 'Files-For-Zip.txt');

            // Zip "FilesUp"
            InfoZIP.zip(FilesUp, cAuftragErgebnisPath + FTP_UploadFName,
              infozip_Password + '=' + Settings.values[cE_ZIPPASSWORD]);

            Stat_Attachments.add(cAuftragErgebnisPath + FTP_UploadFName);

            // ev. FTP-Masken hinzufügen (nur CoreFTP)
            if (Settings.values[cE_AuchAlsIDOC] = cINI_Activate) then
              if (Settings.values[cE_CoreFTP] <> '') then
              begin
                if Erfolgsmeldungen then
                  FTP_UploadMasks.add(cAuftragErgebnisPath + e_r_BaustellenPfad(Settings) + '\' +
                    noblank(Settings.values[cE_Praefix]) + 'Zaehlerdaten_' + Settings.values[cE_TAN] + '.????.idoc' +
                    ';' + '/IDOC');
                if Unmoeglichmeldungen then
                  FTP_UploadMasks.add(cAuftragErgebnisPath + e_r_BaustellenPfad(Settings) + '\' +
                    noblank(Settings.values[cE_Praefix]) + 'Zaehlerdaten_' + Settings.values[cE_TAN] + '*.xls' + ';'
                    + '/TEXT');
              end;

            if (IdFTP1.Host <> '') then
              FTP_UploadFiles.add(cAuftragErgebnisPath + FTP_UploadFName);

          until true;

          result := ExportL.count - FailL.count;
        except
          on e: exception do
          begin
            inc(ErrorCount);
            Log(cERRORText + ' ' + e.message);
          end;
        end;

        Stat_Fail.Append(FailL);

        // die erfolgreichen Mitteilen
        for n := 0 to pred(ExportL.count) do
          if FailL.indexof(ExportL[n]) = -1 then
            CommitL.add(ExportL[n]);

        ExportL.free;
        FailL.free;
        FilesUp.free;

      end;
    end;
    cAUFTRAG.free;
  end;

var
  cBAUSTELLE: TIB_Cursor;

begin
  Button1.enabled := false;
  FormAuftragArbeitsplatz.InvalidateCache_ProblemInfos;
  CloseLater := false;
  if not(active) then
  begin
    Show;
    CloseLater := true;
  end;

  BeginHourGlass;
  Log('[Info]');
  Log('Beginn=' + sTimeStamp);
  Log('Bearbeiter=' + FormBearbeiter.sBearbeiterKurz);
  Log('Manuell=' + bool2cO(ManuellInitiiert));
  Log('pBAUSTELLE_R=' + inttostr(BAUSTELLE_R));
  Log('pAUFTRAG_R=' + inttostr(AUFTRAG_R));
  SolidBeginTransaction;
  HugeTransactionN := e_w_GEN('GEN_EXPORT');

  ErrorCount := 0;
  Settings := TStringList.create;
  eMailParameter := TStringList.create;
  qMail := DataModuleDatenbank.nQuery;
  cBAUSTELLE := DataModuleDatenbank.nCursor;
  FTP_UploadMasks := TStringList.create;
  FTP_UploadFiles := TStringList.create;
  FTP_DeleteLocal := TStringList.create;
  CommitL := TgpIntegerList.create;

  with qMail do
  begin
    sql.add('select * from EMAIL for update');
  end;

  with cBAUSTELLE do
  begin

    // Selektion aufbereiten
    repeat
      sql.add('select NUMMERN_PREFIX, RID, EXPORT_EINSTELLUNGEN');
      sql.add('from BAUSTELLE where');

      if (AUFTRAG_R >= cRID_FirstValid) then
      begin
        sql.add('(RID=(select BAUSTELLE_R from AUFTRAG where RID=' + inttostr(AUFTRAG_R) + '))');
        break;
      end;

      if (BAUSTELLE_R >= cRID_FirstValid) then
      begin
        sql.add('(RID=' + inttostr(BAUSTELLE_R) + ')');
        break;
      end;

      if RadioButton3.checked then
      begin
        sql.add('(RID=' + inttostr(e_r_BaustelleRIDFromKuerzel(ComboBox1.Text)) + ')');
        break;
      end;

      sql.add('(EXPORT_TAN is not null)');

    until true;

    Log(sql);

    Open;
    ApiFirst;
    ProgressBar2.max := RecordCount + 1;
    ProgressBar2.position := 1;
    while not(eof) do
    begin
      BaustelleKurz := FieldByName('NUMMERN_PREFIX').AsString;

      Label3.caption := BaustelleKurz;
      Log('[' + BaustelleKurz + ']');
      Log('Beginn=' + sTimeStamp);

      // init
      FieldByName('EXPORT_EINSTELLUNGEN').AssignTo(Settings);

      // defaults!
      Settings.values[cE_BAUSTELLE_R] := FieldByName('RID').AsString;
      Settings.values[cE_BAUSTELLE] := BaustelleKurz;
      if (Settings.values[cE_Datenquelle] = '') then
        Settings.values[cE_Datenquelle] := Settings.values[cE_BAUSTELLE_R];
      if (Settings.values['Q12'] = '') then
        Settings.values['Q12'] := cQ_erloesend;
      if (StrToIntDef(Settings.values[cE_Datenquelle], cRID_Null) < cRID_FirstValid) then
        Settings.values[cE_Datenquelle] := inttostr(e_r_BaustelleRIDFromKuerzel(Settings.values[cE_Datenquelle]));
      MaxAnzahl := StrToIntDef(Settings.values[cE_MaxperLoad], MaxInt);

      // die aktuelle Export-TAN ermitteln
      Settings.values[cE_EXPORT_TAN] := e_r_sqls(
        { } 'select EXPORT_TAN from BAUSTELLE ' +
        { } 'where RID=' + Settings.values[cE_Datenquelle]);

      Log(Settings);

      repeat

        if not(ManuellInitiiert) then
          if (Settings.values[cE_Wochentage] <> '') then
            if (pos(WeekDayS(DateGet), Settings.values[cE_Wochentage]) = 0) then
            begin
              Log(
                { } cWARNINGText + ' ' + BaustelleKurz + ': ' +
                { } 'Heute nicht, ' +
                { } 'da ∉ [' + Settings.values[cE_Wochentage] + ']!');
              break;
            end;

        // Init
        SolidFTP_Retries := 200;
        TAN := 0;
        ClearStat;
        eMailParameter.clear;
        FTP_UploadFiles.clear;
        FTP_UploadMasks.clear;
        FTP_DeleteLocal.clear;
        CommitL.clear;

        SolidInit(IdFTP1);
        with IdFTP1 do
        begin
          if connected then
          begin
            try
              Disconnect;
            Except
              // don't handle this!
            end;
          end;
          if CheckBox1.checked then
          begin
            Host := cFTP_Host;
            Username := cFTP_UserName;
            Password := cFTP_Password;
            Settings.values[cE_FTPVerzeichnis] := '';
          end
          else
          begin
            Host := Settings.values[cE_FTPHOST];
            Username := nextp(Settings.values[cE_FTPUSER], '\', 0);
            Password := Settings.values[cE_FTPPASSWORD];
          end;

          (* // FTPES
            IdSSLIOHandlerSocketOpenSSL1.PassThrough := false;
            Port := 2001;
            IOHandler := IdSSLIOHandlerSocketOpenSSL1;
            UseTLS := utUseExplicitTLS;
            AUTHCmd := tAuthTLS;
            DataPortProtection := ftpdpsPrivate; // !!! Datenkanal auch verschlüsseln
          *)

          // Prüfung der FTP Daten
          if (Username = '') then
          begin
            Log(cERRORText + ' ' + BaustelleKurz + ':Kein Eintrag in FTPBenutzer=');
            break;
          end;

          if (Host = '') then
            Log(cWARNINGText + ' ' + BaustelleKurz + ':Kein Eintrag in FTPHost=');

          if (Password = '') then
            Log(cWARNINGText + ' ' + BaustelleKurz + ':Kein Eintrag in FTPPassword=');

        end;

        // noch weitere Einzel-Upload Dateien übertragen
        iSourcePathAdditionalFiles := Settings.values[cE_ZusaetzlicheZips];
        if (iSourcePathAdditionalFiles = cINI_Activate) then
          iSourcePathAdditionalFiles := e_r_BaustelleUploadPath(BAUSTELLE_R);

        if (iSourcePathAdditionalFiles <> '') and (IdFTP1.Host <> '') then
        begin
          // zusätzliche Zips ...
          dir(iSourcePathAdditionalFiles + '*.zip', FTP_UploadFiles, false);
          for n := 0 to pred(FTP_UploadFiles.count) do
          begin
            FTP_UploadFiles[n] :=
            { } iSourcePathAdditionalFiles +
            { } FTP_UploadFiles[n];
            FTP_DeleteLocal.add(FTP_UploadFiles[n]);

            // Das funktioniert nicht, da die Dateien gelöscht werden ...
            // Stat_Attachments.add(FTP_UploadFiles[n]);
          end;
        end;

        // Eine Kopie-Baustelle?
        if (Settings.values[cE_KopieVon] <> '') then
        begin
          if not e_w_BaustelleKopie(
            { } StrToIntDef(
            { } Settings.values[cE_Datenquelle],
            { } cRID_Null)) then
            inc(ErrorCount);
        end;

        // neue Erfolgs-TANS übergeben
        if EinzelMeldeErlaubnis then
        begin
          if (Settings.values[cE_EineDatei] = cINI_Activate) then
          begin
            inc(Stat_meldungen, ReportBlock(true, true));
          end
          else
          begin
            inc(Stat_meldungen, ReportBlock(true, false));
            if (ErrorCount = 0) then
            begin
              Settings.values[cE_Postfix] := '.unmoeglich';
              inc(Stat_meldungen, ReportBlock(false, true));
            end;
          end;
        end;

        if (Stat_nichtEFRE > 0) then
        begin
          Stat_FehlendeResourcen.SaveToFile(nichtEFREFName(Settings));
          Settings.values[cE_nichtEFRE] := nichtEFREFName(Settings);
        end;

        if (ErrorCount = 0) then
          doFTP;

        // Erfolg in die einzelnen Datensätze eintragen
        if (ErrorCount = 0) and (CommitL.count > 0) then
          doCommit;

        if (TAN > 0) and (ErrorCount = 0) and (Stat_meldungen > 0) then
        begin

          // Erfolg in die Quell-Baustelle eintragen
          if not(CheckBox3.checked) then
          begin
            e_x_sql(
              { } 'update BAUSTELLE set ' +
              { } 'EXPORT_TAN=' + inttostr(TAN) + ' ' +
              { } 'where RID=' + Settings.values[cE_Datenquelle]);
          end;

        end;

        // Mail verschicken
        if (Settings.values[cE_eMail] <> '') and not(CheckBox1.checked) then
          if (ErrorCount = 0) then
            if (Stat_meldungen > 0) or (Stat_nichtEFRE > 0) then
            begin

              PERSON_R := StrToIntDef(Settings.values[cE_eMail], -1);
              if not(e_r_IsRID('PERSON_R', PERSON_R)) then
              begin
                Log(cWARNINGText + ' ' + BaustelleKurz + ':' + cE_eMail + ' ungültig');
                PERSON_R := cRID_Null;
              end;
              VORLAGE_R := e_r_VorlageMail(cMailvorlage_Ergebnis);

              if (PERSON_R >= cRID_FirstValid) and (VORLAGE_R >= cRID_FirstValid) then
              begin

                // informative Werte
                with eMailParameter do
                begin
                  values['ERFOLGREICH'] := inttostr(Stat_Erfolg.count);
                  values['VORGEZOGEN'] := inttostr(Stat_Vorgezogen.count);
                  values['UNMOEGLICH'] := inttostr(Stat_Unmoeglich.count);
                  values['NICHT_EFRE'] := inttostr(Stat_nichtEFRE);

                  values['ERFOLGREICH_GEMELDET'] := inttostr(Stat_Erfolg.countReducedBy(Stat_Fail));
                  values['VORGEZOGEN_GEMELDET'] := inttostr(Stat_Vorgezogen.countReducedBy(Stat_Fail));
                  values['UNMOEGLICH_GEMELDET'] := inttostr(Stat_Unmoeglich.countReducedBy(Stat_Fail));

                  values['ERFOLGREICH_FEHLER'] := inttostr(Stat_Erfolg.count - Stat_Erfolg.countReducedBy(Stat_Fail));
                  values['VORGEZOGEN_FEHLER'] :=
                    inttostr(Stat_Vorgezogen.count - Stat_Vorgezogen.countReducedBy(Stat_Fail));
                  values['UNMOEGLICH_FEHLER'] :=
                    inttostr(Stat_Unmoeglich.count - Stat_Unmoeglich.countReducedBy(Stat_Fail));

                  values['FEHLER'] := inttostr(Stat_Fail.count);
                  values['ABLAGE'] := nextp(Settings.values[cE_FTPUSER], '\', 0);
                  values['TAN'] := Settings.values[cE_TAN];
                  values['BAUSTELLE'] := Settings.values[cE_BAUSTELLE];

                end;

                // Datei-Anlagen hinzufügen
                if (Settings.values[cE_ZipAnlage] = cINI_Activate) then
                  for n := 0 to pred(Stat_Attachments.count) do
                    eMailParameter.add('Anlage:' + Stat_Attachments[n]);

                // Fehler-Anlagen hinzufügen
                if (Settings.values[cE_nichtEFRE] <> '') then
                  eMailParameter.add('Anlage:' + Settings.values[cE_nichtEFRE]);

                // Sendung beantragen
                with qMail do
                begin
                  insert;
                  FieldByName('RID').AsInteger := cRID_AutoInc;
                  FieldByName('PERSON_R').AsInteger := PERSON_R;
                  FieldByName('VORLAGE_R').AsInteger := VORLAGE_R;
                  FieldByName('NACHRICHT').Assign(eMailParameter);
                  post;
                end;

              end;
            end;

        // FTP Verbindung beenden
        with IdFTP1 do
        begin
          if connected then
          begin
            try
              Disconnect;
            Except
              // do not handle this
            end;
          end;
        end;

      until true;
      ApiNext;

      Log('Ende=' + sTimeStamp);

      // qBAUSTELLE
      application.processmessages;
      ProgressBar2.position := ProgressBar2.position + 1;
    end;
    Log('Ende=' + sTimeStamp);
  end;

  cBAUSTELLE.free;
  qMail.free;
  eMailParameter.free;
  Settings.free;
  FTP_UploadMasks.free;
  FTP_UploadFiles.free;
  FTP_DeleteLocal.free;
  CommitL.free;

  result := (ErrorCount = 0);
  ProgressBar2.position := 0;
  SetDefaults(false);
  SolidEndTransaction;
  Button1.enabled := true;
  EndHourGlass;
  if result and CloseLater then
    close;
end;

procedure TFormAuftragErgebnis.Button1Click(Sender: TObject);
begin
  if UploadNewTANS(-1, CheckBox6.checked) then
    close;
end;

procedure TFormAuftragErgebnis.Log(s: string; BAUSTELLE_R: integer = 0; TAN: string = '');
begin
  if (BAUSTELLE_R > 0) then
    s := s + ' ' + e_r_BaustelleKuerzel(BAUSTELLE_R);
  if (TAN <> '') then
    s := s + ' ' + TAN;
  ListBox1.items.add(s);
  ListBox1.itemindex := pred(ListBox1.items.count);
  application.processmessages;
  AppendStringsToFile(s, DiagnosePath + 'Export_' + inttostrN(HugeTransactionN, 6) + '.csv');
end;

procedure TFormAuftragErgebnis.Log(s: TStrings; BAUSTELLE_R: integer = 0; TAN: string = '');
var
  n: integer;
begin
  for n := 0 to pred(s.count) do
  begin
    if (pos(cE_ZIPPASSWORD, s[n]) = 1) then
      continue;
    if (pos(cE_FTPPASSWORD, s[n]) = 1) then
      continue;
    Log(s[n], BAUSTELLE_R, TAN);
  end;
end;

function TFormAuftragErgebnis.nichtEFREFName(Settings: TStringList): string;
begin
  // Datei mit der Liste der nicht einbaufähigen Neugeräte
  result :=
  { } cAuftragErgebnisPath +
  { } e_r_BaustellenPfad(Settings) + '\' +
  { } 'nicht-EFRE-' + Settings.values[cE_BAUSTELLE] + '.csv';
end;

procedure TFormAuftragErgebnis.SetDefaults(ResetRadioButton: boolean);
begin
  if ResetRadioButton then
  begin
    RadioButton1.checked := true;
    Edit1.Text := '';
    Edit1.enabled := false;
    ComboBox1.itemindex := -1;
    ComboBox1.enabled := false;
  end;
  CheckBox1.checked := false;
  CheckBox2.checked := false;
  CheckBox3.checked := false;
  Memo1.lines.clear;
end;

procedure TFormAuftragErgebnis.RadioButton3Click(Sender: TObject);
begin
  ComboBox1.enabled := RadioButton3.checked;
end;

procedure TFormAuftragErgebnis.CheckBox4Click(Sender: TObject);
begin
  Edit1.enabled := CheckBox4.checked;
end;

procedure TFormAuftragErgebnis.CheckBox5Click(Sender: TObject);
begin
  Edit2.enabled := CheckBox5.checked;
  if CheckBox5.checked then
    CheckBox3.checked := true;
end;

procedure TFormAuftragErgebnis.ClearStat;
begin
  if not(assigned(Stat_Erfolg)) then
  begin
    Stat_Erfolg := TgpIntegerList.create;
    Stat_Vorgezogen := TgpIntegerList.create;
    Stat_Unmoeglich := TgpIntegerList.create;
    Stat_Fail := TgpIntegerList.create;
    Stat_FehlendeResourcen := TStringList.create;
  end
  else
  begin
    Stat_Erfolg.clear;
    Stat_Vorgezogen.clear;
    Stat_Unmoeglich.clear;
    Stat_Fail.clear;
    Stat_FehlendeResourcen.clear;
  end;
  Stat_meldungen := 0;
  Stat_nichtEFRE := 0;
  Stat_Attachments.clear;
  Stat_FehlendeResourcen.add('ZaehlerNummerNeu;MaterialNummerAlt;MeldungsTAN;RID;TextZaehlerNummerNeu');
end;

procedure TFormAuftragErgebnis.ComboBox1DropDown(Sender: TObject);
var
  AllTheBaustellen: TStringList;
  cBAUSTELLE: TIB_Cursor;
begin
  BeginHourGlass;
  AllTheBaustellen := TStringList.create;
  cBAUSTELLE := DataModuleDatenbank.nCursor;
  with cBAUSTELLE do
  begin
    sql.add('select NUMMERN_PREFIX from BAUSTELLE where EXPORT_TAN is not null');
    ApiFirst;
    while not(eof) do
    begin
      AllTheBaustellen.add(Fields[0].AsString);
      ApiNext;
    end;
  end;
  cBAUSTELLE.free;
  AllTheBaustellen.sort;
  ComboBox1.items.Assign(AllTheBaustellen);
  AllTheBaustellen.free;
  EndHourGlass;
end;

procedure TFormAuftragErgebnis.Button2Click(Sender: TObject);
begin
  SetDefaults(true);
end;

function TFormAuftragErgebnis.AUFTRAG_R: integer;
begin
  if (Edit1.Text <> '') and CheckBox4.checked then
    result := StrToIntDef(Edit1.Text, 0)
  else
    result := 0;
end;

function TFormAuftragErgebnis.EinzelMeldeErlaubnis: boolean;
begin
  result := not(CheckBox2.checked);
end;

procedure TFormAuftragErgebnis.FormCreate(Sender: TObject);
begin
  Stat_Attachments := TStringList.create;
  IdFTP1 := TIdFTP.create(self);
  with IdFTP1 do
  begin
    OnStatus := IdFTP1Status;
    OnBannerAfterLogin := IdFTP1BannerAfterLogin;
    OnBannerBeforeLogin := IdFTP1BannerBeforeLogin;
  end;
  FlexCelXLS := TXLSFile.create(true);
end;

procedure TFormAuftragErgebnis.IdFTP1BannerAfterLogin(ASender: TObject; const AMsg: string);
begin
  Log(AMsg);
end;

procedure TFormAuftragErgebnis.IdFTP1BannerBeforeLogin(ASender: TObject; const AMsg: string);
begin
  Log(AMsg);
end;

procedure TFormAuftragErgebnis.IdFTP1Status(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
begin
  Log(AStatusText);
end;

procedure TFormAuftragErgebnis.Image2Click(Sender: TObject);
begin
  //
  openShell(cHelpURL + 'Export');
end;

procedure TFormAuftragErgebnis.SpeedButton1Click(Sender: TObject);
begin
  openShell(cAuftragErgebnisPath);
end;

end.
