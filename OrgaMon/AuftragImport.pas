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
    ComboBox1: TComboBox;
    Label2: TLabel;
    Label4: TLabel;
    ComboBox2: TComboBox;
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
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ListBox2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
    procedure doImport;
    procedure setContext(BAUSTELLE_R: integer);
    procedure mShow;
  end;

var
  FormAuftragImport: TFormAuftragImport;

implementation

uses
  globals, anfix32, gplists,
  math, WordIndex, Baustelle,
  AuftragArbeitsplatz, Bearbeiter, OrientationConvert,
  Datenbank,
  Funktionen.Basis,
  Funktionen.Beleg,
  Funktionen.Auftrag,
  Funktionen.Transaktion,
  IBExportTable,
  CaretakerClient,
  wanfix32;

{$R *.DFM}

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
    sql.add('SELECT RID FROM AUFTRAG WHERE RID_AT_IMPORT=' +
      inttostr(RID_AT_IMPORT));
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
  ShowMessage('Es wurden ' + inttostr(DeleteCount) +
    ' Datensätze gelöscht (incl. Historische)');
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
  if (ComboBox2.Text <> '') then
    OpenDialog2.InitialDir := ExtractFilePath(ComboBox2.Text)
  else
    OpenDialog2.InitialDir := iCSVOpenPath;
  if OpenDialog2.execute then
  begin
    ComboBox2.Text := OpenDialog2.FileName;
    LoadImportFile;
  end;
end;

procedure TFormAuftragImport.Button8Click(Sender: TObject);
begin
  if OpenDialog1.execute then
  begin
    ComboBox1.Text := OpenDialog1.FileName;
    LoadSchema;
  end;
end;

procedure TFormAuftragImport.Button10Click(Sender: TObject);
begin
  SaveDialog1.FileName := ComboBox1.Text;
  if SaveDialog1.execute then
  begin
    ComboBox1.Text := SaveDialog1.FileName;
    SaveSchema(ComboBox1.Text);
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

  sFileName := ComboBox2.Text;
  k := revpos('.', sFileName);
  if (k > 0) then
  begin

    // Aus Excel konvertieren?!
    sExcelFileName := copy(sFileName, 1, pred(k));
    k := revpos('.', sExcelFileName);
    if (AnsiUpperCase(copy(sExcelFileName, k, MaxInt))
      = AnsiUpperCase(cExcelExtension)) then
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
        ListBox3.items.add(inttostrN(SpalteNo, 2) + ':' + nextp(OneLine,
          QuellDelimiter));
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
      Label14.Caption := '(' + inttostr(ImportFile.count - QuellHeaderLines) +
        ' Datensätze / ' + inttostr(SpalteNo) + '(' + inttostr(SpalteNo2) +
        ') Spalten)';
    end
    else
    begin
      ShowMessage('Eine andere Anwendung sperrt diese Datei (Excel?!)!' + #13 +
        'Oder die Datei ist leer!');
    end;
  end;
end;

procedure TFormAuftragImport.Timer1Timer(Sender: TObject);
begin
  if NoTimer then
    exit;
  if not(active) then
    exit;
  if ListBox3.itemIndex <> _l3_ItemIndex then
    L3Changed;
  if ListBox2.itemIndex <> _l2_ItemIndex then
    L2Changed;
  Button4.enabled := ListBox1.itemIndex <> -1;
  Button5.enabled := ComboBox3.Visible and (ListBox3.itemIndex <> -1);
  Button6.enabled := ComboBox4.Visible and (ListBox3.itemIndex <> -1);
  Button7.enabled := ComboBox5.Visible and (ListBox3.itemIndex <> -1);
  Panel1.Visible := ListBox2.itemIndex <> -1;
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
    ShowMAx := MaxInt
  else
    ShowMAx := 10;
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

procedure TFormAuftragImport.SaveSchema;
var
  OutData: TStringList;
begin
  OutData := TStringList.create;
  OutData.add(ComboBox2.Text);
  OutData.AddStrings(ListBox2.items);
  OutData.SaveToFile(FName);
  OutData.free;
  if (FName = ComboBox1.Text) then
    SchemaChanged := false;
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
  ComboBox1.Text := SchemaPath + sBaustelle + cSchemaExtension;
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
  CheckBox11.Checked := false;
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
  FName := ComboBox1.Text;
  if FileExists(FName) then
  begin
    BeginHourGlass;
    SchemaChanged := false;
    InData.LoadFromFile(FName);
    ComboBox2.Text := InData[0];
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

procedure TFormAuftragImport.ListBox2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_DELETE:
      if ListBox2.itemIndex <> -1 then
        if doit('Zuordnung ' + ListBox2.items[ListBox2.itemIndex] + ' löschen')
        then
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
      ListBox2.items.add(NewLine + '(' + Fill(',',
        max(0, pred(CharCount('#', NewLine)))) + ')');
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
      ComboBox3.Text := copy(ListBox3.items[ListBox3.itemIndex], 1,
        pred(pos(':', ListBox3.items[ListBox3.itemIndex])));
      ReadParameter;
    end;
end;

procedure TFormAuftragImport.Button6Click(Sender: TObject);
begin
  if (ListBox2.itemIndex <> -1) then
    if (ListBox3.itemIndex <> -1) and (ComboBox4.Visible) then
    begin
      ComboBox4.Text := copy(ListBox3.items[ListBox3.itemIndex], 1,
        pred(pos(':', ListBox3.items[ListBox3.itemIndex])));

      ReadParameter;
    end;
end;

procedure TFormAuftragImport.Button7Click(Sender: TObject);
begin
  if (ListBox2.itemIndex <> -1) then
    if (ListBox3.itemIndex <> -1) and (ComboBox5.Visible) then
    begin
      ComboBox5.Text := copy(ListBox3.items[ListBox3.itemIndex], 1,
        pred(pos(':', ListBox3.items[ListBox3.itemIndex])));

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
begin
  Button3.enabled := false;
  doImport;
  Button3.enabled := true;
end;

