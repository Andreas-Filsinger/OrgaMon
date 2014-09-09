/// ///////////////////////////////////////////////////////////////////////////////
// This source code is provided 'as-is', without any express or implied     //
// warranty. In no event will Infintuary be held liable for any damages     //
// arising from the use of this software.                                   //
// //
// Infintuary does not warrant, that the source code will be free from      //
// defects in design or workmanship or that operation of the source code    //
// will be error-free. No implied or statutory warranty of merchantability  //
// or fitness for a particular purpose shall apply. The entire risk of      //
// quality and performance is with the user of this source code.            //
// //
// Permission is granted to anyone to use this software for any purpose,    //
// including commercial applications, and to alter it and redistribute it   //
// freely, subject to the following restrictions:                           //
// //
// 1. The origin of this source code must not be misrepresented; you must   //
// not claim that you wrote the original source code.                    //
// //
// 2. Altered source versions must be plainly marked as such, and must not  //
// be misrepresented as being the original source code.                  //
// //
// 3. This notice may not be removed or altered from any source             //
// distribution.                                                         //
/// ///////////////////////////////////////////////////////////////////////////////

unit Main;

interface

uses
  Windows, SysUtils, Classes, Forms, Controls, ComCtrls, StdCtrls,
  ExtCtrls, Graphics,
  MD_PCSC, MD_PCSCDef, MD_Tools;

type
  TMainForm = class(TForm)
    LogMemo: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ReaderListBoxDrawItem(Control: TWinControl; Index: Integer;
      RC: TRect; State: TOwnerDrawState);
    procedure FormActivate(Sender: TObject);
  private
    FPCSC: TPCSC;
    Initialized: boolean;
    Connected: boolean;
    MainReader: string;
    CardResponse: string;
    BLZ, KontoNummer, KarteNr, GueltigBis: string;

    procedure CardStateChanged(Sender: TObject; ReaderName: string);
    procedure ProcessEvents(Sender: TObject; var Done: boolean);

    procedure ReaderFound(Sender: TObject; ReaderName: string);
    procedure ReaderRemoved(Sender: TObject; ReaderName: string);
    procedure CardInserted(Sender: TObject; ReaderName: string; ATR: TBytes);
    procedure CardRemoved(Sender: TObject; ReaderName: string);
    procedure CardError(Sender: TObject; ReaderName: string);

    procedure AddLogMemo(Msg: string);
    function ErrorToString(ErrorCode: DWORD): string;

    function SendAPDU(PCSCReader: TPCSCReader; Command: string): boolean;

  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormActivate(Sender: TObject);
begin
  if not Initialized then
  begin
    Initialized := true;

    if not(FPCSC.Valid) then
      AddLogMemo('SCardEstablishContext failed.')
    else
    begin
      AddLogMemo('SCardEstablishContext succeeded.');
      FPCSC.OnReaderFound := ReaderFound;
      FPCSC.OnReaderRemoved := ReaderRemoved;
      FPCSC.OnCardStateChanged := CardStateChanged;
      FPCSC.OnCardInserted := CardInserted;
      FPCSC.OnCardRemoved := CardRemoved;
      FPCSC.OnCardError := CardError;

      FPCSC.Start;
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Caption := 'PC/SC Sample Application V1.3';
  Application.Title := Caption;
  Application.OnIdle := ProcessEvents;
  LogMemo.Clear;
  Initialized := false;
  FPCSC := TPCSC.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FPCSC.Free;
end;

procedure TMainForm.CardStateChanged(Sender: TObject; ReaderName: string);
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
  AddLogMemo('Card State changed in ' + ReaderName + ' to ' + sState);
end;

procedure TMainForm.ReaderListBoxDrawItem(Control: TWinControl; Index: Integer;
  RC: TRect; State: TOwnerDrawState);
var
  sState: string;
  PCSCReader: TPCSCReader;
