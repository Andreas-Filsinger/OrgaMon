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
unit wanfix32;

{$IFDEF CONSOLE}
{$MESSAGE FATAL 'Prüfe Abhängigkeit: Diese Unit hat GUI'}
{$ENDIF}

interface

uses
  windows,
  classes,
  grids,
  graphics, {wegen "canvas"}
  extctrls; { wegen "TImage" }

const
  // Basis für fest angegebene Pixel-Werte, die aber
  // DPI-Aware umgerechnet werden sollen. Der Entwickler muss also
  // so denken als sei die Anwendung ausschliesslich für 96.0 DPI programmiert
  // die Umrechnung geschieht zur Laufzeit mit der Funktion DPIx()
  cAppDesigner_PixelsPerInch: double = 96.0;

  // Grafische Sachen
function LoadGraphicsFile(const Filename: string): TBitmap;
procedure DrawImage(Canvas: TCanvas; DestRect: TRect; ABitmap: TBitmap);
procedure DisplayBitmap(const Bitmap: TBitmap; const Image: TImage;
  FillColor: TColor);
procedure SetBitMapSizeTo(Bitmap: TBitmap; const xl, yl: integer);
procedure BMPScramble(const b: TBitmap; Key: integer);
function dpiX(PixelCount: integer): integer;

// Farb-Sachen
function VisibleContrast(BackGroundColor: TColor): TColor;
function ColorBrightness(Color: TColor; RGB_delta: integer): TColor;
function ColorDistance(c1, c2: TColor): integer; // 0..3*255
function ScreenColorRes: int64;

// Fonts
function FontInstalled(const FontName: string): boolean;

// System Sachen (VCL-Abhängig)
procedure EnumAllWindows(Names: TStringList);
function TerminateIfAlreadyRunning(ApplicationName: string;
  BringOtherUp: boolean = true): boolean;
procedure delay(milliseconds: Cardinal); // sleep

// Dokumente öffnen
function openShell(dokument: string; Visibility: Word = SW_SHOWMAXIMIZED)
  : boolean; overload;

// Dokumente drucken
function printShell(dokument: string): boolean;
function printto(Handle: THandle; dokument: AnsiString): boolean;
procedure PrintHTMLByIE(const url: string);
function printhtml(dokument: string): boolean;
function printhtmlOK(FName: string): boolean;
function printpdf(dokument: string): boolean;

// Macros, Automatisierung
procedure SetMousePos(x, y: integer);
procedure PressKey(k: integer);

// Tastatur Status
function CtrlDown: boolean;

// Info/Message-Boxes
function DoIt(Frage: string; Danger: boolean = false): boolean; overload;
function DoIt(const Frage: TStrings; Danger: boolean = false): boolean;
  overload;
function YesNoIgnore(Frage: string): integer; // [IDYES, IDNO]
function YesNoCancel(Frage: string): integer; // [IDYES, IDNO]

// Info/Message-Boxes mit TimeOut
procedure ShowMessageTimeout(Meldung: string; TimeOut: integer = 5000
  { [ms] } );
function DoItTimeOut(Frage: string; TimeOut: integer = 5000;
  Danger: boolean = false): boolean;

procedure dgAutoSize(const dg: TDrawGrid; VerticalScrollBar: boolean = false);

implementation

{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}

uses
  SysUtils, forms, dialogs,
  registry, Messages, printers,
  shellapi, math, FileCtrl,
  JclSysUtils, JclDateTime, JclMiscel, ComObj,
  anfix32;

function ScreenColorRes: int64;
var
  DC: HDC;
begin
  DC := GetDC(0);
  result := trunc(IntPower(2.0, GetDeviceCaps(DC, BITSPIXEL)));
  // trunc(log2());
  // result  := GetDeviceCaps(DC, BITSPIXEL); // trunc(log2());
  ReleaseDC(0, DC);
end;

