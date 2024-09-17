{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2012 - 2018  Andreas Filsinger
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
unit Qmain;
//
//
//

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  Grids, ActnList,
  AppEvnts, ToolWin, ActnMan,
  ActnCtrls, ComCtrls, IB_Grid,
  IB_Components, IB_DatasetBar, IB_UpdateBar,
  CheckLst, QAuftrag, IdUDPBase,
  IdUDPClient, WordIndex, IB_Access;

type
  TFormQMain = class(TForm)
    Timer1: TTimer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    TabSheet2: TTabSheet;
    TabSheet4: TTabSheet;
    Edit2: TEdit;
    ListBox1: TListBox;
    Label3: TLabel;
    Label4: TLabel;
    ComboBox2: TComboBox;
    Button10: TButton;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    Label5: TLabel;
    Button11: TButton;
    Button12: TButton;
    CheckListBox1: TCheckListBox;
    Button14: TButton;
    Label6: TLabel;
    Label7: TLabel;
    Button15: TButton;
    Button16: TButton;
    Edit3: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    IB_Query2: TIB_Query;
    IB_Query3: TIB_Query;
    Einstellungen: TButton;
    Backup: TButton;
    Tagesabschluss: TButton;
    Button17: TButton;
    Button7: TButton;
    Button9: TButton;
    Button13: TButton;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    CheckBox1: TCheckBox;
    Image1: TImage;
    Label2: TLabel;
    Image2: TImage;
    Button1: TButton;
    Label8: TLabel;
    CheckListBox2: TCheckListBox;
    Button3: TButton;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    ComboBox3: TComboBox;
    Label14: TLabel;
    Button4: TButton;
    ProgressBar1: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure EinstellungenClick(Sender: TObject);
    procedure BackupClick(Sender: TObject);
    procedure TagesabschlussClick(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure IB_Grid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure IB_Grid1DblClick(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure IB_Grid1DrawFocusedCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Button15Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Image2DblClick(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  private
    { Private-Deklarationen }
    Initialized : boolean;
    procedure CompileStatementAndOpen;
  public
    { Public-Deklarationen }
    UpdateGruppenSelektionNow: boolean;
    GruppeOnceUpdated: boolean;
    Grid1ShouldRefresh: boolean;
    MainSelect: string;
    Admins: TStringList;

    // Für IB-Grid1
    LastRow: integer;
    _NewCol: TColor;
    MainQuery: TIB_Query;
    sAUFTRAG: TList;
    //
    WSearch: TWordIndex;

    procedure UpdateBenutzer(Sender: TObject = nil);
    procedure UpdateGruppenSelektion;
    procedure UpdateAuftrage;
    procedure ShowAuftrag(FormA: TFormQAuftrag);
    procedure NewAuftrag;
    procedure UpdateRecordCountLabel;

  end;

var
  FormQMain: TFormQMain;

implementation

uses
  globals, anfix,
  Funktionen_Auftrag,
  Einstellungen,
  Bearbeiter, Datenbank, splash,
  BaseUpdate, Datensicherung, Tagesabschluss,
  QArbeitsbereich, QProfil,
  QGruppe, math, html,
  IB_Session, wanfix;

{$R *.dfm}

const
  cColGruppe = 8;
  cColVerfall = 9;
  cColOwner = 10;

procedure TFormQMain.FormCreate(Sender: TObject);
begin
  Admins := TStringList.create;
  WSearch := TWordIndex.create(nil, 1);
  MainQuery := IB_Query1;
  MainSelect := HugeSingleLine(MainQuery.SQL, #13);
  LastRow := -1;
  sAUFTRAG := TList.create;
end;

procedure TFormQMain.FormDeactivate(Sender: TObject);
begin
  timer1.enabled := false;
end;

procedure TFormQMain.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TFormQMain.FormActivate(Sender: TObject);

  procedure SetColorOnStaticText(TheText: TStaticText; TheColor: TColor);
  begin
    TheText.color := TheColor;
    TheText.font.color := VisibleContrast(TheColor);
  end;

begin

  //
  //
  //
  if not (Initialized) then
  begin

    Initialized := true;
    label2.Caption := 'auf ' + ComputerName;

    PageControl1.ActivePage := TabSheet1;
    EnsureHints(IB_Query1.hints);
    EnsureHints(IB_Query2.hints);
    EnsureHints(IB_Query3.hints);

    caption := ExtractFileName(iDataBaseName) + ' - OrgaMon Rev ' + RevToStr(Version);

    // Systemparameter ermitteln

    EnsureHints(FormBearbeiter.IB_Query1.Hints);

    // Benutzer Verwaltung aktivieren
//    FormBearbeiter.OnChange := UpdateBenutzer;
//    FormBearbeiter.Start;
    Label14.Visible := FormBearbeiter.WasAdmin;
    Combobox3.Visible := FormBearbeiter.WasAdmin;
    Combobox3.Items.Assign(FormBearbeiter.FetchKuerzel);

    // Benutzer prüfen!
    UpdateGruppenSelektion;
    UpdateAuftrage;

    // diverse Einstellungen wiederspiegeln
    SetColorOnStaticText(StaticText1, iWarnFarbe_L0);
    SetColorOnStaticText(StaticText2, iWarnFarbe_L1);
    SetColorOnStaticText(StaticText3, iWarnFarbe_L2);
    SetColorOnStaticText(StaticText4, iWarnFarbe_L3);
    SetColorOnStaticText(StaticText5, iWarnFarbe_L4);

    //
  end;

  if PageControl1.ActivePage = TabSheet1 then
  begin
    if Grid1ShouldRefresh then
    begin
      Grid1ShouldRefresh := false;
      MainQuery.refresh;
    end;
    IB_Grid1.SetFocus;
  end;
  timer1.enabled := true;
end;

procedure TFormQMain.UpdateBenutzer(Sender: TObject);
var
  IsAdmin: boolean;
  IsGruppenAdmin: boolean;
begin
  IsAdmin := FormBearbeiter.IsAdmin;
  IsGruppenAdmin := FormQGruppe.IsAdmin(FormBearbeiter.sBearbeiter);

  // - * -
  TabSheet2.TabVisible := IsGruppenAdmin;
  TabSheet4.TabVisible := IsAdmin;
  Button15.Visible := IsGruppenAdmin;

  // - * -
  image2.Picture.Bitmap.Assign(FormBearbeiter.FetchBILDFromRID(FormBearbeiter.sBearbeiter));
  ComboBox3.itemindex := Combobox3.Items.indexof(FormBearbeiter.sBearbeiterKurz);

  with FormQAuftrag do
  begin
    button2.Visible := IsGruppenAdmin;
    button3.Visible := IsGruppenAdmin;
    button4.Visible := IsGruppenAdmin;
    button5.Visible := IsGruppenAdmin;
    button6.Visible := IsGruppenAdmin;
    button10.Visible := IsGruppenAdmin;
    combobox1.Visible := IsGruppenAdmin;
    combobox2.Visible := IsGruppenAdmin;
    if IsGruppenAdmin then
      IB_UpdateBar3.visiblebuttons := IB_UpdateBar3.visiblebuttons + [ubDelete]
    else
      IB_UpdateBar3.visiblebuttons := IB_UpdateBar3.visiblebuttons - [ubDelete];
  end;

end;

procedure TFormQMain.Timer1Timer(Sender: TObject);
begin
  if NoTimer then
   exit;
  if iForceAppDown then
   close;
  if GruppeOnceUpdated then
   if UpdateGruppenSelektionNow then
    UpdateGruppenSelektion;
end;

procedure TFormQMain.EinstellungenClick(Sender: TObject);
begin
  FormEinstellungen.show;
end;

procedure TFormQMain.BackupClick(Sender: TObject);
begin
  FormDatensicherung.show;
end;

procedure TFormQMain.TagesabschlussClick(Sender: TObject);
begin
  FormTagesabschluss.show;
end;

procedure TFormQMain.Button7Click(Sender: TObject);
begin
  FormBearbeiter.show;
end;

procedure TFormQMain.Button3Click(Sender: TObject);
var
  TheModuleName: array[0..1023] of char;
begin
  //GetModuleFileName(DataModuleDatenbank.IB_Session1.GDS_Handle, TheModuleName, sizeof(TheModuleName));
  listbox1.items.add(TheModuleName);
  listbox1.items.add(FileVersion(TheModuleName));
end;

procedure TFormQMain.Button9Click(Sender: TObject);
begin
  FormQArbeitsbereich.show;
end;

procedure TFormQMain.Button10Click(Sender: TObject);
begin
  ShowAuftrag(FormQAuftrag);
end;

procedure TFormQMain.Button11Click(Sender: TObject);
begin
//  FormRohstoff.show;
end;

procedure TFormQMain.Button12Click(Sender: TObject);
begin
  FormQProfil.show;
end;

procedure TFormQMain.IB_Grid1DrawFocusedCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  _CellDisplayText: string;
  FurtherDrawing: boolean;
begin
  FurtherDrawing := true;

  IB_Grid1DrawCell(Sender, ACol, ARow, Rect, State);
  with sender as TIB_Grid do
  begin
    _CellDisplayText := GetCellDisplayText(ACol, ARow);
    if (ACol = cColGruppe) then
      _CellDisplayText := FormQGruppe.FetchKuerzelfromRID(strtol(_CellDisplayText));

    if (ACol = cColOwner) then
    begin
//      _CellDisplayText := FormBearbeiter.FetchKurzfromRID(strtol(_CellDisplayText));
      canvas.FillRect(Rect);
      canvas.Draw(Rect.Left, Rect.Top, FormBearbeiter.FetchBILDFromRID(strtol(_CellDisplayText)));
      FurtherDrawing := false;
    end;

    if (ACol = cColOwner + 1) then
      _CellDisplayText := FormBearbeiter.FetchKurzfromRID(strtol(_CellDisplayText));

    if FurtherDrawing then
    begin
      canvas.Font.style := [fsbold];
      canvas.font.color := clwhite;
      canvas.brush.color := clblue;
      DefaultDrawCell(ACol, ARow, Rect, State, _CellDisplayText, GetCellAlignment(ACol, ARow));
      canvas.brush.color := clwhite;
      canvas.font.color := clblack;
      canvas.Font.style := [];
    end;

  end;
end;

procedure TFormQMain.IB_Grid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  _CellDisplayText: string;
  _Diff: integer;
  FurtherDrawing: boolean;
begin
  FurtherDrawing := true;

  // important: set DefDrawBefore to false
  if (ARow <> Lastrow) then
  begin
    // erst mal die Farbe bestimmen!
    _Diff := DateDiff(DateGet, date2long(nextp(IB_grid1.GetCellDisplayText(cColVerfall, ARow), ' ', 0)));
    case _Diff of
      1: _NewCol := iWarnFarbe_L0;
      0: _NewCol := iWarnFarbe_L1;
      -1: _NewCol := iWarnFarbe_L2;
      -2: _NewCol := iWarnFarbe_L3;
    else
      _NewCol := clwhite;
    end;

    if (_Diff < -2) then
      _newCol := iWarnFarbe_L4;

    LastRow := ARow;
  end;

  // Text für diese Zelle
  with sender as TIB_Grid do
  begin
    _CellDisplayText := GetCellDisplayText(ACol, ARow);

    if ACol = cColGruppe then
      _CellDisplayText := FormQGruppe.FetchKuerzelfromRID(strtol(_CellDisplayText));
    if (ACol = cColOwner) then
    begin
//      _CellDisplayText := FormBearbeiter.FetchKurzfromRID(strtol(_CellDisplayText));
      canvas.FillRect(Rect);
      canvas.Draw(Rect.Left, Rect.Top, FormBearbeiter.FetchBILDFromRID(strtol(_CellDisplayText)));
      FurtherDrawing := false;
    end;

    if (ACol = cColOwner + 1) then
      _CellDisplayText := FormBearbeiter.FetchKurzfromRID(strtol(_CellDisplayText));

    if FurtherDrawing then
    begin
      if gdFocused in State then
      begin
      // alles auf Standard
        canvas.brush.color := canvas.Brush.color;
        canvas.font.color := canvas.Font.Color;
        DefaultDrawFocusedCell(ACol, ARow, Rect, State, _CellDisplayText, GetCellAlignment(ACol, ARow));
      end else
      begin
        canvas.brush.color := _newCol;
        canvas.font.color := VisibleContrast(canvas.brush.color);
        DefaultDrawCell(ACol, ARow, Rect, State, _CellDisplayText, GetCellAlignment(ACol, ARow));
      end;
    end;
  end;
end;

procedure TFormQMain.IB_Grid1DblClick(Sender: TObject);
begin
  button10click(Sender);
end;

procedure TFormQMain.Button13Click(Sender: TObject);
begin
  FormQGruppe.show;
end;

procedure TFormQMain.Button14Click(Sender: TObject);
begin
  CompileStateMentAndOpen;
end;

procedure TFormQMain.UpdateGruppenSelektion;
begin
  // verhindern dass zu oft upgedatet wird
  UpdateGruppenSelektionNow := false;

  // Gruppen selektionen anzeigen
  CheckListBox1.Items.assign(FormQGruppe.FetchKuerzel);
  CheckListBox1.Items.insert(0, '"Meine"');
  CheckListBox1.Items.insert(1, '"Alle"');
  CheckListBox1.Items.insert(2, '"ohne Eintrag"');

  // Owner selektion anzeigen
  CheckListBox2.Items.assign(FormBearbeiter.FetchKuerzel);
  CheckListBox2.Items.insert(0, '"Ich (' + FormBearbeiter.sBearbeiterKurz + ')"');
  CheckListBox2.Items.insert(1, '"Alle"');
  CheckListBox2.Items.insert(2, '"ohne Eintrag"');

  // Erstes Mal jetzt OK
  GruppeOnceUpdated := true;
end;

procedure TFormQMain.UpdateAuftrage;
begin
  Button14Click(self);
end;


procedure TFormQMain.ShowAuftrag;
begin
  if not (MainQuery.IsEmpty) then
  begin
    FormA.show;
    FormA.IB_Query1.Locate('RID', MainQuery.FieldByName('QAUFTRAG.RID').AsInteger, []);
    application.ProcessMessages;
    FormA.IB_Query2.Locate('RID', MainQuery.FieldByName('QPOSTEN.RID').AsInteger, []);
    FormA.IB_Grid2.SetFocus;
  end;
end;

procedure TFormQMain.Button15Click(Sender: TObject);
begin
  NewAuftrag;
end;

procedure TFormQMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssCtrl in Shift then
  begin
    case key of
      VK_insert: begin
          NewAuftrag;
          key := 0;
        end;
    end;
  end;
end;

procedure TFormQMain.NewAuftrag;
begin
  FormQAuftrag.show;
  FormQAuftrag.NewAuftrag;
end;

procedure TFormQMain.CheckListBox1ClickCheck(Sender: TObject);
var
  n: integer;
begin

 // eigene
  if CheckListBox1.Checked[0] then
  begin
    CheckListBox1.Checked[0] := false;
  // ermitteln, welchen Gruppen man angehört!
    for n := 3 to pred(CheckListBox1.Count) do
      CheckListbox1.Checked[n] := FormQGruppe.IsMember(FormBearbeiter.sBEARBEITER, integer(CheckListbox1.Items.Objects[n]));
  //
  end;

  // Alle
  if CheckListBox1.Checked[1] then
  begin
    CheckListBox1.Checked[0] := false;
    CheckListBox1.Checked[2] := true;
    for n := 3 to pred(CheckListBox1.items.Count) do
      CheckListbox1.Checked[n] := true;
  end;

end;

procedure WakeOnLan(MAC: string); // sample: WakeOnLan('00-07-95-1C-64-7E');

//
// This sample uses Indy-Components, you should include
// the following two units in your uses clause
//
// uses
//  IdUDPBase, IdUDPClient;
//

  function NextP(var s: string; Delimiter: string): string;
  var
    k: integer;
  begin
    k := pos(Delimiter, s);
    if k > 0 then
    begin
      result := copy(s, 1, pred(k));
      delete(s, 1, pred(k + length(delimiter)));
    end else
    begin
      result := s;
      s := '';
    end;
  end;

var
  OutStr: string;
  OneLine: string;
  n: integer;
  BroadCaster: TIdUDPClient;
begin
  // assemble one MAC-Line
  OneLine := '';
  for n := 0 to pred(6) do
    OneLine := OneLine + chr(strtoint('$' + nextp(MAC, '-')));

  // assemble magic Paket
  OutStr := '';
  for n := 0 to pred(16) do
    OutStr := OutStr + OneLine;
  BroadCaster := TIdUDPClient.Create(nil);

  // broadcast magic Paket
  BroadCaster.broadcast(fill(#$FF, 6) + OutStr, 9);
  BroadCaster.free;
end;

procedure TFormQMain.Button16Click(Sender: TObject);
begin
  WakeOnLan(edit3.Text);
end;

procedure TFormQMain.UpdateRecordCountLabel;
begin
  label7.caption := format('b) Selektierte Positionen (%d aus %d Aufträgen)', [MainQuery.RecordCount, sAUFTRAG.count]);
end;

procedure TFormQMain.Button17Click(Sender: TObject);
var
  BigStr: string;
  Mother: TStringList;
begin
  BeginHourGlass;
  Mother := TStringList.Create;
  with IB_Query2 do
  begin
    Open;
    while not (eof) do
    begin
      BigStr := '';
      with IB_Query3 do
      begin
        ParamByName('CROSSREF').assign(IB_Query2.FieldByName('RID'));
        if not (Active) then
          Open;
        while not (Eof) do
        begin
          BigStr := BigStr + FieldByName('NAME').AsString + ' ';
          next;
        end;
      end;
      // jetzt einfügen

      BigStr := BigStr +
        FieldByName('BU_NO').AsString + ' ' +
        FieldByName('BANF').AsString + ' ' +
        FieldByName('BEST_NO').AsString + ' ' +
        FieldByName('INNEN_A_NO').AsString + ' ' +
        FieldByName('SACHKONTO').AsString + ' ' +
        FieldByName('INVENTAR_NO').AsString + ' ' +
        FieldByName('RAHMEN_BEST_NO').AsString + ' ' +
        FieldByName('PM_AUFTRAG_NO').AsString + ' ' +
        FieldByName('KUNDE').AsString + ' ' +
        FieldByName('KUNDE2').AsString + ' ' +
        FieldByName('KUNDE3').AsString + ' ' +
        FieldByName('LIEFERANT').AsString + ' ' +
        FieldByName('CODE_BACK_OFFICE').AsString + ' ' +
        FieldByName('CODE_FRONT_OFFICE').AsString;

      mother.AddObject(BigStr, TObject(FieldByNAme('RID').AsInteger));
      next;
    end;
    close;
    IB_Query3.Close;
  end;
  WSearch.free;
  WSearch := TWordIndex.create(Mother, 1);
  CheckCreateDir(SearchDir);
  WSearch.SaveToFile(SearchDir + cQAuftragsIndexFName);
  Mother.Free;
  EndHourGlass;
end;

procedure TFormQMain.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    BeginHourGlass;
    Key := #0;
    if FileExists(SearchDir + cQAuftragsIndexFName) then
    begin
      WSearch.ReloadIfNew;
    end else
    begin
      Button17Click(Sender);
    end;
    WSearch.Search(edit1.text);
    Button14Click(Sender);
    EndHourGlass;
  end;
end;

procedure TFormQMain.Image2DblClick(Sender: TObject);
begin
  FormBearbeiter.ShowPrivatProperties(formbearbeiter.sBEARBEITER);
end;

procedure TFormQMain.ComboBox3Change(Sender: TObject);
begin
  FormBearbeiter.switch(Combobox3.items[Combobox3.itemindex]);
  CompileStatementAndOpen;
  IB_Grid1.SetFocus;
end;

procedure TFormQMain.CompileStatementAndOpen;
var
  n, m: integer;
  sList: string;
  OneStr: string;
  GRUPPE_RID: integer;
  BEARBEITER_RID: integer;
  Gruppen: TList;
  NextSQLPattern: string;
  AUFTRAG_RIDS: TIB_Cursor;
  RIDs: string;

  procedure sqlADD(s: string);
  begin
    MainQuery.SQL.add(s);
    AUFTRAG_RIDS.SQL.add(s);
  end;

begin
  AUFTRAG_RIDS := DataModuleDatenbank.nCursor;
  AUFTRAG_RIDS.sql.add('SELECT DISTINCT QAUFTRAG_R FROM QPOSTEN');

  //
  if MainQuery.Active then
    MainQuery.Close;

  NextSQLPattern := 'WHERE';
  MainQuery.SQL.clear;
  OneStr := MainSelect;
  while (OneStr <> '') do
    MainQuery.SQL.add(nextp(OneStr, #13));

    // Einschränkung auf eigene Gruppen
    //
    // Optimierungs-Möglichkeit: Die beiden Fäden (eigene Gruppen) und
    //  (selektierte Gruppen) müssten vor dem Zusammenbau der Anfrage
    //  "ge-anded" werden.
    //
  Gruppen := TList.create;
  FormQGruppe.MemberShips(FormBearbeiter.sBearbeiter, Gruppen);
  if (Gruppen.count > 0) then
  begin
    sqlADD(NextSQLPattern);
    if Gruppen.count = 1 then
    begin
      // single Group
      sqlADD(' (QPOSTEN.GRUPPE_R=' + inttostr(integer(Gruppen[0])) + ')');
    end else
    begin
      // Multi Group
      sList := '';
      for n := 0 to pred(Gruppen.count) do
      begin
        sList := sList + inttostr(integer(Gruppen[n]));
        if n < pred(Gruppen.count) then
          sList := sList + ',';
      end;
      sqlADD(' (QPOSTEN.GRUPPE_R IN (' + sList + '))');
    end;
    NextSQLPattern := 'AND';
  end;
  Gruppen.free;

    // GRUPPE
  for m := 2 to pred(CheckListBox1.Items.Count) do
    if CheckListBox1.checked[m] then
    begin
      sqlADD(NextSQLPattern);
      NextSQLPattern := '';
      sqlADD('(');
      for n := 2 to pred(CheckListBox1.Items.Count) do
      begin
        if CheckListBox1.checked[n] then
        begin
          sqlADD(NextSQLPattern);
          GRUPPE_RID := FormQGruppe.FetchRIDfromKuerzel(CheckListbox1.Items[n]);
          if GRUPPE_RID = -1 then
            sqlADD(' (QPOSTEN.GRUPPE_R IS NULL)')
          else
            sqlADD(' (QPOSTEN.GRUPPE_R=' + inttostr(GRUPPE_RID) + ')');
          NextSQLPattern := 'OR';
        end;
      end;
      sqlADD(')');
      NextSQLPattern := 'AND';
      break;
    end;


    // OWNER a
  if CheckListBox2.checked[0] then
  begin

    sqlADD(NextSQLPattern);
    sqlADD(' (QPOSTEN.OWNER_R=' + inttostr(FormBearbeiter.sBearbeiter) + ')');
    NextSQLPattern := 'AND';
  end;

    // OWNER b
  for m := 2 to pred(CheckListBox2.Items.count) do
  begin
    if CheckListBox2.checked[m] then
    begin
      sqlADD(NextSQLPattern);
      NextSQLPattern := '';
      sqlADD('(');
      for n := 2 to pred(CheckListBox2.Items.count) do
      begin
        if CheckListBox2.checked[n] then
        begin
          sqlADD(NextSQLPattern);

          BEARBEITER_RID := FormBearbeiter.FetchRIDfromKurz(CheckListbox2.Items[n]);
          if BEARBEITER_RID = -1 then
            sqlADD(' (QPOSTEN.OWNER_R IS NULL)')
          else
            sqlADD(' (QPOSTEN.OWNER_R=' + inttostr(BEARBEITER_RID) + ')');
          NextSQLPattern := 'OR';
        end;
      end;
      sqlADD(')');
      NextSQLPattern := 'AND';
      break;
    end;
  end;

    // DATUM
  if (ComboBox2.ItemIndex <> -1) and (ComboBox2.ItemIndex <> 0) then
  begin
    sqlADD(NextSQLPattern);
    case ComboBox2.ItemIndex of
      1: sqlADD(' (QPOSTEN.VERFALL > ''' + long2date(DatePlus(DateGet, +1)) + ''')');
      2: sqlADD(' (QPOSTEN.VERFALL = ''' + long2date(DatePlus(DateGet, +1)) + ''')');
      3: sqlADD(' (QPOSTEN.VERFALL = ''' + long2date(DatePlus(DateGet, 0)) + ''')');
      4: sqlADD(' (QPOSTEN.VERFALL = ''' + long2date(DatePlus(DateGet, -1)) + ''')');
      5: sqlADD(' (QPOSTEN.VERFALL < ''' + long2date(DatePlus(DateGet, -1)) + ''')');
    end;
    NextSQLPattern := 'AND';
  end;


  if WSearch.FoundList.count > 0 then
  begin
    sqlADD(NextSQLPattern);

    sqlADD(' (');
    for n := 0 to min(pred(WSearch.FoundList.Count), 5) do
    begin
      if (n > 0) then
        sqlADD('  OR (QAUFTRAG.RID=' + inttostr(integer(WSearch.FoundList[n])) + ')')
      else
        sqlADD('     (QAUFTRAG.RID=' + inttostr(integer(WSearch.FoundList[n])) + ')');
    end;
    sqlADD(' )');
    NextSQLPattern := 'AND';

  end;

  if checkBox1.Checked then
    ShowMessage(HugeSingleLine(MainQuery.SQL));

  sAUFTRAG.clear;
  with AUFTRAG_RIDS do
  begin
    Open;
    apifirst;
    while not (eof) do
    begin
      sAUFTRAG.add(pointer(FieldByName('AUFTRAG_R').AsInteger));
      apinext;
    end;
    close;
  end;
  AUFTRAG_RIDS.free;

  with FormQAuftrag.IB_Query1 do
  begin
    SQL.clear;
    SQL.add('select * from Qauftrag where rid in (');
    for n := 0 to pred(sAUFTRAG.count) do
      if n = 0 then
        RIDs := inttostr(integer(sAUFTRAG[n]))
      else
        RIDs := RIDs + ', ' + inttostr(integer(sAUFTRAG[n]));
    SQL.add(RIDs);
    SQL.add(')');
  end;

  MainQuery.Open;
  UpdateRecordCountLabel;
end;

procedure TFormQMain.Button4Click(Sender: TObject);
var
  AUFTRAG: TIB_Cursor;
  StartTime: dword;
  RecN: integer;
begin
  BeginHourGlass;
  StartTime := 0;
  RecN := 0;
  AUFTRAG := DataModuleDatenbank.nCursor;
  with AUFTRAG do
  begin
    sql.Add('select rid from qauftrag');
    open;
    progressbar1.Max := RecordCount;

    apifirst;
    while not (eof) do
    begin
      inc(RecN);
      e_w_QAuftragEnsure(FieldByName('RID').AsINteger);
      apinext;
      if frequently(StartTime, 333) or eof then
      begin
        progressbar1.Position := RecN;
        application.processmessages;
      end;
    end;
    progressbar1.Position := 0;
    close;
  end;
  AUFTRAG.Free;
  EndHourGlass;
end;

end.

