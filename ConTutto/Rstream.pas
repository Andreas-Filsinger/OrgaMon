{****************************************}
{    RealSoft Stream Classes  Ver 1.0    }
{  (File Locking, Compressed, Encrypted) }
{        Copyright 1997 RealSoft         }
{        -----------------------         }
{  Change History:                       }
{  1/25/97 Initial Release               }
{****************************************}

unit Rstream;

interface

uses
  Classes, SysUtils;

const
  CRYPT_1 = 2; {must be 0-5    divisor}
  CRYPT_2 = 53; {must be 0-255  modifier}
  CRYPT_3 = 1; {must be 1-255  encrypt every N byte, 1=all}

type
  TString255 = string[255];
  EFileLockedError = class(EStreamError);

  TLockFileStream = class(TFileStream)
  private
    FReadLock: boolean;
    function DoLock(const handle: word; const origin, length: longint; const lock: boolean): word;
  public
    function Lock(origin, length: longint): boolean;
    function Unlock(origin, length: longint): boolean;
    constructor Create(const FileName: string; Mode: Word);
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    property ReadLock: boolean read FReadLock write FReadLock;
  end;

  TRLEStream = class(TMemoryStream)
  private
    procedure RLECompress(InStream, OutStream: TStream);
    procedure RLEUnCompress(InStream, OutStream: TStream);
  public
    procedure SavetoRLEStream(Stream: TStream);
    procedure LoadFromRLEStream(Stream: TStream);
    procedure SavetoRLEFile(FileName: string);
    procedure LoadFromRLEFile(FileName: string);
  end;

  TEncryptedStream = class(TMemoryStream)
  private
    FKey: TString255;
    procedure Crypt(const Key: string; InStream, OutStream: TStream);
  public
    constructor Create;
    procedure SavetoCryptStream(Stream: TStream);
    procedure LoadFromCryptStream(Stream: TStream);
    procedure SavetoCryptFile(FileName: string);
    procedure LoadFromCryptFile(FileName: string);
    property Key: TString255 read FKey write FKey;
  end;

  TEncryptedFileStream = class(TFileStream)
  private
    FKey: TString255;
    c: byte;
  public
    function Read(var Buffer; Count: Longint): Longint; override;
    property Key: TString255 read FKey write FKey;
  end;

  TFilterFileStream = class(TFileStream)
  private
    FromString: TString255;
    ToString: TString255;
    PatchedCount: longint;
    procedure Patch(InStream, OutStream: TStream);
  public
    procedure SaveToPatchFile(FileName: string);
    property FindStr: TString255 read FromString write FromString;
    property ReplaceStr: TString255 read ToString write ToString;
    property Patched: longint read PatchedCount;
  end;

implementation

{****************************}
{  File Locking Stream Class }
{  via FileStream            }
{****************************}

function TLockFileStream.DoLock(const handle: word; const origin, length: longint; const lock: boolean): word; assembler;
asm
    CMP   Lock, true
    JNE   @@UNLOCK
    MOV	  AX,$5C00
    JMP   @@OVER
  @@UNLOCK:
    MOV	  AX,$5C01
  @@OVER:
    MOV	  BX,Handle
    MOV	  CX,origin.Word[2]
    MOV	  DX,origin.Word[0]
    MOV	  SI,length.Word[2]
    MOV	  DI,length.Word[0]
    INT	  $21
    JC	  @@FAIL
  @@OK:
    MOV	  AX,0
    JMP	  @@END
  @@FAIL:
    CMP	  AX,1
    JE	  @@OK
  @@END:
end;

function TLockFileStream.Lock(origin, length: longint): boolean;
begin
  result := DoLock(Handle, origin, length, true) = 0;
end;

function TLockFileStream.Unlock(origin, length: longint): boolean;
begin
  result := DoLock(Handle, origin, length, false) = 0;
end;

constructor TLockFileStream.Create(const FileName: string; Mode: Word);
begin
  inherited Create(FileName, Mode);
  ReadLock := false;
end;

function TLockFileStream.Write(const Buffer; Count: Longint): Longint;
var
  waslocked, cantlock: boolean;
  oldpos: longint;
