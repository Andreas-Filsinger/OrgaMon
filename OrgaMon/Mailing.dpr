program Mailing;

uses
  Forms,
  MailingUser in 'MailingUser.pas' {FormMailingUser},
  anfix32 in '\anfix32\anfix32.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormMailingUser, FormMailingUser);
  Application.Run;
end.
