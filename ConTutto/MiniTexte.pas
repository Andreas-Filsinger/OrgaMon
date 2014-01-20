unit MiniTexte;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TMiniTexteForm = class(TForm)
    Memo1: TMemo;
    Label1: TLabel;
    Label10: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure Label10Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure WriteOut(OutStr: string);
  end;

var
  MiniTexteForm: TMiniTexteForm;

implementation

{$R *.DFM}


(*
procedure TMiniTexteForm.FormPaint(Sender: TObject);
const
 MyXMargin = 5;
var
 r         : TRect;
 MyTextOut : string;
 ActY      : integer;
 MustBeWidth : integer;
 IncY        : integer;

 function NextP : string;
 var
  k : integer;
 begin
  k := pos(#$0D,MyTextOut);
  if (k>0) then
  begin
   result := copy(MyTextOut,1,pred(k));
   Memo1.lines.add(result);
   MyTextOut := copy(MyTextOut,succ(k),MaxInt);
  end else
  begin
   result := MyTextOut;
   Memo1.lines.add(result);
   MyTextOut := '';
  end;
 end;

 procedure WriteOut;
 var
  TodayStr   : string;
  TodayWidth : integer;
  SubStr     : string;
  _SubStr    : string;
  _TodayStr  : string;
  k          : integer;
  AttrOf     : boolean;
 begin
  with canvas do
  begin
   IncY := TextHeight('A') + 1;
   inc(IncY,IncY DIV 10);
   TodayStr := NextP;
   if pos('\u',TodayStr)=1 then
   begin
    TodayStr := copy(TodayStr,3,MaxInt);
    font.style := [fsunderline];
    AttrOf := true;
   end else
   begin
    AttrOf := false;
   end;
   while true do
   begin
    TodayWidth := TextWidth(TodayStr);
    if (TodayWidth>MustBeWidth) then
    begin

     // Split String until
     SubStr     := '';
     _SubStr    := TodayStr;
     _TodayStr  := '';
     while true do
     begin
      k := pos(' ',TodayStr);
      if k>0 then
      begin
       SubStr := SubStr + copy(TodayStr,1,k);
       TodayStr := copy(TodayStr,succ(k),MaxInt);
      end else
      begin
       SubStr   := SubStr + TodayStr;
       TodayStr := '';
      end;
      if TextWidth(SubStr)>MustBeWidth then
       break;
      _SubStr    := SubStr;
      _TodayStr  := TodayStr;
      if TodayStr='' then
       break;
     end;

     TextOut(MyXMargin,ActY,_SubStr);
     TodayStr := _TodayStr;
     inc(ActY,IncY);
     if AttrOf then
     begin
      font.style := [];
      AttrOf := false;
     end;

    end else
     break;
   end;
   TextOut(MyXMargin,ActY,TodayStr);
   inc(ActY,IncY);
   if AttrOf then
   begin
    font.style := [];
    AttrOf := false;
   end;
  end;
 end;

begin
 if length(OutStr)>800 then
  width := (screen.width-left)-6
 else
  width := 364;

 with canvas do
 begin
  MustBeWidth  := ClientWidth-(MyXMargin*2);

  // Rahmen

  // Zeichen-Fläche
  inc(r.left);
  inc(r.top);
  dec(r.right);
  dec(r.bottom);
  Brush.Color := clInfoBk;
  FillRect(r);

  // Text - Ausgeben
  MyTextOut := OutStr;
  font.style := [fsbold];
  ActY := 5;
  WriteOut;
  inc(ActY,5);
  font.style := [];
  repeat
   WriteOut;
  until (MyTextOut='');
  inc(ActY,15);
  Button1.top := ActY -20;
  Button1.left := ClientWidth-37;
  if clientheight<>ActY then
  begin
   clientheight := ActY;
   if top=0 then
   begin
    top := (screen.height DIV 2) - (height DIV 2);
    left := (screen.width DIV 2) - (width DIV 2);
   end;
   paint;
  end;
 end;
end;
*)

procedure TMiniTexteForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = vk_escape) then
    close;
end;

procedure TMiniTexteForm.WriteOut(OutStr: string);

  function NextP: string;
  var
    k: integer;
  begin
    k := pos(#$0D, OutStr);
    if (k > 0) then
    begin
      result := copy(OutStr, 1, pred(k));
      OutStr := copy(OutStr, succ(k), MaxInt);
    end else
    begin
      result := OutStr;
      OutStr := '';
    end;
  end;

begin
  label1.caption := NextP;
  Memo1.lines.clear;
  while true do
  begin
    Memo1.lines.add(Nextp);
    if OutStr = '' then
      break;
  end;
  showmodal;
end;

procedure TMiniTexteForm.FormPaint(Sender: TObject);
var
  r: TRect;
begin
  r.left := 0;
  r.top := 0;
  r.right := Clientwidth;
  r.Bottom := Clientheight;
  canvas.Brush.Color := clblack;
  canvas.FrameRect(r);
end;

procedure TMiniTexteForm.Label10Click(Sender: TObject);
begin
  close;
end;

end.
