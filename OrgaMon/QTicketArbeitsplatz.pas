unit QTicketArbeitsplatz;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  Grids, IB_Grid, StdCtrls,
  IB_Components, IB_Access, ExtCtrls,
  IB_UpdateBar, JvGIF;

type
  TFormQTicketArbeitsplatz = class(TForm)
    Label1: TLabel;
    IB_Grid1: TIB_Grid;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    IB_UpdateBar1: TIB_UpdateBar;
    Edit1: TEdit;
    Label2: TLabel;
    Image2: TImage;
    Button8: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormQTicketArbeitsplatz: TFormQTicketArbeitsplatz;

implementation

uses
  Belege, Globals, anfix,
  CareTakerClient, Artikel, dbOrgaMon,
  wanfix;

{$R *.dfm}

procedure TFormQTicketArbeitsplatz.FormActivate(Sender: TObject);
begin
  if not (IB_Query1.active) then
    IB_Query1.open
  else
    IB_Query1.refresh;
end;

procedure TFormQTicketArbeitsplatz.Button7Click(Sender: TObject);
begin
  FormBelege.SetContext(0, IB_Query1.FieldByName('BELEG_R').AsInteger);
end;

procedure TFormQTicketArbeitsplatz.Button3Click(Sender: TObject);
begin
  with IB_Query1 do
  begin
    FieldByName('VORLAGE').AsDate := FieldByName('VORLAGE').AsDate + strtointdef(edit1.text, 0);
    FieldByName('ABLAUF').AsDate := FieldByName('ABLAUF').AsDate + strtointdef(edit1.text, 0);
  end;
end;

procedure TFormQTicketArbeitsplatz.Button1Click(Sender: TObject);
begin
  with IB_Query1 do
  begin
    FieldByName('AUSGANG').AsString := cC_True;
  end;
end;

procedure TFormQTicketArbeitsplatz.Button5Click(Sender: TObject);
begin
  with IB_Query1 do
  begin
    FieldByName('AUSGANG').AsString := cC_false;
  end;
end;

procedure TFormQTicketArbeitsplatz.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'QM.Ticket');
end;

procedure TFormQTicketArbeitsplatz.Button8Click(Sender: TObject);
begin
  // Artikel aufrufen ...
  if IB_Query1.FieldByName('ARTIKEL_R').IsNotNull then
    FormArtikel.SetContext(IB_Query1.FieldByName('ARTIKEL_R').AsInteger);
end;

end.

