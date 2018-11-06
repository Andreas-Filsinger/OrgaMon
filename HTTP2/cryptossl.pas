{
  |   cryptossl
  |   =========
  |
  |   minimalistic freepascal Interface to OpenSSL 1.1
  |   (c) 2017 - 2018  Andreas Filsinger
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
  |
  |
}
unit cryptossl;

{$mode objfpc}{$H+}

interface

uses
  ctypes,
  Classes,
  Sysutils;

var
  // Debug-Messages from Socket or SSL
  sDebug: TStringList = nil;
  pem_Path : string;

// lib stuff for the public

const
  SSL_FILETYPE_PEM = 1;
  TLS1_2_VERSION = $0303;
  TLS1_3_VERSION = $0304;

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

  // STATUS
  SSL_ST_CONNECT = $1000;
  SSL_ST_ACCEPT = $2000;
  SSL_ST_ALERT = $4000;
  SSL_CB_LOOP = $01;
  SSL_CB_EXIT = $02;
  SSL_CB_READ = $04;
  SSL_CB_WRITE = $08;
  SSL_CB_HANDSHAKE_START = $10;
  SSL_CB_HANDSHAKE_DONE = $20;

  SSL_CB_READ_ALERT  = SSL_ST_ALERT or SSL_CB_READ;
  SSL_CB_WRITE_ALERT = SSL_ST_ALERT or SSL_CB_WRITE;
  SSL_CB_ACCEPT_LOOP = SSL_ST_ACCEPT or SSL_CB_LOOP;
  SSL_CB_ACCEPT_EXIT = SSL_ST_ACCEPT or SSL_CB_EXIT;
  SSL_CB_CONNECT_LOOP = SSL_ST_CONNECT or SSL_CB_LOOP;
  SSL_CB_CONNECT_EXIT = SSL_ST_CONNECT or SSL_CB_EXIT;

  SSL_ERROR_NONE = 0;
  SSL_ERROR_SSL = 1;
  SSL_ERROR_WANT_READ = 2;
  SSL_ERROR_WANT_WRITE = 3;
  SSL_ERROR_WANT_X509_LOOKUP = 4;
  SSL_ERROR_SYSCALL = 5;
  SSL_ERROR_ZERO_RETURN = 6;
  SSL_ERROR_WANT_CONNECT = 7;

  // ERRORS
  SSL_ERROR : array[0..7] of string = (
 'SSL_ERROR_NONE',
 'SSL_ERROR_SSL',
 'SSL_ERROR_WANT_READ',
 'SSL_ERROR_WANT_WRITE',
 'SSL_ERROR_WANT_X509_LOOKUP',
 'SSL_ERROR_SYSCALL',
 'SSL_ERROR_ZERO_RETURN',
 'SSL_ERROR_WANT_CONNECT');

  // TLS EXTENSIONS ...
  SSL_TLSEXT_ERR_OK = 0;
  SSL_TLSEXT_ERR_ALERT_WARNING = 1;
  SSL_TLSEXT_ERR_ALERT_FATAL = 2;
  SSL_TLSEXT_ERR_NOACK = 3;
  TLSEXT_NAMETYPE_host_name = 0;

  // NPN
  OPENSSL_NPN_UNSUPPORTED = 0;
  OPENSSL_NPN_NEGOTIATED = 1;
  OPENSSL_NPN_NO_OVERLAP = 2;

  // CTRL ...
  SSL_CTRL_SET_TLSEXT_SERVERNAME_CB = 53;
  SSL_CTRL_SET_ECDH_AUTO = 94;
  SSL_CTRL_SET_MIN_PROTO_VERSION          = 123;
  SSL_CTRL_SET_MAX_PROTO_VERSION          = 124;

  // OPTION ...
  SSL_OP_CIPHER_SERVER_PREFERENCE = $00400000;

