{     Interface to OpenSSL 1.1
  |
  |
  |    _  _  _                                _
  |   | |(_)| |__    ___  _ __  _   _  _ __  | |_  ___
  |   | || || '_ \  / __|| '__|| | | || '_ \ | __|/ _ \
  |   | || || |_) || (__ | |   | |_| || |_) || |_| (_) |
  |   |_||_||_.__/  \___||_|    \__, || .__/  \__|\___/
  |                             |___/ |_|
  |   (c) File "LICENSE" of OpenSSL 1.1 Distribution
  |
  |    _  _  _                _
  |   | |(_)| |__   ___  ___ | |
  |   | || || '_ \ / __|/ __|| |
  |   | || || |_) |\__ \\__ \| |
  |   |_||_||_.__/ |___/|___/|_|
  |
  |   (c) File "LICENSE" of OpenSSL 1.1 Distribution
  |
  |
  |   cryptossl minimalistic Interface (c) Andreas Filsinger 2017
  |
}
unit cryptossl;

{$mode objfpc}{$H+}

interface

uses
  ctypes;

// lib stuff for the public

const
  SSL_CTRL_SET_ECDH_AUTO = 94;
  SSL_FILETYPE_PEM = 1;


type
  // Data-Types
  PSSL_CTX = Pointer;
  PSSL = Pointer;
  PSSL_METHOD = Pointer;

  // Function-Types
  TTLSv1_2_server_method = function:PSSL_METHOD; cdecl;
  TSSL_CTX_new = function(meth: PSSL_METHOD):PSSL_CTX; cdecl;
  TSSL_CTX_use_certificate_file = function(ctx: PSSL_CTX; const _file: PChar; _type: cInt):cInt; cdecl;
  TSSL_CTX_use_PrivateKey_file = function(ctx: PSSL_CTX; const _file: PChar; _type: cInt):cInt; cdecl;
  TSSL_CTX_ctrl = function (ctx: PSSL_CTX;  cmd : cInt;   larg: clong; parg: Pointer): clong;cdecl;
// lib functions for the public

const
  TLSv1_2_server_method : TTLSv1_2_server_method = nil;
  SSL_CTX_new : TSSL_CTX_new = nil;
  SSL_CTX_use_certificate_file : TSSL_CTX_use_certificate_file = nil;
  SSL_CTX_use_PrivateKey_file : TSSL_CTX_use_PrivateKey_file = nil;
  SSL_CTX_ctrl : TSSL_CTX_ctrl = nil;

function Version : string;

implementation

uses
 dynlibs;

const
 _OPENSSL_VERSION = 0;

 // lib functions in order of usage

type 
 TOpenSSL_version = function(t : cInt):PChar; cdecl;

const
 OpenSSL_version : TOpenSSL_version = nil;

function Version : string;
begin
 if assigned(OpenSSL_version) then
  Result := PChar(OpenSSL_version(_OPENSSL_VERSION))
 else
  Result := '- lib not loaded';
end;            

const
{$ifdef MSWINDOWS}
cLIB_NAME_CRYPTO  = 'libcrypto-1_1-x64.dll';
 cLIB_NAME_SSL     = 'libssl-1_1-x64.dll';
{$else}
cLIB_NAME_CRYPTO  = '/root/Documents/openssl-1.1.0d/libcrypto.so.1.1';
 cLIB_NAME_SSL     = '/root/Documents/openssl-1.1.0d/libssl.so.1.1';
{$endif}

var
 libssl_HANDLE : TLibHandle;
 libcrypto_HANDLE : TLibHandle;

begin
 // writeln( paramstr(0));

 // 
 // libssl has dependencys to libcryto, so
 // ensure the correct libcrypto is loaded BEFORE
 // libssl do 'own' but 'false' trys
 libcrypto_HANDLE  := LoadLibrary(cLIB_NAME_CRYPTO);
// writeln(libcrypto_HANDLE);

 libssl_HANDLE  := LoadLibrary(cLIB_NAME_SSL);
 // writeln(libssl_HANDLE);

 if (libssl_HANDLE>0) then
 begin
  OpenSSL_version :=  TOpenSSL_version (GetProcedureAddress(libssl_HANDLE, 'OpenSSL_version'));
  TLSv1_2_server_method := TTLSv1_2_server_method (GetProcedureAddress(libssl_HANDLE,'TLSv1_2_server_method'));
  SSL_CTX_new := TSSL_CTX_new (GetProcedureAddress(libssl_HANDLE,'SSL_CTX_new'));
  SSL_CTX_ctrl := TSSL_CTX_ctrl (GetProcedureAddress(libssl_HANDLE,'SSL_CTX_ctrl'));
  SSL_CTX_use_certificate_file :=  TSSL_CTX_use_certificate_file (GetProcedureAddress(libssl_HANDLE, 'SSL_CTX_use_certificate_file'));
  SSL_CTX_use_PrivateKey_file := TSSL_CTX_use_PrivateKey_file (GetProcedureAddress(libssl_HANDLE, 'SSL_CTX_use_PrivateKey_file'));

//  writeln(Integer(@OpenSSL_Version));
 end;
end.
