{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2011  Andreas Filsinger
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
unit ArtikelKasse;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, Keyboard, ExtCtrls,
  Grids, WordIndex, basic32;

const
  cDefault_MaxLines = 10;

type
  TSystemTouchField = record
    t_x, t_y, t_dx, t_dy: integer; // Position der Touch-Fläche
    t_Context: integer; // Gültig in welchem Context
    t_Action: string;
  end;

  TFormArtikelKasse = class(TForm)
    TouchKeyboard1: TTouchKeyboard;
    Edit1: TEdit;
    Label2: TLabel;
    TouchKeyboard2: TTouchKeyboard;
    Timer1: TTimer;
    Image1: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Edit2: TEdit;
    DrawGrid1: TDrawGrid;
    Label1: TLabel;
    Timer2: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; x, y: integer);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: integer;
      Rect: TRect; State: TGridDrawState);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DrawGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private-Deklarationen }
    IsInitialized: boolean;
    IsPrepared: boolean;
    Images: TStringList;
    Touch: TStringList;
    TouchSystem: array of TSystemTouchField;
    AktuellesBild: integer;
    dx, dy: integer; // Touch Rasterung
    Touch_Kontext: integer;

    // Die "Datenbank"
    sARTIKEL: TsTable;
    sBON: TsTable;

    // Kasse-Kontext-Variable
    GemerkterBonInDerAnzeige: string;
    NaechsterSchrittIstStorno: boolean;

    // das Kundendisplay
    sDisplay: TBasicProcessor;
    sDrucker: TBasicProcessor;
    sSchublade: TBasicProcessor;
    sKassenzettel_Seite: TStringList;
    sKassenzettel_Cut: TStringList;

    // Drucker Konstanten, werden aus sPage gelesen
    cLINES_PER_PAGE: integer; // 10 default
    cLINE_LENGTH: integer; // 29 default

    // verschiedene Optionen
    oTine: boolean; // sofortiges Drücken von "Bar" nach gegeben!

    // interne Funktionen
    procedure ZeitAnzeigen;
    procedure setFolie(FolieIndex: integer);

    // Touch Funktionen
    procedure Settings;
    procedure CloseKasse;
    procedure FreieEingabe(Sichtbar: boolean);
    procedure ArtikelTouch(ARTIKEL_R: integer);
    procedure SystemTouch(sAction: string);

    // Bon Funktionen
    procedure Bon_ClearLastLine;
    procedure Bon_ClearActLine;
    procedure Bon_Calculate;
    procedure Bon_Storno;
    procedure Bon_Restore;
    procedure Bon_Anzeigen;
    procedure Bon_Buchen;
    procedure Bon_Drucken;

    // Abschluss-Funktionen
    procedure Sturz_Drucken;

  public
    { Public-Deklarationen }
    property Folie: integer read AktuellesBild write setFolie;
    procedure Prepare;
  end;

var
  FormArtikelKasse: TFormArtikelKasse;

implementation

uses
  anfix32, globals, ArtikelPOS,
  dbOrgaMon, math, html,
  GUIHelp, wanfix32, Geld,
  Datenbank, IB_Components,
  Funktionen_Basis,
  Funktionen_Beleg,
  BaseUpdate, Tagesabschluss,
  Bearbeiter, Auswertung;

{$R *.dfm}

function AlsPreis(s: string): string;
begin
  result := s;
  if pos(',', result) = 1 then
    result := '0' + result;
  if pos('-,', result) = 1 then
    result := '-0' + copy(result, 2, MaxInt);
  result := format('%.2f', [StrToDoubleDef(result, 0)]);
end;

procedure TFormArtikelKasse.ArtikelTouch(ARTIKEL_R: integer);
var
  ArtikelRow: integer;
  BonRow: integer;
  Anzahl: integer;
