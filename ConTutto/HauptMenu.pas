unit HauptMenu;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  ExtCtrls, globals,
  // imp pend: BrowseDr,
  splash, shellapi;

type
  ExecuteModeType = (EM_Immedia, EM_Browser, EM_installTest);

  THauptMenue = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Label2MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Label3MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Label1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Label5MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Label4MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Label6MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Label6Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private-Deklarationen }
    FormFactorX: double;
    FormFactorY: double;
    ColRes: byte;
    StartX, StartY: Word;
    ExecuteMode: ExecuteModeType;
    FirstX: Integer;
    FirstY: Integer;
    AllPositions: TStringList;

    procedure WMEraseBkgnd(var m: TWMEraseBkgnd); message WM_ERASEBKGND;
    function DoubleMult(i: Integer; d: double): Integer;
    procedure SetRect(SymName: string; PosObj: TLabel);
    procedure MayClose(X, Y: Integer);
    procedure StartDatenbank; // Datenbank

  public
    { Public-Deklarationen }
  end;

var
  HauptMenue: THauptMenue;

implementation

uses
  HeBuBase, WirUeber, Name,
  winamp, anfix32, noten,
  InstallComponent, SystemSettings, verlage,
  ObermayerImport, IniFiles, wanfix32;

{$R *.DFM}
// tools,

function THauptMenue.DoubleMult(i: Integer; d: double): Integer;
var
  faktor: double;
  DoubleResult: double;
begin
  faktor := i;
  DoubleResult := faktor * d;
  result := round(DoubleResult);
end;

procedure THauptMenue.WMEraseBkgnd(var m: TWMEraseBkgnd);
begin
  m.result := LRESULT(false);
end;

procedure THauptMenue.SetRect(SymName: string; PosObj: TLabel);
var
  r: TRect;
begin
  r := Str2Rect(AllPositions.values[SymName]);
  with PosObj do
  begin
    left := DoubleMult(r.left, FormFactorX);
    top := DoubleMult(r.top, FormFactorY);
    width := DoubleMult(rxl(r), FormFactorX);
    height := DoubleMult(ryl(r), FormFactorY);
  end;
end;

procedure THauptMenue.FormCreate(Sender: TObject);
var
  d1, d2: double;
  DC: HDC;
  MyIni: TIniFile;
