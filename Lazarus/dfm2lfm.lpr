program dfm2lfm;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, SysUtils, CustApp
  { you can add units after this }
  ,LazUTF8, anfix
  ;

type

  { Tdfm2lfm }

  Tdfm2lfm = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ Tdfm2lfm }


function FixWideString(aInStream, aOutStream: TMemoryStream): Integer;
// Convert Windows WideString syntax (#xxx) to UTF8

  function UnicodeNumber(const InS: string; var Ind: integer): string;
  // Convert the number to UTF8
  var
    Start, c: Integer;
  begin
    Inc(Ind);                            // Skip '#'
    Start:=Ind;
    while InS[Ind] in ['0'..'9'] do
      Inc(Ind);                          // Collect numbers
    c:=StrToInt(Copy(InS, Start, Ind-Start));
    if (c>255) then
      Result:=UnicodeToUTF8(c)
    else
      Result:=WinCPToUTF8(chr(c));
  end;

  function FixControlChars(const s:string): string;
  var
    i: Integer;
    InControl: boolean;
  begin
    Result := '';
    InControl := false;
    for i:=1 to Length(s) do begin
      if s[i] < #32 then begin
        if not InControl then
          result := result + '''';
        result := result + '#' + IntToStr(ord(s[i]));
        InControl := true;
      end else begin
        if InControl then begin
          result := result + '''';
          InControl := false;
        end;
        Result := Result + s[i];
      end;
    end;
  end;

  function CollectString(const InS: string; var Ind: integer): string;
  // Collect a string composed of quoted strings and unicode numbers like #xxx
  var
    InQuote: Boolean;
    ch: Char;
  begin
    Result:='';
    InQuote:=False;
    repeat
      ch:=InS[Ind];
      if ch in [#13,#10] then Break;
      if ch = '''' then begin
        InQuote:=not InQuote;            // Toggle quote
        Inc(Ind);
      end
      else if InQuote then begin
        Result:=Result+ch;               // Inside quotes copy characters as is.
        Inc(Ind);
      end
      else if ch = '#' then
        Result:=Result+UnicodeNumber(InS, Ind)
      else
        Break;
    until False;
    Result:=FixControlChars(QuotedStr(Result));
  end;

var
  InS, OutS: string;
  i: Integer;
begin
  Result:=0;
  OutS:='';
  aInStream.Position:=0;
  SetLength(InS{%H-}, aInStream.Size);
  aInStream.Read(InS[1],length(InS));
  i := 1;
  while i <= Length(InS) do begin
    if InS[i] in ['''', '#'] then
      OutS:=OutS+CollectString(InS, i)
    else begin
      OutS:=OutS+InS[i];
      Inc(i);
    end;
  end;
  // Write data to a new stream.
  aOutStream.Write(OutS[1], Length(OutS));
end;

function ConvertDfmToLfm(const aFilename: string): Integer;

  procedure LogError(Line:Integer;Msg:String);
  begin
    writeln(succ(Line),Msg);
  end;

  function StartWith(s,token: String):boolean;
  var
    l1,l2 : Integer;
  begin
    result := false;
    l1 := length(s);
    l2 := length(token);
    repeat
    if (l2>l1) then
      break;
    if (l2=0) then
      break;
    if (l1=l2) then
       if s<>token then
          break;
    if copy(s,1,length(token))<>token then
        break;

      result := true;
    until true;
  end;

var
  // lfm Object-Datastructure is nested, so we use a stack
  // containing classnames
  ObjectStack : TStringList;

  procedure Push(s:String);
  begin
    ObjectStack.add(s);
  end;

  procedure Pop;
  begin
   ObjectStack.delete(pred(ObjectStack.count));
  end;

  function Top : string;
  begin
   result := ObjectStack[pred(ObjectStack.Count)];
  end;

  function ClassFromLine(s:String):String;
  var
    k : Integer;
  begin
    k := pos(': ',s);
    if (k>0) then
      result := copy(s,k+2,MaxInt)
    else
      result := '';
  end;

var
  ConverterSettings: TStringList;

  function ConvertSingle(const aFileName: String) : Integer;
  var
    n: Integer;
    DFMStream, Utf8LFMStream: TMemoryStream;
    DFM,LFM : TStringList;
    IndentCount: Integer;
    Token: String;

    SkipLine : Boolean;
    SkipIndentCount: Integer;
  begin
    DFMStream := TMemoryStream.Create;
    DFMStream.LoadFromFile(aFilename);

    // Convert Windows WideString syntax (#xxx) to UTF8
    Utf8LFMStream := TMemoryStream.Create;
    result := FixWideString(DFMStream, Utf8LFMStream);
    DFMStream.Free;

    DFM := TStringList.create;
    LFM := TStringList.create;
    Utf8LFMStream.Position:=0;
    DFM.LoadFromStream(Utf8LFMStream);
    Utf8LFMStream.Free;

    // Replace/Delete Objects/Properties
    IndentCount := 0;
    SkipLine := false;
    SkipIndentCount := -1;

    ObjectStack := TStringList.create;

    for n := 0 to pred(DFM.count) do
    begin

      // "end" ?
      if (IndentCount>0) then
      begin
        Token := fill(' ',pred(IndentCount)*2) + 'end';
        if (DFM[n]=Token) then
        begin
         // "end" !
         dec(IndentCount);
         if SkipLine then
         begin
          if (succ(IndentCount)=SkipIndentCount) then
          begin
            SkipLine := false;
            SkipIndentCount := -1;
            continue;
          end;
         end else
         begin
           LFM.add(DFM[n]);
           continue;
         end;
        end;
      end;

      // "object ..." ?
      Token := fill(' ',IndentCount*2) + 'object ';
      if StartWith(DFM[n],Token) then
      begin
        inc(IndentCount);
        push(ClassFromLine(DFM[n]));

        if (ConverterSettings.indexof(Top+'=')<>-1) then
        begin
          // delete this Object
          SkipLine := true;
          SkipIndentCount := IndentCount;
          continue;
        end;

        Token := ConverterSettings.Values[Top];
        if (Token<>'') then
        begin
          // rename this Object
          LFM.add(copy(DFM[n],1,pos(':',DFM[n])+1)+Token);
          continue;
        end;

      end;

      // property ?
      if not(SkipLine) then
       LFM.add(DFM[n]);

    end;

    ObjectStack.free;
    DFM.free;

    LFM.SaveToFile(ChangeFileExt(aFilename, '.lfm'));

  end;

var
   DirS: TStringList;
   WorkPath: String;
   n : Integer;
begin
  Result := 0;

  ConverterSettings := TStringList.create;
  ConverterSettings.LoadFromFile(ExtractFilePath(aFileName)+'dfm2lfm.ini');

  if pos('*',aFileName)>0 then
  begin
    WorkPath := ExtractFilePath(aFileName);
    DirS := TStringList.create;
    dir(aFileName,Dirs,false,false);
    for n := 0 to pred(DirS.count) do
    begin
      write(Dirs[n]+' ... ');
      result := ConvertSingle(WorkPath+Dirs[n]);
      if (result<>0) then
       break;
      writeln('OK');
    end;
  end else
  begin
    result := ConvertSingle(aFileName);
  end;

  ConverterSettings.free;
end;

procedure Tdfm2lfm.DoRun;
var
  ErrorMsg: String;
  ErrorCode: Integer;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }
  try
   ErrorCode := ConvertDfmToLfm(ParamStr(1));
  except
    on E : Exception do writeln(E.Message);
  end;

  writeln;
  write('Press any key to exit ');
  readln;

  // stop program loop
  Terminate(ErrorCode);
end;

constructor Tdfm2lfm.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor Tdfm2lfm.Destroy;
begin
  inherited Destroy;
end;

procedure Tdfm2lfm.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;

var
  Application: Tdfm2lfm;
begin
  Application:=Tdfm2lfm.Create(nil);
  Application.Title:='dfm2lfm';
  Application.Run;
  Application.Free;
end.

