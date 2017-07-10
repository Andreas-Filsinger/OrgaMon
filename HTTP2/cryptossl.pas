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

{$ifdef FPC}
{$mode objfpc}{$H+}
{$endif}


{ $ define LIB_SSL_REV_10x}
{$define LIB_SSL_REV_11x}

interface

uses
 {$ifdef FPC}
  ctypes,
 {$endif}
  Classes, Sysutils;

// debug infos

{$ifndef FPC}
type
 cint = INteger;
 cint32 = Word;
 cuint64 = int64;
 clong = longint;
{$endif}


var
  sDebug: TStringList = nil;

// lib stuff for the public

const
  SSL_CTRL_SET_ECDH_AUTO = 94;
  SSL_FILETYPE_PEM = 1;
  TLSEXT_NAMETYPE_host_name = 0;

  OPENSSL_INIT_NO_LOAD_CRYPTO_STRINGS = $00000001;
  OPENSSL_INIT_LOAD_CRYPTO_STRINGS = $00000002;
  OPENSSL_INIT_ADD_ALL_CIPHERS = $00000004;
  OPENSSL_INIT_ADD_ALL_DIGESTS = $00000008;
  OPENSSL_INIT_NO_ADD_ALL_CIPHERS = $00000010;
  OPENSSL_INIT_NO_ADD_ALL_DIGESTS = $00000020;
  OPENSSL_INIT_LOAD_CONFIG = $00000040;
  OPENSSL_INIT_NO_LOAD_CONFIG = $00000080;
  OPENSSL_INIT_ASYNC = $00000100;
  OPENSSL_INIT_ENGINE_RDRAND = $00000200;
  OPENSSL_INIT_ENGINE_DYNAMIC = $00000400;
  OPENSSL_INIT_ENGINE_OPENSSL = $00000800;
  OPENSSL_INIT_ENGINE_CRYPTODEV = $00001000;
  OPENSSL_INIT_ENGINE_CAPI = $00002000;
  OPENSSL_INIT_ENGINE_PADLOCK = $00004000;
  OPENSSL_INIT_ENGINE_AFALG = $00008000;
  OPENSSL_INIT_NO_LOAD_SSL_STRINGS = $00100000;
  OPENSSL_INIT_LOAD_SSL_STRINGS = $00200000;

  SSL_ERROR : array[0..7] of string = (
 'SSL_ERROR_NONE',
 'SSL_ERROR_SSL',
 'SSL_ERROR_WANT_READ',
 'SSL_ERROR_WANT_WRITE',
 'SSL_ERROR_WANT_X509_LOOKUP',
 'SSL_ERROR_SYSCALL',
 'SSL_ERROR_ZERO_RETURN',
 'SSL_ERROR_WANT_CONNECT');

  SSL_TLSEXT_ERR_OK = 0;
  SSL_TLSEXT_ERR_ALERT_WARNING = 1;
  SSL_TLSEXT_ERR_ALERT_FATAL = 2;
  SSL_TLSEXT_ERR_NOACK = 3;

  SSL_CTRL_SET_TLSEXT_SERVERNAME_CB = 53;

