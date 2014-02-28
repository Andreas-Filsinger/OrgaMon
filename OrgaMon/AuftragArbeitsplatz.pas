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
unit AuftragArbeitsplatz;
//
//
// Bug: in SaveContext: nicht die aktuellen controll speichern, sondern die
// Double-Buffer werte, die bei der letzten bestandveränderten Anfrage
// abgespeichert wurden!
//

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  ExtCtrls, Grids, ImgList,
  ComCtrls, ToolWin, IB_Components,
  Menus, WordIndex, anfix32,
  DatePick,
  Sperre, Buttons, globals,
  gplists, txlib, IB_Access,
  dbOrgaMon;

type
  TFormAuftragArbeitsplatz = class(TForm)
    Panel1: TPanel;
    ComboBox1: TComboBox;
    ImageList1: TImageList;
    DrawGrid1: TDrawGrid;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton12: TToolButton;
    ToolButton16: TToolButton;
    ToolButton5: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton13: TToolButton;
    ToolButton15: TToolButton;
    ToolButton14: TToolButton;
    ToolButton18: TToolButton;
    Memo1: TMemo;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    PopupMenu1: TPopupMenu;
    MenuItem_PLZSortierung: TMenuItem;
    Button4: TButton;
    ProgressBar1: TProgressBar;
    Label2: TLabel;
    ComboBox5: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    ComboBox6: TComboBox;
    Panel2: TPanel;
    Button3: TButton;
    Button6: TButton;
    Label14: TLabel;
    DatePick1: TDatePick;
    ToolBar2: TToolBar;
    ToolButton20: TToolButton;
    ToolButton22: TToolButton;
    CheckBox5: TCheckBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    ToolButton27: TToolButton;
    ToolButton28: TToolButton;
    ToolButton31: TToolButton;
    ZhlerInfosanzeigen1: TMenuItem;
    ToolButton19: TToolButton;
    Historieanzeigen1: TMenuItem;
    IB_Query9: TIB_Query;
    WordModusANAUS1: TMenuItem;
    StatusMonteurinformiertANAUS1: TMenuItem;
    ToolButton23: TToolButton;
    Label13: TLabel;
    ToolButton26: TToolButton;
    ToolButton29: TToolButton;
    ToolButton30: TToolButton;
    Timer1: TTimer;
    DrawGrid2: TDrawGrid;
    Button5: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    MenuItem_PostSortierung: TMenuItem;
    N1: TMenuItem;
    MenuItem_ZeitSortierung: TMenuItem;
    MenuItem_normalSortierung: TMenuItem;
    ToolButton32: TToolButton;
    IB_Query2: TIB_Query;
    ToolButton34: TToolButton;
    ToolButton35: TToolButton;
    IB_Query3: TIB_Query;
    ToolButton38: TToolButton;
    IB_Query15: TIB_Query;
    Baustelle: TLabel;
    ToolButton40: TToolButton;
    ToolButton41: TToolButton;
    ToolButton43: TToolButton;
    ToolButton45: TToolButton;
    LabelRefreshDiag: TLabel;
    IB_Query16: TIB_Query;
    N2: TMenuItem;
    Zhlernummeranzeigen1: TMenuItem;
    MenuItem_ZaehlernummerSortierung: TMenuItem;
    ToolButton21: TToolButton;
    ToolButton2: TToolButton;
    CheckBox3: TCheckBox;
    Edit2: TEdit;
    Label5: TLabel;
    StatusRckluferANAUS1: TMenuItem;
    Status1: TMenuItem;
    IB_Cursor1: TIB_Cursor;
    MenuItem_BriefadresseSortierung: TMenuItem;
    ComboBox7: TComboBox;
    ToolButton36: TToolButton;
    Button11: TButton;
    Button12: TButton;
    ToolButton48: TToolButton;
    StatusNeuanschreibenANAUS1: TMenuItem;
    StatusvorgezogenANAUS1: TMenuItem;
    ToolButton49: TToolButton;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    ToolButton11: TToolButton;
    ToolButton17: TToolButton;
    SpeedButton9: TSpeedButton;
    OpenDialog1: TOpenDialog;
    ToolButton33: TToolButton;
    Image2: TImage;
    Image1: TImage;
    SpeedButton4: TSpeedButton;
    ToolButton37: TToolButton;
    Edit3: TEdit;
    Button13: TButton;
    MenuItem_ABNummerSortierung: TMenuItem;
    MenuItem_StatusSortierung: TMenuItem;
    SpeedButton13: TSpeedButton;
    Zeitraumanzeigen1: TMenuItem;
    Protokollangabenanzeigen1: TMenuItem;
    Problemeanzeigen1: TMenuItem;
    SpeedButton5: TSpeedButton;
    ToolButton6: TToolButton;
    IB_Query_MonteurInfoEinzeln: TIB_Query;
    MenuItem_WechselDatumSortierung: TMenuItem;
    procedure ToolButton37Click(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure DrawGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button4Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton15Click(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton16Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure DrawGrid1DblClick(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox4DropDown(Sender: TObject);
    procedure ComboBox6DropDown(Sender: TObject);
    procedure ComboBox6Change(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DatePick1Change(Sender: TDatePick; Value: TDatePickResult);
    procedure Label13Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ToolButton22Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure ToolButton25Click(Sender: TObject);
    procedure ToolButton27Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ToolButton31Click(Sender: TObject);
    procedure ZhlerInfosanzeigen1Click(Sender: TObject);
    procedure Historieanzeigen1Click(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure WordModusANAUS1Click(Sender: TObject);
    procedure StatusMonteurinformiertANAUS1Click(Sender: TObject);
    procedure ToolButton19Click(Sender: TObject);
    procedure ToolButton28Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ToolButton23Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ComboBox2Enter(Sender: TObject);
    procedure ComboBox2Exit(Sender: TObject);
    procedure ComboBox4Exit(Sender: TObject);
    procedure ToolButton26Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToolButton29Click(Sender: TObject);
    procedure DrawGrid2DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure ToolButton32Click(Sender: TObject);
    procedure IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
    procedure ToolButton35Click(Sender: TObject);
    procedure IB_Query3BeforePost(IB_Dataset: TIB_Dataset);
    procedure ToolButton38Click(Sender: TObject);
    procedure ToolButton41Click(Sender: TObject);
    procedure ToolButton43Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Zhlernummeranzeigen1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure StatusRckluferANAUS1Click(Sender: TObject);
    procedure Status1Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DrawGrid2KeyPress(Sender: TObject; var Key: Char);
    procedure ToolButton36Click(Sender: TObject);
    procedure DrawGrid2Click(Sender: TObject);
    procedure DrawGrid2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure ToolButton48Click(Sender: TObject);
    procedure StatusNeuanschreibenANAUS1Click(Sender: TObject);
    procedure ComboBox1Exit(Sender: TObject);
    procedure StatusvorgezogenANAUS1Click(Sender: TObject);
    procedure ToolButton49Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure LabelRefreshDiagClick(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure ToolButton17Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure MenuItem_PLZSortierungClick(Sender: TObject);
    procedure MenuItem_PostSortierungClick(Sender: TObject);
    procedure MenuItem_ZeitSortierungClick(Sender: TObject);
    procedure MenuItem_ZaehlernummerSortierungClick(Sender: TObject);
    procedure MenuItem_normalSortierungClick(Sender: TObject);
    procedure MenuItem_BriefadresseSortierungClick(Sender: TObject);
    procedure ToolButton33Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure ToolButton38MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton4Click(Sender: TObject);
    procedure ToolButton21Click(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Button13Click(Sender: TObject);
    procedure MenuItem_ABNummerSortierungClick(Sender: TObject);
    procedure MenuItem_StatusSortierungClick(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure Zeitraumanzeigen1Click(Sender: TObject);
    procedure Protokollangabenanzeigen1Click(Sender: TObject);
    procedure Problemeanzeigen1Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure MenuItem_WechselDatumSortierungClick(Sender: TObject);
    procedure ToolButton6MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

    { Private-Deklarationen }

    // Selektions-Kriterien
    s_Baustelle: Integer;
    s_Monteur: Integer;
    s_Datum_Start: TANFiXDate;
    s_Datum_Ende: TANFiXDate;
    s_Status: Integer;
    s_SortMode: TeTerminarbeitsplatzSortMode;
    s_Art: string;
    s_Vormittags: string;
    s_BaustelleStart: TANFiXDate;
    s_BaustelleEnde: TANFiXDate;
    s_List: TgpIntegerList;

    // Daten links in der Auslastungsanzeige
    a_baustelle: Integer;

    // ContextVars
    s_Context: TStringlist;

    //
    ShowExtendedWarning: boolean;
    SymbolList: TList;

    //
    InsideSearch: boolean;
    BreakSet: boolean;
    AuftragPostReorgMode: boolean;
    qAUFTRAGred: TIB_Query;
    ProblemInfos: TgpIntegerObjectList;
    ToolButton6Ctrl: boolean;

    procedure FuelleBaustellenCombo;
    procedure EnsureSchlageZeile(BAUSTELLE_R: Integer);
    procedure NotifyGrid1;

  public
    { Public-Deklarationen }
    SelectedRow: Integer;
    ItemsGRID: TExtendedList; // das was angezeigt wird
    ItemsMARKED: TExtendedList; // das was markiert wird
    ItemsQUERY: TExtendedList; // das was die Datenbank erbrachte
    _SomeThingChanged: boolean;
    StatusBMPs: array of TBitMap;
    FitnessBMPs: array of TBitMap;
    GridDisable: boolean;

    // Monteur-Information
    ItemInformiert: TList; // das worüber informiert wurde
    MonteurRIDs: TgpIntegerList; // welche Monteure Informiert werden
    TageRIDs: TgpIntegerList; // welche Tage ausgegeben wurden
    _MonteurRIDsCount: Integer;

    // refresh events
    ShouldRefreshBelastung: boolean;
    ShouldRefreshBelastungbaustelle: Integer;
    ShouldRefreshBelastungIn: Integer;
    ShouldRefreshListe: boolean;

    // Anleuchten der Historischen
    ShouldRefreshHistorischeIn: Integer;

    // Anzeige Kriterien für die Liste
    ZaehlerInfosAnzeigen: boolean;
    ZaehlerNummerAnzeigen: boolean;
    HistorieAnzeigen: boolean;
    ZeitraumAnzeigen: boolean;
    ProtokollangabenAnzeigen: boolean;
    ProblemeAnzeigen: boolean;

    // Öffentlicher Zugriff auf die Suche via SQL
    // (Nach der Durchführung der Suche wird s_OneTimeAddSQL auf leer gesetzt)
    s_OneTimeAddSQL: String; // 17.04.09: Ronny Schupeta

    // View-Kriterien für die Monteur-Liste
    v_MonteurMontag: TANFiXDate;
    v_MonteurSonntag: TANFiXDate;
    v_Kursiv_cell: Integer;
    v_MonteurTag: TANFiXDate;

    // Datenrepräsentation des DrawGrid2
    Auslastung: TAuslastung;

    // Suche
    GlobalerAuftragsIndex: TWordIndex;
    LokalerAuftragsIndex: TWordIndex;

    // Cursor
    SaveCursorRID: Integer;

    // Phasen
    PhasenStatus: TStringlist;

    // Context-Pointer
    ContextReadPos: Integer; // dieser wird bei refresh gelesen!
    ContextWritePos: Integer; // dieser wurde als letzer geschrieben
    ShouldRefreshCameraIn: Integer;

    _LastTerminCount: Integer;

    function CreateSymbol(id: Integer): TBitMap;
    procedure ContextPopUp(X, Y: Integer);
    function WordDataFromRID(RID: Integer): string;
    procedure RefreshCountAnzeige;
    procedure RefreshMonteurAuslastung(BAUSTELLE_R: Integer);
    procedure RefreshBaustellenAuslastung;
    procedure SaveCursorPosition;
    procedure RestoreCursorPosition;
    procedure ProduceInfoBlatt(Datum_RIDs, Monteur_RIDs,
      Single_RIDs: TgpIntegerList; MondaMode: boolean = false;
      FaxMode: boolean = false);
    function getProbleme(AUFTRAG_R: Integer): TStringlist;
    procedure ToggleStatusMode(RID: Integer; Mode: Integer);
    function MonteurSelected: Integer;
    procedure ToggleSortMode(NewMode: TeTerminarbeitsplatzSortMode;
      ForceChange: boolean = false);
    procedure ReflectBaustelleChange;
    procedure MarkiereLeeresPlanquadrat(Import_RID, Anzahl: Integer);
    procedure ShowAuftrag;
    procedure MarkAuftrag;
    procedure MarkSort;
    procedure ClearMarkierte;
    procedure AddMarkierte(AUFTRAG_R: Integer);
    procedure AddMarkierte_RID_AT_IMPORT(RID_AT_IMPORT: Integer);

    // Ausgabe der aktuellen Selektion
    function OutCSV(RID: Integer; s_Baustelle: Integer): string; overload;
    // [FileName]
    function OutCSV(RIDs: TgpIntegerList; s_Baustelle: Integer): string;
      overload; // [FileName]
    // Auftrags-info-Blatt erstellen
    function AsHTML(AUFTRAG_R: Integer; BAUSTELLE_R: Integer = cRID_Unset)
      : string; overload; // [Fname]
    function AsHTML(lAUFTRAG: TgpIntegerList): string; overload; // [Fname]

    // ganze Context Geschichte
    function SaveContext(InternalUse: boolean = false): boolean;
    procedure LoadContext;
    function ContextFName(Position: Integer): string;
    function getContext(Increment: boolean = false): Integer;
    procedure RefreshContextAnzeige;
    function getContextnext(ActCounter: Integer): Integer;
    function getContextprev(ActCounter: Integer): Integer;
    procedure SaveEdits;
    procedure moveContextBack;
    procedure moveContextNext;
    procedure CameraFlash;
    procedure HistorischeFlash;

    procedure HistorischBeenden;
    procedure MarkImportedRID(IMPORT_R: Integer);
    procedure MarkProtokollValue(pName: string);
    procedure FindNextMarked;
    procedure Suche;
    procedure Add(RID: Integer);
    procedure SortSQL(sql: Tstrings);
    procedure SwitchAuslastung;

    // Notify
    procedure NotifyBaustelleChanged(Sender: TObject);
    procedure NotifyMonteurChanged(Sender: TObject);
    procedure showMap(RID: Integer);
    procedure ShowRIDs(RIDs: TgpIntegerList);

    procedure doAynaci1;
    procedure doAynaci2;

    //
    procedure mShow;
    procedure AnzeigenRefresh;

    // Problem-Infos
    procedure InvalidateCache_ProblemInfos;
    procedure RefreshProblemInfos;

  end;

var
  FormAuftragArbeitsplatz: TFormAuftragArbeitsplatz;

implementation

uses
  math, html,
  ExcelHelper, OrientationConvert, wanfix32,

  IB_Header, IB_Session,

  Auftrag, Baustelle, Bearbeiter,
  AuftragSuchindex, PlanquadratNachfrage,
  AuftragMobil, MonteurUmfang, AuftragSuche,
  AuftragErgebnis, CareTakerClient, AnschriftOptimierung,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  Funktionen_Transaktion,
  Funktionen_LokaleDaten,
  FastGeo, GeoArbeitsplatz, GeoLokalisierung,

  Datenbank, FrageLoeschenMonteurInfo;

const
  cTrenner = '<--------------';

  cTagX: Integer = 31;
  cPlanX: Integer = 18;
  cPlanY: Integer = 30;
  cPlanY_div_2: Integer = 0;
{$R *.DFM}

procedure TFormAuftragArbeitsplatz.DrawGrid1DrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  SubItems: TStringlist;
  TERMINIERT_R: Integer;
  GEAENDERT_R: Integer;
  AUFTRAG_R: Integer;
  FocusColor: TColor;
  Fokusiert: boolean;
  vStatus: TeVirtualPhaseStatus;
  sProtokoll: TStringlist;
  sAlter: TStringlist;
  n: Integer;
begin
  if GridDisable then
    exit;

  if (ARow >= 0) then
    with DrawGrid1.canvas do
    begin

      Fokusiert := (ARow = DrawGrid1.Row);

      if Fokusiert then
      begin
        brush.color := HTMLColor2TColor($FFFF33);
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

      if (ARow < ItemsGRID.count) then
      begin
        AUFTRAG_R := Integer(ItemsGRID[ARow]);
        SubItems := e_r_AuftragItems(AUFTRAG_R);
        if (AUFTRAG_R = 1) then
        begin
          if Fokusiert then
            brush.color := HTMLColor2TColor($CCFFCC)
          else
            brush.color := HTMLColor2TColor($66FF66);
        end;
        if ItemsMARKED.indexof(ItemsGRID[ARow]) <> -1 then
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
        FocusColor := brush.color;
        vStatus := TeVirtualPhaseStatus(strtointdef(SubItems[twh_Status1], 0));
        if assigned(SubItems) then
        begin
          case ACol of
            0:
              begin
                // Status
                FillRect(Rect);
                draw(
                  { } Rect.left + 1,
                  { } Rect.top + dpiX(9),
                  { } StatusBMPs[ord(vStatus)]);

                // Status in der fokusierten Zeile
                if (ARow = DrawGrid1.Row) then
                  EnsureSchlageZeile
                    (e_r_BaustelleRIDFromKuerzel(SubItems[twh_Baustelle]));
              end;
            1:
              begin

                font.size := 8;
                if (SubItems[twh_WordEmpfaenger] <> '') then
                  font.style := [fsunderline]
                else
                  font.style := [];

                if vStatus in [ctvHistorisch, ctvHistorischInformiert] then
                begin
                  TextRect(Rect, Rect.left + 16 + 4, Rect.top,
                    SubItems[twh_Baustelle] + '-');
                  TextOut(Rect.left + 16 + 4, Rect.top + cPlanY_div_2,
                    SubItems[twh_Auftrags_Nummer]);
                  draw(Rect.left + 1, Rect.top + dpiX(9),
                    StatusBMPs[strtointdef(SubItems[twh_Status3], 6)]);
                  // Status
                end
                else
                begin
                  TextRect(Rect, Rect.left + 2, Rect.top + dpiX(9),
                    SubItems[twh_Baustelle] + '-' + SubItems
                    [twh_Auftrags_Nummer]);
                end;

              end;
            2:
              begin
                // Fittnes
                FillRect(Rect);
                draw(Rect.left + 1, Rect.top + dpiX(9),
                  FitnessBMPs[strtointdef(SubItems[twh_Status2], 0)]);
                // Fitness
              end;
            3:
              begin
                // Monteur
                font.size := 8;
                font.style := [];
                TextRect(Rect, Rect.left + 2, Rect.top, SubItems[twh_Monteur]);
                TextOut(Rect.left + 2, Rect.top + cPlanY_div_2,
                  SubItems[twh_Art]);
              end;
            4:
              begin
                // Datum
                font.size := 8;
                font.style := [];
                TextRect(Rect, Rect.left + 2, Rect.top, SubItems[twh_Datum]);
                TextOut(Rect.left + 2, Rect.top + cPlanY_div_2,
                  SubItems[twh_WochentagKurz] + ' - ' + SubItems[twh_Zeit]);
              end;
            5:
              begin
                // Name
                font.size := 8;
                font.style := [];
                TextRect(Rect, Rect.left + 2, Rect.top,
                  SubItems[twh_Verbraucher_Strasse] + ' ' +
                  SubItems[twh_Verbraucher_Ort]);
                TextOut(Rect.left + 2, Rect.top + cPlanY_div_2,
                  SubItems[twh_Verbraucher_Name]);
              end;
            6:
              begin
                // PLZ // Ort
                repeat
                  if ZaehlerNummerAnzeigen then
                  begin
                    font.name := 'Courier New';
                    font.size := 10;
                    font.style := [];
                    TextRect(Rect, Rect.left + 4, Rect.top,
                      SubItems[twh_Zaehler_Nummer]);
                    TextOut(Rect.left + 4, Rect.top + cPlanY_div_2,
                      SubItems[twh_Art]);
                    break;
                  end;

                  if ZaehlerInfosAnzeigen then
                  begin
                    font.name := 'Tahoma';
                    font.size := 7;
                    font.style := [];
                    TextRect(Rect, Rect.left + 2, Rect.top,
                      SubItems[twh_ZaehlerInfo1] + ' ' +
                      SubItems[twh_ZaehlerInfo2] + ' ' +
                      SubItems[twh_ZaehlerInfo3]);
                    TextOut(Rect.left + 2, Rect.top + (rYL(Rect) div 3),
                      SubItems[twh_ZaehlerInfo4] + ' ' +
                      SubItems[twh_ZaehlerInfo5] + ' ' +
                      SubItems[twh_ZaehlerInfo6]);
                    TextOut(Rect.left + 2, Rect.top + (rYL(Rect) div 3) * 2,
                      SubItems[twh_ZaehlerInfo7] + ' ' +
                      SubItems[twh_ZaehlerInfo8] + ' ' +
                      SubItems[twh_ZaehlerInfo9]);
                    break;

                  end;

                  if ProtokollangabenAnzeigen then
                  begin
                    font.name := 'Tahoma';
                    font.size := 7;
                    font.style := [];
                    sProtokoll := Split(SubItems[twh_Protokoll],
                      cProtokollTrenner);

                    TextRect(Rect, Rect.left + 2, Rect.top,
                      sProtokoll.values['V1']);
                    TextOut(Rect.left + 2, Rect.top + (rYL(Rect) div 3),
                      sProtokoll.values['V2']);
                    TextOut(Rect.left + 2, Rect.top + (rYL(Rect) div 3) * 2,
                      sProtokoll.values['V3']);
                    sProtokoll.free;
                    break;
                  end;

                  if ProblemeAnzeigen then
                  begin
                    font.name := 'Tahoma';
                    font.size := 7;
                    font.style := [];
                    sProtokoll := getProbleme(AUFTRAG_R);
                    TextRect(Rect, Rect.left + 2, Rect.top, sProtokoll[0]);
                    TextOut(Rect.left + 2, Rect.top + (rYL(Rect) div 3),
                      sProtokoll[1]);
                    TextOut(Rect.left + 2, Rect.top + (rYL(Rect) div 3) * 2,
                      sProtokoll[2]);
                    sProtokoll.free;
                    break;
                  end;

                  // default
                  font.name := 'Tahoma';
                  font.size := 7;
                  font.style := [];
                  TextRect(Rect, Rect.left + 2, Rect.top,
                    SubItems[twh_Anschreiben_Name]);
                  TextOut(Rect.left + 2, Rect.top + (rYL(Rect) div 3),
                    SubItems[twh_Anschreiben_Strasse]);
                  TextOut(Rect.left + 2, Rect.top + (rYL(Rect) div 3) * 2,
                    SubItems[twh_Anschreiben_Ort]);

                until true;
                font.name := 'Verdana';
              end;
            7:
              begin
                // Ortsteil~PQ
                repeat
                  if ProtokollangabenAnzeigen then
                  begin
                    font.name := 'Tahoma';
                    font.size := 7;
                    font.style := [];
                    sProtokoll := Split(SubItems[twh_Protokoll],
                      cProtokollTrenner);
                    sAlter := TStringlist.create;
                    sAlter.Add(sProtokoll.values['B1']);
                    sAlter.Add(sProtokoll.values['B2']);
                    sAlter.Add(sProtokoll.values['B3']);
                    sAlter.Add(sProtokoll.values['I6']);
                    sAlter.Add(sProtokoll.values['I7']);
                    sAlter.Add(sProtokoll.values['I8']);
                    sAlter.Add(sProtokoll.values['I3']);
                    sAlter.Add(sProtokoll.values['I4']);
                    sAlter.Add(sProtokoll.values['I5']);
                    for n := 0 to pred(sProtokoll.count) do
                      if (pos(copy(sProtokoll[n], 1, 2),
                        'V1V2V3B1B2B3B4I3I4I5I6I7I8') = 0) then
                        sAlter.Add(sProtokoll[n]);
                    for n := pred(sAlter.count) downto 0 do
                      if (sAlter[n] = '') then
                        sAlter.Delete(n);

                    if sAlter.count = 0 then
                      sAlter.Add('');
                    if sAlter.count = 1 then
                      sAlter.Add('');
                    if sAlter.count = 2 then
                      sAlter.Add('');

                    TextRect(Rect, Rect.left + 2, Rect.top, sAlter[0]);
                    TextOut(Rect.left + 2, Rect.top + (rYL(Rect) div 3),
                      sAlter[1]);
                    TextOut(Rect.left + 2, Rect.top + (rYL(Rect) div 3) * 2,
                      sAlter[2]);
                    sProtokoll.free;
                    break;
                  end;

                  if ZeitraumAnzeigen then
                  begin
                    font.size := 8;
                    font.style := [];
                    TextRect(Rect, Rect.left + 2, Rect.top,
                      SubItems[twh_Bemerkung]);
                    TextOut(Rect.left + 2, Rect.top + cPlanY_div_2,
                      SubItems[twh_OrtsteilCode] + '~' +
                      SubItems[twh_Planquadrat] + ' ' +
                      SubItems[twh_ZeitraumKurz]);
                    break;
                  end;

                  font.size := 8;
                  font.style := [];
                  TextRect(Rect, Rect.left + 2, Rect.top,
                    SubItems[twh_Bemerkung]);
                  TextOut(Rect.left + 2, Rect.top + cPlanY_div_2,
                    SubItems[twh_OrtsteilCode] + '~' + SubItems[twh_Planquadrat]
                    + ' ' + SubItems[twh_SperreKurz]);

                until true;
              end;
            8:
              begin
                // Datum der letzten Änderung, Farbe des terminierers
                // Benutzer-Logo des letzten Bearbeuters.
                font.size := 7;
                font.style := [];
                GEAENDERT_R := strtointdef(nextp(SubItems[twh_Bearbeiter],
                  '/', 0), 0);
                TERMINIERT_R :=
                  strtointdef(nextp(SubItems[twh_Bearbeiter], '/', 1), 0);
                if (GEAENDERT_R <> TERMINIERT_R) then
                begin
                  brush.color := FormBearbeiter.FetchBackGroundColorFromRiD
                    (TERMINIERT_R);
                  font.color := FormBearbeiter.FetchForeGroundColorFromRiD
                    (TERMINIERT_R);
                end;
                TextRect(Rect, Rect.left + 1, Rect.top + cPlanY_div_2 + 1,
                  SubItems[twh_Geaendert]);
                draw(Rect.left + 1, Rect.top + 1,
                  FormBearbeiter.FetchBILDFromRid(GEAENDERT_R));
                font.color := clblack;
                pen.color := FocusColor;
                MoveTo(Rect.left, Rect.top);
                LineTo(Rect.right, Rect.top);
                MoveTo(Rect.left, Rect.bottom - 1);
                LineTo(Rect.right, Rect.bottom - 1);
              end;
          else
            FillRect(Rect);
          end;
        end;
        if (ACol > 2) then
        begin
          pen.color := $303030;
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

function TFormAuftragArbeitsplatz.CreateSymbol(id: Integer): TBitMap;
begin
  result := TBitMap.create;
  SymbolList.Add(result);
  ImageList1.GetBitmap(id, result);
end;

procedure TFormAuftragArbeitsplatz.FormCreate(Sender: TObject);
var
  n: Integer;
begin

  SymbolList := TList.create;
  PhasenStatus := TStringlist.create;
  ItemsGRID := TExtendedList.create;
  ItemsMARKED := TExtendedList.create;
  ItemsQUERY := TExtendedList.create;
  ItemInformiert := TList.create;
  MonteurRIDs := TgpIntegerList.create;
  TageRIDs := TgpIntegerList.create;
  Auslastung := TAuslastung.create;
  s_Context := TStringlist.create;

  for n := 0 to High(cPhasenStatusText) do
    PhasenStatus.Add(cPhasenStatusText[n]);
  ComboBox1.items.clear;

  top := 0;
  left := 0;

  cTagX := dpiX(31);
  cPlanX := dpiX(18);
  cPlanY := dpiX(30);
  cPlanY_div_2 := cPlanY div 2;

  with ToolBar1 do
  begin
    ButtonHeight := height - 2;
    ButtonWidth := dpiX(23);
  end;
  with ToolBar2 do
  begin
    ButtonHeight := height - 2;
    ButtonWidth := dpiX(23);
  end;
  with DrawGrid1, canvas do
  begin
    DefaultRowHeight := cPlanY;
    font.name := 'Verdana';
    font.size := 16;
    font.color := clblack;
    ColCount := 10;
    ColWidths[0] := cPlanX; // Symbol(e)
    ColWidths[1] := dpiX(88); // Nummer
    ColWidths[2] := cPlanX; // Symbol(e)
    ColWidths[3] := dpiX(45); // Monteur / Auftragstyp
    ColWidths[4] := dpiX(54); // Datum
    ColWidths[5] := -dpiX(186); // Name / Straße
    ColWidths[6] := -dpiX(160); // PLZ / Ortsteil
    ColWidths[7] := -dpiX(179); // Bemerkungen!
    ColWidths[8] := FormBearbeiter.cBearbeiterLogoXd + 1; // Bearbeiter
    ColWidths[9] := 1; // Dummy (wegen der grauen Linie!)

    // ClientHeight := (ClientHeight div DefaultRowHeight) * DefaultRowHeight;
    rowCount := 0;
  end;
  dgAutoSize(DrawGrid1);

  with DrawGrid2, canvas do
  begin
    // DefaultRowHeight := 28;
    DefaultRowHeight := cPlanY;
    font.name := 'Verdana';
    font.size := 10;
    font.color := clblack;
    font.style := [];
    ColCount := 7;
    ColWidths[0] := -dpiX(46); // Monteur-Name
    ColWidths[1] := cTagX; // MO
    ColWidths[2] := cTagX; // DI
    ColWidths[3] := cTagX; // MI
    ColWidths[4] := cTagX; // DO
    ColWidths[5] := cTagX; // FR
    ColWidths[6] := 1; // Dummy (wegen der grauen Begrenzungslinue)
    rowCount := 0;
  end;
  dgAutoSize(DrawGrid2);

  // Status-Symbole
  SetLength(StatusBMPs, ord(ctsLast) + 10);
  StatusBMPs[ord(ctsDatenFehlen)] := CreateSymbol(88);
  StatusBMPs[ord(ctsTerminiert)] := CreateSymbol(31);
  StatusBMPs[ord(ctsAngeschrieben)] := CreateSymbol(23);
  StatusBMPs[ord(ctsMonteurinformiert)] := CreateSymbol(12);
  StatusBMPs[ord(ctsErfolg)] := CreateSymbol(87);
  StatusBMPs[ord(ctsNeuAnschreiben)] := CreateSymbol(80);
  StatusBMPs[ord(ctsHistorisch)] := CreateSymbol(47);
  StatusBMPs[ord(ctsVorgezogen)] := CreateSymbol(83);
  StatusBMPs[ord(ctsRestant)] := CreateSymbol(11);
  StatusBMPs[ord(ctsUnmoeglich)] := CreateSymbol(77);
  StatusBMPs[ord(ctsLast)] := CreateSymbol(49);
  StatusBMPs[ord(ctsLast) + 1] := CreateSymbol(56);
  // Historisch & Monteur Informiert
  StatusBMPs[ord(ctsLast) + 2] := CreateSymbol(85); // Erfolg & TAN>0
  StatusBMPs[ord(ctsLast) + 3] := CreateSymbol(86); // Unmöglich & TAN>0
  StatusBMPs[ord(ctsLast) + 4] := CreateSymbol(89); // Vorgezogen & TAN>0
  StatusBMPs[ord(ctsLast) + 5] := CreateSymbol(97); // Erfolg & TAN=0
  StatusBMPs[ord(ctsLast) + 6] := CreateSymbol(96); // Unmöglich & TAN=0
  StatusBMPs[ord(ctsLast) + 7] := CreateSymbol(98); // Vorgezogen & TAN=0
  StatusBMPs[ord(ctsLast) + 8] := CreateSymbol(10); // unterwegs = Flugzeug
  StatusBMPs[ord(ctsLast) + 9] := CreateSymbol(13); // pausiert

  SetLength(FitnessBMPs, ord(cisLast));
  FitnessBMPs[ord(cisOK)] := CreateSymbol(29);
  FitnessBMPs[ord(cisWiedervorlage)] := CreateSymbol(15);
  FitnessBMPs[ord(cisAlarm)] := CreateSymbol(17);
  FitnessBMPs[ord(cisSperreVerletzt)] := CreateSymbol(50);
  FitnessBMPs[ord(cisProbleme)] := CreateSymbol(8);

  //
  s_Baustelle := -1;
  s_Monteur := -1;
  s_Datum_Start := -1;
  s_Datum_Ende := -1;
  s_Status := -1;
  s_Vormittags := '';
  s_Art := '*';
  ToggleSortMode(s_SortMode, true);
  v_MonteurMontag := DateGet;
  Label14.caption := long2datetext(v_MonteurMontag);

  ComboBox2.items.AddStrings(PhasenStatus);
  ComboBox2.ItemIndex := 0;

  ContextWritePos := getContext;
  ContextReadPos := -1;

  SaveEdits;

end;

procedure TFormAuftragArbeitsplatz.FormDestroy(Sender: TObject);
begin
  {
    var
    n: Integer;
    for n := 0 to pred(SymbolList.count) do
    TObject(SymbolList[n]).free;
    SymbolList.free;
    PhasenStatus.free;
    ItemsGRID.free;
    ItemsMARKED.free;
    ItemsQUERY.free;
    ItemInformiert.free;
    MonteurRIDs.free;
    TageRIDs.free;
    Auslastung.free;
    if assigned(LastRequestedSub) then
    LastRequestedSub.free;
  }
end;

procedure TFormAuftragArbeitsplatz.DrawGrid1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACol: Integer;
begin
  if Button = mbright then
  begin
    DrawGrid1.MouseToCell(X, Y, ACol, SelectedRow);
    if (SelectedRow >= 0) and (SelectedRow < DrawGrid1.rowCount) then
    begin
      DrawGrid1.Row := SelectedRow;
      ContextPopUp(DrawGrid1.left + X + 5, DrawGrid1.top + Y);
    end;
  end;
end;

procedure TFormAuftragArbeitsplatz.ContextPopUp(X, Y: Integer);
begin
  MenuItem_ZaehlernummerSortierung.Enabled := not(HistorieAnzeigen);
  WordModusANAUS1.Enabled := not(HistorieAnzeigen);
  PopupMenu1.PopUp(X, Y);
end;

procedure TFormAuftragArbeitsplatz.Button4Click(Sender: TObject);
begin
  application.processmessages;
  if InsideSearch then
  begin
    BreakSet := true;
  end
  else
  begin
    if assigned(s_List) then
      FreeAndNil(s_List);
    ShowExtendedWarning := true;
    Suche;
  end;
end;

procedure TFormAuftragArbeitsplatz.Suche;
var
  StartTime: dword;
  OneIf: boolean;
  n: Integer;
  OneLine: string;
  sqlCountBeforeExtended: Integer;
  sqlCountAfterExtended: Integer;

  // Filter
  doExtraFIlter: boolean;
  FilterPassed: boolean;
  FilterStrings: TStringlist;

  S: String;

  procedure CheckOneIf;
  begin
    if OneIf then
    begin
      IB_Cursor1.sql.Add('    AND');
    end
    else
    begin
      IB_Cursor1.sql.Add('WHERE');
      OneIf := true;
    end;
  end;

  function CheckDate(const S: String): boolean;
  begin
    result := LimitString(S, '0123456789') <> '';
  end;

begin
  BeginHourGlass;
  SaveContext;
  //
  ComboBox1Exit(self);
  HistorischBeenden;
  FilterStrings := TStringlist.create;
  doExtraFIlter := false;
  sqlCountBeforeExtended := 0;
  sqlCountAfterExtended := 0;

  with IB_Cursor1 do
  begin
    OneIf := false;
    sql.clear;
    sql.Add('SELECT');
    sql.Add('RID');
    FormAuftragSuche.AddExtraFields(sql);
    sql.Add('FROM AUFTRAG');

    if assigned(s_List) then
    begin

      //
      CheckOneIf;
      sql.Add('RID IN ' + ListasSQL(s_List));

    end
    else
    begin

      // dieser Context wird später so abgespeichert
      // ich muss jetzt speichern, da der User unterwegs noch Eingaben
      // machen könnte.
      SaveEdits;

      s_Datum_Start := Date2Long(ComboBox4.Text);
      if not(dateOK(s_Datum_Start)) then
        s_Datum_Start := -1;

      s_Datum_Ende := Date2Long(ComboBox5.Text);
      if not(dateOK(s_Datum_Ende)) then
        s_Datum_Ende := -1;

      if (s_Monteur >= 0) then
      begin
        CheckOneIf;
        sql.Add('    ( (MONTEUR1_R=' + inttostr(s_Monteur) + ') OR (MONTEUR2_R='
          + inttostr(s_Monteur) + ') )');
      end;

      if (s_Monteur = -2) then
      begin
        CheckOneIf;
        sql.Add('    (MONTEUR1_R IS NULL)');
      end;

      if (s_Baustelle <> -1) then
      begin
        CheckOneIf;
        sql.Add('    ( BAUSTELLE_R=' + inttostr(s_Baustelle) + ' )');
      end;

      if (s_Vormittags <> '') then
      begin
        CheckOneIf;
        sql.Add('    ( VORMITTAGS=''' + s_Vormittags + ''' )');
      end;

      if (s_Datum_Start <> -1) then
      begin
        CheckOneIf;
        sql.Add('    ( AUSFUEHREN>=''' + Long2date(s_Datum_Start) + ''' )');
      end;

      if (s_Datum_Ende <> -1) then
      begin
        CheckOneIf;
        sql.Add('    ( AUSFUEHREN<=''' + Long2date(s_Datum_Ende) + ''' )');
      end;

      if (s_Art <> '*') then
      begin
        CheckOneIf;
        sql.Add('    ( ART=''' + s_Art + ''' )');
      end;

      if (Edit2.Text <> '*') and (Edit2.Text <> '') then
      begin
        CheckOneIf;
        if (strtol(Edit2.Text) = 0) then
          sql.Add('    ((NUMMER IS NULL) OR (NUMMER=0))')
        else
          sql.Add('    ( NUMMER=' + inttostr(strtol(Edit2.Text)) + ' )');
      end;

      if CheckBox3.checked then
      begin
        CheckOneIf;
        sql.Add('    ( WORDEMPFAENGER<>''' + ''' )');
      end;

      // Phasen-Status
      if ComboBox2.visible then
      begin
        case s_Status of
          - 1:
            begin { "*" }
              CheckOneIf;
              sql.Add(' (STATUS<>' + inttostr(ord(ctsHistorisch)) + ')');
            end;
          ord(ctsLast):
            begin // 'offen'
              CheckOneIf;
              sql.Add(' (STATUS IN (0,1,5,8))');
              // CheckOneIf;
              // sql.Add(' ( WORDEXPORT IS NULL )');
            end;
          ord(ctsLast) + 1:
            begin // 'anschreibbar',
              CheckOneIf;
              sql.Add(' (STATUS IN (1,2,3,5))');
            end;
          ord(ctsLast) + 2:
            begin // 'abgearbeitet'
              CheckOneIf;
              sql.Add(' (STATUS IN (4,7,9))');
            end;
          ord(ctsLast) + 3:
            begin // 'gemeldet'
              CheckOneIf;
              sql.Add(' ( EXPORT_TAN IS NOT NULL ) AND');
              sql.Add(' ( STATUS <> 6)');
            end;
          ord(ctsLast) + 4:
            begin // 'ungemeldet'
              CheckOneIf;
              sql.Add(' (EXPORT_TAN is null) and');
              sql.Add(' (STATUS in (4,7,9))');
            end;
          ord(ctsLast) + 5:
            begin // 'unterwegs'
              CheckOneIf;
              sql.Add(' (MONDA_ABRUF is not null) and');
              sql.Add(' (STATUS<>6)');
            end;
          ord(ctsLast) + 6:
            begin // 'pausiert'
              CheckOneIf;
              sql.Add(' (WIEDERVORLAGE is not null) and');
              sql.Add(' (STATUS<>6)');
            end;
        else
          CheckOneIf;
          sql.Add(' (STATUS=' + inttostr(s_Status) + ')');
        end;
      end;

      // Erweiterte Suche mit der Lupe
      sqlCountBeforeExtended := sql.count;
      with FormAuftragSuche do
      begin

        //
        with FormAuftragSuche do
          doExtraFIlter := (eMonteur_Info <> '') or (eZaehler_Info <> '') or
            (eIntern_Info <> '');
        //
        if doExtraFIlter then
          dec(sqlCountBeforeExtended); // spei - übel

        //
        if (Edit2.Text <> '') then
        begin
          CheckOneIf;
          if pos(',', Edit2.Text) = 0 then
            sql.Add('    (KUNDE_ORTSTEIL_CODE=''' + Edit2.Text + ''')')
          else
          begin
            OneLine := Edit2.Text;
            sql.Add('    (KUNDE_ORTSTEIL_CODE in (');
            while (OneLine <> '') do
            begin
              if (pos(',', OneLine) = 0) then
                sql.Add('''' + cutblank(nextp(OneLine, ',')) + '''')
              else
                sql.Add('''' + cutblank(nextp(OneLine, ',')) + ''',');
            end;
            sql.Add('    ))');
          end;
        end;

        //
        if (Edit3.Text <> '') then
        begin
          CheckOneIf;
          if pos(',', Edit3.Text) = 0 then
            sql.Add('    (PLANQUADRAT=''' + Edit3.Text + ''')')
          else
          begin
            OneLine := Edit3.Text;
            sql.Add('    (PLANQUADRAT in (');
            while (OneLine <> '') do
            begin
              if (pos(',', OneLine) = 0) then
                sql.Add('''' + cutblank(nextp(OneLine, ',')) + '''')
              else
                sql.Add('''' + cutblank(nextp(OneLine, ',')) + ''',');
            end;
            sql.Add('    ))');
          end;
        end;

        // 22.04.09: Ronny Schupeta
        // Unscharfe Suche nach einem Planquadrat
        if WellPQ(edit8.Text) <> '' then
        begin
          CheckOneIf;
          sql.Add('    (PLANQUADRAT starts with ''' +
            WellPQ(edit8.Text) + ''')');
        end;

        // Einschränkung nach Sperrfrist
        if CheckDate(IB_Date2.Text) then
        begin
          CheckOneIf;
          sql.Add('    (SPERRE_VON >= ''' + IB_Date2.Text + ''')');
        end;
        if CheckDate(IB_Date1.Text) then
        begin
          CheckOneIf;
          sql.Add('    (SPERRE_BIS <= ''' + IB_Date1.Text + ''')');
        end;

        // Einschränkung nach Zeitraum
        if CheckDate(IB_Date3.Text) then
        begin
          CheckOneIf;
          sql.Add('    (ZEITRAUM_VON >= ''' + IB_Date3.Text + ''')');
        end;
        if CheckDate(IB_Date4.Text) then
        begin
          CheckOneIf;
          sql.Add('    (ZEITRAUM_BIS <= ''' + IB_Date4.Text + ''')');
        end;

        // Einschränkung nach dem Protokollfeld
        if Trim(edit7.Text) <> '' then
        begin
          CheckOneIf;
          sql.Add('    (UPPER(PROTOKOLL) like ''%' + UpperCase(Trim(edit7.Text))
            + '%'')');
        end;

        //
        if (Memo1.lines.count > 0) then
          if (noblank(Memo1.lines[0]) <> '') then
          begin
            CheckOneIf;
            for n := 0 to pred(Memo1.lines.count) do
              sql.Add(Memo1.lines[n]);
          end;

        // Suche nach Zählerstand (alt)
        if Trim(Edit9.Text) <> '' then
        begin
          CheckOneIf;
          sql.Add('    (ZAEHLER_STAND_ALT = ' + QuotedStr(Edit9.Text) + ')');
        end;

        // Suche nach Zählerstand (neu)
        if Trim(Edit10.Text) <> '' then
        begin
          CheckOneIf;
          sql.Add('    (ZAEHLER_STAND_NEU = ' + QuotedStr(Edit10.Text) + ')');
        end;

        // 21.04.09: Ronny Schupeta
        // Zusätzliche SQL-Statements, die einmalig einbezogen werden.
        // s_OneTimeAddSQL wird nach Auswertung geleert.
        if Trim(s_OneTimeAddSQL) <> '' then
        begin
          try
            CheckOneIf;
            sql.Add(s_OneTimeAddSQL);
          finally
            s_OneTimeAddSQL := '';
          end;
        end;
      end;
      sqlCountAfterExtended := sql.count;

    end;

    // Sortierung in den sql-String hinzu
    SortSQL(sql);

    if FormAuftragSuche.checkbox1.checked then
      ShowMessage(HugeSingleLine(sql, #13));

    if ShowExtendedWarning then
      if (sqlCountBeforeExtended <> sqlCountAfterExtended) then
        ShowMessage
          ('Beachten Sie, dass immer noch eingaben der Erweiterten Suche' + #13
          + '(Lupensymbol) die Suchergebnisse einschränken!');
    ShowExtendedWarning := false;

    try
      ApiFirst;
      GridDisable := true;
    except
      on e: exception do
        ShowMessage(e.message);
    end;

    if GridDisable then
    begin
      InsideSearch := true;

      Button4.caption := '&Abbrechen';
      ItemsGRID.clear;

      StartTime := frequently;
      while not(eof) do
      begin

        if doExtraFIlter then
        begin
          with FormAuftragSuche do
          begin
            FilterPassed := true;
            repeat
              if (eMonteur_Info <> '') then
              begin
                S := TXLowerCase(eMonteur_Info);
                FieldByName('MONTEUR_INFO').AssignTo(FilterStrings);
                FilterPassed := false;
                for n := 0 to pred(FilterStrings.count) do
                  if pos(S, TXLowerCase(FilterStrings[n])) > 0 then
                  begin
                    FilterPassed := true;
                    break;
                  end;
                if not(FilterPassed) then
                  break;
              end;

              if (eZaehler_Info <> '') then
              begin
                FieldByName('ZAEHLER_INFO').AssignTo(FilterStrings);
                FilterPassed := false;
                for n := 0 to pred(FilterStrings.count) do
                  if pos(eZaehler_Info, FilterStrings[n]) > 0 then
                  begin
                    FilterPassed := true;
                    break;
                  end;
                if not(FilterPassed) then
                  break;
              end;

              if (eIntern_Info <> '') then
              begin
                FieldByName('INTERN_INFO').AssignTo(FilterStrings);
                FilterPassed := false;
                for n := 0 to pred(FilterStrings.count) do
                  if pos(eIntern_Info, FilterStrings[n]) > 0 then
                  begin
                    FilterPassed := true;
                    break;
                  end;
                if not(FilterPassed) then
                  break;
              end;

            until true;

          end;
          if FilterPassed then
            ItemsGRID.Add(TObject(Fields[0].AsInteger));
        end
        else
        begin
          ItemsGRID.Add(TObject(Fields[0].AsInteger));
        end;

        APInext;
        if frequently(StartTime, 333) then
        begin
          Label2.caption := inttostr(ItemsGRID.count);
          application.processmessages;
          if BreakSet then
          begin
            BreakSet := false;
            break;
          end;
        end;
      end;
      InsideSearch := false;
      Button4.caption := 'an&zeigen';
      ItemsQUERY.assign(ItemsGRID);
      close;
      DrawGrid1.rowCount := ItemsGRID.count;
      GridDisable := false;
    end;

    DrawGrid1.SetFocus;
    RefreshCountAnzeige;
    InvalidateCache_Auftrag;
    DrawGrid1.refresh;
  end;
  FilterStrings.free;

  EndHourGlass;
end;

procedure TFormAuftragArbeitsplatz.RefreshCountAnzeige;
begin
  Label2.caption := inttostr(ItemsMARKED.count) + '/' +
    inttostr(ItemsGRID.count);
  Button2.caption := '&Alle ' + inttostr(ItemsQUERY.count) + ' zeigen';
end;

procedure TFormAuftragArbeitsplatz.ClearMarkierte;
begin
  if (ItemsMARKED.count > 0) then
  begin
    BeginHourGlass;
    SaveContext;
    ItemsMARKED.clear;
    EndHourGlass;
  end;
end;

procedure TFormAuftragArbeitsplatz.ToolButton5Click(Sender: TObject);
begin
  // nicht mehr markieren
  if (ItemsMARKED.count > 0) then
  begin
    BeginHourGlass;
    ClearMarkierte;
    InvalidateCache_Auftrag;
    DrawGrid1.refresh;
    RefreshCountAnzeige;
    EndHourGlass;
  end;
end;

procedure TFormAuftragArbeitsplatz.ToolButton6Click(Sender: TObject);
var
  AttachementFName: string;
  qMAIL: TIB_Query;
  eMessage: TStringlist;
  n, k: Integer;
  sMonteure: TgpIntegerObjectList;
  sAttachements: TStringlist;
  AUFTRAG_R, MONTEUR_R: Integer;
  Stat_Mails: Integer;
  Stat_Auftraege: Integer;
  sAUFTRAEGE: TgpIntegerList;
begin

  // Ausgabe in eine! grosse HTML Datei
  if ToolButton6Ctrl then
  begin

    BeginHourGlass;
    sAUFTRAEGE := TgpIntegerList.create;
    for n := 0 to pred(ItemsMARKED.count) do
      sAUFTRAEGE.Add(Integer(ItemsMARKED[n]));
    EndHourGlass;

    OpenShell(AsHTML(sAUFTRAEGE));
    sAUFTRAEGE.free;
    exit;
  end;

  // eMail an alle markierten
  if (ItemsMARKED.count > 0) then
  begin
    BeginHourGlass;
    Stat_Mails := 0;
    Stat_Auftraege := 0;

    // Nach Monteuren zusammenfassen Erst mal nach allen Monteuren auftrennen ermitteln
    sMonteure := TgpIntegerObjectList.create;
    for n := 0 to pred(ItemsMARKED.count) do
    begin
      AUFTRAG_R := Integer(ItemsMARKED[n]);
      MONTEUR_R := e_r_sql('select MONTEUR1_R from AUFTRAG where RID=' +
        inttostr(AUFTRAG_R));
      k := sMonteure.indexof(MONTEUR_R);
      if (k = -1) then
      begin
        sAttachements := TStringlist.create;
        sMonteure.AddObject(MONTEUR_R, sAttachements);
      end
      else
      begin
        sAttachements := TStringlist(sMonteure.objects[k]);
      end;

      // Verbuchen
      { 1 } sAttachements.Add(AsHTML(AUFTRAG_R));
      { 2 } e_x_sql('update AUFTRAG set MONTEUREXPORT=''now'' where RID=' +
        inttostr(AUFTRAG_R));
      inc(Stat_Auftraege);
    end;

    // Pro Monteur, eine Mail
    qMAIL := DataModuleDatenbank.nQuery;
    eMessage := TStringlist.create;
    for n := 0 to pred(sMonteure.count) do
    begin

      MONTEUR_R := sMonteure[n];
      sAttachements := TStringlist(sMonteure.objects[n]);

      // eMail Antrag in die Datenbank stellen!
      // Nachrichten Text dieser eMail zusammenbauen
      with eMessage do
      begin
        if sAttachements.count > 1 then
          Add('Info zu ' + inttostr(sAttachements.count) + ' Aufträgen ' + ' ('
            + DatumLog + ' ' + uhr8 + ')')
        else
          Add('Info zu einem Auftrag ' + ' (' + DatumLog + ' ' + uhr8 + ')');
        Add('Mit freundlichen Grüssen');
        Add('Ihr Auftrags - Team');
        Add(datum + ' ' + Uhr);
        for k := 0 to pred(sAttachements.count) do
          Add('Anlage:' + sAttachements[k]);
      end;

      // qMail.FieldByName('NACHRICHT').Assign (sAttachements);
      // Den Nachrichten Text jetzt speichern
      with qMAIL do
      begin
        sql.Add('select * from EMAIL for update');
        insert;
        FieldByName('RID').AsInteger := cRID_AutoInc;
        FieldByName('NACHRICHT').assign(eMessage);
        FieldByName('PERSON_R').AsInteger := MONTEUR_R;
        post;
      end;
      inc(Stat_Mails);
    end;
    eMessage.free;
    qMAIL.free;
    sMonteure.free;
    EndHourGlass;

    ShowMessage('In ' + inttostr(Stat_Mails) + ' Mail(s) wurde über ' +
      inttostr(Stat_Auftraege) + ' Aufträge informiert!');

  end;
end;

procedure TFormAuftragArbeitsplatz.ToolButton6MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ToolButton6Ctrl := ssCtrl in Shift;

end;

procedure TFormAuftragArbeitsplatz.ToolButton10Click(Sender: TObject);
var
  n: Integer;
begin
  // nur noch die markierten anzeigen!
  if (ItemsMARKED.count > 0) then
  begin

    BeginHourGlass;
    SaveContext;
    SaveCursorPosition;

    // unmarkierte rauslöschen
    for n := pred(ItemsGRID.count) downto 0 do
      if (ItemsMARKED.indexof(ItemsGRID[n]) = -1) then
        ItemsGRID.Delete(n);

    // unsichtbare markierte (unten) hinzunehmen
    for n := 0 to pred(ItemsMARKED.count) do
      if (ItemsGRID.indexof(ItemsMARKED[n]) = -1) then
        ItemsGRID.Add(ItemsMARKED[n]);

    // Auswertung übernehmen in die s_list!
    if (ItemsGRID.count < 500) then
    begin

      //
      if assigned(s_List) then
        FreeAndNil(s_List);
      s_List := TgpIntegerList.create;
      for n := 0 to pred(ItemsGRID.count) do
        s_List.Add(Integer(ItemsGRID[n]));

    end;

    DrawGrid1.rowCount := ItemsGRID.count;
    RestoreCursorPosition;

    InvalidateCache_Auftrag;
    DrawGrid1.refresh;
    RefreshCountAnzeige;
    EndHourGlass;
  end;
end;

procedure TFormAuftragArbeitsplatz.ToolButton9Click(Sender: TObject);
var
  NewList: TExtendedList;
  n: Integer;
begin
  // invert marked list
  BeginHourGlass;
  SaveContext;
  NewList := TExtendedList.create;
  for n := 0 to pred(ItemsGRID.count) do
    if (ItemsMARKED.indexof(ItemsGRID[n]) = -1) then
      NewList.Add(ItemsGRID[n]);
  FreeAndNil(ItemsMARKED);
  ItemsMARKED := NewList;
  InvalidateCache_Auftrag;
  DrawGrid1.refresh;
  RefreshCountAnzeige;
  EndHourGlass;
end;

procedure TFormAuftragArbeitsplatz.ToolButton7Click(Sender: TObject);
var
  n: Integer;
begin
  // Alles in der aktuellen Ansicht markieren
  // imp pend: Bug: hier logical AND
  BeginHourGlass;
  SaveContext;
  if (ItemsMARKED.count = 0) then
  begin
    for n := 0 to pred(ItemsGRID.count) do
      ItemsMARKED.Add(ItemsGRID[n]); // TList
  end
  else
  begin
    ItemsMARKED.clear;
  end;
  InvalidateCache_Auftrag;
  DrawGrid1.refresh;
  RefreshCountAnzeige;
  EndHourGlass;
end;

procedure TFormAuftragArbeitsplatz.ToolButton15Click(Sender: TObject);
begin
  // einzelnen Datensatz ausgeben ins Word!
  if (ItemsGRID.count > 0) then
    OutCSV(Integer(ItemsGRID[DrawGrid1.Row]), s_Baustelle);
end;

procedure TFormAuftragArbeitsplatz.MenuItem_WechselDatumSortierungClick
  (Sender: TObject);
begin
  ToggleSortMode(csm_WechselSortierung);
  Suche;

end;

function TFormAuftragArbeitsplatz.WordDataFromRID(RID: Integer): string;

  function NoSemi(n: Integer; const S: string): string;
  var
    k: Integer;
  begin
    result := S;
    if (n >= 28) and (n <= 36) then
    begin
      k := pos('_', result);
      if (k > 0) then
        result := copy(result, succ(k), MaxInt);
    end;
    ersetze(';', '*', result);
    ersetze('"', '''''', result);
  end;

var
  SubItems: TStringlist;
  n: Integer;
begin
  SubItems := e_r_AuftragItems(RID);
  result := '';
  for n := 0 to pred(SubItems.count) do
    result := result + NoSemi(n, SubItems[n]) + ';';
end;

procedure TFormAuftragArbeitsplatz.ToolButton14Click(Sender: TObject);
var
  UseMarked: boolean;
  OutList: TgpIntegerList;
  n: Integer;
begin

  // Umfang festlegen
  UseMarked := false;
  ItemsMARKED.LogicalAND(ItemsGRID);
  if (ItemsMARKED.count > 0) then
    if doit('Es sind markierte Zeilen enthalten.' + #13 +
      'Drücken Sie <abbrechen>, um alle Datensätze in der Anzeige zu verwenden!'
      + #13 + 'Sollen nur ' + inttostr(ItemsMARKED.count) +
      ' markierte Datensätze verwendet werden') then
      UseMarked := true;

  // Liste erstellen und ausgeben!
  OutList := TgpIntegerList.create;
  if UseMarked then
  begin
    for n := 0 to pred(ItemsMARKED.count) do
      OutList.Add(Integer(ItemsMARKED[n]))
  end
  else
  begin
    for n := 0 to pred(ItemsGRID.count) do
      OutList.Add(Integer(ItemsGRID[n]));
  end;
  OutCSV(OutList, s_Baustelle);
  OutList.free;

end;

procedure TFormAuftragArbeitsplatz.ToolButton1Click(Sender: TObject);
var
  _Datum: TANFiXDate;
  sub: TStringlist;
begin
  if (ItemsGRID.count > 0) then
  begin
    sub := e_r_AuftragItems(Integer(ItemsGRID[DrawGrid1.Row]));
    _Datum := Date2Long(sub[0]);
    if dateOK(_Datum) then
      v_MonteurMontag := _Datum;
    a_baustelle := e_r_BaustelleRIDFromKuerzel(sub[24]);
    RefreshMonteurAuslastung(a_baustelle);
  end;
end;

procedure TFormAuftragArbeitsplatz.ToolButton16Click(Sender: TObject);
var
  _Monteur1: string;
  _Monteur2: string;
  _date: string;
  _vorm: string;
  sub: TStringlist;
  AllOK: boolean;
  DieMonteure: string;
  TARGET_R: Integer;
begin
  // Termin nach unten kopieren!
  TARGET_R := cRID_Null;

  if ItemsGRID.count > 0 then
  begin
    sub := e_r_AuftragItems(Integer(ItemsGRID[DrawGrid1.Row]));
    DieMonteure := sub[2];
    _Monteur1 := nextp(DieMonteure, c2Monteure);
    _Monteur2 := nextp(DieMonteure, c2Monteure);
    _date := sub[0];
    _vorm := sub[12];
    AllOK := false;
    repeat
      if (_Monteur1 = '') then
      begin
        ShowMessage('Es wurde kein Monteur zugeordnet!');
        break;
      end;

      if not(dateOK(_date)) then
      begin
        ShowMessage('Es wurde kein Ausführungsdatum zugeordnet!');
        break;
      end;

      if pos(_vorm, cVormittagsChar + cNachmittagsChar) = 0 then
      begin
        ShowMessage('vormittags oder nachmittags nicht gesetzt!');
        break;
      end;

      if (DrawGrid1.Row = pred(DrawGrid1.rowCount)) then
      begin
        ShowMessage('Am Ende der Liste kann nicht weiterkopiert werden!');
        break;
      end;

      TARGET_R := Integer(ItemsGRID[succ(DrawGrid1.Row)]);

      AllOK := true;
    until true;

    if AllOK then
    begin
      BeginHourGlass;
      // DataModuleHebu.BeginSQLDebug;
      if not(assigned(qAUFTRAGred)) then
      begin
        qAUFTRAGred := DataModuleDatenbank.nQuery;
        with qAUFTRAGred do
        begin
          sql.Add('select');
          sql.Add(' RID,');
          sql.Add(' STATUS,');
          sql.Add(' MONTEUR1_R,');
          sql.Add(' MONTEUR2_R,');
          sql.Add(' AUSFUEHREN,');
          sql.Add(' VORMITTAGS,');
          sql.Add(' KUNDE_NAME1,');
          sql.Add(' KUNDE_NAME2,');
          sql.Add(' VERBRAUCH_PRO_JAHR,');
          sql.Add(' VERBRAUCH_ZAEHLER_STAND,');
          sql.Add(' VERBRAUCH_DATUM,');
          sql.Add(' ZAEHLER_INFO,');
          sql.Add(' MONTEUR_INFO,');
          sql.Add(' MONTEUREXPORT,');
          sql.Add(' TERMINIERT_R,');
          sql.Add(' MONDA_MELDUNG,');
          sql.Add(' ZAEHLER_WECHSEL,');
          sql.Add(' AUFWAND_SCHUTZ,');
          sql.Add(' AUFWAND,');
          sql.Add(' BAUSTELLE_R,');
          sql.Add(' WORDEXPORT,');
          sql.Add(' POSTLEITZAHL_R,');
          sql.Add(' KUNDE_STRASSE,');
          sql.Add(' KUNDE_ORT,');
          sql.Add(' STRASSE,');
          sql.Add(' KUNDE_ORTSTEIL_CODE,');
          sql.Add(' KUNDE_ORTSTEIL,');
          sql.Add(' PLANQUADRAT,');
          sql.Add(' EVENODD,');
          sql.Add(' BEARBEITER_R,');
          sql.Add(' GEAENDERT,');
          sql.Add(' EXPORT_TAN,');
          sql.Add(' FITNESS,');
          sql.Add(' SPERRE_VON,');
          sql.Add(' SPERRE_BIS,');
          sql.Add(' ZEITRAUM_VON,');
          sql.Add(' ZEITRAUM_BIS,');
          sql.Add(' MASTER_R');
          sql.Add('from');
          sql.Add('AUFTRAG where RID=:CROSSREF for update');
          open;
        end;
      end;
      with qAUFTRAGred do
      begin
        ParamByName('CROSSREF').AsInteger := TARGET_R;
        first;
        if not(eof) then
        begin
          edit;
          FieldByName('MONTEUR1_R').AsInteger :=
            e_r_MonteurRIDFromKuerzel(_Monteur1);
          if (_Monteur2 <> '') then
            FieldByName('MONTEUR2_R').AsInteger :=
              e_r_MonteurRIDFromKuerzel(_Monteur2)
          else
            FieldByName('MONTEUR2_R').clear;
          FieldByName('AUSFUEHREN').AsDate := long2datetime(Date2Long(_date));
          FieldByName('VORMITTAGS').AsString := _vorm[1];
          ForceHistorischer := true;
          AuftragBeforePost(qAUFTRAGred);
          if HistorischerErzeugt then
            HistorischeFlash;
          post;
        end;
      end;
      ShouldRefreshBelastung := false;
      ShouldRefreshBelastungIn := 2800;
      ShouldRefreshListe := true;
      DrawGrid1.Row := succ(DrawGrid1.Row);

      (*
        ShowAuftrag;
        application.processmessages;
        with formAuftrag do
        begin
        EnsureEditState;
        IB_Query1.FieldByName('MONTEUR1_R').AsInteger := FormMonteur.ObtainRIDFromKuerzel(_Monteur1);
        if (_Monteur2 <> '') then
        IB_Query1.FieldByName('MONTEUR2_R').AsInteger := FormMonteur.ObtainRIDFromKuerzel(_Monteur2)
        else
        IB_Query1.FieldByName('MONTEUR2_R').clear;
        IB_Query1.FieldByName('AUSFUEHREN').AsDate := long2datetime(date2long(_date));
        case _Vorm[1] of
        cVormittagsChar: RadioButton1.checked := true;
        cNachmittagsChar: RadioButton2.checked := true;
        else
        RadioButton3.checked := true;
        end;
        IB_Query1.post;
        ShouldRefreshBelastung := false;
        ShouldRefreshBelastungIn := 2800;
        ShouldRefreshListe := true;
        close;
        end;
      *)
      // DataModuleHebu.EndSQLDebug;
      EndHourGlass;
    end;
  end;
end;

procedure TFormAuftragArbeitsplatz.Edit1KeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = #13) then
  begin
    Button1Click(Sender);
    Key := #0;
  end;
end;

procedure TFormAuftragArbeitsplatz.Edit3KeyPress(Sender: TObject;
  var Key: Char);
var
  lRID: TgpIntegerList;
begin
  if (Key = #13) then
  begin
    BeginHourGlass;
    Key := #0;
    if (Edit3.Text = 'AY1') then
      doAynaci1;
    if (Edit3.Text = 'AY2') then
      doAynaci2;

    lRID := TgpIntegerList.CreateFrom(ItemsGRID);
    Funktionen_Transaktion.Dispatch(Edit3.Text, lRID);
    lRID.free;

    Edit3.Text := '';

    // Ansicht wieder auffrischen
    NotifyGrid1;
    EndHourGlass;
  end;
end;

procedure TFormAuftragArbeitsplatz.Button1Click(Sender: TObject);
var
  n: Integer;
  ClientSorter: TStringlist;
  RID: Integer;
  cAUFTRAG: TIB_Cursor;

  //
  _TheSearch: TWordIndex;
  _TheEntry: string;
  LokalSearchFName: string;

begin

  // row row
  BeginHourGlass;
  _TheSearch := nil;

  if (Edit1.Text <> '') then
  begin

    if (pos(':', Edit1.Text) > 0) then
    begin
      // LOKALE Suche
      if not(assigned(LokalerAuftragsIndex)) then
        LokalerAuftragsIndex := TWordIndex.create(nil);

      LokalSearchFName := SearchDir + format(cBaustelleIndexFName,
        [e_r_BaustelleRIDFromKuerzel(nextp(Edit1.Text, ':', 0))]);
      if (LokalerAuftragsIndex.LastFileName <> LokalSearchFName) then
      begin
        if FileExists(LokalSearchFName) then
        begin
          LokalerAuftragsIndex.LoadFromFile(LokalSearchFName);
          _TheSearch := LokalerAuftragsIndex;
        end;
      end
      else
      begin
        if (LokalerAuftragsIndex.LastFileName <> '') then
        begin
          LokalerAuftragsIndex.ReLoadIfNew;
          _TheSearch := LokalerAuftragsIndex;
        end;
      end;
      _TheEntry := nextp(Edit1.Text, ':', 1);
    end
    else
    begin

      if not(assigned(GlobalerAuftragsIndex)) then
      begin
        if FileExists(SearchDir + cAuftragsIndexFName) then
        begin

          GlobalerAuftragsIndex := TWordIndex.create(nil);
          GlobalerAuftragsIndex.LoadFromFile(SearchDir + cAuftragsIndexFName);
          _TheSearch := GlobalerAuftragsIndex;
        end;
      end
      else
      begin
        GlobalerAuftragsIndex.ReLoadIfNew;
        _TheSearch := GlobalerAuftragsIndex;
      end;
      _TheEntry := Edit1.Text;

    end;

    if assigned(_TheSearch) then
    begin
      SaveContext;

      _TheSearch.Search(_TheEntry);

      // globale Suche?
      if not(CheckBox5.checked) then
        _TheSearch.FoundList.LogicalAND(ItemsQUERY);

      // sortieren nach "Baustelle,Strasse"
      if (_TheSearch.FoundList.count > 1) then
      begin
        ClientSorter := TStringlist.create;
        ClientSorter.Capacity := _TheSearch.FoundList.count;
        cAUFTRAG := DataModuleDatenbank.nCursor;
        with cAUFTRAG do
        begin
          sql.Add('SELECT BAUSTELLE_R,STRASSE FROM AUFTRAG WHERE RID=:CROSSREF');
          open;
          for n := 0 to pred(_TheSearch.FoundList.count) do
          begin
            RID := Integer(_TheSearch.FoundList[n]);
            ParamByName('CROSSREF').AsInteger := RID;
            ApiFirst;
            if not(eof) then
              ClientSorter.AddObject
                (e_r_BaustelleKuerzel(FieldByName('BAUSTELLE_R').AsInteger) +
                FieldByName('STRASSE').AsString, pointer(RID));
          end;
          ClientSorter.sort;
          _TheSearch.FoundList.clear;
          for n := 0 to pred(ClientSorter.count) do
            _TheSearch.FoundList.Add(ClientSorter.objects[n]);
        end;
        ClientSorter.free;
        cAUFTRAG.free;
      end;
      //
      ItemsGRID.clear;
      for n := 0 to pred(_TheSearch.FoundList.count) do
        ItemsGRID.Add(_TheSearch.FoundList[n]);

      // suche in aktueller Selektion
      NotifyGrid1;
      SaveEdits;
    end
    else
    begin
      Button4Click(Sender);
    end;
  end;
  EndHourGlass;
end;

procedure TFormAuftragArbeitsplatz.NotifyGrid1;
begin
  DrawGrid1.rowCount := ItemsGRID.count;
  InvalidateCache_Auftrag;
  DrawGrid1.refresh;
  RefreshCountAnzeige;
  DrawGrid1.SetFocus;
end;

procedure TFormAuftragArbeitsplatz.DrawGrid1DblClick(Sender: TObject);
begin
  ShowAuftrag;
end;

procedure TFormAuftragArbeitsplatz.ComboBox3Change(Sender: TObject);
begin
  //
  repeat
    if ComboBox3.Text = '*' then
    begin
      s_Monteur := -1;
      break;
    end;
    if ComboBox3.Text = 'ohne' then
    begin
      s_Monteur := -2;
      break;
    end;
    s_Monteur := e_r_MonteurRIDFromKuerzel(ComboBox3.Text);
  until true;
end;

procedure TFormAuftragArbeitsplatz.ComboBox4DropDown(Sender: TObject);
var
  n: Integer;
  AllTheDatums: TStringlist;
  _Datum: TANFiXDate;
  sub: TStringlist;
begin
  BeginHourGlass;
  AllTheDatums := TStringlist.create;
  for n := 0 to pred(ItemsGRID.count) do
  begin
    sub := e_r_AuftragItems(Integer(ItemsGRID[n]));
    _Datum := Date2Long(sub[0]);
    if _Datum > 0 then
      AllTheDatums.Add(inttostrN(_Datum, 8));
  end;
  AllTheDatums.sort;
  removeDuplicates(AllTheDatums);
  for n := 0 to pred(AllTheDatums.count) do
    AllTheDatums[n] := Long2date(strtointdef(AllTheDatums[n], 0));

  ComboBox4.items.assign(AllTheDatums);
  ComboBox4.items.insert(0, '*');
  ComboBox5.items.assign(ComboBox4.items);
  AllTheDatums.free;
  EndHourGlass;
end;

procedure TFormAuftragArbeitsplatz.ComboBox6DropDown(Sender: TObject);
var
  n: Integer;
  AllTheDatums: TStringlist;
  sub: TStringlist;
begin
  BeginHourGlass;

  AllTheDatums := TStringlist.create;
  for n := 0 to pred(ItemsGRID.count) do
  begin
    sub := e_r_AuftragItems(Integer(ItemsGRID[n]));
    AllTheDatums.Add(sub[4]);
  end;
  AllTheDatums.sort;
  removeDuplicates(AllTheDatums);

  ComboBox6.items.assign(AllTheDatums);
  ComboBox6.items.insert(0, '*');
  AllTheDatums.free;
  EndHourGlass;
end;

procedure TFormAuftragArbeitsplatz.ComboBox6Change(Sender: TObject);
begin
  s_Art := ComboBox6.Text;
end;

procedure TFormAuftragArbeitsplatz.RefreshMonteurAuslastung
  (BAUSTELLE_R: Integer);
var
  _Datum: TANFiXDate;

  Monteure: TStringlist;

  //
  n: Integer;
  MONTEUR_R: Integer;
  cAUFWAND: TIB_Cursor;

  // Maximale Auslastung
  v_MonteurMontagAsDate: TDate;
  Col: Integer;
  AUFWAND_C, AUFWAND_S: Integer;
  mBAUSTELLE_R: Integer;

  function AddEntry(MONTEUR_R: Integer; Col: Integer; AUFWAND_C: Integer;
    AUFWAND_S: Integer; BAUSTELLE_R: Integer): Integer;
  begin
    result := Auslastung.indexof(MONTEUR_R);
    if (result <> -1) then
    begin
      with Auslastung[result][Col] do
      begin
        inc(AnzahlIst, AUFWAND_C);
        inc(Aufwand, AUFWAND_S);
        BaustelleAdd(BAUSTELLE_R);
        if (Kapazitaet = 0) then
          if odd(Col) then
            Kapazitaet := e_r_Arbeitszeit_N(BAUSTELLE_R)
          else
            Kapazitaet := e_r_Arbeitszeit_V(BAUSTELLE_R);
      end;
    end;
  end;

begin
  if ComboBox7.ItemIndex = 0 then
    exit;

  BeginHourGlass;

  _Datum := v_MonteurMontag;
  if dateOK(_Datum) then
  begin

    Auslastung.clear;

    // Datum Berechnungen (Vorlauf)
    v_Kursiv_cell := WeekDay(_Datum);
    Label13.caption := 'KW' + inttostr(WeekGet(_Datum));
    while WeekDay(_Datum) <> 1 do
      _Datum := DatePlus(_Datum, -1);
    v_MonteurMontag := _Datum;
    v_MonteurSonntag := DatePlus(_Datum, 6);
    v_MonteurMontagAsDate := long2datetime(v_MonteurMontag);

    // Monteur-Liste aufbereiten
    Monteure := TStringlist.create;
    if (BAUSTELLE_R = -1) then
    begin
      Monteure.assign(e_r_MonteureCache);
    end
    else
    begin
      Monteure.assign(e_r_BaustelleMonteure(BAUSTELLE_R));
    end;

    // Auslastung aufbauen
    for n := 0 to pred(Monteure.count) do
    begin

      // überhaupt richtiger Monteur?
      MONTEUR_R := e_r_MonteurRIDFromKuerzel(Monteure[n]);
      if MONTEUR_R = -1 then
        continue;

      // Zeile für diesen Monteur anlegen!
      Auslastung.Add(Monteure[n], MONTEUR_R);
    end;

    cAUFWAND := DataModuleDatenbank.nCursor;
    with cAUFWAND do
    begin
      sql.Add('select');
      sql.Add(' MONTEUR1_R,');
      sql.Add(' MONTEUR2_R,');
      sql.Add(' AUSFUEHREN,');
      sql.Add(' VORMITTAGS,');
      sql.Add(' BAUSTELLE_R,');
      sql.Add(' count(AUFWAND) AUFWAND_C,');
      sql.Add(' sum(AUFWAND) AUFWAND_S');
      sql.Add('from AUFTRAG where');
      sql.Add(' (AUSFUEHREN between ' + '''' + Long2date(v_MonteurMontag) + ''''
        + ' and ' + '''' + Long2date(v_MonteurSonntag) + '''' + ') and ');
      sql.Add(' (STATUS in (' + inttostr(ord(ctsTerminiert)) + ',' +
        inttostr(ord(ctsAngeschrieben)) + ',' +
        inttostr(ord(ctsMonteurinformiert)) + ') ) and');
      sql.Add(' (AUFWAND>0)');
      sql.Add('group by');
      sql.Add(' BAUSTELLE_R, AUSFUEHREN, VORMITTAGS, MONTEUR1_R, MONTEUR2_R');
      ApiFirst;
      while not(eof) do
      begin

        Col := round(FieldByName('AUSFUEHREN').AsDate -
          v_MonteurMontagAsDate) * 2;
        AUFWAND_C := FieldByName('AUFWAND_C').AsInteger * 2;
        AUFWAND_S := FieldByName('AUFWAND_S').AsInteger;
        mBAUSTELLE_R := FieldByName('BAUSTELLE_R').AsInteger;

        if (FieldByName('VORMITTAGS').AsString = 'N') then
          inc(Col);

        if FieldByName('MONTEUR2_R').IsNotNull then
        begin

          // hey - Doppeltermin, jeder halbe Last
          AddEntry(FieldByName('MONTEUR1_R').AsInteger, Col, AUFWAND_C div 2,
            AUFWAND_S div 2, mBAUSTELLE_R);
          AddEntry(FieldByName('MONTEUR2_R').AsInteger, Col, AUFWAND_C div 2,
            AUFWAND_S div 2, mBAUSTELLE_R);

        end
        else
        begin

          // Normaler Termin, 1 Monteur ...
          AddEntry(FieldByName('MONTEUR1_R').AsInteger, Col, AUFWAND_C,
            AUFWAND_S, mBAUSTELLE_R);

        end;
        APInext;
      end;
    end;
    cAUFWAND.free;

    Auslastung.Mode := 0;
    DrawGrid2.canvas.font.size := 10;

    DrawGrid2.rowCount := Auslastung.count;
    DrawGrid2.refresh;

    Monteure.free;
    v_MonteurTag := v_MonteurMontag;
    Label14.caption := long2datetext(v_MonteurMontag);

  end
  else
  begin
    Label14.caption := ''; // Tlist
  end;
  ShouldRefreshBelastung := false;
  EndHourGlass;

end;

const
  _ProblemInfosFileAge: Integer = 0;

procedure TFormAuftragArbeitsplatz.RefreshProblemInfos;
var
  sExports: TStringlist;
  sSingleExport: TStringlist;
  n, m, o: Integer;
  AUFTRAG_R: Integer;
  ProblemMsg: TStringlist;
  ProblemInfosFileAge: Integer;
  Fixierte: TgpIntegerList;
begin
  BeginHourGlass;
  if not(assigned(ProblemInfos)) then
    ProblemInfos := TgpIntegerObjectList.create;

  sSingleExport := TStringlist.create;
  Fixierte := TgpIntegerList.create;
  sExports := TStringlist.create;
  dir(DiagnosePath + 'Export_*.csv', sExports, false);
  sExports.sort;

  // ev. hier noch Filtern welche überhaupt genommen werden sollen!
  repeat

    // Leer lassen, wenn keine Exports da sind
    if (sExports.count = 0) then
      break;

    //
    // nichts aktualisieren, wenn **neueste** Datei die gleiche wie früher ist
    ProblemInfosFileAge :=
      FileAge(DiagnosePath + sExports[pred(sExports.count)]);
    if ProblemInfosFileAge = _ProblemInfosFileAge then
      break;
    _ProblemInfosFileAge := ProblemInfosFileAge;

    // Alte Liste leeren

    {
      for n := 0 to pred(ProblemInfos.count) do
      if assigned(ProblemInfos.objects[n]) then
      TStringList(ProblemInfos.objects[n]).free;
    }
    ProblemInfos.clear;

    // Neu Aufbauen, Neue zuerst!
    for n := pred(sExports.count) downto 0 do
    begin

      sSingleExport.LoadFromFile(DiagnosePath + sExports[n]);
      for m := 0 to pred(sSingleExport.count) do
      begin

        // Ist (letztendlich) ein Erfolg zu verzeichnen?
        AUFTRAG_R := strtointdef(
          { } ExtractSegmentBetween(sSingleExport[m], ' (', ' : Y)'),
          { } cRID_Unset);
        if (AUFTRAG_R >= cRID_FirstValid) then
        begin
          if (Fixierte.indexof(AUFTRAG_R) <> -1) then
            continue;

          o := ProblemInfos.indexof(AUFTRAG_R);
          if (o = -1) then
          begin
            ProblemMsg := TStringlist.create;
            ProblemMsg.Add(cOKText);
            ProblemInfos.AddObject(AUFTRAG_R, ProblemMsg);
          end
          else
          begin
            ProblemMsg := TStringlist(ProblemInfos.objects[o]);
            ProblemMsg.Add(cOKText);
          end;
          continue;
        end;

        // Ist ein Misserfolg zu verzeichnen?
        AUFTRAG_R := strtointdef(
          { } ExtractSegmentBetween(sSingleExport[m], ' (RID=', ')'),
          { } cRID_Unset);
        if (AUFTRAG_R >= cRID_FirstValid) then
        begin
          if (Fixierte.indexof(AUFTRAG_R) <> -1) then
            continue;

          o := ProblemInfos.indexof(AUFTRAG_R);
          if (o = -1) then
          begin
            // Neu anlegen
            ProblemMsg := TStringlist.create;
            ProblemInfos.AddObject(AUFTRAG_R, ProblemMsg);
          end
          else
          begin
            // Wiederverwerten und anhängen!
            ProblemMsg := TStringlist(ProblemInfos.objects[o]);
          end;
          ProblemMsg.Add(cutblank(FromP(sSingleExport[m], ')', 1)));
          continue;

        end;

        // Irgendwie ne unverständliche Zeile -> nicht beachten!

      end;

      // Sicherstellen, dass nun alle Fixiert sind!
      Fixierte.clear;
      for m := 0 to pred(ProblemInfos.count) do
        Fixierte.Add(ProblemInfos[m]);
      Fixierte.sort;

    end;

  until true;
  sSingleExport.free;
  Fixierte.free;
  sExports.free;
  EndHourGlass;
end;

procedure TFormAuftragArbeitsplatz.InvalidateCache_ProblemInfos;
begin
  _ProblemInfosFileAge := 0;
end;

function TFormAuftragArbeitsplatz.getProbleme(AUFTRAG_R: Integer): TStringlist;
var
  n: Integer;
begin
  if not(assigned(ProblemInfos)) or (_ProblemInfosFileAge = 0) then
    RefreshProblemInfos;

  result := TStringlist.create;
  if (AUFTRAG_R >= cRID_FirstValid) then
  begin
    //
    n := ProblemInfos.indexof(AUFTRAG_R);
    if (n = -1) then
    begin
      result.Add('N/A');
    end
    else
    begin
      result.AddStrings(TStringlist(ProblemInfos.objects[n]));
    end;
  end;

  // Immer 3 Zeilen sicherstellen!
  for n := result.count to pred(3) do
    result.Add('');
end;

procedure TFormAuftragArbeitsplatz.Button6Click(Sender: TObject);
begin
  v_MonteurMontag := DatePlus(v_MonteurMontag, 7);
  RefreshMonteurAuslastung(s_Baustelle);
end;

procedure TFormAuftragArbeitsplatz.Button3Click(Sender: TObject);
begin
  v_MonteurMontag := DatePlus(v_MonteurMontag, -7);
  RefreshMonteurAuslastung(s_Baustelle);
end;

procedure TFormAuftragArbeitsplatz.DatePick1Change(Sender: TDatePick;
  Value: TDatePickResult);
begin
  DatePick1.visible := false;
  v_MonteurMontag := DateTime2long(DatePick1.date);
  RefreshMonteurAuslastung(s_Baustelle);
end;

procedure TFormAuftragArbeitsplatz.doAynaci1;
var
  qAUFTRAG: TIB_Query;
  sInternInfo: TStringlist;
  n: Integer;
  Eigentumsnummer: string;
begin
  if doit(inttostr(ItemsGRID.count) + ' ändern?') then
  begin
    BeginHourGlass;
    qAUFTRAG := DataModuleDatenbank.nQuery;
    sInternInfo := TStringlist.create;
    with qAUFTRAG do
    begin
      sql.Add('select ZAEHLER_NUMMER, INTERN_INFO from AUFTRAG where');
      sql.Add(' RID=:CROSSREF');
      sql.Add('for update');
      for n := 0 to pred(ItemsGRID.count) do
      begin
        ParamByName('CROSSREF').AsInteger := Integer(ItemsGRID[n]);
        first;
        if not(eof) then
        begin
          FieldByName('INTERN_INFO').AssignTo(sInternInfo);
          Eigentumsnummer := noblank(sInternInfo.values['Eigentumsnummer']);
          ersetze('-', '', Eigentumsnummer);
          if (Eigentumsnummer <> '') then
          begin
            edit;
            FieldByName('ZAEHLER_NUMMER').AsString := Eigentumsnummer;
            post;
          end;
        end;
      end;
    end;
    qAUFTRAG.free;
    sInternInfo.free;
    EndHourGlass;
  end;
end;

procedure TFormAuftragArbeitsplatz.doAynaci2;
var
  qAUFTRAG: TIB_Query;
  sInternInfo: TStringlist;
  n: Integer;
  Eigentumsnummer: string;
begin
  if doit(inttostr(ItemsGRID.count) + ' ändern?') then
  begin
    BeginHourGlass;
    qAUFTRAG := DataModuleDatenbank.nQuery;
    sInternInfo := TStringlist.create;
    with qAUFTRAG do
    begin
      sql.Add('select ZAEHLER_NUMMER, INTERN_INFO from AUFTRAG where');
      sql.Add(' RID=:CROSSREF');
      sql.Add('for update');
      for n := 0 to pred(ItemsGRID.count) do
      begin
        ParamByName('CROSSREF').AsInteger := Integer(ItemsGRID[n]);
        first;
        if not(eof) then
        begin
          FieldByName('INTERN_INFO').AssignTo(sInternInfo);
          Eigentumsnummer := noblank(sInternInfo.values['Eigentumsnummer']);
          if (Eigentumsnummer <> '') then
          begin
            edit;
            FieldByName('ZAEHLER_NUMMER').AsString := Eigentumsnummer;
            post;
          end;
        end;
      end;
    end;
    qAUFTRAG.free;
    sInternInfo.free;
    EndHourGlass;
  end;
end;

procedure TFormAuftragArbeitsplatz.mShow;
begin
  WindowState := wsnormal;
  show;
end;

procedure TFormAuftragArbeitsplatz.Label13Click(Sender: TObject);
begin
  DatePick1.date := long2datetime(v_MonteurMontag);
  DatePick1.visible := not(DatePick1.visible);
end;

procedure TFormAuftragArbeitsplatz.Label8Click(Sender: TObject);
begin
  BeginHourGlass;
  InvalidateCache_Monteur;
  if (s_Baustelle <> -1) then
  begin

    // Monteur-Auswahl
    ComboBox3.items.assign(e_r_BaustelleMonteure(s_Baustelle));
    ComboBox3.items.insert(0, '*');
    ComboBox3.items.Add('ohne');

  end
  else
  begin

    ComboBox3.items.assign(e_r_MonteureCache);
    ComboBox3.items.insert(0, '*');
    ComboBox3.items.Add('ohne');
  end;
  EndHourGlass;
end;

procedure TFormAuftragArbeitsplatz.FormActivate(Sender: TObject);
begin
  BeginHourGlass;
  FormAuftrag.close;

  //
  if (ComboBox1.items.count = 0) then
  begin
    //
    FuelleBaustellenCombo;
    ComboBox1Exit(Sender);
  end;

  //
  if (ComboBox3.items.count = 0) then
  begin
    // Monteure einfügen
    ComboBox3.items.assign(e_r_MonteureCache);
    ComboBox3.items.insert(0, '*');
    ComboBox3.items.Add('ohne');
    if (ContextReadPos = -1) and (ItemsMARKED.count = 0) then
      moveContextBack;
  end;

  RefreshCountAnzeige;
  if ShouldRefreshBelastung then
    RefreshMonteurAuslastung(ShouldRefreshBelastungbaustelle);

  if ShouldRefreshListe then
  begin
    InvalidateCache_Auftrag;
    DrawGrid1.refresh;
    ShouldRefreshListe := false;
  end;

  EndHourGlass;
end;

procedure TFormAuftragArbeitsplatz.ToolButton21Click(Sender: TObject);
var
  sBaustelle: string;
begin
  if (s_Baustelle <> -1) then
  begin
    sBaustelle := e_r_BaustelleKuerzel(s_Baustelle);
    if (sBaustelle <> '') then
    begin
      CheckCreateDir(iBaustellenPath + sBaustelle);
      OpenShell(iBaustellenPath + sBaustelle);
    end;
  end;
end;

procedure TFormAuftragArbeitsplatz.ToolButton22Click(Sender: TObject);
begin
  SwitchAuslastung;
  // beta
  Auslastung.pack;
  DrawGrid2.rowCount := Auslastung.count;
  DrawGrid2.refresh;
  // beta
end;

procedure TFormAuftragArbeitsplatz.Button2Click(Sender: TObject);
var
  n: Integer;
begin
  // Historischen Modus beenden!
  HistorischBeenden;
  SaveCursorPosition;
  SaveEdits;

  // wieder alles anzeigen
  ItemsGRID.clear;
  ItemsGRID.Capacity := ItemsQUERY.count;
  for n := 0 to pred(ItemsQUERY.count) do
    ItemsGRID.Add(ItemsQUERY[n]);
  DrawGrid1.rowCount := ItemsQUERY.count;

  RefreshCountAnzeige;
  RestoreCursorPosition;
  InvalidateCache_Auftrag;
  DrawGrid1.refresh;
end;

procedure TFormAuftragArbeitsplatz.SaveCursorPosition;
begin
  if (ItemsGRID.count > 0) then
    SaveCursorRID := Integer(ItemsGRID[DrawGrid1.Row])
  else
    SaveCursorRID := -1;
end;

procedure TFormAuftragArbeitsplatz.RestoreCursorPosition;
var
  n: Integer;
begin
  n := ItemsGRID.indexof(pointer(SaveCursorRID));
  if (n <> -1) then
    DrawGrid1.Row := n;
end;

procedure TFormAuftragArbeitsplatz.RadioButton1Click(Sender: TObject);
begin
  s_Vormittags := cVormittagsChar;
end;

procedure TFormAuftragArbeitsplatz.RadioButton2Click(Sender: TObject);
begin
  s_Vormittags := cNachmittagsChar;
end;

procedure TFormAuftragArbeitsplatz.RadioButton3Click(Sender: TObject);
begin
  s_Vormittags := '';
end;

procedure TFormAuftragArbeitsplatz.ToolButton25Click(Sender: TObject);
begin
  if (MonteurSelected <> -1) then
  begin
    MonteurRIDs.clear;
    MonteurRIDs.Add(MonteurSelected);
    TageRIDs.clear;
    TageRIDs.Add(v_MonteurTag);
    ProduceInfoBlatt(TageRIDs, MonteurRIDs, nil, false, true);
    if (ItemInformiert.count = 0) then
      ShowMessage('Der markierte Monteur hat am ' + long2datetext(v_MonteurTag)
        + ' keinen Termin!');
  end
  else
  begin
    ShowMessage('Es ist kein Monteur markiert!');
  end;
end;

procedure TFormAuftragArbeitsplatz.ToolButton27Click(Sender: TObject);
var
  n: Integer;
  AllDataKuerzel: TStringlist;
begin
  if v_MonteurTag > 0 then
  begin
    // alle Monteure
    AllDataKuerzel := e_r_MonteureCache;
    MonteurRIDs.clear;
    for n := 0 to pred(AllDataKuerzel.count) do
      MonteurRIDs.Add(Integer(AllDataKuerzel.objects[n]));

    // der Tag
    TageRIDs.clear;
    TageRIDs.Add(v_MonteurTag);

    //
    ProduceInfoBlatt(TageRIDs, MonteurRIDs, nil, false, true);
    if (ItemInformiert.count = 0) then
      ShowMessage('Am ' + long2datetext(v_MonteurTag) +
        ' gibt es keinen einzigen Termin!');
  end
  else
  begin
    ShowMessage('Es ist kein Tag markiert!');
  end;
end;

procedure TFormAuftragArbeitsplatz.ProduceInfoBlatt(Datum_RIDs, Monteur_RIDs,
  Single_RIDs: TgpIntegerList; MondaMode: boolean = false;
  FaxMode: boolean = false);

const
  chtml_MIDAUFTRAG = 'load AUFTRAG MID,AUFTRAG';
  chtml_HEADER = 'load HEADER,HEADER';
var
  OutR: TMDERec;
  StartTime: dword;
  MonDaOutF: file of TMDERec;
  InfoBlatt: THTMLTemplate;
  RecN: Integer;
  Auftrag_RID: Integer;
  Master_RID: Integer;
  SubItems: TStringlist;
  AnschriftText: TStringlist;
  Zaehlertext: TStringlist;
  InfoText: TStringlist;
  FirstNachmittag: boolean;
  FirstData: boolean;
  Baustellen: TStringlist;
  n, m: Integer;
  d: Integer;
  FName: string;
  _a, _b, _c: string;
  InfoAboutOld: boolean;
  TrueMonteurRIDs: TgpIntegerList;
  _OrgterminStr: string;
  LastTerminStr: string;
  LastMaster_RID: Integer;
  DatensammlerLokal: TStringlist;
  DatensammlerGlobal: TStringlist;
  cAUFTRAG, cHISTORISCH: TIB_Cursor;
  PreLookl: TStringlist;
  PreN, PreM: Integer;
  Headers: Integer;
  STATUS: TePhaseStatus;
  STATUS_MASTER: TeVirtualPhaseStatus;
  MondaBaustellenL: TList;
  cBAUSTELLE: TIB_Cursor;
  BAUSTELLE_R: Integer;
  RawMode: boolean;
  ZEITRAUM_VON: TANFiXDate;
  ZEITRAUM_BIS: TANFiXDate;
  AUSFUEHREN_SOLL: TANFiXDate;
  Protokoll: TStringlist;
  _RueckKanal: string;

  function TerminStr: string; // aus dem aktuellen Datensatz einen
  // eindeutigen Termin-String zaubern
  begin
    result := SubItems[twh_Monteur] + ' ' + // Monteur
      SubItems[twh_WochentagKurz] + ' ' + // Wochentag
      copy(SubItems[twh_Datum], 1, 5) + // Datum
      AnsiUpperCase(SubItems[twh_ZeitText][1]) + '-' + // V/N
      'KW' + //
      inttostr(WeekGet(Date2Long(SubItems[twh_Datum])));
  end;

  function Hauptbaustelle: string;
  begin
    if (Baustellen.count = 0) then
      result := SubItems[twh_Baustelle]
    else
      result := Baustellen[0];
  end;

  function FaxAusschluss: string;
  var
    AusschlussL: TgpIntegerList;
  begin
    result := '';
    AusschlussL := e_r_sqlm('select RID from BAUSTELLE where TERMINLISTE_AUS='''
      + cC_True + '''');
    if (AusschlussL.count > 0) then
    begin
      result := ' (BAUSTELLE_R not in ' + ListasSQL(AusschlussL) + ') and';
    end;
    AusschlussL.free;
  end;

  function SortierBegriffStr: string;
  begin
    if (Monteur_RIDs.count > 1) then
      result := AnsiUpperCase(Hauptbaustelle + '.' + // Baustelle
        SubItems[twh_Monteur] + '.' + // Monteur
        inttostr(Date2Long(SubItems[twh_Datum])) + '.' + // Datum
        inttostr(CharCount('N', SubItems[twh_Zeit])) // V=0, N=1
        )
    else
      result := AnsiUpperCase(inttostr(Date2Long(SubItems[twh_Datum])) + '.' +
        // Datum
        inttostr(CharCount('N', SubItems[twh_Zeit])) // V=0, N=1
        );
  end;

  function TitelStr: string;
  var
    DatumsStr: string;
  begin
    DatumsStr := SubItems[twh_DatumText];
    ersetze(',', ' ' + SubItems[twh_ZeitText] + ',', DatumsStr);
    result := e_r_BaustelleNameFromKuerzel(Hauptbaustelle) + ': ' +
      SubItems[twh_MonteurText] + ' ' + DatumsStr + ' (KW ' +
      inttostr(WeekGet(Date2Long(SubItems[twh_Datum]))) + ')';
  end;

  procedure OpenHeader;
  begin
    //
    DatensammlerLokal.Add(chtml_HEADER);
    DatensammlerLokal.Add('Tabelle Titel=' + TitelStr);
    DatensammlerLokal.Add('Sortierbegriff=' + SortierBegriffStr);
    inc(Headers);
  end;

  procedure CloseHeader(vormittags: boolean);
  var
    n: Integer;
  begin
    for n := pred(DatensammlerLokal.count) downto 0 do
    begin
      if (pos(chtml_HEADER, DatensammlerLokal[n]) = 1) then
        break;
      if (pos(chtml_MIDAUFTRAG, DatensammlerLokal[n]) = 1) then
      begin
        DatensammlerLokal[n] := 'load AUFTRAG LAST' +
          VormittagsToChar(vormittags) + ',AUFTRAG';
        dec(Headers);
        break;
      end;
    end;
  end;

  procedure ErmittleBaustellen;
  var
    n: Integer;
  begin
    Baustellen.clear;
    for n := 0 to pred(PreLookl.count) do
    begin
      if not(TePhaseStatus(strtol(nextp(PreLookl[n], ';', 3)))
        in [ctsHistorisch, ctsUnmoeglich, ctsVorgezogen]) then
        Baustellen.Add(e_r_BaustelleKuerzel(strtointdef(nextp(PreLookl[n],
          ';', 4), 0)));
    end;
    Baustellen.sort;
    removeDuplicates(Baustellen);
  end;

begin
  BeginHourGlass;

  // Vorlauf
  Baustellen := TStringlist.create;
  AnschriftText := TStringlist.create;
  Zaehlertext := TStringlist.create;
  InfoText := TStringlist.create;
  Protokoll := TStringlist.create;
  TrueMonteurRIDs := TgpIntegerList.create;
  DatensammlerLokal := TStringlist.create;
  DatensammlerGlobal := TStringlist.create;
  PreLookl := TStringlist.create;
  MondaBaustellenL := TList.create;

  cAUFTRAG := DataModuleDatenbank.nCursor;
  with cAUFTRAG do
  begin
    sql.Add('SELECT');
    sql.Add(' RID,VORMITTAGS,MASTER_R,STATUS,MONTEUREXPORT,');
    sql.Add(' ZAEHLER_WECHSEL,ZAEHLER_INFO,MONTEUR_INFO,BAUSTELLE_R,');
    sql.Add(' ZEITRAUM_VON,ZEITRAUM_BIS,PROTOKOLL');
    sql.Add('FROM AUFTRAG');
    if assigned(Single_RIDs) then
    begin
      // ##
      Monteur_RIDs := TgpIntegerList.create;
      Monteur_RIDs.Add(1);
      Datum_RIDs := TgpIntegerList.create;
      Datum_RIDs.Add(1);

      sql.Add(' WHERE RID in (');
      for n := pred(Single_RIDs.count) downto 0 do
        if (n > 0) then
          sql.Add(inttostr(Integer(Single_RIDs[n])) + ',')
        else
          sql.Add(inttostr(Integer(Single_RIDs[n])) + ')');
    end
    else
    begin
      sql.Add('where');
      if FaxMode then
        sql.Add(FaxAusschluss);
      sql.Add(' (AUSFUEHREN=:AUSF) and');
      sql.Add(' (VORMITTAGS IS NOT NULL) and');
      sql.Add(' ((MONTEUR1_R=:MON) OR (MONTEUR2_R=:MON)) and');
      sql.Add(' ((STATUS in (' + inttostr(ord(ctsTerminiert)) + ',' +
        inttostr(ord(ctsAngeschrieben)) + ',' +
        inttostr(ord(ctsMonteurinformiert)) + ',' +
        inttostr(ord(ctsNeuAnschreiben)) + ',' + inttostr(ord(ctsRestant)) + ','
        + inttostr(ord(ctsVorgezogen)) + ',' + inttostr(ord(ctsErfolg)) + ',' +
        inttostr(ord(ctsUnmoeglich)) + ')) OR');
      sql.Add('       ((STATUS=' + inttostr(ord(ctsHistorisch)) +
        ') and MONTEUREXPORT is not null)');
      sql.Add('      )');
    end;
    sql.Add('ORDER BY');
    sql.Add(' VORMITTAGS DESCENDING,'); // Y/N
    sql.Add(' BAUSTELLE_R,'); // baustelle
    sql.Add(' STRASSE,'); // PQ-Strassen
    sql.Add(' NUMMER'); // AB-Nummern
    prepare;
  end;

  cHISTORISCH := DataModuleDatenbank.nCursor;
  with cHISTORISCH do
  begin
    sql.Add('SELECT RID FROM AUFTRAG');
    sql.Add('WHERE (MASTER_R=:CROSSREF) AND');
    sql.Add('      (RID<>MASTER_R) AND');
    sql.Add('      (MONTEUREXPORT IS NOT NULL) AND');
    sql.Add('      (AUSFUEHREN IS NOT NULL)');
    sql.Add('ORDER BY RID DESCENDING');
    prepare;
  end;

  CheckCreateDir(HtmlVorlagenPath + cHTMLBlockPath);
  ItemInformiert.clear; // Auftrags-Sammler
  _LastTerminCount := 0;

  if MondaMode then
  begin

    // Datei anlegen
    CheckCreateDir(MDEPath);
    if (Monteur_RIDs.count = 1) then
    begin
      assignFile(MonDaOutF, MDEPath + e_r_MonteurGeraeteID(Monteur_RIDs[0])
        + '.DAT');
{$I-}
      reset(MonDaOutF);
{$I+}
      if (ioresult <> 0) then
        rewrite(MonDaOutF);
      // Ans Dateiende positionieren!
      seek(MonDaOutF, FileSize(MonDaOutF));
    end
    else
    begin
      assignFile(MonDaOutF, MDEPath + 'NEUES.DAT');
      rewrite(MonDaOutF);
    end;

    // mögliche Baustellen auflisten
    cBAUSTELLE := DataModuleDatenbank.nCursor;
    with cBAUSTELLE do
    begin
      sql.Add('select RID from BAUSTELLE where EXPORT_MONDA=''' +
        cC_True + '''');
      ApiFirst;
      while not(eof) do
      begin
        MondaBaustellenL.Add(pointer(FieldByName('RID').AsInteger));
        APInext;
      end;
    end;
    cBAUSTELLE.free;

  end;

  // !prepare!
  DatensammlerGlobal.Add('save&delete AUFTRAG MID');
  DatensammlerGlobal.Add('save&delete AUFTRAG LASTV');
  DatensammlerGlobal.Add('save&delete AUFTRAG LASTN');
  DatensammlerGlobal.Add('save&delete HEADER');

  Headers := 0;
  _MonteurRIDsCount := 0;
  EnsureHourGlass;
  ProgressBar1.max := Datum_RIDs.count * Monteur_RIDs.count;
  ProgressBar1.Position := 0;
  for n := 0 to pred(Monteur_RIDs.count) do
  begin

    for d := 0 to pred(Datum_RIDs.count) do
    begin

      v_MonteurTag := Integer(Datum_RIDs[d]);

      ProgressBar1.stepit;
      application.processmessages;

      with cAUFTRAG do
      begin

        if not(assigned(Single_RIDs)) then
        begin
          params.BeginUpdate;
          ParamByName('AUSF').AsDate := long2datetime(v_MonteurTag);
          ParamByName('MON').AsInteger := Monteur_RIDs[n];
          params.EndUpdate(true);
        end;

        if (RecordCount = 0) then
          continue;

        // Vorlauf
        PreLookl.clear;
        ApiFirst;
        while not(eof) do
        begin
          PreLookl.AddObject(
            { [00] } FieldByName('RID').AsString + ';' +
            { [01] } FieldByName('VORMITTAGS').AsString + ';' +
            { [02] } FieldByName('MASTER_R').AsString + ';' +
            { [03] } FieldByName('STATUS').AsString + ';' +
            { [04] } FieldByName('BAUSTELLE_R').AsString,
            TObject(FieldByName('RID').AsInteger));
          APInext;
        end;

        // Prüfung, ob was schief geht
        // PreLookl.SaveToFile(DiagnosePath+'pre.0.txt');
        PreM := 0;
        repeat

          if (nextp(PreLookl[PreM], ';', 3) <> '6') then
          begin
            // echter Datensatz! -> lösche alle historischen!
            for PreN := pred(PreLookl.count) downto 0 do
              if (PreN <> PreM) then
                if (nextp(PreLookl[PreN], ';', 1) = nextp(PreLookl[PreM], ';',
                  1)) and // V/N
                  (nextp(PreLookl[PreN], ';', 2) = nextp(PreLookl[PreM], ';', 2))
                then // gleicher !master!
                begin
                  PreLookl.Delete(PreN);
                  if (PreN < PreM) then
                    dec(PreM);
                end;

          end
          else
          begin

            // historischer! -> lösche alle älteren historischen
            for PreN := pred(PreLookl.count) downto 0 do
              if (PreN <> PreM) then
                if (nextp(PreLookl[PreN], ';', 1) = nextp(PreLookl[PreM], ';',
                  1)) and // V/N
                  (nextp(PreLookl[PreN], ';', 2) = nextp(PreLookl[PreM], ';', 2)
                  ) and // gleicher !master!
                  (nextp(PreLookl[PreN], ';', 3) = inttostr(ord(ctsHistorisch)))
                  and // Staus=6
                  (strtointdef(nextp(PreLookl[PreN], ';', 0), 0) <
                  strtointdef(nextp(PreLookl[PreM], ';', 0), 0)) then
                // RID kleiner
                begin
                  PreLookl.Delete(PreN);
                  if (PreN < PreM) then
                    dec(PreM);
                end;
          end;
          inc(PreM);
        until (PreM >= PreLookl.count);
        // PreLookl.SaveToFile(DiagnosePath+'pre.1.txt');

        // Ermittlung der aktive Baustellen!
        ErmittleBaustellen;

        // Jetzt kommt die Tatsächliche Ausgabe
        RecN := 0;
        FirstNachmittag := true;
        FirstData := true;
        LastTerminStr := '';
        LastMaster_RID := -1;
        ApiFirst;
        while not(eof) do
        begin

          repeat

            // Ein historischer Datensatz, jedoch ohne Monteur-Info
            // d.h. der Monteur weis nix davon
            Auftrag_RID := FieldByName('RID').AsInteger;
            if (PreLookl.indexofobject(TObject(Auftrag_RID)) = -1) then
              break;

            // Bei freier Terminwahl kommen nur die "offenen"
            // auf das Gerät!
            STATUS := TePhaseStatus(FieldByName('STATUS').AsInteger);
            if (v_MonteurTag = cMonDa_FreieTerminWahl) then
              if STATUS in [ctsDatenFehlen, ctsErfolg, ctsNeuAnschreiben,
                ctsHistorisch, ctsVorgezogen, ctsUnmoeglich] then
                break;

            Master_RID := FieldByName('MASTER_R').AsInteger;
            BAUSTELLE_R := FieldByName('BAUSTELLE_R').AsInteger;
            SubItems := e_r_AuftragItems(Auftrag_RID);

            // OK, die Zeile kommt dazu
            inc(RecN);
            ItemInformiert.Add(pointer(Auftrag_RID));

            // Monda Daten erstellen
            fillchar(OutR, sizeof(OutR), #0);
            with OutR do
            begin

              { Feld-Besitzer: OrgaMon }
              RID := Auftrag_RID;
              Baustelle := Ansi2Oem(SubItems[twh_Baustelle]);
              ABNummer := SubItems[twh_Auftrags_Nummer];
              Monteur := Ansi2Oem(SubItems[twh_Monteur]);
              Art := SubItems[twh_Art];
              if (length(SubItems[twh_Zaehler_Nummer]) >
                cMonDa_FieldLength_ZaehlerNummer) then
                zaehlernummer_alt := revCopy(SubItems[twh_Zaehler_Nummer], 1,
                  cMonDa_FieldLength_ZaehlerNummer)
              else
                zaehlernummer_alt := SubItems[twh_Zaehler_Nummer];
              reglernummer_alt := SubItems[twh_ReglerNummerAlt];
              AUSFUEHREN_SOLL := Date2Long(SubItems[twh_Datum]);
              vormittags := (SubItems[twh_Zeit] = 'V');
              Zaehler_Name1 := Ansi2Oem(SubItems[twh_Verbraucher_Name]);
              Zaehler_Name2 := Ansi2Oem(SubItems[twh_Verbraucher_Name2]);
              Zaehler_Strasse := Ansi2Oem(SubItems[twh_Verbraucher_Strasse]);
              Zaehler_Ort := Ansi2Oem(SubItems[twh_Verbraucher_Ort]);

              { Feld-Besitzer: JonDa }
              zaehlerstand_alt := '';
              zaehlernummer_korr := '';
              zaehlernummer_neu := '';
              zaehlerstand_neu := '';
              reglernummer_korr := '';
              reglernummer_neu := '';
              ProtokollInfo := '';
              ausfuehren_ist_uhr := 0;
              case STATUS of
                ctsHistorisch:
                  ausfuehren_ist_datum := cMonDa_Status_Wegfall;
                ctsRestant:
                  ausfuehren_ist_datum := cMonDa_Status_Restant;
                ctsVorgezogen:
                  ausfuehren_ist_datum := cMonDa_Status_Vorgezogen;
                ctsUnmoeglich:
                  ausfuehren_ist_datum := cMonDa_Status_Unmoeglich;
                ctsErfolg:
                  begin
                    if FieldByName('ZAEHLER_WECHSEL').IsNull then
                      ausfuehren_ist_datum := DateGet
                    else
                      ausfuehren_ist_datum :=
                        DateTime2long(FieldByName('ZAEHLER_WECHSEL').AsDate);
                  end;
              else
                ausfuehren_ist_datum := cMonDa_Status_unbearbeitet;
              end;

            end;

            repeat

              if FirstData then
              begin

                // wenn es keine "v" Termine gibt ist das die letzte Tabelle
                if (SubItems[twh_ZeitText][1] = 'n') then
                  FirstNachmittag := false;

                // Jetzt die Anzahl der informierten Monteure zählen
                if (TrueMonteurRIDs.indexof(Monteur_RIDs[n]) = -1) then
                begin
                  inc(_MonteurRIDsCount);
                  TrueMonteurRIDs.Add(Monteur_RIDs[n]);
                end;

                // Jetzt ev. eine neue Tabelle laden (incl. FF)
                OpenHeader;

                FirstData := false;
                break;
              end;

              if FirstNachmittag then
                if (SubItems[twh_ZeitText][1] = 'n') then
                begin
                  CloseHeader(true);
                  OpenHeader;
                  FirstNachmittag := false;
                end;

            until true;

            // Auftrag laden
            DatensammlerLokal.Add(chtml_MIDAUFTRAG);

            if assigned(Single_RIDs) then
            begin
              _a := SubItems[twh_DatumText] + ':' + SubItems[twh_Monteur] + #13;
            end
            else
            begin
              _a := '';
            end;

            case STATUS of
              ctsRestant, ctsHistorisch, ctsErfolg, ctsVorgezogen,
                ctsUnmoeglich:
                DatensammlerLokal.Add('No=' + _a + '(' + SubItems[twh_Baustelle]
                  + '-' + SubItems[twh_Auftrags_Nummer] + ')' + #13 +
                  SubItems[twh_Zaehler_Nummer])
            else
              if (SubItems[twh_WordEmpfaenger] <> '') then
              begin
                DatensammlerLokal.Add('No=@' + Ansi2html(_a) + '<u>' +
                  Ansi2html(SubItems[twh_Baustelle] + '-' +
                  SubItems[twh_Auftrags_Nummer]) + '</u><br>' +
                  Ansi2html(SubItems[twh_Zaehler_Nummer]));
              end
              else
                DatensammlerLokal.Add('No=' + _a + SubItems[twh_Baustelle] + '-'
                  + SubItems[twh_Auftrags_Nummer] + #13 +
                  SubItems[twh_Zaehler_Nummer])

            end;

            DatensammlerLokal.Add
              ('VN=' + AnsiUpperCase(SubItems[twh_ZeitText][1]) + #13 +
              SubItems[twh_Art]);

            // zwingendes Blank
            AnschriftText.clear;
            _a := cutblank(SubItems[twh_Verbraucher_Strasse]);
            ersetze(' ', cNonBreakableSpace, _a);
            _b := cutblank(SubItems[twh_Verbraucher_Name]);
            ersetze(' ', cNonBreakableSpace, _b);
            _c := cutblank(SubItems[twh_Verbraucher_Name2]);
            ersetze(' ', cNonBreakableSpace, _c);
            AnschriftText.Add(cutblank(_a + ' ' + _b + ' ' + _c));

            _a := cutblank(SubItems[twh_Verbraucher_Ort]);
            ersetze(' ', cNonBreakableSpace, _a);
            _b := cutblank(SubItems[twh_Verbraucher_Ortsteil]);
            ersetze(' ', cNonBreakableSpace, _b);
            AnschriftText.Add(cutblank(_a + ' ' + _b));

            // !!Ortsteil noch hinzu!!
            DatensammlerLokal.Add('Anschrift=' + HugeSingleLine(AnschriftText));

            FieldByName('ZAEHLER_INFO').AssignTo(Zaehlertext);
            DatensammlerLokal.Add
              ('Zähler=' + HugeSingleLine(Zaehlertext, ', '));

            FieldByName('MONTEUR_INFO').AssignTo(InfoText);

            // Werte aus dem Protokoll zurück in die Terminänderunsliste
            FieldByName('PROTOKOLL').AssignTo(Protokoll);
            with Protokoll do
              _RueckKanal := cutblank(values['I1'] + ' ' + values['I2'] + ' ' +
                values['I6'] + ' ' + values['I7'] + ' ' + values['I8']);
            if (_RueckKanal <> '') then
              InfoText.Add('[' + _RueckKanal + ']');

            _OrgterminStr := TerminStr;

            repeat

              // historische
              if (STATUS = ctsHistorisch) then
              begin

                // Nachladen des aktuellen Masters
                SubItems := e_r_AuftragItems(Master_RID);
                STATUS_MASTER := TeVirtualPhaseStatus
                  (strtol(SubItems[twh_Status1]));
                e_r_sql('select MONTEUR_INFO from AUFTRAG where RID=' +
                  inttostr(Master_RID), InfoText);

                repeat

                  // - -
                  if (STATUS_MASTER in [ctvTerminiert, ctvAngeschrieben,
                    ctvMonteurinformiert, ctvRestant, ctvNeuAnschreiben,
                    ctvAngeschriebenInformiert]) and
                    (SubItems[twh_Monteur] <> '') then
                  begin
                    if (SubItems[twh_ZeitText] <> '?') then
                      InfoText.insert(0, '   (neuer Termin:' + TerminStr + ')');
                    InfoText.insert(0, '   !!!WEGFALL!!!');
                    break;
                  end;

                  // - -
                  case STATUS_MASTER of
                    ctvErfolg, ctvErfolgGemeldet:
                      begin
                        InfoText.insert(0, '   (bereits durchgeführt!)');
                        InfoText.insert(0, '   !!!WEGFALL!!!');
                      end;
                    ctvUnmoeglich, ctvUnmoeglichGemeldet:
                      InfoText.insert(0, '   !!!UNMÖGLICH!!!');
                    ctvVorgezogen, ctvVorgezogenGemeldet:
                      InfoText.insert(0, '   !!!VORGEZOGEN!!!');
                  else
                    InfoText.insert(0, '   (kein neuer Termin!)');
                    InfoText.insert(0, '   !!!WEGFALL!!!');
                  end;

                until true;
                break;
              end;

              // unmögliche
              if (STATUS = ctsUnmoeglich) then
              begin
                InfoText.insert(0, '   !!!UNMÖGLICH!!!');
                break;
              end;

              // Restant
              if (STATUS = ctsRestant) then
              begin
                InfoText.insert(0, '   !!!RESTANT!!!');
                break;
              end;

              // Vorgezogen
              if (STATUS = ctsVorgezogen) then
              begin
                InfoText.insert(0, '   !!!VORGEZOGEN!!!');
                break;
              end;

              // Erledigt
              if (STATUS = ctsErfolg) then
              begin
                InfoText.insert(0, '   !!!FERTIG!!!');
                break;
              end;

              InfoAboutOld := false;
              with cHISTORISCH do
              begin
                // den entsprechenden Historische Datensätze suchen
                ParamByName('CROSSREF').AsInteger := Auftrag_RID;
                ApiFirst;
                while not(eof) do
                begin
                  InfoAboutOld := true; // es gibt alte!
                  SubItems := e_r_AuftragItems(FieldByName('RID').AsInteger);
                  if (TerminStr <> _OrgterminStr) then
                  begin
                    InfoText.insert(0, TerminStr);
                    InfoText.insert(0, 'TERMIN ALT:');
                    break;
                  end;
                  APInext;
                end;
              end;

              // Wechselzeitraum!
              if FieldByName('ZEITRAUM_VON').IsNotNull or
                FieldByName('ZEITRAUM_BIS').IsNotNull then
              begin
                ZEITRAUM_VON :=
                  DateTime2long(FieldByName('ZEITRAUM_VON').AsDate);
                ZEITRAUM_BIS :=
                  DateTime2long(FieldByName('ZEITRAUM_BIS').AsDate);
                if (abs(DateDiff(ZEITRAUM_VON, v_MonteurTag)) <= 7) or
                  (abs(DateDiff(ZEITRAUM_BIS, v_MonteurTag)) <= 7) then
                  InfoText.insert(0, 'zwischen ' + copy(Long2date(ZEITRAUM_VON),
                    1, 6) + ' und ' + copy(Long2date(ZEITRAUM_BIS), 1, 6));
              end;

              // keine weiteren Texte bei Sonder-Terminen
              if (OutR.AUSFUEHREN_SOLL <= cMonDa_FreieTerminWahl) then
                break;

              //
              if FieldByName('MONTEUREXPORT').IsNull then
              begin
                if not(InfoAboutOld) then
                  InfoText.insert(0, '   Neu!');
                break;
              end;

              if not(InfoAboutOld) then
                InfoText.insert(0, '   wie vereinbart');

            until true;

            if assigned(Single_RIDs) then
              InfoText.insert(0, 'EINZELNE NACHMELDUNG:');

            // Info ausgeben
            if (InfoText.count > 0) then
            begin

              // ermitteln ob mit html gearbeitet wird
              // das kann nicht in einzelnen Zeilen, sondern nur im ganzen
              // Block gemacht werden
              RawMode := false;
              for m := 0 to pred(InfoText.count) do
                if pos('@', InfoText[m]) = 1 then
                begin
                  RawMode := true;
                  InfoText[m] := copy(InfoText[m], 2, MaxInt);
                end;

              if RawMode then
                DatensammlerLokal.Add
                  ('Info=@' + HugeSingleLine(InfoText, '<br>'))
              else
                DatensammlerLokal.Add('Info=' + HugeSingleLine(InfoText));

              OutR.Monteur_Info := Ansi2Oem(HugeSingleLine(InfoText));
            end
            else
            begin
              DatensammlerLokal.Add('Info=' + cNonBreakableSpace);
            end;
            DatensammlerLokal.Add('pagebreak');

            // Datensatz auch an MDE
            OutR.Zaehler_info := Ansi2Oem(HugeSingleLine(Zaehlertext, ' '));
            if MondaMode then
              if (MondaBaustellenL.indexof(pointer(BAUSTELLE_R)) <> -1) then
                write(MonDaOutF, OutR);

            inc(_LastTerminCount);
          until true;
          APInext;
        end;

        // Ende des ganzen Tages erreicht!
        if (RecN > 0) then
        begin
          CloseHeader(false);
          case Baustellen.count of
            0:
              DatensammlerLokal.Add
                ('MehrInfo=' + 'An diesem Tag sind keine Termine vorhanden!');
            1:
              DatensammlerLokal.Add
                ('MehrInfo=' + 'An diesem Tag kein Wechsel der Baustelle!');
          else
            DatensammlerLokal.Add('MehrInfo=' + 'Sie arbeiten heute auf ' +
              inttostr(Baustellen.count) + ' Baustellen (' +
              HugeSingleLine(Baustellen, ',') + ')!');
          end;
          DatensammlerLokal.Add('NochMehrInfo=' + cOrgaMonCopyright);
        end;

      end;
    end;
  end;

  cAUFTRAG.close;
  cHISTORISCH.close;

  cAUFTRAG.free;
  cHISTORISCH.free;

  if MondaMode then
  begin
    CloseFile(MonDaOutF);
  end;

  Baustellen.free;
  AnschriftText.free;
  Zaehlertext.free;
  InfoText.free;
  Protokoll.free;
  TrueMonteurRIDs.free;
  PreLookl.free;
  MondaBaustellenL.free;

  // hier jetzt noch den Index-HTML neu erzeugen!
  if (Headers <> 0) then
    ShowMessage('ERROR: html nicht vollständig korrekt!');
  // Jetzt belichten
  InfoBlatt := THTMLTemplate.create;
  InfoBlatt.LoadFromFile(HtmlVorlagenPath + 'Monteur.1.242.html');
  with InfoBlatt do
  begin
    CanUseQuick := true;
    WriteValue(DatensammlerLokal, DatensammlerGlobal);
    if MondaMode then
    begin
      FName := MDEPath + 'MonDa' + inttostr(Monteur_RIDs[0]) + '.html';
    end
    else
    begin
      if (Monteur_RIDs.count > 1) then
      begin
        if (Datum_RIDs.count > 1) then
          FName := WebPath + 'w' + inttostr(WeekGet(Integer(Datum_RIDs[0])))
            + '.html'
        else
          FName := WebPath + 'g' + inttostr(v_MonteurTag) + '.html';
      end
      else
        FName := WebPath + 'm' + inttostr(Monteur_RIDs[0]) + '-' +
          inttostr(v_MonteurTag) + '.html';
    end;
    // SaveToFile(FName+'.unsortiert.html');
    SortPages;
    SaveToFileCompressed(FName);
  end;

  InfoBlatt.free;
  DatensammlerLokal.free;
  DatensammlerGlobal.free;

  ProgressBar1.Position := 0;

  EndHourGlass;
  if not(MondaMode) then
    if (ItemInformiert.count > 0) then
      OpenShell(FName);
end;

const
  cModeMonteur = 0;
  cModeWord = 1;
  cModeUnmoeglich = 2;
  cModeRestant = 3;
  cModeNeuAnschreiben = 4;
  cModeVorgezogen = 5;

procedure TFormAuftragArbeitsplatz.ToggleStatusMode(RID: Integer;
  Mode: Integer);
var
  _Monteur: string;
  _date: string;
  _vorm: string;
  sub: TStringlist;
  AllOK: boolean;
begin
  sub := e_r_AuftragItems(RID);
  _Monteur := sub[2];
  _date := sub[0];
  _vorm := sub[12];

  if Mode in [cModeMonteur, cModeWord] then
  begin
    AllOK := false;
    repeat

      if (_Monteur = '') then
      begin
        ShowMessage('Es wurde kein Monteur zugeordnet!');
        break;
      end;

      if not(dateOK(_date)) then
      begin
        ShowMessage('Es wurde kein Ausführungsdatum zugeordnet!');
        break;
      end;

      if pos(_vorm, cVormittagsChar + cNachmittagsChar) = 0 then
      begin
        ShowMessage('vormittags oder nachmittags nicht gesetzt!');
        break;
      end;

      AllOK := true;
    until true;
  end
  else
  begin
    AllOK := true;
  end;

  if AllOK then
  begin
    ShowAuftrag;
    application.processmessages;
    with FormAuftrag do
    begin
      EnsureEditState;
      case Mode of
        cModeMonteur:
          begin

            // MONTEUR
            if IB_Query1.FieldByName('MONTEUREXPORT').IsNull then
            begin
              IB_Query1.FieldByName('MONTEUREXPORT').AsDateTime := now;
            end
            else
            begin
              IB_Query1.FieldByName('MONTEUREXPORT').clear;
            end;

          end;
        cModeWord:
          begin

            // WORD
            if IB_Query1.FieldByName('WORDEXPORT').IsNull then
            begin
              IB_Query1.FieldByName('WORDEXPORT').AsDateTime := now;
              IB_Query1.FieldByName('WORDANZ').AsInteger :=
                IB_Query1.FieldByName('WORDANZ').AsInteger + 1;
            end
            else
              IB_Query1.FieldByName('WORDEXPORT').clear;
          end;
        cModeUnmoeglich:
          begin
            if (IB_Query1.FieldByName('STATUS').AsInteger <> ord(ctsUnmoeglich))
            then
              IB_Query1.FieldByName('STATUS').AsInteger := ord(ctsUnmoeglich)
            else
              IB_Query1.FieldByName('STATUS').AsInteger := ord(ctsTerminiert);
          end;
        cModeVorgezogen:
          begin
            if (IB_Query1.FieldByName('STATUS').AsInteger <> ord(ctsVorgezogen))
            then
              IB_Query1.FieldByName('STATUS').AsInteger := ord(ctsVorgezogen)
            else
              IB_Query1.FieldByName('STATUS').AsInteger := ord(ctsTerminiert);
          end;
        cModeRestant:
          begin
            if (IB_Query1.FieldByName('STATUS').AsInteger <> ord(ctsRestant))
            then
              IB_Query1.FieldByName('STATUS').AsInteger := ord(ctsRestant)
            else
              IB_Query1.FieldByName('STATUS').AsInteger := ord(ctsTerminiert);
          end;
        cModeNeuAnschreiben:
          begin
            if (IB_Query1.FieldByName('STATUS').AsInteger <>
              ord(ctsNeuAnschreiben)) then
              IB_Query1.FieldByName('STATUS').AsInteger :=
                ord(ctsNeuAnschreiben)
            else
              IB_Query1.FieldByName('STATUS').AsInteger := ord(ctsTerminiert);
          end;
      end;
      IB_Query1.post;
      close;
    end;
  end;

end;

procedure TFormAuftragArbeitsplatz.ComboBox2Change(Sender: TObject);
begin
  s_Status := PhasenStatus.indexof(ComboBox2.Text);
end;

procedure TFormAuftragArbeitsplatz.ToolButton31Click(Sender: TObject);
var
  StartTime: dword;
  RecN: Integer;
  RecC: Integer;
  RID: Integer;
  MASTER: Integer;
begin
  SaveContext;

  if HistorieAnzeigen then
  begin
    DrawGrid1.Row := pred(DrawGrid1.rowCount); // ganz unten!
    Button2Click(Sender);
  end
  else
  begin
    if (ItemsGRID.count > 0) then
      with IB_Cursor1 do
      begin

        BeginHourGlass;
        ToolButton31.Down := true;
        HistorieAnzeigen := true;

        SaveEdits;
        sql.clear;
        sql.Add('SELECT STATUS,RID');
        sql.Add('FROM AUFTRAG');
        sql.Add('WHERE (MASTER_R=' +
          inttostr(Integer(ItemsGRID[DrawGrid1.Row])) + ')');
        sql.Add('ORDER BY RID');
        GridDisable := true;
        StartTime := 0;
        RecN := 0;
        open;
        RecC := RecordCount; // Tlist TStringList
        ProgressBar1.max := RecC;
        ItemsGRID.clear;
        ItemsGRID.Capacity := RecC;
        ApiFirst;
        MASTER := -1;
        while not(eof) do
        begin
          RID := FieldByName('RID').AsInteger;
          if FieldByName('STATUS').AsInteger = ord(ctsHistorisch) then
            ItemsGRID.Add(pointer(RID))
          else
            MASTER := RID;
          APInext;
          if frequently(StartTime, 400) or (eof) then
          begin
            application.processmessages;
            ProgressBar1.Position := RecN;
          end;
        end;
        // sicherstellen, dass der Master zum Schluss angezeigt wird!
        close;
        ItemsGRID.Add(pointer(MASTER));
        ProgressBar1.Position := 0;
        DrawGrid1.rowCount := RecC;
        DrawGrid1.Row := pred(DrawGrid1.rowCount); // ganz unten!
        GridDisable := false;
        InvalidateCache_Auftrag;
        DrawGrid1.refresh;
        RefreshCountAnzeige;
        DrawGrid1.SetFocus;
        EndHourGlass;
      end;
  end;
end;

procedure TFormAuftragArbeitsplatz.AddMarkierte(AUFTRAG_R: Integer);
begin
  ItemsMARKED.Add(pointer(AUFTRAG_R));
end;

procedure TFormAuftragArbeitsplatz.AddMarkierte_RID_AT_IMPORT
  (RID_AT_IMPORT: Integer);
var
  sAUFTRAG_R: TgpIntegerList;
  n: Integer;
begin
  SaveContext;
  sAUFTRAG_R := e_r_sqlm('select RID from AUFTRAG where (RID_AT_IMPORT=' +
    inttostr(RID_AT_IMPORT) + ') and (RID=MASTER_R)');
  for n := 0 to pred(sAUFTRAG_R.count) do
    AddMarkierte(sAUFTRAG_R[n]);
  sAUFTRAG_R.free;
end;

procedure TFormAuftragArbeitsplatz.AnzeigenRefresh;
begin
  ZhlerInfosanzeigen1.checked := ZaehlerInfosAnzeigen;
  Protokollangabenanzeigen1.checked := ProtokollangabenAnzeigen;
  Zhlernummeranzeigen1.checked := ZaehlerNummerAnzeigen;
  Zeitraumanzeigen1.checked := ZeitraumAnzeigen;
  Problemeanzeigen1.checked := ProblemeAnzeigen;
  InvalidateCache_Auftrag;
  DrawGrid1.refresh;
end;

procedure TFormAuftragArbeitsplatz.Zeitraumanzeigen1Click(Sender: TObject);
begin
  ZeitraumAnzeigen := not(ZeitraumAnzeigen);
  ProtokollangabenAnzeigen := false;
  ProblemeAnzeigen := false;
  AnzeigenRefresh;
end;

procedure TFormAuftragArbeitsplatz.ZhlerInfosanzeigen1Click(Sender: TObject);
begin
  ZaehlerInfosAnzeigen := not(ZaehlerInfosAnzeigen);
  ZaehlerNummerAnzeigen := false;
  ProtokollangabenAnzeigen := false;
  ProblemeAnzeigen := false;
  AnzeigenRefresh;
end;

procedure TFormAuftragArbeitsplatz.Protokollangabenanzeigen1Click
  (Sender: TObject);
begin
  ProtokollangabenAnzeigen := not(ProtokollangabenAnzeigen);
  ZaehlerNummerAnzeigen := false;
  ZaehlerInfosAnzeigen := false;
  ZeitraumAnzeigen := false;
  ProblemeAnzeigen := false;
  AnzeigenRefresh;
end;

procedure TFormAuftragArbeitsplatz.Zhlernummeranzeigen1Click(Sender: TObject);
begin
  ZaehlerNummerAnzeigen := not(ZaehlerNummerAnzeigen);
  ZaehlerInfosAnzeigen := false;
  ProtokollangabenAnzeigen := false;
  ProblemeAnzeigen := false;
  AnzeigenRefresh;
end;

procedure TFormAuftragArbeitsplatz.Problemeanzeigen1Click(Sender: TObject);
begin
  ProblemeAnzeigen := not(ProblemeAnzeigen);
  ProtokollangabenAnzeigen := false;
  ZaehlerNummerAnzeigen := false;
  ZaehlerInfosAnzeigen := false;
  ZeitraumAnzeigen := false;
  AnzeigenRefresh;
end;

procedure TFormAuftragArbeitsplatz.Historieanzeigen1Click(Sender: TObject);
begin
  ToolButton31Click(Sender);
end;

procedure TFormAuftragArbeitsplatz.ToolButton12Click(Sender: TObject);
var
  n: Integer;
  WordAnz: Integer;
begin
  BeginHourGlass;
  IB_Query9.open;
  WordAnz := 0;
  with IB_Query9 do
    for n := 0 to pred(ItemsGRID.count) do
    begin
      ParamByName('CROSSREF').AsInteger := Integer(ItemsGRID[n]);
      WordAnz := WordAnz + FieldByName('WORDANZ').AsInteger;
    end;
  IB_Query9.close;
  EndHourGlass;
  ShowMessage(inttostr(WordAnz) + ' Anschreiben in dieser Ansicht!');
end;

procedure TFormAuftragArbeitsplatz.WordModusANAUS1Click(Sender: TObject);
begin
  if (ItemsGRID.count > 0) then
    ToggleStatusMode(Integer(ItemsGRID[DrawGrid1.Row]), cModeWord);
end;

procedure TFormAuftragArbeitsplatz.StatusMonteurinformiertANAUS1Click
  (Sender: TObject);
begin
  if (ItemsGRID.count > 0) then
    ToggleStatusMode(Integer(ItemsGRID[DrawGrid1.Row]), cModeMonteur);
end;

procedure TFormAuftragArbeitsplatz.ToolButton19Click(Sender: TObject);
var
  InfoAnz: Integer;
  n: Integer;
  _now: TDateTime;
  qAUFTRAG: TIB_Query;
begin
  if doit('Es wurden ' + inttostr(_MonteurRIDsCount) + ' Monteur(e) informiert!'
    + #13 + 'Es wurden ' + inttostr(ItemInformiert.count) +
    ' Termine ausgegeben!' + #13 + #13 + 'Soll dies verbucht werden') then
  begin

    BeginHourGlass;
    _now := now;

    qAUFTRAG := DataModuleDatenbank.nQuery;
    with qAUFTRAG do
    begin
      sql.Add('SELECT * FROM AUFTRAG');
      sql.Add('WHERE RID=:CROSSREF');
      sql.Add('FOR UPDATE');
    end;

    qAUFTRAG.open;
    InfoAnz := 0;
    with qAUFTRAG do
      for n := 0 to pred(ItemInformiert.count) do
      begin
        ParamByName('CROSSREF').AsInteger := Integer(ItemInformiert[n]);
        if not(eof) then
          if (FieldByName('STATUS').AsInteger <> ord(ctsHistorisch)) then
            if (FieldByName('MONTEUREXPORT').IsNull) then
            begin
              inc(InfoAnz);
              edit;
              FieldByName('MONTEUREXPORT').AsDateTime := _now;
              AuftragBeforePost(qAUFTRAG, true);
              if HistorischerErzeugt then
                HistorischeFlash;
              post;
            end;
      end;
    qAUFTRAG.close;
    qAUFTRAG.free;
    EndHourGlass;
    ShowMessage('Über ' + inttostr(InfoAnz) +
      ' neue(n) Termin(e) wurde informiert!');
    InvalidateCache_Auftrag;
    DrawGrid1.refresh;
  end;
end;

procedure TFormAuftragArbeitsplatz.ToolButton28Click(Sender: TObject);

var
  WordAnz: Integer;
  _now: TDateTime;
  AllCsv: TStringlist;
  FName: string;

  procedure BookOne(AUFTRAG_R: Integer);
  begin
    with IB_Query9 do
    begin
      ParamByName('CROSSREF').AsInteger := AUFTRAG_R;
      if not(eof) then
        if (FieldByName('WORDEXPORT').IsNull) and
          (FieldByName('STATUS').AsInteger in [ord(ctsTerminiert),
          ord(ctsNeuAnschreiben), ord(ctsAngeschrieben),
          ord(ctsMonteurinformiert)]) then
        begin
          edit;
          FieldByName('WORDEXPORT').AsDateTime := _now;
          FieldByName('WORDANZ').AsInteger := FieldByName('WORDANZ')
            .AsInteger + 1;
          FieldByName('STATUS').AsInteger := ord(ctsAngeschrieben);
          post;
          inc(WordAnz);
        end;
    end;
  end;

var
  n: Integer;

begin
  FName := MyProgramPath + FormBearbeiter.sBearbeiterKurz + '.csv';
  if FileExists(FName) then
  begin

    // Neues verhalten
    AllCsv := TStringlist.create;
    AllCsv.LoadFromFile(FName);
    if doit('Die letzte csv umfasst ' + inttostr(pred(AllCsv.count)) +
      ' Datensätze!' + #13 +
      'Soll anhand dieser Liste der Word-Status gebucht werden') then
    begin
      BeginHourGlass;
      _now := now;
      IB_Query9.open;
      WordAnz := 0;

      for n := 1 to pred(AllCsv.count) do
        BookOne(strtointdef(nextp(AllCsv[n], ';',
          ord(twh_ReferenzIdentitaet)), 0));
      IB_Query9.close;
      EndHourGlass;

      ShowMessage(inttostr(WordAnz) + ' neue(s) Anschreiben!');
      InvalidateCache_Auftrag;
      DrawGrid1.refresh;
    end;
    AllCsv.free;
  end;
end;

procedure TFormAuftragArbeitsplatz.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FormAuftrag.close;
  SaveContext;
end;

procedure TFormAuftragArbeitsplatz.ToolButton23Click(Sender: TObject);
var
  n: Integer;
  cAUFTRAG: TIB_Cursor;
begin

  // alle historischen Markieren
  BeginHourGlass;
  SaveContext;
  ItemsMARKED.clear;
  cAUFTRAG := DataModuleDatenbank.nCursor;
  with cAUFTRAG do
  begin
    sql.Add('select RID from AUFTRAG where');
    sql.Add(' (MASTER_R=:CROSSREF) AND');
    sql.Add(' (MASTER_R<>RID)');
    for n := 0 to pred(ItemsGRID.count) do
    begin
      ParamByName('CROSSREF').AsInteger := Integer(ItemsGRID[n]);
      ApiFirst;
      if not(eof) then
        ItemsMARKED.Add(ItemsGRID[n]);
    end;
  end;
  cAUFTRAG.free;
  EndHourGlass;

  InvalidateCache_Auftrag;
  DrawGrid1.refresh;
end;

procedure TFormAuftragArbeitsplatz.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssAlt in Shift then
  begin
    case Key of
      ord('h'), ord('H'):
        begin
          Key := 0;
          ToolButton31Click(Sender);
        end;
      VK_F1:
        begin
          Key := 0;
          ComboBox2.visible := not(ComboBox2.visible);
        end;
    end;
  end
  else
  begin
    case Key of
      27:
        begin
          Key := 0;
          close;
        end;
      13:
        if DrawGrid1.Focused then
        begin
          Key := 0;
          ShowAuftrag;
        end;
      ord('f'), ord('F'):
        if DrawGrid1.Focused then
        begin
          FindNextMarked;
        end;
      ord('n'), ord('N'):
        if DrawGrid1.Focused then
          MarkProtokollValue('NA');
      ord('g'), ord('G'):
        if DrawGrid1.Focused then
        begin
          if (DrawGrid1.Row <> -1) then
          begin
            if (ItemsGRID[DrawGrid1.Row] = TObject(1)) then
              ItemsGRID.Delete(DrawGrid1.Row)
            else
              ItemsGRID.insert(DrawGrid1.Row, TObject(1));
          end
          else
            ItemsGRID.Add(TObject(1));
          NotifyGrid1;
        end;
      ord('k'), ord('K'):
        if DrawGrid1.Focused then
        begin
          if (DrawGrid1.Row <> -1) then
          begin
            showMap(Integer(ItemsGRID[DrawGrid1.Row]));
          end;
        end;

      ord('m'), ord('M'), ord(' '):
        if DrawGrid1.Focused then
        begin
          if ssCtrl in Shift then
          begin
            // suche nächsten Markierten
            FindNextMarked;
          end
          else
          begin
            Key := 0;
            MarkAuftrag;
          end;
        end;
    end;

  end;
end;

var
  _old_length: Integer;

procedure TFormAuftragArbeitsplatz.ComboBox2Enter(Sender: TObject);
begin
  _old_length := ComboBox2.width;
  ComboBox2.width := 180;
end;

procedure TFormAuftragArbeitsplatz.ComboBox2Exit(Sender: TObject);
begin
  ComboBox2.width := _old_length;
end;

procedure TFormAuftragArbeitsplatz.ComboBox4Exit(Sender: TObject);
begin

  if revpos('.', ComboBox4.Text) = length(ComboBox4.Text) then
    ComboBox4.Text := copy(ComboBox4.Text, 1, pred(length(ComboBox4.Text)));

  if CharCount('.', ComboBox4.Text) = 1 then
    ComboBox4.Text := ComboBox4.Text + copy(Long2date(DateGet), 6, 5);

  if dateOK(Date2Long(ComboBox4.Text)) then
  begin
    ComboBox4.Text := Long2date(Date2Long(ComboBox4.Text));
    if (ComboBox5.Text = '*') then
    begin
      ComboBox5.Text := ComboBox4.Text;
    end;
  end;
end;

procedure TFormAuftragArbeitsplatz.ToolButton26Click(Sender: TObject);
var
  n: Integer;
  sub: TStringlist;
  ZaehlerNummernAlt: TStringlist;
  ZaehlerNummernNeu: TStringlist;
  ReglerNummerAlt: TStringlist;
  ReglerNummerNeu: TStringlist;
  Dupletten: TStringlist;
  DeleteCount: Integer;
  TmpDeleteCount: Integer;
  StartTime: dword;
  S: string;

  function FormatZaehlerNummerAsOneWord(S: string): string;
  begin
    result := noblank(S);
    ersetze('-', '~', result);
  end;

begin
  BeginHourGlass;
  Dupletten := TStringlist.create;
  ZaehlerNummernAlt := TStringlist.create;
  ZaehlerNummernNeu := TStringlist.create;
  ReglerNummerAlt := TStringlist.create;
  ReglerNummerNeu := TStringlist.create;
  StartTime := 0;
  ProgressBar1.max := ItemsGRID.count;
  for n := 0 to pred(ItemsGRID.count) do
  begin
    sub := e_r_AuftragItems(Integer(ItemsGRID[n]));

    S := FormatZaehlerNummerAsOneWord(sub[twh_Zaehler_Nummer]);
    if (S <> '') then
      ZaehlerNummernAlt.AddObject(S, ItemsGRID[n]);

    S := FormatZaehlerNummerAsOneWord(sub[twh_ZaehlerNummerNeu]);
    if (S <> '') then
      ZaehlerNummernNeu.AddObject(S, ItemsGRID[n]);

    S := FormatZaehlerNummerAsOneWord(sub[twh_ReglerNummerAlt]);
    if (S <> '') then
      ReglerNummerAlt.AddObject(S, ItemsGRID[n]);

    S := FormatZaehlerNummerAsOneWord(sub[twh_ReglerNummerNeu]);
    if (S <> '') then
      ReglerNummerNeu.AddObject(S, ItemsGRID[n]);

    if frequently(StartTime, 444) then
    begin
      application.processmessages;
      ProgressBar1.Position := n;
    end;
  end;
  DeleteCount := 0;

  Dupletten.Add('Doppelte "Zähler Nummer Alt":');
  Dupletten.Add('');
  ZaehlerNummernAlt.sort;
  removeDuplicates(ZaehlerNummernAlt, TmpDeleteCount, Dupletten);
  inc(DeleteCount, TmpDeleteCount);

  Dupletten.Add('');
  Dupletten.Add('Doppelte "Zähler Nummer Neu":');
  Dupletten.Add('');
  ZaehlerNummernNeu.sort;
  removeDuplicates(ZaehlerNummernNeu, TmpDeleteCount, Dupletten);
  inc(DeleteCount, TmpDeleteCount);

  Dupletten.Add('');
  Dupletten.Add('Doppelte "Regler Nummer Alt":');
  Dupletten.Add('');
  ReglerNummerAlt.sort;
  removeDuplicates(ReglerNummerAlt, TmpDeleteCount, Dupletten);
  inc(DeleteCount, TmpDeleteCount);

  Dupletten.Add('');
  Dupletten.Add('Doppelte "Regler Nummer Neu":');
  Dupletten.Add('');
  ReglerNummerNeu.sort;
  removeDuplicates(ReglerNummerNeu, TmpDeleteCount, Dupletten);
  inc(DeleteCount, TmpDeleteCount);

  ProgressBar1.Position := 0;
  EndHourGlass;

  if (DeleteCount = 0) then
  begin
    ShowMessage('Keine Doppelten!');
  end
  else
  begin

    // Markieren der Problem-Fälle
    ItemsMARKED.clear;
    for n := 0 to pred(Dupletten.count) do
      if (Dupletten.objects[n] <> nil) then
        ItemsMARKED.Add(Dupletten.objects[n]);

    //
    if doit('Es gibt insgesamt ' + inttostr(DeleteCount) + ' doppelte.' + #13 +
      'Die doppelten sind jetzt markiert!' + #13 +
      'Wollen Sie eine Liste der doppelten Nummern' + #13 + 'jetzt einsehen')
    then
    begin
      Dupletten.SaveToFile(DiagnosePath + 'Doppelte-Nummern.txt');
      OpenShell(DiagnosePath + 'Doppelte-Nummern.txt');
    end;

  end;

  //
  ZaehlerNummernAlt.free;
  ZaehlerNummernNeu.free;
  ReglerNummerAlt.free;
  ReglerNummerNeu.free;
  Dupletten.free;

  // kompletter Refresh
  NotifyGrid1;
end;

procedure TFormAuftragArbeitsplatz.Timer1Timer(Sender: TObject);
begin
  if NoTimer then
    exit;

  // Belastung
  if (ShouldRefreshBelastungIn > 0) then
  begin
    dec(ShouldRefreshBelastungIn, Timer1.interval);
    if ShouldRefreshBelastungIn <= 0 then
    begin
      ShouldRefreshBelastungIn := 0;
      ToolButton1Click(Sender);
    end;
  end;

  // Camera
  if (ShouldRefreshCameraIn > 0) then
  begin
    dec(ShouldRefreshCameraIn, Timer1.interval);
    if ShouldRefreshCameraIn <= 0 then
    begin
      ToolButton11.imageindex := 90;
      ShouldRefreshCameraIn := 0;
    end;
  end;

  // Historische
  if (ShouldRefreshHistorischeIn > 0) then
  begin
    dec(ShouldRefreshHistorischeIn, Timer1.interval);
    if (ShouldRefreshHistorischeIn <= 0) then
    begin
      ToolButton31.imageindex := 47;
      ShouldRefreshHistorischeIn := 0;
    end;
  end;
end;

procedure TFormAuftragArbeitsplatz.ToolButton29Click(Sender: TObject);
var
  n: Integer;
  AllDataKuerzel: TStringlist;
  lMonteur: TgpIntegerList;
begin
  // die ganze Woche!
  TageRIDs.clear;
  for n := 1 to 7 do
    TageRIDs.Add(DatePlus(v_MonteurMontag, pred(n)));

  // alle Monteure
  if (MonteurSelected <> -1) then
  begin
    if not(doit('Soll die ganze Woche für' + #13 +
      e_r_MonteurName(MonteurSelected) + #13 + 'ausgegeben werden?' + #13 + #13
      + '(Drücken Sie jetzt abbrechen, um die Auswahl eines' + #13 +
      'einzelnen Monteures aufzuheben. Danach können Sie die' + #13 +
      'ganze Woche für alle Monteure ausgeben)')) then
    begin
      Button5.SetFocus;
      exit;
    end;
    MonteurRIDs.clear;
    MonteurRIDs.Add(MonteurSelected);
  end
  else
  begin
    // nobel: Soll die ganze Woche für alle blauen Monteure ausgegeben werden?
    FormMonteurUmfang.showModal;
    case FormMonteurUmfang.ExecuteResult of
      0:
        begin
          BeginHourGlass;
          MonteurRIDs.clear;

          if (s_Baustelle = -1) then
          begin
            AllDataKuerzel := e_r_BaustelleMonteure(a_baustelle);
            for n := 0 to pred(AllDataKuerzel.count) do
              if (AllDataKuerzel[n] = cMonteurTrenner) then
                break
              else
                MonteurRIDs.Add(Integer(AllDataKuerzel.objects[n]));
          end
          else
          begin
            // Nur die der aktuellen Baustelle, die auch Termine haben
            lMonteur := e_r_sqlm('select MONTEUR1_R from AUFTRAG where ' +
              ' (BAUSTELLE_R=' + inttostr(s_Baustelle) + ') and ' +
              ' (RID=MASTER_R) and ' + ' (MONTEUR1_R is not null) and ' +
              ' (AUSFUEHREN between ''' + Long2date(TageRIDs[0]) + ''' and ''' +
              Long2date(TageRIDs[pred(TageRIDs.count)]) + ''') ' + 'group by ' +
              ' MONTEUR1_R');
            for n := 0 to pred(lMonteur.count) do
              if (MonteurRIDs.indexof(lMonteur[n]) = -1) then
                MonteurRIDs.Add(lMonteur[n]);
            lMonteur.free;

            lMonteur := e_r_sqlm('select MONTEUR2_R from AUFTRAG where ' +
              ' (BAUSTELLE_R=' + inttostr(s_Baustelle) + ') and ' +
              ' (RID=MASTER_R) and ' + ' (MONTEUR2_R is not null) and ' +
              ' (AUSFUEHREN between ''' + Long2date(TageRIDs[0]) + ''' and ''' +
              Long2date(TageRIDs[pred(TageRIDs.count)]) + ''') ' + 'group by ' +
              ' MONTEUR2_R');
            for n := 0 to pred(lMonteur.count) do
              if (MonteurRIDs.indexof(lMonteur[n]) = -1) then
                MonteurRIDs.Add(lMonteur[n]);
            lMonteur.free;

          end;
          EndHourGlass;
        end;
      1:
        begin
          // Alle - Alle
          BeginHourGlass;
          AllDataKuerzel := e_r_MonteureCache;
          MonteurRIDs.clear;
          for n := 0 to pred(AllDataKuerzel.count) do
            MonteurRIDs.Add(Integer(AllDataKuerzel.objects[n]));
          EndHourGlass;
        end;
    else
      exit;
    end;

  end;

  // Nun die tatsächliche List erzeugen!
  ProduceInfoBlatt(TageRIDs, MonteurRIDs, nil, false, true);
  if (ItemInformiert.count = 0) then
    ShowMessage('In KW ' + inttostr(WeekGet(v_MonteurMontag)) +
      ' gibt es keinen Termin!');
end;

function TFormAuftragArbeitsplatz.MonteurSelected: Integer;
begin
  //
  if DrawGrid2.Focused then
    result := Auslastung.RID[DrawGrid2.Row]
  else
    result := -1;
end;

procedure TFormAuftragArbeitsplatz.DrawGrid2DrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  _ACol: Integer;
  _TextWidth: Integer;
  _FontSize: Integer;
  FocusedLine: boolean;

  function FocusBrush(c: TColor): TColor;
  begin
    {
      if FocusedLine then
      result := ColorBrightness(c,-22)
      else
    }
    result := c;
  end;

  procedure DrawMicroCell(Data: TAuslastungZelle; Rect: TRect);
  var
    CellText: string;
  begin
    with Data, DrawGrid2.canvas do
    begin
      if (AnzahlIst = 0) and (AnzahlSoll = 0) then
      begin
        FillRect(Rect);
      end
      else
      begin

        // mehrere Baustellen?
        if (Baustellen.count > 1) then
        begin

          // abgeschwächte Farben verwenden
          if Baustellen.indexof(TObject(s_Baustelle)) = -1 then
            brush.color := FocusBrush(HTMLColor2TColor($CCCCFF))
          else
            brush.color := FocusBrush(HTMLColor2TColor($CCFFCC));

        end
        else
        begin

          // starke Farben verwenden
          if Baustellen.indexof(TObject(s_Baustelle)) = -1 then
            brush.color := FocusBrush(HTMLColor2TColor($0000FF))
          else
            brush.color := FocusBrush(HTMLColor2TColor($00FF00));

        end;

        if (Auslastung.Mode <> 2) then
        begin
          if (Aufwand > Kapazitaet + cToleranzRahmenVolllast) then
          begin
            // Überlast
            font.color := clred;
            font.style := [fsbold];
          end
          else
          begin
            if (abs(Kapazitaet - Aufwand) < cToleranzRahmenVolllast) then
            begin
              // genau getroffen
              font.color := VisibleContrast(brush.color);
              font.style := [fsbold];
            end
            else
            begin
              // voll normal ey
              font.color := VisibleContrast(brush.color);
              font.style := [];
            end;
          end;
        end
        else
        begin
          font.color := VisibleContrast(brush.color);
          font.style := [];
        end;

        case Auslastung.Mode of
          0:
            CellText := TerminAnzahl;
          1:
            CellText := TerminDauer;
          2:
            CellText := TerminAnzahl;
        else
          CellText := '?';
        end;

        _TextWidth := TextWidth(CellText);
        TextRect(Rect, Rect.left + succ(((rxl(Rect) - _TextWidth) div 2)),
          Rect.top, CellText);
      end;
    end;
  end;

begin

  with DrawGrid2, canvas do
  begin
    if (ARow >= 0) then
    begin

      FocusedLine := (ARow = Row) and Focused;

      if odd(ARow) then
      begin
        brush.color := FocusBrush(clWhite);
      end
      else
      begin
        brush.color := FocusBrush(clListeGrau);
      end;

      if (ARow < Auslastung.count) then
      begin

        if (ACol = 0) then
        begin
          // Monteur
          // arbeitet auf dieser Baustelle?
          if Auslastung[ARow].EigeneBaustelle(s_Baustelle) then
            brush.color := FocusBrush(HTMLColor2TColor($00CCFF));

          // im Moment selectiert?
          _FontSize := font.size;
          if FocusedLine then
          begin
            font.style := [fsbold, fsunderline];
            font.size := 7;
          end;

          if (length(Auslastung[ARow].Title) > 5) then
            font.size := 7;

          TextRect(Rect, Rect.left + 2, Rect.top + 8, Auslastung[ARow].Title);

          font.size := _FontSize;
          font.style := [];

          pen.color := $303030;
          MoveTo(Rect.left, pred(Rect.bottom));
          LineTo(Rect.right, pred(Rect.bottom));
        end
        else
        begin
          // Zahlen
          _ACol := (pred(ACol) * 2);

          DrawMicroCell(Auslastung[ARow][_ACol], mkrect(Rect.left, Rect.top,
            rxl(Rect), cPlanY_div_2));
          DrawMicroCell(Auslastung[ARow][_ACol + 1],
            mkrect(Rect.left, Rect.top + cPlanY_div_2 - 2, rxl(Rect),
            cPlanY_div_2 + 2));

          // normalize
          font.color := clblack;
          font.style := [];

          // Rahmen zeichnen
          MoveTo(Rect.left, Rect.top);

          if (ACol = v_Kursiv_cell) or (ACol = v_Kursiv_cell + 1) or FocusedLine
          then
          begin
            pen.color := clblack; // HTMLColor2TColor($0066CC)
            frameRect(Rect);
          end
          else
          begin
            pen.color := $303030;
          end;

          // vertikal links
          LineTo(Rect.left, pred(Rect.bottom));

          if (ACol = v_Kursiv_cell) or FocusedLine then
          begin
            pen.color := clblack; // HTMLColor2TColor($0066CC);
          end;
          if ACol = v_Kursiv_cell + 1 then
          begin
            pen.color := $303030;
          end;

          // horizontal unten
          LineTo(Rect.right, pred(Rect.bottom));

        end;
      end
      else
      begin
        MoveTo(Rect.left, Rect.top);

        if (ACol = v_Kursiv_cell) or (ACol = v_Kursiv_cell + 1) or FocusedLine
        then
        begin
          pen.color := clblack; // HTMLColor2TColor($0066CC)
          frameRect(Rect);
        end
        else
        begin
          pen.color := $303030;
        end;

        // vertikal links
        LineTo(Rect.left, pred(Rect.bottom));

      end;
    end
    else
    begin
      FillRect(Rect);
      beep;
    end;
  end;
end;

procedure TFormAuftragArbeitsplatz.Button5Click(Sender: TObject);
begin
  v_MonteurTag := DatePlus(v_MonteurMontag, 0);
  v_Kursiv_cell := WeekDay(v_MonteurTag);
  Label14.caption := long2datetext(v_MonteurTag);
  DrawGrid2.refresh;
  DrawGrid2.SetFocus;
end;

procedure TFormAuftragArbeitsplatz.Button7Click(Sender: TObject);
begin
  v_MonteurTag := DatePlus(v_MonteurMontag, 1);
  v_Kursiv_cell := WeekDay(v_MonteurTag);
  Label14.caption := long2datetext(v_MonteurTag);
  DrawGrid2.refresh;
  DrawGrid2.SetFocus;
end;

procedure TFormAuftragArbeitsplatz.Button8Click(Sender: TObject);
begin
  v_MonteurTag := DatePlus(v_MonteurMontag, 2);
  v_Kursiv_cell := WeekDay(v_MonteurTag);
  Label14.caption := long2datetext(v_MonteurTag);
  DrawGrid2.refresh;
  DrawGrid2.SetFocus;
end;

procedure TFormAuftragArbeitsplatz.Button9Click(Sender: TObject);
begin
  v_MonteurTag := DatePlus(v_MonteurMontag, 3);
  v_Kursiv_cell := WeekDay(v_MonteurTag);
  Label14.caption := long2datetext(v_MonteurTag);
  DrawGrid2.refresh;
  DrawGrid2.SetFocus;
end;

procedure TFormAuftragArbeitsplatz.Add(RID: Integer);
begin
  InvalidateCache_Auftrag;
  //
  ItemsGRID.Add(pointer(RID));
  ItemsQUERY.Add(pointer(RID));

  DrawGrid1.rowCount := ItemsGRID.count;
  DrawGrid1.Row := pred(ItemsGRID.count);

  RefreshCountAnzeige;
  DrawGrid1.refresh;
end;

procedure TFormAuftragArbeitsplatz.Button10Click(Sender: TObject);
begin
  v_MonteurTag := DatePlus(v_MonteurMontag, 4);
  v_Kursiv_cell := WeekDay(v_MonteurTag);
  Label14.caption := long2datetext(v_MonteurTag);
  DrawGrid2.refresh;
  DrawGrid2.SetFocus;
end;

procedure TFormAuftragArbeitsplatz.Button11Click(Sender: TObject);
begin
  v_MonteurTag := DatePlus(v_MonteurMontag, 5);
  v_Kursiv_cell := WeekDay(v_MonteurTag);
  Label14.caption := long2datetext(v_MonteurTag);
  DrawGrid2.refresh;
  DrawGrid2.SetFocus;
end;

procedure TFormAuftragArbeitsplatz.Button12Click(Sender: TObject);
begin
  v_MonteurTag := DatePlus(v_MonteurMontag, 6);
  v_Kursiv_cell := WeekDay(v_MonteurTag);
  Label14.caption := long2datetext(v_MonteurTag);
  DrawGrid2.refresh;
  DrawGrid2.SetFocus;
end;

procedure TFormAuftragArbeitsplatz.Button13Click(Sender: TObject);
begin
  Edit1.Text := e_r_BaustelleKuerzel(s_Baustelle) + ':';
  Edit1.SetFocus;
end;

procedure TFormAuftragArbeitsplatz.ToolButton32Click(Sender: TObject);
var
  ChangeFields: TStringlist;
  ChangeRID: Integer;
  n, m: Integer;
  StartTime: dword;
  INFO_ORG: TStringlist;
  INFO_NEW: TStringlist;
  cAUFTRAG: TIB_Cursor;
  SichtbarMarkierte: TExtendedList;

  rWorkerList: TExtendedList; // referenced! do not free
  WorkerPermission: boolean; //
  WorkerDialogResult: Integer;

  procedure CheckDelete(FieldName: string);
  var
    k: Integer;
  begin
    k := ChangeFields.indexof(FieldName);
    if (k <> -1) then
    begin
      if not(doit(
        { } 'Das Feld "' + FieldName + '" zu erweitern ist riskant.' + #13 +
        { } 'In der Regel ist dies nicht notwendig, es sei denn Sie wissen genau was Sie tun!'
        + #13 +
        { } 'Dieses Feld jetzt wirklich ändern', true)) then
        ChangeFields.Delete(k);
    end;
  end;

begin
  INFO_ORG := TStringlist.create;
  INFO_NEW := TStringlist.create;
  ChangeFields := TStringlist.create;
  ChangeFields.assign(AuftragLastChangeFields);
  ChangeRID := AuftragLastChangeRID;
  StartTime := 0;

  CheckDelete('INTERN_INFO');
  // CheckDelete('ZAEHLER_INFO');

  CheckDelete('ZAEHLER_NUMMER');
  // CheckDelete('MONTEUR_INFO');

  if (ChangeFields.count > 0) and (ItemsMARKED.count > 0) then
  begin

    SichtbarMarkierte := TExtendedList.create;
    SichtbarMarkierte.LogicalOR(ItemsMARKED);
    SichtbarMarkierte.LogicalAND(ItemsGRID);
    WorkerPermission := false;
    rWorkerList := nil;

    repeat

      //
      if (ItemsMARKED.count = SichtbarMarkierte.count) then
      begin
        // alle Markierten sind auch sichtbar!
        WorkerPermission := doit('Es sind ' + inttostr(ItemsMARKED.count) +
          ' Datensätze markiert!' + #13 + 'Folgende Felder werden bei ' + #13 +
          'den markierten Datenfeldern überschrieben:' + #13 + #13 +
          HugeSingleLine(ChangeFields, #13) + #13 + #13 +
          'Sollen die Feldinhalte geändert werden');
        rWorkerList := ItemsMARKED;
        break;
      end;
      WorkerDialogResult := YesNoCancel('Es sind ' + inttostr(ItemsMARKED.count)
        + ' Datensätze markiert!' + #13 + 'Davon sind aber nur ' +
        inttostr(SichtbarMarkierte.count) +
        ' in der aktuellen Ansicht enthalten!' + #13 +
        'Folgende Felder werden bei ' + #13 +
        'den markierten Datenfeldern geändert:' + #13 + #13 +
        HugeSingleLine(ChangeFields, #13) + #13 + #13 + '<JA> Es werden nur ' +
        inttostr(SichtbarMarkierte.count) + ' sichtbar markierte geändert!' +
        #13 + '<NEIN> Es werden alle ' + inttostr(ItemsMARKED.count) +
        ' markierten geändert!' + #13 + '<ABBRECHEN> Es wird nichts geändert!');

      case WorkerDialogResult of
        IDYES:
          begin
            WorkerPermission := true;
            rWorkerList := SichtbarMarkierte;
          end;
        IDNO:
          begin
            WorkerPermission := true;
            rWorkerList := ItemsMARKED;
          end;
      end;

    until true;

    if WorkerPermission then
    begin

      BeginHourGlass;
      ProgressBar1.max := rWorkerList.count;

      cAUFTRAG := DataModuleDatenbank.nCursor;
      with cAUFTRAG do
      begin
        sql.Add('select * from AUFTRAG where RID=' + inttostr(ChangeRID));
        ApiFirst;
      end;
      if not(cAUFTRAG.eof) then
      begin
        for n := 0 to pred(rWorkerList.count) do
        begin

          IB_Query2.ParamByName('CROSSREF').AsInteger :=
            Integer(rWorkerList[n]);
          if not(IB_Query2.Active) then
            IB_Query2.open;

          IB_Query2.edit;
          for m := 0 to pred(ChangeFields.count) do
          begin
            if cAUFTRAG.FieldByName(ChangeFields[m]).IsNull then
            begin
              IB_Query2.FieldByName(ChangeFields[m]).clear
            end
            else
            begin
              if (IB_Query2.FieldByName(ChangeFields[m]).IsText) and
                (IB_Query2.FieldByName(ChangeFields[m]).IsBlob) then
              begin
                cAUFTRAG.FieldByName(ChangeFields[m]).AssignTo(INFO_NEW);
                IB_Query2.FieldByName(ChangeFields[m]).AssignTo(INFO_ORG);
                INFO_ORG.AddStrings(INFO_NEW);
                IB_Query2.FieldByName(ChangeFields[m]).assign(INFO_ORG);
              end
              else
              begin
                IB_Query2.FieldByName(ChangeFields[m])
                  .assign(cAUFTRAG.FieldByName(ChangeFields[m]));
              end;
            end;
          end;
          IB_Query2.post;

          if frequently(StartTime, 333) or (n = pred(rWorkerList.count)) then
          begin
            application.processmessages;
            ProgressBar1.Position := n;
          end;

        end;
      end;
      cAUFTRAG.free;
      IB_Query2.close;
      SichtbarMarkierte.free;

      EndHourGlass;
    end;
    // wieder rücksetzen, dass
    AuftragLastChangeFields.assign(ChangeFields);
    AuftragLastChangeRID := ChangeRID;
  end;
  ProgressBar1.Position := 0;
  ChangeFields.free;
  INFO_ORG.free;
  INFO_NEW.free;
  InvalidateCache_Auftrag;
  DrawGrid1.refresh;
end;

procedure TFormAuftragArbeitsplatz.IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
begin
  try
    AuftragBeforePost(IB_Dataset, AuftragPostReorgMode);
    if HistorischerErzeugt then
      HistorischeFlash;
  except
  end;
  AuftragPostReorgMode := false;
end;

procedure TFormAuftragArbeitsplatz.ToolButton35Click(Sender: TObject);
var
  OutList: TList;
  UseMarked: boolean;
  DeleteAll: boolean;
  n: Integer;
begin

  // ganze Listen ausgeben!
  if (ItemsGRID.count > 0) then
  begin
    DeleteAll := true;
    if HistorieAnzeigen then
      DeleteAll := FormFrageLoeschenMonteurInfo.CanDeleteAll;

    try
      if DeleteAll then
      begin
        if doit('Dadurch werden die Monteure nicht mehr' + #13 +
          'über den Wegfall eines Termines informiert!' + #13 +
          'Soll wirklich bei allen historischen Datensätzen' + #13 +
          'das "Monteur informiert" Symbol entfernt werden') then
        begin

          // Umfang festlegen
          UseMarked := false;
          ItemsMARKED.LogicalAND(ItemsGRID);
          if (ItemsMARKED.count > 0) then
            if doit('Es sind markierte Zeilen enthalten.' + #13 +
              'Drücken Sie <abbrechen>, um alle Datensätze in der Anzeige zu verwenden!'
              + #13 + 'Sollen nur ' + inttostr(ItemsMARKED.count) +
              ' markierte Datensätze verwendet werden') then
              UseMarked := true;

          if UseMarked then
            OutList := ItemsMARKED
          else
            OutList := ItemsGRID;

          BeginHourGlass;
          with IB_Query3 do
          begin
            for n := 0 to pred(OutList.count) do
            begin
              ParamByName('CROSSREF').AsInteger := Integer(OutList[n]);
              if not(Active) then
                open;
              if not(Isempty) then
              begin
                first;
                while not(eof) do
                begin
                  edit;
                  FieldByName('MONTEUREXPORT').clear;
                  post;
                  next;
                end;
              end;
            end;
          end;
          EndHourGlass;
        end;
      end
      else
      begin
        BeginHourGlass;
        try
          OutList := ItemsGRID;
          if (DrawGrid1.Row >= 0) and (DrawGrid1.Row < OutList.count) then
          begin
            with IB_Query_MonteurInfoEinzeln do
            begin
              ParamByName('CROSSREF').AsInteger :=
                Integer(OutList[DrawGrid1.Row]);
              if not(Active) then
                open;
              if not(Isempty) then
              begin
                first;
                while not(eof) do
                begin
                  edit;
                  FieldByName('MONTEUREXPORT').clear;
                  post;
                  next;
                end;
              end;
            end;
          end;
        finally
          EndHourGlass;
        end;
      end;
    finally
      DrawGrid1.Invalidate;
    end;
  end;
end;

procedure TFormAuftragArbeitsplatz.IB_Query3BeforePost(IB_Dataset: TIB_Dataset);
begin
  AuftragBeforePost(IB_Dataset);
  if HistorischerErzeugt then
    HistorischeFlash;
end;

procedure TFormAuftragArbeitsplatz.MarkiereLeeresPlanquadrat(Import_RID,
  Anzahl: Integer);

var
  StartTime: dword;
  Kandidaten: TStringlist;
  debugInfo: TStringlist;
  n: Integer;
  _RID_AT_IMPORT: Integer;
  _Planquadrat: string;
  _Strasse: string;

  function StrassenDiff(strasse: string; iIndex: Integer): Integer;
  var
    n, k, l: Integer;
    CheckStr: string;
    strasse2: string;
    _Hausnummer1, _Hausnummer2: string;
  begin
    if (iIndex = -1) or (iIndex >= ItemsGRID.count) then
    begin
      result := strtointdef(fill('9', cSTRASSE_HausNummern_Length), 0);
      exit;
    end;

    strasse := copy(strasse, succ(cSTRASSE_PLANQUADRAT_Length), MaxInt);

    CheckStr := strasse;
    for n := 1 to length(CheckStr) do
      if CheckStr[n] in ['0', '1'] then
        CheckStr[n] := '*'
      else
        break;
    k := pos('0', CheckStr);
    l := pos('1', CheckStr);
    if (k = 0) then
      k := l;
    if (l = 0) then
      l := k;
    k := min(k, l);
    if (k = 0) then
      ShowMessage('Fehler: Strasse Hausnummer, weder gerade noch ungerade!');

    IB_Query15.ParamByName('CROSSREF').AsInteger := Integer(ItemsGRID[iIndex]);
    strasse2 := copy(IB_Query15.FieldByName('STRASSE').AsString,
      succ(cSTRASSE_PLANQUADRAT_Length), MaxInt);

    if copy(strasse, 1, pred(k)) = copy(strasse2, 1, pred(k)) then
    begin
      _Hausnummer1 := copy(strasse, succ(k), cSTRASSE_HausNummern_Length);
      _Hausnummer2 := copy(strasse2, succ(k), cSTRASSE_HausNummern_Length);
      result := abs(strtol(_Hausnummer2) - strtol(_Hausnummer1));
      debugInfo.Add(strasse + ',' + strasse2 + ',' + inttostr(result));
    end
    else
    begin
      result := strtointdef(fill('9', cSTRASSE_HausNummern_Length), 0);
    end;
  end;

begin
  BeginHourGlass;
  StartTime := 0;
  ItemsMARKED.clear;
  ProgressBar1.max := ItemsGRID.count;
  Kandidaten := TStringlist.create;
  debugInfo := TStringlist.create;
  with IB_Query15 do
    for n := 0 to pred(ItemsGRID.count) do
    begin
      ParamByName('CROSSREF').AsInteger := Integer(ItemsGRID[n]);
      if not(Active) then
        open;

      _RID_AT_IMPORT := FieldByName('RID_AT_IMPORT').AsInteger;
      _Planquadrat := FieldByName('PLANQUADRAT').AsString;
      _Strasse := FieldByName('STRASSE').AsString;

      if (_RID_AT_IMPORT >= Import_RID) or (Import_RID = 0) then
      begin
        if (_Planquadrat = '') then
          Kandidaten.AddObject(fill('9', cSTRASSE_HausNummern_Length) + ',' + _Strasse,
            pointer(ItemsGRID[n]))
        else
          Kandidaten.AddObject(inttostrN(min(StrassenDiff(_Strasse, n - 1),
            StrassenDiff(_Strasse, n + 1)), cSTRASSE_HausNummern_Length) + ',' +
            _Strasse, pointer(ItemsGRID[n]));
      end;
      if frequently(StartTime, 333) then
      begin
        application.processmessages;
        ProgressBar1.Position := n;
      end;
    end;
  ProgressBar1.Position := 0;
  Kandidaten.sort;
  for n := pred(Kandidaten.count) downto 0 do
  begin
    ItemsMARKED.Add(Kandidaten.objects[n]);
    if ItemsMARKED.count = Anzahl then
      break;
  end;
  IB_Query15.close;
  debugInfo.SaveToFile(DiagnosePath + 'Strassen.txt');
  Kandidaten.SaveToFile(DiagnosePath + 'Strassen2.txt');
  FreeAndNil(debugInfo);
  FreeAndNil(Kandidaten);
  RefreshCountAnzeige;
  InvalidateCache_Auftrag;
  DrawGrid1.refresh;
  EndHourGlass;
  if doit('Wollen Sie eine Diagnose der Hausabstände') then
    OpenShell(MyProgramPath + 'Strassen.txt');
  if doit('Wollen Sie eine Diagnose der Reihenfolge') then
    OpenShell(MyProgramPath + 'Strassen2.txt');
end;

procedure TFormAuftragArbeitsplatz.ToolButton38Click(Sender: TObject);
var
  n: Integer;
begin
  ItemsMARKED.LogicalAND(ItemsGRID);
  if ItemsMARKED.count > 0 then
    if doit('Sollen wirklich ' + inttostr(ItemsMARKED.count) +
      ' Aufträge gelöscht werden', true) then
      if not(doit('Das Löschen ist in der Regel nicht notwendig!' + #13 +
        'Haben Sie zuvor eine Wordausgabedatei erzeugt?' + #13 +
        'Liegen die Daten in einer Importdatei vor?' + #13 +
        'Wenn Sie jetzt <abbrechen> drücken wird gelöscht')) then
      begin
        BeginHourGlass;
        for n := 0 to pred(ItemsMARKED.count) do
          e_w_AuftragDelete(Integer(ItemsMARKED[n]));
        RefreshCountAnzeige;
        InvalidateCache_Auftrag;
        DrawGrid1.refresh;
        EndHourGlass;
      end;
end;

procedure TFormAuftragArbeitsplatz.LoadContext;
var
  InpF: file;
  StrCount: Integer;
  n: Integer;

  function LoadInteger: Integer;
  begin
    if eof(InpF) then
      result := 0
    else
      BlockRead(InpF, result, sizeof(Integer));
  end;

  function LoadString: AnsiString;
  var
    len: Integer;
  begin
    result := '';
{$I-}
    BlockRead(InpF, len, sizeof(Integer));
{$I+}
    if (ioresult <> 0) then
      len := 0;
    SetLength(result, len);
    if (len > 0) then
      BlockRead(InpF, result[1], len);
  end;

begin
  BeginHourGlass;

  //
  if assigned(s_List) then
    FreeAndNil(s_List);

  /// ////////////////////////
  try
    assignFile(InpF, ContextFName(ContextReadPos));
    reset(InpF, 1);

    s_Baustelle := e_r_BaustelleRIDFromKuerzel(LoadString);
    ReflectBaustelleChange;
    ComboBox2.ItemIndex := ComboBox2.items.indexof(LoadString);
    ComboBox3.Text := LoadString;
    ComboBox4.Text := LoadString;
    ComboBox5.Text := LoadString;
    ComboBox6.Text := LoadString;
    Edit1.Text := LoadString;
    ToolButton31.Down := (LoadString = booltostr(true));
    CheckBox3.checked := (LoadString = booltostr(true));
    RadioButton1.checked := (LoadString = booltostr(true));
    RadioButton2.checked := (LoadString = booltostr(true));
    RadioButton3.checked := (LoadString = booltostr(true));

    ItemsGRID.LoadFromFile(InpF);
    DrawGrid1.rowCount := ItemsGRID.count;
    ItemsMARKED.LoadFromFile(InpF);
    ItemsQUERY.LoadFromFile(InpF);
    DrawGrid1.Row := LoadInteger;
    DrawGrid1.TopRow := LoadInteger;
    BlockRead(InpF, AuftragLastChangeRID, sizeof(Integer));
    BlockRead(InpF, StrCount, sizeof(Integer));
    AuftragLastChangeFields.clear;
    for n := 0 to pred(StrCount) do
      AuftragLastChangeFields.Add(LoadString);
    ToggleSortMode(TeTerminarbeitsplatzSortMode(LoadInteger));
    CloseFile(InpF);
  except
    on e: exception do
    begin
      CareTakerLog(cERRORText + ' Context.' + e.message);
    end;
  end;

  /// ////////////////////////
  HistorieAnzeigen := ToolButton31.Down;
  ComboBox2Change(self);
  ComboBox3Change(self);
  ComboBox6Change(self);
  SaveEdits;
  RefreshCountAnzeige;
  RefreshContextAnzeige;
  DrawGrid1.refresh;
  DrawGrid1.SetFocus;
  EndHourGlass;
end;

function TFormAuftragArbeitsplatz.SaveContext(InternalUse
  : boolean = false): boolean;
//
//
// * Read-Pointer                  * WritePointer
// ###-###-###-###-###-###-###-###-###-###-###
// <- zurück-Knopf
// -> vor-Knopf
//
//
//
// * eine Änderung nach dem Lesen eines alten Standes bewirkt
// -> Read-Pointer geht wieder nach vorne
// ->
//
var
  OutF: file;
  n: Integer;
  _NewFName: string;

  procedure SaveString(S: AnsiString);
  var
    len: Integer;
  begin
    len := length(S);
    BlockWrite(OutF, len, sizeof(Integer));
    if (len > 0) then
      BlockWrite(OutF, S[1], len);
  end;

begin
  result := false;
  if (ItemsGRID.count > 0) then
  begin
    BeginHourGlass;

    // Zähle den Pointer weiter
    try
      _NewFName := ContextFName(cContextCountMax + 1);
      assignFile(OutF, _NewFName);
      rewrite(OutF, 1);

      // Bildschirm
      for n := 0 to 11 do
        SaveString(s_Context[n]);

      // Interne Listen
      ItemsGRID.SaveToFile(OutF);
      ItemsMARKED.SaveToFile(OutF);
      ItemsQUERY.SaveToFile(OutF);
      BlockWrite(OutF, DrawGrid1.Row, sizeof(Integer));
      BlockWrite(OutF, DrawGrid1.TopRow, sizeof(Integer));
      //
      BlockWrite(OutF, AuftragLastChangeRID, sizeof(Integer));
      n := AuftragLastChangeFields.count;
      BlockWrite(OutF, n, sizeof(Integer));
      for n := 0 to pred(AuftragLastChangeFields.count) do
        SaveString(AuftragLastChangeFields[n]);
      BlockWrite(OutF, s_SortMode, sizeof(Integer));

      CloseFile(OutF);
    except
      on e: exception do
      begin
        CareTakerLog(cERRORText + ' Context.' + _NewFName + '.' + e.message);
      end;
    end;

    if not(InternalUse) then
      ContextReadPos := -1;

    // nur wenn was geändert wurde speichern
    if (ContextReadPos = -1) or
      not(FileCompare(_NewFName, ContextFName(ContextReadPos))) then
    begin
      CameraFlash;
      ContextWritePos := getContext(true);
      FileCopy(_NewFName, ContextFName(ContextWritePos));
      result := true;
      RefreshContextAnzeige;
    end;

    EndHourGlass;
  end;
end;

procedure TFormAuftragArbeitsplatz.CameraFlash;

begin
  ToolButton11.imageindex := 92;
  ShouldRefreshCameraIn := 500;
end;

procedure TFormAuftragArbeitsplatz.moveContextBack;
var
  WasSaved: boolean;
begin
  // back
  WasSaved := SaveContext(true);
  if (ContextReadPos = -1) then
  begin
    if WasSaved then
      ContextReadPos := ContextWritePos
    else
      ContextReadPos := getContextnext(ContextWritePos);
  end;

  if FileExists(ContextFName(getContextprev(ContextReadPos))) then
  begin
    BeginHourGlass;
    ContextReadPos := getContextprev(ContextReadPos);
    LoadContext;
    EndHourGlass;
  end
  else
  begin
    beep;
  end;
end;

procedure TFormAuftragArbeitsplatz.moveContextNext;
begin
  // next
  SaveContext(true);
  if (ContextReadPos <> -1) and (ContextReadPos <> ContextWritePos) then
    if FileExists(ContextFName(getContextnext(ContextReadPos))) then
    begin
      BeginHourGlass;
      ContextReadPos := getContextnext(ContextReadPos);
      LoadContext;
      EndHourGlass;
    end
    else
    begin
      beep;
    end;
end;

procedure TFormAuftragArbeitsplatz.ToolButton41Click(Sender: TObject);
begin
  moveContextBack;
end;

procedure TFormAuftragArbeitsplatz.ToolButton43Click(Sender: TObject);
begin
  moveContextNext;
end;

procedure TFormAuftragArbeitsplatz.ReflectBaustelleChange;
var
  cBAUSTELLE: TIB_Cursor;
begin

  //
  if (s_Baustelle <> -1) then
  begin

    // Titel-Texte und andere Sachen
    cBAUSTELLE := DataModuleDatenbank.nCursor;
    with cBAUSTELLE do
    begin
      sql.Add('select NUMMERN_PREFIX, SCHLAGZEILE, VON, BIS  from BAUSTELLE where RID='
        + inttostr(s_Baustelle));
      ApiFirst;
      FieldByName('SCHLAGZEILE').AssignTo(Memo1.lines);
      s_BaustelleStart := DateTime2long(FieldByName('VON').AsDate);
      s_BaustelleEnde := DateTime2long(FieldByName('BIS').AsDate);
      ComboBox1.Text := FieldByName('NUMMERN_PREFIX').AsString;
    end;
    cBAUSTELLE.free;

    // Monteur-Auswahl
    ComboBox3.items.assign(e_r_BaustelleMonteure(s_Baustelle));
    ComboBox3.items.insert(0, '*');
    ComboBox3.items.Add('ohne');

    // Anwendungs-Titel
    caption := 'Auftragarbeitsplatz - [' + ComboBox1.Text + '-' +
      e_r_BaustelleName(s_Baustelle) + ']';

  end
  else
  begin

    //
    Memo1.lines.clear;
    ComboBox3.items.assign(e_r_MonteureCache);
    ComboBox3.items.insert(0, '*');
    ComboBox3.items.Add('ohne');
    caption := 'Auftragarbeitsplatz';
  end;

end;

function TFormAuftragArbeitsplatz.ContextFName(Position: Integer): string;
begin
  result := ContextPath + inttostr(sBearbeiter) + '_' + inttostr(Position) +
    cContextExtension;
end;

procedure TFormAuftragArbeitsplatz.ShowAuftrag;
var
  r: TRect;
  Y: Integer;
begin
  if (ItemsGRID.count > 0) then
  begin
    r := DrawGrid1.CellRect(0, DrawGrid1.Row);
    Y := r.top + DrawGrid1.top + top + cPlanY + dpiX(21);
    if Y > screen.height - (FormAuftrag.height + dpiX(30)) then
      Y := Y - (FormAuftrag.height + cPlanY);
    FormAuftrag.left := FormAuftragArbeitsplatz.left + 3 + DrawGrid1.left;
    FormAuftrag.top := Y;
    FormAuftrag.setContext(Integer(ItemsGRID[DrawGrid1.Row]));
  end;
end;

procedure TFormAuftragArbeitsplatz.MarkAuftrag;
var
  RID: Integer;
  FoundIndex: Integer;
begin
  if (ItemsGRID.count > 0) then
  begin
    RID := Integer(ItemsGRID[DrawGrid1.Row]);
    FoundIndex := ItemsMARKED.indexof(pointer(RID));
    if (FoundIndex = -1) then
    begin
      ItemsMARKED.Add(pointer(RID));
      MarkSort;
    end
    else
      ItemsMARKED.Delete(FoundIndex);
    RefreshCountAnzeige;

    // redraw one line;
    if (DrawGrid1.Row < pred(DrawGrid1.rowCount)) then
      DrawGrid1.Row := DrawGrid1.Row + 1
    else
      DrawGrid1.refresh;
  end;
end;

procedure TFormAuftragArbeitsplatz.HistorischBeenden;
begin
  ToolButton31.Down := false;
  HistorieAnzeigen := false;
end;

procedure TFormAuftragArbeitsplatz.HistorischeFlash;
begin
  ShouldRefreshHistorischeIn := 1500;
  ToolButton31.imageindex := 95;
end;

procedure TFormAuftragArbeitsplatz.CheckBox1Click(Sender: TObject);
begin
  ToolButton1.Enabled := not(ComboBox7.ItemIndex = 0);
  ToolButton22.Enabled := not(ComboBox7.ItemIndex = 0);
end;

procedure TFormAuftragArbeitsplatz.ToolButton2Click(Sender: TObject);
var
  StartTime: dword;
  n: Integer;
begin
  ItemsMARKED.LogicalAND(ItemsGRID);
  if ItemsMARKED.count > 0 then
    if doit('Sollen wirklich ' + inttostr(ItemsMARKED.count) +
      ' Aufträge in die Ablage verschoben werden', true) then
      if not(doit('Aufträge in der Ablage sind im Moment NICHT abrufbar!' + #13
        + 'Erst in einer zukünftigen Programmversion können Sie im' + #13 +
        'Auftragarbeitsplatz abgerufen werden.' + #13 +
        'Wenn Sie jetzt <abbrechen> drücken wird in die Ablage verschoben'))
      then
      begin
        BeginHourGlass;
        e_w_gen('GEN_ZUSAMMENHANG');
        StartTime := 0;
        ProgressBar1.max := ItemsMARKED.count;
        for n := 0 to pred(ItemsMARKED.count) do
        begin
          e_w_AuftragAblage(Integer(ItemsMARKED[n]));
          if frequently(StartTime, 444) or (n = pred(ItemsMARKED.count)) then
          begin
            application.processmessages;
            ProgressBar1.Position := n;
          end;
        end;
        RefreshCountAnzeige;
        InvalidateCache_Auftrag;
        DrawGrid1.refresh;
        ProgressBar1.Position := 0;
        EndHourGlass;
      end;
end;

procedure TFormAuftragArbeitsplatz.StatusRckluferANAUS1Click(Sender: TObject);
begin
  if (ItemsGRID.count > 0) then
    ToggleStatusMode(Integer(ItemsGRID[DrawGrid1.Row]), cModeUnmoeglich);
end;

procedure TFormAuftragArbeitsplatz.Status1Click(Sender: TObject);
begin
  if (ItemsGRID.count > 0) then
    ToggleStatusMode(Integer(ItemsGRID[DrawGrid1.Row]), cModeRestant);
end;

procedure TFormAuftragArbeitsplatz.StatusNeuanschreibenANAUS1Click
  (Sender: TObject);
begin
  if (ItemsGRID.count > 0) then
    ToggleStatusMode(Integer(ItemsGRID[DrawGrid1.Row]), cModeNeuAnschreiben);
end;

procedure TFormAuftragArbeitsplatz.MarkImportedRID(IMPORT_R: Integer);
var
  qIMPORT_R: TIB_Cursor;
begin
  BeginHourGlass;
  qIMPORT_R := DataModuleDatenbank.nCursor;
  ItemsMARKED.clear;
  with qIMPORT_R do
  begin
    sql.Add('SELECT RID FROM AUFTRAG WHERE');
    sql.Add(' (RID_AT_IMPORT=' + inttostr(IMPORT_R) + ') AND');
    sql.Add(' (RID=MASTER_R)');
    open;
    EnsureHourGlass;
    ApiFirst;
    while not(eof) do
    begin
      ItemsMARKED.Add(TObject(FieldByName('RID').AsInteger));
      APInext;
    end;
    close;
  end;
  qIMPORT_R.free;
  InvalidateCache_Auftrag;
  DrawGrid1.refresh;
  RefreshCountAnzeige;
  EndHourGlass;
end;

procedure TFormAuftragArbeitsplatz.MarkProtokollValue(pName: string);
var
  cAUFTRAG: TIB_Cursor;
  n: Integer;
  TheIntern: TStringlist;
begin
  // Deprecated!!
  // Diese Funktion ist unter FormAuftragArbeitsplatz.Suche implementiert

  BeginHourGlass;
  SaveContext;
  ItemsMARKED.clear;
  TheIntern := TStringlist.create;
  cAUFTRAG := DataModuleDatenbank.nCursor;
  with cAUFTRAG do
  begin
    sql.Add('select PROTOKOLL from AUFTRAG where RID=:CROSSREF');
    for n := 0 to pred(ItemsGRID.count) do
    begin
      ParamByName('CROSSREF').AsInteger := Integer(ItemsGRID[n]);
      ApiFirst;
      FieldByName('PROTOKOLL').AssignTo(TheIntern);
      if TheIntern.values[pName] <> '' then
        ItemsMARKED.Add(ItemsGRID[n]);
    end;
  end;
  cAUFTRAG.free;
  TheIntern.free;
  InvalidateCache_Auftrag;
  DrawGrid1.refresh;
  RefreshCountAnzeige;
  EndHourGlass;
end;

procedure TFormAuftragArbeitsplatz.ToolButton3Click(Sender: TObject);
begin
  FormAuftragSuche.show;
end;

procedure TFormAuftragArbeitsplatz.FindNextMarked;
var
  m: Integer;
  NextFound: boolean;
begin
  BeginHourGlass;
  NextFound := false;
  for m := succ(DrawGrid1.Row) to pred(ItemsGRID.count) do
    if (ItemsMARKED.indexof(ItemsGRID[m]) <> -1) then
    begin
      DrawGrid1.Row := m;
      DrawGrid1.refresh;
      NextFound := true;
      break;
    end;
  if not(NextFound) then
    beep;
  EndHourGlass;
end;

procedure TFormAuftragArbeitsplatz.SwitchAuslastung;
const
  cHugeColumSize = 73;
begin
  with DrawGrid2 do
  begin
    if (ColCount = 6) then
    begin
      // enlarge
      if (Auslastung.Mode = 0) then
      begin
        Panel2.width := 266;
        ColCount := 8;
        ColWidths[0] := 46; // Monteur-Name
        ColWidths[1] := cTagX; // MO
        ColWidths[2] := ColWidths[1]; // DI
        ColWidths[3] := ColWidths[1]; // MI
        ColWidths[4] := ColWidths[1]; // DO
        ColWidths[5] := ColWidths[1]; // FR
        ColWidths[6] := ColWidths[1]; // SA
        ColWidths[7] := ColWidths[1]; // SO
      end
      else
      begin
        Panel2.width := 46 + cHugeColumSize * 7;
        ColCount := 8;
        ColWidths[0] := 46; // Monteur-Name
        ColWidths[1] := cHugeColumSize; // MO
        ColWidths[2] := ColWidths[1]; // DI
        ColWidths[3] := ColWidths[1]; // MI
        ColWidths[4] := ColWidths[1]; // DO
        ColWidths[5] := ColWidths[1]; // FR
        ColWidths[6] := ColWidths[1]; // SA
        ColWidths[7] := ColWidths[1]; // SO
      end;
      ToolButton22.imageindex := 73;
    end
    else
    begin
      // shrink
      Panel2.width := 202;
      ColCount := 6;
      ColWidths[0] := 46; // Monteur-Name
      ColWidths[1] := cTagX; // MO
      ColWidths[2] := ColWidths[1]; // DI
      ColWidths[3] := ColWidths[1]; // MI
      ColWidths[4] := ColWidths[1]; // DO
      ColWidths[5] := ColWidths[1]; // FR
      ToolButton22.imageindex := 74;
    end;
    Button6.left := Panel2.width - Button6.width;
    width := Panel2.width;
  end;
end;

procedure TFormAuftragArbeitsplatz.DrawGrid2KeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = '+') then
    SwitchAuslastung;
end;

procedure TFormAuftragArbeitsplatz.ToolButton36Click(Sender: TObject);
begin
  RefreshBaustellenAuslastung;
end;

procedure TFormAuftragArbeitsplatz.ToolButton37Click(Sender: TObject);
var // "V" Verschieben
  BAUSTELLE_R: Integer;
var // "R" Rückgängig
  rCONNECTION: TIB_Connection;
  rTRANSACTION: TIB_Transaction;
  cAUFTRAG: TIB_Cursor;
  qAUFTRAG: TIB_Query;
  StartTime: dword;
  RecN: Integer;

  //
  SourceTable: string;
  DestTable: string;
  ExceptionCount: Integer;
  Anz_Inserts: Integer;
  sDiagnose: TStringlist;

  procedure InsertData;
  var
    RID, n: Integer;
  begin
    StartTime := 0;
    RecN := 0;
    ExceptionCount := 0;

    cAUFTRAG := DataModuleDatenbank.nCursor;
    with cAUFTRAG do
    begin
      sql.Add('select * from ' + SourceTable);
      sql.Add('where RID in ' + ListasSQL(ItemsMARKED));
      ApiFirst;
      while not(eof) do
      begin
        //
        RID := FieldByName('RID').AsInteger;
        try
          qAUFTRAG.close;
          qAUFTRAG.ParamByName('CROSSREF').AsInteger := RID;
          qAUFTRAG.open;

          if qAUFTRAG.eof then
            raise exception.create('Ziel nicht gefunden!');

          if (cAUFTRAG.FieldByName('RID_AT_IMPORT').AsInteger <>
            qAUFTRAG.FieldByName('RID_AT_IMPORT').AsInteger) then
            raise exception.create
              ('Import-RID ist unterschiedlich, ev. Neuanlage?');

          qAUFTRAG.edit;
          for n := 0 to pred(FieldCount) do
            if Fields[n].IsNotNull then
              qAUFTRAG.FieldByName(Fields[n].FieldName).assign(Fields[n])
            else
              qAUFTRAG.FieldByName(Fields[n].FieldName).clear;

          qAUFTRAG.post;
          inc(Anz_Inserts);
        except
          on e: exception do
          begin
            inc(ExceptionCount);
            sDiagnose.Add(cERRORText + ' update(' + inttostr(RID) + '): ' +
              e.message);
          end;
        end;

        inc(RecN);
        next;
        if frequently(StartTime, 1000) or eof then
          application.processmessages;

      end;
      close;
    end;
    cAUFTRAG.free;
  end;

begin
  ItemsMARKED.LogicalAND(ItemsGRID);
  if (pos(':', Edit1.Text) > 0) and (pos('fdb', Edit1.Text) > 0) then
  begin

    BeginHourGlass;
    ExceptionCount := 0;
    sDiagnose := TStringlist.create;

    if false then
      SourceTable := 'ABLAGE'
    else
      SourceTable := 'AUFTRAG';

    if false then
      DestTable := 'ABLAGE'
    else
      DestTable := 'AUFTRAG';

    //
    rTRANSACTION := TIB_Transaction.create(self);
    with rTRANSACTION do
    begin
      AutoCommit := true;
      ServerAutoCommit := true;
      Isolation := tiCommitted;
      RecVersion := true;
      LockWait := true;
    end;

    //
    rCONNECTION := TIB_Connection.create(self);
    with rCONNECTION do
    begin
      DefaultTransaction := rTRANSACTION;
      Protocol := cpTCP_IP;
      DataBaseName := Edit1.Text;
      UserName := 'SYSDBA';
      password := deCrypt_Hex(iDataBase_SYSDBA_pwd);
      CacheStatementHandles := false;
      SQLDialect := 3;
      ParameterOrder := poNew;
    end;

    with rTRANSACTION do
    begin
      IB_connection := rCONNECTION;
    end;

    rCONNECTION.connect;

    if doit(inttostr(ItemsMARKED.count) +
      ' Datensätze, genau so wie hier angezeigt in die fremde Datenbank ' +
      #13#13 + Edit1.Text + #13#13 + ' schreiben', true) then
    begin
      qAUFTRAG := DataModuleDatenbank.nQuery;
      with qAUFTRAG do
      begin
        IB_connection := rCONNECTION;
        sql.Add('select * from ' + DestTable +
          ' where RID=:CROSSREF for update');
      end;
      Anz_Inserts := 0;
      InsertData;
      qAUFTRAG.close;
      qAUFTRAG.free;
    end;

    rCONNECTION.Disconnect;
    rTRANSACTION.free;
    rCONNECTION.free;

    sDiagnose.SaveToFile(DiagnosePath + 'Auftrag-Restore.txt');

    sDiagnose.free;
    EndHourGlass;

    ShowMessage(inttostr(Anz_Inserts) + ' Datensätze eingefügt!' + #13 +
      inttostr(ExceptionCount) + ' Fehler!');

    if (ExceptionCount > 0) then
      OpenShell(DiagnosePath + 'Auftrag-Restore.txt');

  end
  else
  begin

    //
    BAUSTELLE_R := e_r_BaustelleRIDFromKuerzel(AnsiUpperCase(ComboBox1.Text));

    //
    if doit('Sollen ' + inttostr(ItemsMARKED.count) + ' markierte wirklich ' +
      ' in die Baustelle ' + e_r_BaustelleKuerzel(BAUSTELLE_R) +
      ' verschoben werden') then
    begin
      BeginHourGlass;

      // Zunächst historischer Datensatz erzwingen!
      AuftragHistorischerDatensatz(ItemsMARKED);

      // nun verschieben!
      e_x_sql('update Auftrag set' + ' NUMMER = null,' + ' PLANQUADRAT = null,'
        + ' BAUSTELLE_R = ' + inttostr(BAUSTELLE_R) + ' ' + 'where ' +
        ' RID in ' + ListasSQL(ItemsMARKED));

      EndHourGlass;
    end;
  end;
end;

procedure TFormAuftragArbeitsplatz.RefreshBaustellenAuslastung;
var
  Baustellen: TStringlist;

  //
  n, k: Integer;
  cAUFWAND: TIB_Cursor;

  // Maximale Auslastung
  v_MonteurMontagAsDate: TDate;
  Col: Integer;
  _Datum: TANFiXDate;
  AUFWAND_C: Integer;

begin
  if (ComboBox7.ItemIndex = 0) then
    exit;

  BeginHourGlass;

  _Datum := v_MonteurMontag;
  if dateOK(_Datum) then
  begin

    Auslastung.clear;

    // Datum Berechnungen (Vorlauf)
    v_Kursiv_cell := WeekDay(_Datum);
    Label13.caption := 'KW' + inttostr(WeekGet(_Datum));
    while WeekDay(_Datum) <> 1 do
      _Datum := DatePlus(_Datum, -1);
    v_MonteurMontag := _Datum;
    v_MonteurSonntag := DatePlus(_Datum, 6);
    v_MonteurMontagAsDate := long2datetime(v_MonteurMontag);

    //
    Baustellen := e_r_Baustellen;

    // Auslastung aufbauen
    for n := 0 to pred(Baustellen.count) do
    begin

      // Zeile für diesen Monteur anlegen!
      Auslastung.Add(copy(Baustellen[n], 1, 5), Integer(Baustellen.objects[n]));
    end;

    cAUFWAND := DataModuleDatenbank.nCursor;
    with cAUFWAND do
    begin
      sql.Add('select');
      sql.Add(' AUSFUEHREN,');
      sql.Add(' VORMITTAGS,');
      sql.Add(' BAUSTELLE_R,');
      sql.Add(' STATUS,');
      sql.Add(' count(AUFWAND) AUFWAND_C');
      // sql.add(' sum(AUFWAND) AUFWAND_S');
      sql.Add('from AUFTRAG where');
      sql.Add(' (AUSFUEHREN between ' + '''' + Long2date(v_MonteurMontag) + ''''
        + ' and ' + '''' + Long2date(v_MonteurSonntag) + '''' + ') and');
      sql.Add(' (STATUS in (1,2,3,5,8))');
      sql.Add('group by');
      sql.Add(' BAUSTELLE_R, AUSFUEHREN, VORMITTAGS, STATUS');
      ApiFirst;
      while not(eof) do
      begin
        //
        //
        AUFWAND_C := FieldByName('AUFWAND_C').AsInteger * 2;
        Col := round(FieldByName('AUSFUEHREN').AsDate -
          v_MonteurMontagAsDate) * 2;
        if (FieldByName('VORMITTAGS').AsString = 'N') then
          inc(Col);
        k := Auslastung.indexof(FieldByName('BAUSTELLE_R').AsInteger);
        if (k <> -1) then
        begin
          with Auslastung[k][Col] do
          begin
            inc(AnzahlSoll, AUFWAND_C);
            case FieldByName('STATUS').AsInteger of
              ord(ctsErfolg), ord(ctsUnmoeglich):
                inc(AnzahlIst, AUFWAND_C);
            end;
          end;
        end;
        APInext;
      end;
    end;
    cAUFWAND.free;
    Baustellen.free;
  end;

  v_MonteurTag := v_MonteurMontag;
  Label14.caption := long2datetext(v_MonteurMontag) + ' ...';

  Auslastung.pack;

  EndHourGlass;
  Auslastung.Mode := 2;
  DrawGrid2.canvas.font.size := 8;
  DrawGrid2.rowCount := Auslastung.count;
  DrawGrid2.refresh;
end;

procedure TFormAuftragArbeitsplatz.DrawGrid2Click(Sender: TObject);
begin
  //
end;

procedure TFormAuftragArbeitsplatz.DrawGrid2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, Row: Integer;
begin
  DrawGrid2.MouseToCell(X, Y, Col, Row);
  if (Col > 0) then
  begin
    v_MonteurTag := DatePlus(v_MonteurMontag, pred(Col));
    v_Kursiv_cell := WeekDay(v_MonteurTag);
    Label14.caption := long2datetext(v_MonteurTag);
    DrawGrid2.refresh;
    DrawGrid2.SetFocus;
  end;
end;

procedure TFormAuftragArbeitsplatz.ToolButton48Click(Sender: TObject);
begin
  case Auslastung.Mode of
    0:
      begin
        ToolButton48.imageindex := 79;
        Auslastung.Mode := 1;
        DrawGrid2.canvas.font.size := 8;
        if (DrawGrid2.ColCount = 6) then
          SwitchAuslastung;
      end;
    1:
      begin
        ToolButton48.imageindex := 78;
        Auslastung.Mode := 0;
        DrawGrid2.canvas.font.size := 10;
      end;
    2:
      begin
        ToolButton48.imageindex := 78;
        Auslastung.Mode := 0;
        DrawGrid2.canvas.font.size := 10;
      end;
  end;
  DrawGrid2.refresh;
end;

procedure TFormAuftragArbeitsplatz.FuelleBaustellenCombo;
var
  AktiveBaustellen: TStringlist;
  n: Integer;
begin
  AktiveBaustellen := e_r_BaustellenAktive;
  ComboBox1.items.clear;
  ComboBox1.items.Add('*');
  for n := 0 to pred(AktiveBaustellen.count) do
    ComboBox1.items.Add(AktiveBaustellen[n]);
  AktiveBaustellen.free;
end;

procedure TFormAuftragArbeitsplatz.NotifyBaustelleChanged(Sender: TObject);
begin
  ComboBox1.items.clear;
end;

procedure TFormAuftragArbeitsplatz.NotifyMonteurChanged(Sender: TObject);
begin
  // noch nix sinnvolles
end;

function TFormAuftragArbeitsplatz.OutCSV(RID: Integer;
  s_Baustelle: Integer): string;
var
  RIDs: TgpIntegerList;
begin
  RIDs := TgpIntegerList.create;
  RIDs.Add(RID);
  result := OutCSV(RIDs, s_Baustelle);
  RIDs.free;
end;

function TFormAuftragArbeitsplatz.OutCSV(RIDs: TgpIntegerList;
  s_Baustelle: Integer): string;
var
  AllOutData: TStringlist;
  OneLine: string;
  n, k: Integer;
  AUFTRAG_R: Integer;
  StartTime: dword;
  SubItems: TStringlist;
  Protokoll: TStringlist;
  INTERN_INFO: TStringlist;
  ProtokollStr: string;

  ProtokollMode: boolean;
  ProtokollFelder: TStringlist;
  ProtokollOut: TStringlist;
  InternFelder: TStringlist;
  InternOut: TStringlist;

  Baustellen: TStringlist;

  // Für Excel
  xTable: TList;
  xSubs: TStringlist;
  xOneLine: string;
  xOptions: TStringlist;
  xFName: string;

  procedure xNewLine;
  begin
    xSubs := TStringlist.create;
    xTable.Add(xSubs);
  end;

begin
  result := '';
  //
  if (s_Baustelle = -1) then
  begin
    //
    if not(doit
      ('Der csv ist keine Baustelle zugeordnet. Erweiterte Protokollspalten werden fehlen.'
      + #13 + 'Die csv dennoch erzeugen')) then
      exit;
  end;

  xTable := TList.create;
  xOptions := TStringlist.create;
  Protokoll := TStringlist.create;
  ProtokollFelder := TStringlist.create;
  InternFelder := TStringlist.create;
  ProtokollOut := TStringlist.create;
  Baustellen := TStringlist.create;
  AllOutData := TStringlist.create;

  if (s_Baustelle <> -1) then
  begin
    e_r_ProtokollExport(s_Baustelle, ProtokollFelder);
    e_r_InternExport(s_Baustelle, InternFelder);
    ProtokollMode := (ProtokollFelder.count > 0);
  end
  else
  begin
    ProtokollMode := false;
  end;

  Baustellen.Add(e_r_BaustelleKuerzel(s_Baustelle));

  // Ausgabe
  BeginHourGlass;
  StartTime := 0;

  // Kopf Zeile für Excel
  xNewLine;
  xOneLine := cWordHeaderLine;
  while xOneLine <> '' do
    xSubs.Add(nextp(xOneLine, ';'));

  // Spalten Optionen für Excel
  with xOptions do
  begin
    Add('Datum=DATE');
    Add('KundeNummer=');
    Add('Monteur=');
    Add('Bemerkung=');
    Add('Art=');
    Add('Zaehler_Nummer=STRING');
    Add('Anschreiben_Name=');
    Add('Anschreiben_Strasse=');
    Add('Verbraucher_Ort=');
    Add('Verbraucher_Name=');
    Add('Verbraucher_Strasse=');
    Add('Anschreiben_Ort=');
    Add('Zeit=STRING');
    Add('Geaendert=DATETIME');
    Add('Auftrags_Nummer=');
    Add('Status1=');
    Add('Status2=');
    Add('WochentagKurz=');
    Add('Verbraucher_Name2=');
    Add('Anschreiben_Name2=');
    Add('WochentagLang=');
    Add('MonteurText=');
    Add('ZeitText=');
    Add('DatumText=');
    Add('Baustelle=');
    Add('Bearbeiter=');
    Add('Sperre=');
    Add('Planquadrat=');
    Add('ZaehlerInfo1=');
    Add('ZaehlerInfo2=');
    Add('ZaehlerInfo3=');
    Add('ZaehlerInfo4=');
    Add('ZaehlerInfo5=');
    Add('ZaehlerInfo6=');
    Add('ZaehlerInfo7=');
    Add('ZaehlerInfo8=');
    Add('ZaehlerInfo9=');
    Add('ZaehlerInfo10=');
    Add('Verbraucher_Ortsteil=');
    Add('ZaehlerNummerKorrektur=');
    Add('ZaehlerNummerNeu=');
    Add('ZaehlerStandAlt=');
    Add('ZaehlerStandNeu=');
    Add('Protokoll=');
    Add('WechselDatum=DATE');
    Add('WechselZeit=TIME');
    Add('ReglerNummerAlt=');
    Add('ReglerNummerKorrektur=');
    Add('ReglerNummerNeu=');
    Add('Verbaucher_Strasse_Teil1=');
    Add('Verbaucher_Strasse_Teil2=');
    Add('Verbaucher_Strasse_Teil3=');
    Add('WordEmpfaenger=');
    Add('ReferenzIdentitaet=ORDINAL');
    Add('WordAnzahl=');
    Add('OrtsteilCode=');
    Add('SperreKurz=');
    Add('MonteurHandy=');
    Add('InternInfo1=');
    Add('InternInfo2=');
    Add('InternInfo3=');
    Add('InternInfo4=');
    Add('InternInfo5=');
    Add('InternInfo6=');
    Add('InternInfo7=');
    Add('InternInfo8=');
    Add('InternInfo9=');
    Add('InternInfo10=');
    Add('V1=DATETIME');
    Add('V2=DATETIME');
    Add('V3=DATETIME');
  end;

  if ProtokollMode then
  begin
    xSubs.AddStrings(ProtokollFelder);
    xSubs.AddStrings(InternFelder);
    OneLine := cWordHeaderLine + ';' + HugeSingleLine(ProtokollFelder, ';');
    if (InternFelder.count > 0) then
      OneLine := OneLine + ';' + HugeSingleLine(InternFelder, ';');

    AllOutData.Add(OneLine);

  end
  else
  begin
    AllOutData.Add(cWordHeaderLine);
  end;
  ProgressBar1.max := RIDs.count;
  ProgressBar1.smooth := ProtokollMode;

  for n := 0 to pred(RIDs.count) do
  begin
    AUFTRAG_R := RIDs[n];

    //
    SubItems := e_r_AuftragItems(AUFTRAG_R);

    // gleich nach Excel ausgeben
    xSubs := TStringlist.create;
    xTable.Add(xSubs);
    xSubs.AddStrings(SubItems);
    xSubs.Add(''); // grrrr!

    //
    if (Baustellen.indexof(SubItems[twh_Baustelle]) = -1) then
      Baustellen.Add(SubItems[twh_Baustelle]);

    if ProtokollMode then
    begin

      // Protokoll laden
      ProtokollStr := SubItems[twh_Protokoll];
      Protokoll.clear;
      while (ProtokollStr <> '') do
        Protokoll.Add(nextp(ProtokollStr, cProtokollTrenner));
      SubItems[twh_Protokoll] := '';

      ProtokollOut.clear;
      for k := 0 to pred(ProtokollFelder.count) do
      begin
        ProtokollOut.Add
          (csvCheck(KommaCheck(Protokoll.values[ProtokollFelder[k]])));
      end;

      if (InternFelder.count > 0) then
      begin
        INTERN_INFO := e_r_sqlt('select INTERN_INFO from AUFTRAG where RID=' +
          inttostr(AUFTRAG_R));
        for k := 0 to pred(InternFelder.count) do
          ProtokollOut.Add
            (csvCheck(KommaCheck(INTERN_INFO.values[InternFelder[k]])));
        INTERN_INFO.free;
      end;

      xSubs.AddStrings(ProtokollOut);

      AllOutData.Add(WordDataFromRID(AUFTRAG_R) + ';' +
        HugeSingleLine(ProtokollOut, ';'));
    end
    else
    begin
      AllOutData.Add(WordDataFromRID(AUFTRAG_R));
    end;

    //
    if frequently(StartTime, 400) then
    begin
      ProgressBar1.Position := n;
      application.processmessages;
    end;

  end;

  //
  AllOutData.SaveToFile(MyProgramPath + FormBearbeiter.sBearbeiterKurz
    + '.csv');

  xFName := iBaustellenPath + Baustellen[0];
  CheckCreateDir(xFName);
  xFName := xFName + '\' + FormBearbeiter.sBearbeiterKurz + '.xls';
  ExcelExport(xFName, xTable, nil, xOptions);

  //
  if FileExists(iBaustellenPath + Baustellen[0] + '\Vorlage.xls') then
    doConversion(Content_Mode_xls2xls, iBaustellenPath + Baustellen[0] + '\' +
      FormBearbeiter.sBearbeiterKurz + '.xls');

  //
  CheckCreateOnce(WordPath);
  result := WordPath + inttostrN(e_w_gen('GEN_CSV'), 6) + '-' +
    FormBearbeiter.sBearbeiterKurz + '.csv';
  FileCopy(MyProgramPath + FormBearbeiter.sBearbeiterKurz + '.csv', result);

  FreeAndNil(AllOutData);
  FreeAndNil(ProtokollFelder);
  FreeAndNil(ProtokollOut);
  FreeAndNil(Protokoll);
  FreeAndNil(xTable);
  FreeAndNil(xOptions);
  FreeAndNil(InternFelder);
  FreeAndNil(InternOut);

  ProgressBar1.Position := 0;
  ProgressBar1.smooth := false;
  EndHourGlass;

  if (Baustellen.count > 1) then
    ShowMessage('Warnung: Es ist ein Mix aus mehreren Baustellen in der csv:' +
      #13 + HugeSingleLine(Baustellen) + #13 +
      'Sollte das nicht richtig sein, versuchen Sie bitte den Fehler nachzuvollziehen, und melden es an Andreas Filsinger.');
  FreeAndNil(Baustellen);

  // gleich das Excel öffnen
  // open(xFName);

end;

procedure TFormAuftragArbeitsplatz.ComboBox1Exit(Sender: TObject);
var
  NewValue: Integer;
begin
  NewValue := e_r_BaustelleRIDFromKuerzel(AnsiUpperCase(ComboBox1.Text));
  if (NewValue <> s_Baustelle) then
  begin
    s_Baustelle := NewValue;
    ReflectBaustelleChange;
  end;
end;

procedure TFormAuftragArbeitsplatz.StatusvorgezogenANAUS1Click(Sender: TObject);
begin
  if (ItemsGRID.count > 0) then
    ToggleStatusMode(Integer(ItemsGRID[DrawGrid1.Row]), cModeVorgezogen);
end;

procedure TFormAuftragArbeitsplatz.ToolButton49Click(Sender: TObject);
var
  UseMarked: boolean;
begin
  if (ItemsGRID.count > 0) then
  begin
    // Umfang festlegen
    UseMarked := false;
    ItemsMARKED.LogicalAND(ItemsGRID);
    if (ItemsMARKED.count > 0) then
      if doit('Es sind markierte Zeilen enthalten.' + #13 +
        'Drücken Sie <abbrechen>, um alle Datensätze in der Anzeige zu verwenden!'
        + #13 + 'Sollen nur ' + inttostr(ItemsMARKED.count) +
        ' markierte Datensätze verwendet werden') then
        UseMarked := true;
    if UseMarked then
      FormAnschriftOptimierung.setContext(ItemsMARKED)
    else
      FormAnschriftOptimierung.setContext(ItemsGRID);
  end;
end;

procedure TFormAuftragArbeitsplatz.MarkSort;
var
  ClientSorter: TgpIntegerObjectList;
  RestL: TExtendedList;
  n, k: Integer;
begin
  if (ItemsMARKED.count > 1) then
  begin
    RestL := TExtendedList.create;
    ClientSorter := TgpIntegerObjectList.create(false);
    for n := 0 to pred(ItemsMARKED.count) do
    begin
      k := ItemsGRID.indexof(ItemsMARKED[n]);
      if (k = -1) then
        RestL.Add(ItemsMARKED[n])
      else
        ClientSorter.AddObject(k, TObject(ItemsMARKED[n]));
    end;
    if (ClientSorter.count > 1) then
    begin
      ClientSorter.sort;
      ItemsMARKED.clear;
      for n := 0 to pred(ClientSorter.count) do
        ItemsMARKED.Add(ClientSorter.objects[n]);
      for n := 0 to pred(RestL.count) do
        ItemsMARKED.Add(RestL[n]);
    end;
    ClientSorter.free;
    RestL.free;
  end;
end;

procedure TFormAuftragArbeitsplatz.SpeedButton2Click(Sender: TObject);
begin
  //
  BeginHourGlass;
  ReCreateAktiveBaustellen;
  FuelleBaustellenCombo;
  EndHourGlass;
end;

procedure TFormAuftragArbeitsplatz.SpeedButton3Click(Sender: TObject);
var
  cAUFTRAG: TIB_Cursor;
  cLIST: TIB_Cursor;
  AUFTRAG_R: Integer;
  FoundL: TList;
  n: Integer;

  strasse: string;
  POSTLEITZAHL_R: Integer;
  BAUSTELLE_R: Integer;
begin
  if (ItemsGRID.count > 0) then
  begin

    BeginHourGlass;
    AUFTRAG_R := Integer(ItemsGRID[DrawGrid1.Row]);
    cAUFTRAG := DataModuleDatenbank.nCursor;
    cLIST := DataModuleDatenbank.nCursor;
    FoundL := TList.create;

    with cAUFTRAG do
    begin
      sql.Add('select' + ' KUNDE_STRASSE,BAUSTELLE_R,POSTLEITZAHL_R ' +
        'from AUFTRAG where RID=' + inttostr(AUFTRAG_R));
      ApiFirst;
      strasse := StrasseUnify(FieldByName('KUNDE_STRASSE').AsString);
      POSTLEITZAHL_R := FieldByName('POSTLEITZAHL_R').AsInteger;
      BAUSTELLE_R := FieldByName('BAUSTELLE_R').AsInteger;
    end;

    if (POSTLEITZAHL_R = 0) then
      ShowMessage
        ('FEHLER: Diese Baustelle ist scheinbar nicht geolokalisiert!');

    with cLIST do
    begin
      sql.Add('select RID,KUNDE_STRASSE from AUFTRAG where');
      sql.Add(' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') and');
      if (POSTLEITZAHL_R >= cRID_FirstValid) then
        sql.Add(' (POSTLEITZAHL_R=' + inttostr(POSTLEITZAHL_R) + ') and');
      sql.Add(' (STATUS<>' + inttostr(cs_Historisch) + ')');
      sql.Add('order by STRASSE');
      ApiFirst;
      while not(eof) do
      begin
        if (StrasseUnify(FieldByName('KUNDE_STRASSE').AsString) = strasse) then
          FoundL.Add(TObject(FieldByName('RID').AsInteger));
        APInext;
      end;
    end;
    cAUFTRAG.free;
    cLIST.free;

    if (FoundL.count > 1) then
    begin
      SaveCursorPosition;
      SaveContext;
      HistorischBeenden;
      ItemsGRID.assign(FoundL);

      ItemsGRID.clear;
      ItemsGRID.Capacity := FoundL.count;
      for n := 0 to pred(FoundL.count) do
        ItemsGRID.Add(FoundL[n]);
      DrawGrid1.rowCount := FoundL.count;

      RefreshCountAnzeige;
      RestoreCursorPosition;
      InvalidateCache_Auftrag;
      DrawGrid1.refresh;
      EndHourGlass;
    end
    else
    begin
      EndHourGlass;
      ShowMessage('Es ist nur ein Zähler in diesem Haus!');
    end;
  end;
end;

procedure TFormAuftragArbeitsplatz.SpeedButton13Click(Sender: TObject);
begin
  FormAuftragSuchindex.ReCreateTheIndex(s_Baustelle);
end;

procedure TFormAuftragArbeitsplatz.SpeedButton1Click(Sender: TObject);
var
  cAUFTRAG: TIB_Cursor;
  cLIST: TIB_Cursor;
  AUFTRAG_R: Integer;
  FoundL: TList;
  n: Integer;
begin
  if (ItemsGRID.count > 0) then
  begin
    AUFTRAG_R := Integer(ItemsGRID[DrawGrid1.Row]);
    cAUFTRAG := DataModuleDatenbank.nCursor;
    cLIST := DataModuleDatenbank.nCursor;
    FoundL := TList.create;

    cAUFTRAG.sql.Add
      ('select AUSFUEHREN, MONTEUR1_R, MONTEUR2_R from AUFTRAG where RID=' +
      inttostr(AUFTRAG_R));
    cAUFTRAG.ApiFirst;
    with cLIST do
    begin
      sql.Add('select RID from AUFTRAG where');
      sql.Add(' (MONTEUR1_R=' + cAUFTRAG.FieldByName('MONTEUR1_R').AsString
        + ') AND');
      if cAUFTRAG.FieldByName('MONTEUR2_R').IsNotNull then
        sql.Add(' (MONTEUR2_R=' + cAUFTRAG.FieldByName('MONTEUR2_R').AsString
          + ') AND');
      sql.Add(' (AUSFUEHREN=''' + Long2date(cAUFTRAG.FieldByName('AUSFUEHREN')
        .AsDate) + ''') AND');
      sql.Add(' (MASTER_R=RID)');
      sql.Add('ORDER BY STRASSE');
      ApiFirst;
      while not(eof) do
      begin
        FoundL.Add(TObject(FieldByName('RID').AsInteger));
        APInext;
      end;
    end;
    cAUFTRAG.free;
    cLIST.free;
    if (FoundL.count > 1) then
    begin
      SaveCursorPosition;
      SaveContext;
      HistorischBeenden;
      ItemsGRID.assign(FoundL);

      ItemsGRID.clear;
      ItemsGRID.Capacity := FoundL.count;
      for n := 0 to pred(FoundL.count) do
        ItemsGRID.Add(FoundL[n]);
      DrawGrid1.rowCount := FoundL.count;

      RefreshCountAnzeige;
      RestoreCursorPosition;
      InvalidateCache_Auftrag;
      DrawGrid1.refresh;
    end
    else
    begin
      ShowMessage('Schlimmer kann es gar nicht mehr werden!');
    end;
  end;
end;

procedure TFormAuftragArbeitsplatz.RefreshContextAnzeige;
var
  ContextDistance: Integer;
begin
  if (ContextReadPos = -1) then
  begin
    LabelRefreshDiag.caption := '*';
  end
  else
  begin
    //
    if (ContextReadPos <= ContextWritePos) then
      ContextDistance := ContextWritePos - ContextReadPos
    else
      ContextDistance := ContextWritePos + (cContextCountMax - ContextReadPos);

    //
    if (ContextDistance <> 0) then
      LabelRefreshDiag.caption := '-' + inttostr(ContextDistance)
    else
      LabelRefreshDiag.caption := '0';
  end;
end;

function TFormAuftragArbeitsplatz.getContext
  (Increment: boolean = false): Integer;
var
  TrnFile: TextFile;
  TrnLine: string;
begin
  // load
  assignFile(TrnFile, ContextPath + cContextCountFName);
  if not(FileExists(ContextPath + cContextCountFName)) then
  begin
    result := cContextFirst;
    rewrite(TrnFile);
    writeln(TrnFile, inttostr(result));
  end
  else
  begin
    reset(TrnFile);
    readln(TrnFile, TrnLine);

    //
    result := strtointdef(TrnLine, 0);
  end;

  if Increment then
  begin
    inc(result);
    if (result > cContextCountMax) then
      result := cContextFirst;
    rewrite(TrnFile);
    writeln(TrnFile, inttostr(result));
  end;
  CloseFile(TrnFile);
end;

function TFormAuftragArbeitsplatz.getContextnext(ActCounter: Integer): Integer;
begin
  if (ActCounter = cContextCountMax) then
    result := cContextFirst
  else
    result := succ(ActCounter);
end;

function TFormAuftragArbeitsplatz.getContextprev(ActCounter: Integer): Integer;
begin
  if (ActCounter = cContextFirst) then
    result := cContextCountMax
  else
    result := pred(ActCounter);
end;

procedure TFormAuftragArbeitsplatz.SaveEdits;
begin
  s_Context.clear;
  s_Context.Add(ComboBox1.Text);
  s_Context.Add(ComboBox2.Text);
  s_Context.Add(ComboBox3.Text);
  s_Context.Add(ComboBox4.Text);
  s_Context.Add(ComboBox5.Text);
  s_Context.Add(ComboBox6.Text);
  s_Context.Add(Edit1.Text);
  s_Context.Add(booltostr(ToolButton31.Down));
  s_Context.Add(booltostr(CheckBox3.checked));
  s_Context.Add(booltostr(RadioButton1.checked));
  s_Context.Add(booltostr(RadioButton2.checked));
  s_Context.Add(booltostr(RadioButton3.checked));
end;

procedure TFormAuftragArbeitsplatz.LabelRefreshDiagClick(Sender: TObject);
begin
  if doit('Verlauf löschen') then
  begin
    FileDelete(ContextPath + '*' + cContextExtension);
    ContextWritePos := getContext;
    ContextReadPos := -1;
    SaveEdits;
    RefreshContextAnzeige;
  end;
end;

procedure TFormAuftragArbeitsplatz.ToolButton11Click(Sender: TObject);
begin
  SaveContext;
end;

procedure TFormAuftragArbeitsplatz.ToolButton17Click(Sender: TObject);
begin
  if FileExists(ContextFName(ContextWritePos)) then
  begin
    BeginHourGlass;
    ContextReadPos := ContextWritePos;
    LoadContext;
    EndHourGlass;
  end
  else
  begin
    beep;
  end;
end;

procedure TFormAuftragArbeitsplatz.SpeedButton9Click(Sender: TObject);
var
  ImportL: TStringlist;
  n: Integer;
  RID: Integer;
  _RID: string;
  ErrorLogMode: boolean;
  TicketFname: string;
begin
  OpenDialog1.InitialDir := MyProgramPath;
  if OpenDialog1.execute then
  begin
    BeginHourGlass;
    SaveContext;
    TicketFname := OpenDialog1.FileName;
    ImportL := TStringlist.create;
    LoadFromFileCSV(false, ImportL, TicketFname);

    // ErrorMode?
    ErrorLogMode := false;
    for n := 0 to pred(ImportL.count) do
      if (pos('(RID=', ImportL[n]) > 0) then
      begin
        ErrorLogMode := true;
        break;
      end;

    // RIDs?

    ItemsGRID.clear;
    ItemsQUERY.clear;
    for n := 0 to pred(ImportL.count) do
    begin

      if ErrorLogMode then
        _RID := ExtractSegmentBetween(ImportL[n], '(RID=', ')')
      else
        _RID := StrFilter(nextp(ImportL[n], ';', 0), '0123456789');

      if (_RID <> '') then
      begin
        RID := strtointdef(_RID, -1);
        if (RID > 0) then
          if (ItemsGRID.indexof(pointer(RID)) = -1) or (RID = 1) then
          begin
            ItemsGRID.Add(pointer(RID));
            ItemsQUERY.Add(pointer(RID));
          end;
      end;
    end;
    ImportL.free;
    RefreshCountAnzeige;
    DrawGrid1.rowCount := ItemsGRID.count;
    InvalidateCache_Auftrag;
    DrawGrid1.refresh;
    EndHourGlass;
  end;
end;

procedure TFormAuftragArbeitsplatz.ToggleSortMode
  (NewMode: TeTerminarbeitsplatzSortMode; ForceChange: boolean = false);
begin
  if (s_SortMode <> NewMode) or ForceChange then
  begin
    SaveContext;
    s_SortMode := NewMode;
    MenuItem_normalSortierung.checked := (s_SortMode = csm_normalSortierung);
    MenuItem_PostSortierung.checked := (s_SortMode = csm_PostSortierung);
    MenuItem_PLZSortierung.checked := (s_SortMode = csm_PLZSortierung);
    MenuItem_ZeitSortierung.checked := (s_SortMode = csm_ZeitSortierung);
    MenuItem_ZaehlernummerSortierung.checked :=
      (s_SortMode = csm_ZaehlernummerSortierung);
    MenuItem_BriefadresseSortierung.checked :=
      (s_SortMode = csm_BriefadresseSortierung);
    MenuItem_ABNummerSortierung.checked :=
      (s_SortMode = csm_ABNummerSortierung);
    MenuItem_StatusSortierung.checked := (s_SortMode = csm_StatusSortierung);
    MenuItem_WechselDatumSortierung.checked :=
      (s_SortMode = csm_WechselSortierung);
  end;
end;

procedure TFormAuftragArbeitsplatz.MenuItem_PLZSortierungClick(Sender: TObject);
begin
  ToggleSortMode(csm_PLZSortierung);
  Suche;
end;

procedure TFormAuftragArbeitsplatz.MenuItem_PostSortierungClick
  (Sender: TObject);
begin
  ToggleSortMode(csm_PostSortierung);
  Suche;
end;

procedure TFormAuftragArbeitsplatz.MenuItem_ZeitSortierungClick
  (Sender: TObject);
begin
  ToggleSortMode(csm_ZeitSortierung);
  Suche;
end;

procedure TFormAuftragArbeitsplatz.MenuItem_ZaehlernummerSortierungClick
  (Sender: TObject);
begin
  ToggleSortMode(csm_ZaehlernummerSortierung);
  Suche;
end;

procedure TFormAuftragArbeitsplatz.MenuItem_normalSortierungClick
  (Sender: TObject);
begin
  ToggleSortMode(csm_normalSortierung);
  Suche;
end;

procedure TFormAuftragArbeitsplatz.MenuItem_ABNummerSortierungClick
  (Sender: TObject);
begin
  ToggleSortMode(csm_ABNummerSortierung);
  Suche;
end;

procedure TFormAuftragArbeitsplatz.MenuItem_BriefadresseSortierungClick
  (Sender: TObject);
begin
  ToggleSortMode(csm_BriefadresseSortierung);
  Suche;
end;

procedure TFormAuftragArbeitsplatz.MenuItem_StatusSortierungClick
  (Sender: TObject);
begin
  ToggleSortMode(csm_StatusSortierung);
  Suche;

end;

var
  LastRequestedBAUSTELLE_R: Integer = cRID_Unset;

procedure TFormAuftragArbeitsplatz.EnsureSchlageZeile(BAUSTELLE_R: Integer);
var
  cBAUSTELLE: TIB_Cursor;
begin
  if (LastRequestedBAUSTELLE_R <> BAUSTELLE_R) then
  begin
    if (BAUSTELLE_R > 0) then
    begin
      cBAUSTELLE := DataModuleDatenbank.nCursor;
      with cBAUSTELLE do
      begin
        sql.Add('select SCHLAGZEILE from BAUSTELLE where RID=' +
          inttostr(BAUSTELLE_R));
        ApiFirst;
        if not(eof) then
          if Fields[0].IsNotNull then
            Fields[0].AssignTo(Memo1.lines)
          else
            Memo1.lines.clear;
      end;
      cBAUSTELLE.free;
    end
    else
    begin
      Memo1.lines.clear;
    end;
    LastRequestedBAUSTELLE_R := BAUSTELLE_R;
  end;
end;

procedure TFormAuftragArbeitsplatz.ToolButton33Click(Sender: TObject);
var
  SingleRIDs: TgpIntegerList;
  n: Integer;
begin
  SingleRIDs := TgpIntegerList.create;
  for n := 0 to ItemsMARKED.count - 1 do
    SingleRIDs.Add(Integer(ItemsMARKED[n]));
  ProduceInfoBlatt(nil, nil, SingleRIDs);
  SingleRIDs.free;
end;

procedure TFormAuftragArbeitsplatz.Image2Click(Sender: TObject);
begin
  OpenShell(cHelpURL + 'Auftraege');
end;

procedure TFormAuftragArbeitsplatz.showMap(RID: Integer);
var
  cAUFTRAG: TIB_Cursor;
  p: TPoint2D;
begin
  BeginHourGlass;
  try

    // Koordinaten erfragen
    cAUFTRAG := DataModuleDatenbank.nCursor;
    with cAUFTRAG do
    begin
      sql.Add('select KUNDE_STRASSE, KUNDE_ORT from AUFTRAG where RID=' +
        inttostr(RID));
      ApiFirst;
      FormGeoLokalisierung.locate(FieldByName('KUNDE_STRASSE').AsString,
        FieldByName('KUNDE_ORT').AsString, FieldByName('KUNDE_ORTSTEIL')
        .AsString, p);
    end;
    cAUFTRAG.free;

    // Karte anzeigen
    FormGeoArbeitsplatz.showMap(p.X, p.Y);

  except
    beep;
  end;
  EndHourGlass;
end;

procedure TFormAuftragArbeitsplatz.ShowRIDs(RIDs: TgpIntegerList);
var
  n: Integer;
begin
  if (RIDs.count < 500) then
  begin

    //
    if not(visible) then
      show
    else
      BringToFront;

    //
    if assigned(s_List) then
      FreeAndNil(s_List);
    s_List := TgpIntegerList.create;
    for n := 0 to pred(RIDs.count) do
      s_List.Add(RIDs[n]);
    Suche;

  end
  else
  begin

    BeginHourGlass;
    if not(visible) then
      show
    else
      BringToFront;
    SaveContext;
    ItemsGRID.clear;
    ItemsQUERY.clear;
    for n := 0 to pred(RIDs.count) do
    begin
      ItemsGRID.Add(pointer(RIDs[n]));
      ItemsQUERY.Add(pointer(RIDs[n]));
    end;
    RefreshCountAnzeige;
    DrawGrid1.rowCount := ItemsGRID.count;
    InvalidateCache_Auftrag;
    DrawGrid1.refresh;
    EndHourGlass;
  end;
end;

procedure TFormAuftragArbeitsplatz.Image1Click(Sender: TObject);
var
  s_Baustelle: Integer;
begin
  s_Baustelle := e_r_BaustelleRIDFromKuerzel(AnsiUpperCase(ComboBox1.Text));
  if (s_Baustelle <> -1) then
    FormBaustelle.setContext(s_Baustelle);
end;

procedure TFormAuftragArbeitsplatz.ToolButton38MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  n: Integer;
begin
  if (Button = mbright) then
  begin
    ItemsMARKED.LogicalAND(ItemsGRID);
    if ItemsMARKED.count > 0 then
      if doit('Sollen wirklich ' + inttostr(ItemsMARKED.count) +
        ' Geolokalisierungen aufgehoben werden', true) then
      begin
        BeginHourGlass;
        for n := 0 to pred(ItemsMARKED.count) do
          DeleteGeo(Integer(ItemsMARKED[n]));
        RefreshCountAnzeige;
        InvalidateCache_Auftrag;
        DrawGrid1.refresh;
        EndHourGlass;
      end;
  end;
end;

procedure TFormAuftragArbeitsplatz.SortSQL(sql: Tstrings);
begin
  if (s_Status = ord(ctsHistorisch)) then
  begin
    sql.Add('ORDER BY GEAENDERT');
  end
  else
  begin
    // freie Sortierungen
    case s_SortMode of
      csm_PLZSortierung:
        sql.Add('ORDER BY KUNDE_ORT,KUNDE_ORTSTEIL');
      csm_PostSortierung:
        sql.Add('ORDER BY AUSFUEHREN, VORMITTAGS DESCENDING, KUNDE_ORT,KUNDE_ORTSTEIL,STRASSE');
      csm_ZeitSortierung:
        sql.Add('ORDER BY AUSFUEHREN, VORMITTAGS DESCENDING, STRASSE');
      csm_ZaehlernummerSortierung:
        sql.Add('ORDER BY ZAEHLER_NUMMER');
      csm_BriefadresseSortierung:
        sql.Add('ORDER BY BRIEF_NAME1, BRIEF_NAME2');
      csm_normalSortierung:
        sql.Add('ORDER BY STRASSE, NUMMER');
      csm_ABNummerSortierung:
        sql.Add('ORDER BY NUMMER NULLS FIRST');
      csm_StatusSortierung:
        sql.Add('order by STATUS, EXPORT_TAN, STRASSE, NUMMER');
      csm_WechselSortierung:
        sql.Add('order by ZAEHLER_WECHSEL, STRASSE, NUMMER');
    end;
  end;
end;

procedure TFormAuftragArbeitsplatz.SpeedButton4Click(Sender: TObject);
var
  ResultRIDs: TgpIntegerList;

  AUFTRAG_R: Integer;
  cAUFTRAG: TIB_Cursor;
  cLIST: TIB_Cursor;
begin
  if (ItemsGRID.count > 0) then
  begin
    // um welchen Datensatz geht es?!
    AUFTRAG_R := Integer(ItemsGRID[DrawGrid1.Row]);
    cAUFTRAG := DataModuleDatenbank.nCursor;
    cLIST := DataModuleDatenbank.nCursor;
    ResultRIDs := TgpIntegerList.create;
    cAUFTRAG.sql.Add('select BAUSTELLE_R,POSTLEITZAHL_R from AUFTRAG where RID='
      + inttostr(AUFTRAG_R));
    cAUFTRAG.ApiFirst;
    with cLIST do
    begin
      sql.Add('select RID from AUFTRAG where');
      sql.Add(' (POSTLEITZAHL_R=''' + cAUFTRAG.FieldByName('POSTLEITZAHL_R')
        .AsString + ''') AND');
      sql.Add(' (MASTER_R=RID) AND');
      sql.Add(' (BAUSTELLE_R=' + cAUFTRAG.FieldByName('BAUSTELLE_R')
        .AsString + ')');
      ApiFirst;
      while not(eof) do
      begin
        ResultRIDs.Add(FieldByName('RID').AsInteger);
        APInext;
      end;
    end;
    cAUFTRAG.free;
    cLIST.free;
    ShowRIDs(ResultRIDs);
    ResultRIDs.free;
  end;
end;

procedure TFormAuftragArbeitsplatz.SpeedButton5Click(Sender: TObject);
var
  n: Integer;
  sl: TStringlist;
  RID: Integer;
begin
  BeginHourGlass;
  SaveContext;
  ItemsGRID.clear;
  ItemsQUERY.clear;
  InvalidateCache_ProblemInfos;
  RefreshProblemInfos;
  for n := 0 to pred(ProblemInfos.count) do
  begin

    // nun alle ohne OKs rausnehmen ...
    sl := TStringlist(ProblemInfos.objects[n]);
    if (sl.indexof(cOKText) <> -1) then
      continue;

    // Zur Anzeige-Liste hinzunehmen!
    RID := ProblemInfos[n];

    if (ItemsGRID.indexof(pointer(RID)) = -1) or (RID = 1) then
    begin
      ItemsGRID.Add(pointer(RID));
      ItemsQUERY.Add(pointer(RID));
    end;

  end;

  RefreshCountAnzeige;
  //
  DrawGrid1.rowCount := ItemsGRID.count;
  InvalidateCache_Auftrag;
  DrawGrid1.refresh;
  EndHourGlass;

end;

function TFormAuftragArbeitsplatz.AsHTML(AUFTRAG_R,
  BAUSTELLE_R: Integer): string;
var
  CSVFName: string;
  HTMLFName: string;
  sCSV: TStringlist;
  HTMLVorlageFName: string;
  sMonteurInfo: THTMLTemplate;
  DatensammlerGlobal, DatensammlerLokal: TStringlist;
  csvHeader, csvData: string;
begin
  result := '';
  if (BAUSTELLE_R < cRID_FirstValid) then
    BAUSTELLE_R := e_r_sql('select BAUSTELLE_R from AUFTRAG where RID=' +
      inttostr(AUFTRAG_R));

  if (AUFTRAG_R < cRID_FirstValid) or (BAUSTELLE_R < cRID_FirstValid) then
    exit;

  sCSV := TStringlist.create;
  DatensammlerGlobal := TStringlist.create;
  DatensammlerLokal := TStringlist.create;
  sMonteurInfo := THTMLTemplate.create;

  // CSV-Ausgabe erstellen!
  CSVFName := FormAuftragArbeitsplatz.OutCSV(AUFTRAG_R, BAUSTELLE_R);
  sCSV.LoadFromFile(CSVFName);

  // html-Vorlage laden!
  repeat
    HTMLVorlageFName := HtmlVorlagenPath + 'Auftrag-' +
      e_r_BaustelleKuerzel(BAUSTELLE_R) + '.html';
    if FileExists(HTMLVorlageFName) then
    begin
      sMonteurInfo.LoadFromFile(HTMLVorlageFName);
      break;
    end;
    HTMLVorlageFName := HtmlVorlagenPath + 'Auftrag' + '.html';
    sMonteurInfo.LoadFromFile(HTMLVorlageFName);
  until true;

  DatensammlerGlobal.Add('save&delete AUFTRAG');
  DatensammlerGlobal.Add('Titel=');
  DatensammlerGlobal.Add('Datum=' + long2dateLocalized(DateGet));
  DatensammlerGlobal.Add('AktuellesDatum=' + DatumLocalized);
  DatensammlerGlobal.Add('AktuelleUhrzeit=' + Uhr);

  csvHeader := sCSV[0];
  csvData := sCSV[1];
  DatensammlerLokal.Add('load AUFTRAG');
  while (csvHeader <> '') do
    DatensammlerLokal.Add(nextp(csvHeader, ';') + '=' + nextp(csvData, ';'));
  DatensammlerLokal.Add('pagebreak');

  sMonteurInfo.WriteValue(DatensammlerLokal, DatensammlerGlobal);
  HTMLFName := WordPath + inttostrN(e_r_gen('GEN_CSV'), 6) + '-' +
    FormBearbeiter.sBearbeiterKurz + '.html';
  sMonteurInfo.SaveToFileCompressed(HTMLFName);

  DatensammlerGlobal.free;
  DatensammlerLokal.free;
  sMonteurInfo.free;
  result := HTMLFName;

end;

function TFormAuftragArbeitsplatz.AsHTML(lAUFTRAG: TgpIntegerList): string;
var
  CSVFName: string;
  HTMLFName: string;
  sCSV: TStringlist;
  HTMLVorlageFName: string;
  sMonteurInfo: THTMLTemplate;
  DatensammlerGlobal, DatensammlerLokal: TStringlist;
  csvHeader, csvData: string;
  BAUSTELLE_R: Integer;
  n: Integer;
begin

  result := '';
  BAUSTELLE_R := e_r_sql('select BAUSTELLE_R from AUFTRAG where RID=' +
    inttostr(lAUFTRAG[0]));

  sCSV := TStringlist.create;
  DatensammlerGlobal := TStringlist.create;
  DatensammlerLokal := TStringlist.create;
  sMonteurInfo := THTMLTemplate.create;

  // CSV-Ausgabe erstellen!
  CSVFName := FormAuftragArbeitsplatz.OutCSV(lAUFTRAG, BAUSTELLE_R);
  sCSV.LoadFromFile(CSVFName);

  // html-Vorlage laden!
  repeat
    HTMLVorlageFName := HtmlVorlagenPath + 'Auftrag-' +
      e_r_BaustelleKuerzel(BAUSTELLE_R) + '_n.html';
    if FileExists(HTMLVorlageFName) then
    begin
      sMonteurInfo.LoadFromFile(HTMLVorlageFName);
      break;
    end;
    HTMLVorlageFName := HtmlVorlagenPath + 'Auftrag' + '_n.html';
    sMonteurInfo.LoadFromFile(HTMLVorlageFName);
  until true;

  DatensammlerGlobal.Add('Titel=');
  DatensammlerGlobal.Add('Datum=' + long2dateLocalized(DateGet));
  DatensammlerGlobal.Add('AktuellesDatum=' + DatumLocalized);
  DatensammlerGlobal.Add('AktuelleUhrzeit=' + Uhr);

  for n := 1 to pred(sCSV.count) do
  begin
    csvHeader := sCSV[0];
    csvData := sCSV[n];
    while (csvHeader <> '') do
      DatensammlerLokal.Add(nextp(csvHeader, ';') + '=' + nextp(csvData, ';'));
    DatensammlerLokal.Add(cPageBreakHerePossible);
  end;
  sMonteurInfo.WriteValue(DatensammlerLokal, DatensammlerGlobal);
  HTMLFName := WordPath + inttostrN(e_r_gen('GEN_CSV'), 6) + '-' +
    FormBearbeiter.sBearbeiterKurz + '.html';
  sMonteurInfo.SaveToFileCompressed(HTMLFName);

  DatensammlerGlobal.free;
  DatensammlerLokal.free;
  sMonteurInfo.free;
  result := HTMLFName;
end;

end.
