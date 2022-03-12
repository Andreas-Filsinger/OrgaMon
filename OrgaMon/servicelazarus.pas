unit ServiceLazarus;

{$mode ObjFPC}{$H+}

{$ifndef FPC}
{$MESSAGE FATAL 'Prüfe Abhängigkeit: Diese Unit ist nur für Lazarus'}
{$endif}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  ZConnection, ZDataset;

type

  { TFormServiceLazarus }

  TFormServiceLazarus = class(TForm)
    Button1: TButton;
    Button2: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public

  end;

var
  FormServiceLazarus: TFormServiceLazarus;

implementation

{$R *.lfm}

{ TFormServiceLazarus }

procedure TFormServiceLazarus.Button1Click(Sender: TObject);
begin
 ZConnection1.Connected:=true;
end;

procedure TFormServiceLazarus.Button2Click(Sender: TObject);
begin
 ZQuery1.Active := true;
end;

end.

