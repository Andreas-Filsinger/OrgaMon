unit txlib_UI;

// **************************************************
// * TXLIB Rev. 0.046                               *
// *                                                *
// *           Autor: Ronny Schupeta                *
// * Letzte Änderung: 29.10.2009                    *
// **************************************************


interface

uses Windows, SysUtils, StrUtils,  Classes,
ActiveX, Forms, Controls, StdCtrls, Graphics,

     DateUtils, Messages, ShellAPI, Shlobj,  WinSock, txlib;


const
  WM_TRAYMSG = WM_USER + 10;

type
  TTXSysTray = class(TComponent)
  private
    FNid:         TNotifyIconData;
    FNidVisible:  Boolean;

    FDestroyed:   Boolean;

    FVisible:     Boolean;
    FIcon:        TIcon;
    FHint:        AnsiString;
    FID:          Cardinal;

    FOnClick:     TMouseEvent;
    FOnDblClick:  TMouseEvent;
    FOnMouseDown: TMouseEvent;
    FOnMouseUp:   TMouseEvent;
    FOnMouseMove: TMouseEvent;

    FOldWndProc:  TFarProc;
    FNewWndProc:  Pointer;

    procedure SetVisible(Visible: Boolean);
    procedure SetIcon(Icon: TIcon);
    procedure SetHint(const Hint: AnsiString);
    procedure SetID(ID: Cardinal);

    procedure UpdateSysTray(UpdateNID: Boolean = True);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Visible: Boolean read FVisible write SetVisible;
    property Icon: TIcon read FIcon write SetIcon;
    property Hint: AnsiString read FHint write SetHint;
    property ID: Cardinal read FID write SetID;

    property OnClick: TMouseEvent read FOnClick write FOnClick;
    property OnDblClick: TMouseEvent read FOnDblClick write FOnDblClick;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnMouseMove: TMouseEvent read FOnMouseMove write FOnMouseMove;
  protected
    procedure WndProc(var Msg: TMessage);
  end;
  TGradientDirection = (gdVertical, gdHorizontal);
type
  TSpecialFolder = ( sfPrograms, sfCommonPrograms, sfDesktop, sfCommonDesktop,
                     sfRecent, sfPersonal, sfFavorites, sfCommonFavorites,
                     sfNetwork, sfTemplates );

function GetSpecialFolder(SpecialFolder: TSpecialFolder): AnsiString;

  function LimitText(Canvas: TCanvas; const Text: AnsiString; MaxWidth: Integer; SetPointsAfterText: Boolean = True): AnsiString;
// Grafische Funktionen
procedure BlendBitmap(SrcBitmap1, SrcBitmap2, DestBitmap: TBitmap; Alpha: Integer);
procedure FillAlphaRect(Canvas: TCanvas; Rect, ClipRect: TRect; Color: TColor; Alpha: Integer; TempBitmap: TBitmap = nil);
procedure ShadedRect(Canvas: TCanvas; Rect, ClipRect: TRect; ColorFrom, ColorTo: TColor; Direction: TGradientDirection);
procedure DrawText(Canvas: TCanvas; Rect, ClipRect: PRect; Text: AnsiString; Font: TFont; HAlign: TAlignment = taLeftJustify; VAlign: TTextLayout = tlTop); overload;
procedure DrawText(Canvas: TCanvas; Rect: PRect; Text: AnsiString; Font: TFont; HAlign: TAlignment = taLeftJustify; VAlign: TTextLayout = tlTop); overload;
procedure DrawText(Canvas: TCanvas; X, Y: Integer; Text: AnsiString; Font: TFont); overload;
procedure TextRotated(Canvas: TCanvas; ClipRect: TRect; Rotation, X, Y: Integer; Text: AnsiString; Font: TFont);

