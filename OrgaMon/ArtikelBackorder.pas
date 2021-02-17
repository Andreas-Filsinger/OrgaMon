{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2017  Andreas Filsinger
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
unit ArtikelBackorder;
//
// soll Geheimnisse der Mengen-Wirtschaft verraten
//

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  IB_Access, IB_Components, StdCtrls,
  Grids, IB_Grid, Buttons,
  ExtCtrls, JvGIF, Datenbank;

type
  TFormArtikelBackorder = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    IB_Query1: TIB_Query;
    IB_Query2: TIB_Query;
    IB_Grid1: TIB_Grid;
    IB_Query3: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    Label5: TLabel;
    IB_DataSource2: TIB_DataSource;
    IB_Grid2: TIB_Grid;
    IB_Grid3: TIB_Grid;
    IB_DataSource3: TIB_DataSource;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    Label8: TLabel;
    IB_Grid4: TIB_Grid;
    IB_QueryOrderHistorie: TIB_Query;
    IB_DataSourceOrderHistroie: TIB_DataSource;
    StaticText5: TStaticText;
    Label9: TLabel;
    Button5: TButton;
    StaticText6: TStaticText;
    Label10: TLabel;
    SpeedButton2: TSpeedButton;
    Label11: TLabel;
    Image2: TImage;
    StaticText7: TStaticText;
    Label12: TLabel;
    SpeedButton1: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    _ARTIKEL_R: integer;
    _AUSGABEART_R: integer;
    ZeigeAlleAusgabearten : boolean;

    procedure RefreshValues;
  public
    { Public-Deklarationen }
    procedure SetContext(AUSGABEART_R, ARTIKEL_R: integer);

  end;

var
  FormArtikelBackorder: TFormArtikelBackorder;

implementation

uses
  Artikel, anfix, Belege,
  Funktionen_Beleg,
  Funktionen_Artikel,
  BBelege, CareTakerClient,
  globals, dbOrgaMon, wanfix;

{$R *.dfm}


const

 SQL_Query1_AA_NULL =
   {} 'select' +
   {} ' BELEG_R,' +
   {} ' AUSGABEART_R,' +
   {} ' MENGE_AGENT,' +
   {} ' RID ' +
   {} 'from' +
   {} '  POSTEN ' +
   {} 'WHERE' +
   {} '  (AUSGABEART_R is null) and' +
   {} '  (ARTIKEL_R=:CR) and' +
   {} '  (MENGE_AGENT>0)';
 SQL_Query1 =
   {} 'select' +
   {} ' BELEG_R,' +
   {} ' AUSGABEART_R,' +
   {} ' MENGE_AGENT,' +
   {} ' RID ' +
   {} 'from' +
   {} '  POSTEN ' +
   {} 'WHERE' +
   {} '  (AUSGABEART_R=:CR1) and' +
   {} '  (ARTIKEL_R=:CR2) and' +
   {} '  (MENGE_AGENT>0)';
 SQL_Query1_ALL =
   {} 'select' +
   {} ' BELEG_R,' +
   {} ' AUSGABEART_R,' +
   {} ' MENGE_AGENT,' +
   {} ' RID ' +
   {} 'from' +
   {} '  POSTEN ' +
   {} 'WHERE' +
   {} '  (ARTIKEL_R=:CR) and' +
   {} '  (MENGE_AGENT>0)';

 SQL_Query2_AA_NULL =
   {} 'select' +
   {} ' BELEG_R,' +
   {} ' AUSGABEART_R,' +
   {} ' MENGE_ERWARTET,' +
   {} ' MENGE_UNBESTELLT,' +
   {} ' RID ' +
   {} 'from' +
   {} ' BPOSTEN ' +
   {} 'WHERE' +
   {} ' (AUSGABEART_R is null) and' +
   {} ' (ARTIKEL_R=:CR) AND' +
   {} ' ((MENGE_ERWARTET>0) or' +
   {} '  (MENGE_UNBESTELLT>0)' +
   {} ' )'+
   {} 'order by' +
   {} ' RID ' +
   {} 'descending';
 SQL_Query2 =
   {} 'select' +
   {} ' BELEG_R,' +
   {} ' AUSGABEART_R,' +
   {} ' MENGE_ERWARTET,' +
   {} ' MENGE_UNBESTELLT,' +
   {} ' RID ' +
   {} 'from' +
   {} ' BPOSTEN ' +
   {} 'WHERE' +
   {} ' (AUSGABEART_R=:CR1) and' +
   {} ' (ARTIKEL_R=:CR2) AND' +
   {} ' ((MENGE_ERWARTET>0) or' +
   {} '  (MENGE_UNBESTELLT>0)' +
   {} ' )' +
   {} 'order by' +
   {} ' RID ' +
   {} 'descending';
 SQL_Query2_ALL =
   {} 'select' +
   {} ' BELEG_R,' +
   {} ' AUSGABEART_R,' +
   {} ' MENGE_ERWARTET,' +
   {} ' MENGE_UNBESTELLT,' +
   {} ' RID ' +
   {} 'from' +
   {} ' BPOSTEN ' +
   {} 'WHERE' +
   {} ' (ARTIKEL_R=:CR) AND' +
   {} ' ((MENGE_ERWARTET>0) or' +
   {} '  (MENGE_UNBESTELLT>0)' +
   {} ' )'+
   {} 'order by' +
   {} ' RID ' +
   {} 'descending';

  SQL_QueryOrderHistorie_AA_NULL =
   {} 'select' +
   {} ' RID,' +
   {} ' BELEG_R,' +
   {} ' MOTIVATION,' +
   {} ' AUSGABEART_R,' +
   {} ' MENGE_UNBESTELLT,' +
   {} ' MENGE_ERWARTET,' +
   {} ' MENGE_GELIEFERT,' +
   {} ' (select BESTELLT from BBELEG where RID=BPOSTEN.BELEG_R) BESTELLT ' +
   {} 'from' +
   {} ' BPOSTEN ' +
   {} 'where' +
   {} ' (AUSGABEART_R is null) and' +
   {} ' (ARTIKEL_R=:CR)' +
   {} 'order by' +
   {} ' RID ' +
   {} 'descending' ;
  SQL_QueryOrderHistorie =
   {} 'select' +
   {} ' RID,' +
   {} ' BELEG_R,' +
   {} ' MOTIVATION,' +
   {} ' AUSGABEART_R,' +
   {} ' MENGE_UNBESTELLT,' +
   {} ' MENGE_ERWARTET,' +
   {} ' MENGE_GELIEFERT,' +
   {} ' (select BESTELLT from BBELEG where RID=BPOSTEN.BELEG_R) BESTELLT ' +
   {} 'from' +
   {} ' BPOSTEN ' +
   {} 'where' +
   {} ' (AUSGABEART_R=:CR1) and' +
   {} ' (ARTIKEL_R=:CR2)' +
   {} 'order by' +
   {} ' RID ' +
   {} 'descending';
  SQL_QueryOrderHistorie_ALL =
   {} 'select' +
   {} ' RID,' +
   {} ' BELEG_R,' +
   {} ' MOTIVATION,' +
   {} ' AUSGABEART_R,' +
   {} ' MENGE_UNBESTELLT,' +
   {} ' MENGE_ERWARTET,' +
   {} ' MENGE_GELIEFERT,' +
   {} ' (select BESTELLT from BBELEG where RID=BPOSTEN.BELEG_R) BESTELLT ' +
   {} 'from' +
   {} ' BPOSTEN ' +
   {} 'where' +
   {} ' (ARTIKEL_R=:CR)' +
   {} 'order by' +
   {} ' RID ' +
   {} 'descending' ;

  SQL_Query3_AA_NULL =
   {} 'select' +
   {} ' BELEG.RID,' +
   {} ' (SELECT LAGER.NAME FROM LAGER WHERE BELEG.LAGER_R=LAGER.RID) UEFACH,' +
   {} ' POSTEN.AUSGABEART_R,' +
   {} ' POSTEN.MENGE_RECHNUNG,' +
   {} ' POSTEN.RID POSTEN_R ' +
   {} 'from' +
   {} ' BELEG ' +
   {} 'JOIN' +
   {} ' POSTEN ' +
   {} 'ON' +
   {} ' POSTEN.BELEG_R=BELEG.RID ' +
   {} 'WHERE' +
   {} ' (POSTEN.AUSGABEART_R is null) and' +
   {} ' (POSTEN.ARTIKEL_R=:CR) AND' +
   {} ' (POSTEN.MENGE_RECHNUNG>0) AND' +
   {} ' (BELEG.LAGER_R IS NOT NULL)' ;
  SQL_Query3 =
   {} 'select' +
   {} ' BELEG.RID,' +
   {} ' (SELECT LAGER.NAME FROM LAGER WHERE BELEG.LAGER_R=LAGER.RID) UEFACH,' +
   {} ' POSTEN.AUSGABEART_R,' +
   {} ' POSTEN.MENGE_RECHNUNG,' +
   {} ' POSTEN.RID POSTEN_R ' +
   {} 'from' +
   {} ' BELEG ' +
   {} 'JOIN' +
   {} ' POSTEN ' +
   {} 'ON' +
   {} ' (POSTEN.BELEG_R=BELEG.RID) ' +
   {} 'WHERE' +
   {} ' (POSTEN.AUSGABEART_R=:CR1) and' +
   {} ' (POSTEN.ARTIKEL_R=:CR2) AND' +
   {} ' (POSTEN.MENGE_RECHNUNG>0) AND' +
   {} ' (BELEG.LAGER_R IS NOT NULL)' ;
  SQL_Query3_ALL =
   {} 'select' +
   {} ' BELEG.RID,' +
   {} ' (SELECT LAGER.NAME FROM LAGER WHERE BELEG.LAGER_R=LAGER.RID) UEFACH,' +
   {} ' POSTEN.AUSGABEART_R,' +
   {} ' POSTEN.MENGE_RECHNUNG,' +
   {} ' POSTEN.RID POSTEN_R ' +
   {} 'from' +
   {} ' BELEG ' +
   {} 'JOIN' +
   {} ' POSTEN ' +
   {} 'ON' +
   {} ' POSTEN.BELEG_R=BELEG.RID ' +
   {} 'WHERE' +
   {} ' (POSTEN.ARTIKEL_R=:CR) AND' +
   {} ' (POSTEN.MENGE_RECHNUNG>0) AND' +
   {} ' (BELEG.LAGER_R IS NOT NULL)' ;

procedure TFormArtikelBackorder.Button1Click(Sender: TObject);
begin
  RefreshValues;
end;

procedure TFormArtikelBackorder.Button2Click(Sender: TObject);
begin
  FormBelege.SetContext(
   {} cRID_Null,
   {} IB_Query1.FieldByName('BELEG_R').AsInteger,
   {} IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormArtikelBackorder.Button4Click(Sender: TObject);
begin
  FormBelege.SetContext(
   {} cRID_Null,
   {} IB_Query3.FieldByName('BELEG.RID').AsInteger,
   {} IB_Query3.FieldByName('POSTEN_R').AsInteger);
end;

procedure TFormArtikelBackorder.Button3Click(Sender: TObject);
begin
 if IB_Query2.FieldByName('BELEG_R').IsNotNull then
  FormBBelege.SetContext(
   {} cRID_Null,
   {} IB_Query2.FieldByName('BELEG_R').AsInteger,
   {} IB_Query2.FieldByName('RID').AsInteger)
 else
  ShowMessage('Es ist ein Bestellvorschlag, hier ist noch keine Order zugeordnet!');
end;

procedure TFormArtikelBackorder.Button5Click(Sender: TObject);
begin
  if IB_QueryOrderHistorie.FieldByName('BELEG_R').IsNotNull then
    FormBBelege.SetContext(
     {} cRID_Null,
     {} IB_QueryOrderHistorie.FieldByName('BELEG_R').AsInteger,
     {} IB_QueryOrderHistorie.FieldByName('RID').AsInteger)
  else
    ShowMessage('Es ist ein Bestellvorschlag, hier ist noch keine Order zugeordnet!');
end;

procedure TFormArtikelBackorder.SetContext(AUSGABEART_R, ARTIKEL_R: integer);
begin
  show;
  ZeigeAlleAusgabearten := false;
  _ARTIKEL_R := ARTIKEL_R;
  _AUSGABEART_R := AUSGABEART_R;
  RefreshValues;
end;

procedure TFormArtikelBackorder.RefreshValues;

  procedure ReFreshAndSet(IBQ: TIB_Query; sSQL, sSQL_AA_NULL, sSQL_ALL : string);
  begin
    with IBQ do
    begin
     close;
     if (_AUSGABEART_R=0) or ZeigeAlleAusgabearten then
     begin
      if ZeigeAlleAusgabearten then
       sql.text := sSQL_ALL
      else
       sql.text := sSQL_AA_NULL;
      ParamByName('CR').AsInteger := _ARTIKEL_R;
     end else
     begin
      sql.text := sSQL;
      ParamByName('CR1').AsInteger := _AUSGABEART_R;
      ParamByName('CR2').AsInteger := _ARTIKEL_R;
     end;
     open;
    end;
  end;

var
 AUSGABEART_R : Integer;
begin
  BeginHourGlass;

  //
  ReFreshAndSet(IB_Query1,SQL_Query1, SQL_Query1_AA_NULL, SQL_Query1_ALL);
  ReFreshAndSet(IB_Query2,SQL_Query2, SQL_Query2_AA_NULL, SQL_Query2_ALL);
  ReFreshAndSet(IB_Query3,SQL_Query3, SQL_Query3_AA_NULL, SQL_Query3_ALL);
  ReFreshAndSet(IB_QueryOrderHistorie,SQL_QueryOrderHistorie, SQL_QueryOrderHistorie_AA_NULL, SQL_QueryOrderHistorie_ALL);


  if ZeigeAlleAusgabearten then
   AUSGABEART_R := 0
  else
   AUSGABEART_R := _AUSGABEART_R;

  //
  StaticText5.caption := inttostr(e_r_Menge(cRID_NULL, AUSGABEART_R, _ARTIKEL_R));
  StaticText1.caption := inttostr(e_r_MindestMenge(AUSGABEART_R, _ARTIKEL_R));
  StaticText2.caption := inttostr(e_r_AgentMenge(AUSGABEART_R, _ARTIKEL_R));
  StaticText3.caption := inttostr(e_r_ErwarteteMenge(AUSGABEART_R, _ARTIKEL_R));
  StaticText4.Caption := inttostr(e_r_UngelieferteMengeUeberBedarf(AUSGABEART_R, _ARTIKEL_R));
  StaticText6.caption := inttostr(e_r_VorschlagMenge(AUSGABEART_R, _ARTIKEL_R));
  StaticText7.caption := inttostr(e_r_UnbestellteMenge(AUSGABEART_R, _ARTIKEL_R));

  //
  if ZeigeAlleAusgabearten then
   label11.Caption := '* ' + e_r_Artikel(AUSGABEART_R, _ARTIKEL_R)
  else
   label11.Caption := e_r_Artikel(AUSGABEART_R, _ARTIKEL_R);

  EndHourGlass;
end;

procedure TFormArtikelBackorder.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Order#Mengen');
end;

procedure TFormArtikelBackorder.SpeedButton1Click(Sender: TObject);
begin
  ZeigeAlleAusgabearten := not(ZeigeAlleAusgabearten);
  RefreshValues;
end;

procedure TFormArtikelBackorder.SpeedButton2Click(Sender: TObject);
begin
  RefreshValues;
end;

end.

