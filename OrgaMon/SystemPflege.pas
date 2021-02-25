{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2021  Andreas Filsinger
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
unit SystemPflege;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons,
  ComCtrls, ExtCtrls,

  // IB-Objects
  IB_Access,
  IB_Components,
  IB_Process,
  IB_Script,
  IB_Dialogs,
  IB_MetaData,
  IB_UtilityBar,

  // SynEdit
  SynEdit, SynMemo, SynEditHighlighter,
  SynHighlighterSQL, SynEditExport, SynExportHTML,

  // ANFiX
  anfix, Geld, gplists, WordIndex,

  // Indy
  IdBaseComponent, IdComponent, IdUDPBase,
  IdUDPClient, IdSysLog, IdContext, IdCustomTCPServer, IdTCPServer,
  IdCmdTCPServer;

type
  TFormSystemPflege = class(TForm)
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
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    ListBox2: TListBox;
    Button5: TButton;
    CheckBox5: TCheckBox;
    TabSheet2: TTabSheet;
    Label5: TLabel;
    Label6: TLabel;
    IB_Query2: TIB_Query;
    TabSheet3: TTabSheet;
    IB_Metadata1: TIB_Metadata;
    SynSQLSyn1: TSynSQLSyn;
    TabSheet4: TTabSheet;
    SynExporterHTML1: TSynExporterHTML;
    Label7: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Button13: TButton;
    TabSheet5: TTabSheet;
    Timer1: TTimer;
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
    Label19: TLabel;
    SpeedButton1: TSpeedButton;
    GroupBox3: TGroupBox;
    CheckBox8: TCheckBox;
    TabSheet7: TTabSheet;
    Memo1: TMemo;
    IB_Script1: TIB_Script;
    Label8: TLabel;
    Edit7: TEdit;
    Button10: TButton;
    Edit8: TEdit;
    Button11: TButton;
    Edit9: TEdit;
    Label9: TLabel;
    RadioButton5: TRadioButton;
    SynMemo1: TSynMemo;
    Button12: TButton;
    Label10: TLabel;
    Label11: TLabel;
    Edit10: TEdit;
    StaticText1: TStaticText;
    Label12: TLabel;
    IB_UtilityBar1: TIB_UtilityBar;
    Button1: TButton;
    Button2: TButton;
    TabSheet8: TTabSheet;
    Memo2: TMemo;
    Edit11: TEdit;
    Button9: TButton;
    Button14: TButton;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    TabSheet9: TTabSheet;
    Button15: TButton;
    RadioButton6: TRadioButton;
    Edit12: TEdit;
    GroupBox1: TGroupBox;
    SpeedButton4: TSpeedButton;
    Edit13: TEdit;
    Button16: TButton;
    TabSheet10: TTabSheet;
    Edit14: TEdit;
    Button17: TButton;
    Edit15: TEdit;
    Label23: TLabel;
    Label24: TLabel;
    Memo3: TMemo;
    Button18: TButton;
    Button19: TButton;
    ListBox4: TListBox;
    RadioButton7: TRadioButton;
    Edit16: TEdit;
    CheckBox7: TCheckBox;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    Button20: TButton;
    procedure CheckBox8Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure TabSheet7Show(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Edit10KeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure IdCmdTCPServer1BeforeCommandHandler(ASender: TIdCmdTCPServer; var AData: string;
      AContext: TIdContext);
    procedure Button20Click(Sender: TObject);
  private
    { Private-Deklarationen }
    lTRN: TgpIntegerList;
    tTRN: TsTable;
  public
    { Public-Deklarationen }
    function MetaDataFName: string;

    // Speed Test
    procedure PerfSQL;
    procedure PerfDataTransport;

  end;

var
  FormSystemPflege: TFormSystemPflege;

function Transaktionen_Feedback (key : Integer; value : string = '') : Integer;

implementation

uses
  // System
  math, clipbrd,

  // Tools
  SolidFTP, html, wanfix,
  FastGeo,

  // IB-Objects
  IB_Session,

  // JCL
  jclcounter,

  // OrgaMon
  globals, dbOrgaMon,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Buch,
  Funktionen_Artikel,
  Funktionen_LokaleDaten,
  Funktionen_Transaktion,
  Belege, BaseUpdate, Datenbank,
  CareServer, CareTakerClient, ArtikelPOS,
  AuftragArbeitsplatz, GeoLokalisierung;

{$R *.DFM}

const
 fb_STRASSE : string = '';
 fb_ORT : string = '';

function Transaktionen_Feedback (key : Integer; value : string = '') : Integer;
var
 AUFTRAG_R: Integer;
 p : Tpoint2D;
begin
  result := cFeedBack_CONT;
  case Key of
    cFeedBack_OpenShell:openShell(value);
    cFeedBack_Function:
      begin
        AUFTRAG_R := StrToIntDef(value,0);
        if (FormAuftragArbeitsplatz.ItemsMARKED.indexof(pointer(AUFTRAG_R)) = -1) then
         FormAuftragArbeitsplatz.ItemsMARKED.add(pointer(AUFTRAG_R));
      end;
     cFeedBack_Function+1: begin
        FormAuftragArbeitsplatz.ItemsMARKED.clear;
     end;
     cFeedBack_Function+2: fb_STRASSE := value;
     cFeedBack_Function+3: fb_ORT := value;
     cFeedBack_Function+4:begin
        result  := FormGeoLokalisierung.locate(
         { } fb_STRASSE,
         { } fb_ORT,
         { } value,
         { } p);
        _FeedBack_String := FormGeoLokalisierung.r_ortsteil;
     end
  else
   ShowMessage('Unbekannter Feedback Key '+IntToStr(Key));
  end;
end;

function ClearIndexName(s: string): string;
begin
  result := nextp(s, '.', 1);
end;

procedure TFormSystemPflege.FormCreate(Sender: TObject);
begin
  StartDebug('SystemPflege');
  PageControl1.ActivePage := TabSheet1;
end;

procedure TFormSystemPflege.IdCmdTCPServer1BeforeCommandHandler(ASender: TIdCmdTCPServer;
  var AData: string; AContext: TIdContext);
begin
  ListBox4.Items.Add(AData);
end;

procedure TFormSystemPflege.Button3Click(Sender: TObject);
var
  AllTheRIDs: TStringList;
  DuplettenCount: integer;
  ErrorCount: integer;
begin
  BeginHourGlass;
  ListBox1.Items.Clear;
  AllTheRIDs := TStringList.create;
  with IB_Query1 do
  begin
    sql.Clear;
    sql.Add('SELECT ' + Edit4.Text);
    sql.Add('FROM ' + Edit3.Text);
    ListBox1.Items.addstrings(sql);
    Open;
    first;
    while not(eof) do
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
    sql.Clear;
    sql.Add('SELECT ' + Edit2.Text);
    sql.Add('FROM ' + Edit1.Text);
    sql.Add('WHERE ' + Edit2.Text + ' IS NOT NULL');
    sql.Add('FOR UPDATE');
    ListBox1.Items.addstrings(sql);
    Open;
    ErrorCount := 0;
    first;
    while not(eof) do
    begin
      if (AllTheRIDs.indexof(FieldByName(Edit2.Text).AsString) = -1) then
      begin
        if (ErrorCount = 0) then
          ListBox1.Items.Clear;
        ListBox1.Items.Add(FieldByName(Edit2.Text).AsString + '? ');
        inc(ErrorCount);
        if CheckBox1.Checked then
        begin
          if CheckBox5.Checked then // Tdataset
          begin
            delete;
          end
          else
          begin
            edit;
            FieldByName(Edit2.Text).Clear;
            post;
          end;
        end;
      end;
      next;
    end;
    Close;
  end;
  AllTheRIDs.assign(ListBox1.Items);
  AllTheRIDs.Sort;
  AllTheRIDs.SaveToFile(DiagnosePath + Edit1.Text + '-' + Edit2.Text + '.txt');
  AllTheRIDs.free;
  EndHourGlass;
  Label2.caption := inttostr(ErrorCount) + ' Fehler!';
end;

procedure TFormSystemPflege.Button4Click(Sender: TObject);
var
  n: integer;
begin
  // alle indizes ermitteln
  BeginHourGlass;
  Label2.caption := 'läuft ...';
  Button4.Enabled := false;
  ListBox1.Items.Clear;
  ListBox2.Items.Clear;
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
    while not(eof) do
    begin
      ListBox1.Items.Add(FieldByName('RDB$RELATION_NAME').AsString + '.' +
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
  IB_Query2.Open;

  // alle Primary Keys aktivieren
  for n := 0 to pred(ListBox1.Items.count) do
  begin

    if pos('RDB$PRIMARY', ListBox1.Items[n]) > 0 then
    begin
      IB_Script1.sql.Clear;
      IB_Script1.sql.Add('alter index ' + ClearIndexName(ListBox1.Items[n]) + ' active;');
      try
        if CheckBox2.Checked then
        begin
          ListBox1.ItemIndex := n;
          application.ProcessMessages;
          IB_Script1.Execute;
        end;
      except
        beep;
        ListBox2.Items.Add(ListBox1.Items[n]);
      end;
      continue;
    end;

    if pos('RDB$FOREIGN', ListBox1.Items[n]) > 0 then
    begin
      IB_Script1.sql.Clear;
      IB_Script1.sql.Add('alter index ' + ClearIndexName(ListBox1.Items[n]) + ' active;');
      try
        if CheckBox3.Checked then
        begin
          ListBox1.ItemIndex := n;
          application.ProcessMessages;
          IB_Script1.Execute;
        end;
      except
        beep;
        ListBox2.Items.Add(ListBox1.Items[n]);
      end;
      continue;
    end
    else
    begin
      IB_Script1.sql.Clear;
      IB_Script1.sql.Add('alter index ' + ClearIndexName(ListBox1.Items[n]) + ' active;');
      try
        if CheckBox4.Checked then
        begin
          ListBox1.ItemIndex := n;
          application.ProcessMessages;
          IB_Script1.Execute;
        end;
      except
        beep;
        ListBox2.Items.Add(ListBox1.Items[n]);
      end;
      continue;
    end;

  end;
  Button4.Enabled := true;
  Label2.caption := 'inaktive Indizes';

  //
  EndHourGlass;

end;

procedure TFormSystemPflege.Button5Click(Sender: TObject);
begin
  BeginHourGlass;
  if ListBox1.ItemIndex <> -1 then
  begin
    IB_Script1.sql.Clear;
    IB_Script1.sql.Add('alter index ' + ClearIndexName(ListBox1.Items[ListBox1.ItemIndex]) +
      ' active;');
    try
      IB_Script1.Execute;
    except
      beep;
      ListBox2.Items.Add(ListBox1.Items[ListBox1.ItemIndex]);
    end;
  end;
  EndHourGlass;
end;

procedure TFormSystemPflege.Button6Click(Sender: TObject);
var
  ImportL: TStringList;
  n: integer;
  RID: integer;
  _RID: string;
  ErrorLogMode: boolean;
begin
  OpenDialog1.InitialDir := iOlapPath;
  if OpenDialog1.Execute then
  begin
    BeginHourGlass;

    if not(assigned(lTRN)) then
    begin
      lTRN := TgpIntegerList.create;
      tTRN := TsTable.create;
    end
    else
    begin
      lTRN.Clear;
      tTRN.Clear;
    end;

    tTRN.insertFromFile(OpenDialog1.FileName);

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
          lTRN.Add(RID);
      end;
    end;
    ImportL.free;
    Label16.caption := inttostr(lTRN.count);
    EndHourGlass;
  end;

end;

procedure TFormSystemPflege.Button7Click(Sender: TObject);
const
  xMode_PERSON_DEL = 1;
  xMode_ARTIKEL_DEL = 2;
  xMode_BELEGE_DEL = 3;
  xMode_ORDER_DEL = 4;
  xMode_FORDERUNG_DEL = 5;
  xMode_Free = 6;
  xMode_SQL = 7;
  xMode_VERTRAG = 8;
  xMode_LAGER = 9;
  xMode_LAGER_DEL = 10;
var
  n, SuccessN: integer;
  StartTime: dword;
  DisplayFormatstr: string;
  xMode: integer;
  RID: integer;
  Betrag: double;
  sDiagnose: TStringList;
  sLog: TStringList;
  PERSON_R: integer;
  xSQL: string;
begin
  if not(assigned(lTRN)) then
  begin
    ShowMessage('Es ist noch keine Liste geladen. Verwenden Sie ->"laden".');
    exit;
  end;
  if (lTRN.count = 0) then
  begin
    ShowMessage('Die Liste ist leer. Es ist keine Aktion notwendig.');
    exit;
  end;
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
  if RadioButton5.Checked then
    xMode := xMode_FORDERUNG_DEL;
  if RadioButton6.Checked then
    xMode := xMode_Free;
  if RadioButton7.Checked then
    xMode := xMode_SQL;
  if RadioButton8.Checked then
    xMode := xMode_VERTRAG;
  if RadioButton9.Checked then
    xMode := xMode_LAGER;
  if RadioButton10.Checked then
    xMode := xMode_LAGER_DEL;

  if (xMode > 0) then
  begin
    BeginHourGlass;
    if (xMode = xMode_Free) then
    begin
      e_x_Transaktion(Edit12.Text, lTRN, Transaktionen_Feedback);
    end
    else
    begin
      sLog := TStringList.create;
      ProgressBar1.max := lTRN.count;
      DisplayFormatstr := Label15.caption;
      StartTime := 0;
      SuccessN := 0;
      for n := 0 to pred(lTRN.count) do
      begin

        RID := lTRN[n];
        try
          case xMode of
            xMode_PERSON_DEL:
              begin
                e_w_preDeletePerson(RID);
                e_x_sql('delete from PERSON where RID=' + inttostr(RID));
              end;
            xMode_ARTIKEL_DEL:
              begin
                e_w_preDeleteArtikel(RID);
                e_x_sql('delete from ARTIKEL where RID=' + inttostr(RID));
              end;
            xMode_BELEGE_DEL:
              begin
                e_w_preDeleteBeleg(RID);
                e_x_sql('delete from BELEG where RID=' + inttostr(RID));
              end;
            xMode_ORDER_DEL:
              begin
                e_w_preDeleteBBeleg(RID);
                e_x_sql('delete from BBELEG where RID=' + inttostr(RID));
              end;
            xMode_LAGER_DEL:
              begin
                e_w_preDeleteLager(RID);
                e_x_sql('delete from LAGER where RID=' + inttostr(RID));
              end;
            xMode_FORDERUNG_DEL:
              begin
                Betrag := e_r_sqld(
                  { } 'select sum(BETRAG) from' +
                  { } ' AUSGANGSRECHNUNG where ' +
                  { } ' BELEG_R=' + inttostr(RID));

                if isHaben(Betrag) then
                begin

                  // für eine Person sorgen
                  PERSON_R := e_r_sql(
                    { } 'select PERSON_R from BELEG ' +
                    { } 'where RID=' + inttostr(RID));

                  // ev. eine 1710er Buchung?
                  Betrag := b_w_ForderungsAusfall(RID, Betrag);

                  if IsSomeMoney(Betrag) then
                  begin
                    sDiagnose := TStringList.create;
                    b_w_ForderungAusgleich(format(cBuch_Ausgleich, [
                      { } PERSON_R,
                      { } RID,
                      { } Betrag,
                      { } '',
                      { } cRID_Null,
                      { } 'Transaktion Forderungsverlust',
                      { } cKonto_Forderungsverlust,
                      { } 0,
                      { } cRID_Null]), sDiagnose);
                    sLog.addstrings(sDiagnose);
                    sDiagnose.free;
                  end;
                end;
              end;
            xMode_SQL:
              begin
                xSQL := Edit16.Text;
                tTRN.ersetze(n + 1, xSQL);
                e_x_sql(xSQL);
              end;
            xMode_VERTRAG:
              begin
                e_w_VertragBuchen(RID, true);
              end;
            xMode_LAGER:
             begin
               e_r_LagerFreiraum(RID).Free;
             end;
          end;
          inc(SuccessN);
        except
          on E: Exception do
          begin
            ListBox3.Items.Add(IntToStr(RID)+': '+E.Message);
            AppendStringsToFile(
              {} inttostr(RID) + ': ' +
              {} E.Message,
              {} ErrorFName('STAPELTRANSAKTION'),
              {} Uhr12);
          end;
        end;

        if frequently(StartTime, 555) or (n = pred(lTRN.count)) then
        begin
          ProgressBar1.position := n;
          Label15.caption := format(DisplayFormatstr, [SuccessN, lTRN.count]);
          application.ProcessMessages;
          if CheckBox7.Checked then
            break;
        end;

      end;
      ProgressBar1.position := 0;
      Label17.caption := Label15.caption;
      Label15.caption := DisplayFormatstr;
      FormCareServer.ShowIfError(sLog);
      sLog.free;
    end;
    ListBox3.Items.Add('Beendet!');
    EndHourGlass;
  end
  else
  begin
    ShowMessage('Kein Transaktionstyp ausgewählt!')
  end;

end;

procedure TFormSystemPflege.Button8Click(Sender: TObject);
begin
  BeginHourGlass;
  ReBuild;
  EndHourGlass;
  Label18.caption := 'Indizierung abgeschlossen: OrgaMon sollte neu gestartet werden!';
end;

procedure TFormSystemPflege.Button9Click(Sender: TObject);
var
  sList: TStringList;
  n: integer;
  qDOKUMENT: TIB_Query;
  f: TFileStream;
  s: TIB_BlobStream;
  sPath: string;
begin
  qDOKUMENT := DataModuleDatenbank.nQuery;
  sList := TStringList.create;
  dir(Edit11.Text, sList, false);
  sPath := EXtractFilePath(Edit11.Text);
  if doit(inttostr(sList.count) + ' Dateien in die Datenbank schreiben') then
  begin
    with qDOKUMENT do
    begin
      sql.Add('select RID,DATEN from DOKUMENT for update');
      for n := 0 to pred(sList.count) do
      begin

        insert;
        FieldByName('RID').AsInteger := cRID_AutoInc;
        s := CreateBlobStream(FieldByName('DATEN'), bsmWrite);
        f := TFileStream.create(sPath + sList[n], fmOpenRead);
        s.CopyFrom(f, f.Size);
        f.free;
        s.free;
        post;
      end;
    end;
  end;
  qDOKUMENT.free;
end;

procedure TFormSystemPflege.Button10Click(Sender: TObject);
begin
  Edit8.Text := inttostr(e_r_sql('select max(RID) from ' + Edit7.Text));
  Edit9.Text := 'GEN_' + Edit7.Text;
end;

procedure TFormSystemPflege.Button11Click(Sender: TObject);
begin
  e_x_sql('SET GENERATOR ' + Edit9.Text + ' to ' + Edit8.Text);
end;

procedure TFormSystemPflege.Button12Click(Sender: TObject);
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

  SynMemo1.Lines.assign(ResultStrL);
  ResultStrL.SaveToFile(MetaDataFName);
  SynExporterHTML1.ExportAll(ResultStrL);
  SynExporterHTML1.SaveToFile(MetaDataFName + '.html');
  EndHourGlass;

  //
  openShell(MetaDataFName);
end;

function TFormSystemPflege.MetaDataFName: string;
begin
  result := DiagnosePath + cApplicationName + '-' + RevTostr(globals.version) + '-' +
    'Metadata.sql.txt';
end;

procedure TFormSystemPflege.PerfDataTransport;
var
  cDOKUMENT: TIB_Cursor;
  Speed: TJclCounter;
  SizeOverAll: int64;
  m: TMemoryStream;
  s: TStream;
  a, b, c: double;
begin
  Speed := TJclCounter.create;
  Speed.Start;
  SizeOverAll := 0;
  cDOKUMENT := DataModuleDatenbank.nCursor;
  with cDOKUMENT do
  begin
    sql.Add('select RID,DATEN from DOKUMENT where DATEN is not null');
    ApiFirst;
    while not(eof) do
    begin

      // just read it!
      s := CreateBlobStream(FieldByName('DATEN'), bsmRead);
      m := TMemoryStream.create;
      m.CopyFrom(s, s.Size);
      inc(SizeOverAll, m.Size);
      Memo2.Lines.Add(inttostr(m.Size) + ' Bytes');
      m.free;
      s.free;

      ApiNext;
    end;
  end;
  cDOKUMENT.free;
  a := Speed.Stop;
  Memo2.Lines.Add('Summe ist ' + inttostr(SizeOverAll DIV (1024 * 1024)) + ' MiByte');
  Memo2.Lines.Add(format('Benötigte Zeit %.3f s', [a]));

  b := SizeOverAll;
  b := b / 1024.0 / 1024.0;
  c := b / a;
  Memo2.Lines.Add(format('Transfer-Rate ist somit %.1f MiByte/s', [c]));
  Speed.free;

end;

procedure TFormSystemPflege.PerfSQL;
var
  ResultStrL: TStringList;
  Speed: TJclCounter;
begin
  Speed := TJclCounter.create;
  Speed.Start;
  ResultStrL := TStringList.create;
  with IB_Metadata1 do
  begin
    ResetAll;
    ExtractToStrings(ResultStrL);
  end;
  Memo2.Lines.Add(format('SQL-Metadaten Analyse dauerte  %.3f s', [Speed.Stop]));
  ResultStrL.free;
  Speed.free;
end;

procedure TFormSystemPflege.SpeedButton1Click(Sender: TObject);
begin
  CheckCreateOnce(EigeneOrgaMonDateienPfad);
  openShell(EigeneOrgaMonDateienPfad);
end;

procedure TFormSystemPflege.SpeedButton4Click(Sender: TObject);
begin
  Edit13.Text := anfix._document;
end;

procedure TFormSystemPflege.Button13Click(Sender: TObject);
var
  TheL: TStringList;
  Dups: TStringList;
  TheC: TIB_Cursor;
  DeleteCount: integer;
begin
  Dups := TStringList.create;
  TheL := TStringList.create;
  TheC := DataModuleDatenbank.nCursor;
  with TheC do
  begin
    sql.Add('select ' + Edit6.Text + ' from ' + Edit5.Text);
    ApiFirst;
    while not(eof) do
    begin
      TheL.Add(Fields[0].AsString);
      ApiNext;
    end;
  end;
  TheC.free;
  TheL.Sort;
  removeduplicates(TheL, DeleteCount, Dups);
  Dups.SaveToFile(DiagnosePath + 'SQL Fields Dups.txt');
  Dups.free;
  openShell(DiagnosePath + 'SQL Fields Dups.txt');
end;

procedure TFormSystemPflege.Button14Click(Sender: TObject);
begin
  BeginHourGlass;
  Label22.caption := iDataBaseHost;
  Memo2.Lines.Clear;
  PerfSQL;
  PerfDataTransport;
  EndHourGlass;
end;

procedure TFormSystemPflege.Button15Click(Sender: TObject);
begin
  FormArtikelPOS.show;
end;

procedure TFormSystemPflege.Button16Click(Sender: TObject);
begin
  openShell(Edit13.Text);
end;

procedure TFormSystemPflege.Button17Click(Sender: TObject);

  function FilterMatch(const s: string): boolean;
  begin
    result := (pos(Edit15.Text, s) > 0);
  end;

  procedure Log(s: string);
  begin
    Memo3.Lines.Add(s);
  end;

var
  Blocklist: TStringList;
  Apache2Log: TStringList;
  n, i, Matches, MAxMAtches: integer;
  IP: string;
  FirewallScript: TStringList;
begin
  Apache2Log := TStringList.create;
  Blocklist := TStringList.create;

  Apache2Log.LoadFromFile(Edit14.Text);

  Log('Log-Size [Lines] : ' + inttostr(Apache2Log.count));
  Matches := 0;
  for n := 0 to pred(Apache2Log.count) do
    if FilterMatch(Apache2Log[n]) then
    begin
      inc(Matches);
      IP := nextp(Apache2Log[n], ' ', 0);
      i := Blocklist.indexof(IP);
      if (i = -1) then
        Blocklist.AddObject(IP, pointer(integer(1)))
      else
        Blocklist.Objects[i] := pointer(integer(Blocklist.Objects[i]) + 1);
    end;
  Log('Filter-Hits [Lines] : ' + inttostr(Matches));
  Log('Bad IPs [Count] : ' + inttostr(Blocklist.count));
  Apache2Log.free;
  if (Blocklist.count > 0) then
  begin
    FirewallScript := TStringList.create;
    Matches := 0;
    MAxMAtches := 0;
    for n := 0 to pred(Blocklist.count) do
    begin
      i := integer(Blocklist.Objects[n]);
      MAxMAtches := max(MAxMAtches, i);
      inc(Matches, i);
      FirewallScript.Add(inttostrN(i, 5) + ';' + Blocklist[n]);
    end;
    Log('Average Attacks per IP [Attacks] : ' + inttostr(round(Matches / Blocklist.count)));
    Log('Top Count Attacks per most active IP [Attacks] : ' + inttostr(MAxMAtches));
    FirewallScript.Sort;
    FirewallScript.SaveToFile(DiagnosePath+'Blocklist.txt');
    FirewallScript.free;
  end;
  Blocklist.free;
end;

procedure TFormSystemPflege.Button18Click(Sender: TObject);
var
  Blocklist: TStringList;
  FirewallScript: TStringList;
  n: integer;
  IP: string;
begin
  Blocklist := TStringList.create;
  FirewallScript := TStringList.create;
  with FirewallScript do
  begin
    Add('#!/bin/bash');
    Add('#');
    Add('# autogenerated by OrgaMon');
    Add('#');
    Add('');
    Add('iptables -F');
    Add('iptables -t nat -F');
    Add('iptables -t mangle -F');
    Add('iptables -X');
  end;
  Blocklist.LoadFromFile(DiagnosePath+'Blocklist.txt');
  for n := 0 to pred(Blocklist.count) do
  begin
    IP := nextp(Blocklist[n], ';', 1);
    FirewallScript.Add('iptables -I INPUT -s ' + IP + ' -j DROP');
  end;
  Blocklist.free;
  FirewallScript.LineBreak := #$0A;
  FirewallScript.SaveToFile(DiagnosePath + 'block.sh');
  FirewallScript.free;
end;

procedure TFormSystemPflege.Button1Click(Sender: TObject);
begin
  DataModuleDatenbank.IB_Transaction_W.Commit;
end;

procedure TFormSystemPflege.Button20Click(Sender: TObject);
begin
 if DoIt('Unnötige Datenbank Tabellen werden nicht sofort gelöscht.'+#13+
         'Aufgrund eines Bugs in der Firebird Datenbank Engine wird '+
         'empfohlen dass nach einer Löschung von Tabellen die '+
         'Datenbank neu erstellt wird (Backup- & Restore-Lauf)-'+#13+
         'Wenn Sie die Möglichkeit haben dies im Anschluss zu tun ist '+
         'die Anwendung dieser Funktion sicher.'+#13+
         'Sollen ausstehende Tabellen-Löschungen nun durchgeführt werden') then
 begin
  BeginHourGlass;
  DropTheUndropped;
  EndHourGlass;
 end;
end;

procedure TFormSystemPflege.Button2Click(Sender: TObject);
begin
  DataModuleDatenbank.IB_Transaction_R.Commit;
end;

procedure TFormSystemPflege.CheckBox8Click(Sender: TObject);
begin
  NoTimer := CheckBox8.Checked;
end;

procedure TFormSystemPflege.Edit10KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    StaticText1.caption := inttostr(HTMLColor2TColor(Edit10.Text));
    clipboard.AsText := StaticText1.caption;
    Key := #0;
  end;
end;

procedure TFormSystemPflege.TabSheet7Show(Sender: TObject);
var
  e_r_BasePlug_Strings: TStringList;
begin
  if (Memo1.Lines.count = 0) then
  begin
    e_r_BasePlug_Strings := e_r_BasePlug;
    Memo1.Lines.addstrings(e_r_BasePlug_Strings);
    e_r_BasePlug_Strings.free;
  end;
end;

end.
