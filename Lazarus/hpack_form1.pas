unit HPACK_Form1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Menus, cTypes,

  HPACK, HTTP2, Types;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure TabSheet2ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure TabSheet2Show(Sender: TObject);
  private
    { private declarations }

    // The File-Descriptor of the Connection
    // delivered by systemd or a own TCP Connection
    FD: longint;
    HPACK: THPACK;
    Initialized: boolean;
    HTTP2 : THTTP2_Connection;

    //
  public
    { public declarations }
    procedure InitPathToTest;
    procedure ShowDebugMessages;
    procedure Request(s:String);
  end;

var
  Form1: TForm1;

implementation

uses
  // freepascal / Lazarus
  fpjson, jsonparser, jsonscanner,

  // tools
  anfix32,

  // aus dem HTTP/2 Projekt
   cryptossl;

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  if not(assigned(HPACK)) then
   HPACK := THPACK.Create;
  with HPACK do
  begin
    Wire := THPACK.HexStrToRawByteString(edit1.Text);
    try
      clear;
      Decode;
    except
    end;
  end;
  memo1.Lines.add('{-----');
  memo1.Lines.addStrings(HPACK);
  memo1.Lines.add('-----}');
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  ShowDebugMessages;
end;

procedure TForm1.Button11Click(Sender: TObject);
var
   buf : array[0..pred(16*1024)] of byte;
   n : integer;
   BytesWritten : cint;
begin
   for n := low(buf) to high(buf) do
    buf[n] := random(256);

   BytesWritten := HTTP2.write(@buf,sizeof(buf));
   sDebug.Add(IntTostr(BytesWritten)+' Bytes written ...');
end;

procedure TForm1.Button12Click(Sender: TObject);
var
    FName : string;
begin
 InitPathToTest;
 FName := PathToTests + edit4.Text + '.http2';
 HTTP2.LoadRawBytes(FName);

 if (pos('-0-',FName)>0) then
  HTTP2.AutomataState := 0 // we expect a "Client Hello", in a initial packet!
 else
  HTTP2.AutomataState := 1; // we have no Client Helo!

 HTTP2.CN_Pos := 0; // ensure we start "here"
 HTTP2.Parse;

 ShowDebugMessages;
end;

procedure TForm1.Button13Click(Sender: TObject);
var
    BytesWritten : cint;
begin
  BytesWritten := HTTP2.write(@CLIENT_PREFIX[1],length(CLIENT_PREFIX));
  sDebug.Add(IntTostr(BytesWritten)+' Bytes written ...');
end;

procedure TForm1.Button14Click(Sender: TObject);
var
 n : integer;
 TABLE: TStringList;
begin
  if not(assigned(HPACK)) then
   HPACK := THPACK.Create;

  with HPACK do
  begin
    TABLE := dynTABLE;
    for n := 0 to pred(TABLE.count) do
    memo1.Lines.addStrings('['+IntToStr(62+n)+'] '+TABLE[n]);
    memo1.Lines.addStrings(' Table size: '+IntToStr(TABLE_SIZE)+'/'+IntToStr(MAXIMUM_TABLE_SIZE));
    TABLE.free;
  end;
end;

procedure TForm1.Button15Click(Sender: TObject);
begin
  if assigned(HPACK) then
    FreeAndNil(HPACK);
  edit1.Text := '';
  memo1.lines.clear;
end;

procedure TForm1.Button16Click(Sender: TObject);
var
 TheHuff : TStringList;
 ThePascalCodeA: TStringList;
 ThePascalCodeB: TStringList;
 A , B : string;
 BracketPos: Integer;
 n : integer;
begin
  TheHuff := TStringList.create;
  ThePascalCodeA:= TStringList.create;
  ThePascalCodeB:= TStringList.create;
  TheHuff.loadFromFile(Edit5.Text);

  ThePascalCodeA.add(' RFC_7541_Appendix_B_Bits : array[0..256] of int64 = (');
  ThePascalCodeB.add(' RFC_7541_Appendix_B_Length : array[0..256] of byte = (');

  A := '   ';
  B := '   ';
  for n := 0 to pred(TheHuff.count) do
  begin
   BracketPos:= pos('[',TheHuff[n]);

   A := A + '$' + noblank(copy(TheHuff[n],BracketPos-12,12));
   B := B + copy(TheHuff[n],succ(BracketPos),2) ;

   if n<pred(TheHuff.count) then
     begin
       A := A +', ';
       B := B +', ';

     end;

   if n MOD 16 = 15 then
   begin
     ThePascalCodeA.add(A);
     ThePascalCodeB.add(B);
     A := '   ';
     B := '   ';
   end;

  end;
  ThePascalCodeA.add(A+');');
  ThePascalCodeB.add(B+');');

  Memo1.lines.clear;
  Memo1.lines.addstrings(ThePascalCodeA);
  Memo1.lines.addstrings(ThePascalCodeB);

  ThePascalCodeB.free;
  ThePascalCodeA.free;
  TheHuff.free;

