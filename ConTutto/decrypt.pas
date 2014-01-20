unit decrypt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, rstream;

type
  TFormDecrypt = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    function CryptCopy(const Source, Dest, Key: string): boolean;
  end;

var
  FormDecrypt: TFormDecrypt;

implementation

{$R *.DFM}

function TFormDecrypt.CryptCopy(const Source, Dest, Key: string): boolean;
var
  SourceS: TEncryptedFileStream;
  DestS: TFileStream;
begin
  result := false;
  if FileExists(Source) then
  begin
    Label3.caption := Source;
    Label4.caption := Dest;

    show;
    application.processmessages;

  // open Source
    SourceS := TEncryptedFileStream.create(Source, fmOpenRead);
    SourceS.key := Key;

  // create destination
    if FileExists(Dest) then
      DeleteFile(Dest);
    DestS := TFileStream.create(Dest, fmCreate);

  // copy it!
    DestS.CopyFrom(SourceS, 0);
    DestS.free;
    SourceS.free;

    sleep(1000);
    close;
  end else
  begin
    ShowMessage('Datei ' + Source + ' nicht gefunden!');
  end;
end;

procedure TFormDecrypt.FormCreate(Sender: TObject);
begin
  top := (screen.height div 2) - (height div 2);
  left := (screen.width div 2) - (width div 2);
end;

end.
