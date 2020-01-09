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
 n,m,f : Integer;
begin
 result := s;
 while (pos('~',result)>0) do
 begin
  f := 0;
  for n := 0 to pred(sHeaders.count) do
  begin
   m := pos('~'+sHeaders[n]+'~',result);
   if (m>0) then
   begin
    inc(f);
    result :=
     copy(result,1,pred(m)) +
     sValues[n] +
     copy(result,m+length(sHeaders[n])+2,MaxInt);
    if (pos('~',result)=0) then
     break;
   end;
  end;
  if (f=0) then
   break;
 end;
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
 Command: String;

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
 
  if (length(sData[n])<3) then
   continue;
  if (sData[n][1]='#') then
   continue; 

  // prepare Data
  sValues := split(sData[n]);

  // assume [0] is speakfull
  writeln(sValues[0]);

  for m := 0 to pred(sParameter.count) do
  begin

   // Dateien sicherstellen
   if (pos('cp ',sParameter[m])=1) then
   begin
    sCopy := split(eval(sParameter[m]),' ');
    if not(FileExists(sCopy[2])) then
     fpsystem('cp '+sCopy[1]+' '+sCopy[2]);
    sCopy.free;
   end;
   
   // Befehle ausführen
   if (pos('! ',sParameter[m])=1) then
   begin
     Command := eval(copy(sParameter[m],3,MaxInt));
     writeln(' ' + Command);
     fpsystem(Command);
   end;

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
