// Installations-Prozess
unit noten;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls, DBCtrls,
   registry, globals,
  checklst, printers;

type
  TNotenForm = class(TForm)
    StatusBar1: TStatusBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PrintDialog1: TPrintDialog;
    Edit1: TEdit;
    Edit3: TEdit;
    Button2: TButton;
    Button6: TButton;
    Label9: TLabel;
    Edit4: TEdit;
    CheckListBox1: TCheckListBox;
    Label15: TLabel;
    Label5: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Label8: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button8: TButton;
    Button9: TButton;
    Label16: TLabel;
    Button10: TButton;
    Button11: TButton;
    Label17: TLabel;
    Label18: TLabel;
    Button12: TButton;
    Label19: TLabel;
    Label20: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label21: TLabel;
    Button13: TButton;
    Bevel4: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure OpenDialog1Close(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button3Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button9Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
  private
    Initialized: boolean;
    ExecuteString: array[0..256] of char;

    function FileName(No: word): string;
    procedure SetAllCheckState;
    function PwdOK(Analyse: boolean): boolean;
    procedure ShowHilfe(FName: string);
  public
   { Public-Deklarationen }
  end;

var
  NotenForm: TNotenForm;

implementation

uses
  RStream, MiniTexte, decrypt,
  anfix32, wanfix32;

{$R *.DFM}

// Update the "TAG" - State
// nur "untagged" Felder beeinflussen


function TNotenForm.PwdOK(Analyse: boolean): boolean;
var
  Source: TEncryptedFileStream;
  Dest: TFileStream;
  InpF: textfile;
  CheckF: file;
  DestFName: string[255];
  InpStr: string[255];
begin

  result := false;

 // Check Entry in "Dest-Path" -> add
  if (length(edit4.Text) > 0) then
  begin
    if (edit4.Text[length(edit4.Text)] <> '\') then
      edit4.Text := edit4.Text + '\';
  end;

 // Check if Dataentry = 'JA'
  if pos('JA', uppercase(edit1.Text)) <> 1 then
  begin
    if Analyse then
    begin
      PageControl1.ActivePage := TabSheet1;
      FocusControl(edit1);
      ShowMessage('Stimmen Sie dem Vertrag durch Eingabe von JA zu!');
    end;
    exit;
  end;

 // check if destination is valid!
  DestFname := edit4.Text + 'crypt.tmp';
  assignFile(CheckF, DestFname);
{$I-}
  rewrite(CheckF);
{$I+}
  if (ioresult <> 0) then
  begin
    if Analyse then
    begin
      PageControl1.ActivePage := TabSheet2;
      FocusControl(edit4);
      ShowMessage('Ihr Zielverzeichnis ' + DestPath + ' ist falsch oder schreibgeschützt!');
    end;
    exit;
  end;
  closeFile(CheckF);
  erase(CheckF);

 // open Source
  Source := TEncryptedFileStream.create(SystemPath + '\..\noten\crypt.txt', fmOpenRead);
  Source.key := edit3.Text;

 // create destination
  Dest := TFileStream.create(DestFname, fmCreate);

 // copy it!
  Dest.CopyFrom(Source, 0);
  Dest.free;
  Source.free;

  assignFile(InpF, DestFname);
  reset(InpF);
  readln(InpF, InpStr);
  closeFile(InpF);
  erase(InpF);

  if (pos('anfisoft', InpStr) <> 1) or (pos('serial number', InpStr) <> 20) then
  begin
    if Analyse then
    begin
      PageControl1.ActivePage := TabSheet1;
      FocusControl(edit3);
      ShowMessage('Das Zugriffs-Passwort ist falsch!');
    end;
    exit;
  end;

 // nothing left to worry about
  result := true;
end;

function TNotenForm.FileName(No: word): string;
var
  p, q: byte;
begin
  if (No > NotenForm.CheckListBox1.items.count) then
  begin
    Result := '';
  end else
  begin
    p := pos('(', CheckListBox1.items[No]);
    q := pos(')', CheckListBox1.items[No]);
    if (p = 0) or (q = 0) or (q <= p) then
    begin
      result := '';
    end else
    begin
      result := copy(CheckListBox1.items[No], succ(p), pred(q - p));
    end;
  end;
end;

procedure TNotenForm.SetAllCheckState;
var
  i: integer;
begin
  CheckListBox1.AllowGrayed := true;
  for i := 0 to pred(CheckListBox1.items.count) do
    if fileexists(edit4.text + FileName(i)) then
      CheckListBox1.state[i] := cbgrayed
    else
      CheckListBox1.state[i] := cbchecked;
  CheckListBox1.AllowGrayed := false;
end;

procedure TNotenForm.FormCreate(Sender: TObject);
begin
  top := (screen.height div 2) - (height div 2);
  left := (screen.width div 2) - (width div 2);
end;

procedure TNotenForm.OpenDialog1Close(Sender: TObject);
begin
// Edit4.caption := opendialog1
end;

procedure TNotenForm.Edit4Exit(Sender: TObject);
begin
  SetAllCheckState;
end;

procedure TNotenForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Password := edit3.Text;
  Name1 := edit5.Text;
  Name2 := edit6.Text;
  Strasse := edit7.Text;
  PLZOrt := edit8.Text;
  MiniTexteForm.Hide;
end;

procedure TNotenForm.Button2Click(Sender: TObject);
var
  i: integer;
  OneUsed: boolean;
begin
  if paramstr(1) = 'demo' then
    exit;
  if PwdOK(true) then
  begin
  // Start-Copy
    OneUsed := false;
    for i := 0 to pred(CheckListBox1.items.count) do
      if CheckListBox1.state[i] = cbchecked then
      begin
        OneUsed := true;
        FormDecrypt.CryptCopy(SystemPath + '\..\noten\' + FileName(i), Edit4.text + FileName(i), edit3.Text);
      end;
    if not (OneUsed) then
      ShowMessage('Bitte kreuzen Sie zumindest eines der Kästchen, links neben den Texten an!')
    else
      SetAllCheckState;
  end;
end;

procedure TNotenForm.Edit4Change(Sender: TObject);
begin
 // Nur Bei Änderung von Außen aufrufen!!!
  DestPath := edit4.Text;
  if not edit4.focused then
    SetAllCheckState;
end;

procedure TNotenForm.FormActivate(Sender: TObject);
var
  serialF: TStringList;
begin
  if not (Initialized) then
  begin
    Initialized := true;
    edit3.Text := PassWord;
    edit5.Text := Name1;
    edit6.Text := Name2;
    edit7.Text := Strasse;
    edit8.Text := PLZOrt;
    edit4.text := DestPath;
    edit4.showhint := true;
    edit4.hint := 'Zielverzeichnis für ';
    PageControl1.ActivePage := TabSheet1;
    label20.caption := SerialNumber; // Serie Nummer

  // Password
    serialF := TStringList.create;
    if FileExists(SystemPath + '\stdpwd.txt') then
    begin
      serialF.LoadFromFile(SystemPath + '\stdpwd.txt');
      edit3.Text := serialF[0];
    end;
    serialF.free;

  // Lizenz-Text
    Memo1.Lines.Loadfromfile(SystemPath + '\LIZENZ.TXT');

  // Tabelle "Verfügbare Texte holen"
    CheckListBox1.Items.Loadfromfile(SystemPath + '\..\noten\NOTEN.TXT');

    PageControl1.ActivePage := TabSheet1;

    if (edit5.text = '') then
      FocusControl(edit5)
    else
      FocusControl(edit1);

    SetAllCheckState;
  end;
end;

procedure TNotenForm.Label4Click(Sender: TObject);
begin
  PageControl1.ActivePage := PageControl1.FindNextPage(PageControl1.ActivePage, true, false);
end;

procedure TNotenForm.Label5Click(Sender: TObject);
begin
  close;
end;

procedure TNotenForm.Button6Click(Sender: TObject);
begin
  if paramstr(1) = 'demo' then
    exit;
  close;
  StrPCopy(ExecuteString, SystemPath + '\..\install\finale\setup.exe');
  OpenShell(ExecuteString, sw_show);
end;

procedure TNotenForm.Edit3Exit(Sender: TObject);
begin
  Edit3.Text := uppercase(Edit3.Text);
end;

procedure TNotenForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    vk_escape: close;
  end;
end;

procedure TNotenForm.Button3Click(Sender: TObject);
begin
  if paramstr(1) = 'demo' then
    exit;
  close;
  StrPCopy(ExecuteString, SystemPath + '\..\install\BDBdemo\install.exe');
  OpenShell(ExecuteString, sw_show);
end;

procedure TNotenForm.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_return then
    PageControl1.ActivePage := PageControl1.FindNextPage(PageControl1.ActivePage, true, false);
end;

procedure TNotenForm.Button9Click(Sender: TObject);
begin
  if paramstr(1) = 'demo' then
    exit;
  close;
  StrPCopy(ExecuteString, SystemPath + '\..\install\finale97\f97dmo95.exe');
  OpenShell(ExecuteString, sw_show);
  ShowMessage('Nach erfolgreicher Installation ist ein Neustart von Windows ist erforderlich!');
end;

procedure TNotenForm.ShowHilfe(FName: string);
var
  MyStrings: TstringList;
  n: integer;
  Outstr: string;
begin
  MiniTexteForm.hide;
  MyStrings := TStringList.create;
  OutStr := '';
  MyStrings.LoadFromFile(FName);
  for n := 1 to MyStrings.count do
    OutStr := OutStr + MyStrings[pred(n)] + #$0D;
  MyStrings.free;
  MiniTexteForm.position := poScreenCenter;
  MiniTexteForm.WriteOut(OutStr);
end;

procedure TNotenForm.Button4Click(Sender: TObject);
begin
  ShowHilfe(Systempath + '\HLizenz.txt');
end;

procedure TNotenForm.Button5Click(Sender: TObject);
begin
  ShowHilfe(Systempath + '\HNoten.txt');
end;

procedure TNotenForm.Button8Click(Sender: TObject);
begin
  ShowHilfe(Systempath + '\HDemos.txt');
end;

procedure TNotenForm.Button10Click(Sender: TObject);
begin
  if paramstr(1) = 'demo' then
    exit;
  ShowMessage('Tip: Die Installation und Anwendung ist sehr komplex;' +
    #$0D + 'lassen Sie sich durch einen Experten helfen!');
  close;
  StrPCopy(ExecuteString, SystemPath + '\..\install\Ghost\setup.exe');
  OpenShell(ExecuteString, sw_show);
end;

procedure TNotenForm.Button11Click(Sender: TObject);
begin
  if paramstr(1) = 'demo' then
    exit;
  ShowMessage('Tip: Die Installation und Anwendung ist sehr komplex;' +
    #$0D + 'lassen Sie sich durch einen Experten helfen!');
  close;
  StrPCopy(ExecuteString, SystemPath + '\..\install\RedMon\setup.exe');
  OpenShell(ExecuteString, sw_show);
end;


procedure TNotenForm.Button12Click(Sender: TObject);
begin
  ShowMessage('Wenn Sie Post-Script Dokumente drucken wollen' + #$0D +
    'aber keinen Post-Script Drucker besitzten, können Sie mit' + #$0D +
    'dieser mitgelieferten Free-Ware einen Post-Script' + #$0D +
    'Drucker simulieren:' + #$0D +
    '1) Ghost-Script installieren' + #$0D +
    '2) gswin32c.exe durch neuere Version in CD:\install\redmon ersetzen' + #$0D +
    '3) RedMon installieren' + #$0D +
    '4) redmon.hlp in CD:\install\redmon durchlesen' + #$0D);
end;

procedure TNotenForm.Button13Click(Sender: TObject);
begin
  if paramstr(1) = 'demo' then
    exit;
  close;
  ShowMessage('Die Shareware (c)WinAmp(tm) wird nun installiert. Bitte installieren Sie ' + #13 +
    'ausschließlich nach "C:\Programme\winamp". Leider ' + #13 +
    'wird als Standard-Vorgabe "C:\Program Files\winamp" angegeben.' + #13 +
    'Verbessern Sie hier "Program Files" nach "Programme"' + #13 +
    'im folgenden Setup-Fenster!');
  StrPCopy(ExecuteString, SystemPath + '\..\install\WinAmp\winamp19.exe');
  OpenShell(ExecuteString, sw_show);
end;

end.
