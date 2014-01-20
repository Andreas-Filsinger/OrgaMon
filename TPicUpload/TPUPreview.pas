unit TPUPreview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Buttons;

type
  PImage = ^TImage;

  TFullPreview = class(TForm)
    Comment: TMemo;
    CloseButton: TSpeedButton;
    PrevButton: TSpeedButton;
    SelectButton: TSpeedButton;
    NextButton: TSpeedButton;
    Image1: TImage;
    Bevel1: TBevel;
    Label1: TLabel;
    Bevel2: TBevel;
    DisplayFileName: TLabel;
    Wait: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    DisplayWidth: TLabel;
    DisplayHeight: TLabel;
    procedure CloseButtonClick(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure PrevButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure Image1Progress(Sender: TObject; Stage: TProgressStage;
      PercentDone: Byte; RedrawNow: Boolean; const R: TRect;
      const Msg: String);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    Index: integer;
    Image: PImage;
    function isChecked(const i: integer): boolean;
    function getNextIndex(i: integer): integer;
    function getPrevIndex(i: integer): integer;
    procedure UpdateSelectButton;
    procedure UpdateComment;
    procedure AssignComment;
  public
    { Public-Deklarationen }
    procedure ShowPicture(const i: integer);
  end;

var
  FullPreview: TFullPreview;

implementation

uses TPUMain;
{$R *.dfm}

procedure TFullPreview.ShowPicture(const i: integer);
(*var ImageKey: integer;
    PrevImageKey: integer;
    NextImageKey: integer;
    Next: integer;
    Prev: integer;
*)

  function getFileName(index: integer): string;
  begin
    result := FormTPMain.EditPath.Text + FormTPMain.FileCheckList.Items.Strings[index];
  end;

  function LoadAndShow(const index: integer; const image: PImage) : boolean;
  //var start, duration : TdateTime;
  begin
    Result := false;
    //Image^.Show;
    //if index <> Image^.Tag then
    if FormTPMain.FileCheckList.ItemEnabled[index] then
    begin
      try
        Image^.Picture.LoadFromFile(getFileName(index));
        Image^.Tag := index;
        Result := true;
        //ShowMessage(Image^.Name + ' Tag: ' + inttostr(Image^.Tag) + 'Time: ' + TimeToStr(duration));
      except
        beep;
        FormTPMain.MarkAsBadFile(index);
      end;
    end;
  end;

  procedure Load(const index: integer; const image: PImage);
  begin
    if index <> Image^.Tag then
    try
      Image^.Picture.LoadFromFile(getFileName(index));
      Image^.Tag := index;
      //ShowMessage(Image^.Name + ' Tag: ' + inttostr(Image^.Tag) + 'Time: ' + TimeToStr(duration));
    except
      beep;
    end;
  end;

  procedure Hide(const image: PImage);
  begin
    Image^.Hide;
  end;

  (*function isLoadedInImage(index: integer): integer;
  var i: integer;
  begin
    result := 0;
    for i := 1 to 3 do
    begin
      if (Images[i]^.Tag = index) then
      begin
        result := i;
      end;
    end;
  end;*)

begin
  Index := i;
  //Prev := getPrevIndex(Index);
  //Next := getNextIndex(Index);

  //ShowMessage('Index: ' + IntToStr(Index) + ', Prev: ' + IntToStr(Prev) + ', Next: ' + IntToStr(Next));

  //ImageKey := isLoadedInImage(Index);

  //if (ImageKey = 0) then ImageKey := 1;
  //ImageKey := 1;

  //if ImageKey > 1 then PrevImageKey := ImageKey - 1
  //else PrevImageKey := 3;

  //if ImageKey < 3 then NextImageKey := ImageKey + 1
  //else NextImageKey := 1;

  //ShowMessage('ImageKey: ' + IntToStr(ImageKey));
  //ShowMessage(IntToStr(Images[ImageKey]^.Tag));

  //Hide(Images[NextImageKey]);
  //Hide(Images[PrevImageKey]);
  if LoadAndShow(Index, Image) then
  begin
  //ShowMessage(IntToStr(Images[ImageKey]^.Tag));
    DisplayFileName.Caption := FormTPMain.FileCheckList.Items.Strings[Index];
    DisplayWidth.Caption := inttostr(Image^.Picture.Graphic.Width);
    DisplayHeight.Caption := inttostr(Image^.Picture.Graphic.Height);
    UpdateSelectButton;
    UpdateComment;
    FormTPMain.FileCheckList.ItemIndex := Index;
  end;

  //Load(Next, Images[NextImageKey]);
  //Load(Prev, Images[PrevImageKey]);
end;

procedure TFullPreview.CloseButtonClick(Sender: TObject);
begin
  AssignComment;
  Hide;
end;

procedure TFullPreview.SelectButtonClick(Sender: TObject);
begin
  if isChecked(Index) then FormTPMain.FileCheckList.State[Index] := cbUnchecked
  else FormTPMain.FileCheckList.State[Index] := cbChecked;
  UpdateSelectButton;
end;

function TFullPreview.isChecked(const i: integer): boolean;
begin
  if FormTPMain.FileCheckList.State[i] = cbChecked then Result := true
  else Result := false;
end;

procedure TFullPreview.UpdateSelectButton;
begin
  if isChecked(Index) then SelectButton.Glyph.LoadFromFile(FormTPMain.WorkingDir + 'icon_selected.bmp')
  else SelectButton.Glyph.LoadFromFile(FormTPMain.WorkingDir + 'icon_unselected.bmp');
end;

function TFullPreview.getNextIndex(i: integer): integer;
begin
  result := i;
  repeat
    if result < pred(FormTPMain.FileCheckList.Count) then result := succ(result)
    else result := 0;
  until FormTPMain.FileCheckList.ItemEnabled[result];
end;

function TFullPreview.getPrevIndex(i: integer): integer;
begin
  result := i;
  repeat
    if result > 0 then result:= pred(result)
    else result := pred(FormTPMain.FileCheckList.Count);
  until FormTPMain.FileCheckList.ItemEnabled[result];
end;

procedure TFullPreview.PrevButtonClick(Sender: TObject);
begin
  AssignComment;
  Index := getPrevIndex(Index);
  ShowPicture(Index);
end;

procedure TFullPreview.NextButtonClick(Sender: TObject);
begin
  AssignComment;
  Index := getNextIndex(Index);
  ShowPicture(Index);
end;

procedure TFullPreview.Image1Progress(Sender: TObject;
  Stage: TProgressStage; PercentDone: Byte; RedrawNow: Boolean;
  const R: TRect; const Msg: String);
begin
  case Stage of
    psStarting: begin
        Screen.Cursor := crHourGlass;
        Wait.Caption := 'Bitte warten...';
        Wait.Refresh;
      end;
    psEnding: begin
        Screen.Cursor := crDefault;
        Wait.Caption := '';
        Wait.Refresh;
      end;
  end;
end;

procedure TFullPreview.UpdateComment;
var Comments: TStringList;
begin
  Comments := (FormTPMain.FileCheckList.Items.Objects[Index] as TStringList);
  if (Comments <> nil) then Comment.Lines.Assign(Comments)
  else Comment.Clear;
  Comment.SetFocus;
end;

procedure TFullPreview.AssignComment;
var Comments: TStringList;
begin
  if Comment.Lines.Count > 0 then
  begin
    FormTPMain.FileCheckList.Items.Objects[Index] := TStringList.Create;
    Comments := (FormTPMain.FileCheckList.Items.Objects[Index] as TStringList);
    Comments.Assign(Comment.Lines);
  end;
end;

procedure TFullPreview.FormCreate(Sender: TObject);
begin
  //ShowMessage('PreviewCreate');
  Image := @Image1;
end;

end.

(*
procedure LoadAndShow(const FName: string; const index: integer; const image: TImage);
var RealWidth, RealHeight: integer;
    Height, cWidth: integer;
begin
  cHeight := Height ;
  cWidth := Width;
  RealWidth := Image.picture.graphic.Width;
  RealHeight := Image.picture.graphic.Height;
  if (RealWidth / RealHeight < cWidth / cHeight) then
  begin
    // fix height, adjust Width
    //image.Width := MulDiv(cHeight, RealWidth, RealHeight);
    //image.Height := cHeight;
  end else
  begin
    // fix width, Adjust Height
    //image.Height := MulDiv(cWidth, RealHeight, RealWidth);
    //image.Width := cWidth;
  end;
  //image.left := (cWidth - image.width) div 2;
  //image.top := (cHeight - image.height) div 2;
end;
*)
