{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2012 - 2017  Andreas Filsinger
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
unit Objektverwaltung;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  IniFiles, Grids, ExtCtrls;

const
  Version: single = 1.008; // ..\rev\Hausverwaltung.rev.txt
  cObjektSubPath = 'Objekt ';
  cObjektIni = 'Objekt.ini';
  cSaldoPrefix = 'Saldo am ';

type
  TSaldoSpeicher = packed record
    SaldoEigentuemer: extended;
    SaldoMieter: extended;
    Ruecklage: extended;
  end;

  TSaldo = class(TObject)
    Werte: array of TSaldoSpeicher;
    procedure SaveToFile(FName: string);
    procedure LoadFromFile(FName: string; Ausgeglichen: Boolean = false);
    procedure Clear(NewCount: integer);
  end;

type
  TFormObjektverwaltung = class(TForm)
    LadenButton: TButton;
    CopyButton: TButton;
    ComboBox1: TComboBox;
    ListBox1: TListBox;
    Edit1: TEdit;
    Button1: TButton;
    MuellButton: TButton;
    ListPersButton: TButton;
    ComboBox2: TComboBox;
    WasserButton: TButton;
    VersicherungButton: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    ComboBox3: TComboBox;
    Label2: TLabel;
    AuswertenButton: TButton;
    WaermeButton: TButton;
    StromButton: TButton;
    RuecklageButton: TButton;
    BankButton: TButton;
    WarmWasserButton: TButton;
    AllesButton: TButton;
    UebersichtButton: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Button2: TButton;
    ZeitraumVomEdit: TEdit;
    ZeitraumBisEdit: TEdit;
    StringGrid1: TStringGrid;
    SonstigeButton: TButton;
    ListBox2: TListBox;
    ComboBox4: TComboBox;
    Button3: TButton;
    Button4: TButton;
    ReinigungButton: TButton;
    CheckBox1: TCheckBox;
    CheckBoxMuell: TCheckBox;
    procedure LadenButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ComboBox1Change(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure MuellButtonClick(Sender: TObject);
    procedure ListPersButtonClick(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure WasserButtonClick(Sender: TObject);
    procedure VersicherungButtonClick(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure StromButtonClick(Sender: TObject);
    procedure RuecklageButtonClick(Sender: TObject);
    procedure BankButtonClick(Sender: TObject);
    procedure WaermeButtonClick(Sender: TObject);
    procedure WarmWasserButtonClick(Sender: TObject);
    procedure AllesButtonClick(Sender: TObject);
    procedure UebersichtButtonClick(Sender: TObject);
    procedure CopyButtonClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SonstigeButtonClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ReinigungButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }

    ProjektData: TIniFile;
    ActWohnungen: TStringList;
    ActKonten: TStringList;
    ActPersonen: TStringList;
    Report: TStringList;
    KostenArtenGlobal: TStringList;
    EigentuemerInfo: TStringList;
    MieterInfo: TStringList;
    SaldenAlt: TSaldo;
    SaldenNeu: TSaldo;

    procedure LoadKonto(Konto: string);
    procedure SaveKonto(Konto: string);
    function GetKonto(Konto: string): TList;
    function GetKontoWohnung(n: integer): TList;
    function GetKosten(KList: TList; art: string; AmTag: longint): extended;
    function GetKostenPersistent(KList: TList; art: string; AmTag: longint)
      : extended;
    function GetKaufDatum(Wohnung: integer): longint;
    function GetTausendstel(Wohnung: integer): extended;
    function GetPersonen(Wohnung, Tag: integer): integer;
    function VermieteterZeitraum(Wohnung: integer): integer;

    procedure ShowKonto(KList: TList);
    procedure PersonenBerechnen;
    procedure VerteileMuell;

    procedure PersonenVerteiler(day: integer; kosten: extended);
    procedure VerbrauchAbrechnen(const pKostenArt, pEinheit: string);
    function ZeitRaumLength: integer;

    function ObjektPath: string;
    function ObjektName: string;

    procedure Kabel;

  end;

var
  FormObjektverwaltung: TFormObjektverwaltung;

implementation

{$R *.DFM}

uses
  globals, anfix32, wanfix32;

const
  StringDelimiter = ';'; // TList

type
  TKostenZahl = class(TObject)
    Wert: extended;
    UmlageAufMieter: Boolean;
  end;

  // eine einzelne Buchungszeile
  TBuchung = class(TObject)
    Bucher: string; // Verursacher / Geldgeber (Person!)
    Zweck: string; // wer / was
    Kostenart: string; // Umlagetopf
    Buchungstag: TAnfixDate;
    Betrag: extended;
    Waehrung: string;
    BelegNo: string;
    ZeitraumVon: TAnfixDate;
    ZeitraumBis: TAnfixDate;
    UmlageAufMieter: Boolean;

    Persistent: Boolean;
    // true wenn der Eintrag aus der Datei kommt, ansonsten
    // könnte es auch ein errechneter Eintrag sein

    procedure LoadFromString(s: string);
    function SaveToString: string;
    function SaveToTable: string;
    function Zeitraum: string;
    function _Betrag: string;
    function Tage: integer;
    function AufMStr: string;

    function Header: string;
    function Trenner: string;
    function Footer: string;
  end;

  TMonatRecord = record
    FirstDayInMonth: TAnfixDate;
    FirstOffset: integer;
    LastDayInMonth: TAnfixDate;
    LastOffset: integer;
  end;

  // Kosten, die auf einen Zeitraum umgelegt werden
  TTagesKosten = class(TObject)
    StartDatum: TAnfixDate;
    EndeDatum: TAnfixDate;
    Werte: array of extended; // Kostenwert oder Verbrauchswert
    Verbrauch: array of extended; // Resource-Verbrauchswert
    Monate: array of TMonatRecord;

    function DayCount: integer;
    function MonthCount: integer;

    constructor Create(s, e: longint);

    function MonatsSumme(Monat: integer): extended;

    function KostenStart(Monat: integer): TAnfixDate;
    function KostenEnde(Monat: integer): TAnfixDate;

    function AnzTageImMonat(Monat: integer): integer;
    function IndexOf(Datum: TAnfixDate): integer;

    function Summe: extended;
    procedure Clear;
    procedure Multi(f: extended);
    function DatumAt(n: integer): TAnfixDate;
  end;

// TBuchung

procedure TBuchung.LoadFromString(s: string);

  function Nextp: string;
  var
    k: integer;
  begin
    k := pos(StringDelimiter, s);
    if (k > 0) then
    begin
      result := copy(s, 1, pred(k));
      s := copy(s, succ(k), MaxInt);
    end
    else
    begin
      result := s;
      s := '';
    end;
  end;

  function NextR: extended;
  var
    k: integer;
    PreisStr: string;
    dummy: integer;
  begin
    k := pos(' ', s);
    if (k > 0) then
    begin
      PreisStr := cutblank(copy(s, 1, pred(k)));
      ersetze(',', '.', PreisStr);
      s := copy(s, succ(k), MaxInt);
      val(PreisStr, result, dummy);
    end
    else
    begin
      result := 0.0;
    end;
  end;

  function NextVon: longint;
  var
    VonS: string;
    k: integer;
  begin
    result := 0;
    if (s = '') then
      exit;
    k := pos('-', s);
    if k > 0 then
    begin
      VonS := noblank(copy(s, 1, pred(k)));
      delete(s, 1, k);
      if length(VonS) = 5 then
        result := date2long('01.' + VonS)
      else
        result := date2long(VonS);
    end
    else
    begin
      if (s[1] = 'J') then // Dieses Jahr
      begin
        result := date2long('01.01.' + copy(s, 2, MaxInt));
      end;
      if (s[1] = 'M') or (s[1] = 'D') then // Dieser Monat
      begin
        result := date2long('01' + copy(long2date8(Buchungstag), 3, MaxInt));
      end;
      if (s[1] = 'T') or (s[1] = 'B') then // Dieser Tag
      begin
        result := Buchungstag;
      end;
      if (s[1] = 'R') then // Rest des Monats
      begin
        result := Buchungstag;
      end;
    end;
  end;

  function NextBis: longint;
  var
    BisS: string;
  begin
    result := cIllegalDate;
    BisS := Nextp;
    if (BisS = 'M') or (BisS = 'T') or (BisS = 'D') or (BisS = 'B') or
      (BisS = 'R') or (pos('J', BisS) = 1) then
    begin
      case BisS[1] of
        'J':
          result := date2long('31.12.' + copy(BisS, 2, MaxInt));
        'M', 'D':
          result := date2long(inttostr(LastDayOfMonth(Buchungstag)) +
            copy(long2date8(Buchungstag), 3, MaxInt));
        'T', 'B':
          result := Buchungstag;
        'R':
          result := date2long(inttostr(LastDayOfMonth(Buchungstag)) +
            copy(long2date8(Buchungstag), 3, MaxInt));
      end;
    end
    else
    begin
      result := date2long(BisS);
      if (length(long2date8(result)) = 5) then
        result := date2long(inttostr(LastDayOfMonth(result)) + '.' +
          long2date8(result));
    end;
  end;

begin
  Bucher := Nextp;
  Zweck := Nextp;
  Kostenart := Nextp;
  Buchungstag := date2long(Nextp);
  Betrag := NextR;
  Waehrung := Nextp;
  BelegNo := Nextp;
  ZeitraumVon := NextVon;
  ZeitraumBis := NextBis;
  UmlageAufMieter := (Nextp = '*');
end;

function TBuchung.SaveToString: string;

begin
  result :=
  { } Bucher + StringDelimiter +
  { } Zweck + StringDelimiter +
  { } Kostenart + StringDelimiter +
  { } long2date(Buchungstag) + StringDelimiter +
  { } _Betrag + ' ' + Waehrung + StringDelimiter +
  { } BelegNo + StringDelimiter +
  { } Zeitraum;
end;

const
  cBuchungTableHeader: array [1 .. 9] of string = (
   {} 'Verursacher          ',
   {} 'Text                    ',
   {} 'Art           ',
   {} 'Datum     ',
   {} 'Wert          ',
   {} 'BE#',
   {} 'für Zeitraum         ',
   {} 'Tage',
   {} 'MU');

function TBuchung.Header: string;
var
  n: integer;
begin
  result := '|';
  for n := low(cBuchungTableHeader) to high(cBuchungTableHeader) do
    result := result + cBuchungTableHeader[n] + '|';
end;

function TBuchung.Trenner: string;
var
  n: integer;
begin
  result := '|';
  for n := low(cBuchungTableHeader) to high(cBuchungTableHeader) do
    result := result + fill('-', length(cBuchungTableHeader[n])) + '|';
end;

function TBuchung.Footer: string;
var
  n: integer;
begin
  result := '*';
  for n := low(cBuchungTableHeader) to high(cBuchungTableHeader) do
    result := result + fill('-', length(cBuchungTableHeader[n])) + '-';
  // delete(result,length(result),1);
  result[length(result)] := '*';
end;

function TBuchung.AufMStr: string;
begin
  if UmlageAufMieter then
    result := '*'
  else
    result := ' ';
end;

function TBuchung.SaveToTable: string;

  function FitToL(s: string; l: integer): string;
  begin
    result := s + fill(' ', l - length(s));
    result := copy(result, 1, l) + '|';
  end;

  function FitToR(s: string; l: integer): string;
  begin
    result := fill(' ', l - length(s)) + s;
    result := copy(result, 1, l) + '|';
  end;

begin
  result := '|' + FitToL(Bucher, length(cBuchungTableHeader[1])) +
    FitToL(Zweck, length(cBuchungTableHeader[2])) +
    FitToL(Kostenart, length(cBuchungTableHeader[3])) +
    FitToL(long2date(Buchungstag), length(cBuchungTableHeader[4])) +
    FitToR(_Betrag + ' ' + Waehrung, length(cBuchungTableHeader[5])) +
    FitToR(BelegNo, length(cBuchungTableHeader[6])) +
    FitToL(Zeitraum, length(cBuchungTableHeader[7])) + FitToR(inttostr(Tage),
    length(cBuchungTableHeader[8])) +
  // FitToL(VerteilungsModus,length(cBuchungTableHeader[9])) +
    FitToL(AufMStr, length(cBuchungTableHeader[9]));
end;

function TBuchung.Zeitraum: string;
begin
  result := long2date(ZeitraumVon) + '-' + long2date(ZeitraumBis);
end;

function TBuchung._Betrag: string;
begin
  result := format('%.2f', [Betrag]);
  if Betrag >= 0 then
    result := '+' + result;
end;

function TBuchung.Tage: integer;
begin
  result := succ(DateDiff(ZeitraumVon, ZeitraumBis));
end;

function BuchungSort(Item1, Item2: Pointer): integer;
var
  SortStr1, SortStr2: string;
begin
  with TObject(Item1) as TBuchung do
    SortStr1 := inttostr(Buchungstag) + Kostenart + Zweck +
      inttostr(ZeitraumVon);
  with TObject(Item2) as TBuchung do
    SortStr2 := inttostr(Buchungstag) + Kostenart + Zweck +
      inttostr(ZeitraumVon);
  result := AnsiStrComp(PChar(SortStr1), PChar(SortStr2));
end;

// TTagesKosten

constructor TTagesKosten.Create(s, e: longint);
var
  LastRegistratedMonth: integer;
  ThisMonth: integer;
  MyMonthCount: integer;
  n: integer;
  ThisDate: TAnfixDate;
  _FirstDayinMonth: TAnfixDate;
  _FirstDayinMonthOffset: integer;

  function ExtractMonth(FromDate: TAnfixDate): integer;
  begin
    result := strtoint(copy(long2date(FromDate), 4, 2));
  end;

begin
  StartDatum := s;
  EndeDatum := e;
  SetLength(Werte, succ(DateDiff(s, e)));
  SetLength(Verbrauch, succ(DateDiff(s, e)));

  // Anzahl der Monate bestimmen
  LastRegistratedMonth := 0;
  MyMonthCount := 0;
  ThisDate := StartDatum;
  for n := 0 to pred(DayCount) do
  begin
    ThisMonth := ExtractMonth(ThisDate);
    if ThisMonth <> LastRegistratedMonth then
    begin
      LastRegistratedMonth := ThisMonth;
      inc(MyMonthCount);
    end;
    ThisDate := DatePlus(ThisDate, 1);
  end;

  // Array richtig setzen
  SetLength(Monate, MyMonthCount);

  // Nun die Monate eintragen
  LastRegistratedMonth := 0;
  MyMonthCount := 0;
  ThisDate := StartDatum;

  _FirstDayinMonth := 0;
  _FirstDayinMonthOffset := 0;

  for n := 0 to pred(DayCount) do
  begin

    ThisMonth := ExtractMonth(ThisDate);
    if (ThisMonth <> LastRegistratedMonth) then
    begin

      if (LastRegistratedMonth <> 0) then
        with Monate[pred(MyMonthCount)] do
        begin
          FirstDayInMonth := _FirstDayinMonth;
          FirstOffset := _FirstDayinMonthOffset;
          LastDayInMonth := DatePlus(ThisDate, -1);
          LastOffset := pred(n);
        end;

      _FirstDayinMonth := ThisDate;
      _FirstDayinMonthOffset := n;

      LastRegistratedMonth := ThisMonth;
      inc(MyMonthCount);
    end;

    ThisDate := DatePlus(ThisDate, 1);
  end;

  // letzen Monat noch eintragen
  with Monate[pred(MyMonthCount)] do
  begin
    FirstDayInMonth := _FirstDayinMonth;
    FirstOffset := _FirstDayinMonthOffset;
    LastDayInMonth := EndeDatum;
    LastOffset := pred(DayCount);
  end;
  Clear;
end;

function TTagesKosten.AnzTageImMonat(Monat: integer): integer;
begin
  with Monate[Monat] do
    result := succ(LastOffset - FirstOffset);
end;

function TTagesKosten.MonatsSumme(Monat: integer): extended;
var
  n: integer;
begin
  result := 0.0;
  with Monate[Monat] do
    for n := FirstOffset to LastOffset do
      result := result + Werte[n];
end;

function TTagesKosten.KostenStart(Monat: integer): TAnfixDate;
var
  n: integer;
begin
  result := 0;
  with Monate[Monat] do
    for n := FirstOffset to LastOffset do
      if Werte[n] <> 0.0 then
      begin
        result := DatePlus(StartDatum, n);
        break;
      end;
end;

function TTagesKosten.KostenEnde(Monat: integer): TAnfixDate;
var
  n: integer;
begin
  result := 0;
  with Monate[Monat] do
    for n := LastOffset downto FirstOffset do
      if Werte[n] <> 0.0 then
      begin
        result := DatePlus(StartDatum, n);
        break;
      end;
end;

procedure TTagesKosten.Clear;
var
  n: integer;
begin
  for n := 0 to pred(length(Werte)) do
  begin
    Werte[n] := 0.0;
    Verbrauch[n] := 0.0;
  end;
end;

procedure TTagesKosten.Multi(f: extended);
var
  n: integer;
begin
  for n := 0 to pred(length(Werte)) do
    Werte[n] := Werte[n] * f;
end;

function TTagesKosten.DatumAt(n: integer): TAnfixDate;
begin
  result := DatePlus(StartDatum, n);
end;

function TTagesKosten.Summe: extended;
var
  n: integer;
begin
  result := 0.0;
  for n := 0 to pred(length(Werte)) do
    result := result + Werte[n];
end;

function TTagesKosten.DayCount: integer;
begin
  result := length(Werte);
end;

function TTagesKosten.MonthCount: integer;
begin
  result := length(Monate);
end;

function TTagesKosten.IndexOf(Datum: TAnfixDate): integer;
begin
  if Datum > EndeDatum then
  begin
    result := -1;
  end
  else
  begin
    result := DateDiff(StartDatum, Datum);
    if result < 0 then
      result := -1;
  end;
end;

// form

procedure TFormObjektverwaltung.LoadKonto(Konto: string);
var
  KontoList: TList;
  KontoAsStrings: TStringList;
  Buchung: TBuchung;
  n: integer;
  FName: string;
begin
  if (ActKonten.IndexOf(Konto) <> -1) then
    exit;
  KontoList := TList.Create;
  KontoAsStrings := TStringList.Create;
  FName := ObjektPath + Konto + '.Konto';
  if FileExists(FName) then
  begin
    KontoAsStrings.LoadFromFile(FName);
    ActKonten.AddObject(Konto, KontoList);
    for n := 0 to pred(KontoAsStrings.count) do
    begin
      KontoAsStrings[n] := cutblank(KontoAsStrings[n]);
      if (KontoAsStrings[n] <> '') and (pos('-', KontoAsStrings[n]) <> 1) then
      begin
        Buchung := TBuchung.Create;
        Buchung.Persistent := true;
        Buchung.LoadFromString(KontoAsStrings[n]);
        if Buchung.Kostenart = 'SAT Anschluss' then
          Buchung.UmlageAufMieter := true;
        KontoList.add(Buchung);
        if (Konto = 'Kosten') and (Buchung.Betrag < 0.0) then
          if (KostenArtenGlobal.IndexOf(Buchung.Kostenart) = -1) then
            KostenArtenGlobal.add(Buchung.Kostenart);
      end;
    end;
  end;
  KontoAsStrings.free;
end;

procedure TFormObjektverwaltung.SaveKonto(Konto: string);
begin
end;

procedure TFormObjektverwaltung.LadenButtonClick(Sender: TObject);
var
  n: integer;
  wKosten: TTagesKosten;
begin
  ActWohnungen.Clear;
  ActKonten.Clear;
  ActPersonen.Clear;
  KostenArtenGlobal.Clear;

  ProjektData.free;
  ProjektData := TIniFile.Create(ObjektPath + cObjektIni);
  ProjektData.ReadSections(ComboBox1.Items);
  ProjektData.ReadSections(ActWohnungen);

  n := 0;
  while (n < ActWohnungen.count) do
  begin
    if (pos('WOHNUNG ', ActWohnungen[n]) <> 1) then
      ActWohnungen.delete(n)
    else
    begin
      inc(n);
      // ActWohnungen[n] := ActWohnungen[n] + '('+ProjektData.ReadString(ActWohnungen[n],'Name','-')+')';
    end;
  end;

  // für jede Wohnung ein Tages-Kosten-Objekt !!!
  for n := 0 to pred(ActWohnungen.count) do
  begin
    wKosten := TTagesKosten.Create(date2long(ZeitraumVomEdit.Text),
      date2long(ZeitraumBisEdit.Text));
    ActWohnungen.objects[n] := wKosten;
  end;

  // Allgemeine angefallene Kosten !!
  LoadKonto('Kosten');
  // individuelle Kosten / Verbrauch !!
  for n := 0 to pred(ActWohnungen.count) do
    LoadKonto(ProjektData.ReadString(ActWohnungen[n], 'Name', ''));

  ComboBox2.Items.assign(ActKonten);
  ComboBox3.Items.assign(KostenArtenGlobal);

  // Personen
  PersonenBerechnen;

  // Salden anlegen
  SaldenAlt.Clear(ActWohnungen.count);
  SaldenNeu.Clear(ActWohnungen.count);

end;

function TFormObjektverwaltung.GetKonto(Konto: string): TList;
var
  i: integer;
begin
  result := nil;
  i := ActKonten.IndexOf(Konto);
  if i <> -1 then
    result := TList(ActKonten.objects[i]);
end;

function TFormObjektverwaltung.GetKontoWohnung(n: integer): TList;
begin
  result := GetKonto(ProjektData.ReadString(ActWohnungen[n], 'Name', ''));
end;

procedure TFormObjektverwaltung.FormActivate(Sender: TObject);
begin
  if not(assigned(KostenArtenGlobal)) then
  begin

    KostenArtenGlobal := TStringList.Create;
    ActKonten := TStringList.Create;
    ActWohnungen := TStringList.Create;
    ActPersonen := TStringList.Create;
    Report := TStringList.Create;
    EigentuemerInfo := TStringList.Create;
    MieterInfo := TStringList.Create;

    SaldenAlt := TSaldo.Create;
    SaldenNeu := TSaldo.Create;

    StringGrid1.width := ClientWidth - 4;
    caption := 'Hausverwaltung Rev ' + RevToStr(Version);

    dir(MyProgramPath + cObjektSubPath + '*.', ComboBox4.Items, false);
  end;
end;

procedure TFormObjektverwaltung.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = vk_escape) then
    close;
end;

procedure TFormObjektverwaltung.ComboBox1Change(Sender: TObject);
begin
  // TiniFile
  if assigned(ProjektData) then
  begin
    ListBox1.Items.Clear;
    ProjektData.ReadSectionValues(ComboBox1.Text, ListBox1.Items);
  end;
end;

procedure TFormObjektverwaltung.ListBox1DblClick(Sender: TObject);
var
  k: integer;
begin
  if ListBox1.itemindex <> -1 then
  begin
    k := pos('=', ListBox1.Items[ListBox1.itemindex]);
    Edit1.Text := copy(ListBox1.Items[ListBox1.itemindex], succ(k), MaxInt);
    Edit1.SetFocus;
  end;
end;

procedure TFormObjektverwaltung.Button1Click(Sender: TObject);
begin
  ListBox1.Items.assign(ActWohnungen);
end;

procedure TFormObjektverwaltung.PersonenBerechnen;
var
  DateNow: integer;
  n, m, o: integer;
  OneLine: string;
  PersonenInWohnung: integer;
  PersonenImHaus: integer;
  MieterEntries: TStringList;

  function CountPersonenOn(d: longint; Wohnung: integer): integer;
  var
    OneEntry: string;
    ThatDate: longint;
    k, j, l: integer;
  begin
    result := 0;
    OneEntry := MieterEntries[Wohnung];
    while true do
    begin
      k := pos('(', OneEntry);
      if (k = 0) then
        break;
      j := pos(')', OneEntry);
      if (j = 0) then
        beep;
      l := pos(':', OneEntry);
      if (l = 0) then
        beep;
      ThatDate := date2long(copy(OneEntry, succ(k), 8));
      if DateOK(ThatDate) then
        if (d >= ThatDate) then
          result := strtoint(copy(OneEntry, succ(l), pred(j - l)));
      delete(OneEntry, 1, j);
    end;
  end;

begin
  MieterEntries := TStringList.Create;
  DateNow := date2long(ZeitraumVomEdit.Text);
  if DateOK(DateNow) then
  begin

    // Mieter-Einträge suchen TiniFile
    for o := 0 to pred(ActWohnungen.count) do
      MieterEntries.add(ProjektData.ReadString(ActWohnungen[o], 'Mieter', '-'));
    ListBox2.Items.assign(MieterEntries);

    // Mieter-Einträge suchen TiniFile
    m := ZeitRaumLength;
    for n := 1 to m do
    begin
      OneLine := long2date8(DateNow) + '=';
      PersonenImHaus := 0;
      for o := 0 to pred(ActWohnungen.count) do
      begin
        PersonenInWohnung := CountPersonenOn(DateNow, o);
        inc(PersonenImHaus, PersonenInWohnung);
        OneLine := OneLine + inttostr(PersonenInWohnung) + '|';
      end;
      OneLine := OneLine + ' (' + inttostr(PersonenImHaus) + ')';
      ActPersonen.add(OneLine);
      DateNow := DatePlus(DateNow, 1);
    end;
    ListBox1.Items.assign(ActPersonen);
  end
  else
    beep;
  MieterEntries.free;
end;

procedure TFormObjektverwaltung.MuellButtonClick(Sender: TObject);
begin
  VerteileMuell;
end;

procedure TFormObjektverwaltung.VerteileMuell;
var
  KList: TList;
  n, m: integer;
  TestDate: longint;
  VerteilungsBetrag: extended;
  DebugStr: TStringList;
  GesamtKosten: extended;
  BuchungsSatz: TBuchung;
  BuchungsStr: string;
  TagesKosten: TTagesKosten;
begin
  // ActPersonen.SaveToFile('G:\delphi\hausverwaltung\pers.txt');
  KList := GetKonto('Kosten');
  if assigned(KList) then
  begin
    DebugStr := TStringList.Create;
    GesamtKosten := 0.0;
    for n := 0 to pred(ActPersonen.count) do
    begin
      TestDate := date2long(copy(ActPersonen[n], 1, 8));

      // Kosten auf die Personen verteilen
      VerteilungsBetrag := GetKosten(KList, 'Müll', TestDate);
      PersonenVerteiler(n, VerteilungsBetrag);

      GesamtKosten := GesamtKosten + VerteilungsBetrag;
      DebugStr.add(long2date8(TestDate) + '=' + format('%.18f',
        [VerteilungsBetrag]));
    end;
    ListBox2.Items.assign(DebugStr);
    ListBox2.Items.add(format('%.18f', [GesamtKosten]));

    GesamtKosten := 0.0;
    for n := 0 to pred(ActWohnungen.count) do
    begin

      KList := GetKontoWohnung(n);
      TagesKosten := TTagesKosten(ActWohnungen.objects[n]);

      for m := 0 to pred(TagesKosten.MonthCount) do
      begin
        VerteilungsBetrag := TagesKosten.MonatsSumme(m);
        GesamtKosten := GesamtKosten + VerteilungsBetrag; // Tform
        if VerteilungsBetrag <> 0.0 then
        begin
          BuchungsStr := 'C Müll;' + 'Müll;' + 'Müll;' +
            long2date(TagesKosten.Monate[m].FirstDayInMonth) + ';' +
            format('%.18f', [VerteilungsBetrag]) + ' €;' + '-' + ';' +
            long2date(TagesKosten.KostenStart(m)) + '-' +
            long2date(TagesKosten.KostenEnde(m));
          if assigned(KList) then
          begin
            BuchungsSatz := TBuchung.Create;
            BuchungsSatz.LoadFromString(BuchungsStr);
            BuchungsSatz.UmlageAufMieter := true;
            KList.add(BuchungsSatz);
          end;
          ListBox2.Items.add(BuchungsStr);
        end;
      end;
      if assigned(KList) then
        KList.Sort(BuchungSort);
    end;
    ListBox2.Items.add(format('%.12f', [GesamtKosten]));

    DebugStr.free;
  end;
end;

function TFormObjektverwaltung.GetKosten(KList: TList; art: string;
  AmTag: longint): extended;
var
  m: integer;
begin
  result := 0.0;
  if assigned(KList) then
    for m := 0 to pred(KList.count) do
      with TObject(KList[m]) as TBuchung do
      begin
        if (Kostenart = art) then
          if DateInside(AmTag, ZeitraumVon, ZeitraumBis) then
          begin
            // ListBox2.Items.add('found: ' + SaveToString);
            result := result + (Betrag / Tage);
          end;
      end;
end;

function TFormObjektverwaltung.GetKostenPersistent(KList: TList; art: string;
  AmTag: longint): extended;
var
  m: integer;
begin
  result := 0.0;
  if assigned(KList) then
    for m := 0 to pred(KList.count) do
      with TObject(KList[m]) as TBuchung do
      begin
        if Persistent then
          if (Kostenart = art) then
            if DateInside(AmTag, ZeitraumVon, ZeitraumBis) then
            begin
              // ListBox2.Items.add('found: ' + SaveToString);
              result := result + (Betrag / Tage);
            end;
      end;
end;

procedure TFormObjektverwaltung.ListPersButtonClick(Sender: TObject);
begin
  ListBox1.Items.assign(ActPersonen);
end;

procedure TFormObjektverwaltung.PersonenVerteiler(day: integer;
  kosten: extended);
var
  k, j, n: integer;
  TagInfo: string;
  AnzPersonen: integer;
  PersonenProWohnung: integer;
  KostenProPerson: extended;
begin
  TagInfo := ActPersonen[day];
  k := pos('(', TagInfo);
  j := pos(')', TagInfo);
  if (k = 0) or (j < k) then
    beep;
  AnzPersonen := strtoint(copy(TagInfo, succ(k), pred(j - k)));

  if (AnzPersonen > 0) then
    KostenProPerson := kosten / AnzPersonen
  else
    KostenProPerson := 0.0;

  delete(TagInfo, k, MaxInt);
  k := pos('=', TagInfo);
  delete(TagInfo, 1, k);
  for n := 0 to pred(ActWohnungen.count) do
  begin
    k := pos('|', TagInfo);
    PersonenProWohnung := strtoint(copy(TagInfo, 1, pred(k)));
    delete(TagInfo, 1, k);
    with ActWohnungen.objects[n] as TTagesKosten do
      Werte[day] := KostenProPerson * PersonenProWohnung;
  end;
end;

procedure TFormObjektverwaltung.ShowKonto(KList: TList);
var
  InpStr: string;
  n, m: integer;

  function Nextp: string;
  var
    k: integer;
  begin
    k := pos(';', InpStr);
    if k > 0 then
    begin
      result := copy(InpStr, 1, pred(k));
      delete(InpStr, 1, k);
    end
    else
    begin
      result := InpStr;
      InpStr := '';
    end;
  end;

begin
  with StringGrid1 do // TStringGrid
  begin
    ColCount := 10;
    RowCount := KList.count + 1;
    cells[0, 0] := '';
    ColWidths[0] := 25;
    cells[1, 0] := 'Verursacher';
    ColWidths[1] := 150;
    cells[2, 0] := 'Text';
    ColWidths[2] := 200;
    cells[3, 0] := 'Art';
    ColWidths[3] := 120;
    cells[4, 0] := 'Datum';
    ColWidths[4] := 77;
    cells[5, 0] := 'Wert';
    ColWidths[5] := 100;
    cells[6, 0] := 'BNó';
    ColWidths[6] := 30;
    cells[7, 0] := 'für Zeitraum';
    ColWidths[7] := 160;
    cells[8, 0] := 'Tage';
    ColWidths[8] := 35;
    cells[9, 0] := 'UM';
    ColWidths[9] := 15;
    for n := 0 to pred(KList.count) do
    begin
      InpStr := TBuchung(KList[n]).SaveToString;
      cells[0, succ(n)] := inttostrN(succ(n), 3);
      for m := 0 to ColCount - 2 do
        cells[succ(m), succ(n)] := Nextp;
      cells[8, succ(n)] := inttostrN(TBuchung(KList[n]).Tage, 3);
      cells[9, succ(n)] := TBuchung(KList[n]).AufMStr;
    end;
    SetFocus;
  end;
end;

procedure TFormObjektverwaltung.ComboBox2Change(Sender: TObject);
var
  k: TList;
begin
  k := GetKonto(ComboBox2.Text);
  if assigned(k) then
    ShowKonto(k)
  else
    beep;
end;

procedure TFormObjektverwaltung.VerbrauchAbrechnen(const pKostenArt,
  pEinheit: string);
var
  RohstoffVerbrauch: extended;
  RohstoffGesamt: extended;
  Rohstoffkosten: extended;
  n, m: integer;
  KList: TList;
  TestDate: longint;
  VerteilungsBetrag: extended;
  ResourceVerbrauch: extended;
  BuchungsString: string;
  BuchungsSatz: TBuchung;
  TagesKosten: TTagesKosten;
  VerbrauchsKosten: TTagesKosten;
  VerbrauchsSummen: TTagesKosten;
begin

  VerbrauchsKosten := TTagesKosten.Create(date2long(ZeitraumVomEdit.Text),
    date2long(ZeitraumBisEdit.Text));
  VerbrauchsSummen := TTagesKosten.Create(date2long(ZeitraumVomEdit.Text),
    date2long(ZeitraumBisEdit.Text));

  // Gesamt-Rohstoffkosten für diese Resouce-Art berechnen
  KList := GetKonto('Kosten');
  for n := 0 to pred(ActPersonen.count) do
  begin
    TestDate := date2long(copy(ActPersonen[n], 1, 8));
    VerbrauchsKosten.Werte[n] := GetKosten(KList, pKostenArt, TestDate);
  end;
  ListBox2.Items.add(format(pKostenArt + '-Kosten %.18f €',
    [VerbrauchsKosten.Summe]));

  // Resource-Verbrauch berechnen
  RohstoffVerbrauch := 0.0;
  for m := 0 to pred(ActWohnungen.count) do
  begin
    KList := GetKontoWohnung(m);
    TagesKosten := TTagesKosten(ActWohnungen.objects[m]);
    TagesKosten.Clear;
    for n := 0 to pred(ActPersonen.count) do
    begin
      TestDate := date2long(copy(ActPersonen[n], 1, 8));
      ResourceVerbrauch := GetKosten(KList, pKostenArt, TestDate);
      TagesKosten.Werte[n] := ResourceVerbrauch;
      TagesKosten.Verbrauch[n] := ResourceVerbrauch;
      VerbrauchsSummen.Werte[n] := VerbrauchsSummen.Werte[n] +
        ResourceVerbrauch;
    end;
    ListBox2.Items.add(format('Wohnung ' + inttostr(succ(m)) +
      ' Verbrauch %.18f ' + pEinheit, [TagesKosten.Summe]));
    RohstoffVerbrauch := RohstoffVerbrauch + TagesKosten.Summe;
  end;
  ListBox2.Items.add(format('Gesamt Objekt Verbrauch %.18f ' + pEinheit,
    [RohstoffVerbrauch]));
  ListBox2.Items.add(format('Gesamt Objekt Verbrauch %.18f ' + pEinheit,
    [VerbrauchsSummen.Summe]));

  // Taggenau Kosten/Verbrauch in Relation stellen und Kosten aufteilen
  // Kosten werden im Verhältnis zum Verbrauch aufgeteilt
  for m := 0 to pred(ActWohnungen.count) do
  begin
    GetKontoWohnung(m);
    TagesKosten := TTagesKosten(ActWohnungen.objects[m]);
    for n := 0 to pred(ActPersonen.count) do
    begin
      if VerbrauchsSummen.Werte[n] <> 0.0 then
        TagesKosten.Werte[n] :=
          (TagesKosten.Werte[n] / VerbrauchsSummen.Werte[n]) *
          VerbrauchsKosten.Werte[n];
    end;
  end;

  // Auswertung
  RohstoffGesamt := 0.0;
  Rohstoffkosten := 0.0;
  for n := 0 to pred(ActWohnungen.count) do
  begin
    ListBox2.Items.add('Wohnung ' + inttostr(succ(n)) + ':');
    KList := GetKontoWohnung(n);
    TagesKosten := TTagesKosten(ActWohnungen.objects[n]);
    for m := 0 to pred(TagesKosten.MonthCount) do
    begin
      VerteilungsBetrag := TagesKosten.MonatsSumme(m);
      if (VerteilungsBetrag <> 0.0) then
      begin
        RohstoffVerbrauch :=
          (VerteilungsBetrag / VerbrauchsKosten.MonatsSumme(m)) *
          VerbrauchsSummen.MonatsSumme(m);
        BuchungsString := 'C ' + pKostenArt + ';' + pKostenArt + ' ' +
          format('%.3f', [RohstoffVerbrauch]) + ' ' + pEinheit + ';' +
          pKostenArt + ';' + long2date(TagesKosten.Monate[m].FirstDayInMonth) +
          ';' + format('%.18f', [VerteilungsBetrag]) + ' €;-;' +
          long2date(TagesKosten.KostenStart(m)) + '-' +
          long2date(TagesKosten.KostenEnde(m));
        RohstoffGesamt := RohstoffGesamt + RohstoffVerbrauch;
        Rohstoffkosten := Rohstoffkosten + VerteilungsBetrag;

        // neuer Buchungssatz
        BuchungsSatz := TBuchung.Create;
        BuchungsSatz.LoadFromString(BuchungsString);
        BuchungsSatz.UmlageAufMieter := true;
        KList.add(BuchungsSatz);
        ListBox2.Items.add(' ' + BuchungsString);
      end;
    end;
    KList.Sort(BuchungSort);
  end;
  ListBox2.Items.add(format('Gesamt Objekt Verbrauch %.18f ' + pEinheit,
    [RohstoffGesamt]));
  ListBox2.Items.add(format(pKostenArt + '-Kosten %.18f €', [Rohstoffkosten]));
  VerbrauchsKosten.free;
  VerbrauchsSummen.free;
end;

procedure TFormObjektverwaltung.VersicherungButtonClick(Sender: TObject);

  procedure Berechne(MitMieter: Boolean);
  var
    n, m: integer;
    KList: TList;
    TestDate: longint;
    VerteilungsBetrag: extended;
    BuchungsString: string;
    BuchungsSatz: TBuchung;
    KaufDatum: longint;
    Tausendstel: extended;
    TagesKosten: TTagesKosten;
  begin
    // Versicherungen
    KList := GetKonto('Kosten');
    for m := 0 to pred(ActWohnungen.count) do
    begin
      KaufDatum := GetKaufDatum(m);
      Tausendstel := GetTausendstel(m);
      TTagesKosten(ActWohnungen.objects[m]).Clear;
      for n := 0 to pred(ActPersonen.count) do
      begin
        TestDate := date2long(copy(ActPersonen[n], 1, 8));
        if (TestDate >= KaufDatum) then
        begin
          if MitMieter then
          begin
            if (GetPersonen(m, n) > 0) then
              TTagesKosten(ActWohnungen.objects[m]).Werte[n] :=
                GetKosten(KList, 'Versicherungen', TestDate) * Tausendstel;
          end
          else
          begin
            if (GetPersonen(m, n) = 0) then
              TTagesKosten(ActWohnungen.objects[m]).Werte[n] :=
                GetKosten(KList, 'Versicherungen', TestDate) * Tausendstel;
          end;
        end;
      end;
    end;

    // Auswertung
    for n := 0 to pred(ActWohnungen.count) do
    begin
      KList := GetKontoWohnung(n);
      TagesKosten := TTagesKosten(ActWohnungen.objects[n]);
      for m := 0 to pred(TagesKosten.MonthCount) do
      begin
        VerteilungsBetrag := TagesKosten.MonatsSumme(m);
        if (VerteilungsBetrag <> 0.0) then
        begin
          BuchungsString := 'C Versicherungen;' + 'Versicherungen;' +
            'Versicherungen;' + long2date(TagesKosten.Monate[m].FirstDayInMonth)
            + ';' + format('%.18f', [VerteilungsBetrag]) + ' €;-;' +
            long2date(TagesKosten.KostenStart(m)) + '-' +
            long2date(TagesKosten.KostenEnde(m));
          BuchungsSatz := TBuchung.Create;
          BuchungsSatz.LoadFromString(BuchungsString);
          BuchungsSatz.UmlageAufMieter := MitMieter;
          KList.add(BuchungsSatz);
          ListBox2.Items.add(BuchungsString);
        end;
      end;
      KList.Sort(BuchungSort);
    end;
  end;

begin
  // Versicherungen
  Berechne(true);
  Berechne(false);
end;

procedure TFormObjektverwaltung.ComboBox3Change(Sender: TObject);
var
  kosten: extended;
  KList: TList;
  TestDate: longword;
  n: integer;
  Kostenart: string;
begin
  // Gesamt-Kosten berechnen
  Kostenart := ComboBox3.Text;
  kosten := 0.0;
  KList := GetKonto('Kosten');
  for n := 0 to pred(ActPersonen.count) do
  begin
    TestDate := date2long(copy(ActPersonen[n], 1, 8));
    kosten := kosten + GetKosten(KList, Kostenart, TestDate);
  end;
  Label2.caption :=
    (format('Kosten "' + Kostenart + '" ''' + ZeitraumVomEdit.Text +
    ': %.18f €', [kosten]));
end;

function TFormObjektverwaltung.GetKaufDatum(Wohnung: integer): longint;
begin
  result := date2long(ProjektData.ReadString(ActWohnungen[Wohnung],
    'Kauf', ''));
end;

function TFormObjektverwaltung.GetTausendstel(Wohnung: integer): extended;
begin
  result := strtoint(ProjektData.ReadString(ActWohnungen[Wohnung],
    'tausendstel', '')) / 1000.0;
end;

function TFormObjektverwaltung.GetPersonen(Wohnung, Tag: integer): integer;
var
  MyStr: string;
  n, k: integer;
begin
  MyStr := ActPersonen[Tag];
  k := pos('=', MyStr);
  delete(MyStr, 1, k);
  for n := 0 to pred(Wohnung) do
  begin
    k := pos('|', MyStr);
    delete(MyStr, 1, k);
  end;
  k := pos('|', MyStr);
  result := strtoint(copy(MyStr, 1, pred(k)));
end;

function TFormObjektverwaltung.VermieteterZeitraum(Wohnung: integer): integer;
var
  n: integer;
begin
  result := 0;
  for n := 0 to pred(ActPersonen.count) do
    if GetPersonen(Wohnung, n) > 0 then
      inc(result);
end;

procedure TFormObjektverwaltung.StromButtonClick(Sender: TObject);

  procedure Berechnen(MitMieter: Boolean);
  var
    n, m: integer;
    KList: TList;
    TestDate: longint;
    VerteilungsBetrag: extended;
    BuchungsString: string;
    BuchungsSatz: TBuchung;
    KaufDatum: longint;
    TagesKosten: TTagesKosten;
  begin
    KList := GetKonto('Kosten');
    for m := 0 to pred(ActWohnungen.count) do
    begin
      KaufDatum := GetKaufDatum(m);
      TTagesKosten(ActWohnungen.objects[m]).Clear;
      if not(ProjektData.ReadString(ActWohnungen[m], 'Strom', '') = 'NEIN') then
        for n := 0 to pred(ActPersonen.count) do
        begin
          TestDate := date2long(copy(ActPersonen[n], 1, 8));
          if (TestDate >= KaufDatum) then
          begin
            if MitMieter then
            begin
              if GetPersonen(m, n) > 0 then
                TTagesKosten(ActWohnungen.objects[m]).Werte[n] :=
                  GetKosten(KList, 'Strom', TestDate) / 3.0;
            end
            else
            begin
              if GetPersonen(m, n) = 0 then
                TTagesKosten(ActWohnungen.objects[m]).Werte[n] :=
                  GetKosten(KList, 'Strom', TestDate) / 3.0;
            end;
          end;
        end;
    end;

    // Auswertung
    for n := 0 to pred(ActWohnungen.count) do
    begin
      KList := GetKontoWohnung(n);
      TagesKosten := TTagesKosten(ActWohnungen.objects[n]);
      for m := 0 to pred(TagesKosten.MonthCount) do
      begin
        VerteilungsBetrag := TagesKosten.MonatsSumme(m);
        if (VerteilungsBetrag <> 0.0) then
        begin
          BuchungsString := 'C Strom;' + 'Strom;' + 'Strom;' +
            long2date(TagesKosten.Monate[m].FirstDayInMonth) + ';' +
            format('%.18f', [VerteilungsBetrag]) + ' €;-;' +
            long2date(TagesKosten.KostenStart(m)) + '-' +
            long2date(TagesKosten.KostenEnde(m));
          BuchungsSatz := TBuchung.Create;
          BuchungsSatz.LoadFromString(BuchungsString);
          BuchungsSatz.UmlageAufMieter := MitMieter;
          KList.add(BuchungsSatz);
          ListBox2.Items.add(BuchungsString);
        end;
      end;
      KList.Sort(BuchungSort);
    end;
  end;

begin
  // Strom
  Berechnen(true);
  Berechnen(false);

end;

procedure TFormObjektverwaltung.Kabel;

  procedure Berechnen(MitMieter: Boolean);
  var
    n, m: integer;
    KList: TList;
    TestDate: longint;
    VerteilungsBetrag: extended;
    BuchungsString: string;
    BuchungsSatz: TBuchung;
    KaufDatum: longint;
    TagesKosten: TTagesKosten;
  begin
    KList := GetKonto('Kosten');
    for m := 0 to pred(ActWohnungen.count) do
    begin
      KaufDatum := GetKaufDatum(m);
      TTagesKosten(ActWohnungen.objects[m]).Clear;
      if not(ProjektData.ReadString(ActWohnungen[m], 'Kabel', '') = 'NEIN') then
        for n := 0 to pred(ActPersonen.count) do
        begin
          TestDate := date2long(copy(ActPersonen[n], 1, 8));
          if (TestDate >= KaufDatum) then
          begin
            if MitMieter then
            begin
              if GetPersonen(m, n) > 0 then
                TTagesKosten(ActWohnungen.objects[m]).Werte[n] :=
                  GetKosten(KList, 'Kabel', TestDate) / 3.0;
            end
            else
            begin
              if GetPersonen(m, n) = 0 then
                TTagesKosten(ActWohnungen.objects[m]).Werte[n] :=
                  GetKosten(KList, 'Kabel', TestDate) / 3.0;
            end;
          end;
        end;
    end;

    // Auswertung
    for n := 0 to pred(ActWohnungen.count) do
    begin
      KList := GetKontoWohnung(n);
      TagesKosten := TTagesKosten(ActWohnungen.objects[n]);
      for m := 0 to pred(TagesKosten.MonthCount) do
      begin
        VerteilungsBetrag := TagesKosten.MonatsSumme(m);
        if (VerteilungsBetrag <> 0.0) then
        begin
          BuchungsString := 'C Kabel;' + 'Kabel;' + 'Kabel;' +
            long2date(TagesKosten.Monate[m].FirstDayInMonth) + ';' +
            format('%.18f', [VerteilungsBetrag]) + ' €;-;' +
            long2date(TagesKosten.KostenStart(m)) + '-' +
            long2date(TagesKosten.KostenEnde(m));
          BuchungsSatz := TBuchung.Create;
          BuchungsSatz.LoadFromString(BuchungsString);
          BuchungsSatz.UmlageAufMieter := MitMieter;
          KList.add(BuchungsSatz);
          ListBox2.Items.add(BuchungsString);
        end;
      end;
      KList.Sort(BuchungSort);
    end;
  end;

begin
  // Kabel
  Berechnen(true);
  Berechnen(false);

end;

procedure TFormObjektverwaltung.RuecklageButtonClick(Sender: TObject);
var
  n, m: integer;
  KList: TList;
  TestDate: longint;
  VerteilungsBetrag: extended;
  BuchungsString: string;
  BuchungsSatz: TBuchung;
  KaufDatum: longint;
  Tausendstel: extended;
  TagesKosten: TTagesKosten;
begin
  // Versicherungen
  KList := GetKonto('Kosten');
  for m := 0 to pred(ActWohnungen.count) do
  begin
    KaufDatum := GetKaufDatum(m);
    Tausendstel := GetTausendstel(m);
    TTagesKosten(ActWohnungen.objects[m]).Clear;
    for n := 0 to pred(ActPersonen.count) do
    begin
      TestDate := date2long(copy(ActPersonen[n], 1, 8));
      if (TestDate >= KaufDatum) then
        TTagesKosten(ActWohnungen.objects[m]).Werte[n] :=
          GetKosten(KList, 'Rücklage', TestDate) * Tausendstel;
    end;
  end;

  // Auswertung
  for n := 0 to pred(ActWohnungen.count) do
  begin
    KList := GetKontoWohnung(n);
    TagesKosten := TTagesKosten(ActWohnungen.objects[n]);
    for m := 0 to pred(TagesKosten.MonthCount) do
    begin
      VerteilungsBetrag := TagesKosten.MonatsSumme(m);
      if (VerteilungsBetrag <> 0.0) then
      begin
        BuchungsString := 'C Rücklage;' + 'Rücklage;' + 'Rücklage;' +
          long2date(TagesKosten.Monate[m].FirstDayInMonth) + ';' +
          format('%.18f', [VerteilungsBetrag]) + ' €;-;' +
          long2date(TagesKosten.KostenStart(m)) + '-' +
          long2date(TagesKosten.KostenEnde(m));
        if assigned(KList) then
        begin
          BuchungsSatz := TBuchung.Create;
          BuchungsSatz.LoadFromString(BuchungsString);
          KList.add(BuchungsSatz);
        end;
        ListBox2.Items.add(BuchungsString);
      end;
    end;
    if assigned(KList) then
      KList.Sort(BuchungSort);
  end;
end;

procedure TFormObjektverwaltung.BankButtonClick(Sender: TObject);
var
  n, m: integer;
  KList: TList;
  TestDate: longint;
  VerteilungsBetrag: extended;
  BuchungsString: string;
  BuchungsSatz: TBuchung;
  KaufDatum: longint;
  TagesKosten: TTagesKosten;
begin
  // Versicherungen
  KList := GetKonto('Kosten');
  for m := 0 to pred(ActWohnungen.count) do
  begin
    KaufDatum := GetKaufDatum(m);
    TTagesKosten(ActWohnungen.objects[m]).Clear;
    if not(ProjektData.ReadString(ActWohnungen[m], 'Bank', '') = 'NEIN') then
      for n := 0 to pred(ActPersonen.count) do
      begin
        TestDate := date2long(copy(ActPersonen[n], 1, 8));
        if (TestDate >= KaufDatum) then
          TTagesKosten(ActWohnungen.objects[m]).Werte[n] :=
            GetKosten(KList, 'Bank', TestDate) / 3.0;
      end;
  end;

  // Auswertung
  for n := 0 to pred(ActWohnungen.count) do
  begin
    KList := GetKontoWohnung(n);
    TagesKosten := TTagesKosten(ActWohnungen.objects[n]);
    for m := 0 to pred(TagesKosten.MonthCount) do
    begin
      VerteilungsBetrag := TTagesKosten(ActWohnungen.objects[n]).MonatsSumme(m);
      if (VerteilungsBetrag <> 0.0) then
      begin
        BuchungsString := 'C Bank;' + 'Zinsen/Kontoführung;' + 'Bank;' +
          long2date(TagesKosten.Monate[m].FirstDayInMonth) + ';' +
          format('%.18f', [VerteilungsBetrag]) + ' €;-;' +
          long2date(TagesKosten.KostenStart(m)) + '-' +
          long2date(TagesKosten.KostenEnde(m));
        if assigned(KList) then
        begin
          BuchungsSatz := TBuchung.Create;
          BuchungsSatz.LoadFromString(BuchungsString);
          KList.add(BuchungsSatz);
        end;
        ListBox2.Items.add(BuchungsString);
      end;
    end;
    if assigned(KList) then
      KList.Sort(BuchungSort);
  end;
end;

procedure TFormObjektverwaltung.WaermeButtonClick(Sender: TObject);
begin
  VerbrauchAbrechnen('Heizung', 'E');
end;

procedure TFormObjektverwaltung.WarmWasserButtonClick(Sender: TObject);
begin
  VerbrauchAbrechnen('Warmwasser', 'm³');
end;

procedure TFormObjektverwaltung.WasserButtonClick(Sender: TObject);
begin
  VerbrauchAbrechnen('Wasser', 'm³');
end;

procedure TFormObjektverwaltung.AllesButtonClick(Sender: TObject);
begin
  screen.Cursor := crHourGlass;
  ListBox2.Items.BeginUpdate;
  LadenButtonClick(Sender);
  if checkBoxMuell.checked then
   VerteileMuell;
  VerbrauchAbrechnen('Wasser', 'm³');
  VersicherungButtonClick(Sender);
  VerbrauchAbrechnen('Heizung', 'E');
  StromButtonClick(Sender);
  ReinigungButtonClick(Sender);
  Kabel;
  RuecklageButtonClick(Sender);
  BankButtonClick(Sender);
  VerbrauchAbrechnen('Warmwasser', 'm³');
  SonstigeButtonClick(Sender);
  UebersichtButtonClick(Sender);
  ListBox2.Items.EndUpdate;
  screen.Cursor := crDefault;
end;

procedure TFormObjektverwaltung.UebersichtButtonClick(Sender: TObject);
var
  n, m: integer;
  FirstDay: longint;
  LastDay: longint;
  KList: TList;
  HeaderZeile: string;
  kosten: extended;
  KostenSumme: extended;
  TestDate: longint;
  KostenZahl: TKostenZahl;
  SaldenAltDatum: TAnfixDate;

  procedure KontoAuszug;
  var
    n: integer;
  begin
    if assigned(KList) then
      with ListBox2.Items do
      begin
        add('                                                           BE#=Belegnummer der Anlage  MU=auf Mieter umlagefähig? ("*"=JA)');
        add(TBuchung(KList[0]).Footer);
        add(TBuchung(KList[0]).Header);
        add(TBuchung(KList[0]).Trenner);
        for n := 0 to pred(KList.count) do
        begin
          with TBuchung(KList[n]) do
          begin
            // c)
            if DateCollision(ZeitraumVon, ZeitraumBis, FirstDay, LastDay) then

              // b)           if (ZeitraumVon<=LastDay) and (ZeitraumBis>=FirstDay) then
              // a)           if DateInside(ZeitraumVon, Firstday, LastDay) or DateInside(ZeitraumBis, Firstday, LastDay) then
              add(SaveToTable);
          end;
        end;
        add(TBuchung(KList[0]).Footer);
      end;
  end;

// nun eine einzelne Wohung abrechnen
  procedure Abrechnung(Wohnung: integer);
  var
    KostenImMonat: TTagesKosten;
    KostenUmlageFaehig: TTagesKosten;
    KostenNichtUmlageFaehig: TTagesKosten;
    EinzahlungenEigentuemer: TTagesKosten;
    EinzahlungenMieter: TTagesKosten;
    KostenImJahr: extended;
    ZahlungenMieter: extended;
    ZahlungenEigentuemer: extended;
    ZahlungenGesamt: extended;
    n, m: integer;
    Ruecklage: extended;
    EndKontoStand: extended;
    _KostenUmlageFaehig: extended;
    _KostenNichtUmlageFaehig: extended;
    WertIndex: integer;
    KostenArten: TStringList;
    KostenZahl: TKostenZahl;
    GesamtKosten: extended;
    GesamtKostenMieter: extended;
    MieterKonto: extended;
    KostenDieserArt: extended;

    ZeitraumLaenge: extended;
    NeueNebenkostenMieter: extended;
    NeueNebenkostenEigentuemer: extended;

    EinzahlungenTexte: TStringList;
    _S_EinzahlungenEigentuemer: extended;
    _S_EinzahlungenMieter: extended;

    KostenInfo: string;
    _ruecklage: extended;

  begin
    _KostenUmlageFaehig := 0.0;
    _KostenNichtUmlageFaehig := 0.0;
    Ruecklage := 0.0;
    ZahlungenMieter := 0.0;
    ZahlungenEigentuemer := 0.0;
    KostenImMonat := TTagesKosten.Create(date2long(ZeitraumVomEdit.Text),
      date2long(ZeitraumBisEdit.Text));
    KostenUmlageFaehig := TTagesKosten.Create(date2long(ZeitraumVomEdit.Text),
      date2long(ZeitraumBisEdit.Text));
    KostenNichtUmlageFaehig := TTagesKosten.Create
      (date2long(ZeitraumVomEdit.Text), date2long(ZeitraumBisEdit.Text));
    EinzahlungenEigentuemer := TTagesKosten.Create
      (date2long(ZeitraumVomEdit.Text), date2long(ZeitraumBisEdit.Text));
    EinzahlungenMieter := TTagesKosten.Create(date2long(ZeitraumVomEdit.Text),
      date2long(ZeitraumBisEdit.Text));
    KostenArten := TStringList.Create;
    EinzahlungenTexte := TStringList.Create;

    ZeitraumLaenge := VermieteterZeitraum(Wohnung);
    if (ZeitraumLaenge = 0.0) then // unvermietet
      ZeitraumLaenge := KostenImMonat.DayCount;

    for n := 0 to pred(KList.count) do
    begin

      with TBuchung(KList[n]) do
      begin

        if (Waehrung <> '€') then
          continue;

        WertIndex := KostenImMonat.IndexOf(Buchungstag);
        if (WertIndex = -1) then
        begin
          // Dieser Tag kommt in den Kosten gar nicht vor!!!
        end
        else
        begin

          if (Kostenart = 'Nebenkosten') then
          begin

            //
            // hey, dies sind Einzahlungen / Rückerstattungen / Nachforderungen
            //

            if (Zweck = 'Mieter') then
            begin
              ZahlungenMieter := ZahlungenMieter + Betrag;
              EinzahlungenMieter.Werte[WertIndex] := EinzahlungenMieter.Werte
                [WertIndex] + Betrag;
            end
            else
            begin
              ZahlungenEigentuemer := ZahlungenEigentuemer + Betrag;
              EinzahlungenEigentuemer.Werte[WertIndex] :=
                EinzahlungenEigentuemer.Werte[WertIndex] + Betrag;
            end;

            EinzahlungenTexte.add(SaveToTable);

          end
          else
          begin
            m := KostenArten.IndexOf(Kostenart);
            if m = -1 then
            begin
              KostenZahl := TKostenZahl.Create;
              KostenZahl.Wert := Betrag;
              KostenZahl.UmlageAufMieter := UmlageAufMieter;
              KostenArten.AddObject(Kostenart, KostenZahl);
            end
            else
            begin
              TKostenZahl(KostenArten.objects[m]).Wert :=
                TKostenZahl(KostenArten.objects[m]).Wert + Betrag;
            end;

            if UmlageAufMieter then
              KostenUmlageFaehig.Werte[WertIndex] := KostenUmlageFaehig.Werte
                [WertIndex] + Betrag
            else
              KostenNichtUmlageFaehig.Werte[WertIndex] :=
                KostenNichtUmlageFaehig.Werte[WertIndex] + Betrag;

            KostenImMonat.Werte[WertIndex] := KostenImMonat.Werte
              [WertIndex] + Betrag;
            if (Kostenart = 'Rücklage') then
              Ruecklage := Ruecklage - Betrag;
          end;
        end;
      end;
    end;
    ZahlungenGesamt := ZahlungenMieter + ZahlungenEigentuemer;
    KostenArten.Sort;

    // Kosten zu den einzelnen Monaten zusammenfassen
    with ListBox2.Items do
    begin

      add('');
      EigentuemerInfo.add('');
      GesamtKosten := 0.0;
      GesamtKostenMieter := 0.0;
      for n := 0 to pred(KostenArten.count) do
      begin
        m := KostenArtenGlobal.IndexOf(KostenArten[n]);

        if (m = -1) then
          KostenInfo := format('%20s %10.2f €',
            [KostenArten[n], TKostenZahl(KostenArten.objects[n]).Wert])
        else
        begin

          KostenDieserArt := TKostenZahl(KostenArtenGlobal.objects[m]).Wert;
          if (KostenDieserArt = 0) then
          begin
            KostenInfo := format('%20s %10.2f € (100.0%%)',
              [KostenArten[n], TKostenZahl(KostenArten.objects[n]).Wert]);
          end
          else
          begin
            KostenInfo := format('%20s %10.2f € (%4.1f%%)',
              [KostenArten[n], TKostenZahl(KostenArten.objects[n]).Wert,
              (TKostenZahl(KostenArten.objects[n]).Wert / KostenDieserArt
              * 100.0)]);
          end;
        end;

        add(KostenInfo);
        EigentuemerInfo.add(KostenInfo);
        if TKostenZahl(KostenArten.objects[n]).UmlageAufMieter then
        begin
          MieterInfo.add(KostenInfo);
          GesamtKostenMieter := GesamtKostenMieter +
            TKostenZahl(KostenArten.objects[n]).Wert;
        end;

        GesamtKosten := GesamtKosten + TKostenZahl(KostenArten.objects[n]).Wert;
      end;
      add('');
      EigentuemerInfo.add('');
      add(format('%20s %10.2f €', ['Summe', GesamtKosten]));
      EigentuemerInfo.add(format('%20s %10.2f €', ['Summe', -GesamtKosten]));

      MieterInfo.add('');
      MieterInfo.add(format('%20s %10.2f €', ['Summe', GesamtKostenMieter]));

      // Einzahlungen in einer Übersicht ausgeben
      add('');
      add(' Ihre Einzahlungen:');
      add('*------------------------------------------------------------------*');
      add('|Buchungstag |Einzahlungsbetrag|Eigentümer-Anteil|Mieter-Anteil    |');
      add('+------------------------------------------------------------------+');

      MieterInfo.add('');
      MieterInfo.add('2) Ihre Einzahlungen:');
      MieterInfo.add('*------------------------------*');
      MieterInfo.add('|Buchungstag |Betrag           |');
      MieterInfo.add('+------------------------------+');

      _S_EinzahlungenEigentuemer := 0.0;
      _S_EinzahlungenMieter := 0.0;
      for n := 0 to pred(EinzahlungenMieter.DayCount) do
      begin
        if (EinzahlungenMieter.Werte[n] <> 0.0) or
          (EinzahlungenEigentuemer.Werte[n] <> 0.0) then
        begin

          if EinzahlungenMieter.Werte[n] <> 0.0 then
          begin
            MieterInfo.add(format('|  %s|  %12.2f €|',
              [long2date(EinzahlungenMieter.DatumAt(n)),
              EinzahlungenMieter.Werte[n]]));
          end;

          add(format('|  %s|  %13.2f €|  %13.2f €|  %13.2f €|',
            [long2date(EinzahlungenMieter.DatumAt(n)),

            EinzahlungenMieter.Werte[n] + EinzahlungenEigentuemer.Werte[n],
            EinzahlungenEigentuemer.Werte[n], EinzahlungenMieter.Werte[n]]));

          _S_EinzahlungenEigentuemer := _S_EinzahlungenEigentuemer +
            EinzahlungenEigentuemer.Werte[n];
          _S_EinzahlungenMieter := _S_EinzahlungenMieter +
            EinzahlungenMieter.Werte[n];

        end;
      end;
      add('+------------------------------------------------------------------+');
      add(format('|       Summe|  %13.2f €|  %13.2f €|  %13.2f €|',
        [_S_EinzahlungenMieter + _S_EinzahlungenEigentuemer,
        _S_EinzahlungenEigentuemer, _S_EinzahlungenMieter]));
      add('*------------------------------------------------------------------*');
      add('');

      MieterInfo.add('+------------------------------+');
      MieterInfo.add(format('|       Summe|  %12.2f €|',
        [_S_EinzahlungenMieter]));
      MieterInfo.add('*------------------------------*');
      MieterInfo.add('');

      // Rücklage
      add('');
      add(' Ihr Anteil an der gebildeten Rücklage:');
      add('*----------------------------------------*');

      add(format('|Übertrag vom %s|%14.2f €|', [long2date(SaldenAltDatum),
        SaldenAlt.Werte[Wohnung].Ruecklage]));

      n := KostenArten.IndexOf('Rücklage');

      if (n = -1) then
      begin
        SaldenNeu.Werte[Wohnung].Ruecklage := SaldenAlt.Werte[Wohnung]
          .Ruecklage;
        _ruecklage := 0.0;
      end
      else
      begin
        _ruecklage := TKostenZahl(KostenArten.objects[n]).Wert;
        add(format('|  ' + long2date(FirstDay) + '-' + long2date(LastDay) +
          '|%14.2f €|', [-TKostenZahl(KostenArten.objects[n]).Wert]));
        SaldenNeu.Werte[Wohnung].Ruecklage := SaldenAlt.Werte[Wohnung].Ruecklage
          - TKostenZahl(KostenArten.objects[n]).Wert;
      end;

      add('+----------------------------------------+');
      add(format('| Rücklage am %s|%14.2f €|', [long2date(LastDay),
        SaldenNeu.Werte[Wohnung].Ruecklage]));
      add('*----------------------------------------*');
      add('');

      // Nebenkosten auf den Monat übertragen
      KostenImJahr := 0.0;
      add(' Die Nebenkosten:');
      add('*----------------------------------------------------------------------*');
      add('|Zeitraum             |Kosten Summe  |EigentümerAnteil|Mieter-Anteil   |');
      add('|---------------------+--------------+----------------+----------------|');

      for n := 0 to pred(KostenImMonat.MonthCount) do
      begin

        add('|' + long2date(KostenImMonat.Monate[n].FirstDayInMonth) + '-' +
          long2date(KostenImMonat.Monate[n].LastDayInMonth) +
          format('|%12.2f €|%14.2f €|%14.2f €|', [KostenImMonat.MonatsSumme(n),
          KostenNichtUmlageFaehig.MonatsSumme(n),
          KostenUmlageFaehig.MonatsSumme(n)]));
        KostenImJahr := KostenImJahr + KostenImMonat.MonatsSumme(n);
        _KostenUmlageFaehig := _KostenUmlageFaehig +
          KostenUmlageFaehig.MonatsSumme(n);
        _KostenNichtUmlageFaehig := _KostenNichtUmlageFaehig +
          KostenNichtUmlageFaehig.MonatsSumme(n);
      end;
      NeueNebenkostenMieter := ((_KostenUmlageFaehig / ZeitraumLaenge) *
        365.0) / 12.0;
      NeueNebenkostenEigentuemer := ((_KostenNichtUmlageFaehig / ZeitraumLaenge)
        * 365.0) / 12.0;

      MieterInfo.add('3) Abrechnung:');
      MieterInfo.add('*---------------------------------------*');
      MieterInfo.add('|Zeitraum             |Mieter-Anteil    |');
      MieterInfo.add('+---------------------|-----------------|');

      add('|---------------------+--------------+----------------+----------------|');
      add(format('|Saldo am   %s|%12.2f €|%14.2f €|%14.2f €|',
        [long2date(SaldenAltDatum), SaldenAlt.Werte[Wohnung].SaldoEigentuemer +
        SaldenAlt.Werte[Wohnung].SaldoMieter,
        SaldenAlt.Werte[Wohnung].SaldoEigentuemer,
        SaldenAlt.Werte[Wohnung].SaldoMieter]));
      MieterInfo.add(format('|Saldo am   %s|%14.2f €|',
        [long2date(SaldenAltDatum), SaldenAlt.Werte[Wohnung].SaldoMieter]));

      add('|' + long2date(FirstDay) + '-' + long2date(LastDay) +

        format('|%12.2f €|%14.2f €|%14.2f €|', [KostenImJahr,
        _KostenNichtUmlageFaehig, _KostenUmlageFaehig

        ]));

      MieterInfo.add('|' + long2date(FirstDay) + '-' + long2date(LastDay) +

        format('|%14.2f €|', [_KostenUmlageFaehig

        ]));

      EigentuemerInfo.add(format('auf Mieter umgelegt%12.2f €',
        [_KostenUmlageFaehig]));
      EigentuemerInfo.add(format('Rücklage           %12.2f €', [_ruecklage]));
      EigentuemerInfo.add(format('                    ==============', []));
      EigentuemerInfo.add(format('Eigentümeranteil   %12.2f € **)',
        [-(_KostenNichtUmlageFaehig - _ruecklage)]));
      EigentuemerInfo.add('an den Kosten');

      EigentuemerInfo.add('');
      EigentuemerInfo.add
        ('**) Nachforderungen und Korrekturen der Beträge sind nur im umlagefähigen');
      EigentuemerInfo.add
        ('    Anteil der Nebenkosten zu erwarten, so dass dieser Betrag als endgültig');
      EigentuemerInfo.add('    betrachtet werden kann.');
      EigentuemerInfo.add('');
      EigentuemerInfo.add('');
      EigentuemerInfo.add
        ('2) Zinsen aus Anlage der Rücklage sind "Einkünfte aus Kapitalvermögen":');
      EigentuemerInfo.add('');

      EigentuemerInfo.add(format('Summe Rücklage     %12.2f € (Stand vom %s)',
        [SaldenNeu.Werte[Wohnung].Ruecklage, long2date(LastDay)]));
      EigentuemerInfo.add(format('                    ==============', []));
      EigentuemerInfo.add(format('Zinseinkünfte      %12.2f € **)', [0.0]));
      EigentuemerInfo.add('');
      EigentuemerInfo.add
        ('**) Kapitalanlage ist aufgrund des geringen Betrages noch nicht erfolgt.');
      EigentuemerInfo.add('');

      add('|Einzahlungen         ' + format('|%12.2f €|%14.2f €|%14.2f €|',
        [ZahlungenGesamt, ZahlungenEigentuemer, ZahlungenMieter]));

      MieterInfo.add('|Einzahlungen         ' + format('|%14.2f €|',
        [ZahlungenMieter]));

      add('|=====================+==============+================+================|');

      MieterInfo.add('*=======================================*');

      // Salden speichern
      SaldenNeu.Werte[Wohnung].SaldoEigentuemer := ZahlungenEigentuemer +
        _KostenNichtUmlageFaehig + SaldenAlt.Werte[Wohnung].SaldoEigentuemer;
      SaldenNeu.Werte[Wohnung].SaldoMieter := ZahlungenMieter +
        _KostenUmlageFaehig + SaldenAlt.Werte[Wohnung].SaldoMieter;

      //
      // ZahlungenGesamt+KostenImJahr+SaldenAlt.Werte[Wohnung].SaldoEigentuemer+SaldenAlt.Werte[Wohnung].SaldoMieter
      // ==
      // SaldenNeu.Werte[Wohnung].SaldoEigentuemer+SaldenNeu.Werte[Wohnung].SaldoMieter
      //

      add(format('|Saldo am   %s|%12.2f €|%14.2f €|%14.2f €|',
        [long2date(DatePlus(date2long(ZeitraumBisEdit.Text), 1)),
        SaldenNeu.Werte[Wohnung].SaldoEigentuemer + SaldenNeu.Werte[Wohnung]
        .SaldoMieter, SaldenNeu.Werte[Wohnung].SaldoEigentuemer,
        SaldenNeu.Werte[Wohnung].SaldoMieter]));

      MieterInfo.add(format('|Saldo am   %s|%14.2f €|',
        [long2date(DatePlus(date2long(ZeitraumBisEdit.Text), 1)),

        SaldenNeu.Werte[Wohnung].SaldoMieter]));

      add('*----------------------------------------------------------------------*');
      MieterInfo.add('*---------------------------------------*');

      add(

        '|monatlich Beträge NEU' + format('|%12.2f €|%14.2f €|%14.2f €|',
        [NeueNebenkostenMieter + NeueNebenkostenEigentuemer,
        NeueNebenkostenEigentuemer, NeueNebenkostenMieter]));

      MieterInfo.add('|monatlich Beträge NEU' +

        format('|%14.2f €|', [trunc(NeueNebenkostenMieter + 0.5) + 0.0]));

      add('*----------------------------------------------------------------------*');
      MieterInfo.add('*---------------------------------------*');

    end;
    for n := 0 to pred(KostenArten.count) do
      TKostenZahl(KostenArten.objects[n]).free;

    KostenArten.free;
    KostenImMonat.free;
    KostenUmlageFaehig.free;
    KostenNichtUmlageFaehig.free;
    EinzahlungenEigentuemer.free;
    EinzahlungenMieter.free;
    EinzahlungenTexte.free;
  end;

  procedure PersonenReport;
  var
    _LastPersonen: string;
    _ThisPersonen: string;
    n: integer;
    k, l: integer;
  begin
    with ListBox2.Items do
    begin
      add('');
      add('PERSONEN-BELEGUNG DER WOHNUNGEN');
      add('===============================');
      add('');
      for n := 0 to pred(ActWohnungen.count) do
      begin
        add('         ' + fill('| ', n) + '*' + fill('--', 10 - n) +
          ActWohnungen[n] + ' PERSONEN ANZAHL');
      end;
      add('         ' + fill('v ', ActWohnungen.count) +
        '  v----------OBJEKT PERSONEN ANZAHL');

      _LastPersonen := '';
      for n := 0 to pred(ActPersonen.count) do
      begin
        k := pos('=', ActPersonen[n]);
        l := pos('(', ActPersonen[n]);
        _ThisPersonen := copy(ActPersonen[n], succ(k), pred(l - k));
        if _ThisPersonen <> _LastPersonen then
        begin
          add(ActPersonen[n]);
          _LastPersonen := _ThisPersonen;
        end;
      end;
    end;
  end;

  procedure KontoBuchungenAufZeitraumAnpassen;
  var
    n: integer;
    StartIsInside: Boolean;
    EndIsInside: Boolean;
    AnzTageUrspruenglich: extended;
    AnzTageVerblieben: extended;
  begin
    // buchungen, die gar nicht den Zeitraum betreffen rauslassen
    // buchungen, die nur Zeitweise in den Zeitraum passen
    // den Betrag relativieren!!! (im Verhältnis zu den tagen)
    // es wird davon ausgegangen, dass sich die Kosten gleichmäßig
    // auf den gesamten angegebenen Zeitraum verteilen!
    AnzTageVerblieben := 0;

    for n := 0 to pred(KList.count) do
    begin
      with TBuchung(KList[n]) do
      begin
        StartIsInside := DateInside(ZeitraumVon, FirstDay, LastDay);
        EndIsInside := DateInside(ZeitraumBis, FirstDay, LastDay);

        if not(StartIsInside) and not(EndIsInside) then
          continue; // nicht relevant
        if StartIsInside and EndIsInside then
          continue; // vollständig drin, nix ändern!

        AnzTageUrspruenglich := Tage;

        if StartIsInside then
        begin
          AnzTageVerblieben := succ(DateDiff(ZeitraumVon, LastDay));
          ZeitraumBis := LastDay;
        end;

        if EndIsInside then
        begin
          AnzTageVerblieben := succ(DateDiff(FirstDay, ZeitraumBis));
          ZeitraumVon := FirstDay;
        end;

        Bucher := Bucher + format(' (%.2f)', [Betrag]);
        Betrag := (Betrag / AnzTageUrspruenglich) * AnzTageVerblieben;

      end;
    end;
  end;

type
  sWohnung = set of byte;

  function Verbrauch(const pKostenArt, pEinheit: string; W: sWohnung): string;
  var
    RohstoffVerbrauch: extended;
    n, m: integer;
    KList: TList;
    TestDate: TAnfixDate;
  begin
    // Verbrauch berechnen
    RohstoffVerbrauch := 0.0;
    for m := 0 to pred(ActWohnungen.count) do
      if m in W then
      begin
        KList := GetKontoWohnung(m);
        for n := 0 to pred(ActPersonen.count) do
        begin
          TestDate := date2long(copy(ActPersonen[n], 1, 8));
          RohstoffVerbrauch := RohstoffVerbrauch +
          { } GetKostenPersistent(
            { } KList,
            { } pKostenArt,
            { } TestDate);
        end;
      end;
    result := format('%8.2f %2s', [RohstoffVerbrauch,pEinheit]);

  end;

begin
  FirstDay := date2long(ZeitraumVomEdit.Text);
  LastDay := date2long(ZeitraumBisEdit.Text);
  with ListBox2.Items do
  begin
    Clear;
    add('Kosten-Abrechnung Objekt "' + ObjektName + '" vom ' +
      ZeitraumVomEdit.Text + ' bis ' + ZeitraumBisEdit.Text + ' (' +
      inttostr(ZeitRaumLength) + ' Tage)');
    add('');
    add('WOHNUNGEN');
    add('=========');
    add('');
    add('*---------------------------------------------*');
    add('|Wohnung      |Eigentümer seit|mit Tausendstel|');
    add('*-------------|---------------|---------------*');
    for n := 0 to pred(ActWohnungen.count) do
    begin
      add(format('| %s | %s    | %3.0f/1000      |', [ActWohnungen[n],
        long2date(GetKaufDatum(n)), GetTausendstel(n) * 1000.0]));
    end;
    add('*---------------------------------------------*');
    add('');

    add('VERBRÄUCHE');
    add('==========');
    add('');
    add('*-------------------------------------------------------*');
    add('|Wohnung      |Wasser (W+K) |Warmwasser   |Heizung      |');
    add('*-------------|-------------|-------------|-------------*');
    for n := 0 to pred(ActWohnungen.count) do
    begin
      add(format('| %s | %s | %s | %s |', [
        { } ActWohnungen[n],
        { } Verbrauch('Wasser', 'm³', [n]),
        { } Verbrauch('Warmwasser', 'm³', [n]),
        { } Verbrauch('Heizung', 'E', [n])
        { } ]));
    end;
    add('*-------------------------------------------------------*');
    add('');

    add('KOSTEN: ALLE KONTO-BEWEGUNGEN, BELEGE IN DER ANLAGE');
    add('===================================================');
    add('');
    KList := GetKonto('Kosten');
    KontoAuszug;
    KostenArtenGlobal.Sort;

    add('');
    add('KOSTEN: VOM ' + ZeitraumVomEdit.Text + ' bis ' + ZeitraumBisEdit.Text);
    add('=================================');
    add('');
    KostenSumme := 0.0;
    for n := 0 to pred(KostenArtenGlobal.count) do
    begin
      kosten := 0.0;
      for m := 0 to pred(ActPersonen.count) do
      begin
        TestDate := date2long(copy(ActPersonen[m], 1, 8));
        kosten := kosten + GetKosten(KList, KostenArtenGlobal[n], TestDate);
      end;

      // Globale Kosten dauerhaft speichern
      KostenZahl := TKostenZahl.Create;
      KostenZahl.Wert := kosten;
      KostenArtenGlobal.objects[n] := KostenZahl;

      KostenSumme := KostenSumme + kosten;
      ListBox2.Items.add(format('%20s %10.2f €', [KostenArtenGlobal[n],
        kosten]));
    end;
    add('');
    ListBox2.Items.add(format('%20s %10.2f €', ['Summe', KostenSumme]));
    add('');

    PersonenReport;

    SaldenAltDatum := DatePlus(date2long(ZeitraumVomEdit.Text), -1);
    SaldenAlt.LoadFromFile(ObjektPath + cSaldoPrefix + inttostr(SaldenAltDatum)
      + '.dat', CheckBox1.Checked);
    for n := 0 to pred(ActWohnungen.count) do
    begin
      HeaderZeile := ActWohnungen[n] + ' (' + ProjektData.ReadString
        (ActWohnungen[n], 'Name', '-') + ')';
      EigentuemerInfo.Clear;
      MieterInfo.Clear;

      EigentuemerInfo.add
        ('Nebenkostenbeleg nicht umlagefähiger Nebenkosten vom ' +
        ZeitraumVomEdit.Text + ' bis ' + ZeitraumBisEdit.Text + ',');
      EigentuemerInfo.add('für das Objekt "' + ObjektName + ' - ' + ActWohnungen
        [n] + ' (' + ProjektData.ReadString(ActWohnungen[n], 'Name', '-') +
        ')"' + ',');
      EigentuemerInfo.add('zur Vorlage beim Finanzamt "Steuer ' +
        copy(long2date(LastDay), 7, 4) + '"!');
      EigentuemerInfo.add('');
      EigentuemerInfo.add('1) Nebenkosten');
      EigentuemerInfo.add('');

      MieterInfo.add('Ihre Miet-Nebenkostenabrechnung, für "' + ObjektName +
        ' - ' + ActWohnungen[n] + '"');
      MieterInfo.add('');
      MieterInfo.add('1) Nebenkosten vom ' + ZeitraumVomEdit.Text + ' bis ' +
        ZeitraumBisEdit.Text + ' (' + inttostr(ZeitRaumLength) + ' Tage)');
      MieterInfo.add
        ('   Die (Prozentangabe%) gibt Ihren Anteil an den Gesamtkosten wieder.');
      MieterInfo.add('');

      add('');
      add(HeaderZeile);
      add(fill('=', length(HeaderZeile)));
      add('');
      KList := GetKontoWohnung(n);
      KontoBuchungenAufZeitraumAnpassen;
      KontoAuszug;
      Abrechnung(n);
      EigentuemerInfo.SaveToFile(ObjektPath + 'Eigentümer Info Wohnung ' +
        inttostrN(succ(n), 3) + '.txt');
      MieterInfo.SaveToFile(ObjektPath + 'Mieter Info Wohnung ' +
        inttostrN(succ(n), 3) + '.txt');
    end;
    SaldenNeu.SaveToFile(ObjektPath + cSaldoPrefix + inttostr(LastDay)
      + '.dat');
    SetFocus;
  end;
end;

procedure TFormObjektverwaltung.CopyButtonClick(Sender: TObject);
begin
  ListBox2.Items.SaveToFile(ObjektPath + ObjektName + '.txt');
  openShell(ObjektPath + ObjektName + '.txt');
end;

procedure TFormObjektverwaltung.Button2Click(Sender: TObject);
begin
  Label6.caption := inttostr(ZeitRaumLength);
end;

function TFormObjektverwaltung.ZeitRaumLength: integer;
begin
  result := succ(DateDiff(date2long(ZeitraumVomEdit.Text),
    date2long(ZeitraumBisEdit.Text)));
end;

procedure TFormObjektverwaltung.SonstigeButtonClick(Sender: TObject);
var
  n, m: integer;
  KList: TList;
  TestDate: longint;
  VerteilungsBetrag: extended;
  BuchungsString: string;
  BuchungsSatz: TBuchung;
  KaufDatum: longint;
  Tausendstel: extended;
  TagesKosten: TTagesKosten;
begin
  // Sonstige
  KList := GetKonto('Kosten');
  for m := 0 to pred(ActWohnungen.count) do
  begin
    KaufDatum := GetKaufDatum(m);
    Tausendstel := GetTausendstel(m);
    TTagesKosten(ActWohnungen.objects[m]).Clear;
    for n := 0 to pred(ActPersonen.count) do
    begin
      TestDate := date2long(copy(ActPersonen[n], 1, 8));
      if (TestDate >= KaufDatum) then
        TTagesKosten(ActWohnungen.objects[m]).Werte[n] :=
          GetKosten(KList, 'Sonstige', TestDate) * Tausendstel;
    end;
  end;

  // Auswertung
  for n := 0 to pred(ActWohnungen.count) do
  begin
    KList := GetKontoWohnung(n);
    TagesKosten := TTagesKosten(ActWohnungen.objects[n]);
    for m := 0 to pred(TagesKosten.MonthCount) do
    begin
      VerteilungsBetrag := TagesKosten.MonatsSumme(m);
      if (VerteilungsBetrag <> 0.0) then
      begin
        BuchungsString := 'C Sonstige;' + 'Sonstige;' + 'Sonstige;' +
          long2date(TagesKosten.Monate[m].FirstDayInMonth) + ';' +
          format('%.18f', [VerteilungsBetrag]) + ' €;-;' +
          long2date(TagesKosten.KostenStart(m)) + '-' +
          long2date(TagesKosten.KostenEnde(m));
        if assigned(KList) then
        begin
          BuchungsSatz := TBuchung.Create;
          BuchungsSatz.LoadFromString(BuchungsString);
          KList.add(BuchungsSatz);
        end;
        ListBox2.Items.add(BuchungsString);
      end;
    end;
    if assigned(KList) then
      KList.Sort(BuchungSort);
  end;
end;

procedure TSaldo.SaveToFile(FName: string);
var
  OutFile: file of TSaldoSpeicher;
  n: integer;
begin
  AssignFile(OutFile, FName);
  rewrite(OutFile);
  for n := 0 to pred(length(Werte)) do
    write(OutFile, Werte[n]);
  CloseFile(OutFile);
end;

procedure TSaldo.LoadFromFile(FName: string; Ausgeglichen: Boolean = false);
var
  InpFile: file of TSaldoSpeicher;
  n: integer;
begin
  if FileExists(FName) then
  begin
    AssignFile(InpFile, FName);
    reset(InpFile);
    Clear(FileSize(InpFile));
    for n := 0 to pred(length(Werte)) do
    begin
      read(InpFile, Werte[n]);
      if Ausgeglichen then
        with Werte[n] do
        begin
          SaldoEigentuemer := 0.0;
          SaldoMieter := 0.0;
        end;
    end;
    CloseFile(InpFile);
  end
  else
  begin
    ShowMessage('kein ' + FName);
  end;
end;

procedure TSaldo.Clear(NewCount: integer);
var
  n: integer;
begin
  SetLength(Werte, NewCount);
  for n := 0 to pred(NewCount) do
    with Werte[n] do
    begin
      SaldoEigentuemer := 0.0;
      SaldoMieter := 0.0;
      Ruecklage := 0.0;
    end;
end;

function TFormObjektverwaltung.ObjektPath: string;
begin
  result := MyProgramPath + ComboBox4.Text + '\';
end;

function TFormObjektverwaltung.ObjektName: string;
begin
  result := copy(ComboBox4.Text, succ(pos(' ', ComboBox4.Text)), MaxInt);
end;

procedure TFormObjektverwaltung.Button3Click(Sender: TObject);
const
  cEuroFixing = 1.95583;
var
  SaldenS: TStringList;
  KostenS: TStringList;

  function euro(r: real): real;
  begin
    euro := round((r / cEuroFixing) * 100.0) / 100.0;
  end;

  procedure SaldenUmstellung(FName: string);
  var
    SaldenF: TSaldo;
    n: integer;
  begin
    SaldenF := TSaldo.Create;
    with SaldenF do
    begin
      LoadFromFile(FName);
      for n := low(Werte) to high(Werte) do
        with Werte[n] do
        begin
          SaldoEigentuemer := SaldoEigentuemer / cEuroFixing;
          SaldoMieter := SaldoMieter / cEuroFixing;
          Ruecklage := Ruecklage / cEuroFixing;
        end;
      SaveToFile(FName);
    end;
    SaldenF.free;
  end;

  procedure Kostenumstellung(FName: string);
  var
    kosten: TStringList;
    n, k, p: integer;
    DieserPreis: string;
    Wert: double;
  begin
    kosten := TStringList.Create;
    kosten.LoadFromFile(FName);
    for n := 0 to pred(kosten.count) do
    begin

      //
      DieserPreis := cutblank(Nextp(kosten[n], ';', 4));
      if pos('DM', DieserPreis) > 0 then
      begin

        p := CharCount('.', DieserPreis);
        case p of
          0:
            ;
          1:
            ;
        else
          ShowMessage(FName + #13 + DieserPreis + #13 + inttostr(succ(n)));
        end;

        // Wert ermitteln
        k := pos(' ', DieserPreis);
        if (k = 0) then
          ShowMessage('Panic!');
        Wert := StrToDouble(copy(DieserPreis, 1, pred(k)));

        // Wert umrechnen
        Wert := euro(Wert);
        DieserPreis := format('%.2f €', [Wert]);

        kosten[n] :=
         {} Nextp(kosten[n], ';', 0) + ';' +
         {} Nextp(kosten[n], ';', 1) + ';' +
          {} Nextp(kosten[n], ';', 2) + ';' +
          {} Nextp(kosten[n], ';', 3) + ';' +
          {} DieserPreis + ';' +
          {} Nextp(kosten[n], ';', 5) + ';' +
          {} Nextp(kosten[n], ';', 6);
      end;

    end;
    kosten.SaveToFile(FName);
    kosten.free;
  end;

var
  n: integer;

begin

  SaldenS := TStringList.Create;
  dir(ObjektPath + cSaldoPrefix + '*.dat', SaldenS, false);
  for n := 0 to pred(SaldenS.count) do
    SaldenUmstellung(ObjektPath + SaldenS[n]);
  SaldenS.free;

  KostenS := TStringList.Create;
  dir(ObjektPath + '*.konto', KostenS, false);
  for n := 0 to pred(KostenS.count) do
    Kostenumstellung(ObjektPath + KostenS[n]);
  KostenS.free;

end;

procedure TFormObjektverwaltung.Button4Click(Sender: TObject);

  procedure SaldenReport(FName: string);
  var
    SaldenF: TSaldo;
    n: integer;
  begin
    ListBox2.Items.add(fill('-', 47));
    ListBox2.Items.add('* ' + bstr(ExtractFileName(FName), 45) + '*');
    ListBox2.Items.add(fill('-', 47));
    ListBox2.Items.add
      ('| Eigentümer         | Mieter             | Rücklage            |');
    ListBox2.Items.add(fill('-', 47));
    SaldenF := TSaldo.Create;
    with SaldenF do
    begin
      LoadFromFile(FName);
      for n := low(Werte) to high(Werte) do
        with Werte[n] do
        begin
          ListBox2.Items.add(format('| %18.2f €| %18.2f €| %18.2f €|',
            [SaldoEigentuemer, SaldoMieter, Ruecklage]));
        end;
    end;
    SaldenF.free;
  end;

var
  SaldenS: TStringList;
  n: integer;
begin
  ListBox2.Clear;
  SaldenS := TStringList.Create;
  dir(ObjektPath + cSaldoPrefix + '*.dat', SaldenS, false);
  SaldenS.Sort;
  for n := 0 to pred(SaldenS.count) do
    SaldenReport(ObjektPath + SaldenS[n]);
  SaldenS.free;
end;

procedure TFormObjektverwaltung.ReinigungButtonClick(Sender: TObject);

  procedure Berechnen(MitMieter: Boolean);
  var
    n, m: integer;
    KList: TList;
    TestDate: longint;
    VerteilungsBetrag: extended;
    BuchungsString: string;
    BuchungsSatz: TBuchung;
    KaufDatum: longint;
    TagesKosten: TTagesKosten;
  begin
    KList := GetKonto('Kosten');
    for m := 0 to pred(ActWohnungen.count) do
    begin
      KaufDatum := GetKaufDatum(m);
      TTagesKosten(ActWohnungen.objects[m]).Clear;
      if not(ProjektData.ReadString(ActWohnungen[m], 'Reinigung', '') = 'NEIN')
      then
        for n := 0 to pred(ActPersonen.count) do
        begin
          TestDate := date2long(copy(ActPersonen[n], 1, 8));
          if (TestDate >= KaufDatum) then
          begin
            if MitMieter then
            begin
              if GetPersonen(m, n) > 0 then
                TTagesKosten(ActWohnungen.objects[m]).Werte[n] :=
                  GetKosten(KList, 'Reinigung', TestDate) / 3.0;
            end
            else
            begin
              if GetPersonen(m, n) = 0 then
                TTagesKosten(ActWohnungen.objects[m]).Werte[n] :=
                  GetKosten(KList, 'Reinigung', TestDate) / 3.0;
            end;
          end;
        end;
    end;

    // Auswertung
    for n := 0 to pred(ActWohnungen.count) do
    begin
      KList := GetKontoWohnung(n);
      TagesKosten := TTagesKosten(ActWohnungen.objects[n]);
      for m := 0 to pred(TagesKosten.MonthCount) do
      begin
        VerteilungsBetrag := TagesKosten.MonatsSumme(m);
        if (VerteilungsBetrag <> 0.0) then
        begin
          BuchungsString := 'C Reinigung;' + 'Reinigung;' + 'Reinigung;' +
            long2date(TagesKosten.Monate[m].FirstDayInMonth) + ';' +
            format('%.18f', [VerteilungsBetrag]) + ' €;-;' +
            long2date(TagesKosten.KostenStart(m)) + '-' +
            long2date(TagesKosten.KostenEnde(m));
          BuchungsSatz := TBuchung.Create;
          BuchungsSatz.LoadFromString(BuchungsString);
          BuchungsSatz.UmlageAufMieter := MitMieter;
          KList.add(BuchungsSatz);
          ListBox2.Items.add(BuchungsString);
        end;
      end;
      KList.Sort(BuchungSort);
    end;
  end;

begin
  // Reinigung
  Berechnen(true);
  Berechnen(false);
end;

end.