type
  // Data-Types
  POPENSSL_INIT_SETTINGS = Pointer;
  PSSL_CTX = Pointer;
  PSSL = Pointer;
  PSSL_METHOD = Pointer;
  PSSL_CIPHER = Pointer;

  // Callback-Function-Types, Funktionen die openSSL ruft
  TCB_INFO = procedure(ssl : PSSL; wher, ret : cint); cdecl;
  TCB_SERVERNAME = function (SSL : PSSL; i:cint; p: Pointer):cint; cdecl;
  TCB_ERROR = function (const s : PChar; len:size_t; p : Pointer):cint; cdecl;
  TCB_ALPN = function (SSL : PSSL; cout: PPChar; outlen: PChar; pin: PChar; inlen: cuint; arg: Pointer):cint; cdecl;

  // Memory Functions
  TCRYPTO_malloc = function(num: cardinal; const _file: PChar;
    line: cint): Pointer; cdecl;
  TCRYPTO_realloc = function(p: Pointer; num: cardinal; _file: PChar;
    line: cint): Pointer; cdecl;
  TCRYPTO_free = procedure(str: Pointer; const p1: PChar; p2: cint); cdecl;

  // Log-Funktions
  TERR_print_errors_cb = procedure (cb : TCB_ERROR; p : pointer); cdecl;
  TSSL_CTX_set_info_callback = procedure(ctx: PSSL_CTX; cb: TCB_INFO); cdecl;
  TSSL_state_string_long = function (ssl: PSSL) : PChar;
  TSSL_alert_type_string_long = function (value: cint) : PChar;
  TSSL_alert_desc_string_long = function (value: cint) : PChar;

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
  TSSL_use_certificate_file = function(SSL: PSSL; const _file: PChar;
    _type: cint): cint; cdecl;
  TSSL_CTX_use_PrivateKey_file = function(ctx: PSSL_CTX; const _file: PChar;
    _type: cint): cint; cdecl;
  TSSL_use_PrivateKey_file = function(SSL: PSSL; const _file: PChar;
    _type: cint): cint; cdecl;
  TSSL_CTX_ctrl = function(ctx: PSSL_CTX; cmd: cint; larg: clong;
    parg: Pointer): clong; cdecl;
  TSSL_new = function(ctx: PSSL_CTX):PSSL; cdecl;
  TSSL_set_fd = function(SSL: PSSL; fd: cint): cint; cdecl;
  TSSL_accept = function(SSL: PSSL):cint; cdecl;
  TSSL_get_error = function (SSL: PSSL; ret: cint): cint; cdecl;
  TSSL_CTX_callback_ctrl = function (ctx: PSSL_CTX; cmd: cint; cb : pointer) : clong; cdecl;
  TSSL_get_servername = function (SSL: PSSL; typ: cint): Pchar; cdecl;
  TSSL_CTX_set_cipher_list = function (ctx: PSSL_CTX; const str: PChar): cint; cdecl;
  TSSL_CTX_set_options = function(ctx: PSSL_CTX; options: clong): clong; cdecl;
  TSSL_CTX_check_private_key = function (ctx: PSSL_CTX): cint; cdecl;
  TSSL_check_private_key = function (SSL: PSSL): cint; cdecl;
  TSSL_select_next_proto = function (cout : PPChar; outlen : PChar;
                           server : PChar; server_len: cuint;
                           client: PChar; client_len : cuint): cint; cdecl;
  TSSL_get_version = function(SSL: PSSL):PChar; cdecl;
  TSSL_get_current_cipher = function(SSL: PSSL):PSSL_CIPHER; cdecl;
  TSSL_CIPHER_description = function(SSL_CIPHER: PSSL_CIPHER; buf: PChar; size: cint) : PChar; cdecl;

  TSSL_CTX_set_alpn_select_cb = procedure(ctx: PSSL_CTX; cb: TCB_ALPN; arg: Pointer); cdecl;

  // IO
  TSSL_pending = function(SSL: Pssl): cint; cdecl;
  TSSL_has_pending = function(SSL: Pssl): cint; cdecl;
  TSSL_read = function(SSL: Pssl; buf : Pointer;  num: cint): cint; cdecl;
  TSSL_write = function(SSL: Pssl; buf : Pointer;  num: cint): cint; cdecl;


