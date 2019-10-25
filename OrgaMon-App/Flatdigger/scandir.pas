unit scandir;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    ListBox1: TListBox;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
  private

  public
    procedure DigFlat(Path:string;MaxSize:int64);

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  DigFlat(edit1.text,1024*1023*1024*4); // 3,996 GB
end;

procedure TForm1.DigFlat(Path: string; MaxSize: int64);
var
  ActualSize : int64;
  OverallSize : int64;
  MoverList: array of TStringList;
  Movers: Integer;
  Mover: TStringList;

  RenameFail : TStringList;
  RemoveFail : TStringList;
  TouchedPath : TStringList;

  RootPath : string;
  SourceSub : string;
  SourcePath : string;

 procedure DoScanDir(const RootPath : string;FocusedPath:string);
 var
  Rslt : TSearchRec;
 begin
   if (FindFirst(RootPath+FocusedPath+'*',faDirectory,Rslt)=0) then
     repeat
      with Rslt do
        repeat
//          listbox1.Items.add(format('%d %4x %s',[Movers, Attr,Name ]) );

          // This is a Subdir?
          if (Attr and FaDirectory=FaDirectory) then
          begin
            // Recurse into SubDir
            if (pos('.',Name)<>1) then
             DoScanDir(RootPath, FocusedPath+Name+'\');
            break;
          end;

          // This is a File!
          OverallSize := OverallSize + Size;

          // If MaxSize is reached, start do fill
          // a "to do list" of Files we should move!
          if (ActualSize+Size>=MaxSize) then
          begin
            inc(Movers);
            SetLength(MoverList,Movers);
            Mover := TStringList.create;
            MoverList[pred(Movers)] := Mover;
            listbox1.Items.add(format('Chunk %d',[ActualSize]));
            ActualSize := Size;
          end else
          begin
            //inc(ActualSize,Size);
            ActualSize := ActualSize + Size;
          end;

          // If we have a "To Do list", add one entry
          if assigned(Mover) then
           Mover.add(FocusedPath+Name);

        until true;
     until (FindNext(Rslt)<>0);
    FindClose(Rslt);
 end;

 function DirEmpty(FocusedPath: string):boolean;
 var
  Rslt : TSearchRec;
  OneFound : boolean;
 begin
   OneFound := false;
   if (FindFirst(FocusedPath+'*',faDirectory,Rslt)=0) then
    repeat
     with Rslt do
     begin
       if (Attr and FaDirectory=FaDirectory) then
       begin
         // A SubDir - but can be "." and ".."
         if (Name<>'.') and (Name<>'..') then
         begin
          OneFound := true;
          break;
         end;
         continue;
       end else
       begin
         // A File!
         OneFound := true;
        break;
       end;
     end;
    until (FindNext(Rslt)<>0);
   FindClose(Rslt);
   result := (OneFound=false);
 end;

var
  n,m : integer;
  OldPath, NewPath, CreatePath : string;
  PatchPositionStart, PatchLen : Integer;
  Patch : string;
  DirCount: Integer;
  DestPath: string;

begin
  listbox1.Items.add(format('Max %d',[MaxSize]));

  PatchPositionStart := succ(pos('#',Path));
  if (PatchPositionStart<3) then
   exit;
  PatchLen := pos('\',copy(Path,succ(PatchPositionStart),MaxInt));
  if (PatchLen<3) then
   exit;

  DirCount := StrToIntDef(copy(Path,PatchPositionStart,PatchLen),-1);
  if (DirCount=-1) then
   exit;

  RootPath := copy(Path,1,PatchPositionStart-2);
  SourceSub := '#' + copy(Path,PatchPositionStart,PatchLen) + '\';
  SourcePath := RootPath + SourceSub;

  ActualSize := 0;
  OverallSize := 0;
  Movers := 0;
  Mover := nil;
  DoScanDir(SourcePath,'');
  listbox1.Items.add(format('Chunk %d',[ActualSize]));
  listbox1.Items.add(format('%d Bytes',[OverallSize]));
  listbox1.Items.add(format('%d Movers',[Movers]));

  ProgressBar1.Position := 0;
  ProgressBar1.Max := 0;
  for n := 0 to pred(Movers) do
   with MoverList[n] do
   begin
    sort; // ensure that we have one Path by another, no switching back to already visited pathes
 //   SaveToFile(RootPath+'Mover-'+IntToStr(n)+'.csv');
    ProgressBar1.Max := ProgressBar1.Max + Count;
   end;

  RenameFail := TStringList.create;
  RemoveFail := TStringList.create;
  TouchedPath :=  TStringList.create;
  for n := low(MoverList) to high(MoverList) do
  begin
    Mover := MoverList[n];
    Patch := format('%.'+IntToStr(PatchLen)+'d',[succ(DirCount+n)]);
    DestPath := RootPath + '#' + Patch + '\';

    OldPath := '*'; // the impossible Path
    for m := 0 to pred(Mover.count) do // from Short-Path to Long-Path
    begin
      NewPath := ExtractFilePath(SourcePath+Mover[m]);
      if (NewPath<>OldPath) then
      begin
        if (TouchedPath.indexof(NewPath)=-1) then
         TouchedPath.add(NewPath);
        CreatePath := ExtractFilePath(DestPath+Mover[m]);
        if not(ForceDirectories(CreatePath)) then
         RenameFail.add('md '+CreatePath);
        OldPath := NewPath;
      end;

      if not(RenameFile(
       { } SourcePath+Mover[m],
       { } DestPath+Mover[m] )) then
       RenameFail.add('mv '+SourcePath+Mover[m]+' '+DestPath+Mover[m]);
      if (m MOD 10=0) then
      begin
        listbox1.items.add(Mover[m]);
        ProgressBar1.Position := ProgressBar1.Position + 10;
        Application.processmessages;
      end;
    end;
  end;

  // Clean up empty SubDirs
  TouchedPath.sort; // ensure "short" path first, than subdirs of it!
  for n := pred(TouchedPath.count) downto 0 do // from "sub" to "root"
   if DirEmpty(TouchedPath[n]) then
     if not(RemoveDir(TouchedPath[n])) then
      RemoveFail.add(TouchedPath[n]);

  // Report Errors
  for n := 0 to pred(RenameFail.count) do
   listbox1.Items.add('ERROR Rename: '+RenameFail[n]);
  for n := 0 to pred(RemoveFail.count) do
   listbox1.Items.add('ERROR Remove: '+RemoveFail[n]);
  ProgressBar1.Position := 0;

end;

end.

