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
unit Arbeitszeit;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, IB_UpdateBar,
  Grids, IB_Access, IB_Grid, IB_Components,
  IB_Controls, JvGIF, Vcl.Buttons;

type
  TFormArbeitszeit = class(TForm)
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    IB_UpdateBar1: TIB_UpdateBar;
    Label5: TLabel;
    Label1: TLabel;
    IB_Memo1: TIB_Memo;
    GroupBox1: TGroupBox;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Edit2: TEdit;
    Button2: TButton;
    GroupBox2: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Edit1: TEdit;
    Button1: TButton;
    Label6: TLabel;
    Label7: TLabel;
    StaticText2: TStaticText;
    Image2: TImage;
    SpeedButton16: TSpeedButton;
    procedure IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure IB_Grid1GetDisplayText(Sender: TObject; ACol, ARow: Integer;
      var AString: string);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
    procedure Image2Click(Sender: TObject);
    procedure IB_Query1ConfirmDelete(Sender: TComponent;
      var Confirmed: Boolean);
    procedure IB_Query1BeforeInsert(IB_Dataset: TIB_Dataset);
    procedure SpeedButton16Click(Sender: TObject);
  private
    { Private-Deklarationen }
    InsideDatasetChange: boolean;
  public
    { Public-Deklarationen }
    procedure RefreshCombos;
    procedure ShowQuickCalc;
  end;

var
  FormArbeitszeit: TFormArbeitszeit;

implementation

uses
  anfix32, Bearbeiter, CareTakerClient,
  globals, Datenbank, wanfix32,
  Funktionen_Basis, dbOrgaMon;

{$R *.dfm}

procedure TFormArbeitszeit.IB_Query1BeforeInsert(IB_Dataset: TIB_Dataset);
begin
  IB_Dataset.FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
end;

procedure TFormArbeitszeit.IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
begin
  with IB_Dataset do
  begin
    if FieldByName('RID').IsNull then
      FieldByName('RID').AsInteger := 0;
    FieldByName('BEARBEITER_R').AsInteger := sBearbeiter;
  end;
end;

procedure TFormArbeitszeit.RefreshCombos;
begin
end;

procedure TFormArbeitszeit.Button1Click(Sender: TObject);
begin
  if RadioButton2.Checked then
  begin
    IB_Query1.FieldByName('ZEIT_V').AsInteger := SecondsGet;
    if IB_Query1.FieldByName('DATUM').IsNull then
      IB_Query1.FieldByName('DATUM').AsDate := Date;
  end else
  begin
    IB_Query1.FieldByName('ZEIT_V').AsInteger := strtoseconds(edit1.Text);
  end;
end;

procedure TFormArbeitszeit.Button2Click(Sender: TObject);
begin
  if RadioButton4.Checked then
  begin
    IB_Query1.FieldByName('ZEIT_N').AsInteger := SecondsGet;
  end else
  begin
    IB_Query1.FieldByName('ZEIT_N').AsInteger := strtoseconds(edit2.Text);
  end;
end;

procedure TFormArbeitszeit.FormActivate(Sender: TObject);
begin
  if not (IB_Query1.Active) then
    IB_Query1.Open
   else
    IB_Query1.refresh;
end;

procedure TFormArbeitszeit.IB_Grid1GetDisplayText(Sender: TObject; ACol,
  ARow: Integer; var AString: string);

const
  cCol_ZEIT_V = 6;
  cCol_ZEIT_N = 7;
  cCol_ZEIT_SUMME = 8;
begin
  if (ARow > 0) then
    with Sender as TIB_Grid do
      case ACol of
        cCol_ZEIT_V: if (AString <> '') then
            AString := secondstostr(strtointdef(AString, 0));
        cCol_ZEIT_N: if (AString <> '') then
            AString := secondstostr(strtointdef(AString, 0));
        cCol_ZEIT_SUMME: if (GetCellDisplayText(cCol_ZEIT_N, ARow) <> '') then
            AString := secondstostr(
              SecondsDiff(
              strtoseconds(GetCellDisplayText(cCol_ZEIT_N, ARow)),
              strtoseconds(GetCellDisplayText(cCol_ZEIT_V, ARow))));
      end;
