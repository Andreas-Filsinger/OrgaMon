{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2016  Andreas Filsinger
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
unit GeoArbeitsplatz;
//
// namespace
//
// x.y.resolution.png
//

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,

  // Wegen Subinfos im PNG
  GHD_PngImage,
  StdCtrls, ExtCtrls, Buttons,
  GeoCache, FastGeo, OpenStreetMap, JvGIF,

  // Indy
  IdBaseComponent, IdHTTPHeaderInfo, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP,
  IdCookieManager, IdCookie, JvComponentBase,
  JvFormPlacement,

  // Andere Formulare
  main
  ;

type
  TFormGeoArbeitsplatz = class(TForm)
    SpeedButton4: TSpeedButton;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Timer1: TTimer;
    Image2: TImage;
    SpeedButton1: TSpeedButton;
    CheckBox2: TCheckBox;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Label1: TLabel;
    SpeedButton5: TSpeedButton;
    PanelHDD: TPanel;
    PanelOnline: TPanel;
    Button4: TButton;
    Edit1: TEdit;
    ComboBox2: TComboBox;
    IdCookieManager1: TIdCookieManager;
    PaintBox1: TPaintBox;
    SpeedButton6: TSpeedButton;
    JvFormStorage1: TJvFormStorage;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton4Click(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ComboBox2Select(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure IdCookieManager1NewCookie(ASender: TObject; ACookie: TIdCookie;
      var VAccept: Boolean);
    procedure SpeedButton6Click(Sender: TObject);
  private
    { Private-Deklarationen }
    Initialized: Boolean;
    Lastx, Lasty: double;
    Lastz: Integer;

    RouteMode: Boolean;
    DisableCache: Boolean;

    //
    function getMap4(X, Y: double; z: Integer = 100): string; // [FName]
    function getMapOpen(X, Y: double; z: Integer = 100): string; // [FName]
    function getMapGoogle(X, Y: double; z: Integer = 100): string; // [FName]
    procedure ToggleRouteMode;
    procedure ToggleLineMode;
    procedure TogglePanel(p: TPanel; c: TColor);
    procedure RefreshAuftragsCount;
    function cERRORFName: string;

  public
    { Public-Deklarationen }
    Geo: TGeoCache;

    //
    function getMap(X, Y: double; z: Integer = 100): string; // [FName]
    procedure ShowMap(X, Y: double; z: Integer = 100); overload;
    procedure ShowMap(p: TPoint2D; z: Integer = 100); overload;
    procedure ShowMap(GeoC: TGeoCache); overload;

    procedure RedrawAll;
    procedure mShow;
    procedure Test;
    function cImageX: Integer;
    function cImageY: Integer;

  end;

var
  FormGeoArbeitsplatz: TFormGeoArbeitsplatz;


implementation

uses
  Anfix32, globals, CareTakerClient,
  AuftragArbeitsplatz, gplists, WordIndex,
  IB_Components, Datenbank,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  dbOrgaMon, IB_Schema, IB_Access,
  wanfix32;

{$R *.dfm}
{
  const
  cImageX = 990;
  cImageY = 700;
}

procedure TFormGeoArbeitsplatz.mShow;
begin
  WindowState := wsNormal;
  show;
end;

procedure TFormGeoArbeitsplatz.PaintBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  l: TgpIntegerList;
  p: TPoint2D;
begin

  if assigned(Geo) then
  begin

    p := Geo.Naechster(Geo.p2r(X, Y));

    // Karte verschieben
    if (mbright = Button) then
    begin
      ShowMap(p.X, p.Y, Lastz);
    end;

    // Von der Karte zum Terminarbeitsplatz springen
    if (mbleft = Button) then
    begin
      l := Geo.GetList(p);
      FormAuftragArbeitsplatz.ShowRIDs(l);
      l.free;
    end;

  end;

end;

procedure TFormGeoArbeitsplatz.PaintBox1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  p2: TPoint2D;
  Change: Boolean;
begin
  if RouteMode then
    if assigned(Geo) then
    begin
      Change := false;
      while Geo.Kollision(X, Y, p2) do
      begin
        if not(Change) then
          PaintBox1.Canvas.Lock;
        Geo.SetRoute(p2, PaintBox1.Canvas);
        Change := true;
      end;
      if Change then
      begin
        RefreshAuftragsCount;
        PaintBox1.Canvas.unLock;
      end;
    end;
end;

function TFormGeoArbeitsplatz.getMap(X, Y: double; z: Integer): string;
begin
  case ComboBox2.ItemIndex of
    0:
      result := getMap4(X, Y, z);
    1:
      result := getMapGoogle(X, Y, z);
    2:
      result := getMapOpen(X, Y, z);
  else
    result := '';
  end;
end;

function TFormGeoArbeitsplatz.getMap4(X, Y: double; z: Integer = 100): string;
// [FName]
var
  httpC: TIdHTTP;
  ParamF: TMemoryStream;
  mapResponse: TStringList;

  ServerRequest: string;
  _x, _y, _z: string;
  n: Integer;
  PicFName: string;

  function WebClear(s: string): string;
  begin
    result := noblank(s);
    ersetze('<br/>', '', result);
    ersetze('<br>', '', result);
  end;

begin
  result := '';
  mapResponse := TStringList.create;

  // defaults
  Lastx := X;
  Lasty := Y;
  Lastz := z;

  //
  repeat

    if (X <= 0) or (Y <= 0) or (z <= 0) then
    begin
      mapResponse.add(cERRORText + ': x|y|z ist kleiner oder gleich 0');
      break;
    end;

    // Strings zusammenbauen!
    _x := inttostr(round(X * cGEODEZIMAL_Faktor));
    _y := inttostr(round(Y * cGEODEZIMAL_Faktor));
    _z := inttostr(z);
    PicFName := iKartenPfad + _x + '.' + _y + '.' + _z + '.png';

    // Bild schon im Cache?
    if not(DisableCache) then
      if FileExists(PicFName) then
      begin
        PanelHDD.color := cllime;
        PanelOnline.color := clblue;
        result := PicFName;
        break;
      end;

    if (iKartenHost = '') then
    begin
      mapResponse.add(cERRORText + ': KartenHost ist leer!');
      break;
    end;

    // Bild muss geladen werden
    // Vollständige Angabe des Zugriffspfades?
    ServerRequest :=
    { } iKartenHost +
    { } cgetMapScript +
    { } '?x=' + _x +
    { } '&y=' + _y +
    { } '&z=' + _z;

    DisableCache := false;
    httpC := TIdHTTP.create(nil);
    ParamF := TMemoryStream.create;
    try
      httpC.get(ServerRequest, ParamF);
      ParamF.Position := 0;
      mapResponse.LoadFromStream(ParamF);
    except
      on E: Exception do
      begin
        mapResponse.add(cERRORText + ': ' + E.Message);
        break;
      end;
    end;
    ParamF.free;
    httpC.free;

    // Prüfung, ob alles normal war!
    for n := 0 to pred(mapResponse.count) do
      if (pos('IMAGE=', mapResponse[n]) = 1) then
      begin
        // alles super!
        result := PicFName;
        break;
      end;

  until true;

  if (result = '') then
    AppendStringstoFile(mapResponse, cERRORFName);

  mapResponse.free;
end;

function TFormGeoArbeitsplatz.getMapGoogle(X, Y: double; z: Integer): string;
var
  httpC: TIdHTTP;
  cookieM: TIdCookieManager;
  MemoryS: TMemoryStream;
  tilePNG: TPNGObject;
  hugePNG: TPNGObject;

  centerTile: TOpenStreetMapTile;

  ServerRequest: string;
  CacheFName: string;
  _x, _y, _z: string;
  PicFName: string;

  ix, iy: Integer;

  tRowsDiv2, tColumnsDiv2: Integer;
  Mitte: TPoint;

begin
  result := '';

  // defaults
  Lastx := X;
  Lasty := Y;
  Lastz := z;

  //
  repeat

    if (X <= 0) or (Y <= 0) or (z <= 0) then
      break;

    // Strings zusammenbauen!
    _x := geoAsStr(X);
    _y := geoAsStr(Y);
    _z := inttostr(z);
    PicFName := iKartenPfad + 'google-' + _x + '-' + _y + '-' + _z + '-' +
      inttostr(cImageX) + 'x' + inttostr(cImageY) + '.png';

    // Bild schon im Cache?
    if not(DisableCache) then
      if FileExists(PicFName) then
      begin
        PanelHDD.color := cllime;
        PanelOnline.color := clblue;
        result := PicFName;
        break;
      end;

    tColumnsDiv2 := cImageX DIV cTileSize + 2;
    tRowsDiv2 := cImageY DIV cTileSize + 2;

    // Wir wollen Berechnen, welche Kachel benutzt werden muss
    centerTile := TOpenStreetMapTile.create;


    // Wenn nun diese Kachel benutzt wird, wo ist dann der Mittelpunkt!

    // init
    hugePNG := TPNGObject.createblank(COLOR_RGB, 8, cImageX, cImageY);
    tilePNG := TPNGObject.create;
    httpC := TIdHTTP.create(self);
    with httpC do
    begin
      // Die Accept Angabe definiert, welche Formen von Daten der Client akzeptiert
      Request.Accept :=
        'text/html, application/xml;q=0.9, application/xhtml+xml, image/png, image/jpeg, image/gif, image/x-xbitmap, */*;q=0.1';
      // Der AcceptCharSet Wert definiert, welche Zeichen-Formate der Client akzeptiert
      Request.AcceptCharSet := 'iso-8859-1, utf-8, utf-16, *;q=0.1';
      Request.AcceptLanguage := 'de-de,de;q=0.8,en-us;q=0.5,en;q=0.3';
      // Die AcceptEncoding Angabe definiert, welche Kompressionsformate der Client akzeptiert
      Request.AcceptEncoding := 'deflate, identity, *;q=0';
      Request.Connection := 'keep-alive';
      // Der Referer definiert, auf welcher Webseite wir zuvor waren. Gerade dieser Wert
      // wird gerne von Webseiten abgefragt um ungewünschte Bots zu blocken.
      Request.Referer := cGoogle_TileURL;
      // Die Clientkennung
      Request.UserAgent := cAgent;
    end;
    cookieM := TIdCookieManager.create(self);
    cookieM.OnNewCookie := IdCookieManager1NewCookie;
    httpC.CookieManager := cookieM;
    httpC.AllowCookies := true;

    MemoryS := TMemoryStream.create;

    with centerTile do
    begin

      // tz setzen (mit Werten aus der xServer Umfeld)
      calcfromxServer(z);

      Mitte.X := cImageX div 2 - cTileSizeDiv2;
      Mitte.Y := cImageY div 2 - cTileSizeDiv2;

      lat := Y;
      lon := X;
      calcFromGPS;

      // Eintragungen machen
      // TPNGIMage
      hugePNG.addText('MX', _x);
      hugePNG.addText('MY', _y);
      hugePNG.addText('LOX', geoAsStr(X - (cImageX * dlonpp) / 2));
      hugePNG.addText('LOY', geoAsStr(Y + (cImageY * dlatpp) / 2));
      hugePNG.addText('RUX', geoAsStr(X + (dlonpp * cImageX) / 2));
      hugePNG.addText('RUY', geoAsStr(Y - (dlatpp * cImageY) / 2));
      hugePNG.addText('ZOOM', _z);

      for ix := -tColumnsDiv2 to +tColumnsDiv2 do
        for iy := -tRowsDiv2 to +tRowsDiv2 do
        begin

          //
          CacheFName :=
          { } iKartenPfad +
          { } 'google-' +
          { } inttostr(centerTile.tz) + '-' +
          { } inttostr(centerTile.tx + ix) + '-' +
          { } inttostr(centerTile.ty + iy) + '.png';

          if FileExists(CacheFName) then
          begin
            TogglePanel(PanelHDD, cllime);
            tilePNG.LoadFromFile(CacheFName);
          end
          else
          begin
            ServerRequest := TOpenStreetMapTile.RequestURL(
              { } cGoogle_TileURL,
              { } tx + ix,
              { } ty + iy,
              { } tz);

            // Speicher vorbereiten
            MemoryS.Clear;
            TogglePanel(PanelOnline, cllime);
            httpC.get(ServerRequest, MemoryS);
            if (httpC.ResponseCode = 200) then
            begin
              MemoryS.Position := 0;
              tilePNG.LoadFromStream(MemoryS);
              // Save to Cache (may be a little later?)
              // Memory Cache?
              TogglePanel(PanelOnline, clred);
              tilePNG.SaveToFile(CacheFName);
            end;
          end;

          hugePNG.Canvas.Draw(
            { } dx + Mitte.X + ix * cTileSize,
            { } dy + Mitte.Y + iy * cTileSize,
            { } tilePNG);

          TogglePanel(PanelHDD, clSilver);
          TogglePanel(PanelOnline, clSilver);

        end;
    end;

    TogglePanel(PanelHDD, clred);

    hugePNG.SaveToFile(PicFName);
    result := PicFName;

    tilePNG.free;
    hugePNG.free;

    MemoryS.free;
    httpC.free;
    cookieM.free;

  until true;
  TogglePanel(PanelHDD, clSilver);
  TogglePanel(PanelOnline, clSilver);

end;

function TFormGeoArbeitsplatz.getMapOpen(X, Y: double; z: Integer = 100)
  : string; // [FName]

var
  httpC: TIdHTTP;
  MemoryS: TMemoryStream;
  tilePNG: TPNGObject;
  hugePNG: TPNGObject;
  centerTile: TOpenStreetMapTile;

  ServerRequest: string;
  CacheFName: string;
  _x, _y, _z: string;
  PicFName: string;

  ix, iy: Integer;

  tRowsDiv2, tColumnsDiv2: Integer;
  Mitte: TPoint;

begin
  result := '';

  // defaults
  Lastx := X;
  Lasty := Y;
  Lastz := z;

  //
  repeat

    if (X <= 0) or (Y <= 0) or (z <= 0) then
      break;

    // Strings zusammenbauen!
    _x := geoAsStr(X);
    _y := geoAsStr(Y);
    _z := inttostr(z);
    PicFName := iKartenPfad + 'osm-' + _x + '-' + _y + '-' + _z + '-' +
      inttostr(cImageX) + 'x' + inttostr(cImageY) + '.png';

    // Bild schon im Cache?
    if not(DisableCache) then
      if FileExists(PicFName) then
      begin
        TogglePanel(PanelHDD, cllime);
        result := PicFName;
        break;
      end;

    tColumnsDiv2 := succ(succ(cImageX DIV cTileSize) DIV 2);
    tRowsDiv2 := succ(succ(cImageY DIV cTileSize) DIV 2);

    // Wir wollen Berechnen, welche Kachel benutzt werden muss
    centerTile := TOpenStreetMapTile.create;

    // Wenn nun diese Kachel benutzt wird, wo ist dann der Mittelpunkt!

    // init
    hugePNG := TPNGObject.createblank(COLOR_RGB, 8, cImageX, cImageY);
    tilePNG := TPNGObject.create;
    httpC := TIdHTTP.create(nil);
    with httpC do
    begin
      // Die Accept Angabe definiert, welche Formen von Daten der Client akzeptiert
      Request.Accept :=
        'text/html, application/xml;q=0.9, application/xhtml+xml, image/png, image/jpeg, image/gif, image/x-xbitmap, */*;q=0.1';
      // Der AcceptCharSet Wert definiert, welche Zeichen-Formate der Client akzeptiert
      Request.AcceptCharSet := 'iso-8859-1, utf-8, utf-16, *;q=0.1';
      Request.AcceptLanguage := 'de-de,de;q=0.8,en-us;q=0.5,en;q=0.3';
      // Die AcceptEncoding Angabe definiert, welche Kompressionsformate der Client akzeptiert
      Request.AcceptEncoding := 'deflate, identity, *;q=0';
      Request.Connection := 'keep-alive';
      // Der Referer definiert, auf welcher Webseite wir zuvor waren. Gerade dieser Wert
      // wird gerne von Webseiten abgefragt um ungewünschte Bots zu blocken.
      Request.Referer := cOpenStreetMap_TileURL;
      // Die Client Erkennung, um sich zu tarnen benutze ich gerne den Opera User-Agent
      Request.UserAgent := cAgent;
    end;
    MemoryS := TMemoryStream.create;

    with centerTile do
    begin
      // tz setzen (mit Werten aus der xServer Umfeld)
      calcfromxServer(z);

      Mitte.X := cImageX div 2 - cTileSizeDiv2;
      Mitte.Y := cImageY div 2 - cTileSizeDiv2;

      lat := Y;
      lon := X;
      calcFromGPS;

      // Eintragungen machen
      // TPNGIMage
      hugePNG.addText('MX', _x);
      hugePNG.addText('MY', _y);
      hugePNG.addText('LOX', geoAsStr(X - (cImageX * dlonpp) / 2));
      hugePNG.addText('LOY', geoAsStr(Y + (cImageY * dlatpp) / 2));
      hugePNG.addText('RUX', geoAsStr(X + (dlonpp * cImageX) / 2));
      hugePNG.addText('RUY', geoAsStr(Y - (dlatpp * cImageY) / 2));
      hugePNG.addText('ZOOM', _z);

      for ix := -tColumnsDiv2 to +tColumnsDiv2 do
        for iy := -tRowsDiv2 to +tRowsDiv2 do
        begin
          //
          CacheFName :=
          { } iKartenPfad +
          { } 'osm-' +
          { } inttostr(centerTile.tz) + '-' +
          { } inttostr(centerTile.tx + ix) + '-' +
          { } inttostr(centerTile.ty + iy) + '.png';

          if FileExists(CacheFName) then
          begin
            TogglePanel(PanelHDD, cllime);
            tilePNG.LoadFromFile(CacheFName);
          end
          else
          begin

            // formuliere Request
            ServerRequest := TOpenStreetMapTile.RequestURL(
              { } cOpenStreetMap_TileURL,
              { } tx + ix,
              { } ty + iy,
              { } tz);

            // Speicher vorbereiten
            MemoryS.Clear;
            TogglePanel(PanelOnline, cllime);
            httpC.get(ServerRequest, MemoryS);
            if (httpC.ResponseCode = 200) then
            begin
              MemoryS.Position := 0;
              tilePNG.LoadFromStream(MemoryS);
              // Save to Cache (may be a little later?)
              // Memory Cache?
              TogglePanel(PanelOnline, clred);
              tilePNG.SaveToFile(CacheFName);
            end;
          end;
          (*
            PaintBox1.canvas.draw(
            { } dx + Mitte.X + ix * cOpenStreetMap_TileSize,
            { } dy + Mitte.Y + iy * cOpenStreetMap_TileSize,
            tilePNG);
          *)

          hugePNG.Canvas.Draw(
            { } dx + Mitte.X + ix * cTileSize,
            { } dy + Mitte.Y + iy * cTileSize,
            { } tilePNG);

          TogglePanel(PanelHDD, clSilver);
          TogglePanel(PanelOnline, clSilver);

        end;
    end;

    // Save huge to cache
    TogglePanel(PanelHDD, clred);
    hugePNG.SaveToFile(PicFName);
    result := PicFName;

    tilePNG.free;
    hugePNG.free;

    MemoryS.free;
    httpC.free;

  until true;
  TogglePanel(PanelHDD, clSilver);
  TogglePanel(PanelOnline, clSilver);

end;

procedure TFormGeoArbeitsplatz.Test;
begin
  BeginHourGlass;
  DisableCache := true;
  ShowMap(8.41177, 49.00937);
  EndHourGlass;
end;

procedure TFormGeoArbeitsplatz.FormCreate(Sender: TObject);
begin
  top := 0;
  left := 0;
  clientheight := PaintBox1.top + 700 + dpiX(6);
  PaintBox1.Parent.DoubleBuffered := true;
end;

procedure TFormGeoArbeitsplatz.FormActivate(Sender: TObject);
begin
  if not(Initialized) then
  begin
    CheckCreateDir(iKartenPfad);
    with ComboBox2 do
      repeat

        if (pos('tile', iKartenHost) > 0) then
        begin
          ItemIndex := 2;
          break;
        end;

        if (pos('google', iKartenHost) > 0) then
        begin
          ItemIndex := 1;
          break;
        end;

        ItemIndex := 0;

      until true;
    if not(assigned(Geo)) then
      Geo := TGeoCache.create;

    Initialized := true;
  end;
  Timer1.enabled := true;
end;

procedure TFormGeoArbeitsplatz.FormDeactivate(Sender: TObject);
begin
  Timer1.enabled := false;
end;

procedure TFormGeoArbeitsplatz.ShowMap(X, Y: double; z: Integer = 100);
const
  cWAIT_Granularitaet = 151;
  cWAIT_Max = 10000;
var
  FName: string;
  ThePNG: TPNGObject;
  TheText: TStringList;
  Mitte: TPoint;
  ImageFileSize: int64;
  TimeWaited: Integer;
  Stream: TStream;
begin
  BeginHourGlass;

  // Anzeigen!
  CheckBox2.checked := false;
  if not(visible) then
    mShow;
  application.processmessages;

  // Dateiname ermitteln
  FName := getMap(X, Y, z);
  if (FName <> '') then
  begin

    TimeWaited := 0;
    ImageFileSize := -1;
    TheText := TStringList.create;
    ThePNG := TPNGObject.create;
    try

      // Grösse prüfen
      ImageFileSize := FSize(FName);
      while (ImageFileSize <= 0) do
      begin
        delay(cWAIT_Granularitaet);
        inc(TimeWaited, cWAIT_Granularitaet);
        if (TimeWaited >= cWAIT_Max) then
          break;
        ImageFileSize := FSize(FName);
      end;

      if (TimeWaited > 0) then
        AppendStringstoFile(
          { } cWARNINGText + ' ' +
          { } 'FSize(''' + FName + '''): ich ' +
          { } 'musste ' + inttostr(TimeWaited) +
          'ms auf das Dateisystem warten', cERRORFName);

      // Das Laden der Datei versuchen
      TimeWaited := 0;
      Stream := nil;
      repeat
        try
          Stream := TFileStream.create(FName, fmOpenRead or fmShareDenyWrite);
          ThePNG.LoadFromStream(Stream);
          break;
        except
          on E: Exception do
          begin
            if assigned(Stream) then
              FreeAndNil(Stream);

            AppendStringstoFile(
              { } cWARNINGText + ' ' +
              { } 'load(''' + FName + '''): ' +
              { } E.Message,
              { } cERRORFName);

            AppendStringstoFile(
              { } cINFOText + ' ' +
              { } 'go ' + inttostr(cWAIT_Granularitaet) + 'ms for sleep ...',
              { } cERRORFName);

            delay(cWAIT_Granularitaet);
            inc(TimeWaited, cWAIT_Granularitaet);
          end;
        end;
        if (TimeWaited >= cWAIT_Max) then
          break;
      until false;
      if assigned(Stream) then
        FreeAndNil(Stream);

      if (TimeWaited > 0) then
        AppendStringstoFile(
          { } cWARNINGText + ' ' +
          { } 'load(''' + FName + '''): ich ' +
          { } 'musste ' + inttostr(TimeWaited) +
          'ms auf das Dateisystem warten', cERRORFName);

      if (TimeWaited >= cWAIT_Max) then
        raise Exception.create('gebe auf');

      // Endlich zeichnen
      PaintBox1.Canvas.Draw(0, 0, ThePNG);

      // kleines Kreuz in der Mitte zeichnen
      Mitte.X := cImageX div 2;
      Mitte.Y := cImageY div 2;
      Geo.Kreuz(Mitte, 3, clwhite, PaintBox1.Canvas);
      inc(Mitte.X);
      inc(Mitte.Y);
      Geo.Kreuz(Mitte, 3, clred, PaintBox1.Canvas);

      ThePNG.readText(TheText);

      with Geo do
      begin
        xN := strtointdef(TheText.values['LOX'], 0) / cGEODEZIMAL_Faktor;
        yN := strtointdef(TheText.values['RUY'], 0) / cGEODEZIMAL_Faktor;
        xL := (strtointdef(TheText.values['RUX'], 0) -
          strtointdef(TheText.values['LOX'], 0)) / cGEODEZIMAL_Faktor;
        yL := (strtointdef(TheText.values['LOY'], 0) -
          strtointdef(TheText.values['RUY'], 0)) / cGEODEZIMAL_Faktor;
        iWidth := ThePNG.width;
        iHeight := ThePNG.height;
        paint(PaintBox1.Canvas);
      end;

    except
      on E: Exception do
      begin
        AppendStringstoFile(
          { } cERRORText + ' ' +
          { } 'showMap(''' + FName + ''',' + inttostr(ImageFileSize DIV 1024)
          + 'k): ' +
          { } E.Message, cERRORFName);
        // ERROR: Fehler beim Paint!
      end;
    end;
    ThePNG.free;
    TheText.free;
  end;

  if (z = 0) then
    ComboBox1.ItemIndex := ComboBox1.Items.indexof('100')
  else
    ComboBox1.ItemIndex := ComboBox1.Items.indexof(inttostr(z));

  ComboBox1.SetFocus;
  EndHourGlass;
end;

procedure TFormGeoArbeitsplatz.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    close;
    Key := #0;
  end;

  if (Key = '+') then
  begin
    Key := #0;
    if assigned(Geo) then
      Geo.LupenModus := not(Geo.LupenModus);
    RedrawAll;
  end;

  if (Key = ' ') then
  begin
    Geo.PaintAnz(PaintBox1.Canvas);
    Key := #0;
  end;

  if (Key = 'm') then
  begin
    ToggleRouteMode;
    Key := #0;
  end;

  if (Key = 'n') and RouteMode then
    if doit('Wollen Sie die Route löschen und wirklich NEU beginnen') then
    begin
      ToggleRouteMode;
      Geo.deleteRoute(PaintBox1.Canvas);
      RedrawAll;
      Key := #0;
    end;

  if (Key = 'r') then
  begin
    Geo.unRoute(PaintBox1.Canvas);
    RedrawAll;
    if RouteMode then
      RefreshAuftragsCount;
    Key := #0;
  end;

  if (Key = 'l') then
  begin
    ToggleLineMode;
    Key := #0;
  end;

end;

procedure TFormGeoArbeitsplatz.FormResize(Sender: TObject);
begin
  if active then
    ShowMap(Lastx, Lasty, strtointdef(ComboBox1.Text, 0));
end;

procedure TFormGeoArbeitsplatz.SpeedButton4Click(Sender: TObject);
begin
  ShowMap(Lastx, Lasty, strtointdef(ComboBox1.Text, 0));
end;

procedure TFormGeoArbeitsplatz.ComboBox1Select(Sender: TObject);
begin
  SpeedButton4Click(Sender);
end;

procedure TFormGeoArbeitsplatz.ComboBox2Select(Sender: TObject);
begin
  ShowMap(Lastx, Lasty, strtointdef(ComboBox1.Text, 0));
end;

procedure TFormGeoArbeitsplatz.ShowMap(p: TPoint2D; z: Integer);
begin
  ShowMap(p.X, p.Y, z);
end;

procedure TFormGeoArbeitsplatz.RedrawAll;
begin
  ShowMap(Lastx, Lasty, Lastz);
end;

procedure TFormGeoArbeitsplatz.ToggleRouteMode;
begin
  if RouteMode then
  begin
    RouteMode := false;
    Label3.visible := false;
    PaintBox1.cursor := crHandPoint;
  end
  else
  begin
    RouteMode := true;
    RefreshAuftragsCount;
    Label3.visible := true;
    PaintBox1.cursor := crSizeAll;
  end;
end;

procedure TFormGeoArbeitsplatz.RefreshAuftragsCount;
begin
  if assigned(Geo) then
    with Geo do
    begin
      Label3.caption := format('%d/%d/%d', [AnzBesuche, Planbare, count]);
      Label1.caption := format('+%d/%d', [RouteZuletztBesucht,
        RouteZuletztCount]);
    end;
end;

procedure TFormGeoArbeitsplatz.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFormGeoArbeitsplatz.Button4Click(Sender: TObject);
var
  n: Integer;
  RIDs: TgpIntegerList;
begin
  BeginHourGlass;
  RIDs := TgpIntegerList.create;
  for n := 0 to pred(Length(Geo.Route)) do
    with Geo.Route[n] do
      RIDs.add(gRID);
  FormAuftragArbeitsplatz.ShowRIDs(RIDs);
  RIDs.free;
  EndHourGlass;
end;

function TFormGeoArbeitsplatz.cERRORFName: string;
begin
  result := DiagnosePath + 'Karte-Error-' + DatumLog + '.log.txt';
end;

function TFormGeoArbeitsplatz.cImageX: Integer;
begin
  result := PaintBox1.width;
end;

function TFormGeoArbeitsplatz.cImageY: Integer;
begin
  result := PaintBox1.height;
end;

procedure TFormGeoArbeitsplatz.Timer1Timer(Sender: TObject);
begin
  if noTimer then
    exit;
  if assigned(Geo) then
    Geo.Blinker(PaintBox1.Canvas);
end;

procedure TFormGeoArbeitsplatz.IdCookieManager1NewCookie(ASender: TObject;
  ACookie: TIdCookie; var VAccept: Boolean);
begin
  //
  VAccept := true;

end;

procedure TFormGeoArbeitsplatz.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Geoarbeitsplatz');
end;

procedure TFormGeoArbeitsplatz.SpeedButton1Click(Sender: TObject);
var
  PQmain: string;
  PQsub: Integer;
  PQ: string;
  p: TPoint2D;
  n: Integer;
  qAUFTRAG: TIB_Query;
  DebugS: TStringList;
  EmptyRIDs: TgpIntegerList;
  BAUSTELLE_R: Integer;
  numberCLUB: TdboClub;
  updateList: TgpIntegerList;
  Baustellen: TgpIntegerList;
  BaustellenABNUMMER: TgpIntegerList;
  IncIndex: Integer;
begin
  BeginHourGlass;
  BAUSTELLE_R := cRID_unset;
  Baustellen := TgpIntegerList.create;
  BaustellenABNUMMER := TgpIntegerList.create;
  EmptyRIDs := TgpIntegerList.create;
  DebugS := TStringList.create;
  DebugS.add('RID;PQ_BISHER;PQ_NEU;AB_BISHER');
  PQmain := inttostrN(e_w_gen('GEN_GEO'), cGEO_PQ_Length) + '.';
  PQsub := 0;
  p.X := 0;
  Edit1.Text := nextp(PQmain, '.', 0);
  // erst mal die Planquadrate
  qAUFTRAG := DataModuleDatenbank.nQuery;
  with qAUFTRAG do
  begin
    sql.add('select * from AUFTRAG where RID=:CROSSREF for update');
    open;
    for n := 0 to pred(Length(Geo.Route)) do
      with Geo.Route[n] do
      begin
        if not(Geo.Identisch(p, gP)) then
        begin
          inc(PQsub);
          p := gP;
        end;
        PQ := PQmain + inttostrN(PQsub, 3);

        ParamByName('CROSSREF').AsInteger := gRID;
        First;

        DebugS.add(
          { } inttostr(gRID) + ';' +
          { } FieldByName('PLANQUADRAT').AsString + ';' +
          { } PQ + ';' +
          { } FieldByName('NUMMER').AsString);

        BAUSTELLE_R := FieldByName('BAUSTELLE_R').AsInteger;

        edit;
        if CheckBox2.checked then
          FieldByName('NUMMER').Clear;
        FieldByName('PLANQUADRAT').AsString := PQ;
        AuftragBeforePost(qAUFTRAG);
        post;

        if FieldByName('NUMMER').IsNull then
        begin
          if (Baustellen.indexof(BAUSTELLE_R) = -1) then
            Baustellen.add(BAUSTELLE_R);
          EmptyRIDs.add(gRID);
        end;
      end;
  end;
  qAUFTRAG.free;
  DebugS.SaveToFile(DiagnosePath + 'Geo-Route-' + PQmain + 'csv');
  DebugS.free;

  // Nun die Auftragsnummern durchnummerieren
  if (EmptyRIDs.count > 0) then
  begin

    // Die benötigten AB-Start-Nummern ermitteln
    for n := 0 to pred(Baustellen.count) do
      BaustellenABNUMMER.add(e_r_AuftragNummer(Baustellen[n]));

    // Über einen "CLUB" arbeiten
    numberCLUB := TdboClub.create(DataModuleDatenbank.IB_Connection1,
      'AUFTRAG');
    updateList := e_r_sqlm(
      { } 'select AUFTRAG.RID from AUFTRAG ' +
      { } numberCLUB.sql(EmptyRIDs) +
      { } 'where ' +
      { } ' (NUMMER is null) ' +
      { } 'order by' +
      { } ' STRASSE, ZAEHLER_NUMMER, ART');
    e_x_commit;
    numberCLUB.free;

    // Updateliste abarbeiten
    for n := 0 to pred(updateList.count) do
    begin

      BAUSTELLE_R := e_r_sql('select BAUSTELLE_R from AUFTRAG where RID=' +
        inttostr(updateList[n]));
      IncIndex := Baustellen.indexof(BAUSTELLE_R);
      if (IncIndex = -1) then
        raise Exception.create('BAUSTELLE_R unbekannt');

      BaustellenABNUMMER[IncIndex] := BaustellenABNUMMER[IncIndex] + 1;

      e_x_sql(
       { } 'update AUFTRAG set NUMMER=' + inttostr(BaustellenABNUMMER[IncIndex]) + ' ' +
       { } 'where' +
       { } ' RID=' + inttostr(updateList[n]));

    end;
    e_x_commit;
    updateList.free;
  end;
  EmptyRIDs.free;
  BaustellenABNUMMER.free;
  Baustellen.free;
  CheckBox2.checked := false;
  EndHourGlass;
end;

procedure TFormGeoArbeitsplatz.SpeedButton2Click(Sender: TObject);
var
  p: TPoint2D;
begin
  if assigned(Geo) then
  begin
    p := Geo.Naechster(Geo.Zentrum);
    ShowMap(p, Lastz);
  end;
end;

procedure TFormGeoArbeitsplatz.SpeedButton3Click(Sender: TObject);
var
  n: Integer;
  m: TExtendedList; // das was markiert wird
begin
  if assigned(Geo) then
  begin
    m := FormAuftragArbeitsplatz.ItemsMARKED;
    with Geo do
    begin
      for n := 0 to pred(m.count) do
        SetFarbe(Integer(m[n]), cPunkt_blau, PaintBox1.Canvas);
    end;
  end;
end;

procedure TFormGeoArbeitsplatz.ShowMap(GeoC: TGeoCache);
var
  p: TPoint2D;
begin
  if assigned(Geo) then
    FreeAndNil(Geo);
  Geo := GeoC;
  p := GeoC.Naechster(GeoC.Zentrum);
  ShowMap(p.X, p.Y, 25);
end;

procedure TFormGeoArbeitsplatz.TogglePanel(p: TPanel; c: TColor);
begin
  p.color := c;
  application.processmessages;
end;

procedure TFormGeoArbeitsplatz.ToggleLineMode;
begin
  if assigned(Geo) then
  begin
    Geo.LinienModus := not(Geo.LinienModus);
    RedrawAll;
  end;
end;

procedure TFormGeoArbeitsplatz.SpeedButton5Click(Sender: TObject);
begin
  ShowMessage
    (format('Anfahrt notwendig zu %d Zielen bei %d Planbaren bei %d Aufträgen' +
    #13 + '%.2f%% der Zähler müssen angefahren werden!' + #13 +
    'Minimalst denkbarer Mindestabstand: %.3f km' + #13 +
    'Minimalste Fahrstrecke: %.3f km', [Geo.Ziele, Geo.Planbare, Geo.count,
    Geo.pZiele, Geo.Abstand, Geo.Abstand * Geo.Ziele]));
end;

procedure TFormGeoArbeitsplatz.SpeedButton6Click(Sender: TObject);
var
  n: Integer;
begin
  for n := 1 to 5 do
  begin
    ShowMap(Lastx + ((random(200) - 100) / 1000),
      Lasty + ((random(200) - 100) / 1000), Lastz);
    application.processmessages;
  end;
end;

end.
