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
{$ifndef FPC}
jpeg, CCR.Exif,
{$endif}

  // Tools
  anfix32, WordIndex, binlager32,
  Foto, InfoZip, SolidFTP,
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
    tBAUSTELLE: tsTable;
    tABLAGE: tsTable;
    JonDaExec: TJonDaExec;
    LastLogWasTimeStamp: boolean; // Protect TimeStamp Flood
    ZaehlerNummerNeuXlsCsv_Vorhanden: boolean;

    // Ini-Sachen

    // bisher fix 'I:\KundenDaten\SEWA\JonDaServer\' jetzt Parameter "BackupPath"
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

    // Verzeichnisse
    function MyDataBasePath: string;

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

    // muss IMMER überladen werden
    procedure Log(s: string); virtual; abstract;

    // Implementierungen von JonDaExec - Prototypen
    function ZaehlerNummerNeu(AUFTRAG_R: integer; GeraeteNo: string): string;
    function ReglerNummerNeu(AUFTRAG_R: integer; GeraeteNo: string): string;
    procedure invalidate_NummerNeuCache;
  end;

implementation

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
begin
  if not(assigned(tBAUSTELLE)) then
  begin

    // Initialer Lauf

    JonDaExec := TJonDaExec.Create;
    JonDaExec.callback_ZaehlerNummerNeu := ZaehlerNummerNeu;
    JonDaExec.callback_ReglerNummerNeu := ReglerNummerNeu;

    // die aktuellen Daten aus dem FTP-Bereich jetzt abholen
    JonDaExec.doSync;

    tBAUSTELLE := tsTable.Create;
    tBAUSTELLE.insertfromFile(MyDataBasePath + cServiceFoto_BaustelleFName);
    if FileExists(MyDataBasePath + cServiceFoto_BaustelleManuellFName) then
    begin
      with tBAUSTELLE do
      begin
        insertfromFile(MyDataBasePath + cServiceFoto_BaustelleManuellFName);
        for r := RowCount downto 1 do
          if (length(readCell(r, cE_FTPUSER)) < 3) then
            del(r);
        SaveToFile(MyDataBasePath + 'baustelle-alle.csv');
      end;
    end;

    tABLAGE := tsTable.Create;
    tABLAGE.insertfromFile(MyDataBasePath + cFotoAblage);

    // Datei der Wartenden sicherstellen, Header anlegen
    if not(FileExists(MyDataBasePath + cFotoUmbenennungAusstehend)) then
      AppendStringsToFile(
        { } cHeader_UmbenennungUnvollstaendig,
        { } MyDataBasePath + cFotoUmbenennungAusstehend);

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
  sDirs: TStringList;
  n: integer;
  SubPath: string;
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
    pBackUpRootPath := ReadString(SectionName, 'BackUpPath', 'I:\KundenDaten\SEWA\');
    pWebPath := ReadString(SectionName, 'WebPath', 'W:\status\');
    pAppStatistikPath := ReadString(SectionName, 'StatistikPath', pWebPath);
    pAppTextPath := ReadString(SectionName, 'TextPath', 'W:\JonDaServer\Statistik\');
    pFTPPath := ReadString(SectionName, 'FTPPath', 'W:\orgamon-mob\');
    pUnverarbeitetPath := ReadString(SectionName, 'UnverarbeitetPath', 'W:\orgamon-mob\unverarbeitet');
    DiagnosePath := ReadString(SectionName, 'LogPath', DiagnosePath);
  end;
  MyIni.Free;

  // Einstellungen weitergeben
  SolidFTP.SolidFTP_LogDir := DiagnosePath;

  // Backup-Path bestimmen
  // Zielbestimmung Sicherungsunterverzeichnis
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

  //
  pBackUpRootPath := pBackUpRootPath + sDirs[pred(sDirs.count)] + '\';
  sDirs.Free;

  Log('Backup to ' + pBackUpRootPath);
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
      ;
    end;
  end;
end;

function TFotoExec.MyDataBasePath: string;
begin
  result := pAppServicePath + cDBPath;
end;

function TFotoExec.GEN_ID: integer;
var
  mIni: TIniFile;
begin
  mIni := TIniFile.Create(MyDataBasePath + 'Backup-Service.ini');
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
  ID: string;
  RID: integer;
  bOrgaMon, bOrgaMonOld: TBLager;
  mderecOrgaMon: TMDERec;
  FotoMussWarten: boolean;
  FotoPrefix: string;
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
  Image: TJPEGImage;
  sBaustelle: string;
  sZiel: string;

  BAUSTELLE_Index: integer;
  ZAEHLER_NUMMER_NEU: string;

  // alternativer Auftragspool
  fOrgaMonAuftrag: file of TMDERec;
  iEXIF: TExifData;
  AufnahmeMoment: TDateTime;

  // Foto - Umbenennung
  sFotoCall: TStringList;
  sFotoResult: TStringList;
  RenameError: boolean;

  // Parameter
  pAll: boolean;

  procedure unverarbeitet(m: integer);
  begin

    // Datei wegsperren, aber nicht löschen!
    FileMove(
      { } pFTPPath + sFiles[m],
      { } pUnverarbeitetPath + ID + '+' + sFiles[m]);

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

  // Generate Work-TAN
  if (sFiles.count > 0) then
  begin
    ID := inttostrN(GEN_ID, cAnzahlStellen_Transaktionszaehler);
    CheckCreateDir(pBackUpRootPath + cServiceFoto_FTPBackupSubPath);
  end;

  // make backup of all new Files
  for n := 0 to pred(sFiles.count) do
    if not(FileCopy(pFTPPath + sFiles[n], pBackUpRootPath + cServiceFoto_FTPBackupSubPath + ID + '-' + sFiles[n])) then
    begin
      Log(cERRORText + ' can not write to ' + pBackUpRootPath + cServiceFoto_FTPBackupSubPath);
      Log(cFotoService_AbortTag);
      exit;
    end;

  // reduce to valid jpg's
  for n := pred(sFiles.count) downto 0 do
  begin
    FullSuccess := false;
    FName := pFTPPath + sFiles[n];
    Image := TJPEGImage.Create;
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
      on e: Exception do
      begin
        Log(cERRORText + ' ' + sFiles[n] + ': ' + e.Message);
      end;
    end;
    Image.Free;
    iEXIF.Free;

    if not(FullSuccess) then
      unverarbeitet(n);
  end;

  if (sFiles.count > 0) then
  begin

    ensureGlobals;

    bOrgaMon := TBLager.Create;
    bOrgaMon.Init(MyDataBasePath + 'AUFTRAG+TS', mderecOrgaMon, sizeof(TMDERec));
    bOrgaMon.BeginTransaction(now);

    if FileExists(MyDataBasePath + '_AUFTRAG+TS' + cBL_FileExtension) then
    begin
      bOrgaMonOld := TBLager.Create;
      bOrgaMonOld.Init(MyDataBasePath + '_AUFTRAG+TS', mderecOrgaMon, sizeof(TMDERec));
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
      RID := StrToIntDef(nextp(sFiles[m], '-', 1), -1);
      FotoParameter := nextp(nextp(sFiles[m], '-', 2), '.', 0);
      sBaustelle := '';
      sZiel := '';

      // passenden Auftrag suchen
      while true do
      begin

        if (RID < 1) then
        begin
          Log(cERRORText + ' ' + sFiles[m] + ': RID konnte nicht ermittelt werden!');
          break;
        end;

        // Im OrgaMon Record-Store
        if bOrgaMon.exist(RID) then
        begin
          bOrgaMon.get;
          FoundAuftrag := true;
          break;
        end;

        Log('WARNUNG: ' + sFiles[m] + ': RID in ' + bOrgaMon.FileName + ' nicht vorhanden!');

        // In der Alternative suchen
        if (assigned(bOrgaMonOld)) then
        begin
          if bOrgaMonOld.exist(RID) then
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
          on e: Exception do
            Log(cERRORText + ' 614: ' + sFiles[m] + ':' + e.Message);
        end;

        for f := 1 to FileSize(fOrgaMonAuftrag) do
        begin

          read(fOrgaMonAuftrag, mderecOrgaMon);
          if (RID = mderecOrgaMon.RID) then
          begin
            FoundAuftrag := true;
            break;
          end;
        end;
        CloseFile(fOrgaMonAuftrag);
        if FoundAuftrag then
          break;
        Log(cERRORText + ' ' + sFiles[m] + ': RID ' + InttoStr(RID) + ' konnte nicht gefunden werden!');
        break;
      end;

      if FoundAuftrag then
      begin

        sBaustelle := Oem2utf8(mderecOrgaMon.Baustelle);
        while true do
        begin

          BAUSTELLE_Index := tBAUSTELLE.locate(0, sBaustelle);
          if (BAUSTELLE_Index > -1) then
          begin

            // Modus der Fotobenennung ermitteln
            FotoMussWarten := false;

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

            // Auszeichnen, wenn die Umbenennung vorläufig ist
            if not(UmbenennungAbgeschlossen) then
              AppendStringsToFile(
                { DATEINAME_ORIGINAL } sFiles[m] + ';' +
                { DATEINAME_AKTUELL } FotoAblage_PFAD + FotoDateiName + ';' +
                { RID } InttoStr(RID) + ';' +
                { GERAETENO } FotoGeraeteNo + ';' +
                { BAUSTELLE } ';' +
                { MOMENT } DatumLog,
                { Dateiname } MyDataBasePath + cFotoUmbenennungAusstehend);

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
          Log(cERRORText + ' ' + sFiles[n] + ': Nicht löschbar');
          Log(cFotoService_AbortTag);
          exit;
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
  MomentTimeout: TANFiXDate;
  CSV: tsTable;
  r, i, k, ro, c: integer;

  ZAEHLER_NUMMER_NEU: string;
  REGLER_NUMMER_NEU: string;
  NEU: string;

  ORIGINAL_DATEI: string;
  PARAMETER: string;
  FNameAlt, FNameNeu: string;
  RID: integer;
  sBaustelle: string;
  BAUSTELLE_Index: integer;

  // Baustellen-Ermittlung
  bOrgaMon: TBLager;
  mderecOrgaMon: TMDERec;
  FotoBenennungsModus: integer;

  // Foto Benennungs Funktion
  sFotoCall, rFoto: TStringList;

  // senden einfärben
  tSENDEN: tsTable;

begin

  // Init
  ensureGlobals;
  invalidate_NummerNeuCache;

  CSV := nil;
  WARTEND := tsTable.Create;
  with WARTEND do
  begin

    // load+sort
    insertfromFile(MyDataBasePath + cFotoUmbenennungAusstehend);
    Stat_Anfangsbestand := RowCount;
    Stat_NachtragBaustelle := 0;
    SortBy('GERAETENO;MOMENT;DATEINAME_AKTUELL');
    if Changed then
      Log(cINFOText+' Frisch sortiert');

    // sicherstellen von Spalten
    addCol('BAUSTELLE');
    addCol('MOMENT');

    // all zu alte Einträge löschen
    MomentTimeout := DatePlus(DateGet, -10);
    i := 0;
    c := colof('MOMENT');
    for r := RowCount downto 1 do
      if (StrToIntDef(readCell(r, c), 0) < MomentTimeout) then
      begin
        del(r);
        inc(i);
      end;
    if (i > 0) then
      Log(cWARNINGText +' 964: ' + 'gebe ' + InttoStr(i) + ' Dateieinträge frei, da sie älter als 10 Tage sind');

  end;

  bOrgaMon := TBLager.Create;
  bOrgaMon.Init(MyDataBasePath + 'AUFTRAG+TS', mderecOrgaMon, sizeof(TMDERec));
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

    // nichts machen in diesem Fall
    if (NEU = '') then
      continue;

    // Umbenennung starten
    FNameAlt := WARTEND.readCell(r, 'DATEINAME_AKTUELL');

    if not(FileExists(FNameAlt)) then
    begin
      Log(cWARNINGText + ' 1091: ' + 'gebe Dateieintrag "' + FNameAlt + '" frei, da verschwunden, oder bereits umbenannt');
      WARTEND.del(r);
      continue;
    end;

    FNameNeu := FNameAlt;
    k := pos('-Neu.jpg', FNameNeu);
    if (k = 0) then
    begin
      Log(cERRORText + ' ' + 'keine Ahnung wie man "' + FNameNeu + '" umbenennen soll');
      continue;
    end;

    FNameNeu :=
    { } copy(FNameNeu, 1, k) +
    { } TJonDaExec.FormatZaehlerNummerNeu(NEU) +
    { } '.jpg';

    // Es ist gewünscht die (TMP..)- Sachen wieder wegzumachen
    FNameNeu :=
     JonDaExec.clearTempTag(FNameNeu);

    // Laufwerksbuchstaben
    if (CharCount(':', FNameNeu) <> 1) then
    begin
      Log(cERRORText + ' Umbenennung zu "' + FNameNeu + '" ist ungültig. Laufwerksangabe mit ":" fehlt');
      continue;
    end;

    // Pfad ging irgendwie verloren
    if (CharCount('\', FNameNeu) < 2) then
    begin
      Log(cERRORText + ' Umbenennung zu "' + FNameNeu + '" ist ungültig. Zwei Pfadangaben "\" fehlen');
      continue;
    end;

    if (FNameNeu = FNameAlt) then
    begin
      // ohne Umbenennung (also es stimmt bereits!) einfach nur den Eintrag löschen!
      WARTEND.del(r);
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
      end;
    end;
  end;

  bOrgaMon.EndTransaction;
  bOrgaMon.Free;

  if WARTEND.Changed then
  begin

    // recreate senden.html
    tSENDEN := tsTable.Create;
    with tSENDEN do
    begin
      insertfromFile(pAppServicePath + cDBPath + 'SENDEN.csv');
      i := addCol('PAPERCOLOR');
      k := WARTEND.colof('GERAETENO');
      c := colof('ID');
      for r := 1 to RowCount do
        if (WARTEND.locate(k, readCell(r, c)) <> -1) then
          writeCell(r, i, '#FF9900');
      SaveToHTML(pAppStatistikPath + 'senden.html');
    end;
    tSENDEN.Free;

    // save WARTEND / save as html
    WARTEND.SaveToHTML(pAppStatistikPath + '-neu.html');
    WARTEND.SaveToFile(MyDataBasePath + cFotoUmbenennungAusstehend);

    // LOG
    if (Stat_Anfangsbestand - WARTEND.RowCount > 0) then
      Log(cINFOText + ' ' +
        { } InttoStr(Stat_Anfangsbestand - WARTEND.RowCount) +
        { } ' "-Neu" Umbenennung(en) wurde(n) durchgeführt, ' +
        { } InttoStr(WARTEND.RowCount) +
        { } ' verbleiben');

    if (Stat_NachtragBaustelle > 0) then
      Log(cINFOText + ' ' +
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

  procedure Log(Source, Dest: string);
  begin
    AppendStringsToFile(sTimeStamp + ';' + Source + ';' + Dest, AblageLogFname);
  end;

const
  cFileTimeOutDays = 50 + 10;
  cPicTimeOutDays = 0;
  // 0 = gestern ist schon zu alt
var
  sDirs: TStringList;
  sZips: TStringList;
  sPics: TStringList;
  sFotos: TStringList;
  n, m: integer;
  ZIP_OlderThan: TANFiXDate;
  PIC_OlderThan: TANFiXDate;

  BackupPath: string;
  MovedToDay: int64;
  tabelleBAUSTELLE: tsTable;
  r: integer;

  FTP_Benutzer: string;
  mIni: TIniFile;
  Col_FTP_Benutzer: integer;

  // Parameter
  FotosSequence: integer;
  FotosAbzug: boolean;

  //
  WARTEND: tsTable;
  BasisDatum: TANFiXDate;

  // Parameter
  pDatum: string;
  pEinzeln: string;

  //
  Ablage_NAME: string;
  Ablage_PFAD: string;

  procedure serviceJPG;
  const
    cMaxZIP_Size = 100 * 1024 * 1024;
  var
    m: integer;
    Pending: boolean;
    FotoFSize: int64;
  begin
    Pending := false;
    sPics.Clear;
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
        if (WARTEND.locate('DATEINAME_AKTUELL', Ablage_PFAD + sPics[m]) <> -1) then
          sPics.Delete(m);
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
      r := tabelleBAUSTELLE.locate(Col_FTP_Benutzer, FTP_Benutzer);
      if (r = -1) then
      begin
        // 2. Suchversuch mit prefixed "u"
        if CharInSet(FTP_Benutzer[1], ['0' .. '9']) then
        begin
          FTP_Benutzer := 'u' + FTP_Benutzer;
          r := tabelleBAUSTELLE.locate(Col_FTP_Benutzer, FTP_Benutzer);
        end;
      end;

      // (immer noch) nicht gefunden?
      if (r = -1) then
      begin
        self.Log(cERRORText + ' FTP-Benutzer "' + FTP_Benutzer + '" unbekannt');
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
          dir(Ablage_PFAD + 'Fotos-????.zip', sFotos, false);
          if sFotos.count > 0 then
          begin
            sFotos.sort;
            FotosSequence := StrToIntDef(ExtractSegmentBetween(sFotos[pred(sFotos.count)], 'Fotos-', '.zip'), -1);
          end;
        end;

        if FotosSequence < 0 then
          FotosSequence := 0;

        inc(FotosSequence);
      end;
      mIni.Free;

      // Archivieren in Fotos-nnnn.zip
      Log(Ablage_PFAD + 'Fotos-' + inttostrN(FotosSequence, cAnzahlStellen_FotosTagwerk) + '.zip', '.');
      if (zip(
        { } sPics,
        { } Ablage_PFAD +
        { } 'Fotos-' + inttostrN(FotosSequence, cAnzahlStellen_FotosTagwerk) + '.zip',
        { } infozip_RootPath + '=' + Ablage_PFAD + ';' +
        { } infozip_Password + '=' +
        { } deCrypt_Hex(
        { } tabelleBAUSTELLE.readCell(r, cE_ZIPPASSWORD)) + ';' +
        { } infozip_Level + '=' + '0') <> sPics.count) then
      begin
        // Problem anzeigen
        self.Log(cERRORText + ' ' + HugeSingleLine(zMessages, '|'));
        Pending := false;
        break;
      end;

      if FotosAbzug then
      begin
        // Archivieren auch in Abzug-nnnn.zip

        for m := 0 to pred(sPics.count) do
          FotoCompress(Ablage_PFAD + sPics[m], Ablage_PFAD + sPics[m], 94, 6);

        Log(Ablage_PFAD + 'Abzug-' + inttostrN(FotosSequence, cAnzahlStellen_FotosTagwerk) + '.zip', '.');
        if (zip(
          { } sPics,
          { } Ablage_PFAD +
          { } 'Abzug-' + inttostrN(FotosSequence, cAnzahlStellen_FotosTagwerk) + '.zip',
          { } infozip_RootPath + '=' + Ablage_PFAD + ';' +
          { } infozip_Password + '=' +
          { } deCrypt_Hex(
          { } tabelleBAUSTELLE.readCell(r, cE_ZIPPASSWORD)) + ';' +
          { } infozip_Level + '=' + '0') <> sPics.count) then
        begin
          // Problem anzeigen
          self.Log(cERRORText + ' ' + HugeSingleLine(zMessages, '|'));
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

    if Pending then
      serviceJPG;

  end;

  procedure serviceHTML;
  var
    m: integer;
  begin
    sPics.Clear;
    repeat

      // Jpegs
      dir(Ablage_PFAD + '*.zip.html', sPics, false);
      if (sPics.count = 0) then
        break;

      // reduziere um "zu neue" Bilder
      for m := pred(sPics.count) downto 0 do
        if (FileDate(Ablage_PFAD + sPics[m]) >= PIC_OlderThan) then
          sPics.Delete(m);
      if (sPics.count = 0) then
        break;

      // reduziere um "wartende" Wechselbelege, bei denen das pdf fehlt!
      for m := pred(sPics.count) downto 0 do
        if not(FileExists(Ablage_PFAD + sPics[m] + '.pdf')) then
          sPics.Delete(m);
      if (sPics.count = 0) then
        break;

      // .pdf muss auch mit!
      // erweitere um die .pdf Dateien
      for m := 0 to pred(sPics.count) do
        sPics.add(sPics[m] + '.pdf');

      // Prüfen, ob dies eine ordentliche Baustelle ist
      FTP_Benutzer := Ablage_NAME;
      if CharInSet(FTP_Benutzer[1], ['0' .. '9']) then
        FTP_Benutzer := 'u' + FTP_Benutzer;
      r := tabelleBAUSTELLE.locate(Col_FTP_Benutzer, FTP_Benutzer);
      if (r = -1) then
        break;

      // Die Nummer des zu erzeugenden ZIP suchen
      mIni := TIniFile.Create(Ablage_PFAD + 'Wechselbelege-nnnn.ini');
      with mIni do
      begin
        FotosSequence := StrToInt(ReadString('System', 'Sequence', '-1'));
        if (FotosSequence < 0) then
        begin
          dir(Ablage_PFAD + 'Wechselbelege-????.zip', sFotos, false);
          if sFotos.count > 0 then
          begin
            sFotos.sort;
            FotosSequence := StrToIntDef(ExtractSegmentBetween(sFotos[pred(sFotos.count)], 'Wechselbelege-',
              '.zip'), -1);
          end;
        end;

        if FotosSequence < 0 then
          FotosSequence := 0;

        inc(FotosSequence);
      end;
      mIni.Free;

      // Archivieren
      Log(Ablage_PFAD + 'Wechselbelege-' + inttostrN(FotosSequence, cAnzahlStellen_FotosTagwerk) + '.zip', '.');
      if (zip(
        { } sPics,
        { } Ablage_PFAD +
        { } 'Wechselbelege-' + inttostrN(FotosSequence, cAnzahlStellen_FotosTagwerk) + '.zip',
        { } infozip_RootPath + '=' + Ablage_PFAD + ';' +
        { } infozip_Password + '=' +
        { } deCrypt_Hex(
        { } tabelleBAUSTELLE.readCell(r, cE_ZIPPASSWORD)) + ';' +
        { } infozip_Level + '=' + '0') <> sPics.count) then
      begin
        // Problem anzeigen
        self.Log(cERRORText + ' ' + HugeSingleLine(zMessages, '|'));
        break;
      end;

      // Laufnummer erhöhen
      mIni := TIniFile.Create(Ablage_PFAD + 'Wechselbelege-nnnn.ini');
      mIni.WriteString('System', 'Sequence', InttoStr(FotosSequence));
      mIni.Free;

      // nun die eben archivierten löschen!
      for m := 0 to pred(sPics.count) do
        FileDelete(Ablage_PFAD + sPics[m]);

    until true;
  end;

begin

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

  // Set "Lock"
  FileAlive(AblageLogFname);

  // prepare
  sZips := TStringList.Create;
  sPics := TStringList.Create;
  sFotos := TStringList.Create;

  // Infos über Baustellen
  tabelleBAUSTELLE := tsTable.Create;
  tabelleBAUSTELLE.insertfromFile(MyDataBasePath + cServiceFoto_BaustelleFName);
  Col_FTP_Benutzer := tabelleBAUSTELLE.colof(cE_FTPUSER);

  // Infos über noch nicht umbenannte Dateien
  WARTEND := tsTable.Create;
  WARTEND.insertfromFile(MyDataBasePath + cFotoUmbenennungAusstehend);

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

  // Zielbestimmung Sicherungsunterverzeichnis '..\#nnn\'
  sDirs := TStringList.Create;
  dir(pBackUpRootPath + '*.', sDirs, false);
  sDirs.sort;
  for n := pred(sDirs.count) downto 0 do
    if (pos('.', sDirs[n]) = 1) then
      sDirs.Delete(n);
  BackupPath := pBackUpRootPath + sDirs[pred(sDirs.count)] + '\';
  FreeAndNil(sDirs);

  for r := 1 to tABLAGE.RowCount do
  begin

    Ablage_NAME := tABLAGE.readCell(r, 'NAME');
    //
    if (pEinzeln <> '') then
      if (pEinzeln <> Ablage_NAME) then
        continue;

    //
    Ablage_PFAD := tABLAGE.readCell(r, 'PFAD');

    repeat

      // Zips ablegen
      dir(Ablage_PFAD + '*.zip', sZips, false);
      for m := 0 to pred(sZips.count) do
      begin
        if (FileDate(Ablage_PFAD + sZips[m]) < ZIP_OlderThan) then
        begin
          CheckCreateDir(BackupPath + Ablage_NAME);
          inc(MovedToDay, FSize(Ablage_PFAD + sZips[m]));
          Log(Ablage_PFAD + sZips[m], BackupPath);
          FileMove(Ablage_PFAD + sZips[m], BackupPath + Ablage_NAME + '\' + sZips[m]);
        end;
      end;

      // jpgs zippen
      serviceJPG;

      // htmls zippen
      serviceHTML;

    until true;

  end;

  // unprepare
  sZips.Free;
  sPics.Free;
  sFotos.Free;
  tabelleBAUSTELLE.Free;
  WARTEND.Free;
  Log('ENDE', '*');
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

end.
