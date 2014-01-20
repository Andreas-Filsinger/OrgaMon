unit HeBuBase;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, globals,
  AddCursors, Menus, winamp,
  Volumes, binlager32, IniFiles,
  jpeg, Grids, WordIndex;

type
  TFormHeBuBase = class(TForm)
    Timer1: TTimer;
    ProgressBar1: TProgressBar;
    procedure FormPaint(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PlayThisSound;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Einmalig zu Erledigen }
    uMsgQueryCancelAutoPlay: uint;
    Initialized: Boolean;
    LoadDelay: Boolean;
    FilterEditor: Integer;

    { Private-Deklarationen }
    ActPicture: TBitMap; // Bild-Hintergrund
    MoveBackGround: TBitMap; // Bild-Hintergrund ohne das aktuelle Symbol!
    NotenPaper: TBitMap; // schönes Notenpapier!
    CdCover: TJpegImage; // CD-Cover
    CdCoverFName: string;
    CoverPosX: Integer;
    CoverPosY: Integer;
    Drag: Boolean; // wird im Moment "ge"-dragt?

    // Notenblatt
    NotenCache: TBitMap;
    NotenCacheEl: Integer;

    // Eingabe
    InputID: Integer;

    // MiniNoten!
    MiniNoten: array [1 .. MaxDesktopSymbols] of TBitMap;

    // Ablagen
    KorbID: Integer;
    NotizID: Integer;
    HilfeID: Integer;
    KorbAnz: Integer;
    NotizAnz: Integer;
    InterNetID: Integer;
    JubiID: Integer;
    TitelID: Integer;

    // LED
    LEDStatus: eLEDStatus;

    // Timer
    TimerTick: Integer;

    // Symbole
    Symbols: array [0 .. MaxSymbols] of tSymbolPosition;
    SymbolAnz: Integer;

    // Datensätze suchen
    MultipleWords: Integer; // Anzahl der unterschiedlichen Worte

    // "open" Files
    NotenF: file of tDataBaseRec;
    NotenAnz: Integer;

    // Filterknöpfe
    FilterID: Integer; // Desktop-ID des ersten Filters
    FilterSymbolOffset: Integer; // Start des ersten Filters
    // inerhalb des symbols[]-Arrays
    PreisStrings: TStringList;
    SchwierigkeitsgradStrings: TStringList;
    LandStrings: TStringList;
    MusicStrings: TStringList;
    NeuStrings: TStringList;
    RubrikStrings: TStringList;
    RubrikKuerzel: TStringList;

    FeldChecks: tCheckArray;
    PreisChecks: tCheckArray;
    SchwierigkeitsgradChecks: tCheckArray;
    LandChecks: tCheckArray;
    MusicChecks: tCheckArray;
    NeuChecks: tCheckArray;
    RubrikChecks: tCheckArray;

    // Info über aktive Filter
    OneFeldChecked: Boolean;
    OnePreisChecked: Boolean;
    OneSchwierigkeitsgradChecked: Boolean;
    OneLandChecked: Boolean;
    OneMusicChecked: Boolean;
    OneNeuChecked: Boolean;
    OneRubrikChecked: Boolean;

    SearchFullTextMode: Boolean;

    FilterTicker: Integer;
    FilterVictim: Integer;
    FilterRunning: Boolean; // Filter zur Zeit aktiv?
    cRFilter: TRect;

    // Filter-Targets
    MaximalPreis: single;
    MaximalSchwierigkeit: Integer;
    LaenderOK: string;
    SchwierigkeitsgradOK: string;
    MusicOK: array [1 .. MaxMedien] of Boolean;
    NeuDateOK: longint;
    RubrikOK: string;

    // desktop-Verwaltung +Maus
    SymbolPosData: TStringList;
    DesktopAnz: Integer; // Anzahl der Elemente auf dem Desktop

    InsideSymbol: Integer; // ID des Symbols, in dem sich die Maus befindet
    InsideStatus: eInsideArea; // Info, ob sich Maus im Drag-Bereich Befindet

    mOffsetx: Integer; // Abstand der Maus vom linken oberen Eck des Symbols
    mOffsety: Integer; //

    LastPopUpX, LastPopUpy: Integer;

    MinFontSize: Integer;

    // Notenblatt Inside-Bereiche
    NBI_Komponist: TRect;
    NBI_Titel: TRect;
    NBI_Arranger: TRect;
    NBI_verlag: TRect;

    // alles was mit Sound zu tun hat
    SoundState: eSoundState;
    ActVolume: Integer;
    VolumeMusikWay: array [0 .. 200] of TPoint;
    VolumeMusikWayCount: Integer;
    VolumeActPosition: Integer;
    SoundsToPlay: Integer;
    MMWaveDev: Integer;
    LastWasRunMusik: Boolean;

    // alles was mit der Trash-Can zu tun hat
    TrashFull: Boolean;
    TrashID: Integer;

    // String für die Großen Text-Angaben
    TxtLager: TBLager;
    ReallyBigStr: array [0 .. pred(MaxHugeText)] of char;

    TrefferShowRect: TRect;
    ProgressRect: TRect;
    EingabeRect: TRect;

    // Fenster beim Autostart in den Fordergrund bringen
    FirstRefreshed: Boolean;
    RefreshTick: dword;

    //
    VolumeControl1: TVolumeControl;

    procedure WMEraseBkgnd(var m: TWMEraseBkgnd); message WM_ERASEBKGND;

    procedure DrawLED(canvas: TCanvas; LEDStatus: eLEDStatus);
    procedure LoadSymbolPositions;
    procedure LoadDeskTop;
    procedure SaveDeskTop;
    procedure SaveSymbolINfo;
    procedure MarkSymbol(X, Y: Integer);
    procedure UnMarkSymbol;
    procedure DoFullTextSearch;
    procedure DoFilter;
    procedure DoEdit;
    procedure DoNotiz(Mode: byte);
    procedure SetDragOn;
    procedure GetNotenDirect(no: Integer);
    procedure NFirst;
    procedure NLast;
    procedure NNext;
    procedure NPrev;

    function PreisToString(const s: string): single;
    function StartingCharsUpper(const X: string): string;
    function KorbVoll: Boolean;
    function NotizVoll: Boolean;
    function DragArea(X, Y: Integer): Boolean;

    procedure SetDesktopTo(const FName: string);
    procedure RefreshDesktop;
    procedure OpenDataBase;
    procedure CloseDataBase;
    procedure AfterMouseUp;

    // Sound-Sachen
    procedure SetNewVolume(NewVolume: Integer);
    function MusikFName: string;

    function _Bemerkung: string;
    function _Komposition: string;
    function _UeberKomponist: string;
    function _UeberArranger: string;
    function _Preis: string;
    function GetTxtNo(no: Integer): string;

    procedure RunListenAnsicht;
    procedure RunMusikAnsicht;
    function FindArtikelNo(InpStr: string): Integer;

    { Public-Deklarationen }
    procedure WMChar(var Msg: TWMChar); message WM_char;

    // Mini-Noten Zeug
    function CreateMiniNote: Integer;
    procedure DeleteMiniNote(InsideSymbol: Integer);
    procedure MiniNotenBringToTop(no: Integer);
    function MiniNotenAnz: Integer;

    // Tracks / Serien
    procedure FillTrackInfo;

    function GetButtonNumber(X, Y: Integer; PreFixName: string): Integer;
    function GetFilterID(FilterType: Integer): Integer;

    procedure SwitchDesktop;

  protected
    procedure WndProc(var Message: TMessage); override;

  public
    ActFound: Integer;
    DesktopSymbols: tDeskTopSymbols; // Symbole selbst
    NotenID: Integer; // Desktop ID des Notenblattes
    SoundID: Integer;
    InpStr: string;
    FoundAnz: Integer; // Anzahl der gefundene Datensätze
    WrdIdx: TWordIndex;

    function MusikCount: Integer;
    procedure CreateWebExport;
    procedure DrawSymbol(canvas: TCanvas; no: Integer);
    procedure DrawBaseCount(canvas: TCanvas);
    procedure EvaluateFilter;
    procedure SetFeldFilterAutor;
    procedure DoSearch;
    procedure UnSetFeldFilterAutor;
    procedure StartWithDesktop(no: Integer);
    procedure UnInstallLinks;
    function LandKurz(LandLang: string): string;
    procedure ShowTitelInfo(X, Y: Integer);
    procedure SetDefaultCursor;

  end;

var
  FormHeBuBase: TFormHeBuBase;

implementation

uses
  splash, REMain, Hilfe,
  anfix32, ListenAnsicht,
  FilterDialog, MiniTexte, verlage,
{$IFDEF HeBuAdmin}
  Belege, Artikel,
{$ENDIF}
  Jubi, TrackAnsicht, math,
  NotenDaten, Name, WebExport,
  html, wanfix32, PasLibVlcUnit;

{$R *.DFM}
/// ///////////////////////////////////////////////////////////////////
// Tools
/// ///////////////////////////////////////////////////////////////////

function DesktopName: string;
begin
  result := 'Desktop' + inttostr(DesktopMode);
end;

/// ///////////////////////////////////////////////////////////////////

procedure TFormHeBuBase.RefreshDesktop;
begin
  NotenCacheEl := MaxInt; // invalidate cache
  InsideSymbol := 0; // invalidate State
  LoadDeskTop;
  // komische Zahlen hier (970, und 3382 oder so) imp pend!!!
  if (DesktopSymbols[NotenID].SymbolData > NotenAnz) then
    DesktopSymbols[NotenID].SymbolData := 1;
  SetDesktopTo(SystemPath + '\w' + MyResolutionStr + 'xDG' +
    inttostr(DesktopMode) + '.gif');
end;

function TFormHeBuBase.DragArea(X, Y: Integer): Boolean;
var
  mOffsetx, mOffsety: Integer;
begin
  with canvas, DesktopSymbols[InsideSymbol] do
  begin
    mOffsetx := X - SymbolRect.left;
    mOffsety := Y - SymbolRect.top;
    result := inside(mOffsetx, mOffsety, DragArea);
  end;
end;

function TFormHeBuBase.StartingCharsUpper(const X: string): string;
var
  OutStr: string;
  FirstChar: string;
  n: Integer;
begin
  OutStr := AnsiLowerCase(X);
  if (length(OutStr) > 0) then
  begin
    FirstChar := AnsiUpperCase(OutStr[1]);
    OutStr[1] := FirstChar[1];
    for n := 2 to length(OutStr) do
      if OutStr[n] = ' ' then
      begin
        if n + 1 <= length(OutStr) then
        begin
          FirstChar := AnsiUpperCase(OutStr[n + 1]);
          OutStr[n + 1] := FirstChar[1];
        end;
      end;
  end;
  result := OutStr;
end;

procedure TFormHeBuBase.LoadDeskTop;
var
  InF: file of tDesktopSymbol;
  TemplateName: string;
  RAblage: TRect;
  RNotenblatt: TRect;
  RInput: TRect;
  RHelp: TRect;
  RSound: TRect;
  RTrash: TRect;
  MiniNotenArtikelNo: TStringList;
  n, ActMiniNote: Integer;
