object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 341
  ClientWidth = 914
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 100
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 25
    Height = 13
    Caption = 'Infos'
  end
  object Button1: TButton
    Left = 105
    Top = 308
    Width = 75
    Height = 25
    Caption = 'Test "Zip"'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 24
    Top = 308
    Width = 75
    Height = 25
    Caption = 'Test "Unzip"'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Ende: TButton
    Left = 822
    Top = 308
    Width = 75
    Height = 25
    Caption = 'Ende'
    TabOrder = 2
    OnClick = EndeClick
  end
  object ListBox1: TListBox
    Left = 24
    Top = 35
    Width = 873
    Height = 267
    ItemHeight = 13
    TabOrder = 3
  end
end
