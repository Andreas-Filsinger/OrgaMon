object BenutzerWechselForm: TBenutzerWechselForm
  Left = 274
  Top = 172
  BorderStyle = bsToolWindow
  Caption = 'Personal Wechsel'
  ClientHeight = 175
  ClientWidth = 319
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = [fsBold]
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 16
  object Kurzbezeichnung: TLabel
    Left = 29
    Top = 18
    Width = 124
    Height = 16
    Caption = 'Kurzbezeichnung'
  end
  object Passwort: TLabel
    Left = 86
    Top = 51
    Width = 67
    Height = 16
    Caption = 'Passwort'
  end
  object Label1: TLabel
    Left = 56
    Top = 80
    Width = 98
    Height = 16
    Caption = 'Passwort neu'
  end
  object Label2: TLabel
    Left = 6
    Top = 115
    Width = 149
    Height = 16
    Caption = 'Passwort best'#228'tigen'
  end
  object ComboBox1: TComboBox
    Left = 165
    Top = 16
    Width = 145
    Height = 24
    ItemHeight = 16
    TabOrder = 0
    OnChange = ComboBox1Change
    OnKeyDown = ComboBox1KeyDown
  end
  object Edit1: TEdit
    Left = 165
    Top = 48
    Width = 145
    Height = 24
    PasswordChar = '*'
    TabOrder = 1
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 235
    Top = 144
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 117
    Top = 144
    Width = 113
    Height = 25
    Cancel = True
    Caption = 'abbrechen'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Edit2: TEdit
    Left = 165
    Top = 80
    Width = 145
    Height = 24
    PasswordChar = '*'
    TabOrder = 2
    Text = 'Edit2'
  end
  object Edit3: TEdit
    Left = 165
    Top = 112
    Width = 145
    Height = 24
    PasswordChar = '*'
    TabOrder = 3
    Text = 'Edit3'
  end
end
