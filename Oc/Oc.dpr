program Oc;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes,
  SimplePassword in '..\PASconTools\SimplePassword.pas',
  Geld in '..\PASconTools\Geld.pas',
  gplists in '..\PASconTools\gplists.pas',
  anfix32 in '..\PASconTools\anfix32.pas',
  sperre in '..\PASconTools\sperre.pas',
  WordIndex in '..\PASconTools\WordIndex.pas',
  txlib in '..\PASconTools\txlib.pas',
  CareTakerClient in '..\PASconTools\CareTakerClient.pas',
  OrientationConvert in '..\PASconTools\OrientationConvert.pas',
  binlager32 in '..\PASconTools\binlager32.pas',
  Mapping in '..\PASconTools\Mapping.pas',
  libxml2 in '..\libxml2\libxml2.pas',
  html in '..\PASconTools\html.pas',
  ExcelHelper in '..\PASconTools\ExcelHelper.pas';

var
  InFName: string;
  Mode: string;
  ConversionOK: boolean;
  sLOG: TStringList;
  n: integer;
begin

  //
  writeln('O(rientation)c(onvert) Rev. ' + RevToStr(OrientationConvert.Version));
  writeln('(c) 1987-' + JahresZahl + ' by Andreas Filsinger  http://www.orgamon.org');
  sLOG := TStringList.create;

  // Commando-Zeilen Parameter einlesen!
  InFName := paramstr(1);
  FileDelete(ExtractFilePath(InFName) + 'Diagnose.txt');

  Mode := paramstr(2);
  ConversionOK := false;

  repeat

    if (Mode = '') then
    begin
      ConversionOK := doConversion(CheckContent(InFname), InFname, sLOG);
      break;
    end; 

    if (Mode = '--tab') then
    begin
      ConversionOK := doConversion(Content_Mode_tab2csv, InFName, sLOG);
      break;
    end;

    if (Mode = '--csv') then
    begin
      ConversionOK := doConversion(Content_Mode_csv, InFName, sLOG);
      break;
    end;

    if (Mode = '--txt') then
    begin
      ConversionOK := doConversion(Content_Mode_txt, InFName, sLOG);
      break;
    end;

    // XLS -> csv,xml Converter
    if (Mode = '--xls') then
    begin
      ConversionOK := doConversion(CheckContent(InFname),InFname, sLOG);
      break;
    end;

    // XML -> csv Converter
    if (Mode = '--xml') then
    begin
      if FileExists(ExtractFilePath(InFname)+'Schema.xsd') then
        ConversionOK := doConversion(Content_Mode_xsd, InFName, sLOG)
      else
        ConversionOK := doConversion(Content_Mode_xml2csv, InFName, sLOG);
      break;
    end;

    // XML - Validierung
    if (Mode = '--val') then
    begin
      if FileExists(ExtractFilePath(InFname)+'Schema.xsd') then
        ConversionOK := doConversion(Content_Mode_xsd, InFName, sLOG)
      else
        ConversionOK := doConversion(Content_Mode_dtd, InFName, sLOG);
      break;
    end;

    // Fehler: Kann nicht erkannt werden
    writeln('ERROR: Parameter 2 muss --tab, --csv, --txt, --xls oder --xml sein, ist aber "'+Mode+'"');

  until true;

  if not (ConversionOK) then
  begin
    if FileExists(ExtractFilePath(InFName) + 'Diagnose.txt') then
    begin
      sLOg := TStringList.create;
      sLOG.loadFromFile(ExtractFilePath(InFName) + 'Diagnose.txt');
      for n := 0 to pred(sLOG.count) do
        writeln(ANSI2OEM(sLOG[n]));
      sLOG.free;
    end;
    sleep(16000);
    halt(1);
  end;

end.

