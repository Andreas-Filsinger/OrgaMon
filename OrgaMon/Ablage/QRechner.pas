unit QRechner;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls,
  StdCtrls, anfix32, INIFiles,
  ScktComp, Menus, printers,
  GIFImage, globals;

const
  cSurfMax = 6 * 60;
  cRechnerMax = 24;
  cZeitSchwellenMax = 10;


type
  eCommands = (cNone, cBeep, cHerunterFahren, cNeuStart, cClose, cArbeitsplatzOK, cLock, cFree);
  TRechnerInfo = packed record
                 // Status des Client
    IPadress: string[64];
    ComputerName: string[64];
    LinkOK: boolean; // Socket-Verbindung OK!
    ClientLocked: boolean; // Client=Blau

                 //  Das nächste Commando
    Command: eCommands; // Das nächste Commando!

                 // für das Geldverdienen
    tarif: byte; // 0,1
    MoneyOnSoll: boolean; // jetzt sollte Geld verdient werden!
    sDate: TAnfixDate; // Start
    sTime: TAnfixTime;
    eDate: TAnfixDate; // Ende
    eTime: TAnfixTime;
    LetzterPreis: extended;
    Storniert: boolean;
    BelegNo: integer;

                 // Pausen verwaltung
    PausedOn: boolean; // jetzt ist Pause
    PausedOld: integer; // Zeit, die in alten Pausen verwendet wurde
    PausedNow: integer; // Zeit, die in der aktuellen Pause verwendet wird
    pDate: TAnfixDate; // Pausen-Start
    pTime: TAnfixTime;


                 // Bediener Infos
    UserNameAn: string[10];
    UserNameAus: string[10];

  end;

  TTarifSystem = array[1..cSurfMax] of extended;
  TZeitSchwellen = record
    anfang: TAnfixTime;
    ende: TAnfixTime;
  end;

