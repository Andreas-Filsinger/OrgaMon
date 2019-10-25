{$mode objfpc}

program zins;

const
 Kontostand            = 33005.40;
 effektiver_Jahreszins = 1.75;
 Finanzierungs_Start   = 201801;
 Finanzierungs_Ende    = 202412;
 Monatliche_Rate_1     = 350.00;
 Monatliche_Rate_2     = 418.63;

function runde(m: double):double;
begin
 result := round (m * 100.00) / 100.0;
end;

function Monatliche_Rate (Monat: Integer):double;
begin
 if (Monat=Finanzierungs_Start) then
  result :=  Monatliche_Rate_1
 else
  result := Monatliche_Rate_2; 
end;
 
procedure incM(var m:Integer);
var
 z : Integer;
begin
 inc(m);
 z := m MOD 100;
 if (z MOD 13=0) then
 begin
  dec(m,12);
  inc(m,100);
 end; 
end;

var
 Monat : Integer;
 Zinsen_pro_Monat : double;
 Saldo: double;

begin

 Monat := Finanzierungs_Start;
 Saldo := Kontostand;
 repeat
  
  if (Monat>Finanzierungs_Ende) then
   break;

  write (Monat, Saldo:10:2 );   
  
  Zinsen_pro_Monat := runde(Saldo * (effektiver_Jahreszins / 100.0) / 12.0);

  Saldo := Saldo - (Monatliche_Rate(Monat) - Zinsen_pro_Monat);

  writeln(Zinsen_Pro_Monat:10:2, Monatliche_Rate(Monat):10:2, Saldo:10:2 );
  
  
  incM(Monat);
 until false;
end.
 