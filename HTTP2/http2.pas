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

{$mode objfpc}{$H+}
{$modeswitch advancedrecords}

interface

uses
  cTypes,
  cryptossl,
  Classes,
  SysUtils;

const
  OpenSSL_Error : string = '';

function getSocket: cint;
procedure TLS_Init;
procedure TLS_Accept(FD: cint);

implementation

uses
 sockets,
 systemd,
 HMUX;

// Knowledge Base
//  fpopenssl
//  http2_openssl.pas
//  socketssl


// create a Parameter Context for a TLS 1.2 Server Connection
// intended for a "HTTPS://" Server Socket




function StrictHTTP2Context: PSSL_CTX;
begin

 // setup a TLS 1.2 Context
 // RFC 7540-9.2.
 cs_METH := TLSv1_2_server_method();
 cs_CTX := SSL_CTX_new(cs_METH);

 SSL_CTX_set_info_callback(cs_CTX,@cb_info);
 SSL_CTX_ctrl(cs_CTX, SSL_CTRL_SET_ECDH_AUTO, 1, nil);

 (*
 if (SSL_CTX_set_cipher_list(cs_CTX, 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH')<>1) then
  raise Exception.Create('set TLS 1.2 Cipher fails');
  SSL_CTX_set_options(cs_CTX, SSL_OP_CIPHER_SERVER_PREFERENCE);

 *)

 // Register a Callback for: "SNI" read Identity Client expects
 SSL_CTX_callback_ctrl(cs_CTX,SSL_CTRL_SET_TLSEXT_SERVERNAME_CB,@cb_SERVERNAME);

 // Register a Callback for: "ALPN" Select "h2" Protocol
 SSL_CTX_set_alpn_select_cb(cs_CTX,@cb_ALPN,nil);

 result := cs_CTX;
  if not(assigned(result)) then
    raise Exception.Create('Create a new SSL-Context fails');

end;

// binds a HANDLE (comes from systemd, or from incoming socket) to a new SLL Connection

procedure TLS_Accept(FD: cint);
var
  a,e : cInt;
//  ErrStr : array[0..4096] of char;
P : PChar;
x : AnsiString;
ERR_F : THandle;

// initial Read
buf : array[0..pred(16*1024)] of byte;

BytesPending: cint;
BytesHasPending: cint;
BytesRead: cint;
   DD: string;
   DC : string;
   n: Integer;
begin

  // SSL Init
  cs_SSL := SSL_new(cs_CTX);
  if not(assigned(cs_SSL)) then
    raise Exception.create('SSL_new() fails');

  // SSL File Handle Übernahme
  if (SSL_set_fd(cs_SSL, FD)<>1) then
   raise Exception.create('SSL_set_fd() fails');

  //
  a := SSL_accept(cs_SSL);
  if (a<>1) then
  begin
    sDebug.add(SSL_ERROR[SSL_get_error(cs_SSL,a)]);
    ERR_print_errors_cb(@cb_ERR,nil);
    raise Exception.create('SSL_accept() fails');
  end else
  begin
   sDebug.add('connection with "' + SSL_get_version(cs_SSL) + '"-secured established');
   // imp pend: SSL_get_chiper(cs_SSL) name des Chipers ausgeben
      (*
   BytesRead := SSL_read(cs_SSL,nil,0);

   BytesPending := SSL_pending(cs_SSL);
   sDebug.add('we have contact with '+IntTostr(BytesPending)+' pending Bytes of Hello-Code!');

   BytesHasPending:= SSL_has_pending(cs_SSL);
   sDebug.add('we have contact with '+IntTostr(BytesHasPending)+' has_pending Bytes of Hello-Code!');
        *)

   sDebug.add('read ...');
   BytesRead := SSL_read(cs_SSL,@buf,sizeof(buf));

   sDebug.add('we have contact with '+IntTOStr(BytesRead)+' Bytes of Hello-Code!');

   DD := '';
   DC := '';
   for n := 0 to pred(BytesRead) do
   begin
     DD := DD + ' ' + IntToHex(buf[n],2);
     if (buf[n]>=ord(' ')) and (buf[n]<=ord('z')) then
      DC := DC + chr(buf[n])
     else
      DC := DC + '.';
     if (n MOD 16=15) then
     begin
      sDebug.add(DD+'  '+DC);
      DD := '';
      DC := '';
     end;
   end;
   if (DD<>'') then
    sDebug.add(DD+'  '+DC);

   if (BytesRead>0) then
   begin
    CN_SIze := BytesRead;
    move(Buf, ClientNoise, CN_Size);
    CN_Pos := 0;
    Parse;
   end;
  end;
end;

// Im Rang 1: socket von systemd erhalten: // http://0pointer.de/blog/projects/socket-activation.html
// Im Rang 2: selbst ein Socket öffnen und auf Verbindungsversuche von aussen warten

function getSocket: cint;
var
 ServerAddr    : TInetSockAddr;
 ClientAddr    : TInetSockAddr;
 len :    cint;
 ListenSocket, ConnectionSocket : cint;
 Flag: Longint;
begin
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

       // create a Handle
       ListenSocket:=fpSocket (AF_INET,SOCK_STREAM,0);
       if SocketError<>0 then
        raise Exception.Create('Server : Socket : ');

       // set usefull options
       Flag := 1;
       if fpsetsockopt(ListenSocket, IPPROTO_TCP, TCP_NODELAY, @flag, sizeof(LongInt))<0 then
        raise Exception.Create('Server: Socket: can not set TCP_NODELAY ');

       // FpFcntl(ListenSocket, F_SetFl, FpFcntl(ListenSocket, F_GetFl) or O_NONBLOCK);


       // bind to interface
       with ServerAddr do
       begin
         sin_family:=AF_INET;
         sin_port:=htons(443);
         sin_addr.s_addr:=INADDR_ANY;
       end;
       len := sizeof(ServerAddr);
       if fpBind(ListenSocket,@ServerAddr,sizeof(ServerAddr))=-1 then
        raise Exception.Create ('Server : Bind : ');
       if fpListen (ListenSocket,1)=-1 then
        raise Exception.Create ('Server : Listen : ');

       ConnectionSocket := fpAccept(ListenSocket,@ClientAddr,@len);
       if (ConnectionSocket=-1) then
        raise Exception.Create ('Server : Accept : ');

       sDebug.add(NetAddrToStr(ClientAddr.sin_addr));

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
end;

procedure TLS_Init;
begin
 cs_CTX := StrictHTTP2Context;
 if not(assigned(cs_CTX))  then
   raise Exception.Create('SSL Init Fail');
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
