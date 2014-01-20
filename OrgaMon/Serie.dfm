object FormSerie: TFormSerie
  Left = 274
  Top = 165
  Caption = 'Serie'
  ClientHeight = 455
  ClientWidth = 688
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
  object IB_Grid1: TIB_Grid
    Left = 0
    Top = 43
    Width = 688
    Height = 412
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    Align = alBottom
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 41
    Align = alTop
    TabOrder = 1
    object IB_NavigationBar1: TIB_NavigationBar
      Left = 144
      Top = 8
      Width = 88
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      DataSource = IB_DataSource1
      ReceiveFocus = False
      CustomGlyphsSupplied = []
    end
    object IB_UpdateBar1: TIB_UpdateBar
      Left = 241
      Top = 8
      Width = 132
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
      Left = 16
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
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 634
    Top = 3
  end
  object IB_Query1: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED')
    DatabaseName = '192.168.115.91:test.fdb'
    FieldsGridLabel.Strings = (
      'TITEL=Bezeichnung der Serie')
    FieldsDisplayWidth.Strings = (
      'TITEL=500')
    FieldsReadOnly.Strings = (
      'RID=TRUE;NOEDIT;NOINSERT;NOSEARCH')
    FieldsVisible.Strings = (
      'RID=TRUE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT TITEL'
      '     , RID'
      'FROM SERIE'
      'FOR UPDATE')
    ColorScheme = True
    KeyLinks.Strings = (
      'RID')
    KeyLinksAutoDefine = False
    KeyRelation = 'SERIE'
    OrderingItemNo = 1
    OrderingItems.Strings = (
      'Name=TITEL; TITEL DESC')
    OrderingLinks.Strings = (
      'TITEL=1')
    RequestLive = True
    FetchWholeRows = False
    Left = 602
    Top = 3
  end
end