// Console
procedure PrintConsole(const Text: AnsiString);
procedure PrintLine(const Text: AnsiString = '');
function InputConsole(const Text: AnsiString = ''): AnsiString;
procedure CloseConsole;
procedure ConsoleTitle(const Title: AnsiString);
function ConsoleWaitKey: Char;

procedure BPrint(const Text: AnsiString = '');
// Verzögerung
procedure Delay(Millisecs: Integer);

// Aktuelles, aktives Fenster
function ActiveHWND: Integer;

// Dialog
procedure MsgBoxTitle(const Title: AnsiString);
function MsgBox(const Text: AnsiString; Flags: Cardinal; const Title: AnsiString = ''): Integer;
procedure InfoMsg(const Text: AnsiString; const Title: AnsiString = '');
procedure WarningMsg(const Text: AnsiString; const Title: AnsiString = '');
procedure ErrorMsg(const Text: AnsiString; const Title: AnsiString = '');
procedure HandMsg(const Text: AnsiString; const Title: AnsiString = '');

function RequestDir(const Caption, Root: AnsiString): AnsiString;

// Schriftarten auslesen
procedure GetFontNames(FontList: TStrings);

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TXLib', [ TTXSysTray ]);
end;
constructor TTXSysTray.Create(AOwner: TComponent);
begin
  FOldWndProc := nil;

  inherited Create(AOwner);

  FDestroyed := False;

  FOnClick := nil;
  FOnDblClick := nil;
  FOnMouseDown := nil;
  FOnMouseUp := nil;
  FOnMouseMove := nil;

  FVisible := False;
  FNidVisible := False;
  FIcon := TIcon.Create;

  if not (csDesigning in ComponentState) then
  begin
    FOldWndProc := TFarProc(GetWindowLong((Owner as TForm).Handle, GWL_WNDPROC));
    FNewWndProc := MakeObjectInstance(WndProc);

    SetWindowLong((AOwner as TForm).Handle, GWL_WNDPROC, LongInt(FNewWndProc));

    FIcon.Assign(Application.Icon);

    UpdateSysTray;
  end;
end;

destructor TTXSysTray.Destroy;
begin
  FVisible := False;
  UpdateSysTray;
  FDestroyed := True;

  if FOldWndProc <> nil then
  begin
    SetWindowLong((Owner as TForm).Handle, GWL_WNDPROC, LongInt(FOldWndProc));
    FOldWndProc := nil;
  end;

  inherited;
end;

procedure TTXSysTray.SetVisible(Visible: Boolean);
begin
  if Visible <> FVisible then
  begin
    FVisible := Visible;
    UpdateSysTray;
  end;
end;

procedure TTXSysTray.SetIcon(Icon: TIcon);
begin
  if Icon <> FIcon then
  begin
    FIcon.Assign(Icon);

    UpdateSysTray;
  end;
end;

procedure TTXSysTray.SetHint(const Hint: AnsiString);
begin
  FHint := Hint;
  UpdateSysTray;
end;

procedure TTXSysTray.SetID(ID: Cardinal);
begin
  FID := ID;
  UpdateSysTray;
end;

procedure TTXSysTray.UpdateSysTray;
var
  S:  AnsiString;
  L:  Integer;
begin
  if (not FDestroyed) and (not (csDesigning in ComponentState)) then
  begin
    FNid.cbSize := sizeof(TNotifyIconData);
    FNid.Wnd := (Owner as TForm).Handle;
    FNid.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
    FNid.uCallbackMessage := WM_TRAYMSG;
    FNid.uID := FID;
    FNid.hIcon := FIcon.Handle;

    S := FHint;
    L := Length(S);
    if L > 63 then
    begin
      S := Copy(S, 1, 63) + #0;
      L := 63;
    end;

    if L > 0 then
      Move(Pointer(S)^, FNid.szTip, L + 1)
    else
      FNid.szTip := '';

    if (not FNidVisible) and FVisible then
      Shell_NotifyIcon(NIM_ADD, @FNid)
    else if FNidVisible and (not FVisible) then
      Shell_NotifyIcon(NIM_DELETE, @FNid)
    else if FNidVisible and FVisible then
      Shell_NotifyIcon(NIM_MODIFY, @FNid);

    FNidVisible := FVisible;
  end;
