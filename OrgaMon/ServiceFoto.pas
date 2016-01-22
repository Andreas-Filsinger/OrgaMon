{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2012 - 2015  Andreas Filsinger
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
unit ServiceFoto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, WordIndex,
  Vcl.Imaging.jpeg, Vcl.ComCtrls, Vcl.Buttons, Data.DB,
  JonDaExec, memcache, Foto, FotoExec;

type
  TownFotoExec = class(TFotoExec)
    procedure Log(s: string); override;
  end;

type
  TFormServiceFoto = class(TForm)
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
    TabSheet8: TTabSheet;
    ListBox9: TListBox;
    Button15: TButton;
    Edit7: TEdit;
    Label8: TLabel;
    Button16: TButton;
    Label9: TLabel;
    ListBox10: TListBox;
    Label10: TLabel;
    TabSheet9: TTabSheet;
    ListBox11: TListBox;
    Button18: TButton;
    Edit8: TEdit;
    Button19: TButton;
    Button20: TButton;
    Label11: TLabel;
    Edit9: TEdit;
    CheckBox5: TCheckBox;
    TabSheet10: TTabSheet;
    Edit_Rollback_Quelle: TEdit;
    Label12: TLabel;
    Edit_RollBack_Transaktionen: TEdit;
    Label13: TLabel;
    Button21: TButton;
    ListBox12: TListBox;
    Button22: TButton;
    Button23: TButton;
    TabSheet11: TTabSheet;
    Button24: TButton;
    Button25: TButton;
    Label14: TLabel;
    Edit_Rollback_Baustelle: TEdit;
    Button26: TButton;
    StaticText1: TStaticText;
    Button27: TButton;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    Button28: TButton;
    Button7: TButton;
    Edit14: TEdit;
    Edit15: TEdit;
    Label7: TLabel;
    Label17: TLabel;
    Button17: TButton;
    Label18: TLabel;
    Button29: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure ListBox3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure TabSheet9Show(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure ListBox5Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button29Click(Sender: TObject);
  private
    { Private-Deklarationen }
    TimerWartend: integer;
    TimerInit: integer;
    TimerRunning: boolean;
    sMoveTransaktionen: TStringList;
    sLog: TStringList;

    function AuftragFName(GeraeteNo: string): string;
  public
    { Public-Deklarationen }
    MyFotoExec: TownFotoExec;

    procedure LoadPic;
    procedure doRemote(GeraeteNo, Command, FName: string);

  end;

var
  FormServiceFoto: TFormServiceFoto;

implementation

uses
  binlager32, anfix32, globals,
  IniFiles, InfoZip, math,
  CCR.Exif, wanfix32, dbOrgaMon;

{$R *.dfm}

const
  cLocation_MOB = 'orgamon-mob\';
  cLocation_Unverarbeitet = 'unverarbeitet\';

procedure BeginHourGlass;
begin
  if (HourGlassLevel = 0) then
  begin
{$IFNDEF CONSOLE}
    screen.cursor := crHourGlass;
    Application.ProcessMessages;
{$ENDIF}
  end;
  inc(HourGlassLevel);
end;

procedure EnsureHourGlass;
begin
{$IFNDEF CONSOLE}
  if (HourGlassLevel > 0) then
    screen.cursor := crHourGlass
  else
    screen.cursor := crdefault;
{$ENDIF}
end;

procedure EndHourGlass;
begin
  dec(HourGlassLevel);
{$IFNDEF CONSOLE}
  if HourGlassLevel = 0 then
    screen.cursor := crdefault;
{$ENDIF}
end;

procedure EnsureDefaultCursor;
begin
  HourGlassLevel := 0;
{$IFNDEF CONSOLE}
  screen.cursor := crdefault;
{$ENDIF}
end;

procedure TFormServiceFoto.Button10Click(Sender: TObject);
begin
  MyFotoExec.ensureGlobals;
end;

procedure TFormServiceFoto.Button11Click(Sender: TObject);
begin
  if (TimerInit < cKikstart_delay * 60 * 1000) then
    TimerInit := pred(cKikstart_delay * 60 * 1000);
end;

procedure TFormServiceFoto.Button1Click(Sender: TObject);
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

procedure TFormServiceFoto.Button20Click(Sender: TObject);
begin
  FileDelete(MyFotoExec.MyWorkingPath + '_AUFTRAG+TS' + cBL_FileExtension);
end;

procedure TFormServiceFoto.Button22Click(Sender: TObject);
begin
  Edit_Rollback_Quelle.Text := MyFotoExec.pBackUpRootPath;
end;

procedure TFormServiceFoto.Button23Click(Sender: TObject);
begin
  Edit_Rollback_Quelle.Text := MyFotoExec.MyBackupPath;
  // cBackUpPath + cLocation_JonDaServer + '#~AktuelleNummer~\';
end;

procedure TFormServiceFoto.Button24Click(Sender: TObject);
begin
  openShell(MyFotoExec.MyWorkingPath + cMonDaServer_Baustelle);
end;

procedure TFormServiceFoto.Button25Click(Sender: TObject);
begin
  openShell(MyFotoExec.MyWorkingPath + cFotoTransaktionenFName);
end;

procedure TFormServiceFoto.Button21Click(Sender: TObject);
const
  // TransaktionsCountMaske = '??????-';
  TransaktionsCountMaske = '*-';
var
  QuellPfad, TransaktionenFName: string;
  TransaktionsCount: string;
  TRNs: TStringList;
  TRNs_Fail: TStringList;
  n, m: integer;
  SrcFName: string;
  SrcKandidaten: TStringList;
  FotoSize: int64;
begin
  //
  // Rollback
  // ========
  //
  // Ausgangssituation: Neuzuordnung von Bildern nötig.
  //
  // manuell erstellt man einen Auszug aus
  // "FotoService-Transaktionen.log.txt" den man in das
  // JonDaServer/Störungs verzeichnis kopiert
  //
  // Als Bildquelle kann dann ein Sicherungsverzeichnis
  // benutzt werden, also ggf. ein Verzeichnis, das sehr
  // alte Bilder noch gespeichert hat.
  //
  // Ziel: Diese werden alle wieder an den Anfang der
  // Verwarbeitungskette gestellt.
  //

  TRNs := TStringList.Create;
  SrcKandidaten := TStringList.Create;
  TRNs_Fail := TStringList.Create;

  QuellPfad := Edit_Rollback_Quelle.Text;
  TransaktionenFName := Edit_RollBack_Transaktionen.Text;
  ListBox12.Clear;
  TRNs.LoadFromFile(TransaktionenFName);
  for n := 0 to pred(TRNs.count) do
    if pos('cp ', TRNs[n]) = 1 then
    begin
      SrcFName := nextp(TRNs[n], ' ', 1);
      dir(QuellPfad + cLocation_MOB + TransaktionsCountMaske + SrcFName, SrcKandidaten, false, true);
      if (SrcKandidaten.count = 0) then
      begin
        ListBox12.Items.add('ERROR: ' + SrcFName + ' nicht in dieser Quelle');
        TRNs_Fail.add(TRNs[n]);
      end
      else
      begin

        // Identische Rausreduzieren
        for m := pred(SrcKandidaten.count) downto 1 do
        begin
          FotoSize := FSize(QuellPfad + cLocation_MOB + SrcKandidaten[pred(m)]);
          if
          { } (FotoSize > 0) and
          { } (FotoSize = FSize(QuellPfad + cLocation_MOB + SrcKandidaten[m])) then
            SrcKandidaten.Delete(m);
        end;

        if (SrcKandidaten.count > 1) then
        begin
          // Mehrfache versionslieferungen eines Motives geht noch nicht!
          // imp pend!
          ListBox12.Items.add('ERROR: ' + SrcFName + ' kommt mehrfach vor: ' + InttoStr(SrcKandidaten.count) + 'x');
          TRNs_Fail.add(TRNs[n]);
        end
        else
        begin
          TransaktionsCount := nextp(SrcKandidaten[0], '-', 0);
          ListBox12.Items.add(
            { } 'cp ' + QuellPfad + cLocation_MOB + TransaktionsCount + '-' + SrcFName + ' ' +
            { } MyFotoExec.pFTPPath + SrcFName);

          FileCopy(QuellPfad + cLocation_MOB + TransaktionsCount + '-' + SrcFName, MyFotoExec.pFTPPath + SrcFName);
        end;
      end;
      Application.ProcessMessages;
    end;
  TRNs_Fail.SaveToFile(TransaktionenFName + '.fail.txt');

  TRNs.Free;
  SrcKandidaten.Free;
  TRNs_Fail.Free;

end;

procedure TFormServiceFoto.Button26Click(Sender: TObject);
var
  tREFERENZ: tsTable;
  Column_RID: integer;
  r, c, m, n: integer;
  sRID: string;
  QuellPfad: string;
  SrcKandidaten: TStringList;
  FotoSize: int64;

  procedure xmove(FName: string);
  var
    DestFName: string;
  begin
    DestFName := FName;
    nextp(DestFName, '-');
    FileCopy(QuellPfad + FName, 'G:\' + DestFName);
  end;

begin
  //
  // Rollback anhand der Baustellenzugehörigkeit
  // ===========================================
  //
  // Ausgangssituation: Man will Bilder der Baustelle
  // nochmals in die Umbenennungskette stellen.
  //
  // Baustellen mit "Fotobenennung=6" verfügen über
  // Referenzdateien, die den Umbenennungsprozess steuern.
  // Diese Datei wird zu Rate gezogen um alle Bilder
  // nochmals aufzufinden und neu Umbenennen zu lassen.
  //

  QuellPfad := Edit_Rollback_Quelle.Text + cLocation_MOB;
  SrcKandidaten := TStringList.Create;
  tREFERENZ := tsTable.Create;
  with tREFERENZ do
  begin
    insertfromFile(MyFotoExec.MyWorkingPath + cDBPath + Edit_Rollback_Baustelle.Text + '\' + cE_FotoBenennung + '.csv');
    Column_RID := colof(cRID_Suchspalte, true);
    for r := 1 to RowCount do
    begin
      sRID := readCell(r, Column_RID);
      dir(QuellPfad + '*-' + sRID + '*.jpg', SrcKandidaten, false, true);

      if (SrcKandidaten.count > 0) then
      begin

        // Identische rausreduzieren
        n := 0;
        repeat
          FotoSize := FSize(QuellPfad + SrcKandidaten[n]);
          if (FotoSize > 0) then
            for m := pred(SrcKandidaten.count) downto n + 1 do
            begin
              if (FotoSize = FSize(QuellPfad + SrcKandidaten[m])) then
                SrcKandidaten.Delete(m);
            end;
          inc(n);
        until (n >= pred(SrcKandidaten.count));

        if (SrcKandidaten.count > 1) then
        begin
          ListBox12.Items.add('---------------------------');
          ListBox12.Items.add('ERROR: ' + sRID + ' kommt mehrfach vor: ' + InttoStr(SrcKandidaten.count) + 'x');
          for c := 0 to pred(SrcKandidaten.count) do
          begin
            ListBox12.Items.add(SrcKandidaten[c]);
            xmove(SrcKandidaten[c]);
          end;
          ListBox12.Items.add('---------------------------');
        end
        else
        begin
          ListBox12.Items.add(SrcKandidaten[0]);
          xmove(SrcKandidaten[0]);
        end
      end
      else
      begin
        // ListBox12.Items.Add('ERROR: ' + sRID + ' nichts gefunden!');
      end;
    end;
  end;
  tREFERENZ.Free;
  SrcKandidaten.Free;
end;

procedure TFormServiceFoto.Button27Click(Sender: TObject);
var
  FName, FNameRemote: string;
  AmnestiePath: string;
  n: integer;
begin
  if (ListBox5.ItemIndex <> -1) then
  begin
    FName := ListBox5.Items[ListBox5.ItemIndex];
    FNameRemote := nextp(FName, '+', 1);
    AmnestiePath := MyFotoExec.MyBackupPath + 'Amnestie\';
    CheckCreateDIr( AmnestiePath);
    FileMove(
      { } MyFotoExec.pUnverarbeitetPath + FName,
      { } AmnestiePath + Edit10.Text + FNameRemote);

    // delete one Line
    n := ListBox5.ItemIndex;
    ListBox5.Items.Delete(n);
    Label10.Caption := InttoStr(ListBox5.count);
    if (ListBox5.count > 0) then
    begin
      ListBox5.ItemIndex := n;
      ListBox5.SetFocus;
      ListBox5.OnClick(Sender);
    end;
  end;
end;

procedure TFormServiceFoto.Button29Click(Sender: TObject);
begin
  TimerWartend := succ(5 * 60 * 1000);
end;

procedure TFormServiceFoto.Button2Click(Sender: TObject);
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

procedure TFormServiceFoto.Button3Click(Sender: TObject);

  procedure doWork(n: integer);
  var
    FName, FNameRemote: string;
  begin
    FName := ListBox5.Items[n];
    FNameRemote := nextp(FName, '+', 1);
    FileMove(MyFotoExec.pUnverarbeitetPath + FName, MyFotoExec.pFTPPath + FNameRemote);
  end;

var
  n: integer;

begin
  if (ListBox5.ItemIndex <> -1) then
  begin
    doWork(ListBox5.ItemIndex);
    ListBox5.Items.Delete(ListBox5.ItemIndex);
    Label10.Caption := InttoStr(ListBox5.count);
  end
  else
  begin
    for n := 0 to pred(ListBox5.Items.count) do
      doWork(n);
    ListBox5.Items.Clear;
  end;
end;

procedure TFormServiceFoto.Button12Click(Sender: TObject);
begin
  ListBox5.ItemIndex := -1;
  Button3Click(Sender);
end;

procedure TFormServiceFoto.Button13Click(Sender: TObject);
begin
  ShowMessage(inttostrN(MyFotoExec.GEN_ID, cAnzahlStellen_Transaktionszaehler));
end;

procedure TFormServiceFoto.Button14Click(Sender: TObject);
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

procedure TFormServiceFoto.Button15Click(Sender: TObject);
begin
  // Read MemCached
  (*
    if not(assigned(MemCache)) then
    MemCache := TMemCache.Create;

    MemCache.CheckServers;
    ListBox9.Items.Add(

    IntToStr(MemCache.Increment('sequence.69VVTGKZ1')));
  *)
end;

procedure TFormServiceFoto.Button16Click(Sender: TObject);
begin
  MyFotoExec.ensureGlobals;
  MyFotoExec.JonDaExec.doSync;
end;

procedure TFormServiceFoto.Button17Click(Sender: TObject);
begin
  MyFotoExec.readIni(Edit14.Text, Edit15.Text);
end;

procedure TFormServiceFoto.Button18Click(Sender: TObject);
var
  AUFTRAG_R: integer;
  mderecOrgaMon: TMDERec;
  bOrgaMon: TBLager;
  AllTRN: TStringList;
  n: integer;
  AuftragFound: boolean;
begin
  AUFTRAG_R := StrToIntDef(Edit8.Text, 0);
  if (AUFTRAG_R < 1) then
    exit;

  ListBox11.Items.Clear;
  AllTRN := TStringList.Create;

  dir(Edit9.Text + '?????.', AllTRN, false);
  AllTRN.sort;
  ListBox11.Items.add('search in ' + InttoStr(AllTRN.count) + ' subdirs ...');
  for n := pred(AllTRN.count) downto 0 do
  begin
    repeat
      if FileExists(Edit9.Text + AllTRN[n] + '\AUFTRAG+TS.BLA') then
      begin
        AuftragFound := false;
        bOrgaMon := TBLager.Create;
        with bOrgaMon do
        begin
          ListBox11.Items.add('check ' + AllTRN[n] + ' ...');
          Init(Edit9.Text + AllTRN[n] + '\AUFTRAG+TS', mderecOrgaMon, sizeof(TMDERec));
          BeginTransaction(now);
          if exist(AUFTRAG_R) then
          begin
            get;
            ListBox11.Items.add(mderecOrgaMon.Baustelle + '-' + mderecOrgaMon.ABNummer + ' ' +
              Long2date(mderecOrgaMon.ausfuehren_soll));
            AuftragFound := true;
          end;
        end;
        bOrgaMon.EndTransaction;
        bOrgaMon.Free;
        if AuftragFound then
          break;
      end;
      AllTRN.Delete(n);
      if (n mod 25 = 0) then
      begin
        Application.ProcessMessages;
        if CheckBox5.checked then
          break;
      end;

    until true;
  end;
  ListBox11.Items.add('search done!');
  AllTRN.Free;
end;

procedure TFormServiceFoto.Button19Click(Sender: TObject);
var
  TRN: string;
begin
  BeginHourGlass;
  Label11.Caption := '';
  if (ListBox11.ItemIndex = -1) then
  begin
    Label11.Caption := 'ERROR: Es ist nichts markiert';
    exit;
  end;
  TRN := StrFilter(ListBox11.Items[ListBox11.ItemIndex], cZiffern);
  if (length(TRN) <> 5) then
  begin
    Label11.Caption := 'ERROR: Markierte Zeile enthält keine TRN';
    exit;
  end;
  if FileCopy(
    { } Edit9.Text + TRN + '\' + 'AUFTRAG+TS' + cBL_FileExtension,
    { } MyFotoExec.MyWorkingPath + '_AUFTRAG+TS' + cBL_FileExtension) then
    Label11.Caption := 'OK';
  EndHourGlass;
end;

procedure TFormServiceFoto.Button4Click(Sender: TObject);
var
  sParameter: TStringList;
begin
  sParameter := TStringList.Create;
  sParameter.add('ALL=' + cINI_Deactivate);
  if CheckBox1.checked then
    MyFotoExec.workEingang(sParameter);
  if CheckBox2.checked then
    MyFotoExec.workWartend(sParameter);
  sParameter.Free;
end;

procedure TFormServiceFoto.Button5Click(Sender: TObject);
begin
  MyFotoExec.workEingang;
end;

procedure TFormServiceFoto.Button6Click(Sender: TObject);
begin
  MyFotoExec.workWartend;
end;

procedure TFormServiceFoto.Button7Click(Sender: TObject);
const
  pAblageRootPath = 'W:\';
var
  sDirs: TStringList;
  n: integer;
  sPathShort: string;
  sPath: string;
  DoDelete: boolean;
begin
  sDirs := TStringList.Create;
  dir(pAblageRootPath + '*.', sDirs, false);
  for n := pred(sDirs.count) downto 0 do
  begin

    repeat
      DoDelete := true;
      if (pos('.', sDirs[n]) = 1) then
        break;
      if (sDirs[n] = 'orgamon-mob') then
        break;

      sPathShort := sDirs[n] + '\';
      sPath := pAblageRootPath + sPathShort;

      if not(FileExists(sPath + cIsAblageMarkerFile)) then
        break;

      DoDelete := false;

    until true;
    if DoDelete then
      sDirs.Delete(n);

  end;
  sDirs.sort;
  for n := 0 to pred(sDirs.count) do
    sDirs[n] :=
    { } '"' + sDirs[n] + '"' + ';' +
    { } '"' + pAblageRootPath + sDirs[n] + '\"';

  sDirs.insert(0, 'NAME;PFAD');
  sDirs.SaveToFile(pAblageRootPath + 'ABLAGE' + '.csv');
  sDirs.Free;
end;

procedure TFormServiceFoto.Button8Click(Sender: TObject);
var
  sParameter: TStringList;
begin
  BeginHourGlass;
  sParameter := TStringList.Create;
  sParameter.add('DATUM=' + Edit3.Text);
  sParameter.add('EINZELN=' + Edit2.Text);
  MyFotoExec.workAblage(sParameter);
  Edit2.Text := '';
  sParameter.Free;
  EndHourGlass;
end;

procedure TFormServiceFoto.Button9Click(Sender: TObject);
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

    AUFTRAG_R := StrToIntDef(nextp(ListBox6.Items[ListBox6.ItemIndex], ';', 2), cRID_Null);
    if (AUFTRAG_R < cRID_FirstValid) then
      break;

    // Delete Entry
    with WARTEND do
    begin
      insertfromFile(MyFotoExec.MyWorkingPath + cFotoUmbenennungAusstehend);
      r := locate('RID', InttoStr(AUFTRAG_R));
      if (r = -1) then
        break;
      del(r);
      SaveToFile(MyFotoExec.MyWorkingPath + cFotoUmbenennungAusstehend);
    end;

  until true;
  WARTEND.Free;
  // Refresh
  SpeedButton3Click(Sender);

  // set Focus
  if i < ListBox6.Items.count then
    ListBox6.ItemIndex := i;

end;

procedure TFormServiceFoto.CheckBox3Click(Sender: TObject);
begin
  MyFotoExec.ZaehlerNummerNeuXlsCsv_Vorhanden := CheckBox3.checked;
end;

procedure TFormServiceFoto.doRemote(GeraeteNo, Command, FName: string);
const
  cRemoteFotoPath = '/mnt/sdcard/DCIM/Camera/';
var
  sKommandos: TStringList;
  KommandoFName: String;
begin
  sKommandos := TStringList.Create;

  KommandoFName := MyFotoExec.MyWorkingPath + cGeraeteKommandos + GeraeteNo + '.ini';
  if FileExists(KommandoFName) then
    sKommandos.LoadFromFile(KommandoFName);

  // mv
  if (Command = 'mv') then
    sKommandos.add(
      { } Command + ' ' +
      { } cRemoteFotoPath + 'u' +
      { } FName + ' ' +
      { } cRemoteFotoPath +
      { } FName);

  // rm
  if (Command = 'rm') then
    sKommandos.add(
      { } Command + ' ' +
      { } cRemoteFotoPath + 'u' +
      { } FName);

  sKommandos.SaveToFile(KommandoFName, TEncoding.UTF8);
  sKommandos.Free;

end;

procedure TFormServiceFoto.FormActivate(Sender: TObject);
begin
  if (MyFotoExec = nil) then
  begin
    Caption := 'Service-Foto Rev. ' + RevToStr(Version);
    PageControl1.ActivePage := TabSheet1;
    MyFotoExec := TownFotoExec.Create;
  end;
end;

procedure TFormServiceFoto.ListBox3Click(Sender: TObject);
begin
  LoadPic;
end;

procedure TFormServiceFoto.ListBox3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  FindStr, Ablage, Path: string;
  FoundStr: string;
  n, _ItemIndex: integer;
  GeraeteNo, RID: string;
  KommandoFName: string;
  WARTEND: tsTable;
  CopySuccess: boolean;
  FNameSource, FNameDest: string;
begin
  _ItemIndex := ListBox3.ItemIndex;

  // F1: Die Datei ist korrupt - sie muss nochmals übertragen werden
  if (Key = VK_F1) then
  begin
    FindStr :=
    { } ' ' +
    { } ExtractSegmentBetween(Edit4.Text, '\', '\') + '\' +
    { } ListBox3.Items[_ItemIndex];
    for n := 0 to pred(sMoveTransaktionen.count) do
    begin
      if pos('cp', sMoveTransaktionen[n]) = 1 then
        if pos(FindStr, sMoveTransaktionen[n]) > 0 then
        begin
          FoundStr := nextp(sMoveTransaktionen[n], ' ', 1);
          GeraeteNo := nextp(FoundStr, '-', 0);

          doRemote(GeraeteNo, 'mv', FoundStr);

          DeleteFile(Edit4.Text + ListBox3.Items[_ItemIndex]);

          ListBox3.DeleteSelected;

          break;
        end;
    end;
    Key := 0;
  end;

  // F2: Die Umbenennung muss nochmals durchgeführt werden
  if (Key = VK_F2) then
  begin
    Path := ExtractSegmentBetween(Edit4.Text, '\', '\');
    if Path <> '' then
      Path := Path + '\';

    FindStr :=
    { Blank } ' ' +
    { Verzeichnis } Path +
    { Dateiname } ListBox3.Items[_ItemIndex];

    for n := pred(sMoveTransaktionen.count) downto 0 do
    begin

      // wurde die Datei ev. Umbenannt?
      if (pos('mv', sMoveTransaktionen[n]) = 1) then
        if (pos(FindStr, sMoveTransaktionen[n]) > 0) then
        begin
          FindStr := nextp(sMoveTransaktionen[n], ' ', 1);
          continue;
        end;

      // wurde die Datei kopiert?
      if (pos('cp', sMoveTransaktionen[n]) = 1) then
        if (pos(FindStr, sMoveTransaktionen[n]) > 0) then
        begin
          FoundStr := nextp(sMoveTransaktionen[n], ' ', 1);
          if not(FileExists(MyFotoExec.pFTPPath + FoundStr)) then
          begin
            FileMove(Edit4.Text + ListBox3.Items[_ItemIndex], MyFotoExec.pFTPPath + FoundStr);
            ListBox3.DeleteSelected;
          end;
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
    { } ListBox3.Items[_ItemIndex];
    for n := 0 to pred(sMoveTransaktionen.count) do
    begin
      if (pos('cp', sMoveTransaktionen[n]) = 1) then
        if pos(FindStr, sMoveTransaktionen[n]) > 0 then
        begin
          FoundStr := nextp(sMoveTransaktionen[n], ' ', 1);
          GeraeteNo := nextp(FoundStr, '-', 0);

          doRemote(GeraeteNo, 'rm', FoundStr);
          DeleteFile(Edit4.Text + ListBox3.Items[_ItemIndex]);
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
    { } ListBox3.Items[_ItemIndex];
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
          FNameSource := Edit4.Text + ListBox3.Items[_ItemIndex];
          FNameDest :=
          { } Ablage + '\' +
          { } ListBox3.Items[_ItemIndex];
          if (FNameSource <> FNameDest) then
            CopySuccess := FileMove(FNameSource, FNameDest)
          else
            CopySuccess := true;

          if CopySuccess then
          begin

            // Datei in die Tabelle der wartenden einfügen.
            AppendStringsToFile(
              { DATEINAME_ORIGINAL } FoundStr + ';' +
              { DATEINAME_AKTUELL } Ablage + '\' + ListBox3.Items[_ItemIndex] + ';' +
              { RID } RID + ';' +
              { GERAETENO } GeraeteNo + ';' +
              { BAUSTELLE } ';' +
              { MOMENT } DatumLog,
              { Dateiname } MyFotoExec.MyWorkingPath + cFotoUmbenennungAusstehend);

            ListBox3.DeleteSelected;
          end;

          break;
        end;
    end;
    Key := 0;

  end;

  // Bilddatei verkleinern
  if (Key = VK_F5) then
  begin
    BeginHourGlass;
    FNameSource := Edit4.Text + ListBox3.Items[_ItemIndex];
    FNameDest :=
    { } ListBox3.Items[_ItemIndex];

    FotoCompress(FNameSource, FNameDest, 120, 5);

    Key := 0;

    EndHourGlass;
    Beep;
  end;

  //
  if (Key = 0) then
  begin
    if (ListBox3.Items.count > 0) then
    begin
      ListBox3.ItemIndex := min(_ItemIndex, ListBox3.Items.count - 1);
      LoadPic;
    end;
  end;

end;

procedure TFormServiceFoto.ListBox5Click(Sender: TObject);
var
  n: integer;
  FName: string;
begin

  if not(assigned(sLog)) then
  begin
    sLog := TStringList.Create;
    sLog.LoadFromFile(MyFotoExec.MyWorkingPath + 'FotoService.log.txt');
  end;

  FName := nextp(ListBox5.Items[ListBox5.ItemIndex], '+', 1);
  Edit11.Text := nextp(FName, '-', 1);

  for n := pred(sLog.count) downto 0 do
    if pos(FName, sLog[n]) > 0 then
    begin
      StaticText1.Caption := sLog[n];
      break;
    end;

end;

procedure TFormServiceFoto.LoadPic;
begin
  Image1.Picture.LoadFromFile(Edit4.Text + ListBox3.Items[ListBox3.ItemIndex]);
end;

procedure TFormServiceFoto.SpeedButton1Click(Sender: TObject);
var
  sDir: TStringList;
  n: integer;
begin

  // Bild-Tester
  sDir := TStringList.Create;
  dir(Edit4.Text + '*.jpg', sDir, false);

  // Maske Reduce
  if (Edit5.Text <> '*') then
    for n := pred(sDir.count) downto 0 do
      if pos(Edit5.Text, sDir[n]) = 0 then
        sDir.Delete(n);

  sDir.sort;
  ListBox3.Items.Assign(sDir);
  sDir.Free;
  if not(assigned(sMoveTransaktionen)) then
    sMoveTransaktionen := TStringList.Create;
  sMoveTransaktionen.LoadFromFile(MyFotoExec.MyWorkingPath + cFotoTransaktionenFName);
end;

procedure TFormServiceFoto.SpeedButton2Click(Sender: TObject);
var
  sDir: TStringList;
begin
  if assigned(sLog) then
    FreeAndNil(sLog);
  sDir := TStringList.Create;
  dir(MyFotoExec.pUnverarbeitetPath + '*.jpg', sDir, false);
  Label10.Caption := InttoStr(sDir.count);
  ListBox5.Items.Assign(sDir);
  sDir.Free;
end;

procedure TFormServiceFoto.SpeedButton3Click(Sender: TObject);
var
  sWartend: TStringList;
begin
  sWartend := TStringList.Create;
  sWartend.LoadFromFile(MyFotoExec.MyWorkingPath + cFotoUmbenennungAusstehend);
  ListBox6.Items.Assign(sWartend);
  sWartend.Free;
end;

procedure TFormServiceFoto.SpeedButton8Click(Sender: TObject);
var
  sDir: TStringList;
begin
  sDir := TStringList.Create;
  dir(MyFotoExec.pFTPPath + '*.$$$', sDir, false);
  sDir.sort;
  ListBox2.Items.Assign(sDir);
  sDir.Free;
  MyFotoExec.workStatus;

  sDir := TStringList.Create;
  dir(MyFotoExec.pFTPPath + '*.jpg', sDir, false);
  sDir.sort;
  ListBox7.Items.Assign(sDir);
  sDir.Free;

end;

function TFormServiceFoto.AuftragFName(GeraeteNo: string): string;
begin
  result := MyFotoExec.MyWorkingPath + 'Daten\' + 'AUFTRAG.' + GeraeteNo + '.DAT';
end;

procedure TFormServiceFoto.TabSheet9Show(Sender: TObject);
begin
  if (Edit9.Text = '') then
    Edit9.Text := MyFotoExec.MyWorkingPath;
end;

procedure TFormServiceFoto.Timer1Timer(Sender: TObject);
begin

  if (TimerInit < cKikstart_delay * 60 * 1000) then
  begin
    if (TimerInit = 0) then
      MyFotoExec.Log('Warte ' + InttoStr(cKikstart_delay) + ' Minuten ...');
    inc(TimerInit, Timer1.Interval);
    if (TimerInit >= cKikstart_delay * 60 * 1000) then
    begin
      MyFotoExec.Log('Erwacht ... ');
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
        TimerWartend := 0;

        // Ab und zu die neuen Daten beachten
        MyFotoExec.releaseGlobals;

        // Wartende verarbeiten
        MyFotoExec.workWartend;

        // Status Seite neu bearbeiten
        MyFotoExec.workStatus;

        // Zwischen 00:00 und ]01:00
        if (SecondsGet < (1 * 3600)) then
          // nur machen, wenn nicht in Arbeit oder fertig
          if not(FileExists(MyFotoExec.MyWorkingPath + MyFotoExec.AblageFname)) then
            // Zips verschieben, Fotos zippen
            MyFotoExec.workAblage;

      end;

      // Jedes Mal
      MyFotoExec.workEingang;

    except

    end;
    inc(TimerWartend, Timer1.Interval);

    TimerRunning := false;
  end;

end;

{ TownFotoExec }

procedure TownFotoExec.Log(s: string);
begin
  with FormServiceFoto do
  begin
    ListBox1.Items.add(s);
    if (pos('ERROR', s) > 0) then
      AppendStringsToFile(s, MyWorkingPath + 'FotoService.log.txt');
    if (pos('FATAL', s) = 1) then
      Timer1.Enabled := false;
  end;
end;

end.
