object FormNatuerlicheResourcen: TFormNatuerlicheResourcen
  Left = 147
  Top = 156
  Caption = 'FormNatuerlicheResourcen'
  ClientHeight = 116
  ClientWidth = 445
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 48
    Width = 4
    Height = 13
  end
  object Button1: TButton
    Left = 336
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 88
    Width = 313
    Height = 16
    TabOrder = 1
  end
  object Button2: TButton
    Left = 336
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Bericht'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 305
    Height = 73
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'Es wird aus *.pdf und *.mp3 die Menge f'#252'r die '
      'Mengenfelder MENGE_DEMO und MENGE_PROBE '
      'eingetragen.')
    TabOrder = 3
  end
  object IB_Query1: TIB_Query
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT '
      ' MENGE_DEMO,'
      ' MENGE_PROBE'
      'FROM'
      ' ARTIKEL'
      'WHERE'
      ' NUMERO=:CROSSREF'
      'FOR UPDATE')
    RequestLive = True
    Left = 88
    Top = 56
  end
end
