object FormArtikelAAA: TFormArtikelAAA
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'FormArtikelAAA'
  ClientHeight = 144
  ClientWidth = 683
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object IB_Grid1: TIB_Grid
    Left = 0
    Top = 0
    Width = 683
    Height = 144
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    Align = alClient
    TabOrder = 0
    RowSelect = True
    ListBoxStyle = True
    OnCellDblClick = IB_Grid1CellDblClick
    OnGetCellProps = IB_Grid1GetCellProps
  end
  object IB_Query1: TIB_Query
    ColumnAttributes.Strings = (
      'EURO=CURRENCY'
      'ARTIKEL_AA.EURP=CURRENCY')
    DatabaseName = '192.168.115.6:test.fdb'
    FieldsDisplayLabel.Strings = (
      'NAME=Ausgabeart'
      'BASIS=Einheit'
      'EURO=Preis')
    FieldsDisplayWidth.Strings = (
      'NAME=420'
      'BASIS=100'
      'EURO=90')
    FieldsVisible.Strings = (
      'RID=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select'
      ' AUSGABEART.NAME,'
      ' ARTIKEL_AA.EURO,'
      ' ARTIKEL_AA.EURP,'
      ' COALESCE(EINHEIT.BASIS,'#39'komplett'#39') BASIS,'
      ' ARTIKEL_AA.RID,'
      ' PAPERCOLOR'
      'from'
      ' ARTIKEL_AA'
      'join'
      ' AUSGABEART'
      'on'
      ' (ARTIKEL_AA.AUSGABEART_R=AUSGABEART.RID)'
      'left join'
      ' EINHEIT'
      'on'
      ' (ARTIKEL_AA.EINHEIT_R=EINHEIT.RID)'
      'where'
      ' (ARTIKEL_AA.ARTIKEL_R=:CROSSREF)')
    ColorScheme = True
    ReadOnly = True
    BeforePrepare = IB_Query1BeforePrepare
    Left = 40
    Top = 40
    ParamValues = (
      'CROSSREF=')
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 120
    Top = 40
  end
end
