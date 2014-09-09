program PCSC_Sample;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  MD_Events in '..\pcsc\MD_Events.pas',
  MD_PCSC in '..\pcsc\MD_PCSC.pas',
  MD_PCSCDef in '..\pcsc\MD_PCSCDef.pas',
  MD_PCSCRaw in '..\pcsc\MD_PCSCRaw.pas',
  MD_Tools in '..\pcsc\MD_Tools.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
