{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2013  Andreas Filsinger
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
unit Cron;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.StdCtrls, anfix32;

type
  TFormCron = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Timer1: TTimer;
    ListBox1: TListBox;
    Label1: TLabel;
    Panel1: TPanel;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private-Deklarationen }
    Initialized: boolean;
    LetzterCronWarAm: TAnfixDate;
    LetzterCronWarUm: TAnfixTime;
  public
    { Public-Deklarationen }
    procedure Cron_OLAP;
  end;

var
  FormCron: TFormCron;

implementation

uses
  globals, OLAP;

{$R *.dfm}

procedure TFormCron.Cron_OLAP;
begin
  FormOLAP.DoContextOLAP(iSystemOLAPPath + 'Cron.*' + cOLAPExtension);

end;

procedure TFormCron.Timer1Timer(Sender: TObject);
var
  BeendetSeit: integer;
  CountDown: integer;
begin

  if NoTimer then
    exit;

  if not(AllSystemsRunning) then
    exit;

  if not(Initialized) then
  begin
    if (AnsiUpperCase(ComputerName) = AnsiUpperCase(iCronAuf)) then
    begin
      Label1.caption := 'automatisch hier auf ' + iCronAuf;
    end
    else
    begin
      Label1.caption := 'automatisch auf ' + iCronAuf;
      Timer1.Enabled := false;
    end;
    Initialized := true;
  end;

  if (LetzterCronWarAm > 0) then
  begin
    BeendetSeit := SecondsDiff(
      { } DateGet, SecondsGet,
      { } LetzterCronWarAm, LetzterCronWarUm);
    if (BeendetSeit < 90) then
    begin
      // lief kürzlich -> nicht nochmal starten
      exit;
    end
    else
    begin
      // reset!
      LetzterCronWarAm := 0;
      LetzterCronWarUm := 0;
    end;
  end;

  CountDown := abs(SecondsDiff(21 * cOneHourInSeconds, SecondsGet));
  if (CountDown > 10) then
    exit;

  BeginHourGlass;
  NoTimer := true;
  LetzterCronWarAm := DateGet;
  LetzterCronWarUm := SecondsGet;

  Listbox1.Items.Add('Cron_OLAP');
  Cron_OLAP;

  NoTimer := false;
  EndHourGlass;

end;

end.
