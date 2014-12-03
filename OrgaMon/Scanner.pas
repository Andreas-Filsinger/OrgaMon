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
unit Scanner;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  anfix32, wordindex,
  StdCtrls, IB_Components, IB_Access,
  ExtCtrls,
  Buttons, jpeg, Datenbank,

  // Jedi
  JvExExtCtrls, JvComponent, JvClock,

  // Indy
  IdBaseComponent, IdComponent, IdUDPBase,
  IdUDPClient, IdSNTP, JvExtComponent, Vcl.Grids;

type
  TFormScanner = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    ListBox1: TListBox;
    CheckBox1: TCheckBox;
    IB_Cursor1: TIB_Cursor;
    IB_Query1: TIB_Query;
    Button5: TButton;
    Button6: TButton;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    ComboBox1: TComboBox;
    Image2: TImage;
    SpeedButton2: TSpeedButton;
    Button11: TButton;
    Button7: TButton;
    Image1: TImage;
    DrawGrid1: TDrawGrid;
    Edit2: TEdit;
    StaticText1: TStaticText;
    Button2: TButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure DrawGrid1DblClick(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
  private
    initialized: boolean;
    cPlanY: Integer;
    ScrollBarWidth: Integer;
    SCAN_LIST: TsTable;
    SL_BELEG_R: Integer;

    function Selected_BELEG_R: Integer;
    function Selected_PERSON_R: Integer;
    procedure SL_load(BELEG_R: Integer);
    procedure SL_refresh;
    procedure SL_show;
    procedure SL_reflect;
    procedure RefreshSumme;

  public
    { Public-Deklarationen }
    procedure doActivate(active: boolean);
    function Local_vs_Server_TimeDifference: TANFiXTime;
    procedure hotEvent;
  end;

var
  FormScanner: TFormScanner;

implementation

uses
  math,
  globals, winamp,
  Funktionen_Basis,
  Funktionen_Beleg,
  CareTakerClient, Belege, Person,
  Main, dbOrgaMon, VersenderPaketID,
  SysHot, wanfix32, GUIhelp,
  html,
  Artikel;

{$R *.dfm}

procedure TFormScanner.Button11Click(Sender: TObject);
begin
  // Scan Mengen eintragen
  // Verbuchen
end;

procedure TFormScanner.Button1Click(Sender: TObject);
var
  GanzerScan, Scan: string;
  ErrorMsg: string;
  LOGO: string;
  BELEG_R: Integer;
  GENERATION: Integer;
  MENGE_RECHNUNG: Integer;
  EventText: TStringList;
  n: Integer;
  LabelDruck: boolean;
  VERSENDER_R: Integer;
  VERSAND_R: Integer;
  TEILLIEFERUNG: Integer;
  qEREIGNIS: TIB_Query;
begin
  //
  LabelDruck := false;
  MENGE_RECHNUNG := 0;
  GENERATION := 0;
  TEILLIEFERUNG := 0;
  BELEG_R := cRID_Null;
  ErrorMsg := '';
  GanzerScan := Edit1.Text;
  VERSENDER_R := cRID_Null;
  qEREIGNIS := DataModuleDatenbank.nQuery;
  EventText := TStringList.create;
  with qEREIGNIS do
  begin
    ColumnAttributes.add('RID=NOTREQUIRED');
    ColumnAttributes.add('AUFTRITT=NOTREQUIRED');
    sql.add('select * from EREIGNIS for update');
  end;

  //
  ListBox1.items.add(GanzerScan);
  ListBox1.ItemIndex := pred(ListBox1.items.count);
  repeat

    try

      Scan := GanzerScan;

      // Erst mal alles bis zur ersten Ziffer filtern
      LOGO := '';
      for n := 1 to length(Scan) do
        if (Pos(Scan[n], '0123456789') > 0) then
        begin
          LOGO := copy(Scan, 1, pred(n));
          delete(Scan, 1, 1);
          break;
        end;

      // Welcher Versender?!
      if (LOGO <> '') then
        VERSENDER_R := e_r_sql('select RID from VERSENDER where LOGO=''' +
          LOGO + '''');

      // restliche Parameter!
      BELEG_R := strtointdef(nextp(Scan, '-', 0), cRID_Null);
      GENERATION := strtointdef(nextp(Scan, '-', 1), 0);

      // Plausibilisierung "BELEG_R"
      if (BELEG_R >= cRID_FirstValid) then
        if not(e_r_IsRID('BELEG_R', BELEG_R)) then
          BELEG_R := cRID_Null;

      // Ganzen Scan loggen
      with qEREIGNIS do
      begin
        insert;
        FieldByName('ART').AsInteger := eT_BelegScan;
        FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
        EventText.add('Scan ' + GanzerScan);
        if (BELEG_R >= cRID_FirstValid) then
          FieldByName('BELEG_R').AsInteger := BELEG_R;
        FieldByName('INFO').assign(EventText);
        post;
      end;

      // Sonder-Scan "Paket IDs verarbeiten"
      if (GanzerScan = '+00000-') then
      begin
        FormVersenderPaketID.Execute;
        WinAmpPlayFile(SoundPath + 'SUCCESS.WAV');
        break;
      end;

      // Prüfung, ob BELEG_R ok ist
      if (BELEG_R = cRID_Null) then
      begin
        ErrorMsg := 'Beleg ' + inttostr(BELEG_R) + ' wurde nicht gefunden!';
        break;
      end;

      // Beleg-Daten nachladen
      with IB_Cursor1 do
      begin
        ParamByName('CROSSREF1').AsInteger := BELEG_R;
        ParamByName('CROSSREF2').AsInteger := GENERATION;
        open;
        if eof then
        begin
          ErrorMsg := '* Dieser Beleg wurde zwischenzeitlich geändert.' + #13 +
            '* Oder es wurde noch kein Ausdruck gemacht.' + #13 +
            'Er muss neu/erstmals ausgedruckt werden!'
        end
        else
        begin
          MENGE_RECHNUNG := FieldByName('MENGE_RECHNUNG').AsInteger;
          TEILLIEFERUNG := FieldByName('TEILLIEFERUNG').AsInteger;
        end;
        close;
      end;
      if (ErrorMsg <> '') then
        break;

      if (MENGE_RECHNUNG = 0) then
      begin
        ErrorMsg := 'Die Rechnungsmenge des Beleges ist 0!';
        break;
      end;

      // Ist es ein Plus-Scan?
      if Pos('+', LOGO) > 0 then
      begin
        LabelDruck := true;
        WinAmpPlayFile(SoundPath + 'plus.wav')
      end
      else
      begin
        WinAmpPlayFile(SoundPath + 'minus.wav');
      end;

      // Beleg buchen / Ausgabe / Versand vorbereiten
      e_w_BelegBuchen(BELEG_R, LabelDruck);

      // Den Versender noch einstellen
      VERSAND_R := e_r_sql('select RID from VERSAND where' + ' (BELEG_R=' +
        inttostr(BELEG_R) + ') and' + ' (TEILLIEFERUNG=' +
        inttostr(TEILLIEFERUNG) + ')');
      if (VERSAND_R >= cRID_FirstValid) then
        if (VERSENDER_R >= cRID_FirstValid) then
          e_x_sql(
            { } 'update VERSAND set ' +
            { } ' VERSENDER_R=' + inttostr(VERSENDER_R) + ' ' +
            { } 'where' +
            { } ' (RID=' + inttostr(VERSAND_R) + ')');

      if not(LabelDruck) then
      begin
        EventText.clear;
        with qEREIGNIS do
        begin
          insert;
          FieldByName('ART').AsInteger := eT_PaketIDErhalten;
          FieldByName('BELEG_R').AsInteger := BELEG_R;
          FieldByName('VERSAND_R').AsInteger := VERSAND_R;
          EventText.add('Versand ohne Paket-ID!');
          FieldByName('INFO').assign(EventText);
          post;
        end;
      end;

    except
      on E: Exception do
      begin
        ErrorMsg := 'Systemfehler beim Buchen' + E.Message;
        WinAmpPlayFile(SoundPath + 'ERROR.WAV');
        break;
      end;
    end;

    with IB_Query1 do
    begin
      insert;
      FieldByName('BELEG_R').AsInteger := BELEG_R;
      FieldByName('GENERATION').AsInteger := GENERATION;
      FieldByName('ART').AsString := LOGO;
      FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
      post;
    end;

    WinAmpPlayFile(SoundPath + 'SUCCESS.WAV');

  until true;

  Edit1.Text := '';
  if (ErrorMsg <> '') then
  begin
    WinAmpPlayFile(SoundPath + 'ERROR.WAV');
    ShowMessage(ErrorMsg);
  end;
  SetForeGroundWindow(handle);
  qEREIGNIS.free;
  EventText.free;

end;

procedure TFormScanner.CheckBox1Click(Sender: TObject);
begin
  doActivate(CheckBox1.Checked);
end;

procedure TFormScanner.doActivate(active: boolean);
begin
  // init
  FormMain.registerHot('Scanner', [], vkF2, active);

  // set
  if (active <> CheckBox1.Checked) then
    CheckBox1.Checked := active;
end;

procedure TFormScanner.DrawGrid1DblClick(Sender: TObject);
begin
  FormArtikel.SetContext(strtointdef(SCAN_LIST.readCell(DrawGrid1.Row, 3), 0));
end;

procedure TFormScanner.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  Fokusiert: boolean;
  MENGE_RECHNUNG, MENGE_SCAN, MENGE_REST: Integer;
  GTIN: string;
begin
  if (ARow >= 0) then
    with DrawGrid1.canvas, IB_Cursor1 do
    begin

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

      if assigned(SCAN_LIST) then
      begin

        (* Im Falle von Status "Markiert"
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

          // Bereichnung der Zeilen Höhe
          RowHeight := max(cPlanY * 2, cPlanY * UeberweisungsText.count)
          + dpiX(2);
          if (RowHeight <> DrawGrid1.RowHeights[ARow]) then
          begin
          DrawGrid1.RowHeights[ARow] := RowHeight;
          UeberweisungsText.free;
          exit;
          end;
        *)
        case ACol of
          0:
            begin

              if (ARow > 0) then
              begin
                MENGE_RECHNUNG := strtointdef(SCAN_LIST.readCell(ARow, 0), 0);
                MENGE_SCAN := strtointdef(SCAN_LIST.readCell(ARow, 4), 0);
                MENGE_REST := MENGE_RECHNUNG - MENGE_SCAN;
                if MENGE_RECHNUNG > MENGE_SCAN then
                begin
                  GTIN := SCAN_LIST.readCell(ARow, 2);
                  if (GTIN <> '<NULL>') then
                    brush.color := HTMLColor2TColor($FF9966)
                  else
                    brush.color := HTMLColor2TColor($9999FF);
                end
                else
                begin
                  brush.color := HTMLColor2TColor($99FF99);
                end;

                // MENGE

                FillRect(Rect);
                font.size := 11;
                TextOut(Rect.left + 2, Rect.top,
                  SCAN_LIST.readCell(ARow, ACol));
                if (MENGE_REST > 0) then
                  TextOut(
                    { } Rect.left + 2,
                    { } Rect.top + cPlanY,
                    { } 'noch ' + inttostr(MENGE_REST));
              end
              else
              begin
                font.size := 10;
                TextRect(Rect, Rect.left + 2, Rect.top, 'Anzahl');
              end;

              // draw(rect.left + 3, rect.top + 2, StatusBMPs[random(4)]); // Status
            end;
          1:
            begin
              // ARTIKEL
              // brush.color := HTMLColor2TColor($FFCC99);

              font.size := 10;
              TextRect(Rect, Rect.left + 2, Rect.top,
                SCAN_LIST.readCell(ARow, ACol));
            end;
          2:
            begin
              // MENGE
              // brush.color := HTMLColor2TColor($FFCC99);

              font.size := 10;
              TextRect(Rect, Rect.left + 2, Rect.top,
                SCAN_LIST.readCell(ARow, ACol));
            end;
        else
          // dummy Rand Zellen
          FillRect(Rect);
        end;

        // Grauer vertikaler Strich
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

procedure TFormScanner.FormActivate(Sender: TObject);
begin
  if not(initialized) then
  begin
    cPlanY := dpiX(16);
    ScrollBarWidth := GetSystemMetrics(SM_CXVSCROLL);
    with DrawGrid1, canvas do
    begin
      DefaultRowHeight := (cPlanY * 2) + dpiX(2);
      font.NAME := 'Courier New';
      font.color := clblack;
      ColCount := 4;
      ColWidths[0] := dpiX(60);
      ColWidths[2] := dpiX(130);
      ColWidths[3] := 1;
      ColWidths[1] := clientwidth - ColWidths[0] - ColWidths[2] -
        (3 * 2 + ScrollBarWidth);
      RowCount := 0;
    end;
    dgAutoSize(DrawGrid1, true);
    initialized := true;
  end;
end;

procedure TFormScanner.FormResize(Sender: TObject);
begin
  if initialized then
    with DrawGrid1 do
    begin
      ColWidths[1] := clientwidth - ColWidths[0] - ColWidths[2] -
        (3 * 2 + ScrollBarWidth);
    end;
end;

procedure TFormScanner.hotEvent;
begin
  show;
  setfocus;
  Edit1.setfocus;
  SetForeGroundWindow(handle);
end;

procedure TFormScanner.Image1Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Scanner');
end;

procedure TFormScanner.Button2Click(Sender: TObject);
begin
  SL_load(strtointdef(Edit2.Text, 0));
  SL_show;
end;

procedure TFormScanner.Button4Click(Sender: TObject);
var
  ServerDate: TANFiXDate;
  ServerTime: TANFiXTime;
  ServerDiff: TANFiXTime;
  MoreText: string;
begin
  //
  DateTime2long(e_r_Now, ServerDate, ServerTime);

  //
  ServerDiff := Local_vs_Server_TimeDifference;

  MoreText :=
    'Die lokale Zeitsynchronisation mit einem Zeit-Server muss extern aktiviert werden';

  ShowMessage(MoreText + #13 + 'Zeit dieses Rechners ' + long2date(DateGet) +
    ' ' + secondstostr(SecondsGet) + #13 + 'Zeit des Datenbankservers ' +
    long2date(ServerDate) + ' ' + secondstostr(ServerTime) + #13 + #13 +
    'bereinigte Differenz ' + secondstostr9(ServerDiff));
end;

function TFormScanner.Local_vs_Server_TimeDifference: TANFiXTime;
const
  cWahrnehmungsSchwelle = 1;
var
  LocalTime, ServerTime: TANFiXTime;
  LocalDate, ServerDate: TANFiXDate;
begin
  BeginHourGlass;
  result := 0;
  //
  LocalDate := DateGet;
  LocalTime := SecondsGet;
  DateTime2long(e_r_Now, ServerDate, ServerTime);
  //
  result := SecondsDiff(LocalDate, LocalTime, ServerDate, ServerTime);
  if (abs(result) <= cWahrnehmungsSchwelle) then
    result := 0;
  EndHourGlass;
end;

procedure TFormScanner.RefreshSumme;
var
  MENGE_RECHNUNG, MENGE_SCAN: Integer;
  SUMME: Integer;
begin
  if assigned(SCAN_LIST) then
  begin
    MENGE_RECHNUNG := round(SCAN_LIST.sumCol('MENGE_RECHNUNG'));
    MENGE_SCAN := round(SCAN_LIST.sumCol('MENGE_SCAN'));
    SUMME := MENGE_RECHNUNG - MENGE_SCAN;
    if (SUMME = 0) then
    begin
      StaticText1.color := cllime;
      StaticText1.Caption := '';
    end
    else
    begin
      StaticText1.color := clred;
      StaticText1.Caption := inttostr(SUMME);
    end;
  end
  else
  begin
    StaticText1.color := cllime;
    StaticText1.Caption := '';
  end;
end;

procedure TFormScanner.ComboBox1Change(Sender: TObject);
begin
  case ComboBox1.ItemIndex of
    0:
      WinAmpPlayFile(SoundPath + 'plus.wav');
    1:
      WinAmpPlayFile(SoundPath + 'minus.wav');
    2:
      WinAmpPlayFile(SoundPath + 'SUCCESS.WAV');
    3:
      WinAmpPlayFile(SoundPath + 'ERROR.WAV');
  end;
end;

procedure TFormScanner.SpeedButton1Click(Sender: TObject);
begin
  openShell(MyProgramPath + cRechnungPath + RIDasStr(Selected_PERSON_R));
end;

procedure TFormScanner.SpeedButton2Click(Sender: TObject);
begin
  repeat

    if not(FileExists(SoundPath + 'SUCCESS.WAV')) then
    begin
      ShowMessage('Sounddatei "' + SoundPath + 'SUCCESS.WAV" fehlt');
      break;
    end;

    WinAmpLoadUp;
    if not(WinAmpRunning) then
    begin
      ShowMessage('WinAmp fehlt!');
      break;
    end;

    WinAmpPlayFile(SoundPath + 'SUCCESS.WAV');

  until true;

end;

procedure TFormScanner.SpeedButton3Click(Sender: TObject);
begin
  SL_refresh;
end;

procedure TFormScanner.SpeedButton4Click(Sender: TObject);
var
  MENGE_SCAN: Integer;
  MENGE_RECHNUNG: Integer;
  MENGE_REST: Integer;
begin
  MENGE_RECHNUNG := strtointdef(SCAN_LIST.readCell(DrawGrid1.Row, 0), 0);
  MENGE_SCAN := strtointdef(SCAN_LIST.readCell(DrawGrid1.Row, 4), 0);
  MENGE_REST := MENGE_RECHNUNG - MENGE_SCAN;
  if (MENGE_REST > 0) then
  begin
    inc(MENGE_SCAN);
    SCAN_LIST.writeCell(DrawGrid1.Row, 4, inttostr(MENGE_SCAN));
    SL_reflect;
  end;

end;

function TFormScanner.Selected_BELEG_R: Integer;
var
  s: string;
begin
  if (ListBox1.ItemIndex <> -1) then
  begin
    // ##
    s := ListBox1.items[ListBox1.ItemIndex];
    result := strtointdef(nextp(copy(s, 2, MaxInt), '-', 0), 0);
  end
  else
  begin
    result := -1;
  end;
end;

function TFormScanner.Selected_PERSON_R: Integer;
var
  s: string;
  BELEG_R: Integer;
begin
  if (ListBox1.ItemIndex <> -1) then
  begin
    // ##
    s := ListBox1.items[ListBox1.ItemIndex];
    BELEG_R := strtointdef(nextp(copy(s, 2, MaxInt), '-', 0), 0);
    result := e_r_sql('select PERSON_R from BELEG where RID=' +
      inttostr(BELEG_R));
  end
  else
  begin
    result := -1;
  end;
end;

procedure TFormScanner.SL_load(BELEG_R: Integer);
begin
  if assigned(SCAN_LIST) then
    SCAN_LIST.free;

  SCAN_LIST := csTable(
    { } 'select ' +
    { } ' POSTEN.MENGE_RECHNUNG,' +
    { } ' POSTEN.ARTIKEL,' +
    { } ' ARTIKEL.GTIN,' +
    { } ' POSTEN.ARTIKEL_R,' +
    { } ' 0 as MENGE_SCAN ' +
    { } 'from POSTEN ' +
    { } 'left join ARTIKEL on' +
    { } ' (POSTEN.ARTIKEL_R=ARTIKEL.RID) ' +
    { } 'where' +
    { } ' (POSTEN.BELEG_R=' + inttostr(BELEG_R) + ') and' +
    { } ' (POSTEN.MENGE_RECHNUNG>0) and' +
    { } ' (POSTEN.ZUTAT is null) ' +
    { } 'order by' +
    { } ' POSTEN.POSNO,POSTEN.RID');

  SL_BELEG_R := BELEG_R;
end;

procedure TFormScanner.SL_reflect;
begin
  DrawGrid1.Refresh;
  RefreshSumme;
end;

procedure TFormScanner.SL_refresh;
begin
  if assigned(SCAN_LIST) then
    SCAN_LIST.free;
  SL_load(SL_BELEG_R);
  SL_show;
end;

procedure TFormScanner.SL_show;
begin
  with DrawGrid1 do
  begin
    RowCount := SCAN_LIST.RowCount + 1;
    FixedRows := 1;
    DrawGrid1.RowHeights[0] := cPlanY + dpiX(2);
    Refresh;
    // SecureSetRow(DrawGrid1, pred(RowCount));
  end;
  RefreshSumme;
end;

procedure TFormScanner.Button5Click(Sender: TObject);
begin
  FormBelege.SetContext(0, Selected_BELEG_R);
end;

procedure TFormScanner.Button6Click(Sender: TObject);
begin
  FormPerson.SetContext(Selected_PERSON_R);
end;

procedure TFormScanner.Button7Click(Sender: TObject);
begin
  FormArtikel.SetContext(strtointdef(SCAN_LIST.readCell(DrawGrid1.Row, 3), 0));
end;

end.