type
  TFormQRechner = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    ClientSocket1: TClientSocket;
    PopupMenu1: TPopupMenu;
    StartTarif11: TMenuItem;
    StartTraif21: TMenuItem;
    PCwiederfrei1: TMenuItem;
    drucken1: TMenuItem;
    N1: TMenuItem;
    vlligentsperren1: TMenuItem;
    neubooten1: TMenuItem;
    Neustarten1: TMenuItem;
    DiagnoseBeep1: TMenuItem;
    Panel1: TPanel;
    ArbeitsplatzOK1: TMenuItem;
    ListBox1: TListBox;
    PAUSE1: TMenuItem;
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ClientSocket1Connect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DiagnoseBeep1Click(Sender: TObject);
    procedure vlligentsperren1Click(Sender: TObject);
    procedure neubooten1Click(Sender: TObject);
    procedure Neustarten1Click(Sender: TObject);
    procedure StartTarif11Click(Sender: TObject);
    procedure StartTraif21Click(Sender: TObject);
    procedure PCwiederfrei1Click(Sender: TObject);
    procedure drucken1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ArbeitsplatzOK1Click(Sender: TObject);
    procedure PAUSE1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
    Initialized: boolean;

    procedure WMEraseBkgnd(var m: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure init;
  public
    { Public-Deklarationen }
    Rechner: array[0..pred(cRechnerMax)] of TRechnerInfo;
    RechnerIP: array[0..pred(cRechnerMax)] of string;
    ActRechner: integer;
    RechnerClicked: integer;

    // TimeOut Connector
    _LastOpenedRechner: integer;
    CheckForTimeOut: boolean;
    TimeOutStamp: dword;

    // Abrechnungs-Daten
    iPreis: extended;
    iPreis2: extended;
    iWaehrung: string;
    iZeitSchwelle: array[1..cZeitSchwellenMax] of TZeitSchwellen;
    iZeitSchwelleAnz: integer;
    iBelegHeader: string;
    iBelegFooter: string;
    iAutoPrint: boolean;
    iAbrechnungFooter: string;
    iMwSt: extended;
    iAutoBenutzerSpeichern: boolean;
    iDebug: boolean;
    iPrint: boolean;

    // mögliche Benutzer
    Codes: TStringList;
    LoggedInUser: string;
    TypedInByNow: string;
    UserLevel: integer;

    // Tarif-System
    TarifMinuten: array[0..3] of TTarifSystem; // Preis für diese Minute!

    // preferec next Computer
    NextToCall: TStringList;

    // weil nich alle auf einen Schirm passen!
    RechnerShowOffset: integer;

    procedure DrawInfo;
    function IPtoRechner(IPadress: string): integer;
    procedure OpenRechner(n: integer);
    procedure OpenNextRechner;
    procedure SaveData;
    procedure LoadData;
    procedure WriteLog(s: string);
    procedure WriteStatistik(s: string);
    procedure RechnerToXY(n: integer; var x, y: integer);
    procedure PopUpEnableDisable;

    procedure StartRechner(n: integer; Tar: byte);
    procedure StopRechner(n: integer);
    function iniFName: string;
    function dataFName: string;
    function statistikFName: string;
    function StorniertToStr(s: boolean): string;

    function PreisFuerMinute(t: byte; minute: integer; zeit: TAnfixTime): extended;
    procedure BucheEndeStatus(RechnerID: integer);
    function NewTrn: integer;
    procedure ShowUser;
    procedure PostCommand(RechnerID: integer; cmd: eCommands);
    procedure DebugLog(s: string);
    procedure StartPause(RechnerID: integer);
    procedure EndePause(RechnerID: integer);
  end;

var
  FormQRechner: TFormQRechner;

implementation

uses
  {code,
  Settings, LinePrinter32,
  }
  math;

{$R *.DFM}


type
  TWert = class(TObject)
    Wert: extended;
  end;


const
  bstransparent = bsdiagcross;
  cRechnerPerRow = 4;
  MyProgramPath: string = '';
  cClientTimeOut = 400; // [ms]
  cXSize = 158;
  cYSize = 139;
  cXOffset = 31;
  cYOffset = 18;
  cLetzerBenutzerFName = 'Letzer Benutzer.ini';


procedure TFormQRechner.Timer1Timer(Sender: TObject);
var
  _linkOK: boolean;
begin
  if not (NoTimer) then
  begin
    if CheckForTimeOut then
    begin
      if (GetTickCount > TimeOutStamp) then
      begin
        DebugLog(Rechner[_LastOpenedRechner].IPadress + ' timeout!');
        CheckForTimeOut := false;
        with Rechner[_LastOpenedRechner] do
        begin
    // switch to offline
    // go to offline
          ComputerName := 'OFF LINE';
          _linkOK := LinkOK;
          LinkOK := false;
          command := cNone;
          if MoneyOnSoll and (LinkOK <> _LinkOK) then
            StartPause(_LastOpenedRechner);
        end;
        ClientSocket1.Socket.close;
        ClientSocket1.close;
      end else
      begin
        DebugLog(Rechner[_LastOpenedRechner].IPadress + ' wait!');
      end;
    end else
    begin
      OpenNextRechner;
    end;
    image1.Refresh;
    DrawInfo;
  end;
end;

procedure TFormQRechner.FormKeyPress(Sender: TObject;
  var Key: Char);
begin

  if key in ['0'..'9', 'a'..'z', 'ä', 'ü', 'ö', 'ß'] then
  begin

    if (LoggedInUser <> '') then
    begin
      LoggedInUser := '';
      TypedInByNow := '';
    end;

    TypedInByNow := TypedInByNow + ansilowercase(key);
    ShowUser;
  end;
  if (key = #8) then
    if TypedInByNow <> '' then
    begin
      delete(TypedInByNow, length(TypedInByNow), 1);
      ShowUser;
    end;

  if (key = #27) then
  begin
    key := #0;
    close;
  end;
end;

procedure TFormQRechner.DrawInfo;
var
  n, x, y, m: integer;
  s: TAnfixTime;
  ThisT: TAnfixTime;
  ThisD: TAnfixDate;
  SaveSuggested: boolean;
  _Preis: extended;
begin
  with canvas do
  begin
    ThisT := SecondsGet;
    ThisD := DateGet;
    font.color := clyellow;
    SaveSuggested := false;

    for n := RechnerShowOffset to pred(RechnerShowOffset + 12) do
    begin
      x := cXOffset + (n mod cRechnerPerRow) * cXSize;
      y := cYOffset + ((n - RechnerShowOffset) div cRechnerPerRow) * cYSize;
      with Rechner[n] do
      begin

        font.Name := 'Verdana';
        font.size := -10;
        font.style := [fsbold];
        brush.style := bstransparent;

        TextOut(x, y, 'Nó ' + inttostr(succ(n)));
        if MoneyOnSoll then
          if PausedOn then
            TextOut(x + 83, y, 'P')
          else
            TextOut(x + 83, y, '€');

        if (Ipadress <> '') then
        begin
          font.name := 'Small Fonts';
          font.size := -7;
          font.style := [];
          TextOut(x, y + 16, Ipadress);
          TextOut(x, y + 23, ComputerName);
        end;


        if LinkOK then
        begin

     // ONLINE
          SaveSuggested := true;

          brush.color := cllime;
          brush.style := bssolid;
          FillRect(Rect(x + 40, y + 4, x + 50, y + 4 + 6));
          brush.style := bstransparent;

          if not (MoneyOnSoll) then
          begin
            font.name := 'Arial Black';
            font.size := -16;
            TextOut(x + (ThisT mod cRechnerMax) * 2, y + 30, 'FREI');
            font.name := 'Verdana';
            font.size := -10;
            font.style := [fsbold];
            TextOut(x, y + 52, format('%.2f %s', [LetzterPreis, iWaehrung]));
          end;

          if MoneyOnSoll and not (ClientLocked) then
          begin
      // Preise usw. neu eintragen
            eDate := ThisD;
            eTime := ThisT;

            if PausedOn then
              PausedNow := SecondsDiff(pDate, pTime, eDate, eTime)
            else
              PausedNow := 0;

            s := SecondsDiff(sDate, sTime, eDate, eTime) - (PausedOld + PausedNow);

            _Preis := 0.0;
            for m := 1 to (s div 60) + 1 do // "+1" man zahlt immer die Minute in Voraus!
              _Preis := _Preis + PreisFuerMinute(tarif, m, SecondsAdd(sTime, pred(m)));
            LetzterPreis := _Preis;

            font.name := 'Verdana';
            font.size := -15;
            font.style := [fsbold];
            TextOut(x, y + 30, secondstostr(s));
            font.size := -10;
            if (tarif = 0) then
              TextOut(x, y + 52, format('%.2f %s T1', [LetzterPreis, iWaehrung]))
            else
              TextOut(x, y + 52, format('%.2f %s T2', [LetzterPreis, iWaehrung]));

          end;

          if CLientLocked then
            brush.color := clblue
          else
            brush.color := cllime;

          brush.style := bssolid;
          FillRect(Rect(x + 55, y + 4, x + 65, y + 4 + 6));

          if (Command <> cNone) then
          begin
            brush.color := claqua;
            brush.style := bssolid;
            FillRect(Rect(x + 70, y + 4, x + 80, y + 4 + 6));
          end;

        end else
        begin

     // OFFLINE

          brush.color := clred;
          brush.style := bssolid;
          FillRect(Rect(x + 40, y + 4, x + 50, y + 4 + 6));


          if (Ipadress <> '') then
          begin
            font.name := 'Arial Black';
            font.size := -12;
            font.style := [];
            TextOut(x, y + 33, ' AUS ');

            font.name := 'Verdana';
            font.size := -10;
            font.style := [fsbold];
            brush.style := bstransparent;
            TextOut(x, y + 52, format('%.2f %s', [LetzterPreis, iWaehrung]));
          end;

        end;

      end;
    end;
    if SaveSuggested then
      SaveData;
  end;
end;

procedure TFormQRechner.WMEraseBkgnd(var m: TWMEraseBkgnd);
begin
  m.Result := LRESULT(false);
end;

procedure TFormQRechner.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  SaveData;
  if ClientSocket1.active then
    ClientSocket1.active := false;
  CanCLose := true;
end;

function TFormQRechner.IPtoRechner(IPadress: string): integer;
var
  n: integer;
begin
  result := -1;
  for n := 0 to pred(cRechnerMax) do
    if (IPadress = Rechner[n].ipadress) then
    begin
      result := n;
      break;
    end;
end;

function TFormQRechner.StorniertTostr(s: boolean): string;
begin
  if s then
    result := 'STORNIERT'
  else
    result := 'OK'
end;

// socket events

procedure TFormQRechner.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
var
  InpStr: string;
  n: integer;
  CommandStr: string;
  DateStr: string;
  PreisStr: string;

 // gesicherte Modi
  _ClientLocked: boolean;
  _LinkOK: boolean;

begin
  with Socket do
  begin
    if (ReceiveLength > 0) then
    begin
      InpStr := Socket.ReceiveText;
      n := IPtoRechner(RemoteAddress);
      if (n <> -1) then
      begin
        with Rechner[n] do
        begin
          DebugLog(RemoteAddress + ':' + InpStr);
          CommandStr := nextp(InpStr, ',');
          case CommandStr[1] of
            'S': begin
           // save old Values
                _ClientLocked := ClientLocked;
                _LinkOK := LinkOK;

           // read new values
                ComputerName := nextP(InpStr, ',');
                ClientLocked := nextP(InpStr, ',') <> 'FREE';
                DateStr := nextP(InpStr, ',');

                if MoneyOnSoll and ClientLocked then
                begin
                  PostCommand(n, cFree);
                  EndePause(n);
                end;

              end;
          end;
          LinkOK := abs(dateDiff(date2long(DateStr), DateGet)) < 2;
        end;
      end;
      close;
    end;
  end;
end;

procedure TFormQRechner.ClientSocket1Connect(Sender: TObject; Socket: TCustomWinSocket);
var
  n: integer;
  OutCmd: string;
  _LinkOK: boolean;
begin
  CheckForTimeOut := false;
  n := IPtoRechner(Socket.RemoteAddress);
  if (n <> -1) then
  begin
    with Rechner[n] do
    begin
      _LinkOK := LinkOK;

   // ev. noch Command mitschicken
      case Command of
        cBeep: OutCmd := 'B~';
        cArbeitsplatzOK: OutCmd := 'F~';
        cHerunterFahren: OutCmd := 'H~';
        cNeuStart: OutCmd := 'N~';
        cClose: OutCmd := 'X~';
        cLock: OutCmd := '0~';
        cFree: OutCmd := '1~';
      else
        OutCmd := '';
      end;

      LinkOK := true;
      Command := cNone;

   // Befehl absetzen
      ClientSocket1.Socket.SendText(OutCmd + 'S~');
    end;
  end;
end;

procedure TFormQRechner.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
var
  n: integer;
begin
  DebugLog(Socket.RemoteAddress + ' socket error ' + inttostr(ErrorCode));
  n := IPtoRechner(Socket.RemoteAddress);
  if (n <> -1) then
    Rechner[n].LinkOK := false;
  ErrorCode := 0;
end;

procedure TFormQRechner.OpenRechner(n: integer);
begin
  with Rechner[n] do
  begin
    if (IPAdress <> '') then
    begin
      if not (ClientSocket1.active) then
      begin
        ClientSocket1.Address := '';
        ClientSocket1.Host := IPadress;
        ClientSocket1.Open;
        CheckForTimeOut := true;
        TimeOutStamp := GetTickCount + cClientTimeOut;
        _LastOpenedRechner := n;
      end else
      begin
        ClientSocket1.Socket.close;
        ClientSocket1.close;
        DebugLog(ClientSocket1.Host + ' unexpected open socket -> closed now');
      end;
    end else
    begin
      LinkOK := false;
      MoneyOnSoll := false;
    end;
  end;
end;

procedure TFormQRechner.OpenNextRechner;
var
  NoIP: boolean;
begin

  if (NextToCall.count > 0) then
  begin
    ActRechner := strtoint(NextToCall[0]);
    NextToCall.delete(0);
  end;

  NoIP := (Rechner[ActRechner].ipadress = '');
  if not (NoIP) then
    OpenRechner(ActRechner);

  inc(ActRechner);
  if (ActRechner = cRechnerMax) then
  begin
    ActRechner := 0;
  end else
  begin

    if NoIP then
      OpenNextRechner;
  end;
end;

procedure TFormQRechner.Image1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  n: integer;
begin
  n := (cRechnerPerRow * ((y - cYOffset) div cYSize)) +
    ((x - cXOffset) div cXSize);
  inc(n, RechnerShowOffset);

  if (Button = mbleft) then
  begin
    if Rechner[n].MoneyOnSoll then
      StopRechner(n)
    else
      StartRechner(n, 0);
  end else
  begin
    RechnerClicked := n;
    PopUpEnableDisable;
    PopupMenu1.Popup(left + x, top + y);
  end;
end;

procedure TFormQRechner.SaveData;
var
  OutF: file;
begin
  AssignFile(OutF, DataFname);
  Rewrite(OutF, 1);
  BlockWrite(OutF, Rechner, sizeof(Rechner));
  CloseFile(OutF);
end;

procedure TFormQRechner.LoadData;
var
  InF: file;
  n: integer;
begin
  if FileExists(dataFName) then
  begin
    if (FSize(dataFName) = sizeof(Rechner)) then
    begin
      AssignFile(InF, dataFName);
      reset(InF, 1);
      BlockRead(InF, Rechner, sizeof(Rechner));
      CloseFile(InF);
    end;
  end;
 // store local "buffer" Data
  for n := 0 to pred(cRechnerMax) do
    rechner[n].IpAdress := RechnerIP[n];
end;

procedure TFormQRechner.WriteStatistik(s: string);
var
  OutF: TextFile;

  procedure OpenTheFile(FName: string);
  begin
    assignFile(OutF, FName);
    if FileExists(FName) then
      append(OutF)
    else
      rewrite(OutF);
  end;

begin
  OpenTheFile(statistikFName);
  writeln(OutF, s);
  CloseFile(OutF);

  OpenTheFile(MyPRogramPath + 'Statistik x m.txt');
  writeln(OutF, s);
  CloseFile(OutF);

  OpenTheFile(MyPRogramPath + 'Statistik x t.txt');
  writeln(OutF, s);
  CloseFile(OutF);
end;

procedure TFormQRechner.WriteLog(s: string);
var
  OutF: TextFile;
  DateStr: string;
  OutFName: string;
begin
  DateStr := long2date(DateGet);
  OutFName := MyProgramPath + 'Log ' + copy(DateStr, 7, 4) + '-' +
    copy(DateStr, 4, 2) + '-' +
    copy(DateStr, 1, 2) + '.txt';
  assignFile(OutF, OutFName);
  if FileExists(OutFName) then
    append(OutF)
  else
    rewrite(OutF);
  writeln(OutF, s);
  CloseFile(OutF);
end;

procedure TFormQRechner.DiagnoseBeep1Click(Sender: TObject);
begin
  PostCommand(RechnerClicked, cBeep);
end;

procedure TFormQRechner.vlligentsperren1Click(Sender: TObject);
begin
  PostCommand(RechnerClicked, cClose);
end;

procedure TFormQRechner.neubooten1Click(Sender: TObject);
begin
  PostCommand(RechnerClicked, cHerunterFahren);
end;

procedure TFormQRechner.Neustarten1Click(Sender: TObject);
begin
  PostCommand(RechnerClicked, cNeuStart);
end;

procedure TFormQRechner.StartTarif11Click(Sender: TObject);
begin
  with Rechner[RechnerClicked] do
  begin
    if not (MoneyOnSoll) then
      StartRechner(RechnerClicked, 0);
  end;
end;

procedure TFormQRechner.StartTraif21Click(Sender: TObject);
begin
  with Rechner[RechnerClicked] do
  begin
    if not (MoneyOnSoll) then
      StartRechner(RechnerClicked, 1);
  end;
end;

procedure TFormQRechner.PCwiederfrei1Click(Sender: TObject);
begin
  with Rechner[RechnerClicked] do
  begin
    if MoneyOnSoll then
      StopRechner(RechnerClicked);
  end;
end;

procedure TFormQRechner.drucken1Click(Sender: TObject);

var
  OutBmp: TBitMap;
  OutText: TStringList;
  BigStr: string;

  procedure DrawImage(Canvas: TCanvas; DestRect: TRect; ABitmap: TBitmap);
  var
    Header, Bits: Pointer;
    HeaderSize, BitsSize: dword;
  begin
    GetDIBSizes(ABitmap.Handle, HeaderSize, BitsSize);
    GetMem(Header, HeaderSize);
    GetMem(Bits, BitsSize);
    try
      GetDIB(ABitmap.Handle, ABitmap.Palette, Header^, Bits^);
      StretchDIBits(Canvas.Handle, DestRect.Left, DestRect.Top,
        DestRect.Right - DestRect.Left, DestRect.Bottom - DestRect.Top,
        0, 0, ABitmap.Width, ABitmap.Height, Bits, TBitmapInfo(Header^),
        DIB_RGB_COLORS, SRCCOPY);
    finally
      FreeMem(Header, HeaderSize);
      FreeMem(Bits, BitsSize);
    end;
  end;

var
  s: string;
  n: integer;
begin
  if FileExists(MyPRogramPath + 'Beleg.bmp') then
  begin
    OutBmp := TBitMap.Create;
    OutBmp.LoadFromFile(MyPRogramPath + 'Beleg.bmp');
    with printer do
    begin
      BeginDoc;
      DrawImage(Printer.Canvas, Rect(0, 0, OutBmp.width, OutBmp.height), OutBmp);
      canvas.Font.Name := 'Verdana';
      canvas.Font.Size := -5;
      canvas.TextOut(OutBmp.width div 4, OutBmp.height div 2, 'von bis');
      EndDoc;
    end;
    OutBmp.free;
  end else
  begin

    OutText := TStringList.Create;
    BigStr := iBelegHeader;
    while (Bigstr <> '') do
      OutText.add(nextp(BigStr, '#'));

    with Rechner[RechnerClicked] do // Tprinter
    begin
      OutText.add('*  ' + inttostrN(BelegNo, 5) +

        '  *  ' + long2date(DateGet) + '  *  ' + secondstostr5(SecondsGet) + ' Uhr  *');

      OutText.add('----------------------------------------');
      OutText.add('');
      OutText.add(' Rechner ' +
        inttostrN(succ(RechnerClicked), 2) +
        '  Tarif ' +
        inttostr(succ(tarif)));
      OutText.add('');
      OutText.add(' von ' + secondstostr(sTime) +
        ' bis ' +
        secondstostr(eTime) + '       ' +
        format('%4.2f %s', [LetzterPreis, iWaehrung]));
      if pausedOld > 0 then
      begin
        OutText.add(' davon ' + secondstostr5(pausedOld) + ' h ohne Berechnung');
        OutText.add('');
      end;

      OutText.add(' (entspricht ' + format('%.2f EUR', [LetzterPreis / 1.95583]) + ')');
      OutText.add('----------------------------------------');
      OutText.add('');
      OutText.add('    enthaltene ges.MwSt. 16.0% : ' + format('%4.2f %s', [LetzterPreis - (LetzterPreis / iMwSt), iWaehrung]));
      OutText.add('');
      OutText.add('Es bediente Sie: ' + UserNameAus);
      OutText.add('');

    end;

    BigStr := iBelegFooter;
    while Bigstr <> '' do
      OutText.add(nextp(BigStr, '#'));

    OutText.SaveToFile(MyProgramPath + 'CoffeeStop Druck.txt');

{
    if iPrint then
      PrintLines(OutText);
}

    OutText.free;
  end;
end;

procedure TFormQRechner.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  FunctionKey: integer;
  x, y: integer;
begin
  if Shift = [] then
  begin
    FunctionKey := 0;
    case Key of
      vk_f1: FunctionKey := 1;
      vk_f2: FunctionKey := 2;
      vk_f3: FunctionKey := 3;
      vk_f4: FunctionKey := 4;
      vk_f5: FunctionKey := 5;
      vk_f6: FunctionKey := 6;
      vk_f7: FunctionKey := 7;
      vk_f8: FunctionKey := 8;
      vk_f9: FunctionKey := 9;
      vk_f10: FunctionKey := 10;
      vk_f11: FunctionKey := 11;
      vk_f12: FunctionKey := 12;
      vk_prior: RechnerShowOffset := 0;
      vk_next: RechnerShowOffset := 12;
    end;
    if (FunctionKey > 0) then
    begin
      RechnerClicked := pred(FunctionKey + RechnerShowOffset);
      RechnerToXY(pred(FunctionKey), x, y);
      PopUpEnableDisable;
      PopupMenu1.Popup(left + x, top + y);
      Key := 0;
    end;
  end;
  if ssCtrl in shift then
  begin
    case Key of
      vk_f1: if (UserLevel < 3) then
        begin
      {
          SettingsForm.show;
          }
        end else
        begin
          ShowMessage('nicht berechtigt für <Strg>&&<F1>!');
        end;
    end;
  end;
end;

procedure TFormQRechner.RechnerToXY(n: integer; var x, y: integer);
begin
  x := cXOffset + (n mod cRechnerPerRow) * cXSize;
  y := cYOffset + (n div cRechnerPerRow) * cYSize;
end;

procedure TFormQRechner.PopUpEnableDisable;
begin
  with Rechner[RechnerClicked] do
  begin
    if not (LinkOK) then
    begin
      StartTarif11.enabled := false;
      StartTraif21.enabled := false;
      PCwiederfrei1.enabled := false;
      drucken1.enabled := false;
      vlligentsperren1.enabled := false;
      neubooten1.enabled := false;
      Neustarten1.enabled := false;
      DiagnoseBeep1.enabled := false;
      ArbeitsplatzOK1.enabled := false;
      pause1.Enabled := false;
    end else
    begin
      if PausedOn then
        pause1.Caption := 'Ende der &Pause'
      else
        pause1.caption := '&PAUSE';
      if MoneyOnSoll then
      begin
        StartTarif11.enabled := false;
        StartTraif21.enabled := false;
        PCwiederfrei1.enabled := not (PausedOn);
        drucken1.enabled := true;
        vlligentsperren1.enabled := true;
        neubooten1.enabled := true;
        Neustarten1.enabled := true;
        DiagnoseBeep1.enabled := true;
        ArbeitsplatzOK1.enabled := (UserLevel = 0);
        pause1.Enabled := true;
      end else
      begin
        pause1.Enabled := false;
        StartTarif11.enabled := true;
        StartTraif21.enabled := true;
        PCwiederfrei1.enabled := false;
        drucken1.enabled := true;
        vlligentsperren1.enabled := true;
        neubooten1.enabled := true;
        Neustarten1.enabled := true;
        DiagnoseBeep1.enabled := true;
        ArbeitsplatzOK1.enabled := (UserLevel = 0);
      end;
    end;

  end;
end;

procedure TFormQRechner.StartRechner(n: integer; Tar: byte);

  procedure DoStart(UserCode: string);
  begin
    with Rechner[n] do
    begin
      tarif := tar;
      UserNameAn := UserCode;
      BelegNo := NewTrn;
      MoneyOnSoll := true;
      sDate := DateGet;
      sTime := SecondsGet;
      PausedOn := false;
      PausedOld := 0;
      PausedNow := 0;
    end;
    PostCommand(n, cFree);
  end;

begin
  if LoggedInUser <> '' then
  begin
    DoStart(LoggedInUser);
  end else
  begin
   {
    with CodeForm do
    begin
      CheckBox1.visible := false;
      ShowModal;
      if (UserCode <> '') then
      begin
        DoStart(UserCode);
      end;
    end;
    }
  end;
end;

procedure TFormQRechner.StopRechner(n: integer);

  procedure DoStop(UserCode: string; sto: boolean);
  begin
    RechnerClicked := n;
    with Rechner[RechnerClicked] do
    begin
      UserNameAus := UserCode;
      Storniert := sto;
      MoneyOnSoll := false;
    end;
    PostCommand(n, cLock);
    BucheEndeStatus(n);
    if iAutoPrint then
      drucken1Click(self);
  end;

begin
  if LoggedInUser <> '' then
  begin
    DoStop(LoggedInUser, false);
  end else
  begin
   {
    with CodeForm do
    begin
      CheckBox1.Checked := false;
      CheckBox1.visible := true;
      ShowModal;
      if (UserCode <> '') then
      begin
        DoStop(UserCode, CheckBox1.Checked);
      end;
    end;
    }
  end;
end;

function TFormQRechner.IniFName: string;
begin
  result := MyProgramPath + 'CoffeeStop.ini';
end;

function TFormQRechner.DataFName: string;
begin
  result := MyProgramPath + 'CoffeeStop.dat';
end;

function TFormQRechner.StatistikFName: string;
begin
  result := MyProgramPath + 'CoffeeStop Statistik.txt';
end;

function TFormQRechner.PreisFuerMinute(t: byte; minute: integer; zeit: TAnfixTime): extended;
var
  TableOffset: integer;
  n: integer;
begin
  TableOffset := t;
  for n := 1 to iZeitSchwelleAnz do
    if (zeit >= iZeitSchwelle[n].Anfang) and (zeit <= iZeitSchwelle[n].Ende) then
    begin
      inc(TableOffset, 2);
      break;
    end;
  result := TarifMinuten[TableOffset][min(minute, cSurfMax)];
end;

procedure TFormQRechner.BucheEndeStatus(RechnerID: integer);
var
  PreisSTr: string;
begin
  with Rechner[RechnerID] do
  begin
    WriteLog('Rechner ' + inttostrN(succ(RechnerID), 2) + ' vom ' +
      long2date(sDate) +
      ' ' +
      secondstostr(sTime) +
      ' [' +
      format('%6s', [UserNameAn]) +
      '] bis ' +
      long2date(eDate) +
      ' ' +
      secondstostr(eTime) +
      ' [' +
      format('%6s', [UserNameAus]) +
      '] (' +
      secondstostr(
      SecondsDiff(sDate, sTime, eDate, eTime))
      + ') = ' +
      format('%.2f %s', [LetzterPreis, iWaehrung]) +
      ' ' +
      StorniertToStr(storniert)
      );
    PreisStr := format('%.2f', [LetzterPreis]);
    ersetze(',', '.', PreisStr);

    WriteStatistik(inttostr(BelegNo) + ',' +
      inttostr(RechnerID) + ',' +
      long2date(sDate) + ',' +
      secondstostr(sTime) + ',' +
      UserNameAn + ',' +
      long2date(eDate) + ',' +
      secondstostr(eTime) + ',' +
      UserNameAus + ',' +
      secondstostr(SecondsDiff(sDate, sTime, eDate, eTime)) + ',' +
      PreisStr + ',' +
      iWaehrung + ',' +
      StorniertToStr(storniert) + ','
      );
  end;
end;

function TFormQRechner.NewTrn: integer;
var
  MyActTrnNo: TStringList;
  TrnFName: string;
begin
  MyActTrnNo := TStringList.Create;
  TrnFName := MyProgramPath + 'CoffeeStop Beleg No.INI';
  if FileExists(TrnFName) then
    MyActTrnNo.LoadFromFile(TrnFName);
  if (MyActTrnNo.count = 0) then
    MyActTrnNo.add('0');
  result := strtoint(MyActTrnNo[0]);
  MyActTrnNo[0] := inttostr(strtoint(MyActTrnNo[0]) + 1);
  MyActTrnNo.SaveToFile(TrnFName);
  MyActTrnNo.free;
end;

procedure TFormQRechner.ShowUser;
var
  n: integer;
  OutF: TextFile;
begin

  AssignFile(OutF, MyProgramPath + cLetzerBenutzerFName);
  rewrite(OutF);
  writeln(OutF, TypedInByNow);
  CloseFile(OutF);

  if (TypedInByNow = '') then
  begin
    panel1.caption := '< gesperrt >';
    UserLevel := 99;
  end else
  begin
    n := Codes.indexof(TypedInByNow);
    if n = -1 then
    begin
      panel1.caption := fill('*', length(TypedInByNow)) + '_';
      UserLevel := 99;
    end else
    begin
      UserLevel := n;
      panel1.caption := '"' + copy(TypedInByNow, 1, 2) + '..." ist angemeldet';
      LoggedInUser := TypedInByNow;
    end;
  end;
end;

procedure TFormQRechner.ArbeitsplatzOK1Click(Sender: TObject);
begin
  if (UserLevel = 0) then
    PostCommand(RechnerClicked, cArbeitsplatzOK);
end;

procedure TFormQRechner.PAUSE1Click(Sender: TObject);
begin
  with Rechner[RechnerClicked] do
  begin
    if PausedOn then
      EndePause(RechnerClicked)
    else
      StartPause(RechnerCLicked);
  end;
end;

procedure TFormQRechner.PostCommand(RechnerID: integer; cmd: eCommands);
begin
  Rechner[RechnerID].command := cmd;
  NextToCall.add(inttostr(RechnerID));
end;

procedure TFormQRechner.DebugLog(s: string);
begin
  if idebug then
  begin
    listbox1.items.add(s);
    listbox1.ItemIndex := pred(listbox1.items.count);
  end;
end;

procedure TFormQRechner.StartPause(RechnerID: integer);
begin
  with Rechner[RechnerID] do
  begin
    if not (PausedOn) then
    begin
      PausedOn := true;
      pDate := DateGet;
      pTime := SecondsGet;
      PausedNow := 0;
    end;
  end;
end;

procedure TFormQRechner.EndePause(RechnerID: integer);
begin
  with Rechner[RechnerID] do
  begin
    if PausedOn then
    begin
      PausedOld := PausedOld + PausedNow;
      PausedNow := 0;
      PausedOn := false;
    end;
  end;
end;

procedure TFormQRechner.init;
var
  MyIni: TiniFile;
  n: integer;
  AllCodes: string;
  LetzerBenutzerSL: TStringList;

  procedure FillTarif(t: byte; s: string);
  var
    ActWritePointer: integer;
    MinutesValid: integer;
    n: integer;
    ActMinutePreis: extended;
    TarifInfo: TStringList;
  begin
    ActWritePointer := 1;
    ActMinutePreis := 0.0;
    while true do
    begin

      if (ActWritePointer > cSurfMax) then
        break;
      if (s = '') then
        break;

   // nächsten Satz auslesen!
      MinutesValid := strtoint(nextp(s, ':'));
      if MinutesValid <> 0 then
      begin
        ActMinutePreis := strtodouble(nextp(s, ',')) / MinutesValid
      end else
      begin
        ShowMessage('0: nicht gültig!');
        exit;
      end;

      for n := 1 to MinutesValid do
      begin
        if ActWritePointer > cSurfMax then
          break;
        tarifMinuten[t, ActWritePointer] := ActMinutePreis;
        inc(ActWritePointer);
      end;
    end;

    if (ActWritePointer < cSurfMax) then
      for n := ActWritePointer to cSurfMax do
        tarifMinuten[t, n] := ActMinutePreis;

    TarifInfo := TStringList.create;
    for n := 1 to cSurfMax do
      TarifInfo.add(secondstoStr5(n * 60) + ' : ' + format('%.6f', [tarifMinuten[t, n]]));
    TarifInfo.SaveToFile(MyProgramPath + 'Tarif ' + inttostr(succ(t)) + ' Info.txt');
    TarifInfo.free;

  end;

// Tarif1=60:9.00,60:7.00,60:6.00
// Tarif2=60:10.00,60:9.00,60:8.00
// Tarif3=60:11.00,60:10.00,60:9.00
// Tarif4=60:12.00,60:11.00,60:10.00
// Zeitschwelle=20:00

begin
  if not (Initialized) then
  begin
    iMwSt := 1.16;
    image1.top := 0;
    image1.left := 0;
    clientheight := image1.height + panel1.height;
    clientwidth := image1.width;
    panel1.Left := 0;
    panel1.top := image1.height;
    panel1.width := image1.width;
    NextToCall := TstringList.create;

// if (dateGet>=20000801) then
//  halt;
    randomize;
    Codes := TStringList.create;
    MyProgramPath := ExtractFilePath(paramstr(0));


    MyIni := TiniFile.Create(iniFname);
    with MyIni do
    begin
  // [System]
      iPreis := strtodouble(ReadString('System', 'Preis', ''));
      iPreis2 := strtodouble(ReadString('System', 'Preis2', ''));
      iBelegHeader := ReadString('System', 'BelegHeader', '');
      iBelegFooter := ReadString('System', 'BelegFooter', '');
      iAbrechnungFooter := ReadString('System', 'AbrechnungFooter', '');
      iAutoPrint := ansiuppercase(ReadString('System', 'AutoDruck', '')) = 'JA';
      iAutoBenutzerSpeichern := ansiuppercase(ReadString('System', 'AutoBenutzerSpeichern', '')) = 'JA';
      iDebug := ansiuppercase(ReadString('System', 'Debug', '')) = 'JA';
      iPrint := ansiuppercase(ReadString('System', 'Print', 'JA')) = 'JA';

      ersetze('<FF>', #$0D#12, iBelegFooter);
      ersetze('<FF>', #$0D#12, iAbrechnungFooter);

      AllCodes := ReadString('System', 'Zeitschwelle', '');

      iZeitSchwelleAnz := 1;
      while (AllCodes <> '') do
      begin
        iZeitSchwelle[iZeitSchwelleAnz].Anfang := strtoseconds(nextp(AllCodes, '-'));
        iZeitSchwelle[iZeitSchwelleAnz].Ende := strtoseconds(nextp(AllCodes, ','));
        if iZeitSchwelleAnz = cZeitSchwellenMax then
          break;
        inc(iZeitSchwelleAnz);
      end;

      for n := 0 to 3 do
        FillTarif(n, ReadString('System', 'Tarif' + inttostr(succ(n)), ''));

      iWaehrung := ReadString('System', 'Währung', '');
      for n := 0 to pred(cRechnerMax) do
        RechnerIP[n] := ReadString('Rechner Nó ' + inttostr(succ(n)), 'IP', '');
      AllCodes := ReadString('System', 'Codes', 'fils');
    end;
    MyIni.free;
    listbox1.visible := iDebug;
    while true do
    begin
      Codes.add(AnsiUpperCase(Nextp(AllCodes, ',')));
      if (AllCodes = '') then
        break;
    end;

    if iAutoBenutzerSpeichern then
    begin
      // letzer Benutzer laden
      LetzerBenutzerSL := TStringList.create;
      if FileExists(MyProgramPath + cLetzerBenutzerFName) then
      begin
        LetzerBenutzerSL.LoadFromFile(MyProgramPath + cLetzerBenutzerFName);
        if (LetzerBenutzerSL.count > 0) then
          TypedInByNow := LetzerBenutzerSL[0];
        LetzerBenutzerSL.clear;
      end;
      LetzerBenutzerSL.free;
    end;

    caption := 'CoffeeStop Rev. ' + RevTostr(Version);
    LoadData;
    ShowUser;
    timer1.enabled := true;
    Initialized := true;
  end;
end;

procedure TFormQRechner.FormActivate(Sender: TObject);
begin
  Init;
end;

end.

