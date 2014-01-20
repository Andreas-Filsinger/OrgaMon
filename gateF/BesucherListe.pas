unit BesucherListe;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, Grids,
  ExtCtrls, StdCtrls, Spin,
  ImgList, anfix32, ComCtrls,
  Menus, globals, SymbolPool;

type
  TLineRec = class(TObject)
    // PERSISTENT Data
    Symbol: TeSymbol;
    sDatum: TAnfixDate; // Besuchs-Start
    eDatum: TAnfixDate;
    sZeit: TAnfixTime; // Besuchs-Ende
    eZeit: TAnfixTime;
    BesucherName: string;
    Firma: string;
    Mitarbeiter: string; // name (Geb+Tel)#name (Geb+Tel)
    PforteEin: byte;
    PforteAus: byte;
    PfoertnerEin: string;
    PfoertnerAus: string;
    Anzahl: byte; // Besucher-Anzahl
    Kennzeichen: string; // KFZ
    Land: string;
    TRNid: integer; // eindeutige Besuchs-TAN
    Grund: string;
    Mitgebracht: string;
    Handy: string;
    Anrede: string;
    Parken: TeParkErlaubnis;
    Alarm: TeAlarmStatus;
    GeaendertDurch: string;
    BesucherID: integer;
    Nachricht: string;
    RepetierendBis: TAnfixDate; // Repetierend bis Datum

    procedure LoadFromString(const s: string);
    function SaveToString: string;
    function Green: boolean;
    function Color: TColor;
    function RestTimeStr: string;
    function RestTime: TAnfixTime;
    function RestSeconds: integer;
    function SortStr: string;
    function PforteStatus: TePfortenStatus;
    function Identisch(CmpRec: TLineRec): boolean;
    function BMPFname: string;
    procedure CopyTo(Dest: TLineRec);
    function BesuchsDauer: TAnfixTime;
    function eZeitDefault: TAnfixTime;
    function eZeitDefault2: TAnfixTime;
    function GetSymbol(c: TeSymbolColor; b: TColor): TBitMap;
    function BevorzugtesZiel: string;
  end;

  TLineList = class(TList)
    function _Get(Index: integer): TLineRec;
    procedure _Put(Index: integer; Item: TLineRec);
    procedure LoadFromFile(FName: string);
    procedure SaveToFile(FName: string);
    procedure Clear; override;
    property Items[Index: integer]: TLineRec read _Get write _Put; default;
    procedure DoSort;
  end;

type
  TBesucherListeForm = class(TForm)
    DrawGrid1: TDrawGrid;
    Image1: TImage;
    Timer1: TTimer;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    ImHausPopup: TPopupMenu;
    ChangeClick: TMenuItem;
    NewClick: TMenuItem;
    N1: TMenuItem;
    CancelClick: TMenuItem;
    EndeClick: TMenuItem;
    Button4: TButton;
    noch10min1: TMenuItem;
    Panel3: TPanel;
    Label13: TLabel;
    Panel4: TPanel;
    Image2: TImage;
    Panel5: TPanel;
    DruckenClick: TMenuItem;
    NeuPlanung1: TMenuItem;
    HistoriePopup: TPopupMenu;
    FuturePopup: TPopupMenu;
    Zurck1: TMenuItem;
    N2: TMenuItem;
    Zurck2: TMenuItem;
    N3: TMenuItem;
    FutureStartClick: TMenuItem;
    FutureChangeClick: TMenuItem;
    FutureDeleteClick: TMenuItem;
    FutureNewClick: TMenuItem;
    HistRepeat: TMenuItem;
    HistShowClick: TMenuItem;
    Histprint: TMenuItem;
    Futureprint: TMenuItem;
    Label3: TLabel;
    Label6: TLabel;
    Label4: TLabel;
    Image3: TImage;
    Label5: TLabel;
    Besuchaktuell: TMenuItem;
    Image4: TImage;
    Label7: TLabel;
    noch30min1: TMenuItem;
    Label8: TLabel;
    Label9: TLabel;
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure DrawGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Button4Click(Sender: TObject);
    procedure EndeClickClick(Sender: TObject);
    procedure noch10min1Click(Sender: TObject);
    procedure NewClickClick(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Panel3Click(Sender: TObject);
    procedure DruckenClickClick(Sender: TObject);
    procedure NeuPlanung1Click(Sender: TObject);
    procedure HistprintClick(Sender: TObject);
    procedure FutureprintClick(Sender: TObject);
    procedure HistShowClickClick(Sender: TObject);
    procedure ChangeClickClick(Sender: TObject);
    procedure HistRepeatClick(Sender: TObject);
    procedure FutureStartClickClick(Sender: TObject);
    procedure DrawGrid1DblClick(Sender: TObject);
    procedure FutureChangeClickClick(Sender: TObject);
    procedure FutureNewClickClick(Sender: TObject);
    procedure FutureDeleteClickClick(Sender: TObject);
    procedure BesuchaktuellClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure noch30min1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Image4Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }

    Items: TLineList;
    SavedItem: TLineRec;

    PastBorder: integer;
    FutureBorder: integer;
    SelectedRow: integer;
    YellowRow: integer; // zu löschende Zeile

    LastFileTime: integer;

    // Symbole für die Pforten
    PfortenSymbols: array of TBitMap;

    // Symbole für die Personen-Dinge
    SymbolRohstoffe: TSymbolPool;

    // prüfen, welche Pforten oben sind
    UpCheckTime: dword;
    SplashCheck: integer;

    // Stand der Transaktions-Nummer
    CountIniLoaded: integer;
    LastPrintedTRNid: integer;
    LastNewTRNid: integer;
    AlreadyActivatedOnce: boolean;
    BarcodeAutoMode: boolean;
    BarCode: string;

    function GetPfortenTime: TAnfixTime;
    function GetPfortenDate: TAnfixDate;
    function GetPforteSymbol(n: integer): TBitMap;

    procedure SetListCursorToHeute;
    function SetListCursorTo(TRNid: integer): boolean;

    procedure NeuerAnwender(const s: string);

    procedure SortBesucher;
    procedure ShowBesucher;
    procedure NewBesucher(SelectedRow: integer);
    procedure RausBesucher(SelectedRow: integer; AutoModus: boolean);
    procedure DeleteBesucher(SelectedRow: integer; EntlassDatum: TAnfixDate;
      EntlassZeit: TAnfixTime);
    procedure DeleteBesucherByTRN(Trn: integer; EntlassDatum: TAnfixDate;
      EntlassZeit: TAnfixTime);
    procedure PrintBesucher(SelectedRow: integer);
    procedure FillPrinterData(SelectedRow: integer);
    procedure ListeEnterPressed(SelectedRow: integer);
    procedure SaveDataToDialog(src: TLineRec);
    procedure WillkommenOK;

    procedure LoadFileData;
    procedure ContextPopUp(X, Y: integer);

    procedure ReBuildPfortenInfo;

    procedure AddMinutes(s: TAnfixTime);
    procedure BarCodeOKPressed;
    procedure BesuchJetztEingetroffen(l: TLineRec);

    procedure InsertMitarbeiter(data: TStrings);
  end;

var
  BesucherListeForm: TBesucherListeForm;

implementation

uses
  PrintView, SystemSettings, VerbindungIT,
  BenutzerWechsel, Willkommen, AufWiedersehen,
  PlanungLoeschen, splash, BesucherPflege,
  BesucherSuche, MitarbeiterSuche, math,
  Transaction, SystemPasswort, wanfix32;

{$R *.DFM}
// tools,

function RectFromControl(Control: TControl): TRect;
begin
  with Control do
    result := Rect(left - 1, top - 1, left + width + 1, top + height + 1);
end;

procedure TLineRec.CopyTo(Dest: TLineRec);
begin
  Dest.Symbol := Symbol;
  Dest.sDatum := sDatum;
  Dest.eDatum := eDatum;
  Dest.sZeit := sZeit;
  Dest.eZeit := eZeit;
  Dest.BesucherName := BesucherName;
  Dest.Firma := Firma;
  Dest.Mitarbeiter := Mitarbeiter;
  Dest.PforteEin := PforteEin;
  Dest.PforteAus := PforteAus;
  Dest.PfoertnerEin := PfoertnerEin;
  Dest.PfoertnerAus := PfoertnerAus;
  Dest.Anzahl := Anzahl;
  Dest.Kennzeichen := Kennzeichen;
  Dest.Land := Land;
  Dest.TRNid := TRNid;
  Dest.Grund := Grund;
  Dest.Mitgebracht := Mitgebracht;
  Dest.Handy := Handy;
  Dest.Anrede := Anrede;
  Dest.Parken := Parken;
  Dest.Alarm := Alarm;
  Dest.GeaendertDurch := GeaendertDurch;
  Dest.BesucherID := BesucherID;
  Dest.Nachricht := Nachricht;
  Dest.RepetierendBis := RepetierendBis;
end;

