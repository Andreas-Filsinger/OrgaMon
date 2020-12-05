{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2019  Andreas Filsinger
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
unit Buchung;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  IB_Components, IB_Access, IBC_CustomLabel,
  IBC_Label, StdCtrls, IB_Controls,
  ComCtrls, Mask, ExtCtrls,
  IB_UpdateBar, IB_SearchBar, IB_DatasetBar,
  IB_NavigationBar, Buttons, gplists,
  Grids, IB_Grid, Datenbank, IB_EditButton;

type
  TFormBuchung = class(TForm)
    IB_UpdateBar1: TIB_UpdateBar;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    IB_Edit1: TIB_Edit;
    IB_Edit2: TIB_Edit;
    IB_CheckBox1: TIB_CheckBox;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Memo1: TIB_Memo;
    IB_Edit3: TIB_Edit;
    IB_Memo2: TIB_Memo;
    IB_Date1: TIB_Date;
    Label10: TLabel;
    IB_Date2: TIB_Date;
    Label11: TLabel;
    IB_Edit4: TIB_Edit;
    IB_Date3: TIB_Date;
    IB_Date4: TIB_Date;
    IB_Date5: TIB_Date;
    Label12: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label13: TLabel;
    IB_Memo3: TIB_Memo;
    SpeedButton1: TSpeedButton;
    Label14: TLabel;
    IB_Edit5: TIB_Edit;
    IB_Edit6: TIB_Edit;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    IB_Edit7: TIB_Edit;
    IB_Edit8: TIB_Edit;
    IB_Edit9: TIB_Edit;
    IB_Edit10: TIB_Edit;
    IB_Label1: TIB_Label;
    Label18: TLabel;
    IB_Edit11: TIB_Edit;
    IB_Edit14: TIB_Edit;
    Button5: TButton;
    Image2: TImage;
    IB_Edit15: TIB_Edit;
    Label19: TLabel;
    Label20: TLabel;
    SpeedButton2: TSpeedButton;
    IB_Edit16: TIB_Edit;
    Label21: TLabel;
    SpeedButton3: TSpeedButton;
    IB_Text4: TIB_Text;
    SpeedButton12: TSpeedButton;
    IB_Text5: TIB_Text;
    Label22: TLabel;
    IB_Query2: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    Panel1: TPanel;
    Label24: TLabel;
    SpeedButton4: TSpeedButton;
    IB_Text1: TIB_Text;
    Label1: TLabel;
    IB_Edit12: TIB_Edit;
    SpeedButton5: TSpeedButton;
    Button11: TButton;
    IB_CheckBox2: TIB_CheckBox;
    Label8: TLabel;
    IB_Text3: TIB_Text;
    IB_Edit13: TIB_Edit;
    SpeedButton49: TSpeedButton;
    Label23: TLabel;
    Label25: TLabel;
    IB_Edit17: TIB_Edit;
    IB_Edit18: TIB_Edit;
    IB_Date6: TIB_Date;
    Label26: TLabel;
    IB_Edit19: TIB_Edit;
    procedure IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
    procedure Button5Click(Sender: TObject);
    procedure IB_Query1ConfirmDelete(Sender: TComponent;
      var Confirmed: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
    procedure SpeedButton4Click(Sender: TObject);
    procedure IB_Grid1DblClick(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure SpeedButton49Click(Sender: TObject);
  private
    { Private-Deklarationen }
    Historie_Read: integer;
    Historie: TgpIntegerList;
    BUCH_R: integer;
    sFieldBlocklist: TStringList;

    procedure addHistorie(BUCH_R: integer);
    procedure locateTo(pBUCH_R: integer);
    procedure reflectData;
  public
    { Public-Deklarationen }
    procedure setContext(pBUCH_R: integer = 0);
    procedure doBuche(BUCH_R: integer);
  end;

var
  FormBuchung: TFormBuchung;

implementation

{$R *.dfm}

uses
  globals, anfix32,
  Funktionen_Basis,
  Funktionen_Buch,
  Funktionen_Beleg,
  Person, Belege, Ereignis,
 CaretakerClient, CareServer,
  dbOrgaMon,
  wanfix32, Buchhalter;

procedure TFormBuchung.addHistorie(BUCH_R: integer);
begin

  //
  if not(assigned(Historie)) then
    Historie := TgpIntegerList.create;

  // Überhaupt eintragen?
  repeat
    if (Historie.count > 0) then
      if (Historie[pred(Historie.count)] = BUCH_R) then
        break;

    //
    Historie.add(BUCH_R);
    Historie_Read := pred(Historie.count);

  until true;

end;

procedure TFormBuchung.Button11Click(Sender: TObject);
var
  sAusgleich: TStringList;
  sScript: TStringList;
  n: integer;
  Line: string;
  BELEG_R, PERSON_R: integer;
begin
  if doit('Alle "BELEG="-Zeilen im "Z" buchen') then
  begin
    sAusgleich := TStringList.create;
    sScript := TStringList.create;
    IB_Query1.FieldByName('SKRIPT').AssignTo(sScript);
    for n := 0 to pred(sScript.count) do
      if (pos('BELEG=', sScript[n]) = 1) then
      begin
        Line := nextp(sScript[n], '=', 1);

        BELEG_R := strtointdef(nextp(Line, ';', 0), cRID_Null);
        PERSON_R := e_r_sql(
          'select PERSON_R from BELEG where RID=' + inttostr(BELEG_R));

        sAusgleich.add(inttostr(PERSON_R) + ';' + inttostr(BELEG_R)
            + ';' + nextp(Line, ';', 2) + ';' + long2date
            (datetime2long(IB_Query1.FieldByName('DATUM').AsDate))
            + ';' + IB_Query1.FieldByName('RID')
            .AsString + ';' + ';' + ';' + nextp(Line, ';', 1) + ';' + '');
      end;
    b_w_ForderungAusgleich(sAusgleich);
    sScript.free;
    sAusgleich.free;
  end;
end;

procedure TFormBuchung.Button1Click(Sender: TObject);
begin
  FormPerson.setContext(IB_Query1.FieldByName('PERSON_R').AsInteger);
end;

procedure TFormBuchung.Button2Click(Sender: TObject);
begin
  FormBelege.setContext(0, IB_Query1.FieldByName('BELEG_R').AsInteger);
end;

procedure TFormBuchung.Button3Click(Sender: TObject);
begin
  FormEreignis.setContext(IB_Query1.FieldByName('EREIGNIS_R').AsInteger);
end;

procedure TFormBuchung.Button5Click(Sender: TObject);
begin
  doBuche(BUCH_R);
  locateTo(BUCH_R);
end;

procedure TFormBuchung.doBuche(BUCH_R: integer);
var
  sMessage: TStringList;
begin
  sMessage := TStringList.create;
  b_w_buche(BUCH_R, sMessage);
  FormCareServer.ShowIfError(sMessage);
  sMessage.free;
  //
end;

procedure TFormBuchung.IB_Grid1DblClick(Sender: TObject);
begin
  FormBelege.setContext(0, IB_Query2.FieldByName('BELEG_R').AsInteger);
end;

procedure TFormBuchung.IB_Query1AfterPost(IB_Dataset: TIB_Dataset);
begin
  if IB_Dataset.FieldByName('BETRAG').IsNotNull then
    doBuche(BUCH_R);
  // refresh!
  FormBuchhalter.refreshOnActivate := true;
  addHistorie(BUCH_R);
  locateTo(BUCH_R);
end;

procedure TFormBuchung.IB_Query1BeforePost(IB_Dataset: TIB_Dataset);
begin
  with IB_Dataset do
  begin
    if FieldByName('BETRAG').IsNotNull then
      if FieldByName('DATUM').IsNull then
        FieldByName('DATUM').AsDateTime := now;
  end;

  if not(assigned(sFieldBlocklist)) then
  begin
    sFieldBlocklist := TStringList.create;
    sFieldBlocklist.add('MOMENT');
    sFieldBlocklist.add('NAME');
    sFieldBlocklist.add('DATUM');
    sFieldBlocklist.add('WERTSTELLUNG');
    sFieldBlocklist.add('POSNO');
    sFieldBlocklist.add('TEXT');
    sFieldBlocklist.add('BETRAG');
    sFieldBlocklist.add('VORGANG');
    sFieldBlocklist.add('STEMPEL_NO');
  end;

  // imp pend: revert changes
end;

procedure TFormBuchung.IB_Query1ConfirmDelete(Sender: TComponent;
  var Confirmed: Boolean);
begin

  Confirmed := false;
  repeat

    if not(doit('Buchung wirklich löschen')) then
      break;

    b_w_preDeleteBuch(BUCH_R);
    Confirmed := true;
  until true;

end;

procedure TFormBuchung.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Buchfuehrung');
end;

procedure TFormBuchung.locateTo(pBUCH_R: integer);
begin
  if (pBUCH_R >= cRID_FirstValid) then
  begin
    with IB_Query1 do
    begin
      if (FieldByName('MASTER_R').AsInteger = pBUCH_R) then
        refresh
      else
        ParamByName('CROSSREF').AsInteger := pBUCH_R;
      if not(active) then
        open;
    end;
    BUCH_R := pBUCH_R;
    reflectData;
  end;
end;

procedure TFormBuchung.reflectData;
var
  _color: TColor;
  ExterneQuelle: Boolean;
begin
  _color := clBtnFace;
  with IB_Query1 do
  begin

    // Farbe
    if FieldByName('RID').IsNotNull and FieldByName('MASTER_R').IsNotNull then
      if FieldByName('RID').AsInteger <> FieldByName('MASTER_R').AsInteger then
        _color := clred;

    // Freigegebene Felder
    ExterneQuelle := FieldByName('MD5').IsNotNull;

    IB_Date1.ReadOnly := ExterneQuelle;
    IB_Date2.readonly := ExterneQuelle;
    IB_Date3.readonly := ExterneQuelle;
    IB_Date4.readonly := ExterneQuelle;
    IB_Date5.readonly := ExterneQuelle;
    IB_Edit2.readonly := ExterneQuelle;
    IB_Edit3.readonly := ExterneQuelle;
    IB_Edit5.readonly := ExterneQuelle;
    IB_Edit6.readonly := ExterneQuelle;
    IB_Edit14.readonly := ExterneQuelle;
    IB_Memo3.readonly := ExterneQuelle;

    // Name des Stemples
    Label19.caption := b_r_Stempel(FieldByName('STEMPEL_R').AsInteger);

    // Name des Gegenkontos
    Label20.caption := e_r_sqls
      ('select KONTO from BUCH where ' + ' (BETRAG is null) and ' +
        ' (NAME=''' + FieldByName('GEGENKONTO').AsString + ''')');

    // Alle FolgeBuchungssätze
    IB_Query2.ParamByName('CROSSREF').AsInteger := BUCH_R;
    if not(IB_Query2.active) then
      IB_Query2.open;

  end;
  if (_color <> color) then
    color := _color;
end;

procedure TFormBuchung.setContext(pBUCH_R: integer);
begin
  BeginHourGlass;
  pBUCH_R := e_r_InitialerBuchungssatz(pBUCH_R);
  if (pBUCH_R >= cRID_FirstValid) then
  begin
    with IB_Query1 do
    begin
      locateTo(pBUCH_R);
      addHistorie(pBUCH_R);
    end;
    show;
  end
  else
    beep;
  EndHourGlass;
end;

procedure TFormBuchung.SpeedButton12Click(Sender: TObject);
begin
  locateTo(BUCH_R);
end;

procedure TFormBuchung.SpeedButton1Click(Sender: TObject);
begin
  openShell(SystemPath + '\SKR03.txt');
end;

procedure TFormBuchung.SpeedButton2Click(Sender: TObject);
begin
  with IB_Query1 do
  begin
    if (State <> dssedit) then
      locateTo(e_r_sql
          ('select RID from BUCH where' + ' (NAME=''' + FieldByName
            ('GEGENKONTO').AsString + ''') and' + ' (BETRAG is null)'));
  end;
end;

procedure TFormBuchung.SpeedButton3Click(Sender: TObject);
var
  BUCH_R: integer;
begin

  if (Historie.count > 0) and (Historie_Read >= 0) then
  begin
    //
    BUCH_R := IB_Query1.FieldByName('RID').AsInteger;

    repeat
      if (BUCH_R <> Historie[Historie_Read]) then
      begin
        locateTo(Historie[Historie_Read]);
        break;
      end;
      dec(Historie_Read);
      if (Historie_Read < 0) then
        break;
    until false;
  end
  else
    beep;
end;

procedure TFormBuchung.SpeedButton49Click(Sender: TObject);
var
  DirEntries: TStringList;
  n: integer;
begin
  // Öffne die zugeordneten PDF
  DirEntries := b_r_PDF(IB_Query1.FieldByName('MASTER_R').AsInteger);
  if (DirEntries.count > 0) then
  begin
    for n := 0 to pred(DirEntries.count) do
      openShell(DirEntries[n])
  end
  else
    ShowMessage('kein PDF vorhanden!');
  DirEntries.free;
end;

procedure TFormBuchung.SpeedButton4Click(Sender: TObject);
var
  BUCH_R: integer;
begin
  BUCH_R := e_w_GEN('GEN_BUCH');
  e_x_sql('insert into BUCH (RID) values (' + inttostr
      (BUCH_R) + ')');
  addHistorie(BUCH_R);
  locateTo(BUCH_R);
end;

procedure TFormBuchung.SpeedButton5Click(Sender: TObject);
begin
  locateTo(b_w_Copy(BUCH_R));
  IB_query1.Edit;
end;

end.
