unit ArtikelGruppen;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, paramtreeview;

type
  TFormArtikelGruppen = class(TForm)
    Label1: TLabel;
    ParamTreeview1: TParamTreeview;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormArtikelGruppen: TFormArtikelGruppen;

implementation

{$R *.dfm}

end.
