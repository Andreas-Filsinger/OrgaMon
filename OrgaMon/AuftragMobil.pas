{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2020 Andreas Filsinger
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
unit AuftragMobil;
//
// Ausgabe der Auftrags-Daten ins InterNet
// Auslesen der Ergebnis-Daten ins InterNet
//

interface

uses
  Windows, Messages, SysUtils,
  Buttons, Variants, Classes,
  Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,
  // IBO
  IB_Components, IB_Access;

type
  TFormAuftragMobil = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Memo1: TMemo;
    Button2: TButton;
    ComboBox1: TComboBox;
    GroupBox2: TGroupBox;
    ProgressBar1: TProgressBar;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Label3: TLabel;
    GroupBox3: TGroupBox;
    Button4: TButton;
    ComboBox2: TComboBox;
    Button5: TButton;
    Label1: TLabel;
    Button6: TButton;
    CheckBox1: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox7: TCheckBox;
    SpeedButton2: TSpeedButton;
    Button3: TButton;
    CheckBox2: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private-Deklarationen }
    Initialized: boolean;

    procedure RefreshGeraeteAuswahl;
    procedure Log(s: string);

  public
    { Public-Deklarationen }

  end;

var
  FormAuftragMobil: TFormAuftragMobil;

implementation

uses
  // anfix tools
  globals, anfix, gplists,
  html, dbOrgaMon,
  CareTakerClient, wanfix, WordIndex,

  // OrgaMon tools
  Datenbank, AuftragArbeitsplatz,
  Funktionen_App,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag;

{$R *.dfm}

function FeedBack (key : Integer; value : string = '') : Integer;
begin
  result := cFeedBack_CONT;
  with FormAuftragMobil do
  begin
    case Key of
     cFeedBack_ProcessMessages: Application.Processmessages;
     cFeedBack_Label+3:label3.Caption := value;
     cFeedBack_ProgressBar_Position+1: Progressbar1.Position := StrToIntDef(value,0);
     cFeedBack_ProgressBar_Max+1: Progressbar1.Max := StrToIntDef(value,0);
     cFeedBack_ProgressBar_stepit+1: Progressbar1.StepIt;
     cFeedBack_Log: Log(value);
    else
     ShowMessage('Unbekannter Feedback Key '+IntToStr(Key));
    end;
  end;
end;

procedure TFormAuftragMobil.Button1Click(Sender: TObject);
var
 pOptions : TStringList;
 WriteResult : boolean;
begin

  pOptions := TStringList.create;
  with pOptions do
  begin

    // für e_w_ReadMobil
    Values['DownLoadTANs'] := bool2cO(CheckBox5.Checked);
    Values['PreserveTANsOnServer'] := bool2cO(CheckBox6.Checked);
    Values['MoveTANsToDiagnose'] := bool2cO(CheckBox10.Checked);

    // für e_w_WriteMobil
    values['FTPDiagnose'] := bool2cO(CheckBox7.Checked);
    values['PurgeZero'] := bool2cO(CheckBox8.Checked);
    values['UploadBaustellenInfos'] := bool2cO(CheckBox12.Checked);
    values['UploadAbgearbeitete'] := bool2cO(CheckBox9.Checked);
    values['UploadAbgezogene'] := bool2cO(CheckBox11.Checked);
    values['AsHTML'] := bool2cO(CheckBox2.Checked);
    values['FTPup'] := bool2cO(CheckBox1.Checked);
    values['Monteure'] := HugeSingleLine(Memo1.Lines,',');
  end;

  if CheckBox4.Checked then
  begin
    BeginHourGlass;
    e_w_ReadMobil(pOptions,FeedBack);
    EndHourGlass;
  end;

  if CheckBox3.Checked then
  begin
    BeginHourGlass;
    WriteResult := e_w_WriteMobil(pOptions,FeedBack);
    EndHourGlass;
    if not(WriteResult) then
      ShowMessage('Es gab Fehler beim Hochladen, der Vorgang war nicht erfolgreich!' + #13 +
          'Mögliche Ursachen: * gestörter Zugang um InterNet' + #13 + '* Kein Recht für den Dienst passives FTP' + #13 +
          '* ftp-Server ist offline!' + #13 + '* Zugang zum ftp-Server verwehrt!' + #13 +
          '* Verbindung zum ftp-Server unterbrochen!')
    else
     openShell(MdePath + 'Index.html');
  end;
end;

procedure TFormAuftragMobil.FormActivate(Sender: TObject);
begin
  //
  if not(Initialized) then
  begin
    Initialized := true;
    ComboBox1.Items.addstrings(e_r_MonteureJonDa);
    RefreshGeraeteAuswahl;
  end;
end;

