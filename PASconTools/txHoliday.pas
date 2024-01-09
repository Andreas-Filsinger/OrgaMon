{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2009 - 2024  Ronny Schupeta
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
  |    https://wiki.orgamon.org/
  |
}
unit txHoliday;

// **************************************************
// * txHoliday Rev. 0.000                           *
// *                                                *
// *           Autor: Ronny Schupeta                *
// * Letzte Änderung: 29.10.2009                    *
// **************************************************

interface

uses
{$ifdef fpc}
 graphics,
{$else}
  System.UITypes,
{$endif}
  classes,
  anfix,
  dateutils,
  Sperre;

type
  TSperreWeekDayItem = class;

  TSperreWeekDaySpecifics = class
  private
    FOwner: TSperreWeekDayItem;

    FMorning: boolean;
    FAfternoon: boolean;
    FFromDateTime: Double;
    FToDateTime: Double;

    FColor: TColor;
  public
    constructor Create(AOwner: TSperreWeekDayItem);

    procedure Reset;

    function CheckIt(DateTime: TDateTime): boolean;

    property Morning: boolean read FMorning write FMorning;
    property Afternoon: boolean read FAfternoon write FAfternoon;

    // FromDateTime bzw. ToDateTime wird dann ignoriert, wenn diese = 0.0 sind
    property FromDateTime: Double read FFromDateTime write FFromDateTime;
    property ToDateTime: Double read FToDateTime write FToDateTime;

    property Color: TColor read FColor write FColor;

    property Owner: TSperreWeekDayItem read FOwner;
  end;

  TSperreWeekDayItem = class
  private
    FSpecifics: TList;
    FIndex: Integer;
    FEnabled: boolean;
    FColor: TColor;

    function GetSpecifics(Index: Integer): TSperreWeekDaySpecifics;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Reset;

    function Add: TSperreWeekDaySpecifics;

    function CheckIt(DateTime: TDateTime): boolean; overload;
    function CheckIt(DateTime: TDateTime; var AColor: TColor): boolean;
      overload;

    property Specifics[Index: Integer]: TSperreWeekDaySpecifics
      read GetSpecifics;
    property Count: Integer read GetCount;

    property Enabled: boolean read FEnabled write FEnabled;
    property Color: TColor read FColor write FColor;

    property Index: Integer read FIndex;
  end;

  TSperreWeekDays = class
  private
    FDays: array [1 .. 7] of TSperreWeekDayItem;

    FColor: TColor;

    function GetDay(Index: Integer): TSperreWeekDayItem;
  public
    constructor Create;

    procedure Reset;

    function CheckIt(DateTime: TDateTime): boolean; overload;
    function CheckIt(DateTime: TDateTime; var AColor: TColor): boolean;
      overload;

    class function IndexByText(S: String): Integer;

    // Index ist gültig im Bereich 1..7, wobei
    // 1 = Sonntag
    // 2 = Montag
    // ...
    // 7 = Samstag
    property Days[Index: Integer]: TSperreWeekDayItem read GetDay;

    property Color: TColor read FColor write FColor;
  end;

  TSperreOfficalHolidaysState = class;

  TSperreOfficalHolidayItem = class
  private
    FOwner: TSperreOfficalHolidaysState;

    FDay: Integer;
    FMonth: Integer;
    FYear: Integer;
    FCaption: String;

    function GetIndex: Integer;
  public
    constructor Create(AOwner: TSperreOfficalHolidaysState);

    function IsHoliday(DateTime: TDateTime): boolean;

    property Caption: String read FCaption write FCaption;

    property Day: Integer read FDay write FDay;
    property Month: Integer read FMonth write FMonth;
    property Year: Integer read FYear write FYear;

    property Owner: TSperreOfficalHolidaysState read FOwner;
    property Index: Integer read GetIndex;
  end;

  TSperreOfficalHolidaysZipArea = class
  private
    FFromZip: String;
    FToZip: String;
  public
    function IsInZipArea(Zip: String): boolean;

    class function PrepareZip(const Zip: String): String;

    property FromZip: String read FFromZip write FFromZip;
    property ToZip: String read FToZip write FToZip;
  end;

  TSperreOfficalHolidays = class;

  TSperreOfficalHolidaysState = class
  private
    FOwner: TSperreOfficalHolidays;
    FZipAreas: TList;
    FOfficalHoldays: TList;
    FName: String;
    FGlobal: boolean;

    function GetZipArea(Index: Integer): TSperreOfficalHolidaysZipArea;
    function GetZipAreaCount: Integer;
    function GetHoliday(Index: Integer): TSperreOfficalHolidayItem;
    function GetHolidayCount: Integer;

    function GetIndex: Integer;
  public
    constructor Create(AOwner: TSperreOfficalHolidays);
    destructor Destroy; override;

    procedure Clear;

    function AddZipArea(const FromZip, ToZip: String)
      : TSperreOfficalHolidaysZipArea;
    function AddHoliday(const Caption: String; Day, Month, Year: Integer)
      : TSperreOfficalHolidayItem;
    function AutoAddHolidays(Year: Integer): Integer;
    procedure DeleteHoliday(Index: Integer);

    function IsHoliday(DateTime: TDateTime): boolean; overload;
    function IsHoliday(const Zip: String; DateTime: TDateTime)
      : boolean; overload;

    function CountHolidays(Year: Integer): Integer;
    function YearExists(Year: Integer): boolean;

    property ZipAreas[Index: Integer]: TSperreOfficalHolidaysZipArea
      read GetZipArea;
    property ZipAreaCount: Integer read GetZipAreaCount;

    property Holidays[Index: Integer]: TSperreOfficalHolidayItem
      read GetHoliday;
    property HolidayCount: Integer read GetHolidayCount;

    property Name: String read FName write FName;

    property Global: boolean read FGlobal write FGlobal;

    property Owner: TSperreOfficalHolidays read FOwner;
    property Index: Integer read GetIndex;
  end;

  TSperreOfficalHolidays = class
  private
    FStates: TList;
    FColor: TColor;

    function GetState(Index: Integer): TSperreOfficalHolidaysState;
    function GetStateCount: Integer;
  protected
    procedure AddStateOfGermany; virtual;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    procedure LoadFromFile(const Filename: String);
    procedure SaveToFile(const Filename: String);
    procedure AddToSperre(pColor: TColor; pPrioritaet: Integer;
      const Sperre: TSperre);

    function GetYears: TStringList;

    // procedure AddGermanysOfficalHoldays;
    function AddState(const Name: String): TSperreOfficalHolidaysState;

    function IsHoliday(const Zip: String; DateTime: TDateTime)
      : boolean; overload;

    // Gültige Indizes für Bundesländer
    // 0 (oder null) = Bundesweit
    // 1  = Baden-Württemberg
    // 2  = Bayern
    // 3  = Berlin
    // 4  = Brandenburg
    // 5  = Bremen
    // 6  = Hamburg
    // 7  = Hessen
    // 8  = Mecklenburg-Vorpommern
    // 9  = Niedersachsen
    // 10 = Nordrhein-Westfalen
    // 11 = Rheinland-Pfalz
    // 12 = Saarland
    // 13 = Sachsen
    // 14 = Sachsen-Anhalt
    // 15 = Schleswig-Holstein
    // 16 = Thüringen
    function IsHoliday(StateIndex: Integer; DateTime: TDateTime)
      : boolean; overload;

    property States[Index: Integer]: TSperreOfficalHolidaysState read GetState;
    property StateCount: Integer read GetStateCount;

    property Color: TColor read FColor write FColor;
  end;

