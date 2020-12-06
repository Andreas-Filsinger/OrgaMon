{$mode objfpc}{$H+}
program checkerror;

uses
 classes, sysutils, crt, anfix32, unix, systemlog;


const
 checkFile = '/srv/mnt/ERROR.txt';

// Log to system Log

procedure Log(s: string);
const
 MaxMsgLength = 1024;
var
 LogMsg: array[0..MaxMsgLength] of char;
begin
  StrPCopy(LogMsg,copy(s,1,pred(MaxMsgLength)));
  SysLog(LOG_INFO, '%d: %s',[GetProcessID, LogMsg]);
end;

// Execute a Command

function Exec(s: string) : cint;
begin
  writeln('-- '+s);
  try
    if DebugMode then
      Log(s);
    result := fpsystem(s);
  except
    on E: Exception do Log('Exec.' + e.Message);
  end;
end;

var
 Blinking : boolean;

procedure ON;
begin
 Log('blink: ON');
 Exec('startproc /root/blink');
 Blinking := true;
end;

procedure OFF;
begin
 Log('blink: OFF');
 Exec('killproc /root/blink');
 Blinking := false;
end;
 
begin
  OFF;
  delay(2000);
  repeat 
    if FileExists(checkFile) then
    begin
      if not(Blinking) then
       ON;
    end else
    begin
      if Blinking then
       OFF;
    end;   
    delay(15000); 
  until false;
end.
