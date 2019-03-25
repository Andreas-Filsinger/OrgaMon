{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2019  Andreas Filsinger
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
unit AuftragErgebnis;

interface

uses
  Windows, Messages, SysUtils,
  Buttons, ExtCtrls, Variants,
  Classes, Graphics, Controls,
  Forms, Dialogs, ComCtrls,
  StdCtrls,

  // FlexCell
  FlexCel.Core, FlexCel.xlsAdapter,

  // Indy
  IdComponent, IdFTP,

  // Anfix
  SolidFTP,
  gplists;

type
  TFormAuftragErgebnis = class(TForm)
    Button1: TButton;
    ProgressBar1: TProgressBar;
    ListBox1: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    ProgressBar2: TProgressBar;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    RadioButton1: TRadioButton;
    RadioButton3: TRadioButton;
    ComboBox1: TComboBox;
    CheckBox1: TCheckBox;
    Label4: TLabel;
    Button2: TButton;
    CheckBox2: TCheckBox;
    SpeedButton1: TSpeedButton;
    Image2: TImage;
    Memo1: TMemo;
    Label1: TLabel;
    CheckBox3: TCheckBox;
    Edit2: TEdit;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Label5: TLabel;
    CheckBox6: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
  private
    { Private-Deklarationen }



    // FTP
    procedure IdFTP1Status(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
    procedure IdFTP1BannerAfterLogin(ASender: TObject; const AMsg: string);
    procedure IdFTP1BannerBeforeLogin(ASender: TObject; const AMsg: string);

    //
    procedure Log(s: string; BAUSTELLE_R: integer = 0; TAN: string = ''); overload;
    procedure Log(s: TStrings; BAUSTELLE_R: integer = 0; TAN: string = ''); overload;
    function AUFTRAG_R: integer;
    function EinzelMeldeErlaubnis: boolean;

  public
    { Public-Deklarationen }
    procedure SetDefaults(ResetRadioButton: boolean);
  end;

var
  FormAuftragErgebnis: TFormAuftragErgebnis;

implementation

uses
  // lib
  anfix32, globals, OrientationConvert,
  CareTakerClient, Sperre, PEM,
  wanfix32, html, c7zip, WordIndex,

  // IBO
  IB_Components, IB_Access,

  // OrgaMon-Core
  dbOrgaMon,

  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  Funktionen_Transaktion,
  Funktionen_App,

  // Forms
  Bearbeiter, AuftragArbeitsplatz, Datenbank,
  Mapping;

{$R *.dfm}

function FeedBack (key : Integer; value : string = '') : Integer;
begin
 with FormAuftragErgebnis do
 begin
   case Key of
    1:;
    cFeedBack_Function : result := AUFTRAG_R;
   end;
 end;
end;


procedure TFormAuftragErgebnis.Button1Click(Sender: TObject);
var
  CloseLater: boolean;
  ResultIs: boolean;

begin
  Button1.enabled := false;
  FormAuftragArbeitsplatz.InvalidateCache_ProblemInfos;
  CloseLater := false;
  if not(active) then
  begin
    Show;
    CloseLater := true;
  end;
  BeginHourGlass;
  ResultIs := e_w_Ergebnis(-1, CheckBox6.checked, FeedBack);
  Button1.enabled := true;
  SetDefaults(false);
  EndHourGlass;
  if ResultIs and CloseLater then
    close;
end;

procedure TFormAuftragErgebnis.Log(s: string; BAUSTELLE_R: integer = 0; TAN: string = '');
begin
  if (BAUSTELLE_R > 0) then
    s := s + ' ' + e_r_BaustelleKuerzel(BAUSTELLE_R);
  if (TAN <> '') then
    s := s + ' ' + TAN;
  ListBox1.items.add(s);
  ListBox1.itemindex := pred(ListBox1.items.count);
  application.processmessages;
  AppendStringsToFile(s, DiagnosePath + 'Export_' + inttostrN(HugeTransactionN, 6) + '.csv');
end;

procedure TFormAuftragErgebnis.Log(s: TStrings; BAUSTELLE_R: integer = 0; TAN: string = '');
var
  n: integer;
begin
  for n := 0 to pred(s.count) do
  begin
    if (pos(cE_ZIPPASSWORD, s[n]) = 1) then
      continue;
    if (pos(cE_FTPPASSWORD, s[n]) = 1) then
      continue;
    Log(s[n], BAUSTELLE_R, TAN);
  end;
end;

procedure TFormAuftragErgebnis.SetDefaults(ResetRadioButton: boolean);
begin
  if ResetRadioButton then
  begin
    RadioButton1.checked := true;
    Edit1.Text := '';
    Edit1.enabled := false;
    ComboBox1.itemindex := -1;
    ComboBox1.enabled := false;
  end;
  CheckBox1.checked := false;
  CheckBox2.checked := false;
  CheckBox3.checked := false;
  Memo1.lines.clear;
end;

procedure TFormAuftragErgebnis.RadioButton3Click(Sender: TObject);
begin
  ComboBox1.enabled := RadioButton3.checked;
end;

procedure TFormAuftragErgebnis.CheckBox4Click(Sender: TObject);
begin
  Edit1.enabled := CheckBox4.checked;
end;

procedure TFormAuftragErgebnis.CheckBox5Click(Sender: TObject);
begin
  Edit2.enabled := CheckBox5.checked;
  if CheckBox5.checked then
    CheckBox3.checked := true;
end;

procedure TFormAuftragErgebnis.ComboBox1DropDown(Sender: TObject);
var
  AllTheBaustellen: TStringList;
  cBAUSTELLE: TIB_Cursor;
begin
  BeginHourGlass;
  AllTheBaustellen := TStringList.create;
  cBAUSTELLE := DataModuleDatenbank.nCursor;
  with cBAUSTELLE do
  begin
    sql.add('select NUMMERN_PREFIX from BAUSTELLE where EXPORT_TAN is not null');
    ApiFirst;
    while not(eof) do
    begin
      AllTheBaustellen.add(Fields[0].AsString);
      ApiNext;
    end;
  end;
  cBAUSTELLE.free;
  AllTheBaustellen.sort;
  ComboBox1.items.Assign(AllTheBaustellen);
  AllTheBaustellen.free;
  EndHourGlass;
end;

procedure TFormAuftragErgebnis.Button2Click(Sender: TObject);
begin
  SetDefaults(true);
end;

function TFormAuftragErgebnis.AUFTRAG_R: integer;
begin
  if (Edit1.Text <> '') and CheckBox4.checked then
    result := StrToIntDef(Edit1.Text, 0)
  else
    result := 0;
end;

function TFormAuftragErgebnis.EinzelMeldeErlaubnis: boolean;
begin
  result := not(CheckBox2.checked);
end;

procedure TFormAuftragErgebnis.FormCreate(Sender: TObject);
begin
  Stat_Attachments := TStringList.create;
  IdFTP1 := TIdFtpRestart.create(self);
  with IdFTP1 do
  begin
    OnStatus := IdFTP1Status;
    OnBannerAfterLogin := IdFTP1BannerAfterLogin;
    OnBannerBeforeLogin := IdFTP1BannerBeforeLogin;
  end;
  FlexCelXLS := TXLSFile.create(true);
end;

procedure TFormAuftragErgebnis.IdFTP1BannerAfterLogin(ASender: TObject; const AMsg: string);
begin
  Log(AMsg);
end;

procedure TFormAuftragErgebnis.IdFTP1BannerBeforeLogin(ASender: TObject; const AMsg: string);
begin
  Log(AMsg);
end;

procedure TFormAuftragErgebnis.IdFTP1Status(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
begin
  Log(AStatusText);
end;

procedure TFormAuftragErgebnis.Image2Click(Sender: TObject);
begin
  //
  openShell(cHelpURL + 'Export');
end;

procedure TFormAuftragErgebnis.SpeedButton1Click(Sender: TObject);
begin
  openShell(cAuftragErgebnisPath);
end;

end.
