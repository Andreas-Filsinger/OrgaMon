unit feiertagbearbeiten;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DateUtils, txlib_UI;

type
  TFormEditOfficialHolidays = class(TForm)
    DateTimePicker1: TDateTimePicker;
    Label1: TLabel;
    LabeledEdit1: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CtrlKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }

    UserCanceled: Boolean;

    DateTime: TDateTime;
  end;

var
  FormEditOfficialHolidays: TFormEditOfficialHolidays;

implementation

{$R *.dfm}

procedure TFormEditOfficialHolidays.FormShow(Sender: TObject);
begin
  DateTimePicker1.DateTime := DateTime;
  UserCanceled := True;
end;

procedure TFormEditOfficialHolidays.CtrlKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Button1.Click;
end;

procedure TFormEditOfficialHolidays.Button1Click(Sender: TObject);
begin
  if YearOf(DateTimePicker1.DateTime) <> YearOf(DateTime) then
    ErrorMsg('Der Feiertag muss sich im Jahr ' + IntToStr(YearOf(DateTime)) + ' befinden.')
  else if Trim(LabeledEdit1.Text) = '' then
    ErrorMsg('Bitte geben Sie den Namen des Feiertages ein!')
  else
  begin
    UserCanceled := False;
    Close;
  end;
end;

procedure TFormEditOfficialHolidays.Button2Click(Sender: TObject);
begin
  Close;
end;

end.
