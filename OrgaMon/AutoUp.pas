{
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2007 - 2021  Andreas Filsinger
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
unit AutoUp;
//
// CMS - Content Management System
//
// automatisierter Releaseprozess ins Web (->cargobay)
// Projektmanagement, Veröffentlichung von Entwicklungen / Dokumenten
//

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, Buttons,
  ExtCtrls, StdCtrls, ComCtrls,
  html, Anfix, txlib,
  SolidFTP;

const
  cPrjName = '* PROJEKT:';
  cShortName = '* SHORT NAME:';
  cSourceName = '* SOURCE DIR:';
  cDestName = '* DEST DIR:';
  cStripReloc = '* STRIP RELOC:';
  cUpdateName = '* UPDATE:';
  cKundeID = '* KUNDE:';
  cDeleteOlder = '* DELETE OLDER RELEASE: NO';
  cInstallAble = '* INSTALL FROM:'; // Zip-Archiv
  cSingleFile = '* SINGLE FILE:'; // bereits fertig vorbereite Ausgabe
  cInnoSetupScript = '* INNO SETUP SCRIPT:'; // modify and run script!
  cInnoSetUpOhnePunkt = '* INNO SETUP WITHOUT POINT: YES';
  cInnoSetUpUpdate = '* INNO SETUP UPDATE: YES';
  cCopy = '* COPY:'; // strict copy file
  cAdd = '* ADD:'; // Update changed, copy missing Files, not touch unchanged
  cDelete = '* DELETE:';
  cPostMove = '* POST MOVE:';
  cPostCopy = '* POST COPY:';
  cInfo = '* INFO:';
  cCharSet = '* CHARSET: DOS';
  cFullPath = '* FULL PATH:';
  cUnofficial = '* UNOFFICIAL: YES';
  cPUBLIC = '* PUBLIC: YES'; // * Info.html geht raus als "projekt Info"
  cSOURCEBALL = '* SOURCEBALL: YES'; // aktuelle Sourcen als ZIP sichern?
  cARCHIVE = '* ARCHIVE: YES'; // erzeugtes zip-Ergebnis ins Quellverzeichnis
  cVersion = '* VERSION:';
  // Quelle, aus der die Projekt-Version ermittelt wird,
  // keine weitere Bedeutung, es wird nur die Version an
  // gezeigt, ohne weitere Verarbeitung ...
  ceMail = '* EMAIL:'; // wer/welche Gruppe bekommt die Benachrichtigungs-Email
  cUpload = '* UPLOAD:'; // wohin soll das Projekt upgeloadet werden

  // __CONSTANT,i_revision.inc.php5 PHP - Versions-Datei wird geschrieben
  cPHPVersioning = '* PHP VERSIONING:';

  // revision.txt wird geschrieben
  cTXTVersioning = '* TXT VERSIONING: YES';

  // Text-Konstanten in der Rev-Datei
  cRevInfo = 'Rev ';
  cInfoTagBegin = '// INFO BEGIN';
  cInfoTagEnd = '// INFO END';
  cSQLBlockBegin = '.SQL INIT BEGIN';
  cSQLBlockEnd = '.SQL INIT END';
  cSQLLocalBegin = 'SQL BEGIN';
  cSQLLocalEnd = 'SQL END';

  cRevPending = 10; // [days]
  cRevTopPage = 8 * 7; // [days]

  // folgendes muss noch Parameter werden!
  cStripRelocExecPath = 'StripReloc\StripReloc.exe';
  cInnoSetUp6ExecPath = 'Inno Setup 6\ISCC.exe';
  cInnoSetUp5ExecPath = 'Inno Setup 5\ISCC.exe';
  cRohstoffePath = 'Rohstoffe\';
  cTemplatesArchiveFName = 'templates.zip';
  cCargoBay = 'CargoBay.OrgaMon.org';

  // Dateierweiterungen
  cFragmentExtension = '.Fragment.txt';
  cInfoExtension = '.Info.txt';
  cGeneratedExtension = '.Generated.txt';

type
  TFormAutoUp = class(TForm)
    ComboBox1: TComboBox;
    Button1: TButton;
    Label2: TLabel;
    Memo1: TMemo;
    Edit1: TEdit;
    Button2: TButton;
    CheckBoxFileWork: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Button3: TButton;
    Button4: TButton;
    CheckBoxNoDown: TCheckBox;
    Label11: TLabel;
    Image2: TImage;
    CheckBoxRemove: TCheckBox;
    CheckBoxGetToken: TCheckBox;
    SpeedButton8: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    Memo2: TMemo;
    CheckBoxNoUp: TCheckBox;
    RadioButton_SetupType_Full: TRadioButton;
    RadioButton_SetupType_Update: TRadioButton;
    RadioButton_SetupType_ReleaseCandidate: TRadioButton;
    RadioButton_SetupType_Console: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private-Deklarationen }
    IsInitialized: boolean;
    AllProjects: TStringList; // so wie im Verzeichnis
    RevInfo: TStringList;

    iProjektName: string; // ganzer Name
    AddRevLines: boolean;
    KundeID: string;
    iDeleteOlder: boolean;
    InstallFrom: string;
    DOSCharSet: boolean;

    iInnoSetupScript: TStringList;
    iShortName: string; // Kurzname (wie rev-datei)
    iSourcePath: string; // Vorrangiges Quellverzeichnis, Default = iAutoUpRevDir
    iDestPath: string; //
    iOrdner: string; // Ordner ohne Slash
    ieMail: string;
    iPostMove: TStringList;
    iPostCopy: TStringList;
    iUnofficial: boolean;
    iSingleFile: string;
    iInnoSetupOhnePunkt: boolean;
    iInnoSetupUpdate: boolean;
    // Gibt es neben dem vollen "Setup.exe" auf ein "Setup-Update.exe"?
    iPublic: boolean; // Soll im Web was stehen?
    iUpload: string;
    iUploads: TStringList; // host,user,pwd,file,? broken?
    iSourceBall: boolean; // Aus <<ProjektName>>.dpr alle Quelltexte als ZIP,
    // Versionsnummer aus der gloals.pas
    iArchive: boolean;
    iPHP_Constant: string; //
    iPHP_OutFile: string; //
    iTXT_Versioning: boolean; //

    // während der Runtime gebildet
    rRevSourceFile: TStringList;
    rFullSetUpMask: string;
    rIconFound: boolean;
    rInfoBegin: integer;
    rInfoEnd: integer;
    rOldRevDatum: TAnfixDate;
    rActRevDatum: TAnfixDate;
    rSourceIconFname: string;
    rDestIconFname: string;
    rZipFName: TStringList; // Name der resultierenden Dateien
    rUpdateFiles: TStringList; // Welche Datein kommen noch ins Zip
    rStripRelocFiles: TStringList;
    rLatestRevOhnePunkt: string;
    rLatestRevMitPunkt: string;
    rRev: TStringList; // external Rev-Content
    rSQL: TStringList;
    rAutoUps: TStringList;
    rAutoDels: TStringList;
    rCheckCreateDirs : TStringList;

    // ftpsachen
    aFTP: TSolidFTP;

    FullPathPrepared: boolean;
    FullPathPreparedValue: string;

    eMailStr: string;
    InfoStr: string;

    RevVonDatum: TAnfixDate;
    RevBisDatum: TAnfixDate;

    NewestRevFName: string;

    function ZipFNameExe: string;
    function ZipFNameExe2: string;
    procedure CreateProjectInfo(prj: string);

  public

    { Public-Deklarationen }
    procedure Log(s: string);
    function InnoProceed(SourceFName, DestFName: string): string;
    function outFileName(FName: string): string;
    function CountPreFix(s: string): integer;
    function CutPreFix(s: string): string;
    procedure InRente(ToDeleteMask: string);
    function iAutoUpFTP_host: string;
    function iAutoUpFTP_user: string;
    function iAutoUpFTP_pwd: string;
    function iAutoUpFTP_root: string;
    function doReplace(s:string):string;
    function iSingleFile_Source: string;
    function iSingleFile_Dest: string;

    { einzelne Aufgaben }
    function DownLoadTemplates: boolean;
    function CompileRevisionSource: boolean;
    function CreateRevList: boolean;
    function RemoveOldRevisions: boolean;
    function CreateSetupFiles: boolean;
    function PostCopyMove: boolean;
    function CreateHtml: boolean;
    function CreateTemplates: boolean;
    function CreateSourceBall: boolean;
    function FTPup: boolean;
    function AutoUpsUp: boolean;
    function AddFile(s,d:String):boolean;
    function AddDir(s,d:String):boolean;
    function CheckCreateDir_Cached(d:String):boolean;

  end;

var
  FormAutoUp: TFormAutoUp;

implementation

uses
  c7zip,
  CareTakerClient,
  globals,
  math,
  systemd,
  wanfix;

{$R *.DFM}

function cAutoUpPath: string;
begin
  result := MyProgramPath + 'AutoUp\';
end;

function cAutoUpContent: string;
begin
  result := cAutoUpPath + 'Content\';
end;

function cHistoricPath: string;
begin
  result := cAutoUpContent + 'Historische Revisionen\';
end;

function cTemplatesPath: string;
begin
  result := cAutoUpPath + 'Templates\';
end;

procedure TFormAutoUp.Button1Click(Sender: TObject);
begin
  BeginHourGlass;
  repeat
    // Alle Aktionen durchführen!
    if not(DownLoadTemplates) then
      break;
    if not(CreateRevList) then
      break;
    if CheckBoxGetToken.checked then
    begin
      ComboBox1.items.clear;
      ComboBox1.items.addstrings(AllProjects);
      break;
    end;
    if not(CompileRevisionSource) then
      break;
    if not(RemoveOldRevisions) then
      break;
    if not(CreateSetupFiles) then
      break;
    if not(CreateHtml) then
      break;
    if not(CreateTemplates) then
      break;
    if not(PostCopyMove) then
      break;
    if not(FTPup) then
      break;
    if not(CheckBoxNoUp.checked) then
      if not(AutoUpsUp) then
        break;
    // cool
  until yet;
  EndHourGlass;

  // Desktop Clean Up
  Label11.caption := '###';
  Edit1.Text := '';
  Edit1.setfocus;

  // Ergebnis öffnen
  if CheckBox4.checked then
    openShell(cAutoUpContent + iProjektName + '_Info.html');
  if CheckBoxGetToken.checked then
    openShell(cTemplatesPath);