const
  // lib functions for the public

  // Init & Util & Debug
  OPENSSL_init_ssl: TOPENSSL_init_ssl = nil;
  SSL_library_init: TSSL_library_init = nil;
  CRYPTO_set_mem_functions: TCRYPTO_set_mem_functions = nil;
  OpenSSL_version: TOpenSSL_version = nil;
  ERR_print_errors_cb: TERR_print_errors_cb = nil;
  SSL_get_error: TSSL_get_error = nil;
  SSL_select_next_proto: TSSL_select_next_proto = nil;
  SSL_state_string_long:  TSSL_state_string_long = nil;
  SSL_alert_type_string_long : TSSL_alert_type_string_long = nil;
  SSL_alert_desc_string_long : TSSL_alert_desc_string_long = nil;

  // Register Callbacks
  SSL_CTX_set_info_callback: TSSL_CTX_set_info_callback = nil;
  SSL_CTX_set_alpn_select_cb: TSSL_CTX_set_alpn_select_cb = nil;

  // Methods
  {$ifdef TLS12}
  TLSv1_2_server_method: TOpenSSL_method = nil;
  {$endif}
  TLS_server_method: TOpenSSL_method = nil;
  TLS_client_method: TOpenSSL_method = nil;

  // CTX - Tools
  SSL_CTX_new: TSSL_CTX_new = nil;
  SSL_CTX_ctrl: TSSL_CTX_ctrl = nil;
  SSL_CTX_set_options: TSSL_CTX_set_options = nil;
  SSL_CTX_callback_ctrl: TSSL_CTX_callback_ctrl = nil;
  SSL_CTX_set_cipher_list: TSSL_CTX_set_cipher_list = nil;
  SSL_CTX_check_private_key : TSSL_CTX_check_private_key  = nil;

  // SSL - Tools
  SSL_new : TSSL_new = nil;
  SSL_set_fd : TSSL_set_fd = nil;
  SSL_accept : TSSL_accept = nil;
  SSL_get_servername : TSSL_get_servername = nil;
  SSL_check_private_key : TSSL_check_private_key  = nil;
  SSL_get_version : TSSL_get_version = nil;
  SSL_get_current_cipher : TSSL_get_current_cipher = nil;
  SSL_CIPHER_description : TSSL_CIPHER_description = nil;

  // pem - Files
  SSL_CTX_use_certificate_file: TSSL_CTX_use_certificate_file = nil;
  SSL_use_certificate_file: TSSL_use_certificate_file = nil;
  SSL_CTX_use_PrivateKey_file: TSSL_CTX_use_PrivateKey_file = nil;
  SSL_use_PrivateKey_file: TSSL_use_PrivateKey_file = nil;
  SSL_CTX_use_RSAPrivateKey_file : TSSL_CTX_use_PrivateKey_file = nil;

  // IO
  SSL_pending: TSSL_pending = nil;
  SSL_has_pending: TSSL_has_pending = nil;
  SSL_read: TSSL_read = nil;
  SSL_write: TSSL_write = nil;

function Version: string;
function LastError: string;

// public call-Backs

function cb_ERROR (const s : PChar; len:size_t; p : Pointer):cint; cdecl;
procedure cb_INFO(ssl : PSSL; wher, ret : cint); cdecl;
function cb_SERVERNAME (SSL : PSSL; i:cint; p: Pointer):cint; cdecl;
function cb_ALPN(SSL : PSSL; cout: PPChar; outlen: PChar; pin: PChar; inlen: cuint; arg: Pointer):cint; cdecl;
// function cb_PROTOCOL(SSL : PSSL; cout: PPChar; outlen: PChar; arg: Pointer):cint; cdecl;

// One global Context
const
  cs_Servername : string = '';
  cs_Protokoll_h2 : ShortString = 'h2';

implementation

uses
 dynlibs;

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
  result := ReallocMem(p, num);

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

function cb_ERROR (const s : PChar; len:size_t; p : Pointer):cint; cdecl;
begin
 sDebug.add(InttoStr(len)+'@cb_ERROR');
 sDebug.add(s);
end;

procedure cb_INFO(ssl : PSSL; wher, ret : cint); cdecl;
var
 Alert: PChar;
 Status: PChar;
 Msg: string;
