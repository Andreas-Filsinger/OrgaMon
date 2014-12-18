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
unit AuftragExtern;

interface

uses
  Windows, Messages, SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, ComCtrls,
   globals, IdFTP;

const
  cTageVorlauf = 11;
  cAdditionalOutPut = 'Art-Kurz:';
  cSummeFName = 'summe.zip.html';

type
  TFormAuftragExtern = class(TForm)
    ListBox1: TListBox;
    ProgressBar1: TProgressBar;
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    IdFTP1: TIdFTP;

    procedure Log(s: string);
    function ftagevorlauf: integer;
  public
    { Public-Deklarationen }
    function DoJob: boolean;
  end;

var
  FormAuftragExtern: TFormAuftragExtern;

implementation

uses
  anfix32,

  FlexCel.Core, FlexCel.xlsAdapter,

  IB_Components, CareTakerClient,
  Funktionen_Auftrag, WordIndex,
  html, SolidFTP, InfoZIP, Datenbank, Baustelle;

{$R *.dfm}

{ TFormAuftragExtern }

function TFormAuftragExtern.DoJob: boolean;
var
  cBAUSTELLE: TIB_Cursor;
  BAUSTELLE_R: integer;
  BAUSTELLE: string;
  cAUFTRAEGE: TIB_Cursor;
  FirstData: boolean;
  xAUSGABE: TXLSFile;
  xRow: integer;
  MONTEUR_R: integer;
  _MONTEUR_R: integer;
  AktuellerMonteur: string;
  Settings: TStringList;
  ErrorCount: integer;
  FtpUpList: TStringList;
  FTP_UploadFName: string;
  n, k: integer;
  InfoFile: TStringList;
  AktValue: string;
  AktDatum: string;
  MonteurL: TStringList;
  cMonteur: TIB_Cursor;
  DirL: TStringList;
  FirstUpload: boolean;

  function XLSFName: string;
  begin
    result := cAuftragErgebnisPath + noblank(settings.values[cE_Praefix]) + AktuellerMonteur + '.xls';
  end;

  procedure EndDatenSatz;
  var
   ZipFName : string;
  begin
    // speichern oder leer falls keinen Termin!
    FileDelete(XLSFName);
    if (xRow > 1) then
    begin
      xAUSGABE.Save(XLSFName);
      try
        ZipFName := XLSFName + '.zip';
        ftpuplist.add(ZipFName);
        (*
        with zip do
        begin
          password := settings.values[cE_ZIPPASSWORD];
          PackLevel := 9;
          OverwriteMode := Always;
          fileslist.clear;
          fileslist.add(XLSFName);
          ZipName := XLSFName + '.zip';
          zip;
        end;
        *)

        {
        with ZipMaster1 do
        begin
          password := settings.values[cE_ZIPPASSWORD];
          if Password<>'' then
            AddOptions := [AddEncrypt]
          else
            AddOptions := [];
          FSpecArgs.clear;
          FSpecArgs.add(XLSFName);
          ZipFileName := XLSFName + '.zip';
          FileDelete(ZipFileName);
          add;
        end;
        }

        InfoZIP.zip(
         XLSFName,
         ZipFName,
         infozip_Password + '=' + settings.values[cE_ZIPPASSWORD]);

      except
        on e: exception do
        begin
          inc(ErrorCount);
          Log(cERRORText + ' ' +
            e_r_BaustelleKuerzel(BAUSTELLE_R) + ': ' +
            e.message);
        end;
      end;
    end;

    // reinitialize
    FirstData := true;
    xRow := 1;
  end;

  function FullZaehlerArt: string;
  var
    n: integer;
    OutStr: string;
    Infos: TStringList;
  begin
    Infos := TStringList.create;
    OutStr := '';
    cAUFTRAEGE.FieldByName('ZAEHLER_INFO').AssignTo(Infos);
    for n := pred(Infos.count) downto 0 do
    begin
      if (pos(cAdditionalOutPut, Infos[n]) = 1) then
      begin
        OutStr := Infos[n];
        ersetze(cAdditionalOutPut, '', OutStr);
        ersetze('_', '', OutStr);
        break;
      end;
    end;
    Infos.free;
    if (OutStr <> '') then
      result := cAUFTRAEGE.FieldByName('ART').AsString + '-' + OutStr
    else
      result := cAUFTRAEGE.FieldByName('ART').AsString;
  end;

  procedure SchreibeDatenSatz;
  begin
    with xAUSGABE, cAUFTRAEGE do
    begin
      if FirstData then
      begin
        NewFile(1);
        FirstData := false;
        setCellValue(xRow, 1,  'Art');
        setColWidth(1, 4000);
        setCellValue(xRow, 2, 'Zählernummer (M)');
        setColWidth(2, 7000);
        setCellValue(xRow, 3, 'Termin');
        setColWidth(3, 6000);
        setCellValue(xRow, 4,  'vor-/nachmittags');
        setColWidth(4, 6000);
        inc(xRow);
      end;
      setCellValue(xRow, 1,  FullZaehlerArt);
      setCellValue(xRow, 2,  FieldByName('ZAEHLER_NUMMER').AsString);
      setCellValue(xRow, 3,  FieldByName('AUSFUEHREN').AsDate);
      setCellValue(xRow, 4,  FieldByName('VORMITTAGS').AsString);
      inc(xRow);
    end;
  end;

