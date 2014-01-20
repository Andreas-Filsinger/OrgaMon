object FormArtikelEingabe: TFormArtikelEingabe
  Left = 47
  Top = 159
  Caption = 'Artikel Eingabe'
  ClientHeight = 246
  ClientWidth = 789
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 785
    Height = 161
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 17
      Width = 22
      Height = 13
      Caption = 'RID'
    end
    object Label2: TLabel
      Left = 15
      Top = 37
      Width = 49
      Height = 13
      Caption = 'Nummer'
    end
    object Label4: TLabel
      Left = 16
      Top = 64
      Width = 32
      Height = 13
      Caption = 'Lager'
    end
    object Label5: TLabel
      Left = 16
      Top = 120
      Width = 29
      Height = 13
      Caption = 'offen'
    end
    object Label6: TLabel
      Left = 16
      Top = 136
      Width = 28
      Height = 13
      Caption = 'Preis'
    end
    object Label7: TLabel
      Left = 16
      Top = 88
      Width = 24
      Height = 13
      Caption = 'Titel'
    end
    object StaticText1: TStaticText
      Left = 72
      Top = 12
      Width = 68
      Height = 17
      BorderStyle = sbsSunken
      Caption = 'StaticText1'
      TabOrder = 0
    end
    object Edit1: TEdit
      Left = 72
      Top = 34
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'Edit1'
    end
    object StaticText2: TStaticText
      Left = 72
      Top = 115
      Width = 68
      Height = 17
      BorderStyle = sbsSunken
      Caption = 'StaticText2'
      TabOrder = 2
    end
    object Edit3: TEdit
      Left = 72
      Top = 78
      Width = 705
      Height = 21
      TabOrder = 3
      Text = 'Edit3'
    end
    object Button1: TButton
      Left = 152
      Top = 115
      Width = 22
      Height = 19
      Caption = 'B'
      TabOrder = 4
    end
    object StaticText3: TStaticText
      Left = 72
      Top = 136
      Width = 68
      Height = 17
      BorderStyle = sbsSunken
      Caption = 'StaticText3'
      TabOrder = 5
    end
    object Edit2: TEdit
      Left = 72
      Top = 56
      Width = 121
      Height = 21
      TabOrder = 6
      Text = 'Edit2'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 161
    Width = 785
    Height = 81
    TabOrder = 1
    object Label3: TLabel
      Left = 8
      Top = 12
      Width = 55
      Height = 13
      Caption = 'Hersteller'
    end
    object Label8: TLabel
      Left = 8
      Top = 40
      Width = 37
      Height = 13
      Caption = 'Label8'
    end
    object ComboBox1: TComboBox
      Left = 80
      Top = 8
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = 'ComboBox1'
    end
    object ComboBox2: TComboBox
      Left = 80
      Top = 32
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = 'ComboBox2'
    end
  end
end
