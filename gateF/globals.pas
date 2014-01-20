unit globals;

interface

uses
  graphics, classes,
  anfix32, wanfix32;

type
  TeSymbol = (csyMen, csyWoman, csyCar, csyGroup, csyMarker, csyKombi, csyBus, csyPritsche, csyLKW);
  TeSymbolColor = (cscRed, cscGreen, cscGray, cscLogo, cscRobot);
  TeParkErlaubnis = (cpeNone, cpePermission); // new
  TeAlarmStatus = (casNone, casInfo, casAttention, casStop); // new
  TePfortenStatus = (psComplete, psMarkerPast, psInHouse, psMarkerFuture, psUnknown);

const
  Version: single = 2.027; { ..\rev\gateF.rev.txt }
  LanguageDriver = '';
  NoSplash = false;
  SignOffsetX = 150;
  SignOffsetY = 920;
  SignBorderX = 5;
  SignBorderY = 5;
  cKFZFilter = 'ABCDEFGHIJKLMNOPQRSTUVWXYZÖÄÜ0123456789';
  cIniFName = 'gateF.ini';
  cListeFname = 'Liste.ini';
  cHistorieFName = 'Historie.ini';
  cBesucherFName = 'Besucher.txt';
  cMitarbeiterFName = 'Mitarbeiter.txt';
  cTransactionPath = 'Transaktionen\';
  cDatenSicherungPath = 'Datensicherung\';
  cDiagnosePath = 'Diagnose\';
  cSystemPath = 'System\';
  cAblagePath = 'Ablage\';
  AppGoDown: boolean = false;
  DefaultLanguage = 'de';
  cTorMask = 'Tor ';
  cAnlieferung = 'Anlieferung';
  cPwdSuperVisor = 'gatef';
  cMitarbeiter = 'Mitarbeiter'; // Tag, der angibt, dass es sich um einen
                                // Mitarbeiter handelt.

 // Farben der Mänchen
  clListeGrau: TColor = 0;
  clListeGruen: TColor = 0;
  clListeRot: TColor = 0;
  clListeFuture: TColor = 0; // TStringList
  clListeRobot: TColor = 0; //
  clMitarbeiter = cllime+$A500A5;

 // Farbe der leichten grau-Hinterlegung
  clCursorGrau: TColor = 0;
  LetzeVergebeneTRN: integer = 0;
  SubTRN: integer = 0;
  AnonymousMode: boolean = false;

var
  MyProgramPath: string; { .\ }
  ImportePath: string;


 // persistente Systems-Settings der INI
  iBesucherTerminalIP: string;
  iPforteID: integer; { 0=unbekannt, 1,2,... }
  iPfoertnerKurzBez: string; { 4 stellig }
  iLogonDomain: string;
  iRealTime: boolean;
  iStatischeZeit: string;
  iStatischesDatum: string;
  iZulassung: string;
  iChangedExternal: boolean;
  iChangedByMe: boolean;
  iTagesAbschluss: TANFiXTime;
  iDruckerWarmUp: boolean;
  iTransactionServer: boolean;
  iADCMFName: string;
  iBelasseStatusGrau: integer;
  iPLEAImport: boolean;
  iADCMImport: boolean;
  iMitarbeiterOrtUmsetzer: string;
  iSCHEMAImport: boolean;
  iHistorieFName: string;

