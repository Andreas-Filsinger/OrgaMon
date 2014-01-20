unit VerbindungIT;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs,
  StdCtrls, ExtCtrls, globals, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient;

type
  TVerbindungITForm = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Image1: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Timer1: TTimer;
    Label13: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Label14: TLabel;
    Button8: TButton;
    Edit4: TEdit;
    Button9: TButton;
    Label15: TLabel;
    CheckBoxAutoTrans: TCheckBox;
    Button1: TButton;
    ListBox1: TListBox;
    Button2: TButton;
    Button10: TButton;
    Button11: TButton;
    IdTCPClient1: TIdTCPClient;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IdTCPClient1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure Button2Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    LastPacketReceived: dword;

    // private Daten der Socket
    SoData: AnsiString;
    SoCommand: AnsiChar;

    // Performance-Counter
    OutBmp: TBitMap;

    procedure DrawUnterschrift(DataStr: AnsiString);
    procedure DataEvent;
    procedure Load;
    procedure ClearActUnterschrift;
    procedure sendText(msg: AnsiString);
    procedure connectPforteAssist;
    procedure disconnectPforteAssist;
  end;

var
  VerbindungITForm: TVerbindungITForm;

implementation

uses
  anfix32, Willkommen, wanfix32;

{$R *.DFM}

procedure TVerbindungITForm.DrawUnterschrift(DataStr: AnsiString);
var
  Points: array of TSignPoint;
  PointsCount: Integer;
  n: Integer;
  x, y: Integer;
  Minx: Integer;
  MinY: Integer;
  FirstPoint: boolean;
  LastX: Integer;
  LastY: Integer;
  MaxX: Integer;
  MaxY: Integer;
begin

  // Bitmap neu belegen
  OutBmp.free;
  OutBmp := TBitMap.create;
  OutBmp.monochrome := true;

  // Punkte der Unterschrift lesen
  PointsCount := CharCount(',', DataStr);
  SetLength(Points, PointsCount);
  for n := 0 to pred(PointsCount) do
    with Points[n] do
    begin
      px := StrToIntdef(nextp(DataStr, ','), 0);
      py := StrToIntdef(nextp(DataStr, ';'), 0);
    end;

  Label9.Caption := inttostr(PointsCount) + ' Punkte';

  if PointsCount > 0 then
  begin
    Minx := MaxInt;
    MinY := MaxInt;
    MaxX := 0;
    MaxY := 0;
    for n := 0 to pred(PointsCount) do
    begin
      with Points[n] do
      begin
        if (px > 0) then
        begin
          if (px < Minx) then
            Minx := px;
          if (px > MaxX) then
            MaxX := px;

          if (py < MinY) then
            MinY := py;
          if (py > MaxY) then
            MaxY := py;
        end;
      end;
    end;
    dec(Minx, SignBorderX);
    dec(MinY, SignBorderY);
    inc(MaxX, SignBorderX);
    inc(MaxY, SignBorderY);

    // Image1.width := ;
    // Image1.height := ;
    OutBmp.Width := MaxX - Minx;
    OutBmp.Height := MaxY - MinY;

    with OutBmp.Canvas do // TBitMap TImage
    begin
      brush.color := clwhite;
      FillRect(Rect(0, 0, OutBmp.Width, OutBmp.Height));
      brush.color := clblack;
      pen.Width := 4;
      FirstPoint := true;
      for n := 0 to pred(PointsCount) do
      begin
        with Points[n] do
        begin
          if (px = 0) and (py = 0) then
          begin
            FirstPoint := true;
          end
          else
          begin
            x := px - Minx;
            y := py - MinY;
            FillRect(Rect(x - 1, y - 2, x + 1, y + 2));
            FillRect(Rect(x - 2, y - 1, x + 2, y + 1));
            if not(FirstPoint) then
              if (abs(x - LastX) > 2) or (abs(y - LastY) > 2) then
              begin
                MoveTo(LastX, LastY);
                LineTo(x, y);
              end;
            LastX := x;
            LastY := y;
            FirstPoint := false;
          end;
        end;
      end;
    end;
  end;
  Image1.Picture.bitmap := OutBmp;
  if WillkommenForm.active then
    if WillkommenForm.CheckBox4.checked then
      WillkommenForm.LoadUnterschriftBMP(OutBmp);
end;

procedure TVerbindungITForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Key := #0;
    close;
  end;
end;

procedure TVerbindungITForm.IdTCPClient1Status(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: string);
begin
  ListBox1.Items.Add('C:' + AStatusText);
end;

procedure TVerbindungITForm.Timer1Timer(Sender: TObject);
var
  msg: AnsiString;
