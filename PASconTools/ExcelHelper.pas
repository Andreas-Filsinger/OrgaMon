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
unit ExcelHelper;

interface

uses
  Classes
{$ifdef fpc}
  , fpspreadsheet
{$else}
  , UFlexCelImport
{$endif}
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

  xls_CellTypes: array [0 .. pred(xls_CellType_Count)] of string = ('STRING',
    'DATE', 'DATETIME', 'TIME', 'ORDINAL', 'DOUBLE', 'MONEY', 'AUTO', 'TEXT');

  cExcel_TabellenName = 'TabellenName';
  cExcel_FarbSpalte = 'FarbSpalte';

  //
  // TList of TStringList, eine TStringList=eine Zeile
  // eine Zelle = TStringList(TList[r])[c]
  // Headers (optional) die Titel TStringList
  // =nil: Titel ist Zeile 0
  //
  // Options:  SPALTENÜBERSCHRIFT=FELDTYP
  // Farbspalte=<SPALTENÜBERSCHRIFT>
  // TabellenName=<SheetName>

  {$ifdef fpc}

procedure ExcelExport(FName: string; Content: TList; Headers: TStringList = nil;
  Options: TStringList = nil; pXLS: TsWorkbook = nil);
    {$else}
procedure ExcelExport(FName: string; Content: TList; Headers: TStringList = nil;
  Options: TStringList = nil; pXLS: TFlexCelImport = nil);
    {$endif}
procedure CSVExport(FName: string; Content: TList);
procedure CSVImport(FName: string; Content: TList);

implementation

{$ifdef fpc}

procedure ExcelExport(FName: string; Content: TList; Headers: TStringList = nil;
  Options: TStringList = nil; pXLS: TsWorkbook = nil);
begin

end;

procedure CSVExport(FName: string; Content: TList);
begin

end;

procedure CSVImport(FName: string; Content: TList);
begin

end;


end.
{$else}

uses
  UExcelAdapter, XLSAdapter,
  html, UFlxFormats, anfix32,
  math, globals, SysUtils,
  graphics;

procedure ExcelExport(FName: string; Content: TList; Headers: TStringList = nil;
  Options: TStringList = nil; pXLS: TFlexCelImport = nil);
var
  xlsAUSGABE: TFlexCelImport;
  xlsMACHINE: TXLSAdapter;
  xlsFormatDefault: string;
  ColCount: integer;
  AllTypes: TStringList;
  CellCharCount: integer;
  MoneyDouble: double;

  xlsColumnWidth: array of integer;
  xlsFormatsLow: array of integer;
  xlsFormatsHigh: array of integer;
  xlsFormats: array of integer;

  fmfm: TFlxFormat;
  Subs: TStringList;
  myCellValue: string;
  fmCharsWidth: integer;

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

  function EnsureFormat(FormatString: string; CellColor: TColor;
    MultiLine: boolean = false): integer;
  begin
    with fmfm do
    begin
      format := FormatString;
      fmfm.FillPattern.FgColorIndex := xlsAUSGABE.NearestColorIndex(CellColor);
      fmfm.WrapText := MultiLine;
    end;
    result := xlsAUSGABE.addformat(fmfm);
  end;

  function fmSetColor(fmIndex: integer; CellColor: TColor): integer;
  begin
    xlsAUSGABE.GetFormatList(fmIndex, fmfm);
    fmfm.FillPattern.FgColorIndex := xlsAUSGABE.NearestColorIndex(CellColor);
    result := xlsAUSGABE.addformat(fmfm);
  end;

  function fmSetOrientationVertikal(fmIndex: integer): integer;
  begin
    xlsAUSGABE.GetFormatList(fmIndex, fmfm);
    fmfm.Rotation := 90;
    result := xlsAUSGABE.addformat(fmfm);
  end;

  function fmSetAlignment(fmIndex: integer): integer;
  begin
    xlsAUSGABE.GetFormatList(fmIndex, fmfm);
    fmfm.HAlignment := fha_center;
    fmfm.VAlignment := fva_center;
    result := xlsAUSGABE.addformat(fmfm);
  end;

