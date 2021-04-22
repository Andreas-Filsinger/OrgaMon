{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2011 - 2021  Andreas Filsinger
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
unit ArtikelPOS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CPort, CPortCtl, Vcl.Buttons;

type
  TFormArtikelPOS = class(TForm)
    ComPort1: TComPort;
    ComComboBox1: TComComboBox;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    Edit1: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    function isSerialPort(s:string):boolean;
    procedure Schublade_Auf(sComPort: string);
  end;

var
  FormArtikelPOS: TFormArtikelPOS;

implementation

uses
  anfix, systemd, srvXMLRPC,
  globals;

{$R *.dfm}

function TFormArtikelPOS.isSerialPort(s:string):boolean;
begin
 result := pos('COM',s)=1;
end;

procedure TFormArtikelPOS.FormActivate(Sender: TObject);
begin
  Label1.caption := 'SchubladePort=' + iSchubladePort;
  if isSerialPort(iSchubladePort) then
   ComComboBox1.text := iSchubladePort
  else
   edit1.Text := iSchubladePort;
end;

procedure TFormArtikelPOS.Schublade_Auf(sComPort: string);
const
  Sequence_RelaisKarteHi: array [0 .. 2] of byte = ($FF, $01, $01);
  Sequence_RelaisKarteLo: array [0 .. 2] of byte = ($FF, $01, $00);
var
  Params: TStringList;
begin
  try
      repeat

        // unset
        if (sComPort='') then
         break;

        // COM[n], COM[nn]
        if isSerialPort(sComPort) then
        begin
            with ComPort1 do
            begin
              Port := sComPort;
              Connected := true;
              write(Sequence_RelaisKarteHi, sizeof(Sequence_RelaisKarteHi));
              sleep(35); // ms
              write(Sequence_RelaisKarteLo, sizeof(Sequence_RelaisKarteLo));
              Connected := false;
            end;
            break;
        end;

        if (pos('XMLRPC',sComPort)=1) then
        begin
          ParamS:= TStringList.create;
          remote_exec( nextp(sComPort,':',1),
                       3040,
                       'Open',
                       Params);
          ParamS.free;
          break;
        end;

        // Batch-File that do this
        CallExternalApp(sComPort, SW_HIDE);

      until yet;

  except
    beep;
  end;
end;

procedure TFormArtikelPOS.SpeedButton1Click(Sender: TObject);
begin
 if RadioButton1.Checked then
  Schublade_Auf(ComComboBox1.text);
 if RadioButton2.Checked then
  Schublade_Auf(edit1.text);
end;

end.