begin
  //
  with sARTIKEL do
  begin
    ArtikelRow := locate(0, inttostr(ARTIKEL_R));
    if (ArtikelRow <> -1) then
    begin
      (*
        ShowMessage(
        { } readcell(r, 1) + #13 +
        { } readcell(r, 2) + ' €' + #13 +
        { } readcell(r, 3) + ' %' + #13)
      *)

      // Ermitteln der Anzahl
      repeat
        Anzahl := 1;
        if Edit1.Text = '' then
          break;
        if Edit1.Text = '-' then
        begin
          Anzahl := -1;
          break;
        end;
        Anzahl := StrToIntDef(Edit1.Text, 1);

      until true;
      Edit1.Text := '';

      with sBON do
      begin
        BonRow := sBON.locate('RID', inttostr(ARTIKEL_R));
        if (BonRow <> -1) then
        begin

          // Erhöhen der Anzahl
          writeCell(BonRow, 'ANZAHL', inttostr(

            StrToIntDef(readCell(BonRow, 'ANZAHL'), 0) + Anzahl));
        end
        else
        begin
          addRow;
          BonRow := RowCount;
          writeCell(BonRow, 'ANZAHL', inttostr(Anzahl));
          writeCell(BonRow, 'RID', sARTIKEL.readCell(ArtikelRow, 'RID'));
          writeCell(BonRow, 'TITEL', sARTIKEL.readCell(ArtikelRow, 'TITEL'));
          writeCell(BonRow, 'EURO', sARTIKEL.readCell(ArtikelRow, 'EURO'));
          writeCell(BonRow, 'SATZ', sARTIKEL.readCell(ArtikelRow, 'SATZ'));
          DrawGrid1.RowCount := DrawGrid1.RowCount + 1;

        end;

        DrawGrid1.Refresh;
        Bon_Calculate;
        SecureSetRow(DrawGrid1, pred(BonRow));
        Edit1.SetFocus;
        TouchKeyboard2.enabled := true;

      end;
    end;
  end;
end;

procedure TFormArtikelKasse.Bon_Anzeigen;
begin
  DrawGrid1.RowCount := sBON.RowCount;
  DrawGrid1.Refresh;
  Bon_Calculate;
end;

procedure TFormArtikelKasse.Bon_Buchen;
var
  BonFName: string;
  BELEG_R: integer;
  sBeleg: TStringList;
begin
  BeginHourGlass;

  // Erzeugen (Reservieren) einer neuen Belegnummer
  BELEG_R := e_w_GEN('BELEG_GID');

  // Speichern des Bon
  BonFName := cBON_Bon + RIDasStr(BELEG_R) + '.csv';
  sBON.SaveToFile(
    { # } KassePath +
    { # } BonFName);

  // Speichern der Umgebungsdaten
  sBeleg := TStringList.Create;
  sBeleg.Values[cBON_Beleg_Datum] := Datum10;
  sBeleg.Values[cBON_Beleg_Uhr] := Uhr;
  sBeleg.Values[cBON_Beleg_Bearbeiter] := inttostr(sBearbeiter);
  sBeleg.Values[cBON_Beleg_Gegeben] := StaticText2.Caption;

  BonFName := cBON_Bon + RIDasStr(BELEG_R) + '.ini';
  sBeleg.SaveToFile(KassePath + BonFName);

  EndHourGlass;
end;

procedure TFormArtikelKasse.Bon_Calculate;
var
  Summe: double;
  Gegeben: double;
  a, Anzahl: integer;
  r: integer;
  LezterArtikel: string;
  LetzteAnzahl: string;
  Zeile1, Zeile2a, Zeile2b, Zeile2: string;
begin
  with sBON do
  begin
    Summe := 0.0;
    Anzahl := 0;
    LezterArtikel := '';
    LetzteAnzahl := '';
    Gegeben := StrToDoubleDef(StaticText2.Caption, 0);
    for r := 1 to RowCount do
    begin
      a := StrToIntDef(readCell(r, 'ANZAHL'), 0);
      inc(Anzahl, a);
      Summe := Summe +
      { ANZAHL } a *
      { PREIS } StrToDoubleDef(readCell(r, 'EURO'), 0);
      if (r = RowCount) then
      begin
        LezterArtikel := readCell(r, 'TITEL');
        LetzteAnzahl := inttostr(a) + 'x ' + readCell(r, 'EURO');
      end;
    end;
    StaticText1.Caption := format('%m', [Summe]);
    if isSomeMoney(Gegeben) then
      StaticText3.Caption := format('%m', [Gegeben - Summe])
    else
      StaticText3.Caption := format('%m', [0.0]);
    if (Anzahl <> 0) then
      Label1.Caption := inttostr(Anzahl)
    else
      Label1.Caption := '';

    // Ansteuerung des Kassendisplays
    with sDisplay do
    begin
      if (Summe > 0) then
      begin
        Zeile1 := LezterArtikel;
        Zeile2a := LetzteAnzahl;
        Zeile2b := format('Summe %.2f', [Summe]);
        Zeile2 :=
        { } Zeile2a +
        { } fill(' ', 20 - length(Zeile2a) - length(Zeile2b)) +
        { } Zeile2b;

        bfill(Zeile1, 20);
        bfill(Zeile2, 20);
        WriteVal('OBEN', copy(Zeile1, 1, 20));
        WriteVal('UNTEN', copy(Zeile2, 1, 20));
      end
      else
      begin
        WriteVal('OBEN', '');
        WriteVal('UNTEN', '');
      end;
      ShouldRUN := true;
    end;
  end;
end;

procedure TFormArtikelKasse.Bon_ClearLastLine;
begin
  with sBON do
  begin
    if (RowCount > 0) then
    begin
      DrawGrid1.RowCount := pred(RowCount);
      Del(RowCount);
      DrawGrid1.Refresh;
      Bon_Calculate;
    end;
  end;
end;

procedure TFormArtikelKasse.Bon_ClearActLine;
var
  r: integer;
begin
  with sBON do
  begin
    if (RowCount > 0) then
    begin
      r := succ(DrawGrid1.Row);
      if (DrawGrid1.RowCount > 1) then
        if (DrawGrid1.Row = pred(DrawGrid1.RowCount)) then
          DrawGrid1.Row := pred(DrawGrid1.Row);
      Del(r);
      DrawGrid1.RowCount := RowCount;
      DrawGrid1.Refresh;
      Bon_Calculate;
    end;
  end;
end;

procedure TFormArtikelKasse.Bon_Drucken;
var
  LineCounter: integer;

  procedure NewPage;
  begin
    with sDrucker do
    begin
      add('PAGE');
      addStrings(sKassenzettel_Seite);
      LineCounter := 0;
    end;
  end;

  procedure PRINT(s: String = ''); overload;
  begin
    inc(LineCounter);
    if (LineCounter > cLINES_PER_PAGE) then
      NewPage;
    if (s = '') then
      sDrucker.add('PRINT')
    else
      sDrucker.add('PRINT "' + s + '"');
  end;

  procedure PRINT(a, b: string); overload;
  begin
    a := copy(a, 1, cLINE_LENGTH - length(b));
    PRINT(
      { A.A } a +
      { <- FILL -> } fill(' ', cLINE_LENGTH - length(a) - length(b)) +
      { B.B } b);
  end;

  procedure FLOOD(a: string; b: Char);
  begin
    PRINT(a + fill(b, cLINE_LENGTH - length(a)));
  end;

  function MwStGruppe(Index: integer): string;
  begin
    case Index of
      0:
        result := 'A';
      1:
        result := 'B';
      2:
        result := 'C';
    else
      result := ' ';
    end;
  end;

var
  FesterAnteilIndex: integer;
  sBON: TsTable;
  sBeleg: TStringList;
  MWST: TMwSt;
  n, r: integer;
  BELEG_R: integer;
  Anzahl: integer;
  Einzelpreis, Gesamtpreis: double;
  Gegeben: double;
  MwStIndex: integer;
begin
  BeginHourGlass;

  sBON := TsTable.Create;
  sBeleg := TStringList.Create;
  MWST := TMwSt.Create;

  FesterAnteilIndex := sDrucker.Count;
  BELEG_R := e_r_GEN('BELEG_GID') - StrToIntDef(Edit1.Text, 0);

  if FileExists(KassePath + cBON_Bon + RIDasStr(BELEG_R) + '.ini') then
  begin
    sBON.insertFromFile(KassePath + cBON_Bon + RIDasStr(BELEG_R) + '.csv');
    sBeleg.LoadFromFile(KassePath + cBON_Bon + RIDasStr(BELEG_R) + '.ini');

    with sDrucker do
    begin
      addStrings(sKassenzettel_Seite);

      PRINT(
        { } 'RECHNUNG ' + inttostrN(BELEG_R, 5),
        sBeleg.Values[cBON_Beleg_Datum]);
      PRINT;

      for r := 1 to sBON.RowCount do
      begin
        Anzahl := StrToIntDef(sBON.readCell(r, 'ANZAHL'), 0);
        Einzelpreis := StrToDoubleDef(sBON.readCell(r, 'EURO'), 0.0);
        Gesamtpreis := Anzahl * Einzelpreis;
        MwStIndex := MWST.add(
          { } StrToDoubleDef(sBON.readCell(r, 'SATZ'), 0),
          { } Gesamtpreis);

        if (Anzahl <> 1) and (isSomeMoney(Einzelpreis)) then
          PRINT(format('%dx %m', [
            { } Anzahl,
            { } Einzelpreis]));

        PRINT(
          { } sBON.readCell(r, 'TITEL'),
          { } format('%.2f %s', [
          { } Gesamtpreis,
          { } MwStGruppe(MwStIndex)]));

      end;

      PRINT(fill('-', cLINE_LENGTH));

      MWST.Calc(false);
      for n := 0 to pred(MWST.Count) do
        with MWST.MWST[n] do
        begin
          PRINT(
            { } format('%s Netto', [MwStGruppe(n)]),
            format('%m', [NettoSumme]));

          PRINT(
            { } format('%s %.1f%% MwSt', [
            { } MwStGruppe(n),
            { } Satz]),
            { } format('%m', [MwStSumme]));

        end;
      PRINT(fill('-', cLINE_LENGTH));
      Gegeben := StrToDoubleDef(sBeleg.Values[cBON_Beleg_Gegeben], 0);
      if isSomeMoney(Gegeben) then
      begin
        PRINT('Bar gegeben', format('%m', [Gegeben]));
        PRINT('Zurück', format('%m', [-(Gegeben - MWST.Brutto)]));
        PRINT(fill('-', cLINE_LENGTH));
      end;

      PRINT('Summe', format('%m', [MWST.Brutto]));
      FLOOD(
        { } sBeleg.Values[cBON_Beleg_Bearbeiter],
        { } '=');
      PRINT(
        { } 'Herzlichen Dank!',
        { } sBeleg.Values[cBON_Beleg_Uhr]);
      PRINT;

      // Werbung
      add('FONT "2D-Code2"');
      add('PRINT "http://orgamon.org/index.php5/Kasse3"');

      // Cut-Paper
      addStrings(sKassenzettel_Cut);

      //
      if DebugMode then
        SaveToFile(DiagnosePath + 'BASIC-Kasse.txt');

      WriteVal(cPREDEF_TITEL, 'R#' + inttostrN(BELEG_R, 5));
      RUN;
    end;

  end;

  // Original wieder herstellen
  for n := pred(sDrucker.Count) downto FesterAnteilIndex do
    sDrucker.Delete(n);

  sBON.Free;
  sBeleg.Free;
  MWST.Free;
  EndHourGlass;
end;

procedure TFormArtikelKasse.Sturz_Drucken;
var
  LineCounter: integer;

  procedure NewPage;
  begin
    with sDrucker do
    begin
      add('PAGE');
      addStrings(sKassenzettel_Seite);
      LineCounter := 0;
    end;
  end;

  procedure PRINT(s: String = ''); overload;
  begin
    inc(LineCounter);
    if (LineCounter > cLINES_PER_PAGE) then
      NewPage;
    if (s = '') then
      sDrucker.add('PRINT')
    else
      sDrucker.add('PRINT "' + s + '"');
  end;

  procedure PRINT(a, b: string); overload;
  begin
    a := copy(a, 1, cLINE_LENGTH - length(b));
    PRINT(
      { A.A } a +
      { <- FILL -> } fill(' ', cLINE_LENGTH - length(a) - length(b)) +
      { B.B } b);
  end;

  procedure FLOOD(a: string; b: Char);
  begin
    PRINT(a + fill(b, cLINE_LENGTH - length(a)));
  end;

  function MwStGruppe(Index: integer): string;
  begin
    case Index of
      0:
        result := 'A';
      1:
        result := 'B';
      2:
        result := 'C';
    else
      result := ' ';
    end;
  end;

var
  FesterAnteilIndex: integer;
  sBON: TsTable;
  sBeleg: TStringList;
  sBONs: TStringList;
  MWST: TMwSt;
  n, r: integer;
  BELEG_R: integer;
  Anzahl: integer;
  Einzelpreis, Gesamtpreis: double;
  DATUM: TANFiXDate;
  sDATUM: string;
  cGELIEFERT: TIB_Cursor;
begin
  BeginHourGlass;

  // init
  sBON := TsTable.Create;
  sBeleg := TStringList.Create;
  MWST := TMwSt.Create;
  sBONs := TStringList.Create;
  cGELIEFERT := DataModuleDatenbank.nCursor;
  FesterAnteilIndex := sDrucker.Count;

  // params
  DATUM := Date2long(Edit2.Text);
  if not(DateOK(DATUM)) then
    DATUM := DateGet;
  DATUM := DatePlus(DATUM, StrToIntDef(Edit1.Text, 0));
  sDATUM := long2date(DATUM);
  BELEG_R := e_r_GEN('BELEG_GID');

  // aus den ungebuchten ...
  dir(KassePath + cBON_Bon + '*.ini', sBONs, false);
  for n := 0 to pred(sBONs.Count) do
  begin
    sBeleg.LoadFromFile(KassePath + sBONs[n]);
    if (sBeleg.Values[cBON_Beleg_Datum] = sDATUM) then
      sBON.insertFromFile(KassePath + copy(sBONs[n], 1, length(sBONs[n]) - 4)
        + '.csv');
  end;

  // aus den bereits gebuchten ...
  with cGELIEFERT do
  begin
    sql.add('select');
    sql.add(' SUM(GELIEFERT.MENGE_RECHNUNG * GELIEFERT.PREIS) as GESAMTPREIS,');
    sql.add(' GELIEFERT.MWST');
    sql.add('from');
    sql.add(' GELIEFERT');
    sql.add('join');
    sql.add(' BELEG');
    sql.add('on');
    sql.add(' (BELEG.RID=GELIEFERT.BELEG_R) and');
    sql.add(' (BELEG.ANLAGE between ''' + sDATUM + ' 00:00:00'' and ''' + sDATUM
      + ' 23:59:59'')');
    sql.add('where');
    sql.add(' (GELIEFERT.PREIS is not null) and');
    sql.add(' (GELIEFERT.MENGE_RECHNUNG is not null)');
    sql.add('group by');
    sql.add(' GELIEFERT.MWST');
    ApiFirst;
    while not(eof) do
    begin
      MWST.add(
        { } FieldByName('MWST').AsDouble,
        { } FieldByName('GESAMTPREIS').AsDouble);
      ApiNext;
    end;
  end;

  // Summen auf dem Drucker ausgeben
  with sDrucker do
  begin
    addStrings(sKassenzettel_Seite);

    PRINT(
      { } 'ABSCHLUSS ' + inttostrN(BELEG_R, 5),
      { } sDATUM);
    PRINT;

    for r := 1 to sBON.RowCount do
    begin
      Anzahl := StrToIntDef(sBON.readCell(r, 'ANZAHL'), 0);
      Einzelpreis := StrToDoubleDef(sBON.readCell(r, 'EURO'), 0.0);
      Gesamtpreis := Anzahl * Einzelpreis;
      MWST.add(
        { } StrToDoubleDef(sBON.readCell(r, 'SATZ'), 0),
        { } Gesamtpreis);
    end;

    MWST.Calc(false);
    for n := 0 to pred(MWST.Count) do
      with MWST.MWST[n] do
      begin
        PRINT(
          { } format('%s Netto', [MwStGruppe(n)]), format('%m', [NettoSumme]));

        PRINT(
          { } format('%s %.1f%% MwSt', [
          { } MwStGruppe(n),
          { } Satz]),
          { } format('%m', [MwStSumme]));

      end;
    PRINT(fill('-', cLINE_LENGTH));

    PRINT('Summe', format('%m', [MWST.Brutto]));
    FLOOD(
      { } sBeleg.Values[cBON_Beleg_Bearbeiter],
      { } '=');
    PRINT;

    // Cut-Paper
    addStrings(sKassenzettel_Cut);

    //
    if DebugMode then
      SaveToFile(DiagnosePath + 'BASIC-Kasse.txt');

    WriteVal(cPREDEF_TITEL, 'ABSCHLUSS ' + inttostrN(BELEG_R, 5));
    RUN;
  end;

  // Original wieder herstellen
  for n := pred(sDrucker.Count) downto FesterAnteilIndex do
    sDrucker.Delete(n);

  sBON.Free;
  sBONs.Free;
  sBeleg.Free;
  MWST.Free;
  cGELIEFERT.Free;
  EndHourGlass;
end;

procedure TFormArtikelKasse.Bon_Restore;
var
  sAlleBons: TStringList;
  BonIndex: integer;
begin
  sAlleBons := TStringList.Create;

  // Die Liste aller Bons bestimmen
  dir(KassePath + cBON_gemerkt + '*.csv', sAlleBons, false);
  sAlleBons.Sort;
  repeat

    // Prüfen, ob überhaupt einer im Merkspeicher ist
    if (sAlleBons.Count = 0) then
    begin
      beep;
      break;
    end;

    // Bestimmen, welcher Bon geladen werden soll
    // (der zuletzt abgelegte immer zuerst!)
    if (GemerkterBonInDerAnzeige <> '') then
    begin
      BonIndex := sAlleBons.IndexOf(GemerkterBonInDerAnzeige);
      dec(BonIndex);
      if (BonIndex = -1) then
      begin
        GemerkterBonInDerAnzeige := '';
        Bon_Storno;
        break;
      end;
      GemerkterBonInDerAnzeige := sAlleBons[BonIndex];
    end
    else
    begin
      GemerkterBonInDerAnzeige := sAlleBons[pred(sAlleBons.Count)];
    end;

    // Load
    sBON.Del;
    sBON.insertFromFile(KassePath + GemerkterBonInDerAnzeige);

    // Show
    Bon_Anzeigen;

  until true;
  sAlleBons.Free;
end;

procedure TFormArtikelKasse.Bon_Storno;
begin
  NaechsterSchrittIstStorno := false;

  if (GemerkterBonInDerAnzeige <> '') then
  begin
    FileDelete(KassePath + GemerkterBonInDerAnzeige);
    GemerkterBonInDerAnzeige := '';
  end;

  sBON.Del;
  DrawGrid1.RowCount := 0;
  DrawGrid1.Refresh;
  StaticText2.Caption := format('%m', [0.0]);
  Bon_Calculate;
  Edit1.Text := '';

end;

procedure TFormArtikelKasse.CloseKasse;
begin
  close;
end;

procedure TFormArtikelKasse.DrawGrid1DrawCell(Sender: TObject;
  ACol, ARow: integer; Rect: TRect; State: TGridDrawState);
//
var
  Fokusiert: boolean;
  sText: string;
  Preis: double;
  Anzahl: integer;
  Summe: double;
begin
  if (ARow >= 0) then
    with DrawGrid1.canvas do
    begin

      Fokusiert := (ARow = DrawGrid1.Row);

      if NaechsterSchrittIstStorno then
      begin
        brush.color := clListeGrau;
      end
      else
      begin
        if Fokusiert then
        begin
          // $99FF00
          if sBON.changed then
            brush.color := HTMLColor2TColor($99CCFF)
          else
            brush.color := HTMLColor2TColor($CCFFFF);
        end
        else
        begin
          if odd(ARow) then
          begin
            brush.color := clWhite;
          end
          else
          begin
            brush.color := clListeGrau;
          end;
        end;
      end;

      if (ARow < sBON.RowCount) then
      begin

        case ACol of
          0:
            begin
              // Menge
              sText := sBON.readCell(succ(ARow), 'ANZAHL');
              FillRect(Rect);
              TextRect(Rect, sText, [tfRight]);
            end;
          1:
            begin
              // Text
              TextRect(Rect, Rect.left + 2, Rect.top,
                sBON.readCell(succ(ARow), 'TITEL'));
            end;
          2:
            begin
              // Preis
              Preis := StrToDoubleDef(sBON.readCell(succ(ARow), 'EURO'), 0);
              Anzahl := StrToIntDef(sBON.readCell(succ(ARow), 'ANZAHL'), 0);
              Summe := Preis * Anzahl;
              sText := format('%.2f', [Summe]);

              FillRect(Rect);
              TextRect(Rect, sText, [tfRight]);
            end;
        else
          // dummy Rand Zellen
          FillRect(Rect);
        end;
        if (ACol > 0) then
        begin
          // Tabellenlinien
          pen.color := $A0A0A0;
          MoveTo(Rect.left, Rect.top);
          LineTo(Rect.left, Rect.bottom);
        end;
      end
      else
      begin
        // total leer!

        FillRect(Rect);
      end;
    end;
end;

procedure TFormArtikelKasse.DrawGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if not(Edit2.Visible) then
  begin

    Edit1.SetFocus;
    Edit1KeyPress(Sender, Key);
    Key := #0;
  end;
end;

procedure TFormArtikelKasse.Edit1KeyPress(Sender: TObject; var Key: Char);
var
  BonRow: integer;
begin
  repeat

    if (Key = '/') then
    begin
      if DrawGrid1.RowCount > 0 then
      begin
        if DrawGrid1.Row > 0 then
          SecureSetRow(DrawGrid1, pred(DrawGrid1.Row))
        else
          SecureSetRow(DrawGrid1, pred(DrawGrid1.RowCount));
      end;
      Key := #0;
    end;

    if (Edit1.Text = '') and (Key = #8) then
    begin
      Bon_ClearActLine;
      Key := #0;
      break;
    end;

    if (Key = #13) then
    begin
      if (Edit1.Text = '') then
      begin
        FreieEingabe(not(Edit2.Visible));
        if Edit2.Visible then
        begin
          Edit2.SetFocus;
          TouchKeyboard2.enabled := false;
        end;
      end
      else
      begin
        with sBON do
        begin
          addRow;
          BonRow := RowCount;
          if pos('*', Edit1.Text) > 0 then
          begin
            writeCell(BonRow, 'ANZAHL', nextp(Edit1.Text, '*', 0));
            writeCell(BonRow, 'EURO', AlsPreis(nextp(Edit1.Text, '*', 1)));
          end
          else
          begin
            writeCell(BonRow, 'ANZAHL', '1');
            writeCell(BonRow, 'EURO', AlsPreis(Edit1.Text));
          end;
          if Edit2.Text <> '' then
            writeCell(BonRow, 'TITEL', Edit2.Text)
          else
            writeCell(BonRow, 'TITEL', 'Sonstiges');

          FreieEingabe(false);
          Edit2.Text := '';

          writeCell(BonRow, 'RID', inttostr(cRID_Null));
          writeCell(BonRow, 'SATZ', format('%.1f', [iMwStSatzManuelleArtikel]));
        end;

        DrawGrid1.RowCount := DrawGrid1.RowCount + 1;
        DrawGrid1.Refresh;
        Bon_Calculate;
        SecureSetRow(DrawGrid1, pred(BonRow));
        Edit1.Text := '';
        Edit1.SetFocus;

      end;

      Key := #0;
      break;
    end;

    if (Key = '+') and (pos('*', Edit1.Text) = 1) then
    begin

      // close  Kasse/OrgaMon/System
      if (Edit1.Text = '*0') then
        CloseKasse;
      if (Edit1.Text = '*00') then
        FormBaseUpdate.CloseOrgaMon;
      if (Edit1.Text = '*000') then
        WindowsHerunterfahren;

      // restart Kasse/OrgaMon/System
      if (Edit1.Text = '*1') then
        ShowMessageTimeout('Das funktioniert noch nicht!');
      if (Edit1.Text = '*11') then
      begin
        close;
        FormBaseUpdate.RestartOrgaMon;
      end;
      if (Edit1.Text = '*111') then
        WindowsNeuStarten;

      // Abschluss Kasse/OrgaMon
      if (Edit1.Text = '*2') then
      begin
        BeginHourGlass;
        close;
        Application.ProcessMessages;
        e_x_BelegAusPOS;
        EndHourGlass;
        Application.ProcessMessages;
        FormAuswertung.show;
      end;
      if (Edit1.Text = '*22') then
      begin
        close;
        FormTagesabschluss.Tagesabschluss;
      end;

      // Einstellungen
      if (Edit1.Text = '*3') then
        Settings;

      Edit1.Text := '';
      Key := #0;
      break;
    end;

  until true;
end;

procedure TFormArtikelKasse.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  repeat

    //
    if (Key = #13) or (Key = #27) then
    begin
      FreieEingabe(false);
      TouchKeyboard2.enabled := true;
      Edit1.SetFocus;
      Key := #0;
    end;

  until true;
end;

procedure TFormArtikelKasse.Prepare;
var
  n: integer;
  KasseImage: TPicture;
  sSystemKeys: TStringList;
  sSystemParse: string;
begin
  if not(IsPrepared) then
  begin
    BeginHourGlass;
    oTine := bErlaubnis('Kasse Tine');

    CheckCreateDir(KassePath);

    sARTIKEL := csTable(
      { } 'select ARTIKEL.RID,ARTIKEL.TITEL,ARTIKEL.EURO,MWST.SATZ ' +
      { } 'from ARTIKEL ' +
      { } 'join SORTIMENT on (ARTIKEL.SORTIMENT_R=SORTIMENT.RID) ' +
      { } 'join MWST on (SORTIMENT.MWST_NAME=MWST.NAME) and '+
      { } '(CURRENT_DATE between MWST.VON_DATUM and MWST.BIS_DATUM)'
      );
    sARTIKEL.SaveToHTML(Systempath + '\' + 'Touch-Artikel.html');

    sBON := TsTable.Create;
    sBON.addCol('RID'); // Artikel - Referenz
    sBON.addCol('ANZAHL');
    sBON.addCol('TITEL');
    sBON.addCol('EURO');
    sBON.addCol('SATZ');

    AktuellesBild := -1;

    Images := TStringList.Create;
    dir(Systempath + '\' + 'Kasse-*.bmp', Images, false);
    Images.Sort;
    for n := 0 to pred(Images.Count) do
    begin
      KasseImage := TPicture.Create;
      KasseImage.LoadFromFile(Systempath + '\' + Images[n]);
      Images.Objects[n] := KasseImage;
    end;

    //
    Touch := TStringList.Create;
    Touch.LoadFromFile(Systempath + '\' + 'Kasse-Touch.ini');
    dx := StrToIntDef(Touch.Values['dx'], 1);
    dy := StrToIntDef(Touch.Values['dy'], 1);
    Touch_Kontext := StrToIntDef(nextp(Touch.Values['0x0'], ';', 2), cRID_Null);

    // die SystemKeys rausfiltern
    sSystemKeys := TStringList.Create;
    for n := 0 to pred(Touch.Count) do
      if (pos('System', Touch[n]) = 1) then
        sSystemKeys.add(Touch[n]);

    // die Systemkeys anlegen!
    SetLength(TouchSystem, sSystemKeys.Count);
    for n := 0 to pred(sSystemKeys.Count) do
    begin
      with TouchSystem[n] do
      begin
        sSystemParse := sSystemKeys[n];
        nextp(sSystemParse, 'System-');
        t_Action := nextp(sSystemParse, '@');
        t_Context := StrToIntDef(nextp(sSystemParse, '='), 0);
        t_x := StrToIntDef(nextp(sSystemParse, ';'), 0);
        t_y := StrToIntDef(nextp(sSystemParse, ';'), 0);
        t_dx := StrToIntDef(nextp(sSystemParse, ';'), 0);
        t_dy := StrToIntDef(nextp(sSystemParse, ';'), 0);
      end;
    end;
    sSystemKeys.Free;

    // das Kundendisplay initialisieren
    sDisplay := TBasicProcessor.Create;
    with sDisplay do
    begin
      PicturePath := MyProgramPath + cHTMLTemplatesDir;
      ResolveSQL := ResolveSQL;
      addStrings
        (e_r_sqlt('select DEFINITION from DRUCK where NAME=''Display'''));
      ShouldRUN := true;
    end;

    // den Bon-Drucker initialisieren
    sDrucker := TBasicProcessor.Create;
    with sDrucker do
    begin
      PicturePath := MyProgramPath + cHTMLTemplatesDir;
      ResolveSQL := ResolveSQL;
      addStrings
        (e_r_sqlt(
        'select DEFINITION from DRUCK where NAME=''Kassenzettel-Kopf'''));
    end;

    sSchublade := TBasicProcessor.Create;
    with sSchublade do
    begin
      addStrings
        (e_r_sqlt(
        'select DEFINITION from DRUCK where NAME=''Kassenschublade-Öffnen'''));
    end;

    sKassenzettel_Seite :=
      e_r_sqlt('select DEFINITION from DRUCK where NAME=''Kassenzettel-Seite''');
    cLINES_PER_PAGE := StrToIntDef(sKassenzettel_Seite.Values
      ['REM MAX_LINES'], 10);
    cLINE_LENGTH := StrToIntDef(sKassenzettel_Seite.Values
      ['REM LINE_LENGTH'], 29);

    sKassenzettel_Cut :=
      e_r_sqlt('select DEFINITION from DRUCK where NAME=''Kassenzettel-Cut''');

    IsPrepared := true;
    EndHourGlass;
  end;

end;

procedure TFormArtikelKasse.FormActivate(Sender: TObject);
begin
  if DebugMode then
    FormStyle := fsnormal;
  Prepare;
  if not(IsInitialized) then
  begin

    top := 0;
    left := 0;
    width := min(screen.width, 1366);
    height := min(screen.height, 768);

    Edit1.Text := '';
    Edit2.Text := '';

    with DrawGrid1, canvas do
    begin
      DefaultRowHeight := 30;
      font.Name := 'Courier New';
      font.color := clblack;
      ColCount := 4;
      ColWidths[0] := 50;
      // Status
      ColWidths[1] := 250; // Datum
      ColWidths[2] := 80; // Valuta
      ColWidths[3] := 1; // Dummy
      RowCount := 0;
    end;
    dgAutoSize(DrawGrid1, true);

    FreieEingabe(false);

    // Aktuelle Uhrzeit anzeigen
    ZeitAnzeigen;

    // Mit einer Folie starten
    Folie := 0;

    IsInitialized := true;
  end;

  Timer1.enabled := true;
  Timer2.enabled := true;
end;

procedure TFormArtikelKasse.FormDeactivate(Sender: TObject);
begin
  Timer1.enabled := false;
  Timer2.enabled := false;
end;

procedure TFormArtikelKasse.FormKeyPress(Sender: TObject; var Key: Char);
begin
  repeat
    if NaechsterSchrittIstStorno then
      Bon_Storno;

    // Focus vorrangig auf edit2 leiten
    if Edit2.Visible then
    begin
      if not(Edit2.Focused) then
      begin
        Edit2.SetFocus;
      end;
      break;
    end;
    //

    if not(Edit1.Focused) then
      Edit1.SetFocus;

  until true;

end;

procedure TFormArtikelKasse.FreieEingabe(Sichtbar: boolean);
begin
  TouchKeyboard1.Visible := Sichtbar;
  Edit2.Visible := Sichtbar;
  // DrawGrid2.visible := Sichtbar;
end;

procedure TFormArtikelKasse.Image1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; x, y: integer);
var
  sPos: string;
  sAction: string;
  n: integer;
begin

  repeat
    if NaechsterSchrittIstStorno then
      Bon_Storno;

    // System-Aktion
    sAction := '';
    for n := 0 to High(TouchSystem) do
      with TouchSystem[n] do
      begin
        if
        { } (Touch_Kontext = t_Context) and
        { } (x >= t_x) and
        { } (x < t_x + t_dx) and
        { } (y >= t_y) and
        { } (y < t_y + t_dy) then
        begin
          sAction := t_Action;
          SystemTouch(sAction);
          break;
        end;
      end;
    if (sAction <> '') then
      break;

    // Positions-Raster bestimmen
    sPos := inttostr(x div dx) + 'x' + inttostr(y div dy);

    // Globale Aktion
    sAction := Touch.Values[sPos];
    if (sAction <> '') then
    begin
      Touch_Kontext := StrToIntDef(nextp(sAction, ';', 2), cRID_Null);
      Folie := pred(StrToIntDef(nextp(sAction, ';', 1), 1));
      break;
    end;

    // Ein Artikel
    sAction := Touch.Values[sPos + '@' + inttostr(Touch_Kontext)];
    if (sAction <> '') then
    begin
      ArtikelTouch(StrToIntDef(nextp(sAction, ';', 1), cRID_Null));
      break;
    end;

    // ShowMessage(sPos + ' ohne Zuordnung!');
    beep;

  until true;
end;

procedure TFormArtikelKasse.setFolie(FolieIndex: integer);
begin
  if (FolieIndex >= 0) and (FolieIndex < Images.Count) and
    (FolieIndex <> AktuellesBild) then
  begin
    AktuellesBild := FolieIndex;
    Image1.Picture := TPicture(Images.Objects[AktuellesBild]);
  end;
end;

procedure TFormArtikelKasse.Settings;
begin
  close;
  FormArtikelPOS.show;
end;

procedure TFormArtikelKasse.SystemTouch(sAction: string);
var
  Summe: double;
  Gegeben: double;
  BonFName: string;
begin
  repeat

    if (sAction = 'Storno') then
    begin
      Bon_Storno;
      break;
    end;

    if (sAction = 'Gegeben') then
    begin

      // Gegeben berechnen
      Summe := StrToDoubleDef(StaticText1.Caption, 0);
      if (Edit1.Text = '') then
        Gegeben := Summe
      else
        Gegeben := StrToDoubleDef(AlsPreis(Edit1.Text), 0);
      StaticText2.Caption := format('%m', [Gegeben]);
      StaticText3.Caption := format('%m', [Gegeben - Summe]);
      Edit1.Text := '';

      // Kassenschublade auf
      if (iSchubladePort = '') then
        sSchublade.RUN
      else
        FormArtikelPOS.Schublade_Auf(iSchubladePort);

      if oTine then
        if (sBON.RowCount > 0) then
        begin
          NaechsterSchrittIstStorno := true;
          Bon_Buchen;
          DrawGrid1.Refresh;
        end;

      break;
    end;

    if (sAction = 'Merke') then
    begin

      repeat

        // Es soll einfach ein Bon aufgerufen werden
        if (sBON.RowCount = 0) then
        begin
          Bon_Restore;
          break;
        end;

        // Es soll einfach weitergeblättert werden
        if (GemerkterBonInDerAnzeige <> '') and not(sBON.changed) then
        begin
          Bon_Restore;
          break;
        end;

        // BON in den Zwischenspeicher
        if (GemerkterBonInDerAnzeige <> '') and sBON.changed then
        begin
          // Überschreiben!
          BonFName := GemerkterBonInDerAnzeige;
          GemerkterBonInDerAnzeige := '';
        end
        else
        begin
          // Neuer Dateiname
          BonFName := cBON_gemerkt + RIDasStr(e_w_GEN('GEN_TICKET')) + '.csv';
        end;

        sBON.SaveToFile(
          { } KassePath +
          { } BonFName);
        Bon_Storno;
      until true;
      break;
    end;

    if (sAction = 'Bar') and (sBON.RowCount > 0) then
    begin
      // Aktuellen Beleg buchen!
      BeginHourGlass;
      Bon_Buchen;
      Bon_Storno;

      EndHourGlass;
    end;

    if (sAction = 'Bon') then
    begin
      // a) zuletzt gebuchten Beleg ausdrucken, wenn
      // b) wie "Bar" jedoch noch einen Bon drucken!
      BeginHourGlass;
      if (sBON.RowCount > 0) then
      begin
        Bon_Buchen;
        Bon_Storno;
      end;
      if (pos('-', Edit1.Text) = 1) then
        Sturz_Drucken
      else
        Bon_Drucken;
      Edit1.Text := '';
      EndHourGlass;
    end;

  until true;
end;

procedure TFormArtikelKasse.Timer1Timer(Sender: TObject);
begin
  ZeitAnzeigen;
end;

var
  isPrinting: boolean = false;

procedure TFormArtikelKasse.Timer2Timer(Sender: TObject);
begin
  if assigned(sDisplay) then
    if not(isPrinting) then
      with sDisplay do
        if ShouldRUN then
        begin
          isPrinting := true;
          try
            RUN;
          except
          end;
          isPrinting := false;
        end;
end;

procedure TFormArtikelKasse.ZeitAnzeigen;
begin
  Label3.Caption := long2dateText(DateGet) + '   ' + SecondsToStr5(SecondsGet);
end;

end.
