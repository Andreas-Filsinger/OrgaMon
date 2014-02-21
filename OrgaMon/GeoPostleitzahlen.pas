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
unit GeoPostleitzahlen;
// Formate der Dateien:
// ====================
//
// 1. Schritt:
// ===========
// Orte.txt: OrtSchlüssel;PLZ;OrtsteilSub;ORT;ORTSTEIL
// PLZ.txt: OrtSchlüssel;PLZ;OrtsteilSub;STRASSE;StrasseSchlüssel;NAME
//
// 2. Schritt:
// ===========
// Complete.txt: plz;ort;OrtSchlüssel;ortsteil;strasse;StrasseSchlüssel;Name
//

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  ComCtrls;

type
  TFormGeoPostleitzahlen = class(TForm)
    Button1: TButton;
    ProgressBar1: TProgressBar;
    Button2: TButton;
    ProgressBar2: TProgressBar;
    Button3: TButton;
    Button5: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Quelle: TLabel;
    Button6: TButton;
    Label4: TLabel;
    ProgressBar4: TProgressBar;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    UserBreak: boolean;
  end;

var
  FormGeoPostleitzahlen: TFormGeoPostleitzahlen;

implementation

uses
  globals, anfix32, WordIndex,
  Funktionen_Basis,
  Funktionen_Beleg,
  IB_Components, IB_Access,
  gplists, dbOrgaMon, Datenbank;

{$R *.DFM}

const
  GE_Fields: array[0..15] of integer = (9, 8, 8, 40, 160, 46, 8, 8, 5, 8, 6, 5, 3, 1, 8, 1);
  OR_Fields: array[0..11] of integer = (9, 8, 8, 1, 40, 40, 30, 1, 24, 8, 8, 1);
  OT_Fields: array[0..9] of integer = (9, 8, 8, 3, 5, 1, 1, 40, 8, 1);
  PF_Fields: array[0..12] of integer = (9, 8, 8, 6, 6, 1, 8, 1, 5, 1, 6, 6, 1);
  PL_Fields: array[0..20] of integer = (9, 8, 5, 8, 2, 1, 1, 40, 30, 1, 24, 1, 8, 8, 8, 3, 3, 3, 2, 2, 1);
  ST_Fields: array[0..23] of integer = (9, 8, 8, 11, 8, 8, 1, 1, 1, 46, 46, 22, 1, 1, 5, 3, 3, 8, 8, 8, 11, 8, 8, 1);
  KG_Fields: array[0..5] of integer = (9, 8, 8, 1, 40, 1);

function FieldStart(Fields: array of integer; No: integer): integer;
var
  n: integer;
begin
  result := 1;
  for n := 0 to (No - 2) do
    inc(result, Fields[n]);
end;

function FieldCopy(const InpStr: string; Fields: array of integer; No: integer): string;
begin
  result := copy(InpStr, FieldStart(Fields, No), Fields[pred(no)]);
end;

function FieldCopyCB(const InpStr: string; Fields: array of integer; No: integer): string;
begin
  result := cutblank(FieldCopy(Inpstr, Fields, No));
end;

function FieldCopyAlpha(const InpStr: string; Fields: array of integer; No: integer): string;
begin
  result := Oem2ansi(cutblank(copy(InpStr, FieldStart(Fields, No), Fields[pred(no)])));
end;

procedure TFormGeoPostleitzahlen.Button1Click(Sender: TObject);
var
  PLZFile: Textfile;
  InpStr: string;
  _name: string;
  _OrtKey: string;
  _StrasseKey: string;
  _plz: string;
  _sub: string;
  _ort: string;
  _str: string;
  _hn1: string;
  _hn2: string;
  _ortsteil: string;
  TypPart: string[2];
  Orte: TStringList;
  Plz: TStringList;
  LastTime: dword;

  procedure WritePLZ;
  begin
    plz.add(_Ortkey + ';' + _plz + ';' + _sub + ';' + _str + ';' + _Strassekey + ';' + _name);
  end;

  procedure WriteOrt;
  begin
    Orte.add(_Ortkey + ';' + _plz + ';' + _sub + ';' + _ort + ';' + _ortsteil);
  end;

