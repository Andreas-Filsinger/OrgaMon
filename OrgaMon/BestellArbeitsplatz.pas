{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2017  Andreas Filsinger
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
unit BestellArbeitsplatz;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  System.ImageList, Grids, StdCtrls,
  ComCtrls, ToolWin, ImgList,
  ExtCtrls, Mask, JvGIF,
  // IBO
  IB_UpdateBar, IB_Grid,
  IB_Components, IB_Access,
  IB_EditButton, IB_Controls,
  // OrgaMon
  BBelege;

type
  TFormBestellArbeitsplatz = class(TForm)
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton9: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    ToolButton33: TToolButton;
    ToolButton27: TToolButton;
    ToolButton19: TToolButton;
    IB_QueryBV4: TIB_Query;
    IB_QueryBV3: TIB_Query;
    IB_QueryBV2: TIB_Query;
    ToolButton10: TToolButton;
    IB_QueryWE1: TIB_Query;
    IB_QueryWE2: TIB_Query;
    IB_QueryWE3: TIB_Query;
    ToolButton18: TToolButton;
    StatusBar1: TStatusBar;
    IB_QueryLI1: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    IB_QueryBV1: TIB_Query;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label9: TLabel;
    Label10: TLabel;
    Edit2: TEdit;
    Button4: TButton;
    Edit4: TEdit;
    IB_Query5: TIB_Query;
    IB_Query6: TIB_Query;
    Button3: TButton;
    Button5: TButton;
    ToolButton30: TToolButton;
    IB_Query2: TIB_Query;
    IB_UpdateBar1: TIB_UpdateBar;
    ToolButton34: TToolButton;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Label8: TLabel;
    Edit3: TEdit;
    Button1: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label11: TLabel;
    Button2: TButton;
    Edit1: TEdit;
    ToolButton35: TToolButton;
    IB_QueryLA1: TIB_Query;
    IB_DataSource3: TIB_DataSource;
    Button6: TButton;
    ToolButton4: TToolButton;
    Edit5: TEdit;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    IB_DataSource4: TIB_DataSource;
    IB_Query3: TIB_Query;
    IB_Query4: TIB_Query;
    IB_DataSource5: TIB_DataSource;
    ToolButton13: TToolButton;
    Button10: TButton;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    Button11: TButton;
    Label7: TLabel;
    Label12: TLabel;
    IB_DataSource6: TIB_DataSource;
    IB_Edit1: TIB_Edit;
    IB_Edit2: TIB_Edit;
    IB_Edit3: TIB_Edit;
    IB_Edit4: TIB_Edit;
    IB_Edit5: TIB_Edit;
    IB_Edit6: TIB_Edit;
    Label5: TLabel;
    Label6: TLabel;
    Label13: TLabel;
    StaticText1: TStaticText;
    Label4: TLabel;
    StaticText2: TStaticText;
    CheckBox4: TCheckBox;
    IB_QueryWELager: TIB_Query;
    IB_QueryWEVersand: TIB_Query;
    IB_DataSourceWELager: TIB_DataSource;
    IB_DataSourceWEVersand: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    ToolButton28: TToolButton;
    ToolButton29: TToolButton;
    ToolButton31: TToolButton;
    ToolButton32: TToolButton;
    Image2: TImage;
    ToolButton5: TToolButton;
    Button12: TButton;
    IB_UpdateBar2: TIB_UpdateBar;
    IB_QueryBV5: TIB_Query;
    procedure FormActivate(Sender: TObject);
    procedure ToolButton27Click(Sender: TObject);
    procedure ToolButton20Click(Sender: TObject);
    procedure ToolButton21Click(Sender: TObject);
    procedure ToolButton22Click(Sender: TObject);
    procedure ToolButton23Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure Button4Click(Sender: TObject);
    procedure IB_Grid1DblClick(Sender: TObject);
    procedure IB_Grid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure IB_Query1AfterPrepare(Sender: TIB_Statement);
    procedure Button1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ToolButton36Click(Sender: TObject);
    procedure ToolButton35Click(Sender: TObject);
    procedure ToolButton16Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure IB_Query3AfterScroll(IB_Dataset: TIB_Dataset);
    procedure ToolButton13Click(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure ToolButton15Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton33Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure ToolButton17Click(Sender: TObject);
    procedure IB_QueryWE1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure IB_QueryWELagerAfterScroll(IB_Dataset: TIB_Dataset);
    procedure IB_QueryWEVersandAfterScroll(IB_Dataset: TIB_Dataset);
    procedure ToolButton29Click(Sender: TObject);
    procedure ToolButton32Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure IB_Grid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private

    { Private-Deklarationen }
    _Wareneingang_RID: Integer;
    SQLAtStart: TStringList;

    procedure ShowMoreInfo;

    { Public-Deklarationen }
    procedure ErzeugeVorschlag(SilentMode: boolean);
    procedure WarenEingangDiagnose;
    procedure RefreshView;

    { }
    procedure SetVorschlagView;
    procedure SetWareneingangView;
    procedure SetUebergangsfachView;
    procedure SetBelegeView;
    procedure SetAgentView;
    procedure SetWELagerView;
    procedure SetWEVersandView;

  public

    procedure SetContext(ARTIKEL_R: Integer);
    procedure MobilExport;

  end;

var
  FormBestellArbeitsplatz: TFormBestellArbeitsplatz;

implementation

uses
  anfix32, ArtikelVerlag, globals,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  Lager, Artikel, gplists,
  Belege, Person,
  WarenBewegung, html, FolgeSetzen,
  CareTakerClient, ArtikelBackOrder, OLAP,
  Datenbank, wanfix32, dbOrgaMon;

{$R *.dfm}
// Fest programmierte Spalten

const
  cLAGER_row = 2;
  cMINDEST_row = 3;
  cZUSAGE_row = 4;
  cAUSGABEART_R_row = 5;
  cMOTIVATION_row = 18;
  cARTIKEL_R_row = 20;
  cBELEG_R_row = 21;

type
  TBedarf = class(TObject)

    // Artikel-Identifikation
    RID: Integer;
    AUSGABEART_R: Integer;

    // Artikel-Zusatzdaten
    titel: string;
    numero: string;
    Menge_Lager: Integer;
    Menge_mindest: Integer;
    verlagno: string;
    Verlag_r: Integer;

    // Berechnete Mengen
    Menge_erwartet: Integer; // sind unterwegs
    Menge_unbestellt: Integer; // sind unbestellt aber es besteht im Bedarf
    Menge_agent: Integer; // errechneter Bedarf aus Kundenaufträgen

    Menge_fehlt: Integer; // errechnete Vorschlagsmenge
  end;

const
  cOrderDiagFName = 'Ordervorschlag-';
  cOrderDiagExtension = '.txt';

procedure TFormBestellArbeitsplatz.ErzeugeVorschlag(SilentMode: boolean);
var
  BedarfsAnalyse: TList;
  BA: TBedarf;
  n: Integer;
  OutList: TStringList;
  Last_verlag_r: Integer;
  TAN: Integer;

  function BA_locate(pAUSGABEART_R, pARTIKEL_R: Integer): TBedarf;
  var
    Newbedarf: TBedarf;
    n: Integer;
  begin
    result := nil;
    for n := 0 to pred(BedarfsAnalyse.count) do
      with TBedarf(BedarfsAnalyse[n]) do
      begin
        if (pARTIKEL_R = RID) and (pAUSGABEART_R = AUSGABEART_R) then
        begin
          result := TBedarf(BedarfsAnalyse[n]);
          break;
        end;
      end;
    if not(assigned(result)) then
    begin
      with IB_QueryBV2 do
      begin
        ParamByName('CROSSREF').AsInteger := pARTIKEL_R;
        if not(Active) then
          Open;

        // Neueintrag
        Newbedarf := TBedarf.create;
        BedarfsAnalyse.add(Newbedarf);
        with Newbedarf do
        begin

          RID := pARTIKEL_R;
          AUSGABEART_R := pAUSGABEART_R;

          Verlag_r := FieldByName('VERLAG_R').AsInteger;
          titel := FieldByName('TITEL').AsString;
          numero := FieldByName('NUMERO').AsString;
          verlagno := FieldByName('VERLAGNO').AsString;
          if (pAUSGABEART_R<cRID_Firstvalid) then
          begin
           Menge_Lager := FieldByName('MENGE').AsInteger;
           Menge_mindest := FieldByName('MINDESTBESTAND').AsInteger;
          end else
          begin
           Menge_Lager := e_r_Menge(cRID_NULL, pAUSGABEART_R, pARTIKEL_R);
           Menge_mindest := e_r_MindestMenge(pAUSGABEART_R, pARTIKEL_R);
          end;
        end;
      end;
      result := Newbedarf;
    end;
  end;

  procedure BA_sort;
  var
    sorted: boolean;
    n: Integer;
  begin
    repeat
      sorted := true;
      for n := 0 to BedarfsAnalyse.count - 2 do
        if TBedarf(BedarfsAnalyse[n]).Verlag_r > TBedarf(BedarfsAnalyse[n + 1]).Verlag_r
        then
        begin
          BedarfsAnalyse.Exchange(n, n + 1);
          sorted := false;
        end;
    until sorted;
  end;

begin
  BeginHourGlass;
  TAN := e_w_GEN('GEN_ZUSAMMENHANG');
  OutList := TStringList.create;
  BedarfsAnalyse := TList.create;

  // Bedarf aus dem Auftrags-System ermitteln (MENGE_AGENT)
  with IB_QueryBV1 do
  begin
    Open;
    while not(eof) do
    begin
      BA := BA_locate(
        {} FieldByName('AUSGABEART_R').AsInteger,
        {} FieldByName('ARTIKEL_R').AsInteger);
      BA.Menge_agent := FieldByName('C_ME_AG').AsInteger;
      next;
    end;
    Close;
  end;

  // Nun alle Artikel, die den Mindestbestand unterschreiten aufnehmen!
  // Es mag sein, dass diese durch erwartete Mengen wieder rausfliegen!
  // HAUPTARTIKEL
  with IB_QueryBV4 do
  begin
    Open;
    while not(eof) do
    begin
      BA := BA_locate(
       {} cAUSGABEART_OHNE,
       {} FieldByName('RID').AsInteger);
      next;
    end;
    Close;
  end;

  // Mit Ausgabeart
  with IB_QueryBV5 do
  begin
    Open;
    while not(eof) do
    begin
      BA := BA_locate(
       {} FieldByName('AUSGABEART_R').AsInteger,
       {} FieldByName('ARTIKEL_R').AsInteger);
      next;
    end;
    Close;
  end;

  // Nun alle "offenen" Order aufzeigen und Berechnungswerte ergänzen
  with IB_QueryBV3 do
  begin
    Open;
    while not(eof) do
    begin
      BA := BA_locate(
        {} FieldByName('AUSGABEART_R').AsInteger,
        {} FieldByName('ARTIKEL_R').AsInteger);
      with BA do
      begin
        Menge_erwartet := Menge_erwartet + FieldByName('C_ME_ER').AsInteger;
        Menge_unbestellt := Menge_unbestellt + FieldByName('C_ME_UN').AsInteger;
      end;
      next;
    end;
    Close;
  end;

  BA_sort;
  Last_verlag_r := -1;

  // "offline" Berechnung
  for n := 0 to pred(BedarfsAnalyse.count) do
  begin
    BA := TBedarf(BedarfsAnalyse[n]);
    with BA do
    begin

      // Weltformel
      Menge_fehlt := (Menge_mindest + Menge_agent) -
        (Menge_Lager + Menge_erwartet + Menge_unbestellt);

      //
      if (Last_verlag_r <> Verlag_r) then
      begin
        OutList.add(e_r_Verlag_PERSON_R(Verlag_r) + ':');
        Last_verlag_r := Verlag_r;
      end;

      if (Menge_fehlt > 0) then
      begin
        e_w_MehrBedarfsAnzeige(
         {} AUSGABEART_R,
         {} RID,
         {} cRID_Null,
         {} Menge_fehlt,
         {} eT_MotivationMindestbestand);
      end;

      OutList.add(format('%2dx LAG=%2d MIN=%2d UNB=%2d ERW=%2d AGE=%2d %s',

        [Menge_fehlt, Menge_Lager, Menge_mindest, Menge_unbestellt, Menge_erwartet,
        Menge_agent, ' ' + numero + '.' + IntToStr(AUSGABEART_R) + ' ' + '[' +
        verlagno + '] ' + titel])

        );
    end;
  end;
  OutList.SaveToFile(DiagnosePath + cOrderDiagFName + inttostrN(TAN, 8)
    + '.txt');
  for n := 0 to pred(BedarfsAnalyse.count) do
    TBedarf(BedarfsAnalyse[n]).free;
  BedarfsAnalyse.free;
  EndHourGlass;
  if not(SilentMode) then
  begin
    if (OutList.count = 0) then
      ShowMessage('Ich habe keine neuen Vorschläge!');
  end;
  OutList.free;
end;

procedure TFormBestellArbeitsplatz.FormActivate(Sender: TObject);
begin
  if not(IB_Query1.Active) then
  begin
    IB_Query1.Open;
    IB_Query2.Open;
    SetVorschlagView;
  end
  else
  begin
    RefreshView;
  end;
end;

procedure TFormBestellArbeitsplatz.ToolButton27Click(Sender: TObject);
begin
  RefreshView;
end;

procedure TFormBestellArbeitsplatz.WarenEingangDiagnose;
begin
  if (_Wareneingang_RID > 0) then
    openShell(DiagnosePath + 'Wareneingang ' + IntToStr(_Wareneingang_RID)
      + '.txt');
end;

procedure TFormBestellArbeitsplatz.ToolButton20Click(Sender: TObject);
begin
  BeginHourGlass;
  ErzeugeVorschlag(false);
  IB_Grid1.datasource.Dataset.RefreshAll;
  EndHourGlass;
end;

procedure TFormBestellArbeitsplatz.RefreshView;
begin
  BeginHourGlass;
  IB_Grid1.datasource.Dataset.Refresh;
  ShowMoreInfo;
  EndHourGlass;
end;

procedure TFormBestellArbeitsplatz.ToolButton21Click(Sender: TObject);
begin
  // WE "Lager"
  SetWELagerView;
end;

procedure TFormBestellArbeitsplatz.SetUebergangsfachView;
begin
  BeginHourGlass;
  with IB_DataSource3.Dataset do
  begin
    if not(Active) then
      Open;
  end;
  IB_Grid1.datasource := IB_DataSource3;
  IB_UpdateBar1.datasource := IB_DataSource3;
  ShowMoreInfo;
  EndHourGlass;
end;

procedure TFormBestellArbeitsplatz.SetVorschlagView;
begin
  BeginHourGlass;
  with IB_DataSource1.Dataset do
  begin
    Close;
    sql.clear;
    sql.AddStrings(SQLAtStart);
    Open;
  end;
  IB_Grid1.Color := $E0FFE0;
  IB_Grid1.canvas.Brush.Color := IB_Grid1.Color;
  IB_Grid1.datasource := IB_DataSource1;
  IB_UpdateBar1.datasource := IB_DataSource1;
  ShowMoreInfo;
  EndHourGlass;
end;

procedure TFormBestellArbeitsplatz.SetWareneingangView;
begin
  BeginHourGlass;
  with IB_DataSource2.Dataset do
  begin
    if not(Active) then
      Open
    else
      Refresh;
  end;
  IB_Grid1.Color := $E0E0FF;
  IB_Grid1.canvas.Brush.Color := IB_Grid1.Color;
  IB_Grid1.datasource := IB_DataSource2;
  IB_UpdateBar1.datasource := IB_DataSource2;
  ShowMoreInfo;
  EndHourGlass;
end;

procedure TFormBestellArbeitsplatz.ToolButton22Click(Sender: TObject);
begin
  SetWareneingangView;
end;

procedure TFormBestellArbeitsplatz.ToolButton23Click(Sender: TObject);
begin
  SetVorschlagView;
end;

procedure TFormBestellArbeitsplatz.ToolButton9Click(Sender: TObject);
var
  PERSON_R: Integer;
begin
  BeginHourGlass;
  with IB_QueryLI1 do
  begin
    Open;
    while not(eof) do
    begin
      PERSON_R := e_r_Lieferant(FieldByName('ARTIKEL_R').AsInteger, 0);
      if (PERSON_R > 0) then
      begin
        edit;
        FieldByName('LIEFERANT_R').AsInteger := PERSON_R;
        post;
      end;
      next;
    end;
    Close;
  end;
  RefreshView;
  EndHourGlass;
end;

procedure TFormBestellArbeitsplatz.FormCreate(Sender: TObject);
begin
  SQLAtStart := TStringList.create;
  SQLAtStart.AddStrings(IB_Query1.sql);
  with ToolBar1 do
  begin
    ButtonHeight := height - 2;
    ButtonWidth := dpiX(23);
  end;
end;

procedure TFormBestellArbeitsplatz.Button2Click(Sender: TObject);
var
  ZUSAMMENHANG: Integer;
  ARTIKEL_R: Integer;
  AUSGABEART_R: Integer;
  BuchenOK: boolean;
begin
  Button2.enabled := false;
  BeginHourGlass;
  ARTIKEL_R := IB_Grid1.datasource.Dataset.FieldByName('ARTIKEL_R').AsInteger;
  AUSGABEART_R := IB_Grid1.datasource.Dataset.FieldByName('AUSGABEART_R')
    .AsInteger;
  if (e_w_SetFolge(AUSGABEART_R, ARTIKEL_R) > 1) then
    BuchenOK := FormFolgeSetzen.SetContext(AUSGABEART_R, ARTIKEL_R)
  else
    BuchenOK := true;
  if BuchenOK then
  begin
    ZUSAMMENHANG := e_w_Wareneingang(AUSGABEART_R, ARTIKEL_R,
      strtol(Edit1.Text));
    if (ZUSAMMENHANG = -1) then
      ShowMessage('Es gab Fehler - siehe Log')
    else
      Edit1.Text := '';
    IB_Query2.Refresh;
    if CheckBox4.checked then
      RefreshView;
  end;
  EndHourGlass;
  Button2.enabled := true;
end;

procedure TFormBestellArbeitsplatz.IB_Query1AfterScroll
  (IB_Dataset: TIB_Dataset);
begin
  ShowMoreInfo;
end;

procedure TFormBestellArbeitsplatz.Button4Click(Sender: TObject);
begin

  if not(IB_Query5.Active) then
    IB_Query5.Open;
  if not(IB_Query6.Active) then
    IB_Query6.Open;

  IB_Query5.ParamByName('CROSSREF').AsInteger :=
    IB_Query1.FieldByName('BELEG_R').AsInteger;
  IB_Query6.ParamByName('CROSSREF').AsInteger :=
    IB_Query1.FieldByName('BELEG_R').AsInteger;

  e_w_BelegStatusBuchen(IB_Query5.FieldByName('RID').AsInteger);

  IB_UpdateBar1.BtnClick(ubRefreshAll);
  ShowMoreInfo;
end;

procedure TFormBestellArbeitsplatz.Button5Click(Sender: TObject);
begin
  if not(IB_Grid1.datasource.Dataset.FieldByName('ARTIKEL_R').IsNull) then
    FormArtikel.SetContext(IB_Grid1.datasource.Dataset.FieldByName('ARTIKEL_R')
      .AsInteger);
end;

procedure TFormBestellArbeitsplatz.IB_Grid1DblClick(Sender: TObject);
begin
  Button3.click;
end;

var
  LastRow: Integer = -1;
  _NewCol: TColor;
  _NewStyle: set of TFontStyle;

procedure TFormBestellArbeitsplatz.IB_Grid1DrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  _CellDisplayText: string;
  Zusage: TANFiXDate;
  ZusageAge: Integer;
  Motivation: Integer;
begin
  with IB_Grid1 do
  begin

    // important: set DefDrawBefore to false
    if (ARow <> LastRow) then
    begin
      _NewCol := Color;

      // Einfärben anhand der Zusage!
      Zusage := date2long(nextp(GetCellDisplayText(cZUSAGE_row, ARow), ' ', 1));
      if DateOk(Zusage) then
      begin
        ZusageAge := DateDiff(Zusage, DateGet);
        case ZusageAge of
          - 1:
            _NewCol := cllime;
          0:
            _NewCol := clgreen;
          1:
            _NewCol := rgb($FF, $7F, $7F);
        else
          if ZusageAge > 1 then
            _NewCol := clred;
        end;
      end;

      // Fett oder unfett je nachdem, ob Kundenwunsch oder Lager-Auffüllen
      Motivation := strtol(GetCellDisplayText(cMOTIVATION_row, ARow));
      _NewStyle := [];
      if (Motivation = eT_MotivationKundenAuftrag) then
        _NewStyle := [fsbold];
      if (Motivation = eT_MotivationHaendlerAuftrag) then
        _NewStyle := [fsbold, fsitalic];

      LastRow := ARow;
    end;

    // Text für diese Zelle
    _CellDisplayText := GetCellDisplayText(ACol, ARow);
    if (_CellDisplayText = '-') then
      case ACol of
        cLAGER_row:
          begin
            if (GetCellDisplayText(cAUSGABEART_R_row, ARow) = '') then
              if (GetCellDisplayText(cARTIKEL_R_row, ARow) <> '') then
              begin
                _CellDisplayText :=
                  e_r_sqls('select MENGE from ARTIKEL where RID=' +
                  GetCellDisplayText(cARTIKEL_R_row, ARow));
              end;
          end;
        cMINDEST_row:
          begin
            if (GetCellDisplayText(cAUSGABEART_R_row, ARow) = '') then
              if (GetCellDisplayText(cARTIKEL_R_row, ARow) <> '') then
              begin
                _CellDisplayText :=
                  e_r_sqls('select MINDESTBESTAND from ARTIKEL where RID=' +
                  GetCellDisplayText(cARTIKEL_R_row, ARow));
              end;
          end;
      end;

    if gdFocused in State then
    begin
      // alles auf Standard
      canvas.Brush.Color := Color;
      if GetCellDisplayText(cBELEG_R_row, ARow) <> '' then
        canvas.font.Color := clblue
      else
        canvas.font.Color := FormBestellArbeitsplatz.canvas.font.Color;

      canvas.font.Style := _NewStyle;
      DefaultDrawFocusedCell(ACol, ARow, Rect, State, _CellDisplayText,
        GetCellAlignment(ACol, ARow));
    end
    else
    begin
      canvas.Brush.Color := _NewCol;
      if (GetCellDisplayText(cBELEG_R_row, ARow) <> '') then
        canvas.font.Color := clblue
      else
        canvas.font.Color := VisibleContrast(canvas.Brush.Color);
      canvas.font.Style := _NewStyle;
      DefaultDrawCell(ACol, ARow, Rect, State, _CellDisplayText,
        GetCellAlignment(ACol, ARow));
    end;
  end;
end;

procedure TFormBestellArbeitsplatz.IB_Query1AfterPrepare(Sender: TIB_Statement);
begin
  LastRow := MaxInt;
end;

procedure TFormBestellArbeitsplatz.Button1Click(Sender: TObject);
begin
  if (IB_Query1.State <> dssedit) then
    IB_Query1.edit;
  IB_Query1.FieldByName('ZUSAGE').AsDate :=
    long2datetime(DatePlusWorking(DateGet, strtol(Edit3.Text)));
  IB_Query1.post;
  IB_Query1.Refresh;
  ShowMoreInfo;
end;

procedure TFormBestellArbeitsplatz.SetContext(ARTIKEL_R: Integer);
begin
  BeginHourGlass;
  show;
  SetAgentView;
  with IB_Grid1.datasource.Dataset as TIB_Query do
    locate('ARTIKEL_R', ARTIKEL_R, []);
  EndHourGlass;
end;

procedure TFormBestellArbeitsplatz.ShowMoreInfo;

var
  Artikel: TIB_Query;
  DataAvailable: boolean;

  function CheckAvail(FieldName: string): boolean;
  begin
    result := false;
    repeat
      if not(HasFieldName(Artikel, FieldName)) then
        break;
      if Artikel.FieldByName(FieldName).IsNull then
        break;
      result := true;
    until true;
  end;

begin

  DataAvailable := false;
  Artikel := TIB_Query(IB_Grid1.datasource.Dataset);

  Button3.enabled := CheckAvail('ORDER_NO');
  Button5.enabled := CheckAvail('ARTIKEL_R');
  Button8.enabled := CheckAvail('VERLAG_R');
  Button9.enabled := CheckAvail('LIEFERANT_R');
  Button10.enabled := CheckAvail('BELEG_NO') or CheckAvail('POSTEN_R');
  Button11.enabled := CheckAvail('PERSON_R');

  if HasFieldName(Artikel, 'ARTIKEL_R') then
    if Artikel.FieldByName('ARTIKEL_R').IsNotNull then
    begin
      DataAvailable := true;

      IB_Query2.ParamByName('CROSSREF').AsInteger :=
        Artikel.FieldByName('ARTIKEL_R').AsInteger;
      if not(IB_Query2.Active) then
        IB_Query2.Open;

      with IB_Query2 do
      begin
        StaticText1.Caption := e_r_Verlag_PERSON_R
          (IB_Query2.FieldByName('VERLAG_R').AsInteger);
        StaticText2.Caption := e_r_Verlag_PERSON_R
          (e_r_Lieferant(Artikel.FieldByName('ARTIKEL_R').AsInteger, 1));
      end;

    end;

  repeat

    if HasFieldName(Artikel, 'MENGE_AGENT') then
      if Artikel.FieldByName('MENGE_AGENT').IsNotNull then
      begin
        Edit1.Text := Artikel.FieldByName('MENGE_AGENT').AsString;
        break;
      end;

    if HasFieldName(Artikel, 'MENGE_ERWARTET') then
      if Artikel.FieldByName('MENGE_ERWARTET').IsNotNull then
      begin
        Edit1.Text := Artikel.FieldByName('MENGE_ERWARTET').AsString;
        break;
      end;

  until true;

  if not(DataAvailable) then
  begin
    StaticText1.Caption := '---';
    StaticText2.Caption := '---';
  end;
end;

procedure TFormBestellArbeitsplatz.Button6Click(Sender: TObject);
begin
  SetUebergangsfachView;
end;

procedure TFormBestellArbeitsplatz.ToolButton36Click(Sender: TObject);
begin
  SetVorschlagView;
end;

procedure TFormBestellArbeitsplatz.ToolButton35Click(Sender: TObject);
begin
  SetAgentView;
end;

procedure TFormBestellArbeitsplatz.ToolButton16Click(Sender: TObject);
begin
  with IB_Query1 do
  begin
    repeat

      if FieldByName('LIEFERANT_R').IsNull then
      begin
        ShowMessage('Noch kein Lieferant zugeordnet!');
        break;
      end;

      if (FieldByName('MENGE_UNBESTELLT').AsInteger > 0) then
      begin
        BeginHourGlass;
        edit;
        FieldByName('ORDER_NO').AsInteger :=
          e_w_BestellBeleg(FieldByName('LIEFERANT_R').AsInteger);
        post;
        EndHourGlass;
      end
      else
      begin
        ShowMessage('unbestellte Menge ist 0!');
        break;
      end;

    until true;
    BeginHourGlass;
    Refresh;
    next;
    EndHourGlass;
  end;
end;

procedure TFormBestellArbeitsplatz.Button8Click(Sender: TObject);
begin
  FormPerson.SetContext(IB_Grid1.datasource.Dataset.FieldByName('VERLAG_R')
    .AsInteger);
end;

procedure TFormBestellArbeitsplatz.Button9Click(Sender: TObject);
begin
  FormPerson.SetContext(IB_Grid1.datasource.Dataset.FieldByName('LIEFERANT_R')
    .AsInteger);
end;

procedure TFormBestellArbeitsplatz.ToolButton3Click(Sender: TObject);
var
 BPOSTEN : TgpIntegerList;
 n : integer;
begin
  // Bestellvorschlag aufräumen
  if doit('Alle durch den Bestellvorschlag erzeugten Positionen löschen?') then
  begin
    BeginHourGlass;
    BPOSTEN := e_r_sqlm(
     {} 'select RID from BPOSTEN where' +
     {} ' (MENGE_UNBESTELLT<>0) and'+
        ' (MOTIVATION<=10)');
    for n := 0 to pred(BPOSTEN.count) do
    begin
     e_w_preDeleteBPosten(BPOSTEN[n]);
     e_x_sql('delete from BPOSTEN where RID='+inttostr(BPOSTEN[n]));
    end;
    IB_Grid1.datasource.Dataset.RefreshAll;
    EndHourGlass;
  end;
end;

procedure TFormBestellArbeitsplatz.ToolButton11Click(Sender: TObject);
var
  AlleDiags: TStringList;
begin
  AlleDiags := TStringList.create;
  dir(DiagnosePath + cOrderDiagFName + '*' + cOrderDiagExtension,
    AlleDiags, false);
  if (AlleDiags.count > 0) then
  begin
    AlleDiags.sort;
    openShell(DiagnosePath + AlleDiags[pred(AlleDiags.count)]);
  end;
  AlleDiags.free;
end;

procedure TFormBestellArbeitsplatz.IB_Query3AfterScroll
  (IB_Dataset: TIB_Dataset);
begin
  ShowMoreInfo;
end;

procedure TFormBestellArbeitsplatz.ToolButton13Click(Sender: TObject);
begin
  SetBelegeView;
end;

procedure TFormBestellArbeitsplatz.SetBelegeView;
begin
  BeginHourGlass;
  with IB_DataSource5.Dataset do
  begin
    if not(Active) then
      Open;
  end;
  IB_Grid1.datasource := IB_DataSource5;
  IB_UpdateBar1.datasource := IB_DataSource5;
  ShowMoreInfo;
  EndHourGlass;
end;

procedure TFormBestellArbeitsplatz.ToolButton14Click(Sender: TObject);
begin
  // WE "Lager"
  SetWELagerView;
end;

procedure TFormBestellArbeitsplatz.ToolButton15Click(Sender: TObject);
begin
  // WE Versand
  SetWEVersandView;
end;

procedure TFormBestellArbeitsplatz.ToolButton1Click(Sender: TObject);
begin
  ShowMessage('ohne Funktion!');
end;

procedure TFormBestellArbeitsplatz.ToolButton33Click(Sender: TObject);
begin
  ShowMessage('ohne Funktion!');
end;

procedure TFormBestellArbeitsplatz.Button10Click(Sender: TObject);
var
  IBQ: TIB_Query;
  POSTEN: TIB_Query;
  OneFound: boolean;
begin
  BeginHourGlass;
  OneFound := false;
  IBQ := TIB_Query(IB_Grid1.datasource.Dataset);
  repeat

    if HasFieldName(IBQ, 'BELEG_NO') then
      if IBQ.FieldByName('BELEG_NO').IsNotNull then
      begin
        OneFound := true;
        FormBelege.SetContext(0, IBQ.FieldByName('BELEG_NO').AsInteger);
        break;
      end;

    if HasFieldName(IBQ, 'POSTEN_R') then
      if IBQ.FieldByName('POSTEN_R').IsNotNull then
      begin
        OneFound := true;
        POSTEN := DataModuleDatenbank.nQuery;
        with POSTEN do
        begin
          sql.add('SELECT BELEG_R FROM POSTEN WHERE RID=' +
            IBQ.FieldByName('POSTEN_R').AsString);
          Open;
          if not(eof) then
            FormBelege.SetContext(0, FieldByName('BELEG_R').AsInteger,
              IBQ.FieldByName('POSTEN_R').AsInteger);
          Close;
        end;
        POSTEN.free;
        break;
      end;
  until true;
  EndHourGlass;
  if not(OneFound) then
    ShowMessage('Leider keine Verknüpfung zu einem Beleg eingetragen!');
end;

procedure TFormBestellArbeitsplatz.Button3Click(Sender: TObject);
var
  IBQ: TIB_Query;
begin
  IBQ := TIB_Query(IB_Grid1.datasource.Dataset);
  repeat
    if HasFieldName(IBQ, 'ORDER_NO') then
    begin
      if IBQ.FieldByName('ORDER_NO').IsNotNull then
        FormBBelege.SetContext(0, IBQ.FieldByName('ORDER_NO').AsInteger,
          IBQ.FieldByName('BPOSTEN_R').AsInteger)
      else
        ShowMessage('Dieser Zeile wurde noch kein Bestellbeleg zugeordnet.' +
          #13 + 'Dies kann mit der Taste "unbestelltes einem Bestellbeleg zuordnen" erledigt'
          + #13 + 'werden!');
      break;
    end;

    if HasFieldName(IBQ, 'BEWEGT') then
    begin
      with IBQ do
      begin
        edit;
        if (FieldByName('BEWEGT').AsString <> 'Y') then
          FieldByName('BEWEGT').AsString := 'Y'
        else
          FieldByName('BEWEGT').AsString := 'N';
        post;
      end;
    end;
  until true;
end;

procedure TFormBestellArbeitsplatz.Button11Click(Sender: TObject);
begin
  FormPerson.SetContext(IB_Grid1.datasource.Dataset.FieldByName('PERSON_R')
    .AsInteger);
end;

procedure TFormBestellArbeitsplatz.SetAgentView;
begin
  BeginHourGlass;

  // den genialen JOIN einschalten
  if not(IB_Query3.Active) then
    IB_Query3.Open;

  //
  IB_Grid1.Color := $E0E0FF;
  IB_Grid1.canvas.Brush.Color := IB_Grid1.Color;
  IB_Grid1.datasource := IB_DataSource4;
  IB_UpdateBar1.datasource := IB_DataSource4;
  ShowMoreInfo;
  EndHourGlass;
end;

procedure TFormBestellArbeitsplatz.ToolButton17Click(Sender: TObject);
begin
 MobilExport;
 wanfix32.openshell( DiagnosePath + 'WE.csv');
end;

procedure TFormBestellArbeitsplatz.IB_QueryWE1AfterScroll
  (IB_Dataset: TIB_Dataset);
begin
  ShowMoreInfo;
end;

procedure TFormBestellArbeitsplatz.SetWELagerView;
begin
  BeginHourGlass;

  // den genialen JOIN einschalten
  if not(IB_QueryWELager.Active) then
    IB_QueryWELager.Open
  else
    IB_QueryWELager.Refresh;

  //
  IB_Grid1.Color := $EEEEEE;
  IB_Grid1.canvas.Brush.Color := IB_Grid1.Color;
  IB_Grid1.datasource := IB_DataSourceWELager;
  IB_UpdateBar1.datasource := IB_DataSourceWELager;
  ShowMoreInfo;

  EndHourGlass;
end;

procedure TFormBestellArbeitsplatz.SetWEVersandView;
begin
  BeginHourGlass;

  // den genialen JOIN einschalten
  if not(IB_QueryWEVersand.Active) then
    IB_QueryWEVersand.Open;

  //
  IB_Grid1.Color := $EEEEEE;
  IB_Grid1.canvas.Brush.Color := IB_Grid1.Color;
  IB_Grid1.datasource := IB_DataSourceWEVersand;
  IB_UpdateBar1.datasource := IB_DataSourceWEVersand;
  ShowMoreInfo;
  EndHourGlass;

end;

procedure TFormBestellArbeitsplatz.IB_QueryWELagerAfterScroll
  (IB_Dataset: TIB_Dataset);
begin
  ShowMoreInfo;
end;

procedure TFormBestellArbeitsplatz.IB_QueryWEVersandAfterScroll
  (IB_Dataset: TIB_Dataset);
begin
  ShowMoreInfo;
end;

procedure TFormBestellArbeitsplatz.ToolButton29Click(Sender: TObject);
var
  IBQ: TIB_Query;
  POSTEN: TIB_Query;
  OneFound: boolean;
begin
  BeginHourGlass;
  OneFound := false;
  IBQ := TIB_Query(IB_Grid1.datasource.Dataset);
  repeat

    if HasFieldName(IBQ, 'BELEG_NO') then
      if IBQ.FieldByName('BELEG_NO').IsNotNull then
      begin
        OneFound := true;
        FormWarenbewegung.SetContext(IBQ.FieldByName('BELEG_NO').AsInteger);
        break;
      end;

    if HasFieldName(IBQ, 'POSTEN_R') then
      if IBQ.FieldByName('POSTEN_R').IsNotNull then
      begin
        OneFound := true;
        POSTEN := DataModuleDatenbank.nQuery;
        with POSTEN do
        begin
          sql.add('SELECT BELEG_R FROM POSTEN WHERE RID=' +
            IBQ.FieldByName('POSTEN_R').AsString);
          Open;
          if not(eof) then
            FormWarenbewegung.SetContext(FieldByName('BELEG_R').AsInteger);
          Close;
        end;
        POSTEN.free;
        break;
      end;
  until true;
  EndHourGlass;
  if not(OneFound) then
    ShowMessage('Leider keine Verknüpfung zu einem Beleg eingetragen!');
end;

procedure TFormBestellArbeitsplatz.ToolButton32Click(Sender: TObject);
var
  Ausgabe: THTMLTemplate;
  Headers: TStringList;
  IBQ: TIB_Query;
  n, m: Integer;
  PostSize: Integer;

  procedure addline(s: string);
  begin
    Ausgabe.insert(Ausgabe.count - PostSize, s);
  end;

  function getdata(FieldName: string): string;
  begin
    result := IBQ.FieldByName(FieldName).AsString;
    if result = '' then
      result := #160;
  end;

begin
  Ausgabe := THTMLTemplate.create;
  Ausgabe.LoadFromFile(MyProgramPath + cHTMLTemplatesDir + 'Tabelle.html');
  PostSize := Ausgabe.count - Ausgabe.findInsertMark('DATA');
  Ausgabe.DeleteBlock('DATA');
  Ausgabe.WriteValue('Title', 'Warenbewegung ' + Datum + ' *  ' + Uhr);
  Headers := TStringList.create;
  IBQ := TIB_Query(IB_Grid1.datasource.Dataset);
  with IBQ do
  begin

    if HasFieldName(IBQ, 'MENGE') then
      Headers.add('MENGE,Anz,align=right');

    if HasFieldName(IBQ, 'BRISANZ') then
      Headers.add('BRISANZ,Brisanz,align=right');

    if HasFieldName(IBQ, 'AUSGABEART_R') then
      Headers.add('AUSGABEART_R,AA,align=right');

    // Bestnr. Verlag (8 Zeichen)

    if HasFieldName(IBQ, 'VERLAGNO') then
      Headers.add('VERLAGNO,Verlag Nó,align=right');

    if HasFieldName(IBQ, 'NUMERO') then
      Headers.add('NUMERO,Artikel Nó,align=right');

    if HasFieldName(IBQ, 'TITEL') then
      Headers.add('TITEL,Titel');

    if HasFieldName(IBQ, 'ARTIKEL') then
      Headers.add('ARTIKEL,Titel');

    if HasFieldName(IBQ, 'NAME') then
      Headers.add('NAME,Lager,');

    if HasFieldName(IBQ, 'MENGE_BISHER') then
      Headers.add('MENGE_BISHER,Alt,align=right');

    if HasFieldName(IBQ, 'MENGE_NEU') then
      Headers.add('MENGE_NEU,Neu,align=right');

    if HasFieldName(IBQ, 'ZIEL') then
      Headers.add('ZIEL,Ziel,');

    // Tabellen-Header aufbauen!
    addline('<tr>');
    for n := 0 to pred(Headers.count) do
      if (n <> pred(Headers.count)) then
      begin
        addline('<td bgcolor=#C8D8E0 ' + nextp(Headers[n], ',', 2) + '>' +
          AnSi2Html(nextp(Headers[n], ',', 1)) + '</td>');
      end
      else
      begin
        addline('<td class=gend bgcolor=#C8D8E0 ' + nextp(Headers[n], ',', 2) +
          '>' + AnSi2Html(nextp(Headers[n], ',', 1)) + '</td>');
      end;
    addline('</tr>');

    first;
    for m := pred(recordCount) downto 0 do
    begin
      addline('<tr>');
      if (m = 0) then
      begin

        // letzte Zeile
        for n := 0 to pred(Headers.count) do
          if n <> pred(Headers.count) then
          begin
            addline('<td class=gfoot ' + nextp(Headers[n], ',', 2) + '>' +
              AnSi2Html(getdata(nextp(Headers[n], ',', 0))) + '</td>');
          end
          else
          begin
            addline('<td class=gright ' + nextp(Headers[n], ',', 2) + '>' +
              AnSi2Html(getdata(nextp(Headers[n], ',', 0))) + '</td>');

          end;

      end
      else
      begin

        // mittlere Zeilen
        for n := 0 to pred(Headers.count) do
          if n <> pred(Headers.count) then
          begin
            addline('<td ' + nextp(Headers[n], ',', 2) + '>' +
              AnSi2Html(getdata(nextp(Headers[n], ',', 0))) + '</td>');
          end
          else
          begin
            addline('<td class=gend ' + nextp(Headers[n], ',', 2) + '>' +
              AnSi2Html(getdata(nextp(Headers[n], ',', 0))) + '</td>');

          end;

      end;
      addline('</tr>');
      next;
    end;
  end;
  Ausgabe.SaveToFileCompressed(DiagnosePath + 'WE.html');
  Ausgabe.free;
  Headers.free;
  openShell(DiagnosePath + 'WE.html');
end;

procedure TFormBestellArbeitsplatz.FormDestroy(Sender: TObject);
begin
  SQLAtStart.free;
end;

procedure TFormBestellArbeitsplatz.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Agent');
end;

procedure TFormBestellArbeitsplatz.MobilExport;
var
  sql: TStringList;
begin
  sql := TStringList.create;
  sql.add('SELECT');
  sql.add('       WARENBEWEGUNG.MENGE');
  sql.add('     , ARTIKEL.MENGE LAGER_MENGE');
  sql.add('     , ARTIKEL.MINDESTBESTAND');
  sql.add('     , WARENBEWEGUNG.AUFTRITT');
  sql.add('     , WARENBEWEGUNG.AUSGABEART_R');
  sql.add('     , ARTIKEL.NUMERO');
  sql.add('     , ARTIKEL.VERLAGNO');
  sql.add('     , ARTIKEL.TITEL');
  sql.add('     , LAGER.NAME');
  sql.add('     , (SELECT LAGER.NAME FROM LAGER WHERE LAGER.RID=BELEG.LAGER_R) ZIEL');
  sql.add('     , WARENBEWEGUNG.BEWEGT');
  sql.add('     , WARENBEWEGUNG.MENGE_BISHER');
  sql.add('     , WARENBEWEGUNG.MENGE_NEU');
  sql.add('     , WARENBEWEGUNG.ZUSAMMENHANG');
  sql.add('     , WARENBEWEGUNG.BRISANZ');
  sql.add('     , WARENBEWEGUNG.RID');
  sql.add('     , WARENBEWEGUNG.ARTIKEL_R');
  sql.add('     , WARENBEWEGUNG.BELEG_R');
  sql.add('     , WARENBEWEGUNG.POSTEN_R');
  sql.add('     , WARENBEWEGUNG.BBELEG_R');
  sql.add('     , WARENBEWEGUNG.BPOSTEN_R');
  sql.Add('     , (''S1(1+''||WARENBEWEGUNG.LAGER_R||'')'') S1');
  sql.Add('     , (''S2(1+''||BELEG.LAGER_R||'')'') S2');
  sql.Add('     , AUSGABEART.NAME AA');
  sql.add('FROM');
  sql.add(' WARENBEWEGUNG');
  sql.add('LEFT JOIN');
  sql.add(' ARTIKEL');
  sql.add('ON');
  sql.add(' WARENBEWEGUNG.ARTIKEL_R=ARTIKEL.RID');
  sql.Add('LEFT JOIN');
  sql.add(' AUSGABEART');
  sql.add('ON');
  sql.add(' WARENBEWEGUNG.AUSGABEART_R=AUSGABEART.RID');
  sql.Add('LEFT JOIN');
  sql.Add(' BELEG');
  sql.add('ON');
  sql.Add(' WARENBEWEGUNG.BELEG_R=BELEG.RID');
  sql.add('LEFT JOIN');
  sql.add(' LAGER');
  sql.add('ON');
  sql.add(' WARENBEWEGUNG.LAGER_R=LAGER.RID');
  sql.add('WHERE');
  sql.add(' (WARENBEWEGUNG.BEWEGT<>''Y'') OR');
  sql.add(' (WARENBEWEGUNG.BEWEGT IS NULL)');
  sql.add('ORDER BY');
  sql.add(' LAGER.NAME, BELEG.RID, ARTIKEL.TITEL, AUSGABEART.NAME');
  ExportTable(sql, DiagnosePath + 'WE.csv');
  sql.free;
end;

procedure TFormBestellArbeitsplatz.Button12Click(Sender: TObject);
begin
  if not(IB_Grid1.datasource.Dataset.FieldByName('ARTIKEL_R').IsNull) then
    FormArtikelBackOrder.SetContext(
     {} IB_Grid1.datasource.Dataset.FieldByName('AUSGABEART_R').AsInteger,
     {} IB_Grid1.datasource.Dataset.FieldByName('ARTIKEL_R').AsInteger);
end;

procedure TFormBestellArbeitsplatz.IB_Grid1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if ssAlt in Shift then
    if (Key = ord('X')) then
    begin
      Key := 0;
      OLAP.DoContextOLAP(IB_Grid1);
    end;
end;

end.