implementation

uses
  html, SysUtils, txXML;

constructor TSperreWeekDaySpecifics.Create(AOwner: TSperreWeekDayItem);
begin
  FOwner := AOwner;
  Reset;
end;

procedure TSperreWeekDaySpecifics.Reset;
begin
  FMorning := false;
  FAfternoon := false;
  FFromDateTime := 0.0;
  FToDateTime := 0.0;
  FColor := cSperre_ColourDefault;
end;

function TSperreWeekDaySpecifics.CheckIt(DateTime: TDateTime): boolean;
var
  DTFrom, DTTo: TDateTime;
begin
  Result := false;

  if DayOfWeek(DateTime) = FOwner.FIndex then
  begin
    if (FFromDateTime <> 0.0) then
      if (DateTime < FFromDateTime) then
        Exit;

    if (FToDateTime <> 0.0) then
      if (DateTime > FToDateTime) then
        Exit;

    if FMorning and FAfternoon then
      Result := True
    else
    begin
      if FMorning then
      begin
        TryEncodeDateTime(YearOf(DateTime), MonthOf(DateTime), DayOf(DateTime),
          0, 0, 0, 0, DTFrom);

        TryEncodeDateTime(YearOf(DateTime), MonthOf(DateTime), DayOf(DateTime),
          11, 59, 59, 0, DTTo);

        if (DateTime >= DTFrom) and (DateTime <= DTTo) then
          Result := True;
      end;

      if (not Result) and FAfternoon then
      begin
        TryEncodeDateTime(YearOf(DateTime), MonthOf(DateTime), DayOf(DateTime),
          12, 0, 0, 0, DTFrom);

        TryEncodeDateTime(YearOf(DateTime), MonthOf(DateTime), DayOf(DateTime),
          23, 59, 59, 0, DTTo);

        if (DateTime >= DTFrom) and (DateTime <= DTTo) then
          Result := True;
      end;
    end;
  end;
end;

constructor TSperreWeekDayItem.Create;
begin
  FSpecifics := TList.Create;
  FIndex := -1;
  Reset;
end;

destructor TSperreWeekDayItem.Destroy;
begin
  Reset;

  FSpecifics.Free;

  inherited;
end;

procedure TSperreWeekDayItem.Reset;
var
  I, C: Integer;
begin
  C := Count - 1;
  for I := 0 to C do
    Specifics[I].Free;

  FSpecifics.Clear;

  FEnabled := false;
  FColor := cSperre_ColourDefault;
end;

function TSperreWeekDayItem.Add: TSperreWeekDaySpecifics;
begin
  Result := TSperreWeekDaySpecifics.Create(Self);
  Result.Color := Color;

  FSpecifics.Add(Pointer(Result));
end;

function TSperreWeekDayItem.CheckIt(DateTime: TDateTime): boolean;
var
  AColor: TColor;
begin
  Result := CheckIt(DateTime, AColor);
end;

