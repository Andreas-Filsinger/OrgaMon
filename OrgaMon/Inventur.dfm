object FormInventur: TFormInventur
  Left = 4
  Top = 4
  Caption = 'Inventur'
  ClientHeight = 551
  ClientWidth = 826
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
    Width = 826
    Height = 551
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Durchf'#252'hrung'
      DesignSize = (
        818
        523)
      object Label7: TLabel
        Left = 0
        Top = 3
        Width = 80
        Height = 13
        Caption = 'InventurBlock'
      end
      object Label8: TLabel
        Left = 457
        Top = 473
        Width = 68
        Height = 20
        Anchors = [akRight, akBottom]
        Caption = '&MENGE'
        FocusControl = Edit2
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitLeft = 419
      end
      object Label9: TLabel
        Left = 640
        Top = 473
        Width = 72
        Height = 20
        Anchors = [akRight, akBottom]
        Caption = 'LABELS'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitLeft = 602
      end
      object IB_Grid1: TIB_Grid
        Left = 0
        Top = 56
        Width = 815
        Height = 409
        CustomGlyphsSupplied = []
        DataSource = IB_DataSource1
        Anchors = [akLeft, akTop, akRight, akBottom]
        ParentBackground = False
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
        Left = 713
        Top = 467
        Width = 102
        Height = 28
        Anchors = [akRight, akBottom]
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
        Left = 531
        Top = 469
        Width = 99
        Height = 28
        Anchors = [akRight, akBottom]
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
        Left = 127
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
        Left = 0
        Top = 23
        Width = 113
        Height = 25
        Caption = 'bearbeiten'
        TabOrder = 9
        OnClick = Button1Click
      end
      object CheckBox3: TCheckBox
        Left = 150
        Top = 477
        Width = 257
        Height = 17
        Anchors = [akRight, akBottom]
        Caption = 'LABEL menge mit "0" vorbelegen'
        Checked = True
        State = cbChecked
        TabOrder = 10
      end
      object Button14: TButton
        Left = 790
        Top = 25
        Width = 25
        Height = 25
        Hint = 'Springe zum Artikel, der unten markiert ist'
        Anchors = [akTop, akRight]
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
      DesignSize = (
        818
        523)
      object Label3: TLabel
        Left = -1
        Top = 8
        Width = 91
        Height = 13
        Caption = 'Inventur Bl'#246'cke'
      end
      object Label4: TLabel
        Left = 0
        Top = 129
        Width = 112
        Height = 13
        Caption = 'zugeordnete Artikel'
      end
      object Label5: TLabel
        Left = -1
        Top = 320
        Width = 74
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'Artikel suche'
        ExplicitTop = 323
      end
      object Label6: TLabel
        Left = 103
        Top = 320
        Width = 7
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = '0'
        ExplicitTop = 323
      end
      object Label2: TLabel
        Left = 0
        Top = 498
        Width = 38
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'suche:'
        ExplicitTop = 500
      end
      object Label10: TLabel
        Left = 230
        Top = 497
        Width = 57
        Height = 13
        Anchors = [akRight, akBottom]
        Caption = 'von Lager'
        ExplicitLeft = 192
        ExplicitTop = 500
      end
      object Label11: TLabel
        Left = 374
        Top = 497
        Width = 52
        Height = 13
        Anchors = [akRight, akBottom]
        Caption = 'bis Lager'
        ExplicitLeft = 336
        ExplicitTop = 500
      end
      object Label12: TLabel
        Left = 571
        Top = 497
        Width = 37
        Height = 13
        Anchors = [akRight, akBottom]
        Caption = 'Verlag'
      end
      object SpeedButton1: TSpeedButton
        Left = 236
        Top = 123
        Width = 25
        Height = 25
        Hint = 'Liste neu beginnen'
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
          0000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFF000000FFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
          0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
        OnClick = SpeedButton1Click
      end
      object IB_Grid2: TIB_Grid
        Left = 0
        Top = 31
        Width = 623
        Height = 81
        CustomGlyphsSupplied = []
        DataSource = IB_DataSource_Inventur
        Anchors = [akLeft, akTop, akRight]
        ParentBackground = False
        TabOrder = 0
      end
      object IB_Grid3: TIB_Grid
        Left = 0
        Top = 152
        Width = 807
        Height = 145
        CustomGlyphsSupplied = []
        DataSource = IB_DataSource_Artikel
        Anchors = [akLeft, akTop, akRight, akBottom]
        ParentBackground = False
        TabOrder = 1
      end
      object DrawGrid1: TDrawGrid
        Left = -1
        Top = 343
        Width = 808
        Height = 145
        Anchors = [akLeft, akRight, akBottom]
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
        ColWidths = (
          130
          130
          130
          130)
        RowHeights = (
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26
          26)
      end
      object Button2: TButton
        Left = 520
        Top = 2
        Width = 65
        Height = 25
        Caption = 'starten'
        TabOrder = 3
        OnClick = Button2Click
      end
      object IB_UpdateBar2: TIB_UpdateBar
        Left = 93
        Top = 2
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
        Left = 629
        Top = 31
        Width = 178
        Height = 81
        DataField = 'INFO'
        DataSource = IB_DataSource_Inventur
        Anchors = [akTop, akRight]
        ParentBackground = False
        TabOrder = 5
        AutoSize = False
      end
      object Button6: TButton
        Left = 782
        Top = 123
        Width = 25
        Height = 25
        Anchors = [akTop, akRight]
        Caption = '&A'
        TabOrder = 6
        OnClick = Button6Click
      end
      object Button7: TButton
        Left = 716
        Top = 315
        Width = 91
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Hinzun&ehmen'
        TabOrder = 7
        OnClick = Button7Click
      end
      object Button8: TButton
        Left = 754
        Top = 123
        Width = 25
        Height = 25
        Hint = 'Aus diesem Block entfernen'
        Anchors = [akTop, akRight]
        Caption = '-'
        TabOrder = 8
        OnClick = Button8Click
      end
      object IB_UpdateBar3: TIB_UpdateBar
        Left = 116
        Top = 123
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
        Left = 691
        Top = 315
        Width = 25
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = '&A'
        TabOrder = 10
        OnClick = Button9Click
      end
      object Button12: TButton
        Left = 534
        Top = 315
        Width = 155
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Alle hinzunehmen'
        TabOrder = 11
        OnClick = Button12Click
      end
      object Edit1: TEdit
        Left = 42
        Top = 495
        Width = 148
        Height = 21
        Anchors = [akLeft, akBottom]
        TabOrder = 12
        OnKeyPress = Edit1KeyPress
      end
      object Button5: TButton
        Left = 512
        Top = 493
        Width = 51
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Start'
        TabOrder = 13
        OnClick = Button5Click
      end
      object Button13: TButton
        Left = 761
        Top = 493
        Width = 46
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Start'
        TabOrder = 14
        OnClick = Button13Click
      end
      object ComboBox2: TComboBox
        Left = 290
        Top = 494
        Width = 81
        Height = 21
        Style = csDropDownList
        Anchors = [akRight, akBottom]
        TabOrder = 15
        OnChange = ComboBox2Change
      end
      object ComboBox3: TComboBox
        Left = 429
        Top = 494
        Width = 81
        Height = 21
        Style = csDropDownList
        Anchors = [akRight, akBottom]
        TabOrder = 16
      end
      object ComboBox4: TComboBox
        Left = 614
        Top = 495
        Width = 145
        Height = 21
        Style = csDropDownList
        Anchors = [akRight, akBottom]
        TabOrder = 17
      end
      object Button10: TButton
        Left = 291
        Top = 2
        Width = 221
        Height = 25
        Caption = 'Inventur '#252'ber "Menge>0" definieren'
        TabOrder = 18
        OnClick = Button10Click
      end
    end
  end
  object IB_Query1: TIB_Query
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
    OrderingItemNo = -4
    OrderingItems.Strings = (
      'ART#=NUMERO;NUMERO DESC'
      'Titel=TITEL;TITEL DESC'
      'LAGER=NAME;NAME DESC'
      'I-Moment=INVENTUR_MOMENT;INVENTUR_MOMENT DESC'
      'BES#=VERLAGNO;VERLAGNO DESC'
      'ANZ=MENGE;MENGE DESC')
    OrderingLinks.Strings = (
      'NUMERO=ITEM=1'
      'TITEL=ITEM=2'
      'NAME=ITEM=3'
      'INVENTUR_MOMENT=ITEM=4'
      'VERLAGNO=ITEM=5'
      'MENGE=ITEM=6')
    RequestLive = True
    AfterScroll = IB_Query1AfterScroll
    Left = 56
    Top = 80
    ParamValues = (
      'CROSSREF=')
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 136
    Top = 80
  end
  object IB_Query2: TIB_Query
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
    Left = 232
    Top = 80
  end
  object IB_Query_Inventur: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED')
    FieldsReadOnly.Strings = (
      'RID=NOEDIT;NOINSERT')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select * from inventur for update')
    ColorScheme = True
    RequestLive = True
    AfterScroll = IB_Query_InventurAfterScroll
    Left = 320
    Top = 88
  end
  object IB_Query_Artikel: TIB_Query
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
    OrderingItemNo = -2
    OrderingItems.Strings = (
      'LAGER=NAME;NAME DESC'
      'Ttitel=TITEL;TITEL DESC'
      'Art#=NUMERO;NUMERO DESC')
    OrderingLinks.Strings = (
      'NAME=ITEM=1'
      'TITEL=ITEM=2'
      'NUMERO=ITEM=3')
    PreventInserting = True
    PreventDeleting = True
    AfterInsert = IB_Query_ArtikelAfterInsert
    Left = 56
    Top = 240
    ParamValues = (
      'CROSSREF=')
  end
  object IB_DataSource_Inventur: TIB_DataSource
    Dataset = IB_Query_Inventur
    Left = 440
    Top = 88
  end
  object IB_DataSource_Artikel: TIB_DataSource
    Dataset = IB_Query_Artikel
    Left = 168
    Top = 240
  end
end
