{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2009  Ronny Schupeta
  |
  |    This program is free software: you can redistribute it and/or modify
  |    it under the terms of the GNU General Public License as published by
  |    the Free Software Foundation, either version 3 of the License, or
  |    (at your option) any later version.
  |
  |    This program is distributed in the hope that it will be useful,
  |    but WITHOUT ANY WARRANTY; without even the implied warranty of
  |    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  |    GNU General Public License for more details.
  |
  |    You should have received a copy of the GNU General Public License
  |    along with this program.  If not, see <http://www.gnu.org/licenses/>.
  |
  |    https://wiki.orgamon.org/
  |
}
unit feiertage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, DateUtils, Menus, CareTakerClient,
  txHoliday, anfix, globals;

type
  TFormOfficialHolidays = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    TreeView1: TTreeView;
    Splitter1: TSplitter;
    Panel3: TPanel;
    ListView1: TListView;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    PopupMenu1: TPopupMenu;
    Neu1: TMenuItem;
    Bearbeiten1: TMenuItem;
    Lschen1: TMenuItem;
    Button6: TButton;
    N1: TMenuItem;
    Auto1: TMenuItem;
    N2: TMenuItem;
    Allesauswhlen1: TMenuItem;
    Panel4: TPanel;
    Image2: TImage;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ListView1Editing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure Allesauswhlen1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }

    OfficalHolidays:  TSperreOfficalHolidays;
    RootNode:         TTreeNode;
    Year:             Integer;
    DataChanged:      Boolean;
    UserCanceled:     Boolean;

    procedure UpdateTreeView(Rebuild: Boolean);
    procedure UpdateListView;

    procedure GetSelectedIndizes(var SelYear, SelState: Integer);
    function GetSelectedYear: Integer;
    function GetSelectedState: Integer;
  end;

var
  FormOfficialHolidays: TFormOfficialHolidays;

implementation

uses
 feiertagbearbeiten, wanfix;

{$R *.dfm}

function FormatNumber(Value, Decimals: Integer): String;
var
  I, L: Integer;
begin
  Result := IntToStr(Value);
  L := Length(Result);

  Dec(Decimals);
  for I := L to Decimals do
    Result := '0' + Result;
end;

procedure TFormOfficialHolidays.UpdateTreeView(Rebuild: Boolean);
var
  SubNode:          TTreeNode;
  FromYear, ToYear: Integer;
  S:                String;
  I:                Integer;

  function AddStates(Year: Integer; TreeNode: TTreeNode): Boolean;
  var
    SubNode:  TTreeNode;
    Holidays: Integer;
    S:        String;
    I, C:     Integer;
  begin
    Result := False;

    C := OfficalHolidays.StateCount - 1;
    for I := 0 to C do
    begin
      Holidays := OfficalHolidays.States[I].CountHolidays(Year);
      if Holidays > 0 then
        Result := True;

      S := OfficalHolidays.States[I].Name + ' (' + IntToStr(Holidays) + ')';
      if Rebuild then
        SubNode := TreeView1.Items.AddChild(TreeNode, S)
      else
      begin
        SubNode := TreeNode.Item[I];
        SubNode.Text := S;
      end;

      with SubNode do
        Data := Pointer(OfficalHolidays.States[I]);
    end;
  end;
begin
  if Rebuild then
  begin
    if Assigned(RootNode) then
      RootNode.Delete;

    RootNode := TreeView1.Items.Add(nil, 'Jahre');
  end;

  FromYear := Year;
  ToYear := FromYear + 10;

  for I := FromYear to ToYear do
  begin
    S := IntToStr(I);

    if Rebuild then
      SubNode := TreeView1.Items.AddChild(RootNode, S)
    else
      SubNode := RootNode.Item[I - FromYear];

    if AddStates(I, SubNode) then
      SubNode.Text := S
    else
      SubNode.Text := S + ' (!)';
  end;
end;

procedure TFormOfficialHolidays.UpdateListView;
var
  State:        TSperreOfficalHolidaysState;
  SelectedYear: Integer;
  I, C:         Integer;
begin
  ListView1.Clear;

  if Assigned(TreeView1.Selected) then
    if Assigned(TreeView1.Selected.Data) then
      if TObject(TreeView1.Selected.Data) is TSperreOfficalHolidaysState then
      begin
        SelectedYear := GetSelectedYear;
        if SelectedYear > 0 then
        begin
          State := TSperreOfficalHolidaysState(TreeView1.Selected.Data);

          C := State.HolidayCount - 1;
          for I := 0 to C do
            if State.Holidays[I].Year = SelectedYear then
              with ListView1.Items.Add do
              begin
                Caption := FormatNumber(State.Holidays[I].Day, 2) + '.' +
                           FormatNumber(State.Holidays[I].Month, 2) + '.' +
                           IntToStr(State.Holidays[I].Year);
                SubItems.Add(State.Holidays[I].Caption);
                Data := Pointer(State.Holidays[I]);
              end;

          ListView1.AlphaSort;
        end;
      end;
end;

