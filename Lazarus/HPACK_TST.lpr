program HPACK_TST;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, HPACK_Form1,
  { you can add units after this }
  cryptossl in '../HTTP2/cryptossl.pas',
  anfix32 in '../PASconTools/anfix32.pas',
  HPACK in '../HTTP2/hpack.pas',
  HMUX in '../HTTP2/hmux.pas',
  HTTP2 in '../HTTP2/http2.pas';

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

