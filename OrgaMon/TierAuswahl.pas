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
unit TierAuswahl;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, Grids, IB_Grid,
  IB_Components, IB_Access, Datenbank;

type
  TFormTierAuswahl = class(TForm)
    Label1: TLabel;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    IB_Query1: TIB_Query;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private-Deklarationen }
    ExecuteResult: integer;
  public
    { Public-Deklarationen }
    function execute(PERSON_R: integer): integer;
  end;

var
  FormTierAuswahl: TFormTierAuswahl;

implementation

uses
  Tier, globals, dbOrgaMon;

{$R *.dfm}

{ TFormTierAuswahl }

function TFormTierAuswahl.execute(PERSON_R: integer): integer;
begin
  //
  ExecuteResult := cRID_Null;
  with IB_Query1 do
  begin
    if Active then
     close;
    ParamByName('CROSSREF').AsInteger := PERSON_R;
    Open;
    First;
    case RecordCount of
     0:;
     1:ExecuteResult := FieldByName('RID').AsInteger;
    else
      ShowModal;
    end;
  end;
  result := ExecuteResult;
end;

procedure TFormTierAuswahl.Button1Click(Sender: TObject);
begin
  ExecuteResult := IB_Query1.FieldByName('RID').AsInteger;
  close;
end;

procedure TFormTierAuswahl.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFormTierAuswahl.Button3Click(Sender: TObject);
var
  TIER_R: integer;
  PERSON_R: integer;
begin
  with IB_Query1 do
  begin
    TIER_R := FieldByName('RID').AsInteger;
    PERSON_R := FieldByName('PERSON_R').AsInteger;
  end;
  close;
  FormTier.SetContext(PERSON_R, TIER_R);
end;

end.

