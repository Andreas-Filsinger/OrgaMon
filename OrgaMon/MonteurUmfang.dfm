object FormMonteurUmfang: TFormMonteurUmfang
  Left = 218
  Top = 231
  BorderStyle = bsDialog
  Caption = 'Welchen Umfang soll die Liste haben?'
  ClientHeight = 134
  ClientWidth = 323
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 244
    Top = 106
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 164
    Top = 106
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'abbrechen'
    TabOrder = 3
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 3
    Width = 204
    Height = 99
    Caption = 'Monteure'
    TabOrder = 0
    object RadioButtonM1: TRadioButton
      Left = 16
      Top = 24
      Width = 201
      Height = 17
      Caption = 'nur ein Monteur'
      TabOrder = 0
    end
    object RadioButtonB: TRadioButton
      Left = 16
      Top = 47
      Width = 206
      Height = 17
      Caption = 'alle Monteure der Baustelle'
      TabOrder = 1
    end
    object RadioButtonX: TRadioButton
      Left = 16
      Top = 70
      Width = 201
      Height = 17
      Caption = 'alle Monteure'
      TabOrder = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 203
    Top = 3
    Width = 116
    Height = 99
    Caption = 'Zeitraum'
    TabOrder = 1
    object RadioButtonT1: TRadioButton
      Left = 16
      Top = 24
      Width = 137
      Height = 17
      Caption = 'ein Tag'
      TabOrder = 0
    end
    object RadioButtonKW: TRadioButton
      Left = 16
      Top = 47
      Width = 153
      Height = 17
      Caption = 'eine Woche'
      TabOrder = 1
    end
  end
  object JvFormStorage1: TJvFormStorage
    AppStorage = FormMain.JvAppIniFileStorage1
    AppStoragePath = '%FORM_NAME%\'
    Options = [fpLocation]
    StoredValues = <>
    Left = 75
    Top = 64
  end
end
