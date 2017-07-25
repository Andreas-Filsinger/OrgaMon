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
 {$endif}
  cryptossl,
  Classes,
  SysUtils;

const
  OpenSSL_Error : string = '';

function getSocket: cint;
procedure TLS_Bind(FD: cint);
procedure TLS_Init;

implementation

{$ifdef FPC}
uses
 sockets,
 systemd,
 HMUX;
{$endif}

// Knowledge Base
//  fpopenssl
//  http2_openssl.pas
//  socketssl


// create a Parameter Context for a TLS 1.2 Server Connection
// intended for a "HTTPS://" Server Socket




function StrictHTTP2Context: PSSL_CTX;
begin

//
 cs_METH := TLSv1_2_server_method();
 cs_CTX := SSL_CTX_new(cs_METH);

 SSL_CTX_set_info_callback(cs_CTX,@cb_info);
 SSL_CTX_ctrl(cs_CTX, SSL_CTRL_SET_ECDH_AUTO, 1, nil);
 SSL_CTX_callback_ctrl(cs_CTX,SSL_CTRL_SET_TLSEXT_SERVERNAME_CB,@cb_SERVERNAME);

 if (SSL_CTX_set_cipher_list(cs_CTX, 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH')<>1) then
  raise Exception.Create('set TLS 1.2 Cipher fails');

 SSL_CTX_set_options(cs_CTX, SSL_OP_CIPHER_SERVER_PREFERENCE);

 result := cs_CTX;
  if not(assigned(result)) then
    raise Exception.Create('Create a new SSL-Context fails');

end;

// binds a HANDLE (comes from systemd, or from incoming socket) to a new SLL Connection

procedure TLS_Bind(FD: cint);
var
  Buf: array[0..4096] of byte;
  a,e : cInt;
//  ErrStr : array[0..4096] of char;
P : PChar;
x : AnsiString;
ERR_F : THandle;
begin

  // SSL Init
  cs_SSL := SSL_new(cs_CTX);
  if not(assigned(cs_SSL)) then
    raise Exception.create('SSL_new() fails');

  // SSL File Handle Übernahme
  if (SSL_set_fd(cs_SSL, FD)<>1) then
  raise Exception.create('SSL_set_fd() fails');

  //
  if (SSL_accept(cs_SSL)<>1) then
  begin
    sDebug.add(SSL_ERROR[SSL_get_error(cs_SSL,a)]);
    ERR_print_errors_cb(@cb_ERR,nil);
    raise Exception.create('SSL_accept() fails');
  end else
  begin


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
  {$endif}
end;

procedure TLS_Init;
begin

  pem_Path := 'R:\srv\hosts\';

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
