unit BenutzerWechsel;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TBenutzerWechselForm = class(TForm)
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Kurzbezeichnung: TLabel;
    Passwort: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    pwds: TStringList;
    function PwdFName: string;
  end;

var
  BenutzerWechselForm: TBenutzerWechselForm;

implementation

uses
  globals, BesucherListe, anfix32;

{$R *.DFM}

procedure TBenutzerWechselForm.FormActivate(Sender: TObject);
begin
  if FileExists(PwdFName) then
    pwds.LoadFromFile(PwdFName);
  ComboBox1.Text := iPfoertnerKurzBez;
  edit1.Text := '';
  edit2.Text := '';
  edit3.Text := '';
  ComboBox1.SetFocus;
end;

procedure TBenutzerWechselForm.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TBenutzerWechselForm.FormCreate(Sender: TObject);
var
  AllNames: string;

  function NextP: string;
  var
    k: integer;
  begin
    k := pos(',', AllNames);
    if k = 0 then
    begin
      result := AllNames;
      AllNames := '';
    end else
    begin
      result := copy(AllNames, 1, pred(k));
      delete(AllNames, 1, k);
    end;
  end;

begin
  pwds := TStringList.create;
  ComboBox1.Items.clear;
  AllNames := iZulassung;
  repeat
    ComboBox1.Items.Add(NextP);
  until (AllNames = '');
end;

procedure TBenutzerWechselForm.FormKeyPress(Sender: TObject;
  var Key: Char);
begin

  if Key = #13 then
  begin
    Key := #0;
    if Combobox1.Focused then
      edit1.SetFocus
    else
      Button1Click(Sender);
  end;

end;

procedure TBenutzerWechselForm.Button1Click(Sender: TObject);
var
  CheckStr: string;
  NameOK: boolean;
  PwdOK: boolean;
  n: integer;
  _pwd: string;

  Logon_UserName: array[0..1023] of char;
  Logon_PAssword: array[0..1023] of char;
  Logon_Domain: array[0..1023] of char;
  UserHandle: THandle;

  _LastError: dword;

  function NetCheckUserPassword(const User, Domain, Password:
    string): Boolean;
  var
    userHandle: THandle;
    hToken: THandle;
    tkp, p: TTokenPrivileges;
    RetLen: DWORD;
    Reply: Integer;
  begin
    result := False;
    if OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or
      TOKEN_QUERY, hToken) then
    begin
      if LookupPrivilegeValue(nil, 'SeTcbPrivilege', tkp.Privileges[0].Luid)
        then
      begin
        tkp.PrivilegeCount := 1;
        tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;

        AdjustTokenPrivileges(hToken, False, tkp, SizeOf(TTokenPrivileges), p, RetLen);
        Reply := GetLastError;
        if Reply = ERROR_SUCCESS then
        begin
          if
            LogonUser(PChar(User), PChar(Domain), PChar(Password), LOGON32_LOGON_NETWORK, LOGON32_PROVIDER_DEFAULT, UserHandle) then
          begin
            Result := True;
            CloseHandle(userHandle)
          end
        end;
      end;
    end;
  end;

begin
  NameOK := false;
  PwdOK := false;
  while true do
  begin

  { 1. prüfen, ob NAME gültig }
    CheckStr := AnsiUpperCase(Combobox1.Text);
    if length(CheckStr) < 2 then
    begin
      ShowMessage('Geben Sie bitte ein gültiges Kürzel ein!' + #13 +
        'Zumindest zwei Zeichen!' + #13 +
        'Groß/ Kleinschreibung spielt keine Rolle!');
      Combobox1.setfocus;
      break;
    end;

    for n := 0 to pred(Combobox1.items.count) do
      if (CheckStr = ComboBox1.items[n]) then
      begin
        NameOK := true;
        break;
      end;

    if not (NameOK) then
    begin
      ShowMessage(CheckStr + ' ist hier nicht zugelassen!' + #13 +
        'Prüfen Sie die Schreibweise!' + #13 +
        'Lassen Sie dieses Kürzel durch den System Administrator freischalten!');
      ComboBox1.SetFocus;
      break;
    end;

    _pwd := cutblank(StrDecode(pwds.Values[CheckStr], CheckStr));
    PwdOK := (edit1.Text = _pwd) or (edit1.Text = cPwdSuperVisor);

    if not (PwdOK) then
    begin
      ShowMessage('Kombination Kürzel / Passwort ist falsch!');
      edit1.SetFocus;
      break;
    end else
    begin
      Combobox1.Text := CheckStr;

      if (edit2.Text <> '') then
      begin
        if (edit2.Text <> edit3.Text) then
        begin
          ShowMessage('Neues Passwort stimmt mit der Kontrolleingabe nicht überein!' + #13 +
            'Geben Sie bitte beide identisch ein!');
          edit2.Text := '';
          break;
        end else
        begin
          pwds.Values[CheckStr] := StrEncode(edit2.Text + fill(' ', 32 - length(edit2.Text)), CheckStr);
          pwds.SaveToFile(PwdFName);
        end;
      end;
    end;
    break;

  end;
  if NameOK and PwdOK then
  begin
    BesucherListeForm.NeuerAnwender(ComboBox1.Text);
    close;
  end;
end;

procedure TBenutzerWechselForm.ComboBox1Change(Sender: TObject);
var
  n: integer;
  CheckStr: string;
begin
  if (combobox1.Text <> '') and not (combobox1.DroppedDown) then
  begin
    CheckStr := AnsiUpperCase(Combobox1.Text);
    for n := 0 to pred(Combobox1.items.count) do
      if (CheckStr = ComboBox1.items[n]) then
      begin
        edit1.SetFocus;
        break;
      end;
  end;
end;

procedure TBenutzerWechselForm.ComboBox1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = vk_down then
    ComBoBox1.droppedDown := true;
end;

procedure TBenutzerWechselForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  pwds.SaveToFile(PwdFName);
end;

function TBenutzerWechselForm.PwdFName: string;
begin
  result := MyProgramPath + 'pwds.ini';
end;

end.

