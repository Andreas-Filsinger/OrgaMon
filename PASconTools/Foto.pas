unit Foto;

interface

// Liefert den Aufnahme-Moment des Fotos
function FotoAufnahmeMoment(FName: string): TDateTime;
procedure FotoTouch(FName: string);

// Verkleinert die Größe der Foto-Datei auf kByte [kByte] mit der Abweichung [Prozent]
// Liefert die eingesparte Anzahl von Bytes
function FotoCompress(FName: string; DestFName: string; kByte: integer; Abweichung: integer): int64;

implementation

uses
  Windows, Messages, SysUtils,
  Classes,

  anfix32,
  CCR.Exif.BaseUtils,
  CCR.Exif,
{$IFNDEF FPC}
  JclMiscel,
{$ENDIF}
  globals;

function FotoAufnahmeMoment(FName: string): TDateTime;
var
  iEXIF: TExifData;
  _FName: string;
begin
  // a) über EXiF
  iEXIF := TExifData.Create;
  result := TDateTimeTagValue.CreateMissingOrInvalid;
  try
    iEXIF.LoadFromGraphic(FName);
    result := iEXIF.DateTimeOriginal;
  except

  end;
  iEXIF.Free;

  // b) über den Dateinamen 20160414_084106
  if (result = TDateTimeTagValue.CreateMissingOrInvalid) then
  begin

    _FName := StrFilter(ExtractFileName(FName), cZiffern);

    if (length(_FName) = 14) then
      // JJJJMMDDhhmmss
      // 12345678901234

      result := mkdatetime(
        { } date2long(
        { DD } copy(_FName, 7, 2) + '.' +
        { MM } copy(_FName, 5, 2) + '.' +
        { JJJJ } copy(_FName, 1, 4)),
        { } StrToSeconds(
        { hh } copy(_FName, 9, 2) + ':' +
        { mm } copy(_FName, 11, 2) + ':' +
        { ss } copy(_FName, 13, 2)));

  end;
end;

procedure FotoTouch(FName: string);
var
  dt: TDateTime;
begin
  dt := FotoAufnahmeMoment(FName);
  if (dt <> TDateTimeTagValue.CreateMissingOrInvalid) then
    FileTouch(FName, dt);
end;

const
  cGimpTempFName: string = '';
  cGimpTempPath: string = '';

