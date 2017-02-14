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
     {$ifdef linux}
     client_socket : TUnixServer = nil;
     {$else}
  client_socket : TInetServer = nil;
  {$endif}
  OpenSSL_Error : string = '';
     Path: string= '';



function getSocket: longint;
procedure TLS_Bind(FD: cint32);
procedure TLS_Init;


implementation

uses
  systemd,
  cryptossl,
  HMUX;

// fpopenssl
// http2_openssl.pas
// socketssl

// just simple hack wait for new "openssl"

{
const
SSL_CTRL_SET_ECDH_AUTO = 94;


function SslMethodTLSV1_2: PSSL_METHOD;
begin
  Result := openssl.SslMethodV23;
end;

 }

// end hacks



// create a Parameter Context for a TLS 1.2 Server Connection
// intended for a "HTTPS://" Server Socket


var
 CTX : PSSL_CTX;
 METH : PSSL_METHOD;


function StrictHTTP2Context: PSSL_CTX;
var
 p : array[0..4096] of char;
begin

  Path := ExtractFilePath(paramstr(0));
//
 METH := nil;
 METH := TLSv1_2_server_method;

 CTX := SSL_CTX_new(METH);

 result := CTX;
  if not(assigned(result)) then
    raise Exception.Create('Create a new SSL-Context fails');

  SSL_CTX_ctrl(Result, SSL_CTRL_SET_ECDH_AUTO, 1, nil);

  StrPCopy(p,Path + 'cert.pem');

  if (SSL_CTX_use_certificate_file(Result, PChar(@p), SSL_FILETYPE_PEM) <= 0) then
    raise Exception.Create('Register cert.pem fails');

  StrPCopy(p,Path + 'key.pem');



  if (SSL_CTX_use_PrivateKey_file(Result, @p, SSL_FILETYPE_PEM) <= 0) then
    raise Exception.Create('Register key.pem fails');

end;

// binds a HANDLE (comes from systemd, or from incoming socket) to a new SLL Connection

procedure TLS_Bind(FD: cint32);
var
  ssl: PSSL;
  Buf: array[0..4096] of byte;
  a,e : cInt;
//  ErrStr : array[0..4096] of char;
P : PChar;
x : AnsiString;
ERR_F : THandle;
begin
         (*
  // SSL Init
  ssl := sslNew(StrictHTTP2Context);
  if not(assigned(ssl)) then
    raise Exception.create('SSL_new().OpenSSL  fails');

  // SSL File Handle Übernahme
  if (sslSetFD(ssl, FD)=0) then
   raise Exception.create('SSL_set_fd().OpenSSL  fails');

  //
  a := sslAccept(ssl);
  case a of
    0:begin

    end;
    1: begin

    end;
  else

  end;

  if (a <= 0) then
  begin
               ERR_F := FileCreate( Path+'OpenSSL.log');
  ERR_print_errors_fp(ERR_F);
      FileClose(ERR_F);
    raise Exception.Create('ssl Accept fail');
  end;
  (*
  buf += Header;
  buf += Content;
  stack();
  stack();
    *)

  SSLwrite(ssl, @Buf, 16);
           *)
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
      client_socket := TUnixServer.Create('0.0.0.0:443');
   {$else}
      client_socket := TInetServer.Create('0.0.0.0', 443);
   {$endif}

      with client_socket do
      begin
        // Parameter?
     SetNonBlocking;
        // Bind to Interface

        Listen;

        // Make no further actions, let SSL take over
        Result := Socket;

      end;
    end;
  end;
end;

procedure TLS_Init;
begin

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



