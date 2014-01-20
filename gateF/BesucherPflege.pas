unit BesucherPflege;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  Grids, WordIndex, ExtCtrls;

type
  TBesucherPflegeForm = class(TForm)
    StringGrid1: TStringGrid;
    Label1: TLabel;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Edit7: TEdit;
    Label8: TLabel;
    Panel6: TPanel;
    Button1: TButton;
    ListBox1: TListBox;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ComboBox1: TComboBox;
    Label9: TLabel;
    Panel7: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure Edit7KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    BesucherL: TStringList;
    BesucherSuche: TWordIndex;
    NichtGefunden: TStringList;
    SelectedRow: Integer;

    procedure BesucherSucheChange(Sender: TObject);
    function GetDataString(Row: integer): string;
    procedure LoadDataFromList(Row: integer);
    procedure BookAction(FullAction: string);
  end;

var
  BesucherPflegeForm: TBesucherPflegeForm;

implementation

uses
  globals, anfix32;

{$R *.DFM}

procedure TBesucherPflegeForm.FormCreate(Sender: TObject);
var
  n: integer;
begin

 //
  top := 0;
  left := 0;
  height := screen.height - 30;
  width := screen.width;
  NichtGefunden := TStringList.create;
  NichtGefunden.add('<nicht gefunden>');
  NichtGefunden.add('-');
  NichtGefunden.add('.');
  NichtGefunden.add('.');
  NichtGefunden.add('.');
  NichtGefunden.add('.');
  NichtGefunden.add('.');

  with stringgrid1 do // TstringGrid
  begin
    DefaultRowHeight := canvas.TextHeight('X') + (canvas.TextHeight('X') div 2);
    rowCount := 2;
    cells[0, 0] := 'Name'; ColWidths[0] := canvas.TextWidth(cells[0, 0]) + 105;
    cells[1, 0] := 'Firma'; ColWidths[1] := canvas.TextWidth(cells[1, 0]) + 135;
    cells[2, 0] := 'KFZ-Kennz.'; ColWidths[2] := canvas.TextWidth(cells[2, 0]) + 30;
    cells[3, 0] := 'Handy'; ColWidths[3] := canvas.TextWidth(cells[3, 0]) + 70;
    cells[4, 0] := 'Bemerkung'; ColWidths[4] := canvas.TextWidth(cells[4, 0]) + 90;
    cells[5, 0] := 'Grund'; ColWidths[5] := canvas.TextWidth(cells[5, 0]) + 105;
    cells[6, 0] := 'Anrede'; ColWidths[6] := canvas.TextWidth(cells[6, 0]) + 30;
  end;
  button4.Enabled := false;
  button3.enabled := false;
end;

procedure TBesucherPflegeForm.FormActivate(Sender: TObject);
var
  n: integer;
  OneLineStr: string;
  MyColums: TStringList;
begin
  if not (assigned(BesucherL)) then
  begin
    BesucherL := TStringList.create;
    if FileExists(MyProgramPath + cBesucherFname) then
      BesucherL.LoadFromFile(MyProgramPath + cBesucherFname);

    for n := 0 to pred(BesucherL.count) do
    begin
      OneLineStr := BesucherL[n];
      MyColums := TStringList.Create;
      MyColums.add(NextP(OneLineStr, ';')); // Name
      MyColums.add(NextP(OneLineStr, ';')); // firma
      MyColums.add(NextP(OneLineStr, ';')); // kfz
      MyColums.add(NextP(OneLineStr, ';')); // handy
      MyColums.add(NextP(OneLineStr, ';')); // bemerkung
      MyColums.add(NextP(OneLineStr, ';')); // Letzer Besuchsgrund
      MyColums.add(NextP(OneLineStr, ';')); // Anrede

      BesucherL.Objects[n] := MyColums;
      BesucherL[n] := MyColums[0] + ' ' + MyColums[1] + ' ' + MyColums[2];
    end;

    BesucherSuche := TWordIndex.create(BesucherL, 1);
    with stringgrid1 do
    begin
      rowCount := succ(BesucherL.count);
      for n := 0 to pred(BesucherL.count) do
        Rows[succ(n)] := TStrings(BesucherL.objects[n]);
    end;
  end;
  edit1.SetFocus;