begin
 Msg := 'cb_INFO:';

 case wher of
    SSL_ST_CONNECT: Msg := Msg +  'CONNECT';
    SSL_ST_ACCEPT :Msg := Msg + 'ACCEPT';
    SSL_ST_ALERT :Msg := Msg + 'ALERT';
    SSL_CB_LOOP :Msg := Msg + 'LOOP';
    SSL_CB_EXIT :Msg := Msg + 'EXIT';
    SSL_CB_READ :Msg := Msg + 'READ';
    SSL_CB_WRITE :Msg := Msg + 'WRITE';
    SSL_CB_HANDSHAKE_START :Msg := Msg + 'HANDSHAKE_START';
    SSL_CB_HANDSHAKE_DONE :Msg := Msg + 'HANDSHAKE_DONE';
    SSL_CB_READ_ALERT :Msg := Msg + 'READ_ALERT';
    SSL_CB_WRITE_ALERT :Msg := Msg + 'WRITE_ALERT';
    SSL_CB_ACCEPT_LOOP :Msg := Msg + 'ACCEPT_LOOP';
    SSL_CB_ACCEPT_EXIT :Msg := Msg + 'ACCEPT_EXIT';
    SSL_CB_CONNECT_LOOP :Msg := Msg + 'CONNECT_LOOP';
    SSL_CB_CONNECT_EXIT :Msg := Msg + 'CONNECT_EXIT';
 else
   Msg := Msg + '0x' + IntToHex(wher,4);
 end;

 if assigned(ssl) then
  Msg := Msg + '|' + SSL_state_string_long(ssl);

 if (ret<>1) then
  Msg := Msg + '|' + SSL_alert_type_string_long(ret) + '(' + SSL_alert_desc_string_long(ret) + ')' ;

 sDebug.add(Msg);

end;
(* ServerName Callback! *)

function cb_SERVERNAME (SSL : PSSL; i:cint; p: Pointer):cint; cdecl;
var
 ErrorCount: integer;
 FileName : array[0..4095] of AnsiChar;
begin
 ErrorCount := 0;
 cs_Servername := SSL_get_servername(SSL, TLSEXT_NAMETYPE_host_name);

 sDebug.add('REQUEST TO "'+cs_Servername+'"');

 // load the key
 StrPCopy(FileName,pem_Path + cs_Servername + DirectorySeparator + 'key.pem');
 if (SSL_use_PrivateKey_file(SSL, PChar(@FileName), SSL_FILETYPE_PEM) <> 1) then
 begin
   sDebug.add('ERROR: Register Key '+FileName+' fails');
   inc(ErrorCount);
 end;

 // load the cert
 StrPCopy(FileName,pem_Path + cs_Servername + DirectorySeparator + 'cert.pem');
 if (SSL_use_certificate_file(SSL, PChar(@FileName), SSL_FILETYPE_PEM) <> 1) then
 begin
   sDebug.add('ERROR: Register Cert '+FileName+' fails');
   inc(ErrorCount);
 end;

 // is dependency of "key" and "cert" valid?
 if (SSL_check_private_key(SSL)<>1) then
 begin
   sDebug.add('ERROR: Key & Cert : they dont match');
   inc(ErrorCount);
 end;

 if (ErrorCount=0) then
  result := SSL_TLSEXT_ERR_OK
 else
  result := SSL_TLSEXT_ERR_NOACK;
end;

function cb_ALPN(SSL : PSSL; cout: PPChar; outlen: PChar; pin: PChar; inlen: cuint; arg: Pointer) : cint; cdecl;
var
 ErrorCount: integer;
 ProtokollName: ShortString;
 ProtokollNameLength: Byte;
 ParseCount: cuint;
 WeHave_h2 : boolean;
 ClientList: PChar;
