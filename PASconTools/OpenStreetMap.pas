{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2020  Andreas Filsinger
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
unit OpenStreetMap;

{$ifdef fpc}
{$mode delphi}
{$endif}

interface

uses
  classes;

const
  // OSM
  // ===
  //
  // https://tile.openstreetmap.org/$z/$x/$y.png';
  cOpenStreetMap_TileURL = 'https://b.tile.openstreetmap.de/$z/$x/$y.png';
  cOpenStreetMap_GeoURL = 'https://nominatim.openstreetmap.org/search?';

  // Google-Tile Server
  // ==================
  //
  // 'http://mt{s}.google.com/vt/v=w2.106&x={x}&y={y}&z={z}&s=
  // http://maps.google.com/maps/api/staticmap?parameters
  // mt1.google.com/vt/lyrs=m&x=1406&y=2143&zoom=-1
  // http://mt0.google.com/vt/x=2143&y=1406&zoom=5
  //    ('http://maps.google.com/maps/api/staticmap?center=%s,%s&zoom=%d&size=256x256&sensor=false',
  //    [FloatToStrISO(lat), FloatToStrISO(lon), tz]);
  cGoogle_TileURL = 'http://mt0.google.com/vt/x=$x&y=$y&zoom=$-z';


  // Allgemeines Tile System
  cTileSize = 256; // 256x256
  cTileSizeDiv2 = cTileSize div 2;

type
  TOpenStreetMapTile = class(TObject)
  public

    tx, ty, tz: integer; // Tile-Koordinates des 256x256 Kachel-Systems
    lat, lon: double; // Planet-Earth Koordinates in deg

    dx, dy: integer; // Pixel-Offset of the Center-Cross
    dlatpp, dlonpp: double; // Size of one single Pixel in deg

    clat, clon: double;

    procedure calcfromTile;
    procedure calcfromGPS;
    procedure calcfromZoom(xServerZoom: integer);

    class function RequestURL(Host:string; tx, ty, tz: integer):string;
  end;

implementation

uses
  anfix, SysUtils,  math;

procedure TOpenStreetMapTile.calcfromZoom(xServerZoom: integer);
const
  xServerZ: array [0 .. 18] of integer =
   (12000, 12000, 12000, 12000, 12000, 12000, 12000, 12000, 2800, 1500, 900, 300, 180, 100, 60, 40, 25, 10, 1);
  OpenStreetMapZ: array [0 .. 18] of integer =
   (    0,     1,     2,     3,     4,     5,     6,     7,    8,    9,  10,  11,  12,  13, 14, 15, 16, 17, 18);
var
  n: integer;
  _abs: integer;
  BestIndex: integer;
begin

  // Bestimme den naheliegensten Index
  BestIndex := -1;
  _abs := MaxInt;
  for n := Low(xServerZ) to High(xServerZ) do
    if Abs(xServerZoom - xServerZ[n]) < _abs then
    begin
      _abs := Abs(xServerZoom - xServerZ[n]);
      BestIndex := n;
    end;
  if (BestIndex = -1) then
    raise Exception.Create('OpenStreetMap.Zoom: Umrechnung nicht möglich');

  tz := OpenStreetMapZ[BestIndex];
end;

class function TOpenStreetMapTile.RequestURL(Host: string; tx, ty,
  tz: integer): string;
begin
  result := Host;
  ersetze('$x',inttostr(max(0,tx)),result);
  ersetze('$y',inttostr(max(0,ty)),result);
  ersetze('$z',inttostr(tz),result);
  ersetze('$-z',inttostr(17 - tz),result);
end;

{ tOpenStreetMap }

procedure TOpenStreetMapTile.calcfromGPS;
var
  n: double;
  NW, SE: TOpenStreetMapTile;
begin

  // $xtile = floor((($lon + 180) / 360) * pow(2, $zoom));
  // $ytile = floor((1 - log(tan(deg2rad($lat)) + 1 / cos(deg2rad($lat))) / pi()) /2 * pow(2, $zoom));
  n := Power(2, tz);
  tx := Floor((lon + 180) / 360 * n);
  ty := Floor((1 - ln(Tan(lat * Pi / 180) + 1 / Cos(lat * Pi / 180)) /
    Pi) / 2 * n);

  // die obere Linke Ecke bestimmen!
  NW := TOpenStreetMapTile.Create;
  NW.tz := tz;
  NW.tx := tx;
  NW.ty := ty;
  NW.calcfromTile;

  // die rechte untere Ecke bestimmen!
  SE := TOpenStreetMapTile.Create;
  SE.tz := tz;
  SE.tx := tx + 1;
  SE.ty := ty + 1;
  SE.calcfromTile;

  // Size of one single Pixel
  dlatpp := Abs(SE.lat - NW.lat) / cTileSize;
  dlonpp := Abs(SE.lon - NW.lon) / cTileSize;

  // Nun den aktuelle Abstand des Fadenkreuzes vom Mittelpunkt berechnen
  dx :=
  { } cTileSizeDiv2 -
  { } Floor(
    { } Abs(lon - NW.lon) /
    { } dlonpp);

  dy :=
  { } cTileSizeDiv2 -
  { } Floor(
    { } Abs(lat - NW.lat) /
    { } dlatpp);

  clon := lon + dx * dlonpp;
  clat := lat + dy * dlatpp;

  NW.Free;
  SE.Free;
end;

procedure TOpenStreetMapTile.calcfromTile;
var
  n, m: double;
begin
  // $n = pow(2, $zoom);
  // $lon_deg = $xtile / $n * 360.0 - 180.0;
  // $lat_deg = rad2deg(atan(sinh(pi() * (1 - 2 * $ytile / $n))));
  n := Power(2, tz);
  lon := tx / n * 360.0 - 180.0;
  m := Pi - 2.0 * Pi * ty / n;
  lat := 180.0 / Pi * ArcTan(0.5 * (exp(m) - exp(-m)));
end;


end.
