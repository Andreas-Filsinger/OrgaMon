program HPACK_TST;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, HPACK_Form1,
  { you can add units after this }
  cryptossl in '../HTTP2/cryptossl.pas',
  HPACK in '../HTTP2/hpack.pas',
  HTTP2 in '../HTTP2/http2.pas';

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