begin
 ErrorCount := 0;
 repeat
   if (inlen=0) then
   begin
     sDebug.add('ERROR: Client offers nothing!');
    inc(ErrorCount);
    break;
   end;

   ParseCount := 0;
   WeHave_h2 := false;
   ClientList := pin;

   while (ParseCount<inlen) do
   begin
    ProtokollNameLength := ord(ClientList[0]);
    Move (ClientList^,ProtokollName[0],ProtokollNameLength+1);

    if (ProtokollNameLength=2) then
     if (ProtokollName='h2') then
      WeHave_h2 := true;

    sDebug.add('Client offers Protocol "'+ProtokollName+'"');
    inc(ParseCount,ProtokollNameLength+1);
    inc(ClientList,ProtokollNameLength+1);
   end;

   if not(WeHave_h2) then
   begin
     sDebug.add('ERROR: Client did not offered needed "h2" Protokoll');
     inc(ErrorCount);
     break;
   end;

   // Set result
   case (SSL_select_next_proto(
     { result       } cout, outlen,
     { server wants } @cs_Protokoll_h2, length(cs_Protokoll_h2)+1,
     { client have  } pin,inlen)) of

    OPENSSL_NPN_UNSUPPORTED :begin
          sDebug.add('ERROR: UNSUPPORTED -> No agreement about "h2" Protokoll');
          inc(ErrorCount);
          break;
          end;
    OPENSSL_NPN_NEGOTIATED:begin
           // success!!
     sDebug.add('Agreement about Protocol "'+cs_Protokoll_h2+'"');
          end;
    OPENSSL_NPN_NO_OVERLAP:begin
          sDebug.add('ERROR: NO_OVERLAP -> No agreement about "h2" Protokoll');
          inc(ErrorCount);
          break;
          end;
   else
     sDebug.add('ERROR: UNKOWN -> No agreement about "h2" Protokoll');
     inc(ErrorCount);
     break;
   end;

 until true;

 if (ErrorCount=0) then
  result := SSL_TLSEXT_ERR_OK
 else
  result := SSL_TLSEXT_ERR_ALERT_FATAL;

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

    /////////////////////////////////////
    // import libcrypto functions
    /////////////////////////////////////

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


    /////////////////////////////////////
    // import libssl functions
    /////////////////////////////////////

    OPENSSL_init_ssl :=
      TOPENSSL_init_ssl(GetProcAddress(libssl_HANDLE, 'OPENSSL_init_ssl'));
    if not (assigned(OPENSSL_init_ssl)) then
      sDebug.add(LastError);

   TLS_server_method := TOpenSSL_method(GetProcAddress(libssl_HANDLE, 'TLS_server_method'));
   if not (assigned(TLS_server_method)) then
    sDebug.add(LastError+'TLS_server_method');

{$ifdef TLS12}
TLSv1_2_server_method := TOpenSSL_method(
  GetProcAddress(libssl_HANDLE, 'TLSv1_2_server_method'));
