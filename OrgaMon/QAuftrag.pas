unit QAuftrag;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  IB_UpdateBar, IB_NavigationBar,
  Grids, IB_Grid, IB_Components, IB_Access,
  ExtCtrls, StdCtrls, Mask,
  IB_Controls, Buttons, ComCtrls, IB_EditButton;

type
  TFormQAuftrag = class(TForm)
    Panel1: TPanel;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    Panel2: TPanel;
    Panel3: TPanel;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_NavigationBar2: TIB_NavigationBar;
    IB_NavigationBar3: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_UpdateBar2: TIB_UpdateBar;
    IB_UpdateBar3: TIB_UpdateBar;
    Label6: TLabel;
    Label8: TLabel;
    Label7: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    IB_Grid1: TIB_Grid;
    IB_Memo1: TIB_Memo;
    IB_Query2: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    IB_Query3: TIB_Query;
    IB_DataSource3: TIB_DataSource;
    IB_Query4: TIB_Query;
    IB_Query5: TIB_Query;
    IB_Query6: TIB_Query;
    IB_Grid2: TIB_Grid;
    IB_Memo2: TIB_Memo;
    Button9: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label4: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    IB_Edit1: TIB_Edit;
    IB_Edit2: TIB_Edit;
    IB_Edit3: TIB_Edit;
    Label12: TLabel;
    IB_Edit6: TIB_Edit;
    Label11: TLabel;
    Label14: TLabel;
    IB_Edit4: TIB_Edit;
    IB_Edit5: TIB_Edit;
    Label18: TLabel;
    IB_Edit7: TIB_Edit;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label13: TLabel;
    IB_Memo3: TIB_Memo;
    IB_Edit8: TIB_Edit;
    IB_Edit9: TIB_Edit;
    IB_Edit10: TIB_Edit;
    IB_Edit11: TIB_Edit;
    IB_Edit12: TIB_Edit;
    IB_Edit13: TIB_Edit;
    IB_Edit14: TIB_Edit;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Button10: TButton;
    Splitter1: TSplitter;
    TabSheet4: TTabSheet;
    Label1: TLabel;
    IB_Text2: TIB_Text;
    Label16: TLabel;
    IB_Text3: TIB_Text;
    IB_Text4: TIB_Text;
    Label26: TLabel;
    SpeedButton1: TSpeedButton;
    IB_Text1: TIB_Text;
    Label5: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label27: TLabel;
    Label29: TLabel;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    IB_Date2: TIB_Date;
    Label2: TLabel;
    IB_Date1: TIB_Date;
    Label3: TLabel;
    IB_Text5: TIB_Text;
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure IB_Query2AfterScroll(IB_Dataset: TIB_Dataset);
    procedure IB_Query3BeforeInsert(IB_Dataset: TIB_Dataset);
    procedure FormActivate(Sender: TObject);
    procedure IB_Query1BeforeInsert(IB_Dataset: TIB_Dataset);
    procedure IB_Query2BeforeInsert(IB_Dataset: TIB_Dataset);
    procedure IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
    procedure IB_Query3BeforePost(IB_Dataset: TIB_Dataset);
    procedure ComboBox1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure IB_Grid2DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure IB_Grid2DrawFocusedCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDeactivate(Sender: TObject);
    procedure IB_Grid2CellDblClick(Sender: TObject; ACol, ARow: Integer;
      AButton: TMouseButton; AShift: TShiftState);
    procedure Button9Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure Splitter1CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure IB_Grid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure IB_Grid1DrawFocusedCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
    procedure IB_Query3AfterPost(IB_Dataset: TIB_Dataset);
    procedure IB_Query2AfterPost(IB_Dataset: TIB_Dataset);
    procedure IB_Grid2DblClick(Sender: TObject);
  private
    LastRow: integer;
    _NewCol: TColor;
    SupressRecalc: boolean;
    { Private-Deklarationen }

    procedure ReCalcPosten;
    procedure ReCalcAuftrag;
    procedure UpdateMainCaption;

  public

    { Public-Deklarationen }
    procedure NewPosten;
    procedure NewMeilenStein;
    procedure NewAuftrag;
    procedure ToggleAbschlussDatum;
    procedure DeletePosNr;

  end;