end;

function TFormAutoUp.AutoUpsUp: boolean;
var
  n, m: integer;
  LocalFName: string;
  BulkUpload: TStringList;
begin
  result := true;

  // löschen nicht was eben gerade hochgeladen wurde!
  for m := pred(rAutoDels.count) downto 0 do
  begin
    LocalFName := ExtractFileName(rAutoDels[m]);
    for n := 0 to pred(rAutoUps.count) do
      if (ExtractFileName(rAutoUps[n]) = LocalFName) then
        rAutoDels.delete(m);
  end;

  // Grösse berechnen, aufbereiten
  for n := pred(rAutoUps.count) downto 0 do
    if not(FileExists(rAutoUps[n])) then
      rAutoUps.delete(n);

  // ftp initialisieren
  if (rAutoUps.count > 0) then
  begin
    with aFTP do
    begin

      Host := iAutoUpFTP_host;
      UserName := iAutoUpFTP_user;
      Password := iAutoUpFTP_pwd;

      Login(iAutoUpFTP_root);

      BulkUpload := TStringList.Create;
      for n := 0 to pred(rAutoUps.count) do
        BulkUpload.Add(
         {} rAutoUps[n]+';'+
         {} cSolidFTP_DirCurrent+';'+
         {} ExtractFileName(rAutoUps[n]));
      Put(BulkUpload);
      BulkUpload.Free;

      // Löschungen
      for n := 0 to pred(rAutoDels.count) do
      begin
        LocalFName := ExtractFileName(rAutoDels[n]);
        if Size(cSolidFTP_DirCurrent,LocalFName) >= 0 then
          del(cSolidFTP_DirCurrent,LocalFName);
        Application.processmessages;
      end;
      Disconnect;
    end;
  end;

end;

procedure TFormAutoUp.Edit1Change(Sender: TObject);
var
  n: integer;
  ToFindStr: string;
begin
  ToFindStr := AnsiUpperCase(Edit1.Text);
  for n := 0 to pred(ComboBox1.items.count) do
    if pos(ToFindStr, AnsiUpperCase(ComboBox1.items[n])) = 1 then
    begin
      ComboBox1.Text := ComboBox1.items[n];
      break;
    end;
end;

procedure TFormAutoUp.FormActivate(Sender: TObject);
begin

  if not(IsInitialized) then
  begin

    aFTP := TSolidFTP.Create;
    //
    AllProjects := TStringList.create;
    RevInfo := TStringList.create;
    iPostMove := TStringList.create;
    iPostCopy := TStringList.create;
    iInnoSetupScript := TStringList.create;
    iUploads := TStringList.create;
    rAutoUps := TStringList.create;
    rAutoDels := TStringList.create;
    rRevSourceFile := TStringList.create;
    rSQL := TStringList.create;
    rZipFName := TStringList.create;
    rUpdateFiles := TStringList.create;
    rStripRelocFiles := TStringList.create;

    // prüfen, ob das Verzeichnis existiert
    CheckCreateDir_Cached(cAutoUpPath);
    CheckCreateDir_Cached(cAutoUpContent);
    CheckCreateDir_Cached(cHistoricPath);
    CheckCreateDir_Cached(cTemplatesPath);

    // Alle lokalen Projekte in die Listbox laden
    CreateRevList;
    ComboBox1.items.addstrings(AllProjects);
    ComboBox1.Text := NewestRevFName;
    Edit1.Text := NewestRevFName;

    //
    Label2.caption := inttostr(AllProjects.count) + ' Projekte@' + iAutoUpRevDir + ' -> ' + cAutoUpContent;

    IsInitialized := true;
  end;

  Edit1.setfocus;
end;

procedure TFormAutoUp.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Button1Click(Sender);
  end;
  if Key = #27 then
  begin
    Key := #0;
    close;
  end;
end;

procedure TFormAutoUp.Button2Click(Sender: TObject);
begin
  // eMail-Str generieren!
  eMailStr := 'mailto:' + ieMail;

  if pos('?', eMailStr) = 0 then
    eMailStr := eMailStr + '?'
  else
    eMailStr := eMailStr + '&';

  eMailStr := eMailStr + 'subject=' + Memo1.lines[3];

  if iUnofficial then
  begin
    eMailStr := eMailStr + '&body=unveröffentlicher Download-Link http://' + cCargoBay + '/' +
      ExtractFileName(rZipFName[0]) + '%0D%0A' + '%0D%0A' + 'wichtige Information dazu finden Sie in der Datei' +
      '%0D%0A' + '"' + iProjektName + '_Info.html", die sich auch im Paket befindet!'
  end
  else
  begin
    eMailStr := eMailStr + '&body=' +
      'Die neue Software-Release wurde im InterNet bereitgestellt. Was geändert wurde können Sie auf http://' +
      cCargoBay + '/' + iProjektName + 'Rev.html nachlesen. Das Paket enthält die Datei ' + iProjektName +
      '_Info.html mit noch mehr Information. ' +
      'Hat Ihre Software eine Update-Funktion, führen Sie diese bitte durch. ' + 'Ansonsten können Sie von http://' +
      cCargoBay + ' ab sofort die neueste Version herunterladen.' + '%0D%0A' + '%0D%0A' +
      '-------------------------------' + '%0D%0A' +
      'wollen Sie diese automatisch erzeugte Release-Mail nicht mehr erhalten, ' +
      'so antworten Sie mit dem Wort "unsubscribe" im Betreff.';
  end;

  openShell(eMailStr);
end;

function TFormAutoUp.ZipFNameExe: string;
begin
  result := rZipFName[0];
  ersetze(cZIPExtension, '.exe', result);
end;

function TFormAutoUp.ZipFNameExe2: string;
begin
  result := rZipFName[0];
  ersetze(cZIPExtension, '.exe', result);
  ersetze('.exe', '-Update.exe', result);
end;

procedure TFormAutoUp.CreateProjectInfo(prj: string);
const
  cUmlaute: string = 'ßäöüÄÖÜ';

var
  InfoText: TStringList;
  StartLine, EndLine: integer;
  n: integer;
  MainPage: THTMLTemplate;
  InfoPage: THTMLTemplate;
  unofficial: boolean;
  IsPublic: boolean;

  function HtmlUmlaute(s: string): string;
  var
    n, k: integer;
  begin
    for n := 1 to length(cUmlaute) do
    begin
      while true do
      begin
        k := pos(cUmlaute[n], s);
        if k = 0 then
          break;
        s := copy(s, 1, pred(k)) + Ansi2Html(cUmlaute[n]) + copy(s, succ(k), MaxInt);
      end;
    end;
    result := s;
  end;

begin
  MainPage := THTMLTemplate.create;
  MainPage.LoadFromFile(cTemplatesPath + 'index.html');
  InfoText := TStringList.create;
  LoadFromFileHugeLines(true, InfoText, iAutoUpRevDir + prj + cRevExtension);
  StartLine := InfoText.indexof('// INFO BEGIN');
  EndLine := InfoText.indexof('// INFO END');
  unofficial := (InfoText.indexof(cUnofficial) <> -1);
  IsPublic := (InfoText.indexof(cPUBLIC) <> -1);
  InfoPage := THTMLTemplate.create;

  if IsPublic then
  begin
    if FileExists(cAutoUpContent + prj + '_Info.html') then
      InfoPage.LoadFromFile(cAutoUpContent + prj + '_Info.html');
    InfoPage.SaveBlockToFile('Info', cTemplatesPath + prj + cInfoExtension);
  end;

  if (StartLine <> -1) and (EndLine <> -1) then
  begin
    for n := pred(InfoText.count) downto EndLine do
      InfoText.delete(n);
    for n := StartLine downto 0 do
      InfoText.delete(n);
  end
  else
  begin
    InfoText.clear;
    InfoText.add('Es stehen keine weiteren Informationen zur Verfügung.<br>');
    InfoText.add('An eine Veröffentlichung ist zwar gedacht, aber es wurden<br>');
    InfoText.add('noch keine Online-Dokumente verfasst!<br>');
    InfoText.add('Sie könnten jedoch der(die) erste sein, der(die) das Projekt<br>');
    InfoText.add('wieder zum Leben erweckt! Bitte schreiben Sie mir eine eMail.<br>');
  end;

  for n := 0 to pred(InfoText.count) do
    InfoText[n] := HtmlUmlaute(InfoText[n]);

  InfoText.insert(0, '<!-- BEGIN NOT FOUND -->');
  InfoText.insert(1, '<table width="100%" border=0 bgcolor="#FFFFFF" cellpadding=0 cellspacing=0>');
  InfoText.insert(2, '<tr><td width=50></td>');
  InfoText.insert(3, '<td><br>');
  InfoText.insert(4, '<b>' + prj + '</b><br>');
  InfoText.insert(5, fill('=', length(prj)));
  InfoText.insert(6, '<br><br>');

  InfoText.add('<br>');
  InfoText.add('Anfrage via <a href=ni.html>eMail</a>');
  InfoText.add('<br>');

  if FileExists(cTemplatesPath + prj + cFragmentExtension) then
  begin
    InfoText.add('<br>');
    InfoText.add('<TABLE BORDER=0 CELLPADDING=0 CELLSPACING=0 VALIGN=TOP WIDTH="100%">');
    LoadFromFileHugeLines(false, InfoText, cTemplatesPath + prj + cFragmentExtension);
    InfoText.add('</TABLE>');
    InfoText.add('<br>');
  end
  else
  begin
    if unofficial then
    begin
      InfoText.add('<br>');
      InfoText.add('Alle Rechte liegen beim Auftraggeber<br>');
      InfoText.add('<br>');
    end
    else
    begin
      InfoText.add('<br>');
      InfoText.add('Interesse <b>noch</b> zu gering!<br>');
      InfoText.add('Projekt noch nicht downloadbar - bitte eMail an mich!<br>');
      InfoText.add('<br>');
    end;
  end;

  InfoText.add('<br>');
  InfoText.add('</td><td width=50></td></tr></table>');
  InfoText.add('<!-- END NOT FOUND -->');

  with MainPage do
  begin
    ClearBlock('MAIN');
    ClearBlock('NOT FOUND');
    ClearBlock('REVSINGLELINE');
    WriteValue('Datum der Erzeugung', long2date(DateGet));
    LoadBlock('NOT FOUND', InfoText);

    //
    FileDelete(cAutoUpContent + prj + '.html');
    if not(iUnofficial) then
    begin
      if IsPublic then
        LoadBlockFromFile('Info', cTemplatesPath + prj + cInfoExtension);
      SaveToFileCompressed(cAutoUpContent + prj + '.html');
      if not(RadioButton_SetupType_ReleaseCandidate.Checked) and
         not(RadioButton_SetupType_Console.Checked) then
        rAutoUps.add(cAutoUpContent + prj + '.html');
    end;

  end;
  MainPage.free;
  InfoText.free;
  InfoPage.free;
