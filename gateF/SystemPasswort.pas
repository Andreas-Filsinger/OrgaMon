unit SystemPasswort;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFormSystemPasswort = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure CheckPwd;
  end;

var
  FormSystemPasswort: TFormSystemPasswort;

implementation

uses
  Globals, SystemSettings;

{$R *.DFM}

procedure TFormSystemPasswort.FormActivate(Sender: TObject);
begin
  edit1.Text := '';
end;

procedure TFormSystemPasswort.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    key := #0;
    CheckPwd;
  end;
  if Key = #27 then
  begin
    key := #0;
    close;
  end;
end;

procedure TFormSystemPasswort.CheckPwd;
begin
  if (ansiuppercase(edit1.Text) = ansiuppercase(cPwdSuperVisor)) then
    FormSystemSettings.show;
  close;
end;

end.
