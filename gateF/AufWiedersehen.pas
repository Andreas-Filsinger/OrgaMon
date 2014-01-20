unit AufWiedersehen;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls;

type
  TAufWiedersehenForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Button3: TButton;
    Label4: TLabel;
    Edit2: TEdit;
    Timer1: TTimer;
    Label5: TLabel;
    Panel2: TPanel;
    Label6: TLabel;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    SelectedRow: integer;
    TRNID: integer;
  end;

var
  AufWiedersehenForm: TAufWiedersehenForm;

implementation

uses BesucherListe, anfix32, Willkommen;

{$R *.DFM}

procedure TAufWiedersehenForm.FormCreate(Sender: TObject);
begin
  color := clblack;
  GroupBox1.top := 1;
  GroupBox1.Left := 1;
  width := GroupBox1.width + 2;
  height := GroupBox1.height + 2;
  Timer1.enabled := false;
end;

procedure TAufWiedersehenForm.FormActivate(Sender: TObject);
begin
  edit1.Text := SecondsToStr(BesucherListeForm.GetPfortenTime);
  edit2.Text := Long2date(BesucherListeForm.GetPfortenDate);
  label5.caption := 'Besuchs TAN ' + inttostr(TRNID);
  Timer1.enabled := true;
  Button2.SetFocus;
end;

procedure TAufWiedersehenForm.Button1Click(Sender: TObject);
var
  RausZeit: TAnfixTime;
  RausDatum: TAnfixDate;
begin
  if label6.Caption = '' then
  begin
    RausZeit := StrToSeconds(edit1.Text);
    RausDatum := Date2long(edit2.Text);
    if (RausZeit <> 0) then
    begin
      close;
      BesucherListeForm.DeleteBesucherByTRN(TRNID, RausDatum, RausZeit);
    end else
    begin
      Edit1.SetFocus;
    end;
  end else
  begin
    ShowMessage('Bitte best‰tigen Sie erst, daﬂ ' + #13 +
      'Sie die Meldung weitergegeben haben!');
  end;
end;

procedure TAufWiedersehenForm.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TAufWiedersehenForm.Timer1Timer(Sender: TObject);
begin
  edit1.Text := SecondsToStr(BesucherListeForm.GetPfortenTime);
  edit2.Text := Long2date(BesucherListeForm.GetPfortenDate);
end;

procedure TAufWiedersehenForm.Edit2Enter(Sender: TObject);
begin
  Timer1.enabled := false;
end;

procedure TAufWiedersehenForm.Edit1Enter(Sender: TObject);
begin
  Timer1.enabled := false;
end;

procedure TAufWiedersehenForm.FormDeactivate(Sender: TObject);
begin
  Timer1.enabled := false;
  BesucherListeForm.YellowRow := -1;
end;

procedure TAufWiedersehenForm.Button3Click(Sender: TObject);
begin
 // von diesem Besuch ausgehen, und Ihn in die Planung
 // verschieben!
  if label6.caption = '' then
  begin
    Button1Click(Sender); // OK
    application.processmessages;
    BesucherListeForm.SetListCursorTo(TrnID); // auf Historie springen
    application.processmessages;

    BesucherListeForm.HistRepeatClick(Sender); // -> in die Planung
    application.processmessages;
    BesucherListeForm.ListeEnterPressed(BesucherListeForm.DrawGrid1.row);
    WillkommenForm.edit9.text := long2date(datePlus(BesucherListeForm.GetPfortenDate, 1));
  end else
  begin
    ShowMessage('Bitte best‰tigen Sie erst, daﬂ ' + #13 +
      'Sie die Meldung weitergegeben haben!');
  end;
end;

procedure TAufWiedersehenForm.Button4Click(Sender: TObject);
begin
  label6.caption := '';
end;

end.
