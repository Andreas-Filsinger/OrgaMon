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
unit ArtikelContext;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  ExtCtrls, IB_UpdateBar,
  Grids, IB_Grid, IB_Components, IB_Access,
  StdCtrls, ComCtrls,
  Buttons, WordIndex, Mask,
  IB_Controls, JvGIF, IB_EditButton;

type
  TFormArtikelContext = class(TForm)
    IB_Grid1: TIB_Grid;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Query2: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    IB_Grid2: TIB_Grid;
    IB_UpdateBar2: TIB_UpdateBar;
    IB_Query3: TIB_Query;
    IB_DataSource3: TIB_DataSource;
    IB_UpdateBar3: TIB_UpdateBar;
    IB_Grid3: TIB_Grid;
    Label2: TLabel;
    Label3: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton9: TSpeedButton;
    Button8: TButton;
    Edit1: TEdit;
    DrawGrid1: TDrawGrid;
    Button18: TButton;
    Button22: TButton;
    Button24: TButton;
    OpenDialog1: TOpenDialog;
    IB_Query4: TIB_Query;
    IB_DataSource4: TIB_DataSource;
    IB_Edit1: TIB_Edit;
    IB_UpdateBar4: TIB_UpdateBar;
    Button3: TButton;
    Button4: TButton;
    SpeedButton1: TSpeedButton;
    Button7: TButton;
    Button9: TButton;
    Button10: TButton;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    IB_Edit2: TIB_Edit;
    Label6: TLabel;
    Label7: TLabel;
    Image2: TImage;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
    procedure IB_Query2BeforeInsert(IB_Dataset: TIB_Dataset);
    procedure IB_Query2AfterScroll(IB_Dataset: TIB_Dataset);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure DrawGrid1DblClick(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure DrawGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IB_Query3AfterScroll(IB_Dataset: TIB_Dataset);
    procedure Button8Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure IB_Query4AfterPost(IB_Dataset: TIB_Dataset);
    procedure Button7Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure IB_Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button10Click(Sender: TObject);
    procedure IB_Grid3DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure Image2Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure IB_Query4BeforePost(IB_Dataset: TIB_Dataset);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
  private
    { Private-Deklarationen }
    Abbruch: boolean;
    DoNotEnsureOpen: boolean;
    ItemRIDs: TList;
    ItemMarked: TList;
    LastRequestedRID: Integer;
    LastRequestedSub: TStringList;
    ArtikelSucheWI: TWordIndex;

    // für den Owner Draw Teil
    Lastrow: Integer;
    _NewCol: TColor;
    numero: string;

    procedure DoTheArtikelSearch;
    procedure AusSucheUebernehmen;
    function LineDataFromRID1(RID: Integer): TStringList;
    procedure GridRefresh;
    function Grid_ARTIKEL_R: Integer;
    procedure SetPosNo(RID, POSNO: Integer);

  public
    { Public-Deklarationen }
    procedure SetContextArtikel(ARTIKEL_R: Integer; num: string = '');
    procedure SetContextContext(MASTER_R: Integer; num: string = '');
    procedure SetDefaultQuery;
  end;

var
  FormArtikelContext: TFormArtikelContext;

implementation

uses
  globals,
  anfix32,
  systemd,
  html,
  dbOrgaMon,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  ArtikelVerlag, Bearbeiter,
  Artikel, ArtikelKategorie,
  GUIHelp, gpLists, CareTakerClient,
  Datenbank, wanfix32;

{$R *.dfm}

function TFormArtikelContext.LineDataFromRID1(RID: Integer): TStringList;
var
  SubItem: TStringList;
  n: Integer;
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

  // IB-Query auslesen!
  cARTIKEL := DataModuleDatenbank.nCursor;
  with cARTIKEL do
  begin
    SubItem := TStringList.create;
    LastRequestedSub := SubItem;
    LastRequestedRID := RID;

    sql.add('select TITEL,NUMERO,VERLAG_R,');
    sql.add('VERLAGNO, KOMPONIST_R,CODE,ARRANGEUR_R,RID,');
    sql.add('SCHWER_GRUPPE, SCHWER_DETAILS, LAND_R, MENGE, ');
    sql.add('MINDESTBESTAND,LAGER_R,RANG, MENGE_PROBE, ');
    sql.add('MENGE_DEMO from ARTIKEL where RID=' + inttostr(RID));
    ApiFirst;

    if eof then
    begin
      for n := 0 to pred(ord(eSS_Count)) do
        SubItem.add('');
    end
    else
    begin

      { [0] }
      SubItem.add(FieldByName('TITEL').AsString);
      { [1] }
      SubItem.add(FieldByName('NUMERO').AsString);
      { [2] }
      SubItem.add(''); // ehemals Gattung
      { [3] }
      SubItem.add(e_r_Verlag_PERSON_R(FieldByName('VERLAG_R').AsInteger));
      { [4] }
      SubItem.add(''); // ehemals Serie
      { [5] }
      if iGOT then
        SubItem.add(FieldByName('VERLAGNO').AsString)
      else
        SubItem.add(e_r_MusikerName(FieldByName('KOMPONIST_R').AsInteger));
      { [6] }
      if iGOT then
        SubItem.add(FieldByName('CODE').AsString)
      else
        SubItem.add(e_r_MusikerName(FieldByName('ARRANGEUR_R').AsInteger));
      { [7] }
      SubItem.add(e_r_PreisText(0, FieldByName('RID').AsInteger));
      { [8] }
      SubItem.add(FieldByName('SCHWER_GRUPPE').AsString + ' ' + FieldByName('SCHWER_DETAILS')
        .AsString);
      { [9] }
      SubItem.add(e_r_LaenderISO(FieldByName('LAND_R').AsInteger));
      { [10] }
      SubItem.add(FieldByName('MENGE').AsString + '/' + FieldByName('MINDESTBESTAND').AsString);
      { [11] }
      SubItem.add(e_r_LagerPlatzNameFromLAGER_R(FieldByName('LAGER_R').AsInteger));
      { [12] }
      SubItem.add(VersendetagToStr(e_r_ArtikelVersendetag(0, RID)));
      { [13] }
      SubItem.add(inttostr(trunc(FieldByName('RANG').AsDouble)));
      { [14] }
      SubItem.add(FieldByName('MENGE_PROBE').AsString);
      { [15] }
      SubItem.add(FieldByName('MENGE_DEMO').AsString);

    end;
  end;
  result := SubItem;
end;

procedure TFormArtikelContext.FormActivate(Sender: TObject);
begin
  if not(DoNotEnsureOpen) then
    if not(IB_Query1.Active) then
      IB_Query1.Open;
end;

procedure TFormArtikelContext.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  IB_Query2.PAramByNAme('CROSSREF').Assign(IB_Dataset.FieldByName('RID'));
  if not(IB_Query2.Active) then
    IB_Query2.Open;
end;

procedure TFormArtikelContext.IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
begin
  if IB_Dataset.FieldByName('CONTEXT_R').IsNull then
    IB_Dataset.FieldByName('CONTEXT_R').Assign(IB_Query1.FieldByName('RID'));
end;

procedure TFormArtikelContext.IB_Query2BeforeInsert(IB_Dataset: TIB_Dataset);
begin
  IB_Query2BeforePost(IB_Dataset);
end;

procedure TFormArtikelContext.IB_Query2AfterScroll(IB_Dataset: TIB_Dataset);
begin
  Lastrow := -1;
  IB_Query3.PAramByNAme('MR').Assign(IB_Dataset.FieldByName('RID'));
  IB_Query3.PAramByNAme('CR').Assign(IB_Query1.FieldByName('RID'));
  if not(IB_Query3.Active) then
    IB_Query3.Open;
end;

procedure TFormArtikelContext.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    DoTheArtikelSearch;
  end;

end;

procedure TFormArtikelContext.DrawGrid1DblClick(Sender: TObject);
begin
  AusSucheUebernehmen;
end;

procedure TFormArtikelContext.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
  State: TGridDrawState);
