unit Volumes;

interface

uses
  Windows, Messages, Classes, ExtCtrls, ComCtrls, MMSystem;

const
  CDVolume = 0;
  WaveVolume = 1;
  MidiVolume = 2;

type
  TVolumeControl = class(TComponent)
  private
    FDevices: array [0 .. 2] of Integer;
    FTrackBars: array [0 .. 2] of TTrackBar;
    FTimer: TTimer;
    MixerControlDetails: TMixerControlDetails;
    FonvolumeChange: TNotifyEvent;
    function GetInterval: Integer;
    procedure SetInterval(AInterval: Integer);
    function GetVolume(AIndex: Integer): Byte;
    procedure SetVolume(AIndex: Integer; aVolume: Byte);
    procedure InitVolume;
    procedure SetTrackBar(AIndex: Integer; ATrackBar: TTrackBar);
    { Private declarations }
    procedure Update(Sender: TObject);
    procedure Changed(Sender: TObject);
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent;
      AOperation: TOperation); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Interval: Integer read GetInterval write SetInterval default 500;
    property CDVolume: Byte index 0 read GetVolume write SetVolume stored False;
    property CDTrackBar: TTrackBar index 0 read FTrackBars[0] write SetTrackBar;
    property WaveVolume: Byte index 1 read GetVolume write SetVolume
      stored False;
    property WaveTrackBar: TTrackBar index 1 read FTrackBars[1]
      write SetTrackBar;
    property MidiVolume: Byte index 2 read GetVolume write SetVolume
      stored False;
    property MidiTrackBar: TTrackBar index 2 read FTrackBars[2]
      write SetTrackBar;
    property OnVolumeChange: TNotifyEvent read FonvolumeChange
      write FonvolumeChange;
  end;

procedure Register;

implementation

uses
  anfix32;

procedure Register;
begin
  RegisterComponents('ANFiX', [TVolumeControl]);
end;

type
  TVolumeRec = record
    case Integer of
      0:
        (LongVolume: Longint);
      1:
        (LeftVolume, RightVolume: Word
        );
  end;

function TVolumeControl.GetInterval: Integer;
begin
  Result := FTimer.Interval;
end;

procedure TVolumeControl.SetInterval(AInterval: Integer);
begin
  FTimer.Interval := AInterval;
end;

function TVolumeControl.GetVolume(AIndex: Integer): Byte;
var
  Vol: TVolumeRec;
begin
  Vol.LongVolume := 0;
  if FDevices[AIndex] <> -1 then
    case AIndex of
      0:
        auxGetVolume(FDevices[AIndex], @Vol.LongVolume);
      1:
        waveOutGetVolume(FDevices[AIndex], @Vol.LongVolume);
      2:
        midiOutGetVolume(FDevices[AIndex], @Vol.LongVolume);
    end;
  Result := (Vol.LeftVolume + Vol.RightVolume) shr 9;
end;

procedure TVolumeControl.SetVolume(AIndex: Integer; aVolume: Byte);
var
  Vol: TVolumeRec;
  // hmixer: integer;
begin
  if FDevices[AIndex] <> -1 then
  begin
    Vol.LeftVolume := aVolume shl 8;
    Vol.RightVolume := Vol.LeftVolume;
    case AIndex of
      0:
        auxSetVolume(FDevices[AIndex], Vol.LongVolume);
      1:
        waveOutSetVolume(FDevices[AIndex], Vol.LongVolume);
      2:
        midiOutSetVolume(FDevices[AIndex], Vol.LongVolume);
      3:
        ;
      { begin
        with MixerControlDetails do
        begin
        cMultipleItems = 0;
        dwControlID = controlid;
        end;
        //mixerSetControlDetails( ,MixerControlDetails, ); //Alles
        end;
      } end;
  end;
end;

procedure TVolumeControl.SetTrackBar(AIndex: Integer; ATrackBar: TTrackBar);
begin
  if ATrackBar <> FTrackBars[AIndex] then
  begin
    FTrackBars[AIndex] := ATrackBar;
    Update(Self);
  end;
end;

procedure TVolumeControl.Notification(AComponent: TComponent;
  AOperation: TOperation);
var
  I: Integer;
begin
  StartDebug('TVolumeControl.Notification-A');
  inherited Notification(AComponent, AOperation);
  if (AOperation = opRemove) then
    for I := 0 to 2 do
      if (AComponent = FTrackBars[I]) then
        FTrackBars[I] := nil;
  StartDebug('TVolumeControl.Notification-B');
end;

procedure TVolumeControl.Update(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to 2 do
  begin

    if assigned(FonvolumeChange) then
      FonvolumeChange(Self);

    if assigned(FTrackBars[I]) then
      with FTrackBars[I] do
      begin
        Min := 0;
        Max := 255;
        if (Orientation = trVertical) then
          Position := 255 - GetVolume(I)
        else
          Position := GetVolume(I);
        OnChange := Self.Changed;
      end;

  end;
end;

constructor TVolumeControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTimer := TTimer.Create(Self);
  FTimer.OnTimer := Update;
  FTimer.Interval := 500;
  InitVolume;
end;

destructor TVolumeControl.Destroy;
var
  I: Integer;
begin
 StartDebug('TVolumeControl.Destroy-A');
  FTimer.Free;
  for I := 0 to 2 do
    if assigned(FTrackBars[I]) then
      FTrackBars[I].OnChange := nil;
  inherited Destroy;
 StartDebug('TVolumeControl.Destroy-B');
end;

procedure TVolumeControl.Changed(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to 2 do
    if Sender = FTrackBars[I] then
      with FTrackBars[I] do
      begin
        if Orientation = trVertical then
          SetVolume(I, 255 - Position)
        else
          SetVolume(I, Position);
      end;
end;

procedure TVolumeControl.InitVolume;
var
  AuxCaps: TAuxCaps;
  WaveOutCaps: TWaveOutCaps;
  MidiOutCaps: TMidiOutCaps;
  I, J: Integer;
  _auxGetNumDevs: Longword;
begin
  FDevices[0] := -1;
  FDevices[1] := -1;
  FDevices[2] := -1;
  if (waveOutGetNumDevs > 0) then
  begin
    _auxGetNumDevs := auxGetNumDevs;
    if _auxGetNumDevs > 0 then
      for I := 0 to pred(_auxGetNumDevs) do
      begin
        auxGetDevCaps(I, @AuxCaps, SizeOf(AuxCaps));
        if (AuxCaps.dwSupport and AUXCAPS_VOLUME) <> 0 then
        begin
          FTimer.Enabled := True;
          FDevices[0] := I;
          break;
        end;
      end;
    for I := 0 to waveOutGetNumDevs - 1 do
    begin
      waveOutGetDevCaps(I, @WaveOutCaps, SizeOf(WaveOutCaps));
      if (WaveOutCaps.dwSupport and WAVECAPS_VOLUME) <> 0 then
      begin
        FTimer.Enabled := True;
        FDevices[1] := I;
        break;
      end;
    end;
    for I := 0 to midiOutGetNumDevs - 1 do
    begin
      MidiOutGetDevCaps(I, @MidiOutCaps, SizeOf(MidiOutCaps));
      if (MidiOutCaps.dwSupport and MIDICAPS_VOLUME) <> 0 then
      begin
        FTimer.Enabled := True;
        FDevices[2] := I;
        break;
      end;
    end;
  end;
end;

end.
