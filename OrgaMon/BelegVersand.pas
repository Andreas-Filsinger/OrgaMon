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
unit BelegVersand;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, IB_UpdateBar,
  ExtCtrls, Grids, IB_Grid,
  IB_Components, IB_Access, StdCtrls, IB_Controls, JvComponentBase,
  JvFormPlacement, Vcl.Buttons;

type
  TFormBelegVersand = class(TForm)
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Label3: TLabel;
    IB_UpdateBar1: TIB_UpdateBar;
    Image2: TImage;
    Button20: TButton;
    Button2: TButton;
    JvFormStorage1: TJvFormStorage;
    SpeedButton1: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure IB_Query1ConfirmDelete(Sender: TComponent; var Confirmed: Boolean);
    procedure Image2Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure IB_Query1BeforePrepare(Sender: TIB_Statement);
    procedure IB_Grid1GetDisplayText(Sender: TObject; ACol, ARow: Integer; var AString: string);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    Grid1_Col_Bearbeiter: Integer;

    procedure EnsureOpen;
    procedure SetStandardVersandData;
    procedure ReflectData;
    function PERSON_R: Integer;
  public
    { Public-Deklarationen }
    procedure EnsureLocateTo(BELEG_R: Integer; TL: Integer);
    procedure SetContext(BELEG_R: Integer; TL: Integer);
  end;

var
  FormBelegVersand: TFormBelegVersand;

implementation

uses
  Jvgnugettext, JclMiscel,
  anfix32, wanfix32,
  globals,
  Versender, Main, Datenbank,
  GUIHelp,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  dbOrgaMon,
  CaretakerClient, Bearbeiter;

{$R *.DFM}

procedure TFormBelegVersand.EnsureOpen;
begin
  if not(IB_Query1.Active) then
    IB_Query1.Open;
end;

procedure TFormBelegVersand.FormActivate(Sender: TObject);
begin
  EnsureOpen;
  ComboBox1.Items.Assign(FormVersender.Versender);
  ComboBox1.Items.Insert(0, cRefComboOhneEintrag);
  ComboBox2.Items.Assign(FormVersender.Versandformen);
  ComboBox2.Items.Insert(0, cRefComboOhneEintrag);
  ReflectData;
end;

procedure TFormBelegVersand.SetContext(BELEG_R: Integer; TL: Integer);
begin
  EnsureLocateTo(BELEG_R, TL);
  show;
end;

procedure TFormBelegVersand.EnsureLocateTo(BELEG_R: Integer; TL: Integer);
begin
  EnsureOpen;
  with IB_Query1 do
  begin
    //
    ParamByName('CROSSREF').AsInteger := BELEG_R;
    refresh;

    // Erstanlage
    if IsEmpty then
    begin
      // Hey erst mal anlegen!
      Insert;
      FieldByName('RID').AsInteger := cRID_AutoInc;
      FieldByName('BELEG_R').AsInteger := BELEG_R;
      FieldByName('TEILLIEFERUNG').AsInteger := TL;
      SetStandardVersandData;
      post;
      EnsureLocateTo(BELEG_R, TL);
    end
    else
    begin
      // Existiert diese Teillieferung?
      if not(locate('TEILLIEFERUNG', TL, [])) then
      begin
        Insert;
        FieldByName('RID').AsInteger := cRID_AutoInc;
        FieldByName('BELEG_R').AsInteger := BELEG_R;
        FieldByName('TEILLIEFERUNG').AsInteger := TL;
        SetStandardVersandData;
        post;
        EnsureLocateTo(BELEG_R, TL);
      end;
    end;
    refresh; // notwendig wegen obiger selektion!
  end;
end;

procedure TFormBelegVersand.IB_Grid1GetDisplayText(Sender: TObject; ACol, ARow: Integer; var AString: string);
begin
  if (Grid1_Col_Bearbeiter = -2) then
  begin
    Grid1_Col_Bearbeiter := HeaderACol(IB_Grid1, 'BEARBEITER_R');
  end;
  if (ARow > 0) then
  begin
    if (AString <> '') then
      if (ACol = Grid1_Col_Bearbeiter) then
        AString := FormBearbeiter.FetchKURZFromRID(strtointdef(AString, 0));
  end;