begin
  BeginHourGlass;
  UserBreak := false;
  LastTime := GetTickCount;
  Orte := TStringList.create;
  Plz := TStringList.create;
  assignFile(PLZFile, edit1.text);
  reset(PLZFile);
  with progressbar1 do
  begin
    position := 0;
    max := FSize(edit1.text);
    step := 324 + 2;
  end;
  while not (eof(PLZFile)) do
  begin
    readln(PLZFile, InpStr);
    progressbar1.StepIt;

    TypPart := copy(InpStr, 1, 2);

    while true do
    begin

      if (TypPart = 'OR') then
      begin

        if (FieldCopy(INpStr, OR_Fields, 4) = 'G') then
        begin
          _Ortkey := FieldCopy(InpStr, OR_Fields, 3);
          _plz := '';
          _sub := '';
          _ort := FieldCopyAlpha(InpStr, OR_Fields, 5);
          _ortsteil := '';
          WriteOrt;

          if FieldCopy(Inpstr, OR_Fields, 8) = '1' then
          begin
            _ort := _ort + ' ' + FieldCopyAlpha(InpStr, OR_Fields, 7);
            WriteOrt;
          end;

        end;
        break;
      end;

      if (TypPart = 'OT') or (TypPart = 'OB') then
      begin

        // Ortsteile!
        if FieldCopy(InpStr, OT_Fields, 6) = 'G' then
        begin
          _Ortkey := FieldCopy(InpStr, OT_Fields, 3);
          _plz := FieldCopy(InpStr, OT_Fields, 5);
          _sub := FieldCopyCB(InpStr, OT_Fields, 4);
          _Ort := '';
          _OrtsTeil := FieldCopyAlpha(InpStr, OT_Fields, 8);
          WriteOrt;

          _str := '';
          _name := '';
          _Strassekey := '';
          WritePLZ;

        end;
        break;
      end;

      if (TypPart = 'PL') then
      begin

        _Ortkey := FieldCopy(Inpstr, PL_Fields, 4);
        _plz := FieldCopy(InpStr, PL_Fields, 3);
        _sub := FieldCopyCB(InpStr, PL_Fields, 16);
        _ort := FieldCopyAlpha(Inpstr, PL_Fields, 8);
        _ortsteil := '';
        WriteOrt;

        _ort := cutblank(_ort + ' ' + FieldCopyAlpha(Inpstr, PL_Fields, 9));
        WriteOrt;

        _str := '';
        _name := '';
        _Strassekey := '';
        WritePLZ;

        break;
      end;

