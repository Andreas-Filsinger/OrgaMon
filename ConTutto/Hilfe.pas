unit Hilfe;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, globals,
  inifiles;

type
  THilfeForm = class(TForm)
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDeactivate(Sender: TObject);
  private
    { Private-Deklarationen }
    ActPicture: TBitMap;
    ActMapFName: string;
  public
    { Public-Deklarationen }
    procedure WMEraseBkgnd(var m: TWMEraseBkgnd); message WM_ERASEBKGND;
  end;

var
  HilfeForm: THilfeForm;

implementation

{$R *.DFM}

uses
  anfix32;

procedure THilfeForm.WMEraseBkgnd(var m: TWMEraseBkgnd);
begin
  m.Result := LRESULT(false);
end;


procedure THilfeForm.FormPaint(Sender: TObject);
var
  FName: string;
begin
  screen.cursor := crhourglass;
  if not (assigned(ActPicture)) then
  begin
    ActPicture := TBitMap.Create;
    Fname := ActMapFname;
    ersetze('.', LanguageDriver + '.', Fname);
    ActPicture.LoadFromFile(SystemPath + '\' + Fname);
  end;
  with canvas do
  begin
    Draw(1, 1, ActPicture);
    brush.color := clwhite;
    FrameRect(rect(0, 0, width, height));
  end;
  screen.cursor := crdefault;
end;

procedure THilfeForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 // Dynamic
  MyIni: TIniFile;
  Regions: TStringList;

 // Static
  ButtonRect: TRect;
  MapFName: string;
  ValueStr: string;
  n, k: integer;
  AnyHit: boolean;
begin
  AnyHit := false;
  Regions := TstringList.create;
  MyIni := TIniFile.create(SystemPath + '\HMetrix.txt');
  MyIni.ReadSection(ActMapFName, Regions);
  for n := 1 to Regions.count do
  begin
    MapFName := Regions[pred(n)];
    ValueStr := MyIni.ReadString(ActMapFName, MapFName, '0,0,0,0');

  // left
    k := pos(',', ValueStr);
    ButtonRect.left := strtoint(copy(ValueStr, 1, pred(k)));
    delete(ValueStr, 1, k);

  // top
    k := pos(',', ValueStr);
    ButtonRect.top := strtoint(copy(ValueStr, 1, pred(k)));
    delete(ValueStr, 1, k);

  // FullXL
    k := pos(',', ValueStr);
    ButtonRect.right := ButtonRect.left + strtoint(copy(ValueStr, 1, pred(k)));
    delete(ValueStr, 1, k);

  // FullYL
    ButtonRect.bottom := ButtonRect.top + strtoint(copy(ValueStr, 1, MaxInt));

  // jetzt inside prüfen!
    if inside(x, y, ButtonRect) then
    begin
      ActMapFName := MapFName;
      ActPicture.free;
      ActPicture := nil;
      FormPaint(self);
      AnyHit := true;
      break;
    end;
  end;
  Regions.free;
  MyIni.free;
  if not (AnyHit) then
    close;
end;

procedure THilfeForm.FormActivate(Sender: TObject);
begin
  ActMapFName := 'Hilfe01.bmp';
end;

procedure THilfeForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: close;
  end;
end;

procedure THilfeForm.FormDeactivate(Sender: TObject);
begin
  ActPicture.free;
  ActPicture := nil;
end;

end.