end;

procedure TBesucherPflegeForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    close;
  end;
end;

procedure TBesucherPflegeForm.StringGrid1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN: begin
        LoadDataFromList(StringGrid1.Row); // Edit1.SetFocus;
      end;
    VK_INSERT: begin
      end;
    VK_DELETE: begin
        BookAction('Löschung von;' + GetDataString(StringGrid1.Row));
        Key := 0;
      end;
  end;
end;

procedure TBesucherPflegeForm.BesucherSucheChange(Sender: TObject);
var
  n: integer;
  SearchStr: string;
begin
  SearchStr := edit1.Text;
  with stringgrid1 do // TStringGrid
  begin
    if (length(SearchStr) > 1) then
    begin
      with BesucherSuche do
      begin
        Search(SearchStr);
        if FoundList.count = 0 then
        begin
          RowCount := 2;
          Rows[1] := NichtGefunden;
        end else
        begin
          RowCount := succ(FoundList.Count);
          for n := 0 to pred(FoundList.Count) do
            Rows[succ(n)] := TStrings(FoundList[n]);
        end;
        Row := 1;
      end;
    end else
    begin
      rowCount := succ(BesucherL.count);
      for n := 0 to pred(BesucherL.count) do
        Rows[succ(n)] := TStrings(BesucherL.objects[n]);
    end;
  end;
end;

procedure TBesucherPflegeForm.Edit1Change(Sender: TObject);
begin
  BesucherSucheChange(Sender);
end;

procedure TBesucherPflegeForm.Edit1KeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = #13) then
  begin
    Key := #0;
    LoadDataFromList(StringGrid1.Row); // Edit1.SetFocus;
  end;
  if (key = ';') then
    key := #0;
end;

procedure TBesucherPflegeForm.Button1Click(Sender: TObject);
begin
 // Neu
  BookAction('Neuanlage;' + edit2.Text + ';' +
    edit3.Text + ';' +
    edit4.Text + ';' +
    edit5.Text + ';' +
    edit6.Text + ';' +
    edit7.Text + ';' +
    ComboBox1.Text);
end;

procedure TBesucherPflegeForm.LoadDataFromList(Row: integer);
var
  RowData: TStrings;
begin
 // im Report verzeichnen

  button4.Enabled := true;
  button3.enabled := true;


  while true do
  begin


    with listbox1, items do
      if count > 0 then
        if Items[pred(count)][1] = 'A' then
        begin
          Items[pred(count)] := 'Auswahl;' + GetDataString(Row);
          break;
        end;


    listbox1.Items.add('Auswahl;' + GetDataString(Row));
    break;

  end;

 // nun in die Edits
  RowData := StringGrid1.rows[Row];
  edit2.Text := RowData[0];
  edit3.Text := RowData[1];
  edit4.Text := RowData[2];
  edit5.Text := RowData[3];
  edit6.Text := RowData[4];
  edit7.Text := RowData[5];
  ComboBox1.Text := RowData[6];
end;

procedure TBesucherPflegeForm.Button2Click(Sender: TObject);
begin
  ListBox1.clear;
  button3.enabled := false;
end;

function TBesucherPflegeForm.GetDataString(Row: integer): string;
var
  RowData: TStrings;
begin
  RowData := StringGrid1.rows[Row];
  result := RowData[0] + ';' + RowData[1] + ';' + RowData[2] + ';' +
    RowData[3] + ';' + RowData[4] + ';' + RowData[5] + ';' +
    RowData[6];

end;

procedure TBesucherPflegeForm.Edit2KeyPress(Sender: TObject;
  var Key: Char);
begin
  if (key = ';') then
    key := #0;
end;

procedure TBesucherPflegeForm.Edit3KeyPress(Sender: TObject;
  var Key: Char);
begin
  if (key = ';') then
    key := #0;
