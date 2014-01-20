unit SQLExecuter;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,

  // IB-Objects
  IB_Components,
  IB_Process,
  IB_Script,
  IB_Dialogs,
  IB_MetaData,

  HebuData,

  // SynEdit
  SynEdit, SynMemo, SynEditHighlighter,
  SynHighlighterSQL, SynEditExport, SynExportHTML,

  // Borland
  IBServices, ComCtrls, ExtCtrls,

  // ANFiX
  gplists;

type
  TFormSQLExecuter = class(TForm)
    IB_ScriptDialog1: TIB_ScriptDialog;
    IB_BrowseDialog1: TIB_BrowseDialog;
    IB_Query1: TIB_Query;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label2: TLabel;
    ListBox1: TListBox;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Button3: TButton;
    CheckBox1: TCheckBox;
    Label4: TLabel;
    Button4: TButton;
    IB_Script1: TIB_Script;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    ListBox2: TListBox;
    Button5: TButton;
    CheckBox5: TCheckBox;
    TabSheet2: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    Label5: TLabel;
    Label6: TLabel;
    IB_Query2: TIB_Query;
    TabSheet3: TTabSheet;
    IB_Metadata1: TIB_Metadata;
    SynSQLSyn1: TSynSQLSyn;
    TabSheet4: TTabSheet;
    SynMemo1: TSynMemo;
    Button12: TButton;
    SynExporterHTML1: TSynExporterHTML;
    Label7: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Button13: TButton;
    TabSheet5: TTabSheet;
    Edit7: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Button14: TButton;
    Button15: TButton;
    Label10: TLabel;
    Label11: TLabel;
    Edit8: TEdit;
    Edit9: TEdit;
    Label12: TLabel;
    IBServerProperties1: TIBServerProperties;
    CheckBox7: TCheckBox;
    Timer1: TTimer;
    CheckBox8: TCheckBox;
    Label3: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Label13: TLabel;
    Button6: TButton;
    Label14: TLabel;
    ProgressBar1: TProgressBar;
    Button7: TButton;
    OpenDialog1: TOpenDialog;
    Label15: TLabel;
    RadioButton4: TRadioButton;
    Label16: TLabel;
    ListBox3: TListBox;
    Label17: TLabel;
    TabSheet6: TTabSheet;
    Button8: TButton;
    Label18: TLabel;
    procedure CheckBox8Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    lTRN: TIntegerList;
  public
    { Public-Deklarationen }
    function MetaDataFName: string;
  end;

var
  FormSQLExecuter: TFormSQLExecuter;

implementation

uses
  globals, anfix32, eCommerce,
  math, Belege, SolidFTP,
  BaseUpdate, Caching;

{$R *.DFM}

function ClearIndexName(s: string): string;
begin
  result := nextp(s, '.', 1);
end;

procedure TFormSQLExecuter.Button1Click(Sender: TObject);
begin
  IB_ScriptDialog1.execute;
end;

procedure TFormSQLExecuter.Button2Click(Sender: TObject);
begin
  IB_BrowseDialog1.execute;
end;

procedure TFormSQLExecuter.FormActivate(Sender: TObject);
begin
  DataModuleHeBu.IB_connection1.open;
end;

procedure TFormSQLExecuter.FormCreate(Sender: TObject);
begin
 PageControl1.ActivePage := TabSheet1;
end;

procedure TFormSQLExecuter.Button3Click(Sender: TObject);
var
  AllTheRIDs: TStringList;
  DuplettenCount: integer;
  ErrorCount: integer;
