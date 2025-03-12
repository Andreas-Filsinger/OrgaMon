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
unit Inventur;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, IB_Access, IB_UpdateBar,
  IB_NavigationBar, IB_SearchBar, Grids,
  IB_Grid, IB_Components, ExtCtrls,
  ComCtrls, StdCtrls,
  IB_Controls, WordIndex, Vcl.Buttons;

type
  TFormInventur = class(TForm)
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Query2: TIB_Query;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    IB_Grid1: TIB_Grid;
    ComboBox1: TComboBox;
    IB_Query_Inventur: TIB_Query;
    IB_Query_Artikel: TIB_Query;
    IB_DataSource_Inventur: TIB_DataSource;
    IB_DataSource_Artikel: TIB_DataSource;
    Label7: TLabel;
    TabSheet3: TTabSheet;
    Button11: TButton;
    Edit3: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Edit2: TEdit;
    TabSheet2: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    IB_Grid2: TIB_Grid;
    IB_Grid3: TIB_Grid;
    DrawGrid1: TDrawGrid;
    Button2: TButton;
    IB_UpdateBar2: TIB_UpdateBar;
    IB_Memo1: TIB_Memo;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    IB_UpdateBar3: TIB_UpdateBar;
    Button9: TButton;
    Button12: TButton;
    Label2: TLabel;
    Edit1: TEdit;
    Label10: TLabel;
    Button5: TButton;
    Button13: TButton;
    Label11: TLabel;
    Label12: TLabel;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Button10: TButton;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    Panel2: TPanel;
    Button3: TButton;
    ProgressBar2: TProgressBar;
    CheckBox1: TCheckBox;
    Button4: TButton;
    CheckBox2: TCheckBox;
    IB_SearchBar1: TIB_SearchBar;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    Button1: TButton;
    CheckBox3: TCheckBox;
    Button14: TButton;
    SpeedButton1: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure IB_Query_InventurAfterScroll(IB_Dataset: TIB_Dataset);
    procedure FormActivate(Sender: TObject);
    procedure DrawGrid1DblClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button7Click(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DrawGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure IB_Query_ArtikelAfterInsert(IB_Dataset: TIB_Dataset);
    procedure Button8Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure Button12Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    LastRequestedRID: integer;
    LastRequestedSub: TStringList;
    ItemRIDs: TList;
    ItemMarked: TList;
    ArtikelSucheWI: TWordIndex;

    function LineDataFromRID1(RID: integer): TStringList;
    procedure DoTheArtikelSearch;
    procedure DoTheArtikelSearchTabelle;
    procedure GridSortieren;
    procedure GridRefresh;
    procedure GridFillFromList(TheList: TList);

    procedure RefreshNameList;
    procedure RefreshLagerList;
    procedure RefreshVerlagList;

    procedure Add(RID: integer);
    procedure Delete(RID: integer);
    procedure Start(RID: integer);
    procedure Inventur(RID: integer; Menge: integer; Menge_Labels: integer);

  public
    { Public-Deklarationen }
  end;

var
  FormInventur: TFormInventur;

implementation

uses
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Artikel,
  Funktionen_Auftrag,
  ArtikelSortiment, anfix, globals,
  QueryEdit,  Artikel,
  html, ArtikelVerlag,
  Lager, Datenbank,
  wanfix, dborgamon;

{$R *.DFM}

procedure TFormInventur.Button1Click(Sender: TObject);
begin
  if (Combobox1.itemindex <> -1) then
  begin
    BeginHourGlass;
    IB_Query1.ParamByName('CROSSREF').AsInteger := integer(Combobox1.items.objects[Combobox1.itemindex]);
    if not (IB_Query1.Active) then
      IB_Query1.Open;
    EndHourGlass;
  end;
end;

procedure TFormInventur.Button3Click(Sender: TObject);
const
  cTAB = #9;
var
  LastT: dword;
  _read: integer;
  MyReport: TStringList;
  _Preis: double;
  _Mwst: double;
  _anz: integer;
  _rabatt: double;
  LagerWertNetto: double;
  LagerWertRabbattiert: double;

  LagerWert: double;
  LagerWertSumme: double;
  LagerWertSummeA: double;
  LagerWertSummeB: double;
begin
  screen.cursor := crHourGlass;
  MyReport := TStringList.create;
  LastT := 0;
  _read := 0;
  LagerWertSumme := 0;
  LagerWertSummeA := 0;
  LagerWertSummeB := 0;
  with IB_query1 do
  begin
    Disablecontrols;
    progressbar2.Max := RecordCount;
    first;
    while not eof do
    begin
      _Preis := FieldByName('INVENTUR_PREIS').AsDouble;
      _Mwst := FieldByName('INVENTUR_MWST').AsDouble;
      _rabatt := FieldByName('INVENTUR_RABATT').AsDouble;
      _anz := FieldByName('INVENTUR_MENGE').AsInteger;

      LagerWertNetto := _preis / (1.0 + (_MwSt / 100.0));
      LagerWertRabbattiert := LagerWertNetto * (1.0 - (_rabatt / 100.0));

      LagerWert := LagerWertRabbattiert * _anz;

      if CheckBox1.checked then
      begin
        if CheckBox2.checked then
          MyReport.add(inttostrN(FieldByName('INVENTUR_MENGE').AsInteger, 4) + 'x' + cTAB +
            FieldByName('NUMERO').AsString + cTAB +
            copy(FieldByName('TITEL').AsString, 1, 70) + cTAB +
            format('%10m' + cTAB + '%3.1f%%' + cTAB + '-%2.0f%%' + cTAB + '=' + cTAB + '%13m', [_Preis, _MwSt, _rabatt, LagerWert]))
        else
          MyReport.add(inttostrN(FieldByName('INVENTUR_MENGE').AsInteger, 4) + 'x ' +
            FieldByName('NUMERO').AsString + fill(' ', 8 - length(FieldByName('NUMERO').AsString)) + ' ' +
            copy(FieldByName('TITEL').AsString + fill(' ', 70 - length(FieldByName('TITEL').AsString)), 1, 70) + ' ' +
            format('%10m  %3.1f%%  -%2.0f%% = %13m', [_Preis, _MwSt, _rabatt, LagerWert]));
      end else
      begin
        if CheckBox2.checked then
          MyReport.add(inttostrN(FieldByName('INVENTUR_MENGE').AsInteger, 4) + 'x' + cTAB +
            FieldByName('NUMERO').AsString + cTAB +
            copy(FieldByName('TITEL').AsString, 1, 70) + cTAB +
            format('%13m', [LagerWert]))
        else
          MyReport.add(inttostrN(FieldByName('INVENTUR_MENGE').AsInteger, 4) + 'x ' +
            FieldByName('NUMERO').AsString + fill(' ', 8 - length(FieldByName('NUMERO').AsString)) + ' ' +
            copy(FieldByName('TITEL').AsString + fill(' ', 70 - length(FieldByName('TITEL').AsString)), 1, 70) + ' ' +
            format(' %13m', [LagerWert]))
      end;

      LagerWertSumme := LagerWertSumme + LagerWert;

      if (_mwst > 13.0) then
        LagerWertSummeA := LagerWertSummeA + LagerWert
      else
        LagerWertSummeB := LagerWertSummeB + LagerWert;

      next;
      inc(_read);
      if frequently(LastT, 400) or eof then
      begin
        progressbar2.position := _read;
        application.processmessages;
      end;
    end;
    EnableControls;
  end;
  MyReport.add('');
  MyReport.add(format('Lagerwert netto (vermindeter MwSt-Satz) = %20m', [LagerWertSummeB]));
  MyReport.add(format('Lagerwert netto (voller MwSt-Satz)      = %20m', [LagerWertSummeA]));
  MyReport.add('                                          =======================');
  MyReport.add(format('Lagerwert netto (Gesamt)                = %20m', [LagerWertSumme]));
  MyReport.SaveToFile(DiagnosePath + 'Inventur.txt');
  MyReport.free;
  screen.cursor := crdefault;
  progressbar2.position := 0;
  openShell(DiagnosePath + 'Inventur.txt');
end;

procedure TFormInventur.Button4Click(Sender: TObject);
begin
 // IB_query1.editsql
  FormQueryEdit.EditSql(self, IB_Query1);
end;

procedure TFormInventur.IB_Query_InventurAfterScroll(
  IB_Dataset: TIB_Dataset);
begin
  IB_Query_Artikel.ParamByName('CROSSREF').AsInteger := IB_Query_Inventur.FieldByName('RID').AsInteger;
end;

procedure TFormInventur.FormActivate(Sender: TObject);
begin
  if IB_Query_Inventur.active then
    IB_Query_Inventur.refresh
  else
    IB_Query_Inventur.Open;

  if IB_Query_Artikel.active then
    IB_Query_Artikel.refresh
  else
    IB_Query_Artikel.Open;

  RefreshNameList;
  RefreshLagerList;
  RefreshVerlagList;

end;

procedure TFormInventur.DrawGrid1DblClick(Sender: TObject);
begin
  Button7Click(Sender);
end;

procedure TFormInventur.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if iArtikelDatenbankSucheAktiv then
      DoTheArtikelSearchTabelle
      else
      DoTheArtikelSearch;
  end;

end;

procedure TFormInventur.GridSortieren;
var
  ClientSorter: TStringList;
  n: integer;
  cARTIKEL: TIB_Cursor;
begin
  if (ItemRIDs.count > 1) then
  begin
    BeginHourGlass;
    cARTIKEL := DataModuleDatenbank.nCursor;
    with cARTIKEL do
    begin
      sql.add('SELECT TITEL FROM');
      sql.add('ARTIKEL WHERE RID=:CROSSREF');
      prepare;
    end;
    ClientSorter := TStringList.create;
    for n := 0 to pred(ITEMRids.count) do
    begin
      cARTIKEL.ParamByName('CROSSREF').Asinteger := integer(ItemRids[n]);
      cARTIKEL.ApiFirst;
      ClientSorter.addobject(AnsiUpperCase(cARTIKEL.FieldByName('TITEL').AsString), pointer(ItemRids[n]));
    end;
    ClientSorter.sort;
    for n := 0 to pred(ClientSorter.count) do
      ItemRIDs[n] := ClientSorter.objects[n];
    ClientSorter.free;
    cARTIKEL.free;
    EndHourGlass;
  end;
end;



procedure TFormInventur.DoTheArtikelSearch;
begin
  BeginHourGlass;
  if not (assigned(ArtikelSucheWI)) then
  begin
    ArtikelSucheWI := TWordIndex.create(nil);
    ArtikelSucheWI.LoadFromFile(SearchDir + format(cArtikelSuchindexFName,[cArtikelSuchindexIntern]));
  end else
  begin
    ArtikelSucheWI.ReloadIfNew;
  end;

  ArtikelSucheWI.Search(edit1.Text);
  if ArtikelSucheWI.FoundList.count > 0 then
  begin
    GridFillFromList(ArtikelSucheWI.FoundList);
  end else
  begin
    ShowMessage('Nichts gefunden!');
    edit1.SetFocus;
  end;
  EndHourGlass;
end;

procedure TFormInventur.DoTheArtikelSearchTabelle;
var
  i,x:Integer;
  q:TIB_Query;
  lSuchWorte:TStringList;
  lRIDSuche: Boolean;
begin
  BeginHourGlass;
  IB_Query1.DisableControls;
  q:=TIB_Query.Create(nil);
  lSuchWorte:=TStringList.Create;
  try

    //Suchwortliste erstellen (Trennen bei &)
    if copy(lowercase(Edit1.text),0,3) = 'rid' then
    begin
      lRIDSuche := True;
      lSuchWorte.Delimiter := ',';
      lSuchWorte.DelimitedText := copy(Lowercase(Edit1.text),4,length(Edit1.text));
    end
    else
    begin
      lRIDSuche := False;
      lSuchWorte.Delimiter := ' ';
      lSuchWorte.DelimitedText := Lowercase(Edit1.text);
    end;

    if (lSuchWorte.count=0) then
    begin
      ShowMessage('Bitte Suchwort angeben!');
      exit;
    end;

    if (lSuchWorte.count>9) then
    begin
      ShowMessage('Nur max. 9 Suchworte erlaubt!');
      exit;
    end;

    //SpezielleSuche.Clear;
    q.Active := False;
    q.ib_connection:=DataModuleDatenbank.IB_Connection1;

    if lRIDSuche then
    begin
      q.SQL.Text:= 'select RID from ARTIKEL_SUCHE ';
      q.SQL.Add('WHERE RID IN (');
      for x:=0 to  lSuchWorte.Count-1 do
      begin
        if x<lSuchWorte.Count-1 then
        q.SQL.Add(lSuchWorte[x] + ',')
        else
        q.SQL.Add(lSuchWorte[x]);
      end;
        q.SQL.Add(')');
    end
    else
    begin
      q.SQL.Text:= 'select RID from ARTIKEL_SUCHE ' +
                 'WHERE 1=1 ';
      for x:=0 to  lSuchWorte.Count-1 do
      begin
        q.SQL.Add('AND SUCHMEMO' + ' LIKE :SUCHBESCHREIBUNG'+ x.ToString + ' ');
      end;

      for x:=0 to  lSuchWorte.Count-1 do
      begin
        q.ParamByName('SUCHBESCHREIBUNG' + x.ToString).AsString := '%' + Trim(lSuchWorte[x]) + '%';
      end;
    end;

    //Suchfelder
    //RID,INTERN_INFO ==> BESCHREIBUNG,TITEL,VERLAG_R,
    //KOMPONIST_R,ARRANGEUR_R,CODE,
    //NUMERO,VERLAGNO,SORTIMENT_R,LAUFNUMMER,
    //WEBSHOP,GEMA_WN,GTIN

    q.Active := True;
    q.Last;
    q.First;

    if (q.RecordCount>iSuchlimitMaxSuchtreffer) then
    begin
      ShowMessage('Es gibt mehr als ' + iSuchlimitMaxSuchtreffer.ToString + ' Treffer! Bitte schränken Sie Ihre Suche ein!');
      exit;
    end;

    if q.RecordCount>=1 then
    begin
      q.first;
      ItemRIDs.clear;
      ItemRIDs.capacity := q.RecordCount;

      for i:=0 to q.RecordCount-1 do
      begin
       //GridFillFromList(ArtikelSucheWI.FoundList);
       ItemRIDs.add((pointer(q.FieldByName('RID').asInteger)));
       q.Next;
      end;

      GridSortieren;
      label6.caption := inttostr(q.RecordCount);
      GridRefresh;
      DrawGrid1.Row := 0;
    end
    else
    begin
      ShowMessage('Nichts gefunden!');
      Enabled := true;
      Edit1.SetFocus;
    end;

  finally
    q.Free;
    EndHourGlass;
    IB_Query1.refresh;
    lSuchWorte.Free;
    IB_Query1.EnableControls;
  end;
end;

procedure TFormInventur.GridRefresh;
begin
  LastRequestedRID := -1;
  DrawGrid1.RowCount := ItemRIDs.count;
  DrawGrid1.refresh;
  DrawGrid1.SetFocus;
end;

procedure TFormInventur.Button7Click(Sender: TObject);
var
  ARTIKEL_R: integer;
begin
  if not (IB_Query_Inventur.IsEmpty) then
  begin

    // aktuellen Artikel in den Auftrag übernehmen
    ARTIKEL_R := integer(ItemRIDS[DrawGrid1.row]);
    add(ARTIKEL_R);

    IB_Query_Artikel.refresh;
    edit1.SetFocus;
    EndHourGlass;
  end;

end;

procedure TFormInventur.DrawGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  SubItems: TStringList;
  OutStr: string;
begin
  if (arow >= 0) then
    with DrawGrid1.canvas do
    begin

      if odd(ARow) then
      begin
        brush.color := clWhite;
      end else
      begin
        brush.color := clListeGrau;
      end;

      if (ARow = DrawGrid1.Row) then
        brush.color := $0080FFFF;

      if ARow < itemRIDs.count then
      begin
        SubItems := LineDataFromRID1(integer(ItemRIDs[ARow]));

        if ItemMARKED.indexof(ItemRIDs[ARow]) <> -1 then
        begin
          if odd(ARow) then
          begin
            brush.color := HTMLColor2TColor($00CCFF);
          end else
          begin
            brush.color := HTMLColor2TColor($0099CC);
          end;

          if ARow = DrawGrid1.Row then
            brush.color := HTMLColor2TColor($99FF00);

        end;
{
 ----------------------------------
 1: Artikelnummer (Rang)
    Menge , Schwierigkeitsgrad
 2: OK

 3: Koponistz
    Arranger

 4: Menge2/Menge3
    Lieferbarkeit
 5: preis
 ----------------------------------
}

{
  eSuchSubs = ( ,
                ,
                eSS_Gattung,
                ,
                ,
                ,
                ,
                ,
}

        case ACol of
          0: begin
              font.size := 16;
              Font.Style := [fsbold];
              if gdSelected in State then
                TextRect(rect, rect.left + 2, rect.top, '»')
              else
                TextRect(rect, rect.left + 2, rect.top, '');
            end;
          1: begin
              // Nummer / Lager
              font.size := 8;
              Font.Style := [];
              TextRect(rect, rect.left + 5, rect.top, SubItems[ord(eSS_Numero)] + ' (' + SubItems[ord(eSS_Rang)] + ')');
              TextOut(rect.left + 5, rect.top + (rYL(Rect) div 2), SubItems[ord(eSS_Menge)] + 'x (Schw.: ' + SubItems[ord(eSS_Schwer)] + ')');
            end;
          2: begin
              // Titel
              font.size := 8;
              font.style := [];
              TextRect(rect, rect.left + 5, rect.top, SubItems[ord(eSS_Titel)]);
              TextOut(rect.left + 5, rect.top + (rYL(Rect) div 2), SubItems[ord(eSS_Land)] + '-' + SubItems[ord(eSS_Verlag)])
            end;
          3: begin
              // arang
              font.size := 8;
              font.style := [];
              TextRect(rect, rect.left + 5, rect.top, SubItems[ord(eSS_Komponist)]);
              TextOut(rect.left + 5, rect.top + (rYL(Rect) div 2), SubItems[ord(eSS_Arranger)])
            end;
          4: begin
              // Menge / Lager
              font.size := 8;
              Font.Style := [];

              // Lager:
              if (SubItems[ord(eSS_lager)] <> '') then
                Outstr := SubItems[ord(eSS_lager)] + ':'
              else
                OutStr := '';
              // PRO/DMO stimmen
              OutStr := OutStr + SubItems[ord(eSS_MengeProbe)] + '/' +
                SubItems[ord(eSS_MengeDemo)];

              TextRect(rect, rect.left + 5, rect.top, OutStr);
              TextOut(rect.left + 5, rect.top + (rYL(Rect) div 2), SubItems[ord(eSS_VersendeTag)]);
            end;
          5: begin
              // Preis
              font.size := 8;
              font.style := [];
              TextRect(rect, rect.left + 5, rect.top, SubItems[ord(eSS_Preis)]);
              TextOut(rect.left + 5, rect.top + (rYL(Rect) div 2), SubItems[ord(eSS_Serie)]);
            end;
        else
          FillRect(rect);
        end;

        if (ACol > 1) then
        begin
          pen.color := $A0A0A0;
          MoveTo(rect.left, rect.top);
          LineTo(rect.left, rect.bottom);
        end;

      end else
      begin
        FillRect(rect);
      end;
    end;

end;

procedure TFormInventur.DrawGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if DrawGrid1.RowCount > 0 then
    if (Key = #13) then
    begin
      Key := #0;
      Button7Click(Sender);
    end;
end;

procedure TFormInventur.FormCreate(Sender: TObject);
begin
  StartDebug('Inventur');
  top := 0;
  left := 0;
  ItemRIDs := TList.create;
  ItemMarked := TList.create;
  with DrawGrid1, canvas do
  begin
    DefaultRowHeight := 30;
    Font.Name := 'Verdana';
    Font.Size := 16;
    Font.Color := clblack;
    ColCount := 8;
    ColWidths[0] := 17; // Pfeil
    ColWidths[1] := 112; // Nummer (Rang) / Lager
    ColWidths[2] := 430; // Titel
    ColWidths[3] := 130; // Komp / Arra
    ColWidths[4] := 102; // Menge / verfügbarkei
    ColWidths[5] := 110; // Preis
    ClientHeight := succ(ClientHeight div DefaultRowHeight) * DefaultRowHeight;
    rowCount := 0;
  end;

end;

function TFormInventur.LineDataFromRID1(RID: integer): TStringList;
var
  SubItem: TStringList;
  n: integer;
  ArtikelInfo: TStringList;
  cARTIKEL: TIB_Cursor;
begin
 // Element im Cache?
  if LastRequestedRID = RID then
  begin
    result := LastRequestedSub;
    exit;
  end;

 // Altes Ergebnis löschen!
  if assigned(LastRequestedSub) then
    FreeAndNil(LastRequestedSub);

  ArtikelInfo := TStringList.create;

  cARTIKEL := DataModuleDatenbank.nCursor;
  with cARTIKEL do
  begin
    sql.add('select * from ARTIKEL where RID=' + inttostr(RID));
    ApiFirst;

    SubItem := TStringList.create;
    LastRequestedSub := SubItem;
    LastRequestedRID := RID;

    if eof then
    begin
      for n := 0 to pred(ord(eSS_Count)) do
        SubItem.add('');
    end else
    begin
      FieldByName('INTERN_INFO').AssignTo(Artikelinfo);

      {[0]}
      SubItem.add(FieldByName('TITEL').AsString);
      {[1]}
      SubItem.add(FieldByName('NUMERO').AsString);
      {[2]}
      SubItem.add(ArtikelInfo.Values['GATTUNG']);
      {[3]}
      SubItem.add(e_r_Verlag_PERSON_R(FieldByNAme('VERLAG_R').AsInteger));
      {[4]}
      SubItem.add(ArtikelInfo.Values['SERIE']);
      {[5]}
      if iGOT then
        SubItem.add(FieldByName('VERLAGNO').AsString)
      else
        SubItem.add(ArtikelInfo.Values['KOMPONIST']);
      {[6]}
      if iGOT then
        SubItem.add(FieldByName('CODE').AsString)
      else
        SubItem.add(ArtikelInfo.Values['ARRANGER']);
      {[7]}
      SubItem.add(format('%m', [e_r_PaketPreis(0, RID)]));
      {[8]}
      SubItem.add(ArtikelInfo.Values['SCHWER']);
      {[9]}
      SubItem.add(e_r_LaenderISO(FieldByName('LAND_R').AsInteger));
      {[10]}
      SubItem.add(FieldByName('MENGE').AsString);
      {[11]}
      SubItem.add(e_r_LagerPlatzNameFromLAGER_R(FieldByName('LAGER_R').AsInteger));
//      e_r_FormLager.ObtainNameFromRID());
      {[12]}
      SubItem.add(VersendetagToStr(e_r_ArtikelVersendetag(0, RID)));
      {[13]}
      SubItem.add(inttostr(trunc(FieldByName('RANG').AsDouble)));
      {[14]}
      SubItem.Add(FieldByName('MENGE_PROBE').AsString);
      {[15]}
      SubItem.Add(FieldByName('MENGE_DEMO').AsString);

    end;
  end;
  cARTIKEL.free;
  ArtikelInfo.free;
  result := SubItem;
end;


procedure TFormInventur.IB_Query_ArtikelAfterInsert(
  IB_Dataset: TIB_Dataset);
begin
  IB_Dataset.refresh;
end;

procedure TFormInventur.Button8Click(Sender: TObject);
begin
  if not (IB_Query_ARTIKEL.IsEmpty) then
    if doit('Diesen Artikel aus der Inventur entfernen?') then
    begin
      delete(IB_Query_ARTIKEL.FieldByName('RID').AsInteger);
      IB_Query_ARTIKEL.next;
    end;
end;

procedure TFormInventur.Button6Click(Sender: TObject);
begin
  // Auf den Artikel springen!
  FormArtikel.SetContext(IB_Query_ARTIKEL.FieldByName('RID').AsInteger);
end;

procedure TFormInventur.Button9Click(Sender: TObject);
begin
  if (ItemRIDS.count > 0) then
    if (DrawGrid1.row > 0) then
      FormArtikel.SetContext(integer(ItemRIDS[DrawGrid1.row]));
end;

procedure TFormInventur.RefreshNameList;
var
  cInventuren: TIB_Cursor;
begin
  ComboBox1.items.clear;
  cInventuren := DataModuleDatenbank.nCursor;
  with cInventuren do
  begin
    sql.add('select RID, NAME from inventur order by name');
    ApiFirst;
    while not (eof) do
    begin
      ComboBox1.items.addobject(FieldByName('NAME').AsString, TObject(FieldByNAme('RID').AsInteger));
      ApiNext;
    end;
  end;
  cInventuren.free;
end;

procedure TFormInventur.Button10Click(Sender: TObject);
var
  dARTIKEL: TIB_DSQL;
begin

  // 1) RID der Inventur "Menge>0" ermitteln
  with IB_Query_Inventur do
  begin

    if not (locate('NAME', cInventurviaMenge, [])) then
    begin
      insert;
      FieldByName('NAME').AsString := cInventurviaMenge;
      post;
      refresh;
    end;

    if not (locate('NAME', cInventurviaMenge, [])) then
      exit;
  end;

  // 2) alle Referenzen löschen
  BeginHourGlass;

  dARTIKEL := DataModuleDatenbank.nDSQL;
  with dARTIKEL do
  begin

    sql.add('update artikel set INVENTUR_R=NULL');
    sql.add('where INVENTUR_R=' + IB_Query_Inventur.FieldByName('RID').AsString);
    execute;

    sql.clear;
    sql.add('update artikel set INVENTUR_R=' + IB_Query_Inventur.FieldByName('RID').AsString);
    sql.add('where MENGE>0');
    execute;

  end;
  dARTIKEL.free;


  EndHourGlass;

end;

procedure TFormInventur.Add(RID: integer);
var
  dARTIKEL: TIB_DSQL;
begin
  dARTIKEL := DataModuleDatenbank.nDSQL;
  with dARTIKEL do
  begin
    sql.add('update artikel set inventur_r=' + IB_Query_Inventur.FieldByNAme('RID').AsString);
    sql.add('where RID=' + inttostr(RID));
    execute;
  end;
  dARTIKEL.free;
end;

procedure TFormInventur.Delete(RID: integer);
var
  dARTIKEL: TIB_DSQL;
begin
  dARTIKEL := DataModuleDatenbank.nDSQL;
  with dARTIKEL do
  begin
    sql.add('update artikel set INVENTUR_R=NULL');
    sql.add('where RID=' + inttostr(RID));
    execute;
  end;
  dARTIKEL.free;
end;

procedure TFormInventur.SpeedButton1Click(Sender: TObject);
begin
 if IB_Query_Inventur.FieldByName('RID').IsNotNull then
  if doit('Aktuelle Artikel-Liste wirklich neu beginnen') then
  begin
   BeginHourGlass;
   e_x_sql('update ARTIKEL set INVENTUR_R=null where INVENTUR_R='+IB_Query_Inventur.FieldByName('RID').AsString);
   IB_Query_Artikel.refresh;
   EndHourGlass;
  end;
end;

procedure TFormInventur.Start(RID: integer);
var
  qARTIKEL: TIB_QUERY;
begin

  BeginHourGLass;
  qARTIKEL := DataModuleDatenbank.nQuery;
  with qARTIKEL do
  begin
    sql.add('select');
    sql.add('INVENTUR_MWST,');
    sql.add('INVENTUR_MENGE,');
    sql.add('INVENTUR_PREIS,');
    sql.add('INVENTUR_RABATT,');
    sql.add('SORTIMENT_R,');
    sql.add('MENGE');
    sql.add('from ARTIKEL where RID=' + inttostr(RID));
    sql.add('for update');
    Open;
    first;
    edit;
    FieldByName('INVENTUR_MWST').AsDouble := e_r_MwSt(FieldByName('SORTIMENT_R').AsInteger);
    FieldByName('INVENTUR_MENGE').AsInteger := FieldByName('MENGE').AsInteger;
    FieldByName('INVENTUR_PREIS').AsDouble := e_r_PreisBrutto(0, RID);
    FieldByName('INVENTUR_RABATT').AsDouble := e_r_ekRabatt(RID);
    post;
    close;
  end;
  qARTIKEL.free;
  EndHourGLass;
end;

procedure TFormInventur.Inventur(RID, Menge, Menge_Labels: integer);
var
  qWARENBEWEGUNG: TIB_Query;
  qARTIKEL: TIB_Query;
  LAGER_R: integer;
begin
  BeginHourGlass;

  qARTIKEL := DataModuleDatenbank.nQuery;
  with qARTIKEL do
  begin
    sql.add('select MENGE, LAGER_R, INVENTUR_MOMENT from ARTIKEL where RID=' + inttostr(RID));
    sql.add('for update');
    Open;
    LAGER_R := FieldByName('LAGER_R').AsInteger;
    edit;
    FieldByName('MENGE').AsInteger := Menge;
    FieldByName('INVENTUR_MOMENT').AsDateTime := now;
    post;
  end;
  qARTIKEL.free;

  qWARENBEWEGUNG := DataModuleDatenbank.nQuery;
  with qWARENBEWEGUNG do
  begin
    sql.add('select * from WARENBEWEGUNG for update');
    insert;
    FieldByName('RID').AsInteger := 0;
    FieldByName('ARTIKEL_R').AsInteger := RID;
    FieldByName('MENGE_BISHER').AsInteger := Menge;
    FieldByName('MENGE_NEU').AsInteger := Menge;
    FieldByName('MENGE').AsInteger := Menge_Labels;
    if (LAGER_R > 0) then
      FieldByName('LAGER_R').AsInteger := LAGER_R;
    post;
  end;
  qWARENBEWEGUNG.free;

  EndHourGlass;
end;

procedure TFormInventur.Button11Click(Sender: TObject);
begin
  RefreshNameList;
end;

procedure TFormInventur.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    key := #0;
    if Checkbox3.checked then
      edit3.text := '0'
    else
      edit3.text := edit2.text;
    edit3.SetFocus;
  end;
end;

procedure TFormInventur.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) then
  begin
    key := #0;
    Inventur(IB_Query1.FieldByName('RID').AsInteger, strtointdef(edit2.text, 0), strtointdef(edit3.text, 0));
    IB_Query1.next;
    edit2.SetFocus;
  end;
end;

procedure TFormInventur.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  edit2.text := IB_Query1.FieldByNAme('MENGE').AsString;
end;

procedure TFormInventur.Button12Click(Sender: TObject);
var
  n: integer;
begin
  if not (IB_Query_Inventur.IsEmpty) then
  begin
    BeginHourGlass;
    for n := 0 to pred(ItemRIDS.count) do
      add(integer(ItemRIDS[n]));
    IB_Query_Artikel.refresh;
    edit1.SetFocus;
    EndHourGlass;
  end;
end;

procedure TFormInventur.Button2Click(Sender: TObject);
var
  cARTIKEL: TIB_Cursor;
begin
  if not (IB_Query_Inventur.IsEmpty) then
  begin
    if doit('Dadurch werden alle INVENTUR Datenfelder gelöscht!' + #13 +
      'Vorherige INVENTUR-Eingabe werden gelöscht!' + #13 +
      'Wirklich starten') then
    begin
      BEginHourGLass;
      cARTIKEL := DataModuleDatenbank.nCursor;
      with cARTIKEL do
      begin
        sql.add('select RID from ARTIKEL where INVENTUR_R=' + IB_Query_Inventur.FieldByName('RID').AsString);
        ApiFirst;
        while not (eof) do
        begin
          Start(FieldByName('RID').AsInteger);
          ApiNext;
        end;
      end;
      cARTIKEL.free;
      EndHourGLass;
    end;
  end;
end;

procedure TFormInventur.RefreshLagerList;
var
  AllNames: TStringList;
begin
  AllNames := FormLager.LagerNames;
  combobox2.items.clear;
  combobox2.items.addstrings(AllNames);
  combobox3.items.clear;
  combobox3.items.addstrings(AllNames);
  AllNames.free;
end;

procedure TFormInventur.RefreshVerlagList;
begin
  combobox4.items.clear;
  combobox4.items.addstrings(e_r_Verlage1);
end;

procedure TFormInventur.ComboBox2Change(Sender: TObject);
begin
  Combobox3.itemindex := combobox2.itemindex;
end;

procedure TFormInventur.GridFillFromList(TheList: TList);
var
  n: integer;
begin
  ItemRIDs.clear;
  ItemRIDs.capacity := TheList.count;
  for n := 0 to pred(TheList.count) do
    ItemRIDs.add(TheList[n]);
  GridSortieren;
  label6.caption := inttostr(TheList.count);
  GridRefresh;
  DrawGrid1.Row := 0;
end;

procedure TFormInventur.Button5Click(Sender: TObject);
var
  cARTIKEL: TIB_Cursor;
  ResultList: TList;
  n: integer;
begin
  BeginHourGlass;
  cARTIKEL := DataModuleDatenbank.nCursor;
  ResultList := TList.create;
  with cARTIKEL do
  begin
    sql.add('select RID from ARTIKEL where LAGER_R IN (');
    sql.add('select RID from LAGER where ');
    for n := combobox2.itemindex to combobox3.itemindex do
    begin
      sql.add('( NAME = ''' + combobox2.items[n] + ''')');
      if n < combobox3.itemindex then
        sql.add('OR');
    end;
    sql.add(')');
    ApiFirst;
    while not (eof) do
    begin
      ResultList.add(TObject(FieldByName('RID').AsInteger));
      ApiNext;
    end;
  end;
  cARTIKEL.free;
  GridFillFromList(ResultList);
  ResultList.free;
  EndHourGlass;
end;

procedure TFormInventur.Button13Click(Sender: TObject);
var
  cARTIKEL: TIB_Cursor;
  ResultList: TList;
begin
  BeginHourGlass;
  cARTIKEL := DataModuleDatenbank.nCursor;
  ResultList := TList.create;
  with cARTIKEL do
  begin
    sql.add(
      'select RID from ARTIKEL where VERLAG_R=' +
      inttostr(
      e_r_VerlagPerson(
      combobox4.items[combobox4.itemindex])));
    ApiFirst;
    while not (eof) do
    begin
      ResultList.add(TObject(FIeldByName('RID').AsInteger));
      ApiNext;
    end;
  end;
  cARTIKEL.free;
  GridFillFromList(ResultList);
  ResultList.free;
  EndHourGlass;
end;

procedure TFormInventur.FormDestroy(Sender: TObject);
begin
  ItemRIDs.free;
  ItemMarked.free;
end;

procedure TFormInventur.Button14Click(Sender: TObject);
begin
  with IB_Query1 do
    if not (FieldByName('RID').IsNull) then
      FormArtikel.SetContext(FieldByName('RID').AsInteger);
end;

end.

