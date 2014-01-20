unit SystemSettings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, globals, CheckLst;

type
  TSettingForm = class(TForm)
    CheckBox1: TCheckBox;
    Label17: TLabel;
    ComboBox1: TComboBox;
    Button1: TButton;
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label2: TLabel;
    Label15: TLabel;
    Button2: TButton;
    CheckBox2: TCheckBox;
    CheckListBox1: TCheckListBox;
    Label16: TLabel;
    Label10: TLabel;
    Button3: TButton;
    Label18: TLabel;
    Label19: TLabel;
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure SetComboBoxEntry;
  end;

var
  SettingForm: TSettingForm;

implementation

{$R *.DFM}

uses
  anfix32, verlage, Name;

procedure TSettingForm.FormClick(Sender: TObject);
begin
  close;
end;

procedure TSettingForm.FormCreate(Sender: TObject);
begin
  top := (screen.height div 2) - (height div 2);
  left := (screen.width div 2) - (width div 2);
  ComboBox1.Items.Assign(LanguageModes);
end;

procedure TSettingForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = vk_escape) then
    close;
end;

procedure TSettingForm.CheckBox1Click(Sender: TObject);
begin
  if (paramstr(1) = 'demo') then
    exit;
  cUninstall := CheckBox1.checked;
end;

procedure TSettingForm.SetComboBoxEntry;
var
  n: integer;
begin
  ComboBox1.Text := 'D';
  for n := 0 to pred(LanguageModes.count) do
    if pos(LanguageDriver, LanguageModes[n]) = 1 then
    begin
      ComboBox1.Text := LanguageModes[n];
      break;
    end;
end;

procedure TSettingForm.Button1Click(Sender: TObject);
var
  n: integer;

  function bool2crossed(b: boolean): string;
  begin
    if b then
      result := 'X'
    else
      result := ' ';
  end;

begin
  cUninstall := CheckBox1.checked;
  cDeleteRegistry := CheckBox2.checked;
  OwnMedias := '';
  for n := 0 to pred(CheckListBox1.items.count) do
    OwnMedias := OwnMedias + bool2crossed(CheckListBox1.state[n] = cbchecked);
  if cUninstall or cDeleteRegistry then
  begin
   NameForm.AppDown;
  end else
  begin
    if (ComboBox1.text[1] <> LanguageDriver) then
    begin
      // uups, language change!!!
      LanguageDriver := ComboBox1.text[1];
      UpdateLanguageString;

      // ausgabe: restart desktop
      ShowMessage(LanguageStr[pred(89)]);
    end;
    close;
  end;
end;

procedure TSettingForm.FormActivate(Sender: TObject);
var
  n: integer;
begin
  if HaendlerVersion then
    caption := ProjektID + ' Rev ' + RevToStr(Version) + ' ' + LanguageDriver + 'H'
  else
    caption := ProjektID + ' Rev ' + RevToStr(Version) + ' ' + LanguageDriver;

  SetComboBoxEntry;
  label2.caption := LanguageStr[pred(22)];
  label15.caption := LanguageStr[pred(23)];
  label5.caption := LanguageStr[pred(24)];
  label6.caption := LanguageStr[pred(25)];
  button2.caption := LanguageStr[pred(26)];
  label18.caption := 'App: ' + MyProgramPath;
  label19.caption := 'Data: ' + SystemPath;

  checkbox1.caption := LanguageStr[pred(28)];
  checkbox2.caption := LanguageStr[pred(90)];
  label16.Caption := LanguageStr[pred(91)];
  CheckListBox1.items.assign(MusicMedias);
  for n := 0 to pred(CheckListBox1.items.count) do
  begin
    CheckListBox1.items[n] := copy(CheckListBox1.items[n], 1, pred(pos(',', CheckListBox1.items[n])));
    CheckListBox1.state[n] := cbunchecked;
    if length(OwnMedias) > n then
      if OwnMedias[succ(n)] <> ' ' then
        CheckListBox1.state[n] := cbchecked;
  end;
  button3.Caption := LanguageStr[pred(124)];
end;

procedure TSettingForm.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TSettingForm.CheckListBox1ClickCheck(Sender: TObject);
begin
  CheckListBox1.state[0] := cbchecked;
end;

procedure TSettingForm.Button3Click(Sender: TObject);
begin
  NameForm.ShowInAnyCase := true;
  NameForm.show; // settings
end;

end.
