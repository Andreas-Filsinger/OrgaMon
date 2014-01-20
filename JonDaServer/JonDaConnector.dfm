object FormJonDaConnector: TFormJonDaConnector
  Left = 92
  Top = 87
  Caption = 'XML RPC'
  ClientHeight = 301
  ClientWidth = 755
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 17
  object Label1: TLabel
    Left = 21
    Top = 241
    Width = 224
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Fehler anstelle der TAN senden:'
  end
  object CheckBox1: TCheckBox
    Left = 10
    Top = 10
    Width = 347
    Height = 23
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'ich bin Server'
    Enabled = False
    TabOrder = 0
  end
  object lstMessages: TListBox
    Left = 10
    Top = 42
    Width = 724
    Height = 127
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ItemHeight = 17
    TabOrder = 1
  end
  object StaticText1: TStaticText
    Left = 450
    Top = 10
    Width = 284
    Height = 23
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = 'keine Clicks seit Programmstart'
    TabOrder = 2
  end
  object CheckBox2: TCheckBox
    Left = 21
    Top = 188
    Width = 242
    Height = 23
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Log Webshop Calls'
    TabOrder = 3
  end
  object Button2: TButton
    Left = 387
    Top = 178
    Width = 98
    Height = 33
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Clear Log'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 282
    Top = 178
    Width = 99
    Height = 33
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Abst'#252'rzen!'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Edit1: TEdit
    Left = 272
    Top = 235
    Width = 462
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 6
  end
  object CheckBox3: TCheckBox
    Left = 21
    Top = 272
    Width = 360
    Height = 22
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'keine '#220'berpr'#252'fung der Handyzeit'
    TabOrder = 7
  end
  object Timer1: TTimer
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 392
    Top = 8
  end
end
