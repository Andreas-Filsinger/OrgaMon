{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007  Andreas Filsinger
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
unit BaustelleFoto;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons, ExtCtrls;

type
  TFormBaustelleFoto = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Button3: TButton;
    Label3: TLabel;
    ListBox1: TListBox;
    SpeedButton4: TSpeedButton;
    SpeedButton1: TSpeedButton;
    ProgressBar1: TProgressBar;
    Button1: TButton;
    Button2: TButton;
    Label4: TLabel;
    SpeedButton6: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Image3: TImage;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
  private
    { Private-Deklarationen }
    iFotoQuelle: string;
    iFotoAblage: string;
    iGeraet: string;
    BAUSTELLE_R: integer;

    function isDriveReady: boolean;
    function destPath: string;

    procedure log(const s: string);
  public
    { Public-Deklarationen }
    procedure setContext(pBAUSTELLE_R: integer);
  end;

var
  FormBaustelleFoto: TFormBaustelleFoto;

implementation

uses
  globals, Datenbank,
  dbOrgaMon,
  Funktionen_Basis,
  Funktionen_Beleg,
  Funktionen_Auftrag,
  CareTakerClient, anfix32, Baustelle,
  REST,
  wanfix32;
{$R *.dfm}

const
  cIdentifikationFName = 'id.ini';
  cINI_GeraeteNo = 'GeraeteNo';

procedure TFormBaustelleFoto.Button1Click(Sender: TObject);
var
  Settings: TStringList;
  sDir: TStringList;
  sDirSub: TStringList;
  sPath: TStringList;
  n, m: integer;
  nErfolgreichUebertragen: integer;
  destFName: string;
begin
  sDir := TStringList.create;
  sDirSub := TStringList.create;
  Settings := TStringList.create;
  ListBox1.Items.clear;
  repeat
    // Voraussetzungen prüfen!
    if (iFotoQuelle = '') then
      log(cErrorText + ' Export-Parameter "FotoQuelle=" ist ohne Wert');

    // Prüfe Medium
    log('Prüfe Speichermedium "' + iFotoQuelle + '" ...');
    if not(isDriveReady) then
    begin
      log(cErrorText + ' Medium nicht vorhanden oder schreibgeschützt');
      break;
    end;

    // Lade Identifikation
    if FileExists(iFotoQuelle + cIdentifikationFName) then
    begin
      Settings.LoadFromFile(iFotoQuelle + cIdentifikationFName);
      iGeraet := Settings.values['GeraeteNo'];
    end
    else
    begin
      log(cErrorText +
          ' Medium hat keine Geräte-Nummer, bitte eingeben und <speichern>!');
      break;
    end;
    log('Identifikation ist "' + iGeraet + '" ...');

    // Kopiere Bilder 
    CheckCreateDir(destPath);
    nErfolgreichUebertragen := 0;
    sPath := dirs(iFotoQuelle);
    for n := 0 to pred(sPath.count) do
    begin
      dir(iFotoQuelle + sPath[n] + '\' + '*.jpg', sDirSub, false, true);
      for m := 0 to pred(sDirSub.count) do
        sDir.add(sPath[n] + '\' + sDirSub[m]);
    end;
    dir(iFotoQuelle + '*.jpg', sDir, false, false);

    if (sDir.count > 0) then
    begin
      BeginHourGlass;
      ProgressBar1.Position := 0;
      ProgressBar1.Max := sDir.count;
      for n := 0 to pred(sDir.count) do
      begin
        // neuer Dateiname ist ein durchnummerierter
        destFName := e_w_Medium + '.jpg';

        // Von der Speicherkarte kopieren
        if not(FileCopy(iFotoQuelle + sDir[n], destPath + destFName)) then
        begin
          log(cErrorText + iFotoQuelle + sDir[n] +
              ': Fehler beim Kopieren von der Speicherkarte');
          break;
        end;

        // Datensicherung anlegen!
        if not(FileCopy(destPath + destFName,
            iFotoAblage + iGeraet + '-' + destFName)) then
        begin
          log(cErrorText + iFotoQuelle + sDir[n] +
              ': Fehler beim Anlegen der Sicherungskopie');
          break;
        end;

        // Dateigrösse OK?
        if (FSize(iFotoQuelle + sDir[n]) = FSize(destPath + destFName)) then
        begin
          // Löschen auf der Karte
          FileDelete(iFotoQuelle + sDir[n]);
          if FileExists(iFotoQuelle + sDir[n]) then
          begin
            log(cErrorText + iFotoQuelle + sDir[n] +
                ' Fehler beim Löschen von der Speicherkarte');
            break;
          end
          else
          begin
            inc(nErfolgreichUebertragen);
          end;
        end
        else
        begin
          log(cErrorText + iFotoQuelle + sDir[n] + ' Fehler beim Kopieren');
          break;
        end;

        // "0"-Bytes Bilder wieder löschen!
        if (FSize(destPath + destFName) < 1024) then
        begin
          FileDelete(destPath + destFName);
          log(cWARNINGText + destPath + destFName +
              ' wird gelöscht da ohne Inhalt');
          dec(nErfolgreichUebertragen);
        end;

        ProgressBar1.Position := n;
        application.processmessages;
      end;
      ProgressBar1.Position := 0;
      EndHourGlass;
      log('Erfolgreiches Kopieren von ' + inttostr(nErfolgreichUebertragen)
          + ' Bild(ern)');
    end
    else
    begin
      log(cWARNINGText + ' Es sind keine Bilder gespeichert');
    end;

  until true;
  Settings.free;
  sDir.free;
end;

procedure TFormBaustelleFoto.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFormBaustelleFoto.Button3Click(Sender: TObject);
var
  Settings: TStringList;
  nGeraeteNummer: integer;
begin
  nGeraeteNummer := strtointdef(Edit1.Text, 0);
  repeat

    // Prüfung der Gerätenummer 
    if (nGeraeteNummer < 1) or (nGeraeteNummer > 999) or
      (length(Edit1.Text) <> 3) then
    begin
      log(cErrorText + ' Geräte-Nummer nur 3-stellig von 001..999');
      break;
    end;

    log('Speichere Geräte-Nummer ...');
    if not(isDriveReady) then
    begin
      log(cErrorText + ' Medium nicht vorhanden oder schreibgeschützt');
      break;
    end;

    Settings := TStringList.create;
    Settings.add(cINI_GeraeteNo + '=' + Edit1.Text);
    Settings.SaveToFile(iFotoQuelle + cIdentifikationFName);
    Settings.free;

  until true;
end;

function TFormBaustelleFoto.destPath: string;
begin
  result := iBaustellenPath + e_r_BaustelleKuerzel
    (BAUSTELLE_R) + '\Fotos\' + iGeraet + '\';
end;

procedure TFormBaustelleFoto.Image3Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Foto');
end;

function TFormBaustelleFoto.isDriveReady: boolean;
const
  cCheckFName = 'id.tmp';
var
  CheckPoints: integer;
begin
  CheckPoints := 0;
  try
    FileEmpty(iFotoQuelle + cCheckFName);
  except

  end;
  if FileExists(iFotoQuelle + cCheckFName) then
    inc(CheckPoints);
  FileDelete(iFotoQuelle + cCheckFName);
  if not(FileExists(iFotoQuelle + cCheckFName)) then
    inc(CheckPoints);

  result := (CheckPoints = 2);
end;

procedure TFormBaustelleFoto.log(const s: string);
begin
  ListBox1.Items.add(s);
  ListBox1.ItemIndex := pred(ListBox1.Items.count);
end;

procedure TFormBaustelleFoto.setContext(pBAUSTELLE_R: integer);
var
  Settings: TStringList;
begin
  BAUSTELLE_R := pBAUSTELLE_R;
  ListBox1.Items.clear;
  Edit1.Text := '###';
  show;

  log('Lade Einstellungen ...');

  // Einstellungen laden
  Settings := e_r_BaustelleEinstellungen(BAUSTELLE_R);

  // FotoQuelle=
  iFotoQuelle := Settings.values[cE_FotoQuelle];
  if (iFotoQuelle = '') then
    log(cErrorText + ' Export-Parameter "FotoQuelle=" ist ohne Wert');

  // FotoAblage=
  iFotoAblage := Settings.values[cE_FotoAblage];
  if (iFotoAblage = '') then
  begin
    iFotoAblage := EigeneOrgaMonDateienPfad + 'Fotos\';
    CheckCreateDir(EigeneOrgaMonDateienPfad);
  end;
  CheckCreateDir(iFotoAblage);
  CheckCreateDir(iFotoAblage + 'Zips\');

  // FotoAblage nicht überlaufen lassen, nur 40 Tage ...
  FileDelete(iFotoAblage + '*', 40);
  FileDelete(iFotoAblage + 'Zips\' + '*', 40);

end;

procedure TFormBaustelleFoto.SpeedButton1Click(Sender: TObject);
begin
  CheckCreateDir(destPath);
  openShell(destPath);
end;

procedure TFormBaustelleFoto.SpeedButton2Click(Sender: TObject);
begin
  openShell(iFotoAblage);
end;

procedure TFormBaustelleFoto.SpeedButton4Click(Sender: TObject);
begin
  openShell(iFotoQuelle);
end;

procedure TFormBaustelleFoto.SpeedButton6Click(Sender: TObject);
var
  BildAbgleich: TStringList;
begin
  BeginHourGlass;
  BildAbgleich := DataModuleREST.REST(
    'http://orgamon.de/JonDaServer/Statistik/Eingabe.' + Edit1.Text + '.txt');
  BildAbgleich.SaveToFile(DiagnosePath + Edit1.Text + '.txt');
  BildAbgleich.free;
  EndHourGlass;
  openShell(DiagnosePath + Edit1.Text + '.txt');
end;

end.
