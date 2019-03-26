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
unit Tagwache;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  CheckLst, ComCtrls, anfix32,
  ExtCtrls;

type
  TFormTagwache = class(TForm)
    ProgressBar1: TProgressBar;
    CheckListBox1: TCheckListBox;
    Button1: TButton;
    Label1: TLabel;
    Timer1: TTimer;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckListBox1DblClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
    FirstTimerEventChecked: boolean;
    MainFormInformed: boolean;
    Tagwache_TAN: integer;

    procedure Log(s: string);
  public
    { Public-Deklarationen }
    _Tagwache: TAnfixTime;
    FlipFlop: integer;

    //
    LetzteTagwacheWarAm: TAnfixDate;
    LetzteTagwacheWarUm: TAnfixTime;

    function TagwacheAktiv: boolean;
    procedure EofTagwache;

  end;

var
  FormTagwache: TFormTagwache;

implementation

uses
  globals, wanfix32, CareTakerClient,
  Datenbank,

  Funktionen_Basis, Funktionen_Beleg, Funktionen_Auftrag,
  AuftragMobil, AuftragErgebnis, OLAPArbeitsplatz,
  BaseUpdate, Datensicherung, dbOrgaMon,

  OLAP, Baustelle, BestellArbeitsplatz, AuftragImport, main;

{$R *.DFM}

procedure TFormTagwache.Button1Click(Sender: TObject);
var
  n: integer;
  ErrorCount: integer;
  GlobalVars: TStringList;
begin
  if TagwacheAktiv then
  begin
    Log(cERRORText + ' Benutzer Abbruch');
    EofTagwache;
    Button1.caption := 'Abbruch ...';
    application.processmessages;
  end
  else
  begin
    BeginHourGlass;
    NoTimer := true;
    LetzteTagwacheWarAm := DateGet;
    LetzteTagwacheWarUm := SecondsGet;
    Tagwache_TAN := e_w_gen('GEN_TAGWACHE');
    ProgressBar1.max := CheckListBox1.items.count;
    ErrorCount := 0;
    Log('Start am ' + long2date(LetzteTagwacheWarAm) + ' um ' + secondstostr(LetzteTagwacheWarUm) + ' h auf ' +
      ComputerName);

    _Tagwache := iTagwacheUm;
    iTagwacheUm := 0;
    Button1.caption := '&Abbruch';
    for n := 0 to pred(CheckListBox1.items.count) do
    begin
      ProgressBar1.position := n;
      if not(CheckListBox1.checked[n]) then
      begin
        CheckListBox1.itemindex := n;
        application.processmessages;
        try

          if (pos(IntToStr(succ(n))+',',iTagwacheAusschluss)>0) then
          begin
            Log( { } 'Ausschluss Aktion "' +
                 { } CheckListBox1.items[n] + '"');
            continue;
          end;

          Log( { } 'Beginne Aktion "' +
            { } CheckListBox1.items[n] + '" um ' +
            { } secondstostr(SecondsGet) + ' h');

          case n of
            0:
              e_w_FotoDownload.Free;
            1:
              FormAuftragMobil.ReadMobil;
            2:
              e_w_Ergebnis(cRID_Unset);
            3:
              if (iTagwacheBaustelle >= cRID_FirstValid) then
              begin

                // Baustelle ablegen
                with FormBaustelle do
                begin
                  Show;
                  if IB_Query1.Locate('RID', iTagwacheBaustelle, []) then
                  begin
                    AutoYES := true;
                    Button7Click(self);
                  end;
                  Close;
                end;

                // WE frisch erzeugen!
                e_r_Bewegungen;

                // Import-Schema laden, neu Aufbauen
                e_w_Import(iTagwacheBaustelle);
                (* imp pend:
                 Prüfen, ob alles so gemacht wird:
                with FormAuftragImport do
                begin
                  SetContext(iTagwacheBaustelle);
                  Close;
                end;
                *)
              end;
            4:
              FormAuftragMobil.WriteMobil;
            5:
              e_r_Sync_AuftraegeAlle;
            6:
              begin
                FormOLAPArbeitsplatz.Tagwache;
              end;
            7:
              begin
                // Context-OLAPs
                GlobalVars := TStringList.Create;
                GlobalVars.add('$ExcelOpen=' + cINI_Deactivate);
                FormOLAP.DoContextOLAP(
                  { } iSystemOLAPPath + 'Tagwache.*' + cOLAPExtension,
                  { } GlobalVars);
                GlobalVars.free;
              end;
          else
            delay(2000);
          end;
        except
          on e: exception do
          begin
            inc(ErrorCount);
            Log(cERRORText + ' Tagwache Exception ' + e.message);
          end;
        end;
        if (ErrorCount = 0) then
          CheckListBox1.checked[n] := true;
        application.processmessages;
        if not(TagwacheAktiv) or (ErrorCount > 0) then
          break;
      end;
    end;
    ProgressBar1.position := 0;
    iTagwacheUm := _Tagwache;
    Button1.caption := '&Start';
    if (ErrorCount > 0) then
      Log(cERRORText + ' Tagwache FAIL at Stage ' + inttostr(n));
    Log('Ende um ' + secondstostr(SecondsGet) + ' h');

    // Tagwache-OLAPs ausführen
    FormOLAP.DoContextOLAP(iSystemOLAPPath + 'System.Tagwache.*' + cOLAPExtension);

    EofTagwache;
    EndHourGlass;

    // Aktionen NACH der Tagwache
    repeat

      // Anwendung neu starten
      if iNachTagwacheAnwendungNeustart then
      begin
        FormBaseUpdate.RestartOrgaMon;
        break;
      end;

      // Rechner herunterfahren
      if iNachTagwacheHerunterfahren then
      begin
        WindowsHerunterfahren;
        break;
      end;

      // Rechner neu starten
      if iNachTagwacheRechnerNeustarten then
      begin
        FormBaseUpdate.CloseOtherInstances;
        delay(1000);
        WindowsNeuStarten;
        break;
      end;

      // normal weitermachen ...
      if (ErrorCount = 0) then
        for n := 0 to pred(CheckListBox1.items.count) do
          CheckListBox1.checked[n] := false;
      Close;
      NoTimer := false;
    until true;
  end;