begin

  AllPositions := TStringList.create;
  MyIni := TIniFile.create(SystemPath + '\' + cSymbolMetrixFName);
  MyIni.ReadSectionValues('q1024d.bmp', AllPositions);
  MyIni.free;

  // calculate Form Faktors, this is nessesary because
  // the application was designed for 1024x768
  d1 := Screen.width;
  d2 := 1024;
  FormFactorX := d1 / d2;

  d1 := Screen.height;
  d2 := 768;
  FormFactorY := d1 / d2;

  // allign Form to "full screen"
  left := 0;
  top := 0;
  height := Screen.height;
  width := Screen.width;

  // allign the image to the stire

  // Farbtiefe bestimmen
  DC := GetDC(0);
  ColRes := GetDeviceCaps(DC, BITSPIXEL);
  ReleaseDC(0, DC);

  if (ColRes < 15) then
  begin
    ShowMessage(LanguageStr[pred(52)] + #13#13 + LanguageStr[pred(53)] + #13 +
      LanguageStr[pred(54)] + #13 + LanguageStr[pred(55)] + #13#13 + LanguageStr
      [pred(56)]);
    OpenShell('control desk.cpl', sw_show);
    halt;
  end;

  with Image1 do
  begin

    // Anzeige Parameter
    left := 0;
    top := 0;
    height := Screen.height;
    width := Screen.width;
    visible := true;

  end;

  // Oberm
  // SetRect (25,166,378,378,Label1);
  Label1.caption := '';
  Label1.ShowHint := true;
  Label1.hint := LanguageStr[pred(46)];
  Label1.Cursor := crHandPoint;
  SetRect('1_Start', Label1);

  // Hebu
  Label5.caption := '';
  Label5.font := Label1.font;
  Label5.transparent := Label1.transparent;
  Label5.Cursor := Label1.Cursor;
  Label5.autosize := false;
  Label5.ShowHint := true;
  Label5.hint := LanguageStr[pred(47)];
  SetRect('0_Start', Label5);

  // NOTEN
  Label2.caption := '';
  Label2.font := Label1.font;
  Label2.transparent := Label1.transparent;
  Label2.Cursor := Label1.Cursor;
  Label2.autosize := false;
  Label2.ShowHint := true;
  Label2.hint := LanguageStr[pred(48)];
  SetRect('Noten', Label2);

  // ENDE
  Label3.caption := '';
  Label3.font := Label1.font;
  Label3.transparent := Label1.transparent;
  Label3.Cursor := Label1.Cursor;
  Label3.autosize := false;
  Label3.ShowHint := true;
  Label3.hint := LanguageStr[pred(49)];
  SetRect('Ende', Label3);

  // Settings
  Label4.caption := '';
  Label4.font := Label1.font;
  Label4.transparent := Label1.transparent;
  Label4.Cursor := Label1.Cursor;
  Label4.autosize := false;
  Label4.ShowHint := true;
  Label4.hint := LanguageStr[pred(50)];
  SetRect('Settings', Label4);

  // Hebu: wir über
  Label6.caption := '';
  Label6.font := Label1.font;
  Label6.transparent := Label1.transparent;
  Label6.Cursor := Label1.Cursor;
  Label6.autosize := false;
  Label6.ShowHint := true;
  Label6.hint := LanguageStr[pred(51)];
  SetRect('0_About', Label6);

  ExecuteMode := EM_Immedia;
end;

procedure THauptMenue.Label1Click(Sender: TObject); // INFOS
begin
  DesktopMode := 1;
  StartDatenbank; // Datenbank
end;

procedure THauptMenue.Label3Click(Sender: TObject);
begin
  if (paramstr(1) <> 'demo') then
  begin
    height := height - 33;
    NameForm.AppDown;
  end;
end;

procedure THauptMenue.Label4Click(Sender: TObject);
begin
  SettingForm.show;
end;

procedure THauptMenue.Label2Click(Sender: TObject);
begin
  if (languagedriver = 'D') then
    NotenForm.showmodal
  else
    ShowMessage(LanguageStr[pred(63)]);
end;

procedure THauptMenue.StartDatenbank; // Datenbank
var
  MustCreateNewDesktop: Boolean;

  procedure SetKompatible(toVersion: single);
  begin
    if MustCreateNewDesktop then
      if FurtherVersion = RevToStr(toVersion) then
        MustCreateNewDesktop := false;
  end;

begin
  Screen.Cursor := crHourGlass;
  if SoundCardInstalled then
    if not(WinAmpRunning) then
    begin
      winAmpLoadUp;
      if not(WinAmpRunning) then
      begin
        InstallForm.ActualiseDataNoten;
        InstallForm.showmodal;
      end;
    end;

  // Desktop ev. löschen ?
  if FileExists(ProgramFilesDir + cCodeName + '\Desktop0.ini') then
  begin

    // wegen veränderter Auflösung
    if (LastResolution <> Screen.width) then
    begin
      if not(MesseMode) then
        ShowMessage(LanguageStr[pred(57)] + #13#10 + LanguageStr[pred(58)]);
      if FileExists(ProgramFilesDir + cCodeName + '\Desktop0.ini') then
        FileDelete(ProgramFilesDir + cCodeName + '\Desktop0.ini');
      if FileExists(ProgramFilesDir + cCodeName + '\Desktop1.ini') then
        FileDelete(ProgramFilesDir + cCodeName + '\Desktop1.ini');
      LastResolution := Screen.width;
    end;

    // wegen neuer Revision
    if (FurtherVersion <> RevToStr(Version)) then
    begin
      MustCreateNewDesktop := true;
      SetKompatible(1.039);
      SetKompatible(1.040);
      SetKompatible(1.041);
      SetKompatible(1.042);
      SetKompatible(1.043);
      if MustCreateNewDesktop then
      begin
        if not(MesseMode) then
          ShowMessage(LanguageStr[pred(59)] + #13#10 + LanguageStr[pred(60)]);
        if FileExists(ProgramFilesDir + cCodeName + '\Desktop0.ini') then
          FileDelete(ProgramFilesDir + cCodeName + '\Desktop0.ini');
        if FileExists(ProgramFilesDir + cCodeName + '\Desktop1.ini') then
          FileDelete(ProgramFilesDir + cCodeName + '\Desktop1.ini');
      end;
      FurtherVersion := RevToStr(Version);
    end;
  end;

  if FileExists(SystemPath + '\artikel0.bin') then
  begin
    LastResolution := Screen.width;
    FormHeBuBase.StartWithDesktop(DesktopMode);
  end
  else
  begin
    ShowMessage(LanguageStr[pred(64)]);
  end;
end;

procedure THauptMenue.Label5Click(Sender: TObject); // Datenbank
begin
  DesktopMode := 0;
  StartDatenbank; // Datenbank
end;

procedure THauptMenue.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      begin
        Label3Click(Sender);
        Key := 0;
      end;
    ord('I'):
      begin
        InstallForm.ActualiseDataNoten;
        InstallForm.showmodal; // install
        InstallForm.ActualiseDataKatalog;
        InstallForm.showmodal; // install
      end;
    ord('N'):
      NotenForm.show; // noten
    ord('S'):
      begin
        NameForm.ShowInAnyCase := true;
        NameForm.show; // settings
      end;
    ord('C'):
      SettingForm.show; // config
    ord('V'):
      if HaendlerVersion then
        VerlageForm.show; // verlags-Info
  end;
end;

procedure THauptMenue.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  Splashclose;
end;

procedure THauptMenue.MayClose(X, Y: Integer);
begin
  if FirstX = 0 then
  begin
    FirstX := X;
    FirstY := Y;
  end
  else
  begin
    if (FirstX <> X) or (FirstY <> Y) then
      Splashclose;
  end;
end;

procedure THauptMenue.Image1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  MayClose(X, Y);
end;

procedure THauptMenue.Label2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  MayClose(X, Y);
end;

procedure THauptMenue.Label3MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  MayClose(X, Y);
end;

procedure THauptMenue.Label1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  MayClose(X, Y);
end;

procedure THauptMenue.Label5MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  MayClose(X, Y);
end;

procedure THauptMenue.Label4MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  MayClose(X, Y);
end;

procedure THauptMenue.Label6MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  MayClose(X, Y);
end;

procedure THauptMenue.Label6Click(Sender: TObject);
begin
  // wir über uns
  WirUeberForm.show;
end;

procedure THauptMenue.FormActivate(Sender: TObject);
begin
  Screen.Cursor := crdefault;
  // external PIC Resolution Case pending
  if (Image1.picture.width = 0) then
  begin
    // Bild des Hauptmenüs
    Image1.picture.LoadFromFile(SystemPath + '\q1024' + languagedriver
      + '.bmp');
    MyResolutionStr := IntToStr(Screen.width) + 'x' + IntToStr(Screen.height);
  end;

  if MesseMode then
    Label5Click(Sender); //
end;

procedure THauptMenue.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  AppGoesDown := true;
  CanClose := true;
end;

end.

