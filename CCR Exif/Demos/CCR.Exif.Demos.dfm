object frmRoundtripOptions: TfrmRoundtripOptions
  Left = 620
  Top = 92
  BorderStyle = bsDialog
  Caption = 'Roundtrip Options'
  ClientHeight = 472
  ClientWidth = 412
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblInfo: TLabel
    Left = 12
    Top = 371
    Width = 392
    Height = 91
    Caption = 
      'These options are to test the saving code in TExifData. For this' +
      ', you can either try a straight roundtrip (loading, saving and l' +
      'oading again), or selectively remove certain parts of the data a' +
      'nd see if the remainder reloads correctly. Note that the origina' +
      'l file will remain untouched, since a temporary copy will be use' +
      'd to test against. Furthermore, the fact that the result of a ro' +
      'untrip may produce a file with a smaller size does not necessari' +
      'ly mean something is wrong, since TExifData (unlike many cameras' +
      ') does not write out any pad bytes.'
    WordWrap = True
  end
  object Button1: TButton
    Left = 328
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 328
    Top = 39
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object rdgXMP: TRadioGroup
    Left = 8
    Top = 273
    Width = 309
    Height = 87
    Caption = ' XMP '
    Items.Strings = (
      'Preserve any XMP data'
      'Remove any XMP data'
      'Rewrite XMP data, creating if necessary')
    TabOrder = 1
  end
  object grpExif: TGroupBox
    Left = 8
    Top = 8
    Width = 309
    Height = 255
    Caption = ' Exif '
    TabOrder = 0
    object chkClearGeneralSection: TCheckBox
      Left = 11
      Top = 89
      Width = 128
      Height = 17
      Caption = 'Clear general section'
      TabOrder = 3
    end
    object chkClearDetailsSection: TCheckBox
      Left = 11
      Top = 112
      Width = 172
      Height = 17
      Caption = 'Clear details section, if exists'
      TabOrder = 4
      OnClick = chkClearDetailsSectionClick
    end
    object chkRemoveMakerNoteTag: TCheckBox
      Left = 26
      Top = 135
      Width = 188
      Height = 17
      Caption = 'Remove MakerNote tag, if exists'
      TabOrder = 5
    end
    object chkSwitchByteOrder: TCheckBox
      Left = 11
      Top = 43
      Width = 114
      Height = 17
      Caption = 'Switch byte order'
      TabOrder = 1
    end
    object chkRemovePaddingTags: TCheckBox
      Left = 11
      Top = 66
      Width = 290
      Height = 17
      Caption = 'Remove any padding tags added by MS software'
      TabOrder = 2
    end
    object chkRemoveExifSegment: TCheckBox
      Left = 11
      Top = 20
      Width = 173
      Height = 17
      Caption = 'Remove all Exif data'
      TabOrder = 0
      OnClick = chkRemoveExifSegmentClick
    end
    object chkRemoveInteropSection: TCheckBox
      Left = 11
      Top = 158
      Width = 190
      Height = 17
      Caption = 'Remove interop section, if exists'
      TabOrder = 6
    end
    object chkRemoveGPSSection: TCheckBox
      Left = 11
      Top = 181
      Width = 178
      Height = 17
      Caption = 'Remove GPS section, if exists'
      TabOrder = 7
    end
    object chkRemoveThumbnailSection: TCheckBox
      Left = 26
      Top = 227
      Width = 203
      Height = 17
      Caption = 'Remove thumbnail section, if exists'
      TabOrder = 9
      OnClick = chkRemoveThumbnailSectionClick
    end
    object chkSetDummyThumbnail: TCheckBox
      Left = 11
      Top = 204
      Width = 135
      Height = 17
      Caption = 'Set dummy thumbnail '
      TabOrder = 8
    end
  end
end
