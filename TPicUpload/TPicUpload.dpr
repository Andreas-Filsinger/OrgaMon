program TPicUpload;

uses
  Forms,
  TPUMain in 'TPUMain.pas' {FormTPMain},
  TPUIni in 'TPUIni.pas' {Ini},
  TSJpeg in 'TSJpeg.pas',
  TSResample in 'TSResample.pas',
  TPUSplash in 'TPUSplash.pas' {SplashScreen},
  TPUPreview in 'TPUPreview.pas' {FullPreview},
  MsMultiPartFormData in 'MsMultiPartFormData.pas',
  TPUUploadProgress in 'TPUUploadProgress.pas' {UploadProgressForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'TPicUpload';
  Application.CreateForm(TFormTPMain, FormTPMain);
  Application.CreateForm(TIni, Ini);
  Application.CreateForm(TSplashScreen, SplashScreen);
  Application.CreateForm(TFullPreview, FullPreview);
  Application.CreateForm(TUploadProgressForm, UploadProgressForm);
  Application.ShowMainForm := False;
  Application.Run;
end.
