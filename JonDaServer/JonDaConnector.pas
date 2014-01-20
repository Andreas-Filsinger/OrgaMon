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
unit JonDaConnector;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,

  // XML RPC
  xmlrpcserver, { XML stuff }
  xmlrpctypes, { XML stuff }
  xmlrpcsynchclasses, { synch class }
  xmlrpcthreadallocator,

  // Tools
  wordindex,
  idglobal,

  // JonDaServer
  globals,
  JonDaExec;

type
  TFormJonDaConnector = class(TForm)

    CheckBox1: TCheckBox;
    lstMessages: TListBox;
    Timer1: TTimer;
    StaticText1: TStaticText;
    CheckBox2: TCheckBox;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    CheckBox3: TCheckBox;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);

  private
    { Private declarations }

    // globals
    FirstTimerEventChecked: boolean;
    Initialised: integer;
    FServer: TServer;
    FAllocator: TThreadAllocator;
    _RDTSCmc: int64;
    _RDTSCpause: int64;
    JonDaX : TJonDaExec;


    // 1) für e_r_StartTAN
    FSynchroniser_1: TSynchroniser;
    FMethodHandler_1: TMethodHandler;
    Flist_1: TList;
    FReturn_1: TReturn;
    ResultRIDs_1: TArray;

    // 2) für e_r_ProceedTAN
    FSynchroniser_2: TSynchroniser;
    FMethodHandler_2: TMethodHandler;
    Flist_2: TList;
    FReturn_2: TReturn;

    // 11) für e_r_BasePlug
    FSynchroniser_11: TSynchroniser;
    FMethodHandler_11: TMethodHandler;
    Flist_11: TList;
    FReturn_11: TReturn;
    ResultStrings_11: TArray;

    procedure AddMessage(const Msg: string);
    procedure BeginDebug(const Msg: string);
    procedure EndDebug(const Msg: string = '');
    function AllocateStringList: TObject;
    procedure StartServer;

    // für e_r_StartTAN
    procedure Call_e_r_StartTAN(const MethodName: string; const plist: TList;
      const return: TReturn);
    procedure Do_e_r_StartTAN(Sender: TObject);

    // für e_r_ProceedTAN
    procedure Call_e_r_ProceedTAN(const MethodName: string; const plist: TList;
      const return: TReturn);
    procedure Do_e_r_ProceedTAN(Sender: TObject);

    // für e_r_BasePlug
    procedure Call_e_r_BasePlug(const MethodName: string; const plist: TList;
      const return: TReturn);
    procedure Do_e_r_BasePlug(Sender: TObject);

  public
    { Public declarations }
    { exposed delphi method }
    procedure rpc_e_r_StartTAN(const MethodName: string; const plist: TList;
      const return: TReturn);
    procedure rpc_e_r_ProceedTAN(const MethodName: string; const plist: TList;
      const return: TReturn);
    procedure rpc_e_r_BasePlug(const MethodName: string; const plist: TList;
      const return: TReturn);

    procedure UpdateClicksCount(Clicks: integer); overload;
  end;

var
  FormJonDaConnector: TFormJonDaConnector;

implementation

{$R *.dfm}

uses
  anfix32, html, DateUtils,
  GUI, IdFTP;

procedure TFormJonDaConnector.Timer1Timer(Sender: TObject);
begin
  if NoTimer then
    exit;
  //
  if not(FirstTimerEventChecked) then
  begin
    FirstTimerEventChecked := true;
    if IsParam('-dx') then
      Timer1.enabled := false;
    exit;
  end;

  if AllSystemsRunning then
  begin

    //
    case Initialised of
      0:
        if (AnSiUpperCase(ComputerName) = AnSiUpperCase(FormGUI.iXMLRPCHost))
          then
        begin
          Initialised := 1;
          StartServer;
          CheckBox1.Checked := true;
        end
        else
        begin
          CheckBox1.caption := FormGUI.iXMLRPCHost + ' ist Server';
          Initialised := 2;
        end;
      1:
        ; // Initializing ...
      2: // !Server online!
        if (JonDaX.Stat_Clicks > 0) then
        begin

          UpdateClicksCount(JonDaX.Stat_Clicks);

        end;
      3: // please dont waste time and stop!
        Timer1.enabled := false;
    end;

    //

  end;
end;

procedure TFormJonDaConnector.AddMessage(const Msg: string);
begin
  lstMessages.Items.Add(IntToStr(GetCurrentThreadId) + ' ' + Msg);
  application.processmessages;
end;

procedure TFormJonDaConnector.StartServer;
begin

  if (FServer = nil) then
    FServer := TServer.Create;

  if not(FServer.Active) then
  begin

