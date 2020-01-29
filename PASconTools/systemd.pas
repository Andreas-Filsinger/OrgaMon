{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2020  Andreas Filsinger
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
unit systemd;

{$ifdef FPC}
{$mode objfpc}{$H+}
{$endif}

// #
// # OS - Wrapper
// #
// # win32: Aufruf externer Anwendungen
// # linux: rudimentäres libsystemd API um "ordentliche" Services schreiben zu können
// #

interface

uses
 Classes;

// Tools
function CallExternalApp(Cmd: string; const CmdShow: Integer): Cardinal;
function RunExternalApp(Cmd: string; const CmdShow: Integer): boolean;

// Dokumente konvertieren
function html2pdf(Dokument: string; OnlyIfOutDated: boolean = true): TStringList;

const
   SD_LISTEN_FDS_START = 3;

// systemd
function sd_notify(h:Integer; s:string) : Integer;
function sd_listen_fds(h:Integer) : Integer;

implementation

uses
 anfix32, CareTakerClient,
 {$ifndef FPC}
 windows,
 JclMiscel,
 {$else}
 fpchelper,
 {$endif}
 SysUtils;

function CallExternalApp(Cmd: string; const CmdShow: Integer): Cardinal;
begin
 if DebugMode then
   AppendStringsToFile(Cmd, DebugLogPath + 'SYSTEMD-' + DatumLog + cLogExtension, Uhr8);
 {$ifdef FPC}
 {$else}
 result := JclMiscel.WinExec32AndWait(Cmd,CmdShow);
 {$endif}
 if DebugMode then
   AppendStringsToFile(IntToStr(result), DebugLogPath + 'SYSTEMD-' + DatumLog + cLogExtension, Uhr8);
end;

function RunExternalApp(Cmd: string; const CmdShow: Integer): boolean;
begin
 if DebugMode then
   AppendStringsToFile(Cmd, DebugLogPath + 'SYSTEMD-' + DatumLog + cLogExtension, Uhr8);
 {$ifdef FPC}
 {$else}
 result := JclMiscel.WinExec32(Cmd,CmdShow);
 {$endif}
 if DebugMode then
   AppendStringsToFile(BoolToStr(result), DebugLogPath + 'SYSTEMD-' + DatumLog + cLogExtension, Uhr8);
end;

function sd_notify(h: Integer; s: string): Integer;
// sample:     sd_notify( 0, "RELOADING=1\nSTATUS=50% done\n" );
// sample
begin
 result := -1;
end;

function sd_listen_fds(h: Integer): Integer;
begin
 result := -1;

end;
const
 wkhtmltopdf_Installation: string = '';

function html2pdf(Dokument: string; OnlyIfOutDated: boolean = true): TStringList;
const
 cHTMLextension = '.html';
 cPDFextension = '.pdf';
var
 Dokument_pdf : string;
 k : integer;
 ErrorMsg: string;
begin


  repeat

     result := TStringList.Create;
     ErrorMsg := '';
     if not(FileExists(Dokument)) then
     begin
       ErrorMsg := 'Quell-HTML nicht gefunden!';
       break;
     end;

     if (wkhtmltopdf_Installation='') then
     begin

      repeat
       wkhtmltopdf_Installation := 'C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe';
       if FileExists(wkhtmltopdf_Installation) then
        break;
       wkhtmltopdf_Installation := ProgramFilesDir + 'wkhtmltopdf\bin\wkhtmltopdf.exe';
       if FileExists(wkhtmltopdf_Installation) then
        break;
       wkhtmltopdf_Installation := 'C:\Program Files (x86)\wkhtmltopdf\bin\wkhtmltopdf.exe';
       if FileExists(wkhtmltopdf_Installation) then
        break;
       wkhtmltopdf_Installation := '';
      until yet;

     end;

    if (wkhtmltopdf_Installation='') then
    begin
      ErrorMsg := 'wkhtmltopdf Installation nicht gefunden!';
      break;
    end;

    Dokument_pdf := Dokument;

    k := revpos(cHTMLextension, Dokument_pdf);
    if (k > 0) then
    begin
      Dokument_pdf := copy(Dokument_pdf, 1, pred(k)) + cPDFExtension
    end
    else
    begin
      ErrorMsg := 'Anteil "' + cHTMLextension + '" in "' + Dokument + '" nicht gefunden!';
      break;
    end;

    //
    if
     {} not(OnlyIfOutDated) or
     {} (FileDateTime(Dokument) > FileDateTime(Dokument_pdf)) then
    begin
      if (pos('--',iPDFZoom)=0) then
        CallExternalApp(
          { } '"' + wkhtmltopdf_Installation + '"' + ' ' +
          { } '--quiet ' +
          { } '--print-media-type ' +
          { } '--page-width 2480px ' + // DIN A4 Format
          { } '--page-height 3508px ' +
          { } '--margin-top 100px ' +
          { } '--margin-bottom 9px ' +
          { } '--margin-left 9px ' +
          { } '--margin-right 9px ' +
          { } '--dpi 150 ' +
          { } '--zoom '+iPDFZoom+' ' +
          { } '"' + Dokument + '"' + ' ' +
          { } '"' + Dokument_pdf + '"',
          { } SW_HIDE)
      else
        CallExternalApp(
          { } '"' + wkhtmltopdf_Installation + '"' + ' ' +
          { } iPDFZoom + ' ' +
          { } '"' + Dokument + '"' + ' ' +
          { } '"' + Dokument_pdf + '"',
          { } SW_HIDE);
    end;

    if (FSize(Dokument_pdf)<739) then
    begin
      ErrorMsg := 'PDF-Erstellung ist nicht erfolgt. Ev. keine wkhtmltopdf Installation gefunden!';
      break;
    end;

  until true;
  if (ErrorMsg<>'') then
   result.values['ERROR'] := ErrorMsg
  else
   result.values['ConversionOutFName'] := Dokument_pdf;
end;

end.
