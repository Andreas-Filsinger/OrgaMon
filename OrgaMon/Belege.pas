{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2018  Andreas Filsinger
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
unit Belege;

{$IFDEF CONSOLE}
{$MESSAGE FATAL 'Prüfe Abhängigkeit: Diese Unit hat GUI'}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  ExtCtrls, Grids, Mask,
  Menus, ImgList,

  // Tools
  WordIndex,

  // IB-Objects
  IB_UpdateBar,
  IB_NavigationBar,
  IB_SearchBar,
  IB_Components,
  IB_Access,
  IB_Grid,
  IB_Controls,
  IB_LocateEdit,

  // HeBu Projekt
  Buttons, ComCtrls,
  JvGIF, JvComponentBase, JvFormPlacement, IB_EditButton, System.ImageList;

type
  TFormBelege = class(TForm)
    IB_Query2: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    PopupMenu1: TPopupMenu;
    Urzustand1: TMenuItem;
    ImageList1: TImageList;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    DrawGrid1: TDrawGrid;
    Label2: TLabel;
    Label3: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    SpeedButton16: TSpeedButton;
    Button8: TButton;
    Edit1: TEdit;
    Button22: TButton;
    Button24: TButton;
    Button32: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    IB_Grid2: TIB_Grid;
    TabSheet2: TTabSheet;
    Label13: TLabel;
    Label14: TLabel;
    Label11: TLabel;
    IB_Memo1: TIB_Memo;
    IB_Memo2: TIB_Memo;
    Button3: TButton;
    Edit2: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label1: TLabel;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton17: TSpeedButton;
    SpeedButton19: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton21: TSpeedButton;
    SpeedButton22: TSpeedButton;
    SpeedButton41: TSpeedButton;
    IB_Grid1: TIB_Grid;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button20: TButton;
    StaticText2: TStaticText;
    Button28: TButton;
    Button2: TButton;
    Button18: TButton;
    Button30: TButton;
    Button33: TButton;
    Button4: TButton;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    TabSheet3: TTabSheet;
    IB_Memo3: TIB_Memo;
    SpeedButton23: TSpeedButton;
    SpeedButton24: TSpeedButton;
    JvFormStorage1: TJvFormStorage;
    IB_Edit1: TIB_Edit;
    Label4: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Label12: TLabel;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton18: TSpeedButton;
    IB_NavigationBar2: TIB_NavigationBar;
    IB_UpdateBar2: TIB_UpdateBar;
    Button5: TButton;
    Button7: TButton;
    Button10: TButton;
    Button1: TButton;
    Button16: TButton;
    Button17: TButton;
    Button11: TButton;
    Button21: TButton;
    Button6: TButton;
    Button9: TButton;
    Button23: TButton;
    StaticText1: TStaticText;
    Button25: TButton;
    Button26: TButton;
    Button27: TButton;
    Button19: TButton;
    Button29: TButton;
    Button31: TButton;
    Button34: TButton;
    IB_UpdateBar3: TIB_UpdateBar;
    Image2: TImage;
    SpeedButton27: TSpeedButton;
    SpeedButton25: TSpeedButton;
    procedure IB_Grid1GetDisplayText(Sender: TObject; ACol, ARow: Integer; var AString: string);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
    procedure IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
    procedure Button5Click(Sender: TObject);
    procedure Urzustand1Click(Sender: TObject);
    procedure IB_Grid3DblClick(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure Panel4Click(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Panel6Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure IB_Grid2DblClick(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure DrawGrid1DblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure DrawGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure IB_Query2AfterDelete(IB_Dataset: TIB_Dataset);
    procedure IB_Query2AfterPost(IB_Dataset: TIB_Dataset);
    procedure IB_Query2AfterInsert(IB_Dataset: TIB_Dataset);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure StaticText2Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure IB_Query2ConfirmDelete(Sender: TComponent; var Confirmed: Boolean);
    procedure IB_Query1ConfirmDelete(Sender: TComponent; var Confirmed: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure IB_Query2AfterScroll(IB_Dataset: TIB_Dataset);
    procedure Button19Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure Button28Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton12MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image2Click(Sender: TObject);
    procedure Button29Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure SpeedButton16Click(Sender: TObject);
    procedure SpeedButton17Click(Sender: TObject);
    procedure IB_Query1BeforePrepare(Sender: TIB_Statement);
    procedure SpeedButton17MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton18Click(Sender: TObject);
    procedure SpeedButton19Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure IB_Grid2CellGainFocus(Sender: TObject; ACol, ARow: Integer);
    procedure Button30Click(Sender: TObject);
    procedure SpeedButton20Click(Sender: TObject);
    procedure Button31Click(Sender: TObject);
    procedure IB_Query2BeforePrepare(Sender: TIB_Statement);
    procedure IB_Grid2GetDisplayText(Sender: TObject; ACol, ARow: Integer; var AString: string);
    procedure Button32Click(Sender: TObject);
    procedure Button33Click(Sender: TObject);
    procedure SpeedButton21Click(Sender: TObject);
    procedure IB_Grid1GetCellProps(Sender: TObject; ACol, ARow: Integer; AState: TGridDrawState; var AColor: TColor;
      AFont: TFont);
    procedure Button4Click(Sender: TObject);
    procedure SpeedButton22Click(Sender: TObject);
    procedure Button34Click(Sender: TObject);
    procedure SpeedButton41Click(Sender: TObject);
    procedure IB_DataSource2StateChanged(Sender: TIB_DataSource; ADataset: TIB_Dataset);
    procedure SpeedButton23Click(Sender: TObject);
    procedure SpeedButton24Click(Sender: TObject);
    procedure IB_Grid2InplaceEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SpeedButton27Click(Sender: TObject);
    procedure SpeedButton25Click(Sender: TObject);
  private

    { Private-Deklarationen }
    PERSON_R: Integer;
    ARTIKEL_AA_R: Integer;
    BelegRID: Integer;
    ItemRIDs: TList;
    LastRequestedRID: Integer;
    LastRequestedSub: TStringList;
    ArtikelSucheWI: TWordIndex;
    QuickCalcDebug: Boolean;
    Query1_SQL: TStringList;
    Query2_SQL: TStringList;
    Edit2ChangeDisabled: Boolean;
    Grid1_Col_Bearbeiter: Integer;
    Grid1_Col_Anleger: Integer;
    Grid2_Col_Bearbeiter: Integer;
    Grid2_Col_Anleger: Integer;
    Grid2_Col_AusgabeArt: Integer;
    cCOL_PAPERCOLOR: Integer;

    // Event Disabler
    DisableAfterScroll: Integer;
    DisableAutoRefreshOnActive: Boolean;
    DisablePostenEvents: Boolean;

    // Caching
    procedure ensureGrid2Cols;

    function LineDataFromRID1(RID: Integer): TStringList;
    function Grid_ARTIKEL_R: Integer;
    procedure GridRefresh;
    procedure AusSucheUebernehmen;
    procedure BerechneBeleg(var RechnungsBetrag: double; var RechnungsGewicht: Integer; NurGeliefertes: Boolean);
    procedure EnsureThatItsOpen;
    procedure ReflectHeaders;
    procedure Spool(AusgabeFName: string);
    procedure BucheVersand;
    procedure BucheDownload;
    procedure IBSwap(RID, nRID: Integer);

    procedure CreateNewOrder;
    procedure ShowQuickCalc;
    procedure ShowQuickZ;

  public

    { Public-Deklarationen }

    procedure SetContext(Kunde_rid: Integer; Beleg_rid: Integer = 0; Posten_Rid: Integer = 0); overload;
    procedure DoTheArtikelSearch;
    function getContext_PERSON_R: Integer;
    function Neu: Integer;

    // Zuweisung der HotKeys
    procedure setShortCut(pDataSource: TIB_DataSource);

    procedure mShow;
    procedure BuildCache;

  end;

var
  FormBelege: TFormBelege;

implementation

uses
  math, globals, anfix32,
  html, dbOrgaMon, gplists,
  GUIhelp, Datenbank,
  wanfix32, Geld,
  Funktionen_Basis,
  Funktionen_Buch,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  Funktionen_LokaleDaten,
  Person, main, mwst,
  Artikel, AusgangsRechnungen, BelegVersand,
  Versender, ArtikelVerlag, Lager,
  BestellArbeitsplatz, WarenBewegung, PreAuftrag,
  TierAuswahl, ArtikelKategorie, BelegRecherche,
  BBelege, ArtikelBackorder, CareTakerClient,
  QAbzeichnen, ArtikelContext, ArtikelPreis,
  Ereignis, Bearbeiter, OpenOfficePDF,
  Vertrag,
  Kontext, ArtikelAAA, BelegSuche,
  DruckSpooler, BuchBarKasse, ArtikelAusgabeartAuswahl;

{$R *.DFM}
//
// Ausgaben
// ========
//
// _EinzelPreis    (NETTO/BRUTTO je nach Schalter)
// _MwStSatz       zugehöriger MwSt Satz
// _Rabatt         % Rabatt
// _Anz            heutige Menge ~ Rechnungsmenge oder Liefermenge
// _AnzAuftrag     beauftragte Menge
// _AnzGeliefert   gelieferte Menge
// _AnzStorniert   stornierte Menge
//

procedure TFormBelege.Button1Click(Sender: TObject);
var
  RechnungsBetrag: double;
  RechnungsGewicht: Integer;
  AusgabeFName: TStringList;
  BELEG_R: Integer;
begin
  BeginHourGlass;
  BELEG_R := IB_Query1.FieldByName('RID').AsInteger;
  BerechneBeleg(RechnungsBetrag, RechnungsGewicht, CheckBox2.Checked);
  AusgabeFName := e_w_AusgabeBeleg(BELEG_R, CheckBox2.Checked, CheckBox3.Checked);
  if (AusgabeFName.count > 0) then
  begin
    e_w_DruckBeleg(BELEG_R);
    openShell(AusgabeFName[0]);
  end;
  AusgabeFName.free;
  CheckBox2.Checked := false;
  IB_Query1.refresh;
  EndHourGlass;
end;

procedure TFormBelege.FormActivate(Sender: TObject);
begin
  if not(DisableAutoRefreshOnActive) then
  begin
    EnsureThatItsOpen;
    IB_UpdateBar1.BtnClick(ubRefreshAll);
    IB_UpdateBar2.BtnClick(ubRefreshAll);
    Button20.Enabled := (SpoolDir <> '');
    ShowQuickZ;
  end;
end;

procedure TFormBelege.IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
var
  BelegIntern: TStringList;
begin
  with IB_Dataset do
  begin

    // Sicherstellen, das eine Person eingetragen ist
    if FieldByName('PERSON_R').IsNull then
      FieldByName('PERSON_R').AsInteger := PERSON_R;

    // Sicherstellen, dass die Sub Budget Eintragung gemacht wird.
    BelegIntern := TStringList.create;
    FieldByName('INTERN_INFO').AssignTo(BelegIntern);
    if (Edit2.text <> '*') and ((BelegIntern.values['SUB_BUDGET'] <> '') or (BelegIntern.values['SUB_BUDGET'] <> '*'))
    then
    begin
      BelegIntern.values['SUB_BUDGET'] := Edit2.text;
      FieldByName('INTERN_INFO').Assign(BelegIntern);
    end;
    BelegIntern.free;

  end;
end;

procedure TFormBelege.IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
var
  POSTEN: TIB_Cursor;
  _preis, _faktor: double;
  AUSGABEART_R: Integer;
  ARTIKEL_R: Integer;
  EINHEIT_R: Integer;
  MINDESTBESTELLMENGE : Integer;
begin
  with IB_Dataset do
  begin
    cnBELEG.addContext(BelegRID);

    FieldByName('BELEG_R').AsInteger := BelegRID;
    ARTIKEL_R := FieldByName('ARTIKEL_R').AsInteger;
    AUSGABEART_R := FieldByName('AUSGABEART_R').AsInteger;
    EINHEIT_R := FieldByName('EINHEIT_R').AsInteger;


    // Stornierungs-Aufgaben machen
    if (FieldByName('MENGE_RECHNUNG').AsInteger + FieldByName('MENGE_GELIEFERT').AsInteger = 0) then
    begin
      FieldByName('MENGE_RECHNUNG').clear;
      FieldByName('MENGE_GELIEFERT').clear;
    end;

    // ev. ungesetztes "MwSt" setzen
    if FieldByName('MWST').IsNull then
      FieldByName('MWST').AsDouble := iMwStSatzManuelleArtikel;

    // ev. ungesetztes "Netto"
    if (iEinzelPositionNetto <> '') then
      if FieldByName('NETTO').IsNull then
        FieldByName('NETTO').AsString := bool2cC(iEinzelPositionNetto = cIni_Activate);

    // Ausgabeart geändert?
    repeat

      if (State <> dssedit) then
        break;

      if FieldByName('ARTIKEL_R').IsNull then
        break;
      if not(FieldByName('AUSGABEART_R').IsModified) then
        break;

      // Setze Text neu
      FieldByName('ARTIKEL').AsString :=
        cutblank(e_r_Ausgabeart(AUSGABEART_R) + e_r_sqls('select TITEL from ARTIKEL where RID=' +
        inttostr(ARTIKEL_R)));

      // Setze Gewicht neu
      FieldByName('GEWICHT').AsInteger := e_r_gewicht(AUSGABEART_R, ARTIKEL_R);

      // Setze Menge neu (wenn Mindestbestellmenge unterschritten)
      if FieldByName('MENGE').AsInteger>0 then
      begin
        MINDESTBESTELLMENGE := e_r_MindestBestellmenge(AUSGABEART_R, ARTIKEL_R);
        if (MINDESTBESTELLMENGE>0) then
         if (FieldByName('MENGE').AsInteger<MINDESTBESTELLMENGE) then
          FieldByName('MENGE').AsInteger := MINDESTBESTELLMENGE;
      end;

      // Setze Preis neu
      e_w_SetPostenPreis(EINHEIT_R, AUSGABEART_R, ARTIKEL_R, PERSON_R, IB_Query2);

      if FieldByName('AUSGABEART_R').IsNotNull then
      begin

        // Sonstige Verarbeitungs-Optionen
        case e_r_sql('select VERARBEITUNGSART from AUSGABEART where RID=' + inttostr(AUSGABEART_R)) of
          1:
            begin
              //
              FieldByName('PREIS').AsDouble := 0;
              FieldByName('ARTIKEL_R').clear;
            end;
          2:
            begin
              //
              FieldByName('PREIS').clear;
            end;
          3:
            begin
              //
              FieldByName('MWST').AsDouble := e_r_Prozent(1);
              FieldByName('PREIS').AsDouble := 0.99;
              FieldByName('GEWICHT').AsInteger := 0;
            end;
        end;

      end;
    until true;

    if (State = dssedit) then
    begin

      if FieldByName('PREIS').IsModified and (ARTIKEL_R > 0) then
        FormArtikelPreis.SetContext(AUSGABEART_R, ARTIKEL_R, FieldByName('PREIS').AsDouble,
          FieldByName('RID').AsInteger);

      // Nachträgliche Textänderungen
      if FieldByName('MENGE_GELIEFERT').AsInteger > 0 then
        if FieldByName('ARTIKEL').IsModified then
          if not(doit('Es wurde bereits geliefert!' + #13 + 'Sind Sie sicher das der Text geändert werden kann'))
          then
            FieldByName('ARTIKEL').Revert;

      // Faktor Berechungen
      if not (iKommaFaktor) then
      if FieldByName('FAKTOR').IsNotNull then
      begin

          // alten (ehemaligen) Preis finden!
          if FieldByName('FAKTOR').AsDouble = 0 then
            FieldByName('FAKTOR').AsDouble := 1;

          //
          POSTEN := DataModuleDatenbank.nCursor;
          with POSTEN do
          begin
            sql.add('SELECT PREIS,FAKTOR FROM POSTEN WHERE RID=' + inttostr(IB_Dataset.FieldByName('RID').AsInteger));
            APiFirst;
            _preis := FieldByName('PREIS').AsDouble;
            _faktor := FieldByName('FAKTOR').AsDouble;
            if (_faktor = 0) then
              _faktor := 1;
            close;
          end;

          repeat

            if (FieldByName('FAKTOR').AsDouble <> _faktor) and (FieldByName('PREIS').AsDouble = _preis) then
            begin
              // Änderung des Faktors -> Preis anpassen
              FieldByName('PREIS').AsDouble := cPreisRundung((_preis / _faktor) * FieldByName('FAKTOR').AsDouble);
              break;
            end;

            if (FieldByName('PREIS').AsDouble <> _preis) and (FieldByName('FAKTOR').AsDouble = _faktor) and (_preis <> 0)
            then
            begin
              // Änderung des Preises -> Faktor anpassen
              FieldByName('FAKTOR').AsDouble := cPreisRundung(FieldByName('PREIS').AsDouble / (_preis / _faktor));
              break;
            end;

          until true;
          POSTEN.free;

      end;
    end;
  end;
  Label4.caption := '';
  if not(DisablePostenEvents) then
    ShowQuickCalc;
end;

procedure TFormBelege.IB_Query2BeforePrepare(Sender: TIB_Statement);
begin
  LoadHeaderSettings(IB_Grid2, AnwenderPath + HeaderSettingsFName(IB_Grid2));
  Grid2_Col_Bearbeiter := -2;
  Grid2_Col_Anleger := -2;
end;

procedure TFormBelege.BerechneBeleg(var RechnungsBetrag: double; var RechnungsGewicht: Integer;
  NurGeliefertes: Boolean);
var
  BerechneteInfos: TStringList;
  BELEG_R: Integer;
begin
  BeginHourGlass;
  BELEG_R := IB_Query1.FieldByName('RID').AsInteger;
  cnBELEG.addContext(BELEG_R);

  // Auto-Post
  if (IB_Query2.State = dssedit) then // 2=Detail
    IB_Query2.post;
  if (IB_Query1.State = dssedit) then // 1=Master
    IB_Query1.post;
  BerechneteInfos := e_w_BerechneBeleg(BELEG_R, NurGeliefertes);
  Label4.caption := BerechneteInfos.values['RECHNUNGSBETRAG'];
  RechnungsBetrag := strtodouble(BerechneteInfos.values['RECHNUNGSBETRAG']);
  RechnungsGewicht := strtoint(BerechneteInfos.values['LIEFERGEWICHT']);
  BerechneteInfos.free;
  IB_UpdateBar1.BtnClick(ubRefreshAll);
  IB_UpdateBar2.BtnClick(ubRefreshAll);
  ReflectHeaders;
  EndHourGlass;
end;

procedure TFormBelege.Button5Click(Sender: TObject);
var
  RechnungsBetrag: double;
  RechnungsGewicht: Integer;
begin
  BerechneBeleg(RechnungsBetrag, RechnungsGewicht, false);
  ShowQuickCalc;
  CheckBox2.Checked := false;
end;

procedure TFormBelege.Urzustand1Click(Sender: TObject);
begin
  //
  if not(IB_Query2.FieldByName('ARTIKEL_R').IsNull) then
  begin

    IB_Query2.edit;
    e_w_SetPostenData(IB_Query2.FieldByName('ARTIKEL_R').AsInteger, IB_Query1.FieldByName('PERSON_R').AsInteger,
      IB_Query2);
    IB_Query2.post;

  end
  else
  begin
    ShowMessage('Fehler: Dieser Artikel enthält keine Referenz auf einen Artikel aus dem Bestand!');
  end;
end;

procedure TFormBelege.IB_Grid3DblClick(Sender: TObject);
begin
  AusSucheUebernehmen;
end;

function TFormBelege.Neu: Integer;

  procedure SetMM(Medium, Motivation: string);
  var
    OneChanged: Boolean;
    Vorlage: string;
  begin
    with IB_Query1 do
    begin
      OneChanged := false;

      // Medium eintragen
      if FieldByName('MEDIUM').AsString <> Medium then
      begin
        if (Medium = '') then
        begin
          FieldByName('MEDIUM').clear;
        end
        else
        begin
          FieldByName('MEDIUM').AsString := Medium;
        end;
        OneChanged := true;
      end;

      // Motovation eintragen
      if FieldByName('MOTIVATION').AsString <> Motivation then
      begin
        if (Motivation = '') then
        begin
          FieldByName('MOTIVATION').clear;
        end
        else
        begin
          FieldByName('MOTIVATION').AsString := Motivation;
          Vorlage := ExtractSegmentBetween(Motivation, '[', ']');
          if (Vorlage <> '') then
            FieldByName('VORLAGE_PREFIX').AsString := Vorlage;
        end;
        OneChanged := true;
      end;
      if OneChanged then
        post;

    end;
  end;

begin
  if iAuftragsGrundRueckfrage then
  begin
    if (FormPreAuftrag.execute <> -1) then
    begin
      BeginHourGlass;
      CreateNewOrder;
      SetMM(FormPreAuftrag.Medium, FormPreAuftrag.Motivation);
      EndHourGlass;
    end;
  end
  else
  begin
    BeginHourGlass;
    CreateNewOrder;
    SetMM(FormPreAuftrag.DefaultMedium, FormPreAuftrag.DefaultMotivation);
    EndHourGlass;
  end;
  Edit1.SetFocus;
  result := BelegRID;
end;

procedure TFormBelege.Button7Click(Sender: TObject);
begin
  // Auf den Artikel springen!
  if not(IB_Query2.FieldByName('ARTIKEL_R').IsNull) then
    FormArtikel.SetContext(IB_Query2.FieldByName('ARTIKEL_R').AsInteger);
end;

procedure TFormBelege.Button8Click(Sender: TObject);
begin
  if (ItemRIDs.count > 0) then
    FormArtikel.SetContext(Grid_ARTIKEL_R);
end;

procedure TFormBelege.Button10Click(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet2;
end;

procedure TFormBelege.IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
begin
  IB_UpdateBar1.BtnClick(ubRefreshAll);
  ShowQuickZ;
  ShowQuickCalc;
end;

procedure TFormBelege.SetContext(Kunde_rid: Integer; Beleg_rid: Integer = 0; Posten_Rid: Integer = 0);
begin
  BeginHourGlass;

  PageControl1.ActivePage := TabSheet1;

  // Parameter nachtragen
  if (Beleg_rid < cRID_FirstValid) and (Posten_Rid >= cRID_FirstValid) then
    Beleg_rid := e_r_sql('select BELEG_R from POSTEN where RID=' + inttostr(Posten_Rid));
  if (Kunde_rid < cRID_FirstValid) then
    Kunde_rid := e_r_sql('SELECT PERSON_R FROM BELEG WHERE RID=' + inttostr(Beleg_rid));

  PERSON_R := Kunde_rid;
  IB_Query1.Parambyname('CROSSREF').AsInteger := PERSON_R;

  inc(DisableAfterScroll);
  EnsureThatItsOpen;

  if (Beleg_rid >= cRID_FirstValid ) then
    IB_Query1.locate('RID', Beleg_rid, [])
  else
    IB_Query1.last;


  dec(DisableAfterScroll);

  IB_Query1AfterScroll(IB_Query1);
  IB_Query2AfterScroll(IB_Query2);

  DisableAutoRefreshOnActive := true;
  mShow;
  DisableAutoRefreshOnActive := false;

  IB_Grid2.SetFocus;
  if (Posten_Rid >= cRID_FirstValid) then
    IB_Query2.locate('RID', Posten_Rid, []);
  EndHourGlass;
end;

procedure TFormBelege.setShortCut(pDataSource: TIB_DataSource);
begin
end;

procedure TFormBelege.EnsureThatItsOpen;
begin
  if not(IB_Query1.Active) then
    IB_Query1.open;
  if not(IB_Query2.Active) then
    IB_Query2.open;
end;

procedure TFormBelege.Panel4Click(Sender: TObject);
begin
  with IB_Query1 do
  begin
    FieldByName('LIEFERANSCHRIFT_R').clear;
    post;
  end;
end;

procedure TFormBelege.Panel5Click(Sender: TObject);
begin
  with IB_Query1 do
  begin
    FieldByName('RECHNUNGSANSCHRIFT_R').clear;
    post;
  end;
end;

procedure TFormBelege.Label6Click(Sender: TObject);
begin
  if FormPerson.TakeActual then
  begin
    IB_Query1.FieldByName('LIEFERANSCHRIFT_R').AsInteger := FormPerson.IB_Query1.FieldByName('RID').AsInteger;
    IB_Query1.post;
  end;
end;

procedure TFormBelege.Label7Click(Sender: TObject);
begin
  if FormPerson.TakeActual then
  begin
    IB_Query1.FieldByName('RECHNUNGSANSCHRIFT_R').AsInteger := FormPerson.IB_Query1.FieldByName('RID').AsInteger;
    IB_Query1.post;
  end;
end;

procedure TFormBelege.Panel6Click(Sender: TObject);
begin
  FormAusgangsRechnungen.SetContext(IB_Query1.FieldByName('PERSON_R').AsInteger);
end;

procedure TFormBelege.Button12Click(Sender: TObject);
begin
  with IB_Query1 do
    if IsEmpty then
    begin
      FormAusgangsRechnungen.SetContext(PERSON_R);
    end
    else
    begin

      (*
        var
        _PERSON_R: Integer;
        if FieldByName('RECHNUNGSANSCHRIFT_R').IsNotNull then
        _PERSON_R := FieldByName('RECHNUNGSANSCHRIFT_R').AsInteger
        else
        _PERSON_R := FieldByName('PERSON_R').AsInteger;
      *)

      FormAusgangsRechnungen.SetContext(
        { } PERSON_R,
        { } IB_Query1.FieldByName('RID').AsInteger,
        { } IB_Query1.FieldByName('RECHNUNGS_BETRAG').AsDouble -
        { } IB_Query1.FieldByName('DAVON_BEZAHLT').AsDouble);
    end;
end;

procedure TFormBelege.Button13Click(Sender: TObject);
begin
  FormPerson.SetContext(IB_Query1.FieldByName('PERSON_R').AsInteger);
end;

procedure TFormBelege.Button14Click(Sender: TObject);
begin
  FormPerson.SetContext(IB_Query1.FieldByName('RECHNUNGSANSCHRIFT_R').AsInteger);
end;

procedure TFormBelege.Button15Click(Sender: TObject);
begin
  FormPerson.SetContext(IB_Query1.FieldByName('LIEFERANSCHRIFT_R').AsInteger);
end;

procedure TFormBelege.AusSucheUebernehmen;
var
  cARTIKEL: TIB_Cursor;
  cPAKET: TIB_Cursor;

  ARTIKEL_R: Integer;
  EINHEIT_R: Integer;
  AUSGABEART_R: Integer;
  MINDESTBESTELLMENGE: Integer;

  procedure InsertOne(ARTIKEL_R: Integer; MENGE: Integer);
  begin
    with IB_Query2 do
    begin
      Insert;
      EnsureHourGlass;

      // Felder vorbelegen
      FieldByName('BELEG_R').AsInteger := IB_Query1.FieldByName('RID').AsInteger;
      FieldByName('ANLEGER_R').AsInteger := sBearbeiter;
      if (MENGE = 0) then
      begin
        FieldByName('MENGE').AsInteger := 1;
      end
      else
      begin
        FieldByName('MENGE').AsInteger := MENGE;
      end;

      // Wurde eine gewisse Ausgabeart gewählt?
      if (ARTIKEL_AA_R >= cRID_FirstValid) then
      begin
        // Ausgabeart
        AUSGABEART_R := e_r_sql('select AUSGABEART_R from ARTIKEL_AA where RID=' + inttostr(ARTIKEL_AA_R));
        if (AUSGABEART_R >= cRID_FirstValid) then
          FieldByName('AUSGABEART_R').AsInteger := AUSGABEART_R;

        // Einheit
        EINHEIT_R := e_r_sql('select EINHEIT_R from ARTIKEL_AA where RID=' + inttostr(ARTIKEL_AA_R));
        if (EINHEIT_R >= cRID_FirstValid) then
          FieldByName('EINHEIT_R').AsInteger := EINHEIT_R;
      end;

      // Artikeldaten hinzusetzen
      e_w_SetPostenData(ARTIKEL_R, IB_Query1.FieldByName('PERSON_R').AsInteger, IB_Query2);
      EnsureHourGlass;

      // Menge ev. wieder auf "NULL" zwingen -> dadurch fettdruck
      if iBelegAutoSetMengeNull then
        if (MENGE = 0) then
          if (abs(FieldByName('PREIS').AsDouble) < cGeld_KleinsterBetrag) then
            FieldByName('MENGE').clear;

      post;
      EnsureHourGlass;
    end;
  end;

begin
  if not(IB_Query1.IsEmpty) then
  begin
    ARTIKEL_R := Grid_ARTIKEL_R;

    // aktuellen Artikel in den Auftrag übernehmen

    if (ARTIKEL_R >= cRID_FirstValid) then
    begin

      cARTIKEL := DataModuleDatenbank.nCursor;
      with cARTIKEL do
      begin
        sql.add('select GEWICHT,EURO,PREIS_R,MINDESTBESTELLMENGE from ARTIKEL where RID=' + inttostr(ARTIKEL_R));
        ApiFirst;
        MINDESTBESTELLMENGE := FieldByName('MINDESTBESTELLMENGE').AsInteger;
      end;

      //
      if cARTIKEL.FieldByName('GEWICHT').IsNull then
        if doit('Es ist kein Gewicht im Artikel eingetragen!' + #13 + 'Jetzt ein Gewicht eingeben?' + #13 + #13 +
          '<OK> : sie landen in der Artikeleingabe beim richtigen' + #13 +
          ' Artikel, dort das Gewicht nachtragen. "Status gelb"' + #13 +
          ' unbedingt beenden. Artikelfenster schließen, und den' + #13 +
          ' Artikel nochmal übernehmen (Doppelklick auf Artikel' + #13 + ' oder Taste "übernehmen")!' + #13 +
          '<ABBRECHEN> : der Artikel wird übernommen. Sie können später' + #13 +
          ' mit der Taste [A] den Artikel ansteuern und das Gewicht ändern!' + #13 +
          ' nach der Änderung können die Artikeldaten inerhalb der Belegzeilen' + #13 +
          ' (=Posten) mit einem rechten Mausklick, dann aktualisieren' + #13 +
          ' auf den neuesten (Gewichts-)Stand gebracht werden.') then
        begin
          FormArtikel.SetContext(ARTIKEL_R);
          exit;
        end;

      // Preis aus der Ausgabeart holen?
      ARTIKEL_AA_R := cRID_NULL;
      if cARTIKEL.FieldByName('EURO').IsNull then
        if cARTIKEL.FieldByName('PREIS_R').IsNull then
          if e_r_sql(
           {} 'select COUNT(RID) from ARTIKEL_AA where ' +
           {} ' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ')') > 0 then
          begin
            FormArtikelAAA.SetContext(ARTIKEL_R);
            ARTIKEL_AA_R := FormArtikelAAA.ARTIKEL_AA_R;
            EnsureHourGlass;
            if (ARTIKEL_AA_R = cRID_NULL) then
              exit;
            MINDESTBESTELLMENGE := e_r_sql('select MINDESTBESTELLMENGE from ARTIKEL_AA where RID='+inttostr(ARTIKEL_AA_R));
          end;

      //
      BeginHourGlass;
      DisablePostenEvents := true;

      inc(DisableAfterScroll);
      InsertOne(ARTIKEL_R, MINDESTBESTELLMENGE);
      cPAKET := DataModuleDatenbank.nCursor;
      with cPAKET do
      begin
        sql.add('select RID,PAKET_MENGE,PAKET_ARTIKEL_R,PAKET_ARTIKEL_AA_R from ARTIKEL where PAKET_R=' +
          inttostr(ARTIKEL_R));
        sql.add('order by PAKET_POSNO');
        APiFirst;
        while not(eof) do
        begin
          ARTIKEL_AA_R := cRID_NULL;
          if FieldByName('PAKET_ARTIKEL_R').IsNotNull then
          begin
            ARTIKEL_AA_R := FieldByName('PAKET_ARTIKEL_AA_R').AsInteger;
            InsertOne(FieldByName('PAKET_ARTIKEL_R').AsInteger, FieldByName('PAKET_MENGE').AsInteger)
          end
          else
            InsertOne(FieldByName('RID').AsInteger, FieldByName('PAKET_MENGE').AsInteger);
          ApiNext;
        end;
        close;
      end;
      cPAKET.free;
      dec(DisableAfterScroll);
      DisablePostenEvents := false;

      IB_UpdateBar2.BtnClick(ubRefreshAll);
      IB_Query2.last;

      Edit1.SetFocus;
      cARTIKEL.free;
      EndHourGlass;
      ShowQuickCalc;
    end;
  end;
end;

procedure TFormBelege.ShowQuickZ;
var
  Summe: double;
begin
  if (PERSON_R >= cRID_FirstValid) then
  begin
    Summe := b_r_PersonSaldo(PERSON_R);
    StaticText2.caption := format('%m', [abs(Summe)]);
    if (Summe > 0.01) then
      StaticText2.Color := clred
    else
      StaticText2.Color := cllime
  end
  else
  begin
    StaticText2.caption := '';
    StaticText2.Color := clBtnFace;
  end;
end;

procedure TFormBelege.ShowQuickCalc;
var
  eResult: TStringList;
  Summe: double;
  BELEG_R: Integer;
  ARTIKEL_R: Integer;
begin
  BELEG_R := IB_Query1.FieldByName('RID').AsInteger;
  if (BELEG_R >= cRID_FirstValid) then
  begin

    eResult := e_r_BelegInfo(BELEG_R);
    if QuickCalcDebug then
    begin
      QuickCalcDebug := false;
      ARTIKEL_R := e_r_VersandKosten(BELEG_R);
      eResult.add('Versandkosten.ARTIKEL_R=' + inttostr(ARTIKEL_R));
      if (ARTIKEL_R >= cRID_FirstValid) then
        eResult.add(format('Versandkosten=%m', [e_r_PreisBrutto(0, ARTIKEL_R)]));

      ShowMessage(HugeSingleLine(eResult));
    end;

    with eResult do
    begin
      if (IB_Query1.FieldByName('BSTATUS').AsString = 'A') then
        Summe := strtodouble(values['NETTO'])
      else
        Summe := strtodouble(values['SUMME']);
      Label12.caption := values['LIEFERGEWICHT'] + 'g / ' + values['AUFTRAGSGEWICHT'] + 'g';
      StaticText1.caption := format('%m', [abs(Summe)]);
      if (Summe > 0.01) then
      begin
        // Forderung!
        repeat

          // Händler?
          if e_r_RabattFaehig(PERSON_R) then
          begin
            StaticText1.Color := clred;
            break;
          end;

          // Über dem Portofrei Betrag?
          if (strtodouble(values['AUFTRAGSSUMME']) < e_r_PortoFreiabBrutto(PERSON_R)) then
          begin
            StaticText1.Color := clred;
            break;
          end;

          StaticText1.Color := HTMLColor2TColor($FF9933);
        until true;

      end
      else
      begin
        StaticText1.Color := cllime
      end;
    end;
    eResult.free;
  end
  else
  begin
    StaticText1.caption := '';
    StaticText1.Color := clBtnFace;
    Label12.caption := '';
  end;
end;

procedure TFormBelege.Button16Click(Sender: TObject);
var
  RechnungsBetrag: double;
  RechnungsGewicht: Integer;
begin
  // Angaben zur Versand-Art bearbeiten!
  BerechneBeleg(RechnungsBetrag, RechnungsGewicht, false);
  FormBelegVersand.SetContext(IB_Query1.FieldByName('RID').AsInteger, IB_Query1.FieldByName('TEILLIEFERUNG').AsInteger);
end;

var
  LastRow: Integer = -1;
  LastBackgroundCol: TColor;
  LastFontCol: TColor;

procedure TFormBelege.IB_DataSource2StateChanged(Sender: TIB_DataSource; ADataset: TIB_Dataset);
begin
  IB_UpdateBar2.Enabled := ADataset.State <> dssedit;

end;

procedure TFormBelege.IB_Grid1GetCellProps(Sender: TObject; ACol, ARow: Integer; AState: TGridDrawState;
  var AColor: TColor; AFont: TFont);
var
  PAPERCOLOR: string;

begin
  // Im Status "gelb" bitte GAR nix zeichnen oder verändern,
  // sonst wird verhindert dass man den wichtigen geändert sTatus überhuapt
  // als user erkennen und sehen kann!
  if (IB_Query1.State = dssedit) then
    exit;

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

procedure TFormBelege.IB_Grid1GetDisplayText(Sender: TObject; ACol, ARow: Integer; var AString: string);
begin
  if (Grid1_Col_Bearbeiter = -2) then
  begin
    Grid1_Col_Bearbeiter := HeaderACol(IB_Grid1, 'BEARBEITER_R');
    Grid1_Col_Anleger := HeaderACol(IB_Grid1, 'ANLEGER_R');
  end;
  if (ARow > 0) then
  begin
    if (AString <> '') then
      if (ACol = Grid1_Col_Bearbeiter) or (ACol = Grid1_Col_Anleger) then
        AString := FormBearbeiter.FetchKURZFromRID(strtointdef(AString, 0));
  end;
end;

procedure TFormBelege.CreateNewOrder;
var
  BELEG_R: Integer;
begin
  BeginHourGlass;

  inc(DisableAfterScroll);
  BELEG_R := e_w_BelegNeu(PERSON_R);
  cnBELEG.addContext(BELEG_R);
  LastRow := -1;
  IB_Query1.RefreshKeys;
  dec(DisableAfterScroll);

  //
  if not(IB_Query1.locate('RID', BELEG_R, [])) then
    ShowMessage('Beleg nach Neuanlage nicht mehr gefunden!');

  EndHourGlass;
end;

procedure TFormBelege.IB_Grid2CellGainFocus(Sender: TObject; ACol, ARow: Integer);
begin
  setShortCut(IB_DataSource2);
end;

procedure TFormBelege.IB_Grid2DblClick(Sender: TObject);
begin
  Button7.click;
end;

procedure TFormBelege.ensureGrid2Cols;
begin
  if (Grid2_Col_Bearbeiter = -2) then
  begin
    Grid2_Col_Bearbeiter := HeaderACol(IB_Grid2, 'BEARBEITER_R');
    Grid2_Col_Anleger := HeaderACol(IB_Grid2, 'ANLEGER_R');
    Grid2_Col_AusgabeArt := HeaderACol(IB_Grid2, 'AUSGABEART_R');
  end;
end;

procedure TFormBelege.IB_Grid2GetDisplayText(Sender: TObject; ACol, ARow: Integer; var AString: string);
begin
  ensureGrid2Cols;
  if (ARow > 0) then
  begin
    if (AString <> '') then
      if (ACol = Grid2_Col_Bearbeiter) or (ACol = Grid2_Col_Anleger) then
        AString := FormBearbeiter.FetchKURZFromRID(strtointdef(AString, 0));
  end;
end;

procedure TFormBelege.IB_Grid2InplaceEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  c: TGridCoord;
  ARTIKEL_R: Integer;
begin
  ensureGrid2Cols;
  c := IB_Grid2.FocusedCell;
  if (c.X = Grid2_Col_AusgabeArt) and (Key = VK_SPACE) then
  begin
    ARTIKEL_R := IB_Grid2.DataSource.Dataset.FieldByName('ARTIKEL_R').AsInteger;
    if (ARTIKEL_R >= cRID_FirstValid) then
    begin
      FormArtikelAusgabeartAuswahl.exec;
      if (FormArtikelAusgabeartAuswahl.AUSGABEART_R >= cRID_FirstValid) then
        IB_Grid2.DataSource.Dataset.FieldByName('AUSGABEART_R').AsInteger := FormArtikelAusgabeartAuswahl.AUSGABEART_R;
      Key := 0;
    end;
  end;
end;

procedure TFormBelege.Button17Click(Sender: TObject);
begin
  if not(IB_Query2.FieldByName('ARTIKEL_R').IsNull) then
    FormBestellArbeitsplatz.SetContext(IB_Query2.FieldByName('ARTIKEL_R').AsInteger);
end;

procedure TFormBelege.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  SubItems: TStringList;
  OutStr: string;
begin
  if (ARow >= 0) then
    with DrawGrid1.canvas do
    begin

      repeat

        if (ARow = DrawGrid1.Row) then
        begin
          brush.Color := $0080FFFF;
          break;
        end;

        if odd(ARow) then
        begin
          brush.Color := clWhite;
        end
        else
        begin
          brush.Color := clListeGrau;
        end;

      until true;

      if (ARow < ItemRIDs.count) then
      begin
        SubItems := LineDataFromRID1(Integer(ItemRIDs[ARow]));

        {
          ----------------------------------
          1: Artikelnummer (Rang)
          Menge , Schwierigkeitsgrad
          2: OK

          3: Koponistz
          Arranger

          4: Menge2/Menge3
          Lieferbarkeit
          5: preis
          ----------------------------------
        }

        {
          eSuchSubs = ( ,
          ,
          eSS_Gattung,
          ,
          ,
          ,
          ,
          ,
        }

        case ACol of
          0:
            begin
              font.size := 16;
              font.Style := [fsbold];
              if gdSelected in State then
                TextRect(Rect, Rect.left + 2, Rect.top, '»')
              else
                TextRect(Rect, Rect.left + 2, Rect.top, '');
            end;
          1:
            begin
              // Nummer / Lager
              font.size := 8;
              font.Style := [];
              TextRect(Rect, Rect.left + 5, Rect.top, SubItems[ord(eSS_Numero)] + ' (' + SubItems[ord(eSS_Rang)] + ')');
              TextOut(Rect.left + 5, Rect.top + (rYL(Rect) div 2), SubItems[ord(eSS_Menge)] + ' (Schw.: ' +
                SubItems[ord(eSS_Schwer)] + ')');
            end;
          2:
            begin
              // Titel
              if (SubItems[ord(eSS_PaperColor)] <> '') then
                brush.Color := HTMLColor2TColor(SubItems[ord(eSS_PaperColor)]);

              font.size := 8;
              font.Style := [];
              TextRect(Rect, Rect.left + 5, Rect.top, SubItems[ord(eSS_Titel)]);
              TextOut(Rect.left + 5, Rect.top + (rYL(Rect) div 2), SubItems[ord(eSS_Land)] + '-' +
                SubItems[ord(eSS_Verlag)] + ' (' + SubItems[ord(eSS_VerlagNo)] + ')')
            end;
          3:
            begin
              // arang
              font.size := 8;
              font.Style := [];
              TextRect(Rect, Rect.left + 5, Rect.top, SubItems[ord(eSS_Komponist)]);
              TextOut(Rect.left + 5, Rect.top + (rYL(Rect) div 2), SubItems[ord(eSS_Arranger)])
            end;
          4:
            begin

              // Menge / Lager
              font.size := 8;
              font.Style := [];

              // Lager:
              if (SubItems[ord(eSS_lager)] <> '') then
                OutStr := SubItems[ord(eSS_lager)] + ':'
              else
                OutStr := '';

              // PRO/DMO stimmen
              OutStr := OutStr + SubItems[ord(eSS_MengeProbe)] + '/' + SubItems[ord(eSS_MengeDemo)];

              //
              TextRect(Rect, Rect.left + 5, Rect.top, OutStr);
              TextOut(Rect.left + 5, Rect.top + (rYL(Rect) div 2), SubItems[ord(eSS_VersendeTag)]);
            end;
          5:
            begin
              // Preis
              font.size := 8;
              font.Style := [];
              TextRect(Rect, Rect.left + 5, Rect.top, SubItems[ord(eSS_Preis)]);
              TextOut(Rect.left + 5, Rect.top + (rYL(Rect) div 2), SubItems[ord(eSS_Serie)]);
            end;
        else
          FillRect(Rect);
        end;

        if (ACol > 1) then
        begin
          pen.Color := $A0A0A0;
          MoveTo(Rect.left, Rect.top);
          LineTo(Rect.left, Rect.bottom);
        end;

      end
      else
      begin
        FillRect(Rect);
      end;
    end;
end;

procedure TFormBelege.FormCreate(Sender: TObject);
begin
  StartDebug('Belege');
  ItemRIDs := TList.create;
  PageControl1.ActivePage := TabSheet1;
  with DrawGrid1, canvas do
  begin
    DefaultRowHeight := 30;
    font.Name := 'Verdana';
    font.size := 16;
    font.Color := clblack;
    ColCount := 8;
    ColWidths[0] := 17; // Pfeil
    ColWidths[1] := 112; // Nummer (Rang) / Lager
    ColWidths[2] := 430; // Titel
    ColWidths[3] := 130; // Komp / Arra
    ColWidths[4] := 102; // Menge / verfügbarkei
    ColWidths[5] := 110; // Preis
    // ClientHeight := pred(ClientHeight div DefaultRowHeight) * DefaultRowHeight;
    RowCount := 0;
  end;

  //
  Query1_SQL := TStringList.create;
  Query1_SQL.AddStrings(IB_Query1.sql);

  //
  Query2_SQL := TStringList.create;
  Query2_SQL.AddStrings(IB_Query2.sql);
end;

procedure TFormBelege.mShow;
begin
  WindowState := wsnormal;
  show;
end;

function TFormBelege.LineDataFromRID1(RID: Integer): TStringList;
var
  SubItem: TStringList;
  n: Integer;
  cARTIKEL: TIB_Cursor;
begin

  // Element im Cache?
  if LastRequestedRID = RID then
  begin
    result := LastRequestedSub;
    exit;
  end;

  // Altes Ergebnis löschen!
  if assigned(LastRequestedSub) then
    FreeAndNil(LastRequestedSub);

  // IB-Query auslesen!
  cARTIKEL := DataModuleDatenbank.nCursor;
  with cARTIKEL do
  begin
    SubItem := TStringList.create;
    LastRequestedSub := SubItem;
    LastRequestedRID := RID;

    sql.add('select TITEL,NUMERO,VERLAG_R,');
    sql.add('VERLAGNO, KOMPONIST_R,CODE,ARRANGEUR_R,RID,');
    sql.add('SCHWER_GRUPPE, SCHWER_DETAILS, LAND_R, ');
    sql.add('MINDESTBESTAND,LAGER_R,RANG, MENGE_PROBE, ');
    sql.add('MENGE_DEMO,PAPERCOLOR from ARTIKEL where RID=' + inttostr(RID));
    APiFirst;

    if eof then
    begin
      for n := 0 to pred(ord(eSS_Count)) do
        SubItem.add('');
    end
    else
    begin

      { [0] }
      SubItem.add(FieldByName('TITEL').AsString);
      { [1] }
      SubItem.add(FieldByName('NUMERO').AsString);
      { [2] }
      if FieldByName('PAPERCOLOR').IsNotNull then
        SubItem.add(TColor2HTMLColor(FieldByName('PAPERCOLOR').AsInteger))
      else
        SubItem.add('');
      { [3] }
      SubItem.add(e_r_Verlag_PERSON_R(FieldByName('VERLAG_R').AsInteger));
      { [4] }
      SubItem.add(''); // ehemals Serie, jetzt Frei!
      { [5] }
      if iGOT then
        SubItem.add(FieldByName('VERLAGNO').AsString)
      else
        SubItem.add(e_r_MusikerName(FieldByName('KOMPONIST_R').AsInteger));
      { [6] }
      if iGOT then
        SubItem.add(FieldByName('CODE').AsString)
      else
        SubItem.add(e_r_MusikerName(FieldByName('ARRANGEUR_R').AsInteger));
      { [7] }
      SubItem.add(e_r_PreisText(0, FieldByName('RID').AsInteger));
      { [8] }
      SubItem.add(FieldByName('SCHWER_GRUPPE').AsString + ' ' + FieldByName('SCHWER_DETAILS').AsString);
      { [9] }
      SubItem.add(e_r_LaenderISO(FieldByName('LAND_R').AsInteger));
      { [10] }
      SubItem.add(inttostr(e_r_Menge(cRID_Unset, cRID_Unset, RID)) + '/' + FieldByName('MINDESTBESTAND').AsString);
      { [11] }
      SubItem.add(e_r_LagerPlatzNameFromLAGER_R(FieldByName('LAGER_R').AsInteger));
      { [12] }
      SubItem.add(VersendetagToStr(e_r_ArtikelVersendetag(0, RID)));
      { [13] }
      SubItem.add(inttostr(trunc(FieldByName('RANG').AsDouble)));
      { [14] }
      SubItem.add(FieldByName('MENGE_PROBE').AsString);
      { [15] }
      SubItem.add(FieldByName('MENGE_DEMO').AsString);
      { [16] }
      SubItem.add(FieldByName('VERLAGNO').AsString)

    end;
  end;
  result := SubItem;
end;

procedure TFormBelege.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    DoTheArtikelSearch;
  end;
end;

procedure TFormBelege.BuildCache;
begin
  if not(assigned(ArtikelSucheWI)) then
  begin
    ArtikelSucheWI := TWordIndex.create(nil);
    ArtikelSucheWI.LoadFromFile(SearchDir + format(cArtikelSuchindexFName, [cArtikelSuchindexIntern]));
    EnsureCache_Verlag;
    EnsureCache_Musiker;
    EnsureCache_Laender;
    e_r_Preis_ensureCache;
    e_r_PreisTabelle_ensureCache;
    e_r_SortimentSatz_EnsureCache;
    e_r_PreisNativ_ensureCache;
  end
  else
  begin
    ArtikelSucheWI.ReloadIfNew;
  end;
end;

procedure TFormBelege.DoTheArtikelSearch;
var
  n: Integer;
begin
  BeginHourGlass;
  Enabled := false;
  BuildCache;
  ArtikelSucheWI.Search(Edit1.text);
  if (ArtikelSucheWI.FoundList.count > 0) then
  begin
    ItemRIDs.clear;
    ItemRIDs.capacity := ArtikelSucheWI.FoundList.count;
    for n := 0 to pred(ArtikelSucheWI.FoundList.count) do
      ItemRIDs.add(ArtikelSucheWI.FoundList[n]);
    e_r_ArtikelSortieren(ItemRIDs);
    GridRefresh;
    DrawGrid1.Row := 0;
  end
  else
  begin
    ShowMessage('Nichts gefunden!');
    Enabled := true;
    Edit1.SetFocus;
  end;
  EndHourGlass;
end;

procedure TFormBelege.DrawGrid1DblClick(Sender: TObject);
begin
  AusSucheUebernehmen;
end;

function TFormBelege.Grid_ARTIKEL_R: Integer;
begin
  if (ItemRIDs.count > 0) then
    result := Integer(ItemRIDs[DrawGrid1.Row])
  else
    result := -1;
end;

procedure TFormBelege.GridRefresh;
begin
  LastRequestedRID := -1;
  Label3.caption := inttostr(ItemRIDs.count);
  DrawGrid1.RowCount := ItemRIDs.count;
  DrawGrid1.refresh;
  Enabled := true;
  DrawGrid1.SetFocus;
end;

procedure TFormBelege.ReflectHeaders;
var
  HugeAllText: TStringList;
  SingleText: TStringList;
  n, TrueLines: Integer;
  NewStr: string;
  AusgangsRechnungen: TStringList;
  OutStr: TStringList;
  PortoAb: double;
  AUFTRAGGEBER_R: Integer;
begin
  BeginHourGlass;

  // POSTEN Kontext
  AUFTRAGGEBER_R := IB_Query1.FieldByName('PERSON_R').AsInteger;
  BelegRID := IB_Query1.FieldByName('RID').AsInteger;
  IB_Query2.Parambyname('CROSSREF').AsInteger := BelegRID;

  // Rechnungsbetrag
  Label4.caption := '';

  // PERSON
  if (AUFTRAGGEBER_R >= cRID_FirstValid) then
    Label5.caption := e_r_Person(AUFTRAGGEBER_R)
  else
    Label5.caption := e_r_Person(PERSON_R);

  // RabattCode
  Label1.caption := e_r_RabattCode(PERSON_R);

  // LIEFERANSCHRIFT
  NewStr := '- dto -';
  if not(IB_Query1.FieldByName('LIEFERANSCHRIFT_R').IsNull) then
  begin
    Button15.Enabled := true;
    NewStr := e_r_Person(IB_Query1.FieldByName('LIEFERANSCHRIFT_R').AsInteger);
  end
  else
  begin
    Button15.Enabled := false;
  end;
  PortoAb := e_r_PortoFreiabBrutto(PERSON_R);
  if (PortoAb < MaxInt) then
    if not(e_r_RabattFaehig(PERSON_R)) then
      NewStr := NewStr + format(' (freie Lieferung ab %m)', [PortoAb]);
  Label6.caption := NewStr;

  // Rechnungsanschrift
  NewStr := '- dto -';
  if not(IB_Query1.FieldByName('RECHNUNGSANSCHRIFT_R').IsNull) then
  begin
    Button14.Enabled := true;
    NewStr := e_r_Person(IB_Query1.FieldByName('RECHNUNGSANSCHRIFT_R').AsInteger);
  end
  else
  begin
    Button14.Enabled := false;
  end;
  Label7.caption := NewStr;

  // Rechnungen teilweise schon ausgegeben?
  AusgangsRechnungen := e_r_RechnungsNummern(BelegRID);
  case AusgangsRechnungen.count of
    0:
      NewStr := '(bisher keine Rechnungen)';
    1:
      NewStr := '(RECHNUNG ' + AusgangsRechnungen[0] + ')';
  else
    NewStr := '(RECHNUNGEN ' + HugeSingleLine(AusgangsRechnungen, ', ') + ')';
  end;
  AusgangsRechnungen.free;

  TabSheet1.caption := 'Beleg Nó ' + inttostr(BelegRID) + ' ' + NewStr + ' @ ' +
    e_r_LagerPlatzNameFromLAGER_R(IB_Query1.FieldByName('LAGER_R').AsInteger);

  // Try to evaluate if there is Text inside the VALS
  HugeAllText := TStringList.create;
  SingleText := TStringList.create;
  IB_Query1.FieldByName('KUNDEN_INFO').AssignTo(SingleText);
  HugeAllText.AddStrings(SingleText);
  IB_Query1.FieldByName('VORAB_INFO').AssignTo(SingleText);
  HugeAllText.AddStrings(SingleText);

  IB_Query1.FieldByName('INTERN_INFO').AssignTo(SingleText);
  //
  Edit2ChangeDisabled := true;
  Edit2.text := SingleText.values['SUB_BUDGET'];
  if (Edit2.text = '') then
    Edit2.text := '*';
  Edit2ChangeDisabled := false;

  HugeAllText.AddStrings(SingleText);
  TrueLines := 0;
  for n := 0 to pred(HugeAllText.count) do
    if HugeAllText[n] <> '' then
    begin
      HugeAllText[n] := noblank(HugeAllText[n]);
      if HugeAllText[n] <> '' then
        if pos('~', HugeAllText[n]) = 0 then
          inc(TrueLines);
    end;

  HugeAllText.free;
  SingleText.free;
  TabSheet2.Highlighted := (TrueLines > 0);
  EndHourGlass;

  // Dialog zur Qualitätsicherung abrufen
  OutStr := q_r_PersonWarnung(IB_Query1.FieldByName('PERSON_R').AsInteger);
  if (OutStr.count > 0) then
    FormQAbzeichnen.Abzeichnen(HugeSingleLine(OutStr, #13));
  OutStr.free;

end;

procedure TFormBelege.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ssAlt in Shift then
    case Key of
      ord('p'), ord('P'):
        wanfix32.printShell(AnwenderPath + 'Rechnung.html');
    end;
end;

function TFormBelege.getContext_PERSON_R: Integer;
begin
  result := PERSON_R;
end;

procedure TFormBelege.Button20Click(Sender: TObject);
var
  RechnungsBetrag: double;
  RechnungsGewicht: Integer;
  AusgabeFName: TStringList;
  BELEG_R: Integer;
begin
  // aktuellen Beleg in das Spool Verzeichnis kopieren
  if (SpoolDir <> '') then
  begin
    BerechneBeleg(RechnungsBetrag, RechnungsGewicht, CheckBox2.Checked);
    BELEG_R := IB_Query1.FieldByName('RID').AsInteger;
    AusgabeFName := e_w_AusgabeBeleg(BELEG_R, CheckBox2.Checked, CheckBox3.Checked);
    if (AusgabeFName.count > 0) then
    begin
      e_w_DruckBeleg(BELEG_R);
      Spool(AusgabeFName[0]);
    end;
    AusgabeFName.free;
    CheckBox2.Checked := false;
  end;
end;

procedure TFormBelege.Spool(AusgabeFName: string);
begin

  FileCopy(AusgabeFName,
    { } SpoolDir +
    { } inttostrN(IB_Query1.FieldByName('RID').AsInteger, 10) +
    { } '-' +
    { } inttostrN(IB_Query1.FieldByName('TEILLIEFERUNG').AsInteger, 2) +
    { } '.html');

  FileSetAttr(
    { } SpoolDir +
    { } inttostrN(IB_Query1.FieldByName('RID').AsInteger, 10) +
    { } '-' +
    { } inttostrN(IB_Query1.FieldByName('TEILLIEFERUNG').AsInteger, 2) +
    { } '.html',
    { } faReadOnly);
end;

procedure TFormBelege.Button21Click(Sender: TObject);
begin
 IB_Grid2.top := dpix(32)-10+random(20);
 Beep;

  HeBuPlaySound(IB_Query2.FieldByName('ARTIKEL_R').AsInteger);
end;

procedure TFormBelege.Button22Click(Sender: TObject);
begin
  if (ItemRIDs.count > 0) then
    GUIhelp.HeBuPlaySound(Grid_ARTIKEL_R);
end;

procedure TFormBelege.SpeedButton1Click(Sender: TObject);
begin
  HeBuPDF(IB_Query2.FieldByName('ARTIKEL_R').AsInteger);
end;

procedure TFormBelege.SpeedButton20Click(Sender: TObject);
begin
  cnBELEG.addContext(BelegRID);
end;

procedure TFormBelege.SpeedButton21Click(Sender: TObject);
begin
  Neu;
end;

procedure TFormBelege.SpeedButton22Click(Sender: TObject);
var
  BELEG_R: Integer;
begin
  BELEG_R := IB_Query1.FieldByName('RID').AsInteger;
  if (BELEG_R >= cRID_FirstValid) then
    if doit('Wirklich keine Umsatzsteuer mehr ausweisen?') then
    begin
      e_w_BelegDrittlandAusfuhr(BELEG_R);
      Button5Click(Sender);
    end;
end;

procedure TFormBelege.SpeedButton23Click(Sender: TObject);
begin
  // aktuellen Beleg (muss offen sein) in die Bar-Kasse übernehmen
  FormBuchBarKasse.SetContext(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormBelege.SpeedButton24Click(Sender: TObject);
var
  sPath: string;
  sMask: string;
  sMainDoc, sMainDocFName: string;
  sOtherDocs: TStringList;
  bigDocument: THTMLTemplate;
  n: Integer;
begin
  sOtherDocs := TStringList.create;
  sPath := cPersonPath(PERSON_R);

  if (IB_Query1.FieldByName('BSTATUS').AsString='*') then
  begin
   sMainDoc := e_r_BelegFName(
    { } IB_Query1.FieldByName('PERSON_R').AsInteger,
    { } IB_Query1.FieldByName('RID').AsInteger,
    { } pred(IB_Query1.FieldByName('TEILLIEFERUNG').AsInteger));
  end else
  begin
   sMainDoc :=
   {} cPersonPath(IB_Query1.FieldByName('PERSON_R').AsInteger) +
    {} RIDasStr(IB_Query1.FieldByName('RID').AsInteger) +
    {} '-' +
    {} IB_Query1.FieldByName('BSTATUS').AsString +
    {} IB_Query1.FieldByName('GENERATION').AsString + '.html';
  end;
  sMask := sMainDoc;
  ersetze('.html', '*.html', sMask);

  // Beleg HTMLS zusammenführen
  bigDocument := THTMLTemplate.create;
  bigDocument.LoadFromFile(sMainDoc);
  dir(sMask, sOtherDocs, false);
  sMainDocFName := ExtractFileName(sMainDoc);

  sOtherDocs.delete(sOtherDocs.indexof(sMainDocFName));
  sOtherDocs.sort;
  for n := 0 to pred(sOtherDocs.count) do
    bigDocument.InsertDocument(sPath + sOtherDocs[n]);

  sOtherDocs.free;
  ersetze('*.html', '.combined.html', sMask);
  bigDocument.SaveToFile(sMask);
  bigDocument.free;
end;

procedure TFormBelege.SpeedButton25Click(Sender: TObject);
var
  BELEG_R: Integer;
  XYZ: TgpINtegerList;
begin
  BELEG_R := IB_Query1.FieldByName('RID').AsInteger;
  if (BELEG_R >= cRID_FirstValid) then
  begin
    XYZ := e_r_BelegLagerbedarf(BELEG_R);
    ShowMessage(
     {} 'X,Y,Z='+
     {} IntToStr(XYZ[0])+','+
     {} IntToStr(XYZ[1])+','+
     {} IntToStr(XYZ[2])+#13+
     {} 'MENGE='+IntTOstr(XYZ[3]));
    XYZ.Free;
  end;
end;

procedure TFormBelege.SpeedButton27Click(Sender: TObject);
begin
  BeginHourGlass;
  ArtikelSuchIndex;
  EndHourGlass;
end;

procedure TFormBelege.SpeedButton2Click(Sender: TObject);
begin
  if (ItemRIDs.count > 0) then
    HeBuPDF(Grid_ARTIKEL_R);
end;

procedure TFormBelege.SpeedButton41Click(Sender: TObject);
begin
  // Storno
  if doit('Beleg wirklich stornieren und Artikel wieder einlagern', true) then
  begin
    BeginHourGlass;
    e_w_BelegStorno(IB_Query1.FieldByName('RID').AsInteger);
    IB_Query1.refresh;
    EndHourGlass;
  end;
end;

procedure TFormBelege.SpeedButton4Click(Sender: TObject);
begin
  if doit('Den Inhalt des Einkaufswagen wirklich zurücklegen', true) then
    e_w_WarenkorbLeeren(PERSON_R);
end;

procedure TFormBelege.SpeedButton3Click(Sender: TObject);
begin
  BeginHourGlass;
  e_w_WarenkorbEinfuegen(IB_Query1.FieldByName('RID').AsInteger);
  IB_UpdateBar2.BtnClick(ubRefreshAll);
  EndHourGlass;
end;

procedure TFormBelege.SpeedButton5Click(Sender: TObject);
begin
  openShell('mailto:' + e_r_sqls('select EMAIL from PERSON where RID=' + inttostr(PERSON_R)));
end;

procedure TFormBelege.BucheVersand;
var
  LabelOK: Boolean;
  VerbuchenOK: Boolean;
  OutFName: string;
  VersenderName: string;
begin

  // nochmal Rückfragen
  VerbuchenOK := doit('Darf die Rechnung abgeschlossen werden');
  LabelOK := false;

  // verbuchen noch gewünscht?
  if VerbuchenOK then
  begin

    VersenderName := e_r_sqls('select BEZEICHNUNG from VERSENDER where STANDARD=''' + cC_True + '''');
    if (VersenderName <> '') then
      LabelOK := doit('Wollen Sie einen' + #13 + VersenderName + #13 + 'Datensatz schreiben');

    BeginHourGlass;
    OutFName := e_w_BelegBuchen(IB_Query1.FieldByName('RID').AsInteger, LabelOK);
    IB_Query1.refresh;
    IB_Query1AfterScroll(IB_Query1);
    EndHourGlass;
    if (OutFName='') then
    begin
      ShowMessage('Fehler beim Belegbuchen!');
    end else
    begin
    if iBelegAnzeigeNachBuchen then
      openShell(OutFName);
    end;
  end;
end;

procedure TFormBelege.BucheDownload;
begin
  BeginHourGlass;
  e_w_Buchen(
    { } IB_Query1.FieldByName('RID').AsInteger,
    { } IB_Query1.FieldByName('PERSON_R').AsInteger);
  IB_Query1.refresh;
  IB_Query1AfterScroll(IB_Query1);
  EndHourGlass;
end;

procedure TFormBelege.Button11Click(Sender: TObject);
var
  RechnungsBetrag: double;
  RechnungsGewicht: Integer;
  AusgabeFName: TStringList;
  OutPath: string;
  OutFName: string;

  BELEG_R: Integer;
  PERSON_R: Integer;
  BSTATUS: string;
  GENERATION: Integer;

  VerbuchenOK: Boolean;
  ArbeitszeitOK: Boolean;

  // Arbeitszeit
  ARBEITSZEIT_R: TgpIntegerList;
  Arbeitszeiten: THTMLAusgabe;
begin

  // Voraussetzungen prüfen:
  if not(IB_Query1.Active) then
  begin
    ShowMessage('Die Belegliste ist nicht verfügbar!');
    exit;
  end;

  if IB_Query1.eof then
  begin
    ShowMessage('Die Belegliste ist leer!');
    exit;
  end;

  if (IB_Query1.State = dssedit) then
  begin
    ShowMessage('In der Belegliste sind noch Daten ungespeichert!');
    exit;
  end;

  with IB_Query1 do
  begin
    BELEG_R := FieldByName('RID').AsInteger;
    GENERATION := FieldByName('GENERATION').AsInteger;
    PERSON_R := FieldByName('PERSON_R').AsInteger;
    BSTATUS := FieldByName('BSTATUS').AsString;
  end;

  if (BELEG_R < cRID_FirstValid) or (PERSON_R < cRID_FirstValid) then
  begin
    ShowMessage('Beleg oder Person unbekannt!');
    exit;
  end;

  // Init
  Arbeitszeiten := THTMLAusgabe.create;
  ARBEITSZEIT_R := niL;
  ArbeitszeitOK := false;
  OutPath := cPersonPath(PERSON_R);
  CheckCreateDir(OutPath);

  //
  if (BSTATUS = '*') then
  begin
    if CtrlDown then
      BucheDownload
    else
      BucheVersand;
  end
  else
  begin

    VerbuchenOK := doit('Darf der Beleg ins Dokumentverzeichnis kopiert werden');
    if VerbuchenOK then
    begin

      if FileExists(OutPath + cHTML_ArbeitszeitFName) then
      begin
        // Dieses Budget auch noch abschreiben!
        Arbeitszeiten.LoadFromFile(OutPath + cHTML_ArbeitszeitFName);
        ARBEITSZEIT_R := Arbeitszeiten.AsIntegerList('ARBEITSZEIT_R');
        if (ARBEITSZEIT_R.count > 0) then
          ArbeitszeitOK := doit('Es gibt ' + inttostr(ARBEITSZEIT_R.count) + ' Arbeitszeiten!' + #13 +
            'Dürfen diese als verbucht markiert werden');
      end;

      BeginHourGlass;
      BerechneBeleg(RechnungsBetrag, RechnungsGewicht, CheckBox2.Checked);

      if ArbeitszeitOK then
      begin
        e_w_BudgetAbschreiben(BELEG_R, OutPath + cHTML_ArbeitszeitFName);
        FileMove(OutPath + cHTML_ArbeitszeitFName,
          { } OutPath +
          { } inttostrN(BELEG_R, 10) +
          { } '-' +
          { } BSTATUS +
          { } inttostr(GENERATION) +
          { } '.' +
          { } cHTML_ArbeitszeitFName);
      end;

      AusgabeFName := e_w_AusgabeBeleg(BELEG_R, CheckBox2.Checked, CheckBox3.Checked);
      e_w_DruckBeleg(BELEG_R);
      OutFName := RIDasStr(BELEG_R) + '-' + BSTATUS + inttostr(GENERATION) + '.html';
      FileCopy(AusgabeFName[0], OutPath + OutFName);

      //
      openShell(AusgabeFName[0]);
      CheckBox2.Checked := false;
      AusgabeFName.free;

      with IB_Query1 do
      begin
        refresh;
        edit;
        FieldByName('RECHNUNGS_BETRAG').AsDouble := FieldByName('RECHNUNGS_BETRAG').AsDouble + RechnungsBetrag;
        FieldByName('DAVON_BEZAHLT').AsDouble := FieldByName('DAVON_BEZAHLT').AsDouble + RechnungsBetrag;
        post;
      end;

      EndHourGlass;
    end;
  end;
  Arbeitszeiten.free;
  if assigned(ARBEITSZEIT_R) then
    FreeAndNil(ARBEITSZEIT_R);
end;

procedure TFormBelege.SpeedButton6Click(Sender: TObject);
begin
  FormPreAuftrag.SetValues(IB_Query1.FieldByName('MEDIUM').AsString, IB_Query1.FieldByName('MOTIVATION').AsString);
  if (FormPreAuftrag.execute <> -1) then
  begin
    with IB_Query1 do
    begin
      if FieldByName('MEDIUM').AsString <> FormPreAuftrag.Medium then
        FieldByName('MEDIUM').AsString := FormPreAuftrag.Medium;
      if FieldByName('MOTIVATION').AsString <> FormPreAuftrag.Motivation then
        FieldByName('MOTIVATION').AsString := FormPreAuftrag.Motivation;
    end;
  end;
end;

procedure TFormBelege.Button6Click(Sender: TObject);
var
  RID1, POSNO1: Integer;
  RID2, POSNO2: Integer;

  procedure SetPOSNO(RID, POSNO: Integer);
  var
    POSTEN: TIB_DSQL;
  begin
    POSTEN := DataModuleDatenbank.nDSQL;
    with POSTEN do
    begin
      sql.add('UPDATE POSTEN SET POSNO = ' + inttostr(POSNO) + ' WHERE RID = ' + inttostr(RID));
      execute;
    end;
    POSTEN.free;
  end;

begin
  // UP
  with IB_Query2 do
    if not(bof) then
    begin
      // swap posno with upper neighbour
      RID2 := FieldByName('RID').AsInteger;
      POSNO2 := FieldByName('POSNO').AsInteger;
      prior;
      if not(bof) then
      begin
        RID1 := FieldByName('RID').AsInteger;
        POSNO1 := FieldByName('POSNO').AsInteger;
        if (RID1 <> RID2) then
        begin
          SetPOSNO(RID1, POSNO2);
          SetPOSNO(RID2, POSNO1);
          locate('RID', RID1, []);
        end
        else
        begin
          locate('RID', RID2, []);
        end;
      end
      else
      begin
        locate('RID', RID2, []);
        beep;
      end;
      refresh;
    end;
end;

procedure TFormBelege.Button9Click(Sender: TObject);
var
  RID1, POSNO1: Integer;
  RID2, POSNO2: Integer;

  procedure SetPOSNO(RID, POSNO: Integer);
  var
    POSTEN: TIB_DSQL;
  begin
    POSTEN := DataModuleDatenbank.nDSQL;
    with POSTEN do
    begin
      sql.add('UPDATE POSTEN SET POSNO = ' + inttostr(POSNO) + ' WHERE RID = ' + inttostr(RID));
      execute;
    end;
    POSTEN.free;
  end;

begin
  // DOWN
  with IB_Query2 do
    if not(eof) then
    begin
      // swap posno with upper neighbour
      RID2 := FieldByName('RID').AsInteger;
      POSNO2 := FieldByName('POSNO').AsInteger;
      next;
      if not(eof) then
      begin
        RID1 := FieldByName('RID').AsInteger;
        POSNO1 := FieldByName('POSNO').AsInteger;
        if (RID1 <> RID2) then
        begin
          SetPOSNO(RID1, POSNO2);
          SetPOSNO(RID2, POSNO1);
          locate('RID', RID1, []);
        end
        else
        begin
          locate('RID', RID2, []);
        end;
      end
      else
      begin
        locate('RID', RID2, []);
        beep;
      end;
      refresh;
    end;
end;

procedure TFormBelege.Button23Click(Sender: TObject);
var
  POSTEN: TIB_DSQL;
begin
  POSTEN := DataModuleDatenbank.nDSQL;
  with POSTEN do
  begin
    sql.add('UPDATE POSTEN SET POSNO = RID WHERE BELEG_R = ' + IB_Query2.FieldByName('BELEG_R').AsString);
    execute;
  end;
  POSTEN.free;
  IB_Query2.refresh;
end;

procedure TFormBelege.DrawGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if DrawGrid1.RowCount > 0 then
    if (Key = #13) then
    begin
      Key := #0;
      AusSucheUebernehmen;
    end;
end;

procedure TFormBelege.IB_Query2AfterDelete(IB_Dataset: TIB_Dataset);
begin
  ShowQuickCalc;
end;

procedure TFormBelege.IB_Query2AfterPost(IB_Dataset: TIB_Dataset);
begin
  if not(DisablePostenEvents) then
    ShowQuickCalc;
end;

procedure TFormBelege.IB_Query2AfterInsert(IB_Dataset: TIB_Dataset);
begin
  if not(DisablePostenEvents) then
  begin
    IB_Query2.post;
    IB_Grid2.SetFocus;
    IB_Query2.refresh;
    IB_Query2.last;
  end;
end;

procedure TFormBelege.Button25Click(Sender: TObject);
var
  cTIER: TIB_Cursor;
  TIER_R: Integer;
  DoInsert: Boolean;
begin
  if not(IB_Query1.IsEmpty) then
  begin

    // Tier ermitteln
    TIER_R := FormTierAuswahl.execute(PERSON_R);
    if (TIER_R > 0) then
    begin

      cTIER := DataModuleDatenbank.nCursor;
      with cTIER do
      begin
        sql.add('select * from tier where rid=' + inttostr(TIER_R));
        APiFirst;
      end;

      DoInsert := true;
      repeat
        // Noch gar nix eingegeben
        if IB_Query2.IsEmpty then
          break;
        if (IB_Query2.FieldByName('ARTIKEL').AsString = '*') or (IB_Query2.FieldByName('ARTIKEL').AsString = '') or
          (IB_Query2.FieldByName('MENGE').AsInteger = 0) then
        begin
          DoInsert := false;
          break;
        end;
      until true;

      with IB_Query2 do
      begin
        if DoInsert then
          Insert;
        edit;
        FieldByName('ARTIKEL').AsString := cTIER.FieldByName('ART').AsString + ' ' + cTIER.FieldByName('NAME').AsString;
        FieldByName('TIER_R').AsInteger := TIER_R;
        FieldByName('MWST').AsDouble := 0;
      end;
      cTIER.free;
      IB_Grid2.SetFocus;

    end;
  end;
end;

procedure TFormBelege.Button26Click(Sender: TObject);
begin
  if not(IB_Query1.IsEmpty) then
  begin
    with IB_Query2 do
    begin
      if IsEmpty then
        Insert;
      edit;
      if FieldByName('AUSFUEHRUNG').IsNull then
        FieldByName('AUSFUEHRUNG').AsDateTime := now
      else
        FieldByName('AUSFUEHRUNG').AsDateTime :=
          long2datetime(DatePlus(datetime2long(FieldByName('AUSFUEHRUNG').AsDateTime), -1));
    end;
  end;
end;

procedure TFormBelege.StaticText1Click(Sender: TObject);
begin
  QuickCalcDebug := true;
  ShowQuickCalc;
end;

procedure TFormBelege.StaticText2Click(Sender: TObject);
begin
  ShowQuickZ;
end;

procedure TFormBelege.Button27Click(Sender: TObject);
begin
  if not(IB_Query2.FieldByName('ARTIKEL_R').IsNull) then
    FormArtikelKategorie.execute(IB_Query2.FieldByName('ARTIKEL_R').AsInteger);
end;

procedure TFormBelege.Button24Click(Sender: TObject);
begin
  if (ItemRIDs.count > 0) then
    FormArtikelKategorie.execute(Grid_ARTIKEL_R);
end;

procedure TFormBelege.SpeedButton7Click(Sender: TObject);
var
  PERSON_TO_R: Integer;
begin
  with FormBelegRecherche do
  begin
    DontSetContext := true;
    showmodal;
    if (BELEG_R >= cRID_FirstValid) then
    begin
      PERSON_TO_R := e_r_sql('select PERSON_R from BELEG where RID=' + inttostr(BELEG_R));
      if (PERSON_R = PERSON_TO_R) then
        e_w_JoinBeleg(BELEG_R, FormBelege.IB_Query1.FieldByName('RID').AsInteger)
      else
        e_w_MoveBeleg(BELEG_R, PERSON_TO_R);

      FormBelege.IB_Query1.refreshall;
      FormBelege.IB_Query2.refreshall;
    end;
  end;
end;

procedure TFormBelege.SpeedButton8Click(Sender: TObject);
begin
  openShell(cPersonPath(PERSON_R));
end;

procedure TFormBelege.SpeedButton9Click(Sender: TObject);
var
  ImportL: TStringList;
  n: Integer;
begin
  OpenDialog1.InitialDir := iOlapPath;
  if OpenDialog1.execute then
  begin
    BeginHourGlass;
    ImportL := TStringList.create;
    ImportL.LoadFromFile(OpenDialog1.FileName);

    ItemRIDs.clear;
    ItemRIDs.capacity := pred(ImportL.count);
    for n := 1 to pred(ImportL.count) do
      ItemRIDs.add(pointer(strtointdef(nextp(ImportL[n], ';', 0), -1)));
    ImportL.free;

    GridRefresh;
    EndHourGlass;

  end;
end;

procedure TFormBelege.IB_Query2ConfirmDelete(Sender: TComponent; var Confirmed: Boolean);
begin
  Confirmed := false;
  with Sender as TIB_Dataset do
  begin
    if doit('Posten' + #13 + FieldByName('ARTIKEL').AsString + #13 + 'wirklich löschen', true) then
    begin
      e_w_preDeletePosten(FieldByName('RID').AsInteger);
      Confirmed := true;
    end;
  end;
end;

procedure TFormBelege.IB_Query1ConfirmDelete(Sender: TComponent; var Confirmed: Boolean);
var
  BELEG_R: Integer;
begin
  Confirmed := false;
  repeat

    if bnBilligung('BelegLöschen') then
      break;

    BELEG_R := TIB_Dataset(Sender).FieldByName('RID').AsInteger;

    if not(doit(format('Beleg|#%d|wirklich löschen', [BELEG_R]), true)) then
      break;

    if not(e_r_BelegeAusgeglichen(BELEG_R)) then
      if not(doit('Der Beleg ist nicht ausgeglichen!|' + 'Beleg dennoch löschen', true)) then
        break;

    e_w_preDeleteBeleg(BELEG_R);
    Confirmed := true;
  until true;
end;

procedure TFormBelege.Button30Click(Sender: TObject);
begin
  FormVertrag.SetContext(0, 0, IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormBelege.Button31Click(Sender: TObject);
begin
  FormVertrag.SetContext(0, 0, IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormBelege.Button32Click(Sender: TObject);
begin
  if (DrawGrid1.Row >= 0) then
  begin
    FormArtikelAAA.SetContext(Integer(ItemRIDs[DrawGrid1.Row]));
    EnsureHourGlass;
  end;
end;

procedure TFormBelege.Button33Click(Sender: TObject);
begin
  FormBelegSuche.SetContext(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormBelege.Button34Click(Sender: TObject);
var
  RechnungsBetrag: double;
  RechnungsGewicht: Integer;
  AusgabeFName: TStringList;
  BELEG_R: Integer;
begin
  BeginHourGlass;
  BELEG_R := IB_Query1.FieldByName('RID').AsInteger;
  BerechneBeleg(RechnungsBetrag, RechnungsGewicht, CheckBox2.Checked);
  AusgabeFName := e_w_AusgabeBeleg(BELEG_R, CheckBox2.Checked, CheckBox3.Checked);
  if (AusgabeFName.count > 0) then
  begin
    e_w_DruckBeleg(BELEG_R);
    printhtmlOK(AusgabeFName[0]);
  end;
  AusgabeFName.free;
  CheckBox2.Checked := false;
  IB_Query1.refresh;
  EndHourGlass;
end;

procedure TFormBelege.Button3Click(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet1;
end;

procedure TFormBelege.Button4Click(Sender: TObject);
begin
  openShell(e_r_BelegFName(
    { } IB_Query1.FieldByName('PERSON_R').AsInteger,
    { } IB_Query1.FieldByName('RID').AsInteger,
    { } pred(IB_Query1.FieldByName('TEILLIEFERUNG').AsInteger)));
end;

var
  _AfterScroll: Integer = 0;
  _AfterScrollExecuted: Integer = 0;

procedure TFormBelege.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin

  if (DisableAfterScroll = 0) then
  begin
    ShowQuickZ;
    ReflectHeaders;
    ShowQuickCalc;
    inc(_AfterScrollExecuted);
  end;

  inc(_AfterScroll);

  // Debug
  if false then
    Label1.caption :=
    { } inttostr(_AfterScrollExecuted) + '/' +
    { } inttostr(_AfterScroll);
end;

procedure TFormBelege.IB_Query2AfterScroll(IB_Dataset: TIB_Dataset);
begin
  if (DisableAfterScroll = 0) then
  begin
    with IB_Dataset do
    begin
      Button19.Enabled := e_r_ErwarteteMenge(FieldByName('AUSGABEART_R').AsInteger,
        FieldByName('ARTIKEL_R').AsInteger) > 0;
      Button7.Enabled := FieldByName('ARTIKEL_R').IsNotNull;
      Button27.Enabled := Button7.Enabled;
      Button29.Enabled := Button7.Enabled;
    end;
  end;
end;

procedure TFormBelege.Button19Click(Sender: TObject);
var
  sList: TStringList;
  sBBelege: TStringList;
  n: Integer;
begin
  sList := TStringList.create;
  sBBelege := TStringList.create;
  with IB_Query2 do
    e_r_ErwarteteMenge(FieldByName('AUSGABEART_R').AsInteger, FieldByName('ARTIKEL_R').AsInteger, sList);
  if (sList.count > 0) then
  begin
    for n := 0 to pred(sList.count) do
      sBBelege.add(nextp(sList[n], ';', 1));
    RemoveDuplicates(sBBelege);
    if (sBBelege.count > 1) then
      ShowMessage('Warnung: Der Artikel wird in mehreren Ordern erwartet:' + #13 + HugeSingleLine(sBBelege, #13));
    FormBBelege.SetContext(0, strtoint(nextp(sList[0], ';', 1)), strtoint(nextp(sList[0], ';', 0)));
  end;
  sBBelege.free;
  sList.free;
end;

procedure TFormBelege.SpeedButton11Click(Sender: TObject);
begin
  with FormBelegRecherche do
  begin
    DontSetContext := true;
    showmodal;
    if (BELEG_R > 0) then
    begin
      e_w_CopyBeleg(BELEG_R, PERSON_R);
      FormBelege.IB_Query1.refreshall;
      FormBelege.IB_Query1.last;
      FormBelege.IB_Query2.refreshall;
    end;
  end;
end;

procedure TFormBelege.SpeedButton10Click(Sender: TObject);
var
  ImportL: TStringList;
  n: Integer;
  BELEG_R: Integer;
begin
  OpenDialog1.InitialDir := iOlapPath;
  if OpenDialog1.execute then
  begin
    BeginHourGlass;
    BELEG_R := IB_Query1.FieldByName('RID').AsInteger;
    ImportL := TStringList.create;
    ImportL.LoadFromFile(OpenDialog1.FileName);
    if doit('Soll(en) jetzt' + ' ' + inttostr(pred(ImportL.count)) + ' ' + 'Beleg(e) angelegt werden') then
      for n := 1 to pred(ImportL.count) do
        e_w_CopyBeleg(BELEG_R, strtointdef(nextp(ImportL[n], ';', 0), -1));
    ImportL.free;
    EndHourGlass;
  end;
end;

procedure TFormBelege.Button28Click(Sender: TObject);
var
  Bericht: TStringList;
begin
  Bericht := e_w_KontoInfo(PERSON_R);
  Bericht.free;
  openShell(e_r_MahnungFName(PERSON_R));
  //
  MakePDF(e_r_MahnungFName(PERSON_R), e_r_MahnungFName(PERSON_R) + '.pdf');

end;

procedure TFormBelege.SpeedButton12Click(Sender: TObject);
begin
  SaveHeaderSettings(IB_Grid2, AnwenderPath + HeaderSettingsFName(IB_Grid2));
  IB_Query2.sql.SaveToFile(DiagnosePath + HeaderSettingsFName(IB_Grid2) + '.sql.txt');
  IB_Query2.FieldsDisplayWidth.SaveToFile(DiagnosePath + HeaderSettingsFName(IB_Grid2) + '.width.txt');
end;

procedure TFormBelege.SpeedButton12MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbRight) then
    if doit('Wollen Sie die Spaltenbreiten wieder auf Standard setzen', true) then
    begin
      FileDelete(AnwenderPath + HeaderSettingsFName(IB_Grid2));
      IB_Query2.close;
      IB_Query2.sql.clear;
      IB_Query2.sql.AddStrings(Query2_SQL);
      IB_Query2.open;
    end;
end;

procedure TFormBelege.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Belege');
end;

procedure TFormBelege.Button29Click(Sender: TObject);
begin
  FormArtikelBackOrder.SetContext(
   {} IB_Query2.FieldByName('AUSGABEART_R').AsInteger,
   {} IB_Query2.FieldByName('ARTIKEL_R').AsInteger);
end;

procedure TFormBelege.SpeedButton13Click(Sender: TObject);
var
  sBudgetSettings: TStringList;
begin
  // Aufgaben:
  // Alle Bugets des Kunden, die offene Arbeitszeiten haben, auf den Beleg
  // nehmen und die entsprechende Arbeitszeit summieren.
  BeginHourGlass;
  sBudgetSettings := TStringList.create;
  IB_Query1.FieldByName('INTERN_INFO').AssignTo(sBudgetSettings);
  e_w_BudgetEinfuegen(IB_Query1.FieldByName('RID').AsInteger, Edit2.text, cRID_NULL, sBudgetSettings);
  IB_Query2.refresh;
  Button5Click(Sender);
  sBudgetSettings.free;
  EndHourGlass;
  openShell(
    { } cPersonPath(IB_Query1.FieldByName('PERSON_R').AsInteger) +
    { } cHTML_ArbeitszeitFName);
end;

procedure TFormBelege.SpeedButton14Click(Sender: TObject);
begin
  if (ItemRIDs.count > 0) then
    FormArtikelContext.SetContextArtikel(Grid_ARTIKEL_R);
end;

procedure TFormBelege.SpeedButton15Click(Sender: TObject);
begin
  if (ItemRIDs.count > 0) then
    FormArtikelContext.SetContextContext(Grid_ARTIKEL_R);
end;

procedure TFormBelege.SpeedButton16Click(Sender: TObject);
var
  cARTIKEL: TIB_Cursor;
begin
  BeginHourGlass;
  ItemRIDs.clear;
  cARTIKEL := DataModuleDatenbank.nCursor;
  with cARTIKEL do
  begin
    sql.add('select RID from ARTIKEL where ERSTEINTRAG>''' + long2date(DatePlus(DateGet, -iNeuanlageZeitraum)) + '''');
    APiFirst;
    while not(eof) do
    begin
      ItemRIDs.add(pointer(FieldByName('RID').AsInteger));
      ApiNext;
    end;
    close;
  end;
  cARTIKEL.free;
  GridRefresh;
  EndHourGlass;
end;

procedure TFormBelege.SpeedButton17Click(Sender: TObject);
begin
  SaveHeaderSettings(IB_Grid1, AnwenderPath + HeaderSettingsFName(IB_Grid1));
end;

procedure TFormBelege.IB_Query1BeforePrepare(Sender: TIB_Statement);
begin
  LoadHeaderSettings(IB_Grid1, AnwenderPath + HeaderSettingsFName(IB_Grid1));
  Grid1_Col_Bearbeiter := -2;
  Grid1_Col_Anleger := -2;
  cCOL_PAPERCOLOR := 0;
end;

procedure TFormBelege.SpeedButton17MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbRight) then
    if doit('Wollen Sie die Spaltenbreiten wieder auf Standard setzen', true) then
    begin
      FileDelete(AnwenderPath + HeaderSettingsFName(IB_Grid1));
      IB_Query1.close;
      IB_Query1.sql.clear;
      IB_Query1.sql.AddStrings(Query1_SQL);
      IB_Query1.open;
    end;
end;

procedure TFormBelege.IBSwap(RID, nRID: Integer);
var
  qRids: TgpIntegerList;
  qPosNo: TgpIntegerList;
  cPOSTEN: TIB_Cursor;
  StartFlag: Boolean;
  n: Integer;
  POSNO: Integer;
begin
  if (RID >= cRID_FirstValid) and (nRID >= cRID_FirstValid) then
  begin

    qRids := TgpIntegerList.create;
    qPosNo := TgpIntegerList.create;
    cPOSTEN := DataModuleDatenbank.nCursor;
    with cPOSTEN do
    begin

      // das SQL
      sql.add('select POSNO,RID from POSTEN where');
      sql.add(' (BELEG_R=' + IB_Query1.FieldByName('RID').AsString + ') ');
      sql.add('order by');
      sql.add(' POSNO,RID');

      // die Runde
      StartFlag := false;
      APiFirst;
      while not(eof) do
      begin
        StartFlag := StartFlag or (FieldByName('RID').AsInteger = RID);
        if StartFlag then
        begin
          qRids.add(FieldByName('RID').AsInteger);
          qPosNo.add(FieldByName('POSNO').AsInteger);
        end;
        ApiNext;
      end;

    end;
    cPOSTEN.free;

    // das Umschreiben der Reihenfolge
    POSNO := qPosNo[0];
    for n := 0 to qPosNo.count - 2 do
      qPosNo[n] := qPosNo[n + 1];
    qPosNo[pred(qPosNo.count)] := POSNO;

    // jetzt die neuen Nummern setzen
    for n := 0 to pred(qRids.count) do
      e_x_sql('update POSTEN set POSNO=' + inttostr(qPosNo[n]) + ' where RID=' + inttostr(qRids[n]));

    qRids.free;
    qPosNo.free;
  end;
end;

procedure TFormBelege.SpeedButton18Click(Sender: TObject);
var
  BELEG_R: Integer;
  BELEG_R_Neu: Integer;
begin
  BELEG_R := IB_Query2.FieldByName('RID').AsInteger;
  if (BELEG_R >= cRID_FirstValid) then
  begin
    BELEG_R_Neu := e_w_gen('POSTEN_GID');

    if (BELEG_R_Neu >= cRID_FirstValid) then
    begin

      // Startpunkt der Umbenennung bestimmen
      with IB_Query2 do
      begin
        DisableControls;
        Insert;
        FieldByName('RID').AsInteger := BELEG_R_Neu;
        post;

        // Alle RIDs, POSNOs aufzeichnen
        IBSwap(BELEG_R, BELEG_R_Neu);
        refresh;
        locate('RID', BELEG_R_Neu, []);

        EnableControls;
      end;
    end
    else
    begin
      beep;
    end;
  end
  else
  begin
    beep;
  end;
end;

procedure TFormBelege.SpeedButton19Click(Sender: TObject);
var
  BELEG_R: Integer;
begin
  BELEG_R := e_w_BelegNeuAusWarenkorb(PERSON_R);
  IB_Query1.refresh;
  IB_Query1.locate('RID', BELEG_R, []);
end;

procedure TFormBelege.Edit2Change(Sender: TObject);
begin
  with IB_Query1 do
    if not(Edit2ChangeDisabled) then
      if (State <> dssedit) then
        edit;
end;

procedure TFormBelege.Button2Click(Sender: TObject);
begin
  if not(IB_Query1.IsEmpty) then
    FormWarenBewegung.SetContext(IB_Query1.FieldByName('RID').AsInteger);
end;

procedure TFormBelege.Button18Click(Sender: TObject);
begin
  if not(IB_Query1.IsEmpty) then
    FormEreignis.SetContext_BELEG_R(IB_Query1.FieldByName('RID').AsInteger);
end;

end.