// Nebeneffekt: Setzt den Kommentar
//
  function fmModifier(fmIndex: integer; sFormats: TStringList): integer;
  var
    p: string;
  begin
    result := fmIndex;

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
    p := sFormats.Values[cCellFormat_TextDirection];
    if (p = 'JA') then
      result := fmSetOrientationVertikal(result);
    p := sFormats.Values[cCellFormat_CellCenter];
    if (p = 'JA') then
      result := fmSetAlignment(result);
    p := sFormats.Values[cCellFormat_CellWidth];
    fmCharsWidth := strtointdef(p, 0);

  end;

  function hasType(c: integer): integer;
  var
    s: string;
  begin

    // Datentyp ev. schon erzwungen?!
    if assigned(Options) then
      result := AllTypes.indexof(Options.Values[getLine(0)[c]])
    else
      result := -1;

    if (result = -1) then
    begin
      if (getCount > 1) then
        s := getLine(1)[c]
      else
        s := '';

      repeat

        // Monetäres Format?!
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
          if (s[3] = '.') and (s[6] = '.') and
            (s = StrFilter(s, '0123456789.')) then
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

        // Ganzzahl
        if length(s) > 0 then
          if (s[1] >= '0') and (s[1] <= '9') then
            if s = StrFilter(s, '0123456789') then
            begin
              result := xls_CellType_ordinal;
              break;
            end;

        // als String!
        result := xls_CellType_String;

      until true;

    end;
  end;

  function _length(MultiLine: string): integer;
  begin
    result := 0;
    while (MultiLine <> '') do
      result := max(result, length(nextp(MultiLine, cOLAPcsvLineBreak)));
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
            result := split(copy(FullCell, succ(k), pred(l - k)), '|');
            CellCommentString := result.Values[cCellFormat_Comment];
            break;
          end;
        end;
      result := nil;
      CellContentString := FullCell;
      CellCommentString := '';
    until true;
  end;

var
  CellContent, CellComment: string;
  CellFormats: TStringList;
  f, c, r: integer;

