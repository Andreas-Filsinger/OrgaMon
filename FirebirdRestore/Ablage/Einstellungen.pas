//
// firebird - unified
//
// Projekteinstellungen
//
unit Einstellungen;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls,
  StdCtrls, Grids,

  // IBObjects
  IB_UpdateBar,
  IB_NavigationBar,
  IB_SearchBar,
  IB_Components,
  IB_Controls,
  IB_Grid,
{$IFDEF HeBuAdmin}
  HebuData,
{$ENDIF}

  //
  DCPcrypt2, DCPblockciphers, DCPblowfish,
  Buttons;

const
  cSettings_SysdbaPAssword = 'SysdbaPasswort';

type
  TFormEinstellungen = class(TForm)
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Memo1: TIB_Memo;
    Label1: TLabel;
    Edit1: TEdit;
    DCP_blowfish1: TDCP_blowfish;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    Button1: TButton;
    IB_UpdateBar1: TIB_UpdateBar;
    Image2: TImage;
    procedure FormActivate(Sender: TObject);
    procedure IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    CryptKey: array[0..1023] of char;
    CryptKeyLength: integer;

    function enCrypt(s: string): string;
    function deCrypt(s: string): string;
    function SysDBApassword: string;
    procedure SetContext(Setting: string);
  end;

var
  FormEinstellungen: TFormEinstellungen;

implementation

uses
  anfix32, globals, CareTakerClient;

{$R *.DFM}

procedure TFormEinstellungen.FormActivate(Sender: TObject);
var
  sDefaultSettings: TStringList;
begin
  with IB_query1 do
  begin
    if not (Active) then
    begin
      Open;
      if IsEmpty then
      begin
        sDefaultSettings := TStringList.create;
        sDefaultSettings.Add('');
        insert;
        FieldByName('SETTINGS').Assign(sDefaultSettings);
        post;
        sDefaultSettings.free;
      end;
    end;
  end;
end;

procedure TFormEinstellungen.IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
begin
  label2.Caption :=
    'Änderungen werden erst nach einem Neustart von ' + cApplicationName + ' wirksam!';
end;

procedure TFormEinstellungen.Button1Click(Sender: TObject);
begin
  open(MyProgramPath + cIniFName);
end;

procedure TFormEinstellungen.Edit1KeyPress(Sender: TObject; var Key: Char);
var
  sSettings: TStringlist;
begin
  if (key = #13) then
  begin
    key := #0;
    if (edit1.text = 'decode') then
    begin
      edit1.PasswordChar := #0;
      edit1.text := SysDBApassword;
    end else
    begin
      sSettings := TStringlist.create;
      IB_Query1.FieldByName('SETTINGS').AssignTo(sSettings);
      sSettings.values[cSettings_SysdbaPassword] := enCrypt(edit1.text);
      edit1.text := '';
      IB_Query1.FieldByName('SETTINGS').Assign(sSettings);
      sSettings.free;
    end;
  end;
end;

function TFormEinstellungen.deCrypt(s: string): string;
begin
  with DCP_blowfish1 do
  begin
    Init(CryptKey, CryptKeyLength, nil);
    result := cutrblank(decryptstring(hexstr2bin(s)));
  end;
end;

function TFormEinstellungen.enCrypt(s: string): string;
begin
  with DCP_blowfish1 do
  begin
    Init(CryptKey, CryptKeyLength, nil);
    result := bin2hexstr(encryptstring(s + fill(' ', 16 - length(s))));
  end;
end;

procedure TFormEinstellungen.FormCreate(Sender: TObject);
const
  cKey = 'anfisoft' + cApplicationName;
  cCmdLine = '--password=';
var
  n: integer;
begin
  button1.Caption := cIniFName;
  CryptKey := cKey;
  CryptKeyLength := length(cKey) * 8;
  for n := 1 to ParamCount do
    if pos(cCmdLine, ParamStr(n)) = 1 then
      AppendStringsToFile(
        cDataBasePwd +
        '=' +
        enCrypt(nextp(ParamStr(n), cCmdLine, 1)),
        DiagnosePath + 'password.txt');
end;

function TFormEinstellungen.SysDBApassword: string;
var
  cEINSTELLUNGEN: TIB_Cursor;
  Settings: TStringList;
begin
  cEINSTELLUNGEN := TIB_Cursor.create(self);
  with cEINSTELLUNGEN do
  begin
    sql.add('select * from EINSTELLUNG');
    ApiFirst;
    Settings := TStringList.create;
    FieldByNAme('SETTINGS').AssignTo(Settings);
    result := Settings.values[cSettings_SysdbaPAssword];
    if (result = '') then
      result := 'masterkey'
    else
      result := deCrypt(result);
    Settings.free;
  end;
  cEINSTELLUNGEN.free;
end;

procedure TFormEinstellungen.Image2Click(Sender: TObject);
begin
  open(cHelpURL + 'Systemeinstellungen');
end;

procedure TFormEinstellungen.SetContext(Setting: string);
var
  n: integer; // tmemo
  Col: integer;
begin
  show;
  with IB_Memo1 do
  begin
    for n := 0 to pred(Lines.count) do
      if pos(Setting + '=', lines[n]) = 1 then
      begin
        Col := length(Setting) + 1;
        SelStart := SendMessage(Handle, EM_LINEINDEX, n, 0) + Col;
        SendMessage(handle, EM_SCROLLCARET, 0, 0);
        break;
      end;
  end;
end;

end.

