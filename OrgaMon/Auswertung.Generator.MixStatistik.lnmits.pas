{
  |††††††___                  __  __
  |†††††/ _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |††††| | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |††††| |_| | | | (_| | (_| | |  | | (_) | | | |
  |†††††\___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |†††††††††††††††|___/
  |
  |    Copyright (C) 2011  Ronny Schupeta
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
unit Auswertung.Generator.MixStatistik.lnmits;

// Wichtig!!!
// Es gibt es ein Problem mit Umlauten in TFlexCelImport.CellFormula.
// Umlaute werden in Formeln normalerweise nicht akzeptiert.
//
// Umgehung des Problems:
// In der Datei UXlsEncodeFormula die Methode
// TParseString.IsAlpha(const c: UTF16Char): boolean;
// suchen und mit folgenden Code ersetzen:
//
// function TParseString.IsAlpha(const c: UTF16Char): boolean;
// begin
// Result:=(ord(c)<255) and (AnsiChar(c) in ['A'..'Z', 'ƒ', '‹', '÷', '_', '\', 'a'..'z', '‰', '¸', 'ˆ', 'ﬂ'])
// end;
//
// Jetzt werden die Zeichen ƒ÷‹‰ˆ¸ﬂ zus‰tzlich akzeptiert.

interface

uses
  Windows, SysUtils, Classes,
  VCL.FlexCel.Core, FlexCel.xlsAdapter,
  txlib;

type
  TLNMITSCities = class;

  TLNMITS = class
  private
    FFlexCelImport: TXLSFile;
    FCities: TLNMITSCities;

    FCityOverviewStart: Integer;
    FCitySheetStart: Integer;

    function NextCityLineToInsert: Integer;
    procedure RecreateFlexCel;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    procedure Load(const Filename: AnsiString);
    procedure Save(const Filename: AnsiString);

    function OverviewIndexOf(const City: AnsiString): Integer;
    function SheetIndexOf(const City: AnsiString): Integer;

    property Cities: TLNMITSCities read FCities;

    // Zeile auf dem Deckblatt, ab der die St‰dte aufgelistet sind (f‰ngt ab 1 an)
    property CityOverviewStart: Integer read FCityOverviewStart write FCityOverviewStart;
    // Index des Sheets, ab der die St‰dte aufgelistet sind  (f‰ngt ab 1 an)
    property CitySheetStart: Integer read FCitySheetStart write FCitySheetStart;
  end;

  TLNMITSCity = class;

  TLNMITSCities = class
  private
    FOwner: TLNMITS;
    FCities: TTXStringList;

    procedure InternalClear;
    function InternalAdd(const City: AnsiString; CanModifyExcel: Boolean): TLNMITSCity;

    procedure ModifyOverviewLine(const City: AnsiString; Line: Integer);

    function GetItem(Index: Integer): TLNMITSCity;
    function GetCount: Integer;

    function GetCountOlapFiles: Integer;
  public
    constructor Create(AOwner: TLNMITS);
    destructor Destroy; override;

    class function PrepareCityNameForSheet(const City: AnsiString; RemoveSpaces: Boolean)
      : AnsiString;
    class function PrepareCityNameForSearch(const City: AnsiString): AnsiString;
    class procedure ValidateCityName(const City: AnsiString);

    procedure Clear;

    function IndexOf(const City: AnsiString): Integer;

    function Add(const City: AnsiString): TLNMITSCity;
    procedure Delete(Index: Integer);

    property Items[Index: Integer]: TLNMITSCity read GetItem;
    property Count: Integer read GetCount;

    property CountOlapFiles: Integer read GetCountOlapFiles;

    property Owner: TLNMITS read FOwner;
  end;

  TLNMITSCity = class
  private
    FOwner: TLNMITSCities;
    FCity: AnsiString;
    FHaveToGenerateOlapFile: Boolean;

    procedure SetCity(const City: AnsiString);
    function GetIndex: Integer;
  public
    constructor Create(AOwner: TLNMITSCities);

    procedure GenerateOlapFile(const Path: AnsiString);

    procedure Delete;

    property City: AnsiString read FCity write SetCity;

    property HaveToGenerateOlapFile: Boolean read FHaveToGenerateOlapFile
      write FHaveToGenerateOlapFile;

    property Index: Integer read GetIndex;
    property Owner: TLNMITSCities read FOwner;
  end;

implementation

const
  CellLetters: AnsiString = 'UJKLMOPQRSTWXYNVI';

constructor TLNMITS.Create;
begin
  FFlexCelImport := nil;

  RecreateFlexCel;

  FCities := TLNMITSCities.Create(Self);

  FCityOverviewStart := 10;
  FCitySheetStart := 4;
end;

destructor TLNMITS.Destroy;
begin
  FFlexCelImport.Free;

  FCities.Free;

  inherited;
end;

procedure TLNMITS.Clear;
begin
  FCities.InternalClear;
  RecreateFlexCel;
end;

procedure TLNMITS.Load(const Filename: AnsiString);
var
  I, C: Integer;
begin
  Clear;

  FFlexCelImport.Open(Filename);

  C := FFlexCelImport.SheetCount;
  for I := FCitySheetStart to C do
  begin
    FFlexCelImport.ActiveSheet := I;

    if TXLowerCase(Trim(FFlexCelImport.SheetName)) <> 'alle' then
      FCities.InternalAdd(FFlexCelImport.SheetName, False)
    else
      Break;
  end;

  FFlexCelImport.ActiveSheet := 1;
end;

procedure TLNMITS.Save(const Filename: AnsiString);
begin
  Windows.DeleteFileA(PAnsiChar(Filename));
  FFlexCelImport.Save(Filename);
end;

function TLNMITS.OverviewIndexOf(const City: AnsiString): Integer;
var
  S: AnsiString;
  I, C: Integer;
begin
  Result := -1;

  S := TLNMITSCities.PrepareCityNameForSearch(City);

  C := NextCityLineToInsert - 1;
  for I := FCityOverviewStart to C do
    if TLNMITSCities.PrepareCityNameForSearch(FFlexCelImport.getCellValue(I, 1).ToStringInvariant) = S
    then
    begin
      Result := I;
      Break;
    end;
end;

function TLNMITS.SheetIndexOf(const City: AnsiString): Integer;
var
  S: AnsiString;
  I, C: Integer;
begin
  Result := -1;

  S := TLNMITSCities.PrepareCityNameForSearch(City);

  try
    C := FFlexCelImport.SheetCount - 1;
    for I := FCitySheetStart to C do
    begin
      FFlexCelImport.ActiveSheet := I;

      if TLNMITSCities.PrepareCityNameForSearch(FFlexCelImport.SheetName) = S then
      begin
        Result := I;
        Break;
      end;
    end;
  finally
    try
      if FFlexCelImport.ActiveSheet <> 1 then
        FFlexCelImport.ActiveSheet := 1;
    except
    end;
  end;
end;

function TLNMITS.NextCityLineToInsert: Integer;
var
  S: String;
  I, Max: Integer;
begin
  Result := -1;

  try
    if FFlexCelImport.ActiveSheet <> 1 then
      FFlexCelImport.ActiveSheet := 1;
  except
  end;

  Max := 255;
  I := 1;
  while I < Max do
  begin
    S := TXLowerCase(Trim(FFlexCelImport.getCellValue(I, 1).ToStringInvariant));
    if S = 'summe' then
    begin
      Result := I;
      Break;
    end
    else if S <> '' then
      Max := I + 255;

    Inc(I);
  end;

  if Result = -1 then
    raise Exception.Create
      ('Konnte auf dem Deckblatt die Zeile mit dem Inhalt "Summe" nicht finden.');
end;

procedure TLNMITS.RecreateFlexCel;
begin
  if Assigned(FFlexCelImport) then
    FFlexCelImport.Free;

  FFlexCelImport := TXLSFile.Create(true);
end;

constructor TLNMITSCities.Create(AOwner: TLNMITS);
begin
  FOwner := AOwner;

  FCities := TTXStringList.Create;
  with FCities do
  begin
    SearchMethod := smHash;
    HashSize := 1024;
    Duplicates := true;
    CaseSensitive := true;
    Trimmed := False;
    Umlaut := False;
  end;
end;

destructor TLNMITSCities.Destroy;
begin
  InternalClear;

  FCities.Free;

  inherited;
end;

class function TLNMITSCities.PrepareCityNameForSheet(const City: AnsiString; RemoveSpaces: Boolean)
  : AnsiString;
var
  S: AnsiString;
begin
  // S := 'abcdefghijklmnopqrstuvwxyz‰¸ˆÈ˙ÌÛ·˝Ë˘ÏÚ‡Í˚ÓÙ‚ABCDEFGHIJKLMNOPQRSTUVWXYZƒ‹÷…⁄Õ”¡›»ŸÃ“¿ €Œ‘¬ﬂ0123456789';
  S := 'abcdefghijklmnopqrstuvwxyz‰¸ˆABCDEFGHIJKLMNOPQRSTUVWXYZƒ‹÷ﬂ0123456789';
  if not RemoveSpaces then
    S := S + ' ';

  Result := LimitSpaces(LimitString(City, S));
end;

class function TLNMITSCities.PrepareCityNameForSearch(const City: AnsiString): AnsiString;
begin
  Result := TXLowerCase(PrepareCityNameForSheet(City, true));
end;

class procedure TLNMITSCities.ValidateCityName(const City: AnsiString);
begin
  if PrepareCityNameForSheet(City, true) = '' then
    raise Exception.CreateFmt('Der Name der Stadt "%s" ist ung¸ltig.', [City]);
end;

procedure TLNMITSCities.Clear;
var
  I, C: Integer;
begin
  C := Count - 1;
  for I := C downto 0 do
    Delete(I);
end;

function TLNMITSCities.IndexOf(const City: AnsiString): Integer;
begin
  Result := FCities.Find(PrepareCityNameForSearch(City));
end;

function TLNMITSCities.Add(const City: AnsiString): TLNMITSCity;
begin
  Result := InternalAdd(City, true);
  Result.FHaveToGenerateOlapFile := true;
end;

procedure TLNMITSCities.Delete(Index: Integer);
var
  Overview: Integer;
  Sheet: Integer;
  City: AnsiString;
begin
  CheckIndex(Index, Count);

  City := Items[Index].City;

  Overview := FOwner.OverviewIndexOf(City);
  Sheet := FOwner.SheetIndexOf(City);

  if Overview < 0 then
    raise Exception.CreateFmt
      ('Interner Fehler (Stadt "%s" konnte auf dem Deckblatt nicht gefunden werden)', [City]);
  if Sheet < 0 then
    raise Exception.CreateFmt
      ('Interner Fehler (Stadt "%s" konnte in den Sheets nicht gefunden werden)', [City]);

  FOwner.FFlexCelImport.DeleteRange(TXLSCellRange.Create(Overview, 1, Overview, 1024),
    TFlxInsertMode.ShiftRowDown);

  FOwner.FFlexCelImport.ActiveSheet := Sheet;
  try
    FOwner.FFlexCelImport.DeleteSheet(1);
  finally
    FOwner.FFlexCelImport.ActiveSheet := 1;
  end;

  Items[Index].Free;
  FCities.Delete(Index);
end;

procedure TLNMITSCities.InternalClear;
var
  I, C: Integer;
begin
  C := Count - 1;
  for I := 0 to C do
    Items[I].Free;

  FCities.Clear;
end;

function TLNMITSCities.InternalAdd(const City: AnsiString; CanModifyExcel: Boolean): TLNMITSCity;
var
  NewLine: Integer;

  procedure ModifySumLine;
  var
    SumLine: Integer;
    I, C: Integer;
  begin
    SumLine := NewLine + 1;

    C := Length(CellLetters);
    for I := 1 to C do
    begin
      FOwner.FFlexCelImport.setCellValue(
        { } SumLine,
        { } 2 + I,
        { } StringReplace(
        { } FOwner.FFlexCelImport.getCellValue(SumLine, 2 + I).ToStringInvariant,
        { } IntToStr(NewLine - 1) + ')',
        { } IntToStr(SumLine - 1) + ')',
        { } [rfReplaceAll]));
    end;
  end;

begin
  ValidateCityName(City);

  if IndexOf(City) < 0 then
  begin
    if CanModifyExcel then
    begin
      NewLine := FOwner.NextCityLineToInsert;

      // Imp pend FlexCel: Row to Range
      // FOwner.FFlexCelImport.InsertAndCopyRange(FOwner.FCityOverviewStart, FOwner.FCityOverviewStart, NewLine, 1);
      FOwner.FFlexCelImport.InsertAndCopyRange(
        { } TXLSCellRange.Create(FOwner.FCityOverviewStart, 1, FOwner.FCityOverviewStart, 1024),
        { } NewLine,
        { } 1,
        { } 1,
        { } TFlxInsertMode.ShiftRowDown);

      FOwner.FFlexCelImport.InsertAndCopySheets(FOwner.FCitySheetStart,
        FOwner.FFlexCelImport.SheetCount, 1);
      FOwner.FFlexCelImport.ActiveSheet := FOwner.FFlexCelImport.SheetCount - 1;
      FOwner.FFlexCelImport.SheetName := PrepareCityNameForSheet(City, true);
      FOwner.FFlexCelImport.ActiveSheet := 1;

      ModifyOverviewLine(City, NewLine);
      ModifySumLine;
    end;

    Result := TLNMITSCity.Create(Self);
    Result.FCity := PrepareCityNameForSheet(City, False);

    FCities.AddObject(PrepareCityNameForSearch(City), Result);
  end
  else
    raise Exception.CreateFmt('Die Stadt "%s" ist bereits vorhanden.', [City]);
end;

procedure TLNMITSCities.ModifyOverviewLine(const City: AnsiString; Line: Integer);
var
  Col: AnsiChar;
  I, C: Integer;
begin
  FOwner.FFlexCelImport.setCellValue(Line, 1, City);

  C := Length(CellLetters);
  for I := 1 to C do
  begin
    Col := CellLetters[I];
    FOwner.FFlexCelImport.setCellFromString(Line, 2 + I, Format('=SUM(%s!$%s2:$%s$65536)',
      [PrepareCityNameForSheet(City, true), Col, Col]));
  end;
end;

function TLNMITSCities.GetItem(Index: Integer): TLNMITSCity;
begin
  CheckIndex(Index, Count);

  Result := TLNMITSCity(FCities.Objects[Index]);
end;

function TLNMITSCities.GetCount: Integer;
begin
  Result := FCities.Count;
end;

function TLNMITSCities.GetCountOlapFiles: Integer;
var
  I, C: Integer;
begin
  Result := 0;

  C := Count - 1;
  for I := 0 to C do
    if Items[I].HaveToGenerateOlapFile then
      Inc(Result);
end;

constructor TLNMITSCity.Create(AOwner: TLNMITSCities);
begin
  FOwner := AOwner;
  FHaveToGenerateOlapFile := False;
end;

procedure TLNMITSCity.GenerateOlapFile(const Path: AnsiString);
var
  Filename: AnsiString;
  StrList: TStringList;
begin
  Filename := WellFilename(Path + '\LN-MITS.' + TLNMITSCities.PrepareCityNameForSheet(City, true) +
    '.OLAP.txt');

  StrList := TStringList.Create;
  try
    StrList.Add('');
    StrList.Add('$Ortsteil=''' + City + '''');
    StrList.Add('');
    StrList.Add('include LN-Ortsteil-Include');
    StrList.Add('');

    StrList.SaveToFile(Filename);
  finally
    StrList.Free;
  end;
end;

procedure TLNMITSCity.Delete;
begin
  FOwner.Delete(Index);
end;

procedure TLNMITSCity.SetCity(const City: AnsiString);
var
  I: Integer;

  procedure ModifyOverview;
  var
    I: Integer;
  begin
    I := FOwner.FOwner.OverviewIndexOf(FCity);
    if I >= 0 then
      FOwner.ModifyOverviewLine(City, I)
    else
      raise Exception.CreateFmt
        ('Interner Fehler (Stadt "%s" konnte auf dem Deckblatt nicht gefunden werden)', [City]);
  end;

  procedure ModifySheet;
  var
    I: Integer;
  begin
    I := FOwner.FOwner.SheetIndexOf(FCity);
    if I >= 0 then
    begin
      try
        FOwner.FOwner.FFlexCelImport.ActiveSheet := I;
        FOwner.FOwner.FFlexCelImport.SheetName := TLNMITSCities.PrepareCityNameForSheet(City, true);
      finally
        FOwner.FOwner.FFlexCelImport.ActiveSheet := 1;
      end;
    end
    else
      raise Exception.CreateFmt
        ('Interner Fehler (Stadt "%s" konnte auf dem Deckblatt nicht gefunden werden)', [City]);
  end;

begin
  TLNMITSCities.ValidateCityName(City);

  I := FOwner.IndexOf(City);
  if I >= 0 then
    if I <> Index then
      raise Exception.CreateFmt('Die Stadt "%s" ist bereits vorhanden.', [City]);

  ModifySheet;
  ModifyOverview;

  FOwner.FCities.Strings[Index] := TLNMITSCities.PrepareCityNameForSearch(City);
  FCity := TLNMITSCities.PrepareCityNameForSheet(City, False);

  FHaveToGenerateOlapFile := true;
end;

function TLNMITSCity.GetIndex: Integer;
begin
  Result := FOwner.IndexOf(FCity);
end;

end.
