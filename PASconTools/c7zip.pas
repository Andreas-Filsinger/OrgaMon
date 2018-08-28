{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2018  Andreas Filsinger
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
  |    A simple commandline-Interface to 7zip - (c) 2018 Andreas Filsinger
}
unit c7zip;

interface

uses
  Classes;

const
  Version: string = 'N/A';

  cZIPExtension = '.zip';
  czip_set_RootPath = 'RootPath';
  czip_set_Password = 'Password';
  czip_set_Level = 'Level';

  { zip(sFiles,FName,Options)
    |
    |  sFiles  :      Liste der Dateinamen oder "nil" wenn alle Dateien archiviert werden sollen
    |  FName   :      Name des neuen Archives, Datei sollte nicht existieren
    |  Options :
    |    RootPath   = Einstiegsverzeichnis, ab dem rekursiv gesichert werden soll es werden
    |                 Unterverzeichnisnamen als relative Pfade zu RootPath ins Archiv mit
    |                 aufgenommen. Auf RootPath selbst finden sich keine Hinweise im enstehenden
    |                 Archiv. Wird gerne in Verbindung mit sFiles=nil benutzt.
    |
    |    Password   = das globale Passwort, mit dem alle Dateien verschlüsselt werden sollen
    |    Level      = der Grad der Komprimierung bzw. die Art des Komprimierungsverfahrens, das
    |                 eingesetzt werden soll.
    |                   = höchste Komprimierung (default)
    |                 0 = keine Komprimierung (Store) ...
  }

function zip(sFiles: TStringList; FName: string; Options: TStringList = nil) : integer { AnzahlDateien }; overload;

// Options-Delimiter = ";"
function zip(sFiles: TStringList; FName: string; Options: string) : integer { AnzahlDateien }; overload;

// Options-Delimiter = ";"
function zip(sFile: String; FName: string; Options: string = '') : integer { AnzahlDateien }; overload;

{ unzip(FName,Destination,Options)
  |
  |  FName       :   Name des bestehenden Archives, das ausgepackt werden soll
  |  Destination :   Verzeichnis, in das entpackt werden soll
  |  Options     :
  |     Password   = das globale Passwort, welches beim Auspacken benutzt wird
}

function unzip(FName: string; Destination: string; Options: TStringList = nil) : integer { AnzahlDateien };

implementation

uses
 windows, SysUtils,
 anfix32, Systemd;

const
 c7zip_app : string = '';

procedure ensure7zip;
begin
 if (c7zip_app='') then
 begin

  repeat

    c7zip_app := ProgramFilesDir + '7-zip\7z.exe';
    if FileExists(c7zip_app) then
      break;

    c7zip_app := 'C:\Program Files\7-zip\7z.exe';
    if FileExists(c7zip_app) then
      break;

    c7zip_app := 'C:\Program Files (x86)\7-zip\7z.exe';
    if FileExists(c7zip_app) then
      break;

    raise Exception.create('Keine 7zip-Installation gefunden!');

  until yet;
  c7zip_app := '"' + c7zip_app + '"';

 end;
end;

function zip(sFiles: TStringList; FName: string; Options: TStringList = nil) : integer { AnzahlDateien }; overload;
var
 Switches : string;
 RootPath : string;
 WorkWithFileList : boolean;
 CompressionLevel_Switch : string;
 ReturnCode : Cardinal;
 n : Integer;
begin
  result := 0;
  CompressionLevel_Switch := '';

  // set RootPath
  if assigned(options) then
   RootPath := Options.Values[czip_set_RootPath]
  else
   RootPath := '';

  if assigned(sFiles) then
  begin

    if (RootPath<>'') then
    begin
      if not(SetCurrentDir(RootPath)) then
       exit; // ERROR: Can not set current Dir to RootPath=
      for n := 0 to pred(sFiles.Count) do
       if (pos(RootPath,sFiles[n])=1) then
        sFiles[n] := copy(sFiles[n],length(RootPath)+1,MaxInt);
    end;
    sFiles.SaveToFile(FName+'.txt', TEncoding.UTF8);

    WorkWithFileList := true;
  end else
  begin

   if not(assigned(Options)) then
    exit; // ERROR: You need the Options with "RootPath=" if you dont have a FileList
   if (Options.Values[czip_set_RootPath]='') then
    exit; // ERROR: You need to set "RootPath=" if you dont have a FileList
   if not(DirExists(Options.Values[czip_set_RootPath])) then
    exit; // ERROR: "RootPath=" does not exist or is not accessable

   WorkWithFileList := false;
  end;

  Switches := '';
  if assigned(Options) then
  begin
      if (Options.Values[czip_set_Password] <> '') then
      begin
       Switches := Switches + '-mem=AES256 -p"'+Options.Values[czip_set_Password]+'" ';
      end;

      if (Options.Values[czip_set_Level] = '0') then
      begin
       CompressionLevel_Switch := '-mm=Copy ';
      end;
  end;

  // defaults
  if (CompressionLevel_Switch='') then
   CompressionLevel_Switch := '-mm=Deflate64 ';
  if WorkWithFileList then
   if (RootPath<>'') then
     Switches := Switches + '-spf ';

  if FileExists(FName) then
   DeleteFile(FName);
  ensure7zip;
  if WorkWithFileList then
  begin
    ReturnCode := CallExternalApp(
     {} c7zip_app + ' ' +
     {} 'a -tZip -mcu=on ' +
     {} CompressionLevel_Switch +
     {} Switches +
     {} '"' + FName + '" ' +
     {} '@"' + FName + '.txt"',
     {} SW_HIDE);
     DeleteFile(FName+'.txt');
  end else
  begin
    ReturnCode := CallExternalApp(
     {} c7zip_app + ' ' +
     {} 'a -tZip -mcu=on ' +
     {} CompressionLevel_Switch +
     {} Switches +
     {} '"' + FName + '" ' +
     {} '"' + Options.Values[czip_set_RootPath] + '*"',
     {} SW_HIDE);
  end;

  if (ReturnCode>1) then
   exit; // ERROR: 7z Program reports an error

  if FileExists(FName) then
  begin
   if WorkWithFileList then
    result := sFiles.count
   else
    result := 1;
  end;

end;

function zip(sFiles: TStringList; FName: string; Options: string): integer { AnzahlDateien }; overload;
var
  sOptions: TStringList;
begin
  sOptions := split(Options);
  result := zip(sFiles, FName, sOptions);
  sOptions.free;
end;

function zip(sFile: String; FName: string; Options: string): integer { AnzahlDateien }; overload;
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

function unzip(FName: string; Destination: string; Options: TStringList = nil) : integer { AnzahlDateien };
var
 CommandLine : string;
 ReturnCode : Cardinal;
begin
 result := 0;
 if not(FileExists(FName)) then
   raise exception.Create('ERROR: ' + FName + ' nicht gefunden');

 // e"x"tract, "y" to all overwrite messages
 CommandLine := 'x -y ';

 // Password
 if assigned(Options) then
  if (Options.Values[czip_set_Password] <> '') then
   CommandLine := CommandLine + '-p"' + Options.Values[czip_set_Password] + '" ';

 // Destinati"o"n
 CommandLine := CommandLine + '-o"' + Destination + '" "' + FName + '"';

 ensure7zip;
 ReturnCode := CallExternalApp(
  {} c7zip_app + ' ' +
  {} CommandLine,
  {} SW_HIDE);

 if (ReturnCode>2) then
  exit;

 result := 1;
end;

end.
