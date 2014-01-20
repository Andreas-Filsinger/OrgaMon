unit FISonline;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, html;

type
  TFormFISonline = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    Label1: TLabel;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FIShtml: ThtmlTemplate;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormFISonline: TFormFISonline;

implementation

{$R *.dfm}

procedure TFormFISonline.Button1Click(Sender: TObject);
begin
  FIShtml.LoadFromFile(edit1.text);
  FIShtml.Parse;
  memo1.lines.assign(FIShtml.GetForm(''));
end;

procedure TFormFISonline.FormCreate(Sender: TObject);
begin
  FIShtml := ThtmlTemplate.create;
end;

end.

