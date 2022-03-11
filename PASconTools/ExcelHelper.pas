{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2022  Andreas Filsinger
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
unit ExcelHelper;

{$ifdef FPC}
{$mode delphi}
{$endif}

interface

uses
  Classes
{$IFDEF fpc}
    , fpspreadsheet, fpsTypes, fpsUtils, fpsallformats, fpsNumFormat
{$ELSE}
    , VCL.FlexCel.Core, FlexCel.XlsAdapter
{$ENDIF}
    ;

const
  cExcel_HTML_Color_High = $99CCFF;
  cExcel_HTML_Color_Low = $FFFFFF;
  cExcel_HTML_Color_Header = $FFFFCC;
  cExcel_Pixel_Per_Char = 340;
  cExcel_HTML_ColorPalette: array [1 .. 56] of integer = ($000000, $FFFFFF,
    $FF0000, $00FF00, $0000FF, $FFFF00, $FF00FF, $00FFFF, $800000, $008000,
    $000080, $808000, $800080, $008080, $C0C0C0, $808080, $9999FF, $993366,
    $FFFFCC, $CCFFFF, $660066, $FF8080, $0066CC, $CCCCFF, $000080, $FF00FF,
    $FFFF00, $00FFFF, $800080, $800000, $008080, $0000FF, $00CCFF, $CCFFFF,
    $CCFFCC, $FFFF99, $99CCFF, $FF99CC, $CC99FF, $FFCC99, $3366FF, $33CCCC,
    $99CC00, $FFCC00, $FF9900, $FF6600, $666699, $969696, $003366, $339966,
    $003300, $333300, $993300, $993366, $333399, $333333);

  cCellFormat_Color = 'Farbe';
  cCellFormat_TextDirection = 'Vertikal';
  cCellFormat_CellCenter = 'Zentriert';
  cCellFormat_CellWidth = 'Breite';
  cCellFormat_Comment = 'Hinweis';

  // Excel Zellen Typen
  xls_CellType_Count = 9;

  xls_CellType_String = 0;
  xls_CellType_Date = 1;
  xls_CellType_DateTime = 2;
  xls_CellType_Time = 3;
  xls_CellType_ordinal = 4;
  xls_CellType_double = 5;
  xls_CellType_Money = 6;
  xls_CellType_Auto = 7;
  xls_CellType_Text = 8;

  xls_CellTypes: array [0 .. pred(xls_CellType_Count)] of string = (
    { } 'STRING',
    { } 'DATE',
    { } 'DATETIME',
    { } 'TIME',
    { } 'ORDINAL',
    { } 'DOUBLE',
    { } 'MONEY',
    { } 'AUTO',
    { } 'TEXT');

  cExcel_TabellenName = 'TabellenName';
  cExcel_FarbSpalte = 'FarbSpalte';

  //
  // TList of TStringList, eine TStringList=eine Zeile
  // eine Zelle = TStringList(TList[r])[c]
  // Headers (optional) die Titel TStringList
  // =nil: Titel ist Zeile 0
  //
  // sOptions: SPALTENÜBERSCHRIFT=FELDTYP
  //           Farbspalte=<SPALTENÜBERSCHRIFT>
  //           TabellenName=<SheetName>

{$IFDEF fpc}
procedure ExcelExport(FName: string; Content: TList; Headers: TStringList = nil;
  sOptions: TStringList = nil; wb: TsWorkbook = nil);
function getDateValue(s: TsWorksheet; r, c: integer): TDateTime;
function getTimeValue(s: TsWorksheet; r, c: integer): TDateTime;
function getDateTimeValue(s: TsWorksheet; r, c: integer): TDateTime;
function ReadFormatStr(wb: TsWorkbook; r, c: Integer): string;
{$ELSE}
procedure ExcelExport(FName: string; Content: TList; Headers: TStringList = nil;
  sOptions: TStringList = nil; wb: TXLSFile = nil);
function getDateValue(s: TXLSFile; r, c: integer): TDateTime;
function getTimeValue(s: TXLSFile; r, c: integer): TDateTime;
function getDateTimeValue(s: TXLSFile; r, c: integer): TDateTime;
{$ENDIF}
procedure CSVExport(FName: string; Content: TList);
procedure CSVImport(FName: string; Content: TList);


implementation

uses
 html, anfix, math,
 SysUtils, graphics;

const
cOLAPcsvLineBreak = '|';
cOLAPnull = '<NULL>';
cOLAPcsvSeparator = ';';
cOLAPcsvQuote = '"';

{$ifdef fpc}
function ReadFormatStr(wb: TsWorkbook; r, c: Integer): string;
var
 CellFormatIndex: Integer;
 Cell: PCell;
 cf: TsCellFormat;
 NumF : TsNumFormatParams;
begin
  result := '';
  with wb do
  begin
    CellFormatIndex := ActiveWorksheet.GetEffectiveCellFormatIndex(pred(r),pred(c));
    repeat
      if (CellFormatIndex=0) then
        break;
      cf := GetCellFormat(CellFormatIndex);
      if (cf.NumberFormatIndex=0) then
       break;
      NumF := GetNumberFormat(cf.NumberFormatIndex);
      if not(assigned(NumF)) then
        break;
      result := NumF.NumFormatStr;
    until yet;
  end;
end;
{$endif}

procedure CSVExport(FName: string; Content: TList);
var
  m: integer;
  JoinL: TStringList;
begin
  // fertig -> rausspeichern
  JoinL := TStringList.Create;
  for m := 0 to pred(Content.count) do
    JoinL.add(HugeSingleLine(TStringList(Content[m]), cOLAPcsvSeparator));
  JoinL.SaveToFile(FName);
end;

procedure CSVImport(FName: string; Content: TList);
var
  n, m, k: integer;
  Cols: TStringList;
  ThisHeader: string;
  ThisLine: string;
  ColCount: integer;
  JoinL: TStringList;
begin
  Content.clear;
  Content.add(TStringList.Create);
  JoinL := TStringList.Create;
  LoadFromFileCSV(true, JoinL, FName);
  ThisHeader := JoinL[0];
  while (ThisHeader <> '') do
    TStringList(Content[0]).add(nextp(ThisHeader, cOLAPcsvSeparator));
  ColCount := TStringList(Content[0]).count;
  for n := 1 to pred(JoinL.count) do
  begin
    ThisLine := JoinL[n];
    Cols := TStringList.Create;
    for m := 0 to pred(ColCount) do
    begin
      if (pos(cOLAPcsvQuote, ThisLine) = 1) then
      begin
        k := pos(cOLAPcsvQuote, copy(ThisLine, 2, MaxInt));
        Cols.add(copy(ThisLine, 2, k - 1));
        delete(ThisLine, 1, k + 1);
        nextp(ThisLine, cOLAPcsvSeparator);
      end
      else
      begin
        Cols.add(nextp(ThisLine, cOLAPcsvSeparator));
      end;
    end;
    Content.add(Cols);
  end;
end;

{$ifdef fpc}
function getDateTimeValue(s: TsWorksheet; r, c: integer): TDateTime;
{$else}
function getDateTimeValue(s: TXLSFile; r, c: integer): TDateTime;
{$endif}
begin
  with s do
{$ifdef fpc}
    if (FindCell(r, c)<>nil) then
      ReadAsDateTime(r, c, result)
{$else}
    if GetCellValue(r, c).HasValue then
      result := GetCellValue(r, c).ToDateTime(false)
{$endif}
    else
      result := 0;
end;

{$ifdef fpc}
function getDateValue(s: TsWorksheet; r, c: integer): TDateTime;
{$else}
function getDateValue(s: TXLSFile; r, c: integer): TDateTime;
{$endif}
begin
  result := trunc(getDateTimeValue(s,r,c));
end;

{$ifdef fpc}
function getTimeValue(s: TsWorksheet; r, c: integer): TDateTime;
{$else}
function getTimeValue(s: TXLSFile; r, c: integer): TDateTime;
{$endif}
begin
  result := getDateTimeValue(s, r, c);
  ReplaceDate(result, 0);
end;

{$IFDEF fpc}
procedure ExcelExport(
  {} FName: string;
  {} Content: TList;
  {} Headers: TStringList = nil;
  {} sOptions: TStringList = nil;
  {} wb: TsWorkbook = nil);
{$ELSE}
procedure ExcelExport(
  {} FName: string;
  {} Content: TList;
  {} Headers: TStringList = nil;
  {} sOptions: TStringList = nil;
  {} wb: TXLSFile = nil);
{$endif}
var
{$ifdef fpc}
xlsAUSGABE: TsWorkbook;
{$else}
xlsAUSGABE: TXLSFile;
{$endif}
  xlsFormatDefault: string;
  Columns: integer;
  AllTypes: TStringList;
  CellCharCount: integer;
  MoneyDouble: double;

  xlsColumnWidth: array of integer;
  xlsFormatsLow: array of integer;
  xlsFormatsHigh: array of integer;
  xlsFormatsAll: array of integer;
{$ifdef fpc}
  fmfm, fmfm2: TsCellFormat;
{$else}
  fmfm: TFlxFormat;
{$endif}
  Subs: TStringList;
  myCellValue: string;
  userWidth: integer;

  // Formate
  fmHeader: integer;
  fmLow, fmHigh: integer;
  fmLow_Date, fmHigh_Date: integer;
  fmLow_DateTime, fmHigh_DateTime: integer;
  fmLow_Time, fmHigh_Time: integer;
  fmLow_Money, fmHigh_Money: integer;
  fmLow_Text, fmHigh_Text: integer;

  function getCount: integer;
  begin
    result := Content.count;
    if assigned(Headers) then
      inc(result);
  end;

  function getLine(Index: integer): TStringList;
  begin
    if assigned(Headers) then
    begin
      if (Index = 0) then
        result := Headers
      else
        result := Content[pred(Index)];
    end
    else
    begin
      result := Content[Index];
    end;
  end;

  function EnsureFormat(
    {} FormatString: string;
    {} CellColor: TColor;
    {} MultiLine: boolean = false): integer;
  begin
    {$ifdef fpc}

    if (FormatString<>'') then
    begin
      Include(fmfm.UsedFormattingFields, uffNumberFormat);
      fmfm.NumberFormatIndex := xlsAUSGABE.AddNumberFormat(FormatString);
    end else
    begin
      Exclude(fmfm.UsedFormattingFields, uffNumberFormat);
      fmfm.NumberFormatIndex := -1;
    end;

    Include(fmfm.UsedFormattingFields, uffBackground);
    fmfm.Background.Style:=fsSolidFill;
    fmfm.Background.FgColor := CellColor;
    fmfm.Background.BgColor := CellColor;

    if MultiLine then
     Include(fmfm.UsedFormattingFields,uffWordWrap);

    result := xlsAUSGABE.AddCellFormat(fmfm);
    {$else}
    with fmfm do
    begin
      format := FormatString;
      fmfm.FillPattern.FgColor := CellColor;
      fmfm.WrapText := MultiLine;
    end;
    result := xlsAUSGABE.addformat(fmfm);
    {$endif}
  end;

  function fmSetColor(fmIndex: integer; CellColor: TColor): integer;
  begin
    {$ifdef fpc}
    fmfm := xlsAUSGABE.GetCellFormat(fmIndex);
    Include(fmfm.UsedFormattingFields, uffBackground);
    fmfm.Background.Style:=fsSolidFill;
    fmfm.Background.FgColor := CellColor;
    fmfm.Background.BgColor := CellColor;
    result := xlsAUSGABE.AddCellFormat(fmfm);
    {$else}
    fmfm := xlsAUSGABE.getformat(fmIndex);
    fmfm.FillPattern.FgColor := CellColor;
    result := xlsAUSGABE.addformat(fmfm);
    {$endif}
  end;

  function fmSetOrientationVertikal(fmIndex: integer): integer;
  begin
    {$ifdef fpc}
    fmfm := xlsAUSGABE.GetCellFormat(fmIndex);
    fmfm.TextRotation:=rt90DegreeClockwiseRotation; // oder rt90DegreeCounterClockwiseRotation?
    result := xlsAUSGABE.AddCellFormat(fmfm);
    {$else}
    fmfm := xlsAUSGABE.getformat(fmIndex);
    fmfm.Rotation := 90;
    result := xlsAUSGABE.addformat(fmfm);
    {$endif}
  end;

  function fmSetAlignment(fmIndex: integer): integer;
  begin
    {$ifdef fpc}
    fmfm := xlsAUSGABE.GetCellFormat(fmIndex);
    fmfm.HorAlignment := haCenter;
    fmfm.VertAlignment := vaCenter;
    result := xlsAUSGABE.AddCellFormat(fmfm);
    {$else}
    fmfm := xlsAUSGABE.getformat(fmIndex);
    fmfm.HAlignment := THFlxAlignment.center;
    fmfm.VAlignment := TVFlxAlignment.center;
    result := xlsAUSGABE.addformat(fmfm);
    {$endif}
  end;

  function fmModifier(fmIndex: integer; sFormats: TStringList): integer;
  var
    p: string;
  begin
    result := fmIndex;

    // Zell-Hintergrund-Farbe
    p := sFormats.Values[cCellFormat_Color];
    if (p <> '') then
    begin
      if pos('#', p) = 1 then
        // direkte HTML Farbangabe #nnnnnn
        result := fmSetColor(result, HTMLColor2TColor(p))
      else
        // Index 1..56
        result := fmSetColor(result,
          HTMLColor2TColor(cExcel_HTML_ColorPalette[strtointdef(p, 1)]));
    end;

    // Schrift-90° gedreht
    p := sFormats.Values[cCellFormat_TextDirection];
    if (p = 'JA') then
      result := fmSetOrientationVertikal(result);

    // Zellinhalt zentriert
    p := sFormats.Values[cCellFormat_CellCenter];
    if (p = 'JA') then
      result := fmSetAlignment(result);

    // Zellenbreite
    p := sFormats.Values[cCellFormat_CellWidth];
    userWidth := strtointdef(p, 0);

  end;

  function hasType(c: integer): integer;
  var
    s: string;
  begin

    // Datentyp ev. schon erzwungen?!
    if assigned(sOptions) then
      result := AllTypes.indexof(sOptions.Values[getLine(0)[c]])
    else
      result := -1;

    if (result = -1) then
    begin
      if (getCount > 1) then
        s := getLine(1)[c]
      else
        s := '';

      repeat

        // Monetäres Format
        if (pos(',', s) > 0) and (pos('€', s) > 0) and
          (StrFilter(s, ' 0123456789,.-+€') = s) then
        begin
          result := xls_CellType_Money;
          break;
        end;

        // Float oder Ganzzahl
        if (pos('-', s) = 1) or (pos('+', s) = 1) then
        begin
          result := xls_CellType_double;
          break;
        end;

        // Datum
        if (length(s) = 10) then
          if (s[3] = '.') and (s[6] = '.') and (s = StrFilter(s, '0123456789.'))
          then
          begin
            result := xls_CellType_Date;
            break;
          end;

        // Zeitstempel
        if (pos('.', s) = 3) and (pos(' ', s) = 11) and (pos(':', s) = 14) then
        begin
          result := xls_CellType_DateTime;
          break;
        end;

        // positive Ganzzahl
        if length(s) > 0 then
          if (s[1] >= '0') and (s[1] <= '9') then
            if s = StrFilter(s, '0123456789') then
            begin
              result := xls_CellType_ordinal;
              break;
            end;

        // als String!
        result := xls_CellType_String;

      until yet;

    end;
  end;

var
  MultiLineCount: integer;

  function lengthMultiLine(MultiLine: string): integer;
  begin
    result := 0;
    while (MultiLine <> '') do
    begin
      result := max(result, length(nextp(MultiLine, cOLAPcsvLineBreak)));
      inc(MultiLineCount);
    end;
  end;

type
  THLM_Modes = (HLM_byEvenOddHorizontal, HLM_byEvenOddVertikal, HLM_byCol);
var
  HLM_Row: integer;
  HLM_Last: string;
  HLM_Col: integer;
  HLM_Mode: THLM_Modes;

  function isHigh(r, c: integer): boolean;
  begin
    case HLM_Mode of
      HLM_byEvenOddHorizontal:
        begin
          result := (r mod 2 = 0);
        end;
      HLM_byEvenOddVertikal:
        begin
          result := (c mod 2 = 0);
        end;
      HLM_byCol:
        begin
          if (HLM_Last <> Subs[HLM_Col]) then
          begin
            inc(HLM_Row);
            HLM_Last := Subs[HLM_Col];
          end;
          result := (HLM_Row mod 2 = 0);
        end;
    else
      result := false;
    end;
  end;

// Inhalt vom Format trennen
  function cellsplit(const FullCell: string;
    out CellContentString, CellCommentString: string): TStringList;
  var
    l, k: integer;
  begin
    repeat
      l := length(FullCell);
      if (l > 0) then
        if (FullCell[length(FullCell)] = '}') then
        begin
          k := revpos('{', FullCell);
          if (k > 0) then
          begin
            CellContentString := copy(FullCell, 1, pred(k));
            result := split(copy(FullCell, succ(k), pred(l - k)),
              cLineSeparator);
            CellCommentString := result.Values[cCellFormat_Comment];
            break;
          end;
        end;
      result := nil;
      CellContentString := FullCell;
      CellCommentString := '';
    until yet;
  end;

var
  CellContent, CellComment: string;
  CellFormats: TStringList;
  f, c, r: integer;
  _SheetName: string;
{$ifdef fpc}
Zelle : PCell;
{$endif}
begin
  if not(assigned(wb)) then
  begin
    // Datei neu erstellen
    FileDelete(FName);
{$ifdef fpc}
    xlsAUSGABE := TsWorkbook.Create;
    with xlsAUSGABE do
    begin
      if (GetWorksheetCount=0) then
       AddWorkSheet('Tabelle1');
    end;
{$else}
    xlsAUSGABE := TXLSFile.Create(true);
    with xlsAUSGABE do
    begin
      NewFile(1, TExcelFileFormat.v2003);
    end;
{$endif}
  end
  else
  begin
    xlsAUSGABE := wb;
  end;

  AllTypes := TStringList.Create;
  for r := 0 to pred(xls_CellType_Count) do
    AllTypes.add(xls_CellTypes[r]);

{$ifdef fpc}
  with xlsAUSGABE.ActiveWorksheet do
{$else}
  with xlsAUSGABE do
{$endif}
  begin

    //
    {$ifdef fpc}
    // Es gibt das Zellformat mit einem Index
    // darin gibt es aber auch ein NumberFormat, auch mit einem Index
    InitFormatRecord(fmfm);
    with fmfm do
    begin
      // Font
      Include(UsedFormattingFields,uffFont);
      FontIndex := WorkBook.AddFont('Verdana',10,[],scBlack);

      // Border
      Include(fmfm.UsedFormattingFields, uffBorder);
      fmfm.BorderStyles := DEFAULT_BORDERSTYLES;
      fmfm.Border:= [cbEast];

    end;
    xlsFormatDefault := '';
    //fmt := Workbook.GetPointerToCellFormat(ACell^.FormatIndex);
    //numFmt := Workbook.GetNumberFormat(fmt^.NumberFormatIndex);
    {$else}
    // Alle Formate erzeugen, ableiten aus dem Standard-Format
    fmfm := GetDefaultFormat;
    xlsFormatDefault := fmfm.format;
    with fmfm do
    begin
      Font.name := 'Verdana';
      Font.Size20 := round(10.0 * 20);
      borders.Left.style := TFlxBorderStyle.Thin;
      borders.Left.color := clblack;
      FillPattern.Pattern := TFlxPatternStyle.Solid;
      FillPattern.BgColor := 0;
      VAlignment := TVFlxAlignment.top;
    end;
    {$endif}

    // Header Formate erzeugen
    fmHeader := EnsureFormat(xlsFormatDefault,
      HTMLColor2TColor(cExcel_HTML_Color_Header));
    {$ifdef fpc}
    fmfm2 := Workbook.GetCellFormat(fmHeader);
    fmfm2.Border := [cbEast, cbSouth];
    fmHeader := WorkBook.AddCellFormat(fmfm2);
    {$endif}
    fmHigh := EnsureFormat(xlsFormatDefault,
      HTMLColor2TColor(cExcel_HTML_Color_High), true);
    fmLow := EnsureFormat(xlsFormatDefault, cExcel_HTML_Color_Low, true);
    fmHigh_DateTime := EnsureFormat('dd/mm/yyyy\ hh:mm:ss',
      HTMLColor2TColor(cExcel_HTML_Color_High));
    fmLow_DateTime := EnsureFormat('dd/mm/yyyy\ hh:mm:ss',
      cExcel_HTML_Color_Low);
    fmHigh_Date := EnsureFormat('dd/mm/yyyy',
      HTMLColor2TColor(cExcel_HTML_Color_High));
    fmLow_Date := EnsureFormat('dd/mm/yyyy', cExcel_HTML_Color_Low);
    fmHigh_Time := EnsureFormat('hh:mm:ss',
      HTMLColor2TColor(cExcel_HTML_Color_High));
    fmLow_Time := EnsureFormat('hh:mm:ss', cExcel_HTML_Color_Low);
    fmHigh_Money := EnsureFormat('#,##0.00\ "€"',
      HTMLColor2TColor(cExcel_HTML_Color_High));
    fmLow_Money := EnsureFormat('#,##0.00\ "€"', cExcel_HTML_Color_Low);
    fmHigh_Text := EnsureFormat('@', HTMLColor2TColor(cExcel_HTML_Color_High));
    fmLow_Text := EnsureFormat('@', cExcel_HTML_Color_Low);

    // xls max columns limitation
    Columns := min(256, getLine(0).count);
    SetLength(xlsColumnWidth, Columns);
    SetLength(xlsFormatsLow, Columns);
    SetLength(xlsFormatsHigh, Columns);
    SetLength(xlsFormatsAll, Columns);

    // Header schreiben und Typen berechnen
    Subs := getLine(0);
    for c := 0 to pred(Columns) do
    begin

      CellFormats := cellsplit(Subs[c], CellContent, CellComment);

      f := fmHeader;
      if assigned(CellFormats) then
      begin
        f := fmModifier(f, CellFormats);
        CellFormats.Free;
      end
      else
        userWidth := 0;

      // Set Format, Value, Comment
      {$ifdef fpc}
      Zelle := WriteText(0, c, CellContent);
      WriteCellFormatIndex(Zelle,f);
      if (CellComment<>'') then
        WriteComment(0, c, CellComment);
      {$else}
      SetCellFromString(1, succ(c), CellContent, f);
      if (CellComment <> '') then
        SetComment(1, succ(c), CellComment);
      {$endif}

      if (userWidth = 0) then
{$ifdef fpc}
        xlsColumnWidth[c] := max(trunc(ReadDefaultColWidth (suChars)) , length(CellContent))
      else
        xlsColumnWidth[c] := userWidth;
{$else}
        xlsColumnWidth[c] := max(DefaultColWidth, length(CellContent) * cExcel_Pixel_Per_Char)
      else
        xlsColumnWidth[c] := userWidth * cExcel_Pixel_Per_Char;
{$endif}

      xlsFormatsAll[c] := hasType(c);

      //
      case xlsFormatsAll[c] of
        xls_CellType_Date:
          begin
            xlsFormatsLow[c] := fmLow_Date;
            xlsFormatsHigh[c] := fmHigh_Date;
          end;
        xls_CellType_DateTime:
          begin
            xlsFormatsLow[c] := fmLow_DateTime;
            xlsFormatsHigh[c] := fmHigh_DateTime;
          end;
        xls_CellType_Time:
          begin
            xlsFormatsLow[c] := fmLow_Time;
            xlsFormatsHigh[c] := fmHigh_Time;
          end;
        xls_CellType_Money:
          begin
            xlsFormatsLow[c] := fmLow_Money;
            xlsFormatsHigh[c] := fmHigh_Money;
          end;
        xls_CellType_Text:
          begin
            xlsFormatsLow[c] := fmLow_Text;
            xlsFormatsHigh[c] := fmHigh_Text;
          end;
      else
        xlsFormatsLow[c] := fmLow;
        xlsFormatsHigh[c] := fmHigh;
      end;

    end;

    // defaults
    HLM_Mode := HLM_byEvenOddHorizontal;

    if assigned(sOptions) then
    begin

      // Die Art des HiLighters bestimmen
      HLM_Col := Subs.indexof(sOptions.Values[cExcel_FarbSpalte]);
      if HLM_Col <> -1 then
        HLM_Mode := HLM_byCol;

      // Den Name des Sheets setzen
      _SheetName := sOptions.Values[cExcel_TabellenName];
      if (_SheetName <> '') then
{$ifdef fpc}
        Name := _SheetName;
{$else}
        SheetName := _SheetName;
{$endif}

    end;

    // Nun die echten Daten schreiben
    for r := 1 to pred(getCount) do
    begin
      Subs := getLine(r);
      for c := 0 to pred(Columns) do
      begin
         // unset?
         if (c>=Subs.count) then
          continue;

         // ???
         if (r=12) and (c=0) then
          if assigned(sOptions) then
           sOptions.values['x'] := '';

        // Wert,Kommentar,Formatierung bestimmen
        CellFormats := cellsplit(Subs[c], CellContent, CellComment);

        // Format ermitteln
        if isHigh(r, c) then
          f := xlsFormatsHigh[c]
        else
          f := xlsFormatsLow[c];

        // Format ggf. modifizieren
        if assigned(CellFormats) then
        begin
          f := fmModifier(f, CellFormats);
          CellFormats.Free;
        end;

        // Wert schreiben
        if (CellContent <> cOLAPnull) then
        begin
          try
            case xlsFormatsAll[c] of
              xls_CellType_ordinal:
                begin
{$ifdef fpc}
                 Zelle := WriteCellValueAsString(r, c, CellContent);
                 WriteCellFormatIndex(Zelle, f);
{$else}
                  SetCellFromString(succ(r), succ(c), CellContent, f);
{$endif}
                  CellCharCount := length(CellContent);
                end;
              xls_CellType_Date:
                begin
                  if (CellContent <> '') then
                  begin
                    {$ifdef fpc}
                    Zelle := WriteDateTime(r, c,
                      mkDateTime(
                         date2long(nextp(CellContent, ' ', 0)),
                         0));
                    {$else}
                    setCellValue(succ(r), succ(c),
                      double(mkDateTime(date2long(nextp(CellContent, ' ', 0)
                      ), 0)), f);
                    {$endif}
                    CellCharCount := 10;
                  end
                  else
                  begin
                    {$ifdef fpc}
                    Zelle := WriteBlank(r, c,true);
                    WriteCellFormatIndex(Zelle,f);
                    {$else}
                    setCellFormat(succ(r), succ(c), f);
                    {$endif}
                    CellCharCount := 0;
                  end;
                end;
              xls_CellType_DateTime:
                begin
                  if (CellContent <> '') then
                  begin
                    myCellValue := CellContent;
                    ersetze('-', ' ', myCellValue);
                    while (pos('  ', myCellValue) > 0) do
                      ersetze('  ', ' ', myCellValue);
                    {$ifdef fpc}
                    Zelle := WriteDateTime(r, c,
                      { } mkDateTime(
                      { } date2long(nextp(myCellValue, ' ', 0)),
                      { } strtoseconds(nextp(myCellValue, ' ', 1))));
                    WriteCellFormatIndex(Zelle,f);
                    {$else}
                    setCellValue(succ(r), succ(c),
                      { } double(
                      { } mkDateTime(
                      { } date2long(nextp(myCellValue, ' ', 0)),
                      { } strtoseconds(nextp(myCellValue, ' ', 1)))), f);
                    {$endif}
                    CellCharCount := 19;
                  end
                  else
                  begin
                    {$ifdef fpc}
                    Zelle := WriteBlank(r, c, true);
                    WriteCellFormatIndex(Zelle,f);
                    {$else}
                    setCellFormat(succ(r), succ(c), f);
                    {$endif}
                    CellCharCount := 0;
                  end;
                end;
              xls_CellType_Time:
                begin
                  if (CellContent <> '') then
                  begin
                    {$ifdef fpc}
                    Zelle := WriteDateTime(r, c,
                      { } mkDateTime(0, strtoseconds(CellContent)));
                    WriteCellFormatIndex(Zelle,f);
                    {$else}
                    setCellValue(succ(r), succ(c),
                      double(mkDateTime(0, strtoseconds(CellContent))), f);
                    {$endif}
                    CellCharCount := 8;
                  end
                  else
                  begin
                    {$ifdef fpc}
                    Zelle := WriteBlank(r, c, true);
                    WriteCellFormatIndex(Zelle,f);
                    {$else}
                    setCellFormat(succ(r), succ(c), f);
                    {$endif}
                    CellCharCount := 0;
                  end;
                end;
              xls_CellType_Money:
                begin
                  MoneyDouble := strtodoubledef(CellContent, 0);
                  {$ifdef fpc}
                  Zelle := WriteCurrency(r, c, MoneyDouble);
                  WriteCellFormatIndex(Zelle,f);
                  {$else}
                  setCellValue(succ(r), succ(c), MoneyDouble, f);
                  {$endif}
                  CellCharCount := length(format('%m', [MoneyDouble]));
                end;
              xls_CellType_double:
                begin
                  {$ifdef fpc}
                  Zelle := WriteNumber(r, c, strtodoubledef(CellContent, 0));
                  WriteCellFormatIndex(Zelle,f);
                  {$else}
                  setCellValue(succ(r), succ(c),
                    strtodoubledef(CellContent, 0), f);
                  {$endif}
                  CellCharCount := length(CellContent);
                end;
            else

              // Alle String Typen!
              myCellValue := CellContent;
              if (pos('"', myCellValue) = 1) then
                myCellValue := copy(myCellValue, 2, length(myCellValue) - 2);

              // maximale Länge der einzelnen Strings berechnen
              if (pos(cOLAPcsvLineBreak, myCellValue) > 0) then
              begin
                MultiLineCount := 0;
                CellCharCount := lengthMultiLine(myCellValue);
                ersetze(cOLAPcsvLineBreak, #10, myCellValue);
                {$ifdef fpc}
                Zelle := WriteText(r, c, myCellValue);
                WriteUsedFormatting(r, c, [uffWordwrap]);
                {$else}
                setCellValue(succ(r), succ(c), myCellValue, f);
                if (MultiLineCount > 1) then
                  setRowHeight(
                    { } succ(r),
                    { } max(
                    { } GetRowHeight(succ(r)),
                    { } DefaultRowHeight * MultiLineCount));
                {$endif}
              end
              else
              begin
                {$ifdef fpc}
                Zelle := WriteText(r, c, myCellValue);
                WriteCellFormatIndex(Zelle,f);
                {$else}
                setCellValue(succ(r), succ(c), myCellValue, f);
                {$endif}
                CellCharCount := length(myCellValue);
              end;

            end;
          except
            {$ifdef fpc}
            Zelle := WriteText(r, c, myCellValue);
            WriteCellFormatIndex(Zelle,f);
            {$else}
            setCellValue(succ(r), succ(c), CellContent, f);
            {$endif}
            CellCharCount := length(CellContent);
          end;
        end
        else
        begin
          // nur das Format setzen, aber kein Wert
          {$ifdef fpc}
          Zelle := WriteBlank(r, c, true);
          WriteCellFormatIndex(Zelle,f);
          {$else}
          setCellFormat(succ(r), succ(c), f);
          {$endif}
          CellCharCount := 0;
        end;

        // Kommentar noch schreiben
        if (CellComment <> '') then
          {$ifdef fpc}
          WriteComment(r, c, CellComment);
          {$else}
          SetComment(succ(r), succ(c), CellComment);
          {$endif}

        // Breite ermitteln, ggf. merken
{$ifdef fpc}
        xlsColumnWidth[c] := max(xlsColumnWidth[c], CellCharCount );
{$else}
        xlsColumnWidth[c] := max(xlsColumnWidth[c], CellCharCount * cExcel_Pixel_Per_Char);
{$endif}

      end;
    end;

    // Breite schreiben
    for c := 0 to high(xlsColumnWidth) do
      {$ifdef fpc}
      WriteColWidth(c, min(180,(xlsColumnWidth[c]*1000) DIV 750), suChars);
      {$else}
      SetColWidth(succ(c), min(65534, xlsColumnWidth[c]));
      {$endif}

    if not(assigned(wb)) then
    begin
      {$ifdef fpc}
      WorkBook.WriteToFile(FNAme,sfExcel8,true);
      {$else}
      Save(FName);
      {$endif}
    end;
  end;
  if not(assigned(wb)) then
    xlsAUSGABE.Free;
  AllTypes.Free;
end;

end.

