object FormPreisCode: TFormPreisCode
  Left = 92
  Top = 20
  Caption = 'Preis Codes'
  ClientHeight = 679
  ClientWidth = 702
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 697
    Height = 81
    TabOrder = 0
    object Label1: TLabel
      Left = 288
      Top = 56
      Width = 43
      Height = 13
      Caption = 'Label1'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object IB_NavigationBar1: TIB_NavigationBar
      Left = 136
      Top = 8
      Width = 116
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      DataSource = IB_DataSource1
      ReceiveFocus = False
      CustomGlyphsSupplied = []
    end
    object IB_UpdateBar1: TIB_UpdateBar
      Left = 264
      Top = 8
      Width = 156
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      DataSource = IB_DataSource1
      ReceiveFocus = False
      CustomGlyphsSupplied = []
      VisibleButtons = [ubEdit, ubInsert, ubDelete, ubPost, ubCancel, ubRefreshAll]
    end
    object IB_SearchBar1: TIB_SearchBar
      Left = 8
      Top = 8
      Width = 120
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 2
      DataSource = IB_DataSource1
      ReceiveFocus = False
      CustomGlyphsSupplied = []
    end
    object Button1: TButton
      Left = 440
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Clone'
      TabOrder = 3
      OnClick = Button1Click
    end
  end
  object IB_Grid1: TIB_Grid
    Left = 0
    Top = 80
    Width = 697
    Height = 585
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    TabOrder = 1
  end
  object IB_Query1: TIB_Query
    DatabaseName = '192.168.115.91:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT '
      '       RID'
      '     , VERLAG_R'
      '     , CODE'
      '     , ART'
      '     , WAEHRUNG_R'
      '     , PREIS'
      '     , USD'
      '     , EURO '
      '     , ALIAS_R'
      'FROM '
      ' PREIS'
      'ORDER '
      ' BY VERLAG_R,CODE,ART,WAEHRUNG_R'
      'FOR UPDATE')
    ColorScheme = True
    OrderingItems.Strings = (
      'CODE=CODE;CODE DESC'
      'PREIS=PREIS;PREIS DESC'
      'WAEHRUNG_R=WAEHRUNG_R;WAEHRUNG_R DESC'
      'VERLAG_R=VERLAG_R;VERLAG_R DESC'
      'ART=ART;ART DESC')
    OrderingLinks.Strings = (
      'CODE=1'
      'PREIS=2'
      'WAEHRUNG_R=3'
      'VERLAG_R=4'
      'ART=5')
    RequestLive = True
    AfterPost = IB_Query1AfterPost
    AfterScroll = IB_Query1AfterScroll
    BeforePost = IB_Query1BeforePost
    Left = 32
    Top = 136
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 80
    Top = 136
  end
end
