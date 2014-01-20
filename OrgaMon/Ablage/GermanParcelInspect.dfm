object FormGermanParcelInspect: TFormGermanParcelInspect
  Left = 198
  Top = 130
  Caption = 'Sendungs Verfolgung'
  ClientHeight = 447
  ClientWidth = 847
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
  object Label3: TLabel
    Left = 6
    Top = 16
    Width = 59
    Height = 13
    Caption = 'Versender'
  end
  object SpeedButton8: TSpeedButton
    Left = 764
    Top = 12
    Width = 22
    Height = 22
    Hint = 'Importverzeichnis '#246'ffnen'
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFFFFFFFF
      009E9C009E9C009E9C009E9C009E9C009E9C009E9C009E9C009E9C009E9C009E
      9C009E9C000000000000FFFFFFFFFFFF009E9CFFFFFF9CCFFF9CFFFF9CCFFF9C
      FFFF9CCFFF9CCFFF9CCFFF9CCFFF63CFCE009E9C000000000000FFFFFF009E9C
      FFFFFF9CFFFF9CFFFF9CCFFF9CFFFF9CCFFF9CFFFF9CCFFF9CCFFF9CCFFF63CF
      CE000000009E9C000000FFFFFF009E9CFFFFFF9CFFFF9CFFFF9CFFFF9CFFFF9C
      FFFF9CCFFF9CFFFF9CCFFF9CCFFF009E9C000000009E9C000000009E9CFFFFFF
      9CFFFF9CFFFF9CFFFF9CFFFF9CCFFF9CFFFF9CFFFF9CCFFF9CFFFF63CFCE0000
      0063CFCE63CFCE000000009E9CFFFFFF9CFFFF9CFFFF9CFFFF9CFFFF9CFFFF9C
      FFFF9CCFFF9CFFFF9CCFFF63CFCE00000063CFCE63CFCE000000009E9C009E9C
      009E9C009E9C009E9C009E9C009E9C009E9C009E9C009E9C009E9C009E9C63CF
      CE9CFFFF63CFCE000000FFFFFF009E9CFFFFFF9CFFFF9CFFFF9CFFFF9CFFFF9C
      FFFF9CFFFF9CFFFF9CFFFF9CFFFF9CFFFF9CFFFF63CFCE000000FFFFFF009E9C
      FFFFFF9CFFFF9CFFFF9CFFFF9CFFFF9CFFFF9CFFFF9CFFFFFFFFFFFFFFFFFFFF
      FFFFFFFF63CFCE000000FFFFFF009E9CFFFFFF9CFFFF9CFFFF9CFFFF9CFFFF9C
      FFFFFFFFFF009E9C009E9C009E9C009E9C009E9C009E9CFFFFFFFFFFFFFFFFFF
      009E9CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF009E9CFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF009E9C009E9C009E9C009E9C00
      9E9CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    ParentShowHint = False
    ShowHint = True
    OnClick = SpeedButton8Click
  end
  object IB_Grid1: TIB_Grid
    Left = 0
    Top = 40
    Width = 839
    Height = 401
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    TabOrder = 0
  end
  object IB_NavigationBar1: TIB_NavigationBar
    Left = 463
    Top = 12
    Width = 120
    Height = 22
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    DataSource = IB_DataSource1
    ReceiveFocus = False
    CustomGlyphsSupplied = []
  end
  object Button1: TButton
    Left = 792
    Top = 12
    Width = 22
    Height = 22
    Hint = 'Zum Beleg springen'
    Caption = '&B'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = Button1Click
  end
  object IB_UpdateBar1: TIB_UpdateBar
    Left = 591
    Top = 12
    Width = 120
    Height = 22
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 3
    DataSource = IB_DataSource1
    ReceiveFocus = False
    CustomGlyphsSupplied = []
    VisibleButtons = [ubEdit, ubPost, ubCancel, ubRefreshAll]
  end
  object Button2: TButton
    Left = 817
    Top = 12
    Width = 22
    Height = 22
    Hint = 'Paket-IDs suchen und eintragen'
    Caption = 'C'
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Wingdings'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = Button2Click
  end
  object ComboBox1: TComboBox
    Left = 72
    Top = 13
    Width = 201
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    OnChange = ComboBox1Change
  end
  object Edit1: TEdit
    Left = 282
    Top = 13
    Width = 159
    Height = 21
    TabOrder = 6
    Text = 'Paket-ID'
    OnKeyPress = Edit1KeyPress
  end
  object IB_Query1: TIB_Query
    DatabaseName = 'fred:C:\hebu\HeBu001.gdb'
    FieldsDisplayLabel.Strings = (
      'AUSGANG=Labeldruck'
      'BELEG_R=BELEG'
      'TEILLIEFERUNG=TL')
    FieldsDisplayWidth.Strings = (
      'AUSGANG=130'
      'BELEG_R=60'
      'TEILLIEFERUNG=30')
    FieldsReadOnly.Strings = (
      'BELEG_R=NOEDIT'
      'TEILLIEFERUNG=NOEDIT')
    FieldsVisible.Strings = (
      'DB_KEY=FALSE')
    SQL.Strings = (
      'SELECT '
      '   BELEG_R'
      ' , TEILLIEFERUNG'
      ' , AUSGANG'
      ' , PAKETID'
      ' , RID'
      'FROM VERSAND'
      'WHERE VERSENDER_R=:CROSSREF AND'
      '      NOT(AUSGANG IS NULL) AND'
      '      PAKETID IS NULL'
      'ORDER BY AUSGANG'
      'FOR UPDATE')
    ColorScheme = True
    RequestLive = True
    Left = 24
    Top = 72
    ParamValues = (
      'CROSSREF=')
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 56
    Top = 72
  end
end