begin
  if AppGoDown then
    exit;

  if IdTCPClient1.connected then
  begin

    // if IdTCPClient1.ReadTimeout then
    if not(IdTCPClient1.IOHandler.InputBufferIsEmpty) then
    begin
      try

        // if IdTCPClient1.Socket.connected then
        repeat
          msg := IdTCPClient1.IOHandler.ReadLn;
          if (length(msg) > 0) then
          begin
            SoCommand := msg[1];
            SoData := copy(msg, 2, MaxInt);
            DataEvent;
          end;
        until IdTCPClient1.IOHandler.InputBufferIsEmpty;

      except
        on E: exception do
        begin
          ListBox1.Items.Add(E.message);
        end;
      end;
    end;

  end;
end;

procedure TVerbindungITForm.DataEvent;
begin
  if AppGoDown then
    exit;
  case SoCommand of
    'A':
      Button5.Enabled := false;
    'N':
      begin
        Button5.Enabled := true;
        Label2.Caption := SoData;
        if CheckBoxAutoTrans.checked then
          Edit2.Text := SoData;
      end;
    'n':
      begin
        Button5.Enabled := true;
        Label2.Caption := SoData;
        Label3.Caption := '';
        Label14.Caption := '';
        DrawUnterschrift('');
        if CheckBoxAutoTrans.checked then
        begin
          Edit2.Text := SoData;
          Edit3.Text := Label3.Caption;
          Edit4.Text := Label14.Caption;
        end;
      end;
    'F':
      begin
        Label3.Caption := SoData;
        if CheckBoxAutoTrans.checked then
          Edit3.Text := SoData;
      end;
    'H':
      begin
        Label14.Caption := SoData;
        if CheckBoxAutoTrans.checked then
          Edit4.Text := SoData;
      end;
    'U':
      DrawUnterschrift(SoData);
    'C':
      Label4.Caption := SoData;
  end;
end;

procedure TVerbindungITForm.disconnectPforteAssist;
begin
  if IdTCPClient1.connected then
    IdTCPClient1.Disconnect;
end;

procedure TVerbindungITForm.FormCreate(Sender: TObject);
begin
  OutBmp := TBitMap.create;
  OutBmp.monochrome := true;
  Label13.Caption := iBesucherTerminalIP;
  Label4.Caption := DefaultLanguage;
  if (iBesucherTerminalIP <> '') then
    connectPforteAssist;
end;

procedure TVerbindungITForm.Button2Click(Sender: TObject);
begin
  connectPforteAssist;
end;

procedure TVerbindungITForm.Button3Click(Sender: TObject);
begin
  sendText('N' + Edit2.Text + '~');
end;

procedure TVerbindungITForm.Button4Click(Sender: TObject);
begin
  sendText('F' + Edit3.Text + '~');
end;

procedure TVerbindungITForm.Button5Click(Sender: TObject);
begin
  sendText('C~');
end;

procedure TVerbindungITForm.Button6Click(Sender: TObject);
begin
  Edit2.Text := Label2.Caption;
end;

procedure TVerbindungITForm.Button7Click(Sender: TObject);
begin
  Edit3.Text := Label3.Caption;
end;

procedure TVerbindungITForm.Button8Click(Sender: TObject);
begin
  Edit4.Text := Label14.Caption;
end;

procedure TVerbindungITForm.Button9Click(Sender: TObject);
begin
  sendText('H' + Edit4.Text + '~');
end;

procedure TVerbindungITForm.Button10Click(Sender: TObject);
begin
  disconnectPforteAssist;
end;

procedure TVerbindungITForm.Button11Click(Sender: TObject);
begin
  openShell(
    'http://msdn.microsoft.com/en-us/library/ms740668%28v=vs.85%29.aspx');
end;

procedure TVerbindungITForm.Button1Click(Sender: TObject);
begin
  Load;
end;

procedure TVerbindungITForm.Load;
begin
  if (iBesucherTerminalIP <> '') then
    sendText('L~');
end;

procedure TVerbindungITForm.sendText(msg: AnsiString);
begin
  if IdTCPClient1.Connected then
    IdTCPClient1.Socket.WriteLn(msg);
end;

procedure TVerbindungITForm.ClearActUnterschrift;
begin
  DrawUnterschrift('');
end;

procedure TVerbindungITForm.connectPforteAssist;
begin
  if not(IdTCPClient1.connected) then
  begin

    ListBox1.Items.Add('Connect ...');
    // Verfügbarkeit prüfen
    IdTCPClient1.Host := iBesucherTerminalIP;
    try
      IdTCPClient1.connect;
    except
      ListBox1.Items.Add('... FAIL');
      exit;
    end;

  end;
end;

procedure TVerbindungITForm.FormDestroy(Sender: TObject);
begin
  OutBmp.free;
end;

end.
