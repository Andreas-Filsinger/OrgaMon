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
unit GeoArbeitsplatz;
//
// namespace
//
// x-y-z.png
//

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons,
  GeoCache, FastGeo, OpenStreetMap,

  // Indy
  IdBaseComponent, IdHTTPHeaderInfo, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP,
  IdCookieManager, IdCookie, JvComponentBase,
  JvFormPlacement, IdException,

  // Andere Formulare
  main;

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
  private
    { Private-Deklarationen }
    Initialized: Boolean;
    Lastx, Lasty: double;
    Lastz: Integer;
    getMapRecursion: Integer;

    RouteMode: Boolean;
    DisableCache: Boolean;

    // Center-Tile Cache
    LOX, LOY, RUX, RUY : string;

    //
    function OSM : boolean;
    procedure ToggleRouteMode;
    procedure ToggleLineMode;
    procedure TogglePanel(p: TPanel; c: TColor);
    procedure RefreshAuftragsCount;
    function TileProvider : string;

  public
    { Public-Deklarationen }
    Geo: TGeoCache;
    WaitPNG: TPicture;

    //
    function getMap(X, Y: double; z: Integer = 100): TBitMap;
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
  wanfix32, gplists, WordIndex,

  IB_Components, IB_Schema, IB_Access,

  Datenbank,dbOrgaMon,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  AuftragArbeitsplatz;

{$R *.dfm}

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

function TFormGeoArbeitsplatz.getMap(X, Y: double; z: Integer = 100) : TBitMap;
var
  httpC: TIdHTTP;
  cookieM: TIdCookieManager;

  procedure PrepareHTTP;
  begin

    try
      if assigned(httpC) then
        FreeAndNil(httpC);
    except
     ; // silent Exception
    end;

    try
      if assigned(cookieM) then
        FreeAndNil(cookieM)
    except
     ; // silent Exception
    end;

    httpC := TIdHTTP.create(nil);
    if OSM then
    begin
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
        // Die Client Erkennung, um sich zu tarnen benutze ich gerne den Opera User-Agent
        Request.Referer := 'https://wiki.orgamon.org/';
        Request.UserAgent := UserAgent_OrgaMon;
        ConnectTimeout:= 7000; // 7s
        ReadTimeout:= 70000; // 70s
      end;
    end else
    begin
      // Google
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
        Request.Referer := 'https://wiki.orgamon.org/';
        Request.UserAgent := UserAgent_OrgaMon;
        ConnectTimeout:= 7000; // 7s
        ReadTimeout:= 70000; // 70s
      end;
      cookieM := TIdCookieManager.create(self);
      cookieM.OnNewCookie := IdCookieManager1NewCookie;
      httpC.CookieManager := cookieM;
      httpC.AllowCookies := true;
    end;
  end;

var
  MemoryS: TMemoryStream;
  tilePNG: TPicture;
  CenterTile: TOpenStreetMapTile;
  ServerRequest: String;
  CacheFName: String;
  ix, iy: Integer;
  tRowsDiv2, tColumnsDiv2: Integer;
  Mitte: TPoint;
  rMap, rTile : TRectangle;
  RequestGood: boolean;

begin
  result := nil;
  inc(getMapRecursion);
  if (getMapRecursion=1) then
  begin

    // Init
    NoTimer := true;
    httpC := nil;
    cookieM := nil;
    CenterTile := TOpenStreetMapTile.create;

    // Blank Map
