{$Mode Delphi}
program sone;

uses
 sd_daemon, 
 sysutils,
 strings,
 BaseUnix;
 
 
 
 const
  bhup: boolean = false;
  bterm : boolean = false;


 { handle SIGHUP & SIGTERM }
 procedure DoSig(sig: longint); cdecl;
 begin
   if bterm then
   begin
    writeln('Sorry, i ignore Signal ', sig, ' - shutting down ...');
   end else
   begin
   case sig of
       SIGHUP: begin
              write('Restarting ... ');
              bhup := true;
              end;
       SIGTERM: begin
       write('Saving(1) ... ');
       bTerm := true;
       end;
       SIGINT: begin
       write('Saving(3) ... ');
       bTerm := true;
       end;
   else
    writeln('Unkown Signal ... '+inttostr(sig));
   end;
   end;
end;

var
 n : integer;
 s : string;
 _s: PChar;
  aOld,
      aTerm,
          aHup, aInt: pSigActionRec;
            ps1: psigset;
              sSet: cardinal;
                pid: pid_t;
                  secs: longint;
                  
                    zerosigs: sigset_t;
begin



    fpsigemptyset(zerosigs);
    
        { set global daemon booleans }
            bHup := true; { to open log file }
                bTerm := false;
                
                    { block all signals except -HUP & -TERM }
                        sSet := $FFFFBFFE;
                        sSet := $FFFFFFFF - SIGTERM;
                            ps1 := @sSet;
                                //fpsigprocmask(SIG_BLOCK, ps1, nil);
                                
                                    { setup the signal handlers }
                                        new(aOld);
                                            new(aHup);
                                                new(aTerm);
                                                new(aInt);
                                                    aTerm^.sa_handler { .sh } := SigactionHandler(@DoSig);
                                                    
                                                        aTerm^.sa_mask := zerosigs;
                                                            aTerm^.sa_flags := 0;
                                                            {$IFNDEF BSD}                { Linux'ism }
                                                                aTerm^.sa_restorer := nil;
                                                                {$ENDIF}
                                                                    aHup^.sa_handler := SigactionHandler(@DoSig);
                                                                        aHup^.sa_mask := zerosigs;
                                                                            aHup^.sa_flags := 0;
                                                                            {$IFNDEF BSD}                { Linux'ism }
                                                                                aHup^.sa_restorer := nil;
                                                                                {$ENDIF}
                                                                    aInt^.sa_handler := SigactionHandler(@DoSig);
                                                                        aInt^.sa_mask := zerosigs;
                                                                            aInt^.sa_flags := 0;
                                                                            {$IFNDEF BSD}                { Linux'ism }
                                                                                aInt^.sa_restorer := nil;
                                                                                {$ENDIF}
                                                                                    fpSigAction(SIGTERM, aTerm, aOld);
                                                                                    fpSigAction(SIGINT, aInt, aOld);
                                                                                        fpSigAction(SIGHUP, aHup, aOld);
                                                                                        














_s:=StrAlloc (1024);
repeat

 write('Initialization ... ');
 sleep(2000);

 sd_notify(0,'READY=1');

 writeln('OK');
 n := 1;
 bHup := false;

repeat
  Write(inttostr(n)+' ... ');
  sleep(1000);
  writeln('OK');
  s := 'STATUS=Processing Job #'+inttostr(n)+' ...' ;
  StrPCopy(_s,s);
  sd_notify(0,_s);
  inc(n);
  if (n mod 10=0) then
  begin
   writeln('STILL ALIVE! ... OK');
   sd_notify(0, 'WATCHDOG=1');
  end; 
 until bTerm or bHup;
 writeln('OK');
until bTerm; 
end.  