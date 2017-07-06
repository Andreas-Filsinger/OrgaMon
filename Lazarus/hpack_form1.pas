unit HPACK_Form1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Menus;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { private declarations }

    // The File-Descriptor of the Connection
    // delivered by systemd or a own TCP Connection
    FD: longint;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  // freepascal / Lazarus
  fpjson, jsonparser,

  // tools
  anfix32,

  // aus dem HTTP/2 Projekt
  HPACK, HTTP2, cryptossl;

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  HPACK: THPACK;
begin
  HPACK := THPACK.Create;
  with HPACK do
  begin
    Wire := THPACK.HexStrToRawByteString(edit1.Text);
    try
      Decode;
    except
    end;
    memo1.Lines.addStrings(HPACK);
  end;
  HPACK.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
const
  LIMIT = 1;
var
  sDir: TStringList;
  sTest: TStringList;
  m, n, o, i: integer;
  Path: string;
  S: TFileStream;
  P: TJSONParser;
  jROOT, jCASE, jTEST, jHEADER: TJSONData;
  V: TObject;
  W: string;
  H: TStringList;

  TestsToday: integer;
begin
  TestsToday := 0;
  sDir := TStringList.Create;
  sTest := TStringList.Create;
  dir(edit2.Text + '*.', sDir, False);
  sDir.sort;
  for n := 0 to pred(sDir.Count) do
  begin
    Path := edit2.Text + sDir[n] + '\';
    dir(Path + '*.json', sTest, False);
    if sTest.Count > 0 then
    begin
      sTest.sort;
      memo1.Lines.add(Path + ':');

      for m := 0 to pred(sTest.Count) do
      begin

        memo1.Lines.add(' ' + sTest[m] + ':');

        S := TFileStream.Create(Path + sTest[m], fmOpenRead);
        try
          P := TJSONParser.Create(S);
          P.Strict := True;
          try
            jROOT := P.Parse;
          finally
            P.Free;
          end;
        finally
          S.Free;
        end;

        if assigned(jROOT.FindPath('description')) then
        begin

          memo1.Lines.add('  ' + jROOT.getPath('description').AsString);

          jCASE := jROOT.getPath('cases');
          for o := 0 to pred(jCASE.Count) do
          begin
            jTEST := jCASE.items[o];
            W := jTEST.getPath('wire').AsString;
            edit1.Text := W;

            H := TStringList.Create;

            jHEADER := jTEST.getPath('headers');

            //memo1.Lines.add(Inttostr(jHEADER.count)+'x');
            //memo1.Lines.add(jHEADER.AsJSON);
            for i := 0 to pred(jHEADER.Count) do
            begin
              //memo1.Lines.add(jHEADER.Items[i].AsJSON);
              memo1.Lines.add('   ' + JSONStringToString(jHEADER.Items[i].AsJSON));
              // memo1.Lines.add(jHEADER.Strings[ jHEADER.Names[i] ]);
            end;

            //with (jHEADER as TJSONArray) do
            //             memo1.Lines.add(jHEADER.AsString);
            // end;


            {
            for (V in jHEADER) do
            begin

//            H.Assign(jHEADER.);
            end;
            for i := 0 to pred(jHEADER.count) do
            memo1.Lines.add(jHEADER.Items[i].AsString);
}
          end;

        end
        else
        begin
          memo1.Lines.add('  ' + '<NIL>');
        end;

        Inc(TestsToday);
        if TestsToday > LIMIT then
          break;
      end;
      if TestsToday > LIMIT then
        break;
    end;

  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  FD := getSocket;
  memo2.Lines.add('Get Socket : ' + IntToStr(FD));
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if (FD = 0) then
    exit;
  TLS_Bind(FD);
  memo2.Lines.AddStrings(sDebug);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  TLS_Init;
  if (sDebug.Count = 0) then
    memo2.Lines.Add('keine Fehler beim "Init"')
  else
    memo2.Lines.AddStrings(sDebug);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  memo2.Lines.add(cryptossl.Version);
  memo2.Lines.addstrings(cryptossl.sDebug);
  memo2.Lines.add('----------');
end;


type
  TOrgaMonServer = Class(THTTPSServer)
  public
    procedure HandleRequest(var AHttpsConnection: THttpsConnection); override;
    procedure Start;
    procedure Stop;
  end;

var OrgaMonServer: TOrgaMonServer;

// Hello World
procedure TOrgaMonServer.HandleRequest(var AHttpsConnection: THttpsConnection);
begin
  Form1.memo2.lines.add(AHttpsConnection.RequestHeaders.Text);
  Form1.memo2.lines.add(AHttpsConnection.RequestContent);

  { TODO 3 -oUdo -cTHttpsConnection : get first header line as protocol, method and url }
  { TODO 3 -oUdo -cTHttpsConnection : set first header line as protocol, code and text }
  AHttpsConnection.ResponseHeaders.Add('HTTP/1.1 200 OK');
  AHttpsConnection.ResponseHeaders.Add('Content-Type: text/html; charset=utf-8');
  AHttpsConnection.ResponseContent := '<htm><head><title>test</title></head>' +
                      '<body>Hello World at: '+DateTimeToStr (Now) +'</body></html>';

end;

procedure TOrgaMonServer.Start;
begin
  try
    // start server loop
    Active := true;
  finally
    Free;
  end;
end;

procedure TOrgaMonServer.Stop;
begin
  // stop server loop
  Active := false;
end;


procedure TForm1.Button7Click(Sender: TObject);
begin
  OrgaMonServer := TOrgaMonServer.Create(nil);
  OrgaMonServer.Start;

end;

end.

