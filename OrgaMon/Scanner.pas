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
  StdCtrls, IB_Components, IB_Access,
  anfix32, ExtCtrls,
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
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private-Deklarationen }

    function Selected_BELEG_R: integer;
    function Selected_PERSON_R: integer;

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
  globals, winamp,
  Funktionen_Basis,
  Funktionen_Beleg,
  CareTakerClient, Belege, Person,
  Main, dbOrgaMon, VersenderPaketID,
  SysHot, wanfix32;
{$R *.dfm}

procedure TFormScanner.Button1Click(Sender: TObject);
var
  GanzerScan, Scan: string;
  ErrorMsg: string;
  LOGO: string;
  BELEG_R: integer;
  GENERATION: integer;
  MENGE_RECHNUNG: integer;
  EventText: TStringList;
  n: integer;
  LabelDruck: boolean;
  VERSENDER_R: integer;
  VERSAND_R: integer;
  TEILLIEFERUNG: integer;
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
        VERSENDER_R := e_r_sql
          ('select RID from VERSENDER where LOGO=''' + LOGO + '''');

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
      VERSAND_R := e_r_sql('select RID from VERSAND where' +
        ' (BELEG_R=' + inttostr(BELEG_R) + ') and' + ' (TEILLIEFERUNG=' +
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

function TFormScanner.Selected_BELEG_R: integer;
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

function TFormScanner.Selected_PERSON_R: integer;
var
  s: string;
  BELEG_R: integer;
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

procedure TFormScanner.Button5Click(Sender: TObject);
begin
  FormBelege.SetContext(0, Selected_BELEG_R);
end;

procedure TFormScanner.Button6Click(Sender: TObject);
begin
  FormPerson.SetContext(Selected_PERSON_R);
end;

end.