function FotoCompress(FName: string; DestFName: string; kByte: integer; Abweichung: integer): int64;
const
  cGimpExecutePath: string = '';
  cGimpScriptPath: string = '';
  cGimpScriptExtension = '.scm';
  cGimpScriptNAME = 'RESIZE';

  procedure Gimp_Save(Script: TStringList; FunktionsName: string);
  var
    SkriptFileName: string;
  begin
    SkriptFileName :=
    { } cGimpScriptPath +
    { } FunktionsName +
    { } cGimpScriptExtension;
    SaveStringsToFileUTF8(Script, SkriptFileName);

    // Gimp Bug, can not cope with BOM
    FileRemoveBOM(SkriptFileName);
  end;

  function Gimp_FileName(s: string): string;
  begin
    result := s;
    ersetze('\', '/', result);
  end;

var
  IstFSize: int64;
  MaxFSize: int64;
  MinFSize: int64;
  TryFSize, _TryFSize: int64;
  a1, a2, a3: double;
  p_min, p_max, p_check: double;
  execStr: string;
  sCallScript: TStringList;
  sKnowHow: TStringList;
  DateTimeOriginal: TDateTime;

  procedure TryPercent(Prozent: double);
  var
    _percent: string;
  begin
    _percent := FloatToStrISO(Prozent / 100.0, 3);
    with sCallScript do
    begin
      if (count > 0) then
        Clear;

      add(';');
      add('; Dieses Skript wurde automatisch generiert durch FotoCompress');
      add(';');
      add('');
      add('(define (' + cGimpScriptNAME + ')');
      add(' (let* ((das-bild (car (gimp-file-load RUN-NONINTERACTIVE "' + Gimp_FileName(FName) + '" "' +
        Gimp_FileName(FName) + '")))');
      add('       (ergebnis-layer (car (gimp-image-get-active-layer das-bild))))');
      add(' (file-jpeg-save');
      add('     RUN-NONINTERACTIVE');
      add('     das-bild');
      add('     ergebnis-layer');
      add('     "' + Gimp_FileName(cGimpTempFName) + '"');
      add('     "' + Gimp_FileName(cGimpTempFName) + '"');
      add('     ' + _percent + ' ; JPEG compression level');
      add('     0 ; smoothing');
      add('     1 ; optimize');
      add('     0 ; progressive');
      add('     "" ; comment');
      add('     0 ; subsampling');
      add('     1 ; baseline');
      add('     0 ; restart');
      add('     0 ; dct');
      add('  )');
      add(' )');
      add(' (gimp-quit TRUE)');
      add(')');
    end;

    Gimp_Save(sCallScript, cGimpScriptNAME);

    // Gimp anhauen!
    execStr :=
    { } cGimpExecutePath +
    { } 'gimp-console-2.6.exe' +
    { } ' ' +
    { } '--verbose ' +
    { } '--batch="(' + cGimpScriptNAME + ')"';
{$IFDEF FPC}
{$ELSE}
    JclMiscel.WinExec32AndWait(execStr, SW_SHOWNORMAL);
{$ENDIF}
    if debugmode then
      AppendStringsToFile(execStr, DiagnosePath + 'exec.log.txt');

    TryFSize := FSize(cGimpTempFName);

    // Knowhow Datenbank erweitern
    sKnowHow.add(InttoStr(IstFSize) + ';' + _percent + ';' + InttoStr(TryFSize));
  end;

begin
  IstFSize := FSize(FName);

  // Unscharfe aber schnelle Beurteilung
  if (IstFSize <= kByte * 1024) then
  begin
    if (FName <> DestFName) then
      FileMove(FName, DestFName);
    result := 0;
    exit;
  end;

  a1 := kByte * 1024.0;
  a2 := Abweichung / 100.0;
  a3 := a1 * a2;

  MaxFSize := round(a1 + a3);
  MinFSize := round(a1 - a3);

  // Gerade noch im Limit?
  if (IstFSize <= MaxFSize) then
  begin
    if (FName <> DestFName) then
      FileMove(FName, DestFName);
    result := 0;
    exit;
  end;

  if (cGimpTempFName = '') then
  begin
    cGimpTempPath := PersonalDataDir + 'GIMP' + '\';
    CheckCreateDir(cGimpTempPath);
    cGimpTempFName := cGimpTempPath + 'try-image.jpg';
  end;

  DateTimeOriginal := FotoAufnahmeMoment(FName);
  sKnowHow := TStringList.Create;

  cGimpExecutePath := ProgramFilesDir + 'GIMP-2.0\bin\';
  cGimpScriptPath := ProgramFilesDir + 'GIMP-2.0\share\gimp\2.0\scripts\';

  sCallScript := TStringList.Create;

  p_min := 0.0;
  p_max := 100.0;
  _TryFSize := IstFSize;

  repeat

    // Variationsgrenze ist ev. zu klein -> aufgeben
    if (abs(p_max - p_min) < 0.005) then
      break;

    p_check := p_min + ((p_max - p_min) / 2.0);
    TryPercent(p_check);

    // Keine Änderung zum letzten Mal -> aufgeben
    if (TryFSize = _TryFSize) then
      break;

    _TryFSize := TryFSize;

    // Zu groß -> Qualität vermindern -> p_check verkleinern
    if (TryFSize > MaxFSize) then
    begin
      p_max := p_check;
      continue;
    end;

    // Zu klein -> Qualität erhöhen -> p_check vergrößern
    if (TryFSize < MinFSize) then
    begin
      p_min := p_check;
      continue;
    end;

    break;

  until false;

  sCallScript.Free;

  // die Zieldatei zur Verfügung stellen
  FileMove(cGimpTempFName, DestFName);

  // In der Zieldatei den korrekten Zeitstempel setzen
  FileTouch(DestFName, DateTimeOriginal);

  // Knowhow für spätere Optimierungen abspeichern
  AppendStringsToFile(sKnowHow, cGimpTempPath + cGimpScriptNAME + '.csv');
  sKnowHow.Free;

  // Rückgabe: Ersparnis
  result := IstFSize - TryFSize;

end;

end.
