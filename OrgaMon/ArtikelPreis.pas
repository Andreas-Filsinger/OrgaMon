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
unit ArtikelPreis;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, Grids, IB_Grid,
  ExtCtrls, IB_UpdateBar, ComCtrls,
  JvComCtrls, IB_Components, JvExComCtrls;

type
  TFormArtikelPreis = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    JvTreeView1: TJvTreeView;
    Label5: TLabel;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private-Deklarationen }
    AUSGABEART_R: integer;
    ARTIKEL_R: integer;
    POSTEN_R:integer;
    NeuerPreis: double;
    AlterPreis: double;

    procedure CreateToDoList(AUSGABEART_R, ARTIKEL_R: integer);
    procedure OpenUserWindow;
  public
    { Public-Deklarationen }
    procedure SetContext(AUSGABEART_R, ARTIKEL_R: integer; Preis: double; POSTEN_R: integer);
  end;

var
  FormArtikelPreis: TFormArtikelPreis;

implementation

uses
  globals, anfix32, Belege,
  Artikel, Datenbank, IBExportTable,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag;

{$R *.dfm}

procedure TFormArtikelPreis.Button3Click(Sender: TObject);
begin
  close;
end;

procedure TFormArtikelPreis.CreateToDoList(AUSGABEART_R, ARTIKEL_R: integer);
var
  MainCategorie: TTreeNode;
  cBELEG: TIB_Cursor;

  function add(MainCategorie: TTreeNode; cText: string; cRID: integer): TTreeNode;
  begin
    with JvTreeView1 do
      if assigned(MainCategorie) then
        result := items.AddChildObject(MainCategorie, cText, TObject(cRID))
      else
        result := items.addObject(nil, cText, TObject(cRID));
  end;

begin
  JvTreeView1.items.clear;
  //
  cBELEG := DataModuleDatenbank.nCursor;
  MainCategorie := nil;
  with cBELEG do
  begin
    sql.add('select POSTEN.RID, POSTEN.BELEG_R, BELEG.PERSON_R');
    sql.add('from POSTEN');
    sql.add('join BELEG on');
    sql.add(' (POSTEN.BELEG_R=BELEG.RID)');
    sql.add('where');
    sql.add(' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') and');
    if (AUSGABEART_R > 0) then
      SQL.add(' (AUSGABEART_R=' + inttostr(AUSGABEART_R) + ') and')
    else
      SQL.add(' (AUSGABEART_R IS NULL) and');
    sql.add(' ((PREIS IS NULL) or (PREIS<>' + FloatToStrISO(NeuerPreis) + ')) and');
    sql.add(' (coalesce(POSTEN.MENGE,0)>(coalesce(POSTEN.MENGE_GELIEFERT,0)+coalesce(POSTEN.MENGE_AUSFALL,0)))'); // NULLIF
    ApiFirst;
    while not (eof) do
    begin
      if not (assigned(MainCategorie)) then
        MainCategorie := add(nil, 'ausstehende Belege', 0);
      add(MainCategorie, FieldByName('BELEG_R').AsString +
        ' ' +
        e_r_Person(FieldByName('PERSON_R').AsInteger), FieldByName('RID').AsInteger);
      ApiNext;
    end;
  end;
  cBELEG.free;

  //
//  add(nil, 'Direkte Artikel Preis Änderungen', 1);
//  add(nil, 'Folgeänderung des Preises Artikel #28273', 1);

end;

procedure TFormArtikelPreis.SetContext(AUSGABEART_R, ARTIKEL_R: integer;
  Preis: double; POSTEN_R: integer);
var
  cARTIKEL: TIB_Cursor;

  function AnzahlPosten: integer;
  begin
    // Bestimme die Anzahl der Änderungkandidaten!
    result := e_r_sql(
      'select count(RID) from POSTEN where ' +
      e_r_sqlArtikelWhere(AUSGABEART_R, ARTIKEL_R) + ' and ' +
      ' ((PREIS IS NULL) or (PREIS<>' + FloatToStrISO(NeuerPreis) + ')) and ' +
      ' ((MENGE_RECHNUNG>0) or (MENGE_AGENT>0)) and ' +
      ' (RID<>' + inttostr(POSTEN_R) + ')');
  end;

