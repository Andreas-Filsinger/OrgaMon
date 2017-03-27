program r2fips;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp
  { you can add units after this };

type

  { Tr2fips }

  Tr2fips = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ Tr2fips }

procedure Tr2fips.DoRun;
var
  ErrorMsg: String;
  Path : string;
  OldExt, NewExt : string;
  sr : Tsearchrec;
  DosError: Longint;
  Candidates: TStringList;
  n: integer;

  function LocalRename ( old: string) : string;
  begin
    result :=
     {} copy(old,1,length(old)-length(OldExt)) +
     {} NewExt;
  end;

begin
  // quick check parameters
  ErrorMsg:=CheckOptions('hp:e:o:','help path extension old');
  if (ErrorMsg<>'') then
  begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h') then
  begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  if HasOption('p') then
   Path := GetOptionValue('p')
  else
   Path := GetCurrentDir + DirectorySeparator;

  if length(Path)=0 then
  begin
    ShowException(Exception.Create('Path is empty'));
    Terminate;
    Exit;
  end;

  if Path[length(Path)]<>DirectorySeparator then
  begin
    ShowException(Exception.Create('last Character of Path must be '+DirectorySeparator));
    Terminate;
    Exit;
  end;

  if HasOption('e') then
   NewExt := GetOptionValue('e')
  else
   NewExt := 'fips';

  if HasOption('o') then
   OldExt := GetOptionValue('o')
  else
   OldExt := 'xml';

  Candidates := TStringList.create;
  DosError := findfirst(path + '*.' + OldExt, faAnyFile - faDirectory, sr);
  while (DosError = 0) do
  begin
    repeat
      if (sr.Name = '.') then
        break;
      if (sr.Name = '..') then
        break;
      if (sr.Name = 'Vorlage.xml') then
        break;
      Candidates.add(sr.Name);
    until true;
    DosError := FindNext(sr);
  end;
  findclose(sr);

  // the work
  for n := 0 to pred(Candidates.count) do
   RenameFile(Path + Candidates[n], Path + LocalRename(Candidates[n]));

  if (Candidates.count>0) then
   writeln('renamed '+IntToStr(Candidates.count)+' file(s)!');

  Candidates.Free;

  // stop program loop
  Terminate;
end;

constructor Tr2fips.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor Tr2fips.Destroy;
begin
  inherited Destroy;
end;

procedure Tr2fips.WriteHelp;
begin
  { add your help code here }
  writeln('Version 1.0');
  writeln('');
  writeln('-h                 show this help');
  writeln('-p <path>          source Path, default is current working directory');
  writeln('-o <OldExtension>  rename "from" extension, default is xml');
  writeln('-e <NewExtension>  rename "to" extension, default is fips');
end;

var
  Application: Tr2fips;
begin
  Application:=Tr2fips.Create(nil);
  Application.Title:='r2fips';
  Application.Run;
  Application.Free;
end.