end;

procedure TFormBelegVersand.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  ReflectData;
end;

procedure TFormBelegVersand.IB_Query1BeforePrepare(Sender: TIB_Statement);
begin
  Grid1_Col_Bearbeiter := -2;
end;

procedure TFormBelegVersand.IB_Query1ConfirmDelete(Sender: TComponent; var Confirmed: Boolean);
begin
  Confirmed := false;
  with Sender as TIB_Dataset do
    if doit(_('Versand vom ') + #13 + FieldByName('AUSGANG').AsString + #13 + _('wirklich löschen'), true) then
    begin
      // e_w_preDeleteVersand(Fieldbyname('RID').AsInteger);
      Confirmed := true;
    end;

end;

procedure TFormBelegVersand.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Versand');
end;

function TFormBelegVersand.PERSON_R: Integer;
begin
  result := e_r_sql('select PERSON_R from BELEG where RID=' + inttostr(IB_Query1.FieldByName('BELEG_R').AsInteger));
end;

procedure TFormBelegVersand.Button20Click(Sender: TObject);
begin
  // einfach den Beleg direkt drucken
  // printto(Handle,e_r_BelegFName(PERSON_R,IB_Query1.FieldByName('BELEG_R').AsINteger,IB_Query1.FieldByName('TEILLIEFERUNG').AsInteger));
  PrintHTMLByIE(e_r_BelegFName(PERSON_R, IB_Query1.FieldByName('BELEG_R').AsInteger,
    IB_Query1.FieldByName('TEILLIEFERUNG').AsInteger));
end;

procedure TFormBelegVersand.Button2Click(Sender: TObject);
begin
  //
  openShell(e_r_BelegFName(PERSON_R, IB_Query1.FieldByName('BELEG_R').AsInteger, IB_Query1.FieldByName('TEILLIEFERUNG')
    .AsInteger));
end;

procedure TFormBelegVersand.ComboBox1Change(Sender: TObject);
var
  k: Integer;
begin
  k := FormVersender.Versender.indexof(ComboBox1.Text);
  IB_Query1.edit;
  if (k = -1) then
  begin
    IB_Query1.FieldByName('VERSENDER_R').clear;
  end
  else
  begin
    IB_Query1.FieldByName('VERSENDER_R').AsInteger := Integer(FormVersender.Versender.objects[k]);
  end;
  IB_Query1.post;
  IB_UpdateBar1.BtnClick(ubRefreshAll);
end;

procedure TFormBelegVersand.ComboBox2Change(Sender: TObject);
var
  k, RID: Integer;
begin
  k := FormVersender.Versandformen.indexof(ComboBox2.Text);
  IB_Query1.edit;
  if (k = -1) then
  begin
    IB_Query1.FieldByName('PACKFORM_R').clear;
    IB_Query1.FieldByName('LEERGEWICHT').clear;
  end
  else
  begin
    RID := Integer(FormVersender.Versandformen.objects[k]);
    IB_Query1.FieldByName('PACKFORM_R').AsInteger := RID;
    IB_Query1.FieldByName('LEERGEWICHT').AsInteger := e_r_LeerGewicht(RID);
  end;
  IB_Query1.post;
  IB_UpdateBar1.BtnClick(ubRefreshAll);
end;

procedure TFormBelegVersand.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TFormBelegVersand.SetStandardVersandData;
var
  Packform_RID: Integer;
  VERSENDER_R: Integer;
begin
  with IB_Query1 do
  begin
    // Standard-Versandform eintragen!
    VERSENDER_R := e_r_StandardVersender;
    if (VERSENDER_R > 0) then
    begin
      FormVersender.LocateVersender(VERSENDER_R);
      FieldByName('VERSENDER_R').AsInteger := FormVersender.IB_Query1.FieldByName('RID').AsInteger;
      Packform_RID := FormVersender.IB_Query1.FieldByName('PACKFORM_R').AsInteger;
      FieldByName('PACKFORM_R').AsInteger := Packform_RID;
      FieldByName('LEERGEWICHT').AsInteger := e_r_LeerGewicht(Packform_RID);
    end;
  end;
end;

procedure TFormBelegVersand.SpeedButton1Click(Sender: TObject);
var
  FName: string;
  FName_pdf: string;
  VORLAGE_R: Integer;
  ErrorMsg: string;
  BELEG_R: Integer;
  TEILLIEFERUNG: Integer;
  EREIGNIS_R: Integer;
  VERSAND_R: Integer;
  PDF: TStringList;
begin
  BeginHourGlass;
  PDF := nil;
  ErrorMsg := '';
  BELEG_R := IB_Query1.FieldByName('BELEG_R').AsInteger;
  TEILLIEFERUNG := IB_Query1.FieldByName('TEILLIEFERUNG').AsInteger;
  VERSAND_R := e_r_sql(
    { } 'select RID from VERSAND where' +
    { } ' (BELEG_R=' + inttostr(BELEG_R) + ') and' +
    { } ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')');
  repeat

    // Bestimmung des Dateinamens
    FName := e_r_BelegFNameCombined(
      { } PERSON_R,
      { } BELEG_R,
      { } TEILLIEFERUNG);

    if not(FileExists(FName)) then
      FName := e_r_BelegFName(
        { } PERSON_R,
        { } BELEG_R,
        { } TEILLIEFERUNG);

    PDF := html2pdf(FName);
    ErrorMsg := PDF.values['ERROR'];
    if (ErrorMsg<>'') then
     break;
    FName_pdf := PDF.Values['ConversionOutFName'];

    if not(FileExists(FName_pdf)) then
    begin
      ErrorMsg := 'die PDF-Erstellung ist nicht erfolgt';
      break;
    end;

    // openShell(FName_pdf);

    // Ereignis sicherstellen
    EREIGNIS_R := e_r_sql(
      { } 'select RID from' +
      { } ' EREIGNIS where' +
      { } ' (ART=' + inttostr(eT_RechnungPerEMail) + ') and ' +
      { } ' (BELEG_R=' + inttostr(BELEG_R) + ') and ' +
      { } ' (TEILLIEFERUNG=' + inttostr(TEILLIEFERUNG) + ')');

    if (EREIGNIS_R < cRID_FirstValid) then
    begin
      // Ereignis anlegen
      EREIGNIS_R := e_w_GEN('EREIGNIS_GID');
      e_x_sql('insert into EREIGNIS (RID,ART,BEARBEITER_R,PERSON_R,BELEG_R,TEILLIEFERUNG,VERSAND_R) values (' +
        { } inttostr(EREIGNIS_R) + ',' +
        { } inttostr(eT_RechnungPerEMail) + ',' +
        { } inttostr(sBearbeiter) + ',' +
        { } inttostr(PERSON_R) + ',' +
        { } inttostr(BELEG_R) + ',' +
        { } inttostr(TEILLIEFERUNG) + ',' +
        { } inttostr(VERSAND_R) + ')');
    end;

    // Ensure eMail Entry
    VORLAGE_R := e_r_VorlageMail('RECHNUNG');
    if (VORLAGE_R < cRID_FirstValid) then
    begin
      ErrorMsg := 'eMail-Vorlage "RECHNUNG" existiert nicht!';
      break;
    end;

    e_x_sql('insert into EMAIL (' +
      { } 'RID,PERSON_R,VORLAGE_R,EREIGNIS_R,DATEI_ANLAGE) values (' +
      { } '0' + ',' +
      { } inttostr(PERSON_R) + ',' +
      { } inttostr(VORLAGE_R) + ',' +
      { } inttostr(EREIGNIS_R) + ',' +
      { } '''' + FName_pdf + '''' + ')');

  until true;
  EndHourGlass;
  if (ErrorMsg <> '') then
    ShowMessage(ErrorMsg);
  if assigned(PDF) then
       PDF.Free;

end;

procedure TFormBelegVersand.ReflectData;
begin
  with IB_Query1 do
  begin
    Label3.caption := inttostr(FieldByName('GEWICHT').AsInteger + FieldByName('LEERGEWICHT').AsInteger) + 'g';
    ComboBox1.Text := FindRID(FieldByName('VERSENDER_R').AsInteger, FormVersender.Versender);
    ComboBox2.Text := FindRID(FieldByName('PACKFORM_R').AsInteger, FormVersender.Versandformen);
  end;
end;

end.
