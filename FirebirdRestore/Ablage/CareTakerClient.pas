//
// to - do
// =======
//
// caching des Servers, sobald Fehler erneutes abfragen (einmalig)
// danach entgültiger Fehler, und Ausgabe auf den Transaktionsserver
//
unit CareTakerClient;

interface

type
  TTroubleTicket = integer; // \rev\TCareTaker.rev

const
  cCareTakerKey: string = 'PNE-32bit-STUB-VxD';
  cCareTakerDiagnosePath: string = '';
  cERRORText = 'ERROR:';
  cWARNINGText = 'WARNING:';
  cCareTakerLogFName = 'CareTaker.log.txt';
  iWikiServer: string = '';
  iCareTakerOffline: boolean = false;

function CareTakerLog(s: string; Nachmeldungen: boolean = true): TTroubleTicket;
procedure CareTakerClose(Ticket: TTroubleTicket);
function deCrypt(s: string): string;
function Int64asKeyStr(i:int64):string;
function KeyStrasInt64(s:string):int64;
function MachineID: string;
function CareTakerFName: string;
procedure Nachmeldungen;
procedure MachineIDChanged;
function vhost(url: string): string;
function cHelpURL: string;
function ResolveServer(s: string): string;

implementation

uses
  // wegen application
  classes, forms,

  anfix32, html, IdHttp, gnugettext,
  SysUtils, SimplePassword,

  // aus DCP
  DCPcrypt2, DCPblockciphers, DCPblowfish;

const
  _TrueServerName: string = '';
  _MachineID: string = '';
  CareTakerDiagnosePathChecked: string = '';

function MachineID: string;
begin
  if (_machineID = '') then
    _machineID := UserName + '@' +
    GetCurrentLanguage + '.' +
    ComputerName + '.' + MandantName;
  result := _MachineID;
end;

procedure MachineIDChanged;
begin
  _machineID := '';
end;

function enCrypt(s: string): string;
var
  cBLOWFISH: TDCP_blowfish;
  CryptKey: array[0..1023] of char;
begin
  cBLOWFISH := TDCP_blowfish.create(nil);
  with cBLOWFISH do
  begin
    StrPCopy(CryptKey, cCareTakerKey);
    Init(CryptKey, length(cCareTakerKey) * 8, nil);
    result := encryptstring(s);
  end;
  cBLOWFISH.free;
end;

function deCrypt(s: string): string;
var
  cBLOWFISH: TDCP_blowfish;
  CryptKey: array[0..1023] of char;
begin
  cBLOWFISH := TDCP_blowfish.create(nil);
  with cBLOWFISH do
  begin
    StrPCopy(CryptKey, cCareTakerKey);
    Init(CryptKey, length(cCareTakerKey) * 8, nil);
    result := decryptstring(s);
  end;
  cBLOWFISH.free;
end;

function ResolveServer(s: string): string;
var
  hPROXY: TIdHTTP;
begin
  try
    hPROXY := TIdHTTP.create(nil);
    _TrueServerName := StrFilter(
      ExtractSegmentBetween(
      hPROXY.get(
      s + '?p=' + FindANewPassword('', 15)),
      '<BODY>', '</BODY>', true),
      '.0123456789');
    result := _TrueServerName;
    hPROXY.free;
  except
    result := '';
  end;
end;

procedure CheckCreateDiagnosePath;
begin
  if (cCareTakerDiagnosePath = '') then
  begin
    // nimm den Anwendungspfad - der braucht nicht überprüft werden
    cCareTakerDiagnosePath := ExtractFilePath(application.exename);
    CareTakerDiagnosePathChecked := cCareTakerDiagnosePath;
  end else
  begin
    // nur prüfen, wenn nicht schon erfolgt!
    if (CareTakerDiagnosePathChecked <> cCareTakerDiagnosePath) then
    begin
      CheckCreateDir(cCareTakerDiagnosePath);
      CareTakerDiagnosePathChecked := cCareTakerDiagnosePath;
    end;
  end;
end;

function CareTakerLog(s: string; Nachmeldungen: boolean = true): TTroubleTicket;
var
  hCARETAKER: TIdHTTP;
  RawResult: string;
begin
  result := -1;
  s := machineID + ': ' + s;
  if not (iCareTakerOffline) then
  begin
    try
      hCARETAKER := TIdHTTP.create(nil);
      RawResult := ExtractSegmentBetween(
        hCARETAKER.get('http://caretaker.orgamon.org/log.php?msg=' +
        AnsiTorfc1738(enCrypt(s))),
        '<BODY>', '</BODY>', true
        );
      hCARETAKER.free;
      result := strtointdef(StrFilter(Rawresult, '0123456789', false), -1);
    except
    end;
  end;

  //
  // if log fail, write to file: Note the Moment of fail!
  //
  if Nachmeldungen then
    if (result = -1) then
      AppendStringsToFile(s + ' [' + long2date(DateGet) + ' ' + secondstostr(SecondsGet) + ']', CareTakerFName);
end;

procedure CareTakerClose(Ticket: TTroubleTicket);
begin
  CareTakerLog('Close Ticket ' + inttostr(Ticket));
end;

procedure Nachmeldungen;
var
  n, m: integer;
  LogS: TStringList;
begin
  if not (iCareTakerOffline) then
    if FileExists(CareTakerFName) then
    begin
      LogS := TStringList.create;
      LogS.LoadFromFile(CareTakerFName);
      m := 0;
      for n := 0 to pred(LogS.count) do
        if CareTakerLog(LogS[n], false) > 0 then
          inc(m)
        else
          break;
      if (m = LogS.count) then
        FileDelete(CareTakerFName);
    end;
end;

function CareTakerFName: string;
begin
  CheckCreateDiagnosePath;
  result := cCareTakerDiagnosePath + cCareTakerLogFName;
end;

function vhost(url: string): string;
var
  hCARETAKER: TIdHTTP;
  RawResult: string;
begin
  try
    hCARETAKER := TIdHTTP.create(nil);
    RawResult := ExtractSegmentBetween(
      hCARETAKER.get(url),
      '<BODY>', '</BODY>', true
      );
    hCARETAKER.free;
    result := StrFilter(Rawresult, '0123456789.', false);
  except
    result := '';
  end;
end;

function cHelpURL: string;
begin
  if (iWikiServer <> '') then
  begin
    result := iWikiServer + 'index.php/'
  end else
  begin
    result := 'http://www.orgamon.org/mediawiki/index.php/';
  end;
end;

function Int64asKeyStr(i:int64):string;
var
 L,n : integer;
begin
 result := '';
 l := sizeof(i);
 for n := 1 to l do
 begin
  result := result + chr((i AND 255));
  i := i shr 8;
 end;
end;

function KeyStrasInt64(s:string):int64;
var
 l:integer;
begin
  result := 0;
  if (length(s)<>8) then
   raise Exception.Create('KeyStr as a base of int64 must have the length of 8 Bytes');
  for l := 8 downto 1 do
  begin
     result := result shl 8;
     result := result + ord(s[l]);
  end;
end;


end.