function TSperreWeekDayItem.CheckIt(DateTime: TDateTime;
  var AColor: TColor): boolean;
var
  I, C: Integer;
begin
  Result := false;

  AColor := cSperre_ColourDefault;

  if FEnabled then
    if Count > 0 then
    begin
      Result := false;

      C := Count - 1;
      for I := 0 to C do
        if Specifics[I].CheckIt(DateTime) then
        begin
          AColor := Specifics[I].Color;
          Result := True;
          Break;
        end;
    end
    else if DayOfWeek(DateTime) = FIndex then
    begin
      AColor := FColor;
      Result := True;
    end;
end;

function TSperreWeekDayItem.GetSpecifics(Index: Integer)
  : TSperreWeekDaySpecifics;
begin
  Result := TSperreWeekDaySpecifics(FSpecifics.Items[Index]);
end;

function TSperreWeekDayItem.GetCount: Integer;
begin
  Result := FSpecifics.Count;
end;

constructor TSperreWeekDays.Create;
var
  I: Integer;
begin
  for I := 1 to 7 do
  begin
    FDays[I] := TSperreWeekDayItem.Create;
    FDays[I].FIndex := I;
  end;

  FColor := cSperre_ColourRed;
end;

procedure TSperreWeekDays.Reset;
var
  I: Integer;
begin
  for I := 1 to 7 do
    FDays[I].Reset;
end;

function TSperreWeekDays.CheckIt(DateTime: TDateTime): boolean;
var
  AColor: TColor;
begin
  Result := CheckIt(DateTime, AColor);
end;

function TSperreWeekDays.CheckIt(DateTime: TDateTime;
  var AColor: TColor): boolean;
var
  I: Integer;
begin
  Result := false;

  AColor := cSperre_ColourDefault;
  for I := 1 to 7 do
    if FDays[I].CheckIt(DateTime, AColor) then
    begin
      Result := True;
      Break;
    end;
end;

class function TSperreWeekDays.IndexByText(S: String): Integer;
begin
  S := LowerCase(Trim(S));

  if (S = 'so') or (S = 'sonntag') then
    Result := 1
  else if (S = 'mo') or (S = 'montag') then
    Result := 2
  else if (S = 'di') or (S = 'dienstag') then
    Result := 3
  else if (S = 'mi') or (S = 'mittwoch') then
    Result := 4
  else if (S = 'do') or (S = 'donnerstag') then
    Result := 5
  else if (S = 'fr') or (S = 'freitag') then
    Result := 6
  else if (S = 'sa') or (S = 'samstag') then
    Result := 7
  else
    Result := -1;
end;

function TSperreWeekDays.GetDay(Index: Integer): TSperreWeekDayItem;
begin
  if (Index >= 1) and (Index <= 7) then
    Result := FDays[Index]
  else
    raise Exception.Create('Index (=Wochentag) muss zwischen 1 und 7 liegen');
end;

constructor TSperreOfficalHolidayItem.Create
  (AOwner: TSperreOfficalHolidaysState);
begin
  FOwner := AOwner;

  FDay := 0;
  FMonth := 0;
  FYear := 0;
end;

function TSperreOfficalHolidayItem.IsHoliday(DateTime: TDateTime): boolean;
begin
  if (DayOf(DateTime) = FDay) and (MonthOf(DateTime) = FMonth) and
    (YearOf(DateTime) = FYear) then
    Result := True
  else
    Result := false;
end;

function TSperreOfficalHolidayItem.GetIndex: Integer;
var
  I, C: Integer;
begin
  Result := -1;
  if Assigned(FOwner) then
  begin
    C := FOwner.HolidayCount - 1;
    for I := 0 to C do
      if FOwner.Holidays[I] = Self then
      begin
        Result := I;
        Break;
      end;
  end;
end;

function TSperreOfficalHolidaysZipArea.IsInZipArea(Zip: String): boolean;
begin
  Zip := PrepareZip(Zip);
  if (Zip >= FFromZip) and (Zip <= FToZip) then
    Result := True
  else
    Result := false;
end;

class function TSperreOfficalHolidaysZipArea.PrepareZip
  (const Zip: String): String;
var
  I, L: Integer;
begin
  Result := StrFilter(Zip, '0123456789');

  L := Length(Result);
  for I := L to 5 do
    Result := '0' + Result;
end;

constructor TSperreOfficalHolidaysState.Create(AOwner: TSperreOfficalHolidays);
begin
  FOwner := AOwner;

  FZipAreas := TList.Create;
  FOfficalHoldays := TList.Create;

  FGlobal := false;
end;

destructor TSperreOfficalHolidaysState.Destroy;
begin
  Clear;

  FZipAreas.Free;
  FOfficalHoldays.Free;

  inherited;
end;

procedure TSperreOfficalHolidaysState.Clear;
var
  I, C: Integer;
begin
  C := ZipAreaCount - 1;
  for I := 0 to C do
    ZipAreas[I].Free;
  FZipAreas.Clear;

  C := HolidayCount - 1;
  for I := 0 to C do
    Holidays[I].Free;
  FOfficalHoldays.Clear;
end;

function TSperreOfficalHolidaysState.AddZipArea(const FromZip, ToZip: String)
  : TSperreOfficalHolidaysZipArea;
