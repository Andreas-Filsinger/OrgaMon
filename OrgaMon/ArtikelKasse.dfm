object FormArtikelKasse: TFormArtikelKasse
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'FormArtikelKasse'
  ClientHeight = 768
  ClientWidth = 1366
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -16
  Font.Name = 'Verdana'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnDeactivate = FormDeactivate
  OnKeyPress = FormKeyPress
  DesignSize = (
    1366
    768)
  PixelsPerInch = 96
  TextHeight = 18
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 1366
    Height = 768
    Align = alClient
    OnMouseDown = Image1MouseDown
    ExplicitTop = -1
  end
  object Label2: TLabel
    Left = 1104
    Top = 377
    Width = 60
    Height = 18
    Caption = 'Summe'
  end
  object Label3: TLabel
    Left = 6
    Top = 735
    Width = 28
    Height = 18
    Caption = 'Uhr'
  end
  object Label4: TLabel
    Left = 1104
    Top = 408
    Width = 72
    Height = 18
    Caption = 'Gegeben'
  end
  object Label5: TLabel
    Left = 1104
    Top = 438
    Width = 75
    Height = 18
    Caption = 'Rausgeld'
  end
  object Label1: TLabel
    Left = 954
    Top = 377
    Width = 7
    Height = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -21
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object TouchKeyboard1: TTouchKeyboard
    Left = 8
    Top = 464
    Width = 943
    Height = 296
    Anchors = [akLeft, akBottom]
    GradientEnd = clSilver
    GradientStart = clGray
    Layout = 'Standard'
    RepeatDelay = 700
  end
  object TouchKeyboard2: TTouchKeyboard
    Left = 954
    Top = 464
    Width = 321
    Height = 296
    Anchors = [akRight, akBottom]
    GradientEnd = clSilver
    GradientStart = clGray
    Layout = 'NumPad'
    RepeatDelay = 700
  end
  object StaticText1: TStaticText
    Left = 1188
    Top = 373
    Width = 174
    Height = 29
    Alignment = taRightJustify
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = '0,00 '#8364
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -21
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    Transparent = False
  end
  object StaticText2: TStaticText
    Left = 1188
    Top = 403
    Width = 174
    Height = 29
    Alignment = taRightJustify
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = '0,00 '#8364
    Color = 8257405
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -21
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 4
    Transparent = False
  end
  object StaticText3: TStaticText
    Left = 1188
    Top = 432
    Width = 174
    Height = 29
    Alignment = taRightJustify
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = '0,00 '#8364
    Color = 8553215
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -21
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 5
    Transparent = False
  end
  object Edit1: TEdit
    Left = 954
    Top = 404
    Width = 135
    Height = 53
    Alignment = taRightJustify
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -37
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnKeyPress = Edit1KeyPress
  end
  object Edit2: TEdit
    Left = 8
    Top = 404
    Width = 513
    Height = 53
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -37
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    Text = 'Edit2'
    OnKeyPress = Edit2KeyPress
  end
  object DrawGrid1: TDrawGrid
    Left = 954
    Top = 1
    Width = 408
    Height = 372
    ColCount = 3
    FixedCols = 0
    RowCount = 20
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 7
    OnDrawCell = DrawGrid1DrawCell
    OnKeyPress = DrawGrid1KeyPress
    ColWidths = (
      64
      64
      64)
    RowHeights = (
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24)
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 656
    Top = 184
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 432
    OnTimer = Timer2Timer
    Left = 600
    Top = 184
  end
end
