unit MitarbeiterSuche;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, WordIndex, ExtCtrls;

type
  TMitarbeiterSucheForm = class(TForm)
    GroupBox1: TGroupBox;
    StringGrid1: TStringGrid;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    NichtGefunden: TStringList;
    MitarbeiterL: TStringList;
    MitarbeiterSuche: TWordIndex;


    procedure BesucherSucheChange(Sender: TObject);

  end;

var
  MitarbeiterSucheForm: TMitarbeiterSucheForm;

implementation

uses
  globals, BesucherListe, anfix32, wanfix32;

{$R *.DFM}

procedure TMitarbeiterSucheForm.FormCreate(Sender: TObject);
begin
  color := clblack;
  GroupBox1.top := 1;
  GroupBox1.Left := 1;
  width := GroupBox1.width + 2;
  height := GroupBox1.height + 2;
  panel1.Color := clmitarbeiter;

 //
  NichtGefunden := TStringList.create;
  NichtGefunden.add('<nicht gefunden>');
  NichtGefunden.add('-');
  NichtGefunden.add('.');

  with stringgrid1 do // TstringGrid
  begin
    DefaultRowHeight := canvas.TextHeight('X') + (canvas.TextHeight('X') div 2);
    rowCount := 2;
    cells[0, 0] := 'Name'; ColWidths[0] := 155;
    cells[1, 0] := 'Gebäude'; ColWidths[1] := 185;
    cells[2, 0] := 'Telefon'; ColWidths[2] := 100;
    cells[3, 0] := 'eMail'; ColWidths[3] := 210;
  end;
end;

procedure TMitarbeiterSucheForm.FormKeyPress(Sender: TObject; var Key: Char);
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
{
  with stringgrid1 do
   NumberStr := rows[row][3];
  if NumberStr<>'.' then
   BesucherListeForm.SetListCursorTo(strtoint(NumberStr));
}
  end;
end;

procedure TMitarbeiterSucheForm.FormActivate(Sender: TObject);
var
  n: integer;
  OneLineStr: string;
  MyColums: TstringList;
  StartPoint: integer;
begin
  if not (assigned(MitarbeiterL)) then
  begin

    screen.cursor := crhourglass;
    edit1.Text := 'warten ...';
    application.processmessages;
    MitarbeiterL := TStringList.create;

 //
 // kann man noch wesentlich besser machen!!!
 //

    if FileExists(MyProgramPath + 'Mitarbeiter.txt') then
      MitarbeiterL.LoadFromFile(MyProgramPath + 'Mitarbeiter.txt');

    with stringgrid1 do
    begin
      rowCount := succ(MitarbeiterL.count);
      for n := 0 to pred(MitarbeiterL.count) do
      begin
        OneLineStr := MitarbeiterL[n];
        MyColums := TStringList.Create;
        MyColums.add(NextP(OneLineStr, ';')); // Name, Vorname
        MyColums.add(NextP(OneLineStr, ';')); // Gebäude
        MyColums.add(NextP(OneLineStr, ';')); // Telefon (Mobil)
        MyColums.add(NextP(OneLineStr, ';')); // email

        MitarbeiterL.Objects[n] := MyColums;
        MitarbeiterL[n] := MyColums[0];

        Rows[succ(n)] := TStrings(MitarbeiterL.objects[n]);

      end;
    end;

    MitarbeiterSuche := TWordIndex.create(MitarbeiterL);
    edit1.Text := '';
    edit1.SetFocus;
    screen.cursor := crdefault;
  end;
end;

procedure TMitarbeiterSucheForm.BesucherSucheChange(Sender: TObject);
var
  n: integer;
  SearchStr: string;
begin
  SearchStr := edit1.Text;
  with stringgrid1 do // TStringGrid
  begin
    if (length(SearchStr) > 1) then
    begin
      with MitarbeiterSuche do
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
      rowCount := succ(MitarbeiterL.count);
      for n := 0 to pred(MitarbeiterL.count) do
        Rows[succ(n)] := TStrings(MitarbeiterL.objects[n]);
    end;
  end;
end;

procedure TMitarbeiterSucheForm.Edit1Change(Sender: TObject);
begin
  if assigned(MitarbeiterL) then
    BesucherSucheChange(Sender);
end;

procedure TMitarbeiterSucheForm.Edit1KeyDown(Sender: TObject; var Key: Word;
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

procedure TMitarbeiterSucheForm.Button1Click(Sender: TObject);
begin
  openShell('mailto:' + Stringgrid1.Cells[3, StringGrid1.Row] + '?subject=' + iPfoertnerKurzBez + ' via gateF');
end;

procedure TMitarbeiterSucheForm.FormDestroy(Sender: TObject);
var
  n: integer;
begin
  NichtGefunden.free;
  if assigned(MitarbeiterL) then
    for n := 0 to pred(MitarbeiterL.count) do
      MitarbeiterL.Objects[n].free;
  MitarbeiterL.free;
  MitarbeiterSuche.free;
end;

procedure TMitarbeiterSucheForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
 DataS : TStringList;
begin
 if (Key=VK_F3) then
 begin
  if StringGrid1.Row<>-1 then
  begin
   Key := 0;
   close;
   BesucherListeForm.InsertMitarbeiter(StringGrid1.Rows[StringGrid1.Row]);
  end;
 end;
end;

end.
