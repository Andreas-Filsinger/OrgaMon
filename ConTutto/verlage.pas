unit verlage;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, ComCtrls,
  StdCtrls;

type
  TVerlageForm = class(TForm)
    VerlageList: TListView;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    nextButton: TButton;
    cancelButton: TButton;
    Label8: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure FormResize(Sender: TObject);
    procedure VerlageListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure nextButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    installed: boolean;
  public
    { Public declarations }
    procedure LoadVerlage;
    procedure FreeVerlage;
  end;

var
  VerlageForm: TVerlageForm;


implementation

uses
  globals, anfix32;

{$R *.DFM}

procedure TVerlageForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_escape then
  begin
    key := 0;
    close;
  end;
end;

procedure TVerlageForm.FormActivate(Sender: TObject);
var
  ActRecord: integer;
  p: pointer;
begin
  if not (installed) then
  begin

  // Texte zuweisen
    caption := LanguageStr[pred(29)];
    cancelButton.caption := LanguageStr[pred(26)];
    nextButton.caption := LanguageStr[pred(100)];
    groupbox1.caption := LanguageStr[pred(102)];

    verlagelist.columns.Items[0].caption := LanguageStr[pred(108)];
    verlagelist.columns.Items[1].caption := LanguageStr[pred(109)];
    verlagelist.columns.Items[2].caption := LanguageStr[pred(110)];
    verlagelist.columns.Items[3].caption := LanguageStr[pred(111)];
    verlagelist.columns.Items[4].caption := LanguageStr[pred(103)];
    verlagelist.columns.Items[5].caption := LanguageStr[pred(104)];
    verlagelist.columns.Items[6].caption := LanguageStr[pred(112)];
    verlagelist.columns.Items[7].caption := LanguageStr[pred(113)];

    application.processmessages;

    installed := true;
    caption := LanguageStr[pred(101)];
  end;
  LoadVerlage;
end;

procedure TVerlageForm.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  Resize := (NewWidth > 570) and (NewHeight > 450);
end;

procedure TVerlageForm.FormResize(Sender: TObject);
const
  ElementGridX = 5;
  ElementGridY = 5;
begin
  nextbutton.Top := clientheight - (nextbutton.height + ElementGridY);
  nextbutton.left := clientwidth - (nextbutton.Width + ElementGridX);

  cancelbutton.Top := clientheight - (nextbutton.height + ElementGridY);
  cancelbutton.left := clientwidth - (nextbutton.Width + ElementGridX) - (cancelbutton.Width + ElementGridX);

  GroupBox1.top := clientheight - (nextbutton.height + ElementGridY) - (GroupBox1.height + ElementGridY);
  GroupBox1.width := clientwidth - 2 * ElementGridX;

  VerlageList.width := clientwidth - 2 * ElementGridX;
  VerlageList.height := clientheight - (nextbutton.height + ElementGridY) - (GroupBox1.height + ElementGridY) - 3 * ElementGridY;
end;

procedure TVerlageForm.VerlageListSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
type
  pverlag = ^tverlag;
begin
  verlag := pverlag(item.data)^;
  with verlag do
  begin
    label1.caption := name;
    label2.caption := strasse;
    label3.caption := Ort;
    label4.caption := Ansprechpartner;

    if (tel = '') then
      label5.caption := tel
    else
      label5.caption := LanguageStr[pred(103)] + ' ' + tel;

    if (fax = '') then
      label6.caption := fax
    else
      label6.caption := LanguageStr[pred(104)] + ' ' + fax;

    label7.caption := eMail;
    label8.caption := website;
  end;
end;

procedure TVerlageForm.nextButtonClick(Sender: TObject);
begin
  close;
end;

procedure TVerlageForm.cancelButtonClick(Sender: TObject);
begin
  close;
end;

procedure TVerlageForm.FormCreate(Sender: TObject);
begin
  CheckIfHaendlerVersion;
end;


procedure TVerlageForm.LoadVerlage;
var
  Inf: file;
  verlag: tverlag;
  n: integer;
  OneLine: TListitem;
  VerlageFname: string;
begin
  if (VerlageAnz = 0) then
    if assigned(VerlageList) then
    begin
      VerlageList.items.beginupdate;
      VerlageFName := ProgramFilesDir + '\' + cCodeName + '\verlage.bin';
      if not (FileExists(VerlageFName)) then
        VerlageFName := SystemPath + '\verlage.bin';

      VerlageAnz := FSize(VerlageFName);
      if (VerlageAnz > 0) then
      begin
        screen.cursor := crhourglass;
        assignFile(inf, VerlageFName);
        FileMode := fmOpenRead; // read only, from CDR for example
        Reset(InF, 1);
        FileMode := fmOpenReadWrite; // restore FileMode
        GetMem(VerlageArray, VerlageAnz);
        BlockRead(Inf, VerlageArray^, VerlageAnz);
        VerlageAnz := VerlageAnz div sizeof(tverlag);
        closeFile(inf);
        for n := 0 to pred(VerlageAnz) do
        begin
          DataScramble(VerlageArray^[n], sizeof(tVerlag));
          with VerlageArray^[n] do
          begin
            OneLine := VerlageList.items.add;
            OneLine.Caption := name;
            OneLine.SubItems.Add(strasse);
            OneLine.SubItems.Add(Ort);
            OneLine.SubItems.Add(Ansprechpartner);
            OneLine.SubItems.Add(tel);
            OneLine.SubItems.Add(fax);
            OneLine.SubItems.Add(eMail);
            OneLine.SubItems.Add(website);
          end;
          OneLine.data := @VerlageArray^[n];
        end;
        screen.cursor := crdefault;
      end;
      VerlageList.items.endupdate;
    end;
end;

procedure TVerlageForm.FreeVerlage;
begin
  if (VerlageAnz > 0) then
  begin
    VerlageList.items.Clear;
    FreeMem(VerlageArray, VerlageAnz * sizeof(tverlag));
    VerlageArray := nil;
    VerlageAnz := 0;
  end;
end;


end.
