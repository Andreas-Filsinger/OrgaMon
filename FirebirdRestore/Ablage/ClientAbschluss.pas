unit ClientAbschluss;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormClientAbschluss = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormClientAbschluss: TFormClientAbschluss;

implementation

uses
 globals, anfix32;

{$R *.dfm}

procedure TFormClientAbschluss.Button1Click(Sender: TObject);
begin
  // !alte Dateien löschen!
  FileDelete(ContextPath + '*' + cContextExtension, DatePlus(DateGet, -1));
  FileDelete(ContextPath + '*.txt', DatePlus(DateGet, -10));

end;

end.
