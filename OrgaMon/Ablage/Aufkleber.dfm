object FormAufkleber: TFormAufkleber
  Left = 139
  Top = 94
  BorderStyle = bsToolWindow
  Caption = 'Aufkleber'
  ClientHeight = 482
  ClientWidth = 312
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object DrawGrid1: TDrawGrid
    Left = 8
    Top = 8
    Width = 289
    Height = 430
    ColCount = 2
    DefaultColWidth = 142
    DefaultRowHeight = 60
    FixedCols = 0
    RowCount = 7
    FixedRows = 0
    TabOrder = 0
  end
  object Button1: TButton
    Left = 224
    Top = 448
    Width = 75
    Height = 25
    Caption = 'drucken'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 88
    Top = 448
    Width = 131
    Height = 25
    Caption = 'Alles löschen'
    TabOrder = 2
  end
end