if not (assigned(TLSv1_2_server_method)) then
  sDebug.add(LastError);
{$endif}


    TLS_client_method := TOpenSSL_method(
      GetProcAddress(libssl_HANDLE, 'TLS_client_method'));
    if not (assigned(TLS_client_method)) then
      sDebug.add(LastError);

    SSL_CTX_new := TSSL_CTX_new(GetProcAddress(libssl_HANDLE, 'SSL_CTX_new'));
    if not (assigned(SSL_CTX_new)) then
      sDebug.add(LastError);

    SSL_CTX_ctrl := TSSL_CTX_ctrl(GetProcAddress(libssl_HANDLE, 'SSL_CTX_ctrl'));
    if not (assigned(SSL_CTX_ctrl)) then
     sDebug.add(LastError);

    SSL_CTX_set_cipher_list := TSSL_CTX_set_cipher_list(GetProcAddress(libssl_HANDLE, 'SSL_CTX_set_cipher_list'));
    if not (assigned(SSL_CTX_set_cipher_list)) then
      sDebug.add(LastError);

    SSL_CTX_set_options := TSSL_CTX_set_options(GetProcAddress(libssl_HANDLE, 'SSL_CTX_set_options'));
    if not (assigned(SSL_CTX_set_options)) then
      sDebug.add(LastError);

    SSL_CTX_check_private_key := TSSL_CTX_check_private_key(GetProcAddress(libssl_HANDLE, 'SSL_CTX_check_private_key'));
    if not (assigned(SSL_CTX_check_private_key)) then
      sDebug.add(LastError);

    SSL_check_private_key := TSSL_check_private_key(GetProcAddress(libssl_HANDLE, 'SSL_check_private_key'));
    if not (assigned(SSL_check_private_key)) then
      sDebug.add(LastError);

    SSL_get_version := TSSL_get_version(GetProcAddress(libssl_HANDLE,
    'SSL_get_version'));
    if not (assigned(SSL_get_version)) then
      sDebug.add(LastError);

    SSL_get_current_cipher := TSSL_get_current_cipher(GetProcAddress(libssl_HANDLE,'SSL_get_current_cipher'));
    if not (assigned(SSL_get_current_cipher)) then
      sDebug.add(LastError);

    SSL_CIPHER_description := TSSL_CIPHER_description(GetProcAddress(libssl_HANDLE,'SSL_CIPHER_description'));
    if not (assigned(SSL_CIPHER_description)) then
      sDebug.add(LastError);

    SSL_CTX_use_certificate_file :=
      TSSL_CTX_use_certificate_file(GetProcAddress(libssl_HANDLE,
      'SSL_CTX_use_certificate_file'));
    if not (assigned(SSL_CTX_use_certificate_file)) then
      sDebug.add(LastError);

    SSL_use_certificate_file :=
      TSSL_use_certificate_file(GetProcAddress(libssl_HANDLE,
      'SSL_use_certificate_file'));
    if not (assigned(SSL_use_certificate_file)) then
      sDebug.add(LastError);

    SSL_CTX_use_PrivateKey_file :=
      TSSL_CTX_use_PrivateKey_file(GetProcAddress(libssl_HANDLE,
      'SSL_CTX_use_PrivateKey_file'));
    if not (assigned(SSL_CTX_use_PrivateKey_file)) then
      sDebug.add(LastError);

    SSL_use_PrivateKey_file :=
      TSSL_use_PrivateKey_file(GetProcAddress(libssl_HANDLE,
      'SSL_use_PrivateKey_file'));
    if not (assigned(SSL_use_PrivateKey_file)) then
      sDebug.add(LastError);

    SSL_CTX_use_RSAPrivateKey_file :=
      TSSL_CTX_use_PrivateKey_file(GetProcAddress(libssl_HANDLE,
      'SSL_CTX_use_RSAPrivateKey_file'));
    if not (assigned(SSL_CTX_use_RSAPrivateKey_file)) then
      sDebug.add(LastError);

     SSL_CTX_set_info_callback :=
     TSSL_CTX_set_info_callback(GetProcAddress(libssl_HANDLE,
      'SSL_CTX_set_info_callback'));
    if not (assigned(SSL_CTX_set_info_callback)) then
      sDebug.add(LastError);

    SSL_state_string_long := TSSL_state_string_long(GetProcAddress(libssl_HANDLE,
      'SSL_state_string_long'));
    if not (assigned(SSL_state_string_long)) then
      sDebug.add(LastError);

    SSL_alert_type_string_long := TSSL_alert_type_string_long(GetProcAddress(libssl_HANDLE,
      'SSL_alert_type_string_long'));
    if not (assigned(SSL_alert_type_string_long)) then
      sDebug.add(LastError);

    SSL_alert_desc_string_long := TSSL_alert_desc_string_long(GetProcAddress(libssl_HANDLE,
      'SSL_alert_desc_string_long'));
    if not (assigned(SSL_alert_desc_string_long)) then
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

    SSL_CTX_set_alpn_select_cb :=
    TSSL_CTX_set_alpn_select_cb(GetProcAddress(libssl_HANDLE,
      'SSL_CTX_set_alpn_select_cb'));
    if not (assigned(SSL_CTX_set_alpn_select_cb)) then
      sDebug.add(LastError);

    SSL_select_next_proto :=
    TSSL_select_next_proto(GetProcAddress(libssl_HANDLE,
      'SSL_select_next_proto'));
    if not (assigned(SSL_select_next_proto)) then
      sDebug.add(LastError);

    SSL_pending :=
    TSSL_pending(GetProcAddress(libssl_HANDLE,
    'SSL_pending'));
    if not (assigned(SSL_pending)) then
      sDebug.add(LastError);

    SSL_has_pending :=
    TSSL_pending(GetProcAddress(libssl_HANDLE,
    'SSL_has_pending'));
    if not (assigned(SSL_has_pending)) then
      sDebug.add(LastError);

   SSL_read:= TSSL_read(GetProcAddress(libssl_HANDLE,'SSL_read'));
   if not (assigned(SSL_read)) then
     sDebug.add(LastError);

   SSL_write:= TSSL_write(GetProcAddress(libssl_HANDLE,'SSL_write'));
   if not (assigned(SSL_write)) then
     sDebug.add(LastError);

    (*
    if (CRYPTO_set_mem_functions(@CRYPTO_malloc, @CRYPTO_realloc, @CRYPTO_free) <> 1) then
      sDebug.add('CRYPTO_set_mem_functions fail!');
    *)

    if (OPENSSL_init_ssl(OPENSSL_INIT_LOAD_CRYPTO_STRINGS or OPENSSL_INIT_LOAD_SSL_STRINGS, nil) <> 1) then
      sDebug.add('OPENSSL_init_ssl fail!');
  end
  else
  begin
    sDebug.add(LastError);
  end;
end;

function Version: string;
const
  _OPENSSL_VERSION = 0;
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
  Result := GetLoadErrorStr;
end;

end.
