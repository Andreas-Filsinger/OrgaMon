{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007  Andreas Filsinger
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
unit QProfil;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  IB_UpdateBar, IB_NavigationBar, Grids,
  IB_Grid, StdCtrls, ExtCtrls,
  IB_Controls, IB_Components, IB_Access;

type
  TFormQProfil = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    IB_Grid1: TIB_Grid;
    IB_Grid2: TIB_Grid;
    IB_NavigationBar1: TIB_NavigationBar;
    IB_NavigationBar2: TIB_NavigationBar;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_UpdateBar2: TIB_UpdateBar;
    IB_Memo1: TIB_Memo;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Query2: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    IB_Memo2: TIB_Memo;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Button3: TButton;
    IB_Query3: TIB_Query;
    Button4: TButton;
    Button5: TButton;
    IB_DSQL1: TIB_DSQL;
    procedure FormActivate(Sender: TObject);
    procedure IB_Query2BeforeInsert(IB_Dataset: TIB_Dataset);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure IB_Grid2DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Button4Click(Sender: TObject);
    procedure IB_Grid2DrawFocusedCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Button5Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure RefreshSumme;
    procedure NewProfil;
    procedure NewPhase;
  end;

var
  FormQProfil: TFormQProfil;

implementation

uses
  anfix32, QGruppe, Datensicherung,
  Datenbank, Funktionen_Auftrag, wanfix32;

{$R *.dfm}

procedure TFormQProfil.FormActivate(Sender: TObject);
begin
  if not (IB_Query1.Active) then
    IB_Query1.Open;
  if not (IB_Query2.Active) then
    IB_Query2.Open;
  ComboBox1.Items.assign(FormQGruppe.FetchKuerzel);
end;

procedure TFormQProfil.IB_Query2BeforeInsert(IB_Dataset: TIB_Dataset);
begin
  if IB_dataSet.FieldByName('PROFIL_R').IsNull then
    IB_dataSet.FieldByName('PROFIL_R').AsInteger := IB_query1.FieldByName('RID').AsInteger;
end;

procedure TFormQProfil.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  IB_Query2.ParamByName('CROSSREF').AsInteger := IB_Dataset.FieldByName('RID').AsInteger;
end;

procedure TFormQProfil.IB_Query2BeforePost(IB_Dataset: TIB_Dataset);
begin
  if IB_dataSet.FieldByName('PROFIL_R').IsNull then
  begin
    IB_dataSet.FieldByName('PROFIL_R').AsInteger := IB_query1.FieldByName('RID').AsInteger;
    beep;
  end;
end;

procedure TFormQProfil.Button1Click(Sender: TObject);
begin
  NewProfil;
end;

procedure TFormQProfil.Button2Click(Sender: TObject);
begin
  NewPhase;
end;

procedure TFormQProfil.Button3Click(Sender: TObject);
var
  GRUPPE_R: integer;
begin
  GRUPPE_R := FormQGruppe.FetchRIDfromKuerzel(ComboBox1.items[ComboBox1.itemIndex]);
  if (GRUPPE_R <> -1) then
    with IB_Query2 do
    begin
      if not (eof) then
      begin
        if (State <> dssedit) and (State <> dssinsert) then
          edit;
        FieldByName('GRUPPE_R').AsInteger := GRUPPE_R;
        post;
        next;
      end;
    end;
end;

procedure TFormQProfil.IB_Grid2DrawFocusedCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  _CellDisplayText: string;
begin
  with sender as TIB_Grid do
  begin
    _CellDisplayText := GetCellDisplayText(ACol, ARow);
    if (ACol = 4) then
      _CellDisplayText := FormQGruppe.FetchKuerzelfromRID(strtol(_CellDisplayText));
    canvas.Font.style := [fsbold];
    canvas.font.color := clwhite;
    canvas.brush.color := clblue;
    DefaultDrawCell(ACol, ARow, Rect, State, _CellDisplayText, GetCellAlignment(ACol, ARow));
    canvas.brush.color := clwhite;
    canvas.font.color := clblack;
    canvas.Font.style := [];
  end;

end;

procedure TFormQProfil.IB_Grid2DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  _CellDisplayText: string;
begin
  with sender as TIB_Grid do
  begin
  // important: set DefDrawBefore to false
    _CellDisplayText := GetCellDisplayText(ACol, ARow);
    if (ACol = 4) and (_CellDisplayText <> '') then
    begin
      _CellDisplayText := FormQGruppe.FetchKuerzelFromRID(strtol(_CellDisplayText));
    end;
    DefaultDrawCell(ACol, ARow, Rect, State, _CellDisplayText, GetCellAlignment(ACol, ARow));
  end;
end;

procedure TFormQProfil.RefreshSumme;
var
  Summe: integer;
begin
  with IB_query3 do
  begin
    ParamByName('CROSSREF').AsInteger := IB_Query1.FieldByName('RID').AsInteger;
    Open;
    Summe := FieldByName('D_SUMME').AsInteger;
    if (Summe <> IB_Query1.FieldByName('DAUER').AsInteger) then
    begin
      IB_Query1.edit;
      IB_Query1.FieldByName('DAUER').AsInteger := Summe;
      IB_Query1.post;
    end;
    Close;
  end;
end;

procedure TFormQProfil.Button4Click(Sender: TObject);
begin
  RefreshSumme;
end;

procedure TFormQProfil.Button5Click(Sender: TObject);
begin
 //
  if not (IB_Query1.Eof) then
    if doit('Profil "' + IB_query1.FieldByName('NAME').AsString + '" wirklich löschen?' + #13 +
      'Alle zugehörigen Phasen gehen dabei verloren!' + #13 +
      'Jetzt löschen') then
    begin
      IB_DSQL1.ParamByName('CROSSREF').AsInteger := IB_Query1.FieldByName('RID').AsInteger;
      IB_DSQL1.Execute;
      IB_Query2.Refresh;
      IB_query1.Delete;
      IB_query2.refresh;
    end;
end;

procedure TFormQProfil.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssCtrl in Shift then
  begin
    case key of
      VK_insert: begin
          if IB_Grid1.Focused then
            NewProfil;
          if IB_Grid2.Focused then
            NewPhase;
          key := 0;
        end;
    end;
  end;
end;

procedure TFormQProfil.NewPhase;
var
  One: integer;
  two: integer;
begin
  with IB_Query2 do
  begin
    One := GEN_ID('GEN_PHASE', 0);
    disablecontrols;
    insert;
    post;
    two := GEN_ID('GEN_PHASE', 0);
    if (two - one > 1) then
    begin
      locate('RID', two - 1, []);
      delete;
    end;
    locate('RID', two, []);
    enablecontrols;
  end;
end;

procedure TFormQProfil.NewProfil;
begin
  with IB_Query1 do
  begin
    disablecontrols;
    insert;
    post;
    locate('RID', GEN_ID('GEN_PROFIL', 0), []);
    enablecontrols;
  end;
end;

procedure TFormQProfil.FormCreate(Sender: TObject);
begin
  EnsureHints(IB_Query1.Hints);
  EnsureHints(IB_Query2.Hints);
  EnsureHints(IB_Query3.Hints);
end;

end.

