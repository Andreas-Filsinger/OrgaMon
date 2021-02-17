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
unit GeoCache;

interface

uses
  Classes, graphics, windows,
  gplists, FastGeo, globals,
  WordIndex, PNGImage;

const
  // Dimensionen von Deutschland als Plausibilitätsprüfung.
  cxN = 5.8;
  cyN = 47.2;
  cxL = 9.1;
  cyL = 7.9;
  cGEODEZIMAL_Faktor = 100000.0;

  // Konstanten für das Aussehen
  cPunkt_blau = 0;
  cPunkt_gelb = 1;
  cPunkt_glass = 2;
  cPunkt_grau = 3;
  cPunkt_gruen = 4;
  cPunkt_lila = 5;
  cPunkt_mint = 6;
  cPunkt_rot = 7;
  cPunkt_schwarz = 8;
  cPunkt_weiss = 9;

type
  TGeoPoint = record
    gP: TPoint2D; // reale Punktkoordinaten
    gRID: integer; // Auftragsreferenz
    gSichtbar: boolean; // Sichtbar JA/NEIN
                        // nicht sichtbar sind insbesondere doppelte Punkte.
                        // also Zähler in der gleichen Strasse.
    gPlanbar: boolean; // Berührbar beim Planen JA/NEIN
    gEbene: integer; // Aktuelle Zeichen-Ebene 0=ganz unten!
                     // Bitte wenig Ebenen eng beisammen!
                     // Siehe Zeichenroutine!
    gAussehen: integer; // Mapping Index für Farb-Aussehen "cPunkt_"
  end;

  TGeoCache = class(TObject)
  private
    MaxEbene: integer;
    BlinkIntervall: integer;
    RoterPunkt: TPoint2D;

    // Punkte der Karte
    Pnts: array of TGeoPoint;
    Orig: array of TGeoPoint;


    // Symbol-Cache
    Lupe: array of TPNGImage;

    procedure CheckLoadLupen;

  public

    // Dimensionen der Karte
    xN, yN, xL, yL: double;
    iWidth, iHeight: integer;

    // Route auf der Karte
    Route: array of TGeoPoint;

    // Grosse Knödel?
    LupenModus: boolean;
    LinienModus: boolean;

    constructor Create;
    destructor Destroy; override;

    // Aufbau der Wissensbasis
    procedure Clear;

    procedure add(p: TPoint2D; AUFTRAG_R: integer; Aussehen: integer; Ebene: integer; Planbar: boolean); overload;
    procedure add(x, y: double; AUFTRAG_R: integer; Aussehen: integer; Ebene: integer; Planbar: boolean); overload;

    // Status ändern!
    function setAussehen(p: Tpoint2D; a: integer; Planbar: boolean; canvas: TCanvas): integer; // Anzahl Set
    function setFarbe(RID: integer; a: integer; canvas: TCanvas): integer; // Anzahl Set

    procedure setBlinker(p: Tpoint2D; canvas: TCanvas);

    // diesen Punkt dazu oder eben nicht!
    procedure setRoute(p: Tpoint2D; canvas: TCanvas);
    procedure unRoute(canvas: TCanvas);
    procedure deleteRoute(canvas: TCanvas);

    // Infos
    function Grenze: TRectangle;
    function Zentrum: TPoint2D;
    function Breite: double;
    function Hoehe: double;
    function Abstand: double;
    function Naechster(p: TPoint2D; NurPlanbare: boolean = false): TPoint2D;
    function Nachbar(p: TPoint2D; NurPlanbare: boolean = false): TPoint2D;
    function GetList(p: TPoint2D): TgpIntegerList; overload;
    function GetList(a: integer): TgpIntegerList; overload;
    function Element(p: TPoint2D; Ebene: integer): boolean;
    function Count: integer;
    function Sichtbare: integer;
    function Unsichtbare: integer;
    function Planbare: integer;
    function Ziele: integer;
    function pZiele: double;
    function RouteZuletztBesucht: integer;
    function RouteZuletztCount: integer;
    function Radius(p: Tpoint2D): integer;
    function AnzBesuche: integer;
    function getIndex(Pnts: array of TGeoPoint): TWordIndex;

    // Kollidiert die Maus mit einem (nicht schwarzen) Objekt?
    function Kollision(x, y: integer; var p: TPoint2D): boolean;

    // Reale Welt -> Pixel Welt
    function r2pX(x: double): integer;
    function r2pY(y: double): integer;
    function r2p(p: TPoint2D): TPoint; overload;
    function r2p(r: TRectangle): TRect; overload;
    function d2d(d: double): integer; // Abstand in Pixel umrechnen

    // Pixel Welt -> Reale Welt
    function p2rX(x: integer): double;
    function p2rY(y: integer): double;
    function p2r(p: TPoint): TPoint2D; overload;
    function p2r(x, y: integer): TPoint2D; overload;

    // interne Tools
    function Identisch(p1, p2: Tpoint2d): boolean;

    //
    procedure Plot(p: Tpoint; l: integer; a: integer; canvas: TCanvas); overload;
    procedure Plot(p: Tpoint2D; l: integer; a: integer; canvas: TCanvas); overload;
    procedure Plot(p: TPoint2D; canvas: TCanvas); overload;
    procedure Kreuz(p: Tpoint; l: integer; c: Tcolor; canvas: TCanvas);

    procedure Kreuzchen(p: TPoint2D; Canvas: TCanvas); overload;
    procedure Kreuzchen(x, y: double; Canvas: TCanvas); overload;

    // Visualisierung
    procedure Paint(canvas: TCanvas);
    procedure PaintAnz(canvas: TCanvas);
    procedure Blinker(canvas: TCanvas);
    procedure PaintLine(canvas: TCanvas);
  end;