function TLineRec.Identisch(CmpRec: TLineRec): boolean;
begin
  result := (Symbol = CmpRec.Symbol) and (sDatum = CmpRec.sDatum) and
    (eDatum = CmpRec.eDatum) and (sZeit = CmpRec.sZeit) and
    (eZeit = CmpRec.eZeit) and (BesucherName = CmpRec.BesucherName) and
    (Firma = CmpRec.Firma) and (Mitarbeiter = CmpRec.Mitarbeiter) and
    (PforteEin = CmpRec.PforteEin) and (PforteAus = CmpRec.PforteAus) and
    (PfoertnerEin = CmpRec.PfoertnerEin) and
    (PfoertnerAus = CmpRec.PfoertnerAus) and (Anzahl = CmpRec.Anzahl) and
    (Kennzeichen = CmpRec.Kennzeichen) and (Land = CmpRec.Land) and
    (TRNid = CmpRec.TRNid) and (Grund = CmpRec.Grund) and
    (Mitgebracht = CmpRec.Mitgebracht) and (Handy = CmpRec.Handy) and
    (Anrede = CmpRec.Anrede) and (Parken = CmpRec.Parken) and
    (Alarm = CmpRec.Alarm) and (GeaendertDurch = CmpRec.GeaendertDurch) and
    (BesucherID = CmpRec.BesucherID) and (Nachricht = CmpRec.Nachricht) and
    (RepetierendBis = CmpRec.RepetierendBis);
end;

function TLineRec.PforteStatus: TePfortenStatus;
begin

  if (Symbol = csyMarker) then
  begin
    if (PforteEin <> 0) then
      result := psMarkerPast
    else
      result := psMarkerFuture;
    exit;
  end;

  if (PforteEin = 0) and (PforteAus = 0) then
  begin
    result := psUnknown;
    exit;
  end;

  if (PforteEin <> 0) and (PforteAus = 0) then
  begin
    result := psInHouse;
    exit;
  end;

  result := psComplete;
end;

function TLineRec.SortStr: string;
var
  _PforteStatus: TePfortenStatus;
begin
  _PforteStatus := PforteStatus;
  if _PforteStatus = psComplete then
    result := inttostr(ord(_PforteStatus)) + inttostrN(eDatum, 8) +
      inttostrN(eZeit, 6) + BesucherName
  else
    result := inttostr(ord(_PforteStatus)) + inttostrN(sDatum, 8) +
      inttostrN(sZeit, 6) + BesucherName;
end;

function TLineRec.BesuchsDauer: TAnfixTime;
begin
  result := max(SecondsDiff(eDatum, eZeit, sDatum, sZeit), 0);
end;

function TLineRec.eZeitDefault: TAnfixTime;
begin
  result := secondsadd(sZeit, strtoseconds('00:10'));
end;

function TLineRec.eZeitDefault2: TAnfixTime;
begin
  result := secondsadd(sZeit, strtoseconds('08:00'));
end;

function TLineRec.BMPFname: string;
begin
  result := MyProgramPath + cAblagePath + inttostr(BesucherID) + '.bmp';
end;

function TLineRec.BevorzugtesZiel: string;
var
  ziel: string;
  _OneZiel: string;
begin
  ziel := Mitarbeiter;
  result := '';
  while (ziel <> '') do
  begin
    _OneZiel := nextp(ziel, '#');
    if length(_OneZiel) > 0 then
      if _OneZiel[length(_OneZiel)] = '!' then
        result := _OneZiel;
  end;
end;

function _SortCompare(a, b: pointer): integer;
begin
  result := CompareStr(TLineRec(a).SortStr, TLineRec(b).SortStr);
end;

procedure TLineList.DoSort;
begin
  Sort(_SortCompare);
end;

procedure TLineList.LoadFromFile(FName: string);
var
  n: integer;
  NewListElement: TLineRec;
  FullData: TStringList;
begin
  Clear;
  FullData := TStringList.create;
  if FileExists(FName) then
    FullData.LoadFromFile(FName);
  for n := 0 to pred(FullData.Count) do
  begin
    NewListElement := TLineRec.create;
    NewListElement.LoadFromString(FullData[n]);
    add(NewListElement);
  end;
  FullData.free;
end;

procedure TLineList.SaveToFile(FName: string);
var
  FullData: TStringList;
  n: integer;
begin
  FullData := TStringList.create;
  for n := 0 to pred(Count) do
    if (Items[n].Symbol <> csyMarker) then
      FullData.add(Items[n].SaveToString);
  FullData.SaveToFile(FName);
  FullData.free;
end;

function TLineList._Get(Index: integer): TLineRec;
begin
  result := TLineRec(get(index));
end;

procedure TLineList._Put(Index: integer; Item: TLineRec);
begin
  Put(Index, Item);
end;

procedure TLineRec.LoadFromString(const s: string);
var
  RestStr: string;

  function nextp: string;
  var
    k: integer;
  begin
    k := pos(';', RestStr);
    if (k = 0) then
    begin
      result := RestStr;
      RestStr := '';
    end
    else
    begin
      result := copy(RestStr, 1, pred(k));
      delete(RestStr, 1, k);
    end;
  end;

begin
  RestStr := s;
  Symbol := TeSymbol(str2int(nextp));
  sDatum := date2long(nextp);
  eDatum := date2long(nextp);
  sZeit := strtoseconds(nextp);
  eZeit := strtoseconds(nextp);
  BesucherName := nextp;
  Firma := nextp;
  Mitarbeiter := nextp;
  PforteEin := str2int(nextp);
  PforteAus := str2int(nextp);
  PfoertnerEin := nextp;
  PfoertnerAus := nextp;
  Anzahl := str2int(nextp);
  if (Anzahl = 0) then
    Anzahl := 1;
  Kennzeichen := nextp;
  Land := nextp;
  TRNid := str2int(nextp);
  Grund := nextp;
  Mitgebracht := nextp;
  Handy := nextp;
  Anrede := nextp;
  Parken := TeParkErlaubnis(str2int(nextp));
  Alarm := TeAlarmStatus(str2int(nextp));
  GeaendertDurch := nextp;
  BesucherID := str2int(nextp);
  Nachricht := nextp;
  RepetierendBis := date2long(nextp);
end;

function TLineRec.SaveToString: string;
begin
  result := { 01 } inttostr(ord(Symbol)) + ';' +
  { 02 } long2date(sDatum) + ';' +
  { 03 } long2date(eDatum) + ';' +
  { 04 } secondstostr(sZeit) + ';' +
  { 05 } secondstostr(eZeit) + ';' +
  { 06 } BesucherName + ';' +
  { 07 } Firma + ';' +
  { 08 } Mitarbeiter + ';' +
  { 09 } inttostr(PforteEin) + ';' +
  { 10 } inttostr(PforteAus) + ';' +
  { 11 } PfoertnerEin + ';' +
  { 12 } PfoertnerAus + ';' +
  { 13 } inttostr(Anzahl) + ';' +
  { 14 } Kennzeichen + ';' +
  { 15 } Land + ';' +
  { 16 } inttostr(TRNid) + ';' +
  { 17 } Grund + ';' +
  { 18 } Mitgebracht + ';' +
  { 19 } Handy + ';' +
  { 20 } Anrede + ';' +
  { 21 } inttostr(ord(Parken)) + ';' +
  { 22 } inttostr(ord(Alarm)) + ';' +
  { 23 } GeaendertDurch + ';' +
  { 24 } inttostr(BesucherID) + ';' +
  { 25 } Nachricht + ';' +
  { 26 } long2date(RepetierendBis); (* + ';' +
    {27} SortStr;
  *)
end;

function TLineRec.Green: boolean;
begin
  with BesucherListeForm do
    result := (GetPfortenDate < eDatum) or
      ((GetPfortenTime <= eZeit) and (GetPfortenDate = eDatum));
end;

function TLineRec.Color: TColor;
begin
  if (PforteEin = 0) and (PforteAus = 0) then
  begin
    if RepetierendBis = 0 then
      result := clListeFuture
    else
      result := clListeRobot;
    exit;
  end;
  if (PforteEin <> 0) and (PforteAus = 0) then
  begin
    if Green then
      result := clListeGruen
    else
      result := clListeRot;
    exit;
  end;
  result := clListeGrau;
end;

function TLineRec.RestTime: TAnfixTime;
begin
  with BesucherListeForm do
  begin
    if Green then
      result := SecondsDiff(eDatum, eZeit, GetPfortenDate, GetPfortenTime)
    else
      result := SecondsDiff(GetPfortenDate, GetPfortenTime, eDatum, eZeit)
  end;
end;

function TLineRec.RestTimeStr: string;
begin
  result := secondstostr5(RestTime);
end;

function TLineRec.RestSeconds: integer; // 0..60 [s]
begin
  result := abs(RestTime mod 60);
end;

function TLineRec.GetSymbol(c: TeSymbolColor; b: TColor): TBitMap;
var
  SymbolName: string;
  NewBMP: TBitMap;

  function booltoX(b: boolean): string;
  begin
    if b then
      result := 'J'
    else
      result := 'N';
  end;

begin
  // n      := ord(b)*16 + ord(Symbol)*4 + ord(c);
  // result := BesucherListeForm.QV_Symbol( ord(b)*16 + ord(Symbol)*4 + ord(c) );

  SymbolName := inttostr(ord(Symbol)) + inttostr(ord(Parken)) +
    inttostr(ord(Alarm)) + inttostr(ord(c)) + inttoHex(b, 6) +
    booltoX(Handy <> '');

  with BesucherListeForm do
  begin
    result := SymbolRohstoffe.Symbol(SymbolName);
    if (result = nil) then
    begin
      // Hey, jetzt das Symbol umständlich zeichnen
      NewBMP := TBitMap.create;
      NewBMP.width := DrawGrid1.ColWidths[1];
      NewBMP.height := DrawGrid1.DefaultRowHeight;

      // a) Hintergrund
      NewBMP.canvas.brush.Color := b;
      NewBMP.canvas.FillRect(Rect(0, 0, NewBMP.width, NewBMP.height));

      if Parken = cpePermission then
        NewBMP.canvas.Draw(18, 0, SymbolRohstoffe.Symbol('S3'));

      if Handy <> '' then
        NewBMP.canvas.Draw(18, 15, SymbolRohstoffe.Symbol('S4'));

      // NewBMP.Canvas.Draw(0,12,SymbolRohstoffe.symbol('A'+inttostr(ord(alarm))));

      if Alarm <> casnone then
        NewBMP.canvas.Draw(0, 8,
          SymbolRohstoffe.Symbol('A' + inttostr(ord(Alarm))));

      // b) Fahrzeug einblenden windows
      NewBMP.canvas.Draw(36, 6,
        SymbolRohstoffe.Symbol('P' + inttostr(ord(Symbol)) + inttostr(ord(c))));

      result := NewBMP;
      SymbolRohstoffe.InsertSymbol(SymbolName, NewBMP);
    end;
  end;