end;

procedure TFormTagwache.FormActivate(Sender: TObject);
var
  n: integer;
begin
  if not(TagwacheAktiv) then
    for n := 0 to pred(CheckListBox1.items.count) do
      CheckListBox1.checked[n] := false;
  if (AnsiUpperCase(ComputerName) = AnsiUpperCase(iTagwacheAuf)) then
    Label1.caption := 'automatisch um ' + secondstostr5(iTagwacheUm) + ' hier auf ' + iTagwacheAuf
  else
    Label1.caption := 'automatisch um ' + secondstostr5(iTagwacheUm) + ' auf ' + iTagwacheAuf;
end;

procedure TFormTagwache.Log(s: string);
begin
  try
    AppendStringsToFile(s, DiagnosePath + 'Tagwache-' + inttostrN(Tagwache_TAN, 8) + '.log.txt');

    if (pos(cERRORText, s) > 0) then
      AppendStringsToFile(s,ErrorFName('TAGWACHE'), Uhr8);
  except
    // nichts tun!
  end;
end;

procedure TFormTagwache.Timer1Timer(Sender: TObject);
var
  cPanelActive: TColor;
  _CountDown: integer;
  BeendetSeit: TAnfixTime;
begin
  if not(AllSystemsRunning) then
    exit;

  if not(TagwacheAktiv) and NoTimer then
    exit;

  if not(FirstTimerEventChecked) then
  begin
    FirstTimerEventChecked := true;
    if pDisableTagwache then
      Timer1.enabled := false;
    exit;
  end;

  cPanelActive := clAqua;
  repeat

    if TagwacheAktiv then
    begin
      Label2.caption := 'läuft seit ' + secondstostr(SecondsDiff(SecondsGet, LetzteTagwacheWarUm)) + 'h';
      cPanelActive := clyellow; // läuft
      break;
    end;

    if (LetzteTagwacheWarAm > 0) then
    begin
      BeendetSeit := SecondsDiff(DateGet, SecondsGet, LetzteTagwacheWarAm, LetzteTagwacheWarUm);
      if (BeendetSeit < 60) then
      begin
        // lief kürzlich
        Label2.caption := 'beendet seit ' + secondstostr(BeendetSeit) + 'h';
        cPanelActive := clAqua;
        break;
      end;
    end;

    if not(isParam('Tagwache')) then
    begin

      if AnsiUpperCase(ComputerName) <> AnsiUpperCase(iTagwacheAuf) then
      begin
        Label2.caption := 'nicht hier';
        cPanelActive := clred; // nicht vorgesehen
        Timer1.enabled := false;
        break;
      end;

      if not(MainFormInformed) then
      begin
        FormMain.Panel4.color := cllime;
        MainFormInformed := true;
      end;

      if (iTagwacheWochentage <> '') then
      begin
        if (pos(WeekDayS(DateGet), iTagwacheWochentage) = 0) then
        begin
          Label2.caption := 'heute nicht da ∉ [' + iTagwacheWochentage + ']';
          cPanelActive := clred; // nicht vorgesehen
          break;
        end;
      end;

      _CountDown := abs(SecondsDiff(iTagwacheUm, SecondsGet));
      if (_CountDown > 10) then
      begin
        Label2.caption := 'in ' + secondstostr(_CountDown) + 'h';
        cPanelActive := cllime;
        break;
      end;

    end;

    // !! Start !!
    Label2.caption := 'läuft';
    Show;
    Button1.Click;

  until true;

  inc(FlipFlop);
  if (FlipFlop mod 2 = 0) then
    Panel1.color := clblack
  else
    Panel1.color := cPanelActive;

end;

function TFormTagwache.TagwacheAktiv: boolean;
begin
  result := (Tagwache_TAN >= cRID_FirstValid);
end;

procedure TFormTagwache.Button2Click(Sender: TObject);
var
  n: integer;
begin
  for n := 0 to pred(CheckListBox1.items.Count) do
    CheckListBox1.checked[n] := true;
end;

procedure TFormTagwache.CheckListBox1DblClick(Sender: TObject);
var
  i: integer;
begin
  with Sender as TCheckListBox do
    for i := 0 to pred(items.count) do
      checked[i] := true;
end;

procedure TFormTagwache.EofTagwache;
begin
  Tagwache_TAN := cRID_null;
end;

end.