var
  FormQAuftrag: TFormQAuftrag;

implementation

uses
  anfix32, Math, QGruppe,
  main, DateUtils, globals,
  Bearbeiter, Qmain, Datenbank,
  wanfix32, Funktionen_Auftrag;

{$R *.dfm}

const
  cColGruppe = 6;
  cColVerfall = 7;
  cColOwner = 8;

procedure TFormQAuftrag.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  IB_Query2.ParamByName('CROSSREF').AsInteger := IB_DataSet.FieldByName('RID').AsInteger;
  UpdateMainCaption;
end;

procedure TFormQAuftrag.IB_Query2AfterScroll(IB_Dataset: TIB_Dataset);
begin
  IB_Query3.ParamByName('CROSSREF').AsInteger := IB_DataSet.FieldByName('RID').AsInteger;
end;

procedure TFormQAuftrag.IB_Query3BeforeInsert(IB_Dataset: TIB_Dataset);
begin
  if IB_DataSet.FieldByName('POSTEN_R').IsNull then
    IB_DataSet.FieldByName('POSTEN_R').AsInteger := IB_Query2.FieldByName('RID').AsInteger;
end;

procedure TFormQAuftrag.FormActivate(Sender: TObject);
begin

  if not (IB_query1.Active) then
    IB_Query1.Open;

  if not (IB_query2.Active) then
    IB_Query2.Open;

  if not (IB_query3.Active) then
    IB_Query3.Open;

  if not (IB_query4.Active) then
    IB_query4.Open
  else
  begin
    IB_query4.refresh;
    IB_query4.first;
  end;

  ComBoBox1.ItemIndex := -1;
  ComBoBox1.Items.clear;
  ComboBox1.Items.add('-- ohne --');
  while not (IB_query4.eof) do
  begin
    ComboBox1.Items.Add(IB_Query4.FieldByName('NAME').AsString);
    IB_Query4.Next;
  end;

  comboBox2.Items.Assign(FormQGruppe.FetchKuerzel);

end;

procedure TFormQAuftrag.IB_Query1BeforeInsert(IB_Dataset: TIB_Dataset);
begin
  if IB_DataSet.FieldByName('RID').IsNull then
    IB_DataSet.FieldByName('RID').AsInteger := 0;
end;

procedure TFormQAuftrag.IB_Query2BeforeInsert(IB_Dataset: TIB_Dataset);
begin
  if IB_DataSet.FieldByName('AUFTRAG_R').IsNull then
    IB_DataSet.FieldByName('AUFTRAG_R').AsInteger := IB_Query1.FieldByName('RID').AsInteger;
end;

procedure TFormQAuftrag.IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
begin
  if IB_DataSet.FieldByName('AUFTRAG_R').IsNull then
    IB_DataSet.FieldByName('AUFTRAG_R').AsInteger := IB_Query1.FieldByName('RID').AsInteger;
end;

procedure TFormQAuftrag.IB_Query3BeforePost(IB_Dataset: TIB_Dataset);
begin
  if not (
    (FormQGruppe.IsMember(FormBearbeiter.sBearbeiter, IB_DataSet.FieldByName('GRUPPE_R').AsInteger))
    or
    (FormQGruppe.IsAdmin(FormBearbeiter.sBearbeiter, IB_DataSet.FieldByName('GRUPPE_R').AsInteger))

    ) then
  begin
    IB_DataSet.Cancel;
  end else
  begin
    if IB_DataSet.FieldByName('POSTEN_R').IsNull then
      IB_DataSet.FieldByName('POSTEN_R').AsInteger := IB_Query2.FieldByName('RID').AsInteger;
    if IB_DataSet.FieldByName('ABSCHLUSS').IsModified then
      IB_DataSet.FieldByName('BEARBEITER_R').AsInteger := FormBearbeiter.sBearbeiter;
  end;
