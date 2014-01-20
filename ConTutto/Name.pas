unit Name;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  ExtCtrls, globals, Vcl.Imaging.GIFImg;

type
  TNameForm = class(TForm)
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Button2: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label1: TLabel;
    Button1: TButton;
    Label10: TLabel;
    Label11: TLabel;
    ComboBox1: TComboBox;
    Edit5: TEdit;
    Label18: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    ShowInAnyCase: boolean;
    procedure SetComboBoxEntries;
    procedure AppDown;
  end;

var
  NameForm: TNameForm;

implementation

uses
  splash, anfix32, HauptMenu,
  winamp, verlage;

{$R *.DFM}

procedure TNameForm.FormCreate(Sender: TObject);
begin
 { Single instance! }
 // geht irgendwie nicht oder
 // Nachsehen, ob von CDROM gestartet
  Label1.caption := 'Rev. ' + RevToStr(Version);
  Label5.caption := SerialNumber;
  ComboBox1.Items.Assign(LanguageModes);
  edit1.Text := Name1;
  edit2.Text := Name2;
  edit3.Text := Strasse;
  edit4.Text := PLZOrt;
  edit5.text := PasswordHaendler;
end;

procedure TNameForm.Button2Click(Sender: TObject);
begin
  hide;
  HauptMenue.show;
end;

procedure TNameForm.FormDeactivate(Sender: TObject);
begin
  Name1 := edit1.Text;
  Name2 := edit2.Text;
  Strasse := edit3.Text;
  PLZOrt := edit4.Text;
  PasswordHaendler := edit5.text;
end;

procedure TNameForm.FormActivate(Sender: TObject);
begin
  if not (AppGoesDown) then
  begin
    caption := LanguageStr[pred(120)];
    label7.caption := LanguageStr[pred(121)];
    label2.caption := LanguageStr[pred(108)];
    label3.caption := LanguageStr[pred(109)];
    label4.caption := LanguageStr[pred(110)];
    label8.caption := LanguageStr[pred(122)];
    label9.caption := LanguageStr[pred(123)];
    button1.caption := LanguageStr[pred(26)];
    button2.caption := LanguageStr[pred(100)];
    SetComboBoxEntries;
    edit1.Text := Name1;
    edit2.Text := Name2;
    edit3.Text := Strasse;
    edit4.Text := PLZOrt;
    edit1.SetFocus;
    if HaendlerVersion then
      label18.caption := LanguageStr[pred(27)]
    else
      label18.caption := LanguageStr[pred(125)];
    if not (ShowInAnyCase) then
    begin
     SplashClose;

      if (Name1 <> '') or MesseMode then
        if not (HauptMenue.active) then
          HauptMenue.show;
    end;
  end;
end;

procedure TNameForm.Button1Click(Sender: TObject);
begin
  AppGoesDown := true;
  close;
end;

procedure TNameForm.SetComboBoxEntries;
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

procedure TNameForm.ComboBox1Change(Sender: TObject);
begin
  screen.cursor := crHourGlass;
  LanguageDriver := ComboBox1.text[1];
  UpdateLanguageString;
  FormActivate(Sender);
  screen.cursor := crdefault;
end;

procedure TNameForm.Edit5Change(Sender: TObject);
begin
  PasswordHaendler := edit5.text;
  CheckIfHaendlerVersion;
  if HaendlerVersion then
    label18.caption := LanguageStr[pred(27)]
  else
    label18.caption := LanguageStr[pred(125)];
end;

procedure TNameForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #27) then
  begin
    Button1Click(Sender);
    key := #0;
  end;
end;

procedure TNameForm.AppDown;
begin
 AppGoesDown := true;
 close;
end;

end.

