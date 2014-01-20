(*
      ___                  __  __
     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
    | |_| | | | (_| | (_| | |  | | (_) | | | |
     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
               |___/

    Copyright (C) 2007  Andreas Filsinger

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
unit BudgetKalkulation;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs,
  StdCtrls;

type
  TFormBudgetKalkulation = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormBudgetKalkulation: TFormBudgetKalkulation;

implementation

uses
  anfix32;

{$R *.DFM}

procedure TFormBudgetKalkulation.Button1Click(Sender: TObject);
const
  cLeftTab = 65;
var
  InF: TStringList;
  Summe: extended;
  n: integer;
  OneLine: string;
  Menge: integer;

begin
  InF := TStringList.Create;
  Inf.LoadFromFile('G:\doc\Pünktlich 001.txt');
  Summe := 0.0;
  for n := 0 to pred(Inf.count) do
  begin
    if Inf[n] = '' then
      continue;
    if pos('//', InF[n]) = 1 then
      continue;
    OneLine := InF[n];
    Menge := strtoint(nextp(OneLine, ';'));
    nextp(OneLine, ';');
    ersetze('.', '', OneLIne);
    ersetze(',', '.', OneLIne);
    ersetze('DM', '', OneLine);
    OneLine := cutblank(OneLine);
    Summe := Summe + Menge * StrToDouble(OneLine);
    Inf[n] := Inf[n] + fill(' ', cLeftTab - length(Inf[n])) + format('%13.2m', [Menge * StrToDouble(OneLine)]);
  end;
  Inf.add('');
  Inf.add(fill(' ', cLeftTab) + fill('=', 13));
  Inf.add(fill(' ', cLeftTab) + format('%13.2m', [Summe]));
  Inf.SaveToFile('G:\doc\Pünktlich 001-Out.txt');
  Inf.free;
end;

end.