begin
  // Drag-Bereiche
  RAblage := Rect(0, 0, 2000, 11);
  RNotenblatt := Rect(0, 0, 2000, 24);
  cRFilter := Rect(0, 0, 2000, 11);
  RInput := Rect(0, 0, 2000, 11);
  RHelp := Rect(0, 0, 2000, 11);
  RSound := Rect(0, 0, 2000, 11);
  RTrash := Rect(0, 0, 2000, 11);
  NotenPaper.LoadFromFile(SystemPath + '\Back' + inttostr(DesktopMode)
    + '.bmp');
  MiniNotenArtikelNo := TStringList.create;

  if FileExists(ProgramFilesDir + cCodeName + '\' + DesktopName + '.txt') then
    MiniNotenArtikelNo.LoadFromFile(ProgramFilesDir + cCodeName + '\' +
      DesktopName + '.txt');

  if MesseMode then
    if FileExists(SystemPath + '\DesktopMesse.ini') then
      FileCopy(SystemPath + '\DesktopMesse.ini', ProgramFilesDir + cCodeName +
        '\' + DesktopName + '.ini');

  assignFile(InF, ProgramFilesDir + cCodeName + '\' + DesktopName + '.ini');
{$I-}
  reset(InF);
{$I+}
  if (ioresult <> 0) then
  begin

    case screen.width of
      0 .. 799:
        TemplateName := SystemPath + '\d6x' + inttostr(DesktopMode) + '.ini';
      800 .. 1023:
        TemplateName := SystemPath + '\d8x' + inttostr(DesktopMode) + '.ini';
    else
      TemplateName := SystemPath + '\d10x' + inttostr(DesktopMode) + '.ini';
    end;

    if FileExists(TemplateName) then
    begin
      FileCopy(TemplateName, ProgramFilesDir + cCodeName + '\' + DesktopName
        + '.ini');
      LoadDeskTop;
      MiniNotenArtikelNo.free;
      exit;
    end;

    // aus eigener Kraft->alle Symbole (immer)!!!!
    // im Prinzip nur beim Programmieren möglich
    // case DesktopMode of
    // 0:begin

    // Ablage Notiz
    with DesktopSymbols[1] do
    begin
      SymbolRect := Rect(20, 270, 0, 0);
      DragArea := RAblage;
      SymbolType := SYM_NOTIZ;
    end;

    // Ablage Bestellung
    with DesktopSymbols[2] do
    begin
      SymbolRect := Rect(20, 320, 0, 0);
      DragArea := RAblage;
      SymbolType := SYM_KORB;
    end;

    // Notenblatt
    with DesktopSymbols[3] do
    begin
      SymbolRect := Rect(20, 20, 0, 0);
      DragArea := RNotenblatt;
      SymbolType := SYM_NOTENBLATT;
      SymbolData := 0; // erster Datensatz
    end;

    // Filter-Knöpfe
    with DesktopSymbols[4] do
    begin
      SymbolRect := Rect(20, 70, 0, 0);
      DragArea := cRFilter;
      SymbolType := SYM_FILTERBUTTON;
      SymbolData := FILTER_FELDER;
    end;

    with DesktopSymbols[5] do
    begin
      SymbolRect := Rect(20, 90, 0, 0);
      DragArea := cRFilter;
      SymbolType := SYM_FILTERBUTTON;
      SymbolData := FILTER_LAND;
    end;

    with DesktopSymbols[6] do
    begin
      SymbolRect := Rect(20, 110, 0, 0);
      DragArea := cRFilter;
      SymbolType := SYM_FILTERBUTTON;
      SymbolData := FILTER_SCHWER;
    end;

    with DesktopSymbols[7] do
    begin
      SymbolRect := Rect(20, 130, 0, 0);
      DragArea := cRFilter;
      SymbolType := SYM_FILTERBUTTON;
      SymbolData := FILTER_PREIS;
    end;

    with DesktopSymbols[8] do
    begin
      SymbolRect := Rect(20, 150, 0, 0);
      DragArea := cRFilter;
      SymbolType := SYM_FILTERBUTTON;
      SymbolData := FILTER_MUSIC;
    end;

    with DesktopSymbols[9] do
    begin
      SymbolRect := Rect(20, 170, 0, 0);
      DragArea := cRFilter;
      SymbolType := SYM_FILTERBUTTON;
      SymbolData := FILTER_NEU;
    end;

    with DesktopSymbols[10] do
    begin
      SymbolRect := Rect(20, 190, 0, 0);
      DragArea := cRFilter;
      SymbolType := SYM_FILTERBUTTON;
      SymbolData := FILTER_RUBRIK;
    end;

    // Eingabe Symbol!!
    with DesktopSymbols[11] do
    begin
      SymbolRect := Rect(20, 220, 0, 0);
      DragArea := RInput;
      SymbolType := SYM_INPUT;
    end;

    // Hilfe Knopf
    with DesktopSymbols[12] do
    begin
      SymbolRect := Rect(20, 350, 0, 0);
      DragArea := RHelp;
      SymbolType := SYM_HILFE;
    end;

    // Obermayer / HEBU Knopf
    with DesktopSymbols[13] do
    begin
      SymbolRect := TrefferShowRect;
      DragArea := Rect(0, 0, -1, -1); // kein Drag möglich !!
      SymbolType := SYM_SWITCH;
    end;

    // Sound-Knopf
    with DesktopSymbols[14] do
    begin
      SymbolRect := Rect(20, 380, 0, 0);
      DragArea := RSound;
      SymbolType := SYM_SOUND;
    end;

    // Müll-Eimer
    with DesktopSymbols[15] do
    begin
      SymbolRect := Rect(20, 400, 0, 0);
      DragArea := RTrash;
      SymbolType := SYM_TRASH;
    end;

    // JUBI
    with DesktopSymbols[16] do
    begin
      SymbolRect := Rect(20, 20, 0, 0);
      DragArea := cRFilter;
      SymbolType := SYM_JUBI;
    end;

    // INTERNET
    with DesktopSymbols[17] do
    begin
      SymbolRect := Rect(50, 20, 0, 0);
      DragArea := cRFilter;
      SymbolType := SYM_INTERNET;
    end;

    // TITEL
    with DesktopSymbols[18] do
    begin
      SymbolRect := Rect(80, 20, 0, 0);
      DragArea := cRFilter;
      SymbolType := SYM_TITEL;
    end;

    DesktopAnz := 18;

    SaveDeskTop;
    LoadDeskTop;
  end
  else
  begin

    DesktopAnz := 0;
    ActMiniNote := 0;

    // Mini-Noten alle freigeben
    for n := 1 to MaxDesktopSymbols do
      if assigned(MiniNoten[n]) then
      begin
        MiniNoten[n].free;
        MiniNoten[n] := nil;
      end;

    // Ini-File neu lesen
    while not(eof(InF)) do
    begin
      inc(DesktopAnz);
      read(InF, DesktopSymbols[DesktopAnz]);
      case DesktopSymbols[DesktopAnz].SymbolType of
        SYM_SWITCH:
          DesktopSymbols[DesktopAnz].SymbolRect.right := 10 + (222 - 92) +
            (314 - 174) + 10;
        SYM_SOUND:
          SoundID := DesktopAnz;
        SYM_INPUT:
          InputID := DesktopAnz;
        SYM_NOTENBLATT:
          begin
            if (DesktopSymbols[DesktopAnz].SymbolData >= NotenAnz) then
              DesktopSymbols[DesktopAnz].SymbolData := 0;
            NotenID := DesktopAnz;
          end;
        SYM_KORB:
          KorbID := DesktopAnz;
        SYM_TRASH:
          TrashID := DesktopAnz;
        SYM_INTERNET:
          InterNetID := DesktopAnz;
        SYM_JUBI:
          JubiID := DesktopAnz;
        SYM_TITEL:
          TitelID := DesktopAnz;
        SYM_NOTIZ:
          begin
            NotizID := DesktopAnz;
            ListenAnsichtForm.top := DesktopSymbols[DesktopAnz].SymbolRect.top;
            ListenAnsichtForm.left := DesktopSymbols[DesktopAnz]
              .SymbolRect.left;
          end;
        SYM_HILFE:
          HilfeID := DesktopAnz;
        SYM_MININOTEN:
          begin
            DesktopSymbols[DesktopAnz].SymbolOffset := 0;
            if (MiniNotenArtikelNo.count > 0) then
            begin
              DesktopSymbols[DesktopAnz].SymbolData :=
                FindArtikelNo(MiniNotenArtikelNo[ActMiniNote]);
              inc(ActMiniNote);
            end;
          end;
        SYM_FILTERBUTTON:
          begin
            DesktopSymbols[DesktopAnz].SymbolOffset := 0;
            if (FilterID = 0) then
              FilterID := DesktopAnz; // erster Filter
          end;
      end;
    end;
    closeFile(InF);
  end;
  MiniNotenArtikelNo.free;
  FileDelete(ProgramFilesDir + cCodeName + '\' + DesktopName + '.txt');
end;

procedure TFormHeBuBase.SaveSymbolINfo;
var
  n: Integer;
  OutS: TStringList;
begin
  OutS := TStringList.create;
  for n := 1 to DesktopAnz do
  begin
    if (DesktopSymbols[n].SymbolType = SYM_MININOTEN) then
    begin
      GetNotenDirect(DesktopSymbols[n].SymbolData);
      OutS.Add(noten.ArtikelNo);
    end;
  end;
  OutS.SaveToFile(ProgramFilesDir + cCodeName + '\' + DesktopName + '.txt');
  OutS.free;
end;

procedure TFormHeBuBase.SaveDeskTop;
var
  InF: file of tDesktopSymbol;
  n: Integer;
begin
  assignFile(InF, ProgramFilesDir + cCodeName + '\' + DesktopName + '.ini');
  rewrite(InF);
  for n := 1 to DesktopAnz do
  begin

    if (DesktopMode = 0) then
      if DesktopSymbols[n].SymbolType = SYM_FILTERBUTTON then
        if DesktopSymbols[n].SymbolData = FILTER_RUBRIK then
          continue;

    if (DesktopMode = 1) then
      if DesktopSymbols[n].SymbolType = SYM_FILTERBUTTON then
        if DesktopSymbols[n].SymbolData = FILTER_SCHWER then
          continue;

    // alle filter weg
    if MesseMode then
    begin
      if DesktopSymbols[n].SymbolType = SYM_FILTERBUTTON then
        continue;
      if DesktopSymbols[n].SymbolType = SYM_NOTIZ then
        continue;
      if DesktopSymbols[n].SymbolType = SYM_KORB then
        continue;
      if DesktopSymbols[n].SymbolType = SYM_HILFE then
        continue;
      if DesktopSymbols[n].SymbolType = SYM_TRASH then
        continue;
      if DesktopSymbols[n].SymbolType = SYM_INTERNET then
        continue;
      if DesktopSymbols[n].SymbolType = SYM_JUBI then
        continue;
      if DesktopSymbols[n].SymbolType = SYM_TITEL then
        continue;
      if DesktopSymbols[n].SymbolType = SYM_RUBRIK then
        continue;
      if DesktopSymbols[n].SymbolType = SYM_SWITCH then
        continue;
    end;

    write(InF, DesktopSymbols[n]);
  end;
  closeFile(InF);
end;

procedure TFormHeBuBase.LoadSymbolPositions;
var
  InpStr: string;
  SymbolNames: TStringList;
  MyIni: TIniFile;
  n: Integer;

  function NextP(Delimiter: char): string;
  var
    k: Integer;
  begin
    k := pos(Delimiter, InpStr);
    if k = 0 then
    begin
      result := InpStr;
      InpStr := '';
    end
    else
    begin
      result := copy(InpStr, 1, pred(k));
      InpStr := copy(InpStr, succ(k), MaxInt);
    end;
  end;

  function GetIDof(const s: string): Word;
  begin
    result := succ(SymbolNames.Indexof(s));
  end;

  function GetRect(const Name: string): TRect;
  var
    ResStr: string;
  begin
    ResStr := SymbolPosData.values[Name];
    result := Str2Rect(copy(ResStr, succ(pos('=', ResStr)), MaxInt));
  end;

begin
  SymbolNames := TStringList.create;
  MyIni := TIniFile.create(SystemPath + '\' + cSymbolMetrixFName);
  SymbolAnz := 0;

  // für das CD Cover
  MyIni.ReadSectionValues('back1.bmp', SymbolPosData);
  CoverPosX := GetRect('Cover').left;
  CoverPosY := GetRect('Cover').top;

  // Sub-Positionen der Eingabe
  MyIni.ReadSectionValues('sym' + LanguageDriver + '.bmp', SymbolPosData);
  EingabeRect := GetRect('Eingabe');
  MaxInpPixelwidth := rXl(GetRect('i0'));
  INPUTPixelPosX := GetRect('i0').left - EingabeRect.left;
  INPUTPixelPosY := GetRect('i0').top - EingabeRect.top;
  INPUTCountPosX := GetRect('i1').left - EingabeRect.left;
  INPUTCountPosY := GetRect('i1').top - EingabeRect.top;
  LEDPixelPosX := GetRect('i2').left - EingabeRect.left;
  LEDPixelPosY := GetRect('i2').top - EingabeRect.top;
  ProgressRect := GetRect('i1');
  TrefferShowRect := GetRect('HeBu');
  rmoveto(TrefferShowRect, 10, 0);

  MyIni.free;

  for n := 0 to pred(SymbolPosData.count) do
  begin

    InpStr := SymbolPosData[n];

    if (InpStr = '') then
      continue;
    if (pos('[', InpStr) = 1) then
      continue;
    if (pos(' ', InpStr) = 1) then
      continue;

    // if SymbolAnz=MaxSymbols
    inc(SymbolAnz);
    with Symbols[SymbolAnz] do
    begin
      SymbolName := NextP('=');
      SymbolNames.Add(SymbolName);
      with Spos do
      begin
        left := Strtoint(NextP(','));
        top := Strtoint(NextP(','));
        right := left + Strtoint(NextP(','));
        bottom := top + Strtoint(NextP(','));
      end;
      with OwnSize do
      begin
        left := 0;
        top := 0;
        right := Spos.right - Spos.left;
        bottom := Spos.bottom - Spos.top;
      end;
    end;
  end;

  cSym_Notiz_leer := GetIDof('Notiz leer');
  cSym_Notiz_belegt := GetIDof('Notiz belegt');
  cSym_Bestell_leer := GetIDof('Bestell leer');
  cSym_Bestell_belegt := GetIDof('Bestell belegt');
  cSym_Eingabe := GetIDof('Eingabe');
  cSym_sound_disabled := GetIDof('sound disabled');
  cSym_Sound_play := GetIDof('Sound play');
  cSym_Sound_volume := GetIDof('Sound volume');
  cSym_rSound_weel := GetIDof('#Sound weel');
  cSym_hilfe := GetIDof('hilfe');
  cSym_Mulleimer_leer := GetIDof('Mülleimer leer');
  cSym_Mulleimer_belegt := GetIDof('Mülleimer belegt');

  // Filter
  cSym_neu := GetIDof('neu');
  cSym_preis := GetIDof('preis');
  cSym_schwer := GetIDof('schwer');
  cSym_land := GetIDof('land');
  cSym_musik := GetIDof('musik');
  cSym_feld := GetIDof('feld');
  cSym_Rubrik := GetIDof('rubrik');

  cSym_HeBu := GetIDof('HeBu');
  cSym_Obermayer := GetIDof('Amos');
  cSym_rdunkelrot := GetIDof('#dunkelrot');
  cSym_rrot := GetIDof('#rot');
  cSym_rgrun := GetIDof('#grün');
  cSym_rdunkelgrun := GetIDof('#dunkelgrün');
  cSym_rLED_grun := GetIDof('#LED grün');
  cSym_rLED_gelb := GetIDof('#LED gelb');
  cSym_rLED_rot := GetIDof('#LED rot');
  cSym_rLED_grau := GetIDof('#LED grau');
  cSym_InterNet := GetIDof('InterNet');
  cSym_Jubi := GetIDof('Jubiläum');
  cSym_Titel := GetIDof('Titel');

  SymbolNames.free;

end;

// Form-methoden

procedure TFormHeBuBase.WMEraseBkgnd(var m: TWMEraseBkgnd);
begin
  if not(LoadDelay) then
  begin
    with canvas do
    begin
      brush.Color := clblue;
      fillrect(ClientRect);
      brush.style := bsDiagCross;
      brush.Color := clwhite;
      font.Name := 'Arial';
      font.Size := 16;
      font.Color := clwhite;
      font.style := [fsbold];
      TextOut(10, 10, LanguageSTr[pred(29)]);
    end;
    LoadDelay := true;
  end;
  m.result := LRESULT(false);
end;

procedure TFormHeBuBase.DrawSymbol(canvas: TCanvas; no: Integer);
var
  r: TRect;
  n: Integer;
  t1, t2: string;
  ty: Integer;
  X, Y: Integer;
  PlaneBMP: TBitMap;
  tw1, tw2, t1Size, t2Size: Integer;
  _SymbolData: Integer;
  _noten: tDataBaseRec;
  ActSymbolId: Integer;
  BigInfo: string;
  BigInfo2: string;

  // Routinen für Notenblatt-Textausgabe

  function CalculateFontSize(canvas: TCanvas; const X: string;
    MaxFontSize: Integer): Integer;
  var
    n: Integer;
    tw: Integer;
  begin
    with canvas do
    begin
      for n := succ(MinFontSize) to MaxFontSize do
      begin
        font.Size := n;
        tw := Textwidth(X);
        if tw > (cNotenBlattXL - 10) then
          break;
      end;
      result := pred(n);
    end;
  end;

  function SimpleTextOut(canvas: TCanvas; X: Boolean; MyStr: string;
    MyFormat: char; MaxFontSize: Integer): Integer;
  var
    tw: Integer;
    TodayStr: string;
    TodayWidth: Integer;
    SubStr: string;
    _SubStr: string;
    _TodayStr: string;
    k: Integer;
  begin
    if MyStr = '' then
      MyStr := '-';

    with canvas do
    begin

      case MyFormat of
        'l':
          begin // linksbündig, Größe lassen, immer einzeilig
            TextOut(0 + 5, ty, MyStr);
            inc(ty, Textheight(MyStr));
          end;
        'L':
          begin // linksbündig, Größe lassen, immer einzeilig

            if Textwidth(MyStr) > cNotenBlattXL - 50 then
            begin
              while Textwidth(MyStr) > cNotenBlattXL - 80 do
                delete(MyStr, length(MyStr), 1);
              MyStr := MyStr + '...';
            end;

            TextOut(0 + 5, ty, MyStr);
          end;
        'r':
          begin // rechtsbündig, Größe lassen, immer einzeilig
            tw := Textwidth(MyStr);
            TextOut(0 + cNotenBlattXL - tw - 5, ty, MyStr);
            inc(ty, Textheight(MyStr));
          end;
        'z':
          begin // zentriert, Größe lassen
            tw := Textwidth(MyStr);
            if tw <= cNotenBlattXL - 10 then
            begin
              TextOut(0 + ((cNotenBlattXL - tw) div 2), ty, MyStr);
              inc(ty, Textheight(MyStr));
            end
            else
            begin

              // uups, 2-zeilig Sub-Strings zentriert ausgeben
              font.Size := font.Size + 2;
              TodayStr := MyStr;
              while true do
              begin

                TodayWidth := Textwidth(TodayStr);
                if (TodayWidth > cNotenBlattXL - 10) then
                begin

                  // Split String until
                  SubStr := '';
                  _SubStr := TodayStr;
                  _TodayStr := '';
                  while true do
                  begin
                    k := pos(' ', TodayStr);
                    if k > 0 then
                    begin
                      SubStr := SubStr + copy(TodayStr, 1, k);
                      TodayStr := copy(TodayStr, succ(k), MaxInt);
                    end
                    else
                    begin
                      SubStr := SubStr + TodayStr;
                      TodayStr := '';
                    end;
                    if Textwidth(SubStr) > cNotenBlattXL - 10 then
                      break;
                    _SubStr := SubStr;
                    _TodayStr := TodayStr;
                    if TodayStr = '' then
                      break;
                  end;

                  tw := Textwidth(_SubStr);
                  if tw <= cNotenBlattXL - 10 then
                    SimpleTextOut(canvas, X, _SubStr, 'z', MaxFontSize);
                  TodayStr := _TodayStr;

                end
                else
                  break;
              end;

              SimpleTextOut(canvas, X, TodayStr, 'z', MaxFontSize);

            end;
          end;
        'Z':
          begin
            // zentriert, so groß wie es nur geht!
            // aber nicht größer als MaxFontSize!
            // und nicht kleiner als MinFontSize!
            // ggf. ist es mehrzeilig!
            font.Size := CalculateFontSize(canvas, MyStr, MaxFontSize);
            SimpleTextOut(canvas, X, MyStr, 'z', MaxFontSize);
          end;
      else
        ShowMessage('SimpleTextOut(' + MyFormat + ')?');
      end;
    end;
    result := font.Size;
  end;

  procedure TitelTextOutFixed(canvas: TCanvas; const titel: string;
    const Size: Integer);
  var
    k: Integer;
    t1, t2: string;
  begin
    with canvas do
    begin
      k := pos('(', titel);
      if (k = 0) then
      begin
        // einzeiliger Titel, ohne Klammer
        font.Size := Size;
        SimpleTextOut(canvas, true, titel, 'z', Size);
      end
      else
      begin

        // mehrzeiliger Titel
        t1 := cutblank(copy(titel, 1, pred(k)));
        t2 := cutblank(copy(titel, k, MaxInt));

        // Text in Klammer
        SimpleTextOut(canvas, true, t1, 'Z', Size);
        SimpleTextOut(canvas, true, t2, 'Z', pred(Size));
      end;
    end;
  end;

  procedure TitelTextOut(canvas: TCanvas; const titel: string);
  var
    t1, t2: string;
    k: Integer;
  begin
    k := pos('(', titel);
    if (k = 0) then
    begin
      // einzeiliger Titel, ohne Klammer
      SimpleTextOut(canvas, true, titel, 'Z', MaxFontSize);
    end
    else
    begin

      // mehrzeiliger Titel
      t1 := cutblank(copy(titel, 1, pred(k)));
      t2 := cutblank(copy(titel, k, MaxInt));

      // Titel
      k := CalculateFontSize(canvas, t1, MaxFontSize);
      TitelTextOutFixed(canvas, t1, k);

      // Text in Klammer
      SimpleTextOut(canvas, true, t2, 'Z', pred(k));
    end;
  end;

  function TitelTextGetSize(canvas: TCanvas; const titel: string;
    var tw: Integer): Integer;
  var
    t1: string;
    k: Integer;
  begin
    k := pos('(', titel);
    if (k = 0) then
    begin
      // einzeiliger Titel
      result := CalculateFontSize(canvas, titel, MaxFontSize);
    end
    else
    begin
      // mehrzeiliger Titel
      t1 := cutblank(copy(titel, 1, pred(k)));

      // Zeile 1
      result := CalculateFontSize(canvas, t1, MaxFontSize);
    end;
  end;

var
  k: Integer;

begin
  if (no = 0) or (no > MaxDesktopSymbols) then
    exit;
  with canvas, DesktopSymbols[no] do
  begin
    X := SymbolRect.left;
    Y := SymbolRect.top;
    case SymbolType of
      SYM_SWITCH:
        ;
      SYM_TRASH:
        begin
          if TrashFull then
            ActSymbolId := cSym_Mulleimer_belegt
          else
            ActSymbolId := cSym_Mulleimer_leer;

          // neue Größe eintragen
          SymbolRect := Rect(X, Y, pred(X + Symbols[ActSymbolId].sBitMap.width),
            pred(Y + Symbols[ActSymbolId].sBitMap.height));

          // Symbol zeichnen
          Draw(X, Y, Symbols[ActSymbolId].sBitMap);

        end;
      SYM_SOUND:
        begin

          if WinAmpPlaying then
          begin
            SoundState := SS_stop;
          end
          else
          begin
            if not(MesseMode) then
            begin
              if noten.SoundSource > 0 then
                SoundState := SS_play
              else
              begin
                if MusikCount = 0 then
                  SoundState := SS_disabled
                else
                  SoundState := SS_play;
              end;
            end
            else
            begin
              // Musik-Stücke suchen
              if (MusikCount = 0) then
                SoundState := SS_disabled
              else
                SoundState := SS_play;
            end;
          end;

          // Musik-Button zeichnen
          case SoundState of
            SS_disabled:
              n := cSym_sound_disabled;
            SS_play:
              n := cSym_Sound_play;
            SS_stop:
              n := cSym_Sound_volume;
          else
            n := -1;
          end;
          SymbolRect := Rect(X, Y, pred(X + Symbols[n].sBitMap.width),
            pred(Y + Symbols[n].sBitMap.height));
          Draw(X, Y, Symbols[n].sBitMap);

          // ev. noch Regler-Knopf zeichnen
          if not(MesseMode) then
            if (SoundState = SS_stop) then
            begin
              {
                Draw(x+VolumeReglerPixelPosX+VolumeMusikWay[VolumeActPosition].x,
                y+VolumeReglerPixelPosY+VolumeMusikWay[VolumeActPosition].y,
                Symbols[cSym_rSound_weel].BitMap);
              }

              brush.style := bssolid;
              brush.Color := clwhite;
              font.Name := 'Arial';
              font.Size := 8;
              font.Color := clred;
              font.style := [];
              TextOut(X + 5, Y + 13, format('%d', [SoundsToPlay]));
            end;
        end;
      SYM_HILFE:
        begin
          // neue Größe eintragen
          SymbolRect := Rect(X, Y, pred(X + Symbols[cSym_hilfe].sBitMap.width),
            pred(Y + Symbols[cSym_hilfe].sBitMap.height));
          Draw(X, Y, Symbols[cSym_hilfe].sBitMap);
        end;
      SYM_INTERNET:
        begin
          // neue Größe eintragen
          SymbolRect :=
            Rect(X, Y, pred(X + Symbols[cSym_InterNet].sBitMap.width),
            pred(Y + Symbols[cSym_InterNet].sBitMap.height));
          Draw(X, Y, Symbols[cSym_InterNet].sBitMap);
        end;
      SYM_JUBI:
        begin
          // neue Größe eintragen
          SymbolRect := Rect(X, Y, pred(X + Symbols[cSym_Jubi].sBitMap.width),
            pred(Y + Symbols[cSym_Jubi].sBitMap.height));
          Draw(X, Y, Symbols[cSym_Jubi].sBitMap);
        end;
      SYM_TITEL:
        begin
          // neue Größe eintragen
          SymbolRect := Rect(X, Y, pred(X + Symbols[cSym_Titel].sBitMap.width),
            pred(Y + Symbols[cSym_Titel].sBitMap.height));
          Draw(X, Y, Symbols[cSym_Titel].sBitMap);
        end;
      SYM_KORB:
        begin
          PlaneBMP := TBitMap.create;

          // neue Größe eintragen
          SymbolRect :=
            Rect(X, Y, pred(X + Symbols[cSym_Bestell_leer].sBitMap.width),
            pred(Y + Symbols[cSym_Bestell_leer].sBitMap.height));

          brush.style := bssolid;
          brush.Color := $00003333;
          CopyMode := cmPatPaint;
          SetBitMapSizeTo(PlaneBMP, screen.width - X, screen.height - Y);
          copyrect(Rect(X, Y, screen.width, screen.height), PlaneBMP.canvas,
            Rect(0, 0, PlaneBMP.width, PlaneBMP.height));
          CopyMode := cmsrccopy;
          brush.Color := clwhite;
          if not(Drag) then
            framerect(Rect(X, Y, screen.width, screen.height));

          PlaneBMP.free;

          if KorbVoll then
          begin
            Draw(X, Y, Symbols[cSym_Bestell_belegt].sBitMap);
            brush.style := bssolid;
            brush.Color := clwhite;
            font.Name := 'Arial';
            font.Size := 8;
            font.Color := clred;
            font.style := [];
            TextOut(X + 2, (Y + Symbols[cSym_Bestell_belegt].sBitMap.height) -
              (Textheight('X') + 3), format(' %d ', [KorbAnz]));
          end
          else
          begin
            Draw(X, Y, Symbols[cSym_Bestell_leer].sBitMap);
          end;

        end;
      SYM_NOTIZ:
        begin
          PlaneBMP := TBitMap.create;

          // neue Größe eintragen
          SymbolRect :=
            Rect(X, Y, pred(X + Symbols[cSym_Notiz_leer].sBitMap.width),
            pred(Y + Symbols[cSym_Notiz_leer].sBitMap.height));

          brush.style := bssolid;
          brush.Color := $00A7A7A7;
          CopyMode := cmPatPaint;
          SetBitMapSizeTo(PlaneBMP, screen.width - X,
            DesktopSymbols[KorbID].SymbolRect.top - Y);
          copyrect(Rect(X, Y, screen.width,
            DesktopSymbols[KorbID].SymbolRect.top), PlaneBMP.canvas,
            Rect(0, 0, PlaneBMP.width, PlaneBMP.height));
          CopyMode := cmsrccopy;
          brush.Color := clwhite;
          if not(Drag) then
            framerect(Rect(X, Y, screen.width,
              pred(DesktopSymbols[KorbID].SymbolRect.top)));

          PlaneBMP.free;

          if NotizVoll then
          begin
            Draw(X, Y, Symbols[cSym_Notiz_belegt].sBitMap);
            brush.style := bssolid;
            brush.Color := clwhite;
            font.Name := 'Arial';
            font.Size := 8;
            font.Color := clred;
            font.style := [];
            TextOut(X + 2, Y + 12, format(' %d ', [NotizAnz]));
          end
          else
          begin
            Draw(X, Y, Symbols[cSym_Notiz_leer].sBitMap);
          end;

        end;
      SYM_INPUT:
        begin
          // neue Größe eintragen
          SymbolRect :=
            Rect(X, Y, pred(X + Symbols[cSym_Eingabe].sBitMap.width),
            pred(Y + Symbols[cSym_Eingabe].sBitMap.height));

          // Symbol zeichnen
          Draw(X, Y, Symbols[cSym_Eingabe].sBitMap);

          // aktuelle LED zeichnen
          DrawLED(canvas, LEDStatus);
          DrawBaseCount(canvas);

          // Text zeichnen
          brush.style := bssolid;
          brush.Color := clwhite;

          font.Name := 'Arial';
          font.Size := 14;
          font.Color := clblack;
          font.style := [fsbold];
          while (Textwidth(InpStr + '_') > MaxInpPixelwidth) do
            delete(InpStr, length(InpStr), 1);
          TextOut(X + INPUTPixelPosX, Y + INPUTPixelPosY, InpStr + '_');

        end;
      SYM_MININOTEN:
        begin
          // Symbol erzeugen wenn noch nicht geschehen
          if SymbolOffset = 0 then
          begin
            _noten := noten;
            _SymbolData := DesktopSymbols[NotenID].SymbolData;

            DesktopSymbols[NotenID].SymbolData := SymbolData;
            SymbolOffset := CreateMiniNote;

            DesktopSymbols[NotenID].SymbolData := _SymbolData;
            noten := _noten;
          end;

          // neue Größe eintragen
          SymbolRect := Rect(X, Y, pred(X + MiniNoten[SymbolOffset].width),
            pred(Y + MiniNoten[SymbolOffset].height));

          // Symbol zeichnen
          Draw(X, Y, MiniNoten[SymbolOffset]);

        end;
      SYM_FILTERBUTTON:
        begin
          // ShowMessage('Filter '+inttostr(SymbolDATA));

          // Berechnen, welches Symbol gemeint ist
          _SymbolData := FilterSymbolOffset + SymbolData + SymbolOffset;

          // neue Größe eintragen
          with Symbols[_SymbolData].sBitMap do
            SymbolRect := Rect(X, Y, pred(X + width), pred(Y + height));

          // Symbol zeichnen
          Draw(X, Y, Symbols[_SymbolData].sBitMap);
        end;
      SYM_NOTENBLATT:
        begin

          // neue Größe eintragen
          SymbolRect := Rect(X, Y, X + cNotenBlattXL, Y + cNotenBlattYL);

          if (NotenCacheEl <> SymbolData) then
          begin

            // sorry, alles neu zeichnen
            GetNotenDirect(SymbolData);
            NotenCacheEl := SymbolData;

            with NotenCache.canvas do
            begin
              // alles solide
              brush.style := bssolid;

              r.left := 0;
              r.top := 0;
              r.right := cNotenBlattXL;
              r.bottom := cNotenBlattYL;

              copyrect(r, NotenPaper.canvas, Rect(0, 0, rXl(r), ryl(r)));

              NotenCache.TransParentColor := NotenPaper.canvas.Pixels[0, 0];

              if (DesktopMode = 1) then
              begin
                // Obermayer
                rZero(NBI_verlag);
                rZero(NBI_Komponist);
                rZero(NBI_Arranger);

                // Cover laden
                if (noten.Aufnahme <> '') then
                begin
                  CdCoverFName := SystemPath + '\..\Cover\' +
                    noten.Aufnahme + '.jpg';
                  if FileExists(CdCoverFName) then
                  begin
                    CdCover := TJpegImage.create;
                    CdCover.LoadFromFile(CdCoverFName);
                    Draw(CoverPosX, CoverPosY, CdCover);
                    CdCover.free;
                  end;
                end;

                // Schriftauswahl
                brush.style := bsDiagCross;
                brush.Color := clblack;
                font.Name := 'Arial';
                font.Color := clblack;
                font.style := [fsbold];
                font.Size := 9;

                // Artikel-Nummer
                ty := 11;
                SimpleTextOut(NotenCache.canvas, true, noten.ArtikelNo, 'r',
                  MaxFontSize);
                ty := 11;
                SimpleTextOut(NotenCache.canvas, true, noten.land, 'L',
                  MaxFontSize);
                ty := 29;
                NBI_Titel.top := ty;
                NBI_Titel.left := 0;
                font.Color := clblack;

                // T I T E L
                SimpleTextOut(NotenCache.canvas, true, noten.titel, 'Z',
                  MaxFontSize);

                NBI_Titel.right := cNotenBlattXL;
                NBI_Titel.bottom := ty;

                // unten
                font.Size := 8;
                ty := cNotenBlattYL - 20;
                SimpleTextOut(NotenCache.canvas, true, noten.dauer, 'r', 0);

                ty := cNotenBlattYL - 20;
                if noten.schwer <> '' then
                  SimpleTextOut(NotenCache.canvas, true,
                    format('%s (' + LanguageSTr[pred(148)] + ')',
                    [_Preis, noten.schwer]), 'l', 0)
                else
                  SimpleTextOut(NotenCache.canvas, true,
                    format('%s', [_Preis]), 'l', 0);

                // TRACKS
                ty := 4 * (cNotenBlattYL div 6);

                NBI_Komponist := Mkrect(0, ty, cNotenBlattXL,
                  cNotenBlattYL - ty);

                font.Name := 'Small Fonts';
                font.Size := 7;
                font.style := [];

                BigInfo := _UeberKomponist;
                BigInfo2 := _UeberArranger;
                n := 0;
                while (BigInfo <> '') do
                begin
                  inc(n);
                  SimpleTextOut(NotenCache.canvas, true,
                    { inttostrN(n,2)+' '+ } NextP(BigInfo, '|'), 'L',
                    MaxFontSize);
                  if (ty >= (cNotenBlattYL - 45)) then
                  begin
                    SimpleTextOut(NotenCache.canvas, true,
                      NextP(BigInfo2, '¦') + ' ' + LanguageSTr[pred(146)] + '»',
                      'r', MaxFontSize);
                    break;
                  end
                  else
                  begin
                    SimpleTextOut(NotenCache.canvas, true, NextP(BigInfo2, '¦'),
                      'r', MaxFontSize);
                  end;
                  NextP(BigInfo, '¦');
                end;

              end
              else
              begin
                // HeBu

                // Schriftauswahl
                brush.style := bsDiagCross;
                brush.Color := clblack;
                font.Name := 'Arial';
                font.Color := clblack;
                font.style := [fsbold];
                font.Size := 9;

                k := pos('/', noten.titel);

                // Artikel-Nummer
                ty := 11;
                if (k > 0) then
                begin
                  SimpleTextOut(NotenCache.canvas, true, noten.ArtikelNo, 'r',
                    MaxFontSize);
                  SimpleTextOut(NotenCache.canvas, true, LanguageSTr[pred(66)],
                    'r', MaxFontSize);
                end
                else
                begin
                  SimpleTextOut(NotenCache.canvas, true, noten.ArtikelNo, 'r',
                    MaxFontSize);
                end;

                // ... Komponist ...
                if (noten.UeberKomponist > 0) then
                  font.style := [fsbold, fsunderline]
                else
                  font.style := [fsbold];
                ty := 0 + (cNotenBlattYL div 4);
                NBI_Komponist.top := ty;
                NBI_Komponist.left := 0;
                SimpleTextOut(NotenCache.canvas, true, noten.komponist, 'z',
                  MaxFontSize);
                NBI_Komponist.right := cNotenBlattXL;
                NBI_Komponist.bottom := ty;

                NBI_Titel.top := ty;
                NBI_Titel.left := 0;

                font.style := [fsbold];

                // T I T E L
                if (k > 0) then
                begin

                  // mehrzeiliger Titel mit Schrägstrich
                  t1 := cutblank(copy(noten.titel, 1, pred(k)));
                  t2 := cutblank(copy(noten.titel, succ(k), MaxInt));

                  t1Size := TitelTextGetSize(NotenCache.canvas, t1, tw1);
                  t2Size := TitelTextGetSize(NotenCache.canvas, t2, tw2);

                  if t1Size > t2Size then
                    t1Size := t2Size
                  else
                    t2Size := t1Size;

                  TitelTextOutFixed(NotenCache.canvas, t1, t1Size);
                  font.Size := 17;
                  font.style := [fsbold];
                  SimpleTextOut(NotenCache.canvas, true, '* * *', 'z',
                    MaxFontSize);
                  TitelTextOutFixed(NotenCache.canvas, t2, t2Size);

                end
                else
                begin
                  TitelTextOut(NotenCache.canvas, noten.titel);
                end;
                NBI_Titel.right := cNotenBlattXL;
                NBI_Titel.bottom := ty;

                // ... Arranger ...
                NBI_Arranger.top := ty;
                NBI_Arranger.left := 0;
                font.Size := 9;
                if (noten.UeberArranger > 0) then
                  font.style := [fsbold, fsunderline]
                else
                  font.style := [fsbold];

                if noten.arranger <> '' then
                begin
                  SimpleTextOut(NotenCache.canvas, true, LanguageSTr[pred(67)] +
                    ' ' + noten.arranger, 'z', MaxFontSize);
                end;
                NBI_Arranger.right := cNotenBlattXL;
                NBI_Arranger.bottom := ty;

                font.style := [fsbold];

                // unten
                ty := 0 + cNotenBlattYL - 45;
                if (LanguageDriver = 'D') then
                begin
                  SimpleTextOut(NotenCache.canvas, true,
                    format('%s ', [_Preis]), 'r', MaxFontSize);
                end
                else
                begin
                  if (noten.OrgPreis <> 0.0) then
                    SimpleTextOut(NotenCache.canvas, true,
                      format('%s %.2f ', [noten.OrgCurrency, noten.OrgPreis]),
                      'r', MaxFontSize)
                  else
                    SimpleTextOut(NotenCache.canvas, true,
                      format('%s ', [_Preis]), 'r', MaxFontSize);
                end;

                ty := 0 + cNotenBlattYL - 45;
                SimpleTextOut(NotenCache.canvas, true, noten.schwer, 'l', 0);

                if HaendlerVersion then
                  if noten.DealerID <> '' then
                    font.style := [fsbold, fsunderline];

                ty := 0 + cNotenBlattYL - 20;
                NBI_verlag.top := ty;
                NBI_verlag.left := 0;
                SimpleTextOut(NotenCache.canvas, true,
                  noten.land + '-' + noten.verlag, 'z', MaxFontSize);
                NBI_verlag.right := cNotenBlattXL;
                NBI_verlag.bottom := ty;

              end;

            end;
          end;

          if assigned(canvas) then
          begin
            // Noten-Fläche zeichnen
            Draw(X, Y, NotenCache);
          end;
        end;
    else
      ShowMessage('SYM_? = ' + inttostr(Integer(SymbolType)));
    end;
  end;
end;

procedure TFormHeBuBase.FormPaint(Sender: TObject);
var
  n: Integer;
begin
  if not(TxtLager.InTransaction) then
    OpenDataBase;
  MoveBackGround.canvas.Draw(0, 0, ActPicture);
  for n := 1 to DesktopAnz do
    if (n <> InsideSymbol) or not(Drag) then
      DrawSymbol(MoveBackGround.canvas, n);
  canvas.Draw(0, 0, MoveBackGround);
  if Drag then
    DrawSymbol(canvas, InsideSymbol);
end;

procedure TFormHeBuBase.CloseDataBase;
begin
  if TxtLager.InTransaction then
  begin
    closeFile(NotenF);
    TxtLager.EndTransaction;
  end;
end;

procedure TFormHeBuBase.OpenDataBase;
begin
  if not(TxtLager.InTransaction) then
  begin
    // read only
    FileMode := fmOpenRead or fmShareDenyWrite;;
    BaseDate := long2date(Fdate(SystemPath + '\artikel' + inttostr(DesktopMode)
      + '.bin'));
    if FileAge(SystemPath + '\artikel' + inttostr(DesktopMode) + '.bin') >
      FileAge(ProgramFilesDir + cCodeName + '\artikel' + inttostr(DesktopMode) +
      '.bin') then
    begin
      FileCopy(SystemPath + '\artikel' + inttostr(DesktopMode) + '.bin',
        ProgramFilesDir + cCodeName + '\artikel' + inttostr(DesktopMode)
        + '.bin');
      FileCopy(SystemPath + '\texte' + inttostr(DesktopMode) + '.bla',
        ProgramFilesDir + cCodeName + '\texte' + inttostr(DesktopMode)
        + '.bla');
      FileCopy(SystemPath + '\WrdIdx' + inttostr(DesktopMode) + '.idx',
        ProgramFilesDir + cCodeName + '\WrdIdx' + inttostr(DesktopMode)
        + '.idx');
    end;
    TxtLager.init(ProgramFilesDir + cCodeName + '\texte' +
      inttostr(DesktopMode), ReallyBigStr, sizeof(ReallyBigStr));
    TxtLager.BeginTransaction;
    assignFile(NotenF, ProgramFilesDir + cCodeName + '\artikel' +
      inttostr(DesktopMode) + '.bin');
    reset(NotenF);
    NotenAnz := FileSize(NotenF);
    FileMode := fmOpenReadWrite;
    WrdIdx := TWordIndex.create(nil);
    WrdIdx.LoadFromFile(ProgramFilesDir + cCodeName + '\WrdIdx' +
      inttostr(DesktopMode) + '.idx');
    FoundAnz := 0;
    FilterVictim := 0;
    ListenAnsichtForm.ListBox1.Items.clear;
  end;
end;

function TFormHeBuBase.CreateMiniNote: Integer;
var
  mRect, NRect, zoRect: TRect;
  nx, ny: Integer;
  r: TRect;
  no: Integer;
begin
  // freie Stelle suchen
  for no := 1 to MaxDesktopSymbols do
    if not(assigned(MiniNoten[no])) then
      break;
  result := no;
  DrawSymbol(nil, NotenID);

  if assigned(MiniNoten[no]) then
  begin
    ShowMessage('Mini-Noten schon erzeugt!');
    MiniNoten[no].free; // fault-Toleranz
    MiniNoten[no] := nil;
  end;

  nx := 0;
  ny := 0;

  // Mini - Symbol größe
  mRect := Rect(0, 0, pred(ZoomSizeX), pred(ZoomSizeY));

  // Save Symbol erzeugen
  MiniNoten[no] := TBitMap.create;
  SetBitMapSizeTo(MiniNoten[no], ZoomSizeX, ZoomSizeY);

  // Quell Rect
  NRect := Rect(nx, ny, nx + cNotenBlattXL, ny + cNotenBlattYL);

  // Ziel Rect
  zoRect := Rect(1, 1, ZoomSizeX - 2, ZoomSizeY - 2);

  // copy!
  MiniNoten[no].canvas.copyrect(zoRect, NotenCache.canvas, NRect);

  // schwarzer Rahmen
  dec(zoRect.top);
  dec(zoRect.left);
  inc(zoRect.right);
  inc(zoRect.bottom);
  MiniNoten[no].canvas.brush.style := bssolid;
  MiniNoten[no].canvas.brush.Color := clblack;
  MiniNoten[no].canvas.framerect(zoRect);

  MiniNoten[no].transparent := true;
end;

procedure TFormHeBuBase.WMChar(var Msg: TWMChar);
var
  c: char;
begin
  if Drag then
    exit;
  TimerTick := 0;
  c := chr(Msg.CharCode);
  if c = '_' then
    c := ' ';
  case c of
    #8, '-':
      if InpStr <> '' then
      begin
        delete(InpStr, length(InpStr), 1);
        if InpStr = '' then
          LEDStatus := LED_OFF
        else
          LEDStatus := LED_ORANGE;
        DrawSymbol(canvas, InputID);
      end;
    #13, '+':
      DoSearch;
  else
    if ord(c) > 31 then
    begin
      InpStr := InpStr + c;
      LEDStatus := LED_ORANGE;
      DrawSymbol(canvas, InputID);
    end;
  end;
end;

procedure TFormHeBuBase.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if FilterRunning then
  begin
    FilterRunning := false;
  end
  else
  begin

    case Key of
      VK_F1:
        if not(MesseMode) then
          HilfeForm.show
        else
          RunListenAnsicht;

      VK_F2:
        if not(MesseMode) then
          paint;

      VK_F3:
        if not(MesseMode) then
        begin
          with FormNotenDaten, noten, memo1.lines do
          begin
            clear;
            Add(format('ArtikelNo      : "%s"', [ArtikelNo]));
            Add(format('Land           : "%s"', [land]));
            Add(format('Titel          : "%s"', [titel]));
            Add(format('Komponist      : "%s"', [komponist]));
            Add(format('Arranger       : "%s"', [arranger]));
            Add(format('schwer         : "%s"', [schwer]));
            Add(format('preis          : %m', [preis]));
            Add(format('verlag         : "%s"', [verlag]));
            Add(format('Serie          : "%s"', [Serie]));
            Add(format('Dauer          : "%s"', [dauer]));
            Add(format('ProbeStimme    : "%s"', [ProbeStimme]));
            Add(format('Aufnahme       : "%s"', [Aufnahme]));
            Add(format('Sparte         : "%s"', [Sparte]));
            Add(format('Bemerkung      : "%s"', [_Bemerkung]));
            Add(format('Komposition    : "%s"', [_Komposition]));
            Add(format('UeberKomponist : "%s"', [_UeberKomponist]));
            Add(format('UeberArranger  : "%s"', [_UeberArranger]));
            Add(format('PaperColor     : %d', [PaperColor]));
            Add(format('BestellNo      : "%s"', [BestellNo]));
            Add(format('OrgPreis       : %m', [OrgPreis]));
            Add(format('OrgCurrency    : "%s"', [OrgCurrency]));
            Add(format('EntryDate      : %s', [long2date(EntryDate)]));
            Add(format('SoundSource    : %d', [SoundSource]));
            Add(format('dealerID       : "%s"', [DealerID]));
            show;
          end;
        end;
      VK_F4:
        if ssshift in Shift then
          FormWebExport.show
        else
          RunMusikAnsicht;
      VK_F5:
        begin
          if SoundState = SS_play then
            PlayThisSound
          else
            WinAmpNext;
          Key := 0;
        end;
      VK_F6:
        begin
          if SoundState = SS_stop then
          begin
            screen.cursor := crHourGlass;
            WinAmpHide;
            WinAmpFadeOut;
            DrawSymbol(canvas, SoundID);
            SetDefaultCursor;
          end;
          Key := 0;
        end;
      VK_F7:
        begin
          WinAmpVolumeDown;
          Key := 0;
        end;
      VK_F8:
        begin
          WinAmpVolumeUp;
          Key := 0;
        end;
      VK_F9:
        begin
          NPrev;
          Key := 0;
        end;
      VK_F10:
        begin
          NNext;
          Key := 0;
        end;
      VK_F11:
        begin
          ShowTitelInfo(120, 210);
          Key := 0;
        end;
      VK_F12:
        begin
          RunListenAnsicht;
          Key := 0;
        end;
      VK_ESCAPE:
        if not(MesseMode) then
          Close
        else
        begin
          InpStr := '';
          DrawSymbol(canvas, InputID);
        end;
      VK_DELETE:
        begin
          InpStr := '';
          DrawSymbol(canvas, InputID);
        end;
      VK_END:
        NLast;
      VK_HOME:
        NFirst;
      VK_UP, VK_PRIOR, vk_left:
        NPrev;
      VK_DOWN, VK_NEXT, vk_right:
        NNext;

    end;
  end;
end;

procedure TFormHeBuBase.DoSearch;
begin
  screen.cursor := crHourGlass;
  LEDStatus := LED_RED;
  DrawSymbol(canvas, InputID);
  application.processmessages;
  SearchFullTextMode := false;

  if (InpStr <> '') then
  begin
    InpStr := cutblank(AnsiUpperCase(InpStr));
    if InpStr = 'ÄNDE' then
    begin
      AppGoesDown := true;
      Close;
      NameForm.AppDown;
      exit;
    end;
    if InpStr = 'DAUN' then
      FileEMpty(MyProgramPath + '\down.txt');

    WrdIdx.Search(InpStr);
    FoundAnz := WrdIdx.FoundList.count;
    FilterVictim := 0;

  end
  else
  begin

    //
    if OnePreisChecked or OneSchwierigkeitsgradChecked or OneLandChecked or
      OneMusicChecked or OneNeuChecked or OneRubrikChecked or OneFeldChecked
    then
      FoundAnz := NotenAnz
    else
      FoundAnz := 0;

  end;

  if FoundAnz > 0 then
    if OnePreisChecked or OneSchwierigkeitsgradChecked or OneLandChecked or
      OneMusicChecked or OneNeuChecked or OneRubrikChecked or OneFeldChecked
    then
      DoFilter;

  if (FoundAnz > 0) then
  begin

    // Erfolg
    ActFound := 0;
    DesktopSymbols[NotenID].SymbolData := Integer(WrdIdx.FoundList[ActFound]);
    DrawSymbol(canvas, NotenID);
    DrawSymbol(canvas, SoundID);
    LEDStatus := LED_GREEN;
    DrawSymbol(canvas, InputID);

  end
  else
  begin
    ShowMessage(format(LanguageSTr[pred(142)], [InpStr]));

    // nicht gefunden
    LEDStatus := LED_RED;
    DrawSymbol(canvas, InputID);
  end;
  ListenAnsichtForm.ListBox1.Items.clear;
  SetDefaultCursor;
end;

procedure TFormHeBuBase.DoFullTextSearch;
begin
  screen.cursor := crHourGlass;
  LEDStatus := LED_RED;
  DrawSymbol(canvas, InputID);
  application.processmessages;

  FoundAnz := 0;

  if (InpStr <> '') then
  begin
    InpStr := cutblank(AnsiUpperCase(InpStr));
    FoundAnz := NotenAnz;
    SearchFullTextMode := true;
    DoFilter;
  end;

  if (FoundAnz > 0) then
  begin
    // Erfolg
    ActFound := 0;
    DesktopSymbols[NotenID].SymbolData := Integer(WrdIdx.FoundList[ActFound]);
    DrawSymbol(canvas, NotenID);
    DrawSymbol(canvas, SoundID);
    LEDStatus := LED_GREEN;
    DrawSymbol(canvas, InputID);
  end
  else
  begin
    ShowMessage(format(LanguageSTr[pred(142)], [InpStr]));
    // nicht gefunden
    LEDStatus := LED_RED;
    DrawSymbol(canvas, InputID);
  end;
  ListenAnsichtForm.ListBox1.Items.clear;
  SetDefaultCursor;
end;

procedure TFormHeBuBase.DoFilter;
var
  X, Y: Integer;
  n, k: Integer;
  MyTick: dword;
  BigStr: string;
  InpWords: TStringList;

  function Impossible: Boolean;
  var
    k, l: Integer;
  begin
    result := true;
    with noten do
    begin

      if OnePreisChecked then
      begin
        if (preis > MaximalPreis) then
          exit;
      end;

      if OneSchwierigkeitsgradChecked then
      begin
        if pos(schwer[1], SchwierigkeitsgradOK) = 0 then
          exit;
      end;

      if OneLandChecked then
      begin
        if pos('{' + land + '}', LaenderOK) = 0 then
          exit;
      end;

      if OneRubrikChecked then
      begin
        if pos('{' + Sparte + '}', RubrikOK) = 0 then
          exit;
      end;

      if OneFeldChecked then
      begin

        // neuen BigString bilden!
        BigStr := '';
        if FeldChecks[1] then // Titel
          BigStr := BigStr + ' ' + titel;
        if FeldChecks[2] then // Komponist
          BigStr := BigStr + ' ' + komponist;
        if FeldChecks[3] then // Arrangeur
          BigStr := BigStr + ' ' + arranger;
        if FeldChecks[4] then // Serie
          BigStr := BigStr + ' ' + Serie;
        if FeldChecks[5] then // Artikel Nummer
          BigStr := BigStr + ' ' + ArtikelNo;
        if FeldChecks[6] then // Verlag
          BigStr := BigStr + ' ' + verlag;
        if FeldChecks[7] then // Bemerkung
          BigStr := BigStr + ' ' + _Bemerkung;
        if FeldChecks[8] then // sparte
          BigStr := BigStr + ' ' + Sparte;

        BigStr := AnsiUpperCase(BigStr) + ' ';

        // jetzt muss jedes einzelne Wort im BigStr vorkommen!
        if SearchFullTextMode then
        begin
          // Volltextsuche, einfach nur in der Mitte
          for k := 0 to pred(InpWords.count) do
            if pos(InpWords[k], BigStr) = 0 then
              exit;
        end
        else
        begin
          // Jetzt noch mal bestätigen, dass diese WORT im BigStr
          // vorkommt, jedoch als Wort, und nicht als Bruchstück
          // also nicht der zwang zum vollen Wort, jedoch ein
          // Wortanfang sollte es sein!
          for k := 0 to pred(InpWords.count) do
          begin
            l := pos(InpWords[k], BigStr);
            if (l = 0) then
              exit;
            if (l > 1) then
              if pos(BigStr[pred(l)], c_wi_WhiteSpace_exact) = 0 then
                exit;
          end;
        end;

      end;

      if OneMusicChecked then
      begin
        if (SoundSource = 0) then
          exit
        else if not(MusicOK[SoundSource]) then
          exit;
      end;

      if OneNeuChecked then
      begin
        if (EntryDate < NeuDateOK) then
          exit;
      end;

      if SearchFullTextMode then
      begin

        // neuen BigString bilden!
        BigStr := AnsiUpperCase(land + schwer + titel + komponist + arranger +
          Serie + ArtikelNo + verlag + _Bemerkung + ProbeStimme + Aufnahme +
          _Komposition + _UeberKomponist + _UeberArranger + Sparte);

        // jetzt muss jedes einzelne Wort im BigStr vorkommen!
        for k := 0 to pred(InpWords.count) do
          if pos(InpWords[k], BigStr) = 0 then
            exit;

      end;

    end;
    result := false;
  end;

begin

  // einzeichnen der Progess-Bar
  X := DesktopSymbols[InputID].SymbolRect.left;
  Y := DesktopSymbols[InputID].SymbolRect.top;
  with ProgressBar1 do
  begin
    brush.Color := clwhite;
    left := X + ProgressRect.left - EingabeRect.left;
    top := Y + ProgressRect.top - EingabeRect.top;
    height := ryl(ProgressRect);
    width := rXl(ProgressRect);
    visible := true;
    position := 0;
    min := 0;
    max := pred(FoundAnz);
    step := 1;
  end;

  // Vorbereitung für Feld-Filter
  if OneFeldChecked or SearchFullTextMode then
  begin
    if InpStr = '' then
      ShowMessage(LanguageSTr[pred(1)]);

    InpWords := TStringList.create;
    BigStr := InpStr;
    while true do
    begin
      k := pos(' ', BigStr);
      if k = 0 then
      begin
        InpWords.Add(BigStr);
        break;
      end
      else
      begin
        InpWords.Add(copy(BigStr, 1, pred(k)));
        BigStr := copy(BigStr, succ(k), MaxInt);
        if BigStr = '' then
          break;
      end;
    end;

  end;

  application.processmessages;
  // alle Datensätze laden, und schauen, ob sie den Filter
  // bestimmungen genügen!
  MyTick := GetTickCount;
  FilterVictim := 0;
  FilterRunning := true;

  if (FoundAnz = NotenAnz) then
  begin
    // aus ALLEN filtern
    for n := 0 to pred(NotenAnz) do
    begin
      GetNotenDirect(n);
      if Impossible then
      begin
        inc(FilterVictim);
      end
      else
      begin
        WrdIdx.FoundList.Add(pointer(n));
      end;
      if frequently(MyTick, 500) then
      begin
        application.processmessages;
        ProgressBar1.position := n;
      end;
    end;
  end
  else
  begin
    // aus GEFUNDENEN filtern
    for n := pred(WrdIdx.FoundList.count) downto 0 do
    begin
      GetNotenDirect(Integer(WrdIdx.FoundList[n]));
      if Impossible then
      begin
        inc(FilterVictim);
        WrdIdx.FoundList.delete(n);
      end;
      if frequently(MyTick, 500) then
      begin
        application.processmessages;
        ProgressBar1.position := n;
      end;
    end;
  end;
  FoundAnz := WrdIdx.FoundList.count;
  ProgressBar1.visible := false;
  if OneFeldChecked then
  begin
    InpWords.free;
  end;
end;

procedure TFormHeBuBase.EvaluateFilter;
var
  n: Integer;
  OnlyBeforeMinus: string;
  OneActive: Boolean;
begin
  // noch Code aus den Filtern ausführen!!!
  if FilterEditor > -1 then
  begin
    with FilterForm do
    begin
      case FilterEditor of
        FILTER_FELDER:
          begin

            // sind alle Felder aus?
            OneActive := false;
            for n := 1 to FeldNamenAnz do
            begin
              if CheckListBox1.checked[pred(n)] then
                OneActive := true;
            end;

            if not(OneActive) then
              for n := 1 to FeldNamenAnz do
                CheckListBox1.checked[pred(n)] := true;

            OneFeldChecked := false;
            for n := 1 to FeldNamenAnz do
            begin
              FeldChecks[n] := CheckListBox1.checked[pred(n)];
              if not(FeldChecks[n]) then
                OneFeldChecked := true;
            end;
          end;
        FILTER_LAND:
          begin
            OneLandChecked := false;
            LaenderOK := '';
            for n := 1 to LandStrings.count do
            begin
              LandChecks[n] := CheckListBox1.checked[pred(n)];
              if LandChecks[n] then
              begin
                OneLandChecked := true;
                OnlyBeforeMinus := copy(LandStrings[pred(n)], 1,
                  pred(pos('-', LandStrings[pred(n)])));
                LaenderOK := LaenderOK + '{' + OnlyBeforeMinus + '}';
              end;
            end;
          end;
        FILTER_SCHWER:
          begin
            for n := 1 to SchwierigkeitsgradStrings.count do
              SchwierigkeitsgradChecks[n] := CheckListBox1.checked[pred(n)];
            OneSchwierigkeitsgradChecked := false;
            SchwierigkeitsgradOK := '';
            for n := 1 to SchwierigkeitsgradStrings.count do
              if SchwierigkeitsgradChecks[n] then
              begin
                SchwierigkeitsgradOK := SchwierigkeitsgradOK + inttostr(n);
                OneSchwierigkeitsgradChecked := true;
              end;
          end;
        FILTER_PREIS:
          begin
            OnePreisChecked := false;
            for n := 1 to PreisStrings.count do
            begin
              PreisChecks[n] := CheckListBox1.checked[pred(n)];
              if PreisChecks[n] then
              begin
                OnePreisChecked := true;
                MaximalPreis := PreisToString(PreisStrings[pred(n)]);
                if (LanguageDriver <> 'D') then
                  ShowMessage(LanguageSTr[pred(114)]);
              end;
            end;
          end;
        FILTER_MUSIC:
          begin
            OneMusicChecked := false;
            for n := 1 to MusicStrings.count do
            begin
              MusicChecks[n] := CheckListBox1.checked[pred(n)];
              MusicOK[n] := CheckListBox1.checked[pred(n)];
              if MusicChecks[n] then
                OneMusicChecked := true;
            end;
          end;
        FILTER_NEU:
          begin
            OneNeuChecked := false;
            for n := 1 to NeuStrings.count do
            begin
              NeuChecks[n] := CheckListBox1.checked[pred(n)];
              if NeuChecks[n] then
              begin
                OneNeuChecked := true;
                NeuDateOK := FilterForm.UserEntryDate;
              end;
            end;
          end;
        FILTER_RUBRIK:
          begin
            OneRubrikChecked := false;
            RubrikOK := '';
            for n := 1 to RubrikStrings.count do
            begin
              RubrikChecks[n] := CheckListBox1.checked[pred(n)];
              if RubrikChecks[n] then
              begin
                OneRubrikChecked := true;
                RubrikOK := RubrikOK + '{' + RubrikKuerzel[pred(n)] + '}';
              end;
            end;
          end;
      end;
    end;
    FilterEditor := -1;
  end;
end;

procedure TFormHeBuBase.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  n: Integer;
  ButtonNumber: Integer;
  OutStr: string;
  _sparte: string;
  k: Integer;
begin
  if (MesseMode) then
    exit;

  FilterRunning := false;
  if (FilterEditor > -1) then
    FilterForm.Close;
  case Button of
    mbleft:
      if (InsideSymbol > 0) then
      begin
        with DesktopSymbols[InsideSymbol] do
        begin
          mOffsetx := X - SymbolRect.left;
          mOffsety := Y - SymbolRect.top;
          case SymbolType of
            SYM_SWITCH:
              if (mOffsetx > 134) then
              begin
                InsideSymbol := 0;
                LastPopUpX := X;
                LastPopUpy := Y;
              end
              else
              begin
                SwitchDesktop;
              end;
            SYM_HILFE:
              if inside(mOffsetx, mOffsety, DragArea) then
              begin
                SetDragOn;
              end
              else
              begin
                HilfeForm.show;
              end;
            SYM_JUBI:
              if inside(mOffsetx, mOffsety, DragArea) then
              begin
                SetDragOn;
              end
              else
              begin
                JubiForm.show;
              end;
            SYM_TITEL:
              if inside(mOffsetx, mOffsety, DragArea) then
              begin
                SetDragOn;
              end
              else
              begin
                FillTrackInfo;
                FormTrackAnsicht.show;
              end;
            SYM_INTERNET:
              if inside(mOffsetx, mOffsety, DragArea) then
              begin
                SetDragOn;
              end
              else
              begin
                SaveDeskTop;
                SaveSymbolINfo;
                CloseDataBase;
                verlageform.FreeVerlage;
                // InterNetUpdateForm.showmodal;
                NotenCacheEl := MaxInt;
                screen.cursor := crHourGlass;
                OpenDataBase;
                LoadDeskTop;
                paint;
                SetDefaultCursor;
              end;
            SYM_TRASH:
              if inside(mOffsetx, mOffsety, DragArea) then
              begin
                SetDragOn;
              end
              else
              begin
                if TrashFull then
                  ShowMessage('hm, was passiert jetzt');
              end;
            SYM_KORB:
              if inside(mOffsetx, mOffsety, DragArea) then
                SetDragOn
              else
                DoEdit;
            SYM_NOTIZ:
              if inside(mOffsetx, mOffsety, DragArea) then
                SetDragOn
              else
              begin
                if inside(mOffsetx, mOffsety, ListenAnsichtArea) then
                  DoNotiz(0)
                else
                  DoNotiz(1);
              end;
            SYM_SOUND:
              if inside(mOffsetx, mOffsety, DragArea) then
              begin
                SetDragOn;
              end
              else
              begin
                //
                // ShowMessage(format('%d,%d',[mOffsetx,mOffsety]));
                case SoundState of
                  SS_disabled:
                    ShowMessage(LanguageSTr[pred(33)]);
                  SS_play:
                    PlayThisSound;
                  SS_stop:
                    if inside(mOffsetx, mOffsety, VolumeOFFSwitchArea) then
                    begin
                      screen.cursor := crHourGlass;
                      WinAmpFadeOut;
                      WinAmpHide;
                      DrawSymbol(canvas, SoundID);
                      SetDefaultCursor;
                    end;
                end;
              end;
            SYM_INPUT:
              if inside(mOffsetx, mOffsety, DragArea) then
              begin
                SetDragOn;
              end
              else
              begin
                case GetButtonNumber(mOffsetx, mOffsety, 'e') of
                  0:
                    NFirst;
                  1:
                    NPrev;
                  2:
                    NNext;
                  3:
                    NLast;
                  4:
                    RunListenAnsicht;
                  5:
                    DoFullTextSearch;
                  6:
                    begin
                      CloseDataBase;
                      Close;
                    end;
                end;
              end;
            SYM_NOTENBLATT:
              if inside(mOffsetx, mOffsety, DragArea) then
              begin
                SetDragOn;
              end
              else
              begin
                while true do
                begin

                  if inside(mOffsetx, mOffsety, NBI_Komponist) then
                  begin
                    if DesktopMode = 0 then
                    begin
                      // Hebu
                      MiniTexteForm.hide;
                      with noten do
                      begin
                        OutStr := titel + #$0D;
                        OutStr := OutStr + komponist + #$0D;
                        OutStr := OutStr + _UeberKomponist + #$0D;
                      end;
                      MiniTexteForm.left := X;
                      MiniTexteForm.top := Y;
                      MiniTexteForm.WriteOut(OutStr);
                    end
                    else
                    begin
                      // Obermayer
                      FillTrackInfo;
                      FormTrackAnsicht.show;
                    end;
                    break;
                  end;

                  if inside(mOffsetx, mOffsety, NBI_Titel) then
                  begin
                    ShowTitelInfo(X, Y);
                    break;
                  end;

                  if inside(mOffsetx, mOffsety, NBI_Arranger) then
                  begin

                    MiniTexteForm.hide;
                    with noten do
                    begin
                      OutStr := titel + #$0D;
                      OutStr := OutStr + arranger + #$0D;
                      OutStr := OutStr + _UeberArranger + #$0D;
                    end;
                    MiniTexteForm.top := Y;
                    MiniTexteForm.left := X;
                    MiniTexteForm.WriteOut(OutStr);
                    break;
                  end;

                  if HaendlerVersion then
                    if inside(mOffsetx, mOffsety, NBI_verlag) then
                    begin
                      // Händler Info
                      MiniTexteForm.hide;
                      with noten do
                      begin
                        OutStr := titel + #$0D;
                        OutStr := OutStr + #$0D + LanguageSTr[pred(106)] + #$0D;
                        if (BestellNo <> '') then
                          OutStr := OutStr + LanguageSTr[pred(105)] + ' ' +
                            BestellNo + #$0D;
                        if OrgPreis > 0.0 then
                          OutStr := OutStr + format(LanguageSTr[pred(107)],
                            [noten.OrgCurrency, OrgPreis]) + #$0D;

                        if (DealerID <> '') then
                        begin

                          // die Händler-ID suchen!
                          verlageform.LoadVerlage;
                          for n := 0 to pred(VerlageAnz) do
                            if DealerID = VerlageArray^[n].nummer then
                            begin
                              with VerlageArray^[n] do
                              begin
                                OutStr := OutStr + name + #$0D + strasse + #$0D
                                  + Ort + #$0D + #$0D + Ansprechpartner + ' ' +
                                  eMail + #$0D + LanguageSTr[pred(103)] + ' ' +
                                  tel + ' ' + website + #$0D + LanguageSTr
                                  [pred(104)] + ' ' + fax;
                              end;
                            end;
                        end;
                      end;
                      MiniTexteForm.top := Y;
                      MiniTexteForm.left := X;
                      MiniTexteForm.WriteOut(OutStr);
                      break;

                    end;

                  // bleibt nur noch Mini-Noten
                  if (DesktopAnz < MaxDesktopSymbols) then
                  begin

                    // nun in den Desktop einfügen!
                    inc(DesktopAnz);
                    with DesktopSymbols[DesktopAnz] do
                    begin
                      SymbolOffset := CreateMiniNote;
                      SymbolRect :=
                        Rect(X - (MiniNoten[SymbolOffset].width div 2),
                        Y - (MiniNoten[SymbolOffset].height div 2), 0, 0);
                      SymbolType := SYM_MININOTEN;
                      SymbolData := NotenCacheEl;
                      DragArea := cRFilter;
                      mOffsetx := X - SymbolRect.left;
                      mOffsety := Y - SymbolRect.top;
                    end;

                    // und zeichnen
                    DrawSymbol(canvas, DesktopAnz);

                    // und markieren
                    InsideSymbol := DesktopAnz;
                    SetDragOn;
                  end
                  else
                  begin
                    ShowMessage(LanguageSTr[pred(75)]);
                  end;
                  break;

                end; // while true
              end; // Drag
            SYM_MININOTEN:
              if inside(mOffsetx, mOffsety, DragArea) then
              begin
                SetDragOn;
              end
              else
              begin
                FoundAnz := 0;
                FilterVictim := 0;
                ListenAnsichtForm.ListBox1.Items.clear;
                DesktopSymbols[NotenID].SymbolData := SymbolData;
                DrawSymbol(canvas, NotenID);
                DrawSymbol(canvas, SoundID);
                DrawBaseCount(canvas);
              end;
            SYM_FILTERBUTTON:
              if inside(mOffsetx, mOffsety, DragArea) then
              begin
                SetDragOn;
              end
              else
              begin
                with FilterForm do
                begin
                  left := X;
                  top := Y;
                  FilterEditor := SymbolData;
                  case FilterEditor of
                    FILTER_FELDER:
                      begin
                        width := 100;
                        height := FILTER_CHECKLISTBOX_ZERO_SIZE + FeldNamenAnz *
                          FILTER_CHECKLISTBOX_ENTRY_SIZE;

                        caption := LanguageSTr[pred(30)];
                        // SchwierigkeitsgradChecks
                        CheckListBox1.Items.clear;
                        for n := 1 to FeldNamenAnz do
                        begin
                          CheckListBox1.Items.Add
                            (LanguageSTr[pred(cFelderNamen[n])]);
                          CheckListBox1.checked[pred(n)] := FeldChecks[n];
                        end;
                        OneCheckOnly := false;
                        ClearMeansSetAll := true;
                        DatumEntryMode := false;
                        ClearIfSetAll := true;
                        show;
                      end;
                    FILTER_LAND:
                      begin
                        width := 135;
                        height := FILTER_CHECKLISTBOX_ZERO_SIZE +
                          min(LandStrings.count *
                          FILTER_CHECKLISTBOX_ENTRY_SIZE,
                          10 * FILTER_CHECKLISTBOX_ENTRY_SIZE);
                        caption := LanguageSTr[pred(31)];
                        CheckListBox1.Items := LandStrings;
                        for n := 1 to LandStrings.count do
                          CheckListBox1.checked[pred(n)] := LandChecks[n];
                        OneCheckOnly := false;
                        ClearMeansSetAll := false;
                        DatumEntryMode := false;
                        ClearIfSetAll := false;
                        show;
                      end;
                    FILTER_SCHWER:
                      begin
                        width := 70;
                        height := FILTER_CHECKLISTBOX_ZERO_SIZE + 6 *
                          FILTER_CHECKLISTBOX_ENTRY_SIZE;
                        caption := '1-6';
                        // SchwierigkeitsgradChecks
                        CheckListBox1.Items := SchwierigkeitsgradStrings;
                        for n := 1 to SchwierigkeitsgradStrings.count do
                        begin
                          CheckListBox1.checked[pred(n)] :=
                            SchwierigkeitsgradChecks[n];
                        end;
                        OneCheckOnly := false;
                        ClearMeansSetAll := false;
                        DatumEntryMode := false;
                        ClearIfSetAll := false;
                        show;
                      end;
                    FILTER_PREIS:
                      begin
                        width := 110;
                        height := FILTER_CHECKLISTBOX_ZERO_SIZE +
                          PreisStrings.count * FILTER_CHECKLISTBOX_ENTRY_SIZE;
                        caption := LanguageSTr[pred(32)];
                        // PreisChecks
                        CheckListBox1.Items := PreisStrings;
                        for n := 1 to PreisStrings.count do
                          CheckListBox1.checked[pred(n)] := PreisChecks[n];
                        OneCheckOnly := true;
                        ClearMeansSetAll := false;
                        DatumEntryMode := false;
                        ClearIfSetAll := false;
                        show;
                      end;
                    FILTER_MUSIC:
                      begin
                        width := 170;
                        height := FILTER_CHECKLISTBOX_ZERO_SIZE +
                          MusicStrings.count * FILTER_CHECKLISTBOX_ENTRY_SIZE;
                        caption := LanguageSTr[pred(96)];
                        CheckListBox1.Items := MusicStrings;
                        for n := 1 to MusicStrings.count do
                          CheckListBox1.checked[pred(n)] := MusicChecks[n];
                        OneCheckOnly := false;
                        ClearMeansSetAll := false;
                        DatumEntryMode := false;
                        ClearIfSetAll := false;
                        show;
                      end;
                    FILTER_NEU:
                      begin
                        width := 130;
                        height := FILTER_CHECKLISTBOX_ZERO_SIZE +
                          NeuStrings.count * FILTER_CHECKLISTBOX_ENTRY_SIZE;
                        caption := LanguageSTr[pred(97)];
                        CheckListBox1.Items := NeuStrings;
                        for n := 1 to NeuStrings.count do
                          CheckListBox1.checked[pred(n)] := NeuChecks[n];
                        OneCheckOnly := true;
                        ClearMeansSetAll := false;
                        DatumEntryMode := true;
                        ClearIfSetAll := false;
                        show;
                      end;
                    FILTER_RUBRIK:
                      begin
                        width := 170;
                        height := FILTER_CHECKLISTBOX_ZERO_SIZE + FeldNamenAnz *
                          FILTER_CHECKLISTBOX_ENTRY_SIZE;

                        caption := LanguageSTr[pred(145)];
                        // SchwierigkeitsgradChecks
                        CheckListBox1.Items.clear;
                        for n := 1 to RubrikStrings.count do
                        begin
                          CheckListBox1.Items.Add(RubrikStrings[pred(n)]);
                          CheckListBox1.checked[pred(n)] := RubrikChecks[n];
                        end;
                        OneCheckOnly := false;
                        ClearMeansSetAll := true;
                        DatumEntryMode := false;
                        ClearIfSetAll := true;
                        show;
                      end;
                  else
                    ShowMessage('Filter ' + inttostr(FilterEditor) + ' fail!');
                  end;
                end;
              end;
          end;
        end;
      end;
    mbright:
      if (InsideSymbol > 0) then
      begin
        // Symbol löschen
        case DesktopSymbols[InsideSymbol].SymbolType of
          SYM_MININOTEN:
            begin
              DeleteMiniNote(InsideSymbol);
              paint;
              InsideSymbol := 0;
            end;
          SYM_SOUND:
            begin
              WinAmpShow;
              WinAmpSetFocus;
            end;
          SYM_KORB:
            begin
              DoEdit;
            end;
          SYM_NOTIZ:
            begin
              DoNotiz(0);
            end;
          SYM_HILFE:
            begin
            end;
          SYM_SWITCH, SYM_NOTENBLATT:
            begin
              InpStr := copy(noten.titel, 1, 25);
              for n := length(InpStr) downto 1 do
                if pos(InpStr[n], c_wi_WhiteSpace_exact) > 1 then
                  delete(InpStr, n, 1);
              SwitchDesktop;
              DoSearch;
            end;
        end;
      end
      else
      begin
        LastPopUpX := X;
        LastPopUpy := Y;
      end;
  end;
end;

procedure TFormHeBuBase.NFirst;
begin
  if FoundAnz > 0 then
  begin
    ActFound := 0;
    DesktopSymbols[NotenID].SymbolData := Integer(WrdIdx.FoundList[ActFound]);
  end
  else
  begin
    DesktopSymbols[NotenID].SymbolData := 0;
  end;
  DrawSymbol(canvas, NotenID);
  DrawSymbol(canvas, SoundID);
  DrawBaseCount(canvas);
end;

procedure TFormHeBuBase.NLast;
begin
  if FoundAnz > 0 then
  begin
    ActFound := pred(FoundAnz);
    DesktopSymbols[NotenID].SymbolData := Integer(WrdIdx.FoundList[ActFound]);
  end
  else
  begin
    DesktopSymbols[NotenID].SymbolData := pred(NotenAnz);
  end;
  DrawSymbol(canvas, NotenID);
  DrawSymbol(canvas, SoundID);
  DrawBaseCount(canvas);
end;

procedure TFormHeBuBase.NNext;
begin
  if FoundAnz > 0 then
  begin
    if ActFound = pred(FoundAnz) then
      exit;
    inc(ActFound);
    DesktopSymbols[NotenID].SymbolData := Integer(WrdIdx.FoundList[ActFound]);
  end
  else
  begin
    if DesktopSymbols[NotenID].SymbolData = pred(NotenAnz) then
      exit;
    inc(DesktopSymbols[NotenID].SymbolData);
  end;
  DrawSymbol(canvas, NotenID);
  DrawSymbol(canvas, SoundID);
  DrawBaseCount(canvas);
end;

procedure TFormHeBuBase.NPrev;
begin
  if FoundAnz > 0 then
  begin
    if ActFound = 0 then
      exit;
    dec(ActFound);
    DesktopSymbols[NotenID].SymbolData := Integer(WrdIdx.FoundList[ActFound]);
  end
  else
  begin
    if DesktopSymbols[NotenID].SymbolData = 0 then
      exit;
    dec(DesktopSymbols[NotenID].SymbolData);
  end;
  DrawSymbol(canvas, NotenID);
  DrawSymbol(canvas, SoundID);
  DrawBaseCount(canvas);
end;

procedure TFormHeBuBase.AfterMouseUp;
begin
  if (MesseMode) then
    exit;

  if Drag then
  begin
    Drag := false;

    // bring last moved element to top!
    if (DesktopSymbols[InsideSymbol].SymbolType = SYM_MININOTEN) then
      MiniNotenBringToTop(InsideSymbol);

    //
    if TrashFull then
    begin
      DeleteMiniNote(InsideSymbol);
      TrashFull := false;
    end;

    // Desktop im verborgenen neu zeichnen
    // in der Final Release eigentlich nicht notwendig!!!
    // nur notwendig wegen Schlieren beim Ziehen
    InsideSymbol := 0;
    paint;

  end;
end;

procedure TFormHeBuBase.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (MesseMode) then
    exit;
  AfterMouseUp;
end;

procedure TFormHeBuBase.MarkSymbol(X, Y: Integer);
begin
  with canvas do
  begin

    with DesktopSymbols[InsideSymbol] do
    begin

      mOffsetx := X - SymbolRect.left;
      mOffsety := Y - SymbolRect.top;

      case SymbolType of
        SYM_FILTERBUTTON:
          if (SymbolOffset <> FilterGREEN) then
          begin
            SymbolOffset := FilterGREEN;
            DrawSymbol(canvas, InsideSymbol);
          end;
      end;
    end;
    if DragArea(X, Y) then
    begin
      cursor := crHand;
      InsideStatus := INSIDE_DRAG;
    end
    else
    begin
      cursor := crHandPoint;
      InsideStatus := INSIDE_OTHER;
    end;
  end;
end;

procedure TFormHeBuBase.UnMarkSymbol;
begin
  with canvas do
  begin
    {
      Brush.style := bsSolid;
      Brush.Color := clblack;
      FrameRect(DeskTopsymbols[InsideSymbol].SymbolRect);
    }
    with DesktopSymbols[InsideSymbol] do
    begin
      case SymbolType of

        SYM_FILTERBUTTON:
          if (SymbolOffset <> FilterOFF) then
          begin
            SymbolOffset := FilterOFF;
            DrawSymbol(canvas, InsideSymbol);
          end;
      end;
    end;
    cursor := crdefault;
    InsideStatus := INSIDE_UNKNOWN;
  end;
end;

procedure TFormHeBuBase.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  rRestore1: TRect;
  rRestore2: TRect;
  rAlt: TRect;
  rNeu: TRect;
  _nx, _ny, n: Integer;
  SymbolFound: Boolean;
begin
  if (MesseMode) then
    exit;
  if Drag then
  begin

    // neue Position des Symbols
    _nx := X - mOffsetx;
    _ny := Y - mOffsety;

    if InsideSymbol = NotizID then
      if _ny > DesktopSymbols[KorbID].SymbolRect.top - 5 then
        _ny := DesktopSymbols[KorbID].SymbolRect.top - 5;

    if InsideSymbol = KorbID then
      if _ny < DesktopSymbols[NotizID].SymbolRect.top + 5 then
        _ny := DesktopSymbols[NotizID].SymbolRect.top + 5;

    rAlt := DesktopSymbols[InsideSymbol].SymbolRect;
    rNeu := rAlt;
    rmoveto(rNeu, _nx, _ny);
    DesktopSymbols[InsideSymbol].SymbolRect := rNeu;

    // Mini-Noten Handling
    if (DesktopSymbols[InsideSymbol].SymbolType = SYM_MININOTEN) then
    begin

      // Mülleimer
      if RectCollision(rNeu, DesktopSymbols[TrashID].SymbolRect) then
      begin
        // Mini-Noten über dem Mülleimer
        if not(TrashFull) then
        begin
          TrashFull := true;
          DrawSymbol(canvas, TrashID);
          DrawSymbol(MoveBackGround.canvas, TrashID);
        end;
      end
      else
      begin
        // Mini-Noten außerhalb des Mülleimers
        if TrashFull then
        begin
          TrashFull := false;
          DrawSymbol(canvas, TrashID);
        end;
      end;

      // Mini-Noten runterfallen lassen
      if (_ny > screen.height - 60) then
      begin
        // kleine Symbole runter fallen lassen
        for n := InsideSymbol to DesktopAnz - 1 do
          DesktopSymbols[n] := DesktopSymbols[succ(n)];
        dec(DesktopAnz);
        AfterMouseUp;
        exit;
      end;

    end;

    with canvas do
    begin

      // wenn das Symbol rechteckig wäre, würde ein CopyRect(rneu,Canvas,ralt);
      // reichen -> schnell!

      // Symbol neu zeichnen
      DrawSymbol(canvas, InsideSymbol);

      if Sub2Rects(rAlt, rNeu, rRestore1, rRestore2) then
      begin

        if rValid(rRestore1) then
          copyrect(SizeCorrect(rRestore1), MoveBackGround.canvas,
            SizeCorrect(rRestore1));

        if rValid(rRestore2) then
          copyrect(SizeCorrect(rRestore2), MoveBackGround.canvas,
            SizeCorrect(rRestore2));

      end
      else
      begin

        // full size restore
        copyrect(SizeCorrect(rAlt), MoveBackGround.canvas, SizeCorrect(rAlt));

      end;
    end;

  end
  else
  begin
    // nicht im Drag Mode!
    while true do
    begin
      // Rahmen
      if (InsideSymbol > 0) then
      begin
        // already inside a symbol, but may be inside a symbol on top!!
        SymbolFound := false;
        for n := DesktopAnz downto InsideSymbol do
          with DesktopSymbols[n] do
            if inside(X, Y, SymbolRect) then
            begin
              if (n <> InsideSymbol) then
              begin
                // flip to another symbol
                UnMarkSymbol;
                InsideSymbol := n;
                MarkSymbol(X, Y);
              end;
              SymbolFound := true;
              break;
            end;
        if not(SymbolFound) then
        begin
          UnMarkSymbol;
          InsideSymbol := 0;
          break;
        end;
        // inside the symbol but maybe Drag-Area leave or enter!
        if DragArea(X, Y) then
        begin
          // entered DragArea?
          if (InsideStatus = INSIDE_OTHER) then
            MarkSymbol(X, Y);
        end
        else
        begin
          // leaved DragArea?
          if (InsideStatus = INSIDE_DRAG) then
            MarkSymbol(X, Y);
        end;
        break;
      end;
      for n := DesktopAnz downto 1 do
        with DesktopSymbols[n] do
          if inside(X, Y, SymbolRect) then
          begin
            InsideSymbol := n;
            MarkSymbol(X, Y);
            break;
          end;
      break;
    end;
  end;
end;

procedure TFormHeBuBase.SetDragOn;
var
  n: Integer;
begin
  MoveBackGround.canvas.Draw(0, 0, ActPicture);
  // Symbole zeichne / außer das Inside-Symbol!
  for n := 1 to DesktopAnz do
    if n <> InsideSymbol then
      DrawSymbol(MoveBackGround.canvas, n);
  Drag := true;
end;

procedure TFormHeBuBase.DrawLED(canvas: TCanvas; LEDStatus: eLEDStatus);
var
  X, Y: Integer;
begin
  X := DesktopSymbols[InputID].SymbolRect.left;
  Y := DesktopSymbols[InputID].SymbolRect.top;
  with canvas do
    case LEDStatus of
      LED_GREEN:
        Draw(X + LEDPixelPosX, Y + LEDPixelPosY,
          Symbols[cSym_rLED_grun].sBitMap);
      LED_RED:
        Draw(X + LEDPixelPosX, Y + LEDPixelPosY,
          Symbols[cSym_rLED_rot].sBitMap);
      LED_ORANGE:
        Draw(X + LEDPixelPosX, Y + LEDPixelPosY,
          Symbols[cSym_rLED_gelb].sBitMap);
    else
      Draw(X + LEDPixelPosX, Y + LEDPixelPosY, Symbols[cSym_rLED_grau].sBitMap);
    end;
end;

procedure TFormHeBuBase.DrawBaseCount(canvas: TCanvas);
var
  X, Y, xl, yl: Integer;
  OutStr: string[80];
begin
  X := DesktopSymbols[InputID].SymbolRect.left;
  Y := DesktopSymbols[InputID].SymbolRect.top;
  with canvas do
  begin
    // Text ausgeben !!
    inc(X, INPUTCountPosX);
    inc(Y, INPUTCountPosY);
    brush.style := bssolid;
    brush.Color := clwhite; // grau
    font.Size := 10;
    font.Name := 'Arial';
    font.Color := clblack;
    font.style := [fsbold];
    xl := Textwidth('00000/00000 00000');
    yl := Textheight('0');
    fillrect(Rect(X, Y, X + xl, Y + yl));

    if (FoundAnz > 0) then
    begin
      OutStr := format('%d/%d', [succ(ActFound), FoundAnz]) + ' ';
    end
    else
    begin
      OutStr := format('%d/%d', [succ(DesktopSymbols[NotenID].SymbolData),
        NotenAnz]) + ' ';
    end;
    TextOut(X, Y, OutStr);

    if (FilterVictim > 0) then
    begin
      font.Color := clred;
      TextOut(X + Textwidth(OutStr), Y, format('%d', [FilterVictim]));
    end;
  end;
end;

procedure TFormHeBuBase.Timer1Timer(Sender: TObject);
var
  a, b: double;
  _VolumeActPosition: Integer;

  procedure SetFilterColor(FilterType: Integer; NewColor: Integer);
  var
    SymbolNo: Integer;
  begin
    SymbolNo := GetFilterID(FilterType);
    if SymbolNo <> -1 then
    begin
      DesktopSymbols[SymbolNo].SymbolOffset := NewColor;
      DrawSymbol(canvas, SymbolNo);
    end;
  end;

begin
  // Initialisieren geht ziemlich lange: erst mal sehn ob OK
  if Initialized and not(AppGoesDown) then
  begin

    // if not first refresh
    if not(FirstRefreshed) then
    begin
      inc(RefreshTick, Timer1.Interval);
      if RefreshTick > 6000 then
      begin
        FirstRefreshed := true;
        SetForeGroundWindow(application.Handle);
        beep;
      end;
    end;

    if FileExists(MyProgramPath + '\down.txt') then
    begin
      AppGoesDown := true;
      Close;
      NameForm.AppDown;
    end;

    // sound prüfen!
    if SoundCardInstalled then
      if (SoundState = SS_stop) then
      begin
        if not(WinAmpPlaying) then
        begin
          DrawSymbol(canvas, SoundID); // wieder play oder disabled!
          WinAmpHide;
          exit; // genug getan!
        end
        else
        begin
          a := VolumeControl1.WaveVolume / 255.0;
          b := VolumeMusikWayCount;
          _VolumeActPosition := round(a * b);
          if (_VolumeActPosition <> VolumeActPosition) then
          begin
            VolumeActPosition := _VolumeActPosition;
            DrawSymbol(canvas, SoundID);
            exit; // genug getan!
          end;
        end;
        if (GetForeGroundWindow = FindWindow('Winamp v1.x', nil)) then
          SetForeGroundWindow(application.Handle);
      end;

    if Drag or not(active) then
      exit;

    // such LED
    if (LEDStatus = LED_ORANGE) then
    begin
      inc(TimerTick);
      if (TimerTick = LEDonTimer) then
        DrawLED(canvas, LED_ORANGE);
      if (TimerTick = LEDoffTimer) then
      begin
        DrawLED(canvas, LED_OFF);
        TimerTick := 0;
      end;
    end;

    // Filter LEDs
    if OneFeldChecked or OnePreisChecked or OneSchwierigkeitsgradChecked or
      OneMusicChecked or OneNeuChecked or OneLandChecked or OneRubrikChecked
    then
    begin
      inc(FilterTicker);
      if (FilterTicker = LEDonTimer) then
      begin
        if OneFeldChecked then
          SetFilterColor(FILTER_FELDER, FilterRED);
        if OneLandChecked then
          SetFilterColor(FILTER_LAND, FilterRED);
        if OneSchwierigkeitsgradChecked then
          SetFilterColor(FILTER_SCHWER, FilterRED);
        if OnePreisChecked then
          SetFilterColor(FILTER_PREIS, FilterRED);
        if OneMusicChecked then
          SetFilterColor(FILTER_MUSIC, FilterRED);
        if OneNeuChecked then
          SetFilterColor(FILTER_NEU, FilterRED);
        if OneRubrikChecked then
          SetFilterColor(FILTER_RUBRIK, FilterRED);
      end;
      if (FilterTicker = LEDoffTimer) then
      begin
        if OneFeldChecked then
          SetFilterColor(FILTER_FELDER, FilterGREEN);
        if OneLandChecked then
          SetFilterColor(FILTER_LAND, FilterGREEN);
        if OneSchwierigkeitsgradChecked then
          SetFilterColor(FILTER_SCHWER, FilterGREEN);
        if OnePreisChecked then
          SetFilterColor(FILTER_PREIS, FilterGREEN);
        if OneMusicChecked then
          SetFilterColor(FILTER_MUSIC, FilterGREEN);
        if OneNeuChecked then
          SetFilterColor(FILTER_NEU, FilterGREEN);
        if OneRubrikChecked then
          SetFilterColor(FILTER_RUBRIK, FilterGREEN);
        FilterTicker := 0;
      end;
    end;
  end;
end;

procedure TFormHeBuBase.GetNotenDirect(no: Integer);
var
  _AnError: Boolean;

  procedure Scramble;
  const
    CRYPT_1 = 2; { must be 0-5    divisor }
    CRYPT_2 = 53; { must be 0-255  modifier }
    Key = 'ANFiSOFT';
    l = length(Key);
  type
    NotenCast = array [0 .. pred(sizeof(tDataBaseRec))] of byte;
  var
    n: Integer;
    c, t: byte;
  begin
    c := 0;
    for n := 0 to pred(sizeof(tDataBaseRec)) do
    begin
      if c = 255 then
        c := 0
      else
        inc(c);
      if (c mod 2) = 0 then
        t := (c shr CRYPT_1) xor byte(Key[(c mod l) + 1])
      else
        t := (abs(CRYPT_2 - c)) xor byte(Key[((c mod l) + 1) shr 1]);
      NotenCast(noten)[n] := NotenCast(noten)[n] xor t;
    end;
  end;

  function TheWasAnError: Boolean;
  begin
    if ioresult <> 0 then
      _AnError := true;
    result := _AnError;
  end;

begin
{$I-}
  _AnError := false;
  while true do
  begin
    seek(NotenF, no);
    if TheWasAnError then
      break;
    read(NotenF, noten);
    if TheWasAnError then
      break;
    break;
  end;
{$I+}
  if _AnError then
    fillchar(noten, sizeof(noten), 0)
  else
    Scramble;
end;

function TFormHeBuBase.KorbVoll: Boolean;
var
  n: Integer;
  r: TRect;
begin
  KorbAnz := 0;
  with DesktopSymbols[KorbID].SymbolRect do
    r := Rect(left, top, screen.width, screen.height);
  for n := 1 to DesktopAnz do
    with DesktopSymbols[n] do
      if SymbolType = SYM_MININOTEN then
      begin
        if inside(SymbolRect.left, SymbolRect.top, r) then
          inc(KorbAnz);
      end;
  result := KorbAnz > 0;
end;

procedure TFormHeBuBase.DoEdit;
const
  ArtikelNummerLength = 10;
  TitelLength = 20;
  PreisLength = 10;
  AddifTooLong = ' ...';
  StartLine = 15;
  LeftBorder = 8;
var
  n: Integer;
  r: TRect;
  lines: TStrings;
  EndPreis: single;
  TitelStr: string;
  LastLine: string;

  function fill(const s: string; count: Integer): string;
  var
    n: Integer;
  begin
    result := '';
    for n := 1 to count do
      result := result + s;
  end;

  function PreisStr(const preis: single; Stellen: Integer): string;
  begin
    result := format('%5.2f', [preis]);
    result := fill(' ', Stellen - length(result)) + result;
  end;

begin

  if HaendlerVersion then
    verlageform.showmodal;

  EndPreis := 0.0;
  MainForm.Editor.lines.LoadFromFile(ProgramFilesDir + cCodeName + '\Best' +
    inttostr(DesktopMode) + '.rtf');
  MainForm.SetFileName(ProgramFilesDir + cCodeName + '\Best' +
    inttostr(DesktopMode) + '.rtf');
  lines := MainForm.GetEditorStrings;
  LastLine := lines[pred(lines.count)];

  lines[2] := Name1 + ' * ' + strasse + ' * ' + PLZOrt;

  if (DesktopMode = 0) then // nur Hebu
  begin
    if HaendlerVersion then
    begin
      lines[4] := verlag.Name;
      lines[5] := verlag.strasse;
      lines[7] := verlag.Ort;
    end
    else
    begin
      lines[4] := LanguageSTr[pred(115)];
      lines[5] := LanguageSTr[pred(116)];
      lines[7] := LanguageSTr[pred(117)];
    end;
  end;

  while (lines.count > StartLine) do
    lines.delete(pred(lines.count));
  lines.Add('');

  with DesktopSymbols[KorbID].SymbolRect do
    r := Rect(left, top, screen.width, screen.height);
  for n := 1 to DesktopAnz do
    with DesktopSymbols[n] do
      if SymbolType = SYM_MININOTEN then
      begin
        if inside(SymbolRect.left, SymbolRect.top, r) then
        begin
          GetNotenDirect(SymbolData);
          with noten do
          begin

            if length(titel) > TitelLength then
              TitelStr := copy(titel, 1, TitelLength - length(AddifTooLong)) +
                AddifTooLong
            else
              TitelStr := titel + fill(' ', TitelLength - length(titel));

            if HaendlerVersion then
            begin
              lines.Add(fill(' ', LeftBorder) +
                format('1x %' + inttostr(ArtikelNummerLength) + 's %s %s %.2f ',
                [BestellNo, TitelStr, OrgCurrency, OrgPreis]));
              lines.Add(fill(' ', LeftBorder) +
                format('   (%' + inttostr(ArtikelNummerLength) + 's ',
                [ArtikelNo, PreisStr(preis, PreisLength)]));
            end
            else
            begin
              lines.Add(fill(' ', LeftBorder) +
                format('1x %' + inttostr(ArtikelNummerLength) + 's %s ',
                [ArtikelNo, TitelStr, PreisStr(preis, PreisLength)]));
            end;

            EndPreis := EndPreis + preis;
          end;
        end;
      end;

  lines.Add(fill(' ', LeftBorder) + fill(' ', ArtikelNummerLength + TitelLength
    + 5) + fill('=', PreisLength));
  lines.Add(fill(' ', LeftBorder) + fill(' ', ArtikelNummerLength + TitelLength
    - 4) + format(LanguageSTr[pred(76)] + ' %s ',
    [PreisStr(EndPreis, PreisLength)]));
  lines.Add('');
  lines.Add(fill(' ', LeftBorder) + LastLine);
  MainForm.SaveIt;
  MainForm.showmodal;
end;

procedure TFormHeBuBase.DoNotiz;
const
  ArtikelNummerLength = 10;
  TitelLength = 20;
  PreisLength = 10;
  AddifTooLong = ' ...';
  LeftBorder = 8;
var
  n: Integer;
  r: TRect;

  function fill(const s: string; count: Integer): string;
  var
    n: Integer;
  begin
    result := '';
    for n := 1 to count do
      result := result + s;
  end;

  function PreisStr(const preis: single; Stellen: Integer): string;
  begin
    result := format('%5.2f', [preis]);
    result := fill(' ', Stellen - length(result)) + result;
  end;

  procedure AddMuchText(AllTxt: string);
  var
    k: Integer;
  begin
    while true do
    begin
      if AllTxt = '' then
        break;
      k := pos(#$0D, AllTxt);
      if (k > 0) then
      begin
        MainForm.Editor.lines.Add(copy(AllTxt, 1, pred(k)));
        AllTxt := copy(AllTxt, succ(k), MaxInt);
      end
      else
      begin
        MainForm.Editor.lines.Add(AllTxt);
        break;
      end;
    end;
  end;

begin
  // Trichedit
  MainForm.Editor.lines.clear;
  MainForm.Editor.font.Name := 'Courier New';
  MainForm.Editor.font.Size := 10;
  MainForm.Editor.font.style := [fsbold];

  with DesktopSymbols[NotizID].SymbolRect do
    r := Rect(left, top, screen.width,
      pred(DesktopSymbols[KorbID].SymbolRect.top));
  for n := 1 to DesktopAnz do
    with DesktopSymbols[n] do
      if SymbolType = SYM_MININOTEN then
      begin
        if inside(SymbolRect.left, SymbolRect.top, r) then
        begin
          GetNotenDirect(SymbolData);
          with noten do
          begin
            if Mode = 1 then
            begin
              MainForm.Editor.lines.Add('');
              MainForm.Editor.lines.Add(ArtikelNo + ' ' + titel);
              MainForm.Editor.lines.Add
                (fill('=', length(ArtikelNo + ' ' + titel)));
              MainForm.Editor.lines.Add(land + '-' + verlag);
              MainForm.Editor.lines.Add('');

              if (_Komposition <> '') then
                AddMuchText(_Komposition);
              if (_Bemerkung <> '') then
                AddMuchText(_Bemerkung);

              if komponist <> '' then
                MainForm.Editor.lines.Add(komponist + ' ' + LanguageSTr
                  [pred(77)]);
              if _UeberKomponist <> '' then
                AddMuchText(_UeberKomponist);
              if arranger <> '' then
                MainForm.Editor.lines.Add(arranger + ' ' + LanguageSTr
                  [pred(78)]);
              if _UeberArranger <> '' then
                AddMuchText(_UeberArranger);
              MainForm.Editor.lines.Add(LanguageSTr[pred(79)] + ' ' + schwer);
              MainForm.Editor.lines.Add(LanguageSTr[pred(80)] + ' ' +
                PreisStr(preis, PreisLength));
              MainForm.Editor.lines.Add(LanguageSTr[pred(81)] + ' ' + Serie);
              MainForm.Editor.lines.Add(LanguageSTr[pred(82)] + ' ' + dauer);
              MainForm.Editor.lines.Add(LanguageSTr[pred(83)] + ' ' +
                ProbeStimme);
              MainForm.Editor.lines.Add(LanguageSTr[pred(84)] + ' ' + Aufnahme);
              MainForm.Editor.lines.Add(LanguageSTr[pred(85)] + ' ' + Sparte);
            end
            else
            begin
              // 91000 Bei Tanze (Polka)   Guido Henn  2  38,-
              MainForm.Editor.lines.Add(ArtikelNo + fill(' ',
                10 - length(ArtikelNo)) + copy(titel + fill(' ',
                40 - length(titel)), 1, 40) + komponist + fill(' ',
                20 - length(komponist)) + schwer + fill(' ', 5 - length(schwer))
                + PreisStr(preis, PreisLength));
            end;
          end;
        end;
      end;

  MainForm.Editor.lines.Add('');
  MainForm.SetFileName(ProgramFilesDir + cCodeName + '\Notiz' +
    inttostr(DesktopMode) + '.rtf');
  MainForm.SaveIt;
  MainForm.showmodal;
end;

function TFormHeBuBase.NotizVoll: Boolean;
var
  n: Integer;
  r: TRect;
begin
  NotizAnz := 0;
  with DesktopSymbols[NotizID].SymbolRect do
    r := Rect(left, top, screen.width, DesktopSymbols[KorbID].SymbolRect.top);
  for n := 1 to DesktopAnz do
    with DesktopSymbols[n] do
      if SymbolType = SYM_MININOTEN then
      begin
        if inside(SymbolRect.left, SymbolRect.top, r) then
          inc(NotizAnz);
      end;
  result := NotizAnz > 0;
end;

function TFormHeBuBase.PreisToString(const s: string): single;
var
  n: Integer;
  StartZiffer, EndZiffer: Integer;
begin
  // suche erste Ziffer
  for n := 1 to length(s) do
    if s[n] in ['0' .. '9'] then
    begin
      StartZiffer := n;
      break;
    end;

  // letzte Ziffer suchen
  for n := succ(StartZiffer) to length(s) do
    if not(s[n] in ['0' .. '9']) then
    begin
      EndZiffer := pred(n);
      break;
    end;

  // Ergebnis = <ErsteZiffer>..<LetzteZiffer>
  result := strtofloat(copy(s, StartZiffer, succ(EndZiffer - StartZiffer)));
  // ShowMessage(floattostr(result));
end;

procedure TFormHeBuBase.FormActivate(Sender: TObject);

var
  n: Integer;
  SymbolPool: TBitMap; // gesamter Symbol-Pool
  VolumeWayStrings: TStringList;
  BigStr: string;

  procedure SymbolAdd(var symbol: tSymbolPosition; HeadID, BodyID: Word);
  begin
    with symbol do
    begin
      sBitMap := TBitMap.create;

      // 3+5
      SetBitMapSizeTo(sBitMap, rXl(Symbols[HeadID].OwnSize) +
        rXl(Symbols[BodyID].OwnSize) - 2, ryl(Symbols[HeadID].OwnSize));

      // Kopf-Stück kopieren
      Spos := Symbols[HeadID].Spos;
      OwnSize.left := 0;
      OwnSize.top := 0;
      OwnSize.right := pred(rXl(Spos));
      OwnSize.bottom := pred(ryl(Spos));
      sBitMap.canvas.copyrect(SizeCorrect(OwnSize), SymbolPool.canvas,
        SizeCorrect(Spos));

      // Text-Stück kopieren
      Spos := Symbols[BodyID].Spos;
      inc(Spos.left, 1);
      OwnSize.left := rXl(Symbols[HeadID].Spos) - 1;
      OwnSize.top := 0;
      rSize(Spos, OwnSize);
      sBitMap.canvas.copyrect(SizeCorrect(OwnSize), SymbolPool.canvas,
        SizeCorrect(Spos));

      sBitMap.transparent := true;
      // sBitMap.SaveToFile('G:\' + inttostr(random(10)) + '.bmp');

    end;
  end;

begin
  if not(Initialized) then
  begin
    VolumeControl1 := TVolumeControl.create(self);
    if MesseMode then
      SetMousePos(800, 600);

    // intro Sound!
    if SoundCardInstalled then
    begin

      if FileExists(SystemPath + '\..\Musik\intro.mp3') then
      begin
        WinAmpPlayFile(SystemPath + '\..\Musik\intro.mp3');
        WinAmpShow;
      end;
    end;

    screen.cursor := crHourGlass;
    NotenCacheEl := MaxInt;
    FilterEditor := -1;
    MinFontSize := 8;

    // Rubrik-Strings füllen
    RubrikStrings.clear;
    RubrikKuerzel.clear;
    BigStr := LanguageSTr[pred(143)];
    while (BigStr <> '') do
    begin
      RubrikKuerzel.Add(NextP(BigStr, ':'));
      RubrikStrings.Add(NextP(BigStr, ';'));
    end;

    // Filter "Feld" setzten!
    for n := 1 to FeldNamenAnz do
      FeldChecks[n] := true;

    // Filter "Rubrik" alle setzen!
    for n := 1 to RubrikStrings.count do
      RubrikChecks[n] := true;

    TxtLager := TBLager.create;
    OpenDataBase;

    // Symbole
    LoadSymbolPositions;
    SymbolPool := TBitMap.create;
    SymbolPool.LoadFromFile(SystemPath + '\sym' + LanguageDriver + '.bmp');

    ActPicture := TBitMap.create;
    SetBitMapSizeTo(ActPicture, screen.width, screen.height);

    // Move-Hintergrund
    MoveBackGround := TBitMap.create;
    SetBitMapSizeTo(MoveBackGround, screen.width, screen.height);

    // Noten-Cache
    NotenCache := TBitMap.create;
    SetBitMapSizeTo(NotenCache, cNotenBlattXL, cNotenBlattYL);
    NotenCache.transparent := true;

    // Noten-Papier
    NotenPaper := TBitMap.create;

    // Roh-Symbole !alle! laden
    for n := 1 to SymbolAnz do
    begin
      with Symbols[n] do
      begin
        sBitMap := TBitMap.create;
        SetBitMapSizeTo(sBitMap, rXl(Spos), ryl(Spos));

        // jetz reinkopieren, zuvor müssen aber die Rects angepasst werden
        // komisch eigentlich ein Fehler im Delphi oder?!
        // ->nein: Win32 API ist so definiert!
        sBitMap.canvas.copyrect(SizeCorrect(OwnSize), SymbolPool.canvas,
          SizeCorrect(Spos));
        sBitMap.transparent := true;
      end;
    end;

    // hier beginnen die Filter!
    FilterSymbolOffset := SymbolAnz;

    // richtige Symbole zusammensetzten -> 4 (dunkelgrün) + 5/6/7/8/9
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rdunkelgrun, cSym_feld);
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rdunkelgrun, cSym_land);
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rdunkelgrun, cSym_schwer);
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rdunkelgrun, cSym_preis);
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rdunkelgrun, cSym_musik);
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rdunkelgrun, cSym_neu);
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rdunkelgrun, cSym_Rubrik);

    // richtige Symbole zusammensetzten -> 3 (hellgrün) + 5/6/7/8/9
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rgrun, cSym_feld);
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rgrun, cSym_land);
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rgrun, cSym_schwer);
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rgrun, cSym_preis);
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rgrun, cSym_musik);
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rgrun, cSym_neu);
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rgrun, cSym_Rubrik);

    // richtige Symbole zusammensetzten -> 2 (rot) + 5/6/7/8/9
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rrot, cSym_feld);
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rrot, cSym_land);
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rrot, cSym_schwer);
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rrot, cSym_preis);
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rrot, cSym_musik);
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rrot, cSym_neu);
    inc(SymbolAnz);
    SymbolAdd(Symbols[SymbolAnz], cSym_rrot, cSym_Rubrik);

    // Symbole wieder frei lassen!
    SymbolPool.free;

    // Texte für die Filter!
    PreisStrings := TStringList.create;
    for n := 2 to 20 do
      PreisStrings.Add(LanguageSTr[pred(n)]);

    SchwierigkeitsgradStrings := TStringList.create;
    for n := 1 to 6 do
      SchwierigkeitsgradStrings.Add(format('%d', [n]));

    LandStrings := TStringList.create;
    BigStr := LanguageSTr[pred(21)] + ',';
    while pos(',', BigStr) > 0 do
    begin
      LandStrings.Add(copy(BigStr, 1, pred(pos(',', BigStr))));
      BigStr := copy(BigStr, succ(pos(',', BigStr)), MaxInt);
    end;
    LandStrings.sort;

    // Musik-Medien
    MusicStrings := TStringList.create;
    for n := 0 to pred(MusicMedias.count) do
      MusicStrings.Add(copy(MusicMedias[n], 1, pred(pos(',', MusicMedias[n]))));

    // Neuerscheinungen
    NeuStrings := TStringList.create;
    // NeuStrings.add(LanguageStr[pred(93)]);
    // NeuStrings.add(Format(LanguageStr[pred(94)],['01.01.1998']));
    NeuStrings.Add(LanguageSTr[pred(95)]);

    // Volume-Regler Weg laden
    VolumeWayStrings := TStringList.create;
    VolumeWayStrings.LoadFromFile(SystemPath + '\VolWay.ini');
    for n := 0 to pred(VolumeWayStrings.count) do
      VolumeMusikWay[succ(n)] := str2point(VolumeWayStrings[n]);
    VolumeMusikWayCount := VolumeWayStrings.count;
    VolumeWayStrings.free;

  end;
  if (DesktopAnz = 0) then
  begin
    // Desktop aufbauen ###
    RefreshDesktop;
    SetDefaultCursor;
  end;
  Initialized := true;
