{
  |������___                  __  __
  |�����/ _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |����| | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |����| |_| | | | (_| | (_| | |  | | (_) | | | |
  |�����\___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |���������������|___/
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
unit BBelege;
//
// ---------------------------------------------
// !BESTELL BELEGE!
// 23.05.2002, abgeleitet aus "Belege"
//
//             Irgendwie verschiedene Beleg-Modi machen
//             Bestellung,Angebot,Garantie,
// ---------------------------------------------
//
// sollte ev. wieder mit Belge verschmolzen werden.
//

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  ExtCtrls, Grids, Mask,
  Menus, ImgList,

  // Tools
  Wordindex,

  // IB-Objects
  IB_Access,
  IB_UpdateBar,
  IB_NavigationBar,
  IB_SearchBar,
  IB_Components,
  IB_Grid,
  IB_Controls,
  IB_LocateEdit,

  // HeBu Projekt
  Buttons, JvGIF, IB_EditButton;

type
  TFormBBelege = class(TForm)
    Panel1: TPanel;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_SearchBar1: TIB_SearchBar;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_Grid1: TIB_Grid;
    Panel2: TPanel;
    IB_Query2: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    IB_NavigationBar2: TIB_NavigationBar;
    IB_UpdateBar2: TIB_UpdateBar;
    IB_Grid2: TIB_Grid;
    Label1: TLabel;
    IB_Edit1: TIB_Edit;
    IB_Query3: TIB_Query;
    IB_Query4: TIB_Query;
    IB_Query5: TIB_Query;
    Panel3: TPanel;
    IB_Query6: TIB_Query;
    Button3: TButton;
    Button5: TButton;
    PopupMenu1: TPopupMenu;
    Demoaufnahme1: TMenuItem;
    Probestimme1: TMenuItem;
    Urzustand1: TMenuItem;
    Button4: TButton;
    Button7: TButton;
    Button8: TButton;
    IB_Memo1: TIB_Memo;
    Button10: TButton;
    Button11: TButton;
    Label4: TLabel;
    IB_Query7: TIB_Query;
    IB_Query8: TIB_Query;
    Label5: TLabel;
    Button1: TButton;
    CheckBox2: TCheckBox;
    Label8: TLabel;
    Panel6: TPanel;
    Button12: TButton;
    Button13: TButton;
    MwStauf01: TMenuItem;
    Button17: TButton;
    Label2: TLabel;
    Edit1: TEdit;
    DrawGrid1: TDrawGrid;
    ImageList1: TImageList;
    IB_Query9: TIB_Query;
    Label3: TLabel;
    Button18: TButton;
    IB_Query10: TIB_Query;
    IB_Query11: TIB_Query;
    Button20: TButton;
    IB_Query12: TIB_Query;
    Label6: TLabel;
    Label10: TLabel;
    Panel4: TPanel;
    Button15: TButton;
    SpeedButton1: TSpeedButton;
    Button6: TButton;
    SpeedButton12: TSpeedButton;
    Image2: TImage;
    Button2: TButton;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    SpeedButton2: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
    procedure IB_Edit1Change(Sender: TObject);
    procedure IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Demoaufnahme1Click(Sender: TObject);
    procedure Probestimme1Click(Sender: TObject);
    procedure Urzustand1Click(Sender: TObject);
    procedure IB_Grid3DblClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
    procedure Button11Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure MwStauf01Click(Sender: TObject);
    procedure IB_Grid2DblClick(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure DrawGrid1DblClick(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button20Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IB_Query2AfterScroll(IB_Dataset: TIB_Dataset);
    procedure IB_Query1ConfirmDelete(Sender: TComponent;
      var Confirmed: Boolean);
    procedure IB_Query2ConfirmDelete(Sender: TComponent;
      var Confirmed: Boolean);
    procedure Button6Click(Sender: TObject);
    procedure IB_Grid2DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton12MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure IB_Query2BeforePrepare(Sender: TIB_Statement);
    procedure Image2Click(Sender: TObject);
    procedure IB_Query2AfterOpen(IB_Dataset: TIB_Dataset);
    procedure IB_Grid2DrawFocusedCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure IB_Query2AfterPrepare(Sender: TIB_Statement);
    procedure IB_Grid2TitleClick(Sender: TObject; ACol, ARow: Integer;
      AButton: TMouseButton; AShift: TShiftState);
    procedure IB_Query2AfterPost(IB_Dataset: TIB_Dataset);
    procedure IB_Grid2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private-Deklarationen }
    PersonRID: integer;
    BelegRID: integer;
    BerechneBelegActive: boolean;
    ItemRIDs: TList;
    ItemMarked: TList;
    StatusBMPs: array of TBitMap;
    FitnessBMPs: array of TBitMap;
    LastRequestedRID: integer;
    LastRequestedSub: TStringList;
    ArtikelSucheWI: TWordIndex;
    Lastrow: integer;
    _NewCol: TColor;
    _NewStyle: TFontStyles;
    IB_Query2_SQL: TStringList;

    GridCol_Motivation: integer;
    GridCol_Vorschlag: integer;
    GridCol_Anzahl: integer;
    GridCol_ARTIKEL_R: integer;
    GridCol_AUSGABEART_R: integer;

    procedure SetPostenData(IB_Query6, IB_Query2: TIB_Query);
    procedure ReflectData;
    function CreateSymbol(id: integer): TBitMap;
    function LineDataFromRID1(RID: integer): TStringList;
    procedure DoTheArtikelSearch;
    procedure GridToIBQ6;
    procedure GridRefresh;
    procedure GridTitleRefresh;


  public

    { Public-Deklarationen }
    RechnungsBetrag: double;
    DisableAutoRefreshOnActive: boolean;

    // F�r die Preis Ermittlung und Ausgabelauf

    _Anz: integer;
    _AnzAuftrag: integer;

    _AnzGeliefert: integer;
    _AnzStorniert: integer;
    _AnzErwartet: integer; // (werden noch erwartet)
    _AnzZurueck: integer; // (wurden zur�ckgeliefert)

    _Rabatt: double;
    _EinzelPreisOhneRabatt: double;
    _EinzelPreis: double;
    _MwStSatz: double;
    PortoRIDs: TStringList;

    procedure BerechneBeleg(NurZurueck: boolean);
    procedure AusgabeRechnung3_1(NurZurueck: boolean);

    procedure SetContext(Kunde_rid: integer; Beleg_rid: integer = 0; Posten_Rid: integer = 0); overload;
    procedure EnsureThatItsOpen;
    procedure LocateArtikel(Nummer: string);
    procedure PreisErmittlung(IBQ: TIB_Query; NurZurueck: boolean); // aktuelle Zeile
    procedure Spool;
  end;

var
  FormBBelege: TFormBBelege;

implementation

uses
  globals, anfix32, html,
  Person, main, mwst, GUIHelp,
  Funktionen.Basis,
  Funktionen.Beleg,
  funktionen.Auftrag,
  Artikel, ArtikelSuchIndex,
  ArtikelVerlag, Lager,
  AusgabeArt,
  FolgeSetzen, ArtikelBackorder,
  ArtikelPreis, IBExportTable, CareTakerClient,
  gplists, OLAP, Jvgnugettext,
  Geld, Datenbank, wanfix32;

const
  cPlanY = 30;
  cPlanX = 32;

{$R *.DFM}

type
  MwstInfo = record
    satz: double;
    summe: double;
  end;

procedure TFormBBelege.PreisErmittlung(IBQ: TIB_Query; NurZurueck: boolean); // aktuelle Zeile;
begin
  with IBQ do
  begin
    if NurZurueck then
    begin
      _Anz := FieldByName('MENGE_ZURUECK').AsInteger;
      _AnzAuftrag := _Anz;
      _AnzGeliefert := 0;
      _AnzStorniert := 0;
      _AnzErwartet := 0;
    end else
    begin
      _Anz := FieldByName('MENGE_UNBESTELLT').AsInteger;
      _AnzAuftrag := FieldByName('MENGE').AsInteger;
      _AnzErwartet := FieldByName('MENGE_ERWARTET').AsInteger; // bei der letzten Bestellung bestellt
      _AnzGeliefert := FieldByName('MENGE_GELIEFERT').AsInteger; // schon im Wareneingang
      _AnzStorniert := FieldByName('MENGE_AUSFALL').AsInteger; // bei Wareneingang als nicht existent gebucht
    end;

    _Rabatt := FieldByName('RABATT').AsDouble;
    _EinzelPreisOhneRabatt := FieldByName('PREIS').AsDouble;
    if _Rabatt > 0 then
    begin
      _EinzelPreis := _EinzelPreisOhneRabatt - (_EinzelPreisOhneRabatt * (_Rabatt / 100.0));
      _EinzelPreis := cPreisRundung(_EinzelPreis);
    end else
    begin
      _EinzelPreis := _EinzelPreisOhneRabatt;
    end;
    _MwStSatz := FieldByName('MWST').AsDouble;
  end;
end;

procedure TFormBBelege.Button1Click(Sender: TObject);
begin
  BerechneBeleg(CheckBox2.Checked);
  AusgabeRechnung3_1(CheckBox2.Checked);

 // Rechnung
  openShell(AnwenderPath + cHTML_OrderFName);
  CheckBox2.Checked := false;
end;

procedure TFormBBelege.FormActivate(Sender: TObject);
begin
  if not (DisableAutoRefreshOnActive) then
  begin
    EnsureThatItsOpen;
    IB_UpdateBar1.BtnClick(ubRefreshAll);
    IB_UpdateBar2.BtnClick(ubRefreshAll);
    button20.Enabled := (SpoolDir <> '');

    ReflectData;
//  IB_UpdateBar3.BtnClick(ubRefreshAll); gab zu viele Probleme
  end;
end;

procedure TFormBBelege.IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
begin
  with IB_DATASET do
  begin
    if FieldByName('PERSON_R').IsNull then
      FieldByName('PERSON_R').AsInteger := PersonRID;
  end;
end;

procedure TFormBBelege.IB_Edit1Change(Sender: TObject);
begin
  if (IB_Edit1.Text <> '') then
    BelegRID := StrToInt(IB_Edit1.Text)
  else
    BelegRID := 0;
  IB_Query2.Params.ParamByName('CROSSREFERENCE').AsInteger := BelegRID;

  IB_Memo1.visible := false; ;
  Button10.Caption := 'I+';
  label4.caption := '';
end;

procedure TFormBBelege.IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
var
  _PreFix: string;
  AUSGABEART_R: integer;
  ARTIKEL_R: integer;
  NeuBeauftragteMenge: integer;
begin
  with IB_DATASET do
  begin
    FieldByName('BELEG_R').AsInteger := BelegRID;
    ARTIKEL_R := FieldByName('ARTIKEL_R').AsInteger;
    AUSGABEART_R := FieldByName('AUSGABEART_R').AsInteger;

    // Zusage grunds�tzlich neu eintragen
    if (ARTIKEL_R > 0) and (FieldByName('MENGE_UNBESTELLT').AsInteger > 0) then
    begin
      //
      FieldByName('ZUSAGE').AsDateTime := now + e_r_Lieferzeit(AUSGABEART_R, ARTIKEL_R);
    end;

    // Mengen Grund Logik
    NeuBeauftragteMenge := FieldByName('MENGE').AsInteger - (
      FieldByName('MENGE_UNBESTELLT').AsInteger +
      FieldByName('MENGE_ERWARTET').AsInteger +
      FieldByName('MENGE_GELIEFERT').AsInteger +
      FieldByName('MENGE_ZURUECK').AsInteger +
      FieldByName('MENGE_AUSFALL').AsInteger
      );
    if (NeuBeauftragteMenge <> 0) then
      FieldByName('MENGE_UNBESTELLT').AsInteger := FieldByName('MENGE_UNBESTELLT').AsInteger + NeuBeauftragteMenge;

    //
    if FieldByName('ARTIKEL').IsNull then
      FieldByName('ARTIKEL').AsString := '*';
    if FieldByName('MWST').IsNull then
      FieldByName('MWST').AsDouble := iMwStSatzManuelleArtikel;
    if FieldByName('MOTIVATION').IsNull then
      FieldByName('MOTIVATION').AsInteger := eT_MotivationManuell;

    if (state = dssedit) then
      if FieldByName('PREIS').IsModified then
        FormArtikelPreis.SetContext(AUSGABEART_R, ARTIKEL_R, FieldByName('PREIS').AsDouble, 0);

    if FieldByName('AUSGABEART_R').IsNotNull then
    begin
      IB_Query12.ParamByName('CROSSREF').AsInteger := FieldByName('AUSGABEART_R').AsInteger;
      if not (IB_Query12.active) then
        IB_Query12.Open;
      _PreFix := IB_Query12.FieldByName('NAME').AsString;
      if (pos(_PreFix, FieldByName('ARTIKEL').AsString) <> 1) then
        FieldByName('ARTIKEL').AsString := _PreFix + ' ' + FieldByName('ARTIKEL').AsString;
      case IB_Query12.FieldByName('VERARBEITUNGSART').AsInteger of
        1: begin
            //
            FieldByName('PREIS').AsDouble := 0;
            FieldByName('ARTIKEL_R').Clear;
            FieldByName('GEWICHT').Clear;
          end;
        2: begin
            //
            FieldByName('PREIS').clear;
            FieldByName('GEWICHT').Clear;
          end;
      end;

    end;
  end;
  label4.caption := '';
end;

procedure TFormBBelege.Button3Click(Sender: TObject);
begin
  // aktuellen Artikel in den Auftrag �bernehmen
  GridToIBQ6;

  //
  with IB_Query2 do
  begin
    Insert;
    FieldByName('ARTIKEL_R').AsInteger := IB_Query6.FieldByName('RID').AsInteger;
    FieldByName('MENGE').AsInteger := 1;
    FieldByName('MOTIVATION').AsInteger := eT_MotivationManuell;

    SetPostenData(IB_Query6, IB_Query2);
    Post;
    IB_UpdateBar2.BtnClick(ubRefreshAll);
  end;
end;

procedure TFormBBelege.SetPostenData(IB_Query6, IB_Query2: TIB_Query);
var
  MemoField: TStringList;
begin
  with IB_Query2 do
  begin
    MemoField := TStringList.create;
    IB_Query6.FieldByName('INTERN_INFO').AssignTo(MemoField);
    FieldByName('PREIS').AsDouble := e_r_PreisBrutto(0, IB_Query6.FieldByName('RID').AsInteger);
    FieldByNAme('RABATT').AsDouble := e_r_ekRabatt(IB_Query6.FieldByName('RID').AsInteger);
    FieldByName('ARTIKEL').AsString := IB_Query6.FieldByName('TITEL').AsString;
    FieldByName('GEWICHT').AsInteger := IB_Query6.FieldByName('GEWICHT').AsInteger;

    if not (IB_Query6.FieldByName('VERLAG_R').IsNull) then
      FieldByName('VERLAG_R').Assign(IB_Query6.FieldByName('VERLAG_R'))
    else
      FieldByName('VERLAG_R').clear;

  // MwSt bestimmen
    IB_Query4.ParamByName('CROSSREF').AsInteger := IB_Query6.FieldByName('SORTIMENT_R').AsInteger;
    if IB_Query4.IsEmpty then
      ShowMessage('Fehler: Sortiment nicht gefunden!');

    IB_Query5.ParamByName('CROSSREF').AsInteger := IB_Query4.FieldByName('MWST_R').AsInteger;
    if IB_Query5.IsEmpty then
      ShowMessage('Fehler: MwSt nicht gefunden!');

    FieldByName('MWST').AsDouble := IB_Query5.FieldByName('SATZ').AsDouble;
    MemoField.free;
  end;
end;

procedure TFormBBelege.BerechneBeleg(NurZurueck: boolean);
var
  _PreisProPosition: double;
  _AuftragsWert: double;
  _Summe: double;


  MwStAnz: integer;
  MwStSaver: array of MwStInfo;

  _RabattErteilt: boolean;

  // Mengen Logik
  _BeauftragteMenge: integer;
  _UnbestelltImPosten: integer;
  _UnbestelltImPostenNeu: integer;

  _SummeRechnungsMenge: integer; // Summe aller berechneter Mengen
  _SummeGelieferteMenge: integer;
  _VorschlagMenge: integer;

  procedure AddLine(Satz, Summe: double);
  var
    n: integer;
    MwStFound: boolean;
  begin
  // Suche den entsprechenden Satz
    MwStFound := false;
    for n := 0 to pred(MwStAnz) do
      if (satz = MwStSaver[n].satz) then
      begin
        MwStSaver[n].Summe := MwStSaver[n].Summe + Summe;
        MwStFound := true;
        break;
      end;

  // Gruppe neu anlegen!
    if not (MwStFound) then
    begin
      inc(MwStAnz);
      SetLength(MwStSaver, MwStAnz);
      MwStSaver[pred(MwStAnz)].Satz := Satz;
      MwStSaver[pred(MwStAnz)].Summe := Summe;
    end;
  end;

begin
  BerechneBelegActive := true;
  BeginHourGlass;

  //

  with IB_Query2 do
  begin
    disablecontrols;

    // alle "laufenden" Porto-Artikel rausschmeisen!
    if not (NurZurueck) then
    begin

      // jetzt alle Mengen verbuchen!
      // erkennen, wie die MwSt-Anteile liegen!
      _Summe := 0.0;
      _SummeRechnungsMenge := 0;
      _SummeGelieferteMenge := 0;
      MwStAnz := 0;
      _RabattErteilt := false;
      SetLength(MwStSaver, MwStAnz);
      First;
      while not (eof) do
      begin

        PreisErmittlung(IB_Query2, NurZurueck);
        if (_Rabatt <> 0.0) then
          _RabattErteilt := true;

        _SummeRechnungsMenge := _SummeRechnungsMenge + FieldByName('MENGE_UNBESTELLT').AsInteger;
        _SummeGelieferteMenge := _SummeGelieferteMenge + FieldByName('MENGE_GELIEFERT').AsInteger;

        _BeauftragteMenge := FieldByName('MENGE').AsInteger - (
          FieldByName('MENGE_UNBESTELLT').AsInteger +
          FieldByName('MENGE_ERWARTET').AsInteger +
          FieldByName('MENGE_GELIEFERT').AsInteger +
          FieldByName('MENGE_ZURUECK').AsInteger +
          FieldByName('MENGE_AUSFALL').AsInteger
          );

        if FieldByName('ARTIKEL_R').IsNotNull then
        begin


          with IB_Query3 do // ARTIKEL
          begin

            // Artikel ansteuern!
            ParamByName('CROSSREF').AsInteger := IB_query2.FieldByName('ARTIKEL_R').AsInteger;
            if IsEmpty then
              ShowMessage('Fehler: Artikel nicht mehr gefunden!');

          end;

          _VorschlagMenge := e_r_VorschlagMenge(
            FieldByName('AUSGABEART_R').AsInteger,
            FieldByName('ARTIKEL_R').AsInteger);


        end else
        begin
          _VorschlagMenge := 0;
        end;

        if (_BeauftragteMenge <> 0) then
        begin
          _UnbestelltImPosten := FieldByName('MENGE_UNBESTELLT').AsInteger;
          _UnbestelltImPostenNeu := _UnbestelltImPosten + _BeauftragteMenge;
          _SummeRechnungsMenge := _SummeRechnungsMenge + (_UnbestelltImPostenNeu - _UnbestelltImPosten);
        end;

        if (_VorschlagMenge <> FieldByNAme('MENGE_VORSCHLAG').AsInteger) or
          ((_VorschlagMenge = 0) and FieldByName('MENGE_VORSCHLAG').IsNotNull) or
          (_UnbestelltImPostenNeu <> FieldByName('MENGE_UNBESTELLT').AsInteger) or
          ((_UnbestelltImPostenNeu = 0) and FieldByName('MENGE_UNBESTELLT').IsNotNull)
          then
        begin

          edit;
          if (_UnbestelltImPostenNeu <> 0) then
            FieldByName('MENGE_UNBESTELLT').AsInteger := _UnbestelltImPostenNeu
          else
            FieldByName('MENGE_UNBESTELLT').clear;

          if (_VorschlagMenge <> 0) then
            FieldByName('MENGE_VORSCHLAG').AsInteger := _VorschlagMenge
          else
            FieldByName('MENGE_VORSCHLAG').clear;

          post;

        end;





        _PreisProPosition := _EinzelPreis * _Anz;
        AddLine(_MwStSatz, _PreisProPosition);
        _Summe := _Summe + _PreisProPosition;

        next;
      end;

      if (_SummeRechnungsMenge > 0) or
        ((_SummeGelieferteMenge > 0) and (IB_query1.FieldByName('BESTELLT').IsNull)) then
      begin

        with IB_Query1 do
        begin
          edit;
          FieldByName('BESTELLT').AsDateTime := now;
          post;
        end;

      end;

      // jetzt erst mal den Auftrags-Wert bestimmen!
      _AuftragsWert := 0.0;
      first;
      while not (eof) do
      begin
        _AuftragsWert := _AuftragsWert + FieldByName('MENGE').AsInteger * FieldByName('PREIS').AsDouble;
        next;
      end;

      e_w_BBelegStatusBuchen(IB_Query1.FieldByName('RID').AsInteger);
    end;


    // hier Addierungslauf!!!
    _Summe := 0.0;
    MwStAnz := 0;
    SetLength(MwStSaver, MwStAnz);
    First;
    while not (eof) do
    begin
      PreisErmittlung(IB_Query2, NurZurueck);
      if not (FieldByName('ARTIKEL_R').IsNull) then
      begin
        with IB_Query3 do
        begin

     //
          ParamByName('CROSSREF').AsInteger := IB_query2.FieldByName('ARTIKEL_R').AsInteger;



        end;

      end;

      _PreisProPosition := _EinzelPreis * _Anz;

      AddLine(_MwStSatz, _PreisProPosition);

      _Summe := _Summe + _PreisProPosition;

      next;
    end;
    EnableControls;
  end;

  RechnungsBetrag := _summe;

  label4.caption := format('%.2m', [_summe]);

  IB_UpdateBar2.BtnClick(ubRefreshAll);
  EndHourGlass;
  BerechneBelegActive := false;
end;

procedure TFormBBelege.Button5Click(Sender: TObject);
begin
  BerechneBeleg(false);
  CheckBox2.Checked := false;
end;

procedure TFormBBelege.Demoaufnahme1Click(Sender: TObject);
const
  cProbeAufnahme = 'Demoaufnahme';
begin
  with IB_Query2 do
  begin
    if pos(cProbeAufnahme, FieldByName('ARTIKEL').AsString) = 0 then
    begin
      edit;
      FieldByName('ARTIKEL').AsString := cProbeAufnahme + ' ' + FieldByName('ARTIKEL').AsString;
      FieldByName('PREIS').AsDouble := 0;
      FieldByName('ARTIKEL_R').Clear;
      post;
    end;
  end;
end;

procedure TFormBBelege.Probestimme1Click(Sender: TObject);
const
  cProbeAufnahme = 'Probestimme';
begin
  with IB_Query2 do
  begin
    if pos(cProbeAufnahme, FieldByName('ARTIKEL').AsString) = 0 then
    begin
      edit;
      FieldByName('ARTIKEL').AsString := cProbeAufnahme + ' ' + FieldByName('ARTIKEL').AsString;
      FieldByName('PREIS').AsDouble := 0;
      FieldByName('ARTIKEL_R').Clear;
      post;
    end;
  end;
end;

procedure TFormBBelege.Urzustand1Click(Sender: TObject);
begin
  if not (IB_Query2.FieldByName('ARTIKEL_R').IsNull) then
  begin
    IB_Query3.ParamByName('CROSSREF').AsInteger := IB_Query2.FieldByName('ARTIKEL_R').AsInteger;
    if IB_Query3.IsEmpty then
      ShowMessage('Fehler: Artikel nicht gefunden!');
    IB_Query2.edit;
    SetPostenData(IB_Query3, IB_Query2);
    IB_Query2.post;
  end else
  begin
    ShowMessage('Fehler: Dieser Artikel enth�lt keine Referenz auf einen Artikel aus dem Bestand!');
  end;
end;

procedure TFormBBelege.IB_Grid3DblClick(Sender: TObject);
begin
  Button3Click(Sender);
end;

procedure TFormBBelege.Button4Click(Sender: TObject);
var
  NewRID: integer;
begin
  with IB_Query1 do
  begin
    insert;
    // start atom
    FieldByName('PERSON_R').AsInteger := PersonRID;
    post;
    NewRID := GEN_ID('GEN_BBELEG', 0);
    // end atom
    IB_UpdateBar1.BtnClick(ubRefreshAll);
    locate('RID', NewRID, []);
  end;
end;

procedure TFormBBelege.Button7Click(Sender: TObject);
begin
  // Auf den Artikel springen!
  if not (IB_Query2.FieldByName('ARTIKEL_R').IsNull) then
    FormArtikel.SetContext(IB_Query2.FieldByName('ARTIKEL_R').AsInteger);
end;

procedure TFormBBelege.Button8Click(Sender: TObject);
begin
  if (ItemRIDS.count > 0) then
  begin
    GridToIBQ6;
    FormArtikel.SetContext(IB_Query6.FieldByName('RID').AsInteger);
  end;
end;

procedure TFormBBelege.Button10Click(Sender: TObject);
begin
  IB_Memo1.visible := not (IB_Memo1.visible);
  if IB_Memo1.visible then
    Button10.Caption := 'I-'
  else
    Button10.Caption := 'I+';
end;

procedure TFormBBelege.IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
begin
  IB_UpdateBar1.BtnClick(ubRefreshAll);
end;

procedure TFormBBelege.Button11Click(Sender: TObject);
var
  OutPath: string;
  SummeAlteLieferungen: integer;
  SummeNeueLieferungen: integer;
  _Menge_Rechnung: integer;
  ARTIKEL_R: integer;
  AUSGABEART_R: integer;
  ZUSAGE: TANFiXDate;
  BelegeRIDs: TgpIntegerList;


  n: integer;

  function NoSemi(S: string): string;
  begin
    result := s;
    ersetze(';', ',', result);
  end;

  function NoKomma(S: string): string;
  begin
    result := s;
    ersetze(',', '', result);
  end;

begin
  if doit(_('Die Bestellung ist dem Lieferant schon bekannt?') + #13 +
    _('Die unbestellen Mengen k�nnen somit in die erwarteten Mengen gebucht werden')) then
  begin
    BerechneBeleg(false);
    AusgabeRechnung3_1(false);
    OutPath := MyProgramPath + 'Bestellungen\' + inttostrN(IB_query1.FieldByName('PERSON_R').AsInteger, 10) + '\';
    CheckCreateDir(Outpath);
    FileCopy(AnwenderPath + cHTML_OrderFName, Outpath +
      inttostrN(IB_Query1.FieldByName('RID').AsInteger, 10) +
      '-' +
      inttostrN(IB_Query1.FieldByName('TEILLIEFERUNG').AsInteger, 2) +
      '.html');
    FileCopy(AnwenderPath + cHTML_OrderFName, MyProgramPath + 'Bestellungskopie\' +
      inttostrN(IB_Query1.FieldByName('RID').AsInteger, 10) +
      '-' +
      inttostrN(IB_Query1.FieldByName('TEILLIEFERUNG').AsInteger, 2) +
      '.html');
    SummeAlteLieferungen := 0;
    SummeNeueLieferungen := 0;

    with IB_Query2 do
    begin
      DisableControls;
      first;
      while not (eof) do
      begin

        _Menge_Rechnung := FieldByName('MENGE_UNBESTELLT').AsInteger;
        inc(SummeAlteLieferungen, FieldByName('MENGE_GELIEFERT').AsInteger);
        ARTIKEL_R := FieldByName('ARTIKEL_R').AsInteger;


        if not (e_r_IsVersandKosten(ARTIKEL_R)) then
        begin

          AUSGABEART_R := FieldByName('AUSGABEART_R').AsInteger;
          inc(SummeNeueLieferungen, _Menge_Rechnung);

          if (ARTIKEL_R > 0) then
          begin

            // Tickets, die auf die Bestellung dieses Artikels warten abzeichnen!
            e_x_sql(
              'update TICKET set AUSGANG = ''' + cC_True + ''' where' +
              ' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') and' +
              ' (ART=' + inttostr(eT_WareBestellt) + ') and' +
              ' (AUSGANG IS NULL)'
              );

            ZUSAGE := Liefertag(DatePlus(DateGet, e_r_Lieferzeit(AUSGABEART_R, ARTIKEL_R)));

            // In den Posten die Zusage Felder neu setzen!
            // Beleg-K�pfe entsprechend ver�ndern!
            e_x_sql(
              'update POSTEN set ZUSAGE = ''' + long2date(ZUSAGE) + ''' where' +
              ' (MENGE_AGENT>0) and' +
              ' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ')'
              );

            BelegeRIDs := e_r_sqlm('select BELEG_R from POSTEN where ' +
              ' (MENGE_AGENT>0) and' +
              ' (ARTIKEL_R=' + inttostr(ARTIKEL_R) + ') ' +
              ' GROUP BY BELEG_R'

              );
            for n := 0 to pred(BelegeRIDs.count) do
              e_w_BelegStatusBuchen(BelegeRIDs[n]);

            //
            BelegeRIDs.free;

          end;

        end;

        if (_Menge_Rechnung > 0) then
        begin
          edit;
          FieldByName('MENGE_ERWARTET').AsInteger := FieldByName('MENGE_ERWARTET').AsInteger + _Menge_Rechnung;
          FieldByName('MENGE_UNBESTELLT').clear;
          post;
        end;
        next;
      end;
      EnableControls;
    end;

    // Buchungen im Beleg-Kopf
    repeat

      // Teillieferung "0"
      if (SummeNeueLieferungen = 0) then
        if not (doit(_('Die Bestellmenge ist Null!') + #13 +
          _('Trotzdem als weitere Teilbestellung verbuchen?'))) then
          break;

      //
      with IB_Query1 do
      begin

        // Rechnungs-Betrag erh�hen
        // Teillieferung erh�hen!
        edit;
        FieldByName('RECHNUNGS_BETRAG').AsDouble := FieldByName('RECHNUNGS_BETRAG').AsDouble + Rechnungsbetrag;
        FieldByName('TEILLIEFERUNG').AsInteger := FieldByName('TEILLIEFERUNG').AsInteger + 1;
        post;
      end;

    until true;
    e_w_BBelegStatusBuchen(IB_Query1.FieldByName('RID').AsInteger);
  end;
end;

procedure TFormBBelege.SetContext(Kunde_rid: integer; Beleg_rid: integer = 0; Posten_Rid: integer = 0);
begin
  BeginHourGlass;

  if (Kunde_rid < cRID_FirstValid) then
    Kunde_RID := e_r_sql('SELECT PERSON_R FROM BBELEG WHERE RID=' + inttostr(Beleg_RID));
  PersonRID := Kunde_rid;

  EnsureThatItsOpen;
  label1.caption := 'Kunde RID #' + inttostr(PersonRID);
  IB_Query1.Parambyname('CROSSREFERENCE').AsInteger := PersonRID;
  label5.caption := e_r_Person(Kunde_rid);

  if Beleg_RID > 0 then
    IB_Query1.Locate('RID', Beleg_rid, [])
  else
    IB_Query1.last;

  if (Posten_Rid > 0) then
  begin
    IB_Query2.Locate('RID', Posten_rid, []);
  end;

  show;
  IB_Grid2.SetFocus;
  EndHourGlass;
end;

procedure TFormBBelege.EnsureThatItsOpen;
begin
  if not (IB_Query1.Active) then
    IB_Query1.Open;
  if not (IB_Query2.Active) then
    IB_Query2.Open;
  if not (IB_Query3.Active) then
    IB_Query3.Open;
  if not (IB_Query4.Active) then
    IB_Query4.Open;
  if not (IB_Query5.Active) then
    IB_Query5.Open;
  if not (IB_Query6.Active) then
    IB_Query6.Open;
  if not (IB_Query7.Active) then
    IB_Query7.Open;
  if not (IB_Query8.Active) then
    IB_Query8.Open;
end;

procedure TFormBBelege.Label6Click(Sender: TObject);
begin
  if FormPerson.TakeActual then
  begin
    IB_Query1.FieldByName('LIEFERANSCHRIFT_R').AsInteger := FormPerson.IB_Query1.FieldByname('RID').AsInteger;
    IB_Query1.post;
  end;
end;

procedure TFormBBelege.Button13Click(Sender: TObject);
begin
  FormPerson.SetContext(IB_Query1.FieldByName('PERSON_R').AsInteger);
end;

procedure TFormBBelege.Button15Click(Sender: TObject);
begin
  FormPerson.SetContext(IB_Query1.FieldByName('LIEFERANSCHRIFT_R').AsInteger);
end;

procedure TFormBBelege.MwStauf01Click(Sender: TObject);
begin
  with IB_Query2 do
  begin
    if (FieldByName('MWST').AsDouble > 0.0) then
    begin
      edit;
      FieldByName('PREIS').AsDouble :=
       cPreisRundung( FieldByName('PREIS').AsDouble / (1.0 +
        (FieldByName('MWST').AsDouble / 100.0)));
      FieldByName('MWST').AsDouble := 0.0;
      post;
    end;
  end;

end;

procedure TFormBBelege.IB_Grid2DblClick(Sender: TObject);
begin
  button7.click;
end;

procedure TFormBBelege.Button17Click(Sender: TObject);
var
  ZUSAMMENHANG: integer;
  ARTIKEL_R: integer;
  AUSGABEART_R: integer;
  BuchenOK: boolean;
begin
  // Auf den Artikel springen!
  with IB_Query2 do
  begin
    Button17.enabled := false;
    if FieldByName('ARTIKEL_R').IsNotNull then
      if (FieldByName('MENGE_ERWARTET').AsInteger > 0) then
      begin
        ARTIKEL_R := FieldByName('ARTIKEL_R').AsInteger;
        AUSGABEART_R := FieldByName('AUSGABEART_R').AsInteger;
        if (e_w_SetFolge(AUSGABEART_R, ARTIKEL_R) > 1) then
          BuchenOK := FormFolgeSetzen.SetContext(AUSGABEART_R, ARTIKEL_R)
        else
          BuchenOK := true;
        if BuchenOK then
        begin
          BeginHourGlass;
          ZUSAMMENHANG := e_w_Wareneingang(
            AUSGABEART_R,
            ARTIKEL_R,
            FieldByName('MENGE_ERWARTET').AsInteger);
          if (ZUSAMMENHANG = -1) then
            ShowMessage('Es gabe Fehler - siehe Log');
          Next;
          IB_Query2.Refresh;
          IB_Query1.Refresh;
          EndHourGlass;
        end;
      end;
    Button17.enabled := true;
  end;
end;

procedure TFormBBelege.LocateArtikel(Nummer: string);
begin
  screen.cursor := crHourGlass;
  DisableAutoRefreshOnActive := true;
  show;
  application.ProcessMessages;
  IB_Query9.ParamByName('CROSSREF').AsInteger := strtoint(Nummer);
  if not (IB_Query9.Active) then
    IB_Query9.Open;
  if IB_Query9.IsEmpty then
    exit;
  ItemRIDs.clear;
  ItemRIDs.add(pointer(IB_Query9.FieldByName('RID').AsInteger));
  GridRefresh;
  screen.cursor := crDefault;
  DisableAutoRefreshOnActive := false;
end;

procedure TFormBBelege.DrawGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  SubItems: TStringList;
  xl: integer;
begin
  if arow >= 0 then
    with DrawGrid1.canvas do
    begin

      if odd(ARow) then
      begin
        brush.color := clWhite;
      end else
      begin
        brush.color := clListeGrau;
      end;

      if ARow = DrawGrid1.Row then
        brush.color := $0080FFFF;

      if (ARow < itemRIDs.count) then
      begin
        SubItems := LineDataFromRID1(integer(ItemRIDs[ARow]));

        if ItemMARKED.indexof(ItemRIDs[ARow]) <> -1 then
        begin
          if odd(ARow) then
          begin
            brush.color := HTMLColor2TColor($00CCFF);
          end else
          begin
            brush.color := HTMLColor2TColor($0099CC);
          end;
          if ARow = DrawGrid1.Row then
            brush.color := HTMLColor2TColor($99FF00);
        end;

        case ACol of
          0: begin
              font.size := 16;
              Font.Style := [fsbold];
              if gdSelected in State then
                TextRect(rect, rect.left + 2, rect.top, '�')
              else
                TextRect(rect, rect.left + 2, rect.top, '');
            end;
          1: begin
              // Nummer
              font.size := 8;
              Font.Style := [];
              TextRect(rect, rect.left + 5, rect.top, SubItems[1]);
              Font.Style := [fsbold];
              TextOut(rect.left + 5, rect.top + (rYL(Rect) div 2), SubItems[10] + ' ');
              xl := TextWidth(SubItems[10] + ' ');
              Font.Style := [];
              TextOut(rect.left + 5 + xl, rect.top + (rYL(Rect) div 2), SubItems[11]);
            end;
          2: begin
              // Titel
              font.size := 8;
              font.style := [];
              TextRect(rect, rect.left + 5, rect.top, SubItems[0]);
              TextOut(rect.left + 5, rect.top + (rYL(Rect) div 2), SubItems[9] + '-' + SubItems[3])
            end;
          3: begin
              // Status
              font.size := 8;
              font.style := [];
              TextRect(rect, rect.left + 5, rect.top, SubItems[5]);
              TextOut(rect.left + 5, rect.top + (rYL(Rect) div 2), SubItems[6])
            end;
          4: begin
              // Monteur
              font.size := 8;
              font.style := [];
              TextRect(rect, rect.left + 5, rect.top, SubItems[7]);
              TextOut(rect.left + 5, rect.top + (rYL(Rect) div 2), SubItems[8]);
            end;
        else
          FillRect(rect);
        end;

        if (ACol > 1) then
        begin
          pen.color := $A0A0A0;
          MoveTo(rect.left, rect.top);
          LineTo(rect.left, rect.bottom);
        end;

      end else
      begin
        FillRect(rect);
      end;
    end;
end;

procedure TFormBBelege.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
  GridCol_Motivation := -1;

  ItemRIDs := TList.create;
  ItemMarked := TList.create;
  with DrawGrid1, canvas do
  begin
    DefaultRowHeight := cPlanY;
    Font.Name := 'Verdana';
    Font.Size := 16;
    Font.Color := clblack;
    ColCount := 5;
    ColWidths[0] := 21; // Pfeil
    ColWidths[1] := 82; // Nummer
    ColWidths[2] := 430; // Titel
    ColWidths[3] := 180; // Komp / Arra
    ColWidths[4] := 110;

//    ClientHeight := succ(ClientHeight div DefaultRowHeight) * DefaultRowHeight;
    rowCount := 0;
  end;

  SetLength(StatusBMPs, 5);
  StatusBMPs[0] := CreateSymbol(3);
  StatusBMPs[1] := CreateSymbol(31);
  StatusBMPs[2] := CreateSymbol(23);
  StatusBMPs[3] := CreateSymbol(27);
  StatusBMPs[4] := CreateSymbol(25);

  SetLength(FitnessBMPs, 5);
  FitnessBMPs[0] := CreateSymbol(29);
  FitnessBMPs[1] := CreateSymbol(15);
  FitnessBMPs[2] := CreateSymbol(17);
  FitnessBMPs[3] := CreateSymbol(33);
  FitnessBMPs[4] := CreateSymbol(8);
  Lastrow := -1;

  IB_Query2_SQL := TStringList.create;
  IB_Query2_SQL.assign(IB_Query2.sql);


end;

function TFormBBelege.CreateSymbol(id: integer): TBitMap;
begin
  result := TBitMap.create;
  ImageList1.GetBitmap(id, result);
end;

function TFormBBelege.LineDataFromRID1(RID: integer): TStringList;
var
  SubItem: TStringList;
  n: integer;
begin
 // Element im Cache?
  if LastRequestedRID = RID then
  begin
    result := LastRequestedSub;
    exit;
  end;

 // Altes Ergebnis l�schen!
  if assigned(LastRequestedSub) then
    FreeAndNil(LastRequestedSub);


 // IB-Query auslesen!
  with IB_Query6 do
  begin

    SubItem := TStringList.create;
    LastRequestedSub := SubItem;
    LastRequestedRID := RID;

    ParamByName('CROSSREF').AsInteger := RID;
    if not (Active) then
      Open;
    if eof then
    begin
      for n := 0 to 10 do
        SubItem.add('');
    end else
    begin

   {[0]}
      SubItem.add(FieldByName('TITEL').AsString);
   {[1]}
      SubItem.add(FieldByName('NUMERO').AsString);
   {[2]}
      SubItem.add('');
   {[3]}
      SubItem.add(e_r_Verlag_PERSON_R(FieldByNAme('VERLAG_R').AsInteger));
   {[4]}
      SubItem.add('');
      {[5]}
      if iGOT then
        SubItem.add(FieldByName('VERLAGNO').AsString)
      else
        SubItem.add(e_r_MusikerName(FieldByNAme('KOMPONIST_R').AsInteger));
      {[6]}
      if iGOT then
        SubItem.add(FieldByName('CODE').AsString)
      else
        SubItem.add(e_r_MusikerName(FieldByNAme('ARRANGEUR_R').AsInteger));
   {[7]}
      SubItem.add(e_r_PreisText(0, FieldByName('RID').AsInteger));
   {[8]}
      SubItem.add(FieldByNAme('SCHWER_GRUPPE').AsString + ' ' + FieldByNAme('SCHWER_DETAILS').AsString);
   {[9]}
      SubItem.add(e_r_LaenderISO(FieldByName('LAND_R').AsInteger));
   {[10]}
      SubItem.add(FieldByName('MENGE').AsString + '/' + FieldByName('MINDESTBESTAND').AsString);
   {[11]}
      SubItem.add(e_r_LagerPlatzNameFromLAGER_R(FieldByName('LAGER_R').AsInteger));
    end;
  end;
  result := SubItem;
end;

procedure TFormBBelege.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    DoTheArtikelSearch;
  end;
end;

procedure TFormBBelege.DoTheArtikelSearch;
var
  n: integer;
begin
  BeginHourGlass;
  if not (assigned(ArtikelSucheWI)) then
  begin
    ArtikelSucheWI := TWordIndex.create(nil);
    ArtikelSucheWI.LoadFromFile(SearchDir + format(cArtikelSuchindexFName,[cArtikelSuchindexIntern]));
  end;

  ArtikelSucheWI.Search(edit1.Text);
  ItemRIDs.clear;
  ItemRIDs.capacity := ArtikelSucheWI.FoundList.count;
  for n := 0 to pred(ArtikelSucheWI.FoundList.count) do
    ItemRIDs.add(ArtikelSucheWI.FoundList[n]);
  e_r_ArtikelSortieren(ItemRIDs);
  label3.caption := inttostr(ArtikelSucheWI.FoundList.count);
  GridRefresh;
  DrawGrid1.Row := 0;
  EndHourGlass;
end;

procedure TFormBBelege.DrawGrid1DblClick(Sender: TObject);
begin
  Button3Click(Sender);
end;

procedure TFormBBelege.GridToIBQ6;
begin
  IB_Query6.ParamByName('CROSSREF').AsInteger := integer(ItemRIDS[DrawGrid1.row]);
  if IB_Query6.IsEmpty then
    ShowMessage('Belege: Artikel nicht gefunden!');
end;

procedure TFormBBelege.GridRefresh;
begin
  LastRequestedRID := -1;
  DrawGrid1.RowCount := ItemRIDs.count;
  DrawGrid1.refresh;
  DrawGrid1.SetFocus;
end;

procedure TFormBBelege.Button18Click(Sender: TObject);
begin
  screen.cursor := crHourGlass;
  with IB_Query10 do
  begin
    ParamByName('CROSSREF').AsDate := now;
    Open;
    ItemRIDs.clear;
    ItemRIDs.capacity := RecordCount;
    label3.caption := inttostr(ItemRIDs.capacity);
    First;
    while not (eof) do
    begin
      ItemRIDs.add(pointer(FieldByName('RID').AsInteger));
      next;
    end;
    Close;
  end;
  GridRefresh;
  screen.cursor := crdefault;
end;

procedure TFormBBelege.AusgabeRechnung3_1(NurZurueck: boolean);
var
  AnschriftInfo: TStringList;
  MyBeleg: THTMLTemplate;
  VerpackerMehrInfo: string;
  _Summe: double;
  _Gewicht: integer;
  MwStAnz: integer;
  MwStSaver: array of MwStInfo;
  EvenOddCounter: integer;
  EvenOddCounterPackListe: integer;
  _AddText: string;
  ArtikelInfo: TStringList;
  _PreisProPosition: double;
  _GewichtProPosition: integer;
  _Netto: double;
  _NettoInDieserMwStKlasse: double;
  n: integer;
  _UstID: string;
  KundenInfo: TStringList;
  ZielLandRID: integer;
  _ort: string;

  // konstante Daten, die auf jeder Seite gleich sind
  DatenSammlerGlobal: TStringList; // mal xml ... ? Jahr 2005?!

  // lokale Block-Daten, die wechseln
  DatenSammlerLokal: TStringList; // mal xml ... ? Jahr 2005?!

  procedure AddLine(Satz, Summe: double);
  var
    n: integer;
    MwStFound: boolean;
  begin
  // Suche den entsprechenden Satz
    MwStFound := false;
    for n := 0 to pred(MwStAnz) do
      if (satz = MwStSaver[n].satz) then
      begin
        MwStSaver[n].Summe := MwStSaver[n].Summe + Summe;
        MwStFound := true;
        break;
      end;

  // Gruppe neu anlegen!
    if not (MwStFound) then
    begin
      inc(MwStAnz);
      SetLength(MwStSaver, MwStAnz);
      MwStSaver[pred(MwStAnz)].Satz := Satz;
      MwStSaver[pred(MwStAnz)].Summe := Summe;
    end;
  end;

begin

  // Ausgabe-Lauf
  BerechneBelegActive := true;
  BeginHourGlass;

  AnschriftInfo := TStringList.Create;
  ArtikelInfo := TStringList.create;
  KundenInfo := TStringList.create;
  DatenSammlerGlobal := TStringList.create;
  DatenSammlerLokal := TStringList.create;
  MyBeleg := THTMLTemplate.Create;

  // Kontext setzten f�r Rechnungs-Anschrift
  // Person!
  IB_Query7.ParamByName('CROSSREF').AsInteger := IB_Query1.FieldByName('PERSON_R').AsInteger;

  // nun die Anschrift dazu
  if IB_Query7.IsEmpty then
    ShowMessage('Fehler: Person nicht mehr gefunden!');
  IB_Query8.ParamByName('CROSSREF').AsInteger := IB_Query7.FieldByName('PRIV_ANSCHRIFT_R').AsInteger;
  if IB_Query8.IsEmpty then
    ShowMessage('Fehler: Anschrift nicht mehr gefunden!');

  MyBeleg.LoadFromFile(MyProgramPath + cHTMLTemplatesDir + 'Bestellung_n.html');

  // Blocks speichern
  DatensammlerGlobal.add('save&delete PL_ARTIKEL EVEN');
  DatensammlerGlobal.add('save&delete PL_ARTIKEL ODD');
  DatensammlerGlobal.add('save&delete ARTIKEL EVEN');
  DatensammlerGlobal.add('save&delete ARTIKEL ODD');
  DatensammlerGlobal.add('save&delete MWST');
  DatensammlerGlobal.add('save&delete PUNKTE');

  // Datenfelder ersetzen
  VerpackerMehrInfo := e_r_LagerPlatzNameFromLAGER_R(IB_query1.FieldByName('LAGER_R').AsInteger);
  if (VerpackerMehrInfo <> '') then
    VerpackerMehrInfo := ' nach ' + VerpackerMehrInfo + '!';

  DatenSammlerGlobal.add('R#=' + inttostr(IB_query1.FieldByName('RID').AsInteger));
  DatenSammlerGlobal.add('T#=' + inttostrN(IB_Query1.FieldByName('TEILLIEFERUNG').AsInteger, 2));
  DatenSammlerGlobal.add('PL Beleg Titel=' + 'PACKLISTE NUMMER ' + inttostr(IB_query1.FieldByName('RID').AsInteger) + '-' +
    inttostrN(IB_Query1.FieldByName('TEILLIEFERUNG').AsInteger, 2) +
    VerpackerMehrInfo);

  DatenSammlerGlobal.add('Beleg Titel=' + 'BESTELLUNG NUMMER ' + inttostr(IB_query1.FieldByName('RID').AsInteger) + '-' +
    inttostrN(IB_Query1.FieldByName('TEILLIEFERUNG').AsInteger, 2)
    );

  // Ausgabe, jetzt unver�ndert ausgeben!
  with IB_query2 do
  begin
    DisableControls;
    _Summe := 0.0;
    _Gewicht := 0;
    MwStAnz := 0;
    EvenOddCounter := 0;
    EvenOddCounterPackListe := 0;
    SetLength(MwStSaver, MwStAnz);
    First;
    while not (eof) do
    begin

      if EvenOddCounter mod 2 = 0 then
      begin
        DatenSammlerLokal.add('load ARTIKEL EVEN,ARTIKEL');
      end else
      begin
        DatenSammlerLokal.add('load ARTIKEL ODD,ARTIKEL');
      end;
      inc(EvenOddCounter);

      PreisErmittlung(IB_Query2, NurZurueck);

      if (_Rabatt > 0) then
      begin
        DatensammlerLokal.add('Einzel=' + format('%.2m (-%.0f%%)', [_EinzelPreisOhneRabatt, _Rabatt]));
      end else
      begin
        DatensammlerLokal.Add('Einzel=' + format('%.2m', [_EinzelPreis]));
      end;

      DatensammlerLokal.add('MwSt=' + format('%2.f', [_MwStSatz]) + '%');
      DatensammlerLokal.add('Anz=' + inttostr(_Anz));

      _AddText := '';

        // storniert oder nicht mehr lieferbar
      if (_AnzStorniert > 0) then
        _AddText := _AddText + #13 + format('%dx storniert, bitte nicht mehr liefern', [_AnzStorniert]);

        // wurde bereits geliefert
      if (_AnzGeliefert > 0) then
        _AddText := _AddText + #13 + format('%dx sind angekommen', [_AnzGeliefert]);

        // wird nachgeliefert
      if (_AnzErwartet > 0) then
        _AddText := _AddText + #13 + format('%dx werden erwartet', [_AnzErwartet]);

      DatensammlerLokal.add('Text=' + FieldByName('ARTIKEL').AsString + _AddText);
      // weitere Felder
      DatensammlerLokal.add('VerlagNo2=' + FieldByName('VERLAGNO').AsString);
      DatensammlerLokal.add('Numero2=' + FieldByName('NUMERO').AsString);
      DatensammlerLokal.add('Info=' + FieldByName('INFO').AsString);

      if not (FieldByName('ARTIKEL_R').IsNull) then
      begin


        with IB_Query3 do
        begin

          // Artikel-Daten holen!
          ParamByName('CROSSREF').AsInteger := IB_query2.FieldByName('ARTIKEL_R').AsInteger;
          FieldByName('INTERN_INFO').AssignTo(ArtikelInfo);

          //
          DatensammlerLokal.add('Numero=' + FieldByName('NUMERO').AsString + '.' + IB_Query2.FieldByName('AUSGABEART_R').AsString);

          DatensammlerLokal.add('VerlagNo=' +
            FormAusgabeArt.RIDtoKurz(IB_Query2.FieldByName('AUSGABEART_R').AsInteger) +
            FieldByName('VERLAGNO').AsString
            );


        end;

      end else
      begin
        DatensammlerLokal.add('Numero=' + FieldByName('NUMERO').AsString);
        DatensammlerLokal.add('VerlagNo=' + FieldByName('VERLAGNO').AsString);
      end;

      _PreisProPosition := _EinzelPreis * _Anz;
      _GewichtProPosition := FieldByName('GEWICHT').AsInteger * _Anz;

      AddLine(_MwStSatz, _PreisProPosition);

      _Summe := _Summe + _PreisProPosition;
      _Gewicht := _Gewicht + _GewichtProPosition;

      DatensammlerLokal.add('ll.ZW=' + format('%.2m', [_Summe]));
      if (_Anz > 0) then
      begin
        DatensammlerLokal.add('Brutto=' + format('%.2m', [_PreisProPosition]));
      end else
      begin
        DatenSammlerLokal.add('Brutto=' + '');
      end;

      DatensammlerLokal.Add('pagebreak');
      next;
    end;
    EnableControls;
  end;

  _Netto := _summe;
  for n := 0 to pred(MwStAnz) do
  begin
    if (MwStSaver[n].Summe > 0) and (MwStSaver[n].Satz > 0) then
    begin
      DatenSammlerLokal.add('load MWST');
      _NettoInDieserMwStKlasse := MwStSaver[n].Summe -
        (MwStSaver[n].Summe / (1.0 + MwStSaver[n].Satz / 100.0));
      _NettoInDieserMwStKlasse := cPreisRundung(_NettoInDieserMwStKlasse);

      DatensammlerLokal.add('PR=' + format('%.0f', [MwStSaver[n].Satz]));
      DatensammlerLokal.add('MW=' + format('%.2m', [_NettoInDieserMwStKlasse]));
      DatensammlerLokal.add('MS=' + format('%.2m', [MwStSaver[n].Summe]));
      _netto := _netto - _NettoInDieserMwStKlasse;
    end;
  end;

  DatensammlerGlobal.add('ZS=' + format('%.2m', [_Netto]));
  DatensammlerGlobal.add('BB=' + format('%.2m', [_summe]));

  // Anschrift extrahieren!
  IB_Query7.FieldByName('BEMERKUNG').AssignTo(AnschriftInfo);

  DatensammlerGlobal.add('Anrede=' + AnschriftInfo.Values['ANREDE']);
  DatensammlerGlobal.add('Name=' + IB_Query7.FieldByName('VORNAME').AsString + ' ' +
    IB_Query7.FieldByName('NACHNAME').AsString);

  repeat

    if (IB_Query7.FieldByName('GESCH_FAX').AsString <> '') then
    begin
      DatensammlerGlobal.add('Fax=' + IB_Query7.FieldByName('GESCH_FAX').AsString);
      break;
    end;

    if (IB_Query7.FieldByName('PRIV_FAX').AsString <> '') then
    begin
      DatensammlerGlobal.add('Fax=' + IB_Query7.FieldByName('PRIV_FAX').AsString);
      break;
    end;

    DatensammlerGlobal.add('Fax=');

  until true;

  with IB_Query8 do
  begin
    DatensammlerGlobal.add('Name1=' + FieldByName('NAME1').AsString);
    DatensammlerGlobal.add('Strasse=' + FieldByName('STRASSE').AsString);
    _ort := e_r_ort(IB_Query8);
    DatensammlerGlobal.add('Ort=' + _ort);
    ZielLandRID := e_r_LaenderRIDfromALT(_ort);

    DatensammlerGlobal.add('KontoInhaber=' + e_r_Localize(strtol(iKontoInhaber), ZielLandRID));
    DatensammlerGlobal.add('KontoBankName=' + e_r_Localize(strtol(iKontoBankName), ZielLandRID));
    DatensammlerGlobal.add('KontoNummer=' + e_r_Localize(strtol(iKontoNummer), ZielLandRID));
    DatensammlerGlobal.add('KontoBLZ=' + e_r_Localize(strtol(iKontoBLZ), ZielLandRID));

    _ustid := FieldByName('UST_ID').AsString;
    if _ustid <> '' then
    begin
      DatensammlerGlobal.add('USTID=' + _ustid);
    end else
    begin
      DatensammlerGlobal.add('delete USTID_A');
      DatensammlerGlobal.add('delete USTID_B');
    end;
  end;

  DatensammlerGlobal.add('Datum=' + long2date(DateTime2long(IB_Query1.FieldByName('BESTELLT').AsDateTime)));
  {
  DatensammlerGlobal.add('Zahldatum=' + long2date(DateTime2long(IB_Query1.FieldByName('FAELLIG').AsDateTime)));
  }

  DatensammlerGlobal.add('K#=' + IB_Query7.FieldByName('NUMMER').AsString);


  DatensammlerLokal.add('load PUNKTE');
  DatensammlerLokal.add('PunkteText=' + 'Lieferung an ' + label6.caption);

  if length(iStandardTextRechnung) > 0 then
  begin
    DatensammlerLokal.add('load PUNKTE');
    DatensammlerLokal.add('PunkteText=' + iStandardTextRechnung);
  end;

  // weitere Bemerkungen hinzuf�gen!
  if not (IB_Query1.FieldByName('INFO').IsNull) then
  begin
    IB_Query1.FieldByName('INFO').AssignTo(KundenInfo);
    if (KundenInfo.count > 0) then
    begin
      DatensammlerLokal.add('load PUNKTE');
      _AddText := KundenInfo[0];
      for n := 1 to pred(KundenInfo.count) do
        _AddText := _AddText + #13 + KundenInfo[n];
      DatensammlerLokal.add('PunkteText=' + _AddText);
    end;
  end;

  // Anzeigen, bzw. drucken
  DatensammlerGlobal.Add('local');
  DatensammlerGlobal.AddStrings(DatensammlerLokal);
  //
  MyBeleg.WriteValue(DatensammlerGlobal);
  MyBeleg.SaveToFileCompressed(AnwenderPath + cHTML_OrderFName);
  MyBeleg.free;

  AnschriftInfo.free;
  ArtikelInfo.free;
  KundenInfo.free;
//  DatenSammlerGlobal.SaveToFile(UserDir + 'Beleg.ini');
  DatenSammlerGlobal.free;
  DatenSammlerLokal.free;

  EndHourGlass;
  BerechneBelegActive := false;
end;

procedure TFormBBelege.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssAlt in Shift then
    case Key of
      ord('p'), ord('P'): wanfix32.printShell(AnwenderPath + cHTML_OrderFName);
    end;
end;

procedure TFormBBelege.Button20Click(Sender: TObject);
begin
  // aktuellen Beleg in das Spool Verzeichnis kopieren
  if (SpoolDir <> '') then
  begin
    BerechneBeleg(CheckBox2.Checked);
    AusgabeRechnung3_1(CheckBox2.Checked);
    Spool;
    CheckBox2.Checked := false;
  end;
end;

procedure TFormBBelege.Spool;
begin
  FileCopy(AnwenderPath + cHTML_OrderFName, SpoolDir +
    inttostrN(IB_Query1.FieldByName('RID').AsInteger, 10) +
    '-' +
    inttostrN(IB_Query1.FieldByName('TEILLIEFERUNG').AsInteger, 2) +
    '.html');
  FileSetAttr(SpoolDir +
    inttostrN(IB_Query1.FieldByName('RID').AsInteger, 10) +
    '-' +
    inttostrN(IB_Query1.FieldByName('TEILLIEFERUNG').AsInteger, 2) +
    '.html', faReadOnly);
end;


procedure TFormBBelege.Panel4Click(Sender: TObject);
begin
  with IB_query1 do
  begin
    FieldByName('LIEFERANSCHRIFT_R').clear;
    post;
  end;
end;

procedure TFormBBelege.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin

  ReflectData;

end;

procedure TFormBBelege.SpeedButton1Click(Sender: TObject);
begin
  openShell(MyProgramPath + 'Bestellungen\' + inttostrN(PersonRID, 10));
end;

procedure TFormBBelege.SpeedButton2Click(Sender: TObject);
begin
  openShell('mailto:' +
    e_r_sqls(
    'select EMAIL from PERSON where RID=' +
    IB_Query1.FieldByName('PERSON_R').AsString
    ));
end;

procedure TFormBBelege.FormDestroy(Sender: TObject);
begin
  ItemRIDs.free;
  ItemMarked.free;
  StatusBMPs[0].free;
  StatusBMPs[1].free;
  StatusBMPs[2].free;
  StatusBMPs[3].free;
  StatusBMPs[4].free;
  FitnessBMPs[0].free;
  FitnessBMPs[1].free;
  FitnessBMPs[2].free;
  FitnessBMPs[3].free;
  FitnessBMPs[4].free;
end;

procedure TFormBBelege.IB_Query2AfterScroll(IB_Dataset: TIB_Dataset);
begin
  with IB_Dataset do
  begin
    button7.enabled := (FieldByName('ARTIKEL_R').IsNotNull);
    button6.enabled := button7.enabled;
//  button17.enabled := (FieldByName('MENGE_ERWARTET').AsInteger>0);
  end;
end;

procedure TFormBBelege.IB_Query1ConfirmDelete(Sender: TComponent;
  var Confirmed: Boolean);
begin
  Confirmed := false;
  with Sender as TIB_Dataset do
    if doit(_('Order') + #13 +
      '#' + FieldByName('RID').AsString + #13 +
      _('wirklich l�schen')) then
    begin
      BeginHourGlass;
      e_w_preDeleteBBeleg(fieldbyname('RID').AsInteger);
      Confirmed := true;
      EndHourGlass;
    end;
end;

procedure TFormBBelege.IB_Query2ConfirmDelete(Sender: TComponent;
  var Confirmed: Boolean);
begin
  Confirmed := false;
  with Sender as TIB_Dataset do
    if doit(_('Posten') + #13 +
      FieldByName('ARTIKEL').AsString + #13 +
      _('wirklich l�schen')) then
    begin
      BeginHourGlass;
      e_w_preDeleteBPosten(fieldbyname('RID').AsInteger);
      Confirmed := true;
      EndHourGlass;
    end;
end;

procedure TFormBBelege.Button6Click(Sender: TObject);
begin
  FormArtikelBackOrder.SetContext(IB_Query2.FieldByName('ARTIKEL_R').AsInteger);
end;

procedure TFormBBelege.IB_Grid2DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  _CellDisplayText: string;

  UeberMenge: integer;
  Motivation: integer;
  AUSGABEART_R, ARTIKEL_R: integer;
begin
  with IB_Grid2 do
  begin

    // important: set DefDrawBefore to false

    if (ARow <> Lastrow) then
    begin
      _NewCol := Color;

      // Einf�rben anhand der Vorschlagsmenge
      ARTIKEL_R := StrToIntdef(GetCellDisplayText(GridCol_ARTIKEL_R, ARow), 0);

      if (ARTIKEL_R > 0) then
      begin
        AUSGABEART_R := StrToIntdef(GetCellDisplayText(GridCol_AUSGABEART_R, ARow), 0);
        UeberMenge := e_r_VorschlagMenge(AUSGABEART_R, ARTIKEL_R);
        if (UeberMenge < -3) then
          UeberMenge := -3;
        if (UeberMenge > 3) then
          UeberMenge := 3;
        case UeberMenge of
          -3: _NewCol := HTMLColor2TColor($6699CC);
          -2: _NewCol := HTMLColor2TColor($3399FF);
          -1: _NewCol := HTMLColor2TColor($99CCFF);
          0: _NewCol := HTMLColor2TColor($CCFFCC);
          1: _NewCol := HTMLColor2TColor($FFFFCC);
          2: _NewCol := HTMLColor2TColor($FFFF66);
          3: _NewCol := HTMLColor2TColor($FFCC33);
        end;
      end else
      begin
        _NewCol := clwhite;
      end;

      // Fett oder unfett je nachdem, ob Kundenwunsch oder Lager-Auff�llen
      Motivation := strtol(GetCellDisplayText(GridCol_Motivation, ARow));
      _NewStyle := [];
      if (Motivation = eT_MotivationKundenAuftrag) then
        _NewStyle := [fsbold];
      if (Motivation = eT_MotivationHaendlerAuftrag) then
        _NewStyle := [fsbold,fsitalic];

      LastRow := ARow;
    end;

    // Text f�r diese Zelle
    _CellDisplayText := GetCellDisplayText(ACol, ARow);

    if gdFocused in State then
    begin
      // alles auf Standard
      canvas.brush.color := Color;
      canvas.font.color := FormBBelege.canvas.Font.Color;
      canvas.Font.Style := _newStyle;
      DefaultDrawFocusedCell(ACol, ARow, Rect, State, _CellDisplayText, GetCellAlignment(ACol, ARow));
    end else
    begin
      canvas.brush.color := _newCol;
      canvas.font.color := VisibleContrast(canvas.brush.color);
      canvas.Font.Style := _newStyle;
      DefaultDrawCell(ACol, ARow, Rect, State, _CellDisplayText, GetCellAlignment(ACol, ARow));
    end;
  end;
end;

procedure TFormBBelege.SpeedButton12Click(Sender: TObject);
begin
  SaveHeaderSettings(IB_grid2, AnwenderPath + HeaderSettingsFName(IB_grid2));
  GridTitleRefresh;
end;

procedure TFormBBelege.SpeedButton12MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbRight) then
    if doit(_('Wollen Sie die Spaltenbreiten wieder auf Standard setzen'), true) then
    begin
      FileDelete(AnwenderPath + HeaderSettingsFName(IB_grid2));
      IB_Query2.close;
      IB_Query2.sql.clear;
      IB_Query2.sql.AddStrings(IB_Query2_SQL);
      IB_Query2.open;
    end;
end;

procedure TFormBBelege.IB_Query2BeforePrepare(Sender: TIB_Statement);
begin
  LoadHeaderSettings(IB_grid2, AnwenderPath + HeaderSettingsFName(IB_grid2));
  GridTitleRefresh;
end;

procedure TFormBBelege.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Order');
end;

procedure TFormBBelege.IB_Query2AfterOpen(IB_Dataset: TIB_Dataset);
begin
  GridTitleRefresh;
end;

procedure TFormBBelege.IB_Grid2DrawFocusedCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  with sender as TIB_Grid do
  begin
    canvas.Font.style := [fsbold];
    canvas.font.color := clwhite;
    canvas.brush.color := clblue;
    DefaultDrawCell(ACol, ARow, Rect, State, GetCellDisplayText(ACol, ARow), GetCellAlignment(ACol, ARow));
  end;
end;

procedure TFormBBelege.IB_Query2AfterPrepare(Sender: TIB_Statement);
begin
  GridTitleRefresh;
end;

procedure TFormBBelege.IB_Grid2TitleClick(Sender: TObject; ACol,
  ARow: Integer; AButton: TMouseButton; AShift: TShiftState);
begin
  GridTitleRefresh;
end;

procedure TFormBBelege.GridTitleRefresh;
var
  n: integer;
begin
  with IB_grid2 do
  begin
    for n := 1 to GridFieldCount do
    begin
      if (GetCellDisplayText(n, 0) = 'MOT') then
        GridCol_Motivation := n;
      if (GetCellDisplayText(n, 0) = 'VOR') then
        GridCol_Vorschlag := n;
      if (GetCellDisplayText(n, 0) = 'ANZ') then
        GridCol_Anzahl := n;
      if (GetCellDisplayText(n, 0) = 'AA') then
        GridCol_AUSGABEART_R := n;
      if (GetCellDisplayText(n, 0) = 'ARTIKEL R') then
        GridCol_ARTIKEL_R := n;
    end;
  end;
end;

procedure TFormBBelege.IB_Query2AfterPost(IB_Dataset: TIB_Dataset);
begin
  LastRow := -1;
end;

procedure TFormBBelege.ReflectData;
var
  SUMME: double;
begin
  // Lieferanschrift anzeigen
  if IB_Query1.FieldByName('LIEFERANSCHRIFT_R').IsNotNull then
    label6.caption := e_r_Person(IB_Query1.FieldByName('LIEFERANSCHRIFT_R').AsInteger)
  else
    Label6.caption := '';

  // Summe f�r diesen Beleg anzeigen
  if IB_Query1.FieldByName('RID').IsNotNull then
  begin

    Summe := e_r_sqld(
      'select SUM(BETRAG) from BUCH where' +
      ' (BBELEG_R=' + IB_Query1.FieldByName('RID').AsString + ') and' +
      ' (NAME=''ER'')'
      );

    StaticText1.Caption := format('%m', [abs(Summe)]);
    if (summe > 0.01) then
    begin
      StaticText1.Color := clred
    end else
    begin
      StaticText1.Color := cllime
    end;

  end;

  // Summe f�r diesen Lieferanten bilden
  if IB_Query1.FieldByName('PERSON_R').IsNotNull then
  begin

    Summe := e_r_sqld(
      'select SUM(BETRAG) from BUCH where' +
      ' (PERSON_R=' + IB_Query1.FieldByName('PERSON_R').AsString + ') and' +
      ' (NAME=''ER'')'
      );

    StaticText2.Caption := format('%m', [abs(Summe)]);
    if (Summe > 0.01) then
    begin
      StaticText2.Color := clred
    end else
    begin
      StaticText2.Color := cllime
    end;

  end;

end;

procedure TFormBBelege.IB_Grid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssAlt in Shift then
    if (Key = ord('X')) then
    begin
      OLAP.DoContextOLAP(IB_Grid2);
      Key := 0;
    end;

end;

end.

