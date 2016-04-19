{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2016  Andreas Filsinger
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
unit AuftragBildzuordnung;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids,
  Buttons, Datenbank,
  IB_Grid, IB_Components, IB_Access,
  anfix32;

type
  TFormAuftragBildzuordnung = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Image2: TImage;
    SpeedButton2: TSpeedButton;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    IB_Query1: TIB_Query;
    IB_DataSource1: TIB_DataSource;
    IB_Grid1: TIB_Grid;
    Button1: TButton;
    Label2: TLabel;
    Edit2: TEdit;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    SpeedButton3: TSpeedButton;
    Button2: TButton;
    ComboBox2: TComboBox;
    Edit3: TEdit;
    CheckBox2: TCheckBox;
    Button3: TButton;
    Button4: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Edit4: TEdit;
    Label3: TLabel;
    CheckBox5: TCheckBox;
    SpeedButton4: TSpeedButton;
    procedure Image2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
    procedure CheckBox1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private

    { Private-Deklarationen }
    BAUSTELLE_R: integer;
    MONTEUR_JONDA_R: integer; // wer hat ins JonDa eingegeben
    MONTEUR_FOTO_R: integer; // wer hat Fotografiert
    FOTOMOMENT: TAnfixDate;
    Path: string;

    // Bilder
    sImages: TStringList;
    sParameter: TStringList;
    ImageIndex: integer;
    FotoOffset: TDateTime;

    procedure refresh_FOTO;
    procedure refresh_JONDA;
    procedure refresh_MonteurCombos;

    // Interner Event
    procedure onLoadPic;
    procedure nextFoto;

  public
    { Public-Deklarationen }
    procedure setContext(pBAUSTELLE_R: integer);

  end;

var
  FormAuftragBildzuordnung: TFormAuftragBildzuordnung;

implementation

uses
  CaretakerClient, Baustelle,
  globals, math, wanfix32,
  dbOrgaMon, Funktionen_Auftrag, CCR.Exif,
  Foto;

{$R *.dfm}

procedure TFormAuftragBildzuordnung.Button1Click(Sender: TObject);
begin
  FileMove(Path + sImages[ImageIndex], Path + '..\' + Edit2.text + '.jpg');
  AppendStringsToFile(
    { } IB_Query1.FieldByName('RID').AsString + ';' +
    { } 'FA=' + Edit2.text + '.jpg',
    { } Path + 'Umbenannt.txt');
  if not(CheckBox3.Checked) then
    IB_Query1.next;
  nextFoto;
end;

procedure TFormAuftragBildzuordnung.Button2Click(Sender: TObject);
begin
  FileMove(Path + sImages[ImageIndex], Path + '..\' + Edit2.text + '-Neu.jpg');
  AppendStringsToFile(
    { } IB_Query1.FieldByName('RID').AsString + ';' +
    { } 'FN=' + Edit2.text + '-Neu.jpg',
    { } Path + 'Umbenannt.txt');
  IB_Query1.next;
  nextFoto;
end;

procedure TFormAuftragBildzuordnung.SpeedButton3Click(Sender: TObject);
begin
  CheckCreateDir(Path + 'Ablage');
  FileMove(Path + sImages[ImageIndex], Path + 'Ablage\' + sImages[ImageIndex]);
  nextFoto;
end;

procedure TFormAuftragBildzuordnung.SpeedButton4Click(Sender: TObject);
var
  dt: TDateTime;
begin
  dt := FotoAufnahmeMoment(Path + Label3.Caption);
  e_x_sql(
    { } 'update AUFTRAG set' +
    { } ' zaehler_wechsel=''' + long2date(dt) + ' ' + secondstostr(dt) + ''' ' +
    { } 'where ' +
    { } ' (RID=' + IB_Query1.FieldByName('RID').AsString + ')');
end;

procedure TFormAuftragBildzuordnung.Button3Click(Sender: TObject);
begin
  if (ImageIndex > 0) then
  begin
    dec(ImageIndex);
    onLoadPic;
  end
  else
    beep;
end;

procedure TFormAuftragBildzuordnung.Button4Click(Sender: TObject);
begin
  if (ImageIndex < pred(sImages.count)) then
  begin
    inc(ImageIndex);
    onLoadPic;
  end
  else
    beep;

end;

procedure TFormAuftragBildzuordnung.CheckBox1Click(Sender: TObject);
begin
  FOTOMOMENT := 0;
  refresh_FOTO;
  refresh_JONDA;
end;

procedure TFormAuftragBildzuordnung.ComboBox1Change(Sender: TObject);
var
  _MONTEUR_R: integer;
  M: integer;
begin
  _MONTEUR_R := MONTEUR_JONDA_R;
  repeat
    if ComboBox1.text = '*' then
    begin
      MONTEUR_JONDA_R := -1;
      break;
    end;
    M := e_r_MonteurRIDFromKuerzel(ComboBox1.text);
    if M >= cRID_FirstValid then
      MONTEUR_JONDA_R := M;
  until true;
  if (_MONTEUR_R <> MONTEUR_JONDA_R) then
    refresh_JONDA;
end;

procedure TFormAuftragBildzuordnung.ComboBox2Change(Sender: TObject);
var
  _MONTEUR_R: integer;
  M: integer;
begin
  FOTOMOMENT := 0;

  _MONTEUR_R := MONTEUR_FOTO_R;
  M := e_r_MonteurRIDFromKuerzel(nextp(ComboBox2.text, ' ', 0));
  if M >= cRID_FirstValid then
    MONTEUR_FOTO_R := M;
  if (_MONTEUR_R <> MONTEUR_FOTO_R) then
    refresh_FOTO;
end;

procedure TFormAuftragBildzuordnung.IB_Query1AfterScroll(IB_Dataset: TIB_Dataset);
begin
  Label2.Caption := IB_Query1.FieldByName('ZAEHLER_NUMMER').AsString;
  Edit2.text := IB_Query1.FieldByName('ZAEHLER_NUMMER').AsString;
end;

procedure TFormAuftragBildzuordnung.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'Medien');
end;

procedure TFormAuftragBildzuordnung.nextFoto;
begin
  if (ImageIndex < pred(sImages.count)) then
  begin
    inc(ImageIndex);
    onLoadPic;
  end
  else
    refresh_FOTO;
end;

procedure TFormAuftragBildzuordnung.onLoadPic;
var
  iEXIF: TExifData;
  AufnahmeMoment: TDateTime;
begin

  if (ImageIndex < sImages.count) and (sImages.count > 0) then
  begin
    Label3.Caption := sImages[ImageIndex];

    Image1.Picture.LoadFromFile(Path + sImages[ImageIndex]);

    // Ermittlung des EXIF Aufnahmemomentes
    iEXIF := TExifData.create;
    With iEXIF do
    begin
      if LoadFromGraphic(Path + sImages[ImageIndex]) then
        AufnahmeMoment := DateTimeOriginal.Value + FotoOffset
      else
        AufnahmeMoment := 0.0;
    end;
    iEXIF.free;

    Label1.Caption :=
    { } 'Datei=' + secondstostr(FileSeconds(Path + sImages[ImageIndex])) +
    { } ' / ' +
    { } 'Exif=' + SecondsToStr8(DateTime2seconds(AufnahmeMoment));

  end
  else
  begin
    Image1.Picture := nil;
    Label1.Caption := '';
    Label2.Caption := '';
    Edit2.text := '';
    beep;
  end;
end;

procedure TFormAuftragBildzuordnung.Panel1Click(Sender: TObject);
begin
  Label2.Font.Color := clSilver;
end;

procedure TFormAuftragBildzuordnung.Panel2Click(Sender: TObject);
begin
  Label2.Font.Color := clBlack;
end;

procedure TFormAuftragBildzuordnung.Panel3Click(Sender: TObject);
begin
  Label2.Font.Color := clWhite;
end;

procedure TFormAuftragBildzuordnung.refresh_JONDA;
begin
  BeginHourGlass;

  // Datenbank auffrischen
  with IB_Query1 do
  begin
    close;
    sql.clear;
    //
    sql.add('select');
    sql.add(' zaehler_nummer,');
    sql.add(' zaehler_wechsel,');
    if CheckBox2.Checked then
      sql.add(' regler_nr,');
    if CheckBox4.Checked then
      sql.add(' zaehler_nr_neu,');
    sql.add(' RID');
    sql.add('from');
    sql.add(' auftrag');
    sql.add('where');
    if (Edit4.text <> '') then
      sql.add(' (BAUSTELLE_R in (' + inttostr(BAUSTELLE_R) + ',' + Edit4.text + ')) and')
    else
      sql.add(' (baustelle_R=:BAUSTELLE) and');
    if CheckBox5.Checked then
    begin
      // sql.add(' ((zaehler_wechsel between :VON and :BIS) or');
      // sql.add('  (AUSFUEHREN between :VON and :BIS)) and');
      sql.add('  (AUSFUEHREN between :VON and :BIS) and');
    end
    else
    begin
      sql.add(' (zaehler_wechsel between :VON and :BIS) and');
    end;
    if (MONTEUR_JONDA_R >= cRID_FirstValid) then
      sql.add(' ((MONTEUR1_R=' + inttostr(MONTEUR_JONDA_R) + ') or ' + ' (MONTEUR2_R=' + inttostr(MONTEUR_JONDA_R) +
        ')) and');
    sql.add(' (status<>6)');
    if not(CheckBox5.Checked) then
    begin
      sql.add('order by');
      sql.add(' zaehler_wechsel');
    end;

    prepare;

    // Stichtag ermitteln!
    FOTOMOMENT := date2long(Edit1.text);

    // Query vorbereiten
    if (Edit4.text = '') then
      ParamByName('BAUSTELLE').AsInteger := BAUSTELLE_R;
    ParamByName('VON').AsDate := long2datetime(FOTOMOMENT);
    ParamByName('BIS').AsDate := long2datetime(DatePlus(FOTOMOMENT, 1));

    open;
  end;

  endHourGlass;
end;

procedure TFormAuftragBildzuordnung.refresh_FOTO;
var
  n: integer;
  sClientSorter: TStringList;
  newImages: TStringList;
begin
  BeginHourGlass;
  if assigned(sImages) then
  begin
    sImages.clear;
  end
  else
  begin
    sImages := TStringList.create;
    sParameter := TStringList.create;
  end;

  Path :=
  { } iBaustellenPath +
  { } e_r_BaustelleKuerzel(BAUSTELLE_R) +
  { } '\Fotos\' +
  { } e_r_MonteurGeraeteID(MONTEUR_FOTO_R) + '\';

  // Parameter setzen
  if FileExists(Path + 'Parameter.ini') then
    sParameter.LoadFromFile(Path + 'Parameter.ini')
  else
    sParameter.clear;
  FotoOffset := strtodoubledef(sParameter.values['KameraOffset'], 0.0) * (1.0 / 86400.0);

  // Verzeichnis durchsuchen nach Bildern
  dir(Path + '*.jpg', sImages, false);
  if (sImages.count > 0) then
  begin

    if DateNotOK(FOTOMOMENT) then
    begin

      // Suche das jüngste Bild
      if CheckBox1.Checked then
      begin
        FOTOMOMENT := MaxInt;
        for n := pred(sImages.count) downto 0 do
          FOTOMOMENT := min(FileDate(Path + sImages[n]), FOTOMOMENT);
      end
      else
      begin
        FOTOMOMENT := 0;
        for n := pred(sImages.count) downto 0 do
          FOTOMOMENT := max(FileDate(Path + sImages[n]), FOTOMOMENT);
      end;

      //
      Edit3.text := long2date(FOTOMOMENT);
      Edit1.text := long2date(FOTOMOMENT);
      refresh_JONDA;
    end;

    // *#*
    sClientSorter := TStringList.create;
    newImages := TStringList.create;
    for n := pred(sImages.count) downto 0 do
      if (FileDate(Path + sImages[n]) <> FOTOMOMENT) then
        sImages.delete(n);
    for n := 0 to pred(sImages.count) do
      sClientSorter.addObject(inttostrN(FileSeconds(Path + sImages[n]), 8), pointer(n));
    sClientSorter.sort;
    for n := 0 to pred(sClientSorter.count) do
      newImages.add(sImages[integer(sClientSorter.objects[n])]);

    sClientSorter.free;
    sImages.clear;
    for n := 0 to pred(newImages.count) do
      sImages.add(newImages[n]);
    newImages.free;
  end;

  // minimaler Tag raussuchen
  ImageIndex := 0;

  onLoadPic;
  endHourGlass;
end;

procedure TFormAuftragBildzuordnung.refresh_MonteurCombos;
var
  sMonteure: TStringList;
  n: integer;
  MONTEUR_R: integer;
begin

  // Monteurauswahl "JonDa"
  ComboBox1.items.assign(e_r_BaustelleMonteure(BAUSTELLE_R));
  ComboBox1.items.insert(0, '*');

  // Monteurauswahl "Foto"
  sMonteure := TStringList.create;
  dir(
    { } iBaustellenPath +
    { } e_r_BaustelleKuerzel(BAUSTELLE_R) +
    { } '\Fotos\' +
    { } '*.', sMonteure);
  for n := pred(sMonteure.count) downto 0 do
    if (length(sMonteure[n]) <> 3) or (strtointdef(sMonteure[n], 0) <= 0) then
      sMonteure.delete(n);
  for n := 0 to pred(sMonteure.count) do
  begin
    MONTEUR_R := e_r_MonteurRIDfromGeraeteID(sMonteure[n]);
    sMonteure[n] :=
    { } e_r_MonteurKuerzel(MONTEUR_R) + ' ' +
    { } sMonteure[n];
  end;
  ComboBox2.items.assign(sMonteure);
  sMonteure.free;

end;

procedure TFormAuftragBildzuordnung.setContext(pBAUSTELLE_R: integer);
begin
  BAUSTELLE_R := pBAUSTELLE_R;
  FOTOMOMENT := 0;
  refresh_FOTO;
  refresh_MonteurCombos;
  show;
end;

procedure TFormAuftragBildzuordnung.SpeedButton1Click(Sender: TObject);
begin
  refresh_JONDA;
  refresh_MonteurCombos;
end;

procedure TFormAuftragBildzuordnung.SpeedButton2Click(Sender: TObject);
begin
  FOTOMOMENT := 0;
  refresh_FOTO;
end;

end.
