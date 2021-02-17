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
unit PlanquadratNachfrage;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TFormPlanquadratNachfrage = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormPlanquadratNachfrage: TFormPlanquadratNachfrage;

implementation

uses
 AuftragArbeitsplatz, anfix;

{$R *.DFM}

procedure TFormPlanquadratNachfrage.Button1Click(Sender: TObject);
begin
  close;
  FormAuftragArbeitsplatz.MarkiereLeeresPlanquadrat(strtol(edit1.Text), strtol(edit2.Text));
end;

end.