begin
  result := false;
  BeginHourGlass;
  show;
  FtpUpList := TStringList.create;
  Settings := TStringList.create;
  InfoFile := TStringList.create;
  MonteurL := TStringList.create;
  DirL := TStringList.create;
  xAUSGABE := TXLSFIle.create(true);
  ErrorCount := 0;
  FirstUpload := true;
  cBAUSTELLE := DataModuleDatenbank.nCursor;
  try
    with cBAUSTELLE do
    begin

      //
      sql.add('select RID, EXPORT_EINSTELLUNGEN from BAUSTELLE where EXPORT_EXTERN=''Y''');
      ApiFirst;
      while not (eof) do
      begin

        // init
        BAUSTELLE_R := FieldByName('RID').AsInteger;
        BAUSTELLE := e_r_BaustelleKuerzel(BAUSTELLE_R);
        FieldByName('EXPORT_EINSTELLUNGEN').AssignTo(Settings);

        InfoFile.clear;
        FtpUpList.clear;
        MonteurL.clear;
        cAUFTRAEGE := DataModuleDatenbank.nCursor;

        with cAUFTRAEGE do
        begin
          sql.add('select RID, ART, MONTEUR1_R,');
          sql.add(' AUSFUEHREN, VORMITTAGS, ZAEHLER_NUMMER, ');
          sql.add(' ZAEHLER_INFO from AUFTRAG where');
          sql.add(' (BAUSTELLE_R=' + inttostr(BAUSTELLE_R) + ') AND');
          sql.add(' (AUSFUEHREN between ''' + long2date(DateGet) + ''' and ''' +
            long2date(DatePlus(DateGet, fTageVorlauf)) + ''') AND');
          sql.add(' (STATUS IN (' +
            inttostr(ord(ctsTerminiert)) + ',' +
            inttostr(ord(ctsAngeschrieben)) + ',' +
            inttostr(ord(ctsMonteurinformiert)) + ',' +
            inttostr(ord(ctsRestant)) +
            ')) ');
          sql.add('ORDER BY');
          sql.add(' MONTEUR1_R,');
          sql.add(' AUSFUEHREN,');
          sql.add(' VORMITTAGS DESCENDING,');
          sql.add(' BAUSTELLE_R,');
          sql.add(' STRASSE,');
          sql.add(' NUMMER');
          ApiFirst;
          FirstData := true;
          _MONTEUR_R := -1;
          xRow := 1;
          while not (eof) do
          begin

            //
            MONTEUR_R := FieldByName('MONTEUR1_R').AsInteger;
            if (MONTEUR_R <> _MONTEUR_R) then
            begin
              if (_MONTEUR_R <> -1) then
                EndDatenSatz;

              // Monteur - Info auslesen
              cMonteur := DataModuleDatenbank.nCursor;
              with cMonteur do
              begin
                sql.add('select PERSON.KUERZEL, PERSON.HANDY, ANSCHRIFT.NAME1 from PERSON');
                sql.add('join anschrift on person.priv_anschrift_r=anschrift.rid');
                sql.add('where PERSON.RID=' + inttostr(MONTEUR_R));
                ApiFirst;
                AktuellerMonteur := FieldByNAme('KUERZEL').AsString;
                MonteurL.add(AktuellerMonteur + '=' + FieldByName('NAME1').AsString + ' (' +
                  FieldByName('HANDY').AsString + ')');
              end;
              cMonteur.free;

              //
              listbox1.items.add(e_r_BaustelleKuerzel(BAUSTELLE_R) +
                '.' +
                AktuellerMonteur);
            end;

            //
            AktDatum := long2date(DateTime2long(FieldByName('AUSFUEHREN').AsDate));
            AktDatum := copy(AktDatum, 7, 4) + '.' +
              copy(AktDatum, 4, 2) + '.' +
              copy(AktDatum, 1, 2);

            AktValue := AktDatum + '-' +
              FullZaehlerArt + '-' +
              AktuellerMonteur;

            InfoFile.values[AktValue] := inttostr(strtointdef(InfoFile.values[AktValue], 0) + 1);

            AktValue := AktDatum + '-' +
              FullZaehlerArt;

            InfoFile.values[AktValue] := inttostr(strtointdef(InfoFile.values[AktValue], 0) + 1);

            // Daten in die aktuelle Datei rausschreiben
            SchreibeDatenSatz;
            _MONTEUR_R := MONTEUR_R;

            // nächster Datensatz
            ApiNext;
          end;
        end;
        cAUFTRAEGE.free;
        EndDatenSatz;

        //
        InfoFile.sort;
        for n := 0 to pred(InfoFile.count) do
          InfoFile[n] := InfoFile[n] + '<br>';

        //
        MonteurL.sort;
        removeduplicates(MonteurL);
        for n := 0 to pred(MonteurL.count) do
          MonteurL[n] := MonteurL[n] + '<br>';

        InfoFile.insert(0, '<html>');
        InfoFile.insert(1, '<HEAD>');
        InfoFile.insert(2, '<Title>Überblick ' + e_r_BaustelleKuerzel(BAUSTELLE_R) + '</title>');
        InfoFile.insert(3, '<META HTTP-EQUIV="Pragma" content="no-cache">');
        InfoFile.insert(4, '<META HTTP-EQUIV="Cache-Control" content="no-cache, must-revalidate">');
        InfoFile.insert(5, '<META HTTP-EQUIV="Expires" content="0">');
        InfoFile.insert(6, '</HEAD>');
        InfoFile.insert(7, '<body bgcolor="#ffffff" text="#000000" link="#cc0000" vlink="#999999" alink="#ffcc00">');
        InfoFile.insert(8, '<font face="Verdana" size=2>');
        InfoFile.insert(9, '<u><b>' +
          e_r_BaustelleKuerzel(BAUSTELLE_R) +
          '</b>: Stand vom ' +
          long2datetext(DateGet) + ', ' +
          uhr +
          '</u><br>'
          );
        InfoFile.insert(10, '<br>');

        // Monteur Übersicht oben hin
        for n := 0 to pred(MonteurL.count) do
          InfoFile.insert(11 + n, MonteurL[n]);
        InfoFile.insert(11 + MonteurL.count, '<br>');

        InfoFile.add('<br>');
        InfoFile.add('<font face="Verdana" size=-2>' +
          Ansi2html(cOrgaMonCopyright) +
          '<br>');
        InfoFile.add('</body></html>');

        InfoFile.SaveTofile(cAuftragErgebnisPath + noblank(settings.values[cE_Praefix]) + cSummeFName);
        ftpuplist.add(cAuftragErgebnisPath + noblank(settings.values[cE_Praefix]) + cSummeFName);

        // Alles nun noch hochladen
        if (settings.values[cE_FTPHOST] <> '') then
        begin

          Log('FTP upload ' + BAUSTELLE + ' ...');
          try
            SolidInit(IdFTP1);
            with IdFTP1 do
            begin
              Host := settings.values[cE_FTPHOST];
              UserName := settings.values[cE_FTPUSER];
              password := settings.values[cE_FTPPASSWORD];
              passive := true;

              connect;

              // bei der ersten Baustelle
              if FirstUpload then
              begin
                List(DirL, '*', false);
                for n := 0 to pred(DirL.Count) do
                begin
                  if (pos('.zip', DirL[n]) > 0) then
                    Delete(DirL[n]);
                end;
                FirstUpload := false;
              end;

              for n := 0 to pred(ftpuplist.count) do
              begin
                FTP_UploadFName := ExtractFileName(ftpuplist[n]);

                // "secure put"
                if (Size(FTP_UploadFName + cTmpFileExtension) >= 0) then
                  Delete(FTP_UploadFName + cTmpFileExtension);
                Put(cAuftragErgebnisPath + FTP_UploadFName, FTP_UploadFName + cTmpFileExtension);
                if (Size(FTP_UploadFName) >= 0) then
                begin
                  Delete(FTP_UploadFName);
                end;

                Rename(FTP_UploadFName + cTmpFileExtension, FTP_UploadFName);

              end;

              Disconnect;

            end;
          except
            on e: exception do
            begin
              inc(ErrorCount);
              Log(cERRORText + ' ' +
                BAUSTELLE + ': ' +
                e.message);
            end;
          end;
        end;

        // nächste Baustelle
        ApiNext;
      end;

    end;
  except
    on e: exception do
    begin
      inc(ErrorCount);
      Log(cERRORText + ' ' +
        BAUSTELLE + ': ' +
        e.message);
    end;
  end;
  cBAUSTELLE.free;
  settings.free;
  ftpuplist.free;
  InfoFile.free;
  MonteurL.free;
  DirL.Free;
  xAusgabe.Free;
  EndHourGlass;
  if (ErrorCount = 0) then
    close
  else
    Log(cERRORText + ' Es gab Fehler!');
  result := (ErrorCount = 0);
end;

procedure TFormAuftragExtern.Log(s: string);
begin
  listbox1.items.add(s);
  if (pos(cERRORText, s) > 0) then
    CareTakerLog('AuftragExtern.' + s);
end;

procedure TFormAuftragExtern.Button1Click(Sender: TObject);
begin
  DoJob;
end;

procedure TFormAuftragExtern.FormCreate(Sender: TObject);
begin
  edit1.text := inttostr(cTageVorlauf);
  IdFTP1:= TIdFTP.Create(self);

end;

function TFormAuftragExtern.fTageVorlauf: integer;
begin
  result := strtointdef(edit1.text, cTageVorlauf);
end;

end.