end;

procedure TBesucherPflegeForm.Edit4KeyPress(Sender: TObject;
  var Key: Char);
begin
  if (key = ';') then
    key := #0;
end;

procedure TBesucherPflegeForm.Edit5KeyPress(Sender: TObject;
  var Key: Char);
begin
  if (key = ';') then
    key := #0;
end;

procedure TBesucherPflegeForm.Edit6KeyPress(Sender: TObject;
  var Key: Char);
begin
  if (key = ';') then
    key := #0;
end;

procedure TBesucherPflegeForm.Edit7KeyPress(Sender: TObject;
  var Key: Char);
begin
  if (key = ';') then
    key := #0;
end;

procedure TBesucherPflegeForm.StringGrid1DblClick(Sender: TObject);
begin
  LoadDataFromList(StringGrid1.Row); // Edit1.SetFocus;
end;

procedure TBesucherPflegeForm.BookAction(FullAction: string);
begin
  button3.enabled := true;
  listbox1.items.add(FullAction);
  case FullAction[1] of
    'Ä': button4.Enabled := false;
    'L': button4.Enabled := false;
    'N': button4.Enabled := false;
  end;
end;


procedure TBesucherPflegeForm.Button4Click(Sender: TObject);
begin
  BookAction('Ändern;' + edit2.Text + ';' +
    edit3.Text + ';' +
    edit4.Text + ';' +
    edit5.Text + ';' +
    edit6.Text + ';' +
    edit7.Text + ';' +
    ComboBox1.Text);

end;

procedure TBesucherPflegeForm.Button3Click(Sender: TObject);
var
  BesucherWow: TStringList;
  n, m, k: integer;
  _Item: string;
  LastSetWas: integer;
  ThisIsSet: integer;

  function SetToActualRecord: integer;
  var
    n: integer;
  begin
    for n := 0 to pred(BesucherWow.count) do
    begin
      if (pos(BesucherWow[n], _Item) = 1) then
      begin
        result := n;
        exit;
      end;
    end;
    ShowMessage('uups nicht mehr gefunden, da zuvor gelöscht!');
    result := -1;
  end;

begin
  if (ListBox1.items.count > 0) then
  begin
    LastSetWas := -1;
    BesucherWow := TStringList.Create;
    if FIleExists(MyProgramPath + cBesucherFname) then
      BesucherWow.LoadFromFile(MyProgramPath + cBesucherFname);
    for n := 0 to pred(ListBox1.items.count) do
    begin
      k := pos(';', ListBox1.items[n]);
      _Item := copy(ListBox1.items[n], succ(k), MaxInt);
      case ListBox1.items[n][1] of
        'N': BesucherWow.add(_Item);
        'L': begin
            ThisIsSet := SetToActualRecord;
            if ThisIsSet <> -1 then
              BesucherWow.Delete(ThisIsSet);
          end;
        'Ä': begin
            if LastSetWas <> -1 then
              BesucherWow[LAstSetWas] := _Item;
          end;
        'A': LastSetWas := SetToActualRecord;
      end;
    end;
  // speichere alles
    BesucherWow.sort;
    RemoveDuplicates(BesucherWow);
    BesucherWow.SaveToFile(MyProgramPath + cBesucherFName);
    BesucherWow.free;
    ListBox1.items.clear;
    ShowMessage('Bei Änderungen muss in der Regel die Anwendung'#13 +
      'neu gestartet werden, damit die Änderungen'#13 +
      'wirksam werden!');
  end;
  close;
end;

procedure TBesucherPflegeForm.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with stringgrid1 do
    case Key of
      VK_Down: begin
          if row < pred(RowCount) then
            row := row + 1
          else
            beep;
          Key := 0;
        end;
      VK_UP: begin
          if row > 1 then
            row := row - 1
          else
            beep;
          Key := 0;
        end;
    end;
end;

procedure TBesucherPflegeForm.FormDestroy(Sender: TObject);
begin
  NichtGefunden.free;
  BesucherL.free;
  BesucherSuche.free;
end;

end.

