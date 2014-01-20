//
// todo
//
// Bei einem Server die OrgaMon.bat starten!
// (Und nicht den OrgaMon mit irgendwelchen Parametern)
//
unit BaseUpdate;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, IB_Dialogs,
  StdCtrls, IB_Components, IB_Process,
  IB_Script, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP,
  ComCtrls, ExtCtrls, IB_Events, Buttons;

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
    IdHTTP1: TIdHTTP;
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
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IB_Script1Error(Sender: TObject; const ERRCODE: Integer;
      ErrorMessage, ErrorCodes: TStringList; const SQLCODE: Integer;
      SQLMessage, SQL: TStringList; var RaiseException: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure IdHTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure IdHTTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure Button8Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure IB_Events1EventAlert(Sender: TObject; AEventName: string;
      AEventCount: Integer);
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
    ErrorCount: integer;
    LastHttpDisplayTime: dword;
    SQLUpdateScript: TStringList;
    FireOnceInformed: boolean;

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

  public
    { Public-Deklarationen }
    BaseUpdateAbgeschlossen: boolean;
    IBC: TIB_Connection;
    BaseRev: single;

    function CheckIfUpdateNeeded(pIBC: TIB_Connection): boolean;
    procedure EnforceApplicationUpdateTo(Rev: single);
    procedure DataBaseUpdate;
    procedure RestartApplication;
    function CloseOtherInstances: boolean;

  end;

var
  FormBaseUpdate: TFormBaseUpdate;

implementation

uses
  WordIndex, anfix32, globals,
  Einstellungen, CareTakerClient, splash,
  SimplePassword;

{$R *.DFM}

function RevAsInteger(Rev: single): integer; overload;
begin
  result := round(Rev * 1000);
end;

function RevAsInteger(Rev: double): integer; overload;
begin
  result := round(Rev * 1000);
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
  SQLUpdateScript := TStringList.create;

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
  ShowMessage('Fehler bei:' + #13 +
    HugeSingleLine(sql, #13) +
    #13 +
    '-------------------------------------------------------' + #13 +
    'Fehlermeldung:' + #13 +
    HugeSingleLine(ErrorMessage, #13)
    );
  inc(ErrorCount);
  RaiseException := true;
end;

procedure TFormBaseUpdate.EnsureSQLUpdateScript;
var
  n, k: integer;
  MetaDataUpdateFname: string;
begin
  if assigned(SQLUpdateScript) then
    if (SQLUpdateScript.count = 0) then
    begin

      if FileExists(MyProgramPath + cApplicationName + '.dpr') then
      begin

        // Entwickler-Version, laden aus der Rev-Datei
        SQLUpdateScript.LoadFromFile('G:\rev\' + cApplicationName + '.rev');
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

      end else
      begin

        MetaDataUpdateFname := MyApplicationPath + cApplicationName + '_Info.html';
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

        end else
        begin
          SQLUpdateScript.add(':0.001');
          if doit(MetaDataUpdateFName + ' fehlt oder ist veraltet!' + #13 +
            'Es kann nicht geprüft werden, ob ein Datenbankupdate' + #13 +
            'durchgeführt werden muss! Anwendung beenden', true) then
            application.terminate;
        end;

      end;

      BaseUpdateRev := strtodouble(copy(SQLUpdateScript[0], 2, MaxInt));

    end;
end;

function TFormBaseUpdate.CheckIfUpdateNeeded(pIBC: TIB_Connection): boolean;
begin

  if not (assigned(IBC)) then
    IBC := pIBC;

  result := false;

  // Apllikationsnamen wie OrgaMon.6700.exe werden beim Updatesystem
  // aussen vor gelassen! (Anwendung für Server)!
  if (pos(inttostr(RevAsInteger(Globals.Version)), application.ExeName) > 0) then
    exit;

  repeat

    //
    // Aktuelle Datenbank-Version ermitteln
    //
    ObtainBaseRevision(IBC);

    if (RevAsInteger(BaseRev) >= 9998) then
    begin
      IBC.disconnect;
      if not (doit(
        'Die Struktur der Datenbank wird gerade aktualisiert!' + #13 + #13 +
        'Dieser Vorgang ist normalerweise innerhalb weniger Minuten abgeschlossen!' + #13 +
        'Versuchen Sie später nocheinmal, ' + cApplicationName + ' zu starten. Erhalten Sie langandauernd' + #13 +
        'diese Meldung wenden Sie sich an die EDV-Hilfestellung.' + #13 + #13 +
        'DRÜCKEN SIE JETZT <OK> UM DIE ANWENDUNG ZU BEENDEN!' + #13 +
        '<Abbrechen> würde den Updatevorgang unterbrechen und könnte schwerwiegende Folgen haben!' + #13 +
        'Möchten Sie ' + cApplicationname + ' jetzt beenden', true)) then
      begin
        CareTakerLog(cERRORText + ' BaseUpdate.PendingUpdate: USER BREAK');
        IBC.connect;
        CloseEvent;
        IBC.disconnect;
      end;
      result := true;
      application.terminate;
      exit;
    end;

    IB_Events1.registered := true;

    // alles OK?
    if (globals.Version = BaseRev) then
      break;

    // Ist die Anwendung veraltet?
    if (RevAsInteger(BaseRev) > RevAsInteger(globals.Version)) then
    begin
      EnforceApplicationUpdateTo(BaseRev);
      break;
    end;

    // Infos nachladen ...
    EnsureSQLUpdateScript;

    // Ist die Datenbank veraltet?
    if RevAsInteger(BaseUpdateRev) > RevAsInteger(BaseRev) then
    begin
      result := true;
      break;
    end;

    // Einfach nur die aktuelle Rev eintragen?
    if RevAsInteger(BaseRev) < RevAsInteger(globals.Version) then
      SetToActualRevision(IBC);

  until true;

  if not (result) then
    BaseUpdateAbgeschlossen := true;

  if result then
  begin
    PageControl1.ActivePage := TabSheet2;
    ShowModal;
  end;

end;

procedure TFormBaseUpdate.SetToActualRevision(pIBC: TIB_Connection);
var
  _iCareTakerOffline: boolean;
begin
  BeginHourGlass;
  if not (assigned(IBC)) then
    IBC := pIBC;
  with IB_Query1 do
  begin
    IB_Connection := IBC;
    Open;
    insert;
    FieldByName('RID').AsInteger := round(globals.Version * 1000);
    FieldByName('DATUM').AsDateTime := now;
    post;
    close;
  end;
  BaseRev := globals.version;

  // Erfolg verbuchen
  _iCareTakerOffline := iCareTakerOffline;
  iCareTakerOffline := false;
  if CareTakerLog(cApplicationName + ' Rev. ' + RevTostr(globals.Version) + ' active!') <> -1 then
    NachMeldungen;
  iCareTakerOffline := _iCareTakerOffline;

  //
  UpdateRevCaptions;
  EndHourGlass;
end;

procedure TFormBaseUpdate.ObtainBaseRevision;
begin
  if not (assigned(IBC)) then
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
        if not (eof) then
          BaseRev := FieldByName('RID').AsInteger / 1000.0;
        Close;
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
  timer1.Enabled := true;
  EndHourGlass;
end;

procedure TFormBaseUpdate.EnforceApplicationUpdateTo(Rev: single);
var
  UpdateQuellen: TStringList;
  UpdateQuelleGefunden: boolean;
  ImInternetRev: single;

  function CheckUpdateQuellen: boolean;
  var
    n: integer;
  begin
    result := false;
    for n := 0 to pred(UpdateQuellen.count) do
      if FileExists(UpdateQuellen[n]) then
      begin
        //
        if CloseOtherInstances then
        begin
          spawn(UpdateQuellen[n] + ' /SILENT /SUPPRESSMSGBOXES /PostExec=' + paramstr(1));
          result := true;
          application.terminate;
        end;
        break;
      end;
  end;

begin
  // Quelle auflisten
  UpdateQuellen := TStringList.create;

  // die aktuelle Rev suchen
  UpdateQuellen.add(UpdatePath + SetupUpdateFName(Rev));
  UpdateQuellen.add('G:\CargoBay\' + SetupUpdateFName(Rev));

  //

  // Existenz der Quellen prüfen
  UpdateQuelleGefunden := CheckUpdateQuellen;

  if not (UpdateQuelleGefunden) then
  begin
    // Jetzt noch via Internet suchen
    ImInterNetRev := NewestCargobayRev;

    if (Rev <= ImInterNetRev) and (ImInterNetRev <> cRevNotAValidProject) then
    begin
      // OK, im Internet liegt auf alle Fälle was
      UpdateQuellen.clear;
      UpdateQuellen.add(UpdatePath + SetupUpdateFName(ImInterNetRev));

      // schon zuvor mal downgeloaded?
      UpdateQuelleGefunden := CheckUpdateQuellen;

      if not (UpdateQuelleGefunden) then
      begin
        // downloaden, und nochmal versuchen!
        DownloadUpdate(ImInterNetRev);
        UpdateQuelleGefunden := CheckUpdateQuellen;
      end;

    end;
  end;

  UpdateQuellen.free;

  if not (UpdateQuelleGefunden) then
  begin
    SplashClose;
    ShowMessage('Update unmöglich:' + #13 +
      SetupUpdateFName(Rev) + #13 +
      'fehlt!');
  end;

end;

function TFormBaseUpdate.SetupUpdateFName(Rev: single): string;
begin
  result := 'Setup-' + cApplicationName + '-' +
    StrFilter(RevTostr(Rev), '.', true) + '-' +
    'Update.exe';
end;

procedure TFormBaseUpdate.IdHTTP1Work(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
  if frequently(LastHttpDisplayTime, 222) then
  begin
    progressbar1.position := AWorkCount;
    application.processmessages;
  end;
end;

procedure TFormBaseUpdate.IdHTTP1WorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
  progressbar1.Max := AWorkCountMax;
end;

procedure TFormBaseUpdate.IdHTTP1WorkEnd(Sender: TObject;
  AWorkMode: TWorkMode);
begin
  progressbar1.Position := 0;
end;

procedure TFormBaseUpdate.DownloadUpdate(Rev: single);
var
  OutF: TFileStream;
  TmpFName: string;
begin
  cursor := crHourGlass;
  show;
  PageControl1.activePage := TabSheet1;
  CheckCreateDir(UpdatePath);

  TmpFName := UpdatePath + FindANewPassword + '.$$$';
  FileDelete(TmpFName);
  OutF := TFileStream.Create(TmpFName, fmCreate);
  IDhttp1.get(CargobayWebAdress + SetupUpdateFName(Rev), OutF);
  OutF.free;

  if (IDhttp1.ResponseCode = 200) then
  begin
    FileDelete(UpdatePath + SetupUpdateFName(Rev));
    FileRename(TmpFName, UpdatePath + SetupUpdateFName(Rev));
  end;

  cursor := crdefault;
end;

procedure TFormBaseUpdate.Button8Click(Sender: TObject);
begin
  DownLoadUpdate(CargoBayRev);
  EnforceApplicationUpdateTo(CargoBayRev);
end;

procedure TFormBaseUpdate.Button4Click(Sender: TObject);
begin
  EnforceApplicationUpdateTo(globals.version);
end;

procedure TFormBaseUpdate.UpdateRevCaptions;
begin
  BeginHourGlass;
  StaticText1.caption := RevToStr(BaseRev);
  StaticText2.caption := RevToStr(globals.Version);
  statictext3.Caption := RevToStr(CargoBayRev);
  StaticText5.Caption := RevToStr(BaseUpdateRev);
  StaticText6.caption := RevToStr(NewestUpdateRev);
  label5.caption := iDataBaseName;
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
    ShowMessage('Anstehende Änderung der Datenbankstruktur!' + #13 +
      'Bitte beenden Sie sofort ' + cApplicationName + '. In wenigen' + #13 +
      'Sekunden erfolgt die Zwangstrennung!');
  end;

  //
  UpdateUserCount;
end;

procedure TFormBaseUpdate.FormDeactivate(Sender: TObject);
begin
  timer1.Enabled := false;
end;

function TFormBaseUpdate.NewestUpdateRev: single;
var
  NewestUpdatesL: TStringList;
begin
  NewestUpdatesL := TStringList.create;
  dir(UpdatePath + '*', NewestUpdatesL, false);
  if (NewestUpdatesL.count = 0) then
  begin
    result := 0.000;
  end else
  begin
    NewestUpdatesL.sort;
    result := strtointdef(nextp(NewestUpdatesL[pred(NewestUpdatesL.count)], '-', 2), 0) / 1000;
  end;
  NewestUpdatesL.free;
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
    REVISION := TIB_Query.Create(self);
    with REVISION do
    begin
      IB_Connection := IBC;
      sql.add('SELECT * FROM REVISION ORDER BY RID DESCENDING FOR UPDATE');
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
      if not (FireOnceInformed) then
      begin
        FireOnceInformed := true;
        timer1.Enabled := true;
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
  k: integer;
begin
  result := cRevNotAValidProject;
  try
    wow := IDhttp1.get(CargoBayWebAdress +
      cApplicationName +
      'Rev.html' +
      '?p=' + FindANewPassword('', 12));
    k := pos(' Rev ', wow);
    if (k <> -1) then
      result := strtodouble(copy(wow, k + 5, 4)) / 1000
    else
      CareTakerLog(cERRORText + ' BaseUpdate.get: ' + IDhttp1.ResponseText);
  except
    on e: exception do CareTakerLog(cERRORText + ' BaseUpdate.get: ' + e.message);
  end;
end;

function TFormBaseUpdate.CargobayWebAdress: string;
begin
  result := 'http://cargobay.orgamon.org/';
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
  dEVENT := TIB_DSQL.create(self);
  with dEVENT do
  begin
    sql.add('delete from REVISION where RID=' + inttostr(RevAsInteger(Rev)));
    execute;
    sql.clear;
    sql.add('insert into REVISION (RID) values (' + inttostr(RevAsInteger(Rev)) + ')');
    execute;
  end;
  dEVENT.free;
end;

procedure TFormBaseUpdate.ermittelnClick(Sender: TObject);
begin
  UpdateUserCount;
end;

procedure TFormBaseUpdate.UpdateUserCount;
begin
  if assigned(IBC) then
    StaticText4.Caption := inttostr(IBC.Users.Count);
end;

procedure TFormBaseUpdate.CloseEvent;
var
  xREVISION: TIB_DSQL;
begin

  // Remove "Update" - Lock
  xREVISION := TIB_DSQL.create(self);
  with xREVISION do
  begin
    sql.add('delete from REVISION where RID>=9998');
    execute;
  end;
  xREVISION.free;

  // Switch on the Update Alerter
  IB_Events1.registered := true;

end;

procedure TFormBaseUpdate.DataBaseUpdate;
var
  HeaderStr: string;
  StepNo: integer;
  RunNo: integer;
  _SYSDBA_password: string;

  procedure RunNow;
  var
    RunPersmission: boolean;
  begin

    if CheckBox1.Checked then
    begin
      RunPersmission := DoIt(IB_Script1.sql);
    end else
    begin
      RunPersmission := true;
    end;

    listbox1.items.assign(IB_Script1.sql);
    inc(StepNo);
    label7.caption := 'Schritt Nó ' + inttostr(StepNo) + ' (' + HeaderStr + ')';
    Application.processmessages;

    if RunPersmission then
    begin
      try
        inc(RunNo);
        if (pos('reconnect', IB_Script1.sql[0]) > 0) then
        begin
          with IB_Script1.IB_Connection do
          begin
            disconnect;
            connect;
          end;
        end else
        begin
          IB_Script1.Execute;
        end;
      except
        on e: exception do CareTakerLog(cERRORText + ' BaseUpdate.' + e.message);
      end;
    end;
    IB_Script1.sql.clear;
  end;

var
  _UpdateFrom, _UpdateTo, BringTo: integer;
  k: integer;
  n: integer;
  UpdateData: TSearchStringList;
  UserCount: integer;
  _db_UserName: string;
  _db_password: string;

begin
  // hole neueste Infos
  EnsureSQLUpdateScript;

  // alle freundlich aufordern, das Programm zu verlassen!
  BeginHourGlass;
  FireEvent(9.998);
  delay(200);
  EndHourGlass;

  repeat
    UserCount := IBC.Users.Count;
    if (UserCount = 1) then
      break;

    case YesNoIgnore('Es ist/sind noch ' + inttostr(UserCount - 1) + ' andere Benutzer' + #13 +
      'mit der Datenbank verbunden. Dies kann zur Folge haben, dass' + #13 +
      'wichtige Änderungen nicht durchgeführt werden können.' + #13 +
      'Stellen Sie jetzt sicher, dass diese Verbindungen' + #13 +
      'getrennt werden - drücken Sie ' + #13 +
      '<Abbrechen> um die Zwangsbeendigung aller Verbindungen auszulösen. (empfohlen nach 1 Minute).' + #13 +
      '<Wiederholen> um noch etwas zu warten. (empfohlen innerhalb 1 Minute).' + #13 +
      '<Ignorieren> um dennoch das Update durchzuführen. (NICHT EMPFOHLEN)') of
      IDCANCEL,
        IDABORT: FireEvent(9.999);
      IDOK,
        IDRETRY: ;
      IDIGNORE: break;
    end;

    BeginHourGlass;
    delay(500);
    EndHourGlass;

  until false;

  BeginHourGlass;

  _UpdateFrom := round(BaseRev * 1000);
  _UpdateTo := round(globals.Version * 1000);
  UpdateData := TSearchStringList.create;
  UpdateData.addStrings(SQLUpdateScript);
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
      _SYSDBA_password := FormEinstellungen.SysDBApassword;
      Username := 'SYSDBA';
      password := _SYSDBA_password;
    end;
    connect;
  end;

  IB_Script1.IB_Connection := IBC;
  for BringTo := succ(_UpdateFrom) to _UpdateTo do
  begin
    // Datenbank-Änderungen durchführen
    HeaderStr := ':' + RevToStr(BringTo / 1000.0);
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

  // hier, ev. Einzelne Hand-Codierte Datenänderungen durchführen
(*
    case BringTo of
      2000: ShowMessage('Willkommen in der Rev. 2.000');
    end;
*)

  end;
  UpdateData.free;

  // change to old User
  with IBC do
  begin
    if (UserName <> _db_UserName) then
    begin
      disconnect;
      Username := _db_UserName;
      password := _db_password;
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
  end else
  begin
    if (StepNo = (RunNo - ErrorCount)) then
    begin
      // Erfolg eintragen
      SetToActualRevision(IBC);
      BaseUpdateAbgeschlossen := true;
      close;
      ShowMessage('Das Update wurde ohne Fehler durchgeführt!' + #13 +
        'Auf anderen Arbeitsplätzen darf die Anwendung' + #13 +
        'nun gestartet werden!');
    end else
    begin
      if (ErrorCount > 0) then
      begin
        ShowMessage('Update nicht fehlerfrei ausgeführt!' + #13 +
          'Spielen Sie das Datenbank-Backup ein und' + #13 +
          'führen Sie das Update im Einzelschrittmodus aus' + #13 +
          'um einzukreisen welcher Update-Schritt problematisch' + #13 +
          'war. Die Anwendung sollte nicht verwendet werden!');
      end else
      begin
        if doit('Das Update wurde nicht vollständig ausgeführt!' + #13 +
          'Sind dennoch alle notwendigen Schritte' + #13 +
          'z.B. durch eine externe Anwendung bereits' + #13 +
          'erfolgt', true) then
        begin
          CareTakerLog(cERRORText + ' BaseUpdate.ForceRev: USER OVERRIDE');
          SetToActualRevision(IBC);
          BaseUpdateAbgeschlossen := true;
          close;
        end;
      end;
    end;
  end;
end;

procedure TFormBaseUpdate.CheckBox2Click(Sender: TObject);
begin
  if CheckBox2.checked then
    FireEvent(9.999)
  else
    CloseEvent;
end;

procedure TFormBaseUpdate.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if assigned(IBC) then
  begin
    if (IBC.connected) then
    begin
      if CheckBox2.checked then
        CloseEvent;
    end;
  end;
end;

procedure TFormBaseUpdate.FormDestroy(Sender: TObject);
begin
  SQLUpdateScript.free;
end;

procedure TFormBaseUpdate.RestartApplication;
const
  cUpdateBatFName = 'update.bat';
var
  OutF: TextFile;
  AllParams: string;
  n: integer;
begin
  NoTimer := true;
  AssignFile(OutF, MyApplicationPath + cUpdateBatFName);
  rewrite(OutF);
  writeln(OutF, '@echo off');
  writeln(OutF, MyApplicationPath + 'sleep.com 25');
  AllParams := '';
  for n := 1 to ParamCount do
    AllParams := AllParams + ' ' + ParamStr(n);
  writeln(OutF, 'start ' + application.exename + AllParams + ' -lr'); // "log restart"
  CloseFile(OutF);
  spawn(MyApplicationPath + cUpdateBatFName);
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

function TFormBaseUpdate.CloseOtherInstances: boolean;
var
  AllW: TStringList;
  n: integer;
  OneFound: boolean;
  OneStillOpen: boolean;
  CloseTry: integer;
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
      if (pos(cApplicationName + cTradeMark + ' Rev', AllW[n]) = 1) then
      begin
        OneFound := true;
        if (hwnd(AllW.objects[n]) <> Application.MainForm.handle) then
        begin
          PostMessage(hwnd(AllW.objects[n]), WM_CLOSE, 0, 0);
          OneStillOpen := true;
        end;
      end;
    if (CloseTry = 4) then
    begin
      result := false;
      ShowMessage('Andere laufende ' +
        cApplicationName +
        cTradeMark +
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
//  AllW.SaveTofile(DiagnosePath + 'AlleOffenenFenster.txt');
//  open(DiagnosePath + 'AlleOffenenFenster.txt');
  Allw.free;
  if not (OneFound) then
    CareTakerLog(cERRORtext + ' CloseOtherInstances: Nicht mal die eigene Instanz gefunden!');
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

