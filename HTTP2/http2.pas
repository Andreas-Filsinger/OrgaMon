{
|     _   _   _____   _____   ____       __  ____
|    | | | | |_   _| |_   _| |  _ \     / / |___ \
|    | |_| |   | |     | |   | |_) |   / /    __) |
|    |  _  |   | |     | |   |  __/   / /    / __/
|    |_| |_|   |_|     |_|   |_|     /_/    |_____|
|
|    HTTP/2 (as described in RFC 7540)
|
|    (c) 2017 Andreas Filsinger
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
unit HTTP2;

{$ifdef FPC}
{$mode objfpc}{$H+}
{$endif}

interface


uses
 {$ifdef FPC}
  cTypes,
  ssockets,
 {$endif}
  cryptossl,
  Classes,
  SysUtils;

const
{$ifdef FPC}
  {$ifdef linux}
  client_socket : TUnixServer = nil;
  {$else}
  client_socket : TInetServer = nil;
  {$endif}
{$endif}
  OpenSSL_Error : string = '';
  Path: string= '';

function getSocket: cint;
procedure TLS_Bind(FD: cint);
procedure TLS_Init;

const
  ReadBufLen = 4096;

type
  THttpsServer = class;
  TRequestErrorHandler = procedure (Sender : TObject; E : Exception) of object;

  THttpsConnection = class(TObject)
  private
    FOnError: TRequestErrorHandler;
    FServer: THttpsServer;
    FSocket: TSocketStream;
    FBuffer: Ansistring;

{ TODO 3 -oUdo -cTHttpsConnection : use the following  Properties }
    FProtocol: string;
    FMethod: string;
    FUrl: string;
    FResponseCode: integer;
    FResponseText: string;

    FRequestHeaders: TStringList;
{ TODO 3 -oUdo -cTHttpsConnection : use TStream }
    FRequestContent: string;
    FResponseHeaders: TStringList;
{ TODO 3 -oUdo -cTHttpsConnection : use TStream }
    FResponseContent: string;
    procedure ReadRequestHeaders;
  protected
    procedure ReadRequestContent(ALength: integer); virtual;
    procedure HandleRequestError(E: Exception); virtual;
    procedure SetupSocket; virtual;
  public
    constructor Create(AServer: THttpsServer; ASocket : TSocketStream);
    destructor Destroy; override;
    procedure HandleRequest; virtual;
    property Socket: TSocketStream read FSocket;
    property Server: THttpsServer read FServer;
    property OnRequestError : TRequestErrorHandler read FOnError write FOnError;
    property Protocol: string read FProtocol;
    property Method: string read FMethod;
    property Url: string read FUrl;
    property ResponseCode: integer read FResponseCode write FResponseCode;
    property ResponseText: string read FResponseText write FResponseText;
    property RequestHeaders: TStringList read FRequestHeaders;
    property RequestContent: string read FRequestContent;
    property ResponseHeaders: TStringList read FResponseHeaders write FResponseHeaders;
    property ResponseContent: string read FResponseContent write FResponseContent;
  end;

  THttpsServerRequestHandler = procedure (Sender: TObject;
    var AHttpsConnection: THttpsConnection) of object;

  THttpsServer = class(TComponent)
  private
    FOnAllowConnect: TConnectQuery;
    FOnRequest: THttpsServerRequestHandler;
    FOnRequestError: TRequestErrorHandler;
    FServer : TInetServer;
    FLoadActivate : Boolean;
    FConnectionCount : Integer;
    FHandler: TSocketHandler;
    function GetActive: Boolean;
    procedure SetActive(const AValue: Boolean);
    procedure SetOnAllowConnect(const AValue: TConnectQuery);
    procedure WaitForRequests;
  protected
    // Called on accept errors
    procedure DoAcceptError(Sender: TObject; ASocket: Longint; E: Exception;  var ErrorAction: TAcceptErrorAction);
    // Create a connection handling object.
    function CreateConnection(Data : TSocketStream) : THttpsConnection; virtual;
    // Called by TInetServer when a new connection is accepted.
    procedure DoConnect(Sender : TObject; Data : TSocketStream); virtual;
    // Create and configure TInetServer
    procedure CreateServerSocket; virtual;
    // free server socket instance
    procedure FreeServerSocket; virtual;
    // Handle request. This calls OnRequest. It can be overridden by descendants to provide standard handling.
    procedure HandleRequest(var AHttpsConnection: THttpsConnection); virtual;
    // Called when a connection encounters an unexpected error. Will call OnRequestError when set.
    procedure HandleRequestError(Sender: TObject; E: Exception); virtual;
    // Connection count
    property ConnectionCount : Integer Read FConnectionCount;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
  published
    // Set to true to start listening.
    property Active : boolean read GetActive write SetActive default false;
    // Called when deciding whether to accept a connection.
    property OnAllowConnect : TConnectQuery read FOnAllowConnect write SetOnAllowConnect;
    // Called to handle the request. If Threaded=True, it is called in a the connection thread.
    property OnRequest : THttpsServerRequestHandler read FOnRequest write FOnRequest;
    // Called when an unexpected error occurs during handling of the request. Sender is the TFPHTTPConnection.
    property OnRequestError : TRequestErrorHandler read FOnRequestError write FOnRequestError;
  end;