type
  // Data-Types
  POPENSSL_INIT_SETTINGS = Pointer;
  PSSL_CTX = Pointer;
  PSSL = Pointer;
  PSSL_METHOD = Pointer;

  //
  // Callback-Function-Types, Funktionen die openSSL ruft
  TCB_INFO = procedure(ssl : PSSL; wher, ret : cint); cdecl;
  TCB_SERVERNAME = function (SSL : PSSL; i:cint; p: Pointer):cint; cdecl;
  TCB_ERROR = function (const s : PChar; len:size_t; p : Pointer):cint; cdecl;

  // Memory Functions
  TCRYPTO_malloc = function(num: cardinal; const _file: PChar;
    line: cint): Pointer; cdecl;
  TCRYPTO_realloc = function(p: Pointer; num: cardinal; _file: PChar;
    line: cint): Pointer; cdecl;
  TCRYPTO_free = procedure(str: Pointer; const p1: PChar; p2: cint); cdecl;

  // Log-Funktions
  TERR_print_errors_cb = procedure (cb : TCB_ERROR; p : pointer); cdecl;

  // API-Function-Types
  TOPENSSL_init_ssl = function(opts: cuint64;
    settings: POPENSSL_INIT_SETTINGS): cint; cdecl;
  TSSL_library_init = function:cint; cdecl;
  TCRYPTO_set_mem_functions = function(m: TCRYPTO_malloc; r: TCRYPTO_realloc;
    f: TCRYPTO_free): cint; cdecl;
  TOpenSSL_version = function(t: cint): PAnsiChar; cdecl;
  TOpenSSL_method = function: PSSL_METHOD; cdecl;
  TSSL_CTX_new = function(meth: PSSL_METHOD): PSSL_CTX; cdecl;
  TSSL_CTX_use_certificate_file = function(ctx: PSSL_CTX; const _file: PChar;
    _type: cint): cint; cdecl;
  TSSL_CTX_use_PrivateKey_file = function(ctx: PSSL_CTX; const _file: PChar;
    _type: cint): cint; cdecl;
  TSSL_CTX_ctrl = function(ctx: PSSL_CTX; cmd: cint; larg: clong;
    parg: Pointer): clong; cdecl;
  TSSL_CTX_set_info_callback = procedure(ctx: PSSL_CTX; cb: TCB_INFO); cdecl;
  TSSL_new = function(ctx: PSSL_CTX):PSSL; cdecl;
  TSSL_set_fd = function(SSL: PSSL; fd: cint): cint; cdecl;
  TSSL_accept = function(SSL: PSSL):cint; cdecl;
  TSSL_get_error = function (SSL: PSSL; ret: cint): cint; cdecl;
  TSSL_CTX_callback_ctrl = function (ctx: PSSL_CTX; cmd: cint; cb : pointer) : clong; cdecl;
  TSSL_get_servername = function (SSL: PSSL; typ: cint): Pchar; cdecl;

const
  // lib functions for the public

  // Init & Util & Debug
  OPENSSL_init_ssl: TOPENSSL_init_ssl = nil;
  SSL_library_init: TSSL_library_init = nil;
  CRYPTO_set_mem_functions: TCRYPTO_set_mem_functions = nil;
  OpenSSL_version: TOpenSSL_version = nil;
  SSL_CTX_set_info_callback: TSSL_CTX_set_info_callback = nil;
  ERR_print_errors_cb: TERR_print_errors_cb = nil;
  SSL_get_error: TSSL_get_error = nil;

  // Methods
  TLSv1_2_server_method: TOpenSSL_method = nil;
  TLS_server_method:TOpenSSL_method = nil;
  TLS_client_method: TOpenSSL_method = nil;

  // CTX - Tools
  SSL_CTX_new: TSSL_CTX_new = nil;
  SSL_CTX_ctrl: TSSL_CTX_ctrl = nil;
  SSL_CTX_callback_ctrl: TSSL_CTX_callback_ctrl = nil;

  // SSL - Tools
  SSL_new : TSSL_new = nil;
  SSL_set_fd : TSSL_set_fd = nil;
  SSL_accept : TSSL_accept = nil;
  SSL_get_servername : TSSL_get_servername = nil;

  // pem - Files
  SSL_CTX_use_certificate_file: TSSL_CTX_use_certificate_file = nil;
  SSL_CTX_use_PrivateKey_file: TSSL_CTX_use_PrivateKey_file = nil;
  SSL_CTX_use_RSAPrivateKey_file : TSSL_CTX_use_PrivateKey_file = nil;

function Version: string;
function LastError: string;

// public call-Backs