end;

procedure TLineList.Clear;
var
  n: integer;
begin
  for n := 0 to pred(Count) do
    Items[n].free;
  inherited Clear;
end;

procedure rPercent(p: byte; cent: extended; var r: TRect);
var
  FullX: extended;
  Percent: extended;
  NewXL: integer;
begin
  FullX := rXL(r);
  Percent := p / cent;
  FullX := FullX * Percent;
  NewXL := round(FullX);
  rSetSize(NewXL, rYl(r), r);
end;

procedure TBesucherListeForm.DrawGrid1DrawCell(Sender: TObject;
  ACol, ARow: integer; Rect: TRect; State: TGridDrawState);
var
  SymbolColor: TeSymbolColor;
  WaitRect: TRect;
  k: integer;
  _FirstLine: string;
  _brush_color: TColor;
begin
  if (ARow >= 0) then
    with DrawGrid1.canvas, Items[ARow] do
    begin

      if odd(ARow) then
      begin
        brush.Color := clWhite;
      end
      else
      begin
        brush.Color := clCursorGrau;
      end;

      if (ARow = YellowRow) then
        brush.Color := $80FFFF;

      if gdSelected in State then
        brush.Color := brush.Color - $101060;

      while true do
      begin
        if (ARow = PastBorder) then
        begin
          case ACol of
            0:
              if gdSelected in State then
                TextRect(Rect, Rect.left + 5, Rect.top, '»')
              else
                TextRect(Rect, Rect.left + 5, Rect.top, '');
            1:
              Draw(Rect.left, Rect.top, SymbolRohstoffe.Symbol('Past')); // Bild
            3:
              begin
                font.size := 9;
                font.style := [fsbold, fsunderline];
                font.Color := clred;
                TextRect(Rect, Rect.left + 5, Rect.bottom - TextHeight('X') - 4,
                  'Besucher, aktuell im Werk:');
                font.Color := clblack;
                font.style := [];
                font.size := 16;
              end;
            5:
              if (Symbol <> csyMarker) then
                TextRect(Rect, Rect.left + 5, Rect.top, 'kein Marker!')
              else
                FillRect(Rect);
          else
            FillRect(Rect);
          end;
          break;
        end;

        if (ARow = FutureBorder) then
        begin
          case ACol of
            0:
              if gdSelected in State then
                TextRect(Rect, Rect.left + 5, Rect.top, '»')
              else
                TextRect(Rect, Rect.left + 5, Rect.top, '');
            1:
              Draw(Rect.left, Rect.top, SymbolRohstoffe.Symbol('Future'));
              // Bild
            3:
              begin
                font.size := 9;
                font.style := [fsbold, fsunderline];
                font.Color := clListeFuture;
                TextRect(Rect, Rect.left + 5, Rect.bottom - TextHeight('X') - 4,
                  'Besuchsplanung:');
                font.Color := clblack;
                font.style := [];
                font.size := 16;
              end;
            5:
              if Symbol <> csyMarker then
                TextRect(Rect, Rect.left + 5, Rect.top, 'kein Marker!')
              else
                FillRect(Rect);
          else
            FillRect(Rect);
          end;
          break;
        end;

        case ACol of
          0:
            if gdSelected in State then
              TextRect(Rect, Rect.left + 5, Rect.top, '»')
            else
              TextRect(Rect, Rect.left + 5, Rect.top, '');
          1:
            begin

              repeat

                if (ARow < PastBorder) then
                begin
                  SymbolColor := cscGray;
                  break;
                end;

                if (ARow > FutureBorder) then
                begin
                  if RepetierendBis = 0 then
                    SymbolColor := cscLogo
                  else
                    SymbolColor := cscRobot;

                  break;
                end;

                if Green then
                  SymbolColor := cscGreen
                else
                  SymbolColor := cscRed;

              until true;

              if (Symbol <> csyMarker) then
              begin
                Draw(Rect.left, Rect.top, GetSymbol(SymbolColor, brush.Color));
                // Bild
              end
              else
              begin
                brush.Color := clyellow;
                FillRect(Rect);
              end;
            end;
          2:
            begin
              while true do
              begin

                if (ARow < PastBorder) or (ARow > FutureBorder) then
                begin
                  font.size := 9;
                  font.style := [fsbold];
                  TextRect(Rect, Rect.left + 5, Rect.top, long2date8(sDatum));

                  font.style := [];
                  TextOut(Rect.left + 5, Rect.top + (rYl(Rect) div 2),
                    secondstostr5(BesuchsDauer) + ' h');
                  font.size := 16;
                  break;
                end;

                TextRect(Rect, Rect.left + 8, Rect.top, RestTimeStr);
                brush.Color := clblue;
                WaitRect := Classes.Rect(Rect.left + 8,
                  Rect.top + rYl(Rect) - 6, Rect.left + rXL(Rect) - 12,
                  Rect.top + rYl(Rect) - 2);
                rPercent(RestSeconds, 60.0, WaitRect);
                FillRect(WaitRect);
                break;

              end;
            end;
          3:
            begin
              font.size := 9;
              font.style := [fsbold];
              if pos(cMitarbeiter, Firma) = 1 then
              begin
                _brush_color := brush.Color;
                brush.Color := clMitarbeiter;
              end;
              while true do
              begin
                if (Anzahl = 1) then
                  _FirstLine := BesucherName
                else
                  _FirstLine := inttostr(Anzahl) + 'x ' + BesucherName;

                if (Parken = cpePermission) or
                  (Symbol in [csyCar, csyKombi, csyBus, csyPritsche, csyLKW]) or
                  (Grund = cAnlieferung) then
                  _FirstLine := cutblank(Kennzeichen + ' ' + _FirstLine);
                break;
              end;

              TextRect(Rect, Rect.left + 5, Rect.top, _FirstLine);

              font.style := [];
              TextOut(Rect.left + 5, Rect.top + (rYl(Rect) div 2), Firma);
              font.size := 16;

              if pos(cMitarbeiter, Firma) = 1 then
              begin
                brush.Color := _brush_color;
                framerect(Rect);
              end;
            end;
          4:
            begin
              font.size := 9;
              TextRect(Rect, Rect.left + 5, Rect.top, secondstostr(sZeit));
              TextOut(Rect.left + 5, Rect.top + (rYl(Rect) div 2),
                secondstostr(eZeit));
              font.size := 16;
            end;
          5:
            begin
              k := pos('#', Mitarbeiter);
              if k > 0 then
              begin
                TextRect(Rect, Rect.left + 5, Rect.top,
                  copy(Mitarbeiter, 1, pred(k)) + ' ...');
              end
              else
              begin
                TextRect(Rect, Rect.left + 5, Rect.top, Mitarbeiter);
              end;
            end;
          6:
            begin
              font.size := 9;
              font.style := [fsbold];
              FillRect(Rect);

              if (ARow < FutureBorder) then
              begin
                if (PforteEin > 0) then
                  Draw(Rect.left, Rect.top, GetPforteSymbol(PforteEin));
                TextOut(Rect.left + PfortenSymbols[0].width + 3, Rect.top,
                  PfoertnerEin);
              end;

              if (ARow < PastBorder) then
              begin
                if (PforteAus > 0) then
                  Draw(Rect.left, Rect.top + (rYl(Rect) div 2),
                    GetPforteSymbol(PforteAus));
                TextOut(Rect.left + PfortenSymbols[0].width + 3,
                  Rect.top + (rYl(Rect) div 2), PfoertnerAus);
              end;
              font.style := [];
              font.size := 16;
            end;
        end;
        break;
      end;
    end;
end;

procedure TBesucherListeForm.FormCreate(Sender: TObject);
var
  n, m, X, Y: integer;
  AllePfortenSymbols: TStringList;
  GrundSymbol: TBitMap;
  NewSymbol: TBitMap;
  NewFarbe: TColor;
