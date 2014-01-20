unit QArbeitsbereich;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, IB_Controls, Grids,
  IB_Grid, IB_UpdateBar, IB_NavigationBar,
  IB_Components, IB_Access, ExtCtrls,
  Datenbank;

type
  TFormQArbeitsbereich = class(TForm)
    Panel1: TPanel;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_Grid1: TIB_Grid;
    IB_Memo1: TIB_Memo;
    Label1: TLabel;
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormQArbeitsbereich: TFormQArbeitsbereich;

implementation

{$R *.dfm}

procedure TFormQArbeitsbereich.FormActivate(Sender: TObject);
begin
 if not(IB_Query1.Active) then
  IB_Query1.Open;
end;

end.
