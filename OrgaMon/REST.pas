{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
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
unit REST;

interface

uses
  SysUtils, Classes,

  // Indy
  IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, IdCustomTCPServer,
  IdCustomHTTPServer, IdHTTPServer, IdContext,
  IdMultipartFormData,

  // OrgaMon
  globals;

type
  TDataModuleREST = class(TDataModule)
    IdHTTPServer1: TIdHTTPServer;
  private

  var
    sAllTables: TStringList;

    { Private-Deklarationen }
    procedure getREST(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    function LogFName: string;

  public
    TAN: string; // im "ETag" übertragene Transaktionsnummer

    { Public-Deklarationen }
    procedure start;
    procedure stop;
    function REST(request: string): TStringList; overload;
    function REST(request: string; Attachment: string): TStringList; overload;
  end;

var
  DataModuleREST: TDataModuleREST;

implementation

uses
  IBExportTable, anfix32,
  CareTakerClient, html;

{$R *.dfm}

procedure TDataModuleREST.getREST(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  sTable: string;
  sData: TStringList;
begin
  with AResponseInfo do
  begin
    ContentType := 'text/plain';
    ServerSoftware := 'OrgaMon REST Rev. ' + RevToStr(globals.Version);

    // init
    if not(assigned(sAllTables)) then
      sAllTables := AllTables;

    repeat

      if (ARequestInfo.Document = '/') then
      begin
        ContentText := ARequestInfo.Command + ' ' + ARequestInfo.Document +
          #13#10 + HugeSingleLine(ARequestInfo.Params, #13#10)
          + #13#10 + '-----' + #13#10 + HugeSingleLine(sAllTables, #13#10);
        break;
      end;

      sTable := nextp(ARequestInfo.Document, '/', 1);
      if (sAllTables.indexof(sTable) <> -1) then
      begin
        sData := slTable('select * from ' + sTable);
        ContentText := HugeSingleLine(sData, #13#10);
        sData.free;
        break;
      end;

      ContentText := #13#10 + ARequestInfo.Document +
        ': I don''t know this chord' + #13#10;

    until true;

  end;
end;

function TDataModuleREST.REST(request: string): TStringList;
var
  httpC: TIdHTTP;
  ResponseStream: TMemoryStream;
begin
  TAN := '';
  result := TStringList.Create;

  httpC := TIdHTTP.Create(self);
  ResponseStream := TMemoryStream.Create;
  try
    httpC.get(AnsiToRFC1738(request), ResponseStream);
    if (httpC.ResponseCode = 200) then
    begin
      TAN := ExtractSegmentBetween(httpC.Response.RawHeaders.Values['ETag'],
        '"', '"');
      //
      ResponseStream.Position := 0;
      result.LoadFromStream(ResponseStream);
    end
    else
    begin
      result.add(cERRORText + ' GET.rest(' + request + '): ' + inttostr
          (httpC.ResponseCode) + ' (' + httpC.ResponseText + ')');
    end;
  except
    on E: Exception do
    begin
      result.add(cERRORText + ' rest(' + request + '): ' + E.Message);
    end;
  end;
  AppendStringsToFile('Request: "' + request + '":', LogFName);
  AppendStringsToFile(result, LogFName);
  ResponseStream.free;
  httpC.free;
end;

const
  _LogFName: string = '';

function TDataModuleREST.LogFName: string;
begin
  if (_LogFName = '') then
    _LogFName := DiagnosePath + 'REST-' + DatumLog + '.txt';
  result := _LogFName;
end;

function TDataModuleREST.REST(request, Attachment: string): TStringList;
var
  httpC: TIdHTTP;
  ResponseStream: TMemoryStream;
  MultiPartFormDataStream: TIdMultiPartFormDataStream;
begin
  TAN := '';
  result := TStringList.Create;

  httpC := TIdHTTP.Create(self);
  ResponseStream := TMemoryStream.Create;
  MultiPartFormDataStream := TIdMultiPartFormDataStream.Create;
  try
    MultiPartFormDataStream.AddFile('Datei', Attachment, 'text/plain');
    httpC.request.ContentType := MultiPartFormDataStream.RequestContentType;
    httpC.Post(request, MultiPartFormDataStream, ResponseStream);

    if (httpC.ResponseCode = 200) then
    begin
      TAN := ExtractSegmentBetween(httpC.Response.RawHeaders.Values['ETag'],
        '"', '"');
      //
      ResponseStream.Position := 0;
      result.LoadFromStream(ResponseStream);
    end
    else
    begin
      result.add(cERRORText + ' POST.rest(' + request + '): ' + inttostr
          (httpC.ResponseCode) + ' (' + httpC.ResponseText + ')');
    end;

    // ResponseStream.Seek(0, sofromBeginning);
    // result.LoadFromStream(ResponseStream);
  except
    on E: Exception do
    begin
      result.add(cERRORText + ' rest(' + request + ',' + Attachment + '): ' +
          E.Message);
    end;
  end;
  AppendStringsToFile('Request: "' + request + '","' + Attachment + '":',
    LogFName);
  AppendStringsToFile(result, LogFName);

  MultiPartFormDataStream.free;
  ResponseStream.free;
  httpC.free;
end;

procedure TDataModuleREST.start;
begin
  with IdHTTPServer1 do
  begin
    if not(Active) then
    begin
      DefaultPort := StrToIntDef(iRESTPort, 3047);
      OnCommandGet := getREST;
      Active := true;
    end;
  end;
end;

procedure TDataModuleREST.stop;
begin
  with IdHTTPServer1 do
  begin
    Active := false;
  end;
end;

end.