begin
  Label9.caption := 'gateF Rev. ' + RevToStr(globals.Version);
  SavedItem := TLineRec.create;
  top := 0;
  left := 0;
  height := 768 - 28;
  width := 1024;
  Color := $E0F0F0;
  YellowRow := -1;

  // Listen-Ende und Anfang
  SymbolRohstoffe := TSymbolPool.create(MyProgramPath + cSystemPath + 'Alles');

  // Pforten-Symbole laden
  AllePfortenSymbols := TStringList.create;
  dir(MyProgramPath + cSystemPath + cTorMask + '*.bmp', AllePfortenSymbols);

  SetLength(PfortenSymbols, AllePfortenSymbols.Count);
  AllePfortenSymbols.Sort;
  for n := 0 to pred(AllePfortenSymbols.Count) do
  begin
    PfortenSymbols[n] := TBitMap.create;
    PfortenSymbols[n].LoadFromFile(MyProgramPath + cSystemPath +
      AllePfortenSymbols[n]);
  end;
  AllePfortenSymbols.free;

  clCursorGrau := SymbolRohstoffe.Symbol('L0').canvas.pixels[0, 0];
  clListeRot := SymbolRohstoffe.Symbol('B0').canvas.pixels[0, 0];
  clListeGruen := SymbolRohstoffe.Symbol('B1').canvas.pixels[0, 0];
  clListeGrau := SymbolRohstoffe.Symbol('B2').canvas.pixels[0, 0];
  clListeFuture := SymbolRohstoffe.Symbol('B3').canvas.pixels[0, 0];
  clListeRobot := SymbolRohstoffe.Symbol('B4').canvas.pixels[0, 0];

  // verschieden farbige Symbole aus der Vorlage erzeugen

  for m := 0 to 8 do // symbole
  begin
    GrundSymbol := SymbolRohstoffe.Symbol('P' + inttostr(m));
    for n := 0 to 4 do // farben
    begin
      // 1. aus dem Grund-Symbol kopieren
      NewSymbol := TBitMap.create;
      NewSymbol.assign(GrundSymbol);
      case n of
        0:
          NewFarbe := clListeRot;
        1:
          NewFarbe := clListeGruen;
        2:
          NewFarbe := clListeGrau;
        3:
          NewFarbe := clListeFuture;
        4:
          NewFarbe := clListeRobot;
      end;

      for X := 0 to pred(NewSymbol.width) do
        for Y := 0 to pred(NewSymbol.height) do
          if NewSymbol.canvas.pixels[X, Y] = clblack then
            NewSymbol.canvas.pixels[X, Y] := NewFarbe;

      SymbolRohstoffe.InsertSymbol('P' + inttostr(m) + inttostr(n), NewSymbol);
    end;
  end;

  with DrawGrid1, canvas do
  begin
    DefaultRowHeight := 32;
    font.Name := 'Verdana';
    font.size := 16;
    font.Color := clblack;
    ColCount := 7;
    ColWidths[0] := 21; // Pfeil
    ColWidths[1] := 85; // Symbol
    ColWidths[2] := 80; // Zeit
    ColWidths[3] := 230;
    ColWidths[4] := 65;
    ColWidths[5] := 380;
    ColWidths[6] := ClientWidth - (ColWidths[0] + ColWidths[1] + ColWidths[2] +
      ColWidths[3] + ColWidths[4] + ColWidths[5]);
    ClientHeight := DefaultRowHeight * 21;
  end;

  // Das 1. Border Symbol erzeugen
  NewSymbol := TBitMap.create;
  NewSymbol.width := DrawGrid1.ColWidths[1];
  NewSymbol.height := DrawGrid1.DefaultRowHeight;
  NewSymbol.canvas.brush.Color := clListeGrau;
  NewSymbol.canvas.FillRect(Rect(0, 0, NewSymbol.width,
    NewSymbol.height div 2));
  NewSymbol.canvas.brush.Color := clListeGruen;
  NewSymbol.canvas.FillRect(Rect(0, NewSymbol.height div 2,
    NewSymbol.width div 2, NewSymbol.height));
  NewSymbol.canvas.brush.Color := clListeRot;
  NewSymbol.canvas.FillRect(Rect(NewSymbol.width div 2, NewSymbol.height div 2,
    NewSymbol.width, NewSymbol.height));
  SymbolRohstoffe.InsertSymbol('Past', NewSymbol);

  // Das 2. Border Symbol erzeugen
  NewSymbol := TBitMap.create;
  NewSymbol.width := DrawGrid1.ColWidths[1];
  NewSymbol.height := DrawGrid1.DefaultRowHeight;
  NewSymbol.canvas.brush.Color := clListeFuture;
  NewSymbol.canvas.FillRect(Rect(0, NewSymbol.height div 2, NewSymbol.width,
    NewSymbol.height));
  NewSymbol.canvas.brush.Color := clListeGruen;
  NewSymbol.canvas.FillRect(Rect(0, 0, NewSymbol.width div 2,
    NewSymbol.height div 2));
  NewSymbol.canvas.brush.Color := clListeRot;
  NewSymbol.canvas.FillRect(Rect(NewSymbol.width div 2, 0, NewSymbol.width,
    NewSymbol.height div 2));
  SymbolRohstoffe.InsertSymbol('Future', NewSymbol);

  Items := TLineList.create;
  if (iPforteID <= length(PfortenSymbols)) then
  begin
    Image2.picture.assign(GetPforteSymbol(iPforteID));
  end
  else
  begin
    with Image2.picture.bitmap do
    begin
      height := Image2.height;
      width := Image2.width;
      canvas.brush.Color := Panel4.Color;
      canvas.FillRect(Rect(0, 0, width, height));
      canvas.TextOut(0, 0, 'T' + inttostr(iPforteID));
    end;
  end;
  Label13.caption := iPfoertnerKurzBez;
  Image3.width := (Image3.width div length(PfortenSymbols)) *
    length(PfortenSymbols);
  LetzeVergebeneTRN := pred(GetTRN);
  if iTransActionServer then
  begin
    if not(FileExists(MyProgramPath + cListeFName)) then
      if doit('Soll die Besucherliste neu angelegt werden?' + #13 +
        'ALLE aktuellen Besucherdaten werden dadurch GELÖSCHT!' + #13 +
        'Wählen Sie <abbrechen> wenn Sie unsicher sind!' + #13 +
        'Jetzt (liste.ini) neu anlegen') then
        FileEmpty(MyProgramPath + cListeFName);
    FileSetAttr(MyProgramPath + cListeFName, faReadOnly);
  end;
  LoadFileData;
  SetListCursorToHeute;
end;

procedure TBesucherListeForm.FormDestroy(Sender: TObject);
var
  n: integer;
begin
  FileDelete(MyPforteUpFName);
  Items.free;
  for n := 0 to pred(length(PfortenSymbols)) do
    PfortenSymbols[n].free;
  SetLength(PfortenSymbols, 0);
  SavedItem.free;
  SymbolRohstoffe.free;
end;

procedure TBesucherListeForm.LoadFileData;
begin
  LastFileTime := FileAge(MyProgramPath + cListeFName);
  Items.LoadFromFile(MyProgramPath + cListeFName);
  inc(CountIniLoaded);
  Label7.caption := inttostr(CountIniLoaded);
  SortBesucher;
  ShowBesucher;
end;

procedure TBesucherListeForm.ReBuildPfortenInfo;
var
  AllPforten: TStringList;
  n: integer;
  PfortenActive: array of boolean;

  _PfortenIDchar: Char;
  _PforteDetected: integer;
begin
  SetLength(PfortenActive, length(PfortenSymbols));
  for n := 0 to pred(length(PfortenSymbols)) do
    PfortenActive[n] := false;

  // Pfad-Info einholen
  AllPforten := TStringList.create;
  dir(MyProgramPath + 'T? aktiv.ini', AllPforten);
  for n := 0 to pred(AllPforten.Count) do
  begin
    _PfortenIDchar := AllPforten[n][2];
    if _PfortenIDchar in ['0' .. '9'] then
    begin
      _PforteDetected := pred(strtoint(_PfortenIDchar));
      if _PforteDetected in [0 .. pred(length(PfortenSymbols))] then
        PfortenActive[_PforteDetected] := true;
    end;
  end;

  // Bildchen zeichnen
  with Image3.picture.bitmap do
  begin
    width := Image3.width;
    height := Image3.height;
    with canvas do
      for n := 0 to pred(length(PfortenSymbols)) do
      begin
        if PfortenActive[n] then
          brush.Color := PfortenSymbols[n].canvas.pixels[0, 0]
        else
          brush.Color := clsilver;
        FillRect(Rect(n * (width div length(PfortenSymbols)), 0,
          (n + 1) * (width div length(PfortenSymbols)), height));
      end;
  end;
  AllPforten.free;
end;

procedure TBesucherListeForm.Timer1Timer(Sender: TObject);
var
  OldTRN: integer;
  JustLoaded: boolean;
  _FileAttr: integer;
begin
  if AppGoDown then
    exit;

  if FileExists(MyProgramPath + 'stop.txt') then
    close;

  if active then
  begin

    if frequently(UpCheckTime, 15000) then
    begin
      ReBuildPfortenInfo;
      Panel5.caption := long2date(GetPfortenDate);
    end;

    JustLoaded := false;

    _FileAttr := FileGetAttr(MyProgramPath + cListeFName);
    if (_FileAttr <> -1) then
      if ((_FileAttr and faReadOnly) = faReadOnly) then
        if (LastFileTime <> FileAge(MyProgramPath + cListeFName)) then
        begin
          OldTRN := Items[DrawGrid1.Row].TRNid;
          LoadFileData;
          SetListCursorTo(OldTRN);
          JustLoaded := true;
        end;

    if not(JustLoaded) then
      DrawGrid1.refresh;

    Button4.enabled := (DrawGrid1.Row <> succ(PastBorder));
  end;
end;

procedure TBesucherListeForm.FormPaint(Sender: TObject);
begin
  with canvas do
  begin
    brush.Color := clblack;
    framerect(RectFromControl(DrawGrid1));
  end;
end;

procedure TBesucherListeForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Key := #0;
    close;
  end;
end;

function TBesucherListeForm.GetPfortenTime: TAnfixTime;
begin
  if iRealTime then
    result := SecondsGet
  else
    result := strtoseconds(iStatischeZeit);
