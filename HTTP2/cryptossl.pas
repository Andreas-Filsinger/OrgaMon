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
  ctypes, Classes;

// debug infos

var
  sDebug: TStringList;

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
  TOpenSSL_version = function(t: cInt): PChar; cdecl;
  TTLSv1_2_server_method = function: PSSL_METHOD; cdecl;
  TSSL_CTX_new = function(meth: PSSL_METHOD): PSSL_CTX; cdecl;
  TSSL_CTX_use_certificate_file = function(ctx: PSSL_CTX; const _file: PChar;
    _type: cInt): cInt; cdecl;
  TSSL_CTX_use_PrivateKey_file = function(ctx: PSSL_CTX; const _file: PChar;
    _type: cInt): cInt; cdecl;
  TSSL_CTX_ctrl = function(ctx: PSSL_CTX; cmd: cInt; larg: clong;
    parg: Pointer): clong; cdecl;

const
  // lib functions for the public
  TLSv1_2_server_method: TTLSv1_2_server_method = nil;
  SSL_CTX_new: TSSL_CTX_new = nil;
  SSL_CTX_use_certificate_file: TSSL_CTX_use_certificate_file = nil;
  SSL_CTX_use_PrivateKey_file: TSSL_CTX_use_PrivateKey_file = nil;
  SSL_CTX_ctrl: TSSL_CTX_ctrl = nil;
  OpenSSL_version: TOpenSSL_version = nil;

function Version: string;
function LastError: string;

implementation

uses
  dynlibs;

const
  _OPENSSL_VERSION = 0;


const
{$ifdef MSWINDOWS}
{$ifdef win64}
  cLIB_NAME_CRYPTO = 'libcrypto-1_1-x64.dll';
  cLIB_NAME_SSL = 'libssl-1_1-x64.dll';
{$else}
  cLIB_NAME_CRYPTO = 'libcrypto-1_1.dll';
  cLIB_NAME_SSL = 'libssl-1_1.dll';
{$endif}
{$else}
  cLIB_NAME_CRYPTO = 'libcrypto.so.1.1';
  cLIB_NAME_SSL = 'libssl.so.1.1';
{$endif}

var
  libssl_HANDLE: TLibHandle = 0;
  libcrypto_HANDLE: TLibHandle = 0;

procedure Init;
begin
  sDebug := TStringList.Create;


  // libssl has dependencys to libcryto, so
  // ensure the correct libcrypto is loaded BEFORE
  // libssl do 'own' but 'false' trys
  libcrypto_HANDLE := LoadLibrary(cLIB_NAME_CRYPTO);
  if (libcrypto_HANDLE <= 0) then
  begin
    sDebug.add(LastError);
  end;

  libssl_HANDLE := LoadLibrary(cLIB_NAME_SSL);

  if (libssl_HANDLE > 0) then
  begin

    {$ifdef MSWINDOWS}
    OpenSSL_version := TOpenSSL_version(GetProcedureAddress(libcrypto_HANDLE,
      'OpenSSL_version'));
    {$else}
    OpenSSL_version := TOpenSSL_version(GetProcedureAddress(libssl_HANDLE,
      'OpenSSL_version'));
    {$endif}
    if not (assigned(OpenSSL_version)) then
      sDebug.add(LastError);

    TLSv1_2_server_method := TTLSv1_2_server_method(
      GetProcedureAddress(libssl_HANDLE, 'TLSv1_2_server_method'));
    if not (assigned(TLSv1_2_server_method)) then
      sDebug.add(LastError);

    SSL_CTX_new := TSSL_CTX_new(GetProcedureAddress(libssl_HANDLE, 'SSL_CTX_new'));
    if not (assigned(SSL_CTX_new)) then
      sDebug.add(LastError);

    SSL_CTX_ctrl := TSSL_CTX_ctrl(GetProcedureAddress(libssl_HANDLE, 'SSL_CTX_ctrl'));
    if not (assigned(SSL_CTX_ctrl)) then
      sDebug.add(LastError);

    SSL_CTX_use_certificate_file :=
      TSSL_CTX_use_certificate_file(GetProcedureAddress(libssl_HANDLE,
      'SSL_CTX_use_certificate_file'));
    if not (assigned(SSL_CTX_use_certificate_file)) then
      sDebug.add(LastError);

    SSL_CTX_use_PrivateKey_file :=
      TSSL_CTX_use_PrivateKey_file(GetProcedureAddress(libssl_HANDLE,
      'SSL_CTX_use_PrivateKey_file'));
    if not (assigned(SSL_CTX_use_PrivateKey_file)) then
      sDebug.add(LastError);

  end
  else
  begin
    sDebug.add(LastError);
  end;
end;

function Version: string;
begin
  if not(assigned(OpenSSL_version)) then
   Init;

  if assigned(OpenSSL_version) then
    Result := PChar(OpenSSL_version(_OPENSSL_VERSION))
  else
    Result := '- lib not loaded';
end;

function LastError: string;
begin
  Result := GetLoadErrorStr;
end;




end.
