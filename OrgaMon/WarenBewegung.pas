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
unit WarenBewegung;

interface

uses
  Windows, Messages, SysUtils, Variants,
  Classes, Graphics, Controls, Forms,Buttons, StdCtrls,
  Dialogs, Grids,         ExtCtrls,

  IB_Access,
  IB_Grid, IB_Components,
  IB_UpdateBar, IB_NavigationBar;

type
  TFormWarenBewegung = class(TForm)
    Panel1: TPanel;
    IB_DataSource1: TIB_DataSource;
    IB_Query1: TIB_Query;
    IB_Grid1: TIB_Grid;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    SpeedButton1: TSpeedButton;
    IB_DSQL1: TIB_DSQL;
    Button8: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    IB_Query2: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    IB_Grid2: TIB_Grid;
    Panel2: TPanel;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure IB_Query2AfterScroll(IB_Dataset: TIB_Dataset);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure SetContext(BELEG_R:integer);
    procedure CheckAll(BELEG_R:integer);
    procedure SetContextArtikel(ARTIKEL_R:integer);
  end;

var
  FormWarenBewegung: TFormWarenBewegung;

implementation

uses
 Belege, BBelege, Person,
 Artikel, globals, Datenbank;

{$R *.dfm}

{ TFormWarenBewegung }

procedure TFormWarenBewegung.CheckAll(BELEG_R: integer);
begin
 with IB_DSQL1 do
 begin
  ParamByName('CROSSREF').AsInteger := BELEG_R;
  execute;
 end;
end;

procedure TFormWarenBewegung.SetContextArtikel(ARTIKEL_R: integer);
begin
 BeginHourGlass;
  show;
  application.processmessages;

 with IB_Query1 do
 begin
  sql.clear;
  sql.add('SELECT');
  sql.add('       MENGE');
  sql.add('     , BEWEGT');
  sql.add('     , BRISANZ');
  sql.add('     , AUSGABEART_R');
  sql.add('     , (SELECT ARTIKEL.TITEL FROM ARTIKEL WHERE RID=WARENBEWEGUNG.ARTIKEL_R) ARTIKEL');
  sql.add('     , (SELECT LAGER.NAME FROM LAGER WHERE RID=WARENBEWEGUNG.LAGER_R) LAGER');
  sql.add('     , (SELECT LAGER.NAME FROM LAGER WHERE RID=(SELECT LAGER_R FROM BELEG WHERE RID=WARENBEWEGUNG.BELEG_R)) ZIEL');
  sql.add('     , MENGE_BISHER');
  sql.add('     , MENGE_NEU');
  sql.add('     , ZUSAMMENHANG');
  sql.add('     , AUFTRITT');
  sql.add('     , RID');
  sql.add('     , ARTIKEL_R');
  sql.add('     , BELEG_R');
  sql.add('     , POSTEN_R');
  sql.add('     , BBELEG_R');
  sql.add('     , BPOSTEN_R');
  sql.add('     , (SELECT BELEG.PERSON_R FROM BELEG WHERE RID=WARENBEWEGUNG.BELEG_R) PERSON_R');
  sql.add('FROM');
  sql.add(' WARENBEWEGUNG');
  sql.add('WHERE');
  sql.add(' ARTIKEL_R='+inttostr(ARTIKEL_R));
  sql.add(' ORDER BY RID descending');
  sql.add('FOR UPDATE');
  open;
 end;
 caption := 'Warenbewegung zu Beleg '+inttostr(IB_Query1.FieldByNAme('BELEG_R').AsInteger);
 EndHourGlass;
end;

