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
unit QAbzeichnen;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TFormQAbzeichnen = class(TForm)
    Label1: TLabel;
    Memo1: TMemo;
    Button1: TButton;
    Image1: TImage;
    Timer1: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private-Deklarationen }
    Initialized: boolean;
    _LastMessage: string;
    CacheLiveTime: integer;
    procedure CacheAlive;
  public
    { Public-Deklarationen }
    procedure Abzeichnen(Info: string);
  end;

var
  FormQAbzeichnen: TFormQAbzeichnen;

implementation

uses
  Globals, Bearbeiter, Anfix32,
  math;

{$R *.dfm}

procedure TFormQAbzeichnen.Abzeichnen(Info: string);
begin

  //
  if (Info = '') then
    exit;

  //
  if (info <> _LastMessage) then
  begin
    _LastMessage := info;
    CacheAlive;
    memo1.Lines.Clear;
    while (Info <> '') do
      memo1.Lines.Add(nextp(Info, #13));
    ShowModal;
  end else
  begin
    CacheAlive;
  end;

end;

procedure TFormQAbzeichnen.FormActivate(Sender: TObject);
begin
  if not (Initialized) then
  begin
    image1.Picture.Bitmap.Assign(FormBearbeiter.FetchBILDFromRID(sBearbeiter));
    Initialized := true;
  end;
end;

procedure TFormQAbzeichnen.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TFormQAbzeichnen.Timer1Timer(Sender: TObject);
begin
  if NoTimer then
    exit;
  dec(CacheLiveTime, Timer1.Interval);
  CacheLiveTime := max(0, CacheLiveTime);
  if (CacheLiveTime = 0) then
  begin
    _LastMessage := '';
    Timer1.enabled := false;
  end;
end;

procedure TFormQAbzeichnen.CacheAlive;
begin
  CacheLiveTime := 3 * 60 * 1000; // 3 minuten
  if not (Timer1.Enabled) then
    Timer1.Enabled := true;
end;

end.

