program ExifTimeShift;

uses
  Forms,
  CCR.Exif in '..\..\CCR.Exif.pas',
  CCR.Exif.Consts in '..\..\CCR.Exif.Consts.pas',
  CCR.Exif.JpegUtils in '..\..\CCR.Exif.JpegUtils.pas',
  CCR.Exif.StreamHelper in '..\..\CCR.Exif.StreamHelper.pas',
  CCR.Exif.TagIDs in '..\..\CCR.Exif.TagIDs.pas',
  CCR.Exif.XMPUtils in '..\..\CCR.Exif.XMPUtils.pas',
  CCR.Exif.Demos in '..\CCR.Exif.Demos.pas',
  TimeShiftForm in 'TimeShiftForm.pas' {frmTimeShiftDemo},
  FileTimeOptsForm in 'FileTimeOptsForm.pas' {frmFileTimeOptions};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTimeShiftDemo, frmTimeShiftDemo);
  Application.Run;
end.
