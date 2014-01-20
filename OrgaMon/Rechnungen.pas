unit Rechnungen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, StdCtrls, CheckLst, RechnungenFrame;

type
  TFormRechnungen = class(TForm)
    ControlBar1: TControlBar;
    ControlBar2: TControlBar;
    CheckListBox1: TCheckListBox;
    FrameRechnungUeberblick1: TFrameRechnungUeberblick;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormRechnungen: TFormRechnungen;

implementation

{$R *.dfm}

end.
