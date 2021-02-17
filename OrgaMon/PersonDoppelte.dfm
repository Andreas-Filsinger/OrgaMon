object FormPersonDoppelte: TFormPersonDoppelte
  Left = 214
  Top = 256
  Caption = 'Doppelte Personen'
  ClientHeight = 501
  ClientWidth = 798
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
  object Label1: TLabel
    Left = 40
    Top = 200
    Width = 37
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 40
    Top = 216
    Width = 37
    Height = 13
    Caption = 'Label2'
  end
  object ListBox1: TListBox
    Left = 0
    Top = 336
    Width = 433
    Height = 156
    ItemHeight = 13
    TabOrder = 0
  end
  object Button1: TButton
    Left = 456
    Top = 472
    Width = 75
    Height = 25
    Caption = 'Delete!'
    TabOrder = 1
    OnClick = Button1Click
  end
  object ProgressBar1: TProgressBar
    Left = 16
    Top = 312
    Width = 150
    Height = 16
    TabOrder = 2
  end
  object Button2: TButton
    Left = 184
    Top = 300
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 3
    OnClick = Button2Click
  end
  object IB_Grid1: TIB_Grid
    Left = 0
    Top = 56
    Width = 689
    Height = 129
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    TabOrder = 4
  end
  object IB_Edit1: TIB_Edit
    Left = 592
    Top = 288
    Width = 121
    Height = 21
    DataField = 'VORNAME'
    DataSource = IB_DataSource2
    TabOrder = 5
  end
  object IB_Edit2: TIB_Edit
    Left = 592
    Top = 312
    Width = 121
    Height = 21
    DataField = 'NACHNAME'
    DataSource = IB_DataSource2
    TabOrder = 6
  end
  object IB_Edit3: TIB_Edit
    Left = 592
    Top = 264
    Width = 121
    Height = 21
    DataField = 'NUMMER'
    DataSource = IB_DataSource2
    TabOrder = 7
  end
  object IB_Memo1: TIB_Memo
    Left = 592
    Top = 336
    Width = 185
    Height = 161
    DataField = 'BEMERKUNG'
    DataSource = IB_DataSource2
    TabOrder = 8
    AutoSize = False
  end
  object IB_SearchBar1: TIB_SearchBar
    Left = 56
    Top = 8
    Width = 120
    Height = 25
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 9
    DataSource = IB_DataSource1
    ReceiveFocus = False
    CustomGlyphsSupplied = []
  end
  object IB_NavigationBar1: TIB_NavigationBar
    Left = 192
    Top = 8
    Width = 120
    Height = 25
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 10
    DataSource = IB_DataSource1
    ReceiveFocus = False
    CustomGlyphsSupplied = []
  end
  object IB_UpdateBar1: TIB_UpdateBar
    Left = 344
    Top = 8
    Width = 120
    Height = 25
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 11
    DataSource = IB_DataSource1
    ReceiveFocus = False
    CustomGlyphsSupplied = []
  end
  object Button3: TButton
    Left = 464
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Load'
    TabOrder = 12
    OnClick = Button3Click
  end
  object IB_Query1: TIB_Query
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT'
      '       STATE'
      '     , PLZ'
      '     , STRASSE'
      '     , ORT '
      '     , RID'
      'FROM ANSCHRIFT'
      'ORDER BY STATE, PLZ, STRASSE'
      'FOR UPDATE')
    ColorScheme = True
    KeyLinks.Strings = (
      'RID')
    KeyLinksAutoDefine = False
    KeyRelation = 'ANSCHRIFT'
    RequestLive = True
    AfterScroll = IB_Query1AfterScroll
    Left = 504
    Top = 24
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 536
    Top = 24
  end
  object IB_Query2: TIB_Query
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT *'
      'FROM PERSON'
      'WHERE PRIV_ANSCHRIFT_R=:CROSSREF'
      'FOR UPDATE')
    ColorScheme = True
    KeyLinks.Strings = (
      'RID')
    KeyLinksAutoDefine = False
    KeyRelation = 'PERSON'
    RequestLive = True
    Left = 616
    Top = 224
    ParamValues = (
      'CROSSREF=21000')
  end
  object IB_DataSource2: TIB_DataSource
    Dataset = IB_Query2
    Left = 648
    Top = 224
  end
  object IB_Query3: TIB_Query
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT *'
      'FROM ANSCHRIFT'
      'WHERE RID=:CROSSREF'
      'FOR update')
    RequestLive = True
    Left = 464
    Top = 208
    ParamValues = (
      'CROSSREF=')
  end
end