end;

function TBesucherListeForm.GetPfortenDate: TAnfixDate;
begin
  if iRealTime then
    result := DateGet
  else
    result := date2long(iStatischesDatum);
end;

procedure TBesucherListeForm.DrawGrid1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  ACol: integer;
begin
  if Button = mbright then
  begin
    DrawGrid1.MouseToCell(X, Y, ACol, SelectedRow);
    DrawGrid1.Row := SelectedRow;
    ContextPopUp(DrawGrid1.left + X, DrawGrid1.top + Y);
  end;
end;

procedure TBesucherListeForm.SortBesucher;
var
  n: integer;
  Marker: TLineRec;
  ToDeleteIDs: TList;
  ToDeleteID: integer;
begin

  Items.DoSort;

  // alte Marker löschen
  ToDeleteIDs := TList.create;

  // marker suchen, und aus der Liste löschen
  for n := 0 to pred(Items.Count) do
    if (Items[n].Symbol = csyMarker) then
      ToDeleteIDs.add(pointer(n));

  // marker nun löschen, von Hinten,
  // damit sich die index-Werte nicht verschieben
  for n := pred(ToDeleteIDs.Count) downto 0 do
  begin
    ToDeleteID := integer(ToDeleteIDs[n]);
    Items[ToDeleteID].free;
    Items.delete(ToDeleteID);
  end;

  ToDeleteIDs.free;

  // Marker "PAST" einfügen... (werden nicht abgespeichert)
  PastBorder := -1;
  Marker := TLineRec.create;
  Marker.LoadFromString('4;;;;;Im Haus...;;;0;0;KA;PF;1;;;1');
  for n := 0 to pred(Items.Count) do
    if (Items[n].PforteStatus > psComplete) then
    begin
      Items.Insert(n, pointer(Marker));
      PastBorder := n;
      break;
    end;
  if (PastBorder = -1) then
  begin
    // uups, alles ist Historie!!!
    PastBorder := Items.Count;
    Items.Insert(PastBorder, pointer(Marker));
  end;

  // Marker "FUTURE" einfügen
  FutureBorder := -1;
  Marker := TLineRec.create;
  Marker.LoadFromString('4;;;;;In Planung...;;;1;2;KA;PF;1;;;2');
  for n := 0 to pred(Items.Count) do
    if (Items[n].Symbol <> csyMarker) then
      if (Items[n].PforteStatus > psInHouse) then
      begin
        Items.Insert(n, pointer(Marker));
        FutureBorder := n;
        break;
      end;
  if (FutureBorder = -1) then
  begin
    FutureBorder := Items.Count;
    Items.Insert(FutureBorder, pointer(Marker));
  end;
  DrawGrid1.RowCount := Items.Count;
end;

procedure TBesucherListeForm.SetListCursorToHeute;
begin
  with DrawGrid1 do
  begin
    TopRow := PastBorder;
    Row := succ(PastBorder);
  end;
end;

procedure TBesucherListeForm.ShowBesucher;
var
  GreenInHouse: integer;
  RedInHouse: integer;
  n: integer;
begin
  GreenInHouse := 0;
  RedInHouse := 0;
  for n := succ(PastBorder) to pred(FutureBorder) do
    if Items[n].Green then
      inc(GreenInHouse, Items[n].Anzahl)
    else
      inc(RedInHouse, Items[n].Anzahl);
  Label2.caption := inttostr(GreenInHouse);
  Label1.caption := inttostr(RedInHouse);
  DrawGrid1.refresh;
end;

procedure TBesucherListeForm.Button4Click(Sender: TObject);
begin
  SetListCursorToHeute;
  DrawGrid1.SetFocus;
end;

procedure TBesucherListeForm.EndeClickClick(Sender: TObject);
begin
  RausBesucher(SelectedRow, false);
end;

procedure TBesucherListeForm.AddMinutes(s: TAnfixTime);
var
  _OldData: string;
begin
  if (SelectedRow > PastBorder) and (SelectedRow < FutureBorder) then
  begin
    with Items[SelectedRow] do
    begin
      _OldData := SaveToString;
      eZeit := secondsadd(GetPfortenTime, s);
      eDatum := GetPfortenDate;
      GeaendertDurch := iPfoertnerKurzBez;
      FormTransaction.StoreTransaktion(MF_Change, _OldData, SaveToString);
    end;
    ShowBesucher;
  end
  else
  begin
    beep;
  end;
end;

procedure TBesucherListeForm.noch10min1Click(Sender: TObject);
begin
  AddMinutes(strtoseconds('00:10'));
end;

procedure TBesucherListeForm.NewClickClick(Sender: TObject);
begin
  NewBesucher(SelectedRow);
end;

function TBesucherListeForm.GetPforteSymbol(n: integer): TBitMap;
begin
  result := PfortenSymbols[pred(n)];
end;

procedure TBesucherListeForm.Label13Click(Sender: TObject);
begin
  BenutzerWechselForm.top := Panel3.top + Panel3.height;
  BenutzerWechselForm.left := Panel3.left;
  BenutzerWechselForm.Color := Panel3.Color;
  BenutzerWechselForm.show;
end;

procedure TBesucherListeForm.NeuerAnwender(const s: string);
var
  OutF: TextFile;
begin
  iPfoertnerKurzBez := s;
  Label13.caption := iPfoertnerKurzBez;
  AssignFile(OutF, LetzerBenutzerFName);
  rewrite(OutF);
  writeln(OutF, iPfoertnerKurzBez);
  writeln(OutF, UserName + ' auf ' + ComputerName + ' mit gateF Rev. ' +
    RevToStr(Version));
  CloseFile(OutF);
end;

procedure TBesucherListeForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  // ALT &
  if (ssAlt in Shift) then
    case Key of
      ord('L'):
        Label13Click(Sender); // Login
      ord('P'):
        begin
          FillPrinterData(DrawGrid1.Row);
          PrintViewForm.show;
        end;
      ord('S'):
        FormSystemPasswort.show;
      // SystemSettingsForm.show;
      ord('D'):
        PrintBesucher(DrawGrid1.Row);
      ord('I'):
        VerbindungITForm.show;
      ord('B'):
        begin
          BarCode := inttostr(Items[DrawGrid1.Row].BesucherID);
        end;
      ord('V'):
        BesucherPflegeForm.show;
      ord('W'):
        BesucherSucheForm.show;
      ord('T'):
        FormTransaction.show;
      ord('M'):
        ;
      ord('K'):
        begin
          AnonymousMode := true;
          NewBesucher(DrawGrid1.Row);
        end;
    end;

  // nur die Taste!
  if Shift = [] then
    case Key of
      ord('1'):
        ;
      (*
        with FormBarCodeView do
        begin
        edit1.Text := '';
        show;
        edit1.SetFocus;
        edit1.SelLength := -1;
        end;
      *)
      VK_APPS:
        begin
          SelectedRow := DrawGrid1.Row;
          ContextPopUp(0, 0);
        end;
      VK_DELETE:
        RausBesucher(DrawGrid1.Row, false);
      VK_INSERT:
        NewBesucher(DrawGrid1.Row);
      VK_RETURN:
        ListeEnterPressed(DrawGrid1.Row);
      {
        ord('I'):if (DrawGrid1.row<>PastBorder) and (DrawGrid1.row<>FutureBorder) then
        with items[DrawGrid1.row] do
        ShowMessage('Pforteninfo:'+#13+#13+
        inttostr(PforteEin)+':'+PfoertnerEin+#13+
        inttostr(PforteAus)+':'+PfoertnerAus);
      }
      VK_F1:
        begin
          BesucherSucheForm.AuskunftModus := true;
          BesucherSucheForm.show;
        end;

      VK_F2:
        BesucherSucheForm.show;
      VK_F3:
        PrintBesucher(DrawGrid1.Row);
      VK_F4:
        begin
          MitarbeiterSucheForm.edit1.Text := '';
          MitarbeiterSucheForm.show;
        end;
      VK_F5:
        begin
          BarcodeAutoMode := not(BarcodeAutoMode);
          if BarcodeAutoMode then
          begin
            Label8.caption := 'F5-BARCODE AUTOMATIK';
            Label8.font.Color := clgreen
          end
          else
          begin
            Label8.caption := 'F5-Barcode Automatik';
            Label8.font.Color := clblack;
          end;
        end;
    end;

  // Shift
  if ssCtrl in Shift then
    case Key of
      VK_F5:
        ; (* FormBarCodeScanner.show; *)
      VK_DELETE:
        if (DrawGrid1.Row <> PastBorder) and
          (DrawGrid1.Row <> FutureBorder) then
        begin
          Items[DrawGrid1.Row].GeaendertDurch := iPfoertnerKurzBez;
          FormTransaction.StoreTransaktion(MF_Delete,
            Items[DrawGrid1.Row].SaveToString);
          Items.delete(DrawGrid1.Row);
          SortBesucher;
          SetListCursorToHeute;
          ShowBesucher;
        end;
    end;
end;

procedure TBesucherListeForm.NewBesucher(SelectedRow: integer);
var
  NewLine: TLineRec;