type
  TBesucherItem = class(TObject)
                  {00} name: string;
                  {01} firma: string;
                  {02} kennzeichen: string;
                  {03} Handy: string;
                  {04} Bemerkung: string;
                  {05} grund: string;
                  {06} anrede: string;
                  {07} datum: TANFiXDate; // 2.0
                  {08} tan: integer; // 2.0
                  {09} ziel: string; // 2.0
                  {10} nation: string; // 2.1
                  {11} symbol: TeSymbol; // 2.1

    procedure LoadFromString(s: string);
    function SaveToString: string;
    function SortStr: string;
    function Identisch(CmpRec: TBesucherItem): boolean;
    procedure CopyTo(Dest: TBesucherItem);
    function kfz: string;
  end;

  TBesucherList = class(TList)
    function _Get(Index: Integer): TBesucherItem;
    procedure _Put(Index: Integer; Item: TBesucherItem);
    procedure LoadFromFile(FName: string);
    procedure SaveToFile(FName: string);
    procedure Clear; override;
    property Items[Index: Integer]: TBesucherItem read _Get write _Put; default;
    procedure DoSort;
  end;

  TSignPoint = packed record
    Px, Py: word;
  end;

function LetzerBenutzerFName: string;
function NewTrn: integer;
function GetTrn: integer;
function BesucherLoeschenFName: string;
function MyPforteUpFName: string;
function KeyFromFName(FName: string): integer;
procedure BeginHourGlass;
procedure EndHourGlass;

implementation

uses
  SysUtils, IniFiles, Forms,
  Controls;

function LetzerBenutzerFName: string;
begin
  result := MyProgramPath + 'Letzer Benutzer ' + inttostrN(iPforteID, 2) + '.ini';
end;

function BesucherLoeschenFName: string;
begin
  result := MyProgramPath + 'Besucher Löschen ' + inttostrN(iPforteID, 2) + '.txt';
end;

function MyPforteUpFName: string;
begin
  result := MyProgramPath + 'T' + inttostr(iPforteID) + ' aktiv.ini';
end;

procedure ReadIni;
var
  MyIni: TIniFile;
  _ComputerName: string;
  InpF: TextFile;
  OutF: TextFile;
begin
  _ComputerName := ComputerName;

  // bis Rev. 1.036 war der Anwendungsname "FilsingerPforte.ini"
  if FileAge(MyProgramPath + 'FilsingerPforte.ini') > FileAge(MyProgramPath + ciniFName) then
    FileCopy(MyProgramPath + 'FilsingerPforte.ini', MyProgramPath + ciniFName);

  // ini lesen ...
  MyIni := TiniFile.create(MyProgramPath + ciniFName);
  with MyIni do
  begin
    if ReadString(_ComputerName, 'PforteNo', '?')='?' then
     _ComputerName := 'DEFAULT';

    iBesucherTerminalIP := ReadString(_ComputerName, 'BesucherTerminal', '');
    iPforteID := strtoint(ReadString(_ComputerName, 'PforteNo', '1'));
    iPfoertnerKurzBez := ReadString(_ComputerName, 'Mitarbeiter', 'LIEB');
    iRealTime := ReadString(_ComputerName, 'EchtZeit', 'JA') = 'JA';
    iStatischeZeit := ReadString(_ComputerName, 'Uhr', '10:17:02');
    iStatischesDatum := ReadString(_ComputerName, 'Datum', '13.12.99');
    iTagesAbschluss := strtoseconds(ReadString(_ComputerName, 'TagesAbschluss', ''));
    iZulassung := ReadString('SYSTEM', 'Zulassung', 'LIEB');
    iLogonDomain := ReadString('SYSTEM', 'AnmeldeDomain', '');
    iPLEAImport := ReadString('SYSTEM', 'MitarbeiterAusCSV', '') = 'JA';
    iADCMImport := ReadString('SYSTEM', 'MitarbeiterAusADCM', '') = 'JA';
    iSCHEMAImport := ReadString('SYSTEM', 'MitarbeiterAnhandSchema', '') = 'JA';
    iMitarbeiterOrtUmsetzer := ReadString('SYSTEM', 'MitarbeiterOrtUmsetzer', '');
    iDruckerWarmUp := ReadString(_ComputerName, 'DruckerWarmUp', '') = 'JA';
    iTransactionServer := ReadString(_ComputerName, 'Server', '') = 'JA';
    iADCMFName := ReadString('ADCM', 'ImportQuelle', '<kein Eintrag>');
    iBelasseStatusGrau := strtoint(ReadString('SYSTEM', 'BelasseStatusGrau', '1'));
    iHistorieFName := ReadString('SYSTEM','Ablage',cHistorieFName);

  end;
  MyIni.free;

 // Letzter Benutzer
  if FileExists(LetzerBenutzerFName) then
  begin
    AssignFile(InpF, LetzerBenutzerFName);
    reset(InpF);
    readln(InpF, iPfoertnerKurzBez);
    CloseFile(InpF);
  end;

  // Aktive Pforte
  assignFile(OutF, MyPforteUpFName);
  rewrite(OutF);
  writeln(OutF, _ComputerName + ', ' + datum + ', ' + uhr);
  CloseFile(OutF);
