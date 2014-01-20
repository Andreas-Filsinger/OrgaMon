unit ArtikelBackorder;
//
// soll Geheimnisse der Mengen-Wirtschaft verraten
//

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  IB_Access, IB_Components, StdCtrls,
  Grids, IB_Grid, Buttons,
  ExtCtrls, JvGIF, Datenbank;

type
  TFormArtikelBackorder = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    IB_Query1: TIB_Query;
    IB_Query2: TIB_Query;
    IB_Grid1: TIB_Grid;
    IB_Query3: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    Label5: TLabel;
    IB_DataSource2: TIB_DataSource;
    IB_Grid2: TIB_Grid;
    IB_Grid3: TIB_Grid;
    IB_DataSource3: TIB_DataSource;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    Label8: TLabel;
    IB_Grid4: TIB_Grid;
    IB_QueryOrderHistorie: TIB_Query;
    IB_DataSourceOrderHistroie: TIB_DataSource;
    StaticText5: TStaticText;
    Label9: TLabel;
    Button5: TButton;
    StaticText6: TStaticText;
    Label10: TLabel;
    SpeedButton2: TSpeedButton;
    Label11: TLabel;
    Panel1: TPanel;
    Image2: TImage;
    StaticText7: TStaticText;
    Label12: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private-Deklarationen }
    _ARTIKEL_R: integer;
    _AUSGABEART_R: integer;
    procedure RefreshValues;
  public
    { Public-Deklarationen }
    procedure SetContext(ARTIKEL_R: integer);

  end;

var
  FormArtikelBackorder: TFormArtikelBackorder;

implementation

uses
  Artikel, anfix32, Belege,
  Funktionen.Beleg,
  BBelege, CareTakerClient,
  globals, IBExportTable, wanfix32;

{$R *.dfm}

procedure TFormArtikelBackorder.Button1Click(Sender: TObject);
begin
  RefreshValues;
end;

procedure TFormArtikelBackorder.Button2Click(Sender: TObject);
begin
  FormBelege.SetContext(0, IB_Query1.FieldByName('BELEG_R').AsInteger);
end;

procedure TFormArtikelBackorder.Button4Click(Sender: TObject);
begin
  FormBelege.SetContext(0, IB_Query3.FieldByName('BELEG.RID').AsInteger);
end;

procedure TFormArtikelBackorder.Button3Click(Sender: TObject);
begin
  FormBBelege.SetContext(0, IB_Query2.FieldByName('BELEG_R').AsInteger);
end;

procedure TFormArtikelBackorder.SetContext(ARTIKEL_R: integer);
begin
  show;
  _ARTIKEL_R := ARTIKEL_R;
  RefreshValues;
end;

procedure TFormArtikelBackorder.Button5Click(Sender: TObject);
begin
  if IB_QueryOrderHistorie.FieldByName('BELEG_R').IsNotNull then
    FormBBelege.SetContext(0, IB_QueryOrderHistorie.FieldByName('BELEG_R').AsInteger, IB_QueryOrderHistorie.FieldByName('RID').AsInteger)
  else
    beep;
end;

procedure TFormArtikelBackorder.RefreshValues;

  procedure ReFreshAndSet(IBQ: TIB_Query);
  begin
    with IBQ do
    begin
      close;
      ParamByName('CROSSREF').AsInteger := _ARTIKEL_R;
      open;
    end;
  end;

begin

  //
  ReFreshAndSet(IB_Query1);
  ReFreshAndSet(IB_Query2);
  ReFreshAndSet(IB_Query3);
  ReFreshAndSet(IB_QueryOrderHistorie);

  //
    StaticText5.caption := inttostr(e_r_Menge(cRID_NULL, _AUSGABEART_R, _ARTIKEL_R));
    StaticText1.caption := inttostr(e_r_MindestMenge(_AUSGABEART_R, _ARTIKEL_R));
    StaticText2.caption := inttostr(e_r_AgentMenge(_AUSGABEART_R, _ARTIKEL_R));
    StaticText3.caption := inttostr(e_r_ErwarteteMenge(_AUSGABEART_R, _ARTIKEL_R));
    StaticText4.Caption := inttostr(e_r_UngelieferteMengeUeberBedarf(_AUSGABEART_R, _ARTIKEL_R));
    StaticText6.caption := inttostr(e_r_VorschlagMenge(_AUSGABEART_R, _ARTIKEL_R));
    StaticText7.caption := inttostr(e_r_UnbestellteMenge(_AUSGABEART_R, _ARTIKEL_R));

end;

procedure TFormArtikelBackorder.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Order#Mengen');
end;

procedure TFormArtikelBackorder.SpeedButton2Click(Sender: TObject);
begin
  RefreshValues;
end;

end.

