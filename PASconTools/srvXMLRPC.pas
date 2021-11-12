{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2021  Andreas Filsinger
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
unit srvXMLRPC;

{$ifdef fpc}
{$mode delphi}
{$endif}

interface

uses
  Classes, IdCustomHTTPServer,
  SyncObjs, IdHTTPServer, IdContext;

const
  cXML_NameSpaceDelimiter = '.';
  cXMLRPC_Version : single = 1.021;
  REST_ETAG : string = '';

type
  TXMLRPC_Method = function (sParameter: TStringList) : TStringList of object;

  // sParameter und "Result" sind String-Listen, die im "objects" Anteil zu
  // jedem String die Typ-Information speichern. Dazu definiert "TXMLRPC_Server"
  // verschiedene Typen "o*" die als Class-Functions zugänglich sind.
  //
  // [0] : vom Typ oMethodName
  // [1..] : vom Typ {oInteger, oDouble, oDateTime, oString, oBoolean}
  //
  // call('a;b;c') kommt im sParameter[1] als 'a,b,c' an
  //

const
  //
  // das Feedback-Interface nutzt TXMLRPC_Method, der Server ruft
  // die Feedback-Implementierung des Client
  //
  cFeedback_Log = 'Log'; // s : array of string
  cFeedback_Info = 'Info'; // s : string
  cFeedback_Progress = 'Progress';
  // BarName : string; Position : integer; Max : integer
  cFeedback_Inquire = 'Inquire'; // Question : string
  cFeedBack_Message = 'Message'; // Message : string

  cServerFunctions_Meta_CallCount = '_CALLS';
  cServerFunctions_Meta_Uptime = '_UPTIME';

  cParameter_Unset = 0;
  cParameter_Control = -1000;
  cParameter_DisableCache = cParameter_Control - 1;

type
  TFeedbackHelper = class
    class function Progress(Position: Integer; Name: string = ''; Maximum: Integer = 0)
      : TStringList;
    class function ShowMessage(Msg: string): TStringList;
  end;

type
  // TOOL: Liste der Methoden
  TMethodList = class
  private
    fList: array of TXMLRPC_Method;
    function GetCount: Integer;
    function GetItem(const index: Integer): TXMLRPC_Method;
  public
    procedure Add(aMethod: TXMLRPC_Method);
    property Count: Integer read GetCount;
    property Items[const index: Integer]: TXMLRPC_Method read GetItem; default;
  end;

  // SERVER: synchroner XMLRPC Server
  TXMLRPC_Server = class(TIdHTTPServer)
  private
    sMethodNames: TStringList;
    mMethodAddr: TMethodList;
    sCloseTagEvents: TStringList;
    callSection: TCriticalSection;
    procedure XMLRPC_get(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);

    function parse(xml: TStringList): TStringList;
    function good_xml(OutParam: TStringList): string;
    function bad_xml(ErrorCode: Integer; ErrorMsg: String): string;


    class function QuoteParams(Params: TStringList):TStringList;

  public

    DebugMode: boolean;
    TimingStats: boolean;
    DiagnosePath: string;
    LogContext: string;
    Stat_Calls: Integer;
    Stat_Exceptions: Integer;

    // Aufrufparameter verpacken
    class function QuoteInteger(s: string): string;
    class function QuoteDouble(s: string): string;
    class function QuoteDateTime(s: string): string;
    class function QuoteString(s: string): string;
    class function QuoteBoolean(s: string): string;
    class function QuoteBeginArray: string;
    class function QuoteEndArray: string;

  published

    property Methods: TStringList read sMethodNames;

    // Type-Info for the TStringList.Objects
    class function oInteger: TObject;
    class function oDouble: TObject;
    class function oDateTime: TObject;
    class function oString: TObject;
    class function oBoolean: TObject;
    class function oMethodName: TObject;
    class function oBeginArray: TObject;
    class function oEndArray: TObject;
    class function oMetaString: TObject;

    // TOOLS
    class function fromInteger(i: Integer): string;
    class function fromObject(o: TObject): string;
    class function fromDouble(d: double): string;
    class function fromDateTime(d: TDateTime): string;
    class function fromBoolean(b: boolean): string;

    // XMLRPC-Methoden anmelden
    //
    // Name: [<NameSpace> "."] <Methodenname>
    //
    // <NameSpace>  : informativer Namens-Domain, wird aber bei der Zuordnung
    // von RPC-Aufrufen nicht ausgewertet. Das bedeutet für eine
    // Routine, die als "JonDa.Info" angemeldet werden, dass ein
    // Aufruf von "Test.Info" dennoch die registrierte "Info"
    // gerufen wird. Inerhalb der "Info" Implementierung hat man
    // jedoch im "sParameter[0]" "Test.Info" stehen, man kann also
    // NameSpace abhängig Implementierungen verwirklichen (Mandanten).
    // Typische Anwendung ist die Artikelsuche, hier kann man die Suche
    // auf verschiedenen Indizes anwenden: "sale", "restposten", "alles"
    //
    // <MethodName> : der Methodenname an sich, dieser muss pro Server eindeutig
    // sein. Die Anzahl der Server ist auf die freien Ports
    // beschränkt.
    // Method: Die implementierte Routine, die gerufen werden soll
    procedure addMethod(Name: string; Method: TXMLRPC_Method);

    // XMLRPC-Methoden local ausführen
    //
    function exec(Name: string; Parameter: TStringList): TStringList;

  end;

// XMLRPC-Client, Methoden remote ausführen
function remote_exec(Host:string;Port:integer;Method:string;Parameter:TStringList = nil; NameSpace: string = 'abu') : TStringList;

// REST-Client, "GET" remote ausführen
function REST(request: string; Attachment: string = ''; ForceRAW : boolean = false) : TStringList;

// Texte gehen in die Log-Datei
procedure Log(s: string);

implementation

uses
  // System
  Sysutils,

  // Indy
  IdHTTP,
  IdMultipartFormData,

  // anfix-Tools
  html, anfix, CareTakerClient;

{ TXMLRPC_Server }

const
  cXML_Tag_ErrorCode = '~ErrorCode~';
  cXML_Tag_ErrorText = '~ErrorText~';
  cXML_Tag_Value = '~Value~';
  cXML_CR = #13#10;
  cXML_Head = '<?xml version="1.0"?>' + cXML_CR;

  cXML_Response =
  { } cXML_Head +
  { } '<methodResponse>' + cXML_CR +
  { } ' <params>' + cXML_CR +
  { } '  <param>' + cXML_CR +
  { } '   ' + cXML_Tag_Value + cXML_CR +
  { } '  </param>' + cXML_CR +
  { } ' </params>' + cXML_CR +
  { } '</methodResponse>';

  cXML_Error =
  { } cXML_Head +
  { } '<methodResponse>' + cXML_CR +
  { } ' <fault>' + cXML_CR +
  { } '  <value>' + cXML_CR +
  { } '   <struct>' + cXML_CR +
  { } '    <member>' + cXML_CR +
  { } '      <name>faultCode</name>' + cXML_CR +
  { } '      <value><int>' + cXML_Tag_ErrorCode + '</int></value>' + cXML_CR +
  { } '    </member>' + cXML_CR +
  { } '    <member>' + cXML_CR +
  { } '     <name>faultString</name>' + cXML_CR +
  { } '     <value><string>' + cXML_Tag_ErrorText + '</string></value>' + cXML_CR +
  { } '    </member>' + cXML_CR +
  { } '   </struct>' + cXML_CR +
  { } '  </value>' + cXML_CR +
  { } ' </fault>' + cXML_CR +
  { } '</methodResponse>';

  // mögliche Typen
  cXML_SimpleType_String = $00000000;
  cXML_SimpleType_Integer = $00000001;
  cXML_SimpleType_Double = $00000002;
  cXML_SimpleType_DateTime = $00000003;
  cXML_SimpleType_Boolean = $00000004;
  cXML_SimpleType_Method = $00000005;
  cXML_SimpleType_BeginArray = $0000006;
  cXML_SimpleType_EndArray = $0000007;
  cXML_SimpleType_MetaString = $00000008;

const
  gDiagnoseFName: string = '';

procedure TMethodList.Add(aMethod: TXMLRPC_Method);
var
  i: Integer;
begin
  i := length(fList);
  SetLength(fList, succ(i));
  fList[i] := aMethod;
end;

function TMethodList.GetItem(const index: Integer): TXMLRPC_Method;
begin
  result := TXMLRPC_Method(fList[index]);
end;

function TMethodList.GetCount: Integer;
begin
  result := length(fList);
end;

class function TXMLRPC_Server.QuoteDateTime(s: string): string;
begin
  result := '<value><dateTime.iso8601>' + s + '</dateTime.iso8601></value>';
end;

class function TXMLRPC_Server.QuoteDouble(s: string): string;
begin
  result := '<value><double>' + s + '</double></value>';
end;

class function TXMLRPC_Server.QuoteInteger(s: string): string;
begin
  result := '<value><int>' + s + '</int></value>';
end;

class function TXMLRPC_Server.QuoteString(s: string): string;
var
  AsXML: string;
begin
  AsXML := s;
  ersetze('&', c_xml_ampersand, AsXML);
  // c_xml_CRLF = '&#xA;';
  ersetze('<', c_xml_lessthan, AsXML);
  ersetze('>', c_xml_greaterthan, AsXML);
  ersetze('''', c_xml_apostrophe, AsXML);
  ersetze('"', c_xml_quote, AsXML);
  result := '<value><string>' + AsXML + '</string></value>';
end;

class function TXMLRPC_Server.QuoteBoolean(s: string): string;
begin
  result := '<value><boolean>' + s + '</boolean></value>';
end;

class function TXMLRPC_Server.QuoteBeginArray: string;
begin
  result := '<value><array><data>';
end;

class function TXMLRPC_Server.QuoteEndArray: string;
begin
  result := '</data></array></value>';
end;

class function TXMLRPC_Server.QuoteParams(Params: TStringList):TStringList;
var
 n : integer;

begin
  result := TStringList.create;
  for n := 0 to pred(Params.count) do
  begin


   case integer(Params.objects[n]) of
  cXML_SimpleType_String :begin
      result.add('<param>');
      result.Add(QuoteString(Params[n]));
      result.add('</param>');
  end;
  cXML_SimpleType_Integer :  begin
      result.add('<param>');
   result.Add(QuoteInteger(Params[n]));
      result.add('</param>');
  end;
  cXML_SimpleType_Double :  begin
      result.add('<param>');
  result.Add(QuoteDouble(Params[n]));
      result.add('</param>');
  end;
  cXML_SimpleType_DateTime : begin
      result.add('<param>');
  result.Add(QuoteDateTime(Params[n]));
      result.add('</param>');
  end;
  cXML_SimpleType_Boolean : begin
  result.Add(QuoteBoolean(Params[n]));
  end;
  cXML_SimpleType_BeginArray : begin
      result.add('<param>');
  result.Add(QuoteBeginArray);
  end;
  cXML_SimpleType_EndArray : begin
  result.Add(QuoteEndArray);
      result.add('</param>');
  end
  else
   raise Exception.Create('Unkown Parameter Type');
  end;
  end;
end;


class function TXMLRPC_Server.fromDateTime(d: TDateTime): string;
begin
  result := FormatDateTime('yyyymmdd"T"hh:mm:ss', d);
end;

class function TXMLRPC_Server.fromDouble(d: double): string;
begin
  result := FloatToStrISO(d);
end;

class function TXMLRPC_Server.fromInteger(i: Integer): string;
begin
  result := IntToStr(i);
end;

class function TXMLRPC_Server.fromObject(o: TObject): string;
begin
  result := IntToStr(Integer(o));
end;

class function TXMLRPC_Server.fromBoolean(b: boolean): string;
const
  s: array [boolean] of string = ({false=}'0',{true=}'1');
begin
  result := s[b];
end;

procedure TXMLRPC_Server.addMethod(Name: string; Method: TXMLRPC_Method);
begin

  if not(assigned(sMethodNames)) then
  begin
    // Init
    ServerSoftware := 'srvXMLRPC Rev. '+RevToStr(cXMLRPC_Version)+' (c) Andreas Filsinger';
    OnCommandGet := XMLRPC_get;
    TerminateWaitTime := 30000;
    sMethodNames := TStringList.Create;
    mMethodAddr := TMethodList.Create;
    callSection := TCriticalSection.Create;
    sCloseTagEvents := TStringList.Create;
    with sCloseTagEvents do
    begin
      addobject('methodCall.methodName', oMethodName);
      addobject('methodCall.params.param.value.string', oString);
      addobject('methodCall.params.param.value.dateTime.iso8601', oDateTime);
      addobject('methodCall.params.param.value.double', oDouble);
      addobject('methodCall.params.param.value.int', oInteger);
      addobject('methodCall.params.param.value.boolean', oBoolean);
    end;
    if DebugMode then
     if DiagnosePath = '' then
       DiagnosePath := 'C:\';
    if (LogContext<>'') then
     LogContext := '-' + LogContext;
    if (DiagnosePath='') then
      gDiagnoseFName := ''
    else
      gDiagnoseFName :=
       { } DiagnosePath +
       { } 'XMLRPC-' +
       { } DatumLog +
       { } LogContext +
       {} cLogExtension;
  end;

  if (sMethodNames.IndexOf(Name) <> -1) then
    raise Exception.Create('Methode "' + Name + '" ist bereits definiert!');

  sMethodNames.Add(Name);
  mMethodAddr.Add(Method);
end;

function TXMLRPC_Server.bad_xml(ErrorCode: Integer; ErrorMsg: String): string;
begin
  result := cXML_Error;
  ersetze(cXML_Tag_ErrorCode, IntToStr(ErrorCode), result);
  ersetze(cXML_Tag_ErrorText, ErrorMsg, result);
end;

function TXMLRPC_Server.exec(Name: string; Parameter: TStringList): TStringList;
var
  n: Integer;
  MethodName: string;
begin
  // [0] ist immer [ Namespace "." ] MethodName
  Parameter.InsertObject(0, Name, oMethodName);

  // Prefix-Namespace abtrennen
  n := revpos(cXML_NameSpaceDelimiter, Name);
  if (n > 0) then
    MethodName := copy(Name, succ(n), MaxInt)
  else
    MethodName := Name;

  // Funktionsaufruf
  n := sMethodNames.IndexOf(MethodName);
  if (n <> -1) then
    result := mMethodAddr[n](Parameter)
  else
    result := nil;
end;

function TXMLRPC_Server.good_xml(OutParam: TStringList): string;
begin
  result := cXML_Response;
  if assigned(OutParam) then
    ersetze(cXML_Tag_Value, HugeSingleLine(OutParam, cXML_CR), result)
  else
    ersetze(cXML_Tag_Value, '', result);
end;

procedure Log(s: string);
begin
  if (gDiagnoseFName<>'') then
    AppendStringsToFile(s, gDiagnoseFName);
end;

class function TXMLRPC_Server.oBoolean: TObject;
begin
  result := TObject(cXML_SimpleType_Boolean);
end;

class function TXMLRPC_Server.oDateTime: TObject;
begin
  result := TObject(cXML_SimpleType_DateTime);
end;

class function TXMLRPC_Server.oDouble: TObject;
begin
  result := TObject(cXML_SimpleType_Double);
end;

class function TXMLRPC_Server.oInteger: TObject;
begin
  result := TObject(cXML_SimpleType_Integer);
end;

class function TXMLRPC_Server.oMetaString: TObject;
begin
  result := TObject(cXML_SimpleType_MetaString);
end;

class function TXMLRPC_Server.oMethodName: TObject;
begin
  result := TObject(cXML_SimpleType_Method);
end;

class function TXMLRPC_Server.oString: TObject;
begin
  result := TObject(cXML_SimpleType_String);
end;

class function TXMLRPC_Server.oBeginArray: TObject;
begin
  result := TObject(cXML_SimpleType_BeginArray);
end;

class function TXMLRPC_Server.oEndArray: TObject;
begin
  result := TObject(cXML_SimpleType_EndArray);
end;

function TXMLRPC_Server.parse(xml: TStringList): TStringList;

var
  sMESSAGE: TStringList;
  NameSpace: TStringList;
  sRESULT: TStringList;

  // PARSE
  AutoMataState: Integer;
  ActParserValue: string;
  CloseTag: boolean;
  LineNo: Integer;
  ErrorCount: Integer;

  procedure Error(s: string);
  var
    ErrorMsg: TStringList;
  begin
    if (gDiagnoseFName <> '') then
    begin
      ErrorMsg := TStringList.Create;
      ErrorMsg.Add(cERRORText + ' XML-RPC: { Exception ');
      ErrorMsg.Add(DatumLog + ' ' + Uhr8);
      ErrorMsg.Add('Parse (');
      ErrorMsg.AddStrings(xml);
      ErrorMsg.Add(') :');
      ErrorMsg.Add(s + '}');
      AppendStringsToFile(ErrorMsg, gDiagnoseFName);
      ErrorMsg.free;
    end;
    inc(ErrorCount);
  end;

  function FormatValue(s: string): string;
  begin
    result := s;
    ersetze(c_xml_CRLF, '|', result);
    ersetze(c_xml_ampersand, '&', result);
    result := html2ansi(result);
    ersetze(';', ',', result);
  end;

  function fullName: string;
  var
    n: Integer;
  begin
    if (NameSpace.Count = 0) then
    begin
      result := '';
    end
    else
    begin
      result := NameSpace[0];
      for n := 1 to pred(NameSpace.Count) do
        result := result + cXML_NameSpaceDelimiter + NameSpace[n]
    end;
  end;

  procedure push(Name: string);
  begin
    // Push to NameSpace
    NameSpace.Add(Name);
    ActParserValue := '';
  end;

  procedure pop;
  var
    _FullName: string;
    k: Integer;
  begin
    _FullName := fullName;
    k := sCloseTagEvents.IndexOf(_FullName);
    if (k <> -1) then
      sRESULT.addobject(sMESSAGE.Values[_FullName], sCloseTagEvents.objects[k]);
    // pop from Namespace
    NameSpace.delete(pred(NameSpace.Count));
  end;

  procedure parseLine(Line: string);
  var
    k, l, m: Integer;
    id: string;
    Rounds: Integer;
  begin
    try
      Rounds := 0;
      repeat

        // Runden-Zähler
        inc(Rounds);
        if (Rounds > 2000) then
        begin
          Error(' Parse: Zeile "' + Line + '" nicht verständlich!');
          break;
        end;

        //
        if (Line <> '') then
          case AutoMataState of
            0:
              begin // suche ein open Tag "<", ansonsten kommt alles in "value"!

                k := pos('<', Line);
                if (k > 0) then
                begin
                  if (k > 1) then
                  begin
                    ActParserValue := ActParserValue + copy(Line, 1, pred(k));
                  end;
                  delete(Line, 1, k);
                  AutoMataState := 1;
                end
                else
                begin
                  ActParserValue := ActParserValue + Line + '|';
                  Line := '';
                end;

              end;
            1:
              begin // Art des Tag bestimmen

                if (pos('!--', Line) = 1) then
                begin
                  AutoMataState := 2;
                  continue;
                end;

                if (pos('!', Line) = 1) then
                begin
                  AutoMataState := 3;
                  continue;
                end;

                if (pos('?', Line) = 1) then
                begin
                  AutoMataState := 3;
                  continue;
                end;

                if (pos('/', Line) = 1) then
                begin
                  sMESSAGE.Values[fullName] := FormatValue(ActParserValue);
                  ActParserValue := '';
                  CloseTag := true;
                  delete(Line, 1, 1);
                end;

                AutoMataState := 4;

              end;
            2:
              begin // Suche den comment Close Tag
                k := pos('-->', Line);
                if (k > 0) then
                begin
                  delete(Line, 1, k + 2);
                  AutoMataState := 0;
                  continue;
                end;
                Line := '';
              end;
            3:
              begin // es ist ein reiner XML interner Tag
                k := pos('>', Line);
                if (k > 0) then
                begin
                  delete(Line, 1, k);
                  AutoMataState := 0;
                  continue;
                end;

                Line := '';
              end;
            4:
              begin // Name eines echten Tags einlesen,

                if CloseTag then
                begin

                  CloseTag := false;
                  k := pos('>', Line);
                  delete(Line, 1, k);
                  pop;
                  AutoMataState := 0;

                end
                else
                begin

                  k := pos(' ', Line);
                  l := pos('>', Line);
                  m := pos('/>', Line);

                  // nach dem Namen kommt ein leerschritt? -> Es gibt Werte!
                  if (k > 0) and ((k < l) or (l = 0)) then
                  begin
                    push(copy(Line, 1, pred(k)));
                    delete(Line, 1, k);
                    AutoMataState := 5;
                    continue;
                  end;

                  // nach dem Namen kommt sofort der CloseTag?
                  if (l > 0) and ((l < k) or (k = 0)) then
                  begin
                    if (m <> l - 1) then
                    begin
                      // Beginn eines neuen Wertes
                      push(copy(Line, 1, pred(l)));
                      delete(Line, 1, l);
                    end
                    else
                    begin
                      // Beginn und gleichzeitiges Ende eines Wertes
                      push(copy(Line, 1, pred(m)));
                      sMESSAGE.Values[fullName] := '';
                      pop;
                      delete(Line, 1, m);
                    end;
                    AutoMataState := 0;
                    continue;
                  end;

                end;
              end;
            5:
              begin // Identifier eines einzelnen Tags sammeln

                while (pos(' ', Line) = 1) do
                  delete(Line, 1, 1);

                if (pos('/>', Line) = 1) then
                begin
                  pop;
                  delete(Line, 1, 2);
                  AutoMataState := 0;
                  continue;
                end;

                if (pos('>', Line) = 1) then
                begin
                  delete(Line, 1, 1);
                  AutoMataState := 0;
                  continue;
                end;

                k := pos('=', Line);
                id := copy(Line, 1, pred(k));
                ActParserValue := '';
                delete(Line, 1, k);
                AutoMataState := 6;

              end;
            6:
              begin // Sammeln eines id="embedded" !

                if (pos('"', Line) = 1) then
                begin

                  // Wert herausschneiden, Linie verkürzen!
                  ActParserValue := copy(Line, 2, MaxInt);
                  k := pos('"', ActParserValue);
                  delete(Line, 1, succ(k));

                  ActParserValue := copy(ActParserValue, 1, pred(k));
                  AutoMataState := 5;
                end;

                sMESSAGE.Values[fullName + '.' + id] := FormatValue(ActParserValue);

              end;
          end;
      until Line = '';
    except
      on e: Exception do
        Error('Parse: Line ' + IntToStr(LineNo) + ':' + e.message);
    end;
  end;

begin
  sRESULT := TStringList.Create;
  sMESSAGE := TStringList.Create;
  NameSpace := TStringList.Create;

  ErrorCount := 0;
  AutoMataState := 0;
  CloseTag := false;
  for LineNo := 0 to pred(xml.Count) do
  begin
    parseLine(xml[LineNo]);
    if (ErrorCount > 0) then
      break;
  end;

  NameSpace.free;
  sMESSAGE.free;

  result := sRESULT;
end;

procedure TXMLRPC_Server.XMLRPC_get(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
  AResponseInfo: TIdHTTPResponseInfo);
var
  MethodName: string;
  Name: string;
  n: Integer;
  inParam: TStringList;
  OutParam: TStringList;
  Request: TStringList;
  ErrorMsg: TStringList;
  WasError: boolean;
  StartTime: int64;

  function QuoteMetaString(s: string): string;
  begin
    result := s;
    ersetze(cServerFunctions_Meta_CallCount, IntToStr(Stat_Calls), result);
    ersetze(cServerFunctions_Meta_Uptime, SecondsToStr9(RunTime) + '@' +
      SecondsToStr9(UpTime), result);
    result := QuoteString(result);
  end;

begin
  Request := TStringList.Create;
  WasError := false;
  OutParam := nil;
  AResponseInfo.ContentType := 'text/xml';
  repeat

    // Read Request
    if assigned(ARequestInfo.PostStream) then
      Request.LoadFromStream(ARequestInfo.PostStream);

    // Log Request
    if DebugMode then
      AppendStringsToFile(Request, gDiagnoseFName, 'Request');

    // parse Input
    inParam := parse(Request);

    if DebugMode then
      AppendStringsToFile(inParam, gDiagnoseFName, 'inParam');

    // extract the method-Name
    n := inParam.IndexOfObject(oMethodName);
    if (n = -1) then
    begin
      AResponseInfo.ContentText := bad_xml(-100, 'Kein Methodenname im XML angegeben');
      break;
    end;
    MethodName := inParam[n];

    // Prefix-Namespace abtrennen
    n := revpos(cXML_NameSpaceDelimiter, MethodName);
    if (n > 0) then
      Name := copy(MethodName, succ(n), MaxInt)
    else
      Name := MethodName;

    // find the Method in local List
    n := sMethodNames.IndexOf(Name);
    if (n = -1) then
    begin
      AResponseInfo.ContentText := bad_xml(-101, 'Methode "' + Name + '" (' + MethodName +
        ') ist unbekannt');
      break;
    end;

    // Enter critical Section
    callSection.enter;
    try
      if TimingStats then
      begin
        // Save Begin
        StartTime := RDTSCms;

        // Call the Method
        OutParam := mMethodAddr[n](inParam);

        // Log Duration
        AppendStringsToFile(
          { } HugeSingleLine(inParam, ',') +
          { } ':' +
          { } IntToStr(RDTSCms - StartTime) +
          { } 'ms',
          { } gDiagnoseFName);

      end
      else
      begin

        // Call the Method
        OutParam := mMethodAddr[n](inParam);

      end;

      // Inc Call-Count Statistics
      inc(Stat_Calls);

    except
      on e: Exception do
      begin
        inc(Stat_Exceptions);
        WasError := true;

        // Log ERROR
        if (gDiagnoseFName <> '') then
        begin
          ErrorMsg := TStringList.Create;
          ErrorMsg.Add(cERRORText + ' XML-RPC: { Exception ');
          ErrorMsg.Add(DatumLog + ' ' + Uhr8);
          ErrorMsg.Add(Name + '(' + HugeSingleLine(inParam, ',') + ') :');
          ErrorMsg.Add(e.message + '}');
          AppendStringsToFile(ErrorMsg, gDiagnoseFName);
          ErrorMsg.free;
        end;

        // Send ERROR to Client
        AResponseInfo.ContentText := bad_xml(-102, Name + '(' + HugeSingleLine(inParam, ',') +
          ') Exception: ' + e.message);
      end;
    end;
    callSection.Leave;

    if not(WasError) then
    begin

      // Convert Answer to XML-Struct
      if assigned(OutParam) then
        for n := 0 to pred(OutParam.Count) do
        begin
          case Integer(OutParam.objects[n]) of
            cXML_SimpleType_Integer:
              OutParam[n] := QuoteInteger(OutParam[n]);
            cXML_SimpleType_Double:
              OutParam[n] := QuoteDouble(OutParam[n]);
            cXML_SimpleType_DateTime:
              OutParam[n] := QuoteDateTime(OutParam[n]);
            cXML_SimpleType_Boolean:
              OutParam[n] := QuoteBoolean(OutParam[n]);
            cXML_SimpleType_BeginArray:
              OutParam[n] := QuoteBeginArray;
            cXML_SimpleType_EndArray:
              OutParam[n] := QuoteEndArray;
            cXML_SimpleType_MetaString:
              OutParam[n] := QuoteMetaString(OutParam[n]);
          else
            OutParam[n] := QuoteString(OutParam[n]);
          end;
        end;

      // Add XML-Envelop, OutParam may be Nil
      AResponseInfo.ContentText := good_xml(OutParam);
    end;

    if assigned(OutParam) then
      OutParam.free;

  until yet;

  if DebugMode then
    AppendStringsToFile(AResponseInfo.ContentText, gDiagnoseFName, 'Response');

  inParam.free;
end;

{ TFeedbackHelper }

class function TFeedbackHelper.Progress(Position: Integer; Name: string; Maximum: Integer)
  : TStringList;
begin
  result := TStringList.Create;
  with result do
  begin
    Add(cFeedback_Progress);
    Add(Name);
    Add(IntToStr(Maximum));
    Add(IntToStr(Position));
  end;
end;

class function TFeedbackHelper.ShowMessage(Msg: string): TStringList;
begin
  result := TStringList.Create;
  with result do
  begin
    Add(cFeedBack_Message);
    Add(Msg);
  end;
end;

// call a remote XML RPC

function remote_exec(
 {} Host:string;Port:integer;
 {} Method:string;Parameter:TStringList = nil; NameSpace: string = 'abu'):TStringList;
var
 cXMLRPC : TIdHTTP;
 XML : TStringList;
 RequestContent: TMemoryStream;
 ResponseContent : TMemoryStream;
 n : integer;
 Parameters: boolean;
begin
  result := TStringList.Create;

  // do we have parameters
  Parameters := false;
  repeat
   if (Parameter=nil) then
    break;
   if (Parameter.Count=0) then
    break;
   Parameters := true;
  until yet;

  // generate the XML
  XML := TStringList.Create;
  with XML do
  begin
    add('<?xml version="1.0"?>');
    if Parameters then
    begin
     add('<methodCall><methodName>' + NameSpace + '.' + Method + '</methodName><params>');
     addStrings(TXMLRPC_Server.QuoteParams(Parameter));
     add('</params></methodCall>');
    end else
    begin
     add('<methodCall><methodName>' + NameSpace + '.' + Method + '</methodName></methodCall>')
    end;
  end;

  RequestContent := TMemoryStream.Create;
  XML.SaveToStream(RequestContent);

  ResponseContent:= TMemoryStream.create;
  cXMLRPC := TIdHTTP.create(nil);
  with cXMLRPC do
  begin
    Request.ContentType := 'text/xml';
    Request.CharSet := 'ISO-8859-1';     // Dokumentation sagt, XMLRPC wäre ANSI
    Request.UserAgent := 'srvXMLRPC.pas';
    Post('http://'+Host+':'+IntToStr(Port),RequestContent,ResponseContent);
    ResponseContent.Position := 0;
    result.LoadFromStream(ResponseContent{$ifndef FPC},TEncoding.ANSI{$endif}); // Dokumentation sagt, XMLRPC wäre ANSI
  end;
  ResponseContent.Free;
  RequestContent.Free;
  XML.free;
  cXMLRPC.Free;

  // parse result
  for n := pred(result.Count) downto 0 do
  begin
   repeat
    if (pos('<value><string>',result[n])<>0) then
    begin
     result[n] := ExtractSegmentBetween(result[n],'<value><string>','</string></value>');
     result.Objects[n] := TXMLRPC_Server.oString;
     break;
    end;
    if (pos('<value><int>',result[n])<>0) then
    begin
     result[n] := ExtractSegmentBetween(result[n],'<value><int>','</int></value>');
     result.Objects[n] := TXMLRPC_Server.oInteger;
     break;
    end;
    if (pos('<value><boolean>',result[n])<>0) then
    begin
     result[n] := ExtractSegmentBetween(result[n],'<value><boolean>','</boolean></value>');
     result.Objects[n] := TXMLRPC_Server.oBoolean;
     break;
    end;
    // imp pend: ein vollumfänglicher Ergebnis-Parser
    //  oDouble
    //  oDateTime
    result.Delete(n)
   until yet;
  end;
end;

// R E S T

function REST(request: string; Attachment: string = ''; ForceRAW : boolean = false) : TStringList;
var
  httpC: TIdHTTP;
  ResponseStream: TMemoryStream;
  MultiPartFormDataStream: TIdMultiPartFormDataStream;
begin
  REST_ETAG := '';
  result := TStringList.Create;

  httpC := TIdHTTP.Create(nil);
  ResponseStream := TMemoryStream.Create;
  MultiPartFormDataStream := TIdMultiPartFormDataStream.Create;
  try
    if (Attachment<>'') then
    begin
      MultiPartFormDataStream.AddFile('Datei', Attachment, 'text/plain');
      httpC.request.ContentType := MultiPartFormDataStream.RequestContentType;
      httpC.Post(request, MultiPartFormDataStream, ResponseStream);
    end else
    begin
      httpC.get(AnsiToRFC1738(request), ResponseStream);
    end;

    if (httpC.ResponseCode = 200) then
    begin
      // Ermittlung der Verarbeitungs-TAN
      REST_ETAG := ExtractSegmentBetween(
        {} httpC.Response.RawHeaders.Values['ETag'],
        {} '"', '"');

      ResponseStream.Position := 0;
      repeat

         // Unsure about char-set
         if ForceRAW or (LowerCase(httpc.response.charset)='none') then
         begin
          result.LoadFromStream(ResponseStream,TEncoding.ASCII);
          break;
         end;

         // Unicode
         if (LowerCase(httpc.response.charset)='utf-8') then
         begin
           result.LoadFromStream(ResponseStream,Tencoding.UTF8);
           break;
         end;

         // default is Ansi
         result.LoadFromStream(ResponseStream,Tencoding.ANSI);

      until yet;
    end
    else
    begin
      result.add(cERRORText + ' REST(' + request + '): ' + inttostr
          (httpC.ResponseCode) + ' (' + httpC.ResponseText + ')');
    end;
  except
    on E: Exception do
    begin
      result.add(cERRORText + ' REST(' + request + '): ' + E.Message);
    end;
  end;
//  AppendStringsToFile('Request: "' + request + '":', LogFName);
//  AppendStringsToFile(result, LogFName);
  MultiPartFormDataStream.free;
  ResponseStream.free;
  httpC.free;
end;

end.