begin
  Result := TSperreOfficalHolidaysZipArea.Create;
  Result.FFromZip := FromZip;
  Result.FToZip := ToZip;

  FZipAreas.Add(Pointer(Result));
end;

function TSperreOfficalHolidaysState.AddHoliday(const Caption: String;
  Day, Month, Year: Integer): TSperreOfficalHolidayItem;
begin
  Result := TSperreOfficalHolidayItem.Create(Self);

  Result.FCaption := Caption;
  Result.FDay := Day;
  Result.FMonth := Month;
  Result.FYear := Year;

  FOfficalHoldays.Add(Pointer(Result));
end;

function TSperreOfficalHolidaysState.AutoAddHolidays(Year: Integer): Integer;
begin
  case Index of
    0: // Bundesweit
      begin
        AddHoliday('Neujahr', 01, 01, Year);
        AddHoliday('Karfreitag', 02, 04, Year); // ***
        AddHoliday('Ostermontag', 05, 04, Year); // ***
        AddHoliday('Maifeiertag', 01, 05, Year);
        AddHoliday('Christi Himmelfahrt', 13, 05, Year);
        AddHoliday('Pfingstmontag', 24, 05, Year); // ***
        AddHoliday('Tag der Deutschen Einheit', 03, 10, Year);
        AddHoliday('1. Weihnachtstag', 25, 12, Year);
        AddHoliday('2. Weihnachtstag', 26, 12, Year);

        Result := 9;
      end;
    1: // Baden-Württemberg
      begin
        AddHoliday('Heilige Drei Könige', 06, 01, Year);
        AddHoliday('Fronleichnam', 03, 06, Year);
        AddHoliday('Allerheiligen', 01, 11, Year);

        Result := 3;
      end;
    2: // Bayern
      begin
        AddHoliday('Heilige Drei Könige', 06, 01, Year);
        AddHoliday('Fronleichnam', 03, 06, Year);
        AddHoliday('Maria Himmelfahrt', 15, 08, Year);
        AddHoliday('Allerheiligen', 01, 11, Year);

        Result := 4;
      end;
    3: // Berlin
      begin
        Result := 0;
      end;
    4: // Brandenburg
      begin
        AddHoliday('Reformationstag', 31, 10, Year);

        Result := 1;
      end;
    5: // Bremen
      begin
        Result := 0;
      end;
    6: // Hamburg
      begin
        Result := 0;
      end;
    7: // Hessen
      begin
        AddHoliday('Fronleichnam', 03, 06, Year);

        Result := 1;
      end;
    8: // Mecklenburg-Vorpommern
      begin
        AddHoliday('Reformationstag', 31, 10, Year);

        Result := 1;
      end;
    9: // Niedersachsen
      begin
        Result := 0;
      end;
    10: // Nordrhein-Westfalen
      begin
        AddHoliday('Fronleichnam', 03, 06, Year);
        AddHoliday('Allerheiligen', 01, 11, Year);

        Result := 2;
      end;
    11: // Rheinland-Pfalz
      begin
        AddHoliday('Fronleichnam', 03, 06, Year);
        AddHoliday('Allerheiligen', 01, 11, Year);

        Result := 2;
      end;
    12: // Saarland
      begin
        AddHoliday('Fronleichnam', 03, 06, Year);
        AddHoliday('Maria Himmelfahrt', 15, 08, Year);
        AddHoliday('Allerheiligen', 01, 11, Year);

        Result := 3;
      end;
    13: // Sachsen
      begin
        AddHoliday('Reformationstag', 31, 10, Year);
        AddHoliday('Buß- und Bettag', 17, 11, Year);

        Result := 2;
      end;
    14: // Sachsen-Anhalt
      begin
        AddHoliday('Heilige Drei Könige', 06, 01, Year);
        AddHoliday('Reformationstag', 31, 10, Year);

        Result := 2;
      end;
    15: // Schleswig-Holstein
      begin
        Result := 0;
      end;
    16: // Thüringen
      begin
        AddHoliday('Reformationstag', 31, 10, Year);

        Result := 1;
      end;
  end;
end;

procedure TSperreOfficalHolidaysState.DeleteHoliday(Index: Integer);
begin
  Holidays[Index].Free;
  FOfficalHoldays.Delete(Index);
end;

function TSperreOfficalHolidaysState.IsHoliday(DateTime: TDateTime): boolean;
var
  I, C: Integer;
begin
  Result := false;

  C := HolidayCount - 1;
  for I := 0 to C do
    if Holidays[I].IsHoliday(DateTime) then
    begin
      Result := True;
      Break;
    end;
end;

function TSperreOfficalHolidaysState.IsHoliday(const Zip: String;
  DateTime: TDateTime): boolean;
var
  I, C: Integer;
begin
  Result := false;

  // Zuerst die PLZ überprüfen
  C := ZipAreaCount - 1;
  for I := 0 to C do
    if ZipAreas[I].IsInZipArea(Zip) then
    begin
      Result := True;
      Break;
    end;

  // Wenn PLZ ok, dann Datum prüfen
  if Result then
    Result := IsHoliday(DateTime);
end;

function TSperreOfficalHolidaysState.CountHolidays(Year: Integer): Integer;
var
  I, C: Integer;
