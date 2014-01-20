object FormWebExport: TFormWebExport
  Left = 145
  Top = 119
  Width = 164
  Height = 106
  Caption = 'Web-Export'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 134
    Height = 13
    Caption = '<ESC> um zu beenden'
  end
  object Edit1: TEdit
    Left = 8
    Top = 40
    Width = 81
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
  end
  object Button1: TButton
    Left = 96
    Top = 39
    Width = 47
    Height = 23
    Caption = '&Start'
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
end
