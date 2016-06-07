{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2015 - 2016  Andreas Filsinger
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
unit FotoExec;

interface

uses
{$IFNDEF linux}
  windows,
{$ENDIF}
  // System
  classes, inifiles, SysUtils,
  math,
{$IFDEF FPC}
  fpImage, FPReadJPEG, Graphics,
{$ELSE}
  jpeg,
{$ENDIF}
  CCR.Exif,

  // Tools
  anfix32, WordIndex, binlager32,
  Foto, InfoZip,
  CareTakerClient,

  // OrgaMon
  globals,
  JonDaExec;

const

  // Warte Zeiten [min]
  cKikstart_delay = 10;

  // Anzahl der Stellen verschiedener Ablagesysteme
  cAnzahlStellen_Transaktionszaehler = 5;
  cAnzahlStellen_FotosTagwerk = 4;

  // Filenames
  cFotoTransaktionenFName = 'FotoService-Transaktionen.log.txt';
  cFotoAblageFName = 'FotoService-Ablage-%s.log.txt';

  cIsAblageMarkerFile = 'ampel-horizontal.gif' deprecated 'Alte Ablage!';

  // Bild-Namenskonvention
  //
  // GeraeteID "-" RID "-" BildProtokollName[ "-" N ].jpg
  // "-" N wird nur angefügt sobald auf dem Smartphone eine Bildnamensgleichheit
  // erkannt wird.
  //
  cFotoService_AbortTag = 'FATAL';

type
  TFotoExec = class(TObject)
  public
    // aktueller Context
    tBAUSTELLE: tsTable;
    tABLAGE: tsTable;
    JonDaExec: TJonDaExec;
    LastLogWasTimeStamp: boolean; // Protect TimeStamp Flood
    BackupDir: string;
    // heutige Datensicherungen gehen hier hin (=pBackUpRootPath+#001\ als Beispiel)
    ZaehlerNummerNeuXlsCsv_Vorhanden: boolean;

    AUFTRAG_R: integer; // Aktueller Context für Log-Datei, Fehlermeldungsausgabe usw.

    // Ini-Sachen

    // bisher fix 'I:\KundenDaten\SEWA\JonDaServer\' jetzt Parameter "BackupPath"
    // direkt dorthinein nichts sichern, es gibt ".\#nnn" Unterverzeichnisse,
    // ACHTUNG: Benutze "BackupDir" zu sichern und NICHT dieses Root-Verzeichnis aller Backups
    pBackUpRootPath: string;

    // bisher fix 'W:\status\' jetzt Parameter "WebPath"
    pWebPath: string;

    // bisher fix 'W:\orgamon-mob\' jetzt Parameter "FTPPath"
    pFTPPath: string;

    // bisher fix 'W:\orgamon-mob\unverarbeitet\' jetzt Parameter "UnverarbeitetPath"
    pUnverarbeitetPath: string;

    // bisher fix 'W:\JonDaServer\' jetzt Anwendungsverzeichnis, Endpunkt der ini-Kette, Home von cOrgaMon.ini
    pAppServicePath: string;

    // bisher fix 'W:\JonDaServer\Statistik\' jetzt Parameter "StatistikPath" mit Default "WebPath"
    pAppStatistikPath: string;

    // bisher fix 'W:\JonDaServer\Statistik\' jetzt Parameter "TextPath" mit Default
    pAppTextPath: string;

    // Verzeichnisse errechnet
    function MyDataBasePath: string;
    function MyDataBasePath2: string;
    // ehemalige Datenhalten in "\Fotos" heute alles zentral in "\db"
    function MySyncPath: string;

    // Dateinamen
    function AblageLogFname: string;

    // load Settings
    procedure readIni(SectionName: string = ''; Path: string = '');

    // Init, Deinit
    procedure ensureGlobals;
    procedure releaseGlobals;

    function GEN_ID: integer;

    // Work
    procedure workEingang(sParameter: TStringList = nil);
    procedure workWartend(sParameter: TStringList = nil);
    procedure workAblage(sParameter: TStringList = nil);
    procedure workStatus;
    procedure workSync;

    // muss IMMER überladen werden
    procedure Log(s: string); virtual; abstract;

    // Implementierungen von JonDaExec - Prototypen
    function ZaehlerNummerNeu(AUFTRAG_R: integer; GeraeteNo: string): string;
    function ReglerNummerNeu(AUFTRAG_R: integer; GeraeteNo: string): string;
    procedure invalidate_NummerNeuCache;
  end;

implementation

uses
  IdFTP, SolidFTP;

const
  _GeraeteNo: string = '';
  EINGABE: tsTable = nil;

procedure TFotoExec.invalidate_NummerNeuCache;
begin
  _GeraeteNo := '';
end;

function TFotoExec.ZaehlerNummerNeu(AUFTRAG_R: integer; GeraeteNo: string): string;
var
  FName: string;
  r: integer;
begin

  // Datenspeicher laden
  if (GeraeteNo <> _GeraeteNo) then
  begin
    if not(assigned(EINGABE)) then
      EINGABE := tsTable.Create
    else
      EINGABE.Clear;
    FName := pAppTextPath + 'Eingabe.' + GeraeteNo + '.txt';
    if FileExists(FName) then
      FileAlive(FName);
    EINGABE.insertfromFile(FName, cHeader_Eingabe);
    _GeraeteNo := GeraeteNo;
  end;

  // RID suchen
  r := EINGABE.locate('RID', InttoStr(AUFTRAG_R));
  if (r <> -1) then
    result := EINGABE.readCell(r, 'ZAEHLER_NUMMER_NEU')
  else
    result := '';

end;

function TFotoExec.ReglerNummerNeu(AUFTRAG_R: integer; GeraeteNo: string): string;
var
  FName: string;
  r: integer;
begin

  // Datenspeicher laden
  if (GeraeteNo <> _GeraeteNo) then
  begin
    if not(assigned(EINGABE)) then
      EINGABE := tsTable.Create
    else
      EINGABE.Clear;
    FName := pAppTextPath + 'Eingabe.' + GeraeteNo + '.txt';
    if FileExists(FName) then
      FileAlive(FName);
    EINGABE.insertfromFile(FName, cHeader_Eingabe);
    _GeraeteNo := GeraeteNo;
  end;

  // RID suchen
  r := EINGABE.locate('RID', InttoStr(AUFTRAG_R));
  if (r <> -1) then
    result := EINGABE.readCell(r, 'REGLER_NUMMER_NEU')
  else
    result := '';
end;

procedure TFotoExec.ensureGlobals;
var
  r: integer;
  sDirs: TStringList;
  n: integer;
  SubPath: string;
begin
  if not(assigned(tBAUSTELLE)) then
  begin

    // Initialer Lauf
    JonDaExec := TJonDaExec.Create;
    JonDaExec.callback_ZaehlerNummerNeu := ZaehlerNummerNeu;
    JonDaExec.callback_ReglerNummerNeu := ReglerNummerNeu;

    // die aktuellen Daten aus dem FTP-Bereich jetzt abholen
    workSync;

    tBAUSTELLE := tsTable.Create;
    tBAUSTELLE.insertfromFile(MyDataBasePath2 + cFotoService_BaustelleFName);
    if FileExists(MyDataBasePath2 + cFotoService_BaustelleManuellFName) then
    begin
      with tBAUSTELLE do
      begin
        insertfromFile(MyDataBasePath2 + cFotoService_BaustelleManuellFName);
        for r := RowCount downto 1 do
          if (length(readCell(r, cE_FTPUSER)) < 3) then
            del(r);
        // SaveToFile(MyBaustellePath + 'baustelle-alle.csv');
      end;
    end;

    tABLAGE := tsTable.Create;
    tABLAGE.insertfromFile(MyDataBasePath + cFotoService_AblageFName);

    // Datei der Wartenden sicherstellen, Header anlegen
    if not(FileExists(MyDataBasePath2 + cFotoService_UmbenennungAusstehendFName)) then
      AppendStringsToFile(
        { } cFotoService_UmbenennungAusstehendHeader,
        { } MyDataBasePath2 + cFotoService_UmbenennungAusstehendFName);

    // heutiges BackupDir bestimmen, "...\#001\", "...\#002" usw.
    sDirs := TStringList.Create;
    dir(pBackUpRootPath + '*.', sDirs, false);
    sDirs.sort;
    for n := pred(sDirs.count) downto 0 do
      if (pos('.', sDirs[n]) = 1) then
        sDirs.Delete(n);
    if (sDirs.count = 0) then
    begin
      Log(cERRORText + ' Backup: Kein Unterverzeichnis in ' + pBackUpRootPath);
      Log(cFotoService_AbortTag);
    end;

    SubPath := StrFilter(sDirs[pred(sDirs.count)], '#' + cZiffern);
    if (length(SubPath) <> 4) then
    begin
      Log(cERRORText + ' Backup: Unterverzeichnis nicht in der Form #nnn ');
      Log(cFotoService_AbortTag);
    end;
    if (SubPath[1] <> '#') then
    begin
      Log(cERRORText + ' Backup: Unterverzeichnis nicht in der Form #nnn ');
      Log(cFotoService_AbortTag);
    end;

    // das gröste Element wählen
    BackupDir := pBackUpRootPath + sDirs[pred(sDirs.count)] + '\';
    sDirs.Free;

    JonDaExec.BackupDir := BackupDir;

    // TimeStamp in die Logdatei legen
    if not(LastLogWasTimeStamp) then
    begin
      AppendStringsToFile(
        { } 'timestamp ' + sTimeStamp,
        { } DiagnosePath + cFotoTransaktionenFName);
      LastLogWasTimeStamp := true;
    end;

  end;
end;

procedure TFotoExec.readIni(SectionName: string = ''; Path: string = '');
var
  MyIni: TIniFile;
begin

  // Root Path
  if (Path = '') then
    Path := MyProgramPath;
  pAppServicePath := Path;

  // Wir brauchen FTP-Zugangsdaten wegen des Sync
  MyIni := TIniFile.Create(pAppServicePath + cIniFNameConsole);
  with MyIni do
  begin
    if (SectionName = '') then
      SectionName := getParam('Id');
    if (SectionName = '') then
      SectionName := UserName;
    if (ReadString(SectionName, 'ftpuser', '') = '') then
      SectionName := 'System';

    // Ftp-Bereich für diesen Server
    iJonDa_FTPHost := ReadString(SectionName, 'ftphost', 'gateway');
    iJonDa_FTPUserName := ReadString(SectionName, 'ftpuser', '');
    iJonDa_FTPPassword := ReadString(SectionName, 'ftppwd', '');

    // die ganzen Pfade
    pBackUpRootPath := ReadString(SectionName, 'BackUpPath', 'I:\KundenDaten\SEWA\JonDaServer\');
    pWebPath := ReadString(SectionName, 'WebPath', 'W:\status\');
    pAppStatistikPath := ReadString(SectionName, 'StatistikPath', pWebPath);
    pAppTextPath := ReadString(SectionName, 'TextPath', 'W:\JonDaServer\Statistik\');
    pFTPPath := ReadString(SectionName, 'FTPPath', 'W:\orgamon-mob\');
    pUnverarbeitetPath := ReadString(SectionName, 'UnverarbeitetPath', 'W:\orgamon-mob\unverarbeitet\');
    DiagnosePath := ReadString(SectionName, 'LogPath', 'W:\JonDaServer\Fotos\');
  end;
  MyIni.Free;

  // Einstellungen weitergeben
  SolidFTP.SolidFTP_LogDir := DiagnosePath;
end;

procedure TFotoExec.releaseGlobals;
begin
  if assigned(tBAUSTELLE) then
  begin
    try
      FreeAndNil(tBAUSTELLE);
      FreeAndNil(tABLAGE);
      FreeAndNil(JonDaExec);
    except
      on E: Exception do
        Log(cERRORText + ' 345:' + E.ClassName + ': ' + E.Message);
    end;
  end;
end;

function TFotoExec.MyDataBasePath: string;
begin
  result := pAppServicePath + cDBPath;
end;

function TFotoExec.MyDataBasePath2: string;
begin
  if JonDaExec.oldInfrastructure then
    result := DiagnosePath
  else
    result := MyDataBasePath;
end;

function TFotoExec.MySyncPath: string;
begin
  result := pAppServicePath + cSyncPath;
end;

function TFotoExec.GEN_ID: integer;
var
  mIni: TIniFile;
begin
  if JonDaExec.oldInfrastructure then
    mIni := TIniFile.Create(pFTPPath + cFotoService_IdFName)
  else
    mIni := TIniFile.Create(MyDataBasePath + cFotoService_IdFName);
  with mIni do
  begin
    result := StrToInt(ReadString('System', 'Sequence', '0'));
    inc(result);
    if (result >= round(power(10, cAnzahlStellen_Transaktionszaehler))) then
      result := 1;
    WriteString('System', 'Sequence', InttoStr(result));
  end;
  mIni.Free;
end;

procedure TFotoExec.workEingang(sParameter: TStringList = nil);
var
  sFiles: TStringList;
  IgnoreIt: boolean;
  // Überspringen weil zu neu?!
  sFilesClientSorter: TStringList;
  sTemp: TStringList;
  n, m, i, f, r: integer;
  FileTimeStamp: TDateTime;
  d, File_Date: TANFiXDate;
  s, File_Seconds: TANFiXTime;
  FName: string;
  DATEINAME_AKTUELL: string;
  ID: string;
  bOrgaMon, bOrgaMonOld: TBLager;
  mderecOrgaMon: TMDERec;
  FotoGeraeteNo: string;
  FotoParameter: string;
  // FA, Ausbau, FN, Anlage usw.
  FotoDateiName, FotoDateiNameVerfuegbar: string;
  // Kompletter Dateiname
  FotoZiel: string;
  FotoAblage_PFAD: string;

  FullSuccess: boolean;
  FoundAuftrag: boolean;
  UmbenennungAbgeschlossen: boolean;
{$IFDEF FPC}
  Image: TPicture;
{$ELSE}
  Image: TJPEGImage;
{$ENDIF}
  sBaustelle: string;
  sZiel: string;

  BAUSTELLE_Index: integer;

  // alternativer Auftragspool
  fOrgaMonAuftrag: file of TMDERec;
  iEXIF: TExifData;

  // Foto - Umbenennung
  sFotoCall: TStringList;
  sFotoResult: TStringList;
  RenameError: boolean;

  // Parameter
  pAll: boolean;

  procedure unverarbeitet(m: integer);
  var
    FNameAlt: string;
    FNameNeu: string;
  begin
    FNameAlt := pFTPPath + sFiles[m];
    FNameNeu := pUnverarbeitetPath + ID + '+' + sFiles[m];

    // Datei wegsperren, aber nicht löschen!
    if not(FileMove(
      { } FNameAlt,
      { } FNameNeu)) then
    begin
      Log(cERRORText + ' 460: FileMove("' + FNameAlt + '", "' + FNameNeu + '")');
      Log(cFotoService_AbortTag);
    end;

    // Protokollieren
    AppendStringsToFile(
      { } 'mv ' + FNameAlt +
      { } ' ' + FNameNeu,
      { } DiagnosePath + cFotoTransaktionenFName);
    LastLogWasTimeStamp := false;

    // Datei aus der Verarbeitungskette entfernen
    sFiles.Delete(m);
  end;

begin
  if assigned(sParameter) then
  begin
    pAll := sParameter.Values['ALL'] <> cIni_Deactivate;
  end
  else
  begin
    pAll := true;
  end;

  // Init Phase
  sFiles := TStringList.Create;
  sFilesClientSorter := TStringList.Create;
  ID := '';

  // get File List
  dir(pFTPPath + '*.jpg', sFiles, false);

  // reduce to Files-Age > 5 Seconds
  d := DateGet;
  s := SecondsGet;
  for n := pred(sFiles.count) downto 0 do
  begin
    FName := pFTPPath + sFiles[n];
    FileAge(FName, FileTimeStamp);
    File_Date := DateTime2long(FileTimeStamp);
    File_Seconds := cIllegalSeconds;

    IgnoreIt := true;
    repeat

      if not(DateOK(File_Date)) then
      begin
        Log('Wrong Filedate ' + FName + ' ...');
        break;
      end;

      File_Seconds := dateTime2Seconds(FileTimeStamp);
      if SecondsDiff(d, s, File_Date, File_Seconds) < 4 then
      begin
        Log('Skip new ' + FName + ' ...');
      end;

      IgnoreIt := false;

    until true;
    if not(IgnoreIt) then
      sFilesClientSorter.AddObject(
        { } long2dateLog(File_Date) + '|' +
        { } secondstostr(File_Seconds) + '|' +
        { } sFiles[n], TObject(n));

  end;

  // Sort Files by "Date / Time", Oldest topmost
  sFilesClientSorter.sort;
  sTemp := TStringList.Create;
  for n := 0 to pred(sFilesClientSorter.count) do
    sTemp.add(sFiles[integer(sFilesClientSorter.Objects[n])]);
  sFiles.Assign(sTemp);
  sTemp.Free;

  // Reduce Work to Only One!
  if not(pAll) then
    for n := pred(sFiles.count) downto 1 do
      sFiles.Delete(n);

  // Generate Work-TAN as "ID"
  if (sFiles.count > 0) then
  begin
    ID := inttostrN(GEN_ID, cAnzahlStellen_Transaktionszaehler);
    CheckCreateDir(BackupDir + cFotoService_FTPBackupSubPath);
  end;

  // reduce to valid jpg's
  for n := pred(sFiles.count) downto 0 do
  begin

    FullSuccess := false;
    FName := pFTPPath + sFiles[n];
{$IFDEF FPC}
    Image := TPicture.Create;
{$ELSE}
    Image := TJPEGImage.Create;
{$ENDIF}
    iEXIF := TExifData.Create;
    try
      repeat

        // Load it
        Image.LoadFromFile(FName);

        // Delphi Bug, can not read jpeg compression!
        (*
          if (image.CompressionQuality>0) then
          begin
          Log('INFO: jpeg quality '+inttostr(image.CompressionQuality));
          end;
        *)

        if (Image.Width < 640) then
        begin
          Log(cERRORText + ' ' + sFiles[n] + ': Breite kleiner als 640');
          break;
        end;

        if (Image.Height < 480) then
        begin
          Log(cERRORText + ' ' + sFiles[n] + ': Höhe kleiner als 480');
          break;
        end;

        // get Foto-Moment, touch File-Date-Time
        if not(iEXIF.LoadFromGraphic(FName)) then
        begin
          Log(cERRORText + ' ' + sFiles[n] + ': EXiF konnte nicht geladen werden');
          break;
        end;

        if (iEXIF.DateTimeOriginal <> FileDateTime(FName)) then
        begin
          FileTouch(FName, iEXIF.DateTimeOriginal);
          Log(cINFOText + ' ' + sFiles[n] + ': Dateizeitstempel korrigiert');
        end;
        FullSuccess := true;

      until true;

    except
      on E: Exception do
      begin
        Log(cERRORText + ' ' + sFiles[n] + ': ' + E.Message);
      end;
    end;
    Image.Free;
    iEXIF.Free;

    if FullSuccess then
    begin
      if not(FileCopy(pFTPPath + sFiles[n], BackupDir + cFotoService_FTPBackupSubPath + ID + '-' + sFiles[n])) then
      begin
        Log(
          { } cERRORText + ' 598: ' +
          { } 'can not write to ' + BackupDir + cFotoService_FTPBackupSubPath);
        Log(cFotoService_AbortTag);
        exit;
      end;
    end
    else
    begin
      unverarbeitet(n);
    end;
  end;

  if (sFiles.count > 0) then
  begin

    ensureGlobals;

    bOrgaMon := TBLager.Create;
    bOrgaMon.Init(MyDataBasePath2 + 'AUFTRAG+TS', mderecOrgaMon, sizeof(TMDERec));
    bOrgaMon.BeginTransaction(now);

    if FileExists(MyDataBasePath2 + '_AUFTRAG+TS' + cBL_FileExtension) then
    begin
      bOrgaMonOld := TBLager.Create;
      bOrgaMonOld.Init(MyDataBasePath2 + '_AUFTRAG+TS', mderecOrgaMon, sizeof(TMDERec));
      bOrgaMonOld.BeginTransaction(now);
    end
    else
    begin
      bOrgaMonOld := nil;
    end;

    sFiles.sort;

    // Umbenennen nach dem Standard der jeweiligen Baustelle
    for m := pred(sFiles.count) downto 0 do
    begin
      RenameError := false;
      FullSuccess := false;
      FoundAuftrag := false;
      UmbenennungAbgeschlossen := false;
      BAUSTELLE_Index := -1;

      // Parameter aus der Bilddatei berechnen
      FotoGeraeteNo := nextp(sFiles[m], '-', 0);
      AUFTRAG_R := StrToIntDef(nextp(sFiles[m], '-', 1), -1);
      FotoParameter := nextp(nextp(sFiles[m], '-', 2), '.', 0);
      sBaustelle := '';
      sZiel := '';

      // passenden Auftrag suchen
      while true do
      begin

        if (AUFTRAG_R < 1) then
        begin
          Log(cERRORText + ' ' + sFiles[m] + ': RID konnte nicht ermittelt werden!');
          break;
        end;

        // Im OrgaMon Record-Store
        if bOrgaMon.exist(AUFTRAG_R) then
        begin
          bOrgaMon.get;
          FoundAuftrag := true;
          break;
        end;

        Log('WARNUNG: ' + sFiles[m] + ': RID in ' + bOrgaMon.FileName + ' nicht vorhanden!');

        // In der Alternative suchen
        if (assigned(bOrgaMonOld)) then
        begin
          if bOrgaMonOld.exist(AUFTRAG_R) then
          begin
            bOrgaMonOld.get;
            FoundAuftrag := true;
            break;
          end;

          Log('WARNUNG: ' + sFiles[m] + ': RID in ' + bOrgaMonOld.FileName + ' nicht vorhanden!');
        end;

        // Im aktuellen Auftrag des Monteurs
        assignFile(fOrgaMonAuftrag, pAppServicePath + cServerDataPath + FotoGeraeteNo + cDATExtension);
        try
          reset(fOrgaMonAuftrag);
        except
          on E: Exception do
            Log(cERRORText + ' 614: ' + sFiles[m] + ':' + E.Message);
        end;

        for f := 1 to FileSize(fOrgaMonAuftrag) do
        begin

          read(fOrgaMonAuftrag, mderecOrgaMon);
          if (AUFTRAG_R = mderecOrgaMon.RID) then
          begin
            FoundAuftrag := true;
            break;
          end;
        end;
        CloseFile(fOrgaMonAuftrag);
        if FoundAuftrag then
          break;
        Log(cERRORText + ' ' + sFiles[m] + ': RID ' + InttoStr(AUFTRAG_R) + ' konnte nicht gefunden werden!');
        break;
      end;

      if FoundAuftrag then
      begin

        sBaustelle := Oem2utf8(mderecOrgaMon.Baustelle);
        while true do
        begin

          // Modus der Fotobenennung ermitteln über Tabelle "BAUSTELLE"
          BAUSTELLE_Index := tBAUSTELLE.locate(0, sBaustelle);
          if (BAUSTELLE_Index > -1) then
          begin

            sFotoCall := TStringList.Create;
            with mderecOrgaMon do
            begin
              // Belegung der Foto-Parameter
              sFotoCall.Values[cParameter_foto_Modus] := tBAUSTELLE.readCell(BAUSTELLE_Index, cE_FotoBenennung);
              sFotoCall.Values[cParameter_foto_parameter] := FotoParameter;
              // bisheriger Bildparameter
              sFotoCall.Values[cParameter_foto_baustelle] := sBaustelle;
              sFotoCall.Values[cParameter_foto_strasse] := Oem2asci(Zaehler_Strasse);
              sFotoCall.Values[cParameter_foto_ort] := Oem2asci(Zaehler_Ort);
              sFotoCall.Values[cParameter_foto_zaehler_info] := Zaehler_Info;
              sFotoCall.Values[cParameter_foto_RID] := InttoStr(RID);

              sFotoCall.Values[cParameter_foto_ART] := art;
              sFotoCall.Values[cParameter_foto_zaehlernummer_alt] := zaehlernummer_alt;
              sFotoCall.Values[cParameter_foto_zaehlernummer_neu] := zaehlernummer_neu;
              sFotoCall.Values[cParameter_foto_ReglerNummer_neu] := Reglernummer_neu;
              sFotoCall.Values[cParameter_foto_geraet] := FotoGeraeteNo;
              sFotoCall.Values[cParameter_foto_Pfad] := pAppServicePath + cDBPath;
              sFotoCall.Values[cParameter_foto_Datei] := pFTPPath + sFiles[m];
              sFotoCall.Values[cParameter_foto_ABNummer] := ABNummer;
            end;
            sFotoResult := JonDaExec.Foto(sFotoCall);
            sFotoCall.Free;

            // Ergebnis auswerten
            FotoDateiName := sFotoResult.Values[cParameter_foto_neu];
            UmbenennungAbgeschlossen := (sFotoResult.Values[cParameter_foto_fertig] = JonDaExec.active(true));
            sZiel := sFotoResult.Values[cParameter_foto_Ziel];

            if (sFotoResult.Values[cParameter_foto_Fehler] <> '') then
            begin
              RenameError := true;
              Log(cERRORText + ' ' + sFotoResult.Values[cParameter_foto_Fehler]);
            end;

            sFotoResult.Free;

            if (sBaustelle <> sZiel) then
              BAUSTELLE_Index := tBAUSTELLE.locate(0, sZiel);

          end;

          //
          if (BAUSTELLE_Index <= -1) then
          begin
            Log(cERRORText + ' ' + sFiles[m] + ': Baustelle "' + sBaustelle + '" unbekannt!');
          end;

          break;
        end;

        //
        if (BAUSTELLE_Index > -1) and not(RenameError) then
        begin

          FotoZiel := tBAUSTELLE.readCell(BAUSTELLE_Index, cE_FTPUSER);
          repeat

            if (length(FotoZiel) < 3) then
            begin
              Log(cERRORText + ' ' + sFiles[m] + ': ' + sBaustelle + ': Keine Internet-Ablage definiert');
              break;
            end;

            // Workaround, Linux User mit Ziffer am Anfang geht nicht
            if (FotoZiel[1] = 'u') and CharInSet(FotoZiel[2], ['0' .. '9']) then
              FotoZiel := copy(FotoZiel, 2, MaxInt);

            // Fotoziel ist der Name der Internet-Ablage nicht der
            // des SAP Verzeichnisses
            FotoZiel := nextp(FotoZiel, '\', 0);

            r := tABLAGE.locate('NAME', FotoZiel { + } );
            if (r = -1) then
            begin
              Log(cERRORText + ' ' + sFiles[m] + ': ' + sBaustelle + ': Internet-Ablage "' + FotoZiel +
                '": Die Ablage ist nicht bekannt');
              break;
            end;

            FotoAblage_PFAD := tABLAGE.readCell(r, 'PFAD');
            if not(DirExists(FotoAblage_PFAD)) then
            begin
              Log(cERRORText + ' ' + sFiles[m] + ': ' + sBaustelle + ': Internet-Ablage "' + FotoZiel +
                '": Das Verzeichnis "' + FotoAblage_PFAD + '" existiert nicht');
              break;
            end;

            // freien Ziel-Dateinamen finden:
            FotoDateiNameVerfuegbar := FotoDateiName;
            i := 1;
            repeat
              if not(FileExists(FotoAblage_PFAD + '\' + FotoDateiNameVerfuegbar)) then
                break;
              if (i = 1) then
                FotoDateiNameVerfuegbar := copy(FotoDateiNameVerfuegbar, 1, revpos('.', FotoDateiNameVerfuegbar) - 1) +
                  '-' + InttoStr(i) + '.jpg'
              else
                FotoDateiNameVerfuegbar := copy(FotoDateiNameVerfuegbar, 1, revpos('-', FotoDateiNameVerfuegbar) - 1) +
                  '-' + InttoStr(i) + '.jpg';
              inc(i);
            until false;

            // Ist der Dateiname schon belegt, wird ggf. Platz geschaffen.
            // Der hereinkommende Name hat Vorrang vor den bisher
            // unter diesem Namen bereitgestellten Bildern.
            // Aber nur wenn die hereinkommende Datei jünger ist
            // als das aktuelle Bild
            if (FotoDateiName <> FotoDateiNameVerfuegbar) then
            begin
              if (
                { } FotoAufnahmeMoment(pFTPPath + sFiles[m])
                { } >=
                { } FotoAufnahmeMoment(FotoAblage_PFAD + FotoDateiName)) then
              begin
                if not(RenameFile(
                  { } FotoAblage_PFAD + FotoDateiName,
                  { } FotoAblage_PFAD + FotoDateiNameVerfuegbar)) then
                begin
                  Log(cERRORText + ' 802: ' + sFiles[m] + ': Platz schaffen nicht erfolgreich');
                  break;
                end;
              end
              else
              begin
                Log(cINFOText + ' ' + sFiles[m] + ': Veraltetes Bild, behalte Neueres');
                FotoDateiName := FotoDateiNameVerfuegbar;
              end;
            end;

            // Transaktion archivieren
            AppendStringsToFile(
              { } 'cp ' + sFiles[m] +
              { } ' ' +
              { } FotoAblage_PFAD + FotoDateiName,
              { } DiagnosePath + cFotoTransaktionenFName);
            LastLogWasTimeStamp := false;

            // aktueller Dateiname, wo er im Moment liegt
            DATEINAME_AKTUELL := FotoAblage_PFAD + FotoDateiName;
            if JonDaExec.oldInfrastructure then
              DATEINAME_AKTUELL := copy(DATEINAME_AKTUELL, 4, MaxInt);

            // Auszeichnen, wenn die Umbenennung vorläufig ist
            if not(UmbenennungAbgeschlossen) then
              AppendStringsToFile(
                { DATEINAME_ORIGINAL } sFiles[m] + ';' +
                { DATEINAME_AKTUELL } DATEINAME_AKTUELL + ';' +
                { RID } InttoStr(AUFTRAG_R) + ';' +
                { GERAETENO } FotoGeraeteNo + ';' +
                { BAUSTELLE } ';' +
                { MOMENT } DatumLog,
                { Dateiname } MyDataBasePath2 + cFotoService_UmbenennungAusstehendFName);

            // Foto in die richtige Ablage kopieren!
            if not(FileCopy(
              { } pFTPPath + sFiles[m],
              { } FotoAblage_PFAD + FotoDateiName)) then
            begin
              Log(cERRORText + ' {' + sFiles[m] + ': Kopieren nicht erfolgreich');
              Log('Quelle war: "' + pFTPPath + sFiles[m] + '"');
              Log('Ziel war: "' + FotoAblage_PFAD + '\' + FotoDateiName + '" }');
              break;
            end;

            FullSuccess := true;

          until true;
        end;

      end;

      if not(FullSuccess) then
        unverarbeitet(m);

    end; // for m

    bOrgaMon.EndTransaction;
    bOrgaMon.Free;

    if assigned(bOrgaMonOld) then
    begin
      bOrgaMonOld.EndTransaction;
      bOrgaMonOld.Free;
    end;

    // Bilder jetzt einfach sichern
    if (sFiles.count > 0) then
    begin
      (*
        if (zip(
        { } sFiles,
        { } MobUploadPath + ID + '-Bilder.zip',
        { } infozip_RootPath + '=' + MobUploadPath) = sFiles.count) then
        begin
        Log(ID);
        for n := 0 to pred(sFiles.count) do
        if not(FileDelete(MobUploadPath + sFiles[n])) then
        begin
        Log('ERROR: ' + 'can not delete ' + sFiles[n]);
        Timer1.Enabled := false;
        exit;
        end;
        end
        else
        begin
        Log('ERROR: Fehler beim Anlegen der ZIP-Datei!');
        end;
      *)

      Log(ID);
      for n := 0 to pred(sFiles.count) do
        if not(FileDelete(pFTPPath + sFiles[n])) then
        begin
          Log(cERRORText + ' "' + pFTPPath + sFiles[n] + '" : Nicht löschbar');
          Log(cFotoService_AbortTag);
          break;
        end;

    end;
  end;

  sFiles.Free;
  sFilesClientSorter.Free;
end;

procedure TFotoExec.workWartend(sParameter: TStringList = nil);
var
  WARTEND: tsTable;
  Stat_Anfangsbestand: integer;
  Stat_NachtragBaustelle: integer;
  Stat_ZuAlt: integer;
  Stat_Verschwunden: integer;
  Stat_Doppelt: integer;
  Stat_Umbenannt: integer;

  col_MOMENT: integer;
  col_DATEINAME_AKTUELL: integer;

  MomentTimeout: TANFiXDate;
  CSV: tsTable;
  r, i, k, ro, c: integer;

  ZAEHLER_NUMMER_NEU: string;
  REGLER_NUMMER_NEU: string;
  NEU: string;

  ORIGINAL_DATEI: string;
  DATEINAME_AKTUELL: string;
  PARAMETER: string;
  FNameAlt, FNameNeu: string;
  RID: integer;
  sBaustelle: string;
  BAUSTELLE_Index: integer;

  // Baustellen-Ermittlung
  bOrgaMon: TBLager;
  mderecOrgaMon: TMDERec;
  FotoBenennungsModus: integer;

  // senden einfärben
  tSENDEN: tsTable;

  // Doppelten Erkennung
  slAKTUELL: TStringList;

begin

  // Init
  ensureGlobals;
  invalidate_NummerNeuCache;

  CSV := nil;
  WARTEND := tsTable.Create;
  with WARTEND do
  begin

    // load+sort
    insertfromFile(MyDataBasePath2 + cFotoService_UmbenennungAusstehendFName);

    // init Global Stat
    Stat_Anfangsbestand := RowCount;
    Stat_Umbenannt := 0;
    Stat_NachtragBaustelle := 0;

    // Sortieren
    SortBy('GERAETENO;MOMENT;DATEINAME_AKTUELL');
    if Changed then
      Log(
        { } cINFOText + ' 988: ' +
        { } ' Frisch sortiert');

    // sicherstellen von Spalten
    addCol('BAUSTELLE');
    addCol('MOMENT');

    // all zu alte Einträge löschen
    MomentTimeout := DatePlus(DateGet, -cMaxAge_Umbenennen);
    slAKTUELL := TStringList.Create;
    Stat_ZuAlt := 0;
    Stat_Verschwunden := 0;
    Stat_Doppelt := 0;
    col_MOMENT := colof('MOMENT');
    col_DATEINAME_AKTUELL := colof('DATEINAME_AKTUELL');
    for r := RowCount downto 1 do
    begin

      DATEINAME_AKTUELL := readCell(r, col_DATEINAME_AKTUELL);
      if JonDaExec.oldInfrastructure then
        DATEINAME_AKTUELL := 'W:\' + DATEINAME_AKTUELL;

      if (StrToIntDef(readCell(r, col_MOMENT), ccMaxDate) < MomentTimeout) then
      begin
        del(r);
        inc(Stat_ZuAlt);
        Log(
          { } cWARNINGText + ' 1049: ' +
          { } 'gebe "' + DATEINAME_AKTUELL + '" auf, da sie älter als ' + InttoStr(cMaxAge_Umbenennen) + ' Tage ist');
        continue;
      end;

      if not(FileExists(DATEINAME_AKTUELL)) then
      begin
        del(r);
        inc(Stat_Verschwunden);
        Log(
          { } cWARNINGText + ' 1059: ' +
          { } 'gebe "' + DATEINAME_AKTUELL + '" auf, da sie verschwunden ist');
        continue;
      end;

      if (slAKTUELL.IndexOf(DATEINAME_AKTUELL) <> -1) then
      begin
        del(r);
        inc(Stat_Doppelt);
        Log(
          { } cWARNINGText + ' 1069: ' +
          { } 'gebe "' + DATEINAME_AKTUELL + '" auf, da er Eintrag doppelt ist');
        continue;
      end;

      slAKTUELL.add(DATEINAME_AKTUELL);
    end;
    slAKTUELL.Free;
  end;

  bOrgaMon := TBLager.Create;
  bOrgaMon.Init(MyDataBasePath2 + 'AUFTRAG+TS', mderecOrgaMon, sizeof(TMDERec));
  bOrgaMon.BeginTransaction(now);

  for r := WARTEND.RowCount downto 1 do
  begin

    // Init
    ZAEHLER_NUMMER_NEU := '';
    REGLER_NUMMER_NEU := '';
    NEU := '';

    // Parameter Init
    RID := StrToIntDef(WARTEND.readCell(r, 'RID'), 0);
    ORIGINAL_DATEI := WARTEND.readCell(r, 'DATEINAME_ORIGINAL');
    PARAMETER := nextp(ORIGINAL_DATEI, '-', 2);
    ersetze('.jpg', '', PARAMETER);

    // Prüfe auf erlaubte ('FE','FN')
    repeat
      if (PARAMETER = 'FN') then
        break;
      if (PARAMETER = 'FE') then
        break;
      Log(cERRORText + ' 987: Parameter "' + PARAMETER + '" ist bei der -Neu Behandlung unbekannt');
      continue;
    until true;

    // Nachtrag der Baustellen-Info
    sBaustelle := WARTEND.readCell(r, 'BAUSTELLE');
    if (sBaustelle = '') then
      if bOrgaMon.exist(RID) then
      begin
        bOrgaMon.get;
        sBaustelle := Oem2utf8(mderecOrgaMon.Baustelle);
        WARTEND.writeCell(r, 'BAUSTELLE', sBaustelle);
        inc(Stat_NachtragBaustelle);
      end;

    // Ist bei dieser Baustelle eine Umbenennung überhaupt erwünscht?
    // Die Frage sei dann aber erlaubt: Warum steht es dann in WARTEND?
    if (sBaustelle <> '') then
    begin
      BAUSTELLE_Index := tBAUSTELLE.locate(0, sBaustelle);
      if (BAUSTELLE_Index > -1) then
      begin
        FotoBenennungsModus := StrToIntDef(
          { } tBAUSTELLE.readCell(
          { } BAUSTELLE_Index,
          { } cE_FotoBenennung), 0);
      end;
    end;

    if (PARAMETER = 'FN') then
    begin

      // Umbenennungsversuch über den Callback, in dem Fall also die Monteurs-Eingaben "Eingabe.nnn.txt"
      if (ZAEHLER_NUMMER_NEU = '') then
        ZAEHLER_NUMMER_NEU :=
        { } ZaehlerNummerNeu(
          { } RID,
          { } WARTEND.readCell(r, 'GERAETENO'));

      // Zuschaltbare Alternative für Notfälle: den Inhalt einer CSV prüfen
      if (ZAEHLER_NUMMER_NEU = '') then
        if ZaehlerNummerNeuXlsCsv_Vorhanden then
        begin
          if not(assigned(CSV)) then
          begin
            CSV := tsTable.Create;
            CSV.insertfromFile(MyDataBasePath + 'ZaehlerNummerNeu.xls.csv');
          end;
          ro := CSV.locate('ReferenzIdentitaet', InttoStr(RID));
          if (ro <> -1) then
            ZAEHLER_NUMMER_NEU := CSV.readCell(ro, 'ZaehlerNummerNeu');
        end;

      // kein Ergebnis -> keine Aktion
      if (ZAEHLER_NUMMER_NEU = '') then
        continue;

      NEU := ZAEHLER_NUMMER_NEU { + };
    end;

    if (PARAMETER = 'FE') then
    begin

      // Umbenennungsversuch über den Callback, in dem Fall also die Monteurs-Eingaben "Eingabe.nnn.txt"
      if (REGLER_NUMMER_NEU = '') then
        REGLER_NUMMER_NEU :=
        { } ReglerNummerNeu(
          { } RID,
          { } WARTEND.readCell(r, 'GERAETENO'));

      // Zuschaltbare Alternative für Notfälle: den Inhalt einer CSV prüfen
      if (REGLER_NUMMER_NEU = '') then
        if ZaehlerNummerNeuXlsCsv_Vorhanden then
        begin
          if not(assigned(CSV)) then
          begin
            CSV := tsTable.Create;
            CSV.insertfromFile(MyDataBasePath + 'ZaehlerNummerNeu.xls.csv');
          end;
          ro := CSV.locate('ReferenzIdentitaet', InttoStr(RID));
          if (ro <> -1) then
            REGLER_NUMMER_NEU := CSV.readCell(ro, 'ReglerNummerNeu');
        end;

      // kein Ergebnis -> keine Aktion
      if (REGLER_NUMMER_NEU = '') then
        continue;

      NEU := REGLER_NUMMER_NEU { + };
    end;

    // nichts neues? -> nichts machen in diesem Fall
    if (NEU = '') then
      continue;

    // Umbenennung starten
    FNameAlt := WARTEND.readCell(r, 'DATEINAME_AKTUELL');
    if JonDaExec.oldInfrastructure then
      FNameAlt := 'W:\' + FNameAlt;
    FNameNeu := FNameAlt;

    // das letzte "Neu" am Ende des Dateinamens zählt
    k := revpos(cFotoService_NeuPlatzhalter, FNameNeu);
    if (k = 0) then
    begin
      Log(
        { } cERRORText + ' 1179: ' +
        { } 'keine Ahnung wie man "' + FNameNeu + '" umbenennen soll');
      continue;
    end;

    // Neuen Dateinamen zusammenbauen
    FNameNeu :=
    { } copy(FNameNeu, 1, pred(k)) +
    { } TJonDaExec.FormatZaehlerNummerNeu(NEU) +
    { } '.jpg';

    // die (TMP..)- Sachen wieder wegzumachen
    FNameNeu := JonDaExec.clearTempTag(FNameNeu);

    // Laufwerksbuchstaben
    if (CharCount(':', FNameNeu) <> 1) then
    begin
      Log(
        { } cERRORText + ' 1195: ' +
        { } 'Umbenennung zu "' + FNameNeu + '" ist ungültig. Laufwerksangabe mit ":" fehlt');
      continue;
    end;

    // Pfad ging irgendwie verloren
    if (CharCount('\', FNameNeu) < 2) then
    begin
      Log(
        { } cERRORText + ' 1211: ' +
        { } 'Umbenennung zu "' + FNameNeu + '" ist ungültig. Zwei Pfadtrenner "\" fehlen');
      continue;
    end;

    if (FNameNeu = FNameAlt) then
    begin
      // ohne Umbenennung (also es stimmt bereits!) einfach nur den Eintrag löschen!
      WARTEND.del(r);
      inc(Stat_Umbenannt);
    end
    else
    begin

      // freien Ziel-Dateinamen finden:
      i := 1;
      repeat
        if not(FileExists(FNameNeu)) then
          break;
        if (i = 1) then
          FNameNeu := copy(FNameNeu, 1, revpos('.', FNameNeu) - 1) + '-' + InttoStr(i) + '.jpg'
        else
          FNameNeu := copy(FNameNeu, 1, revpos('-', FNameNeu) - 1) + '-' + InttoStr(i) + '.jpg';
        inc(i);
      until false;

      if FileMove(FNameAlt, FNameNeu) then
      begin
        AppendStringsToFile(
          { } 'mv ' + FNameAlt +
          { } ' ' + FNameNeu,
          { } DiagnosePath + cFotoTransaktionenFName);
        LastLogWasTimeStamp := false;

        WARTEND.del(r);
        inc(Stat_Umbenannt);
      end
      else
      begin
        Log(cERRORText + ' 1280: FileMove("' + FNameAlt + '", "' + FNameNeu + '")');
        Log(cFotoService_AbortTag);
      end;
    end;
  end;

  bOrgaMon.EndTransaction;
  bOrgaMon.Free;

  if WARTEND.Changed then
  begin

    // recreate senden.html, muss jemand noch "senden"
    tSENDEN := tsTable.Create;
    with tSENDEN do
    begin
      insertfromFile(pAppServicePath + cDBPath + cAppService_SendenFName);
      i := addCol('PAPERCOLOR');
      k := WARTEND.colof('GERAETENO');
      c := colof('ID');
      for r := 1 to RowCount do
        if (WARTEND.locate(k, readCell(r, c)) <> -1) then
          writeCell(r, i, '#FFFF00');
      SaveToHTML(pAppStatistikPath + 'senden.html');
    end;
    tSENDEN.Free;

    // save WARTEND / save as html
    WARTEND.SaveToHTML(pAppStatistikPath + '-neu.html');
    WARTEND.SaveToFile(MyDataBasePath2 + cFotoService_UmbenennungAusstehendFName);

    // LOG
    if (Stat_Umbenannt > 0) then
      Log(cINFOText + ' 1276: ' +
        { } InttoStr(Stat_Umbenannt) +
        { } ' "-Neu" Umbenennung(en) wurde(n) durchgeführt, ' +
        { } InttoStr(WARTEND.RowCount) +
        { } ' verbleiben');

    if (Stat_NachtragBaustelle > 0) then
      Log(cINFOText + ' 1283: ' +
        { } InttoStr(Stat_NachtragBaustelle) +
        { } ' Baustelleninfo(s) wurde(n) nachgetragen');

  end;

  WARTEND.Free;
  if assigned(CSV) then
    CSV.Free;
end;

function TFotoExec.AblageLogFname: string;
begin
  result := DiagnosePath + format(cFotoAblageFName, [DatumLog]);
end;

procedure TFotoExec.workAblage(sParameter: TStringList = nil);

  procedure AblageLog(Source, Dest: string);
  begin
    AppendStringsToFile(sTimeStamp + ';' + Source + ';' + Dest, AblageLogFname);
  end;

const
  cFileTimeOutDays = 50 + 10;
  // 0 = gestern ist schon zu alt
  cPicTimeOutDays = 0;
var
  // Infrastruktur
  Ablage_NAME: string;
  Ablage_PFAD: string;
  ZIP_OlderThan: TANFiXDate;
  PIC_OlderThan: TANFiXDate;
  WARTEND: tsTable;
  col_DATEINAME_AKTUELL: integer;

  Col_FTP_Benutzer: integer;
  Col_ZIPPASSWORD: integer;
  MovedToDay: int64;

  procedure serviceJPG;
  const
    cMaxZIP_Size = 100 * 1024 * 1024;
  var
    m, r: integer;
    Pending: boolean;
    FotoFSize: int64;
    sPics: TStringList;
    mIni: TIniFile;
    FTP_Benutzer: string;
    FotosSequence: integer;
    FotosAbzug: boolean;
    sOldZips: TStringList;
    DATEINAME_AKTUELL: string;
  begin
    Pending := false;
    sPics := TStringList.Create;
    sOldZips := TStringList.Create;
    repeat
      // Jpegs
      dir(Ablage_PFAD + '*.jpg', sPics, false);
      if (sPics.count = 0) then
        break;

      // reduziere um "zu neue" Bilder
      for m := pred(sPics.count) downto 0 do
        if (FileDate(Ablage_PFAD + sPics[m]) >= PIC_OlderThan) then
          sPics.Delete(m);
      if (sPics.count = 0) then
        break;

      // reduziere um "wartende" Bilder
      for m := pred(sPics.count) downto 0 do
      begin
        DATEINAME_AKTUELL := Ablage_PFAD + sPics[m];
        if JonDaExec.oldInfrastructure then
          DATEINAME_AKTUELL := copy(DATEINAME_AKTUELL, 4, MaxInt);

        if (WARTEND.locate(col_DATEINAME_AKTUELL, DATEINAME_AKTUELL) <> -1) then
          sPics.Delete(m);
      end;
      if (sPics.count = 0) then
        break;

      // reduziere auf < 100 MByte
      FotoFSize := 0;
      for m := pred(sPics.count) downto 0 do
      begin
        if (FotoFSize >= cMaxZIP_Size) then
        begin
          sPics.Delete(m);
          Pending := true;
        end
        else
        begin
          inc(FotoFSize, FSize(Ablage_PFAD + sPics[m]));
        end;
      end;

      // Prüfen, ob dies eine ordentliche Baustelle ist
      FTP_Benutzer := Ablage_NAME;
      r := tBAUSTELLE.locate(Col_FTP_Benutzer, FTP_Benutzer);
      if (r = -1) then
      begin
        // 2. Suchversuch mit prefixed "u"
        if CharInSet(FTP_Benutzer[1], ['0' .. '9']) then
        begin
          FTP_Benutzer := 'u' + FTP_Benutzer;
          r := tBAUSTELLE.locate(Col_FTP_Benutzer, FTP_Benutzer);
        end;
      end;

      // (immer noch) nicht gefunden?
      if (r = -1) then
      begin
        Log(cERRORText + ' FTP-Benutzer "' + FTP_Benutzer + '" unbekannt');
        Pending := false;
        break;
      end;

      // Die Nummer des zu erzeugenden ZIP suchen
      FotosAbzug := false;
      mIni := TIniFile.Create(Ablage_PFAD + 'Fotos-nnnn.ini');
      with mIni do
      begin
        FotosSequence := StrToInt(ReadString('System', 'Sequence', '-1'));
        FotosAbzug := (ReadString('System', 'Abzug', cIni_Deactivate) = cINI_ACTIVATE);
        if FotosSequence < 0 then
        begin
          dir(Ablage_PFAD + 'Fotos-????.zip', sOldZips, false);
          if sOldZips.count > 0 then
          begin
            sOldZips.sort;
            FotosSequence := StrToIntDef(ExtractSegmentBetween(sOldZips[pred(sOldZips.count)], 'Fotos-', '.zip'), -1);
          end;
        end;
        if (FotosSequence < 0) then
          FotosSequence := 0;
        inc(FotosSequence);
      end;
      mIni.Free;

      // Archivieren in Fotos-nnnn.zip
      AblageLog(Ablage_PFAD + 'Fotos-' + inttostrN(FotosSequence, cAnzahlStellen_FotosTagwerk) + '.zip', '.');
      if (zip(
        { } sPics,
        { } Ablage_PFAD +
        { } 'Fotos-' + inttostrN(FotosSequence, cAnzahlStellen_FotosTagwerk) + '.zip',
        { } infozip_RootPath + '=' + Ablage_PFAD + ';' +
        { } infozip_Password + '=' +
        { } deCrypt_Hex(
        { } tBAUSTELLE.readCell(r, Col_ZIPPASSWORD)) + ';' +
        { } infozip_Level + '=' + '0') <> sPics.count) then
      begin
        // Problem anzeigen
        Log(cERRORText + ' ' + HugeSingleLine(zMessages, '|'));
        Pending := false;
        break;
      end;

      if FotosAbzug then
      begin
        // Archivieren auch in Abzug-nnnn.zip

        for m := 0 to pred(sPics.count) do
          FotoCompress(Ablage_PFAD + sPics[m], Ablage_PFAD + sPics[m], 94, 6);

        AblageLog(Ablage_PFAD + 'Abzug-' + inttostrN(FotosSequence, cAnzahlStellen_FotosTagwerk) + '.zip', '.');
        if (zip(
          { } sPics,
          { } Ablage_PFAD +
          { } 'Abzug-' + inttostrN(FotosSequence, cAnzahlStellen_FotosTagwerk) + '.zip',
          { } infozip_RootPath + '=' + Ablage_PFAD + ';' +
          { } infozip_Password + '=' +
          { } deCrypt_Hex(
          { } tBAUSTELLE.readCell(r, Col_ZIPPASSWORD)) + ';' +
          { } infozip_Level + '=' + '0') <> sPics.count) then
        begin
          // Problem anzeigen
          Log(cERRORText + ' ' + HugeSingleLine(zMessages, '|'));
          Pending := false;
          break;
        end;

      end;

      // Fotos-nnnn.ini erhöhen
      mIni := TIniFile.Create(Ablage_PFAD + 'Fotos-nnnn.ini');
      mIni.WriteString('System', 'Sequence', InttoStr(FotosSequence));
      mIni.Free;

      // nun die eben archivierten JPGS schlussendlich löschen!
      for m := 0 to pred(sPics.count) do
        FileDelete(Ablage_PFAD + sPics[m]);

    until true;
    sPics.Free;
    sOldZips.Free;

    if Pending then
      serviceJPG;
  end;

  procedure serviceHTML;
  var
    m, r: integer;
    sHTMLSs: TStringList;
    mIni: TIniFile;
    FTP_Benutzer: string;
    FotosSequence: integer;
    sOldZips: TStringList;
  begin
    sHTMLSs := TStringList.Create;
    sOldZips := TStringList.Create;
    repeat

      // Jpegs
      dir(Ablage_PFAD + '*.zip.html', sHTMLSs, false);
      if (sHTMLSs.count = 0) then
        break;

      // reduziere um "zu neue" Bilder
      for m := pred(sHTMLSs.count) downto 0 do
        if (FileDate(Ablage_PFAD + sHTMLSs[m]) >= PIC_OlderThan) then
          sHTMLSs.Delete(m);
      if (sHTMLSs.count = 0) then
        break;

      // reduziere um "wartende" Wechselbelege, bei denen das pdf fehlt!
      for m := pred(sHTMLSs.count) downto 0 do
        if not(FileExists(Ablage_PFAD + sHTMLSs[m] + '.pdf')) then
          sHTMLSs.Delete(m);
      if (sHTMLSs.count = 0) then
        break;

      // .pdf muss auch mit!
      // erweitere um die .pdf Dateien
      for m := 0 to pred(sHTMLSs.count) do
        sHTMLSs.add(sHTMLSs[m] + '.pdf');

      // Prüfen, ob dies eine ordentliche Baustelle ist
      FTP_Benutzer := Ablage_NAME;
      if CharInSet(FTP_Benutzer[1], ['0' .. '9']) then
        FTP_Benutzer := 'u' + FTP_Benutzer;
      r := tBAUSTELLE.locate(Col_FTP_Benutzer, FTP_Benutzer);
      if (r = -1) then
        break;

      // Die Nummer des zu erzeugenden ZIP suchen
      mIni := TIniFile.Create(Ablage_PFAD + 'Wechselbelege-nnnn.ini');
      with mIni do
      begin
        FotosSequence := StrToInt(ReadString('System', 'Sequence', '-1'));
        if (FotosSequence < 0) then
        begin
          dir(Ablage_PFAD + 'Wechselbelege-????.zip', sOldZips, false);
          if sOldZips.count > 0 then
          begin
            sOldZips.sort;
            FotosSequence := StrToIntDef(ExtractSegmentBetween(sOldZips[pred(sOldZips.count)], 'Wechselbelege-',
              '.zip'), -1);
          end;
        end;

        if FotosSequence < 0 then
          FotosSequence := 0;

        inc(FotosSequence);
      end;
      mIni.Free;

      // Archivieren
      AblageLog(Ablage_PFAD + 'Wechselbelege-' + inttostrN(FotosSequence, cAnzahlStellen_FotosTagwerk) + '.zip', '.');
      if (zip(
        { } sHTMLSs,
        { } Ablage_PFAD +
        { } 'Wechselbelege-' + inttostrN(FotosSequence, cAnzahlStellen_FotosTagwerk) + '.zip',
        { } infozip_RootPath + '=' + Ablage_PFAD + ';' +
        { } infozip_Password + '=' +
        { } deCrypt_Hex(
        { } tBAUSTELLE.readCell(r, Col_ZIPPASSWORD)) + ';' +
        { } infozip_Level + '=' + '0') <> sHTMLSs.count) then
      begin
        // Problem anzeigen
        Log(cERRORText + ' ' + HugeSingleLine(zMessages, '|'));
        break;
      end;

      // Laufnummer erhöhen
      mIni := TIniFile.Create(Ablage_PFAD + 'Wechselbelege-nnnn.ini');
      mIni.WriteString('System', 'Sequence', InttoStr(FotosSequence));
      mIni.Free;

      // nun die eben archivierten löschen!
      for m := 0 to pred(sHTMLSs.count) do
        FileDelete(Ablage_PFAD + sHTMLSs[m]);

    until true;
    sHTMLSs.Free;
    sOldZips.Free;
  end;

  procedure serviceZIP;
  var
    sZips: TStringList;
    m: integer;
  begin
    sZips := TStringList.Create;
    dir(Ablage_PFAD + '*.zip', sZips, false);
    for m := 0 to pred(sZips.count) do
    begin
      if (FileDate(Ablage_PFAD + sZips[m]) < ZIP_OlderThan) then
      begin
        CheckCreateDir(BackupDir + Ablage_NAME);
        if FileMove(
         {} Ablage_PFAD + sZips[m],
         {} BackupDir + Ablage_NAME + '\' + sZips[m]) then
        begin
          inc(MovedToDay, FSize(Ablage_PFAD + sZips[m]));
          AblageLog(Ablage_PFAD + sZips[m], BackupDir);
        end
        else
        begin
          Log(cERRORText +
            { } ' 1645: FileMove("' +
            { } Ablage_PFAD + sZips[m] + '", "' +
            { } BackupDir + Ablage_NAME + '\' + sZips[m] + '")');
          Log(cFotoService_AbortTag);
        end;
      end;
    end;
    sZips.Free;
  end;

var
  BasisDatum: TANFiXDate;

  // Parameter
  pDatum: string;
  pEinzeln: string;
  r: integer;

begin

  // Set "Lock" for this day
  FileAlive(AblageLogFname);

  ensureGlobals;

  if assigned(sParameter) then
  begin
    pDatum := sParameter.Values['DATUM'];
    pEinzeln := sParameter.Values['EINZELN'];
  end
  else
  begin
    pDatum := '';
    pEinzeln := '';
  end;

  // Infos über Baustellen
  Col_FTP_Benutzer := tBAUSTELLE.colof(cE_FTPUSER);
  Col_ZIPPASSWORD := tBAUSTELLE.colof(cE_ZIPPASSWORD);

  // Infos über noch nicht umbenannte Dateien
  WARTEND := tsTable.Create;
  WARTEND.insertfromFile(MyDataBasePath2 + cFotoService_UmbenennungAusstehendFName);
  col_DATEINAME_AKTUELL := WARTEND.colof('DATEINAME_AKTUELL');

  //
  if (pDatum = '') then
  begin
    BasisDatum := DateGet;
  end
  else
  begin
    BasisDatum := date2long(pDatum);
  end;

  // init
  MovedToDay := 0;
  ZIP_OlderThan := DatePlus(BasisDatum, -cFileTimeOutDays);
  PIC_OlderThan := DatePlus(BasisDatum, -cPicTimeOutDays);

  for r := 1 to tABLAGE.RowCount do
  begin

    Ablage_NAME := cutblank(tABLAGE.readCell(r, 'NAME'));

    if (Ablage_NAME = '') then
      continue;

    //
    if (pEinzeln <> '') then
      if (pEinzeln <> Ablage_NAME) then
        continue;

    //
    Ablage_PFAD := cutblank(tABLAGE.readCell(r, 'PFAD'));

    if (Ablage_PFAD = '') then
    begin
      Log(cERRORText + ' Bei Ablage "' + Ablage_NAME + '"  ist kein Pfad definiert');
      continue;
    end;

    if not(DirExists(Ablage_PFAD)) then
    begin
      Log(cERRORText + ' Zu Ablage "' + Ablage_NAME + '"  existiert "' + Ablage_PFAD + '" nicht');
      continue;
    end;

    // ganz alte Zips ablegen
    try
      serviceZIP;
    except
      on E: Exception do
        Log(cERRORText + ' :serviceZIP(' + Ablage_NAME + '): ' + E.ClassName + ': ' + E.Message);
    end;

    // jpgs von gestern zippen
    try
      serviceJPG;
    except
      on E: Exception do
        Log(cERRORText + ' :serviceJPG(' + Ablage_NAME + '): ' + E.ClassName + ': ' + E.Message);
    end;

    // htmls von gestern zippen
    try
      serviceHTML;
    except
      on E: Exception do
        Log(cERRORText + ' :serviceHTML(' + Ablage_NAME + '): ' + E.ClassName + ': ' + E.Message);
    end;

  end;

  // unprepare
  WARTEND.Free;
  AblageLog('ENDE', '*');

end;

procedure TFotoExec.workStatus;
var
  sDir: TStringList;
  n: integer;
  FileDateTime: TDateTime;
  sMonteure: TStringList;
  m: string;
  sTabelle: tsTable;
begin
  sDir := TStringList.Create;
  sMonteure := TStringList.Create;
  sTabelle := tsTable.Create;

  try
    dir(pFTPPath + '*.$$$', sDir, false);
    sDir.sort;

    // Aktuelle Uploads (=Dateien im aktuellem Zugriff) entfernen
    for n := pred(sDir.count) downto 0 do
    begin
      if not(FileAge(pFTPPath + sDir[n], FileDateTime)) then
      begin
        // Datei ist verschwunden!
        sDir.Delete(n);
        continue;
      end;
      if (SecondsDiff(now, FileDateTime) < 120) then
      begin
        // Datei wird gerade hochgeladen, bzw. ist zu frisch
        sDir.Delete(n);
        continue;
      end;
    end;

    for n := 0 to pred(sDir.count) do
    begin
      m := nextp(sDir[n], '-', 0);
      if (sMonteure.IndexOf(m) = -1) then
        sMonteure.add(m);
    end;

    sTabelle.addCol('Gerät', sMonteure);
    // imp pend:
    // bisher W:\status\index.html
    sTabelle.SaveToHTML(pWebPath + 'ausstehende-fotos.html');
    // imp pend:
    // bisher W:\status\ausstehende-fotos.csv
    // sTabelle.SaveToFile(pWebPath + 'ausstehende-fotos.csv');

  except

  end;
  sDir.Free;
  sMonteure.Free;
  sTabelle.Free;
end;

procedure TFotoExec.workSync;
var
  iFTP: TIdFTP;
  sDir: TStringList;
  n: integer;
  BaustellePath: string;
begin

  // Sync Down
  iFTP := TIdFTP.Create(nil);
  SolidInit(iFTP);
  with iFTP do
  begin
    Host := iJonDa_FTPHost;
    UserName := iJonDa_FTPUserName;
    Password := iJonDa_FTPPassword;
  end;

  // Get
  try
    SolidGet(iFTP, '', cFotoService_BaustelleFName, '', MySyncPath, true);
    SolidGet(iFTP, '', cE_FotoBenennung + '-*.csv', '', MySyncPath, true);
  except
    on E: Exception do
      Log(cERRORText + ' 1846:' + E.ClassName + ': ' + E.Message);
  end;

  // close
  try
    iFTP.DisConnect;
  except
    // Ignore ALL Exceptions at Disconnect, # 10054, ...
  end;

  // free;
  try
    iFTP.Free;
  except
    on E: Exception do
      Log(cERRORText + ' 1861:' + E.ClassName + ': ' + E.Message);
  end;

  try
    // baustelle.csv -> sync
    if FileExists(MySyncPath + cFotoService_BaustelleFName) then
    begin

      // prepare
      TJonDaExec.validateBaustelleCSV(MySyncPath + cFotoService_BaustelleFName);

      // compare + copy
      if not(FileCompare(
        { } MySyncPath + cFotoService_BaustelleFName,
        { } MyDataBasePath2 + cFotoService_BaustelleFName)) then
      begin
        FileVersionedCopy(
          { } MySyncPath + cFotoService_BaustelleFName,
          { } MyDataBasePath2 + cFotoService_BaustelleFName);
        Log(cINFOText + ' neue ' + cFotoService_BaustelleFName);
      end;

      // delete
      FileDelete(MySyncPath + cFotoService_BaustelleFName);
    end;
  except
    on E: Exception do
      Log(cERRORText + ' 1889:' + E.ClassName + ': ' + E.Message);
  end;

  try
    // FotoBenennung-*.csv ->  cDBPath + Baustelle + "FotoBenennung-"+ Baustelle + ".csv"
    //
    sDir := TStringList.Create;
    dir(MySyncPath + cE_FotoBenennung + '-*.csv', sDir, false);
    for n := 0 to pred(sDir.count) do
    begin

      // Lese den Pfad aus dem Dateinamen
      BaustellePath := ExtractSegmentBetween(sDir[n], cE_FotoBenennung + '-', '.csv');

      // JonDa - Limitation!
      BaustellePath := copy(noblank(BaustellePath), 1, 6) + '\';

      CheckCreateDir(MyDataBasePath + BaustellePath);

      if not(FileCompare(
        { } MySyncPath + sDir[n],
        { } MyDataBasePath + BaustellePath + cE_FotoBenennung + '.csv')) then
      begin
        FileVersionedCopy(
          { } MySyncPath + sDir[n],
          { } MyDataBasePath + BaustellePath + cE_FotoBenennung + '.csv');
        Log(cINFOText + ' in ' + BaustellePath + ' neue ' + cE_FotoBenennung + '.csv');
      end;

      FileDelete(MySyncPath + sDir[n]);
    end;
    sDir.Free;
  except
    on E: Exception do
      Log(cERRORText + ' 1923:' + E.ClassName + ': ' + E.Message);
  end;

end;

end.
