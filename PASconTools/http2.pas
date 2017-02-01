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
  cTypes, Classes, SysUtils, ssockets;

const
  client_socket: TInetServer = nil;


function getSocket: longint;
procedure TLS_Bind(FD: cint32);


implementation

uses
  systemd, openssl, HMUX;

// just simple hack wait for new "openssl"

const
  SSL_CTRL_SET_ECDH_AUTO = 94;


function SslMethodTLSV1_2: PSSL_METHOD;
begin
  Result := openssl.SslMethodV23;
end;

// end hacks



// create a Parameter Context for a TLS 1.2 Server Connection
// intended for a "HTTPS://" Server Socket

function StrictHTTP2Context: PSSL_CTX;
var
   Path: string;
begin

  Path := ExtractFilePath(paramstr(0)) + DirectorySeparator;
  if not (InitSSLInterface) then
    raise Exception.Create('SSL Init Fail');

  Result := SslCtxNew(SslMethodTLSV1_2);

  SslCTXCtrl(Result, SSL_CTRL_SET_ECDH_AUTO, 1, nil);

  if (SslCtxUseCertificateFile(Result, Path + 'cert.pem', SSL_FILETYPE_PEM) < 0) then
    raise Exception.Create('Register cert.pem fails');

  if (SslCtxUsePrivateKeyFile(Result, Path + 'key.pem', SSL_FILETYPE_PEM) < 0) then
    raise Exception.Create('Register key.pem fails');

end;

// binds a HANDLE (comes from systemd, or from incoming socket) to a new SLL Connection

procedure TLS_Bind(FD: cint32);
var
  ssl: PSSL;
  Buf: array[0..4096] of byte;
begin

  ssl := sslNew(StrictHTTP2Context);
  sslSetFD(ssl, FD);

  if (sslAccept(ssl) <= 0) then
    raise Exception.Create('ssl Accept fail');

  (*
  buf += Header;
  buf += Content;
  stack();
  stack();
    *)

  SSLwrite(ssl, @Buf, 16);

end;

// Im Rang 1: socket von systemd erhalten: // http://0pointer.de/blog/projects/socket-activation.html
// Im Rang 2: selbst ein Socket öffnen und auf Verbindungsversuche von aussen warten

function getSocket: longint;
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

   {$ifdef linux}
      client_socket := TUnixServer.Create('0.0.0.0', 443);
   {$else}
      client_socket := TInetServer.Create('0.0.0.0', 443);
   {$endif}

      with client_socket do
      begin
        // Parameter?

        // Bind to Interface
        bind;

        // Make no further actions, let SSL take over
        Result := Socket;

      end;
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



