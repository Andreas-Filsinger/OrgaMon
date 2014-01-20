object FormAGM_Config: TFormAGM_Config
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Konfiguration'
  ClientHeight = 171
  ClientWidth = 348
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBoxExcel: TGroupBox
    Left = 8
    Top = 8
    Width = 329
    Height = 121
    Caption = 'Excel'
    TabOrder = 0
    object LabelCityOverviewStart: TLabel
      Left = 72
      Top = 32
      Width = 249
      Height = 33
      AutoSize = False
      Caption = 
        'Zeile (auf dem Tabellenblatt "Deckblatt"), ab der die St'#228'dte beg' +
        'innen'
      WordWrap = True
    end
    object LabelCitySheetStart: TLabel
      Left = 72
      Top = 71
      Width = 249
      Height = 21
      AutoSize = False
      Caption = 'Tabellenblatt (Sheet), ab der die St'#228'dte beginnen'
      WordWrap = True
    end
    object EditCityOverviewStart: TEdit
      Left = 16
      Top = 32
      Width = 49
      Height = 21
      TabOrder = 0
      OnKeyDown = EditCityOverviewStartKeyDown
    end
    object EditCitySheetStart: TEdit
      Left = 16
      Top = 71
      Width = 49
      Height = 21
      TabOrder = 1
      OnKeyDown = EditCityOverviewStartKeyDown
    end
  end
  object ButtonOk: TButton
    Left = 152
    Top = 135
    Width = 90
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = ButtonOkClick
  end
  object ButtonCancel: TButton
    Left = 248
    Top = 135
    Width = 90
    Height = 25
    Caption = 'Abbrechen'
    TabOrder = 2
    OnClick = ButtonCancelClick
  end
end
