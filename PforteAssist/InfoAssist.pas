unit InfoAssist;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  globals, IniFiles, ExtCtrls,
  ScktComp, IdContext, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdTCPServer, Sockets;

type
  TInfoAssistForm = class(TForm)
    Timer1: TTimer;
    IdTCPServer1: TIdTCPServer;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure IdTCPServer1Execute(AContext: TIdContext);
    procedure IdTCPServer1Connect(AContext: TIdContext);
    procedure IdTCPServer1Disconnect(AContext: TIdContext);
  private
    { Private-Deklarationen }
    procedure WMEraseBkgnd(var m: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure gateF(msg: string);
  public

    { Public-Deklarationen }
    bmBack: TBitMap;
    DrawMode: Boolean;
    LastX, LastY: Integer; // letze Mouse-Position
    LEDon: TBitMap;
    LEDoff: TBitMap;

    InputAreaN: TRect;
    InputAreaF: TRect;
    InputAreaH: TRect;
    SignArea: TRect;
    KeyBoardArea: TRect;

    ClearSignArea: TRect;
    LayoutArea: TRect;
    clDesktop: TColor;
    DatumRect: TRect;
    LEDonRect: TRect;
    LEDoffRect: TRect;

    // Eingabe / Keyboard
    InpStrN: string;
    InpStrF: string;
    InpStrH: string;
    InputMode: byte;

    ActivateNameArea: TRect;
    ActivateFirmaArea: TRect;
    ActivateHandyArea: TRect;

    TouchPosAll: TStringList;
    SignIni: TiniFile;
    TouchPosIni: TiniFile;
    SystemIni: TiniFile;

    Keys: array [0 .. KeyMaxX, 0 .. KeyMaxY] of KeyRecord;
    LampsToOff: array of TLampRecord;

    // Keyboard-Wiederholfunktion
    KeyMayRepeat: Boolean;
    KeyNextFire: dword;
    KeyLast: Char;

    // Uhrzeitanzeige
    LastUhrTime: dword;

    // Eingabe-Überwachung
    LastInputTime: dword;

    // Kommunikation
    gateFContext: TIdContext;

    // Unterschrift
    SignPoints: array [0 .. pred(SignMaxPoints)] of TSignPoint;
    SignPointCount: Integer;

    // Textanzeige
    TextAreaRect: TRect;
    TextAppInfo: Boolean;

    // Rev-Output
    FirstPaintFlag: Boolean;

    // Refresh
    FirstRefreshFlag: Boolean;
    FirstRefreshTick: dword;

    // Landes-Versionen
    ActLanguage: string;
    TakeLanguage: array [0 .. high(cPossibleLanguages)] of TRect;

    Lang_Bediener: TStringList;
    Lang_Contract: TStringList;
    Lang_Name: string;
    Lang_Firma: string;
    Lang_Handy: string;
    Lang_Sign: string;

    procedure DrawPixel(X, Y: Integer);
    procedure PaintInput;
    procedure PaintKeys;
    procedure LoadKeyMap;
    procedure InsertLight(r: TRect);
    procedure InsertKey(c: Char);
    procedure ClearLamps;
    procedure LoadAndPaintText;
    procedure ClearAllData;

    procedure SocketSendName;
    procedure SocketSendSign;
    procedure SocketSendCountry;
    procedure SocketSendFirm;
    procedure SocketSendHandy;

  end;

var
  InfoAssistForm: TInfoAssistForm;

implementation

uses
  anfix32, wanfix32;

{$R *.DFM}

function rNormalize(r: TRect): TRect;
begin
  result := Rect(0, 0, r.right - r.Left, r.bottom - r.Top);
end;

procedure TInfoAssistForm.FormCreate(Sender: TObject);

var
  n, k: Integer;
  KeyX, KeyY: Integer;

  function PosStringList(const PosStr: string; StrList: TStringList): Integer;
  var
    n: Integer;
  begin
    result := -1;
    for n := 0 to pred(StrList.count) do
      if pos(PosStr, StrList[n]) = 1 then
      begin
        result := n;
        break;
      end;
  end;

  function PreValue(const Str: string): string;
  var
    k: Integer;
  begin
    k := pos('=', Str);
    result := copy(Str, 1, pred(k));
  end;

  function PostValue(const Str: string): string;
  var
    k: Integer;
  begin
    k := pos('=', Str);
    result := copy(Str, succ(k), MaxInt);
  end;

begin
  screen.cursor := crHourGlass;
  Top := 0;
  Left := 0;
  width := 768;
  height := 1024;

  InpStrN := '';
  InpStrF := '';
  InpStrH := '';
  InputMode := 1;
  TextAppInfo := true;

  // Landes Versionen
  Lang_Bediener := TStringList.Create;
  Lang_Contract := TStringList.Create;
  ActLanguage := DefaultLanguage;

  // constructors global
  bmBack := TBitMap.Create;
  TouchPosAll := TStringList.Create;
  SignIni := TiniFile.Create(MyProgramPath + 'Keyboard Layouts.ini');
  TouchPosIni := TiniFile.Create(MyProgramPath + 'itsiemens3.itp');
  SystemIni := TiniFile.Create(MyProgramPath + 'PforteAssist.ini');
  LEDon := TBitMap.Create;
  LEDoff := TBitMap.Create;

  // System Settings
  iKeyFirstRepeatAfter := StrToint(SystemIni.ReadString('System',
    'KeyFirstRepeatAfter', '900'));
  iKeyNextRepeat := StrToint(SystemIni.ReadString('System',
    'KeyNextRepeat', '99'));
  iClearDataAfter := StrToint(SystemIni.ReadString('System', 'ClearDataAfter',
    '20000'));
  iFirstRefreshAfter := StrToint(SystemIni.ReadString('System',
    'FirstRefreshAfter', '20000'));

  //
  bmBack.LoadFromFile(MyProgramPath + 'main.bmp');
  TouchPosIni.ReadSectionValues('main.bmp', TouchPosAll);

  SignArea := Str2Rect(TouchPosAll.Values['U']);
  LayoutArea := Str2Rect(TouchPosAll.Values['Layout']);
  TextAreaRect := Str2Rect(TouchPosAll.Values['TextArea']);
  ClearSignArea := Str2Rect(TouchPosAll.Values['11-01']);

  for KeyX := 0 to KeyMaxX do
    for KeyY := 0 to KeyMaxY do
      Keys[KeyX, KeyY].TouchRect :=
        Str2Rect(TouchPosAll.Values[IntToStrN(KeyX, 2) + '-' +
        IntToStrN(KeyY, 2)]);

  // not touchable?!
  InputAreaN := Str2Rect(TouchPosAll.Values['NAME']);
  InputAreaF := Str2Rect(TouchPosAll.Values['FIRMA']);
  InputAreaH := Str2Rect(TouchPosAll.Values['HANDY']);

  DatumRect := Str2Rect(TouchPosAll.Values['Datum']);
  LEDonRect := Str2Rect(TouchPosAll.Values['LED on']);
  LEDoffRect := Str2Rect(TouchPosAll.Values['LED off']);

  ActivateNameArea := Str2Rect(TouchPosAll.Values['KNAME']);
  ActivateFirmaArea := Str2Rect(TouchPosAll.Values['KFIRMA']);
  ActivateHandyArea := Str2Rect(TouchPosAll.Values['KHANDY']);

  for n := 0 to high(cPossibleLanguages) do
    TakeLanguage[n] :=
      Str2Rect(TouchPosAll.Values['LANG_' +
      AnsiUpperCase(cPossibleLanguages[n])]);

  SetBitMapSizeTo(LEDon, pred(rXL(LEDonRect)), pred(rYL(LEDonRect)));
  LEDon.canvas.CopyRect(rNormalize(LEDonRect), bmBack.canvas, LEDonRect);
  LEDon.transparent := true;
  LEDon.transparentColor := LEDon.canvas.pixels[0, 0];

  SetBitMapSizeTo(LEDoff, pred(rXL(LEDoffRect)), pred(rYL(LEDoffRect)));
  LEDoff.canvas.CopyRect(rNormalize(LEDoffRect), bmBack.canvas, LEDoffRect);
  LEDoff.transparent := true;
  LEDoff.transparentColor := LEDoff.canvas.pixels[0, 0];

  font.name := 'Verdana';
  font.size := 10;
  font.style := [fsbold];
  with bmBack.canvas do
  begin
    clDesktop := pixels[0, 0];
    brush.color := clDesktop;
    FillRect(LEDonRect);
    FillRect(LEDoffRect);
  end;

  SetLength(LampsToOff, 0);
  LastInputTime := GetTickCount;
  FirstRefreshTick := GetTickCount + iFirstRefreshAfter;

  // Ab nun lauscht der Server
  IdTCPServer1.Active := true;

  // Cursor weg!!!
  screen.cursor := crnone;

end;

procedure TInfoAssistForm.WMEraseBkgnd(var m: TWMEraseBkgnd);
begin
  m.result := LRESULT(false);
end;

procedure TInfoAssistForm.FormPaint(Sender: TObject);
var
  n: Integer;
begin
  canvas.draw(0, 0, bmBack);

  LoadAndPaintText;
  LoadKeyMap;
  PaintKeys;

  // kleiner Ausweiß
  PaintInput;

  with canvas do
  begin

    for n := 0 to pred(length(LampsToOff)) do
      with LampsToOff[n].LampPos do
      begin
        if Left > 0 then
          draw(Left + LEDoffsetX, Top + LEDoffsetY, LEDon);
      end;

    // kleine LED für ONLINE / OFFLINE
    if assigned(gateFContext) then
      brush.color := cllime
    else
      brush.color := clred;
    FillRect(Rect(755, 3, 765, 7));
  end;

  // force to clock to be up-to-date
  LastUhrTime := 0;
end;

procedure TInfoAssistForm.gateF(msg: string);
begin
  if assigned(gateFContext) then
    if gateFContext.Connection.Connected then
      gateFContext.Connection.Socket.WriteLn(msg);
end;

procedure TInfoAssistForm.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  n: Integer;
begin
  LastInputTime := GetTickCount;
  if DrawMode then
  begin
    DrawPixel(X, Y);
    if (abs(X - LastX) > 2) or (abs(Y - LastY) > 2) then
    begin
      canvas.pen.width := 4;
      canvas.MoveTo(LastX, LastY);
      canvas.LineTo(X, Y);
    end;
    LastX := X;
    LastY := Y;
  end;
end;

procedure TInfoAssistForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    close;
  end;
  if (Key = 'm') then
    screen.cursor := crdefault;
  if (Key = 'p') then
    paint;
end;

procedure TInfoAssistForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  kx, ky: Integer;
  n: Integer;
begin
  LastInputTime := GetTickCount;

  if InSide(X, Y, SignArea) then
  begin
    DrawPixel(X, Y);
    DrawMode := true;
    LastX := X;
    LastY := Y;
  end
  else
  begin

    for ky := 0 to KeyMaxY do
      for kx := 0 to KeyMaxX do
        with Keys[kx, ky] do
        begin
          if (TouchRect.Left = 0) then
            continue;
          if InSide(X, Y, TouchRect) then
          begin
            canvas.draw(TouchRect.Left + LEDoffsetX,
              TouchRect.Top + LEDoffsetY, LEDon);
            InsertLight(TouchRect);
            if (LowerChar <> #0) then
            begin
              KeyNextFire := GetTickCount + iKeyFirstRepeatAfter;
              KeyMayRepeat := true;
              InsertKey(LowerChar);
              exit;
            end;
          end;
        end;

    if InSide(X, Y, ClearSignArea) then
    begin
      SignPointCount := 0;
      paint;
    end;

    if InSide(X, Y, ActivateNameArea) then
    begin
      InputMode := 1;
      PaintInput;
    end;

    if InSide(X, Y, ActivateFirmaArea) then
    begin
      InputMode := 2;
      PaintInput;
    end;

    if InSide(X, Y, ActivateHandyArea) then
    begin
      InputMode := 3;
      PaintInput;
    end;

    for n := 0 to high(cPossibleLanguages) do
      if InSide(X, Y, TakeLanguage[n]) then
      begin
        ActLanguage := cPossibleLanguages[n];
          SocketSendCountry;
        paint;
        break;
      end;

  end;
end;

procedure TInfoAssistForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  LastInputTime := GetTickCount;
  if DrawMode then
  begin
    if (SignPointCount < SignMaxPoints) then
    begin
      with SignPoints[SignPointCount] do
      begin
        Px := 0;
        Py := 0;
      end;
      inc(SignPointCount);
    end;
    SocketSendSign;
    DrawMode := false;
  end;
  KeyMayRepeat := false;
end;

procedure TInfoAssistForm.ClearLamps;
var
  n: Integer;
  ActTick: dword;
  AllOff: Boolean;
begin
  if length(LampsToOff) = 0 then
    exit;
  ActTick := GetTickCount;
  AllOff := true;
  for n := 0 to pred(length(LampsToOff)) do
    with LampsToOff[n] do
    begin
      if (ActTick > OFFTime) and (LampPos.Left > 0) then
      begin
        canvas.draw(LampPos.Left + LEDoffsetX,
          LampPos.Top + LEDoffsetY, LEDoff);
        LampPos.Left := 0;
      end
      else
        AllOff := false;
    end;
  if AllOff then
    SetLength(LampsToOff, 0);
end;

procedure TInfoAssistForm.DrawPixel(X, Y: Integer);
begin
  if (SignPointCount = SignMaxPoints) then
  begin
    SignPointCount := 0;
    DrawMode := false;
    paint;
  end
  else
  begin
    with SignPoints[SignPointCount] do
    begin
      Px := X;
      Py := Y;
    end;
    inc(SignPointCount);
    with canvas do
    begin
      brush.color := clblack;
      FillRect(Rect(X - 1, Y - 2, X + 1, Y + 2));
      FillRect(Rect(X - 2, Y - 1, X + 2, Y + 1));
    end;
  end;
end;

procedure TInfoAssistForm.PaintInput;
const
  TextLeftOffset = 12;
begin
  canvas.font.name := 'Arial Black';
  canvas.font.size := -30;
  canvas.font.style := [];
  canvas.brush.color := clWhite;

  // Name
  canvas.FillRect(InputAreaN);
  case InputMode of
    1:
      canvas.TextRect(InputAreaN, InputAreaN.Left + TextLeftOffset,
        InputAreaN.Top, InpStrN + '_');
  else
    canvas.TextRect(InputAreaN, InputAreaN.Left + TextLeftOffset,
      InputAreaN.Top, InpStrN);
  end;

  // Firma
  canvas.FillRect(InputAreaF);
  case InputMode of
    2:
      canvas.TextRect(InputAreaF, InputAreaF.Left + TextLeftOffset,
        InputAreaF.Top, InpStrF + '_');
  else
    canvas.TextRect(InputAreaF, InputAreaF.Left + TextLeftOffset,
      InputAreaF.Top, InpStrF);
  end;

  // Handy
  canvas.FillRect(InputAreaH);
  case InputMode of
    3:
      canvas.TextRect(InputAreaH, InputAreaH.Left + TextLeftOffset,
        InputAreaH.Top, InpStrH + '_');
  else
    canvas.TextRect(InputAreaH, InputAreaH.Left + TextLeftOffset,
      InputAreaH.Top, InpStrH);
  end;

  canvas.font := font;
end;

procedure TInfoAssistForm.LoadKeyMap;
var
  X, Y, k: Integer;
  AllLines: TStringList;
  CharLine: string;
  c: Char;
begin
  // erst mal alle Chars rausschmeisen

  AllLines := TStringList.Create;

  for X := 0 to KeyMaxX do
    for Y := 0 to KeyMaxY do
    begin
      with Keys[X, Y] do
      begin
        LowerChar := #0;
      end;
    end;
  Keys[11, 00].LowerChar := chr(VK_BACK);
  Keys[11, 03].LowerChar := chr(VK_RETURN);
  Keys[10, 03].LowerChar := chr(VK_TAB);
  Keys[09, 03].LowerChar := ' ';

  SignIni.ReadSectionValues(ActLanguage, AllLines);
  for Y := 0 to KeyMaxY do
  begin

    CharLine := AllLines.Values[IntToStrN(Y, 2)];
    if (Y = 1) and (CharLine = '') then
      CharLine := 'qwertyuiop,QWERTYUIOP';
    if (Y = 2) and (CharLine = '') then
      CharLine := 'asdfghjkl,ASDFGHJKL';
    if (Y = 3) and (CharLine = '') then
      CharLine := 'zxcvbnm#.,ZXCVBNM#.';

    if (CharLine <> '') then
    begin
      k := pos(',', CharLine);
      CharLine := copy(CharLine, succ(k), MaxInt);
      for X := 1 to length(CharLine) do
      begin
        c := CharLine[X];
        case c of
          '#':
            c := ',';
        end;
        Keys[pred(X), Y].LowerChar := c;
      end;
    end;
  end;
  AllLines.free;
end;

procedure TInfoAssistForm.PaintKeys;
var
  X, Y: Integer;
  DestFlag: TRect;
begin
  with canvas do
  begin
    CopyRect(LayoutArea, bmBack.canvas, LayoutArea);
    brush.style := bsDiagCross;
    font.name := 'Arial Black';
    font.size := -30;
    font.style := [];
    for X := 0 to KeyMaxX do
      for Y := 0 to KeyMaxY do
      begin
        with Keys[X, Y] do
        begin
          if TouchRect.Left > 0 then
            if LowerChar > ' ' then
              TextOut(TouchRect.Left + 17, TouchRect.Top + 3, LowerChar);
        end;
      end;

    TextOut(ActivateNameArea.Left + 15, ActivateNameArea.Top + 10,
      Lang_Name + ' :');
    TextOut(ActivateFirmaArea.Left + 15, ActivateFirmaArea.Top + 10,
      Lang_Firma + ' :');

    while Textwidth(Lang_Handy) > 150 do
      font.size := font.size + 1;
    TextOut(ActivateHandyArea.Left + 15, ActivateHandyArea.Top + 10,
      Lang_Handy + ' :');

    font.name := 'Verdana';
    font.size := 10;
    font.style := [fsbold];
    TextOut(150, DatumRect.Top, Lang_Sign);

    brush.style := bsSolid;
  end;
  canvas.font := font;
end;

procedure TInfoAssistForm.Timer1Timer(Sender: TObject);
var
  ThisTick: dword;
begin

  ClearLamps;
  ThisTick := GetTickCount;

  // Key Repeater
  if KeyMayRepeat then
    if (ThisTick > KeyNextFire) then
    begin
      InsertKey(KeyLast);
      KeyNextFire := ThisTick + iKeyNextRepeat;
    end;

  // Auto Data Clear
  if frequently(LastInputTime, iClearDataAfter) then
  begin
    if (InpStrN <> '') or (InpStrF <> '') or (InpStrH <> '') or
      (SignPointCount <> 0) then
    begin
      ClearAllData;
      gateF('A' );
    end;
  end;

  // First Desktop Redraw
  if not(FirstRefreshFlag) then
    if (ThisTick > FirstRefreshTick) then
    begin
      FirstRefreshFlag := true;
      paint;
    end;

  // Clock
  if frequently(LastUhrTime, 1000) then
  begin
    with canvas do
    begin
      font.name := 'Verdana';
      brush.color := pixels[DatumRect.Left, DatumRect.Top];
      font.size := 10;
      font.style := [fsbold];
      FillRect(DatumRect);
      TextRect(DatumRect, DatumRect.Left, DatumRect.Top,
        long2date(DateGet) + ' - ' + SecondsToStr5(SecondsGet));
    end;
    canvas.font := font;
  end;

end;

procedure TInfoAssistForm.InsertLight(r: TRect);
begin
  SetLength(LampsToOff, succ(length(LampsToOff)));
  with LampsToOff[pred(length(LampsToOff))] do
  begin
    LampPos := r;
    OFFTime := GetTickCount + 370;
  end;
end;

procedure TInfoAssistForm.IdTCPServer1Connect(AContext: TIdContext);
begin
  gateFContext := AContext;
  paint;
end;

procedure TInfoAssistForm.IdTCPServer1Disconnect(AContext: TIdContext);
begin
  if gateFContext = AContext then
  begin
    gateFContext := nil;
    paint;
  end;
end;

procedure TInfoAssistForm.IdTCPServer1Execute(AContext: TIdContext);
var
  CommandStr, InpStr: ANsiString;
  k: Integer;
begin
  InpStr := AContext.Connection.IOHandler.ReadLn;
  while (InpStr <> '') do
  begin
    k := pos('~', InpStr);
    if k > 0 then
    begin
      CommandStr := copy(InpStr, 1, pred(k));
      delete(InpStr, 1, k);
    end
    else
    begin
      CommandStr := InpStr;
      InpStr := '';
    end;
    case CommandStr[1] of
      'N':
        begin
          InpStrN := copy(CommandStr, 2, MaxInt);
          PaintInput;
        end;
      'F':
        begin
          InpStrF := copy(CommandStr, 2, MaxInt);
          PaintInput;
        end;
      'H':
        begin
          InpStrH := copy(CommandStr, 2, MaxInt);
          PaintInput;
        end;
      'C':
        ClearAllData;
      'L':
        begin
          // alle Info muss raus
          SocketSendCountry;
          SocketSendName;
          SocketSendFirm;
          SocketSendHandy;
          SocketSendSign;
        end;
    end;
    LastInputTime := GetTickCount;
  end;
end;

procedure TInfoAssistForm.InsertKey(c: Char);
var
  InpStr: string;
  SwitchMode: Boolean;
begin

  case InputMode of
    1:
      InpStr := InpStrN;
    2:
      InpStr := InpStrF;
    3:
      InpStr := InpStrH;
  end;

  SwitchMode := false;
  KeyLast := c;
  case ord(c) of
    VK_BACK:
      if (InpStr <> '') then
        delete(InpStr, length(InpStr), 1);
    VK_TAB:
      SwitchMode := true;
    VK_RETURN:
      SwitchMode := true;
  else
    InpStr := InpStr + KeyLast;
  end;

  case InputMode of
    1:
      begin
        InpStrN := InpStr;
          SocketSendName;
      end;
    2:
      begin
        InpStrF := InpStr;
          SocketSendFirm;
      end;
    3:
      begin
        InpStrH := InpStr;
          SocketSendHandy;
      end;
  end;

  if SwitchMode then
  begin
    InputMode := InputMode + 1;
    if InputMode = 4 then
      InputMode := 1;
  end;

  PaintInput;

  if (InputMode = 1) then
    if not(TextAppInfo) then
    begin
      TextAppInfo := true;
      LoadAndPaintText;
    end;

  if (InpStrN <> '') and (InputMode <> 1) then
    if TextAppInfo then
    begin
      TextAppInfo := false;
      LoadAndPaintText;
    end;

end;

procedure TInfoAssistForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  // imp pend
  // ServerSocket1.Active := false;
  CanClose := true;
end;

procedure TInfoAssistForm.SocketSendSign;
var
  SendStr: string;
  SendSize: Integer;
  n: Integer;
begin
  SendStr := '';
  for n := 0 to pred(SignPointCount) do
  begin
    if n > 0 then
      SendStr := SendStr + ';';
    SendStr :=
    { } SendStr +
    { } inttostr(SignPoints[n].Px) + ',' +
    { } inttostr(SignPoints[n].Py);
  end;
  gateF('U' + SendStr);
end;

procedure TInfoAssistForm.LoadAndPaintText;

var
  BesucherHinweise: TStringList;
  n: Integer;

  procedure WriteAllText;
  var
    k, n: Integer;
    CheckFormatStr: string;
    TextX, TextY: Integer;
  begin
    with canvas do
    begin
      TextX := TextAreaRect.Left;
      TextY := TextAreaRect.Top;
      font.name := 'Arial';
      font.style := [];
      font.height := -12;
      for n := 0 to pred(BesucherHinweise.count) do
      begin
        if BesucherHinweise[n] = '' then
          inc(TextY, TextHeight('X') + (TextHeight('X') DIV 7));
        CheckFormatStr := BesucherHinweise[n];
        while true do
        begin
          if (length(CheckFormatStr) = 0) then
            break;
          while (CheckFormatStr[1] = '\') do
          begin
            case CheckFormatStr[2] of
              '+':
                font.height := font.height - 1;
              '-':
                font.height := font.height + 1;
              'F':
                font.style := font.style + [fsbold];
              'f':
                font.style := font.style - [fsbold];
              'U':
                font.style := font.style + [fsunderline];
              'u':
                font.style := font.style - [fsunderline];
              'K':
                font.style := font.style + [fsItalic];
              'k':
                font.style := font.style - [fsItalic];
              'n':
                inc(TextY, TextHeight('X') + (TextHeight('X') DIV 7));
            else
              ShowMessage('Besucher Hinweise ??.txt(' + inttostr(succ(n)) +
                ') falsche Formatangabe: \' + CheckFormatStr[2]);
            end;
            delete(CheckFormatStr, 1, 2);
            if length(CheckFormatStr) < 2 then
              break;
          end;
          k := pos('\', CheckFormatStr);
          if (k > 0) then
          begin
            TextOut(TextX, TextY, copy(CheckFormatStr, 1, pred(k)));
            inc(TextY, TextHeight('X') + (TextHeight('X') DIV 7));
            delete(CheckFormatStr, 1, pred(k));
          end
          else
          begin
            TextOut(TextX, TextY, CheckFormatStr);
            inc(TextY, TextHeight('X') + (TextHeight('X') DIV 7));
            break;
          end;
        end;
      end;
    end;
  end;

  procedure LoadTextFromNextLines(StartIndex: Integer; s: TStrings);
  var
    n: Integer;
  begin
    for n := StartIndex to pred(BesucherHinweise.count) do
    begin
      if pos('[', BesucherHinweise[n]) = 1 then
        break;
      s.add(BesucherHinweise[n]);
    end;
  end;

begin

  // Text-Bereich löschen!
  with canvas do
  begin
    brush.color := clDesktop;
    FillRect(TextAreaRect);

    for n := 0 to high(cPossibleLanguages) do
      if ActLanguage = cPossibleLanguages[n] then
      begin
        with TakeLanguage[n] do
          draw(Left + LEDoffsetX, Top + LEDoffsetY + 4, LEDon);
        break;
      end;
  end;

  // hey, Sprache laden!!!
  BesucherHinweise := TStringList.Create;
  Lang_Bediener.clear;
  Lang_Contract.clear;
  Lang_Name := '';
  Lang_Firma := '';
  Lang_Handy := '';
  Lang_Sign := '';

  BesucherHinweise.LoadFromFile(MyProgramPath + 'Besucher Hinweise ' +
    ActLanguage + '.txt');

  for n := 0 to pred(BesucherHinweise.count) do
  begin

    // '[' muss da sein!
    if pos('[', BesucherHinweise[n]) <> 1 then
      continue;

    if pos('[Bediener]', BesucherHinweise[n]) = 1 then
      LoadTextFromNextLines(succ(n), Lang_Bediener);
    if pos('[Hinweise]', BesucherHinweise[n]) = 1 then
      LoadTextFromNextLines(succ(n), Lang_Contract);

    if pos('[Name]', BesucherHinweise[n]) = 1 then
      Lang_Name := BesucherHinweise[succ(n)];
    if pos('[Firma]', BesucherHinweise[n]) = 1 then
      Lang_Firma := BesucherHinweise[succ(n)];
    if pos('[Mobilfunk-Telefon]', BesucherHinweise[n]) = 1 then
      Lang_Handy := BesucherHinweise[succ(n)];
    if pos('[Unterschrift]', BesucherHinweise[n]) = 1 then
      Lang_Sign := BesucherHinweise[succ(n)];

  end;

  if TextAppInfo then
    BesucherHinweise.assign(Lang_Bediener)
  else
    BesucherHinweise.assign(Lang_Contract);

  WriteAllText;
  BesucherHinweise.free;

  if not(FirstPaintFlag) then
  begin
    with canvas do
    begin
      font.name := 'Verdana';
      font.size := -10;
      TextOut(5, 424, 'Rev. ' + RevToStr(Version));
    end;
    FirstPaintFlag := true;
  end;

end;

procedure TInfoAssistForm.ClearAllData;
begin
  InpStrN := '';
  InpStrF := '';
  InpStrH := '';
  SignPointCount := 0;
  InputMode := 1;
  ActLanguage := DefaultLanguage;
  TextAppInfo := true;
  paint;
end;

procedure TInfoAssistForm.SocketSendName;
begin
  if (InpStrF = '') and (InpStrH = '') and (length(InpStrN) = 1) and
    (SignPointCount = 0) then
  begin
    SocketSendCountry;
    gateF('n' +  InpStrN);
  end
  else
    gateF('N' +  InpStrN);
end;

procedure TInfoAssistForm.SocketSendCountry;
begin
  gateF('C'  + AnsiUpperCase(ActLanguage));
end;

procedure TInfoAssistForm.SocketSendFirm;
begin
  gateF('F' +  InpStrF);
end;

procedure TInfoAssistForm.SocketSendHandy;
begin
  gateF('H' +  InpStrH);
end;

end.

  procedure OnTCPServerClientSend
(Sender: TObject; Buf: PAnsiChar; var DataLen: Integer);
procedure OnTCPServerClientReceive
(Sender: TObject; Buf: PAnsiChar; var DataLen: Integer);
procedure OnTCPServerClientDisconnect
(Sender: TObject);
{ ... }
FTCPServerClient: TCustomIpClient;
{ ... }
procedure TFrmMain.BtnStartClick
(Sender: TObject); begin if TCPServer.Listening then TCPServer.close
(); try TCPServer.LocalPort := EdtPort.Text;
TCPServer.LocalHost := EdtLocalHost.Text; TCPServer.Open
(); except end; end;

procedure TFrmMain.TCPServerAccept
(Sender: TObject; ClientSocket: TCustomIpClient); begin MemoLog.Lines.add
(" IN_ " + ClientSocket.RemoteHost + " _CONNECTED ");
ClientSocket.OnSend := OnTCPServerClientSend;
ClientSocket.OnReceive := OnTCPServerClientReceive;
ClientSocket.OnDisconnect := OnTCPServerClientDisconnect;
FTCPServerClient := ClientSocket; if TCPClient.Active then TCPClient.close
(); TCPClient.RemoteHost := EdtRemoteHost.Text;
TCPClient.RemotePort := EdtPort.Text; TCPClient.Open
(); end;

procedure TFrmMain.OnTCPServerClientSend
(Sender: TObject; Buf: PAnsiChar; var DataLen: Integer);

var
  s: string;

begin
  s := copy(Buf, 0, DataLen);
  MemoLog.Lines.add(" IN_SEND > " + s);
end;

procedure TFrmMain.OnTCPServerClientReceive(Sender: TObject; Buf: PAnsiChar;
  var DataLen: Integer);
var
  s: string;
begin
  s := copy(Buf, 0, DataLen);
  MemoLog.Lines.add(" IN_RECEIVE > " + s);
  if TCPClient.Active then
    TCPClient.SendBuf(Buf, DataLen);
end;

procedure TFrmMain.OnTCPServerClientDisconnect(Sender: TObject);
begin
  MemoLog.Lines.add(" IN_ " + TCustomIpClient(Sender).RemoteHost +
    " _DISCONNECTED ");
  TCPClient.close();
end;

procedure TFrmMain.TCPClientConnect(Sender: TObject);
begin
  MemoLog.Lines.add(" OUT_ " + TCPClient.RemoteHost + " _CONNECTED ");
end;

procedure TFrmMain.TCPClientDisconnect(Sender: TObject);
begin
  MemoLog.Lines.add(" OUT_ " + TCPClient.RemoteHost + " _DISCONNECTED ");
end;

procedure TFrmMain.TCPClientReceive(Sender: TObject; Buf: PAnsiChar;
  var DataLen: Integer);
var
  s: string;
begin
  s := copy(Buf, 0, DataLen);
  MemoLog.Lines.add(" OUT_RECEIVE > " + s);
  if FTCPServerClient <> nil then
    FTCPServerClient.SendBuf(Buf, DataLen);
end;

procedure TFrmMain.TCPClientSend(Sender: TObject; Buf: PAnsiChar;
  var DataLen: Integer);
var
  s: string;
begin
  s := copy(Buf, 0, DataLen);
  MemoLog.Lines.add(" OUT_SEND > " + s);
end;
