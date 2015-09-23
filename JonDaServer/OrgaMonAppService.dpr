program OrgaMonAppService;

uses
  Vcl.Forms,
  FotoService in 'FotoService.pas' {FormFotoService},
  anfix32 in '..\PASconTools\anfix32.pas',
  infozip in '..\infozip\infozip.pas',
  WordIndex in '..\PASconTools\WordIndex.pas',
  gplists in '..\PASconTools\gplists.pas',
  html in '..\PASconTools\html.pas',
  globals in 'globals.pas',
  binlager32 in '..\PASconTools\binlager32.pas',
  CCR.Exif in '..\CCR Exif\CCR.Exif.pas',
  CCR.Exif.XMPUtils in '..\CCR Exif\CCR.Exif.XMPUtils.pas',
  CCR.Exif.StreamHelper in '..\CCR Exif\CCR.Exif.StreamHelper.pas',
  CCR.Exif.Consts in '..\CCR Exif\CCR.Exif.Consts.pas',
  CCR.Exif.TagIDs in '..\CCR Exif\CCR.Exif.TagIDs.pas',
  CCR.Exif.JpegUtils in '..\CCR Exif\CCR.Exif.JpegUtils.pas',
  JonDaExec in 'JonDaExec.pas',
  CareTakerClient in '..\PASconTools\CareTakerClient.pas',
  DCPblowfish in '..\DCPcrypt\Ciphers\DCPblowfish.pas',
  DCPblockciphers in '..\DCPcrypt\DCPblockciphers.pas',
  DCPcrypt2 in '..\DCPcrypt\DCPcrypt2.pas',
  DCPconst in '..\DCPcrypt\DCPconst.pas',
  SimplePassword in '..\PASconTools\SimplePassword.pas',
  DCPbase64 in '..\DCPcrypt\DCPbase64.pas',
  SolidFTP in '..\PASconTools\SolidFTP.pas',
  srvXMLRPC in '..\PASconTools\srvXMLRPC.pas',
  wanfix32 in '..\PASvisTools\wanfix32.pas',
  memcache in '..\PASconTools\memcache.pas',
  Foto in '..\PASconTools\Foto.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormFotoService, FormFotoService);
  Application.Run;
end.
