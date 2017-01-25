unit HPACK_Form1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,


  anfix32, HPACK;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  HPACK: THPACK;
begin
  HPACK:= THPACK.create;
  with HPACK do
  begin
   Wire := THPACK.HexStrToRawByteString(edit1.Text);
   try
    Decode;
   except
   end;
   memo1.lines.addStrings(HPACK);
  end;
  HPACK.free;

end;

end.

