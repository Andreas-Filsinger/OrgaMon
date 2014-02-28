unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, DB, FileUtil, Forms, Controls,
  Graphics, Dialogs, DBGrids, StdCtrls, DBCtrls, ZConnection, ZDataset,
  ZSqlUpdate;

type

  { TForm1 }

  TForm1 = class(TForm)
    Datasource1: TDatasource;
    DBGrid1: TDBGrid;
    DBMemo1: TDBMemo;
    DBNavigator1: TDBNavigator;
    Memo1: TMemo;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    procedure Datasource1StateChange(Sender: TObject);
    procedure DBMemo1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ZQuery1AfterEdit(DataSet: TDataSet);
    procedure ZQuery1AfterPost(DataSet: TDataSet);
    procedure ZQuery1ApplyUpdateError(DataSet: TDataSet; E: EDatabaseError;
      var DataAction: TDataAction);
    procedure ZQuery1BeforeEdit(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  anfix32, globals,
  JonDaExec in '../JonDaServer/JonDaExec.pas',
  Sperre;

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
  if not (ZQuery1.Active) then
    ZQuery1.Open;
  caption := cApplicationName + ' ' + RevToStr(globals.version);
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  //  SQLQuery1.Post;
  DataSource1.Enabled := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.ZQuery1AfterEdit(DataSet: TDataSet);
begin

end;

procedure TForm1.ZQuery1AfterPost(DataSet: TDataSet);
begin

end;

procedure TForm1.ZQuery1ApplyUpdateError(DataSet: TDataSet; E: EDatabaseError;
  var DataAction: TDataAction);
begin

end;

procedure TForm1.ZQuery1BeforeEdit(DataSet: TDataSet);
begin

end;

procedure TForm1.DBMemo1Change(Sender: TObject);
begin

end;

procedure TForm1.Datasource1StateChange(Sender: TObject);
var
  s: Tdatasetstate;
begin
  {   dsInactive, dsBrowse, , dsInsert, dsSetKey,
      dsCalcFields, dsFilter, dsNewValue, dsOldValue, dsCurValue, dsBlockRead,
      dsInternalCalc, dsOpening
}
  case (Sender as TDatasource).State of
    dsInsert: Memo1.Color := cllime;
    dsEdit: Memo1.Color := clyellow;
    dsBrowse: Memo1.Color := clwindow;
  end;
end;

end.