end;

procedure TTXSysTray.WndProc(var Msg: TMessage);
var
  X, Y:   Integer;

  procedure Click(Button: TMouseButton);
  begin
    if Assigned(FOnClick) then
      FOnClick(Self, Button, [ ], X, Y);
  end;

  procedure DblClick(Button: TMouseButton);
  begin
    if Assigned(FOnDblClick) then
      FOnDblClick(Self, Button, [ ], X, Y);
  end;

  procedure MouseDown(Button: TMouseButton);
  begin
    if Assigned(FOnMouseDown) then
      FOnMouseDown(Self, Button, [ ], X, Y);
  end;

  procedure MouseUp(Button: TMouseButton);
  begin
    if Assigned(FOnMouseUp) then
      FOnMouseUp(Self, Button, [ ], X, Y);
  end;

  procedure MouseMove(Button: TMouseButton);
  begin
    if Assigned(FOnMouseMove) then
      FOnMouseMove(Self, Button, [ ], X, Y);
  end;

  procedure GetPosition;
  var
    Pnt:  TPoint;
  begin
    GetCursorPos(Pnt);

    X := Pnt.X;
    Y := Pnt.Y;
  end;
begin
  Msg.Result := CallWindowProc(FOldWndProc, (Owner as TForm).Handle, Msg.Msg , Msg.wParam, Msg.lParam);

  case Msg.Msg of
  WM_TRAYMSG:
  begin
    GetPosition;

    case Msg.lParam of
    WM_MOUSEMOVE: MouseMove(mbLeft);
    WM_LBUTTONDOWN: MouseDown(mbLeft);
    WM_LBUTTONUP:
    begin
      MouseUp(mbLeft);
      Click(mbLeft);
    end;
    WM_LBUTTONDBLCLK: DblClick(mbLeft);
    WM_RBUTTONDOWN: MouseDown(mbRight);
    WM_RBUTTONUP:
    begin
      MouseUp(mbRight);
      Click(mbRight);
    end;
    WM_RBUTTONDBLCLK: DblClick(mbRight);
    WM_MBUTTONDOWN: MouseDown(mbMiddle);
    WM_MBUTTONUP:
    begin
      MouseUp(mbMiddle);
      Click(mbMiddle);
    end;
    WM_MBUTTONDBLCLK: DblClick(mbMiddle);
    end;
  end;
  WM_DESTROY:
  begin
    FVisible := False;
    UpdateSysTray;
    FDestroyed := True;

    if FOldWndProc <> nil then
    begin
      SetWindowLong((Owner as TForm).Handle, GWL_WNDPROC, LongInt(FOldWndProc));
      FOldWndProc := nil;
    end;

    FDestroyed := True;
  end;
  end;
end;
function LimitText(Canvas: TCanvas; const Text: AnsiString; MaxWidth: Integer; SetPointsAfterText: Boolean = True): AnsiString;
var
  l, r, i, w:   Integer;
begin
  result := Text;

  if Canvas.TextWidth(result) < MaxWidth then
    Exit;

  if not SetPointsAfterText then
    result := ReverseString(result);

  l := 0;
  r := Length(Text) - 1;

  repeat
    i := (l + r) div 2;

    result := LeftStr(Text, i) + '...';
    w := Canvas.TextWidth(result);

    if w < MaxWidth then
      l := i + 1
    else if w > MaxWidth then
      r := i - 1
    else
      Exit;

    if l >= r then
      Exit;
  until False;

  if not SetPointsAfterText then
    result := ReverseString(result);
