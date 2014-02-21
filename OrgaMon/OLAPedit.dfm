object FormOLAPedit: TFormOLAPedit
  Left = 8
  Top = 155
  Caption = 'Eichraum: einzelner Datensatz'
  ClientHeight = 480
  ClientWidth = 914
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 56
    Height = 16
    Caption = 'METERS'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 144
    Width = 43
    Height = 16
    Caption = 'TESTS'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 472
    Top = 304
    Width = 88
    Height = 16
    Caption = 'REJECTIONS'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 16
    Top = 304
    Width = 107
    Height = 16
    Caption = 'CALIBRATIONS'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object IB_Grid1: TIB_Grid
    Left = 16
    Top = 40
    Width = 889
    Height = 89
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    TabOrder = 0
  end
  object IB_Grid2: TIB_Grid
    Left = 16
    Top = 168
    Width = 889
    Height = 120
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource2
    TabOrder = 1
  end
  object IB_Grid3: TIB_Grid
    Left = 472
    Top = 328
    Width = 433
    Height = 120
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource3
    TabOrder = 2
  end
  object IB_Grid4: TIB_Grid
    Left = 16
    Top = 328
    Width = 449
    Height = 120
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource4
    TabOrder = 3
  end
  object IB_UpdateBar1: TIB_UpdateBar
    Left = 80
    Top = 8
    Width = 115
    Height = 25
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 4
    DataSource = IB_DataSource1
    ReceiveFocus = False
    CustomGlyphsSupplied = []
  end
  object IB_UpdateBar2: TIB_UpdateBar
    Left = 72
    Top = 136
    Width = 115
    Height = 25
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 5
    DataSource = IB_DataSource2
    ReceiveFocus = False
    CustomGlyphsSupplied = []
  end
  object IB_UpdateBar3: TIB_UpdateBar
    Left = 576
    Top = 296
    Width = 115
    Height = 25
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 6
    DataSource = IB_DataSource3
    ReceiveFocus = False
    CustomGlyphsSupplied = []
  end
  object IB_UpdateBar4: TIB_UpdateBar
    Left = 128
    Top = 296
    Width = 115
    Height = 25
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
    DatabaseName = '192.168.115.25:test.fdb'
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
    DatabaseName = '192.168.115.25:test.fdb'
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
    DatabaseName = '192.168.115.25:test.fdb'
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
    DatabaseName = '192.168.115.25:test.fdb'
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
