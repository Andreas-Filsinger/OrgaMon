{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2013 - 2019  Andreas Filsinger
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
unit UnitFirebirdRestore;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls,
  DCPcrypt2, DCPblockciphers, DCPblowfish,
  IB_Components, IBOServices;

type
  TFormFirebirdRestore = class(TForm)
    Memo1: TMemo;
    DCP_blowfish1: TDCP_blowfish;
    IBORestoreService1: TIBORestoreService;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
    ProcessData: boolean;
    ReplaceVolumes: TStringList;
    TheCommandLine: string;
    EditIniMode: boolean;
    MaxSetting: integer;
  public
    { Public-Deklarationen }
    iServerName: string;
    iShareRoot: string;
    iBackupName: string;
    iNewDatabaseFName: string;
    iDBName: string;
    iSYSDBApassword: string;
    iRestoreDest: string;
    function IniFName: string;
    function deCrypt(s: string): string;
  end;

var
  FormFirebirdRestore: TFormFirebirdRestore;

implementation

uses
  math, anfix32, IniFiles,
  wanfix32, IB_Session;

{$R *.dfm}

const
  Version: single = 1.015; // ..\rev\FirebirdRestore.rev.txt
  cKey = 'anfisoftOrgaMon';
  cApplicationName = 'FirebirdRestore';

procedure TFormFirebirdRestore.FormCreate(Sender: TObject);
var
  n: integer;
  MyINi: TIniFile;
  Setting: string;
  LocationLength: integer;
  LocationPreFix: string;
  BackupLocation: string;
  DBLocation: string;

begin

  //
  ReplaceVolumes := TStringList.create;
  Caption := 'Firebird Restore Rev ' + RevToStr(Version);

  //
  MaxSetting := 0;
  MyINi := TIniFile.create(IniFName);
  with MyINi do
  begin
    for n := 0 to 30 do
    begin
      Setting := noblank(ReadString('System', inttostr(n), ''));
      if (Setting <> '') then
      begin
        ReplaceVolumes.add(Setting);
        MaxSetting := max(MaxSetting, n);
      end;
    end;
  end;
  MyINi.free;

  //
  TheCommandLine := paramstr(1);
  if (TheCommandLine <> '') then
  begin

    ProcessData := false;
    for n := 0 to pred(ReplaceVolumes.count) do
    begin
      LocationPreFix := nextp(ReplaceVolumes[n], ',', 0);
      if pos(LocationPreFix, TheCommandLine) = 1 then
      begin
        LocationLength := length(LocationPreFix);
        BackupLocation := copy(TheCommandLine, succ(LocationLength), MaxInt);
        ersetze('\', '/', BackupLocation);
        DBLocation := BackupLocation;
        ersetze('.fbak', '.fdb', DBLocation);

        //
        iNewDatabaseFName := ExtractFileName(TheCommandLine);
        ersetze('.fbak', '.fdb', iNewDatabaseFName);

        // Parameter aus ini Dazulesen
        iServerName := nextp(ReplaceVolumes[n], ',', 1);
        iShareRoot := nextp(ReplaceVolumes[n], ',', 2);
        iSYSDBApassword := nextp(ReplaceVolumes[n], ',', 3);

        repeat

          if (iSYSDBApassword = '') then
          begin
            iSYSDBApassword := 'masterkey';
            break;
          end;

          if (length(iSYSDBApassword)=48) then
          begin
            iSYSDBApassword := deCrypt(iSYSDBApassword);
            break;
          end;

        until true;
        iRestoreDest := nextp(ReplaceVolumes[n], ',', 4);

        // Berechnete DateiNamen
        iBackupName := iShareRoot + BackupLocation;
        if (iRestoreDest <> '') then
          iDBName := iRestoreDest + iNewDatabaseFName
        else
          iDBName := iShareRoot + DBLocation;

        //

        ProcessData := true;
        break;
      end;
    end;

    if not(ProcessData) then
    begin

      LocationPreFix := copy(TheCommandLine, 1, 3);
      LocationLength := length(LocationPreFix);
      BackupLocation := copy(TheCommandLine, succ(LocationLength), MaxInt);
      ersetze('\', '/', BackupLocation);
      DBLocation := BackupLocation;
      ersetze('.fbak', '.fdb', DBLocation);

      if FisNetwork(LocationPreFix) then
      begin
        Showmessage('Fehler: Zu wenig Information über ' + LocationPreFix + #13
          + 'Bitte vervollständigen Sie die Angaben' + #13 + '<host>,<rootdir>'
          + #13 + 'ganz unten in der ini-Datei!');
        EditIniMode := true;
        Memo1.Lines.LoadFromFile(IniFName);
        Memo1.Lines.add(inttostr(MaxSetting + 1) + '=' + LocationPreFix +
          ',<host>,<rootdir>,masterkey');
      end
      else
      begin
        if (iServerName = 'local') then
          iServerName := ''
        else
          iServerName := '127.0.0.1';
        iDBName := LocationPreFix + DBLocation;
        iBackupName := LocationPreFix + BackupLocation;
        ProcessData := true;
      end;

    end;

  end
  else
  begin
    EditIniMode := true;
    Memo1.Lines.LoadFromFile(IniFName);
  end;
end;

function TFormFirebirdRestore.deCrypt(s: string): string;
var
  CryptKey: array [0 .. 1023] of char;
  CryptKeyLength: integer;
begin
  with DCP_blowfish1 do
  begin
    CryptKey := cKey;
    CryptKeyLength := length(cKey) * 8;
    Init(CryptKey, CryptKeyLength, nil);
    result := cutrblank(decryptstring(hexstr2bin(s)));
  end;
end;

procedure TFormFirebirdRestore.FormActivate(Sender: TObject);
var
  ErrorMsg: string;
  OneLine: string;
  ErrorFlag: boolean;
begin
  if ProcessData then
  begin
    ProcessData := false;
    ErrorMsg := '';
    ErrorFlag := false;
    //
    with IBORestoreService1 do
    begin
      ServerName := iServerName;
      if (ServerName <> '') then
        Protocol := cpTCP_IP
      else
        Protocol := cpLocal;

      PageSize := 16384;
      Verbose := true;
      Options := [CreateNewDB, Replace];
      LoginPrompt := false;

      Params.clear;
      Params.add('user_name=SYSDBA');
      Params.add('password=' + iSYSDBApassword);

      Memo1.Lines.add('SERVER=' + iServerName);
      Memo1.Lines.add('READ=' + iBackupName);
      Memo1.Lines.add('WRITE=' + iDBName);
      Memo1.Lines.add('');
      try
        DatabaseName.add(iDBName);
        BackupFile.add(iBackupName);
        application.processmessages;
        Active := true;
        ServiceStart;
        repeat
          try
            while not Eof do
            begin
              OneLine := GetNextLine;

              // SF Bug #
              ersetze(#10, '', OneLine);

              // SF Bug #
              OneLine := cutrblank(OneLine);

              if ErrorFlag or (pos('ERROR:', OneLine) > 0) then
              begin
                ErrorMsg := ErrorMsg + #13 + OneLine;
                ErrorFlag := true;
              end;

              Memo1.Lines.add(OneLine);
              application.processmessages;
            end;
          except
            on E: Exception do
            begin
              exitcode := 1;
              ErrorMsg := ErrorMsg + E.message;
            end;
          end;
        until Eof;

      except
        on E: Exception do
        begin
          exitcode := 1;
          ErrorMsg := ErrorMsg + E.message;
        end;
      end;
      Active := false;
    end;
    if (exitcode = 0) and (ErrorMsg = '') then
    begin
      delay(2500);
      close;
    end
    else
      Showmessage('FEHLER:' + #13 + ErrorMsg);
  end;
end;

procedure TFormFirebirdRestore.FormDestroy(Sender: TObject);
begin
  if EditIniMode then
    if doit('Einstellungen jetzt speichern') then
      Memo1.Lines.savetofile(IniFName);
end;

function TFormFirebirdRestore.IniFName: string;
begin
  result := PersonalDataDir + cApplicationName + '\' + cApplicationName
    + '.ini';
end;

end.
