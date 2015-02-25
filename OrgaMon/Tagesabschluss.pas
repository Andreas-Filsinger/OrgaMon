{
  |������___                  __  __
  |�����/ _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |����| | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |����| |_| | | | (_| | (_| | |  | | (_) | | | |
  |�����\___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |���������������|___/
  |
  |    Copyright (C) 2007 - 2014 Andreas Filsinger
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
unit Tagesabschluss;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  CheckLst, ComCtrls, anfix32,
  ExtCtrls;

type
  TFormTagesAbschluss = class(TForm)
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
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
    FirstTimerEventChecked: boolean;
    MainFormInformed: boolean;
    TagesAbschluss_TAN: integer;

    procedure Log(s: string);
  public
    { Public-Deklarationen }
    _TagesAbschluss: TAnfixTime;
    FlipFlop: integer;
    //
    LetzerTagesAbschlussWarAm: TAnfixDate;
    LetzerTagesAbschlussWarUm: TAnfixTime;

    function TagesabschlussAktiv: boolean;
    procedure Tagesabschluss;
    procedure EofTagesabschluss;
  end;

var
  FormTagesAbschluss: TFormTagesAbschluss;

implementation

uses
  globals, wanfix32, InfoZip,
  Datenbank,

  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_LokaleDaten,
  Funktionen_Auftrag,

  Datensicherung, Person, CreatorMain,
  VersenderPaketID, ArtikelSuchindex, NatuerlicheResourcen,
  Replikation, CareTakerClient, Musiker,
  BaseUpdate, Tier, Mahnung,
  AuftragMobil, AuftragExtern, AuftragSuchindex,
  WebShopConnector, Buchhalter, OLAP,
  dbOrgaMon, main;

{$R *.DFM}

procedure FilesLimit(Mask: string; LimitTo: integer; ZipCount: integer);
var
  sDir: TStringList;
  n: integer;
  Path: string;
begin
  sDir := TStringList.Create;
  dir(Mask, sDir, false);
  if (sDir.Count >= LimitTo) then
  begin
    Path := ExtractFilePath(Mask);
    sDir.Sort;
    for n := pred(sDir.Count) downto ZipCount do
      sDir.Delete(n);
    if (zip(
      { } sDir,
      { } Path + sDir[pred(sDir.Count)] + cZIPExtension,
      { } infozip_RootPath + '=' + Path) =
      { } sDir.Count) then
    begin
      for n := 0 to pred(sDir.Count) do
        DeleteFile(Path + sDir[n]);
    end;
  end;
  sDir.Free;
end;

procedure TFormTagesAbschluss.Log(s: string);
begin
  try
    AppendStringsToFile(s, DiagnosePath + 'Tagesabschluss-' +
      inttostrN(TagesAbschluss_TAN, 8) + '.log.txt');

    if (pos(cERRORText, s) > 0) then
      CareTakerLog(s);
  except
    // nichts tun!
  end;
end;

procedure TFormTagesAbschluss.Button1Click(Sender: TObject);
var
  n: integer;
  TimeDiff: TAnfixTime;
  ErrorCount: integer;
  Ticket: TTroubleTicket;
begin
  if TagesabschlussAktiv then
  begin
    Log(cERRORText + ' Tagesabschluss: Abbruch');
    EofTagesabschluss;
    Button1.caption := 'Abbruch ...';
    application.processmessages;
  end
  else
  begin
    BeginHourGlass;
    NoTimer := true;

    TagesAbschluss_TAN := FormDatensicherung.GENID;
    LetzerTagesAbschlussWarAm := DateGet;
    LetzerTagesAbschlussWarUm := SecondsGet;
    Log('Start am ' + long2date(LetzerTagesAbschlussWarAm) + ' um ' +
      secondstostr(LetzerTagesAbschlussWarUm) + ' h auf ' + ComputerName);

    SetPriorityClass(GetCurrentProcess, DWORD(IDLE_PRIORITY_CLASS));
    ProgressBar1.max := CheckListBox1.items.Count;
    Ticket := CareTakerLog('Tagesabschluss START');
    Log('Ticket ' + inttostr(Ticket) + ' erhalten');
    ErrorCount := 0;

    _TagesAbschluss := iTagesAbschlussUm;
    iTagesAbschlussUm := 0;
    Button1.caption := '&Abbruch';

    for n := 0 to pred(CheckListBox1.items.Count) do
    begin
      ProgressBar1.position := n;
      if not(CheckListBox1.checked[n]) and TagesabschlussAktiv then
      begin
        CheckListBox1.itemindex := n;
        application.processmessages;
        try
          Log( { } 'Beginne Aktion "' +
            { } CheckListBox1.items[n] + '" um ' +
            { } secondstostr(SecondsGet) + ' h');
          case n of
            0:
              if not(FormDatensicherung.BackUp(TagesAbschluss_TAN)) then
                raise Exception.Create('Datenbanksicherung erfolglos');
            1:
              begin
                // normale Gesamt-Sicherung
                if (iSicherungenAnzahl <> -1) then
                  if not(FormDatensicherung.doCompress(TagesAbschluss_TAN)) then
                    raise Exception.Create('Gesamtsicherung erfolglos');
              end;
            2:
              begin
                // Dateien verschieben, die zu lange ausser Gebrauch sind!
                if iAblage then
                  FormDatensicherung.do400(TagesAbschluss_TAN);

                // Datei-L�schungen
                FileDelete(DiagnosePath + '*', 20);
                FileDelete(MyProgramPath + 'Bestellungskopie\*', 30);
                FileDelete(UpdatePath + '*', 30, 3);
                FileDelete(WordPath + '*.csv', 10);
                FileDelete(WordPath + '*.html', 10);
                FileDelete(MyProgramPath + cRechnungsKopiePath + '*', 90);
                if (iSchnelleRechnung_PERSON_R >= cRID_FirstValid) then
                  FilesLimit(MyProgramPath + cRechnungPath +
                    RIDasStr(iSchnelleRechnung_PERSON_R) + '\*' +
                    cHTMLextension, 2000, 1500);

                if (DatensicherungPath <> '') then
                  FileDelete(DatensicherungPath + '*', 3, 3);
                if (iTranslatePath <> '') then
                  if (pos(';', iTranslatePath) = 0) then
                    FileDelete(iTranslatePath + iSicherungsPrefix + '*', 10);
                FileDelete(WebPath + '*', 10);
                FileDelete(cAuftragErgebnisPath + '*', 5);

                // Verzeichnis L�schungen
                DirDelete(ImportePath + '*', 10);

              end;
            3:
              FormVersenderPaketID.Execute;
            4:
              begin
                // sich selbst enthaltende Kollektionen l�schen!
                e_x_sql('delete from ARTIKEL_MITGLIED where (MASTER_R=ARTIKEL_R)');

                // Context-OLAPs
                FormOLAP.DoContextOLAP(iSystemOLAPPath + 'Tagesabschluss.*' +
                  cOLAPExtension);

              end;
            5:
              begin
                if iReplikation then
                  FormReplikation.Execute;
              end;
            6:
              begin
                FormAuftragMobil.ReadMobil;
                FormAuftragMobil.WriteMobil;
              end;
            7:
              begin
                // F�r den Foto Server
                e_r_Sync_AuftraegeAlle;

                // F�r externe Auftrags-Routen
                if not(FormAuftragExtern.DoJob) then
                  Log(cERRORText + ' AuftragExtern fail');
              end;
            8:
              if (iShopKey <> '') then
                if not(FormWebShopConnector.doMediumBuilder) then
                  Log(cERRORText + ' Medium Upload fail');
            9:
              if (iShopKey <> '') then
                if not(FormWebShopConnector.doContenBuilder) then
                  Log(cERRORText + ' Content Upload fail');
            10:
              if (iKontenHBCI <> '') then
                FormBuchhalter.e_w_KontoSync(iKontenHBCI);
            11:
              ReBuild;
            12:
              FormAuftragSuchindex.ReCreateTheIndex;
            13:
              if iTagesabschlussRang then
                e_d_Rang;
            14:
              e_d_Lieferzeit;
            15:
              PersonSuchindex;
            16:
              FormCreatorMain.CreateSearchIndex;
            17:
              FormMusiker.CreateTheIndex;
            18:
              FormTier.CreateIndex;
            19:
              begin
                FormArtikelSuchIndex.show;
                FormArtikelSuchIndex.Button1Click(self);
              end;
            20:
              begin
                FormNatuerlicheResourcen.Execute;
              end;
            21:
              e_w_LagerFreigeben;
            22:
              begin
                e_x_BelegAusPOS;
                e_d_Belege;
              end;
            23:
              if iMahnlaufbeiTagesabschluss then
              begin
                if e_w_NeuerMahnlauf then
                begin
                  if not(FormMahnung.Execute(TagesAbschluss_TAN)) then
                    Log(cERRORText +
                      ' kein neuer Mahnlauf m�glich, da noch Fehler abgearbeitet werden m�ssen!');
                end
                else
                  Log(cERRORText +
                    ' kein neuer Mahnlauf m�glich, da noch teilweise "Brief" angekreuzt ist!');
              end;
            24:
              e_w_VertragBuchen;
            25:
              begin
                TimeDiff := r_Local_vs_Server_TimeDifference;
                if (TimeDiff <> 0) then
                  Log(cERRORText +
                    format(' Abweichung der lokalen Zeit zu der des DB-Servers ist %d Sekunde(n)!',
                    [TimeDiff]));
              end;
            26:
              begin
                Nachmeldungen;
              end;
          else
            delay(2000);
          end;
        except
          on e: Exception do
          begin
            inc(ErrorCount);
            Log(cERRORText + ' Tagesabschluss Exception ' + e.message);
          end;
        end;

        application.processmessages;
        CheckListBox1.checked[n] := (ErrorCount = 0);
        if not(TagesabschlussAktiv) or (ErrorCount > 0) then
          break;
      end;
    end;
    ProgressBar1.position := 0;
    iTagesAbschlussUm := _TagesAbschluss;
    Button1.caption := '&Start';
    if (ErrorCount > 0) then
      Log(cERRORText + ' Tagesabschluss FAIL at Stage ' + inttostr(n));
    CareTakerClose(Ticket);
    SetPriorityClass(GetCurrentProcess, DWORD(NORMAL_PRIORITY_CLASS));
    Log('Ende um ' + secondstostr(SecondsGet) + ' h');

    FormOLAP.DoContextOLAP(iSystemOLAPPath + 'System.Tagesabschluss.*' +
      cOLAPExtension);
    EofTagesabschluss;

    EndHourGlass;

    // Aktionen NACH dem Tagesabschluss
    repeat

      // Anwendung neu starten
      if iNachTagesAbschlussAnwendungNeustart then
      begin
        FormBaseUpdate.RestartApplication;
        break;
      end;

      // Rechner abschalten
      if iNachTagesAbschlussHerunterfahren then
      begin
        WindowsHerunterfahren;
        break;
      end;

      // Rechner neu starten
      if iNachTagesAbschlussRechnerNeustarten then
      begin
        FormBaseUpdate.CloseOtherInstances;
        delay(1000);
        WindowsNeuStarten;
        break;
      end;

      // Normal weitermachen
      NoTimer := false;
      close;

    until true;

  end;
end;

procedure TFormTagesAbschluss.FormActivate(Sender: TObject);
var
  n: integer;
begin
  if not(TagesabschlussAktiv) then
    for n := 0 to pred(CheckListBox1.items.Count) do
      CheckListBox1.checked[n] := false;

  if (AnsiUpperCase(ComputerName) = AnsiUpperCase(iTagesAbschlussAuf)) then
    Label1.caption := 'automatisch um ' + secondstostr5(iTagesAbschlussUm) +
      ' hier auf ' + iTagesAbschlussAuf
  else
    Label1.caption := 'automatisch um ' + secondstostr5(iTagesAbschlussUm) +
      ' auf ' + iTagesAbschlussAuf;
end;

procedure TFormTagesAbschluss.Timer1Timer(Sender: TObject);
var
  cPanelActive: TColor;
  _CountDown: integer;
begin
  if not(AllSystemsRunning) then
    exit;

  if not(TagesabschlussAktiv) and NoTimer then
    exit;

  if not(FirstTimerEventChecked) then
  begin
    FirstTimerEventChecked := true;
    if pDisableTagesabschluss then
      Timer1.enabled := false;
    exit;
  end;

  cPanelActive := clTeal;
  repeat

    if TagesabschlussAktiv then
    begin
      Label2.caption := 'seit ' + secondstostr(SecondsDiff(SecondsGet,
        LetzerTagesAbschlussWarUm)) + 'h';
      cPanelActive := clyellow; // l�uft
      break;
    end;

    if not(isParam('Tagesabschluss')) then
    begin

      if (AnsiUpperCase(ComputerName) <> AnsiUpperCase(iTagesAbschlussAuf)) then
      begin
        Label2.caption := 'nicht hier';
        cPanelActive := clred; // nicht vorgesehen
        Timer1.enabled := false;
        break;
      end;

      if not(MainFormInformed) then
      begin
        FormMain.Panel3.color := cllime;
        MainFormInformed := true;
      end;

      if (iTagesabschlussWochentage <> '') then
      begin
        if (pos(WeekDayS(DateGet), iTagesabschlussWochentage) = 0) then
        begin
          Label2.caption := 'heute nicht (nur ' +
            iTagesabschlussWochentage + ')';
          cPanelActive := clred; // nicht vorgesehen
          break;
        end;
      end;

      _CountDown := abs(SecondsDiff(iTagesAbschlussUm, SecondsGet));
      if (_CountDown > 10) then
      begin
        Label2.caption := 'in ' + secondstostr(_CountDown) + 'h';
        cPanelActive := cllime;
        break;
      end;

    end;

    Tagesabschluss;

  until true;

  inc(FlipFlop);
  if (FlipFlop mod 2 = 0) then
    Panel1.color := clblack
  else
    Panel1.color := cPanelActive;
end;

procedure TFormTagesAbschluss.Tagesabschluss;
begin
  show;
  Label2.caption := 'l�uft';
  Button1.Click;
end;

procedure TFormTagesAbschluss.Button2Click(Sender: TObject);
var
  n: integer;
begin
  for n := 0 to pred(CheckListBox1.items.Count) do
    CheckListBox1.checked[n] := true;
end;

function TFormTagesAbschluss.TagesabschlussAktiv: boolean;
begin
  result := (TagesAbschluss_TAN >= cRID_FirstValid);
end;

procedure TFormTagesAbschluss.EofTagesabschluss;
begin
  TagesAbschluss_TAN := cRID_null;
  LetzerTagesAbschlussWarAm := 0;
  LetzerTagesAbschlussWarUm := 0;
end;

end.
