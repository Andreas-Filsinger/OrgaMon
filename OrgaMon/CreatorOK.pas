(*
      ___                  __  __
     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
    | |_| | | | (_| | (_| | |  | | (_) | | | |
     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
               |___/

    Copyright (C) 2007 - 2017  Andreas Filsinger

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    http://orgamon.org/

*)
unit CreatorOK;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  checklst;

type
  TFormCreatorOK = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    CheckListBox1: TCheckListBox;
    Label6: TLabel;
    Label7: TLabel;
    CheckBox1: TCheckBox;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure Reload;
  end;

var
  FormCreatorOK: TFormCreatorOK;

implementation

uses
  anfix, SimplePassword,
  globals,
  Funktionen_Beleg,
  splash,
  CreatorMain,
  Person;

{$R *.DFM}

procedure TFormCreatorOK.Button1Click(Sender: TObject);
var
  AlleNoten: TStringList;
  OutF: TextFile;
  i: integer;
begin
  if (edit1.Text <> '') then
  begin
    if checkbox1.checked then
      SavePassword(MyProgramPath + cHistorieTextFName, ActualPwdNoten, ActualSerialNumber + ' ' + edit1.Text + ' ³')
    else
      SavePassword(MyProgramPath + cHistorieTextFName, ActualPwdNoten, ActualSerialNumber + ' ' + edit1.Text);

    AlleNoten := TStringList.create;
    if FileExists(ETFLager + 'noten.txt') then
      AlleNoten.LoadFromFile(ETFLager + 'noten.txt');
    assignFile(OutF, MyProgramPath + cHistorieTextFName);
    append(OutF);
    writeln(OutF, ActualPwdHaendler + ' (Pwd für Händler-Version)');
    for i := 0 to pred(AlleNoten.count) do
      writeln(OutF, '                                           ' + AlleNoten[i]);
    closeFile(OutF);
    AlleNoten.free;
    SaveSerial(MyProgramPath + SerialText, ActualSerialNumber);
    close;
  end else
  begin
    FocusControl(edit1);
    ShowMessage('Bitte - zur eigenen Übersicht - etwas eingeben');
  end;
end;

procedure TFormCreatorOK.FormActivate(Sender: TObject);
begin
  focuscontrol(edit1);
  CheckBox1.checked := false;
  Reload;
end;

procedure TFormCreatorOK.Reload;
begin
  FormPerson.EnsureThatQuerysAreOpen;
  edit1.Text :=
    {} FormPerson.IB_Query1.FieldByName('NUMMER').AsString + ' ' +
    {} FormPerson.IB_Query1.FieldByName('NACHNAME').AsString + ', ' +
    {} FormPerson.IB_Query1.FieldByName('VORNAME').AsString + ' ' +
    {} HugeSingleLine(e_r_Ort(FormPerson.IB_Query2),'|',3,true);
end;

procedure TFormCreatorOK.FormCreate(Sender: TObject);
begin
  StartDebug('CreatorOK');
  top := (screen.height div 2) - (height div 2) + 50;
  left := (screen.width div 2) - (width div 2) + 50;
  caption := 'CD kann gebrannt werden!'
end;

procedure TFormCreatorOK.Button2Click(Sender: TObject);
begin
  ReLoad;
end;

end.