begin
  if (SelectedRow < PastBorder) then
  begin
    BesucherListeForm.SelectedRow := SelectedRow;
    BesuchaktuellClick(self);
  end
  else
  begin
    NewLine := TLineRec.create;
    with NewLine do
    begin
      if (SelectedRow < FutureBorder) then
      begin
        // Drucker aufwärmen
        PrintViewForm.WarmUp;

        // hey neuer Besuch
        sDatum := GetPfortenDate;
        eDatum := sDatum;
        sZeit := GetPfortenTime;
        eZeit := eZeitDefault;
        PforteEin := iPforteID;
        PfoertnerEin := iPfoertnerKurzBez;
      end
      else
      begin
        // Planung!
        sDatum := DatePlus(GetPfortenDate, 1);
        eDatum := sDatum;
        sZeit := strtoseconds('09:00');
        eZeit := eZeitDefault;
      end;
      Anzahl := 1;
      Land := 'DE';
    end;
    NewLine.CopyTo(SavedItem);
    SaveDataToDialog(NewLine);
    NewLine.free;
    WillkommenForm.show;
    if (SelectedRow < FutureBorder) then
    begin
      WillkommenForm.Edit3.SetFocus;
    end
    else
    begin
      WillkommenForm.Edit9.SetFocus;
    end;
    if AnonymousMode then
    begin
      WillkommenForm.Edit8.SetFocus;
      AnonymousMode := false;
    end;
  end;
end;

procedure TBesucherListeForm.Panel3Click(Sender: TObject);
begin
  Label13.OnClick(Sender);
end;

procedure TBesucherListeForm.RausBesucher(SelectedRow: integer;
  AutoModus: boolean);
begin

  while true do
  begin

    if (SelectedRow > PastBorder) and (SelectedRow < FutureBorder) then
    begin
      // Besucher im Haus verlässt das Gebäude
      YellowRow := SelectedRow;
      if (SelectedRow - DrawGrid1.TopRow < 15) then
      begin
        AufWiedersehenForm.top := DrawGrid1.top + DrawGrid1.CellRect(1,
          SelectedRow).bottom;
        AufWiedersehenForm.left := DrawGrid1.left + DrawGrid1.CellRect(1,
          SelectedRow).left;
      end
      else
      begin
        AufWiedersehenForm.top := DrawGrid1.top + DrawGrid1.CellRect(1,
          SelectedRow).bottom -
          (AufWiedersehenForm.height + DrawGrid1.DefaultRowHeight);
        AufWiedersehenForm.left := DrawGrid1.left + DrawGrid1.CellRect(1,
          SelectedRow).left;
      end;

      AufWiedersehenForm.Label1.caption := Items[SelectedRow].BesucherName +
        ' beendet den Besuch ...';
      AufWiedersehenForm.TRNid := Items[SelectedRow].TRNid;
      AufWiedersehenForm.SelectedRow := SelectedRow;
      AufWiedersehenForm.Label6.caption := Items[SelectedRow].Nachricht;
      AufWiedersehenForm.show;
      if AutoModus then
        AufWiedersehenForm.Button1Click(self);
      break;
    end;

    if (SelectedRow > FutureBorder) then
    begin
      // Besuchersplanung wird gelöscht
      YellowRow := SelectedRow;
      if (SelectedRow - DrawGrid1.TopRow < 17) then
      begin
        PlanungLoeschenForm.top := DrawGrid1.top + DrawGrid1.CellRect(1,
          SelectedRow).bottom;
        PlanungLoeschenForm.left := DrawGrid1.left + DrawGrid1.CellRect(1,
          SelectedRow).left;
      end
      else
      begin
        PlanungLoeschenForm.top := DrawGrid1.top + DrawGrid1.CellRect(1,
          SelectedRow).bottom -
          (PlanungLoeschenForm.height + DrawGrid1.DefaultRowHeight);
        PlanungLoeschenForm.left := DrawGrid1.left + DrawGrid1.CellRect(1,
          SelectedRow).left;
      end;

      PlanungLoeschenForm.Label1.caption := Items[SelectedRow].BesucherName +
        ' aus Besuchsplanung löschen ...';
      PlanungLoeschenForm.SelectedRow := SelectedRow;
      PlanungLoeschenForm.show;
      break;
    end;

    break;
  end;
end;

procedure TBesucherListeForm.DeleteBesucher(SelectedRow: integer;
  EntlassDatum: TAnfixDate; EntlassZeit: TAnfixTime);
var
  _OldData: string;
begin
  if (SelectedRow < FutureBorder) then
  begin
    with Items[SelectedRow] do
    begin
      _OldData := SaveToString;
      PforteAus := iPforteID;
      PfoertnerAus := iPfoertnerKurzBez;
      eZeit := EntlassZeit;
      eDatum := EntlassDatum;
      GeaendertDurch := iPfoertnerKurzBez;
      FormTransaction.StoreTransaktion(MF_Change, _OldData, SaveToString);
    end;
  end
  else
  begin
    Items[SelectedRow].GeaendertDurch := iPfoertnerKurzBez;
    FormTransaction.StoreTransaktion(MF_Delete,
      Items[SelectedRow].SaveToString);
    Items.delete(SelectedRow);
  end;
  SortBesucher;
  ShowBesucher;
end;

procedure TBesucherListeForm.DeleteBesucherByTRN(Trn: integer;
  EntlassDatum: TAnfixDate; EntlassZeit: TAnfixTime);
var
  n: integer;
  WasFound: boolean;
begin
  // Eintrag suchen
  WasFound := false;
  for n := 0 to pred(Items.Count) do
    if (Items[n].TRNid = Trn) then
    begin
      DeleteBesucher(n, EntlassDatum, EntlassZeit);
      WasFound := true;
      break;
    end;
  if not(WasFound) then
    ShowMessage('Datensatz inzwischen gelöscht!');
end;

procedure TBesucherListeForm.PrintBesucher(SelectedRow: integer);
begin
  repeat

    if (Items[SelectedRow].TRNid = LastPrintedTRNid) then
      if not(doit('Wollen Sie den Besucherschein jetzt nochmals drucken')) then
        break;

    LastPrintedTRNid := Items[SelectedRow].TRNid;

    FillPrinterData(SelectedRow);
    PrintViewForm.AllesClick(self);
  until true;
end;

procedure TBesucherListeForm.DruckenClickClick(Sender: TObject);
begin
  PrintBesucher(SelectedRow);
end;

procedure TBesucherListeForm.FillPrinterData(SelectedRow: integer);
var
  LastMitarbeiter: integer;
  BigStr: string;
  _BisDatum: TAnfixDate;

  function nextp: string;
  var
    k: integer;
  begin
    k := pos('#', BigStr);
    if k = 0 then
    begin
      result := BigStr;
      BigStr := '';
    end
    else
    begin
      result := copy(BigStr, 1, pred(k));
      delete(BigStr, 1, k);
    end;
  end;

begin
  with Items[SelectedRow] do
  begin
    PrintViewForm.ClearData;
    PrintViewForm.drvName := BesucherName;
    PrintViewForm.drvFirma := Firma;
    BigStr := Mitarbeiter;
(*
    PrintViewForm.drvTabelle[1, 1] := secondstostr5(sZeit) + '(' +
      PfoertnerEin + ')';
*)
    PrintViewForm.drvTabelle[1, 1] := secondstostr5(sZeit) ;
    LastMitarbeiter := 0;
    repeat
      inc(LastMitarbeiter);
      PrintViewForm.drvTabelle[0, LastMitarbeiter] := nextp;
    until (BigStr = '');
    PrintViewForm.drvTabelle[2, LastMitarbeiter] := secondstostr5(eZeit);
    if (RepetierendBis <> 0) then
    begin
      _BisDatum := eDatum;
      while (WeekDay(_BisDatum) <> 5) do
        _BisDatum := DatePlus(_BisDatum, 1);

      _BisDatum := min(_BisDatum, RepetierendBis);
      PrintViewForm.drvGueltig := 'gültig bis ' + long2date(_BisDatum);
    end
    else
    begin
      PrintViewForm.drvGueltig := 'gültig bis ' + long2date(eDatum) + ' ' +
        secondstostr5(eZeit);
    end;

    if FileExists(BMPFname) then
    begin
      PrintViewForm.drvUnterschrift.LoadFromFile(BMPFname);
      BMPscramble(PrintViewForm.drvUnterschrift, KeyFromFName(BMPFname));
    end
    else
    begin
      PrintViewForm.drvUnterschrift.height := 0;
      PrintViewForm.drvUnterschrift.width := 0;
    end;

    PrintViewForm.drvKennzeichen := Kennzeichen;
    PrintViewForm.drvID := 'ID-' + inttostr(TRNid) + '-' + iPfoertnerKurzBez;
    PrintViewForm.drvPforteInfo := 'T' + inttostr(PforteEin);

    if (Anrede = 'Frau') or (Anrede = 'Herr') then
      PrintViewForm.drvAnrede := Anrede
    else
      PrintViewForm.drvAnrede := '';

    PrintViewForm.drvParken := (Parken = cpePermission);
    PrintViewForm.drvHandy := Handy;
    PrintViewForm.drvMitgebracht := Mitgebracht;
    PrintViewForm.drvLanguage := Land;
    PrintViewForm.drvBarCode := inttostr(BesucherID);

    PrintViewForm.CheckBoxRahmen.checked := false;
    PrintViewForm.CheckBoxLogos.checked := false;
    PrintViewForm.CheckBoxDruck.checked := true;
  end;
end;

procedure TBesucherListeForm.SaveDataToDialog(src: TLineRec);
var
  BigStr: string;
  TMPbmp: TBitMap;

  function nextp: string;
  var
    k: integer;
  begin
    k := pos('#', BigStr);
    if k = 0 then
    begin
      result := BigStr;
      BigStr := '';
    end
    else
    begin
      result := copy(BigStr, 1, pred(k));
      delete(BigStr, 1, k);
    end;
  end;

