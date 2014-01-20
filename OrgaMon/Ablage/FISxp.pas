unit FISxp;

interface

uses
  // native
  Windows, Messages, SysUtils,
  Classes, Dialogs,

  // Indy
  IdIntercept, IdLogBase, IdLogEvent,
  IdIOHandler, IdIOHandlerSocket, IdSSLOpenSSL,
  IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, IdURI,

  // VCL
  StdCtrls, Controls, Forms,
  Graphics,

  // anfix
  html;

const
  ReadTimeOut: integer = 40000;
  InitHost: string = 'http://www.fisxp.supinfo.de';
  PathToForm: string = '/remscr/wfm/wfmtasks_tw/fisxp_wfmtaskFlatOFD.asp?datid=';
  PathToNewCounter: string = '/remscr/wfm/wfmlager/popWfmLagerZaehlerPickSubmit.asp?datid=';
  JavaScriptFunctionName: string = 'popWfmLagerZaehlerPick';
  Redirects: boolean = true;
  Authentication: boolean = true;

type
  TFormFISxp = class(TForm)
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocket1: TIdSSLIOHandlerSocket;
    Memo3: TMemo;
    IdLogEvent1: TIdLogEvent;
    Memo_Data: TMemo;
    Button4: TButton;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Button5: TButton;
    Button6: TButton;
    CheckLogEvents: TCheckBox;
    Label6: TLabel;
    EditAction: TEdit;
    Button3: TButton;
    Button7: TButton;
    FormList: TListBox;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    EditDatID: TEdit;
    JavaParamsList: TListBox;
    Label8: TLabel;
    Button8: TButton;
    Label11: TLabel;
    Label12: TLabel;
    EditCounterID: TEdit;
    GroupBox1: TGroupBox;
    EditUser: TEdit;
    EditPass: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    Button9: TButton;

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure IdHTTP1Redirect(Sender: TObject; var dest: string;
      var NumRedirect: Integer; var Handled: Boolean;
      var VMethod: TIdHTTPMethod);
    procedure IdLogEvent1Status(ASender: TComponent; const AText: string);
    procedure FormCreate(Sender: TObject);
    procedure IdLogEvent1Send(ASender: TIdConnectionIntercept;
      AStream: TStream);
    procedure IdLogEvent1Sent(ASender: TComponent; const AText,
      AData: string);
    procedure Button3Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormListClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Memo_DataKeyPress(Sender: TObject; var Key: Char);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private-Deklarationen }
    FIShtml: THTMLTemplate;
    EnterData: boolean;
    Redirected: boolean;
    _LastError: string;
    Host: string;
    procedure TakeOver;
    procedure ShowForm(index: integer);
    procedure CheckLog;
    function GatherIdentData: boolean;
  public
    { Public-Deklarationen }
    function GhostLink(DatID, FisUserName, FisUserPassword: string): string;
    function InitGhost(DatID, FisUserName, FisUserPassword: string): boolean;

    function GetVarList: TStringList;
    function ProcessOne: TStringList; // Result = HTTP-konforme Error Meldung (Erfolg=200)

    function NewCounter(DatID, CounterID: string): boolean;

    function LastError: string;
  end;
//---------------------------------
var
  FormFISxp: TFormFISxp;

implementation

uses
  // globals,
  anfix32;

{$R *.dfm}

function TFormFISxp.GhostLink(DatID, FisUserName, FisUserPassword: string): string;
var
  uri: TIdURI;
begin
  result := '';
  try
    IdHTTP1.ReadTimeout := ReadTimeOut;
    IdHTTP1.Host := InitHost;
    IdHTTP1.HandleRedirects := Redirects;
    IdHTTP1.Request.BasicAuthentication := Authentication;
    IdHTTP1.Request.Username := FisUserName;
    IdHTTP1.Request.Password := FisUserPassword;

    Host := InitHost;

    IdHTTP1.Get(Host);

    uri := TIdURI.create(Host);
    Host := uri.Protocol + '://' +
      FisUserNAme + ':' +
      FisUserPassword + '@' +
      uri.Host;
    result := Host + PathToForm + DatID;
    uri.Free;
  except
  end;
end;

function TFormFISxp.InitGhost(DatID, FisUserName, FisUserPassword: string): boolean;
var
  get: TStringStream;
  uri: TIdURI;
  html: TStringList;
  URL: string;
  text: string;
  line: string;
  k: integer;
