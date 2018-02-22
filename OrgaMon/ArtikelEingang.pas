{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2018 Andreas Filsinger
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
unit ArtikelEingang;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, Vcl.Grids, ExtCtrls,
  Buttons, jpeg,

  // Tools
  anfix32, wordindex, Datenbank,

  // IBO
  IB_Components, IB_Access,

  // Indy
  IdBaseComponent, IdComponent, IdUDPBase,
  IdUDPClient, IdSNTP,

  // Jedi
  JvFormPlacement, JvAppStorage, JvComponentBase;

type
  TFormArtikelEingang = class(TForm)
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
    StaticText1: TStaticText;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Button2: TButton;
    JvFormStorage1: TJvFormStorage;
    SpeedButton5: TSpeedButton;
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
    procedure FormResize(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton5Click(Sender: TObject);
  private
    initialized: boolean;
    cPlanY: Integer;
    ScrollBarWidth: Integer;
    SCAN_LIST: TsTable;

    // Parameter der aktuellen Beleg-Ansicht
    SL_BBELEG_R: Integer;
    SL_LabelDruck: boolean;
    SL_Teillieferung: Integer;
    SL_ScanPrefix: string;

    function Selected_BBELEG_R: Integer;
    function Selected_PERSON_R: Integer;
    procedure SL_load(BBELEG_R: Integer);
    procedure SL_refresh; // Full Rebuild
    procedure SL_show;
    procedure SL_reflect; // Data Change
    procedure SL_free; // empty and free list
    procedure RefreshSumme;
    procedure doBuchen;
    procedure doCheck;
    procedure doCheckLess;
    procedure doArtikelJump;
    procedure ResizeDrawgrid1;

  public
    _rowBuchbar: boolean;

    { Public-Deklarationen }
    procedure doActivate(active: boolean);
    procedure hotEvent;

    // verschieden Scan Events
    procedure doBelegScan(ganzerScan: string);
    procedure doArtikelScan(ganzerScan: string);

    // =true wenn SCAN_MENGE nunmehr "0"
    function bucheArtikelScan(row: Integer): boolean;

    // hat die Row noch einen Rest
    function rowRest(row: Integer): boolean;

    // finde die nächste buchbare Zeile
    function rowBuchbar(row: Integer): Integer;

  end;

var
  FormArtikelEingang: TFormArtikelEingang;

implementation

uses
  math,

  globals,

  winamp, SysHot, wanfix32,
  html, dbOrgaMon,

  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,

  GUIhelp, CareTakerClient, Belege,
  Person, main, VersenderPaketID,

  Artikel, bbelege, FolgeSetzen;

{$R *.dfm}

const
  SCAN_LIST_MENGE_ERWARTET = 0;
  SCAN_LIST_ARTIKEL = 1;
  SCAN_LIST_GTIN = 2;
  SCAN_LIST_ARTIKEL_R = 3;
  SCAN_LIST_MENGE_SCAN = 4;
  SCAN_LIST_AUSGABEART_R = 5;
  SCAN_LIST_LAGER = 6;
  SCAN_LIST_VERLAG = 7;
  SCAN_LIST_BBELEG_R = 8;
  SCAN_LIST_BPOSTEN_R = 9;

procedure TFormArtikelEingang.Button11Click(Sender: TObject);
begin
//  doBuchen;
 ShowMessage('Noch keine Idee für diesen Knopf');

end;

procedure TFormArtikelEingang.Button1Click(Sender: TObject);
var
  ganzerScan: string;
begin

  ganzerScan := Edit1.Text;

  if (ganzerScan <> '') then
  begin


    // Historie oben anzeigen
    ListBox1.items.add(ganzerScan);
    ListBox1.ItemIndex := pred(ListBox1.items.count);

    // für die Liste sorgen
    if not(assigned(SCAN_LIST)) then
    begin
      BeginHourGlass;
      SL_load(cRID_unset);
      SL_show;
      EndHourGlass;
    end;

    repeat

      // Sonder-Scans aus ArtikelAusgang
      if (ganzerScan = '+00000-') then
      begin
        break;
      end;

      // Sonder Scan "Artikel so OK"
      if (ganzerScan = '+00001-') then
      begin
        doCheck;
        Edit1.Text := '';

        break;
      end;

      // Sonder Scan "Verbuchen"
      if (ganzerScan = '+00002-') then
      begin
        doBuchen;
        Edit1.Text := '';

        break;
      end;

      // Sonder Scan "Artikel so OK"
      if (ganzerScan = '+00003-') then
      begin
        doCheckLess;
        Edit1.Text := '';

        break;
      end;

      if (pos('-', ganzerScan) = 0) then
        doArtikelScan(ganzerScan)
      else
        doBelegScan(ganzerScan);

    until true;

    // Focus back!
    SetForeGroundWindow(handle);
    Edit1.SetFocus;

  end;
end;

procedure TFormArtikelEingang.Button2Click(Sender: TObject);
var
  row: Integer;
  AUSGABEART_R: Integer;
begin
  if assigned(SCAN_LIST) then
    if (Edit1.Text <> '') then
    begin
      row := DrawGrid1.row;
      AUSGABEART_R :=
       {} StrToIntDef(
       {} SCAN_LIST.readCell(row,SCAN_LIST_AUSGABEART_R),
       {} cRID_Null);
      if (AUSGABEART_R >= cRID_FirstValid) then
      begin

        // Setze Hauptartikel wenn <leer>
        e_x_sql(
          { } 'update ARTIKEL set' +
          { } ' GTIN=' + Edit1.Text +
          { } 'where ' +
          { } ' (GTIN is null) and ' +
          { } ' (RID=' + SCAN_LIST.readCell(row, SCAN_LIST_ARTIKEL_R) + ')');

        // setze GTIN in der Ausgabeart
        e_x_sql(
          { } 'update ARTIKEL_AA set' +
          { } ' GTIN=' + Edit1.Text +
          { } 'where ' +
          { } ' (AUSGABEART_R=' + IntTostr(AUSGABEART_R) + ') and ' +
          { } ' (ARTIKEL_R=' + SCAN_LIST.readCell(row,
          SCAN_LIST_ARTIKEL_R) + ')');

      end
      else
      begin

        // Setze Hauptartikel
        e_x_sql(
          { } 'update ARTIKEL set ' +
          { } 'GTIN=' + Edit1.Text +
          { } ' where RID=' + SCAN_LIST.readCell(row, SCAN_LIST_ARTIKEL_R));

      end;

      SL_refresh;
      SecureSetRow(DrawGrid1, row);
    end;
end;

procedure TFormArtikelEingang.CheckBox1Click(Sender: TObject);
begin
  doActivate(CheckBox1.Checked);
end;

procedure TFormArtikelEingang.doActivate(active: boolean);
begin
  // register callback "hotEvent"
  FormMain.registerHot('ArtikelEingangScanner', [], vkF2, active);

  // set
  if (active <> CheckBox1.Checked) then
    CheckBox1.Checked := active;

  if active then
    FormMain.Panel5.Color := cllime;
end;

procedure TFormArtikelEingang.doArtikelJump;
begin
  if assigned(SCAN_LIST) then
    FormArtikel.SetContext(
      { } StrToIntDef(SCAN_LIST.readCell(DrawGrid1.row, SCAN_LIST_ARTIKEL_R),
      cRID_Null),
      { } StrToIntDef(SCAN_LIST.readCell(DrawGrid1.row, SCAN_LIST_AUSGABEART_R),
      cRID_Null));
end;

procedure TFormArtikelEingang.doArtikelScan(ganzerScan: string);
var
  ErrorMsg: string;
  row: Integer;
  ScanFertig: boolean;
begin
  ErrorMsg := '';
  repeat

    if not(assigned(SCAN_LIST)) then
    begin
      ErrorMsg := 'Bitte erst eine Belegnummer scannen' + #13 +
        'Oder in der Form' + #13 + '"+" | "-" ~Belegnummer~ "-" ~Generation~' +
        #13 + 'eingeben und mit <ENTER> abschliessen';
      break;
    end;

    row := SCAN_LIST.next(DrawGrid1.row, SCAN_LIST_GTIN, ganzerScan);
    if (row = -1) then
    begin
      ErrorMsg := 'Diese GTIN ist im Moment unbekannt' + #13 +
        'Entweder der Eintrag fehlt noch beim Artikel oder ist falsch' + #13 +
        'Oder der Artikel gehört nicht zu dieser Lieferung' + #13 +
        'Tragen Sie die GTIN nach, indem Sie manuell auf die richtige Zeile positionieren, drücken Sie dann [GTIN]';
      break;
    end;

    // prüfen, ob überhaupt noch was offen ist
    if not(rowRest(row)) then
    begin
      ErrorMsg := 'Dieser Artikel wurde zu oft gescannt';
      break;
    end;

    // Änderung um "1" durchführen
    ScanFertig := bucheArtikelScan(row);
    SL_reflect;
    if ScanFertig then
      SecureSetRow(DrawGrid1, min(row + 1, pred(DrawGrid1.RowCount)))
    else
      SecureSetRow(DrawGrid1, row);

  until true;

  if (ErrorMsg <> '') then
  begin
    WinAmpPlayFile(SoundPath + 'ERROR.WAV');
    ShowMessageTimeOut(ErrorMsg, 8000);
  end
  else
  begin
    Edit1.Text := '';
  end;

end;

procedure TFormArtikelEingang.doBelegScan(ganzerScan: string);
var
  Scan: string;
  ErrorMsg: string;
  MENGE_ERWARTET: Integer;
  n: Integer;
  EventText: TStringList;
  qEREIGNIS: TIB_Query;
begin

  // Scan-Ereignis!
  MENGE_ERWARTET := 0;
  ErrorMsg := '';
  SL_LabelDruck := false;

  EventText := TStringList.create;
  qEREIGNIS := DataModuleDatenbank.nQuery;
  with qEREIGNIS do
  begin
    ColumnAttributes.add('RID=NOTREQUIRED');
    ColumnAttributes.add('AUFTRITT=NOTREQUIRED');
    sql.add('select * from EREIGNIS for update');
  end;

  //
  repeat

    try

      // "+" | "-" ~BelegNummer~ "-" ~Generation~

      Scan := ganzerScan;

      // Erst mal alles bis zur ersten Ziffer filtern
      SL_ScanPrefix := '';
      for n := 1 to length(Scan) do
        if (pos(Scan[n], '0123456789') > 0) then
        begin
          SL_ScanPrefix := copy(Scan, 1, pred(n));
          delete(Scan, 1, 1);
          break;
        end;

      // restliche Parameter!
      SL_BBELEG_R := StrToIntDef(nextp(Scan, '-', 0), cRID_Null);

      // Plausibilisierung "BELEG_R"
      if (SL_BBELEG_R >= cRID_FirstValid) then
        if not(e_r_IsRID('BBELEG_R', SL_BBELEG_R)) then
          SL_BBELEG_R := cRID_Null;

      // Ganzen Scan loggen
      with qEREIGNIS do
      begin
        insert;
        FieldByName('ART').AsInteger := eT_BelegScan;
        FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
        EventText.add('Eingang ' + ganzerScan);
        if (SL_BBELEG_R >= cRID_FirstValid) then
          FieldByName('BBELEG_R').AsInteger := SL_BBELEG_R;
        FieldByName('INFO').assign(EventText);
        post;
      end;

      // Prüfung, ob VBELEG_R ok ist
      if (SL_BBELEG_R = cRID_Null) then
      begin
        ErrorMsg := 'Order ' + Scan + ' wurde nicht gefunden!';
        break;
      end;

      // Beleg-Daten nachladen
      with IB_Cursor1 do
      begin
        ParamByName('CROSSREF1').AsInteger := SL_BBELEG_R;
        open;
        if eof then
        begin
          ErrorMsg :=
          { } '* Dieser Beleg wurde zwischenzeitlich geändert.' + #13 +
          { } '* Oder es wurde noch kein Ausdruck gemacht.' + #13 +
          { } 'Er muss neu/erstmals ausgedruckt werden!'
        end
        else
        begin
          MENGE_ERWARTET := FieldByName('MENGE_ERWARTET').AsInteger;
          SL_Teillieferung := FieldByName('TEILLIEFERUNG').AsInteger;
        end;
        close;
      end;
      if (ErrorMsg <> '') then
        break;

      if (MENGE_ERWARTET = 0) then
      begin
        ErrorMsg := 'Die erwartete Menge des Order-Beleges ist 0!';
        break;
      end;

      // Ist es ein Plus-Scan?
      if pos('+', SL_ScanPrefix) > 0 then
      begin
        SL_LabelDruck := true;
        WinAmpPlayFile(SoundPath + 'plus.wav')
      end
      else
      begin
        WinAmpPlayFile(SoundPath + 'minus.wav');
      end;

      // Liste füllen
      SL_load(SL_BBELEG_R);
      SL_show;

    except
      on E: Exception do
      begin
        ErrorMsg := 'Systemfehler beim Buchen' + E.Message;
        break;
      end;
    end;

  until true;

  if (ErrorMsg <> '') then
  begin
    WinAmpPlayFile(SoundPath + 'ERROR.WAV');
    ShowMessageTimeOut(ErrorMsg, 10000);
  end
  else
  begin
    if iScannerAutoBuchen then
      doBuchen;
    Edit1.Text := '';
  end;

  qEREIGNIS.free;
  EventText.free;

end;

procedure TFormArtikelEingang.doBuchen;
var
  ErrorMsg: string;
  VERSENDER_R: Integer;
  VERSAND_R: Integer;
  EventText: TStringList;
  qEREIGNIS: TIB_Query;
begin
  BeginHourGlass;

  VERSENDER_R := cRID_Null;
  EventText := TStringList.create;
  qEREIGNIS := DataModuleDatenbank.nQuery;
  ErrorMsg := '';

  repeat

    if not(assigned(SCAN_LIST)) or (SL_BBELEG_R < cRID_FirstValid) then
    begin
      ErrorMsg :=
       { } 'Bitte erst eine Belegnummer scannen' + #13 +
       { } 'Oder in der Form' + #13 +
       { } '"+" | "-" ~Belegnummer~ "-" ~Generation~' + #13 +
       { } 'eingeben und mit <ENTER> abschliessen';
      break;
    end;

    // Scan "Beleg verbuchen"
    with qEREIGNIS do
    begin
      ColumnAttributes.add('RID=NOTREQUIRED');
      ColumnAttributes.add('AUFTRITT=NOTREQUIRED');
      sql.add('select * from EREIGNIS for update');
    end;

    // Verbuchen
    try

      // Beleg buchen / Ausgabe / Versand vorbereiten

    except
      on E: Exception do
      begin
        ErrorMsg := 'Systemfehler beim Buchen' + E.Message;
      end;
    end;

  until true;

  //
  qEREIGNIS.free;
  EventText.free;

  if (ErrorMsg <> '') then
  begin
    WinAmpPlayFile(SoundPath + 'ERROR.WAV');
    EndHourGlass;
    ShowMessage(ErrorMsg);
  end
  else
  begin
    WinAmpPlayFile(SoundPath + 'SUCCESS.WAV');
    SL_free;
    StaticText1.Color := cllime;
    StaticText1.Caption := '';
    EndHourGlass;
  end;

end;

procedure TFormArtikelEingang.doCheck;
var
  ScanFertig: boolean;
begin
  if assigned(SCAN_LIST) then
  begin

    // prüfen ob überhaupt die richtige Position
    DrawGrid1.row := rowBuchbar(DrawGrid1.row);

    if _rowBuchbar then
    begin

      // Position buchen
      ScanFertig := bucheArtikelScan(DrawGrid1.row);
      SL_reflect;
      if ScanFertig then
        SecureSetRow(DrawGrid1, min(DrawGrid1.row + 1,
          pred(DrawGrid1.RowCount)));
    end
    else
    begin
      WinAmpPlayFile(SoundPath + 'ERROR.WAV');
      ShowMessageTimeOut
        ('Sie versuchen zu viele Artikel barcodelos zu scannen', 8000);
    end;
  end;
end;

procedure TFormArtikelEingang.doCheckLess;
var
  ScanFertig: boolean;
begin
  if assigned(SCAN_LIST) then
  begin
    // Position buchen
    ScanFertig := bucheArtikelScan(DrawGrid1.row);
    SL_reflect;
    if ScanFertig then
      SecureSetRow(DrawGrid1, min(DrawGrid1.row + 1, pred(DrawGrid1.RowCount)));
  end;
end;

procedure TFormArtikelEingang.DrawGrid1DblClick(Sender: TObject);
begin
  doArtikelJump;
end;

procedure TFormArtikelEingang.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  Fokusiert: boolean;
  MENGE_ERWARTET, MENGE_SCAN, MENGE_REST: Integer;
  AUSGABEART_R: Integer;
  AUSGABEART_NAME, Artikel: string;
  GTIN: string;
  TXT: string;
  LASTONE: boolean;
begin
  if (ARow >= 0) then
    with DrawGrid1.canvas, IB_Cursor1 do
    begin

      Fokusiert := (ARow = DrawGrid1.row);

      if Fokusiert then
      begin
        brush.Color := HTMLColor2TColor($99CCFF);
      end
      else
      begin
        if odd(ARow) then
        begin
          brush.Color := clWhite;
        end
        else
        begin
          brush.Color := clListeGrauer;
        end;
      end;

      if assigned(SCAN_LIST) then
      begin

        repeat

         if (ARow<1) then
         begin
          LASTONE := false;
          break;
         end;

         if (ARow=SCAN_LIST.RowCount) then
         begin
          LASTONE := true;
          break;
         end;

         LASTONE :=
          {} SCAN_LIST.readCell(ARow,SCAN_LIST_BBELEG_R)<>
          {} SCAN_LIST.readCell(ARow+1,SCAN_LIST_BBELEG_R);

        until yet;

        case ACol of
          0:
            begin

              if (ARow > 0) then
              begin
                MENGE_ERWARTET := StrToIntDef(SCAN_LIST.readCell(ARow, SCAN_LIST_MENGE_ERWARTET), 0);
                MENGE_SCAN := StrToIntDef(SCAN_LIST.readCell(ARow, SCAN_LIST_MENGE_SCAN), 0);
                MENGE_REST := MENGE_ERWARTET - MENGE_SCAN;
                if (MENGE_ERWARTET > MENGE_SCAN) then
                begin
                  GTIN := SCAN_LIST.readCell(ARow, SCAN_LIST_GTIN);
                  if (GTIN <> sRID_NULL) then
                  begin
                    if (MENGE_SCAN > 0) then
                      brush.Color := HTMLColor2TColor($FF66FF)
                    else
                      brush.Color := HTMLColor2TColor($FF9966)
                  end
                  else
                    brush.Color := HTMLColor2TColor($9999FF);
                end
                else
                begin
                  brush.Color := HTMLColor2TColor($99FF99);
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
                    { } 'noch ' + IntTostr(MENGE_REST));
              end
              else
              begin
                font.size := 10;
                TextRect(Rect, Rect.left + 2, Rect.top, 'Anzahl');
              end;

              // draw(rect.left + 3, rect.top + 2, StatusBMPs[random(4)]); // Status
            end;
          1:begin
              // ARTIKEL
              // brush.color := HTMLColor2TColor($FFCC99);

              TXT := SCAN_LIST.readCell(ARow, ACol);
              if (ARow > 0) then
              begin
                if (pos(cLineSeparator, TXT) > 0) then
                begin
                  // Info Text unter dem Posten
                  font.size := 10;
                  TextRect(Rect, Rect.left + 2, Rect.top,
                    nextp(TXT, cLineSeparator, 0));
                  TextOut(
                    { } Rect.left + 2,
                    { } Rect.top + cPlanY,
                    { } nextp(TXT, cLineSeparator, 1));
                end
                else
                begin
                  AUSGABEART_R := StrToIntDef(SCAN_LIST.readCell(ARow, 5),
                    cRID_Null);

                  if (AUSGABEART_R >= cRID_FirstValid) then
                  begin
                    AUSGABEART_NAME := e_r_Ausgabeart(AUSGABEART_R);
                    Artikel := TXT;
                    ersetze(AUSGABEART_NAME, '', Artikel);
                    font.size := 10;
                    TextRect(Rect, Rect.left + 2, Rect.top, AUSGABEART_NAME);
                    font.size := 11;
                    font.Style := [fsbold];
                    TextOut(
                      { } Rect.left + 2,
                      { } Rect.top + cPlanY,
                      { } cutblank(Artikel));
                    font.Style := [];
                  end
                  else
                  begin
                    font.size := 11;
                    font.Style := [fsbold];
                    TextRect(Rect, Rect.left + 2,
                      Rect.top + (cPlanY div 2), TXT);
                    font.Style := [];
                  end;
                end;
              end
              else
              begin
                font.size := 10;
                TextRect(Rect, Rect.left + 2, Rect.top, TXT);
              end;
            end;
          2:begin
              font.size := 10;
              if (ARow>0) then
              begin
                TextRect(Rect, Rect.left + 2, Rect.top,
                {} e_r_LagerPlatzNameFromLAGER_R(
                {} StrToIntDef(
                {} SCAN_LIST.readCell(ARow, SCAN_LIST_LAGER),
                {} cRID_Null)));


                TextOut(Rect.left + 2, Rect.top + cPlanY,
                {} e_r_Verlag_PERSON_R (
                {} StrToIntdef(
                {} SCAN_LIST.readCell(ARow, SCAN_LIST_VERLAG),
                {} cRID_Null)));

              end else
              begin
                TextRect(Rect, Rect.left + 2, Rect.top,
                 {} SCAN_LIST.readCell(ARow, SCAN_LIST_LAGER) + '|' +
                 {} SCAN_LIST.readCell(ARow, SCAN_LIST_VERLAG) );
              end;
            end;
          3:begin
              font.size := 10;
              TextRect(Rect, Rect.left + 2, Rect.top,
                SCAN_LIST.readCell(ARow, SCAN_LIST_GTIN));
            end
        else
          // dummy Rand Zellen
          FillRect(Rect);
        end;

        // Grauer vertikaler Strich
        if (ACol > 0) then
        begin
          pen.Color := $A0A0A0;
          MoveTo(Rect.left, Rect.top);
          LineTo(Rect.left, Rect.bottom);
        end;

        // Endlinie für OrderBelege
        if LASTONE then
        begin
          pen.Color := clBlack;
          MoveTo(Rect.left, Rect.bottom);
          LineTo(Rect.right, Rect.bottom);
        end;

      end
      else
      begin
        // total leer!
        FillRect(Rect);
      end;
    end;
end;

procedure TFormArtikelEingang.ResizeDrawgrid1;
begin
  with DrawGrid1 do
  begin
    ColWidths[1] :=
     {} clientwidth -
     {} ColWidths[0] - ColWidths[2] - ColWidths[3] -
     {} (4 * 2 + ScrollBarWidth);
  end;
end;

procedure TFormArtikelEingang.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    'ß':
      Key := '-';
    '`':
      Key := '+';
    '´':
      Key := '+';
  end;
end;

procedure TFormArtikelEingang.FormActivate(Sender: TObject);
begin
  if not(initialized) then
  begin
    cPlanY := dpiX(16);
    ScrollBarWidth := GetSystemMetrics(SM_CXVSCROLL);
    with DrawGrid1, canvas do
    begin
      DefaultRowHeight := (cPlanY * 2) + dpiX(2);
      font.NAME := 'Courier New';
      font.Color := clblack;
      ColCount := 5;
      ColWidths[0] := dpiX(60);
      // ColWidths[1] := Artikel-Breite wird durch "ResizeDrawGrid1" gesetzt
      ColWidths[2] := dpiX(190); // Lager|Verlag
      ColWidths[3] := dpiX(120); // GTIN
      ColWidths[4] := 1;
      ResizeDrawGrid1;
      RowCount := 0;
    end;
    dgAutoSize(DrawGrid1, true);
    initialized := true;
  end;
end;

procedure TFormArtikelEingang.FormResize(Sender: TObject);
begin
  if initialized then
   ResizeDrawGrid1;
end;

procedure TFormArtikelEingang.hotEvent;
begin
  if not(active) then
  begin
    show;
    SetFocus;
  end;
  Edit1.SetFocus;
  Edit1.SelectAll;
  SetForeGroundWindow(handle);
end;

procedure TFormArtikelEingang.Image1Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Eingang');
end;

procedure TFormArtikelEingang.Button4Click(Sender: TObject);
var
  ServerDate: TANFiXDate;
  ServerTime: TANFiXTime;
  ServerDiff: TANFiXTime;
  MoreText: string;
begin
  //
  DateTime2long(e_r_Now, ServerDate, ServerTime);

  //
  ServerDiff := r_Local_vs_Server_TimeDifference;

  MoreText :=
    'Die lokale Zeitsynchronisation mit einem Zeit-Server muss extern aktiviert werden';

  ShowMessage(MoreText + #13 + 'Zeit dieses Rechners ' + long2date(DateGet) +
    ' ' + secondstostr(SecondsGet) + #13 + 'Zeit des Datenbankservers ' +
    long2date(ServerDate) + ' ' + secondstostr(ServerTime) + #13 + #13 +
    'bereinigte Differenz ' + secondstostr9(ServerDiff));
end;

procedure TFormArtikelEingang.RefreshSumme;
var
  MENGE_ERWARTET, MENGE_SCAN: Integer;
  SUMME: Integer;
begin
  if assigned(SCAN_LIST) then
  begin
    MENGE_ERWARTET := round(SCAN_LIST.sumCol('MENGE_ERWARTET'));
    MENGE_SCAN := round(SCAN_LIST.sumCol('MENGE_SCAN'));
    SUMME := MENGE_ERWARTET - MENGE_SCAN;
    if (SUMME = 0) then
    begin
      StaticText1.Color := clAqua;
      StaticText1.Caption := '0';
      Application.ProcessMessages;

      doBuchen;

    end
    else
    begin
      StaticText1.Color := clred;
      StaticText1.Caption := IntTostr(SUMME);
    end;
  end
  else
  begin
    StaticText1.Color := clBtnFace;
    StaticText1.Caption := '';
  end;
end;

procedure TFormArtikelEingang.ComboBox1Change(Sender: TObject);
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

procedure TFormArtikelEingang.SpeedButton1Click(Sender: TObject);
begin
//  openShell(cPersonPath(Selected_PERSON_R));
 ShowMessage('Noch keine Idee für diesen Knopf');
end;

procedure TFormArtikelEingang.SpeedButton2Click(Sender: TObject);
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

procedure TFormArtikelEingang.SpeedButton3Click(Sender: TObject);
begin
  SL_refresh;
  Edit1.SetFocus;
end;

function TFormArtikelEingang.bucheArtikelScan(row: Integer): boolean;
var
  MENGE_SCAN: Integer;
  MENGE_ERWARTET: Integer;
  MENGE_REST: Integer;

  ZUSAMMENHANG: Integer;
  ARTIKEL_R: Integer;
  AUSGABEART_R: Integer;
  BuchenOK: Boolean;

begin
  MENGE_ERWARTET := StrToIntDef(
   SCAN_LIST.readCell(row,
    SCAN_LIST_MENGE_ERWARTET), 0);
  MENGE_SCAN := StrToIntDef(SCAN_LIST.readCell(row, SCAN_LIST_MENGE_SCAN), 0);
  MENGE_REST := MENGE_ERWARTET - MENGE_SCAN;
  if (MENGE_REST > 0) then
  begin
    inc(MENGE_SCAN);
    SCAN_LIST.writeCell(row, SCAN_LIST_MENGE_SCAN, IntTostr(MENGE_SCAN));
    result := (MENGE_REST = 1);
  end
  else
  begin
    result := false;
  end;

  if result then
  begin
    // Scan jetzt als ganzes ausführen

    BeginHourGlass;

    ARTIKEL_R := StrToIntDef(SCAN_LIST.readCell(row, SCAN_LIST_ARTIKEL_R), cRID_Null);
    AUSGABEART_R := StrToIntDef(SCAN_LIST.readCell(row, SCAN_LIST_AUSGABEART_R), cRID_Null);

    if (e_w_SetFolge(AUSGABEART_R, ARTIKEL_R) > 1) then
      BuchenOK := FormFolgeSetzen.SetContext(AUSGABEART_R, ARTIKEL_R)
    else
     BuchenOK := true;

    if BuchenOK then
    begin
      ZUSAMMENHANG := e_w_Wareneingang(AUSGABEART_R, ARTIKEL_R, MENGE_SCAN);
      if (ZUSAMMENHANG = -1) then
        ShowMessage('Es gabe Fehler - siehe Log');
    end;

    EndHourGlass;
  end;

end;

function TFormArtikelEingang.rowRest(row: Integer): boolean;
var
  MENGE_SCAN: Integer;
  MENGE_ERWARTET: Integer;
begin
  MENGE_ERWARTET := StrToIntDef(SCAN_LIST.readCell(row,
    SCAN_LIST_MENGE_ERWARTET), 0);
  MENGE_SCAN := StrToIntDef(SCAN_LIST.readCell(row, SCAN_LIST_MENGE_SCAN), 0);
  result := (MENGE_SCAN < MENGE_ERWARTET);
end;

function TFormArtikelEingang.rowBuchbar(row: Integer): Integer;

  function good(row: Integer): boolean;
  begin
    result := rowRest(row);
    if result then
      result := (SCAN_LIST.readCell(row, SCAN_LIST_GTIN) = sRID_NULL)
  end;

var
  n: Integer;

begin
  _rowBuchbar := true;
  result := row;
  for n := row to pred(SCAN_LIST.count) do
    if good(n) then
      exit(n);
  for n := 1 to pred(row) do
    if good(n) then
      exit(n);
  _rowBuchbar := false;
end;

procedure TFormArtikelEingang.SpeedButton4Click(Sender: TObject);
begin
  doCheck;
  Edit1.SetFocus;
end;

procedure TFormArtikelEingang.SpeedButton5Click(Sender: TObject);
begin
  doCheckLess;
  Edit1.SetFocus;
end;

function TFormArtikelEingang.Selected_BBELEG_R: Integer;
var
  s: string;
begin
  if (ListBox1.ItemIndex <> -1) then
  begin
    // ##
    s := ListBox1.items[ListBox1.ItemIndex];
    result := StrToIntDef(nextp(copy(s, 2, MaxInt), '-', 0), 0);
  end
  else
  begin
    result := -1;
  end;
end;

function TFormArtikelEingang.Selected_PERSON_R: Integer;
var
  s: string;
  BBELEG_R: Integer;
begin
  if (ListBox1.ItemIndex <> -1) then
  begin
    // ##
    s := ListBox1.items[ListBox1.ItemIndex];
    BBELEG_R := StrToIntDef(nextp(copy(s, 2, MaxInt), '-', 0), 0);
    result := e_r_sql('select PERSON_R from BBELEG where RID=' +
      IntTostr(BBELEG_R));
  end
  else
  begin
    result := -1;
  end;
end;

procedure TFormArtikelEingang.SL_free;
begin
  DrawGrid1.RowCount := 0;
  FreeAndNil(SCAN_LIST);
end;

procedure TFormArtikelEingang.SL_load(BBELEG_R: Integer);
var
  PostenInfos: TStringList;
  LineA, LineB: string;
begin
  if assigned(SCAN_LIST) then
    SCAN_LIST.free;

  // Beleg Positionen
  SCAN_LIST := csTable(
    { } 'select ' +
    { 0 } ' BPOSTEN.MENGE_ERWARTET,' +
    { 1 } ' BPOSTEN.ARTIKEL,' +
    { 2 } ' coalesce(ARTIKEL_AA.GTIN, ARTIKEL.GTIN) as GTIN,' +
    { 3 } ' BPOSTEN.ARTIKEL_R,' +
    { 4 } ' 0 as MENGE_SCAN, ' +
    { 5 } ' BPOSTEN.AUSGABEART_R, ' +
    { 6 } ' ARTIKEL.LAGER_R as LAGER, ' +
    { 7 } ' ARTIKEL.VERLAG_R as VERLAG, ' +
    { 8 } ' BPOSTEN.BELEG_R, ' +
    { 9 } ' BPOSTEN.RID '+
    { } 'from BPOSTEN ' +
    { } 'left join ARTIKEL on' +
    { } ' (BPOSTEN.ARTIKEL_R=ARTIKEL.RID) ' +
    { } 'left join ARTIKEL_AA on' +
    { } ' (BPOSTEN.ARTIKEL_R=ARTIKEL_AA.ARTIKEL_R) and ' +
    { } ' (BPOSTEN.AUSGABEART_R=ARTIKEL_AA.AUSGABEART_R) ' +
    { } 'where' +
    { } ' (BPOSTEN.MENGE_ERWARTET>0)' +
    { } 'order by' +
    { } ' BPOSTEN.BELEG_R,BPOSTEN.POSNO,BPOSTEN.RID');

  // Info Positionen
  PostenInfos := e_r_sqlsl(
    { } 'select' +
    { } ' INFO ' +
    { } 'from' +
    { } ' BBELEG ' +
    { } 'where' +
    { } ' RID=' + IntTostr(BBELEG_R));

  // delete leading empty lines
  repeat
    if (PostenInfos.count > 0) then
    begin
      if (noblank(PostenInfos[0]) = '') then
        PostenInfos.delete(0)
      else
        break;
    end
    else
    begin
      break;
    end;
  until false;

  // Fülle Doppel-Zeilen
  repeat

    // 1. Zeile
    if (PostenInfos.count = 0) then
      break;
    LineA := PostenInfos[0];
    PostenInfos.delete(0);

    // 2. Zeile
    if (PostenInfos.count > 0) then
    begin
      LineB := PostenInfos[0];
      PostenInfos.delete(0);
    end
    else
    begin
      LineB := '';
    end;

    SCAN_LIST.addRow(split(
      { 0 } '1;' +
      { 1 } nosemi(LineA) + cLineSeparator + nosemi(LineB) + ';' +
      { 2 } 'INFO;' +
      { 3 } ';' +
      { 4 } '0;' +
      { 5 } ''));

  until false;

  //
  PostenInfos.free;

  SL_BBELEG_R := BBELEG_R;
  if DebugMode then
    SCAN_LIST.SaveToFile(DiagnosePath + 'EINGANG_SCAN_LIST.csv');

end;

procedure TFormArtikelEingang.SL_reflect;
begin
  DrawGrid1.Refresh;
  RefreshSumme;
end;

procedure TFormArtikelEingang.SL_refresh;
begin
  BeginHourGlass;
  if assigned(SCAN_LIST) then
    FreeAndNil(SCAN_LIST);
  SL_load(SL_BBELEG_R);
  SL_show;
  EndHourGlass;
end;

procedure TFormArtikelEingang.SL_show;
begin
  with DrawGrid1 do
  begin
    RowCount := SCAN_LIST.RowCount + 1;
    FixedRows := 1;
    RowHeights[0] := cPlanY + dpiX(2);
    row := 1;
    Refresh;
  end;
  RefreshSumme;
end;

procedure TFormArtikelEingang.Button5Click(Sender: TObject);
begin
//  FormBBelege.SetContext(0, Selected_BBELEG_R);
 if assigned(SCAN_LIST) then
  FormBBelege.SetContext(
   {} 0,
   {} StrToIntDef(SCAN_LIST.readCell(Drawgrid1.Row,SCAN_LIST_BBELEG_R),cRID_Null),
   {} StrToIntDef(SCAN_LIST.readCell(Drawgrid1.Row,SCAN_LIST_BPOSTEN_R),cRID_Null));
end;

procedure TFormArtikelEingang.Button6Click(Sender: TObject);
begin
//  FormPerson.SetContext(Selected_PERSON_R);
 ShowMessage('Noch keine Idee für diesen Knopf');
end;

procedure TFormArtikelEingang.Button7Click(Sender: TObject);
begin
  doArtikelJump;
end;


end.