(* // hatte keine Zusatz Infos gebracht!
      if (typPart = 'KG') then
      begin

        if (FieldCopy(InpStr, KG_Fields, 4) = 'G') then
        begin

          // Gemeinde Schlüssel -> für weitere Ortsnamen in einem PLZ Gebiet
          _Ortkey := '#' + FieldCopy(InpStr, KG_Fields, 3);
          _plz := '';
          _sub := '';
          _ort := FieldCopyAlpha(InpStr, KG_Fields, 5);
          _ortsteil := '';
          WriteOrt;

        end;
        break;

      end;
*)

      if (TypPart = 'GE') then
      begin

        _Ortkey := FieldCopy(InpStr, GE_Fields, 15);
        _plz := FieldCopy(InpStr, GE_Fields, 12);
        _sub := '';
        _name := FieldCopyAlpha(InpStr, GE_Fields, 5);
        _str := '';
        _Strassekey := '';
        WritePLZ;

        _plz := FieldCopyCB(InpStr, GE_Fields, 9);
        if (_plz <> '') then
        begin
          // Hausanschrift angegeben
          _Ortkey := FieldCopy(InpStr, GE_Fields, 10);
          _hn1 := FieldCopyCB(InpStr, GE_Fields, 7);
          _hn2 := FieldCopyCB(InpStr, GE_Fields, 8);
          _str := FieldCopyAlpha(InpStr, GE_Fields, 6) + ' ' + _hn1;
          if (_hn2 <> '') then
            _str := _str + '-' + _hn2;
          _Strassekey := '';
          WritePLZ;
        end;

        break;
      end;


      if (TypPart = 'PF') then
      begin
        if FieldCopy(InpStr, PF_Fields, 6) = 'G' then
        begin
          _Ortkey := FieldCopy(InpStr, PF_Fields, 3);
          _plz := FieldCopy(InpStr, PF_Fields, 9);
          _sub := '';
          _hn1 := FieldCopyCB(InpStr, PF_Fields, 4);
          _hn2 := FieldCopyCB(InpStr, PF_Fields, 5);
          _str := 'Postfach ' + _hn1 + '-' + _hn2;
          _name := '';
          _Strassekey := '';
          WritePLZ;
        end;
        break;
      end;


      if (TypPart = 'ST') then
      begin
        if FieldCopy(InpStr, ST_Fields, 7) = 'G' then
        begin
          _name := '';
          _Ortkey := FieldCopy(InpStr, ST_Fields, 3);
          _plz := FieldCopy(InpStr, ST_Fields, 15);
          _sub := FieldCopyCB(InpStr, ST_Fields, 17);

          _hn1 := FieldCopyCB(InpStr, ST_Fields, 5);
          _hn2 := FieldCopyCB(InpStr, ST_Fields, 6);
          _str := FieldCopyAlpha(InpStr, ST_Fields, 11);
          _Strassekey := FieldCopy(InpStr, ST_Fields, 4);

          if _hn1 <> '' then
            _str := _str + ' ' + _hn1;
          if _hn2 <> '' then
          begin
            if _hn1 = '' then
              _str := _str + ' -' + _hn2
            else
              _str := _str + '-' + _hn2
          end;
          WritePlz;
        end;
        break;
      end;

      break;
    end;

    if frequently(LastTime, 200) then
      application.processmessages;
    if UserBreak then
      break;

  end;

  CloseFile(PLZFile);

  Orte.Sort;
  removeduplicates(orte);
  Orte.SaveToFile(SearchDir + 'Orte.txt');
  Orte.free;

  Plz.Sort;
  removeduplicates(plz);
  Plz.SaveToFile(SearchDir + 'PLZ.txt');
  plz.free;

  progressbar1.Position := 0;
  EndHourGlass;
end;

procedure TFormGeoPostleitzahlen.Button2Click(Sender: TObject);
begin
  UserBreak := true;
end;

procedure TFormGeoPostleitzahlen.FormCreate(Sender: TObject);
begin
  caption := 'PLZread Rev. ' + RevToSTr(Version);
end;

procedure TFormGeoPostleitzahlen.Button3Click(Sender: TObject);
var
  Orte: TSearchStringList;
  InpF: TextFile;
  LastTime: dword;
  InpStr: string;
  CompleteF: TextFile;

  _Ortkey, _plz, _sub, _ort, _ortsteil: string;
  _StrasseKey, _name, _strasse: string;

  k: integer;
  MyErrors: TStringList;
  BytesRead: dword;