begin
  BeginHourGlass;
  listbox1.Items.Clear;
  AllTheRIDs := TStringList.create;
  with IB_Query1 do
  begin
    sql.clear;
    sql.add('SELECT ' + edit4.Text);
    sql.add('FROM ' + edit3.Text);
    listbox1.Items.addstrings(sql);
    Open;
    first;
    while not (eof) do
    begin
      AllTheRIDs.Add(FieldByName(Edit4.Text).AsString);
      next;
    end;
    Close;
    AllTheRIDs.Sort;
    AllTheRIDs.Sorted := true;
    removeduplicates(AllTheRIDs, DuplettenCount);
    if DuplettenCount > 0 then
    begin
      ShowMessage('Ziel ist nicht eindeutig!');
      exit;
    end;
    SQL.clear;
    SQL.add('SELECT ' + edit2.Text);
    SQL.add('FROM ' + edit1.Text);
    SQL.add('WHERE ' + edit2.Text + ' IS NOT NULL');
    sql.add('FOR UPDATE');
    listbox1.Items.addstrings(sql);
    open;
    ErrorCount := 0;
    first;
    while not (eof) do
    begin
      if (AllTheRIDs.indexof(FieldByName(edit2.Text).AsString) = -1) then
      begin
        if (ErrorCount = 0) then
          listbox1.Items.Clear;
        listbox1.Items.add(FieldByName(edit2.Text).AsString + '? ');
        inc(ErrorCount);
        if CheckBox1.Checked then
        begin
          if CheckBox5.Checked then // Tdataset
          begin
            delete;
          end else
          begin
            edit;
            FieldByName(edit2.Text).Clear;
            post;
          end;
        end;
      end;
      next;
    end;
    close;
  end;
  AllTheRIDs.assign(listbox1.Items);
  AllTheRIDs.Sort;
  AllTheRIDs.SaveToFile(DiagnosePath + edit1.Text + '-' + edit2.text + '.txt');
  AllTheRIDs.free;
  EndHourGlass;
  label2.caption := inttostr(ErrorCount) + ' Fehler!';
end;

procedure TFormSQLExecuter.Button4Click(Sender: TObject);
var
  AllTheLines: TStringList;
  n, k: integer;
  IndexName: string;
begin
  // alle indizes ermitteln
  BeginHourGlass;
  label2.caption := 'läuft ...';
  Button4.Enabled := false;
  listbox1.Items.clear;
  listbox2.Items.clear;
 {
  AllTheLines := TStringList.create;
  AllTheLines.LoadFromFile(LogDir+'out.txt');
  for n := 0 to pred(AllTheLines.count) do
  begin
    k := pos('restoring index ', AllTheLines[n]);
    if (k > 0) then
    begin
      IndexName := copy(AllTheLines[n], k + length('restoring index '), MaxInt);
      listbox1.Items.add(IndexName);
    end;
  end;
  AllTheLines.Free;
 }
  with IB_Query2 do
  begin
    Open;
    refresh;
    while not (eof) do
    begin
      listbox1.items.add(FieldByName('RDB$RELATION_NAME').AsString + '.' +
        FieldByName('RDB$INDEX_NAME').AsString
                          {
                          + ' ' +
                          FieldByName('RDB$FIELD_NAME').AsString
                          }

        );
      next;
    end;
    Close;
  end;
  IB_query2.Open;

  // alle Primary Keys aktivieren
  for n := 0 to pred(listbox1.Items.count) do
  begin

    if pos('RDB$PRIMARY', listbox1.Items[n]) > 0 then
    begin
      IB_Script1.SQL.Clear;
      IB_Script1.SQL.Add('alter index ' + ClearIndexName(listbox1.Items[n]) + ' active;');
      try
        if CheckBox2.Checked then
        begin
          listbox1.ItemIndex := n;
          application.ProcessMessages;
          IB_script1.Execute;
        end;
      except
        beep;
        listbox2.Items.add(listbox1.Items[n]);
      end;
      continue;
    end;

    if pos('RDB$FOREIGN', listbox1.Items[n]) > 0 then
    begin
      IB_Script1.SQL.Clear;
      IB_Script1.SQL.Add('alter index ' + ClearIndexName(listbox1.Items[n]) + ' active;');
      try
        if CheckBox3.Checked then
        begin
          listbox1.ItemIndex := n;
          application.ProcessMessages;
          IB_script1.Execute;
        end;
      except
        beep;
        listbox2.Items.add(listbox1.Items[n]);
      end;
      continue;
    end else
    begin
      IB_Script1.SQL.Clear;
      IB_Script1.SQL.Add('alter index ' + ClearIndexName(listbox1.Items[n]) + ' active;');
      try
        if CheckBox4.Checked then
        begin
          listbox1.ItemIndex := n;
          application.ProcessMessages;
          IB_script1.Execute;
        end;
      except
        beep;
        listbox2.Items.add(listbox1.Items[n]);
      end;
      continue;
    end;

  end;
  Button4.Enabled := true;
  label2.caption := 'inaktive Indizes';

  //
  EndHourGlass;

