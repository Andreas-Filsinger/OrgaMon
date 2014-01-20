unit TSResample;

interface

uses
  SysUtils, Classes, Graphics;

type
  TFilterProc = function(value: single): single;

function HermiteFilter(value: single): single;
function BellFilter(value: single): single;
function SplineFilter(value: single): single;
function Lanczos3Filter(value: single): single;
function MitchellFilter(value: single): single;
procedure Resample(Src, Dst: TBitmap; Filter: TFilterProc; FilterWidth: single);

implementation

uses Math;

function HermiteFilter(value: single): single;
begin
  // f(t) = 2|t|^3 - 3|t|^2 + 1, -1 <= t <= 1
  if (value < 1.0) then Result := (2.0 * value - 3.0) * Sqr(value) + 1.0
  else Result := 0.0;
end;

function BellFilter(value: single): single;
begin
  if (value < 0.5) then Result := 0.75 - Sqr(value)
  else if (value < 1.5) then
  begin
    value := value - 1.5;
    Result := 0.5 * Sqr(value);
  end else
    Result := 0.0;
end;

function SplineFilter(value: single): single;
begin
  if (value < 1.0) then Result := 0.5 * power(value,3) - sqr(value) + (2.0/3.0)
  else if (value < 2.0) then Result := (1.0/6.0) * power((value-2),3)
  else Result := 0.0;
end;

function Lanczos3Filter(value: single): single;
  function SinC(value: single): single;
  begin
    if (value <> 0.0) then
    begin
      value := value * Pi;
      Result := sin(value) / value
    end else
      Result := 1.0;
  end;
begin
  if (value < 3.0) then Result := SinC(value) * SinC(value / 3.0)
  else Result := 0.0;
end;

function MitchellFilter(value: single): single;
const
  B		= (1.0 / 3.0);
  C		= (1.0 / 3.0);
var
  tt: single;
begin
  tt := Sqr(value);
  if (value < 1.0) then
  begin
    value := (((12.0 - 9.0 * B - 6.0 * C) * (value * tt))
      + ((-18.0 + 12.0 * B + 6.0 * C) * tt)
      + (6.0 - 2 * B));
    Result := value / 6.0;
  end else
  if (value < 2.0) then
  begin
    value := (((-1.0 * B - 6.0 * C) * (value * tt))
      + ((6.0 * B + 30.0 * C) * tt)
      + ((-12.0 * B - 48.0 * C) * value)
      + (8.0 * B + 24 * C));
    Result := value / 6.0;
  end else
    Result := 0.0;
end;



type
  TContributor = record
    pixel : integer;
    weight : single;
  end;

  TContributorList = array[0..0] of TContributor;
  PContributorList = ^TContributorList;

  TCList = record
    n		: integer;
    p		: PContributorList;
  end;

  TCListList = array[0..0] of TCList;
  PCListList = ^TCListList;

  TRGB = packed record
    r, g, b	: single;
  end;

  TColorRGB = packed record
    r, g, b	: BYTE;
  end;
  PColorRGB = ^TColorRGB;

  TRGBList = packed array[0..0] of TColorRGB;
  PRGBList = ^TRGBList;

procedure Resample(Src, Dst: TBitmap; Filter: TFilterProc; FilterWidth: single);
var
  xscale, yscale	: single;	
  i, j, k		: integer;
  center		: single;
  width, fscale, weight	: single;
  left, right		: integer;
  n			: integer;
  Work			: TBitmap;
  contrib		: PCListList;
  rgb			: TRGB;
  color			: TColorRGB;
  SourceLine, DestLine 	: PRGBList;
  SourcePixel, DestPixel: PColorRGB;
  Delta, DestDelta	: integer;
  SrcWidth, SrcHeight, DstWidth, DstHeight: integer;

  function Color2RGB(Color: TColor): TColorRGB;
  begin
    Result.r := Color AND $000000FF;
    Result.g := (Color AND $0000FF00) SHR 8;
    Result.b := (Color AND $00FF0000) SHR 16;
  end;

  function RGB2Color(Color: TColorRGB): TColor;
  begin
    Result := Color.r OR (Color.g SHL 8) OR (Color.b SHL 16);
  end;

  function GetIntegerColorvalue(value: single): integer;
  begin
    if (value > 255.0) then Result := 255
    else if (value < 0.0) then Result := 0
    else Result := round(value);
  end;

