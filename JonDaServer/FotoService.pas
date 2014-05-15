{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2012  Andreas Filsinger
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
unit FotoService;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, WordIndex,
  Vcl.Imaging.jpeg, Vcl.ComCtrls, Vcl.Buttons, Data.DB, ZAbstractRODataset,
  ZDataset, ZAbstractConnection, ZConnection,
  JonDaExec, MemCache;

const
  Version: single = 1.041; // ..\rev\OrgaMonAppService.rev.txt

  // root Locations
  cWorkPath = 'W:\';
  cBackUpPath = 'I:\KundenDaten\SEWA\';
  cWebPath = 'W:\status\';

  // Warte Zeiten [min]
  cKikstart_delay = 10;
  cAnzahlStellen_Transaktionszaehler = 5;
  cAnzahlStellen_FotosTagwerk = 4;

  // Sub Locations
  cLocation_MOB = 'orgamon-mob\';
  cLocation_JonDaServer = 'JonDaServer\';
  cLocation_Unverarbeitet = 'unverarbeitet\';

  // File Names
  cFotoTransaktionenFName = 'FotoService-Transaktionen.log.txt';
  cFotoAblageFName = 'FotoService-Ablage-%s.log.txt';

  // Bild-Namenskonvention
  //
  // GeraeteID "-" RID "-" BildProtokollName[ "-" N ].jpg
  // "-" N wird nur angefügt sobald auf dem Smartphone eine Bildnamensgleichheit
  // erkannt wird.
  //

type
  TFormFotoService = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ListBox1: TListBox;
    Button1: TButton;
    Timer1: TTimer;
    TabSheet2: TTabSheet;
    SpeedButton8: TSpeedButton;
    ListBox2: TListBox;
    TabSheet3: TTabSheet;
    Edit4: TEdit;
    SpeedButton1: TSpeedButton;
    ListBox3: TListBox;
    Image1: TImage;
    Label1: TLabel;
    Edit5: TEdit;
    ListBox4: TListBox;
    TabSheet4: TTabSheet;
    ListBox5: TListBox;
    SpeedButton2: TSpeedButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    TabSheet5: TTabSheet;
    ListBox6: TListBox;
    SpeedButton3: TSpeedButton;
    Button6: TButton;
    TabSheet6: TTabSheet;
    Button8: TButton;
    Button9: TButton;
    ListBox7: TListBox;
    TabSheet7: TTabSheet;
    Button7: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Button10: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Edit1: TEdit;
    CheckBox3: TCheckBox;
    ProgressBar1: TProgressBar;
    Edit2: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit3: TEdit;
    Label6: TLabel;
    CheckBox4: TCheckBox;
    Edit6: TEdit;
    Label7: TLabel;
    ListBox8: TListBox;
    TabSheet8: TTabSheet;
    ListBox9: TListBox;
    Button15: TButton;
    Edit7: TEdit;
    Label8: TLabel;
    Button16: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure ListBox3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure TabSheet7Show(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
  private
    { Private-Deklarationen }
    TimerWartend: integer;
    TimerInit: integer;
    TimerRunning: boolean;
    sMoveTransaktionen: TStringList;

    function JonDaServerPath: string;
    function MyWorkingPath: string;
    function AuftragFName(GeraeteNo: string): string;
    function AblageFname: string;
    function MobUploadPath: string;
  public
    { Public-Deklarationen }
    tBAUSTELLE: tsTable;
    JonDaExec: TJonDaExec;
    MemCache: TMemCache;
    LastLogWasTimeStamp: boolean; // Protect TimeStamp Flood

    procedure Log(s: string);
    function GEN_ID: integer;
    procedure LoadPic;
    procedure doRemote(GeraeteNo, Command, FName: string);
    procedure workEingang(All: boolean);
    procedure workWartend(All: boolean);
    procedure workAblage;
    procedure workStatus;
    procedure ensureGlobals;
    procedure releaseGlobals;

    // Implementierungen von JonDaExec - Prototypen
    function ZaehlerNummerNeu(AUFTRAG_R: integer; GeraeteNo: string): string;
    procedure invalidateZaehlerNummerNeuCache;
  end;

var
  FormFotoService: TFormFotoService;

implementation

uses
  binlager32, anfix32, globals,
  IniFiles, InfoZip, math,
  CCR.Exif, wanfix32,

  // ZEOS
  ZDbcIntfs, ZClasses;

{$R *.dfm}

function ExifDatum(FName: string): TDateTime;
var
  iEXIF: TExifData;
begin
  iEXIF := TExifData.Create;
  result := 0.0;
  try
    iEXIF.LoadFromJPEG(FName);
    result := iEXIF.DateTimeOriginal;
  except

  end;
  iEXIF.Free;
end;

procedure TFormFotoService.Button10Click(Sender: TObject);
begin
  ensureGlobals;
end;

procedure TFormFotoService.Button11Click(Sender: TObject);
begin
  if (TimerInit < cKikstart_delay * 60 * 1000) then
    TimerInit := pred(cKikstart_delay * 60 * 1000);
end;

procedure TFormFotoService.Button1Click(Sender: TObject);
begin
  if Timer1.Enabled then
  begin
    Timer1.Enabled := false;
    Button1.Caption := 'Start';
  end
  else
  begin
    Timer1.Enabled := true;
    Button1.Caption := 'Stop';
  end;
end;

procedure TFormFotoService.Button2Click(Sender: TObject);
var
  n: integer;
  FName, FNameRemote, GeraeteNo: string;
begin
  for n := 0 to pred(ListBox5.Items.count) do
  begin
    FName := ListBox5.Items[n];
    FNameRemote := nextp(FName, '+', 1);
    GeraeteNo := nextp(FNameRemote, '-', 0);
    doRemote(GeraeteNo, 'mv', FNameRemote);
    // DeleteFile(MobUploadPath+cSubDirUnverarbeitet+'\'+ListBox5.Items[n]);
  end;

end;

procedure TFormFotoService.Button3Click(Sender: TObject);

  procedure doWork(n: integer);
  var
    FName, FNameRemote: string;
  begin
    FName := ListBox5.Items[n];
    FNameRemote := nextp(FName, '+', 1);
    FileMove(MobUploadPath + cLocation_Unverarbeitet + FName,
      MobUploadPath + FNameRemote);
  end;

var
  n: integer;

begin
  if (ListBox5.ItemIndex <> -1) then
  begin
    doWork(ListBox5.ItemIndex);
    ListBox5.Items.delete(ListBox5.ItemIndex);
  end
  else
  begin
    for n := 0 to pred(ListBox5.Items.count) do
      doWork(n);
    ListBox5.Items.Clear;
  end;
end;

procedure TFormFotoService.Button12Click(Sender: TObject);
begin
  ListBox5.ItemIndex := -1;
  Button3Click(Sender);
end;

procedure TFormFotoService.Button13Click(Sender: TObject);
begin
  ShowMessage(inttostrN(GEN_ID, cAnzahlStellen_Transaktionszaehler));
end;

procedure TFormFotoService.Button14Click(Sender: TObject);
const
  cPath_pdf_Temp = 'FreePDF\';
  cPDF_File = 'OrgaMon.pdf';
  cWaitGranularity = 2000;
  cWaitMax = 60000;

  function convert(FName: string): boolean;
  var
    OverAllWaitedTime: integer;
    TimeOut: boolean;
  begin
    result := false;
    repeat
      FileDelete(PersonalDataDir + cPath_pdf_Temp + cPDF_File);
      if FileExists(PersonalDataDir + cPath_pdf_Temp + cPDF_File) then
        break;

      printhtmlOK(FName);

      OverAllWaitedTime := 0;
      TimeOut := false;
      repeat
        if FileExists(PersonalDataDir + cPath_pdf_Temp + cPDF_File) then
          break;

        if (OverAllWaitedTime >= cWaitMax) then
        begin
          TimeOut := true;
          // ErrorCode := 'TimeOut on waiting for '+PersonalDataDir + cPath_pdf_Temp + cPDF_File
          break;
        end;

        delay(cWaitGranularity);
        inc(OverAllWaitedTime, cWaitGranularity);

      until false;

      if TimeOut then
        break;

      delay(5000);

      if not(FileMove(
        { } PersonalDataDir + cPath_pdf_Temp + cPDF_File,
        { } FName + '.pdf')) then
      begin
        // ErrorCode := 'Can not move to '+FName+'.pdf'
        break;
      end;

      //
      FileTouch(FName + '.pdf', FileDateTime(FName));

      delay(1000);
      result := true;
      break;

    until true;
  end;

var
  sDir: TStringList;
  n: integer;
  pPath_html: string;
begin
  Button14.Enabled := false;
  if (Edit1.Text = '') then
  begin
    pPath_html := Edit6.Text;

    // Alle
    sDir := TStringList.Create;
    dir(pPath_html + '*.zip.html', sDir, false);
    if (sDir.count > 0) then
    begin
      ProgressBar1.Max := pred(sDir.count);
      ProgressBar1.Position := 0;
      for n := 0 to pred(sDir.count) do
      begin
        if CheckBox4.checked then
          break;
        ProgressBar1.Position := n;
        if FileExists(pPath_html + sDir[n] + '.pdf') then
          continue;
        if not(convert(pPath_html + sDir[n])) then
          break;
      end;
      ProgressBar1.Position := 0;
    end;
    sDir.Free;
  end
  else
  begin
    // Einzelne
    convert(Edit1.Text);
  end;
  Button14.Enabled := true;
end;

procedure TFormFotoService.Button15Click(Sender: TObject);
begin
  // Read MemCached
  if not(assigned(MemCache)) then
    MemCache := TMemCache.Create;

  MemCache.CheckServers;
  ListBox9.Items.Add(

    inttostr(MemCache.Increment('sequence.69VVTGKZ1')));

end;

procedure TFormFotoService.Button16Click(Sender: TObject);
begin
  ensureGlobals;
  JonDaExec.doSync;
end;

procedure TFormFotoService.Button4Click(Sender: TObject);
begin
  if CheckBox1.checked then
    workEingang(false);
  if CheckBox2.checked then
    workWartend(false);
end;

procedure TFormFotoService.Button5Click(Sender: TObject);
begin
  workEingang(true);
end;

procedure TFormFotoService.Button6Click(Sender: TObject);
begin
  workWartend(true);
end;

const
  PostgreSQL_Connection: TZConnection = nil;
  PostgreSQL_Query: TZQuery = nil;

procedure TFormFotoService.Button7Click(Sender: TObject);
var
  n: integer;
begin

  if not(assigned(PostgreSQL_Connection)) then
  begin

    // Connection
    PostgreSQL_Connection := TZConnection.Create(self);
    with PostgreSQL_Connection do
    begin
      Protocol := 'postgresql';
      TransactIsolationLevel := tiReadCommitted;
      User := 'postgres';
      HostName := 'raib25';
      Database := 'OrgaMon';
      //
      Connect;

      ListBox8.Items.Add('PostgreSQL Rev. ' + ServerVersionStr);
      ListBox8.Items.Add('PostgreSQL-Client Rev. ' + ClientVersionStr);
    end;

    // Query
    PostgreSQL_Query := TZQuery.Create(self);
    with PostgreSQL_Query do
    begin
      Connection := PostgreSQL_Connection;
    end;
  end;

  with PostgreSQL_Query do
  begin

    sql.Clear;
    sql.Add('select * from auftrag for update');
    open;
    insert;
    FieldByName('RID').AsInteger := random(202928);
    post;
    close;

    sql.Clear;
    sql.Add('select * from auftrag');
    open;
    for n := 0 to pred(FieldCount) do
      ListBox8.Items.Add(Fields[n].FieldName);
    First;
    while not(eof) do
    begin
      ListBox8.Items.Add(FieldByName('rid').AsString);
      Next;
    end;
    close;
  end;
end;

procedure TFormFotoService.Button8Click(Sender: TObject);
begin
  workAblage;
end;

procedure TFormFotoService.Button9Click(Sender: TObject);
var
  WARTEND: tsTable;
  AUFTRAG_R: integer;
  r: integer;
  i: integer;
begin

  WARTEND := tsTable.Create;
  repeat

    if (ListBox6.ItemIndex = -1) then
      break;
    i := ListBox6.ItemIndex;

    AUFTRAG_R := StrToIntDef(nextp(ListBox6.Items[ListBox6.ItemIndex], ';', 2),
      cRID_Null);
    if (AUFTRAG_R < cRID_FirstValid) then
      break;

    // Delete Entry
    with WARTEND do
    begin
      insertFromFile(MyWorkingPath + cFotoUmbenennungAusstehend);
      r := locate('RID', inttostr(AUFTRAG_R));
      if (r = -1) then
        break;
      del(r);
      SaveToFile(MyWorkingPath + cFotoUmbenennungAusstehend);
    end;

  until true;
  WARTEND.Free;
  // Refresh
  SpeedButton3Click(Sender);

  // set Focus
  if i < ListBox6.Items.count then
    ListBox6.ItemIndex := i;

end;

procedure TFormFotoService.doRemote(GeraeteNo, Command, FName: string);
const
  cRemoteFotoPath = '/mnt/sdcard/DCIM/Camera/';
var
  sKOmmandos: TStringList;
  KommandoFName: String;
begin
  sKOmmandos := TStringList.Create;

  KommandoFName := JonDaServerPath + cGeraeteKommandos + GeraeteNo + '.ini';
  if FileExists(KommandoFName) then
    sKOmmandos.LoadFromFile(KommandoFName);

  // mv
  if Command = 'mv' then
    sKOmmandos.Add(
      { } Command + ' ' +
      { } cRemoteFotoPath + 'u' +
      { } FName + ' ' +
      { } cRemoteFotoPath +
      { } FName);

  // rm
  if Command = 'rm' then
    sKOmmandos.Add(
      { } Command + ' ' +
      { } cRemoteFotoPath + 'u' +
      { } FName);

  sKOmmandos.SaveToFile(KommandoFName, TEncoding.UTF8);
  sKOmmandos.Free;

end;

procedure TFormFotoService.ensureGlobals;
var
 MyIni: TIniFile;
 SectionName : string;
begin
  if not(assigned(tBAUSTELLE)) then
  begin

    //
    JonDaExec := TJonDaExec.Create;
    JonDaExec.callback_ZaehlerNummerNeu := ZaehlerNummerNeu;

    // Wir brauchen FTP-Zugangsdaten wegen des Sync
    MyIni := TIniFile.Create(MyProgramPath + cIniFName);
    with MyIni do
    begin
      SectionName := UserName;
      if (ReadString(SectionName, 'ftpuser', '') = '') then
        SectionName := 'System';

      // Ftp-Bereich für diesen Server
      iJonDa_FTPHost := ReadString(SectionName, 'ftphost', 'gateway');
      iJonDa_FTPUserName := ReadString(SectionName, 'ftpuser', '');
      iJonDa_FTPPassword := ReadString(SectionName, 'ftppwd', '');
    end;
    MyIni.free;

    // die aktuellen Daten aus dem FTP-Bereich abholen
    JonDaExec.doSync;

    // Initialer Lauf
    tBAUSTELLE := tsTable.Create;
    tBAUSTELLE.insertFromFile(MyWorkingPath + cMonDaServer_Baustelle);

    // Header anlegen
    if not(FileExists(MyWorkingPath + cFotoUmbenennungAusstehend)) then
      AppendStringsToFile(
        { } cHeader_UmbenennungUnvollstaendig,
        { } MyWorkingPath + cFotoUmbenennungAusstehend);

    // TimeStamp in die Logdatei legen
    if not(LastLogWasTimeStamp) then
    begin
      AppendStringsToFile(
        { } 'timestamp ' + sTimeStamp,
        { } MyWorkingPath + cFotoTransaktionenFName);
      LastLogWasTimeStamp := true;
    end;
  end;

end;

procedure TFormFotoService.FormCreate(Sender: TObject);
begin
  Caption := 'OrgaMonAppService Rev. ' + RevToStr(Version);
  PageControl1.ActivePage := TabSheet1;
end;

function TFormFotoService.GEN_ID: integer;
var
  mIni: TiniFile;
  i: int64;
begin
  mIni := TiniFile.Create(MobUploadPath + 'Backup-Service.ini');
  with mIni do
  begin
    result := StrToInt(ReadString('System', 'Sequence', '0'));
    inc(result);
    if (result >= round(power(10, cAnzahlStellen_Transaktionszaehler))) then
      result := 1;
    WriteString('System', 'Sequence', inttostr(result));
  end;
  mIni.Free;
end;

procedure TFormFotoService.ListBox3Click(Sender: TObject);
begin
  LoadPic;
end;

procedure TFormFotoService.ListBox3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  FindStr, Ablage: string;
  FoundStr: string;
  n, i: integer;
  GeraeteNo, RID: string;
  KommandoFName: string;
  WARTEND: tsTable;
  CopySuccess: boolean;
  FNameSource, FNameDest: string;
begin
  i := ListBox3.ItemIndex;

  // F1: Die Datei ist korrupt - sie muss nochmals übertragen werden
  if (Key = VK_F1) then
  begin
    FindStr :=
    { } ' ' +
    { } ExtractSegmentBetween(Edit4.Text, '\', '\') + '\' +
    { } ListBox3.Items[i];
    for n := 0 to pred(sMoveTransaktionen.count) do
    begin
      if pos('cp', sMoveTransaktionen[n]) = 1 then
        if pos(FindStr, sMoveTransaktionen[n]) > 0 then
        begin
          FoundStr := nextp(sMoveTransaktionen[n], ' ', 1);
          GeraeteNo := nextp(FoundStr, '-', 0);

          doRemote(GeraeteNo, 'mv', FoundStr);

          DeleteFile(Edit4.Text + ListBox3.Items[i]);

          ListBox3.DeleteSelected;

          break;
        end;
    end;
    Key := 0;
  end;

  // F2: Die Umbenennung muss nochmals durchgeführt werden
  if (Key = VK_F2) then
  begin
    FindStr :=
    { } ' ' +
    { } ExtractSegmentBetween(Edit4.Text, '\', '\') + '\' +
    { } ListBox3.Items[i];
    for n := 0 to pred(sMoveTransaktionen.count) do
    begin
      if pos('cp', sMoveTransaktionen[n]) = 1 then
        if pos(FindStr, sMoveTransaktionen[n]) > 0 then
        begin
          FoundStr := nextp(sMoveTransaktionen[n], ' ', 1);

          FileMove(Edit4.Text + ListBox3.Items[i], MobUploadPath + FoundStr);

          ListBox3.DeleteSelected;

          break;
        end;
    end;
    Key := 0;
  end;

  // F3: Die Datei kann aufgegeben werden, keine Verarbeitung erwünscht
  if (Key = VK_F3) then
  begin
    FindStr :=
    { } ' ' +
    { } ExtractSegmentBetween(Edit4.Text, '\', '\') + '\' +
    { } ListBox3.Items[i];
    for n := 0 to pred(sMoveTransaktionen.count) do
    begin
      if (pos('cp', sMoveTransaktionen[n]) = 1) then
        if pos(FindStr, sMoveTransaktionen[n]) > 0 then
        begin
          FoundStr := nextp(sMoveTransaktionen[n], ' ', 1);
          GeraeteNo := nextp(FoundStr, '-', 0);

          doRemote(GeraeteNo, 'rm', FoundStr);
          DeleteFile(Edit4.Text + ListBox3.Items[i]);
          ListBox3.DeleteSelected;

          break;
        end;
    end;
    Key := 0;
  end;

  // In sichtbare Ablage verschieben
  // Eintrag in die Wartend.Tabelle machen
  if (Key = VK_F4) then
  begin
    FindStr :=
    { } ' ' +
    { } ExtractSegmentBetween(Edit4.Text, '\', '\') + '\' +
    { } ListBox3.Items[i];
    for n := 0 to pred(sMoveTransaktionen.count) do
    begin
      if (pos('cp', sMoveTransaktionen[n]) = 1) then
        if pos(FindStr, sMoveTransaktionen[n]) > 0 then
        begin
          FoundStr := nextp(sMoveTransaktionen[n], ' ', 1);
          Ablage := nextp(nextp(sMoveTransaktionen[n], ' ', 2), '\', 0);
          GeraeteNo := nextp(FoundStr, '-', 0);
          RID := nextp(FoundStr, '-', 1);

          // Datei in der aktiven Ablage wieder bereitstellen
          // Es kann aber sein, dass wir schon direkt in der Ablage sind
          // in disem Fall kann das Kopieren unterbleiben
          FNameSource := Edit4.Text + ListBox3.Items[i];
          FNameDest := { } cWorkPath +
          { } Ablage + '\' +
          { } ListBox3.Items[i];
          if (FNameSource <> FNameDest) then
            CopySuccess := FileMove(FNameSource, FNameDest)
          else
            CopySuccess := true;

          if CopySuccess then
          begin

            // Datei in die Tabelle der wartenden einfügen.
            AppendStringsToFile(
              { } FoundStr + ';' +
              { } Ablage + '\' + ListBox3.Items[i] + ';' +
              { } RID + ';' +
              { } GeraeteNo + ';' +
              { } ';' +
              { } DatumLog, MyWorkingPath + cFotoUmbenennungAusstehend);

            ListBox3.DeleteSelected;
          end;

          break;
        end;
    end;
    Key := 0;

  end;

  //
  if (Key = 0) then
  begin
    if (ListBox3.Items.count > 0) then
    begin
      ListBox3.ItemIndex := min(i, ListBox3.Items.count - 1);
      LoadPic;
    end;
  end;

end;

procedure TFormFotoService.LoadPic;
begin
  Image1.Picture.LoadFromFile(Edit4.Text + ListBox3.Items[ListBox3.ItemIndex]);
end;

procedure TFormFotoService.Log(s: string);
begin
  ListBox1.Items.Add(s);
  if (pos('ERROR', s) > 0) then
    AppendStringsToFile(s, MyWorkingPath + 'FotoService.log.txt');
end;

function TFormFotoService.JonDaServerPath: string;
begin
  result := cWorkPath + cLocation_JonDaServer;
end;

function TFormFotoService.MobUploadPath: string;
begin
  result := cWorkPath + cLocation_MOB;
end;

function TFormFotoService.MyWorkingPath: string;
begin
  result := JonDaServerPath + 'Fotos\';
end;

procedure TFormFotoService.releaseGlobals;
begin
  if assigned(tBAUSTELLE) then
  begin
    try
      FreeAndNil(tBAUSTELLE);
      FreeAndNil(JonDaExec);
    except
      ;
    end;
  end;
end;

procedure TFormFotoService.SpeedButton1Click(Sender: TObject);
var
  sDir: TStringList;
  n: integer;
begin

  // Bild-Tester
  sDir := TStringList.Create;
  dir(Edit4.Text + '*.jpg', sDir, false);

  // Maske Reduce
  if Edit5.Text <> '*' then
    for n := pred(sDir.count) downto 0 do
      if pos(Edit5.Text, sDir[n]) = 0 then
        sDir.delete(n);

  sDir.Sort;
  ListBox3.Items.Assign(sDir);
  sDir.Free;
  if not(assigned(sMoveTransaktionen)) then
    sMoveTransaktionen := TStringList.Create;
  sMoveTransaktionen.LoadFromFile(MyWorkingPath + cFotoTransaktionenFName);
end;

procedure TFormFotoService.SpeedButton2Click(Sender: TObject);
var
  sDir: TStringList;
begin
  sDir := TStringList.Create;
  dir(MobUploadPath + cLocation_Unverarbeitet + '*.jpg', sDir, false);
  ListBox5.Items.Assign(sDir);
  sDir.Free;
end;

procedure TFormFotoService.SpeedButton3Click(Sender: TObject);
var
  sWartend: TStringList;
begin
  sWartend := TStringList.Create;
  sWartend.LoadFromFile(MyWorkingPath + cFotoUmbenennungAusstehend);
  ListBox6.Items.Assign(sWartend);
  sWartend.Free;
end;

procedure TFormFotoService.SpeedButton8Click(Sender: TObject);
var
  sDir: TStringList;
begin
  sDir := TStringList.Create;
  dir(MobUploadPath + '*.$$$', sDir, false);
  sDir.Sort;
  ListBox2.Items.Assign(sDir);
  sDir.Free;
  workStatus;

  sDir := TStringList.Create;
  dir(MobUploadPath + '*.jpg', sDir, false);
  sDir.Sort;
  ListBox7.Items.Assign(sDir);
  sDir.Free;
end;

procedure TFormFotoService.workStatus;
var
  sDir: TStringList;
  n: integer;
  FileDateTime: TDateTime;
  sMonteure: TStringList;
  m: string;
  sTabelle: tsTable;
begin
  sDir := TStringList.Create;
  sMonteure := TStringList.Create;
  sTabelle := tsTable.Create;

  try
    dir(MobUploadPath + '*.$$$', sDir, false);
    sDir.Sort;

    // Aktuelle Uploads (=Dateien im aktuellem Zugriff) entfernen
    for n := pred(sDir.count) downto 0 do
    begin
      if not(FileAge(MobUploadPath + sDir[n], FileDateTime)) then
      begin
        // Datei ist verschwunden!
        sDir.delete(n);
        continue;
      end;
      if (SecondsDiff(now, FileDateTime) < 120) then
      begin
        // Datei wird gerade hochgeladen, bzw. ist zu frisch
        sDir.delete(n);
        continue;
      end;
    end;

    for n := 0 to pred(sDir.count) do
    begin
      m := nextp(sDir[n], '-', 0);
      if (sMonteure.IndexOf(m) = -1) then
        sMonteure.Add(m);
    end;

    sTabelle.addCol('Gerät', sMonteure);
    sTabelle.SaveToHTML(cWebPath + 'index.html');
    sTabelle.SaveToFile(cWebPath + 'ausstehende-fotos.csv');
  except

  end;

  sDir.Free;
  sMonteure.Free;
  sTabelle.Free;

end;

function TFormFotoService.AblageFname: string;
begin
  result := format(cFotoAblageFName, [DatumLog]);
end;

function TFormFotoService.AuftragFName(GeraeteNo: string): string;
begin
  result := JonDaServerPath + 'Daten\' + 'AUFTRAG.' + GeraeteNo + '.DAT';
end;

procedure TFormFotoService.TabSheet7Show(Sender: TObject);
begin
  Label7.Caption := 'ZEOS Rev. ' + ZEOS_VERSION;
end;

procedure TFormFotoService.Timer1Timer(Sender: TObject);
begin

  if (pos('+' + Computername + '+', '+KHAO+MAILAND+WERDER+') > 0) then
  begin
    Log('Timer ist nun AUS, da dieses System auf der Blacklist steht ...');
    Timer1.Enabled := false;
    exit;
  end;

  if (TimerInit < cKikstart_delay * 60 * 1000) then
  begin
    if (TimerInit = 0) then
      Log('Warte ' + inttostr(cKikstart_delay) + ' Minuten ...');
    inc(TimerInit, Timer1.Interval);
    if (TimerInit >= cKikstart_delay * 60 * 1000) then
    begin
      Log('Erwacht ... ');
      Button11.Enabled := false;
    end
    else
    begin
      exit;
    end;
  end;

  if not(TimerRunning) then
  begin

    TimerRunning := true;
    try

      // Alle 5 Min!
      if (TimerWartend > 5 * 60 * 1000) then
      begin
        // Ab und zu die neuen Daten beachten
        releaseGlobals;

        // Wartende verarbeiten
        TimerWartend := 0;
        workWartend(true);

        // Status Seite neu bearbeiten
        workStatus;

        // Zwischen 00:00 und ]01:00
        if (SecondsGet < (1 * 3600)) then
          // nur machen, wenn nicht in Arbeit oder fertig
          if not(FileExists(MyWorkingPath + AblageFname)) then
            // Zips verschieben, Fotos zippen
            workAblage;

      end;

      // Jedes Mal
      workEingang(true);

    except

    end;
    inc(TimerWartend, Timer1.Interval);

    TimerRunning := false;
  end;

end;

procedure TFormFotoService.workAblage;

  procedure Log(Source, Dest: string);
  begin
    AppendStringsToFile(sTimeStamp + ';' + Source + ';' + Dest,
      MyWorkingPath + AblageFname);
  end;

const
  cIsAblageMarkerFile = 'ampel-horizontal.gif';
  cFileTimeOutDays = 50 + 10;
  cPicTimeOutDays = 0; // 0 = gestern ist schon zu alt
var
  sDirs: TStringList;
  sZips: TStringList;
  sPics: TStringList;
  sFotos: TStringList;
  n, m: integer;
  sPath, sPathShort: string;
  ZIP_OlderThan: TANFiXDate;
  PIC_OlderThan: TANFiXDate;

  sBackupRoot, sDest, sDestShort: string;
  MovedToDay: int64;
  tabelleBAUSTELLE: tsTable;
  r: integer;

  FTP_Benutzer: string;
  mIni: TiniFile;
  FotosSequence: integer;
  Col_FTP_Benutzer: integer;

  //
  WARTEND: tsTable;
  BasisDatum: TANFiXDate;

  procedure serviceJPG;
  const
    cMaxZIP_Size = 100 * 1024 * 1024;
  var
    m: integer;
    Pending: boolean;
    FotoFSize: int64;
  begin
    Pending := false;
    sPics.Clear;
    repeat
      // Jpegs
      dir(sPath + '*.jpg', sPics, false);
      if (sPics.count = 0) then
        break;

      // reduziere um "zu neue" Bilder
      for m := pred(sPics.count) downto 0 do
        if (FileDate(sPath + sPics[m]) >= PIC_OlderThan) then
          sPics.delete(m);
      if (sPics.count = 0) then
        break;

      // reduziere um "wartende" Bilder
      for m := pred(sPics.count) downto 0 do
        if (WARTEND.locate('DATEINAME_AKTUELL', sPathShort + sPics[m]) <> -1)
        then
          sPics.delete(m);
      if (sPics.count = 0) then
        break;

      // reduziere auf < 100 MByte
      FotoFSize := 0;
      for m := pred(sPics.count) downto 0 do
      begin
        if (FotoFSize >= cMaxZIP_Size) then
        begin
          sPics.delete(m);
          Pending := true;
        end
        else
        begin
          inc(FotoFSize, FSize(sPath + sPics[m]));
        end;
      end;

      // Prüfen, ob dies eine ordentliche Baustelle ist
      FTP_Benutzer := nextp(sPath, '\', 1);
      r := tabelleBAUSTELLE.locate(Col_FTP_Benutzer, FTP_Benutzer);
      if (r = -1) then
      begin
        // 2. Suchversuch mit prefixed "u"
        if CharInSet(FTP_Benutzer[1], ['0' .. '9']) then
        begin
          FTP_Benutzer := 'u' + FTP_Benutzer;
          r := tabelleBAUSTELLE.locate(Col_FTP_Benutzer, FTP_Benutzer);
        end;
      end;

      // (immer noch) nicht gefunden?
      if (r = -1) then
      begin
        FormFotoService.Log('ERROR: FTP-Benutzer "' + FTP_Benutzer +
          '" unbekannt');
        Pending := false;
        break;
      end;

      // Die Nummer des zu erzeugenden ZIP suchen
      mIni := TiniFile.Create(sPath + 'Fotos-nnnn.ini');
      with mIni do
      begin
        FotosSequence := StrToInt(ReadString('System', 'Sequence', '-1'));
        if FotosSequence < 0 then
        begin
          dir(sPath + 'Fotos-????.zip', sFotos, false);
          if sFotos.count > 0 then
          begin
            sFotos.Sort;
            FotosSequence :=
              StrToIntDef(ExtractSegmentBetween(sFotos[pred(sFotos.count)],
              'Fotos-', '.zip'), -1);
          end;
        end;

        if FotosSequence < 0 then
          FotosSequence := 0;

        inc(FotosSequence);
      end;
      mIni.Free;

      // Archivieren
      Log(sPath + 'Fotos-' + inttostrN(FotosSequence,
        cAnzahlStellen_FotosTagwerk) + '.zip', '.');
      if (zip(
        { } sPics,
        { } sPath +
        { } 'Fotos-' + inttostrN(FotosSequence,
        cAnzahlStellen_FotosTagwerk) + '.zip',
        { } infozip_RootPath + '=' + sPath + ';' +
        { } infozip_Password + '=' +
        { } deCrypt_Hex(
        { } tabelleBAUSTELLE.readCell(r, cE_ZIPPASSWORD)) + ';' +
        { } infozip_Level + '=' + '0') <> sPics.count) then
      begin
        // Problem anzeigen
        FormFotoService.Log('ERROR: ' + HugeSingleLine(zMessages, '|'));
        Pending := false;
        break;
      end;

      // Fotos-nnnn.ini erhöhen
      mIni := TiniFile.Create(sPath + 'Fotos-nnnn.ini');
      mIni.WriteString('System', 'Sequence', inttostr(FotosSequence));
      mIni.Free;

      // nun die eben archivierten JPGS löschen!
      for m := 0 to pred(sPics.count) do
        FileDelete(sPath + sPics[m]);

    until true;

    if Pending then
      serviceJPG;

  end;

  procedure serviceHTML;
  var
    m: integer;
  begin
    sPics.Clear;
    repeat

      // Jpegs
      dir(sPath + '*.zip.html', sPics, false);
      if (sPics.count = 0) then
        break;

      // reduziere um "zu neue" Bilder
      for m := pred(sPics.count) downto 0 do
        if (FileDate(sPath + sPics[m]) >= PIC_OlderThan) then
          sPics.delete(m);
      if (sPics.count = 0) then
        break;

      // reduziere um "wartende" Wechselbelege, bei denen das pdf fehlt!
      for m := pred(sPics.count) downto 0 do
        if not(FileExists(sPath + sPics[m] + '.pdf')) then
          sPics.delete(m);
      if (sPics.count = 0) then
        break;

      // .pdf muss auch mit!
      // erweitere um die .pdf Dateien
      for m := 0 to pred(sPics.count) do
        sPics.Add(sPics[m] + '.pdf');

      // Prüfen, ob dies eine ordentliche Baustelle ist
      FTP_Benutzer := nextp(sPath, '\', 1);
      if CharInSet(FTP_Benutzer[1], ['0' .. '9']) then
        FTP_Benutzer := 'u' + FTP_Benutzer;
      r := tabelleBAUSTELLE.locate(Col_FTP_Benutzer, FTP_Benutzer);
      if (r = -1) then
        break;

      // Die Nummer des zu erzeugenden ZIP suchen
      mIni := TiniFile.Create(sPath + 'Wechselbelege-nnnn.ini');
      with mIni do
      begin
        FotosSequence := StrToInt(ReadString('System', 'Sequence', '-1'));
        if FotosSequence < 0 then
        begin
          dir(sPath + 'Wechselbelege-????.zip', sFotos, false);
          if sFotos.count > 0 then
          begin
            sFotos.Sort;
            FotosSequence :=
              StrToIntDef(ExtractSegmentBetween(sFotos[pred(sFotos.count)],
              'Wechselbelege-', '.zip'), -1);
          end;
        end;

        if FotosSequence < 0 then
          FotosSequence := 0;

        inc(FotosSequence);
      end;
      mIni.Free;

      // Archivieren
      Log(sPath + 'Wechselbelege-' + inttostrN(FotosSequence,
        cAnzahlStellen_FotosTagwerk) + '.zip', '.');
      if (zip(
        { } sPics,
        { } sPath +
        { } 'Wechselbelege-' + inttostrN(FotosSequence,
        cAnzahlStellen_FotosTagwerk) + '.zip',
        { } infozip_RootPath + '=' + sPath + ';' +
        { } infozip_Password + '=' +
        { } deCrypt_Hex(
        { } tabelleBAUSTELLE.readCell(r, cE_ZIPPASSWORD)) + ';' +
        { } infozip_Level + '=' + '0') <> sPics.count) then
      begin
        // Problem anzeigen
        FormFotoService.Log('ERROR: ' + HugeSingleLine(zMessages, '|'));
        break;
      end;

      // Laufnummer erhöhen
      mIni := TiniFile.Create(sPath + 'Wechselbelege-nnnn.ini');
      mIni.WriteString('System', 'Sequence', inttostr(FotosSequence));
      mIni.Free;

      // nun die eben archivierten löschen!
      for m := 0 to pred(sPics.count) do
        FileDelete(sPath + sPics[m]);

    until true;
  end;

begin

  // Set "Lock"
  FileAlive(MyWorkingPath + AblageFname);

  // prepare
  sDirs := TStringList.Create;
  sZips := TStringList.Create;
  sPics := TStringList.Create;
  sFotos := TStringList.Create;

  // Infos über Baustellen
  tabelleBAUSTELLE := tsTable.Create;
  tabelleBAUSTELLE.insertFromFile(MyWorkingPath + cMonDaServer_Baustelle);
  Col_FTP_Benutzer := tabelleBAUSTELLE.colOf(cE_FTPUSER);

  // Infos über noch nicht umbenannte Dateien
  WARTEND := tsTable.Create;
  WARTEND.insertFromFile(MyWorkingPath + cFotoUmbenennungAusstehend);

  //
  if (Edit3.Text = '') then
  begin
    BasisDatum := DateGet;
  end
  else
  begin
    BasisDatum := date2long(Edit3.Text);
  end;

  // init
  MovedToDay := 0;
  ZIP_OlderThan := DatePlus(BasisDatum, -cFileTimeOutDays);
  PIC_OlderThan := DatePlus(BasisDatum, -cPicTimeOutDays);

  // Zielbestimmung Sicherungsunterverzeichnis
  sBackupRoot := cBackUpPath + cLocation_JonDaServer;
  dir(sBackupRoot + '*.', sDirs, false);
  sDirs.Sort;
  for n := pred(sDirs.count) downto 0 do
    if (pos('.', sDirs[n]) = 1) then
      sDirs.delete(n);
  sDestShort := sDirs[pred(sDirs.count)];
  sDest := sBackupRoot + sDestShort + '\';

  // work what?
  if (Edit2.Text = '') then
    dir(cWorkPath + '*.', sDirs, false)
  else
  begin
    sDirs.Clear;
    sDirs.Add(Edit2.Text);
  end;

  // sDirs.Clear;
  // sDirs.Add('orgamon-mob');
  for n := 0 to pred(sDirs.count) do
  begin
    if (pos('.', sDirs[n]) = 1) then
      continue;
    sPathShort := sDirs[n] + '\';
    sPath := cWorkPath + sPathShort;

    if FileExists(sPath + cIsAblageMarkerFile) then
    begin

      repeat

        // Zips ablegen
        dir(sPath + '*.zip', sZips, false);
        for m := 0 to pred(sZips.count) do
        begin
          if (FileDate(sPath + sZips[m]) < ZIP_OlderThan) then
          begin
            checkcreatedir(sDest + sDirs[n]);
            inc(MovedToDay, FSize(sPath + sZips[m]));
            Log(sPath + sZips[m], sDestShort);
            FileMove(sPath + sZips[m], sDest + sDirs[n] + '\' + sZips[m]);
          end;
        end;

        if (sDirs[n] = 'orgamon-mob') then
          break;

        // jpgs zippen
        serviceJPG;

        // htmls zippen
        serviceHTML;

      until true;

    end;
  end;

  // unprepare
  sDirs.Free;
  sZips.Free;
  sPics.Free;
  sFotos.Free;
  tabelleBAUSTELLE.Free;
  WARTEND.Free;
  Log('ENDE', '*');
end;

procedure TFormFotoService.workEingang(All: boolean);
var
  sFiles: TStringList;
  IgnoreIt: boolean; // Überspringen weil zu neu?!
  sFilesClientSorter: TStringList;
  sTemp: TStringList;
  n, m, i, f: integer;
  FileTimeStamp: TDateTime;
  d, File_Date: TANFiXDate;
  s, File_Seconds: TANFiXTime;
  FName: string;
  ID: string;
  RID: integer;
  bOrgaMon, bOrgaMonOld: TBLager;
  mderecOrgaMon: TMDERec;
  FotoMussWarten: boolean;
  FotoPrefix: string;
  FotoGeraeteNo: string;
  FotoParameter: string; // FA, Ausbau, FN, Anlage usw.
  FotoDateiName, FotoDateiNameVerfuegbar: string; // Kompletter Dateiname
  FotoZiel: string;
  FotoHost: string;

  FullSuccess: boolean;
  FoundAuftrag: boolean;
  UmbenennungAbgeschlossen: boolean;
  Image: TJPEGImage;
  sBaustelle: string;
  sZiel: string;

  BAUSTELLE_Index: integer;
  ZAEHLER_NUMMER_NEU: string;

  // alternativer Auftragspool
  fOrgaMonAuftrag: file of TMDERec;
  iEXIF: TExifData;
  AufnahmeMoment: TDateTime;

  // Foto - Umbenennung
  sFotoCall: TStringList;
  sFotoResult: TStringList;
  RenameError: boolean;

  procedure unverarbeitet(m: integer);
  begin

    // Datei wegsperren, aber nicht löschen!
    FileMove(
      { } MobUploadPath + sFiles[m],
      { } MobUploadPath + cLocation_Unverarbeitet + ID + '+' + sFiles[m]);

    // Datei aus der Verarbeitungskette entfernen
    sFiles.delete(m);
  end;

begin

  // Init Phase
  sFiles := TStringList.Create;
  sFilesClientSorter := TStringList.Create;
  ID := '';

  // get File List
  dir(MobUploadPath + '*.jpg', sFiles, false);

  // reduce to Files-Age > 5 Seconds
  d := DateGet;
  s := SecondsGet;
  for n := pred(sFiles.count) downto 0 do
  begin
    FName := MobUploadPath + sFiles[n];
    FileAge(FName, FileTimeStamp);
    File_Date := DateTime2long(FileTimeStamp);
    File_Seconds := cIllegalSeconds;

    IgnoreIt := true;
    repeat

      if not(DateOK(File_Date)) then
      begin
        Log('Wrong Filedate ' + FName + ' ...');
        break;
      end;

      File_Seconds := dateTime2Seconds(FileTimeStamp);
      if SecondsDiff(d, s, File_Date, File_Seconds) < 4 then
      begin
        Log('Skip new ' + FName + ' ...');
      end;

      IgnoreIt := false;

    until true;
    if not(IgnoreIt) then
      sFilesClientSorter.AddObject(
        { } long2dateLog(File_Date) + '|' +
        { } secondstostr(File_Seconds) + '|' +
        { } sFiles[n], TObject(n));

  end;

  // Sort Files by "Date / Time", Oldest topmost
  sFilesClientSorter.Sort;
  sTemp := TStringList.Create;
  for n := 0 to pred(sFilesClientSorter.count) do
    sTemp.Add(sFiles[integer(sFilesClientSorter.Objects[n])]);
  sFiles.Assign(sTemp);
  sTemp.Free;

  // Reduce Work to Only One!
  if not(All) then
    for n := pred(sFiles.count) downto 1 do
      sFiles.delete(n);

  // Generate Work-TAN
  if (sFiles.count > 0) then
    ID := inttostrN(GEN_ID, cAnzahlStellen_Transaktionszaehler);

  // make backup of all new Files
  for n := 0 to pred(sFiles.count) do
    if not(FileCopy(MobUploadPath + sFiles[n], cBackUpPath + cLocation_MOB + ID
      + '-' + sFiles[n])) then
    begin
      Log('ERROR: ' + 'can not write to ' + cBackUpPath + cLocation_MOB);
      Timer1.Enabled := false;
      exit;
    end;

  // reduce to valid jpg's
  for n := pred(sFiles.count) downto 0 do
  begin
    FullSuccess := false;
    FName := MobUploadPath + sFiles[n];
    Image := TJPEGImage.Create;
    iEXIF := TExifData.Create;
    try
      repeat

        // Load it
        Image.LoadFromFile(FName);

        // Delphi Bug, can not read jpeg compression!
        (*
          if (image.CompressionQuality>0) then
          begin
          Log('INFO: jpeg quality '+inttostr(image.CompressionQuality));
          end;
        *)

        if (Image.Width < 640) then
        begin
          Log('ERROR: ' + sFiles[n] + ': Breite kleiner als 640');
          break;
        end;

        if (Image.Height < 480) then
        begin
          Log('ERROR: ' + sFiles[n] + ': Höhe kleiner als 480');
          break;
        end;

        // get Foto-Moment, touch File-Date-Time
        if not(iEXIF.LoadFromJPEG(FName)) then
        begin
          Log('ERROR: ' + sFiles[n] + ': EXiF konnte nicht geladen werden');
          break;
        end;

        if (iEXIF.DateTimeOriginal <> FileDateTime(FName)) then
        begin
          Log('INFO: ' + sFiles[n] + ': Dateizeitstempel korrigiert');
          FileTouch(FName, iEXIF.DateTimeOriginal);
        end;
        FullSuccess := true;

      until true;

    except
      on e: exception do
      begin
        Log('ERROR: ' + sFiles[n] + ': ' + e.Message);
      end;
    end;
    Image.Free;
    iEXIF.Free;

    if not(FullSuccess) then
      unverarbeitet(n);
  end;

  if (sFiles.count > 0) then
  begin

    ensureGlobals;

    bOrgaMon := TBLager.Create;
    bOrgaMon.Init(MyWorkingPath + 'AUFTRAG+TS', mderecOrgaMon, sizeof(TMDERec));
    bOrgaMon.BeginTransaction(now);

    if FileExists(MyWorkingPath + '_AUFTRAG+TS' + cBL_FileExtension) then
    begin
      bOrgaMonOld := TBLager.Create;
      bOrgaMonOld.Init(MyWorkingPath + '_AUFTRAG+TS', mderecOrgaMon,
        sizeof(TMDERec));
      bOrgaMonOld.BeginTransaction(now);
    end
    else
    begin
      bOrgaMonOld := nil;
    end;

    sFiles.Sort;

    // Umbenennen nach dem Standard der jeweiligen Baustelle
    for m := pred(sFiles.count) downto 0 do
    begin
      RenameError := false;
      FullSuccess := false;
      FoundAuftrag := false;
      UmbenennungAbgeschlossen := false;
      BAUSTELLE_Index := -1;

      // Parameter aus der Bilddatei berechnen
      FotoGeraeteNo := nextp(sFiles[m], '-', 0);
      RID := StrToIntDef(nextp(sFiles[m], '-', 1), -1);
      FotoParameter := nextp(nextp(sFiles[m], '-', 2), '.', 0);
      sBaustelle := '';
      sZiel := '';

      // passenden Auftrag suchen
      while true do
      begin

        if (RID < 1) then
        begin
          Log('ERROR: ' + sFiles[m] + ': RID konnte nicht ermittelt werden!');
          break;
        end;

        // Im OrgaMon Record-Store
        if bOrgaMon.exist(RID) then
        begin
          bOrgaMon.get;
          FoundAuftrag := true;
          break;
        end;

        Log('WARNUNG: ' + sFiles[m] + ': RID in ' + bOrgaMon.FileName +
          ' nicht vorhanden!');

        // In der Alternative suchen
        if (assigned(bOrgaMonOld)) then
        begin
          if bOrgaMonOld.exist(RID) then
          begin
            bOrgaMonOld.get;
            FoundAuftrag := true;
            break;
          end;

          Log('WARNUNG: ' + sFiles[m] + ': RID in ' + bOrgaMonOld.FileName +
            ' nicht vorhanden!');
        end;

        // Im aktuellen Auftrag des Monteurs
        assignFile(fOrgaMonAuftrag, JonDaServerPath + cServerDataPath +
          FotoGeraeteNo + cDATExtension);
        try
          reset(fOrgaMonAuftrag);
        except
          on e: exception do
            Log('ERROR: 519: ' + sFiles[m] + ':' + e.Message);
        end;

        for f := 1 to FileSize(fOrgaMonAuftrag) do
        begin

          read(fOrgaMonAuftrag, mderecOrgaMon);
          if (RID = mderecOrgaMon.RID) then
          begin
            FoundAuftrag := true;
            break;
          end;
        end;
        CloseFile(fOrgaMonAuftrag);
        if FoundAuftrag then
          break;
        Log('ERROR: ' + sFiles[m] + ': RID ' + inttostr(RID) +
          ' konnte nicht gefunden werden!');
        break;
      end;

      if FoundAuftrag then
      begin

        sBaustelle := Oem2utf8(mderecOrgaMon.Baustelle);
        while true do
        begin

          BAUSTELLE_Index := tBAUSTELLE.locate(0, sBaustelle);
          if (BAUSTELLE_Index > -1) then
          begin

            // Modus der Fotobenennung ermitteln
            FotoMussWarten := false;

            sFotoCall := TStringList.Create;

            with mderecOrgaMon do
            begin
              // Belegung der Foto-Parameter
              sFotoCall.Values[cParameter_foto_Modus] :=
                tBAUSTELLE.readCell(BAUSTELLE_Index, cE_FotoBenennung);
              sFotoCall.Values[cParameter_foto_parameter] := FotoParameter;
              // bisheriger Bildparameter
              sFotoCall.Values[cParameter_foto_baustelle] := sBaustelle;
              sFotoCall.Values[cParameter_foto_strasse] :=
                Oem2asci(Zaehler_Strasse);
              sFotoCall.Values[cParameter_foto_ort] := Oem2asci(Zaehler_Ort);
              sFotoCall.Values[cParameter_foto_zaehler_info] := Zaehler_Info;
              sFotoCall.Values[cParameter_foto_RID] := inttostr(RID);
              sFotoCall.Values[cParameter_foto_zaehlernummer_alt] :=
                zaehlernummer_alt;
              sFotoCall.Values[cParameter_foto_zaehlernummer_neu] :=
                zaehlernummer_neu;
              sFotoCall.Values[cParameter_foto_geraet] := FotoGeraeteNo;
              sFotoCall.Values[cParameter_foto_Pfad] := JonDaServerPath + cdbPath;
            end;
            sFotoResult := JonDaExec.foto(sFotoCall);
            sFotoCall.Free;

            // Ergebnis auswerten
            FotoDateiName := sFotoResult.Values[cParameter_foto_neu];
            UmbenennungAbgeschlossen :=
              (sFotoResult.Values[cParameter_foto_fertig]
              = JonDaExec.activ(true));
            sZiel := sFotoResult.Values[cParameter_foto_Ziel];

            if (sFotoResult.Values[cParameter_foto_Fehler] <> '') then
            begin
              RenameError := true;
              Log('ERROR: ' + sFotoResult.Values[cParameter_foto_Fehler]);
            end;

            sFotoResult.Free;

            if (sBaustelle <> sZiel) then
              BAUSTELLE_Index := tBAUSTELLE.locate(0, sZiel);

          end;

          //
          if (BAUSTELLE_Index <= -1) then
          begin
            Log('ERROR: ' + sFiles[m] + ': Baustelle "' + sBaustelle +
              '" unbekannt!');
          end;

          break;
        end;

        //
        if (BAUSTELLE_Index > -1) and not(RenameError) then
        begin
          FotoZiel := tBAUSTELLE.readCell(BAUSTELLE_Index, cE_FTPUSER);
          FotoHost := tBAUSTELLE.readCell(BAUSTELLE_Index, cE_FTPHOST);
          repeat

            if (length(FotoZiel) < 3) then
            begin
              Log('ERROR: ' + sFiles[m] + ': ' + sBaustelle +
                ': Keine Internet-Ablage definiert');
              break;
            end;

            // Workaround, Linux User mit Ziffer am Anfang geht nicht
            if (FotoZiel[1] = 'u') and CharInSet(FotoZiel[2], ['0' .. '9']) then
              FotoZiel := copy(FotoZiel, 2, MaxInt);

            // Fotoziel ist der Name der Internet-Ablage nicht der
            // des SAP Verzeichnisses
            FotoZiel := nextp(FotoZiel, '\', 0);

            if not(DirExists(cWorkPath + FotoZiel)) then
            begin
              Log('ERROR: ' + sFiles[m] + ': ' + sBaustelle +
                ': Internet-Ablage "' + FotoZiel +
                '": Das Verzeichnis existiert nicht');
              break;
            end;

            // freien Ziel-Dateinamen finden:
            FotoDateiNameVerfuegbar := FotoDateiName;
            i := 1;
            repeat
              if not(FileExists(cWorkPath + FotoZiel + '\' +
                FotoDateiNameVerfuegbar)) then
                break;
              if (i = 1) then
                FotoDateiNameVerfuegbar := copy(FotoDateiNameVerfuegbar, 1,
                  revpos('.', FotoDateiNameVerfuegbar) - 1) + '-' +
                  inttostr(i) + '.jpg'
              else
                FotoDateiNameVerfuegbar := copy(FotoDateiNameVerfuegbar, 1,
                  revpos('-', FotoDateiNameVerfuegbar) - 1) + '-' +
                  inttostr(i) + '.jpg';
              inc(i);
            until false;

            // Ist der Dateiname schon belegt, wird ggf. Platz geschaffen.
            // Der hereinkommende Name hat Vorrang vor den bisher
            // unter diesem Namen bereitgestellten Bildern.
            // Aber nur wenn die hereinkommende Datei jünger ist
            // als das aktuelle Bild
            if (FotoDateiName <> FotoDateiNameVerfuegbar) then
            begin
              if (
                { } ExifDatum(MobUploadPath + sFiles[m])
                { } >=
                { } ExifDatum(cWorkPath + FotoZiel + '\' + FotoDateiName)) then
              begin
                if not(FileRename(
                  { } cWorkPath + FotoZiel + '\' + FotoDateiName,
                  { } cWorkPath + FotoZiel + '\' + FotoDateiNameVerfuegbar))
                then
                begin
                  Log('ERROR: ' + sFiles[m] +
                    ': Platz schaffen nicht erfolgreich');
                  break;
                end;
              end
              else
              begin
                Log('INFO: ' + sFiles[m] +
                  ': Veraltetes Bild, behalte Neueres');
                FotoDateiName := FotoDateiNameVerfuegbar;
              end;
            end;

            // Transaktion archivieren
            AppendStringsToFile(
              { } 'cp ' + sFiles[m] +
              { } ' ' + FotoZiel + '\' +
              { } FotoDateiName, MyWorkingPath + cFotoTransaktionenFName);
            LastLogWasTimeStamp := false;

            // Auszeichnen, wenn die Umbenennung vorläufig ist
            if not(UmbenennungAbgeschlossen) then
              AppendStringsToFile(
                { } sFiles[m] + ';' +
                { } FotoZiel + '\' + FotoDateiName + ';' +
                { } inttostr(RID) + ';' +
                { } FotoGeraeteNo + ';' +
                { } ';' +
                { } DatumLog,
                { } MyWorkingPath + cFotoUmbenennungAusstehend);

            // Foto in die richtige Ablage kopieren!
            if not(FileCopy(
              { } MobUploadPath + sFiles[m],
              { } cWorkPath + FotoZiel + '\' + FotoDateiName)) then
            begin
              Log('ERROR: ' + sFiles[m] + ': Kopieren nicht erfolgreich');
              break;
            end;

            FullSuccess := true;

          until true;
        end;

      end;

      if not(FullSuccess) then
        unverarbeitet(m);

    end; // for m

    bOrgaMon.EndTransaction;
    bOrgaMon.Free;

    if assigned(bOrgaMonOld) then
    begin
      bOrgaMonOld.EndTransaction;
      bOrgaMonOld.Free;
    end;

    // Bilder jetzt einfach sichern
    if (sFiles.count > 0) then
    begin
      (*
        if (zip(
        { } sFiles,
        { } MobUploadPath + ID + '-Bilder.zip',
        { } infozip_RootPath + '=' + MobUploadPath) = sFiles.count) then
        begin
        Log(ID);
        for n := 0 to pred(sFiles.count) do
        if not(FileDelete(MobUploadPath + sFiles[n])) then
        begin
        Log('ERROR: ' + 'can not delete ' + sFiles[n]);
        Timer1.Enabled := false;
        exit;
        end;
        end
        else
        begin
        Log('ERROR: Fehler beim Anlegen der ZIP-Datei!');
        end;
      *)

      Log(ID);
      for n := 0 to pred(sFiles.count) do
        if not(FileDelete(MobUploadPath + sFiles[n])) then
        begin
          Log('ERROR: ' + sFiles[n] + ': Nicht löschbar');
          Timer1.Enabled := false;
          exit;
        end;

    end;
  end;

  sFiles.Free;
  sFilesClientSorter.Free;
end;

procedure TFormFotoService.workWartend(All: boolean);
var
  WARTEND: tsTable;
  CSV: tsTable;
  r, i, k, ro: integer;
  ZAEHLER_NUMMER_NEU: string;
  FNameAlt, FNameNeu: string;
  RID: integer;
  sBaustelle: string;
  BAUSTELLE_Index: integer;

  // Baustellen-Ermittlung
  bOrgaMon: TBLager;
  mderecOrgaMon: TMDERec;
  FotoBenennungsModus: integer;

  // Foto Benennungs Funktion
  sFotoCall, rFoto: TStringList;
begin

  // Init
  ensureGlobals;
  invalidateZaehlerNummerNeuCache;

  CSV := nil;
  WARTEND := tsTable.Create;
  with WARTEND do
  begin
    //
    insertFromFile(MyWorkingPath + cFotoUmbenennungAusstehend);
    SortBy('GERAETENO');

    // sicherstellen der Spalte
    addCol('BAUSTELLE');
    addCol('MOMENT');

  end;

  bOrgaMon := TBLager.Create;
  bOrgaMon.Init(MyWorkingPath + 'AUFTRAG+TS', mderecOrgaMon, sizeof(TMDERec));
  bOrgaMon.BeginTransaction(now);

  for r := WARTEND.RowCount downto 1 do
  begin

    RID := StrToIntDef(WARTEND.readCell(r, 'RID'), 0);
    ZAEHLER_NUMMER_NEU := '';

    // Hinzunehmen der Baustellen-Info
    sBaustelle := WARTEND.readCell(r, 'BAUSTELLE');
    if (sBaustelle = '') then
      if bOrgaMon.exist(RID) then
      begin
        bOrgaMon.get;
        sBaustelle := Oem2utf8(mderecOrgaMon.Baustelle);
        WARTEND.writeCell(r, 'BAUSTELLE', sBaustelle);
      end;

    // Ist bei dieser Baustelle eine Umbenennung überhaupt erwünscht?
    if (sBaustelle <> '') then
    begin
      BAUSTELLE_Index := tBAUSTELLE.locate(0, sBaustelle);
      if (BAUSTELLE_Index > -1) then
      begin
        FotoBenennungsModus := StrToIntDef(
          { } tBAUSTELLE.readCell(
          { } BAUSTELLE_Index,
          { } cE_FotoBenennung), 0);

        // Ist überhaupt eine Umbenennung nötig?
        if (FotoBenennungsModus = 7) then
          ZAEHLER_NUMMER_NEU := 'Neu';

      end;
    end;

    // Umbenennungsversuch über die Monteurs-Eingabe
    if (ZAEHLER_NUMMER_NEU = '') then
      ZAEHLER_NUMMER_NEU :=
      { } ZaehlerNummerNeu(
        { } RID,
        { } WARTEND.readCell(r, 'GERAETENO'));

    // Zuschaltbare Alternative: den Inhalt einer CSV prüfen
    if (ZAEHLER_NUMMER_NEU = '') then
      if CheckBox3.checked then
      begin
        if not(assigned(CSV)) then
        begin
          CSV := tsTable.Create;
          CSV.insertFromFile(MyWorkingPath + 'ZaehlerNummerNeu.xls.csv');
        end;
        ro := CSV.locate('ReferenzIdentitaet', inttostr(RID));
        if (ro <> -1) then
          ZAEHLER_NUMMER_NEU := CSV.readCell(ro, 'ZaehlerNummerNeu');
      end;

    // kein Ergebnis -> keine Aktion
    if (ZAEHLER_NUMMER_NEU = '') then
      continue;

    // Umbenennung starten
    FNameAlt := WARTEND.readCell(r, 'DATEINAME_AKTUELL');

    if not(FileExists(cWorkPath + FNameAlt)) then
    begin
      Log('INFO: ' + 'überspringe Datei "' + FNameAlt +
        '" da verschwunden, oder bereits umbenannt');
      WARTEND.del(r);
      continue;
    end;

    FNameNeu := FNameAlt;
    k := pos('-Neu', FNameNeu);
    if (k = 0) then
    begin
      Log('ERROR: ' + 'keine Ahnung wie man "' + FNameNeu +
        '" umbenennen soll');
      continue;
    end;

    // imp pend: Immer (nicht nur bei Modus=6) sollte die Dateinamensfindung
    // über die Standard-Umbenennungs-Funktion "foto" erfolgen
    // ev. mit einem "nil" Callback für die Z# Neu, oder einem
    // der die Monteurseingaben berücksichtigen kann.

    if (FotoBenennungsModus = 6) then
    begin

      // prepare
      sFotoCall := TStringList.Create;
      with sFotoCall do
      begin
        Values[cParameter_foto_Modus] := inttostr(FotoBenennungsModus);
        Values[cParameter_foto_baustelle] := sBaustelle;
        Values[cParameter_foto_parameter] := 'FN';
        Values[cParameter_foto_zaehlernummer_alt] := copy(FNameNeu, 1, pred(k));
        Values[cParameter_foto_zaehlernummer_neu] := ZAEHLER_NUMMER_NEU;
      end;

      // execute
      rFoto := JonDaExec.foto(sFotoCall);
      sFotoCall.Free;
      FNameNeu := rFoto.Values[cParameter_foto_neu];
      rFoto.Free;

    end
    else
    begin
      FNameNeu :=
      { } copy(FNameNeu, 1, k) +
      { } TJonDaExec.FormatZaehlerNummerNeu(ZAEHLER_NUMMER_NEU) +
      { } '.jpg';
    end;

    if (FNameNeu = FNameAlt) then
    begin
      // ohne Umbenennung einfach nur den Eintrag löschen!
      WARTEND.del(r);
    end
    else
    begin

      // freien Ziel-Dateinamen finden:
      i := 1;
      repeat
        if not(FileExists(cWorkPath + FNameNeu)) then
          break;
        if (i = 1) then
          FNameNeu := copy(FNameNeu, 1, revpos('.', FNameNeu) - 1) + '-' +
            inttostr(i) + '.jpg'
        else
          FNameNeu := copy(FNameNeu, 1, revpos('-', FNameNeu) - 1) + '-' +
            inttostr(i) + '.jpg';
        inc(i);
      until false;

      if FileMove(cWorkPath + FNameAlt, cWorkPath + FNameNeu) then
      begin
        AppendStringsToFile(
          { } 'mv ' + FNameAlt +
          { } ' ' + FNameNeu,
          { } MyWorkingPath + cFotoTransaktionenFName);
        LastLogWasTimeStamp := false;

        WARTEND.del(r);
      end;
    end;

  end;

  bOrgaMon.EndTransaction;
  bOrgaMon.Free;

  if WARTEND.Changed then
    WARTEND.SaveToFile(MyWorkingPath + cFotoUmbenennungAusstehend);

  WARTEND.Free;

  if assigned(CSV) then
    CSV.Free;

end;

const
  _GeraeteNo: string = '';
  EINGABE: tsTable = nil;

procedure TFormFotoService.invalidateZaehlerNummerNeuCache;
begin
  _GeraeteNo := '';
end;

procedure TFormFotoService.FormDestroy(Sender: TObject);
begin
  if assigned(MemCache) then
    MemCache.Free;

  if assigned(EINGABE) then
    EINGABE.Free;
  if assigned(tBAUSTELLE) then
  begin
    tBAUSTELLE.Free;
    JonDaExec.Free;
  end;
end;

function TFormFotoService.ZaehlerNummerNeu(AUFTRAG_R: integer;
  GeraeteNo: string): string;
var
  FName: string;
  r: integer;
begin

  // Datenspeicher laden
  if (GeraeteNo <> _GeraeteNo) then
  begin
    if not(assigned(EINGABE)) then
      EINGABE := tsTable.Create
    else
      EINGABE.Clear;
    FName := MyProgramPath + cStatistikPath + 'Eingabe.' + GeraeteNo + '.txt';
    if FileExists(FName) then
      FileAlive(FName);
    EINGABE.insertFromFile(FName, cHeader_Eingabe);
    _GeraeteNo := GeraeteNo;
  end;

  // RID suchen
  r := EINGABE.locate('RID', inttostr(AUFTRAG_R));
  if (r <> -1) then
    result := EINGABE.readCell(r, 'ZAEHLER_NUMMER_NEU')
  else
    result := '';

end;

end.
