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
unit ArtikelPakete;
//
// Migration aus EP
//

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  IB_Access, IB_UpdateBar, IB_NavigationBar, Grids,
  IB_Grid, IB_Components, ExtCtrls,
  StdCtrls, JvGIF, Buttons;

type
  TFormArtikelPakete = class(TForm)
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_DataSource2: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    IB_Grid2: TIB_Grid;
    Image2: TImage;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    Button2: TButton;
    IB_NavigationBar2: TIB_NavigationBar;
    IB_UpdateBar2: TIB_UpdateBar;
    Button3: TButton;
    Button6: TButton;
    Button9: TButton;
    Button23: TButton;
    Label1: TLabel;
    Button5: TButton;
    Button7: TButton;
    StaticText1: TStaticText;
    Button8: TButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;

    Button1: TButton;
    IB_Query2: TIB_Query;   procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure IB_Query2AfterInsert(IB_Dataset: TIB_Dataset);
    procedure IB_Query2AfterPost(IB_Dataset: TIB_Dataset);
    procedure IB_Query2AfterDelete(IB_Dataset: TIB_Dataset);
    procedure IB_Query2ConfirmDelete(Sender: TComponent;
      var Confirmed: Boolean);
    procedure IB_Query1ConfirmDelete(Sender: TComponent;
      var Confirmed: Boolean);
    procedure IB_Query2AfterScroll(IB_Dataset: TIB_Dataset);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure Button8Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure SetPOSNO(RID, POSNO: integer);
    procedure RefreshPaketPreis;
  public
    { Public-Deklarationen }
  end;

var
  FormArtikelPakete: TFormArtikelPakete;

implementation

uses
  globals, ArtikelNeu,
  Funktionen_Beleg,
  Funktionen_Artikel,
  Artikel, anfix32, dbOrgaMon,
  CareTakerClient, Datenbank,
  wanfix32;
{$R *.dfm}

procedure TFormArtikelPakete.FormActivate(Sender: TObject);
begin
  if not(IB_Query1.active) then
    IB_Query1.open;
end;

procedure TFormArtikelPakete.Button2Click(Sender: TObject);
begin
  FormArtikel.SetContext(IB_Query1.FieldByName('MASTERRID').AsInteger);
end;

procedure TFormArtikelPakete.Button3Click(Sender: TObject);
begin
  with IB_Query2 do
    FormArtikel.SetContext(FieldByName('RID').AsInteger);
end;

procedure TFormArtikelPakete.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Artikelpakete');
end;

procedure TFormArtikelPakete.Button1Click(Sender: TObject);
begin
 FormArtikel.show;
end;

procedure TFormArtikelPakete.Button23Click(Sender: TObject);
var
  POSTEN: TIB_DSQL;
begin
  POSTEN := DataModuleDatenbank.nDSQL;
  with POSTEN do
  begin
    sql.add('UPDATE ARTIKEL SET PAKET_POSNO = RID WHERE PAKET_R = ' +
        IB_Query1.FieldByName('MASTERRID').AsString);
    execute;
  end;
  POSTEN.free;
  IB_Query2.Refresh;
end;

procedure TFormArtikelPakete.SetPOSNO(RID, POSNO: integer);
var
  POSTEN: TIB_DSQL;
begin
  POSTEN := DataModuleDatenbank.nDSQL;
  with POSTEN do
  begin
    sql.add('UPDATE ARTIKEL SET PAKET_POSNO = ' + inttostr(POSNO)
        + ' WHERE RID = ' + inttostr(RID));
    execute;
  end;
  POSTEN.free;
end;

procedure TFormArtikelPakete.SpeedButton1Click(Sender: TObject);
var
  MASTER_R: integer;
  SLAVE_R: integer;
  Artikel: TIB_Query;
