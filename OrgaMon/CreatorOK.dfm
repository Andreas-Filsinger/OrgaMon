object FormCreatorOK: TFormCreatorOK
  Left = 357
  Top = 162
  BorderStyle = bsToolWindow
  Caption = 'FormCreatorOK'
  ClientHeight = 368
  ClientWidth = 578
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 9
    Top = 8
    Width = 88
    Height = 13
    Caption = 'Serie Nummer:'
  end
  object Label2: TLabel
    Left = 6
    Top = 35
    Width = 104
    Height = 13
    Caption = 'Zugriffs Passwort:'
  end
  object Label3: TLabel
    Left = -1
    Top = 100
    Width = 102
    Height = 13
    Caption = 'Kunden-Nummer:'
  end
  object Label4: TLabel
    Left = 119
    Top = 7
    Width = 79
    Height = 20
    Caption = 'Label4'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Courier'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 120
    Top = 35
    Width = 79
    Height = 20
    Caption = 'Label5'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Courier'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 0
    Top = 72
    Width = 99
    Height = 13
    Caption = 'H'#228'ndler Passwort'
  end
  object Label7: TLabel
    Left = 120
    Top = 66
    Width = 79
    Height = 20
    Caption = 'Label7'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Courier'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 456
    Top = 32
    Width = 121
    Height = 89
    Caption = 'Ausgeliefert!'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 152
    Top = 96
    Width = 289
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
  end
  object CheckListBox1: TCheckListBox
    Left = 0
    Top = 128
    Width = 577
    Height = 236
    BorderStyle = bsNone
    Color = clInfoBk
    Ctl3D = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
  end
  object CheckBox1: TCheckBox
    Left = 456
    Top = 8
    Width = 97
    Height = 17
    Caption = 'H'#228'ndlerversion'
    TabOrder = 3
  end
  object Button2: TButton
    Left = 112
    Top = 96
    Width = 35
    Height = 25
    Caption = 'P->'
    TabOrder = 4
    OnClick = Button2Click
  end
end