//

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
      DestRect.Right - DestRect.Left, DestRect.Bottom - DestRect.Top, 0, 0,
      ABitmap.Width, ABitmap.Height, Bits, TBitmapInfo(Header^),
      DIB_RGB_COLORS, SRCCOPY);
  finally
    FreeMem(Header, HeaderSize);
    FreeMem(Bits, BitsSize);
  end;
end;

// Based on suggestions from Anders Melander.  See Magnifier Lab Report
// www.efg2.com/Lab/ImageProcessing/Magnifier.htm

function LoadGraphicsFile(const Filename: string): TBitmap;
var
  Picture: TPicture;
begin
  result := nil;

  if FileExists(Filename) then
  begin

    result := TBitmap.Create;
    try
      Picture := TPicture.Create;
      try
        Picture.LoadFromFile(Filename);
        // Try converting picture to bitmap
        try
          result.Assign(Picture.Graphic);
        except
          // Picture didn't support conversion to TBitmap.
          // Draw picture on bitmap instead.
          result.Width := Picture.Graphic.Width;
          result.Height := Picture.Graphic.Height;
          result.PixelFormat := pf24bit;
          result.Canvas.Draw(0, 0, Picture.Graphic);
        end
      finally
        Picture.Free
      end
    except
      result.Free;
      raise
    end

  end
end { LoadGraphicFile };


// Display Bitmap in Image.  Keep the TBitmap as large as possible
// in the TImage while maintaining the correct aspect ratio.

function ColorBrightness(Color: TColor; RGB_delta: integer): TColor;
begin
  with TRGBQuad(Color) do
  begin
    rgbRed := min(rgbRed + RGB_delta, 255);
    rgbGreen := min(rgbGreen + RGB_delta, 255);
    rgbBlue := min(rgbBlue + RGB_delta, 255);
  end;
  result := Color;
end;

procedure DisplayBitmap(const Bitmap: TBitmap; const Image: TImage;
  FillColor: TColor);
var
  Half: integer;
  Height: integer;
  NewBitmap: TBitmap;
  TargetArea: TRect;
  Width: integer;
begin
  NewBitmap := TBitmap.Create;
  try
    NewBitmap.Width := Image.Width;
    NewBitmap.Height := Image.Height;
    NewBitmap.PixelFormat := pf24bit;

    NewBitmap.Canvas.Brush.Color := FillColor;
    NewBitmap.Canvas.FillRect(NewBitmap.Canvas.ClipRect);

    // "equality" (=) case can go either way in this comparison

    if Bitmap.Width / Bitmap.Height < Image.Width / Image.Height then
    begin

      // Stretch Height to match.
      TargetArea.Top := 0;
      TargetArea.Bottom := NewBitmap.Height;

      // Adjust and center Width.
      Width := MulDiv(NewBitmap.Height, Bitmap.Width, Bitmap.Height);
      Half := (NewBitmap.Width - Width) div 2;

      TargetArea.Left := Half;
      TargetArea.Right := TargetArea.Left + Width;
    end
    else
    begin
      // Stretch Width to match.
      TargetArea.Left := 0;
      TargetArea.Right := NewBitmap.Width;

      // Adjust and center Height.
      Height := MulDiv(NewBitmap.Width, Bitmap.Height, Bitmap.Width);
      Half := (NewBitmap.Height - Height) div 2;

      TargetArea.Top := Half;
      TargetArea.Bottom := TargetArea.Top + Height
    end;

    NewBitmap.Canvas.StretchDraw(TargetArea, Bitmap);
    Image.Picture.Graphic := NewBitmap
  finally
    NewBitmap.Free
  end
end { DisplayBitmap };

procedure delay(milliseconds: Cardinal);
var
  BeforeTicks: dword;
  NowTicks: dword;
  ms: Cardinal;