function inDE(p: Tpoint2D): boolean;
function geoAsStr(rad:double):string;
function geoAsInt(rad:double):integer;
function UserAgent_OrgaMon : string;

implementation

uses
  math, IB_Components, anfix,
  SysUtils;

function inDE(p: Tpoint2D): boolean;
begin
  result := (p.x > cxN - 1) and (p.x < cxN + cxL + 1) and (p.y > cyN - 1) and (p.y < cyN + cyL + 1);
end;

{ TGeoCache }

procedure TGeoCache.add(p: TPoint2D; AUFTRAG_R: integer; Aussehen: integer; Ebene: integer; Planbar: boolean);
var
  _visible: boolean;
  LastIndexPnt: integer;
begin

  // nur Deutschland wird berücksichtigt
  if inDE(p) then
  begin
    _visible := not (Element(p, Ebene));
    LastIndexPnt := Length(Pnts);
    MaxEbene := max(MaxEbene, Ebene);
    SetLength(Pnts, LastIndexPnt + 1);
    with Pnts[LastIndexPnt] do
    begin
      gP := p;
      gRID := AUFTRAG_R;
      gAussehen := Aussehen;
      gEbene := Ebene;
      gPlanbar := Planbar;
      gSichtbar := _visible;
    end;

    // Sicherheitskopie anlegen!
    SetLength(Orig, LastIndexPnt + 1);
    Orig[LastIndexPnt] := Pnts[LastIndexPnt];
  end;
end;

procedure TGeoCache.add(x, y: double; AUFTRAG_R: integer; Aussehen: integer; Ebene: integer; PlanBar: boolean);
var
  p: TPoint2D;
begin
  p.x := x;
  p.y := y;
  add(p, AUFTRAG_R, Aussehen, Ebene, Planbar);
end;

function TGeoCache.Zentrum: TPoint2D;
begin
 // den Mittelpunkt aller Punkte ermitteln
  result := Center(Grenze);
end;

procedure TGeoCache.Clear;
begin
  RoterPunkt.x := 0;
  RoterPunkt.y := 0;
  SetLength(pnts, 0);
  SetLength(Orig, 0);
  SetLength(Route, 0);
  LupenModus := true;
  MaxEbene := 0;
  xN := cxN;
  yN := cyN;
  xL := cxL;
  yL := cyL;
end;

constructor TGeoCache.Create;
begin
  Clear;
  LupenModus := true;
  LinienModus := true;
  CheckLoadLupen;
end;

