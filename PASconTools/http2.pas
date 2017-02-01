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

interface

uses
  Classes, SysUtils;

implementation

uses
  systemd, openssl, HMUX;

// just simple hack wait for new "openssl"

const
 SSL_CTRL_SET_ECDH_AUTO                      = 94;


 function SslMethodTLSV1_2:PSSL_METHOD;
 begin
   result := openssl.SslMethodV23;
 end;

 // end hacks


// create a Parameter Context for a TLS 1.2 Server Connection
// intended for a "HTTPS://" Server Socket

function StrictHTTP2Context : PSSL_CTX;
begin

  if not(InitSSLInterface) then
   Raise Exception.Create('SSL Init Fail');

  result := SslCtxNew(SslMethodTLSV1_2);

  SslCTXCtrl(result,SSL_CTRL_SET_ECDH_AUTO,1,nil);

  if (SslCtxUseCertificateFile(result, 'cert.pem', SSL_FILETYPE_PEM) < 0) then
  Raise Exception.Create('Register cert.pem fails');


  if (SslCtxUsePrivateKeyFile(result, 'key.pem', SSL_FILETYPE_PEM) < 0 ) then
   Raise Exception.Create('Register key.pem fails');

end;

// binds a HANDLE (comes from systemd, or from incoming socket) to a new SLL Connection

procedure TLS_Bind (H : Integer);
var
 ssl : PSSL;
 Buf: array[0..4096] of byte;
begin

  ssl := sslNew(StrictHTTP2Context);
  sslSetFD(ssl, H);

  if (sslAccept(ssl)<=0) then
   Raise Exception.Create('ssl Accept fail');

  (*
  buf += Header;
  buf += Content;
  stack();
  stack();
    *)

  SSLwrite(ssl, @Buf, 16);




end;

// Im Rang 1: socket von systemd erhalten: // http://0pointer.de/blog/projects/socket-activation.html
// Im Rang 2: selbst ein Socket öffnen und auf Verbindungsversuche warten

procedure getSocket;
var
 fd: Integer;
begin
  sd_notify( 0, 'READY=1\nSTATUS=Ready\n' );
  fd := sd_listen_fds(0);

if (fd > 1) then
 begin
       Raise Exception.Create('Too many file descriptors received');
 end else
 begin
 if (fd = 1) then
  begin
        fd := SD_LISTEN_FDS_START;
  end else
  begin
   // Open via a SOCKET!
(*
  union {
          struct sockaddr sa;
          struct sockaddr_un un;
  } sa;

  fd = socket(AF_UNIX, SOCK_STREAM, 0);
  if (fd < 0) {
          fprintf(stderr, "socket(): %m\n");
          exit(1);
  }

  memset(&sa, 0, sizeof(sa));
  sa.un.sun_family = AF_UNIX;
  strncpy(sa.un.sun_path, "/run/foobar.sk", sizeof(sa.un.sun_path));

  if (bind(fd, &sa.sa, sizeof(sa)) < 0) {
          fprintf(stderr, "bind(): %m\n");
          exit(1);
  }

  if (listen(fd, SOMAXCONN) < 0) {
          fprintf(stderr, "listen(): %m\n");
          exit(1);
  }
*)
  end;

 end;
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

