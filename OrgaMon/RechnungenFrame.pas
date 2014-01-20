unit RechnungenFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, Grids;

type
  TFrameRechnungUeberblick = class(TFrame)
    DrawGrid1: TDrawGrid;
    DrawGrid2: TDrawGrid;
    Splitter1: TSplitter;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

implementation

{$R *.dfm}

end.
