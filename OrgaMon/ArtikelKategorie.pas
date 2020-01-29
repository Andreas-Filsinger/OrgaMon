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
unit ArtikelKategorie;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  ComCtrls, StdCtrls,

  // IBO
  IB_Components, IB_Access,

  // JVCL
  JvComCtrls, JvGif,

  // Anfix
  WordIndex, JvExComCtrls, Buttons;

type
  TFormArtikelKategorie = class(TForm)
    ListBox1: TListBox;
    Edit1: TEdit;
    Button1: TButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    JvTreeView1: TJvTreeView;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure JvTreeView1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    Gattung: TSearchStringList;
    ARTIKEL_R: integer;
    cTreeColorNormal: TColor;

    procedure EnsureCache;
    procedure InvalidateCache;
    procedure CheckIt;
    procedure ExpandIt;
    procedure storeDB(Node: TTreeNode; SetIt: boolean);
    procedure lAddNode(Node: TTreeNode);
    procedure lDelNode(Node: TTreeNode);
    procedure Listbox1Sort;
    procedure Log(s: string);
    procedure FillTree;
    procedure FillCaption;
  public
    { Public-Deklarationen }
    procedure execute(ARTIKEL_R: integer);
    procedure AddKategorie(ARTIKEL_R: integer; Code: string);
  end;

var
  FormArtikelKategorie: TFormArtikelKategorie;

implementation

uses
  globals, anfix32, CareTakerClient,
  IBExcel, Datenbank,
  dbOrgaMon,
  Funktionen_Basis,
  Funktionen_Beleg,
  wanfix32;

{$R *.dfm}

type
  THeaderNode = class(TObject)
    Node: TTreeNode;
    Header: string;
  end;

procedure TFormArtikelKategorie.EnsureCache;
var
  cGATTUNG: TIB_Cursor;
  LastHeader: string;
  ThisHeader: string;
  HeaderNodes: TList;
  RecN: integer;
  NodeText: string;
  NodeRID: integer;
  n: integer;

  function _add(MainCategorie: TTreeNode; const cHeader, cText: string; const cRID: integer): TTreeNode;
  var
    TrackNode: THeaderNode;
  begin

    // In den Tree-View eintragen
    with JvTreeView1 do
      if assigned(MainCategorie) then
        result := items.AddChildObject(MainCategorie, cText, TObject(cRID))
      else
        result := items.addObject(nil, cText, TObject(cRID));

    // In der Node-Liste verzeichnen
    TrackNode := THeaderNode.create;
    with TrackNode do
    begin
      Node := result;
      Header := cHeader;
    end;
    HeaderNodes.add(TrackNode);

  end;

begin

  if not(assigned(Gattung)) then
  begin
    cTreeColorNormal := clWindow;
    HeaderNodes := TList.create;
    Gattung := TSearchStringList.create;
    LastHeader := '';

    cGATTUNG := DataModuleDatenbank.nCursor;
    with cGATTUNG, JvTreeView1 do
    begin
      sql.add('SELECT RID,CODE,BEZEICHNUNG FROM GATTUNG ORDER BY CODE');
      APIFirst;
      RecN := 0;
      while not(eof) do
      begin
        inc(RecN);

        ThisHeader := FieldByName('CODE').AsString;
        NodeText := ThisHeader + ' ' + FieldByName('BEZEICHNUNG').AsString;
        NodeRID := FieldByName('RID').AsInteger;

        // aktuellen String in den Baum einhängen
        for n := pred(HeaderNodes.count) downto 0 do
          with THeaderNode(HeaderNodes[n]) do
            if (pos(Header, ThisHeader) = 1) then
            begin
              Gattung.addObject(NodeText, _add(Node, ThisHeader, NodeText, NodeRID));
              break;
            end
            else
            begin
              // this do not fit, purge this chain
              THeaderNode(HeaderNodes[n]).free;
              HeaderNodes.delete(n);
            end;

        if (HeaderNodes.count = 0) then
          Gattung.addObject(NodeText, _add(nil, ThisHeader, NodeText, NodeRID));

        LastHeader := ThisHeader;
        ApiNext;
      end;
    end;
    cGATTUNG.free;
  end;
end;

