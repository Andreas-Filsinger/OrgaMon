unit NummernKreise;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Grids,

  // IB-Objects
  IB_Components,
  IB_Grid,

  // HeBuAdmin-Projekt
  HebuData;

type
  TFormNummernKreise = class(TForm)
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    Button1: TButton;
    IB_Grid1: TIB_Grid;
    ListBox1: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormNummernKreise: TFormNummernKreise;

implementation

{$R *.DFM}

procedure TFormNummernKreise.Button1Click(Sender: TObject);
begin
  listbox1.items.clear;
  IB_Query1.Active := true;
  with IB_Query1 do
  begin
    first;
    while not (eof) do
    begin
      listbox1.items.add(Fields[0].AsString +
        '=' +
        inttostr(GeneratorValue(Fields[0].AsString, 0))
        );
      next;
    end;
  end;
end;

procedure TFormNummernKreise.FormActivate(Sender: TObject);
begin
  if not (IB_Query1.active) then
    IB_Query1.active := true;
end;

end.
