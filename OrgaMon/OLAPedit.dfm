object FormOLAPedit: TFormOLAPedit
  Left = 8
  Top = 155
  Caption = 'Eichraum: einzelner Datensatz'
  ClientHeight = 628
  ClientWidth = 1195
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 17
  object Label1: TLabel
    Left = 21
    Top = 21
    Width = 77
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'METERS'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 21
    Top = 188
    Width = 60
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'TESTS'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 617
    Top = 398
    Width = 119
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'REJECTIONS'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 21
    Top = 398
    Width = 145
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'CALIBRATIONS'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object IB_Grid1: TIB_Grid
    Left = 21
    Top = 52
    Width = 1162
    Height = 117
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    TabOrder = 0
    DefaultRowHeight = 22
  end
  object IB_Grid2: TIB_Grid
    Left = 21
    Top = 220
    Width = 1162
    Height = 157
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource2
    TabOrder = 1
    DefaultRowHeight = 22
  end
  object IB_Grid3: TIB_Grid
    Left = 617
    Top = 429
    Width = 566
    Height = 157
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource3
    TabOrder = 2
    DefaultRowHeight = 22
  end
  object IB_Grid4: TIB_Grid
    Left = 21
    Top = 429
    Width = 587
    Height = 157
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource4
    TabOrder = 3
    DefaultRowHeight = 22
  end
  object IB_UpdateBar1: TIB_UpdateBar
    Left = 105
    Top = 10
    Width = 155
    Height = 33
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 4
    DataSource = IB_DataSource1
    ReceiveFocus = False
    CustomGlyphsSupplied = []
  end
  object IB_UpdateBar2: TIB_UpdateBar
    Left = 94
    Top = 178
    Width = 155
    Height = 33
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 5
    DataSource = IB_DataSource2
    ReceiveFocus = False
    CustomGlyphsSupplied = []
  end
  object IB_UpdateBar3: TIB_UpdateBar
    Left = 753
    Top = 387
    Width = 155
    Height = 33
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 6
    DataSource = IB_DataSource3
    ReceiveFocus = False
    CustomGlyphsSupplied = []
  end
  object IB_UpdateBar4: TIB_UpdateBar
    Left = 167
    Top = 387
    Width = 155
    Height = 33
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 7
    DataSource = IB_DataSource4
    ReceiveFocus = False
    CustomGlyphsSupplied = []
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 72
    Top = 64
  end
  object IB_Query1: TIB_Query
    DatabaseName = '192.168.115.91:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select '
      ' *'
      'from METERS'
      'where'
      ' (calibrationid=:CI) and'
      ' (equipmentid=:EI) and'
      ' (serialnumber=:SN)'
      'for update')
    ColorScheme = True
    RequestLive = True
    Left = 40
    Top = 64
  end
  object IB_DataSource2: TIB_DataSource
    Dataset = IB_Query2
    Left = 64
    Top = 184
  end
  object IB_Query2: TIB_Query
    DatabaseName = '192.168.115.91:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select '
      ' *'
      'from TESTS'
      'where'
      ' (calibrationid=:CI) and'
      ' (equipmentid=:EI) and'
      ' (serialnumber=:SN)'
      'for update')
    ColorScheme = True
    RequestLive = True
    Left = 32
    Top = 184
  end
  object IB_Query3: TIB_Query
    DatabaseName = '192.168.115.91:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select '
      ' *'
      'from REJECTIONS'
      'where'
      ' (calibrationid=:CI) and'
      ' (equipmentid=:EI)'
      'for update')
    RequestLive = True
    Left = 488
    Top = 352
  end
  object IB_DataSource3: TIB_DataSource
    Dataset = IB_Query3
    Left = 520
    Top = 352
  end
  object IB_DataSource4: TIB_DataSource
    Dataset = IB_Query4
    Left = 64
    Top = 360
  end
  object IB_Query4: TIB_Query
    DatabaseName = '192.168.115.91:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select '
      ' *'
      'from CALIBRATIONS'
      'where'
      ' (calibrationid=:CI) and'
      ' (equipmentid=:EI)'
      'for update')
    RequestLive = True
    Left = 32
    Top = 360
  end
end
