unit b2bCheck;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls;

type
  TFormb2bCheck = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Edit2: TEdit;
    Label2: TLabel;
    Edit3: TEdit;
    Button2: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Formb2bCheck: TFormb2bCheck;

implementation

uses
 eCommerce;

{$R *.dfm}

procedure TFormb2bCheck.Button1Click(Sender: TObject);
var
 Status: integer;
begin
 ShowMessage(format('%m',[DataModuleeCommerce.e_w_KontoInfo(strtointDef(edit1.Text,0),Status)]));
end;

procedure TFormb2bCheck.Button2Click(Sender: TObject);
begin
 ShowMessage(format('%m',[ DataModuleeCommerce.e_r_PreisBrutto(strtointdef(edit2.text,0),strtointdef(edit3.text,0))]));
end;

procedure TFormb2bCheck.Button3Click(Sender: TObject);
begin
 ShowMessage(format('%d',[DataModuleeCommerce.e_w_Bestellen(strtointDef(edit1.Text,0))]));
end;

end.