begin
  Result := false;
  try
    IdHTTP1.ReadTimeout := ReadTimeOut;
    IdHTTP1.Host := InitHost;
    IdHTTP1.HandleRedirects := Redirects;
    IdHTTP1.Request.BasicAuthentication := Authentication;
    IdHTTP1.Request.Username := FisUserName;
    IdHTTP1.Request.Password := FisUserPassword;

    Host := InitHost;

    IdHTTP1.Get(Host);

    uri := TIdURI.create(Host);
    Host := uri.Protocol + '://' + uri.Host;
    URL := Host + PathToForm + DatID;
    uri.Free;

    get := TStringStream.Create('');

    try
      IdHTTP1.Get(URL, get);
    except
    end;

    get.Seek(0, soFromBeginning);

    html := TStringList.Create;

    html.LoadFromStream(get);

    // for k := 0 to pred(html.count) do memo_data.lines.Add(html.strings[k]);

    ersetze('<', #$0D + #$0A + '<', html);
    ersetze(#$0D + #$0A + #$0D + #$0A, #$0D + #$0A, html);

    text := html.Text;

    html.Clear;
    repeat begin
        k := pos(#$0D + #$0A, text);
        line := copy(text, 1, k - 1);
        text := copy(text, k + 2, length(text) - k - 2);
        if (cutblank(line) <> '') then html.Add(line);
    end until k = 0;

    FIShtml.Assign(html);
    FIShtml.Parse;

    get.Free;
    html.Free;

    Result := true;
  except
    on e: exception do
    begin
      _LastError := e.message;
    end;
  end;
end;

procedure TFormFISxp.IdHTTP1Redirect(Sender: TObject; var dest: string;
  var NumRedirect: Integer; var Handled: Boolean;
  var VMethod: TIdHTTPMethod);
begin
  Host := dest;
  Redirected := Handled;
end;

function TFormFISxp.ProcessOne: TStringList;
var post: TStringStream;
begin
  Result := TStringList.Create;
  try
    GatherIdentData;
    post := TStringStream.Create('');
    IdHTTP1.Post(Host + FIShtml.GetFormAction(0), FIShtml.GetForm(0), post);
    post.Seek(0, soFromBeginning);
    Result.LoadFromStream(post);
    post.Free;
    Result.Insert(0, inttostr(IdHTTP1.ResponseCode));
  except
    on e: exception do
    begin
      Result.Insert(0, e.message);
      Result.Insert(0, '999');
    end;
  end;
end;

procedure TFormFISxp.Button1Click(Sender: TObject);
var i: integer;
begin
  EnterData := false;
  CheckLog;
  FormList.Clear;

  if not (InitGhost(EditDatID.Text, EditUser.Text, EditPass.Text)) then
    ShowMessage(LastError);

  with FIShtml do
  begin
    for i := 0 to pred(CountForms) do FormList.Items.Add(GetFormName(i));
    JavaParamsList.Items.Assign(GetJavaParams('popWfmLagerZaehlerPick'));
  end;

  ShowForm(1);
end;

procedure TFormFISxp.Button2Click(Sender: TObject);
begin
  CheckLog;
  memo3.clear;
  memo3.lines.addstrings(ProcessOne);
end;

procedure TFormFISxp.Button4Click(Sender: TObject);
begin
  Close;
end;

procedure TFormFISxp.FormCreate(Sender: TObject);
begin
  memo3.Font.Color := clMaroon;
  memo3.Clear;
  memo_data.Font.Color := clGreen;
  memo_data.Clear;

  EnterData := false;

  if not assigned(FIShtml) then FIShtml := THTMLTemplate.create;
end;

// LogEventHandles

procedure TFormFISxp.IdLogEvent1Status(ASender: TComponent;
  const AText: string);
begin
  memo3.Lines.Add('** STATUS *********************************');
  memo3.Lines.Add(AText);
end;

procedure TFormFISxp.IdLogEvent1Send(ASender: TIdConnectionIntercept;
  AStream: TStream);
var
  c: char;
  s: string;
begin
  s := '';
  memo3.Lines.Add('** SEND *********************************');
  repeat
    if AStream.Read(c, 1) = 0 then
      break;
    s := s + c
  until false;
  memo3.lines.add(s);
end;

procedure TFormFISxp.IdLogEvent1Sent(ASender: TComponent; const AText,
  AData: string);
begin
  memo3.Lines.Add('** SENT *********************************');
  memo3.Lines.Add(AText);
  memo3.Lines.Add(AData);
end;


// Private

procedure TFormFISxp.CheckLog;
begin
  if CheckLogEvents.State = cbChecked then IdLogEvent1.Active := true
  else IdLogEvent1.Active := false;
end;

procedure TFormFISxp.TakeOver;
var
  VarList: TStringList;
  n: integer;
begin
  VarList := FIShtml.GetForm(1);
  VarList.clear;
  with memo_data do
    for n := 0 to pred(Lines.Count) do
      if pos('=', Lines[n]) > 0 then
        VarList.add(Lines[n]);

  if GatherIdentData then
    ShowForm(0)
  else
    ShowMessage(_LastError);
end;

procedure TFormFISxp.Button3Click(Sender: TObject);
begin
  memo_data.Clear;
end;

procedure TFormFISxp.Button7Click(Sender: TObject);
begin
  memo3.Clear;
end;

procedure TFormFISxp.FormDestroy(Sender: TObject);
begin
  if assigned(FIShtml) then FIShtml.Free;
end;

function TFormFISxp.GatherIdentData: boolean;
var
  i: integer;
  VarList: TStringList;
  nam: string;
  val: string;
  len: integer;
  cut: integer;
  typ: string;
  error_obli: boolean;
  error_type: boolean;
  str: string;
begin
  VarList := FIShtml.GetForm(1);

  str := '';
  error_obli := false;
  error_type := false;
  for i := 0 to pred(VarList.Count) do
  begin
    nam := nextp(VarList.Strings[i], '=', 0);
    val := nextp(VarList.Strings[i], '=', 1);
    len := length(val);
    if (copy(nam, 1, 5) = 'obli_') then
    begin
      if (val = '') then error_obli := true;
      cut := 5;
    end
    else cut := 0;
    if (len <> 0) then
    begin
      typ := copy(nam, cut + 1, 5);
      if (typ = 'time_') then cut := cut + 5;
      if (typ = 'date_') then cut := cut + 5;
      if (typ = 'text_') then cut := cut + 5;
      if (typ = 'intg_') then cut := cut + 5;
      if (typ = 'real_') then
      begin
        ersetze(',', '.', val);
        cut := cut + 5;
      end;
    end;

    str := str + '&' + copy(nam, cut + 1, length(nam) - cut) + '=' + val;
  end;

  str := str + '&';

  str := rfc1738(str);

  if (error_obli = true) then _LastError := 'Mindestens ein Pflichtfeld ist nicht ausgefüllt !';
  if (error_type = true) then _LastError := 'Mindestens ein Feld enthält einen ungültigen Wert !';

  VarList := FIShtml.GetForm(0);
  VarList.Values['identdata'] := str;

  if (error_obli or error_type) then result := false
  else result := true;
end;

procedure TFormFISxp.Button6Click(Sender: TObject);
begin
  EnterData := true;
  ShowForm(1);
end;

procedure TFormFISxp.ShowForm(index: integer);
var
  s: TStrings;
begin
  FormList.ItemIndex := index;
  with FIShtml do
  begin
    s := GetForm(index);
    if (s <> nil) then
      memo_data.Lines.Assign(s)
    else
      memo_data.Lines.clear;
    EditAction.text := GetFormAction(index);
  end;
end;

procedure TFormFISxp.FormListClick(Sender: TObject);
begin
  EnterData := false;
  ShowForm(FormList.ItemIndex);
end;

procedure TFormFISxp.Button5Click(Sender: TObject);
begin
  if (EnterData = true) then TakeOver
  else ShowMessage('Sie müssen zuerst Daten eingeben !');
end;

procedure TFormFISxp.Memo_DataKeyPress(Sender: TObject; var Key: Char);
begin
  if (FormList.ItemIndex = 1) then EnterData := true;
end;

function TFormFISxp.GetVarList: TStringList;
begin
  result := FIShtml.GetForm(1);
end;

function TFormFISxp.LastError: string;
begin
  result := _LastError;
end;

function TFormFISxp.NewCounter(DatID, CounterID: string): boolean;
var JavaParams: TStringList;
  DatPA: string;
  URL: string;
  get: TStringStream;
  html: TStringList;
begin
  while length(CounterID) < 18 do CounterID := '0' + CounterID;
  JavaParams := FIShtml.GetJavaParams(JavaScriptFunctionName);
  DatPA := JavaParams.Strings[1];

  URL := Host + PathToNewCounter + DatID + '&datpa=' + DatPA + '&sernr=' + CounterID;

  // ShowMessage(URL);
  Result := false;
  try
    // get := TStringStream.Create('');
    // IdHTTP1.Get(URL, get);
    // get.Seek(0, soFromBeginning);
    // html := TStringList.Create;
    // html.LoadFromStream(get);
    // memo3.Lines.AddStrings(html);
    // get.Free;
    // html.Free;

    IdHTTP1.Get(URL);

    Result := true;
  except
    on e: exception do
    begin
      _LastError := e.message;
    end;
  end;
end;


procedure TFormFISxp.Button8Click(Sender: TObject);
begin

  if EditCounterID.Text <> '' then
  begin
    if NewCounter(EditDatID.Text, EditCounterID.Text) then ShowMessage('Neuer Zähler erfolgreich eingetragen !')
    else ShowMessage('Ein Fehler ist aufgetreten: ' + _LastError);
    Button1Click(FormFisXP.Button8);
  end
  else ShowMessage('Zuerst SerienNummer Neu eingeben !');

end;

procedure TFormFISxp.Button9Click(Sender: TObject);
begin
//  FIShtml.SaveToFile(DiagnosePath + 'fisxp.html.txt');
//  open(cDiagnosePath + 'fisxp.html.txt');
end;

end.