begin
  with TListBox(Control).Canvas do
  begin
    PCSCReader := FPCSC.GetPCSCReader(TListBox(Control).Items[Index]);
    if PCSCReader = nil then
      exit;

    if odSelected in State then
    begin
      Brush.Color := $00CEFF;
      Font.Color := clBlack;
    end
    else
    begin
      Brush.Color := clWhite;
      Font.Color := clBlack;
    end;
    Pen.Color := Brush.Color;

    Rectangle(RC.Left, RC.Top, RC.Right, RC.Bottom);
    TextOut(RC.Left + 4, RC.Top + 2, TListBox(Control).Items[Index]);

    if PCSCReader <> nil then
    begin
      case PCSCReader.CardState of
        csExclusive:
          begin
            Font.Color := clGreen;
            sState := 'Card state = exclusive, ATR = ' + PCSCReader.ATRasString;
          end;
        csShared:
          begin
            Font.Color := clGreen;
            sState := 'Card state = shared, ATR = ' + PCSCReader.ATRasString;
          end;
        csAvailable:
          begin
            Font.Color := clGreen;
            sState := 'Card state = available, ATR = ' + PCSCReader.ATRasString;
          end;
        csBadCard:
          begin
            Font.Color := $808080;
            sState := 'Card state = bad card';
          end;
        csNoCard:
          begin
            Font.Color := clGray;
            sState := 'Card state = no card';
          end;
      else
        begin
          Font.Color := clGray;
          sState := 'Card state = unknown';
        end;
      end;
      TextOut(RC.Left + 20, RC.Top + 15, sState);
    end;
  end;
end;

function TMainForm.ErrorToString(ErrorCode: DWORD): string;
begin
  if ErrorCode >= $80000000 then
    result := PCSCErrorToString(ErrorCode)
  else
    result := WindowsErrorToString(ErrorCode);
end;

procedure TMainForm.ReaderFound(Sender: TObject; ReaderName: string);
begin
  AddLogMemo('New reader found: ' + ReaderName);

end;

procedure TMainForm.ReaderRemoved(Sender: TObject; ReaderName: string);
begin
  AddLogMemo('Reader removed: ' + ReaderName);
end;

procedure TMainForm.CardInserted(Sender: TObject; ReaderName: string;
  ATR: TBytes);
var
  PCSCReader: TPCSCReader;
  PCSCResult: DWORD;
  DataIn: TBytes;
  DataOut: TBytes;
  SW12: Word;
  n: Integer;