begin
  //
  if (milliseconds > 0) then
  begin
    if (milliseconds > 10) then
    begin
      ms := milliseconds;

      BeforeTicks := GetTickCount;
      application.processmessages;
      NowTicks := GetTickCount;

      if (NowTicks > BeforeTicks) then
        dec(milliseconds, NowTicks - BeforeTicks);
      if (milliseconds > ms) then
        milliseconds := ms;
      if (milliseconds > 0) then
        sleep(milliseconds);
    end
    else
    begin
      sleep(milliseconds);
    end;
  end;
end;

procedure SetBitMapSizeTo(Bitmap: TBitmap; const xl, yl: integer);
var
  ARect: TRect;
begin
  Bitmap.Width := xl;
  Bitmap.Height := yl;
  ARect := Rect(0, 0, pred(xl), pred(yl));
  Bitmap.Canvas.Brush.style := bssolid;
  Bitmap.Canvas.CopyMode := cmWhiteness;
  Bitmap.Canvas.CopyRect(ARect, Bitmap.Canvas, ARect);
  Bitmap.Canvas.CopyMode := cmSrcCopy;
end;

var
  WindowList: TStringList = nil;

function GetWindowsProcLower(Handle: HWND; Info: Pointer): BOOL; stdcall;
var
  Dest: array [0 .. 1023] of char;
begin
  GetWindowText(Handle, Dest, pred(sizeof(Dest)));
  if StrLen(Dest) > 0 then
    if assigned(WindowList) then
      WindowList.AddObject(AnsiLowerCase(Dest), Pointer(Handle));
  result := true;
end;

function GetWindowsProc(Handle: HWND; Info: Pointer): BOOL; stdcall;
var
  Dest: array [0 .. 1023] of char;
begin
  GetWindowText(Handle, Dest, pred(sizeof(Dest)));
  if (StrLen(Dest) > 0) then
    if assigned(WindowList) then
      WindowList.AddObject(Dest, Pointer(Handle));
  result := true;
end;

procedure EnumAllWindows(Names: TStringList);
begin
  WindowList := Names;
  EnumWindows(@GetWindowsProc, 0);
  WindowList := nil;
end;

function TerminateIfAlreadyRunning(ApplicationName: string;
  BringOtherUp: boolean = true): boolean;
var
  Wind: HWND;
  n: integer;
begin
  result := false;
  if AlreadyRunning(ApplicationName) then
  begin
    if BringOtherUp then
    begin
      WindowList := TStringList.Create;
      ApplicationName := AnsiLowerCase(ApplicationName);
      EnumWindows(@GetWindowsProcLower, 0);
      for n := 0 to pred(WindowList.count) do
      begin
        Wind := HWND(WindowList.Objects[n]);
        if (Wind <> application.Handle) then
          if (ApplicationName = WindowList[n]) then
          begin
            if not(ShowWindow(Wind, sw_show)) then
              beep;
            if not(SetForegroundWindow(Wind)) then
              beep;
          end;
      end;
      WindowList.Free;
    end;
    halt;
    result := true;
  end;
end;

function printto(Handle: THandle; dokument: AnsiString): boolean;
var
  Device: array [0 .. 1023] of char;
  Driver: array [0 .. 1023] of char;
  Port: array [0 .. 1023] of char;
  hDeviceMode: THandle;
  sPrinterIdentification: string;
  p1, p2: array [0 .. 1023] of AnsiChar;
  SE_result: integer;

begin
  Printer.PrinterIndex := -1; // select a printer, in this case default
  Printer.GetPrinter(Device, Driver, Port, hDeviceMode);
  sPrinterIdentification := Format('"%s" "%s" "%s"', [Device, Driver, Port]);
  StrPcopy(p1, dokument);
  StrPcopy(p2, sPrinterIdentification);
  SE_result := ShellExecuteA(Handle, 'printto', p1, p2, nil, SW_HIDE);
  result := SE_result > 32;
end;

procedure PrintHTMLByIE(const url: string);
const
  OLECMDID_PRINT = $00000006;
  OLECMDEXECOPT_DONTPROMPTUSER = $00000002;
  READYSTATE_COMPLETE = 4;
  PRINT_WAITFORCOMPLETION = 2;
