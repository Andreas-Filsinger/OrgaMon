unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Ende: TButton;
    ListBox1: TListBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure EndeClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

uses
 infozip;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
 DestPath : string;
 zipOptions: TStringList;
begin
 DestPath := ExtractFilePath(application.exename)+'test-0000';
 zipOptions:= TStringList.create;
 zipOptions.add('RootPath=I:\KundenUmgebung\AndreasFilsinger');
 zip(nil,DestPath+'\AndreasFilsinger.zip',zipOptions);
 zipOptions.free;
 listbox1.Items.AddStrings(zMessages);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
 DestPath : string;
begin
 DestPath := ExtractFilePath(application.exename)+'test-0000';

 listbox1.Items.add(format('unzip: %d',[unzip(DestPath+'\test-0000.zip',DestPath)]));

 listbox1.Items.AddStrings(zMessages);

end;

procedure TForm1.EndeClick(Sender: TObject);
begin
 close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 listbox1.items.add(zip_Version);
 listbox1.items.add(unzip_Version);

end;

end.
