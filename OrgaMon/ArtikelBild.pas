{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2011  Andreas Filsinger
  |
  |    This program is free software: you can redistribute it and/or modify
  |    it under the terms of the GNU General Public License as published by
  |    the Free Software Foundation, either version 3 of the License, or
  |    (at your option) any later version.
  |
  |    This program is distributed in the hope that it will be useful,
  |    but WITHOUT ANY WARRANTY; without even the implied warranty of
  |    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  |    GNU General Public License for more details.
  |
  |    You should have received a copy of the GNU General Public License
  |    along with this program.  If not, see <http://www.gnu.org/licenses/>.
  |
  |    http://orgamon.org/
  |
}
unit ArtikelBild;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtDlgs, ComCtrls;

type
  TFormArtikelBild = class(TForm)
    Edit1: TEdit;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    OpenTextFileDialog1: TOpenTextFileDialog;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    ProgressBar1: TProgressBar;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure Log(s: string);
  public
    { Public-Deklarationen }
    function cTPicUploadPath: string;
  end;

var
  FormArtikelBild: TFormArtikelBild;

implementation

uses
  anfix32, IniFiles, IBExportTable,
   globals,
   Funktionen_Basis,
   Funktionen_Beleg;

{$R *.dfm}

procedure TFormArtikelBild.Button1Click(Sender: TObject);
type
  eT_WorkMode = (WorkMode_Unknown, WorkMode_JPG, WorkMode_MP3, WorkMode_PDF);
var
  sIni: TIniFile;
  sBilder: TStringList;
  n, m: integer;
  ARTIKEL_R: integer;
  NUMERO: string;
  BILD_R: integer;
  FNameSource: string;
  FNameDest: string;
  WorkMode: eT_WorkMode;

  // MP3 - Sachen
  LocalMusikFName: TStringList;
  MusikPostfix: string;

  procedure DoCopy;
  begin
    if (FSize(FNameSource) <> FSize(cTPicUploadPath + NUMERO +
      cImageExtension)) then
    begin
      Log('kopiere "' + cTPicUploadPath + NUMERO + cImageExtension + '" ...');
      FileCopy(FNameSource, cTPicUploadPath + NUMERO + cImageExtension);
    end;
  end;

