object MitarbeiterSucheForm: TMitarbeiterSucheForm
  Left = 162
  Top = 147
  BorderStyle = bsNone
  Caption = 'MitarbeiterSucheForm'
  ClientHeight = 453
  ClientWidth = 748
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 24
    Width = 681
    Height = 393
    Caption = 'Mitarbeiter suchen ...'
    Color = 4772395
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 330
      Width = 43
      Height = 16
      Caption = '&suche'
      FocusControl = Edit1
    end
    object StringGrid1: TStringGrid
      Left = 5
      Top = 24
      Width = 668
      Height = 289
      ColCount = 4
      FixedCols = 0
      RowCount = 2
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goThumbTracking]
      ParentFont = False
      TabOrder = 0
    end
    object Edit1: TEdit
      Left = 56
      Top = 328
      Width = 281
      Height = 24
      HideSelection = False
      TabOrder = 1
      OnChange = Edit1Change
      OnKeyDown = Edit1KeyDown
    end
    object Button1: TButton
      Left = 344
      Top = 328
      Width = 329
      Height = 25
      Caption = '-> e&Mail'
      TabOrder = 2
      OnClick = Button1Click
    end
    object Panel1: TPanel
      Left = 512
      Top = 374
      Width = 161
      Height = 17
      BevelOuter = bvNone
      Caption = 'F3-Tagesausweis'
      TabOrder = 3
    end
  end
end
