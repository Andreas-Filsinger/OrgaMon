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
unit Vertrag;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  ExtCtrls, IB_UpdateBar, IB_Components,
  Grids, IB_Grid, StdCtrls, IB_Access,
  IB_Controls, Mask, ComCtrls,
  Buttons, Datenbank, IB_EditButton, JvComponentBase, JvFormPlacement;

type
  TFormVertrag = class(TForm)
    IB_Grid1: TIB_Grid;
    IB_DataSource1: TIB_DataSource;
    IB_Query1: TIB_Query;
    IB_UpdateBar1: TIB_UpdateBar;
    Image2: TImage;
    Button11: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    IB_Grid2: TIB_Grid;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    IB_Date1: TIB_Date;
    IB_Date2: TIB_Date;
    IB_Date3: TIB_Date;
    IB_Edit1: TIB_Edit;
    IB_Edit2: TIB_Edit;
    IB_Edit3: TIB_Edit;
    IB_Date4: TIB_Date;
    IB_Memo1: TIB_Memo;
    Label2: TLabel;
    Label11: TLabel;
    IB_Query2: TIB_Query;
    IB_DataSource2: TIB_DataSource;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    IB_Query3: TIB_Query;
    IB_DataSource3: TIB_DataSource;
    TabSheet3: TTabSheet;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    IB_Edit4: TIB_Edit;
    IB_Edit5: TIB_Edit;
    IB_Edit6: TIB_Edit;
    Label16: TLabel;
    IB_UpdateBar2: TIB_UpdateBar;
    Label17: TLabel;
    IB_Edit7: TIB_Edit;
    Button6: TButton;
    SpeedButton4: TSpeedButton;
    Button7: TButton;
    SpeedButton5: TSpeedButton;
    IB_CheckBox1: TIB_CheckBox;
    Button8: TButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    Edit1: TEdit;
    Label12: TLabel;
    SpeedButton8: TSpeedButton;
    Button4: TButton;
    Button5: TButton;
    JvFormStorage1: TJvFormStorage;
    procedure Image2Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure IB_Query1BeforeInsert(IB_Dataset: TIB_Dataset);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure IB_Query2AfterScroll(IB_Dataset: TIB_Dataset);
    procedure IB_Query3AfterScroll(IB_Dataset: TIB_Dataset);
    procedure FormCreate(Sender: TObject);
    procedure IB_Query1ConfirmDelete(Sender: TComponent;
      var Confirmed: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure IB_Query1AfterDelete(IB_Dataset: TIB_Dataset);
    procedure SpeedButton8Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure NeuNehmer;
    procedure NeuVariante;
    procedure RefreshVertragsnehmer;
    procedure AddKontext(LogFileDerVertragsAnwendung: TStringList);
    function VertragLogFName: string;
  public
    { Public-Deklarationen }
    procedure setContext(VERTRAG_R: integer; PERSON_R: integer = 0;
      BELEG_R: integer = 0; BAUSTELLE_R: integer = 0);
    procedure createVertragFromContext;
    procedure createVertragsnehmerFromContext;
  end;

var
  FormVertrag: TFormVertrag;

implementation

uses
  globals, Baustelle,
  CaretakerClient, anfix32, Person,
  Belege, Kontext, OLAP,
  dbOrgaMon, Main,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  Funktionen_LokaleDaten,
  wanfix32, gplists;

{$R *.dfm}
{ TFormVertrag }

procedure TFormVertrag.AddKontext(LogFileDerVertragsAnwendung: TStringList);
var
  n: integer;
  RID: integer;
begin
  for n := 0 to pred(LogFileDerVertragsAnwendung.Count) do
  begin
    if pos('BELEG_R=', LogFileDerVertragsAnwendung[n]) = 1 then
    begin
      RID := strtointdef(nextp(LogFileDerVertragsAnwendung[n], '=', 1),
        cRID_Null);
      FormKontext.cnBELEG.addContext(RID);
      continue;
    end;
    if pos('PERSON_R=', LogFileDerVertragsAnwendung[n]) = 1 then
    begin
      RID := strtointdef(nextp(LogFileDerVertragsAnwendung[n], '=', 1),
        cRID_Null);
      FormKontext.cnPERSON.addContext(RID);
      continue;
    end;
  end;
end;

procedure TFormVertrag.Button11Click(Sender: TObject);
var
  sDiagnose: TStringList;
begin

  BeginHourGlass;
  sDiagnose := e_w_VertragBuchen(IB_Query1.FieldByName('RID').AsInteger);
  EndHourGlass;

  AddKontext(sDiagnose);
  if (sDiagnose.Count > 0) then
    AppendStringsToFile(sDiagnose, VertragLogFName);

  ShowMessage(HugeSingleLine(sDiagnose));
  sDiagnose.free;
  IB_Query1.refresh;
end;

procedure TFormVertrag.Button1Click(Sender: TObject);
begin
  FormPerson.setContext(IB_Query3.FieldByName('PERSON_R').AsInteger);
end;

procedure TFormVertrag.Button2Click(Sender: TObject);
begin
  FormBelege.setContext(0, IB_Query2.FieldByName('BELEG_R').AsInteger);
end;

procedure TFormVertrag.Button3Click(Sender: TObject);
begin
  FormBaustelle.setContext(IB_Query2.FieldByName('BAUSTELLE_R').AsInteger);
end;

procedure TFormVertrag.Button4Click(Sender: TObject);
var
  sDiagnose: TStringList;
begin

  BeginHourGlass;
  sDiagnose := e_w_VertragBuchen;
  EndHourGlass;

  AddKontext(sDiagnose);

  if (sDiagnose.Count > 0) then
  begin
    AppendStringsToFile(sDiagnose, VertragLogFName);
    openShell(VertragLogFName);
  end
  else
  begin
    ShowMessage('Kein Vertrag ist anzuwenden!');
  end;

  sDiagnose.free;

end;

procedure TFormVertrag.Button5Click(Sender: TObject);
var
  BELEG_R: integer;
  VERTRAG_R: TGpIntegerList;
  sDiagnose: TStringList;
begin

  BELEG_R := IB_Query2.FieldByName('BELEG_R').AsInteger;
  VERTRAG_R := e_r_sqlm(
    { } 'select RID from VERTRAG where BELEG_R=' +
    { } inttostr(BELEG_R));

  if (VERTRAG_R.Count > 0) then
  begin

    //
    BeginHourGlass;
    sDiagnose := e_w_VertragBuchen(VERTRAG_R);
    EndHourGlass;

    AddKontext(sDiagnose);

    //
    if (sDiagnose.Count > 0) then
    begin
      AppendStringsToFile(sDiagnose, VertragLogFName);
      openShell(VertragLogFName);
    end
    else
    begin
      ShowMessage('Kein Vertrag ist anzuwenden!');
    end;
    sDiagnose.free;

  end;
  VERTRAG_R.free;

end;

procedure TFormVertrag.NeuNehmer;
begin
  FormKontext.setContext(cContextMode_VertragsNehmerNeu);
end;

procedure TFormVertrag.NeuVariante;
begin
  VertragsVarianten(true);
  FormKontext.setContext(cContextMode_VertragNeu);
end;

procedure TFormVertrag.RefreshVertragsnehmer;
begin
  IB_Query3.refresh;
  Label16.caption := inttostr(IB_Query3.Recordcount);
  IB_Query1.ParamByName('CROSSREF').AsInteger := IB_Query3.FieldByName('RID')
    .AsInteger;
  IB_Query1.refresh;
end;

procedure TFormVertrag.Button6Click(Sender: TObject);
begin
  FormBelege.setContext(0, IB_Query1.FieldByName('VORGABEN_R').AsInteger);
end;

procedure TFormVertrag.Button7Click(Sender: TObject);
var
  sDiagnose: TStringList;
  sSettings: TStringList;
begin
  BeginHourGlass;
  if (Edit1.Text <> '') then
  begin
    sSettings := TStringList.create;
    sSettings.add('Erzwingen=' + cIni_Activate);
    sSettings.add('Per=' + Edit1.Text);
    sDiagnose := e_w_VertragBuchen(IB_Query1.FieldByName('RID').AsInteger,
      sSettings);
    sSettings.free;
  end
  else
  begin
    sDiagnose := e_w_VertragBuchen(IB_Query1.FieldByName('RID')
      .AsInteger, true);
  end;
  AddKontext(sDiagnose);
  if (sDiagnose.Count > 0) then
    AppendStringsToFile(sDiagnose, VertragLogFName);

  EndHourGlass;
  ShowMessage(HugeSingleLine(sDiagnose));
  sDiagnose.free;
  IB_Query1.refresh;
end;

procedure TFormVertrag.Button8Click(Sender: TObject);
begin
  FormBelege.setContext(0, IB_Query1.FieldByName('BELEG_R').AsInteger);
end;

procedure TFormVertrag.createVertragFromContext;
var
  VERTRAG_R: integer;
begin
  // anlegen!
  VERTRAG_R := e_w_gen('GEN_VERTRAG');
  e_x_sql('insert into VERTRAG ' + '(RID,PERSON_R,BAUSTELLE_R,BELEG_R) ' +
    'values (' + inttostr(VERTRAG_R) + ',' + inttostr(FormKontext.PERSON_R) +
    ',' + inttostr(FormKontext.BAUSTELLE_R) + ',' +
    inttostr(FormKontext.BELEG_R) + ')');

  // Anzeigen, hoffentlich ohne refresh!
  show;

  // Kontrolle auf diesen Datensatz setzten
  IB_Query2.refresh;
  IB_Query2.Locate('BELEG_R', FormKontext.BELEG_R, []);
  IB_Query3.Locate('PERSON_R', FormKontext.PERSON_R, []);
  Label16.caption := inttostr(IB_Query3.Recordcount);

end;

procedure TFormVertrag.createVertragsnehmerFromContext;
var
  VERTRAG_R: integer;
  PERSON_R: integer;
begin
  PERSON_R := FormKontext.PERSON_R;

  if (PERSON_R > 0) then
    if doit('Neuer Vertragsnehmer ist: ' + e_r_Person(PERSON_R)) then
    begin
      show;

      VERTRAG_R := e_w_gen('GEN_VERTRAG');

      e_x_sql('insert into VERTRAG ' + '(RID,PERSON_R,BAUSTELLE_R,BELEG_R) ' +
        'values (' + inttostr(VERTRAG_R) + ', ' + inttostr(PERSON_R) + ', ' +
        IB_Query1.FieldByName('BAUSTELLE_R').AsString + ', ' +
        IB_Query1.FieldByName('BELEG_R').AsString + ')');

      with IB_Query3 do
      begin
        refresh;
        Locate('RID', VERTRAG_R, []);
        Label16.caption := inttostr(IB_Query3.Recordcount);

      end;
    end;

end;

procedure TFormVertrag.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet1;
end;

procedure TFormVertrag.IB_Query1AfterDelete(IB_Dataset: TIB_Dataset);
begin
  RefreshVertragsnehmer;
end;

procedure TFormVertrag.IB_Query1BeforeInsert(IB_Dataset: TIB_Dataset);
begin
  if IB_Query1.FieldByName('RID').IsNull then
    IB_Query1.FieldByName('RID').AsInteger := cRID_AutoInc;
end;

procedure TFormVertrag.IB_Query1ConfirmDelete(Sender: TComponent;
  var Confirmed: Boolean);
begin
  Confirmed := doit('Vertragskündigung mit sofortiger Wirkung');
end;

procedure TFormVertrag.IB_Query2AfterScroll(IB_Dataset: TIB_Dataset);
begin
  IB_Query3.ParamByName('CROSSREF').AsInteger :=
    IB_Query2.FieldByName('BELEG_R').AsInteger;
  Label16.caption := inttostr(IB_Query3.Recordcount);
  IB_Query1.ParamByName('CROSSREF').AsInteger := IB_Query3.FieldByName('RID')
    .AsInteger;
end;

procedure TFormVertrag.IB_Query3AfterScroll(IB_Dataset: TIB_Dataset);
begin
  IB_Query1.ParamByName('CROSSREF').AsInteger := IB_Query3.FieldByName('RID')
    .AsInteger;
end;

procedure TFormVertrag.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Vertrag');
end;

procedure TFormVertrag.setContext;
begin

  //
  with IB_Query1 do
  begin
    // Aktuellen Personen Context setzen
    if not(active) then
      Open
    else
      refresh;
  end;

  with IB_Query3 do
  begin
    // Aktuellen Personen Context setzen
    if not(active) then
      Open
    else
      refresh;

  end;

  //
  with IB_Query2 do
  begin
    if not(active) then
      Open
    else
      refresh;
  end;

  show;
  if (PERSON_R > 0) then
  begin
    // Ansicht über die Person
    BAUSTELLE_R := e_r_sql('select BAUSTELLE_R from VERTRAG where PERSON_R=' +
      inttostr(PERSON_R));
    if (BAUSTELLE_R < cRID_FirstValid) then
    begin
      beep
    end
    else
    begin
      IB_Query2.Locate('BAUSTELLE_R', BAUSTELLE_R, []);
      IB_Query3.Locate('PERSON_R', PERSON_R, []);
    end;
  end;

  Label16.caption := inttostr(IB_Query3.Recordcount);

end;

procedure TFormVertrag.SpeedButton1Click(Sender: TObject);
begin
  ShowMessage('-- ohne Funktion --');
end;

procedure TFormVertrag.SpeedButton2Click(Sender: TObject);
begin
  ShowMessage('-- ohne Funktion --');
end;

procedure TFormVertrag.SpeedButton3Click(Sender: TObject);
begin
  ShowMessage('-- ohne Funktion --');
end;

procedure TFormVertrag.SpeedButton4Click(Sender: TObject);
begin
  FormOLAP.DoContextOLAP(IB_Grid2);
end;

procedure TFormVertrag.SpeedButton5Click(Sender: TObject);
begin
  FormOLAP.DoContextOLAP(IB_Grid1);
  IB_Query1.refresh;
end;

procedure TFormVertrag.SpeedButton6Click(Sender: TObject);
begin
  NeuVariante;
end;

procedure TFormVertrag.SpeedButton7Click(Sender: TObject);
begin
  NeuNehmer;
end;

procedure TFormVertrag.SpeedButton8Click(Sender: TObject);
begin
  RefreshVertragsnehmer;
end;

function TFormVertrag.VertragLogFName: string;
begin
  result := DiagnosePath + 'Vertragsbuchung-' + inttostr(DateGet) + '.txt';
end;

end.
