unit srv_unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
 cryptossl, HTTP2;

procedure TForm1.Button1Click(Sender: TObject);
begin
 memo1.Lines.Add(cryptossl.Version);
 memo1.Lines.AddStrings(cryptossl.sdebug);
 memo1.Lines.Add('---------------');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 TLS_init;
end;

end.