procedure TGeoCache.Paint(canvas: TCanvas);
var
  frameR: TRectangle;
  r: TRect;
  e, n: integer;
  CenterP: TPoint2D;
  PixelCenter: TPoint;
begin

  // Kasten um die Baustelle zeichnen
  frameR := Grenze;
  CenterP := FastGEO.center(frameR);

  // Randzeichnen doppelt dick
  r := SizeCorrect(r2p(frameR));
  canvas.brush.color := cllime;
  canvas.framerect(r);
  rInc(r, 1, 1);
  r.left := r.left - 1;
  r.top := r.top - 1;
  canvas.framerect(r);

  // Verbindungslinie zeichnen
  PaintLine(canvas);

  // Fadenkreuz zeichnen
  PixelCenter := r2p(CenterP);
  Kreuz(PixelCenter, 3, clblack, canvas);

  // Punkte zeichnen
  for e := 0 to MaxEbene do
    for n := 0 to Length(Pnts) - 1 do
      with Pnts[n] do
      begin
        if (gSichtbar) then
          if e = gEbene then
            Plot(gP, 1, gAussehen, canvas);
      end;

end;

function TGeoCache.r2p(p: TPoint2D): TPoint;
begin
  result.x := r2pX(p.x);
  result.y := r2pY(p.y);
end;

function TGeoCache.p2r(p: TPoint): TPoint2D;
begin
  result.x := p2rX(p.x);
  result.y := p2rY(p.y);
end;

function TGeoCache.r2p(r: TRectangle): TRect;
begin
  result.left := r2px(r[1].x);
  result.top := r2py(r[1].y);
  result.right := r2px(r[2].x);
  result.bottom := r2py(r[2].y);
end;

function TGeoCache.r2pX(x: double): integer;
begin
  result := round((x - xN) * iwidth / xL);
end;

function TGeoCache.r2pY(y: double): integer;
begin
  result := iheight - round((y - yN) * iheight / yL);
end;

function TGeoCache.d2d(d: double): integer;
begin
  result := 0;
end;

function TGeoCache.p2rX(x: integer): double;
begin
  if (iwidth > 0) then
    result := xN + xL * (x / iwidth)
  else
    result := -1;
end;

function TGeoCache.p2rY(y: integer): double;
begin
  if (iheight > 0) then
    result := yN + yL * ((iheight - y) / iheight)
  else
    result := -1;
end;

function TGeoCache.Breite: double;
var
  b: TRectangle;
begin
  b := Grenze;
  result := DistanceEarth(b[1].x, b[1].y, b[2].x, b[1].y);
end;

function TGeoCache.Hoehe: double;
var
  b: TRectangle;
begin
  b := Grenze;
  result := DistanceEarth(b[1].x, b[1].y, b[1].x, b[2].y);
end;

function TGeoCache.Grenze: TRectangle;
var
  n: integer;
begin
  if (length(Pnts) > 0) then
  begin
    result[1] := Pnts[0].gP;
    result[2] := result[1];
    for n := 1 to Length(Pnts) - 1 do
    begin
      result[1].x := min(result[1].x, Pnts[n].gP.x);
      result[1].y := max(result[1].y, Pnts[n].gP.y);
      result[2].x := max(result[2].x, Pnts[n].gP.x);
      result[2].y := min(result[2].y, Pnts[n].gP.y);
    end;
  end else
  begin
    result[1].x := -1;
    result[1].y := -1;
    result[2].x := -1;
    result[2].y := -1;
  end;
end;

procedure TGeoCache.Plot(p: Tpoint; l: integer; a: integer; canvas: TCanvas);
var
  n: integer;
begin
  if LupenModus then
  begin
    if (a >= 0) and (a < Length(Lupe)) then
      canvas.draw(p.x - (Lupe[a].width div 2), p.y - (Lupe[a].height div 2), Lupe[a]);
  end else
  begin
    canvas.pixels[p.x, p.y] := clred;
    for n := 1 to l do
    begin
      canvas.pixels[p.x + n, p.y] := clred;
      canvas.pixels[p.x - n, p.y] := clred;
      canvas.pixels[p.x, p.y + n] := clred;
      canvas.pixels[p.x, p.y - n] := clred;
    end;
  end;
end;

