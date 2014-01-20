unit SymbolPool;

interface

uses
  windows, classes, anfix32,
  wordindex, graphics;

type
  TSymbolPool = class(TList)
  private
    SymbolInfo: TSearchStringList;
    SymbolBild: TBitMap;
    SymbolPath: string;
  public
    constructor Create(FName: string); virtual;
    destructor Destroy; override;
    function Symbol(Name: string): TBitMap;
    procedure InsertSymbol(Name: string; Symbol: TBitMap); overload;
    procedure InsertSymbol(FName: string); overload;
  end;

implementation

uses
  SysUtils;

constructor TSymbolPool.Create(FName: string);
begin
  inherited Create;
  SymbolInfo := TSearchStringList.create;
  SymbolInfo.LoadFromFile(Fname + '.itp');
  SymbolInfo.sort;
  SymbolBild := TBitMap.create;
  SymbolBild.LoadFromFile(FName + '.bmp');
  SymbolPath := ExtractFilePath(FName + '.bmp');
end;

function TSymbolPool.Symbol(Name: string): TBitMap;
var
  k: integer;
  NewSymbolRect: TRect;
  NewBMP: TBitMap;
begin
  // Check if "Name" exists
  k := SymbolInfo.FindNear(Name);
  if (k = -1) then
  begin
    result := nil;
    exit;
  end;

  // Check if "assigned"
  result := SymbolInfo.objects[k] as TBitMap;
  if (result = nil) then
  begin
    if pos(Name + '=', SymbolInfo[k]) = 1 then
    begin
      NewBMP := TBitMap.Create;
      SymbolInfo.objects[k] := NewBMP;
      result := NewBMP;
      NewSymbolRect := Str2Rect(copy(SymbolInfo[k], succ(pos('=', SymbolInfo[k])), MaxInt));
      NewBmp.width := rXL(NewSymbolRect);
      NewBmp.Height := rYL(NewSymbolRect);
      NewBmp.canvas.CopyRect(SizeCorrect(mkRect(0, 0, pred(NewBMP.Width), pred(NewBMP.Height))),
        SymbolBild.Canvas,
        SizeCorrect(NewSymbolRect));
      if (NewBmp.canvas.Pixels[0, 0] = SymbolBild.Canvas.Pixels[0, 0]) then
        NewBmp.Transparent := true;
    end;
  end;
end;

procedure TSymbolPool.InsertSymbol(Name: string; Symbol: TBitMap);
begin
  SymbolInfo.addobject(Name, Symbol);
  SymbolInfo.sort;
end;

procedure TSymbolPool.InsertSymbol(FName: string);
var
  NewBMP: TBitMap;
begin
  if FileExists(SymbolPath + FName + '.bmp') then
  begin
    NewBMP := TBitMap.Create;
    NewBMP.LoadFromFile(SymbolPath + FName + '.bmp');
    SymbolInfo.AddObject(FName, NewBMP);
    SymbolInfo.sort;
  end;
end;

destructor TSymbolPool.Destroy;
var
  n: integer;
begin
  SymbolBild.free;
  for n := 0 to pred(SymbolInfo.count) do
    SymbolInfo.objects[n].free;
  SymbolInfo.free;
  inherited destroy;
end;


end.