begin
  if FormArtikelNeu.execute then
  begin
    BeginHourGlass;
    IB_Query2.Close;
    MASTER_R := e_w_ArtikelNeu(FormArtikelNeu.SORTIMENT_R);
    SLAVE_R := e_w_ArtikelNeu(FormArtikelNeu.SORTIMENT_R);
    Artikel := DataModuleDatenbank.nQuery;
    with Artikel do
    begin
      sql.add('SELECT PAKET_R FROM ARTIKEL WHERE RID=' + inttostr(SLAVE_R)
          + ' FOR UPDATE');
      open;
      edit;
      FieldByName('PAKET_R').AsInteger := MASTER_R;
      post;
    end;
    Artikel.free;
    IB_Query1.Refresh;
    IB_Query1.Locate('MASTERRID', MASTER_R, []);
    EndHourGlass;
  end;

end;

procedure TFormArtikelPakete.SpeedButton2Click(Sender: TObject);
var
  ARTIKEL_R: integer;
  Artikel: TIB_Query;
begin
  //
  BeginHourGlass;
  if FormArtikelNeu.execute then
  begin
    ARTIKEL_R := e_w_ArtikelNeu(FormArtikelNeu.SORTIMENT_R);
    Artikel := DataModuleDatenbank.nQuery;
    with Artikel do
    begin
      sql.add('SELECT RID, PAKET_R, PAKET_POSNO FROM ARTIKEL WHERE RID=' +
          inttostr(ARTIKEL_R) + ' FOR UPDATE');
      open;
      edit;
      FieldByName('PAKET_R').assign(IB_Query1.FieldByName('MASTERRID'));
      FieldByName('PAKET_POSNO').assign(FieldByName('RID'));
      post;
    end;
    Artikel.free;
    IB_Query2.Refresh;
    IB_Query2.Locate('RID', ARTIKEL_R, []);
  end;
  EndHourGlass;

end;

procedure TFormArtikelPakete.Button6Click(Sender: TObject);
var
  RID1, POSNO1: integer;
  RID2, POSNO2: integer;
begin
  // UP
  with IB_Query2 do
    if not(bof) then
    begin
      // swap posno with upper neighbour
      RID2 := FieldByName('RID').AsInteger;
      POSNO2 := FieldByName('PAKET_POSNO').AsInteger;
      prior;
      if not(bof) then
      begin
        RID1 := FieldByName('RID').AsInteger;
        POSNO1 := FieldByName('PAKET_POSNO').AsInteger;
        if (RID1 <> RID2) then
        begin
          SetPOSNO(RID1, POSNO2);
          SetPOSNO(RID2, POSNO1);
          Locate('RID', RID1, []);
        end
        else
        begin
          Locate('RID', RID2, []);
        end;
      end
      else
      begin
        Locate('RID', RID2, []);
        beep;
      end;
      Refresh;
    end;
end;

procedure TFormArtikelPakete.Button9Click(Sender: TObject);
var
  RID1, POSNO1: integer;
  RID2, POSNO2: integer;
begin
  // DOWN
  with IB_Query2 do
    if not(Eof) then
    begin
      // swap posno with upper neighbour
      RID2 := FieldByName('RID').AsInteger;
      POSNO2 := FieldByName('PAKET_POSNO').AsInteger;
      next;
      if not(Eof) then
      begin
        RID1 := FieldByName('RID').AsInteger;
        POSNO1 := FieldByName('PAKET_POSNO').AsInteger;
        if (RID1 <> RID2) then
        begin
          SetPOSNO(RID1, POSNO2);
          SetPOSNO(RID2, POSNO1);
          Locate('RID', RID1, []);
        end
        else
        begin
          Locate('RID', RID2, []);
        end;
      end
      else
      begin
        Locate('RID', RID2, []);
        beep;
      end;
      Refresh;
    end;
end;

procedure TFormArtikelPakete.Button7Click(Sender: TObject);
begin
  IB_Query2.FieldByName('PAKET_ARTIKEL_R').clear;
end;

procedure TFormArtikelPakete.Button5Click(Sender: TObject);
var
  ARTIKEL_AA_R: integer;