//    SetPriorityClass(GetCurrentProcess, DWORD(ABOVE_NORMAL_PRIORITY_CLASS));

    if FMethodHandler_1 = nil then
    begin
      // _1
      ResultRIDs_1 := TArray.Create;
      FMethodHandler_1 := TMethodHandler.Create;
      FSynchroniser_1 := TSynchroniser.Create; // #
      FMethodHandler_1.Name := 'StartTAN';
      FMethodHandler_1.Method := Call_e_r_StartTAN;
      FSynchroniser_1.Method := Do_e_r_StartTAN;
      FServer.RegisterMethodHandler(FMethodHandler_1);
    end;

    if FMethodHandler_2 = nil then
    begin
      // _2
      FMethodHandler_2 := TMethodHandler.Create;
      FSynchroniser_2 := TSynchroniser.Create; // #
      FMethodHandler_2.Name := 'ProceedTAN';
      FMethodHandler_2.Method := Call_e_r_ProceedTAN;
      FSynchroniser_2.Method := Do_e_r_ProceedTAN;
      FServer.RegisterMethodHandler(FMethodHandler_2);
    end;

    if (FMethodHandler_11 = nil) then
    begin
      // _11
      FMethodHandler_11 := TMethodHandler.Create;
      FSynchroniser_11 := TSynchroniser.Create; // #
      FMethodHandler_11.Name := 'BasePlug';
      FMethodHandler_11.Method := Call_e_r_BasePlug;
      FSynchroniser_11.Method := Do_e_r_BasePlug;
      ResultStrings_11 := TArray.Create;
      FServer.RegisterMethodHandler(FMethodHandler_11);
    end;

    FServer.ListenPort := StrToIntDef(FormGUI.iXMLRPCPort, 80);
    FServer.Active := true;
    AddMessage('xml-rpc Server wurde gestartet (' + ComputerName + ':' +
        IntToStr(FServer.ListenPort) + ')');
    Initialised := 2;
    _RDTSCpause := RDTSCms;

  end
  else
  begin
    FServer.Active := false;
    Initialised := 3;
    AddMessage('xml-rpc Server wurde gestoppt');
  end;

end;

procedure TFormJonDaConnector.rpc_e_r_StartTAN(const MethodName: string;
  const plist: TList; const return: TReturn);
var
  s: string;
  GeraetID: string;
  _TAN: string;
  VERSION, OPTIONEN, UHR: string;
  TAN: string;
  OptionStrings: TStringList;
  MomentDate: TANFiXDate;
  MomentTime: TANFiXTime;
