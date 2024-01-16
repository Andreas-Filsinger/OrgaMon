{
  |        ___
  |       / _ \  ___
  |      | | | |/ __|
  |      | |_| | (__
  |       \___/ \___|
  |
  |    Orientation Convert
  |
  |    Copyright (C) 2007 - 2024  Andreas Filsinger
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
program Oc;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes,
  SimplePassword in '..\PASconTools\SimplePassword.pas',
  Geld in '..\PASconTools\Geld.pas',
  gplists in '..\PASconTools\gplists.pas',
  anfix in '..\PASconTools\anfix.pas',
  sperre in '..\PASconTools\sperre.pas',
  WordIndex in '..\PASconTools\WordIndex.pas',
  CareTakerClient in '..\PASconTools\CareTakerClient.pas',
  OrientationConvert in '..\PASconTools\OrientationConvert.pas',
  binlager in '..\PASconTools\binlager.pas',
  Mapping in '..\PASconTools\Mapping.pas',
  libxml2 in '..\libxml2\libxml2.pas',
  html in '..\PASconTools\html.pas',
  ExcelHelper in '..\PASconTools\ExcelHelper.pas',
  txXML in '..\PASconTools\txXML.pas';

var
  InFName: string;
  Mode: string;
  ConversionOK: boolean;
  sLOG: TStringList;
  n: integer;

begin

  //
  writeln('O(rientation)c(onvert) Rev. ' + RevToStr(OrientationConvert.Version));
  writeln('(c) 1987-' + JahresZahl + ' by Andreas Filsinger  https://wiki.orgamon.org');
  sLOG := TStringList.create;

  // Commando-Zeilen Parameter einlesen!
  InFName := paramstr(1);
  DebugLogPath := ExtractFilePath(InFName);
  DebugMode := IsParam('-al');
  TestMode := IsParam('-tm');
  FileDelete(DebugLogPath + cOc_LogFName);

  Mode := paramstr(2);
  ConversionOK := false;

  repeat

    if (Mode = '') then
    begin
      ConversionOK := doConversion(CheckContent(InFName), InFName, sLOG);
      break;
    end;

    if (Mode = '--tab') then
    begin
      ConversionOK := doConversion(Content_Mode_tab2csv, InFName, sLOG);
      break;
    end;

    if (Mode = '--huff') then
    begin
      ConversionOK := doConversion(Content_Mode_Huffman, InFName, sLOG);
      break;
    end;

    if (Mode = '--csv') then
    begin
      if FileExists(ExtractFilePath(InFName) + cARGOS_TYP) then
        // CSV nach CSV (irgendwas wegen Argos)
        ConversionOK := doConversion(Content_Mode_csv, InFName, sLOG)
      else
        // CSV mit Umsetzer nach CSV
        ConversionOK := doConversion(Content_Mode_csvMap, InFName, sLOG);
      break;
    end;

    if (Mode = '--txt') then
    begin
      ConversionOK := doConversion(CheckContent(InFName), InFName, sLOG);
      break;
    end;

    // XLS -> csv,xml Converter
    if (Mode = '--xls') then
    begin
      ConversionOK := doConversion(CheckContent(InFName), InFName, sLOG);
      break;
    end;

    // XML -> csv Converter
    if (Mode = '--xml') then
    begin
      if FileExists(ExtractFilePath(InFName) + 'Schema.xsd') then
        ConversionOK := doConversion(Content_Mode_xsd, InFName, sLOG)
      else
        ConversionOK := doConversion(Content_Mode_xml2csv, InFName, sLOG);
      break;
    end;

    // XLS -> html Converter
    if (Mode = '--html') then
    begin
      ConversionOK := doConversion(Content_Mode_xls2html, InFName, sLOG);
      break;
    end;

    // XML - Validierung
    if (Mode = '--val') then
    begin
      if FileExists(ExtractFilePath(InFName) + 'Schema.xsd') then
        ConversionOK := doConversion(Content_Mode_xsd, InFName, sLOG)
      else
        ConversionOK := doConversion(Content_Mode_dtd, InFName, sLOG);
      break;
    end;

    // Fehler: Kann nicht erkannt werden
    writeln('ERROR: der letzte Parameter muss --tab, --csv, --txt, --xls, --html oder --xml sein, ist aber "' + Mode + '"');

  until yet;

  if not(ConversionOK) then
  begin
    if FileExists(ExtractFilePath(InFName) + cOc_LogFName) then
    begin
      sLOG := TStringList.create;
      sLOG.loadFromFile(ExtractFilePath(InFName) + cOc_LogFName);
      for n := 0 to pred(sLOG.count) do
        writeln(ANSI2OEM(sLOG[n]));
      sLOG.free;
    end;
    sleep(16000);
    halt(1);
  end;

end.
