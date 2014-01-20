unit PlanungLoeschen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TPlanungLoeschenForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    SelectedRow: integer;
  end;

var
  PlanungLoeschenForm: TPlanungLoeschenForm;

implementation

uses
  BesucherListe, anfix32;

{$R *.DFM}

procedure TPlanungLoeschenForm.FormCreate(Sender: TObject);
begin
  color := clblack;
  GroupBox1.top := 1;
  GroupBox1.Left := 1;
  width := GroupBox1.width + 2;
  height := GroupBox1.height + 2;
end;

procedure TPlanungLoeschenForm.FormActivate(Sender: TObject);
begin
  button2.SetFocus;
end;

procedure TPlanungLoeschenForm.Button1Click(Sender: TObject);
begin
  close;
  BesucherListeForm.DeleteBesucher(SelectedRow, 0, 0);
end;

procedure TPlanungLoeschenForm.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TPlanungLoeschenForm.FormDeactivate(Sender: TObject);
begin
  BesucherListeForm.YellowRow := -1;
end;

end.