end;

procedure TFormQAuftrag.ComboBox1Click(Sender: TObject);
begin
  if IB_Query4.Locate('NAME', ComboBox1.Items[ComboBox1.ItemIndex], []) then
  begin
    BeginHourGlass;
    SupressRecalc := true;
    // Header einfügen!
    IB_Query2.Insert;
    IB_Query2.FieldByName('NAME').AsString := IB_Query4.FieldByName('NAME').AsString;
    IB_Query2.FieldByName('DAUER').AsInteger := IB_Query4.FieldByName('DAUER').AsInteger;
    IB_Query2.FieldByName('INFO').Assign(IB_Query4.FieldByName('INFO'));
    IB_Query2.Post;
    IB_Query2.Locate('RID', IB_Query2.Gen_ID('GEN_POSTEN', 0), []);

    // einzelne Posten einfügen
    IB_Query3.DisableControls;
    IB_Query5.ParamByName('CROSSREF').AsInteger := IB_Query4.FieldByNAme('RID').AsINteger;
    IB_Query5.Open;
    while not (IB_Query5.eof) do
    begin
      // copy it!
      IB_Query3.Insert;
      IB_Query3.FieldByName('POSNR').AsString := IB_Query5.FieldByName('POSNR').AsString;
      IB_Query3.FieldByName('NAME').AsString := IB_Query5.FieldByName('NAME').AsString;
      IB_Query3.FieldByName('DAUER').AsInteger := IB_Query5.FieldByName('DAUER').AsInteger;
      IB_Query3.FieldByName('INFO').assign(IB_Query5.FieldByName('INFO'));
      IB_Query3.FieldByName('GRUPPE_R').assign(IB_Query5.FieldByName('GRUPPE_R'));
      IB_Query3.post;

      IB_Query5.next;
    end;
    IB_Query5.Close;
    IB_Query3.EnableControls;
    SupressRecalc := false;
    RecalcAuftrag;
    EndHourGlass;
  end;
end;

procedure TFormQAuftrag.Button2Click(Sender: TObject);
begin
  NewAuftrag;
end;

procedure TFormQAuftrag.Button3Click(Sender: TObject);
begin
  NewPosten;
end;

procedure TFormQAuftrag.Button4Click(Sender: TObject);
begin
  NewMeilenStein;
end;

procedure TFormQAuftrag.FormCreate(Sender: TObject);
begin
  top := 0;
  left := 0;
  PageControl1.ActivePage := TabSheet1;
  EnsureHints(IB_Query1.hints);
  EnsureHints(IB_Query2.hints);
  EnsureHints(IB_Query3.hints);
  LastRow := -1;
end;

procedure TFormQAuftrag.Button5Click(Sender: TObject);
begin
  if not (IB_query2.Eof) then
  begin
    if doit('PosNr ' + IB_Query2.FieldByName('POSNR').AsString + ' wirklich löschen') then
    begin
      DeletePosNr;
    end;
  end;
end;

procedure TFormQAuftrag.Button6Click(Sender: TObject);
var
  GRUPPE_R: integer;
begin
  GRUPPE_R := FormQGruppe.FetchRIDfromKuerzel(ComboBox2.items[ComboBox2.itemIndex]);
  if (GRUPPE_R <> -1) then
    with IB_Query3 do
    begin
      if not (eof) then
      begin
        if (State <> dssedit) and (State <> dssinsert) then
          edit;
        FieldByName('GRUPPE_R').AsInteger := GRUPPE_R;
        post;
        next;
      end;
    end;
end;

procedure TFormQAuftrag.IB_Grid2DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  _CellDisplayText: string;
  FurtherPainting: boolean;