begin
  BeginHourGlass;
  assignFile(CompleteF, SearchDir + 'Complete.txt');
  rewrite(CompleteF);
  MyErrors := TStringList.create;
  with progressbar2 do
  begin
    max := FSize(SearchDir + 'PLZ.txt');
    position := 0;
  end;
  UserBreak := false;
  LastTime := GetTickCount;
  Orte := TSearchStringList.create;
  Orte.LoadFromFile(SearchDir + 'Orte.txt');
  Orte.sort;

  AssignFile(InpF, SearchDir + 'PLZ.txt');
  reset(InpF);
  BytesRead := 0;

  while not (eof(InpF)) do
  begin
    readln(InpF, InpStr);
    inc(BytesRead, length(InpStr) + 2);

    _Ortkey := nextp(InpStr, ';');
    _plz := nextp(InpStr, ';');
    _sub := nextp(InpStr, ';');
    _strasse := nextp(InpStr, ';');
    _strasseKey := nextp(InpStr, ';');
    _name := nextp(InpStr, ';');

    // 1. Den Ort finden!
    k := Orte.FindNear(_Ortkey + ';' + _plz + ';;');
    if (k = -1) then
      k := Orte.FindNear(_Ortkey + ';' + _plz + ';');

    if (k = -1) then
    begin
      MyErrors.add(_Ortkey + ';' + _plz + ' nicht gefunden!');
      continue;
    end else
    begin
      _ort := nextp(Orte[k], ';', 3);
    end;

    // 2. Den Ortsteil finden!
    if (_sub = '') then
    begin
      _Ortsteil := '';
    end else
    begin
      k := Orte.FindNear(_Ortkey + ';' + _plz + ';' + _sub);
      if (k = -1) then
      begin
        MyErrors.add(_Ortkey + ';' + _plz + ';' + _sub + ' nicht gefunden!');
        _Ortsteil := '';
      end else
      begin
        _ortsteil := nextp(Orte[k], ';', 4);
      end;
    end;

    if (_ort = _ortsteil) then
      _ortsteil := '';

    writeln(CompleteF, _plz + ';' + _ort + ';' + _OrtKey + ';' + _ortsteil + ';' + _strasse + ';' + _StrasseKey + ';' + _name);
    if frequently(LastTime, 200) then
    begin
      application.processmessages;
      progressbar2.position := BytesRead;
      if UserBreak then
        break;
    end;

  end;
  CloseFile(CompleteF);
  Orte.free;
  MyErrors.Sort;
  RemoveDuplicates(MyErrors);
  MyErrors.SaveToFile(SearchDir + 'Complete Errors.txt');
  MyErrors.free;
  progressbar2.position := 0;
  EndHourGlass;
end;

procedure TFormGeoPostleitzahlen.Button5Click(Sender: TObject);
var
  orte: TStringList;
begin
  BeginHourGlass;
  orte := TStringList.create;
  orte.LoadFromFile(SearchDir + 'Complete.txt');
  orte.sort;
  removeduplicates(Orte);
  orte.SaveToFile(SearchDir + 'Complete.txt');
  orte.Free;
  EndHourGlass;
end;

procedure TFormGeoPostleitzahlen.Button6Click(Sender: TObject);
var
  AllPLZData: TStringList;
  OneLine: string;
  MyTick: dword;
  n, RecAll: integer;
  id: int64;
  qPOSTLEITZAHLEN: TIB_Query;
begin
  BeginHourGlass;

  label4.caption := 'Vorlauf ...';
  Application.processmessages;

  AllPLZData := TStringList.create;
  AllPlzData.LoadFromFile(SearchDir + 'Complete.txt');
  RecAll := AllPlzData.count;
  progressbar4.max := RecAll;
  progressbar4.Position := 0;
  MyTick := 0;

  e_x_sql('delete from POSTLEITZAHLEN where x is null');

  qPOSTLEITZAHLEN := DataModuleDatenbank.nQuery;

  with qPOSTLEITZAHLEN do
  begin
    sql.add('select * from POSTLEITZAHLEN for update');

    for n := 0 to RecAll - 1 do
    begin
      OneLine := AllPlzData[n];

      insert;
      FieldByName('RID').AsInteger := 0;
      FieldByName('PLZ').AsInteger := strtoint(nextp(OneLine, ';'));
      FieldByName('ORT').AsString := nextp(OneLine, ';');

      // Orte ID
      id := strtointdef(nextp(OneLine, ';'), 0);
      if id > 0 then
        FieldByName('ORTID').AsInteger := id;

      FieldByName('ORTSTEIL').AsString := nextp(OneLine, ';');
      FieldByName('STRASSE').AsString := nextp(OneLine, ';');

      // Strassen ID
      id := strtoint64def(nextp(OneLine, ';'), 0);
      if (id > 0) then
        FieldByName('STRASSEID').Ascurrency := id;

      FieldBYName('NAME1').AsString := nextp(OneLine, ';');
      post;

      if (n = RecAll - 1) or (frequently(MyTick, 333)) then
      begin
        label4.caption := inttostr(n + 1) + '/' + inttostr(RecAll);
        progressbar4.position := n;
        application.processmessages;
        if UserBreak then
          break;
      end;
    end;
  end;
  qPOSTLEITZAHLEN.free;

  progressbar4.position := 0;
  AllPlzData.Free;
  EndHourGlass;
