{
  |
  |  Copyright (c) 1990-2009 Info-ZIP.  All rights reserved.
  |
  |  See the accompanying file LICENSE, version 2009-Jan-2 or later
  |  (the contents of which are also included in zip.h) for terms of use.
  |  If, for some reason, all these files are missing, the Info-ZIP license
  |  also may be found at:  ftp://ftp.info-zip.org/pub/infozip/license.html
  |
  |  =========================================================================
  |
  |    infozip.pas is a single unit api - Translation to Delphi for the Windows DLLs
  |
  |    unzip32.dll(6.0)
  |    zip32z64.dll(3.1)
  |
  |    released by infozip.org. API is NOT completed but you can zip and unzip with
  |    common Options. The interface Routines "zip" and "unzip" do a very good job
  |    for me - you may extend functionality. This work was done as a part of ...
  |
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007  Andreas Filsinger
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
unit unzip32d;

interface

uses
  Classes;

const
  unzip_Version: string = 'N/A';
  zip_Version: string = 'N/A';
  cZIPExtension = '.zip';
  infozip_RootPath = 'RootPath';
  infozip_Password = 'Password';
  infozip_Level = 'Level';
  infozip_ExtraInfo = 'ExtraInfos';

var
  zMessages: TStringList;

function zip(sFiles: TStringList; FName: string;
  Options: TStringList = nil): integer { AnzahlDateien } ; overload;
function zip(sFiles: TStringList; FName: string; Options: string): integer
{ AnzahlDateien } ; overload;
function zip(sFile: String; FName: string; Options: string = ''): integer
{ AnzahlDateien } ; overload;

//
// sFiles : Liste der Dateinamen oder "nil" wenn alle Dateien archiviert werden sollen
// FName: Name des neuen Arives, Datei sollte nicht existieren
// Options
// RootPath   = Einstiegsverzeichnis, ab dem rekursiv gesichert werden soll es werden
// Unterverzeichnisnamen als relative Pfade zu RootPath ins Archiv mit
// aufgenommen. Auf RootPath selbst finden sich keine Hinweise im enstehenden
// Archiv. Wird gerne in Verbindung mit sFiles=nil benutzt.
//
// Password   = das globale Passwort, mit dem Alle Dateien verschlüsselt werden sollen
// Level      = der Grad der Komprimierung bzw. die Art des Komprimierungsverfahrens, das
// eingesetzt werden soll. 0 = keine Komprimierung (Store) ... 9 = höchste Komprimierung
// ExtraInfos = genauer Sinn bleibt mir verschlossen: Auf alle Fälle führt es zu nicht deterministischen
// Zips. Deshalb wird es bei alles Tests deaktiviert, sonst lasse ich es auf Default
// also incl. der Extra infos!

function unzip(FName: string; Destination: string;
  Options: TStringList = nil): integer { AnzahlDateien } ;

procedure ZpLoad;
procedure ZpUnload;

implementation

uses
  windows, SysUtils;

// globals
type
  z_uint8 = int64;
  z_unsigned = word;

  // Version - Stuff
  _version_type = packed record
    major: byte; (* e.g., integer 5 *)
    minor: byte; (* e.g., 2 *)
    patchlevel: byte; (* e.g., 0 *)
    not_used: byte;
  end;

  (*
    See api.c for exactly what UzpVersion does, but the short description is
    "UzpVersion() returns a pointer to a dll-internal static structure
    containing the unzip32.dll version information".

    For usage with languages that do not support function which return pointers
    to structures, the variant UzpVersion2() allows to retrieve the version info
    into a memory area supplied by the caller:
  *)

type
  UzpVer2 = packed record
    structlen: longword; (* length of the struct being passed *)
    flag: longword; (* bit 0: is_beta   bit 1: uses_zlib *)
    betalevel: array [0 .. 9] of AnsiChar; (* e.g. "g BETA" or "" *)
    date: array [0 .. 19] of AnsiChar;
    (* e.g. "9 Oct 08" (beta) or "9 October 2008" *)
    zlib_version: array [0 .. 9] of AnsiChar; (* e.g. "1.2.3" or NULL *)
    unzip: _version_type; (* current UnZip version *)
    zipinfo: _version_type; (* current ZipInfo version *)
    os2dll: _version_type; (* OS2DLL version (retained for compatibility) *)
    windll: _version_type; (* WinDLL version (retained for compatibility) *)
    dllapimin: _version_type; (* last incompatible change of library API *)
  end;

  LPUzpVer2 = ^UzpVer2;

  ZpVer = packed record
    structlen: longword; (* length of the struct being passed *)
    flag: longword; (* bit 0: is_beta   bit 1: uses_zlib *)
    betalevel: array [0 .. 9] of AnsiChar; (* e.g., "g BETA" or "" *)
    date: array [0 .. 19] of AnsiChar;
    (* e.g., "4 Sep 95" (beta) or "4 September 1995" *)
    zlib_version: array [0 .. 9] of AnsiChar; (* e.g., "0.95" or NULL *)
    fEncryption: LongBool; (* TRUE if encryption enabled, FALSE otherwise *)
    zip: _version_type;
    os2dll: _version_type;
    windll: _version_type;
  end;

  LPZpVer = ^ZpVer;

  // typedef int (WINAPI DLLPRNT) (LPSTR, unsigned long);
  DLLPRNT = function(buffer: PAnsiChar; bufsiz: longword): integer; stdcall;

  // typedef int (WINAPI DLLPASSWORD) (LPSTR pwbuf, int bufsiz, LPCSTR promptmsg, LPCSTR entryname);
  DLLPASSWORD = function(pwbuf: PAnsiChar; bufsiz: integer;
    promptmsg, entryname: PAnsiChar): integer; stdcall;

  // unzip: typedef int (WINAPI DLLSERVICE) (LPCSTR entryname, z_uint8 uncomprsiz);
  // zip: typedef int (WINAPI DLLSERVICE) (LPCSTR, unsigned __int64);
  DLLSERVICE = function(entryname: PAnsiChar; uncomprsiz: z_uint8): integer;
    stdcall;
  // zip: typedef int (WINAPI DLLSERVICE_NO_INT64) (LPCSTR, unsigned long, unsigned long);
  DLLSERVICE_NO_INT64 = function(Msg: PAnsiChar; sizHi: longword;
    sizLo: longword): integer; stdcall;

  // typedef int (WINAPI DLLSERVICE_I32) (LPCSTR entryname, unsigned long ucsz_lo, unsigned long ucsz_hi);

  // typedef void (WINAPI DLLSND) (void);
  DLLSND = procedure; stdcall;
  // typedef int (WINAPI DLLREPLACE) (LPSTR efnam, unsigned efbufsiz);
  DLLREPLACE = function(efnam: PAnsiChar; efbufsiz: word): integer; stdcall;

  // typedef void (WINAPI DLLMESSAGE) (z_uint8 ucsize, z_uint8 csize,
  // unsigned cfactor,    unsigned mo, unsigned dy, unsigned yr, unsigned hh, unsigned mm,
  // char c, LPCSTR filename, LPCSTR methbuf, unsigned long crc, char fCrypt);
  DLLMESSAGE = procedure(ucsize, csiz: z_uint8;
    cfactor, mo, dy, yr, hh, mm: z_unsigned; c: byte; FName, meth: PAnsiChar;
    crc: longword; fCrypt: byte); stdcall;

  // typedef void (WINAPI DLLMESSAGE_I32) (unsigned long ucsiz_l,
  // unsigned long ucsiz_h, unsigned long csiz_l, unsigned long csiz_h,
  // unsigned cfactor,
  // unsigned mo, unsigned dy, unsigned yr, unsigned hh, unsigned mm,
  // char c, LPCSTR filename, LPCSTR methbuf, unsigned long crc, char fCrypt);
  DLLVOID = function: integer; stdcall;

  // zip: typedef int (WINAPI DLLSPLIT) (LPSTR);
  DLLSPLIT = function(mPart: PAnsiChar): integer; stdcall;
  // zip: typedef int (WINAPI DLLCOMMENT)(LPSTR);
  DLLCOMMENT = function(mComment: PAnsiChar): integer; stdcall;

  USERFUNCTIONS = packed record

    print: DLLPRNT;
    sound: DLLSND;
    replace: DLLREPLACE;
    password: DLLPASSWORD;
    SendApplicationMessage: DLLMESSAGE;
    ServCallBk: DLLSERVICE;
    SendApplicationMessage_i32: DLLVOID;
    ServCallBk_i32: DLLVOID;

    TotalSizeComp: z_uint8;
    TotalSize: z_uint8;
    NumMembers: z_uint8;
    CompFactor: z_unsigned;
    cchComment: word;
  end;

  LPUSERFUNCTIONS = ^USERFUNCTIONS;

const
  (* The following symbol UZ_DCL_STRUCTVER must be incremented whenever an
    * incompatible change is applied to the WinDLL API structure "DCL" !
    *)
  UZ_DCL_STRUCTVER = $600;

type
  DCL = packed record
    (* The structure "DCL" is collects most the UnZip WinDLL program options
      * that control the operation of the main UnZip WinDLL function.
      *)
    StructVersID: integer; (* struct version id (= UZ_DCL_STRUCTVER) *)
    ExtractOnlyNewer: integer; (* TRUE for "update" without interaction
      (extract only newer/new files, without queries) *)
    SpaceToUnderscore: integer; (* TRUE if convert space to underscore *)
    PromptToOverwrite: integer; (* TRUE if prompt to overwrite is wanted *)
    fQuiet: integer; (* quiet flag:
      { 0 = all | 1 = few | 2 = no } messages *)
    ncflag: integer; (* write to stdout if TRUE *)
    ntflag: integer; (* test zip file *)
    nvflag: integer; (* verbose listing *)
    nfflag: integer; (* "freshen" (replace existing files by newer versions) *)
    nzflag: integer; (* display zip file comment *)
    ndflag: integer; (* controls (sub)dir recreation during extraction
      0 = junk paths from filenames
      1 = "safe" usage of paths in filenames (skip ../)
      2 = allow unsafe path components (dir traversal)
      *)
    noflag: integer; (* always overwriting existing files if TRUE *)
    naflag: integer; (* do end-of-line translation *)
    nZIflag: integer; (* get ZipInfo output if TRUE *)
    B_flag: integer; (* backup existing files if TRUE *)
    C_flag: integer; (* be case insensitive if TRUE *)
    D_flag: integer; (* controls restoration of timestamps
      0 = restore all timestamps (default)
      1 = skip restoration of timestamps for folders
      created on behalf of directory entries in the
      Zip archive
      2 = no restoration of timestamps; extracted files
      and dirs get stamped with current time *)
    U_flag: integer; (* controls UTF-8 filename coding support
      0 = automatic UTF-8 translation enabled (default)
      1 = recognize UTF-8 coded names, but all non-ASCII
      characters are "escaped" into "#Uxxxx"
      2 = UTF-8 support is disabled, filename handling
      works exactly as in previous UnZip versions *)
    fPrivilege: integer; (* 1 => restore ACLs in user mode,
      2 => try to use privileges for restoring ACLs *)
    lpszZipFN: PAnsiChar; (* zip file name *)
    lpszExtractDir: PAnsiChar; (* directory to extract to. This should be NULL if
      you are extracting to the current directory. *)
  end;

  LPDCL = ^DCL;

  ZPOPT = packed record (* zip options *)
    date: PAnsiChar; (* Date to include after *)
    szRootDir: PAnsiChar; (* Directory to use as base for zipping *)
    szTempDir: PAnsiChar; (* Temporary directory used during zipping *)
    fTemp: LongBool; (* Use temporary directory '-b' during zipping *)
    fMisc: integer; (* (was fsuffix) Misc data flags (was "include suffixes") *)
    (* Add values to set flags
      1 = include suffixes (not implemented)
      2 = no UTF8          Ignore UTF-8 information (except native)
      4 = native UTF8      Store UTF-8 as native character set
    *)
    fEncrypt: integer; (* encrypt method (was "encrypt files") *)
    (* Currently only one encryption method
      1 = standard encryption
    *)

    fSystem: LongBool; (* include system and hidden files *)
    fVolume: LongBool; (* Include volume label *)
    fExtra: LongBool; (* Exclude extra attributes *)
    fNoDirEntries: LongBool; (* Do not add directory entries *)
    fExcludeDate: LongBool; (* Exclude files newer than specified date *)
    fIncludeDate: LongBool; (* Include only files newer than specified date *)
    fVerbose: LongBool; (* Mention oddities in zip file structure *)
    fQuiet: LongBool; (* Quiet operation *)
    fCRLF_LF: LongBool; (* Translate CR/LF to LF *)
    fLF_CRLF: LongBool; (* Translate LF to CR/LF *)
    fJunkDir: LongBool; (* Junk directory names *)
    fGrow: LongBool; (* Allow appending to a zip file *)
    fForce: LongBool; (* Make entries using DOS names (k for Katz) *)
    fMove: LongBool; (* Delete files added or updated in zip file *)
    fDeleteEntries: LongBool; (* Delete files from zip file *)
    fUpdate: LongBool; (* Update zip file--overwrite only if newer *)
    fFreshen: LongBool; (* Freshen zip file--overwrite only *)
    fJunkSFX: LongBool; (* Junk SFX prefix *)
    fLatestTime: LongBool; (* Set zip file time to time of latest file in it *)
    fComment: LongBool; (* Put comment in zip file *)
    fOffsets: LongBool; (* Update archive offsets for SFX files *)
    fPrivilege: LongBool; (* Use privileges (WIN32 only) *)
    fEncryption: LongBool; (* TRUE if encryption supported (compiled in), else FALSE.
      this is a read only flag *)
    szSplitSize: PAnsiChar; (* This string contains the size that you want to
      split the archive into. i.e. 100 for 100 bytes,
      2K for 2 k bytes, where K is 1024, m for meg
      and g for gig. If this string is not NULL it
      will automatically be assumed that you wish to
      split an archive. *)
    szIncludeList: PAnsiChar; (* Pointer to include file list string (for VB) *)
    IncludeListCount: longword;
    (* Count of file names in the include list array *)
    IncludeList: pointer; (* Pointer to include file list array. Note that the last
      entry in the array must be NULL *)
    szExcludeList: pointer; (* Pointer to exclude file **list (for VB) *)
    ExcludeListCount: longword;
    (* Count of file names in the include list array *)
    ExcludeList: pointer; (* Pointer to exclude file **list array. Note that the last
      entry in the array must be NULL *)
    fRecurse: integer; (* Recurse into subdirectories. 1 => -r, 2 => -R *)
    fRepair: integer; (* Repair archive. 1 => -F, 2 => -FF *)
    fLevel: byte; (* Compression level (0 - 9) *)
  end;

  LPZPOPT = ^ZPOPT;

  ZCL = packed record
    argc: integer; (* Count of files to zip *)
    lpszZipFN: PAnsiChar; (* name of archive to create/update *)
    FNV: pointer; (* **array of file names to zip up *)
    lpszAltFNL: PAnsiChar; (* pointer to a string containing a list of file
      names to zip up, separated by whitespace. Intended
      for use only by VB users, all others should set this
      to NULL. *)
  end;

  LPZCL = ^ZCL;

  ZIPUSERFUNCTIONS = packed record
    print: DLLPRNT;
    comment: DLLCOMMENT;
    password: DLLPASSWORD;
    split: DLLSPLIT; (* This MUST be set to NULL unless you want to be queried
      for a destination for each split archive. *)
    ServiceApplication64: DLLSERVICE;
    ServiceApplication64_No_Int64: DLLSERVICE_NO_INT64;
  end;

  LPZIPUSERFUNCTIONS = ^ZIPUSERFUNCTIONS;

  // Globale Variable

var
  FileCount: integer;
  FilePassword: string;
  UnzipVersionInfo: LPUzpVer2;
  ZipVersionInfo: LPZpVer;
  ZipCallBacks: LPZIPUSERFUNCTIONS;
  CallBackControl: LPUSERFUNCTIONS;
  hunzip32: HMODULE;
  hzip32z64: HMODULE;

  // Call Back - Implementation

function _DLLPRNT(buffer: PAnsiChar; bufsiz: longword): integer; stdcall; far;
begin
  zMessages.add(format('prnt %d %s', [bufsiz, buffer]));
  result := 0;
end;

function _DLLPASSWORD(pwbuf: PAnsiChar; bufsiz: integer;
  promptmsg, entryname: PAnsiChar): integer; stdcall; far;
begin
  zMessages.add(format('pwd %s %s', [promptmsg, entryname]));
  StrPCopy(pwbuf, copy(FilePassword, 1, pred(bufsiz)));
  result := 0;
end;

function _DLLSERVICE(entryname: PAnsiChar; uncomprsiz: z_uint8): integer;
  stdcall; far;
begin
  zMessages.add(format('service %d %s', [uncomprsiz, entryname]));
  inc(FileCount);
  result := 0;
end;

procedure _DLLSND; stdcall; far;
begin

end;

function _DLLREPLACE(efnam: PAnsiChar; efbufsiz: word): integer; stdcall; far;
begin
  result := 0;
end;

procedure _DLLMESSAGE(ucsize, csiz: z_uint8;
  cfactor, mo, dy, yr, hh, mm: z_unsigned; c: byte; FName, meth: PAnsiChar;
  crc: longword; fCrypt: byte); stdcall; far;
begin
  zMessages.add('message ' + FName);
end;

// Used DLL-Functions
type

  // Version-Info: to ensure correct DLL
  Tunzip32_UzpVersion2 = function(ver2: LPUzpVer2): integer; stdcall;
  Tzip32z64_ZpVersion = function(ver: LPZpVer): integer; stdcall;


  // #### unzip ####

  Tunzip32_Wiz_SingleEntryUnzip = function(ifnc: integer; ifnv: pointer;
    xfnc: integer; xfnv: pointer; DCL: LPDCL;
    UserFunc: LPUSERFUNCTIONS): integer; stdcall;
  (*
    where the arguments are:

    ifnc       = number of file names being passed. If all files are to be
    extracted, then this can be zero.
    ifnv       = file names to be unarchived. Wildcard patterns are recognized
    and expanded. If all files are to be extracted, then this can
    be NULL.
    xfnc       = number of "file names to be excluded from processing" being
    passed. If all files are to be extracted, set this to zero.
    xfnv       = file names to be excluded from the unarchiving process. Wildcard
    characters are allowed and expanded. If all files are to be
    extracted, set this argument to NULL.
    lpDCL      = pointer to a structure with the flags for setting the
    various options, as well as the zip file name.
    lpUserFunc = pointer to a structure that contains pointers to functions
    in the calling application, as well as sizes passed back to
    the calling application etc. See below for a detailed description
    of all the parameters.
  *)

  // #### zip ####

  Tzip32z64_ZpInit = function(lpZipUserFunc: LPZIPUSERFUNCTIONS): integer;
    stdcall;
  Tzip32z64_ZpArchive = function(c: ZCL; Opts: LPZPOPT): integer; stdcall;

var
  // zip
  ZpVersion: Tzip32z64_ZpVersion;
  ZpInit: Tzip32z64_ZpInit;
  ZpArchive: Tzip32z64_ZpArchive;
  // unzip
  UzpVersion2: Tunzip32_UzpVersion2;
  Wiz_SingleEntryUnzip: Tunzip32_Wiz_SingleEntryUnzip;


  // #### tools ####

function NextP(var s: string; Delimiter: string): string;
var
  k: integer;
begin
  k := pos(Delimiter, s);
  if k > 0 then
  begin
    result := copy(s, 1, pred(k));
    delete(s, 1, pred(k + length(Delimiter)));
  end
  else
  begin
    result := s;
    s := '';
  end;
end;

function split(s: string; Delimiter: string = ';';
  Quote: string = ''): TStringList;
var
  QuoteLength: integer;
  QuoteEnd: integer;
begin
  QuoteLength := length(Quote);
  result := TStringList.Create;
  if (QuoteLength = 0) then
  begin
    while (s <> '') do
      result.add(NextP(s, Delimiter));
  end
  else
  begin
    while (s <> '') do
    begin
      if (pos(Quote, s) = 1) then
      begin
        System.delete(s, 1, QuoteLength);
        QuoteEnd := pos(Quote, s);
        if QuoteEnd = 0 then
        begin
          // ERROR: closing Quote expected
          result.add(s);
          s := '';
        end
        else
        begin
          result.add(copy(s, 1, pred(QuoteEnd)));
          System.delete(s, 1, pred(QuoteEnd + QuoteLength));
          NextP(s, Delimiter);
        end;
      end
      else
      begin
        result.add(NextP(s, Delimiter));
      end;
    end;
  end;
end;

// End - User - API

function zip(sFiles: TStringList; FName: string;
  Options: TStringList = nil): integer;
var
  FilesStore: pointer;
  FilesStoreCount: integer;

  procedure FS_fill(s: TStrings);
  var
    n: integer;
    StoreP: ^pointer;
    StoreS: PAnsiChar;
  begin
    FilesStoreCount := s.Count;
    GetMem(FilesStore, sizeof(pointer) * FilesStoreCount + 1);
    StoreP := FilesStore;
    for n := 0 to pred(s.Count) do
    begin
      GetMem(StoreS, length(s[n]) + 1);
      StoreP^ := StrPCopy(StoreS, s[n]);
      inc(integer(StoreP), sizeof(pointer));
    end;
    StoreP^ := nil;
  end;

  procedure FS_free;
  var
    n: integer;
    StoreS: ^pointer;
  begin
    StoreS := FilesStore;
    for n := 1 to FilesStoreCount do
    begin
      FreeMem(StoreS^);
      inc(integer(StoreS), sizeof(pointer));
    end;
    FreeMem(FilesStore);
  end;

var
  ZipOptions: LPZPOPT;
  ZipControl: ZCL;
  oRootDir: array [0 .. 1023] of AnsiChar;
  oArchiveName: array [0 .. 1023] of AnsiChar;
  sFilesInternal: TStringList;
begin
  // Pre Check
  if sizeof(pointer) <> sizeof(integer) then
    raise exception.Create('zip: Pointer Increment will fail!');

  // Init
  zMessages.clear;
  FileCount := 0;
  StrPCopy(oArchiveName, FName);
  sFilesInternal := TStringList.Create;

  repeat

    if not(assigned(sFiles)) then
    begin
      sFilesInternal.add('*');
      break;
    end;

    if (sFiles.Count = 0) then
    begin
      sFilesInternal.add('*');
      break;
    end;

    sFilesInternal.addstrings(sFiles);

  until true;

  FS_fill(sFilesInternal);

  new(ZipOptions);

  // default init
  fillchar(ZipOptions^, sizeof(ZPOPT), 0);
  FilePassword := '';

  with ZipOptions^ do
  begin
    if assigned(Options) then
    begin

      // Recurse SubDirs
      if (Options.Values[infozip_RootPath] <> '') then
      begin
        StrPCopy(oRootDir, Options.Values[infozip_RootPath]);
        szRootDir := oRootDir;
        fRecurse := 1;
      end
      else
      begin
        fNoDirEntries := true;
        fJunkDir := true;
      end;

      // Password
      if (Options.Values[infozip_Password] <> '') then
      begin
        FilePassword := Options.Values[infozip_Password];
        fEncrypt := 1;
      end;

      // Compression Level
      if (Options.Values[infozip_Level] <> '') then
        fLevel := ord(Options.Values[infozip_Level][1])
      else
        fLevel := ord('9');

      // Extra Infos
      if (Options.Values[infozip_ExtraInfo] = '0') then
        fExtra := true;

    end
    else
    begin

      // Defaults!
      fNoDirEntries := true;
      fJunkDir := true;
      fLevel := ord('9');
    end;
  end;

  fillchar(ZipControl, sizeof(ZCL), 0);
  with ZipControl do
  begin
    lpszZipFN := oArchiveName;
    argc := FilesStoreCount;
    FNV := FilesStore;
  end;

  DeleteFile(FName);
  result := ZpArchive(ZipControl, ZipOptions);
  if result = 0 then
    result := FileCount
  else
    result := -result;

  dispose(ZipOptions);
  sFilesInternal.free;
  FS_free;
end;

function zip(sFiles: TStringList; FName: string; Options: string): integer
{ AnzahlDateien } ; overload;
var
  sOptions: TStringList;
begin
  sOptions := split(Options);
  result := zip(sFiles, FName, sOptions);
  sOptions.free;
end;

function zip(sFile: String; FName: string; Options: string): integer
{ AnzahlDateien } ; overload;
var
  sOptions: TStringList;
  sFiles: TStringList;
begin
  sFiles := split(sFile);
  sOptions := split(Options);
  result := zip(sFiles, FName, sOptions);
  sOptions.free;
  sFiles.free;
end;

function unzip(FName: string; Destination: string;
  Options: TStringList = nil): integer;
var
  Parameter: LPDCL;
  oArchiveName: array [0 .. 1023] of AnsiChar;
  oDestination: array [0 .. 1023] of AnsiChar;
begin
  zMessages.clear;
  FileCount := 0;
  StrPCopy(oArchiveName, FName);
  StrPCopy(oDestination, Destination);

  new(Parameter);
  fillchar(Parameter^, sizeof(DCL), 0);
  FilePassword := '';

  with Parameter^ do
  begin
    StructVersID := UZ_DCL_STRUCTVER;
    fQuiet := 1; // nicht so viel ausgaben (speed wanted)
    noflag := 1; // vorhandenes überschreiben
    ndflag := 1; // subdirs erstellen
    lpszZipFN := oArchiveName;
    lpszExtractDir := oDestination;
    if assigned(Options) then
      if (Options.Values[infozip_Password] <> '') then
        FilePassword := Options.Values[infozip_Password];
  end;

  result := Wiz_SingleEntryUnzip(0, nil, 0, nil, Parameter, CallBackControl);
  if result = 0 then
    result := FileCount
  else
    result := -result;

  fillchar(Parameter^, sizeof(DCL), 0);

  dispose(Parameter);
end;

procedure ZpLoad;
var
  LibFName: array [0 .. 1023] of char;
begin

  // zip dynamic load
  hzip32z64 := LoadLibrary('zip32z64.dll');
  if hzip32z64 = 0 then
    halt;
  ZpVersion := Tzip32z64_ZpVersion(GetProcAddress(hzip32z64, 'ZpVersion'));
  ZpInit := Tzip32z64_ZpInit(GetProcAddress(hzip32z64, 'ZpInit'));
  ZpArchive := Tzip32z64_ZpArchive(GetProcAddress(hzip32z64, 'ZpArchive'));

  // unzip dynamic load
  StrPCopy(LibFName, ExtractFilePath(paramstr(0)) + 'UNZIP32static.DLL');
  hunzip32 := LoadLibrary(LibFName);
  if hunzip32 = 0 then
    halt;
  UzpVersion2 := Tunzip32_UzpVersion2(GetProcAddress(hunzip32, 'UzpVersion2'));
  Wiz_SingleEntryUnzip := Tunzip32_Wiz_SingleEntryUnzip
    (GetProcAddress(hunzip32, 'Wiz_SingleEntryUnzip'));

end;

procedure ZpUnload;
begin
  FreeLibrary(hunzip32);
  FreeLibrary(hzip32z64);
  fillchar(ZipCallBacks^, sizeof(ZIPUSERFUNCTIONS), 0);
  fillchar(CallBackControl^, sizeof(USERFUNCTIONS), 0);
end;

begin
  zMessages := TStringList.Create;
  ZpLoad;

  // ZIP Versions-Nummer
  new(ZipVersionInfo);
  fillchar(ZipVersionInfo^, sizeof(ZpVer), 0);
  ZipVersionInfo^.structlen := sizeof(ZpVer);
  ZpVersion(ZipVersionInfo);

  with ZipVersionInfo^ do
    zip_Version := format('zip %d.%d.%d%s (%s)', [zip.major, zip.minor,
      zip.patchlevel, betalevel, date]);

  // UNZIP Versions-Nummer
  new(UnzipVersionInfo);
  fillchar(UnzipVersionInfo^, sizeof(UzpVer2), 0);
  UnzipVersionInfo^.structlen := sizeof(UzpVer2);
  UzpVersion2(UnzipVersionInfo);

  with UnzipVersionInfo^ do
    unzip_Version := format('unzip %d.%d.%d%s (%s)', [unzip.major, unzip.minor,
      unzip.patchlevel, betalevel, date]);

  // ZIP - DLL - Init
  new(ZipCallBacks);
  fillchar(ZipCallBacks^, sizeof(ZIPUSERFUNCTIONS), 0);
  with ZipCallBacks^ do
  begin
    print := _DLLPRNT;
    password := _DLLPASSWORD;
    ServiceApplication64 := _DLLSERVICE;
  end;
  ZpInit(ZipCallBacks);

  // UNZIP - DLL - Init
  new(CallBackControl);
  fillchar(CallBackControl^, sizeof(USERFUNCTIONS), 0);
  with CallBackControl^ do
  begin
    print := _DLLPRNT;
    replace := _DLLREPLACE;
    password := _DLLPASSWORD;
    SendApplicationMessage := _DLLMESSAGE;
    ServCallBk := _DLLSERVICE;
  end;

end.