begin
  Result := 0;

  C := HolidayCount - 1;
  for I := 0 to C do
    if Holidays[I].Year = Year then
      Inc(Result);
end;

function TSperreOfficalHolidaysState.YearExists(Year: Integer): boolean;
begin
  Result := CountHolidays(Year) > 0;
end;

function TSperreOfficalHolidaysState.GetZipArea(Index: Integer)
  : TSperreOfficalHolidaysZipArea;
begin
  Result := TSperreOfficalHolidaysZipArea(FZipAreas.Items[Index]);
end;

function TSperreOfficalHolidaysState.GetZipAreaCount: Integer;
begin
  Result := FZipAreas.Count;
end;

function TSperreOfficalHolidaysState.GetHoliday(Index: Integer)
  : TSperreOfficalHolidayItem;
begin
  Result := TSperreOfficalHolidayItem(FOfficalHoldays.Items[Index]);
end;

function TSperreOfficalHolidaysState.GetHolidayCount: Integer;
begin
  Result := FOfficalHoldays.Count;
end;

function TSperreOfficalHolidaysState.GetIndex: Integer;
var
  I, C: Integer;
begin
  Result := -1;
  if Assigned(FOwner) then
  begin
    C := FOwner.StateCount - 1;
    for I := 0 to C do
      if FOwner.States[I] = Self then
      begin
        Result := I;
        Break;
      end;
  end;
end;

constructor TSperreOfficalHolidays.Create;
begin
  FStates := TList.Create;
  FColor := cSperre_ColourRed;

  AddStateOfGermany;
end;

destructor TSperreOfficalHolidays.Destroy;
begin
  Clear;

  FStates.Free;

  inherited;
end;