end;
procedure FillAlphaRect(Canvas: TCanvas; Rect, ClipRect: TRect; Color: TColor; Alpha: Integer; TempBitmap: TBitmap = nil);
var
  Bitmap:     TBitmap;
  X, Y:       Integer;
  W, H:       Integer;
  PSrc:       PCardinal;
  V:          Cardinal;
  R1, G1, B1: Integer;
  R2, G2, B2: Integer;
  R3, G3, B3: Integer;
begin
  if Alpha >= 0 then
    if Rect.Left <= ClipRect.Right then
      if Rect.Right >= ClipRect.Left then
        if Rect.Top <= ClipRect.Bottom then
          if Rect.Bottom >= ClipRect.Top then
          begin
            if Rect.Left < ClipRect.Left then
              Rect.Left := ClipRect.Left;
            if Rect.Top < ClipRect.Top then
              Rect.Top := ClipRect.Top;
            if Rect.Right > ClipRect.Right then
              Rect.Right := ClipRect.Right;
            if Rect.Bottom > ClipRect.Bottom then
              Rect.Bottom := ClipRect.Bottom;

            W := Rect.Right - Rect.Left;
            H := Rect.Bottom - Rect.Top;

            if W > 0 then
              if H > 0 then
              begin
                if Alpha >= 255 then
                begin
                  Canvas.Brush.Style := bsSolid;
                  Canvas.Brush.Color := Color;
                  Canvas.FillRect(Rect);
                end
                else
                begin
                  if TempBitmap <> nil then
                    Bitmap := TempBitmap
                  else
                    Bitmap := TBitmap.Create;

                  if Bitmap.PixelFormat <> pf32bit then
                    Bitmap.PixelFormat := pf32bit;
                  if W > Bitmap.Width then
                    Bitmap.Width := W;
                  if H > Bitmap.Height then
                    Bitmap.Height := H;

                  Bitmap.Canvas.CopyRect(Classes.Rect(0, 0, W, H), Canvas, Rect);

                  R2 := (Color shr 16) and $FF;
                  G2 := (Color shr 8) and $FF;
                  B2 := Color and $FF;

                  dec(W);
                  dec(H);

                  for Y := 0 to H do
                  begin
                    PSrc := Bitmap.ScanLine[Y];

                    for X := 0 to W do
                    begin
                      V := PSrc^;
                      R1 := V and $FF;
                      B1 := (V shr 16) and $FF;
                      G1 := (V shr 8) and $FF;

                      R3 := R1 + (R2 - R1) * Alpha div 255;
                      B3 := B1 + (B2 - B1) * Alpha div 255;
                      G3 := G1 + (G2 - G1) * Alpha div 255;

                      PSrc^ := (B3 shl 16) or (G3 shl 8) or R3;

                      inc(PSrc);
                    end;
                  end;

                  Canvas.CopyRect(Rect, Bitmap.Canvas, Classes.Rect(0, 0, W, H));

                  if TempBitmap = nil then
                    Bitmap.Free;
                end;
              end;
          end;
end;

procedure ShadedRect(Canvas: TCanvas; Rect, ClipRect: TRect; ColorFrom, ColorTo: TColor; Direction: TGradientDirection);
var
  R1, G1, B1: Integer;
  R2, G2, B2: Integer;
  R3, G3, B3: Integer;
  X, Y, W, H: Integer;
