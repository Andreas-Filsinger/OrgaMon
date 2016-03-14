{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2015  Andreas Filsinger
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
unit Person;
//
// rund um die Person
//

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, Grids,
  StdCtrls, Mask,

  // Tools
  gplists,

  // IB-Objects
  IB_Access,
  IB_Components,
  IB_Grid,

  // HeBuAdmin-Projekt
  Buttons,
  JvGIF, JvExExtCtrls, JvRadioGroup,
  CheckLst, IB_NavigationBar, IB_SearchBar, IB_Controls, ComCtrls, ExtCtrls,
  IB_UpdateBar, ToolWin, IB_EditButton;

type
  TFormPerson = class(TForm)
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    IB_Query2: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    IB_Grid2: TIB_Grid;
    IB_Edit13: TIB_Edit;
    IB_Edit14: TIB_Edit;
    IB_Edit15: TIB_Edit;
    Label13: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    IB_Edit17: TIB_Edit;
    IB_Edit18: TIB_Edit;
    IB_Edit19: TIB_Edit;
    Label17: TLabel;
    IB_Edit20: TIB_Edit;
    IB_Text3: TIB_Text;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    IB_Edit1: TIB_Edit;
    IB_Edit2: TIB_Edit;
    TabSheet2: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    IB_Edit4: TIB_Edit;
    IB_Edit5: TIB_Edit;
    IB_Edit6: TIB_Edit;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    IB_Edit7: TIB_Edit;
    IB_Edit8: TIB_Edit;
    IB_Edit10: TIB_Edit;
    Label19: TLabel;
    IB_Edit11: TIB_Edit;
    TabSheet3: TTabSheet;
    IB_Text1: TIB_Text;
    Label3: TLabel;
    IB_Edit3: TIB_Edit;
    IB_Query3: TIB_Query;
    IB_DataSource3: TIB_DataSource;
    IB_Grid3: TIB_Grid;
    Label21: TLabel;
    IB_Text2: TIB_Text;
    Button2: TButton;
    TabSheet5: TTabSheet;
    Label9: TLabel;
    IB_Edit9: TIB_Edit;
    IB_Edit22: TIB_Edit;
    IB_Edit23: TIB_Edit;
    IB_Memo2: TIB_Memo;
    Label22: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Button17: TButton;
    Label27: TLabel;
    Label28: TLabel;
    IB_Edit25: TIB_Edit;
    IB_Edit24: TIB_Edit;
    Label29: TLabel;
    IB_Edit26: TIB_Edit;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    Label30: TLabel;
    IB_Edit27: TIB_Edit;
    Label31: TLabel;
    Label32: TLabel;
    IB_Query5: TIB_Query;
    IB_DataSource4: TIB_DataSource;
    IB_Grid4: TIB_Grid;
    IB_UpdateBar3: TIB_UpdateBar;
    IB_Edit28: TIB_Edit;
    IB_Query6: TIB_Query;
    IB_DataSource5: TIB_DataSource;
    Button3: TButton;
    IB_Grid5: TIB_Grid;
    Button6: TButton;
    Label33: TLabel;
    TabSheet8: TTabSheet;
    Label11: TLabel;
    IB_CheckBox3: TIB_CheckBox;
    IB_Edit12: TIB_Edit;
    Label18: TLabel;
    Label24: TLabel;
    IB_ComboBox1: TIB_ComboBox;
    IB_Text4: TIB_Text;
    StaticText5: TStaticText;
    Label20: TLabel;
    Label23: TLabel;
    Label34: TLabel;
    IB_Date1: TIB_Date;
    IB_Edit21: TIB_Edit;
    IB_Edit29: TIB_Edit;
    TabSheet4: TTabSheet;
    IB_Memo1: TIB_Memo;
    Label35: TLabel;
    Label36: TLabel;
    IB_Edit16: TIB_Edit;
    IB_Edit30: TIB_Edit;
    TabSheet9: TTabSheet;
    Label38: TLabel;
    IB_Edit31: TIB_Edit;
    IB_Edit32: TIB_Edit;
    IB_Edit33: TIB_Edit;
    IB_Edit34: TIB_Edit;
    IB_Edit35: TIB_Edit;
    IB_Edit36: TIB_Edit;
    IB_Edit37: TIB_Edit;
    IB_Edit38: TIB_Edit;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    IB_ComboBox2: TIB_ComboBox;
    SpeedButton3: TSpeedButton;
    IB_CheckBox24: TIB_CheckBox;
    Label47: TLabel;
    Label48: TLabel;
    IB_Edit39: TIB_Edit;
    IB_Edit40: TIB_Edit;
    Button8: TButton;
    IB_SearchBar3: TIB_SearchBar;
    IB_NavigationBar3: TIB_NavigationBar;
    Button9: TButton;
    Button10: TButton;
    Label49: TLabel;
    IB_Edit41: TIB_Edit;
    Label12: TLabel;
    SpeedButton4: TSpeedButton;
    IB_SearchBar2: TIB_SearchBar;
    IB_NavigationBar2: TIB_NavigationBar;
    IB_UpdateBar2: TIB_UpdateBar;
    SpeedButton5: TSpeedButton;
    SpeedButton17: TSpeedButton;
    TabSheet10: TTabSheet;
    Button19: TButton;
    TabSheet11: TTabSheet;
    StaticText1: TStaticText;
    Edit2: TEdit;
    Label14: TLabel;
    Edit3: TEdit;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    StaticText2: TStaticText;
    Label53: TLabel;
    StaticText3: TStaticText;
    SpeedButton9: TSpeedButton;
    SpeedButton15: TSpeedButton;
    OpenDialog1: TOpenDialog;
    Button21: TButton;
    SpeedButton10: TSpeedButton;
    Image1: TImage;
    TabSheet12: TTabSheet;
    Label54: TLabel;
    IB_Edit42: TIB_Edit;
    Edit4: TEdit;
    Button20: TButton;
    Label55: TLabel;
    IB_Edit43: TIB_Edit;
    Button15: TButton;
    Image3: TImage;
    Label56: TLabel;
    Button22: TButton;
    Button23: TButton;
    Button24: TButton;
    Button25: TButton;
    Button26: TButton;
    Edit5: TEdit;
    ComboBox5: TComboBox;
    SpeedButton14: TSpeedButton;
    IB_CheckBox25: TIB_CheckBox;
    CheckListBox1: TCheckListBox;
    SpeedButton8: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton16: TSpeedButton;
    IB_UpdateBar1: TIB_UpdateBar;
    SpeedButton7: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton11: TSpeedButton;
    Button7: TButton;
    Button11: TButton;
    Button13: TButton;
    Button14: TButton;
    Button1: TButton;
    Button16: TButton;
    Button4: TButton;
    Button18: TButton;
    Image2: TImage;
    Button5: TButton;
    Edit1: TEdit;
    SpeedButton6: TSpeedButton;
    Label57: TLabel;
    IB_Edit44: TIB_Edit;
    Image4: TImage;
    SpeedButton18: TSpeedButton;
    SpeedButton27: TSpeedButton;
    Label58: TLabel;
    ComboBox1: TComboBox;
    SpeedButton19: TSpeedButton;
    Panel1: TPanel;
    Label37: TLabel;
    IB_CheckBox4: TIB_CheckBox;
    IB_CheckBox5: TIB_CheckBox;
    IB_CheckBox6: TIB_CheckBox;
    IB_CheckBox7: TIB_CheckBox;
    IB_CheckBox8: TIB_CheckBox;
    IB_CheckBox9: TIB_CheckBox;
    IB_CheckBox10: TIB_CheckBox;
    IB_CheckBox11: TIB_CheckBox;
    IB_CheckBox12: TIB_CheckBox;
    IB_CheckBox13: TIB_CheckBox;
    IB_CheckBox14: TIB_CheckBox;
    IB_CheckBox15: TIB_CheckBox;
    IB_CheckBox16: TIB_CheckBox;
    IB_CheckBox17: TIB_CheckBox;
    IB_CheckBox18: TIB_CheckBox;
    IB_CheckBox19: TIB_CheckBox;
    IB_CheckBox20: TIB_CheckBox;
    IB_CheckBox21: TIB_CheckBox;
    IB_CheckBox1: TIB_CheckBox;
    IB_CheckBox2: TIB_CheckBox;
    IB_CheckBox22: TIB_CheckBox;
    IB_CheckBox23: TIB_CheckBox;
    SpeedButton21: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure IB_Edit18Change(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
    procedure Button2Click(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure Button11Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
    procedure IB_Query5BeforeInsert(IB_Dataset: TIB_Dataset);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IB_Query1ConfirmDelete(Sender: TComponent; var Confirmed: Boolean);
    procedure Button18Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton17Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure IB_Query1BeforePrepare(Sender: TIB_Statement);
    procedure IB_Query3BeforePrepare(Sender: TIB_Statement);
    procedure SpeedButton8MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure SpeedButton17MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3Exit(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure IB_Grid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SpeedButton11Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure SpeedButton20Click(Sender: TObject);
    procedure ComboBox5KeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton14Click(Sender: TObject);
    procedure IB_Query1AfterCancel(IB_Dataset: TIB_Dataset);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure SpeedButton16Click(Sender: TObject);
    procedure IB_Grid1GetCellProps(Sender: TObject; ACol, ARow: Integer; AState: TGridDrawState;
      var AColor: TColor; AFont: TFont);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure SpeedButton18Click(Sender: TObject);
    procedure SpeedButton27Click(Sender: TObject);
    procedure IB_Query1AfterDelete(IB_Dataset: TIB_Dataset);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure SpeedButton19Click(Sender: TObject);
    procedure IB_DataSource1StateChanged(Sender: TIB_DataSource; ADataset: TIB_Dataset);
    procedure SpeedButton21Click(Sender: TObject);
  private
    { Private-Deklarationen }
    RefreshBirth: dword;
    Query1_sql: TStringList;
    Query2_sql: TStringList;
    lVertragsVarianten: TgpIntegerList;

    cntReflectPerson: Integer;
    inOLAPmode: Boolean;
    cCOL_PAPERCOLOR: Integer;
    iMacroInitialisiert: Boolean;

    procedure ReflectPerson;
    procedure ReflectLaender;
    procedure AlleAnzeigen;

    function csvAddHeader: TStringList;
    function csvOptions: TStringList;
    function csvAddOne: TStringList;
    procedure csvOne;
    procedure csvSave(PersonList: TList; xlsOptions: TStringList);
    procedure Neu;
    procedure ensureiMacro;
    procedure createiMacro(NameSpace: string);
    procedure dhlSave;

  public
    { Public-Deklarationen }
    InsideImport: Boolean;
    UserBreak: Boolean;
    InsertedByNow: Integer;

    procedure setContext(PERSON_R: Integer);
    function getContext: Integer;
    function TakeActual: Boolean;
    procedure EnsureThatQuerysAreOpen(Refresh: Boolean = true);
    procedure RefreshProfileNames;
    procedure RefreshZahlungtypCombo;
    procedure RefreshWordVorlagen;
    procedure RefreshVertraege;
  end;

var
  FormPerson: TFormPerson;

implementation

uses
  anfix32, globals,

  FlexCel.Core, FlexCel.XLSAdapter,

  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  Funktionen_Buch,
  Funktionen_LokaleDaten,
  WordIndex, Belege, AusgangsRechnungen,
  BBelege, Geld,
  Tier, TierAuswahl, PersonSuche, QAbzeichnen,
  GeoLokalisierung, dbOrgaMon,
  CareTakerClient, FastGeo, GeoArbeitsplatz,
  OLAP, Jvgnugettext,
  Vertrag, ExcelHelper, main,
  OrientationConvert, Kontext, Datenbank,
  DruckSpooler, html, clipbrd,
  wanfix32, GUIHelp,
  ZahlungECconnect;

{$R *.DFM}

procedure TFormPerson.FormActivate(Sender: TObject);
begin
  // Alle 30 Min
  if frequently(RefreshBirth, 30 * 60 * 1000) then
  begin
    BeginHourGlass;
    ReflectLaender;
    RefreshProfileNames;
    RefreshZahlungtypCombo;
    RefreshVertraege;
    RefreshWordVorlagen;
    EndHourGlass;
  end;
  EnsureThatQuerysAreOpen;
end;

procedure TFormPerson.EnsureThatQuerysAreOpen(Refresh: Boolean = true);
begin
  if not(IB_Query3.active) then
    IB_Query3.active := true;
  if not(IB_Query5.active) then
    IB_Query5.active := true;

  if not(IB_Query1.active) then
  begin
    IB_Query1.Open;
    if IB_Query1.IsEmpty then
      ShowMessageTimeOut('Person wurde nicht gefunden!' + #13 +
        'Person eventuell zwischenzeitlich gelöscht!');
  end
  else
  begin
    if Refresh then
      IB_Query1.Refresh;
  end;
end;

procedure TFormPerson.Neu;
begin
  BeginHourGlass;
  IB_Query1.DisableControls;
  IB_Query2.DisableControls;
  setContext(e_w_PersonNeu);
  EnsureThatQuerysAreOpen;
  PageControl1.ActivePage := TabSheet1;
  IB_Edit3.SetFocus;
  IB_Query2.EnableControls;
  IB_Query1.EnableControls;
  EndHourGlass;
end;

procedure TFormPerson.Button7Click(Sender: TObject);
begin
  FormBelege.setContext(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormPerson.IB_DataSource1StateChanged(Sender: TIB_DataSource; ADataset: TIB_Dataset);
begin
  if ADataset.State in [dssedit, dssinsert] then
    Panel1.Color := ADataset.IB_Session.EditingColor
  else
    Panel1.Color := clwindow;
end;

procedure TFormPerson.IB_Edit18Change(Sender: TObject);
begin
  if (length(IB_Edit18.Text) = e_r_PLZlength(IB_Query2)) then
    IB_Query3.ParamByName('CROSSREFERENCE').AsInteger := StrToInt(IB_Edit18.Text);
end;

procedure TFormPerson.Button8Click(Sender: TObject);
begin
  // alles
  IB_Query2.FieldByName('NAME1').assign(IB_Query3.FieldByName('NAME1'));
  IB_Query2.FieldByName('STRASSE').assign(IB_Query3.FieldByName('STRASSE'));
  IB_Query2.FieldByName('ORT').assign(IB_Query3.FieldByName('ORT'));
  IB_Query2.FieldByName('ORTSTEIL').assign(IB_Query3.FieldByName('ORTSTEIL'));
end;

procedure TFormPerson.Button9Click(Sender: TObject);
begin
  // Strasse + Ort
  IB_Query2.FieldByName('STRASSE').assign(IB_Query3.FieldByName('STRASSE'));
  IB_Query2.FieldByName('ORT').assign(IB_Query3.FieldByName('ORT'));
  IB_Query2.FieldByName('ORTSTEIL').assign(IB_Query3.FieldByName('ORTSTEIL'));
end;

procedure TFormPerson.CheckListBox1ClickCheck(Sender: TObject);
begin
  CheckListBox1.Color := clyellow;
  if not(IB_Query1.State in [dssedit, dssinsert]) then
    IB_Query1.edit;
end;

procedure TFormPerson.ComboBox5KeyPress(Sender: TObject; var Key: Char);
var
  VorlageFName: string;
  DokumentFName: string;
  OutPath: string;
  PERSON_R: Integer;
begin
  if (Key = #13) then
  begin
    Key := #0;
    PERSON_R := IB_Query1.FieldByName('RID').AsInteger;
    csvOne;

    // Word rufen
    CheckCreateOnce(WordPath);
    if (ComboBox5.Text <> '') then
    begin

      // Pfade vorbereiten!
      VorlageFName := WordPath + ComboBox5.Text + iTextDocumentExtension;
      OutPath := cPersonPath(PERSON_R);
      DokumentFName := OutPath + ComboBox5.Text + '-' + RIDasStr(e_w_gen('GEN_DOKUMENT')) +
        iTextDocumentExtension;

      CheckCreateDir(OutPath);
      if FileExists(VorlageFName) then
        FileCopy(VorlageFName, DokumentFName)
      else
        FileCopy(WordPath + 'Vorlage' + iTextDocumentExtension, DokumentFName);

      openShell(DokumentFName);
    end;
  end;
end;

procedure TFormPerson.Button10Click(Sender: TObject);
begin
  // nur Ort
  IB_Query2.FieldByName('ORT').assign(IB_Query3.FieldByName('ORT'));
  IB_Query2.FieldByName('ORTSTEIL').assign(IB_Query3.FieldByName('ORTSTEIL'));
end;

function TFormPerson.TakeActual: Boolean;
begin
  EnsureThatQuerysAreOpen;
  result := doit('Wollen Sie den Eintrag' + #13 + IB_Query1.FieldByName('NACHNAME').AsString + ', '
    + IB_Query1.FieldByName('VORNAME').AsString + #13 + IB_Query2.FieldByName('NAME1').AsString +
    #13 + 'jetzt übernehmen');
end;

procedure TFormPerson.Button4Click(Sender: TObject);
begin
  FormAusgangsRechnungen.setContext(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormPerson.Button5Click(Sender: TObject);
var
  DruckStueck: THTMLTemplate;
  DatensammlerGlobal: TStringList;
  DatensammlerLokal: TStringList;
  FullTemplateFname: string;
begin
  FullTemplateFname := MyProgramPath + cHTMLTemplatesDir + Edit1.Text + cHTMLextension;
  if FileExists(FullTemplateFname) then
  begin
    CheckCreateOnce(EigeneOrgaMonDateienPfad);
    DruckStueck := THTMLTemplate.create;
    DatensammlerGlobal := TStringList.create;
    DatensammlerLokal := TStringList.create;
    // Druckstück drucken!
    with DruckStueck do
    begin
      LoadFromFile(FullTemplateFname);
      DatensammlerGlobal.add('Titel=' + Edit1.Text);
      DatensammlerGlobal.add('Datum=' + long2dateLocalized(DateGet));
      DatensammlerGlobal.add('AktuellesDatum=' + DatumLocalized);
      DatensammlerGlobal.add('AktuelleUhrzeit=' + Uhr);
      e_r_Anschrift(IB_Query1.FieldByName('RID').AsInteger, DatensammlerGlobal);
      WriteValue(DatensammlerLokal, DatensammlerGlobal);
      SaveToFileCompressed(EigeneOrgaMonDateienPfad + 'druck' + cHTMLextension);
    end;
    printhtmlok(EigeneOrgaMonDateienPfad + 'druck' + cHTMLextension);
    DatensammlerGlobal.Free;
    DatensammlerLokal.Free;
    DruckStueck.Free;
  end;
end;

procedure TFormPerson.IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
begin
  if IB_Query1.State in [dssedit, dssinsert] then
    IB_Query1.post;
end;

procedure TFormPerson.Button2Click(Sender: TObject);
begin
  if (IB_Edit1.Text = '') then
  begin
    // EnsureEditState;
    if not(IB_Query1.State in [dssedit, dssinsert]) then
      IB_Query1.edit;
    IB_Edit1.Text := IB_Edit13.Text;
    IB_Query1.post;
  end;
end;

procedure TFormPerson.ReflectLaender;
var
  cLAND: TIB_Cursor;
  LandName: TStringList;
  AlleLaender: TStringList;
  n: Integer;
begin
  LandName := TStringList.create;
  AlleLaender := TStringList.create;

  //
  cLAND := DataModuleDatenbank.nCursor;
  with cLAND do
  begin
    sql.add('SELECT L.RID,I.INT_TEXT FROM LAND L ');
    sql.add('JOIN INTERNATIONALTEXT I ON');
    sql.add(' (I.LAND_R=' + inttostr(iHeimatLand) + ') AND');
    sql.add(' (I.RID=L.INT_NAME_R)');
    sql.add('WHERE');
    sql.add(' (L.KURZ_ALT IS NOT NULL)');
    first;
    while not(eof) do
    begin
      FieldByName('INT_TEXT').AssignTo(LandName);
      LandName.add('');
      AlleLaender.addobject(LandName[0], TObject(FieldByName('RID').AsInteger));
      next;
    end;
    close;
  end;
  cLAND.Free;
  AlleLaender.sort;

  with IB_ComboBox1 do
  begin
    clear;
    for n := 0 to pred(AlleLaender.count) do
    begin
      Items.add(AlleLaender[n]);
      Itemvalues.add(inttostr(Integer(AlleLaender.objects[n])));
    end;
  end;

  LandName.Free;
  AlleLaender.Free;

end;

procedure TFormPerson.ReflectPerson;
var
  OutStr: TStringList;
  Summe: double;
  PERSON_R: Integer;
  n: Integer;
  sVertraege: TgpIntegerList;
begin
  inc(cntReflectPerson);
  if not(IB_Query1.eof) then
  begin
    PERSON_R := IB_Query1.FieldByName('RID').AsInteger;
    IB_Query2.ParamByName('CROSSREF').AsInteger := IB_Query1.FieldByName('PRIV_ANSCHRIFT_R')
      .AsInteger;
    if not(IB_Query2.active) then
      IB_Query2.active := true;

    // Farbe des Formulars
    if IB_Query1.FieldByName('PAPERCOLOR').IsNotNull then
      Color := IB_Query1.FieldByName('PAPERCOLOR').AsInteger
    else
      Color := iFormColor;

    Label24.Caption := LieferzeitToStr(IB_Query1.FieldByName('LIEFERZEIT').AsInteger);
    Label33.Caption := '?';

    // Verträge
    CheckListBox1.Items.BeginUpdate;
    CheckListBox1.Color := clwhite;
    sVertraege := e_r_sqlm('select BELEG_R from VERTRAG where PERSON_R=' + inttostr(PERSON_R));
    for n := 0 to pred(lVertragsVarianten.count) do
      CheckListBox1.checked[n] := (sVertraege.indexof(lVertragsVarianten[n]) <> -1);
    sVertraege.Free;
    CheckListBox1.Items.EndUpdate;

    // Saldo seines Kontos
    Summe := b_r_PersonSaldo(PERSON_R);
    StaticText5.Caption := format('%m', [abs(Summe)]);
    if isHaben(Summe) then
      StaticText5.Color := clred
    else
      StaticText5.Color := cllime;

    // Bestimmte Tickets?
    OutStr := q_r_PersonWarnung(IB_Query1.FieldByName('RID').AsInteger);
    if (OutStr.count > 0) then
      FormQAbzeichnen.Abzeichnen(HugeSingleLine(OutStr, #13));
    OutStr.Free;

    // Lohn
    if (length(Edit3.Text) = 7) then
    begin

      // Monats-Summe
      Summe := e_r_sqld(
        { } 'select sum(BETRAG) from' +
        { } ' BUCH ' +
        { } 'join PERSON on' +
        { } ' (BUCH.PERSON_R=PERSON.RID) and' +
        { } ' (A00=''Y'') ' +
        { } 'where' +
        { } ' (NAME=' + cKonto_Loehne_AsDBString + ') and' +
        { } ' (DATUM=''01.' + Edit3.Text + ''') and' +
        { } ' (BETRAG>0)');

      StaticText1.Caption := format('%m', [abs(Summe)]);
      if isHaben(Summe) then
        StaticText1.Color := clred
      else
        StaticText1.Color := cllime;

      // Jahres-Summe
      Summe := e_r_sqld(
        { } 'select sum(BETRAG) from' +
        { } ' BUCH ' +
        { } 'join PERSON on' +
        { } ' (BUCH.PERSON_R=PERSON.RID) and' +
        { } ' (A00=''Y'') ' +
        { } 'where' +
        { } ' (NAME=' + cKonto_Loehne_AsDBString + ') and' +
        { } ' (DATUM between ''01.01.' + copy(Edit3.Text, 4, 4) + ''' and ''31.12.' +
        copy(Edit3.Text, 4, 4) + ''') and' +
        { } ' (BETRAG>0)');

      StaticText3.Caption := format('%m', [abs(Summe)]);
      if isHaben(Summe) then
        StaticText3.Color := clred
      else
        StaticText3.Color := cllime;

      //
      Summe := e_r_sqld(
        { } 'select sum(betrag) S from BUCH ' +
        { } 'where' +
        { } ' (NAME=' + cKonto_Loehne_AsDBString + ') and' +
        { } ' (datum=''01.' + Edit3.Text + ''') and' +
        { } ' (KUNDE_R=' + IB_Query1.FieldByName('RID').AsString + ')');
      Edit2.Text := format('%m', [abs(Summe)]);

      //
      OutStr := TStringList.create;
      IB_Query1.FieldByName('BEMERKUNG').AssignTo(OutStr);
      OutStr.add('');
      StaticText2.Caption := OutStr[0];
      OutStr.Free;

    end;
  end
  else
  begin
    IB_Query2.close;
  end;
end;

procedure TFormPerson.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  ReflectPerson;
end;

procedure TFormPerson.Button11Click(Sender: TObject);
begin
  FormBBelege.setContext(IB_Query1.FieldByName('RID').AsInteger);
  FormBBelege.show;
end;

function iMacroWorkPath: string;
begin
  result := PersonalDataDir + 'iMacros\Macros\';
end;

procedure TFormPerson.ensureiMacro;
var
  WebsiteLogins: TStringList;
  n: Integer;
begin
  if not(iMacroInitialisiert) then
  begin
    WebsiteLogins := TStringList.create;
    dir(iMacroWorkPath + 'OrgaMon-*.iim', WebsiteLogins, false);
    for n := 0 to pred(WebsiteLogins.count) do
      ComboBox1.Items.add(ExtractSegmentBetween(WebsiteLogins[n], 'OrgaMon-', '.iim'));
    iMacroInitialisiert := true;
  end;
end;

procedure TFormPerson.createiMacro(NameSpace: string);
var
  s: TStringList;
  p: string;
begin
  s := TStringList.create;
  s.LoadFromFile(iMacroWorkPath + 'OrgaMon-' + NameSpace + '.iim');
  ersetze('~NUMMER~', IB_Query1.FieldByName('NUMMER').AsString, s);
  ersetze('~HANDY~', IB_Query1.FieldByName('HANDY').AsString, s);
  ersetze('~USER_PWD~', IB_Query1.FieldByName('USER_PWD').AsString, s);

  // Names-Ermittlung
  p := e_r_Person(IB_Query1.FieldByName('RID').AsInteger);
  if (IB_Query1.FieldByName('A13').AsString = 'Y') then
    p := p + ' Fremd';

  // Speichern des Makros
  s.SaveToFile(
    { } iMacroWorkPath +
    { } NameSpace + '-' +
    { } p +
    { } '.iim', Tencoding.UTF8);
  s.Free;

  //
  ShowMessageTimeOut(
    { } 'Firefox-iMacro ' + #13#13 +
    { } NameSpace + '-' + p + #13#13 +
    { } 'erstellt!');
end;

procedure TFormPerson.ComboBox1DropDown(Sender: TObject);
begin
  ensureiMacro;
end;

procedure TFormPerson.ComboBox1Select(Sender: TObject);
begin
  createiMacro(ComboBox1.Items[ComboBox1.ItemIndex]);
  ComboBox1.ItemIndex := -1;
end;

procedure TFormPerson.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
  PageControl1.ActivePage := TabSheet1;
  top := 0;
  left := 0;
  Query1_sql := TStringList.create;
  Query1_sql.AddStrings(IB_Query1.sql);
  Query2_sql := TStringList.create;
  Query2_sql.AddStrings(IB_Query2.sql);
  lVertragsVarianten := TgpIntegerList.create;
end;

procedure TFormPerson.Button16Click(Sender: TObject);
begin
  openShell(format('http://%s?site=login&action=login&f_user=%s&f_pass=%s',
    [iShopDomain, IB_Query1.FieldByName('USER_ID').AsString, IB_Query1.FieldByName('USER_PWD')
    .AsString]));
end;

procedure TFormPerson.Button17Click(Sender: TObject);
begin
  if doit('OK: Direkt neu setzen'#13'Abbrechen: Über den Webshop') then
  begin
    e_w_PersonSetPassword(IB_Query1.FieldByName('RID').AsInteger);
    IB_Query1.Refresh;
  end
  else
  begin
    openShell(format('http://%s?action=send_password&f_user=%s',
      [iShopDomain, IB_Query1.FieldByName('USER_ID').AsString]));
  end;
end;

procedure TFormPerson.IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
var
  sSoll, sIst: TgpIntegerList;
  n, k: Integer;
  PERSON_R: Integer;
begin
  if IB_Query2.State in [dssedit, dssinsert] then
    IB_Query2.post;

  with IB_Dataset do
  begin
    PERSON_R := FieldByName('RID').AsInteger;

    //
    if FieldByName('EMAIL').IsNotNull then
      if FieldByName('USER_ID').IsNull then
        FieldByName('USER_ID').AsString := noblank(nextp(FieldByName('EMAIL').AsString, ';', 0));
    if FieldByName('USER_ID').IsModified then
      if FieldByName('USER_ID').IsNotNull then
        FieldByName('USER_ID').AsString := AnsiLowerCase(FieldByName('USER_ID').AsString);

    // Verträge
    sIst := e_r_sqlm('select distinct BELEG_R from VERTRAG where PERSON_R=' + inttostr(PERSON_R));
    sIst.sort;
    sSoll := TgpIntegerList.create;
    for n := 0 to pred(lVertragsVarianten.count) do
      if CheckListBox1.checked[n] then
        sSoll.add(lVertragsVarianten[n]);
    sSoll.sort;

    for n := 0 to pred(sSoll.count) do
    begin
      k := sIst.indexof(sSoll[n]);
      if (k = -1) then
      begin
        // muss neu angelegt werden!
        e_x_sql('insert into VERTRAG (RID,PERSON_R,BELEG_R) values ' + '(0,' + inttostr(PERSON_R) +
          ',' + inttostr(sSoll[n]) + ')');
      end
      else
      begin
        sIst.delete(k);
      end;
    end;

    for n := 0 to pred(sIst.count) do
    begin
      // was übrig bleibt muss weg
      e_x_sql(
        { } 'delete from VERTRAG where ' +
        { } ' (BELEG_R=' + inttostr(sIst[n]) + ') and ' +
        { } ' (PERSON_R=' + inttostr(PERSON_R) + ')');
    end;

    sIst.Free;
    sSoll.Free;

  end;
end;

procedure TFormPerson.IB_Query5BeforeInsert(IB_Dataset: TIB_Dataset);
begin
  IB_Dataset.FieldByName('PERSON_R').assign(IB_Query1.FieldByName('RID'));
end;

procedure TFormPerson.Button3Click(Sender: TObject);
begin
  IB_Query6.Open;
  IB_Query6.Refresh;
end;

procedure TFormPerson.Button6Click(Sender: TObject);
var
  qUMSATZ: TIB_Cursor;
begin

  //
  qUMSATZ := DataModuleDatenbank.nCursor;
  with qUMSATZ do
  begin
    sql.add('SELECT sum(DAVON_BEZAHLT) BETRAG,');
    sql.add('count(RID) ANZAHL');
    sql.add('FROM BELEG WHERE FAELLIG>''' + copy(Datum, 1, 6) +
      inttostr(pred(strtointdef(copy(Datum, 7, 4), 0))) + ''' AND PERSON_R=' +
      IB_Query1.FieldByName('RID').AsString);
    sql.add('group by PERSON_R');
    Open;
    Label33.Caption := format('%d Beleg(e): %m', [FieldByName('ANZAHL').AsInteger,
      FieldByName('BETRAG').AsDouble]);
  end;
  qUMSATZ.Free;

  //

end;

procedure TFormPerson.Button13Click(Sender: TObject);
begin
  FormTier.setContext(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormPerson.Button14Click(Sender: TObject);
begin
  FormVertrag.setContext(0, IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormPerson.csvSave(PersonList: TList; xlsOptions: TStringList);
var
  sExcelOptions: TStringList;
begin
  BeginHourGlass;
  sExcelOptions := TStringList.create;
  sExcelOptions.add('Datum=DATE');

  try
    CheckCreateOnce(EigeneOrgaMonDateienPfad);
    ExcelExport(EigeneOrgaMonDateienPfad + 'Personen.xls', PersonList, nil, xlsOptions);
  except
    ShowMessage('Die Datenquelle kann nicht aktualisiert werden! Ist die Datei' + #13 +
      EigeneOrgaMonDateienPfad + 'Personen.xls' + #13 + 'im Moment geöffnet?');
  end;

  try
    CSVExport(EigeneOrgaMonDateienPfad + 'Personen.csv', PersonList);
  except
    ShowMessage('Die Datenquelle kann nicht aktualisiert werden! Ist die Datei' + #13 +
      EigeneOrgaMonDateienPfad + 'Personen.csv' + #13 + 'im Moment geöffnet?');
  end;

  sExcelOptions.Free;
  EndHourGlass;
end;

procedure TFormPerson.csvOne;
var
  PersonList: TList;
  xlsOptions: TStringList;
  n: Integer;
begin
  BeginHourGlass;
  PersonList := TList.create;
  with PersonList do
  begin
    add(csvAddHeader);
    add(csvAddOne);
  end;
  xlsOptions := csvOptions;
  csvSave(PersonList, xlsOptions);

  // Objektfreigabe
  for n := 0 to pred(PersonList.count) do
    TStringList(PersonList[n]).Free;
  PersonList.Free;
  xlsOptions.Free;
  EndHourGlass;
end;

procedure TFormPerson.SpeedButton1Click(Sender: TObject);
var
  OpenPathName: string;
begin
  OpenPathName := cPersonPath(IB_Query1.FieldByName('RID').AsInteger);
  if DirExists(OpenPathName) then
  begin
    openShell(OpenPathName)
  end
  else
  begin
    if doit('Zu dieser Person gibt es noch keine Rechnungsablage!' + #13 +
      'Soll jetzt ein Verzeichnis angelegt werden') then
    begin
      CheckCreateDir(OpenPathName);
      openShell(OpenPathName);
    end;
  end;
end;

procedure TFormPerson.SpeedButton20Click(Sender: TObject);
begin
  FormKontext.cnPERSON.addContext(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormPerson.SpeedButton21Click(Sender: TObject);
begin
  ShowMessage(format(
    { } '%m', [
    { } b_r_Anno(
    { } IB_Edit7.Text,
    { } 20120101,
    { } DateGet)]));
end;

procedure TFormPerson.SpeedButton27Click(Sender: TObject);
begin
  RefreshWordVorlagen;
end;

procedure TFormPerson.SpeedButton2Click(Sender: TObject);
var
  OpenPathName: string;
begin
  OpenPathName := MyProgramPath + 'Bestellungen\' +
    inttostrN(IB_Query1.FieldByName('RID').AsInteger, 10);
  if DirExists(OpenPathName) then
    openShell(OpenPathName)
  else
    ShowMessage('Zu dieser Person gibt es noch keine Bestellablage!');
end;

procedure TFormPerson.SpeedButton7Click(Sender: TObject);
var
  PERSON_R_TO: Integer;
begin
  // aktuelle Person bleibt erhalten!
  PERSON_R_TO := FormPerson.IB_Query1.FieldByName('RID').AsInteger;
  if inOLAPmode then
    AlleAnzeigen;

  with FormPersonSuche do
  begin
    if visible then
      close;
    DontSetContext := true;
    showmodal;
    if (PERSON_R > 0) then
    begin
      e_w_JoinPerson(PERSON_R, PERSON_R_TO);
      FormPerson.IB_Query1.locate('RID', PERSON_R, []);
      FormPerson.IB_Query1.delete;
      FormKontext.cnPERSON.delContext(PERSON_R);
      FormPerson.IB_Query1.locate('RID', PERSON_R_TO, []);
    end;
  end;
end;

procedure TFormPerson.Button1Click(Sender: TObject);
begin
  FormPersonSuche.show;
end;

procedure TFormPerson.RefreshProfileNames;
begin
  IB_CheckBox4.Caption := iProfilTexte[0];
  IB_CheckBox5.Caption := iProfilTexte[1];
  IB_CheckBox6.Caption := iProfilTexte[2];
  IB_CheckBox7.Caption := iProfilTexte[3];
  IB_CheckBox8.Caption := iProfilTexte[4];
  IB_CheckBox9.Caption := iProfilTexte[5];
  IB_CheckBox10.Caption := iProfilTexte[6];
  IB_CheckBox11.Caption := iProfilTexte[7];
  IB_CheckBox12.Caption := iProfilTexte[8];
  IB_CheckBox13.Caption := iProfilTexte[9];
  IB_CheckBox14.Caption := iProfilTexte[10];
  IB_CheckBox15.Caption := iProfilTexte[11];
  IB_CheckBox16.Caption := iProfilTexte[12];
  IB_CheckBox17.Caption := iProfilTexte[13];
  IB_CheckBox18.Caption := iProfilTexte[14];
  IB_CheckBox19.Caption := iProfilTexte[15];
  IB_CheckBox20.Caption := iProfilTexte[16];
  IB_CheckBox21.Caption := iProfilTexte[17];
end;

procedure TFormPerson.RefreshVertraege;
var
  sVertraege: TStringList;
begin
  // Texte der Checkboxen
  sVertraege := TStringList.create;
  sVertraege.LoadFromFile(VertragsVarianten + cItemsCacheFExtension);
  CheckListBox1.Items.assign(sVertraege);
  sVertraege.Free;

  // Value-Liste laden
  lVertragsVarianten.LoadFromFile(VertragsVarianten + cValueCacheFExtension);
end;

procedure TFormPerson.RefreshWordVorlagen;
var
  sDir: TStringList;
  pExtension: string;
  n, k: Integer;
begin
  sDir := TStringList.create;
  pExtension := AnsiUpperCase(iTextDocumentExtension);
  dir(WordPath + '*' + pExtension, sDir, false);
  sDir.sort;
  for n := 0 to pred(sDir.count) do
  begin
    k := revpos(pExtension, AnsiUpperCase(sDir[n]));
    if (k > 0) then
      sDir[n] := copy(sDir[n], 1, pred(k));
  end;
  ComboBox5.Items.assign(sDir);
  sDir.Free;
end;

procedure TFormPerson.FormDestroy(Sender: TObject);
begin
  UserBreak := true;
end;

function TFormPerson.getContext: Integer;
begin
  result := IB_Query1.FieldByName('RID').AsInteger;
end;

procedure TFormPerson.IB_Query1ConfirmDelete(Sender: TComponent; var Confirmed: Boolean);
begin
  Confirmed := false;
  with Sender as TIB_Dataset do
  begin
    if doit('Person ' + #13 + FieldByName('VORNAME').AsString + ' ' + FieldByName('NACHNAME')
      .AsString + #13 + 'wirklich löschen') then
    begin
      BeginHourGlass;
      FormKontext.cnPERSON.delContext(FieldByName('RID').AsInteger);
      e_w_preDeletePerson(FieldByName('RID').AsInteger);
      Confirmed := true;
      EndHourGlass;
    end;
  end;
end;

procedure TFormPerson.setContext(PERSON_R: Integer);
var
  wSQL: TStringList;
begin
  BeginHourGlass;
  FormKontext.cnPERSON.addContext(PERSON_R);

  wSQL := TStringList.create;
  with wSQL do
  begin
    add('where RID=' + inttostr(PERSON_R));
    add('for update');
  end;
  with IB_Query1 do
  begin
    close;
    ChangeWhere(IB_Query1, wSQL);
    inOLAPmode := true;
  end;
  show;
  EndHourGlass;
end;

procedure TFormPerson.Button18Click(Sender: TObject);
var
  Bericht: TStringList;
  PERSON_R: Integer;
begin
  PERSON_R := IB_Query1.FieldByName('RID').AsInteger;
  Bericht := e_w_KontoInfo(PERSON_R);
  Bericht.Free;
  openShell(e_r_MahnungFName(PERSON_R));
end;

procedure TFormPerson.RefreshZahlungtypCombo;
var
  cZAHLUNGTYP: TIB_Cursor;
begin
  with IB_ComboBox2 do
  begin
    Items.clear;
    Itemvalues.clear;
    Items.add('- Standard -');
    Itemvalues.add('');
    cZAHLUNGTYP := DataModuleDatenbank.nCursor;
    with cZAHLUNGTYP do
    begin
      sql.add('select RID,BEZEICHNUNG from ZAHLUNGTYP order by BEZEICHNUNG');
      ApiFirst;
      while not(eof) do
      begin
        Items.add(FieldByName('BEZEICHNUNG').AsString);
        Itemvalues.add(FieldByName('RID').AsString);
        ApiNext;
      end;
    end;
    ItemIndex := 0;
    cZAHLUNGTYP.Free;
  end;
end;

procedure TFormPerson.SpeedButton3Click(Sender: TObject);
begin
  RefreshZahlungtypCombo;
  IB_Query1.Refresh;
end;

procedure TFormPerson.Button19Click(Sender: TObject);
begin
  e_f_PersonInfo(IB_Query1.FieldByName('RID').AsInteger, AnwenderPath);
  openShell(AnwenderPath);
end;

procedure TFormPerson.SpeedButton4Click(Sender: TObject);
begin
  // Word Verzeichnis
  CheckCreateOnce(WordPath);
  openShell(WordPath);
end;

procedure TFormPerson.FormDeactivate(Sender: TObject);
begin
  InvalidateCache_Monteur;
end;

procedure TFormPerson.SpeedButton5Click(Sender: TObject);
begin
  FormGeoLokalisierung.show;
end;

procedure TFormPerson.SpeedButton6Click(Sender: TObject);
begin
  with IB_Query1 do
  begin
    if (FieldByName('KONTAKTAM').AsDate = Date) then
    begin
      // heute
      ShowMessage('Kontakt um ' + secondstostr8(DateTime2seconds(FieldByName('KONTAKTAM')
        .AsDateTime)));
    end
    else
    begin
      // Eintragen und speichern!
      FieldByName('KONTAKTAM').AsDateTime := now;
      post;
    end;
  end;
end;

procedure TFormPerson.SpeedButton17Click(Sender: TObject);
begin
  SaveHeaderSettings(IB_Grid2, AnwenderPath + HeaderSettingsFName(IB_Grid2));
end;

procedure TFormPerson.SpeedButton8Click(Sender: TObject);
begin
  SaveHeaderSettings(IB_Grid1, AnwenderPath + HeaderSettingsFName(IB_Grid1));
end;

procedure TFormPerson.IB_Query1BeforePrepare(Sender: TIB_Statement);
begin
  LoadHeaderSettings(IB_Grid1, AnwenderPath + HeaderSettingsFName(IB_Grid1));
  cCOL_PAPERCOLOR := 0;
end;

procedure TFormPerson.IB_Query3BeforePrepare(Sender: TIB_Statement);
begin
  LoadHeaderSettings(IB_Grid2, AnwenderPath + HeaderSettingsFName(IB_Grid2));
end;

procedure TFormPerson.SpeedButton8MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbRight) then
    if doit('Wollen Sie die Spaltenbreiten wieder auf Standard setzen', true) then
    begin
      FileDelete(AnwenderPath + HeaderSettingsFName(IB_Grid1));
      IB_Query1.close;
      IB_Query1.sql.clear;
      IB_Query1.sql.AddStrings(Query1_sql);
      IB_Query1.Open;
    end;
end;

procedure TFormPerson.SpeedButton17MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbRight) then
    if doit('Wollen Sie die Spaltenbreiten wieder auf Standard setzen', true) then
    begin
      FileDelete(AnwenderPath + HeaderSettingsFName(IB_Grid2));
      IB_Query2.close;
      IB_Query2.sql.clear;
      IB_Query2.sql.AddStrings(Query2_sql);
      IB_Query2.Open;
    end;
end;

procedure TFormPerson.SpeedButton18Click(Sender: TObject);
var
  PERSON_R: TDOM_Reference;
  Zahlungspflichtige: TgpIntegerList;
  wSQL: TStringList;
begin
  BeginHourGlass;
  PERSON_R := IB_Query1.FieldByName('RID').AsInteger;

  wSQL := TStringList.create;

  // Springe auf die Ansicht mit allen Zahlungspflichtigen
  if is1400 then
    Zahlungspflichtige := e_r_sqlm(
      { } 'select distinct ZAHLUNGSPFLICHTIGER_R from' +
      { } ' BUCH ' +
      { } 'where' +
      { } ' (NAME=' + cKonto_Forderungen_AsDBString + ') and' +
      { } ' (PERSON_R=' + inttostr(PERSON_R) + ')')
  else
    Zahlungspflichtige := e_r_sqlm(
      { } 'select DISTINCT ZAHLUNGSPFLICHTIGER_R from ' + TABELLE_AR + ' where' +
      { } ' (KUNDE_R=' + inttostr(PERSON_R) + ')');

  if (Zahlungspflichtige.count = 0) then
  begin
    wSQL.add('where RID is null');
  end
  else
  begin
    Zahlungspflichtige.Insert(0, PERSON_R);
    wSQL.add('where RID in ' + Zahlungspflichtige.AsString);
  end;
  wSQL.add('for update');
  with IB_Query1 do
  begin
    close;
    ChangeWhere(IB_Query1, wSQL);
    Open;
    inOLAPmode := true;
  end;

  Zahlungspflichtige.Free;
  wSQL.Free;
  EndHourGlass;
end;

procedure TFormPerson.SpeedButton19Click(Sender: TObject);
begin
  clipboard.AsText := StrFilter(IB_Edit7.Text, cZiffern);
end;

procedure TFormPerson.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    Button5Click(Sender);
  end;
end;

procedure TFormPerson.Edit2KeyPress(Sender: TObject; var Key: Char);
var
  AUSGANGSRECHNUNG_R: Integer;
  PERSON_R: Integer;
  qAUSGANGSRECHNUNG: TIB_Query;
begin

  if (Key = #13) then
  begin
    PERSON_R := IB_Query1.FieldByName('RID').AsInteger;
    AUSGANGSRECHNUNG_R := e_r_sql('select RID from AUSGANGSRECHNUNG where (KUNDE_R=' +
      inttostr(PERSON_R) + ') and (DATUM=''01.' + Edit3.Text + ''')');

    if (AUSGANGSRECHNUNG_R > 0) then
    begin
      // imp pend: umstellen auf x_sql
      qAUSGANGSRECHNUNG := DataModuleDatenbank.nQuery;
      with qAUSGANGSRECHNUNG do
      begin
        sql.add('select * from AUSGANGSRECHNUNG where RID=' + inttostr(AUSGANGSRECHNUNG_R) +
          ' for update');
        Open;
        edit;
        FieldByName('BETRAG').AsDouble := strtodoubledef(Edit2.Text, 0);
        post;
      end;
      qAUSGANGSRECHNUNG.Free;
    end
    else
    begin
      e_x_sql('insert into BUCH (RID,NAME,KUNDE_R,DATUM,BETRAG) values (' +
        { } '0,' +
        { } cKonto_Loehne_AsDBString + ',' +
        { } inttostr(PERSON_R) + ',' +
        { } '''01.' + Edit3.Text + ''',' +
        { } FloatToStrISO(strtodoubledef(Edit2.Text, 0)) +
        { } ')');
    end;
    Key := #0;
    IB_Query1.next;
    application.processmessages;

    // alle markieren!
    Edit3.SetFocus;
    Edit2.SetFocus;
  end;
end;

procedure TFormPerson.Edit3Exit(Sender: TObject);
begin
  ReflectPerson;
  // Edit2.SetFocus;
end;

procedure TFormPerson.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Personen');
end;

procedure TFormPerson.Image3Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Personen.Import');
end;

procedure TFormPerson.Image4Click(Sender: TObject);
begin
  // EC-Karten Event simulieren!
  with FormZahlungECconnect, IB_Query1 do
  begin
    Edit_BLZ.Text := b_r_Person_ELV_BLZ(
      { } FieldByName('Z_ELV_BLZ').AsString,
      { } FieldByName('Z_ELV_KONTO').AsString);
    Edit_Konto.Text := b_r_Person_ELV_Konto(
      { } FieldByName('Z_ELV_BLZ').AsString,
      { } FieldByName('Z_ELV_KONTO').AsString);
    Edit_GueltigBis.Text := 'NOCARD';
    DatenKommenVonDerKarte := false;
    FillContext;
    if (PERSON_R <> FieldByName('RID').AsInteger) and (PERSON_R <> -1) then
      ShowMessage('RID=' + inttostr(PERSON_R) + ' hat dieselben Kontodaten (Dublette?)!')
    else
      show;
  end;
end;

procedure TFormPerson.Edit3Change(Sender: TObject);
begin
  Edit2.enabled := (length(Edit3.Text) = 7);
end;

procedure TFormPerson.IB_Query1AfterCancel(IB_Dataset: TIB_Dataset);
begin
  ReflectPerson;
end;

procedure TFormPerson.IB_Query1AfterDelete(IB_Dataset: TIB_Dataset);
begin
  if IB_Query1.IsEmpty then
    FormPersonSuche.show;
end;

procedure TFormPerson.IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
var
  PERSON_R: Integer;
begin
  PERSON_R := IB_Dataset.FieldByName('RID').AsInteger;
  IB_Dataset.Refresh;
  IB_Query1.locate('RID', PERSON_R, []);
end;

procedure TFormPerson.SpeedButton9Click(Sender: TObject);
var
  p: TPoint2D;
begin
  BeginHourGlass;
  try
    // Koordinaten erfragen
    FormGeoLokalisierung.locate(IB_Query2.FieldByName('STRASSE').AsString,
      e_r_plz(IB_Query2) + ' ' + IB_Query2.FieldByName('ORT').AsString,
      IB_Query2.FieldByName('ORTSTEIL').AsString, p);

    // Karte anzeigen
    FormGeoArbeitsplatz.showMap(p.X, p.Y);

  except
    beep;
  end;
  EndHourGlass;
end;

procedure TFormPerson.SpeedButton15Click(Sender: TObject);
begin
  OpenDialog1.InitialDir := iOlapPath;
  if OpenDialog1.execute then
  begin
    BeginHourGlass;
    with IB_Query1 do
    begin
      close;
      qSelectList(IB_Query1, OpenDialog1.FileName);
      Open;
      inOLAPmode := true;
    end;
    EndHourGlass;
  end;
end;

procedure TFormPerson.SpeedButton16Click(Sender: TObject);
begin
  SpeedButton16.enabled := false;
  Neu;
  SpeedButton16.enabled := true;
end;

procedure TFormPerson.Button20Click(Sender: TObject);
var
  sPERSON: TsTable;
  qPERSON: TIB_Query;
  PERSON_R: Integer;
  n, r, c: Integer;
  _FieldName: string;
begin
  BeginHourGlass;
  sPERSON := TsTable.create;
  sPERSON.insertFromFile(Edit4.Text);
  qPERSON := DataModuleDatenbank.nQuery;
  with qPERSON do
  begin
    for r := 1 to pred(sPERSON.count) do
    begin
      PERSON_R := e_w_PersonNeu;
      sql.clear;
      sql.add('select * from PERSON where RID=' + inttostr(PERSON_R) + ' for update');
      Open;
      edit;
      if not(eof) then
      begin
        FieldByName('RID').AsInteger := PERSON_R;
        for n := 0 to pred(FieldCount) do
        begin
          _FieldName := Fields[n].FieldName;
          if sPERSON.isHeader(_FieldName) then
          begin
            c := sPERSON.colOf(_FieldName);
            qPERSON.Fields[n].AsString := sPERSON.readcell(r, c);
          end;
        end;
        post;
      end;
      close;
    end;
  end;
  sPERSON.Free;
  qPERSON.Free;
  EndHourGlass;
end;

procedure TFormPerson.AlleAnzeigen;
var
  ToRID: Integer;
begin
  BeginHourGlass;
  with IB_Query1 do
  begin
    ToRID := FieldByName('RID').AsInteger;
    close;
    qSelectAll(IB_Query1);
    Open;
    inOLAPmode := false;
    locate('RID', ToRID, []);
  end;
  EndHourGlass;
end;

procedure TFormPerson.Button21Click(Sender: TObject);
begin
  AlleAnzeigen;
end;

procedure TFormPerson.Button22Click(Sender: TObject);
begin
  if not(IB_Query1.State in [dssedit, dssinsert]) then
    IB_Query1.edit;
  IB_Query1.FieldByName('ANSPRACHE').AsString := _('Sehr geehrte Frau') + ' ' + IB_Edit3.Text;
end;

procedure TFormPerson.Button23Click(Sender: TObject);
begin
  if not(IB_Query1.State in [dssedit, dssinsert]) then
    IB_Query1.edit;
  IB_Query1.FieldByName('ANSPRACHE').AsString := _('Sehr geehrter Herr') + ' ' + IB_Edit3.Text;
end;

procedure TFormPerson.Button24Click(Sender: TObject);
begin
  if not(IB_Query1.State in [dssedit, dssinsert]) then
    IB_Query1.edit;
  IB_Query1.FieldByName('ANSPRACHE').AsString := _('Hallo') + ' ' + IB_Edit2.Text;
end;

procedure TFormPerson.Button25Click(Sender: TObject);
begin
  if not(IB_Query1.State in [dssedit, dssinsert]) then
    IB_Query1.edit;
  IB_Query1.FieldByName('ANSPRACHE').AsString := _('Sehr geehrte Damen und Herren');
end;

procedure TFormPerson.Button26Click(Sender: TObject);
begin
  if not(IB_Query1.State in [dssedit, dssinsert]) then
    IB_Query1.edit;
  IB_Query1.FieldByName('ANSPRACHE').AsString := _('Liebe Familie') + ' ' + IB_Edit3.Text;
end;

procedure TFormPerson.SpeedButton10Click(Sender: TObject);
var
  DokumentFName: string;
  ToRID: Integer;
  PersonList: TList;
  xlsOptions: TStringList;
  n: Integer;
begin
  if doit('Serienbriefsteuerdatei mit ' + inttostr(IB_Query1.RecordCount) + ' Datensätzen erstellen')
  then
  begin

    //
    BeginHourGlass;
    PersonList := TList.create;
    PersonList.add(csvAddHeader);
    with IB_Query1 do
    begin
      ToRID := FieldByName('RID').AsInteger;
      first;
      while not(eof) do
      begin
        PersonList.add(csvAddOne);
        next;
      end;
      locate('RID', ToRID, []);
    end;
    xlsOptions := csvOptions;
    csvSave(PersonList, xlsOptions);

    // Objektfreigabe
    for n := 0 to pred(PersonList.count) do
      TStringList(PersonList[n]).Free;
    PersonList.Free;
    xlsOptions.Free;

    EndHourGlass;
  end;

  // Word rufen
  CheckCreateOnce(WordPath);
  if (ComboBox5.Text <> '') then
  begin
    DokumentFName := WordPath + ComboBox5.Text + iTextDocumentExtension;
    if not(FileExists(DokumentFName)) then
      FileCopy(WordPath + 'Vorlage' + iTextDocumentExtension, DokumentFName);
    openShell(DokumentFName);
  end;

end;

function TFormPerson.csvOptions: TStringList;
begin
  result := TStringList.create;
  with result do
  begin
    add('Lohn01=MONEY');
    add('Lohn02=MONEY');
    add('Lohn03=MONEY');
    add('Lohn04=MONEY');
    add('Lohn05=MONEY');
    add('Lohn06=MONEY');
    add('Lohn07=MONEY');
    add('Lohn08=MONEY');
    add('Lohn09=MONEY');
    add('Lohn10=MONEY');
    add('Lohn11=MONEY');
    add('Lohn12=MONEY');
    add('LohnSumme=MONEY');
    add('Datum=DATE');
    add('Geburtsdatum=DATE');
    add('Vertrag_Beginn=DATE');
    add('Vertrag_Ende=DATE');
    add('Vertrag_Stichtag=DATE');
    add('Vertrag_Volumen=MONEY');
    add('Vertrag_Betrag=MONEY');
    add('PIN=TEXT');
    add('Handy=TEXT');
    add('Versicherungsnummer=TEXT');
    add('Passwort=TEXT');
  end;
end;

function TFormPerson.csvAddHeader: TStringList;
const
  csvHeaderLines = 'Vorname;Nachname;Name1;Name2;Strasse;Ort;Telefon;Fax;Datum;' +
    'Tier_Art;Tier_Rasse;Tier_Name;Tier_Geburt;Tier_Geschlecht;' +
    'Tier_Tätowiernummer;Tier_Chipnummer;Anrede;Ansprache;Adressat1;Adressat2;' +
    'Adressat3;Adressat4;LohnJahr;' + 'Lohn01;Arbeitszeit01;Lohn02;Arbeitszeit02;' +
    'Lohn03;Arbeitszeit03;Lohn04;Arbeitszeit04;Lohn05;Arbeitszeit05;' +
    'Lohn06;Arbeitszeit06;Lohn07;Arbeitszeit07;Lohn08;Arbeitszeit08;' +
    'Lohn09;Arbeitszeit09;Lohn10;Arbeitszeit10;Lohn11;Arbeitszeit11;' + 'Lohn12;Arbeitszeit12;' +
    'LohnSumme;Zusätzlich;Beruf;Geburtsdatum;' +
    'Baustelle_Name;Vertrag_Nummer;Vertrag_Beginn;Vertrag_Ende;Vertrag_Stichtag;' +
    'Vertrag_Volumen;Vertrag_Betrag;PIN;Handy;Versicherungsnummer;Passwort';
var
  FullHeader: string;
begin
  result := TStringList.create;
  FullHeader := csvHeaderLines;
  with result do
    while (FullHeader <> '') do
      add(nextp(FullHeader, ';'));
end;

procedure TFormPerson.dhlSave;
var
  OutFName: string;
  Ort: string;
begin
  OutFName := EigeneOrgaMonDateienPfad + 'DHL-Versandhelfer.csv';
  if not(FileExists(OutFName)) then
    AppendStringsToFile
      ('"Vorname";"Nachname";"Firma";"Straßegeschäftlich";"Ortgeschäftlich";"Postleitzahlgeschäftlich";"Landgeschäftlich";"Straßeprivat";"Ortprivat";"Postleitzahlprivat";"Landprivat"',
      OutFName);

  Ort := e_r_ort(IB_Query2);

  AppendStringsToFile(

    { } '"' + IB_Query1.FieldByName('VORNAME').AsString + '";' +
    { } '"' + IB_Query1.FieldByName('NACHNAME').AsString + '";' +
    { } '"' + IB_Query2.FieldByName('NAME2').AsString + '";' +
    (*
      { } '"' + sAdressat[1] + '";' +
      { } '"' + sAdressat[2] + '";' +
      { } '"' + sAdressat[3] + '";' +
    *)
    { } '"' + IB_Query2.FieldByName('STRASSE').AsString + '";' +
    { } '"' + nextp(Ort, ' ', 1) + '";' +
    { } '"' + nextp(Ort, ' ', 0) + '";' +
    { } '"Deutschland";' +
    { } ';;;', OutFName);

  (*
    "Max";"Mustermann";"Musterfirma";"Musterstr. 4";"Musterdorf";12345;"Deutschland";;;;
    "Maria";"Musterfrau";;;;;;"Musterallee 1c";"Musterstadt";54321;"Deutschland"
  *)
end;

function TFormPerson.csvAddOne: TStringList;
var
  Person: TIB_Query;
  ANSCHRIFT: TIB_Query;
  // Tier
  Tier: TIB_Cursor;
  TIER_R: Integer;
  Tier_Art, Tier_Rasse, Tier_Name, Tier_Geburt, Tier_Geschlecht, Tier_Taetowiernummer,
    Tier_Chipnummer: string;

  // Vertrag
  VERTRAG_R: Integer;
  cVERTRAG: TIB_Cursor;
  Baustelle_Name: string;
  Vertrag_Nummer: string;
  Vertrag_Beginn: string;
  Vertrag_Ende: string;
  Vertrag_Stichtag: string;
  Vertrag_Volumen: string;
  Vertrag_Betrag: string;
  Vertrag_Einzeln: double;
  Vertrag_Gesamt: double;

  PERSON_R: Integer;
  sAdressat: TStringList;
  fax: string;
  sLohn: TStringList;
  n: Integer;
  zusaetzlich: string;
  OutStr: TStringList;
  MonatsBetrag: double;
  Monat: Integer;
  JahresBetrag: double;
  MonatsStartDatum: TANFIXDate;
begin
  result := TStringList.create;
  //
  sLohn := TStringList.create;
  for n := 0 to 24 do
    sLohn.add('');
  zusaetzlich := '';

  Tier_Art := '';
  Tier_Rasse := '';
  Tier_Name := '';
  Tier_Geburt := '';
  Tier_Geschlecht := '';
  Tier_Taetowiernummer := '';
  Tier_Chipnummer := '';
  Baustelle_Name := '';
  Vertrag_Nummer := '';
  Vertrag_Beginn := '';
  Vertrag_Ende := '';
  Vertrag_Stichtag := '';
  Vertrag_Volumen := '';
  Vertrag_Betrag := '';

  // csv erstellen
  Person := IB_Query1;
  ANSCHRIFT := IB_Query2;
  PERSON_R := Person.FieldByName('RID').AsInteger;
  sAdressat := e_r_Adressat(PERSON_R);

  // Fax
  if Person.FieldByName('PRIV_FAX').IsNull then
    fax := Person.FieldByName('GESCH_FAX').AsString
  else
    fax := Person.FieldByName('PRIV_FAX').AsString;

  // Tier
  TIER_R := FormTierAuswahl.execute(PERSON_R);
  if (TIER_R >= cRID_FirstValid) then
  begin

    Tier := DataModuleDatenbank.nCursor;
    with Tier do
    begin
      sql.add('select * from tier where RID=' + inttostr(TIER_R));
      ApiFirst;
      if not(eof) then
      begin
        Tier_Art := FieldByName('ART').AsString;
        Tier_Rasse := FieldByName('RASSE').AsString;
        Tier_Name := FieldByName('NAME').AsString;
        Tier_Geburt := long2dateLocalized(FieldByName('GEBURT').AsInteger);
        Tier_Geschlecht := FieldByName('GESCHLECHT').AsString;
        Tier_Taetowiernummer := FieldByName('TAETOWIERNUMMER').AsString;
        Tier_Chipnummer := FieldByName('CHIPNUMMER').AsString;
      end;
    end;
    Tier.Free;

  end;

  // Vertrag
  VERTRAG_R := e_r_sql('select max(RID) from VERTRAG where PERSON_R=' + inttostr(PERSON_R));
  if VERTRAG_R >= cRID_FirstValid then
  begin
    cVERTRAG := DataModuleDatenbank.nCursor;
    with cVERTRAG do
    begin
      sql.add('select * from VERTRAG where RID=' + inttostr(VERTRAG_R));
      ApiFirst;
      Baustelle_Name := e_r_sqls('select NAME from BAUSTELLE where RID=' +
        FieldByName('BAUSTELLE_R').AsString);
      Vertrag_Nummer := FieldByName('RID').AsString;
      Vertrag_Beginn := long2dateLocalized(FieldByName('VON').AsDate);
      Vertrag_Ende := long2dateLocalized(FieldByName('BIS').AsDate);
      Vertrag_Stichtag := long2dateLocalized(FieldByName('STICHTAG').AsDate);
      Vertrag_Einzeln := e_r_sqld('select VOLUMEN from BELEG where RID=' + FieldByName('BELEG_R')
        .AsString);
      Vertrag_Gesamt := Vertrag_Einzeln * FieldByName('WIEDERHOLUNGEN').AsInteger;
      Vertrag_Volumen := format('%m', [Vertrag_Einzeln]);
      Vertrag_Betrag := format('%m', [Vertrag_Gesamt]);
    end;
    cVERTRAG.Free;
  end;

  // Lohnsachen
  if (length(Edit3.Text) = 7) then
  begin
    JahresBetrag := 0;
    Monat := 1;
    n := 0;
    repeat

      //
      MonatsStartDatum := date2long('01.' + inttostrN(Monat, 2) + '.' + copy(Edit3.Text, 4, 4));
      MonatsBetrag := e_r_sqld('select sum(betrag) S from ausgangsrechnung where (datum=''' +
        long2date(MonatsStartDatum) + ''') and (KUNDE_R=' + Person.FieldByName('RID')
        .AsString + ')');
      JahresBetrag := JahresBetrag + MonatsBetrag;

      // Zuweisung der Ergebnisse
      sLohn[n] := format('%m', [MonatsBetrag]);
      inc(n);
      sLohn[n] := e_r_LohnKalkulation(MonatsBetrag, MonatsStartDatum);
      inc(n);
      inc(Monat);
    until (Monat > 12);
    sLohn[24] := format('%m', [JahresBetrag]);
    OutStr := TStringList.create;
    Person.FieldByName('BEMERKUNG').AssignTo(OutStr);
    OutStr.add('');
    zusaetzlich := OutStr[0];
    OutStr.Free;
  end;

  with result do
  begin
    add(nosemi(Person.FieldByName('VORNAME').AsString));
    add(nosemi(Person.FieldByName('NACHNAME').AsString));
    add(nosemi(ANSCHRIFT.FieldByName('NAME1').AsString));
    add(nosemi(ANSCHRIFT.FieldByName('NAME2').AsString));
    add(nosemi(ANSCHRIFT.FieldByName('STRASSE').AsString));
    add(nosemi(e_r_ort(ANSCHRIFT)));
    add(nosemi(Person.FieldByName('PRIV_TEL').AsString));
    add(nosemi(fax));
    add(Datum10);
    add(nosemi(Tier_Art));
    add(nosemi(Tier_Rasse));
    add(nosemi(Tier_Name));
    add('"' + nosemi(Tier_Geburt) + '"');
    add(nosemi(Tier_Geschlecht));
    add(nosemi(Tier_Taetowiernummer));
    add(nosemi(Tier_Chipnummer));
    add(nosemi(Person.FieldByName('ANREDE').AsString));
    add(nosemi(Person.FieldByName('ANSPRACHE').AsString));
    add(nosemi(sAdressat[0]));
    add(nosemi(sAdressat[1]));
    add(nosemi(sAdressat[2]));
    add(nosemi(sAdressat[3]));
    add(copy(Edit3.Text, 4, 4));
    add(sLohn[0]);
    add(sLohn[1]);
    add(sLohn[2]);
    add(sLohn[3]);
    add(sLohn[4]);
    add(sLohn[5]);
    add(sLohn[6]);
    add(sLohn[7]);
    add(sLohn[8]);
    add(sLohn[9]);
    add(sLohn[10]);
    add(sLohn[11]);
    add(sLohn[12]);
    add(sLohn[13]);
    add(sLohn[14]);
    add(sLohn[15]);
    add(sLohn[16]);
    add(sLohn[17]);
    add(sLohn[18]);
    add(sLohn[19]);
    add(sLohn[20]);
    add(sLohn[21]);
    add(sLohn[22]);
    add(sLohn[23]);
    add(sLohn[24]);
    add(nosemi(zusaetzlich));
    add(nosemi(Person.FieldByName('BERUF').AsString));
    add('"' + long2dateLocalized(Person.FieldByName('GEBURTSTAG').AsDate) + '"');
    add(nosemi(Baustelle_Name));
    add(nosemi(Vertrag_Nummer));
    add(nosemi(Vertrag_Beginn));
    add(nosemi(Vertrag_Ende));
    add(nosemi(Vertrag_Stichtag));
    add(nosemi(Vertrag_Volumen));
    add(nosemi(Vertrag_Betrag));
    add(nosemi(copy(Person.FieldByName('HAUPT_NUMMER').AsString, 5, 4)));
    add(nosemi(Person.FieldByName('PRIV_FAX').AsString));
    add(nosemi(Person.FieldByName('VERSICHERUNGSNUMMER').AsString));
    add(nosemi(Person.FieldByName('USER_PWD').AsString));
  end;
  sAdressat.Free;
  sLohn.Free;
end;

procedure TFormPerson.Image1Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Mobil');
end;

var
  LastRow: Integer = -1;
  LastBackgroundCol: TColor;
  LastFontCol: TColor;

procedure TFormPerson.IB_Grid1GetCellProps(Sender: TObject; ACol, ARow: Integer;
  AState: TGridDrawState; var AColor: TColor; AFont: TFont);
var
  PAPERCOLOR: string;
begin

  // Wird die fokusierte Zeile ausgegeben muss das Caching verhindert werden,
  // da sich das Grid in der ersten Zeile zunächst leer selbst zeichnet,
  // danach die erste Zeile nochmals, diesmal mit Daten, durch das Caching
  // würde der Fehler entstehen, dass die Farbe aus dem ersten Zeichenversuch
  // in den 2. Versuch übernommen wird.
  if gdFocused in AState then
    LastRow := -1;

  if not(gdFixed in AState) and not(gdFocused in AState) then
    with IB_Grid1 do
    begin
      if (ARow <> LastRow) then
      begin

        // Spalte der "PAPERCOLOR" bestimmen
        if (cCOL_PAPERCOLOR <= 0) then
          cCOL_PAPERCOLOR := ColOfGrid(IB_Grid1, 'PAPERCOLOR');
        if (cCOL_PAPERCOLOR <= 0) then
          raise Exception.create('Spalte "PAPERCOLOR" ist undefiniert!');

        // Wert aus PAPERCOLOR bestimmen
        PAPERCOLOR := GetCellDisplayText(cCOL_PAPERCOLOR, ARow);
        if (PAPERCOLOR <> '') then
          LastBackgroundCol := strtointdef(PAPERCOLOR, Color)
        else
          LastBackgroundCol := Color;

        //
        LastFontCol := VisibleContrast(LastBackgroundCol);

        // Cache-Flag setzen
        LastRow := ARow;
      end;

      AColor := LastBackgroundCol;
      AFont.Color := LastFontCol;
    end;
end;

procedure TFormPerson.IB_Grid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ssAlt in Shift then
    if (Key = ord('X')) then
    begin
      OLAP.DoContextOLAP(IB_Grid1);
      Key := 0;
    end;
end;

procedure TFormPerson.SpeedButton11Click(Sender: TObject);
begin
  csvOne;
  dhlSave;
end;

procedure TFormPerson.SpeedButton12Click(Sender: TObject);
begin
  openShell('mailto:' + IB_Edit9.Text);
end;

procedure TFormPerson.SpeedButton13Click(Sender: TObject);
begin
  openShell('http://' + IB_Edit10.Text);
end;

procedure TFormPerson.SpeedButton14Click(Sender: TObject);
begin
  BeginHourGlass;
  FormOLAP.DoContextOLAP(IB_Grid1);
  with IB_Query1 do
  begin
    close;
    qSelectList(IB_Query1, FormOLAP.RohdatenFName(0));
    Open;
    inOLAPmode := true;
  end;
  EndHourGlass;
end;

procedure TFormPerson.Button15Click(Sender: TObject);
var
  HeaderNames: TStringList;
  DatenVorhanden, DatenWeglassen: Boolean;
  Aenderungen: Integer;
  Neuanlagen: Integer;
  r, c, i: Integer;
  qPERSON: TIB_Query;
  qANSCHRIFT: TIB_Query;
  PERSON_R: Integer;
  PERSON_R_Unbenutzt: Integer;
  PERSON_R_Altbestand: Integer;

  Tabelle: string;
  Spalte: string;
  CellStr: string;
  ModifiedStr: string;
  IgnoreField: Boolean;
  Bemerkung: TStringList;
  extraSQL: TStringList;
  FieldNames: TStringList;
  XLS: TXLSFIle;
  FName: string;

  procedure TagDBField(FieldName: string; BoolValue: Boolean);
  begin
    if BoolValue then
      qPERSON.FieldByName(FieldName).AsString := cC_True
    else
      qPERSON.FieldByName(FieldName).AsString := cC_False;
  end;

begin
  //
  if (Button15.Caption = 'XLS-Import') then
  begin
    BeginHourGlass;
    Bemerkung := TStringList.create;
    extraSQL := TStringList.create;
    FieldNames := TStringList.create;
    HeaderNames := TStringList.create;
    qPERSON := DataModuleDatenbank.nQuery;
    qANSCHRIFT := DataModuleDatenbank.nQuery;
    XLS := TXLSFIle.create(true);
    FName := Edit5.Text;
    patchPath(FName);

    UserBreak := false;
    Button15.Caption := 'Abbruch';
    with XLS do
    begin
      Open(FName);

      with qPERSON do
      begin
        sql.add('select * from PERSON where RID=:CROSSREF for update');
        prepare;
        for r := 0 to pred(Fields.ColumnCount) do
          FieldNames.add('PERSON.' + Fields[r].FieldName);
      end;

      with qANSCHRIFT do
      begin
        sql.add('select * from ANSCHRIFT where RID=:CROSSREF for update');
        prepare;
        for r := 0 to pred(Fields.ColumnCount) do
          FieldNames.add('ANSCHRIFT.' + Fields[r].FieldName);
      end;

      // Spalten-Überschriften speichern
      for c := 1 to ColCountInRow(1) do
      begin
        Spalte := StrFilter(
          { } GetStringFromCell(1, c),
          { } '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_.');
        repeat
          i := pos('_', Spalte);
          if (i = 1) then
            system.delete(Spalte, 1, 1);
        until i <> 1;
        HeaderNames.add(Spalte);
      end;

      // Init
      Aenderungen := 0;
      Neuanlagen := 0;
      PERSON_R_Unbenutzt := cRID_Null;
      PERSON_R := cRID_Null;

      // Nun der Import
      for r := 2 to RowCount do // Zeilen
      begin

        DatenVorhanden := false;
        DatenWeglassen := false;
        Bemerkung.clear;
        extraSQL.clear;

        try
          for c := 1 to ColCountInRow(1) do // Spalten
          begin
            if DatenWeglassen then
              break;
            IgnoreField := false;
            Tabelle := nextp(HeaderNames[pred(c)], '.', 0);
            Spalte := nextp(HeaderNames[pred(c)], '.', 1);
            if (Spalte <> '') then
            begin

              CellStr := cutblank(GetStringFromCell(r, c));
              if (c = 1) then
              begin

                if (Spalte = 'RID') then
                begin

                  // eine Änderungen einspielen!
                  IgnoreField := true;
                  PERSON_R := strtointdef(CellStr, 0);

                  if (e_r_sql('select COUNT(RID) from PERSON where RID=' + inttostr(PERSON_R)) = 0)
                  then
                  begin
                    e_x_sql('update PERSON set RID=' + inttostr(PERSON_R) + ' where RID=' +
                      inttostr(e_w_PersonNeu));
                  end;

                end
                else
                begin

                  // Neuanlage!
                  if (PERSON_R_Unbenutzt = cRID_Null) then
                  begin
                    PERSON_R := e_w_PersonNeu;
                    inc(Neuanlagen);
                    PERSON_R_Unbenutzt := PERSON_R;
                  end
                  else
                  begin
                    PERSON_R := PERSON_R_Unbenutzt;
                  end;

                end;

                // PERSON
                qPERSON.ParamByName('CROSSREF').AsInteger := PERSON_R;
                qPERSON.Open;
                qPERSON.edit;
                qPERSON.FieldByName('NACHNAME').AsString := '';

                // ANSCHRIFT
                qANSCHRIFT.ParamByName('CROSSREF').AsInteger :=
                  qPERSON.FieldByName('PRIV_ANSCHRIFT_R').AsInteger;
                qANSCHRIFT.Open;
                qANSCHRIFT.edit;

              end;

              if (CellStr <> '') then
                repeat

                  if (Spalte = 'ZWE') then
                  begin
                    ModifiedStr := noblank(AnsiUpperCase(CellStr));
                    repeat

                      // Profil03=(D) Dauerauftrag
                      TagDBField('A02', ModifiedStr = 'D');

                      // Profil04=(L) Lastschrift
                      TagDBField('A03', ModifiedStr = 'J');

                      // Profil05=(M) Manueller Zahler
                      TagDBField('A04', ModifiedStr = 'M');

                      // Profil06=(G) anderer zahlt
                      TagDBField('A05', pos('G', ModifiedStr) > 0);

                      // Profil07=(X) Verweigerer
                      TagDBField('A06', ModifiedStr = 'X');

                      // Profil08=(U) Unterhaltsreinigung
                      TagDBField('A07', ModifiedStr = 'U');

                      // Profil09=(Y) Objekt
                      TagDBField('A08', (ModifiedStr = '') or (ModifiedStr = 'T1') or
                        (ModifiedStr = 'T2') or (ModifiedStr = 'U') or (ModifiedStr = 'Y') or
                        (ModifiedStr = 'YS') or (ModifiedStr = 'S'));

                      // Profil10=(T) Treppenhaus
                      TagDBField('A09', pos('T', ModifiedStr) > 0);

                    until true;
                  end;

                  if (Spalte = 'SQL') then
                  begin
                    DatenVorhanden := true;
                    ersetze('$PERSON_R', inttostr(PERSON_R), CellStr);
                    extraSQL.add(CellStr);
                    IgnoreField := true;
                  end;

                  if (Spalte = 'BEMERKUNG') then
                  begin
                    DatenVorhanden := true;
                    Bemerkung.add(CellStr);
                    IgnoreField := true;
                  end;

                  if (Spalte = 'EMAIL_NEU') then
                  begin
                    i := e_r_sql('select count(RID) from PERSON where EMAIL containing ' +
                      SQLstring(CellStr));
                    if (i > 0) then
                      DatenWeglassen := true
                    else
                    begin
                      DatenVorhanden := true;
                      qPERSON.FieldByName('EMAIL').AsString := CellStr;
                    end;
                    break;
                  end;

                  if (Spalte = 'VERTRAG') then
                  begin
                    DatenVorhanden := true;
                    extraSQL.add('insert into VERTRAG (RID,PERSON_R,BELEG_R) values (' +
                      { } '0,' +
                      { } inttostr(PERSON_R) + ',' +
                      { } CellStr + ')');

                    if not(DatenWeglassen) then
                      if (qPERSON.FieldByName('VORNAME').AsString = '') then
                        DatenWeglassen := true;
                    if not(DatenWeglassen) then
                      if (qPERSON.FieldByName('NACHNAME').AsString = '') then
                        DatenWeglassen := true;
                    if not(DatenWeglassen) then
                      if (qANSCHRIFT.FieldByName('ORT').AsString = '') then
                        DatenWeglassen := true;

                    if not(DatenWeglassen) then
                    begin
                      PERSON_R_Altbestand := e_r_sql(
                        { } 'select' +
                        { } ' PERSON.RID ' +
                        { } 'from' +
                        { } ' PERSON ' +
                        { } 'join' +
                        { } ' ANSCHRIFT ' +
                        { } 'on' +
                        { } ' (PERSON.PRIV_ANSCHRIFT_R=ANSCHRIFT.RID) ' +
                        { } 'where' +
                        { } ' (PERSON.VORNAME=' + SQLstring(qPERSON.FieldByName('VORNAME').AsString)
                        + ') and' +
                        { } ' (PERSON.NACHNAME=' + SQLstring(qPERSON.FieldByName('NACHNAME')
                        .AsString) + ') and' +
                        { } ' (ANSCHRIFT.ORT=' + SQLstring(qANSCHRIFT.FieldByName('ORT')
                        .AsString) + ')');
                      if (PERSON_R_Altbestand >= cRID_FirstValid) then
                      begin
                        DatenWeglassen := true;
                        i := e_r_sql(
                          { } 'select RID from VERTRAG where ' +
                          { } ' (PERSON_R=' + inttostr(PERSON_R_Altbestand) + ') and' +
                          { } ' (BELEG_R=' + CellStr + ')');
                        if (i < cRID_FirstValid) then
                        begin
                          e_x_sql('insert into VERTRAG (RID,PERSON_R,BELEG_R) values (' +
                            { } '0,' +
                            { } inttostr(PERSON_R_Altbestand) + ',' +
                            { } CellStr + ')');

                          inc(Aenderungen);
                        end;
                      end;

                    end;
                    break;
                  end;

                  if (Spalte = 'PLZ') then
                  begin
                    if pos('-', CellStr) > 0 then
                      CellStr := nextp(CellStr, '-', 1);
                  end;

                  if (Spalte = 'PLZORT') then
                  begin
                    qANSCHRIFT.FieldByName('PLZ').AsInteger :=
                      strtointdef(nextp(CellStr, ' ', 0), 0);
                    qANSCHRIFT.FieldByName('ORT').AsString := nextp(CellStr, ' ', 1);
                    DatenVorhanden := true;
                    break;
                  end;

                  // Unbekannte Spalten
                  if (FieldNames.indexof(Tabelle + '.' + Spalte) = -1) then
                  begin
                    DatenVorhanden := true;
                    Bemerkung.add(Spalte + '=' + CellStr);
                    break;
                  end;

                  if IgnoreField then
                    break;

                  if (Tabelle = 'PERSON') then
                  begin
                    qPERSON.FieldByName(Spalte).AsString := CellStr;
                    DatenVorhanden := true;
                  end;

                  if (Tabelle = 'ANSCHRIFT') then
                  begin
                    qANSCHRIFT.FieldByName(Spalte).AsString := CellStr;
                    DatenVorhanden := true;
                  end;

                until true;
            end;
          end;
        except
          on E: Exception do
          begin
            DatenVorhanden := false;
            if doit(
              { } 'Zeile ' + inttostr(r) + '' + #13 +
              { } 'Spalte "' + Spalte + '"' + #13 +
              { } 'Inhalt: "' + CellStr + '"' + #13 +
              { } '----------------------------------------' + #13 +
              { } E.Message + #13 +
              { } '----------------------------------------' + #13 +
              { } 'Import abbrechen', true) then
              break;
          end;
        end;

        if DatenVorhanden and not(DatenWeglassen) then
        begin

          qPERSON.FieldByName('BEMERKUNG').assign(Bemerkung);

          try
            qANSCHRIFT.post;
            qANSCHRIFT.close;
          except
            on E: Exception do
            begin
              if doit(
                { } 'Zeile ' + inttostr(r) + '' + #13 +
                { } 'ANSCHRIFT.POST' + #13 +
                { } '----------------------------------------' + #13 +
                { } E.Message + #13 +
                { } '----------------------------------------' + #13 +
                { } 'Import abbrechen', true) then
                break;
            end;
          end;

          try
            qPERSON.post;
            qPERSON.close;
          except
            on E: Exception do
            begin
              if doit(
                { } 'Zeile ' + inttostr(r) + '' + #13 +
                { } 'PERSON.POST' + #13 +
                { } '----------------------------------------' + #13 +
                { } E.Message + #13 +
                { } '----------------------------------------' + #13 +
                { } 'Import abbrechen', true) then
                break;
            end;
          end;

          // Folge SQL
          for i := 0 to pred(extraSQL.count) do
          begin
            try
              e_x_sql(extraSQL[i]);
            except
              on E: Exception do
              begin
                if doit(
                  { } 'Zeile ' + inttostr(r) + '' + #13 +
                  { } 'SQL: +' + extraSQL[i] + #13 +
                  { } '----------------------------------------' + #13 +
                  { } E.Message + #13 +
                  { } '----------------------------------------' + #13 +
                  { } 'Import abbrechen', true) then
                  break;
              end;
            end;
          end;

          PERSON_R_Unbenutzt := cRID_Null;

        end
        else
        begin
          qANSCHRIFT.Cancel;
          qANSCHRIFT.close;
          qPERSON.Cancel;
          qPERSON.close;
        end;

        Label56.Caption :=
        { } 'Zeile ' +
        { } inttostr(r) + '/' + inttostr(RowCount) +
        { } ' (' + inttostr(Neuanlagen) + ' Neuanlagen / ' +
        { } inttostr(Aenderungen) + ' Änderungen bisher)';
        application.processmessages;

        if UserBreak then
          break;
      end;
    end;
    Button15.Caption := 'XLS-Import';
    Label23.Caption := '-';
    qANSCHRIFT.Free;
    qPERSON.Free;
    Bemerkung.Free;
    extraSQL.Free;
    FieldNames.Free;
    HeaderNames.Free;
    XLS.Free;
    EndHourGlass;
  end
  else
  begin
    Button15.Caption := 'Warten';
    application.processmessages;
    UserBreak := true;
  end;
end;

end.
