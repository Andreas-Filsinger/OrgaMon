program OrgaMon;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, zcomponent, indylaz, main, ServiceFoto, ServiceApp, anfix, basic,
  binlager, c7zip, CareTakerClient, ContextBase, dbOrgaMon, ExcelHelper,
  fpchelper, Geld, GpLists, html, OrientationConvert, SimplePassword, Sperre,
  systemd, txlib, WordIndex, DCPcrypt2, tgputtylib, tgputtysftp, wanfix,
  DCPblowfish, DCPmd5
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormServiceApp, FormServiceApp);
  Application.CreateForm(TFormServiceFoto, FormServiceFoto);
  Application.CreateForm(TFormServiceLazarus, FormServiceLazarus);
  Application.Run;
end.

