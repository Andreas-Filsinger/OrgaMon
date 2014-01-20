unit Aufkleber;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids;

type
  TFormAufkleber = class(TForm)
    DrawGrid1: TDrawGrid;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormAufkleber: TFormAufkleber;

implementation

uses
  printers;

{$R *.DFM}

procedure TFormAufkleber.Button1Click(Sender: TObject);
var
  xKachel, yKachel: integer;
begin
  printer.BeginDoc;
  with printer.Canvas do
  begin
    font.name := 'Verdana';
    font.size := -14;
    font.style := [];
    xKachel := TextHeight('X');
    yKachel := TextWidth('X');

    TextOut(xKachel * 3, yKachel * 4, 'Andreas Filsinger');
    TextOut(xKachel * 3, yKachel * 6, 'Musikverein "Echo" Ubstadt');
    TextOut(xKachel * 3, yKachel * 8, 'Stettfelder Straﬂe 44');
    TextOut(xKachel * 3, yKachel * 10, '(Dorf)');
    font.size := -19;
    font.style := [fsbold];
    TextOut(xKachel * 3, yKachel * 16, 'D-76698 Ubstadt-Weiher');

  end;
  printer.EndDoc;
end;

end.
