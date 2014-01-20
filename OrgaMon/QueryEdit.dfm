object FormQueryEdit: TFormQueryEdit
  Left = 243
  Top = 159
  Caption = 'FormQueryEdit'
  ClientHeight = 328
  ClientWidth = 596
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 17
  object Memo1: TMemo
    Left = 10
    Top = 10
    Width = 588
    Height = 263
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 398
    Top = 282
    Width = 98
    Height = 33
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'abbrechen'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 502
    Top = 282
    Width = 98
    Height = 33
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'OK'
    TabOrder = 2
    OnClick = Button2Click
  end
  object IB_Query1: TIB_Query
    DatabaseName = '192.168.115.91:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    Left = 304
    Top = 56
  end
end