procedure TFormAuftragImport.doImport;
var
  InpStr: string;
  n, m, k, l: integer;
  STime: dword;

  _Monteur_r: integer;
  _Monteur: string;
  _Nummer: string;

  _Name: string;
  _Strasse: string;
  _HausNummer: string;

  _plz: string;
  _ort: string;
  _Art: string;
  _Zeile: string;
  _Zaehlwerke: integer;
  Zaehlwerk: integer;
  Anzahl_Zaehlwerk_0: integer;
  Anzahl_Zaehlwerk_nicht_1: integer;

  _ZaehlerMehrInfo: TStringList;
  _MonteurMehrInfo: TStringList;
  _InternMehrInfo: TStringList;

  _ZaehlerTyp: string;
  MoreTextInfo: TStringList;

  // Parameter aus der Baustelle
  Baustelle_StellenAnzZaehlerNummer: integer;
  Baustelle_Ortsteilcodes: boolean;

  _Verbraucher_r: integer;
  ThisDate: TANFiXDate;
  SpaltenWerte_Primaer: TStringList;
  SpaltenWerte_Sekundaer: TStringList;
  SubItemIndex: integer;
  Umsetzer: TStringList;
  InfoFile: TStringList;
  ParameterItems: TStringList;
  AllParameter: string;
  UmsetzerNo: integer;
  ParameterError: boolean;
  BAUSTELLE_R: integer;
  AUFTRAG_R: integer;
  qAUFTRAG: TIB_Query;
  RID_AT_IMPORT: integer;
  _Date, _Date1, _Date2: TANFiXDate;
  _planquadrat: string;
  MONTEUR_R: integer;

  //
  MoreInfo: TWordIndex;
  OrgCount: integer;
  DeleteCount: integer;
  AllCount: integer;

  // Zählernummer Verwaltung
  ZaehlerNummernInCSV: TStringList;
  ZaehlerNummernImBestand: TStringList; // [<Art> "-" ] Nummer
  Abgelehnte: TStringList;
  _ZaehlerNummer: string; // Zählernummer aus dem Import
  ZaehlerNummerAbgeschnittenCount: integer;

  // ermittelte Spalten Index
  ZaehlerNummer_FieldIndex: integer;
  KundeBriefName1_FieldIndex: integer;
  ZaehlerArt_FieldIndex: integer;
  MaterialNummer_FieldIndex: integer;
  Zaehlwerk_FieldIndex: integer;
  OrtsTeil_FieldIndex: integer;
  VorberechnetePlausibilitaetVon_FieldIndex: integer;
  VorberechnetePlausibilitaetBis_FieldIndex: integer;
  LetzterAblesestand_FieldIndex: integer;

  Importierte: TStringList;
  lImportierte: TgpIntegerList;
  _zaehler_nummer: string;
  _importFile: TStringList;
  OrtsteileDerQuelle: TStringList;

  // Für Strassen / Planquadrat Informationen
  _LastLocation: string;
  _DieseStrasse: string;
  _DieserOrt: string;
  _HausZusatz: string;
  StrassenListeMitPlanquadrat: TSearchStringList;

  r1AsString: string;
  ABNummer: integer;

  // Verbrauchs Geschichten
  Verbrauch_0_Datum: TANFiXDate;
  Verbrauch_1_Datum: TANFiXDate;
  Verbrauch_0_Zaehler_Stand: int64;
  Verbrauch_1_Zaehler_Stand: int64;

  // Post-Transaktionen
  Transaktionen: TStringList;

  function sSpaltenWert(i: integer): string;
  begin
    if (i >= 0) and (i < SpaltenWerte_Primaer.count) then
      result := SpaltenWerte_Primaer[i]
    else
      result := '';
  end;

  function sSpaltenWert_Sekundaer(i: integer): string;
  begin
    if (i >= 0) and (i < SpaltenWerte_Sekundaer.count) then
      result := SpaltenWerte_Sekundaer[i]
    else
      result := '';
  end;

  function rSpaltenWert(n: byte): string;
  begin
    result := sSpaltenWert(strtol(ParameterItems[pred(n)]) - 1);
  end;

  function rSpaltenWert_Sekundaer(n: byte): string;
  begin
    result := sSpaltenWert_Sekundaer(strtol(ParameterItems[pred(n)]) - 1);
  end;

  function FormatZaehlerNummer(s: string): string;
  var
    ZaehlerNummer: int64;
    n: integer;
    zn: string;
  begin
    if (Baustelle_StellenAnzZaehlerNummer < 99) then
    begin

      // Grundsätzliche Aktionen
      s := noblank(s);

      // nur den letzten Ziffernblok?
      if CheckBox14.checked then
      begin
        zn := '';
        for n := length(s) downto 1 do
          if s[n] in ['0' .. '9'] then
            zn := s[n] + zn
          else
            break;
        s := zn;
      end;

      // Nur Ziffern?
      if CheckBox13.checked then
        s := StrFilter(s, '0123456789');

      ZaehlerNummer := strtoint64def(s, 0);
      if (ZaehlerNummer <> 0) then
        result := inttostrN(ZaehlerNummer, Baustelle_StellenAnzZaehlerNummer)
      else
        result := Fill('0', Baustelle_StellenAnzZaehlerNummer - length(s)) + s;
    end
    else
    begin
      result := noblank(s);
    end;
    if length(result) > cZaehlerNummerFieldLength then
      inc(ZaehlerNummerAbgeschnittenCount);
  end;

  function FormatZaehlerNummerAsOneWord(s: string): string;
  begin
    // sicherstellen, dass das Word-Index Objekt die Zählernummern nicht zerreist
    result := FormatZaehlerNummer(s);
    ersetze('-', '~', result);
  end;

  function ObtainOrtCode(const _ort: string): string;
  begin
    result := e_r_OrtsteilCode(BAUSTELLE_R, _ort);
  end;

  function artA: string;
  begin
    result := sSpaltenWert(ZaehlerArt_FieldIndex);
    if (Zaehlwerk_FieldIndex <> -1) then
      result := SAP2art(result);
  end;

  function artB: string;
  begin
    result := sSpaltenWert_Sekundaer(ZaehlerArt_FieldIndex);
    if (Zaehlwerk_FieldIndex <> -1) then
      result := SAP2art(result);
  end;

  function Format_HausZusatz(s: string): string;
  begin
    result := cutblank(s) + ' ';
    if result[1] in ['0' .. '9'] then
      result := '/' + result;
    result := cutblank(result);
  end;

  function Format_HausNummer(s: string): string;
  begin
    result := cutblank(s);
    while (pos('0', result) = 1) do
      delete(result, 1, 1);
  end;

  function date_JJJJMMTT_2long(s: string): TANFiXDate;
  var
    i: integer;
  begin
    result := 0;
    i := strtointdef(s, 0);
    if (i > date2long(cOrgaMonBirthDay)) then
      result := date2long(copy(s, 7, 2) + '.' + copy(s, 5, 2) + '.' +
        copy(s, 1, 4))
  end;

  procedure readMinMax(Zaehlwerk: integer; sMin, sMax, sAlt: string);

    function MinMaxToDouble(const s: string): double;
    begin
      result := strtodoubledef(s, -1);
    end;

  var
    dMin, dMax, dAlt: double;
  begin
    dMin := MinMaxToDouble(sMin);
    dMax := MinMaxToDouble(sMax);
    dAlt := MinMaxToDouble(sAlt);
    if (dMin >= 0) and (dMax >= dMin) then
    begin
      _ZaehlerMehrInfo.add('v' + inttostr(Zaehlwerk) + '=' +
        format('%.2f', [dMin]));
      _ZaehlerMehrInfo.add('b' + inttostr(Zaehlwerk) + '=' +
        format('%.2f', [dMax]));
      _ZaehlerMehrInfo.add('a' + inttostr(Zaehlwerk) + '=' +
        format('%.2f', [dAlt]));
    end;
  end;