end;

procedure TForm1.Button17Click(Sender: TObject);
var
 D : RawByteString;
 DD: string;
 BytesWritten: cint;
 n : Integer;
begin
  D := HTTP2.PING(PING_PAYLOAD);

  // save it as "init"
  InitPathToTest;
  HTTP2.SaveRawBytes(D,PathToTests+'ping.http2');

  if assigned(HTTP2) then
  begin
    BytesWritten := HTTP2.write(@D[1],length(D));
    sDebug.Add(IntTostr(BytesWritten)+' Bytes written ...');
  end;

  ShowDebugMessages;

end;

procedure TForm1.Button18Click(Sender: TObject);
begin
  Memo3.Clear;
end;

procedure TForm1.Button19Click(Sender: TObject);
begin
  Memo2.clear;
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
  W: string;
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
          P := TJSONParser.Create(S,[joStrict]);
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
  memo2.lines.Add('Make a request now: (https://localhost/)');
  application.processmessages;
  FD := getSocket;
  memo2.Lines.add('Get Socket : ' + IntToStr(FD));
  memo2.Lines.Add('Incoming call, press Accept now');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if (FD = 0) then
    exit;
  HTTP2.TLS_Accept(FD);
  ShowDebugMessages;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if not(assigned(HTTP2)) then
  begin
   HTTP2 := THTTP2_Connection.create;
   HTTP2.OnRequest := @Request;
   SHowDebugmessages;
   HTTP2.CTX:=   HTTP2.StrictHTTP2Context;
   SHowDebugmessages;
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  InitPathToTest;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  HTTP2.ParserClear;
  HTTP2.Parse;
end;

procedure TForm1.Button8Click(Sender: TObject);
var
 n : Integer;
 D : RawByteString;

 function StrFilter(s,Filter:string):string;
 var
   n : Integer;
 begin
   result := '';
   for n := 1 to length(s) do
    if pos(s[n],Filter)>0 then
     result := result + s[n];
 end;

begin
 with memo3.lines do
 begin
  D := '';
  for n := 0 to pred(count) do
   D := D + StrFilter(Strings[n],'0123456789ABCDEFabcdef');
 end;
 mDebug.add(D);
 HTTP2.AutomataState := 1;
 HTTP2.enqueue(THPACK.HexStrToRawByteString(D));
end;


procedure TForm1.Button9Click(Sender: TObject);
var
 D : RawByteString;
 DD: string;
 BytesWritten: cint;
 n : Integer;
begin
  D := HTTP2.StartFrames;

  // save it as "init"
  InitPathToTest;
  HTTP2.SaveRawBytes(D,PathToTests+'init.http2');


  sDebug.add('--------------------------------------------');

  DD := '';
  for n := 1 to length(D) do
  begin
    DD := DD + ' ' + IntToHex(ord(D[n]),2);
    if (pred(n) MOD 16=15) then
    begin
     sDebug.add(DD);
     DD := '';
    end;
  end;
  if (DD<>'') then
   sDebug.add(DD);

  sDebug.add('--------------------------------------------');

  if assigned(HTTP2) then
  begin
    BytesWritten := HTTP2.write(@D[1],length(D));
    sDebug.Add(IntTostr(BytesWritten)+' Bytes written ...');
  end;

  ShowDebugMessages;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet2;
end;

procedure TForm1.TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TForm1.TabSheet2ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TForm1.TabSheet2Show(Sender: TObject);
begin
    pem_Path := edit3.Text;
 if not(Initialized) then
 begin
     memo2.Lines.add(cryptossl.Version);
  memo2.Lines.addstrings(cryptossl.sDebug);
  memo2.Lines.add('----------');
  Initialized := true;
 end;
end;

procedure TForm1.InitPathToTest;
begin
  PathToTests := copy(edit3.Text,1,pred(length(edit3.Text)));
  PathToTests := copy(PathToTests,1,RevPos('\',PathToTests));
  label7.Caption := PathToTests;
end;

procedure TForm1.ShowDebugMessages;
begin
  with Memo2 do
  begin
   lines.addstrings(sdebug);
   sdebug.clear;
   lines.addstrings(mdebug);
   mdebug.clear;

   SelStart := Length(Lines.Text) - 3;
   SelLength := 1;
   if(Visible) then
    SetFocus;
   Application.ProcessMessages;
 end;
end;

procedure TForm1.Request(s: String);
begin
 if (s<>'') then
  sDebug.add(s);
 ShowDebugMessages;
end;

end.

