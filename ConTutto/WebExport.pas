unit WebExport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormWebExport = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormWebExport: TFormWebExport;

implementation

uses
 globals, HeBuBase;

{$R *.dfm}

procedure TFormWebExport.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if (Key=#27) then
  close;
end;

procedure TFormWebExport.Button1Click(Sender: TObject);
begin
 close;
 if edit1.Text = 'webexport' then
  FormHebuBase.CreateWebExport;
end;

end.
