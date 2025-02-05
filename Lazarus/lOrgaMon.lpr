{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |   l \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2014 - 2024  Andreas Filsinger
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
  |    https://wiki.orgamon.org/
  |
}
program lOrgaMon;

{$APPTYPE CONSOLE}
{$MAXSTACKSIZE $20000000} // 512 MByte
{$codepage cp1252}

{

 l("l" für Lazarus / Linux)OrgaMon

 cOrgaMon ist der Embarcadero/Delphi XMLRPC-Server für Win32
 dieses lOrgaMon ist das Lazarus/FreePascal Gegenstück für die Plattform Win64 und Linux

 Voraussetzungen
 ===============

 1) Online Packages

 indylaz
 zcomponent
 laz_fpspreadsheet
 ibcontrols
 dcpcrypt
 dexif_package

 2) vorliegender Quelltext

 Vergleiche
 ==========

 cOrgaMon | lOrgaMon
 =========+=========
 jcl      | - Wegfall -
 libxml2  | - Wegfall - (keine win64- Portierung vorhanden!)
 wanfix   | - Wegfall -
 flexcel  | fpspreadsheet
 IBO      | zeos + IBX

}

{$mode objfpc}{$H+}


uses
  {$IFDEF UNIX}
  {$IFDEF UseCThreads} cthreads, {$ENDIF}
  cwstring,
  {$ENDIF}
  sysutils,
  Charset,
  Classes,
  Interfaces, ibexpress,
  fpchelper in '..\PASconTools\fpchelper.pas',
  html in '..\PASconTools\html.pas',
  CareTakerClient in '..\PASconTools\CareTakerClient.pas',
  SimplePassword in '..\PASconTools\SimplePassword.pas',
  Geld in '..\PASconTools\Geld.pas',
  SolidFTP in '..\PASconTools\SolidFTP.pas',
  srvXMLRPC in '..\PASconTools\srvXMLRPC.pas',
  OrientationConvert,
  globals,
  Funktionen_Auftrag,
  Funktionen_Basis,
  Identitaet;

{$R *.res}

begin
 setIdentitaetAndRun;
end.