end;

procedure TFormSQLExecuter.Button5Click(Sender: TObject);
begin
  BeginHourGlass;
  if listbox1.itemindex <> -1 then
  begin
    IB_Script1.SQL.Clear;
    IB_Script1.SQL.Add('alter index ' + ClearIndexName(listbox1.Items[listbox1.itemindex]) + ' active;');
    try
      IB_script1.Execute;
    except
      beep;
      listbox2.Items.add(listbox1.Items[listbox1.itemindex]);
    end;
  end;
  EndHourGlass;
end;

procedure TFormSQLExecuter.Button6Click(Sender: TObject);
var
  ImportL: TStringList;
  n: integer;
  RID: integer;
  _RID: string;
  ErrorLogMode: boolean;
begin
  OpenDialog1.InitialDir := MyProgramPath;
  if OpenDialog1.execute then
  begin
    BeginHourGlass;

    if not (assigned(lTRN)) then
      lTRN := TIntegerList.create
    else
      lTRN.Clear;


    ImportL := TStringList.create;
    LoadFromFileCSV(false, ImportL, OpenDialog1.FileName);
    ErrorLogMode := false;
    for n := 0 to pred(ImportL.count) do
      if (pos('(RID=', ImportL[n]) > 0) then
      begin
        ErrorLogMode := true;
        break;
      end;
    for n := 0 to pred(ImportL.count) do
    begin
      if ErrorLogMode then
        _RID := ExtractSegmentBetween(ImportL[n], '(RID=', ')')
      else
        _RID := StrFilter(nextp(ImportL[n], ';', 0), '0123456789');
      if (_RID <> '') then
      begin
        RID := strtointdef(_RID, -1);
        if (RID > 0) and (lTRN.indexof(RID) = -1) then
          lTRN.add(RID);
      end;
    end;
    ImportL.free;
    label16.caption := inttostr(lTRN.count);
    EndHourGlass;
  end;

end;

procedure TFormSQLExecuter.Button7Click(Sender: TObject);
const
  xMode_PERSON_DEL = 1;
  xMode_ARTIKEL_DEL = 2;
  xMode_BELEGE_DEL = 3;
  xMode_ORDER_DEL = 4;
var
  n, SuccessN: integer;
  StartTime: dword;
  DisplayFormatstr: string;
  xMode: integer;
  RID: integer;
begin
  //
  xMode := -1;

  if RadioButton1.Checked then
    xMode := xMode_PERSON_DEL;
  if RadioButton2.Checked then
    xMode := xMode_ARTIKEL_DEL;
  if RadioButton3.Checked then
    xMode := xMode_BELEGE_DEL;
  if RadioButton4.Checked then
    xMode := xMode_ORDER_DEL;
  if xMode > 0 then
  begin
    BeginHourGlass;
    progressbar1.max := lTRN.count;
    DisplayFormatstr := label15.caption;
    StartTime := 0;
    SuccessN := 0;
    with DataModuleeCommerce do
      for n := 0 to pred(lTRN.count) do
      begin

        RID := lTRN[n];
        try
          case xMode of
            xMode_PERSON_DEL: begin
                e_w_BeforeDeletePerson(RID);
                e_x_sql('delete from PERSON where RID=' + inttostr(RID));
              end;
            xMode_ARTIKEL_DEL: begin
                e_w_BeforeDeleteArtikel(RID);
                e_x_sql('delete from ARTIKEL where RID=' + inttostr(RID));
              end;
            xMode_BELEGE_DEL: begin
                e_w_BeforeDeleteBeleg(RID);
                e_x_sql('delete from BELEG where RID=' + inttostr(RID));
              end;
            xMode_ORDER_DEL: begin
                e_w_BeforeDeleteBBeleg(RID);
                e_x_sql('delete from BBELEG where RID=' + inttostr(RID));
              end;
          end;
          inc(SuccessN);
        except
          on E: Exception do
            listbox3.items.add(E.Message);
        end;

        if frequently(StartTime, 555) or (n = pred(lTRN.count)) then
        begin
          progressbar1.position := n;
          label15.caption := format(DisplayFormatstr, [SuccessN, lTRN.count]);
          application.processmessages;
        end;

      end;
    progressbar1.position := 0;
    label17.caption := label15.caption;
    label15.caption := DisplayFormatstr;
    EndHourGlass;
  end else
  begin
    ShowMessage('Kein Transaktionstyp ausgewählt!')
  end;

