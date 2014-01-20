unit TPUIni;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles;

const
  cINIFileName: string = 'TPicUpload.ini';

type
  TIni = class(TForm)
    INIContent: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure INIContentChange(Sender: TObject);
  private
    { Private-Deklarationen }
    WorkingDir: string;

    procedure Connect;
    procedure SaveChanges;
  public
    { Public-Deklarationen }
    INIFile: TMemIniFile;
    Changed: boolean;
  end;

var
  Ini: TIni;

implementation

{$R *.dfm}

uses
{$IFNDEF STANDALONE}
  globals,
{$ENDIF}
TPUMain;

procedure TIni.Button1Click(Sender: TObject);
begin
  if Changed then
  begin
    SaveChanges;
    Connect;
    FormTPMain.ReadIniValues;
  end;
  Hide;
end;

procedure TIni.Connect;
begin
{$IFDEF STANDALONE}
  WorkingDir := ExtractFilePath(Application.ExeName);
{$ELSE}
  WorkingDir := AnwenderPath;
{$ENDIF}
  INIContent.Clear;
  // ShowMessage(WorkingDir);
  INIFile := TMemIniFile.Create(WorkingDir + cINIFileName);
  INIFile.CaseSensitive := false;
  INIFile.GetStrings(INIContent.Lines);
end;

procedure TIni.FormCreate(Sender: TObject);
begin
  Connect;
  FormTPMain.ReadIniValues;
end;

procedure TIni.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  INIFile.Free;
end;

procedure TIni.INIContentChange(Sender: TObject);
begin
  Changed := true;
end;

procedure TIni.SaveChanges;
var F: TextFile;
  i: integer;
begin
  AssignFile(F, WorkingDir + cINIFileName);
  Rewrite(F);
  for i := 0 to pred(INIContent.Lines.Count) do writeln(F, INIContent.Lines.Strings[i]);
  CloseFile(F);
end;

end.