begin
  // erst mal sehen ob überhaupt geöffnet werden muss
  if (iSchnelleRechnung_PERSON_R >= cRID_FirstValid) then
    exit;
  AlterPreis := e_r_PreisNativ(AUSGABEART_R, ARTIKEL_R);
  self.AUSGABEART_R := AUSGABEART_R;
  self.ARTIKEL_R := ARTIKEL_R;
  self.POSTEN_R := POSTEN_R;
  self.NeuerPreis := Preis;
  if (NeuerPreis <> AlterPreis) then
  begin
    // Es ist eine Preis-Änderung!


    // Gab es bisher ganz einfach noch keinen Preis-Eintrag?
    if (AUSGABEART_R < cRID_FirstValid) then
    begin
      cARTIKEL := DataModuleDatenbank.nCursor;
      with cARTIKEL do
      begin
        sql.add('select PREIS_R,EURO from ARTIKEL where RID=' + inttostr(ARTIKEL_R));
        ApiFirst;
        if (FieldByName('EURO').IsNull) and (FieldByName('PREIS_R').IsNull) then
        begin

          // Es war noch gar kein Preis eingetragen gewesen!
          e_x_sql('update ARTIKEL set EURO=' +
            FloatToStrISO(NeuerPreis)
            + ' where RID=' + inttostr(ARTIKEL_R))
        end else
        begin
          // -> Preisänderung!
          if (AnzahlPosten > 0) then
            OpenUserWindow;
        end;
      end;
      cARTIKEL.Free;
    end else
    begin
      cARTIKEL := DataModuleDatenbank.nCursor;
      with cARTIKEL do
      begin
        //
        sql.add('select PREIS_R,EURO from ARTIKEL_AA where (ARTIKEL_R=' + inttostr(ARTIKEL_R) +
          ') and (AUSGABEART_R=' + inttostr(AUSGABEART_R) + ')');
        ApiFirst;
        if eof then
        begin
          // Bisher kein Preis-Eintrag!
          e_w_Artikel(cRID_Null, AUSGABEART_R,  ARTIKEL_R);
          e_x_sql(
           'update ARTIKEL_AA set EURO=' + FloatToStrIso(NeuerPreis)+
           ' where ' +e_r_sqlArtikelWhere(AUSGABEART_R,ARTIKEL_R));
        end else
        begin
          // -> Preisänderung!
          if (AnzahlPosten > 0) then
            OpenUserWindow;
        end;
      end;
      cARTIKEL.Free;
    end;
  end;
end;

procedure TFormArtikelPreis.Button2Click(Sender: TObject);
begin
  ShowMessage('noch nicht möglich!');
  close;
end;

procedure TFormArtikelPreis.OpenUserWindow;
begin
  edit1.Text := format('%.2f', [NeuerPreis]);
  StaticText1.Caption := cutblank(
    e_r_AusgabeArt(AUSGABEART_R) +
    e_r_sqls('select TITEL from ARTIKEL where RID=' + inttostr(ARTIKEL_R)));
  StaticText2.Caption := e_r_PreisText(AUSGABEART_R, ARTIKEL_R);
  CreateToDoList(AUSGABEART_R, ARTIKEL_R);
  show;
end;

procedure TFormArtikelPreis.Button1Click(Sender: TObject);
var
  Node: TJvTreeNode;
begin
  with JvTreeView1 do
  begin
    Node := TJvTreeNode(selected);
    if assigned(Node.Data) then
      FormBelege.SetContext(0, 0, integer(Node.Data));
  end;
end;

procedure TFormArtikelPreis.Button4Click(Sender: TObject);
begin
 FormArtikel.SetContext(ARTIKEL_R);
end;

end.

