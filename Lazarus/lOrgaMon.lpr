{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |   l \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2014 - 2016  Andreas Filsinger
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
program lOrgaMon;

{$APPTYPE CONSOLE}
{$codepage cp1252}
{$UNDEF UTF8_RTL}
{

 l("l" für Lazarus / Linux)OrgaMon

 cOrgaMon ist der Embarcadero/Delphi XMLRPC-Server für Win32
 dieses lOrgaMon ist das Lazarus/FreePascal Gegenstück für die Plattform Win32 und Linux (Yeah!)


 Voraussetzungen
 ===============

 Indy
 zeos
 fpspreadsheet
 IBX 2.0

 Vergleiche
 ==========

 cOrgaMon | lOrgaMon
 =========+=========
 jcl      | -
 Indy     | Indy
 flexcel  | fpspreadsheet
 IBO      | zeos + IBX
 infozip  | zipper

}

{$mode objfpc}{$H+}


uses
  {$IFDEF UNIX}
  {$IFDEF UseCThreads} cthreads, {$ENDIF}
  cwstring,
  {$ENDIF}
  Crt,
  Windows,
  sysutils, strutils,
  Interfaces,
  CHarset,
  Classes,
  Math,
  inifiles,
  fpchelper in '..\PASconTools\fpchelper.pas',
  anfix32 in '..\PASconTools\anfix32.pas',
  WordIndex in '..\PASconTools\WordIndex.pas',
  gplists in '..\PASconTools\gplists.pas',
  DCPcrypt2 in '..\DCPcrypt\DCPcrypt2.pas',
  DCPmd5 in '..\DCPcrypt\Hashes\DCPmd5.pas',
  html in '..\PASconTools\html.pas',
  CareTakerClient in '..\PASconTools\CareTakerClient.pas',
  SimplePassword in '..\PASconTools\SimplePassword.pas',
  Geld in '..\PASconTools\Geld.pas',
  SolidFTP in '..\PASconTools\SolidFTP.pas',
  sperre in '..\PASconTools\sperre.pas',
  txlib in '..\PASconTools\txlib.pas',
  JonDaExec in '..\JonDaServer\JonDaExec.pas',
  binlager32 in '..\PASconTools\binlager32.pas',
  srvXMLRPC in '..\PASconTools\srvXMLRPC.pas',
  dbOrgaMon in '..\PASconTools\dbOrgaMon.pas',
  txHoliday in '..\PASconTools\txHoliday.pas',
  InfoZIP in '..\infozip\InfoZIP.pas',
  Mapping in '..\PASconTools\Mapping.pas',
  OpenStreetMap in '..\PASconTools\OpenStreetMap.pas',
  globals,
  Funktionen_Auftrag,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_LokaleDaten,
  eConnect,
  indylaz,
  Identitaet,
  FotoExec,
  TestExec;

{$R *.res}

begin
 setIdentitaetAndRun;
end.
