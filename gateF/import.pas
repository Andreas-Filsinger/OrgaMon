unit Import;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls;

type
  TFormImport = class(TForm)
    ComboBox1: TComboBox;
    Label2: TLabel;
    Button8: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Button10: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
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
    GroupBox2: TGroupBox;
    Label13: TLabel;
    ProgressBar1: TProgressBar;
    Button3: TButton;
    CheckBox2: TCheckBox;
    Button2: TButton;
    Timer1: TTimer;
    Label4: TLabel;
    ComboBox2: TComboBox;
    Button9: TButton;
    OpenDialog2: TOpenDialog;
    Label12: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Label15: TLabel;
    Edit1: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
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
    procedure ListBox1DblClick(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    RID_AT_IMPORT: integer;
    ImportFields: TStringList;
    ImportFile: TStringList;
    _l3_ItemIndex: integer;
    _l2_ItemIndex: integer;
    SchemaChanged: boolean;
    SchemaPath: string;
    RohstoffePath: string;
    iCSVOpenPath: string;
    procedure L3Changed;
    procedure L2Changed;
    procedure LoadImportFile;
    procedure SaveSchema(FName: string);
    procedure LoadSchema;
    procedure ReadParameter;
    function Execute(SchemaName: string): integer;
  end;

var
  FormImport: TFormImport;

implementation

uses
  globals, anfix32, wanfix32,
  math, wordindex, splash,
  IniFiles, FileCtrl;

{$R *.DFM}

const
  cSchemaExtension = '.ImportSchema';
  cImportFieldsAnz = 11;
  cImportFields: array[0..pred(cImportFieldsAnz)] of string = (
                                                  {00}'Nachname',
                                                  {01}'Vorname',
                                                  {02}'Gebäude',
                                                  {03}'Telefon Festnetz',
                                                  {04}'Telefon Mobilfunk',
                                                  {05}'eMail',
                                                  {06}'Filter A',
                                                  {07}'Filter B',
                                                  {08}'Filter C',
                                                  {09}'Firma',
                                                  {10}'Benutzerdefiniert A_#_#'
    );

procedure TFormImport.FormCreate(Sender: TObject);
var
  n: integer;
begin
  SchemaPath := MyProgramPath + 'ImportSchema\';
  RohstoffePath := MyProgramPath + 'ImportQuelle\';
  CheckCreateDir(SchemaPath);
  CheckCreateDir(RohstoffePath);
  ImportFields := TStringList.create;
  for n := 0 to high(cImportFields) do
    ImportFields.add(cImportFields[n]);
  Listbox1.items.assign(ImportFields);
  OpenDialog1.InitialDir := SchemaPath;
  SaveDialog1.InitialDir := SchemaPath;
  OpenDialog2.InitialDir := RohstoffePath;
  CheckCreateDir(SchemaPath);
  CheckCreateDir(RohstoffePath);
  ImportFile := TStringList.create;
  label2.caption := format(Label2.caption, [cSchemaExtension]);
end;

procedure TFormImport.Button9Click(Sender: TObject);
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

procedure TFormImport.Button8Click(Sender: TObject);
begin
  if OpenDialog1.execute then
  begin
    ComboBox1.Text := OpenDialog1.FileName;
    LoadSchema;
  end;
end;

procedure TFormImport.Button10Click(Sender: TObject);
begin
  if (ComboBox1.Text = '') or not (FileExists(ComboBox1.Text)) then
    ComboBox1.Text := SchemaPath + 'Unbenannt' + cSchemaExtension;
  SaveDialog1.FileName := ComBoBox1.Text;
  if SaveDialog1.Execute then
  begin
    ComBoBox1.Text := SaveDialog1.FileName;
    SaveSchema(Combobox1.Text);
  end;
end;

procedure TFormImport.LoadImportFile;
var
  SpalteNo: integer;
  OneLine: string;
begin
  if FileExists(ComboBox2.Text) then
  begin
    LoadFromFileCSV(true, ImportFile, ComboBox2.Text);
    if (ImportFile.count > 0) then
    begin
      ListBox3.Items.clear;
      OneLIne := ImportFile[0];
      SpalteNo := 0;
      while OneLine <> '' do
      begin
        inc(SpalteNo);
        ListBox3.items.add(inttostrN(SpalteNo, 2) + ':' + nextp(OneLine, ';'));
      end;

      // Caches
      _l3_ItemIndex := -1;
      Listbox4.items.clear;

      //
      label14.Caption := '(' + inttostr(pred(ImportFile.count)) + ' Datensätze / ' +
        inttostr(SpalteNo) + ' Spalten)';
    end else
    begin
      ShowMessage('Eine andere Anwendung sperrt diese Datei (Excel?!)!' + #13 +
        'Oder die Datei ist leer!');
    end;
  end;
end;

procedure TFormImport.Timer1Timer(Sender: TObject);
begin
  if not (active) then
    exit;
  if ListBox3.itemIndex <> _l3_ItemIndex then
    L3Changed;
  if ListBox2.itemIndex <> _l2_ItemIndex then
    L2Changed;
  Button4.enabled := listbox1.Itemindex <> -1;
  Button5.enabled := ComboBox3.Visible and (listbox3.ItemIndex <> -1);
  Button6.enabled := ComboBox4.Visible and (listbox3.ItemIndex <> -1);
  Button7.enabled := ComboBox5.Visible and (listbox3.ItemIndex <> -1);
  panel1.Visible := (listbox2.itemindex <> -1);
  label12.visible := SchemaChanged;
end;

procedure TFormImport.L3Changed;
var
  n: integer;
  ShowMAx: integer;
begin
  BeginHourGlass;
  _l3_ItemIndex := listbox3.ItemIndex;
  listbox4.items.clear;
  if Checkbox2.checked then
    ShowMax := MaxInt
  else
    ShowMax := 10;
  for n := 1 to min(pred(ImportFile.count), ShowMAx) do
    listbox4.Items.add(nextp(ImportFile[n], ';', _l3_ItemIndex));
  EndHourGlass;
end;

procedure TFormImport.L2Changed;
var
  TheParameter: string;
  ParamCount: integer;
begin
  _l2_ItemIndex := listbox2.ItemIndex;
  if listbox2.ItemIndex <> -1 then
  begin
    TheParameter := listbox2.Items[listbox2.ItemIndex];
    TheParameter := copy(TheParameter, succ(pos('(', TheParameter)), MAxInt);
    delete(TheParameter, length(TheParameter), 1);

    ParamCount := CharCount(',', TheParameter) + 1;

    combobox3.Text := nextp(TheParameter, ',');
    combobox4.Text := nextp(TheParameter, ',');
    combobox5.Text := nextp(TheParameter, ',');
    case ParamCount of
      0: begin
          combobox3.visible := false;
          combobox4.visible := false;
          combobox5.visible := false;
        end;
      1: begin
          combobox3.visible := true;
          combobox4.visible := false;
          combobox5.visible := false;
        end;
      2: begin
          combobox3.visible := true;
          combobox4.visible := true;
          combobox5.visible := false;
        end;
      3: begin
          combobox3.visible := true;
          combobox4.visible := true;
          combobox5.visible := true;
        end;
    end;
  end;
end;

procedure TFormImport.SaveSchema(FName: string);
var
  OutData: TStringList;
  n: integer;
begin
  OutData := TStringList.create;
  OutData.Add('[QUELLE]');
  OutData.add('load=' + ComboBox2.Text);
  OutData.Add('');

  OutData.Add('[FELD]');
  for n := 0 to pred(listbox2.count) do
    OutData.Add(inttostr(n) + '=' + Listbox2.items[n]);
  OutData.Add('');

  OutData.Add('[OUT]');
  for n := 0 to pred(memo1.Lines.count) do
    OutData.Add(inttostr(n) + '=' + memo1.lines[n]);
  OutData.Add('');

  OutData.add('[ERSATZ]');
  OutData.Add('0=' + edit1.Text);
  OutData.Add('');

  OutData.SaveToFile(FName);
  OutData.free;
  if (FName = ComboBox1.Text) then
    SchemaChanged := false;
end;

procedure TFormImport.LoadSchema;
var
  InData: TIniFile;
  AllData: TStringList;
  n: integer;
begin
  screen.cursor := crHourGlass;

  // clear data
  ComboBox2.Text := '';
  listbox2.items.clear;
  memo1.Lines.Clear;
  edit1.Text := '';

  // load data
  AllData := TStringList.create;
  if FileExists(Combobox1.TExt) then
  begin
    InData := TIniFile.Create(Combobox1.TExt);
    with InData do
    begin

      // FileName
      Combobox2.Text := ReadString('QUELLE', 'load', '');

      // felder
      ReadSectionValues('FELD', AllData);
      for n := 0 to pred(AllData.Count) do
        listbox2.items.add(nextp(AllData[n], '=', 1));

      // OUT
      ReadSectionValues('OUT', AllData);
      for n := 0 to pred(AllData.Count) do
        memo1.lines.add(nextp(AllData[n], '=', 1));

      // ERSATZ
      edit1.Text := ReadString('ERSATZ', '0', '');
    end;
    InData.Free;
  end;
  AllData.Free;

  // load the import file itself
  LoadImportFile;
  screen.cursor := crdefault;

  // ifdef gatef
  edit1.Text := iMitarbeiterOrtUmsetzer;
  edit1.Enabled := false;
  // endif
   SchemaChanged := false;
end;

procedure TFormImport.ListBox2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_DELETE: if listbox2.ItemIndex <> -1 then
        if doit('Zuordnung ' + listbox2.items[listbox2.itemindex] + ' löschen') then
        begin
          listbox2.items.delete(listbox2.Itemindex);
          SchemaChanged := true;
        end;
  end;
end;

procedure TFormImport.Button4Click(Sender: TObject);
var
  NewLine: string;
  AlreadyThere: boolean;
  n: integer;
begin
  if (listbox1.itemindex <> -1) then
  begin
    NewLine := listbox1.items[listbox1.ItemIndex];
    AlreadyThere := false;
    if pos('_Info_#', NewLine) = 0 then
      for n := 0 to pred(listbox2.items.count) do
        if pos(NewLine + '(', listbox2.items[n]) = 1 then
          AlreadyThere := true;
    if not (AlreadyThere) then
    begin
      SchemaChanged := true;
      listbox2.Items.add(NewLine + '(' +
        Fill(',', max(0, pred(CharCount('#', NewLine)))) +
        ')');
    end else
      ShowMessage('Zuordnung bereits vorhanden!');
  end;
end;

procedure TFormImport.Button5Click(Sender: TObject);
begin
  if (Listbox2.itemindex <> -1) then
    if (listbox3.itemindex <> -1) and (ComboBox3.visible) then
    begin
      combobox3.Text := copy(Listbox3.items[listbox3.itemindex],
        1,
        pred(pos(':', Listbox3.items[listbox3.itemindex])));
      ReadParameter;
    end;
end;

procedure TFormImport.Button6Click(Sender: TObject);
begin
  if (Listbox2.itemindex <> -1) then
    if (listbox3.itemindex <> -1) and (ComboBox4.visible) then
    begin
      combobox4.Text := copy(Listbox3.items[listbox3.itemindex],
        1,
        pred(pos(':', Listbox3.items[listbox3.itemindex])));

      ReadParameter;
    end;
end;

procedure TFormImport.Button7Click(Sender: TObject);
begin
  if (Listbox2.itemindex <> -1) then
    if (listbox3.itemindex <> -1) and (ComboBox5.visible) then
    begin
      combobox5.Text := copy(Listbox3.items[listbox3.itemindex],
        1,
        pred(pos(':', Listbox3.items[listbox3.itemindex])));

      ReadParameter;
    end;
end;

procedure TFormImport.ReadParameter;
var
  NewValue: string;
begin
  if listbox2.ItemIndex <> -1 then
  begin
    NewValue := listbox2.items[listbox2.ItemIndex];
    NewValue := copy(NewValue, 1, pos('(', NewValue));

    if ComboBox3.Visible then
      NewValue := NewValue + ComboBox3.Text;

    if ComboBox4.Visible then
      NewValue := NewValue + ',' + ComboBox4.Text;

    if ComboBox5.Visible then
      NewValue := NewValue + ',' + ComboBox5.Text;

    NewValue := NewValue + ')';

    if NewValue <> listbox2.items[listbox2.ItemIndex] then
    begin
      listbox2.items[listbox2.ItemIndex] := NewValue;
      SchemaChanged := true;
    end;

  end;
end;

procedure TFormImport.ComboBox3Change(Sender: TObject);
begin
  ReadParameter;
end;

procedure TFormImport.ComboBox4Change(Sender: TObject);
begin
  ReadParameter;
end;

procedure TFormImport.ComboBox5Change(Sender: TObject);
begin
  ReadParameter;
end;

procedure TFormImport.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    close;
  end;
end;

procedure TFormImport.Button3Click(Sender: TObject);
var
  InpStr: string;
  n, m, k: integer;
  STime: dword;

  MoreTextInfo: TStringList;
  OutStrList: TStringList;
  OutData: TStringList;

  ThisDate: TANFiXDate;
  SubItems: TStringList;
  SubItemIndex: integer;
  Umsetzer: TStringList;
  InfoFile: TStringList;
  ParameterItems: TStringList;
  AllParameter: string;
  UmsetzerNo: integer;
  ParameterError: boolean;
  _Date: TANFiXDate;

  AllCount: integer;

  Abgelehnte: TStringList;
  Importierte: TStringList;
  DoNotTakeIt: boolean;
  FilterColumns: array of integer;
  FilterColumnsCount: integer;

  function r(n: byte): string;
  var
    FieldID: integer;
  begin
    FieldID := strtol(ParameterItems[pred(n)]);
    if (FieldID > 0) and (FieldID < SubItems.count) then
      result := SubItems[pred(FieldID)]
    else
      result := '';
  end;

  function p(n: byte): string;
  begin
   result := ParameterItems[pred(n)];
  end;

  function FilterTreffer(s: string): boolean;
  var
    n: integer;
  begin
    result := false;
    for n := 0 to pred(memo1.lines.count) do
      if pos(s, memo1.Lines[n]) > 0 then
      begin
        result := true;
        break;
      end;
  end;

begin

  screen.cursor := crHourGlass;
  Umsetzer := TStringList.create;
  InfoFile := TStringList.create;

  InfoFile.add('Datum ' + datum);
  InfoFile.add('Uhr ' + uhr);

  ParameterError := false;

  Umsetzer.addstrings(listbox2.items);
  FilterColumnsCount := 0;
  for n := 0 to pred(Umsetzer.count) do
  begin

    // Parameter ohne Klammer extrahieren
    AllParameter := Umsetzer[n];
    AllParameter := copy(AllParameter, succ(Pos('(', AllParameter)), MaxInt);
    delete(AllParameter, length(AllParameter), 1);

    // Umsetzer Nummer ermitteln!
    for m := 0 to high(cImportFields) do
      if pos(cImportFields[m] + '(', Umsetzer[n]) = 1 then
      begin
        if pos('Filter', Umsetzer[n]) = 1 then
        begin
          inc(FilterColumnsCount);
          SetLength(FilterColumns, FilterColumnsCount);
          FilterColumns[pred(FilterColumnsCount)] := m;
        end;
        Umsetzer[n] := inttostrN(m, 2) + ':' + Umsetzer[n];
        break;
      end;

  // Alle Parameter in eine Stringliste
    ParameterItems := TStringList.create;
    Umsetzer.objects[n] := ParameterItems;
    for m := 1 to 3 do
      ParameterItems.add(nextp(AllParameter, ','));

  end;

  if not (ParameterError) then
  begin
    progressbar1.Max := ImportFile.count;
    RID_AT_IMPORT := NewTrn;

    DirDelete(ImportePath + '*', 5);
    CheckCreateDir(ImportePath + inttostr(RID_AT_IMPORT));
    SaveSchema(ImportePath + inttostr(RID_AT_IMPORT) + '\Schema' + cSchemaExtension);
    ImportFile.SaveToFile(ImportePath + inttostr(RID_AT_IMPORT) + '\Daten.csv');

    label13.caption := 'Import-RID: ' + inttostr(RID_AT_IMPORT);
    MoreTextInfo := TStringList.create;
    SubItems := TStringList.create;
    Abgelehnte := TStringList.create;
    Importierte := TStringList.create;
    OutStrList := TStringList.create;
    OutData := TStringList.create;

    OutData.add(HugeSingleLine(listbox1.Items, ';'));

    if ImportFile.count>0 then
    begin
    Abgelehnte.add(ImportFile[0]);
    Importierte.add(ImportFile[0]);
    end;

    InfoFile.add('Anz ' + inttostr(pred(ImportFile.count)));
    STime := 0;
    for n := 0 to pred(ImportFile.count) do
    begin
      InpStr := ImportFile[n];

      // Alle Felder einlesen!
      SubItems.Clear;
      while (inpStr <> '') do
        SubItems.add(cutblank(Nextp(InpStr, ';')));

      OutStrList.clear;
      for m := 0 to pred(cImportFieldsAnz) do
        OutStrList.add('');

      // jetzt die Feld-Umsetzer
      try
        for m := 0 to pred(Umsetzer.count) do
        begin
          UmsetzerNo := strtoint(copy(Umsetzer[m], 1, 2));
          ParameterItems := Umsetzer.Objects[m] as TStringList;
          if (UmsetzerNo < cImportFieldsAnz) then
          begin
           case UmsetzerNo of
            10: if r(1)=p(2) then
                 OutStrList[02] := OutStrList[09];
           else
            OutStrList[UmsetzerNo] := r(1);
           end;
          end;
        end;
      except
        InfoFile.add('Exception');
      end;

      // filter prüfen!
      DoNotTakeIt := false;
      for m := 0 to high(FilterColumns) do
        if FilterTreffer(OutStrList[FilterColumns[m]]) then
        begin
          DoNotTakeIt := true;
          break;
        end;

      if DoNotTakeIt then
      begin
        Abgelehnte.add(ImportFile[n]);
      end else
      begin
        Importierte.add(ImportFile[n]);
        OutData.add(HugeSingleLine(OutStrList, ';'));
      end;

      if frequently(STime, 400) or (n = pred(ImportFile.count)) then
      begin
        progressbar1.position := n;
        application.processmessages;
      end;

    end;
    MoreTextInfo.free;
    FreeAndNil(SubItems);
    FreeAndNil(OutStrList);

    InfoFile.add('Abgelehnte ' + inttostr(pred(Abgelehnte.count)));
    InfoFile.add('Importierte ' + inttostr(pred(Importierte.count)));

    InfoFile.SaveToFile(ImportePath + inttostr(RID_AT_IMPORT) + '\Info.txt');
    Abgelehnte.SaveToFile(ImportePath + inttostr(RID_AT_IMPORT) + '\Abgelehnte.csv');
    Importierte.SaveToFile(ImportePath + inttostr(RID_AT_IMPORT) + '\Importierte.csv');
    OutData.SaveToFile(ImportePath + inttostr(RID_AT_IMPORT) + '\Resultat.csv');

    FreeAndNil(Abgelehnte);
    FreeAndNil(Importierte);
    FreeAndNil(OutData);
  end;
  for n := 0 to pred(Umsetzer.count) do
    Umsetzer.objects[n].free;
  FreeAndNil(Umsetzer);
  FreeAndNil(InfoFile);

  progressbar1.position := 0;
  screen.cursor := crdefault;
  close;
end;

(*
var
 AllData        : TStringList;
 InpStr         : string;
 n              : integer;
 STime          : dword;

 _Monteur_r     : integer;
 _Monteur       : string;
 _Nummer        : string;

 _Name          : string;
 _Strasse       : string;
 _HausNummer    : string;

 _plz           : string;
 _ort           : string;

 _ZaehlerMehrInfo : TStringList;
 _MonteurMehrInfo : TStringList;
 _ZaehlerTyp      : string;
 MoreTextInfo     : TStringList;

 _Verbraucher_r : integer;
 ThisDate       : TANFiXDate;
 screen.cursor    := crHourGlass;
 MoreTextInfo     := TStringList.create;
 _ZaehlerMehrInfo := TStringList.create;
  _MonteurMehrInfo := TStringList.create;


 IB_Query2.Open;
 AllData := TStringList.create;
 LoadFromFileCSV(false,AllData,MyPRogramPath+'Rohstoffe\KA01.csv');
 progressbar1.Max := AllData.count;
 STime := 0;
 for n := 1 to pred(AllData.count) do
 begin

  InpStr := AllData[n];
  if frequently(STime,400) then
  begin
   progressbar1.position := n;
   application.processmessages;
  end;


  // AB-Nummer
  nextp(InpStr,';');
  // Monteur
  nextp(InpStr,';');

  //
  _ZaehlerTyp := Nextp(InpStr,';');
  if (_ZaehlerTyp<>'W') and (_ZaehlerTyp<>'G') then
   continue;

  _ZaehlerMehrInfo.clear;
  _ZaehlerMehrInfo.add ('Typ_'+_ZaehlerTyp);


  IB_Query2.insert; // Auftragszeile!

  IB_Query2.FieldByName('ART').AsString := _ZaehlerTyp;
  IB_Query2.FieldByName('RID').AsInteger := 0;
  IB_Query2.FieldByName('BAUSTELLE_R').AsInteger := strtoint(edit1.Text);

  // Z-Nummer
  IB_Query2.FieldByName('ZAEHLER_NUMMER').AsString := NextP(InpStr,';');

  // K-Nummer (Verbraucher)
  IB_Query2.FieldByName('KUNDE_NUMMER').AsString := Nextp(Inpstr,';');

  IB_Query2.FieldByName('KUNDE_NAME1').AsString := Nextp(Inpstr,';');
  IB_Query2.FieldByName('KUNDE_NAME2').AsString := Nextp(Inpstr,';');
  IB_Query2.FieldByName('KUNDE_STRASSE').AsString := Nextp(Inpstr,';');
  _plz := nextp(InpStr,';');
  IB_Query2.FieldByName('KUNDE_ORT').AsString := _plz+ ' ' + Nextp(Inpstr,';');

  // Zähler-Anschrift
  IB_Query2.FieldByName('BRIEF_NAME1').AsString := Nextp(Inpstr,';');
  IB_Query2.FieldByName('BRIEF_NAME2').AsString := Nextp(Inpstr,';');
  IB_Query2.FieldByName('BRIEF_STRASSE').AsString := Nextp(Inpstr,';');

  nextp(InpStr,';'); // Tag
  nextp(InpStr,';'); // Datum
  nextp(InpStr,';'); // Zeit

  // Zähler-standort;
  if pos(';',InpStr)>1 then
   _ZaehlerMehrInfo.add ( 'Standort_'+Nextp(Inpstr,';'))
  else
   Nextp(Inpstr,';');

  // Zähler-Art;
  if pos(';',InpStr)>1 then
   _ZaehlerMehrInfo.add ( 'Art_'+Nextp(Inpstr,';'))
  else
   Nextp(Inpstr,';');

  // Zähler-Größe;
  if pos(';',InpStr)>1 then
   _ZaehlerMehrInfo.add ( 'Größe_'+Nextp(Inpstr,';'))
  else
   Nextp(Inpstr,';');
  // NW;
  if pos(';',InpStr)>1 then
   _ZaehlerMehrInfo.add ( 'NW_'+Nextp(Inpstr,';'))
  else
   Nextp(Inpstr,';');
  // Ausbau-Grund;
  if pos(';',InpStr)>1 then
   _ZaehlerMehrInfo.add ( 'Grund_'+Nextp(Inpstr,';'))
  else
   Nextp(Inpstr,';');
  // Zusatzgerät-Begriff-Regler-Nr. [Ausbau Gas];
  if pos(';',InpStr)>1 then
   _ZaehlerMehrInfo.add ( 'Zusatzgerät-Begriff-Regler-Nr.-[Ausbau-Gas]_'+Nextp(Inpstr,';'))
  else
   Nextp(Inpstr,';');
  // Ablese-Bezirk;
  if pos(';',InpStr)>1 then
   _ZaehlerMehrInfo.add ( 'Bezirk_'+Nextp(Inpstr,';'))
  else
   Nextp(Inpstr,';');

  // Tage-Werk;
  IB_Query2.FieldByName('PLANQUADRAT').AsString := Nextp(Inpstr,';');

  // Beglaubig-ungs-Beginn;
  if pos(';',InpStr)>1 then
   _ZaehlerMehrInfo.add ('Beglaubig-ungs-Beginn_'+Nextp(Inpstr,';'))
  else
   Nextp(Inpstr,';');
  // Beglaubig-ungs-Ende;
  if pos(';',InpStr)>1 then
   _ZaehlerMehrInfo.add ('Beglaubig-ungs-Ende_'+Nextp(Inpstr,';'))
  else
   Nextp(Inpstr,';');
  // Zähler-/Zusatz-Begriff-Nebenzähler [Ausbau Wasser]
  if pos(';',InpStr)>1 then
   _ZaehlerMehrInfo.add ('Zähler-/Zusatz-Begriff-Nebenzähler-[Ausbau-Wasser]_'+Nextp(Inpstr,';'))
  else
   Nextp(Inpstr,';');

  IB_query2.FieldByName('ZAEHLER_INFO').Assign(_ZaehlerMehrInfo);

 DataModuleGaZMa.AuftragBeforePost(IB_Query2);

  IB_Query2.Post;
 end;
 progressbar1.position := 0;
 AllData.Free;
 screen.cursor := crdefault;
 MoreTextInfo.free;
 close;

*)

procedure TFormImport.Button2Click(Sender: TObject);
var
  AllTheLines: TStringList;
  MoreInfo: TWordIndex;
  n: integer;
  DeleteCount: integer;
  AllCount: integer;
  OneStr: string;
begin
  //
  AllCount := Listbox4.items.count;
  AllTheLines := TStringList.create;
  for n := 0 to pred(Listbox4.items.count) do
  begin
    OneStr := Listbox4.Items[n];
    ersetze(' ', '_', OneStr);
    AllTheLines.addobject(OneStr, TObject(n));
  end;

  //
  MoreInfo := TWordIndex.create(AllTheLines, 1);
  MoreInfo.saveToDiagFile(MyProgramPath + 'Diagnose doppelte.txt', 2, MaxInt);
  AllTheLines.sort;
  RemoveDuplicates(AllTheLines, DeleteCount);
  ShowMessage(inttostr(DeleteCount) + ' Doppelte' + #13 +
    inttostr(AllCount) + ' insgesamt!');
  if (DeleteCount > 0) then
    openShell(MyProgramPath + 'Diagnose doppelte.txt');
  MoreInfo.free;
  AllTheLines.free;
end;

procedure TFormImport.CheckBox2Click(Sender: TObject);
begin
  L3Changed;
end;

procedure TFormImport.ListBox1DblClick(Sender: TObject);
begin
  Button4Click(Sender);
end;

procedure TFormImport.Memo1Change(Sender: TObject);
begin
  SchemaChanged := true;
end;

procedure TFormImport.Edit1Change(Sender: TObject);
begin
  SchemaChanged := true;
end;

procedure TFormImport.ComboBox2Change(Sender: TObject);
begin
  SchemaChanged := true;
end;

function TFormImport.Execute(SchemaName: string): integer;
begin

  // laden
  RID_AT_IMPORT := -1;
  ComboBox1.Text := SchemaPath + SchemaName + cSchemaExtension;
  LoadSchema;

  // ausführen
  Button3Click(self);

  // Ergebnis zurückliefern!
  result := RID_AT_IMPORT;

end;

end.