end;

procedure TFormArbeitszeit.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  with IB_Dataset do
  begin
    InsideDatasetChange := true;
    edit1.Text := secondstostr(FieldByName('ZEIT_V').AsInteger);
    edit2.Text := secondstostr(FieldByName('ZEIT_N').AsInteger);
    InsideDatasetChange := false;
  end;
  ShowQuickCalc;
end;

procedure TFormArbeitszeit.Edit1Change(Sender: TObject);
begin
  if not (InsideDatasetChange) then
    RadioButton1.Checked := true;
end;

procedure TFormArbeitszeit.Edit2Change(Sender: TObject);
begin
  if not (InsideDatasetChange) then
    RadioButton3.Checked := true;
end;

procedure TFormArbeitszeit.ShowQuickCalc;
var
  cZEIT: TIB_Cursor;
  ArbeitsZeit: integer;
  NullFields: integer;

  function SingleArbeitsZeit: integer;
  begin
    with cZEIT do
    begin
      result := SecondsDiff(FieldByName('ZEIT_N').AsInteger, FieldByName('ZEIT_V').AsInteger);
    end;
  end;

begin
  NullFields := 0;
  ArbeitsZeit := 0;
  if IB_Query1.FieldByName('DATUM').IsNotNull then
  begin
    cZEIT := DataModuleDatenbank.nCursor;
    with cZEIT do
    begin
      sql.add('select ZEIT_V,ZEIT_N from ARBEITSZEIT where DATUM=''' +
        long2date(DateTime2Long(IB_Query1.FieldByName('DATUM').AsDate)) +
        '''');
      ApiFirst;
      while not (eof) do
      begin
        repeat
          if FieldbyName('ZEIT_V').IsNull or FieldByName('ZEIT_N').IsNull then
          begin
            inc(NullFields);
            break;
          end;
          inc(ArbeitsZeit, SingleArbeitsZeit);
        until true;
        ApiNext;
      end;
    end;
    cZEIT.free;
  end;
  if (ArbeitsZeit = 0) then
  begin
    StaticText2.Caption := '';
    StaticText2.Color := clBtnFace;
  end else
  begin
    if (NullFields > 0) then
      StaticText2.Color := clred
    else
      StaticText2.Color := cllime;
    StaticText2.Caption := secondstostr(ArbeitsZeit) + ' h';
  end;
end;

procedure TFormArbeitszeit.SpeedButton16Click(Sender: TObject);

var
  BUDGET_R: integer;
  ARBEITSZEIT_R: integer;
begin

  ARBEITSZEIT_R:= e_w_gen('GEN_ARBEITSZEIT');
  BUDGET_R := strtointdef(getSetting('HauptBudget'), cRID_NUll);

  e_x_sql(
  {} 'insert into ARBEITSZEIT (RID,BUGET_R,ZEIT_V,DATUM) values ( '+
  {} inttostr(ARBEITSZEIT_R)+','+
  {} RIDtostr(BUDGET_R) + ','+
  {} inttostr(SecondsGet)+','+
  {} 'CURRENT_DATE'+
  {} ' )');

  IB_Query1.refreshKeys;
  IB_Query1.locate('RID',ARBEITSZEIT_R,[]);

end;

procedure TFormArbeitszeit.IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
begin
  ShowQuickCalc;
end;

procedure TFormArbeitszeit.Image2Click(Sender: TObject);
begin
  //
  openShell(cHelpURL + 'Arbeitszeit');
end;

procedure TFormArbeitszeit.IB_Query1ConfirmDelete(Sender: TComponent;
  var Confirmed: Boolean);
begin
  with Sender as TIB_Dataset do
    Confirmed := doit('Zeiteintrag ' + #13 +
      FieldByName('RID').AsString + #13 +
      'wirklich löschen', true);
end;

end.