end;

function TFormAutoUp.InnoProceed(SourceFName, DestFName: string): string;
var
  InnoScript: TStringList;
  n: integer;
  OneLine: string;
begin
  InnoScript := TStringList.create;
  InnoScript.LoadFromFile(SourceFName);
  iOrdner :=
   StrFilter(
    copy(iSourcePath,
     revpos('\', copy(iSourcePath, 1, pred(length(iSourcePath)))), MaxInt),
    '\', true);

  for n := 0 to pred(InnoScript.count) do
    InnoScript[n] := doReplace(InnoScript[n]);

  // Zieldateiname herauslesen!
  result := InnoScript.values['OutputDir'];
  if (pos(':', result) = 0) then
    result := ExpandFileName(iSourcePath + result);
  result := ValidatePathName(result) + '\' + InnoScript.values['OutputBaseFilename'] + '.exe';

  rAutoUps.add(result);

  InnoScript.SaveToFile(DestFName);
  InnoScript.free;
end;

function TFormAutoUp.outFileName(FName: string): string;
begin
  result := FName;
  if RadioButton_SetupType_Full.checked then
    ersetze('%out%', ExtractFileName(rZipFName[0]), result)
  else
    ersetze('%out%', ExtractFileName(ZipFNameExe2), result);
end;

procedure TFormAutoUp.Button3Click(Sender: TObject);
begin
  RunExternalApp('notepad.exe ' + iAutoUpRevDir + ComboBox1.Text, SW_SHOW);
end;

procedure TFormAutoUp.Button4Click(Sender: TObject);
begin
  // eMail-Str generieren!
  eMailStr := 'mailto:';

  if (pos('?', eMailStr) = 0) then
    eMailStr := eMailStr + '?'
  else
    eMailStr := eMailStr + '&';

  eMailStr := eMailStr + 'subject=' + Memo1.lines[3];

  if iUnofficial then
    eMailStr := eMailStr + '&body=unveröffentlicher Download-Link http://' + cCargoBay + '/' +
      ExtractFileName(rZipFName[0]) + '%0D%0A' + '%0D%0A' + 'wichtige Information dazu finden Sie in der Datei' +
      '%0D%0A' + '"' + iProjektName + '_Info.html", die sich auch im Paket befindet!'
  else
    eMailStr := eMailStr + '&body=ab sofort downloadbar von http://' + cCargoBay + '%0D%0A' + '%0D%0A' +
      'wichtige Information dazu finden Sie in der Datei' + '%0D%0A' + '"' + iProjektName +
      '_Info.html", die sich auch im Paket befindet!';

  openShell(eMailStr);

end;

function TFormAutoUp.CountPreFix(s: string): integer;
var
  n: integer;
begin
  result := 0;
  for n := 1 to length(s) do
    if (s[n] = '_') then
      inc(result)
    else
      break;
end;

function TFormAutoUp.CutPreFix(s: string): string;
begin
  result := s;
  while pos('_', result) = 1 do
    delete(result, 1, 1);
end;

procedure TFormAutoUp.InRente(ToDeleteMask: string);
var
  OldRevisionArchive: TStringList;
  n: integer;
begin
  OldRevisionArchive := TStringList.create;
  dir(ToDeleteMask, OldRevisionArchive, false);
  if OldRevisionArchive.count > 0 then
  begin
    for n := 0 to pred(OldRevisionArchive.count) do
    begin
      Log('InRente ' + OldRevisionArchive[n] + ' ...');

      FileMove(ExtractFilePath(ToDeleteMask) + OldRevisionArchive[n], cHistoricPath + OldRevisionArchive[n]);
      FileTouch(cHistoricPath + OldRevisionArchive[n]);
      rAutoDels.add(ExtractFilePath(ToDeleteMask) + OldRevisionArchive[n]);
    end;
  end;
  OldRevisionArchive.free;
end;

procedure TFormAutoUp.Log(s: string);
begin
  Memo2.lines.add(s);
end;

function TFormAutoUp.CompileRevisionSource: boolean;
var
  // Für das Info-Dokument
  RevAsHtml: TStringList;
  MachineState: integer;
  RefCount: integer;
  Inhaltsverzeichnis: TStringList;

  ThisFName: string;
  n, k, m: integer;
  ThisLine: string;
  InfoTextPos: integer;
  CopyCommand: string;
  CopySrc: string;
  CopyDest: string;
  SQLBegin: integer;
  DeleteCommand: string;
  ExternalRev: string;

  function CheckAndPos(FindStr: string; AllStr: string; var NextPos: integer; LineNo: integer): boolean;
  begin
    NextPos := pos(FindStr, AllStr);
    if (NextPos = 1) then
    begin
      // gefunden!!!
      result := true;
      NextPos := succ(NextPos + length(FindStr));
    end
    else
    begin
      result := false;
      NextPos := 0;
    end;
  end;

  function ExtractRevDatum: TAnfixDate;
  begin
    result := cIllegalDate;
    repeat
      k := pos('-', ThisLine);
      if (k > 0) then
      begin
        result := date2long(copy(ThisLine, succ(k), 8));
        break;
      end;

      k := pos('(', ThisLine);
      if (k > 0) then
      begin
        result := date2long(copy(ThisLine, succ(k), 8));
        break;
      end;
    until yet;

  end;

begin
  result := true;
  Memo1.lines.clear;
  Memo2.lines.clear;
  RevInfo.clear;
  rUpdateFiles.clear;
  rStripRelocFiles.clear;
  rRevSourceFile.clear;
  Inhaltsverzeichnis := TStringList.create;
  Inhaltsverzeichnis.addobject('Was ist neu', nil);

  ThisFName := ComboBox1.Text;

  rRevSourceFile.LoadFromFile(iAutoUpRevDir + ThisFName, TEncoding.UTF8);

  iProjektName := nextp(ThisFName, '.');
  if RadioButton_SetupType_ReleaseCandidate.checked then
    iProjektName := iProjektName + '-RC';
  if RadioButton_SetupType_Console.checked then
    iProjektName := iProjektName + '-Console';
  iShortName := '';
  rLatestRevOhnePunkt := '0000';
  AddRevLines := false;
  iDeleteOlder := true;
  InstallFrom := '';
  InfoStr := '';
  iInnoSetupScript.clear;
  ieMail := '';
  iPostMove.clear;
  iPostCopy.clear;
  iUnofficial := false;
  iSingleFile := '';
  iInnoSetupOhnePunkt := false;
  iInnoSetupUpdate := false;
  iPublic := false;
  iSourceBall := false;
  iArchive := false;
  iUpload := '';
  iPHP_Constant := '';
  iPHP_OutFile := '';
  iTXT_Versioning := false;
  iSourcePath := iAutoUpRevDir;
  iDestPath := iAutoUpRevDir;

  iUploads.clear;
  rAutoUps.clear;
  rAutoDels.clear;

  rSQL.clear;

  RevVonDatum := MaxInt; // should be smaller
  RevBisDatum := 0; // should be greater
  DOSCharSet := false;
  FullPathPrepared := false;

  rActRevDatum := 0;
  rOldRevDatum := 0;
  rInfoBegin := rRevSourceFile.indexof(cInfoTagBegin);
  rInfoEnd := rRevSourceFile.indexof(cInfoTagEnd);
  rZipFName.clear;

  if (rInfoBegin >= rInfoEnd) then
    ShowMessage(cInfoTagBegin + #13 + cInfoTagEnd + #13 + '------------------' + #13 + 'fehlt, oder falsch gesetzt!');

  RevAsHtml := TStringList.create;

  RevAsHtml.add('');
  RevAsHtml.add('<HTML>');

  //
  // Datenbank-Metadata aufbereiten
  //
  SQLBegin := rRevSourceFile.indexof(cSQLBlockBegin);
  if SQLBegin <> -1 then
  begin
    RevAsHtml.add('<!-- SQL');
    for n := succ(SQLBegin) to pred(rRevSourceFile.indexof(cSQLBlockEnd)) do
      RevAsHtml.add(rRevSourceFile[n]);
    RevAsHtml.add('-->');
  end;

  RevAsHtml.add('<HEAD>');
  RevAsHtml.add('<STYLE TYPE="text/css">');
  RevAsHtml.add('<!--');
  RevAsHtml.add('BODY {font-family:Courier New;font-size:10pt}');
  RevAsHtml.add('A.red0 {color:CC0000;text-decoration:underline}');
  RevAsHtml.add('A.blue0 {color:000099;text-decoration:none}');
  RevAsHtml.add('-->');
  RevAsHtml.add('</STYLE>');
  RevAsHtml.add('<TITLE>Projekt Info</TITLE>');
  RevAsHtml.add('</HEAD>');
  RevAsHtml.add
    ('<body bgcolor="#FFFFFF" leftmargin=10 topmargin=0 marginwidth=0 marginheight=0 vlink="#888888" alink="#AA3333" link="#336699">');
  RevAsHtml.add('<!-- BEGIN Info -->');

  for n := 0 to pred(rRevSourceFile.count) do
  begin

    ThisLine := rRevSourceFile[n];

    if (pos(cDeleteOlder, ThisLine) = 1) then
    begin
      iDeleteOlder := false;
      continue;
    end;

    if CheckAndPos(cSourceName, ThisLine, InfoTextPos, n) then
    begin
      iSourcePath := ValidatePathName(copy(ThisLine, InfoTextPos, MaxInt)) + '\';
      if (pos(':', iSourcePath) = 0) then
        iSourcePath := ExpandFileName(iAutoUpRevDir + iSourcePath);
      continue;
    end;

    if CheckAndPos(cDestName, ThisLine, InfoTextPos, n) then
    begin
      iDestPath := ValidatePathName(copy(ThisLine, InfoTextPos, MaxInt)) + '\';
      if (pos(':', iDestPath) = 0) then
        iDestPath := ExpandFileName(iAutoUpRevDir + iDestPath);
      continue;
    end;

    if pos(cCharSet, ThisLine) = 1 then
    begin
      DOSCharSet := true;
      for m := 0 to pred(rRevSourceFile.count) do
        rRevSourceFile[m] := oem2ansi(rRevSourceFile[m]);
      continue;
    end;

    if CheckAndPos(cFullPath, ThisLine, InfoTextPos, n) then
    begin
      FullPathPrepared := true;
      FullPathPreparedValue := copy(ThisLine, InfoTextPos, MaxInt);
      continue;
    end;

    if CheckAndPos(cInfo, ThisLine, InfoTextPos, n) then
    begin
      InfoStr := cutblank(copy(ThisLine, InfoTextPos, MaxInt));
      continue;
    end;

    if CheckAndPos(cCopy, ThisLine, InfoTextPos, n) then
    begin
      CopyCommand := doReplace(cutblank(copy(ThisLine, InfoTextPos, MaxInt)));
      CopySrc := nextp(CopyCommand, ',');
      CopyDest := nextp(CopyCommand, ',');

      if (pos('.\',CopySrc)>0) then
      begin
       CopySrc := iSourcePath+CopySrc;
       CopyDest := iSourcePath+CopyDest;
      end;

      if FileExists(CopySrc) then
      begin
        if not(FileCopy(CopySrc, CopyDest)) then
          ShowMessage('980:'+#13+CopyDest +#13+ ' konnte nicht angelegt werden!');
      end else
        ShowMessage('982:'+#13+CopySrc+#13+ ' nicht gefunden!');
      continue;
    end;

    if CheckAndPos(cAdd, ThisLine, InfoTextPos, n) then
    begin
      CopyCommand := doReplace(cutblank(copy(ThisLine, InfoTextPos, MaxInt)));
      CopySrc := nextp(CopyCommand, ',');
      CopyDest := nextp(CopyCommand, ',');
      if (CopyDest='') then
       CopyDest := CopySrc;

      if (pos(':',CopySrc)=0) then
        CopySrc := iSourcePath + CopySrc;
      if pos(':',CopyDest)=0 then
       CopyDest := iDestPath + CopyDest;

      if (pos('*',CopySrc)=0) then
        AddFile(CopySrc, CopyDest)
      else
        AddDir(CopySrc, CopyDest);

      continue;
    end;

    if CheckAndPos(cDelete, ThisLine, InfoTextPos, n) then
    begin
      DeleteCommand := cutblank(copy(ThisLine, InfoTextPos, MaxInt));
      FileDelete(DeleteCommand);
      continue;
    end;

    if CheckAndPos(cUpload, ThisLine, InfoTextPos, n) then
    begin
      if (iUpload = '') then
        iUpload := cutblank(copy(ThisLine, InfoTextPos, MaxInt))
      else
        iUploads.add(cutblank(copy(ThisLine, InfoTextPos, MaxInt)));
      continue;
    end;

    if CheckAndPos(cPostMove, ThisLine, InfoTextPos, n) then
    begin
      iPostMove.add(cutblank(copy(ThisLine, InfoTextPos, MaxInt)));
      continue;
    end;

    if CheckAndPos(cPostCopy, ThisLine, InfoTextPos, n) then
    begin
      iPostCopy.add(cutblank(copy(ThisLine, InfoTextPos, MaxInt)));
      continue;
    end;

    if CheckAndPos(cInstallAble, ThisLine, InfoTextPos, n) then
    begin
      InstallFrom := cutblank(copy(ThisLine, InfoTextPos, MaxInt));
      continue;
    end;

    if CheckAndPos(cSingleFile, ThisLine, InfoTextPos, n) then
    begin
      iSingleFile := cutblank(copy(ThisLine, InfoTextPos, MaxInt));
      continue;
    end;

    if CheckAndPos(cInnoSetUpOhnePunkt, ThisLine, InfoTextPos, n) then
    begin
      iInnoSetupOhnePunkt := true;
      continue;
    end;

    if CheckAndPos(cInnoSetUpUpdate, ThisLine, InfoTextPos, n) then
    begin
      iInnoSetupUpdate := true;
      continue;
    end;

    if CheckAndPos(cInnoSetupScript, ThisLine, InfoTextPos, n) then
    begin
      iInnoSetupScript.add(cutblank(copy(ThisLine, InfoTextPos, MaxInt)));
      continue;
    end;

    if CheckAndPos(cUnofficial, ThisLine, InfoTextPos, n) then
    begin
      iUnofficial := true;
      continue;
    end;

    if CheckAndPos(cPUBLIC, ThisLine, InfoTextPos, n) then
    begin
      iPublic := true;
      continue;
    end;

    if CheckAndPos(cSOURCEBALL, ThisLine, InfoTextPos, n) then
    begin
      iSourceBall := true;
      continue;
    end;

    if CheckAndPos(cTXTVersioning, ThisLine, InfoTextPos, n) then
    begin
      iTXT_Versioning := true;
      continue;
    end;

    if CheckAndPos(cARCHIVE, ThisLine, InfoTextPos, n) then
    begin
      iArchive := true;
      continue;
    end;

    if CheckAndPos(cVersion, ThisLine, InfoTextPos, n) then
    begin
      ShowMessage(FileVersion(iSourcePath + cutblank(copy(ThisLine, InfoTextPos, MaxInt))));
      continue;
    end;

    if CheckAndPos(cPrjName, ThisLine, InfoTextPos, n) then
    begin
      iProjektName := cutblank(copy(ThisLine, InfoTextPos, MaxInt));
      if (iShortName = '') then
        iShortName := iProjektName;
      continue;
    end;

    if CheckAndPos(cShortName, ThisLine, InfoTextPos, n) then
    begin
      iShortName := copy(ThisLine, InfoTextPos, MaxInt);
      continue;
    end;

    if CheckAndPos(ceMail, ThisLine, InfoTextPos, n) then
    begin
      ieMail := copy(ThisLine, InfoTextPos, MaxInt);
      continue;
    end;

    if CheckAndPos(cPHPVersioning, ThisLine, InfoTextPos, n) then
    begin
      iPHP_Constant := nextp(copy(ThisLine, InfoTextPos, MaxInt), ',', 0);
      iPHP_OutFile := nextp(copy(ThisLine, InfoTextPos, MaxInt), ',', 1);
      continue;
    end;

    if CheckAndPos(cStripReloc, ThisLine, InfoTextPos, n) then
    begin
      ThisLine := copy(ThisLine, InfoTextPos, MaxInt);
      if (pos(':', ThisLine) > 0) or (ThisLine[1] = '\') then
        rStripRelocFiles.add(ThisLine)
      else
        rStripRelocFiles.add(iSourcePath + ThisLine);
      continue;
    end;

    if CheckAndPos(cUpdateName, ThisLine, InfoTextPos, n) then
    begin
      ThisLine := doReplace(copy(ThisLine, InfoTextPos, MaxInt));
      if (pos(':', ThisLine) > 0) or (ThisLine[1] = '\') then
        ThisFName := ThisLine
      else
        ThisFName := iSourcePath + ThisLine;
      if FileExists(ThisFName) then
        rUpdateFiles.add(ThisFName)
      else
       ShowMEssage('1148:'+'Datei '+#13+'"'+ThisFName+'"'+#13+' nicht gefunden!');
      continue;
    end;

    if CheckAndPos(cKundeID, ThisLine, InfoTextPos, n) then
    begin
      KundeID := copy(ThisLine, InfoTextPos, MaxInt);
      // imp pend: Kunden-Daten laden!
      continue;
    end;

    if AddRevLines then
    begin

      if CheckAndPos(cRevInfo, ThisLine, InfoTextPos, -1) then
      begin
        rOldRevDatum := ExtractRevDatum;
        if not(DateOK(rOldRevDatum)) then
          break;
        if (DateDiff(rOldRevDatum, rActRevDatum) > cRevPending) then
          break;
        ThisLine := iProjektName + ' ' + ThisLine;
      end;

      RevInfo.add(ThisLine);

      continue;
    end;

    if CheckAndPos(cRevInfo, ThisLine, InfoTextPos, -1) then
    begin
      ExternalRev := ExtractSegmentBetween(ThisLine,'{','}');
      if (ExternalRev<>'') then
      begin
        rRev := TStringList.Create;
        rRev.LoadFromFile(iSourcePath+ExternalRev);
        for m := 0 to pred(rRev.Count) do
          if (pos(cRevInfo,rRev[m])=1) then
          begin
            ThisLine := rRev[m];
            break;
          end;
        rRev.Free;
      end;
      rLatestRevMitPunkt := nextp(copy(ThisLine, 5, MaxInt), ' ', 0);
      rLatestRevOhnePunkt := rLatestRevMitPunkt;
      ersetze('.', '', rLatestRevOhnePunkt);
      rActRevDatum := ExtractRevDatum;
      RevInfo.add(iProjektName + ' ' + ThisLine);
      AddRevLines := true;
    end;

    if not(AddRevLines) then
    begin
      // weitere Punkte des Inhaltsverzeichnisses einfügen
      if (n > rInfoEnd) then
        if length(ThisLine) > 1 then
          if (ThisLine[1] <> ' ') and (ThisLine[1] <> '@') then
            Inhaltsverzeichnis.addobject(ThisLine, pointer(n));
    end;

  end;

  if RadioButton_SetupType_ReleaseCandidate.checked or
     RadioButton_SetupType_Console.checked then
  begin
    iPublic := false;
    iDeleteOlder := false;
  end;

  // calculate ZIP-Filename
  repeat

    if (iSingleFile <> '') then
    begin
      rZipFName.add(ExtractFileName(iSingleFile_Dest));
      break;
    end;

    if (InstallFrom <> '') then
    begin
      rZipFName.add(iShortName + 'Setup' + rLatestRevOhnePunkt + cZIPExtension);
      break;
    end;

    if (iInnoSetupScript.count > 0) then
    begin
      for n := 0 to pred(iInnoSetupScript.count) do
        if iInnoSetupOhnePunkt then
          rZipFName.add('Setup-' + nextp(iInnoSetupScript[n], '.', 0) + '-' + rLatestRevOhnePunkt + '.exe')
        else
          rZipFName.add('Setup-' + nextp(iInnoSetupScript[n], '.', 0) + '-' + rLatestRevMitPunkt + '.exe');
      break;
    end;

    rZipFName.add(iShortName + rLatestRevOhnePunkt + cZIPExtension);

  until yet;

  for n := 0 to pred(rZipFName.count) do
  begin
    Memo1.lines.add(rZipFName[n]);
    Memo1.lines.add(fill('=', length(rZipFName[n])));
  end;
  Memo1.lines.add('');
  Memo1.lines.addstrings(RevInfo);

  if ieMail = '' then
    ieMail := iProjektName + ' <' + iProjektName + '>';

  // Icon
  rSourceIconFname := iSourcePath + cRohstoffePath + iProjektName + 'icon.gif';
  if not(FileExists(rSourceIconFname)) then
    rSourceIconFname := iSourcePath + cRohstoffePath + 'icon.gif';
  if not(FileExists(rSourceIconFname)) then
    rSourceIconFname := iAutoUpRevDir + cRohstoffePath + iProjektName + 'icon.gif';

  rDestIconFname := cAutoUpContent + iProjektName + 'icon.gif';

  rIconFound := FileExists(rSourceIconFname);
  CheckBox1.checked := rIconFound;

  // Info-Dokument
  RevAsHtml.add('<b>' + Ansi2Html('Info Dokument für ' + iProjektName + ' Rev. ' + rLatestRevMitPunkt) + '</b><br>');
  RevAsHtml.add('<br>');
  RevAsHtml.add('&nbsp;&nbsp;<A class=red0 href="#' + inttostr(0) + '">' + Ansi2Html(Inhaltsverzeichnis[0]) +
    '</A><br>');
  RevAsHtml.add('<br>');
  RevAsHtml.add(Ansi2Html('Inhaltsverzeichnis') + '<br>');
  RevAsHtml.add('<br>');

  for n := 1 to pred(Inhaltsverzeichnis.count) do
    RevAsHtml.add('&nbsp;&nbsp;' + fill('&nbsp;', CountPreFix(Inhaltsverzeichnis[n])) + '<A class=red0 href="#' +
      inttostr(n) + '">' + Ansi2Html(CutPreFix(Inhaltsverzeichnis[n])) + '</A><br>');

  MachineState := 0;
  RefCount := 1;
  for n := succ(rInfoEnd) to pred(rRevSourceFile.count) do
  begin

    if pos(cRevInfo, rRevSourceFile[n]) = 1 then
    begin
      if (MachineState = 0) then
      begin
        RevAsHtml.add('<A class=red0 name="0">' + Ansi2Html(rRevSourceFile[n]) + '</A><br>');
        inc(MachineState);
      end
      else
      begin
        RevAsHtml.add('<A class=red0>' + Ansi2Html(rRevSourceFile[n]) + '</A><br>');
      end;
      continue;
    end;

    if (MachineState = 0) then
    begin
      if (length(rRevSourceFile[n]) > 0) then
      begin
        if not(rRevSourceFile[n][1] in [' ', #9, '@']) then
        begin
          RevAsHtml.add('<A class=blue0 name="' + inttostr(RefCount) + '">' + Ansi2Html(rRevSourceFile[n]) +
            '</A><br>');
          inc(RefCount);
        end
        else
          RevAsHtml.add(Ansi2Html(rRevSourceFile[n]) + '<br>');
      end
      else
      begin
        RevAsHtml.add(Ansi2Html(rRevSourceFile[n]) + '<br>');
      end;
    end
    else
    begin
      RevAsHtml.add(Ansi2Html(rRevSourceFile[n]) + '<br>');
    end;

  end;
  RevAsHtml.add('<!-- END Info -->');
  RevAsHtml.add('</BODY>');
  RevAsHtml.add('</HTML>');

  // Info-Dokument ausgeben
  RevAsHtml.SaveToFile(cAutoUpContent + iProjektName + '_Info.html');
  RevAsHtml.SaveToFile(iAutoUpRevDir + '..\..\Cargobay\' + iProjektName + '_Info.html');

  rUpdateFiles.add(cAutoUpContent + iProjektName + '_Info.html');
  if not(RadioButton_SetupType_ReleaseCandidate.checked) and
     not(RadioButton_SetupType_Console.checked) then
    rAutoUps.add(cAutoUpContent + iProjektName + '_Info.html');

  RevAsHtml.free;
  Inhaltsverzeichnis.free;
end;

function TFormAutoUp.CreateHtml: boolean;
var
  n, m, k: integer;
  OldProjekts: TStringList;
  SortProjekts: TStringList;
  REVISIONBlock: string;
  OldFullSetUpFiles: TStringList;
  MainPage: THTMLTemplate;
begin
  result := true;

  if RadioButton_SetupType_Console.Checked then
   exit;

  if RadioButton_SetupType_ReleaseCandidate.checked then
  begin
    // Nur RC-Versionsnummer schreiben
    MainPage := THTMLTemplate.create;
    with MainPage do
    begin
      forceUTF8:= true;
      add('<!DOCTYPE html>');
      add('<html lang="de">');
      add('<!--');
      // vvv DO NOT CHANGE FORMAT vvv
      add(' Rev ' + rLatestRevOhnePunkt);
      // ^^^ DO NOT CHANGE FORMAT ^^^
      add('-->');
      add('<head>');
      add(' <meta charset="utf-8" />');
      add(' <style>body{font-family: monospace}</style>');
      add(' <title>' + iProjektName + ' Rev. ' + rLatestRevMitPunkt + '</title>');
      add('</head>');
      add('<body>');
      add('  <br><h1>' + iProjektName + '-RC Rev. ' + rLatestRevMitPunkt + '</h1>');
      add('</body>');
      add('</html>');
      SaveToFileCompressed(cAutoUpContent + iProjektName + '-RC.html');
    end;
    MainPage.free;
    rAutoUps.add(cAutoUpContent + iProjektName + '-RC.html');
    exit;
  end;

  //

  // Template neu erzeugen!
  MainPage := THTMLTemplate.create;
  MainPage.LoadFromFile(cTemplatesPath + 'index.html');
  with MainPage do
  begin

    if iInnoSetupUpdate then
      REVISIONBlock := 'REVISION2'
    else
      REVISIONBlock := 'REVISION1';

    //
    if rIconFound then
      WriteValue(REVISIONBlock, 'Icon', iProjektName)
    else
      WriteValue(REVISIONBlock, 'Icon', 'no');

    WriteValue(REVISIONBlock, 'Name', iProjektName);
    WriteValue(REVISIONBlock, 'Rev', rLatestRevMitPunkt);

    if (InstallFrom = '') and (iInnoSetupScript.count = 0) then
    begin
      WriteValue(REVISIONBlock, 'ZipFName1', rZipFName)
    end
    else
    begin
      if not(RadioButton_SetupType_Full.checked) then
      begin
        //
        OldFullSetUpFiles := TStringList.create;

        with aFTP do
        begin
          Host := iAutoUpFTP_host;
          UserName := iAutoUpFTP_user;
          Password := iAutoUpFTP_pwd;
          Login(iAutoUpFTP_root);
          Dir(
            { } iAutoUpFTP_root,
            { } ExtractFileName(rFullSetUpMask),
            { } '',
            { } OldFullSetUpFiles);
        end;

        // dir(rFullSetUpMask, OldFullSetUpFiles, false);

        if (OldFullSetUpFiles.count = 0) then
        begin

          ShowMessage('1438:'+#13+
           {} 'Vollsetup ' + rFullSetUpMask + ' nicht gefunden!' + #13 +
           {} ' Dadurch kann der Link "Download Setup" nicht gesetzt werden!' + #13 +
           {} 'Behebung: Lade den Vollsetup nach:' + #13 +
           {} cAutoUpContent);

        end
        else
        begin
          OldFullSetUpFiles.Sort;
          WriteValue(REVISIONBlock, 'ZipFName1', OldFullSetUpFiles[pred(OldFullSetUpFiles.count)]);
        end;
        OldFullSetUpFiles.free;

      end
      else
      begin
        WriteValue(REVISIONBlock, 'ZipFName1', ZipFNameExe);
      end;
      WriteValue(REVISIONBlock, 'ZipFName2', ZipFNameExe2);
    end;

    WriteValue(REVISIONBlock, 'Revision Info', Memo1.lines[3]);
    WriteValue(REVISIONBlock, 'Projekt Info', InfoStr);

    if iUnofficial then
      FileDelete(cTemplatesPath + iProjektName + cFragmentExtension)
    else
      SaveBlockToFile(REVISIONBlock, cTemplatesPath + iProjektName + cFragmentExtension);

    ClearBlock('REVISION1');
    ClearBlock('REVISION2');

    SaveBlockToFile('TRENNER', cTemplatesPath + 'TRENNER' + cGeneratedExtension);
    ClearBlock('TRENNER');

    // weitere Projekte dranhängen
    OldProjekts := TStringList.create;
    dir(cTemplatesPath + '*' + cFragmentExtension, OldProjekts, false);
    for n := pred(OldProjekts.count) downto 0 do
      if DateDiff(FileDate(cTemplatesPath + OldProjekts[n]), DateGet) > cRevTopPage then
        OldProjekts.delete(n);

    // prepare for sort, get (from-to) Date
    SortProjekts := TStringList.create;

    for n := 0 to pred(OldProjekts.count) do
    begin

      setDatesFromFile(cTemplatesPath + OldProjekts[n]);
      if (DateA > 0) then
        RevVonDatum := Min(RevVonDatum, DateA);

      if (DateB > 0) then
        RevBisDatum := max(RevBisDatum, DateB)
      else
        DateB := DateA;

      if DateB = 0 then
        DateB := FileDate(cTemplatesPath + OldProjekts[n]);

      SortProjekts.add(inttostr(100000000 - DateB) + ',' + AnsiUpperCase(OldProjekts[n]) + ',' + inttostr(n));
    end;
    SortProjekts.Sort;

    for n := 0 to pred(OldProjekts.count) do
    begin
      k := revpos(',', SortProjekts[n]);
      m := strtoint(copy(SortProjekts[n], succ(k), MaxInt));
      LoadBlockFromFile('REVISION', cTemplatesPath + OldProjekts[m]);
      if CheckBox2.checked then
        if n <> pred(OldProjekts.count) then
          LoadBlockFromFile('REVISION', cTemplatesPath + 'TRENNER' + cGeneratedExtension);
    end;
    SortProjekts.free;

    // Jetzt alle Projekte
    ClearBlock('SUBTOPIC');
    ClearBlock('SUBSUBTOPIC');
    ClearBlock('SUBSUBSUBTOPIC');

    WriteValue('PROJECTHEADER', 'Projekt Gruppe', 'Projekt-Übersicht');

    SaveBlockToFile('SINGLEPROJECT', cTemplatesPath + 'PROJEKT' + cGeneratedExtension);
    ClearBlock('SINGLEPROJECT');

    OldProjekts.clear;
    for n := 0 to pred(AllProjects.count) do
      if (pos('(', AllProjects[n]) <> 1) then
        OldProjekts.add(AllProjects[n]);

    for n := 0 to pred(OldProjekts.count) do
    begin
      k := pos(cRevExtension, OldProjekts[n]);
      if (k > 0) then
        OldProjekts[n] := copy(OldProjekts[n], 1, pred(k));
    end;
    OldProjekts.Sort;

    // Jetzt die linke Leiste, und die projekt-Seiten
    for n := 0 to pred(OldProjekts.count) do
    begin
      LoadBlockFromFile('SINGLEPROJECT', cTemplatesPath + 'PROJEKT' + cGeneratedExtension);
      WriteValue('SINGLEPROJECT', 'Name', OldProjekts[n]);
      WriteValue('SINGLEPROJECT', 'Projekt', OldProjekts[n] + '.html');
      if CheckBox3.checked then
        CreateProjectInfo(OldProjekts[n]);
    end;
    if not(CheckBox3.checked) then
      CreateProjectInfo(iProjektName);

    OldProjekts.free;

    //
    SaveBlockToFile('NOT FOUND', cTemplatesPath + 'NOT FOUND' + cGeneratedExtension);
    SaveBlockToFile('REVINFO', cTemplatesPath + 'REVINFO' + cGeneratedExtension);
    ClearBlock('NOT FOUND');
    ClearBlock('REVINFO');
    ClearBlock('THEMA');
    ClearBlock('MAKTUELL');

    // Index Seite
    WriteValue('Aktualisierung Revisions', long2date(RevVonDatum) + '-' + long2date(RevBisDatum));
    WriteValue('Datum der Erzeugung', long2date(DateGet));
    //
    FileDelete(cAutoUpContent + 'index.html');
    SaveToFileCompressed(cAutoUpContent + 'index.html');
    rAutoUps.add(cAutoUpContent + 'index.html');

    // "Nicht gefunden Seite"
    ClearBlock('MAIN');
    LoadBlockFromFile('MAIN', cTemplatesPath + 'NOT FOUND' + cGeneratedExtension);
    FileDelete(cAutoUpContent + 'ni.html');
    SaveToFileCompressed(cAutoUpContent + 'ni.html');
    rAutoUps.add(cAutoUpContent + 'ni.html');

    // Rechtliches
    ClearBlock('MAIN');
    LoadBlockFromFile('MAIN', cTemplatesPath + 'Rechtliches.txt');
    FileDelete(cAutoUpContent + 'Rechtliches.html');
    SaveToFileCompressed(cAutoUpContent + 'Rechtliches.html');
    rAutoUps.add(cAutoUpContent + 'Rechtliches.html');

    // Ueber
    ClearBlock('MAIN');
    LoadBlockFromFile('MAIN', cTemplatesPath + 'Ueber.txt');
    FileDelete(cAutoUpContent + 'Ueber.html');
    SaveToFileCompressed(cAutoUpContent + 'Ueber.html');
    rAutoUps.add(cAutoUpContent + 'Ueber.html');

    // Revision Info!
    ClearBlock('MAIN');
    LoadBlockFromFile('MAIN', cTemplatesPath + 'REVINFO' + cGeneratedExtension);
    WriteValue('REVSINGLELINE', 'Text', Memo1.lines);
    WriteValue('RevOhnePunkt', rLatestRevOhnePunkt);

    FileDelete(cAutoUpContent + iProjektName + 'Rev.html');
    if not(iUnofficial) then
    begin
      SaveToFileCompressed(cAutoUpContent + iProjektName + 'Rev.html');
      rAutoUps.add(cAutoUpContent + iProjektName + 'Rev.html');
    end;

  end;
  MainPage.free;
end;

function TFormAutoUp.CreateTemplates: boolean;
begin
  result := false;
  try
    repeat
      if RadioButton_SetupType_ReleaseCandidate.checked then
        break;
      if RadioButton_SetupType_Console.checked then
        break;

      zip(cTemplatesPath + '*', cAutoUpPath + cTemplatesArchiveFName);

      rAutoUps.add(cAutoUpPath + cTemplatesArchiveFName);
    until yet;
    result := true;

  except
    ;
  end;
end;

function TFormAutoUp.CreateSetupFiles: boolean;
var
  n: integer;
  InnoSetupPatched: string;
  InnoResult: string;
  PHP_Version: TStringList;
  TXT_Version: TStringList;
  ZipFileName: string;
  ApplicationName: string;
  SourceName: string;
  DestName: string;
begin
  result := true;

  // Versions-Nummer Dateien jetzt erzeugen
  if (iPHP_Constant <> '') then
  begin
    PHP_Version := TStringList.create;
    with PHP_Version do
    begin
      add('<?php');
      add('/*');
      add('');
      add('WARNUNG: DIESE DATEI NICHT EDITIEREN - SIE WIRD VON AUTOUP GESCHRIEBEN !');
      add('      ___                  __  __');
      add('     / _ \ _ __ __ _  __ _|  \/  | ___  _ __');
      add('    | | | | ''__/ _` |/ _` | |\/| |/ _ \| ''_ \');
      add('    | |_| | | | (_| | (_| | |  | | (_) | | | |');
      add('     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|');
      add('               |___/');
      add('');
      add('    Copyright (C) 1987-' + JahresZahl + '  Andreas Filsinger');
      add('');
      add('    This program is free software: you can redistribute it and/or modify');
      add('    it under the terms of the GNU General Public License as published by');
      add('    the Free Software Foundation, either version 3 of the License, or');
      add('    (at your option) any later version.');
      add('');
      add('    This program is distributed in the hope that it will be useful,');
      add('    but WITHOUT ANY WARRANTY; without even the implied warranty of');
      add('    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the');
      add('    GNU General Public License for more details.');
      add('');
      add('    You should have received a copy of the GNU General Public License');
      add('    along with this program.  If not, see <http://www.gnu.org/licenses/>.');
      add('');
      add('    http://orgamon.org/');
      add('');
      add('*/');
      add('');
      add('define("' + iPHP_Constant + '","' + rLatestRevMitPunkt + '");');
      add('');
      add('?>');
      SaveToFile(iSourcePath + iPHP_OutFile);
    end;
    PHP_Version.free;
  end;

  if iTXT_Versioning then
  begin
    TXT_Version := TStringList.create;
    with TXT_Version do
    begin
      add(rLatestRevMitPunkt);
      SaveToFile(iSourcePath + 'revision.txt');
    end;
    TXT_Version.free;
  end;

  // Source-Ball noch erzeugen?
  if iSourceBall then
    CreateSourceBall;

  // B U I L D
  // hier den automatischen Build erzeugen

  // Strip-Reloc Sachen
  ApplicationName := ProgramFilesDir + cStripRelocExecPath;
  for n := 0 to pred(rStripRelocFiles.count) do
  begin
    FileDelete(rStripRelocFiles[n] + '.exe');
    if not(FileCopy(rStripRelocFiles[n], rStripRelocFiles[n] + '.exe')) then
      raise Exception.create('Copy ' + #13 + rStripRelocFiles[n] + #13 + rStripRelocFiles[n] + '.exe' + #13 +
        'unmöglich!');

    if not(FileExists(ApplicationName)) then
      raise Exception.create('ERROR: Anwendung ' + ApplicationName + ' nicht gefunden');
    SourceName := rStripRelocFiles[n] + '.exe';
    if not(FileExists(SourceName)) then
      raise Exception.create('ERROR: ' + SourceName + ' nicht gefunden');

    CallExternalApp('"' + ApplicationName + '" "' + SourceName + '"', SW_SHOWNORMAL);

  end;

  // Icon Sachen
  if rIconFound then
  begin

    // nur austauschen, wenn Quelle jünger als das Ziel ist
    if (FileAge(rDestIconFname) < FileAge(rSourceIconFname)) then
      FileCopy(rSourceIconFname, rDestIconFname);

    // grundsätzlich das Icon hochladen
    if not(RadioButton_SetupType_ReleaseCandidate.checked) and
       not(RadioButton_SetupType_Console.checked) then
      rAutoUps.add(rDestIconFname);
  end;

  if iUnofficial then
  begin
    FileDelete(rDestIconFname);
    rAutoDels.add(rDestIconFname);
  end;

  // create zip
  repeat

    // SINGLE File
    if (iSingleFile <> '') then
    begin
      FileCopy(iSourcePath + iSingleFile_Source, cAutoUpContent + iSingleFile_Dest);
      rAutoUps.add(cAutoUpContent + iSingleFile_Dest);
      break;
    end;

    // SFX Installer
    if (InstallFrom <> '') then
    begin
      zip(nil, cAutoUpContent + rZipFName[0], czip_set_RootPath + '=' + InstallFrom);

      rAutoUps.add(cAutoUpContent + rZipFName[0]);
      break;
    end;

    // erzeugt von Inno-Setup
    if (iInnoSetupScript.count > 0) then
    begin

      for n := 0 to pred(iInnoSetupScript.count) do
      begin

        if RadioButton_SetupType_Full.checked then
        begin

          // Full-Setup
          InnoSetupPatched := iSourcePath + iInnoSetupScript[n] + '.iss';
          InnoResult := InnoProceed(iSourcePath + iInnoSetupScript[n], InnoSetupPatched);
          ApplicationName := ProgramFilesDir + cInnoSetUp6ExecPath;
          if not(FileExists(ApplicationName)) then
          ApplicationName := ProgramFilesDir + cInnoSetUp5ExecPath;

          if not(FileExists(ApplicationName)) then
            raise Exception.create('ERROR: ' + ApplicationName + ' nicht gefunden');
          if not(FileExists(InnoSetupPatched)) then
            raise Exception.create('ERROR: ' + InnoSetupPatched + ' nicht gefunden');

          CallExternalApp('"' + ApplicationName + '"' + ' ' + '"' + InnoSetupPatched + '"', SW_SHOWNORMAL);

          if not FileExists(InnoResult) then
          begin
            ShowMessage('1787:'+'Fehler im Script ' + InnoSetupPatched);
          end;
        end;

        if RadioButton_SetupType_Update.checked then
        begin
          // Update-Setup

          if iInnoSetupUpdate then
          begin
            ersetze('.iss', '-Update.iss', iInnoSetupScript, n);
            InnoSetupPatched := iSourcePath + iInnoSetupScript[n] + '.iss';

            InnoResult := InnoProceed(iSourcePath + iInnoSetupScript[n], InnoSetupPatched);
            ApplicationName := ProgramFilesDir + cInnoSetUp6ExecPath;
            if not(FileExists(ApplicationName)) then
            ApplicationName := ProgramFilesDir + cInnoSetUp5ExecPath;
            if not(FileExists(ApplicationName)) then
              raise Exception.create('ERROR: ' + ApplicationName + ' nicht gefunden');
            if not(FileExists(InnoSetupPatched)) then
              raise Exception.create('ERROR: ' + InnoSetupPatched + ' nicht gefunden');

            CallExternalApp('"' + ApplicationName + '" "' + InnoSetupPatched + '"', SW_SHOWNORMAL);

            if not FileExists(InnoResult) then
            begin
              raise Exception.create('Fehler im Script ' + InnoSetupPatched);
            end;
          end;
        end;

        if RadioButton_SetupType_ReleaseCandidate.checked then
        begin
          // RC-Setup

          ersetze('.iss', '-RC.iss', iInnoSetupScript, n);
          InnoSetupPatched := iSourcePath + iInnoSetupScript[n] + '.iss';

          InnoResult := InnoProceed(iSourcePath + iInnoSetupScript[n], InnoSetupPatched);
          FileDelete(InnoResult);
          if FileExists(InnoResult) then
            raise Exception.create('ERROR: ' + InnoResult + ' nicht löschbar!');
          ApplicationName := ProgramFilesDir + cInnoSetUp6ExecPath;
          if not(FileExists(ApplicationName)) then
          ApplicationName := ProgramFilesDir + cInnoSetUp5ExecPath;
          if not(FileExists(ApplicationName)) then
            raise Exception.create('ERROR: ' + ApplicationName + ' nicht gefunden');
          if not(FileExists(InnoSetupPatched)) then
            raise Exception.create('ERROR: ' + InnoSetupPatched + ' nicht gefunden');

          CallExternalApp('"' + ApplicationName + '" "' + InnoSetupPatched + '"', SW_SHOWNORMAL);

          if not FileExists(InnoResult) then
            raise Exception.create('Fehler im Script ' + InnoSetupPatched);
        end;

        if RadioButton_SetupType_Console.checked then
        begin
          // Consolen-Setup

          ersetze('.iss', '-Console.iss', iInnoSetupScript, n);
          InnoSetupPatched := iSourcePath + iInnoSetupScript[n] + '.iss';

          InnoResult := InnoProceed(iSourcePath + iInnoSetupScript[n], InnoSetupPatched);
          FileDelete(InnoResult);
          if FileExists(InnoResult) then
            raise Exception.create('ERROR: ' + InnoResult + ' nicht löschbar!');
          ApplicationName := ProgramFilesDir + cInnoSetUp6ExecPath;
          if not(FileExists(ApplicationName)) then
          ApplicationName := ProgramFilesDir + cInnoSetUp5ExecPath;
          if not(FileExists(ApplicationName)) then
            raise Exception.create('ERROR: ' + ApplicationName + ' nicht gefunden');
          if not(FileExists(InnoSetupPatched)) then
            raise Exception.create('ERROR: ' + InnoSetupPatched + ' nicht gefunden');

          CallExternalApp('"' + ApplicationName + '" "' + InnoSetupPatched + '"', SW_SHOWNORMAL);

          if not FileExists(InnoResult) then
            raise Exception.create('Fehler im Script ' + InnoSetupPatched);
        end;


      end;

      // ###
      break;
    end;

    ZipFileName := cAutoUpContent + rZipFName[0];
    if FullPathPrepared then
    begin
      if CheckBoxFileWork.checked then
        zip('*', ZipFileName, czip_set_RootPath + '=' + FullPathPreparedValue);
    end
    else
    begin
      if CheckBoxFileWork.checked then
        zip(rUpdateFiles, ZipFileName);
    end;
    rAutoUps.add(ZipFileName);
    if iArchive then
      FileCopy(ZipFileName, iSourcePath + rZipFName[0]);

  until yet;

end;

function TFormAutoUp.PostCopyMove: boolean;
var
  n: integer;
begin
  //
  // Post-Moves durchführen
  //
  result := true;
  if iPostMove.count > 0 then
    for n := 0 to pred(iPostMove.count) do
      FileMove(outFileName(nextp(iPostMove[n], ',', 0)), outFileName(nextp(iPostMove[n], ',', 1)));

  if iPostCopy.count > 0 then
    for n := 0 to pred(iPostCopy.count) do
      FileCopy(outFileName(nextp(iPostCopy[n], ',', 0)), outFileName(nextp(iPostCopy[n], ',', 1)));
end;

function TFormAutoUp.RemoveOldRevisions: boolean;
var
  n: integer;

  procedure MoveOne(rZipFName: string);
  var
    ToDeleteMask: string;
    ToSearchMask: string;
    ActRevisionPart: string;
  begin
    ToDeleteMask := cAutoUpContent + rZipFName;
    if pos(rLatestRevOhnePunkt, ToDeleteMask) > 0 then
      ActRevisionPart := rLatestRevOhnePunkt
    else
      ActRevisionPart := rLatestRevMitPunkt;

    if pos('.', ActRevisionPart) = 0 then
      ToSearchMask := fill('?', length(ActRevisionPart))
    else
      ToSearchMask := fill('*.', CharCount('.', ActRevisionPart)) + '*';

    ersetze(ActRevisionPart, ToSearchMask, ToDeleteMask);

    // alten Full-Setup löschen
    rFullSetUpMask := ToDeleteMask;
    if iInnoSetupUpdate then
    begin
      if RadioButton_SetupType_Full.checked then
        InRente(ToDeleteMask);
    end
    else
    begin
      InRente(ToDeleteMask);
    end;

    // alten Update-Setup löschen
    ersetze('.exe', '-Update.exe', ToDeleteMask);
    if RadioButton_SetupType_Update.checked then
      InRente(ToDeleteMask);

    // alten Update-Setup löschen
    ersetze('.exe', '-RC.exe', ToDeleteMask);
    if RadioButton_SetupType_ReleaseCandidate.checked then
      InRente(ToDeleteMask);

  end;

begin
  // move older revisions to Historic Path
  result := true;
  FileDelete(cHistoricPath + '*', 5);

  // delete zip with same rev
  if CheckBoxFileWork.checked then
  begin

    repeat

      //
      if iInnoSetupUpdate and not(RadioButton_SetupType_Full.checked) then
        break;

      //
      for n := 0 to pred(rZipFName.count) do
      begin
        FileDelete(cAutoUpContent + rZipFName[n]);
      end;

    until yet;

    if iDeleteOlder then
      for n := 0 to pred(rZipFName.count) do
        MoveOne(rZipFName[n]);

  end;
end;

procedure TFormAutoUp.SpeedButton1Click(Sender: TObject);
begin
  openShell(iAutoUpRevDir);
end;

procedure TFormAutoUp.SpeedButton2Click(Sender: TObject);
begin
  openShell(cAutoUpContent);
end;

procedure TFormAutoUp.SpeedButton8Click(Sender: TObject);
begin
  openShell(cTemplatesPath);
end;

function TFormAutoUp.FTPup: boolean;
var
  Uploads: TStringList;
  n: integer;
  DestPath: string;
begin
  result := true;
  if (iUpload <> '') then
  begin
    Uploads := TStringList.create;
    DestPath := nextp(iUpload, ',', 3);
    Uploads.addstrings(rZipFName);
    Uploads.addstrings(iUploads);

    // Grösse berechnen, aufbereiten
    for n := pred(Uploads.count) downto 0 do
    begin
      if pos(':', Uploads[n]) = 0 then
        Uploads[n] := cAutoUpContent + Uploads[n];
      if not(FileExists(Uploads[n])) then
        Uploads.delete(n);
    end;

    // ftp initialisieren
    if (Uploads.count > 0) then
      if doit(HugeSingleLine(Uploads) + #13#13 + ' jetzt hochladen') then
        with aFTP do
        begin
          Host := nextp(iUpload, ',', 0);
          UserName := nextp(iUpload, ',', 1);
          Password := nextp(iUpload, ',', 2);
          Login(iAutoUpFTP_root);
          for n := pred(Uploads.count) downto 0 do
            Put(Uploads[n], DestPath, ExtractFileName(Uploads[n]));
          Disconnect;
        end;
    Uploads.free;
  end;
end;

procedure TFormAutoUp.Image2Click(Sender: TObject);
begin
  openShell(cHelpURL + 'AutoUp');
end;

function TFormAutoUp.CreateRevList: boolean;
var
  CheckRealName: TStringList;
  TemplateProjects: TStringList;
  n, m: integer;
  _realName: string;
  unofficial: boolean;

  _FileAge, NewestFileAge: integer;

begin
  CheckRealName := TStringList.create;
  TemplateProjects := TStringList.create;

  // rev-Liste erzeugen aus dem Dateisystem
  AllProjects.clear;
  NewestRevFName := '';
  NewestFileAge := 0;
  result := true;
  dir(iAutoUpRevDir + '*' + cRevExtension, AllProjects, false);
  for n := 0 to pred(AllProjects.count) do
  begin
    _FileAge := FileAge(iAutoUpRevDir + AllProjects[n]);
    if (_FileAge > NewestFileAge) then
    begin
      NewestFileAge := _FileAge;
      NewestRevFName := AllProjects[n];
    end;
    CheckRealName.LoadFromFile(iAutoUpRevDir + AllProjects[n]);
    _realName := AllProjects[n];
    unofficial := false;
    for m := 0 to Min(pred(CheckRealName.count), 100) do
    begin
      if (pos(cPrjName, CheckRealName[m]) = 1) then
      begin
        _realName := CheckRealName[m];
        ersetze(cPrjName, '', _realName);
        ersetze('*', '', _realName);
        _realName := cutblank(_realName) + cRevExtension;
      end;
      if pos(cUnofficial, CheckRealName[m]) = 1 then
        unofficial := true;
    end;
    AllProjects[n] := _realName;
    if unofficial then
      AllProjects[n] := '(' + AllProjects[n] + ')';
  end;

  // Neue Projekt-liste aufbereiten und Speichern
  AllProjects.Sort;
  RemoveDuplicates(AllProjects);

  // nicht öffentliche Projekt dürfen nicht zeitgleich öffentlich sein
  for n := pred(AllProjects.count) downto 0 do
    if (AllProjects.indexof('(' + AllProjects[n] + ')') <> -1) then
      AllProjects.delete(n);

  // Projekte, die zur Löschung anstehen jetzt löschen
  if CheckBoxRemove.checked then
  begin

    n := AllProjects.indexof(Edit1.Text);
    if (n = -1) then
      n := AllProjects.indexof('(' + Edit1.Text + ')');
    if (n <> -1) then
      AllProjects.delete(n);
    FileMove(iAutoUpRevDir + Edit1.Text, iAutoUpRevDir + Edit1.Text + '.deleted');
    FileDelete(cTemplatesPath + nextp(Edit1.Text, cRevExtension, 0) + cFragmentExtension);
    FileDelete(cTemplatesPath + nextp(Edit1.Text, cRevExtension, 0) + cInfoExtension);
  end;

  CheckRealName.free;
  TemplateProjects.free;
end;

function TFormAutoUp.DownLoadTemplates: boolean;
begin
  result := true;
  if not(CheckBoxNoDown.checked) and
     not(RadioButton_SetupType_ReleaseCandidate.checked) and
     not(RadioButton_SetupType_Console.checked) then
  begin

    // templates Archive downloaden
    FileDelete(cAutoUpPath + cTemplatesArchiveFName);

    with aFTP do
    begin
      Host := iAutoUpFTP_host;
      UserName := iAutoUpFTP_user;
      Password := iAutoUpFTP_pwd;
      Login(iAutoUpFTP_root);
      Log('FTP: get ' + cTemplatesArchiveFName + ' ...');
      Get(cTemplatesArchiveFName, cAutoUpPath + cTemplatesArchiveFName, true);
      Disconnect;
    end;

    // entpacken nach .
    FileDelete(cTemplatesPath + '*');
    unzip(cAutoUpPath + cTemplatesArchiveFName, cTemplatesPath);
    FileDelete(cAutoUpPath + cTemplatesArchiveFName);
  end;
end;

function TFormAutoUp.iAutoUpFTP_host: string;
begin
  result := nextp(iAutoUpFTP, ';', 0);
end;

function TFormAutoUp.iAutoUpFTP_user: string;
begin
  result := nextp(iAutoUpFTP, ';', 1);
end;

function TFormAutoUp.iAutoUpFTP_pwd: string;
begin
  result := nextp(iAutoUpFTP, ';', 2);
end;

function TFormAutoUp.iAutoUpFTP_root: string;
begin
  result := nextp(iAutoUpFTP, ';', 3);
end;

function TFormAutoUp.doReplace(s: string):string;
begin
 result := s;
 if (pos('«',s)>0) then
 begin
    ersetze('«RevMitPunkt»', rLatestRevMitPunkt, result);
    ersetze('«RevOhnePunkt»', rLatestRevOhnePunkt, result);
    ersetze('«KurzName»', iShortName, result);
    ersetze('«Ordner»', iOrdner, result);
    ersetze('«ProgramFiles»', ProgramFilesDir, result);
  end;
end;

function TFormAutoUp.iSingleFile_Source: string;
begin
  result := doReplace(nextp(iSingleFile,' ',0));
end;

function TFormAutoUp.iSingleFile_Dest: string;
begin
  result := nextp(iSingleFile,' ',1);
  if (result='') then
   result := iSingleFile_Source
  else
   result := doReplace(result);
end;

function TFormAutoUp.CreateSourceBall: boolean;
var
  sDPR: TStringList;
  n: integer;
  sSourceFName: string;
  sFullSourceFname: string;
  sFullDFMFName: string;

  // Versionsnummer des aktuellen Projektes
  sGLOBALS: TStringList;
  sVersion: string;

  // Sicherungsverzeichnis
  sDestPath: string;

  procedure add(FName: string);
  begin
    // listbox1.items.add(FName);
    FileCopy(FName, sDestPath + ExtractFileName(FName));
  end;

begin
  result := false;
  sDPR := TStringList.create;

  // Versionnummer ermitteln
  sVersion := 'x.xxx';
  sGLOBALS := TStringList.create;
  sGLOBALS.LoadFromFile(iSourcePath + 'globals.pas');
  for n := 0 to pred(sGLOBALS.count) do
  begin
    if (pos('Version:', sGLOBALS[n]) > 0) then
    begin
      sVersion := ExtractSegmentBetween(sGLOBALS[n], '= ', ';');
      break;
    end;
  end;

  //
  sDestPath := iSourcePath + 'SourceBall\' + sVersion + '\';
  CheckCreateDir_Cached(sDestPath);

  //
  sDPR.LoadFromFile(iSourcePath + iProjektName + '.dpr');
  for n := 0 to pred(sDPR.count) do
  begin
    if pos(' in ', sDPR[n]) > 0 then
    begin
      sSourceFName := ExtractSegmentBetween(sDPR[n], '''', '''');
      repeat
        if pos('..', sSourceFName) = 1 then
        begin
          sFullSourceFname := iSourcePath + sSourceFName;
          break;
        end;
        if pos(':', sSourceFName) > 0 then
        begin
          sFullSourceFname := sSourceFName;
          break;
        end;
        sFullSourceFname := iSourcePath + sSourceFName;
      until yet;
      add(sFullSourceFname);

      sFullDFMFName := sFullSourceFname;
      ersetze('.pas', '.dfm', sFullDFMFName);
      if pos(' {', sDPR[n]) > 0 then
        if FileExists(sFullDFMFName) then
          add(sFullDFMFName);

    end;
  end;
  sDPR.free;
  result := true;
end;

function TFormAutoUp.AddFile(s,d : String):boolean;
var
  CopyNeeded: boolean;
begin
  if FileExists(s) then
  begin
    CheckCreateDir_Cached(ExtractFilePath(d));
    CopyNeeded := true;
    repeat
      if not(FileExists(d)) then
        break;
      if (FSize(s)<>FSize(d)) then
        break;
      if (FileAge(s)<>FileAge(d)) then
        break;
      CopyNeeded := false;
    until yet;
    if CopyNeeded then
      if not(FileCopy(s, d)) then
        ShowMessage('2297:'+#13+d+#13 + ' konnte nicht angelegt werden!');
  end else
  begin
    ShowMessage('2300:'+#13+s+#13 + ' nicht gefunden!');
  end;
end;

function TFormAutoUp.AddDir(s,d:String):boolean;
var
  sDir: TStringList;
  n: Integer;
begin
  // Recursive Add of Files and Dirs
  CheckCreateDir_Cached(d);
  sDir := TStringList.Create;
  Dir(s+'.', sDir, false, false);
  for n := 0 to pred(sDir.Count) do
    AddDir(ExtractFilePath(s)+sDir[n]+'\*',ExtractFilePath(d)+sDir[n]+'\');
  Dir(s, sDir, false, true);
  for n := 0 to pred(sDir.Count) do
    AddFile(ExtractFilePath(s)+sDir[n],d+sDir[n]);
  sDir.Free;
end;

function TFormAutoUp.CheckCreateDir_Cached(d:String):boolean;

  procedure Work;
  begin
    rCheckCreateDirs.add(d);
    CheckCreateDir(d);
    result := DirExists(d);
  end;

begin
  // only check Existence of a SubDir once!
  if not(assigned(rCheckCreateDirs)) then
  begin
    rCheckCreateDirs := TStringList.Create;
    work;
  end else
  begin
    if (rCheckCreateDirs.indexof(d)=-1) then
      work
    else
      result := true;
  end;
end;

end.
