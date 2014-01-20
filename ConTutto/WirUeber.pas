unit WirUeber;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, globals;

type
  TWirUeberForm = class(TForm)
    procedure FormPaint(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure WMEraseBkgnd(var m: TWMEraseBkgnd); message WM_ERASEBKGND;
  end;

var
  WirUeberForm: TWirUeberForm;

implementation

{$R *.DFM}

procedure TWirUeberForm.WMEraseBkgnd(var m: TWMEraseBkgnd);
begin
  m.Result := LRESULT(false);
end;

procedure TWirUeberForm.FormPaint(Sender: TObject);
var
  Pic: TBitMap;
begin
  Pic := TBitmap.create;
  Pic.LoadFromFile(SystemPath + '\about' + LanguageDriver + '.bmp');
  with canvas do
  begin
    width := pic.width + 2;
    height := pic.Height + 2;
    top := (screen.height div 2) - (height div 2);
    left := (screen.width div 2) - (width div 2);
    draw(1, 1, Pic);
    brush.color := clwhite;
    FrameRect(rect(0, 0, width, height));
  end;
  Pic.free;
end;

procedure TWirUeberForm.FormClick(Sender: TObject);
begin
  close;
end;

procedure TWirUeberForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: close;
  end;
end;

end.