begin
  if Rect.Left <= ClipRect.Right then
    if Rect.Right >= ClipRect.Left then
      if Rect.Top <= ClipRect.Bottom then
        if Rect.Bottom >= ClipRect.Top then
        begin
          if Rect.Left < ClipRect.Left then
            Rect.Left := ClipRect.Left;
          if Rect.Top < ClipRect.Top then
            Rect.Top := ClipRect.Top;
          if Rect.Right > ClipRect.Right then
            Rect.Right := ClipRect.Right;
          if Rect.Bottom > ClipRect.Bottom then
            Rect.Bottom := ClipRect.Bottom;

          W := Rect.Right - Rect.Left;
          H := Rect.Bottom - Rect.Top;

          if W > 0 then
            if H > 0 then
            begin
              ColorFrom := ColorToRGB(ColorFrom);
              ColorTo := ColorToRGB(ColorTo);

              R1 := (ColorFrom shr 16) and $FF;
              G1 := (ColorFrom shr 8) and $FF;
              B1 := ColorFrom and $FF;

              R2 := (ColorTo shr 16) and $FF;
              G2 := (ColorTo shr 8) and $FF;
              B2 := ColorTo and $FF;


              if Direction = gdVertical then
                for Y := 0 to H do
                begin
                  R3 := R1 + (R2 - R1) * Y div H;
                  B3 := B1 + (B2 - B1) * Y div H;
                  G3 := G1 + (G2 - G1) * Y div H;

                  Canvas.Brush.Color := (B3 shl 16) or (G3 shl 8) or R3;
                  Canvas.FillRect(Classes.Rect(Rect.Left, Rect.Top + Y, Rect.Right, Rect.Top + Y + 1));
                end
              else
                for X := 0 to W do
                begin
                  R3 := R1 + (R2 - R1) * X div W;
                  B3 := B1 + (B2 - B1) * X div W;
                  G3 := G1 + (G2 - G1) * X div W;

                  Canvas.Brush.Color := (B3 shl 16) or (G3 shl 8) or R3;
                  Canvas.FillRect(Classes.Rect(Rect.Left + X, Rect.Top, Rect.Left + X + 1, Rect.Bottom));
                end;
            end;
        end;
end;

procedure DrawText(Canvas: TCanvas; Rect, ClipRect: PRect; Text: AnsiString; Font: TFont; HAlign: TAlignment = taLeftJustify; VAlign: TTextLayout = tlTop);
var
  bkMode:       Integer;
  x, y:         Integer;
  options:      Integer;
begin
  if ClipRect <> nil then
    options := ETO_CLIPPED
  else
    options := 0;

  case HAlign of
  taCenter: x := Rect.Left + (Rect.Right - Rect.Left - Canvas.TextWidth(Text)) div 2;
  taRightJustify: x := Rect.Right - Canvas.TextWidth(Text);
  else
    x := Rect.Left;
  end;
  case VAlign of
  tlCenter: y := Rect.Top + (Rect.Bottom - Rect.Top - Canvas.TextHeight(Text)) div 2;
  tlBottom: y := Rect.Bottom - Canvas.TextHeight(Text);
  else
    y := Rect.Top;
  end;

  bkMode := GetBkMode(Canvas.Handle);
  SetBkMode(Canvas.Handle, TRANSPARENT);

  SelectObject(Canvas.Handle, Font.Handle);

  SetTextColor(Canvas.Handle, Font.Color);
  ExtTextOut(Canvas.Handle, x, y, options, ClipRect, PAnsiChar(Text), Length(Text), nil);

  SetBkMode(Canvas.Handle, bkMode);
end;

procedure DrawText(Canvas: TCanvas; Rect: PRect; Text: AnsiString; Font: TFont; HAlign: TAlignment = taLeftJustify; VAlign: TTextLayout = tlTop);
begin
  DrawText(Canvas, Rect, nil, Text, Font, HAlign, VAlign);
end;

procedure DrawText(Canvas: TCanvas; X, Y: Integer; Text: AnsiString; Font: TFont);
var
  Rect:   TRect;
begin
  Rect.Left := X;
  Rect.Top := Y;
  Rect.Right := 0;
  Rect.Bottom := 0;

  DrawText(Canvas, @Rect, nil, Text, Font, taLeftJustify, tlTop);
end;

procedure TextRotated(Canvas: TCanvas; ClipRect: TRect; Rotation, X, Y: Integer; Text: AnsiString; Font: TFont);
var
  lfont:    LOGFONT;
  nfont:    HFONT;
  bkMode:   Integer;