end;

procedure TFormHeBuBase.SetDesktopTo(const FName: string);
var
  DskB: TPicture;
begin
  DskB := TPicture.create;
  StartDebug('lade "' + FName + '" ...');
  DskB.LoadFromFile(FName);
  ActPicture.canvas.Draw(0, 0, DskB.Graphic);

  // ev. zoomen!
  if not((DskB.width = screen.width) and (DskB.height = screen.height)) then
    ActPicture.canvas.copyrect(Rect(0, 0, screen.width, screen.height),
      ActPicture.canvas, Rect(0, 0, DskB.width, DskB.height));

  if not(MesseMode) then
    case DesktopMode of
      0:
        begin
          ActPicture.canvas.Draw(10, 0, Symbols[cSym_HeBu].sBitMap); // HeBu
        end;
      1:
        begin
          ActPicture.canvas.Draw(10, 0, Symbols[cSym_Obermayer].sBitMap);
          // Obermayer
        end;
    end;

  DskB.free;
end;

procedure TFormHeBuBase.FormCreate(Sender: TObject);
begin
  top := 0;
  left := 0;
  width := screen.width;
  height := screen.height;
  BorderStyle := bsNone;
  Color := clblue;
  uMsgQueryCancelAutoPlay := RegisterWindowMessage('QueryCancelAutoPlay');
  Symbols[0].sBitMap := TBitMap.create; // dummy BitMap
  SymbolPosData := TStringList.create;
  RubrikStrings := TStringList.create;
  RubrikKuerzel := TStringList.create;
