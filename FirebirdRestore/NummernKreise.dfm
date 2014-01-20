object FormNummernKreise: TFormNummernKreise
  Left = 254
  Top = 129
  Width = 696
  Height = 480
  Caption = 'Nummern Kreise'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 160
    Top = 8
    Width = 121
    Height = 25
    Caption = 'Lese Werte'
    TabOrder = 0
    OnClick = Button1Click
  end
  object IB_Grid1: TIB_Grid
    Left = 24
    Top = 80
    Width = 233
    Height = 265
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    TabOrder = 1
  end
  object ListBox1: TListBox
    Left = 264
    Top = 80
    Width = 233
    Height = 265
    ItemHeight = 13
    TabOrder = 2
  end
  object IB_Query1: TIB_Query
    DatabaseName = '192.168.115.82:/freigabe/fdb/hebu/hebu.fdb'
    IB_Connection = DataModuleHeBu.IB_Connection1
    SQL.Strings = (
      'SELECT RDB$GENERATOR_NAME'
      'FROM RDB$GENERATORS'
      'WHERE RDB$SYSTEM_FLAG IS NULL')
    ColorScheme = False
    KeyLinks.Strings = (
      'RDB$GENERATOR_ID')
    KeyLinksAutoDefine = False
    KeyRelation = 'RDB$GENERATORS'
    MasterSearchFlags = [msfOpenMasterOnOpen, msfSearchAppliesToMasterOnly]
    ReadOnly = True
    BufferSynchroFlags = []
    FetchWholeRows = False
    Left = 40
    Top = 16
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 40
    Top = 48
  end
end
