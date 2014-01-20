object PlanungLoeschenForm: TPlanungLoeschenForm
  Left = 190
  Top = 186
  BorderStyle = bsNone
  Caption = 'PlanungLoeschenForm'
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
    Height = 105
    Caption = 'Planung löschen ...'
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
      Left = 14
      Top = 27
      Width = 48
      Height = 16
      Caption = 'Label1'
    end
    object Button1: TButton
      Left = 384
      Top = 69
      Width = 75
      Height = 25
      Caption = '&OK'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 280
      Top = 69
      Width = 99
      Height = 25
      Cancel = True
      Caption = 'ab&brechen'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Panel1: TPanel
      Left = 1
      Top = 56
      Width = 463
      Height = 2
      Enabled = False
      TabOrder = 2
    end
  end
end
