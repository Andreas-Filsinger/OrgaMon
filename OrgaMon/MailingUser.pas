unit MailingUser;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TFormMailingUser = class(TForm)
    Button1: TButton;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
   AdrHeBu : TStringList;
   AdrDebi : TStringList;
   AdrDebiOut : TStringList;
   AdrDebiOut2 : TStringList;
   laender : TStringList;
   namen   : TStringlist;
   weg_count : integer;
  end;

var
  FormMailingUser: TFormMailingUser;

implementation

uses
 anfix32;

{$R *.DFM}

procedure TFormMailingUser.Button1Click(Sender: TObject);
var
 n,m : integer;
 OneLine : string;
 TakeIt : boolean;


 _Firma1,
 _Firma2,
 _Anrede,
 _Vorname,
 _Nachname,
 _str,
 _land,
 _plz,
 _ort        : string;


 function NextMac : string;
 begin
  result := nextp(OneLIne,'",');
  if length(result)>0 then
   if result[1]='"' then
    delete(result,1,1);
  result := cutblank(MacCodes(result));
  if pos(';',result)>0 then
   ersetze(';',',',result);
  if pos(#13,result)>0 then
   ersetze(#13,'',result);
 end;

 function NextPC : string;
 begin
  result := cutblank(OemCodes(nextp(OneLine,';')));
 end;

begin
 AdrHeBu.LoadFromFile('G:\delphi\HebuAdmin\Adressentest.txt');
 AdrDebi.LoadFromFile('G:\delphi\HebuAdmin\debtor.txt');
 with progressbar1 do
 begin
  max := AdrHebu.count + Adrdebi.count;
  step := 1;
  position := 0;
 end;
 laender.clear;
 namen.clear;
 for n := 0 to pred(AdrHebu.count) do
 begin
  OneLine := AdrHebu[n] + ',';

  _firma1   := nextMac;
  _firma2   := '';
  _Vorname  := nextMac;
  _Nachname := nextMac;
  _Anrede := nextMac;
  _str := nextMac;
  _ort := nextMac;
  _land := nextMac;
  _plz := nextMac;

  AdrHebu[n] := _firma1+';'+
                _firma2+';'+
                _Anrede+';'+
                _Vorname+';'+
                _Nachname+';'+
                _str+';'+
                _land+';'+
                _plz+';'+
                _ort;

  if _nachname+_vorname<>'' then
   namen.add(ansiuppercase(_Nachname+_vorname));
  if _firma1<>'' then
   namen.add(ansiuppercase(_firma1));
  namen.add(noblank(ansiuppercase(_plz+_str)));
  progressbar1.stepit;
 end;
 namen.sort;
 namen.sorted := true;
 AdrHebu.SaveToFile('G:\delphi\HebuAdmin\Adressentest 2.txt');

// AdrDebiOut.LoadFromFile('G:\delphi\HebuAdmin\Adressentest 2.txt');
 AdrDebiOut.clear;

 for n := 0 to pred(AdrDebi.count) do
 begin
  progressbar1.stepit;
  OneLine := AdrDebi[n];
    nextPC;
   _Firma1 := nextPC;
   _Firma2 := nextPC;
   _Anrede := nextPC;
   _Vorname := nextPC;
   _Nachname := nextPC;
   _str := nextPC;
    nextPC;
   _plz := nextPC;
   _ort := nextPC;

   _land := nextPC;

   TakeIt := false;
   if _land='' then
   begin
    _land := 'D-';
    takeit := true;
   end else
   begin
    inc(weg_count);
    continue;
(*
    if laender.indexof(_Land)=-1 then
     laender.add(_Land);

    if pos('Schweiz',_land)>0 then
    begin
     _Land := 'CH-';
     TakeIt := true;
    end;

    if pos('Österreich',_land)>0 then
    begin
     _land := 'A-';
     TakeIt := true;
    end;
*)

    if not(TakeIt) then
     continue;

   end;

  if _nachname+_vorname<>'' then
  begin
   if namen.indexof(ansiuppercase(_nachname+_vorname))=-1 then
    TakeIt := true
   else
   begin
    inc(weg_count);
    TakeIt := false;
    continue;
   end;
  end;

  if _firma1+_firma2<>'' then
  begin
   if namen.indexof(ansiuppercase(_firma1+' '+_firma2))=-1 then
    TakeIt := true
   else
   begin
    inc(weg_count);
    TakeIt := false;
    continue;
   end;
  end;

   if namen.indexof(noblank(ansiuppercase(_plz+_str)))=-1 then
    TakeIt := true
   else
   begin
    inc(weg_count);
    TakeIt := false;
    continue;
   end;

  if (_land='D-') and (length(_plz)<>5) then
  begin
   inc(weg_count);
   TakeIt := false;
   continue;
  end;

  if TakeIt then
    AdrDebiOut.add( _firma1+';'+
                  _firma2+';'+
                  _Anrede+';'+
                  _Vorname+';'+
                  _Nachname+';'+
                  _str+';'+
                  _land+';'+
                  _plz+';'+
                  _ort)


 end;
 AdrDebiOut.sort;
 RemoveDuplicates(AdrDebiOut);
 AdrDebiOut2.sort;
 RemoveDuplicates(AdrDebiOut2);
 AdrDebiOut.SaveToFile('G:\delphi\HebuAdmin\debtor 2.txt');
 AdrDebiOut2.SaveToFile('G:\delphi\HebuAdmin\debtor 3.txt');
 laender.SaveToFile('G:\delphi\HebuAdmin\laender.txt');
 namen.SaveToFile('G:\delphi\HebuAdmin\namen.txt');
 ShowMessage(inttostr(Weg_Count));
 close;
end;

procedure TFormMailingUser.FormCreate(Sender: TObject);
begin
 AdrHeBu     := TStringList.create;
 AdrDebi     := TStringList.create;
 AdrDebiOut  := TStringList.create;
 AdrDebiOut2 := TStringList.create;
 laender     := TStringList.create;
 namen       := TStringlist.create;
 randomize;
end;

end.