var
  WaitRect: TRect;
  SubItems: TStringList;
  OutStr: string;
begin
  if (ARow >= 0) then
    with DrawGrid1.canvas do
    begin

      if odd(ARow) then
      begin
        brush.color := clWhite;
      end
      else
      begin
        brush.color := clListeGrau;
      end;

      if (ARow = DrawGrid1.Row) then
        brush.color := $0080FFFF;

      if ARow < ItemRIDs.count then
      begin
        SubItems := LineDataFromRID1(Integer(ItemRIDs[ARow]));

        if ItemMarked.indexof(ItemRIDs[ARow]) <> -1 then
        begin
          if odd(ARow) then
          begin
            brush.color := HTMLColor2TColor($00CCFF);
          end
          else
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
          0:
            begin
              font.size := 16;
              font.Style := [fsbold];
              if gdSelected in State then
                TextRect(Rect, Rect.left + 2, Rect.top, '»')
              else
                TextRect(Rect, Rect.left + 2, Rect.top, '');
            end;
          1:
            begin
              // Nummer / Lager
              font.size := 8;
              font.Style := [];
              TextRect(Rect, Rect.left + 5, Rect.top, SubItems[ord(eSS_Numero)] + ' (' +
                SubItems[ord(eSS_Rang)] + ')');
              TextOut(Rect.left + 5, Rect.top + (rYL(Rect) div 2),
                SubItems[ord(eSS_Menge)] + ' (Schw.: ' + SubItems[ord(eSS_Schwer)] + ')');
            end;
          2:
            begin
              // Titel
              font.size := 8;
              font.Style := [];
              TextRect(Rect, Rect.left + 5, Rect.top, SubItems[ord(eSS_Titel)]);
              TextOut(Rect.left + 5, Rect.top + (rYL(Rect) div 2), SubItems[ord(eSS_Land)] + '-' +
                SubItems[ord(eSS_Verlag)])
            end;
          3:
            begin
              // arang
              font.size := 8;
              font.Style := [];
              TextRect(Rect, Rect.left + 5, Rect.top, SubItems[ord(eSS_Komponist)]);
              TextOut(Rect.left + 5, Rect.top + (rYL(Rect) div 2), SubItems[ord(eSS_Arranger)])
            end;
          4:
            begin

              // Menge / Lager
              font.size := 8;
              font.Style := [];

              // Lager:
              if (SubItems[ord(eSS_lager)] <> '') then
                OutStr := SubItems[ord(eSS_lager)] + ':'
              else
                OutStr := '';

              // PRO/DMO stimmen
              OutStr := OutStr + SubItems[ord(eSS_MengeProbe)] + '/' + SubItems[ord(eSS_MengeDemo)];

              //
              TextRect(Rect, Rect.left + 5, Rect.top, OutStr);
              TextOut(Rect.left + 5, Rect.top + (rYL(Rect) div 2), SubItems[ord(eSS_VersendeTag)]);
            end;
          5:
            begin
              // Preis
              font.size := 8;
              font.Style := [];
              TextRect(Rect, Rect.left + 5, Rect.top, SubItems[ord(eSS_Preis)]);
              TextOut(Rect.left + 5, Rect.top + (rYL(Rect) div 2), SubItems[ord(eSS_Serie)]);
            end;
        else
          FillRect(Rect);
        end;

        if (ACol > 1) then
        begin
          pen.color := $A0A0A0;
          MoveTo(Rect.left, Rect.top);
          LineTo(Rect.left, Rect.bottom);
        end;

      end
      else
      begin
        FillRect(Rect);
      end;
    end;

end;