procedure TFormWarenBewegung.SetContext(BELEG_R: integer);
begin
 BeginHourGlass;
 with IB_Query1 do
 begin
  sql.clear;
  sql.add('SELECT');
  sql.add('       MENGE');
  sql.add('     , BEWEGT');
  sql.add('     , BRISANZ');
  sql.add('     , AUSGABEART_R');
  sql.add('     , (SELECT ARTIKEL.TITEL FROM ARTIKEL WHERE RID=WARENBEWEGUNG.ARTIKEL_R) ARTIKEL');
  sql.add('     , (SELECT LAGER.NAME FROM LAGER WHERE RID=WARENBEWEGUNG.LAGER_R) LAGER');
  sql.add('     , (SELECT LAGER.NAME FROM LAGER WHERE RID=(SELECT LAGER_R FROM BELEG WHERE RID=WARENBEWEGUNG.BELEG_R)) ZIEL');
  sql.add('     , MENGE_BISHER');
  sql.add('     , MENGE_NEU');
  sql.add('     , ZUSAMMENHANG');
  sql.add('     , AUFTRITT');
  sql.add('     , RID');
  sql.add('     , ARTIKEL_R');
  sql.add('     , BELEG_R');
  sql.add('     , POSTEN_R');
  sql.add('     , BBELEG_R');
  sql.add('     , BPOSTEN_R');
  sql.add('     , (SELECT BELEG.PERSON_R FROM BELEG WHERE RID=WARENBEWEGUNG.BELEG_R) PERSON_R');
  sql.add('FROM');
  sql.add(' WARENBEWEGUNG');
  sql.add('WHERE');
  sql.add(' BELEG_R='+inttostr(BELEG_R));
  sql.add(' ORDER BY RID descending');
  sql.add('FOR UPDATE');
  open;
 end;
 caption := 'Warenbewegung zu Beleg '+inttostr(IB_Query1.FieldByName('BELEG_R').AsInteger);
 show;
 EndHourGlass;
end;

procedure TFormWarenBewegung.SpeedButton1Click(Sender: TObject);
begin
 CheckAll(IB_Query1.FieldByName('BELEG_R').AsInteger);
 IB_Query1.Refresh;
end;

procedure TFormWarenBewegung.Button8Click(Sender: TObject);
begin
 FormArtikel.SetContext(IB_Query1.FieldByName('ARTIKEL_R').AsInteger);
end;

procedure TFormWarenBewegung.Button1Click(Sender: TObject);
begin
 FormBBelege.SetContext(0,IB_Query1.FieldByName('BBELEG_R').AsInteger);
end;

procedure TFormWarenBewegung.Button2Click(Sender: TObject);
begin
 FormBelege.SetContext(0,IB_Query1.FieldByName('BELEG_R').AsInteger);
end;

procedure TFormWarenBewegung.Button3Click(Sender: TObject);
begin
 FormPerson.SetContext(IB_Query1.FieldByName('PERSON_R').AsInteger);
end;

procedure TFormWarenBewegung.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
 Button8.enabled := IB_DataSet.FieldByName('ARTIKEL_R').IsNotNull;
 Button1.enabled := IB_DataSet.FieldByName('BBELEG_R').IsNotNull;
 Button2.enabled := IB_DataSet.FieldByName('BELEG_R').IsNotNull;
 Button3.enabled := IB_DataSet.FieldByName('PERSON_R').IsNotNull;
 IB_Query2.ParamByName('CROSSREF').Assign(IB_DataSet.FieldByName('ZUSAMMENHANG'));
 if not(IB_Query2.active) then
  IB_Query2.opeN;
end;

procedure TFormWarenBewegung.IB_Query2AfterScroll(IB_Dataset: TIB_Dataset);
begin
 Button4.enabled := IB_DataSet.FieldByName('ARTIKEL_R').IsNotNull;
 Button5.enabled := IB_DataSet.FieldByName('BBELEG_R').IsNotNull;
 Button6.enabled := IB_DataSet.FieldByName('BELEG_R').IsNotNull;
 Button7.enabled := IB_DataSet.FieldByName('PERSON_R').IsNotNull;
end;

procedure TFormWarenBewegung.Button4Click(Sender: TObject);
begin
 FormArtikel.SetContext(IB_Query2.FieldByName('ARTIKEL_R').AsInteger);
end;

procedure TFormWarenBewegung.Button5Click(Sender: TObject);
begin
 FormBBelege.SetContext(0,IB_Query2.FieldByName('BBELEG_R').AsInteger);
end;

procedure TFormWarenBewegung.Button6Click(Sender: TObject);
begin
 FormBelege.SetContext(0,IB_Query2.FieldByName('BELEG_R').AsInteger);
end;

procedure TFormWarenBewegung.Button7Click(Sender: TObject);
begin
 FormPerson.SetContext(IB_Query2.FieldByName('PERSON_R').AsInteger);
end;

end.