procedure TGeoCache.Kreuz(p: Tpoint; l: integer; c: Tcolor; canvas: TCanvas);
var
  n: integer;
begin
  canvas.pixels[p.x, p.y] := c;
  for n := 1 to l do
  begin
    canvas.pixels[p.x + n, p.y] := c;
    canvas.pixels[p.x - n, p.y] := c;
    canvas.pixels[p.x, p.y + n] := c;
    canvas.pixels[p.x, p.y - n] := c;
  end;
end;

function TGeoCache.Nachbar(p: TPoint2D; NurPlanbare: boolean = false): TPoint2D;
var
  n: integer;
  d: double;
begin
  result.x := 0;
  result.y := 0;
  d := MaxInt;
  for n := 0 to pred(Length(Pnts)) do
    with Pnts[n] do
    begin
      if gSichtbar and
        (not (NurPlanbare) or gPlanbar) and
        (Distance(p, gP) < d) and
        (not Identisch(p, gP))
        then
      begin
        d := Distance(p, gP);
        result := gP;
      end;
    end;
end;

function TGeoCache.Naechster(p: TPoint2D; NurPlanbare: boolean = false): TPoint2D;
var
  n: integer;
  d: double;
begin
  result.x := 0;
  result.y := 0;
  d := MaxInt;
  for n := 0 to pred(Length(Pnts)) do
    with Pnts[n] do
    begin
      if gSichtbar and
        (not (NurPlanbare) or gPlanbar) and
        (Distance(p, gP) < d) then
      begin
        d := Distance(p, gP);
        result := gP;
      end;
    end;
end;

function TGeoCache.p2r(x, y: integer): TPoint2D;
begin
  result.x := p2rX(x);
  result.y := p2rY(y);
end;

procedure TGeoCache.Kreuzchen(p: TPoint2D; Canvas: TCanvas);
begin
  Plot(p, 0, 8, canvas);
end;

procedure TGeoCache.Kreuzchen(x, y: double; Canvas: TCanvas);
var
  p: TPoint2D;
begin
  p.x := x;
  p.y := y;
  Plot(p, 0, 8, canvas);
end;

procedure TGeoCache.CheckLoadLupen;
var
  n: integer;
  AlleLupen: TStringList;
