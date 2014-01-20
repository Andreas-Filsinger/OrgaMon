unit QueryEdit;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, IB_Access, IB_Components,
  StdCtrls, Datenbank;

type
  TFormQueryEdit = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    IB_Query1: TIB_Query;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    CallerForm: TForm;
    CallerQuery: TIB_Query;
    procedure EditSql(Sender: TForm; Query: TIB_Query);
  end;

var
  FormQueryEdit: TFormQueryEdit;

implementation

{$R *.DFM}

procedure TFormQueryEdit.EditSql(Sender: TForm; Query: TIB_Query);
begin
  CallerForm := sender;
  CallerQuery := Query;
  memo1.lines.assign(Query.Sql);
  show;
end;

procedure TFormQueryEdit.Button1Click(Sender: TObject);
begin
  close;
  CallerForm.show;
end;

procedure TFormQueryEdit.Button2Click(Sender: TObject);
begin
  close;
  CallerQuery.Close;
  CallerQuery.SQL.assign(memo1.lines);
  CallerQuery.Open;
  CallerForm.show;
end;

end.