begin
  waslocked := false;
  cantlock := false;
  oldpos := Position;
  {Attempt to lock file}
  if not Lock(Position, Count) then
  {Couldn't lock, so try to unlock}
    if UnLock(Position, Count) then waslocked := true
    {Couldn't unlock, it must be locked by another app}
    else cantlock := true;
  {Couldn't lock or unlock, so raise exception}
  if cantlock then begin
    raise EFileLockedError.Create('Unable to write locked file.');
    Exit;
  end;
  {Write Data}
  result := inherited Write(Buffer, Count);
  {Restore lock}
  if waslocked then Lock(oldPos, Count)
  else UnLock(oldPos, Count);
end;

function TLockFileStream.Read(var Buffer; Count: Longint): Longint;
var
  waslocked, cantlock: boolean;
  oldpos: longint;
begin
  if not FReadLock then
  begin
    result := inherited Read(Buffer, Count);
    Exit;
  end;
  waslocked := false;
  cantlock := false;
  oldpos := Position;
  {Attempt to lock file}
  if not Lock(Position, Count) then
  {Couldn't lock, so try to unlock}
    if UnLock(Position, Count) then waslocked := true
    {Couldn't unlock, it must be locked by another app}
    else cantlock := true;
  {Couldn't lock or unlock, so raise exception}
  if cantlock then begin
    raise EFileLockedError.Create('Unable to read locked file.');
    Exit;
  end;
  {Read Data}
  result := inherited Read(Buffer, Count);
  {Restore lock}
  if waslocked then Lock(oldPos, Count)
  else UnLock(oldPos, Count);
end;

{****************************}
{   Compressed Stream Class  }
{   via MemoryStream         }
{****************************}

procedure TRLEStream.RLECompress(InStream, OutStream: TStream);
var
  b, p, c: byte;
  run: boolean;
begin
  InStream.Seek(0, 0);
  OutStream.Seek(0, 0);
  c := 0;
  run := false;
  if InStream.Read(p, 1) = 1 then begin
    while InStream.Read(b, 1) = 1 do begin
      if not run then begin
        if (p = b) and (p < 193) then begin
          run := true;
          c := 1;
        end
        else begin {P <> B -- so write it non runmode}
          if p > 191 then begin
            c := 193;
            OutStream.Write(c, 1);
            OutStream.Write(p, 1);
          end else OutStream.Write(p, 1);
        end;
      end { end not runmode}

      else begin {It was in runmode}
        if (P <> b) or (c > 61) then begin {Terminate the run}
          inc(c, 193);
          OutStream.Write(c, 1);
          OutStream.Write(p, 1);
          run := false;
        end else inc(c);
      end; {end runmode}
      p := b;
    end; {end stream}

    {Clean-up last byte or the run}
    if run then begin
      inc(c, 193);
      OutStream.Write(c, 1);
      OutStream.Write(p, 1);
    end else begin
      if p > 191 then begin
        c := 193;
        OutStream.Write(c, 1);
        OutStream.Write(p, 1);
      end else OutStream.Write(p, 1);
    end;
  end; {end-- if instream read p = 1}
end;

procedure TRLEStream.RLEUnCompress(InStream, OutStream: TStream);
var
  i, b, c: byte;
begin
  InStream.Seek(0, 0);
  OutStream.Seek(0, 0);
  while InStream.Read(b, 1) = 1 do begin
    if b < 192 then OutStream.Write(b, 1)
    else begin
      c := b - 192;
      InStream.Read(b, 1);
      for i := 1 to c do OutStream.Write(b, 1);
    end;
  end;
end;

procedure TRLEStream.SavetoRLEStream(Stream: TStream);
begin
  RLECompress(Self, Stream);
end;

procedure TRLEStream.LoadFromRLEStream(Stream: TStream);
begin
  RLEUnCompress(Stream, Self);
end;

procedure TRLEStream.SavetoRLEFile(FileName: string);
var
  TempMS: TMemoryStream;
begin
  TempMS := TMemoryStream.Create;
  RLECompress(Self, TempMS);
  TempMS.SaveToFile(FileName);
  TempMS.Free;
end;

procedure TRLEStream.LoadFromRLEFile(FileName: string);
var
  TempMS: TMemoryStream;
begin
  TempMS := TMemoryStream.Create;
  TempMS.LoadfromFile(FileName);
  RLEUnCompress(TempMS, Self);
  TempMS.Free;
end;

{****************************}
{   Encrypted Stream Class   }
{   via MemoryStream         }
{****************************}

constructor TEncryptedStream.Create;
begin
  inherited Create;
  Key := 'RSD';
end;

procedure TEncryptedStream.Crypt(const Key: string; InStream, OutStream: TStream);
var
  b, l, c, t: byte;
  buf: array[0..255] of byte;
  r: byte;
begin
  InStream.Seek(0, 0);
  OutStream.Seek(0, 0);
  l := length(Key);
  c := 0;
  repeat
    r := InStream.Read(buf, CRYPT_3);
    b := buf[0];
    inc(c);
    if l > 0 then
    begin
      if (c mod 2) = 0 then
        t := (c shr CRYPT_1) xor byte(Key[(c mod l) + 1])
      else
        t := (abs(CRYPT_2 - c)) xor byte(Key[((c mod l) + 1) shr 1]);
      b := b xor t;
    end;
    buf[0] := b;
    OutStream.Write(buf, r);
  until r = 0;
end;

procedure TEncryptedStream.SavetoCryptStream(Stream: TStream);
begin
  Crypt(Key, Self, Stream);
end;

procedure TEncryptedStream.LoadFromCryptStream(Stream: TStream);
begin
  Crypt(Key, Stream, Self);
end;

procedure TEncryptedStream.SavetoCryptFile(FileName: string);
var TempMS: TMemoryStream;
begin
  TempMS := TMemoryStream.Create;
  Crypt(Key, Self, TempMS);
  TempMS.SaveToFile(FileName);
  TempMS.Free;
end;

procedure TEncryptedStream.LoadFromCryptFile(FileName: string);
var TempMS: TMemoryStream;
begin
  TempMS := TMemoryStream.Create;
  TempMS.LoadfromFile(FileName);
  Crypt(key, TempMS, Self);
  TempMS.Free;
end;

function TEncryptedFileStream.Read(var Buffer; Count: Longint): Longint;
var
  WasCount, n: integer;
  l, t: byte;
  p: ^byte;
begin
 // read the buffer unchanged
  WasCount := inherited Read(Buffer, Count);

 // now crypt the result, remember, read the result
  p := @Buffer;
  l := length(Key);
  if (l > 0) then
    for n := 1 to WasCount do
    begin
      if c = 255 then
        c := 0
      else
        inc(c);
      if (c mod 2) = 0 then
        t := (c shr CRYPT_1) xor byte(Key[(c mod l) + 1])
      else
        t := (abs(CRYPT_2 - c)) xor byte(Key[((c mod l) + 1) shr 1]);
      p^ := p^ xor t;
      inc(p);
    end;
  result := WasCount;
end;

procedure TFilterFileStream.Patch(InStream, OutStream: TStream);
var
 //  FromString    : TString255;
 //  ToString      : TString255;
  FindLength: byte;
  FoundCount: byte;
  b, n: byte;
begin
  InStream.Seek(0, 0);
  OutStream.Seek(0, 0);
  FindLength := length(FromString);
  FoundCount := 0;
  while (InStream.Read(b, 1) = 1) do
  begin
  // Test, if there is another HIT
    if b = ord(FromString[succ(FoundCount)]) then
    begin
   // another char HIT detected
      inc(FoundCount);
      if (FoundCount = FindLength) then
      begin
    // full FindString Hit detected
        inc(PatchedCount);
        for n := 1 to FindLength do
          OutStream.Write(ToString[n], 1);
        FoundCount := 0; // clear Counter
      end;
    end else
    begin
   // A not fitting char detected
      if (FoundCount > 0) then
      begin
    // wow, further partial hit
        for n := 1 to FoundCount do
          OutStream.Write(FromString[n], 1);
        FoundCount := 0;
      end;
      OutStream.Write(b, 1);
    end;
  end;
end;

procedure TFilterFileStream.SaveToPatchFile(FileName: string);
var
  TempSource: TMemoryStream;
  TempMS: TMemoryStream;
begin
  TempSource := TMemoryStream.create;
  TempSource.CopyFrom(Self, 0);
  TempMS := TMemoryStream.Create;
  Patch(TempSource, TempMS);
  TempMS.SaveToFile(FileName);
  TempMS.Free;
  TempSource.Free;
end;

end.
