object UploadProgressForm: TUploadProgressForm
  Left = 0
  Top = 0
  Caption = 'Upload'
  ClientHeight = 33
  ClientWidth = 319
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressBar: TJvSpecialProgress
    Left = 8
    Top = 8
    Width = 228
    Height = 17
    Color = clBackground
    EndColor = 8404992
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    GradientBlocks = True
    ParentColor = False
    ParentFont = False
    StartColor = 15448477
    TextCentered = True
    TextOption = toCaption
  end
  object CancelButton: TButton
    Left = 242
    Top = 3
    Width = 69
    Height = 25
    Cancel = True
    Caption = 'Abbruch'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = CancelButtonClick
  end
end
