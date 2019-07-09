object FormGeoPostleitzahlen: TFormGeoPostleitzahlen
  Left = 220
  Top = 175
  Caption = 'FormGeoPostleitzahlen'
  ClientHeight = 233
  ClientWidth = 462
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 46
    Top = 41
    Width = 47
    Height = 13
    Caption = 'einlesen'
  end
  object Label2: TLabel
    Left = 30
    Top = 65
    Width = 63
    Height = 13
    Caption = 'Ortsnamen'
  end
  object Quelle: TLabel
    Left = 58
    Top = 11
    Width = 36
    Height = 13
    Caption = 'Quelle'
  end
  object Label4: TLabel
    Left = 7
    Top = 150
    Width = 9
    Height = 13
    Caption = '#'
  end
  object Button1: TButton
    Left = 256
    Top = 40
    Width = 76
    Height = 18
    Caption = '1. Schritt'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ProgressBar1: TProgressBar
    Left = 97
    Top = 40
    Width = 149
    Height = 16
    TabOrder = 1
  end
  object Button2: TButton
    Left = 336
    Top = 40
    Width = 74
    Height = 123
    Caption = 'abbrechen'
    TabOrder = 2
    OnClick = Button2Click
  end
  object ProgressBar2: TProgressBar
    Left = 97
    Top = 64
    Width = 149
    Height = 16
    TabOrder = 3
  end
  object Button3: TButton
    Left = 256
    Top = 64
    Width = 76
    Height = 17
    Caption = '2. Schritt'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button5: TButton
    Left = 256
    Top = 88
    Width = 76
    Height = 17
    Caption = '3. Schritt'
    TabOrder = 5
    OnClick = Button5Click
  end
  object Edit1: TEdit
    Left = 97
    Top = 7
    Width = 313
    Height = 21
    TabOrder = 6
    Text = 'I:\install\daten\datafactorypostalcode\G0506152.DAT'
  end
  object Button6: TButton
    Left = 256
    Top = 168
    Width = 76
    Height = 21
    Caption = '4. Schritt'
    TabOrder = 7
    OnClick = Button6Click
  end
  object ProgressBar4: TProgressBar
    Left = 7
    Top = 168
    Width = 234
    Height = 17
    TabOrder = 8
  end
  object Button4: TButton
    Left = 256
    Top = 192
    Width = 76
    Height = 25
    Caption = '5. Schritt'
    TabOrder = 9
    OnClick = Button4Click
  end
end
