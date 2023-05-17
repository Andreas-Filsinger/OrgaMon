{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2021  Andreas Filsinger
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
unit binlager;

{
  Persistentes Binäres Lager mit LongInt Index (keine Dupletten) und TimeStamp

  Binäres LAger (c) 1994 - 2023 by Andreas Filsinger

  Aufgabe:
  ========

  * Speicherung unterschiedlich großer binärer Blöcke in einer Datei
  * Für die Datenblöcke werden eindeutige LONGINT Kennungen vergeben
  * Betrieb im Netzwerk ist möglich

  Aufbau der Datenstrukturen:
  ===========================

  Record "Idx" für Idx-Tabelle
  ======================================
  | IDX | Data-Position |


  Record "Free" für Free-Verkettung
  ======================================
  | FreeSize | NextFree |


  Record "Data" für Daten-Speicherung
  ======================================
  | DataSize | [ TimeStamp | ] .... Data .... |


  File-Aufbau:
  ============

  Header:
  =======

  Revision & Copyright  : 100 Chars  = Versions-Info & Hersteller Info
  Index-Position        : longint    = Start-Offset der IDX-Tablle
  Index-Länge           : longint    = Anzahl der IDX-Einträge
  FirstFree             : longint    = Start-Offset des ersten Freien Elementes

  Index-Tabelle:
  ==============

  ======================================
  | idx : integer | DataPos  : integer |
  ======================================
  | idx : integer | DataPos  : integer |
  ======================================
  .
  .
  .

  ======================================
  | idx : integer | DataPos  : integer |
  ======================================
  | idx : integer | DataPos  : integer |
  ======================================
  | idx : integer | DataPos  : integer |
  ======================================


  Daten
  =====

  ===============================================================
  | len : integer | [ TimeStamp  : TDateTime ] | Data : Record  |
  ===============================================================


  "len" : Länge des Data (-Blocks)
  "TimeStamp" : Transaktions-Zeitstempel der letzten "Put" Operation auf diesen Record
  "Data" : die Daten an sich

  Minimale Size eines Data-Records ist MinimumSize, Grund: Wenn Löcher entstehen wird
  an deren Platz ein Element einer verketteten Liste gepspeichert dieses ist Minim-Size
  groß, das bedeutet Löcher kleiner Minimumsize können nicht aufgenommen werden, diese
  Löcher bleiben unverwaltet.

  HISTORIE:
  =========

  20.04.23 setTransactionTimeStamp
  30.04.20 minimale Dokumentationsverbesserungen
  17.03.10 "Write-Access" kann protokolliert werden.
  19.09.07 Umstellung auf TFileStream
  29.09.95 DeleteAll, CreateClone
  09.01.95 Bug: Put hatte nicht "IdxChanged" gesetzt
  07.01.95 Test und weitere Implementierung
  06.01.95 Implementierung (Transaktion, get, ...)
  05.01.95 Implementierung
  16.05.94 Konzept
  05.04.94 Konzept

  Warte-und Ideen- Liste  (too implement...):
  ===========================================

  Transaktions Konzept:

  * Durch die Forderung der Netzwerkfähigkeit muß jede Aktion
    immer komplette abgeschlossen werden. D.h. keine Dateien
    dürfen geöffnet bleiben / es sei denn im shared Mode. Vor allem
    darf das Programm keinerlei Annahmen ber den aktuellen Zustand
    der Datei im RAM-Speicher behalten (z.B. IDX-Tabelle im Speicher
    Informationen ber Records-Größen usf.). Alle Information müssen
    "just in time" neu gebildet werden.
  * Um jedoch die Verarbeitungs Geschwindigkeit zu erhöhen, kann man
    Transaktionen starten, die als Ganzes am Stück ausgeführt werden.
    Während einer Transaktion ist die Datei für alle anderen User
    gesperrt. Sie bleibt für die aktuelle Transaktion geöffnet.
    Indextabellen und File-Header verbleiben im RAM und werden nicht
    gespeichert.

  * Whole-Verwaltung legt bisher nur Löcher an, es werden keine wieder benutzt!

  þ Revision - Konzept verwirklichen

  a) Es gibt ein Kontainer-Revision (internes format der Binären Daten)

  Aktion bei Unstimmigkeit -> automatische Umkonvertierung durch
  Binlager selbst.

  b) Es gibt eine Elements-Revision (Applikations Revision der abgelegten
  daten)

  Aktion bei Unstimmigkeit -> Applikations CallBack
  um Rev x in Rev (y) zu konvertieren (y>x).

  Neues Revision Konzept:

  * im Header wird eine Revision-Nummer gespeichert.

  OK wenn ProgrammRevision = DateiRevision
  Automatischer Umkode, wenn ProgrammRevision > DateiRevision
  FAIL wenn Programmrevision < DateiRevision

}

