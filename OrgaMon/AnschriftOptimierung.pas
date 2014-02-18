(*
      ___                  __  __
     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
    | |_| | | | (_| | (_| | |  | | (_) | | | |
     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
               |___/

    Copyright (C) 2007  Andreas Filsinger

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    http://orgamon.org/

*)
unit AnschriftOptimierung;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, IB_Components,
  Buttons;

type
  TFormAnschriftOptimierung = class(TForm)
    Button1: TButton;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    CheckBox2: TCheckBox;
    Button2: TButton;
    CheckBox3: TCheckBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private-Deklarationen }
    TheSourceRIDS: TList;
    TheSourceAdrList: TStringList;

    // errechnete Listen
    DestAnschriftenL: TStringList;
    DestHaeuserL: TStringList;
    DestAnschriftenE: TStringList;

  public
    { Public-Deklarationen }
    procedure Prepare;
    procedure SetContext(RIDs: TList);
    procedure TestDatei;
    procedure Ausgabe;
  end;

var
  FormAnschriftOptimierung: TFormAnschriftOptimierung;

implementation

uses
  anfix32, globals, Baustelle,
  Datenbank, Funktionen_Auftrag, wanfix32;

{$R *.dfm}

{ TFormAnschriftOptimierung }

function RemoveDoubleBlank(s: string): string;
var
  k: integer;
begin
  repeat
    k := pos('  ', s);
    if k = 0 then
      break;
    system.delete(s, k, 1);
  until false;
  result := s;
end;

procedure FreeElement(s: TStringList; i: integer);
var
  o: TObject;
begin
  o := s.objects[i];
  FreeAndNil(o);
  s.Delete(i);
end;

function NoSemiAndCSV(const s: string): string;
begin
  result := cutblank(s);
  if (result <> '') then
  begin
    ersetze(';', ',', result);
    ersetze('"', '''', result);
    result := '"' + result + '"';
  end;
end;

function NoSemiNoBlank(const s: string): string;
begin
  result := noblank(s);
  ersetze(';', ',', result);
end;

function PLZ(const s: string): string;
var
  k: integer;
begin
  k := pos(' ', s);
  if (k = 0) then
    result := s
  else
    result := copy(s, 1, pred(k));
end;

procedure LookAndAdd(LookStr: string; RID: integer; Dest: TStringList);
var
  k: integer;
begin
  k := Dest.indexof(LookStr);
  if (k <> -1) then
  begin
    TList(Dest.objects[k]).add(pointer(RID));
  end else
  begin
    Dest.addObject(LookStr, TList.create);
    Tlist(Dest.objects[pred(Dest.count)]).add(pointer(rid));
  end;
end;

function LookFor(Dest: TStringList; o: TObject): integer;
var
  n, k: integer;
  TheList: TList;
begin
  result := -1;
  for n := 0 to pred(Dest.count) do
  begin
    TheList := TList(Dest.objects[n]);
    if assigned(TheList) then
    begin
      k := TheList.indexof(o);
      if k <> -1 then
      begin
        result := n;
        exit;
      end;
    end else
    begin
      beeP;
    end;
  end;
end;

procedure TFormAnschriftOptimierung.SetContext(RIDs: TList);
begin
  TheSourceRIDS := RIDs;
  show;
end;

procedure TFormAnschriftOptimierung.TestDatei;
var
  AusgabeCSV: TStringList;

  function SecialCharReplace(s: string): string;
  begin
    result := s;
    ersetze('#', #$09, result);
    ersetze('~', #$0A, result);
  end;

begin
  AusgabeCSV := TStringList.create;
  AusgabeCSV.add('Hallo;Bello');
  AusgabeCSV.add(SecialCharReplace('"LOL-28003#Gas 293822#Grüner Hof 14, Andreas Filsinger#16.03 vormittags~' +
    'MILO-290002#Wasser#3234#Grüner Hof 14#16.03 nachmittags~' +
    'Elektro#12912782#Grüner Hof 14b#16.03 nachmittags' +
    '";genau'));
  AusgabeCSV.SaveToFile(DiagnosePath + 'Daten.csv');
  AusgabeCSV.free;
end;

procedure TFormAnschriftOptimierung.FormCreate(Sender: TObject);
begin
  TheSourceAdrList := TStringList.create;
  DestAnschriftenL := TStringList.create;
  DestHaeuserL := TStringList.create;
  DestAnschriftenE := TStringList.create;
end;

procedure TFormAnschriftOptimierung.FormDestroy(Sender: TObject);
begin
  TheSourceAdrList.free;
  DestAnschriftenL.free;
  DestHaeuserL.free;
  DestAnschriftenE.free;
end;

procedure TFormAnschriftOptimierung.Button1Click(Sender: TObject);
begin
  Prepare;
  Ausgabe;
end;

procedure TFormAnschriftOptimierung.Prepare;
var
  cAUFTRAG: TIB_Cursor;
  AUFTRAG_R: integer;
  n: integer;
  k_n1, k_n2, k_s, k_o: string;
  e_n1, e_n2, e_s, e_o: string;
  FTime: dword;
begin

  //
  BeginHourGlass;
  FTime := 0;
  Progressbar1.max := TheSourceRIDS.count;
  TheSourceAdrList.clear;
  DestAnschriftenL.clear;
  DestHaeuserL.clear;
  DestAnschriftenE.clear;
  cAUFTRAG := DataModuleDatenbank.nCursor;
  with cAUFTRAG do
  begin

    sql.add('select KUNDE_NAME1,KUNDE_NAME2,');
    sql.add(' KUNDE_STRASSE,KUNDE_ORT,KUNDE_ORTSTEIL,');
    sql.add(' BRIEF_NAME1,BRIEF_NAME2,BRIEF_STRASSE,BRIEF_ORT,RID ');
    sql.add('from AUFTRAG where RID=:CROSSREF');

    for n := 0 to pred(TheSourceRIDS.count) do
    begin
      AUFTRAG_R := integer(TheSourceRIDS[n]);
      parambyName('CROSSREF').AsInteger := AUFTRAG_R;
      ApiFirst;

      //
      k_n1 := NoSemiNoBlank(FieldByName('KUNDE_NAME1').AsString);
      k_n2 := NoSemiNoBlank(FieldByName('KUNDE_NAME2').AsString);
      k_s := NoSemiNoBlank(FieldByName('KUNDE_STRASSE').AsString);
      k_o := NoSemiNoBlank(FieldByName('KUNDE_ORT').AsString + '-' + FieldByName('KUNDE_ORTSTEIL').AsString);

      if ((k_n1 + k_n2) = '') then
      begin

       // Hausanschrift!!!
        if (k_s + K_o <> '') then
        begin
          LookAndAdd(k_s + ';' + k_o, AUFTRAG_R, DestHaeuserL);
        end;

      end else
      begin
        LookAndAdd(K_n1 + ';' + k_n2 + ';' + k_s + ';' + k_o, AUFTRAG_R, DestAnschriftenL);
      end;

      //
      e_n1 := NoSemiNoBlank(FieldByName('BRIEF_NAME1').AsString);
      e_n2 := NoSemiNoBlank(FieldByName('BRIEF_NAME2').AsString);
      e_s := NoSemiNoBlank(FieldByName('BRIEF_STRASSE').AsString);
      e_o := NoSemiNoBlank(FieldByName('BRIEF_ORT').AsString);

      //
      if ((e_n1 + e_n2) <> '') and (e_s <> '') and (e_o <> '') then
      begin
        // immer aufnehmen, wenn Strasse anders ist
        LookAndAdd(E_n1 + ';' + e_n2 + ';' + e_s + ';' + e_o, AUFTRAG_R, DestAnschriftenE);
      end;


      TheSourceAdrList.addobject(
        inttostr(AUFTRAG_R) + ';' +
        k_n1 + ';' +
        k_n2 + ';' +
        k_s + ';' +
        k_o + ';' +
        e_n1 + ';' +
        e_n2 + ';' +
        e_s + ';' +
        e_o, pointer(AUFTRAG_R));

      if frequently(FTime, 333) then
      begin
        progressbar1.position := n;
        application.processmessages;
      end;
    end;
  end;
  cAUFTRAG.free;
  progressbar1.position := 0;
  EndHourGlass;

  StaticText1.caption := inttostr(TheSourceAdrList.count);

  StaticText6.caption := inttostr(DestAnschriftenL.count) +
    '/' +
    inttostr(DestAnschriftenE.count)
    ;

  StaticText7.caption := inttostr(DestHaeuserL.count) + '/0';

end;

procedure TFormAnschriftOptimierung.Ausgabe;

const
  cWordHeaderE = 'Name1;Name2;Strasse;Ort;Tabelle;Zusatz;DatumHeute;Leer';
  cWordHeaderL = 'Name1;Name2;Strasse;Ort;WechselDatum;ABNummer;Zaehler;Monteur;DatumHeute;Leer';
  cMsgBrief_NichtInformiert = 'Hausbewohner der Liegenschaft wurden NICHT informiert,' + #$0A#$09 + 'bitte tragen Sie dafür Sorge, dass der Zähler zugänglich ist.';

var
  AusgabeL: TStringList;
  AusgabeE: TStringList;
  n, m, k: integer;
  TheList: TList;
  OutS: string;
  FTime: dword;

  // Ausgabe-Lauf
  cAUFTRAG: TIB_Cursor;
  AUFTRAG_R: integer;
  SubItems: TStringList;
  ZusatzItems: TStringList;
  _name1, _name2, _strasse, _ort, _Tabelle, _zusatz: string;
  _monteur, _name: string;

  function ZusatzHint(FixedIndex: integer = -1): string;
  begin
    if (FixedIndex = -1) then
      result := inttostr(succ(ZusatzItems.count))
    else
      result := inttostr(succ(FixedIndex));
  end;

  procedure ZusatzInfosAdd(Msg: string);
  var
    k: integer;
  begin
    k := ZusatzItems.Indexof(Msg);
    if (k = -1) then
    begin
      SubItems[pred(SubItems.count)] := SubItems[pred(SubItems.count)] + ZusatzHint + ' ';
      ZusatzItems.add(Msg);
    end else
    begin
      SubItems[pred(SubItems.count)] := SubItems[pred(SubItems.count)] + ZusatzHint(k) + ' ';
    end;
  end;

  procedure AddAntoherLine(AUFTRAG_R: integer);
  var
    _Datum: string;
    _Art: string;
  begin
    SubItems.clear;
    with cAUFTRAG do
    begin
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      ApiFirst;

      // Ausführungsdatum
      _Datum := long2dateText(DateTime2long(FieldByName('AUSFUEHREN').AsDateTime));
      repeat
        if (FieldByName('VORMITTAGS').AsString = cVormittagsChar) then
        begin
          _Datum := _Datum + ' vormittags';
          break;
        end;
        if (FieldByName('VORMITTAGS').AsString = cNachmittagsChar) then
        begin
          _Datum := _Datum + ' vormittags';
          break;
        end;
      until true;
      SubItems.add(_Datum);

      // "Baustelle ABNummer"
      SubItems.add(
        e_r_BaustelleKuerzel(FieldByName('BAUSTELLE_R').AsInteger) + '-' +
        inttostrN(FieldByName('NUMMER').AsInteger, cAuftragsNummer_Length));

      // "Gas 2029382"
      _Art := AnsiUpperCase(FieldByName('ART').AsString);
      repeat
        if (pos('G', _Art) > 0) then
        begin
          _Art := 'Gas';
          break;
        end;
        if (pos('E', _Art) > 0) then
        begin
          _Art := 'Strom';
          break;
        end;
        if (pos('W', _Art) > 0) then
        begin
          _Art := 'Wasser';
          break;
        end;
      until true;
      if (_Art = '') then
        _Art := 'Wasser';
      SubItems.add(_art + ' ' + FieldByName('ZAEHLER_NUMMER').AsString);

      SubItems.add('');
      //
      // Hinweise in den Zusatz Text
      //
      // * Monteure
      if CheckBox1.checked then
        if not (FieldByName('MONTEUR1_R').IsNull) then
        begin
          _Monteur := e_r_MonteurName(FieldByName('MONTEUR1_R').AsInteger);
          if not (FieldByName('MONTEUR2_R').IsNull) then
            _Monteur := _Monteur + ' oder ' + e_r_MonteurName(FieldByName('MONTEUR2_R').AsInteger);
          ZusatzInfosAdd('Unser Monteur: ' + _Monteur);
        end;

      // * Liegenschaft
      ZusatzInfosAdd('Zähler Anwesen: ' +
        PLZ(FieldByName('KUNDE_ORT').AsString) + '-' +
        RemoveDoubleBlank(FieldByName('KUNDE_STRASSE').AsString)
        );

      // * Informierte Personen
      _name := cutblank(RemoveDoubleBlank(FieldByName('KUNDE_NAME1').AsString) + ' ' +
        RemoveDoubleBlank(FieldByName('KUNDE_NAME2').AsString));
      if (_Name = '') then
      begin
        ZusatzInfosAdd(cMsgBrief_NichtInformiert);
      end else
      begin
        ZusatzInfosAdd('Es wurde angeschrieben: ' + _Name);
      end;

    end;
  end;

begin
  BeginHourGlass;
  Ftime := 0;
  progressbar1.max := DestAnschriftenE.Count + DestAnschriftenL.Count;
  AusgabeL := TStringList.create;
  AusgabeE := TStringList.create;

  // a) zusammenstellen
  // erst die Hausverwaltungen ausgeben, die ziehen "normale"
  // Anschreiben mit in den Tod
  //
  // zumindest die Hausanschreiben
  // in der Regel jedoch auch die
  for n := 0 to pred(DestAnschriftenE.Count) do
  begin
    if frequently(FTime, 333) then
    begin
      progressbar1.position := n;
      application.processmessages;
    end;
    TheList := TList(DestAnschriftenE.objects[n]);
    if not (assigned(TheList)) then
      break;
    OutS := DestAnschriftenE[n] + ';';

    for m := 0 to pred(TheList.count) do
    begin

      repeat
        k := LookFor(DestHaeuserL, TheList[m]);
        if (k <> -1) then
        begin
          FreeElement(DestHaeuserL, k);
          OutS := OutS + inttostr(integer(TheList[m])) + '-Haus;';
          break;
        end;
        k := LookFor(DestAnschriftenL, TheList[m]);
        if (k <> -1) then
        begin
          //
          // wenn die Liegenschaft im selben Haus ist wie
          // die HV -> nur die HV anschreiben.
          //
          if not (CheckBox3.Checked) or (nextp(DestAnschriftenE[n], ';', 2) = nextp(DestAnschriftenL[k], ';', 2)) then
          begin
            FreeElement(DestAnschriftenL, k);
          end;
          OutS := OutS + inttostr(integer(TheList[m])) + '-Person;';
        end;
      until true;
    end;
    AusgabeE.addobject(OutS, TheList);
  end;

  if (DestHaeuserL.count > 0) then
  begin
    DestHaeuserL.saveToFile(DiagnosePath + 'AnschriftOptimierung_NichtanschreibbareHäuser.txt');
    openShell(DiagnosePath + 'AnschriftOptimierung_NichtanschreibbareHäuser.txt');
  end;

  // jetzt halt noch die ürigen
  for n := 0 to pred(DestAnschriftenL.Count) do
  begin
    if frequently(FTime, 333) then
    begin
      progressbar1.position := DestAnschriftenE.Count + n;
      application.processmessages;
    end;
    TheList := TList(DestAnschriftenL.objects[n]);
    OutS := DestAnschriftenL[n] + ';';
    for m := 0 to pred(TheList.Count) do
      OutS := OutS + inttostr(integer(TheList[m])) + ';';
    AusgabeL.addobject(OutS, TheList);
  end;

  // b) Mit Zusatz-Infos versehen und erweitern
  StaticText4.caption := inttostr(AusgabeL.count);
  StaticText5.caption := inttostr(AusgabeE.count);

  // Eigner aufblasen
  SubItems := TStringList.create;
  ZusatzItems := TStringList.create;
  cAUFTRAG := DataModuleDatenbank.nCursor;
  with cAUFTRAG do
  begin
    sql.add('select * from AUFTRAG where RID=:CROSSREF');
    for n := 0 to pred(AusgabeE.count) do
    begin
      ZusatzItems.clear;
      TheList := TList(AusgabeE.objects[n]);
      AUFTRAG_R := integer(TheList[0]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      ApiFirst;

      // ersten Datensatz erzeugen
      _name1 := RemoveDoubleBlank(FieldByName('BRIEF_NAME1').AsString);
      _name2 := RemoveDoubleBlank(FieldByName('BRIEF_NAME2').AsString);
      _strasse := RemoveDoubleBlank(FieldByName('BRIEF_STRASSE').AsString);
      _ort := FieldByName('BRIEF_ORT').AsString;

      AddAntoherLine(AUFTRAG_R);
      _tabelle := HugeSingleLine(SubItems, #$09);

      // weitere Zeilen in die Tabelle einhängen
      for m := 1 to pred(TheList.count) do
      begin
        AddAntoherLine(integer(TheList[m]));
        _tabelle := _tabelle + #$0A + HugeSingleLine(SubItems, #$09);
      end;

      for m := 0 to pred(ZusatzItems.count) do
        ZusatzItems[m] := inttostr(succ(m)) + #$09 + ZusatzItems[m];
      _zusatz := HugeSingleLine(ZusatzItems, #$0A);

      AusgabeE[n] :=
        nosemiAndCSV(_name1) + ';' +
        nosemiAndCSV(_name2) + ';' +
        nosemiAndCSV(_strasse) + ';' +
        nosemiAndCSV(_ort) + ';' +
        nosemiAndCSV(_tabelle) + ';' +
        nosemiAndCSV(_zusatz) + ';';

    end;
  end;

  FreeAndNil(ZusatzItems);

  // Liegenschaften aufblasen
  with cAUFTRAG do
  begin
    for n := 0 to pred(AusgabeL.count) do
    begin
      ZusatzItems.clear;
      TheList := TList(AusgabeE.objects[n]);
      AUFTRAG_R := integer(TheList[0]);
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      ApiFirst;

    // ersten Datensatz erzeugen
      _name1 := RemoveDoubleBlank(FieldByName('BRIEF_NAME1').AsString);
      _name2 := RemoveDoubleBlank(FieldByName('BRIEF_NAME2').AsString);
      _strasse := RemoveDoubleBlank(FieldByName('BRIEF_STRASSE').AsString);
      _ort := FieldByName('BRIEF_ORT').AsString;

      AddAntoherLine(AUFTRAG_R);
      _tabelle := HugeSingleLine(SubItems, #$09);

      // weitere Zeilen in die Tabelle einhängen
      if (TheList.count <> 1) then
      begin
        ShowMessage('"Liegenschaft"-Brief kann nur über einen Zähler verfügen!');
        exit;
      end;

      AusgabeL[n] :=
        nosemiAndCSV(_name1) + ';' +
        nosemiAndCSV(_name2) + ';' +
        nosemiAndCSV(_strasse) + ';' +
        nosemiAndCSV(_ort) + ';' +
        nosemiAndCSV(_tabelle) + ';' +
        nosemiAndCSV(_zusatz) + ';';

    end;
  end;

  cAUFTRAG.free;
  SubItems.free;

  AusgabeL.insert(0, cWordHeaderL);
  AusgabeL.SaveToFile(DiagnosePath + 'Liegenschaften.txt');

  AusgabeE.insert(0, cWordHeaderL);
  AusgabeE.SaveToFile(DiagnosePath + 'Verwaltungen.csv');

  AusgabeL.free;
  AusgabeE.free;
  progressbar1.position := 0;
  EndHourGlass;
end;

procedure TFormAnschriftOptimierung.SpeedButton1Click(Sender: TObject);
begin
  openShell(DiagnosePath + 'Liegenschaften.txt');
end;

procedure TFormAnschriftOptimierung.SpeedButton2Click(Sender: TObject);
begin
  openShell(DiagnosePath + 'Verwaltungen.txt');
end;

procedure TFormAnschriftOptimierung.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFormAnschriftOptimierung.Button3Click(Sender: TObject);
begin
  TestDatei;
end;

end.

