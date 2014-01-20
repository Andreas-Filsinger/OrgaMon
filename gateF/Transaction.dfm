object FormTransaction: TFormTransaction
  Left = 264
  Top = 186
  BorderStyle = bsToolWindow
  Caption = 'Transaktions Diagnose'
  ClientHeight = 176
  ClientWidth = 323
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 321
    Height = 169
    Caption = 'Server Statistik'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 24
      Width = 129
      Height = 13
      Alignment = taRightJustify
      Caption = 'Transaktionen bisher :'
    end
    object Label2: TLabel
      Left = 89
      Top = 42
      Width = 72
      Height = 13
      Alignment = taRightJustify
      Caption = 'Neuanlagen:'
    end
    object Label3: TLabel
      Left = 87
      Top = 61
      Width = 74
      Height = 13
      Alignment = taRightJustify
      Caption = #196'nderungen:'
    end
    object Label4: TLabel
      Left = 89
      Top = 79
      Width = 72
      Height = 13
      Alignment = taRightJustify
      Caption = 'L'#246'schungen:'
    end
    object Label5: TLabel
      Left = 52
      Top = 111
      Width = 109
      Height = 13
      Alignment = taRightJustify
      Caption = 'Warnungen bisher:'
    end
    object Label6: TLabel
      Left = 56
      Top = 148
      Width = 105
      Height = 13
      Caption = 'Verarbeitungszeit:'
    end
    object Label7: TLabel
      Left = 43
      Top = 129
      Width = 118
      Height = 13
      Alignment = taRightJustify
      Caption = 'Verarbeitungsfehler:'
    end
    object Button2: TButton
      Left = 256
      Top = 56
      Width = 57
      Height = 39
      Caption = 'Details'
      TabOrder = 0
      OnClick = Button2Click
    end
    object StaticText1: TStaticText
      Left = 168
      Top = 24
      Width = 11
      Height = 17
      BorderStyle = sbsSunken
      Caption = '*'
      TabOrder = 1
    end
    object StaticText2: TStaticText
      Left = 168
      Top = 42
      Width = 11
      Height = 17
      BorderStyle = sbsSunken
      Caption = '*'
      TabOrder = 2
    end
    object StaticText3: TStaticText
      Left = 168
      Top = 60
      Width = 11
      Height = 17
      BorderStyle = sbsSunken
      Caption = '*'
      TabOrder = 3
    end
    object StaticText4: TStaticText
      Left = 168
      Top = 78
      Width = 11
      Height = 17
      BorderStyle = sbsSunken
      Caption = '*'
      TabOrder = 4
    end
    object StaticText5: TStaticText
      Left = 168
      Top = 110
      Width = 11
      Height = 17
      BorderStyle = sbsSunken
      Caption = '*'
      TabOrder = 5
    end
    object StaticText6: TStaticText
      Left = 168
      Top = 146
      Width = 11
      Height = 17
      BorderStyle = sbsSunken
      Caption = '*'
      TabOrder = 6
    end
    object Panel1: TPanel
      Left = 2
      Top = 100
      Width = 318
      Height = 2
      Enabled = False
      TabOrder = 7
    end
    object Button1: TButton
      Left = 256
      Top = 30
      Width = 57
      Height = 25
      Caption = 'Re&play'
      TabOrder = 8
      OnClick = Button1Click
    end
    object StaticText7: TStaticText
      Left = 168
      Top = 128
      Width = 11
      Height = 17
      BorderStyle = sbsSunken
      Caption = '*'
      TabOrder = 9
    end
  end
  object Timer1: TTimer
    Interval = 1333
    OnTimer = Timer1Timer
    Left = 8
    Top = 40
  end
end