begin
  with src do
  begin
    WillkommenForm.DoNotSearch := true;
    WillkommenForm.ListView1.Items.Clear;
    WillkommenForm.Edit9.Text := long2date(sDatum);
    WillkommenForm.Edit2.Text := cutblank(long2date(RepetierendBis));
    if (sDatum <> 0) then
      WillkommenForm.MonthCalendar1.Date := long2datetime(sDatum) // TmonthCal
    else
      WillkommenForm.MonthCalendar1.Date := long2datetime(GetPfortenDate);

    WillkommenForm.Edit10.Text := secondstostr5(sZeit);
    WillkommenForm.label35.caption := long2date(eDatum);
    WillkommenForm.edit1.Text := Land;
    WillkommenForm.ComboBox1.Text := Anrede;
    WillkommenForm.SpinEdit1.Text := inttostr(Anzahl);
    WillkommenForm.Checkbox1.checked := (Parken = cpePermission);
    WillkommenForm.Edit3.Text := BesucherName;
    WillkommenForm.Edit6.Text := Firma;
    WillkommenForm.Edit8.Text := Kennzeichen;
    WillkommenForm.ListBox1.Items.Clear;
    if (Mitarbeiter <> '') then
    begin
      BigStr := Mitarbeiter;
      repeat
        WillkommenForm.ListBox1.Items.add(nextp);
      until (BigStr = '');
    end;
    WillkommenForm.ComboBox4.Text := Grund;
    WillkommenForm.edit11.Text := Mitgebracht;
    WillkommenForm.Edit5.Text := Handy;
    WillkommenForm.Label17.caption := secondstostr5(eZeit);
    WillkommenForm.Label18.caption := inttostr(TRNid);
    WillkommenForm.Label23.caption := GeaendertDurch;
    WillkommenForm.Label30.caption := inttostr(BesucherID);
    WillkommenForm.Label33.caption := '';
    WillkommenForm.edit7.Text := Nachricht;
    WillkommenForm._PforteEin := PforteEin;
    WillkommenForm._PforteAus := PforteAus;
    WillkommenForm._PfoertnerEin := PfoertnerEin;
    WillkommenForm._PfoertnerAus := PfoertnerAus;

    WillkommenForm.ClearReferenzUnterschrift;

    if (BesuchsDauer <> 0) then
      WillkommenForm.Combobox3.Text := secondstostr5(BesuchsDauer)
    else
      WillkommenForm.Combobox3.Text := '';

    WillkommenForm.RadioButton1.checked := (Symbol = csyCar);
    WillkommenForm.RadioButton2.checked := (Symbol = csyKombi);
    WillkommenForm.RadioButton3.checked := (Symbol = csyBus);
    WillkommenForm.RadioButton4.checked := (Symbol = csyPritsche);
    WillkommenForm.RadioButton5.checked := (Symbol = csyLKW);
    WillkommenForm.CheckBox5.checked := (Grund = cAnlieferung);
    WillkommenForm.ReBuildFahrzeugAbility;

    if (TRNid <> 0) and FileExists(BMPFname) then
    begin
      TMPbmp := TBitMap.create;
      TMPbmp.LoadFromFile(BMPFname);
      BMPscramble(TMPbmp, KeyFromFName(BMPFname));
      WillkommenForm.LoadUnterschriftBMP(TMPbmp);
      TMPbmp.free;
    end
    else
    begin
      WillkommenForm.LoadUnterschriftBMP(nil);
    end;
    WillkommenForm.DoNotSearch := false;
  end;
end;

procedure TBesucherListeForm.WillkommenOK;
var
  SaverTemp: TLineRec;
  n: integer;
  ToSaveIndex: integer;
  k: integer;
begin
  SaverTemp := TLineRec.create;

  // erst mal alles in einen Zwischen-Record speichern!
  with SaverTemp, WillkommenForm do
  begin
    RepetierendBis := date2long(Edit2.Text);
    sDatum := date2long(Edit9.Text);
    eDatum := date2long(label35.caption);
    sZeit := strtoseconds(Edit10.Text);
    eZeit := strtoseconds(Label17.caption);
    BesucherName := Edit3.Text;
    Firma := Edit6.Text;
    Mitarbeiter := '';
    if (WillkommenForm.ListBox1.Items.Count > 0) then
    begin
      for n := 0 to pred(WillkommenForm.ListBox1.Items.Count) do
        Mitarbeiter := Mitarbeiter + WillkommenForm.ListBox1.Items[n] + '#';
      delete(Mitarbeiter, length(Mitarbeiter), 1);
    end;
    PforteEin := _PforteEin;
    PforteAus := _PforteAus;
    PfoertnerEin := _PfoertnerEin;
    PfoertnerAus := _PfoertnerAus;
    Anzahl := strtoint(SpinEdit1.Text);
    Kennzeichen := AnsiUpperCase(Edit8.Text);
    Land := edit1.Text;
    TRNid := strtoint(Label18.caption);
    Grund := ComboBox4.Text;
    Mitgebracht := edit11.Text;
    Handy := Edit5.Text;
    Anrede := ComboBox1.Text;
    Alarm := casnone;
    BesucherID := str2int(Label30.caption);
    if (edit7.Text <> '') then
    begin
      k := CharCount('!', edit7.Text);
      case k of
        0:
          Alarm := casInfo;
        1:
          Alarm := casAttention;
      else
        Alarm := casStop;
      end;
    end;
    Nachricht := edit7.Text;

    if RadioButton1.checked then
      Symbol := csyCar;
    if RadioButton2.checked then
      Symbol := csyKombi;
    if RadioButton3.checked then
      Symbol := csyBus;
    if RadioButton4.checked then
      Symbol := csyPritsche;
    if RadioButton5.checked then
      Symbol := csyLKW;

    if Checkbox1.checked then
    begin
      // Symbol := csyCar;
      Parken := cpePermission;
    end
    else
    begin
      Parken := cpeNone;
    end;

    if not(Checkbox1.checked) and not(CheckBox5.checked) then
    begin
      Symbol := csyMen;
      if (Anrede = 'Frau') then
        Symbol := csyWoman;
      if (Anrede = 'Gruppe') then
        Symbol := csyGroup;
    end;

  end;

  if (SaverTemp.TRNid = 0) then
  begin

    // Neuanlage
    LastNewTRNid := NewTrn;
    SaverTemp.TRNid := LastNewTRNid;
    SaverTemp.GeaendertDurch := iPfoertnerKurzBez;
    if SaverTemp.BesucherID = 0 then
      SaverTemp.BesucherID := SaverTemp.TRNid;
    Items.Insert(0, pointer(SaverTemp));
    FormTransaction.StoreTransaktion(MF_New, SaverTemp.SaveToString);
    SortBesucher;
    WillkommenForm.SaveUnterschriftAs(SaverTemp.BMPFname);
    VerbindungITForm.ClearActUnterschrift;
    SetListCursorTo(SaverTemp.TRNid);
    ShowBesucher;

  end
  else
  begin

    // erst mal "alten" wieder in der Liste suchen!
    ToSaveIndex := -1;
    for n := 0 to pred(Items.Count) do
      if (SaverTemp.TRNid = Items[n].TRNid) then
      begin
        ToSaveIndex := n;
        break;
      end;

    if (ToSaveIndex <> -1) then
    begin

      { !!!CHANGE!!! }
      if not(SaverTemp.Identisch(SavedItem)) then
      begin
        SaverTemp.GeaendertDurch := iPfoertnerKurzBez;
        if SaverTemp.BesucherID = 0 then
          SaverTemp.BesucherID := SaverTemp.TRNid;
        SaverTemp.CopyTo(Items[ToSaveIndex]);
        FormTransaction.StoreTransaktion(MF_Change, SavedItem.SaveToString,
          SaverTemp.SaveToString);
      end;

      WillkommenForm.SaveUnterschriftAs(SaverTemp.BMPFname);
      SortBesucher;
      SetListCursorTo(SaverTemp.TRNid);

    end
    else
    begin
      ShowMessage('Der Datensatz wurde inzwischen gelöscht!');
    end;
    SaverTemp.free;
  end;
  WillkommenForm.close;
end;

procedure TBesucherListeForm.NeuPlanung1Click(Sender: TObject);
begin
  NewBesucher(SelectedRow);
end;

procedure TBesucherListeForm.ContextPopUp(X, Y: integer);
var
  r: TRect;
  p: TPopupMenu;
begin
  if (SelectedRow <> PastBorder) and (SelectedRow <> FutureBorder) then
  begin

    while true do
    begin

      if SelectedRow < PastBorder then
      begin
        p := HistoriePopup;
        break;
      end;
      if SelectedRow < FutureBorder then
      begin
        p := ImHausPopup;
        break;
      end;

      p := FuturePopup;
      break;
    end;

    if (X = 0) then
    begin
      r := DrawGrid1.CellRect(0, SelectedRow);
      X := r.left + DrawGrid1.left;
      Y := r.top + DrawGrid1.top;
    end;
    inc(X, 10);
    dec(Y, p.Items.Count * 12);
    p.PopUp(X, Y);
  end;
end;

procedure TBesucherListeForm.HistprintClick(Sender: TObject);
begin
  PrintBesucher(SelectedRow);
end;

procedure TBesucherListeForm.FutureprintClick(Sender: TObject);
begin
  PrintBesucher(SelectedRow);
end;

