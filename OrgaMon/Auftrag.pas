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
unit Auftrag;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, IB_Components, IB_Access,
  IB_UpdateBar, ComCtrls, ExtCtrls,
  StdCtrls, IB_Controls, Mask,
  Sperre, Buttons, JvExStdCtrls,
  JvButton, JvCtrls, IB_EditButton;

type
  TFormAuftrag = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Date1: TIB_Date;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    IB_Edit1: TIB_Edit;
    IB_Memo1: TIB_Memo;
    IB_Edit2: TIB_Edit;
    IB_Edit3: TIB_Edit;
    IB_Edit4: TIB_Edit;
    IB_Edit5: TIB_Edit;
    IB_Edit6: TIB_Edit;
    IB_Edit7: TIB_Edit;
    IB_Edit8: TIB_Edit;
    IB_Edit9: TIB_Edit;
    IB_Edit10: TIB_Edit;
    IB_Edit11: TIB_Edit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    IB_Memo2: TIB_Memo;
    Label6: TLabel;
    Label7: TLabel;
    ComboBox2: TComboBox;
    Button3: TButton;
    Label9: TLabel;
    Label10: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    TabSheet4: TTabSheet;
    Button4: TButton;
    Button5: TButton;
    IB_DSQL1: TIB_DSQL;
    Label18: TLabel;
    IB_Edit12: TIB_Edit;
    Label20: TLabel;
    IB_Memo3: TIB_Memo;
    Label22: TLabel;
    IB_Edit13: TIB_Edit;
    IB_Query2: TIB_Query;
    IB_CheckBox1: TIB_CheckBox;
    Label19: TLabel;
    IB_Date2: TIB_Date;
    IB_Date3: TIB_Date;
    TabSheet5: TTabSheet;
    Label25: TLabel;
    IB_Edit14: TIB_Edit;
    Label26: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    IB_Edit19: TIB_Edit;
    IB_Edit20: TIB_Edit;
    IB_Edit21: TIB_Edit;
    IB_Edit22: TIB_Edit;
    Label36: TLabel;
    IB_Edit18: TIB_Edit;
    TabSheet6: TTabSheet;
    Button8: TButton;
    Label41: TLabel;
    IB_Edit27: TIB_Edit;
    Label42: TLabel;
    IB_Edit28: TIB_Edit;
    Button9: TButton;
    IB_CheckBox3: TIB_CheckBox;
    SpeedButton1: TSpeedButton;
    TabSheet7: TTabSheet;
    Label23: TLabel;
    Label44: TLabel;
    IB_Edit15: TIB_Edit;
    IB_Memo5: TIB_Memo;
    SpeedButton2: TSpeedButton;
    Button6: TButton;
    SpeedButton3: TSpeedButton;
    TabSheet8: TTabSheet;
    Label45: TLabel;
    Button10: TButton;
    Button11: TButton;
    IB_Edit29: TIB_Edit;
    Label46: TLabel;
    Label47: TLabel;
    Button12: TButton;
    Image3: TImage;
    IB_Date6: TIB_Date;
    IB_Date7: TIB_Date;
    Label8: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    IB_Text13: TIB_Text;
    TabSheet9: TTabSheet;
    SpeedButton5: TSpeedButton;
    CheckBox1: TCheckBox;
    SpeedButton4: TSpeedButton;
    ListBox1: TListBox;
    Memo1: TMemo;
    Button13: TButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    Label48: TLabel;
    IB_Edit30: TIB_Edit;
    IB_Edit31: TIB_Edit;
    Label49: TLabel;
    TabSheet10: TTabSheet;
    IB_Text2: TIB_Text;
    IB_Text3: TIB_Text;
    IB_Text4: TIB_Text;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    IB_Text5: TIB_Text;
    IB_Text6: TIB_Text;
    Label15: TLabel;
    Image1: TImage;
    Image2: TImage;
    Label16: TLabel;
    IB_Text1: TIB_Text;
    IB_Text7: TIB_Text;
    Label17: TLabel;
    Label24: TLabel;
    IB_Text9: TIB_Text;
    Label40: TLabel;
    Label43: TLabel;
    IB_Text8: TIB_Text;
    IB_Text14: TIB_Text;
    IB_Edit26: TIB_Edit;
    Label21: TLabel;
    Label50: TLabel;
    IB_Edit32: TIB_Edit;
    IB_Memo6: TIB_Memo;
    IB_Text15: TIB_Text;
    Label51: TLabel;
    Label35: TLabel;
    IB_Date8: TIB_Date;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    IB_Edit16: TIB_Edit;
    IB_Edit17: TIB_Edit;
    IB_Date4: TIB_Date;
    Label52: TLabel;
    Label54: TLabel;
    IB_Edit34: TIB_Edit;
    IB_Edit33: TIB_Edit;
    IB_Edit35: TIB_Edit;
    Label55: TLabel;
    Label56: TLabel;
    Button14: TButton;
    Image4: TImage;
    Button15: TButton;
    SpeedButton8: TSpeedButton;
    Button16: TButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    Image5: TImage;
    SpeedButton19: TSpeedButton;
    Label14: TLabel;
    Label31: TLabel;
    IB_CheckBox2: TIB_CheckBox;
    Label53: TLabel;
    JvImgBtn1: TJvImgBtn;
    JvImgBtn2: TJvImgBtn;
    JvImgBtn3: TJvImgBtn;
    JvImgBtn4: TJvImgBtn;
    JvImgBtn5: TJvImgBtn;
    JvImgBtn6: TJvImgBtn;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    IB_Edit36: TIB_Edit;
    IB_Edit37: TIB_Edit;
    IB_Edit38: TIB_Edit;
    Label27: TLabel;
    IB_Date5: TIB_Date;
    Button7: TButton;
    IB_Edit25: TIB_Edit;
    IB_Edit24: TIB_Edit;
    IB_Edit23: TIB_Edit;
    Label39: TLabel;
    Label38: TLabel;
    Label37: TLabel;
    Label60: TLabel;
    IB_Edit39: TIB_Edit;
    Label61: TLabel;
    Label62: TLabel;
    IB_Memo4: TIB_Memo;
    procedure IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2DropDown(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure IB_Query1AfterCancel(IB_Dataset: TIB_Dataset);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure IB_Date1Strike(Sender: TIB_CustomDate; CheckThisDate: TDateTime; var CrossColor: TColor);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure IB_Edit3Change(Sender: TObject);
    procedure IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
    procedure FormDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure IB_Edit28IsValidChar(Sender: TObject; var AChar: Char; var IsValid: Boolean);
    procedure IB_Edit28SetEditText(Sender: TObject; var AString: string);
    procedure Button9Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure JvImgBtn1Click(Sender: TObject);
    procedure JvImgBtn3Click(Sender: TObject);
    procedure JvImgBtn2Click(Sender: TObject);
    procedure JvImgBtn5Click(Sender: TObject);
    procedure JvImgBtn4Click(Sender: TObject);
    procedure JvImgBtn6Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure IB_Edit28GetDisplayText(Sender: TObject; var AString: string);
    procedure IB_Edit28GetEditText(Sender: TObject; var AString: string);
    procedure SpeedButton8Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure IB_Memo2Change(Sender: TObject);
    procedure IB_Memo1Change(Sender: TObject);
    procedure IB_Memo3Change(Sender: TObject);
    procedure IB_Memo6Change(Sender: TObject);
    procedure IB_Memo4Change(Sender: TObject);
    procedure IB_Memo5Change(Sender: TObject);
    procedure IB_Date1ButtonClick(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure TabSheet9Show(Sender: TObject);
    procedure IB_Memo4DblClick(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure SpeedButton19Click(Sender: TObject);
    procedure IB_Edit5DblClick(Sender: TObject);
  private
    { Private-Deklarationen }
    _RadioAsStr: string;
    _RadioIgnoreChanges: Boolean;
    _Sperre: TSperre;
    Kontext: integer;
    KeySaver: TStringList;
    procedure setStatusNormal;
    procedure setStatusNeuAnschreiben;
    procedure setStatusRestant;
    procedure setStatusErledigt;
    procedure setStatusVorgezogen;
    procedure setStatusUnmoeglich;

  public

    { Public-Deklarationen }
    procedure setContext(AUFTRAG_R: integer);
    procedure EnsureEditState;
    function RadioChangeDetect: Boolean;
    function RadioAsStr: string;
    procedure ReflectTheQueryData;
    procedure ReflectQuality;

    procedure SaveKeysaver;

  end;

var
  FormAuftrag: TFormAuftrag;

implementation

uses
  AuftragArbeitsplatz, Baustelle,
  globals, DatePick, WordIndex,
  anfix32, gplists, math,
  Funktionen_App,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  AuftragAssist, Bearbeiter, GeoLokalisierung,
  FastGEO, GeoArbeitsplatz,
  GeoCache, CareTakerClient, dbOrgaMon,
  clipbrd, Datenbank, html,
  PEM, wanfix32;
{$R *.DFM}

const
  cTasteFName = 'Tasten.txt';
  cStrassenFName = 'Strassen.txt';

procedure TFormAuftrag.IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
var
  _datum: TAnfixDate;
begin
  //
  _datum := DateTime2long(IB_Dataset.FieldByName('AUSFUEHREN').AsDate);

  // Sicherstellen, dass die richtige Belastung angezeigt wird!
  with FormAuftragArbeitsplatz do
  begin
    ShouldRefreshListe := true;
    ShouldRefreshBelastung := true;
    ShouldRefreshBelastungbaustelle := IB_Dataset.FieldByName('BAUSTELLE_R').AsInteger;
    if DateOK(_datum) then
      v_MonteurMontag := _datum;
  end;

  // VORMITTAGS
  if RadioButton1.Checked then
    IB_Dataset.FieldByName('VORMITTAGS').AsString := cVormittagsChar;
  if RadioButton2.Checked then
    IB_Dataset.FieldByName('VORMITTAGS').AsString := cNachmittagsChar;
  if RadioButton3.Checked then
    IB_Dataset.FieldByName('VORMITTAGS').clear;

  // Standard-Änderung
  ForceHistorischer := true;
  AuftragBeforePost(IB_Dataset);
  if HistorischerErzeugt then
    FormAuftragArbeitsplatz.HistorischeFlash;
end;

procedure TFormAuftrag.setContext(AUFTRAG_R: integer);
begin
  with IB_Query1 do
  begin
    ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
    if not(Active) then
      Open;
    ReflectTheQueryData;
  end;
  BringToFront;
  show;
end;

procedure TFormAuftrag.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #27:
      begin
        Key := #0;
        close;
      end;
    #13:
      begin
        KeySaver.add('');
      end;
    #8:
      begin
        KeySaver.add('<Löschen>');
      end;
  else
    if (KeySaver.count = 0) then
      KeySaver.add('');
    KeySaver[pred(KeySaver.count)] := KeySaver[pred(KeySaver.count)] + Key;
  end;
end;

procedure TFormAuftrag.ComboBox1DropDown(Sender: TObject);
begin
  ComboBox1.items.assign(e_r_BaustelleMonteure(IB_Query1.FieldByName('BAUSTELLE_R').AsInteger));
  ComboBox1.items.insert(0, '*');
end;

procedure TFormAuftrag.ComboBox2DropDown(Sender: TObject);
begin
  ComboBox2.items.assign(e_r_BaustelleMonteure(IB_Query1.FieldByName('BAUSTELLE_R').AsInteger));
  ComboBox2.items.insert(0, '*');
end;

procedure TFormAuftrag.ComboBox1Change(Sender: TObject);
var
  _rid: integer;
begin
  EnsureEditState;
  _rid := e_r_MonteurRIDFromKuerzel(ComboBox1.Text);
  if _rid <> -1 then
  begin
    IB_Query1.FieldByName('MONTEUR1_R').AsInteger := _rid;
  end
  else
  begin
    IB_Query1.FieldByName('MONTEUR1_R').clear;
  end;
end;

procedure TFormAuftrag.ComboBox2Change(Sender: TObject);
var
  _rid: integer;
begin
  EnsureEditState;
  _rid := e_r_MonteurRIDFromKuerzel(ComboBox2.Text);
  if _rid <> -1 then
  begin
    IB_Query1.FieldByName('MONTEUR2_R').AsInteger := _rid;
  end
  else
  begin
    IB_Query1.FieldByName('MONTEUR2_R').clear;
  end;
end;

procedure TFormAuftrag.Button3Click(Sender: TObject);
begin
  close;
end;

procedure TFormAuftrag.EnsureEditState;
begin
  if (IB_Query1.State <> dssEdit) and (IB_Query1.State <> dssInsert) then
    IB_Query1.edit;
end;

function TFormAuftrag.RadioAsStr: string;
begin
  result := format('%d%d%d', [ord(RadioButton1.Checked), ord(RadioButton2.Checked), ord(RadioButton3.Checked)]);
end;

function TFormAuftrag.RadioChangeDetect: Boolean;
begin
  result := (RadioAsStr <> _RadioAsStr) and not(_RadioIgnoreChanges);
  if result then
    _RadioAsStr := RadioAsStr;
end;

procedure TFormAuftrag.RadioButton1Click(Sender: TObject);
begin
  if RadioChangeDetect then
    EnsureEditState;
end;

procedure TFormAuftrag.RadioButton2Click(Sender: TObject);
begin
  if RadioChangeDetect then
    EnsureEditState;
end;

procedure TFormAuftrag.RadioButton3Click(Sender: TObject);
begin
  if RadioChangeDetect then
    EnsureEditState;
end;

procedure TFormAuftrag.IB_Query1AfterCancel(IB_Dataset: TIB_Dataset);
begin
  // wieder die alten Daten reflektieren
  ReflectTheQueryData;
end;

procedure TFormAuftrag.ReflectQuality;
begin
  // Ticket Sachen
  Memo1.lines.clear;
  Memo1.lines.addstrings(FormAuftragArbeitsplatz.getProbleme(IB_Query1.FieldByName('RID').AsInteger));
end;

procedure TFormAuftrag.ReflectTheQueryData;
var
  s: string;
begin
  with IB_Query1 do
  begin
    //
    Label54.Caption := '';
    Label46.Caption := '';
    Label47.Caption := '';
    Label56.Caption := '';
    Label3.Caption := FieldByName('NUMMER').AsString;

    // Urlaub Monteur 1
    if not(FieldByName('MONTEUR1_R').IsNull) then
    begin
      ComboBox1.Text := e_r_MonteurKuerzel(FieldByName('MONTEUR1_R').AsInteger);
    end
    else
      ComboBox1.Text := '';

    // Urlaub Monteur 2
    if not(FieldByName('MONTEUR2_R').IsNull) then
    begin
      ComboBox2.Text := e_r_MonteurKuerzel(FieldByName('MONTEUR2_R').AsInteger);
    end
    else
      ComboBox2.Text := '';

    // Vormittags Nachmittags
    _RadioIgnoreChanges := true;
    s := FieldByName('VORMITTAGS').AsString + ' ';
    case s[1] of
      cVormittagsChar:
        RadioButton1.Checked := true;
      cNachmittagsChar:
        RadioButton2.Checked := true;
    else
      RadioButton3.Checked := true;
    end;
    _RadioAsStr := RadioAsStr;
    _RadioIgnoreChanges := false;

    // Quality
    if (PageControl1.ActivePage = TabSheet9) then
      ReflectQuality;
  end;
end;

procedure TFormAuftrag.Button2Click(Sender: TObject);
begin
  // auto-post
  if IB_Query1.State = dssEdit then
    IB_Query1.post;

  // next
  close;
  application.processmessages;
  with FormAuftragArbeitsplatz do
  begin
    if DrawGrid1.row < pred(DrawGrid1.RowCount) then
    begin
      DrawGrid1.row := DrawGrid1.row + 1;
      application.processmessages;
      ShowAuftrag;
    end;
  end;
end;

procedure TFormAuftrag.Button1Click(Sender: TObject);
begin
  // auto-post
  if IB_Query1.State = dssEdit then
    IB_Query1.post;
  //
  close;
  application.processmessages;
  with FormAuftragArbeitsplatz do
  begin
    if DrawGrid1.row > 0 then
    begin
      DrawGrid1.row := DrawGrid1.row - 1;
      ShowAuftrag;
    end;
  end;
end;

procedure TFormAuftrag.IB_Date1Strike(Sender: TIB_CustomDate; CheckThisDate: TDateTime; var CrossColor: TColor);
begin
  CrossColor := _Sperre.CheckIt(CheckThisDate, Kontext);
end;

procedure TFormAuftrag.FormCreate(Sender: TObject);
begin
  _Sperre := TSperre.create;
  PageControl1.ActivePage := TabSheet1;
  KeySaver := TStringList.create;
end;

procedure TFormAuftrag.Button4Click(Sender: TObject);
var
  SourceRID: integer;
  NewRID: integer;
begin
  SourceRID := IB_Query1.FieldByName('RID').AsInteger;
  if (SourceRID >= cRID_FirstValid) then
    if doit('Soll eine Kopie dieses Datensatzes angelegt werden') then
    begin
      close;
      BeginHourGlass;

      // Kopie des Datensatzes erzeugen!
      NewRID := RecordCopy('AUFTRAG', 'GEN_AUFTRAG', SourceRID);

      // Numero und MASTER_R anpassen!
      e_x_sql('UPDATE AUFTRAG SET ' + 'MASTER_R=' + inttostr(NewRID) + ', ' + 'NUMMER=0 ' + 'WHERE (RID=' +
        inttostr(NewRID) + ')');

      // Jetzt noch auf NewRID lokalisieren und öffnen
      FormAuftragArbeitsplatz.add(NewRID);
      FormAuftragArbeitsplatz.ShowAuftrag;

      EndHourGlass;

    end;
end;

procedure TFormAuftrag.Button5Click(Sender: TObject);
begin
  if doit('Auftragszeile löschen') then
  begin
    e_w_AuftragDelete(IB_Query1.FieldByName('MASTER_R').AsInteger);
    close;
    with FormAuftragArbeitsplatz do
    begin
      InvalidateCache_Auftrag;
      DrawGrid1.refresh;
    end;
  end;
end;

procedure TFormAuftrag.IB_Date1ButtonClick(Sender: TObject);
var
  Monteur_R: integer;
  Sperre_Von: TDate;
  Sperre_bis: TDate;
  Zeitraum_Von: TDate;
  Zeitraum_bis: TDate;
  Umstand: TStringList;
  BAUSTELLE_R: integer;
begin
  Umstand := TStringList.create;

  _Sperre.clear;

  BAUSTELLE_R := IB_Query1.FieldByName('BAUSTELLE_R').AsInteger;

  // M1
  Monteur_R := e_r_MonteurRIDFromKuerzel(ComboBox1.Text);
  if (Monteur_R <> -1) then
  begin
    e_r_MonteurUrlaub(Monteur_R, _Sperre);
    Umstand.add(ComboBox1.Text);
  end;

  // M2
  Monteur_R := e_r_MonteurRIDFromKuerzel(ComboBox2.Text);
  if (Monteur_R <> -1) then
  begin
    e_r_MonteurUrlaub(Monteur_R, _Sperre);
    Umstand.add(ComboBox2.Text);
  end;

  // Baustellen Sperre
  Kontext := e_r_BaustelleAddSperre(BAUSTELLE_R, Umstand, _Sperre);

  // Zähler Sperre
  Sperre_Von := IB_Date2.Field.AsDateTime;
  Sperre_bis := IB_Date3.Field.AsDateTime;

  if DateOK(DateTime2long(Sperre_Von)) and DateOK(DateTime2long(Sperre_bis)) then
    _Sperre.add(Sperre_Von, Sperre_bis, true, cSperreZaehler, cPrio_ZaehlerSperre);

  // Zähler Wunschzeitraum
  Zeitraum_Von := IB_Date6.Field.AsDateTime;
  Zeitraum_bis := IB_Date7.Field.AsDateTime;

  if DateOK(DateTime2long(Zeitraum_Von)) and DateOK(DateTime2long(Zeitraum_bis)) then
    _Sperre.add(Zeitraum_Von, Zeitraum_bis, false, cSperreZaehler, cPrio_ZaehlerSperre);

  if DebugMode then
    _Sperre.SaveToFile(DiagnosePath + 'Sperre-Auftrag.csv');
  Umstand.Free;
end;

procedure TFormAuftrag.IB_Edit3Change(Sender: TObject);
begin
  if (IB_Edit3.Text = '') and not(IB_Query1.FieldByName('KUNDE_NAME1').IsNull) then
    IB_Query1.FieldByName('KUNDE_NAME1').clear;
end;

procedure TFormAuftrag.IB_Edit5DblClick(Sender: TObject);
begin
  AppendStringsToFile(
    { } IB_Query1.FieldByName('KUNDE_STRASSE').AsString + ';' +
    { } IB_Query1.FieldByName('STRASSE').AsString,
    { } AnwenderPath + cStrassenFName);
end;

procedure TFormAuftrag.IB_Memo1Change(Sender: TObject);
begin
  with Sender as TIB_Memo do
    if (lines.count = 0) then
      DataSource.Dataset.FieldByName(DataField).clear;

end;

procedure TFormAuftrag.IB_Memo2Change(Sender: TObject);
begin
  with Sender as TIB_Memo do
    if (lines.count = 0) then
      DataSource.Dataset.FieldByName(DataField).clear;
end;

procedure TFormAuftrag.IB_Memo3Change(Sender: TObject);
begin
  with Sender as TIB_Memo do
    if (lines.count = 0) then
      DataSource.Dataset.FieldByName(DataField).clear;

end;

procedure TFormAuftrag.IB_Memo4Change(Sender: TObject);
begin
  with Sender as TIB_Memo do
    if (lines.count = 0) then
      DataSource.Dataset.FieldByName(DataField).clear;
end;

procedure TFormAuftrag.IB_Memo4DblClick(Sender: TObject);
var
  BAUSTELLE_R: integer;
  AUFTRAG_R: integer;
  FotoDir: string;
  Settings: TStringList;

  function InfoStr(FotoParameter: string): string;
  var
    FotoFName, _FotoFName: string;
    FotoPath: string;
  begin
    FotoFname :=
    { } e_r_FotoName(
      { } AUFTRAG_R,
      { } FotoParameter,
      { } IB_Memo4.lines.Values[FotoParameter]);
    repeat

     if FileExists(FotoDir + nextp(FotoFname, ',', 0)) then
     begin
      FotoFname := FotoFname + ' OK!';
      break;
     end;

     _FotoFName :=
    { } e_r_FotoName(
      { } AUFTRAG_R,
      { } FotoParameter,
      { } IB_Memo4.lines.Values[FotoParameter],
      {} cFoto_Option_ZaehlernummerNeuLeer);
     if (_FotoFName<>FotoFName) then
      if FileExists(FotoDir + nextp(_FotoFName, ',', 0)) then
      begin
       FileMove(FotoDir + nextp(_FotoFName, ',', 0), FotoDir + nextp(FotoFName, ',', 0));
       FotoFname := FotoFname + ' OK!';
       break;
      end;

      FotoFName := FotoFname + ' ERROR: In "' + FotoDir + '" fehlt die Datei!';

    until yet;

    result :=
    { } FotoParameter + '=' +
    { } FotoFname;

  end;

begin
  AUFTRAG_R := IB_Query1.FieldByName('RID').AsInteger;
  BAUSTELLE_R := IB_Query1.FieldByName('BAUSTELLE_R').AsInteger;

  Settings := e_r_sqlt('select EXPORT_EINSTELLUNGEN from BAUSTELLE where RID=' + inttostr(BAUSTELLE_R));

  FotoDir :=
  { } FotoPath +
  { } e_r_BaustellenPfad(Settings) + '\';

  ShowMessage(FotoDir + #13 +
    { } InfoStr('FA') + #13 +
    { } InfoStr('FN') + #13 +
    { } InfoStr('FH'));

  Settings.Free;
end;

procedure TFormAuftrag.IB_Memo5Change(Sender: TObject);
begin
  with Sender as TIB_Memo do
    if (lines.count = 0) then
      DataSource.Dataset.FieldByName(DataField).clear;

end;

procedure TFormAuftrag.IB_Memo6Change(Sender: TObject);
begin
  with Sender as TIB_Memo do
    if (lines.count = 0) then
      DataSource.Dataset.FieldByName(DataField).clear;

end;

procedure TFormAuftrag.IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
begin
  AuftragBeforePost(IB_Dataset);
  if HistorischerErzeugt then
    FormAuftragArbeitsplatz.HistorischeFlash;
end;

procedure TFormAuftrag.FormDeactivate(Sender: TObject);
begin
  SaveKeysaver;
end;

procedure TFormAuftrag.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (KeySaver.count > 0) then
    if (length(KeySaver[pred(KeySaver.count)]) > 0) then
      KeySaver.add('');
end;

procedure TFormAuftrag.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  MxResult: integer;
begin
  CanClose := (IB_Query1.State <> dssEdit) and (IB_Query1.State <> dssInsert);
  if not(CanClose) then
  begin
    BringToFront;
    MxResult := YesNoCancel('Jetzt speichern');
    case MxResult of
      IDYES:
        begin
          IB_Query1.post;
          CanClose := true;
        end;
      IDNO:
        begin
          IB_Query1.cancel;
          CanClose := true;
        end;
      IDCANCEL:
        ;
    end;
  end;
end;

procedure TFormAuftrag.Button7Click(Sender: TObject);
begin
  IB_Query1.FieldByName('ZAEHLER_WECHSEL').clear;
end;

procedure TFormAuftrag.Button8Click(Sender: TObject);
var
  PhoneInfo: TStringList;
begin
  with IB_Query1 do
  begin
    PhoneInfo := TStringList.create;
    FieldByName('INTERN_INFO').AssignTo(PhoneInfo);
    PhoneInfo.add('CALL=' + datum + ';' + secondstostr(SecondsGet) + ';' + FormBearbeiter.sBearbeiterKurz);
    FieldByName('INTERN_INFO').assign(PhoneInfo);
    PhoneInfo.Free;
  end;
end;

procedure TFormAuftrag.setStatusRestant;
begin
  if (IB_Query1.FieldByName('STATUS').AsInteger <> cs_Restant) then
  begin
    EnsureEditState;
    IB_Query1.FieldByName('STATUS').AsInteger := cs_Restant;
  end;
end;

procedure TFormAuftrag.setStatusUnmoeglich;
begin
  if (IB_Query1.FieldByName('STATUS').AsInteger <> ord(ctsUnmoeglich)) then
  begin
    EnsureEditState;
    IB_Query1.FieldByName('STATUS').AsInteger := ord(ctsUnmoeglich);
  end;
end;

procedure TFormAuftrag.setStatusErledigt;
begin
  if (IB_Query1.FieldByName('STATUS').AsInteger <> ord(ctsErfolg)) then
  begin
    EnsureEditState;
    if (IB_Query1.FieldByName('ZAEHLER_WECHSEL').IsNull) then
      IB_Query1.FieldByName('ZAEHLER_WECHSEL').AsDate := now;
    IB_Query1.FieldByName('STATUS').AsInteger := ord(ctsErfolg);
  end;
end;

procedure TFormAuftrag.setStatusNormal;
begin
  if (IB_Query1.FieldByName('STATUS').AsInteger <> ord(ctsMonteurinformiert)) then
  begin
    EnsureEditState;
    IB_Query1.FieldByName('ZAEHLER_WECHSEL').clear;
    IB_Query1.FieldByName('STATUS').AsInteger := ord(ctsMonteurinformiert);
  end;
end;

procedure TFormAuftrag.IB_Edit28GetDisplayText(Sender: TObject; var AString: string);
begin
  AString := secondstostr(strtointdef(AString, 0));

end;

procedure TFormAuftrag.IB_Edit28GetEditText(Sender: TObject; var AString: string);
begin
  AString := secondstostr(strtointdef(AString, 0));

end;

procedure TFormAuftrag.IB_Edit28IsValidChar(Sender: TObject; var AChar: Char; var IsValid: Boolean);
begin
  if (AChar = ':') then
    IsValid := true;
end;

procedure TFormAuftrag.IB_Edit28SetEditText(Sender: TObject; var AString: string);
begin
  AString := inttostr(strtoseconds(AString));
end;

procedure TFormAuftrag.setStatusNeuAnschreiben;
begin
  if (IB_Query1.FieldByName('STATUS').AsInteger <> ord(ctsNeuAnschreiben)) then
  begin
    EnsureEditState;
    IB_Query1.FieldByName('STATUS').AsInteger := ord(ctsNeuAnschreiben);
  end;
end;

procedure TFormAuftrag.Button9Click(Sender: TObject);
var
  InternalP: TStringList;
begin
  with IB_Query1 do
  begin
    // Zählerstand
    InternalP := TStringList.create;
    FieldByName('ZAEHLER_INFO').AssignTo(InternalP);
    FieldByName('ZAEHLER_STAND_ALT').AsString :=
      inttostr(max((strtoint64def(InternalP.Values['P0'], 0) + strtoint64def(InternalP.Values['P1'], 0)) div 2,
      strtointdef(FieldByName('VERBRAUCH_ZAEHLER_STAND').AsString, 0)));
    InternalP.Free;
    // Ausführungsdatum
    FieldByName('ZAEHLER_WECHSEL').AsDate := FieldByName('AUSFUEHREN').AsDate;
  end;
end;

procedure TFormAuftrag.SpeedButton10Click(Sender: TObject);
var
  Protokoll: TStringList;
  AusbelichtetesProtokoll: THTMLTemplate;
  ProtokollName: string;
begin
  Protokoll := TStringList.create;
  with IB_Query1 do
  begin
    FieldByName('PROTOKOLL').AssignTo(Protokoll);
    ProtokollName := e_r_BaustelleProtokollName(FieldByName('RID').AsInteger, FieldByName('BAUSTELLE_R').AsInteger);
    Protokoll.add('Titel=' + e_r_BaustelleKuerzel(FieldByName('BAUSTELLE_R').AsInteger) + '-' +
      inttostrN(FieldByName('NUMMER').AsInteger, cAuftragsNummer_Length));
  end;
  AusbelichtetesProtokoll := pem_toHTML(HtmlVorlagenPath + 'PEM.html', ProtokollePath + ProtokollName, Protokoll);
  AusbelichtetesProtokoll.SaveToFile(AnwenderPath + ProtokollName + '.raw.html');
  AusbelichtetesProtokoll.SaveToFileCompressed(AnwenderPath + ProtokollName + '.html');
  openShell(AnwenderPath + ProtokollName + '.html');
  Protokoll.Free;
  AusbelichtetesProtokoll.Free;
end;

procedure TFormAuftrag.SpeedButton11Click(Sender: TObject);
var
  ProtokollName: string;
begin
  // Einfach nur das Protokoll laden
  with IB_Query1 do
  begin
    ProtokollName := e_r_BaustelleProtokollName(FieldByName('RID').AsInteger, FieldByName('BAUSTELLE_R').AsInteger);
  end;
  openShell(ProtokollePath + ProtokollName + cProtExtension);
end;

procedure TFormAuftrag.SpeedButton12Click(Sender: TObject);
begin
  openShell(ProtokollePath);
end;

procedure TFormAuftrag.SpeedButton13Click(Sender: TObject);
var
  PhoneInfo: TStringList;
begin
  with IB_Query1 do
  begin
    PhoneInfo := TStringList.create;
    FieldByName('INTERN_INFO').AssignTo(PhoneInfo);
    PhoneInfo.add('QS_NOGO=' + datum + ';' + secondstostr(SecondsGet) + ';' + FormBearbeiter.sBearbeiterKurz);
    FieldByName('INTERN_INFO').assign(PhoneInfo);
    PhoneInfo.Free;
  end;
end;

procedure TFormAuftrag.SpeedButton1Click(Sender: TObject);
begin
  FormAuftragAssist.setContext(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormAuftrag.setStatusVorgezogen;
begin
  if (IB_Query1.FieldByName('STATUS').AsInteger <> ord(ctsVorgezogen)) then
  begin
    EnsureEditState;
    IB_Query1.FieldByName('STATUS').AsInteger := ord(ctsVorgezogen);
  end;
end;

procedure TFormAuftrag.Button6Click(Sender: TObject);
begin
  try
    SaveKeysaver;
    openShell(AnwenderPath + cTasteFName);
  except
  end;
end;

procedure TFormAuftrag.SaveKeysaver;
begin
  try
    if (KeySaver.count > 0) then
    begin
      BeginHourGlass;
      KeySaver.add('----------- ' + datum + ' ----- ' + uhr8 + ' ----------------------------------------');
      KeySaver.add('');
      AppendStringsToFile(KeySaver, AnwenderPath + cTasteFName);
      FileLimitTo(AnwenderPath + cTasteFName, 256 * 1024);
      KeySaver.clear;
      EndHourGlass;
    end;
  except
  end;
end;

procedure TFormAuftrag.SpeedButton3Click(Sender: TObject);
var
  p: TPoint2D;
  GeoCache: TGeoCache;
begin

  // neu lokalisieren?!
  BeginHourGlass;
  GeoCache := TGeoCache.create;
  with IB_Query1 do
  begin
    FormGeoLokalisierung.locate(FieldByName('KUNDE_STRASSE').AsString, FieldByName('KUNDE_ORT').AsString,
      FieldByName('KUNDE_ORTSTEIL').AsString, p);
    GeoCache.add(p, FieldByName('RID').AsInteger, cPunkt_rot, 0, true);
  end;
  EndHourGlass;

  // auf dem Geoarbeitsplatz rot anzeigen!
  FormGeoArbeitsplatz.showMap(GeoCache);

end;

procedure TFormAuftrag.SpeedButton4Click(Sender: TObject);
var
  slSchritte: TStringList;
begin
  // refresh der Auftrags-Schritte
  slSchritte := e_r_Schritte(IB_Query1.FieldByName('RID').AsInteger);
  ListBox1.items.addstrings(slSchritte);
  slSchritte.Free;
end;

procedure TFormAuftrag.SpeedButton5Click(Sender: TObject);
const
  cAbstandMax = 100;
var
  cLIST: TIB_Cursor;
  POI, LOC: TPoint2D;

  datum: TAnfixDate;
  AUFTRAG_R: integer;
  BAUSTELLE_R: integer;
  POSTLEITZAHLEN_R: integer;
  Abstand: double;
begin
  BeginHourGlass;

  // Parameter ermitteln
  with IB_Query1 do
  begin
    datum := DateTime2long(FieldByName('AUSFUEHREN').AsDate);
    AUFTRAG_R := FieldByName('RID').AsInteger;
    BAUSTELLE_R := FieldByName('BAUSTELLE_R').AsInteger;
    POSTLEITZAHLEN_R := FieldByName('POSTLEITZAHL_R').AsInteger;
  end;

  // POI lesen
  cLIST := DataModuleDatenbank.nCursor;
  with cLIST do
  begin
    sql.add('select X,Y from POSTLEITZAHLEN where RID=' + inttostr(POSTLEITZAHLEN_R));
    ApiFirst;
    POI.x := FieldByName('X').AsDouble;
    POI.y := FieldByName('Y').AsDouble;
  end;
  cLIST.Free;

  // Nun alle Abstände bestimmen
  Abstand := cAbstandMax;
  cLIST := DataModuleDatenbank.nCursor;
  with cLIST do
  begin
    sql.add('select X,Y');
    sql.add('from AUFTRAG');
    sql.add('join POSTLEITZAHLEN on');
    sql.add(' (POSTLEITZAHLEN.RID=AUFTRAG.POSTLEITZAHL_R)');
    sql.add('where');
    sql.add(' (AUFTRAG.BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') and');
    sql.add(' (AUFTRAG.AUSFUEHREN=''' + long2date(datum) + ''') and');
    sql.add(' (AUFTRAG.STATUS IN (' + inttostr(cs_Terminiert) + ',' + inttostr(cs_Angeschrieben) + ',' +
      inttostr(cs_Monteurinformiert) + ',' + inttostr(cs_Restant) + ')) and');
    sql.add(' (AUFTRAG.RID<>' + inttostr(AUFTRAG_R) + ')');
    ApiFirst;
    while not(eof) do
    begin
      LOC.x := FieldByName('X').AsDouble;
      LOC.y := FieldByName('Y').AsDouble;
      if inDE(LOC) then
        Abstand := min(Abstand, DistanceEarth(POI, LOC));
      ApiNext;
    end;
  end;
  cLIST.Free;
  EndHourGlass;

  ShowMessage(format('Abstand: %.3f km', [Abstand]));

end;

procedure TFormAuftrag.SpeedButton2Click(Sender: TObject);
var
  PhoneInfo: TStringList;
begin
  if IB_Query1.FieldByName('EXPORT_TAN').IsNotNull then
  begin
    IB_Query1.FieldByName('EXPORT_TAN').clear;
    PhoneInfo := TStringList.create;
    IB_Query1.FieldByName('INTERN_INFO').AssignTo(PhoneInfo);
    PhoneInfo.add('UNGEMELDET=' + datum + ';' + secondstostr(SecondsGet) + ';' + FormBearbeiter.sBearbeiterKurz);
    IB_Query1.FieldByName('INTERN_INFO').assign(PhoneInfo);
    PhoneInfo.Free;
  end;
end;

procedure TFormAuftrag.SpeedButton6Click(Sender: TObject);
var
  PhoneInfo: TStringList;
begin
  IB_Query1.FieldByName('EXPORT_TAN').AsInteger := 0;
  PhoneInfo := TStringList.create;
  IB_Query1.FieldByName('INTERN_INFO').AssignTo(PhoneInfo);
  PhoneInfo.add('GEMELDET=' + datum + ';' + secondstostr(SecondsGet) + ';' + FormBearbeiter.sBearbeiterKurz);
  IB_Query1.FieldByName('INTERN_INFO').assign(PhoneInfo);
  PhoneInfo.Free;

  with IB_Query1 do
    clipboard.AsText := FieldByName('ART').AsString + '-' + FieldByName('ZAEHLER_NUMMER').AsString + ';' +
      FieldByName('ZAEHLER_STAND_ALT').AsString + ';' + FieldByName('ZAEHLER_STAND_NEU').AsString + ';' +
      FieldByName('ZAEHLER_WECHSEL').AsString;

end;

procedure TFormAuftrag.SpeedButton7Click(Sender: TObject);
var
  PhoneInfo: TStringList;
begin
  with IB_Query1 do
  begin
    PhoneInfo := TStringList.create;
    FieldByName('INTERN_INFO').AssignTo(PhoneInfo);
    PhoneInfo.add('QS_UMGANGEN=' + datum + ';' + secondstostr(SecondsGet) + ';' + FormBearbeiter.sBearbeiterKurz);
    FieldByName('INTERN_INFO').assign(PhoneInfo);
    PhoneInfo.Free;
  end;

end;

procedure TFormAuftrag.SpeedButton8Click(Sender: TObject);
var
  AttachementFName: string;
  qMAIL: TIB_Query;
  eMessage: TStringList;
  Monteur_R: integer;
begin
  BeginHourGlass;

  Monteur_R := IB_Query1.FieldByName('MONTEUR1_R').AsInteger;

  if (Monteur_R >= cRID_FirstValid) then
  begin
    AttachementFName := FormAuftragArbeitsplatz.AsHTML(IB_Query1.FieldByName('RID').AsInteger,
      IB_Query1.FieldByName('BAUSTELLE_R').AsInteger);

    if (AttachementFName <> '') then
    begin

      qMAIL := DataModuleDatenbank.nQuery;
      eMessage := TStringList.create;

      // eMail Antrag in die Datenbank stellen!

      // Nachrichten Text dieser eMail zusammenbauen
      with eMessage do
      begin
        add('Info zum Auftrag ' +
          { Baustelle } e_r_BaustelleKuerzel(IB_Query1.FieldByName('BAUSTELLE_R').AsInteger) +
          { - } '-' +
          { ABNummer } inttostrN(IB_Query1.FieldByName('NUMMER').AsInteger, cAuftragsNummer_Length) +
          { Zeitstempel } ' (' + DatumLog + ' ' + uhr8 + ')');
        add('Mit freundlichen Grüssen');
        add('Ihr Auftrags - Team');
        add(datum + ' ' + Uhr);
      end;

      // Den Nachrichten Text jetzt speichern
      with qMAIL do
      begin
        sql.add('select * from EMAIL for update');
        insert;
        FieldByName('RID').AsInteger := cRID_AutoInc;
        FieldByName('NACHRICHT').assign(eMessage);
        FieldByName('DATEI_ANLAGE').AsString := AttachementFName;
        FieldByName('PERSON_R').AsInteger := Monteur_R;
        post;
      end;

      IB_Query1.FieldByName('MONTEUREXPORT').AsDateTime := now;

      eMessage.Free;
      qMAIL.Free;
    end;

  end
  else
  begin
    ShowMessage('Kein Monteur eingetragen!');
  end;

  EndHourGlass;
  // e_w_AuftrageMail(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormAuftrag.SpeedButton9Click(Sender: TObject);
begin
  FormAuftragArbeitsplatz.InvalidateCache_ProblemInfos;
  Memo1.lines.clear;
  Memo1.lines.addstrings(FormAuftragArbeitsplatz.getProbleme(IB_Query1.FieldByName('RID').AsInteger));
end;

procedure TFormAuftrag.TabSheet9Show(Sender: TObject);
begin
  ReflectQuality;
end;

procedure TFormAuftrag.Label2Click(Sender: TObject);
begin
  if doit('Planquadrat-Eintrag löschen', true) then
    IB_Query1.FieldByName('PLANQUADRAT').clear;
end;

procedure TFormAuftrag.Label3Click(Sender: TObject);
begin
  if doit('Auftragsnummer zurücksetzen') then
    IB_Query1.FieldByName('NUMMER').clear;
end;

procedure TFormAuftrag.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
  repeat

    //
    if (Key = '-') then
    begin
      // suche die
    end;

    //
    if (Key = '+') then
    begin

    end;

  until true;
end;

procedure TFormAuftrag.Button10Click(Sender: TObject);
begin
  with IB_Query1 do
  begin
    FieldByName('POSTLEITZAHL_R').clear;
    if CheckBox1.Checked then
      FieldByName('KUNDE_ORTSTEIL').clear;
  end;
end;

procedure TFormAuftrag.Button11Click(Sender: TObject);
var
  POSTLEITZAHL_R: integer;
  p: TPoint2D;
begin
  BeginHourGlass;

  // Alte Referenzen aufheben
  with IB_Query1 do
  begin

    POSTLEITZAHL_R := FieldByName('POSTLEITZAHL_R').AsInteger;

    if (POSTLEITZAHL_R > 0) then
    begin
      close;
      e_w_unlocate(POSTLEITZAHL_R);
      Open;
    end;

    // referenzen wieder eintragen
    POSTLEITZAHL_R := FormGeoLokalisierung.locate(FieldByName('KUNDE_STRASSE').AsString,
      FieldByName('KUNDE_ORT').AsString, FieldByName('KUNDE_ORTSTEIL').AsString, p);

    Label54.Caption := FormGeoLokalisierung.r_Strasse;
    Label46.Caption := FormGeoLokalisierung.r_plz + ' ' + FormGeoLokalisierung.r_Ort;
    Label47.Caption := FormGeoLokalisierung.r_ortsteil;
    Label56.Caption := FormGeoLokalisierung.r_Error;

    EndHourGlass;

    // Ergebnis eintragen
    if (POSTLEITZAHL_R > 0) then
    begin
      edit;

      // Geo-Referenz eintragen
      FieldByName('POSTLEITZAHL_R').AsInteger := POSTLEITZAHL_R;

      // neues Ortsteil eintragen
      if (FieldByName('KUNDE_ORTSTEIL').AsString = '') or CheckBox1.Checked then
        FieldByName('KUNDE_ORTSTEIL').AsString := FormGeoLokalisierung.r_ortsteil;

      // PLZ ergänzen
      if FormGeoLokalisierung.q_PLZ = cImpossiblePLZ then
      begin
        if (FieldByName('KUNDE_ORT').AsString = FieldByName('BRIEF_ORT').AsString) then
        begin
          FieldByName('BRIEF_ORT').AsString := FormGeoLokalisierung.r_plz + ' ' +
            cutblank(FieldByName('KUNDE_ORT').AsString);
          FieldByName('KUNDE_ORT').AsString := FormGeoLokalisierung.r_plz + ' ' +
            cutblank(FieldByName('KUNDE_ORT').AsString);
        end
        else
        begin
          FieldByName('KUNDE_ORT').AsString := FormGeoLokalisierung.r_plz + ' ' +
            cutblank(FieldByName('KUNDE_ORT').AsString);
        end;
      end;
    end
    else
    begin
      beep;
    end;
  end;
end;

procedure TFormAuftrag.Button12Click(Sender: TObject);
var
  Ort, PLZ: string;
  cORTE: TIB_Cursor;
  ResultList: TStringList;
begin
  ResultList := TStringList.create;
  Ort := IB_Query1.FieldByName('KUNDE_ORT').AsString;
  PLZ := nextp(Ort, ' ', 0);
  Ort := nextp(Ort, ' ', 1);
  cORTE := DataModuleDatenbank.nCursor;
  with cORTE do
  begin
    sql.add('select distinct ORT,ORTSTEIL from POSTLEITZAHLEN where PLZ=' + PLZ);
    ApiFirst;
    while not(eof) do
    begin
      ResultList.add(PLZ + ' ' + FieldByName('ORT').AsString + ' ' + FieldByName('ORTSTEIL').AsString);
      ApiNext;
    end;
  end;
  cORTE.Free;
  ShowMessage(HugeSingleLine(ResultList));
  ResultList.Free;
end;

procedure TFormAuftrag.Button13Click(Sender: TObject);
var
  sQS: string;
begin
  sQS := e_r_AuftragPlausi(IB_Query1.FieldByName('RID').AsInteger);
  with Memo1.lines do
  begin
    clear;
    while (sQS <> '') do
      add(nextp(sQS, cOLAPcsvLineBreak));
  end;
end;

procedure TFormAuftrag.Button14Click(Sender: TObject);
begin
  FormGeoLokalisierung.SetDiagMode;
  Button11Click(Sender);
  FormGeoLokalisierung.UnSetDiagMode;
end;

procedure TFormAuftrag.Button15Click(Sender: TObject);
begin
  clipboard.AsText := Trim(IB_Text5.Caption);
end;

procedure TFormAuftrag.Button16Click(Sender: TObject);
var
  FName: string;
begin
  FName := FormAuftragArbeitsplatz.AsHTML(IB_Query1.FieldByName('RID').AsInteger, IB_Query1.FieldByName('BAUSTELLE_R')
    .AsInteger);
  if (FName <> '') then
    openShell(FName);
end;

procedure TFormAuftrag.Image3Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Auftrag');
end;

procedure TFormAuftrag.Image4Click(Sender: TObject);
begin
  with IB_Query1 do
    wanfix32.openShell('http://maps.google.de/maps?q=' + AnsiToRFC1738(FieldByName('KUNDE_ORT').AsString + ', ' +
      FieldByName('KUNDE_STRASSE').AsString));
end;

procedure TFormAuftrag.SpeedButton19Click(Sender: TObject);
begin
  with IB_Query1 do
    clipboard.AsText :=
    { } StrassePostalisch(FieldByName('KUNDE_STRASSE').AsString) + ', ' +
    { } FieldByName('KUNDE_ORT').AsString;
end;

procedure TFormAuftrag.Image5Click(Sender: TObject);
var
  s: string;
begin
  with IB_Query1 do
  begin
    s :=
    { } StrassePostalisch(FieldByName('KUNDE_STRASSE').AsString) + ', ' +
    { } FieldByName('KUNDE_ORT').AsString;

    ersetze('ü', 'ue', s);
    ersetze('ö', 'oe', s);
    ersetze('ä', 'ae', s);
    ersetze('Ü', 'Ue', s);
    ersetze('Ö', 'Oe', s);
    ersetze('Ä', 'Ae', s);
    ersetze('ß', 'ss', s);

    wanfix32.openShell('http://nominatim.openstreetmap.org/search.php?q=' + AnsiToRFC1738(s));
  end;
end;

procedure TFormAuftrag.JvImgBtn1Click(Sender: TObject);
begin
  setStatusNormal;
end;

procedure TFormAuftrag.JvImgBtn2Click(Sender: TObject);
begin
  setStatusNeuAnschreiben;
end;

procedure TFormAuftrag.JvImgBtn3Click(Sender: TObject);
begin
  setStatusRestant;
end;

procedure TFormAuftrag.JvImgBtn4Click(Sender: TObject);
begin
  setStatusErledigt;
end;

procedure TFormAuftrag.JvImgBtn5Click(Sender: TObject);
begin
  setStatusVorgezogen;
end;

procedure TFormAuftrag.JvImgBtn6Click(Sender: TObject);
begin
  setStatusUnmoeglich;
end;

end.
