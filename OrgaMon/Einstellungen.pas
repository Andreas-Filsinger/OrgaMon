{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007  Andreas Filsinger
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
unit Einstellungen;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls,
  StdCtrls, Grids,

  // IBObjects
  IB_Access,
  IB_UpdateBar,
  IB_NavigationBar,
  IB_SearchBar,
  IB_Components,
  IB_Controls,
  IB_Grid,
  Datenbank,

  //
  Buttons;

type
  TFormEinstellungen = class(TForm)
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    Label1: TLabel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    Button1: TButton;
    IB_UpdateBar1: TIB_UpdateBar;
    Image2: TImage;
    IB_Memo1: TIB_Memo;
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
    procedure SetContext(Setting: string);
  end;

var
  FormEinstellungen: TFormEinstellungen;

implementation

uses
 clipbrd, anfix32, globals,
 CareTakerClient, Funktionen_Basis, wanfix32;

{$R *.DFM}

procedure TFormEinstellungen.FormActivate(Sender: TObject);
var
  sDefaultSettings: TStringList;
begin
  with IB_Query1 do
  begin
    if not(Active) then
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

      // Hinweis für die Benutzer geben "wie" lokalisierte Parameter
      // funktionieren
      FormEinstellungen.Caption := 'Einstellungen.'+UserName+'@'+ComputerName;
    end;
  end;
end;

procedure TFormEinstellungen.IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
begin
 ShowMessage( 'Änderungen werden erst nach einem Neustart von ' +
    cApplicationName + ' wirksam!');
end;

procedure TFormEinstellungen.Button1Click(Sender: TObject);
begin
  openShell(MyProgramPath + cIniFName);
end;

procedure TFormEinstellungen.Edit1KeyPress(Sender: TObject; var Key: Char);
var
 p : string;
begin
  if (Key = #13) then
  begin
    Key := #0;
    if (Edit1.text = 'decode') then
    begin
      Edit1.PasswordChar := #0;
      Edit1.text := deCrypt_Hex(iDataBasePassword);
    end
    else
    begin
      p := enCrypt_Hex(Edit1.text);
      Edit1.text := '';
      clipboard.AsText := p;
      ShowMessage('Das verschlüsselte Passwort' + #13#10 + p + #13#10 + 'wurde in die Zwischenablage kopiert!');
    end;
  end;
end;

procedure TFormEinstellungen.FormCreate(Sender: TObject);
const
  cCmdLine = '--password=';
var
  n: integer;
begin
  StartDebug('Einstellungen');
  Button1.Caption := cIniFName;
  for n := 1 to ParamCount do
    if pos(cCmdLine, ParamStr(n)) = 1 then
      AppendStringsToFile(cDataBasePwd + '=' + enCrypt_Hex
        (nextp(ParamStr(n), cCmdLine, 1)), DiagnosePath + 'password.txt');
end;

procedure TFormEinstellungen.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Systemeinstellungen');
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
      if pos(Setting + '=', Lines[n]) = 1 then
      begin
        Col := length(Setting) + 1;
        SelStart := SendMessage(Handle, EM_LINEINDEX, n, 0) + Col;
        SendMessage(Handle, EM_SCROLLCARET, 0, 0);
        break;
      end;
  end;
end;

end.
