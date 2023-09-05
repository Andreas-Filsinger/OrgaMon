{$mode objfpc}{$H+}
program bakexternal;

{

Aufgaben
========

* Sichert die Quelle rsyncd "srv" auf einen bestimmten externen
  Datenträger in das Unterverzeichnis "srv".
* Dabei wird durch die Kalenderwoche festgelegt welcher Datenträger
  in Gebrauch ist - ist der passende Datenträger nicht sichtbar
  wird auch NICHT gesichert, dann ist ein manueller Eingriff nötig
* am "Wechseltag" (das ist ein einstellbarer Wochentag, 1 ist Montag)
  sollte das Sicherungsmedium getauscht werden. Dieser Tag ist eine Aus-
  nahme, da wird fehlertolerant auf das jeweils angeschlossene
  Medium gesichert

Begriffe
========

SetAnzahl     : Ist die Anzahl der externen Datenträger, die im
                Wechsel eingesetzt werden. Empfohlen 3
ToleranceDay  : Ist der Tag des Medium-Wechsels, an dem Tag werden
                das aktuelle und das zukünftige Medium akzeptiert          
            
Parameter
=========

siehe bakexternal.ini

Funktion
========

+ stelle fest, welche Kalenderwoche ist
+ berechne welches Set dran ist durch "wk Modulo SetAnzahl"
+ hole aus der config den Partitions-uuid der Sicherungsparition
++ Zu ermitteln mit lsblk -o NAME,LABEL,FSTYPE,PARTUUID | grep ntfs
++ Prefix "/dev/disk/by-partuuid/" muss eintragen werden 
+ prüfe auf diese id auf dem Datenträger, 
++ nicht vorhanden: try-mount für diesen Datenträger
+ mache die Sicherung
+ gibt es eine Verifizierung der Sicherung, wenn ja machen (aber wie?) 
* sync und umount des Datenträgers
* dokumentiere in einer für alle sichtbaren Datei (ResultFile) 
  "Letztes erfolgreiches Backup" 

}

uses
 crt, classes, anfix32, 
 iniFiles, Unix, SysUtils, 
 SystemLog;

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
  writeln(' # '+s);
  try
    Log(s);
    result := fpsystem(s);
  except
    on E: Exception do Log('Exec.' + e.Message);
  end;
end;

const
 BoldOn  = #27+'[1m';
 BoldOff = #27+'[0m';

var 
 TerminalIsBold : Integer = 0;
 
procedure B;
begin
 if (TerminalIsBold=0) then
  write(BoldOn);
 inc(TerminalIsBold);
end;

procedure _;
begin
 if (TerminalIsBold>0) then
 begin
  dec(TerminalIsBold);
  if (TerminalIsBold=0) then
   write(BoldOff);
 end;  
end;

const
 NameSpace = 'System'; 
 FileOnEveryUsbDrive = 'bakexternal.txt';
 
var
 // Settings
 Settings : TMemIniFile;
 pSetAnzahl : Integer;
 pWechselTag : Integer;
 pMountPoint : String;
 pKWOffset : Integer;

 // 
 kw,SetNum : byte;

 ERROR_MSG : String;
 ERROR_FName : String;
 
 t,d : TAnfixDate;
 n,w : Integer;
 Mounted: boolean;

function BackupKalenderWoche(d:TAnfixDate):byte;
begin
 result := Kalenderwoche(DatePlus(d,-pred(pWechselTag)));
end;

function ToleranceDay(d:TAnfixDate):boolean;
begin
 result := (WeekDay(d)=pWechselTag);
end;

function PartitionUUID(SetNum:byte):string;
begin
  result := Settings.ReadString(NameSpace,IntToStr(SetNum),'');
end;

function TryMount(SetNum:byte):boolean;
var
 PartitionName : String;
begin
  result := false;

  // Already Mounted, Unmount;
  if DirExists(pMountPoint+'/srv') then
   Exec('umount '+pMountPoint);  

  PartitionName := PartitionUUID(SetNum);
  if (PartitionName='') then
  begin
    ERROR_MSG := 'PartitionsUUID ' + IntToStr(SetNum) + 'nicht in der .ini definiert';
    exit;
  end;
  
  Exec('mount /dev/disk/by-partuuid/'+PartitionName+' '+pMountPoint);

  result := FileExists(pMountPoint + '/' + FileOnEveryUsbDrive);
end;

begin
 ERROR_MSG := '';
 Settings := TMemIniFile.Create('/root/bakexternal.ini');
 pSetAnzahl := StrToIntDef(Settings.ReadString(NameSpace,'SetAnzahl','0'),0);
 pWechselTag := StrToIntDef(Settings.ReadString(NameSpace,'WechselTag','1'),1);
 pMountPoint := Settings.ReadString(NameSpace,'mount','');
 pKWOffset := StrToIntDef(Settings.ReadString(NameSpace,'KWOffset','0'),0);

 repeat
                                               
  writeln('+==========+=========+=============+====================================+');
  writeln('|'+BoldOn+'Datum     '+BoldOff+
          '|'+BoldOn+'Wochentag'+BoldOff+
          '|'+BoldOn+'Kalenderwoche'+BoldOff+
          '|'+BoldOn+'Partition'+BoldOff+'                           '+
          '|');
  writeln('+==========+=========+=============+====================================+');
  t := DateGet;
  for n := -8 to 8 do 
  begin
   write('|');

   d := DatePlus(t,n);
   if (d=t) then 
    B;
   write(long2date(d):5);
   _;
   write('|');

   w := WeekDay(d);
   if ToleranceDay(d) then
    B;
   write(w:9);
   _;
   write('|');

   write(Kalenderwoche(d):6,
         '->',
         BackupKalenderwoche(d):5);
   write('|');

   if ToleranceDay(d) then
    write('* (Toleranz-Tag)',' ':20)
   else   
    write( PartitionUUID( (BackupKalenderwoche(d) + pKWOffset) MOD pSetAnzahl ));
   writeln('|');
   
  end; 
  writeln('+==========+=========+=============+====================================+');

  kw := BackupKalenderwoche(DateGet);
  writeln('KW=', kw, '+', pKWOffset);
  
  SetNum := (kw + pKWOffset) MOD pSetAnzahl;
  writeln('Set=', SetNum);

  if paramstr(1)<>'' then
   halt;

  Mounted := TryMount(SetNum);
  if (ERROR_MSG='') then
   if not(Mounted) then
    if ToleranceDay(DateGet) then
    begin
     Log('ToleranceDay, try alternatives ...');
     for n := 0 to pred(pSetAnzahl) do
      if (n<>SetNum) then
      begin
        Mounted := TryMount(n);
        if Mounted then 
          break;
        if (ERROR_MSG<>'') then
          break; 
      end; 
    end;
     
  if (ERROR_MSG<>'') then 
   break;

  if not(Mounted) then
  begin
   ERROR_MSG := 'Mount war erfolglos, ist die richtige Platte angeschlossen?';
   break;
  end;   
  
  Exec('/root/bakexternal.sh');
  
  Exec('sync');
  
  Exec('umount '+pMountPoint);

 until yet;

 if (ERROR_MSG<>'') then
 begin
   writeln;
   write('ERROR: ');
   B;
   writeln(ERROR_MSG);
   _;
   ERROR_FName := Settings.ReadString(NameSpace,'errorfile','/root/ERROR.txt');
   AppendStringsToFile(sTimeStamp+' '+ERROR_MSG+#$0D#$0A,ERROR_FName);
   Exec('chmod 777 '+ERROR_FName);
   Log(ERROR_MSG);
 end;

 Settings.free;
end.
