program SRV;

uses
  Vcl.Forms,
  srv_unit1 in 'srv_unit1.pas' {Form1},
  cryptossl in '..\HTTP2\cryptossl.pas',
  http2 in '..\HTTP2\http2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
