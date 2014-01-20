object FormFISonline: TFormFISonline
  Left = 192
  Top = 144
  Width = 783
  Height = 540
  Caption = 'FormFISonline'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Trebuchet MS'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 18
  object Label1: TLabel
    Left = 24
    Top = 112
    Width = 131
    Height = 18
    Caption = 'Hier Eingaben machen'
  end
  object Button1: TButton
    Left = 440
    Top = 56
    Width = 75
    Height = 25
    Caption = 'load'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 24
    Top = 56
    Width = 401
    Height = 26
    TabOrder = 1
    Text = 'G:\delphi\twebformghost\webform.html'
  end
  object Memo1: TMemo
    Left = 24
    Top = 136
    Width = 401
    Height = 241
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
  object Button2: TButton
    Left = 448
    Top = 352
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 3
  end
end