function cb_ERR (const s : PChar; len:size_t; p : Pointer):cint; cdecl;
procedure cb_INFO(ssl : PSSL; wher, ret : cint); cdecl;
function cb_SERVERNAME (SSL : PSSL; i:cint; p: Pointer):cint; cdecl;


var
  METH: PSSL_METHOD = nil;
  CTX: PSSL_CTX = nil;

implementation

uses
{$ifdef FPC}
  dynlibs
{$else}
 windows
 {$endif}
 ;

const
  _OPENSSL_VERSION = 0;


const
{$ifdef MSWINDOWS}

  {$ifdef win64}
    cLIB_NAME_CRYPTO = 'libcrypto-1_1-x64.dll';
    cLIB_NAME_SSL = 'libssl-1_1-x64.dll';
  {$else}

  {$ifdef LIB_SSL_REV_11x}
    cLIB_NAME_CRYPTO = 'libcrypto-1_1.dll';
    cLIB_NAME_SSL = 'libssl-1_1.dll';
    {$endif LIB_SSL_REV_11x}
    {$ifdef LIB_SSL_REV_10x}
    cLIB_NAME_CRYPTO = 'libeay32.dll';
    cLIB_NAME_SSL = 'ssleay32.dll';
    {$endif LIB_SSL_REV_10x}
  {$endif}

{$else}

  {$ifdef LIB_SSL_REV_11x}
   cLIB_NAME_CRYPTO = 'libcrypto.so.1.1';
   cLIB_NAME_SSL = 'libssl.so.1.1';
   {$endif LIB_SSL_REV_11x}

  {$ifdef LIB_SSL_REV_10x}
   cLIB_NAME_CRYPTO = 'libcrypto.so.1.0.0';
   cLIB_NAME_SSL = 'libssl.so.1.0.0';
  {$endif LIB_SSL_REV_10x}

{$endif}

var
//  libssl_HANDLE: TLibHandle = 0;
//  libcrypto_HANDLE: TLibHandle = 0;

  libssl_HANDLE: HMODULE = 0;
  libcrypto_HANDLE: HMODULE = 0;


function CRYPTO_malloc(num: cardinal; const _file: PChar;
  line: cint): Pointer; cdecl;
begin
  Result := AllocMem(num);
    (*


    Result := nil;

    if (num <= 0) then Exit;

    Result := HeapAlloc(
      GetProcessHeap,
      $8{HEAP_ZERO_MEMORY},
      size
      );
      *)


end;

function CRYPTO_realloc(p: Pointer; num: cardinal; _file: PChar;
  line: cint): Pointer; cdecl;
begin
{$ifdef FPC}
  result := ReallocMem(p, num);
{$endif}

    (*
    Result := nil;

    if (nil = p) then Exit;

    old := HeapSize(GetProcessHeap, 0, p);
    if old < 0 then Exit;

    Result := HeapReAlloc(
      GetProcessHeap,
      $8{HEAP_ZERO_MEMORY} or $10{HEAP_REALLOC_IN_PLACE_ONLY},
      p,
      size
      );

    // if couldnt resize in place
    // we will alloc a new one
    // and zerofill the old one
    if (nil = Result) then
    begin
      Result := aopenssl_malloc(Size);

      if (nil = Result) then Exit;

      CopyMemory(
        Result,
        P,
        old
        );

      aopenssl_free(p); /// free and zerofill
    end;
*)

end;

procedure CRYPTO_free(str: Pointer; const p1: PChar; p2: cint); cdecl;
begin
  FreeMem(str);

    (*
      if (nil = p) then Exit;

  old := HeapSize(GetProcessHeap, 0, p);
  if old < 0 then ZeroMemory(p, old);

  HeapFree(GetProcessHeap, 0, p);
*)
end;

function cb_ERR (const s : PChar; len:size_t; p : Pointer):cint; cdecl;
begin
 sDebug.add(InttoStr(len)+'@cb_ERR');
 sDebug.add(s);
end;

