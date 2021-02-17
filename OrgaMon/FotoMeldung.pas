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
unit FotoMeldung;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormFotoMeldung = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Button1: TButton;
    Button2: TButton;
    ListBox1: TListBox;
    Edit3: TEdit;
    Label4: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    TAN: string;

    procedure Log(s: string);

    function TAN_FName: string;
    procedure save_TAN;
    procedure load_TAN;
    procedure new_TAN;
    procedure ensure_TAN;

    procedure proceed;
    function checkMeldung(sREST: TStringList): Boolean;
    function prefixMDE: string;
    function toProtokoll(NewName: string): string;
    function GeraetOK: Boolean;
    procedure MoveManuell;

  public
    { Public-Deklarationen }
  end;

var
  FormFotoMeldung: TFormFotoMeldung;

implementation

uses
  globals, REST, CareTakerClient,
  anfix, wanfix;
{$R *.dfm}

procedure TFormFotoMeldung.proceed;
var
  sREST: TStringList;
begin
  sREST := DataModuleREST.REST(
    { host } 'http://orgamon.de/up.php?' +
    { proceed } 'proceed=' + TAN);
  sREST.free;
  FileDelete(TAN_FName);

  openShell('http://orgamon.de/JonDaServer/Info/' + edit3.text + '.html');
  edit3.Text := '';
end;

procedure TFormFotoMeldung.new_TAN;
var
  sREST: TStringList;
begin
  if GeraetOK then
  begin

    // versuchen eine TAN zu erhalten
    sREST := DataModuleREST.REST(
      { host } 'http://orgamon.de/up.php?' +
      { id } 'id=' +
      { Geräte ID } Edit3.text + ';' +
      { letzte TAN } '00000' + ';' +
      { Programm-Version } RevToStr(globals.Version) + ';' +
      { Optionen } 'Foto' + ';' +
      { Timestamp } Datum10 + ' - ' + Uhr8);

    TAN := ExtractSegmentBetween(HugeSingleLine(sREST, ''), '<BODY>',
      '</BODY>', true);
    sREST.free;

    if (length(TAN) <> 5) then
    begin
      ShowMessage(TAN);
      TAN := '';
    end
    else
    begin
      Log('neue TAN ' + TAN + ' erhalten!');
      save_TAN;
    end;
  end;
end;

procedure TFormFotoMeldung.Button1Click(Sender: TObject);
begin
  proceed;
end;

procedure TFormFotoMeldung.Button2Click(Sender: TObject);
begin
  MoveManuell;
  edit1.Text := '';
end;

function TFormFotoMeldung.checkMeldung(sREST: TStringList): Boolean;
begin
  if assigned(sREST) then
    result := (pos('<BODY>OK</BODY>', HugeSingleLine(sREST, '')) > 0)
  else
    result := false;
end;

procedure TFormFotoMeldung.Edit3Change(Sender: TObject);
begin
  ensure_TAN;
end;

procedure TFormFotoMeldung.ensure_TAN;
begin
  if GeraetOK then
  begin
    if FileExists(TAN_FName) then
      load_TAN
    else
      new_TAN;
  end
  else
  begin
    TAN := '';
  end;
  Label1.Caption := TAN;
end;

function TFormFotoMeldung.prefixMDE: string;
begin
  result :=
  { RID } Edit1.text +
  { Leerfelder } ';;;;;;;';
end;

function TFormFotoMeldung.toProtokoll(NewName: string): string;
begin
  result :=
  { Neuer Bilddateiname } NewName + ',' +
  { Datum } ',' +
  { Uhr } ',' +
  { FileSize } '';
end;

procedure TFormFotoMeldung.MoveManuell;
var
  iBild, iWechsel: Integer;
  NewNameA: string;
  MeldungsZeile: string;
  sREST: TStringList;
  BildContext: string;
begin

  if (TAN <> '') and (edit1.Text<>'') then
  begin

    // Meldung erstellen
    if RadioButton1.checked then
      BildContext := 'FA'
    else
      BildContext := 'FN';

    MeldungsZeile := prefixMDE + BildContext + '=' + toProtokoll(Edit2.text);
    Log(MeldungsZeile);

    // Melden
    sREST := DataModuleREST.REST(
      { host } 'http://orgamon.de/up.php?' +
      { TAN } 'tan=' + TAN + '&' +
      { data } 'data=' + MeldungsZeile);

    if checkMeldung(sREST) then
    begin
      // gut!
    end
    else
    begin
      Log(cERRORText + ' Meldung ging schief!');
    end;

    sREST.free;
  end
  else
  begin
    Log(cERRORText + ' keine TAN erhalten!');
  end;
end;

procedure TFormFotoMeldung.FormActivate(Sender: TObject);
begin
  ensure_TAN;

end;

function TFormFotoMeldung.GeraetOK: Boolean;
begin
  result :=
  { Länge 3 } (length(Edit3.text) = 3) and
  { numerisch } (StrFilter(Edit3.text, cZiffern) = Edit3.text) and
  { <>'000' } (Edit3.text <> '000');
end;

procedure TFormFotoMeldung.load_TAN;
var
  s: TStringList;
begin
  s := TStringList.create;
  s.LoadFromFile(TAN_FName);
  TAN := s.Values['TAN'];
  Log('verwende die TAN ' + TAN + ' weiter');
  s.free;
end;

procedure TFormFotoMeldung.Log(s: string);
begin
  ListBox1.Items.Add(s);
end;

procedure TFormFotoMeldung.save_TAN;
var
  s: TStringList;
begin
  s := TStringList.create;
  s.Values['TAN'] := TAN;
  s.saveToFile(TAN_FName);
  s.free;
end;

function TFormFotoMeldung.TAN_FName: string;
begin
  result := AnwenderPath + 'TAN.ini';
end;

end.
