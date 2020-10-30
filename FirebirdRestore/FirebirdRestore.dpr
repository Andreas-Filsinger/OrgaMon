program FirebirdRestore;

uses
  Forms,
  UnitFirebirdRestore in 'UnitFirebirdRestore.pas' {FormFirebirdRestore},
  DCPconst in '..\DCPcrypt\DCPconst.pas',
  DCPcrypt2 in '..\DCPcrypt\DCPcrypt2.pas',
  DCPbase64 in '..\DCPcrypt\DCPbase64.pas',
  DCPblockciphers in '..\DCPcrypt\DCPblockciphers.pas',
  anfix32 in '..\PASconTools\anfix32.pas',
  wanfix32 in '..\PASvisTools\wanfix32.pas',
  DCPblowfish in '..\DCPcrypt\Ciphers\DCPblowfish.pas',
  systemd in '..\PASconTools\systemd.pas',
  CareTakerClient in '..\PASconTools\CareTakerClient.pas',
  SimplePassword in '..\PASconTools\SimplePassword.pas',
  gplists in '..\PASconTools\gplists.pas',
  html in '..\PASconTools\html.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormFirebirdRestore, FormFirebirdRestore);
  Application.Run;
end.
