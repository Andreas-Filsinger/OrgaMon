unit TrackAnsicht;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ImgList;

type
  TFormTrackAnsicht = class(TForm)
    ImageList1: TImageList;
    ListView1: TListView;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormTrackAnsicht: TFormTrackAnsicht;

implementation

{$R *.DFM}

procedure TFormTrackAnsicht.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    close;
  end;
end;

end.
