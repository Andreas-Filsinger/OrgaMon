object FormArtikelRang: TFormArtikelRang
  Left = 11
  Top = 92
  Caption = 'Verkaufsrang'
  ClientHeight = 599
  ClientWidth = 991
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 457
    Top = 13
    Width = 36
    Height = 13
    Caption = 'Status'
  end
  object Button1: TButton
    Left = 272
    Top = 8
    Width = 177
    Height = 25
    Caption = 'Rang neu berechnen'
    TabOrder = 0
    OnClick = Button1Click
  end
  object IB_Grid1: TIB_Grid
    Left = 8
    Top = 40
    Width = 977
    Height = 545
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 184
    Top = 8
    Width = 22
    Height = 22
    Caption = '&A'
    TabOrder = 2
    OnClick = Button2Click
  end
  object IB_NavigationBar1: TIB_NavigationBar
    Left = 8
    Top = 8
    Width = 128
    Height = 25
    Flat = False
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 3
    DataSource = IB_DataSource1
    ReceiveFocus = False
    CustomGlyphsSupplied = []
  end
  object IB_UpdateBar1: TIB_UpdateBar
    Left = 144
    Top = 8
    Width = 33
    Height = 25
    Flat = False
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 4
    DataSource = IB_DataSource1
    ReceiveFocus = False
    CustomGlyphsSupplied = []
    VisibleButtons = [ubRefreshAll]
  end
  object Button3: TButton
    Left = 208
    Top = 8
    Width = 22
    Height = 22
    Caption = '&K'
    TabOrder = 5
    OnClick = Button3Click
  end
  object IB_Query1: TIB_Query
    DatabaseName = '192.168.115.25:test.fdb'
    FieldsVisible.Strings = (
      'RID=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select'
      ' rang,'
      ' numero,'
      ' titel,'
      ' menge,'
      ' mindestbestand,'
      ' rid'
      'from '
      ' artikel'
      'order by '
      ' rang')
    OrderingItems.Strings = (
      'RANG=RANG;RANG DESC'
      'NUMERO=NUMERO;NUMERO DESC'
      'TITEL=TITEL;TITEL DESC'
      'MENGE=MENGE;MENGE DESC'
      'MINDESTBESTAND=MINDESTBESTAND;MINDESTBESTAND DESC')
    OrderingLinks.Strings = (
      'RANG=ITEM=1'
      'NUMERO=ITEM=2'
      'TITEL=ITEM=3'
      'MENGE=ITEM=4'
      'MINDESTBESTAND=ITEM=5')
    Left = 40
    Top = 96
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 88
    Top = 96
  end
end
