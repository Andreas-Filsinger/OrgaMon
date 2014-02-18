object FormInventur: TFormInventur
  Left = 4
  Top = 4
  Caption = 'Inventur'
  ClientHeight = 541
  ClientWidth = 788
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 788
    Height = 541
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Durchf'#252'hrung'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label7: TLabel
        Left = 12
        Top = 3
        Width = 80
        Height = 13
        Caption = 'InventurBlock'
      end
      object Label8: TLabel
        Left = 419
        Top = 473
        Width = 68
        Height = 20
        Caption = '&MENGE'
        FocusControl = Edit2
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 602
        Top = 473
        Width = 72
        Height = 20
        Caption = 'LABELS'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object IB_Grid1: TIB_Grid
        Left = 0
        Top = 56
        Width = 777
        Height = 409
        CustomGlyphsSupplied = []
        DataSource = IB_DataSource1
        TabOrder = 0
      end
      object ComboBox1: TComboBox
        Left = 104
        Top = 0
        Width = 265
        Height = 21
        Style = csDropDownList
        TabOrder = 1
      end
      object Button11: TButton
        Left = 372
        Top = 1
        Width = 21
        Height = 20
        Hint = 'aktualisieren'
        Caption = #200
        Font.Charset = SYMBOL_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = Button11Click
      end
      object Edit3: TEdit
        Left = 675
        Top = 467
        Width = 102
        Height = 28
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnKeyPress = Edit3KeyPress
      end
      object Edit2: TEdit
        Left = 493
        Top = 469
        Width = 99
        Height = 28
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnKeyPress = Edit2KeyPress
      end
      object ProgressBar1: TProgressBar
        Left = 449
        Top = 5
        Width = 216
        Height = 16
        TabOrder = 5
      end
      object IB_SearchBar1: TIB_SearchBar
        Left = 136
        Top = 23
        Width = 120
        Height = 25
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 6
        DataSource = IB_DataSource1
        ReceiveFocus = False
        CustomGlyphsSupplied = []
      end
      object IB_NavigationBar1: TIB_NavigationBar
        Left = 264
        Top = 23
        Width = 116
        Height = 25
        Flat = False
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 7
        DataSource = IB_DataSource1
        ReceiveFocus = False
        CustomGlyphsSupplied = []
      end
      object IB_UpdateBar1: TIB_UpdateBar
        Left = 392
        Top = 23
        Width = 108
        Height = 25
        Flat = False
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 8
        DataSource = IB_DataSource1
        ReceiveFocus = False
        CustomGlyphsSupplied = []
        VisibleButtons = [ubEdit, ubPost, ubCancel, ubRefreshAll]
      end
      object Button1: TButton
        Left = 8
        Top = 23
        Width = 113
        Height = 25
        Caption = 'bearbeiten'
        TabOrder = 9
        OnClick = Button1Click
      end
      object CheckBox3: TCheckBox
        Left = 416
        Top = 496
        Width = 257
        Height = 17
        Caption = 'LABEL menge mit "0" vorbelegen'
        Checked = True
        State = cbChecked
        TabOrder = 10
      end
      object Button14: TButton
        Left = 756
        Top = 34
        Width = 22
        Height = 22
        Hint = 'Springe zum Artikel, der unten markiert ist'
        Caption = '&A'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
        OnClick = Button14Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Auswertungen'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 237
        Height = 25
        Caption = 'OrgaMon'#8482' Inventur'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Panel2: TPanel
        Left = 8
        Top = 56
        Width = 369
        Height = 41
        TabOrder = 0
        object Button3: TButton
          Left = 49
          Top = 12
          Width = 75
          Height = 21
          Caption = 'auswerten'
          TabOrder = 0
          OnClick = Button3Click
        end
        object ProgressBar2: TProgressBar
          Left = 144
          Top = 4
          Width = 177
          Height = 16
          TabOrder = 1
        end
        object CheckBox1: TCheckBox
          Left = 144
          Top = 22
          Width = 113
          Height = 17
          Caption = 'mehr Angaben'
          TabOrder = 2
        end
        object Button4: TButton
          Left = 8
          Top = 8
          Width = 33
          Height = 25
          Caption = 'SQL'
          TabOrder = 3
          OnClick = Button4Click
        end
        object CheckBox2: TCheckBox
          Left = 270
          Top = 23
          Width = 46
          Height = 17
          Caption = 'TAB'
          TabOrder = 4
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Definition'
      ImageIndex = 1
      object Label3: TLabel
        Left = -1
        Top = 8
        Width = 91
        Height = 13
        Caption = 'Inventur Bl'#246'cke'
      end
      object Label4: TLabel
        Left = -1
        Top = 120
        Width = 112
        Height = 13
        Caption = 'zugeordnete Artikel'
      end
      object Label5: TLabel
        Left = -1
        Top = 303
        Width = 74
        Height = 13
        Caption = 'Artikel suche'
      end
      object Label6: TLabel
        Left = 103
        Top = 302
        Width = 7
        Height = 13
        Caption = '0'
      end
      object Label2: TLabel
        Left = -1
        Top = 477
        Width = 38
        Height = 13
        Caption = 'suche:'
      end
      object Label10: TLabel
        Left = 194
        Top = 475
        Width = 57
        Height = 13
        Caption = 'von Lager'
      end
      object Label11: TLabel
        Left = 336
        Top = 476
        Width = 52
        Height = 13
        Caption = 'bis Lager'
      end
      object Label12: TLabel
        Left = 540
        Top = 475
        Width = 37
        Height = 13
        Caption = 'Verlag'
      end
      object IB_Grid2: TIB_Grid
        Left = 0
        Top = 31
        Width = 585
        Height = 81
        CustomGlyphsSupplied = []
        DataSource = IB_DataSource_Inventur
        TabOrder = 0
      end
      object IB_Grid3: TIB_Grid
        Left = -1
        Top = 137
        Width = 769
        Height = 160
        CustomGlyphsSupplied = []
        DataSource = IB_DataSource_Artikel
        TabOrder = 1
      end
      object DrawGrid1: TDrawGrid
        Left = -1
        Top = 320
        Width = 769
        Height = 145
        BorderStyle = bsNone
        ColCount = 4
        DefaultColWidth = 130
        DefaultRowHeight = 26
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 45
        FixedRows = 0
        GridLineWidth = 0
        Options = [goRowSelect, goThumbTracking]
        ScrollBars = ssVertical
        TabOrder = 2
        OnDblClick = DrawGrid1DblClick
        OnDrawCell = DrawGrid1DrawCell
        OnKeyPress = DrawGrid1KeyPress
      end
      object Button2: TButton
        Left = 519
        Top = 0
        Width = 65
        Height = 25
        Caption = 'starten'
        TabOrder = 3
        OnClick = Button2Click
      end
      object IB_UpdateBar2: TIB_UpdateBar
        Left = 143
        Top = 0
        Width = 138
        Height = 25
        Flat = False
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 4
        DataSource = IB_DataSource_Inventur
        ReceiveFocus = False
        CustomGlyphsSupplied = []
        VisibleButtons = [ubEdit, ubInsert, ubDelete, ubPost, ubCancel, ubRefreshAll]
      end
      object IB_Memo1: TIB_Memo
        Left = 591
        Top = 28
        Width = 178
        Height = 81
        DataField = 'INFO'
        DataSource = IB_DataSource_Inventur
        TabOrder = 5
        AutoSize = False
      end
      object Button6: TButton
        Left = 743
        Top = 116
        Width = 22
        Height = 22
        Caption = '&A'
        TabOrder = 6
        OnClick = Button6Click
      end
      object Button7: TButton
        Left = 678
        Top = 297
        Width = 91
        Height = 22
        Caption = #220'bern&ehmen'
        TabOrder = 7
        OnClick = Button7Click
      end
      object Button8: TButton
        Left = 719
        Top = 116
        Width = 22
        Height = 22
        Hint = 'Aus diesem Block entfernen'
        Caption = '-'
        TabOrder = 8
        OnClick = Button8Click
      end
      object IB_UpdateBar3: TIB_UpdateBar
        Left = 143
        Top = 111
        Width = 116
        Height = 25
        Flat = False
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 9
        DataSource = IB_DataSource_Artikel
        ReceiveFocus = False
        CustomGlyphsSupplied = []
        VisibleButtons = [ubEdit, ubPost, ubCancel, ubRefreshAll]
      end
      object Button9: TButton
        Left = 655
        Top = 297
        Width = 22
        Height = 22
        Caption = '&A'
        TabOrder = 10
        OnClick = Button9Click
      end
      object Button12: TButton
        Left = 496
        Top = 298
        Width = 155
        Height = 21
        Caption = 'Alle '#252'bernehmen'
        TabOrder = 11
        OnClick = Button12Click
      end
      object Edit1: TEdit
        Left = 40
        Top = 473
        Width = 148
        Height = 21
        TabOrder = 12
        OnKeyPress = Edit1KeyPress
      end
      object Button5: TButton
        Left = 472
        Top = 473
        Width = 51
        Height = 21
        Caption = 'Start'
        TabOrder = 13
        OnClick = Button5Click
      end
      object Button13: TButton
        Left = 727
        Top = 473
        Width = 46
        Height = 21
        Caption = 'Start'
        TabOrder = 14
        OnClick = Button13Click
      end
      object ComboBox2: TComboBox
        Left = 254
        Top = 472
        Width = 81
        Height = 21
        Style = csDropDownList
        TabOrder = 15
        OnChange = ComboBox2Change
      end
      object ComboBox3: TComboBox
        Left = 391
        Top = 472
        Width = 81
        Height = 21
        Style = csDropDownList
        TabOrder = 16
      end
      object ComboBox4: TComboBox
        Left = 580
        Top = 473
        Width = 145
        Height = 21
        Style = csDropDownList
        TabOrder = 17
      end
      object Button10: TButton
        Left = 291
        Top = 0
        Width = 221
        Height = 25
        Caption = 'Inventur '#252'ber "Menge>0" definieren'
        TabOrder = 18
        OnClick = Button10Click
      end
    end
  end
  object IB_Query1: TIB_Query
    DatabaseName = '192.168.115.25:test.fdb'
    FieldsDisplayLabel.Strings = (
      'NUMERO=ART#'
      'NAME=LAGER'
      'INVENTUR_MWST=I-%'
      'MENGE=ANZ'
      'INVENTUR_MENGE=I-ANZ'
      'TITEL=Titel'
      'INVENTUR_PREIS=I-Preis'
      'INVENTUR_RABATT=I-R'
      'INVENTUR_MOMENT=I-Moment'
      'VERLAGNO=BES#')
    FieldsDisplayWidth.Strings = (
      'NUMERO=60'
      'NAME=60'
      'INVENTUR_MWST=30'
      'MENGE=50'
      'INVENTUR_MENGE=50'
      'TITEL=220'
      'INVENTUR_PREIS=70'
      'INVENTUR_RABATT=30'
      'INVENTUR_MOMENT=130'
      'VERLAGNO=70')
    FieldsVisible.Strings = (
      'RID=FALSE'
      'INVENTUR_MENGE=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT '
      '       A.NUMERO'
      '     , A.VERLAGNO'
      '     , L.NAME'
      '     , A.INVENTUR_MWST'
      '     , A.INVENTUR_MENGE'
      '     , A.MENGE'
      '     , A.TITEL '
      '     , A.INVENTUR_PREIS'
      '     , A.INVENTUR_RABATT '
      '     , A.INVENTUR_MOMENT'
      '     , A.RID'
      'FROM ARTIKEL A'
      'left join LAGER L ON'
      ' L.RID=A.LAGER_R'
      'WHERE INVENTUR_R=:CROSSREF'
      'ORDER BY '
      ' L.NAME,'
      ' A.TITEL '
      'FOR UPDATE')
    ColorScheme = True
    OrderingItems.Strings = (
      'ART#=ARTIKEL.NUMERO;ARTIKEL.NUMERO DESC'
      'Titel=ARTIKEL.TITEL;ARTIKEL.TITEL DESC'
      'LAGER=LAGER.NAME;LAGER.NAME DESC'
      'I-Moment=ARTIKEL.INVENTUR_MOMENT;ARTIKEL.INVENTUR_MOMENT DESC'
      'BES#=ARTIKEL.VERLAGNO;ARTIKEL.VERLAGNO DESC'
      'ANZ=ARTIKEL.MENGE;ARTIKEL.MENGE DESC')
    OrderingLinks.Strings = (
      'NUMERO=ITEM=1'
      'TITEL=ITEM=2'
      'NAME=ITEM=3'
      'INVENTUR_MOMENT=ITEM=4'
      'VERLAGNO=ITEM=5'
      'MENGE=ITEM=6')
    RequestLive = True
    AfterScroll = IB_Query1AfterScroll
    Left = 328
    Top = 64
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 704
    Top = 8
  end
  object IB_Query2: TIB_Query
    DatabaseName = '192.168.115.25:test.fdb'
    FieldsVisible.Strings = (
      'RID=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT INVENTUR_MWST'
      '     , INVENTUR_MENGE'
      '     , INVENTUR_PREIS'
      '     , INVENTUR_RABATT'
      '     , MENGE'
      '     , SORTIMENT_R'
      '     , INTERN_INFO'
      '     , EURO'
      '     , VERLAG_R '
      '     , RID'
      'FROM ARTIKEL'
      'FOR UPDATE')
    RequestLive = True
    Left = 752
    Top = 8
  end
  object IB_Query_Inventur: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED')
    DatabaseName = '192.168.115.25:test.fdb'
    FieldsReadOnly.Strings = (
      'RID=NOEDIT;NOINSERT')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select * from inventur for update')
    ColorScheme = True
    RequestLive = True
    AfterScroll = IB_Query_InventurAfterScroll
    Left = 48
    Top = 160
  end
  object IB_Query_Artikel: TIB_Query
    DatabaseName = '192.168.115.25:test.fdb'
    FieldsDisplayLabel.Strings = (
      'MENGE=ANZ'
      'NAME=LAGER'
      'TITEL=Ttitel'
      'NUMERO=Art#')
    FieldsDisplayWidth.Strings = (
      'MENGE=60'
      'NAME=80'
      'TITEL=220'
      'NUMERO=80')
    FieldsVisible.Strings = (
      'RID=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select A.RID,'
      '       A.MENGE ,'
      '       L.NAME,'
      '       A.TITEL,'
      '       A.NUMERO,'
      '       A.INVENTUR_MOMENT'
      'from ARTIKEL A '
      'left join LAGER L '
      'ON A.LAGER_R=L.RID'
      'where INVENTUR_R=:CROSSREF'
      'order by'
      ' L.NAME,A.TITEL')
    ColorScheme = True
    OrderingItems.Strings = (
      'LAGER=LAGER.NAME;LAGER.NAME DESC'
      'Ttitel=ARTIKEL.TITEL;ARTIKEL.TITEL DESC'
      'Art#=ARTIKEL.NUMERO;ARTIKEL.NUMERO DESC')
    OrderingLinks.Strings = (
      'NAME=ITEM=1'
      'TITEL=ITEM=2'
      'NUMERO=ITEM=3')
    PreventInserting = True
    PreventDeleting = True
    AfterInsert = IB_Query_ArtikelAfterInsert
    Left = 40
    Top = 400
  end
  object IB_DataSource_Inventur: TIB_DataSource
    Dataset = IB_Query_Inventur
    Left = 176
    Top = 168
  end
  object IB_DataSource_Artikel: TIB_DataSource
    Dataset = IB_Query_Artikel
    Left = 152
    Top = 416
  end
end