begin
  with sender as TIB_Grid do
  begin
  // important: set DefDrawBefore to false
    _CellDisplayText := GetCellDisplayText(ACol, ARow);
    FurtherPainting := true;
    if (_CellDisplayText <> '') then
      case ACol of
        4: begin
            _CellDisplayText := FormQGruppe.FetchKuerzelFromRID(strtol(_CellDisplayText));
          end;
        7: begin
            canvas.FillRect(Rect);
            canvas.Draw(Rect.Left, Rect.Top, FormBearbeiter.FetchBILDFromRID(strtol(_CellDisplayText)));
            FurtherPainting := false;
          end;
      end;
    if FurtherPainting then
      DefaultDrawCell(ACol, ARow, Rect, State, _CellDisplayText, GetCellAlignment(ACol, ARow));
  end;
end;

// with sender as TIB_Grid do
//  DefaultDrawFocusedCell(ACol, ARow, Rect, State, GetCellDisplayText(ACol, ARow), GetCellAlignment(ACol, ARow));

procedure TFormQAuftrag.IB_Grid2DrawFocusedCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  _CellDisplayText: string;
  FurtherPainting: boolean;
begin
  with sender as TIB_Grid do
  begin
  // important: set DefDrawBefore to false
    _CellDisplayText := GetCellDisplayText(ACol, ARow);
    FurtherPainting := true;
    if _CellDisplayText <> '' then
      case ACol of
        4: begin
            _CellDisplayText := FormQGruppe.FetchKuerzelFromRID(strtol(_CellDisplayText));
          end;
        7: begin
            canvas.FillRect(Rect);
            canvas.Draw(Rect.Left, Rect.Top, FormBearbeiter.FetchBILDFromRID(strtol(_CellDisplayText)));
            FurtherPainting := false;
          end;
      end;
    if FurtherPainting then
    begin
      canvas.font.style := [fsbold];
      canvas.font.color := clwhite;
      canvas.brush.color := clblue;
      DefaultDrawCell(ACol, ARow, Rect, State, _CellDisplayText, GetCellAlignment(ACol, ARow));
      canvas.brush.color := clwhite;
      canvas.font.color := clblack;
      canvas.font.style := [];
    end;
  end;
end;

procedure TFormQAuftrag.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssCtrl in Shift then
  begin
    case key of
      VK_insert: begin
          if IB_Grid1.Focused then
            NewPosten;
          if IB_Grid2.Focused then
            NewMeilenStein;
          key := 0;
        end;
    end;
  end;
end;

procedure TFormQAuftrag.NewPosten;
var
  p: TGridCoord;
begin
  with IB_Query2 do
  begin
    disablecontrols;
    insert;
    if IB_Query1.FieldByName('OWNER_R').IsNotNull then
      FieldByName('OWNER_R').AsInteger := IB_Query1.FieldByName('OWNER_R').AsInteger;
{
    else
     FieldByName('OWNER_R').AsInteger := sBearbeiter;
}
    post;
    locate('RID', GEN_ID('GEN_POSTEN', 0), []);
    ib_grid1.col := 1;
    enablecontrols;
//  ib_grid1.SelectedField := ib_grid1.r
  end;
end;

procedure TFormQAuftrag.NewMeilenStein;
begin
  with IB_Query3 do
  begin
    disablecontrols;
    insert;
    post;
    locate('RID', GEN_ID('GEN_MEILENSTEIN', 0), []);
    ib_grid2.col := 1;
    enablecontrols;
  end;
end;

procedure TFormQAuftrag.NewAuftrag;
begin
  with IB_Query1 do
  begin
    disablecontrols;
    insert;
    FieldByName('EINGANG').AsDateTime := Today;
    FieldByName('OWNER_R').AsInteger := FormBearbeiter.sBearbeiter;
    post;
    locate('RID', GEN_ID('GEN_AUFTRAG', 0), []);
    enablecontrols;
  end;
  PageControl1.ActivePage := TabSheet1;
  IB_edit1.SetFocus;
  IB_Query1.Edit;
