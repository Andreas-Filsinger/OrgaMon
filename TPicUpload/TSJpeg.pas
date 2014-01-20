unit TSJpeg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TSResample, Math;

function JPEGDimensions(Filename: string; var X, Y: Word): boolean;
function ResizeImage(FilePath, ResizedPath, Filename: string;
  MaxWidth: Integer; ShortEdge: boolean): integer;

implementation

{

  Before importing an image (jpg) into a database,
  I would like to resize it (reduce its size) and
  generate the corresponding smaller file. How can I do this?


  Load the JPEG into a bitmap, create a new bitmap
  of the size that you want and pass them both into
  SmoothResize then save it again ...
  there's a neat routine JPEGDimensions that
  gets the JPEG dimensions without actually loading the JPEG into a bitmap,
  saves loads of time if you only need to test its size before resizing.
}

uses
  JPEG;

type
  TRGBArray = array [Word] of TRGBTriple;
  pRGBArray = ^TRGBArray;

  { ---------------------------------------------------------------------------
    ----------------------- }

procedure SmoothResize(Src, Dst: TBitmap);
var
  X, Y: Integer;
  xP, yP: Integer;
  xP2, yP2: Integer;
  SrcLine1, SrcLine2: pRGBArray;
  t3: Integer;
  z, z2, iz2: Integer;
  DstLine: pRGBArray;
  DstGap: Integer;
  w1, w2, w3, w4: Integer;
begin
  Src.PixelFormat := pf24Bit;
  Dst.PixelFormat := pf24Bit;

  if (Src.Width = Dst.Width) and (Src.Height = Dst.Height) then
    Dst.Assign(Src)
  else
  begin
    DstLine := Dst.ScanLine[0];
    DstGap := Integer(Dst.ScanLine[1]) - Integer(DstLine);

    xP2 := MulDiv(pred(Src.Width), $10000, Dst.Width);
    yP2 := MulDiv(pred(Src.Height), $10000, Dst.Height);
    yP := 0;

    for Y := 0 to pred(Dst.Height) do
    begin
      xP := 0;

      SrcLine1 := Src.ScanLine[yP shr 16];

      if (yP shr 16 < pred(Src.Height)) then
        SrcLine2 := Src.ScanLine[succ(yP shr 16)]
      else
        SrcLine2 := Src.ScanLine[yP shr 16];

      z2 := succ(yP and $FFFF);
      iz2 := succ((not yP) and $FFFF);
      for X := 0 to pred(Dst.Width) do
      begin
        t3 := xP shr 16;
        z := xP and $FFFF;
        w2 := MulDiv(z, iz2, $10000);
        w1 := iz2 - w2;
        w4 := MulDiv(z, z2, $10000);
        w3 := z2 - w4;
        DstLine[X].rgbtRed :=
          (SrcLine1[t3].rgbtRed * w1 + SrcLine1[t3 + 1].rgbtRed * w2 +
          SrcLine2[t3].rgbtRed * w3 + SrcLine2[t3 + 1].rgbtRed * w4) shr 16;
        DstLine[X].rgbtGreen :=
          (SrcLine1[t3].rgbtGreen * w1 + SrcLine1[t3 + 1].rgbtGreen * w2 +

          SrcLine2[t3].rgbtGreen * w3 + SrcLine2[t3 + 1].rgbtGreen * w4) shr 16;
        DstLine[X].rgbtBlue :=
          (SrcLine1[t3].rgbtBlue * w1 + SrcLine1[t3 + 1].rgbtBlue * w2 +
          SrcLine2[t3].rgbtBlue * w3 + SrcLine2[t3 + 1].rgbtBlue * w4) shr 16;
        Inc(xP, xP2);
      end; { for }
      Inc(yP, yP2);
      DstLine := pRGBArray(Integer(DstLine) + DstGap);
    end; { for }
  end; { if }
end; { SmoothResize }

{ ---------------------------------------------------------------------------
  ----------------------- }

function LoadJPEGPictureFile(Bitmap: TBitmap;
  FilePath, Filename: string): boolean;
var
  JPEGImage: TJPEGImage;
begin
  if (Filename = '') then // No FileName so nothing
    Result := False // to load - return False...
  else
  begin
    //try // Start of try except
      JPEGImage := TJPEGImage.Create; // Create the JPEG image... try  // now
      try // to load the file but
        JPEGImage.LoadFromFile(FilePath + Filename);
        // might fail...with an Exception.
        Bitmap.Assign(JPEGImage);
        // Assign the image to our bitmap.Result := True;
        // Got it so return True.
        //finally
        //JPEGImage.Free; // ...must get rid of the JPEG image. finally
        Result := True;
      except
        Result := False;
      end; { try }
    //finally
      JPEGImage.Free;
    //end; { try }
  end; { if }
end; { LoadJPEGPictureFile }

{ ---------------------------------------------------------------------------
  ----------------------- }

function SaveJPEGPictureFile(Bitmap: TBitmap; FilePath, Filename: string;
  Quality: Integer): boolean;
begin
  Result := True;
  try
    if ForceDirectories(FilePath) then
    begin
      with TJPEGImage.Create do
      begin
        try
          Assign(Bitmap);
          CompressionQuality := Quality;
          SaveToFile(FilePath + Filename);
        finally
          Free;
        end; { try }
      end; { with }
    end; { if }
  except
    raise;
    Result := False;
  end; { try }
end; { SaveJPEGPictureFile }

{ ---------------------------------------------------------------------------
  ----------------------- }