begin

  // Baustelle ermitteln
  BAUSTELLE_R := e_r_BaustelleRIDFromKuerzel(ComboBox6.Text);
  if (BAUSTELLE_R = -1) then
  begin
    ShowMessage('Keine Baustelle zugeordnet!');
    exit;
  end;

  // Baustellen-Daten einlesen
  with IB_Query5 do
  begin
    ParamByName('CROSSREF').AsInteger := BAUSTELLE_R;
    open;
    Baustelle_StellenAnzZaehlerNummer := FieldByName('ZAEHLER_NR_STELLEN')
      .AsInteger;
    Baustelle_Ortsteilcodes := (FieldByName('ORTE_AKTIV').AsString = 'Y');
    close;
  end;

  // bisherige Zählernummern lesen!
  ZaehlerNummernInCSV := TStringList.create;
  ZaehlerNummernImBestand := TStringList.create;
  OrtsteileDerQuelle := TStringList.create;
  Transaktionen := TStringList.create;
  SpaltenWerte_Primaer := nil;

  ZaehlerNummerAbgeschnittenCount := 0;
  DeleteCount := 0;
  OrgCount := ImportFile.count - QuellHeaderLines;
  ZaehlerNummer_FieldIndex := -1;
  KundeBriefName1_FieldIndex := -1;
  ZaehlerArt_FieldIndex := -1;
  MaterialNummer_FieldIndex := -1;
  Zaehlwerk_FieldIndex := -1;
  OrtsTeil_FieldIndex := -1;
  VorberechnetePlausibilitaetVon_FieldIndex := -1;
  VorberechnetePlausibilitaetBis_FieldIndex := -1;
  LetzterAblesestand_FieldIndex := -1;

  for n := 0 to pred(ListBox2.items.count) do
  begin

    InpStr := ListBox2.items[n];
    nextp(InpStr, '(');

    repeat

      if pos('Art' + '(', ListBox2.items[n]) = 1 then
      begin
        ZaehlerArt_FieldIndex := pred(strtol(nextp(InpStr, ')')));
        break;
      end;

      if pos('SAP_Art_#_#' + '(', ListBox2.items[n]) = 1 then
      begin
        ZaehlerArt_FieldIndex := pred(strtol(nextp(InpStr, ',')));
        Zaehlwerk_FieldIndex := pred(strtol(nextp(InpStr, ')')));
        CheckBox5.checked := true;
        break;
      end;

      if pos('Zähler_Nummer' + '(', ListBox2.items[n]) = 1 then
      begin
        ZaehlerNummer_FieldIndex := pred(strtol(nextp(InpStr, ')')));
        break;
      end;

      if pos('Material_Nummer' + '(', ListBox2.items[n]) = 1 then
      begin
        MaterialNummer_FieldIndex := pred(strtol(nextp(InpStr, ')')));
        break;
      end;

      if pos('Kunde_Brief_Name1' + '(', ListBox2.items[n]) = 1 then
      begin
        KundeBriefName1_FieldIndex := pred(strtol(nextp(InpStr, ')')));
        break;
      end;

      if pos('Zähler_Ort_Ortsteil' + '(', ListBox2.items[n]) = 1 then
      begin
        OrtsTeil_FieldIndex := pred(strtol(nextp(InpStr, ')')));
        break;
      end;

      if pos('C_Zähler_Ort_Ortsteil' + '(', ListBox2.items[n]) = 1 then
      begin
        OrtsteileDerQuelle.add(nextp(InpStr, ')'));
        break;
      end;

      if pos('Plausibilität_Min_Max_#_#_#' + '(', ListBox2.items[n]) = 1 then
      begin
        VorberechnetePlausibilitaetVon_FieldIndex :=
          pred(strtol(nextp(InpStr, ',')));
        VorberechnetePlausibilitaetBis_FieldIndex :=
          pred(strtol(nextp(InpStr, ',')));
        LetzterAblesestand_FieldIndex := pred(strtol(nextp(InpStr, ')')));
        break;
      end;

    until true;
  end;

  // P r ü f u n g e n
  if (ZaehlerNummer_FieldIndex = -1) then
  begin
    ShowMessage('Das Feld Zähler_Nummer muss importiert werden!');
    ZaehlerNummernImBestand.free;
    exit;
  end;

  if CheckBox5.checked and (ZaehlerArt_FieldIndex = -1) then
  begin
    ShowMessage('Das Feld Art muss importiert werden!');
    ZaehlerNummernImBestand.free;
    exit;
  end;

  if CheckBox11.checked and (MaterialNummer_FieldIndex = -1) then
  begin
    ShowMessage('Das Feld Material_Nummer muss importiert werden!');
    ZaehlerNummernImBestand.free;
    exit;
  end;

  BeginHourGlass;
  with IB_Query4 do
  begin
    close;
    ParamByName('CROSSREF').AsInteger := BAUSTELLE_R;
    open;
    first;
    while not(eof) do
    begin

      // Zählernummern sammeln
      repeat

        // ab verwendet und OK?
        if (Edit3.Text <> '') then
          if (FieldByName('PLANQUADRAT').AsString < Edit3.Text) then
            break;

        // hinzunehmen
        _ZaehlerNummer := FormatZaehlerNummer(FieldByName('ZAEHLER_NUMMER')
          .AsString);

        if CheckBox5.checked then
          _ZaehlerNummer := e_r_Sparte(FieldByName('ART').AsString) + '~' +
            _ZaehlerNummer;

        if CheckBox11.checked then
          _ZaehlerNummer := FieldByName('MATERIAL_NUMMER').AsString + '~' +
            _ZaehlerNummer;

        ZaehlerNummernImBestand.addobject(_ZaehlerNummer,
          TObject(FieldByName('RID').AsInteger));

      until true;

      next;
    end;
    close;
  end;
  ZaehlerNummernImBestand.Sort;
  RemoveDuplicates(ZaehlerNummernImBestand, DeleteCount);
  EndHourGlass;

  if (DeleteCount > 0) then
  begin
    if not(doit('Info: Die angegebene Baustelle hat schon' + #13 +
      'ohne diesen Import doppelte Zählernummern!' + #13 +
      'Mit dem Schalter 33/33 können Sie die doppelten' + #13 +
      'anzeigen. Wollen Sie dennoch importieren')) then
    begin
      ZaehlerNummernInCSV.free;
      ZaehlerNummernImBestand.free;
      exit;
    end;
  end;

  BeginHourGlass;
  // Import File nochmal laden, da beim letzten Import ev. durch doppelte
  //
  LoadImportFile;

  // Spalte "Zählernummer" nun laden:
  if CheckBox5.checked then
  begin
    _zaehler_nummer := '#';
    // mit Art
    for m := QuellHeaderLines to pred(ImportFile.count) do
    begin
      SpaltenWerte_Primaer := Split(ImportFile[m], QuellDelimiter, '"');
      _Art := artA;
      repeat

        // Leere Art weglassen!
        if CheckBox12.checked then
          if (_Art = '') then
            break;

        // Zählwerke<>'1' weglassen
        if (Zaehlwerk_FieldIndex <> -1) then
        begin
          // es wird nur EINE Zeile eines identischen Blocks importiert, danach
          // wird ignoriert!
          if (_zaehler_nummer = sSpaltenWert(ZaehlerNummer_FieldIndex)) then
            break;
          k := strtointdef(sSpaltenWert(Zaehlwerk_FieldIndex), 0);
          if (k <> 1) then
            break;

          // keine gültige Zeile -> löschen
          _zaehler_nummer := sSpaltenWert(ZaehlerNummer_FieldIndex);
          ZaehlerNummernInCSV.addobject(e_r_Sparte(_Art) +
            FormatZaehlerNummerAsOneWord(_zaehler_nummer), TObject(m));

        end
        else
        begin

          //
          ZaehlerNummernInCSV.addobject(e_r_Sparte(_Art) +
            FormatZaehlerNummerAsOneWord(sSpaltenWert(ZaehlerNummer_FieldIndex)),
            TObject(m));
        end;
      until true;
      FreeAndNil(SpaltenWerte_Primaer);
    end;
  end
  else
  begin
    // ohne Art-Ergänzung
    for m := QuellHeaderLines to pred(ImportFile.count) do
    begin
      SpaltenWerte_Primaer := Split(ImportFile[m], QuellDelimiter, '"');
      _Art := artA;
      repeat
        // Leere Art weglassen!
        if CheckBox12.checked then
          if (_Art = '') then
            break;

        ZaehlerNummernInCSV.addobject
          (FormatZaehlerNummerAsOneWord(sSpaltenWert(ZaehlerNummer_FieldIndex)),
          TObject(m));
      until true;
      FreeAndNil(SpaltenWerte_Primaer);
    end;
  end;

  // Schreibe Diagnose-Datei
  AllCount := ZaehlerNummernInCSV.count;
  MoreInfo := TWordIndex.create(ZaehlerNummernInCSV, 1);
  MoreInfo.saveToDiagFile(DiagnosePath + 'Import-Doppelte.txt', 2, MaxInt);
  ZaehlerNummernInCSV.Sort;
  ZaehlerNummernInCSV.SaveToFile(DiagnosePath + 'Import-ZaehlerNummern.txt');
  RemoveDuplicates(ZaehlerNummernInCSV, DeleteCount);
  MoreInfo.free;

  // auf die eindeutigen reduzieren!
  EndHourGlass;

  if (ZaehlerNummerAbgeschnittenCount > 0) then
  begin
    if doit('Die Baustelle hat keinen Eintrag ' + #13 +
      'in "Anzahl der Stellen Zählernummer".' + #13 +
      'Es mussten daher sehr lange Zählernummern' + #13 +
      '(>15 Zeichen) abgeschnitten werden.' + #13 +
      'Drücken Sie jetzt <ABBRECHEN> um dennoch zu importieren!' + #13 +
      'Zurück') then
    begin
      ZaehlerNummernInCSV.free;
      ZaehlerNummernImBestand.free;
      exit;
    end;
  end;

  if (DeleteCount > 0) then
  begin
    if doit('Es gibt ' + inttostr(DeleteCount) +
      ' doppelte Zählernummern in der csv!' + #13 + inttostr(AllCount) +
      ' Nummern insgesamt!' + #13 + 'Drücken Sie jetzt <OK> für eine Diagnose!'
      + #13 + ' Sie erhalten eine Aufstellung der Doppelten und sollten' + #13 +
      ' im Anschluss die "falschen" doppelten entfernen!' + #13 +
      'Drücken Sie jetzt <ABBRECHEN> um dennoch zu importieren!' + #13 +
      ' Doppelte Nummern werden dabei nicht importiert!' + #13) then
    begin
      openShell(DiagnosePath + 'Import-Doppelte.txt');
      ZaehlerNummernInCSV.free;
      ZaehlerNummernImBestand.free;
      exit;
    end;
  end;

  ZaehlerNummernInCSV.free;

  // noch sehen, ob es alle Ortsteile in der Baustelle schon gibt!
  if Baustelle_Ortsteilcodes then
  begin

    if (OrtsTeil_FieldIndex > -1) then
      for m := QuellHeaderLines to pred(ImportFile.count) do
        OrtsteileDerQuelle.add(cutblank(nextp(ImportFile[m], QuellDelimiter,
          OrtsTeil_FieldIndex)));
    // NIX NIX ^
    OrtsteileDerQuelle.Sort;
    RemoveDuplicates(OrtsteileDerQuelle);

    for m := pred(OrtsteileDerQuelle.count) downto 0 do
    begin
      if (e_r_OrtsteilCode(BAUSTELLE_R, OrtsteileDerQuelle[m]) <> '??') or
        (OrtsteileDerQuelle[m] = '') then
        OrtsteileDerQuelle.delete(m);
    end;

    if (OrtsteileDerQuelle.count > 0) then
    begin
      for m := 0 to pred(OrtsteileDerQuelle.count) do
        OrtsteileDerQuelle[m] := OrtsteileDerQuelle[m] + '=';
      OrtsteileDerQuelle.Insert(0, '// ');
      OrtsteileDerQuelle.Insert(1,
        '// Unten sind neue Ortsteile angegeben, die in der Baustelle noch');
      OrtsteileDerQuelle.Insert(2,
        '// nicht eingetragen sind. Kopieren Sie die Zeilen in die ');
      OrtsteileDerQuelle.Insert(3,
        '// Zwischenablage. Wählen Sie Baustelle->richtige Baustelle');
      OrtsteileDerQuelle.Insert(4,
        '// auswählen->Verabeiten. Fügen Sie die neuen Orsteile aus');
      OrtsteileDerQuelle.Insert(5,
        '// der Zwischenablage ein. Versehen Sie die Ortsteile mit');
      OrtsteileDerQuelle.Insert(6,
        '// einem Code. Versuchen Sie den Import danach nochmals.');
      OrtsteileDerQuelle.Insert(7, '// ');
      OrtsteileDerQuelle.SaveToFile(DiagnosePath + 'NeueOrtsteile.txt');
      ShowMessage('Es gibt Ortsteile, die noch nicht eingetragen sind!');
      openShell(DiagnosePath + 'NeueOrtsteile.txt');
      exit;
    end;

  end;

  // wow, eigentlicher Import startet hier
  screen.cursor := crHourGlass;
  Umsetzer := TStringList.create;
  InfoFile := TStringList.create;
  StrassenListeMitPlanquadrat := TSearchStringList.create;

  InfoFile.add('Benutzer ' + FormBearbeiter.sBearbeiterKurz + ' mit Rev. ' +
    RevToStr(globals.Version));
  InfoFile.add('Datum ' + datum);
  InfoFile.add('Uhr ' + uhr);
  InfoFile.add('Baustelle ' + inttostr(BAUSTELLE_R) + '=' + ComboBox6.Text);
  InfoFile.add(' Ortsteillogik [' + booltostr(Baustelle_Ortsteilcodes) + ']');
  InfoFile.add('doppelte ablehnen [' + booltostr(CheckBox1.checked) + ']');
  InfoFile.add('numerisch [' + booltostr(CheckBox13.checked) + ']');
  InfoFile.add('letzter Block [' + booltostr(CheckBox14.checked) + ']');
  InfoFile.add('nur simulieren [' + booltostr(CheckBox3.checked) + ']');

  ParameterError := false;

  Umsetzer.AddStrings(ListBox2.items);
  for n := 0 to pred(Umsetzer.count) do
  begin

    AllParameter := Umsetzer[n];
    AllParameter := copy(AllParameter, succ(pos('(', AllParameter)), MaxInt);
    delete(AllParameter, length(AllParameter), 1);

    // Umsetzer Nummer ermitteln!
    for m := 0 to high(cImportFields) do
      if pos(cImportFields[m] + '(', Umsetzer[n]) = 1 then
      begin
        Umsetzer[n] := inttostrN(m, 2) + ':' + Umsetzer[n];
        break;
      end;

    // Alle Parameter in eine Stringliste
    ParameterItems := TStringList.create;
    Umsetzer.objects[n] := ParameterItems;

    for m := 1 to 3 do
      ParameterItems.add(nextp(AllParameter, ','));
  end;

  if not(ParameterError) then
  begin
    ProgressBar1.max := ImportFile.count;
    IB_Query2.open;
    RID_AT_IMPORT := IB_Query2.Gen_ID('GEN_AUFTRAG', 1);
    ABNummer := e_r_AuftragNummer(BAUSTELLE_R) + 1;

    CheckCreateDir(ImportePath + inttostr(RID_AT_IMPORT));
    SaveSchema(ImportePath + inttostr(RID_AT_IMPORT) + '\Schema' +
      cSchemaExtension);
    ImportFile.SaveToFile(ImportePath + inttostr(RID_AT_IMPORT) + '\Daten.csv');

    Edit1.Text := inttostr(RID_AT_IMPORT);
    InfoFile.Insert(0, 'Import-RID: ' + Label13.Caption);
    Last_Import_RID := RID_AT_IMPORT;
    Button11.enabled := true;
    STime := 0;
    Anzahl_Zaehlwerk_0 := 0;
    Anzahl_Zaehlwerk_nicht_1 := 0;

    MoreTextInfo := TStringList.create;
    _ZaehlerMehrInfo := TStringList.create;
    _MonteurMehrInfo := TStringList.create;
    _InternMehrInfo := TStringList.create;

    Abgelehnte := TStringList.create;
    Importierte := TStringList.create;

    for m := 0 to pred(QuellHeaderLines) do
      Abgelehnte.add(ImportFile[m]);
    for m := 0 to pred(QuellHeaderLines) do
      Importierte.add(ImportFile[m]);

    InfoFile.add('Import-Quelle: ursprüngliche Anzahl ' + inttostr(OrgCount));
    InfoFile.add('Import-Quelle: doppelte Zählernummern ' +
      inttostr(DeleteCount));
    InfoFile.add('Import-Quelle: Anzahl reduziert auf ' +
      inttostr(ImportFile.count - QuellHeaderLines));
    _LastLocation := '!null!';

    ZaehlerNummernImBestand.add('### neue Nummern ###');

    // tatsächlicher Import
    with IB_Query2 do
      for n := QuellHeaderLines to pred(ImportFile.count) do
      begin

        // Ab jetzt kommt ein echter Datensatz!
        if assigned(SpaltenWerte_Primaer) then
          FreeAndNil(SpaltenWerte_Primaer);
        SpaltenWerte_Primaer := Split(ImportFile[n], QuellDelimiter, '"');

        if CheckBox12.checked then
          if (artA = '') then
            continue;

        if (Zaehlwerk_FieldIndex <> -1) then
        begin
          // Nur Zeilen mit Zaehlwerk=1 wird beachtet!!
          Zaehlwerk := strtointdef(sSpaltenWert(Zaehlwerk_FieldIndex), 0);
          if (Zaehlwerk = 0) then
            inc(Anzahl_Zaehlwerk_0);
          if (Zaehlwerk <> 1) then
          begin
            inc(Anzahl_Zaehlwerk_nicht_1);

            // für dieses Zählwerk die InternInfos erweitern
            qAUFTRAG := DataModuleDatenbank.nQuery;
            with qAUFTRAG do
            begin
              sql.add('SELECT INTERN_INFO FROM AUFTRAG WHERE RID=' +
                inttostr(AUFTRAG_R) + ' for update');
              open;
              first;
              edit;
              FieldByName('INTERN_INFO').assignto(_InternMehrInfo);
              for m := 0 to pred(Umsetzer.count) do
              begin
                UmsetzerNo := strtoint(copy(Umsetzer[m], 1, 2));
                if (UmsetzerNo = 39) then
                begin
                  ParameterItems := Umsetzer.objects[m] as TStringList;
                  _InternMehrInfo.add(cutblank(
                    { } ParameterItems[0] +
                    { } '.' + inttostr(Zaehlwerk) +
                    { } '=' +
                    { } rSpaltenWert(2)));
                end;
              end;
              FieldByName('INTERN_INFO').assign(_InternMehrInfo);
              post;
            end;
            qAUFTRAG.free;

            // ansonsten nix mehr machen
            continue;
          end;
        end;

        _ZaehlerMehrInfo.clear;
        _MonteurMehrInfo.clear;
        _InternMehrInfo.clear;

        Insert; // neue Auftragszeile!

        AUFTRAG_R := e_w_GEN('GEN_AUFTRAG');
        // setze Standards
        FieldByName('RID').AsInteger := AUFTRAG_R;
        FieldByName('PROTECT_RID').AsString := cC_True;
        FieldByName('BAUSTELLE_R').AsInteger := BAUSTELLE_R;
        FieldByName('RID_AT_IMPORT').AsInteger := RID_AT_IMPORT;
        FieldByName('EVENODD').AsString := cC_True;

        // jetzt die Feld-Umsetzer
        try
          for m := 0 to pred(Umsetzer.count) do
          begin
            UmsetzerNo := strtoint(copy(Umsetzer[m], 1, 2));
            ParameterItems := Umsetzer.objects[m] as TStringList;
            case UmsetzerNo of
              00:
                begin
                  // 'Art',
                  FieldByName('ART').AsString := rSpaltenWert(1);
                end;
              01:
                begin
                  // 'Zähler_Nummer',
                  _zaehler_nummer := FormatZaehlerNummer(rSpaltenWert(1));
                  FieldByName('ZAEHLER_NUMMER').AsString := _zaehler_nummer;
                end;
              02:
                begin
                  // 'Zähler_Ort_Name1',
                  FieldByName('KUNDE_NAME1').AsString := rSpaltenWert(1);
                end;
              03:
                begin
                  // 'Zähler_Ort_Name2',
                  FieldByName('KUNDE_NAME2').AsString := rSpaltenWert(1);
                end;
              04:
                begin
                  // 'Zähler_Ort_Strasse',
                  FieldByName('KUNDE_STRASSE').AsString := rSpaltenWert(1);
                end;
              05:
                begin
                  // 'Zähler_Ort_Strasse_#_#_#',
                  FieldByName('KUNDE_STRASSE').AsString :=
                    cutblank(cutblank(rSpaltenWert(1)) + ' ' + Format_HausNummer(rSpaltenWert(2)) +
                    Format_HausZusatz(rSpaltenWert(3)));
                end;
              06:
                begin
                  // 'Zähler_Ort_Ort',
                  FieldByName('KUNDE_ORT').AsString := rSpaltenWert(1);
                end;
              07:
                begin
                  // 'Zähler_Ort_Ort_#_#',
                  FieldByName('KUNDE_ORT').AsString := cutblank(rSpaltenWert(1)) +
                    ' ' + rSpaltenWert(2);
                end;
              08:
                begin
                  // 'Zähler_Info_#_#', // Konstante + Feld -> eine Zeile
                  if (ParameterItems[0] <> '') then
                  begin
                    if (strtointdef(ParameterItems[1], -1) = -1) then
                      _ZaehlerMehrInfo.add(ParameterItems[0] + '_' +
                        ParameterItems[1])
                    else
                      _ZaehlerMehrInfo.add(ParameterItems[0] + '_' + rSpaltenWert(2));
                  end
                  else
                  begin
                    if (rSpaltenWert(2) <> '') then
                      _ZaehlerMehrInfo.add(rSpaltenWert(2));
                  end;
                end;
              09:
                begin
                  // 'Zähler_Planquadrat',
                  _planquadrat := noblank(rSpaltenWert(1));
                  if (length(_planquadrat) < cAutoPlanquadratLength) then
                    _planquadrat :=
                      Fill('0', cAutoPlanquadratLength - length(_planquadrat)) +
                      _planquadrat;
                  FieldByName('PLANQUADRAT').AsString := _planquadrat;
                end;
              10:
                begin
                  // 'Kunde_Brief_Nummer',
                  FieldByName('KUNDE_NUMMER').AsString := rSpaltenWert(1);
                end;
              11:
                begin
                  // 'Kunde_Brief_Name1',
                  FieldByName('BRIEF_NAME1').AsString := rSpaltenWert(1);
                end;
              12:
                begin
                  // 'Kunde_Brief_Name2',
                  FieldByName('BRIEF_NAME2').AsString := rSpaltenWert(1);
                end;
              13:
                begin
                  // 'Kunde_Brief_Straße',
                  FieldByName('BRIEF_STRASSE').AsString := rSpaltenWert(1);
                end;
              14:
                begin
                  // 'Kunde_Brief_Ort',
                  FieldByName('BRIEF_ORT').AsString := rSpaltenWert(1);
                end;
              15:
                begin
                  // 'Kunde_Brief_Ort_#_#' );
                  FieldByName('BRIEF_ORT').AsString := cutblank(rSpaltenWert(1)) +
                    ' ' + rSpaltenWert(2);
                end;
              16:
                begin
                  // 'Monteur_Info_#_#'
                  if (ParameterItems[0] = '') then
                  begin
                    _Zeile := cutblank(rSpaltenWert(2));
                    while (_Zeile <> '') do
                      _MonteurMehrInfo.add(cutblank(nextp(_Zeile, '|')));
                  end
                  else
                  begin
                    _MonteurMehrInfo.add
                      (cutblank(ParameterItems[0] + '_' + rSpaltenWert(2)))
                  end;
                end;
              17:
                begin
                  // 'C_Art_Info'
                  FieldByName('ART').AsString := ParameterItems[0];
                end;
              18:
                begin
                  // 'C_Zähler_Ort_Info'
                  FieldByName('KUNDE_ORT').AsString := ParameterItems[0];
                end;
              19:
                begin
                  _Date := date2long(rSpaltenWert(1));
                  if DateOK(_Date) then
                    FieldByName('SPERRE_VON').AsDate := long2datetime(_Date);
                end;
              20:
                begin
                  _Date := date2long(rSpaltenWert(1));
                  if DateOK(_Date) then
                    FieldByName('SPERRE_BIS').AsDate := long2datetime(_Date);
                end;
              21:
                begin
                  FieldByName('BRIEF_STRASSE').AsString :=
                    cutblank(cutblank(rSpaltenWert(1)) + ' ' + Format_HausNummer(rSpaltenWert(2)) +
                    Format_HausZusatz(rSpaltenWert(3)));
                end;
              22:
                begin
                  // ''
                  FieldByName('BRIEF_NAME1').AsString := cutblank(rSpaltenWert(1)) +
                    ' ' + rSpaltenWert(2);
                end;
              23:
                begin
                  // ''
                  _InternMehrInfo.add
                    (cutblank(ParameterItems[0] + '_' + rSpaltenWert(2)));
                end;
              24:
                begin
                  FieldByName('KUNDE_ORTSTEIL').AsString := rSpaltenWert(1);
                end;
              25:
                begin
                  FieldByName('BRIEF_ORT').AsString := cutblank(rSpaltenWert(1)) + ' ' +
                    cutblank(rSpaltenWert(2)) + ' ' + rSpaltenWert(3);
                end;
              26:
                begin
                  FieldByName('PLANQUADRAT').AsString := rSpaltenWert(1) + rSpaltenWert(2);
                end;
              27:
                begin
                  Verbrauch_1_Datum := 0;
                  if DateOK(date2long(rSpaltenWert(1))) then
                  begin
                    Verbrauch_1_Datum := date2long(rSpaltenWert(1));
                    appendstringstofile
                      (rSpaltenWert(1) + ';' + inttostr(Verbrauch_1_Datum),
                      ImportePath + 'datums.txt');

                    FieldByName('VERBRAUCH_DATUM').AsDate :=
                      long2datetime(date2long(rSpaltenWert(1)));
                  end;
                end;
              28:
                begin
                  Verbrauch_1_Zaehler_Stand := strtoint64def(rSpaltenWert(1), -1);
                  FieldByName('VERBRAUCH_ZAEHLER_STAND').AsString :=
                    inttostr(Verbrauch_1_Zaehler_Stand);
                end;
              29:
                begin
                  FieldByName('VERBRAUCH_PRO_JAHR').AsString := rSpaltenWert(1);
                end;
              30:
                begin
                  FieldByName('REGLER_NR').AsString := rSpaltenWert(1);
                end;
              31:
                begin
                  MONTEUR_R := e_r_MonteurRIDFromKuerzel(ParameterItems[0]);
                  if (MONTEUR_R > 0) then
                    FieldByName('MONTEUR1_R').AsInteger := MONTEUR_R;
                end;
              32:
                begin
                  MONTEUR_R := e_r_MonteurRIDFromKuerzel(ParameterItems[0]);
                  if (MONTEUR_R > 0) then
                    FieldByName('MONTEUR2_R').AsInteger := MONTEUR_R;
                end;
              33:
                begin
                  // numerische Angabe?
                  MONTEUR_R := strtointdef(rSpaltenWert(1), cRID_Unset);
                  if MONTEUR_R < cRID_FirstValid then
                    // Kürzel angegeben?
                    MONTEUR_R := e_r_MonteurRIDFromKuerzel(rSpaltenWert(1));
                  if (MONTEUR_R >= cRID_FirstValid) then
                    FieldByName('MONTEUR1_R').AsInteger := MONTEUR_R;
                end;
              34:
                begin
                  MONTEUR_R := strtointdef(rSpaltenWert(1), cRID_Unset);
                  if MONTEUR_R < cRID_FirstValid then
                    MONTEUR_R := e_r_MonteurRIDFromKuerzel(rSpaltenWert(1));
                  if (MONTEUR_R >= cRID_FirstValid) then
                    FieldByName('MONTEUR2_R').AsInteger := MONTEUR_R;
                end;
              35:
                begin
                  r1AsString := noblank(AnsiUpperCase(rSpaltenWert(1)));
                  if r1AsString <> '' then
                    FieldByName('WORDEMPFAENGER').AsString := r1AsString;
                end;
              36:
                begin
                  // C_Zähler_Ort_Ortsteil
                  FieldByName('KUNDE_ORTSTEIL').AsString := ParameterItems[0];
                end;
              37:
                begin
                  // 'Verbrauch_0_Datum',
                  Verbrauch_0_Datum := 0;
                  if DateOK(date2long(rSpaltenWert(1))) then
                  begin
                    Verbrauch_0_Datum := date2long(rSpaltenWert(1));
                  end;
                end;
              38:
                begin
                  // 'Verbrauch_0_Zähler_Stand'
                  Verbrauch_0_Zaehler_Stand := strtoint64def(rSpaltenWert(1), -1);
                  //

                  if (Verbrauch_1_Zaehler_Stand > 0) then
                    if (Verbrauch_0_Zaehler_Stand > 0) then
                      if DateOK(Verbrauch_0_Datum) then
                        if DateOK(Verbrauch_1_Datum) then
                          if (Verbrauch_0_Datum < Verbrauch_1_Datum) then
                          begin
                            FieldByName('VERBRAUCH_PRO_JAHR').AsString :=
                              inttostr(round((Verbrauch_1_Zaehler_Stand -
                              Verbrauch_0_Zaehler_Stand) /
                              DateDiff(Verbrauch_0_Datum,
                              Verbrauch_1_Datum) * 365));
                          end;

                end;
              39: // SAP_Info_#_#
                begin

                  _InternMehrInfo.add
                    (cutblank(ParameterItems[0] + '=' + rSpaltenWert(2)));
                end;
              40: // SAP Art
                begin

                  _Art := SAP2art(rSpaltenWert(1));
                  _Zaehlwerke := 1;

                  SpaltenWerte_Sekundaer := nil;
                  for k := succ(n) to pred(ImportFile.count) do
                  begin

                    if assigned(SpaltenWerte_Sekundaer) then
                      FreeAndNil(SpaltenWerte_Sekundaer);
                    SpaltenWerte_Sekundaer := Split(ImportFile[k], QuellDelimiter, '"');

                    l := strtointdef(sSpaltenWert_Sekundaer(Zaehlwerk_FieldIndex), 0);

                    // weitere Zeilen müssen Werte >1 haben
                    if (l < 2) then
                      break;

                    // das grösste Zählwerk ermitteln!
                    if (l > _Zaehlwerke) then
                      _Zaehlwerke := l;

                    _ZaehlerNummer :=
                      FormatZaehlerNummer(sSpaltenWert_Sekundaer(ZaehlerNummer_FieldIndex));
                    if (_ZaehlerNummer <> _zaehler_nummer) then
                    begin
                      if (l = 2) then
                        FieldByName('REGLER_NR').AsString := _ZaehlerNummer
                      else
                        break;
                    end;

                  end;
                  if assigned(SpaltenWerte_Sekundaer) then
                    FreeAndNil(SpaltenWerte_Sekundaer);

                  // Zählwerk eintragen!
                  if (_Zaehlwerke > 1) then
                    _Art := _Art + inttostr(min(9, _Zaehlwerke));
                  FieldByName('ART').AsString := _Art;

                end;
              41:
                begin
                  FieldByName('ZAEHLER_STAND_ALT').AsString := rSpaltenWert(1);
                end;
              42:
                begin
                  FieldByName('ZAEHLER_STAND_NEU').AsString := rSpaltenWert(1);
                end;
              43:
                begin
                  FieldByName('KUNDE_NAME1').AsString :=
                    cutblank(cutblank(rSpaltenWert(1)) + ' ' + cutblank(rSpaltenWert(2)));
                end;
              44:
                begin
                  FieldByName('KUNDE_NAME2').AsString :=
                    cutblank(cutblank(rSpaltenWert(1)) + ' ' + cutblank(rSpaltenWert(2)));
                end;
              45:
                begin
                  _Date := date2long(rSpaltenWert(1));
                  if DateOK(_Date) then
                    FieldByName('ZEITRAUM_VON').AsDate := long2datetime(_Date);
                end;
              46:
                begin
                  _Date := date2long(rSpaltenWert(1));
                  if DateOK(_Date) then
                    FieldByName('ZEITRAUM_BIS').AsDate := long2datetime(_Date);
                end;
              47:
                begin
                  r1AsString := noblank(rSpaltenWert(1));
                  if (length(r1AsString) = 8) then
                    r1AsString := copy(r1AsString, 7, 2) + { TT }
                      copy(r1AsString, 5, 2) + { MM }
                      copy(r1AsString, 1, 4) { JJJJ }
                      ;
                  _Date := date2long(r1AsString);
                  if DateOK(_Date) then
                  begin
                    _Date1 := DatePlus(_Date,
                      -strtointdef(ParameterItems[1], 0));
                    _Date2 := DatePlus(_Date,
                      strtointdef(ParameterItems[2], 0));
                    FieldByName('ZEITRAUM_VON').AsDate := long2datetime(_Date1);
                    FieldByName('ZEITRAUM_BIS').AsDate := long2datetime(_Date2);
                  end;
                end;
              48:
                begin
                  r1AsString := noblank(rSpaltenWert(1));
                  if (length(r1AsString) = 8) then
                    r1AsString := copy(r1AsString, 7, 2) + { TT }
                      copy(r1AsString, 5, 2) + { MM }
                      copy(r1AsString, 1, 4) { JJJJ }
                      ;
                  _Date := date2long(r1AsString);
                  if DateOK(_Date) then
                  begin
                    _Date1 := DatePlus(_Date,
                      -strtointdef(ParameterItems[1], 0));
                    _Date2 := DatePlus(_Date,
                      strtointdef(ParameterItems[2], 0));
                    FieldByName('SPERRE_VON').AsDate := long2datetime(_Date1);
                    FieldByName('SPERRE_BIS').AsDate := long2datetime(_Date2);
                  end;
                end;
              49:
                begin
                  _Date := date_JJJJMMTT_2long(rSpaltenWert(1));
                  if DateOK(_Date) then
                    FieldByName('SPERRE_VON').AsDate := long2datetime(_Date);
                end;
              50:
                begin
                  _Date := date_JJJJMMTT_2long(rSpaltenWert(1));
                  if DateOK(_Date) then
                    FieldByName('SPERRE_BIS').AsDate := long2datetime(_Date);
                end;
              51:
                begin

                  // vorberechnete Plausi
                  readMinMax(1, rSpaltenWert(1), rSpaltenWert(2), rSpaltenWert(3));
                  _Zaehlwerke := 1;

                  SpaltenWerte_Sekundaer := nil;
                  for k := succ(n) to pred(ImportFile.count) do
                  begin
                    if assigned(SpaltenWerte_Sekundaer) then
                      FreeAndNil(SpaltenWerte_Sekundaer);
                    SpaltenWerte_Sekundaer := Split(ImportFile[k], QuellDelimiter, '"');

                    l := strtointdef(sSpaltenWert_Sekundaer(Zaehlwerk_FieldIndex), 0);
                    if (l > _Zaehlwerke) then
                    begin
                      readMinMax(l,
                        sSpaltenWert_Sekundaer(VorberechnetePlausibilitaetVon_FieldIndex),
                        sSpaltenWert_Sekundaer(VorberechnetePlausibilitaetBis_FieldIndex),
                        sSpaltenWert_Sekundaer(LetzterAblesestand_FieldIndex));
                      _Zaehlwerke := l;
                    end
                    else
                      break;
                  end;
                  if assigned(SpaltenWerte_Sekundaer) then
                    FreeAndNil(SpaltenWerte_Sekundaer);

                end;
              52:
                begin
                  // 'Strassen_erst_ungerade',
                  // Unterdrückung ausschalten!
                  FieldByName('EVENODD').AsString := cC_False;
                end;
              53:
                begin
                  // 'Nummer_Auto',
                  // +Fixe Vorgabe der Reihenfolge
                  FieldByName('NUMMER').AsInteger := ABNummer;
                  FieldByName('PLANQUADRAT').AsString := inttostrN(ABNummer, 5);
                  inc(ABNummer);
                end;
              54:
                begin
                  // {54}'Termin'
                  if (ParameterItems[0] = 'now') then
                    FieldByName('AUSFUEHREN').AsDate := now
                  else
                    FieldByName('AUSFUEHREN').AsDate :=
                      long2datetime(date2long(rSpaltenWert(1)));
                  FieldByName('VORMITTAGS').AsString := cVormittagsChar;
                end;
              55:
                begin
                  // {55}'Zusatzarbeiten'
                  SpaltenWerte_Sekundaer := nil;
                  for k := succ(n) to pred(ImportFile.count) do
                  begin

                    if assigned(SpaltenWerte_Sekundaer) then
                      FreeAndNil(SpaltenWerte_Sekundaer);
                    SpaltenWerte_Sekundaer := Split(ImportFile[k], QuellDelimiter, '"');

                    if artB <> '' then
                      break;

                    if (_MonteurMehrInfo.indexof(rSpaltenWert_Sekundaer(1)) = -1) then
                      _MonteurMehrInfo.add(rSpaltenWert_Sekundaer(1));

                  end;
                  if assigned(SpaltenWerte_Sekundaer) then
                    FreeAndNil(SpaltenWerte_Sekundaer);

                end;
              56:
                begin
                  // ''
                  _InternMehrInfo.add
                    (cutblank(ParameterItems[0] + '=' + ParameterItems[1]));
                end;
              57:
                begin
                  // die Angegebene Transaktion ausführen
                  if (Transaktionen.indexof(ParameterItems[0]) = -1) then
                    Transaktionen.add(ParameterItems[0]);
                end;

              58:
                begin
                  // 'Material_Nummer',
                  FieldByName('MATERIAL_NUMMER').AsString := rSpaltenWert(1);
                end;

            else
              // Fehler!
            end;
          end; // for Import-Tags do
        except
          ParameterError := true;
          InfoFile.add('Exception');
        end;

        // die Texte
        FieldByName('ZAEHLER_INFO').assign(_ZaehlerMehrInfo);
        FieldByName('MONTEUR_INFO').assign(_MonteurMehrInfo);
        FieldByName('INTERN_INFO').assign(_InternMehrInfo);

        //
        if (FieldByName('BRIEF_NAME1').AsString = '') and
          (FieldByName('BRIEF_NAME2').AsString = '') and
          (FieldByName('BRIEF_STRASSE').AsString = '') and
          (FieldByName('BRIEF_ORT').AsString = '') then
        begin
          FieldByName('BRIEF_NAME1').assign(FieldByName('KUNDE_NAME1'));
          FieldByName('BRIEF_NAME2').assign(FieldByName('KUNDE_NAME2'));
          FieldByName('BRIEF_STRASSE').assign(FieldByName('KUNDE_STRASSE'));
          FieldByName('BRIEF_ORT').assign(FieldByName('KUNDE_ORT'));
        end;

        repeat

          if CheckBox1.checked then
          begin
            // Detectierung der Zählernummern
            _ZaehlerNummer := FieldByName('ZAEHLER_NUMMER').AsString;
            if CheckBox5.checked then
              _ZaehlerNummer := e_r_Sparte(FieldByName('ART').AsString) + '~' +
                _ZaehlerNummer;

            if (ZaehlerNummernImBestand.indexof(_ZaehlerNummer) <> -1) then
            begin
              Abgelehnte.add(ImportFile[n]);
              cancel;
              break;
            end;
            ZaehlerNummernImBestand.add(_ZaehlerNummer);
          end;

          Importierte.add(ImportFile[n]);

          // Save it!
          if not(CheckBox3.checked) then // "simulation"
          begin
            AuftragBeforePost(IB_Query2);
            post;
          end
          else
          begin
            cancel;
          end;

        until true;

        if frequently(STime, 400) or (n = pred(ImportFile.count)) then
        begin
          ProgressBar1.position := n;
          application.processmessages;
        end;

      end; // for all the import line

    if CheckBox10.checked then
      FormAuftragArbeitsplatz.ClearMarkierte;
    if CheckBox9.checked then
      if (Importierte.count - QuellHeaderLines > 0) then
        FormAuftragArbeitsplatz.AddMarkierte_RID_AT_IMPORT(RID_AT_IMPORT);

    // Post-Transaktionen durchführen
    if (Transaktionen.count > 0) then
      if (Importierte.count - QuellHeaderLines > 0) then
      begin
        lImportierte := e_r_sqlm('select RID from AUFTRAG where (RID_AT_IMPORT='
          + inttostr(RID_AT_IMPORT) + ') and (RID=MASTER_R)');
        for n := 0 to pred(Transaktionen.count) do
        begin
          InfoFile.add('Transaktion "' + Transaktionen[n] + '"');
          Funktionen.Transaktion.Dispatch(Transaktionen[n], lImportierte);
        end;
        lImportierte.free;
      end;

    if assigned(SpaltenWerte_Primaer) then
      FreeAndNil(SpaltenWerte_Primaer);
    MoreTextInfo.free;
    _ZaehlerMehrInfo.free;
    _MonteurMehrInfo.free;
    _InternMehrInfo.free;

    InfoFile.add(cINFOText + 'Abgelehnte ' + inttostr(Abgelehnte.count -
      QuellHeaderLines));
    InfoFile.add('Importierte ' + inttostr(Importierte.count -
      QuellHeaderLines));
    InfoFile.add(cWARNINGText + 'Zählwerk_ist_"0" ' +
      inttostr(Anzahl_Zaehlwerk_0));
    InfoFile.add(cWARNINGText + 'Zählwerk_ist_nicht_"1" ' +
      inttostr(Anzahl_Zaehlwerk_nicht_1));

    InfoFile.SaveToFile(ImportePath + inttostr(RID_AT_IMPORT) + '\Info.txt');
    Abgelehnte.SaveToFile(ImportePath + inttostr(RID_AT_IMPORT) +
      '\Abgelehnte.csv');
    Importierte.SaveToFile(ImportePath + inttostr(RID_AT_IMPORT) +
      '\Importierte.csv');
    ZaehlerNummernImBestand.SaveToFile(ImportePath + inttostr(RID_AT_IMPORT) +
      '\ZaehlerNummern.txt');

    if (Abgelehnte.count > QuellHeaderLines) then
      ShowMessage('Es wurden ' + inttostr(Abgelehnte.count - QuellHeaderLines) +
        ' von ' + inttostr(Importierte.count + Abgelehnte.count -
        QuellHeaderLines - QuellHeaderLines) + ' Zählernummern abgelehnt!');
    if (Anzahl_Zaehlwerk_0 > 0) then
      ShowMessage(inttostr(Anzahl_Zaehlwerk_0) + ' Zeilen wurden überlesen ' +
        #13 + 'da die Spalte Zählwerk (angegeben im 2. Parameter der SAP_Art_#_#())'
        + #13 + 'leer ist, oder den Wert "0" hat.');

    if (Importierte.count - QuellHeaderLines) = 0 then
      openShell(ImportePath + inttostr(RID_AT_IMPORT) + '\Info.txt');

  end;
  for n := 0 to pred(Umsetzer.count) do
    Umsetzer.objects[n].free;
  FreeAndNil(Umsetzer);
  FreeAndNil(InfoFile);
  FreeAndNil(Abgelehnte);
  FreeAndNil(Importierte);
  FreeAndNil(ZaehlerNummernImBestand);
  FreeAndNil(OrtsteileDerQuelle);
  FreeAndNil(StrassenListeMitPlanquadrat);
  FreeAndNil(Transaktionen);

  ProgressBar1.position := 0;
  screen.cursor := crdefault;
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
  ShowMessage(inttostr(DeleteCount) + ' Doppelte' + #13 + inttostr(AllCount) +
    ' insgesamt!');
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
    if Index > 0 then
    begin
      items.exchange(Index, Index - 1);
      itemIndex := pred(Index);
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
