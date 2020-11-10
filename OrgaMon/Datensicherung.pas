{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2020  Andreas Filsinger
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
unit Datensicherung;
{$IFDEF CONSOLE}
{$MESSAGE FATAL 'Prüfe Abhängigkeit: Diese Unit hat GUI'}
{$ENDIF}

//
// 11'2003: Approoved Backup
// 12'2003: Restore im DatenbankBackupBereich
// 05'2004: if Diagnostic is checked <-> DONT PROOVE!
//
//
// unified Backup (alle Projekte)
//
// a) Read Generators
// b) Backup
// c) Restore
// d) connect and read Generators
// e) Compare Generators !PROOF!
// f) delete recently restored DataBase
// g) move and compress the Backup File
//
//
// Generation Switch
//
// a) shut down Database
// b) "small" unified Backup
// c) online Database
//
// todo
// ====
//
// * fbak-Komprimierung aus eigener Kraft mit dem zip Algorithmus mit dem SysDBA Passwort
// * backup/restore/set prductiv (im Prinzip ein Reorg/Generationswechsel) per Knopfdruck
// mit Modifikation der OrgaMon.ini
// * Innosetup Integration: Das "grosse" Backup könnte eine Setup-Routine sein:
// mit dem letzen Backup in der ".\Datensicherung"
// der Restore sollte automatisch nach einem Setup erfolgen
// in das Setup sollten die Punkte
// * mixed up Umgebung: die Datenbank sichern! Jedoch mit dem lokalen firebird den
// restore und die Prüfung machen!
//
// [x] lokales Anwendungs-Update
// [x] Datenbank-Client Installation
// [x] Netzwerk Verzeichnis erstellen
// (*) Remote Datenbank-Restore
// ( ) Lokaler Datenbank-Restore
//
interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls, Buttons,

  // IBObjects
  IB_Components, IBOServices,

  // Crypt
  DCPcrypt2, DCPblockciphers, DCPdes;

type
  TFormDatensicherung = class(TForm)
    DCP_des1: TDCP_des;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Button1: TButton;
    Memo1: TMemo;
    CheckBox1: TCheckBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Button2: TButton;
    ListBox1: TListBox;
    SpeedButton8: TSpeedButton;
    Button3: TButton;
    ProgressBar1: TProgressBar;
    Image2: TImage;
    SpeedButton2: TSpeedButton;
    Edit1: TEdit;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ListBox2: TListBox;
    TabSheet4: TTabSheet;
    Button4: TButton;
    ListBox3: TListBox;
    Button5: TButton;
    CheckBox5: TCheckBox;
    TabSheet5: TTabSheet;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    ListBox4: TListBox;
    Button6: TButton;
    Edit2: TEdit;
    Button7: TButton;
    IBOBackupService1: TIBOBackupService;
    IBORestoreService1: TIBORestoreService;
    IBOServerProperties1: TIBOServerProperties;
    TabSheet6: TTabSheet;
    ListBox5: TListBox;
    Edit3: TEdit;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Button9: TButton;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    Edit4: TEdit;
    Label1: TLabel;
    CheckBox13: TCheckBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label11: TLabel;
    Button8: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure TabSheet5Show(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure TabSheet6Show(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private-Deklarationen }
    Initialized: boolean;
    sLog: TStringList;
    StartTime: dword;

    procedure SetUpService(dbService: TIBOBackupRestoreService);
    procedure Log(s: string);
    procedure SaveLog;
  public
    { Public-Deklarationen }
    IBC: TIB_Connection;
    ErrorCount: Integer;

    function BackUp(BackupGID: Integer): boolean;
    function GENID: Integer;
    procedure Restore(BackupGID: Integer);
    procedure refreshCompressedDirView;
    procedure refresh_fbak_DirView;
    procedure refresh_MandantView;
    function doUpload(ResultFName: string): boolean;

    //
    function die400: TStringList;
    procedure zip400(sFiles: TStringList; DontDelete: boolean = false;
      TAN: Integer = 0);
    procedure do400(TAN: Integer);

  end;

var
  FormDatensicherung: TFormDatensicherung;

implementation

uses
  math,
  globals,

  // Anfix
  anfix32, splash, c7zip,
  SolidFTP, CareTakerClient, wanfix32,

  // Tools
  IB_Session,

  // OrgaMon-Core
  Datenbank,
  dbOrgaMon,
  Funktionen_Basis,
  Funktionen_LokaleDaten,

  // OrgaMon - UI
  Einstellungen,
  BaseUpdate;

{$R *.DFM}


function TFormDatensicherung.BackUp(BackupGID: Integer): boolean;
const
  cScript_List_Generators =
    'select RDB$GENERATOR_NAME from RDB$GENERATORS where (RDB$SYSTEM_FLAG=0) or (RDB$SYSTEM_FLAG is null)';
var
  fbak_Full_FName: string;
  fbak_FName: string;
  ResultFName: string;
  CommandLine: string;
  sGENERATORS: TStringList;

  cGENERATORS: TIB_Cursor;
  cINDEX: TIB_Cursor;
  rCONNECTION: TIB_Connection;
  rTRANSACTION: TIB_Transaction;
  GenName: string;
  GenValIst: int64;
  GenValSoll: int64;
  OneLine: string;
  ZipFileList: TStringList;

  procedure ReadGenerators;
  begin
    sGENERATORS := TStringList.create;

    try
      Log('###############################');
      Log('# G E N - E V A L U A T I O N #');
      Log('###############################');
      cGENERATORS := DataModuleDatenbank.nCursor;
      with cGENERATORS do
      begin
        sql.add(cScript_List_Generators);
        ApiFirst;
        while not(eof) do
        begin
          GenName := Fields[0].AsString;
          sGENERATORS.add(GenName + '=' + inttostr(GEN_ID(GenName, 0)));
          Log(sGENERATORS[pred(sGENERATORS.count)]);
          ApiNext;
        end;
      end;
      cGENERATORS.free;
    except
      on E: Exception do
      begin
        Log(cERRORText + ' IQ-Evaluation Exception: ' + E.Message);
      end;
    end;
  end;

  procedure DoBackup;
  begin
    with IBOBackupService1 do
    begin

      Log(ServerName);
      try
        DatabaseName := i_c_DataBaseFName;

        Log(fbak_Full_FName);
        Log(iTranslatePath + fbak_FName);
        BackupFile.clear;
        BackupFile.add(fbak_Full_FName);
        application.processmessages;
        Log('###############');
        Log('# B A C K U P #');
        Log('###############');
        Log('läuft ...');
        Active := true;
        ServiceStart;
        repeat
          try
            while not eof do
            begin
              OneLine := GetNextLine;

              // SF Bug #
              ersetze(#10, '', OneLine);

              // SF Bug #
              OneLine := cutrblank(OneLine);

              Log(OneLine);
            end;
          except
            on E: Exception do
            begin
              Log(cERRORText + ' Backup Exception: ' + E.Message);
            end;
          end;
        until eof;

      finally
        Active := false;
      end;

    end;
  end;

  procedure DoRestore;
  begin
    with IBORestoreService1 do
    begin

      PageSize := 16384;
      try
        DatabaseName.clear;
        DatabaseName.add(fbak_Full_FName + '.fdb');
        BackupFile.clear;
        BackupFile.add(fbak_Full_FName);
        application.processmessages;

        Log('#################');
        Log('# R E S T O R E #');
        Log('#################');
        Log('läuft ...');
        Active := true;
        ServiceStart;
        repeat
          try
            while not eof do
            begin
              OneLine := GetNextLine;

              // SF Bug #
              ersetze(#10, '', OneLine);

              // SF Bug #
              OneLine := cutrblank(OneLine);

              Log(OneLine);
            end;
          except
            on E: Exception do
            begin
              Log(cERRORText + ' Restore Exception: ' + E.Message);
            end;
          end;
        until eof;
      finally
        Active := false;
      end;
    end;
  end;

  procedure DoCheckGenerators;
  begin
    Log('#########################');
    Log('# G E N - C O M P A R E #'); // Information Quantity/Quality
    Log('#########################');

    try

      //
      rTRANSACTION := TIB_Transaction.create(self);
      with rTRANSACTION do
      begin
        Isolation := tiCommitted;
        AutoCommit := true;
        ReadOnly := true;
      end;

      //
      rCONNECTION := TIB_Connection.create(self);
      with rCONNECTION do
      begin
        DefaultTransaction := rTRANSACTION;
        LoginDBReadOnly := true;
        Protocol := cpTCP_IP;
        if (iDataBaseHost = '') then
          DatabaseName := fbak_Full_FName + '.fdb'
        else
          DatabaseName := iDataBaseHost + ':' + fbak_Full_FName + '.fdb';
        UserName := 'SYSDBA';
        Password := deCrypt_Hex(iDataBasePassword);
      end;

      with rTRANSACTION do
      begin
        IB_Connection := rCONNECTION;
      end;

      rCONNECTION.connect;

      //
      cGENERATORS := DataModuleDatenbank.nCursor;
      with cGENERATORS do
      begin
        IB_Connection := rCONNECTION;
        sql.add(cScript_List_Generators);
        ApiFirst;
        if (RecordCount <> sGENERATORS.count) then
        begin
          Log(cERRORText + ' Anzahl der GENERATORen stimmt nicht!');
        end;

        while not(eof) do
        begin
          GenName := Fields[0].AsString;
          GenValIst := GEN_ID(GenName, 0);
          GenValSoll := strtoint64def(sGENERATORS.values[GenName], 0);
          if (GenValIst >= GenValSoll) then
          begin
            Log(GenName + ' OK');
          end
          else
          begin
            Log(cERRORText + ' GENERATOR ' + GenName + ': Ist=' +
              inttostr(GenValIst) + ' Soll=' + inttostr(GenValSoll));
          end;
          ApiNext;
        end;
      end;
      sGENERATORS.free;
      cGENERATORS.free;

      cINDEX := DataModuleDatenbank.nCursor;
      with cINDEX do
      begin
        IB_Connection := rCONNECTION;
        sql.add('SELECT');
        sql.add(' RDB$INDICES.RDB$RELATION_NAME,');
        sql.add(' RDB$INDICES.RDB$INDEX_NAME,');
        sql.add(' RDB$INDEX_SEGMENTS.RDB$FIELD_NAME');
        sql.add('FROM');
        sql.add(' RDB$INDICES');
        sql.add('JOIN');
        sql.add(' RDB$INDEX_SEGMENTS');
        sql.add('ON');
        sql.add(' RDB$INDICES.RDB$INDEX_NAME=RDB$INDEX_SEGMENTS.RDB$INDEX_NAME');
        sql.add('WHERE');
        sql.add(' (RDB$INDICES.RDB$SYSTEM_FLAG=0) AND');
        sql.add(' (RDB$INDICES.RDB$INDEX_INACTIVE=1)');
        ApiFirst;
        if (RecordCount <> 0) then
          Log(cERRORText + ' Es gibt inaktive Indizes');
        while not(eof) do
        begin
          Log(
            { } cWARNINGtext +
            { } ' Index ' +
            { } FieldByName('RDB$RELATION_NAME').AsString + '.' +
            { } FieldByName('RDB$INDEX_NAME').AsString +
            { } ' ist nicht aktiv');
          ApiNext;
        end;
      end;
      cINDEX.free;

      rCONNECTION.disconnect;
      rCONNECTION.free;
      rTRANSACTION.free;
    except
      on E: Exception do
      begin
        Log(cERRORText + ' IQ-Compare Exception: ' + E.Message);
      end;
    end;

  end;

  procedure doCompress;
  begin
    repeat

      ResultFName := DatensicherungPath + fbak_FName + cZIPExtension;

      Log('zip ' + ResultFName + ' ...');

      ProgressBar1.max := 100;
      ProgressBar1.Position := 50;
      ZipFileList := TStringList.create;
      ZipFileList.add(DatensicherungPath + fbak_FName);
      if (zip(ZipFileList, ResultFName) <> 1) then
      begin
        Log(cERRORText + ' zip Archiv sollte eine Datei beinhalten!');
        break;
      end;
      ZipFileList.free;

      // hat das Komprimieren geklappt?
      if not(FileExists(ResultFName)) then
      begin
        Log(cERRORText + ' Archiv ' + ResultFName + ' nicht gefunden!');
        break;
      end;

      // nun das Datenbank-Backup löschen!
      FileDelete(DatensicherungPath + fbak_FName);
      if FileExists(DatensicherungPath + fbak_FName) then
      begin
        Log(cERRORText + ' Datenbank-Datei ' + DatensicherungPath + fbak_FName +
          ' nicht löschbar!');
        break;
      end;

    until true;
    ProgressBar1.Position := 0;

  end;

begin
  result := false;
  if (BackupGID >= 0) then
  begin
    if assigned(IBC) then
    begin

      StartTime := 0;
      ErrorCount := 0;
      fbak_FName := cSicherungsPrefix + inttostrN(BackupGID, 8) + '.fbak';
      caption := 'Datensicherung - ' + inttostr(BackupGID);
      if (iDataBaseBackUpDir = '') then
      begin
        fbak_Full_FName := i_c_DataBasePath + fbak_FName;
      end
      else
      begin
        fbak_Full_FName := iDataBaseBackUpDir + fbak_FName;
      end;

      show;
      PageControl1.ActivePage := TabSheet1;

      repeat

        Memo1.lines.clear;
        BeginHourGlass;

        //
        CheckCreateDir(DatensicherungPath);

        if not(CheckBox3.Checked) then
        begin

          ReadGenerators;
          if (ErrorCount > 0) then
            break;

          // ShowMessage(HugeSingleLine(sGENERATORS));
          SetUpService(IBOBackupService1);
          SetUpService(IBORestoreService1);

          // BACKUP
          if not(CheckBox12.Checked) then
          begin
            DoBackup;
            SaveLog;
          end;

          if (ErrorCount > 0) then
            break;
          if CheckBox2.Checked then
            break;

          // ist das Backup angekommen? Prüfen über die Windows-Welt
          if not(FileExists(iTranslatePath + fbak_FName)) then
          begin
            Log(cERRORText + ' Datei ' + iTranslatePath + fbak_FName +
              ' fehlt. FreigabePfad= definieren!');
            break;
          end;

        end;
        SaveLog;
        if (ErrorCount > 0) then
          break;

        if not(CheckBox1.Checked) and not(CheckBox3.Checked) then
        begin

          // restore to proof validty
          DoRestore;
          SaveLog;

          if (ErrorCount > 0) then
            break;

          if not(FileExists(iTranslatePath + fbak_FName + '.fdb')) then
          begin
            Log(cERRORText + ' Datei ' + iTranslatePath + fbak_FName + '.fdb' +
              ' fehlt!');
          end;

          if (ErrorCount > 0) then
            break;
          DoCheckGenerators;
          if (ErrorCount > 0) then
            break;

          // Datenbankdatei aus Sicht der Backup-Routine löschen
          FileDelete(iTranslatePath + fbak_FName + '.fdb');
          if FileExists(iTranslatePath + fbak_FName + '.fdb') then
          begin
            Log(cERRORText + ' Datei ' + iTranslatePath + fbak_FName + '.fdb' +
              ' nicht löschbar!');
          end;

        end;
        SaveLog;
        if (ErrorCount > 0) then
          break;

        ResultFName := DatensicherungPath + fbak_FName;

        // a) in den Windows Bereich kopieren (falls es nicht schon dort ist!)
        if (iTranslatePath <> DatensicherungPath) then
          if not(FileExists(DatensicherungPath + fbak_FName)) then
          begin
              Log(
               {} 'mv ' + iTranslatePath + fbak_FName + ' ' +
               {} DatensicherungPath + fbak_FName + ' ...');
              FileMove(
               {} iTranslatePath + fbak_FName,
               {} DatensicherungPath + fbak_FName);
          end;
        SaveLog;

        // Existenz der Ergebnisdatei prüfen!
        if not(FileExists(DatensicherungPath + fbak_FName)) then
        begin
          Log(cERRORText + ' Datei ' + DatensicherungPath + fbak_FName +
            ' nicht gefunden!');
          break;
        end;

        // b) im Windows Bereich komprimieren!
        doCompress;

      until true;
      SaveLog;

      // FTP Upload?
      if CheckBox1.Checked and (ErrorCount = 0) then
      begin
        Log('FTP Upload ...');

        CheckBox1.Checked := false;
        doUpload(ResultFName);
      end;
      SaveLog;

      EndHourGlass;

      // Ergebnis!
      if (ErrorCount = 0) then
      begin
        Log('Erfolgreich beendet');
        result := true;
        close;
      end
      else
      begin
        Log('Es gab Fehler!');
      end;
      SaveLog;

    end;
  end;
end;

procedure TFormDatensicherung.Button1Click(Sender: TObject);
begin
  if (Edit4.Text = '') then
    BackUp(GENID)
  else
  begin
    BackUp(StrToIntDef(Edit4.Text, -1));
    Edit4.Text := '';
  end;
end;

procedure TFormDatensicherung.FormActivate(Sender: TObject);
begin
  if not(Initialized) then
  begin
    Initialized := true;
    BeginHourGlass;

    // welcher Server wird verwendet
    with IBOServerProperties1 do
    begin
      SysErrorMessage(10060);
      Params.clear;
      Params.add('user_name=SYSDBA');
      Params.add('password=' + deCrypt_hex(iDataBasePassword));
      ServerName := iDataBaseHost;
      if (iDataBaseHost <> '') then
        Protocol := cpTCP_IP
      else
        Protocol := cpLocal;

      try
        Attach;
        Fetch;
        Log(VersionInfo.ServerImplementation + ' ' + VersionInfo.ServerVersion);
        Detach;
      except
        on E: Exception do
          Log(cERRORText + ' ' + E.Message);
      end;
    end;

    if (iDataBaseBackUpDir = '') then
      Log(i_c_DataBasePath)
    else
      Log(iDataBaseBackUpDir);

    Log(iTranslatePath);

    Label8.caption := MyProgramPath + '*';
    Label10.caption := iSicherungsPfad + iSicherungsPreFix + 'NNNNNNNN';

    EndHourGlass;
  end;
  Button1.Enabled := assigned(IBC);
end;

function TFormDatensicherung.GENID: Integer;
begin
  if assigned(IBC) then
    if CheckBox3.Checked then
      result := IBC.GEN_ID('GEN_BACKUP', 0)
    else
      result := IBC.GEN_ID('GEN_BACKUP', 1)
  else
    result := -1;
end;

// die400

// erstellt eine Dateiliste von gewissen Dateien
// die mit hinreichender Wahrscheinlichkeit nicht mehr benötigt werden
// es sind diverse Dateien aus unterschiedlichen Quellen
// die 400er-Zips sollten dauerhaft gespeichert werden

function TFormDatensicherung.die400: TStringList;

const
  cMinAge = 400;
  cFotosPath = 'Fotos\';
var
  DiagnoseFName: string;

  procedure CheckAndAdd(sPath, sExtension: string);
  var
    n: Integer;
    sFiles: TStringList;
    FindOne: boolean;
  begin
    FindOne := false;
    sFiles := TStringList.create;
    dir(sPath + '*' + sExtension, sFiles, false);
    for n := 0 to pred(sFiles.count) do
      if FileRetire(sPath + sFiles[n], cMinAge) then
      begin
        result.add(sPath + sFiles[n]);
        if not(FindOne) then
        begin
          AppendStringsToFile(sPath, DiagnoseFName);
          FindOne := true;
        end;
        AppendStringsToFile(
          { } ' ' +
          { } Long2date(LastDate) +
          { } ' ' + sFiles[n],
          { } DiagnoseFName);
      end;
    sFiles.free;
  end;

var
  sBAUSTELLEN: TStringList;
  sFOTOS: TStringList;
  sSubs: TStringList;
  n, m: Integer;

begin
  DiagnoseFName :=
  { } DiagnosePath +
  { } 'Ablage-400-' +
  { } inttostr(DateGet) +
  { } cLogExtension;

  result := TStringList.create;
  sBAUSTELLEN := TStringList.create;
  sFOTOS := TStringList.create;
  sSubs := TStringList.create;

  // 1) jpgs aus den Baustellenverzeichnissen
  dir(iBaustellenPath + '*.', sBAUSTELLEN, false);
  for n := 0 to pred(sBAUSTELLEN.count) do
  begin
    if (Pos('.', sBAUSTELLEN[n]) = 1) then
      continue;

    // Das Baustellen Verzeichnis direkt
    CheckAndAdd(iBaustellenPath + sBAUSTELLEN[n] + '\', cImageExtension);

    // Alles ab "Fotos"
    if DirExists(iBaustellenPath + sBAUSTELLEN[n] + '\' + cFotosPath) then
    begin

      // Im Hauptverzeichnis suchen
      CheckAndAdd(iBaustellenPath + sBAUSTELLEN[n] + '\' + cFotosPath,
        cImageExtension);

      // In allen Unterverzeichnissen suchen
      dir(iBaustellenPath + sBAUSTELLEN[n] + '\' + cFotosPath + '*.',
        sSubs, false);
      for m := 0 to pred(sSubs.count) do
      begin
        if (Pos('.', sSubs[m]) = 1) then
          continue;
        CheckAndAdd(iBaustellenPath + sBAUSTELLEN[n] + '\' + cFotosPath +
          sSubs[m] + '\', cImageExtension);
      end;

    end;
  end;

  // 2) xml aus den SAP Verzeichnissen
  dir(cAuftragErgebnisPath + '*.', sBAUSTELLEN, false);
  for n := 0 to pred(sBAUSTELLEN.count) do
  begin
    if (Pos('.', sBAUSTELLEN[n]) = 1) then
      continue;

    // Das Baustellen Verzeichnis direkt
    CheckAndAdd(cAuftragErgebnisPath + sBAUSTELLEN[n] + '\', '.csv');
    CheckAndAdd(cAuftragErgebnisPath + sBAUSTELLEN[n] + '\', '.xml');

  end;

  sBAUSTELLEN.free;
  sFOTOS.free;
  sSubs.free;

end;

procedure TFormDatensicherung.do400(TAN: Integer);
var
  sFiles: TStringList;
begin
  BeginHourGlass;
  sFiles := die400;
  zip400(sFiles, false, TAN);
  sFiles.free;
  EndHourGlass;
end;

function FeedBack (key : Integer; value : string = '') : Integer;
begin
  result := cFeedBack_CONT;
  with FormDatensicherung do
  begin
    case Key of
     cFeedBack_ProcessMessages: Application.Processmessages;
     cFeedBack_ProgressBar_Max+1: progressbar1.max := StrToIntDef(value,0);
     cFeedBack_ProgressBar_Position+1: progressbar1.position := StrToIntDef(value,0);
     cFeedBack_ProgressBar_stepit+1: progressbar1.StepIt;
     cFeedBack_ShowMessage: ShowMessage(value);
     cFeedBack_ListBox_add+2:begin
     ListBox2.items.Add(value);
ListBox2.itemindex := pred(ListBox2.items.count);
     end;
     cFeedBack_ListBox_clear+2:begin
       ListBox2.items.clear;
     end;

    else
     ShowMessage('Unbekannter Feedback Key '+IntToStr(Key));
    end;
  end;
end;

procedure TFormDatensicherung.Button2Click(Sender: TObject);
begin
    BeginHourGlass;
    show;
    PageControl1.ActivePage := TabSheet2;
    SicherungDateisystem(GENID,Feedback);
    EndHourGlass;
    close;
end;

procedure TFormDatensicherung.Restore(BackupGID: Integer);
var
  OutFName: string;
  gbkFName: string;
  OneLine: string;
begin
  //
  gbkFName := cSicherungsPrefix + inttostrN(BackupGID, 8) + '.fbak';
  if iDataBaseBackUpDir = '' then
    OutFName := i_c_DataBasePath + gbkFName
  else
    OutFName := iDataBaseBackUpDir + gbkFName;

  if not(FileExists(iTranslatePath + gbkFName + '.fdb')) then
  begin
    show;
    StartTime := 0;

    SetUpService(IBORestoreService1);
    with IBORestoreService1 do
    begin
      PageSize := 16384;

      try
        DatabaseName.clear;
        DatabaseName.add(OutFName + '.fdb');
        BackupFile.clear;
        BackupFile.add(OutFName);
        application.processmessages;

        Log('#################');
        Log('# R E S T O R E #');
        Log('#################');
        Log('läuft ...');
        Active := true;
        ServiceStart;
        repeat
          try
            while not eof do
            begin
              OneLine := GetNextLine;

              // SF Bug #
              ersetze(#10, '', OneLine);

              // SF Bug #
              OneLine := cutrblank(OneLine);

              Log(OneLine);
            end;
          except
            on E: Exception do
            begin
              Log(cERRORText + ' Restore Exception:' + E.Message);
            end;
          end;
        until eof;
      finally
        Active := false;
      end;
    end;
    close;
  end;
end;

procedure TFormDatensicherung.SaveLog;
begin
  if assigned(sLog) then
  begin
    AppendStringsToFile(sLog, DiagnosePath + 'Datensicherung-' + DatumLog +
      cLogExtension);
    sLog.clear;
  end;
end;

procedure TFormDatensicherung.SetUpService(dbService: TIBOBackupRestoreService);
begin
  with dbService do
  begin
    //
    ServerName := iDataBaseHost;
    if (iDataBaseHost = '') then
      Protocol := cpLocal
    else
      Protocol := cpTCP_IP;
    LoginPrompt := false;

    Params.clear;
    Params.add('user_name=SYSDBA');
    Params.add('password=' + deCrypt_Hex(iDataBasePassword));
    if dbService is TIBOBackupRestoreService then
      with dbService as TIBOBackupRestoreService do
        Verbose := true;
  end;
end;

procedure TFormDatensicherung.Log(s: string);
begin

  if not(assigned(sLog)) then
    sLog := TStringList.create;

  Memo1.lines.add(s);
  sLog.add(s);

  if (Pos(cERRORText, s) > 0) then
  begin
    inc(ErrorCount);
    AppendStringsToFile('DaSi ' + s,
      {} ErrorFName('BACKUP'),
      {} Uhr8);
  end;

  if frequently(StartTime, 444) then
    application.processmessages;
end;

procedure TFormDatensicherung.refreshCompressedDirView;
var
  sDir: TStringList;
begin
  if (Edit1.Text = '') then
    Edit1.Text := DatensicherungPath;
  sDir := TStringList.create;
  dir(Edit1.Text + '*', sDir, false);
  sDir.sort;
  ListBox1.items.Assign(sDir);
  sDir.free;
end;

procedure TFormDatensicherung.refresh_fbak_DirView;
var
  sDir: TStringList;
begin
  if (Edit2.Text = '') then
    Edit2.Text := DatensicherungPath;
  sDir := TStringList.create;
  dir(Edit2.Text + '*.fbak', sDir, false);
  sDir.sort;
  ListBox4.items.Assign(sDir);
  sDir.free;
end;

procedure TFormDatensicherung.refresh_MandantView;
var
  sDir: TStringList;
  k: Integer;
begin
  if (Edit3.Text = '') then
  begin

    k := revpos('\', copy(MyProgramPath, 1, pred(length(MyProgramPath))));
    if k > 0 then
      Edit3.Text := copy(MyProgramPath, 1, k);

  end;
  sDir := TStringList.create;
  dir(Edit3.Text + '*.zip', sDir, false);
  sDir.sort;
  ListBox5.items.Assign(sDir);
  sDir.free;
end;

procedure TFormDatensicherung.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Datensicherung');
end;

procedure TFormDatensicherung.TabSheet3Show(Sender: TObject);
begin
  refreshCompressedDirView;
end;

procedure TFormDatensicherung.TabSheet5Show(Sender: TObject);
begin
  refresh_fbak_DirView;
end;

procedure TFormDatensicherung.TabSheet6Show(Sender: TObject);
begin
  refresh_MandantView;
end;

procedure TFormDatensicherung.zip400(sFiles: TStringList; DontDelete: boolean;
  TAN: Integer);
var
  sOptions: TStringList;
  ZipCount: Integer;
  ErrorCount: Integer;
  n: Integer;
  ZipFName: string;
begin
  if (sFiles.count >= 20) then
  begin

    // TAN ermitteln
    if TAN < cRID_FirstValid then
      TAN := e_w_gen('GEN_BACKUP');

    // Zip-Optionen
    sOptions := TStringList.create;
    sOptions.values[czip_set_RootPath] := MyProgramPath;
    sOptions.values[czip_set_Level] := '0';

    // nun komprimieren
    ZipFName :=
    { } iSicherungsPfad +
    { } 'Ablage-' +
    { } inttostrN(TAN, 8) +
    { } cZIPExtension;
    ZipCount := zip(
      { } sFiles,
      { } ZipFName,
      { } sOptions);

    sOptions.free;

    if (ZipCount <> sFiles.count) then
    begin
      sFiles.add(
        { } cERRORText + ' zip400: nur ' + inttostr(ZipCount) +
        { } ' Datei(en) im Archiv "' + ZipFName +
        { } '" aber ' + inttostr(sFiles.count) +
        { } ' erwartet');

      sFiles.SaveToFile(
        { } DiagnosePath +
        { } 'zip400-' +
        { } inttostrN(TAN, 8) +
        { } cLogExtension);
      exit;
    end;

    if not(DontDelete) then
    begin

      ErrorCount := 0;
      for n := 0 to pred(sFiles.count) do
        if not(FileDelete(sFiles[n])) then
        begin
          sFiles.add(
            { } cERRORText + ' zip400: Datei "' +
            { } sFiles[n] + '" lässt sich nicht löschen');
          inc(ErrorCount);
        end;

      if (ErrorCount > 0) then
        sFiles.SaveToFile(
          { } DiagnosePath +
          { } 'zip400-' +
          { } inttostrN(TAN, 8) +
          { } cLogExtension);

    end;
  end;
end;

procedure TFormDatensicherung.SpeedButton1Click(Sender: TObject);
begin
  openShell(Edit2.Text);
end;

procedure TFormDatensicherung.SpeedButton2Click(Sender: TObject);
begin
  refreshCompressedDirView;
end;

procedure TFormDatensicherung.SpeedButton3Click(Sender: TObject);
begin
  refresh_fbak_DirView;
end;

procedure TFormDatensicherung.SpeedButton4Click(Sender: TObject);
begin
  openShell(Edit3.Text);
end;

procedure TFormDatensicherung.SpeedButton5Click(Sender: TObject);
begin
  refresh_MandantView;
end;

procedure TFormDatensicherung.SpeedButton8Click(Sender: TObject);
begin
  openShell(Edit1.Text);
end;

procedure TFormDatensicherung.Button3Click(Sender: TObject);
var
  FName: string;
begin
 if (ListBox1.itemindex<>-1) then
 begin
   BeginHourGlass;
   PageControl1.ActivePage := TabSheet1;
   FName := Edit1.Text + ListBox1.items[ListBox1.itemindex];
   NoTimer := true;
   doUpload(FName);
   NoTimer := false;
   EndHourGlass;
 end;
end;

procedure TFormDatensicherung.Button4Click(Sender: TObject);
var
  s400: TStringList;
begin
  BeginHourGlass;
  s400 := die400;
  ListBox3.items.Assign(s400);
  if DebugMode then
   s400.SaveToFile(DiagnosePath+'400.txt',Tencoding.UTF8);
  s400.free;
  EndHourGlass;
end;

procedure TFormDatensicherung.Button5Click(Sender: TObject);
var
  sFiles: TStringList;
begin
  BeginHourGlass;
  sFiles := TStringList.create;
  sFiles.Assign(ListBox3.items);
  zip400(sFiles, not(CheckBox5.Checked));
  sFiles.free;
  if CheckBox5.Checked then
    ListBox3.items.clear;
  EndHourGlass;
end;

procedure TFormDatensicherung.Button6Click(Sender: TObject);
var
  fbakFName: string;
  OneLine: string;
  ExceptionMessage: string;
begin
  // restore this file!
  fbakFName := Edit2.Text + ListBox4.items[ListBox4.itemindex];
  SetUpService(IBORestoreService1);

  PageControl1.ActivePage := TabSheet1;
  ExceptionMessage := '';
  with IBORestoreService1 do
  begin

    PageSize := 16384;
    try
      DatabaseName.clear;
      DatabaseName.add(fbakFName + '.fdb');
      BackupFile.clear;
      BackupFile.add(fbakFName);
      application.processmessages;

      Log('#################');
      Log('# R E S T O R E #');
      Log('#################');
      Log('läuft ...');
      Active := true;
      ServiceStart;
      repeat
        try
          while not eof do
          begin
            OneLine := GetNextLine;

            // SF Bug #
            ersetze(#10, '', OneLine);

            // SF Bug #
            OneLine := cutrblank(OneLine);

            Log(OneLine);
          end;
        except
          on E: Exception do
          begin
            if E.Message = ExceptionMessage then
              break;
            Log(cERRORText + ' Restore Exception: ' + E.Message);
            ExceptionMessage := E.Message;
          end;
        end;
      until eof;
    finally
      Active := false;
    end;
  end;

end;

procedure TFormDatensicherung.Button7Click(Sender: TObject);
begin
  unzip(Edit1.Text + ListBox1.items[ListBox1.itemindex], Edit1.Text);
  refreshCompressedDirView;
end;

procedure TFormDatensicherung.Button8Click(Sender: TObject);
begin
  SicherungenQuota;
end;

procedure TFormDatensicherung.Button9Click(Sender: TObject);
var
  RestorePath: string;
  MandantNeu: string;
  MandantPath: string;
  MandantRaw: string;
  FirebirdWorkPath: string;
  SicherungTAN: string;
  i: Integer;
  OneLine: string;
  fbakFName: string;
  fdbFName: string;
  sIni: TStringList;

  //
  MandantMatch_Found: boolean;
  Max_DataBaseNameN: Integer;
  OrgaMonIni_PatchPosition: Integer;
  _sIniUpper: string;

  function cdpp(sPath: string): string;
  var
    k: Integer;
  begin
    k := revpos(sPath[length(sPath)], copy(sPath, 1, pred(length(sPath))));
    result := copy(sPath, 1, k);
  end;

begin
  if (ListBox5.itemindex <> -1) then
  begin

    // A: Init
    PageControl1.ActivePage := TabSheet1;
    application.processmessages;
    RestorePath := Edit3.Text;
    MandantNeu := nextp(ListBox5.items[ListBox5.itemindex], cZIPExtension, 0);
    MandantRaw := nextp(MandantNeu, '_', 0);
    SicherungTAN := nextp(MandantNeu, '_', 1);

    // B: Name des Unzip-Zielpfades bestimmen
    MandantPath := MandantNeu;
    if CheckBox6.Checked then
    begin
      i := 1;
      repeat
        if not(DirExists(RestorePath + MandantPath)) then
          break;

        if (i = 1) then
          MandantPath := MandantPath + '-1'
        else
          MandantPath :=
          { } copy(MandantPath, 1, revpos('-', MandantPath) - 1) +
          { } '-' + inttostr(i);

        inc(i);
      until false;
    end;
    MandantPath := MandantPath + '\';

    if CheckBox6.Checked then
      Log('restore to "' + RestorePath + MandantPath + '" ...')
    else
      Log('assume ready unzipped "' + RestorePath + MandantPath + '" ...');

    // C: unzip
    CheckCreateDir(RestorePath + MandantPath);

    if CheckBox6.Checked then
    begin
      Log('unzip  "' + RestorePath + MandantNeu + cZIPExtension + '" ...');
      unzip(RestorePath + MandantNeu + cZIPExtension, RestorePath + MandantPath);
    end;

    if (iDataBaseBackUpDir = '') then
      FirebirdWorkPath := i_c_DataBasePath
    else
      FirebirdWorkPath := iDataBaseBackUpDir;

    fbakFName := FirebirdWorkPath + 'sicherung_' + SicherungTAN + '.fbak';
    fdbFName :=
    { } FirebirdWorkPath +
    { } MandantRaw + '_' +
    { } SicherungTAN + '.fdb';

    Log('unzip "' + RestorePath + MandantPath + 'Datensicherung\' +
      { } 'sicherung_' + SicherungTAN + '.fbak.zip' + '" ...');

    if CheckBox7.Checked then
      unzip(
        { } RestorePath + MandantPath + 'Datensicherung\' +
        { } 'sicherung_' + SicherungTAN + '.fbak.zip', iTranslatePath);
    Log(' to ' + iTranslatePath);

    Log('.fbak name (from Server Point of View) is ... ');
    Log(' ' + fbakFName);
    Log('.fdb name (from Server Point of View) is ... ');
    Log(' ' + fdbFName);

    // E: restore Database
    if CheckBox8.Checked then
    begin
      with IBORestoreService1 do
      begin
        SetUpService(IBORestoreService1);

        PageSize := 16384;
        try
          DatabaseName.clear;
          DatabaseName.add(fdbFName);
          BackupFile.clear;
          BackupFile.add(fbakFName);
          application.processmessages;

          Log('#################');
          Log('# R E S T O R E #');
          Log('#################');
          Log('läuft ...');
          Active := true;
          ServiceStart;
          repeat
            try
              while not eof do
              begin
                OneLine := GetNextLine;

                // SF Bug #
                ersetze(#10, '', OneLine);

                // SF Bug #
                OneLine := cutrblank(OneLine);

                Log(OneLine);
              end;
            except
              on E: Exception do
              begin
                Log(cERRORText + ' Restore Exception: ' + E.Message);
              end;
            end;
          until eof;
        finally
          Active := false;
        end;
      end;
    end;

    // F: patch "restore" OrgaMon.ini
    if CheckBox9.Checked then
    begin
      sIni := TStringList.create;
      if (iDataBaseHost <> '') then
        sIni.values[cDataBaseName] := iDataBaseHost + ':' + fdbFName
      else
        sIni.values[cDataBaseName] := fdbFName;

      sIni.values[cDataBasePwd] := iDataBasePassword;
      sIni.Insert(0, '[System]');
      sIni.SaveToFile(RestorePath + MandantPath + cIniFName);
      sIni.free;
    end;

    // G: patch "local" OrgaMon.ini
    if CheckBox10.Checked then
    begin

      MandantMatch_Found := false;
      sIni := TStringList.create;
      sIni.LoadFromFile(RestorePath + cIniFName);
      for i := 0 to pred(sIni.count) do
      begin
        if (Pos('Mandant:', sIni[i]) > 0) and (Pos(MandantRaw, sIni[i]) > 0)
        then
        begin
          sIni[i + 1] :=
          { } nextp(sIni[i + 1], '=', 0) + '=' +
          { } RestorePath + MandantPath;
          MandantMatch_Found := true;
          break;
        end;
      end;

      if not(MandantMatch_Found) then
      begin
        Max_DataBaseNameN := 1;
        OrgaMonIni_PatchPosition := sIni.count;
        for i := 0 to pred(sIni.count) do
        begin
          _sIniUpper := cutblank(AnsiUpperCase(sIni[i]));
          if (_sIniUpper = '[SPARE]') then
          begin
            OrgaMonIni_PatchPosition := pred(i);
            break;
          end;
          if (Pos('DATABASENAME', _sIniUpper) = 1) then
          begin
            Max_DataBaseNameN := max(Max_DataBaseNameN,
              StrToIntDef(ExtractSegmentBetween(_sIniUpper, 'DATABASENAME',
              '='), 1));
          end;
        end;

        sIni.Insert(OrgaMonIni_PatchPosition,
          cDataBasePwd + inttostr(succ(Max_DataBaseNameN)) + '=' +
          iDataBasePassword);
        sIni.Insert(OrgaMonIni_PatchPosition,
          cDataBaseName + inttostr(succ(Max_DataBaseNameN)) + '=' + RestorePath
          + MandantPath);
        sIni.Insert(OrgaMonIni_PatchPosition, '// Mandant: ' + MandantRaw);
        sIni.Insert(OrgaMonIni_PatchPosition, '');

      end;

      // wenn nicht gefunden dies als einen neuen Mandanten dazumachen!
      (*
        .add(cDataBaseName
        .add(cDataBasePwd+'='+ iDataBase_SYSDBA_pwd);
      *)
      sIni.SaveToFile(RestorePath + cIniFName);
      sIni.free;
    end;

    // F:
    if CheckBox11.Checked then
      FormBaseUpdate.RestartOrgaMon;
  end;
end;

function TFormDatensicherung.doUpload(ResultFName: string): boolean;
var
 FTPDestFName : string;
 FTP: TSolidFTP;
 DestPath: string;
begin
  result := false;
  FtpDestFName := ExtractFileName(ResultFName);
  Log('FTP Upload '+FtpDestFName+' ...');

  FTP := TSolidFTP.Create;
  with FTP do
  begin
    if RadioButton1.Checked then
    begin
     Host := cFTP_Host;
     UserName := cFTP_UserName;
     Password := cFTP_Password;
     DestPath := cSolidFTP_DirCurrent;
    end;

    if RadioButton2.Checked then
    begin
     Host := Edit5.Text;
     UserName := Edit6.Text;
     Password := Edit7.Text;
     DestPath := Edit8.Text;
    end;

    Retries := 200;
    result := Upload(ResultFName,DestPath,FtpDestFName);
  end;
  FTP.Free;
  if result then
   Log('OK')
  else
   Log('ERROR');
end;

procedure TFormDatensicherung.Edit5Change(Sender: TObject);
begin
 if not(RadioButton2.Checked) then
   RadioButton2.Checked := true;
end;

procedure TFormDatensicherung.FormCreate(Sender: TObject);
begin
  StartDebug('Datensicherung');
  PageControl1.ActivePage := TabSheet1;
end;

end.