Begin
  GetObject(Font.Handle, sizeof(lfont), @lfont);
  lfont.lfEscapement := 10 * Rotation;
  lfont.lfOrientation := lfont.lfEscapement;
  lfont.lfQuality := ANTIALIASED_QUALITY;

  nfont := CreateFontIndirect(lfont);

  bkMode := GetBkMode(Canvas.Handle);
  SetBkMode(Canvas.Handle, TRANSPARENT);

  SelectObject(Canvas.Handle, nfont);

  SetTextColor(Canvas.Handle, Font.Color);
  ExtTextOut(Canvas.Handle, X, Y, ETO_CLIPPED, @ClipRect, PAnsiChar(Text), Length(Text), nil);

  SetBkMode(Canvas.Handle, bkMode);

  DeleteObject(nfont);
end;
var
  __ConsoleInputHandle:     Cardinal = 0;
  __ConsoleOutputHandle:    Cardinal = 0;
  __ConsoleTitle:           WideString;

procedure PrintConsole(const Text: AnsiString);
var
  written:    Cardinal;
  WText:      WideString;
begin
  if __ConsoleOutputHandle = 0 then
  begin
    if not AllocConsole then
      Exit;

    __ConsoleInputHandle := GetStdHandle(STD_INPUT_HANDLE);
    __ConsoleOutputHandle := GetStdHandle(STD_OUTPUT_HANDLE);

    if not SetConsoleTitleW(PWideChar(__ConsoleTitle)) then
    begin
      FreeConsole;
      Exit;
    end;

		SetConsoleMode(__ConsoleInputHandle, ENABLE_ECHO_INPUT);
  end;

  WText := Text;
  Windows.WriteConsoleW(__ConsoleOutputHandle, PWideChar(WText), Length(WText), written, nil);
end;

