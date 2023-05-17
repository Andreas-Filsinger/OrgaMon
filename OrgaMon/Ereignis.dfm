object FormEreignis: TFormEreignis
  Left = 34
  Top = 153
  Caption = 'Ereignisse'
  ClientHeight = 374
  ClientWidth = 950
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  DesignSize = (
    950
    374)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 553
    Top = 16
    Width = 37
    Height = 13
    Caption = 'Label1'
  end
  object IB_Grid1: TIB_Grid
    Left = 0
    Top = 40
    Width = 943
    Height = 229
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    IndicateLongCellText = True
    DrawCellTextOptions = [gdtEllipsis, gdtShowTextBlob]
  end
  object Button1: TButton
    Left = 844
    Top = 12
    Width = 21
    Height = 21
    Caption = '&A'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 871
    Top = 12
    Width = 22
    Height = 21
    Caption = '&B'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 897
    Top = 12
    Width = 22
    Height = 21
    Caption = '&P'
    TabOrder = 3
    OnClick = Button3Click
  end
  object IB_SearchBar1: TIB_SearchBar
    Left = 7
    Top = 7
    Width = 120
    Height = 26
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 4
    DataSource = IB_DataSource1
    ReceiveFocus = False
    CustomGlyphsSupplied = []
  end
  object IB_NavigationBar1: TIB_NavigationBar
    Left = 137
    Top = 7
    Width = 116
    Height = 26
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 5
    DataSource = IB_DataSource1
    ReceiveFocus = False
    CustomGlyphsSupplied = []
  end
  object IB_UpdateBar1: TIB_UpdateBar
    Left = 264
    Top = 7
    Width = 132
    Height = 26
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 6
    DataSource = IB_DataSource1
    ReceiveFocus = False
    CustomGlyphsSupplied = []
    VisibleButtons = [ubDelete, ubPost, ubCancel, ubRefreshAll]
  end
  object Button4: TButton
    Left = 923
    Top = 12
    Width = 22
    Height = 21
    Caption = '&O'
    TabOrder = 7
    OnClick = Button4Click
  end
  object Button11: TButton
    Left = 717
    Top = 12
    Width = 22
    Height = 21
    Hint = 'aus Ereignis einen Beleg erstellen'
    Caption = '*'
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Wingdings'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    OnClick = Button11Click
  end
  object CheckBox1: TCheckBox
    Left = 745
    Top = 17
    Width = 65
    Height = 17
    Caption = 'drucken'
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object IB_Memo1: TIB_Memo
    Left = 0
    Top = 266
    Width = 950
    Height = 108
    DataField = 'INFO'
    DataSource = IB_DataSource1
    Align = alBottom
    TabOrder = 10
    AutoSize = False
  end
  object IB_Query1: TIB_Query
    DatabaseName = '192.168.115.6:test.fdb'
    FieldsDisplayLabel.Strings = (
      'ART=Art'
      'ZUSAMMENHANG=Zusammenhang')
    FieldsDisplayWidth.Strings = (
      'INFO=450'
      'ART=25'
      'AUFTRITT=129'
      'ZUSAMMENHANG=87')
    FieldsReadOnly.Strings = (
      'RID=TRUE')
    FieldsVisible.Strings = (
      'POSTEN_R=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT '
      '       AUFTRITT'
      '     , ART'
      '     , BEENDET'
      '     , MENGE'
      '     , ZUSAMMENHANG'
      '     , INFO'
      '     , ARTIKEL_R'
      '     , AUSGABEART_R'
      '     , PERSON_R'
      '     , BELEG_R'
      '     , POSTEN_R'
      '     , BBELEG_R'
      '     , BPOSTEN_R'
      '     , LAGER_R'
      '     , VERSAND_R'
      '     , RID'
      '     , BEARBEITER_R'
      '     , TICKET_R'
      'FROM '
      ' EREIGNIS'
      'ORDER '
      ' BY AUFTRITT DESC'
      'FOR UPDATE')
    ColorScheme = True
    RequestLive = True
    AfterScroll = IB_Query1AfterScroll
    Left = 24
    Top = 64
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 96
    Top = 64
  end
  object Timer1: TTimer
    Interval = 1333
    OnTimer = Timer1Timer
    Left = 24
    Top = 120
  end
end
