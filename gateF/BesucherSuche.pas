unit BesucherSuche;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, Grids,
  StdCtrls, WordIndex;

type
  TBesucherSucheForm = class(TForm)
    GroupBox1: TGroupBox;
    StringGrid1: TStringGrid;
    Label1: TLabel;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    NichtGefunden: TStringList;
    BesucherL: TStringList;
    BesucherSuche: TWordIndex;

    Auskunftmodus: boolean;
    MemoryEntry: dword;

    procedure BesucherSucheChange(Sender: TObject);

  end;

var
  BesucherSucheForm: TBesucherSucheForm;

implementation

uses
  BesucherListe, anfix32, globals;

{$R *.DFM}

procedure TBesucherSucheForm.FormCreate(Sender: TObject);
begin
  color := clblack;
  GroupBox1.top := 1;
  GroupBox1.Left := 1;
  width := GroupBox1.width + 2;
  height := GroupBox1.height + 2;

 //
  NichtGefunden := TStringList.create;
  NichtGefunden.add('<nicht gefunden>');
  NichtGefunden.add('-');
  NichtGefunden.add('.');
  NichtGefunden.add('.');
  NichtGefunden.add('.');

 // TStringGrid
  with stringgrid1 do
  begin
    DefaultRowHeight := canvas.TextHeight('X') + (canvas.TextHeight('X') div 2);
    rowCount := 2;
    cells[0, 0] := 'Name'; ColWidths[0] := canvas.TextWidth(cells[0, 0]) + 105;
    cells[1, 0] := 'Firma'; ColWidths[1] := canvas.TextWidth(cells[1, 0]) + 135;
    cells[2, 0] := 'KFZ-Kennz.'; ColWidths[2] := canvas.TextWidth(cells[2, 0]) + 30;
    cells[3, 0] := 'Besuchs TAN'; ColWidths[3] := canvas.TextWidth(cells[3, 0]) + 70;
    cells[4, 0] := 'Einlasstor'; ColWidths[4] := canvas.TextWidth(cells[4, 0]) + 30;
    cells[5, 0] := 'Status'; ColWidths[5] := 45;
  end;
end;

procedure TBesucherSucheForm.FormKeyPress(Sender: TObject; var Key: Char);
var
  NumberStr: string;
begin
  if key = #27 then
  begin
    Key := #0;
    close;
  end;
  if key = #13 then
  begin
    Key := #0;
    close;
    with stringgrid1 do
      NumberStr := rows[row][3];
    if NumberStr <> '.' then
      BesucherListeForm.SetListCursorTo(strtoint(NumberStr));
  end;
end;

procedure TBesucherSucheForm.FormDeactivate(Sender: TObject);
var
  n: integer;
begin
  for n := 0 to pred(BesucherL.count) do
    TStringList(BesucherL.Objects[n]).free;
  BesucherL.free;
  BesucherL := nil;
  BesucherSuche.free;
  BesucherSuche := nil;
end;

procedure TBesucherSucheForm.FormActivate(Sender: TObject);
var
  n: integer;
  OneLineStr: string;
  MyColums: TstringList;
  StartPoint: integer;
  SymbolColor: integer;
  _SymbolColor: string;
  _TorInfo: string;
begin

  MemoryEntry := GetHEapStatus.TotalAllocated;

  BesucherL := TStringList.create;

 //
 // kann man noch wesentlich besser machen!!!
 //

  with BesucherListeForm do
  begin
    if Auskunftmodus then
    begin
      StartPoint := 0;
      BesucherSucheForm.GroupBox1.color := clListeGrau;
    end else
    begin
      StartPoint := succ(PastBorder);
      BesucherSucheForm.GroupBox1.color := clListeGruen;
    end;

    for n := StartPoint to pred(Items.count) do
      with Items[n] do
        if Symbol <> csyMarker then
        begin
          SymbolColor := Color;
          _SymbolColor := '$' + inttoHex(SymbolColor, 6);
          _TorInfo := 'T' + inttostr(PforteEin) + ' ' + PfoertnerEin;

          MyColums := TStringList.Create;
          MyColums.add(BesucherName); // Name
          MyColums.add(Firma); // firma
          MyColums.add(Kennzeichen); // kfz
          MyColums.add(inttostr(TRNid)); // trn
          MyColums.add(_TorInfo); // Tor
          MyColums.add(_SymbolColor);

          BesucherL.AddObject(BesucherName + ' ' + Firma + ' ' + Kennzeichen + ' ' + inttostr(TRNid) + ' ' + _Torinfo, MyColums);
        end;
  end;

  BesucherSuche := TWordIndex.create(BesucherL, 1);
  with stringgrid1 do
  begin
    rowCount := succ(BesucherL.count);
    for n := 0 to pred(BesucherL.count) do
      Rows[succ(n)] := TStrings(BesucherL.objects[n]);
  end;
  edit1.Text := '';
  edit1.SetFocus;
  Auskunftmodus := false;
end;

procedure TBesucherSucheForm.BesucherSucheChange(Sender: TObject);
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

procedure TBesucherSucheForm.Edit1Change(Sender: TObject);
begin
  BesucherSucheChange(Sender);
end;

procedure TBesucherSucheForm.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 // dispose freem eheap sysutils
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

procedure TBesucherSucheForm.FormDestroy(Sender: TObject);
begin
  NichtGefunden.free;
end;

procedure TBesucherSucheForm.StringGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (ARow > 0) and (ACol = 5) then
  begin
    StringGrid1.canvas.brush.color := str2int(StringGrid1.Cells[ACol, ARow]);
    StringGrid1.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, '');
    StringGrid1.canvas.brush.color := clwhite;
  end;
 (*
  else
 begin
  StringGrid1.Canvas.TextRect(Rect, Rect.Left+2, Rect.Top+2, StringGrid1.Cells[ACol, ARow]);
 end;
 *)
end;

end.

