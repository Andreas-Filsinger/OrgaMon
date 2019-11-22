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
  systemd in '..\PASconTools\systemd.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormFirebirdRestore, FormFirebirdRestore);
  Application.Run;
end.
