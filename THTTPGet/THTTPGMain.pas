unit THTTPGMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  StdCtrls, IdURI;

type
  TForm1 = class(TForm)
    EditURL: TEdit;
    GetButton: TButton;
    MemoLog: TMemo;
    IdHTTP1: TIdHTTP;
    LabelRevision: TLabel;
    LabelURL: TLabel;
    procedure GetButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    WorkingDir: string;
  public
    { Public-Deklarationen }
  end;

const
  cREV: string = '1.002';
  cDESTFILE: string = 'thttpget.$$$';
  cSOURCEURL: string = 'http://www.difem.ch/pdf/11577.pdf';

var
  Form1: TForm1;

implementation


{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  EditURL.Text := cSOURCEURL;
  WorkingDir := ExtractFilePath(Application.ExeName);
  LabelRevision.Caption := LabelRevision.Caption + cREV;
  //ShowMessage(WorkingDir);
end;

procedure TForm1.GetButtonClick(Sender: TObject);
var
  _URL: string;
  OutF: TFileStream;
begin
  // Es darf heute nochmal ein Download versucht werden!
  //FileDelete(d + '.$$$');
  repeat

   _URL := EditURL.Text;
  OutF := TFileStream.create(WorkingDir + cDESTFILE, fmCreate);
  try
    with IdHTTP1 do
    begin
      MemoLog.Lines.Add('GET ' + _URL + ' ...');
      //HandleRedirects := true;
      REsponse.KeepAlive := true;
      //Request.UserAgent := 'Mozilla/5.0 (Windows NT 6.1; rv:2.0) Gecko/20100101 Firefox/4.0';
      Request.UserAgent := 'Mozilla/5.0 (Windows NT 6.1; rv:2.0) Gecko/20100101 Firefox/4.0 Indy Library';
      get(TIdURI.URLEncode(_URL), OutF)
    end;
  except
    on E: exception do
    begin
      MemoLog.Lines.Add('ERROR: ' + E.Message);
    end;
  end;
  OutF.free;

  MemoLog.Lines.Add('Request:' + #13#10 + IdHTTP1.Request.RawHeaders.Text);
  MemoLog.Lines.Add('ResponseCode: ' + inttostr(IdHTTP1.ResponseCode));
  MemoLog.Lines.Add('ResponseText: ' + IdHTTP1.Response.ResponseText);
  break;

  if (IdHTTP1.ResponseCode = 200) then
  begin
    MemoLog.Lines.Add('ResponseCode: 200');
    break;
  end;

  if (IdHTTP1.ResponseCode = 404) then
  begin

    break;
  end;

  until true;

end;


 (*   try
      Memo1.Lines.Add('HEAD ' + s + ' ...');
      IdHTTP1.Head(TIdURI.URLEncode(s));
    except
      on E: exception do
      begin
        Memo1.Lines.Add('ERROR: ' + E.Message);
      end;
    end;
    inc(DownLoadsToday, Length(IdHTTP1.REsponse.ResponseText));

   *)


end.
