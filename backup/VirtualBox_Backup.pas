
{$mode objfpc}
{$H+}


// Erstellen einer Sicherungskopie einer VM
program VirtualBox_Backup;

uses
 Classes, SysUtils, Unix, SystemLog;

var
 DebugMode : boolean = false;

const 
 cWorkPath = '/srv/vbx/';
 cBakPath = '/srv/smb/ra6/Datensicherung/AndreasFilsinger/VMs/';
 yet = true;

//

function bak_FName (VM:string):string;
begin
  result := cBakPath + VM + '.7z';
end;

function vdi_FName (VM:string):string;
begin
  result := cWorkPath + VM + '/' + VM + '.vdi';
end;

// Log to system Log

procedure Log(s: string);
const  
 MaxMsgLength = 1024;
var  
 LogMsg: array[0..MaxMsgLength] of char;
begin
  writeln(s);
  StrPCopy(LogMsg,copy(s,1,pred(MaxMsgLength))); 
  SysLog(LOG_INFO, '%d: %s',[GetProcessID, LogMsg]);
end;
      
// Execute a Command
      
function Exec(s: string) : cint;
begin
  writeln('# '+s);
  try
    if DebugMode then
     Log(s);
    result := fpsystem(s);
  except
    on E: Exception do Log('Exec.' + e.Message);
  end;
end;

{ isDown

  true: VM exists AND VMs State is "powered off"

  false: VM unknown or VMs State <> "powered off"
}

function isDown(VM:string):boolean;
const
 TMP_FileName = 'State.tmp';
var
 sResult : TStringList;
begin
 DeleteFile(cWorkPath+TMP_FileName);
 Exec('VBoxManage showvminfo ' + VM + ' | grep State > '+cWorkPath+TMP_FileName);

 sResult := TStringList.create;
 sResult.LoadFromFile(cWorkPath+TMP_FileName);
 repeat
  if (sResult.count>0) then
   if (pos('powered off',sResult[0])>0) then
   begin
    result := true;
    break;
   end; 
    
  result := false;
 until yet;
 sResult.free;
end;

// if there is a chanche to shrink the vdi

procedure doCleanUp(VM:string);
begin
 // VBoxManage modifymedium "VirtualBox VMs/VPN/VPN.vdi" -compact
 // Ich habe festgestellt dass dies in meinem Fall nix bringt
 // Man müsste erst Defrag, dann Zero-Fill machen
end;

// backup it to a archive

procedure doBackup(VM:string);
begin
 DeleteFile(bak_FName(VM));
 Log('INFO: try to 7z - this takes a long time ...');
 Exec(
  { } '7za a -t7z -mx=1 ' + 
  { } '"'+bak_FName(VM)+'"' + ' ' +
  { } '"' + cWorkPath + VM + '/*"');
 Log('INFO: back from 7z ...');
end;

// have 7za?
function have7zip : boolean;
const
 TMP_FileName = '7za.tmp';
var
 sl : TStringList;
 n : Integer;
begin
  result := false;
  DeleteFile(cWorkPath+TMP_FileName);
  Exec('7za > '+cWorkPath+TMP_FileName);
  if not(FileExists(cWorkPath+TMP_FileName)) then
  begin
    Log('ERROR: Can not Exec');
    exit;
  end;
  sl := TStringList.create;
  sl.LoadFromFile(cWorkPath+TMP_FileName);
  for n := 0 to pred(sl.Count) do
   if pos('Pavlov',sl[n])>0 then
   begin
    result := true;
    break;
   end;
end; 

// Main function

procedure run(VM:string);
var
 FA_BAK, FA_VDI : LongInt;
begin
 repeat

  // prüfen ob 7za installiert ist: zypper install p7zip-full  
  if not(have7zip) then
  begin
    Log('ERROR: Command Line Tool 7za not installed');
    Log('Try "zypper install p7zip-full"');
    break;
  end; 

  // 
  FA_VDI := FileAge(vdi_FName(VM));
  if (FA_VDI=-1) then
  begin
   Log('ERROR: "'+vdi_FName(VM)+'" not found');
   break;
  end; 
  
  //  
  FA_BAK := FileAge(bak_FName(VM));
  if (FA_BAK=-1) then
   Log('WARNING: no old BAK');

  // 
  if (FA_VDI<=FA_BAK) then
  begin
   Log('INFO: '+VM+' Backup is up to date');
   break;
  end;
  
  if isDown(VM) then
  begin
   doCleanUp(VM);
   doBackup(VM);
   break;
  end; 
  
  Log('WARNING: Should, but can not BACKUP due VM '+VM+' is running');
  
 until yet; 
end;

begin
 run('VPN');
end.