procedure TFormArtikelContext.DrawGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if (DrawGrid1.RowCount > 0) then
    if (Key = #13) then
    begin
      Key := #0;
      AusSucheUebernehmen;
    end;
end;

procedure TFormArtikelContext.DoTheArtikelSearch;
var
  n: Integer;
begin
  BeginHourGlass;
  if not(assigned(ArtikelSucheWI)) then
  begin
    ArtikelSucheWI := TWordIndex.create(nil);
    ArtikelSucheWI.LoadFromFile(SearchDir + format(cArtikelSuchindexFName,
      [cArtikelSuchindexIntern]));
  end
  else
  begin
    ArtikelSucheWI.ReloadIfNew;
  end;

  ArtikelSucheWI.Search(Edit1.Text);
  if (ArtikelSucheWI.FoundList.count > 0) then
  begin
    ItemRIDs.clear;
    ItemRIDs.capacity := ArtikelSucheWI.FoundList.count;
    for n := 0 to pred(ArtikelSucheWI.FoundList.count) do
      ItemRIDs.add(ArtikelSucheWI.FoundList[n]);
    e_r_ArtikelSortieren(ItemRIDs);
    GridRefresh;
    DrawGrid1.Row := 0;
  end
  else
  begin
    ShowMessage('Nichts gefunden!');
    Edit1.SetFocus;
  end;
  EndHourGlass;

end;

procedure TFormArtikelContext.AusSucheUebernehmen;
var
  xMITGLIED: TIB_DSQL;
  POSNO: Integer;
  COLLECTION_R: Integer;
  CONTEXT_R: Integer;
begin
  BeginHourGlass;

  // Den Master Collektions-Artikel bestimmen
  if CheckBox1.checked then
    COLLECTION_R := Grid_ARTIKEL_R
  else
    COLLECTION_R := IB_Query2.FieldByName('RID').AsInteger;

  // Den Context_R noch bestimmen!
  CONTEXT_R := IB_Query1.FieldByName('RID').AsInteger;
  if (CONTEXT_R = 0) then
    CONTEXT_R := e_r_sql('select context_r from ARTIKEL_MITGLIED where MASTER_R=' +
      inttostr(COLLECTION_R));

  POSNO := e_r_sql('select max(POSNO) from ARTIKEL_MITGLIED where MASTER_R=' +
    inttostr(COLLECTION_R));
  xMITGLIED := DataModuleDatenbank.nDSQL;
  with xMITGLIED do
  begin
    sql.add('insert into ARTIKEL_MITGLIED (RID,ARTIKEL_R,CONTEXT_R,MASTER_R,POSNO) values');
    sql.add(' (0,' + inttostr(Grid_ARTIKEL_R) + ',' + inttostr(CONTEXT_R) + ',' +
      inttostr(COLLECTION_R) + ',' + inttostr(POSNO + 1) + ')');
    execute;
  end;
  if CheckBox1.checked then
  begin
    IB_Query2.refresh;
    IB_Query2.locate('RID', Grid_ARTIKEL_R, []);
    CheckBox1.checked := false;
  end
  else
  begin
    IB_Query3.refresh;
    IB_Query3.locate('POSNO', POSNO + 1, []);
  end;
  xMITGLIED.free;
  Edit1.SetFocus;
  EndHourGlass;
end;

procedure TFormArtikelContext.SpeedButton9Click(Sender: TObject);
var
  ImportL: TStringList;
  n: Integer;
begin
  OpenDialog1.InitialDir := iOlapPath;
  if OpenDialog1.execute then
  begin
    BeginHourGlass;
    ImportL := TStringList.create;
    ImportL.LoadFromFile(OpenDialog1.FileName);

    ItemRIDs.clear;
    ItemRIDs.capacity := pred(ImportL.count);
    for n := 1 to pred(ImportL.count) do
      ItemRIDs.add(pointer(strtointdef(nextp(ImportL[n], ';', 0), -1)));
    ImportL.free;
    GridRefresh;
    EndHourGlass;
  end;
end;

procedure TFormArtikelContext.GridRefresh;
begin
  LastRequestedRID := -1;
  Label3.caption := inttostr(ItemRIDs.count);
  DrawGrid1.RowCount := ItemRIDs.count;
  DrawGrid1.refresh;
  DrawGrid1.SetFocus;
end;

procedure TFormArtikelContext.FormCreate(Sender: TObject);
begin
  ItemRIDs := TList.create;
  ItemMarked := TList.create;
  with DrawGrid1, canvas do
  begin
    DefaultRowHeight := 30;
    font.Name := 'Verdana';
    font.size := 16;
    font.color := clblack;
    ColCount := 8;
    ColWidths[0] := 17; // Pfeil
    ColWidths[1] := 112; // Nummer (Rang) / Lager
    ColWidths[2] := 430; // Titel
    ColWidths[3] := 130; // Komp / Arra
    ColWidths[4] := 102; // Menge / verfügbarkei
    ColWidths[5] := 110; // Preis
    // ClientHeight := pred(ClientHeight div DefaultRowHeight) * DefaultRowHeight;
    RowCount := 0;
  end;
end;

procedure TFormArtikelContext.FormDestroy(Sender: TObject);
begin
  ItemRIDs.free;
  ItemMarked.free;
end;

procedure TFormArtikelContext.IB_Query3AfterScroll(IB_Dataset: TIB_Dataset);
begin
  IB_Query4.PAramByNAme('CROSSREF').Assign(IB_Dataset.FieldByName('RID'));
  if not(IB_Query4.Active) then
    IB_Query4.Open;
end;

function TFormArtikelContext.Grid_ARTIKEL_R: Integer;
begin
  if (ItemRIDs.count > 0) then
    result := Integer(ItemRIDs[DrawGrid1.Row])
  else
    result := -1;
end;

procedure TFormArtikelContext.Button8Click(Sender: TObject);
begin
  if (ItemRIDs.count > 0) then
    FormArtikel.SetContext(Grid_ARTIKEL_R);
end;

procedure TFormArtikelContext.Button24Click(Sender: TObject);
begin
  if (ItemRIDs.count > 0) then
    FormArtikelKategorie.execute(Grid_ARTIKEL_R);
end;

procedure TFormArtikelContext.Button22Click(Sender: TObject);
begin
  if (ItemRIDs.count > 0) then
    GUIHelp.HeBuPlaySound(Grid_ARTIKEL_R);
end;

procedure TFormArtikelContext.SpeedButton2Click(Sender: TObject);
begin
  if (ItemRIDs.count > 0) then
    HeBuPDF(Grid_ARTIKEL_R);
end;

procedure TFormArtikelContext.SpeedButton3Click(Sender: TObject);
begin
  with IB_Query3 do
  begin
    if doit('Artikel ' + #13 + FieldByName('NUMERO').AsString + #13 + FieldByName('TITEL').AsString
      + #13 + 'wirklich vom Artikel lösen?') then
    begin
      e_x_sql('update ARTIKEL_MITGLIED set ARTIKEL_R = null where RID=' + FieldByName('RID')
        .AsString);
      refresh;
    end;
  end;
end;

procedure TFormArtikelContext.SpeedButton4Click(Sender: TObject);
begin
  e_x_sql('update ARTIKEL_MITGLIED set TITEL = null where RID=' + IB_Query3.FieldByName('RID')
    .AsString);
  IB_Query3.refresh;
end;

procedure TFormArtikelContext.SpeedButton5Click(Sender: TObject);
var
  ARTIKEL_MITGLIED_R: Integer;
  CONTEXT_R: Integer;
  MASTER_R: Integer;
  POSNO: Integer;
begin
  // Neuanlage
  CONTEXT_R := IB_Query1.FieldByName('RID').AsInteger;
  MASTER_R := IB_Query2.FieldByName('RID').AsInteger;
  if not(IB_Query3.eof) then
    POSNO := IB_Query3.FieldByName('POSNO').AsInteger + 1
  else
    POSNO := 1;

  IB_Query3.close;
  // Neuanlage
  ARTIKEL_MITGLIED_R := e_w_gen('GEN_ARTIKEL_MITGLIED');
  e_x_sql(format('insert into ARTIKEL_MITGLIED (RID,CONTEXT_R,MASTER_R,POSNO) values (%d,%d,%d,%d)',
    [ARTIKEL_MITGLIED_R, CONTEXT_R, MASTER_R, POSNO]));
  IB_Query3.Open;
  IB_Query3.locate('RID', ARTIKEL_MITGLIED_R, []);

end;

procedure TFormArtikelContext.SpeedButton6Click(Sender: TObject);
begin
  with IB_Query3 do
  begin
    if doit('Artikel ' + #13 + FieldByName('NUMERO').AsString + #13 + FieldByName('TITEL').AsString
      + #13 + 'wirklich aus dem Context entfernen') then
    begin
      e_x_sql('delete from ARTIKEL_MITGLIED where RID=' + FieldByName('RID').AsString);
      refresh;
    end;
  end;

end;

procedure TFormArtikelContext.SpeedButton7Click(Sender: TObject);
begin
  with IB_Query2 do
  begin
    if doit('Sind Sie sicher, dass Sie die Collection ' + #13 + FieldByName('TITEL').AsString + #13
      + 'löschen wollen') then
    begin
      // lösche alle CONTEXT_R Mitglieder!
      e_x_sql('delete from ARTIKEL_MITGLIED where MASTER_R=' + FieldByName('RID').AsString);
      // lösche den Datensatz selbst
      // e_x_sql('delete from ARTIKEL_CONTEXT where RID=' + FieldByNAme('RID').AsString);
    end;
    refresh;
  end;
end;

procedure TFormArtikelContext.SpeedButton8Click(Sender: TObject);
const
  cGimpExecutePath: string = '';
  cGimpScriptPath: string = '';
  cGimpScriptExtension = '.scm';
  cFontName = 'Verdana Bold';
  dx = 130;
  dy = 80;
  ZwischenraumX = 3;
  ZwischenraumY = 3;
var
  Prefix: string;
  // DB-Caching
  CONTEXT_R: Integer;
  MASTER_R: Integer;
  PAPERCOLOR: Integer;
  SECTION_PAPERCOLOR: Integer;
  ARTIKEL_R: Integer;

  cARTIKEL: TIB_Cursor;
  sql: TStringList;
  sCOLLECTION: TsTable;
  FolienIndex: Integer;
  TabIndex: Integer;
  sGimpScript: TStringList;
  sCallScript: TStringList;
  sTouch: TStringList;
  ButtonCaption: string;
  FunktionsName: string;
  x, y: Integer;
  execStr: string;

  function Gimp_FileName(s: string): string;
  begin
    result := s;
    ersetze('\', '/', result);
  end;

  function Gimp_Color(c: Integer): string;
  begin
    result := '''(' +
    { } inttostr(GetRValue(c)) + ' ' +
    { } inttostr(GetGValue(c)) + ' ' +
    { } inttostr(GetBValue(c)) + ')';
  end;

  procedure Gimp_Button(x, y, PAPERCOLOR: Integer; sText: TStringList; TextSize: Integer;
    Disabled: boolean = false); overload;
  var
    _x, _y: Integer;
    TextSize2: Integer;
    d: Double;
  begin
    _x := x * dx + ZwischenraumX;
    _y := y * dy + ZwischenraumY;
    d := TextSize;
    TextSize2 := round(d * 0.8);
    with sGimpScript do
    begin
      if not(Disabled) then
      begin

        add(format
          ('  (gimp-round-rect-select das-bild %d %d %d %d 6 5 CHANNEL-OP-REPLACE TRUE FALSE 0 0)',
          [
          { } _x,
          { } _y,
          { } dx - 2 * ZwischenraumX,
          { } dy - 2 * ZwischenraumY]));

        add('  (gimp-palette-set-foreground ''(66 66 66))');
        add('  (gimp-palette-set-background ''(100 100 100))');
        add(format
          ('  (gimp-edit-blend text-layer FG-BG-RGB-MODE NORMAL-MODE GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE FALSE 1 0 FALSE %d %d %d %d)',
          [_x, _y, _x, _y + dy]));

        add('  (gimp-selection-shrink das-bild 2)');
        add('  (gimp-palette-set-foreground ' + Gimp_Color(PAPERCOLOR) + ')');
        add('  (gimp-palette-set-background ''(255 255 255))');

        add(format
          ('  (gimp-edit-blend text-layer FG-BG-RGB-MODE NORMAL-MODE GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE FALSE 1 0 FALSE %d %d %d %d)',
          [_x, _y + dy, _x, _y]));
      end;
      add('  (gimp-palette-set-foreground ''(0 0 0))');
      add(format('  (gimp-text-fontname das-bild text-layer %d %d "%s" 0 TRUE %d PIXELS "%s")', [
        { x } _x + 2 * ZwischenraumX,
        { y } _y + 3 * ZwischenraumY,
        { Text } sText[0],
        { Pixel } TextSize,
        { FontName } cFontName]));
      if sText.count > 1 then
        add(format('  (gimp-text-fontname das-bild text-layer %d %d "%s" 0 TRUE %d PIXELS "%s")', [
          { x } _x + 2 * ZwischenraumX,
          { y } _y + 4 * ZwischenraumY + TextSize,
          { Text } sText[1],
          { Pixel } TextSize2,
          { FontName } cFontName]));
      if sText.count > 2 then
        add(format('  (gimp-text-fontname das-bild text-layer %d %d "%s" 0 TRUE %d PIXELS "%s")', [
          { x } _x + 2 * ZwischenraumX,
          { y } _y + 5 * ZwischenraumY + TextSize + TextSize2,
          { Text } sText[2],
          { Pixel } TextSize2,
          { FontName } cFontName]));
    end;
  end;

  procedure Gimp_Button(x, y, PAPERCOLOR: Integer; sText: string; TextSize: Integer;
    Disabled: boolean = false); overload;
  var
    sTextAsStringList: TStringList;
  begin
    sTextAsStringList := TStringList.create;
    sTextAsStringList.add(sText);
    Gimp_Button(x, y, PAPERCOLOR, sTextAsStringList, TextSize, Disabled);
    sTextAsStringList.free;
  end;

  procedure Gimp_ButtonSystem(x, y, PAPERCOLOR: Integer; sText: string; TextSize: Integer;
    Disabled: boolean = false; dy: Integer = 64);
  const
    dx = 88;
  var
    SystemArea: string;
  begin
    // System-Touch-Bereich bekannt machen
    SystemArea := format('System-%s@%s=%d;%d;%d;%d', [sText, inttostr(MASTER_R), x, y, dx, dy]);
    if (sTouch.indexof(SystemArea) = -1) then
      sTouch.add(SystemArea);

    with sGimpScript do
    begin
      if not(Disabled) then
      begin

        add(format
          ('  (gimp-round-rect-select das-bild %d %d %d %d 6 5 CHANNEL-OP-REPLACE TRUE FALSE 0 0)',
          [
          { } x,
          { } y,
          { } dx - 2 * ZwischenraumX,
          { } dy - 2 * ZwischenraumY]));

        add('  (gimp-palette-set-foreground ''(66 66 66))');
        add('  (gimp-palette-set-background ''(100 100 100))');
        add(format
          ('  (gimp-edit-blend text-layer FG-BG-RGB-MODE NORMAL-MODE GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE FALSE 1 0 FALSE %d %d %d %d)',
          [x, y, x, y + dy]));

        add('  (gimp-selection-shrink das-bild 2)');
        add('  (gimp-palette-set-foreground ' + Gimp_Color(PAPERCOLOR) + ')');
        add('  (gimp-palette-set-background ''(110 110 110))');

        add(format
          ('  (gimp-edit-blend text-layer FG-BG-RGB-MODE NORMAL-MODE GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE FALSE 1 0 FALSE %d %d %d %d)',
          [x, y + dy, x, y]));

      end;
      add('  (gimp-palette-set-foreground ''(255 255 255))');
      add(format('  (gimp-text-fontname das-bild text-layer %d %d "%s" 0 TRUE %d PIXELS "%s")', [
        { x } x + 2 * ZwischenraumX,
        { y } y + 2 * ZwischenraumY,
        { Text } sText,
        { Pixel } TextSize,
        { FontName } cFontName]));
    end;
  end;

  procedure Gimp_Save(Script: TStringList; FunktionsName: string);
  var
    SkriptFileName: string;
  begin
    SkriptFileName :=
    { } cGimpScriptPath +
    { } FunktionsName +
    { } cGimpScriptExtension;
    Script.SaveToFile(SkriptFileName, TEncoding.UTF8);

    // Gimp Bug, can not cope with BOM
    FileRemoveBOM(SkriptFileName);
  end;

var
  sButtonText: TStringList;

begin
  sql := TStringList.create;
  sButtonText := TStringList.create;

  sTouch := TStringList.create;
  with sTouch do
  begin
    add('dx=' + inttostr(dx));
    add('dy=' + inttostr(dy));
  end;

  with IB_Query1 do
  begin
    Prefix := FieldByName('BEZEICHNUNG').AsString;
    CONTEXT_R := FieldByName('RID').AsInteger;
  end;

  sGimpScript := TStringList.create;
  sCallScript := TStringList.create;

  sql := TStringList.create;
  sql.add('select');
  sql.add(' ARTIKEL.RID,');
  sql.add(' ARTIKEL.NUMERO,');
  sql.add(' ARTIKEL.TITEL,');
  sql.add(' ARTIKEL.PAPERCOLOR');
  sql.add('from');
  sql.add(' ARTIKEL_MITGLIED');
  sql.add('join');
  sql.add(' ARTIKEL');
  sql.add('on');
  sql.add(' (ARTIKEL.RID=ARTIKEL_MITGLIED.MASTER_R)');
  sql.add('where');
  sql.add(' CONTEXT_R=' + inttostr(CONTEXT_R));
  sql.add('group by');
  sql.add(' ARTIKEL_MITGLIED.MASTER_R,');
  sql.add(' ARTIKEL.RID,');
  sql.add(' ARTIKEL.NUMERO,');
  sql.add(' ARTIKEL.TITEL,');
  sql.add(' ARTIKEL.PAPERCOLOR');

  ExportTable(sql, SystemPath + '\' + 'Folien.csv');

  sCOLLECTION := csTable(sql);
  sCOLLECTION.SaveToHTML(SystemPath + '\' + 'Folien.html');

  cGimpExecutePath := ProgramFilesDir + 'GIMP-2.0\bin\';
  cGimpScriptPath := ProgramFilesDir + 'GIMP-2.0\share\gimp\2.0\scripts\';

  sCallScript := TStringList.create;

  with sCallScript do
  begin
    add(';');
    add('; ' + cOrgaMonCopyright);
    add(';');
    add('; Dieses Skript wurde automatisch generiert durch');
    add('; OrgaMon -> Context -> Touchfolien erstellen.');
    add('; Manuelle Änderungen werden bei der nächsten Generierung überschrieben!');
    add(';');
    add('');
    add('(define (' + Prefix + ')');
  end;

  for FolienIndex := 1 to pred(sCOLLECTION.count) do
  begin

    MASTER_R := strtointdef(sCOLLECTION.readCell(FolienIndex, 0), cRID_Null);

    // E R Z E U G E   D E N   G I M P  (Script Fu)
    sGimpScript.clear;
    FunktionsName := Prefix + '-' + inttostrN(FolienIndex, 3);
    sCallScript.add(' (' + FunktionsName + ')');
    with sGimpScript do
    begin

      add(';');
      add('; ' + cOrgaMonCopyright);
      add(';');
      add('; Dieses Skript wurde automatisch generiert durch');
      add('; OrgaMon -> Context -> Touchfolien erstellen.');
      add('; Manuelle Änderungen werden bei der nächsten Generierung überschrieben!');
      add(';');
      add('');
      add('(define (' + FunktionsName + ')');

      add(' (let*');
      add('  (');
      add('     (das-bild 1)');
      add('     (text-layer 0)');
      add('     (ergebnis-layer 0)');
      add('  )');
      add('  (set! das-bild (car (gimp-image-new 1366 768 RGB)))');
      add('  (set! text-layer (car(gimp-layer-new das-bild 1366 768 RGB-IMAGE "Text" 100 NORMAL)))');
      add('  (gimp-image-add-layer das-bild text-layer 0)');
      add('  (gimp-context-set-background ''(255 255 255) )');
      add('  (gimp-context-set-foreground ''(0 0 0))');
      add('  (gimp-drawable-fill text-layer BACKGROUND-FILL)');

      // Copyright
      add(format('   (gimp-text-fontname das-bild text-layer %d %d "%s" 0 TRUE %d PIXELS "%s")', [
        { x } ZwischenraumX,
        { y } 755,
        { Text } cOrgaMonCopyright,
        { Size } 10,
        { FontName } cFontName]));

      // S Y S T E M
      Gimp_ButtonSystem(1279, 464 + 0, clblack, 'Storno', 15, false);
      Gimp_ButtonSystem(1279, 464 + 62, clblack, 'Merke', 20, false, 61);

      if bErlaubnis('Kasse Tine') then
      begin
        Gimp_ButtonSystem(1279, 464 + 62 + 59, clblack, 'Gegeben', 12, false, 120);
        Gimp_ButtonSystem(1279, 464 + 62 + 59 + 59 + 59, clblack, 'Bon', 30, false, 61);
      end
      else
      begin
        Gimp_ButtonSystem(1279, 464 + 62 + 59, clblack, 'Gegeben', 12, false, 61);
        Gimp_ButtonSystem(1279, 464 + 62 + 59 + 59, clblack, 'Bar', 30, false, 61);
        Gimp_ButtonSystem(1279, 464 + 62 + 59 + 59 + 59, clblack, 'Bon', 30, false, 61);
      end;

      // Die Navigation
      x := 0;
      y := 0;
      for TabIndex := 1 to pred(sCOLLECTION.count) do
      begin
        // Sektions-Farbe
        PAPERCOLOR := strtoint(sCOLLECTION.readCell(TabIndex, 3));

        // Übergabe der Sektionsfarbe
        if TabIndex = FolienIndex then
          SECTION_PAPERCOLOR := PAPERCOLOR;

        // Sektions-Button zeichnen
        Gimp_Button(x, y, PAPERCOLOR, sCOLLECTION.readCell(TabIndex, 2), 20,
          TabIndex = FolienIndex);

        if (FolienIndex = 1) then
          sTouch.add(inttostr(x) + 'x' + inttostr(y) + '=' +
            { } 'Reiter;' +
            { } inttostr(TabIndex) + ';' +
            { } sCOLLECTION.readCell(TabIndex, 0));

        inc(x);
      end;

      // Die Schalter
      cARTIKEL := DataModuleDatenbank.nCursor;
      with cARTIKEL do
      begin
        sql.add('select');
        sql.add(' ARTIKEL.RID ARTIKEL_R,');
        sql.add(' COALESCE( ARTIKEL_MITGLIED.TITEL, ARTIKEL.TITEL ) TITEL,');
        sql.add(' ARTIKEL.PAPERCOLOR,');
        sql.add(' ARTIKEL.INTERN_INFO');
        sql.add('from');
        sql.add(' ARTIKEL_MITGLIED');
        sql.add('left join');
        sql.add(' Artikel');
        sql.add('on');
        sql.add(' ARTIKEL_MITGLIED.ARTIKEL_R=ARTIKEL.RID');
        sql.add('where');
        sql.add(' (ARTIKEL_MITGLIED.MASTER_R=' + inttostr(MASTER_R) + ') and');
        sql.add(' (ARTIKEL_MITGLIED.CONTEXT_R=' + inttostr(CONTEXT_R) + ')');
        sql.add('order by');
        sql.add(' ARTIKEL_MITGLIED.POSNO');

        ExportTable(sql, SystemPath + '\' + 'Folie-' + inttostr(MASTER_R) + '-' +
          inttostr(CONTEXT_R) + '.csv');

        x := 0;
        y := 1;
        ApiFirst;
        while not(eof) do
        begin
          repeat

            ButtonCaption := FieldByName('TITEL').AsString;
            if (ButtonCaption = '') then
            begin
              inc(y);
              x := 0;
              break;
            end;

            FieldByName('INTERN_INFO').AssignTo(sButtonText);
            if (sButtonText.count < 2) then
              sButtonText.clear;
            if (sButtonText.count = 0) then
              sButtonText.add(ButtonCaption);

            ARTIKEL_R := FieldByName('ARTIKEL_R').AsInteger;
            if FieldByName('PAPERCOLOR').IsNull then
              PAPERCOLOR := SECTION_PAPERCOLOR
            else
              PAPERCOLOR := FieldByName('PAPERCOLOR').AsInteger;

            // normaler Button
            Gimp_Button(x, y, PAPERCOLOR, sButtonText, 17);

            sTouch.add(inttostr(x) + 'x' + inttostr(y) + '@' + inttostr(MASTER_R) + '=Artikel;' +
              inttostr(ARTIKEL_R));

            inc(x);
          until true;

          ApiNext;
        end;
      end;
      cARTIKEL.free;

      // ;  S A V E
      add('  (set! ergebnis-layer (car(gimp-image-merge-visible-layers das-bild CLIP-TO-BOTTOM-LAYER)))');
      add('  (file-bmp-save RUN-NONINTERACTIVE das-bild ergebnis-layer "' + Gimp_FileName(
        { } SystemPath + '\' +
        { } FunktionsName + '.bmp') +
        { } '" "")');

      // ; Q U I T
      add(' )');
      add(')');
    end;

    // Gimp - Script ausgeben
    Gimp_Save(sGimpScript, FunktionsName);

  end;

  //
  sCallScript.add(' (gimp-quit TRUE)');
  sCallScript.add(')');
  Gimp_Save(sCallScript, Prefix);

  // Gimp anhauen!
  execStr :=
  { } cGimpExecutePath +
  { } 'gimp-console-2.6.exe' +
  { } ' ' +
  { } '--verbose ' +
  { } '--batch="(' + Prefix + ')"';
  CallExternalApp(execStr, SW_SHOWNORMAL);


  sTouch.SaveToFile(SystemPath + '\' + 'Kasse-Touch.ini');

  sGimpScript.free;
  sCallScript.free;
  sTouch := TStringList.create;
  sButtonText.free;
  sql.free;
  sCOLLECTION.free;
end;

procedure TFormArtikelContext.IB_Query4AfterPost(IB_Dataset: TIB_Dataset);
var
  ARTIKEL_MITGLIED_R: Integer;
begin
  with IB_Query3 do
  begin
    ARTIKEL_MITGLIED_R := FieldByName('RID').AsInteger;
    refresh;
    locate('RID', ARTIKEL_MITGLIED_R, []);
  end;
end;

procedure TFormArtikelContext.IB_Query4BeforePost(IB_Dataset: TIB_Dataset);
begin
  with IB_Dataset do
    if FieldByName('TITEL').IsNotNull then
      if (FieldByName('TITEL').AsString = '') then
        FieldByName('TITEL').clear;
end;

procedure TFormArtikelContext.SetPosNo(RID, POSNO: Integer);
var
  POSTEN: TIB_DSQL;
begin
  POSTEN := DataModuleDatenbank.nDSQL;
  with POSTEN do
  begin
    sql.add('UPDATE ARTIKEL_MITGLIED SET POSNO = ' + inttostr(POSNO) + ' WHERE RID = ' +
      inttostr(RID));
    execute;
  end;
  POSTEN.free;
end;

procedure TFormArtikelContext.Button7Click(Sender: TObject);
var
  RID1, POSNO1: Integer;
  RID2, POSNO2: Integer;
begin
  // UP
  with IB_Query3 do
    if not(bof) then
    begin
      // swap posno with upper neighbour
      RID2 := FieldByName('RID').AsInteger;
      POSNO2 := FieldByName('POSNO').AsInteger;
      prior;
      if not(bof) then
      begin
        RID1 := FieldByName('RID').AsInteger;
        POSNO1 := FieldByName('POSNO').AsInteger;
        if (RID1 <> RID2) then
        begin
          SetPosNo(RID1, POSNO2);
          SetPosNo(RID2, POSNO1);
          locate('RID', RID1, []);
        end
        else
        begin
          locate('RID', RID2, []);
        end;
      end
      else
      begin
        locate('RID', RID2, []);
        beep;
      end;
      refresh;
    end;
end;

procedure TFormArtikelContext.Button9Click(Sender: TObject);
var
  RID1, POSNO1: Integer;
  RID2, POSNO2: Integer;
begin
  // DOWN
  with IB_Query3 do
    if not(eof) then
    begin
      // swap posno with upper neighbour
      RID2 := FieldByName('RID').AsInteger;
      POSNO2 := FieldByName('POSNO').AsInteger;
      next;
      if not(eof) then
      begin
        RID1 := FieldByName('RID').AsInteger;
        POSNO1 := FieldByName('POSNO').AsInteger;
        if (RID1 <> RID2) then
        begin
          SetPosNo(RID1, POSNO2);
          SetPosNo(RID2, POSNO1);
          locate('RID', RID1, []);
        end
        else
        begin
          locate('RID', RID2, []);
        end;
      end
      else
      begin
        locate('RID', RID2, []);
        beep;
      end;
      refresh;
    end;
end;

procedure TFormArtikelContext.SpeedButton1Click(Sender: TObject);
var
  POSNO: Integer;
begin
  with IB_Query3 do
  begin
    first;
    POSNO := 1;
    while not(eof) do
    begin
      SetPosNo(FieldByName('RID').AsInteger, POSNO);
      inc(POSNO);
      next;
    end;
    refresh;
  end;
end;

procedure TFormArtikelContext.Button4Click(Sender: TObject);
begin
  FormArtikel.SetContext(IB_Query3.FieldByName('ARTIKEL_R').AsInteger);
end;

procedure TFormArtikelContext.Button3Click(Sender: TObject);
begin
  FormArtikel.SetContext(IB_Query2.FieldByName('RID').AsInteger);
end;

procedure TFormArtikelContext.IB_Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    IB_Query4.post;
    Key := #0;
  end;
end;

procedure TFormArtikelContext.SetContextArtikel(ARTIKEL_R: Integer; num: string = '');
var
  lMASTER: TgpIntegerList;
begin
  BeginHourGlass;
  lMASTER := e_r_sqlm('select distinct MASTER_R from ARTIKEL_MITGLIED where ARTIKEL_R=' +
    inttostr(ARTIKEL_R));
  EndHourGlass;
  if (lMASTER.count > 0) then
  begin
    //
    numero := num;
    BeginHourGlass;
    IB_Query1.close;
    IB_Query2.close;
    IB_Query2.sql.clear;
    IB_Query2.sql.add('select');
    IB_Query2.sql.add(' A.RID,');
    IB_Query2.sql.add(' A.NUMERO,');
    IB_Query2.sql.add(' A.TITEL');
    IB_Query2.sql.add('from ARTIKEL_MITGLIED');
    IB_Query2.sql.add('join artikel A on');
    IB_Query2.sql.add(' A.RID=ARTIKEL_MITGLIED.MASTER_R');
    IB_Query2.sql.add('where ARTIKEL_MITGLIED.MASTER_R IN ' + lMASTER.AsString);
    IB_Query2.sql.add('Group by ARTIKEL_MITGLIED.MASTER_R,A.RID,A.NUMERO,A.TITEL');
    IB_Query2.Open;
    DoNotEnsureOpen := true;
    show;
    DoNotEnsureOpen := false;
    EndHourGlass;
  end
  else
  begin
    SetDefaultQuery;
    ShowMessage('Nichts gefunden!');
  end;
  lMASTER.free;
end;

procedure TFormArtikelContext.SetContextContext(MASTER_R: Integer; num: string = '');
begin
  BeginHourGlass;
  //
  numero := num;
  IB_Query1.close;
  IB_Query2.close;
  IB_Query2.sql.clear;
  IB_Query2.sql.add(' select');
  IB_Query2.sql.add('A.RID,');
  IB_Query2.sql.add('A.NUMERO,');
  IB_Query2.sql.add('A.TITEL');
  IB_Query2.sql.add('from ARTIKEL_MITGLIED');
  IB_Query2.sql.add('join artikel A on');
  IB_Query2.sql.add('A.RID=ARTIKEL_MITGLIED.MASTER_R');
  IB_Query2.sql.add('where ARTIKEL_MITGLIED.MASTER_R = ' + inttostr(MASTER_R));
  IB_Query2.sql.add('Group by ARTIKEL_MITGLIED.MASTER_R,A.RID,A.NUMERO,A.TITEL');
  IB_Query2.Open;
  if IB_Query2.eof then
  begin
    SetDefaultQuery;
    EndHourGlass;
    ShowMessage('Nichts gefunden!');
  end
  else
  begin
    DoNotEnsureOpen := true;
    show;
    DoNotEnsureOpen := false;
    EndHourGlass;
  end;
end;

procedure TFormArtikelContext.SetDefaultQuery;
begin
  with IB_Query2 do
  begin
    numero := '';
    close;
    sql.clear;
    sql.add('select');
    sql.add('A.RID,');
    sql.add('A.NUMERO,');
    sql.add('A.TITEL');
    sql.add('from ARTIKEL_MITGLIED');
    sql.add('join artikel A on');
    sql.add('A.RID=ARTIKEL_MITGLIED.MASTER_R');
    sql.add('where CONTEXT_R=:CROSSREF');
    sql.add('Group by ARTIKEL_MITGLIED.MASTER_R,A.RID,A.NUMERO,A.TITEL');
  end;
end;

procedure TFormArtikelContext.Button10Click(Sender: TObject);
begin
  IB_Query1.close;
  SetDefaultQuery;
  IB_Query1.Open;
end;

procedure TFormArtikelContext.IB_Grid3DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
  State: TGridDrawState);
var
  _CellDisplayText: string;
begin
  with IB_Grid3 do
  begin

    // important: set DefDrawBefore to false
    if (ARow <> Lastrow) then
    begin

      //
      if (GetCellDisplayText(4, ARow) = '') then
      begin
        _NewCol := cllime
      end
      else
      begin
        if odd(ARow) then
          _NewCol := HTMLColor2TColor($CCFFFF)
        else
          _NewCol := HTMLColor2TColor($AADDDD);
      end;

      Lastrow := ARow;
    end;

    // Text   für diese Zelle
    _CellDisplayText := GetCellDisplayText(ACol, ARow);

    // Fett Unfett bestimmen!
    repeat
      if (ACol = 3) then
        if (GetCellDisplayText(5, ARow) <> '') then
        begin
          canvas.font.Style := [fsunderline];
          break;
        end;
      canvas.font.Style := [];
    until true;

    if gdFocused in State then
    begin
      // alles auf Standard
      canvas.brush.color := color;
      canvas.font.color := VisibleContrast(canvas.brush.color);
      DefaultDrawFocusedCell(ACol, ARow, Rect, State, _CellDisplayText,
        GetCellAlignment(ACol, ARow));
    end
    else
    begin
      canvas.brush.color := _NewCol;
      canvas.font.color := VisibleContrast(canvas.brush.color);
      DefaultDrawCell(ACol, ARow, Rect, State, _CellDisplayText, GetCellAlignment(ACol, ARow));
    end;
  end;
end;

procedure TFormArtikelContext.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Context');
end;

procedure TFormArtikelContext.Button18Click(Sender: TObject);
var
  cARTIKEL: TIB_Cursor;
begin
  BeginHourGlass;
  ItemRIDs.clear;
  cARTIKEL := DataModuleDatenbank.nCursor;
  with cARTIKEL do
  begin
    sql.add('select RID from ARTIKEL where ERSTEINTRAG>''' + long2date(DatePlus(DateGet,
      -3)) + '''');
    ApiFirst;
    while not(eof) do
    begin
      ItemRIDs.add(pointer(FieldByName('RID').AsInteger));
      ApiNext;
    end;
    close;
  end;
  cARTIKEL.free;
  GridRefresh;
  EndHourGlass;
end;

end.

  var CONTEXT: string; CONTEXT_R: Integer; RID: Integer; DebugL: TStringList; cARTIKEL: TIB_Cursor;
INternInfo: TStringList;

cCATALOG_ARTIKEL: TIB_Cursor; NewEntry: TIB_DSQL; StartTime: dword; RecN: Integer; NewOnes: Integer;
AllRIDs: string;

// Auslesen
with IB_Query1 do begin CONTEXT := FieldByName
('BEZEICHNUNG').AsString; CONTEXT_R := FieldByName
('RID').AsInteger; end;

//
if doit
('Migration ' + #13 + CONTEXT + '=' + #13 + 'durchführen?') then begin BeginHourGlass;
Abbruch := false; StartTime := 0; NewOnes := 0; INternInfo := TStringList.create;
DebugL := TStringList.create; cARTIKEL := DataModuleDatenbank.nCursor;
with cARTIKEL do begin sql.add
('select RID,INTERN_INFO from ARTIKEL'); Open; Progressbar1.Max := RecordCount; ApiFirst; while not
(eof) do begin
// Werbe RID auslesen
FieldByName('INTERN_INFO').AssignTo(INternInfo); AllRIDs := INternInfo.values[CONTEXT]; while
(AllRIDs <> '') do begin RID := strtointdef(nextp(AllRIDs, ';'), 0); if
(RID <> 0) then begin

// ist der "Hauptartikel" schon angelegt?
cCATALOG_ARTIKEL := DataModuleDatenbank.nCursor; with cCATALOG_ARTIKEL do begin sql.add
('select count(RID) AM_COUNT from ARTIKEL_MITGLIED where'); sql.add
(' (ARTIKEL_R=' + cARTIKEL.FieldByName('RID').AsString + ') AND'); sql.add
(' (CONTEXT_R=' + inttostr(CONTEXT_R) + ') AND'); sql.add
(' (MASTER_R=' + inttostr(RID) + ')'); ApiFirst; if
(FieldByName('AM_COUNT').AsInteger < 1) then begin NewEntry := DataModuleDatenbank.nDSQL;
with NewEntry do begin sql.add
('insert into ARTIKEL_MITGLIED (RID,ARTIKEL_R,CONTEXT_R,MASTER_R) values'); sql.add
(' (0,' + cARTIKEL.FieldByName('RID').AsString + ',' + inttostr(CONTEXT_R) + ',' + inttostr(RID) +
  ')'); try execute; inc
(NewOnes); except DebugL.add
('#################################'); DebugL.addstrings
(sql); end; end; NewEntry.free; end; end; cCATALOG_ARTIKEL.free; end; end; ApiNext; inc
(RecN); if frequently
(StartTime, 333) or eof then begin if Abbruch then break; Progressbar1.Position := RecN;
application.processmessages; end; end; cARTIKEL.free; end; DebugL.SaveToFile
(DiagnosePath + 'Migration_' + CONTEXT + '.txt'); openShell
(DiagnosePath + 'Migration_' + CONTEXT + '.txt'); INternInfo.free; DebugL.free;
Progressbar1.Position := 0; EndHourGlass; end;