function ResizeImage(FilePath, ResizedPath, Filename: string;
  MaxWidth: Integer; ShortEdge: boolean): integer;
{ Rückgabewerte:
   0 = Verkleinerte Version existiert schon
   1 = Verkleinerung erfolgreich
  -1 = Quelldatei konnte nicht geladen werden
}
var
  OldBitmap: TBitmap;
  NewBitmap: TBitmap;
begin
  Result := 0;
  { if not FileExists(ResizedPath + Filename) then }
  if (FileAge(ResizedPath + Filename) < FileAge(FilePath + Filename)) then
  begin
    OldBitmap := TBitmap.Create;
    try
      if LoadJPEGPictureFile(OldBitmap, FilePath, Filename) then
      begin
        // muss resampled werden ?
        if (not ShortEdge and //die längere Seite soll auf MaxWidth verkleinert werden
           (Max(OldBitmap.Width, OldBitmap.Height) > MaxWidth)) //ist die längere Seite (MAX) größer als MaxWidth?
            or
           (ShortEdge and //die kürzere Seite soll auf MaxWidth verkleinert werden
           (Min(OldBitmap.Width, OldBitmap.Height) > MaxWidth)) //ist die kürzere Seite (MIN) größer als MaxWidth?
        then
        begin
          NewBitmap := TBitmap.Create;
          try

            repeat

              if (not ShortEdge and (OldBitmap.Width > OldBitmap.Height)) or
              // hat Querformat & die lange Seite soll auf MaxWidth verkleinert werden
                (ShortEdge and (OldBitmap.Height > OldBitmap.Width)) then
              // hat Hochformat & die kurze Seite soll auf MaxWidth verkleinert werden
              // -> in beiden Fällen muss die BREITE bearbeitet werden
              begin
                // auf die passende Breite verkleinern
                NewBitmap.Width := MaxWidth;
                NewBitmap.Height := MulDiv(MaxWidth, OldBitmap.Height,
                  OldBitmap.Width);
                break;
              end;

              if (not ShortEdge and (OldBitmap.Height > OldBitmap.Width)) or
              // hat Hochformat & die lange Seite soll auf MaxWidth verkleinert werden
                (ShortEdge and (OldBitmap.Width > OldBitmap.Height)) then
              // hat Querformat & die kurze Seite soll auf MaxWidth verkleinert werden
              // -> in beiden Fällen muss die HÖHE bearbeitet werden
              begin
                // auf die passende Höhe der Bilder verkleinern
                // AF: Sinn verstehe ich nicht!
                // TS: Bei allen Bildern soll die kurze Seite gleich lang sein.
                //     Wenn man z.B. quadratische Ausschnitte dieser Bilder als Thumbnails anzeigen möchte,
                //     ist die Kantenlänge der Quadrate gleich die der kurzen Seite.
                //     Sollen alle Quadrate gleich groß sein, müssen die kurzen Seiten der Bilder gleich sein.
                NewBitmap.Height := MaxWidth;
                NewBitmap.Width := MulDiv(MaxWidth, OldBitmap.Width,
                  OldBitmap.Height);
                break;
              end;

              // Völlig Quadratische Bilder
              NewBitmap.Width := MaxWidth;
              NewBitmap.Height := MulDiv(MaxWidth, OldBitmap.Height,
                OldBitmap.Width);

            until True;

            // SmoothResize(OldBitmap, NewBitmap);
            Resample(OldBitmap, NewBitmap, MitchellFilter, 2.0);
            // RenameFile(FileName, ChangeFileExt(FileName, '.$$$'));
            if SaveJPEGPictureFile(NewBitmap, ResizedPath, Filename, 85) then
            begin
              // DeleteFile(ChangeFileExt(FileName, '.$$$'))
              Result := 1;
            end
            else
              RenameFile(ChangeFileExt(Filename, '.$$$'), Filename);
          finally
            NewBitmap.Free;
          end; { try }
        end { if }
        else
          SaveJPEGPictureFile(OldBitmap, ResizedPath, Filename, 85);
      end { if }
      else Result := -1;
    finally
      OldBitmap.Free;
    end; { try }
  end;
end;

{ ---------------------------------------------------------------------------
  ----------------------- }

function JPEGDimensions(Filename: string; var X, Y: Word): boolean;
var
  SegmentPos: Integer;
  SOIcount: Integer;
  b: byte;
begin
  Result := False;
  with TFileStream.Create(Filename, fmOpenRead or fmShareDenyNone) do
  begin
    try
      Position := 0;
      Read(X, 2);
      if (X <> $D8FF) then
        exit;
      SOIcount := 0;
      Position := 0;
      while (Position + 7 < Size) do
      begin
        Read(b, 1);
        if (b = $FF) then
        begin
          Read(b, 1);
          if (b = $D8) then
            Inc(SOIcount);
          if (b = $DA) then
            break;
        end; { if }
      end; { while }
      if (b <> $DA) then
        exit;
      SegmentPos := -1;
      Position := 0;
      while (Position + 7 < Size) do
      begin
        Read(b, 1);
        if (b = $FF) then
        begin
          Read(b, 1);
          if (b in [$C0, $C1, $C2]) then
          begin
            SegmentPos := Position;
            dec(SOIcount);
            if (SOIcount = 0) then
              break;
          end; { if }
        end; { if }
      end; { while }
      if (SegmentPos = -1) then
        exit;
      if (Position + 7 > Size) then
        exit;
      Position := SegmentPos + 3;
      Read(Y, 2);
      Read(X, 2);
      X := Swap(X);
      Y := Swap(Y);
      Result := True;
    finally
      Free;
    end; { try }
  end; { with }
end; { JPEGDimensions }

end.
