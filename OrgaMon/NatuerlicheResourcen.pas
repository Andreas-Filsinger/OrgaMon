(*
      ___                  __  __
     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
    | |_| | | | (_| | (_| | |  | | (_) | | | |
     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
               |___/

    Copyright (C) 2007  Andreas Filsinger

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    http://orgamon.org/

*)
unit NatuerlicheResourcen;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  IB_Components, IB_Access, StdCtrls, ComCtrls;

type
  TFormNatuerlicheResourcen = class(TForm)
    Button1: TButton;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    IB_Query1: TIB_Query;
    Button2: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure Execute;
  end;

var
  FormNatuerlicheResourcen: TFormNatuerlicheResourcen;

implementation

uses
  anfix, globals, wanfix;

{$R *.dfm}

{ TFormNatuerlicheResourcen }

procedure TFormNatuerlicheResourcen.Execute;
const
  cFillValue = 50;
var
  DirListMP3: TStringList;
  DirListPDF: TStringList;
  Bericht: TStringList;
  n: integer;
  RecN: integer;
  StartTime: dword;

  function Make_A_Numero(s: string): string;
  var
    n: integer;
  begin
    s := nextp(s, '.', 0);
    result := '';
    for n := 1 to length(s) do
      if s[n] in ['0'..'9'] then
        result := result + s[n]
      else
        break;
    Bericht.add(result);
  end;

begin
  show;
  BeginHourGlass;
  StartTime := 0;
  DirListMP3 := TStringList.create;
  DirListPDF := TStringList.create;
  Bericht := TStringList.create;
  label1.Caption := 'Vorlauf ...';
  application.processmessages;
  dir(iMusicPath + '*.mp3', DirListMP3, false);
  dir(iPDFPathPublicApp + '*.pdf', DirListPDF, false);
  progressbar1.max := DirListMP3.count + DirListPDF.count;
  label1.Caption := 'Mengen auffüllen (' + inttostr(DirListMP3.count) + ' MP3s / ' + inttostr(DirListPDF.count) + ' PDFs) ...';
  RecN := 0;
  with IB_Query1 do
  begin
    Open;
    for n := pred(DirListMP3.count) downto 0 do
    begin
      IB_Query1.ParamByName('CROSSREF').AsInteger := strtointdef(Make_A_Numero(DirListMP3[n]), 0);
      if not (IB_Query1.Eof) then
      begin
        if FieldByName('MENGE_DEMO').AsInteger < cFillValue then
        begin
          edit;
          FieldByName('MENGE_DEMO').AsInteger := cFillValue;
          post;
        end;
      end else
      begin
        // Fehler-Bericht
        Bericht.add('ERROR.MP3: unter ' + DirListMP3[n] + ' kein Artikel gefunden!');
      end;
      inc(RecN);
      if frequently(StartTime, 444) or (n = 0) then
      begin
        progressbar1.Position := RecN;
        application.processmessages;
      end;
    end;
    for n := pred(DirListPDF.count) downto 0 do
    begin
      IB_Query1.ParamByName('CROSSREF').AsInteger := strtointdef(Make_A_Numero(DirListPDF[n]), 0);
      if not (IB_Query1.Eof) then
      begin
        if (FieldByName('MENGE_PROBE').AsInteger < cFillValue) then
        begin
          edit;
          FieldByName('MENGE_PROBE').AsInteger := cFillValue;
          post;
        end;
      end else
      begin
        // Fehler-Bericht
        Bericht.add('ERROR.PDF: unter ' + DirListPDF[n] + ' kein Artikel gefunden!');
      end;
      inc(RecN);
      if frequently(StartTime, 444) or (n = 0) then
      begin
        progressbar1.Position := RecN;
        application.processmessages;
      end;
    end;
    close;
  end;
  DirListMP3.free;
  DirListPDF.free;
  if (Bericht.Count>0) then
    Bericht.SaveToFile(DiagnosePath + 'DMO_PDF_Bericht.txt');
  progressbar1.Position := 0;
  close;
  EndHourGlass;
end;

procedure TFormNatuerlicheResourcen.Button1Click(Sender: TObject);
begin
  execute;
end;

procedure TFormNatuerlicheResourcen.Button2Click(Sender: TObject);
begin
  openShell(DiagnosePath + 'DMO_PDF_Bericht.txt');
end;

end.