procedure TFormOfficialHolidays.GetSelectedIndizes(var SelYear, SelState: Integer);
var
  CurNode:  TTreeNode;
  Level:    Integer;
begin
  SelYear := -1;
  SelState := -1;

  Level := 0;

  CurNode := TreeView1.Selected;
  repeat
    if Assigned(CurNode) and (CurNode <> RootNode) then
    begin
      case Level of
      0: SelState := CurNode.Index;
      1: SelYear := CurNode.Index;
      end;

      Inc(Level);
    end
    else
      Break;

    CurNode := CurNode.Parent;
  until False;

  case Level of
  1:
  begin
    SelYear := Year + SelState;
    SelState := -1;
  end;
  2: SelYear := Year + SelYear;
  else
    SelYear := -1;
    SelState := -1;
  end;
end;

function TFormOfficialHolidays.GetSelectedYear: Integer;
var
  Dummy:  Integer;
begin
  GetSelectedIndizes(Result, Dummy);
end;

function TFormOfficialHolidays.GetSelectedState: Integer;
var
  Dummy:  Integer;
begin
  GetSelectedIndizes(Dummy, Result);
end;

procedure TFormOfficialHolidays.FormCreate(Sender: TObject);
begin
  OfficalHolidays := TSperreOfficalHolidays.Create;
  RootNode := nil;
end;

procedure TFormOfficialHolidays.FormDestroy(Sender: TObject);
begin
  OfficalHolidays.Free;
end;

