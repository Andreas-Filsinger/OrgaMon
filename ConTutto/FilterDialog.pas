unit FilterDialog;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  checklst, ExtCtrls, globals, ComCtrls;

type
  TFilterForm = class(TForm)
    CheckListBox1: TCheckListBox;
    Button1: TButton;
    Button2: TButton;
    DateTimePicker1: TDateTimePicker;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    CheckSaver: array[0..100] of boolean;
    procedure UpdateEnableDisableState;
  public
    { Public-Deklarationen }
    OneCheckOnly: boolean; // nur ein Flag darf gesetzt sein
    ClearMeansSetAll: boolean; // bei "aus" sollen alle Flags gesetzt werden
    DatumEntryMode: boolean; // Sonderfunktion Datumseingabe
    ClearIfSetAll: boolean; // wenn alles Flags an -> keines anschalten!

    function UserEntryDate: integer;
  end;

var
  FilterForm: TFilterForm;

implementation

uses
  HeBuBase, anfix32;

{$R *.DFM}

procedure TFilterForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_escape then
    close;
end;

procedure TFilterForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbright then
    close;
end;

procedure TFilterForm.CheckListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_escape then
    close;
end;

procedure TFilterForm.CheckListBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbright then
    close;
end;

procedure TFilterForm.CheckListBox1ClickCheck(Sender: TObject);
var
  n: integer;
  NewTag: integer;
begin
  if OneCheckOnly then
  begin
    NewTag := -1;
    for n := 0 to pred(CheckListBox1.items.count) do
      if CheckListBox1.checked[n] then
        if not (CheckSaver[n]) then
          NewTag := n;
    for n := 0 to pred(CheckListBox1.items.count) do
    begin
      CheckListBox1.checked[n] := (n = NewTag);
      CheckSaver[n] := (n = NewTag);
    end;
  end;
  UpdateEnableDisableState;
end;

procedure TFilterForm.FormActivate(Sender: TObject);
const
  ButtonOKHeight = 17;
var
  n: integer;
  ButtonYPos: integer;
  UserControlsY: integer;
  OneIsActive: boolean;
begin
  UserControlsY := ButtonOKHeight + 2;
  if DatumEntryMode then
    inc(UserControlsY, DateTimePicker1.height + 2);


  clientHeight := height + UserControlsY;
  OneIsActive := false;
  for n := 0 to pred(CheckListBox1.items.count) do
  begin
    CheckSaver[n] := CheckListBox1.checked[n];
    if CheckSaver[n] = not (ClearMeansSetAll) then
      OneIsActive := true;
  end;

  if ClearIfSetAll and not (OneIsActive) then
  begin
    for n := 0 to pred(CheckListBox1.items.count) do
      CheckListBox1.checked[n] := not (ClearMeansSetAll);
  end;

 // Resizen der List und des OK-Buttons
  CheckListBox1.Height := ClientHeight - UserControlsY;
  ButtonYPos := ClientHeight - ButtonOKHeight;

 // off
  button2.left := 0;
  button2.Top := ButtonYPos;
  button2.width := clientwidth div 2;
  button2.height := ButtonOKHeight;

 // on
  button1.Left := clientwidth div 2;
  button1.Top := ButtonYPos; // Tbutton
  button1.width := clientwidth div 2;
  button1.height := ButtonOKHeight;
  button2.caption := LanguageStr[pred(92)];

 // Einabe-Feld
  if DatumEntryMode then
  begin
    DateTimePicker1.visible := true;
    DateTimePicker1.Left := 0;
    DateTimePicker1.Top := ButtonYPos - 2 - DateTimePicker1.height;
    DateTimePicker1.Width := clientwidth;
  end else
  begin
    DateTimePicker1.visible := false;
  end;
  CheckListBox1.SetFocus;
  UpdateEnableDisableState;
end;

procedure TFilterForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FormHeBuBase.EvaluateFilter; // tform
end;

procedure TFilterForm.Button2Click(Sender: TObject);
var
  n: integer;
begin
  for n := 0 to pred(CheckListBox1.items.count) do
    if ClearMeansSetAll then
      CheckListBox1.State[n] := cbchecked
    else
      CheckListBox1.State[n] := cbunchecked;
  CheckListBox1.SetFocus;
  UpdateEnableDisableState;
end;

procedure TFilterForm.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TFilterForm.UpdateEnableDisableState;
var
  ClearMakeSense: boolean;
  n: integer;
begin
  if DatumEntryMode then
    DateTimePicker1.Enabled := (CheckListBox1.state[pred(CheckListBox1.items.count)] = cbchecked);

  ClearMakeSense := false;
  for n := 0 to pred(CheckListBox1.items.count) do
    if ClearMeansSetAll then
    begin
      if (CheckListBox1.state[n] <> cbchecked) then
      begin
        ClearMakeSense := true;
        break;
      end;
    end else
    begin
      if (CheckListBox1.state[n] = cbchecked) then
      begin
        ClearMakeSense := true;
        break;
      end;
    end;
  button2.Enabled := ClearMakeSense;
end;

function TFilterForm.UserEntryDate: integer;
begin
  result := DateTime2long(DateTimePicker1.time);
end;

end.