begin
  DstWidth := Dst.Width;
  DstHeight := Dst.Height;
  SrcWidth := Src.Width;
  SrcHeight := Src.Height;
  if (SrcWidth < 1) or (SrcHeight < 1) then raise Exception.Create('Ausgangsbild zu klein !');

  Work := TBitmap.Create;
  try
    Work.Height := SrcHeight;
    Work.Width := DstWidth;
    // xscale := DstWidth / SrcWidth;
    // yscale := DstHeight / SrcHeight;
    // Improvement suggested by David Ullrich:
    if (SrcWidth = 1) then xscale:= DstWidth / SrcWidth
    else xscale:= (DstWidth - 1) / (SrcWidth - 1);
    if (SrcHeight = 1) then yscale:= DstHeight / SrcHeight
    else yscale := (DstHeight - 1) / (SrcHeight - 1);

    Src.PixelFormat := pf24bit;
    Dst.PixelFormat := Src.PixelFormat;
    Work.PixelFormat := Src.PixelFormat;


    // VORBERECHNUNGEN FÜR HORIZONTALES RESAMPLING
    GetMem(contrib, DstWidth* sizeof(TCList));

    //if (xscale < 1.0) then
    //begin
      width := FilterWidth / xscale;
      fscale := 1.0 / xscale;
      for i := 0 to DstWidth-1 do
      begin
        contrib^[i].n := 0;
        GetMem(contrib^[i].p, trunc(width * 2.0 + 1) * sizeof(TContributor));
        center := i / xscale;
        // Original code:
        // left := ceil(center - width);
        // right := floor(center + width);
        left := floor(center - width);
        right := ceil(center + width);
        for j := left to right do
        begin
          weight := Filter(abs(center - j) / fscale) / fscale;
          if (weight = 0.0) then continue;
          if (j < 0) then n := -j
          else if (j >= SrcWidth) then n := SrcWidth - j + SrcWidth - 1
          else n := j;
          k := contrib^[i].n;
          contrib^[i].n := contrib^[i].n + 1;
          contrib^[i].p^[k].pixel := n;
          contrib^[i].p^[k].weight := weight;
        end;
      end;
    //end;
                                                        
    // HORIZONTALES RESAMPLING
    for k := 0 to SrcHeight-1 do
    begin
      SourceLine := Src.ScanLine[k];
      DestPixel := Work.ScanLine[k];
      for i := 0 to DstWidth-1 do
      begin
        rgb.r := 0.0;
        rgb.g := 0.0;
        rgb.b := 0.0;
        for j := 0 to contrib^[i].n-1 do
        begin
          color := SourceLine^[contrib^[i].p^[j].pixel];
          weight := contrib^[i].p^[j].weight;
          if (weight = 0.0) then
            continue;
          rgb.r := rgb.r + color.r * weight;
          rgb.g := rgb.g + color.g * weight;
          rgb.b := rgb.b + color.b * weight;
        end;

        color.r := GetIntegerColorValue(rgb.r);
        color.g := GetIntegerColorValue(rgb.g);
        color.b := GetIntegerColorValue(rgb.b);

        DestPixel^ := color;
        inc(DestPixel);

      end;
    end;

    for i := 0 to DstWidth-1 do FreeMem(contrib^[i].p);
    FreeMem(contrib);

    // VORBERECHNUNGEN FÜR VERTIKALES RESAMPLING
    GetMem(contrib, DstHeight* sizeof(TCList));
    //if (yscale < 1.0) then
    //begin
      width := FilterWidth / yscale;
      fscale := 1.0 / yscale;
      for i := 0 to DstHeight-1 do
      begin
        contrib^[i].n := 0;
        GetMem(contrib^[i].p, trunc(width * 2.0 + 1) * sizeof(TContributor));
        center := i / yscale;
        // Original code:
        // left := ceil(center - width);
        // right := floor(center + width);
        left := floor(center - width);
        right := ceil(center + width);
        for j := left to right do
        begin
          weight := Filter(abs(center - j) / fscale) / fscale;
          if (weight = 0.0) then continue;
          if (j < 0) then n := -j
          else if (j >= SrcHeight) then n := SrcHeight - j + SrcHeight - 1
          else n := j;
          k := contrib^[i].n;
          contrib^[i].n := contrib^[i].n + 1;
          contrib^[i].p^[k].pixel := n;
          contrib^[i].p^[k].weight := weight;
        end;
      end;
    //end;

    // VERTIKALES RESAMPLING
    SourceLine := Work.ScanLine[0];
    Delta := integer(Work.ScanLine[1]) - integer(SourceLine);
    DestLine := Dst.ScanLine[0];
    DestDelta := integer(Dst.ScanLine[1]) - integer(DestLine);

    for k := 0 to DstWidth-1 do
    begin
      DestPixel := pointer(DestLine);
      for i := 0 to DstHeight-1 do
      begin
        rgb.r := 0;
        rgb.g := 0;
        rgb.b := 0;
        // weight := 0.0;
        for j := 0 to contrib^[i].n-1 do
        begin
          color := PColorRGB(integer(SourceLine)+contrib^[i].p^[j].pixel*Delta)^;
          weight := contrib^[i].p^[j].weight;
          if (weight = 0.0) then Continue;
          rgb.r := rgb.r + color.r * weight;
          rgb.g := rgb.g + color.g * weight;
          rgb.b := rgb.b + color.b * weight;
        end;

        color.r := GetIntegerColorValue(rgb.r);
        color.g := GetIntegerColorValue(rgb.g);
        color.b := GetIntegerColorValue(rgb.b);

        DestPixel^ := color;
        inc(integer(DestPixel), DestDelta);
      end;
      Inc(SourceLine, 1);
      Inc(DestLine, 1);
    end;

    for i := 0 to DstHeight-1 do FreeMem(contrib^[i].p);
    FreeMem(contrib);
    
  finally
    Work.Free;
  end;
end;

end.
