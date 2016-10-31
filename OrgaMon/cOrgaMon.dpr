{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2012 - 2016  Andreas Filsinger
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
program cOrgaMon;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Classes,
  math,
  inifiles,
  IB_Session,
  anfix32 in '..\PASconTools\anfix32.pas',
  globals in 'globals.pas',
  WordIndex in '..\PASconTools\WordIndex.pas',
  gplists in '..\PASconTools\gplists.pas',
  html in '..\PASconTools\html.pas',
  CareTakerClient in '..\PASconTools\CareTakerClient.pas',
  SimplePassword in '..\PASconTools\SimplePassword.pas',
  Geld in '..\PASconTools\Geld.pas',
  SolidFTP in '..\PASconTools\SolidFTP.pas',
  sperre in '..\PASconTools\sperre.pas',
  txlib in '..\PASconTools\txlib.pas',
  binlager32 in '..\PASconTools\binlager32.pas',
  srvXMLRPC in '..\PASconTools\srvXMLRPC.pas',
  dbOrgaMon in '..\PASconTools\dbOrgaMon.pas',
  txHoliday in '..\PASconTools\txHoliday.pas',
  infozip in '..\infozip\infozip.pas',
  Mapping in '..\PASconTools\Mapping.pas',
  GHD_pngimage in '..\PASconTools\GHD_pngimage.pas',
  GHD_pnglang in '..\PASconTools\GHD_pnglang.pas',
  CCR.Exif.StreamHelper in '..\ccr-exif\CCR.Exif.StreamHelper.pas',
  CCR.Exif.TagIDs in '..\ccr-exif\CCR.Exif.TagIDs.pas',
  CCR.Exif.XMPUtils in '..\ccr-exif\CCR.Exif.XMPUtils.pas',
  eConnect in 'eConnect.pas',
  OpenStreetMap in '..\PASconTools\OpenStreetMap.pas',
  Funktionen_Auftrag in 'Funktionen_Auftrag.pas',
  Funktionen_Basis in 'Funktionen_Basis.pas',
  Funktionen_Beleg in 'Funktionen_Beleg.pas',
  Funktionen_LokaleDaten in 'Funktionen_LokaleDaten.pas',
  OrientationConvert in '..\PASconTools\OrientationConvert.pas',
  libxml2 in '..\libxml2\libxml2.pas',
  ExcelHelper in '..\PASconTools\ExcelHelper.pas',
  basic32 in '..\PASconTools\basic32.pas',
  DTA in '..\PASconTools\DTA.PAS',
  memcache in '..\PASconTools\memcache.pas',
  Foto in '..\PASconTools\Foto.pas',
  JonDaExec in 'JonDaExec.pas',
  FotoExec in 'FotoExec.pas',
  CCR.Exif.BaseUtils in '..\ccr-exif\CCR.Exif.BaseUtils.pas',
  CCR.Exif.Consts in '..\ccr-exif\CCR.Exif.Consts.pas',
  CCR.Exif in '..\ccr-exif\CCR.Exif.pas',
  CCR.Exif.TiffUtils in '..\ccr-exif\CCR.Exif.TiffUtils.pas',
  CCR.Exif.IPTC in '..\ccr-exif\CCR.Exif.IPTC.pas',
  Identitaet in 'Identitaet.pas',
  TestExec in 'TestExec.pas',
  systemd in '..\PASconTools\systemd.pas';

begin
 setIdentitaetAndRun;
end.
