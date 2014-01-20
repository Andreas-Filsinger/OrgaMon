unit InterNetUpdate;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  ComCtrls, VCLUnZip, VCLZip,
  ExtCtrls, Ftpcli, Psock, NMFtp;

type
  TInterNetUpdateForm = class(TForm)
    VCLUnZip1: TVCLUnZip;
    VCLZip1: TVCLZip;
    Panel1: TPanel;
    Panel2: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    ProgressBar1: TProgressBar;
    LabelInfo: TLabel;
    FtpClient1: TFtpClient;
    Button1: TButton;
    Label1: TLabel;
    Button2: TButton;
    Button3: TButton;
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure VCLUnZip1TotalPercentDone(Sender: TObject; Percent: Integer);
    procedure VCLZip1TotalPercentDone(Sender: TObject; Percent: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FtpClient1Progress(Sender: TObject; Count: Integer;
      var Abort: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public

    { Public-Deklarationen }
    UserBreak: boolean;
    ErrorCode: integer;
    MaxUpdate: integer; // Berechtigung für Update <= No <MaxUpdate>
    SourceZip: string;
    Debug: TStringList;

    // wichtige Versions-Nummern
    RevisionOfBasis: integer;
    RevisionOfUpdate: integer;

    // Länge der Nummern-Symbole
    TypicalRevisionStrLength: integer;
    ObermayerMode: boolean;

    function RevAsStr(rev: integer): string;

    procedure Display(Sender: TObject; var Msg: string);
    procedure _debug(const msg: string);
    function GetUpdateZips: boolean;
    function notostr4(n: integer): string;
  end;

var
  InterNetUpdateForm: TInterNetUpdateForm;

implementation

uses
  globals, anfix32, binlager32, ObermayerImport, math, HeBuBase;

{$R *.DFM}

const
 // ERROR MESSAGES
  FTP_INVALIDRAS = 2;
  FTP_CONNECTFAILD = 4;
  FTP_TRANSERROR = 5;
  FTP_USERBREAK = 6;
  FTP_DIALUPENTRYINVALID = 8;
  FTP_NOLICENCE = 9;
  FTP_UPTODATE = 10;

procedure TInterNetUpdateForm.FormActivate(Sender: TObject);
begin
  button1.caption := LanguageStr[pred(129)];
  LabelInfo.caption := SerialNumber;
end;

procedure TInterNetUpdateForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := true;
  UserBreak := true;
end;


procedure TInterNetUpdateForm.Button1Click(Sender: TObject);
begin
  if (button1.caption = 'OK') then
    close
  else
; //    Import;
end;

procedure TInterNetUpdateForm.VCLUnZip1TotalPercentDone(Sender: TObject;
  Percent: Integer);
begin
  progressbar1.position := Percent;
end;

procedure TInterNetUpdateForm.VCLZip1TotalPercentDone(Sender: TObject;
  Percent: Integer);
begin
  progressbar1.position := Percent;
end;

procedure TInterNetUpdateForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_escape) then
  begin
    button1.SetFocus;
    close;
  end;
end;

function TInterNetUpdateForm.GetUpdateZips: boolean;
var
  MyActiveConnections: TStringList;
  n: integer;
  UserName: array[0..1024] of char;
  UserNameSize: DWord;
  InpStr: string[10];
  Inf: TextFile;
  UpdatesOnServer: TStringList;
begin
  Debug.clear;
  UserNameSize := sizeof(UserName);
  GetUserName(UserName, UserNameSize);
  _debug(format('%s on %s', [UserName, FSerial('C:\')]));
  _debug(format('serial %s with Rev. %s', [SerialNumber, RevTostr(Version)]));
  _debug(format('has %d basis', [RevisionOfBasis]));

  while true do
  begin

  // DFÜ-Verbindung prüfen

    with FTPClient1 do
    begin
      HostName := 'www.hebu-music.de';
      UserName := 'FTP_HEBU_DOWNLOAD';
      PassWord := noblank('d o w  n  l o a d');

   // FTP connect!
      labelinfo.Caption := 'ftp login ...';
      if not (connect) then
        ErrorCode := FTP_CONNECTFAILD;
      if (ErrorCode <> 0) then
        break;
      OnDisplay := Display;

   // get System Information
   // syst;
   // pwd;

   // cd \database
      HostDirName := '/download/update';
      if not (cwd) then
        ErrorCode := FTP_CONNECTFAILD;
      if (ErrorCode <> 0) then
        break;

   // binary
      if not (TypeSet) then
        ErrorCode := FTP_CONNECTFAILD;
      if (ErrorCode <> 0) then
        break;

   // hole Lizenz-Info GetSysteminfo
      labelinfo.Caption := 'check rights ...';
      HostFileName := SerialNumber + '.ok';
      LocalFileName := ProgramFilesDir + cCodeName + '\Licence.txt';
      Binary := true;
      if not (Get) then
        ErrorCode := FTP_NOLICENCE;
      if (ErrorCode <> 0) then
        break;
      progressbar1.position := 0;

   // Get the highest Update-Number on Server
   // starting at "1"
      labelinfo.Caption := 'check rights ...';
      HostFileName := '*.ZIP';
      LocalFileName := ProgramFilesDir + cCodeName + '\dir.txt';
      if not (dir) then
        ErrorCode := FTP_TRANSERROR;
      if (ErrorCode <> 0) then
        break;
      progressbar1.position := 0;

      UpdatesOnServer := TStringList.create;
      UpdatesOnServer.LoadFromFile(LocalFileName);
      RevisionOfUpdate := UpdatesOnServer.count;
      UpdatesOnServer.free;

   // Prüfung, ob Update notwendig
      if (RevisionOfBasis = RevisionOfUpdate) then
        ErrorCode := FTP_UPTODATE;
      if (ErrorCode <> 0) then
        break;

   // Alle Updates von Basis ... <no> abholen
      for n := succ(RevisionOfBasis) to RevisionOfUpdate do
      begin
        HostFileName := 'U' + notostr4(n) + '.ZIP';
        labelinfo.Caption := 'load update ' + notostr4(n) + ' ...';
        LocalFileName := ProgramFilesDir + cCodeName + '\' + HostFileName;
        Binary := true;
        progressbar1.position := 0;
        if not (Size) then
          ErrorCode := FTP_TRANSERROR;
        if (ErrorCode <> 0) then
          break;
        ProgressBar1.Max := SizeResult;

        if FileExists(LocalFileName) then
          if FSize(LocalFileName) = SizeResult then
            continue;

        Binary := true;
        if not (Get) then
          ErrorCode := FTP_TRANSERROR;
        if (ErrorCode <> 0) then
          break;
      end;

      if (ErrorCode <> 0) then
        break;

      HostDirName := '/download/success';
      if not (cwd) then
        ErrorCode := FTP_CONNECTFAILD;
      if (ErrorCode <> 0) then
        break;

      HostFileName := SerialNumber + '.ok';
      LocalFileName := ProgramFilesDir + cCodeName + '\dir.txt';
      if not (Put) then
        ErrorCode := FTP_TRANSERROR;
      if (ErrorCode <> 0) then
        break;

      quit;
    end;

  // may close Connection

    break;
  end;

  if (ErrorCode in [FTP_INVALIDRAS, FTP_CONNECTFAILD,
    FTP_TRANSERROR, FTP_USERBREAK,
      FTP_DIALUPENTRYINVALID]) then
  begin
    ShowMessage(FTPClient1.ErrorMessage);
    debug.add(FTPClient1.ErrorMessage);
  end;

  if FTPClient1.Connected then
    FTPClient1.quit;

  case ErrorCode of
    FTP_INVALIDRAS: labelinfo.Caption := 'Error: ras entry invalid!';
    FTP_CONNECTFAILD: labelinfo.Caption := 'Error: connect fail!';
    FTP_TRANSERROR: labelinfo.Caption := 'Error: transfer error!';
    FTP_USERBREAK: labelinfo.Caption := 'Error: user break!';
    FTP_DIALUPENTRYINVALID: labelinfo.Caption := 'Error: dial up entry invalid!';
    FTP_NOLICENCE: labelinfo.Caption := 'Info: No lincence for update! / Keine Lizenz!';
    FTP_UPTODATE: labelinfo.Caption := 'Info: Data is up to date! / Keine Änderungen!';
  end;
  result := (ErrorCode = 0);
  debug.SaveToFile(ProgramFilesDir + cCodeName + '\Bericht.txt');

  label1.caption := 'You may disconnect InterNet now!' + #13#10 +
    'Die Verbindung zum InterNet wird nicht mehr benötigt!';
end;

procedure TInterNetUpdateForm.Display(Sender: TObject; var Msg: string);
begin
  debug.add(Msg);
end;

function TInterNetUpdateForm.notostr4(n: integer): string;
begin
  result := inttostr(n);
  result := fill('0', 4 - length(result)) + result;
end;


procedure TInterNetUpdateForm.FtpClient1Progress(Sender: TObject;
  Count: Integer; var Abort: Boolean);
begin
  ProgressBar1.Position := Count;
  panel5.caption := inttostr(Count);
end;

procedure TInterNetUpdateForm.FormCreate(Sender: TObject);
begin
  Debug := TStringList.create;
end;

procedure TInterNetUpdateForm.FormDestroy(Sender: TObject);
begin
  Debug.free;
end;

procedure TInterNetUpdateForm._debug(const msg: string);
begin
  debug.add(msg);
end;

function TInterNetUpdateForm.RevAsStr(Rev: integer): string;
begin
  result := inttostrN(Rev, TypicalRevisionStrLength);
end;

procedure TInterNetUpdateForm.Button2Click(Sender: TObject);
begin
  ObermayerMode := true;
//  Import;
end;

procedure TInterNetUpdateForm.Button3Click(Sender: TObject);
begin
  FormObermayerImport.show;
end;

end.


procedure TInterNetUpdateForm.Import;

const
  clpaper = $00808080;
  Delimiter = ',';
  ValidChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789ßÄËÖÜÁÀÉÈÚÙÓÍÊÇÅ';
  ZipPwd = 'p L oP} /8. +ZH   aI   r Y * Nfl m 5 8![ |g';

type
  tIndexValues = array[0..MaxDoubleWordCount] of integer;
  tReallyBigString = array[0..pred(MaxHugeText)] of char;
  tArtikelStr = array[0..pred(4 * MaxHugeText)] of char;

var
  ModeStr: string;
  sWordFbin: file;
  sIndexF: file of integer;
  BinF: file of tDataBaseRec;
  Inf: TBLager; // Artikel-Daten A0000 oder U0000
  OutF: TBLager; // neuer A0000
  TextLager: TBLager; // Komponisten-Texte

  UpDateArtikel: TStringList;
  FehlerReport: TStringList;

  IndexValues: ^tIndexValues;
  ReallyBigString: ^tReallyBigString;
  ArtikelStr: ^tArtikelStr;

  ActWordCount: integer;
  StartTime: DWORD;

 // Index-Felder
  IndexCount: integer; // Gesamt-Größe der sIndexF Datei
  ActIndexCount: integer; // Anzahl im actuellen Array
  InpStr: string;
  n, m, k: integer;
  PreisStr: string;
  TextOutNumber: integer;

 // artikel.bin ausgabe
  ActIndex: integer;

 // Wortanfänge
  BigWordStr: string;

 // Debug-Sachen
  BemerkungStr: string;
  KompositionStr: string;
  MaxBigStringSize: integer;
  UeberKomponistStr: string;
  UeberArrangerStr: string;

 // AMode            : boolean; // Modus "Artikel" / "Update"

 // Nummer des Datenbestandes
  ActRevNo: integer;

 // Informations-Angaben
  _InfoOld: integer;
  _InfoNew: integer;
  _InfoUpdate: integer;
  _InfoDeleted: integer;
  _InfoWords: integer;

 // Obermayer-Sachen: doppelte Info
  dup_laender: TStringList;
  dup_namen: TStringList;
  dup_rubriken: TStringList;
  dup_Bilder: TstringList;
  Dirigent: string;
  CDno: string;
  LandLang: string;
  SparteLang: string;
  SparteAlles: string;
  ArtikelNo2: string;

  procedure AddIfNew(s: TStringList; NewS: string);
  begin
    if s.indexof(NewS) = -1 then
    begin
      s.add(NewS);
      s.sort;
      s.sorted := true;
    end;
  end;

  procedure PostError(const x: string);
  begin
    FehlerReport.add(inttostr(ActRevNo) + ';' +
      noten.artikelno + ';' +
      x)
  end;

  function nextO: string;
  var
    k: integer;
  begin
    k := pos('","', InpStr);
    if (k = 0) then
    begin
      result := copy(InpStr, 2, length(InpStr) - 2);
      InpStr := '';
    end else
    begin
      result := copy(InpStr, 2, k - 2);
      delete(InpStr, 1, k + 1);
    end;
  end;

  function NextP: string;
  var
    n, m, o, k: integer;
  begin

    while true do
    begin

   // empty
      if length(InpStr) = 0 then
      begin
        result := '';
        exit;
      end;

   // leerschritt an erster stelle
      if (InpStr[1] = ' ') then
        delete(InpStr, 1, 1)
      else
        break;
    end;

    if InpStr[1] = ';' then
    begin
      InpStr := copy(InpStr, 2, MaxInt);
      result := '';
      exit;
    end;

  // delete the field "
    delete(InpStr, 1, 1);

  // suche "", (möglich!)
    while true do
    begin
      n := pos('"' + Delimiter, InpStr);
      if n > 0 then
      begin
        m := pos('""' + Delimiter, InpStr);
        if m > 0 then
        begin
          o := pos('"""' + Delimiter, InpStr);
          if (o > 0) and (m = succ(o)) then
            break;
          if (n = succ(m)) then
          begin
            InpStr[m + 2] := #$01;
            continue;
          end;
        end;
      end;
      break;
    end;

    if (n > 0) then
    begin
      result := copy(InpStr, 1, pred(n));
      InpStr := copy(InpStr, n + 2, MaxInt);
    end else
    begin
      result := copy(InpStr, 1, pred(length(InpStr)));
      InpStr := '';
    end;

  // Entfernung der Double-Brakets
    while true do
    begin
      k := pos('""', result);
      if k > 0 then
      begin
        delete(result, succ(k), 1);
      end else
        break;
    end;
  end;

  procedure Scramble;
  const
    CRYPT_1 = 2; {must be 0-5    divisor}
    CRYPT_2 = 53; {must be 0-255  modifier}
    Key = 'ANFiSOFT';
    l = length(KEy);
  type
    NotenCast = array[0..pred(sizeof(tDataBaseRec))] of byte;
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

  procedure SplitString;
  var
    sLen: integer;
    wStart, wEnd: integer;
    AutomataState: integer;

    procedure WordOut;
    begin
      fillchar(StartWord, sizeof(StartWord), 0);
      with StartWord do
      begin
        WordStart := copy(BigWordStr, wStart, wEnd - wStart);
        IndexOf := ActIndex;
      end;
      write(sWordF, StartWord);
      inc(_InfoWords);
    end;

    function ValidChar(c: char): boolean;
    begin
      if pos(c, cWhiteSpace) > 0 then
      begin
        result := false;
        exit;
      end;
      if pos(c, ValidChars) > 0 then
      begin
        result := true;
        exit;
      end;
      PostError('illegal char "' + c + '"!');
      result := false;
    end;

  begin
    sLen := length(BigWordStr);
    wStart := 0;
    wEnd := 0;
    AutomataState := 0;

    while true do
    begin
      case AutomataState of
        0: begin // search for word start!
            inc(wStart);
            if wStart > sLen then
              break;
            if ValidChar(BigWordStr[wStart]) then
            begin
              AutomataState := 1;
              wEnd := wStart;
            end;
          end;
        1: begin // search for word end!
            inc(wEnd);
            if wEnd > sLen then
            begin
              WordOut;
              break;
            end;
            if ValidChar(BigWordStr[wEnd]) = false then
            begin
              WordOut;
              AutomataState := 0;
              wStart := wEnd;
            end;
          end;
      end;
    end;
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
    end else
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

  function StoreBigOne(const Value: string): integer;
  var
    n: integer;
    BigLen: integer;
  begin
    if (Value <> '') then
    begin
   // Text eventuell zu groß?
      BigLen := length(Value);
      if succ(BigLen) > MaxHugeText then
      begin
        PostError(copy(value, 1, 20) + '... text too with ' + inttostr(BigLen) + ' big!');
        BigLen := pred(MaxHugeText);
      end;
      if BigLen > MaxBigStringSize then
        MaxBigStringSize := BigLen;

   // bug, bug: StrPCopy
   // StrPCopy copiert nur 255 Zeichen oder so
      for n := 0 to pred(BigLen) do
        ReallyBigString^[n] := Value[succ(n)];
      ReallyBigString^[BigLen] := #0;
      inc(TextOutNumber);
      TextLager.insert(TextOutNumber, succ(BigLen));
      result := TextOutNumber;
    end else
    begin
      result := 0;
    end;
  end;

 // shell sort aus 'c bibel'
  procedure Sort(n: Integer);
  var
    gap, i, j: Integer;
    Temp: tStartWordRec;
  begin
    gap := n div 2;
    while (gap > 0) do
    begin
      i := gap;
      while (i < n) do
      begin
        j := i - gap;
        while (j >= 0) do
        begin
          if CompareStr(WordArrayP^[j].WordStart, WordArrayP^[j + gap].WordStart) <= 0 then
            break;
          temp := WordArrayP^[j];
          WordArrayP^[j] := WordArrayP^[j + gap];
          WordArrayP^[j + gap] := temp;
          j := j - gap;
        end;
        inc(i);
      end;
      gap := gap div 2;
    end;
  end;

  procedure AddIndexArrayVal(n: integer);
  begin
    if ActIndexCount < MaxDoubleWordCount then
    begin
      IndexValues^[ActIndexCount] := n;
      inc(ActIndexCount);
    end;
  end;

  procedure WriteIndexArray;
  var
    n, m: integer;
    LastValue: integer;

    procedure Sort(n: Integer); // Sortieren von 0.. Datenfeldern
    var
      gap, i, j: Integer;
      Temp: Integer;
    begin
      gap := n div 2;
      while (gap > 0) do
      begin
        i := gap;
        while (i < n) do
        begin
          j := i - gap;
          while (j >= 0) do
          begin
            if IndexValues^[j] < IndexValues^[j + gap] then
              break;
            temp := IndexValues^[j];
            IndexValues^[j] := IndexValues^[j + gap];
            IndexValues^[j + gap] := temp;
            j := j - gap;
          end;
          inc(i);
        end;
        gap := gap div 2;
      end;
    end;

  begin
    if (ActIndexCount = 0) then
      exit;
    Sort(ActIndexCount);

  // remove duplicates from an array 0..pred(count)
    if ActIndexCount > 1 then
    begin
      m := 1; // m = write counter
      LastValue := IndexValues^[0];
      for n := 1 to pred(ActIndexCount) do // n = read counter
        if (IndexValues^[n] <> LastValue) then
        begin
          LastValue := IndexValues^[n];
          IndexValues^[m] := LastValue;
          inc(m);
        end;
      ActIndexCount := m;
    end;

  //
    write(sIndexF, ActIndexCount);
    for n := 0 to pred(ActIndexCount) do
      write(sIndexF, IndexValues^[n]);
    inc(IndexCount, succ(ActIndexCount));
    ActIndexCount := 0;
  end;

  function _DataScramble(var data; datasize: integer): boolean;
  type
    ScrambleCast = array[0..MaxInt div 2] of byte;
  var
    n: integer;
  begin
    for n := 0 to pred(datasize) do
      dec(ScrambleCast(data)[n], 7);
    result := true;
  end;

  function CharSetConvert(const Feld, x: string): string;
  var
    k: integer;
  begin
    result := Mac2Ansi(x);
    k := pos(NVAC, result);
    if k > 0 then
    begin
      PostError(' illegal char #' + inttostr(ord(x[k])) + '(' + x[k] + ') in field ' + Feld + ' at ' + inttostr(k) + ': xxxx!xxxx = ' + copy(x, k - 4, 9));
    end;
  end;

  procedure Info;
  begin
    panel2.caption := inttostr(_InfoOld);
    panel4.caption := inttostr(_InfoNew);
    panel5.caption := inttostr(Outf.CountRecs);
    panel3.caption := inttostr(_InfoUpdate);
    panel6.caption := inttostr(_InfoDeleted);
    panel7.caption := inttostr(_InfoWords);
    application.processmessages;
  end;

begin
  screen.cursor := crHourGlass;

  if ObermayerMode then
    ModeStr := '1'
  else
    ModeStr := '0';

  label1.caption := '';
  button1.caption := LanguageStr[pred(129)];

  button1.Enabled := false;
  ProgressBar1.Min := 0;
  ProgressBar1.Max := 100;
  ProgressBar1.Step := 1;
  ProgressBar1.Position := 0;
  MaxBigStringSize := 0;
  new(IndexValues);
  new(ReallyBigString);
  new(ArtikelStr);
  UpDateArtikel := TStringList.create;

  if not (ObermayerMode) then
  begin
  // Name des "artikel.zip" ermitteln
    SourceZip := ProgramFilesDir + cCodeName + '\artikel.zip';
    if not (FileExists(SourceZip)) then
      SourceZip := SystemPath + '\artikel.zip';
    if not (FileExists(SourceZip)) then
    begin
      ShowMessage('Keine InterNet fähige CD-ROM!');
      button1.Enabled := true;
      button1.caption := 'OK';
      exit;
    end;

  // Nummer des Updates bestimmen
    labelinfo.caption := 'base lookup ...';
    application.processmessages;
    with vclunzip1 do
    begin
      password := noblank(ZipPwd);
      ZipName := SourceZip;
      ReadZip;
      InpStr := copy(FileName[0], 2, pos('.', FileName[0]) - 2);
      TypicalRevisionStrLength := length(InpStr);
      RevisionOfBasis := strtoint(InpStr);
    end;

    label1.caption := 'Data Rev. ' + RevAsStr(RevisionOfBasis);

  // Im InterNet das Update ziehen

    if not (GetUpdateZips) then
    begin
      button1.Enabled := true;
      button1.caption := 'OK';
      exit;
    end;

    if not (FileExists(ProgramFilesDir + cCodeName + '\u' + RevAsStr(RevisionOfUpdate) + '.zip')) then
    begin
      button1.Enabled := true;
      button1.caption := 'OK';
      exit;
    end;

  end else
  begin
    TypicalRevisionStrLength := 4;
    RevisionOfBasis := 1;
    RevisionOfUpdate := 1;

    FileDelete(ProgramFilesDir + cCodeName + '\A' + RevAsStr(RevisionOfBasis));
    Inf := TBLager.Create;
    Inf.init(ProgramFilesDir + cCodeName + '\A' + RevAsStr(RevisionOfBasis), ArtikelStr^, sizeof(tArtikelStr));
    Inf.BeginTransAction;
    UpDateArtikel.LoadFromFile(ProgramFilesDir + cCodeName + '\Out.csv');

    progressbar1.max := UpdateArtikel.count;
    StartTime := 0;

    for n := 0 to pred(UpDateArtikel.count) do
    begin
      InpStr := UpdateArtikel[n];
      move(InpStr[1], ArtikelStr^, length(InpStr));
      Inf.insert(-1, length(InpStr));
      if frequently(StartTime, 400) then
      begin
        progressbar1.position := n;
        application.processmessages;
      end;
    end;
    progressbar1.position := 0;

    Inf.EndTransAction;
    Inf.free;

  end;

 // Artikel, die schon in der Update-Datenbank enthalten sind
  UpdateArtikel.clear;
  UpdateArtikel.Sorted := true;
  UpdateArtikel.Duplicates := dupIgnore;
  FehlerReport := TStringList.create;
  dup_laender := TStringList.create;
  dup_namen := TStringList.create;
  dup_rubriken := TstringList.create;
  dup_Bilder := TStringList.create;
  if FileExists(ProgramFilesDir + cCodeName + '\Bericht.txt') then
    FehlerReport.LoadFromFile(ProgramFilesDir + cCodeName + '\Bericht.txt');

 // Ausgabe-Datei öffnen
  AssignFile(Binf, ProgramFilesDir + cCodeName + '\N artikel' + ModeStr + '.bin');
  rewrite(Binf);

 // Wortanfänge
  AssignFile(sWordF, ProgramFilesDir + cCodeName + '\N WordStart' + ModeStr + '.bin');
  rewrite(sWordF);

  StartTime := GetTickCount;
  ActIndex := 0;
  UserBreak := false;
  TextOutNumber := 0;

  _InfoOld := 0;
  _InfoNew := 0;
  _InfoUpdate := 0;
  _InfoDeleted := 0;
  _InfoWords := 0;

 // TextAusgabe erstellen
  FileDelete(ProgramFilesDir + cCodeName + '\N Texte' + ModeStr + '.BLA');

  TextLager := TBLager.create;
  TextLager.init(ProgramFilesDir + cCodeName + '\N Texte' + ModeStr, ReallyBigString^, sizeof(tReallyBigString));
  TextLager.BeginTransAction;

 // Ausgabe-Datei erstellen
  if not (ObermayerMode) then
  begin
    FileDelete(ProgramFilesDir + cCodeName + '\A' + RevAsStr(RevisionOfUpdate) + '.BLA');
    OutF := TBlager.create;
    OutF.init(ProgramFilesDir + cCodeName + '\A' + RevAsStr(RevisionOfUpdate), ArtikelStr^, sizeof(tArtikelStr));
    OutF.BeginTransAction;
  end else
  begin
    FileDelete(ProgramFilesDir + cCodeName + '\A' + RevAsStr(RevisionOfUpdate + 1) + '.BLA');
    OutF := TBlager.create;
    OutF.init(ProgramFilesDir + cCodeName + '\A' + RevAsStr(RevisionOfUpdate + 1), ArtikelStr^, sizeof(tArtikelStr));
    OutF.BeginTransAction;
  end;

  for ActRevNo := RevisionOfUpdate downto RevisionOfBasis do
  begin

    labelinfo.caption := 'unzip base ' + inttostr(ActRevNo) + ' ...';

    application.processmessages;

  // *.bla erzeugen
    if not (ObermayerMode) then
    begin
      ProgressBar1.Min := 0;
      ProgressBar1.Max := 100;
      with vclunzip1 do
      begin
        password := noblank(ZipPwd);
        if ActRevNo = RevisionOfBasis then
          ZipName := SourceZip
        else
          ZipName := ProgramFilesDir + cCodeName + '\u' + RevAsStr(ActRevNo) + '.zip';
        DestDir := ProgramFilesDir + cCodeName;
        unzip;
      end;
    end;

    labelinfo.caption := 'open base ...';
    application.processmessages;
    ProgressBar1.Position := 0;

    Inf := TBlager.Create;

  // Eingabe-Datei öffnen
    if ActRevNo = RevisionOfBasis then
      Inf.init(ProgramFilesDir + cCodeName + '\A' + RevAsStr(RevisionOfBasis), ArtikelStr^, sizeof(tArtikelStr))
    else
      Inf.init(ProgramFilesDir + cCodeName + '\U' + RevAsStr(ActRevNo), ArtikelStr^, sizeof(tArtikelStr));

    Inf.BeginTransAction;
    Inf.first;

    ProgressBar1.Max := Inf.CountRecs;
    labelinfo.caption := 'import ' + inttostr(Inf.CountRecs) + ' records ...';

    StartTime := GetTickCount;
    while not (Inf.eol) do
    begin

   // ab und zu Windows Zeit geben, aber nicht so oft
      if frequently(StartTime, 500) then
        info;

      setLength(InpStr, Inf.RecordSize);

      if not (ObermayerMode) then
      begin
        _DataScramble(ArtikelStr^, Inf.RecordSize);
        move(ArtikelStr^, InpStr[1], pred(Inf.RecordSize))
      end else
      begin
        move(ArtikelStr^, InpStr[1], Inf.RecordSize);
      end;

      ProgressBar1.StepBy(1);

   // Ausgabe
      fillchar(noten, sizeof(noten), 0);
      with noten do
      begin

        if not (ObermayerMode) then
        begin
          PaperColor := clpaper + (random($80) shl 16) + (random($80) shl 08) + random($80);
          ArtikelNo := NextP;
          Land := CharSetConvert('Land', NextP);

          if (ActRevNo = RevisionOfUpdate) then
          begin
      // neueste Daten
            UpDateArtikel.add(ArtikelNo);
            inc(_InfoNew);
          end else
          begin
      // mit ältere Datensätze abgleichen
            if (UpDateArtikel.IndexOf(ArtikelNo) <> -1) then
            begin
       // Ups, den gibst schon
              inc(_InfoOld);
              inf.next;
              continue;
            end else
            begin
       // Ups, gibst gar nicht
              if (ActRevNo <> RevisionOfBasis) then
              begin
                UpDateArtikel.add(ArtikelNo);
                inc(_InfoNew);
              end else
              begin
                inc(_InfoUpdate);
              end;
            end;
          end;

          if (Land <> 'X') then
            OutF.insert(-1, Inf.RecordSize);

          Titel := CharSetConvert('Titel', NextP);
          if (Titel = '') then
            PostError('no titel entry!');

          k := StrPosCount('/', titel);
          if (k > 1) then
            PostError(format('%dx "/" in titel appeared!', [k]));

          Komponist := CharSetConvert('Komponist', NextP);
          if pos(',', Komponist) > 0 then
            PostError('the char "," is illegal in field komponisten!');

          Arranger := CharSetConvert('Arranger', NextP);
          if pos(',', Arranger) > 0 then
            PostError('the char "," is illegal in field Arranger!');

          schwer := NextP;
          PreisStr := NextP;
          if PreisStr <> '' then
          begin
            k := pos('.', PreisStr);
            if (k > 0) then
              PreisStr[k] := DecimalSeparator;
            try
              preis := strtofloat(PreisStr);
            except
              PostError('Wandlungsfehler im Preis-Feld');
            end;
          end else
          begin
            preis := 0.0;
          end;

          verlag := CharSetConvert('verlag', NextP);
          Serie := CharSetConvert('serie', NextP);
          BemerkungStr := CharSetConvert('BemerkungStr', NextP);
          Bemerkung := StoreBigOne(BemerkungStr);
          Dauer := NextP;
          ProbeStimme := NextP;
          Aufnahme := CharSetConvert('Aufnahme', NextP);
          nextp;
          Sparte := CharSetConvert('Sparte', nextp);
          Komposition := StoreBigOne(CharSetConvert('Komposition', NextP));
          UeberKomponist := StoreBigOne(CharSetConvert('UeberKomposition', NextP));
          UeberArranger := StoreBigOne(CharSetConvert('UeberArranger', NextP));
          BestellNo := NextP;
          PreisStr := NextP;
          if (PreisStr <> '') then
          begin
            k := pos('.', PreisStr);
            if (k > 0) then
              PreisStr[k] := DecimalSeparator;
            try
              OrgCurrency := '';
              for m := 1 to length(PreisStr) do
              begin
                if (PreisStr[m] = ' ') then
                  PreisStr[m] := '#';
                if (PreisStr[m] = '-') then
                  PreisStr[m] := '0';
                if not (PreisStr[m] in ['#', '0'..'9', DecimalSeparator]) then
                begin
                  OrgCurrency := OrgCurrency + PreisStr[m];
                  PreisStr[m] := '#';
                end;
              end;

              repeat
                m := pos('#', PreisStr);
                if m = 0 then
                  break;
                delete(PreisStr, m, 1);
              until false;

              while true do
              begin
                k := pos(DecimalSeparator, PreisStr);
                if (k = 0) then
                  break;
                delete(PreisStr, k, 1);
              end;

              while true do
              begin
                k := revpos(DecimalSeparator, PreisStr);
                if (k = 0) or (k < length(PreisStr)) then
                  break;
                delete(PreisStr, k, 1);
              end;

              if PreisStr <> '' then
                Orgpreis := strtofloat(PreisStr)
              else
                Orgpreis := 0.0;
            except
              PostError('convert error in preis field');
            end;
          end else
          begin
            Orgpreis := 0.0;
            OrgCurrency := '';
          end;
          OrgCurrency := CharSetConvert('OrgCurrency', OrgCurrency);

          EntryDate := date2long(Nextp);

          PreisStr := NextP;
          if (PreisStr = '') then
            SoundSource := 0
          else
            SoundSource := strtoint(PreisStr);

          dealerID := NextP;
          BigWordStr := AnsiUpperCase(Titel + ' ' +
            Komponist + ' ' +
            Arranger + ' ' +
            Serie + ' ' +
            ArtikelNo + ' ' +
            Verlag + ' ' +
            BemerkungStr + ' ' +
            Sparte
            );
        end else
        begin

     // Obermayer
          PaperColor := clpaper + (random($80) shl 16) + (random($80) shl 08) + random($80);

          inc(_InfoNew);
          OutF.insert(-1, Inf.RecordSize);

     {CDnr} CDno := NextO;
          ArtikelNo := CDno;
     {Titel} Titel := NextO;

     {Land} LandLang := NextO;
          Land := FormHeBuBase.LandKurz(LandLang);
          if (Land = '') and (LandLang <> '') then
            PostError(' Land "' + LandLang + '" unbekannt -> static.txt,21 prüfen');

     {Internet} ArtikelNo2 := NextO;
     {Kommentar} BemerkungStr := NextO;
     {Bildname} Aufnahme := cutblank(NextO);
          AddIfNew(dup_Bilder, Aufnahme);

     {Sparte} SparteAlles := NextO;
          SparteLang := anfix32.Nextp(SparteAlles, #11);
          AddIfNew(dup_rubriken, SparteLang);
          while (SparteAlles <> '') do
          begin
            Sparte := anfix32.Nextp(SparteAlles, #11);
            AddIfNew(dup_rubriken, Sparte);
            SparteLang := SparteLang + ',' + Sparte;
          end;
          Sparte := SparteLang;

     {Lieferant} NextO;
     {Preis} PreisStr := NextO;
          if PreisStr <> '' then
          begin
            k := pos('.', PreisStr);
            if (k > 0) then
              PreisStr[k] := DecimalSeparator;
            try
              preis := strtofloat(PreisStr);
            except
              PostError('Wandlungsfehler im Preis-Feld');
            end;
          end else
          begin
            preis := 0.0;
          end;

     {BestNo} ArtikelNo := NextO;
          if (ArtikelNo = '') then
            ArtikelNo := ArtikelNo2;

     {Anz Scheiben} schwer := NextO;

     {Neuheit} NextO;
     {Neuerscheinungsdatum} EntryDate := date2long(NextO);
     {Eins} NextO;
     {EURO} NextO;
     {Summe Laufz} dauer := NextO;
     {Tracks} UeberKomponistStr := NextO;
     {LZ} UeberArrangerStr := NextO;

          Bemerkung := StoreBigOne(BemerkungStr);
          UeberKomponist := StoreBigOne(UeberKomponistStr);
          UeberArranger := StoreBigOne(UeberArrangerStr);

     (*
                 ArtikelNo      : string[10];
                 schwer         : string[10];
                 preis          : single;
                 verlag         : string[35];
                 Serie          : string[35];
                 Dauer          : string[10];
                 ProbeStimme    : string[10];
                 Aufnahme       : string[35];
                 Sparte         : string[35];
                 Bemerkung      : integer;
                 Komposition    : integer;
                 UeberArranger  : integer;
                 PaperColor     : TColor;
                 BestellNo      : string[10];
                 OrgPreis       : single;
                 OrgCurrency    : string[3];
                 EntryDate      : integer;
                 SoundSource    : byte;       // 0=nicht verfügbar, 1=HeBu CDR usw.
                 dealerID       : string[6];  // xxxxxc
      *)

          AddIfNew(dup_laender, LandLang);
          AddIfNew(dup_namen, Komponist);
          AddIfNew(dup_namen, Arranger);
          AddIfNew(dup_namen, Dirigent);

          BigWordStr := AnsiUpperCase(Titel + ' ' +
            ArtikelNo + ' ' +
            BemerkungStr + ' ' +
            UeberKomponistStr + ' ' +
            Sparte
            );
        end;

      end;

      if (noten.Land <> 'X') then
      begin
        SplitString;
        scramble;
        write(Binf, noten);
        inc(ActIndex);
      end else
      begin
        inc(_InfoDeleted);
      end;

      if UserBreak then
        break;

      inf.next;
    end;
    Info;
    Inf.EndTransaction;
    Inf.Free;


  // Update gelesen, jetzt kommen die "unveränderten Sachen!"
    FileDelete(ProgramFilesDir + cCodeName + '\U' + RevAsStr(ActRevNo) + '.BLA');
    FileDelete(ProgramFilesDir + cCodeName + '\U' + RevAsStr(ActRevNo) + '.ZIP');

  end;

  UpdateArtikel.free;
  OutF.EndTransAction;
  OutF.free;
  dispose(ReallyBigString);
  dispose(ArtikelStr);
  FileDelete(ProgramFilesDir + cCodeName + '\A' + RevAsStr(RevisionOfBasis) + '.BLA');
  TextLager.EndTransAction;
  TextLager.free;
  closeFile(Binf);
  closeFile(sWordF);

 // Neuer Artikel zippen
  labelinfo.caption := 'zip new base ...';
  application.processmessages;
  ProgressBar1.position := 0;
  ProgressBar1.max := 100;
  with vclzip1 do
  begin
    password := noblank(ZipPwd);
    ZipName := ProgramFilesDir + cCodeName + '\N artikel.zip';
    FilesList.clear;
    FilesList.add(ProgramFilesDir + cCodeName + '\A' + RevAsStr(RevisionOfUpdate) + '.BLA');
    zip;
  end;
  FileDelete(ProgramFilesDir + cCodeName + '\A' + RevAsStr(RevisionOfUpdate) + '.BLA');

 // Worte alle laden
  ProgressBar1.position := 0;
  assignFile(sWordFBin, ProgramFilesDir + cCodeName + '\N WordStart' + ModeStr + '.bin');
  reset(sWordFBin, sizeof(tStartWordRec));
  ActWordCount := FileSize(sWordFBin);
  GetMem(WordArrayP, ActWordCount * sizeof(tStartWordRec));
  ProgressBar1.Min := 0;
  ProgressBar1.Max := ActWordCount;
  ProgressBar1.Step := 1;
  labelinfo.caption := format('load %d words ...', [ActWordCount]);
  application.processmessages;
  blockread(sWordFBin, WordArrayP^, ActWordCount);
  CloseFile(SWordFBin);
  FileDelete(ProgramFilesDir + cCodeName + '\N WordStart' + ModeStr + '.bin');

 // Worte sortieren
  labelinfo.caption := format('sort %d words ...', [ActWordCount]);
  application.processmessages;
  if not (UserBreak) then
    Sort(ActWordCount);

 // speichern & komprimieren (was noch übrig ist!)
  IndexCount := 0;
  ActIndexCount := 0;
  _LastWord := ''; // imposible String
  assignFile(sWordF, ProgramFilesDir + cCodeName + '\N WSS' + ModeStr + '.bin');
  rewrite(sWordF);
  assignFile(sIndexF, ProgramFilesDir + cCodeName + '\N WSI' + ModeStr + '.bin');
  rewrite(sIndexF);
  labelinfo.caption := format('save %d words ...', [ActWordCount]);
  application.processmessages;
  StartTime := GetTickCount;
  for n := 0 to pred(ActWordCount) do
  begin
    if (_LastWord <> WordArrayP^[n].WordStart) then
    begin
      if _LastWord <> '' then
        WriteIndexArray;
      AddIndexArrayVal(WordArrayP^[n].indexOf); // add Record-Number
      WordArrayP^[n].indexOf := IndexCount; // save Index-Start-Position
      write(sWordF, WordArrayP^[n]); // save Word to File
      _LastWord := WordArrayP^[n].WordStart; // save last Word
    end else
    begin
      AddIndexArrayVal(WordArrayP^[n].indexOf); // selbes wort, nur index speichern
    end;
    if frequently(StartTime, 500) then
    begin
      ProgressBar1.position := n;
      application.processmessages;
    end;
  end;
  WriteIndexArray; // letzten Wert auch noch rausschreiben
  CloseFile(sWordF);
  CloseFile(sIndexF);
  FreeMem(WordArrayP, ActWordCount * sizeof(tStartWordRec));
  dispose(IndexValues);

 // Bericht!!!
  ProgressBar1.Position := 0;
  if (FehlerReport.count > 0) then
  begin
    labelinfo.caption := 'there are errors';
    FehlerReport.SaveToFile(ProgramFilesDir + cCodeName + '\Bericht.txt');
  end else
  begin
    labelinfo.caption := 'OK [' + inttostr(MaxBigStringSize) + ']';
  end;
  FehlerReport.free;

  dup_laender.SaveToFile(ProgramFilesDir + cCodeName + '\Info LÄNDER.txt');
  dup_namen.SaveToFile(ProgramFilesDir + cCodeName + '\Info NAMEN.txt');
  dup_rubriken.SaveToFile(ProgramFilesDir + cCodeName + '\Info RUBRIKEN.txt');
  dup_Bilder.SaveToFile(ProgramFilesDir + cCodeName + '\Info BILDER.txt');

  dup_laender.free;
  dup_namen.free;
  dup_rubriken.free;
  dup_bilder.free;

  labelinfo.caption := 'copy results ...';
  application.processmessages;
  ProgressBar1.Position := 0;
  ProgressBar1.max := 10;

  FileCopy(ProgramFilesDir + cCodeName + '\N artikel.ZIP', ProgramFilesDir + cCodeName + '\artikel.ZIP');
  ProgressBar1.StepIt;
  FileDelete(ProgramFilesDir + cCodeName + '\N artikel.ZIP');
  ProgressBar1.StepIt;
  FileCopy(ProgramFilesDir + cCodeName + '\N artikel0.bin', ProgramFilesDir + cCodeName + '\artikel0.bin');
  ProgressBar1.StepIt;
  FileDelete(ProgramFilesDir + cCodeName + '\N artikel0.bin');
  ProgressBar1.StepIt;
  FileCopy(ProgramFilesDir + cCodeName + '\N texte0.bla', ProgramFilesDir + cCodeName + '\texte0.bla');
  ProgressBar1.StepIt;
  FileDelete(ProgramFilesDir + cCodeName + '\N texte0.bla');
  ProgressBar1.StepIt;
  FileCopy(ProgramFilesDir + cCodeName + '\N wsi0.bin', ProgramFilesDir + cCodeName + '\wsi0.bin');
  ProgressBar1.StepIt;
  FileDelete(ProgramFilesDir + cCodeName + '\N wsi0.bin');
  ProgressBar1.StepIt;
  FileCopy(ProgramFilesDir + cCodeName + '\N wss0.bin', ProgramFilesDir + cCodeName + '\wss0.bin');
  ProgressBar1.StepIt;
  FileDelete(ProgramFilesDir + cCodeName + '\N wss0.bin');
  ProgressBar1.StepIt;
  FileDelete(ProgramFilesDir + cCodeName + '\dir.txt');
  FileDelete(ProgramFilesDir + cCodeName + '\Licence.txt');

  if ObermayerMode then
  begin
    FileMove(ProgramFilesDir + cCodeName + '\N artikel1.bin', SystemPath + '\artikel1.bin');
    FileMove(ProgramFilesDir + cCodeName + '\N texte1.bla', SystemPath + '\texte1.bla');
    FileMove(ProgramFilesDir + cCodeName + '\N wsi1.bin', SystemPath + '\wsi1.bin');
    FileMove(ProgramFilesDir + cCodeName + '\N wss1.bin', SystemPath + '\wss1.bin');
    FileDelete(ProgramFilesDir + cCodeName + '\A0002.BLA');
    FileDelete(ProgramFilesDir + cCodeName + '\artikel.zip');
  end;

  labelinfo.caption := 'success';
  button1.Enabled := true;
  button1.caption := 'OK';

  screen.cursor := crDefault;

end;

