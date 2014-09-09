program mOrgaMon;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Winapi.Windows,
  MD_Events in '..\pcsc\MD_Events.pas',
  MD_PCSC in '..\pcsc\MD_PCSC.pas',
  MD_PCSCDef in '..\pcsc\MD_PCSCDef.pas',
  MD_PCSCRaw in '..\pcsc\MD_PCSCRaw.pas',
  MD_Tools in '..\pcsc\MD_Tools.pas';

type
  TSmartCardProcessor = class(TObject)
  private
    FPCSC: TPCSC;

    constructor Create;

    // Call-Backs
    procedure CardStateChanged(Sender: TObject; ReaderName: string);
    procedure ReaderFound(Sender: TObject; ReaderName: string);
    procedure ReaderRemoved(Sender: TObject; ReaderName: string);
    procedure CardInserted(Sender: TObject; ReaderName: string; ATR: TBytes);
    procedure CardRemoved(Sender: TObject; ReaderName: string);
    procedure CardError(Sender: TObject; ReaderName: string);
    procedure ProcessEvents(Sender: TObject; var Done: boolean);

  public

    procedure ListReaders;

  end;

procedure TSmartCardProcessor.CardStateChanged(Sender: TObject;
  ReaderName: string);
var
  CardState: TCardState;
  PCSCReader: TPCSCReader;
  sState: string;
begin
  PCSCReader := TPCSC(Sender).GetPCSCReader(ReaderName);
  if PCSCReader = nil then
    exit;

  CardState := PCSCReader.CardState;
  ReaderName := PCSCReader.ReaderName;
  case CardState of
    csExclusive:
      sState := 'exclusive';
    csShared:
      sState := 'shared';
    csAvailable:
      sState := 'available';
    csBadCard:
      sState := 'bad card';
    csNoCard:
      sState := 'no card';
  else
    sState := 'unknown';
  end;
  Writeln('Card State changed in ' + ReaderName + ' to ' + sState);
end;

procedure TSmartCardProcessor.ReaderFound(Sender: TObject; ReaderName: string);
begin
  Writeln('New reader found: ' + ReaderName);
end;

procedure TSmartCardProcessor.ReaderRemoved(Sender: TObject;
  ReaderName: string);
begin
  Writeln('Reader removed: ' + ReaderName);
end;

procedure TSmartCardProcessor.CardInserted(Sender: TObject; ReaderName: string;
  ATR: TBytes);
var
  PCSCReader: TPCSCReader;
begin
  Writeln('Card inserted in ' + ReaderName);
  PCSCReader := TPCSCReader(FPCSC.GetPCSCReader(ReaderName));
  if PCSCReader <> nil then
  begin
    if length(ATR) > 0 then
      Writeln('ATR = ' + BufferToHexString(ATR));
  end;
end;

procedure TSmartCardProcessor.CardRemoved(Sender: TObject; ReaderName: string);
begin
  Writeln('Card removed from ' + ReaderName);
end;

constructor TSmartCardProcessor.Create;
begin
  inherited;
  FPCSC := TPCSC.Create;
  with FPCSC do
  begin
    OnReaderFound := ReaderFound;
    OnReaderRemoved := ReaderRemoved;
    OnCardStateChanged := CardStateChanged;
    OnCardInserted := CardInserted;
    OnCardRemoved := CardRemoved;
    OnCardError := CardError;
    Start;
  end;
  ListReaders;
end;

procedure TSmartCardProcessor.ListReaders;
var
  i: integer;
begin
  Writeln('*');
  for i := 0 to FPCSC.ReaderList.Count - 1 do
    Writeln(FPCSC.ReaderList[i]);
end;

procedure TSmartCardProcessor.CardError(Sender: TObject; ReaderName: string);
begin
  Writeln('Card error in ' + ReaderName);
end;

procedure TSmartCardProcessor.ProcessEvents(Sender: TObject; var Done: boolean);
begin
  if FPCSC.Valid then
    FPCSC.ProcessEvent;
  Done := true;
end;

var
  CallBackContainer: TSmartCardProcessor;
  Done: boolean;

var
  Msg: TMsg;
  bRet: LongBool;

begin
  try

    Writeln('mOrgaMon Smart-Card Agent Rev. 1.000');

    CallBackContainer := TSmartCardProcessor.Create;
    if not(CallBackContainer.FPCSC.Valid) then
      Writeln('SCardEstablishContext failed.');

    repeat
write('.');
  if CallBackContainer.FPCSC.Valid then
    CallBackContainer.FPCSC.ProcessEvent;
CallBackContainer.ListReaders;

      bRet := Winapi.Windows.GetMessage(Msg, 0, 0, 0);
      if Int32(bRet) = -1 then
      begin
        // Error
        Break;
      end
      else
      begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
        CallBackContainer.ProcessEvents(CallBackContainer.FPCSC, Done);
      end;
    until not bRet;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