procedure TFormOfficialHolidays.FormShow(Sender: TObject);
begin
  Year := YearOf(Now);
  DataChanged := False;
  UserCanceled := True;

  if FileExists(SystemPath+'\'+cFeiertageFName) then
  begin
    try
      OfficalHolidays.LoadFromFile(SystemPath+'\'+cFeiertageFName);
    except
      on E: Exception do ShowMessage('Daten konnten nicht aus' + #13#13 + SystemPath+'\'+cFeiertageFName + #13#13 + 'gelesen werden. Grund:' + #13#13 + E.Message);
    end;
  end
  else
    OfficalHolidays.Clear;

  ListView1.Tag := 0;

  UpdateTreeView(True);
  RootNode.Expand(False);
  if RootNode.Count > 0 then
  begin
    RootNode.Item[0].Expand(False);
    RootNode.Item[0].Selected := True;
  end;
end;

procedure TFormOfficialHolidays.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if DataChanged then
  begin
    if UserCanceled then
      if doit('Daten haben sich geändert. Sollen diese gespeichert werden?') then
        UserCanceled := False;

    if not UserCanceled then
    begin
      CanClose := False;
      OfficalHolidays.SaveToFile(SystemPath+'\'+cFeiertageFName);
      CanClose := True;
    end;
  end;
end;

procedure TFormOfficialHolidays.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  ListView1.Tag := Column.Index;
  ListView1.AlphaSort;
end;

procedure TFormOfficialHolidays.ListView1Compare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  Holiday1: TSperreOfficalHolidayItem;
  Holiday2: TSperreOfficalHolidayItem;
  
  function PrepareDate(Holiday: TSperreOfficalHolidayItem): Integer;
  begin
    Result := Holiday.Year * 365 + Holiday.Month * 31 + Holiday.Day;
  end;
begin
  Holiday1 := TSperreOfficalHolidayItem(Item1.Data);
  Holiday2 := TSperreOfficalHolidayItem(Item2.Data);

  case ListView1.Tag of
  0: Compare := PrepareDate(Holiday1) - PrepareDate(Holiday2);
  1: Compare := CompareStr(AnsiLowerCase(Trim(Holiday1.Caption)), AnsiLowerCase(Trim(Holiday2.Caption)));
  end;
end;

procedure TFormOfficialHolidays.ListView1DblClick(Sender: TObject);
begin
  Button4.Click;
end;

procedure TFormOfficialHolidays.ListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  VK_RETURN: Button4.Click;
  VK_DELETE: Button5.Click;
  end;
end;

procedure TFormOfficialHolidays.ListView1Editing(Sender: TObject;
  Item: TListItem; var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;

procedure TFormOfficialHolidays.TreeView1Change(Sender: TObject;
  Node: TTreeNode);
begin
  UpdateListView;
end;

procedure TFormOfficialHolidays.Button1Click(Sender: TObject);
begin
  UserCanceled := False;

  Close;
end;

procedure TFormOfficialHolidays.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TFormOfficialHolidays.Button3Click(Sender: TObject);
var
  SelectedState:  Integer;
  SelectedYear:   Integer;
begin
  GetSelectedIndizes(SelectedYear, SelectedState);
  if (SelectedYear >= 0) and (SelectedState >= 0) then
  begin
    FormEditOfficialHolidays.Caption := 'Neuen Feiertag eingeben';
    try
      FormEditOfficialHolidays.DateTime := EncodeDate(SelectedYear, MonthOf(Now), DayOf(Now));
    except
      FormEditOfficialHolidays.DateTime := Now;
    end;
    FormEditOfficialHolidays.LabeledEdit1.Text := '';

    FormEditOfficialHolidays.ShowModal;
    if not FormEditOfficialHolidays.UserCanceled then
    begin
      OfficalHolidays.States[SelectedState].AddHoliday(FormEditOfficialHolidays.LabeledEdit1.Text,
                                                       DayOf(FormEditOfficialHolidays.DateTimePicker1.DateTime),
                                                       MonthOf(FormEditOfficialHolidays.DateTimePicker1.DateTime),
                                                       YearOf(FormEditOfficialHolidays.DateTimePicker1.DateTime));

      UpdateListView;
      UpdateTreeView(False);
      DataChanged := True;
    end;
  end;
end;

procedure TFormOfficialHolidays.Button4Click(Sender: TObject);
var
  Holiday:        TSperreOfficalHolidayItem;
  SelectedState:  Integer;
  SelectedYear:   Integer;
begin
  GetSelectedIndizes(SelectedYear, SelectedState);
  if (SelectedYear >= 0) and (SelectedState >= 0) then
  begin
    if Assigned(ListView1.Selected) then
    begin
      Holiday := TSperreOfficalHolidayItem(ListView1.Selected.Data);

      FormEditOfficialHolidays.Caption := 'Feiertag bearbeiten';
      try
        FormEditOfficialHolidays.DateTime := EncodeDate(Holiday.Year, Holiday.Month, Holiday.Day);
      except
        on E: Exception do
        begin
          ShowMessage('Datum konnte nicht ermittelt werden (' + E.Message + ')');

          FormEditOfficialHolidays.DateTime := Now;
        end;
      end;
      FormEditOfficialHolidays.LabeledEdit1.Text := Holiday.Caption;

      FormEditOfficialHolidays.ShowModal;
      if not FormEditOfficialHolidays.UserCanceled then
      begin
        Holiday.Day := DayOf(FormEditOfficialHolidays.DateTimePicker1.DateTime);
        Holiday.Month := MonthOf(FormEditOfficialHolidays.DateTimePicker1.DateTime);
        Holiday.Year := YearOf(FormEditOfficialHolidays.DateTimePicker1.DateTime);
        Holiday.Caption := FormEditOfficialHolidays.LabeledEdit1.Text;

        UpdateListView;
        UpdateTreeView(False);
        DataChanged := True;
      end;
    end;
  end;
end;

procedure TFormOfficialHolidays.Button5Click(Sender: TObject);
var
  Holiday:        TSperreOfficalHolidayItem;
  SelectedState:  Integer;
  SelectedYear:   Integer;
  Selected:       Integer;
  Index:          Integer;
  S:              String;
  I, C:           Integer;
begin
  GetSelectedIndizes(SelectedYear, SelectedState);
  if (SelectedYear >= 0) and (SelectedState >= 0) then
  begin
    Selected := 0;
    C := ListView1.Items.Count - 1;
    for I := 0 to C do
      if ListView1.Items.Item[I].Selected then
        Inc(Selected);
  
    if Selected > 0 then
    begin
      if Selected = 1 then
        S := 'Soll der Feiertag wirklich entfernt werden?'
      else
        S := 'Sollen die ausgewählten Feiertage wirklich entfernt werden?';

      if doit(S) then
      begin
        C := ListView1.Items.Count - 1;
        for I := 0 to C do
          if ListView1.Items.Item[I].Selected then
          begin
            Holiday := TSperreOfficalHolidayItem(ListView1.Items.Item[I].Data);      
            Index := Holiday.Index;
            if Index >= 0 then
              Holiday.Owner.DeleteHoliday(Index);            
          end;

        ListView1.DeleteSelected;
          
        //UpdateListView;
        UpdateTreeView(False);
        DataChanged := True;
      end;
    end;
  end;
end;

procedure TFormOfficialHolidays.Button6Click(Sender: TObject);
var
  SelectedState:  Integer;
  SelectedYear:   Integer;
  Count:          Integer;
  S:              String;
begin
  GetSelectedIndizes(SelectedYear, SelectedState);
  if (SelectedYear >= 0) and (SelectedState >= 0) then
  begin
    if SelectedState = 0 then
      S := 'Es werden alle bundesweiten Feiertage hinzugefügt.'
    else
      S := 'Es werden zu diesem Bundesland alle Feiertage hinzugefügt.';

    S := S + #13#13 + 'Soll der Vorgang fortgesetzt werden?';
    if doit(S) then
    begin
      Count := OfficalHolidays.States[SelectedState].AutoAddHolidays(SelectedYear);

      UpdateListView;
      UpdateTreeView(False);

      if Count > 0 then
        DataChanged := True
      else
        ShowMessage('Zu diesem Bundesland existieren keine spezifischen Feiertage.');
    end;
  end;
end;

procedure TFormOfficialHolidays.Allesauswhlen1Click(Sender: TObject);
begin
  ListView1.SelectAll;
end;

procedure TFormOfficialHolidays.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Baustelle');
end;

procedure TFormOfficialHolidays.Label1Click(Sender: TObject);
begin
  openShell('http://www.feiertage.net');
end;

end.
