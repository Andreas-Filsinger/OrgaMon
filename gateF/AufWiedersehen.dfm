object AufWiedersehenForm: TAufWiedersehenForm
  Left = 190
  Top = 186
  BorderStyle = bsNone
  Caption = 'AufWiedersehenForm'
  ClientHeight = 453
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 96
    Top = 32
    Width = 465
    Height = 153
    Caption = 'Auf Wiedersehen ...'
    Color = 8454143
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 12
      Top = 34
      Width = 48
      Height = 16
      Caption = 'Label1'
    end
    object Label2: TLabel
      Left = 14
      Top = 124
      Width = 42
      Height = 16
      Caption = '... um'
    end
    object Label3: TLabel
      Left = 158
      Top = 125
      Width = 9
      Height = 16
      Caption = 'h'
    end
    object Label4: TLabel
      Left = 15
      Top = 95
      Width = 42
      Height = 16
      Caption = '... am'
    end
    object Label5: TLabel
      Left = 12
      Top = 20
      Width = 37
      Height = 13
      Caption = 'Label5'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 13
      Top = 64
      Width = 42
      Height = 16
      Caption = 'Label6'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object Button1: TButton
      Left = 384
      Top = 122
      Width = 75
      Height = 25
      Caption = '&OK'
      TabOrder = 5
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 280
      Top = 122
      Width = 99
      Height = 25
      Cancel = True
      Caption = 'ab&brechen'
      TabOrder = 4
      OnClick = Button2Click
    end
    object Panel1: TPanel
      Left = 1
      Top = 56
      Width = 463
      Height = 2
      Enabled = False
      TabOrder = 6
    end
    object Edit1: TEdit
      Left = 64
      Top = 120
      Width = 89
      Height = 24
      TabOrder = 1
      OnEnter = Edit1Enter
    end
    object Button3: TButton
      Left = 280
      Top = 93
      Width = 179
      Height = 25
      Caption = 'OK && &weiterer Besuch'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button3Click
    end
    object Edit2: TEdit
      Left = 64
      Top = 93
      Width = 105
      Height = 24
      TabOrder = 0
      OnEnter = Edit2Enter
    end
    object Panel2: TPanel
      Left = 2
      Top = 87
      Width = 463
      Height = 2
      Enabled = False
      TabOrder = 7
    end
    object Button4: TButton
      Left = 280
      Top = 64
      Width = 177
      Height = 17
      Caption = '&Meldung weitergegeben'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button4Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 333
    OnTimer = Timer1Timer
    Left = 424
    Top = 56
  end
end
