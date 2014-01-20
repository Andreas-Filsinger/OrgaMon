unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, DB, FileUtil, Forms, Controls,
  Graphics, Dialogs, DBGrids, StdCtrls, DBCtrls, ZConnection, ZDataset;

type

  { TForm1 }

  TForm1 = class(TForm)
    Datasource1: TDatasource;
    DBGrid1: TDBGrid;
    DBMemo1: TDBMemo;
    DBNavigator1: TDBNavigator;
    IBConnection1: TIBConnection;
    Memo1: TMemo;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    procedure DBMemo1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  anfix32;

{$R *.lfm}

{ TForm1 }


procedure TForm1.FormActivate(Sender: TObject);
var
   s: TSTringField;
begin
  {
  if not (SQLQuery1.active) then
  begin
    IBCOnnection1.Connected := True;
    DataSource1.Enabled := True;
    SQLQuery1.active := True;
    memo1.Lines.add(AnsiToUTF8(SQLQuery1.FieldByName('NUMMERN_PREFIX').AsString));
  end;
  }
  // with Zeos
  if not(ZQuery1.Active) then
   ZQuery1.Open;

end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
//  SQLQuery1.Post;
  SQLTransaction1.Commit;
  DataSource1.Enabled:=false;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.DBMemo1Change(Sender: TObject);
begin

end;

end.