end;

procedure TFormHeBuBase.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // close all Forms that this may opened
{$IFDEF HeBuAdmin}
  if formbelege.visible then
    with formbelege do
    begin
      SetFocus;
      IB_LocateEdit1.SetFocus;
      IB_LocateEdit1.Text := noten.ArtikelNo;
      IB_LocateEdit1.locate;
    end;
  if FormArtikel.visible then
    with FormArtikel do
    begin
      SetFocus;
      IB_LocateEdit1.SetFocus;
      IB_LocateEdit1.Text := noten.ArtikelNo;
      IB_LocateEdit1.locate;
    end;
{$ENDIF}
  StartDebug('1');
  SaveDeskTop;
  StartDebug('2');
  MiniTexteForm.Close;
  StartDebug('3');
  FilterForm.Close;
  StartDebug('4');
  ListenAnsichtForm.Close;
  StartDebug('5');
  HilfeForm.Close;
  StartDebug('6');
end;

procedure TFormHeBuBase.PlayThisSound;
var
  SearchMask: string;
  MusikPath: string;
  AllMusikFNames: TStringList;
  n: Integer;
begin
  if SoundCardInstalled then
  begin
    // Look at all files

    AllMusikFNames := TStringList.create;
    MusikPath := AnsiUpperCase(ExtractFilePath(MusikFName));
    ersetze('SYSTEM\..\', '', MusikPath);

    SearchMask := MusikFName;
    ersetze('.mp3', '*.mp3', SearchMask);
    dir(SearchMask, AllMusikFNames, false);
    SoundsToPlay := AllMusikFNames.count;

    if (SoundsToPlay > 0) then
    begin
      if not(WinAmpRunning) then
        WinAmpLoadUp;

      screen.cursor := crHourGlass;

      WinAmpClearPlayList;
      AllMusikFNames.sort;

      // Nach weiteren Titeln suchen
      for n := 0 to pred(AllMusikFNames.count) do
        WinAmpAddOneFile(MusikPath + AllMusikFNames[n]);

      WinAmpShow;
      WinAmpPlay;
      sleep(500);
      application.processmessages;
      DrawSymbol(canvas, SoundID);
      SetDefaultCursor;

    end
    else
    begin
      ShowMessage(format(LanguageSTr[pred(118)],
        [SearchMask, MusicStrings[pred(noten.SoundSource)]]));
    end;
    AllMusikFNames.free;
  end
  else
  begin
    ShowMessage(LanguageSTr[pred(86)]);
  end;
end;

procedure TFormHeBuBase.SetNewVolume(NewVolume: Integer);
begin
end;

function TFormHeBuBase.MusikFName: string;
begin
  with noten do
  begin
    MusikFName := SystemPath + '\..\Musik\' + noblank(ArtikelNo) + '.mp3';
  end;
end;

function TFormHeBuBase.MusikCount: Integer;
var
  MusikMask: string;
  AllMusikFNames: TStringList;
begin
  AllMusikFNames := TStringList.create;
  MusikMask := AnsiUpperCase(MusikFName);
  ersetze('SYSTEM\..\', '', MusikMask);
  ersetze('.MP3', '*.MP3', MusikMask);
  dir(MusikMask, AllMusikFNames, false);
  result := AllMusikFNames.count;
  AllMusikFNames.free;
end;

function TFormHeBuBase._Bemerkung: string;
begin
  result := GetTxtNo(noten.Bemerkung);
end;

function TFormHeBuBase._Komposition: string;
begin
  result := GetTxtNo(noten.Komposition);
end;

function TFormHeBuBase._Preis: string;
const
  cPreis_vergriffen = -1.0;
  cPreis_aufAnfrage = -2.0;
  cPreis_unbekannt = -3.0;
  cPreis_ungesetzt = -4.0;

begin
  if (-1.0 = noten.preis) then
    result := 'Vergriffen'
  else if (-2.0 = noten.preis) then
    result := 'Preis auf Anfrage'
  else if (-3.0 = noten.preis) then
    result := 'Preis Unbekannt'
  else if (-4.0 = noten.preis) then
    result := 'Keine Preisangabe'
  else
    result := format('%m', [noten.preis]);
end;

function TFormHeBuBase._UeberKomponist: string;
begin
  result := GetTxtNo(noten.UeberKomponist);
end;

function TFormHeBuBase._UeberArranger: string;
begin
  result := GetTxtNo(noten.UeberArranger);
end;

function TFormHeBuBase.GetTxtNo(no: Integer): string;
begin
  if no = 0 then
    result := ''
  else
  begin
    if TxtLager.exist(no) then
    begin
      TxtLager.get;
      result := ReallyBigStr;
    end
    else
    begin
      result := 'FAIL:TxtLager.GetTxtNo(' + inttostr(no) + ')';
    end;
  end;
end;

procedure TFormHeBuBase.RunListenAnsicht;
var
  n: Integer;
  MyAllString: TStringList;
begin
  if FoundAnz = 0 then
  begin
    ShowMessage(LanguageSTr[pred(65)]);
  end
  else
  begin
    with ListenAnsichtForm do
    begin
      if (ListBox1.Items.count = 0) or LastWasRunMusik then
      begin
        screen.cursor := crHourGlass;
        MyAllString := TStringList.create;
        for n := 1 to FoundAnz do
        begin
          GetNotenDirect(Integer(WrdIdx.FoundList[n]));
          MyAllString.Add(noten.titel + ', ' + noten.komponist + ', ' +
            noten.arranger + ', ' + noten.verlag + ' \' + inttostr(n));
        end;
        MyAllString.Sorted := true;
        ListBox1.Items.addStrings(MyAllString);
        MyAllString.free;
        SetDefaultCursor;
      end;
      show;
      SetFocus;
      ListBox1.SetFocus;
    end;
  end;
  LastWasRunMusik := false;
end;

procedure TFormHeBuBase.CreateWebExport;
const
  cMusikFName = '\WebExport.csv';
  cCSVDelimiter = ',';
var
  n: Integer;
  MyAllString: TStringList;
  MyTick: dword;

  function CSV_text(s: string): string;
  begin
    result := '"' + ansi2html(cutblank(s)) + '"';
  end;

  function CSV_preis(s: single): string;
  begin
    result := inttostr(trunc(s)) + '.' +
      inttostrN(round((s - trunc(s)) * 100.0), 2);
  end;

begin
  // prüfen, ob schon vorhanden
  //
  screen.cursor := crHourGlass;
  MyAllString := TStringList.create;
  MyAllString.Add('ArtikelNo' + cCSVDelimiter + 'Land' + cCSVDelimiter + 'Titel'
    + cCSVDelimiter + 'Komponist' + cCSVDelimiter + 'Arranger' + cCSVDelimiter +
    'schwer' + cCSVDelimiter + 'preis' + cCSVDelimiter + 'verlag' +
    cCSVDelimiter + 'Serie' + cCSVDelimiter + 'Dauer' + cCSVDelimiter +
    'ProbeStimme' + cCSVDelimiter + 'Aufnahme' + cCSVDelimiter + 'Sparte' +
    cCSVDelimiter + 'Bemerkung' + cCSVDelimiter + 'Komposition' + cCSVDelimiter
    + 'UeberKomponist' + cCSVDelimiter + 'UeberArranger' + cCSVDelimiter +
    'PaperColor' + cCSVDelimiter + 'OrgBestellNo' + cCSVDelimiter + 'OrgPreis' +
    cCSVDelimiter + 'OrgCurrency' + cCSVDelimiter + 'EntryDate' + cCSVDelimiter
    + 'SoundSource');

  MyTick := GetTickCount;
  ProgressBar1.max := NotenAnz;
  ProgressBar1.position := 0;
  ProgressBar1.visible := true;
  for n := 0 to pred(NotenAnz) do
  begin
    GetNotenDirect(n);
    with noten do
    begin
      MyAllString.Add(ArtikelNo + cCSVDelimiter + '"' + land + '"' +
        cCSVDelimiter + CSV_text(titel) + cCSVDelimiter + CSV_text(komponist) +
        cCSVDelimiter + CSV_text(arranger) + cCSVDelimiter + CSV_text(schwer) +
        cCSVDelimiter + CSV_preis(preis) + cCSVDelimiter + CSV_text(verlag) +
        cCSVDelimiter + CSV_text(Serie) + cCSVDelimiter + CSV_text(dauer) +
        cCSVDelimiter + CSV_text(ProbeStimme) + cCSVDelimiter +
        CSV_text(Aufnahme) + cCSVDelimiter + CSV_text(Sparte) + cCSVDelimiter +
        CSV_text(_Bemerkung) + cCSVDelimiter + CSV_text(_Komposition) +
        cCSVDelimiter + CSV_text(_UeberKomponist) + cCSVDelimiter +
        CSV_text(_UeberArranger) + cCSVDelimiter + TColor2HTMLColor(PaperColor)
        + cCSVDelimiter + CSV_text(BestellNo) + cCSVDelimiter +
        CSV_preis(OrgPreis) + cCSVDelimiter + CSV_text(OrgCurrency) +
        cCSVDelimiter + long2date(EntryDate) + cCSVDelimiter +
        inttostr(SoundSource));
    end;
    if frequently(MyTick, 500) then
    begin
      application.processmessages;
      ProgressBar1.position := n;
    end;
  end;
  MyAllString.SaveToFile(SystemPath + cMusikFName);
  MyAllString.free;
  ProgressBar1.position := 0;
  ProgressBar1.visible := false;
  SetDefaultCursor;
end;

procedure TFormHeBuBase.RunMusikAnsicht;
const
  cMusikFName = '\MitMusik.txt';
var
  n: Integer;
  MyAllString: TStringList;
  MyTick: dword;
begin
  // prüfen, ob schon vorhanden
  if FileAge(SystemPath + cMusikFName) <
    FileAge(SystemPath + '\artikel' + inttostr(DesktopMode) + '.bin') then
  begin
    //
    screen.cursor := crHourGlass;
    MyAllString := TStringList.create;
    MyTick := GetTickCount;
    ProgressBar1.max := NotenAnz;
    ProgressBar1.position := 0;
    ProgressBar1.visible := true;
    for n := 0 to pred(NotenAnz) do
    begin
      GetNotenDirect(n);
      if MusikCount > 0 then
        with noten do
          MyAllString.Add(titel + ', ' + komponist + ', ' + arranger + ', ' +
            verlag + ' \0' + inttostr(n));
      if frequently(MyTick, 500) then
      begin
        application.processmessages;
        ProgressBar1.position := n;
      end;
    end;
    MyAllString.sort;
    MyAllString.Add(inttostr(MyAllString.count) + ' Titel!, ' + MyAllString
      [pred(MyAllString.count)]);
    MyAllString.SaveToFile(SystemPath + cMusikFName);
    MyAllString.free;
    ProgressBar1.position := 0;
    ProgressBar1.visible := false;
    SetDefaultCursor;
  end;

  with ListenAnsichtForm do
  begin
    if not(LastWasRunMusik) or (ListBox1.count = 0) then
      ListBox1.Items.LoadFromFile(SystemPath + cMusikFName);
    show;
    SetFocus;
    ListBox1.SetFocus;
    LastWasRunMusik := true;
  end;

end;

function TFormHeBuBase.FindArtikelNo(InpStr: string): Integer; // Index
var
  n: Integer;
begin
  result := 0;
  WrdIdx.Search(InpStr);
  with WrdIdx.FoundList do
    for n := pred(count) downto 0 do
    begin
      GetNotenDirect(Integer(Items[n]));
      if (noten.ArtikelNo <> InpStr) then
        delete(n);
    end;
  if (WrdIdx.FoundList.count > 0) then
    result := Integer(WrdIdx.FoundList[0]);
  // ok?
  FilterVictim := 0;
  FoundAnz := 0;
end;

procedure TFormHeBuBase.DeleteMiniNote(InsideSymbol: Integer);
var
  n: Integer;
begin
  // MiniSymbol freigeben
  MiniNoten[DesktopSymbols[InsideSymbol].SymbolOffset].free;
  MiniNoten[DesktopSymbols[InsideSymbol].SymbolOffset] := nil;
  // aus Desktop löschen
  for n := InsideSymbol to pred(DesktopAnz) do
    DesktopSymbols[n] := DesktopSymbols[succ(n)];
  dec(DesktopAnz);
end;

procedure TFormHeBuBase.WndProc(var Message: TMessage);
begin
  if (Message.Msg = uMsgQueryCancelAutoPlay) then
    Message.result := 1 // 1 = kein AutoPlay, 0 = AutoPlay erlaubt
  else
    inherited WndProc(Message);
end;

procedure TFormHeBuBase.SetFeldFilterAutor;
begin
  OneFeldChecked := true;
  FeldChecks[1] := false;
  FeldChecks[2] := true;
  FeldChecks[3] := true;
  FeldChecks[4] := false;
  FeldChecks[5] := false;
  FeldChecks[6] := false;
  FeldChecks[7] := false;
  FeldChecks[8] := false;
  FeldChecks[9] := false;
end;

procedure TFormHeBuBase.UnSetFeldFilterAutor;
begin
  OneFeldChecked := false;
  FeldChecks[1] := false;
  FeldChecks[2] := false;
  FeldChecks[3] := false;
  FeldChecks[4] := false;
  FeldChecks[5] := false;
  FeldChecks[6] := false;
  FeldChecks[7] := false;
  FeldChecks[8] := false;
  FeldChecks[9] := false;
end;

procedure TFormHeBuBase.StartWithDesktop(no: Integer);
begin
  DesktopMode := no; //
  DesktopAnz := 0; // Force to load desktop
  showmodal;
end;

procedure TFormHeBuBase.MiniNotenBringToTop(no: Integer);
var
  n: Integer;
  TopMiniNotenIndex: Integer;
  FirstMiniNotenIndex: Integer;
  _MiniNotenAnz: Integer;
  DesktopTemp: tDesktopSymbol;
begin
  _MiniNotenAnz := 0;
  FirstMiniNotenIndex := 0;
  for n := 1 to DesktopAnz do
    if (DesktopSymbols[n].SymbolType = SYM_MININOTEN) then
    begin
      inc(_MiniNotenAnz);
      TopMiniNotenIndex := n;
      if FirstMiniNotenIndex = 0 then
        FirstMiniNotenIndex := n;
    end;
  if (_MiniNotenAnz > 1) and (TopMiniNotenIndex <> no) then
  begin
    // imp pend, swap ist eigentlich falsch, ein schieben aller
    // das "no" geht an die Spitze, alle anderen rutschen in
    // die entstandene Lücke ab!
    // swap no <-> TopMiniNotenIndex
    DesktopTemp := DesktopSymbols[TopMiniNotenIndex];
    DesktopSymbols[TopMiniNotenIndex] := DesktopSymbols[no];
    DesktopSymbols[no] := DesktopTemp;
  end;
end;

function TFormHeBuBase.MiniNotenAnz: Integer;
var
  n: Integer;
begin
  result := 0;
  for n := 1 to DesktopAnz do
    if (DesktopSymbols[n].SymbolType = SYM_MININOTEN) then
      inc(result);
end;

procedure TFormHeBuBase.FillTrackInfo;
var
  InpStr: string;
  InpStr2: string;
  ActTrack: Integer;
begin
  with FormTrackAnsicht do
  begin
    GetNotenDirect(DesktopSymbols[NotenID].SymbolData);
    caption := noten.Serie;
    ListView1.Items.BeginUpdate;
    ListView1.Items.clear;
    InpStr := _UeberKomponist;
    InpStr2 := _UeberArranger;
    ActTrack := 0;
    while (InpStr <> '') do
    begin
      with ListView1.Items.Add do
      begin
        {
          if random(3)=1 then
          ImageIndex := 1
          else
        }
        ImageIndex := -1;

        inc(ActTrack);
        caption := inttostrN(ActTrack, 2);
        subitems.Add(NextP(InpStr, '|'));
        subitems.Add(NextP(InpStr, '|'));
        subitems.Add(NextP(InpStr, '|'));
        subitems.Add(NextP(InpStr, '|'));
        subitems.Add(NextP(InpStr, '¦'));
        subitems.Add(NextP(InpStr2, '¦'));
      end;
    end;
    ListView1.Items.EndUpdate;
    ListView1.selected := ListView1.Items[0];
  end;
end;

function TFormHeBuBase.GetButtonNumber(X, Y: Integer;
  PreFixName: string): Integer;
var
  ParentRect: TRect;
  n: Integer;
begin
  // default-result
  result := -1;

  // Eltern-Symbol suchen!
  for n := 0 to pred(SymbolPosData.count) do
    if SymbolPosData[n][1] = AnsiUpperCase(PreFixName[1]) then
      ParentRect := Str2Rect(copy(SymbolPosData[n],
        succ(pos('=', SymbolPosData[n])), MaxInt));

  // Verschieben
  inc(X, ParentRect.left);
  inc(Y, ParentRect.top);

  // Kind-Symbol suchen!
  for n := 0 to pred(SymbolPosData.count) do
    if SymbolPosData[n][1] = PreFixName[1] then
      if inside(X, Y, Str2Rect(copy(SymbolPosData[n],
        succ(pos('=', SymbolPosData[n])), MaxInt))) then
      begin
        result := Strtoint(SymbolPosData[n][2]);
        break;
      end;
end;

function TFormHeBuBase.GetFilterID(FilterType: Integer): Integer;
var
  n: Integer;
begin
  result := -1;
  for n := FilterID to FilterID + pred(cFILTER_ANZ) do
    with DesktopSymbols[n] do
    begin
      if (SymbolType <> SYM_FILTERBUTTON) then
        break;
      if (SymbolData = FilterType) then
      begin
        result := n;
        break;
      end;
    end;
end;

procedure TFormHeBuBase.UnInstallLinks;
begin
end;

function TFormHeBuBase.LandKurz(LandLang: string): string;
var
  n, k: Integer;
begin
  result := '';
  for n := 0 to pred(LandStrings.count) do
  begin
    k := pos('-' + AnsiUpperCase(LandLang), AnsiUpperCase(LandStrings[n]));
    if (k > 0) then
    begin
      result := copy(LandLang, 1, pred(pos('-', LandStrings[n])));
      break;
    end;
  end;
end;

procedure TFormHeBuBase.SwitchDesktop;
begin
  screen.cursor := crHourGlass;
  SaveDeskTop;
  CloseDataBase;
  inc(DesktopMode);
  if (DesktopMode = 2) then
    DesktopMode := 0;
  OpenDataBase;
  RefreshDesktop;
  paint;
  SetDefaultCursor;
end;

procedure TFormHeBuBase.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  StartDebug('HeBuBase.FormCloseQuery');
  if not(MesseMode) or (AppGoesDown) then
  begin
    AppGoesDown := true;
    CanClose := true;
  end
  else
  begin
    CanClose := false;
  end;
end;

procedure TFormHeBuBase.ShowTitelInfo(X, Y: Integer);
var
  OutStr: string;
  _sparte: string;
  k: Integer;
begin
  MiniTexteForm.hide;
  with noten do
  begin
    OutStr := titel + #$0D;
    if DesktopMode = 1 then
    begin
      // Obermayer
      if (Sparte <> '') then
      begin
        OutStr := OutStr + LanguageSTr[pred(145)] + ' : ';
        _sparte := Sparte;
        while _sparte <> '' do
        begin
          k := RubrikKuerzel.Indexof(NextP(_sparte, ','));
          if k <> -1 then
            OutStr := OutStr + RubrikStrings[k] + ', ';
        end;
        delete(OutStr, length(OutStr) - 1, 2);
        OutStr := OutStr + #$0D + #$0D;
      end;

      if (schwer <> '') then
        OutStr := OutStr + LanguageSTr[pred(147)] + ' : ' + schwer +
          #$0D + #$0D;

      OutStr := OutStr + _Bemerkung;
    end
    else
    begin
      if (Serie <> '') then
        OutStr := OutStr + LanguageSTr[pred(70)] + ' ' + Serie + #$0D;
      if _Bemerkung <> '' then
        OutStr := OutStr + _Bemerkung + #$0D;
      if dauer <> '' then
        OutStr := OutStr + LanguageSTr[pred(71)] + ' ' + dauer + #$0D;
      if ProbeStimme = 'ja' then
        OutStr := OutStr + LanguageSTr[pred(72)] + #$0D;
      if Aufnahme <> '' then
        OutStr := OutStr + LanguageSTr[pred(73)] + ' ' + Aufnahme + #$0D;
      if Sparte <> '' then
        OutStr := OutStr + LanguageSTr[pred(74)] + ' ' + Sparte + #$0D;
      if _Komposition <> '' then
        OutStr := OutStr + _Komposition + #$0D;
      if SoundSource > 0 then
        OutStr := OutStr + format(LanguageSTr[pred(98)],
          [MusicStrings[pred(SoundSource)]]) + #$0D;
      OutStr := OutStr + #$0D + '(Taste <ESC> schließt dieses Fenster)';
    end;
  end;
  MiniTexteForm.left := X;
  MiniTexteForm.top := Y;
  MiniTexteForm.WriteOut(OutStr);
end;

procedure TFormHeBuBase.SetDefaultCursor;
begin
  if MesseMode then
    screen.cursor := crnone
  else
    screen.cursor := crdefault;
end;

end.
