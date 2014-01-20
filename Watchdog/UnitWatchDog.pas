unit UnitWatchDog;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  SvcMgr, Dialogs, ExtCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient;

type
  TServiceWatchDog = class(TService)
    Timer1: TTimer;
    IdTCPClient1: TIdTCPClient;
    procedure Timer1Timer(Sender: TObject);
    procedure ServiceExecute(Sender: TService);
    procedure ServiceAfterInstall(Sender: TService);
  private
    { Private-Deklarationen }
    TimeWithOutFunction: dword;
    TimeWithOutNachtrag: dword;
    TimeEverCalled: dword;
  public
    function GetServiceController: TServiceController; override;
    { Public-Deklarationen }
  end;

var
  ServiceWatchDog: TServiceWatchDog;

implementation

uses
  Registry, ServiceManager, anfix32,
  CareTakerClient;

{$R *.DFM}

const
  Version: single = 1.002; // \rev\WatchDog.rev

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ServiceWatchDog.Controller(CtrlCode);
end;

function TServiceWatchDog.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TServiceWatchDog.Timer1Timer(Sender: TObject);
begin

  // erster Aufruf wird ignoriert
  inc(TimeEverCalled, timer1.interval);
  if (TimeEverCalled = timer1.interval) then
    exit;

  // a) Prüfe, ob Nachmeldungen zu machen sind
  inc(TimeWithOutNachtrag, timer1.interval);
  if (TimeWithOutNachtrag > 30 * 60 * 1000) then
  begin
    Nachmeldungen;
    TimeWithOutNachtrag := 0;
  end;

  // b) Prüfe, ob XML RPC verfügbar ist
  with IdTCPClient1 do
  begin
    try
      connect;
      TimeWithOutFunction := 0;
    except
      inc(TimeWithOutFunction, timer1.interval);
      if (TimeWithOutFunction >= 3 * 60 * 1000) then
      begin
        CareTakerLog(cERRORText + ' Watchdog Alarm!');
        TimeWithOutFunction := 0;
        WindowsNeuStarten;
      end;
      beep;
    end;
    try
      disconnect;
    except
      ;
    end;
  end;

  // c)
end;

procedure TServiceWatchDog.ServiceExecute(Sender: TService);
begin
  while not Terminated do
    ServiceThread.ProcessRequests(True);
end;

procedure TServiceWatchDog.ServiceAfterInstall(Sender: TService);
var
  reg: TRegistry;
  sm: TServiceManager;
begin

  // Name registrieren
  reg := TRegistry.Create;
  try
    with reg do begin
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('SYSTEM\CurrentControlSet\Services\' + Name, false) then
      begin
        WriteString('Description', 'Überwacht XMLRPC auf Port 3049. Rev ' + RevToStr(Version));
      end;
      CloseKey;
    end;
  finally
    reg.Free;
  end;

  // Autostart
  sm := TServiceManager.Create;
  try
    if sm.Connect then
      if sm.OpenServiceConnection(PChar(self.name)) then
        sm.StartService;
  finally
    sm.Free;
  end;

end;

end.