procedure cb_INFO(ssl : PSSL; wher, ret : cint); cdecl;
begin
  sDebug.add(InttoStr(wher)+'@cb_INFO');
  sDebug.Add(IntTostr(wher)+':'+InttoStr(ret));
end;

(* ServerName Callback! *)

function cb_SERVERNAME (SSL : PSSL; i:cint; p: Pointer):cint; cdecl;
var
  ServerExpected : string;
begin
 ServerExpected := SSL_get_servername(SSL,  TLSEXT_NAMETYPE_host_name);


 sDebug.add('REQUEST TO "'+ServerExpected+'"');

 // in der Entwicklungsphase ist nur die Identität "localhost" erlaubt
 // wird der Server als eine andere Identität angesprochen erfolgt ein
 // Verbindungsabbruch
 if (ServerExpected='localhost') then
  result := SSL_TLSEXT_ERR_OK
 else
  result := SSL_TLSEXT_ERR_NOACK;
end;

/////////////////////////////////////////////////////////////////

procedure Init;
begin
  if assigned(sDebug) then
    exit;

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

    // import libcrypto functions


    OpenSSL_version := TOpenSSL_version(GetProcAddress(libcrypto_HANDLE,
      'OpenSSL_version'));
    if not (assigned(OpenSSL_version)) then
    begin
      OpenSSL_version := TOpenSSL_version(GetProcAddress(libcrypto_HANDLE,'SSLeay_version'));
    end;
    if not (assigned(OpenSSL_version)) then
      sDebug.add(LastError);

    CRYPTO_set_mem_functions :=
      TCRYPTO_set_mem_functions(GetProcAddress(libcrypto_HANDLE,
      'CRYPTO_set_mem_functions'));
    if not (assigned(CRYPTO_set_mem_functions)) then
      sDebug.add(LastError);

    ERR_print_errors_cb := TERR_print_errors_cb(GetProcAddress(libcrypto_HANDLE,
      'ERR_print_errors_cb'));
    if not (assigned(ERR_print_errors_cb)) then
      sDebug.add(LastError);


    // import libssl functions

    {$ifdef LIB_SSL_REV_11x}
    OPENSSL_init_ssl :=
      TOPENSSL_init_ssl(GetProcAddress(libssl_HANDLE, 'OPENSSL_init_ssl'));
    if not (assigned(OPENSSL_init_ssl)) then
      sDebug.add(LastError);
    {$endif}

    {$ifdef LIB_SSL_REV_10x}
    SSL_library_init := TSSL_library_init(GetProcAddress(libssl_HANDLE, 'SSL_library_init'));
    if not (assigned(SSL_library_init)) then
      sDebug.add(LastError);
    {$endif}

    TLSv1_2_server_method := TOpenSSL_method(
      GetProcAddress(libssl_HANDLE, 'TLSv1_2_server_method'));
    if not (assigned(TLSv1_2_server_method)) then
      sDebug.add(LastError);

    {$ifdef LIB_SSL_REV_11x}
    TLS_server_method := TOpenSSL_method(
      GetProcAddress(libssl_HANDLE, 'TLS_server_method'));
    if not (assigned(TLS_server_method)) then
      sDebug.add(LastError);
    {$endif}

    {$ifdef LIB_SSL_REV_11x}
    TLS_client_method := TOpenSSL_method(
      GetProcAddress(libssl_HANDLE, 'TLS_client_method'));
    if not (assigned(TLS_client_method)) then
      sDebug.add(LastError);
    {$endif}

    SSL_CTX_new := TSSL_CTX_new(GetProcAddress(libssl_HANDLE, 'SSL_CTX_new'));
    if not (assigned(SSL_CTX_new)) then
      sDebug.add(LastError);

    SSL_CTX_ctrl := TSSL_CTX_ctrl(GetProcAddress(libssl_HANDLE, 'SSL_CTX_ctrl'));
    if not (assigned(SSL_CTX_ctrl)) then
      sDebug.add(LastError);

    SSL_CTX_use_certificate_file :=
      TSSL_CTX_use_certificate_file(GetProcAddress(libssl_HANDLE,
      'SSL_CTX_use_certificate_file'));
    if not (assigned(SSL_CTX_use_certificate_file)) then
      sDebug.add(LastError);

    SSL_CTX_use_PrivateKey_file :=
      TSSL_CTX_use_PrivateKey_file(GetProcAddress(libssl_HANDLE,
      'SSL_CTX_use_PrivateKey_file'));
    if not (assigned(SSL_CTX_use_PrivateKey_file)) then
      sDebug.add(LastError);

    SSL_CTX_use_RSAPrivateKey_file :=
      TSSL_CTX_use_PrivateKey_file(GetProcAddress(libssl_HANDLE,
      'SSL_CTX_use_RSAPrivateKey_file'));
    if not (assigned(SSL_CTX_use_RSAPrivateKey_file)) then
      sDebug.add(LastError);

     SSL_CTX_set_info_callback := TSSL_CTX_set_info_callback(GetProcAddress(libssl_HANDLE,
      'SSL_CTX_set_info_callback'));
    if not (assigned(SSL_CTX_set_info_callback)) then
      sDebug.add(LastError);

    SSL_new := TSSL_new(GetProcAddress(libssl_HANDLE,
      'SSL_new'));
    if not (assigned(SSL_new)) then
      sDebug.add(LastError);

    SSL_set_fd := TSSL_set_fd(GetProcAddress(libssl_HANDLE,
      'SSL_set_fd'));
    if not (assigned(SSL_set_fd)) then
      sDebug.add(LastError);

    SSL_accept := TSSL_accept(GetProcAddress(libssl_HANDLE,
      'SSL_accept'));
    if not (assigned(SSL_accept)) then
      sDebug.add(LastError);

    SSL_get_error := TSSL_get_error(GetProcAddress(libssl_HANDLE,
      'SSL_get_error'));
    if not (assigned(SSL_get_error)) then
      sDebug.add(LastError);

    SSL_CTX_callback_ctrl := TSSL_CTX_callback_ctrl(GetProcAddress(libssl_HANDLE,
      'SSL_CTX_callback_ctrl'));
    if not (assigned(SSL_CTX_callback_ctrl)) then
      sDebug.add(LastError);

    SSL_get_servername := TSSL_get_servername(GetProcAddress(libssl_HANDLE,
      'SSL_get_servername'));
    if not (assigned(SSL_get_servername)) then
      sDebug.add(LastError);


    (*
    if (CRYPTO_set_mem_functions(@CRYPTO_malloc, @CRYPTO_realloc, @CRYPTO_free) <> 1) then
      sDebug.add('CRYPTO_set_mem_functions fail!');
    *)

    {$ifdef LIB_SSL_REV_10x}
                     SSL_library_init;
    //    OpenSSL_add_all_algorithms;
    //OpenSSL_add_all_ciphers;
    //OpenSSL_add_all_digests;
    //ERR_load_crypto_strings;
    {$endif}

    {$ifdef LIB_SSL_REV_11x}

    if (OPENSSL_init_ssl(OPENSSL_INIT_LOAD_CRYPTO_STRINGS or OPENSSL_INIT_LOAD_SSL_STRINGS, nil) <> 1) then
      sDebug.add('OPENSSL_init_ssl fail!');

    {$endif}



  end
  else
  begin
    sDebug.add(LastError);
  end;
end;

function Version: string;
var
 P : PChar;
begin
  Init;

  if assigned(OpenSSL_version) then
  begin
    result := OpenSSL_version(_OPENSSL_VERSION);
  end else
  begin
    Result := '- lib not loaded';
  end;
end;

function LastError: string;
begin
{$ifdef FPC}
  Result := GetLoadErrorStr;
{$endif}
end;

end.
