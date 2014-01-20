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
unit OLAPedit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, IB_Access, IB_UpdateBar, IB_Components, Grids, IB_Grid, StdCtrls;

type
  TFormOLAPedit = class(TForm)
    IB_Grid1: TIB_Grid;
    IB_Grid2: TIB_Grid;
    IB_Grid3: TIB_Grid;
    IB_Grid4: TIB_Grid;
    IB_DataSource1: TIB_DataSource;
    IB_Query1: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    IB_Query2: TIB_Query;
    IB_Query3: TIB_Query;
    IB_DataSource3: TIB_DataSource;
    IB_DataSource4: TIB_DataSource;
    IB_Query4: TIB_Query;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_UpdateBar2: TIB_UpdateBar;
    IB_UpdateBar3: TIB_UpdateBar;
    IB_UpdateBar4: TIB_UpdateBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure SetContext(EQUIPMENTID, CALIBRATIONID, SERIALNUMBER: string);
  end;

var
  FormOLAPedit: TFormOLAPedit;

implementation

uses
  IBExportTable, globals, Datenbank;

{$R *.dfm}

{ TFormOLAPedit }

procedure TFormOLAPedit.SetContext(EQUIPMENTID, CALIBRATIONID,
  SERIALNUMBER: string);
begin
  BeginHourglass;
  with IB_Query1 do
  begin
    if Active then
      close;
    IB_Connection := cConnectioN;

    ParamByName('EI').AsString := EQUIPMENTID;
    ParamByNAme('CI').AsString := CALIBRATIONID;
    ParamByName('SN').AsString := SERIALNUMBER;
    Open;
  end;

  with IB_Query2 do
  begin
    if Active then
      close;
    IB_Connection := cConnectioN;
    ParamByName('EI').AsString := EQUIPMENTID;
    ParamByNAme('CI').AsString := CALIBRATIONID;
    ParamByName('SN').AsString := SERIALNUMBER;
    Open;
  end;

  with IB_Query3 do
  begin
    if Active then
      close;
    IB_Connection := cConnectioN;
    ParamByName('EI').AsString := EQUIPMENTID;
    ParamByNAme('CI').AsString := CALIBRATIONID;
    Open;
  end;

  with IB_Query4 do
  begin
    if Active then
      close;
    IB_Connection := cConnectioN;
    ParamByName('EI').AsString := EQUIPMENTID;
    ParamByNAme('CI').AsString := CALIBRATIONID;
    Open;
  end;
  show;
  EndHourGlass;
end;

end.

