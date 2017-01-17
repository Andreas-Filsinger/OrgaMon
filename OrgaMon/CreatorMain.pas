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
unit CreatorMain;
//
// 22.04.2004 auf neuen Wordindex umgestellt!
//

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  checklst, ComCtrls, ExtCtrls,
  shellapi, IB_Access, Datenbank,
  globals, IB_Components;

type
  TFormCreatorMain = class(TForm)
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Button4: TButton;
    Button5: TButton;
    CheckListBox1: TCheckListBox;
    Button1: TButton;
    Button2: TButton;
    Button6: TButton;
    Button3: TButton;
    Button7: TButton;
    Button8: TButton;
    ProgressBar1: TProgressBar;
    Label4: TLabel;
    Button10: TButton;
    Label5: TLabel;
    Button9: TButton;
    Label6: TLabel;
    Button11: TButton;
    Label7: TLabel;
    Button13: TButton;
    Label8: TLabel;
    Button12: TButton;
    CheckBox1: TCheckBox;
    Edit8: TEdit;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    IB_Query1: TIB_Query;
    CheckBox2: TCheckBox;
    IB_Query2: TIB_Query;
    IB_Query3: TIB_Query;
    IB_Query4: TIB_Query;
    Label1: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    CheckBox3: TCheckBox;
    Edit2: TEdit;
    Label13: TLabel;
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1Exit(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Edit8Exit(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
  private

    { Private-Deklarationen }
    UserBreak: boolean;
    noten: tDataBaseRec;
    ModeStr: string;
    Delimiter: char;
    TextOutNumber: integer;
    CDR_Ausgabe: boolean;

    //
    procedure ReloadNotenTable;
    function FileName(const AllStr: string): string;
    procedure ClearLager;
    procedure Scramble;
  public
    { Public-Deklarationen }
    procedure CreateSearchIndex;
  end;

var
  FormCreatorMain: TFormCreatorMain;

implementation

{$RANGECHECKS OFF}

uses
  SimplePassword, Splash, wanfix32,
  Creatorok, Creatorwait,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  anfix32, binlager32,
  ArtikelVerlag, WordIndex,
  dbOrgaMon;

{$R *.DFM}

procedure TFormCreatorMain.Scramble;
const
  CRYPT_1 = 2; { must be 0-5    divisor }
  CRYPT_2 = 53; { must be 0-255  modifier }
  Key = 'ANFiSOFT';
  l = length(Key);
type
  NotenCast = array [0 .. pred(sizeof(tDataBaseRec))] of byte;
var
  n: integer;
  c, t: byte;
begin
  c := 0;
  for n := 0 to pred(sizeof(tDataBaseRec)) do
  begin
    if c = 255 then
      c := 0
    else
      inc(c);
    if (c mod 2) = 0 then
      t := (c shr CRYPT_1) xor byte(Key[(c mod l) + 1])
    else
      t := (abs(CRYPT_2 - c)) xor byte(Key[((c mod l) + 1) shr 1]);
    NotenCast(noten)[n] := NotenCast(noten)[n] xor t;
  end;
end;

procedure TFormCreatorMain.Button4Click(Sender: TObject); // Ende
begin
  close;
end;

procedure TFormCreatorMain.ClearLager; // Zwischenlager löschen
begin
  FileDelete(ETFLager + cNotenTableFName);
  FileDelete(ETFLager + '*.' + MUSExtension);
end;

function TFormCreatorMain.FileName(const AllStr: string): string;
// extrahiere DateiName
var
  p, q: byte;
begin
  p := pos('(', AllStr);
  q := pos(')', AllStr);
  if (p = 0) or (q = 0) or (q <= p) then
  begin
    result := '';
  end
  else
  begin
    result := copy(AllStr, succ(p), pred(q - p));
  end;
end;

procedure TFormCreatorMain.ReloadNotenTable; // Zwischenlager-Info neu laden
var
  i: integer;
begin
  // Datei neu laden ...
  CheckListBox1.items.clear;
  if FileExists(ETFLager + cNotenTableFName) then
    CheckListBox1.items.Loadfromfile(ETFLager + cNotenTableFName);

  // Datei-Namen ankreuzen
  for i := 0 to pred(CheckListBox1.items.count) do
    if (pos('(', CheckListBox1.items[i]) > 0) then
      if FileExists(ETFLager + FileName(CheckListBox1.items[i])) then
        CheckListBox1.Checked[i] := true;
end;

procedure TFormCreatorMain.FormCreate(Sender: TObject);
begin
  top := (screen.height div 2) - (height div 2);
  left := (screen.width div 2) - (width div 2);
  caption := ProjektID + ' Rev ' + RevToStr(Version);
  Edit1.Text := ActualSource;
  Label10.caption := CDRAusgabe;
  Edit8.Text := BLAOutFName;
  ReloadNotenTable;
end;

procedure TFormCreatorMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ActualSource := Edit1.Text;
  BLAOutFName := Edit8.Text;
end;

procedure TFormCreatorMain.Edit1Exit(Sender: TObject);
begin
  Edit1.Text := AddBackSlash(Edit1.Text);
  ActualSource := Edit1.Text;
end;

procedure TFormCreatorMain.Button2Click(Sender: TObject); // edit noten.txt
var
  ExecuteString: array [0 .. 255] of char;
begin
  if FileExists(ETFLager + cNotenTableFName) then
  begin
    StrPCopy(ExecuteString, ETFLager + cNotenTableFName);
    ShellExecute(Application.handle, 'open', ExecuteString, '', '', sw_showmaximized);
    ShowMessage('Datei neu laden?');
    ReloadNotenTable;
  end
  else
  begin
    ShowMessage('Datei ' + cNotenTableFName + ' im Verzeichnis ' + ETFLager + ' nicht gefunden!');
  end;
end;

procedure TFormCreatorMain.Button1Click(Sender: TObject); // edit historie
begin
  if not(FileExists(MyProgramPath + cHistorieTextFName)) then
    FileEmpty(MyProgramPath + cHistorieTextFName);
  openShell(MyProgramPath + cHistorieTextFName);
end;

procedure TFormCreatorMain.Button5Click(Sender: TObject); // create CD
var
  i: integer;
  notenF: TextFile;
  serialF: TextFile;
  cryptF: TextFile;
begin
  FormCreatorWait.show;
  FormCreatorWait.Label2.caption := 'Vorlauf...';
  FormCreatorWait.refresh;

  // Noten.txt erzeugen, etf - kopieren - patchen -
  assignFile(notenF, CDRAusgabe + cNotenTableFName);
{$I-}
  rewrite(notenF);
{$I+}
  if ioresult <> 0 then
  begin
    FormCreatorWait.close;
    ShowMessage('Das Ausgabe-Verzeichnis ' + CDRAusgabe + ' ist ungültig!');
    exit;
  end;

  // Alle Dateien im Zielverzeichnis löschen
  FileDelete(CDRAusgabe + '*.' + MUSExtension);

  // Nummern und PWDs bestimmen
  ActualPwdNoten := FindANewPassword(MyProgramPath + cHistorieTextFName);
  ActualPwdHaendler := FindANewPassword(MyProgramPath + cHistorieTextFName);
  ActualSerialNumber := FindANewSerialNumber(MyProgramPath + SerialText);

  // Original von Crypt.txt erzeugen
  assignFile(cryptF, MyProgramPath + CryptOriginal);
  rewrite(cryptF);
  writeln(cryptF, 'anfisoft ' + ActualSerialNumber + ' serial number');
  closeFile(cryptF);

  (* // imp pend
    // verschlüsseln, a) für Noten
    Source := TEncryptedFileStream.create(MyProgramPath + CryptOriginal, fmOpenRead);
    Source.key := ActualPwdNoten;
    if FileExists(CDRAusgabe + CryptAusgabe) then
    DeleteFile(CDRAusgabe + CryptAusgabe);
    Dest := TFileStream.create(CDRAusgabe + CryptAusgabe, fmCreate);
    Dest.CopyFrom(Source, 0);
    Dest.free;
    Source.free;

    // verschlüsseln, b) für Händler-Version
    Source := TEncryptedFileStream.create(MyProgramPath + CryptOriginal, fmOpenRead);
    Source.key := ActualPwdHaendler;
    if FileExists(CDRAusgabe + cHaendlerFName) then
    DeleteFile(CDRAusgabe + cHaendlerFName);
    Dest := TFileStream.create(CDRAusgabe + cHaendlerFName, fmCreate);
    Dest.CopyFrom(Source, 0);
    Dest.free;
    Source.free;
  *)

  // serial.txt erzeugen
  assignFile(serialF, CDRAusgabe + SerialFName);
  rewrite(serialF);
  writeln(serialF, ActualSerialNumber);
  closeFile(serialF);

  // Aktion für einzelne Dateien durchführen
  (*
    for i := 0 to pred(CheckListBox1.items.count) do
    if CheckListBox1.checked[i] then
    begin
    FormCreatorWait.label2.caption := FileName(CheckListBox1.items[i]) + '...';
    FormCreatorWait.refresh;

    if FileExists(ETFLager + FileName(CheckListBox1.items[i])) then
    begin

    // Patch '0000-0000'
    PatchedF := TFilterFileStream.create(ETFLager + FileName(CheckListBox1.items[i]), fmOpenRead);
    PatchedF.FindStr := '0000-0000';
    PatchedF.ReplaceStr := ActualSerialNumber;

    PatchedF.SaveToPatchFile(CDRAusgabe + 'temp.' + MUSExtension);

    if (PatchedF.Patched > 0) then
    begin

    PatchedF.Free;

    // Noten jetzt verschlüsseln
    Source := TEncryptedFileStream.create(CDRAusgabe + 'temp.' + MUSExtension, fmOpenRead);
    Source.key := ActualPwdNoten;

    // create destination
    Dest := TFileStream.create(CDRAusgabe + FileName(CheckListBox1.items[i]), fmCreate);

    // copy it!
    Dest.CopyFrom(Source, 0);
    Dest.free;
    Source.free;


    // make an entry in CDR-noten.txt
    writeln(notenF, CheckListBox1.items[i]);

    end else
    begin

    PatchedF.free;
    ShowMessage('In ' + FileName(CheckListBox1.items[i]) + ' kein Text "0000-0000" gefunden!');

    end;

    assignFile(Delf, CDRAusgabe + 'temp.' + MUSExtension);
    erase(DelF);

    end else
    begin
    ShowMessage('Quell-Datei ' + FileName(CheckListBox1.items[i]) + ' nicht gefunden!');
    end;
    end;
  *)

  closeFile(notenF);
  FormCreatorWait.close;

  // Arbeit abschließen
  with FormCreatorOK do
  begin
    Label4.caption := ActualSerialNumber;
    Label5.caption := ActualPwdNoten;
    Label7.caption := ActualPwdHaendler;
    Edit1.Text := '';
    CheckListBox1.clear;
    CheckListBox1.items.Loadfromfile(CDRAusgabe + cNotenTableFName);
    for i := 0 to pred(CheckListBox1.items.count) do
      CheckListBox1.Checked[i] := true;
    show;
  end;
end;

procedure TFormCreatorMain.Button3Click(Sender: TObject);
// neues MUS Verzeichnis hinzu
begin
  raise Exception.Create('Muss wegen TBrowseDirectoryDlg neu implementiert werden!');
end;
(*
  var
  Browse: TBrowseDirectoryDlg;
  sr: TSearchRec;
  SrcF, DestF: TFileStream;
  Found: integer;

  NotenSrc: TStringList;
  NotenDest: TStringList;
  n: integer;
  begin
  Browse := TBrowseDirectoryDlg.create(FormCreatorMain);
  Browse.Selection := edit1.Text;
  Browse.Title := 'Durchsuchen';
  if Browse.execute then
  begin

  cursor := crHourglass;

  // Inhalt des neuen Verzeichnis in den
  // Temporär-Speicher kopieren!!!
  edit1.Text := AddBackSlash(Browse.Selection);
  ActualSource := edit1.Text;

  // Alle Dateien kopieren
  Found := findfirst(ActualSource + '*.' + MUSExtension, faAnyFile - faDirectory, sr);
  while found = 0 do
  begin

  // FileCopy
  if FileExists(ETFLager + sr.name) then
  begin
  ShowMessage('Datei-Name: ' + sr.name + ' existiert bereits! Bitte eindeutige Namen verwenden');
  break;
  end else
  begin
  srcF := TFileStream.create(ActualSource + sr.name, fmOpenRead);
  DestF := TFileStream.create(ETFLager + sr.name, fmCreate);
  DestF.CopyFrom(srcF, 0);
  srcF.free;
  DestF.free;
  end;
  found := findnext(sr);
  end;
  findclose(sr);

  // Noten-Tabelle ergänzen
  NotenSrc := TStringList.create;
  NotenDest := TStringList.create;
  if FileExists(ActualSource + cNotenTableFName) then
  NotenSrc.LoadFromFile(ActualSource + cNotenTableFName);
  if FileExists(ETFLager + cNotenTableFName) then
  NotenDest.LoadFromFile(ETFLager + cNotenTableFName);
  for n := 1 to NotenSrc.count do
  NotenDest.add(NotenSrc[pred(n)]);
  NotenDest.SaveToFile(ETFLager + cNotenTableFName);
  NotenSrc.free;
  NotenDest.free;

  // Noten-Tabelle laden
  ReloadNotenTable;
  FocusControl(edit1);

  cursor := crdefault;
  end;
  Browse.free;
  end;
*)

procedure TFormCreatorMain.Button6Click(Sender: TObject); // CD neu
begin
  ClearLager;
  ReloadNotenTable;
end;

procedure TFormCreatorMain.Button7Click(Sender: TObject);
// Noten.txt in der Quelle bearbeiten
begin
  if FileExists(ActualSource + cNotenTableFName) then
  begin
    openShell(ActualSource + cNotenTableFName);
  end
  else
  begin
    ShowMessage('Datei ' + cNotenTableFName + ' nicht im Verzeichnis ' + ActualSource + ' gefunden!');
  end;
end;

procedure TFormCreatorMain.Button8Click(Sender: TObject); // check noten.txt
var
  noten: TStringList;
  i: integer;
  Changes: integer;
  sr: TSearchRec;
  Found: integer;
  FileNameFound: boolean;
begin
  Changes := 0;

  // Test 1, -> alle MUS Dateien auch wirklich existent?
  noten := TStringList.Create;
  if FileExists(ActualSource + cNotenTableFName) then
  begin
    noten.Loadfromfile(ActualSource + cNotenTableFName);
    for i := 0 to pred(noten.count) do
      if pos('(', noten[i]) > 0 then
      begin
        if not(FileExists(ActualSource + FileName(noten[i]))) then
        begin
          if pos('<fehlt>', noten[i]) <> 1 then
          begin
            noten[i] := '<fehlt> ' + noten[i];
            inc(Changes);
          end;
        end;
      end;
  end;

  // Test 2, -> alle MUS Dateien auch eingetragen?
  Found := findfirst(ActualSource + '*.' + MUSExtension, faAnyFile - faDirectory, sr);
  while (Found = 0) do
  begin
    FileNameFound := false;
    for i := 0 to pred(noten.count) do
      if uppercase(FileName(noten[i])) = uppercase(sr.name) then
      begin
        FileNameFound := true;
        break;
      end;
    if not(FileNameFound) then
    begin
      inc(Changes);
      noten.add(' ... (' + sr.name + ')');
    end;
    Found := findnext(sr);
  end;
  findclose(sr);

  if Changes > 0 then
  begin
    noten.SaveToFile(ActualSource + cNotenTableFName);
    Button7Click(self);
    // case Messagedlg('Änderungen notewendig! Automatisch einfügen?',mtError	,[mbYes,mbNo],0) of
    // mryes:
    // end;
  end
  else
  begin
    ShowMessage('Alles OK, bzw. Fehler bereits markiert!');
  end;
end;


// tools

const
  LoStr: string = 'abcdefghijklmnopqrstuvwxyzäöüßABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  UpStr: string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZAOUSABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

function LowerStr(const x: string): string;
var
  OutStr: string;
  n, k: integer;
begin
  OutStr := x;
  for n := 1 to length(OutStr) do
  begin
    k := pos(OutStr[n], UpStr);
    if k > 0 then
      OutStr[n] := LoStr[k];
  end;
  result := OutStr;
end;

function UpperStr(const x: string): string;
var
  OutStr: string;
  n, k: integer;
begin
  OutStr := x;
  for n := 1 to length(OutStr) do
  begin
    k := pos(OutStr[n], LoStr);
    if k > 0 then
      OutStr[n] := UpStr[k];
  end;
  result := OutStr;
end;

function MacField(OutStr: string): string;
begin
  result := Ansi2Mac(OutStr);
  ersetze(cHochKommaMac, '''', result);
end;

procedure TFormCreatorMain.Button10Click(Sender: TObject);

var
  k: integer;
  StartTime: dword;
  PreisStr: string;
  BemerkungStr: string;
  DemoTextNo: integer;
  ActRecNo: integer;

  // artikel.bin ausgabe
  BinF: file of tDataBaseRec;
  ActIndex: integer;

  // Wortanfänge
  BigWordStr: string;

  // Debug-Sachen
  PostErrorList: TStringList;

  // Sachen für die Composer-TXT
  ComposerList: TStringList;
  ComposerOutput: TStringList;
  ComposerDoppel: TStringList;

  ActComposer, ActComposerInfo, ActArranger, ActArrangerInfo: string;
  SortimentList: TStringList;
  SortimentOK: boolean;

  // Verlags-Sachen
  VerlageList: TList;
  verlag: tVerlag;
  OutF: file of tVerlag;
  VERLAG_R: integer;
  ARTIKEL_R: integer;
  RandomGrenze: integer;

  CDR_Index: TWordIndex;

  // Codes

  procedure PostError(const x: string);
  begin
    PostErrorList.add(noten.artikelno + ' : ' + x);
  end;

  function StrPosCount(const Sub, Main: string): integer;
  var
    MyStr: string;
    k: integer;
    CountOfIt: integer;
  begin
    k := pos(Sub, Main);
    if k = 0 then
    begin
      result := 0;
    end
    else
    begin
      CountOfIt := 0;
      MyStr := Main;
      while true do
      begin
        MyStr[k] := chr(pred(ord(Sub[1])));
        inc(CountOfIt);
        k := pos(Sub, MyStr);
        if k = 0 then
          break;
      end;
      result := CountOfIt;
    end;
  end;

  function VorNachName(const s: string): string;
  var
    k: integer;
  begin
    k := revpos(' ', s);
    if k = 0 then
      k := revpos('.', s);
    if k = 0 then
      result := s
    else
      result := copy(s, succ(k), 255) + ', ' + copy(s, 1, pred(k));

    result := '"' + result + '","' + s + '","' + noten.artikelno + '"';
  end;

  procedure ImportOneFile;
  var
    n, n1: integer;
    TextLager: TBlager;
    ArtikelInfo: TStringList;

    function StoreBigOne(const Value: string): integer;
    var
      n: integer;
      BigLen: integer;
    begin
      if (Value <> '') then
      begin
        // Text eventuell zu groß?
        BigLen := length(Value);
        if succ(BigLen) > PlaceForHugeText then
        begin
          BigLen := pred(PlaceForHugeText);
          PostError(copy(Value, 1, 20) + '... Text zu lang!');
        end;

        // bug, bug: StrPCopy
        // StrPCopy copiert nur 255 Zeichen oder so
        for n := 0 to pred(BigLen) do
          ReallyBigString[n] := Value[succ(n)];
        ReallyBigString[BigLen] := #0;
        inc(TextOutNumber);
        TextLager.insert(TextOutNumber, succ(BigLen));
        result := TextOutNumber;
      end
      else
      begin
        result := 0;
      end;
    end;

    function ReadLongStr(BlockName: string): string;
    var
      MachineState: byte;
      n, k: integer;
    begin
      result := '';
      MachineState := 0;
      for n := 0 to pred(ArtikelInfo.count) do
      begin
        case MachineState of
          0:
            begin
              k := pos(BlockName + '=', ArtikelInfo[n]);
              if (k = 1) then
              begin
                result := copy(ArtikelInfo[n], length(BlockName) + 2, MaxInt);
                MachineState := 1;
              end;
            end;
          1:
            begin
              k := pos('=', ArtikelInfo[n]);
              if (k = 0) or (k > 11) then
                result := result + #13 + ArtikelInfo[n]
              else
                exit;
            end;
        end;
      end;
    end;

  begin
    IB_Query1.Open;
    IB_Query3.Open;
    IB_Query4.Open;

    ArtikelInfo := TStringList.Create;
    VerlageList := TList.Create; // indexof
    CDR_Index := TWordIndex.Create(nil);

    if CDR_Ausgabe then
    begin
      IB_Query2.Open;
      SortimentList := TStringList.Create;
      with IB_Query2 do
      begin
        first;
        while not(eof) do
        begin
          if (FieldByName('CD_R').AsString = cC_True) then
            SortimentList.add(FieldByName('RID').AsString);
          next;
        end;
      end;
      SortimentList.sort;
      IB_Query2.close;
    end;

    // TextAusgabe
    if FileExists(CDRAusgabe + '..\system\Texte' + ModeStr + '.BLA') then
      FileDelete(CDRAusgabe + '..\system\Texte' + ModeStr + '.BLA');
    TextLager := TBlager.Create;
    TextLager.init(CDRAusgabe + '..\system\Texte' + ModeStr, ReallyBigString, sizeof(ReallyBigString));
    TextLager.BeginTransAction;

    ProgressBar1.Min := 0;
    ProgressBar1.Max := IB_Query1.RecordCount;
    ProgressBar1.Step := 1;
    ActRecNo := 0;
    RandomGrenze := strtol(Edit2.Text);

    if CheckBox1.Checked then
      DemoTextNo := StoreBigOne('???');

    StartTime := GetTickCount;
    IB_Query1.first;
    SortimentOK := true;
    BigWordStr := '';
    while not(IB_Query1.eof) do
    begin
      inc(ActRecNo);

      // ab und zu Windows Zeit geben, aber nicht so oft
      if frequently(StartTime, 444) then
      begin
        Label5.caption := format('[%d] %s', [ActIndex, BigWordStr]);
        Application.processmessages;
        ProgressBar1.Position := ActRecNo;
      end;

      if CDR_Ausgabe then
        SortimentOK := (SortimentList.IndexOf(IB_Query1.FieldByName('SORTIMENT_R').AsString) <> -1);

      if CheckBox3.Checked and (SortimentOK) then
        SortimentOK := (random(100) < RandomGrenze);

      if SortimentOK then
      begin

        // Ausgabe
        fillchar(noten, sizeof(noten), 0);
        with noten, IB_Query1 do
        begin

          ARTIKEL_R := FieldByName('RID').AsInteger;

          // ev. Verlag addieren
          // ### imp pend

          FieldByName('INTERN_INFO').AssignTo(ArtikelInfo);

          PaperColor := FieldByName('PAPERCOLOR').AsInteger;
          if PaperColor = 0 then
            PaperColor := clpaper + (random($80) shl 16) + (random($80) shl 08) + random($80);

          artikelno := FieldByName('NUMERO').AsString;

          try
            Land := e_r_LaenderISO(FieldByName('LAND_R').AsInteger);
            Titel := FieldByName('TITEL').AsString;

            ActComposer := e_r_MusikerName(FieldByName('KOMPONIST_R').AsInteger);
            Komponist := ActComposer;
            if pos(',', Komponist) > 0 then
              PostError('Das Zeichen "," ist im Komponisten verboten!');

            ActArranger := e_r_MusikerName(FieldByName('ARRANGEUR_R').AsInteger);;
            Arranger := ActArranger;
            if pos(',', Komponist) > 0 then
              PostError('Das Zeichen "," ist im Arrangeur verboten!');

            preis := e_r_PreisBrutto(0, ARTIKEL_R);

            VERLAG_R := FieldByName('VERLAG_R').AsInteger;
            if (VERLAG_R > 0) then
            begin
              dealerID := inttostr(VERLAG_R);
              if VerlageList.IndexOf(pointer(VERLAG_R)) = -1 then
                VerlageList.add(pointer(VERLAG_R));
            end
            else
            begin
              dealerID := '';
            end;
            if CheckBox1.Checked then
              verlag := '???'
            else
              verlag := e_r_Verlag_PERSON_R(VERLAG_R);

            Serie := ArtikelInfo.Values['SERIE'];
            BemerkungStr := ReadLongStr('BEM');
            Bemerkung := StoreBigOne(BemerkungStr);
            ProbeStimme := ArtikelInfo.Values['PROBESTIMME'];
            Aufnahme := ArtikelInfo.Values['AUFNAHME'];
            Sparte := ArtikelInfo.Values['GATTUNG'];
            BildDokument := e_r_ArtikelDokument(0, ARTIKEL_R, cMediumBild);

            //
            schwer := cutblank(FieldByName('SCHWER_GRUPPE').AsString + ' ' + FieldByName('SCHWER_DETAILS').AsString);
            Dauer := FieldByName('DAUER').AsString;

            if CheckBox1.Checked then
            begin
              Komposition := DemoTextNo;
            end
            else
              Komposition := StoreBigOne(ReadLongStr('Ü1'));

            if FieldByName('KOMPONIST_R').IsNull then
              ActComposerInfo := ''
            else
              ActComposerInfo := e_r_MusikerUeber(FieldByName('KOMPONIST_R').AsInteger);

            if CheckBox1.Checked then
            begin
              UeberKomponist := DemoTextNo;
            end
            else
              UeberKomponist := StoreBigOne(ActComposerInfo);

            if FieldByName('ARRANGEUR_R').IsNull then
              ActArrangerInfo := ''
            else
              ActArrangerInfo := e_r_MusikerUeber(FieldByName('ARRANGEUR_R').AsInteger);

            if CheckBox1.Checked then
            begin
              UeberArranger := DemoTextNo;
            end
            else
              UeberArranger := StoreBigOne(ActArrangerInfo);

            if (ActComposer <> '') then
            begin
              if (ComposerList.IndexOf(ActComposer) = -1) then
              begin
                ComposerList.add(ActComposer);
                ComposerDoppel.add(VorNachName(ActComposer));
                ComposerOutput.add('"' + ActComposer + '","' + ActComposerInfo + '"');
              end;
            end;

            if (ActArranger <> '') then
            begin
              if (ComposerList.IndexOf(ActArranger) = -1) then
              begin
                ComposerList.add(ActArranger);
                ComposerDoppel.add(VorNachName(ActArranger));
                ComposerOutput.add('"' + ActArranger + '","' + ActArrangerInfo + '"');
              end;
            end;

            BestellNo := ArtikelInfo.Values['VERLAGNO'];
            PreisStr := ArtikelInfo.Values['PREISSTR2'];
            if (PreisStr <> '') then
            begin
              k := pos('.', PreisStr);
              if (k > 0) then
                PreisStr[k] := FormatSettings.DecimalSeparator;
              try

                OrgCurrency := '';
                for n1 := 1 to length(PreisStr) do
                begin
                  if (PreisStr[n1] = ' ') then
                    PreisStr[n1] := '#';
                  if (PreisStr[n1] = '-') then
                    PreisStr[n1] := '0';
                  if not(PreisStr[n1] in ['#', '0' .. '9', FormatSettings.DecimalSeparator]) then
                  begin
                    OrgCurrency := OrgCurrency + PreisStr[n1];
                    PreisStr[n1] := '#';
                  end;
                end;

                repeat
                  n1 := pos('#', PreisStr);
                  if n1 = 0 then
                    break;
                  system.delete(PreisStr, n1, 1);
                until false;

                Orgpreis := strtofloatdef(PreisStr, 0);
              except
                PostError('Wandlungsfehler im Preis-Feld');
              end;
            end
            else
            begin
              Orgpreis := 0.0;
              OrgCurrency := '';
            end;

            EntryDate := 0;

            PreisStr := ArtikelInfo.Values['MP3'];
            if (PreisStr = '') then
              SoundSource := 0
            else
              SoundSource := strtointdef(PreisStr, 0);

            (*
              if not(FieldByName('HAENDLER_R').IsNull) then
              dealerID       := FieldByName('HAENDLER_R').AsString
              else
              dealerID       := '';
            *)

            BigWordStr := AnsiUpperCase(Titel + ' ' + Komponist + ' ' + Arranger + ' ' + Serie + ' ' + artikelno + ' ' +
              verlag + ' ' + BemerkungStr + ' ' + Sparte);

            // DebugOut.add(BigWordStr);
            // den String zerlegen in lauter einzelne Worte
            CDR_Index.addwords(BigWordStr, TObject(ActIndex));

          except
            on E: Exception do
            begin
              PostError('Lese-Exception bei ' + artikelno);
              PostError(E.Message);
            end;
          end;

        end;
        Scramble;
        write(BinF, noten);
        inc(ActIndex);
      end;

      if UserBreak then
        break;
      IB_Query1.next;
    end;
    CDR_Index.JoinDuplicates(false);
    CDR_Index.SaveToFile(CDRAusgabe + '..\system\WrdIdx' + ModeStr + '.idx');
    CDR_Index.free;

    // nun die benutzen Verlage ausgeben
    fillchar(verlag, sizeof(tVerlag), 0);
    FileDelete(CDRAusgabe + '..\system\verlage.bin');
    assignFile(OutF, CDRAusgabe + '..\system\verlage.bin');
    rewrite(OutF);
    Label5.caption := 'Verlage ...';
    for n := 0 to pred(VerlageList.count) do
    begin
      VERLAG_R := integer(VerlageList[n]);

      IB_Query3.ParamByName('CROSSREF').AsInteger := VERLAG_R;
      IB_Query4.ParamByName('CROSSREF').AsInteger := IB_Query3.FieldByName('PRIV_ANSCHRIFT_R').AsInteger;

      if not(IB_Query3.IsEmpty) and not(IB_Query4.IsEmpty) then
      begin

        with verlag do
        begin
          nummer := inttostr(VERLAG_R);
          name := IB_Query4.FieldByName('NAME1').AsString;
          Ansprechpartner := IB_Query3.FieldByName('NACHNAME').AsString + ', ' +
            IB_Query3.FieldByName('VORNAME').AsString;
          strasse := IB_Query4.FieldByName('STRASSE').AsString;
          Ort := HugeSingleLine(e_r_Ort(IB_Query4),'|',2,true);
          tel := IB_Query3.FieldByName('GESCH_TEL').AsString;
          fax := IB_Query3.FieldByName('GESCH_FAX').AsString;
          eMail := IB_Query3.FieldByName('EMAIL').AsString;
          website := IB_Query3.FieldByName('WEBSITE').AsString;

          if frequently(StartTime, 333) then
          begin
            Label5.caption := 'Verlag ' + name;
          end;

        end;
        DataScramble(verlag, sizeof(tVerlag));
        write(OutF, verlag);
      end;
    end;
    closeFile(OutF);
    VerlageList.free;

    TextLager.EndTransAction;
    TextLager.free;
    ArtikelInfo.free;

    IB_Query1.close;
    IB_Query3.close;
    IB_Query4.close;

    if CDR_Ausgabe then
    begin
      SortimentList.free;
    end;
  end;

begin
  CDR_Ausgabe := CheckBox2.Checked;

  PostErrorList := TStringList.Create;

  ComposerList := TStringList.Create;
  ComposerList.Sorted := true;

  ComposerOutput := TStringList.Create;
  ComposerOutput.Sorted := true;

  ComposerDoppel := TStringList.Create;
  ComposerDoppel.Sorted := true;

  if CDR_Ausgabe then
  begin
    CDRAusgabe := MyProgramPath + 'CD-R\Noten\';
  end
  else
  begin
    CDRAusgabe := MyProgramPath + 'Noten\';
  end;
  Label10.caption := CDRAusgabe;

  // Ausgabe-Datei öffnen
  FileDelete(CDRAusgabe + '..\system\artikel' + ModeStr + '.bin');
  assignFile(BinF, CDRAusgabe + '..\system\artikel' + ModeStr + '.bin');
  rewrite(BinF);

  // Wortanfänge

  StartTime := GetTickCount;
  ActIndex := 0;
  UserBreak := false;

  ImportOneFile;

  closeFile(BinF);
  if (PostErrorList.count > 0) then
    PostErrorList.SaveToFile(DiagnosePath + 'DatenbankFehler.txt');
  PostErrorList.free;

  if (ComposerList.count > 0) then
    ComposerList.SaveToFile(DiagnosePath + 'AlleMusiker.txt');
  ComposerList.free;

  if (ComposerOutput.count > 0) then
    ComposerOutput.SaveToFile(DiagnosePath + 'composer.txt');
  ComposerOutput.free;

  if (ComposerDoppel.count > 0) then
    ComposerDoppel.SaveToFile(DiagnosePath + 'comp2.txt');
  ComposerDoppel.free;

  ProgressBar1.Position := 0;
  if UserBreak then
  begin
    Label5.caption := format('abgebrochen [%d]', [ActIndex])
  end
  else
  begin
    Label5.caption := format('fertig [%d]', [ActIndex]);
  end;
end;

procedure TFormCreatorMain.Button9Click(Sender: TObject);
begin
  UserBreak := true;
end;

procedure TFormCreatorMain.Button13Click(Sender: TObject);
const
  MaxMedia = 20;
var
  BinF: file of tDataBaseRec;
  Komponisten: TStringList;
  KomponistenText: TStringList;
  Laender: TStringList;
  Schwierigkeitsgrade: TStringList;
  Verlage: TStringList;
  SparteListe: TStringList;
  MedienListe: TStringList;
  StartTime: dword;
  n, k: integer;
  MediaStrings: array [1 .. MaxMedia] of TStringList;
  TxtLager: TBlager;
  LastNumberCode: integer;

  function GetTxtNo(no: integer): string;
  begin
    if no = 0 then
      result := ''
    else
    begin
      if TxtLager.exist(no) then
      begin
        TxtLager.get;
        result := ReallyBigString;
        ersetze(#13, '#da', result);
        ersetze(#10, '#da', result);
      end
      else
      begin
        result := 'FAIL:TxtLager.GetTxtNo(' + inttostr(no) + ')';
      end;
    end;
  end;

  procedure InsertIt(Komponisten: TStringList; s: string);
  var
    r: integer;
  begin
    if (s <> '') then
    begin
      r := revpos(' ', s);
      if r > 0 then
        s := copy(s, succ(r), MaxInt) + ', ' + copy(s, 1, pred(r));
      if Komponisten.IndexOf(s) = -1 then
      begin
        Komponisten.add(s);
        KomponistenText.add(s + ';;;' + GetTxtNo(LastNumberCode));
      end;
    end;
  end;

  procedure InsertItUnChanged(Komponisten: TStringList; s: string);
  begin
    if s <> '' then
    begin
      if Komponisten.IndexOf(s) = -1 then
        Komponisten.add(s);
    end;
  end;

  function cutblank(const inpstr: string): string;
  var
    OutStr: string;
  begin
    OutStr := inpstr;
    while (OutStr <> '') and (OutStr[1] = ' ') do
      delete(OutStr, 1, 1);
    while (OutStr <> '') and (OutStr[length(OutStr)] = ' ') do
      delete(OutStr, length(OutStr), 1);
    cutblank := OutStr;
  end;

  procedure TryInsertKomponisten(InsertStr: string; TextInfo: integer);
  begin
    LastNumberCode := TextInfo;
    if InsertStr = '' then
      exit;
    while true do
    begin
      k := pos('/', InsertStr);
      if k = 0 then
      begin
        InsertIt(Komponisten, cutblank(InsertStr));
        exit;
      end
      else
      begin
        InsertIt(Komponisten, cutblank(copy(InsertStr, 1, pred(k))));
        InsertStr := cutblank(copy(InsertStr, succ(k), MaxInt))
      end;
    end;
  end;

begin
  ModeStr := '0';
  Komponisten := TStringList.Create;
  Komponisten.Sorted := true;

  KomponistenText := TStringList.Create;
  KomponistenText.Loadfromfile('G:\delphi\hebu\berichte\autoren gefunden.txt');
  KomponistenText.Sorted := true;

  Laender := TStringList.Create;
  Laender.Sorted := true;
  Schwierigkeitsgrade := TStringList.Create;
  Schwierigkeitsgrade.Sorted := true;
  Verlage := TStringList.Create;
  Verlage.Sorted := true;

  SparteListe := TStringList.Create;
  SparteListe.Sorted := true;
  MedienListe := TStringList.Create;
  MedienListe.Sorted := true;

  UserBreak := false;
  StartTime := GetTickCount;
  assignFile(BinF, CDRAusgabe + '..\system\artikel' + ModeStr + '.bin');
  reset(BinF);

  TxtLager := TBlager.Create;
  TxtLager.init(CDRAusgabe + '..\system\texte' + ModeStr, ReallyBigString, sizeof(ReallyBigString));
  TxtLager.BeginTransAction;

  ProgressBar1.Min := 0;
  ProgressBar1.Max := FileSize(BinF);
  ProgressBar1.Step := 1;

  // Medien-Dateien löschen
  for n := 1 to MaxMedia do
  begin
    MediaStrings[n] := TStringList.Create;
    MediaStrings[n].Sorted := true;
  end;

  while not(eof(BinF)) do
  begin
    if GetTickCount > (StartTime + 500) then
    begin
      Label5.caption := format('[%d:%d] %s', [FilePos(BinF), Komponisten.count, noten.Komponist]);
      Application.processmessages;
      StartTime := GetTickCount;
      if UserBreak then
        break;
    end;
    read(BinF, noten);
    Scramble;
    with noten do
    begin
      TryInsertKomponisten(Komponist, UeberKomponist);
      TryInsertKomponisten(Arranger, UeberArranger);
      InsertItUnChanged(Laender, Land);
      InsertItUnChanged(Verlage, verlag);
      InsertItUnChanged(Schwierigkeitsgrade, schwer);
      InsertItUnChanged(SparteListe, Sparte);
      InsertItUnChanged(MedienListe, inttostr(SoundSource));
      if (SoundSource > 0) then
        MediaStrings[SoundSource].add(artikelno);
    end;

    ProgressBar1.StepBy(1);
  end;
  closeFile(BinF);

  Komponisten.SaveToFile(DiagnosePath + 'Komponisten.txt');
  Komponisten.free;
  KomponistenText.SaveToFile(DiagnosePath + 'autoren.txt');
  KomponistenText.free;
  Laender.SaveToFile(DiagnosePath + 'Laender.txt');
  Laender.free;
  Schwierigkeitsgrade.SaveToFile(DiagnosePath + 'Schwierigkeitsgrade.txt');
  Schwierigkeitsgrade.free;
  Verlage.SaveToFile(DiagnosePath + 'Verlage.txt');
  Verlage.free;
  SparteListe.SaveToFile(DiagnosePath + 'Sparten.txt');
  SparteListe.free;
  MedienListe.SaveToFile(DiagnosePath + 'Medien.txt');
  MedienListe.free;

  for n := 1 to MaxMedia do
  begin
    if (MediaStrings[n].count > 0) then
      MediaStrings[n].SaveToFile(DiagnosePath + 'Inhalt von Medium ' + inttostr(n) + '.txt');
    MediaStrings[n].free;
  end;

  TxtLager.EndTransAction;
  TxtLager.free;
  ProgressBar1.Position := 0;
end;

procedure TFormCreatorMain.Button12Click(Sender: TObject);
begin
  Label5.caption := 'Vorlauf ...';
  Application.processmessages;
  ModeStr := '0';
  Delimiter := ',';
  Button10Click(self);
  Label5.caption := 'fertig!';
end;

procedure TFormCreatorMain.Edit8Exit(Sender: TObject);
begin
  BLAOutFName := Edit8.Text;
end;

procedure TFormCreatorMain.Button17Click(Sender: TObject);
begin
  openShell(DiagnosePath + 'DatenbankFehler.txt');
end;

procedure TFormCreatorMain.Button18Click(Sender: TObject);
var
  BigPwdInfo: TStringList;
  HEntryOut: TStringList;
  n: integer;
  LastUserUpdate: dword;
  UserName: string;
begin
  LastUserUpdate := 0;
  BigPwdInfo := TStringList.Create;
  HEntryOut := TStringList.Create;
  BigPwdInfo.Loadfromfile(MyProgramPath + cHistorieTextFName);
  ProgressBar1.Max := BigPwdInfo.count;
  for n := 0 to pred(BigPwdInfo.count) do
  begin
    if (length(BigPwdInfo[n]) > 40) then
    begin
      if (BigPwdInfo[n][11] = ';') and (BigPwdInfo[n][22] = ';') and (BigPwdInfo[n][33] = ';') then
        if (pos('²', BigPwdInfo[n]) = 0) then
        begin
          UserName := copy(BigPwdInfo[n], 45, MaxInt);
          ersetze('³', '', UserName);
          UserName := cutblank(UserName);

          if (pos('³', BigPwdInfo[n]) = 0) then
            HEntryOut.add(copy(BigPwdInfo[n], 1, 9) + ';' + copy(BigPwdInfo[n], 35, 9) + ';' + UserName + ';')
          else
            HEntryOut.add(copy(BigPwdInfo[n], 1, 9) + ';' + copy(BigPwdInfo[n], 35, 9) + ';' + UserName + ';H');

        end;
    end;
    if frequently(LastUserUpdate, 300) then
      ProgressBar1.Position := n;
  end;
  Label5.caption := inttostr(HEntryOut.count) + ' Kombinationen "pwd;Serienummer"';
  HEntryOut.SaveToFile(MyProgramPath + cPwdAllTextFName);
  BigPwdInfo.free;
  HEntryOut.free;
  ProgressBar1.Position := 0;
end;

procedure TFormCreatorMain.Button19Click(Sender: TObject);
begin
  openShell(MyProgramPath + cPwdAllTextFName);
end;

procedure TFormCreatorMain.CreateSearchIndex;
begin
  CheckBox1.Checked := false;
  CheckBox2.Checked := false;
  show;
  Button12.Click;
  close;
end;

procedure TFormCreatorMain.CheckBox2Click(Sender: TObject);
begin
  CDR_Ausgabe := CheckBox2.Checked;
  if CDR_Ausgabe then
  begin
    CDRAusgabe := MyProgramPath + 'CD-R\Noten\';
  end
  else
  begin
    CDRAusgabe := MyProgramPath + 'Noten\';
  end;
  Label10.caption := CDRAusgabe;
end;

end.
