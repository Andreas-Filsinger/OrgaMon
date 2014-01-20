unit ListenAnsicht;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TListenAnsichtForm = class(TForm)
    ListBox1: TListBox;
    procedure ListBox1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  ListenAnsichtForm: TListenAnsichtForm;

implementation

{$R *.DFM}

uses
  HebuBase, anfix32, globals;

procedure TListenAnsichtForm.ListBox1Click(Sender: TObject); // TlistBox
var
  k: integer;
begin
  if ListBox1.ItemIndex <> -1 then
    with FormHeBuBase do
    begin
      k := revpos('\', ListBox1.items[ListBox1.ItemIndex]);
      if k > 0 then
      begin
        if ListBox1.items[ListBox1.ItemIndex][k + 1] = '0' then
        begin
          DesktopSymbols[NotenID].SymbolData := strtoint(copy(ListBox1.items[ListBox1.ItemIndex], succ(k), MaxInt));
        end else
        begin
          ActFound := strtoint(copy(ListBox1.items[ListBox1.ItemIndex], succ(k), MaxInt));
          DesktopSymbols[NotenID].SymbolData := Integer(WrdIdx.foundList[ActFound]);
        end;
        DrawSymbol(canvas, NotenID);
        Drawsymbol(canvas, SoundID);
        DrawBaseCount(canvas);
      end;
    end;
end;

procedure TListenAnsichtForm.FormActivate(Sender: TObject);
begin
  caption := LanguageStr[pred(88)];
end;

procedure TListenAnsichtForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (Key = VK_RETURN) then
  begin
    Key := 0;
    close;
    if FormHeBuBase.MusikCount > 0 then
      FormHeBuBase.PlayThisSound;
  end;

  if (Key = VK_ESCAPE) then
  begin
    Key := 0;
    close;
  end;

end;

end.