procedure PrintLine(const Text: AnsiString = '');
begin
  PrintConsole(Text + #13#10);
end;

function InputConsole(const Text: AnsiString = ''): AnsiString;
var
  WResult:    WideString;
  readed:     Cardinal;
begin
  PrintConsole(Text);

  SetLength(WResult, 512);
  if ReadConsoleW(__ConsoleInputHandle, PWideChar(WResult), 256, readed, nil) then
  begin
    WResult[readed + 1] := #0;
    result := WResult;
  end
  else
    result := '';
end;

procedure CloseConsole;
begin
  if __ConsoleOutputHandle <> 0 then
  begin
    FreeConsole;

    __ConsoleInputHandle := 0;
    __ConsoleOutputHandle := 0;
  end;
end;

procedure ConsoleTitle(const Title: AnsiString);
begin
  __ConsoleTitle := Title;
  SetConsoleTitleW(PWideChar(__ConsoleTitle));
end;

function ConsoleWaitKey: Char;
var
  mode:     Cardinal;
  readed:   Cardinal;
begin
  if __ConsoleInputHandle <> 0 then
  begin
    GetConsoleMode(__ConsoleInputHandle, mode);
    SetConsoleMode(__ConsoleInputHandle, 0);

    ReadConsoleA(__ConsoleInputHandle, @result, 1, readed, nil);

    SetConsoleMode(__ConsoleInputHandle, mode);
  end
  else
    result := #0;
end;

procedure BPrint(const Text: AnsiString = '');
begin
  PrintLine(Text);
end;

function ActiveHWND: Integer;
begin
  if Screen.ActiveForm <> nil then
    result := Screen.ActiveForm.Handle
  else
    result := GetDesktopWindow;
end;

var
  __MessageBoxTitle:        WideString;

procedure MsgBoxTitle(const Title: AnsiString);
begin
  __MessageBoxTitle := Title;
end;

function MsgBox(const Text: AnsiString; Flags: Cardinal; const Title: AnsiString = ''): Integer;
var
  WText:    WideString;
  WCaption: WideString;
begin
  WText := Text;
  if Title <> '' then
    WCaption := Title
  else
    WCaption := __MessageBoxTitle;

  Screen.Cursor := crDefault;

  result := MessageBoxW(ActiveHWND, PWideChar(WText), PWideChar(WCaption), Flags);
end;

procedure InfoMsg(const Text: AnsiString; const Title: AnsiString = '');
begin
  MsgBox(Text, MB_OK or MB_ICONINFORMATION, Title);
end;

procedure WarningMsg(const Text: AnsiString; const Title: AnsiString = '');
begin
  MsgBox(Text, MB_OK or MB_ICONWARNING, Title);
end;

procedure ErrorMsg(const Text: AnsiString; const Title: AnsiString = '');
begin
  MsgBox(Text, MB_OK or MB_ICONERROR, Title);
end;

procedure HandMsg(const Text: AnsiString; const Title: AnsiString = '');
begin
  MsgBox(Text, MB_OK or MB_ICONHAND, Title);
end;
procedure GetFontNames(FontList: TStrings);
var
  TempList: TTXStringList;
  LogFont:  TLogFont;
  DC:       HDC;
  i, c:     Integer;

  function EnumSize(var LogFont: TLogFont; var TextMetric: TTextMetric; FontType: Integer; Data: LParam): Integer; stdcall;
  begin
    try
      TTXStringList(Data).Add(LogFont.lfFaceName);
    except
    end;

    result := 1;
  end;
begin
  TempList := TTXStringList.Create;
  TempList.SearchMethod := smHash;
  TempList.Hashsize := 16;
  TempList.Duplicates := False;
  TempList.CaseSensitive := False;
  TempList.Trimmed := True;
  TempList.Umlaut := True;

  DC := GetDC(0);

  try
    FontList.Clear;

    LogFont.lfCharSet := DEFAULT_CHARSET;
    LogFont.lfFaceName := '';
    LogFont.lfPitchAndFamily := 0;

    EnumFontFamiliesEx(DC, LogFont, @EnumSize, Integer(TempList), 0);

    TempList.Sort;

    c := TempList.Count - 1;
    for i := 0 to c do
      FontList.Add(TempList.Strings[i]);
  finally
    ReleaseDC(0, DC);

    TempList.Free;
  end;
end;
function BrowseForFolderHook(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer; stdcall;
begin
  if uMsg = BFFM_INITIALIZED then
    SendMessageW(Wnd, BFFM_SETSELECTIONW, 1, lpData);

  result := 0;
end;

function RequestDir(const Caption, Root: AnsiString): AnsiString;
var
  WCaption:   WideString;
  WRoot:      WideString;
  pMalloc:    IMalloc;
  bi:         BROWSEINFOW;
  iilBrowse:  PItemIDList;
  resbuf:     array[0..1023] of WideChar;
begin
  result := '';

  WCaption := Caption;
  WRoot := Root;

  resbuf[0] := #0;

  SHGetMalloc(pMalloc);

  bi.hwndOwner := ActiveHWND;
  bi.pidlRoot := nil;
  bi.pszDisplayName := @resbuf[0];
  bi.lpszTitle := PWideChar(WCaption);
  bi.ulFlags := $40 or $1; // BIF_USENEWUI or BIF_RETURNONLYFSDIRS;

  if Root = '' then
  begin
    bi.lpfn := nil;
    bi.lParam := 0;
  end
  else
  begin
    bi.lpfn := BrowseForFolderHook;
    bi.lParam := Integer(PWideChar(WRoot));
  end;

  iilBrowse := SHBrowseForFolderW(bi);
  if iilBrowse <> nil then
    if SHGetPathFromIDListW(iilBrowse, resbuf) then
      result := PWideChar(@resbuf[0]);

  pMalloc.Free(iilBrowse);
end;
function GetSpecialFolder(SpecialFolder: TSpecialFolder): AnsiString;
var
  pMalloc:  IMalloc;
  pidl:     PItemIDList;
  Path:     PChar;
  Folder:   Integer;
begin
  if (SHGetMalloc(pMalloc) <> S_OK) then
    Exit;

  case SpecialFolder of
  sfPrograms: Folder := CSIDL_PROGRAMS;
  sfCommonPrograms: Folder := CSIDL_COMMON_PROGRAMS;
  sfDesktop: Folder := CSIDL_DESKTOPDIRECTORY;
  sfCommonDesktop: Folder := CSIDL_RECENT;
  sfRecent: Folder := CSIDL_PERSONAL;
  sfFavorites: Folder := CSIDL_FAVORITES;
  sfCommonFavorites: Folder := CSIDL_COMMON_FAVORITES;
  sfNetwork: Folder := CSIDL_NETHOOD;
  sfTemplates: Folder := CSIDL_TEMPLATES;
  else
    Folder := CSIDL_PERSONAL;
  end;

  SHGetSpecialFolderLocation(ActiveHWND, Folder, pidl);

  GetMem(Path, MAX_PATH);
  SHGetPathFromIDList(pidl, Path);
  result := Path;
  FreeMem(Path);

  pMalloc.Free(pidl);
end;
procedure Delay(Millisecs: Integer);
var
  Start:    Cardinal;
begin
  Start := GetTickCount;
  repeat
    Application.ProcessMessages;
    //Sleep(1);
  until GetTickCount - Start > Cardinal(Millisecs);
end;
procedure BlendBitmap(SrcBitmap1, SrcBitmap2, DestBitmap: TBitmap; Alpha: Integer);
var
  X, Y:         Integer;
  W, H:         Integer;
  PSrc1, PSrc2: PCardinal;
  PDest:        PCardinal;
  V:            Cardinal;
  R1, G1, B1:   Integer;
  R2, G2, B2:   Integer;
  R3, G3, B3:   Integer;
begin
  if SrcBitmap1.PixelFormat <> pf32bit then
    SrcBitmap1.PixelFormat := pf32bit;

  if SrcBitmap2.PixelFormat <> pf32bit then
    SrcBitmap2.PixelFormat := pf32bit;

  if DestBitmap.PixelFormat <> pf32bit then
    DestBitmap.PixelFormat := pf32bit;

  if SrcBitmap1.Width < SrcBitmap2.Width then
    W := SrcBitmap1.Width
  else
    W := SrcBitmap2.Width;
  if SrcBitmap1.Height < SrcBitmap2.Height then
    H := SrcBitmap1.Height
  else
    H := SrcBitmap2.Height;

  if DestBitmap.Width <> W then
    DestBitmap.Width := W;
  if DestBitmap.Height <> H then
    DestBitmap.Height := H;

  if Alpha <= 0 then
    DestBitmap.Canvas.Draw(0, 0, SrcBitmap1)
  else if Alpha >= 255 then
    DestBitmap.Canvas.Draw(0, 0, SrcBitmap2)
  else
  begin
    dec(W);
    dec(H);

    for Y := 0 to H do
    begin
      PSrc1 := SrcBitmap1.ScanLine[Y];
      PSrc2 := SrcBitmap2.ScanLine[Y];
      PDest := DestBitmap.ScanLine[Y];

      for X := 0 to W do
      begin
        V := PSrc1^;
        R1 := (V shr 16) and $FF;
        G1 := (V shr 8) and $FF;
        B1 := V and $FF;

        V := PSrc2^;
        R2 := (V shr 16) and $FF;
        G2 := (V shr 8) and $FF;
        B2 := V and $FF;

        R3 := R1 + (R2 - R1) * Alpha div 255;
        B3 := B1 + (B2 - B1) * Alpha div 255;
        G3 := G1 + (G2 - G1) * Alpha div 255;

        PDest^ := (R3 shl 16) or (G3 shl 8) or B3;

        inc(PSrc1);
        inc(PSrc2);
        inc(PDest);
      end;
    end;
  end;
end;

end.
