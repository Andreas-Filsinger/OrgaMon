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
unit ArtikelAAA;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Datenbank,
  Dialogs, Grids, IB_Grid,
  IB_Components, IB_Access,
  StdCtrls;

type
  TFormArtikelAAA = class(TForm)
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure IB_Grid1CellDblClick(Sender: TObject; ACol, ARow: Integer;
      AButton: TMouseButton; AShift: TShiftState);
    procedure IB_Query1BeforePrepare(Sender: TIB_Statement);
    procedure IB_Grid1GetCellProps(Sender: TObject; ACol, ARow: Integer;
      AState: TGridDrawState; var AColor: TColor; AFont: TFont);
  private
    { Private-Deklarationen }
    g1_cCOL_PAPERCOLOR: Integer;
    procedure TakeIt;
    procedure IgnoreIt;
  public
    { Public-Deklarationen }

    // -1   : keine Auswahl getroffen -> Abbruch
    // 0   : einfach den Hauptartikel
    // RID  : eine echte Auswahl
    ARTIKEL_AA_R: Integer; // [-1,0,ARTIKEL_AA_R]

    procedure SetContext(ARTIKEL_R: Integer);
  end;

var
  FormArtikelAAA: TFormArtikelAAA;

implementation

uses
  GUIHelp, globals,
  dbOrgaMon,
  Funktionen_Basis,
  Funktionen_Beleg,
  wanfix, Artikel;

{$R *.dfm}

procedure TFormArtikelAAA.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    TakeIt;
  end;

  if (Key = #10) then
  begin
    Key := #0;
    IgnoreIt;
  end;

  if (Key = #27) then
  begin
    Key := #0;
    close;
  end;

  if (Key = 'A') or (Key = 'a') then
  begin
    Key := #0;
    FormArtikel.SetContext(
      { } IB_Query1.FieldByName('ARTIKEL_R').AsInteger,
      { } IB_Query1.FieldByName('RID').AsInteger);
  end;

end;

procedure TFormArtikelAAA.IB_Grid1CellDblClick(Sender: TObject;
  ACol, ARow: Integer; AButton: TMouseButton; AShift: TShiftState);
begin
  TakeIt;
end;

//
// ListBoxStyle nehmen, sonst geht das schief
//

var
  g1_LastRow: Integer = -1;
  g1_LastBackgroundCol: TColor;
  g1_LastFontCol: TColor;

procedure TFormArtikelAAA.IB_Grid1GetCellProps(Sender: TObject;
  ACol, ARow: Integer; AState: TGridDrawState; var AColor: TColor;
  AFont: TFont);
var
  PAPERCOLOR: string;
begin
  // Wird die fokusierte Zeile ausgegeben muss das Caching verhindert werden,
  // da sich das Grid in der ersten Zeile zunächst leer selbst zeichnet,
  // danach die erste Zeile nochmals, diesmal mit Daten, durch das Caching
  // würde der Fehler entstehen, dass die Farbe aus dem ersten Zeichenversuch
  // in den 2. Versuch übernommen wird.
  if gdFocused in AState then
    g1_LastRow := -1;

  if not(gdFixed in AState) and not(gdFocused in AState) then
    with IB_Grid1 do
    begin
      if (ARow <> g1_LastRow) and DataSource.DataSet.active then
      begin

        // Spalte der "PAPERCOLOR" bestimmen
        if (g1_cCOL_PAPERCOLOR <= 0) then
          g1_cCOL_PAPERCOLOR := ColOfGrid(IB_Grid1, 'PAPERCOLOR');
        if (g1_cCOL_PAPERCOLOR <= 0) then
          raise Exception.create('Spalte "PAPERCOLOR" ist undefiniert!');

        // Wert aus PAPERCOLOR bestimmen
        PAPERCOLOR := GetCellDisplayText(g1_cCOL_PAPERCOLOR, ARow);
        if (PAPERCOLOR <> '') then
          g1_LastBackgroundCol := strtointdef(PAPERCOLOR, color)
        else
          g1_LastBackgroundCol := color;

        //
        g1_LastFontCol := VisibleContrast(g1_LastBackgroundCol);

        // Cache-Flag setzen
        g1_LastRow := ARow;
      end;

      AColor := g1_LastBackgroundCol;
      AFont.color := g1_LastFontCol;
    end;

end;

procedure TFormArtikelAAA.IB_Query1BeforePrepare(Sender: TIB_Statement);
begin
  g1_cCOL_PAPERCOLOR := 0;
end;

procedure TFormArtikelAAA.TakeIt;
begin
  ARTIKEL_AA_R := IB_Query1.FieldByName('RID').AsInteger;
  close;
end;

procedure TFormArtikelAAA.IgnoreIt;
begin
  ARTIKEL_AA_R := 0;
  close;
end;

procedure TFormArtikelAAA.SetContext(ARTIKEL_R: Integer);
begin
  ARTIKEL_AA_R := -1;
  with IB_Query1 do
  begin
    caption := 'Ausgabeart von "' +
      e_r_sqls('select TITEL from ARTIKEL where RID=' + inttostr(ARTIKEL_R)) +
      '" wählen ... (<Strg>&<ENTER> = neutrale Auswahl)';
    close;
    ParamByName('CROSSREF').AsInteger := ARTIKEL_R;
    open;
  end;
  showModal;
  IB_Query1.close;
end;

end.
