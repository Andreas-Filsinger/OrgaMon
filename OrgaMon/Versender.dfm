object FormVersender: TFormVersender
  Left = 101
  Top = 147
  Caption = 'Versand'
  ClientHeight = 484
  ClientWidth = 746
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  PixelsPerInch = 109
  TextHeight = 14
  object Label3: TLabel
    Left = 9
    Top = 168
    Width = 169
    Height = 14
    Caption = 'Parameter des Versenders'
  end
  object Label1: TLabel
    Left = 9
    Top = 11
    Width = 65
    Height = 14
    Caption = 'Versender'
  end
  object Label2: TLabel
    Left = 9
    Top = 320
    Width = 57
    Height = 14
    Caption = 'Packform'
  end
  object IB_Grid1: TIB_Grid
    Left = 0
    Top = 34
    Width = 742
    Height = 130
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    TabOrder = 0
    DefaultRowHeight = 18
  end
  object IB_Grid2: TIB_Grid
    Left = 0
    Top = 345
    Width = 742
    Height = 130
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource2
    TabOrder = 1
    DefaultRowHeight = 18
  end
  object IB_Memo1: TIB_Memo
    Left = 0
    Top = 190
    Width = 742
    Height = 113
    DataField = 'INTERNINFO'
    DataSource = IB_DataSource1
    TabOrder = 2
    AutoSize = False
  end
  object IB_UpdateBar1: TIB_UpdateBar
    Left = 250
    Top = 6
    Width = 210
    Height = 24
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 3
    DataSource = IB_DataSource1
    ReceiveFocus = False
    CustomGlyphsSupplied = []
    VisibleButtons = [ubEdit, ubInsert, ubDelete, ubPost, ubCancel, ubRefreshAll]
  end
  object IB_NavigationBar1: TIB_NavigationBar
    Left = 112
    Top = 6
    Width = 128
    Height = 24
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 4
    DataSource = IB_DataSource1
    ReceiveFocus = False
    CustomGlyphsSupplied = []
  end
  object Button1: TButton
    Left = 568
    Top = 6
    Width = 23
    Height = 24
    Caption = '&P'
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 543
    Top = 6
    Width = 23
    Height = 24
    Hint = 'Unten markierte Form als Standard '#252'bernehmen'
    Caption = '&V'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnClick = Button2Click
  end
  object IB_NavigationBar2: TIB_NavigationBar
    Left = 112
    Top = 313
    Width = 128
    Height = 27
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 7
    DataSource = IB_DataSource2
    ReceiveFocus = False
    CustomGlyphsSupplied = []
  end
  object IB_UpdateBar2: TIB_UpdateBar
    Left = 250
    Top = 313
    Width = 210
    Height = 27
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 8
    DataSource = IB_DataSource2
    ReceiveFocus = False
    CustomGlyphsSupplied = []
    VisibleButtons = [ubEdit, ubInsert, ubDelete, ubPost, ubCancel, ubRefreshAll]
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 656
  end
  object IB_Query1: TIB_Query
    ColumnAttributes.Strings = (
      'STANDARD=BOOLEAN=Y,N')
    DatabaseName = '192.168.115.91:test.fdb'
    FieldsVisible.Strings = (
      'INTERNINFO=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT '
      '       STANDARD'
      '     , RID'
      '     , BEZEICHNUNG'
      '     , PERSON_R'
      '     , LOGO'
      '     , VERFOLGUNG'
      '     , EXPORTPFAD'
      '     , IMPORTPFAD'
      '     , EXPORTTYP'
      '     , INTERNINFO'
      '     , PACKFORM_R'
      'FROM VERSENDER'
      'ORDER BY RID'
      'FOR UPDATE')
    ColorScheme = True
    RequestLive = True
    BeforePost = IB_Query1BeforePost
    Left = 624
  end
  object IB_Query2: TIB_Query
    DatabaseName = '192.168.115.91:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT *'
      'FROM PACKFORM'
      'FOR UPDATE')
    ColorScheme = True
    RequestLive = True
    BeforePost = IB_Query2BeforePost
    Left = 624
    Top = 160
  end
  object IB_DataSource2: TIB_DataSource
    Dataset = IB_Query2
    Left = 656
    Top = 160
  end
end