procedure TSperreOfficalHolidays.AddStateOfGermany;
begin
  // Bundesweite Feiertage
  with AddState('Bundesweit') do
  begin
    // Alle Postleitzahlen
    AddZipArea('00000', '99999');

    Global := True;
  end;

  with AddState('Baden-Württemberg') do
  begin
    // Postleitzahlengebiete
    AddZipArea('63928', '63928');
    AddZipArea('64754', '64754');
    AddZipArea('68001', '68312');
    AddZipArea('68520', '68549');
    AddZipArea('68701', '69234');
    AddZipArea('69240', '69429');
    AddZipArea('69434', '69434');
    AddZipArea('69435', '69469');
    AddZipArea('69489', '69502');
    AddZipArea('69510', '69514');
    AddZipArea('70001', '74592');
    AddZipArea('74594', '76709');
    AddZipArea('77601', '79879');
    AddZipArea('88001', '88099');
    AddZipArea('88147', '88147');
    AddZipArea('88181', '89079');
    AddZipArea('89081', '89085');
    AddZipArea('89090', '89198');
    AddZipArea('89501', '89619');
    AddZipArea('97861', '97877');
    AddZipArea('97893', '97896');
    AddZipArea('97897', '97900');
    AddZipArea('97911', '97999');
  end;

  with AddState('Bayern') do
  begin
    // Postleitzahlengebiete
    AddZipArea('63701', '63774');
    AddZipArea('63776', '63928');
    AddZipArea('63930', '63939');
    AddZipArea('74594', '74594');
    AddZipArea('80001', '87490');
    AddZipArea('87493', '87561');
    AddZipArea('87571', '87789');
    AddZipArea('88101', '88146');
    AddZipArea('88147', '88179');
    AddZipArea('89081', '89081');
    AddZipArea('89087', '89087');
    AddZipArea('89201', '89449');
    AddZipArea('90001', '96489');
    AddZipArea('97001', '97859');
    AddZipArea('97888', '97892');
    AddZipArea('97896', '97896');
    AddZipArea('97901', '97909');
  end;

  with AddState('Berlin') do
  begin
    // Postleitzahlengebiete
    AddZipArea('10001', '14330');
  end;

  with AddState('Brandenburg') do
  begin
    // Postleitzahlengebiete
    AddZipArea('01941', '01998');
    AddZipArea('03001', '03253');
    AddZipArea('04891', '04938');
    AddZipArea('14401', '14715');
    AddZipArea('14723', '16949');
    AddZipArea('17258', '17258');
    AddZipArea('17261', '17291');
    AddZipArea('17309', '17309');
    AddZipArea('17321', '17321');
    AddZipArea('17326', '17326');
    AddZipArea('17335', '17335');
    AddZipArea('17337', '17337');
    AddZipArea('19307', '19357');
  end;

  with AddState('Bremen') do
  begin
    // Postleitzahlengebiete
    AddZipArea('27501', '27580');
    AddZipArea('28001', '28779');
  end;

  with AddState('Hamburg') do
  begin
    // Postleitzahlengebiete
    AddZipArea('20001', '21037');
    AddZipArea('21039', '21170');
    AddZipArea('22001', '22113');
    AddZipArea('22115', '22143');
    AddZipArea('22145', '22145');
    AddZipArea('22147', '22786');
    AddZipArea('27499', '27499');
  end;

  with AddState('Hessen') do
  begin
    // Postleitzahlengebiete
    AddZipArea('34001', '34329');
    AddZipArea('34355', '34355');
    AddZipArea('34356', '34399');
    AddZipArea('34441', '36399');
    AddZipArea('37194', '37195');
    AddZipArea('37201', '37299');
    AddZipArea('55240', '55252');
    AddZipArea('59969', '59969');
    AddZipArea('60001', '63699');
    AddZipArea('63776', '63776');
    AddZipArea('64201', '64753');
    AddZipArea('64754', '65326');
    AddZipArea('65327', '65391');
    AddZipArea('65392', '65556');
    AddZipArea('65583', '65620');
    AddZipArea('65627', '65627');
    AddZipArea('65701', '65936');
    AddZipArea('68501', '68519');
    AddZipArea('68601', '68649');
    AddZipArea('69235', '69239');
    AddZipArea('69430', '69431');
    AddZipArea('69434', '69434');
    AddZipArea('69479', '69488');
    AddZipArea('69503', '69509');
    AddZipArea('69515', '69518');
  end;

  with AddState('Mecklenburg-Vorpommern') do
  begin
    // Postleitzahlengebiete
    AddZipArea('17001', '17256');
    AddZipArea('17258', '17259');
    AddZipArea('17301', '17309');
    AddZipArea('17309', '17321');
    AddZipArea('17321', '17322');
    AddZipArea('17328', '17331');
    AddZipArea('17335', '17335');
    AddZipArea('17337', '19260');
    AddZipArea('19273', '19273');
    AddZipArea('19273', '19306');
    AddZipArea('19357', '19417');
    AddZipArea('23921', '23999');
  end;

  with AddState('Niedersachsen') do
  begin
    // Postleitzahlengebiete
    AddZipArea('19271', '19273');
    AddZipArea('21202', '21449');
    AddZipArea('21522', '21522');
    AddZipArea('21601', '21789');
    AddZipArea('26001', '27478');
    AddZipArea('27607', '27809');
    AddZipArea('28784', '29399');
    AddZipArea('29431', '31868');
    AddZipArea('34331', '34353');
    AddZipArea('34355', '34355');
    AddZipArea('37001', '37194');
    AddZipArea('37197', '37199');
    AddZipArea('37401', '37649');
    AddZipArea('37689', '37691');
    AddZipArea('37697', '38479');
    AddZipArea('38501', '38729');
    AddZipArea('48442', '48465');
    AddZipArea('48478', '48480');
    AddZipArea('48486', '48488');
    AddZipArea('48497', '48531');
    AddZipArea('49001', '49459');
    AddZipArea('49551', '49849');
  end;

  with AddState('Nordrhein-Westfalen') do
  begin
    // Postleitzahlengebiete
    AddZipArea('32001', '33829');
    AddZipArea('34401', '34439');
    AddZipArea('37651', '37688');
    AddZipArea('37692', '37696');
    AddZipArea('40001', '48432');
    AddZipArea('48466', '48477');
    AddZipArea('48481', '48485');
    AddZipArea('48489', '48496');
    AddZipArea('48541', '48739');
    AddZipArea('49461', '49549');
    AddZipArea('50101', '51597');
    AddZipArea('51601', '53359');
    AddZipArea('53581', '53604');
    AddZipArea('53621', '53949');
    AddZipArea('57001', '57489');
    AddZipArea('58001', '59966');
    AddZipArea('59969', '59969');
  end;

  with AddState('Rheinland-Pfalz') do
  begin
    // Postleitzahlengebiete
    AddZipArea('51598', '51598');
    AddZipArea('53401', '53579');
    AddZipArea('53614', '53619');
    AddZipArea('54181', '55239');
    AddZipArea('55253', '56869');
    AddZipArea('57501', '57648');
    AddZipArea('65326', '65326');
    AddZipArea('65391', '65391');
    AddZipArea('65558', '65582');
    AddZipArea('65621', '65626');
    AddZipArea('65629', '65629');
    AddZipArea('66461', '66509');
    AddZipArea('66841', '67829');
    AddZipArea('76711', '76891');
  end;

  with AddState('Saarland') do
  begin
    // Postleitzahlengebiete
    AddZipArea('66001', '66459');
    AddZipArea('66511', '66839');
  end;

  with AddState('Sachsen') do
  begin
    // Postleitzahlengebiete
    AddZipArea('01001', '01936');
    AddZipArea('02601', '02999');
    AddZipArea('04001', '04579');
    AddZipArea('04641', '04889');
    AddZipArea('07919', '07919');
    AddZipArea('07919', '07919');
    AddZipArea('07951', '07951');
    AddZipArea('07952', '07952');
    AddZipArea('07982', '07982');
    AddZipArea('07985', '07985');
    AddZipArea('08001', '09669');
  end;

  with AddState('Sachsen-Anhalt') do
  begin
    // Postleitzahlengebiete
    AddZipArea('06001', '06548');
    AddZipArea('06601', '06928');
    AddZipArea('14715', '14715');
    AddZipArea('29401', '29416');
    AddZipArea('38481', '38489');
    AddZipArea('38801', '39649');
  end;

  with AddState('Schleswig-Holstein') do
  begin
    // Postleitzahlengebiete
    AddZipArea('21039', '21039');
    AddZipArea('21451', '21521');
    AddZipArea('21524', '21529');
    AddZipArea('22113', '22113');
    AddZipArea('22145', '22145');
    AddZipArea('22145', '22145');
    AddZipArea('22801', '23919');
    AddZipArea('24001', '25999');
    AddZipArea('27483', '27498');
  end;

  with AddState('Thüringen') do
  begin
    // Postleitzahlengebiete
    AddZipArea('04581', '04639');
    AddZipArea('06551', '06578');
    AddZipArea('07301', '07919');
    AddZipArea('07919', '07919');
    AddZipArea('07920', '07950');
    AddZipArea('07952', '07952');
    AddZipArea('07953', '07980');
    AddZipArea('07985', '07985');
    AddZipArea('07985', '07989');
    AddZipArea('36401', '36469');
    AddZipArea('37301', '37359');
    AddZipArea('96501', '96529');
    AddZipArea('98501', '99998');
  end;