//    result := TPNGObject.CreateBlank(COLOR_RGB, 8, cImageX, cImageY);
    result := TBitMap.Create;
    result.SetSize(cImageX, cImageY);
    result.Canvas.Brush.Color := clwindow;
    result.Canvas.FillRect(Rect(0, 0, cImageX, cImageY));

    // Full Map Rect
    rMap[1].x := 0;
    rMap[1].y := 0;
    rMap[2].x := cImageX;
    rMap[2].y := cImageY;

    // Cache der Werte für Refresh
    Lastx := X;
    Lasty := Y;
    Lastz := z;

    repeat

      if (X <= 0) or (Y <= 0) or (z <= 0) then
        break;

      tColumnsDiv2 := succ(succ(cImageX DIV cTileSize) DIV 2);
      tRowsDiv2 := succ(succ(cImageY DIV cTileSize) DIV 2);


      // init
      PrepareHTTP;

      with centerTile do
      begin
        calcfromZoom(z);

        Mitte.X := cImageX div 2 - cTileSizeDiv2;
        Mitte.Y := cImageY div 2 - cTileSizeDiv2;

        lat := Y;
        lon := X;
        calcFromGPS;

        LOX :=  geoAsStr(X - (cImageX * dlonpp) / 2);
        LOY :=  geoAsStr(Y + (cImageY * dlatpp) / 2);
        RUX :=  geoAsStr(X + (dlonpp * cImageX) / 2);
        RUY :=  geoAsStr(Y - (dlatpp * cImageY) / 2);

        for ix := -tColumnsDiv2 to +tColumnsDiv2 do
          for iy := -tRowsDiv2 to +tRowsDiv2 do
          begin

            rTile[1].x := dx + Mitte.X + ix * cTileSize;
            rTile[1].y := dy + Mitte.Y + iy * cTileSize;
            rTile[2].x := rTile[1].x + cTileSize;
            rTile[2].y := rTile[1].y + cTileSize;

            if RectangleInRectangle(rTile,rMap) then
            begin

              RequestGood := false;

              //
              CacheFName :=
                { } iKartenPfad +
                { } TileProvider + '-' +
                { } inttostr(tz) + '-' +
                { } inttostr(tx + ix) + '-' +
                { } inttostr(ty + iy) + '.png';

              if FileExists(CacheFName) then
              begin
                TogglePanel(PanelHDD, cllime);
                try
                 tilePNG := TPicture.create;
                 tilePNG.LoadFromFile(CacheFName);
                 RequestGood := true;
                except
                  on E: Exception do
                  begin
                    AppendStringstoFile(
                      { } cERRORText + ' 386: ' +
                      { } CacheFName + ' ' +
                      { } E.Message, ERRORFName('Geo'));
                  end;
                end;
              end
              else
              begin
                // es muss erst ein Server gefragt werden
                TogglePanel(PanelOnline, cllime);


                if assigned(WaitPNG) then
                begin
                 try
                  PaintBox1.canvas.draw(
                   { } dx + Mitte.X + ix * cTileSize,
                   { } dy + Mitte.Y + iy * cTileSize,
                   { } waitPNG.Graphic);
                 except
                    ;
                 end;
