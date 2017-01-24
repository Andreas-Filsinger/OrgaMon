program HPACK_TST;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, HPACK_Form1
  { you can add units after this }
  anfix32 in '../PASconTools/anfix32.pas',
  HPACK in '../PASconTools/hpack.pas';

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

