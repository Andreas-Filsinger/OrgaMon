unit InstallComponent;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  globals, splash;

type
  TInstallForm = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure ActualiseDataNoten;
    procedure ActualiseDataKatalog;
  end;

var
  InstallForm: TInstallForm;

implementation

{$R *.DFM}

uses
  winamp, anfix32, wanfix32;

procedure TInstallForm.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TInstallForm.Button1Click(Sender: TObject);
var
  ExecuteStr: array[0..1024] of char;
begin
  close;
  application.ProcessMessages;

 // Installation von Quick-Time
  if (CheckBox1.state <> cbUnchecked) then
  begin
    StrPCopy(ExecuteStr, MyProgramPath + '\install\QTwin32\qt32.exe');
    OpenShell(ExecuteStr, sw_show);
  end;

 // Installation von Immedia
  if (CheckBox2.state <> cbUnchecked) then
  begin
    StrPCopy(ExecuteStr, MyProgramPath + '\install\immedia\install.exe');
    OpenShell(ExecuteStr, sw_show);
  end;

 // Installation von WinAmp
  if (CheckBox3.state <> cbUnchecked) then
  begin
    StrPCopy(ExecuteStr, MyProgramPath + '\install\winamp\winamp.exe');
    OpenShell(ExecuteStr, sw_show);
  end;

end;

procedure TInstallForm.ActualiseDataNoten;
begin
  CheckBox1.state := cbunchecked;
  CheckBox2.state := cbunchecked;
  CheckBox3.state := cbunchecked;
  CheckBox1.visible := false;
  CheckBox2.visible := false;
  CheckBox3.visible := true;
  if SoundCardInstalled then // SoundCardInstalled
    CheckBox3.state := TCheckBoxState(not (FileExists('C:\program files\winamp\winamp.exe') and
      not (FileExists('C:\programme\winamp\winamp.exe'))))
  else
    CheckBox3.state := cbunchecked;
end;

procedure TInstallForm.ActualiseDataKatalog;
begin
  CheckBox1.state := cbunchecked;
  CheckBox2.state := cbunchecked;
  CheckBox3.state := cbunchecked;
  CheckBox1.visible := true;
  CheckBox2.visible := true;
  CheckBox3.visible := false;
  CheckBox1.state := TCheckBoxState(not (FileExists(SystemRoot + '\PLAY32.EXE')));
  CheckBox2.state := TCheckBoxState(not (FileExists('C:\immedia\immedia.exe')));
end;

procedure TInstallForm.FormCreate(Sender: TObject);
begin
  top := (screen.height div 2) - (height div 2);
  left := (screen.width div 2) - (width div 2);
end;

procedure TInstallForm.FormActivate(Sender: TObject);
begin
  button2.caption := LanguageStr[pred(26)];
  button1.caption := LanguageStr[pred(61)];
  label1.caption := LanguageStr[pred(62)];
end;

end.
