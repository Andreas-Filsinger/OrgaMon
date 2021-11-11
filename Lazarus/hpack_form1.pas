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
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    Button24: TButton;
    Button25: TButton;
    Button26: TButton;
    Button27: TButton;
    Button28: TButton;
    Button29: TButton;
    Button3: TButton;
    Button31: TButton;
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
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
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
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure Button28Click(Sender: TObject);
    procedure Button29Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button30Click(Sender: TObject);
    procedure Button31Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Memo4Change(Sender: TObject);
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
    fHPACK: THPACK;
    Initialized: boolean;
    fHTTP2: THTTP2_Connection;

    //
    procedure EnsureHTTP2;

  public
    { public declarations }
    procedure InitPathToTest;
    procedure ShowDebugMessages;
    procedure Request(R:TStringList);
    procedure StartServer;
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
var
  H : RawByteString;
  n : integer;
begin
  if not(assigned(fHPACK)) then
   fHPACK := THPACK.Create;
  with fHPACK do
  begin
    H := '';
    with memo4.lines do
     for n := 0 to pred(count) do
      H := H + StrFilter(Strings[n],'0123456789ABCDEFabcdef');
    Wire := THPACK.HexStrToRawByteString(H);
    try
      clear;
      Decode;
    except
    end;
  end;
  with fHPACK do
  begin
    memo1.Lines.add('// DebugStrings');
    memo1.Lines.addStrings(DebugStrings);
    memo1.Lines.add('');

    memo1.Lines.add('// HTTP Header-Fields');
    memo1.Lines.addStrings(fHPACK);
    memo1.Lines.add('');

    memo1.Lines.add('// new HPACK-TABLE');
    memo1.Lines.addStrings(dynTable);
    memo1.Lines.add('');
  end;
end;

procedure TForm1.Button20Click(Sender: TObject);
begin
  memo4.lines.clear;
end;

procedure TForm1.Button21Click(Sender: TObject);
begin
  memo1.lines.clear;
end;

procedure TForm1.Button22Click(Sender: TObject);
begin
 ShowDebugMessages;
 fHTTP2.debug(fHTTP2.r_SETTINGS_ACK);
 memo3.lines.addstrings(HTTP2.mDebug);
 mDebug.clear;
end;

procedure TForm1.Button23Click(Sender: TObject);
begin
 ShowDebugMessages;
 fHTTP2.debug(fHTTP2.r_SETTINGS);
 memo3.lines.addstrings(HTTP2.mDebug);
 mDebug.clear;
end;

procedure TForm1.Button24Click(Sender: TObject);
begin
 ShowDebugMessages;
 fHTTP2.debug(fHTTP2.r_WINDOW_UPDATE(0,2147418112));
 memo3.lines.addstrings(HTTP2.mDebug);
 mDebug.clear;
end;

procedure TForm1.Button25Click(Sender: TObject);
begin
 EnsureHTTP2;
 ShowDebugMessages;

 fHTTP2.debug(fHTTP2.r_DATA(0,THTTP2_Connection.NULL_PAGE));
 memo3.lines.addstrings(HTTP2.mDebug);
 mDebug.clear;
end;

procedure TForm1.Button26Click(Sender: TObject);
var
 H : THPACK;
begin
 EnsureHTTP2;
 ShowDebugMessages;

 with fHTTP2.HEADERS_OUT do
 begin
  clear;
  add(':status=200');
  add('server=' + Server);
  add('date=' + Date);
  add('content-type=text/html; charset=UTF-8');
  add('custom=~abcabcabc');
  encode;
 end;

 ShowDebugMessages;
 fHTTP2.debug(fHTTP2.r_HEADER(0));
 memo3.lines.addstrings(HTTP2.mDebug);
 mDebug.clear;
end;

procedure TForm1.Button27Click(Sender: TObject);
var
  n,k : Integer;
  S : string;
  B : TStringList;
  D : RawByteString;
