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
unit Resource.SiteDownload;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  StdCtrls, IdHeaderList, IdURI, IniFiles, Anfix, ExtDlgs, ComCtrls;

type
  TFormSiteDownload = class(TForm)
    Memo1: TMemo;
    Sync: TButton;
    IdHTTP1: TIdHTTP;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    OpenTextFileDialog1: TOpenTextFileDialog;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Label7: TLabel;
    ProgressBar1: TProgressBar;
    ListBox3: TListBox;
    Label6: TLabel;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Button3: TButton;
    ProgressBar2: TProgressBar;
    procedure SyncClick(Sender: TObject);
    procedure IdHTTP1HeadersAvailable(Sender: TObject; AHeaders: TIdHeaderList;
      var VContinue: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure Button3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private

    { Private-Deklarationen }
    tIni: TIniFile;
    _DateGet: TAnfixDate;
    _TimeOut_404: TAnfixDate;
    _TimeOut_200: TAnfixDate;
    DownLoadsToday: Int64;

    procedure ensureIni;

  public
    { Public-Deklarationen }
    procedure GetOne(RID, s, d: string);
    function DateTimeToStamp(d: TDateTime): string;
  end;

var
  FormSiteDownload: TFormSiteDownload;

implementation

uses
  WordIndex, GifImg, jpeg,
  Globals;

{$R *.dfm}

procedure TFormSiteDownload.SyncClick(Sender: TObject);
var
  r, f: integer;
  tFiles: TsTable;
  sExtensions: TStringList;
  sSources: TStringList;

  cNAME: integer;
  cRID: integer;
  sNAME: string;
  dNAME: string;
begin
  Sync.enabled := false;
  tFiles := TsTable.create;
  sExtensions := TStringList.create;
  sSources := TStringList.create;

  sExtensions.AddStrings(ListBox2.items);
  sSources.AddStrings(ListBox3.items);
  with tFiles do
  begin
    insertFromStrings(ListBox1.items);

    ProgressBar2.Max := tFiles.RowCount;

    cNAME := colOf('NAME', true);
    cRID := colOf('RID', true);

    for r := 1 to tFiles.RowCount do
    begin
      ProgressBar2.position := r;

      for f := 0 to pred(sExtensions.count) do
      begin
        sNAME := readCell(r, cNAME);
        if CheckBox3.checked then
          sNAME := StrFilter(sNAME, cZiffern);

        dNAME := StrFilter(readCell(r, cNAME), cInvalidFNameChars, true);

        GetOne(
          { "RID.mp3" } readCell(r, cRID) + sExtensions[f],
          { Source } sSources[f] + sNAME + sExtensions[f],
          { Destination } Edit2.Text + dNAME + sExtensions[f]);

        Label7.Caption := IntToStr(DownLoadsToday);
        Application.ProcessMessages;
        if CheckBox1.checked then
          break;
      end;
      if assigned(tIni) then
        tIni.UpdateFile;
      if CheckBox1.checked then
        break;
    end;
  end;

  ProgressBar2.position := 0;

  // Ini speichern!
  if assigned(tIni) then
    FreeAndNil(tIni);
  Memo1.Lines.Add('ENDE');

  // .gif nach .jpg Konverter
  Button3Click(Sender);

  //
  sExtensions.free;
  sSources.free;
  Sync.enabled := true;
end;

procedure TFormSiteDownload.Button1Click(Sender: TObject);
var
  sExtensions: TStringList;
  sSources: TStringList;
  i: integer;
begin

  ensureIni;

  with tIni do
  begin

    // Datei erweuterungen!
    sExtensions := split(ReadString('System', 'Extensions', ''));
    ListBox2.items.clear;
    ListBox2.items.AddStrings(sExtensions);

    // URL
    sSources := split(ReadString('System', 'URL', ''));
    ListBox3.items.clear;
    for i := sSources.count to pred(sExtensions.count) do
      sSources.Add(sSources[pred(sSources.count)]);
    ListBox3.items.AddStrings(sSources);
    sSources.free;
    sExtensions.free;

    // OLAP Tabelle laden
    if FileExists(Edit2.Text + 'OLAP.tmp0.csv') then
      ListBox1.items.LoadFromFile(Edit2.Text + 'OLAP.tmp0.csv')
    else
      ListBox1.items.clear;

    // Optionen setzen
    CheckBox2.checked := ReadString('System', 'Delete', '') = 'JA';
    CheckBox3.checked := ReadString('System', 'Filter', '') = 'JA';

  end;

end;

procedure TFormSiteDownload.Button2Click(Sender: TObject);
begin
  with OpenTextFileDialog1 do
  begin
    InitialDir := Edit2.Text;
    if execute then
      Edit2.Text := ExtractFilePath(FileName);
  end;
end;

procedure TFormSiteDownload.Button3Click(Sender: TObject);
var
  pGIF: TGifImage;
  pJPG: TJpegImage;
  sGifs: TStringList;
  n: integer;
  WorkPath: string;
  SourceFName, DestFName: string;
begin
  WorkPath := Edit2.Text;

  BeginHourGlass;
  sGifs := TStringList.create;
  pGIF := TGifImage.create;
  pJPG := TJpegImage.create;

  dir(WorkPath + '*.gif', sGifs, false);
  for n := 0 to pred(sGifs.count) do
  begin
    SourceFName := WorkPath + sGifs[n];
    DestFName := SourceFName;
    ersetze('.gif', cImageExtension, DestFName);
    if (FileAge(SourceFName) > FileAge(DestFName)) then
    begin
      pGIF.LoadFromFile(SourceFName);
      pJPG.Assign(pGIF.Images[0].BitMap);
      // pJPG.CompressionQuality := 95;
      pJPG.SaveToFile(DestFName);
      Memo1.Lines.Add('save ' + DestFName);
    end;

  end;
  Memo1.Lines.Add('ENDE');

  EndHourGlass;

end;

function TFormSiteDownload.DateTimeToStamp(d: TDateTime): string;
begin
  result :=
  { } long2dateLocalized(d) +
  { } ' ' +
  { } SecondsToStr(d);
end;

procedure TFormSiteDownload.ensureIni;
begin
  if not(assigned(tIni)) then
  begin
    tIni := TIniFile.create(Edit2.Text + 'Sync.ini');
    _DateGet := DateGet;
    _TimeOut_404 := DatePlus(_DateGet, -7); // Alle 2 Tage nochmals prüfen
    _TimeOut_200 := DatePlus(_DateGet, -30); // Alle 14 auf Änderungen prüfen
  end;

end;

procedure TFormSiteDownload.FormActivate(Sender: TObject);
begin
  if (Edit2.Text = '') then
    Edit2.Text := iVerlagsdatenabgleich;
end;

procedure TFormSiteDownload.GetOne(RID, s, d: string);
var
  _OldFSize: Int64;
  OutF: TFileStream;
  Last404: TAnfixDate;
  Last200: TAnfixDate;
  oldName: string;
  IsLocal: Boolean;
  HTTP_Exception: Boolean;
  ErrorMsg: string;
begin

  IsLocal := (pos('.', s) = 1);

  if (RID = '') or (s = '') or (d = '') then
    exit;

  //
  ensureIni;

  with tIni do
  begin

    // Neues Spiel bei neuem Namen
    oldName := ReadString(RID, 'NAME', '');
    if (oldName <> '') then
      if (oldName <> s) then
        EraseSection(RID);

    //
    WriteString(RID, 'NAME', s);

    //
    _OldFSize := FSize(d);

    if (_OldFSize = -1) then
    begin

      Last404 := Date2long(
        { } ReadString(RID, '404', long2Date(_TimeOut_404)));

      repeat

        if IsLocal then
          break;

        if Last404 > _TimeOut_404 then
        begin
          Memo1.Lines.Add('amnesty ' + s + ' ...');
          break;
        end;

        // Es darf heute nochmal ein Download versucht werden!
        HTTP_Exception := true;
        FileDelete(d + cTmpFileExtension);
        OutF := TFileStream.create(d + cTmpFileExtension, fmCreate);
        try
          with IdHTTP1 do
          begin
            Memo1.Lines.Add('GET ' + s + ' ...');
            REsponse.KeepAlive := true;
            get(TIdURI.URLEncode(s), OutF);
            if (FSize(d + cTmpFileExtension) <= 0) then
              ErrorMsg := 'Filesize<=0'
            else
              HTTP_Exception := false
          end;
        except
          on E: exception do
          begin
            ErrorMsg := E.Message;
            Memo1.Lines.Add('ERROR: ' + ErrorMsg);
          end;
        end;
        OutF.free;

        if
        { OK } (IdHTTP1.ResponseCode = 200) and
        { ohne sonstige Fehler } not(HTTP_Exception) then
        begin

          // make visible
          FileDelete(d);
          RenameFile(d + cTmpFileExtension, d);

          // polish
          FileSetDate(d, DateTimeToFileDate(IdHTTP1.REsponse.LastModified));

          // log
          inc(DownLoadsToday, FSize(d));
          WriteString(RID, 'FILE', d);
          WriteString(RID, '200', long2Date(_DateGet));
          WriteString(RID, 'Last Modified',
            DateTimeToStamp(IdHTTP1.REsponse.LastModified));

          break;
        end;

        // Fehler Codes
        DeleteFile(d + cTmpFileExtension);

        if (IdHTTP1.ResponseCode = 404) or HTTP_Exception then
        begin
          WriteString(RID, '404', long2Date(_DateGet));
          if HTTP_Exception then
            WriteString(RID, 'ERROR', ErrorMsg)
          else
            WriteString(RID, 'ERROR', '');
          break;
        end;

        WriteString(RID, 'ERROR', IntToStr(IdHTTP1.ResponseCode));

      until true;

    end
    else
    begin

      // File nachtragen ...
      if (ReadString(RID, 'FILE', '') = '') then
        WriteString(RID, 'FILE', d);

      // Die Datei existierte schon
      Last200 := Date2long(
        { } ReadString(RID, '200', long2Date(_TimeOut_200)));

      repeat

        if IsLocal then
          break;

        if Last200 > _TimeOut_200 then
        begin
          Memo1.Lines.Add('ignore ' + s + ' ...');
          break;
        end;

        try
          Memo1.Lines.Add('HEAD ' + s + ' ...');
          IdHTTP1.Head(TIdURI.URLEncode(s));
        except
          on E: exception do
          begin
            Memo1.Lines.Add('ERROR: ' + E.Message);
          end;
        end;
        inc(DownLoadsToday, Length(IdHTTP1.REsponse.ResponseText));

        if (IdHTTP1.ResponseCode = 200) then
        begin
          if (DateTimeToStamp(IdHTTP1.REsponse.LastModified) <> ReadString(RID,
            'Last Modified', '')) or
            (IdHTTP1.REsponse.ContentLength <> _OldFSize) then
          begin
            // Force Reload
            DeleteFile(d);
            GetOne(RID, s, d);
          end;
          break;
        end;

        if (IdHTTP1.ResponseCode = 404) then
        begin
          WriteString(RID, '404', long2Date(_DateGet));
          if CheckBox2.checked then

            DeleteFile(d);
        end;

      until true;

    end;
  end;
end;

procedure TFormSiteDownload.IdHTTP1HeadersAvailable(Sender: TObject;
  AHeaders: TIdHeaderList; var VContinue: Boolean);
begin
  //
  Memo1.Lines.AddStrings(AHeaders);
end;

procedure TFormSiteDownload.IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  ProgressBar1.position := AWorkCount;
end;

procedure TFormSiteDownload.IdHTTP1WorkBegin(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  //
  ProgressBar1.Max := AWorkCountMax;
end;

procedure TFormSiteDownload.IdHTTP1WorkEnd(ASender: TObject;
  AWorkMode: TWorkMode);
begin
  ProgressBar1.position := 0;
end;

end.
