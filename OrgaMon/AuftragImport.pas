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
unit AuftragImport;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, ComCtrls,
  StdCtrls, IB_Components, ExtCtrls,
  IB_Access;

type
  TFormAuftragImport = class(TForm)
    Label2: TLabel;
    Label4: TLabel;
    Button8: TButton;
    Button9: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    OpenDialog2: TOpenDialog;
    Button10: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ListBox4: TListBox;
    Button4: TButton;
    Panel1: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    CheckBox2: TCheckBox;
    Button2: TButton;
    IB_Query1: TIB_Query;
    IB_Query2: TIB_Query;
    IB_Query3: TIB_Query;
    Timer1: TTimer;
    IB_Query4: TIB_Query;
    IB_Query5: TIB_Query;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label13: TLabel;
    ProgressBar1: TProgressBar;
    Button3: TButton;
    ComboBox6: TComboBox;
    CheckBox1: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox5: TCheckBox;
    Edit3: TEdit;
    IB_DSQL1: TIB_DSQL;
    IB_DSQL2: TIB_DSQL;
    Panel2: TPanel;
    Label15: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    Label19: TLabel;
    Button11: TButton;
    Panel5: TPanel;
    Panel6: TPanel;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox8: TCheckBox;
    Image3: TImage;
    Edit1: TEdit;
    Button12: TButton;
    CheckBox4: TCheckBox;
    Button13: TButton;
    Button14: TButton;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    Edit4: TEdit;
    Edit5: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ListBox2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure ComboBox6DropDown(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox3DblClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
  private
    { Private-Deklarationen }
    Last_Import_RID: integer;
    procedure ensureBaustellenCombo;

  public
    { Public-Deklarationen }
    ImportFields: TStringList;
    ImportFile: TStringList;
    _l3_ItemIndex: integer;
    _l2_ItemIndex: integer;
    SchemaChanged: boolean;

    QuellDelimiter: Char;
    QuellHeaderLines: integer;

    procedure L3Changed;
    procedure L2Changed;
    procedure LoadImportFile;
    procedure SaveSchema(FName: string);
    function LoadSchema: boolean;
    procedure ReadParameter;
    procedure SetDefaults;
    procedure setContext(BAUSTELLE_R: integer);
    procedure mShow;
    function SchemaTmpFName: String;
  end;

var
  FormAuftragImport: TFormAuftragImport;

implementation

uses
  globals, anfix, gplists,
  math, WordIndex, Baustelle,
  AuftragArbeitsplatz, Bearbeiter, OrientationConvert,
  Datenbank,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  Funktionen_Transaktion,
  dbOrgaMon,
  CaretakerClient,
  wanfix;

{$R *.DFM}

function Feedback (key : Integer; value : string = '') : Integer;
begin
  result := 0;
  with FormAuftragImport do
  begin
    case key of
     cFeedBack_ProcessMessages:Application.ProcessMessages;
     cFeedBack_Edit+1:edit1.Text := value;
     cFeedBack_ProgressBar_Max+1:ProgressBar1.Max := StrToIntDef(value,0);
     cFeedBack_ProgressBar_Position+1:ProgressBar1.Position := StrToIntDef(value,0);
     cFeedBack_Label+14:label14.Caption := value;
     cFeedBack_ListBox_clear+3:Listbox3.Items.Clear;
     cFeedBack_ListBox_clear+4:Listbox4.Items.Clear;
     cFeedBack_ListBox_add+3:Listbox3.items.Add(value);
     cFeedBack_ShowMessage:ShowMessage(value);
     cFeedback_doit:if doit(value) then
                      result := cFeedBack_TRUE
                    else
                     result := cFeedBack_FALSE;
     cFeedBack_openShell:openShell(value);
     cFeedBack_Function+1:FormAuftragArbeitsplatz.ClearMarkierte;
     cFeedBack_Function+2:FormAuftragArbeitsplatz.AddMarkierte_RID_AT_IMPORT(StrToIntDef(value,0));
     cFeedBack_Function+3:Last_Import_RID := StrToIntDef(value,0);
    else
     ShowMessage('Unbekannter Feedback Key '+IntToStr(Key));
    end;
  end;
end;

procedure TFormAuftragImport.Button1Click(Sender: TObject);
var
  RID_AT_IMPORT: integer;
  Auftrag: TIB_Query;
  ImportRIDs: TList;
  DeleteCount: integer;
begin
  //
  BeginHourGlass;
  RID_AT_IMPORT := strtol(Edit2.Text);

  // sammle allen
  ImportRIDs := TList.create;
  Auftrag := DataModuleDatenbank.nQuery;
  with Auftrag do
  begin
    sql.add('SELECT RID FROM AUFTRAG WHERE RID_AT_IMPORT=' + inttostr(RID_AT_IMPORT));
    open;
    first;
    while not(eof) do
    begin
      ImportRIDs.add(TObject(FieldByName('RID').AsInteger));
      next;
    end;
  end;
  Auftrag.free;

  DeleteCount := 0;
  RecourseDeleteAUFTRAG(ImportRIDs, DeleteCount);
  ImportRIDs.free;

  EndHourGlass;
  Edit2.Text := '';
  ShowMessage('Es wurden ' + inttostr(DeleteCount) + ' Datensätze gelöscht (incl. Historische)');
end;

procedure TFormAuftragImport.FormCreate(Sender: TObject);
var
  n: integer;
begin
  ImportFields := TStringList.create;
  for n := 0 to high(cImportFields) do
    ImportFields.add(cImportFields[n]);
  ListBox1.items.assign(ImportFields);
  OpenDialog1.InitialDir := SchemaPath;
  SaveDialog1.InitialDir := SchemaPath;
  OpenDialog2.InitialDir := RohstoffePath;
  CheckCreateDir(SchemaPath);
  CheckCreateDir(RohstoffePath);
  ImportFile := TStringList.create;
  PageControl1.ActivePage := TabSheet1;
  top := 0;
  left := 0;
  QuellDelimiter := ';';
  QuellHeaderLines := 1;
end;

procedure TFormAuftragImport.Button9Click(Sender: TObject);
begin
  if (edit5.Text <> '') then
    OpenDialog2.InitialDir := ExtractFilePath(edit5.Text)
  else
    OpenDialog2.InitialDir := iCSVOpenPath;
  if OpenDialog2.execute then
  begin
    edit5.Text := OpenDialog2.FileName;
    LoadImportFile;
  end;
end;

procedure TFormAuftragImport.Button8Click(Sender: TObject);
begin
  if OpenDialog1.execute then
  begin
    edit4.Text := OpenDialog1.FileName;
    LoadSchema;
  end;
end;

procedure TFormAuftragImport.Button10Click(Sender: TObject);
begin
  SaveDialog1.FileName := edit4.Text;
  if SaveDialog1.execute then
  begin
    edit4.Text := SaveDialog1.FileName;
    SaveSchema(edit4.Text);
  end;
end;

procedure TFormAuftragImport.LoadImportFile;
var
  SpalteNo: integer;
  SpalteNo2: integer;
  OneLine: string;
  n, k: integer;
  sFileName: string;
  sExcelFileName: string;
begin

  sFileName := edit5.Text;
  k := revpos('.', sFileName);
  if (k > 0) then
  begin

    // Aus Excel konvertieren?!
    sExcelFileName := copy(sFileName, 1, pred(k));
    k := revpos('.', sExcelFileName);
    if (AnsiUpperCase(copy(sExcelFileName, k, MaxInt)) = AnsiUpperCase(cSpreadsheetExtension)) then
      if FileExists(sExcelFileName) then
        if (FileAge(sFileName) < FileAge(sExcelFileName)) then
        begin
          BeginHourGlass;
          doConversion(Content_Mode_xls2csv, sExcelFileName);
          EndHourGlass;
        end;

  end;

  if FileExists(sFileName) then
  begin

    BeginHourGlass;
    LoadFromFileCSV(true, ImportFile, sFileName);
    EndHourGlass;

    if (ImportFile.count > 0) then
    begin

      if CheckBox8.checked then
      begin
        for n := 0 to pred(ImportFile.count) do
          ImportFile[n] := Oem2Ansi(ImportFile[n]);
      end;

      ListBox3.items.clear;
      OneLine := ImportFile[0];
      SpalteNo := 0;
      while (OneLine <> '') do
      begin
        inc(SpalteNo);
        ListBox3.items.add(inttostrN(SpalteNo, 2) + ':' + nextp(OneLine, QuellDelimiter));
      end;
      SpalteNo := CharCount(QuellDelimiter, ImportFile[0]);

      if (ImportFile.count > 1) then
        SpalteNo2 := CharCount(QuellDelimiter, ImportFile[1])
      else
        SpalteNo2 := 0;

      // Caches
      _l3_ItemIndex := -1;
      ListBox4.items.clear;

      //
      Label14.Caption :=
       {} '(' + inttostr(ImportFile.count - QuellHeaderLines) + ' Datensätze / ' +
       {} inttostr(SpalteNo) + '(' + inttostr(SpalteNo2) + ') Spalten)';
    end
    else
    begin
      ShowMessage('Eine andere Anwendung sperrt diese Datei (Excel?!)!' + #13 + 'Oder die Datei ist leer!');
    end;
  end;
end;

procedure TFormAuftragImport.Timer1Timer(Sender: TObject);
begin
  if NoTimer then
    exit;
  if not(active) then
    exit;
  if (PageControl1.ActivePage<>TabSheet1) then
    exit;

  if (ListBox3.itemIndex <> _l3_ItemIndex) then
    L3Changed;
  if (ListBox2.itemIndex <> _l2_ItemIndex) then
    L2Changed;
  Button4.enabled := (ListBox1.itemIndex <> -1);
  Button5.enabled := ComboBox3.Visible and (ListBox3.itemIndex <> -1);
  Button6.enabled := ComboBox4.Visible and (ListBox3.itemIndex <> -1);
  Button7.enabled := ComboBox5.Visible and (ListBox3.itemIndex <> -1);
  Panel1.Visible := (ListBox2.itemIndex <> -1);
  Label12.Visible := SchemaChanged;
end;

procedure TFormAuftragImport.L3Changed;
var
  n: integer;
  ShowMAx: integer;
  SubItems: TStringList;
begin
  BeginHourGlass;
  _l3_ItemIndex := ListBox3.itemIndex;
  ListBox4.items.clear;
  if CheckBox2.checked then
    ShowMax := MaxInt
  else
    ShowMax := 10;
  for n := QuellHeaderLines to min(pred(ImportFile.count), ShowMAx) do
  begin
    SubItems := Split(ImportFile[n], QuellDelimiter, '"');
    if (SubItems.count > _l3_ItemIndex) then
      ListBox4.items.add(SubItems[_l3_ItemIndex])
    else
      ListBox4.items.add('SpalteFehlt');
    SubItems.free;
  end;
  EndHourGlass;
end;

procedure TFormAuftragImport.L2Changed;
var
  TheParameter: string;
  ParamCount: integer;
begin
  _l2_ItemIndex := ListBox2.itemIndex;
  if ListBox2.itemIndex <> -1 then
  begin
    TheParameter := ListBox2.items[ListBox2.itemIndex];
    TheParameter := copy(TheParameter, succ(pos('(', TheParameter)), MaxInt);
    delete(TheParameter, length(TheParameter), 1);

    ParamCount := CharCount(',', TheParameter) + 1;

    ComboBox3.Text := nextp(TheParameter, ',');
    ComboBox4.Text := nextp(TheParameter, ',');
    ComboBox5.Text := nextp(TheParameter, ',');
    case ParamCount of
      0:
        begin
          ComboBox3.Visible := false;
          ComboBox4.Visible := false;
          ComboBox5.Visible := false;
        end;
      1:
        begin
          ComboBox3.Visible := true;
          ComboBox4.Visible := false;
          ComboBox5.Visible := false;
        end;
      2:
        begin
          ComboBox3.Visible := true;
          ComboBox4.Visible := true;
          ComboBox5.Visible := false;
        end;
      3:
        begin
          ComboBox3.Visible := true;
          ComboBox4.Visible := true;
          ComboBox5.Visible := true;
        end;
    end;
  end;

end;

procedure TFormAuftragImport.SaveSchema(FName: string);
var
  OutData: TStringList;
begin
  OutData := TStringList.create;
  OutData.add(edit5.Text);
  OutData.AddStrings(ListBox2.items);
  OutData.SaveToFile(FName);
  OutData.free;
  if (FName = edit4.Text) then
    SchemaChanged := false;
end;

function TFormAuftragImport.SchemaTmpFName: String;
begin
  result := SchemaPath + sBearbeiterKurz + '-ungespeichert' + cSchemaExtension;
end;

procedure TFormAuftragImport.setContext(BAUSTELLE_R: integer);
var
  sBaustelle: string;
begin

  // Vorlauf ...
  BeginHourGlass;
  sBaustelle := e_r_BaustelleKuerzel(BAUSTELLE_R);
  ensureBaustellenCombo;
  ComboBox6.itemIndex := ComboBox6.items.indexof(sBaustelle);
  edit4.Text := SchemaPath + sBaustelle + cSchemaExtension;
  EndHourGlass;

  if LoadSchema then
  begin
    // Weitere Einstellungen
    SetDefaults;
    PageControl1.ActivePage := TabSheet2;
    show;
  end;
end;

procedure TFormAuftragImport.SetDefaults;
begin
  CheckBox1.checked := true;
  Edit3.Text := '';
  CheckBox5.checked := false;
  CheckBox11.checked := false;
  CheckBox13.checked := false;
  CheckBox14.checked := false;
  CheckBox3.checked := false;
  CheckBox12.checked := false;
end;

function TFormAuftragImport.LoadSchema: boolean;
var
  InData: TStringList;
  FName: string;
begin
  result := false;
  InData := TStringList.create;
  FName := edit4.Text;
  if FileExists(FName) then
  begin
    BeginHourGlass;
    SchemaChanged := false;
    InData.LoadFromFile(FName);
    edit5.Text := InData[0];
    InData.delete(0);
    ListBox2.items.assign(InData);
    LoadImportFile;
    result := true;
    EndHourGlass;
  end
  else
  begin
    ShowMessage(FName + ' nicht vorhanden!');
  end;
  InData.free;
end;

procedure TFormAuftragImport.ListBox2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_DELETE:
      if ListBox2.itemIndex <> -1 then
        if doit('Zuordnung ' + ListBox2.items[ListBox2.itemIndex] + ' löschen') then
        begin
          ListBox2.items.delete(ListBox2.itemIndex);
          SchemaChanged := true;
        end;
  end;
end;

procedure TFormAuftragImport.Button4Click(Sender: TObject);
var
  NewLine: string;
  AlreadyThere: boolean;
  n: integer;
begin
  if ListBox1.itemIndex <> -1 then
  begin
    NewLine := ListBox1.items[ListBox1.itemIndex];
    AlreadyThere := false;
    if pos('_Info_#', NewLine) = 0 then
      for n := 0 to pred(ListBox2.items.count) do
        if pos(NewLine + '(', ListBox2.items[n]) = 1 then
          AlreadyThere := true;
    if not(AlreadyThere) then
    begin
      SchemaChanged := true;
      ListBox2.items.add(NewLine + '(' + Fill(',', max(0, pred(CharCount('#', NewLine)))) + ')');
      ListBox2.itemIndex := pred(ListBox2.items.count);
    end
    else
      ShowMessage('Zuordnung bereits vorhanden!');
  end;
end;

procedure TFormAuftragImport.Button5Click(Sender: TObject);
begin
  if (ListBox2.itemIndex <> -1) then
    if (ListBox3.itemIndex <> -1) and (ComboBox3.Visible) then
    begin
      ComboBox3.Text := copy(ListBox3.items[ListBox3.itemIndex], 1, pred(pos(':', ListBox3.items[ListBox3.itemIndex])));
      ReadParameter;
    end;
end;

procedure TFormAuftragImport.Button6Click(Sender: TObject);
begin
  if (ListBox2.itemIndex <> -1) then
    if (ListBox3.itemIndex <> -1) and (ComboBox4.Visible) then
    begin
      ComboBox4.Text := copy(ListBox3.items[ListBox3.itemIndex], 1, pred(pos(':', ListBox3.items[ListBox3.itemIndex])));

      ReadParameter;
    end;
end;

procedure TFormAuftragImport.Button7Click(Sender: TObject);
begin
  if (ListBox2.itemIndex <> -1) then
    if (ListBox3.itemIndex <> -1) and (ComboBox5.Visible) then
    begin
      ComboBox5.Text := copy(ListBox3.items[ListBox3.itemIndex], 1, pred(pos(':', ListBox3.items[ListBox3.itemIndex])));

      ReadParameter;
    end;
end;

procedure TFormAuftragImport.ReadParameter;
var
  NewValue: string;
begin
  if ListBox2.itemIndex <> -1 then
  begin
    NewValue := ListBox2.items[ListBox2.itemIndex];
    NewValue := copy(NewValue, 1, pos('(', NewValue));

    if ComboBox3.Visible then
      NewValue := NewValue + ComboBox3.Text;

    if ComboBox4.Visible then
      NewValue := NewValue + ',' + ComboBox4.Text;

    if ComboBox5.Visible then
      NewValue := NewValue + ',' + ComboBox5.Text;

    NewValue := NewValue + ')';

    if NewValue <> ListBox2.items[ListBox2.itemIndex] then
    begin
      ListBox2.items[ListBox2.itemIndex] := NewValue;
      SchemaChanged := true;
    end;

  end;
end;

procedure TFormAuftragImport.ComboBox3Change(Sender: TObject);
begin
  ReadParameter;
end;

procedure TFormAuftragImport.ComboBox4Change(Sender: TObject);
begin
  ReadParameter;
end;

procedure TFormAuftragImport.ComboBox5Change(Sender: TObject);
begin
  ReadParameter;
end;

procedure TFormAuftragImport.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Key := #0;
    close;
  end;
end;

procedure TFormAuftragImport.Image3Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Import');
end;

procedure TFormAuftragImport.Button3Click(Sender: TObject);
var
 qOptions: TStringList;
 BAUSTELLE_R: Integer;
begin
  Button3.enabled := false;

  //
  BAUSTELLE_R := e_r_BaustelleRIDFromKuerzel(ComboBox6.Text);
  if (BAUSTELLE_R>=cRID_FirstValid) then
  begin

    qOptions:= TStringList.create;
    with qOptions do
    begin

      if SchemaChanged then
      begin
        SaveSchema(SchemaTmpFName);
        values['SchemaFileName'] := SchemaTmpFName;
      end else
      begin
        values['SchemaFileName'] := edit4.Text;
      end;


      values['DataFileName'] := edit5.Text;
      values['NurDenLetztenBlock'] := bool2cO(CheckBox14.checked);
      values['NurZiffern'] :=  bool2cO(CheckBox13.checked);
      values['QuellHeaderLines'] := IntToStr(QuellHeaderLines);
      values['NummerConcatArt'] := bool2cO(CheckBox5.checked);
      values['NummerConcatMaterial'] := bool2cO(CheckBox11.checked);
      values['Planquadrat'] := Edit3.Text;
      values['IgnoreEmptyArt'] := bool2cO(CheckBox12.checked);
      values['QuellDelimiter'] :=  QuellDelimiter;
      values['Eindeutig'] := bool2cO(CheckBox1.checked);
      values['Simulieren'] := bool2cO(CheckBox3.checked);
      values['DeleteMarked'] := bool2cO(CheckBox10.checked);
      values['MarkImported'] := bool2cO(CheckBox9.checked);
      values['OEM'] :=bool2cO(CheckBox8.checked);
    end;
    e_w_Import(
     { } BAUSTELLE_R,
     { } qOptions,
     { } Feedback);
    qOptions.Free;
  end;

  Button3.enabled := true;
  if not(CheckBox3.checked) then
    close;
end;

procedure TFormAuftragImport.mShow;
begin
  WindowState := wsNormal;
  show;
end;

procedure TFormAuftragImport.Button2Click(Sender: TObject);
var
  AllTheLines: TStringList;
  MoreInfo: TWordIndex;
  n: integer;
  DeleteCount: integer;
  AllCount: integer;
  OneStr: string;
begin

  //
  AllCount := ListBox4.items.count;
  AllTheLines := TStringList.create;
  for n := 0 to pred(ListBox4.items.count) do
  begin
    OneStr := ListBox4.items[n];
    ersetze(' ', '_', OneStr);
    AllTheLines.addobject(OneStr, TObject(n));
  end;

  //
  AllTheLines.SaveToFile(DiagnosePath + 'Import-ZaehlerNummern.txt');
  MoreInfo := TWordIndex.create(AllTheLines, 1);
  MoreInfo.saveToDiagFile(DiagnosePath + 'Import-Doppelte.txt', 2, MaxInt);
  AllTheLines.Sort;
  RemoveDuplicates(AllTheLines, DeleteCount);
  ShowMessage(inttostr(DeleteCount) + ' Doppelte' + #13 + inttostr(AllCount) + ' insgesamt!');
  if (DeleteCount > 0) then
    openShell(DiagnosePath + 'Import-Doppelte.txt');
  MoreInfo.free;
  AllTheLines.free;
end;

procedure TFormAuftragImport.CheckBox2Click(Sender: TObject);
begin
  L3Changed;
end;

procedure TFormAuftragImport.ComboBox6DropDown(Sender: TObject);
begin
  ensureBaustellenCombo;
end;

procedure TFormAuftragImport.ensureBaustellenCombo;
var
  s: TStringList;
begin
  s := e_r_Baustellen;
  ComboBox6.items.assign(s);
  s.free;
end;

procedure TFormAuftragImport.Button11Click(Sender: TObject);
begin
  openShell(ImportePath + inttostr(Last_Import_RID) + '\Info.txt');
end;

procedure TFormAuftragImport.Button12Click(Sender: TObject);
begin
  openShell(ImportePath + inttostr(Last_Import_RID) + '\Abgelehnte.csv');
end;

procedure TFormAuftragImport.Button13Click(Sender: TObject);
var
  Index: integer;
begin
  // Up
  with ListBox2 do
  begin
    items.BeginUpdate;
    Index := itemIndex;
    if (Index > 0) then
    begin
      items.exchange(Index, Index - 1);
      itemIndex := pred(Index);
      SchemaChanged := true;
    end;
    items.EndUpdate;
  end;
end;

procedure TFormAuftragImport.Button14Click(Sender: TObject);
var
  Index: integer;
begin
  // DOWN
  with ListBox2 do
  begin
    items.BeginUpdate;
    Index := itemIndex;
    if (Index >= 0) and (Index < pred(items.count)) then
    begin
      items.exchange(Index, Index + 1);
      itemIndex := Index + 1;
      SchemaChanged := true;
    end;
    items.EndUpdate;
  end;
end;

procedure TFormAuftragImport.CheckBox6Click(Sender: TObject);
begin
  if CheckBox6.checked then
  begin
    QuellDelimiter := #9;
  end
  else
  begin
    QuellDelimiter := ';';
  end;
end;

procedure TFormAuftragImport.CheckBox7Click(Sender: TObject);
begin
  if CheckBox7.checked then
  begin
    QuellHeaderLines := 1;
  end
  else
  begin
    QuellHeaderLines := 0;
  end;
end;

procedure TFormAuftragImport.ListBox1DblClick(Sender: TObject);
begin
  Button4.click;
end;

procedure TFormAuftragImport.ListBox3DblClick(Sender: TObject);
begin
  repeat
    if (ComboBox3.Text = '') then
    begin
      Button5.click;
      break;
    end;

    if (ComboBox4.Text = '') then
    begin
      Button6.click;
      break;
    end;

    if (ComboBox5.Text = '') then
    begin
      Button7.click;
      break;
    end;

  until true;
end;

procedure TFormAuftragImport.FormDeactivate(Sender: TObject);
begin
  FormAuftragArbeitsplatz.NotifyBaustelleChanged(Sender);
end;

end.