begin

 D := '';
 with memo3.lines do
  for n := 0 to pred(count) do
  begin
   S := Strings[n];

   k := pos('>',S);
   if k>0 then
    S := copy(S,succ(k),MaxInt);

   k := pos('<',S);
   if k>0 then
    S := copy(S,succ(k),MaxInt);

   D := D + StrFilter(S,'0123456789ABCDEFabcdef');
  end;

 B := THPACK.HexStrToBinaryDebug(D);
 mDebug.addStrings(B);
 B.free;
 ShowDebugMessages;
 mDebug.clear;
end;

procedure TForm1.Button28Click(Sender: TObject);
var
 R,H : RawByteString;
begin
  R := THPACK.RawByteStringToHuffman(edit1.Text);
  H := THPACK.RawByteStringToHexStr(R);
  memo5.Lines.add(H);
  memo5.Lines.AddStrings(THPACK.HexStrToBinaryDebug(H));
end;

procedure TForm1.Button29Click(Sender: TObject);
begin
  StartServer;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  ShowDebugMessages;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  with fHTTP2 do
  begin
   write(r_GOAWAY);
  end;
end;

procedure TForm1.Button12Click(Sender: TObject);
var
    FName : string;
begin
 InitPathToTest;
 FName := PathToTests + edit4.Text + '.http2';
 fHTTP2.LoadRawBytes(FName);

 if (pos('-0-',FName)>0) then
  fHTTP2.AutomataState := 0 // we expect a "Client Hello", in a initial packet!
 else
  fHTTP2.AutomataState := 1; // we have no Client Helo!

 fHTTP2.CN_Pos := 0; // ensure we start "here"
 fHTTP2.Parse;

 ShowDebugMessages;
end;

procedure TForm1.Button13Click(Sender: TObject);
var
 BytesWritten : cint;
begin
 // thats NOT ok for a server to do this !
 BytesWritten := fHTTP2.write(@CLIENT_PREFIX[1],length(CLIENT_PREFIX));
 sDebug.Add(IntTostr(BytesWritten)+' Bytes written ...');
end;

procedure TForm1.Button14Click(Sender: TObject);
var
 n : integer;
 TABLE: TStringList;
begin
  if not(assigned(fHPACK)) then
   fHPACK := THPACK.Create;

  with fHPACK do
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
  if assigned(fHPACK) then
    FreeAndNil(fHPACK);
  memo4.lines.clear;
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
  D := fHTTP2.r_PING(PING_PAYLOAD);

  // save it as "init"
  InitPathToTest;
  fHTTP2.SaveRawBytes(D,PathToTests+'ping.http2');

  if assigned(fHTTP2) then
  begin
    BytesWritten := fHTTP2.write(@D[1],length(D));
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
            memo4.lines.clear;
            memo4.lines.add(W);


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

procedure TForm1.Button30Click(Sender: TObject);
begin

end;

procedure TForm1.Button31Click(Sender: TObject);
begin
 memo3.lines.add('--------------------------------------------------------------');
 memo3.lines.addstrings(fHTTP2.HEADERS_IN);
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
  fHTTP2.Accept(FD);
  ShowDebugMessages;
end;

procedure TForm1.EnsureHTTP2;
begin
  if not(assigned(fHTTP2)) then
  begin
   fHTTP2 := THTTP2_Connection.create;
   fHTTP2.OnRequest := @Request;
   ShowDebugmessages;
   fHTTP2.CTX:= fHTTP2.StrictHTTP2Context;
   fHTTP2.Path := Edit3.Text;
   ShowDebugmessages;
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  EnsureHTTP2;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  InitPathToTest;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  fHTTP2.ParserClear;
  fHTTP2.Parse;
end;

procedure TForm1.Button8Click(Sender: TObject);


 function StrFilter(s,Filter:string):string;
 var
   n : Integer;
 begin
   result := '';
   for n := 1 to length(s) do
    if pos(s[n],Filter)>0 then
     result := result + s[n];
 end;