procedure TFormArtikelKategorie.execute(ARTIKEL_R: integer);
begin
  BeginHourGlass;
  self.ARTIKEL_R := ARTIKEL_R;
  Log('execute:' + inttostr(ARTIKEL_R));
  if assigned(Gattung) then

    InvalidateCache;
  EnsureCache;
  FillCaption;
  FillTree;
  Edit1.text := '';
  show;
  Edit1.SetFocus;
  EndHourGlass;
end;

procedure TFormArtikelKategorie.JvTreeView1Click(Sender: TObject);
var
  Node: TJvTreeNode;
begin

  //
  with Sender as TJvTreeView do
    Node := TJvTreeNode(selected);
  Log('Click ' + inttostr(integer(Node.Data)));

  //
  if Node.Checked then
  begin
    // Setzen oder eben nicht
    lAddNode(Node);
    storeDB(Node, true);
  end
  else
  begin
    // Aus Kategorie entfernen
    storeDB(Node, false);
    lDelNode(Node);
  end;

end;

procedure TFormArtikelKategorie.CheckIt;
var
  cSETTINGS: TIB_Cursor;
  lChecked: TList;
  CurItem: TJvTreeNode;
begin
  Log('-checkit-begin');

  // prepare
  lChecked := TList.create;

  // alle Zuordnungen ermitteln
  cSETTINGS := DataModuleDatenbank.nCursor;
  with cSETTINGS do
  begin
    sql.add('select GATTUNG_R from ARTIKEL_GATTUNG where ARTIKEL_R=' + inttostr(ARTIKEL_R));
    APIFirst;
    while not(eof) do
    begin
      lChecked.add(Pointer(FieldByName('GATTUNG_R').AsInteger));
      Log(FieldByName('GATTUNG_R').AsString);
      ApiNext;
    end;
  end;
  cSETTINGS.free;

  // ganzen Baum durchlaufen & die entsprechenden Kreuzchen setzen
  ListBox1.items.clear;
  CurItem := JvTreeView1.items.GetFirstNode as TJvTreeNode;
  while (CurItem <> nil) do
  begin

    //
    if (lChecked.indexof(CurItem.Data) >= 0) then
    begin
      // ja, ein Kreuz
      CurItem.Checked := true;
      ListBox1.items.add(CurItem.text);
      Log(CurItem.text);
    end
    else
    begin
      // kein Kreuz
      CurItem.Checked := false;
    end;

    CurItem := CurItem.GetNext as TJvTreeNode;
  end;
  Listbox1Sort;

  // postpare
  lChecked.free;
  JvTreeView1.color := cTreeColorNormal;
  Log('-checkit-end');
end;

procedure TFormArtikelKategorie.ExpandIt;
var
  CurItem: TJvTreeNode;
  HeaderItem: TJvTreeNode;
begin

  // erst mal den ganzen Baum zuklappen
  CurItem := JvTreeView1.items.GetFirstNode as TJvTreeNode;
  while (CurItem <> nil) do
  begin
    CurItem.collapse(true);
    CurItem := CurItem.GetNext as TJvTreeNode;
  end;

  // ganzen Baum durchlaufen & die entsprechenden angekreuzten öffnen
  CurItem := JvTreeView1.items.GetFirstNode as TJvTreeNode;
  while (CurItem <> nil) do
  begin
    if CurItem.Checked then
    begin
      HeaderItem := CurItem.Parent as TJvTreeNode; // Ttreenode
      while (HeaderItem <> nil) do
      begin
        HeaderItem.expand(false);
        HeaderItem := HeaderItem.Parent as TJvTreeNode;
      end;
    end;
    CurItem := CurItem.GetNext as TJvTreeNode;
  end;
end;

procedure TFormArtikelKategorie.Listbox1Sort;
var
  s: TStringList;
  Dups: TStringList;
  n, DupCount: integer;
begin
  Dups := TStringList.create;
  s := TStringList.create;
  s.assign(ListBox1.items);
  s.sort;
  removeduplicates(s, DupCount, Dups);
  if (DupCount > 0) then
  begin
    for n := 0 to pred(Dups.count) do
      Log('ERROR: Removed duplicate "' + Dups[n] + '"');
  end;
  with ListBox1.items do
  begin
    clear;
    addstrings(s);
  end;
  s.free;
  Dups.free;
end;

