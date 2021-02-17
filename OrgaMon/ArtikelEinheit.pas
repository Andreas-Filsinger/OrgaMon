{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2017  Andreas Filsinger
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
unit ArtikelEinheit;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, Grids, IB_Grid,
  ExtCtrls, IB_Access, IB_UpdateBar,
  IB_Components, Vcl.Buttons;

type
  TFormArtikelEinheit = class(TForm)
    Label1: TLabel;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_UpdateBar1: TIB_UpdateBar;
    IB_Grid1: TIB_Grid;
    Image2: TImage;
    SpeedButton1: TSpeedButton;
    Edit1: TEdit;
    procedure Image2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure IB_Query1AfterInsert(IB_Dataset: TIB_Dataset);
    procedure IB_Query1ConfirmDelete(Sender: TComponent;
      var Confirmed: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormArtikelEinheit: TFormArtikelEinheit;

implementation

uses
  globals, CareTakerClient, anfix,
  wanfix, dbOrgaMon, Funktionen_Beleg;

{$R *.dfm}

procedure TFormArtikelEinheit.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Einheiten');
end;

procedure TFormArtikelEinheit.SpeedButton1Click(Sender: TObject);

  procedure migrate (FROM_RID,TO_RID:Integer);
  var
   References: TStringList;
  begin
     // make a copy of the Record
     e_x_sql(
      {} 'insert into EINHEIT (RID,EINHEIT,BASIS,ART,NENNER) select '+
      {} IntTostr(TO_RID)+',EINHEIT,BASIS,ART,NENNER from EINHEIT where RID='+Inttostr(FROM_RID));

     // route the OLD to the NEW
     References := TStringList.create;
     e_w_preDeleteEinheit(cRID_UnSet,References);
     //
     e_x_dereference(References, FROM_RID, TO_RID);
     References.free;

     // delete the OLD, so this RID is free at all
     e_x_sql('delete from EINHEIT where RID='+INttoStr(FROM_RID));
  end;

  function e_w_newRID : Integer;
  begin
    repeat
      result:= e_w_GEN('GEN_EINHEIT');
      if e_r_NoRID('EINHEIT_R',result) then
        break;
    until eternity;
  end;

var
 ALT_EINHEIT_R: Integer;
 NEU_EINHEIT_R: Integer;
 WUNSCH_EINHEIT_R: Integer;
begin
   ALT_EINHEIT_R := IB_Query1.FieldByName('RID').AsInteger;
   if (IB_Query1.state<>dssedit) and (ALT_EINHEIT_R>=cRID_FirstValid) then
   begin
     BeginHourGlass;
     NEU_EINHEIT_R := ALT_EINHEIT_R;
     repeat

       WUNSCH_EINHEIT_R := StrToIntDef(edit1.Text,cRID_Unset);
       if (WUNSCH_EINHEIT_R=ALT_EINHEIT_R) then
        break;

       if (WUNSCH_EINHEIT_R>=cRID_FirstValid) then
       begin
         if e_r_isRID('EINHEIT_R',WUNSCH_EINHEIT_R) then
           migrate(WUNSCH_EINHEIT_R,e_w_newRID);
         NEU_EINHEIT_R := WUNSCH_EINHEIT_R;
       end else
       begin
         NEU_EINHEIT_R := e_w_newRID;
       end;

       migrate(ALT_EINHEIT_R,NEU_EINHEIT_R);
     until yet;

     // GUI
     edit1.Text := '';
     IB_Query1.Refresh;
     IB_Query1.Locate('RID',NEU_EINHEIT_R,[]);

     EndHourGlass;
   end;
end;

procedure TFormArtikelEinheit.FormActivate(Sender: TObject);
begin
  if not (IB_Query1.Active) then
    IB_Query1.Open;
end;

procedure TFormArtikelEinheit.FormDeactivate(Sender: TObject);
begin
  IB_Query1.Close;
end;

procedure TFormArtikelEinheit.IB_Query1AfterInsert(
  IB_Dataset: TIB_Dataset);
begin
 IB_Dataset.post;
 IB_Dataset.Refresh;
 IB_Query1.Locate('RID',e_r_gen('GEN_EINHEIT'),[]);
end;

procedure TFormArtikelEinheit.IB_Query1ConfirmDelete(Sender: TComponent;
  var Confirmed: Boolean);
begin
  Confirmed := false;
  with Sender as TIB_Dataset do
    if doit(FieldByName('EINHEIT').AsString + #13 + FieldByName('BASIS').AsString + #13 +
      'wirklich löschen') then
    begin
      BeginHourGlass;
      e_w_preDeleteEinheit(FieldByName('RID').AsInteger);
      Confirmed := true;
      EndHourGlass;
    end;

end;

end.