var
 n,k : Integer;
 D : RawByteString;
 S : String;

begin
 EnsureHTTP2;

 D := '';
 with memo3.lines do
  for n := 0 to pred(count) do
  begin
   S := Strings[n];

   k := pos('>',S);
   if (k>0) then
    S := copy(S,succ(k),MaxInt);

   k := pos('<',S);
   if (k>0) then
    S := copy(S,succ(k),MaxInt);

   D += StrFilter(S,'0123456789ABCDEFabcdef');
  end;

 with fHTTP2 do
 begin
   ParserClear;

   // Auto-Detect if this is the "intitial Packet" with CLIENT_PREFIX
   if pos('5052',D)=1 then
    AutomataState := 0
   else
    AutomataState := 1;

   enqueue(THPACK.HexStrToRawByteString(D));
 end;
 ShowDebugMessages;
end;

const
  _AutoMataState : Integer = 0;

procedure TForm1.Button9Click(Sender: TObject);
var
  R : RawByteString;
begin
 with fHTTP2 do
 begin
  case _AutoMataState of
   0 : R := r_SETTINGS+r_WINDOW_UPDATE(0,2147418112);
   1 : R := r_SETTINGS_ACK;
   2 : begin

    with HEADERS_OUT do
     begin
      clear;
      add(':status=200');
      add('server=' + Server);
      add('date=' + Date);
      add('content-type=text/html; charset=UTF-8');
      encode;
     end;

    R := r_HEADER(15);

   end;
   3 : R := r_DATA(15,NULL_PAGE);
  end;
  mDebug.add('send Paket '+IntToStr(_AutoMataState)+' ...');
  write(R);

  ShowDebugMessages;
  inc(_AutoMataState);
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet2;
end;

procedure TForm1.Memo4Change(Sender: TObject);
begin

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

procedure TForm1.Request(R: TStringList);
var
  C : RawByteString;
  RequestedResourceName : string;
  ID : Integer;
begin
 memo2.Lines.add('{ ----------');
 memo2.Lines.AddStrings(R);
 memo2.Lines.add('---------- }');

 RequestedResourceName := R.Values[':path'];
 ID := StrToIntDef(R.Values[CONTEXT_HEADER_STREAM_ID],0);

 memo2.lines.add('Answering to '+RequestedResourceName+'@'+IntTOStr(ID)+ '...');
 repeat

  if (RequestedResourceName='/') then
  begin
    with fHTTP2 do
    begin
      with HEADERS_OUT do
      begin
        clear;
        add(':status=200');
        add('date='+Date);
        add('server='+Server);
        add('content-type='+ContentTypeOf(RequestedResourceName));
        encode;
      end;
      C := r_Header(ID)+r_DATA(ID,NULL_PAGE);
      write(C);
    end;
    break;
  end;

  // deliver a file
  with fHTTP2 do
  begin
    with HEADERS_OUT do
    begin
     clear;
     add(':status=200');
     add('date='+Date);
     add('server='+Server);
     add('content-type='+ContentTypeOf(RequestedResourceName));
     encode;
    end;
    write(r_Header(ID));
    sendfile(RequestedResourceName,ID);
  end;

 until yet;
 R.Free;
end;

procedure TForm1.StartServer;
begin
  if Initialized then
  begin
    InitPathToTest;
    EnsureHTTP2;
    FD := getSocket;
    if (FD<>0) then
     fHTTP2.Accept(FD);
    ShowDebugMessages;
  end;
end;

end.

// write rubbish
var
   buf : array[0..pred(16*1024)] of byte;
   n : integer;
   BytesWritten : cint;
  for n := low(buf) to high(buf) do
   buf[n] := random(256);

  BytesWritten := fHTTP2.write(@buf,sizeof(buf));
  sDebug.Add(IntTostr(BytesWritten)+' Bytes written ...');