procedure TBesucherListeForm.HistShowClickClick(Sender: TObject);
begin
  ListeEnterPressed(SelectedRow);
end;

procedure TBesucherListeForm.ChangeClickClick(Sender: TObject);
begin
  ListeEnterPressed(SelectedRow);
end;

procedure TBesucherListeForm.ListeEnterPressed(SelectedRow: integer);
begin
  if (SelectedRow <> PastBorder) and (SelectedRow <> FutureBorder) then
  begin
    // Backup the old Data
    Items[SelectedRow].CopyTo(SavedItem);
    // Save Data to Dialog
    SaveDataToDialog(Items[SelectedRow]);
    // Start the Dialog
    if (SelectedRow < PastBorder) then
      WillkommenForm.Button1.enabled := false;
    WillkommenForm.show;
    WillkommenForm.Combobox3.SetFocus;
  end;
end;

procedure TBesucherListeForm.HistRepeatClick(Sender: TObject);
var
  NewItem: TLineRec;
  _BesuchsDauer: integer;
begin
  //
  NewItem := TLineRec.create;
  Items[SelectedRow].CopyTo(NewItem);

  // Daten-Felder zu setzen
  NewItem.PforteEin := 0;
  NewItem.PforteAus := 0;
  LastNewTRNid := NewTrn;
  NewItem.TRNid := LastNewTRNid;
  _BesuchsDauer := NewItem.BesuchsDauer;
  NewItem.sDatum := GetPfortenDate;
  NewItem.sZeit := GetPfortenTime;
  SecondsAddLong(NewItem.sDatum, NewItem.sZeit, _BesuchsDauer, NewItem.eDatum,
    NewItem.eZeit);
  NewItem.GeaendertDurch := iPfoertnerKurzBez;

  // NewItem
  Items.Insert(0, NewItem);
  FormTransaction.StoreTransaktion(MF_New, NewItem.SaveToString);
  SortBesucher;
  SetListCursorTo(NewItem.TRNid);
end;

procedure TBesucherListeForm.BesuchaktuellClick(Sender: TObject);
var
  NewItem: TLineRec;
  _BesuchsDauer: integer;
begin
  //
  NewItem := TLineRec.create;
  Items[SelectedRow].CopyTo(NewItem);

  // Daten-Felder zu setzen
  LastNewTRNid := NewTrn;
  NewItem.TRNid := LastNewTRNid;
  NewItem.PforteEin := iPforteID;
  NewItem.PfoertnerEin := iPfoertnerKurzBez;
  NewItem.PforteAus := 0;
  NewItem.PfoertnerAus := '';

  // Besuchsdauer übernehmen, und neuen Datensatz auch so gestalten
  _BesuchsDauer := NewItem.BesuchsDauer;
  NewItem.sDatum := GetPfortenDate;
  NewItem.sZeit := GetPfortenTime;
  SecondsAddLong(NewItem.sDatum, NewItem.sZeit, _BesuchsDauer, NewItem.eDatum,
    NewItem.eZeit);

  NewItem.GeaendertDurch := iPfoertnerKurzBez;

  // NewItem
  Items.Insert(0, NewItem);
  FormTransaction.StoreTransaktion(MF_New, NewItem.SaveToString);
  SortBesucher;
  if SetListCursorTo(NewItem.TRNid) then
    ListeEnterPressed(DrawGrid1.Row);
end;

procedure TBesucherListeForm.FutureStartClickClick(Sender: TObject);
var
  NewLine: TLineRec;
  SavedItemID: integer;
  n: integer;
  _OldData: string;
begin
  if (SelectedRow > FutureBorder) then
  begin
    // Backup the old Data
    Items[SelectedRow].CopyTo(SavedItem);

    // Save Data to Dialog
    SaveDataToDialog(SavedItem);

    // make Modifikations
    WillkommenForm._PforteEin := iPforteID;
    WillkommenForm._PfoertnerEin := iPfoertnerKurzBez;
    WillkommenForm.Edit9.Text := long2date(GetPfortenDate); // sdatum
    WillkommenForm.label35.caption := long2date(GetPfortenDate); // edatum
    WillkommenForm.Edit10.Text := secondstostr(GetPfortenTime); // sZeit
    WillkommenForm.Label17.caption :=
      secondstostr(secondsadd(GetPfortenTime, strtoseconds('00:10'))); // eZeit

    // Start the Dialog
    WillkommenForm.show;
    WillkommenForm.Combobox3.SetFocus;
  end;

end;

function TBesucherListeForm.SetListCursorTo(TRNid: integer): boolean;
var
  n: integer;
begin
  result := false;
  for n := 0 to pred(Items.Count) do
  begin
    if (TRNid = Items[n].TRNid) then
    begin
      result := true;
      DrawGrid1.Row := n;
      SelectedRow := n;
      break;
    end;
  end;
  if not(result) then
  begin
    Label9.caption := 'SLC fail';
    application.processmessages;
  end;
end;

procedure TBesucherListeForm.DrawGrid1DblClick(Sender: TObject);
begin
  ListeEnterPressed(DrawGrid1.Row);
end;

procedure TBesucherListeForm.FutureChangeClickClick(Sender: TObject);
begin
  ListeEnterPressed(SelectedRow);
end;

procedure TBesucherListeForm.FutureNewClickClick(Sender: TObject);
begin
  NewBesucher(SelectedRow);
end;

procedure TBesucherListeForm.FutureDeleteClickClick(Sender: TObject);
begin
  RausBesucher(SelectedRow, false);
end;

procedure TBesucherListeForm.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  AppGoDown := true;
  CanClose := true;
end;

procedure TBesucherListeForm.noch30min1Click(Sender: TObject);
begin
  AddMinutes(strtoseconds('00:30'));
end;

procedure TBesucherListeForm.BarCodeOKPressed;
var
  id: integer;
  n: integer;
begin
  (*
    id := str2int(FormBarCodeView.edit1.Text);
  *)
  id := str2int(BarCode);

  while true do
  begin

    // 1. Prüfung, ob Person im Haus ist! -> Ausgang
    for n := succ(PastBorder) to pred(FutureBorder) do
      if (id = Items[n].BesucherID) then
      begin
        SetListCursorTo(Items[n].TRNid);
        RausBesucher(n, BarcodeAutoMode);
        exit;
      end;

    // 2. Prüfung, ob Person in der Planung ist! ->Ist Jetzt eingetroffen
    for n := succ(FutureBorder) to pred(Items.Count) do
      if (id = Items[n].BesucherID) then
      begin
        SetListCursorTo(Items[n].TRNid);
        FutureStartClickClick(self);
        exit;
      end;

    // 3. Prüfung, ob Person als Besucher existiert! ->Ungeplant eingetroffen
    WillkommenForm.PreSelektedBesucher := id;
    NewBesucher(PastBorder);
    exit;

  end;
end;

procedure TBesucherListeForm.BesuchJetztEingetroffen(l: TLineRec);
var
  n: integer;
begin
  // id suchen
  for n := succ(FutureBorder) to pred(Items.Count) do
    if (l.TRNid = Items[n].TRNid) then
    begin
      SelectedRow := n;
      FutureStartClickClick(self);
      break;
    end;
end;

procedure TBesucherListeForm.FormActivate(Sender: TObject);
var
  DirList: TStringList;
  OneToday: boolean;
  n: integer;
begin
  if iTransActionServer then
    if not(AlreadyActivatedOnce) then
    begin
      AlreadyActivatedOnce := true;
      OneToday := false;
      DirList := TStringList.create;
      dir(MyProgramPath + cDatenSicherungPath + 'Sicherung*.zip',
        DirList, false);
      DirList.Sort;
      for n := pred(DirList.Count) downto 0 do
        if (DateGet = FileDate(MyProgramPath + cDatenSicherungPath +
          DirList[n])) then
        begin
          OneToday := true;
          break;
        end;
      DirList.free;
      if not(OneToday) then
        if (SecondsGet > iTagesAbschluss) then
        begin
          SplashClose;
          if doit('Der Tagesabschluss wurde möglicherweise nicht durchgeführt!'
            + #13 + 'Jetzt durchführen') then
          begin
            iTagesAbschluss := GetPfortenTime;
            FormSystemSettings.Timer1Timer(Sender);
          end;
        end;
    end;
  SplashClose;
end;

procedure TBesucherListeForm.InsertMitarbeiter(data: TStrings);
var
  SaverTemp: TLineRec;
begin

  // Neuanlage
  SaverTemp := TLineRec.create;

  with SaverTemp do
  begin
    BesucherName := data[0];
    Firma := cMitarbeiter + ' ' + data[1];
    Handy := data[2];
    LastNewTRNid := NewTrn;
    TRNid := LastNewTRNid;
    BesucherID := TRNid;
    GeaendertDurch := iPfoertnerKurzBez;
    sDatum := GetPfortenDate;
    sZeit := GetPfortenTime;
    SecondsAddLong(sDatum, sZeit, strtoseconds('08:00'), eDatum, eZeit);
    PforteEin := iPforteID;
    PfoertnerEin := iPfoertnerKurzBez;
    Anzahl := 1;
    Symbol := csyGroup;
  end;

  Items.Insert(0, pointer(SaverTemp));
  FormTransaction.StoreTransaktion(MF_New, SaverTemp.SaveToString);
  SortBesucher;
  SetListCursorTo(SaverTemp.TRNid);
  ShowBesucher;
end;

procedure TBesucherListeForm.Image4Click(Sender: TObject);
begin
  openShell(MyProgramPath + 'gateF Info.html');
end;

end.
