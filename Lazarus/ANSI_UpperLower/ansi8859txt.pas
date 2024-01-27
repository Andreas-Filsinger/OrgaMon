unit ANSI8859txt;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

const
 ANSI_8859_15_Upper : array[0..255] of char = (#$00, #$01,
  #$02, #$03, #$04, #$05, #$06, #$07, #$08, #$09, #$0A, #$0B, #$0C, #$0D, #$0E, #$0F, #$10, #$11,
  #$12, #$13, #$14, #$15, #$16, #$17, #$18, #$19, #$1A, #$1B, #$1C, #$1D, #$1E, #$1F, #$20, #$21,
  #$22, #$23, #$24, #$25, #$26, #$27, #$28, #$29, #$2A, #$2B, #$2C, #$2D, #$2E, #$2F, #$30, #$31,
  #$32, #$33, #$34, #$35, #$36, #$37, #$38, #$39, #$3A, #$3B, #$3C, #$3D, #$3E, #$3F, #$40, #$41,
  #$42, #$43, #$44, #$45, #$46, #$47, #$48, #$49, #$4A, #$4B, #$4C, #$4D, #$4E, #$4F, #$50, #$51,
  #$52, #$53, #$54, #$55, #$56, #$57, #$58, #$59, #$5A, #$5B, #$5C, #$5D, #$5E, #$5F, #$60, {#$61->}#$41,
  {#$62->}#$42, {#$63->}#$43, {#$64->}#$44, {#$65->}#$45, {#$66->}#$46, {#$67->}#$47, {#$68->}#$48, {#$69->}#$49, {#$6A->}#$4A, {#$6B->}#$4B, {#$6C->}#$4C, {#$6D->}#$4D, {#$6E->}#$4E, {#$6F->}#$4F, {#$70->}#$50, {#$71->}#$51,
  {#$72->}#$52, {#$73->}#$53, {#$74->}#$54, {#$75->}#$55, {#$76->}#$56, {#$77->}#$57, {#$78->}#$58, {#$79->}#$59, {#$7A->}#$5A, #$7B, #$7C, #$7D, #$7E, #$7F, #$80, #$81,
  #$82, #$83, #$84, #$85, #$86, #$87, #$88, #$89, #$8A, #$8B, #$8C, #$8D, #$8E, #$8F, #$90, #$91,
  #$92, #$93, #$94, #$95, #$96, #$97, #$98, #$99, #$9A, #$9B, #$9C, #$9D, #$9E, #$9F, #$A0, #$A1,
  #$A2, #$A3, #$A4, #$A5, #$A6, #$A7, {#$A8->}#$A6, #$A9, #$AA, #$AB, #$AC, #$AD, #$AE, #$AF, #$B0, #$B1,
  #$B2, #$B3, #$B4, #$B5, #$B6, #$B7, {#$B8->}#$B4, #$B9, #$BA, #$BB, #$BC, {#$BD->}#$BC, #$BE, #$BF, #$C0, #$C1,
  #$C2, #$C3, #$C4, #$C5, #$C6, #$C7, #$C8, #$C9, #$CA, #$CB, #$CC, #$CD, #$CE, #$CF, #$D0, #$D1,
  #$D2, #$D3, #$D4, #$D5, #$D6, #$D7, #$D8, #$D9, #$DA, #$DB, #$DC, #$DD, #$DE, #$DF, {#$E0->}#$C0, {#$E1->}#$C1,
  {#$E2->}#$C2, {#$E3->}#$C3, {#$E4->}#$C4, {#$E5->}#$C5, {#$E6->}#$C6, {#$E7->}#$C7, {#$E8->}#$C8, {#$E9->}#$C9, {#$EA->}#$CA, {#$EB->}#$CB, {#$EC->}#$CC, {#$ED->}#$CD, {#$EE->}#$CE, {#$EF->}#$CF, {#$F0->}#$D0, {#$F1->}#$D1,
  {#$F2->}#$D2, {#$F3->}#$D3, {#$F4->}#$D4, {#$F5->}#$D5, {#$F6->}#$D6, #$F7, {#$F8->}#$D8, {#$F9->}#$D9, {#$FA->}#$DA, {#$FB->}#$DB, {#$FC->}#$DC, {#$FD->}#$DD, {#$FE->}#$DE, {#$FF->}#$BE);
ANSI_8859_15_Lower : array[0..255] of char = (#$00, #$01,
  #$02, #$03, #$04, #$05, #$06, #$07, #$08, #$09, #$0A, #$0B, #$0C, #$0D, #$0E, #$0F, #$10, #$11,
  #$12, #$13, #$14, #$15, #$16, #$17, #$18, #$19, #$1A, #$1B, #$1C, #$1D, #$1E, #$1F, #$20, #$21,
  #$22, #$23, #$24, #$25, #$26, #$27, #$28, #$29, #$2A, #$2B, #$2C, #$2D, #$2E, #$2F, #$30, #$31,
  #$32, #$33, #$34, #$35, #$36, #$37, #$38, #$39, #$3A, #$3B, #$3C, #$3D, #$3E, #$3F, #$40, {#$41->}#$61,
  {#$42->}#$62, {#$43->}#$63, {#$44->}#$64, {#$45->}#$65, {#$46->}#$66, {#$47->}#$67, {#$48->}#$68, {#$49->}#$69, {#$4A->}#$6A, {#$4B->}#$6B, {#$4C->}#$6C, {#$4D->}#$6D, {#$4E->}#$6E, {#$4F->}#$6F, {#$50->}#$70, {#$51->}#$71,
  {#$52->}#$72, {#$53->}#$73, {#$54->}#$74, {#$55->}#$75, {#$56->}#$76, {#$57->}#$77, {#$58->}#$78, {#$59->}#$79, {#$5A->}#$7A, #$5B, #$5C, #$5D, #$5E, #$5F, #$60, #$61,
  #$62, #$63, #$64, #$65, #$66, #$67, #$68, #$69, #$6A, #$6B, #$6C, #$6D, #$6E, #$6F, #$70, #$71,
  #$72, #$73, #$74, #$75, #$76, #$77, #$78, #$79, #$7A, #$7B, #$7C, #$7D, #$7E, #$7F, #$80, #$81,
  #$82, #$83, #$84, #$85, #$86, #$87, #$88, #$89, #$8A, #$8B, #$8C, #$8D, #$8E, #$8F, #$90, #$91,
  #$92, #$93, #$94, #$95, #$96, #$97, #$98, #$99, #$9A, #$9B, #$9C, #$9D, #$9E, #$9F, #$A0, #$A1,
  #$A2, #$A3, #$A4, #$A5, {#$A6->}#$A8, #$A7, #$A8, #$A9, #$AA, #$AB, #$AC, #$AD, #$AE, #$AF, #$B0, #$B1,
  #$B2, #$B3, {#$B4->}#$B8, #$B5, #$B6, #$B7, #$B8, #$B9, #$BA, #$BB, {#$BC->}#$BD, #$BD, {#$BE->}#$FF, #$BF, {#$C0->}#$E0, {#$C1->}#$E1,
  {#$C2->}#$E2, {#$C3->}#$E3, {#$C4->}#$E4, {#$C5->}#$E5, {#$C6->}#$E6, {#$C7->}#$E7, {#$C8->}#$E8, {#$C9->}#$E9, {#$CA->}#$EA, {#$CB->}#$EB, {#$CC->}#$EC, {#$CD->}#$ED, {#$CE->}#$EE, {#$CF->}#$EF, {#$D0->}#$F0, {#$D1->}#$F1,
  {#$D2->}#$F2, {#$D3->}#$F3, {#$D4->}#$F4, {#$D5->}#$F5, {#$D6->}#$F6, #$D7, {#$D8->}#$F8, {#$D9->}#$F9, {#$DA->}#$FA, {#$DB->}#$FB, {#$DC->}#$FC, {#$DD->}#$FD, {#$DE->}#$FE, #$DF, #$E0, #$E1,
  #$E2, #$E3, #$E4, #$E5, #$E6, #$E7, #$E8, #$E9, #$EA, #$EB, #$EC, #$ED, #$EE, #$EF, #$F0, #$F1,
  #$F2, #$F3, #$F4, #$F5, #$F6, #$F7, #$F8, #$F9, #$FA, #$FB, #$FC, #$FD, #$FE, #$FF);



procedure TForm1.Button1Click(Sender: TObject);
const
 cUpperTag = 'LATIN CAPITAL';
 cLowerTag = 'LATIN SMALL';


var
  CharsetFile : TStringList;

  procedure setLigatureName(i:Integer; var LigatureName: String; var LigatureUpper : boolean);
  var
   k : Integer;
  begin
    repeat

      k := pos(cUpperTag,CharsetFile[i]);
      if (k>0) then
      begin
       LigatureName := copy(CharsetFile[i],k+length(cUpperTag)+1,MaxInt);
       LigatureUpper := true;
       break;
      end;

     k := pos(cLowerTag,CharSetFile[i]);
     if (k>0) then
     begin
      LigatureName := copy(CharsetFile[i],k+length(cLowerTag)+1,MaxInt);
      LigatureUpper := false;
      break;
     end;

     LigatureName := '';
    until true;

  end;

  procedure setCode(i:Integer; var TwoDigitHexCode: string);
  begin
    TwoDigitHexCode := '#$' + copy(CharSetFile[i],3,2);
  end;

var
  n : Byte;
  LineIndex,k,m: Integer;
  LigatureName, _LigatureName: String;
  LigatureUpper, _LigatureUpper: boolean;
  FoundPairs: Integer;
  CharCodeA, CharCodeB: string;

  MapUpper, MapLower : string;

begin
  CharsetFile := TStringList.create;
  CharsetFile.LoadFromFile(edit1.text);
  LineIndex := 0;
  MapUpper := 'ANSI_8859_15_Upper : array[0..255] of char = (';
  MapLower := 'ANSI_8859_15_Lower : array[0..255] of char = (';

  for n := 0 to 255 do
  begin

    // 1. Find the Line with chr "n"
    repeat
      if (LineIndex>=CharsetFile.count) then
       break;
      if (pos('0x'+HexStr(n,2)+#9,CharsetFile[LineIndex])=1) then
        break;
      inc(LineIndex);
    until false;

    // 2. Extract the Name of the Character
    setCode(LineIndex, CharCodeA);
    setLigatureName(LineIndex, LigatureName, LigatureUpper);

    // 3. It is a Sign, not a CAPTIAL / SMALL
    if (LigatureName='') then
    begin
      memo1.Lines.add(CharCodeA);
      MapUpper := MapUpper + CharCodeA;
      MapLower := MapLower + CharCodeA;
    end else
    begin
      FoundPairs := 0;
      for m := 0 to pred(CharSetFile.Count) do
       if (m<>LineIndex) then
        if (pos('0x',CharSetFile[m])=1) then
        begin
         setLigatureName(m, _LigatureName, _LigatureUpper);
         if (_LigatureName=LigatureName) then
          if (_LigatureUpper<>LigatureUpper) then
          begin
           // 4. we have a match!
           setCode(m, CharCodeB);
           memo1.Lines.add(LigatureName+';'+CharCodeA+'<->'+CharCodeB);
           if _LigatureUpper then
           begin
            // A is lower, B is upper
            MapUpper := MapUpper + '{'+CharCodeA+'->}' + CharCodeB;
            MapLower := MapLower + CharCodeA;
           end else
           begin
             // A is upper, B is lower
             MapUpper := MapUpper + CharCodeA;
             MapLower := MapLower + '{'+CharCodeA+'->}' + CharCodeB;
           end;
           inc(FoundPairs);
          end;
        end;
      case FoundPairs of
       0:begin
       memo1.Lines.add(LigatureName);
       MapUpper := MapUpper + CharCodeA;
       MapLower := MapLower + CharCodeA;
       end;
       1:;

      else
       memo1.Lines.add('ERROR');
      end;



    end;

    if n<255 then
    begin
     MapUpper := MapUpper + ', ';
     MapLower := MapLower + ', ';
    end;

    if n MOD 16=1 then
    begin
     MapUpper := MapUpper + #13#10 + '  ';
     MapLower := MapLower + #13#10 + '  ';
    end;


  end;
  MapUpper := MapUpper + ');';
  MapLower := MapLower + ');';

  memo1.lines.add(MapUpper);
  memo1.lines.add(MapLower);


end;

end.

