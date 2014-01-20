object BesucherSucheForm: TBesucherSucheForm
  Left = 182
  Top = 165
  BorderStyle = bsNone
  Caption = 'BesucherSucheForm'
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
  OnDeactivate = FormDeactivate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 24
    Width = 681
    Height = 361
    Caption = 'Besucher suchen ...'
    Color = 15393173
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 32
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
      ColCount = 6
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
      OnDrawCell = StringGrid1DrawCell
    end
    object Edit1: TEdit
      Left = 88
      Top = 328
      Width = 281
      Height = 24
      TabOrder = 1
      OnChange = Edit1Change
      OnKeyDown = Edit1KeyDown
    end
  end
end
