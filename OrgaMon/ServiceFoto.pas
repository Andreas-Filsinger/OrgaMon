{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2012 - 2019  Andreas Filsinger
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
  memcache, Foto,

  Funktionen_App;

type
  TownFotoExec = class(TOrgaMonApp)
    procedure FotoLog(s: string); override;
  end;

type
  TFormServiceFoto = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ListBox1: TListBox;
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
    TabSheet6: TTabSheet;
    Button8: TButton;
    Button9: TButton;
    ListBox7: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Edit1: TEdit;
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
    TabSheet11: TTabSheet;
    Button24: TButton;
    Button25: TButton;
    Label14: TLabel;
    Edit_Rollback_Baustelle: TEdit;
    Button26: TButton;
    Button27: TButton;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    Button29: TButton;
    Button6: TButton;
    Button31: TButton;
    CheckBox1: TCheckBox;
    Button30: TButton;
    Rückstand: TTabSheet;
    Button10: TButton;
    Memo1: TMemo;
    Label7: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    SpeedButton4: TSpeedButton;
    Edit15: TEdit;
    Button17: TButton;
    ComboBox1: TComboBox;
    Panel1: TPanel;
    Button22: TButton;
    Button1: TButton;
    CheckBox2: TCheckBox;
    Label19: TLabel;
    TabSheet7: TTabSheet;
    Edit14: TEdit;
    Label20: TLabel;
    Button23: TButton;
    Label21: TLabel;
    Button32: TButton;
    ListBox8: TListBox;
    Label22: TLabel;
    Label23: TLabel;
    Memo2: TMemo;
    Sicherungsverzeichnisse: TLabel;
    Button33: TButton;
    Button34: TButton;
    Edit16: TEdit;
    Label24: TLabel;
    Label25: TLabel;
    Edit17: TEdit;
    Edit18: TEdit;
    Label26: TLabel;
    ListBox13: TListBox;
    Label27: TLabel;
    Edit19: TEdit;
    Label28: TLabel;
    Edit20: TEdit;
    ProgressBar2: TProgressBar;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Button35: TButton;
    Label32: TLabel;
    Edit21: TEdit;
    Button36: TButton;
    Button37: TButton;
    CheckBox6: TCheckBox;
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
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
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
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure ListBox5Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button29Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button31Click(Sender: TObject);
    procedure Button30Click(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button32Click(Sender: TObject);
    procedure Button33Click(Sender: TObject);
    procedure Button34Click(Sender: TObject);
    procedure Button35Click(Sender: TObject);
    procedure Button36Click(Sender: TObject);
    procedure Button37Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TabSheet6Show(Sender: TObject);
  private
    { Private-Deklarationen }
    TimerWartend: integer;
    TimerInit: integer;
    TimerRunning: boolean;
    sMoveTransaktionen: TStringList;
    sLog: TStringList;
    GUIInitialized: boolean;

  public
    { Public-Deklarationen }
    MyFotoExec: TownFotoExec;

    procedure LoadPic;
    procedure doRemote(GeraeteNo, Command, FName: string);
    procedure RefreshFotoPath;
    procedure refreshPanel;

  end;

var
  FormServiceFoto: TFormServiceFoto;

implementation

uses
  SimplePassword, binlager32, anfix32, c7zip,
  globals, IniFiles,
  math, CCR.Exif, wanfix32,
  dbOrgaMon;

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
  BeginHourGlass;
  MyFotoExec.workAusstehendeFotos;
  EndHourGlass;
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
  FileDelete(MyFotoExec.DataPath + '_AUFTRAG+TS' + cBL_FileExtension);
end;

procedure TFormServiceFoto.Button24Click(Sender: TObject);
begin
  openShell(MyFotoExec.DataPath + cFotoService_BaustelleFName);
end;

procedure TFormServiceFoto.Button25Click(Sender: TObject);
begin
  openShell(MyFotoExec.DataPath + cFotoTransaktionenFName);
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

  TRNs := TStringList.create;
  SrcKandidaten := TStringList.create;
  TRNs_Fail := TStringList.create;

  QuellPfad := Edit_Rollback_Quelle.Text;
  TransaktionenFName := Edit_RollBack_Transaktionen.Text;
  ListBox12.Clear;
  TRNs.LoadFromFile(TransaktionenFName);
  for n := 0 to pred(TRNs.Count) do
    if pos('cp ', TRNs[n]) = 1 then
    begin
      SrcFName := nextp(TRNs[n], ' ', 1);
      dir(QuellPfad + cLocation_MOB + TransaktionsCountMaske + SrcFName, SrcKandidaten, false, true);
      if (SrcKandidaten.Count = 0) then
      begin
        ListBox12.Items.Add('ERROR: ' + SrcFName + ' nicht in dieser Quelle');
        TRNs_Fail.Add(TRNs[n]);
      end
      else
      begin

        // Identische Rausreduzieren
        for m := pred(SrcKandidaten.Count) downto 1 do
        begin
          FotoSize := FSize(QuellPfad + cLocation_MOB + SrcKandidaten[pred(m)]);
          if
          { } (FotoSize > 0) and
          { } (FotoSize = FSize(QuellPfad + cLocation_MOB + SrcKandidaten[m])) then
            SrcKandidaten.Delete(m);
        end;

        if (SrcKandidaten.Count > 1) then
        begin
          // Mehrfache versionslieferungen eines Motives geht noch nicht!
          // imp pend!
          ListBox12.Items.Add('ERROR: ' + SrcFName + ' kommt mehrfach vor: ' + inttostr(SrcKandidaten.Count) + 'x');
          TRNs_Fail.Add(TRNs[n]);
        end
        else
        begin
          TransaktionsCount := nextp(SrcKandidaten[0], '-', 0);
          ListBox12.Items.Add(
            { } 'cp ' + QuellPfad + cLocation_MOB + TransaktionsCount + '-' + SrcFName + ' ' +
            { } MyFotoExec.pFTPPath + SrcFName);

          FileCopy(QuellPfad + cLocation_MOB + TransaktionsCount + '-' + SrcFName, MyFotoExec.pFTPPath + SrcFName);
        end;
      end;
      Application.ProcessMessages;
    end;
  TRNs_Fail.savetoFile(TransaktionenFName + '.fail.txt');

  TRNs.Free;
  SrcKandidaten.Free;
  TRNs_Fail.Free;

end;

procedure TFormServiceFoto.Button22Click(Sender: TObject);
begin
  if assigned(MyFotoExec) then
    with MyFotoExec do
      Pause(true, Pause);
  refreshPanel;
end;


const
  _Wiederholen_BETRACHTUNGS_ZEITRAUM = 100; // [Tage]


var
 _Wiederholen_sFOTOS : TsTable = nil;
 _Wiederholen_sFOUND: TsTable = nil;
 _Wiederholen_Log: TStringList = nil;


procedure TFormServiceFoto.Button23Click(Sender: TObject);
var
 n,r,i : integer;
 LieferMoment_First: TDateTime;
 sLieferMoment, sLieferMoment_First: String;
 SrcFname, sRID : string;
 col_RID: integer;
 CheckList: TStringList;
 OneFound: TStringList;
begin

 BeginHourGlass;

 // Lade die Suchanfrage
 if not(assigned(_Wiederholen_sFOTOS)) then
 begin
  _Wiederholen_sFOTOS := TsTable.Create;
 end;

 with _Wiederholen_sFOTOS do
 begin
   insertfromFile(edit14.Text);
   col_RID := colof(cRID_Suchspalte);
   label21.Caption := IntToStr(RowCount)+' Anfragen';
   application.ProcessMessages;

   CheckList :=  TStringList.create;
   for r := 1 to RowCount do
   begin
     sRID := readCell (r,col_RID);
     if CheckList.IndexOf( sRID)=-1 then
       CheckList.add(sRID);
   end;
   label22.Caption := IntToStr(CheckList.count)+ ' Anfragen (um Doppelte reduziert)';
   application.ProcessMessages;

 end;

 // Lade die Transaktionstabelle
 if not(assigned(_Wiederholen_Log)) then
  _Wiederholen_Log := TStringList.create;
 _Wiederholen_Log.LoadFromFile(DiagnosePath + cFotoTransaktionenFName);

 // Suche RIDs und deren Ziel und Datum
 LieferMoment_First := now - _Wiederholen_BETRACHTUNGS_ZEITRAUM;
 sLieferMoment_First := dTimeStamp(LieferMoment_First);

 _Wiederholen_sFOUND := TsTable.Create;
 with _Wiederholen_sFOUND do
 begin
   addcol(cRID_Suchspalte);
   addcol('DateiName');
 end;

 with _Wiederholen_Log do
    for n := pred(Count) downto 0 do
    begin

      if (pos('cp ', strings[n]) = 1) then
      begin
       SrcFName := nextp(strings[n], ' ', 1);
       sRID := ExtractSegmentBetween(SrcFname,'-','-');
       if (length(sRid)>0) then
       begin
        r := _Wiederholen_sFOTOS.locate(col_RID,sRID);
        if (r<>-1) then
        begin
         i := CheckList.IndexOf(sRID);
         if (i<>-1) then
          CheckList.Delete(i);

         OneFound:= TStringList.create;
         OneFound.Add(sRID);
         OneFound.Add(SrcFname);
         _Wiederholen_sFOUND.addRow(OneFound);

         ListBox8.Items.Add(SrcFName);
         application.ProcessMessages;
        end;
       end;
       continue;
      end;

      if (pos('timestamp ', strings[n]) = 1) then
      begin
        sLieferMoment := copy(strings[n], 11, MaxInt);
        if (sLieferMoment < sLieferMoment_First) then
        begin
          ListBox8.Items.Add('-- Finish Line '+InttoStr(n));
          break;
        end;
        continue;
      end;

    end;
  _Wiederholen_sFOUND.SaveToFile(ExtractFilePath(edit14.Text)+'Fotos-Found.csv');
  label23.Caption := IntToStr(CheckList.Count)+ ' nicht gefunden';
  if assigned(CheckList) then
  begin
   CheckList.SaveToFile(ExtractFilePath(edit14.Text)+'Fotos-not-Found.csv');
   CheckList.Free;
  end;

  EndHourGlass;

end;

procedure TFormServiceFoto.Button32Click(Sender: TObject);
var
 l, r, n: integer;
 sDIR : TStringList;
 SrcFname: string;
 AnzEintragungen: integer;
 cCol_Pfad: integer;
begin
 // Die Kandidaten in den Sicherungen suchen!
 if not(assigned(_Wiederholen_sFOUND)) then
   _Wiederholen_sFOUND := TsTable.Create;

   AnzEintragungen := 0;
 with _Wiederholen_sFOUND do
 begin

  if (RowCount<1) then
   insertFromFile(ExtractFilePath(edit14.Text)+'Fotos-Found.csv');
  cCol_Pfad := addCol('Pfad');

  sDIR := TStringList.Create;
  for l := 0 to pred(Memo2.Lines.Count) do
  begin

    if (pos('--',Memo2.Lines[l])=1) then
     continue;
    if (pos('#',Memo2.Lines[l])=0) then
     continue;
    dir(Memo2.Lines[l]+'*.jpg',sDIR,false);

    for n := 0 to pred(sDIR.Count) do
    begin
      if (pos('-',sDIR[n])=0) then
       continue;
      SrcFName := copy(sDIR[n],7,MaxInt);
      r := locate(1,SrcFName);
      if (r<>-1) then
      begin
        writeCell(r,cCol_Pfad,Memo2.Lines[l]+sDIR[n]);
        inc(AnzEintragungen);
      end;
    end;

  end;
  if changed then
   SaveToFile(ExtractFilePath(edit14.Text)+'Fotos-Found.csv');
  Label29.Caption := IntToStr(RowCount)+' Fotos insgesamt';
  Label30.Caption := IntToStr(AnzEintragungen)+' eben gefunden';

  AnzEintragungen := 0;
  for r := 1 to RowCount do
   if (readCell(r,cCol_Pfad)<>'') then
    inc(AnzEintragungen);
  Label31.Caption := IntToStr(RowCount-AnzEintragungen)+' fehlen noch';
 end;
end;

procedure TFormServiceFoto.Button33Click(Sender: TObject);
var
 r: integer;
 srcFname,dstFName: string;
begin
 if not(assigned(_Wiederholen_sFOUND)) then
   _Wiederholen_sFOUND := TsTable.Create;
 with _Wiederholen_sFOUND do
 begin
  if (RowCount<1) then
   insertFromFile(ExtractFilePath(edit14.Text)+'Fotos-Found.csv');
  for r := 1 to RowCount do
  begin
   srcFname := readCell(r,'Pfad');
   if (srcFname<>'') then
   begin
    dstFname := readCell(r,1);
    FileCopy(
     {} srcFname,
     {} MyFotoExec.pFTPPath + dstFName );
   end;
  end;
 end;
end;

procedure TFormServiceFoto.Button34Click(Sender: TObject);
var
 sDir: TStringList;
 zDir: TStringList;
 rDir: TStringList;
 n,m: integer;
 FName: string;
 sDate, rDate: TANFixDate;
begin
BeginHourGlass;
 CheckCreateDir(edit19.Text);
 zDir := TStringList.Create;
 sDir := TStringList.Create;
 rDir := TStringList.Create;
 sDate := Date2Long(edit18.Text);


 dir(edit16.Text+'*.',sDir,false);
 for n := 0 to pred(sDir.Count) do
 begin
   if pos('.',sDir[n])=1 then
    continue;
   dir(
    {} edit16.Text+sDir[n]+'\'+
    {} edit17.Text+'\'+
    {} 'Fotos-*.zip',zDir,false,true);
   for m := 0 to pred(zDir.Count) do
   begin
    FName :=
      {} edit16.Text +
      {} sDir[n]+'\'+
      {} edit17.Text+'\'+
      {} zDir[m];

    if (FDate(Fname)>=sDate) then
     rDir.Add(FName);

     listbox13.Items.Add(zDir[m]);
   end;
 end;

 rDir.Sort;
 Progressbar2.Max := rDir.Count;
 for n := 0 to pred(rDir.Count) do
 begin
  Progressbar2.Position := n;
  unzip(rDir[n],edit19.Text,Split(czip_set_Password+'='+edit20.Text));
  Application.ProcessMessages;
 end;
 Progressbar2.Position := 0;

 rDir.Free;
 sDir.Free;
 zDir.Free;
 EndHourGlass;
end;

procedure TFormServiceFoto.Button35Click(Sender: TObject);
const
 cPOS_MINUS = 6;
var
 sDir,sRow : TStringList;
 FILENAMES : TsTable;
 LASTNAME: string;
 n,k,r : integer;
begin

 FILENAMES := TSTable.create;
 with FILENAMES do
 begin
  addCol('FULLNAME');
  addCol('ORIGINALNAME');
 end;

 sDir := TStringList.Create;
 dir (edit6.Text+'*.jpg',sDir,false,false);
 for n := 0 to pred(sDir.Count) do
 begin
  k := pos('-',sDir[n]);
  if (k=cPOS_MINUS) then
  begin
    sRow := TStringList.Create;
    sRow.Add(sDir[n]);
    sRow.Add(copy(sDir[n],succ(cPOS_MINUS),MaxInt));
    FILENAMES.addRow(sRow);
  end;
 end;

 sDir.clear;
 with FILENAMES do
 begin
  SortBy('ORIGINALNAME');
  SaveToFile(DiagnosePath+'FILENAMES.csv');
  LASTNAME := '';
  for r := 1 to RowCount do
  begin
    if (readCell(r,1)=LASTNAME) then
     if not(DeleteFile(edit6.Text+readCell(r,0))) then
      sDir.Add('rm ' + readCell(r,0));
    LASTNAME := readCell(r,1);
  end;
 end;

 sDir.SaveToFile(DiagnosePath+'rm.sh');

 FILENAMES.free;
 sDir.Free;
end;

procedure TFormServiceFoto.Button36Click(Sender: TObject);
var
  sParameter: TStringList;
begin
  sParameter := TStringList.create;
  // sParameter.add('ALL=' + cINI_Deactivate);
  MyFotoExec.workEingang_TXT(sParameter);
  sParameter.Free;
end;

procedure TFormServiceFoto.Button37Click(Sender: TObject);
var
 InternetAblage_SourcePath : string;
 SicherungsPath : string;
 AblageName : string;
 sAblagen: TStringList;
 sRechteSkript: TStringList;
 n,i: integer;
 sTAN : TSTringList;
 ZipOptions: TStringList;
begin

 // 1) Rechte Vorbereiten und virtueller Host löschen
 if false then
 begin
   InternetAblage_SourcePath := 'R:\Datensicherung\SEWA\JonDaServer\#185\Ablagen\';
   SicherungsPath := 'R:\Datensicherung\SEWA\JonDaServer\#185\';

   sAblagen := TStringList.Create;
   sAblagen.LoadFromFile(InternetAblage_SourcePath+'Ablagen.txt');

   sRechteSkript:= TStringList.Create;

   for n := 0 to pred(sAblagen.Count) do
   begin
    AblageName := noblank(nextp(sAblagen[n],' ',1));
    if (AblageName='') then
     continue;

    with sRechteSkript do
    begin
     add('chmod -R 777 /srv/www/htdocs/'+AblageName+'/*'  );
     add('chmod 777 /srv/www/htdocs/'+AblageName+'/.htpasswd');
     add('rm /etc/apache2/vhosts.d/'+ AblageName + '.conf');
    end;



   end;
   sRechteSkript.SaveToFile(InternetAblage_SourcePath+'ablagen.sh');
  end;

  // 2) Verschieben der Ablagen in die Sicherung:
  if false then
  begin
   InternetAblage_SourcePath := 'R:\Datensicherung\SEWA\JonDaServer\#185\Ablagen\';
   SicherungsPath := 'R:\Datensicherung\SEWA\JonDaServer\#185\';

   sAblagen := TStringList.Create;
   sAblagen.LoadFromFile(InternetAblage_SourcePath+'Ablagen-2.txt');

   for n := 0 to pred(sAblagen.Count) do
   begin
    AblageName := noblank(nextp(sAblagen[n],' ',1));
    if (AblageName='') then
     continue;

    if
    MoveFileEx(
      { Source-Path } pChar('W:\'+AblageName),
      { Dest-Path } pChar('W:\SEWA\'+AblageName),
      { } MOVEFILE_COPY_ALLOWED + MOVEFILE_WRITE_THROUGH) then
     listbox10.Items.Add(AblageName)
     else
     listbox10.Items.Add('ERROR:'+AblageName);

    application.ProcessMessages;
   end;
  end;

  // 3) ZIP der TAN-Verzeichnisse
  if false then
  begin
    ZipOptions:= TStringList.create;

    InternetAblage_SourcePath := 'R:\Datensicherung\SEWA\JonDaServer\#184\TAN\';
    sTAN := dirs(InternetAblage_SourcePath);
    for n := 0 to pred(sTAN.count) do
    begin
     ZipOptions.values[czip_set_RootPath] := InternetAblage_SourcePath+sTAN[n]+'\';
     i := zip(nil,InternetAblage_SourcePath+sTAN[n]+'.zip',ZipOptions);

     listbox10.Items.Add(sTAN[n]+':'+IntTOstr(i));
      application.ProcessMessages;

    end;
  end;

end;

procedure TFormServiceFoto.Button26Click(Sender: TObject);
var
  tREFERENZ: TsTable;
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

    ListBox12.Items.Add(QuellPfad + FName + ' -> ' + MyFotoExec.pFTPPath + DestFName);

    // Nur wirklich was machen, wenn gewollt
    if CheckBox1.Checked then
      FileCopy(QuellPfad + FName, MyFotoExec.pFTPPath + DestFName);
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

  QuellPfad := Edit_Rollback_Quelle.Text;

  SrcKandidaten := TStringList.create;
  tREFERENZ := TsTable.create;
  with tREFERENZ do
  begin
    insertfromFile(MyFotoExec.DataPath + Edit_Rollback_Baustelle.Text + '\' + cE_FotoBenennung + '.csv');
    Column_RID := colof(cRID_Suchspalte, true);
    for r := 1 to RowCount do
    begin
      sRID := readCell(r, Column_RID);
      dir(QuellPfad + '*-' + sRID + '*.jpg', SrcKandidaten, false, true);

      if (SrcKandidaten.Count > 0) then
      begin

        // Identische rausreduzieren
        n := 0;
        repeat
          FotoSize := FSize(QuellPfad + SrcKandidaten[n]);
          if (FotoSize > 0) then
            for m := pred(SrcKandidaten.Count) downto n + 1 do
            begin
              if (FotoSize = FSize(QuellPfad + SrcKandidaten[m])) then
                SrcKandidaten.Delete(m);
            end;
          inc(n);
        until (n >= pred(SrcKandidaten.Count));

        for c := 0 to pred(SrcKandidaten.Count) do
        begin
          ListBox12.Items.Add(SrcKandidaten[c]);
          xmove(SrcKandidaten[c]);
        end;
      end
      else
      begin
        ListBox12.Items.Add('ERROR: ' + sRID + ' nichts gefunden!');
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
  with ListBox5 do
    if (ItemIndex <> -1) then
    begin
      FName := Items[ListBox5.ItemIndex];
      FNameRemote := nextp(FName, '+', 1);
      AmnestiePath := MyFotoExec.BackupDir + 'Amnestie\';
      CheckCreateDIr(AmnestiePath);
      FileMove(
        { } MyFotoExec.pWebPath + FName,
        { } AmnestiePath + Edit10.Text + FNameRemote);

      // delete one Line
      n := ItemIndex;
      Items.Delete(n);
      Label10.Caption := inttostr(Count);
      if (Count > 0) then
      begin
        ItemIndex := min(n, pred(Count));
        SetFocus;
        OnClick(Sender);
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
  for n := 0 to pred(ListBox5.Items.Count) do
  begin
    FName := ListBox5.Items[n];
    FNameRemote := nextp(FName, '+', 1);
    GeraeteNo := nextp(FNameRemote, '-', 0);
    doRemote(GeraeteNo, 'mv', FNameRemote);
    // DeleteFile(MobUploadPath+cSubDirUnverarbeitet+'\'+ListBox5.Items[n]);
  end;
end;

procedure TFormServiceFoto.Button30Click(Sender: TObject);
var
  i: integer;
begin
  with ListBox3 do
    for i := 0 to pred(Items.Count) do
    begin
      ItemIndex := i;
      Application.ProcessMessages;
      FotoTouch(Edit4.Text + Items[i]);
    end;
end;

procedure TFormServiceFoto.Button31Click(Sender: TObject);
var
  Trn: TStringList;

  function rDaSiName(sSource: string): string;
  var
    m: integer;
    sDeliveryName: string;
    _sSource: string;
    sDir: TStringList;
  begin
    result := '';
    sDir := TStringList.create;
    for m := 0 to pred(Trn.Count) do
    begin
      if pos(sSource, Trn[m]) > 0 then
      begin
        _sSource := nextp(Trn[m], ' ', 2);
        if (sSource <> _sSource) then
          continue;
        sDeliveryName := nextp(Trn[m], ' ', 1);
        dir(MyFotoExec.BackupDir + cFotoService_FTPBackupSubPath + '*' + sDeliveryName, sDir, false, true);
        if (sDir.Count < 1) then
          raise Exception.create('Datei ' + sDeliveryName + ' nicht im Backup');
        sDir.sort;
        result := MyFotoExec.BackupDir + cFotoService_FTPBackupSubPath + sDir[pred(sDir.Count)];
        break;
      end;
    end;
    sDir.Free;
  end;

var
  l, sCommand, sSource, sDest: string;
  newSource, newDest: string;
  n: integer;
  sLog: TStringList;

begin
  ListBox12.Items.Clear;
  //
  Trn := TStringList.create;
  sLog := TStringList.create;
  sLog.Add('PFAD;BISHER;NEU');
  Trn.LoadFromFile(DiagnosePath + cFotoTransaktionenFName);
  for n := 0 to pred(Trn.Count) do
  begin
    l := Trn[n];

    sCommand := nextp(l, ' ');
    if (sCommand <> 'mv') then
      continue;

    sSource := nextp(l, ' ');
    if pos('-Neu', sSource) = 0 then
      continue;

    sDest := nextp(l, ' ');
    if (pos('-N', sDest) = 0) and (pos('\N', sDest) = 0) then
      continue;

    ListBox12.Items.Add(Trn[n]);

    //
    newSource := rDaSiName(sSource);
    newDest := sDest;
    ersetze('-N', '-', newDest);
    ersetze('\N', '\', newDest);

    ListBox12.Items.Add('cp ' + newSource + ' ' + newDest);

    if CheckBox1.Checked then
    begin

      //
      if not(FileCopy(newSource, newDest)) then
        raise Exception.create('cp ' + newSource + ' ' + newDest + ' failed');

      sLog.Add(
        { } ExtractFilePath(sDest) + ';' +
        { } ExtractFileName(sDest) + ';' +
        { } ExtractFileName(newDest));

      TOrgaMonApp.Foto_setcorrectDateTime(newDest);
    end;

    Application.ProcessMessages;

  end;
  sLog.savetoFile(DiagnosePath + 'N-Bug-' + FindANewPassword + '.csv');
  sLog.Free;
  Trn.Free;

end;


procedure TFormServiceFoto.Button3Click(Sender: TObject);

  procedure doWork(n: integer);
  var
    FName, FNameRemote: string;
  begin
    FName := ListBox5.Items[n];
    repeat

      if (pos('+',FName)>0) then
      begin
       FNameRemote := nextp(FName, '+', 1);
       break;
      end;

      FNameRemote := copy(FName,succ(pos('-',FName)),MaxInt);

    until yet;
    FileMove(
      { } MyFotoExec.pWebPath + FName,
      { } MyFotoExec.pFTPPath + FNameRemote);
  end;

var
  n: integer;

begin
  if (ListBox5.ItemIndex <> -1) then
  begin
    doWork(ListBox5.ItemIndex);
    ListBox5.Items.Delete(ListBox5.ItemIndex);
    Label10.Caption := inttostr(ListBox5.Count);
  end
  else
  begin
    for n := 0 to pred(ListBox5.Items.Count) do
      doWork(n);
    ListBox5.Items.Clear;
  end;
end;

procedure TFormServiceFoto.Button12Click(Sender: TObject);
begin
  BeginHourGlass;
  ListBox5.ItemIndex := -1;
  Button3Click(Sender);
  EndHourGlass;
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
    sDir := TStringList.create;
    dir(pPath_html + '*.zip.html', sDir, false);
    if (sDir.Count > 0) then
    begin
      ProgressBar1.Max := pred(sDir.Count);
      ProgressBar1.Position := 0;
      for n := 0 to pred(sDir.Count) do
      begin
        if CheckBox4.Checked then
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
  MyFotoExec.workSync;
end;

procedure TFormServiceFoto.Button17Click(Sender: TObject);
begin
  BeginHourGlass;

  if (MyFotoExec = nil) then
    MyFotoExec := TownFotoExec.create;

  MyProgramPath := Edit15.Text;
  with MyFotoExec do
  begin
   readIni(ComboBox1.Text, Edit15.Text);

   // IMEI-Tabelle laden
   tIMEI.oSalt := ComboBox1.Text;
   tIMEI.insertfromHash(MyProgramPath + cDBPath , cLICENCE_FName);

   ensureGlobals;
  end;
  // Pfade übernehmen
  Edit_Rollback_Quelle.Text := MyFotoExec.BackupDir + cFotoService_FTPBackupSubPath;

  //
  refreshPanel;

  EndHourGlass;
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
  AllTRN := TStringList.create;

  dir(Edit9.Text + '?????.', AllTRN, false);
  AllTRN.sort;
  ListBox11.Items.Add('search in ' + inttostr(AllTRN.Count) + ' subdirs ...');
  for n := pred(AllTRN.Count) downto 0 do
  begin
    repeat
      if FileExists(Edit9.Text + AllTRN[n] + '\AUFTRAG+TS.BLA') then
      begin
        AuftragFound := false;
        bOrgaMon := TBLager.create;
        with bOrgaMon do
        begin
          ListBox11.Items.Add('check ' + AllTRN[n] + ' ...');
          Init(Edit9.Text + AllTRN[n] + '\AUFTRAG+TS', mderecOrgaMon, sizeof(TMDERec));
          BeginTransaction(now);
          if exist(AUFTRAG_R) then
          begin
            get;
            ListBox11.Items.Add(mderecOrgaMon.Baustelle + '-' + mderecOrgaMon.ABNummer + ' ' +
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
        if CheckBox5.Checked then
          break;
      end;

    until true;
  end;
  ListBox11.Items.Add('search done!');
  AllTRN.Free;
end;

procedure TFormServiceFoto.Button19Click(Sender: TObject);
var
  Trn: string;
begin
  BeginHourGlass;
  Label11.Caption := '';
  if (ListBox11.ItemIndex = -1) then
  begin
    Label11.Caption := 'ERROR: Es ist nichts markiert';
    exit;
  end;
  Trn := StrFilter(ListBox11.Items[ListBox11.ItemIndex], cZiffern);
  if (length(Trn) <> 5) then
  begin
    Label11.Caption := 'ERROR: Markierte Zeile enthält keine TRN';
    exit;
  end;
  if FileCopy(
    { } Edit9.Text + Trn + '\' + 'AUFTRAG+TS' + cBL_FileExtension,
    { } MyFotoExec.DataPath + '_AUFTRAG+TS' + cBL_FileExtension) then
    Label11.Caption := 'OK';
  EndHourGlass;
end;

procedure TFormServiceFoto.Button4Click(Sender: TObject);
var
  sParameter: TStringList;
begin
  sParameter := TStringList.create;
  // sParameter.add('ALL=' + cINI_Deactivate);
  MyFotoExec.workWartend(sParameter);
  sParameter.Free;
end;

procedure TFormServiceFoto.Button5Click(Sender: TObject);
var
  sParameter: TStringList;
begin
  sParameter := TStringList.create;
  if CheckBox6.Checked then
   sParameter.add('ALL=' + cINI_Deactivate);
  MyFotoExec.workEingang_JPG(sParameter);
  sParameter.Free;
end;

procedure TFormServiceFoto.Button6Click(Sender: TObject);
var
  BackupSizeByNow: double;
begin
  MyFotoExec.ensureGlobals;
  BackupSizeByNow := MyFotoExec.doBackup;
  MyFotoExec.Log(format(' %s hat %.3f GB', [MyFotoExec.BackupDir, BackupSizeByNow / 1024.0 / 1024.0 /
    1024.0]));
end;

procedure TFormServiceFoto.Button8Click(Sender: TObject);
var
  sParameter: TStringList;
begin
  BeginHourGlass;
  sParameter := TStringList.create;
  sParameter.Add('DATUM=' + Edit3.Text);
  sParameter.Add('EINZELN=' + Edit2.Text);
  MyFotoExec.workAblage(sParameter);
  Edit2.Text := '';
  sParameter.Free;
  EndHourGlass;
end;

procedure TFormServiceFoto.Button9Click(Sender: TObject);
var
  WARTEND: TsTable;
  AUFTRAG_R: integer;
  r: integer;
  i: integer;
  Original_FName, Aktueller_FName: string;
begin
  Button9.Enabled := false;
  BeginHourGlass;
  i := MaxInt;
  WARTEND := TsTable.create;
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
      insertfromFile(MyFotoExec.DataPath + cFotoService_UmbenennungAusstehendFName);
      r := locate('RID', inttostr(AUFTRAG_R));
      if (r = -1) then
        break;

      if CheckBox2.Checked then
      begin
        Original_FName := MyFotoExec.pFTPPath + readCell(r, 'DATEINAME_ORIGINAL');
        Aktueller_FName := readCell(r, 'DATEINAME_AKTUELL');
        FileMove(Aktueller_FName, Original_FName);
      end;

      Del(r);
      savetoFile(MyFotoExec.DataPath + cFotoService_UmbenennungAusstehendFName);
    end;

  until true;
  WARTEND.Free;
  // Refresh
  SpeedButton3Click(Sender);

  // set Focus
  if i < ListBox6.Items.Count then
    ListBox6.ItemIndex := i;
  EndHourGlass;
  Button9.Enabled := true;
end;

procedure TFormServiceFoto.ComboBox1Select(Sender: TObject);
begin
  RefreshFotoPath;
end;

procedure TFormServiceFoto.doRemote(GeraeteNo, Command, FName: string);
const
  cRemoteFotoPath = '/mnt/sdcard/DCIM/Camera/';
var
  sKommandos: TStringList;
  KommandoFName: String;
begin
  sKommandos := TStringList.create;

  KommandoFName := MyFotoExec.DataPath + cGeraeteKommandos + GeraeteNo + '.ini';
  if FileExists(KommandoFName) then
    sKommandos.LoadFromFile(KommandoFName);

  // mv
  if (Command = 'mv') then
    sKommandos.Add(
      { } Command + ' ' +
      { } cRemoteFotoPath + 'u' +
      { } FName + ' ' +
      { } cRemoteFotoPath +
      { } FName);

  // rm
  if (Command = 'rm') then
    sKommandos.Add(
      { } Command + ' ' +
      { } cRemoteFotoPath + 'u' +
      { } FName);

  sKommandos.savetoFile(KommandoFName, TEncoding.UTF8);
  sKommandos.Free;

end;

procedure TFormServiceFoto.FormActivate(Sender: TObject);
begin
 if not(GUIInitialized) then
 begin
   PageControl1.ActivePage := TabSheet1;
   GUIInitialized := true;
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
    for n := 0 to pred(sMoveTransaktionen.Count) do
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
    Path := Edit21.Text;
    if Path <> '' then
      Path := Path + '\'
     else
      ShowMessage('Bitte eine Ablage angeben!');

    FindStr :=
    { Delimiter } '\' +
    { Verzeichnis } Path +
    { Dateiname } ListBox3.Items[_ItemIndex];

    for n := pred(sMoveTransaktionen.Count) downto 0 do
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
    for n := 0 to pred(sMoveTransaktionen.Count) do
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
    for n := 0 to pred(sMoveTransaktionen.Count) do
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
              { Dateiname } MyFotoExec.DataPath + cFotoService_UmbenennungAusstehendFName);

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
    if (ListBox3.Items.Count > 0) then
    begin
      ListBox3.ItemIndex := min(_ItemIndex, ListBox3.Items.Count - 1);
      LoadPic;
    end;
  end;

end;

procedure TFormServiceFoto.ListBox5Click(Sender: TObject);
var
  n: integer;
  FName: string;
  RID: string;
  m: integer;
begin

  if not(assigned(sLog)) then
  begin
    sLog := TStringList.create;
    sLog.LoadFromFile(DiagnosePath + 'FotoService.log.txt');
  end;

  FName := nextp(ListBox5.Items[ListBox5.ItemIndex], '+', 1);
  Edit11.Text := nextp(FName, '-', 1);
  RID := '';
  for n := pred(sLog.Count) downto 0 do
    if (pos(FName, sLog[n]) > 0) then
    begin
      RID := nextp(sLog[n], ';', 1);
      break;
    end;

  Memo1.Lines.Clear;
  if (RID <> '') then
  begin
    for m := Max(0, n - 5) to min(n + 5, pred(sLog.Count)) do
      if pos(RID, sLog[m]) > 0 then
        Memo1.Lines.Add(sLog[m]);
  end
  else
  begin
    Memo1.Lines.Add('Zu ' + FName + ' gibt es keine erweiterten Fehler-Infos');
  end;

end;

procedure TFormServiceFoto.LoadPic;
begin
  Image1.Picture.LoadFromFile(Edit4.Text + ListBox3.Items[ListBox3.ItemIndex]);
end;

procedure TFormServiceFoto.RefreshFotoPath;
var
  MyIni: TIniFile;
begin
  MyIni := TIniFile.create(EigeneOrgaMonDateienPfad + cIniFName);
  Edit15.Text := MyIni.ReadString(ComboBox1.Text, cDataBaseName, MyProgramPath);
  MyIni.Free;
end;

procedure TFormServiceFoto.refreshPanel;
begin
  with Panel1 do
  begin
    if assigned(MyFotoExec) then
    begin
      Caption := MyFotoExec.MandantId;
      if MyFotoExec.Pause then
      begin
        color := clred;
        Button22.Caption := Button22.Hint[2];
      end
      else
      begin
        color := cllime;
        Button22.Caption := Button22.Hint[1];
      end;
    end
    else
    begin
      Caption := '';
      color := clWindow;
    end;
  end;
end;

procedure TFormServiceFoto.SpeedButton1Click(Sender: TObject);
var
  sDir: TStringList;
  n: integer;
begin

  // Bild-Tester
  sDir := TStringList.create;
  dir(Edit4.Text + '*.jpg', sDir, false);

  // Maske Reduce
  if (Edit5.Text <> '*') then
    for n := pred(sDir.Count) downto 0 do
      if pos(Edit5.Text, sDir[n]) = 0 then
        sDir.Delete(n);

  sDir.sort;
  ListBox3.Items.Assign(sDir);
  sDir.Free;

  if not(assigned(sMoveTransaktionen)) then
    sMoveTransaktionen := TStringList.create;
  sMoveTransaktionen.LoadFromFile(DiagnosePath + cFotoTransaktionenFName);
end;

procedure TFormServiceFoto.SpeedButton2Click(Sender: TObject);
var
  sDir: TStringList;
begin
  if assigned(sLog) then
    FreeAndNil(sLog);
  sDir := TStringList.create;
  dir(MyFotoExec.pWebPath + '*.jpg', sDir, false);
  Label10.Caption := inttostr(sDir.Count);
  ListBox5.Items.Assign(sDir);
  sDir.Free;
end;

procedure TFormServiceFoto.SpeedButton3Click(Sender: TObject);
var
  sWartend: TStringList;
begin
  sWartend := TStringList.create;
  sWartend.LoadFromFile(MyFotoExec.DataPath + cFotoService_UmbenennungAusstehendFName);
  ListBox6.Items.Assign(sWartend);
  Label19.Caption := INtToStr(pred(sWartend.Count));
  sWartend.Free;
end;

procedure TFormServiceFoto.SpeedButton4Click(Sender: TObject);
begin
  RefreshFotoPath;
end;

procedure TFormServiceFoto.SpeedButton8Click(Sender: TObject);
var
  sDir: TStringList;
begin
  sDir := TStringList.create;
  dir(MyFotoExec.pFTPPath + '*.$$$', sDir, false);
  sDir.sort;
  ListBox2.Items.Assign(sDir);
  sDir.Free;

  sDir := TStringList.create;
  dir(MyFotoExec.pFTPPath + '*.jpg', sDir, false);
  sDir.sort;
  ListBox7.Items.Assign(sDir);
  sDir.Free;

end;

procedure TFormServiceFoto.TabSheet1Show(Sender: TObject);
var
  sl: TStringList;
  n: integer;
  Id: string;
begin
  sl := TStringList.create;
  sl.LoadFromFile(EigeneOrgaMonDateienPfad + cIniFName);
  for n := 0 to pred(sl.Count) do
    if (pos('[', sl[n]) = 1) then
      if (revpos(']', sl[n]) = length(sl[n])) then
      begin
        Id := ExtractSegmentBetween(sl[n], '[', ']');
        if (Id <> cGroup_Id_Default) then
          ComboBox1.Items.Add(Id);
      end;
  sl.Free;

end;

procedure TFormServiceFoto.TabSheet6Show(Sender: TObject);
begin
 if assigned(MyFotoExec) then
  with MyFotoExec do
  if Initialized then
  begin
    Listbox10.items.add('INFO: Backups goes to '+BackupDir);
    Listbox10.items.add('INFO: next Backup will be '+nextBackupDir);
  end;
end;

procedure TFormServiceFoto.TabSheet9Show(Sender: TObject);
begin
  if (Edit9.Text = '') then
    Edit9.Text := MyFotoExec.pAppServicePath;
end;

procedure TFormServiceFoto.Timer1Timer(Sender: TObject);
begin

  if (TimerInit < cKikstart_delay * 60 * 1000) then
  begin
    if (TimerInit = 0) then
      MyFotoExec.Log('Warte ' + inttostr(cKikstart_delay) + ' Minuten ...');
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
        MyFotoExec.workAusstehendeFotos;

        // Zwischen 00:00 und ]01:00
        if (SecondsGet < (1 * 3600)) then
          // nur machen, wenn nicht in Arbeit oder fertig
          if not(FileExists(MyFotoExec.AblageLogFname)) then
            // Zips verschieben, Fotos zippen
            MyFotoExec.workAblage;

      end;

      // Jedes Mal
      MyFotoExec.workEingang_JPG;
      MyFotoExec.workEingang_TXT;

    except

    end;
    inc(TimerWartend, Timer1.Interval);

    TimerRunning := false;
  end;

end;

{ TownFotoExec }

procedure TownFotoExec.FotoLog(s: string);
begin
  with FormServiceFoto do
  begin
    ListBox1.Items.Add(s);
    if (pos('ERROR', s) > 0) then
      AppendStringsToFile(s, DiagnosePath + 'FotoService.log.txt');
    if (pos('FATAL', s) = 1) then
      Timer1.Enabled := false;
  end;
end;

end.
