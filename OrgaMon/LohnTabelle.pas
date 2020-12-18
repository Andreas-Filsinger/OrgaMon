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
unit LohnTabelle;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls,
  Datenbank,
  IB_Access, IB_Components, IB_UpdateBar,
  Grids, IB_Grid;

type
  TFormLohntabelle = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Image1: TImage;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Button1: TButton;
    Edit1: TEdit;
    Panel1: TPanel;
    Edit2: TEdit;
    CheckBox1: TCheckBox;
    Panel2: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    CheckBox2: TCheckBox;
    Edit3: TEdit;
    Edit4: TEdit;
    CheckBox3: TCheckBox;
    TabSheet2: TTabSheet;
    Edit5: TEdit;
    Button2: TButton;
    ListBox1: TListBox;
    IB_QueryPERSON: TIB_Query;
    IB_QueryANSCHRIFT: TIB_Query;
    Edit6: TEdit;
    Label19: TLabel;
    TabSheet3: TTabSheet;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    IB_UpdateBar1: TIB_UpdateBar;
    CheckBox4: TCheckBox;
    Image2: TImage;
    procedure Button1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
    procedure FormActivate(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure IB_Query1ConfirmDelete(Sender: TComponent;
      var Confirmed: Boolean);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    function Verteile(r: double): string;
    function Verteile2(r: double): string;
    function Verteile4(r: double): string;
    function Arbeitszeit12(r: double): integer;
    function Arbeitszeit1(r: double): integer;
    function Arbeitszeit2(r: double): integer;
  end;

var
  FormLohntabelle: TFormLohntabelle;

implementation

uses
  globals, anfix32,
  Funktionen_Basis,
  Funktionen_Beleg,
  CareTakerClient, dbOrgaMon, wanfix32;

{$R *.DFM}

const
  cMaxValue = 400.0;

function TFormLohntabelle.Arbeitszeit1(r: double): integer;
type
  FileTypeStr = string[30];
var
  InpF: file of FileTypeStr;
  s: word;
  str: FileTypeStr;
begin
  if (r > cMaxValue) then
  begin
    result := 0;
    exit;
  end;
  s := trunc(r * 2.0);
  assignFile(inpF, DiagnosePath + 'lohntab.dat');
  reset(InpF);
  seek(inpF, s);
  read(InpF, str);
  closeFile(InpF);
  result := strtoseconds(copy(str, 1, 5));
end;

function TFormLohntabelle.Arbeitszeit2(r: double): integer;
type
  FileTypeStr = string[30];
var
  InpF: file of FileTypeStr;
  s: word;
  str: FileTypeStr;
begin
  if (r > cMaxValue) then
  begin
    result := 0;
    exit;
  end;
  s := trunc(r * 2.0);
  assignFile(inpF, DiagnosePath + 'lohntab.dat');
  reset(InpF);
  seek(inpF, s);
  read(InpF, str);
  closeFile(InpF);
  result := strtoseconds(copy(str, 9, 5));
end;

procedure TFormLohntabelle.Button1Click(Sender: TObject);
type
  FileStrType = string[30];
const
  MinArray: array[0..3] of string = (':00', ':15', ':30', ':45');
var
  TabelleOut: TStringList;
  n, m: integer;
  l1, l2: extended;
  summe: extended;
  Teilung: integer;
  OutStr: string;
  SubOutStr: string;
  FoundValue: boolean;
  MaxValue: extended;
  ZeroCount: integer;
  OutF: file of FileStrType;
  OutStr30: FileStrType;
begin
  Teilung := 4;
  MaxValue := 900.0;
  l1 := strtodouble(edit3.text) / Teilung;
  l2 := strtodouble(edit4.text) / Teilung;
  TabelleOut := TStringList.create;
  for n := 0 to trunc(MaxValue / l1) do
    for m := 0 to trunc(MaxValue / l2) do
    begin
      summe := l1 * n + l2 * m;
      if summe > MaxValue then
        continue;


      if (summe = trunc(summe)) or (summe - 0.5 = trunc(summe)) then
      begin

        ZeroCount := 0;
        if n = 0 then
          inc(ZeroCount);
        if m = 0 then
          inc(ZeroCount);

        OutStr := format('%6.2f %d %4d ', [summe, 2 - ZeroCount, abs(n - m)]) +

        inttostrn(n div Teilung, 2) + MinArray[n mod Teilung] + ' h ' +
          inttostrn(m div Teilung, 2) + MinArray[m mod Teilung] + ' h ';


        TabelleOut.add(OutStr);
      end;
    end;
  TabelleOut.sort;
  TabelleOut.SaveToFile(DiagnosePath + 'Out.0.txt');

  // remove duplicates
  for n := pred(TabelleOut.count) downto 1 do
    if copy(TabelleOut[pred(n)], 1, 6) = copy(TabelleOut[n], 1, 6) then
      TabelleOut.delete(n);

  // suche nicht mˆgliche Werte
  summe := 0.0;
  while summe < MaxValue do
  begin
    FoundValue := false;
    SubOutStr := format('%6.2f', [summe]);
    for n := 0 to pred(TabelleOut.count) do
      if pos(SubOutStr, TabelleOut[n]) = 1 then
      begin
        FoundValue := true;
        break;
      end;
    if not (FoundValue) then
      TabelleOut.add(SubOutStr + '        ---------------');
    summe := summe + 0.5;
  end;
  TabelleOut.sort;
  TabelleOut.SaveToFile(DiagnosePath + 'Out.1.txt');

  assignFile(OutF, DiagnosePath + 'lohntab.dat');
  rewrite(OutF);
  for n := 0 to pred(TabelleOut.count) do
  begin
    TabelleOut[n] := copy(TabelleOut[n], 15, MaxInt);
    OutStr30 := TabelleOut[n];
    write(OutF, Outstr30);
  end;
  closeFile(OutF);

  TabelleOut.SaveToFile(DiagnosePath + 'Out.2.txt');
  TabelleOut.free;
  if CheckBox4.checked then
    openShell(DiagnosePath + 'Out.1.txt');

end;

procedure TFormLohntabelle.Edit1Change(Sender: TObject);
var
  Betrag: double;
  Arbeitszeit: double;
  _Arbeitszeit1, _Arbeitszeit12: double;
  _ArbeitszeitEff: integer;
begin
  Betrag := strtodoubledef(edit1.text, 0);
  if (Betrag > 0) then
  begin
    label2.caption := verteile(Betrag);
    label7.caption := verteile2(Betrag);
    if Checkbox3.checked then
      label8.caption := 'Abwesenheitszeit ' + secondstostr(Arbeitszeit12(Betrag)) + ' h'
    else
      label8.caption := 'eff. Arbeitszeit ' + secondstostr(Arbeitszeit12(Betrag)) + ' h';

    staticText4.caption := secondstostr(Arbeitszeit12(Betrag)) + ' h';
    label12.caption := secondstostr(round(Betrag / strtodouble(edit2.text) * 3600));

    label10.caption := secondstostr(
      Arbeitszeit12(Betrag) -
      strtoseconds(label12.caption)) + ' h';

    // eff. Fahrzeit
    StaticText3.caption := secondstostr(
      ((strtoseconds(label10.caption) div 3600) + 1) * 3600
      );

    //
    Arbeitszeit := Arbeitszeit12(Betrag) - strtoseconds(StaticText3.caption);
    if Checkbox3.checked then
      if (Arbeitszeit > 0) then
      begin

        _Arbeitszeit1 := Arbeitszeit1(Betrag);
        _Arbeitszeit12 := Arbeitszeit12(Betrag);

        if checkbox2.checked then
          StaticText1.caption := secondstostr(round((Arbeitszeit / (5 * 60)) * (_Arbeitszeit1 / _Arbeitszeit12)) * (5 * 60))
        else
          StaticText1.caption := secondstostr(round(Arbeitszeit * (_Arbeitszeit1 / _Arbeitszeit12)));

        StaticText2.caption := secondstostr(round(Arbeitszeit - strtoseconds(StaticText1.caption)));

        _ArbeitszeitEff := strtoseconds(StaticText1.caption) +
          strtoseconds(StaticText2.caption);
        StaticText9.caption := secondstostr(_ArbeitszeitEff);

        StaticText6.caption := format('%.2m', [strtoseconds(StaticText1.caption) * (
            strtodouble(edit2.text) / 3600)]);

        StaticText7.caption := format('%.2m', [strtoseconds(StaticText2.caption) * (
            strtodouble(edit2.text) / 3600)]);

        StaticText8.caption :=
          format('%.2m', [
          strtodouble(StaticText7.caption) +
            strtodouble(staticText6.caption) - strtodouble(edit1.text)]);

        StaticText5.caption := format('%.2m', [
          strtodouble(edit1.text) / (_ArbeitszeitEff / 3600.0)]);

      end;
  end else
  begin
    label2.caption := '';
    label7.caption := '';
    label8.caption := '';
    label10.caption := '';
  end;
end;

function TFormLohntabelle.Verteile(r: double): string;
type
  FileTypeStr = string[30];
var
  InpF: file of FileTypeStr;
  s: word;
  str: FileTypeStr;
begin
  if (r > cMaxValue) then
  begin
    verteile := '';
    exit;
  end;
  s := trunc(r * 2.0);
  assignFile(inpF, DiagnosePath + 'lohntab.dat');
  reset(InpF);
  seek(inpF, s);
  read(InpF, str);
  closeFile(InpF);
  Verteile := str;
end;

function TFormLohntabelle.Verteile2(r: double): string;
type
  FileTypeStr = string[30];
var
  InpF: file of FileTypeStr;
  s: word;
  str: FileTypeStr;
  a, b: string[7];
begin
  if (r > cMaxValue) then
  begin
    verteile2 := '';
    exit;
  end;
  s := trunc(r * 2.0);
  assignFile(inpF, DiagnosePath + 'lohntab.dat');
  reset(InpF);
  seek(inpF, s);
  read(InpF, str);
  closeFile(InpF);
  a := copy(str, 1, 7);
  b := copy(str, 9, 7);
  if (a <> '00:00 h') and (b <> '00:00 h') then
  begin
    Verteile2 := '(' + edit3.text + ' EUR* ' + a + ') (' + edit4.text + ' EUR* ' + b + ')';
    exit;
  end;

  if (a = '00:00 h') then
  begin
    Verteile2 := '(' + edit4.text + ' EUR* ' + b + ')';
    exit;
  end;

  if (b = '00:00 h') then
  begin
    Verteile2 := '(' + edit3.text + ' EUR* ' + a + ')';
    exit;
  end;

  Verteile2 := '';

end;

function TFormLohntabelle.Arbeitszeit12(r: double): integer;
type
  FileTypeStr = string[30];
var
  InpF: file of FileTypeStr;
  s: word;
  str: FileTypeStr;
begin
  if (r > cMaxValue) then
  begin
    result := 0;
    exit;
  end;
  s := trunc(r * 2.0);
  assignFile(inpF, DiagnosePath + 'lohntab.dat');
  reset(InpF);
  seek(inpF, s);
  read(InpF, str);
  closeFile(InpF);
  result :=
    strtoseconds(copy(str, 1, 5)) +
    strtoseconds(copy(str, 9, 5))
    ;
end;

function TFormLohntabelle.Verteile4(r: double): string;
type
  FileTypeStr = string[30];
var
  InpF: file of FileTypeStr;
  s: word;
  str: FileTypeStr;
  a, b: string[7];
begin
  if (r > cMaxValue) then
  begin
    result := '';
    exit;
  end;
  s := trunc(r * 2.0);
  assignFile(inpF, DiagnosePath + 'lohntab.dat');
  reset(InpF);
  seek(inpF, s);
  read(InpF, str);
  closeFile(InpF);
  a := copy(str, 1, 7);
  b := copy(str, 9, 7);
  if (a <> '00:00 h') and (b <> '00:00 h') then
  begin
    result := '2';
    exit;
  end;
  result := '1';
end;

procedure TFormLohntabelle.Button2Click(Sender: TObject);
type
  datumtype = packed array[1..4] of byte; {Century,Year,Month,Day}
  putzrectyp = packed record
    XXX: string[10]; { ersten 5 Buchstaben nam }
                                      { ersten 3 Buchstaben str }
                                      { letzen 2 Ziffern von str }
                                      { Beispiel : FILSIAM 01 }
                                      { Beispiel : HAAS HER22 }
                 { énderung am 5.4.89 index ist jetzt der Name }
    nam: string[30]; { Name der Putzfrau }
    geb: datumtype; { Geburtsdatum der Putzfrau }
    sta: string[30]; { Stra·e }
    ort: string[30]; { Wohnort }
    obj: string[30]; { Objekt, in dem sie putzt }
    bem: string[30]; { Bemerkung }
    mon: packed array[1..12] of real48; { Monatliche BezÅge }
  end;

  function pDate(d: Datumtype): string;
  begin
    result :=
      inttostrN(d[4], 2) + '.' +
      inttostrN(d[3], 2) + '.' +
      inttostrN(d[1], 2) +
      inttostrN(d[2], 2);
  end;

var
  PutzFrF: file of putzrectyp;
  putzrec: putzrectyp;
  PERSON_R: integer;
  Geburtstag: TAnfixdate;
  Bemerkung: TStringList;
  qAUSGANGSRECHNUNG: TIB_Query;
  AUSGANGSRECHNUNG_R: integer;
  n: integer;
  datumS: string;
begin
  //
  IB_QueryANSCHRIFT.Open;
  IB_QueryPERSON.Open;

  AssignFile(PutzfrF, edit5.text + 'ORGAMON.DAT');
  reset(PutzfrF);
  while not (eof(PutzfrF)) do
  begin
    read(Putzfrf, putzrec);

    with putzrec do
    begin

      nam := cutblank(nam);

      if (nam <> '') then
      begin
        PERSON_R := e_r_sql('select RID from PERSON where NACHNAME=' +
          '''' + nam + '''');
        if (PERSON_R < 1) then
          PERSON_R := e_w_PersonNeu;
      //

      //
        IB_QueryPERSON.parambyname('CROSSREF').AsInteger := PERSON_R;
        IB_QueryPERSON.open;

      //
        IB_QueryANSCHRIFT.ParamByName('CROSSREF').AsInteger := IB_QueryPERSON.FieldByName('PRIV_ANSCHRIFT_R').Asinteger;
        IB_QueryANSCHRIFT.open;


        with IB_QueryANSCHRIFT do
        begin
          edit;
          FieldByName('STRASSE').AsString := sta;
          FieldByName('PLZ').AsInteger := strtointdef(nextp(ort, ' ', 0), 0);
          FieldByName('ORT').AsString := nextp(ort, ' ', 1);
          post;
        end;

        with IB_QueryPERSON do
        begin
          edit;
          Geburtstag := date2long(pDate(geb));
          if DateOK(Geburtstag) then
            FieldByName('GEBURTSTAG').AsDate := long2datetime(Geburtstag);

          FieldByName('BERUF').AsString := obj;
          FieldByName('A00').AsString := cC_True;

          Bemerkung := TStringList.create;
          Bemerkung.add(bem);
          FieldByName('BEMERKUNG').Assign(Bemerkung);
          Bemerkung.free;

          FieldByName('NACHNAME').AsString := nam;
          post;
        end;

        for n := 1 to 12 do
        begin
          datumS := '''01.' + inttostrN(n, 2) + '.' + edit6.text + '''';

          AUSGANGSRECHNUNG_R := e_r_sql('select RID from AUSGANGSRECHNUNG where' +
            ' (KUNDE_R=' + inttostr(PERSON_R) + ') AND ' +
            ' (DATUM=' + DatumS + ')');

          if (AUSGANGSRECHNUNG_R < 1) then
          begin
            e_x_sql('insert into AUSGANGSRECHNUNG (RID,KUNDE_R,DATUM,BETRAG) values' +
              ' (0,' + inttostr(PERSON_R) + ',' + DatumS + ',' + FloatToStrISO(mon[n]) + ')');
          end else
          begin
            qAUSGANGSRECHNUNG := DataModuleDatenbank.nQuery;
            with qAUSGANGSRECHNUNG do
            begin
              sql.add('select BETRAG from AUSGANGSRECHNUNG where RID=' + inttostr(AUSGANGSRECHNUNG_R) + ' for update');
              Open;
              Edit;
              FieldByName('BETRAG').AsDouble := mon[n];
              Post;
            end;
            qAUSGANGSRECHNUNG.free;
          end;
        end;
      end;

      with putzrec do
        listbox1.items.add(
          nam + ',' +
          rtostr(mon[1], 7, 2));
      application.processmessages;
    end;
  end;
  closeFile(PutzfrF);
  IB_QueryANSCHRIFT.close;
  IB_QueryPERSON.close;
end;

procedure TFormLohntabelle.IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
begin
 // Hier wird die Info-Datei geschrieben
 // Dateiname: Kalkulation_<RID>.txt
 //
  with IB_Dataset do
  begin
    BeginHourGlass;
    if (FieldByName('RID').IsNotNull) and
       (FieldByName('SATZ1').AsDouble>0) and
       (FieldByName('SATZ2').AsDouble>0) then
    begin
      edit3.Text := format('%g', [FieldByName('SATZ1').AsDouble]);
      edit4.Text := format('%g', [FieldByName('SATZ2').AsDouble]);
      CheckBox4.checked := false;
      Button1Click(self);
      FileCopy(DiagnosePath + 'lohntab.dat', e_r_LohnFName(FieldByName('RID').AsInteger));
    end;
    EndHourGlass;
  end;
end;

procedure TFormLohntabelle.FormActivate(Sender: TObject);
begin
  if not(IB_Query1.Active) then
    IB_Query1.open
  else
    IB_Query1.refresh;
end;

procedure TFormLohntabelle.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Lohn');
end;

procedure TFormLohntabelle.IB_Query1ConfirmDelete(Sender: TComponent;
  var Confirmed: Boolean);
begin
  with Sender as TIB_Dataset do
    Confirmed := doit('Eintrag ' + #13 +
      '#' + FieldByName('RID').AsString + #13 +
      'wirklich lˆschen', true);
end;

end.