procedure TFormArtikelKategorie.Log(s: string);
begin
  AppendStringsToFile(inttostr(ARTIKEL_R) + ' : ' + s, AnwenderPath + 'Kategorie'+cLogExtension);
end;

procedure TFormArtikelKategorie.SpeedButton1Click(Sender: TObject);
begin
  BeginHourGlass;
  execute(ARTIKEL_R);
  EndHourGlass;
end;

procedure TFormArtikelKategorie.SpeedButton2Click(Sender: TObject);
var
  KategorieSQL: TStringList;
begin
  KategorieSQL := TStringList.create;
  with KategorieSQL do
  begin
    add('select');
    add(' GATTUNG.CODE, ');
    add(' GATTUNG.bezeichnung');
    add('from');
    add(' gattung');
    add('join');
    add(' artikel_gattung');
    add('on');
    add(' (ARTIKEL_GATTUNG.gattung_r=GATTUNG.RID) and');
    add(' (ARTIKEL_GATTUNG.artikel_r=' + inttostr(ARTIKEL_R) + ')');
  end;
  ExportTableAsXLS(KategorieSQL, AnwenderPath + 'Kategorie.xls');
  openShell(AnwenderPath + 'Kategorie.xls');
  KategorieSQL.free;
end;

procedure TFormArtikelKategorie.AddKategorie(ARTIKEL_R: integer; Code: string);
var
  k: integer;
  GATTUNG_R: integer;
  RID: integer;
begin
  if (strtointdef(Code, 0) > 0) and (ARTIKEL_R > 0) then
  begin
    EnsureCache;
    k := Gattung.FindInc(Code + ' ');
    if (k <> -1) then
    begin
      GATTUNG_R := integer((Gattung.objects[k] as TTreeNode).Data);
      RID := e_r_sql(
        { } 'select RID from ARTIKEL_GATTUNG where ' +
        { } ' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') AND' +
        { } ' (GATTUNG_R=' + inttostr(GATTUNG_R) + ')');
      if (RID < 1) then
        e_x_sql(format(
          { } 'insert into ARTIKEL_GATTUNG (RID,ARTIKEL_R,GATTUNG_R) values (0,%d,%d)', [
          { } ARTIKEL_R,
          { } GATTUNG_R]));
    end;
  end;
end;

procedure TFormArtikelKategorie.Edit1Change(Sender: TObject);
var
  k: integer;
  // Ttreeview
  Node: TTreeNode;
begin
  if (Edit1.text = '') then
  begin
    JvTreeView1.FullCollapse;
  end
  else
  begin
    EnsureCache;
    k := Gattung.FindInc(Edit1.text + ' ');
    if (k <> -1) then
    begin
      // TTreeView
      Node := Gattung.objects[k] as TTreeNode;
      JvTreeView1.Select(Node);
      JvTreeView1.SelectItem(Node, true);
      Node.expand(false);
    end
    else
    begin
      k := Gattung.FindInc(Edit1.text);
      if (k <> -1) then
      begin
        JvTreeView1.SelectItem(Gattung.objects[k] as TTreeNode, true);
      end
      else
      begin
        JvTreeView1.FullCollapse;
      end;
    end;
  end;
end;

procedure TFormArtikelKategorie.Edit1KeyPress(Sender: TObject; var Key: Char);
// Ttreeview
var
  Node: TTreeNode;
