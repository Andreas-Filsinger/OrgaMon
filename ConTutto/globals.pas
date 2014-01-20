{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __     ConTutto
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2012  Andreas Filsinger
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
unit globals;

interface

uses
  windows, graphics,
  sysutils, classes;

const
  version: single = 2.033; { ..\rev\ConTutto.rev.txt }
  cCodeName = 'ConTutto';
  cExeName: string = cCodeName + '.exe';
  ProjektID = 'anfisoft\' + cCodeName;
  nosplash: boolean = false;
  AppGoesDown: boolean = false;
  MesseMode: boolean = false;
  cSymbolMetrixFName = 'symbol.itp';

  // Program-Limits
  MaxDesktopSymbols = 100;
  MaxSymbols = 100;
  MaxFoundAnz = 15000; // Maximale Anzahl der gefundenen Datensätze
  MaxMedien = 25; // Maximale Anzahl der Sound-Medien
  MaxHugeText = 20 * 1024; // Maximale Größe der Info-Text
  cMaxDesktops = 2;

  // Pixel-Konstanten
  MaxFontSize = 18;
  MaxInpPixelwidth: integer = 390; // Pixel-Breite der Eingabe-Zeile
  INPUTPixelPosX: integer = 27;
  INPUTPixelPosY: integer = 14;
  INPUTCountPosX: integer = 27;
  INPUTCountPosY: integer = 14;
  LEDPixelPosX: integer = 431; // LED - Position X
  LEDPixelPosY: integer = 21; // LED - Position Y
  cNotenBlattXL: integer = 270;
  cNotenBlattYL: integer = 400;

  FILTER_CHECKLISTBOX_ZERO_SIZE = 0;
  FILTER_CHECKLISTBOX_ENTRY_SIZE = 13;
  VolumeReglerPixelPosX = 50;
  VolumeReglerPixelPosY = 78;
  VolumeOFFSwitchArea: TRect = (left: 10; top: 10; right: 52; bottom: 77);
  ListenAnsichtArea: TRect = (left: 6; top: 41; right: 25; bottom: 59);
  ZoomSizeX = 90;
  ZoomSizeY = 120;
  LEDonTimer = 1;
  LEDoffTimer = 3;
  LegalStr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  TranslatetStr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ';
  // swmode               : boolean = false;
  MaxSubSearch = 20; // Max Anzahl der Suchworte

  // FILTER-IDs
  cFILTER_ANZ = 7;

  FILTER_FELDER = 1;
  FILTER_LAND = 2;
  FILTER_SCHWER = 3;
  FILTER_PREIS = 4;
  FILTER_MUSIC = 5;
  FILTER_NEU = 6;
  FILTER_RUBRIK = 7;

  // Offsets für verschiedene Farben
  FilterOFF = 0;
  FilterGREEN = cFILTER_ANZ;
  FilterRED = cFILTER_ANZ * 2;

  //
  BUT_INFO = 0;
  BUT_SEARCH = 1;
  BUT_EXIT = 2;
  BUT_DATABASE = 3;
  BUT_NON = 3;

  cSym_Notiz_leer: word = 0;
  cSym_Notiz_belegt: word = 0;
  cSym_Bestell_leer: word = 0;
  cSym_Bestell_belegt: word = 0;
  cSym_Eingabe: word = 0;
  cSym_sound_disabled: word = 0;
  cSym_Sound_play: word = 0;
  cSym_Sound_volume: word = 0;
  cSym_rSound_weel: word = 0;
  cSym_hilfe: word = 0;
  cSym_Mulleimer_leer: word = 0;
  cSym_Mulleimer_belegt: word = 0;
  cSym_neu: word = 0;
  cSym_preis: word = 0;
  cSym_schwer: word = 0;
  cSym_land: word = 0;
  cSym_musik: word = 0;
  cSym_feld: word = 0;
  cSym_HeBu: word = 0;
  cSym_Obermayer: word = 0;
  cSym_rdunkelrot: word = 0;
  cSym_rrot: word = 0;
  cSym_rgrun: word = 0;
  cSym_rdunkelgrun: word = 0;
  cSym_rLED_grun: word = 0;
  cSym_rLED_gelb: word = 0;
  // cSym_rLED_blau         : word = 0;
  cSym_rLED_rot: word = 0;
  cSym_rLED_grau: word = 0;
  cSym_InterNet: word = 0;
  cSym_Jubi: word = 0;
  cSym_Titel: word = 0;
  cSym_Rubrik: word = 0;

const
  Artikel0FName = 'artikel0.bin';
  Artikel1FName = 'artikel1.bin';
  Bestellung0FName = 'best0.rtf';
  Bestellung1FName = 'best1.rtf';
  CDHintergrundFName = 'cdback.bmp';
  Desktop0x1024FName = 'd0x10.ini';
  Desktop0x800FName = 'd0x8.ini';
  Desktop1x1024FName = 'd1x10.ini';
  Desktop1x800FName = 'd1x8.ini';
  HilfeDemosFName = 'hdemos.txt';
  HilfeLizenzFName = 'hlizenz.txt';
  HilfeMetrixFName = 'hmetrix.txt';
  HilfeNotenFName = 'hnoten.txt';
  NotenHinterGrundFName = 'noback.bmp';
  WordStartIndex0FName = 'wsi0.bin';
  WordStartIndex1FName = 'wsi1.bin';
  WordStartSorted0FName = 'wss0.bin';
  WordStartSorted1FName = 'wss1.bin';

type

  tDataBaseRec = packed record
    ArtikelNo: string[10];
    Land: string[3];
    Titel: string[80];
    Komponist: string[35];
    Arranger: string[35];
    schwer: string[10];
    preis: single;
    verlag: string[35];
    Serie: string[35];
    Dauer: string[10];
    ProbeStimme: string[10];
    Aufnahme: string[35];
    Sparte: string[35];
    Bemerkung: integer;
    Komposition: integer;
    UeberKomponist: integer;
    UeberArranger: integer;
    PaperColor: TColor;
    BestellNo: string[10];
    OrgPreis: single;
    OrgCurrency: string[3];
    EntryDate: integer;
    SoundSource: byte; // 0=nicht verfügbar, 1=HeBu CDR usw.
    dealerID: string[6]; // xxxxxc, eigentlich integer
    BildDokument: integer; // Nummer des Bildes falls vorhanden
  end;
  tCheckArray = array [1 .. 1023] of boolean;

  tVerlag = packed record
    nummer: string[10]; // eigentlich integer
    name: string[40];
    strasse: string[40];
    Ort: string[40];
    Ansprechpartner: string[40];
    tel: string[40];
    fax: string[40];
    eMail: string[40];
    website: string[40];
  end;

const
 MaxDoubleWordCount = 30000;
 MaxVerlage         = 1000;

type
  eSymbolTypes = (SYM_UNKNOWN, // "0" may occur if not initialized
    SYM_NOTENBLATT, // großes Notenblatt
    SYM_FILTERBUTTON, // Filter
    SYM_NOTIZ, // Ablage
    SYM_KORB, // Bestellkorb
    SYM_MININOTEN, // kleine Noten
    SYM_LED, // kleine LED auf Input Symbol
    SYM_INPUT, // Controll-Panel
    SYM_HILFE, // Hilfe
    SYM_SWITCH, // Mode-Switch
    SYM_SOUND, // Sound-Modul
    SYM_TRASH, // Müll-Eimer
    SYM_INTERNET, // InterNet
    SYM_JUBI, // Jubiläen
    SYM_TITEL, // CD-Titel, Serien
    SYM_RUBRIK);

  eLEDStatus = (LED_OFF, LED_GREEN, LED_RED, LED_ORANGE);

  eInsideArea = (INSIDE_UNKNOWN, INSIDE_DRAG, INSIDE_OTHER);

  eSoundState = (SS_DISABLED, SS_PLAY, SS_STOP);

  tPaintProc = procedure(DesktopIndex: word);

  tDesktopSymbol = record
    Symbolrect: TRect;
    SymbolType: eSymbolTypes; // Symbol-Typ
    SymbolDATA: integer; // Symbol-ID
    SymbolOffset: integer; // Symbol-ID-Offset
    DragArea: TRect; // Bereich für Object-Move
  end;

  tDeskTopSymbols = array [1 .. MaxDesktopSymbols] of tDesktopSymbol;

  tSymbolPosition = record
    SymbolName: string[35];
    Spos: TRect; // Source Pos
    OwnSize: TRect; // "self-Rect"
    sBitMap: TBitMap;
  end;

  tLandRec = record
    LandName: string[35];
  end;

  tKomponistRec = record
    name: string[35];
  end;

  tArragerRec = record
    name: string[35];
  end;

  tVerlagRec = record
    name: string[35];
  end;

  tSerieRec = record
    name: string[35];
  end;

  tFoundArray = array [1 .. MaxFoundAnz] of integer;
  pFoundArray = ^tFoundArray;

  tverlage = array [0 .. pred(MaxVerlage)] of tVerlag;
  pverlage = ^tverlage;

const
  cImpossibleRect: array [0 .. 3] of integer = (0, 0, -1, -1);
  cUninstall: boolean = false;
  cDeleteRegistry: boolean = false;

  FeldNamenAnz = 8;
  cFelderNamen: array [1 .. FeldNamenAnz] of word = (39, 40, 41, 42, 43,
    44, 45, 99);

var
  noten: tDataBaseRec; // aktueller Datensatz "notenblatt"

  // für die Händler-Version
  HaendlerVersion: boolean;
  verlag: tVerlag; // aktueller Datensatz "verlagsadresse"
  VerlageArray: pverlage;
  VerlageAnz: integer;

  SystemPath: string; // CDROM:SYSTEM  (ohne Slash)
  SystemRoot: string; // %WINNT%

  MyProgramPath: string;
  // Path were the EXE was started from, without '\' at the end
  ScreenPixelX: integer;
  ScreenPixelY: integer;

  SuggestedWindowPosition: TPoint;

  // Persistent Registration Data
  FurtherVersion: string;
  DestPath: string;
  SerialNumber: string;
  Password: string;
  Name1: string;
  Name2: string;
  strasse: string;
  PLZOrt: string;
  // DesktopSetting            : string;
  LastResolution: integer;
  MyResolutionStr: string;
  DesktopMode: integer; // Was ist das?
  FirstInstallOfThisVersion: string;
  PasswordHaendler: string;
  BaseDate: string;
  OwnMedias: string;
  RegistrationKey: string;
  LastInterNetConnection: string;
  QuellPath: string;

  // Sprach-Treiber
  LanguageDriver: string;
  LanguageStr: TstringList;
  LanguageModes: TstringList;
  MusicMedias: TstringList;

  // InterNet-Update Programm Version
  Paramstr0: string;

  // läuft von "C:\"
  Crunner: boolean;

function DirExists(name: string): boolean;
procedure UpdateLanguageString;
procedure CheckIfHaendlerVersion;

implementation

uses
  Registry, dialogs, anfix32,
  IniFiles, forms, rstream,
  wanfix32;

const
  RegistrySoftwareID = 'SOFTWARE';

  // TOOLS

procedure ReadSystemSettings;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  with Registry do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion', false);
    if not(ValueExists('SystemRoot')) then
      OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion', false);
    SystemRoot := ReadString('SystemRoot');
  end;
  Registry.Free;
end;

procedure WriteSystemRegistry;
var
  Registry: TRegistry;
begin
  try
    Registry := TRegistry.Create;
    with Registry do
    begin
      RootKey := HKEY_LOCAL_MACHINE;
      StartDebug('WSR-Start1');
      OpenKey('\' + RegistrySoftwareID + '\' + ProjektID, true);
      StartDebug('WSR-Start2');
      WriteString('Rev', RevToStr(version));
      StartDebug('WSR-Start3');
      WriteString('DestPath', DestPath);
      StartDebug('WSR-Start4');
      WriteString('SerialNumber', SerialNumber);
      StartDebug('WSR-Start5');
      WriteString('PassWord', Password);
      StartDebug('WSR-Start6');
      WriteString('Name1', Name1);
      StartDebug('WSR-Start7');
      WriteString('Name2', Name2);
      StartDebug('WSR-Start8');
      WriteString('Strasse', strasse);
      StartDebug('WSR-Start9');
      WriteString('PLZOrt', PLZOrt);
      StartDebug('WSR-Start10');
      // WriteString('Desktop',DesktopSetting);
      StartDebug('WSR-Start11');
      WriteString('ScreenSetting', inttostr(LastResolution));
      StartDebug('WSR-Start12');
      WriteString('Datenbank', inttostr(DesktopMode));
      StartDebug('WSR-Start13');
      WriteString('Language', LanguageDriver);
      StartDebug('WSR-Start14');
      WriteString('Rev ' + RevToStr(version), FirstInstallOfThisVersion);
      StartDebug('WSR-Start15');
      WriteString('Händler', PasswordHaendler);
      StartDebug('WSR-Start16');
      if (BaseDate <> '') then
        StartDebug('WSR-Start17');
      WriteString('Base ' + BaseDate, long2date(DateGet));
      StartDebug('WSR-Start18');
      WriteString('Medien', OwnMedias);
      StartDebug('WSR-Start19');
      if not(Crunner) then
        StartDebug('WSR-Start20');
      WriteString('Quelle', SystemPath);
      StartDebug('WSR-Start21');
      WriteString('Quelle2', SystemPath);
      StartDebug('WSR-Start22');
      WriteString('Registration', RegistrationKey);
      StartDebug('WSR-Start23');
      WriteString('InterNet', LastInterNetConnection);
      CloseKey;
    end;
    Registry.Free;
  except
    on e: exception do
      StartDebug('WriteSystemRegistry-Exception: ' + e.Message);
  end;
end;

procedure ReadSystemRegistry;
var
  Registry: TRegistry;
  ResStr: string;
begin
  Registry := TRegistry.Create;
  with Registry do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    if KeyExists('\' + RegistrySoftwareID + '\' + ProjektID) then
    begin
      // Read the values
      OpenKey('\' + RegistrySoftwareID + '\' + ProjektID, false);
      FurtherVersion := ReadString('Rev');
      DestPath := ReadString('DestPath');
      Password := ReadString('PassWord');
      Name1 := ReadString('Name1');
      Name2 := ReadString('Name2');
      strasse := ReadString('Strasse');
      PLZOrt := ReadString('PLZOrt');
      // DesktopSetting         := ReadString('Desktop');
      PasswordHaendler := ReadString('Händler');
      LanguageDriver := ReadString('Language');
      RegistrationKey := ReadString('Registration');
      LastInterNetConnection := ReadString('InterNet');
      QuellPath := ReadString('Quelle');
      if QuellPath = '' then
        QuellPath := ReadString('Quelle2');
      if (LanguageDriver = '') then
      begin
        if pos('Programme', DestPath) > 0 then
          LanguageDriver := 'D'
        else
          LanguageDriver := 'E';
      end;
      LanguageDriver := 'D';
      OwnMedias := ReadString('Medien');
      if (OwnMedias = '') then
        OwnMedias := 'X';

      BaseDate := '';

      ResStr := ReadString('ScreenSetting');
      if (ResStr = '') then
        LastResolution := screen.width // default
      else
        LastResolution := strtoint(ResStr);

      ResStr := ReadString('Datenbank');
      if ResStr = '' then
        DesktopMode := 0 // default
      else
        DesktopMode := strtoint(ResStr);

      //
      FirstInstallOfThisVersion := ReadString('Rev ' + RevToStr(version));
      if FirstInstallOfThisVersion = '' then
        FirstInstallOfThisVersion := long2date(DateGet);

      CloseKey;
    end
    else
    begin

      CreateKey('\' + RegistrySoftwareID + '\' + ProjektID);
      CloseKey;

      // einfach die aktuellen Werte rausschreiben
      WriteSystemRegistry;
    end;
  end;
  Registry.Free;
end;

function DirExists(name: string): boolean;
var
  ActDir: string;
begin
  GetDir(0, ActDir);
{$I-}
  chdir(Name);
  result := (ioresult = 0);
{$I+}
  chdir(ActDir);
end;

procedure DeleteDesktopFiles;
begin
  DirDelete(ProgramFilesDir + cCodeName);
  rmdir(ProgramFilesDir + cCodeName);
end;

procedure DeleteRegistryEntries;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  with Registry do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    if KeyExists('\' + RegistrySoftwareID + '\' + ProjektID) then
      DeleteKey('\' + RegistrySoftwareID + '\' + ProjektID);
  end;
  Registry.Free;
end;

function InSide(const x, y: integer; const R: TRect): boolean;
begin
  InSide := (x >= R.left) and (x <= R.right) and (y >= R.top) and
    (y <= R.bottom);
end;

procedure GetSerialNumber;
var
  serialF: TstringList;
  Fname: string;
begin
  serialF := TstringList.Create;
  Fname := SystemPath + '\..\noten\serial.txt';
  while true do
  begin

    if FileExists(Fname) then
    begin
      serialF.LoadFromFile(Fname);
      SerialNumber := serialF[0];
      break;
    end;

    if (MessageBox(0, PChar('"' + Fname + '" not found!' + #13 +
      'Please insert ' + cCodeName + '-CDR!' + #13 + 'Bitte ' + cCodeName +
      '-CDR einlegen!'), PChar(SystemPath), mb_OKCANCEL or MB_ICONQUESTION or
      MB_DEFBUTTON2) = IDOK) then
    begin
      sleep(1000); // give System Time to react
      continue;
    end;

    halt;
  end;
  serialF.Free;
end;

procedure UpdateLanguageString;
var
  MyIni: TIniFile;
  n: integer;
begin

  MyIni := TIniFile.Create(SystemPath + '\static.txt');
  // erst mal die Modes einlesen, falls noch nicht geschehen
  if (LanguageModes.count = 0) then
    MyIni.ReadSectionValues('LANGUAGE', LanguageModes);
  LanguageStr.clear;
  MyIni.ReadSectionValues(LanguageDriver, LanguageStr);
  for n := 0 to pred(LanguageStr.count) do
    LanguageStr[n] := copy(LanguageStr[n], succ(pos('=', LanguageStr[n])
      ), MaxInt);
  MyIni.Free;

  MyIni := TIniFile.Create(SystemPath + '\mp3cd.txt');
  MusicMedias.clear;
  MyIni.ReadSectionValues(LanguageDriver, MusicMedias);
  for n := 0 to pred(MusicMedias.count) do
    MusicMedias[n] := copy(MusicMedias[n], succ(pos('=', MusicMedias[n])
      ), MaxInt);
  MyIni.Free;

end;

procedure FindProgramPath;
begin
  MyProgramPath := ExtractFilePath(paramstr(0));
  if (length(MyProgramPath) > 0) then
    if MyProgramPath[length(MyProgramPath)] = '\' then
      delete(MyProgramPath, length(MyProgramPath), 1);
  ScreenPixelX := screen.width;
  ScreenPixelY := screen.height;
end;

procedure CheckIfHaendlerVersion;
var
  Source: TEncryptedFileStream;
  Dest: TFileStream;
  DestFName: string;
  CheckF: file;
  InpF: TextFile;
  InpStr: string;
begin
  HaendlerVersion := false;

  // check if destination is valid!
  DestFName := DestPath + '\crypt.tmp';
  assignFile(CheckF, DestFName);
{$I-}
  rewrite(CheckF);
{$I+}
  if (ioresult <> 0) then
    exit;
  closeFile(CheckF);
  erase(CheckF);

  // open Source
  Source := TEncryptedFileStream.Create(SystemPath + '\..\noten\Haendler.txt',
    fmOpenRead);
  Source.key := PasswordHaendler;

  // create destination
  Dest := TFileStream.Create(DestFName, fmCreate);

  // copy it!
  Dest.CopyFrom(Source, 0);
  Dest.Free;
  Source.Free;

  assignFile(InpF, DestFName);
  reset(InpF);
  readln(InpF, InpStr);
  closeFile(InpF);
  erase(InpF);

  if (pos('anfisoft', InpStr) = 1) and (pos('serial number', InpStr) = 20) then
  begin
    HaendlerVersion := true;
  end;
end;

initialization

StartDebug('globals');
// if 2nd instance: halt!
// imp pend:
nosplash := TerminateIfAlreadyRunning(cCodeName);
nosplash := IsParam('nosplash');

MesseMode := IsParam('messe');

// Zero Info Reading
ReadSystemSettings;
FindProgramPath;
SystemPath := MyProgramPath + '\SYSTEM';
DestPath := ProgramFilesDir;
Crunner := FileExists(MyProgramPath + '\desktop0.ini') and not(MesseMode);
FileDelete(MyProgramPath + '\down.txt');

checkCreateDir(ProgramFilesDir + cCodeName);

// System-Pfade setzen
if not(MesseMode) then
  if not(nosplash) then
  begin
    Paramstr0 := ansiuppercase(ProgramFilesDir + cCodeName + '\' + cExeName);
    if Paramstr0 <> ansiuppercase(paramstr(0)) then
      if FileExists(ProgramFilesDir + cCodeName + '\' + cExeName) then
      begin
        nosplash := true;
        CloseAppSem;
        // imp pend:           spawn(ProgramFilesDir + cCodeName + '\' + cEXEName, SW_Show);
        halt;
      end;
  end;

// Objekte anlegen
LanguageStr := TstringList.Create;
LanguageModes := TstringList.Create;
MusicMedias := TstringList.Create;

// Aktuelle Serien-Nummer von der CD lesen!
if not(Crunner) then
begin
  GetSerialNumber;

  // default Programm-Settings, may be overwritten by registry entries
  FurtherVersion := RevToStr(version);
  Password := '';
  Name1 := '';
  Name2 := '';
  strasse := '';
  PLZOrt := '';
  // DesktopSetting := '2';
  LastResolution := screen.width;
  DesktopMode := 0;
  LanguageDriver := 'D';
  FirstInstallOfThisVersion := long2date(DateGet);
  PasswordHaendler := '';
  BaseDate := '';
  OwnMedias := 'X';
  VerlageAnz := 0;
  HaendlerVersion := false;
  RegistrationKey := '0000-0000-0000-0000';
  LastInterNetConnection := '';
  ReadSystemRegistry;
end
else
begin
  ReadSystemRegistry;
  SystemPath := QuellPath;
  GetSerialNumber;
end;

// nationale Version der Strings laden
UpdateLanguageString;

finalization

StartDebug('finalization-globals-A');
if not(MesseMode) then
begin
  if cDeleteRegistry or cUninstall then
  begin
    if cUninstall then
      DeleteDesktopFiles;
    if cDeleteRegistry then
      DeleteRegistryEntries;
  end
  else
  begin
    WriteSystemRegistry;
  end;
end;
StartDebug('finalization-globals-B');

end.
