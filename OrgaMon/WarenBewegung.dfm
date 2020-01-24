object FormWarenBewegung: TFormWarenBewegung
  Left = 0
  Top = 90
  Caption = 'FormWarenBewegung'
  ClientHeight = 563
  ClientWidth = 1019
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 2
    Top = 0
    Width = 1017
    Height = 41
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 531
      Top = 10
      Width = 23
      Height = 22
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
        00000000FFFF00FFFF00FFFF00FFFF00FFFF0000000000000000000000000000
        00000000000000FFFFFFFFFFFFFFFFFF00000000FFFFC0C0C000FFFFC0C0C000
        FFFF000000FFFFFF000000808080FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF
        000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBF0000000000008080800000008080
        80FFFFFF000000FFFFFFFFFFFFFFFFFF000000BFBFBF000000BFBFBF000000BF
        BFBF000000000000FFFFFFFFFFFF000000808080000000FFFFFFFFFFFFFFFFFF
        000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBF000000FFFFFFFFFFFFFFFFFFFFFF
        FF000000000000FFFFFFFFFFFFFFFFFF000000BFBFBF000000BFBFBF00000000
        0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF
        000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBF0000000000000000000000000000
        00000000000000FFFFFFFFFFFFFFFFFF000000BFBFBF000000BFBFBF000000BF
        BFBF000000BFBFBF000000BFBFBF000000FFFFFFFFFFFFFFFFFFFFFFFF000000
        BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
        BF000000FFFFFFFFFFFFFFFFFF000000BFBFBF00000000000000000000000000
        0000000000000000000000000000BFBFBF000000FFFFFFFFFFFFFFFFFF000000
        BFBFBF000000000000000000000000000000000000000000000000000000BFBF
        BF000000FFFFFFFFFFFFFFFFFF000000BFBFBF00000000000000000000000000
        0000000000000000000000000000BFBFBF000000FFFFFFFFFFFFFFFFFF000000
        BFBFBF000000000000000000000000000000000000000000000000000000BFBF
        BF000000FFFFFFFFFFFFFFFFFF000000BFBFBF00000000000000000000000000
        0000000000000000000000000000BFBFBF000000FFFFFFFFFFFFFFFFFF000000
        BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
        BF000000FFFFFFFFFFFFFFFFFF7F7F7F00000000000000000000000000000000
        00000000000000000000000000000000007F7F7FFFFFFFFFFFFF}
      OnClick = SpeedButton1Click
    end
    object Label1: TLabel
      Left = 2
      Top = 24
      Width = 94
      Height = 13
      Caption = 'Warenbewegung'
    end
    object IB_NavigationBar1: TIB_NavigationBar
      Left = 192
      Top = 8
      Width = 120
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      DataSource = IB_DataSource1
      ReceiveFocus = False
      CustomGlyphsSupplied = []
    end
    object IB_UpdateBar1: TIB_UpdateBar
      Left = 320
      Top = 8
      Width = 204
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      DataSource = IB_DataSource1
      ReceiveFocus = False
      CustomGlyphsSupplied = []
      VisibleButtons = [ubEdit, ubInsert, ubDelete, ubPost, ubCancel, ubRefreshAll]
    end
    object Button8: TButton
      Left = 587
      Top = 7
      Width = 22
      Height = 22
      Caption = '&A'
      TabOrder = 2
      OnClick = Button8Click
    end
    object Button1: TButton
      Left = 611
      Top = 7
      Width = 22
      Height = 22
      Caption = '&O'
      TabOrder = 3
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 635
      Top = 7
      Width = 22
      Height = 22
      Caption = '&B'
      TabOrder = 4
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 659
      Top = 7
      Width = 22
      Height = 22
      Caption = '&P'
      TabOrder = 5
      OnClick = Button3Click
    end
  end
  object IB_Grid1: TIB_Grid
    Left = 0
    Top = 41
    Width = 1017
    Height = 224
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    PreventDeleting = True
    TabOrder = 1
  end
  object IB_Grid2: TIB_Grid
    Left = 0
    Top = 304
    Width = 1017
    Height = 177
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource2
    PreventDeleting = True
    TabOrder = 2
    IndicateLongCellText = True
    DrawCellTextOptions = [gdtEllipsis, gdtShowTextBlob]
  end
  object Panel2: TPanel
    Left = 0
    Top = 264
    Width = 1017
    Height = 41
    TabOrder = 3
    object Label2: TLabel
      Left = 2
      Top = 24
      Width = 45
      Height = 13
      Caption = 'Ereignis'
    end
    object Button4: TButton
      Left = 587
      Top = 7
      Width = 22
      Height = 22
      Caption = '&A'
      TabOrder = 0
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 611
      Top = 7
      Width = 22
      Height = 22
      Caption = '&O'
      TabOrder = 1
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 635
      Top = 7
      Width = 22
      Height = 22
      Caption = '&B'
      TabOrder = 2
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 659
      Top = 7
      Width = 22
      Height = 22
      Caption = '&P'
      TabOrder = 3
      OnClick = Button7Click
    end
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 56
    Top = 64
  end
  object IB_Query1: TIB_Query
    ColumnAttributes.Strings = (
      'BEWEGT=BOOLEAN=Y,N'
      'ALTERNATIV=BOOLEAN='#39'Y,N'#39)
    DatabaseName = '192.168.115.1:test.fdb'
    FieldsDisplayLabel.Strings = (
      'AUSGABEART_R=AA'
      'ARTIKEL=Titel'
      'BEWEGT=OK'
      'MENGE=ANZ'
      'ALTERNATIV=A')
    FieldsGridTitleHint.Strings = (
      'ALTERNATIV=Alternativ Lager')
    FieldsDisplayWidth.Strings = (
      'AUSGABEART_R=25'
      'ARTIKEL=120'
      'BEWEGT=22'
      'MENGE=30'
      'LAGER=60'
      'ZIEL=60'
      'BRISANZ=30'
      'MENGE_BISHER=30'
      'MENGE_NEU=30'
      'ALTERNATIV=14')
    FieldsVisible.Strings = (
      'POSTEN_R=FALSE'
      'BPOSTEN_R=FALSE'
      'PERSON_R=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select '
      '       MENGE'
      '     , BEWEGT'
      '     , BRISANZ'
      '     , AUSGABEART_R'
      
        '     , (SELECT ARTIKEL.TITEL FROM ARTIKEL WHERE RID=WARENBEWEGUN' +
        'G.ARTIKEL_R) ARTIKEL'
      
        '     , (SELECT LAGER.NAME FROM LAGER WHERE RID=WARENBEWEGUNG.LAG' +
        'ER_R) LAGER'
      
        '     , (SELECT LAGER.NAME FROM LAGER WHERE RID=(SELECT LAGER_R F' +
        'ROM BELEG WHERE RID=WARENBEWEGUNG.BELEG_R)) ZIEL '
      '     , MENGE_BISHER'
      '     , MENGE_NEU'
      '     , ALTERNATIV'
      '     , ZUSAMMENHANG'
      '     , AUFTRITT'
      '     , RID'
      '     , ARTIKEL_R'
      '     , BELEG_R'
      '     , POSTEN_R'
      '     , BBELEG_R'
      '     , BPOSTEN_R'
      
        '     , (SELECT BELEG.PERSON_R FROM BELEG WHERE RID=WARENBEWEGUNG' +
        '.BELEG_R) PERSON_R'
      'FROM '
      ' WARENBEWEGUNG'
      'order by'
      ' RID descending')
    ColorScheme = True
    OrderingItems.Strings = (
      'RID=RID;RID DESC'
      'ARTIKEL_R=ARTIKEL_R;ARTIKEL_R DESC'
      'BELEG_R=BELEG_R;BELEG_R DESC'
      'BBELEG_R=BBELEG_R;BBELEG_R DESC'
      'POSTEN_R=POSTEN_R;POSTEN_R DESC'
      'BPOSTEN_R=BPOSTEN_R;BPOSTEN_R DESC'
      'MENGE_BISHER=MENGE_BISHER;MENGE_BISHER DESC'
      'MENGE_NEU=MENGE_NEU;MENGE_NEU DESC'
      'BRISANZ=BRISANZ;BRISANZ DESC'
      'ZUSAMMENHANG=ZUSAMMENHANG;ZUSAMMENHANG DESC'
      'AUFTRITT=AUFTRITT;AUFTRITT DESC'
      'AA=AUSGABEART_R;AUSGABEART_R DESC'
      'ANZ=MENGE;MENGE DESC'
      'OK=BEWEGT;BEWEGT DESC')
    OrderingLinks.Strings = (
      'RID=ITEM=1'
      'ARTIKEL_R=ITEM=2'
      'BELEG_R=ITEM=3'
      'BBELEG_R=ITEM=4'
      'POSTEN_R=ITEM=5'
      'BPOSTEN_R=ITEM=6'
      'MENGE_BISHER=ITEM=7'
      'MENGE_NEU=ITEM=8'
      'BRISANZ=ITEM=9'
      'ZUSAMMENHANG=ITEM=10'
      'AUFTRITT=ITEM=11'
      'AUSGABEART_R=ITEM=12'
      'MENGE=ITEM=13'
      'BEWEGT=ITEM=14')
    AfterScroll = IB_Query1AfterScroll
    Left = 24
    Top = 64
  end
  object IB_DSQL1: TIB_DSQL
    DatabaseName = '192.168.115.1:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'UPDATE '
      ' WARENBEWEGUNG'
      'SET'
      ' BEWEGT='#39'Y'#39
      'WHERE'
      ' (BELEG_R=:CROSSREF);')
    Left = 152
    Top = 64
  end
  object IB_Query2: TIB_Query
    DatabaseName = '192.168.115.1:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select * from ereignis where zusammenhang=:CROSSREF'
      'order by rid')
    ColorScheme = True
    AfterScroll = IB_Query2AfterScroll
    Left = 24
    Top = 344
  end
  object IB_DataSource2: TIB_DataSource
    Dataset = IB_Query2
    Left = 112
    Top = 344
  end
end
