{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2016  Andreas Filsinger
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
  |    http://orgamon.org/
  |
}
unit ArtikelAusgabeartAuswahl;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,

  // Jcl
  JvComponentBase, JvFormPlacement,

  // Tools
  Wordindex, anfix,

  // OrgaMon
  Datenbank, dbOrgaMon;

type
  TFormArtikelAusgabeartAuswahl = class(TForm)
    Edit1: TEdit;
    ListBox1: TListBox;
    JvFormStorage1: TJvFormStorage;
    SpeedButton27: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1DblClick(Sender: TObject);
    procedure SpeedButton27Click(Sender: TObject);
  private
    s: TWordIndex;
    All: TStringList;
    { Private-Deklarationen }
    procedure ensureData;
    procedure take;

  public
    { Public-Deklarationen }
    AUSGABEART_R: integer;

    procedure exec;
    procedure clear;
  end;

var
  FormArtikelAusgabeartAuswahl: TFormArtikelAusgabeartAuswahl;

implementation

uses
  main;

{$R *.dfm}
{ TFormArtikelAusgabeartAuswahl }

procedure TFormArtikelAusgabeartAuswahl.clear;
begin
  Edit1.text := '';
end;

procedure TFormArtikelAusgabeartAuswahl.Edit1Change(Sender: TObject);
var
  n: integer;
  Treffer: TStringList;
begin
  if (Edit1.text <> '') then
  begin
    Treffer := TStringList.Create;
    s.search(Edit1.text);
    if (s.FoundList.Count > 0) then
    begin
      for n := 0 to pred(s.FoundList.Count) do
        Treffer.Add(All[integer(s.FoundList[n])]);
      ListBox1.Items.Assign(Treffer);
      ListBox1.ItemIndex := 0;
    end
    else
    begin
      beep;
    end;
  end
  else
  begin
    ListBox1.Items.Assign(All);
    if (All.Count > 0) then
      ListBox1.ItemIndex := 0;
  end;
end;

procedure TFormArtikelAusgabeartAuswahl.Edit1KeyPress(Sender: TObject; var Key: Char);
begin

  if (Key = #27) then
  begin
    Key := #0;
    AUSGABEART_R := cRID_Unset;
    close;
  end;

  if (Key = #13) then
  begin
    Key := #0;
    take;
  end;

end;

procedure TFormArtikelAusgabeartAuswahl.ensureData;
var
  BEZEICHNUNG, KUERZEL: string;
  RID: integer;
  cAUSGABEART: TdboCursor;
  AllSearch: TStringList;
begin
  if (s = nil) then
  begin
    All := TStringList.Create;
    AllSearch := TStringList.Create;
    cAUSGABEART := DataModuleDatenbank.nCursor;
    with cAUSGABEART do
    begin
      sql.Add('select RID,NAME,KUERZEL from AUSGABEART order by RID');
      ApiFirst;
      while not(eof) do
      begin
        RID := FieldByName('RID').AsInteger;
        BEZEICHNUNG := FieldByName('NAME').AsString;
        KUERZEL := FieldByName('KUERZEL').AsString;
        All.Add(InttoStrN(RID, 3) + ' - ' + BEZEICHNUNG + ' (' + KUERZEL + ')');
        AllSearch.AddObject(BEZEICHNUNG + KUERZEL, TObject(AllSearch.Count));
        ApiNext;
      end;
    end;
    s := TWordIndex.Create(AllSearch, 1);
    ListBox1.Items.Assign(All);
    if (All.Count > 0) then
      ListBox1.ItemIndex := 0;
  end;
end;

procedure TFormArtikelAusgabeartAuswahl.exec;
begin
  clear;
  showmodal;
end;

procedure TFormArtikelAusgabeartAuswahl.FormActivate(Sender: TObject);
begin
  ensureData;
  Edit1.SetFocus;
end;

procedure TFormArtikelAusgabeartAuswahl.ListBox1DblClick(Sender: TObject);
begin
  take;
end;

procedure TFormArtikelAusgabeartAuswahl.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
  Edit1KeyPress(Sender, Key);
end;

procedure TFormArtikelAusgabeartAuswahl.SpeedButton27Click(Sender: TObject);
begin
  ListBox1.Items.clear;
  FreeAndNil(s);
  ensureData;
  Edit1Change(Sender);
end;

procedure TFormArtikelAusgabeartAuswahl.take;
begin
  if (ListBox1.ItemIndex <> -1) then
  begin
    AUSGABEART_R := STrToIntDef(nextp(ListBox1.Items[ListBox1.ItemIndex], ' - ', 0), cRID_Unset);
    close;
  end
  else
  begin
    AUSGABEART_R := cRID_Unset;
  end;
end;

end.