var
  ie, vaIn, vaOut: Variant;
begin
  ie := CreateOleObject('InternetExplorer.Application');
  ie.Navigate('file:\\' + url);
  while (ie.ReadyState <> READYSTATE_COMPLETE) do
    application.processmessages;
  ie.Visible := true;
  ie.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_DONTPROMPTUSER, vaIn, vaOut);
  // ie.Visible := false;
  // ie.quit;
end;

(*
  procedure PrintHTMLByIE(const url: string);
  const
  OLECMDID_PRINT = $00000006;
  OLECMDEXECOPT_DONTPROMPTUSER = $00000002;
  var
  ie, vaIn, vaOut: Variant;
  begin
  ie := CreateOleObject('InternetExplorer.Application');
  ie.Navigate(url);
  ie.Visible := True;
  ie.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_DONTPROMPTUSER, vaIn, vaOut);
  end;
*)

(*
  var
  Device: array[0..255] of Char;
  Driver: array[0..255] of Char;
  Port: array[0..255] of Char;
  S: string;
  documentname: string;
  begin
  documentname := 'c:\anydocument.doc';
  ShellExecute(Handle, 'printto', PChar(documentname), PChar(S), nil, SW_HIDE);
  end; *)

function WinExec32TimeOut(Cmd: string; const CmdShow: integer;
  TimeOut: dword): string;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  apiResult: boolean;
