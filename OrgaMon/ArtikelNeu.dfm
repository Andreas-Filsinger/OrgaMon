object FormArtikelNeu: TFormArtikelNeu
  Left = 145
  Top = 155
  Caption = 'Artikel neu anlegen'
  ClientHeight = 220
  ClientWidth = 326
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
    Left = 2
    Top = 6
    Width = 168
    Height = 13
    Caption = 'Anlage in welches Sortiment?'
  end
  object Button1: TButton
    Left = 227
    Top = 192
    Width = 91
    Height = 25
    Caption = '&OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 131
    Top = 192
    Width = 89
    Height = 25
    Caption = 'A&bbrechen'
    TabOrder = 1
    OnClick = Button2Click
  end
  object IB_Grid1: TIB_Grid
    Left = 0
    Top = 24
    Width = 320
    Height = 161
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    TabOrder = 2
  end
  object IB_UpdateBar1: TIB_UpdateBar
    Left = 3
    Top = 192
    Width = 120
    Height = 25
    Flat = False
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 3
    DataSource = IB_DataSource1
    ReceiveFocus = False
    CustomGlyphsSupplied = []
    VisibleButtons = [ubEdit, ubPost, ubCancel, ubRefreshAll]
  end
  object IB_Query1: TIB_Query
    DatabaseName = '192.168.115.91:test.fdb'
    FieldsDisplayLabel.Strings = (
      'NAECHSTE_NUMMER=#')
    FieldsDisplayWidth.Strings = (
      'BEZEICHNUNG=200'
      'NAECHSTE_NUMMER=90')
    FieldsVisible.Strings = (
      'RID=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT BEZEICHNUNG'
      '     , RID'
      '     , NAECHSTE_NUMMER'
      'FROM SORTIMENT'
      'ORDER BY BEZEICHNUNG'
      'FOR UPDATE')
    KeyLinks.Strings = (
      'RID')
    KeyLinksAutoDefine = False
    KeyRelation = 'SORTIMENT'
    RefreshAction = raKeepDataPos
    RequestLive = True
    Left = 216
    Top = 8
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 248
    Top = 8
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 280
    Top = 8
  end
end