end;

function TBesucherItem.kfz: string;
begin
  result := StrFilter(ansiuppercase(Kennzeichen), cKFZFilter, false);
end;

procedure TBesucherItem.LoadFromString(s: string);
begin
  name := cutblank(nextp(s, ';'));
  firma := cutblank(nextp(s, ';'));
  kennzeichen := ansiuppercase(cutblank(nextp(s, ';')));
  Handy := cutblank(nextp(s, ';'));
  Bemerkung := cutblank(nextp(s, ';'));
  grund := cutblank(nextp(s, ';'));
  anrede := cutblank(nextp(s, ';'));
  datum := date2long(nextp(s, ';'));
  tan := str2int(nextp(s, ';'));
  ziel := cutblank(nextp(s, ';'));
  nation := cutblank(nextp(s, ';'));
  symbol := TeSymbol(str2int(nextp(s, ';')));
end;

function TBesucherItem.SaveToString: string;
begin
  result := cutblank(name) + ';' +
    cutblank(firma) + ';' +
    ansiuppercase(cutblank(kennzeichen)) + ';' +
    cutblank(Handy) + ';' +
    cutblank(Bemerkung) + ';' +
    cutblank(grund) + ';' +
    cutblank(anrede) + ';' +
    long2date(datum) + ';' +
    inttostr(tan) + ';' +
    cutblank(ziel) + ';' +
    cutblank(nation) + ';' +
    inttostr(ord(symbol));
end;

function TBesucherItem.SortStr: string;
begin
end;

function TBesucherItem.Identisch(CmpRec: TBesucherItem): boolean;
begin
  result := ((name = CmpRec.name) or ((name <> '') and (CmpRec.name = ''))) and
    ((firma = CmpRec.firma) or ((Firma <> '') and (CmpRec.Firma = ''))) and
    ((kfz = CmpRec.kfz) or ((kfz <> '') and (CmpRec.kfz = ''))) and
    ((handy = CmpRec.handy) or ((handy <> '') and (CmpRec.handy = ''))) and
    ((Bemerkung = CmpRec.bemerkung) or ((Bemerkung <> '') and (CmpRec.Bemerkung = ''))) and
    ((Grund = CmpRec.Grund) or (datum > CmpRec.datum)) and
    ((anrede = CmpRec.anrede) or ((anrede <> '') and (CmpRec.anrede = ''))) and
    ((ziel = CmpRec.ziel) or ((ziel <> '') and (CmpRec.ziel = ''))) and
    ((nation = CmpRec.nation) or ((nation <> '') and (CmpRec.nation = ''))) and
    (symbol = CmpRec.symbol);
end;

procedure TBesucherItem.CopyTo(Dest: TBesucherItem);
begin
end;

//

function _SortCompareBesucher(a, b: pointer): integer;
begin
  result := CompareStr(TBesucherItem(a).SortStr, TBesucherItem(b).SortStr);
end;

function TBesucherList._Get(Index: Integer): TBesucherItem;
begin
  result := TBesucherItem(get(index));
end;

procedure TBesucherList._Put(Index: Integer; Item: TBesucherItem);
begin
  Put(Index, Item);
end;