begin
  if (Length(Lupe) = 0) then
  begin
    AlleLupen := TStringList.create;
    dir(SystemPath + '\' + 'Punkt.*.png', AlleLupen);
    AlleLupen.sort;
    setLength(Lupe, AlleLupen.count);
    for n := 0 to pred(AlleLupen.count) do
    begin
      Lupe[n] := TPNGImage.create;
      Lupe[n].LoadFromFile(SystemPath + '\' + AlleLupen[n]);
    end;
    AlleLupen.free;
  end;
end;

procedure TGeoCache.PaintAnz(canvas: TCanvas);
var
  AllEl: TWordIndex;
  n: integer;
  p: TPoint2D;
begin
  canvas.brush.color := clwhite;

  // Anzahl der doppelten bestimmen
  AllEl := getIndex(Pnts);

  for n := 0 to pred(AllEl.count) do
    with AllEl.Objects[n] as TExtendedList do
    begin
      if (count > 1) then
      begin
        p := Pnts[integer(items[0])].gP;
        canvas.TextOut(
          r2pX(p.x),
          r2pY(p.y), ' ' + inttostr(count) + ' ');
      end;
    end;
  AllEl.free;
end;

function TGeoCache.GetList(p: TPoint2D): TgpIntegerList;
var
  n: integer;
begin
  result := TgpIntegerList.create;
  for n := 0 to pred(Length(Pnts)) do
    with Pnts[n] do
      if (p.x = gP.x) and (p.y = gP.y) then
        result.add(gRID);
end;

function TGeoCache.Element(p: TPoint2D; Ebene: integer): boolean;
var
  n: integer;
begin
  result := false;
  for n := 0 to pred(Length(Pnts)) do
    with Pnts[n] do
      if Identisch(p, gP) and (Ebene = gEbene) then
      begin
        result := true;
        break;
      end;
end;

function TGeoCache.setFarbe(RID: integer; a: integer;
  canvas: TCanvas): integer;
var
  n: integer;
begin
  result := 0;
  inc(maxEbene);
  for n := 0 to pred(Length(Pnts)) do
    with Pnts[n] do
      if (gRID = RID) then
      begin
        gAussehen := a;
        gSichtbar := true;
        gEbene := MaxEbene;
        Plot(gP, 1, a, canvas);
        inc(result);
      end;
end;

function TGeoCache.setAussehen(p: Tpoint2D; a: integer; Planbar: boolean; canvas: TCanvas): integer;
var
  n: integer;
begin
  result := 0;
  for n := 0 to pred(Length(Pnts)) do
    with Pnts[n] do
      if gSichtbar then
        if Identisch(p, gP) then
        begin
          gAussehen := a;
          gPlanbar := Planbar;
          inc(result);
        end;

  // Punkte da?
  if (result > 0) then
  begin
    // neues Aussehen auch anzeigen
    Plot(p, 1, a, canvas);

    // Blinker auf den aktuellen Punkt setzen
    if (a = cPunkt_schwarz) then
      setBlinker(p, canvas);
  end;
end;

function TGeoCache.GetList(a: integer): TgpIntegerList;
var
  n: integer;
begin
  result := TgpIntegerList.create;
  for n := 0 to pred(Length(Pnts)) do
    with Pnts[n] do
      if gAussehen = a then
        result.add(gRID);
end;

function TGeoCache.Count: integer;
begin
  result := Length(Pnts);
end;

destructor TGeoCache.Destroy;
begin

end;

function TGeoCache.Identisch(p1, p2: Tpoint2d): boolean;
begin
  result := (p1.x = p2.x) and (p1.y = p2.y)
end;

function TGeoCache.Kollision(x, y: integer; var p: TPoint2D): boolean;
var
  p1: TPoint2D;
  p2: Tpoint2D;
  _p2: TPoint;
begin
  result := false;
  p1 := p2r(x, y); // Realer Mauspunkt
  p2 := Naechster(p1, true);
  if inDE(p2) then
  begin
    // Einen nächsten gefunden
    // liegen wir in seinem Radius?
    _p2 := r2p(p2);
    result := (round(distance(x, y, _p2.x, _p2.y)) < Radius(p2));
    if result then
      p := p2;
  end;
end;

function TGeoCache.Radius(p: Tpoint2D): integer;
begin
  result := 9;
end;

procedure TGeoCache.Blinker(canvas: TCanvas);
begin
  if (RoterPunkt.x > 0) then
  begin
    inc(BlinkIntervall);
    canvas.Lock;
    case BlinkIntervall mod 2 of
      0: plot(r2p(RoterPunkt), 7, 7, canvas);
      1: plot(r2p(RoterPunkt), 7, 8, canvas);
    end;
    canvas.UnLock;
  end;
end;

procedure TGeoCache.Plot(p: Tpoint2D; l, a: integer; canvas: TCanvas);
begin
  plot(r2p(p), l, a, canvas);
end;

procedure TGeoCache.setBlinker(p: Tpoint2D; canvas: TCanvas);
begin
  // bisheriger Punkt auf schwarz
  if (RoterPunkt.x > 0) then
    plot(RoterPunkt, 7, 8, canvas);
  // neuen Punkt merken!
  RoterPunkt := p;
end;

procedure TGeoCache.setRoute(p: Tpoint2D; canvas: TCanvas);
var
  n: integer;
begin

  // Zu der aktuellen Route hinzunehmen
  for n := 0 to pred(Length(Pnts)) do
    if Identisch(p, Pnts[n].gP) and Pnts[n].gPlanbar then
    begin
      // Zur Route hinzunehmen (so wie der Punkt ist!)
      SetLength(Route, length(Route) + 1);
      route[pred(Length(Route))] := Pnts[n];
    end;

  //
  if LinienModus then
  begin
    // Zeichne Linine von gP nach P
    for n := Length(Route) - 2 downto 0 do
      with Route[n] do
        if not (Identisch(gP, p)) then
        begin
          canvas.brush.color := clblack;
          canvas.MoveTo(r2pX(gP.x), r2pY(gP.y));
          canvas.LineTo(r2pX(P.x), r2pY(P.y));
          Plot(gp, canvas);
          break;
        end;
    // Zeichne den alten Punkt!

  end;

  // Aussehen auf Schwarz ändern
  SetAussehen(p, cPunkt_schwarz, false, canvas);

end;

procedure TGeoCache.unRoute(canvas: TCanvas);
var
  p: Tpoint2D;
  n: integer;
begin
  if (length(Route) > 0) then
  begin

    // aus den gesicherten Plot wieder das normale rauslesen
    with Route[pred(Length(Route))] do
    begin
      p := gp;
    end;

    // aus der aktuellen Route weglöschen
    for n := pred(length(Route)) downto 0 do
      if Identisch(p, Route[n].gP) then
        SetLength(Route, n)
      else
        break;

    RoterPunkt.x := 0;
    RoterPunkt.y := 0;
    if (Length(Route) > 0) then
    begin
     // auch den "Blinker" zurückstellen
      setBlinker(Route[Length(Route) - 1].gP, canvas);
    end else
    begin
      setBlinker(RoterPunkt, canvas);
    end;

    // Das Aussehen wieder auf den Originalen Stand zurück!
    for n := 0 to pred(length(Pnts)) do
      if Identisch(p, Pnts[n].gP) then
        Pnts[n] := Orig[n];

  end;
end;

procedure TGeoCache.deleteRoute(canvas: TCanvas);
var
  n, m: integer;
  RID: integer;
begin
  if (length(Route) > 0) then
  begin

    for n := pred(length(Route)) downto 0 do
    begin
      RID := Route[n].gRID;
      for m := 0 to pred(length(Pnts)) do
        if (RID = Pnts[m].gRID) then
        begin
          with Orig[m] do
          begin
            gPlanbar := false;
            gAussehen := cPunkt_mint;
          end;
          break;
        end;
    end;

    SetLength(Route, 0);

    RoterPunkt.x := 0;
    RoterPunkt.y := 0;
    setBlinker(RoterPunkt, canvas);

    // Das Aussehen wieder auf den Originalen Stand zurück!
    for n := 0 to pred(length(Pnts)) do
      Pnts[n] := Orig[n];

  end;
end;

function TGeoCache.AnzBesuche: integer;
begin
  result := length(Route);
end;

procedure TGeoCache.PaintLine(canvas: TCanvas);
var
  n: integer;
  p: TPoint2D;
begin
  if LinienModus then
  begin
    canvas.brush.color := clblack;
    p.x := 0;
    p.y := 0;
    for n := 0 to pred(Length(Route)) do
      if Identisch(p, Route[n].gP) then
        continue
      else
        with Route[n] do
        begin
          if (p.x = 0) then
            canvas.MoveTo(r2pX(gP.x), r2pY(gP.y))
          else
            canvas.LineTo(r2pX(gP.x), r2pY(gP.y));
          p := gP;
        end;
  end;
end;

function TGeoCache.getIndex(Pnts: array of TGeoPoint): TWordIndex;
var
  n: integer;
begin
  result := TWordIndex.create(nil);
  for n := 0 to pred(Length(Pnts)) do
    with Pnts[n] do
      result.AddWords(
        inttostrN(round(gP.x * cGEODEZIMAL_Faktor), 9) + 'X' +
        inttostrN(round(gP.y * cGEODEZIMAL_Faktor), 9),
        TObject(n)
        );
  result.JoinDuplicates(true);
end;

function TGeoCache.Sichtbare: integer;
var
  n: integer;
begin
  result := 0;
  for n := 0 to pred(length(Pnts)) do
    with Pnts[n] do
      if gSichtbar then
        inc(result);
end;

function TGeoCache.Unsichtbare: integer;
var
  n: integer;
begin
  result := 0;
  for n := 0 to pred(length(Pnts)) do
    with Pnts[n] do
      if not (gSichtbar) then
        inc(result);
end;

function TGeoCache.Planbare: integer;
var
  n: integer;
begin
  result := 0;
  for n := 0 to pred(length(Pnts)) do
    with Pnts[n] do
      if gPlanbar then
        inc(result);
end;

function TGeoCache.RouteZuletztBesucht: integer;
var
  p: TPoint2d;
  n: integer;
begin
  if (length(Route) > 0) then
  begin
    p := route[pred(Length(Route))].gP;
    result := 1;
    for n := Length(Route) - 2 downto 0 do
      with Route[n] do
        if Identisch(p, gP) then
          inc(result);
  end else
  begin
    result := 0;
  end;
end;

function TGeoCache.RouteZuletztCount: integer;
var
  p: TPoint2d;
  n: integer;
begin
  if (length(Route) > 0) then
  begin
    p := route[pred(Length(Route))].gP;
    result := 0;
    for n := 0 to pred(Length(Pnts)) do
      with Pnts[n] do
        if Identisch(p, gP) then
          inc(result);
  end else
  begin
    result := 0;
  end;
end;

procedure TGeoCache.Plot(p: TPoint2D; canvas: TCanvas);
var
  e, n: integer;
begin
  for e := 0 to MaxEbene do
    for n := 0 to Length(Pnts) - 1 do
      with Pnts[n] do
      begin
        if (gSichtbar) then
          if e = gEbene then
            if Identisch(p, gP) then
              Plot(gP, 1, gAussehen, canvas);
      end;
end;

function TGeoCache.Abstand: double;
var
  n, m: integer;
  d, weg: double;
  aZiele: array of TPoint2D;
  NewPoint: boolean;
begin

  //
  SetLength(aZiele, 0);
  for n := 0 to pred(length(Pnts)) do
    with Pnts[n] do
      if gPlanbar then
      begin

        // gibt es den Punkt schon
        NewPoint := true;
        for m := 0 to high(aZiele) do
          if Identisch(aZiele[m], gP) then
          begin
            NewPoint := false;
            break;
          end;

        if NewPoint then
        begin
          // Als neuen Punkt speichern
          SetLength(aZiele, Length(aZiele) + 1);
          aZiele[high(aZiele)] := gP;
        end;

      end;

  // Nun die distinct Ziele zusammenrechnen
  if (Length(aZiele) > 0) then
  begin
    weg := 0;
    for n := 0 to pred(length(aZiele)) do
    begin

      d := MaxInt;
      for m := 0 to pred(length(aZiele)) do
        if (n <> m) then
          d := min(d, Distance(aZiele[n], aZiele[m]));
      if (d < MaxInt) then
        weg := weg + km(d);
    end;

    result := weg / Length(aZiele);
  end else
  begin
    result := -1;
  end;

end;

function TGeoCache.Ziele: integer; // örtlich unterschiedliche planbare
var
  n, m: integer;
  aZiele: array of TPoint2D;
  NewPoint: boolean;
begin

  //
  SetLength(aZiele, 0);
  for n := 0 to pred(length(Pnts)) do
    with Pnts[n] do
      if gPlanbar then
      begin

        // gibt es den Punkt schon
        NewPoint := true;
        for m := 0 to high(aZiele) do
          if Identisch(aZiele[m], gP) then
          begin
            NewPoint := false;
            break;
          end;

        if NewPoint then
        begin
          // Als neuen Punkt speichern
          SetLength(aZiele, Length(aZiele) + 1);
          aZiele[high(aZiele)] := gP;
        end;

      end;
  result := Length(aZiele);
  SetLength(aZiele, 0);
end;

function TGeoCache.pZiele: double;
var
  _Ziele: double;
  _Planbare: double;
begin
  _Ziele := Ziele;
  _Planbare := Planbare;
  result := (_Ziele / _Planbare) * 100.0;
end;

function geoAsInt(rad:double):integer;
begin
  result := round(rad * cGEODEZIMAL_Faktor);
end;

function geoAsStr(rad:double):string;
begin
  result := inttostr(geoAsInt(rad));
end;

const
 _UserAgent_OrgaMon : string = '';

function UserAgent_OrgaMon : string;
begin
  if (_UserAgent_OrgaMon='') then
  begin
    _UserAgent_OrgaMon :=
      {} globals.cApplicationName+'/'+RevToStr(globals.Version)+ ' ' +
      {} 'contact andreas.filsinger@orgamon.org';
  end;
  result := _UserAgent_OrgaMon;
end;


end.