end;

procedure TSperreOfficalHolidays.AddToSperre(pColor: TColor;
  pPrioritaet: Integer; const Sperre: TSperre);

var
  I: Integer;
  rSperre: TSperreRecord;

  procedure SaveState(Index: Integer);
  var
    State: TSperreOfficalHolidaysState;
    I, C: Integer;

    procedure SaveHoliday(Holiday: TSperreOfficalHolidayItem);
    begin
      with rSperre do
      begin
        StartD :=
        { } long2datetime(
          { } Details2Long(
          { } Holiday.Year,
          { } Holiday.Month,
          { } Holiday.Day));

        // Ende der Sperre (Datum, Uhrzeit)
        // dieser Endpunkt ist noch gesperrt
        EndeD := StartD + cTime_23_59_59;
        GrundKurz := Holiday.Caption;
      end;
      Sperre[Sperre.Add] := rSperre;
    end;

  begin
    rSperre.Kontext := Index;

    State := States[Index];
    for I := 0 to pred(State.HolidayCount) do
      SaveHoliday(State.Holidays[I]);
  end;

begin
  // Init single Sperre Record
  fillchar(rSperre,sizeof(TSperreRecord),0);
  with rSperre do
  begin
    BadPeriod := true;
    BadColor := pColor;
    Prioritaet := pPrioritaet;
  end;
  for I := 0 to pred(StateCount) do
    SaveState(I);
end;

procedure TSperreOfficalHolidays.Clear;
var
  I, C: Integer;
begin
  C := StateCount - 1;
  for I := 0 to C do
    States[I].Free;

  FStates.Clear;

  AddStateOfGermany;
end;

procedure TSperreOfficalHolidays.LoadFromFile(const Filename: String);
var
  XML: TTXXMLDocument;
  XMLEntities: TTXXMLEntities;

  procedure LoadDocument(XMLNode: TTXXMLNodeElement);
  var
    SubNode: TTXXMLNodeElement;
    NodeName: String;
    I, C: Integer;

    procedure LoadYears(XMLNode: TTXXMLNodeElement);
    var
      SubNode: TTXXMLNodeElement;
      NodeName: String;
      AYear: Integer;
      I, C: Integer;

      procedure LoadStates(XMLNode: TTXXMLNodeElement);
      var
        SubNode: TTXXMLNodeElement;
        NodeName: String;
        StateIndex: Integer;
        I, C: Integer;

        procedure LoadHolidays(XMLNode: TTXXMLNodeElement;
          State: TSperreOfficalHolidaysState);
        var
          SubNode: TTXXMLNodeElement;
          NodeName: String;
          ADay: Integer;
          AMonth: Integer;
          ACaption: String;
          I, C: Integer;
        begin
          C := XMLNode.Count - 1;
          for I := 0 to C do
            if XMLNode.NodeTypes[I] = dtElement then
            begin
              SubNode := XMLNode.Elements[I];
              NodeName := LowerCase(SubNode.NodeName);

              if NodeName = 'holiday' then
              begin
                ADay := TXStrToInt(SubNode.Attributes['day']);
                AMonth := TXStrToInt(SubNode.Attributes['month']);
                ACaption := LimitSpaces(SubNode.Attributes['caption']);

                State.AddHoliday(ACaption, ADay, AMonth, AYear);
              end;
            end;
        end;

      begin
        C := XMLNode.Count - 1;
        for I := 0 to C do
          if XMLNode.NodeTypes[I] = dtElement then
          begin
            SubNode := XMLNode.Elements[I];
            NodeName := LowerCase(SubNode.NodeName);

            if NodeName = 'state' then
            begin
              if Trim(SubNode.Attributes['index']) <> '' then
              begin
                StateIndex := TXStrToInt(SubNode.Attributes['index']);
                if (StateIndex >= 0) and (StateIndex < StateCount) then
                  LoadHolidays(SubNode, States[StateIndex]);
              end;
            end;
          end;
      end;

    begin
      C := XMLNode.Count - 1;
      for I := 0 to C do
        if XMLNode.NodeTypes[I] = dtElement then
        begin
          SubNode := XMLNode.Elements[I];
          NodeName := LowerCase(SubNode.NodeName);

          if NodeName = 'year' then
          begin
            AYear := TXStrToInt(SubNode.Attributes['value']);
            if AYear > 0 then
              LoadStates(SubNode);
          end;
        end;
    end;

  begin
    C := XMLNode.Count - 1;
    for I := 0 to C do
      if XMLNode.NodeTypes[I] = dtElement then
      begin
        SubNode := XMLNode.Elements[I];
        NodeName := LowerCase(SubNode.NodeName);

        if NodeName = 'years' then
        begin
          LoadYears(SubNode);
          Break;
        end;
      end;
  end;

