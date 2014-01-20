unit TPUUploadProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExControls, JvSpecialProgress;

type
  TUploadProgressForm = class(TForm)
    ProgressBar: TJvSpecialProgress;
    CancelButton: TButton;
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure incPosition;
  end;

var
  UploadProgressForm: TUploadProgressForm;

implementation

uses TPUMain;

{$R *.dfm}

procedure TUploadProgressForm.CancelButtonClick(Sender: TObject);
begin
  FormTPMain.CancelUpload := true;
end;

procedure TUploadProgressForm.incPosition;
begin
  with ProgressBar do
  begin
    Position := Position + 1;
    Caption := inttostr(PercentDone) + ' %';
  end;
end;


end.