begin
  MomentDate := DateGet;
  MomentTime := SecondsGet;

  try

    s := html2ansi(TParameter(plist[0]).GetString);

    GeraetID := nextp(s, ';', 0);
    _TAN := nextp(s, ';', 1);
    VERSION := nextp(s, ';', 2);
    OPTIONEN := nextp(s, ';', 3);
    UHR := nextp(s, ';', 4); // Format: "26.09.2005 - 07:21:05"

    if CheckBox2.Checked then
      AddMessage(MethodName + ' ' + s);

    repeat

      // vorbereiteter Fehler
      if (Edit1.Text <> '') then
      begin
        TAN := Edit1.Text;
        Edit1.Text := '';
        break;
      end;

      // grössere Zeitabweichung?
      if not(CheckBox3.Checked) then
      begin
        if SecondsDiffABS(DateGet, SecondsGet, date2long(nextp(UHR, ' - ', 0)),
          strtoSeconds(nextp(UHR, ' - ', 1))) > 60 * 5 then
        begin
          TAN := 'Handyzeit sollte ' + long2date(DateGet)
            + ' - ' + secondstostr8(SecondsGet + 1)
            + ' sein (Ist aber ' + UHR + ').';
          break;
        end;
      end;

      // TAN jetzt berechnen
      TAN := JonDaX.FolgeTAN(GeraetID);

      if not(FileExists(JonDaX.UpFName(TAN))) then
      begin
        // Erstmaliges Übertragen?!
        OptionStrings := TStringList.Create;
        with OptionStrings do
        begin
          Add('TAN=' + _TAN);
          Add('VERSION=' + VERSION);
          Add('OPTIONEN=' + OPTIONEN);
          Add('UHR=' + UHR);

          // Format: "26.09.2005 - 07:21:05"
          Add('MOMENT=' + long2date(MomentDate) + ' - ' + secondstostr8
              (MomentTime));
          Add('GERAET=' + GeraetID);
        end;
        AppendStringsToFile(OptionStrings,
          MyProgramPath + TAN + '\' + TAN + '.txt');
        OptionStrings.free;
      end;

      // Sicherstellen, dass es die Gerätenummer gibt.
      FileEmpty(MyProgramPath + TAN + '\' + GeraetID + '.zip');

    until true;
  except
    TAN := cERROR_TAN;
  end;

  // Ergebnis und den Call loggen!
  AppendStringsToFile(DatumLog + ';' + uhr8 + ';' + 'StartTAN:' + TAN + ';' +
      s, MyProgramPath + cJonDaServer_XMLRPCLogFName);

  return.AddParam(TAN);
end;

procedure TFormJonDaConnector.Call_e_r_StartTAN(const MethodName: string;
  const plist: TList; const return: TReturn);
begin
  Flist_1 := plist;
  FReturn_1 := return;
  FSynchroniser_1.RunMethod(self);
  Flist_1 := nil;
  FReturn_1 := nil;
end;

procedure TFormJonDaConnector.Do_e_r_StartTAN(Sender: TObject);
begin
  BeginDebug('StartTAN');
  rpc_e_r_StartTAN('StartTAN', Flist_1, FReturn_1);
  EndDebug;
end;

function TFormJonDaConnector.AllocateStringList: TObject;
begin
  Result := TStringList.Create;
end;

procedure TFormJonDaConnector.FormCreate(Sender: TObject);
begin
  FAllocator := TThreadAllocator.Create;
  FAllocator.CreationProc := AllocateStringList;
end;

procedure TFormJonDaConnector.FormDestroy(Sender: TObject);
begin
  FAllocator.free;
  FServer.free;
end;

procedure TFormJonDaConnector.Call_e_r_ProceedTAN(const MethodName: string;
  const plist: TList; const return: TReturn);
begin
  Flist_2 := plist;
  FReturn_2 := return;
  FSynchroniser_2.RunMethod(self,true);
  Flist_2 := nil;
  FReturn_2 := nil;
end;

procedure TFormJonDaConnector.Do_e_r_ProceedTAN(Sender: TObject);
begin
  BeginDebug('ProceedTAN');
  rpc_e_r_ProceedTAN('ProceedTAN', Flist_2, FReturn_2);
  EndDebug;
end;

procedure TFormJonDaConnector.rpc_e_r_ProceedTAN(const MethodName: string;
  const plist: TList; const return: TReturn);
var
  TAN: string;
  sResult, sParameter: TStringList;
begin
  sParameter := TStringList.create;
  try

    TAN := TParameter(plist[0]).GetString;
    sParameter.Values['TAN'] := TAN;

    AppendStringsToFile(DatumLog + ';' + uhr8 + ';' + 'ProceedTAN:' + TAN,
      MyProgramPath + cJonDaServer_XMLRPCLogFName);
    sResult := JonDaX.proceed(sParameter);
    if (sREsult.Values['OK']=cIni_Activate) then
    begin
      return.AddParam(0);
    end
    else
    begin
      return.AddParam(30001);
    end;
  except
    return.AddParam(30002);
  end;
end;

procedure TFormJonDaConnector.Call_e_r_BasePlug(const MethodName: string;
  const plist: TList; const return: TReturn);
begin
  Flist_11 := plist;
  FReturn_11 := return;
  FSynchroniser_11.RunMethod(self);
  Flist_11 := nil;
  FReturn_11 := nil;
end;

procedure TFormJonDaConnector.Do_e_r_BasePlug(Sender: TObject);
begin
  BeginDebug('BasePlug');
  rpc_e_r_BasePlug('BasePlug', Flist_11, FReturn_11);
  EndDebug;
end;

procedure TFormJonDaConnector.rpc_e_r_BasePlug(const MethodName: string;
  const plist: TList; const return: TReturn);
begin
  ResultStrings_11.clear;
  ResultStrings_11.additem(MyProgramPath);
  ResultStrings_11.additem(cApplicationName + ' Rev. ' + RevToStr
      (globals.VERSION));
  ResultStrings_11.additem(gsIdProductName + ' Rev. ' + gsIdVersion);
  ResultStrings_11.additem('ANFiX Rev. ' + RevToStr(VersionAnfix32));
  ResultStrings_11.additem(ComputerName);
  ResultStrings_11.additem(Datum + ' ' + uhr8);
  ResultStrings_11.additem(JonDaX.ActTrn + '.' + IntToStr(JonDaX.Stat_Clicks));
  ResultStrings_11.additem(iUserName + '@' + iHost);

  return.AddParam(ResultStrings_11);
end;

procedure TFormJonDaConnector.FormActivate(Sender: TObject);
begin
  UpdateClicksCount(JonDaX.Stat_Clicks);
end;

procedure TFormJonDaConnector.UpdateClicksCount(Clicks: integer);
begin
  StaticText1.caption := Datum + ' : ' + IntToStr(Clicks);
end;

procedure TFormJonDaConnector.BeginDebug(const Msg: string);
begin
  if CheckBox2.Checked then
  begin
    AddMessage('(Idle ' + IntToStr(RDTSCms - _RDTSCpause)
        + ' ms) ' + Msg + ' ...');
    _RDTSCmc := RDTSCms;
  end;
end;

procedure TFormJonDaConnector.EndDebug(const Msg: string = '');
begin
  if CheckBox2.Checked then
  begin
    if (Msg <> '') then
      AddMessage(Msg + ' ...');
    with lstMessages do
      Items[pred(Items.count)] := Items[pred(Items.count)]
        + ' (needed  ' + IntToStr(RDTSCms - _RDTSCmc) + ' ms)';
    _RDTSCpause := RDTSCms;
    application.processmessages;
  end;
end;

procedure TFormJonDaConnector.Button2Click(Sender: TObject);
begin
  lstMessages.Items.clear;
end;

procedure TFormJonDaConnector.Button3Click(Sender: TObject);
begin
  ShowMessage('Stufe 1: Message Box offen!' + #13 +
      '<Enter> für Stufe2 -> danach Endlosschleife');
  while true do
    ;
end;

end.
