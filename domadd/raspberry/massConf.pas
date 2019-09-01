program massConf;

{$mode objfpc}{$H+}

uses
 Classes, SysUtils, Unix;


function split(s:string; Delimiter:string=';'):TStringList;
var
 n : Integer;
begin
 result := TStringList.create;
 repeat
  n := pos(Delimiter,s);
  if (n>0) then
  begin
   result.add( copy(s,1,pred(n)));
   s := copy(s,succ(n),MaxInt);
  end else
  begin
   result.add(s);
   break;
  end;
 until false;
end;

var
 sHeaders : TStringList;
 sValues : TStringList;

const
 Param = 'ablagen';


function eval(s:string):string;
var
 n,m : Integer;
begin
 if (pos('~',s)>0) then
 begin
  for n := 0 to pred(sHeaders.count) do
  begin
   m := pos('~'+sHeaders[n]+'~',s);
   if (m>0) then
   begin
    s :=
     copy(s,1,pred(m)) +
     sValues[n] +
     copy(s,m+length(sHeaders[n])+2,MaxInt);
    if (pos('~',s)=0) then
     break;
   end;
  end;
 end;
 result := s;
end;

var
 sConf : TStringList;
 sParameter : TStringList;
 sTemplate : TStringList;
 sOutPut : TStringList;
 sData : TStringList;
 sCopy : TStringList;
 n,m : Integer;
 StartDataFlag : boolean;

 // Parameter
 pOutput : string;

begin
 sConf := TStringList.create;
 sConf.loadfromFile(Param+'.conf');

 StartDataFlag := false;
 sTemplate := TStringList.create;
 sParameter := TStringList.create;
 for n := 0 to pred(sConf.count) do
 begin
  if StartDataFlag then
  begin
   sTemplate.add(sConf[n]);
  end else
  begin
   if (pos('#',sConf[n])<>1) then
     sParameter.add(sConf[n]);
  end;
  if not(StartDataFlag) then
   if (sConf[n]=':') then
    StartDataFlag := true;
 end;
 sConf.free;

 // Load the parameter, more to come
 pOutPut := sParameter.values['Output'];

 sData := TStringList.create;
 sData.loadfromFile(Param+'.csv');

 sHeaders := split(sData[0]);

 for n := 1 to pred(sData.count) do
 begin

  // prepare Data
  sValues := split(sData[n]);

  // assume [0] is speakfull
  write( sValues[0] + ' ... ' );

  // Dateien sicherstellen?
  for m := 0 to pred(sParameter.count) do
   if (pos('cp ',sParameter[m])=1) then
   begin
    sCopy := split(eval(sParameter[m]),' ');
    if not(FileExists(sCopy[2])) then
     fpsystem('cp '+sCopy[1]+' '+sCopy[2]);
    sCopy.free;
   end;

  // Template ausbelichten
  sOutPut := TStringList.create;
  for m := 0 to pred(sTemplate.count) do
   sOutPut.add( eval(sTemplate[m]));
  sOutPut.saveToFile(eval(pOutPut));
  sOutPut.free;

  // unprepare
  sValues.free;

  writeln('OK');

 end;

 sData.free;
 sHeaders.free;
 sTemplate.free;
 sParameter.free;

end.