begin
  XML := TTXXMLDocument.Create;
  XMLEntities := TTXXMLEntities.Create;
  try
    XMLEntities.AddStandardXMLEntities;
    XML.XMLEntities := XMLEntities;

    if FileExists(Filename) then
      XML.LoadFromFile(Filename);

    Clear;

    LoadDocument(XML.Document);
  finally
    XML.Free;
  end;
end;

procedure TSperreOfficalHolidays.SaveToFile(const Filename: String);
var
  XML: TTXXMLDocument;
  XMLEntities: TTXXMLEntities;

  procedure SaveDocument(XMLNode: TTXXMLNodeElement);
  var
    Years: TStringList;
    I, C: Integer;

    procedure SaveYear(XMLNode: TTXXMLNodeElement; Year: Integer);
    var
      I, C: Integer;

      procedure SaveState(XMLNode: TTXXMLNodeElement; Index: Integer);
      var
        State: TSperreOfficalHolidaysState;
        I, C: Integer;

        procedure SaveHoliday(XMLNode: TTXXMLNodeElement;
          Holiday: TSperreOfficalHolidayItem);
        begin
          XMLNode.Attributes['day'] := IntToStr(Holiday.Day);
          XMLNode.Attributes['month'] := IntToStr(Holiday.Month);
          XMLNode.Attributes['caption'] := Holiday.Caption;
        end;

      begin
        State := States[Index];

        XMLNode.Attributes['index'] := IntToStr(Index);
        XMLNode.Attributes['name'] := State.Name;

        C := State.HolidayCount - 1;
        for I := 0 to C do
          if State.Holidays[I].Year = Year then
            SaveHoliday(XMLNode.AddElement('holiday'), State.Holidays[I]);
      end;

    begin
      XMLNode.Attributes['value'] := IntToStr(Year);

      C := StateCount - 1;
      for I := 0 to C do
        if States[I].YearExists(Year) then
          SaveState(XMLNode.AddElement('state'), I);
    end;

  begin
    Years := GetYears;
    try
      with XMLNode.AddElement('years') do
      begin
        C := Years.Count - 1;
        for I := 0 to C do
          SaveYear(AddElement('year'), TXStrToInt(Years.Strings[I]));
      end;
    finally
      Years.Free;
    end;
  end;

begin
  XML := TTXXMLDocument.Create;
  XMLEntities := TTXXMLEntities.Create;
  try
    XMLEntities.AddStandardXMLEntities;
    XML.XMLEntities := XMLEntities;

    SaveDocument(XML.Document);

    XML.SaveToFile(Filename);
  finally
    XML.Free;
  end;
end;

function TSperreOfficalHolidays.GetYears: TStringList;
var
  TmpList: TTXStringList;
  SYear: String;
  I, J, CI, CJ: Integer;
begin
  TmpList := TTXStringList.Create;
  try
    with TmpList do
    begin
      SearchMethod := smHash;
      Hashsize := 64;
      Duplicates := false;
      Trimmed := false;
      CaseSensitive := True;
      Umlaut := false;
    end;

    Result := TStringList.Create;
    try
      CI := StateCount - 1;
      for I := 0 to CI do
      begin
        CJ := States[I].HolidayCount - 1;
        for J := 0 to CJ do
        begin
          SYear := IntToStr(States[I].Holidays[J].Year);
          if TmpList.Find(SYear) < 0 then
            TmpList.Add(SYear);
        end;
      end;

      CI := TmpList.Count - 1;
      for I := 0 to CI do
        Result.Add(TmpList.Strings[I]);
    except
      Result.Free;

      raise;
    end;
  finally
    TmpList.Free;
  end;
end;

function TSperreOfficalHolidays.AddState(const Name: String)
  : TSperreOfficalHolidaysState;
begin
  Result := TSperreOfficalHolidaysState.Create(Self);
  Result.FName := Name;

  FStates.Add(Pointer(Result));
end;

function TSperreOfficalHolidays.IsHoliday(const Zip: String;
  DateTime: TDateTime): boolean;
var
  I, C: Integer;
begin
  Result := false;

  C := StateCount - 1;
  for I := 0 to C do
    if States[I].IsHoliday(Zip, DateTime) then
    begin
      Result := True;
      Break;
    end;
end;

function TSperreOfficalHolidays.IsHoliday(StateIndex: Integer;
  DateTime: TDateTime): boolean;
var
  I, C: Integer;
begin
  Result := States[StateIndex].IsHoliday(DateTime);

  // Global durchsuchen (z.B. bundesweit)
  if not Result then
  begin
    C := StateCount - 1;
    for I := 0 to C do
      if I <> StateIndex then
        if States[I].Global then
          if States[I].IsHoliday(DateTime) then
          begin
            Result := True;
            Break;
          end;
  end;
end;

function TSperreOfficalHolidays.GetState(Index: Integer)
  : TSperreOfficalHolidaysState;
begin

  Result := TSperreOfficalHolidaysState(FStates.Items[Index]);
end;

function TSperreOfficalHolidays.GetStateCount: Integer;
begin
  Result := FStates.Count;
end;

end.