begin
  IB_Query2.FieldByName('PAKET_ARTIKEL_R').assign
    (FormArtikel.IB_Query1.FieldByName('RID'));
  IB_Query2.FieldByName('TITEL').assign(FormArtikel.IB_Query1.FieldByName
      ('TITEL'));
  IB_Query2.FieldByName('CODE').assign(FormArtikel.IB_Query1.FieldByName('CODE')
    );
  IB_Query2.FieldByName('VERLAGNO').assign(FormArtikel.IB_Query1.FieldByName
      ('VERLAGNO'));
  IB_Query2.FieldByName('EINHEIT_R').assign(FormArtikel.IB_Query1.FieldByName
      ('EINHEIT_R'));
  if (FormArtikel.PageControl1.ActivePage = FormArtikel.TabSheet3) then
  begin
    ARTIKEL_AA_R := FormArtikel.IB_Query13.FieldByName('RID').AsInteger;
    if (ARTIKEL_AA_R >= cRID_FirstValid) then
      IB_Query2.FieldByName('PAKET_ARTIKEL_AA_R').AsInteger := ARTIKEL_AA_R;
  end;
end;

procedure TFormArtikelPakete.RefreshPaketPreis;
begin
  StaticText1.caption := format('%m', [e_r_PaketPreis(0,
      IB_Query1.FieldByName('MASTERRID').AsInteger)]);
end;

procedure TFormArtikelPakete.IB_Query2AfterInsert(IB_Dataset: TIB_Dataset);
begin
  RefreshPaketPreis;
end;

procedure TFormArtikelPakete.IB_Query2AfterPost(IB_Dataset: TIB_Dataset);
begin
  RefreshPaketPreis;
end;

procedure TFormArtikelPakete.IB_Query2AfterDelete(IB_Dataset: TIB_Dataset);
begin
  RefreshPaketPreis;
end;

procedure TFormArtikelPakete.IB_Query2ConfirmDelete(Sender: TComponent;
  var Confirmed: Boolean);
begin
  Confirmed := false;
  with Sender as TIB_Dataset do
    if doit(FieldByName('NUMERO').AsString + #13 + FieldByName('TITEL')
        .AsString + #13 + 'wirklich löschen') then
    begin
      BeginHourGlass;
      e_w_preDeleteArtikel(FieldByName('RID').AsInteger);
      Confirmed := true;
      EndHourGlass;
    end;
end;

procedure TFormArtikelPakete.IB_Query1ConfirmDelete(Sender: TComponent;
  var Confirmed: Boolean);
begin
  Confirmed := false;
  with Sender as TIB_Dataset do
    if doit('Paket #' + FieldByName('NUMERO').AsString + #13 + FieldByName
        ('TITEL').AsString + #13 + 'wirklich löschen') then
    begin
      BeginHourGlass;
      e_w_preDeleteArtikel
        (FieldByName('MASTERRID').AsInteger);
      Confirmed := true;
      EndHourGlass;
    end;
end;

procedure TFormArtikelPakete.IB_Query2AfterScroll(IB_Dataset: TIB_Dataset);
begin
  with IB_Dataset do
  begin
    Button5.enabled := FieldByName('PAKET_ARTIKEL_R').IsNull;
    Button7.enabled := FieldByName('PAKET_ARTIKEL_R').IsNotNull;
    Button8.enabled := Button7.enabled;
  end;
end;

procedure TFormArtikelPakete.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  RefreshPaketPreis;
  IB_Query2.ParamByName('CROSSREF').AsInteger := IB_Query1.FieldByName('MASTERRID').AsInteger;
  if not(IB_Query2.active) then
    IB_Query2.open;
end;

procedure TFormArtikelPakete.Button8Click(Sender: TObject);
begin
  with IB_Query2 do
    FormArtikel.SetContext(FieldByName('PAKET_ARTIKEL_R').AsInteger,
      FieldByName('PAKET_ARTIKEL_AA_R').AsInteger);
end;

end.
