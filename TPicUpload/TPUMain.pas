// STANDALONE GLOBAL DEFINIERT IN PROJEKT->OPTIONEN->VERZEICHNISSE/BEDINGUNGEN
unit TPUMAIN;

interface

uses
  // Win32
  Windows, Messages, ShellApi,
  // Delphi
  SysUtils,
  Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls, CheckLst, ExtCtrls,
  ComCtrls, ShellCtrls, ActnList,
  Jpeg, Spin, Buttons,
  // JVCL
  JvSpecialProgress,
  // TPicUpload
  TSJpeg,
  // Indy
  IdIntercept, IdLogBase,
  IdLogEvent, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP,
  IdCoder, IdCoder3to4, IdCoderMIME,
  IdIOHandler, IdIOHandlerSocket,
  IdURI, IdException, IdExceptionCore, IdStack,
  ComObj, JvExControls, JvExStdCtrls, JvListBox, JvDriveCtrls, JvCombobox,
  JvBaseDlg, JvBrowseFolder, Mask, JvExMask, JvToolEdit,
  FileCtrl, IdIOHandlerStack, IdSSL, IdSSLOpenSSL;

type
  TFormTPMain = class(TForm)
    IdHTTP1: TIdHTTP;
    IdLogEvent1: TIdLogEvent;
    SpeedButton6: TSpeedButton;
    SpeedButton9: TSpeedButton;
    PageControl1: TPageControl;
    Step1: TTabSheet;
    Panel1: TPanel;
    Label2: TLabel;
    EditPath: TEdit;
    Step2: TTabSheet;
    Panel2: TPanel;
    Wait: TLabel;
    Bevel1: TBevel;
    Label3: TLabel;
    Label1: TLabel;
    ImageViewer: TImage;
    Label6: TLabel;
    Label5: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    DisplayWidth: TLabel;
    DisplayHeight: TLabel;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    DisplayFileName: TLabel;
    Label14: TLabel;
    ProgressBar: TJvSpecialProgress;
    ShortEdge: TCheckBox;
    FileCheckList: TCheckListBox;
    SpinEditMaxWidth: TSpinEdit;
    CheckAutoPre: TCheckBox;
    Comment: TMemo;
    Step3: TTabSheet;
    StartButton: TButton;
    RevInfo: TLabel;
    SpeedButton8: TSpeedButton;
    HelpButton: TSpeedButton;
    FullScreenButton: TSpeedButton;
    Bevel2: TBevel;
    DisplayCountSelected: TLabel;
    FolderTree: TJvDirectoryListBox;
    JvDriveCombo1: TJvDriveCombo;
    Panel3: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label15: TLabel;
    SpeedButton7: TSpeedButton;
    Label19: TLabel;
    ConnectButton: TSpeedButton;
    StatusBox: TMemo;
    EditUser: TEdit;
    EditPass: TEdit;
    SiteSelect: TComboBox;
    FolderPanel: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    FolderNameCharsLeft: TLabel;
    FolderCount: TLabel;
    FolderSelect: TComboBox;
    NewFolder: TEdit;
    NewFolderDescription: TMemo;
    UploadButton: TButton;
    DeleteResizedPhotosAfterUpload: TCheckBox;
    SSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
    procedure FileCheckListDblClick(Sender: TObject);
    procedure ImageViewerProgress(Sender: TObject; Stage: TProgressStage;
      PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure FileCheckListClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure CommentEnter(Sender: TObject);
    procedure CommentExit(Sender: TObject);
    procedure CheckAutoPreClick(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure FolderSelectChange(Sender: TObject);
    procedure NewFolderChange(Sender: TObject);
    procedure EditUserChange(Sender: TObject);
    procedure EditPassChange(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure UploadButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure SiteSelectChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FullScreenButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FolderTreeChange(Sender: TObject);

  private

    { Private-Deklarationen }
    Site: string;
    PHPScript: string;
    LastClicked: integer;
    NextSite: integer;
    MaxThumbWidth: integer;
    ThumbResizeShortEdge: Boolean;
    MaxOriginalWidth: integer;
    OriginalResizeShortEdge: Boolean;
    MaxFolderNameLength: integer;
    FolderID: string;
    UpLoadInfo: Boolean;
    UnAttendedMode: Boolean; //
    LogS: TStringList;
    Online: Boolean;
    UploadData: TStringList;
    Statistik_KorrupteDateien: integer;
    DeleteOriginalPhotosAfterUpload: Boolean;
    CountSelected: integer;

    procedure ersetze(const find_str, ersetze_str: string; var d: string);
    function delete_dir(dir: string): Boolean;
    function AddFile(FileName: string; State: TCheckBoxState): integer;
    function LoadFiles: integer;
    procedure MoveFile(p: integer);
    procedure Preview;
    procedure AssignComment;
    procedure CommentView;
    procedure ItemClicked(pre: Boolean);
    procedure InvertSelection;
    procedure Selection(State: TCheckBoxState);
    function GetResizedPath(width: integer; ShortEdge: Boolean)
      : string; overload;
    function GetResizedPath(width: integer; ShortEdge: Boolean;
      TrailingSlash: Boolean): string; overload;
    procedure ResizePhotos(width: integer; ShortEdge: Boolean);
    procedure DeleteResizedPhotos;
    function Upload: Boolean;
    function GetSelectedFolderID: string;
    function GetUploadInfo: Boolean;
    function UploadFile(index: integer): Boolean;
    function CreateNewFolder: Boolean;
    function SendUploadFinished: Boolean;
    function CheckStep2: Boolean;
    procedure CheckStep3;
    procedure CheckUpload;
    procedure CheckPath;
    function AtLeastOneChecked: Boolean;
    procedure ClearFileCheckList;
    procedure UpdateFolderNameCharsLeft;
    procedure ClearLog;
    procedure Log(s: string = ''); overload;
    procedure Log(s: TStringList); overload;
    procedure BackupUploadData;
    procedure SaveUploadData;
    procedure DeleteUploadData;
    procedure RestoreUploadData;
    procedure OpenFullScreen;

{$IFDEF STANDALONE}
    procedure PathByCLI;
{$ENDIF}
  public

    { Public-Deklarationen }

    WorkingDir: string;
    CancelUpload: Boolean;
    procedure ReadIniValues;
    procedure WriteIniValues;

    function getFolder(Site, user, pwd: string): TStringList;
    // werde ich nicht verwenden, nur der Vollständigkeit halber!
    function doTPicUpload(Site, user, pwd, FileName, folder: string;
      Comment, ErrorDetail: TStringList): Boolean; // true=fehlerlos

    function CheckOnline: Boolean;
    procedure MarkAsBadFile(index: integer);
  end;

const
  REV: string = '1.043';
  DefaultPHPScript: string = 'tpicupload.php';
  CARGOBAY: string = 'https://cargobay.orgamon.org/';
  REV_HTML: string = 'TPicUploadRev.html';
  INFO_HTML: string = 'TPicUpload_Info.html';
  cUPLOADDATAFileName: string = 'upload_data.txt';
  cCORRUPTFolderName: string = 'corrupt-jpgs'; // ohne abschließenden Slash

var
  FormTPMain: TFormTPMain;

implementation

uses
  TPUIni, MsMultiPartFormData, TPUUploadProgress
{$IFDEF STANDALONE}
    , TPUPreview, TPUSplash
{$ELSE}
    , anfix32, globals
{$ENDIF}
    ;
{$R *.dfm}

procedure TFormTPMain.ersetze(const find_str, ersetze_str: string;
  var d: string);
{ bug: 28.07.92 ersetze('x','ax','x') funktioniert jetzt }
{ weiterhin ein Problem: d kann gr”áer werden! }
var
  i: integer;
  l: integer;
  WorkStr: string;
begin
  if (find_str = ersetze_str) then
    exit;
  WorkStr := d;
  d := '';
  l := length(find_str);
  i := pos(find_str, WorkStr);
  while (i > 0) do
  begin
    d := d + copy(WorkStr, 1, pred(i)) + ersetze_str;
    WorkStr := copy(WorkStr, i + l, MaxInt);
    i := pos(find_str, WorkStr);
  end;
  d := d + WorkStr;
end;

function TFormTPMain.delete_dir(dir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc := FO_DELETE;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
    pFrom := PChar(dir + #0);
  end;
  Result := (0 = ShFileOperation(fos));
end;

procedure TFormTPMain.FolderTreeChange(Sender: TObject);
begin
  // FolderTree.OpenCurrent;
  EditPath.Text := FolderTree.Directory;
  CheckPath;
  FileCheckList.Enabled := True;
  CheckStep2;
end;

procedure TFormTPMain.CheckPath;
begin
  with EditPath do
  begin
    if Text[length(Text)] <> '\' then
      Text := Text + '\';
  end;
end;

function TFormTPMain.AddFile(FileName: string; State: TCheckBoxState): integer;
begin
  Result := FileCheckList.Items.Add(FileName);
  FileCheckList.State[Result] := State;
  FileCheckList.ItemIndex := 0;
end;

function TFormTPMain.LoadFiles: integer;
var
  SearchRec: TSearchRec;
  code: integer;
  FileName: string;
  Files: string;
begin
  Result := 0;

  FileCheckList.Clear;

  Files := EditPath.Text + '*.jpg';

  code := FindFirst(Files, faAnyFile, SearchRec);
  while code = 0 do
  begin
    inc(Result);
    FileName := SearchRec.Name;
    AddFile(FileName, cbUnChecked);
    code := FindNext(SearchRec);
  end;
  // ShowMessage(filename);
  FindClose(SearchRec);
  if (Result > 0) then
    FileCheckList.ItemIndex := 0;
end;

procedure TFormTPMain.FileCheckListDblClick(Sender: TObject);
begin
  // if (CheckAutoPre.State <> cbChecked) then
  // begin
  // LastClicked := -1;
  // ItemClicked(true);
  // end;
  OpenFullScreen;
end;

function TFormTPMain.GetResizedPath(width: integer; ShortEdge: Boolean): string;
begin
  Result := GetResizedPath(width, ShortEdge, True);
end;

function TFormTPMain.GetResizedPath(width: integer; ShortEdge: Boolean;
  TrailingSlash: Boolean): string;
var
  prefix, postfix: string;
  slash: string;
begin
  prefix := '';
  postfix := '';
  slash := '\';
  if ShortEdge then
    postfix := 's';
  if not TrailingSlash then
    slash := '';
  Result := EditPath.Text + prefix + IntToStr(width) + postfix + slash;
end;

procedure TFormTPMain.ResizePhotos(width: integer; ShortEdge: Boolean);
var
  i, c: integer;
  // n: integer;  n ersetzt durch globale Variable CountSelected Rev 1.042
  FileName: string;
  ResizedPath: string;
begin
  ResizedPath := GetResizedPath(width, ShortEdge);
  if (not SysUtils.DirectoryExists(ResizedPath)) then
    mkdir(ResizedPath);
  Screen.Cursor := crHourGlass;
  ProgressBar.Position := 0;
  if PageControl1.ActivePageIndex = 1 then
    ProgressBar.Show;
  // n := 0;
  c := 0;
  // for i := 0 to pred(FileCheckList.Items.Count) do
  // if FileCheckList.State[i] = cbChecked then
  // inc(n);
  for i := 0 to pred(FileCheckList.Items.Count) do
  begin
    if CancelUpload then
      break;
    if (FileCheckList.State[i] = cbChecked) then
    begin
      inc(c);
      FileName := FileCheckList.Items.Strings[i];
      if PageControl1.ActivePageIndex = 1 then
      begin
        ProgressBar.Caption := FileName;
        ProgressBar.Position := round(c / CountSelected * 100);
        Application.ProcessMessages;
      end;
      if PageControl1.ActivePageIndex = 2 then
      begin
        Log('resampling ' + FileName + ' to ' + IntToStr(width) + 'px');
        UploadProgressForm.incPosition;
        // ShowMessage(inttostr(ProgressBar2.Position));
        Application.ProcessMessages;
      end;
      case ResizeImage(EditPath.Text, ResizedPath, FileName, width,
        ShortEdge) of
        0:
          ; // verkleinerte Version existierte schon (es wurde nichts erzeugt)
        1:
          ; // Verkleinerung erfolgreich
        -1:
          MarkAsBadFile(i); // Datei konnte nicht geladen werden
      end;

      if PageControl1.ActivePageIndex = 2 then
      begin
        Log('...done');
        Application.ProcessMessages;
      end;
    end;
  end;
  if CountSelected = 0 then // ((CountSelected = 0) or (c = 0))
  begin
    if UnAttendedMode then
      Log('ERROR: Keine Bilder ausgewählt!')
    else
      ShowMessage('Keine Bilder ausgewählt.');
    FileCheckList.Enabled := True;
    FileCheckList.Refresh;
  end;
  ProgressBar.Hide;
  Screen.Cursor := crDefault;
end;

procedure TFormTPMain.DeleteResizedPhotos;
begin
  if not(delete_dir(GetResizedPath(MaxThumbWidth, ThumbResizeShortEdge, false))
    and delete_dir(GetResizedPath(MaxOriginalWidth, OriginalResizeShortEdge,
    false))) then
  begin
    ShowMessage('Dateien konnten nicht gelöscht werden!');
  end;
end;

procedure TFormTPMain.ImageViewerProgress(Sender: TObject;
  Stage: TProgressStage; PercentDone: Byte; RedrawNow: Boolean; const R: TRect;
  const Msg: string);
begin
  case Stage of
    psStarting:
      begin
        Application.ProcessMessages;
        Screen.Cursor := crHourGlass;
        Wait.Caption := 'Bitte warten...';
        Wait.Refresh;
        FileCheckList.Enabled := false;
      end;
    psEnding:
      begin
        Application.ProcessMessages;
        Screen.Cursor := crDefault;
        Wait.Caption := '';
        Wait.Refresh;
        FileCheckList.Enabled := True;
      end;
  end;
end;

procedure TFormTPMain.SpeedButton1Click(Sender: TObject);
begin
  MoveFile(-1);
end;

procedure TFormTPMain.MoveFile(p: integer);
var
  item: string;
  itemstate: TCheckBoxState;
  _Enabled: Boolean;
  max, min: integer;
  Comment: TStringList;
begin
  if FileCheckList.ItemEnabled[FileCheckList.ItemIndex] then
    with FileCheckList do
    begin
      min := 0;
      max := pred(Items.Count);
      if ((ItemIndex + p >= min) and (ItemIndex + p <= max)) then
      begin
        item := Items.Strings[ItemIndex + p];
        itemstate := State[ItemIndex + p];
        // FileChecklist.Enabled existiert, deshalb Variable mit Unterstrich
        _Enabled := ItemEnabled[ItemIndex + p];
        Comment := (Items.Objects[ItemIndex + p] as TStringList);

        Items.Strings[ItemIndex + p] := Items.Strings[ItemIndex];
        State[ItemIndex + p] := State[ItemIndex];
        ItemEnabled[ItemIndex + p] := ItemEnabled[ItemIndex];
        Items.Objects[ItemIndex + p] := Items.Objects[ItemIndex];

        Items.Strings[ItemIndex] := item;
        State[ItemIndex] := itemstate;
        ItemEnabled[ItemIndex] := _Enabled;
        Items.Objects[ItemIndex] := Comment;

        ItemIndex := ItemIndex + p;
        LastClicked := ItemIndex;

      end;
    end;
end;

procedure TFormTPMain.SpeedButton2Click(Sender: TObject);
begin
  MoveFile(1);
end;

procedure TFormTPMain.SpeedButton3Click(Sender: TObject);
begin
  InvertSelection;
end;

procedure TFormTPMain.InvertSelection;
var
  i: integer;
begin
  with FileCheckList do
  begin
    for i := 0 to pred(Items.Count) do
    begin
      if ItemEnabled[i] then
      begin
        case (State[i]) of
          cbChecked:
            State[i] := cbUnChecked;
          cbUnChecked:
            State[i] := cbChecked;
        end;
      end;
    end;
  end;
  CheckStep3;
end;

procedure TFormTPMain.SpeedButton4Click(Sender: TObject);
begin
  Selection(cbChecked);
end;

procedure TFormTPMain.SpeedButton5Click(Sender: TObject);
begin
  Selection(cbUnChecked);
end;

procedure TFormTPMain.Selection(State: TCheckBoxState);
var
  i: integer;
begin
  for i := 0 to pred(FileCheckList.Items.Count) do
    if FileCheckList.ItemEnabled[i] then
      FileCheckList.State[i] := State;
  CheckStep3;
end;

procedure TFormTPMain.Preview;
var
  FileName: string;
  i: integer;
begin
  i := FileCheckList.ItemIndex;
  FileName := FileCheckList.Items.Strings[i];
  try
    if FileCheckList.ItemEnabled[i] then
      ImageViewer.Picture.LoadFromFile(EditPath.Text + FileName);
  except
    MarkAsBadFile(i);
  end;

  DisplayFileName.Caption := FileName;
  DisplayWidth.Caption := IntToStr(ImageViewer.Picture.width) + 'x' +
    IntToStr(ImageViewer.Picture.Height);
  DisplayHeight.Caption := IntToStr(ImageViewer.Picture.Height);
end;

procedure TFormTPMain.CommentView;
var
  Comments: TStringList;
  i: integer;
begin
  i := FileCheckList.ItemIndex;
  Comments := (FileCheckList.Items.Objects[i] as TStringList);
  if (Comments <> nil) then
    Comment.Lines.Assign(Comments)
  else
    Comment.Clear;
  Comment.SetFocus;
end;

procedure TFormTPMain.ItemClicked(pre: Boolean);
var
  clicked: integer;
begin
  clicked := FileCheckList.ItemIndex;
  if (LastClicked <> clicked) AND FileCheckList.ItemEnabled[clicked] then
  begin
    if (pre) then
      Preview;
  end;
  CommentView;
  LastClicked := clicked;
end;

procedure TFormTPMain.FileCheckListClick(Sender: TObject);
begin
  if (CheckAutoPre.State = cbChecked) then
    ItemClicked(True)
  else
    ItemClicked(false);
  FileCheckList.Hint := FileCheckList.Items.Strings[FileCheckList.ItemIndex];
  CheckStep3;
end;

procedure TFormTPMain.FormCreate(Sender: TObject);
begin
  RevInfo.Caption := 'Rev ' + REV;
  PHPScript := DefaultPHPScript;
  WorkingDir := ExtractFilePath(Application.ExeName);
  // ReadIniValues;
  PageControl1.ActivePageIndex := 0;
  LastClicked := -1;
  CountSelected := 0;
  CancelUpload := false;
  UploadData := TStringList.Create;
  // FullScreenButton.Caption := 'Auswahl'#13#10'in der'#13#10'Vollansicht';
  // FullScreenButton.Caption := '';
  // RestoreUploadData;
end;

procedure TFormTPMain.ReadIniValues;
var
  i: integer;
  www: string;
begin
  SpinEditMaxWidth.Value := INI.INIFile.ReadInteger('Format',
    'MaxWidthHeight', 640);
  DeleteResizedPhotosAfterUpload.Checked := INI.INIFile.ReadBool('Allgemein',
    'DeleteAfterUpload', false);
  DeleteOriginalPhotosAfterUpload := INI.INIFile.ReadBool('Allgemein',
    'DeleteOriginalsAfterUpload',
{$IFDEF STANDALONE}
    false
{$ELSE}
    True
{$ENDIF}
    );
  // EditUser.Text := INI.INIFile.ReadString('Login','User','');
  // EditPass.Text := INI.INIFile.ReadString('Login','Pass','');
  i := 1;
  SiteSelect.Clear;
  repeat
  begin
    www := INI.INIFile.ReadString('Sites', 'Site' + IntToStr(i), '');
    if (www <> '') then
    begin
      SiteSelect.Items.Add(www);
      SiteSelect.ItemIndex := 0;
      inc(i);
      NextSite := i;
    end;
  end
  until (www = '');
end;

procedure TFormTPMain.WriteIniValues;
begin
  INI.INIFile.WriteBool('Allgemein', 'DeleteAfterUpload',
    DeleteResizedPhotosAfterUpload.Checked);
  INI.INIFile.WriteInteger('Format', 'MaxWidthHeight', SpinEditMaxWidth.Value);
  INI.INIFile.UpdateFile;
end;

procedure TFormTPMain.SpeedButton9Click(Sender: TObject);
begin
  Close;
end;

procedure TFormTPMain.SpeedButton6Click(Sender: TObject);
begin
  INI.Show;
end;

procedure TFormTPMain.SpeedButton7Click(Sender: TObject);
begin
  ClearLog;
end;

procedure TFormTPMain.CommentEnter(Sender: TObject);
begin
  // Comment.SelectAll;
end;

procedure TFormTPMain.AssignComment;
var
  Comments: TStringList;
begin
  if Comment.Lines.Count > 0 then
  begin
    if (FileCheckList.ItemIndex < 0) then
      FileCheckList.ItemIndex := 0;
    FileCheckList.Items.Objects[FileCheckList.ItemIndex] := TStringList.Create;
    Comments := (FileCheckList.Items.Objects[FileCheckList.ItemIndex]
      as TStringList);
    Comments.Assign(Comment.Lines);
  end;
end;

procedure TFormTPMain.CommentExit(Sender: TObject);
begin
  AssignComment;
end;

procedure TFormTPMain.CheckAutoPreClick(Sender: TObject);
begin
  if (CheckAutoPre.State = cbChecked) then
  begin
    Preview;
    CommentView;
  end;
end;

procedure TFormTPMain.StartButtonClick(Sender: TObject);
begin
  // FileCheckList.Enabled := False;
  PageControl1.Enabled := false;
  FileCheckList.Refresh;
  ResizePhotos(SpinEditMaxWidth.Value, ShortEdge.Checked);
  PageControl1.Enabled := True;
end;

function TFormTPMain.GetUploadInfo: Boolean;
var
  ResponseStream: TStringStream;
  ResponseString: TStringList;
  FolderInfo: TStringList;
  i: integer;
  id: string;
begin
  Result := false;
  ResponseStream := TStringStream.Create('');
  ResponseString := TStringList.Create;
  Site := SiteSelect.Items.Strings[SiteSelect.ItemIndex];
  try
    ClearLog;
    Application.ProcessMessages;
    Log('get uploadinfo from ' + Site + '...');
    IdHTTP1.Get(Site + '/' + PHPScript, ResponseStream);
    ResponseStream.Seek(0, sofromBeginning);
    ResponseString.LoadFromStream(ResponseStream);
    // ShowMessage(ResponseString.Text);
    Log(ResponseString.Strings[0]);

    if ResponseString.Strings[0] = '999 REDIRECT' then
    begin
      PHPScript := ResponseString.Strings[1];
      Result := GetUploadInfo;
    end;

    if ResponseString.Strings[0] = '200 OK' then
    begin
      Result := True;
      MaxThumbWidth := StrToInt(ResponseString.Values['MaxThumbWidth']);
      if ResponseString.Values['ThumbResizeShortEdge'] = '' then
        ThumbResizeShortEdge := false
      else
        ThumbResizeShortEdge :=
          StrToBool(ResponseString.Values['ThumbResizeShortEdge']);
      MaxOriginalWidth := StrToInt(ResponseString.Values['MaxOriginalWidth']);
      if ResponseString.Values['OriginalResizeShortEdge'] = '' then
        OriginalResizeShortEdge := false
      else
        OriginalResizeShortEdge :=
          StrToBool(ResponseString.Values['OriginalResizeShortEdge']);
      if ResponseString.Values['MaxFolderNameLength'] = '' then
        MaxFolderNameLength := 0
      else
        MaxFolderNameLength :=
          StrToInt(ResponseString.Values['MaxFolderNameLength']);
      NewFolder.MaxLength := MaxFolderNameLength;
      UpdateFolderNameCharsLeft;
      Log('index-image-size: ' + ResponseString.Values['MaxThumbWidth'] + 'px');
      if ThumbResizeShortEdge then
        Log('index-image-edge: short');
      Log('original-image-size: ' + ResponseString.Values
        ['MaxOriginalWidth'] + 'px');
      if OriginalResizeShortEdge then
        Log('original-image-edge: short');
      FolderSelect.Clear;
      if (ResponseString.Values['Folders'] = 'yes') then
      begin
        FolderPanel.Visible := True;
        for i := ResponseString.IndexOfName('Folders') +
          1 to pred(ResponseString.Count) do
        begin
          id := ResponseString.Names[i];
          FolderInfo := TStringList.Create;
          FolderInfo.Add(id);
          FolderInfo.Add(ResponseString.Values[id]);
          // FolderInfo.Add(name);
          FolderSelect.Items.AddObject(ResponseString.Values[id], FolderInfo);
        end;
        FolderSelect.ItemIndex := 0;
        FolderCount.Caption := IntToStr(FolderSelect.Items.Count);
        FolderID := GetSelectedFolderID;
      end
      else
      begin
        FolderPanel.Visible := false;
        NewFolder.Text := '';
        FolderSelect.ItemIndex := -1;
        FolderID := '0';
      end;
    end;
  finally
    ResponseStream.Free;
    ResponseString.Free;
    IdHTTP1.Request.Clear;
  end;
end;

function TFormTPMain.CreateNewFolder: Boolean;
var
  RequestString: TStringList;
  ResponseStream: TStringStream;
  ResponseString: TStringList;
  // site: string;
begin
  Result := false;

  RequestString := TStringList.Create;
  ResponseStream := TStringStream.Create('');
  ResponseString := TStringList.Create;

  try
    Log('creating new folder...');
    RequestString.Add('user=' + EditUser.Text);
    RequestString.Add('pass=' + EditPass.Text);
    RequestString.Add('fid=' + FolderID);
    RequestString.Add('newfolder=' + NewFolder.Text);
    RequestString.Add('description=' + NewFolderDescription.Lines.Text);
    IdHTTP1.Post(Site + '/' + PHPScript, RequestString, ResponseStream);
    ResponseStream.Seek(0, sofromBeginning);
    ResponseString.LoadFromStream(ResponseStream);
    // ShowMessage(ResponseString.Text);
    // ResponseString.Delimiter := ';';
    Log(ResponseString.Strings[0]);
    if ResponseString.Strings[0] = '200 OK' then
    begin
      Result := True;
      Log(ResponseString.Strings[1]);
      FolderID := ResponseString.Values['FolderID'];
    end
    else
    begin
      if UnAttendedMode then
        Log('ERROR: ' + ResponseString.Strings[0])
      else
        ShowMessage(ResponseString.Strings[0]);
      // ShowMessage(ResponseString.CommaText);
    end;
    Log;
  finally
    RequestString.Free;
    ResponseStream.Free;
    ResponseString.Free;
    IdHTTP1.Request.Clear;
  end;
end;

function TFormTPMain.UploadFile(index: integer): Boolean;
var
  ResponseStream: TStringStream;
  MultiPartFormDataStream: TMsMultiPartFormDataStream;
  ResponseString: TStringList;
  // site: string;
  Comments: TStringList;
  description: string;
  FileName: string;
  thumb: string;
  original: string;

begin
  Result := false;
  MultiPartFormDataStream := TMsMultiPartFormDataStream.Create;
  ResponseStream := TStringStream.Create('');
  ResponseString := TStringList.Create;
  try
    FileName := FileCheckList.Items.Strings[index];
    thumb := GetResizedPath(MaxThumbWidth, ThumbResizeShortEdge) + FileName;
    original := GetResizedPath(MaxOriginalWidth, OriginalResizeShortEdge)
      + FileName;
    Comments := (FileCheckList.Items.Objects[index] as TStringList);
    if (Comments <> nil) then
      description := Comments.Text
    else
      description := '';
    ersetze(#13#10, '', description);
    Log('uploading ' + FileName + '...');
    if (description <> '') then
      Log('with description: ' + description);
    Application.ProcessMessages;
    IdHTTP1.Request.ContentType := MultiPartFormDataStream.RequestContentType;
    // IdHttp1.Request.ContentType := 'image/jpeg';

    MultiPartFormDataStream.AddFormField('fid', FolderID);
    MultiPartFormDataStream.AddFormField('filename', FileName);
    MultiPartFormDataStream.AddFormField('description', description);
    MultiPartFormDataStream.AddFormField('user', EditUser.Text);
    MultiPartFormDataStream.AddFormField('pass', EditPass.Text);

    MultiPartFormDataStream.AddFile('original', original, 'image/jpeg');
    MultiPartFormDataStream.AddFile('thumb', thumb, 'image/jpeg');

    { You must make sure you call this method *before* sending the stream }
    MultiPartFormDataStream.PrepareStreamForDispatch;
    // MultiPartFormDataStream.Position := 0;
    // ResponseString.LoadFromStream(MultiPartFormDataStream);
    // ShowMessage(ResponseString.GetText);
    // MultiPartFormDataStream.Position := 0;
    IdHTTP1.Post(Site + '/' + PHPScript, MultiPartFormDataStream,
      ResponseStream);
    ResponseStream.Seek(0, sofromBeginning);
    ResponseString.LoadFromStream(ResponseStream);
    // ShowMessage(ResponseString.Text);
    Log(ResponseString);
    if ResponseString.Strings[0] = '200 OK' then
    begin
      Result := True;
    end
    else
    begin
      if UnAttendedMode then
        Log('ERROR: ' + ResponseString.Strings[0])
      else
        ShowMessage(ResponseString.Strings[0]);
    end;
  finally
    MultiPartFormDataStream.Free;
    ResponseString.Free;
    ResponseStream.Free;
    IdHTTP1.Request.Clear;
    // Comments.Free;
  end;
end;

function TFormTPMain.SendUploadFinished: Boolean;
var
  RequestString: TStringList;
  ResponseStream: TStringStream;
  ResponseString: TStringList;
begin
  Result := false;

  RequestString := TStringList.Create;
  ResponseStream := TStringStream.Create('');
  ResponseString := TStringList.Create;
  try
    RequestString.Add('user=' + EditUser.Text);
    RequestString.Add('pass=' + EditPass.Text);
    RequestString.Add('finished=true');
    IdHTTP1.Post(Site + '/' + PHPScript, RequestString, ResponseStream);
    ResponseStream.Seek(0, sofromBeginning);
    ResponseString.LoadFromStream(ResponseStream);
    if ResponseString.Count > 0 then
    begin
      Result := True;
      Log(ResponseString.Text);
    end
  finally
    RequestString.Free;
    ResponseStream.Free;
    ResponseString.Free;
    IdHTTP1.Request.Clear;
  end;
end;

function TFormTPMain.Upload: Boolean;
var
  ok: Boolean;
  Upload: Boolean;
  i: integer;
  c: integer;
  index: integer;
  FileName: string;
  FullSourceFName: string;
  FullDestFname: string;
  ErrorMsgStr: string;
begin
  // SiteSelect.ItemIndex := SiteSelect.Items.IndexOf(Site);
  ok := false;
  Statistik_KorrupteDateien := 0;
  FileName := '';
  BackupUploadData;

  Screen.Cursor := crHourGlass;

  // Fortschrittsanzeige
  UploadProgressForm.ProgressBar.Position := 0;
  UploadProgressForm.ProgressBar.Maximum := 3 * CountSelected;
  UploadProgressForm.Show;
  Enabled := false;
  UploadProgressForm.SetFocus;
  // Ende Fortschrittsanzeige

  repeat
    Log;
    Log('--- resampling ---');
    ResizePhotos(MaxThumbWidth, ThumbResizeShortEdge);

    if CancelUpload then
      break;

    ResizePhotos(MaxOriginalWidth, OriginalResizeShortEdge);

    if CancelUpload then
      break;

    Log;
    Log('--- upload ---');
    Application.ProcessMessages;
    if (NewFolder.Text <> '') then
    begin
      ok := CreateNewFolder;
      UploadData.Values['FOLDERID'] := FolderID;
    end
    else
      ok := True;

    if ok then
    begin
      UploadData.Delete(UploadData.IndexOfName('FOLDER'));
      UploadData.Delete(UploadData.IndexOfName('DESCRIPTION'));
    end;
    SaveUploadData;

    if CancelUpload then
      break;

    if ok then
    begin
      c := 0;
      for i := 0 to pred(FileCheckList.Items.Count) do
      begin
        if CancelUpload then
          break;
        if FileCheckList.State[i] = cbChecked then
        begin
          inc(c);
          Upload := UploadFile(i);
          // ShowMessage(inttostr(i));
          if Upload then
          begin
            index := UploadData.IndexOfName('PICTURE' + IntToStr(c));
            UploadData.Strings[index] := '#' + UploadData.Strings[index];
            SaveUploadData;
{$IFNDEF STANDALONE}
            FileName := FileCheckList.Items.Strings[i];
            if DeleteOriginalPhotosAfterUpload then
              if SysUtils.DeleteFile(EditPath.Text + FileName) then
                Log(FileName + ' deleted.');
{$ENDIF}
            Log; // Leerzeile;
          end;
          ok := (ok and Upload);
          if not ok then
            break
          else
            UploadProgressForm.incPosition;
        end;
      end;
    end;

    if CancelUpload then
      break;

    Log(#13#10 + '--- thats it ---');
    if ok then
    begin
      DeleteUploadData;
      if DeleteResizedPhotosAfterUpload.Checked then
        DeleteResizedPhotos;
      SendUploadFinished;
      EditPass.Clear;
    end;

    if CancelUpload then
      break;

    if (ok AND (Statistik_KorrupteDateien > 0)) then
    begin

      ErrorMsgStr := 'ERROR: Es gab ' + IntToStr(Statistik_KorrupteDateien) +
        ' korrupte Datei(en)!';

      if UnAttendedMode then
        Log(ErrorMsgStr)
      else
        ShowMessage(ErrorMsgStr);

{$IFNDEF STANDALONE}
      repeat

        // Verzeichnis sicherstellen
        if not DirectoryExists(EditPath.Text + cCORRUPTFolderName) then
          if not CreateDir(EditPath.Text + cCORRUPTFolderName) then
          begin
            Log('ERROR: Ordner für korrupte Dateien konnte nicht erstellt werden!');
            break;
          end;

        // Bilder kopieren bzw. verschieben!
        for i := 0 to pred(FileCheckList.Items.Count) do
          if ((not FileCheckList.ItemEnabled[i]) and
            (FileCheckList.State[i] = cbUnChecked)) then
          begin
            // als fehlerhaft markierte Datei
            FileName := FileCheckList.Items.Strings[i];
            FullSourceFName := EditPath.Text + FileName;
            FullDestFname := EditPath.Text + cCORRUPTFolderName + '\' +
              FileName;
            if DeleteOriginalPhotosAfterUpload then
            begin
              // Verschieben
              if FileMove(
                { } FullSourceFName,
                { } FullDestFname) then
                Log(FileName + ' moved.')
              else
                Log(
                  { } 'ERROR: Datei "' +
                  { } FullSourceFName + '" konnte nicht nach  "' +
                  { } FullDestFname +
                  { } '" verschoben werden!');
            end
            else
            begin
              // Kopieren
              if FileCopy(
                { } FullSourceFName,
                { } FullDestFname) then
                Log(FileName + ' copied.')
              else
                Log(
                  { } 'ERROR: Datei "' +
                  { } FullSourceFName + '" konnte nicht nach  "' +
                  { } FullDestFname +
                  { } '" kopiert werden!');

            end;
          end;

      until True;
{$ENDIF}
    end;
  until True;

  // Fortschrittsanzeige
  UploadProgressForm.Hide;
  Enabled := True;
  SetFocus;
  // Fortschrittsanzeige

  if CancelUpload then
    Log('upload canceled by user!');
  CancelUpload := false;

  Screen.Cursor := crDefault;

  Result := ok;
  // Rückgabewert wir bisher (Rev 1.042) nur von DoTPicUpload ausgewertet
end;

procedure TFormTPMain.ConnectButtonClick(Sender: TObject);
begin
  PHPScript := DefaultPHPScript;
  UpLoadInfo := GetUploadInfo;
  CheckUpload;
end;

function TFormTPMain.GetSelectedFolderID: string;
var
  FolderInfo: TStringList;
begin
  FolderInfo := (FolderSelect.Items.Objects[FolderSelect.ItemIndex]
    as TStringList);
  Result := FolderInfo.Strings[0];
end;

procedure TFormTPMain.FolderSelectChange(Sender: TObject);
begin
  FolderSelect.Hint := FolderSelect.Items.Strings[FolderSelect.ItemIndex];
  FolderID := GetSelectedFolderID;
  NewFolder.Text := '';
  CheckUpload;
end;

procedure TFormTPMain.CheckUpload;
begin
  if ((EditUser.Text <> '') and (EditPass.Text <> '') and UpLoadInfo and
    ((FolderSelect.ItemIndex <> -1) or (FolderPanel.Visible = false))) then
    UploadButton.Enabled := True
  else
    UploadButton.Enabled := false;
end;

procedure TFormTPMain.NewFolderChange(Sender: TObject);
begin
  if NewFolder.Text <> '' then
  begin
    Label18.Enabled := True;
    NewFolderDescription.Enabled := True;
  end
  else
  begin
    Label18.Enabled := false;
    NewFolderDescription.Enabled := false;
  end;
  UpdateFolderNameCharsLeft;
end;

procedure TFormTPMain.EditUserChange(Sender: TObject);
begin
  CheckUpload;
end;

procedure TFormTPMain.EditPassChange(Sender: TObject);
begin
  CheckUpload;
end;

procedure TFormTPMain.PageControl1Change(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
{$IFDEF STANDALONE}
    0:
      begin
        if not SplashScreen.UpdateStateKnown then
          SpeedButton8.Show;
      end;
{$ENDIF}
    1:
      begin
        Preview;
        CommentView;
{$IFDEF STANDALONE}
        SpeedButton8.Hide;
{$ENDIF}
      end;
    2:
      begin
        AssignComment;
        CheckUpload;
{$IFDEF STANDALONE}
        SpeedButton8.Hide;
{$ENDIF}
      end;
  end;
end;

function TFormTPMain.CheckStep2: Boolean;
begin
  if LoadFiles > 0 then
    Step2.TabVisible := True
  else
    Step2.TabVisible := false;
  Result := Step2.TabVisible;
  CheckStep3;
end;

function TFormTPMain.AtLeastOneChecked: Boolean;
var
  i: integer;
begin
  Result := false;
  CountSelected := 0;
  for i := 0 to pred(FileCheckList.Items.Count) do
  begin
    if FileCheckList.State[i] = cbChecked then
    begin
      Result := True;
      inc(CountSelected);
    end;
    // if Result then break;
  end;
  DisplayCountSelected.Caption := IntToStr(CountSelected);
end;

procedure TFormTPMain.CheckStep3;
begin
  if AtLeastOneChecked then
  begin
    Step3.TabVisible := True;
    StartButton.Enabled := True;
  end
  else
  begin
    Step3.TabVisible := false;
    StartButton.Enabled := false;
  end;
end;

procedure TFormTPMain.UploadButtonClick(Sender: TObject);
begin
  PageControl1.Enabled := false;
  Upload;
  PageControl1.Enabled := True;
end;

function TFormTPMain.doTPicUpload(Site, user, pwd, FileName, folder: string;
  Comment, ErrorDetail: TStringList): Boolean;
begin
  Result := false;
  LogS := ErrorDetail;
  try

    // visueller Debug Modus ?
    if assigned(ErrorDetail) then
      if (ErrorDetail.Count > 0) then
      begin
        // debug Optionen
        if (ErrorDetail.indexof('show') <> -1) then
          Show;
        if (ErrorDetail.indexof('unattended') <> -1) then
          UnAttendedMode := True;
      end;

    // Belegung der Controls
    EditPath.Text := ExtractFilePath(FileName);
    SiteSelect.Text := Site;
    EditUser.Text := user;
    EditPass.Text := pwd;

    ClearFileCheckList;
    FileCheckList.Items.Add(ExtractFileName(FileName));
    FileCheckList.Items.Objects[0] := TStringList.Create;
    FileCheckList.State[0] := cbChecked;
    with FileCheckList.Items.Objects[0] as TStringList do
      addstrings(Comment);
    AtLeastOneChecked; // TS 30.03.2011: Einführung von CountSelected Rev 1.042

    repeat

      // Überhaupt etwas machen`?
      if assigned(ErrorDetail) then
        if ErrorDetail.Count > 0 then
        begin
          if ErrorDetail.indexof('nowork') <> -1 then
            break;
        end;

      // Verbinden klicken!
      ConnectButtonClick(self);

      if not(UploadButton.Enabled) then
        break;

      // Upload klicken!
      Result := Upload;
    until True;

  except
  end;
  UnAttendedMode := false;
  LogS := nil;
end;

function TFormTPMain.getFolder(Site, user, pwd: string): TStringList;
begin
  Result := TStringList.Create;
end;

procedure TFormTPMain.ClearFileCheckList;
var
  n: integer;
begin
  with FileCheckList do
  begin
    for n := 0 to pred(Items.Count) do
      if assigned(Items.Objects[n]) then
        TStringList(Items.Objects[n]).Free;
    Items.Clear;
  end;
end;

procedure TFormTPMain.ClearLog;
begin
  StatusBox.Clear;
  if assigned(LogS) then
    LogS.Clear;
end;

procedure TFormTPMain.Log(s: string);
begin
  StatusBox.Lines.Add(s);
  if assigned(LogS) then
    LogS.Add(s);
end;

procedure TFormTPMain.Log(s: TStringList);
var
  n: integer;
begin
  for n := 0 to pred(s.Count) do
    Log(s[n]);
end;

procedure TFormTPMain.UpdateFolderNameCharsLeft;
begin
  if MaxFolderNameLength <> 0 then
    FolderNameCharsLeft.Caption :=
      IntToStr(MaxFolderNameLength - integer(strlen(PChar(NewFolder.Text))))
  else
    FolderNameCharsLeft.Caption := '';
end;

function TFormTPMain.CheckOnline: Boolean;
var
  url: string;
begin
  Result := True;
  url := CARGOBAY + REV_HTML;
  try
    // IdHTTP1.Head('http://www.foddoos.de/nase.html');
    IdHTTP1.Head(url);
    // ShowMessage(IntToStr(IdHTTP1.Response.ContentLength));
  except
    on EIdSocketError do
    begin
      Result := false;
      // ShowMessage('Keine Internetverbindung');
    end;
    on EIdReadTimeout do
    begin
      Result := True;
      // ShowMessage('TimeOut: Kann Resource nicht finden: ' + url);
    end;
    on EIdHTTPProtocolException do
    begin
      Result := True;
      // ShowMessage('Fehler: Kann Resource nicht finden: ' + url);
    end;
  end;
  Online := Result;
end;

procedure TFormTPMain.FormActivate(Sender: TObject);
begin
{$IFDEF STANDALONE}
  if not SplashScreen.UpdateStateKnown then
    SpeedButton8.Show;
{$ENDIF}
  if fileexists(WorkingDir + INFO_HTML) then
    HelpButton.Show;

{$IFNDEF STANDALONE}
  if (EditPath.Text = '') then
  begin
    FolderTree.Directory := iTPicUpload;
    FolderTreeChange(Sender);
  end;
{$ENDIF}
  PageControl1Change(self);
  CheckStep3;
end;

procedure TFormTPMain.SpeedButton8Click(Sender: TObject);
begin
{$IFDEF STANDALONE}
  SplashScreen.Show;
  if SplashScreen.UpdateStateKnown then
    SpeedButton8.Hide;
{$ENDIF}
end;

procedure TFormTPMain.HelpButtonClick(Sender: TObject);
begin
  ShellExecute(Handle, PChar('open'), PChar(INFO_HTML), PChar(''),
    PChar(ExtractFilePath(Application.ExeName)), SW_SHOW);
end;

procedure TFormTPMain.SiteSelectChange(Sender: TObject);
begin
  if SiteSelect.ItemIndex <> SiteSelect.Items.indexof(Site) then
    UpLoadInfo := false
  else
    UpLoadInfo := True;
  CheckUpload;
end;

procedure TFormTPMain.BackupUploadData;
var
  i: integer;
  c: integer;
  Comments: TStringList;
  description: string;
begin
  UploadData.Clear;
  UploadData.Append('USER=' + EditUser.Text);
  UploadData.Append('PATH=' + EditPath.Text);
  UploadData.Append('SITEINDEX=' + IntToStr(SiteSelect.ItemIndex));
  UploadData.Append('FOLDERID=' + FolderID);
  UploadData.Append('FOLDER=' + NewFolder.Text);
  UploadData.Append('DESCRIPTION=' + NewFolderDescription.Lines.Text);
  c := 0;
  for i := 0 to pred(FileCheckList.Items.Count) do
  begin
    if FileCheckList.State[i] = cbChecked then
    begin
      inc(c);
      UploadData.Append('PICTURE' + IntToStr(c) + '=' +
        FileCheckList.Items.Strings[i]);
      Comments := (FileCheckList.Items.Objects[i] as TStringList);
      if (Comments <> nil) then
      begin
        description := Comments.Text;
        ersetze(#13#10, ' ', description);
        UploadData.Append('PICTURE' + IntToStr(c) + 'DESCRIPTION=' +
          description);
      end;
    end;
  end;
  SaveUploadData;
end;

procedure TFormTPMain.SaveUploadData;
begin
  // ShowMessage(WorkingDir+cUPLOADDATAFileName);
  UploadData.SaveToFile(WorkingDir + cUPLOADDATAFileName);
end;

procedure TFormTPMain.DeleteUploadData;
begin
  DeleteFile(WorkingDir + cUPLOADDATAFileName);
end;

procedure TFormTPMain.RestoreUploadData;
var
  i: integer;
  FolderInfo: TStringList;
  Comments: TStringList;
  index: integer;
  Picture: string;
  description: string;
begin
  if fileexists(WorkingDir + cUPLOADDATAFileName) then
  begin
    if MessageDlg
      ('Der letzte Upload wurde nicht abgeschlossen. Klicken Sie auf Ok, um den letzten Upload fertigzustellen. Klicken Sie auf Abbrechen, wenn Sie eine neue Sitzung starten möchten.',
      mtCustom, [mbOk, mbCancel], 0) = mrOk then
    begin
      // ShowMessage('RestoreUploadData');
      UploadData.Clear;
      // Upload-Daten in Stringliste laden
      UploadData.LoadFromFile(WorkingDir + cUPLOADDATAFileName);
      // Restore User
      EditUser.Text := UploadData.Values['USER'];
      // Restore lokaler Pfad zu den Photos
      EditPath.Text := UploadData.Values['PATH'];
      CheckStep2;
      // Restore Photos inkl. Beschreibungen
      FileCheckList.Clear;
      i := 1;
      repeat
      begin
        Picture := UploadData.Values['PICTURE' + IntToStr(i)];
        description := UploadData.Values
          ['PICTURE' + IntToStr(i) + 'DESCRIPTION'];
        if Picture <> '' then
        begin
          index := AddFile(Picture, cbChecked);
          if description <> '' then
          begin
            FileCheckList.Items.Objects[index] := TStringList.Create;
            Comments := (FileCheckList.Items.Objects[index] as TStringList);
            Comments.Add(description);
          end;
        end;
        // ShowMessage(picture);
        inc(i);
      end
      until i = UploadData.Count;
      CheckStep3;
      // Restore Internetseite
      SiteSelect.ItemIndex := StrToInt(UploadData.Values['SITEINDEX']);
      // GetUploadInfo
      ConnectButtonClick(self);
      // Restore Ordner
      FolderID := UploadData.Values['FOLDERID'];
      for i := 0 to pred(FolderSelect.Items.Count) do
      begin
        FolderInfo := (FolderSelect.Items.Objects[i] as TStringList);
        if FolderInfo.Strings[0] = FolderID then
          FolderSelect.ItemIndex := i;
      end;
      NewFolder.Text := UploadData.Values['FOLDER'];
      NewFolderDescription.Lines.Add(UploadData.Values['DESCRIPTION']);
      CheckUpload;
      PageControl1.ActivePageIndex := 2;
      // ShowMessage('Der letzte Upload wurde nicht abgeschlossen. Passwort eingeben und auf Upload klicken, um den letzten Upload fertigzustellen.');
    end
    else
    begin
      DeleteUploadData;
    end;
  end;
end;

procedure TFormTPMain.FormShow(Sender: TObject);
begin
  RestoreUploadData;
  // ShowMessage('FormShow');
{$IFDEF STANDALONE}
  PathByCLI;
{$ENDIF}
end;

procedure TFormTPMain.OpenFullScreen;
begin
{$IFDEF STANDALONE}
  if FileCheckList.ItemEnabled[FileCheckList.ItemIndex] then
  begin
    FullPreview.Show;
    FullPreview.ShowPicture(FileCheckList.ItemIndex);
  end;
{$ELSE}
  ShowMessage('bisher ohne Funktion');
{$ENDIF}
end;

procedure TFormTPMain.FullScreenButtonClick(Sender: TObject);
begin
  OpenFullScreen;
end;

{$IFDEF STANDALONE}

procedure TFormTPMain.PathByCLI;
var
  Path: string;
  PathIsValid: Boolean;
begin
  PathIsValid := false;
  if ParamCount > 0 then
  begin
    Path := ParamStr(1);
    try
      FolderTree.Directory := Path;
      EditPath.Text := Path;
      PathIsValid := True;
    except
      on EInvalidPath do
      begin
        ShowMessage('Der als Parameter übergebene Pfad (' + Path +
          ') ist ungültig!');
        PathIsValid := false;
      end;
    end;
  end;
  if PathIsValid then
  begin
    CheckPath;
    if CheckStep2 then
      PageControl1.ActivePage := Step2
    else
      ShowMessage('Keine Photos in ' + Path + ' gefunden!');
  end;
end;
{$ENDIF}

procedure TFormTPMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  WriteIniValues;
end;

procedure TFormTPMain.MarkAsBadFile(index: integer);
begin
  if ((index >= 0) AND (index < FileCheckList.Count)) then
  begin
    FileCheckList.ItemEnabled[index] := false;
    FileCheckList.State[index] := cbUnChecked;
    inc(Statistik_KorrupteDateien);

    if PageControl1.ActivePageIndex > 0 then
    begin
      if UnAttendedMode then
        Log('ERROR: Die Datei ' + FileCheckList.Items.Strings[index] +
          ' kann nicht geladen werden.')
{$IFDEF STANDALONE}
      else
        ShowMessage('Die Datei ' + FileCheckList.Items.Strings[index] +
          ' kann nicht geladen werden.');
{$ENDIF}
    end;

    if PageControl1.ActivePageIndex = 2 then
      Log(FileCheckList.Items.Strings[index] + ' is unreadable: skipped');
  end;
end;

end.
