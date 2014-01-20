unit TPUSplash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ShellApi, Buttons, StdCtrls, IdHTTP, IdException, IdStack;

type
  TSplashScreen = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    UpdateInfo: TLabel;
    RevInfo: TLabel;
    UpdateStatus: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
    UpdateChecked: boolean;
    procedure GoOn;
  public
    { Public-Deklarationen }
    UpdateStateKnown: boolean;
    procedure CheckUpdate;
  end;

var
  SplashScreen: TSplashScreen;

implementation

uses TPUMain;

{$R *.dfm}

procedure TSplashScreen.Timer1Timer(Sender: TObject);
begin
  if UpdateChecked then GoOn;
end;

procedure TSplashScreen.GoOn;
begin
  Timer1.Enabled := false;
  SplashScreen.Hide;
  Application.MainForm.Show;
end;

procedure TSplashScreen.CheckUpdate;
var
  ResponseStream: TStringStream;
  ResponseString: TStringList;
  FileStream: TFileStream;
  Html: string;
  i: integer;
  IntRev: integer;
  CurRev: integer;
  RevWithPoint: string;
  RevWithOutPoint: string;
  SetupFile: string;
  DownloadPath: string;
  ExInfo: TShellExecuteInfo;
  Parameters: string;
begin
  ResponseStream := TStringStream.Create('');
  ResponseString := TStringList.Create;
  try
    UpdateStatus.Font.Color := clWhite;
    UpdateStatus.Caption := '';
    UpdateInfo.Show;
    UpdateStatus.Show;
    Application.ProcessMessages;
    Html := FormTPMain.IdHTTP1.Get(CARGOBAY + REV_HTML);
    i := pos('Rev ',Html) + 4;
    RevWithOutPoint := copy(Html, i, 4);
    IntRev := StrToInt(RevWithOutPoint);
    CurRev := StrToInt(copy(REV,1,1) + copy(REV,3,3));
    if IntRev > CurRev then
    begin
      UpdateStateKnown := true;
      RevWithPoint := RevWithOutPoint[1] + '.' + copy(RevWithOutPoint,2,3);
      SetupFile := 'Setup-TPicUpload-' + RevWithPoint + '.exe';
      UpdateInfo.Caption := 'Neue Revision im Internet gefunden ! Führe Update durch...';
      UpdateStatus.Font.Color := clSkyBlue;
      UpdateStatus.Caption := 'Lade ' + SetupFile + '...';
      Application.ProcessMessages;
      DownloadPath := GetEnvironmentVariable('TEMP') + '\';
      //DownloadPath := GetEnvironmentVariable('USERPROFILE') + '\Desktop\';
      //FormTPMain.IdHTTP1.Head(CARGOBAY + SetupFile);
      //ShowMessage(IntToStr(FormTPMain.IdHTTP1.Response.ContentLength));
      FormTPMain.IdHTTP1.Get(CARGOBAY + SetupFile, ResponseStream);
      FileStream := TFileStream.Create(DownloadPath + SetupFile,fmCreate OR fmShareDenyWrite);
      FileStream.CopyFrom(ResponseStream,0);
      FileStream.Free;
      UpdateStatus.Caption := 'Beenden und Setup starten...';
      Application.ProcessMessages;
      ExInfo.cbSize := SizeOf(TShellExecuteInfo);
      ExInfo.lpFile := pchar(SetupFile);
      if ParamCount > 0 then Parameters := ' /RunOnPath="' + ParamStr(1) + '"'
      else Parameters := '';
      ExInfo.lpParameters := pchar('/SILENT /SUPPRESSMSGBOXES' + Parameters);
      ExInfo.lpDirectory := pchar(DownloadPath);
      ExInfo.nShow := SW_SHOW;
      ExInfo.fMask := SEE_MASK_NOCLOSEPROCESS;
      ShellExecuteEx(@ExInfo);
      Application.MainForm.Close;
    end
    else
    begin
      UpdateStatus.Caption := 'Keine neue Revision verfügbar.';
      Application.ProcessMessages;
      UpdateStateKnown := true;
    end;
  except
    on EIdSocketError do
    begin
      UpdateStatus.Font.Color := clSkyBlue;
      UpdateStatus.Caption := 'Keine Internetverbindung: Kann Revision-Info nicht abrufen.';
      UpdateStatus.Show;
      Application.ProcessMessages;
      UpdateStateKnown := false;
    end;
    on EIdHTTPProtocolException do
    begin
      UpdateStatus.Font.Color := clSkyBlue;
      UpdateStatus.Caption := 'Ein Fehler ist aufgetreten: Kann Revision-Info nicht finden.';
      UpdateStatus.Show;
      Application.ProcessMessages;
      UpdateStateKnown := false;
    end;
  end;
  ResponseStream.Free;
  ResponseString.Free;
  FormTPMain.IdHTTP1.Request.Clear;
  UpdateChecked := true;
end;

procedure TSplashScreen.Image1Click(Sender: TObject);
begin
  if UpdateChecked then GoOn;
end;

procedure TSplashScreen.FormCreate(Sender: TObject);
begin
  RevInfo.Caption := 'Rev ' + REV;
end;

procedure TSplashScreen.FormActivate(Sender: TObject);
begin
  UpdateChecked := false;
  CheckUpdate;
  Timer1.Enabled := true;
end;

end.

