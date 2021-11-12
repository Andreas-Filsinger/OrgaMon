{
  |††††††___                  __  __
  |†††††/ _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |††††| | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |††††| |_| | | | (_| | (_| | |  | | (_) | | | |
  |†††††\___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |†††††††††††††††|___/
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
unit Buchhalter;

interface

uses
  // System
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, Grids, ComCtrls,
  Buttons, ExtCtrls, ImgList, System.ImageList,

  // IB-Objects
  IB_Components, IB_Access, IB_Grid,

  // Jedi
  JvGIF, JvExControls, JvArrayButton,
  JvAnimatedImage, JvGIFCtrl,
  JvComponentBase, JvFormPlacement,

  // Anfix
  gplists, DCPcrypt2, DCPmd5,
  DTA, WordIndex, anfix,

  // OrgaMon
  Sperre;

type
  TFormBuchhalter = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    IB_Cursor1: TIB_Cursor;
    ImageList1: TImageList;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    Timer1: TTimer;
    IB_Query2: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    TabSheet7: TTabSheet;
    Panel1: TPanel;
    Label2: TLabel;
    SpeedButton11: TSpeedButton;
    SpeedButton28: TSpeedButton;
    Image2: TImage;
    IB_Grid1: TIB_Grid;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button7: TButton;
    Panel4: TPanel;
    SpeedButton1: TSpeedButton;
    Label13: TLabel;
    Label14: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    SpeedButton29: TSpeedButton;
    SpeedButton30: TSpeedButton;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    JvGIFAnimator2: TJvGIFAnimator;
    SpeedButton41: TSpeedButton;
    Label1: TLabel;
    Image1: TImage;
    Button1: TButton;
    Button4: TButton;
    Edit4: TEdit;
    Edit5: TEdit;
    Button12: TButton;
    Edit10: TEdit;
    Button6: TButton;
    Memo1: TMemo;
    Edit15: TEdit;
    Panel5: TPanel;
    Label40: TLabel;
    Label41: TLabel;
    Label3: TLabel;
    SpeedButton40: TSpeedButton;
    Label33: TLabel;
    Label12: TLabel;
    Label23: TLabel;
    Image3: TImage;
    Button5: TButton;
    CheckBox3: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit11: TEdit;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    Edit12: TEdit;
    ListBox1: TListBox;
    Edit9: TEdit;
    Edit3: TEdit;
    Button2: TButton;
    CheckBox4: TCheckBox;
    CheckBox7: TCheckBox;
    Panel6: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    SpeedButton3: TSpeedButton;
    Label10: TLabel;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton27: TSpeedButton;
    SpeedButton31: TSpeedButton;
    Label28: TLabel;
    SpeedButton34: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Image4: TImage;
    Edit1: TEdit;
    DrawGrid1: TDrawGrid;
    StaticText5: TStaticText;
    ComboBox1: TComboBox;
    Button20: TButton;
    Button3: TButton;
    Edit8: TEdit;
    Edit7: TEdit;
    Panel2: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    SpeedButton12: TSpeedButton;
    Label21: TLabel;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton17: TSpeedButton;
    SpeedButton18: TSpeedButton;
    SpeedButton19: TSpeedButton;
    SpeedButton20: TSpeedButton;
    JvArrayButton1: TJvArrayButton;
    SpeedButton22: TSpeedButton;
    SpeedButton23: TSpeedButton;
    SpeedButton24: TSpeedButton;
    SpeedButton21: TSpeedButton;
    SpeedButton25: TSpeedButton;
    SpeedButton26: TSpeedButton;
    SpeedButton32: TSpeedButton;
    Label43: TLabel;
    Label45: TLabel;
    SpeedButton38: TSpeedButton;
    SpeedButton39: TSpeedButton;
    SpeedButton33: TSpeedButton;
    SpeedButton42: TSpeedButton;
    SpeedButton46: TSpeedButton;
    SpeedButton47: TSpeedButton;
    DrawGrid2: TDrawGrid;
    StaticText1: TStaticText;
    ComboBox2: TComboBox;
    DrawGrid3: TDrawGrid;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    StaticText2: TStaticText;
    Button13: TButton;
    Button18: TButton;
    Button19: TButton;
    CheckBox5: TCheckBox;
    Button21: TButton;
    CheckBox6: TCheckBox;
    Panel3: TPanel;
    Edit13: TEdit;
    Panel7: TPanel;
    Button22: TButton;
    Panel8: TPanel;
    SpeedButton37: TSpeedButton;
    SpeedButton44: TSpeedButton;
    SpeedButton45: TSpeedButton;
    SpeedButton48: TSpeedButton;
    Edit14: TEdit;
    SpeedButton43: TSpeedButton;
    Button11: TButton;
    IB_Grid2: TIB_Grid;
    Panel9: TPanel;
    Label11: TLabel;
    Label15: TLabel;
    Label22: TLabel;
    Label29: TLabel;
    SpeedButton35: TSpeedButton;
    Label30: TLabel;
    Label31: TLabel;
    SpeedButton36: TSpeedButton;
    Memo2: TMemo;
    Edit2: TEdit;
    Edit6: TEdit;
    Button23: TButton;
    ComboBox3: TComboBox;
    JvFormStorage1: TJvFormStorage;
    SpeedButton49: TSpeedButton;
    SpeedButton50: TSpeedButton;
    Label27: TLabel;
    SpeedButton51: TSpeedButton;
    ProgressBar1: TProgressBar;
    Label32: TLabel;
    Label39: TLabel;
    Edit16: TEdit;
    Edit17: TEdit;
    CheckBox8: TCheckBox;
    SpeedButton52: TSpeedButton;
    procedure DrawGrid1DblClick(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure FormActivate(Sender: TObject);
    procedure TabSheet4Show(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure DrawGrid2DblClick(Sender: TObject);
    procedure DrawGrid2DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure ComboBox2KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox2Select(Sender: TObject);
    procedure SpeedButton20Click(Sender: TObject);
    procedure SpeedButton23Click(Sender: TObject);
    procedure DrawGrid3DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure SpeedButton24Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton22Click(Sender: TObject);
    procedure SpeedButton21Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure SpeedButton25Click(Sender: TObject);
    procedure SpeedButton26Click(Sender: TObject);
    procedure TabSheet5Show(Sender: TObject);
    procedure SpeedButton27Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button20Click(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure SpeedButton19Click(Sender: TObject);
    procedure SpeedButton30Click(Sender: TObject);
    procedure SpeedButton29Click(Sender: TObject);
    procedure SpeedButton28Click(Sender: TObject);
    procedure SpeedButton31Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton32Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure SpeedButton34Click(Sender: TObject);
    procedure Edit8KeyPress(Sender: TObject; var Key: Char);
    procedure JvArrayButton1ArrayButtonClicked(ACol, ARow: Integer);
    procedure Button6Click(Sender: TObject);
    procedure Edit10KeyPress(Sender: TObject; var Key: Char);
    procedure Button21Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure Edit13KeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton38Click(Sender: TObject);
    procedure SpeedButton39Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton40Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure SpeedButton41Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure TabSheet6Show(Sender: TObject);
    procedure SpeedButton35Click(Sender: TObject);
    procedure SpeedButton36Click(Sender: TObject);
    procedure SpeedButton37Click(Sender: TObject);
    procedure TabSheet7Show(Sender: TObject);
    procedure IB_Grid2GetDisplayText(Sender: TObject; ACol, ARow: Integer; var AString: string);
    procedure SpeedButton42Click(Sender: TObject);
    procedure SpeedButton43Click(Sender: TObject);
    procedure SpeedButton44Click(Sender: TObject);
    procedure SpeedButton45Click(Sender: TObject);
    procedure SpeedButton46Click(Sender: TObject);
    procedure SpeedButton47Click(Sender: TObject);
    procedure SpeedButton48Click(Sender: TObject);
    procedure SpeedButton33Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure SpeedButton49Click(Sender: TObject);
    procedure SpeedButton50Click(Sender: TObject);
    procedure SpeedButton51Click(Sender: TObject);
    procedure SpeedButton52Click(Sender: TObject);
  private
    { Private-Deklarationen }
    DTA_Header: DtaDataType;
    DTA_Posten: CSatzType;

    Initialized: boolean;
    InitializedTab4: boolean;
    InitializedTab5: boolean;
    iColor_Rosa: TColor;
    iColor_Gruen: TColor;
    iColor_Braun: TColor;
    iColor_Rot: TColor;

    // Allgemeines f¸r die Kontoausz¸ge
    ItemKontoAuszugRIDs: TgpIntegerList;
    ItemKontoAuszugAll: TgpIntegerList;
    KontoAuszugIndex: TWordIndex;

    NeueEingaengeSaldo: double;
    ItemMarked: TgpIntegerList;
    StatusBMPs: array of TBitMap;
    cPlanY: Integer;

    // Eingangs Zahlungen, einzelne Zeile
    sBuchungsText: TStringList;
    sBetrag: double;
    sDatum: TAnfixDate;
    _NewPoint: Integer;

    // Debi-Suche
    ItemDebiRIDs: TgpIntegerList;
    DebiSearchIndex: TWordIndex;

    // ausf¸hrlichere Suche AN/AUS
    mehrDebis: boolean;

    // ToDo Text aus Datei anzeigen?
    ToDoMode : boolean;
    ToDoList : TStringList;

    // Aktueller Forderungsausgleich-Vorschlag
    // Grundlage: cBuch_HeaderLineForderungen
    sForderungen: TStringList;
    sForderungenFixed: TStringList; // unver‰nderlicher

    // durchzuf¸hrende Ausgleichsbuchungen, Anzeigegrundlage
    // Grundlage: cBuch_HeaderLineForderungen
    sAusgleich: TStringList; // "Ausgleich" siehe cBuch_HeaderLineAusgleich
    sAusgleich_FirstButtonOffset: Integer;
    // Element, ab dem die Anzeige erfolgt

    BelegMode: boolean;

    // Caching des Debi-Context
    DrawGrid3_PERSON_R: Integer;
    DrawGrid2_LastFocused: Integer;

    //
    isGreen: boolean; // Person erscheint als Volltreffer
    isRose: boolean; // Person erscheint als typischer 1590 Volltreffer
    sSQLwhere: TStringList;

    // lastschrift
    KlassischeTAN: string;
    LastschriftJobID: string;
    WarteAufMeldung: boolean;

    function CreateSymbol(id: Integer): TBitMap;
    procedure Erzeuge_sForderungen(PERSON_R: Integer);
    procedure Erzeuge_Show_sYellow(Zahlung: double; SuchePassendeKombination: boolean);

    procedure SyncKontoUmsaetze;
    procedure SyncNeueEingaenge;

    procedure hideForderung(BUCH_R: Integer);
    procedure bucheAufKonto(ZielKonto: string);
    procedure nextRow(dg : TDrawGrid);

    procedure Draw_NeueEingaengeSaldo(saldo: double);
    procedure Draw_PersonSaldo(saldo: double);

    procedure Disable_AusgleichCache;
    procedure Disable_DebiCache;

    procedure setNewPoint(BUCH_R: Integer);
    procedure RefreshKontoAuszug;
    procedure RefreshNeueEingaenge;
    procedure RefreshKontoCombos;
    procedure RefreshAusgleichCombos;
    procedure RefreshForderungen;

    procedure RefreshKontoSearch;
    procedure RefreshDebis(AddInfo: string = '');
    function SetScriptValue(ParamName, ParamValue: string): Integer;
    procedure SetColorAndAccount(ParamValue:string);
    procedure setDebiContext(s: TStrings = nil; b: double = 0.0; d: TAnfixDate = 0);
    function getSQLwhere: TStringList;

    function rPERSON_R: Integer;
    function rBUCH_R: Integer;
    function rERRORs: Integer;
    function getActiveGrid: TDrawGrid;
    function e_x_KontoSyncREST(BLZ, KontoNummer, JobID, LogID: string; AlleUmsaetze: boolean; Buchen: boolean): Integer;
    function e_r_SaldoREST(BLZ, KontoNummer, JobID: string): double;
    procedure ensureTimerState;
    function LogKontoFName(KontoNummer: string; BUCH_R: Integer): string;
    procedure MemoLog(s: TStrings); overload;
    procedure MemoLog(s: String); overload;
    procedure showBeleg(ForderungINdex: Integer);
    procedure CheckInitialized;

  public
    // Auffrischen der Liste
    refreshOnActivate: boolean;

    function e_w_KontoSync(Konten: string; AlleUmsaetze: boolean = false; Buchen: boolean = true): Integer;
    procedure e_r_Saldo(Konten: string);
    procedure RefreshKontoAuszugSaldo(saldo: double);
    function e_r_Log: TStringList; // Lese Log-Datei der letzten TAN

    procedure RefreshLastschriften;
    procedure setIdentitaetGruen(PERSON_R: Integer);
    procedure setIdentitaetRosa(PERSON_R: Integer);
    function Suchbegriff: string;
    procedure doSuche;

    procedure e_w_HBCI_Group(TAN: string; JobID: string);
    procedure e_w_HBCI_EreignisDel(EREIGNIS_R: Integer; Grund: string);

    procedure setContext(Konto: string; BELEG_R: Integer = -1); overload;
    procedure setContext(BUCH_R: Integer); overload;
    procedure setContext(RIDs: TgpIntegerList); overload;
  end;

var
  FormBuchhalter: TFormBuchhalter;

implementation

uses
  Math, c7zip,

  html, Geld,
  wanfix,
  globals, dbOrgaMon,
  srvXMLRPC,
  GUIhelp,
  ExcelHelper, CareServer, CareTakerClient,
  Datenbank, main,
  Funktionen_Basis,
  Funktionen_Buch,
  Funktionen_Beleg,
  Funktionen_OLAP,
  Funktionen_Artikel,
  Funktionen_Auftrag,
  Funktionen_Transaktion,
  Funktionen_LokaleDaten,
  Bearbeiter, Buchung, Person,
  Belege, Ausgangsrechnungen, PersonSuche,
  OLAP;
{$R *.dfm}

const
  cButtonGridRows = 4;

procedure TFormBuchhalter.ComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    ComboBox1Select(Sender);
  end;
end;

procedure TFormBuchhalter.ComboBox2KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    ComboBox2Select(Sender);
  end;
end;

procedure TFormBuchhalter.ComboBox1Select(Sender: TObject);
begin
  ItemKontoAuszugRIDs.clear;
  RefreshKontoAuszug;
end;

procedure TFormBuchhalter.ComboBox2Select(Sender: TObject);
begin
  RefreshNeueEingaenge;
end;

function TFormBuchhalter.CreateSymbol(id: Integer): TBitMap;
begin
  result := TBitMap.Create;
  ImageList1.GetBitmap(id, result);
end;

procedure TFormBuchhalter.Disable_AusgleichCache;
begin
  DrawGrid3_PERSON_R := -1;
end;

procedure TFormBuchhalter.Disable_DebiCache;
begin
  DrawGrid2_LastFocused := -1;
end;

function TFormBuchhalter.Suchbegriff: string;
begin
  result := edit1.Text;
  if (Edit16.Text<>'') then
   result := result + ' A' + edit16.Text + '.';
  if (Edit17.Text<>'') then
   result := result + ' U' + edit17.Text + '.';
end;

procedure TFormBuchhalter.doSuche;
var
  n: Integer;
  FName: string;
begin
  BeginHourGlass;
  if assigned(KontoAuszugIndex) then
    KontoAuszugIndex.ReloadIfNew
  else
  begin
    FName := b_r_KontoSuchindexFName(ComboBox1.Text);
    if not(FileExists(FName)) then
      RefreshKontoSearch;
    KontoAuszugIndex := TWordIndex.Create(nil);
    KontoAuszugIndex.LoadFromFile(FName);
  end;
  KontoAuszugIndex.search(Suchbegriff);
  if (KontoAuszugIndex.FoundList.count > 0) then
  begin
    ItemKontoAuszugRIDs.clear;
    for n := 0 to pred(KontoAuszugIndex.FoundList.count) do
      ItemKontoAuszugRIDs.add(Integer(KontoAuszugIndex.FoundList[n]));
    ItemKontoAuszugRIDs.sort;
    with DrawGrid1 do
    begin
      RowCount := ItemKontoAuszugRIDs.count;
      Refresh;
      SecureSetRow(DrawGrid1, pred(RowCount));
    end;
    if (ItemKontoAuszugRIDs.count > 0) and (ItemKontoAuszugRIDs.count < 500) then
      RefreshKontoAuszugSaldo(e_r_sqld('select SUM(BETRAG) from BUCH where RID in ' + ListAsSQL(ItemKontoAuszugRIDs)))
    else
      RefreshKontoAuszugSaldo(0);
  end
  else
  begin
    ShowMessage('Nichts gefunden!');
    Edit1.SetFocus;
  end;
  EndHourGlass;
end;

procedure TFormBuchhalter.bucheAufKonto(ZielKonto: string);
var
  BUCH_R: Integer;
  qBUCH: TIB_Query;
  ScriptText: TStringList;
  Betrag: double;
  sDiagnose: TStringList;
begin
  sDiagnose := TStringList.Create;
  BUCH_R := rBUCH_R;
  if (BUCH_R >= cRID_FirstValid) then
  begin
    BeginHourGlass;

    // neuen Saldo auffrischen
    Betrag := e_r_sqld('select BETRAG from BUCH where RID=' + inttostr(BUCH_R));
    Draw_NeueEingaengeSaldo(NeueEingaengeSaldo - Betrag);

    // Buchung durchf¸hren
    qBUCH := DataModuleDatenbank.nQuery;
    with qBUCH do
    begin
      sql.add('select SKRIPT,GEGENKONTO from BUCH');
      sql.add('where RID=' + inttostr(BUCH_R));
      sql.add('for update');
      open;
      first;
      if not(eof) then
      begin
        ScriptText := TStringList.Create;
        FieldByName('SKRIPT').AssignTo(ScriptText);
        edit;
        if (ZielKonto = cKonto_Bank) then
          ScriptText.values['COLOR'] := cColor_Gruen
        else
          ScriptText.values['COLOR'] := cColor_Rosa;
        ScriptText.values['SATZ'] := '';
        FieldByName('SKRIPT').Assign(ScriptText);
        FieldByName('GEGENKONTO').AsString := ZielKonto;
        ScriptText.free;
        post;
      end;
    end;
    qBUCH.free;

    // Folgebuchungen sicherstellen
    b_w_buche(BUCH_R);

    // aus der Liste entfernen
    hideForderung(BUCH_R);
    EndHourGlass;

    FormCareServer.ShowIfError(sDiagnose);

  end;
  sDiagnose.free;
end;

procedure TFormBuchhalter.Button10Click(Sender: TObject);
begin
  with IB_Query1 do
    FormAusgangsrechnungen.setContext(FieldByName('PERSON_R').AsInteger, FieldByName('BELEG_R').AsInteger);
end;

function FeedBack (key : Integer; value : string = '') : Integer;
begin
  with FormBuchhalter do
  begin
    case Key of
     cFeedBack_ProgressBar_Max : begin
                                  Progressbar1.Max := StrToIntDef(value,0);
                                  Progressbar1.Step := 1;
                                 end;
     cFeedBack_ProgressBar_Position : Progressbar1.Position := StrToIntDef(value,0);
     cFeedBack_ProgressBar_stepit : Progressbar1.StepIt;
    end;
  end;
end;

procedure TFormBuchhalter.Button11Click(Sender: TObject);
var
  EREIGNIS_R: Integer;
begin
  //
  EREIGNIS_R := IB_Query2.FieldByName('RID').AsInteger;
  if (EREIGNIS_R < cRID_FirstValid) then
  begin
    ShowMessage('Es gibt nichts zu buchen');
    exit;
  end;

  if doit(
    { } 'Die Ausbuchung wird in der Regel durch' + #13 +
    { } 'den Reiter "Ausgleich Forderungen" durchgef¸hrt' + #13 +
    { } 'sobald die Gutschrift erfolgt ist. Dieser Schritt' + #13 +
    { } 'ist also nur in Ausnahmef‰llen notwendig.' + #13 +
    { } #13 +
    { } 'Wurde die Sammellastschrift erfolgreich' + #13 +
    { } 'eingereicht? Wurde auch ein Zahlungseingang sichergestellt?' + #13 +
    { } 'Darf nun der Zahlungseingang f¸r' + #13 +
    { } 'alle Einzugsmandate verbucht werden') then
  begin
    BeginHourGlass;
    b_w_ForderungAusgleich(EREIGNIS_R,FeedBack);
    IB_Query2.Refresh;
    EndHourGlass;
  end;
end;

procedure TFormBuchhalter.Button12Click(Sender: TObject);

  function split(s: string; Delimiter: string): TStringList;
  const
    cQuote = '"';
  var
    k: Integer;
  begin
    result := TStringList.Create;
    while (s <> '') do
    begin

      if (s[1] = cQuote) then
      begin
        Delete(s, 1, 1);
        k := pos(cQuote, s);
        result.add(copy(s, 1, pred(k)));
        Delete(s, 1, k);
        k := pos(Delimiter, s);
        if (k > 0) then
          Delete(s, 1, k);
        continue;
      end;

      if (s[1] = Delimiter) then
      begin
        Delete(s, 1, 1);
        result.add('');
        continue;
      end;

      k := pos(Delimiter, s);
      if (k > 0) then
      begin
        result.add(copy(s, 1, pred(k)));
        Delete(s, 1, k);
      end
      else
      begin
        result.add(s);
        break;
      end;

    end;
  end;

  function fmBLZ(s: string): string;
  begin
    result := StrFilter(s, '0123456789');
  end;

  function fmKonto(s: string): string;
  begin
    result := int64tostr(strtoint64(s));
  end;

  function fmBetrag(s: string): string;
  begin
    result := inttostr(round(strtodouble(s) * 100.0));
  end;

  procedure Load(sDTA: TStringList; FName: string);
  var
    n: Integer;
    sLine: TStringList;
  begin
    sDTA.LoadFromFile(FName);
    if (pos('RID;', sDTA[0]) = 1) then
    begin
      for n := 1 to pred(sDTA.count) do
      begin
        sLine := split(sDTA[n], ';');
        if (sLine.count > 3) then
          sDTA[n] :=
          { BLZ } fmBLZ(sLine[3]) + ';' +
          { Konto } fmKonto(sLine[4]) + ';' +
          { Betrag } fmBetrag(sLine[5]) + ';' + '"' + sLine[1] + '"';
        sLine.free;
      end;
    end
    else
    begin
      for n := 1 to pred(sDTA.count) do
      begin
        sLine := split(sDTA[n], ',');
        if (sLine.count > 3) then
          sDTA[n] :=
          { BLZ } fmBLZ(sLine[2]) + ';' +
          { Konto } fmKonto(sLine[3]) + ';' +
          { Betrag } fmBetrag(sLine[4]) + ';' + '"' + sLine[0] + '"';
        sLine.free;
      end;
    end;
    sDTA[0] := 'BLZ;Konto;Betrag;Name';
  end;

  function find(s: string; sDTA: TStringList): Integer;
  var
    n: Integer;
  begin
    result := -1;
    s := nextp(s, ';', 0) + ';' + nextp(s, ';', 1) + ';' + nextp(s, ';', 2) + ';';
    for n := 1 to pred(sDTA.count) do
      if (pos(s, sDTA[n]) = 1) then
      begin
        result := n;
        break;
      end;
  end;

var
  sDTAalt: TStringList;
  sDTAneu: TStringList;
  sBericht: TStringList;
  n, k: Integer;

begin
  sBericht := TStringList.Create;
  sDTAalt := TStringList.Create;
  Load(sDTAalt, MyProgramPath + cHBCIPath + Edit4.Text);
  sDTAalt.savetofile(DiagnosePath + 'DTA-0.txt');
  sDTAneu := TStringList.Create;
  Load(sDTAneu, MyProgramPath + cHBCIPath + Edit5.Text);
  sDTAneu.savetofile(DiagnosePath + 'DTA-1.txt');

  sBericht.add('');
  sBericht.add('## Neuzug‰nge ##');
  for n := 0 to pred(sDTAneu.count) do
  begin
    k := find(sDTAneu[n], sDTAalt);
    if (k <> -1) then
    begin
      sDTAalt.Delete(k);
    end
    else
    begin
      sBericht.add(sDTAneu[n]);
    end;
  end;
  sBericht.add('');
  sBericht.add('## Lˆschungen ##');
  sBericht.addstrings(sDTAalt);
  sBericht.savetofile(DiagnosePath + 'DTA-3.txt');
  sDTAalt.free;
  sDTAneu.free;
  sBericht.free;
  openShell(DiagnosePath + 'DTA-3.txt');
end;

procedure TFormBuchhalter.Button13Click(Sender: TObject);
var
  Bericht: TStringList;
begin
  Bericht := e_w_KontoInfo(rPERSON_R);
  Bericht.free;
  openShell(e_r_MahnungFName(rPERSON_R));
end;

procedure TFormBuchhalter.Button14Click(Sender: TObject);
var
  BUCH_R: Integer;
  Betrag: double;
  sDiagnose: TStringList;
begin
  sDiagnose := TStringList.Create;
  Button14.enabled := false;

  // Bezahlen, so wie steht!
  BUCH_R := rBUCH_R;
  if (BUCH_R >= cRID_FirstValid) and (sAusgleich.count > 0) then
  begin
    BeginHourGlass;

    // Bezahlen wie es steht!
    b_w_ForderungAusgleich(sAusgleich);

    // Noch eventuelle Folgebuchungen
    b_w_LastschriftAusgleich(sAusgleich);

    // Neuen Saldo auffrischen
    Betrag := e_r_sqld('select BETRAG from BUCH where RID=' + inttostr(BUCH_R));
    Draw_NeueEingaengeSaldo(NeueEingaengeSaldo - Betrag);

    // aus der Liste entfernen
    hideForderung(BUCH_R);

    // Fixierung aufheben
    if assigned(sForderungenFixed) then
      sForderungenFixed.clear;
    RefreshForderungen;

    EndHourGlass;
  end;
  Button14.enabled := true;
  FormCareServer.ShowIfError(sDiagnose);
  sDiagnose.free;
end;

procedure TFormBuchhalter.Button15Click(Sender: TObject);
begin
  FormPerson.setContext(rPERSON_R);
end;

procedure TFormBuchhalter.Button16Click(Sender: TObject);
begin
  FormBelege.setContext(rPERSON_R);
end;

procedure TFormBuchhalter.Button17Click(Sender: TObject);
begin
  FormAusgangsrechnungen.setContext(rPERSON_R);
end;

procedure TFormBuchhalter.Button18Click(Sender: TObject);
var
  PERSON_R: Integer;
  qPERSON: TIB_Query;
  KontoInhaber: string;
begin
  BeginHourGlass;
  // Mit den aktuellen Daten eine Neuanlage wagen!
  // Problem, da dann noch nicht im SuchIndex
  PERSON_R := e_w_PersonNeu;
  qPERSON := DataModuleDatenbank.nQuery;
  with qPERSON do
  begin
    sql.add('select * from PERSON where RID=' + inttostr(PERSON_R) + ' for update');
    open;
    edit;
    KontoInhaber := b_r_Auszug_Inhaber(sBuchungsText);
    if (pos(',', KontoInhaber) = 0) then
    begin
      FieldByName('VORNAME').AsString := nextp(KontoInhaber, ' ', 0);
      FieldByName('NACHNAME').AsString := copy(KontoInhaber, pos(' ', KontoInhaber) + 1, MaxInt);
    end
    else
    begin
      FieldByName('VORNAME').AsString := nextp(KontoInhaber, ',', 0);;
      FieldByName('NACHNAME').AsString := copy(KontoInhaber, pos(',', KontoInhaber) + 1, MaxInt);
    end;
    post;
  end;
  qPERSON.free;

  // Zuordnen als Privat Person
  setIdentitaetRosa(PERSON_R);

  // Index neu erstellen!
  PersonSuchindex;

  // Debi-Hilfe neu aufbauen
  RefreshDebis;

  EndHourGlass;
end;

procedure TFormBuchhalter.Button19Click(Sender: TObject);
begin
  // Person suchen!
  FormPersonSuche.setContext(b_r_Auszug_Inhaber(sBuchungsText));
end;

procedure TFormBuchhalter.Button1Click(Sender: TObject);
var
  _UeberweisungsSettings: TStringList;

  function e_r_Ueberweisungstext: TStringList;
  var
    TierTexte: TStringList;
    UeberweisungsTextAusForderung: TStringList;
    UeberweisungsTextAusZahlungstyp: TStringList;
    UeberweisungsSettings: TStringList;
    LastschriftTexte: TStringList;
    i: Integer;
    Forderung: double;
    sVerwendungsZweck: string;
  begin
    result := TStringList.Create;
    UeberweisungsTextAusForderung := TStringList.Create;
    UeberweisungsTextAusZahlungstyp := TStringList.Create;
    UeberweisungsSettings := TStringList.Create;
    with IB_Query1 do
    begin

      // Prio 1: ‹0 aus Einstellungen
      if FieldByName('EINSTELLUNGEN').IsNotNull then
        FieldByName('EINSTELLUNGEN').AssignTo(UeberweisungsSettings)
      else
      begin
        UeberweisungsSettings.clear;
        UeberweisungsSettings.addstrings(_UeberweisungsSettings);
      end;
      result.add(UeberweisungsSettings.values['‹0']);
      result.add(UeberweisungsSettings.values['‹00']);
      result.add(UeberweisungsSettings.values['‹000']);

      // Prio 2: ‹1 aus Forderung oder Belegkopftext oder automatisch
      FieldByName('TEXT').AssignTo(UeberweisungsTextAusForderung);
      repeat

        if (UeberweisungsTextAusForderung.IndexOfName('‹1') <> -1) then
        begin
          result.add(UeberweisungsTextAusForderung.values['‹1']);
          break;
        end;

        if (UeberweisungsSettings.IndexOfName('‹1') <> -1) then
        begin
          result.add(UeberweisungsSettings.values['‹1']);
          break;
        end;

        Forderung := cSkonto(FieldByName('SKONTO').AsDouble, FieldByName('BETRAG').AsDouble);

        if isHaben(Forderung) then
        begin
          result.add('Rechnung ' + FieldByName('RECHNUNG').AsString + ' vom ' +
            long2date8(datetime2long(FieldByName('RECHNUNGS_DATUM').AsDate)))
        end
        else
        begin
          result.add('Gutschrift ' + FieldByName('RECHNUNG').AsString + ' ¸ber');
          sVerwendungsZweck := format('%m vom %s', [
            { } Forderung,
            { } long2date8(datetime2long(FieldByName('RECHNUNGS_DATUM').AsDate))]);
          ersetze('Ä', 'EUR', sVerwendungsZweck);
          result.add(sVerwendungsZweck);

        end;

      until true;

      // Prio 3: ‹2 aus der Forderung
      // Prio 4: ‹2 aus den Einstellungen
      // Prio 5: ‹3 aus der Forderung
      // Prio 6: ‹3 aus den Einstellungen
      // Prio 7: ‹4 aus der Forderung
      // Prio 8: ‹4 aus den Einstellungen
      for i := 2 to 4 do
      begin
        result.add(UeberweisungsTextAusForderung.values['‹' + inttostr(i)]);
        result.add(UeberweisungsSettings.values['‹' + inttostr(i)]);
      end;

      // Prio 9: sind Tiernamen gew¸nscht?
      if (UeberweisungsSettings.values['BehandelteTiere'] = cIni_Activate) then
      begin
        TierTexte := e_r_sqlsl(
          { } 'select ARTIKEL from POSTEN ' +
          { } 'where' +
          { } ' (BELEG_R=' + FieldByName('BELEG_R').AsString + ') and' +
          { } ' (TIER_R is not null) ' +
          { } 'order by' +
          { } ' POSNO,RID');

        result.addstrings(TierTexte);
        TierTexte.free;
      end;

      // Prio 10: Postenzeilen mit der passenden Ausgabeart
      if (iAusgabeartLastschriftText >= cRID_FirstValid) then
      begin
        LastschriftTexte := e_r_sqlsl(
          { } 'select ARTIKEL from POSTEN ' +
          { } 'where' +
          { } ' (BELEG_R=' + FieldByName('BELEG_R').AsString + ') and' +
          { } ' (AUSGABEART_R=' + inttostr(iAusgabeartLastschriftText) + ') ' +
          { } 'order by' +
          { } ' POSNO,RID');

        result.addstrings(LastschriftTexte);
        LastschriftTexte.free;
      end;

    end;

    // Aufr‰umen & Komprimieren
    for i := pred(result.count) downto 0 do
    begin
      // Leer
      if (result[i] = '') then
      begin
        result.Delete(i);
        continue;
      end;

      // Zu lang, Buzzwords verkleinern
      if (length(result[i]) > 27) then
      begin
        sVerwendungsZweck := result[i];
        ersetze('Strasse', 'Str.', sVerwendungsZweck);
        ersetze('strasse', 'str.', sVerwendungsZweck);
        ersetze('Straﬂe', 'Str.', sVerwendungsZweck);
        ersetze('straﬂe', 'str.', sVerwendungsZweck);
        result[i] := sVerwendungsZweck;
      end;

    end;

    UeberweisungsTextAusForderung.free;
    UeberweisungsTextAusZahlungstyp.free;
    UeberweisungsSettings.free;

  end;

var
  Verwendungszweck: TStringList;
  VerwendungszweckGutschrift: TStringList;
  Gutschriften: TStringList;
  Gutschriften_RID: TgpIntegerList;
  dGutschriften: array of double;
  GutschriftKey: string;
  i, n: Integer;
  DTAlog: TStringList;
  SollCount: Integer;
  Forderung, Mandat: double;
  BLZ: string[8];
  ktonr: string[10];
  MANDAT_ID : string;

  // Limitierung
  Limit_Anzahl: Integer;
  Limit_Wert: double;
  Limit_Erreicht: boolean;

  // Aufsummierung des Volumens
  Summe_Anzahl: Integer;
  Summe_Wert: double;
  Summe_Mandat: double;

  // Ausgabevolumen
  tDTAUS: TsTable;
  RIDs_Used: TgpIntegerList;

begin
  BeginHourGlass;
  Memo1.lines.clear;
  Gutschriften := TStringList.Create;
  Gutschriften_RID := TgpIntegerList.Create;
  tDTAUS := TsTable.Create;
  tDTAUS.oNoAutoQuote := true;

  RIDs_Used := TgpIntegerList.Create;

  // defaults aus den Zahlungsarten
  _UeberweisungsSettings := e_r_sqlt(
    { } 'select EINSTELLUNGEN from ZAHLUNGTYP ' +
    { } 'where' +
    { } ' (AUTOZAHLUNG=''' + cC_True + ''') ' +
    { } 'order by ' +
    { } ' BEZEICHNUNG');

  // Die aktuelle Abfrage ausgeben
  ExportTable(IB_Query1.sql, DiagnosePath + 'DTAUS.csv');
  tDTAUS.insertFromFile(DiagnosePath + 'DTAUS.csv');

  repeat

    if (pos('Ä', Edit15.Text) > 0) then
    begin
      Limit_Wert := StrToDoubledef(Edit15.Text, cGeld_Max);
      Limit_Anzahl := MaxInt;
      break;
    end;

    if (Edit15.Text <> '') then
    begin
      Limit_Anzahl := StrToIntDef(Edit15.Text, MaxInt);
      Limit_Wert := cGeld_Max;
      break;
    end;

    Limit_Anzahl := MaxInt;
    Limit_Wert := cGeld_Max;

  until true;

  // Nachsehen, wo Gutschriften sind
  with IB_Query1 do
  begin
    first;
    while not(eof) do
    begin
      Forderung := cSkonto(
        { } FieldByName('SKONTO').AsDouble,
        { } FieldByName('BETRAG').AsDouble);
      if isSoll(Forderung) then
      begin
        Gutschriften_RID.add(FieldByName('RID').AsInteger);
        Verwendungszweck := e_r_Ueberweisungstext;
        BLZ := b_r_Person_ELV_BLZ(FieldByName('Z_ELV_BLZ').AsString, FieldByName('Z_ELV_KONTO').AsString);
        ktonr := b_r_Person_ELV_Konto(FieldByName('Z_ELV_BLZ').AsString, FieldByName('Z_ELV_KONTO').AsString);
        Gutschriften.AddObject(BLZ + '-' + ktonr, Verwendungszweck);
        SetLength(dGutschriften, Gutschriften.count);
        dGutschriften[pred(Gutschriften.count)] := Forderung;
      end;

      next;
    end;
  end;

  DTA.cDTA_HTML_Vorlagen_Path := HtmlVorlagenPath;
  with DTA_Header do
  begin
    RID := succ(e_r_gen('EREIGNIS_GID'));
    FName := DiagnosePath + 'DTAUS.DTA';
    BankName := iKontoBankName;
    BLZ := StrFilter(iKontoBLZ, cZiffern);
    ktonr := StrFilter(iKontoNummer, cZiffern);
    KontoInhaberName := iKontoInhaber;
    GlaeubigerID := iGlaeubigerID;
    KontoInhaberOrt := '';
    Lastschrift := true;
    AusfuehrungsDatum := datePlusWorking(DateGet, iKontoSEPAFrist);
  end;

  SollCount := 0;
  Summe_Anzahl := 0;
  Summe_Wert := 0.0;
  Summe_Mandat := 0.0;
  Limit_Erreicht := false;

  DtaOpen(DTA_Header);
  with IB_Query1 do
  begin
    first;
    while not(eof) do
    begin
      Forderung := cSkonto(FieldByName('SKONTO').AsDouble, FieldByName('BETRAG').AsDouble);

      Mandat := e_r_sqld(
        { } 'select BETRAG ' +
        { } 'from BUCH where ' +
        { } ' (NAME=' + SQLString(cKonto_Mandat) + ') and' +
        { } ' (BELEG_R=' + FieldByName('BELEG_R').AsString + ') and' +
        { } ' (TEILLIEFERUNG=' + FieldByName('TEILLIEFERUNG').AsString + ')', cPreis_ungesetzt);

      if isequal(Mandat, cPreis_ungesetzt) then
      begin
        MANDAT_ID := 'P' + FieldByName('PERSON_R').AsString;

        Memo1.lines.add(
          { } cINFOText +
          { } ' Zum Beleg ' +
          { } FieldByName('BELEG_R').AsString + '-' +
          { } FieldByName('TEILLIEFERUNG').AsString + ' ' +
          { } 'gibt es kein explizites Mandat');
      end
      else
      begin
        MANDAT_ID := 'M' + e_r_sqls(
        { } 'select RID ' +
        { } 'from BUCH where ' +
        { } ' (NAME=' + SQLString(cKonto_Mandat) + ') and' +
        { } ' (BELEG_R=' + FieldByName('BELEG_R').AsString + ') and' +
        { } ' (TEILLIEFERUNG=' + FieldByName('TEILLIEFERUNG').AsString + ')');

        if isother(Forderung, Mandat) then
          Memo1.lines.add(
            { } cWARNINGText +
            { } ' Beim Beleg ' +
            { } FieldByName('BELEG_R').AsString + '-' +
            { } FieldByName('TEILLIEFERUNG').AsString + ' ' +
            { } 'bel‰uft sich das Mandat auf ' + MoneyToStr(Mandat) + ' ' +
            { } 'aber die Forderung ist ' + MoneyToStr(Forderung));
      end;

      if isHaben(Forderung) then
      begin

        with DTA_Posten do
        begin
          RID := FieldByName('RID').AsInteger;
          BLZ := b_r_Person_ELV_BLZ(FieldByName('Z_ELV_BLZ').AsString, FieldByName('Z_ELV_KONTO').AsString);
          ktonr := b_r_Person_ELV_Konto(FieldByName('Z_ELV_BLZ').AsString, FieldByName('Z_ELV_KONTO').AsString);

          zahlerName := cutblank(FieldByName('Z_ELV_KONTO_INHABER').AsString);
          if (zahlerName = '') then
            zahlerName := cutblank(FieldByName('VORNAME').AsString + ' ' + FieldByName('NACHNAME').AsString);
          if (zahlerName = '') then
            zahlerName := FieldByName('NAME1').AsString;
          zahlerOrt := '';

          // nun alle Verwendungszwecke eintragen
          // tats‰chliche Forderung berechnen, suche passende Gutschriften
          Verwendungszweck := e_r_Ueberweisungstext;
          GutschriftKey := BLZ + '-' + ktonr;
          for n := pred(Gutschriften.count) downto 0 do
            if (Gutschriften[n] = GutschriftKey) then
              if isHaben(Forderung + dGutschriften[n]) then
              begin
                VerwendungszweckGutschrift := TStringList(Gutschriften.Objects[n]);
                Forderung := Forderung + dGutschriften[n];
                for i := 0 to pred(VerwendungszweckGutschrift.count) do
                  if (Verwendungszweck.IndexOf(VerwendungszweckGutschrift[i]) = -1) then
                    Verwendungszweck.add(VerwendungszweckGutschrift[i]);
                RIDs_Used.add(Gutschriften_RID[n]);
                Gutschriften_RID.Delete(n);
                // Imp pend: memory leak wegen TObject?!
                Gutschriften.Delete(n);
              end;

          Betrag := Forderung;
          n := 0;
          for i := 0 to pred(Verwendungszweck.count) do
          begin
            inc(n);
            VZweck[n] := Verwendungszweck[i];
            if (n = 7) then
              break;
          end;
          for i := n + 1 to 7 do
            VZweck[i] := '';
          Verwendungszweck.free;

          // Datums bisher noch automatisch
          MandatsDatum := cDTA_DatumAutomatisch;
          MandatsID := MANDAT_ID;
          AusfuehrungsDatum := cDTA_DatumAutomatisch;

        end;

        inc(Summe_Anzahl);
        Summe_Wert := Summe_Wert + DTA_Posten.Betrag;

        if (Summe_Anzahl <= Limit_Anzahl) and (Summe_Wert <= Limit_Wert) then
        begin
          RIDs_Used.add(FieldByName('RID').AsInteger);
          DtaPut(DTA_Posten);
          inc(SollCount);
        end
        else
        begin
          Limit_Erreicht := true;
        end;

      end;
      next;
    end;
  end;

  DTAlog := DtaClose;

  Label35.Caption := DTAlog.values['ANZAHL'] + ' Buchung(en)';
  Label36.Caption := DTAlog.values['BETRAG'];

  // Jetzt die unbenutzen RIDs alle raus aus der Gesamt-Tabelle
  with tDTAUS do
  begin
    for n := RowCount downto 1 do
      if RIDs_Used.IndexOf(StrToIntDef(readCell(n, 'RID'), 0)) = -1 then
        tDTAUS.Del(n);
    if Changed then
      savetofile(DiagnosePath + 'DTAUS.csv');
  end;

  EndHourGlass;
  repeat

    if (SollCount <> StrToIntDef(DTAlog.values['ANZAHL'], -1)) then
    begin
      // Fehler
      DTAlog.savetofile(DiagnosePath + 'DTAUS'+cLogExtension);
      if doit('Es gab Fehler! Wollen Sie jetzt eine Diagnose einsehen') then
        openShell(DiagnosePath + 'DTAUS'+cLogExtension);
      break;
    end;

    if (Gutschriften.count > 0) then
    begin
      ShowMessage('Gutschriften konnten nicht angewendet werden!' + #13 + HugeSingleLine(Gutschriften));
      break;
    end;

    if Limit_Erreicht then
      ShowMessageTimeOut('Ihr Limit war wirksam!');

    // Erfolg
    CheckCreateOnce(MyProgramPath + cHBCIPath);
    FileCopy(DiagnosePath + 'DTAUS.*', MyProgramPath + cHBCIPath);
    FileDelete(DiagnosePath + 'DTAUS'+cLogExtension);

  until true;
  _UeberweisungsSettings.free;

  // imp pend: memory leak wegen TObject?
  Gutschriften.free;
  Gutschriften_RID.free;
  tDTAUS.free;
  RIDs_Used.free;

end;

procedure TFormBuchhalter.TabSheet1Show(Sender: TObject);
var
  sDir: TStringList;
begin
  BeginHourGlass;
  if not(IB_Query1.Active) then
    IB_Query1.open
  else
    RefreshLastschriften;

  if (Edit4.Text = '') then
  begin
    sDir := TStringList.Create;
    dir(MyProgramPath + cHBCIPath + 'DTAUS-' + Fill('?', 8) + '.CSV', sDir);
    if (sDir.count > 0) then
    begin
      sDir.sort;
      Edit4.Text := sDir[pred(sDir.count)];
    end;
  end;
  EndHourGlass;
end;

procedure TFormBuchhalter.TabSheet3Show(Sender: TObject);
var
  sl: TStringList;
begin
  sl := b_r_HBCIKonten;
  Label23.Caption := HugeSingleLine(sl, ' / ');
  sl.free;
end;

procedure TFormBuchhalter.SpeedButton10Click(Sender: TObject);
begin
  if (DrawGrid1.Row >= 0) and (DrawGrid1.Row < ItemKontoAuszugRIDs.count) then
    FormBuchung.setContext(Integer(ItemKontoAuszugRIDs[DrawGrid1.Row]))
  else
    FormBuchung.setContext;
end;

procedure TFormBuchhalter.SpeedButton11Click(Sender: TObject);
begin
  RefreshLastschriften;
end;

procedure TFormBuchhalter.SpeedButton12Click(Sender: TObject);
begin
  RefreshNeueEingaenge;
end;

procedure TFormBuchhalter.SpeedButton13Click(Sender: TObject);
begin
  RefreshAusgleichCombos;
end;

procedure TFormBuchhalter.SpeedButton19Click(Sender: TObject);
begin
  if (DrawGrid2.Row >= 0) and (DrawGrid2.Row < ItemKontoAuszugRIDs.count) then
    FormBuchung.setContext(Integer(ItemKontoAuszugRIDs[DrawGrid2.Row]))
  else
    FormBuchung.setContext;
end;

procedure TFormBuchhalter.SpeedButton1Click(Sender: TObject);
begin
  openShell(MyProgramPath + cHBCIPath);
end;

procedure TFormBuchhalter.SpeedButton20Click(Sender: TObject);
begin
  // Debi-Suche-Update
  Disable_AusgleichCache;
  RefreshDebis;
end;

procedure TFormBuchhalter.SpeedButton21Click(Sender: TObject);
begin
  // Debitor als Privatier markieren!
  setIdentitaetRosa(rPERSON_R);
end;

procedure TFormBuchhalter.nextRow(dg : TDrawGrid);
begin
  with dg do
    SecureSetRow(dg, min(pred(RowCount), Succ(Row)));
end;

procedure TFormBuchhalter.SpeedButton22Click(Sender: TObject);

  procedure setRow(n: Integer);
  begin
    SecureSetRow(DrawGrid2, n);
  end;


var
  saldo: double;
  goNext: boolean;
  AnzVerbuchungen: Integer;
begin
  if (DrawGrid2.RowCount > 0) then
  begin

    BeginHourGlass;
    SpeedButton22.enabled := false;
    AnzVerbuchungen := 0;
    setRow(0);

    repeat

      goNext := false;

      if (DrawGrid2.RowCount = 0) then
        break;

      repeat

        if (isGreen) then
        begin

          if (sAusgleich.count = 0) then
          begin
            goNext := true;
            break;
          end;

          if (rERRORs > 0) then
          begin
            goNext := true;
            break;
          end;

          isGreen := false;
          application.processmessages;
          Button14Click(self);
          inc(AnzVerbuchungen);
          break;

        end;

        if (isRose) then
        begin

          saldo := b_r_PersonSaldo(rPERSON_R);
          if (saldo <> 0) then
          begin
            goNext := true;
            break;
          end;

          isRose := false;
          application.processmessages;
          SpeedButton26Click(self);
          inc(AnzVerbuchungen);
          break;
        end;

        goNext := true;
      until true;

      if goNext then
      begin
        if (DrawGrid2.Row = pred(DrawGrid2.RowCount)) then
          break;
        SecureSetRow(DrawGrid2, min(pred(DrawGrid2.RowCount), Succ(DrawGrid2.Row)));
      end;
      application.processmessages;

    until false;
    SpeedButton22.enabled := true;
    EndHourGlass;
    if (AnzVerbuchungen = 0) then
      ShowMessage('Keine Datens‰tze zum automatischen Forderungsausgleich gefunden!')
    else
      ShowMessage(inttostr(AnzVerbuchungen) + ' Forderungen ausgeglichen!');
  end;

end;

procedure TFormBuchhalter.SpeedButton23Click(Sender: TObject);
begin
  RefreshForderungen;
end;

procedure TFormBuchhalter.SpeedButton24Click(Sender: TObject);
begin
  setIdentitaetGruen(rPERSON_R);
end;

procedure TFormBuchhalter.SpeedButton25Click(Sender: TObject);
begin
  //
  ShowMessage('Noch nicht automatisiert!' + #13 + 'Siehe Hilfe f¸r den manuellen Weg!');
end;

procedure TFormBuchhalter.SpeedButton26Click(Sender: TObject);
begin
  SpeedButton26.enabled := false;
  bucheAufKonto(cKonto_DurchlaufenderPosten);
  SpeedButton26.enabled := true;
end;

procedure TFormBuchhalter.SpeedButton27Click(Sender: TObject);
begin
  RefreshKontoSearch;
  if (Edit1.Text <> '') then
    doSuche;
end;

procedure TFormBuchhalter.SpeedButton28Click(Sender: TObject);
var
  BUCH_R: Integer;
begin
  BeginHourGlass;
  BUCH_R := IB_Query1.FieldByName('RID').AsInteger;
  e_x_sql('update AUSGANGSRECHNUNG set DATUM=CURRENT_TIMESTAMP + 1.0 where RID=' + inttostr(BUCH_R));
  RefreshLastschriften;
  EndHourGlass;
end;

procedure TFormBuchhalter.SpeedButton29Click(Sender: TObject);
begin
  openShell(DiagnosePath + 'DTAUS.DTA.ini');
end;

procedure TFormBuchhalter.SpeedButton2Click(Sender: TObject);
var
  sNeu: TgpIntegerList;
begin
  // Die neuen Anzeigen!
  if (_NewPoint >= cRID_FirstValid) then
  begin
    BeginHourGlass;
    sNeu := e_r_sqlm(
      { } 'select RID from BUCH ' +
      { } 'where ' +
      { } ' (RID>' + inttostr(_NewPoint) + ') and ' +
      { } ' (RID=MASTER_R) ' +
      { } 'order by DATUM,POSNO');

    // RID-Liste aus OLAP-Laden!
    if (sNeu.count > 0) then
    begin
      ItemKontoAuszugRIDs.clear;
      ItemKontoAuszugRIDs.append(sNeu);
      DrawGrid1.RowCount := ItemKontoAuszugRIDs.count;
      DrawGrid1.Refresh;
      SecureSetRow(DrawGrid1, pred(ItemKontoAuszugRIDs.count));
    end
    else
    begin
      beep;
    end;
    RefreshKontoAuszugSaldo(0);

    sNeu.free;
    EndHourGlass;
  end
  else
  begin
    beep;
    setNewPoint(e_r_sql('select MAX(RID) from BUCH') - 10);
  end;
end;

procedure TFormBuchhalter.SpeedButton30Click(Sender: TObject);
var
  Content: TList;
  xlsOptions: TStringList;
begin
  if FileExists(DiagnosePath + 'DTAUS.DTA.CSV') then
  begin
    // aktuelle DTA Liste ˆffnen
    xlsOptions := TStringList.Create;
    xlsOptions.add('Betrag=MONEY');
    xlsOptions.add('VZ1=TEXT');
    xlsOptions.add('VZ2=TEXT');
    xlsOptions.add('VZ3=TEXT');
    xlsOptions.add('VZ4=TEXT');
    xlsOptions.add('VZ5=TEXT');
    xlsOptions.add('VZ6=TEXT');
    xlsOptions.add('VZ7=TEXT');
    Content := TList.Create;
    CSVImport(DiagnosePath + 'DTAUS.DTA.CSV', Content);
    ExcelExport(DiagnosePath + 'DTAUS.DTA.XLS', Content, nil, xlsOptions);
    Content.free;
    xlsOptions.free;

    // aktuelle DTA Liste ˆffnen
    openShell(DiagnosePath + 'DTAUS.DTA.XLS');
  end;
end;

procedure TFormBuchhalter.SpeedButton31Click(Sender: TObject);
var
  BUCH_R: Integer;
begin
  if (DrawGrid1.Row <> -1) then
  begin
    if doit('Bitte beim Lˆschen beachten:' + #13 +
      'Handelt es sich um einen initialen Buchungssatz, so verschwinden auch alle Folges‰tze!' + #13 +
      'Beim Lˆschen eines Folge-Buchungssatzes, wird auch der initiale Buchungssatz gelˆscht!' + #13 +
      'Bei einem via HBCI synchronisierten Konto kann durch den Kontenabgleich die Buchung wiederum entstehen!' + #13 +
      #13 + 'Buchung wirklich lˆschen') then
    begin
      // Referenz aus Liste
      BUCH_R := ItemKontoAuszugRIDs[DrawGrid1.Row];
      // Den initialen Buchungssatz holen
      BUCH_R := e_r_InitialerBuchungssatz(BUCH_R);
      // Folge Buchungss‰tze lˆschen
      b_w_preDeleteBuch(BUCH_R);
      // Den eigentlichen Buchungssatz lˆschen
      e_x_sql('delete from BUCH where RID=' + inttostr(BUCH_R));
      RefreshKontoAuszug;
    end;
  end;

end;

procedure TFormBuchhalter.SpeedButton32Click(Sender: TObject);
begin
  ShowMessage(
    { } cBuch_HeaderLineFOrderungen + #13 + HugeSingleLine(sForderungen) +
    { } #13 + #13 +
    { } cBuch_HeaderLineAusgleich + #13 + HugeSingleLine(sAusgleich));
end;

procedure TFormBuchhalter.SpeedButton33Click(Sender: TObject);
begin
  Erzeuge_sForderungen(rPERSON_R);
  Erzeuge_Show_sYellow(sBetrag, false);
end;

procedure TFormBuchhalter.SpeedButton34Click(Sender: TObject);
var
  sOLAPFName: TStringList;
  n: Integer;
begin
  // RID-Liste aus OLAP-Laden!
  BeginHourGlass;
  sOLAPFName := TStringList.Create;
  ItemKontoAuszugRIDs.clear;
  sOLAPFName.LoadFromFile(RohdatenFName(0));
  for n := 1 to pred(sOLAPFName.count) do
    ItemKontoAuszugRIDs.add(StrToIntDef(sOLAPFName[n], cRID_Null));
  DrawGrid1.RowCount := ItemKontoAuszugRIDs.count;
  RefreshKontoAuszugSaldo(0);
  if (ItemKontoAuszugRIDs.count > 0) then
    SecureSetRow(DrawGrid1, pred(ItemKontoAuszugRIDs.count));
  sOLAPFName.free;
  EndHourGlass;
end;

procedure TFormBuchhalter.SpeedButton35Click(Sender: TObject);
begin
  Memo2.lines.savetofile(SystemPath + '\Konten-Alias.ini');
end;

procedure TFormBuchhalter.SpeedButton36Click(Sender: TObject);
var
  Buchungen: TgpIntegerList;
  i: Integer;
begin
  if doit(
    { } 'Konto ' + ComboBox3.Text +
    { } ' mit allen Buchungen und allen Folgedatens‰tze wirklich lˆschen') then
  begin
    //
    BeginHourGlass;
    Buchungen := e_r_sqlm(
      { } 'select RID from BUCH where ' +
      { } '(NAME=''' + ComboBox3.Text + ''') and ' +
      { } '(RID=MASTER_R) and ' +
      { } '(BETRAG is not null)');
    for i := 0 to pred(Buchungen.count) do
      b_w_DeleteBuch(Buchungen[i]);
    Buchungen.free;
    EndHourGlass;
  end;

end;

procedure TFormBuchhalter.SpeedButton37Click(Sender: TObject);
begin
  IB_Query2.Refresh;
end;

procedure TFormBuchhalter.SpeedButton38Click(Sender: TObject);
begin
  inc(sAusgleich_FirstButtonOffset);
  Erzeuge_Show_sYellow(sBetrag, false);
end;

procedure TFormBuchhalter.SpeedButton39Click(Sender: TObject);
begin
  if (sAusgleich_FirstButtonOffset > 0) then
  begin
    dec(sAusgleich_FirstButtonOffset);
    Erzeuge_Show_sYellow(sBetrag, false);
  end;
end;

procedure TFormBuchhalter.SpeedButton3Click(Sender: TObject);
begin
  RefreshKontoAuszug;
end;

procedure TFormBuchhalter.Button20Click(Sender: TObject);
var
  BUCH_R: Integer;
  NAME: string;
begin
  BeginHourGlass;
  BUCH_R := ItemKontoAuszugRIDs[DrawGrid1.Row];
  NAME := e_r_sqls('select NAME from BUCH where RID=' + inttostr(BUCH_R));
  if (NAME <> '') then
    if (ComboBox1.Text <> NAME) then
    begin
      ComboBox1.Text := NAME;
      ComboBox1Select(Sender);
    end;

  ItemKontoAuszugRIDs.Assign(ItemKontoAuszugAll);
  with DrawGrid1 do
  begin
    RowCount := ItemKontoAuszugRIDs.count;
    RefreshKontoAuszugSaldo(0);
  end;
  SecureSetRow(DrawGrid1, ItemKontoAuszugRIDs.IndexOf(BUCH_R));
  EndHourGlass;
end;

procedure TFormBuchhalter.Button21Click(Sender: TObject);
begin
  mehrDebis := true;
  RefreshDebis;
end;

procedure TFormBuchhalter.Button22Click(Sender: TObject);
begin
  if BelegMode then
  begin
    Button22.Caption := 'ù';
    BelegMode := false;
  end;

  if (sForderungen.count > 0) then
  begin
    if (sForderungen.count = 1) then
    begin
      showBeleg(0)
    end
    else
    begin
      BelegMode := true;
      Button22.Caption := 's';
      ShowMEssageTimeOut('Es gibt mehrere Belege, klicken Sie auf die Tabelle um einen auszuw‰hlen!');
    end;
  end;
end;

procedure TFormBuchhalter.Button23Click(Sender: TObject);
var
  sKontenAlias: TStringList;

  function KontoAsAlias(Konto: string): string;
  begin
    result := sKontenAlias.values[Konto];
    if (result = '') then
      result := Konto;
  end;

const
  cFormatMwSt = '%.1f%%';
  cFormatMoney = '%.2f';
  cHeaderLine =
  { 00 } 'BuchungsZusammenhang;' +
  { 01 } 'Datum;' +
  { 02 } 'Uhrzeit;' +
  { 03 } 'Valuta;' +
  { 04 } 'BetragSumme;' +
  { 05 } 'BetragNetto;' +
  { 06 } 'BetragSteuer;' +
  { 07 } 'VonKonto;' +
  { 08 } 'AufKonto;' +
  { 09 } 'Schl¸ssel;' +
  { 10 } 'RechnungsNummer;' +
  { 11 } 'Satz;' +
  { 12 } 'Zeile1;' +
  { 13 } 'Zeile2;' +
  { 14 } 'Zeile3;' +
  { 15 } 'Zeile4;' +
  { 16 } 'Zeile5;' +
  { 17 } 'Zeile6;' +
  { 18 } 'Zeile2bis6;' +
  { 19 } 'Zeilen';
  sSQL_Alle =
  { } ' select' +
  { } '  VERSAND.RECHNUNG,' +
  { } '  VERSAND.LIEFERBETRAG,' +
  { } '  (select' +
  { } '    SUM(-B.BETRAG)' +
  { } '   from' +
  { } '    AUSGANGSRECHNUNG B' +
  { } '   where' +
  { } '    (VERSAND.BELEG_R=B.BELEG_R) and' +
  { } '    (VERSAND.TEILLIEFERUNG=B.TEILLIEFERUNG) and' +
  { } '    ((B.VORGANG<>''' + cVorgang_Rechnung + ''') or (B.VORGANG is null))' +
  { } '   ) as DAVON_BEZAHLT,' +
  { } '  VERSAND.BELEG_R,' +
  { } '  VERSAND.TEILLIEFERUNG,' +
  { } '  VERSAND.AUSGANG,' +
  { } '  BELEG.MAHNSTUFE,' +
  { } '  PERSON.RID as PERSON_R,' +
  { } '  PERSON.SUCHBEGRIFF' +
  { } ' from' +
  { } '  VERSAND' +
  { } ' join' +
  { } '  BELEG' +
  { } ' on' +
  { } '  (BELEG.RID=VERSAND.BELEG_R)' +
  { } ' join' +
  { } '  PERSON' +
  { } ' on' +
  { } '  (PERSON.RID=BELEG.PERSON_R)' +
  { } ' where' +
  { } '  (VERSAND.RECHNUNG is not null) and' +
  { } '  (VERSAND.AUSGANG>CURRENT_DATE-213) and' +
  { } '  (VERSAND.AUSGANG<CURRENT_DATE)' +
  { } ' order by' +
  { } '  VERSAND.AUSGANG descending ';

var
  Von, Bis: TAnfixDate;
  cBUCH: TdboCursor;
  cFOLGE: TdboCursor;
  cRECHNUNGEN: TdboCursor;
  sCSV: TStringList;
  STEMPEL: string;
  STEMPEL_R: Integer;
  sText: TStringList;
  sInitialerBuchungssatz: TStringList;
  sFolgeVorgaenger: TStringList;
  sFolgeBuchungssatz: TStringList;
  n: Integer;
  WarEbenErloesKonto: boolean;
  WorkPath, _WorkPath : string;
  RechnungFName, ZipFName : string;
  sPDF: TStringList;

  // caching
  MASTER_R: Integer;
  Konto: string;
  DATUM: TAnfixDate;

begin

  //
  Von := Date2Long(Edit2.Text);
  Bis := Date2Long(Edit6.Text);

  if DateOK(Von) and DateOK(Bis) then
  begin
    //

    _WorkPath := MyProgramPath + cAuswertungenPath;
    CheckCreateDir(_WorkPath);

    WorkPath := _WorkPath + IntToStr(Bis) + '\';
    CheckCreateDir(WorkPath);

    //
    cBUCH := DataModuleDatenbank.nCursor;
    cFOLGE := DataModuleDatenbank.nCursor;
    sCSV := TStringList.Create;
    sText := TStringList.Create;
    sKontenAlias := TStringList.Create;
    sKontenAlias.Assign(Memo2.lines);
    sCSV.add(cHeaderLine);
    WarEbenErloesKonto := false;

    with cFOLGE do
    begin
      //
      sql.add('select * from BUCH where (MASTER_R=:CROSSREF) and (RID<>MASTER_R)');
      sql.add('order by RID');
    end;

    with cBUCH do
    begin
      //
      sql.add('select * from BUCH where');
      sql.add(' (DATUM between ''' + long2date(Von) + ' 00:00:00'' and ''' + long2date(Bis) + ' 23:59:59'') and ');
      sql.add(' (MASTER_R=RID) and');
      sql.add(' (GEGENKONTO is not null)');
      sql.add('order by');
      sql.add(' DATUM,POSNO');

      // sql.add(' (GEGENKONTO is not in ('+HugeSingleLine()+')');
      open;
      ApiFirst;
      while not(eof) do
      begin

        // Zusammenhang
        MASTER_R := FieldByName('MASTER_R').AsInteger;
        DATUM := datetime2long(FieldByName('DATUM').AsDateTime);

        // Vorbereitungen f¸r Verwendungszweck
        FieldByName('TEXT').AssignTo(sText);
        ersetze(';', ',', sText);

        // Vorbereitungen f¸r "STEMPEL"
        STEMPEL_R := FieldByName('STEMPEL_R').AsInteger;
        STEMPEL := b_r_Stempel(STEMPEL_R);

        // Ausgabe vorbereiten
        sInitialerBuchungssatz := TStringList.Create;
        with sInitialerBuchungssatz do
        begin

          { 00 } add(FieldByName('MASTER_R').AsString);
          { 01 } add(long2date(DATUM));
          { 02 } add(secondstostr(FieldByName('DATUM').AsDateTime));
          { 03 } add(long2date(FieldByName('WERTSTELLUNG').AsDate));
          { 04 } add(format(cFormatMoney, [-FieldByName('BETRAG').AsDouble]));
          { 05 } add('');
          { 06 } add('');
          { 08 } add(KontoAsAlias(FieldByName('NAME').AsString));
          { 07 } add(KontoAsAlias(FieldByName('GEGENKONTO').AsString));
          { 09 } add('');
          { 10 } add(STEMPEL + FieldByName('STEMPEL_DOKUMENT').AsString);

          { 11 } add('');
          { 12,13,14,15,16,17 }
          for n := 0 to 5 do
            if (sText.count > n) then
              add(sText[n])
            else
              add('');
          { 18 } add('');
          { 19 } add(HugeSingleLine(sText, cLineSeparator));
          if (sText.count > 1) then
            sText.Delete(0);
          strings[18] := HugeSingleLine(sText, cLineSeparator);

        end;
        sCSV.add(HugeSingleLine(sInitialerBuchungssatz, ';'));

        // Nun alle zugehˆrigen Belege kopieren
        sPDF := b_r_PDF(FieldByName('MASTER_R').AsInteger);
        for n := 0 to pred(sPDF.count) do
         FileCopy(sPDF[n],WorkPath+ExtractFileName(sPDF[n]));
        sPDF.Free;

        // Nun die Folge-Buchungss‰tze
        sFolgeVorgaenger := TStringList.Create;
        with cFOLGE do
        begin
          ParamByName('CROSSREF').AsInteger := MASTER_R;
          open;
          ApiFirst;
          if not(eof) then
            sCSV.Delete(pred(sCSV.count));
          while not(eof) do
          begin

            // Ist es ein numerisches Konto?
            Konto := FieldByName('NAME').AsString;
            if (StrFilter(Konto, cZiffern) = Konto) then
              WarEbenErloesKonto := (pos('8', Konto) = 1);

            sFolgeBuchungssatz := TStringList.Create;
            sFolgeBuchungssatz.Assign(sInitialerBuchungssatz);

            sFolgeBuchungssatz[8] := KontoAsAlias(Konto);
            if WarEbenErloesKonto then
              sFolgeBuchungssatz[10] := e_r_RechnungsNummer(FieldByName('BELEG_R').AsInteger,
                FieldByName('TEILLIEFERUNG').AsInteger);

            if (pos('S', Konto) = 1) then
            begin

              sFolgeBuchungssatz[11] := format(cFormatMwSt, [e_r_Prozent(StrToInt(StrFilter(Konto, cZiffern)), DATUM)]);
              sFolgeBuchungssatz[6] := format(cFormatMoney, [-FieldByName('BETRAG').AsDouble]);

              sFolgeBuchungssatz[5] := sFolgeVorgaenger[5];
              sFolgeBuchungssatz[8] := sFolgeVorgaenger[8];
              sFolgeBuchungssatz[4] :=
                format(cFormatMoney, [StrToDoubledef(sFolgeBuchungssatz[5],
                0) + StrToDoubledef(sFolgeBuchungssatz[6], 0)]);

              if (Konto = 'SATZ1') then
              begin
                if WarEbenErloesKonto then
                  sFolgeBuchungssatz[9] := '3'
                else
                  sFolgeBuchungssatz[9] := '9';
              end;

              if (Konto = 'SATZ2') then
              begin
                if WarEbenErloesKonto then
                  sFolgeBuchungssatz[9] := '2'
                else
                  sFolgeBuchungssatz[9] := '8';
              end;
              sCSV.Delete(pred(sCSV.count));

            end
            else
            begin
              sFolgeBuchungssatz[5] := format(cFormatMoney, [-FieldByName('BETRAG').AsDouble]);
              sFolgeBuchungssatz[4] := sFolgeBuchungssatz[5];
              sFolgeBuchungssatz[6] := '';
            end;

            sCSV.add(HugeSingleLine(sFolgeBuchungssatz, ';'));

            sFolgeVorgaenger.Assign(sFolgeBuchungssatz);
            sFolgeBuchungssatz.free;
            ApiNext;
          end;
        end;
        sFolgeVorgaenger.free;

        sInitialerBuchungssatz.free;
        ApiNext;
      end;

    end;

    //
    sCSV.savetofile(WorkPath + 'DATEV.CSV');

    cBUCH.free;
    cFOLGE.free;
    sCSV.free;
    sText.free;
    sKontenAlias.free;

    // Nun die Rechnungsbelege ausgeben

    ExportTable(sSQL_Alle, WorkPath + 'AUSGANGSRECHNUNGEN.CSV');

    cRECHNUNGEN:= nCursor;
    with cRECHNUNGEN do
    begin
     sql.add ( sSQL_Alle);

     ApiFirst;
     while not(eof) do
     begin
      RechnungFName := e_r_BelegFNameCombined(
      { } FieldByName('PERSON_R').AsInteger,
      { } FieldByName('BELEG_R').AsInteger,
      { } FieldByName('TEILLIEFERUNG').AsInteger);

    if not(FileExists(RechnungFName)) then
      RechnungFName := e_r_BelegFName(
      { } FieldByName('PERSON_R').AsInteger,
      { } FieldByName('BELEG_R').AsInteger,
      { } FieldByName('TEILLIEFERUNG').AsInteger);

    if FileExists(RechnungFName) then
      FileCopy(
       RechnungFName,
       WorkPath + FieldByName('RECHNUNG').AsString + '.html' );


      ApiNext;
     end;
    end;
    cRECHNUNGEN.Free;

    // zip
    ZipFName := IntToStr(Bis) + cZIPExtension;
    zip(nil, _WorkPath+ZipFName, czip_set_RootPath + '=' + WorkPath);
    openShell(WorkPath);
  end;

end;

procedure TFormBuchhalter.Button2Click(Sender: TObject);
begin
  ListBox1.Items.savetofile(DiagnosePath + 'HBCI-Abfrage'+cLogExtension);
  openShell(DiagnosePath + 'HBCI-Abfrage'+cLogExtension);
end;

procedure TFormBuchhalter.Button3Click(Sender: TObject);
var
  sDiagnose: TStringList;
  n: Integer;
  BUCH_R: Integer;
  sInitialSaetze: TgpIntegerList;
begin
  if doit(format('Sollen %d Buchungss‰tze neu gebucht werden', [ItemKontoAuszugRIDs.count])) then
  begin
    sInitialSaetze := TgpIntegerList.Create;
    sDiagnose := TStringList.Create;
    BeginHourGlass;
    for n := 0 to pred(ItemKontoAuszugRIDs.count) do
    begin
      BUCH_R := e_r_sql('select MASTER_R from BUCH where RID=' + inttostr(ItemKontoAuszugRIDs[n]));
      if (sInitialSaetze.IndexOf(BUCH_R) = -1) then
        sInitialSaetze.add(BUCH_R);
    end;
    for n := 0 to pred(sInitialSaetze.count) do
      b_w_buche(sInitialSaetze[n], sDiagnose);
    EndHourGlass;
    FormCareServer.ShowIfError(sDiagnose);
    sDiagnose.free;
    RefreshKontoAuszug;
  end;
end;

procedure TFormBuchhalter.Button4Click(Sender: TObject);
var
  sTANAbfrage: TStringList;
begin

  //
  KlassischeTAN := Edit10.Text;
  Memo1.lines.clear;
  sTANAbfrage := REST(
   {} iHBCIRest + 'sammellastschrift/' +
   {} StrFilter(iKontoBLZ, cZiffern) + '/' +
   {} StrFilter(iKontoNummer, cZiffern),
   {} MyProgramPath + cHBCIPath + 'DTAUS.DTA.SEPA.csv',
   {} true);
  LastschriftJobID := REST_ETAG;
  MemoLog(sTANAbfrage);
  sTANAbfrage.free;
  Edit10.Text := '';
  Edit10.SetFocus;

  if (KlassischeTAN <> '') then
  begin
    if (Memo1.lines.count > 0) then
      if (StrToIntDef(Memo1.lines[0], 0) > 10000) then
      begin
        Edit10.Text := KlassischeTAN;
        KlassischeTAN := '';
        Button6Click(Sender);
      end;
  end
  else
  begin
    WarteAufMeldung := true;
    ensureTimerState;
  end;
end;

procedure TFormBuchhalter.IB_Grid2GetDisplayText(Sender: TObject; ACol, ARow: Integer; var AString: string);
begin
  if (ACol = 2) then
  begin
    ersetze(#13#10, #160, AString);
    ersetze('=', ': ', AString);
  end;
end;

procedure TFormBuchhalter.Image1Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Lastschriften');
end;

procedure TFormBuchhalter.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Lastschriften');
end;

procedure TFormBuchhalter.Image3Click(Sender: TObject);
begin
  openShell(cHelpURL + 'HBCI');
end;

procedure TFormBuchhalter.Image4Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Buchfuehrung');
end;

procedure TFormBuchhalter.JvArrayButton1ArrayButtonClicked(ACol, ARow: Integer);
var
  n: Integer;
  sForderungen_Index: Integer;
begin

  // show Beleg
  if (sForderungen.count > 0) and BelegMode then
  begin
    showBeleg(ACol);
    exit;
  end;

  // show Beleg
  if (sForderungen.count = 1) and (ACol = 0) then
  begin
    showBeleg(ACol);
    exit;
  end;

  // swap
  if (sForderungen.count > 1) then
  begin
    BeginHourGlass;
    repeat
      sForderungen_Index := ACol - sAusgleich_FirstButtonOffset;

      if (ACol = 0) then
      begin
        for n := sAusgleich_FirstButtonOffset to sForderungen.count - 2 do
          sForderungen.Exchange(n, Succ(n));
        beep;
        break;
      end;

      if (sForderungen_Index < sForderungen.count) then
      begin
        for n := ACol downto 1 do
          sForderungen.Exchange(pred(sAusgleich_FirstButtonOffset + n), sAusgleich_FirstButtonOffset + n);
        break;
      end;

    until true;
    Erzeuge_Show_sYellow(sBetrag, false);
    EndHourGlass;
  end;
end;

function TFormBuchhalter.LogKontoFName(KontoNummer: string; BUCH_R: Integer): string;
begin
  result :=
   {} MyProgramPath + cHBCIPath + KontoNummer + '\' +
   {} inttostrN(BUCH_R, 8) + cLogExtension;
end;

procedure TFormBuchhalter.MemoLog(s: String);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  sl.add(s);
  MemoLog(sl);
  sl.free;
end;

procedure TFormBuchhalter.MemoLog(s: TStrings);
begin
  with Memo1 do
  begin
    lines.addstrings(s);
    SelStart := SendMessage(Handle, EM_LINEINDEX, pred(lines.count), 0);
    SendMessage(Handle, EM_SCROLLCARET, 0, 0);
  end;
end;

procedure TFormBuchhalter.setNewPoint(BUCH_R: Integer);
begin
  _NewPoint := BUCH_R;
end;

function TFormBuchhalter.rBUCH_R: Integer;
begin
  with DrawGrid2 do
    if (Row >= 0) and (Row < ItemKontoAuszugRIDs.count) then
      result := ItemKontoAuszugRIDs[Row]
    else
      result := cRID_Null;
end;

procedure TFormBuchhalter.Button5Click(Sender: TObject);
var
  Stat_NeueBuchungen: Integer;
  pKonto, pBLZ: string;
begin
  // Ausgew‰hltes Konto
  BeginHourGlass;
  Stat_NeueBuchungen := 0;

  repeat

    //
    if CheckBox3.Checked then
    begin
      pKonto := Edit3.Text;
      pBLZ := Edit9.Text;
      if CheckBox4.Checked then
        e_r_Saldo(pKonto + ':' + ':' + pBLZ)
      else
        Stat_NeueBuchungen := e_w_KontoSync(pKonto + ':' + ':' + pBLZ, CheckBox1.Checked, CheckBox2.Checked);
    end
    else
    begin
      if CheckBox4.Checked then
        e_r_Saldo(iKontenHBCI)
      else
        Stat_NeueBuchungen := e_w_KontoSync(iKontenHBCI);
    end;

    // gleich die neuen Anzeigen
    if (Stat_NeueBuchungen > 0) then
    begin
      PageControl1.ActivePage := TabSheet4;
      SpeedButton2Click(Sender);
    end;

  until yet;

  EndHourGlass;
end;

procedure TFormBuchhalter.Button6Click(Sender: TObject);
const
  cTAN_AnzahlStellen = 6;
var
  Response: TStringList;
  iTAN: string;
begin

  BeginHourGlass;
  repeat

    // Ist die TAN g¸ltig?
    iTAN := StrFilter(Edit10.Text, '0123456789');
    if (length(iTAN) <> cTAN_AnzahlStellen) then
    begin
      EndHourGlass;
      ShowMessage('TAN sollte ' + inttostr(cTAN_AnzahlStellen) + '-stellig sein!');
      break;
    end;

    if (iTAN <> Fill('0', cTAN_AnzahlStellen)) then
    begin

      // Ist eine g¸ltige JobID vorhanden?
      if (StrToIntDef(LastschriftJobID, -1) = -1) then
      begin
        EndHourGlass;
        ShowMessage('Es konnte keine JOB-Nummer ermittelt werden!');
        break;
      end;

      Memo1.lines.clear;
      Response := REST(
       {} iHBCIRest + 'itan/' +
       {} LastschriftJobID + '/' +
       {} iTAN,
       {} '',
       {} true);
      MemoLog(Response);
      Response.free;
    end;

    // Volumen nun als ‹bertragen markieren
    e_w_HBCI_Group(iTAN, LastschriftJobID);

    // Jetzt die ganzen Server-Infos ausgeben
    if (iTAN <> Fill('0', cTAN_AnzahlStellen)) then
    begin
      REST_ETAG := LastschriftJobID;
      Response := e_r_Log;
      MemoLog(Response);
      Response.free;
    end;

    EndHourGlass;

  until true;

  IB_Query1.Refresh;

end;

procedure TFormBuchhalter.Button7Click(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet2;
end;

function TFormBuchhalter.e_r_Log: TStringList;
var
  n: Integer;
begin
  result := REST(iHBCIRest + 'Log/' + REST_ETAG, '', true);
  for n := pred(result.count) downto 0 do
  begin
    if (pos(cERRORText, result[n]) > 0) then
      continue;
    if (pos(cWARNINGText, result[n]) > 0) then
      continue;
    if (pos(cINFOText, result[n]) > 0) then
      continue;
    result.Delete(n);
  end;
  for n := 0 to pred(result.count) do
    result[n] := '  ' + cutblank(result[n]);
end;

procedure TFormBuchhalter.e_w_HBCI_EreignisDel(EREIGNIS_R: Integer; Grund: string);
begin
  e_x_sql(
    { } 'update EREIGNIS set ' +
    { } 'BEENDET=CURRENT_TIMESTAMP, ' +
    { } 'INFO=INFO'+cC_CRLF+
    { } SQLstring(Grund) + ' ' +
    { } 'where RID=' + inttostr(EREIGNIS_R));
end;

procedure TFormBuchhalter.e_w_HBCI_Group(TAN: string; JobID: string);
var
  sVOLUMEN: TsTable;
  sDTAUS: TsTable;
  r: Integer;
  col_RID: Integer;
  col_BELEG_R: Integer;
  col_TEILLIEFERUNG: Integer;

  EREIGNIS_R: Integer;
  qEREIGNIS: TIB_Query;
  qDOKUMENT: TIB_Query;
  sINFO: TStringList;
  sCSV: TStringList;
  sCSV_FileName: string;

  function DateiAblegen(PostFix: string): string;
  begin
    result :=
    { } MyProgramPath +
    { } cHBCIPath +
    { } 'DTAUS-' +
    { } inttostrN(EREIGNIS_R, 8) +
    { } '.' + PostFix;
    FileCopy(
      { } MyProgramPath + cHBCIPath + 'DTAUS.' + PostFix,
      { } result);
    FileTouch(result);
  end;

begin
  sVOLUMEN := TsTable.Create;
  sDTAUS := TsTable.Create;
  qEREIGNIS := DataModuleDatenbank.nQuery;
  qDOKUMENT := DataModuleDatenbank.nQuery;
  sINFO := TStringList.Create;
  sCSV := TStringList.Create;

  EREIGNIS_R := e_w_gen('EREIGNIS_GID');

  // Ereignis erzeugen
  sDTAUS.insertFromFile(MyProgramPath + cHBCIPath + 'DTAUS.DTA.csv');
  with qEREIGNIS do
  begin
    ColumnAttributes.add('AUFTRITT=NOTREQUIRED');
    sql.add('select * from EREIGNIS for update');
    insert;
    FieldByName('RID').AsInteger := EREIGNIS_R;
    FieldByName('ART').AsInteger := eT_ZahlungPerLastschrift;
    FieldByName('MENGE').AsInteger := sDTAUS.RowCount;
    sINFO.values['BETRAG'] := format('%m', [sDTAUS.sumCol('Betrag')]);
    sINFO.values['TAN'] := TAN;
    sINFO.values['JOB'] := JobID;
    FieldByName('INFO').Assign(sINFO);
    if (sBearbeiter >= cRID_FirstValid) then
      FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
    post;
  end;
  DateiAblegen('DTA');
  DateiAblegen('DTA.CSV');
  DateiAblegen('DTA.raw.csv');
  DateiAblegen('DTA.UTF-8.csv');
  DateiAblegen('DTA.SEPA.csv');

  // EREIGNIS_R in allen Forderungsdatens‰tzen buchen
  with sVOLUMEN do
  begin
    insertFromFile(MyProgramPath + cHBCIPath + 'DTAUS.csv');
    col_RID := colOf('RID', true);
    col_BELEG_R := colOf('BELEG_R', true);
    col_TEILLIEFERUNG := colOf('TEILLIEFERUNG', true);
    for r := 1 to RowCount do
    begin
      // Markiere die Forderung als "an die Bank ¸bertragen"
      e_x_sql(
        { } 'update AUSGANGSRECHNUNG set' +
        { } ' EREIGNIS_R=' + inttostr(EREIGNIS_R) + ', ' +
        { } ' POSNO=' + inttostr(r) + ' ' +
        { } 'where' +
        { } ' (RID=' + readCell(r, col_RID) + ')');

      // Markiere das Mandat (wenn vorhanden) als "benutzt"
      e_x_sql(
        { } 'update BUCH set' +
        { } ' EREIGNIS_R=' + inttostr(EREIGNIS_R) + ',' +
        { } ' WERTSTELLUNG=CURRENT_TIMESTAMP ' +
        { } 'where' +
        { } ' (NAME=' + SQLString(cKonto_Mandat) + ') and' +
        { } ' (BELEG_R=' + readCell(r, col_BELEG_R) + ') and' +
        { } ' (TEILLIEFERUNG=' + readCell(r, col_TEILLIEFERUNG) + ')');

    end;
  end;
  sCSV_FileName := DateiAblegen('csv');
  sCSV.LoadFromFile(sCSV_FileName);

  // Das Paket als Dokument speichern
  with qDOKUMENT do
  begin
    sql.add('select RID,MEDIUM_R,EREIGNIS_R,BEMERKUNG from DOKUMENT');
    insert;
    FieldByName('RID').AsInteger := cRID_AutoInc;
    FieldByName('MEDIUM_R').AsInteger := e_x_ensureMedium('CSV Tabelle');
    FieldByName('EREIGNIS_R').AsInteger := EREIGNIS_R;
    FieldByName('BEMERKUNG').Assign(sCSV);
    post;
  end;

  sINFO.free;
  qEREIGNIS.free;
  qDOKUMENT.free;
  sDTAUS.free;
  sVOLUMEN.free;
  sCSV.free;
end;

function TFormBuchhalter.e_w_KontoSync(Konten: string; AlleUmsaetze: boolean = false; Buchen: boolean = true): Integer;
var
  OneKonto: string;
  sINFO: TStringList;
  Anzahl_NeueBuchungen: Integer;
  n: Integer;
begin
  result := 0;
  if (Konten <> '') then
  begin
    setNewPoint(e_r_gen('GEN_BUCH'));

    if RadioButton9.Checked then
    begin
      //
      ListBox1.Items.add('Kontaktiere Banking-Server "' + iHBCIRest + '"...');
      application.processmessages;

      // Versionsnummer Abruf
      sINFO := REST(iHBCIRest + 'Info/','',true);
      ListBox1.Items.add('  [' + REST_ETAG + ']');
      for n := pred(sINFO.count) downto 0 do
      begin
        sINFO[n] := cutblank(sINFO[n]);
        if sINFO[n] = '' then
          sINFO.Delete(n)
        else
          sINFO[n] := '  ' + sINFO[n];
      end;
      ListBox1.Items.addstrings(sINFO);
      sINFO.free;

      ListBox1.Items.add('');
      ListBox1.ItemIndex := pred(ListBox1.Items.count);

    end;

    if RadioButton10.Checked then
    begin
      //
      ListBox1.Items.add('Lese aus Logverzeichnis "'+Edit11.Text+'"...');
      application.processmessages;
    end;

    while (Konten <> '') do
    begin
      OneKonto := noblank(nextp(Konten, ';'));

      ListBox1.Items.add(nextp(OneKonto, ':', 2) + '-' + nextp(OneKonto, ':', 0) + ' ...');
      application.processmessages;

      Anzahl_NeueBuchungen := e_x_KontoSyncREST(
        { KontoNr } nextp(OneKonto, ':', 2),
        { BLZ } nextp(OneKonto, ':', 0),
        { JobId } Edit12.Text,
        { LogID } Edit11.Text,
        {} AlleUmsaetze,
        {} Buchen);

      if (Anzahl_NeueBuchungen >= 0) then
      begin
        ListBox1.Items.add('  ' + inttostr(Anzahl_NeueBuchungen) + ' neue Buchung(en).');
        inc(result, Anzahl_NeueBuchungen);
      end
      else
      begin
        sINFO := TStringList.Create;
        sINFO.LoadFromFile(LogKontoFName(nextp(OneKonto, ':', 0),_NewPoint));
        for n := 0 to pred(sINFO.count) do
          if pos(cERRORText, sINFO[n]) > 0 then
            ListBox1.Items.add('  ' + sINFO[n]);
        sINFO.free;
      end;
      ListBox1.Items.add('');
      ListBox1.ItemIndex := pred(ListBox1.Items.count);
      Edit12.Text := '';
    end;
  end;
end;

function TFormBuchhalter.e_x_KontoSyncREST(BLZ, KontoNummer, JobID, LogID: string; AlleUmsaetze: boolean;
  Buchen: boolean): Integer;
var
  ErrorCount: Integer;
  DiagnoseLog: TStringList;
  serverLog: TStringList;
  Headers: TStringList;

  function r(Line, FieldName: string): string;
  var
    i: Integer;
  begin
    i := Headers.IndexOf(FieldName);
    if (i = -1) then
      result := ''
    else
      result := nextp(Line, ';', i);
  end;

  procedure radd(Line, FieldName: string; sl: TStringList);
  var
    s: string;
  begin
    s := r(Line, FieldName);
    if (s <> '') then
      sl.add(s);
  end;

  procedure sadd(Kuerzel, Wert: string; sl: TStringList);
  var
    s: string;
  begin
    if Wert <> '' then
    begin
      s := noblank(sl.Text);
      if (pos(Wert, s) = 0) then
        if pos(Kuerzel + ':', s) = 0 then
          sl.add(Kuerzel + ': ' + Wert);
    end;
  end;

var
  i, n, m: Integer;
  AbfrageStartDatum: TAnfixDate;

  sResult,sSingle: TStringList;

  //
  LastDate: TAnfixDate;
  LfdNoBuchungstag, LfdNo: Integer;
  SkipCount, _SkipCount: Integer; // wieviel Datens‰tze der Bank sollen ¸berlesen werden
  MD5,DataLine: string;
  Script: TStringList;
  uText: TStringList;
  sDir: TStringList;

  cBUCH: TIB_Cursor;
  qBUCH: TIB_Query;

  vonName: TStringList;
  BuchungsText: TStringList;
  s, ActLine: string;

  // Umsatzdaten
  PosNo: Integer;
  EntryDate, ValutaDate: TAnfixDate;
  Amount: double;
  RealValuta: string;
  TransactionType: string;
  CustomerReference: string;
  BusinessTransactionCode: string;
  BankCode, AccountNumber: string;
  IBAN: string;
  BusinessTransactionText: string;
  PrimaNoteNumber: string;
  MandatsReferenz, GlaeubigerID, EndeZuEndeReferenz: string;

  // Bereits im System
  BereitsGespeichert: boolean;

  // Ereignis eintragen
  EREIGNIS_R: Integer;
  sEreignis: TStringList;
  qEREIGNIS: TIB_Query;

begin
  result := -1;
  ErrorCount := 0;
  EREIGNIS_R := cRID_Null;
  Script := TStringList.Create;
  uText := TStringList.Create;
  DiagnoseLog := TStringList.Create;
  sDir:= TStringList.Create;
  vonName := TStringList.Create;
  BuchungsText := TStringList.Create;
  sResult := nil;
  qBUCH := DataModuleDatenbank.nQuery;
  cBUCH := DataModuleDatenbank.nCursor;
  AbfrageStartDatum := DatePlus(DateGet, -2);
  try
    CheckCreateDir(MyProgramPath + cHBCIPath + KontoNummer);
    FileDelete(MyProgramPath + cHBCIPath + KontoNummer + '\*', 60);

    // Tag der letzten Buchung ermitteln!
    if not(AlleUmsaetze) then
    begin
      with cBUCH do
      begin
        sql.add('select max(DATUM) DATUM from BUCH where NAME=''' + KontoNummer + '''');
        ApiFirst;
        if eof then
          AlleUmsaetze := true
        else
          AbfrageStartDatum := datetime2long(FieldByName('DATUM').AsDate);
      end;
    end;

    //
    if AlleUmsaetze then
      AbfrageStartDatum := DatePlus(DateGet, -365);

    //
    if not(DateOK(AbfrageStartDatum)) then
      AbfrageStartDatum := DatePlus(DateGet, -365);

    //
    with qBUCH do
    begin
      sql.add('select * from BUCH for update');
    end;

    repeat

      if (JobID='') and (LogID='') then
      begin

        sResult := REST(
         { } iHBCIRest +
         { } 'umsatz/' +
         { } BLZ + '/' +
         { } KontoNummer + '/' +
         { } long2date(AbfrageStartDatum));

        if DebugMode then
         sResult.SaveToFile(DiagnosePath+'Umsatz-'+REST_ETAG+'.csv');
        ListBox1.Items.add('  [' + REST_ETAG + ']');
        break;
      end;

      if (pos('*',JobID)>0) then
      begin
       sResult := TStringList.Create;
       sDir := TStringList.Create;
       Dir(MyPRogramPath+cHBCIPath+KontoNummer+'\*'+cLogExtension,sDir,false);
       sDir.Sort;
       for n := 0 to pred(sDir.Count) do
       begin
         DiagnoseLog.LoadFromFile(MyProgramPath+cHBCIPath+KontoNummer+'\'+sDir[n]);
         for m := 0 to pred(DiagnoseLog.Count) do
          if (CHarCount(cDTA_csvSeparator,DiagnoseLog[m])>22) then
           if (pos(cDTA_Umsatz_Header,DiagnoseLog[m])=0) then
           begin
             DataLine := DiagnoseLog[m];
             ersetze('(null)','',DataLine);
             if (sResult.IndexOf(DataLine)=-1) then
               sResult.Add(DataLine);
           end;
       end;
       DiagnoseLog.Clear;
       sResult.Insert(0, cDTA_Umsatz_Header);
       sResult.SaveToFile(DiagnosePath + 'Umsatz-aus-Log-'+IntToStr(_NewPoint)+'.csv');
       sDir.Free;
       break;
      end;

      if (LogID='*') then
      begin
       sDir := TStringList.Create;
       sResult := TStringList.create;
       sResult.add(cDTA_Umsatz_Header);
       Dir(MyPRogramPath+cHBCIPath+KontoNummer+'\*'+cLogExtension,sDir,false);
       sDir.Sort;
       for n := 0 to pred(sDir.Count) do
       begin
        sSingle := TStringList.create;
        sSingle.LoadFromFile(MyProgramPath+cHBCIPath+KontoNummer+'\'+sDir[n]);
        for m := 0 to pred(sSingle.Count) do
          if (CharCount(cDTA_csvSeparator,sSingle[m])<22) then
          begin
            while (sSingle.Count>m) do
             sSingle.Delete(pred(sSingle.Count));
            break;
          end;
        sSingle.Delete(0);
        sResult.AddStrings(sSingle);
        sSingle.Free;
       end;
       break;
      end;

      if (LogID<>'') then
      begin
        sResult := TStringList.create;
        sResult.LoadFromFile(LogKontoFName(KontoNummer,StrTOIntDef(LogID,-1)));
        for m := 0 to pred(sResult.Count) do
          if (CharCount(cDTA_csvSeparator,sResult[m])<22) then
          begin
            while (sResult.Count>m) do
             sResult.Delete(pred(sResult.Count));
            break;
          end;
        break;
      end;

      // aus der Ablage
      sResult := REST(iHBCIRest + 'ablage/' + JobID);
    until yet;
    DiagnoseLog.addstrings(sResult);

    // Log-Nachrichten des Servers
    if RadioButton9.Checked then
    begin
      serverLog := e_r_Log;
      ListBox1.Items.addstrings(serverLog);
      DiagnoseLog.addstrings(serverLog);
      serverLog.free;
    end;

    // Skip-Automatik verwenden
    if CheckBox8.checked then
    begin
      SkipCount := e_r_sql(
       {} 'select count(RID) from '+
       {} 'BUCH where'+
       {} ' (NAME=''' + KontoNummer + ''') and' +
       {} ' (DATUM=''' + long2date(AbfrageStartDatum) + ''') and' +
       {} ' (MD5 is not null)');
    end else
    begin
     SkipCount := 0;
    end;
    _SkipCount := SkipCount;

    if (SkipCount>0) then
     ListBox1.Items.add('  Skip '+IntToStr(SkipCount)+' ...');

    // ‹berhaupt was da?
    if (sResult.count > 0) then
      // OrgaMon oder AQB kann jeweils weiterentwickelt sein, ->kein Problem
      if (pos(cDTA_Umsatz_Header, sResult[0]) = 1) or (pos(sResult[0], cDTA_Umsatz_Header) = 1) then
      begin

        Headers := split(sResult[0]);
        result := 0;
        LastDate := cMinDate;
        LfdNo := 0; // wird sp‰ter durch "1" ¸berschrieben
        LfdNoBuchungstag := 0;

        for i := 1 to pred(sResult.count) do
        begin

          ActLine := sResult[i];
          DiagnoseLog.add(ActLine);

          //
          // Identifikationsfelder muss aufbereitet werden
          // zur Dublettenerkennung
          //
          MD5 := DtaUmsatzMD5(ActLine);

          EntryDate := Date2Long(r(ActLine, 'Datum'));
          if (EntryDate <> LastDate) then
          begin
            LastDate := EntryDate;
            LfdNo := 1;
          end;

          if CheckBox7.Checked then
            BereitsGespeichert := (e_r_sql(
             {} 'select count(RID) from BUCH where' +
             {} ' (NAME=''' + KontoNummer + ''') and'              +
             {} ' (DATUM=''' + long2date(EntryDate) + ''') and' +
             {} ' (MD5=''' + MD5 + ''')') <> 0)
          else
            BereitsGespeichert := (e_r_sql(
            {} 'select count(RID) from BUCH where' +
            {} ' (NAME=''' + KontoNummer + ''') and'              +
            {} ' (DATUM=''' + long2date(EntryDate) + ''') and' +
            {} ' (POSNO=' + inttostr(LfdNo) + ')') <> 0);

          if (SkipCount>0) then
          begin

            dec(SkipCount);
            repeat
              if BereitsGespeichert then
               break;

              if (AbfrageStartDatum<>EntryDate) then
              begin
               ListBox1.Items.add('ERROR: Weniger Ums‰tze als bisher!');
               SkipCount := 0;
               break;
              end;

              ListBox1.Items.add(
               'Beim Umsatz #'+IntToStr(LfdNo)+
               '/'+IntToStr(_SkipCount)+
               ' vom '+long2date(EntryDate)+
               ' haben sich ƒnderungen ergeben die ignoriert werden, da dieser Umsatz'+
               ' bereits gespeichert wurde');
              ListBox1.Items.add(ActLine);

              BereitsGespeichert := true;
            until yet;
          end;

          // Fingerabdruck suchen
          if not(BereitsGespeichert) then
          begin

            if Buchen then
            begin

              // Aufbereiten
              PosNo := StrToIntDef(r(ActLine, 'PosNo'),0);
              ValutaDate := Date2Long(r(ActLine, 'Valuta'));
              Amount := strtodouble(r(ActLine, 'Betrag'));
              TransactionType := r(ActLine, 'Typ');
              CustomerReference := r(ActLine, 'VonREF');
              if (CustomerReference = '') then
                CustomerReference := 'NONREF';
              BusinessTransactionCode := r(ActLine, 'VorgangID');
              BankCode := r(ActLine, 'VonBLZ');
              AccountNumber := r(ActLine, 'VonKonto');
              IBAN := '';
              BusinessTransactionText := r(ActLine, 'VorgangText');
              PrimaNoteNumber := r(ActLine, 'PrimaNota');
              BuchungsText.clear;
              radd(ActLine, 'Buchungstext1', BuchungsText);
              radd(ActLine, 'Buchungstext2', BuchungsText);
              radd(ActLine, 'Buchungstext3', BuchungsText);
              radd(ActLine, 'Buchungstext4', BuchungsText);
              radd(ActLine, 'Buchungstext5', BuchungsText);
              radd(ActLine, 'Buchungstext6', BuchungsText);
              radd(ActLine, 'Buchungstext7', BuchungsText);
              vonName.clear;
              radd(ActLine, 'VonName1', vonName);
              radd(ActLine, 'VonName2', vonName);
              MandatsReferenz := r(ActLine, 'MandatsReferenz');
              sadd('MREF', MandatsReferenz, BuchungsText);
              GlaeubigerID := r(ActLine, 'GlaeubigerID');
              sadd('CRED', GlaeubigerID, BuchungsText);
              EndeZuEndeReferenz := r(ActLine, 'EndeZuEndeReferenz');
              sadd('EREF', EndeZuEndeReferenz, BuchungsText);

              // Gesamtliste aller ¸bertragener Posten

              // Valutadatum "080319"
              RealValuta := long2date8(ValutaDate);
              RealValuta := copy(RealValuta, 7, 2) + // JJ
                copy(RealValuta, 4, 2) + // MM
                copy(RealValuta, 1, 2); // TT

              // Erst ein zentrales Ereignis schreiben
              if (EREIGNIS_R < cRID_FirstValid) then
              begin
                sEreignis := TStringList.Create;
                sEreignis.add('Umsatzabruf ' + BLZ + '/' + KontoNummer);
                sEreignis.addstrings(sResult);
                qEREIGNIS := DataModuleDatenbank.nQuery;
                with qEREIGNIS do
                begin
                  EREIGNIS_R := GEN_ID('EREIGNIS_GID', 1);
                  ColumnAttributes.add('AUFTRITT=NOTREQUIRED');
                  sql.add('select * from EREIGNIS for update');
                  insert;
                  FieldByName('RID').AsInteger := EREIGNIS_R;
                  FieldByName('ART').AsInteger := eT_UmsatzAbruf;
                  if (sBearbeiter > 0) then
                    FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
                  FieldByName('INFO').Assign(sEreignis);
                  FieldByName('TEILLIEFERUNG').AsInteger := AbfrageStartDatum;
                  post;
                end;
                qEREIGNIS.free;
                sEreignis.free;
              end;

              DiagnoseLog.add('+' + MD5);

              with qBUCH do
              begin

                // Datensatz speichern
                insert;
                FieldByName('RID').AsInteger := cRID_AutoInc;
                FieldByName('EREIGNIS_R').AsInteger := EREIGNIS_R;
                FieldByName('EREIGNIS_POSNO').AsInteger := PosNo;
                FieldByName('MOMENT').AsDateTime := now;
                FieldByName('NAME').AsString := KontoNummer;

                FieldByName('DATUM').AsDate := long2datetime(EntryDate);
                FieldByName('WERTSTELLUNG').AsDate := long2datetime(ValutaDate);
                FieldByName('POSNO').AsInteger := LfdNo;

                Script.clear;
                Script.values['TRANSAKTIONSTYP'] := TransactionType;
                FieldByName('SKRIPT').Assign(Script);

                // ‹berweisungstext
                uText.clear;
                uText.addstrings(vonName);
                if (BusinessTransactionCode = '1') then
                  if (CustomerReference <> 'NONREF') and (CustomerReference <> '') then
                    uText.add('Schecknummer: ' + CustomerReference);

                if (IBAN='') then
                begin
                  repeat

                    if (length(AccountNumber)=22) then
                    begin
                      IBAN := AccountNumber;
                      break;
                    end;

                    s := StrFilter(BuchungsText.Text, cZiffern + cBuchstaben + ':');
                    n := pos(cIBANStr+'DE', s);
                    if (n > 0) then
                    begin
                      IBAN := copy(s,n+5,22);
                      break;
                    end;

                  until yet;
                end;

                if (BankCode <> '') or (AccountNumber <> '') then
                begin
                  s := StrFilter(BuchungsText.Text, cZiffern + cBuchstaben + ':');

                  // keine Kontonummer? ev. in der SEPA Welt leer
                  if (AccountNumber = '') then
                  begin
                    n := pos(cIBANStr+'DE', s);
                    if (n > 0) then
                      AccountNumber := Bank_Konto(copy(s, n + 4 + 13, 10));
                  end;

                  // "Konto: %s BLZ: %s"  hinzuf¸gen, aber nur wenn nicht schon vorhanden!
                  if (pos(AccountNumber,s)=0) then
                  begin
                   if (length(AccountNumber)=22) then
                    uText.add(cIBANStr+' ' + AccountNumber)
                   else
                    uText.add(cKontoStr + ' ' + AccountNumber);
                  end;

                  if (pos(BankCode,s)=0) then
                  begin
                   if (StrFilter(BankCode,cBuchstaben)='') then
                    uText.add(cBLZStr + ' ' + BankCode)
                   else
                    uText.add(cBICStr + ' ' + BankCode)
                  end;
                end;

                uText.addstrings(BuchungsText);

                FieldByName('TEXT').Assign(uText);
                FieldByName('BETRAG').AsDouble := Amount;
                FieldByName('IBAN').AsString := IBAN;
                FieldByName('VORGANG').AsString := BusinessTransactionText + ' (' + BusinessTransactionCode + ')';
                FieldByName('STEMPEL_NO').AsInteger := StrToIntDef(PrimaNoteNumber, 0);
                FieldByName('MD5').AsString := MD5;
                post;

                inc(result);
              end;
            end
            else
            begin
              DiagnoseLog.add('#' + MD5);
            end;
          end
          else
          begin
            DiagnoseLog.add('-' + MD5);
          end;

          inc(LfdNo);
          application.processmessages;

        end;
      end
      else
      begin
        inc(ErrorCount);
      end;

  except
    on E: Exception do
    begin
      result := -1;
      inc(ErrorCount);
      DiagnoseLog.add(cERRORText + ' e_x_KontoSyncREST: ' + E.Message);
    end;
  end;

  // Log speichern
  if (LogID='') and (JobId='') then
   DiagnoseLog.SaveToFile(LogKontoFName(KontoNummer,_NewPoint))
  else
   DiagnoseLog.SaveToFile(
    {} DiagnosePath+
    {} KontoNummer+'-'+IntToStrN(_NewPoint,8)+cLogExtension);

  Script.free;
  uText.free;
  DiagnoseLog.free;
  qBUCH.free;
  cBUCH.free;
  if assigned(sResult) then
    sResult.free;
  if (ErrorCount <> 0) then
    result := -1;

end;

procedure TFormBuchhalter.e_r_Saldo(Konten: string);
var
  OneKonto: string;
  sINFO: TStringList;
  Anzahl_NeueBuchungen: Integer;
  n: Integer;
  saldo: double;
  kto, BLZ: string;
begin
  if (Konten <> '') then
  begin
    if RadioButton9.Checked then
    begin
      setNewPoint(e_r_gen('GEN_BUCH'));

      //
      ListBox1.Items.add('Kontaktiere Banking-Server "' + iHBCIRest + '"...');
      application.processmessages;

      // Versionsnummer Abruf
      sINFO := REST(iHBCIRest + 'Info/','',true);
      ListBox1.Items.add('  [' + REST_ETAG + ']');
      for n := pred(sINFO.count) downto 0 do
      begin
        sINFO[n] := cutblank(sINFO[n]);
        if sINFO[n] = '' then
          sINFO.Delete(n)
        else
          sINFO[n] := '  ' + sINFO[n];
      end;
      ListBox1.Items.addstrings(sINFO);
      sINFO.free;

      ListBox1.Items.add('');
      ListBox1.ItemIndex := pred(ListBox1.Items.count);

    end;

    while (Konten <> '') do
    begin
      OneKonto := noblank(nextp(Konten, ';'));
      kto := nextp(OneKonto, ':', 0);
      BLZ := nextp(OneKonto, ':', 2);

      if RadioButton9.Checked then
      begin
        ListBox1.Items.add(BLZ + '-' + kto + ' ...');
        ListBox1.Items.add(format('Saldo laut Buch %m', [b_r_KontoSaldo(kto)]));
        application.processmessages;

        saldo := e_r_SaldoREST(BLZ, kto, Edit12.Text);

        sINFO := TStringList.Create;
        sINFO.LoadFromFile(LogKontoFName(kto,_NewPoint));
        for n := 0 to pred(sINFO.count) do
          if pos(cERRORText, sINFO[n]) > 0 then
            ListBox1.Items.add('  ' + sINFO[n]);
        sINFO.free;

        ListBox1.Items.add(format('Saldo laut aktueller Abfrage %m', [saldo]));

        ListBox1.Items.add('');
        ListBox1.ItemIndex := pred(ListBox1.Items.count);
        Edit12.Text := '';
      end;

    end;
  end;
end;

function TFormBuchhalter.e_r_SaldoREST(BLZ, KontoNummer, JobID: string): double;
var
  ErrorCount: Integer;
  serverLog: TStringList;
  Headers: TStringList;
  DiagnoseLog: TStringList;

  function r(Line, FieldName: string): string;
  var
    i: Integer;
  begin
    i := Headers.IndexOf(FieldName);
    if (i = -1) then
      result := '??'
    else
      result := nextp(Line, ';', i);
  end;

  procedure radd(Line, FieldName: string; sl: TStringList);
  var
    s: string;
  begin
    s := r(Line, FieldName);
    if (s <> '') then
      sl.add(s);
  end;

var

  sResult: TStringList;

  //
  cBUCH: TIB_Cursor;

  // Ereignis eintragen
  EREIGNIS_R: Integer;
  sEreignis: TStringList;
  qEREIGNIS: TIB_Query;

begin
  result := cGeld_keinElement;
  ErrorCount := 0;
  EREIGNIS_R := cRID_Null;
  sResult := nil;
  DiagnoseLog := TStringList.Create;
  cBUCH := DataModuleDatenbank.nCursor;
  try

    if (JobID <> '') then
    begin
      sResult := REST(iHBCIRest + 'ablage/' + JobID);
    end
    else
    begin
      sResult := REST(iHBCIRest + 'saldo/' + BLZ + '/' + KontoNummer);
      ListBox1.Items.add('  [' + REST_ETAG + ']');
    end;
    DiagnoseLog.addstrings(sResult);

    // Log-Nachrichten weitergeben
    serverLog := e_r_Log;
    ListBox1.Items.addstrings(serverLog);
    DiagnoseLog.addstrings(serverLog);
    serverLog.free;

    //
    if (sResult.count > 0) then
      if pos(cDTA_Saldo_Header, sResult[0]) = 1 then
      begin

        Headers := split(sResult[0]);
        result := strtodouble(r(sResult[1], 'Betrag'));

        // Erst ein zentrales Ereignis schreiben
        sEreignis := TStringList.Create;
        sEreignis.add('Saldoabruf ' + BLZ + '/' + KontoNummer);
        qEREIGNIS := DataModuleDatenbank.nQuery;
        with qEREIGNIS do
        begin
          ColumnAttributes.add('AUFTRITT=NOTREQUIRED');
          sql.add('select * from EREIGNIS for update');
          insert;
          FieldByName('RID').AsInteger := cRID_AutoInc;
          FieldByName('ART').AsInteger := eT_SaldoAbruf;
          if (sBearbeiter > 0) then
            FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
          FieldByName('INFO').Assign(sEreignis);
          FieldByName('MENGE').AsInteger := cCent(result);
          post;
        end;
        qEREIGNIS.free;
        sEreignis.free;
      end;

  except
    on E: Exception do
    begin
      result := cGeld_keinElement;
      inc(ErrorCount);
    end;
  end;

  // Log speichern
  DiagnoseLog.savetofile(LogKontoFName(KontoNummer,_NewPoint));
  DiagnoseLog.free;
  cBUCH.free;
  if assigned(sResult) then
    sResult.free;
  if (ErrorCount <> 0) then
    result := -1;

end;

procedure TFormBuchhalter.DrawGrid1DblClick(Sender: TObject);
begin
  FormBuchung.setContext(Integer(ItemKontoAuszugRIDs[DrawGrid1.Row]));
end;

procedure TFormBuchhalter.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  BUCH_R: Integer;
  VORGANG: string;
  Fokusiert: boolean;
  UeberweisungsText: TStringList;

  ScriptText: TStringList;
  n, yT: Integer;
  DatensatzVorhanden: boolean;
  RowHeight: Integer;
  tmpColor: TColor;
  Needle : String;
  OutStr: String;
  t,l: string;
begin
  if (ARow >= 0) then
    with DrawGrid1.canvas, IB_Cursor1 do
    begin

      DatensatzVorhanden := false;
      BUCH_R := cRID_Null;
      Fokusiert := (ARow = DrawGrid1.Row);

      if Fokusiert then
      begin
        brush.color := HTMLColor2TColor($99CCFF);
      end
      else
      begin
        if odd(ARow) then
        begin
          brush.color := clWhite;
        end
        else
        begin
          brush.color := clListeGrau;
        end;
      end;

      if (ARow < ItemKontoAuszugRIDs.count) then
      begin
        BUCH_R := Integer(ItemKontoAuszugRIDs[ARow]);
        if (FieldByName('RID').AsInteger <> BUCH_R) then
        begin
          ParamByName('CROSSREF').AsInteger := BUCH_R;
          ApiFirst;
        end;
        DatensatzVorhanden := not(eof);
      end;

      if DatensatzVorhanden then
      begin

        if (ItemMarked.IndexOf(ItemKontoAuszugRIDs[ARow]) <> -1) then
        begin
          if Fokusiert then
          begin
            brush.color := HTMLColor2TColor($CCFFFF); // $99FF00
          end
          else
          begin
            if odd(ARow) then
            begin
              brush.color := HTMLColor2TColor($00CCFF);
            end
            else
            begin
              brush.color := HTMLColor2TColor($0099CC);
            end;
          end;
        end;
        case ACol of
          0:
            begin
              // Status
              ScriptText := TStringList.Create;
              FieldByName('SKRIPT').AssignTo(ScriptText);
              if (ScriptText.values['COLOR'] <> '') then
                brush.color := HTMLColor2TColor(ScriptText.values['COLOR']);
              ScriptText.free;
              FillRect(Rect);
              if (_NewPoint >= cRID_FirstValid) then
                if (FieldByName('MASTER_R').AsInteger > _NewPoint) then
                begin
                  font.size := 8;
                  font.Style := [fsItalic];
                  TextOut(Rect.left + 2, Rect.top, 'neu');
                  font.Style := [];
                end;

              if ToDoMode then
               if Fokusiert then
               begin
                 if not(assigned(ToDoList)) then
                 begin
                   ToDoList := TStringList.create;
                   ToDoList.LoadFromFile(DiagnosePath+'ToDo-Buch.txt');
                 end;
                 Needle := FieldByName('MASTER_R').AsString+';';
                 label27.Caption := '';
                 for n := 1 to pred(ToDoList.Count) do
                  if pos(Needle,ToDoList[n])=1 then
                  begin
                   label27.Caption := nextp(ToDoList[n],';',1);
                   break;
                  end;
               end;
              // draw(rect.left + 3, rect.top + 2, StatusBMPs[random(4)]); // Status
            end;
          1:
            begin
              // Datum
              if BUCH_R <> FieldByName('MASTER_R').AsInteger then
                brush.color := HTMLColor2TColor($FFCC99);

              font.size := 10;
              if FieldByName('DATUM').IsNull then
                TextRect(Rect, Rect.left + 2, Rect.top, FieldByName('NAME').AsString)
              else
                TextRect(Rect, Rect.left + 2, Rect.top, long2date(FieldByName('DATUM').AsDate));
              if FieldByName('GEGENKONTO').IsNotNull then
                if FieldByName('GEBUCHT').IsNull then
                  font.Style := [fsStrikeOut];
              OutStr := FieldByName('GEGENKONTO').AsString;
              if FieldByName('BAUSTELLE_R').IsNotNull then
               OutStr := OutStr + '#' + FieldByName('BAUSTELLE_R').AsString;
              if FieldByName('BUGET_R').IsNotNull then
               OutStr := OutStr + '@' + FieldByName('BUGET_R').AsString;

              TextOut(Rect.left + 2, Rect.top + cPlanY, OutStr);
              font.Style := [];

            end;
          2:
            begin
              // Wertstellung
              font.size := 10;
              TextRect(Rect, Rect.left + 2, Rect.top, long2date(FieldByName('WERTSTELLUNG').AsDate));
            end;
          3:
            begin
              // Vorgang
              font.size := 9;
              TextRect(Rect, Rect.left + 2, Rect.top, FieldByName('NAME').AsString);
              yT := Rect.Top + cPlanY;

              if FieldByName('VORGANG').IsNull then
              begin
                TextOut(Rect.left + 2, yT,
                  {} inttostr(FieldByName('BELEG_R').AsInteger) + '-' +
                  {} inttostrN(FieldByName('TEILLIEFERUNG').AsInteger, 2));
                inc(yT, cPlanY);
              end
              else
              begin
                VORGANG := FieldByName('VORGANG').AsString;
                TextOut(Rect.left + 2, yT, VORGANG);
                inc(yT, cPlanY);
                repeat

                  if b_r_GutschriftAusLS(VORGANG) then
                  begin
                    tmpColor := brush.color;
                    brush.color := HTMLColor2TColor(cDTA_Color);
                    TextOut(Rect.left + 2, yT, cAnzeige_Vorgang_LSG);
                    brush.color := tmpColor;
                    inc(yT, cPlanY);
                    break;
                  end;

                  if b_r_Abschluss(VORGANG) then
                  begin
                    tmpColor := brush.color;
                    brush.color := HTMLColor2TColor(cABSCHLUSS_Color);
                    TextOut(Rect.left + 2, yT, cAnzeige_Vorgang_ABSCHLUSS);
                    brush.color := tmpColor;
                    inc(yT, cPlanY);
                    break;
                  end;

                until yet;
              end;
              TextOut(Rect.left + 2, yT, 'PN' + FieldByName('STEMPEL_NO').AsString);
            end;
          4:
            begin
              // Text
              UeberweisungsText := TStringList.Create;
              if FieldByName('TEXT').IsNull then
                UeberweisungsText.add(FieldByName('KONTO').AsString)
              else
                FieldByName('TEXT').AssignTo(UeberweisungsText);

              WordWrap(UeberweisungsText,35);

              // Zeilehˆhe anpassen - falls notwendig!
              RowHeight := max(cPlanY * 2, cPlanY * UeberweisungsText.count) + dpiX(2);
              if (RowHeight <> DrawGrid1.RowHeights[ARow]) then
              begin
                DrawGrid1.RowHeights[ARow] := RowHeight;
                UeberweisungsText.free;
                exit;
              end;

              // Zeichnen
              font.size := 9;
              repeat

                // erste Zeile
                if (UeberweisungsText.count > 0) then
                begin
                  TextRect(Rect, Rect.left + 2, Rect.top, UeberweisungsText[0]);
                end
                else
                begin
                  TextRect(Rect, Rect.left + 2, Rect.top, '');
                  break;
                end;

                // weitere Zeilen
                for n := 1 to pred(UeberweisungsText.count) do
                  TextOut(Rect.left + 2, Rect.top + cPlanY * n, UeberweisungsText[n]);

              until true;

              UeberweisungsText.free;

            end;
          5:
            begin
              if (FieldByName('ERTRAG').AsString = 'N') or
                ((FieldByName('BETRAG').AsDouble < 0) and (FieldByName('ERTRAG').AsString <> 'Y')) then
              begin
                font.size := 10;
                font.Style := [fsbold];
                if (FieldByName('BETRAG').AsDouble < 0) then
                  font.color := HTMLColor2TColor($CC0033);
                TextRect(Rect, Rect.left + 2, Rect.top, format('%15m', [FieldByName('BETRAG').AsDouble]));

                font.color := clblack;
                font.Style := [];
              end
              else
                TextRect(Rect, Rect.left + 2, Rect.top, '');
            end;
          6:
            begin
              if (FieldByName('ERTRAG').AsString = 'Y') or
                ((FieldByName('BETRAG').AsDouble >= 0) and (FieldByName('ERTRAG').AsString <> 'N')) then
              begin
                font.size := 10;
                font.Style := [fsbold];
                if (FieldByName('BETRAG').AsDouble < 0) then
                  font.color := HTMLColor2TColor($CC0033);
                TextRect(Rect, Rect.left + 2, Rect.top, format('%15m', [FieldByName('BETRAG').AsDouble]));

                font.color := clblack;
                font.Style := [];
              end
              else
                TextRect(Rect, Rect.left + 2, Rect.top, '');
            end;
        else
          // dummy Rand Zellen
          FillRect(Rect);
        end;
        if (ACol > 0) then
        begin
          pen.color := $A0A0A0;
          MoveTo(Rect.left, Rect.top);
          LineTo(Rect.left, Rect.bottom);
        end;
      end
      else
      begin
        // total leer!
        FillRect(Rect);
      end;
    end;
end;

procedure TFormBuchhalter.DrawGrid2DblClick(Sender: TObject);
begin
  FormBuchung.setContext(Integer(ItemKontoAuszugRIDs[DrawGrid2.Row]));
end;

procedure TFormBuchhalter.DrawGrid2DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  BUCH_R: Integer;
  Fokusiert: boolean;
  UeberweisungsText_Original: TStringList;
  UeberweisungsText_WordWrap: TStringList;
  ScriptText: TStringList;
  n, yT: Integer;
  DatensatzVorhanden: boolean;
  RowHeight: Integer;
  Betrag, BetragNominal: double;
  VORGANG: string;
  tmpColor: TColor;
begin
  if (ARow >= 0) then
    with DrawGrid2.canvas, IB_Cursor1 do
    begin

      DatensatzVorhanden := false;
      Fokusiert := (ARow = DrawGrid2.Row);

      if Fokusiert then
      begin
        brush.color := HTMLColor2TColor($99CCFF);
      end
      else
      begin
        if odd(ARow) then
        begin
          brush.color := clWhite;
        end
        else
        begin
          brush.color := clListeGrau;
        end;
      end;

      if (ARow < ItemKontoAuszugRIDs.count) then
      begin
        BUCH_R := Integer(ItemKontoAuszugRIDs[ARow]);
        if (FieldByName('RID').AsInteger <> BUCH_R) then
        begin
          ParamByName('CROSSREF').AsInteger := BUCH_R;
          ApiFirst;
        end;
        DatensatzVorhanden := not(eof);
      end;

      if DatensatzVorhanden then
      begin

        if (ItemMarked.IndexOf(ItemKontoAuszugRIDs[ARow]) <> -1) then
        begin
          if Fokusiert then
          begin
            brush.color := HTMLColor2TColor($CCFFFF); // $99FF00
          end
          else
          begin
            if odd(ARow) then
            begin
              brush.color := HTMLColor2TColor($00CCFF);
            end
            else
            begin
              brush.color := HTMLColor2TColor($0099CC);
            end;
          end;
        end;
        case ACol of
          0:
            begin

              // Status
              ScriptText := TStringList.Create;
              FieldByName('SKRIPT').AssignTo(ScriptText);
              if (ScriptText.values['COLOR'] <> '') then
                brush.color := HTMLColor2TColor(ScriptText.values['COLOR']);
              ScriptText.free;

              FillRect(Rect);
              // draw(rect.left + 3, rect.top + 2, StatusBMPs[random(4)]); // Status
            end;
          1:
            begin
              // Datum
              font.size := 10;
              TextRect(Rect, Rect.left + 2, Rect.top, long2date(FieldByName('DATUM').AsDate));
              TextOut(Rect.left + 2, Rect.top + cPlanY, 'RID' + FieldByName('RID').AsString);

            end;
          2:
            begin
              // Wertstellung
              font.size := 10;
              TextRect(Rect, Rect.left + 2, Rect.top, long2date(FieldByName('WERTSTELLUNG').AsDate));
            end;
          3:
            begin

              // Vorgang
              font.size := 9;
              TextRect(Rect, Rect.left + 2, Rect.top, FieldByName('NAME').AsString);
              yT := Rect.top + cPlanY;

              VORGANG := FieldByName('VORGANG').AsString;
              TextOut(Rect.left + 2, yT, VORGANG);
              inc(yT, cPlanY);

              repeat

                if b_r_GutschriftAusLS(VORGANG) then
                begin
                  tmpColor := brush.color;
                  brush.color := HTMLColor2TColor(cDTA_Color);
                  TextOut(Rect.left + 2, yT, cAnzeige_Vorgang_LSG);
                  brush.color := tmpColor;
                  inc(yT,cPlanY);
                  break;
                end;

                if b_r_Abschluss(VORGANG) then
                begin
                  tmpColor := brush.color;
                  brush.color := HTMLColor2TColor(cABSCHLUSS_Color);
                  TextOut(Rect.left + 2, yT, cAnzeige_Vorgang_ABSCHLUSS);
                  brush.color := tmpColor;
                  inc(yT,cPlanY);
                  break;
                end;

              until yet;

              // Prima Nota
              TextOut(Rect.left + 2, yT, 'PN' + FieldByName('STEMPEL_NO').AsString);
            end;
          4:
            begin
              // Texte
              UeberweisungsText_Original := TStringList.Create;
              FieldByName('TEXT').AssignTo(UeberweisungsText_Original);
              UeberweisungsText_WordWrap := TStringList.Create;
              UeberweisungsText_WordWrap.AddStrings(UeberweisungsText_Original);
              WordWrap(UeberweisungsText_WordWrap,35);
              ScriptText := TStringList.Create;
              FieldByName('SKRIPT').AssignTo(ScriptText);
              Betrag := StrToDoubledef(ScriptText.values['BETRAG'], cGeld_keinElement);
              if isNoMoney(Betrag) then
                Betrag := FieldByName('BETRAG').AsDouble;
              ScriptText.free;

              // ################
              RowHeight := max(cPlanY * 3, cPlanY * UeberweisungsText_WordWrap.count) + dpiX(2);
              if (RowHeight <> DrawGrid2.RowHeights[ARow]) then
              begin
                DrawGrid2.RowHeights[ARow] := RowHeight;
                UeberweisungsText_WordWrap.free;
                exit;
              end;
              // ################

              font.size := 9;
              repeat

                // erste Zeile
                if (UeberweisungsText_WordWrap.count > 0) then
                begin
                  TextRect(Rect, Rect.left + 2, Rect.top, UeberweisungsText_WordWrap[0]);
                end
                else
                begin
                  TextRect(Rect, Rect.left + 2, Rect.top, '');
                  break;
                end;

                // weitere Zeilen
                for n := 1 to pred(UeberweisungsText_WordWrap.count) do
                  TextOut(Rect.left + 2, Rect.top + cPlanY * n, UeberweisungsText_WordWrap[n]);

              until true;

              // nun auch die untere Tabelle fertigmalen
              if Fokusiert then
                if (DrawGrid2_LastFocused <> ARow) then
                begin
                  DrawGrid2_LastFocused := ARow;

                  // besonderer Modus f¸r Gutschriften aus Lastschriften
                  if b_r_GutschriftAusLS(FieldByName('VORGANG').AsString) then
                    UeberweisungsText_Original.add(cAnzeige_Vorgang_LSG + '=' + cIni_Activate);

                  // suche die passenden Debitoren
                  setDebiContext(
                    { } UeberweisungsText_Original,
                    { } Betrag,
                    { } datetime2long(FieldByName('DATUM').AsDate));

                end;
              UeberweisungsText_WordWrap.free;
              UeberweisungsText_Original.free;

            end;
          5:
            begin

              if (FieldByName('BETRAG').AsDouble < 0) then
              begin
                font.size := 10;
                font.Style := [fsbold];
                font.color := HTMLColor2TColor($CC0033);
                TextRect(Rect, Rect.left + 2, Rect.top, format('%15m', [FieldByName('BETRAG').AsDouble]));
                font.color := clblack;
                font.Style := [];
              end
              else
                TextRect(Rect, Rect.left + 2, Rect.top, '');
            end;
          6:
            begin
              Betrag := FieldByName('BETRAG').AsDouble;
              if (Betrag > 0) then
              begin

                // BETRAG=
                ScriptText := TStringList.Create;
                FieldByName('SKRIPT').AssignTo(ScriptText);
                BetragNominal := StrToDoubledef(ScriptText.values['BETRAG'], cGeld_keinElement);
                ScriptText.free;

                font.size := 10;
                if isNoMoney(BetragNominal) then
                begin
                  font.Style := [fsbold];
                  TextRect(Rect, Rect.left + 2, Rect.top, format('%15m', [Betrag]));
                end
                else
                begin
                  font.Style := [fsItalic];
                  TextRect(Rect, Rect.left + 2, Rect.top, format('%15m', [Betrag]));
                  font.Style := [fsbold];
                  TextOut(Rect.left + 2, Rect.top + cPlanY * 1, format('%15m', [BetragNominal]));
                end;

                font.Style := [];
              end
              else
                TextRect(Rect, Rect.left + 2, Rect.top, '');
            end;
        else
          // dummy Rand Zellen
          FillRect(Rect);
        end;
        if (ACol > 0) then
        begin
          pen.color := $A0A0A0;
          MoveTo(Rect.left, Rect.top);
          LineTo(Rect.left, Rect.bottom);
        end;
      end
      else
      begin
        // total leer, da eof
        FillRect(Rect);
      end;
    end;
end;

procedure TFormBuchhalter.DrawGrid3DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  PERSON_R: Integer;
  Fokusiert: boolean;
  saldo: double;
begin
  if (ARow >= 0) then
    with DrawGrid3.canvas do
    begin
      Fokusiert := (ARow = DrawGrid3.Row);

      if Fokusiert then
      begin
        brush.color := HTMLColor2TColor($99CCFF);
      end
      else
      begin
        if odd(ARow) then
        begin
          brush.color := clWhite;
        end
        else
        begin
          brush.color := clListeGrau;
        end;
      end;

      if (ARow < ItemDebiRIDs.count) then
      begin
        PERSON_R := Integer(ItemDebiRIDs[ARow]);

        if (ItemMarked.IndexOf(ItemDebiRIDs[ARow]) <> -1) then
        begin
          if Fokusiert then
          begin
            brush.color := HTMLColor2TColor($CCFFFF); // $99FF00
          end
          else
          begin
            if odd(ARow) then
            begin
              brush.color := HTMLColor2TColor($00CCFF);
            end
            else
            begin
              brush.color := HTMLColor2TColor($0099CC);
            end;
          end;
        end;
        with IB_Cursor1 do
        begin
          case ACol of
            0:
              begin

                // Status Kalt oder Warm oder HOT-HOT-HOT
                brush.color := HTMLColor2TColor(cBUCH_Farbe_Kalt); // kalt
                repeat
                  if (PERSON_R = cRID_Person_Lastschrift) then
                  begin
                    brush.color := HTMLColor2TColor(cBUCH_Farbe_OK);
                    break;
                  end;

                  if (b_r_Auszug_KontoIBAN(sBuchungsText) <> e_r_sqls('select Z_ELV_KONTO from PERSON ' + 'where RID=' +
                    inttostr(PERSON_R))) then
                    break;

                  if (b_r_Auszug_BLZBIC(sBuchungsText) <> e_r_sqls('select Z_ELV_BLZ from PERSON ' + 'where RID=' +
                    inttostr(PERSON_R))) then
                    break;

                  if (e_r_sqls('select Z_ELV_BANK_NAME from PERSON ' + 'where RID=' + inttostr(PERSON_R))
                    = cOrgaMonPrivat) then
                    brush.color := HTMLColor2TColor(cBUCH_Farbe_DurchlaufenderPosten)
                    // rosa
                  else
                    brush.color := HTMLColor2TColor(cBUCH_Farbe_OK);
                  // gr¸n

                until true;

                FillRect(Rect);
                // draw(rect.left + 3, rect.top + 2, StatusBMPs[random(4)]); // Status
              end;
            1:
              begin

                // Name
                font.size := 10;
                if (PERSON_R = cRID_Person_Lastschrift) then
                begin
                  TextRect(Rect, Rect.left + 2, Rect.top, 'Konto ' + cKonto_Bank);
                end
                else
                begin
                  TextRect(Rect, Rect.left + 2, Rect.top, e_r_Person(PERSON_R));
                  TextOut(Rect.left + 2, Rect.top + cPlanY, e_r_sqls(
                    { } 'select ANSCHRIFT.STRASSE from' +
                    { } ' PERSON ' +
                    { } 'join' +
                    { } ' ANSCHRIFT ' +
                    { } 'on (ANSCHRIFT.RID=PERSON.PRIV_ANSCHRIFT_R) ' +
                    { } 'where' +
                    { } ' (PERSON.RID=' + inttostr(PERSON_R) + ')'));
                end;

              end;
            2:
              begin
                // noch ohne Verwendung
                TextRect(Rect, Rect.left + 2, Rect.top, '');
                // TextOut(rect.left + 2, rect.top + cPlanY, 'Volumen-Monatlich');
              end;
            3:
              begin

                // Beleg-Daten
                font.size := 10;
                font.Style := [fsbold];
                if (PERSON_R = cRID_Person_Lastschrift) then
                  saldo := b_r_LastschriftSaldo
                else
                  saldo := b_r_PersonSaldo(PERSON_R);
                TextRect(Rect, Rect.left + 2, Rect.top, format('%15m', [saldo]));
                font.Style := [];

                // nun die aktuellen Forderungen anzeigen
                if Fokusiert then
                begin
                  if (DrawGrid3_PERSON_R <> PERSON_R) then
                  begin

                    Draw_PersonSaldo(saldo);
                    Erzeuge_sForderungen(PERSON_R);
                    Erzeuge_Show_sYellow(sBetrag, true);

                    // Arbeit aufzeichnen im Cache
                    DrawGrid3_PERSON_R := PERSON_R;
                  end;
                end;

              end;
          else
            // dummy Rand Zellen
            FillRect(Rect);
          end;
        end;
        if (ACol > 0) then
        begin
          pen.color := $A0A0A0;
          MoveTo(Rect.left, Rect.top);
          LineTo(Rect.left, Rect.bottom);
        end;
      end
      else
      begin
        // total leer!
        FillRect(Rect);
      end;
    end;
end;

procedure TFormBuchhalter.Edit10KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    //
    Key := #0;
    ShowMessage('Die TAN wird erst ¸bertragen sobald Sie den Briefumschlag dr¸cken!');
  end;
end;

procedure TFormBuchhalter.Edit13KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    //
    Key := #0;
    RefreshDebis(Edit13.Text);
  end;

end;

procedure TFormBuchhalter.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    //
    Key := #0;
    doSuche;
  end;
end;

procedure TFormBuchhalter.Edit8KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    if (Edit8.Text = 'BI1') then
      doBI1(ItemKontoAuszugRIDs);
    Edit8.Text := '';
  end;
end;

procedure TFormBuchhalter.ensureTimerState;
begin
  if WarteAufMeldung then
  begin
    BeginHourGlass;
    Timer1.enabled := true;
    JvGIFAnimator2.Visible := true;
    JvGIFAnimator2.Animate := true;
  end
  else
  begin
    Timer1.enabled := false;
    JvGIFAnimator2.Animate := false;
    JvGIFAnimator2.Visible := false;
    EndHourGlass;
  end;
end;

procedure TFormBuchhalter.FormActivate(Sender: TObject);
begin
  CheckInitialized;
  if refreshOnActivate then
  begin
    if (PageControl1.ActivePage = TabSheet5) then
      RefreshNeueEingaenge;
    if (PageControl1.ActivePage = TabSheet4) then
      RefreshKontoAuszug;
    refreshOnActivate := false;
  end;
end;

procedure TFormBuchhalter.TabSheet4Show(Sender: TObject);
begin
  if Initialized then
  begin
    if not(InitializedTab4) then
    begin
      RefreshKontoCombos;
      RefreshKontoAuszug;
      InitializedTab4 := true;
    end
    else
    begin
      RefreshKontoAuszug;
    end;
  end;
end;

procedure TFormBuchhalter.TabSheet5Show(Sender: TObject);
begin
  // Combobox mit einem Default belegen
  Disable_AusgleichCache;

  if Initialized then
  begin
    if not(InitializedTab5) then
    begin
      RefreshAusgleichCombos;
      InitializedTab5 := true;
    end;
    RefreshNeueEingaenge;
  end;
end;

procedure TFormBuchhalter.TabSheet6Show(Sender: TObject);
var
  AlleKonten: TStringList;
begin
  if (Memo2.lines.count = 0) then
    if FileExists(SystemPath + '\Konten-Alias.ini') then
      Memo2.lines.LoadFromFile(SystemPath + '\Konten-Alias.ini');

  if (ComboBox3.Text = '') then
  begin
    AlleKonten := e_r_sqlsl(
     {} 'select distinct NAME from BUCH where' +
     {}  ' (NAME is not null) and' +
     {}  ' (NAME<>'''') and' +
     {}  ' (BETRAG is not null)');
    AlleKonten.sort;
    ComboBox3.Items.Assign(AlleKonten);
    AlleKonten.free;
  end;

  if (Edit2.Text='') then
  begin
    Edit2.Text := long2date( DatePlus(DateGet,-213) );
    Edit6.Text := long2date( DatePlus(DateGet,-1) );
  end;

end;

procedure TFormBuchhalter.TabSheet7Show(Sender: TObject);
begin
  BeginHourGlass;
  if not(IB_Query2.Active) then
    IB_Query2.open
  else
    IB_Query2.Refresh;
  EndHourGlass;

end;

procedure TFormBuchhalter.Timer1Timer(Sender: TObject);
var
  Response: TStringList;

  procedure timerOFF;
  begin
    WarteAufMeldung := false;
    ensureTimerState;
  end;

begin
  if NoTimer then
    exit;
  if not(WarteAufMeldung) then
    exit;

  repeat

    // Job-ID aus der ersten Zeile des Memo rauslesen
    if (StrToIntDef(LastschriftJobID, -1) = -1) then
    begin
      timerOFF;
      MemoLog('ERROR: Es konnte keine JOB-Nummer ermittelt werden!');
      break;
    end;

    Response := REST(iHBCIRest + 'meldung/' + LastschriftJobID);

    if (Response.count > 0) then
      if (pos('[NA]', Response[0]) = 0) then
      begin
        timerOFF;
        MemoLog(html2raw(Response));
      end;

    Response.free;
  until true;
end;

procedure TFormBuchhalter.SyncKontoUmsaetze;
var
  cBUCH: TIB_Cursor;
  ABSCHLUSS: TAnfixDate;
  saldo: TSaldo;
  DebugAbschluss: TStringList;
begin
  if Initialized then
  begin

    BeginHourGlass;
    ItemKontoAuszugRIDs.clear;
    if DebugMode then
    begin
    DebugAbschluss := TStringList.Create;
    DebugAbschluss.Add('DATUM;PER;ABSCHLUSS');
    end else
    begin
       DebugAbschluss := nil;
    end;
    saldo := TSaldo.Create;

    cBUCH := DataModuleDatenbank.nCursor;
    with cBUCH do
    begin
      sql.add('select');
      sql.add(' RID, TEXT, BETRAG, ABSCHLUSS,');
      sql.add(' DATUM, WERTSTELLUNG, VORGANG');
      sql.add('from BUCH');
      sql.add('where');
      sql.addstrings(getSQLwhere);

      repeat

        if (ComboBox1.Text = cKonto_Deckblatt) then
        begin
          sql.add('order by NAME');
          break;
        end;

        if (ComboBox1.Text = cKonto_Anzahlungen) then
        begin
          sql.add('order by BELEG_R,TEILLIEFERUNG,DATUM,POSNO');
          break;
        end;

        if (ComboBox1.Text = cKonto_Bank) then
        begin
          sql.add('order by EREIGNIS_R,POSNO,RID');
          break;
        end;

        sql.add('order by DATUM,POSNO');
      until yet;
      dbLog(sql);
      open;
      DrawGrid1.RowCount := Recordcount;
      ApiFirst;
      ABSCHLUSS := 0;
      while not(eof) do
      begin
        // ...
        ItemKontoAuszugRIDs.add(FieldByName('RID').AsInteger);
        b_r_SaldenFortschreibung(ABSCHLUSS,cBUCH,saldo,DebugAbschluss);
        ApiNext;
      end;
    end;
    RefreshKontoAuszugSaldo(saldo.saldo);
    if DebugMode then
    begin
      DebugAbschluss.SaveToFile(DiagnosePath+'Abschluss.csv');
      DebugAbschluss.Free;
      DebugAbschluss := saldo.Diagnose;
      DebugAbschluss.SaveToFile(DiagnosePath+'Saldo.csv');
      DebugAbschluss.Free;
    end;
    cBUCH.free;
    saldo.free;
    ItemKontoAuszugAll.Assign(ItemKontoAuszugRIDs);
    EndHourGlass;

  end;
end;

procedure TFormBuchhalter.SyncNeueEingaenge;
var
  cBUCH: TIB_Cursor;
  UeberweisungsText: TStringList;
  RecN: Integer;
  saldo: double;
begin
  if Initialized then
  begin
    BeginHourGlass;
    ItemKontoAuszugRIDs.clear;
    UeberweisungsText := TStringList.Create;
    cBUCH := DataModuleDatenbank.nCursor;
    saldo := 0;
    with cBUCH do
    begin
      sql.add('select RID,TEXT,BETRAG,VORGANG from BUCH');
      sql.add('where');
      sql.add(' (NAME=''' + ComboBox2.Text + ''') and');
      // richtiges Konto
      sql.add(' ((BETRAG>0.0) or (ERTRAG='+cC_True_AsString+')) and'); // Eingang!

      // im Fokus
      if DateOK(iBuchFokus) then
        sql.add(' (DATUM >= ''' + long2date(iBuchFokus) + ''') and ');

      // noch nicht gebucht!
      sql.add(' ((GEGENKONTO is null) or (GEGENKONTO=''''))');

      sql.add('order by DATUM,POSNO');
      open;
      DrawGrid2.RowCount := Recordcount;
      ApiFirst;
      RecN := 0;
      while not(eof) do
      begin
        // ...
        ItemKontoAuszugRIDs.add(FieldByName('RID').AsInteger);
        FieldByName('TEXT').AssignTo(UeberweisungsText);

        saldo := saldo + FieldByName('BETRAG').AsDouble;

        // ...
        DrawGrid2.RowHeights[RecN] := max(cPlanY * 3, cPlanY * UeberweisungsText.count) + 2;
        inc(RecN);
        ApiNext;
      end;
    end;
    cBUCH.free;
    UeberweisungsText.free;
    Draw_NeueEingaengeSaldo(saldo);
    EndHourGlass;
  end;
end;

procedure TFormBuchhalter.RefreshDebis(AddInfo: string = '');
var
  BUCH_R: Integer;
  sl: TStringList;
  ScriptText: TStringList;
  cBUCH: TIB_Cursor;
  n: Integer;
  FoundKonto: boolean;
  Betrag: double;
begin

  // Debi-Suche-Update
  BUCH_R := rBUCH_R;
  if (BUCH_R >= cRID_FirstValid) then
  begin

    sl := TStringList.Create;
    ScriptText := TStringList.Create;
    cBUCH := DataModuleDatenbank.nCursor;
    with cBUCH do
    begin
      sql.add('select TEXT,SKRIPT,BETRAG,DATUM,VORGANG from BUCH where RID=' + inttostr(BUCH_R));
      ApiFirst;
      if not(eof) then
      begin
        FieldByName('TEXT').AssignTo(sl);
        FieldByName('SKRIPT').AssignTo(ScriptText);
        Betrag := StrToDoubledef(
          { } ScriptText.values['BETRAG'],
          { } cGeld_keinElement);
        if isNoMoney(Betrag) then
          Betrag := FieldByName('BETRAG').AsDouble;
        if b_r_GutschriftAusLS(FieldByName('VORGANG').AsString) then
          sl.add(cAnzeige_Vorgang_LSG + '=' + cIni_Activate);
      end;

      if (AddInfo <> '') then
      begin
        FoundKonto := false;
        for n := 0 to pred(sl.count) do
          if (pos(cKontoStr, sl[n]) > 0) then
          begin
            sl.insert(n + 1, AddInfo);
            FoundKonto := true;
            break;
          end;
        if not(FoundKonto) then
          sl.add(AddInfo);
      end;

      setDebiContext(sl, Betrag, datetime2long(FieldByName('DATUM').AsDate));
    end;
    cBUCH.free;
    sl.free;
    ScriptText.free;
  end
  else
  begin
    setDebiContext;
  end;
end;

procedure TFormBuchhalter.RefreshForderungen;
begin
  Erzeuge_sForderungen(rPERSON_R);
  Erzeuge_Show_sYellow(sBetrag, true);
end;

procedure TFormBuchhalter.Erzeuge_Show_sYellow(Zahlung: double; SuchePassendeKombination: boolean);

  procedure setCaption(ACol, ARow: Integer; s: string);
  begin
    with JvArrayButton1 do
    begin
      if (ACol >= 0) and (ACol < Cols) then
        captions[Cols * ARow + ACol] := s;
    end;
  end;

  procedure setColor(ACol, ARow: Integer; c: TColor);
  begin
    with JvArrayButton1 do
    begin
      if (ACol >= 0) and (ACol < Cols) then
        colors[Cols * ARow + ACol] := HTMLColor2RGBConst(c);
    end;
  end;

  function sForderungen_saldo(i: Integer): double; overload;
  var
    UrsprungsForderung: double;
    ZahlungenBisher: double;
  begin
    UrsprungsForderung := StrToDoubledef(nextp(sForderungen[i], ';', 1), 0);
    ZahlungenBisher := StrToDoubledef(nextp(sForderungen[i], ';', 4), 0);
    result := UrsprungsForderung - ZahlungenBisher;
  end;

  function sForderungen_saldo(v: TgpIntegerList): double; overload;
  var
    i: Integer;
  begin
    result := 0.0;
    for i := 0 to pred(v.count) do
      result := result + sForderungen_saldo(v[i]);
  end;

var
  n, k, i: Integer;
  BELEG_R, PERSON_R: Integer;
  TEILLIEFERUNG: Integer;
  TITEL: string;
  VALUTA: TAnfixDate;
  RestForderung: double;
  UrsprungsForderung: double;
  ZahlungenBisher: double;
  AnzeigeIndex: Integer;
  v: TgpIntegerList;
  VolltrefferGefunden: boolean;
  sForderungenNeu: TStringList;
begin

  if not(assigned(sAusgleich)) then
    sAusgleich := TStringList.Create
  else
    sAusgleich.clear;

  with JvArrayButton1 do
  begin
    captions.clear;
    colors.clear;
    for n := 0 to pred(Cols * cButtonGridRows) do
    begin
      captions.add('');
      colors.add(HTMLColor2RGBConst(cBUCH_Farbe_Neutral));
    end;
  end;

  Panel3.color := clBtnFace;

  if assigned(sForderungen) then
  begin

    // Volltreffer durch Kombinatorik suchen
    // sForderungen entsprechend rumwirbeln
    VolltrefferGefunden := false;
    n := sForderungen.count;
    if SuchePassendeKombination then
      if (n >= 2) and (n <= 12) then
        for k := 1 to n do
        begin
          v := TgpIntegerList.Create;
          while (n_over_k(n, k, v)) do
          begin
            if isequal(Zahlung, sForderungen_saldo(v)) then
            begin
              sForderungenNeu := TStringList.Create;

              // Passendes: Vorne die Gutschriften, dann die Forderungen
              for i := 0 to pred(v.count) do
                if isHaben(sForderungen_saldo(v[i])) then
                  sForderungenNeu.add(sForderungen[v[i]])
                else
                  sForderungenNeu.insert(0, sForderungen[v[i]]);

              // Unpassendes: Hinten dran
              for i := 0 to pred(n) do
                if (v.IndexOf(i) = -1) then
                  sForderungenNeu.add(sForderungen[i]);

              FreeAndNil(sForderungen);
              sForderungen := sForderungenNeu;
              SpeedButton33.enabled := true;
              VolltrefferGefunden := true;
              break;
            end;
          end;
          if VolltrefferGefunden then
            break;
        end;

    for n := 0 to pred(sForderungen.count) do
    begin

      AnzeigeIndex := n - sAusgleich_FirstButtonOffset;

      // sForderungen auflˆsen!
      BELEG_R := StrToIntDef(nextp(sForderungen[n], ';', 2), cRID_Null);
      PERSON_R := StrToIntDef(nextp(sForderungen[n], ';', 5), cRID_Null);
      TEILLIEFERUNG := StrToIntDef(nextp(sForderungen[n], ';', 3), cRID_Null);
      UrsprungsForderung := StrToDoubledef(nextp(sForderungen[n], ';', 1), 0);
      ZahlungenBisher := StrToDoubledef(nextp(sForderungen[n], ';', 4), 0);
      RestForderung := UrsprungsForderung - ZahlungenBisher;
      if CheckBox6.Checked then
        TITEL := inttostr(BELEG_R) + '-' + inttostrN(TEILLIEFERUNG, 2)
      else
        TITEL := nextp(sForderungen[n], ';', 0);

      // Valuta
      if CheckBox5.Checked then
        VALUTA := Date2Long(TITEL)
      else
        VALUTA := sDatum;

      if not(DateOK(VALUTA)) then
        VALUTA := DateGet;

      // Anzeigen!
      setCaption(AnzeigeIndex, 0, TITEL); // ‹berschrift
      setCaption(AnzeigeIndex, 1, nextp(sForderungen[n], ';', 1));

      // Urspr¸ngliche Gesamtforderung
      if isSomeMoney(ZahlungenBisher) then // Anzahlungen
        setCaption(AnzeigeIndex, 2, format('%m', [-ZahlungenBisher]))
      else
        setCaption(AnzeigeIndex, 2, nextp(sForderungen[n], ';', 4));

      repeat

        if isZeroMoney(RestForderung) then
          break;

        if isZeroMoney(Zahlung) then
          break;

        if (RestForderung - Zahlung >= cGeld_KleinsterBetrag) then
        begin

          // Es konnte nicht komplett bezahlt werden!
          sAusgleich.add(format(cBuch_Ausgleich, [
            { } PERSON_R,
            { } BELEG_R,
            { } Zahlung,
            { } long2date(VALUTA),
            { } rBUCH_R,
            { } 'Teilzahlung',
            { } ComboBox2.Text,
            { } TEILLIEFERUNG,
            { } cRID_Null]));

          setCaption(AnzeigeIndex, 3, format('%m', [-Zahlung]));
          Zahlung := 0;

          setColor(AnzeigeIndex, 0, cBUCH_Farbe_Teilzahlung);
          setColor(AnzeigeIndex, 3, cBUCH_Farbe_edit);

          Panel3.color := HTMLColor2TColor(cBUCH_Farbe_Teilzahlung);

          break;
        end;

        if (Zahlung - RestForderung >= cGeld_KleinsterBetrag) and (n = pred(sForderungen.count)) then
        begin

          // ‹berzahlung
          sAusgleich.add(format(cBuch_Ausgleich, [
            { } PERSON_R,
            { } BELEG_R,
            { } Zahlung,
            { } long2date(VALUTA),
            { } rBUCH_R,
            { } '‹berzahlung',
            { } ComboBox2.Text,
            { } TEILLIEFERUNG,
            { } cRID_Null]));

          setCaption(AnzeigeIndex, 3, format('%m', [-Zahlung]));
          Zahlung := 0;

          setColor(AnzeigeIndex, 0, cBUCH_Farbe_Ueberzahlung);
          setColor(AnzeigeIndex, 3, cBUCH_Farbe_edit);

          Panel3.color := HTMLColor2TColor(cBUCH_Farbe_Ueberzahlung);
          break;

        end;

        // normaler Vollausgleich!
        sAusgleich.add(format(cBuch_Ausgleich, [
          { } PERSON_R,
          { } BELEG_R,
          { } RestForderung,
          { } long2date(VALUTA),
          { } rBUCH_R,
          { } '',
          { } ComboBox2.Text,
          { } TEILLIEFERUNG,
          { } cRID_Null]));

        setCaption(AnzeigeIndex, 3, format('%m', [-RestForderung]));
        Zahlung := Zahlung - RestForderung;

        // Ausgleichsbetrag (Vorschlag) gelb
        setColor(AnzeigeIndex, 0, cBUCH_Farbe_Gebucht);
        setColor(AnzeigeIndex, 3, cBUCH_Farbe_edit);

        Panel3.color := HTMLColor2TColor(cBUCH_Farbe_Gebucht);

      until true;
      // if (AnzeigeIndex=pred(JvArrayButton1.Cols)) then
      // break;

    end;
  end;
  JvArrayButton1.Refresh;

  // noch das Gesamt-Ergebnis darstellen

end;

procedure TFormBuchhalter.Erzeuge_sForderungen(PERSON_R: Integer);

  procedure viaLeistungsDatum(BELEG_R: Integer; rDate: TAnfixDate);
  var
    cPOSTEN: TIB_Cursor;

    // Salden
    Zahlung, Zahlungen: double;
    Forderung, DetailForderungen, Forderungen: double;

    // Details
    aDate: TAnfixDate;

  begin

    // Bisherige (An)zahlungen bestimmen!
    Zahlungen := -e_r_sqld(
     {} 'select SUM(BETRAG) from AUSGANGSRECHNUNG where ' +
     {} ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
     {} ' (BETRAG<0)');

    // Forderungen bestimmen!
    Forderungen := e_r_sqld(
     {} 'select SUM(BETRAG) from AUSGANGSRECHNUNG where ' +
     {} ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
     {} ' (BETRAG>0)');

    // Forderungs-Details bestimmen! (Wenn vorhanden!)
    DetailForderungen := 0;
    cPOSTEN := DataModuleDatenbank.nCursor;
    with cPOSTEN do
    begin

      sql.add('select');
      sql.add(' AUSFUEHRUNG,');
      sql.add(' MENGE_RECHNUNG as MENGE,');
      sql.add(' PREIS');
      sql.add('from');
      sql.add(' GELIEFERT');
      sql.add('where');
      sql.add(' (BELEG_R=' + inttostr(BELEG_R) + ') and');
      sql.add(' (AUSFUEHRUNG is not null) and');
      sql.add(' (MENGE_RECHNUNG is not null)');
      sql.add('order by');
      sql.add(' POSNO,RID');

      ApiFirst;
      while not(eof) do
      begin
        // hier noch die vollst‰ndige e_r_PostenPreis Routine
        Forderung := FieldByName('PREIS').AsDouble * FieldByName('MENGE').AsInteger;
        DetailForderungen := DetailForderungen + Forderung;
        aDate := datetime2long(FieldByName('AUSFUEHRUNG').AsDate);
        if (Zahlungen > 0) then
        begin
          Zahlung := -min(Forderung, Zahlungen);
          Zahlungen := Zahlungen + Zahlung;
        end
        else
        begin
          Zahlung := 0;
        end;
        sForderungen.add(format(cBuch_Forderungen, [
          { } long2date8(aDate),
          { } Forderung,
          { } BELEG_R,
          { } 0,
          { } Zahlung,
          { } PERSON_R]));
        ApiNext;
      end;
    end;
    cPOSTEN.free;

    // Es ist noch ein Rest ¸brig! (z.B. Mehrwertsteuer)
    if isSomeMoney(Forderungen - DetailForderungen + Zahlungen) then
      sForderungen.add(format(cBuch_Forderungen, [
        { } '?',
        { } Forderungen - DetailForderungen + Zahlungen,
        { } BELEG_R,
        { } 0,
        { } Zahlungen,
        { } PERSON_R]));

  end;

  procedure viaRechnungen(BELEG_R: Integer; rDate: TAnfixDate);
  var
    cVERSAND: TIB_Cursor;

    // Salden
    saldo: double;

    // Details
    RECHNUNG: string;
    TEILLIEFERUNG: Integer;
    GESAMT_FORDERUNG: double;
  begin

    // Forderungs-Details bestimmen! (Wenn vorhanden!)
    cVERSAND := DataModuleDatenbank.nCursor;
    with cVERSAND do
    begin
      sql.add('select');
      sql.add(' TEILLIEFERUNG,');
      sql.add(' LIEFERBETRAG,');
      sql.add(' RECHNUNG');
      sql.add('from');
      sql.add(' VERSAND');
      sql.add('where');
      sql.add(' (BELEG_R=' + inttostr(BELEG_R) + ') and');
      sql.add(' (RECHNUNG is not null)');
      sql.add('order by');
      sql.add(' TEILLIEFERUNG');
      ApiFirst;
      while not(eof) do
      begin
        TEILLIEFERUNG := FieldByName('TEILLIEFERUNG').AsInteger;
        RECHNUNG := FieldByName('RECHNUNG').AsString;
        GESAMT_FORDERUNG := FieldByName('LIEFERBETRAG').AsDouble;

        saldo := e_r_sqld(
         {} 'select SUM(BETRAG) from AUSGANGSRECHNUNG ' +
         {} 'where' +
         {} ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
         {} ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')');

        if isSomeMoney(saldo) then
        begin

          sForderungen.add(format(cBuch_Forderungen, [
            { } RECHNUNG,
            { } GESAMT_FORDERUNG,
            { } BELEG_R,
            { } TEILLIEFERUNG,
            { } GESAMT_FORDERUNG - saldo,
            { } PERSON_R]));

        end;
        ApiNext;
      end;
    end;
    cVERSAND.free;

  end;

var
  cAUSGANGSRECHNUNGEN: TIB_Cursor;
  cEREIGNIS: TIB_Cursor;
  n: Integer;
  Forderung, GesamteForderung: double;
  sINFO: TStringList;
begin
  SpeedButton33.enabled := false;
  sAusgleich_FirstButtonOffset := 0;

  if not(assigned(sForderungen)) then
    sForderungen := TStringList.Create
  else
    sForderungen.clear;

  if assigned(sForderungenFixed) then
    sForderungen.addstrings(sForderungenFixed);

  GesamteForderung := 0;

  if (PERSON_R = cRID_Person_Lastschrift) then
  begin
    cEREIGNIS := nCursor;
    sINFO := TStringList.Create;
    with cEREIGNIS do
    begin
      sql.add('select * from EREIGNIS where');
      sql.add(' (ART=11) and');
      sql.add(' (BEENDET is null)');
      sql.add('order by');
      sql.add('AUFTRITT');
      ApiFirst;
      while not(eof) do
      begin
        //
        e_r_sqlt(FieldByName('INFO'), sINFO);
        Forderung := StrToMoneyDef(sINFO.values['BETRAG']);

        sForderungen.add(format(cBuch_Forderungen, [
          { } FieldByName('MENGE').AsString + ':' + sINFO.values['TAN'],
          { } Forderung,
          { } FieldByName('RID').AsInteger,
          { } 0,
          { } cGeld_Zero,
          { } PERSON_R]));

        ApiNext;
      end
    end;
    cEREIGNIS.free;
    sINFO.free;
  end;

  if (PERSON_R >= cRID_FirstValid) then
  begin

    cAUSGANGSRECHNUNGEN := DataModuleDatenbank.nCursor;

    // Alle Beleg-Salden sammeln
    with cAUSGANGSRECHNUNGEN do
    begin
      sql.add('select');
      sql.add(' min(DATUM) FDATUM,');
      sql.add(' sum(BETRAG) SALDO,');
      sql.add(' BELEG_R');
      sql.add('from');
      sql.add(' AUSGANGSRECHNUNG');
      sql.add('where');
      sql.add(' KUNDE_R=' + inttostr(PERSON_R));
      sql.add('group by');
      sql.add(' BELEG_R');
      sql.add('order by');
      sql.add(' min(DATUM)');
      ApiFirst;
      while not(eof) do
      begin
        if isSomeMoney(FieldByName('SALDO').AsDouble) then
        begin
          if CheckBox5.Checked then
            viaLeistungsDatum(FieldByName('BELEG_R').AsInteger, datetime2long(FieldByName('FDATUM').AsDate))
          else
            viaRechnungen(FieldByName('BELEG_R').AsInteger, datetime2long(FieldByName('FDATUM').AsDate));
        end;
        ApiNext;
      end;
    end;

    // Summe der Gesamt-Forderungen bilden!
    for n := 0 to pred(sForderungen.count) do
      GesamteForderung := GesamteForderung + StrToDoubledef(nextp(sForderungen[n], ';', 1), 0);

    cAUSGANGSRECHNUNGEN.free;
  end;

end;

procedure TFormBuchhalter.RefreshKontoAuszug;
var
  BUCH_R: Integer;
  nROW: Integer;
begin
  BeginHourGlass;

  // alten Zustand speichern!
  if (ItemKontoAuszugRIDs.count > 0) and (ItemKontoAuszugRIDs.count = DrawGrid1.RowCount) then
    BUCH_R := ItemKontoAuszugRIDs[DrawGrid1.Row]
  else
    BUCH_R := cRID_Null;

  // Suchindex verwerfen
  if assigned(KontoAuszugIndex) then
    FreeAndNil(KontoAuszugIndex);

  // Liste neu aufbauen!
  SyncKontoUmsaetze;

  // alte Position nach Mˆglichkeit wiederherstellen!
  if (ItemKontoAuszugRIDs.count > 0) then
  begin
    IB_Cursor1.Refresh;

    Label28.Caption := inttostr(ItemKontoAuszugRIDs.count);
    repeat
      // vorher war gar nix?!
      if (BUCH_R = cRID_Null) then
      begin
        // gaanz ans Ende
        SecureSetRow(DrawGrid1, pred(ItemKontoAuszugRIDs.count));
        break;
      end;

      // alte Position wieder suchen
      nROW := ItemKontoAuszugRIDs.IndexOf(BUCH_R);
      if (nROW <> -1) then
        SecureSetRow(DrawGrid1, nROW);

    until true;
  end
  else
  begin
    Label28.Caption := '';
  end;

  DrawGrid1.Refresh;
  SetFocus;
  DrawGrid1.SetFocus;
  EndHourGlass;

end;

procedure TFormBuchhalter.Button8Click(Sender: TObject);
begin
  with IB_Query1 do
    FormPerson.setContext(FieldByName('PERSON_R').AsInteger);
end;

procedure TFormBuchhalter.Button9Click(Sender: TObject);
begin
  with IB_Query1 do
    FormBelege.setContext(FieldByName('PERSON_R').AsInteger, FieldByName('BELEG_R').AsInteger);
end;

procedure TFormBuchhalter.CheckBox5Click(Sender: TObject);
begin
  BeginHourGlass;
  Erzeuge_sForderungen(rPERSON_R);
  Erzeuge_Show_sYellow(sBetrag, true);
  EndHourGlass;
end;

procedure TFormBuchhalter.CheckBox6Click(Sender: TObject);
begin
  Erzeuge_Show_sYellow(sBetrag, false);
end;

procedure TFormBuchhalter.CheckBox7Click(Sender: TObject);
begin
  ensureTimerState;
end;

procedure TFormBuchhalter.CheckInitialized;
begin
  if not(Initialized) then
  begin

    ItemKontoAuszugRIDs := TgpIntegerList.Create;
    ItemKontoAuszugAll := TgpIntegerList.Create;
    ItemMarked := TgpIntegerList.Create;
    ItemDebiRIDs := TgpIntegerList.Create;

    // Konto
    with DrawGrid1, canvas do
    begin
      cPlanY := dpiX(16);
      DefaultRowHeight := cPlanY * 3;
      font.NAME := 'Courier New';
      font.color := clblack;
      ColCount := 8;
      ColWidths[0] := dpiX(25);
      // Status
      ColWidths[1] := dpiX(88); // Datum
      ColWidths[2] := dpiX(88); // Valuta
      ColWidths[3] := -dpiX(100); // Vorgang
      ColWidths[4] := -dpiX(230); // Text
      ColWidths[5] := dpiX(125); // Betrag Soll
      ColWidths[6] := dpiX(125); // Betrag Haben
      ColWidths[7] := 1; // Dummy
      RowCount := 0;
    end;
    dgAutoSize(DrawGrid1, true);

    // Eing‰nge
    with DrawGrid2, canvas do
    begin
      cPlanY := dpiX(16);
      DefaultRowHeight := cPlanY * 2;
      font.NAME := 'Courier New';
      font.color := clblack;
      ColCount := 8;
      ColWidths[0] := dpiX(25);
      // Status
      ColWidths[1] := dpiX(88); // Datum
      ColWidths[2] := dpiX(88); // Valuta
      ColWidths[3] := -dpiX(100); // Vorgang
      ColWidths[4] := -dpiX(230); // Text
      ColWidths[5] := dpiX(125); // Betrag Soll
      ColWidths[6] := dpiX(125); // Betrag Haben
      ColWidths[7] := 1; // Dummy
      RowCount := 0;
    end;
    dgAutoSize(DrawGrid2);

    with DrawGrid3, canvas do
    begin
      cPlanY := dpiX(16);
      DefaultRowHeight := cPlanY * 2;
      font.NAME := 'Courier New';
      font.color := clblack;
      ColCount := 5;
      ColWidths[0] := dpiX(25);
      // Status
      ColWidths[1] := -dpiX(500); // Name
      ColWidths[2] := -dpiX(190); // Vertragsdaten / Forderungen
      ColWidths[3] := dpiX(125); // Betrag
      ColWidths[4] := 1; // Dummy
      RowCount := 0;
    end;
    dgAutoSize(DrawGrid3);

    SetLength(StatusBMPs, 4);
    StatusBMPs[0] := CreateSymbol(0);
    StatusBMPs[1] := CreateSymbol(1);
    StatusBMPs[2] := CreateSymbol(2);
    StatusBMPs[3] := CreateSymbol(3);

    Initialized := true;
    PageControl1.ActivePage := TabSheet3;
  end;
end;

procedure TFormBuchhalter.RefreshKontoAuszugSaldo(saldo: double);
begin
  StaticText5.Caption := format('%m', [abs(saldo)]);
  if (saldo > cGeld_KleinsterBetrag) then
    StaticText5.color := cllime
  else
    StaticText5.color := clred;
end;

procedure TFormBuchhalter.setContext(RIDs: TgpIntegerList);
begin
  BeginHourGlass;
  show;
  PageControl1.ActivePage := TabSheet4;
  ItemKontoAuszugRIDs.Assign(RIDs);
  (*
    ItemKontoAuszugRIDs.clear;
    for n := 0 to pred(RIDs.count) do
    ItemKontoAuszugRIDs.add(RIDs[n]); *)
  ItemKontoAuszugRIDs.sort;
  with DrawGrid1 do
  begin
    RowCount := ItemKontoAuszugRIDs.count;
    Refresh;
    SecureSetRow(DrawGrid1, pred(RowCount));
  end;
  if (ItemKontoAuszugRIDs.count > 0) and (ItemKontoAuszugRIDs.count < 500) then
    RefreshKontoAuszugSaldo(e_r_sqld('select SUM(BETRAG) from BUCH where RID in ' + ListAsSQL(ItemKontoAuszugRIDs)))
  else
    RefreshKontoAuszugSaldo(0);
  EndHourGlass;
end;

procedure TFormBuchhalter.setContext(Konto: string; BELEG_R: Integer = -1);
begin
  //
  BeginHourGlass;
  show;
  PageControl1.ActivePage := TabSheet4;
  ComboBox1.Text := Konto;
  if (BELEG_R >= cRID_FirstValid) then
  begin
    Edit1.Text := 'BELEG' + inttostr(BELEG_R);
    RefreshKontoSearch;
    doSuche;
  end
  else
  begin
    RefreshKontoAuszug;
  end;
  EndHourGlass;
end;

procedure TFormBuchhalter.setContext(BUCH_R: Integer);
begin
  BeginHourGlass;
  show;
  PageControl1.ActivePage := TabSheet4;
  Edit1.Text := 'RID' + inttostr(BUCH_R);
  doSuche;
  EndHourGlass;
end;

procedure TFormBuchhalter.setDebiContext(s: TStrings; b: double; d: TAnfixDate);

  procedure addFoundListTo(const ItemDebiRIDs: TgpIntegerList);
  var
    PERSON_R: Integer;
    n: Integer;
  begin
    with DebiSearchIndex do
      for n := 0 to pred(FoundList.count) do
      begin
        PERSON_R := Integer(FoundList[n]);
        if (ItemDebiRIDs.IndexOf(PERSON_R) = -1) then
        begin
          ItemDebiRIDs.add(PERSON_R);
        end;
      end;
  end;

var
  KontoInhaber: string;
  RechnungsNummern: TStringList;
  BelegNummer: TStringList;
  BELEG_R: Integer;
  TEILLIEFERUNG: Integer;
  PERSON_R: Integer;
  BelegSaldo: double;
  KontoIBAN: string; // Kontonummer ODER IBAN

  // Treffer-Liste ...
  BetragPassend: TgpIntegerList;
  NamePassend: TgpIntegerList;
  n: Integer;
  cVERSAND: TIB_Cursor;

begin
  // label44.Caption := label44.caption + '*';
  isRose := false;
  isGreen := false;
  PERSON_R := cRID_Null;

  Disable_AusgleichCache;

  if Initialized then
  begin

    BeginHourGlass;
    if not(assigned(sBuchungsText)) then
      sBuchungsText := TStringList.Create
    else
      sBuchungsText.clear;

    if assigned(s) then
      sBuchungsText.addstrings(s);
    sBetrag := b;
    sDatum := d;

    ItemDebiRIDs.clear;
    if (sBuchungsText.count > 0) then
    begin
      repeat

        // ist es gar keine Person, sondern ein EINZUG
        if (sBuchungsText.IndexOf(cAnzeige_Vorgang_LSG + '=' + cIni_Activate) <> -1) then
        begin
          ItemDebiRIDs.add(cRID_Person_Lastschrift);
          isGreen := true;
          break;
        end;

        // ¸ber ~RechnungsNummer~
        // -> es wird nur nach ~BelegNummer~ "-" ~Teillieferung~ umgesetzt
        RechnungsNummern := b_r_Auszug_Rechnung(sBuchungsText);
        if (RechnungsNummern.count > 0) then
        begin
          cVERSAND := DataModuleDatenbank.nCursor;
          with cVERSAND do
          begin
            sql.add('select BELEG_R, TEILLIEFERUNG from VERSAND where');
            sql.add(' RECHNUNG in (' + HugeSingleLine(RechnungsNummern, ',') + ')');
            ApiFirst;
            while not(eof) do
            begin
              sBuchungsText.add(FieldByName('BELEG_R').AsString + '-' + inttostrN(FieldByName('TEILLIEFERUNG')
                .AsInteger, 2));
              ApiNext;
            end;
          end;
          cVERSAND.free;
        end;
        RechnungsNummern.free;

        // ¸ber ~BelegNummer~ "-" ~Teillieferung~
        BelegNummer := b_r_Auszug_BelegTeillieferung(sBuchungsText);
        if (BelegNummer.count > 0) then
        begin
          for n := 0 to pred(BelegNummer.count) do
          begin
            BELEG_R := StrToIntDef(nextp(BelegNummer[n], '-', 0), -1);
            TEILLIEFERUNG := StrToIntDef(nextp(BelegNummer[n], '-', 1), -1);
            BelegSaldo := e_r_BelegSaldo(BELEG_R, TEILLIEFERUNG);
            if isSomeMoney(BelegSaldo) then
            begin
              (*
                PERSON_R :=
                e_r_sql('select coalesce(RECHNUNGSANSCHRIFT_R,PERSON_R) from BELEG where RID='
                + inttostr(BELEG_R));
              *)
              PERSON_R := e_r_sql('select PERSON_R from BELEG where RID=' + inttostr(BELEG_R));
              if (PERSON_R >= cRID_FirstValid) then
                if (ItemDebiRIDs.IndexOf(PERSON_R) = -1) then
                begin
                  ItemDebiRIDs.add(PERSON_R);
                  if (ItemDebiRIDs.count = 1) then
                    if isequal(sBetrag, BelegSaldo) then
                      isGreen := true; // Volltreffer !
                end;
            end;
          end;
        end;
        BelegNummer.free;

        if isGreen then
          if not(mehrDebis) then
            break;

        if not(assigned(DebiSearchIndex)) then
        begin
          DebiSearchIndex := TWordIndex.Create(nil);
          DebiSearchIndex.LoadFromFile(SearchDir + 'Kunden.Suchindex');
        end
        else
        begin
          DebiSearchIndex.ReloadIfNew;
        end;

        with DebiSearchIndex do
        begin

          // direkt ¸ber die Namens-Zeile!
          KontoInhaber := PrepareForSearch(b_r_Auszug_Inhaber(sBuchungsText));

          // Bank-Worte entfernen
          ersetze(' UND ', ' ', KontoInhaber);
          ersetze(' ODER ', ' ', KontoInhaber);

          if (cutblank(KontoInhaber) <> '') then
          begin

            NamePassend := TgpIntegerList.Create;
            BetragPassend := TgpIntegerList.Create;
            repeat

              KontoIBAN := b_r_Auszug_KontoIBAN(sBuchungsText);

              // Volltreffer-Suche "Name" + "BLZ" + "Konto"
              search(
                { } KontoInhaber + ' ' +
                { } b_r_Auszug_BLZBIC(sBuchungsText) + ' ' +
                { } KontoIBAN);
              addFoundListTo(ItemDebiRIDs);

              // rein ¸ber die "alte" Bankverbindung
              if (pos('DE', KontoIBAN) = 1) then
              begin
                search(
                  { } IBAN_BLZ_Konto(KontoIBAN)
                  { } );
                addFoundListTo(ItemDebiRIDs);
              end;

              if (ItemDebiRIDs.count > 0) then
              begin

                // Volltreffer im ersten Datensatz?!
                if (e_r_sqls('select Z_ELV_BANK_NAME from PERSON ' + 'where RID=' + inttostr(ItemDebiRIDs[0]))
                  = cOrgaMonPrivat) then
                  isRose := true
                else
                  isGreen := true;
                if not(mehrDebis) then
                  break;
              end;

              // rein ¸ber den Namen
              search(KontoInhaber);
              addFoundListTo(NamePassend);

              KontoInhaber := cutblank(KontoInhaber);
              if (pos(',', b_r_Auszug_Inhaber(sBuchungsText)) > 0) then
              begin
                search(nextp(KontoInhaber, ' ', 0));
                addFoundListTo(NamePassend);
                search(nextp(KontoInhaber, ' ', 1));
                addFoundListTo(NamePassend);
              end
              else
              begin
                search(nextp(KontoInhaber, ' ', 1));
                addFoundListTo(NamePassend);
                search(nextp(KontoInhaber, ' ', 0));
                addFoundListTo(NamePassend);
              end;

              // die hinzu, bei denen 100% der offene Betrag stimmt
              e_r_sqlm(
                { } 'select KUNDE_R FROM' +
                { } ' AUSGANGSRECHNUNG ' +
                { } 'GROUP BY' +
                { } ' KUNDE_R ' +
                { } 'HAVING' +
                { } ' SUM(BETRAG) between ' +
                { } FloatToStrISO(sBetrag - cGeld_Schwellwert) + ' and ' +
                { } FloatToStrISO(sBetrag + cGeld_Schwellwert), BetragPassend);

              // alle vom Namen her passenden MIT passender Forderung
              for n := 0 to pred(NamePassend.count) do
                if (BetragPassend.IndexOf(NamePassend[n]) <> -1) then
                  if (ItemDebiRIDs.IndexOf(NamePassend[n]) = -1) then
                    ItemDebiRIDs.add(NamePassend[n]);

              // alle mit passendem Namen "ohne passende Forderung"
              for n := 0 to pred(NamePassend.count) do
                if (ItemDebiRIDs.IndexOf(NamePassend[n]) = -1) then
                  ItemDebiRIDs.add(NamePassend[n]);

              // alle ohne passenden Namen aber mit "passender Forderung"
              for n := 0 to pred(BetragPassend.count) do
                if (ItemDebiRIDs.IndexOf(BetragPassend[n]) = -1) then
                  ItemDebiRIDs.add(BetragPassend[n]);

            until true;

            NamePassend.free;
            BetragPassend.free;
            mehrDebis := false;
          end;
        end;
      until true;
    end;

    DrawGrid3.RowCount := ItemDebiRIDs.count;
    DrawGrid3.Row := 0;
    if (ItemDebiRIDs.count = 0) then
    begin
      Erzeuge_sForderungen(cRID_Null);
      Erzeuge_Show_sYellow(sBetrag, false);
      Draw_PersonSaldo(0);
    end;
    DrawGrid3.Refresh;

    repeat

      if isGreen then
      begin
        Panel2.color := iColor_Gruen;
        break;
      end;
      if isRose then
      begin
        Panel2.color := iColor_Rosa;
        break;
      end;
      Panel2.color := clBtnFace;
    until true;
    EndHourGlass;
  end;
end;

procedure TFormBuchhalter.setIdentitaetGruen(PERSON_R: Integer);
var
  sBUCHUNGSTEXTE: TStringList;
  BUCH_R: Integer;
begin
  // Personen Identit‰t eintragen!
  BUCH_R := rBUCH_R;

  if (BUCH_R >= cRID_FirstValid) and (PERSON_R >= cRID_FirstValid) then
  begin

    //
    sBUCHUNGSTEXTE := e_r_sqlt('select TEXT from BUCH where RID=' + inttostr(BUCH_R));

    //
    e_x_sql('update PERSON set ' +
      { } ' Z_ELV_KONTO_INHABER=''' + b_r_Auszug_Inhaber(sBUCHUNGSTEXTE) + ''', ' +
      { } ' Z_ELV_BLZ=''' + b_r_Auszug_BLZBIC(sBUCHUNGSTEXTE) + ''', ' +
      { } ' Z_ELV_KONTO=''' + b_r_Auszug_KontoIBAN(sBUCHUNGSTEXTE) + ''' ' + 'where' + ' RID=' + inttostr(PERSON_R));

    e_x_sql('update PERSON set ' + ' Z_ELV_BANK_NAME=null ' + 'where' + ' (RID=' + inttostr(PERSON_R) + ') and' +
      ' (Z_ELV_BANK_NAME=''' + cOrgaMonPrivat + ''')');

    sBUCHUNGSTEXTE.free;
    DrawGrid3.Refresh;

  end;

end;

procedure TFormBuchhalter.setIdentitaetRosa(PERSON_R: Integer);
var
  sBUCHUNGSTEXTE: TStringList;
  BUCH_R: Integer;
begin
  // Personen Identit‰t eintragen!
  BUCH_R := rBUCH_R;

  if (BUCH_R >= cRID_FirstValid) and (PERSON_R >= cRID_FirstValid) then
  begin
    //
    sBUCHUNGSTEXTE := e_r_sqlt('select TEXT from BUCH where RID=' + inttostr(BUCH_R));

    //
    e_x_sql('update PERSON set ' +
      { } ' Z_ELV_KONTO_INHABER=''' + b_r_Auszug_Inhaber(sBUCHUNGSTEXTE) + ''', ' +
      { } ' Z_ELV_BANK_NAME=''' + cOrgaMonPrivat + ''', ' +
      { } ' Z_ELV_BLZ=''' + b_r_Auszug_BLZBIC(sBUCHUNGSTEXTE) + ''', ' +
      { } ' Z_ELV_KONTO=''' + b_r_Auszug_KontoIBAN(sBUCHUNGSTEXTE) + ''' ' +
      { } 'where' + ' RID=' + inttostr(PERSON_R));

    sBUCHUNGSTEXTE.free;
    DrawGrid3.Refresh;

  end;

end;

procedure TFormBuchhalter.RefreshKontoCombos;
var
  AlleKonten: TStringList;
  OldEntryIndex: Integer;
begin
  BeginHourGlass;

  // ComboBox1: Alle Konten auflisten
  AlleKonten := e_r_sqlsl('select distinct NAME from BUCH where' + ' (NAME is not null) and' + ' (NAME<>'''') and' +
    ' (BETRAG is not null)');
  AlleKonten.sort;
  AlleKonten.insert(0, '');
  AlleKonten.add('*');
  AlleKonten.add(cKonto_Deckblatt);
  AlleKonten.add(cKonto_Ungebucht);
  OldEntryIndex := AlleKonten.IndexOf(ComboBox1.Text);
  ComboBox1.Items.Assign(AlleKonten);
  if (OldEntryIndex <> -1) then
    ComboBox1.ItemIndex := OldEntryIndex
  else
    ComboBox1.ItemIndex := 0;
  AlleKonten.free;

  EndHourGlass;
end;

procedure TFormBuchhalter.RefreshAusgleichCombos;
var
  AlleKonten: TStringList;
  OldEntryIndex: Integer;
begin
  BeginHourGlass;

  // ComboBox2: Nur Eingangskonten auflisten
  AlleKonten := b_r_AusgleichKonten;
  AlleKonten.sort;
  AlleKonten.insert(0, '');
  AlleKonten.add('*');
  OldEntryIndex := AlleKonten.IndexOf(ComboBox2.Text);
  ComboBox2.Items.Assign(AlleKonten);
  if (OldEntryIndex <> -1) then
    ComboBox2.ItemIndex := OldEntryIndex
  else
    ComboBox2.ItemIndex := 0;
  AlleKonten.free;

  EndHourGlass;
end;

procedure TFormBuchhalter.RefreshKontoSearch;
var
  si: TWordIndex;
  sBuchText: TStringList;
  sBemerkungText: TStringList;
  cBUCH: TIB_Cursor;
  VORGANG: String;
begin
  BeginHourGlass;
  cBUCH := DataModuleDatenbank.nCursor;
  sBuchText := TStringList.Create;
  sBemerkungText := TStringList.Create;
  si := TWordIndex.Create(nil);

  // aktuellen Suchindex auf alle F‰lle freigeben!
  if assigned(KontoAuszugIndex) then
    FreeAndNil(KontoAuszugIndex);

  with cBUCH do
  begin
    sql.add('select RID, TEXT, BEMERKUNG, BETRAG, NAME,');
    sql.Add('STEMPEL_R, STEMPEL_DOKUMENT, IBAN, VORGANG, ');
    sql.Add('BAUSTELLE_R, BUGET_R, ');
    sql.add('KONTO, GEGENKONTO, BELEG_R, EREIGNIS_R from BUCH where');
    sql.addstrings(getSQLwhere);
    ApiFirst;
    while not(eof) do
    begin
      FieldByName('TEXT').AssignTo(sBuchText);
      if FieldByName('EREIGNIS_R').IsNotNull then
        sBuchText.add('E' + FieldByName('EREIGNIS_R').AsString);
      if FieldByName('VORGANG').IsNotNull then
      begin
        VORGANG := FieldByName('VORGANG').AsString;
        repeat

          if b_r_Abschluss(VORGANG) then
          begin
            sBuchText.add(cAnzeige_Vorgang_ABSCHLUSS);
            break;
          end;

          if b_r_GutschriftAusLS(VORGANG) then
          begin
            sBuchText.add(cAnzeige_Vorgang_LSG);
            break;
          end;

          sBuchText.add(StrFilter(VORGANG,cBuchstaben+cZiffern));
        until yet;
      end;
      FieldByName('BEMERKUNG').AssignTo(sBemerkungText);
      si.addwords(
        { } HugeSingleLine(sBuchText, ' ') + ' ' +
        { } HugeSingleLine(sBemerkungText, ' ') + ' ' +
        { } 'B' + inttostr(round(abs(FieldByName('BETRAG').AsDouble * 100.0))) + ' ' +
        { } 'K' + FieldByName('NAME').AsString + ' ' +
        { } FieldByName('KONTO').AsString + ' ' +
        { } 'G' + FieldByName('GEGENKONTO').AsString + ' ' +
        { } FieldByName('IBAN').AsString + ' ' +
        { } 'BELEG' + FieldByName('BELEG_R').AsString + ' ' +
        { } 'A' + FieldByName('BAUSTELLE_R').AsString + ' ' +
        { } 'U' + FieldByName('BUGET_R').AsString + ' ' +
        { } b_r_Stempel(FieldbyName('STEMPEL_R').AsInteger)+FieldByName('STEMPEL_DOKUMENT').AsString,
        { } pointer(FieldByName('RID').AsInteger));
      ApiNext;
    end;
  end;

  //
  si.JoinDuplicates(false);
  si.savetofile(b_r_KontoSuchindexFName(ComboBox1.Text));
  sBuchText.free;
  sBemerkungText.free;
  cBUCH.free;
  si.free;
  EndHourGlass;
end;

procedure TFormBuchhalter.RefreshLastschriften;
begin
  BeginHourGlass;
  IB_Query1.Refresh;
  EndHourGlass;
end;

procedure TFormBuchhalter.RefreshNeueEingaenge;
begin
  BeginHourGlass;
  Disable_AusgleichCache;
  Disable_DebiCache;
  SyncNeueEingaenge;
  IB_Cursor1.Refresh;
  DrawGrid2.Refresh;
  if (ItemKontoAuszugRIDs.count > 0) then
    SecureSetRow(DrawGrid2, 0)
  else
    setDebiContext;
  SetFocus;
  DrawGrid2.SetFocus;
  EndHourGlass;
end;

procedure TFormBuchhalter.Draw_NeueEingaengeSaldo(saldo: double);
begin
  Label45.Caption := inttostr(DrawGrid2.RowCount);
  StaticText1.Caption := format('%m', [abs(saldo)]);
  if (saldo > cGeld_KleinsterBetrag) then
    StaticText1.color := cllime
  else
    StaticText1.color := clred;
  NeueEingaengeSaldo := saldo;
end;

procedure TFormBuchhalter.Draw_PersonSaldo(saldo: double);
begin
  StaticText2.Caption := format('%m', [abs(saldo)]);
  if (saldo > cGeld_KleinsterBetrag) then
    StaticText2.color := cllime
  else
    StaticText2.color := clred;
end;

function TFormBuchhalter.rERRORs: Integer;
var
  n: Integer;
begin
  result := 0;
  for n := 0 to pred(sAusgleich.count) do
    if (nextp(sAusgleich[n], ';', 5) <> '') then
      inc(result);
end;

function TFormBuchhalter.rPERSON_R: Integer;
begin
  if (ItemDebiRIDs.count > 0) then
    result := ItemDebiRIDs[DrawGrid3.Row]
  else
    result := cRID_Null;
end;

procedure TFormBuchhalter.SpeedButton40Click(Sender: TObject);
begin
  openShell(MyProgramPath + cHBCIPath);
end;

procedure TFormBuchhalter.SpeedButton41Click(Sender: TObject);

  function split(s: string; Delimiter: string): TStringList;
  const
    cQuote = '"';
  var
    k: Integer;
  begin
    result := TStringList.Create;
    while (s <> '') do
    begin

      if (s[1] = cQuote) then
      begin
        Delete(s, 1, 1);
        k := pos(cQuote, s);
        result.add(copy(s, 1, pred(k)));
        Delete(s, 1, k);
        k := pos(Delimiter, s);
        if (k > 0) then
          Delete(s, 1, k);
        continue;
      end;

      if (s[1] = Delimiter) then
      begin
        Delete(s, 1, 1);
        result.add('');
        continue;
      end;

      k := pos(Delimiter, s);
      if (k > 0) then
      begin
        result.add(copy(s, 1, pred(k)));
        Delete(s, 1, k);
      end
      else
      begin
        result.add(s);
        break;
      end;

    end;
  end;

  function fmBLZ(s: string): string;
  begin
    result := StrFilter(s, '0123456789');
  end;

  function fmKonto(s: string): string;
  begin
    result := int64tostr(strtoint64(s));
  end;

  function fmBetrag(s: string): string;
  begin
    result := inttostr(round(strtodouble(s) * 100.0));
  end;

  procedure Load(sDTA: TStringList; FName: string);
  var
    n: Integer;
    sLine: TStringList;
  begin
    sDTA.LoadFromFile(FName);
    if (pos('RID;', sDTA[0]) = 1) then
    begin
      for n := 1 to pred(sDTA.count) do
      begin
        sLine := split(sDTA[n], ';');
        if (sLine.count > 3) then
          sDTA[n] :=
          { BLZ } fmBLZ(sLine[3]) + ';' +
          { Konto } fmKonto(sLine[4]) + ';' +
          { Betrag } fmBetrag(sLine[5]) + ';' + '"' + sLine[1] + '"';
        sLine.free;
      end;
    end
    else
    begin
      for n := 1 to pred(sDTA.count) do
      begin
        sLine := split(sDTA[n], ',');
        if (sLine.count > 3) then
          sDTA[n] :=
          { BLZ } fmBLZ(sLine[2]) + ';' +
          { Konto } fmKonto(sLine[3]) + ';' +
          { Betrag } fmBetrag(sLine[4]) + ';' + '"' + sLine[0] + '"';
        sLine.free;
      end;
    end;
    sDTA[0] := 'BLZ;Konto;Betrag;Name';
  end;

var
  sCSV: TStringList;
  Subs: TStringList;
  n: Integer;
  DTAlog: TStringList;

begin

  //
  sCSV := TStringList.Create;
  sCSV.LoadFromFile(MyProgramPath + cHBCIPath + Edit4.Text);

  with DTA_Header do
  begin
    FName := DiagnosePath + 'DTAUS-GK.DTA';
    BankName := iKontoBankName;
    BLZ := StrFilter(iKontoBLZ, cZiffern);
    ktonr := StrFilter(iKontoNummer, cZiffern);
    KontoInhaberName := iKontoInhaber;
    KontoInhaberOrt := '';
    Lastschrift := false;
  end;

  DtaOpen(DTA_Header);

  for n := 1 to pred(sCSV.count) do
    if pos(';', sCSV[n]) > 0 then
    begin

      Subs := split(sCSV[n], ';');
      while (Subs.count < 10) do
        Subs.add('');
      with DTA_Posten do
      begin
        RID := StrToIntDef(Subs[0], cRID_Null);
        zahlerName := Subs[1];
        zahlerOrt := Subs[2];
        BLZ := Subs[3];
        ktonr := Subs[4];
        Betrag := StrToDoubledef(Subs[5], 0);
        VZweck[1] := Subs[6];
        VZweck[2] := Subs[7];
        VZweck[3] := Subs[8];
        VZweck[4] := Subs[9];
        VZweck[5] := '';
        VZweck[6] := '';
        VZweck[7] := '';
        // Datums bisher noch automatisch
        MandatsDatum := cDTA_DatumAutomatisch;
        AusfuehrungsDatum := cDTA_DatumAutomatisch;

      end;
      Subs.free;

      DtaPut(DTA_Posten);
    end;

  DTAlog := DtaClose;
  ShowMessage(HugeSingleLine(DTAlog));
  sCSV.free;
  DTAlog.free;
end;

procedure TFormBuchhalter.SpeedButton42Click(Sender: TObject);
begin
  // sicherstellen dass es existiert
  if not(assigned(sForderungenFixed)) then
    sForderungenFixed := TStringList.Create;

  // diese Forderungen hinzuf¸gen
  if (sForderungen.count > 0) then
    if (sForderungenFixed.IndexOf(sForderungen[0]) = -1) then
    begin
      sForderungenFixed.add(sForderungen[0]);
      ShowMessage(sForderungen[0] + #13 + #13 + 'ist nun fixiert!');
    end;

end;

procedure TFormBuchhalter.SpeedButton43Click(Sender: TObject);
begin
  // Disable control
  Edit14.enabled := false;

  // proceed
  BeginHourGlass;
  b_w_ForderungAusgleichStorno(StrToIntDef(Edit14.Text, cRID_Null));
  Edit14.Text := '';
  Edit14.enabled := true;
  EndHourGlass;
end;

procedure TFormBuchhalter.SpeedButton44Click(Sender: TObject);
var
  EREIGNIS_R: Integer;
begin
  EREIGNIS_R := IB_Query2.FieldByName('RID').AsInteger;
  if (EREIGNIS_R < cRID_FirstValid) then
  begin
    ShowMessage('Es gibt nichts zu buchen');
    exit;
  end;

  if doit(
   {} 'Wurde diese Sammellastschrift' + #13 +
   {} 'nicht erfolgreich durchgef¸hrt?' + #13 +
   {} 'Kann dieser Eintrag - ohne jede weitere Aktion - gelˆscht werden') then
  begin
    BeginHourGlass;
    e_w_HBCI_EreignisDel(EREIGNIS_R, 'nicht erfolgreich ausgef¸hrt!');
    IB_Query2.Refresh;
    EndHourGlass;
  end;
end;

procedure TFormBuchhalter.SpeedButton45Click(Sender: TObject);
var
  EREIGNIS_R: Integer;
begin

  EREIGNIS_R := IB_Query2.FieldByName('RID').AsInteger;
  if (EREIGNIS_R >= cRID_FirstValid) then
  begin
    if doit('Soll dieses Sammellastschriftvolumen wieder aktiv gestellt werden') then
    begin
      BeginHourGlass;

      // alle Buchungen bei der Lastschrift wieder sichtbar machen
      e_x_sql(
        { } 'update AUSGANGSRECHNUNG set EREIGNIS_R=' +
        { } 'null ' +
        { } 'where EREIGNIS_R=' +
        { } inttostr(EREIGNIS_R));

      // das Ereignis selbst verschwinden lassen abschliessen
      e_w_HBCI_EreignisDel(EREIGNIS_R, 'Wiederholung angefordert!');
      IB_Query2.Refresh;

      EndHourGlass;
    end;
  end;

end;

procedure TFormBuchhalter.SpeedButton46Click(Sender: TObject);
begin
  if assigned(sForderungenFixed) then
    sForderungenFixed.clear;
  RefreshForderungen;
end;

procedure TFormBuchhalter.SpeedButton47Click(Sender: TObject);
begin
  // Zahlung als Anzahlung f¸r Zuk¸nftige Belege verbuchen
  ShowMessage('Noch nicht implementiert');
end;

procedure TFormBuchhalter.SpeedButton48Click(Sender: TObject);
var
  EREIGNIS_R: Integer;
  FName: string;
begin
  EREIGNIS_R := IB_Query2.FieldByName('RID').AsInteger;
  FName := MyProgramPath + cHBCIPath + 'DTAUS-' + inttostrN(EREIGNIS_R, 8) + '.csv';
  if FileExists(FName) then
    openShell(FName)
  else
    ShowMessage('Dazu gibt es keine Liste');
end;

procedure TFormBuchhalter.SpeedButton49Click(Sender: TObject);

var
 AlleDokumente : TStringList;
 AllePersonenVerzeichnisse : TStringList;

 procedure addFiles(Mask:String);
 var
  n,m : integer;
  FoundFiles : TStringList;
 begin
  FoundFiles := TStringList.create;
  for n := 0 to pred(AllePersonenVerzeichnisse.Count) do
  begin
   dir( MyProgramPath + cRechnungPath + AllePersonenVerzeichnisse[n] + '\' + Mask + '*.pdf', FoundFiles);
   if (FoundFiles.Count>0) then
    for m := 0 to pred(FoundFiles.count) do
      AlleDokumente.add(AllePersonenVerzeichnisse[n]+'\'+FoundFiles[m]);
  end;
 end;

 function DokumentVerzeichnis_PERSON_R(Dir: string):Integer;
 begin
   result := StrToIntDef(copy(Dir,1,10),0);
 end;

var
 Stempel_SQL : TStringList;
 lSTEMPEL_R : TgpIntegerList;
 sSTEMPEL : TStringList;
 n : integer;
 cBUCH: TdboCursor;
 STEMPEL : string;
 UpDate_PERSON_R : boolean;
 PERSON_R_IST : integer;
 PERSON_R_SOLL : integer;
 BUCH_R : Integer;
 ToDoList: TStringList;
 FoundDokument: boolean;
 DATUM, _DATUM: TANFiXDate;

begin
  BeginHourGlass;
  if ToDoMode then
   SpeedButton50Click(Sender);

  ToDoList := TStringList.create;
  ToDoList.add('BUCH_R;TODO;DATUM');
  // berechne alle PDF Zuordnungen

  // 1) sammle alle Datei-Masken (Stempel-Prefixe), ER, AR
  Stempel_SQL := TStringList.create;
  with Stempel_SQL do
  begin
    add('select distinct STEMPEL_R from BUCH');
    add('where');
    add(' (STEMPEL_R is not null) and');
    addstrings(getSQLwhere);
  end;
  lSTEMPEL_R := e_r_sqlm(Stempel_SQL.Text);
  sSTEMPEL := e_r_sqlsl('select PREFIX from STEMPEL where RID in '+ ListasSQL(lSTEMPEL_R));

  // 2) sammle alle Unterverzeichnisse, in denen Dokumente liegen
  AllePersonenVerzeichnisse := TStringList.Create;
  dir(MyProgramPath + cRechnungPath + cDirMask_Directory,  AllePersonenVerzeichnisse);

  // 3) sammle alle Dokumente
  AlleDokumente := TStringList.create;
  for n := 0 to pred(sSTEMPEL.Count) do
   addFiles(sSTEMPEL[n]+'-');

  if DebugMode then
   AlleDokumente.SaveToFile(DiagnosePath+'Stempel-Dokumente.txt');

  // 4) gehe alle Buchungen durch und sehe nach, ob es ein Dokument dazu gibt
  _DATUM := cIllegalDate;
  cBUCH := nCursor;
  with cBUCH do
  begin
    sql.add('select * from BUCH where');
    sql.Add(' (STEMPEL_R is not null) and ');
    sql.Add(' (GEGENKONTO <> ''1590'') and ');
    sql.Add(' ((BUGET_R is null) or (BUGET_R <> 0)) and ');
    sql.addstrings(getSQLwhere);
    sql.Add('order by');
    sql.Add(' DATUM descending,');
    sql.Add(' POSNO descending');
    open;
    ApiFirst;
    while not(eof) do
    begin
      UpDate_PERSON_R := FieldByName('PERSON_R').IsNull;
      PERSON_R_SOLL := FieldByName('PERSON_R').AsInteger;
      BUCH_R := FieldByName('RID').AsInteger;
      STEMPEL := b_r_Stempel(FieldByName('STEMPEL_R').AsInteger) + '-' + FieldByName('STEMPEL_DOKUMENT').AsString;
      DATUM := DateTime2Long(FieldByName('DATUM').AsDateTime);
      repeat
       FoundDokument := false;
       for n := 0 to pred(AlleDokumente.Count) do
        if b_r_Stempel_CheckFile(STEMPEL,AlleDokumente[n]) then
        begin
          PERSON_R_IST := DokumentVerzeichnis_PERSON_R(AlleDokumente[n]);
          FoundDokument := true;
          if UpDate_PERSON_R then
          begin
           { Action: set BUCH.PERSON_R from NULL to Value }
           e_x_sql('update BUCH set PERSON_R='+inttostr(PERSON_R_IST)+' where RID='+inttostr(BUCH_R));
           UpDate_PERSON_R := false;
           PERSON_R_SOLL := PERSON_R_IST;
          end;
          if (PERSON_R_IST<>PERSON_R_SOLL) then
          begin
           { Warn: Document is misplaced }
           ToDoList.Add(
            { } IntToStr(BUCH_R)+';'+
            { } 'Dokument ist in falschem Verzeichnis (IST='+IntTOstr(PERSON_R_IST)+', SOLL='+INtTostr(PERSON_R_SOLL)+')'+';'+
            { } Long2Date(DATUM));
          end;
        end;
       if not(FoundDokument) then
        { Warn: Document is missing }
        ToDoList.Add(
         { } IntTostr(BUCH_R)+';'+
         { } 'Dokument '+STEMPEL+' ist nicht vorhanden'+';'+
         { } Long2Date(DATUM));
      until yet;
      ApiNext;
    end;
  end;

  ToDoList.SaveToFile(DiagnosePath+'ToDo-Buch.txt');
  openShell(DiagnosePath+'ToDo-Buch.txt');
  Stempel_SQL.Free;
  lSTEMPEL_R.Free;
  sSTEMPEL.Free;
  AllePersonenVerzeichnisse.Free;
  ToDoList.Free;
  SpeedButton50Click(Sender);
  EndHourGlass;
end;

procedure TFormBuchhalter.SpeedButton4Click(Sender: TObject);
begin
  RefreshKontoCombos;
end;

procedure TFormBuchhalter.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet4;
  iColor_Rosa := HTMLColor2TColor(cColor_Rosa);
  iColor_Gruen := HTMLColor2TColor(cColor_Gruen);
  iColor_Braun := HTMLColor2TColor(cColor_Braun);
  iColor_Rot := HTMLColor2TColor(cColor_Rot);
end;

function TFormBuchhalter.getSQLwhere: TStringList;
begin

  if not(assigned(sSQLwhere)) then
    sSQLwhere := TStringList.Create
  else
    sSQLwhere.clear;
  result := sSQLwhere;

  if (ComboBox1.Text = cKonto_Deckblatt) then
    result.add(' (BETRAG is null)')
  else
    result.add(' (BETRAG is not null)');

  // den Buchungsfokus ber¸cksichtigen ...
  if DateOK(iBuchFokus) and (ComboBox1.Text <> cKonto_Deckblatt) then
    result.add(' and (DATUM >= ''' + long2date(iBuchFokus) + ''')');

  repeat

    if (ComboBox1.Text = '') then
    begin
      result.add(' and (null=null)');
      break;
    end;

    if (ComboBox1.Text = cKonto_Ungebucht) then
    begin
      result.add(' and (RID=MASTER_R)');
      result.add(' and (GEGENKONTO is not null)');
      result.add(' and (GEBUCHT is null)');
      break;
    end;

    if (ComboBox1.Text <> '*') and (ComboBox1.Text <> cKonto_Deckblatt) then
    begin
      result.add(' and (NAME=''' + ComboBox1.Text + ''')');
    end;
  until true;
end;

procedure TFormBuchhalter.hideForderung;
var
  k: Integer;
begin
  k := ItemKontoAuszugRIDs.IndexOf(BUCH_R);
  if (k <> -1) then
  begin
    Disable_AusgleichCache;
    Disable_DebiCache;
    ItemKontoAuszugRIDs.Delete(k);
    DrawGrid2.RowCount := ItemKontoAuszugRIDs.count;
    Draw_NeueEingaengeSaldo(0);
    DrawGrid2.Refresh;
    if (ItemKontoAuszugRIDs.count = 0) then
      setDebiContext;
  end;
end;

function TFormBuchhalter.getActiveGrid: TDrawGrid;
begin
    // welches Control?
    repeat
      if (PageControl1.ActivePage=TabSheet4) then
      begin
        result := DrawGrid1;
        break;
      end;
      if (PageControl1.ActivePage=TabSheet5) then
      begin
        result := DrawGrid2;
        break;
      end;
      result := nil;
    until yet;
end;

procedure TFormBuchhalter.SetColorAndAccount(ParamValue:string);
var
  BUCH_R: Integer;
  dg : TDrawGrid;
  EINGABE, BAUSTELLE_R, BUDGET_R : string;
begin
  BUCH_R := SetScriptValue('COLOR', ParamValue);
  if (BUCH_R >= cRID_FirstValid) then
  begin
    if (Edit7.Text <> '') then
    begin
      EINGABE := Edit7.Text;

      if (pos('@',EINGABE)>0) then
      begin
       BUDGET_R := nextp(EINGABE,'@',1);
       EINGABE := nextp(EINGABE,'@');
       e_x_sql('update BUCH set BUGET_R=' + BUDGET_R + ' where RID=' + inttostr(BUCH_R));
      end;

      if (pos('#',EINGABE)>0) then
      begin
       BAUSTELLE_R := nextp(EINGABE,'#',1);
       EINGABE := nextp(EINGABE,'#');
       e_x_sql('update BUCH set BAUSTELLE_R=' + BAUSTELLE_R + ' where RID=' + inttostr(BUCH_R));
      end;

      if (EINGABE<>'') then
       e_x_sql('update BUCH set GEGENKONTO=''' + EINGABE + ''' where RID=' + inttostr(BUCH_R));

      FormBuchung.doBuche(BUCH_R);
    end;
    dg := getActiveGrid;
     if assigned(dg) then
      nextRow(dg);
  end;
end;

procedure TFormBuchhalter.SpeedButton7Click(Sender: TObject);
begin
  SetColorAndAccount(cColor_Gruen);
end;

procedure TFormBuchhalter.SpeedButton8Click(Sender: TObject);
begin
  SetColorAndAccount(cColor_Rosa);
end;

procedure TFormBuchhalter.SpeedButton6Click(Sender: TObject);
begin
  SetColorAndAccount(cColor_Braun);
end;

procedure TFormBuchhalter.SpeedButton50Click(Sender: TObject);
var
  sOLAPFName: TStringList;
  n: Integer;
begin
  // RID-Liste aus TO-DO-Laden!
  if ToDoMode then
  begin
    ToDoMode := false;
    label27.Caption := '-';
    if assigned(ToDoList) then
     FreeAndNil(ToDoList);
  end else
  begin
    BeginHourGlass;
    ToDoMode := true;
    sOLAPFName := TStringList.Create;
    ItemKontoAuszugRIDs.clear;
    sOLAPFName.LoadFromFile(DiagnosePath+'ToDo-Buch.txt');
    for n := 1 to pred(sOLAPFName.count) do
      ItemKontoAuszugRIDs.add(StrToIntDef(nextp(sOLAPFName[n],';',0), cRID_Null));
    sOLAPFName.free;
    DrawGrid1.RowCount := ItemKontoAuszugRIDs.count;
    RefreshKontoAuszugSaldo(0);
    if (ItemKontoAuszugRIDs.count > 0) then
      SecureSetRow(DrawGrid1, pred(ItemKontoAuszugRIDs.count));
    EndHourGlass;
  end;
end;

procedure TFormBuchhalter.SpeedButton51Click(Sender: TObject);
var
 ClientSorter : TStringList;
 _sForderungen : TStringList;
 n : Integer;
begin

 // sort
 if (sForderungen.Count>1) then
 begin
   ClientSorter := TStringList.create;
   for n := 0 to pred(sForderungen.count) do
    ClientSorter.addObject( nextp(sForderungen[n],';',0), Pointer(n));
   ClientSorter.sort;
   _sForderungen := TStringList.create;
   for n := 0 to pred(CLientSorter.count) do
    _sForderungen.add(SForderungen[Integer(ClientSorter.Objects[n])]);
   ClientSorter.Free;
   FreeAndNil(sForderungen);
   sForderungen := _sForderungen;
 end;

 // show
 Erzeuge_Show_sYellow(sBetrag, true);

end;

procedure TFormBuchhalter.SpeedButton52Click(Sender: TObject);
var
  EREIGNIS_R: Integer;
begin
  EREIGNIS_R := IB_Query2.FieldByName('RID').AsInteger;
  if (EREIGNIS_R < cRID_FirstValid) then
  begin
    ShowMessage('Es gibt nichts zu buchen');
    exit;
  end;

  if doit(
   {} 'Wurde diese Sammellastschrift' + #13+
   {} 'erfolgreich durchgef¸hrt, und anderweitig verbucht?' + #13 +
   {} 'Kann dieser Eintrag - ohne jede weitere Aktion - als erledigt betrachtet werden') then
  begin
    BeginHourGlass;
    e_w_HBCI_EreignisDel(EREIGNIS_R, 'anderweitig erfolgreich ausgef¸hrt!');
    IB_Query2.Refresh;
    EndHourGlass;
  end;

end;

procedure TFormBuchhalter.SpeedButton5Click(Sender: TObject);
begin
  SetColorAndAccount(cColor_Rot);
end;

procedure TFormBuchhalter.SpeedButton9Click(Sender: TObject);
begin
  SetColorAndAccount('');
end;

function TFormBuchhalter.SetScriptValue(ParamName, ParamValue: string): Integer;
var
  qBUCH: TIB_Query;
  BUCH_R: Integer;
  ScriptText: TStringList;
  dg: TDrawGrid;
begin
  result := cRID_Unset;
  if (ItemKontoAuszugRIDs.count > 0) then
  begin

    dg := getActiveGrid;

    // Suche hat geklappt?
    if not(assigned(dg)) then
    begin
      ShowMessage('Es kann nicht ermittelt werden auf welche Tabelle sich die Skript-ƒnderung bezieht');
      exit;
    end;

    // Datensatz ermitteln
    with dg do
      BUCH_R := Integer(ItemKontoAuszugRIDs[Row]);

    //
    qBUCH := DataModuleDatenbank.nQuery;
    with qBUCH do
    begin
      sql.add('select SKRIPT from BUCH');
      sql.add('where RID=' + inttostr(BUCH_R));
      sql.add('for update');
      open;
      first;
      if not(eof) then
      begin
        IB_Cursor1.close;
        ScriptText := TStringList.Create;
        FieldByName('SKRIPT').AssignTo(ScriptText);
        ScriptText.values[ParamName] := ParamValue;

        edit;
        FieldByName('SKRIPT').Assign(ScriptText);
        ScriptText.free;
        post;
      end;
    end;
    qBUCH.free;
    dg.Refresh;
    //
    result := BUCH_R;
  end;
end;

procedure TFormBuchhalter.showBeleg(ForderungINdex: Integer);
var
  sLine: string;
  PERSON_R: Integer;
  BELEG_R: Integer;
  TEILLIEFERUNG: Integer;
  FName: string;
begin
  sLine := sForderungen[ForderungINdex];
  BELEG_R := StrToIntDef(nextp(sLine, ';', 2), cRID_Null);
  TEILLIEFERUNG := StrToIntDef(nextp(sLine, ';', 3), cRID_Null);
  PERSON_R := e_r_sql('select PERSON_R from BELEG where RID=' + inttostr(BELEG_R));
  FName := e_r_BelegFName(PERSON_R, BELEG_R, TEILLIEFERUNG);
  if FileExists(FName) then
    openShell(FName)
  else
    ShowMessage(FName + #13 + 'nicht gefunden!');
  BelegMode := false;
  Button22.Caption := 'ù';
end;

end.