begin
  // ENTER
  if (Key = #13) then
  begin
    Node := JvTreeView1.selected;
    JvTreeView1.SetChecked(Node, true);
    lAddNode(Node);
    storeDB(Node, true);
    Key := #0;
    ListBox1.SetFocus;
    Edit1.SetFocus;
  end;

  // +
  if (Key = '+') and (pos(' ', Edit1.text) > 0) then
  begin
    Button1Click(Sender);
    Key := #0;
    Edit1.SetFocus;
  end;
end;

procedure TFormArtikelKategorie.lAddNode(Node: TTreeNode);
begin
  ListBox1.items.add(Node.text);
  Listbox1Sort;
end;

procedure TFormArtikelKategorie.lDelNode(Node: TTreeNode);
var
  k: integer;
begin
  k := ListBox1.items.indexof(Node.text);
  if (k <> -1) then
    ListBox1.items.delete(k);
end;

procedure TFormArtikelKategorie.storeDB(Node: TTreeNode; SetIt: boolean);
var
  cKATEGORIESETTING: TIB_query;
  dKATEGORIESETTING: TIB_DSQL;
  GATTUNG_R: integer;
  WasSet: boolean;
begin
  if (ARTIKEL_R > 0) then
  begin

    GATTUNG_R := integer(Node.Data);
    WasSet := (e_r_sql('select count(RID) from ARTIKEL_GATTUNG where (GATTUNG_R=' + inttostr(GATTUNG_R) +
      ') and (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ')') > 0);

    if (WasSet <> SetIt) then
    begin

      JvTreeView1.color := clyellow;
      if SetIt then
      begin

        // Kategorie setzen
        cKATEGORIESETTING := DataModuleDatenbank.nQuery;
        with cKATEGORIESETTING do
        begin
          Log('+' + inttostr(integer(Node.Data)));
          sql.add('select * from ARTIKEL_GATTUNG for update');
          insert;
          FieldByName('RID').AsInteger := 0;
          FieldByName('GATTUNG_R').AsInteger := GATTUNG_R;
          FieldByName('ARTIKEL_R').AsInteger := ARTIKEL_R;
          post; { w }
        end;
        cKATEGORIESETTING.free;

      end
      else
      begin

        // Kategorie löschen
        dKATEGORIESETTING := DataModuleDatenbank.nDSQL;
        with dKATEGORIESETTING do
        begin
          Log('-' + inttostr(integer(Node.Data)));
          sql.add('delete from ARTIKEL_GATTUNG where');
          sql.add('(GATTUNG_R=' + inttostr(GATTUNG_R) + ') AND');
          sql.add('(ARTIKEL_R=' + inttostr(ARTIKEL_R) + ')');
          execute; { w }
        end;
        dKATEGORIESETTING.free;

      end;
    end;
  end;
end;

procedure TFormArtikelKategorie.ListBox1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  CurItem: TJvTreeNode;
  NodeText: string;
begin
  if (ListBox1.itemindex <> -1) then
    if (Key = VK_DELETE) then
    begin
      NodeText := ListBox1.items[ListBox1.itemindex];
      CurItem := JvTreeView1.items.GetFirstNode as TJvTreeNode;
      while (CurItem <> nil) do
      begin
        if (CurItem.text = NodeText) then
        begin
          storeDB(CurItem, false);
          JvTreeView1.SetChecked(CurItem, false);
          lDelNode(CurItem);
        end;
        CurItem := CurItem.GetNext as TJvTreeNode;
      end;
    end;
end;

procedure TFormArtikelKategorie.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Key := #0;
    close;
  end;
end;

procedure TFormArtikelKategorie.Button1Click(Sender: TObject);
begin
  // Neuanlage
  e_x_sql(
   { } 'insert into GATTUNG (RID,CODE,BEZEICHNUNG) values (' +
   { } '0,' +
   { } '''' + nextp(Edit1.text, ' ', 0) + '''' + ',' +
   { } '''' + nextp(Edit1.text, ' ', 1) + ''')');

  InvalidateCache;
  EnsureCache;
  FillTree;
  Edit1.text := nextp(Edit1.text, ' ', 0);
end;

procedure TFormArtikelKategorie.InvalidateCache;
begin
  FreeAndNil(Gattung);
  JvTreeView1.items.clear;
end;

procedure TFormArtikelKategorie.FillCaption;
var
  cARTIKEL: TIB_Cursor;
begin
  if (ARTIKEL_R > 0) then
  begin
    cARTIKEL := DataModuleDatenbank.nCursor;
    with cARTIKEL do
    begin
      sql.add('select NUMERO, TITEL from ARTIKEL where RID=' + inttostr(ARTIKEL_R));
      APIFirst;
      caption := format('Kategorie - (%d) %s', [FieldByName('NUMERO').AsInteger, FieldByName('TITEL').AsString]);
      Log(caption);
    end;
    cARTIKEL.free;
  end
  else
  begin
    caption := 'Kategorie';
  end;

end;

procedure TFormArtikelKategorie.FillTree;
begin
  CheckIt;
  ExpandIt;
  if (JvTreeView1.items.count > 0) then
    JvTreeView1.items[0].selected := true;
end;

end.