end;

procedure TFormSQLExecuter.Button8Click(Sender: TObject);
begin
  BeginHourGlass;
  DataModuleCaching.ReBuild;
  EndHourGlass;
  label18.caption := 'Indizierung abgeschlossen: OrgaMon sollte neu gestartet werden!';
end;

procedure TFormSQLExecuter.Button12Click(Sender: TObject);
var
  ResultStrL: TStringList;
begin

  BeginHourGlass;
  ResultStrL := TStringList.create;
  IB_Metadata1.ExtractToStrings(ResultStrL);

  //
  ResultStrL.insert(0, '*/');
  ResultStrL.insert(0, '// Metadatenextraktion vom ' + datum + '  ' + uhr);
  ResultStrL.insert(0, '// DataBase Rev. ' + RevTostr(FormBaseUpdate.BaseRev));
  ResultStrL.insert(0, '// ' + cApplicationName + ' Rev. ' + RevTostr(globals.version));
  ResultStrL.insert(0, '//');
  ResultStrL.insert(0, '// ' + iDataBaseName);
  ResultStrL.insert(0, '/*');

  SynMemo1.lines.assign(ResultStrL);
  ResultStrL.SaveToFile(MetaDataFName);
  SynExporterHTML1.ExportAll(ResultStrL);
  SynExporterHTML1.SaveToFile(MetaDataFName + '.html');
  EndHourGlass;

  //
  open(MetaDataFName);
end;

function TFormSQLExecuter.MetaDataFName: string;
begin
  result := DiagnosePath +
    cApplicationName + '-' +
    RevToStr(globals.Version) + '-' +
    'Metadata.sql.txt';
end;

procedure TFormSQLExecuter.Button13Click(Sender: TObject);
var
  TheL: TStringList;
  Dups: TStringList;
  TheC: TIB_Cursor;
  DeleteCount: integer;
begin
  Dups := TStringList.create;
  TheL := TStringList.create;
  TheC := TIB_Cursor.create(self);
  with TheC do
  begin
    sql.add('select ' + edit6.Text + ' from ' + edit5.text);
    ApiFirst;
    while not (eof) do
    begin
      TheL.add(Fields[0].AsString);
      ApiNext;
    end;
  end;
  TheC.free;
  TheL.sort;
  RemoveDuplicates(TheL, DeleteCount, Dups);
  Dups.SaveToFile(DiagnosePath + 'SQL Fields Dups.txt');
  Dups.free;
  open(DiagnosePath + 'SQL Fields Dups.txt');
end;

procedure TFormSQLExecuter.Button15Click(Sender: TObject);
begin
  WakeOnLan(edit9.Text);
end;

procedure TFormSQLExecuter.Button14Click(Sender: TObject);
var
  Msg: string;
begin
  BeginHourGlass;
  with IBServerProperties1 do
  begin
    SysErrorMessage(10060);
    application.processmessages;
    Params.clear;
    params.add('user_name=SYSDBA');
    params.add('password=' + edit8.text);
    ServerName := noblank(edit7.text);
    Protocol := TCP;
    try
      Attach;
      Fetch;
      application.processmessages;
      msg := 'Plattform: ' + VersionInfo.ServerImplementation + #13#10 +
        'Server-Version: ' + VersionInfo.ServerVersion + #13#10 +
        'Service-Version: ' + inttostr(VersionInfo.ServiceVersion) + #13#10;
      Detach;
    except
      on E: Exception do
      begin
        Msg := 'FEHLER' + #13 + E.Message;
      end;
    end;
  end;
  EndHourGlass;
  ShowMessage(Msg);
end;

procedure TFormSQLExecuter.CheckBox7Click(Sender: TObject);
begin
  if CheckBox7.checked then
  begin
    timer1.enabled := true;
  end else
  begin
    timer1.enabled := false;
  end;
end;

procedure TFormSQLExecuter.CheckBox8Click(Sender: TObject);
begin
  NoTimer := CheckBox8.checked;
end;

procedure TFormSQLExecuter.Timer1Timer(Sender: TObject);
begin
  WakeOnLan(edit9.Text);
end;


end.