begin
  result := 'OK';
  ResetMemory(StartupInfo, sizeof(TStartupInfo));
  ResetMemory(ProcessInfo, sizeof(ProcessInfo));
  StartupInfo.cb := sizeof(TStartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := CmdShow;
  UniqueString(Cmd);
  // in the Unicode version the parameter lpCommandLine needs to be writable
  apiResult := CreateProcess(nil, PChar(Cmd), nil, nil, false,
    NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo);

  if apiResult then
  begin
    apiResult := (WaitForInputIdle(ProcessInfo.hProcess, TimeOut) = 0);
    if apiResult then
    begin
      CloseHandle(ProcessInfo.hThread);
      CloseHandle(ProcessInfo.hProcess);
    end
    else
    begin
      result := 'WaitForInputIdle:' + SysErrorMessage(GetLastError);
    end;
  end
  else
  begin
    result := 'CreateProcess:' + SysErrorMessage(GetLastError);
  end;
end;

function printhtml(dokument: string): boolean;
begin
  result := WinExec32('rundll32.exe mshtml.dll,PrintHTML "' + dokument + '"',
    sw_showdefault);
end;

function printpdf(dokument: string): boolean;
const
  cAdobe9 = 'Adobe\Reader 9.0\Reader\AcroRd32.exe';
  cAdobe7 = 'adobe\acrobat 7.0\reader\acrord32.exe';
var
  InstalledReader: string;
begin
  repeat
    // detect newest reader
    if FileExists(ProgramFilesDir + cAdobe9) then
    begin
      InstalledReader := ProgramFilesDir + cAdobe9;
      break;
    end;
    if FileExists(ProgramFilesDir + cAdobe7) then
    begin
      InstalledReader := ProgramFilesDir + cAdobe7;
      break;
    end;
    InstalledReader := '';
  until true;

  if (InstalledReader <> '') then
    result := WinExec32(
      { } '"' + InstalledReader + '"' +
      { } ' /p /h "' + dokument + '"', sw_showdefault)
  else
    result := false;

end;

function printhtmlOK(FName: string): boolean;
const
  cTimeOut = 20000;
  cDelayGranularity = 250;
var
  WindowList: TStringList;
  TimeWaited: integer;

  function dFName: string;
  begin
    result :=
    { } DebugLogPath +
    { } 'Print-HTML-OK-' +
    { } ComputerName + '-' +
    { } DatumLog +
    { } '.txt.log';
  end;

  procedure d(s: string); overload;
  begin
    if (DebugLogPath <> '') then
      AppendStringsToFile(
        { } sTimeStamp + ' ' + s,
        { } dFName);
  end;

  procedure d(s: TStrings); overload;
  var
    sl: TStringList;
  begin
    if (DebugLogPath <> '') then
    begin
      sl := TStringList.Create;
      sl.Add(HugeSingleLine(s, '|'));
      AppendStringsToFile(
        { } sl,
        { } dFName, sTimeStamp);
      sl.Free;
    end;
  end;

begin
  result := false;
  d(FName);
  if FileExists(FName) then
  begin
    WindowList := TStringList.Create;

    // Ausgeben der Datei auf den Drucker
    d(WinExec32TimeOut('rundll32.exe mshtml.dll,PrintHTML "' + FName + '"',
      sw_showdefault, 60000));

    // "OK" drücken
    TimeWaited := 0;
    repeat

      // schlafen
      delay(cDelayGranularity);
      Inc(TimeWaited, cDelayGranularity);

      //
      WindowList.clear;
      EnumAllWindows(WindowList);
      d(WindowList);

      if (WindowList.indexof('Drucken') <> -1) then
      begin
        delay(cDelayGranularity*2);
        d('PRE-VK_RETURN');
        PostKeyEx32(VK_RETURN, [], false);
        d('POST-VK_RETURN');
        delay(cDelayGranularity);
        d('POST DELAY');
        result := true;
        break;
      end;

      d('Fenster "Drucken" nicht dabei!');

    until (TimeWaited >= cTimeOut);
    d('POST LOOP');
    WindowList.Free;
    d('result = ' + booltostr(result, 'true', 'false'));
  end;
end;

// SetMousePos
// ###########

var
  MacroRunning: boolean = false;
  FPlayingSpeed: integer = 0;
  FWindowHandle: HWND;

const
  MAXMSG = 5;

type
  TwMsg = Longint;
  TwParam = Longint;
  TlParam = Longint;

type
  PEventMsg = ^TEventMsg;
  TMsgBuff = array [0 .. MAXMSG] of TEventMsg;

var
  MsgBuff: TMsgBuff;
  TheHook: HHook;
  currentMsg, the_Handle: Longint;
  playspeed: integer;
  msgCount: integer;

  // if msg_code is a mouse_message so the result false;

function noMouseMsg(msg_code: integer): boolean;
begin
  result := not((msg_code >= 512) and (msg_code <= 518));
end;

// ************************Hook Functions***************************************

function PlaybackProc(Code: integer; wParam: TwParam; lParam: TlParam)
  : Longint; stdcall;
begin
  PlaybackProc := 0;
  case Code of
    HC_SKIP:
      begin
        Inc(currentMsg); { get the next message }
        if currentMsg >= (msgCount - 1) then
        begin
          if UnHookWindowsHookEx(TheHook) = true then
          begin
            TheHook := 0;
            MacroRunning := false;
            // SendMessage(the_handle,wm_lbuttonup,0,0);
          end;
          exit;
        end;
      end;
    HC_GETNEXT:
      begin
        sleep(playspeed);
        PEventMsg(lParam)^ := MsgBuff[currentMsg]; { play the current message }
      end;
    HC_SYSMODALON:
      begin
        CallNextHookEx(TheHook, Code, wParam, lParam);
        exit;
      end;
    HC_SYSMODALOFF:
      begin
        TheHook := 0;
        CallNextHookEx(TheHook, Code, wParam, lParam);
        exit;
      end;
  end;
  if Code < 0 then
    PlaybackProc := CallNextHookEx(TheHook, Code, wParam, lParam);
end;

// ************************end of Hook Functions***************************************

// *******************************methods***************************

procedure PlayMacro;
begin
  currentMsg := 0;
  if (msgCount > 0) then
  begin
    MacroRunning := true;
    playspeed := FPlayingSpeed;
    the_Handle := FWindowHandle;
    TheHook := SetWindowsHookEx(wh_journalplayback, @PlaybackProc,
      hInstance, 0);
  end;
end;

// *******************************end of methods***************************

procedure PressKey(k: integer);
begin
  with MsgBuff[0] do // teventmsg
  begin
    Message := WM_KEYDOWN;
    paraml := vk_f1 + pred(k) + ((59 + pred(k)) shl 16);
    paramh := 1;
    time := 0;
    HWND := 0;
  end;
  with MsgBuff[1] do // teventmsg
  begin
    Message := WM_KEYUP;
    paraml := MsgBuff[0].paraml;
    paramh := 1;
    time := 0;
    HWND := 0;
  end;
  msgCount := 2;
  PlayMacro;
end;

procedure SetMousePos(x, y: integer);
begin
  with MsgBuff[0] do // teventmsg
  begin
    Message := WM_MOUSEMOVE;
    paraml := x;
    paramh := y;
    time := 0;
    HWND := 0;
  end;
  msgCount := 1;
  PlayMacro;
end;

function FontInstalled(const FontName: string): boolean;
//
// alternative:
// ============
//
// UnicodeFont = 'Arial Unicode MS';
// ...
// IF   Screen.Fonts.IndexOf(UnicodeFont)
//
var
  pitch: Byte;
  MyCanvas: TCanvas;
  TextMet: TTextMetric;
begin
  MyCanvas := TCanvas.Create;
  try
    MyCanvas.Handle := CreateCompatibleDC(0);
    MyCanvas.Font.Name := FontName;
    GetTextMetrics(MyCanvas.Handle, TextMet);
    pitch := TextMet.tmPitchAndFamily and $07;
    result := ((pitch and TMPF_TRUETYPE) <> 0);
  except
    result := false;
  end;
  MyCanvas.Free;
end;

var
  BMPScrambleSeed: integer;

procedure BMPScramble(const b: TBitmap; Key: integer);

//
// (c)'01 by http://www.efg2.com/lab
//
// scrambles (encrypt) a bitmap before you save it to
// disk (for example) or before post it to a database-field.
// Scramble it again before you want to view it.
// Ensure to use the same key-value, for each pic, but
// different key-values for different pictures.
//
//
// Rev. 1.001 (2001-12-02) Andreas Filsinger, www.cargobay.de
// new: "global" var "BMPScrambleSeed"
// fix: NextModulu Bug
// Rev. 1.000 (2001-12-02) Andreas Filsinger, www.cargobay.de
// info: This is my delphi 6.01 Version: There where two reasons
// because i rewrite the code.
// 1) In the Delphi Help there is a hint, that you should NOT
// use "random" to encrypt data, because implementations may
// change in future releases.
// 2) after "dormat" i accessed the Rows: That caused an Exception
// new: only one ScanLine[n]
// new: NO random()-call
//

var
  i, j: integer;
  Row: PWordArray;
  ScanlineBytes: integer;
  _ScanlineOp: Word;

  function NextModulu: Word;
  asm
    PUSH    EBX
    XOR     EBX, EBX
    MOV     EAX,10000H
    IMUL    EDX,[EBX].BMPScrambleSeed,08088405H
    INC     EDX
    MOV     [EBX].BMPScrambleSeed,EDX
    MUL     EDX
    MOV     EAX,EDX
    POP     EBX
  end;

  begin
    BMPScrambleSeed := Key;
    with b do
    begin
      // Ensure, this is a device independent Bitmap
      HandleType := bmDIB;
      // Get the Adress of the first Pixel-Data-Row
      Row := ScanLine[0];
      // Obtain Lenght of one ROW
      ScanlineBytes := integer(ScanLine[1]) - integer(Row);
      // Obtain Lenght of one, ignore direction, "Count of words" is OK
      _ScanlineOp := abs(ScanlineBytes) div 2;
      // for each line
      for j := 0 to pred(Height) do
      begin
        // for each pixel-data-word
        for i := 0 to pred(_ScanlineOp) do
          Row[i] := Row[i] xor NextModulu;
        // theres no need to call ScanLine[] again
        Inc(integer(Row), ScanlineBytes);
      end;
    end;
  end;

function VisibleContrast(BackGroundColor: TColor): TColor;
const
  cHalfBrightness = ((0.3 * 255.0) + (0.59 * 255.0) + (0.11 * 255.0)) / 2.0;
var
  Brightness: double;
begin
  with TRGBQuad(BackGroundColor) do
    Brightness := (0.3 * rgbRed) + (0.59 * rgbGreen) + (0.11 * rgbBlue);
  if (Brightness > cHalfBrightness) then
    result := clblack
  else
    result := clwhite;
end;

function ColorDistance(c1, c2: TColor): integer; // 0..3*255
var
  Distance: double;
  cc1: TRGBQuad absolute c1;
  cc2: TRGBQuad absolute c2;
begin
  Distance := (0.3 * abs(cc1.rgbRed - cc2.rgbRed)) +
    (0.59 * abs(cc1.rgbGreen - cc2.rgbGreen)) +
    (0.11 * abs(cc1.rgbBlue - cc2.rgbBlue));
  result := round(Distance);

end;

const
  _dpi: double = 0;

function dpiX(PixelCount: integer): integer;
var
  p2: double;
begin
  if (_dpi = 0) then
    _dpi := screen.PixelsPerInch;
  p2 := PixelCount;
  result := round((_dpi / cAppDesigner_PixelsPerInch) * double(p2));
end;

function DoIt(Frage: string; Danger: boolean = false): boolean;
begin
  ersetze('|', #13, Frage);
  if Danger then
    result := (MessageBox(0, PChar(Frage + '?'), PChar(cNachfrage),
      MB_TOPMOST or mb_OKCANCEL or MB_ICONSTOP or MB_DEFBUTTON2) = IDOK)
  else
    result := (MessageBox(0, PChar(Frage + '?'), PChar(cNachfrage),
      MB_TOPMOST or mb_OKCANCEL or MB_ICONQUESTION or MB_DEFBUTTON2) = IDOK)
end;

function DoIt(const Frage: TStrings; Danger: boolean = false): boolean;
var
  _Frage: string;
  n: integer;
begin
  _Frage := '';
  for n := 0 to pred(Frage.count) do
    _Frage := _Frage + Frage[n] + #13;
  if length(_Frage) > 0 then
    delete(_Frage, length(_Frage), 1);
  result := DoIt(_Frage, Danger);
end;

function YesNoIgnore(Frage: string): integer;
begin
  ersetze('|', #13, Frage);
  result := MessageBox(0, PChar(Frage + '?'), PChar(cNachfrage),
    MB_ABORTRETRYIGNORE or MB_ICONQUESTION or MB_DEFBUTTON2);
end;

function YesNoCancel(Frage: string): integer;
begin
  ersetze('|', #13, Frage);
  result := MessageBox(0, PChar(Frage + '?'), PChar(cNachfrage),
    MB_YESNOCANCEL or MB_ICONQUESTION or MB_DEFBUTTON1 or MB_TASKMODAL);
end;

type
  TMessageBoxTimeOut = function(HWND: HWND; lpText: PChar; lpCaption: PChar;
    uType: UINT; wLanguageId: Word; dwMilliseconds: dword): integer; stdcall;

const
  MB_TIMEDOUT = 32000;
  LIB_USER32: HMODULE = 0;
  MessageBoxTimeOut: TMessageBoxTimeOut = nil;
  MessageBoxTimeOutInitialized: boolean = false;

procedure ShowMessageTimeout(Meldung: string; TimeOut: integer = 5000
  { [ms] } );
var
  iFlags: integer;
begin
  // First Call?
  if not(MessageBoxTimeOutInitialized) then
  begin
    LIB_USER32 := LoadLibrary('user32.dll');
    MessageBoxTimeOut := GetProcAddress(LIB_USER32, 'MessageBoxTimeoutW');
    MessageBoxTimeOutInitialized := true;
  end;

  if assigned(MessageBoxTimeOut) then
  begin
    iFlags := MB_OK or MB_SETFOREGROUND or MB_SYSTEMMODAL or MB_ICONINFORMATION;
    MessageBoxTimeOut(application.Handle, PChar(Meldung),
      PChar(Format('Info für %d Sekunden', [TimeOut DIV 1000])), iFlags,
      0, TimeOut);
  end
  else
  begin
    // Windows 2000: (bisher) keine Entsprechung programmiert!
    ShowMessage(Meldung);
  end;
end;

function DoItTimeOut(Frage: string; TimeOut: integer = 5000;
  Danger: boolean = false): boolean;
var
  iFlags: integer;
  MBresult: integer;
begin
  // First Call?
  if not(MessageBoxTimeOutInitialized) then
  begin
    LIB_USER32 := LoadLibrary('user32.dll');
    MessageBoxTimeOut := GetProcAddress(LIB_USER32, 'MessageBoxTimeoutW');
    MessageBoxTimeOutInitialized := true;
  end;

  if assigned(MessageBoxTimeOut) then
  begin

    ersetze('|', #13, Frage);
    if Danger then
      iFlags := mb_OKCANCEL or MB_DEFBUTTON2 or MB_SETFOREGROUND or
        MB_SYSTEMMODAL or MB_ICONSTOP
    else
      iFlags := mb_OKCANCEL or MB_DEFBUTTON2 or MB_SETFOREGROUND or
        MB_SYSTEMMODAL or MB_ICONQUESTION;

    MBresult := MessageBoxTimeOut(application.Handle, PChar(Frage),
      PChar(Format('OK nach %d Sekunden', [TimeOut DIV 1000])), iFlags, 0,
      TimeOut);

    result := (MBresult=MB_TIMEDOUT) or (MBresult=IDOK);
  end
  else
  begin
    // Windows 2000: (bisher) keine Entsprechung programmiert!
    result := DoIt(Frage, Danger);
  end;

end;

procedure dgAutoSize(const dg: TDrawGrid; VerticalScrollBar: boolean = false);
var
  KorrekturX: integer;
  Unkorrigierbar: integer;
  SizeX: integer;
  n: integer;
begin
  with dg, Canvas do
  begin
    SizeX := 0;
    for n := 0 to pred(ColCount) do
      Inc(SizeX, abs(ColWidths[n]));

    KorrekturX := Clientwidth - SizeX;
    if VerticalScrollBar then
      dec(KorrekturX, GetSystemMetrics(SM_CXVSCROLL));

    while (KorrekturX <> 0) do
    begin
      Unkorrigierbar := 0;
      for n := 0 to pred(ColCount) do
        if ColWidths[n] < 0 then
        begin
          if KorrekturX > 0 then
          begin
            ColWidths[n] := ColWidths[n] - 1;
            dec(KorrekturX);
          end;
          if KorrekturX < 0 then
          begin
            ColWidths[n] := ColWidths[n] + 1;
            Inc(KorrekturX);
          end;
        end
        else
        begin
          Inc(Unkorrigierbar);
        end;
      if (Unkorrigierbar = ColCount) then
        break;
    end;

    for n := 0 to pred(ColCount) do
      ColWidths[n] := abs(ColWidths[n]);

  end;
end;

function openShell(dokument: string;
  Visibility: Word = SW_SHOWMAXIMIZED): boolean;
begin
  result := ShellExecute(0, 'open', PChar(dokument), nil, nil, Visibility) > 32;
end;

function printShell(dokument: string): boolean;
begin
  result := ShellExecute(0, 'print', PChar(dokument), nil, nil,
    SW_SHOWMAXIMIZED) > 32;
end;

function CtrlDown: boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  result := ((State[vk_Control] And 128) <> 0);
end;

end.