begin
  BeginHourGlass;
  Memo1.Lines.Clear;
  CheckCreateDir(cTPicUploadPath);

  LocalMusikFName := TStringList.create;
  sBilder := TStringList.create;
  sIni := TIniFile.create(Edit1.Text + 'Sync.ini');
  MusikPostfix := StrFilter(iShopMP3, '*?', true);

  with sIni do
  begin
    ReadSections(sBilder);
    ProgressBar1.max := sBilder.count;
    for n := 0 to pred(sBilder.count) do
    begin

      // Raus?
      if CheckBox2.checked then
        break;

      ProgressBar1.Position := n;
      WorkMode := WorkMode_Unknown;

      // Suche nach verwertbaren Bildern! Also
      repeat

        if (pos(cImageExtension, sBilder[n]) > 0) then
        begin
          ARTIKEL_R := strtointdef(nextp(sBilder[n], cImageExtension, 0),
            cRID_Null);
          WorkMode := WorkMode_JPG;
          break;
        end;

        if (pos('.gif', sBilder[n]) > 0) then
        begin
          ARTIKEL_R := strtointdef(nextp(sBilder[n], '.gif', 0), cRID_Null);
          WorkMode := WorkMode_JPG;
          break;
        end;

        if (pos('.mp3', sBilder[n]) > 0) then
        begin
          ARTIKEL_R := strtointdef(nextp(sBilder[n], '.mp3', 0), cRID_Null);
          WorkMode := WorkMode_MP3;
          break;
        end;

        if (pos(cPDFExtension, sBilder[n]) > 0) then
        begin
          ARTIKEL_R := strtointdef(nextp(sBilder[n],cPDFExtension, 0), cRID_Null);
          WorkMode := WorkMode_PDF;
          break;
        end;

        ARTIKEL_R := cRID_unset;
      until true;

      // Kein Eintrag für uns
      if (ARTIKEL_R < cRID_FirstValid) or (WorkMode = WorkMode_Unknown) then
        continue;

      // Artikel auf Existenz prüfen!
      if (e_r_sql(
        { } 'select count(RID) from ARTIKEL where RID=' + inttostr(ARTIKEL_R))
        <> 1) then
      begin
        Log('ERROR: (RID=' + inttostr(ARTIKEL_R) +
          ') diesen Artikel gibt es nicht!');
        continue;
      end;

      NUMERO := e_r_sqls(
        { } 'select NUMERO from ARTIKEL where RID=' + inttostr(ARTIKEL_R));
      if (NUMERO = '') then
      begin
        Log('WARNUNG: (RID=' + inttostr(ARTIKEL_R) +
          ') keine NUMERO eingetragen!');
        continue;
      end;

      FNameSource := ReadString(sBilder[n], 'FILE', '');
      if (FNameSource = '') then
        continue;

      // wenn .gif, dann .jpg
      ersetze('.gif', cImageExtension, FNameSource);

      if not(FileExists(FNameSource)) then
      begin
        Log('ERROR: Datei "' + FNameSource + '" fehlt!');
        continue;
      end;

      if (FSize(FNameSource) = 0) then
      begin
        Log('ERROR: Datei "' + FNameSource + '" ist leer!');
        continue;
      end;

      case WorkMode of
        WorkMode_PDF:begin
          if FileExists(iPDFPathPublicApp + NUMERO + cPDFExtension) then
          begin
                Log('INFO: Miniscore "' + NUMERO + cPDFExtension + '" vorhanden!');
          end else
          begin
              Log('kopiere "' + NUMERO + cPDFExtension + '" ...');
              FileCopy(
                { } FNameSource,
                { } iPDFPathPublicApp + NUMERO + cPDFExtension);
          end;
        end;
        WorkMode_MP3:
          begin

            // prüfe, ob schon was vorhanden ist
            dir(iMusicPath + NUMERO + iShopMP3, LocalMusikFName, false);
            if (LocalMusikFName.count > 0) then
            begin
              for m := 0 to pred(LocalMusikFName.count) do
                Log('INFO: Musik "' + LocalMusikFName[m] + '" vorhanden!');
            end
            else
            begin
              Log('kopiere "' + NUMERO + MusikPostfix + '" ...');
              FileCopy(
                { } FNameSource,
                { } iMusicPath + NUMERO + MusikPostfix);
            end;

          end;
        WorkMode_JPG:
          begin

            if (pos(cImageExtension, FNameSource) = 0) then
            begin
              Log('ERROR: Datei "' + FNameSource +
                '" scheint kein Bild zu sein!');
              continue;
            end;

            BILD_R := e_r_ArtikelDokument(
              { } cAUSGABEART_NATIV,
              { } ARTIKEL_R, cMediumBild);
            if (BILD_R >= cRID_FirstValid) then
            begin
              // breits ein Bilder-RID eingetragen

              FNameDest := e_r_ArtikelBild
                (cAUSGABEART_NATIV, ARTIKEL_R);
              if (FNameDest = '') then
              begin
                // Problem: Das Bild ist nicht da!
                Log(
                  { } 'WARNUNG: Bild-Datei "' +
                  { } e_r_ArtikelBild(cAUSGABEART_NATIV,
                  ARTIKEL_R, false) +
                  { } '" vermisst!');
                DoCopy;
              end
              else
              begin
                repeat

                  if CheckBox1.checked then
                    if (FSize(FNameDest) <> FSize(FNameSource)) then
                    begin
                      Log('INFO: Bild "' + FNameDest + '" veraltet!');
                      DoCopy;
                      break;
                    end;

                  // Skip
                  Log('INFO: Bild "' + FNameDest + '" vorhanden!');

                until true;
              end;

            end
            else
            begin
              // bisher noch kein Bild
              // -> eines via TPicUpload eintragen
              DoCopy;

            end;
          end;
      end;

    end;
  end;

  //
  sBilder.Free;
  sIni.Free;
  LocalMusikFName.Free;
  ProgressBar1.Position := 0;
  Log('ENDE');
  EndHourGlass;
end;

procedure TFormArtikelBild.Button2Click(Sender: TObject);
begin
  with OpenTextFileDialog1 do
  begin
    InitialDir := Edit1.Text;
    if execute then
      Edit1.Text := ExtractFilePath(FileName);
  end;
end;

function TFormArtikelBild.cTPicUploadPath: string;
begin
  if Edit2.Text = '' then
    result := EigeneOrgaMonDateienPfad + 'TPicUpload' + '\'
  else
    result := Edit2.Text;
end;

procedure TFormArtikelBild.FormActivate(Sender: TObject);
begin
  if Edit1.Text = '' then
    Edit1.Text := iVerlagsdatenabgleich;
  if Edit2.Text = '' then
    Edit2.Text := iTPicUpload;
end;

procedure TFormArtikelBild.Log(s: string);
begin
  Memo1.Lines.Add(s);
  Application.ProcessMessages;
end;

end.
