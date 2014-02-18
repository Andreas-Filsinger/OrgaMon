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
unit TagWache;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  CheckLst, ComCtrls, anfix32,
  ExtCtrls;

type
  TFormTagWache = class(TForm)
    ProgressBar1: TProgressBar;
    CheckListBox1: TCheckListBox;
    Button1: TButton;
    Label1: TLabel;
    Timer1: TTimer;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckListBox1DblClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FirstTimerEventChecked: boolean;
    Tagwache_TAN: integer;

    procedure Log(s: string);
  public
    { Public-Deklarationen }
    _TagWache: TAnfixTime;
    FlipFlop: integer;

    //
    LetzteTagWacheWarAm: TAnfixDate;
    LetzteTagWacheWarUm: TAnfixTime;

    function TagwacheAktiv: boolean;
    procedure EofTagwache;

  end;

var
  FormTagWache: TFormTagWache;

implementation

uses
  globals, Datenbank,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  CareTakerClient,
  AuftragMobil, AuftragErgebnis, OLAPArbeitsplatz,
  BaseUpdate, Datensicherung, IBEXportTable,
  wanfix32,
  OLAP, Baustelle, BestellArbeitsplatz, AuftragImport;

{$R *.DFM}

procedure TFormTagWache.Button1Click(Sender: TObject);
var
  n, m: integer;
  ErrorCount: integer;
  Ticket: TTroubleTicket;
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
    LetzteTagWacheWarAm := DateGet;
    LetzteTagWacheWarUm := SecondsGet;
    Tagwache_TAN := e_w_gen('GEN_TAGWACHE');
    ProgressBar1.max := CheckListBox1.items.count;
    Ticket := CareTakerLog('TagWache START');
    ErrorCount := 0;
    Log('Start am ' + long2date(LetzteTagWacheWarAm) + ' um ' +
      secondstostr(LetzteTagWacheWarUm) + ' h auf ' + ComputerName);

    _TagWache := iTagWacheUm;
    iTagWacheUm := 0;
    Button1.caption := '&Abbruch';
    for n := 0 to pred(CheckListBox1.items.count) do
    begin
      ProgressBar1.position := n;
      if not(CheckListBox1.checked[n]) then
      begin
        try
          Log( { } 'Beginne Aktion "' +
            { } CheckListBox1.items[n] + '" um ' +
            { } secondstostr(SecondsGet) + ' h');

          case n of
            0:
              FormAuftragMobil.ReadMobil;
            1:
              e_w_GrabFotos;
            2:
              FormAuftragErgebnis.UploadNewTANS;
            3:
              if (iTagwacheBaustelle >= cRID_FirstValid) then
              begin

                // Baustelle ablegen
                with FormBaustelle do
                begin
                  Show;
                  if IB_Query1.Locate('RID',iTagwacheBaustelle , []) then
                  begin
                    AutoYES := true;
                    Button7Click(self);
                  end;
                  Close;
                end;

                // WE frisch erzeugen!
                FormBestellArbeitsplatz.MobilExport;

                // Import-Schema laden
                with FormAuftragImport do
                begin
                  SetContext(iTagwacheBaustelle);
                  DoImport;
                  Close;
                end;

                //

              end;
            4:
              FormAuftragMobil.WriteMobil;
            5:
              begin
                FormOLAPArbeitsplatz.TagWache;
              end;
            6:
              begin
                // Context-OLAPs
                FormOLAP.DoContextOLAP(iSystemOLAPPath + 'Tagwache.*' +
                  cOLAPExtension);
              end;
          else
            delay(2000);
          end;
        except
          on e: exception do
          begin
            inc(ErrorCount);
            Log(cERRORText + ' TagWache Exception ' + e.message);
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
    iTagWacheUm := _TagWache;
    Button1.caption := '&Start';
    if (ErrorCount > 0) then
      Log(cERRORText + ' TagWache FAIL at Stage ' + inttostr(n));
    CareTakerClose(Ticket);
    Log('Ende um ' + secondstostr(SecondsGet) + ' h');

    // Tagwache-OLAPs ausführen
    FormOLAP.DoContextOLAP(iSystemOLAPPath + 'System.Tagwache.*' +
      cOLAPExtension);

    EofTagwache;
    EndHourGlass;

    // Aktionen NACH der Tagwache
    repeat

      // Anwendung neu starten
      if iNachTagwacheAnwendungNeustart then
      begin
        FormBaseUpdate.RestartApplication;
        break;
      end;

      // Rechner herunterfahren
      if iNachTagWacheHerunterfahren then
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

procedure TFormTagWache.FormActivate(Sender: TObject);
var
  n: integer;
begin
  if not(TagwacheAktiv) then
    for n := 0 to pred(CheckListBox1.items.count) do
      CheckListBox1.checked[n] := false;
  if (AnsiUpperCase(ComputerName) = AnsiUpperCase(iTagWacheAuf)) then
    Label1.caption := 'automatisch um ' + secondstostr5(iTagWacheUm) +
      ' hier auf ' + iTagWacheAuf
  else
    Label1.caption := 'automatisch um ' + secondstostr5(iTagWacheUm) + ' auf ' +
      iTagWacheAuf;
end;

procedure TFormTagWache.Log(s: string);
begin
  try
    AppendStringsToFile(s, DiagnosePath + 'Tagwache-' + inttostrN(Tagwache_TAN,
      8) + '.log.txt');

    if (pos(cERRORText, s) > 0) then
      CareTakerLog(s);
  except
    // nichts tun!
  end;
end;

procedure TFormTagWache.Timer1Timer(Sender: TObject);
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
      Label2.caption := 'läuft seit ' +
        secondstostr(SecondsDiff(SecondsGet, LetzteTagWacheWarUm)) + 'h';
      cPanelActive := clyellow; // läuft
      break;
    end;

    if (LetzteTagWacheWarAm > 0) then
    begin
      BeendetSeit := SecondsDiff(DateGet, SecondsGet, LetzteTagWacheWarAm,
        LetzteTagWacheWarUm);
      if (BeendetSeit < 60) then
      begin
        // lief kürzlich
        Label2.caption := 'beendet seit ' + secondstostr(BeendetSeit) + 'h';
        cPanelActive := clAqua;
        break;
      end;
    end;

    if not(isParam('TagWache')) then
    begin

      if AnsiUpperCase(ComputerName) <> AnsiUpperCase(iTagWacheAuf) then
      begin
        Label2.caption := 'nicht hier';
        cPanelActive := clred; // nicht vorgesehen
        break;
      end;

      if (iTagWacheWochentage <> '') then
      begin
        if (pos(WeekDayS(DateGet), iTagWacheWochentage) = 0) then
        begin
          Label2.caption := 'heute nicht (nur ' + iTagWacheWochentage + ')';
          cPanelActive := clred; // nicht vorgesehen
          break;
        end;
      end;

      _CountDown := abs(SecondsDiff(iTagWacheUm, SecondsGet));
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

function TFormTagWache.TagwacheAktiv: boolean;
begin
  result := (Tagwache_TAN >= cRID_FirstValid);
end;

procedure TFormTagWache.CheckListBox1DblClick(Sender: TObject);
var
  i: integer;
begin
  with Sender as TCheckListBox do
    for i := 0 to pred(items.count) do
      checked[i] := true;
end;

procedure TFormTagWache.EofTagwache;
begin
  Tagwache_TAN := cRID_null;
end;

end.