procedure TFormAuftragMobil.Button2Click(Sender: TObject);
begin
  if (pos('<', ComboBox1.Items[ComboBox1.itemindex]) = 0) then
    Memo1.lines.add(ComboBox1.Items[ComboBox1.itemindex]);
end;

procedure TFormAuftragMobil.Button3Click(Sender: TObject);
begin
  Memo1.lines.clear;
end;

procedure TFormAuftragMobil.Button4Click(Sender: TObject);
var
  INf: file of TMDErec;
  OneRec: TMDErec;
  DebugF: TStringList;
  InfoF: TStringList;
  Auftrag: TIB_Cursor;
  _Status: integer;
  _MondaSchutz: boolean;
  _result: string;
  n, RecCount: integer;
begin
  BeginHourGlass;
  Auftrag := DataModuleDatenbank.nCursor;
  Auftrag.sql.add('SELECT * FROM AUFTRAG WHERE RID=:CROSSREF');
  Auftrag.open;

  DebugF := TStringList.create;
  InfoF := TStringList.create;
  AssignFile(INf, AuftragMobilServerPath + 'AUFTRAG.' + ComboBox2.Text + '.DAT');
  reset(INf);
  RecCount := FileSize(INf);
  n := 0;
  while not(eof(INf)) do
  begin
    read(INf, OneRec);
    inc(n);
    if (OneRec.ausfuehren_ist_Datum = cMonDa_Status_Restant) then
    begin
      with Auftrag do
      begin
        ParamByName('CROSSREF').AsInteger := OneRec.RID;
        ApiFirst;
        if not(eof) then
        begin

          _Status := FieldByName('STATUS').AsInteger;
          _MondaSchutz := (FieldByName('MONDA_SCHUTZ').AsString = 'Y');

          if (_Status = ord(ctsRestant)) then
          begin
            _result := 'OK (echter Restat)';
          end
          else
          begin
            _result := ' eigentlich ' + cPhasenStatusText[_Status] + ' ' + FieldByName('AUSFUEHREN').AsString + ' ' +
              FieldByName('ZAEHLER_WECHSEL').AsString;
          end;
          if _MondaSchutz then
            _result := _result + ' Keine weiteren Eingaben möglich!';

        end
        else
        begin
          _result := 'bitte als "unmögl" markieren!';
        end;

        DebugF.add(inttostr(n) + '/' + inttostr(RecCount) + ' ' + OneRec.Monteur + ' ' + OneRec.Art + '-' +
          OneRec.zaehlernummer_alt + ': ->' + _result);

      end;
    end;
  end;
  Auftrag.close;
  Auftrag.free;
  CloseFile(INf);
  DebugF.SaveToFile(DiagnosePath + 'Restaten.txt');
  DebugF.free;
  InfoF.free;
  EndHourGlass;
  openShell(DiagnosePath + 'Restaten.txt');
end;

procedure TFormAuftragMobil.Button5Click(Sender: TObject);
var
  INf: file of TMDErec;
  OneRec: TMDErec;
  DebugF: TStringList;
  InfoF: TStringList;
  deletecount: integer;
begin
  //
  BeginHourGlass;
  DebugF := TStringList.create;
  InfoF := TStringList.create;
  AssignFile(INf, AuftragMobilServerPath + 'AUFTRAG.' + ComboBox2.Text + '.DAT');
  reset(INf);
  while not(eof(INf)) do
  begin
    read(INf, OneRec);
    DebugF.add(inttostr(OneRec.RID));
  end;
  CloseFile(INf);
  DebugF.sort;
  removeduplicates(DebugF, deletecount, InfoF);
  InfoF.SaveToFile(DiagnosePath + 'Doppelte.txt');
  DebugF.free;
  InfoF.free;
  EndHourGlass;

  //
  openShell(DiagnosePath + 'Doppelte.txt');
end;

procedure TFormAuftragMobil.RefreshGeraeteAuswahl;
var
  n: integer;
  AllGeraete: TStringList;
begin
  AllGeraete := TStringList.create;
  dir(AuftragMobilServerPath + 'AUFTRAG.???.DAT', AllGeraete, false);
  AllGeraete.sort;
  ComboBox2.Items.clear;
  for n := 0 to pred(AllGeraete.count) do
    ComboBox2.Items.add(nextp(AllGeraete[n], '.', 1));
  AllGeraete.free;
end;

procedure TFormAuftragMobil.SpeedButton2Click(Sender: TObject);
begin
  openShell(DiagnosePath);
end;

procedure TFormAuftragMobil.Log(s: string);
begin
  if pos(cERRORText, s) > 0 then
    AppendStringsToFile(s,
      {} ErrorFName('ERGEBNIS'),
      {} Uhr8);
end;

procedure TFormAuftragMobil.Button6Click(Sender: TObject);
begin
  openShell(MdePath + 'Index.html');
end;

end.