end;

procedure TFormGeoPostleitzahlen.Button4Click(Sender: TObject);
var
  cPLZ: TIB_Cursor;
  RecN, RecAll: integer;
  StartTime: dword;
  ThisStrasseID, LastStrasseID: int64;
  ThisPLZ: string;
  DiversitaetRIDs: TgpIntegerList; // Liste der Einträge mit gleicher Strasse
  PLZs: TStringList;

  procedure SaveDiversitaet;
  begin
    // speichern, nur ab 2 verschiedenen PLZ
    if (DiversitaetRIDs.count > 0) and (PLZs.count > 1) then
    begin
      //
      e_x_sql('update POSTLEITZAHLEN' +
        ' set PLZ_DIVERSITAET = ''' + cC_True + '''' +
        ' where RID in ' + ListasSQL(DiversitaetRIDs));
    end;
  end;

begin
  // erst mal alles auf null
  BeginHourGlass;
  label4.caption := 'Vorlauf ...';
  Application.processmessages;

  e_x_sql('update POSTLEITZAHLEN set PLZ_DIVERSITAET = null');

  DiversitaetRIDs := TgpIntegerList.create;
  PLZs := TStringList.create;
  cPLZ := DataModuleDatenbank.nCursor;
  LastStrasseID := -1;
  StartTime := 0;
  RecN := 0;
  with cPLZ do
  begin
    sql.add('select RID,STRASSEID,PLZ from POSTLEITZAHLEN where');
    sql.add(' (STRASSEID is not null)');
    sql.add('order by');
    sql.add(' STRASSEID,PLZ');
    open;
    RecAll := recordCount;
    progressbar4.max := RecAll;
    ApiFirst;

    while not (eof) do
    begin

      //
      ThisStrasseID := trunc(FieldByName('STRASSEID').AsDouble);
      ThisPLZ := FieldByName('PLZ').AsString;

      //
      if (LastStrasseID <> -1) then
        if (ThisStrasseID <> LastStrasseID) then
        begin
          // Strassen-Wechsel, alte Sachen speichern
          SaveDiversitaet;

          // auf alle Fälle jedoch wieder neue Liste beginnen!
          DiversitaetRIDs.clear;
          PLZs.clear;
        end;

      //
      DiversitaetRIDs.add(FieldByName('RID').AsInteger);
      if (PLZs.indexof(ThisPLZ) = -1) then
        PLZs.add(ThisPLZ);

      // weiter ...
      LastStrasseID := ThisStrasseID;
      ApiNext;
      inc(RecN);
      if eof or (frequently(StartTime, 333)) then
      begin
        label4.caption := inttostr(RecN) + '/' + inttostr(RecAll);
        progressbar4.position := RecN;
        Application.processmessages;
      end;
    end;
    SaveDiversitaet;

  end;
  cPLZ.free;
  DiversitaetRIDs.free;
  PLZs.free;
  progressbar4.position := 0;
  EndHourGlass;

end;

end.

