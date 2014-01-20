unit LAND_R;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  IB_Components, Grids, IB_Grid,
  StdCtrls, IB_Controls;

type
  TFormLAND_R = class(TForm)
    IB_DataSource1: TIB_DataSource;
    IB_Query1: TIB_Query;
    IB_Grid1: TIB_Grid;
    Button1: TButton;
    IB_Text1: TIB_Text;
    Label1: TLabel;
    Button2: TButton;
    Label2: TLabel;
    Label3: TLabel;
    ComboBox1: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormLAND_R: TFormLAND_R;

implementation

uses
  HeBuData, anfix32, globals;

{$R *.dfm}

procedure TFormLAND_R.Button1Click(Sender: TObject);
var
  ANSCHRIFT: TIB_dsql;
  OldLand: string;
begin
  BeginHourGlass;
  //
  OldLand:= IB_Query1.FieldByName('STATE').AsString;
  ersetze('"','',OldLand);

  ANSCHRIFT := TIB_dsql.Create(self);
  with ANSCHRIFT do
  begin
    sql.add('UPDATE ANSCHRIFT SET');
    sql.Add('STATE=''' + combobox1.Text + '''');
    sql.add('WHERE STATE=''' + OldLand + '''');
    execute;
  end;

  Button2Click(Sender);
  EndHourGlass;



end;

procedure TFormLAND_R.Button2Click(Sender: TObject);
var
  LAND: TIB_Cursor;
  ANSCHRIFT: TIB_DSQL;
  laender: TSTringList;
  n: integer;
begin
  BeginHourGlass;

  IB_query1.Open;

  // erst alle Länder ermitteln
  laender := TSTringList.create;
  LAND := TIB_Cursor.Create(self);
  with LAND do
  begin
    sql.add('SELECT RID,KURZ_ALT FROM LAND WHERE KURZ_ALT IS NOT NULL');
    first;
    while not (eof) do
    begin
      laender.addobject(noblank(FieldByName('KURZ_ALT').AsString) + '-', TObject(
        FieldByName('RID').AsInteger));
      next;
    end;
    close;
  end;
  LAND.Free;
  laender.sort;
  combobox1.Items.Assign(laender);

 //
  ANSCHRIFT := TIB_DSQL.Create(self);
  with ANSCHRIFT do
  begin
    for n := 0 to pred(laender.Count) do
    begin
      sql.add('UPDATE ANSCHRIFT SET');
      sql.add(' STATE=NULL,');
      sql.add(' LAND_R=' + inttostr(integer(laender.objects[n])));
      sql.add('WHERE');
      sql.add(' (LAND_R IS NULL) AND');
      sql.add(' (STATE=''' + laender[n]+''')');
      execute;
      sql.clear;
    end;
  end;
  ANSCHRIFT.free;
  IB_Query1.Refresh;
  EndHourGlass;
end;

end.