interface

uses
  classes, anfix;

{ Rev-Info für Auto-Konvert, VORSICHT }
const
  VersionBinLager: single = 1.001;

  ThisVersion: AnsiString =
   {} 'Binary Container Rev. 1.001' + #$0D#$0A +
   {} '(c)''1998-2007 by Andreas Filsinger' + #$0D#$0A +
   {} 'http://www.orgamon.org/' + #$0D#$0A + #26;

  cBL_FileExtension = '.BLA';
  cBL_ClonePostfix = '.clone';
  cBL_FreshPostfix = '.fresh';

type
  IdxRecordType = packed record
    idx: longint; { Record Identification }
    position: longint; { Position of File-Block }
  end;

  FreeRecordType = packed record
    FreeSize: longint; { Free Data-Area over all }
    NextFree: longint; { Next Free Element }
  end;

const
  IdxMax = 2500000;
  MaxReTrys = 20;

type
  IdxArrayType = array [1 .. IdxMax] of IdxRecordType;

type
  FileHeaderType = packed record
    FileID: array [0 .. 99] of AnsiChar;
    IdxPos: longint;
    IdxLen: longint;
    FirstFree: longint;
  end;

  TBLager = class(TObject)

  private
    { local Data }
    TagTable: ^IdxArrayType;
    fh: FileHeaderType;
    Tag, Tags, _Tags: 0 .. IdxMax;
    DataPointer: pointer;
    BinFile: TFileStream;
    BinFileFName: string;
    TransactionLevel: byte; { Transaction Count }
    TransactionUseTime: boolean;
    TransactionTimeStamp: TDateTime;
    IdxChanged: boolean; { saveing of TagTable nessesary? }
    HeaderChanged: boolean; { saveing of FileHeader nessesary? }
    MaxDataLen: longword;

    { Information filled by get }
    ActIdx: longint;
    DataLen: longword;
    TimeStamp: TDateTime;

    { PRIVAT }
    procedure InsertWhole(Start, Length: longint);
    procedure ReportError(No: byte);
    procedure Open; { open file and read the IDX-Table }
    procedure close; { close file and write the IDX-Table }

  public
    ReadOnly: boolean;

    { Administration }
    procedure Init(FName: string; var Data; MaxDataSize: longword);
    procedure Clone(dt: TDateTime = 0.0); { Create a defragmented Clone }
    procedure ReBuild; { Delete all wholes! }
    procedure DeleteAll; { Deletes all Records }
    procedure DeleteOld(dt: TDateTime);

    { Transaction System }
    procedure BeginTransaction(dt: TDateTime = 0.0);
    procedure SetTransactionTimeStamp(dt: TDateTime);
    procedure EndTransaction;
    function InTransAction: boolean;

    { Save Routines }
    procedure insert(NewId: longint; DSize: longint);
    procedure put(DSize: longint);
    procedure touch;

    { Delete Routine }
    procedure delete; { delete Record }

    { Access Routines, Daily Stuff }
    procedure first;
    procedure last;
    procedure next;
    procedure prev;
    function exist(Id: longint): boolean;
    procedure get;

    function eol: boolean;

    function CountRecs: longint; { Number of Data Records }
    function CountWholes: longint; { Space in all Wholes }

    function RecordSize: longword; { actual Record Size }
    function RecordTimeStamp: TDateTime; { last write of Record }
    function RecordIndex: longint; { internal ActIndex }

    property FileName : string read BinFileFName;

  end;

