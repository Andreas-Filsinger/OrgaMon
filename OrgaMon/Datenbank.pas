{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2020  Andreas Filsinger
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
unit Datenbank;

{$IFDEF CONSOLE}
{$MESSAGE FATAL 'Prüfe Abhängigkeit: Diese Unit hat GUI'}
{$ENDIF}

interface

uses
  // Delphi
  Windows,
  SysUtils,
  Classes,

  // IB-Objects
  IB_Access,
  IB_Components,
  IB_Session,

  // Tools
  anfix32, gplists, IB_Monitor;

type
  TDataModuleDatenbank = class(TDataModule)
    IB_Connection1: TIB_Connection;
    IB_Transaction_W: TIB_Transaction;
    IB_Session1: TIB_Session;
    IB_Transaction_R: TIB_Transaction;
    IB_Monitor1: TIB_Monitor;
    procedure IB_Connection1BeforeConnect(Sender: TIB_Connection);
    procedure DataModuleCreate(Sender: TObject);
    procedure IB_Monitor1MonitorOutputItem(Sender: TObject;
      const NewString: string);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }

    // LOG-Sachen
    SQLLog : TStringList;

    // Freepascal Abstraktions-Schicht
    function nQuery : TIB_Query;
    function nCursor : TIB_Cursor;
    function nDSQL : TIB_DSQL;

  end;


var
  DataModuleDatenbank: TDataModuleDatenbank;

implementation

uses
  math,
  globals,
  CareTakerClient, html,
  Sperre,
  WordIndex,
  Dialogs;

{$R *.DFM}

procedure TDataModuleDatenbank.IB_Connection1BeforeConnect(Sender: TIB_Connection);
var
  _iDataBaseName: string;
  k, l: integer;
begin
  if isParam('-al') then
   IB_Monitor1.Enabled := true;

  _iDataBaseName := iDataBaseName;
  if (iDataBaseHost <> '') then
    i_c_DataBaseFName := copy(_iDataBaseName, succ(pos(':', _iDataBaseName)), MaxInt)
  else
    i_c_DataBaseFName := iDataBaseName;


  i_c_DataBasePath := i_c_DataBaseFName;
  l := revpos('.', i_c_DataBasePath);
  k := max(revpos('\', i_c_DataBasePath), revpos('/', i_c_DataBasePath));
  if (k > 0) then
  begin
    i_c_DataBasePath := copy(i_c_DataBaseFName, 1, k);
    MandantName := copy(i_c_DataBaseFName, succ(k), pred(l - k));
  end;

  Sender.DataBaseName := _iDataBaseName;
  if (iDataBaseHost = '') then
  begin
    Sender.Server := '';
    Sender.protocol := cplocal;
  end  else
  begin
    Sender.protocol := cpTCP_IP;
  end;

end;

procedure TDataModuleDatenbank.IB_Monitor1MonitorOutputItem(Sender: TObject;
  const NewString: string);
begin
  if not(assigned(SQLLog)) then
   SQLLog := TSTringList.Create;
  SQLLog.Add(NewString);
end;

function TDataModuleDatenbank.nCursor: TIB_Cursor;
begin
  result := TIB_Cursor.create(self);
  with result do
  begin
    IB_Connection := IB_Connection1;
  end;
end;

function TDataModuleDatenbank.nDSQL: TIB_DSQL;
begin
  result := TIB_DSQL.create(self);
  with result do
  begin
    IB_Connection := IB_Connection1;
  end;
end;

function TDataModuleDatenbank.nQuery: TIB_Query;
begin
  result := TIB_Query.create(self);
  with result do
  begin
    IB_Connection := IB_Connection1;
  end;
end;

procedure TDataModuleDatenbank.DataModuleCreate(Sender: TObject);
begin
 IB_Connection1.connected := false;
end;

procedure TDataModuleDatenbank.DataModuleDestroy(Sender: TObject);
begin
 if assigned(SQLLog) then
  SQLLog.SaveToFile(
   {} DiagnosePath+
   {} 'SQL-'+
   {} ComputerName+'-'+
   {} e_r_Kontext+
   {} cLogExtension);
end;

end.

