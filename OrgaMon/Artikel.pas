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
unit Artikel;

// {$IFDEF OrgaMonServer}
// {$Message Error 'Someone uses "Artikel" in Server-Mode!'}
// {$ENDIF}

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, Grids,
  ExtCtrls, StdCtrls, ComCtrls,
  Mask, Buttons,

  // IBObjects
  IB_Access,
  IB_Grid,
  IB_Components,
  IB_NavigationBar,
  IB_Controls,
  IB_UpdateBar,
  IB_DatasetBar,
  IB_SearchBar,
  IB_LocateEdit,

  // Tools
  WordIndex,
  JvGIF,
  FlexCel.Core, FlexCel.xlsadapter,
  dbOrgaMon,

  // Hebu-Project
  Datenbank, IB_EditButton, JvComponentBase, JvFormPlacement;

type
  TFormArtikel = class(TForm)
    IB_Grid1: TIB_Grid;
    IB_DataSource1: TIB_DataSource;
    IB_Query1: TIB_Query;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    Edit1: TEdit;
    IB_Query5: TIB_Query;
    Button18: TButton;
    IB_Query6: TIB_Query;
    IB_Query7: TIB_Query;
    IB_Query8: TIB_Query;
    ComboBox1: TComboBox;
    IB_Query9: TIB_Query;
    ComboBox2: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    ComboBox3: TComboBox;
    IB_Query10: TIB_Query;
    IB_Query11: TIB_Query;
    IB_Query12: TIB_Query;
    Label5: TLabel;
    IB_Text1: TIB_Text;
    IB_Date1: TIB_Date;
    Label10: TLabel;
    Label11: TLabel;
    Button15: TButton;
    Label12: TLabel;
    Label13: TLabel;
    IB_ComboBox1: TIB_ComboBox;
    Label14: TLabel;
    IB_ComboBox2: TIB_ComboBox;
    Label15: TLabel;
    Button7: TButton;
    Label9: TLabel;
    Label16: TLabel;
    TabSheet3: TTabSheet;
    TabSheet5: TTabSheet;
    IB_Memo1: TIB_Memo;
    IB_Grid2: TIB_Grid;
    Button9: TButton;
    Button19: TButton;
    IB_UpdateBar2: TIB_UpdateBar;
    IB_Query13: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    Label17: TLabel;
    Edit2: TEdit;
    IB_Edit1: TIB_Edit;
    IB_Edit2: TIB_Edit;
    Label8: TLabel;
    Label18: TLabel;
    IB_ComboBox3: TIB_ComboBox;
    IB_ComboBox4: TIB_ComboBox;
    IB_ComboBox5: TIB_ComboBox;
    Label19: TLabel;
    Label20: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    Image2: TImage;
    IB_SearchBar1: TIB_SearchBar;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_LocateEdit1: TIB_LocateEdit;
    Button4: TButton;
    Button16: TButton;
    Button11: TButton;
    Button14: TButton;
    Button12: TButton;
    Button6: TButton;
    Button8: TButton;
    Button10: TButton;
    SpeedButton14: TSpeedButton;
    TabSheet2: TTabSheet;
    IB_Memo2: TIB_Memo;
    Label21: TLabel;
    TabSheet4: TTabSheet;
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
    IB_CheckBox22: TIB_CheckBox;
    IB_CheckBox23: TIB_CheckBox;
    SpeedButton17: TSpeedButton;
    Label22: TLabel;
    Edit3: TEdit;
    Button1: TButton;
    Label23: TLabel;
    Image1: TImage;
    SpeedButton15: TSpeedButton;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    Image3: TImage;
    TabSheet6: TTabSheet;
    ComboBox4: TComboBox;
    IB_Memo3: TIB_Memo;
    IB_Query2: TIB_Query;
    IB_DataSource3: TIB_DataSource;
    IB_UpdateBar3: TIB_UpdateBar;
    SpeedButton16: TSpeedButton;
    SpeedButton18: TSpeedButton;
    TabSheet7: TTabSheet;
    Label7: TLabel;
    Button13: TButton;
    IB_Grid3: TIB_Grid;
    IB_Query3: TIB_Query;
    IB_DataSource4: TIB_DataSource;
    IB_UpdateBar4: TIB_UpdateBar;
    Button3: TButton;
    SpeedButton20: TSpeedButton;
    Button5: TButton;
    Button17: TButton;
    Button20: TButton;
    Label24: TLabel;
    IB_Edit3: TIB_Edit;
    SpeedButton19: TSpeedButton;
    TabSheet8: TTabSheet;
    Edit4: TEdit;
    SpeedButton21: TSpeedButton;
    JvFormStorage1: TJvFormStorage;
    procedure SpeedButton16Click(Sender: TObject);
    procedure IB_Query2AfterPost(IB_Dataset: TIB_Dataset);
    procedure IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
    procedure FormActivate(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure Button4Click(Sender: TObject);
    procedure IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
    procedure Button16Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2DropDown(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3DropDown(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure IB_Query1ConfirmDelete(Sender: TComponent;
      var Confirmed: Boolean);
    procedure Button7Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure IB_Query13BeforePost(IB_Dataset: TIB_Dataset);
    procedure SpeedButton17Click(Sender: TObject);
    procedure IB_Query1BeforePrepare(Sender: TIB_Statement);
    procedure SpeedButton17MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton18Click(Sender: TObject);
    procedure IB_Query3AfterScroll(IB_Dataset: TIB_Dataset);
    procedure Button3Click(Sender: TObject);
    procedure IB_Query3ConfirmDelete(Sender: TComponent;
      var Confirmed: Boolean);
    procedure Button5Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure IB_Grid1GetCellProps(Sender: TObject; ACol, ARow: Integer;
      AState: TGridDrawState; var AColor: TColor; AFont: TFont);
    procedure Button20Click(Sender: TObject);
    procedure SpeedButton19Click(Sender: TObject);
    procedure IB_Grid2GetCellProps(Sender: TObject; ACol, ARow: Integer;
      AState: TGridDrawState; var AColor: TColor; AFont: TFont);
    procedure IB_Query13BeforePrepare(Sender: TIB_Statement);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton21Click(Sender: TObject);
  private
    { Private-Deklarationen }
    _VERLAG_R: Integer;
    Query1_Sql: TStringList;
    ArtikelSucheWI: TWordIndex;
    RefreshArtikelTime: dword;
    g1_cCOL_PAPERCOLOR: Integer;
    g2_cCOL_PAPERCOLOR: Integer;
    procedure EnsureEditState;
    procedure LagerReflect;
    procedure FromFoundListToGrid(ArtikelSuche: TWordIndex);
    procedure PrepareSearch;
  public
    { Public-Deklarationen }
    UserBreak: Boolean;
    InsideImport: Boolean;
    UserEditMode: Boolean;
    procedure SetContext(RID: Integer; AA: Integer = cRID_Null); overload;
    procedure SetContext(RIDS: TList); overload;
    procedure SetContext(sql: string); overload;
    procedure ReflectArtikelInfo;
    procedure ReflectPREIS_R;
    procedure DoTheArtikelSearch;

    // Combo Boxes
    procedure RefreshKomponistArrangeurCombo;
    procedure RefreshSortimentCombo;
    procedure RefreshLaenderCombo;
    procedure RefreshSchalterTexte;

  end;

var
  FormArtikel: TFormArtikel;

implementation

uses
  globals, anfix32, html,
  gplists, math, wanfix32,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  Funktionen_Transaktion,
  Funktionen_LokaleDaten,
  ArtikelNeu, Musiker, Person,
  ArtikelEingabe, ArtikelVerlag, Lager,
  ArtikelBackorder, BestellArbeitsplatz, ArtikelKategorie,
  GUIhelp, WarenBewegung, CareTakerClient, ArtikelContext,
  ArtikelPreis, ArtikelPakete, OLAP,
  Jvgnugettext, ArtikelSortiment, Main;

{$R *.DFM}

procedure TFormArtikel.FormActivate(Sender: TObject);
begin
  if frequently(RefreshArtikelTime, 30 * 60 * 1000) then
  begin
    BeginHourGlass;

    // Vorbereitungen für die Sortiment-Combobox
    RefreshSortimentCombo;

    // Komponist und Arrangeur
    RefreshKomponistArrangeurCombo;

    // Vorbereitungen
    RefreshLaenderCombo;

    // Schalter
    RefreshSchalterTexte;

    // IB- Query öffnen
    if IB_Query1.active then
      IB_Query1.refresh
    else
      IB_Query1.Open;

    EndHourGlass;
  end;
  if not(IB_Query1.active) then
    IB_Query1.Open;
  UserEditMode := true;
end;

procedure TFormArtikel.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  ReflectArtikelInfo;
end;

procedure TFormArtikel.Button4Click(Sender: TObject);
var
  ARTIKEL_R: Integer;
begin
  if FormArtikelNeu.execute then
  begin
    BeginHourGlass;
    ARTIKEL_R := e_w_ArtikelNeu(FormArtikelNeu.SORTIMENT_R);
    with IB_Query1 do
    begin
      close;
      qSelectOne(IB_Query1);
      ParamByName('CROSSREF').AsInteger := ARTIKEL_R;
      Open;
      Button16.Enabled := true;
    end;
    EndHourGlass;
  end;
end;

procedure TFormArtikel.Button5Click(Sender: TObject);
begin
  openShell(format('http://%s?site=article&id=%s',
    [iShopDomain, IB_Query1.FieldByName('RID').AsString]));
end;

procedure TFormArtikel.Button17Click(Sender: TObject);
begin
  openShell(format
    ('http://%s?site=search&action=search_user_expression&f_search_expression=%s',
    [iShopDomain, AnsiToRFC1738(Edit2.text)]));
end;

procedure TFormArtikel.IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
begin
  with IB_Dataset do
  begin
    if UserEditMode then
      IB_Dataset.FieldByName('LETZTEAENDERUNG').AsDateTime := now;
    if (state = dssedit) then
      if FieldByName('EURO').IsModified then
      begin
        FormArtikelPreis.SetContext(0, FieldByName('RID').AsInteger,
          FieldByName('EURO').AsDouble, 0);
      end;
  end;
end;

procedure TFormArtikel.Button16Click(Sender: TObject);
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
    locate('RID', ToRID, []);
  end;
  EndHourGlass;
  Button16.Enabled := false;
end;

procedure TFormArtikel.Button6Click(Sender: TObject);
begin
  FormArtikelKategorie.execute(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormArtikel.Button18Click(Sender: TObject);
var
  StartTime: dword;
  RecN: Integer;
  OutL: TStringList;
  ArtikelINfo: TStringList;
  ArtikelMenge: TStringList;

  _ErstesDatum: TANFIXDATE;
  _LetztesDatum: TANFIXDATE;
  Zeitraum: Integer;
  _Zeitraum: double;
  GelieferteMenge: Integer;
  _GelieferteMenge: double;
  MengeProWoche: double;
  MengeProWocheAnfang: double;
  n: Integer;

begin
  screen.cursor := crHourGlass;
  OutL := TStringList.create;
  ArtikelINfo := TStringList.create;
  ArtikelMenge := TStringList.create;
  IB_Query6.Open;
  IB_Query7.Open;
  IB_Query8.Open;
  IB_Query6.first;
  ProgressBar1.Max := IB_Query6.Recordcount;
  StartTime := 0;
  RecN := 0;
  while not(IB_Query6.eof) do
  begin

    _ErstesDatum := 0;
    _LetztesDatum := 0;
    Zeitraum := 0;
    GelieferteMenge := 0;
    MengeProWoche := 0.0;
    MengeProWocheAnfang := 0.0;
    ArtikelMenge.clear;

    IB_Query7.ParamByName('CROSSREF').AsInteger := IB_Query6.FieldByName('RID')
      .AsInteger;
    if not(IB_Query7.IsEmpty) then
    begin
      IB_Query7.first;
      with IB_Query7 do
        while not(eof) do
        begin
          IB_Query8.ParamByName('CROSSREF').AsInteger := FieldByName('BELEG_R')
            .AsInteger;
          if not(IB_Query8.IsEmpty) then
            ArtikelMenge.addObject
              (inttostr(datetime2long(IB_Query8.FieldByName('ANLAGE').AsDate)),
              pointer(FieldByName('MENGE_GELIEFERT').AsInteger));
          next;
        end;
      if ArtikelMenge.count > 0 then
      begin
        ArtikelMenge.sort;
        for n := 0 to pred(ArtikelMenge.count) do
          GelieferteMenge := GelieferteMenge + Integer(ArtikelMenge.objects[n]);
        _ErstesDatum := strtoint(ArtikelMenge[0]);
        _LetztesDatum := strtoint(ArtikelMenge[pred(ArtikelMenge.count)]);

        // 2
        Zeitraum := DateDiff(_ErstesDatum, DateGet) + 1;
        if Zeitraum > 0 then
        begin
          _Zeitraum := Zeitraum;
          _GelieferteMenge := GelieferteMenge;
          MengeProWocheAnfang := (_GelieferteMenge / _Zeitraum) * 7.0;
        end;

        // 1
        Zeitraum := DateDiff(_ErstesDatum, _LetztesDatum) + 1;
        if Zeitraum > 0 then
        begin
          _Zeitraum := Zeitraum;
          _GelieferteMenge := GelieferteMenge;
          MengeProWoche := (_GelieferteMenge / _Zeitraum) * 7.0;
        end;

      end;
    end;
    IB_Query6.FieldByName('INTERN_INFO').AssignTo(ArtikelINfo);

    OutL.add(NoSemi(e_r_Verlag_PERSON_R(IB_Query6.FieldByName('VERLAG_R')
      .AsInteger)) + ';' + inttostr(IB_Query6.FieldByName('NUMERO').AsInteger) +
      ';' + NoSemi(IB_Query6.FieldByName('TITEL').AsString) + ';' +
      inttostr(IB_Query6.FieldByName('MENGE').AsInteger) + ';' +
      long2date(_ErstesDatum) + ';' + long2date(_LetztesDatum) + ';' +
      inttostr(Zeitraum) + ';' + inttostr(GelieferteMenge) + ';' +
      format('%.2f;%.2f', [MengeProWoche, MengeProWocheAnfang]) + ';' +
      NoSemi(ArtikelINfo.Values['BEM']) + ';' + e_r_LagerPlatzNameFromLAGER_R
      (IB_Query6.FieldByName('LAGER_R').AsInteger) + ';' +
      NoSemi(ArtikelINfo.Values['VERLAGNO']) + ';'
      // inttostr(IB_Query6.FieldByName('MENGE_ERWARTET').AsInteger) + ';'
      );

    IB_Query6.next;
    if frequently(StartTime, 400) or (IB_Query6.eof) then
    begin
      ProgressBar1.position := RecN;
      application.processmessages;
    end;
    inc(RecN);
  end;
  IB_Query6.close;
  IB_Query7.close;
  IB_Query8.close;
  OutL.sort;
  OutL.saveToFile(DiagnosePath + 'Artikel Liste.txt');
  OutL.free;
  ArtikelINfo.free;
  ProgressBar1.position := 0;
  screen.cursor := crdefault;
end;

procedure TFormArtikel.ComboBox1Change(Sender: TObject);
var
  _rid: Integer;
begin
  EnsureEditState;
  _rid := e_r_LaenderRIDfromISO(ComboBox1.text);
  if _rid <> -1 then
  begin
    IB_Query1.FieldByName('LAND_R').AsInteger := _rid;
  end
  else
  begin
    IB_Query1.FieldByName('LAND_R').clear;
  end;
end;

procedure TFormArtikel.EnsureEditState;
begin
  if (IB_Query1.state <> dssedit) and (IB_Query1.state <> dssInsert) then
    IB_Query1.edit;
end;

procedure TFormArtikel.ComboBox2DropDown(Sender: TObject);
begin
  ComboBox2.Items.assign(e_r_Verlage1);
end;

procedure TFormArtikel.ComboBox2Change(Sender: TObject);
var
  _rid: Integer;
begin
  EnsureEditState;
  _rid := e_r_VerlagPerson(ComboBox2.text);
  if (_rid <> -1) then
  begin
    IB_Query1.FieldByName('VERLAG_R').AsInteger := _rid;
  end
  else
  begin
    IB_Query1.FieldByName('VERLAG_R').clear;
  end;
end;

procedure TFormArtikel.ComboBox3DropDown(Sender: TObject);
var
  LAGER_R: Integer;
begin
  with IB_Query1 do
  begin
    if FieldByName('LAGER_R').IsNull then
    begin
      // Lager zuordnen!
      LAGER_R := e_r_LagerVorschlag(FieldByName('SORTIMENT_R').AsInteger,
        FieldByName('VERLAG_R').AsInteger);
      if (LAGER_R > 0) then
      begin
        EnsureEditState;
        FieldByName('LAGER_R').AsInteger := LAGER_R;
      end;
    end
    else
    begin
      // Lager eintrag löschen?!
      EnsureEditState;
      FieldByName('LAGER_R').clear;
    end;
  end;
  LagerReflect;
end;

procedure TFormArtikel.LagerReflect;
begin
  with IB_Query1 do
  begin
    ComboBox3.DroppedDown := false;
    if FieldByName('LAGER_R').IsNull then
      ComboBox3.text := '-'
    else
      ComboBox3.text := e_r_LagerPlatzNameFromLAGER_R(FieldByName('LAGER_R')
        .AsInteger);
    ComboBox3.refresh;
  end;
end;

procedure TFormArtikel.Button10Click(Sender: TObject);
begin
  FormArtikelBackOrder.SetContext(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormArtikel.Button11Click(Sender: TObject);
begin
  FormBestellArbeitsplatz.SetContext(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormArtikel.ReflectArtikelInfo;
var
  ARTIKEL_R: Integer;
  FName: string;
begin

  BeginHourGlass;

  //
  ARTIKEL_R := IB_Query1.FieldByName('RID').AsInteger;

  // Artikel - Ausgabearten
  with IB_Query13 do
  begin
    ParamByName('CROSSREF').AsInteger := ARTIKEL_R;
    if not(active) then
      Open;
  end;

  // Die Dokumente
  with IB_Query2 do
  begin
    ParamByName('CROSSREF').AsInteger := ARTIKEL_R;
    if not(active) then
      Open;
  end;

  // Die Prorata
  with IB_Query3 do
  begin
    ParamByName('CROSSREF').AsInteger := ARTIKEL_R;
    if not(active) then
      Open;
  end;

  //
  with IB_Query1 do
  begin

    // Bild
    FName := e_r_ArtikelVorschaubild(0, ARTIKEL_R);
    if (FName <> '') then
    begin
      Image3.picture.loadfromfile(iShopArtikelBilderPath + FName);
      Image3.show;
    end
    else
    begin
      Image3.hide;
    end;

    // Land
    if FieldByName('LAND_R').IsNull then
      ComboBox1.text := '-'
    else
      ComboBox1.text := e_r_LaenderISO(FieldByName('LAND_R').AsInteger);

    // Lieferant
    Label11.caption := e_r_Person(e_r_Lieferant(ARTIKEL_R, 0));

    // Lieferzeit
    if FieldByName('LIEFERZEIT').IsNotNull then
      Label13.caption := LieferzeitToStr(FieldByName('LIEFERZEIT').AsInteger)
    else
      Label13.caption := '<leer>';

    Label16.caption := FieldByName('INVENTUR_MOMENT').AsString;

    // Verlag
    if FieldByName('VERLAG_R').IsNull then
    begin
      ComboBox2.text := '-';
    end
    else
    begin
      ComboBox2.text := e_r_Verlag_PERSON_R(FieldByName('VERLAG_R').AsInteger);
      if (ComboBox2.text = '') then
        ComboBox2.text := '<Verlag ohne Begriff>';
    end;

    // Lager
    LagerReflect;

    // PREIS_R
    ReflectPREIS_R;

    // Titel des Forms
    caption := 'Artikel - [' + FieldByName('NUMERO').AsString + ' ' +
      FieldByName('TITEL').AsString + ']';

    // Farbe des Formulars
    if FieldByName('PAPERCOLOR').IsNotNull then
      color := FieldByName('PAPERCOLOR').AsInteger
    else
      color := clBtnFace;

  end;
  EndHourGlass;

end;

procedure TFormArtikel.IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
begin
  ReflectArtikelInfo;
end;

procedure TFormArtikel.Button13Click(Sender: TObject);
begin
  FormPerson.SetContext(IB_Query3.FieldByName('PERSON_R').AsInteger);
end;

procedure TFormArtikel.Button14Click(Sender: TObject);
begin
  HebuPlaySound(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormArtikel.SpeedButton1Click(Sender: TObject);
begin
  HeBuPDF(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormArtikel.Button12Click(Sender: TObject);
begin
  FormPerson.SetContext(IB_Query1.FieldByName('VERLAG_R').AsInteger);
end;

procedure TFormArtikel.Button15Click(Sender: TObject);
begin
  FormPerson.SetContext(e_r_Lieferant(IB_Query1.FieldByName('RID')
    .AsInteger, 0));
end;

procedure TFormArtikel.ReflectPREIS_R;
var
  VERLAG_R: Integer;
  PREIS: TIB_Cursor;
begin
  // clear
  VERLAG_R := IB_Query1.FieldByName('VERLAG_R').AsInteger;
  if (VERLAG_R <> _VERLAG_R) then
  begin
    _VERLAG_R := VERLAG_R;

    IB_ComboBox2.Items.clear;
    IB_ComboBox2.ItemValues.clear;

    // kein Eintrag
    IB_ComboBox2.Items.add(cRefComboOhneEintrag);
    IB_ComboBox2.ItemValues.add('');

    VERLAG_R := e_r_Verlag_R(VERLAG_R);
    VERLAG_R := e_r_VerlagAlias(VERLAG_R);
    PREIS := DataModuleDatenbank.nCursor;
    with PREIS do
    begin
      sql.add('select P.RID,P.CODE,P.EURO,P.PREIS,L.KURS,L.ISO_WAEHRUNG from PREIS P');
      sql.add('left join LAND L on P.WAEHRUNG_R=L.RID');
      sql.add('where verlag_r=' + inttostr(VERLAG_R));
      sql.add('order by code');
      APIfirst;
      while not(eof) do
      begin
        if FieldByName('EURO').IsNull then
          IB_ComboBox2.Items.add(FieldByName('CODE').AsString +
            format(' (%.2f %s) %.2m', [FieldByName('PREIS').AsDouble,
            FieldByName('ISO_WAEHRUNG').AsString,
            round(FieldByName('PREIS').AsDouble * FieldByName('KURS').AsDouble *
            100.0) / 100.0]))
        else
          IB_ComboBox2.Items.add(FieldByName('CODE').AsString + format(' %.2m',
            [FieldByName('EURO').AsDouble]));
        IB_ComboBox2.ItemValues.add(FieldByName('RID').AsString);
        next;
      end;
      close;
    end;
    PREIS.free;
  end;
  IB_ComboBox2.itemindex := IB_ComboBox2.ItemValues.IndexOf
    (IB_Query1.FieldByName('PREIS_R').AsString);
end;

procedure TFormArtikel.IB_Query1ConfirmDelete(Sender: TComponent;
  var Confirmed: Boolean);
begin
  Confirmed := false;
  with Sender as TIB_Dataset do
    if doit(FieldByName('NUMERO').AsString + #13 + FieldByName('TITEL').AsString
      + #13 + 'wirklich löschen') then
    begin
      BeginHourGlass;
      e_w_preDeleteArtikel(FieldByName('RID').AsInteger);
      Confirmed := true;
      EndHourGlass;
    end;
end;

procedure TFormArtikel.IB_Query2AfterPost(IB_Dataset: TIB_Dataset);
begin
  IB_Dataset.refresh;
end;

procedure TFormArtikel.IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
begin
  with IB_Dataset do
  begin
    if FieldByName('RID').IsNull then
      FieldByName('RID').AsInteger := 0;
    FieldByName('ARTIKEL_R').AsInteger := IB_Query1.FieldByName('RID')
      .AsInteger;
    FieldByName('MEDIUM_R').AsInteger := cMediumWeblink;
  end;
end;

procedure TFormArtikel.IB_Query3AfterScroll(IB_Dataset: TIB_Dataset);
begin
  // Prorata
  with IB_Dataset do
    if FieldByName('PERSON_R').IsNull then
      Label7.caption := '-- keine Prorata Zuordnung --'
    else
      Label7.caption := e_r_Person(FieldByName('PERSON_R').AsInteger);
end;

procedure TFormArtikel.IB_Query3ConfirmDelete(Sender: TComponent;
  var Confirmed: Boolean);
begin
  Confirmed := false;
  with Sender as TIB_Dataset do
    Confirmed := doit('Prorata-Zuordnung wirklich löschen');
end;

procedure TFormArtikel.Button7Click(Sender: TObject);
var
  LAGER_R: Integer;
begin
  with IB_Query1 do
  begin
    LAGER_R := e_w_Einlagern(FieldByName('RID').AsInteger);
    if (LAGER_R > 0) then
      FieldByName('LAGER_R').AsInteger := LAGER_R
    else
      FieldByName('LAGER_R').clear;
    LagerReflect;
  end;
end;

procedure TFormArtikel.FormDestroy(Sender: TObject);
begin
  _VERLAG_R := -1;
end;

procedure TFormArtikel.Button8Click(Sender: TObject);
begin
  FormWarenbewegung.SetContextArtikel(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormArtikel.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
  PageControl1.ActivePage := TabSheet3;
  Query1_Sql := TStringList.create;
  Query1_Sql.AddStrings(IB_Query1.sql);
end;

procedure TFormArtikel.DoTheArtikelSearch;
var
  SpezielleSuche: TWordIndex;
begin
  BeginHourGlass;
  if pos('@', Edit2.text) > 0 then
  begin
    SpezielleSuche := TWordIndex.create(nil);
    SpezielleSuche.loadfromfile(SearchDir + format(cArtikelSuchindexFName,
      [nextp(Edit2.text, '@', 1)]));
    SpezielleSuche.Search(nextp(Edit2.text, '@', 0));
    FromFoundListToGrid(SpezielleSuche);
    SpezielleSuche.free;
  end
  else
  begin

    PrepareSearch;
    ArtikelSucheWI.Search(Edit2.text);
    FromFoundListToGrid(ArtikelSucheWI);
  end;
  EndHourGlass;
end;

procedure TFormArtikel.PrepareSearch;
begin
  if not(assigned(ArtikelSucheWI)) then
  begin
    ArtikelSucheWI := TWordIndex.create(nil);
    ArtikelSucheWI.loadfromfile(SearchDir + format(cArtikelSuchindexFName,
      [cArtikelSuchindexIntern]));
  end
  else
  begin
    ArtikelSucheWI.ReloadIfNew;
  end;
end;

procedure TFormArtikel.FromFoundListToGrid(ArtikelSuche: TWordIndex);
begin
  if ArtikelSuche.FoundList.count > 0 then
  begin
    with IB_Query1 do
    begin
      close;
      qSelectList(IB_Query1, ArtikelSuche.FoundList);
      Open;
      Button16.Enabled := true;
    end;
  end
  else
  begin
    ShowMessage('Nichts gefunden!');
    Edit2.SetFocus;
  end;
end;

procedure TFormArtikel.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    DoTheArtikelSearch;
  end;
end;

procedure TFormArtikel.Edit4KeyPress(Sender: TObject; var Key: Char);
var
  lRID: TgpIntegerList;
begin
  if (Key = #13) then
  begin
    Key := #0;
    BeginHourGlass;

    //
    lRID := TgpIntegerList.create;
    with IB_Query1 do
    begin
      DisableControls;
      first;
      while not(eof) do
      begin
        lRID.add(FieldByName('RID').AsInteger);
        next;
      end;
      EnableControls;
    end;

    //
    Funktionen_Transaktion.Dispatch(Edit4.text, lRID);
    lRID.free;

    EndHourGlass;
    IB_Query1.refresh;
  end;
end;

function TextInside(SmallOne, BigOne: TStrings): Boolean;
var
  s, b: string;
  n: Integer;
begin
  s := '';
  b := '';
  for n := 0 to pred(SmallOne.count) do
    s := s + AnsiUpperCase(noblank(SmallOne[n]));
  if (s <> '') then
    for n := 0 to pred(BigOne.count) do
      b := b + AnsiUpperCase(noblank(BigOne[n]));
  result := (pos(s, b) > 0) or (s = '');
end;

procedure TFormArtikel.SpeedButton21Click(Sender: TObject);
var
  QRindex: THTMLTemplate;
  OutPath: string;
  DatensammlerLokal, DatensammlerGlobal: TStringList;
begin
  BeginHourGlass;
  DatensammlerLokal := TStringList.create;
  QRindex := THTMLTemplate.create;
  with QRindex, IB_Query1 do
  begin
    loadfromfile(iShopQRPath + cHTMLTemplatesDir + 'index.html');
    DatensammlerGlobal := AsKeyValue(IB_Query1);
    DatensammlerGlobal.add('id=' + e_r_ArtikelLink(FieldByName('RID')
      .AsInteger));

    OutPath := iShopQRPath + FieldByName('NUMERO').AsString + '\';
    WriteValue(DatensammlerLokal, DatensammlerGlobal);
    CheckCreateDir(OutPath);
    if DebugMode then
      saveToFile(OutPath + 'index.html')
    else
      SaveToFileCompressed(OutPath + 'index.html');
  end;
  QRindex.free;
  DatensammlerLokal.free;
  DatensammlerGlobal.free;
  EndHourGlass;
end;

procedure TFormArtikel.SpeedButton2Click(Sender: TObject);
begin
  BeginHourGlass;
  Kreative(true);
  RefreshKomponistArrangeurCombo;
  IB_Query1.refresh;
  EndHourGlass;
end;

procedure TFormArtikel.SpeedButton3Click(Sender: TObject);
begin
  BeginHourGlass;
  Kreative(true);
  RefreshKomponistArrangeurCombo;
  IB_Query1.refresh;
  EndHourGlass;
end;

procedure TFormArtikel.RefreshKomponistArrangeurCombo;
begin
  IB_ComboBox4.Items.loadfromfile(Kreative + cItemsCacheFExtension);
  IB_ComboBox4.ItemValues.loadfromfile(Kreative + cValueCacheFExtension);
  IB_ComboBox5.Items.assign(IB_ComboBox4.Items);
  IB_ComboBox5.ItemValues.assign(IB_ComboBox4.ItemValues);
end;

procedure TFormArtikel.RefreshSortimentCombo;
begin
  IB_ComboBox1.Items.loadfromfile(Sortiment + cItemsCacheFExtension);
  IB_ComboBox1.ItemValues.loadfromfile(Sortiment + cValueCacheFExtension);
end;

procedure TFormArtikel.SpeedButton4Click(Sender: TObject);
begin
  BeginHourGlass;
  Sortiment(true);
  RefreshSortimentCombo;
  IB_Query1.refresh;
  EndHourGlass;
end;

procedure TFormArtikel.RefreshLaenderCombo;
begin
  ComboBox1.Items.loadfromfile(Laender);
  ComboBox1.Items.insert(0, '-');
end;

procedure TFormArtikel.SpeedButton5Click(Sender: TObject);
begin
  RefreshLaenderCombo;
  IB_Query1.refresh;
end;

procedure TFormArtikel.SpeedButton7Click(Sender: TObject);
begin
  FormMusiker.SetContext(IB_Query1.FieldByName('KOMPONIST_R').AsInteger);
end;

procedure TFormArtikel.SpeedButton9Click(Sender: TObject);
begin
  FormMusiker.SetContext(IB_Query1.FieldByName('ARRANGEUR_R').AsInteger);
end;

procedure TFormArtikel.SpeedButton6Click(Sender: TObject);
begin
  ShowMessage(e_r_MusikerUeber(IB_Query1.FieldByName('KOMPONIST_R').AsInteger));
end;

procedure TFormArtikel.SpeedButton8Click(Sender: TObject);
begin
  ShowMessage(e_r_MusikerUeber(IB_Query1.FieldByName('ARRANGEUR_R').AsInteger));
end;

procedure TFormArtikel.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Artikel');
end;

procedure TFormArtikel.SpeedButton10Click(Sender: TObject);
var
  cARTIKEL: TIB_Cursor;
begin
  BeginHourGlass;
  PrepareSearch;
  cARTIKEL := DataModuleDatenbank.nCursor;
  with cARTIKEL do
  begin
    sql.add('select DISTINCT MASTER_R from ARTIKEL_MITGLIED where ARTIKEL_R=' +
      IB_Query1.FieldByName('RID').AsString);
    ArtikelSucheWI.FoundList.clear;
    APIfirst;
    while not(eof) do
    begin
      ArtikelSucheWI.FoundList.add(TObject(FieldByName('MASTER_R').AsInteger));
      ApiNext;
    end;
  end;
  cARTIKEL.free;
  FromFoundListToGrid(ArtikelSucheWI);
  EndHourGlass;
end;

procedure TFormArtikel.SpeedButton11Click(Sender: TObject);
var
  cARTIKEL: TIB_Cursor;
begin
  BeginHourGlass;
  PrepareSearch;
  cARTIKEL := DataModuleDatenbank.nCursor;
  with cARTIKEL do
  begin
    sql.add('select DISTINCT ARTIKEL_R from ARTIKEL_MITGLIED where MASTER_R=' +
      IB_Query1.FieldByName('RID').AsString);
    ArtikelSucheWI.FoundList.clear;
    APIfirst;
    while not(eof) do
    begin
      ArtikelSucheWI.FoundList.add(TObject(FieldByName('ARTIKEL_R').AsInteger));
      ApiNext;
    end;
  end;
  cARTIKEL.free;
  FromFoundListToGrid(ArtikelSucheWI);
  EndHourGlass;
end;

procedure TFormArtikel.SpeedButton12Click(Sender: TObject);
begin
  FormArtikelContext.SetContextArtikel(IB_Query1.FieldByName('RID').AsInteger,
    IB_Query1.FieldByName('NUMERO').AsString);
end;

procedure TFormArtikel.SpeedButton13Click(Sender: TObject);
begin
  FormArtikelContext.SetContextContext(IB_Query1.FieldByName('RID').AsInteger,
    IB_Query1.FieldByName('NUMERO').AsString);
end;

procedure TFormArtikel.Button20Click(Sender: TObject);
begin
  FormArtikelSortiment.SetContext(IB_Query1.FieldByName('SORTIMENT_R')
    .AsInteger);
end;

procedure TFormArtikel.Button21Click(Sender: TObject);
begin
  IB_Query1.FieldByName('TITEL').clear;
end;

procedure TFormArtikel.SpeedButton14Click(Sender: TObject);
var
  cARTIKEL: TIB_Cursor;
begin
  BeginHourGlass;
  PrepareSearch;
  cARTIKEL := DataModuleDatenbank.nCursor;
  with cARTIKEL do
  begin
    sql.add('select RID from ARTIKEL where ERSTEINTRAG>''' +
      long2date(DatePlus(DateGet, -iNeuanlageZeitraum)) + '''');
    APIfirst;
    ArtikelSucheWI.FoundList.clear;
    while not(eof) do
    begin
      ArtikelSucheWI.FoundList.add(TObject(FieldByName('RID').AsInteger));
      ApiNext;
    end;
    close;
  end;
  cARTIKEL.free;
  FromFoundListToGrid(ArtikelSucheWI);
  EndHourGlass;
end;

var
  g1_LastRow: Integer = -1;
  g1_LastBackgroundCol: TColor;
  g1_LastFontCol: TColor;

procedure TFormArtikel.IB_Grid1GetCellProps(Sender: TObject;
  ACol, ARow: Integer; AState: TGridDrawState; var AColor: TColor;
  AFont: TFont);
var
  PAPERCOLOR: string;
begin

  // Wird die fokusierte Zeile ausgegeben muss das Caching verhindert werden,
  // da sich das Grid in der ersten Zeile zunächst leer selbst zeichnet,
  // danach die erste Zeile nochmals, diesmal mit Daten, durch das Caching
  // würde der Fehler entstehen, dass die Farbe aus dem ersten Zeichenversuch
  // in den 2. Versuch übernommen wird.
  if gdFocused in AState then
    g1_LastRow := -1;

  if not(gdFixed in AState) and not(gdFocused in AState) then
    with IB_Grid1 do
    begin
      if (ARow <> g1_LastRow) and DataSource.DataSet.active then
      begin

        // Spalte der "PAPERCOLOR" bestimmen
        if (g1_cCOL_PAPERCOLOR <= 0) then
          g1_cCOL_PAPERCOLOR := ColOfGrid(IB_Grid1, 'PAPERCOLOR');
        if (g1_cCOL_PAPERCOLOR <= 0) then
          raise Exception.create('Spalte "PAPERCOLOR" ist undefiniert!');

        // Wert aus PAPERCOLOR bestimmen
        PAPERCOLOR := GetCellDisplayText(g1_cCOL_PAPERCOLOR, ARow);
        if (PAPERCOLOR <> '') then
          g1_LastBackgroundCol := strtointdef(PAPERCOLOR, color)
        else
          g1_LastBackgroundCol := color;

        //
        g1_LastFontCol := VisibleContrast(g1_LastBackgroundCol);

        // Cache-Flag setzen
        g1_LastRow := ARow;
      end;

      AColor := g1_LastBackgroundCol;
      AFont.color := g1_LastFontCol;
    end;
end;

var
  g2_LastRow: Integer = -1;
  g2_LastBackgroundCol: TColor;
  g2_LastFontCol: TColor;

procedure TFormArtikel.IB_Grid2GetCellProps(Sender: TObject;
  ACol, ARow: Integer; AState: TGridDrawState; var AColor: TColor;
  AFont: TFont);
var
  PAPERCOLOR: string;
begin

  // Wird die fokusierte Zeile ausgegeben muss das Caching verhindert werden,
  // da sich das Grid in der ersten Zeile zunächst leer selbst zeichnet,
  // danach die erste Zeile nochmals, diesmal mit Daten, durch das Caching
  // würde der Fehler entstehen, dass die Farbe aus dem ersten Zeichenversuch
  // in den 2. Versuch übernommen wird.
  if gdFocused in AState then
    g2_LastRow := -1;

  if not(gdFixed in AState) and not(gdFocused in AState) then
    with IB_Grid2 do
    begin
      if (ARow <> g2_LastRow) and DataSource.DataSet.active then
      begin

        // Spalte der "PAPERCOLOR" bestimmen
        if (g2_cCOL_PAPERCOLOR <= 0) then
          g2_cCOL_PAPERCOLOR := ColOfGrid(IB_Grid2, 'PAPERCOLOR');
        if (g2_cCOL_PAPERCOLOR <= 0) then
          raise Exception.create('Spalte "PAPERCOLOR" ist undefiniert!');

        // Wert aus PAPERCOLOR bestimmen
        PAPERCOLOR := GetCellDisplayText(g2_cCOL_PAPERCOLOR, ARow);
        if (PAPERCOLOR <> '') then
          g2_LastBackgroundCol := strtointdef(PAPERCOLOR, color)
        else
          g2_LastBackgroundCol := color;

        //
        g2_LastFontCol := VisibleContrast(g2_LastBackgroundCol);

        // Cache-Flag setzen
        g2_LastRow := ARow;
      end;

      AColor := g2_LastBackgroundCol;
      AFont.color := g2_LastFontCol;
    end;
  // AColor := random($FFFFFF+1);
  // AFont.color := random($FFFFFF+1);

end;

procedure TFormArtikel.IB_Query13BeforePost(IB_Dataset: TIB_Dataset);
var
  ARTIKEL_R: Integer;
begin
  ARTIKEL_R := IB_Query1.FieldByName('RID').AsInteger;
  with IB_Dataset do
  begin
    if FieldByName('ARTIKEL_R').IsNull then
      FieldByName('ARTIKEL_R').AsInteger := ARTIKEL_R;
    if (state = dssedit) then
      if FieldByName('EURO').IsModified then
      begin
        FormArtikelPreis.SetContext(FieldByName('AUSGABEART_R').AsInteger,
          ARTIKEL_R, FieldByName('EURO').AsDouble, 0);
      end;
  end;
end;

procedure TFormArtikel.IB_Query13BeforePrepare(Sender: TIB_Statement);
begin
  g2_cCOL_PAPERCOLOR := 0;
end;

procedure TFormArtikel.RefreshSchalterTexte;
begin
  IB_CheckBox4.caption := iSchalterTexte[0];
  IB_CheckBox5.caption := iSchalterTexte[1];
  IB_CheckBox6.caption := iSchalterTexte[2];
  IB_CheckBox7.caption := iSchalterTexte[3];
  IB_CheckBox8.caption := iSchalterTexte[4];
  IB_CheckBox9.caption := iSchalterTexte[5];
  IB_CheckBox10.caption := iSchalterTexte[6];
  IB_CheckBox11.caption := iSchalterTexte[7];
  IB_CheckBox12.caption := iSchalterTexte[8];
  IB_CheckBox13.caption := iSchalterTexte[9];
  IB_CheckBox14.caption := iSchalterTexte[10];
  IB_CheckBox15.caption := iSchalterTexte[11];
  IB_CheckBox16.caption := iSchalterTexte[12];
  IB_CheckBox17.caption := iSchalterTexte[13];
  IB_CheckBox18.caption := iSchalterTexte[14];
  IB_CheckBox19.caption := iSchalterTexte[15];
  IB_CheckBox20.caption := iSchalterTexte[16];
  IB_CheckBox21.caption := iSchalterTexte[17];
  IB_CheckBox22.caption := iSchalterTexte[18];
  IB_CheckBox23.caption := iSchalterTexte[19];
end;

procedure TFormArtikel.SpeedButton17Click(Sender: TObject);
begin
  SaveHeaderSettings(IB_Grid1, AnwenderPath + HeaderSettingsFName(IB_Grid1));
end;

procedure TFormArtikel.IB_Query1BeforePrepare(Sender: TIB_Statement);
begin
  LoadHeaderSettings(IB_Grid1, AnwenderPath + HeaderSettingsFName(IB_Grid1));
  g1_cCOL_PAPERCOLOR := 0;
end;

procedure TFormArtikel.SpeedButton17MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbRight) then
    if doit('Wollen Sie die Spaltenbreiten wieder auf Standard setzen', true)
    then
    begin
      FileDelete(AnwenderPath + HeaderSettingsFName(IB_Grid1));
      IB_Query1.close;
      IB_Query1.sql.clear;
      IB_Query1.sql.AddStrings(Query1_Sql);
      IB_Query1.Open;
    end;
end;

procedure TFormArtikel.SpeedButton18Click(Sender: TObject);
var
  DirEntries: TStringList;
  n: Integer;
begin
  DirEntries := e_r_ArtikelPDF(IB_Query1.FieldByName('RID').AsInteger);
  if DirEntries.count > 0 then
  begin
    for n := 0 to pred(DirEntries.count) do
      wanfix32.printpdf(DirEntries[n])
  end
  else
    ShowMessage('kein PDF vorhanden!');
  DirEntries.free;
end;

procedure TFormArtikel.SpeedButton19Click(Sender: TObject);
begin
  ShowMessage(e_r_ArtikelLink(IB_Query1.FieldByName('RID').AsInteger));
end;

procedure TFormArtikel.Image1Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Artikel.Import');
end;

procedure TFormArtikel.SpeedButton15Click(Sender: TObject);
var
  ImportL: TStringList;
  n: Integer;
begin
  OpenDialog1.InitialDir := iOlapPath;
  if OpenDialog1.execute then
  begin
    BeginHourGlass;
    PrepareSearch;
    ImportL := TStringList.create;
    ImportL.loadfromfile(OpenDialog1.FileName);
    with ArtikelSucheWI do
    begin
      FoundList.clear;
      FoundList.capacity := pred(ImportL.count);
      for n := 1 to pred(ImportL.count) do
        FoundList.add(pointer(strtointdef(nextp(ImportL[n], ';', 0), -1)));
    end;
    ImportL.free;
    FromFoundListToGrid(ArtikelSucheWI);
    EndHourGlass;
  end;
end;

procedure TFormArtikel.SpeedButton16Click(Sender: TObject);
begin
  // einzelner Datensatz an Word!
  FormOLAP.DoContextOLAP(IB_Grid1);
end;

procedure TFormArtikel.Button2Click(Sender: TObject);
begin
  FormArtikelPakete.show;
end;

procedure TFormArtikel.Button3Click(Sender: TObject);
var
  ARTIKEL_R: Integer;
  PERSON_R: Integer;
begin
  ARTIKEL_R := IB_Query1.FieldByName('RID').AsInteger;
  if FormPerson.TakeActual then
  begin
    PERSON_R := FormPerson.IB_Query1.FieldByName('RID').AsInteger;
    IB_Query3.insert;
    IB_Query3.FieldByName('PERSON_R').AsInteger := PERSON_R;
    IB_Query3.FieldByName('ARTIKEL_R').AsInteger := ARTIKEL_R;
    IB_Query3.post;
    IB_Query3.refresh;
    IB_Query3.locate('PERSON_R', PERSON_R, []);
  end;
end;

procedure TFormArtikel.SetContext(sql: string);
begin
  //
  BeginHourGlass;
  ChangeWhere(IB_Query1, sql);
  show;
  Button16.Enabled := true;
  EndHourGlass;
end;

procedure TFormArtikel.SetContext(RID: Integer; AA: Integer = cRID_Null);
begin
  BeginHourGlass;

  with IB_Query1 do
  begin
    qSelectOne(IB_Query1);
    ParamByName('CROSSREF').AsInteger := RID;
    Button16.Enabled := true;
  end;
  show;

  // ggf. noch auf die Darreichungsform springen
  if AA >= cRID_FirstValid then
  begin
    PageControl1.ActivePage := TabSheet3;
    IB_Query13.locate('RID', AA, []);
  end;
  EndHourGlass;
end;

procedure TFormArtikel.SetContext(RIDS: TList);
begin
  BeginHourGlass;
  with IB_Query1 do
  begin
    close;
    qSelectList(IB_Query1, RIDS);
    Open;
    Button16.Enabled := true;
  end;
  show;
  EndHourGlass;
end;

procedure TFormArtikel.Button1Click(Sender: TObject);
var
  HeaderNames: TStringList;
  SaveChanges: Boolean;
  Aenderungen: Integer;
  n, m, k: Integer;
  qARTIKEL: TIB_Query;
  ARTIKEL_R: Integer;
  Spalte: string;
  CellStr: string;
  IMPORT_R: Integer;
  MyStrL: TStringList;
  VerlagNo: string;
  XLS : TXLSFIle;
begin
  //
  if Button1.caption = 'Import' then
  begin
    BeginHourGlass;
  XLS := TXLSFIle.create(true);
    Aenderungen := 0;

    UserBreak := false;
    Button1.caption := 'Abbruch';
    with XLS do
    begin
      Open(Edit3.text);

      qARTIKEL := DataModuleDatenbank.nQuery;
      with qARTIKEL do
      begin
        sql.add('select * from ARTIKEL where RID=:CROSSREF for update');
        IMPORT_R := succ(GEN_ID('ARTIKEL_GID', 0));
        Open;
      end;

      // Spalten-Überschriften speichern
      HeaderNames := TStringList.create;
      for n := 1 to ColCountInRow(1) do
      begin
        Spalte := StrFilter(getCellValue(1, n), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ_');
        repeat
          k := pos('_', Spalte);
          if k = 1 then
            system.delete(Spalte, 1, 1);
        until k <> 1;
        HeaderNames.add(Spalte);
      end;

      // Nun der Import
      for n := 2 to RowCount do // Zeilen
      begin
        SaveChanges := false;
        try
          for m := 1 to ColCountInRow(1) do // Spalten
          begin

            Spalte := HeaderNames[pred(m)];
            if (Spalte <> '') then
            begin

              CellStr := cutblank(getCellValue(n, m));
              if (CellStr <> '') then
              begin
                repeat

                  if (Spalte = 'RID') then
                  begin
                    if not(SaveChanges) then
                    begin
                      ARTIKEL_R := strtointdef(CellStr, 0);
                      if (ARTIKEL_R > 0) then
                      begin
                        inc(Aenderungen);
                        qARTIKEL.ParamByName('CROSSREF').AsInteger := ARTIKEL_R;
                        qARTIKEL.edit;
                        SaveChanges := true;
                      end;
                      break;
                    end;
                  end;

                  if (Spalte = 'VERLAGNO') then
                  begin
                    if not(SaveChanges) then
                    begin
                      ARTIKEL_R :=
                        e_r_sql('select RID from ARTIKEL where VERLAGNO=''' +
                        CellStr + '''');
                      if (ARTIKEL_R > 0) then
                      begin
                        inc(Aenderungen);
                        qARTIKEL.ParamByName('CROSSREF').AsInteger := ARTIKEL_R;
                        qARTIKEL.edit;
                        SaveChanges := true;
                      end
                      else
                      begin
                        VerlagNo := CellStr;
                      end;
                      break;
                    end;
                  end;

                  if (Spalte = 'SORTIMENT') then
                  begin
                    if not(SaveChanges) then
                    begin
                      qARTIKEL.ParamByName('CROSSREF').AsInteger :=
                        e_w_ArtikelNeu(strtoint(CellStr));
                      qARTIKEL.edit;
                      qARTIKEL.FieldByName('IMPORT_RID').AsInteger := IMPORT_R;
                      qARTIKEL.FieldByName('VERLAGNO').AsString := VerlagNo;
                      SaveChanges := true;
                    end;
                    break;
                  end;

                  if (Spalte = 'KOMPONIST') then
                  begin
                    qARTIKEL.FieldByName('KOMPONIST_R').AsInteger :=
                      e_w_MusikerCheckCreate(CellStr);
                    SaveChanges := true;
                    break;
                  end;

                  if (Spalte = 'ARRANGEUR') then
                  begin
                    qARTIKEL.FieldByName('ARRANGEUR_R').AsInteger :=
                      e_w_MusikerCheckCreate(CellStr);
                    SaveChanges := true;
                    break;
                  end;

                  if (Spalte = 'KATEGORIE') then
                  begin
                    CellStr := noblank(CellStr);
                    while (CellStr <> '') do
                      FormArtikelKategorie.AddKategorie
                        (qARTIKEL.FieldByName('RID').AsInteger,
                        nextp(CellStr, ';'));
                    break;
                  end;

                  if (Spalte = 'SCHWER') then
                  begin
                    if (IB_ComboBox3.Items.IndexOf(CellStr) <> -1) then
                      qARTIKEL.FieldByName('SCHWER_GRUPPE').AsString := CellStr
                    else
                      qARTIKEL.FieldByName('SCHWER_DETAILS').AsString
                        := CellStr;
                    break;
                  end;

                  if (Spalte = 'BEM') then
                  begin
                    MyStrL := TStringList.create;
                    MyStrL.add('BEM=' + CellStr);
                    qARTIKEL.FieldByName('INTERN_INFO').assign(MyStrL);
                    MyStrL.free;
                    break;
                  end;

                  // Wert speichern
                  if (strtointdef(getCellValue(n, m), 0) > 0) then
                    qARTIKEL.FieldByName(Spalte).AsInteger :=
                      strtointdef(CellStr, 0)
                  else
                    qARTIKEL.FieldByName(Spalte).AsString := CellStr;

                  SaveChanges := true;

                until true;
              end;
            end;
          end;
        except
          on E: Exception do
          begin
            SaveChanges := false;
            if doit('Zeile ' + inttostr(n) + '' + #13 + 'Spalte "' + Spalte +
              '"' + #13 + 'Inhalt: "' + CellStr + '"' + #13 +
              '----------------------------------------' + #13 + E.Message + #13
              + '----------------------------------------' + #13 +
              'Import abbrechen', true) then
              break;
          end;
        end;
        if SaveChanges then
        begin
          qARTIKEL.post;
          SaveChanges := false;
          Label23.caption := 'Zeile ' + inttostr(n) + '/' + inttostr(RowCount) +
            '(' + inttostr(Aenderungen) + ' Änderungen)';
          application.processmessages;
        end;
        if UserBreak then
          break;
      end;
      qARTIKEL.free;
    end;
    SpeedButton2Click(Sender);
    Button1.caption := 'Import';
    Label23.caption := '-';
    XLS.free;
    EndHourGlass;
  end
  else
  begin
    Button1.caption := 'Warten';
    application.processmessages;
    UserBreak := true;
  end;
end;

end.