resourcestring
  SErrSocketActive =  'Operation not allowed while server is active';
  SErrReadingSocket = 'Error reading data from the socket';

implementation

  {$ifdef FPC}
uses
  systemd,
  HMUX,
  sockets
  ,sslsockets, fpopenssl, openssl;
  {$endif}


// Knowledge Base
// fpopenssl
// http2_openssl.pas
// socketssl



{$REGION ' - TFPHTTPConnection - '}
procedure THttpsConnection.ReadRequestHeaders;
  procedure FillBuffer;
  var i: integer;
  begin
    SetLength(FBuffer, ReadBufLen);
    i := FSocket.Read(FBuffer[1], ReadBufLen);
    if i<0 then
      raise Exception.Create(SErrReadingSocket);
    if (i < ReadBuflen) then
      SetLength(FBuffer, i);
  end;
var
  CheckLF,Done: boolean;
  P,L: integer;
  s: string;
begin
  repeat
    s := '';
    Done := false;
    CheckLF := false;
    { TODO 3 -oUdo -cTHttpsConnection : HPack decode}
    repeat
      if Length(FBuffer)=0 then
        FillBuffer;
      if Length(FBuffer)=0 then
        Done := true
      else if CheckLF then
      begin
        if (FBuffer[1]<>#10) then
          s := s+#13
        else
        begin
          Delete(FBuffer, 1, 1);
          Done := true;
        end;
        CheckLF := false;
      end;
      if not Done then
      begin
        P := Pos(#13#10, FBuffer);
        if P = 0 then
        begin
          L := Length(FBuffer);
          CheckLF := FBuffer[L] = #13;
          if CheckLF then
            s := s + Copy(FBuffer, 1, L-1)
          else
            s := s + FBuffer;
          FBuffer := '';
        end
        else
        begin
          s := s + Copy(FBuffer, 1, P-1);
          Delete(FBuffer, 1, P+1);
          Done := true;
        end;
      end;
    until Done;
    if s <> '' then
      { TODO 3 -oUdo -cTHttpsConnection : split first header line into protocol, method and url }
      FRequestHeaders.Add(s);
  until (s='');
end;

procedure THttpsConnection.HandleRequestError(E: Exception);
begin
  If Assigned(FOnError) then
    try
      FOnError(Self,E);
    except
      // We really cannot handle this...
    end;
end;

procedure THttpsConnection.SetupSocket;
begin
{$if defined(FreeBSD) or defined(Linux)}
  FSocket.ReadFlags:=MSG_NOSIGNAL;
  FSocket.WriteFlags:=MSG_NOSIGNAL;
{$endif}
end;

procedure THttpsConnection.ReadRequestContent(ALength: integer);
var P, R : integer;
begin
  if (ALength>0) then
  begin
    SetLength(FRequestContent, ALength);
    P := Length(FBuffer);
    if (P>0) then
    begin
      Move(FBuffer[1], FRequestContent[1], P);
      ALength := ALength - P;
    end;
    P := P + 1;
    R := 1;
    while (ALength<>0) and (R>0) do
    begin
      R := FSocket.Read(FRequestContent[p], ALength);
      if R<0 then
        raise Exception.Create(SErrReadingSocket);
      if (R>0) then
      begin
        P := P + R;
        ALength := ALength - R;
      end;
    end;
  end;
end;

constructor THttpsConnection.Create(AServer: THttpsServer; ASocket: TSocketStream);
begin
  FSocket := ASocket;
  FServer := AServer;
  If Assigned(FServer) then
    InterLockedIncrement(FServer.FConnectionCount)
end;

destructor THttpsConnection.Destroy;
begin
  if Assigned(FServer) then
    InterLockedDecrement(FServer.FConnectionCount);
  FreeAndNil(FSocket);
  Inherited;
end;

procedure THttpsConnection.HandleRequest;
var
  s, sx: string;
  i, code: integer;
begin
  try
    SetupSocket;
    // read request headers.
    FRequestHeaders := TStringList.Create;
    try
      FRequestHeaders.Delimiter := ':';
      ReadRequestHeaders();
      // read content, if any
      if FRequestHeaders.Values['Content-Length'] <> '' then
      begin
        val(trim(FRequestHeaders.Values['Content-Length']), i, code);
        ReadRequestContent(i);
      end;

      // create response
      FResponseHeaders := TStringList.Create;
      try
        FResponseHeaders.Delimiter := ':';
        FResponseContent := '';
        // And dispatch
        if Server.Active then
          Server.HandleRequest(Self);
        sx := FResponseContent;
        s := '';
        { TODO 3 -oUdo -cTHttpsConnection : merge first header line from protocol, code and text }
        for i := 0 to FResponseHeaders.Count-1 do
          { TODO 3 -oUdo -cTHttpsConnection : HPack Encode}
          s := s + FResponseHeaders.Strings[i] + #13#10;
        s := s + 'Content-Length: ' + IntToStr(length(sx)) + #13#10#13#10;
        FSocket.Write(s[1], length(s));
        FSocket.Write(sx[1], length(sx));
      finally
        FreeAndNil(FResponseHeaders);
      end;
    finally
      FreeAndNil(FRequestHeaders);
    end;
  except
    on E : Exception do
      HandleRequestError(E);
  end;
end;
{$ENDREGION}

{$REGION ' - THttpsServer - '}
procedure THttpsServer.HandleRequestError(Sender: TObject; E: Exception);
begin
  If Assigned(FOnRequestError) then
    try
      FOnRequestError(Sender, E);
    except
      // Do not let errors in user code escape.
    end
end;

procedure THttpsServer.DoAcceptError(Sender: TObject; ASocket: Longint;
  E: Exception; var ErrorAction: TAcceptErrorAction);
begin
  If Not Active then
    ErrorAction := AEAStop
  else
    ErrorAction := AEARaise
end;

function THttpsServer.GetActive: Boolean;
begin
  if (csDesigning in ComponentState) then
    result := FLoadActivate
  else
    result := Assigned(FServer);
end;

procedure THttpsServer.SetActive(const AValue: Boolean);
begin
  if AValue = GetActive then exit;
  FLoadActivate := AValue;
  if not (csDesigning in Componentstate) then
    if AValue then
    begin
      CreateServerSocket;
      FServer.QueueSize := 5;
      FServer.ReuseAddress := true;
      FServer.Bind;
      FServer.Listen;
      FServer.StartAccepting;
      FreeServerSocket;
    end
    else
      FServer.StopAccepting(False);
end;

procedure THttpsServer.SetOnAllowConnect(const AValue: TConnectQuery);
begin
  if FOnAllowConnect = AValue then exit;
  if GetActive then
    raise Exception.Create(SErrSocketActive);
  FOnAllowConnect := AValue;
end;

function THttpsServer.CreateConnection(Data: TSocketStream): THttpsConnection;
begin
  result := THttpsConnection.Create(Self,Data);
end;

procedure THttpsServer.DoConnect(Sender: TObject; Data: TSocketStream);
var Con : THttpsConnection;
begin
  Con := CreateConnection(Data);
  try
    Con.FServer := Self;
    Con.OnRequestError := @HandleRequestError;
    Con.HandleRequest;
  finally
    Con.Free;
  end;
end;

procedure THttpsServer.CreateServerSocket;
begin
{ TODO 1 -oUdo -cTHttpsSocketHandler : write socket handler based on openssl v1.1 }
  FHandler := TSSLSocketHandler.Create;
  (FHandler as TSSLSocketHandler).SSLType := stTLSv1_2;
  { TODO 1 -oUdo -cTHttpsSocketHandler : change local path to cert storage path }
  (FHandler as TSSLSocketHandler).Certificate.FileName := ExtractFilePath(ParamStr(0)) + 'cert.pem';
  (FHandler as TSSLSocketHandler).PrivateKey.FileName := ExtractFilePath(ParamStr(0)) + 'key.pem';
  //(FHandler as TSSLSocketHandler).CertCA.FileName := ExtractFilePath(ParamStr(0)) + 'CertCa.pem';
  // add all SSL settings to FHandler
  FServer := TInetServer.Create('0.0.0.0', 443, FHandler);
  FServer.MaxConnections := 1;
  FServer.OnConnectQuery := OnAllowConnect;
  FServer.OnConnect := @DoConnect;
  FServer.OnAcceptError := @DoAcceptError;
  FServer.AcceptIdleTimeOut := 1000;
end;

procedure THttpsServer.FreeServerSocket;
begin
  FreeAndNil(FServer);
end;

procedure THttpsServer.HandleRequest(var AHttpsConnection: THttpsConnection);
begin
  If Assigned(FOnRequest) then
    FonRequest(Self, AHttpsConnection);
end;

constructor THttpsServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure THttpsServer.WaitForRequests;
var FLastCount, ACount: integer;
begin
  ACount := 0;
  FLastCount := FConnectionCount;
  while (FConnectionCount > 0) and (ACount < 10) do
  begin
    Sleep(100);
    if (FConnectionCount = FLastCount) then
      Dec(ACount)
    else
      FLastCount := FConnectionCount;
  end;
end;

destructor THttpsServer.Destroy;
begin
  Active := false;
{$ifdef USE_multithreading}
  if (FConnectionCount>0) then
    WaitForRequests;
{$endif}
  inherited Destroy;
end;
{$ENDREGION}


// create a Parameter Context for a TLS 1.2 Server Connection
// intended for a "HTTPS://" Server Socket

var
 p : array[0..4096] of AnsiChar;


function StrictHTTP2Context: PSSL_CTX;
begin

//
 METH := TLSv1_2_server_method();

 CTX := SSL_CTX_new(METH);

 SSL_CTX_set_info_callback(CTX,@cb_info);
 SSL_CTX_ctrl(Result, SSL_CTRL_SET_ECDH_AUTO, 1, nil);
 SSL_CTX_callback_ctrl(CTX,SSL_CTRL_SET_TLSEXT_SERVERNAME_CB,@cb_SERVERNAME);

 StrPCopy(p,Path + 'key.pem');
 if (SSL_CTX_use_PrivateKey_file(CTX, PChar(@p), SSL_FILETYPE_PEM) <> 1) then
   raise Exception.Create('Register key.pem fails');

  StrPCopy(p,Path + 'cert.pem');
  if (SSL_CTX_use_certificate_file(CTX, PChar(@p), SSL_FILETYPE_PEM) <> 1) then
    raise Exception.Create('Register cert.pem fails');

 // ev. die Paarung cert+key gegeneinander prüfen
 //  SSL_CTX_check_private_key()

 result := CTX;
  if not(assigned(result)) then
    raise Exception.Create('Create a new SSL-Context fails');

end;

// binds a HANDLE (comes from systemd, or from incoming socket) to a new SLL Connection

procedure TLS_Bind(FD: cint);
var
  ssl: PSSL;
  Buf: array[0..4096] of byte;
  a,e : cInt;
//  ErrStr : array[0..4096] of char;
P : PChar;
x : AnsiString;
ERR_F : THandle;
begin

  // SSL Init
  ssl := SSL_new(CTX);
  if not(assigned(ssl)) then
    raise Exception.create('SSL_new() fails');

  // SSL File Handle Übernahme
  if (SSL_set_fd(ssl, FD)<>1) then
   raise Exception.create('SSL_set_fd() fails');

  //
  a := SSL_accept(ssl);
  case a of
    0:begin

    end;
    1: begin

    end;
  else

  end;

  if (a <= 0) then
  begin
    sDebug.add(SSL_ERROR[SSL_get_error(SSL,a)]);
    ERR_print_errors_cb(@cb_ERR,nil);

  //             ERR_F := FileCreate( Path+'OpenSSL.log');
  // ERR_print_errors_fp(ERR_F);
//      FileClose(ERR_F);
  end;
  {
  buf += Header;
  buf += Content;
  stack();
  stack();
  SSLwrite(ssl, @Buf, 16);
   }

end;

// Im Rang 1: socket von systemd erhalten: // http://0pointer.de/blog/projects/socket-activation.html
// Im Rang 2: selbst ein Socket öffnen und auf Verbindungsversuche von aussen warten

function getSocket: cint;
var
 SAddr    : TInetSockAddr;
 CAddr    : TInetSockAddr;
 len :    cint;
 ListenSocket, ConnectionSocket : cint;
begin
  {$ifdef FPC}
  // try systemd
  sd_notify(0, 'READY=1\nSTATUS=Ready\n');
  Result := sd_listen_fds(0);

  if (Result > 1) then
  begin
    raise Exception.Create('Too many file descriptors received');
  end
  else
  begin

    if (Result = 1) then
    begin
      // success via "systemd", result is a "symbolic" handle
      // with a fixed value (3)
      Result := SD_LISTEN_FDS_START;
    end
    else
    begin
       // Open via a SOCKET!

       ListenSocket:=fpSocket (AF_INET,SOCK_STREAM,0);
       if SocketError<>0 then
        raise Exception.Create('Server : Socket : ');
       SAddr.sin_family:=AF_INET;
       SAddr.sin_port:=htons(443);
       SAddr.sin_addr.s_addr:=INADDR_ANY;
       len := sizeof(SAddr);
       if fpBind(ListenSocket,@SAddr,sizeof(saddr))=-1 then
        raise Exception.Create ('Server : Bind : ');
       if fpListen (ListenSocket,1)=-1 then
        raise Exception.Create ('Server : Listen : ');

       ConnectionSocket := fpAccept(ListenSocket,@CAddr,@len);
       if (ConnectionSocket=-1) then
        raise Exception.Create ('Server : Accept : ');

       sDebug.add(NetAddrToStr(CAddr.sin_addr));

       result := ConnectionSocket;

           (*
       // OPen via inetServer
   {$ifdef linux}
      client_socket := TUnixServer.Create('0.0.0.0:443');
   {$else}
      client_socket := TInetServer.Create('0.0.0.0', 443);
   {$endif}

      with client_socket do
      begin
        // Parameter?
        SetNonBlocking;
        KeepAlive := true;

        // Bind to Interface
        StartAccepting;

        // Make no further actions, let SSL take over
        Result := Socket;

      end;
      *)
    end;
  end;
  {$endif}
end;

procedure TLS_Init;
begin

  Path := 'R:\GIT\OrgaMon\HTTP2\';

  CTX := StrictHTTP2Context;

if not(assigned(CTX))  then
  raise Exception.Create('SSL Init Fail');

//ERR_load_crypto_strings;
//OpenSSL_Version  := SSLeayversion(0);

end;

procedure Release;
begin
  (*
  SSLfree(ssl);
    close(client);
    close(sock);
    SSL_CTX_free(ctx);
    cleanup_openssl();
   *)
end;


end.