implementation

{$RANGECHECKS OFF}

uses
{$IFNDEF console}
  dialogs,
{$ENDIF}
  sysutils;

const
  BL_NETTIMEOUT = 1; { File is locked too long }
  BL_OLDPROGRAM = 2; { File is created by a newer Program Version }
  BL_ILLEGALFREESIZE = 3; { Free-Loch ist kleiner als MiniMumSize }
  BL_TOOMANYBEGINTRANSACTION = 4;
  BL_TOOMANYENDTRANSACTION = 5;
  BL_LOSTKONTEXT = 6; { next or prev don't work because actual
    Record was deleted by another Application }
  BL_IDXTABLEFULL = 7;
  BL_WHOLETOOSMALL = 8; { Entstandenes Loch ist zu klein }
  BL_INVALIDPOSITIONING = 9; { Actual Record Position is undefined }
  BL_ILLEGALOP = 10; { illegale Operation inerhalb einer Transaktion }
  BL_NODATA = 11; { Record has no Data }
  BL_USE_TS = 12; { Try to write TimeStamp, but Lager does not support this }

  MiniMumSize = sizeof(FreeRecordType);
  cBL_Null = 0;

procedure TBLager.Init(FName: string; var Data; MaxDataSize: longword);
begin
  MaxDataLen := MaxDataSize;
  BinFileFName := FName;
  DataPointer := @Data;
  TransactionLevel := 0;
end;

{ File - Changing - Reading - Atom - Routines }