procedure TBesucherList.LoadFromFile(FName: string);
var
  n: integer;
  NewListElement: TBesucherItem;
  FullData: TStringList;
begin
  Clear;
  FullData := TstringList.create;
  if FileExists(Fname) then
    FullData.LoadFromFile(FName);
  for n := 0 to pred(FullData.Count) do
  begin
    NewListElement := TBesucherItem.Create;
    NewListElement.LoadFromString(FullData[n]);
    add(NewListElement);
  end;
  FullData.free;
end;

procedure TBesucherList.SaveToFile(FName: string);
var
  FullData: TStringList;
  n: integer;
begin
  FullData := TStringList.create;
  for n := 0 to pred(count) do
    with Items[n] do
      if name + firma + kennzeichen <> '' then
        FullData.add(SaveToString);
  FullData.SaveToFile(Fname);
  FullData.free;
end;

procedure TBesucherList.Clear;
var
  n: integer;
begin
  for n := 0 to pred(count) do
    items[n].free;
  inherited Clear;
end;

procedure TBesucherList.DoSort;
begin
  Sort(_SortCompareBesucher);
end;

function NewTrn: integer;
var
  MyActTrnNo: TStringList;
  TrnFName: string;
begin
  MyActTrnNo := TStringList.Create;
  TrnFName := MyProgramPath + 'TRN' + inttostrN(iPforteID, 3) + '.INI';
  if FileExists(TrnFName) then
    MyActTrnNo.LoadFromFile(TrnFName);
  if (MyActTrnNo.count = 0) then
    MyActTrnNo.add('1' + inttostrN(iPforteID, 3) + '000000');
  result := strtoint(MyActTrnNo[0]);
  LetzeVergebeneTRN := result;
  SubTRN := 0;
  MyActTrnNo[0] := inttostr(strtoint(MyActTrnNo[0]) + 1);
  MyActTrnNo.SaveToFile(TrnFName);
  MyActTrnNo.free;
end;

function GetTrn: integer;
var
  MyActTrnNo: TStringList;
  TrnFName: string;
begin
  MyActTrnNo := TStringList.Create;
  TrnFName := MyProgramPath + 'TRN' + inttostrN(iPforteID, 3) + '.INI';
  if FileExists(TrnFName) then
    MyActTrnNo.LoadFromFile(TrnFName);
  if (MyActTrnNo.count = 0) then
    MyActTrnNo.add('1' + inttostrN(iPforteID, 3) + '000000');
  result := strtoint(MyActTrnNo[0]);
  MyActTrnNo.free;
end;

function KeyFromFName(FName: string): integer;
var
  PreExtension: string;
begin
  PreExtension := ExtractFileName(FName);
  PreExtension := copy(PreExtension, 1, pred(pos('.', PreExtension)));
  result := str2int(PreExtension);
end;

var
  HourGlassLevel: integer;

procedure BeginHourGlass;
begin
  if HourGlassLevel = 0 then
    screen.cursor := crHourGlass;
  inc(HourGlassLevel);
end;

procedure EndHourGlass;
begin
  dec(HourGlassLevel);
  if HourGlassLevel = 0 then
    screen.cursor := crdefault;
end;

initialization
  TerminateIfAlreadyRunning('gateF');
  HourGlassLevel := 0;
  MyProgramPath := ExtractFilePath(paramstr(0));
  ImportePath := MyProgramPath + 'Importe\';
  FileDelete(MyProgramPath + 'stop.txt');
  CheckCreateDir(MyProgramPath + cTransactionPath);
  CheckCreateDir(MyProgramPath + cDatenSicherungPath);
  CheckCreateDir(MyProgramPath + cDiagnosePath);
  CheckCreateDir(MyProgramPath + cSystemPath);
  CheckCreateDir(MyProgramPath + cAblagePath);
  FileDelete(MyProgramPath + 'FilsingerPforte.ini');
  FileDelete(MyProgramPath + 'besucher.idx');
  ReadIni;
end.