begin

  AddLogMemo('Card inserted in ' + ReaderName);
  PCSCReader := TPCSCReader(FPCSC.GetPCSCReader(ReaderName));
  if PCSCReader <> nil then
  begin
    if length(ATR) > 0 then
      AddLogMemo('ATR = ' + BufferToHexString(ATR));
  end;

  BLZ := '';
  KontoNummer := '';
  KarteNr := '';
  GueltigBis := '';

  // Auto Connect
  PCSCResult := PCSCReader.Connect(SCARD_SHARE_SHARED);
  if PCSCResult = SCARD_S_SUCCESS then
    AddLogMemo('SCardConnect (shared) succeeded.')
  else
    AddLogMemo(Format('SCardConnect (shared) failed with error code %s (%s)',
      [IntToHex(PCSCResult, 8), ErrorToString(PCSCResult)]));

  repeat

    // Send Commands
    if not SendAPDU(PCSCReader, '00a40000023f0000') then
    begin
      AddLogMemo('Error 246');
      break;
    end;

    // EF_BOERSE
    if not SendAPDU(PCSCReader, '00a404000ba00000005950414345010000') then
    begin
      AddLogMemo('Error 253');
      break;
    end;

    // READ record cc.1
    if not SendAPDU(PCSCReader, '00b201cc00') then
    begin
      AddLogMemo('Error 260');
      break;
    end;

    BLZ := copy(CardResponse, 3, 8);
    AddLogMemo('BLZ: ' + BLZ);

  until true;

  repeat

    // EMV
    if not SendAPDU(PCSCReader, '00a40000023f0000') then
    begin
      AddLogMemo('Error 272');
      break;
    end;

    // Datei wählen
    if not SendAPDU(PCSCReader, '00a4040007a000000004306000') then
    begin
      AddLogMemo('Error 276');
      break;
    end;

    for n := 1 to 9 do
    begin
      AddLogMemo
        ('================================================================================');
      if not SendAPDU(PCSCReader, '00b20' + IntToStr(n) + '0c00') then
      begin
        AddLogMemo('Error 283 at record ' + IntToStr(n));
        break;
      end;
      AddLogMemo(IntToStr(n) + ' : ' + CardResponse + ' (' +
        IntToStr(length(CardResponse)) + ' bytes)');
      if length(CardResponse) = 94 then
      begin
        GueltigBis := copy(CardResponse, 14, 2) + '.' + copy(CardResponse, 12,
          2) + '.' + copy(CardResponse, 10, 2);
        AddLogMemo('Gültig bis: ' + GueltigBis);

        KontoNummer := copy(CardResponse, 26, 10);
        AddLogMemo('Account: ' + KontoNummer);
        break;
      end;
    end;

  until true;

  // Karten Nummer
  if SendAPDU(PCSCReader, '00b201bc00') then
  begin
    KarteNr := copy(CardResponse, 9, 11);
    AddLogMemo('KarteNr: ' + KarteNr);
  end;


  // Abmelden
  PCSCResult := PCSCReader.Disconnect();
  if PCSCResult = SCARD_S_SUCCESS then
    AddLogMemo('SCardDisconnect succeeded.')
  else
    AddLogMemo(Format('SCardDisconnect failed with error code %s (%s)',
      [IntToHex(PCSCResult, 8), ErrorToString(PCSCResult)]));


  // Ergebnis melden

  AddLogMemo('BLZ;KontoNummer;KarteNr;GueltigBis');
  AddLogMemo(BLZ + ';' + KontoNummer + ';' + KarteNr + ';' + GueltigBis);

end;

function TMainForm.SendAPDU(PCSCReader: TPCSCReader; Command: string): boolean;
var
  PCSCResult: DWORD;
  DataIn: TBytes;
  DataOut: TBytes;
  SW12: Word;
begin
  result := false;
  CardResponse := '';
  DataIn := HexStringToBuffer(Command);

  AddLogMemo('Sending APDU to card: ' + BufferToHexString(DataIn));
  PCSCResult := PCSCReader.TransmitSW(DataIn, DataOut, SW12);
  if PCSCResult = SCARD_S_SUCCESS then
  begin
    AddLogMemo('SCardTransmit succeeded.');
    AddLogMemo('Card response status word: ' + IntToHex(SW12, 4) + ' (' +
      CardErrorToString(SW12) + ')');
    if length(DataOut) > 0 then
    begin
      CardResponse := BCDBufferToDecString(DataOut);
      AddLogMemo('Card response data: ' + CardResponse);
      result := true;
    end;
  end
  else
    AddLogMemo(Format('SCardTransmit failed with error code %s (%s)',
      [IntToHex(PCSCResult, 8), ErrorToString(PCSCResult)]));
end;

procedure TMainForm.CardRemoved(Sender: TObject; ReaderName: string);
begin
  AddLogMemo('Card removed from ' + ReaderName);
end;

procedure TMainForm.CardError(Sender: TObject; ReaderName: string);
begin
  AddLogMemo('Card error in ' + ReaderName);
end;

procedure TMainForm.ProcessEvents(Sender: TObject; var Done: boolean);
begin
  if FPCSC.Valid then
    FPCSC.ProcessEvent;
  Done := true;
end;

procedure TMainForm.AddLogMemo(Msg: string);
begin
  LogMemo.Lines.Add(Msg);
end;

end.