//                 Application.ProcessMessages;
                end;

                // formuliere Request
                if OSM then
                  ServerRequest := TOpenStreetMapTile.RequestURL(
                    { } iKartenHost,
                    { } tx + ix,
                    { } ty + iy,
                    { } tz)
                else
                  ServerRequest := TOpenStreetMapTile.RequestURL(
                    { } cGoogle_TileURL,
                    { } tx + ix,
                    { } ty + iy,
                    { } tz);

                // Speicher vorbereiten
                MemoryS := TMemoryStream.create;
                try
                  httpC.get(ServerRequest, MemoryS);
                  RequestGood := true;
                except

                  on E: EIdConnClosedGracefully do
                  begin;
                   RequestGood := true;
                  end;

                  on E: Exception do
                  begin
                    AppendStringstoFile(
                      { } cERRORText + ' 435: ' +
                      { } ServerRequest + ' ' +
                      { } E.Message, ERRORFName('Geo'));
                  end;

                end;

                repeat

                 if not(RequestGood) then
                  break;

                 // weitere Prüfungen
                 RequestGood := false;

                 if (httpC.ResponseCode <> 200) then
                 begin
                   AppendStringstoFile(
                     { } cERRORText + ' 453: ' +
                     { } ServerRequest + ':' +  IntToStr(httpC.ResponseCode),
                     { } ERRORFName('Geo'));
                   break;
                 end;

                 if (pos('png',httpC.Response.ContentType)=0) then
                 begin
                   AppendStringstoFile(
                     { } cERRORText + ' 462: ' +
                     { } ServerRequest + ' Contenttype <image/png> erwartet , erhalten <'+ httpC.Response.ContentType + '>',
                     { } ERRORFName('Geo'));
                   break;
                 end;

                 if (MemoryS.Size<>httpc.Response.ContentLength) then
                 begin
                   AppendStringstoFile(
                     { } cERRORText + ' 471: ' +
                     { } ServerRequest + ' ' +
                     { } IntToStr(httpc.Response.ContentLength) +' erwartet / ' +
                     { } IntToStr(MemoryS.Size)+' erhalten',
                     { } ERRORFName('Geo'));
                   break;
                 end;

                 if (MemoryS.Size<67) then
                 begin
                   AppendStringstoFile(
                     { } cERRORText + ' 482: ' +
                     { } ServerRequest + ' kein PNG, nur ' +
                     { } IntToStr(httpc.Response.ContentLength) + ' Bytes',
                     { } ERRORFName('Geo'));
                   break;
                 end;

                 RequestGood := true;
                until yet;

                if RequestGood then
                begin
                   RequestGood := false;
                   MemoryS.Position := 0;
                   try
                    TogglePanel(PanelOnline, clred);
                    MemoryS.SaveToFile(CacheFName);
                    tilePNG := TPicture.create;
                    tilePNG.LoadFromFile(CacheFName);
                    RequestGood := true;
                   except
                     on E: Exception do
                     begin
                        AppendStringstoFile(
                          { } cERRORText + ' 506: ' +
                          { } ServerRequest + ' ' +
                          { } E.Message, ERRORFName('Geo'));
                     end;
                   end;
                end;

                FreeAndNil(MemoryS);
              end;

              if RequestGood and assigned(tilePNG) then
              begin
               result.Canvas.Draw(
                 { } dx + Mitte.X + ix * cTileSize,
                 { } dy + Mitte.Y + iy * cTileSize,
                 { } tilePNG.Graphic);
               FreeAndNil(tilePNG);
               TogglePanel(PanelHDD, clSilver);
               TogglePanel(PanelOnline, clSilver);
              end else
              begin
               PrepareHTTP;
              end;
            end;
        end;
      end;
      if assigned(httpC) then
       httpC.free;
      if assigned(cookieM) then
       cookieM.Free;
    until true;
    TogglePanel(PanelHDD, clSilver);
    TogglePanel(PanelOnline, clSilver);
    CenterTile.Free;
    NoTimer := false;
   end;
   dec(getMapRecursion);
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
          ItemIndex := 1;
          break;
        end;

        if (pos('google', iKartenHost) > 0) then
        begin
          ItemIndex := 0;
          break;
        end;

        ItemIndex := 0;

      until true;
    if not(assigned(Geo)) then
      Geo := TGeoCache.create;

    if FileExists(SystemPath + '\' + 'Warte.png') then
    begin
     waitPNG := TPicture.create;
     waitPNG.loadFromFile(SystemPath + '\' + 'Warte.png');
    end else
    begin
      WaitPNG := nil;
    end;

    Initialized := true;
  end;
  Timer1.enabled := true;
end;

procedure TFormGeoArbeitsplatz.FormDeactivate(Sender: TObject);
begin
  Timer1.enabled := false;
end;

procedure TFormGeoArbeitsplatz.ShowMap(X, Y: double; z: Integer = 100);
var
  ThePNG: TBitMap;
  TheText: TStringList;
  Mitte: TPoint;
begin
  BeginHourGlass;

  ThePNG:= nil;
  TheText:= nil;

  // Anzeigen!
  CheckBox2.checked := false;
  if not(visible) then
    mShow;
  application.processmessages;


   // Dateiname ermitteln
   TheText := TStringList.create;
   ThePNG := getMap(X, Y, z);

   if Assigned(ThePNG) then
   begin

      try
         // Endlich die Karte anzeigen
         PaintBox1.Canvas.Draw(0, 0, ThePNG);
      except
        on E: Exception do
        begin
          AppendStringstoFile(
            { } cERRORText + ' 638: ' +
            { } E.Message, ERRORFName('Geo'));
        end;
      end;

      try
       // kleines Kreuz in der Mitte zeichnen
       Mitte.X := cImageX div 2;
       Mitte.Y := cImageY div 2;
       Geo.Kreuz(Mitte, 3, clwhite, PaintBox1.Canvas);
       inc(Mitte.X);
       inc(Mitte.Y);
       Geo.Kreuz(Mitte, 3, clred, PaintBox1.Canvas);
      except
        on E: Exception do
        begin
          AppendStringstoFile(
            { } cERRORText + ' 655: ' +
            { } E.Message, ERRORFName('Geo'));
        end;
      end;

     try

       with Geo do
       begin
          xN := strtointdef(LOX, 0) / cGEODEZIMAL_Faktor;
          yN := strtointdef(RUY, 0) / cGEODEZIMAL_Faktor;
          xL := (strtointdef(RUX, 0) -
            strtointdef(LOX, 0)) / cGEODEZIMAL_Faktor;
          yL := (strtointdef(LOY, 0) -
            strtointdef(RUY, 0)) / cGEODEZIMAL_Faktor;
          iWidth := ThePNG.width;
          iHeight := ThePNG.height;
          paint(PaintBox1.Canvas);
       end;
     except
       on E: Exception do
        begin
          AppendStringstoFile(
            { } cERRORText + ' 679: ' +
            { } E.Message, ERRORFName('Geo'));
        end;
      end;
   end;

  if assigned(ThePNG) then
   ThePNG.free;
  if assigned(TheText) then
   TheText.free;

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
  numberCLUB: TdboClub;
  updateList: TgpIntegerList;
  Baustellen: TgpIntegerList;
  BaustellenABNUMMER: TgpIntegerList;
  IncIndex: Integer;
  BAUSTELLE_R : Integer;
begin
  BeginHourGlass;
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
    numberCLUB := TdboClub.create('AUFTRAG');
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

function TFormGeoArbeitsplatz.OSM : boolean;
begin
  result := (ComboBox2.ItemIndex<>0);
end;

function TFormGeoArbeitsplatz.TileProvider : string;
begin
 if OSM then
  result := 'osm'
 else
  result := 'google';
end;

end.