procedure TBLager.Open;

  procedure CreateFile;
  var
    n: byte;
    BinFile: TFileStream;
  begin
    with fh do
    begin
      fillChar(FileID, sizeof(FileID), #0);
      for n := 1 to Length(ThisVersion) do
        FileID[pred(n)] := ThisVersion[n];
      IdxPos := cBL_Null;
      IdxLen := 0;
      FirstFree := cBL_Null;
    end;
    BinFile := TFileStream.create(BinFileFName + cBL_FileExtension, fmCreate);
    BinFile.Write(fh, sizeof(fh));
    BinFile.Free;
  end;

begin
  new(TagTable);
  if not(FileExists(BinFileFName + cBL_FileExtension)) then
    CreateFile;

  // Öffnen
  if ReadOnly then
    BinFile := TFileStream.create(BinFileFName + cBL_FileExtension,
      fmOpenRead + fmShareDenyWrite)
  else
    BinFile := TFileStream.create(BinFileFName + cBL_FileExtension,
      fmOpenReadWrite);

  { Load the File-Header }
  BinFile.Read(fh, sizeof(fh));
  Tags := fh.IdxLen;
  _Tags := Tags; { Original Size of the Tag-Table }

  { Load the Tag-Table (if valid) }
  if (Tags > 0) then
  begin
    BinFile.position := fh.IdxPos;
    BinFile.Read(TagTable^, Tags * sizeof(IdxRecordType));
  end;

  IdxChanged := false;
  HeaderChanged := false;
end;

procedure TBLager.InsertWhole(Start, Length: longint);
var
  fr: FreeRecordType;
begin
  if (Length = 0) then
    exit;
  if (Length < sizeof(FreeRecordType)) then
  begin
    ReportError(BL_WHOLETOOSMALL);
    exit;
  end;
  fr.FreeSize := Length;
  fr.NextFree := fh.FirstFree;
  fh.FirstFree := Start;
  BinFile.position := Start;
  BinFile.Write(fr, sizeof(FreeRecordType));
  HeaderChanged := true;
end;

procedure TBLager.close;
begin
  if _Tags <> Tags then
  begin
    fh.IdxLen := Tags;
    HeaderChanged := true;
  end;

  if IdxChanged then
  begin

    if _Tags = Tags then
    begin
      { Index Table Size didnt changed }
    end;

    if _Tags > Tags then
    begin
      { Index Table Size decreased, a whole was born }
      InsertWhole(fh.IdxPos + Tags * sizeof(IdxRecordType),
        (_Tags - Tags) * sizeof(IdxRecordType));
    end;

    if _Tags < Tags then
    begin
      { Index Table Size increased }
      InsertWhole(fh.IdxPos, _Tags * sizeof(IdxRecordType));
      fh.IdxPos := BinFile.Size;
      HeaderChanged := true;
    end;
    BinFile.position := fh.IdxPos;
    BinFile.Write(TagTable^, Tags * sizeof(IdxRecordType));

  end;

  if HeaderChanged then
  begin
    BinFile.position := 0;
    BinFile.write(fh, sizeof(FileHeaderType));
  end;

  BinFile.Free;
  dispose(TagTable);
end;

procedure TBLager.insert(NewId: longint; DSize: longint);
begin
  BeginTransaction;

  if (Tags = IdxMax) then
  begin
    ReportError(BL_IDXTABLEFULL);
  end
  else
  begin
    if (NewId = -1) then
    begin
      if (Tags = 0) then
        NewId := 0
      else
        NewId := succ(TagTable^[Tags].idx);
      IdxChanged := true;
      inc(Tags);
      Tag := Tags;
      TagTable^[Tag].idx := NewId;
      TagTable^[Tag].position := cBL_Null;
    end
    else
    begin
      if not(exist(NewId)) then
      begin

        { Position in der Tag-Table suchen }
        IdxChanged := true;
        inc(Tags);
        TagTable^[Tags].idx := maxlongint;
        Tag := 1;
        while (TagTable^[Tag].idx < NewId) do
          inc(Tag);

        { Platz einfgen in Tag-Table }
        if Tag < Tags then
          move(TagTable^[Tag], TagTable^[Tag + 1],
            (Tags - Tag) * sizeof(IdxRecordType));

        { Tag eintragen }
        TagTable^[Tag].idx := NewId;
        TagTable^[Tag].position := cBL_Null;
      end;
    end;
    put(DSize);
  end;
  EndTransaction;
end;

procedure TBLager.delete;
begin
  BeginTransaction;
  if not(eol) then
  begin
    if (Tag < Tags) then
      move(TagTable^[Tag + 1], TagTable^[Tag],
        (Tags - Tag) * sizeof(TagTable^[Tag]));
    dec(Tags);
  end;
  EndTransaction;
end;

function TBLager.exist(Id: longint): boolean;
var
  s, e: word;
  m: word;
begin
  BeginTransaction;
  { binäre Suche in der Tag-Table }
  s := 1;
  e := Tags;
  while (s < e) do
  begin
    m := s + ((e - s) div 2);
    if TagTable^[m].idx < Id then
      s := m + 1
    else if TagTable^[m].idx > Id then
      e := m - 1
    else
    begin
      s := m;
      e := m;
    end;
  end;
  Tag := s;
  exist := (TagTable^[s].idx = Id) and (s <= Tags);
  EndTransaction;
end;

procedure TBLager.get; { Read actual Record }
begin
  BeginTransaction;
  if eol then
  begin
    ReportError(BL_INVALIDPOSITIONING);
  end
  else
  begin
    ActIdx := TagTable^[Tag].idx;
    BinFile.position := TagTable^[Tag].position;
    BinFile.Read(DataLen, sizeof(longword));
    if TransactionUseTime then
    begin
      try
        BinFile.Read(TimeStamp, sizeof(TDateTime));
        if (TimeStamp < 0) or (TimeStamp > cMaxDateTime) then
          TimeStamp := 0;
      except
        TimeStamp := 0;
      end;
    end;
    if (DataLen > MaxDataLen) then
      DataLen := MaxDataLen;
    BinFile.Read(DataPointer^, DataLen);
  end;
  EndTransaction;
end;

procedure TBLager.put(DSize: longint);
var
  OldSize: longint;
begin
  BeginTransaction;
  if eol then
  begin
    ReportError(BL_INVALIDPOSITIONING);
  end
  else
  begin
    if (TagTable^[Tag].position = cBL_Null) then
    begin
      { first Save }
      TagTable^[Tag].position := BinFile.Size;
      IdxChanged := true;
    end
    else
    begin
      { update Operation, delete old Record }
      BinFile.position := TagTable^[Tag].position;
      BinFile.Read(OldSize, sizeof(longint));
      { ##, look for smaller or bigger sizes }
      { smaller: use old place, insert a whole }
      { bigger: insert old place as a whole, use a fitting wohle or a new }

      if (OldSize <> DSize) then
      begin
        InsertWhole(TagTable^[Tag].position, OldSize);
        TagTable^[Tag].position := BinFile.Size;
        IdxChanged := true;
      end;
    end;
    BinFile.position := TagTable^[Tag].position;
    BinFile.Write(DSize, sizeof(longint));
    if TransactionUseTime then
      BinFile.Write(TransactionTimeStamp, sizeof(TDateTime));
    BinFile.Write(DataPointer^, DSize);
  end;
  EndTransaction;
end;

procedure TBLager.touch;
var
  OldSize: longint;
begin
  BeginTransaction;
  repeat

    if not(TransactionUseTime) then
    begin
      ReportError(BL_USE_TS);
      break;
    end;

    if eol then
    begin
      ReportError(BL_INVALIDPOSITIONING);
      break;
    end;

    if (TagTable^[Tag].position = cBL_Null) then
    begin
      ReportError(BL_NODATA);
      break;
    end;

    BinFile.position := TagTable^[Tag].position+sizeof(longint);
    BinFile.Write(TransactionTimeStamp, sizeof(TDateTime));
  until yet;
  EndTransaction;
end;

procedure TBLager.next;
begin
  BeginTransaction;
  inc(Tag);
  if not(eol) then
    get;
  EndTransaction;
end;

procedure TBLager.prev;
begin
  BeginTransaction;
  dec(Tag);
  if not(eol) then
    get;
  EndTransaction;
end;

function TBLager.eol: boolean;
begin
  BeginTransaction;
  eol := (Tag < 1) or (Tag > Tags);
  EndTransaction;
end;

procedure TBLager.first;
begin
  BeginTransaction;
  Tag := 1;
  if not(eol) then
    get;
  EndTransaction;
end;

procedure TBLager.last;
begin
  BeginTransaction;
  Tag := Tags;
  if not(eol) then
    get;
  EndTransaction;
end;

function TBLager.CountRecs: longint;
begin
  BeginTransaction;
  CountRecs := Tags;
  EndTransaction;
end;

procedure TBLager.ReBuild;
begin
  if (CountWholes > 0) then
  begin
    Clone(TransactionTimeStamp);
    close;
    FileCopy(cBL_FileExtension + cBL_ClonePostfix + cBL_FileExtension,
      BinFileFName + cBL_FileExtension);
    Open;
    FileDelete(cBL_FileExtension + cBL_ClonePostfix + cBL_FileExtension);
  end;
end;

function TBLager.CountWholes: longint;
var
  WholeCount: longint;
  NextWhole: longint;
  fr: FreeRecordType;

  { in case off emergency : }
  procedure SetNILStamp(e: longint);
  begin
    fr.NextFree := cBL_Null;
    BinFile.position := e;
    BinFile.write(fr, sizeof(FreeRecordType));
  end;

begin
  BeginTransaction;
  WholeCount := 0;
  NextWhole := fh.FirstFree;
  while (NextWhole <> cBL_Null) do
  begin
    { write('(',NextWhole); }
    BinFile.position := NextWhole;
    BinFile.Read(fr, sizeof(FreeRecordType));
    { write('=',fr.FreeSize,')'); }
    inc(WholeCount, fr.FreeSize);
    NextWhole := fr.NextFree;
  end;
  CountWholes := WholeCount;
  EndTransaction;
end;

{ Trans-Action System }

procedure TBLager.BeginTransaction(dt: TDateTime = 0.0);
begin
  if (TransactionLevel = 0) then
  begin
    TransactionTimeStamp := dt;
    TransactionUseTime := (dt > 0.1);
    Open;
  end;
  inc(TransactionLevel);
  if (TransactionLevel = 255) then
    ReportError(BL_TOOMANYBEGINTRANSACTION);
end;

procedure TBLager.SetTransactionTimeStamp(dt: TDateTime);
begin
 TransactionTimeStamp := dt;
end;

procedure TBLager.EndTransaction;
begin
  if (TransactionLevel = 0) then
    ReportError(BL_TOOMANYENDTRANSACTION)
  else
    dec(TransactionLevel);
  if (TransactionLevel = 0) then
    close;
end;

procedure TBLager.DeleteAll;
begin
  if (TransactionLevel <> 0) then
    ReportError(BL_ILLEGALOP)
  else
  begin
    if FileExists(BinFileFName + cBL_FileExtension) then
      FileDelete(BinFileFName + cBL_FileExtension);
  end;
end;

procedure TBLager.DeleteOld(dt: TDateTime);
var
  Fresh: TBLager;
begin
  BeginTransaction;
  Fresh := TBLager.create;
  Fresh.Init(BinFileFName + cBL_FreshPostfix, DataPointer^, MaxDataLen);
  Fresh.DeleteAll;
  Fresh.BeginTransaction(now);
  first;
  while not(eol) do
  begin
    // Sicherstellen, dass die alte "TimeStamp" wiederverwendet wird
    if (TimeStamp >= dt) then
    begin
      Fresh.TransactionTimeStamp := TimeStamp;
      Fresh.insert(ActIdx, DataLen);
    end;
    next;
  end;
  Fresh.EndTransaction;
  Fresh.Free;
  EndTransaction;
end;

procedure TBLager.ReportError(No: byte);
begin
{$IFNDEF console}
  ShowMessage('BinLager-Fehler' + #13 + ' Name: ' + BinFileFName +
      cBL_FileExtension + #13 + 'ID: ' + inttostr(Tag)
      + #13 + 'Error: ' + inttostr(No));
{$ELSE}
  writeln('BinLager-Fehler' + #13 + ' Name: ' + BinFileFName +
      cBL_FileExtension + #13 + 'ID: ' + inttostr(Tag)
      + #13 + 'Error: ' + inttostr(No));
{$ENDIF}
end;

procedure TBLager.Clone(dt: TDateTime = 0.0);
var
  C: TBLager;
begin
  BeginTransaction;
  C := TBLager.create;
  C.Init(BinFileFName + cBL_ClonePostfix, DataPointer^, MaxDataLen);
  C.DeleteAll;
  C.BeginTransaction(dt);
  first;
  while not(eol) do
  begin
    // Sicherstellen, dass die alte "TimeStamp" wiederverwendet wird
    if TransactionUseTime then
      C.TransactionTimeStamp := TimeStamp;
    C.insert(ActIdx, DataLen);
    next;
  end;
  C.EndTransaction;
  EndTransaction;
end;

function TBLager.RecordIndex: longint;
begin
  result := ActIdx;
end;

function TBLager.RecordSize: longword; { actual Record Size }
begin
  result := DataLen;
end;

function TBLager.RecordTimeStamp: TDateTime;
begin
  result := TimeStamp;
end;

function TBLager.InTransAction: boolean;
begin
  if assigned(self) then
    result := TransactionLevel > 0
  else
    result := false;
end;

end.
