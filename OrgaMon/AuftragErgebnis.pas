{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2022  Andreas Filsinger
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
unit AuftragErgebnis;

interface

uses
  Windows, Messages, SysUtils,
  Buttons, ExtCtrls, Variants,
  Classes, Graphics, Controls,
  Forms, Dialogs, ComCtrls,
  StdCtrls,

  // Anfix
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
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
  private
    { Private-Deklarationen }

  public
    { Public-Deklarationen }
    procedure SetDefaults(ResetRadioButton: boolean);
  end;

var
  FormAuftragErgebnis: TFormAuftragErgebnis;

implementation

uses
  // lib
  anfix, globals, OrientationConvert,
  CareTakerClient, Sperre,
  wanfix, html, c7zip, WordIndex,

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
  result := cFeedBack_CONT;
  with FormAuftragErgebnis do
  begin
    case Key of
     cFeedBack_Log:begin
                    ListBox1.items.add(value);
                    ListBox1.itemindex := pred(ListBox1.items.count);
                   end;
     cFeedBack_ProcessMessages: Application.Processmessages;
     cFeedBack_ProgressBar_Max+1: progressbar1.max := StrToIntDef(value,0);
     cFeedBack_ProgressBar_Position+1: progressbar1.position := StrToIntDef(value,0);
     cFeedBack_ProgressBar_stepit+1: progressbar1.StepIt;
     cFeedBack_ProgressBar_Max+2: progressbar2.max := StrToIntDef(value,0);
     cFeedBack_ProgressBar_Position+2: progressbar2.position := StrToIntDef(value,0);
     cFeedBack_ProgressBar_stepit+2: progressbar2.StepIt;
     cFeedBack_Label+3: label3.caption := value;
     cFeedBack_ListBox_add+1: Listbox1.Items.Add(value);
    else
     ShowMessage('Unbekannter Feedback Key '+IntToStr(Key));
    end;
  end;
end;

procedure TFormAuftragErgebnis.Button1Click(Sender: TObject);
var
  CloseLater: boolean;
  ResultIs: boolean;
  pOptions: TStringList;
  BAUSTELLE_R : Integer;
begin
  Button1.enabled := false;
  FormAuftragArbeitsplatz.InvalidateCache_ProblemInfos;
  pOptions:= TStringList.Create;
  with pOptions do
  begin
    values['TAN_wiederholen'] := bool2cO(CheckBox5.checked);
    values['TAN'] := edit2.Text;
    values['SQL'] := HugeSingleLine(Memo1.lines,' ');
    if CheckBox4.Checked then
     values['AUFTRAG_R'] :=  Edit1.Text;
    values['FTP_Diagnose'] :=  bool2cO(CheckBox1.checked);
    values['Report'] := bool2cO(not(CheckBox2.checked));
    values['TAN_statisch'] := bool2cO(CheckBox3.checked);
    values['Manuell'] := bool2cO(CheckBox6.checked);
  end;

  // Autoclose?
  CloseLater := false;
  if not(active) then
  begin
    Show;
    CloseLater := true;
  end;
  BeginHourGlass;
  if RadioButton3.Checked then
   BAUSTELLE_R := e_r_BaustelleRIDFromKuerzel(ComboBox1.Text)
  else
   BAUSTELLE_R := cRID_unset;

  ResultIs := e_w_Ergebnis(BAUSTELLE_R, pOptions, FeedBack);
  Button1.enabled := true;
  SetDefaults(false);
  EndHourGlass;
  if ResultIs and CloseLater then
    close;
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

procedure TFormAuftragErgebnis.Image2Click(Sender: TObject);
begin
  //
  openShell(cHelpURL + 'Ergebnis');
end;

procedure TFormAuftragErgebnis.SpeedButton1Click(Sender: TObject);
begin
  openShell(cAuftragErgebnisPath);
end;

end.