begin
  if not(assigned(pXLS)) then
  begin
    // Datei neu erstellen
    FileDelete(FName);
    xlsMACHINE := TXLSAdapter.create(nil);
    xlsAUSGABE := TFlexCelImport.create(nil);
    with xlsAUSGABE do
    begin
      adapter := xlsMACHINE;
      NewFile(1);
    end;
  end
  else
  begin
    xlsAUSGABE := pXLS;
  end;

  AllTypes := TStringList.create;
  for r := 0 to pred(xls_CellType_Count) do
    AllTypes.add(xls_CellTypes[r]);

  with xlsAUSGABE do
  begin

    // Alle Formate erzeugen, ableiten aus dem Standard-Format
    GetDefaultFormat(fmfm);
    xlsFormatDefault := fmfm.format;
    with fmfm do
    begin
      Font.name := 'Verdana';
      Font.Size20 := round(10.0 * 20);
      borders.Left.style := fbs_Thin;
      borders.Left.colorIndex := NearestColorIndex(clblack);
      FillPattern.Pattern := 2;
      FillPattern.BgColorIndex := 0;
      VAlignment := fva_top;
    end;

    // Header Formate erzeugen
    fmHeader := EnsureFormat(xlsFormatDefault,
      HTMLColor2TColor(cExcel_HTML_Color_Header));
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

    //
    ColCount := getLine(0).count;

    SetLength(xlsColumnWidth, ColCount);
    SetLength(xlsFormatsLow, ColCount);
    SetLength(xlsFormatsHigh, ColCount);
    SetLength(xlsFormats, ColCount);

    // Header schreiben und Typen berechnen
    Subs := getLine(0);
    for c := 0 to pred(ColCount) do
    begin

      CellFormats := cellsplit(Subs[c], CellContent, CellComment);

      f := fmHeader;
      if assigned(CellFormats) then
      begin
        f := fmModifier(f, CellFormats);
        CellFormats.Free;
      end
      else
        fmCharsWidth := 0;

      CellValue[1, succ(c)] := CellContent;
      CellFormat[1, succ(c)] := f;

      if (CellComment <> '') then
        SetCellComment(1, succ(c), CellComment);

      if (fmCharsWidth = 0) then
        xlsColumnWidth[c] := max(DefaultColWidth, length(CellContent) *
          cExcel_Pixel_Per_Char)
      else
        xlsColumnWidth[c] := fmCharsWidth * cExcel_Pixel_Per_Char;

      xlsFormats[c] := hasType(c);

      //
      case xlsFormats[c] of
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

    if assigned(Options) then
    begin

      // Die Art des High-Liters bestimmen
      HLM_Col := Subs.indexof(Options.Values[cExcel_FarbSpalte]);
      if HLM_Col <> -1 then
        HLM_Mode := HLM_byCol;

      // Den Name des Sheets bestimmen
      if (Options.Values[cExcel_TabellenName] <> '') then
        ActiveSheetName := Options.Values[cExcel_TabellenName];

    end;

    // Nun die echten Daten schreiben
    for r := 1 to pred(getCount) do
    begin
      Subs := getLine(r);
      for c := 0 to pred(Subs.count) do
      begin

        CellFormats := cellsplit(Subs[c], CellContent, CellComment);

        // Wert schreiben
        if (CellContent <> cOLAPnull) then
        begin
          try
            case xlsFormats[c] of
              xls_CellType_ordinal:
                begin
                  SetCellString(succ(r), succ(c), CellContent);
                  CellCharCount := length(CellContent);
                end;
              xls_CellType_Date:
                begin
                  if (CellContent <> '') then
                  begin
                    CellValue[succ(r), succ(c)] :=
                      double(mkDateTime(date2long(nextp(CellContent,
                      ' ', 0)), 0));
                    CellCharCount := 10;
                  end
                  else
                  begin
                    CellValue[succ(r), succ(c)] := '';
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
                    CellValue[succ(r), succ(c)] :=
                      double(mkDateTime(date2long(nextp(myCellValue, ' ', 0)),
                      strtoseconds(nextp(myCellValue, ' ', 1))));
                    CellCharCount := 19;
                  end
                  else
                  begin
                    CellValue[succ(r), succ(c)] := '';
                    CellCharCount := 0;
                  end;
                end;
              xls_CellType_Time:
                begin
                  if (CellContent <> '') then
                  begin
                    CellValue[succ(r), succ(c)] :=
                      double(mkDateTime(0, strtoseconds(CellContent)));
                    CellCharCount := 8;
                  end
                  else
                  begin
                    CellValue[succ(r), succ(c)] := '';
                    CellCharCount := 0;
                  end;
                end;
              xls_CellType_Money:
                begin
                  MoneyDouble := strtodoubledef(CellContent, 0);
                  CellValue[succ(r), succ(c)] := MoneyDouble;
                  CellCharCount := length(format('%m', [MoneyDouble]));
                end;
              xls_CellType_double:
                begin
                  CellValue[succ(r), succ(c)] := strtodoubledef(CellContent, 0);
                  CellCharCount := length(CellContent);
                end;
            else
              // String Typen!
              myCellValue := CellContent;
              if (pos('"', myCellValue) = 1) then
                myCellValue := copy(myCellValue, 2, length(myCellValue) - 2);

              // maximale Länge der einzelnen Strings berechnen
              CellCharCount := _length(myCellValue);
              ersetze(cOLAPcsvLineBreak, #10, myCellValue);
              CellValue[succ(r), succ(c)] := myCellValue;

            end;
          except
            CellValue[succ(r), succ(c)] := CellContent;
            CellCharCount := length(CellContent);
          end;
        end
        else
        begin
          CellCharCount := 0;
        end;

        // Format schreiben
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

        CellFormat[succ(r), succ(c)] := f;

        if (CellComment <> '') then
          SetCellComment(succ(r), succ(c), CellComment);

        // Breite schreiben
        xlsColumnWidth[c] := max(xlsColumnWidth[c],
          CellCharCount * cExcel_Pixel_Per_Char);

      end;
    end;
    for c := 0 to high(xlsColumnWidth) do
      ColumnWidth[succ(c)] := min(65534, xlsColumnWidth[c]);
    if not(assigned(pXLS)) then
    begin
      Save(FName);
      adapter := nil;
    end;
  end;
  if not(assigned(pXLS)) then
  begin
    xlsMACHINE.Free;
    xlsAUSGABE.Free;
  end;
  AllTypes.Free;
end;

procedure CSVExport(FName: string; Content: TList);
var
  m: integer;
  JoinL: TStringList;
begin
  // fertig -> rausspeichern
  JoinL := TStringList.create;
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
  Content.add(TStringList.create);
  JoinL := TStringList.create;
  LoadFromFileCSV(true, JoinL, FName);
  ThisHeader := JoinL[0];
  while (ThisHeader <> '') do
    TStringList(Content[0]).add(nextp(ThisHeader, cOLAPcsvSeparator));
  ColCount := TStringList(Content[0]).count;
  for n := 1 to pred(JoinL.count) do
  begin
    ThisLine := JoinL[n];
    Cols := TStringList.create;
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

end.
{$endif}