end;

procedure TFormQAuftrag.FormDeactivate(Sender: TObject);
begin
  RecalcAuftrag;
  FormQMain.Grid1ShouldRefresh := true;
end;

procedure TFormQAuftrag.IB_Grid2CellDblClick(Sender: TObject; ACol,
  ARow: Integer; AButton: TMouseButton; AShift: TShiftState);
begin
  if (ACol = 6) then
    ToggleAbschlussDatum;
end;

procedure TFormQAuftrag.ToggleAbschlussDatum;
begin
  with IB_query3 do
  begin
    if not (eof) then
    begin
      if FieldByName('ABSCHLUSS').IsNull then
        FieldByName('ABSCHLUSS').AsDateTime := today
      else
        FieldByName('ABSCHLUSS').clear;
    end;
    IB_Grid2.Setfocus;
  end;
end;

procedure TFormQAuftrag.Button9Click(Sender: TObject);
var
  c: TGridCoord;
begin
  // neu berechnen erzwingen
  ReCalcAuftrag;

  // auf den dringendsten Datensatz springen
  IB_Query2.locate('RID', HANDLUNGSBEDARF_POSTEN_RID, []);
  IB_Query3.locate('RID', HANDLUNGSBEDARF_MEILENSTEIN_RID, []);
  IB_Grid2.SetFocus;
  IB_Grid2.Col := 6;
end;

procedure TFormQAuftrag.SpeedButton1Click(Sender: TObject);
var
  PathName: string;
begin
  PathName := iAuftragsObjektPath + '\' + inttostrN(IB_Query1.FieldByName('RID').AsInteger, 6);
  CheckCreateDir(PathName);
  openShell(PathName);
end;

procedure TFormQAuftrag.Button10Click(Sender: TObject);
begin
  if doit('Auftrag #' + IB_Query1.FieldByName('RID').AsString + #13 +
    'wirklich löschen') then
  begin
    repeat
      IB_Query2.First;
      if IB_query2.Eof then
        break;
      while not (IB_Query2.eof) do
      begin
        DeletePosNr;
        IB_Query2.Next;
      end;
    until false;

    //
    IB_Query1.Delete;
    close;
  end;
end;

procedure TFormQAuftrag.DeletePosNr;
begin
  with IB_Query3 do
  begin
    if (RecordCount > 0) then
      repeat
        first;
        if eof then
          break;
        delete;
      until false;
  end;
  with IB_Query2 do
    delete;
end;

procedure TFormQAuftrag.Splitter1Moved(Sender: TObject);
begin
  ib_grid1.width := splitter1.Width - 2;
  ib_memo1.left := splitter1.Width + 2;
end;

procedure TFormQAuftrag.Splitter1CanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
  Accept := true;
end;

procedure TFormQAuftrag.ReCalcAuftrag;
begin
  if not (SupressRecalc) then
  begin
    BeginHourGlass;
    e_w_QAuftragEnsure(IB_Query1.FieldByName('RID').AsInteger);
    IB_Query1.Refresh;
    IB_Query2.Refresh;
    IB_Query3.Refresh;
    EndHourGlass;
  end;
end;

procedure TFormQAuftrag.ReCalcPosten;
var
  Summe: integer;
begin
  with IB_query6 do
  begin
    ParamByName('CROSSREF').AsInteger := IB_Query2.FieldByName('RID').AsInteger;
    Open;
    Summe := FieldByName('D_SUMME').AsInteger;
    if (Summe <> IB_Query2.FieldByName('DAUER').AsInteger) then
    begin
      IB_Query2.edit;
      IB_Query2.FieldByName('DAUER').AsInteger := Summe;
      IB_Query2.post;
    end;
    Close;
  end;
end;

