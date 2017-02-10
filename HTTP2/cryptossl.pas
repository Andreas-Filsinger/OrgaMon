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

function Version : string;


implementation

uses
 dynlibs, ctypes;

const
 cOPENSSL_VERSION = 0;

type 
 TOpenSSL_version = function (t : cInt) : PChar; cdecl;
 
const
 OpenSSL_version : TOpenSSL_version = nil;

function Version : string;
begin
 if assigned(OpenSSL_version) then
  Result := PChar(OpenSSL_version(cOPENSSL_VERSION));
end;            

const
{$ifdef MSWINDOWS}
 cLIB_NAME_SSL     = 'C:\OpenSSL-Win64\bin\libssl-1_1-x64.dll';
 cLIB_NAME_CRYPTO  = 'C:\OpenSSL-Win64\bin\libcrypto-1_1-x64.dll';
{$else}
 cLIB_NAME_SSL     = '/root/Documents/openssl-1.1.0d/libssl.so.1.1';
 cLIB_NAME_CRYPTO  = '/root/Documents/openssl-1.1.0d/libcrypto.so.1.1';
{$endif}

var
 libssl_HANDLE : TLibHandle;
 libcrypto_HANDLE : TLibHandle;

begin
 writeln( paramstr(0));

 // 
 // libssl has dependencys to libcryto, so
 // ensure the correct libcrypto is loaded BEFORE
 // libssl do 'own' but 'false' trys
 libcrypto_HANDLE  := LoadLibrary(cLIB_NAME_CRYPTO);
 writeln(libcrypto_HANDLE);

 libssl_HANDLE  := LoadLibrary(cLIB_NAME_SSL);
 writeln(libssl_HANDLE);

 if (libssl_HANDLE>0) then
 begin
  OpenSSL_version :=  TOpenSSL_version (GetProcedureAddress(libssl_HANDLE, 'OpenSSL_version'));
//  Pointer(OpenSSL_Version) :=  GetProcedureAddress(libssl_HANDLE, 'SSLeay_version');

  writeln(Integer(@OpenSSL_Version));
 end;
end.
