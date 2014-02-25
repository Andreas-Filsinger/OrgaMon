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
unit BaseUpdate;
//
// todo
//
// Bei einem Server die OrgaMon.bat starten!
// (Und nicht den OrgaMon mit irgendwelchen Parametern)
//

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  StdCtrls, Forms, Dialogs,
  ComCtrls, ExtCtrls, Buttons,

  // IBO
  IB_Dialogs, IB_Components, IB_Process,
  IB_Script, IB_Events, IB_Access,

  // Indy
  IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, txlib;

const
  cUpdate_Aktuell = 0; // Alles auf dem neuesten Stand
  cUpdate_Verfuegbar = 1;
  // Ein Update wäre verfügbar und könnte angewendet werden
  cUpdate_Fehlerhaft = 2;
  // Update müsste vorliegen kann aber nicht angewendet werden
  cUpdate_Kritisch = 3;
  // Die aktuelle Version ist abgelaufen und MUSS geupdatet werden
  cUpdate_Laufend = 4;
  // Die aktuelle Version darf nicht gestartet werden, da ein Update läuft
  cUpdate_Ungeprueft = 5;
  // In Serverumgebungen kan ein exe auch ohne Updatezwang angewendet werden

type
  TFormBaseUpdate = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    StaticText1: TStaticText;
    Label7: TLabel;
    Label8: TLabel;
    Button1: TButton;
    Button2: TButton;
    ListBox1: TListBox;
    CheckBox1: TCheckBox;
    IB_Query1: TIB_Query;
    IB_Script1: TIB_Script;
    Label2: TLabel;
    Label6: TLabel;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Button8: TButton;
    Label3: TLabel;
    StaticText4: TStaticText;
    Button3: TButton;
    ProgressBar1: TProgressBar;
    StaticText5: TStaticText;
    Button4: TButton;
    Timer1: TTimer;
    Label4: TLabel;
    Button9: TButton;
    StaticText6: TStaticText;
    Button10: TButton;
    Label5: TLabel;
    Button11: TButton;
    IB_Events1: TIB_Events;
    ermitteln: TButton;
    CheckBox2: TCheckBox;
    Button5: TButton;
    Button6: TButton;
    Label9: TLabel;
    Button7: TButton;
    SpeedButton4: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    IdHTTP1: TIdHTTP;
    CheckBox3: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IB_Script1Error(Sender: TObject; const ERRCODE: Integer;
      ErrorMessage, ErrorCodes: TStringList; const SQLCODE: Integer;
      SQLMessage, SQL: TStringList; var RaiseException: Boolean);
    procedure FormActivate(Sender: TObject);

    procedure IdHTTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure Button8Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure ermittelnClick(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    { Private-Deklarationen }
    BaseUpdateRev: single;
    CargoBayRev: single;
    ErrorCount: Integer;
    LastHttpDisplayTime: dword;
    SQLUpdateScript: TStringList;
    SQLUpdateLog: TStringList;
    FireOnceInformed: Boolean;

    function CargobayWebAdress: string;
    function SetupUpdateFName(Rev: single): string;
    procedure SetToActualRevision(pIBC: TIB_Connection);
    procedure ObtainBaseRevision(pIBC: TIB_Connection);
    procedure DownloadUpdate(Rev: single);
    procedure UpdateRevCaptions;

    function NewestUpdateRev: single;
    function NewestCargobayRev: single;
    procedure EnsureSQLUpdateScript;
    procedure UpdateUserCount;

    procedure FireEvent(Rev: single);
    procedure CloseEvent;

    // Http-Work 64 Bit
    procedure IdHTTP1WorkBegin64(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure IdHTTP1Work64(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);

    // IB-Objects 4.9
    procedure IB_Events1EventAlert(Sender: TObject; AEventName: String;
      AEventCount: Integer);

  public
    { Public-Deklarationen }
    IBC: TIB_Connection;
    BaseRev: single;

    function CheckIfUpdateNeeded(pIBC: TIB_Connection): Integer;
    function EnforceApplicationUpdateTo(Rev: single): Boolean;
    procedure DataBaseUpdate;
    procedure RestartApplication;
    function CloseOtherInstances: Boolean;

  end;

var
  FormBaseUpdate: TFormBaseUpdate;

implementation

uses
  WordIndex, anfix32, globals,
  dbOrgaMon,
  Einstellungen, CareTakerClient, splash,
  SimplePassword, wanfix32, Datenbank,
  Funktionen_Basis, JclMiscel, math;

{$R *.DFM}

function fullCmd: string;
var
  pIndex: Integer;
begin
  result := '';
  for pIndex := 1 to ParamCount do
    result := result + ' ' + ParamStr(pIndex);
  result := cutblank(result);
end;

procedure TFormBaseUpdate.Button1Click(Sender: TObject);
begin
  DataBaseUpdate;
end;

procedure TFormBaseUpdate.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFormBaseUpdate.FormCreate(Sender: TObject);
begin
  //
  IB_Events1.OnEventALert := IB_Events1EventAlert;
  //
  SQLUpdateScript := TStringList.create;
  SQLUpdateLog := TStringList.create;

  // mark, that nothing is initialized
  BaseRev := cRevNotAValidProject;
  BaseUpdateRev := cRevNotAValidProject;
  PageControl1.ActivePage := TabSheet1;

  //
  IB_Events1.events.add(cEventsDisconnect);
  IB_Events1.events.add(cEventsDown);

end;

procedure TFormBaseUpdate.IB_Script1Error(Sender: TObject;
  const ERRCODE: Integer; ErrorMessage, ErrorCodes: TStringList;
  const SQLCODE: Integer; SQLMessage, SQL: TStringList;
  var RaiseException: Boolean);
begin
  if CheckBox3.Checked then
  begin
    SQLUpdateLog.add(cERRORTExt + ' ' + HugeSingleLine(ErrorMessage, #13));
    SQLUpdateLog.add('=================================');
    RaiseException := false;
  end
  else
  begin
    ShowMessage('Fehler bei:' + #13 + HugeSingleLine(SQL, #13) + #13 +
      '-------------------------------------------------------' + #13 +
      'Fehlermeldung:' + #13 + HugeSingleLine(ErrorMessage, #13));
    RaiseException := true;
  end;
  inc(ErrorCount);
end;

procedure TFormBaseUpdate.EnsureSQLUpdateScript;
var
  n, k: Integer;
  MetaDataUpdateFname: string;
  sDRC: TStringList;
begin
  if assigned(SQLUpdateScript) then
    if (SQLUpdateScript.count = 0) then
    begin

      if FileExists(MyApplicationPath + cApplicationName + '.drc') then
      begin

        sDRC := TStringList.create;
        sDRC.LoadFromFile(MyApplicationPath + cApplicationName + '.drc');

        // !Entwickler-Version: laden aus der Rev-Datei des .\rev Verzeichnisses
        repeat

          for n := pred(sDRC.count) downto max(0, sDRC.count - 10) do
            if pos(cApplicationName + '.RES', sDRC[n]) > 0 then
            begin
              SQLUpdateScript.LoadFromFile(
                { } ExtractSegmentBetween(
                { } sDRC[n],
                { } '/* ',
                { } cApplicationName + '.RES') +
                { } '..\rev\' +
                { } cApplicationName + cRevExtension);
              break;

            end;

          if SQLUpdateScript.count > 0 then
            break;

          if FileExists(MyApplicationPath + '..\rev\' + cApplicationName +
            cRevExtension) then
          begin
            SQLUpdateScript.LoadFromFile(MyApplicationPath + '..\rev\' +
              cApplicationName + cRevExtension);
            break;
          end;

          if FileExists(MyApplicationPath + '..\OrgaMon\rev\' + cApplicationName
            + cRevExtension) then
          begin
            SQLUpdateScript.LoadFromFile(MyApplicationPath + '..\OrgaMon\rev\' +
              cApplicationName + cRevExtension);
            break;
          end;

          SQLUpdateScript.add(':0.001');
          if doit(cApplicationName + cRevExtension + ' fehlt!' + #13 +
            'Es kann nicht geprüft werden, ob ein Datenbankupdate' + #13 +
            'durchgeführt werden muss! Anwendung beenden', true) then
            application.terminate;

        until true;

        sDRC.Free;

        k := SQLUpdateScript.indexof('.SQL INIT BEGIN');
        if (k <> -1) then
          for n := k downto 0 do
            SQLUpdateScript.delete(n);

        if (SQLUpdateScript.count > 0) then
          while (SQLUpdateScript[0] = '') do
          begin
            SQLUpdateScript.delete(0);
            if (SQLUpdateScript.count = 0) then
              break;
          end;

      end
      else
      begin

        MetaDataUpdateFname := MyApplicationPath + cApplicationName +
          '_Info.html';
        if (FileAge(application.ExeName) < FileAge(MetaDataUpdateFname)) then
        begin

          SQLUpdateScript.LoadFromFile(MetaDataUpdateFname);
          k := SQLUpdateScript.indexof('<!-- SQL');
          if (k <> -1) then
            for n := k downto 0 do
              SQLUpdateScript.delete(n);

          // delete empty lines at start
          if SQLUpdateScript.count > 0 then
            while (SQLUpdateScript[0] = '') do
            begin
              SQLUpdateScript.delete(0);
              if SQLUpdateScript.count = 0 then
                break;
            end;

          //
          k := SQLUpdateScript.indexof('-->');
          if (k <> -1) then
            for n := pred(SQLUpdateScript.count) downto k do
              SQLUpdateScript.delete(n);

        end
        else
        begin
          SQLUpdateScript.add(':0.001');
          if doit(MetaDataUpdateFname + ' fehlt oder ist veraltet!' + #13 +
            'Es kann nicht geprüft werden, ob ein Datenbankupdate' + #13 +
            'durchgeführt werden muss! Anwendung beenden', true) then
            application.terminate;
        end;

      end;

      BaseUpdateRev := strtodouble(copy(SQLUpdateScript[0], 2, MaxInt));

    end;
end;

function TFormBaseUpdate.CheckIfUpdateNeeded(pIBC: TIB_Connection): Integer;
var
  SQL_UpdateNotwendig: Boolean;
  iRCversion: Integer;
begin
  result := cUpdate_Ungeprueft;

  // globales IBC setzen
  if not(assigned(IBC)) then
    IBC := pIBC;

  // Applikationsnamen wie OrgaMon.6700.exe, -RC.exe werden beim Updatesystem
  // aussen vor gelassen! (Anwendung für Server / Betas)!
  //
  if isBeta then
  begin
    iRCversion := RevAsInteger(NewestCargobayRev);
    if iRCversion > RevAsInteger(globals.version) then
      result := cUpdate_Aktuell;
    if iRCversion > RevAsInteger(globals.version) then
    begin
      ShowMessage('Es ist ein verbesserter RC erschienen!' + #13 +
        'Führen Sie bitte  die Update-Funktion aus ...');
      result := cUpdate_Verfuegbar;
    end;
    exit;
  end;

  SQL_UpdateNotwendig := false;
  repeat

    //
    // Aktuelle Datenbank-Version ermitteln
    //
    ObtainBaseRevision(IBC);

    if (RevAsInteger(BaseRev) >= 9998) then
    begin
      IBC.disconnect;
      if not(doit('Die Struktur der Datenbank wird gerade aktualisiert!' + #13 +
        #13 + 'Dieser Vorgang ist normalerweise innerhalb weniger Minuten abgeschlossen!'
        + #13 + 'Versuchen Sie später nocheinmal, ' + cApplicationName +
        ' zu starten. Erhalten Sie langandauernd' + #13 +
        'diese Meldung wenden Sie sich an die EDV-Hilfestellung.' + #13 + #13 +
        'DRÜCKEN SIE JETZT <OK> UM DIE ANWENDUNG ZU BEENDEN!' + #13 +
        '<Abbrechen> würde den Updatevorgang unterbrechen und könnte schwerwiegende Folgen haben!'
        + #13 + 'Möchten Sie ' + cApplicationName + ' jetzt beenden', true))
      then
      begin
        CareTakerLog(cERRORTExt + ' BaseUpdate.PendingUpdate: USER BREAK');
        IBC.connect;
        CloseEvent;
        IBC.disconnect;
      end;
      application.terminate;
      result := cUpdate_Laufend;
      exit;
    end;

    IB_Events1.registered := true;

    // alles OK?
    if (globals.version = BaseRev) then
    begin
      result := cUpdate_Aktuell;
      break;
    end;

    // Ist die Anwendung veraltet?
    if (RevAsInteger(BaseRev) > RevAsInteger(globals.version)) then
    begin
      if EnforceApplicationUpdateTo(BaseRev) then
        result := cUpdate_Verfuegbar
      else
        result := cUpdate_Fehlerhaft;

      break;
    end;

    // Infos nachladen ...
    EnsureSQLUpdateScript;

    // Ist die Datenbank veraltet?
    if RevAsInteger(BaseUpdateRev) > RevAsInteger(BaseRev) then
    begin
      SQL_UpdateNotwendig := true;
      break;
    end;

    // Einfach nur die aktuelle Rev eintragen?
    if RevAsInteger(BaseRev) < RevAsInteger(globals.version) then
      SetToActualRevision(IBC);

  until true;

  if SQL_UpdateNotwendig then
  begin
    PageControl1.ActivePage := TabSheet2;
    ShowModal;
  end;

end;

procedure TFormBaseUpdate.SetToActualRevision(pIBC: TIB_Connection);
var
  _iCareTakerOffline: Boolean;
begin
  BeginHourGlass;
  if not(assigned(IBC)) then
    IBC := pIBC;
  with IB_Query1 do
  begin
    IB_Connection := IBC;
    Open;
    insert;
    FieldByName('RID').AsInteger := round(globals.version * 1000);
    FieldByName('DATUM').AsDateTime := now;
    post;
    close;
  end;
  BaseRev := globals.version;

  // Erfolg verbuchen
  _iCareTakerOffline := iCareTakerOffline;
  iCareTakerOffline := false;
  if CareTakerLog(cApplicationName + ' Rev. ' + RevTostr(globals.version) +
    ' active!') <> -1 then
    NachMeldungen;
  iCareTakerOffline := _iCareTakerOffline;

  //
  UpdateRevCaptions;
  EndHourGlass;
end;

procedure TFormBaseUpdate.ObtainBaseRevision;
begin
  if not(assigned(IBC)) then
    IBC := pIBC;
  if (BaseRev < 0.999) then
  begin
    BaseRev := 0.999;
    try
      with IB_Query1 do
      begin
        IB_Connection := IBC;
        Open;
        Last;
        if not(eof) then
          BaseRev := FieldByName('RID').AsInteger / 1000.0;
        close;
      end;
    except
      // ;
    end;
  end;
  UpdateRevCaptions;
end;

procedure TFormBaseUpdate.FormActivate(Sender: TObject);
begin
  BeginHourGlass;
  CargoBayRev := NewestCargobayRev;
  UpdateRevCaptions;
  Timer1.Enabled := true;
  EndHourGlass;
end;

function TFormBaseUpdate.EnforceApplicationUpdateTo(Rev: single): Boolean;
var
  UpdateQuellen: TStringList;
  UpdateQuelleGefunden: Boolean;
  ImInternetRev: single;

  function CheckUpdateQuellen: Boolean;
  var
    n: Integer;
  begin
    result := false;
    for n := 0 to pred(UpdateQuellen.count) do
      if FileExists(UpdateQuellen[n]) then
      begin
        //
        if CloseOtherInstances then
        begin
          WinExec32(UpdateQuellen[n] + ' /SILENT /SUPPRESSMSGBOXES "/PostExec='
            + fullCmd + '"', sw_showdefault);
          result := true;
          application.terminate;
        end;
        break;
      end;
  end;

begin
  result := true;

  // Quelle auflisten
  UpdateQuellen := TStringList.create;

  // die aktuelle Rev suchen
  UpdateQuellen.add(UpdatePath + SetupUpdateFName(Rev));
  UpdateQuellen.add('G:\CargoBay\' + SetupUpdateFName(Rev));

  // Existenz der Quellen prüfen
  UpdateQuelleGefunden := CheckUpdateQuellen;

  if not(UpdateQuelleGefunden) then
  begin
    // Jetzt noch via Internet suchen
    ImInternetRev := NewestCargobayRev;

    if (Rev <= ImInternetRev) and (ImInternetRev <> cRevNotAValidProject) then
    begin
      // OK, im Internet liegt auf alle Fälle was
      UpdateQuellen.clear;
      UpdateQuellen.add(UpdatePath + SetupUpdateFName(ImInternetRev));

      // schon zuvor mal downgeloaded?
      UpdateQuelleGefunden := CheckUpdateQuellen;

      if not(UpdateQuelleGefunden) then
      begin
        // downloaden, und nochmal versuchen!
        DownloadUpdate(ImInternetRev);
        UpdateQuelleGefunden := CheckUpdateQuellen;
      end;

    end;
  end;

  UpdateQuellen.Free;

  if not(UpdateQuelleGefunden) then
  begin
    SplashClose;
    result := false;
    CareTakerLog(cERRORTExt + ' EnforceBaseUpdate: "' + SetupUpdateFName(Rev) +
      '" fehlt!');
  end;

end;

function TFormBaseUpdate.SetupUpdateFName(Rev: single): string;
begin
  if isBeta then
    result := 'Setup-' + cApplicationName + '-' + 'RC.exe'
  else
    result := 'Setup-' + cApplicationName + '-' + StrFilter(RevTostr(Rev), '.',
      true) + '-' + 'Update.exe'
end;

procedure TFormBaseUpdate.IdHTTP1WorkBegin64(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  ProgressBar1.max := AWorkCountMax;
end;

procedure TFormBaseUpdate.IdHTTP1Work64(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  ProgressBar1.Position := AWorkCount;
end;

procedure TFormBaseUpdate.IdHTTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  ProgressBar1.Position := 0;
end;

procedure TFormBaseUpdate.DownloadUpdate(Rev: single);
var
  OutF: TFileStream;
  TmpFName: string;
begin
  cursor := crHourGlass;
  show;
  PageControl1.ActivePage := TabSheet1;
  CheckCreateDir(UpdatePath);

  TmpFName := UpdatePath + FindANewPassword + '.' + UserName +
    cTmpFileExtension;
  FileDelete(TmpFName);
  OutF := TFileStream.create(TmpFName, fmCreate);
  with IdHTTP1 do
  begin
    OnWorkBegin := IdHTTP1WorkBegin64;
    OnWork := IdHTTP1Work64;
    get(CargobayWebAdress + SetupUpdateFName(Rev), OutF)
  end;
  OutF.Free;

  if (IdHTTP1.ResponseCode = 200) then
  begin
    FileDelete(UpdatePath + SetupUpdateFName(Rev));
    FileRename(TmpFName, UpdatePath + SetupUpdateFName(Rev));
  end;

  cursor := crdefault;
end;

procedure TFormBaseUpdate.Button8Click(Sender: TObject);
begin
  DownloadUpdate(CargoBayRev);
  EnforceApplicationUpdateTo(CargoBayRev);
end;

procedure TFormBaseUpdate.Button4Click(Sender: TObject);
begin
  EnforceApplicationUpdateTo(globals.version);
end;

procedure TFormBaseUpdate.UpdateRevCaptions;
begin
  BeginHourGlass;
  StaticText1.caption := RevTostr(BaseRev);
  StaticText2.caption := RevTostr(globals.version);
  StaticText3.caption := RevTostr(CargoBayRev);
  StaticText5.caption := RevTostr(BaseUpdateRev);
  StaticText6.caption := RevTostr(NewestUpdateRev);
  Label5.caption := iDataBaseName;
  EndHourGlass;
end;

procedure TFormBaseUpdate.Timer1Timer(Sender: TObject);
begin
  if NoTimer then
    exit;
  //
  if FireOnceInformed then
  begin
    FireOnceInformed := false;
    ShowMessageTimeOut('Anstehende Änderung der Datenbankstruktur!' + #13 +
      'Bitte beenden Sie sofort ' + cApplicationName + '. In wenigen' + #13 +
      'Sekunden erfolgt die Zwangstrennung!', 15000);
  end;

  //
  UpdateUserCount;
end;

procedure TFormBaseUpdate.FormDeactivate(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

function TFormBaseUpdate.NewestUpdateRev: single;
var
  NewestUpdatesL: TStringList;
begin
  NewestUpdatesL := TStringList.create;
  dir(UpdatePath + '*-Update.exe', NewestUpdatesL, false);
  if (NewestUpdatesL.count = 0) then
  begin
    result := 0.000;
  end
  else
  begin
    NewestUpdatesL.sort;
    result := strtointdef(nextp(NewestUpdatesL[pred(NewestUpdatesL.count)], '-',
      2), 0) / 1000;
  end;
  NewestUpdatesL.Free;
end;

procedure TFormBaseUpdate.Button9Click(Sender: TObject);
begin
  EnforceApplicationUpdateTo(NewestUpdateRev);
end;

procedure TFormBaseUpdate.Button10Click(Sender: TObject);
var
  REVISION: TIB_Query;
begin
  if doit('Sind Sie sich ganz sicher') then
  begin
    REVISION := DataModuleDatenbank.nQuery;
    with REVISION do
    begin
      IB_Connection := IBC;
      SQL.add('SELECT * FROM REVISION ORDER BY RID DESCENDING FOR UPDATE');
      Open;
      first;
      delete;
      close;
    end;
    REVISION.Free;
    BaseRev := cRevNotAValidProject;
    ObtainBaseRevision(IBC);
  end;
end;

procedure TFormBaseUpdate.Button11Click(Sender: TObject);
begin
  EnsureSQLUpdateScript;
  UpdateRevCaptions;
end;

procedure TFormBaseUpdate.IB_Events1EventAlert(Sender: TObject;
  AEventName: string; AEventCount: Integer);
begin
  repeat

    //
    if (AEventName = cEventsDisconnect) then
    begin
      NoTimer := true;
      iForceAppDown := true;
      application.terminate;
      break;
    end;

    //
    if (AEventName = cEventsDown) then
    begin
      if not(FireOnceInformed) then
      begin
        FireOnceInformed := true;
        Timer1.Enabled := true;
      end;
      break;
    end;

  until true;
end;

procedure TFormBaseUpdate.Button3Click(Sender: TObject);
begin
  FireEvent(9.998);
end;

function TFormBaseUpdate.NewestCargobayRev: single;
var
  wow: string;
  k: Integer;
begin
  result := cRevNotAValidProject;
  try
    if isBeta then
      wow := IdHTTP1.get(CargobayWebAdress + cApplicationName +
        '-RC.html' + '?')
    else
      wow := IdHTTP1.get(CargobayWebAdress + cApplicationName +
        'Rev.html' + '?');

    k := pos(' Rev ', wow);
    if (k <> -1) then
      result := strtodouble(copy(wow, k + 5, 4)) / 1000
    else
      CareTakerLog(cERRORTExt + ' BaseUpdate.get: ' + IdHTTP1.ResponseText);
  except
    on e: exception do
      CareTakerLog(cERRORTExt + ' BaseUpdate.get: ' + e.message);
  end;
end;

function TFormBaseUpdate.CargobayWebAdress: string;
begin
  result := 'http://cargobay.orgamon.net/';
end;

procedure TFormBaseUpdate.TabSheet1Show(Sender: TObject);
begin
  CargoBayRev := NewestCargobayRev;
  UpdateRevCaptions;
end;

procedure TFormBaseUpdate.FireEvent(Rev: single);
var
  dEVENT: TIB_DSQL;
begin

  // sicherstellen, dass die Events im Moment nicht aktiv sind!
  IB_Events1.registered := false;

  //
  dEVENT := DataModuleDatenbank.nDSQL;
  with dEVENT do
  begin
    SQL.add('delete from REVISION where RID=' + inttostr(RevAsInteger(Rev)));
    execute;
    SQL.clear;
    SQL.add('insert into REVISION (RID) values (' +
      inttostr(RevAsInteger(Rev)) + ')');
    execute;
  end;
  dEVENT.Free;
end;

procedure TFormBaseUpdate.ermittelnClick(Sender: TObject);
begin
  UpdateUserCount;
end;

procedure TFormBaseUpdate.UpdateUserCount;
begin
  StaticText4.caption := inttostr(e_r_COnnectionCount);
end;

procedure TFormBaseUpdate.CloseEvent;
var
  xREVISION: TIB_DSQL;
begin

  // Remove "Update" - Lock
  xREVISION := DataModuleDatenbank.nDSQL;
  with xREVISION do
  begin
    SQL.add('delete from REVISION where RID>=9998');
    execute;
  end;
  xREVISION.Free;

  // Switch on the Update Alerter
  IB_Events1.registered := true;

end;

procedure TFormBaseUpdate.DataBaseUpdate;
var
  HeaderStr: string;
  StepNo: Integer;
  RunNo: Integer;
  _SYSDBA_password: string;

  procedure RunNow;
  var
    RunPersmission: Boolean;
  begin

    if CheckBox1.Checked then
    begin
      RunPersmission := doit(IB_Script1.SQL);
    end
    else
    begin
      RunPersmission := true;
    end;

    ListBox1.items.assign(IB_Script1.SQL);
    inc(StepNo);
    Label7.caption := 'Schritt Nó ' + inttostr(StepNo) + ' (' + HeaderStr + ')';
    application.processmessages;

    if RunPersmission then
    begin
      SQLUpdateLog.add('----------------------------------');
      SQLUpdateLog.addstrings(IB_Script1.SQL);
      try
        inc(RunNo);
        if (pos('reconnect', IB_Script1.SQL[0]) > 0) then
        begin
          with IB_Script1.IB_Connection do
          begin
            disconnect;
            connect;
          end;
        end
        else
        begin
          IB_Script1.execute;
        end;
      except
        on e: exception do
          CareTakerLog(cERRORTExt + ' BaseUpdate.' + e.message);
      end;
    end;
    IB_Script1.SQL.clear;
  end;

var
  _UpdateFrom, _UpdateTo, BringTo: Integer;
  k: Integer;
  n: Integer;
  UpdateData: TSearchStringList;
  UserCount: Integer;
  _db_UserName: string;
  _db_password: string;

begin
  // hole neueste Infos
  SQLUpdateLog.clear;
  EnsureSQLUpdateScript;

  // alle freundlich aufordern, das Programm zu verlassen!
  BeginHourGlass;
  FireEvent(9.998);
  delay(200);
  EndHourGlass;

  repeat
    UserCount := IBC.Users.count;
    if (UserCount = 1) then
      break;

    case YesNoIgnore('Es ist/sind noch ' + inttostr(UserCount - 1) +
      ' andere Benutzer' + #13 +
      'mit der Datenbank verbunden. Dies kann zur Folge haben, dass' + #13 +
      'wichtige Änderungen nicht durchgeführt werden können.' + #13 +
      'Stellen Sie jetzt sicher, dass diese Verbindungen' + #13 +
      'getrennt werden - drücken Sie ' + #13 +
      '<Abbrechen> um die Zwangsbeendigung aller Verbindungen auszulösen. (empfohlen nach 1 Minute).'
      + #13 + '<Wiederholen> um noch etwas zu warten. (empfohlen innerhalb 1 Minute).'
      + #13 + '<Ignorieren> um dennoch das Update durchzuführen. (NICHT EMPFOHLEN)')
      of
      IDCANCEL, IDABORT:
        FireEvent(9.999);
      IDOK, IDRETRY:
        ;
      IDIGNORE:
        break;
    end;

    BeginHourGlass;
    delay(500);
    EndHourGlass;

  until false;

  BeginHourGlass;

  _UpdateFrom := round(BaseRev * 1000);
  _UpdateTo := round(globals.version * 1000);
  UpdateData := TSearchStringList.create;
  UpdateData.addstrings(SQLUpdateScript);
  ErrorCount := 0;
  RunNo := 0;
  StepNo := 0;

  // für Anwender, die nicht als SYSDBA drin sind!
  with IBC do
  begin
    _db_UserName := UserName;
    _db_password := Password;
    disconnect;
    if (UserName <> 'SYSDBA') then
    begin
      _SYSDBA_password := SysDBApassword;
      UserName := 'SYSDBA';
      Password := _SYSDBA_password;
    end;
    connect;
  end;

  IB_Script1.IB_Connection := IBC;
  for BringTo := succ(_UpdateFrom) to _UpdateTo do
  begin

    // Datenbank-Änderungen durchführen
    HeaderStr := ':' + RevTostr(BringTo / 1000.0);
    k := UpdateData.indexof(HeaderStr);
    if k <> -1 then
    begin
      IB_Script1.SQL.clear;
      for n := succ(k) to pred(UpdateData.count) do
      begin
        if pos(':', UpdateData[n]) = 1 then
          break;
        if UpdateData[n] <> '' then
          IB_Script1.SQL.add(UpdateData[n]);
        if (IB_Script1.SQL.count > 0) and (UpdateData[n] = '') then
          RunNow;
      end;
      if (IB_Script1.SQL.count > 0) then
        RunNow;
    end;

  end;
  UpdateData.Free;

  // change to old User
  with IBC do
  begin
    if (UserName <> _db_UserName) then
    begin
      disconnect;
      UserName := _db_UserName;
      Password := _db_password;
      connect;
    end;
  end;

  EndHourGlass;

  // Update-Status wieder austragen
  CloseEvent;

  if (StepNo = 0) then
  begin
    ShowMessage('Ein Datenbank-Update war nicht erforderlich!');
    close;
  end
  else
  begin
    if (StepNo = (RunNo - ErrorCount)) then
    begin
      // Erfolg eintragen
      SetToActualRevision(IBC);
      close;
      ShowMessageTimeOut('Das Update wurde ohne Fehler durchgeführt!' + #13 +
        'Auf anderen Arbeitsplätzen darf die Anwendung' + #13 +
        'nun gestartet werden!', 15000);
    end
    else
    begin
      if (ErrorCount > 0) and not(CheckBox3.Checked) then
      begin
        ShowMessage('Update nicht fehlerfrei ausgeführt!' + #13 +
          'Spielen Sie das Datenbank-Backup ein und' + #13 +
          'führen Sie das Update im Einzelschrittmodus aus' + #13 +
          'um einzukreisen welcher Update-Schritt problematisch' + #13 +
          'war. Die Anwendung sollte nicht verwendet werden!');
      end
      else
      begin
        SQLUpdateLog.SaveToFile(DiagnosePath + 'BaseUpdate.txt');
        openShell(DiagnosePath + 'BaseUpdate.txt');
        if doit('Das Update wurde nicht vollständig ausgeführt!' + #13 +
          'Sind dennoch alle notwendigen Schritte' + #13 +
          'z.B. durch eine externe Anwendung bereits' + #13 + 'erfolgt', true)
        then
        begin
          CareTakerLog(cERRORTExt + ' BaseUpdate.ForceRev: USER OVERRIDE');
          SetToActualRevision(IBC);
          close;
        end;
      end;
    end;
  end;
end;

procedure TFormBaseUpdate.CheckBox2Click(Sender: TObject);
begin
  if CheckBox2.Checked then
    FireEvent(9.999)
  else
    CloseEvent;
end;

procedure TFormBaseUpdate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if assigned(IBC) then
  begin
    if (IBC.connected) then
    begin
      if CheckBox2.Checked then
        CloseEvent;
    end;
  end;
end;

procedure TFormBaseUpdate.FormDestroy(Sender: TObject);
begin
  SQLUpdateScript.Free;
end;

procedure TFormBaseUpdate.RestartApplication;
var
  AllParams: string;
  n: Integer;
begin

  // Alle Timer stoppen
  NoTimer := true;

  // Alle Parameter sammeln
  AllParams := '';
  for n := 1 to ParamCount do
    if (ParamStr(n) <> '-lr') then
      AllParams := AllParams + ' ' + ParamStr(n);

  // OrgaMon neu starten
  WinExec32(application.ExeName + ' ' + cutblank(AllParams + ' -lr'),
    sw_showdefault);

  // Anwendung stoppen
  application.terminate;
end;

procedure TFormBaseUpdate.Button5Click(Sender: TObject);
begin
  RestartApplication;
end;

procedure TFormBaseUpdate.Button6Click(Sender: TObject);
begin
  CloseOtherInstances;
end;

function TFormBaseUpdate.CloseOtherInstances: Boolean;
var
  AllW: TStringList;
  n: Integer;
  OneFound: Boolean;
  OneStillOpen: Boolean;
  CloseTry: Integer;
begin
  BeginHourGlass;
  result := true;
  AllW := TStringList.create;
  CloseTry := 0;
  OneFound := false;
  repeat
    EnumAllWindows(AllW);
    OneStillOpen := false;
    for n := 0 to pred(AllW.count) do
      if (pos(cApplicationName + cTradeMark, AllW[n]) = 1) then
      begin
        OneFound := true;
        if (hwnd(AllW.objects[n]) <> application.MainForm.handle) then
        begin
          PostMessage(hwnd(AllW.objects[n]), WM_CLOSE, 0, 0);
          OneStillOpen := true;
        end;
      end;
    if (CloseTry = 4) then
    begin
      result := false;
      ShowMessageTimeOut('Andere laufende ' + cApplicationName + cTradeMark +
        ' Anwendungen konnten nicht beendet werden!' + #13 +
        'Beenden Sie diese mit dem Task-Manager oder starten Sie den Rechner neu!');
      break;
    end;
    if OneStillOpen then
      delay(1500)
    else
      break;
    inc(CloseTry);
    AllW.clear;
  until false;
  // AllW.SaveTofile(DiagnosePath + 'AlleOffenenFenster.txt');
  // open(DiagnosePath + 'AlleOffenenFenster.txt');
  AllW.Free;
  if not(OneFound) then
    CareTakerLog(cERRORTExt +
      ' CloseOtherInstances: Nicht mal die eigene Instanz gefunden!');
  EndHourGlass;
end;

procedure TFormBaseUpdate.Button7Click(Sender: TObject);
begin
  WindowsNeuStarten;
end;

procedure TFormBaseUpdate.SpeedButton2Click(Sender: TObject);
begin
  CargoBayRev := NewestCargobayRev;
  UpdateRevCaptions;
end;

procedure TFormBaseUpdate.SpeedButton1Click(Sender: TObject);
begin
  UpdateRevCaptions;
end;

procedure TFormBaseUpdate.SpeedButton4Click(Sender: TObject);
begin
  UpdateRevCaptions;
end;

end.
