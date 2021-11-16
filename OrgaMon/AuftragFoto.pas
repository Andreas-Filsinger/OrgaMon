{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2021  Andreas Filsinger
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
unit AuftragFoto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  JvComponentBase, JvFormPlacement;

type
  TFormAuftragFoto = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    SpeedButton19: TSpeedButton;
    JvFormStorage1: TJvFormStorage;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    SpeedButton16: TSpeedButton;
    SpeedButton22: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SpeedButton19Click(Sender: TObject);
    procedure SpeedButton16Click(Sender: TObject);
    procedure SpeedButton22Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton1DblClick(Sender: TObject);
  private
    { Private-Deklarationen }
    _Fotos: TStringList;
    ItemIndex: Integer; // -1,0..pred(_Fotos.Count)

    procedure ReflectData;
  public
    { Public-Deklarationen }
    procedure setContext(Fotos: TStringList);
  end;

var
  FormAuftragFoto: TFormAuftragFoto;

implementation

{$R *.dfm}

uses
 main, anfix, wanfix,
 clipbrd;

procedure TFormAuftragFoto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
 _ItemIndex : INteger;
begin
 _ItemIndex := ItemIndex;
 repeat

   if (Key=VK_ESCAPE) then
   begin
     Key := 0;
     close;
     break;
   end;

   if (Key=VK_UP) or (Key=VK_RIGHT) then
   begin
    Key := 0;
    inc(ItemIndex);
    if (ItemIndex>=_Fotos.Count) then // bounce
    begin
     dec(ItemIndex);
     Beep;
    end;
    break;
   end;

   if (Key=VK_DOWN) or (Key=VK_LEFT) then
   begin
    Key := 0;
    dec(ItemIndex);
    if (ItemIndex<-1) or ((ItemIndex=-1) and (_Fotos.Count>0)) then // bounce
    begin
     inc(ItemIndex);
     Beep;
    end;
    break;
   end;

 until yet;
 if (_ItemIndex<>ItemIndex) then
  ReflectData;
end;

procedure TFormAuftragFoto.setContext(Fotos: TStringList);
begin
 _Fotos := TStringList.Create;
 _Fotos.AddStrings(Fotos);
 if (_Fotos.Count=0) then
  ItemIndex := -1
 else
  ItemIndex := 0;
 ReflectData;
 show;
end;

procedure TFormAuftragFoto.SpeedButton16Click(Sender: TObject);
begin
 openShell(label3.Caption);
end;

procedure TFormAuftragFoto.SpeedButton19Click(Sender: TObject);
begin
 // Ordner öffnen
 if (label3.Caption <> '') then
  openShell(ExtractFilePath(Label3.Caption));
end;

procedure TFormAuftragFoto.SpeedButton1Click(Sender: TObject);
begin
  clipboard.AsText :=
   ExtractFileName(label3.Caption);
end;

procedure TFormAuftragFoto.SpeedButton1DblClick(Sender: TObject);
begin
  clipboard.AsText :=
   label3.Caption;
end;

procedure TFormAuftragFoto.SpeedButton22Click(Sender: TObject);
begin
  ReflectData;
end;

procedure TFormAuftragFoto.ReflectData;
var
 Parameter, OrgFName, FullFName: string;
begin
  if (ItemIndex=-1) then
  begin
   label1.Caption := '';
   label2.Caption := '';
   label3.Caption := '';
   label4.Caption := '0/0';
   Image1.visible := false;
  end else
  begin
   Parameter := nextp(_Fotos[ItemIndex],';',0);
   OrgFName := nextp(_Fotos[ItemIndex],';',1);
   FullFName := nextp(_Fotos[ItemIndex],';',2);
   label1.Caption := Parameter;
   label2.Caption := OrgFName;
   label3.Caption := FullFName;
   label4.Caption := IntTostr(succ(ItemIndex))+'/'+IntToStr(_Fotos.Count);
   if (FullFname<>'') and FileExists(FullFname) then
   begin
    Image1.Picture.LoadFromFile(FullFName);
    Image1.visible := true;
   end else
   begin
    Image1.visible := false;
   end;
  end;
end;


end.