procedure TFormQAuftrag.IB_Grid1DrawFocusedCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  _CellDisplayText: string;
begin
  IB_Grid1DrawCell(Sender, ACol, ARow, Rect, State);
  with sender as TIB_Grid do
  begin
    _CellDisplayText := GetCellDisplayText(ACol, ARow);
    if (ACol = cColGruppe) then
      _CellDisplayText := FormQGruppe.FetchKuerzelfromRID(strtol(_CellDisplayText));
    if (ACol = cColOwner) then
      _CellDisplayText := FormBearbeiter.FetchKurzfromRID(strtol(_CellDisplayText));

    canvas.Font.style := [fsbold];
    canvas.font.color := clwhite;
    canvas.brush.color := clblue;
    DefaultDrawCell(ACol, ARow, Rect, State, _CellDisplayText, GetCellAlignment(ACol, ARow));
    canvas.brush.color := clwhite;
    canvas.font.color := clblack;
    canvas.Font.style := [];
  end;
end;

procedure TFormQAuftrag.IB_Grid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  _CellDisplayText: string;
  _RedBright: byte;
  _Diff: integer;
  Zusage: TANFiXDate;
  ZusageAge: integer;
begin

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
      _CellDisplayText := FormBearbeiter.FetchKurzfromRID(strtol(_CellDisplayText));

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

procedure TFormQAuftrag.UpdateMainCaption;
var
  BEGINN: TANFIXDATE;
  WUNSCHTERMIN: TANFIXDATE;
  ABSCHLUSS: TANFIXDATE;
  VERFALL: TANFIXDATE;
begin
  with IB_Query1 do
  begin
    // Titel oben
    caption := '  ' +
      FieldByName('RID').AsString + ' ' +
      FieldByName('KUNDE').AsString + ' ' +
      FieldByName('KUNDE2').AsString;

    // Lieferzeit lauf Wunsch
    BEGINN := 0;
    WUNSCHTERMIN := 0;
    if FieldByName('BEGINN').IsNotNull then
      BEGINN := datetime2long(FieldByName('BEGINN').AsDate);
    if FieldByName('ABSCHLUSS_WUNSCH').IsNotNull then
      WUNSCHTERMIN := datetime2long(FieldByNAme('ABSCHLUSS_WUNSCH').AsDate);
    if DateOK(BEGINN) and DateOK(WUNSCHTERMIN) then
      StaticText2.Caption := inttostr(DateDiff(BEGINN,WUNSCHTERMIN))
    else
      StaticText2.Caption := '';

    // Lieferzeit tatsächlich
    if FieldByName('ABSCHLUSS').IsNotNull then
      ABSCHLUSS := datetime2long(FieldByNAme('ABSCHLUSS').AsDate);
    if DateOK(BEGINN) and DateOK(ABSCHLUSS) then
      StaticText3.Caption := inttostr(DateDiff(BEGINN, ABSCHLUSS))
    else
      StaticText3.Caption := '';

    // Verfall in
    if FieldByName('VERFALL').IsNotNull then
      VERFALL := datetime2long(FieldByNAme('VERFALL').AsDate);
    if DateOK(VERFALL) then
      StaticText4.Caption := inttostr(DateDiff(DateGet, VERFALL))
    else
      StaticText4.Caption := '';

  end;
end;

procedure TFormQAuftrag.IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
begin
  UpdateMainCaption;
end;

procedure TFormQAuftrag.IB_Query3AfterPost(IB_Dataset: TIB_Dataset);
begin
  if not (SupressRecalc) then
    RecalcAuftrag;
end;

procedure TFormQAuftrag.IB_Query2AfterPost(IB_Dataset: TIB_Dataset);
begin
  if not (SupressRecalc) then
    RecalcAuftrag;
end;

procedure TFormQAuftrag.IB_Grid2DblClick(Sender: TObject);
begin
  ToggleAbschlussDatum;
end;

end.

