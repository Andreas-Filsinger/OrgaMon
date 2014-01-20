object FormArtikelPreis: TFormArtikelPreis
  Left = 0
  Top = 110
  Caption = 'Artikel Preis'#228'nderung'
  ClientHeight = 446
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    688
    446)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 373
    Height = 20
    Caption = 'OrgaMon'#8482' Systemweite Preis'#228'nderung'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 52
    Width = 42
    Height = 13
    Caption = 'Artikel:'
  end
  object Label3: TLabel
    Left = 16
    Top = 77
    Width = 33
    Height = 13
    Caption = 'Preis:'
  end
  object Label4: TLabel
    Left = 16
    Top = 103
    Width = 70
    Height = 13
    Caption = 'neuer Preis:'
  end
  object Label5: TLabel
    Left = 16
    Top = 137
    Width = 82
    Height = 13
    Caption = 'Einzelaktionen'
  end
  object StaticText1: TStaticText
    Left = 97
    Top = 52
    Width = 576
    Height = 17
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = 'StaticText1'
    TabOrder = 0
  end
  object StaticText2: TStaticText
    Left = 97
    Top = 76
    Width = 576
    Height = 17
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = 'StaticText1'
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 97
    Top = 100
    Width = 120
    Height = 25
    TabOrder = 2
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 648
    Top = 132
    Width = 25
    Height = 25
    Caption = '&B'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 600
    Top = 409
    Width = 75
    Height = 24
    Caption = 'Buchen'
    Enabled = False
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 521
    Top = 409
    Width = 75
    Height = 24
    Caption = 'Abbruch'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 622
    Top = 132
    Width = 25
    Height = 25
    Caption = '&A'
    TabOrder = 6
    OnClick = Button4Click
  end
  object JvTreeView1: TJvTreeView
    Left = 16
    Top = 160
    Width = 657
    Height = 241
    Anchors = []
    Indent = 19
    ReadOnly = True
    TabOrder = 7
    LineColor = 13158600
    ItemHeight = 20
    Checkboxes = True
  end
end
