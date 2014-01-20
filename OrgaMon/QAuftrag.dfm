object FormQAuftrag: TFormQAuftrag
  Left = 0
  Top = 0
  Caption = 'Auftrag 00-XX-00.000.00'
  ClientHeight = 538
  ClientWidth = 790
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  DesignSize = (
    790
    538)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 1
    Top = 0
    Width = 787
    Height = 162
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    DesignSize = (
      787
      162)
    object Label6: TLabel
      Left = 13
      Top = 10
      Width = 42
      Height = 13
      Caption = '&Auftrag'
    end
    object IB_NavigationBar1: TIB_NavigationBar
      Left = 90
      Top = 4
      Width = 112
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      DataSource = IB_DataSource1
      ReceiveFocus = False
      CustomGlyphsSupplied = []
    end
    object IB_UpdateBar1: TIB_UpdateBar
      Left = 207
      Top = 4
      Width = 84
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      DataSource = IB_DataSource1
      ReceiveFocus = False
      CustomGlyphsSupplied = []
      VisibleButtons = [ubPost, ubCancel, ubRefreshAll]
    end
    object Button2: TButton
      Left = 335
      Top = 4
      Width = 25
      Height = 25
      Hint = 'neuer Auftrag'
      Caption = '+'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = Button2Click
    end
    object PageControl1: TPageControl
      Left = 7
      Top = 30
      Width = 781
      Height = 133
      ActivePage = TabSheet4
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      object TabSheet1: TTabSheet
        Caption = '&Kunde'
        DesignSize = (
          773
          105)
        object Label4: TLabel
          Left = 43
          Top = 8
          Width = 33
          Height = 13
          Caption = 'Name'
        end
        object Label9: TLabel
          Left = 23
          Top = 29
          Width = 53
          Height = 13
          Caption = 'Abteilung'
        end
        object Label10: TLabel
          Left = 7
          Top = 47
          Width = 69
          Height = 13
          Caption = 'Kostenstelle'
        end
        object Label13: TLabel
          Left = 276
          Top = 10
          Width = 30
          Height = 13
          Caption = 'Bem.'
        end
        object IB_Edit1: TIB_Edit
          Left = 83
          Top = 5
          Width = 173
          Height = 21
          DataField = 'KUNDE'
          DataSource = IB_DataSource1
          TabOrder = 0
        end
        object IB_Edit2: TIB_Edit
          Left = 83
          Top = 24
          Width = 173
          Height = 21
          DataField = 'KUNDE2'
          DataSource = IB_DataSource1
          TabOrder = 1
        end
        object IB_Edit3: TIB_Edit
          Left = 83
          Top = 43
          Width = 173
          Height = 21
          DataField = 'KUNDE3'
          DataSource = IB_DataSource1
          TabOrder = 2
        end
        object IB_Memo3: TIB_Memo
          Left = 310
          Top = 8
          Width = 461
          Height = 94
          DataField = 'INFO'
          DataSource = IB_DataSource1
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 3
          AutoSize = False
        end
      end
      object TabSheet2: TTabSheet
        Caption = '&Administrativ'
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label11: TLabel
          Left = 54
          Top = 23
          Width = 44
          Height = 13
          Caption = 'BuE-Nr.'
        end
        object Label14: TLabel
          Left = 34
          Top = 4
          Width = 64
          Height = 13
          Caption = 'Auftragsnr.'
        end
        object Label19: TLabel
          Left = 12
          Top = 44
          Width = 85
          Height = 13
          Caption = 'BU-Auftragsnr.'
        end
        object Label20: TLabel
          Left = 72
          Top = 63
          Width = 26
          Height = 13
          Caption = 'Banf'
        end
        object Label21: TLabel
          Left = 44
          Top = 81
          Width = 54
          Height = 13
          Caption = 'Bestellnr.'
        end
        object Label22: TLabel
          Left = 229
          Top = 5
          Width = 96
          Height = 13
          Caption = 'Innenauftragsnr.'
        end
        object Label23: TLabel
          Left = 265
          Top = 25
          Width = 60
          Height = 13
          Caption = 'Sachkonto'
        end
        object Label24: TLabel
          Left = 260
          Top = 44
          Width = 65
          Height = 13
          Caption = 'Inventarnr.'
        end
        object Label25: TLabel
          Left = 240
          Top = 64
          Width = 85
          Height = 13
          Caption = 'PM-Auftragsnr.'
        end
        object SpeedButton1: TSpeedButton
          Left = 469
          Top = 5
          Width = 23
          Height = 22
          Hint = 'Auftrags Verzeichnis '#246'ffnen'
          Enabled = False
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00303333333333
            333337F3333333333333303333333333333337F33FFFFF3FF3FF303300000300
            300337FF77777F77377330000BBB0333333337777F337F33333330330BB00333
            333337F373F773333333303330033333333337F3377333333333303333333333
            333337F33FFFFF3FF3FF303300000300300337FF77777F77377330000BBB0333
            333337777F337F33333330330BB00333333337F373F773333333303330033333
            333337F3377333333333303333333333333337FFFF3FF3FFF333000003003000
            333377777F77377733330BBB0333333333337F337F33333333330BB003333333
            333373F773333333333330033333333333333773333333333333}
          NumGlyphs = 2
          ParentShowHint = False
          ShowHint = True
          OnClick = SpeedButton1Click
        end
        object IB_Edit4: TIB_Edit
          Left = 101
          Top = 1
          Width = 116
          Height = 21
          DataField = 'CODE_FRONT_OFFICE'
          DataSource = IB_DataSource1
          TabOrder = 0
        end
        object IB_Edit5: TIB_Edit
          Left = 101
          Top = 20
          Width = 116
          Height = 21
          DataField = 'CODE_BACK_OFFICE'
          DataSource = IB_DataSource1
          TabOrder = 1
        end
        object IB_Edit8: TIB_Edit
          Left = 101
          Top = 40
          Width = 116
          Height = 21
          DataField = 'BU_NO'
          DataSource = IB_DataSource1
          TabOrder = 2
        end
        object IB_Edit9: TIB_Edit
          Left = 101
          Top = 59
          Width = 116
          Height = 21
          DataField = 'BANF'
          DataSource = IB_DataSource1
          TabOrder = 3
        end
        object IB_Edit10: TIB_Edit
          Left = 101
          Top = 78
          Width = 116
          Height = 21
          DataField = 'BEST_NO'
          DataSource = IB_DataSource1
          TabOrder = 4
        end
        object IB_Edit11: TIB_Edit
          Left = 328
          Top = 1
          Width = 121
          Height = 21
          DataField = 'INNEN_A_NO'
          DataSource = IB_DataSource1
          TabOrder = 5
        end
        object IB_Edit12: TIB_Edit
          Left = 328
          Top = 21
          Width = 121
          Height = 21
          DataField = 'SACHKONTO'
          DataSource = IB_DataSource1
          TabOrder = 6
        end
        object IB_Edit13: TIB_Edit
          Left = 328
          Top = 40
          Width = 121
          Height = 21
          DataField = 'INVENTAR_NO'
          DataSource = IB_DataSource1
          TabOrder = 7
        end
        object IB_Edit14: TIB_Edit
          Left = 328
          Top = 60
          Width = 121
          Height = 21
          DataField = 'PM_AUFTRAG_NO'
          DataSource = IB_DataSource1
          TabOrder = 8
        end
      end
      object TabSheet3: TTabSheet
        Caption = '&Lieferant'
        ImageIndex = 2
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label12: TLabel
          Left = 51
          Top = 7
          Width = 50
          Height = 13
          Caption = 'Lieferant'
        end
        object Label18: TLabel
          Left = 1
          Top = 27
          Width = 100
          Height = 13
          Caption = 'Rahmenbestellnr.'
        end
        object IB_Edit6: TIB_Edit
          Left = 104
          Top = 4
          Width = 173
          Height = 21
          DataField = 'LIEFERANT'
          DataSource = IB_DataSource1
          TabOrder = 0
        end
        object IB_Edit7: TIB_Edit
          Left = 104
          Top = 23
          Width = 173
          Height = 21
          DataField = 'RAHMEN_BEST_NO'
          DataSource = IB_DataSource1
          TabOrder = 1
        end
      end
      object TabSheet4: TTabSheet
        Caption = 'Terminierung'
        ImageIndex = 3
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label1: TLabel
          Left = 260
          Top = 30
          Width = 113
          Height = 13
          Caption = 'berechneter Termin'
        end
        object IB_Text2: TIB_Text
          Left = 376
          Top = 68
          Width = 120
          Height = 17
          DataField = 'VERFALL'
          DataSource = IB_DataSource1
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          BevelOuter = bvLowered
        end
        object Label16: TLabel
          Left = 280
          Top = 69
          Width = 93
          Height = 13
          Caption = 'abgerechnet am'
        end
        object IB_Text3: TIB_Text
          Left = 504
          Top = 28
          Width = 50
          Height = 17
          DataField = 'DAUER'
          DataSource = IB_DataSource1
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          BevelOuter = bvLowered
        end
        object IB_Text4: TIB_Text
          Left = 376
          Top = 28
          Width = 120
          Height = 17
          DataField = 'ABSCHLUSS_C'
          DataSource = IB_DataSource1
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          BevelOuter = bvLowered
        end
        object Label26: TLabel
          Left = 257
          Top = 50
          Width = 116
          Height = 13
          Caption = 'tats'#228'chlicher Termin'
        end
        object IB_Text1: TIB_Text
          Left = 376
          Top = 48
          Width = 120
          Height = 17
          DataField = 'ABSCHLUSS'
          DataSource = IB_DataSource1
          BevelOuter = bvLowered
        end
        object Label5: TLabel
          Left = 292
          Top = 9
          Width = 81
          Height = 13
          Caption = 'Wunschtermin'
        end
        object Label15: TLabel
          Left = 557
          Top = 10
          Width = 28
          Height = 13
          Caption = 'Tage'
        end
        object Label17: TLabel
          Left = 558
          Top = 29
          Width = 28
          Height = 13
          Caption = 'Tage'
        end
        object Label27: TLabel
          Left = 558
          Top = 50
          Width = 28
          Height = 13
          Caption = 'Tage'
        end
        object Label29: TLabel
          Left = 558
          Top = 70
          Width = 28
          Height = 13
          Caption = 'Tage'
        end
        object Label2: TLabel
          Left = 4
          Top = 9
          Width = 45
          Height = 13
          Caption = 'Eingang'
        end
        object Label3: TLabel
          Left = 9
          Top = 32
          Width = 39
          Height = 13
          Caption = 'Beginn'
        end
        object IB_Text5: TIB_Text
          Left = 52
          Top = 30
          Width = 118
          Height = 19
          DataField = 'BEGINN'
          DataSource = IB_DataSource1
          BevelOuter = bvLowered
        end
        object StaticText2: TStaticText
          Left = 504
          Top = 8
          Width = 50
          Height = 17
          AutoSize = False
          BorderStyle = sbsSunken
          Caption = '<EMPTY>'
          TabOrder = 2
        end
        object StaticText3: TStaticText
          Left = 504
          Top = 48
          Width = 50
          Height = 17
          AutoSize = False
          BorderStyle = sbsSunken
          Caption = #178')'
          TabOrder = 3
        end
        object StaticText4: TStaticText
          Left = 504
          Top = 68
          Width = 50
          Height = 17
          AutoSize = False
          BorderStyle = sbsSunken
          Caption = #178')'
          TabOrder = 4
        end
        object IB_Date2: TIB_Date
          Left = 376
          Top = 6
          Width = 121
          Height = 21
          DataField = 'ABSCHLUSS_WUNSCH'
          DataSource = IB_DataSource1
          TabOrder = 1
          IncCellHeight = 1
          IncCellWidth = 2
          DrawYearArrow = False
        end
        object IB_Date1: TIB_Date
          Left = 52
          Top = 6
          Width = 119
          Height = 21
          DataField = 'EINGANG'
          DataSource = IB_DataSource1
          TabOrder = 0
          IncCellHeight = 1
          IncCellWidth = 2
          DrawYearArrow = False
        end
      end
    end
    object Button10: TButton
      Left = 360
      Top = 4
      Width = 25
      Height = 25
      Hint = 'Auftrag l'#246'schen'
      Caption = '-'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = Button10Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 162
    Width = 789
    Height = 204
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
    DesignSize = (
      789
      204)
    object Splitter1: TSplitter
      Left = 1
      Top = 1
      Width = 544
      Height = 202
      Beveled = True
      OnCanResize = Splitter1CanResize
      OnMoved = Splitter1Moved
    end
    object Label7: TLabel
      Left = 8
      Top = 8
      Width = 58
      Height = 13
      Caption = '&Positionen'
      FocusControl = IB_Grid1
    end
    object IB_NavigationBar2: TIB_NavigationBar
      Left = 90
      Top = 5
      Width = 112
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      DataSource = IB_DataSource2
      ReceiveFocus = False
      CustomGlyphsSupplied = []
    end
    object IB_UpdateBar2: TIB_UpdateBar
      Left = 207
      Top = 5
      Width = 90
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      DataSource = IB_DataSource2
      ReceiveFocus = False
      CustomGlyphsSupplied = []
      VisibleButtons = [ubPost, ubCancel, ubRefreshAll]
    end
    object ComboBox1: TComboBox
      Left = 390
      Top = 7
      Width = 150
      Height = 21
      Style = csDropDownList
      TabOrder = 2
      OnClick = ComboBox1Click
    end
    object Button3: TButton
      Left = 335
      Top = 5
      Width = 25
      Height = 25
      Caption = '+'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button3Click
    end
    object Button5: TButton
      Left = 360
      Top = 5
      Width = 25
      Height = 25
      Caption = '-'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = Button5Click
    end
    object IB_Memo1: TIB_Memo
      Left = 545
      Top = 34
      Width = 241
      Height = 168
      DataField = 'INFO'
      DataSource = IB_DataSource2
      Anchors = [akTop, akRight, akBottom]
      TabOrder = 6
      AutoSize = False
    end
    object Button9: TButton
      Left = 560
      Top = 5
      Width = 153
      Height = 25
      Caption = 'Handlungs&bedarf'
      TabOrder = 7
      OnClick = Button9Click
    end
    object IB_Grid1: TIB_Grid
      Left = 4
      Top = 33
      Width = 539
      Height = 169
      CustomGlyphsSupplied = []
      DefDrawBefore = False
      DataSource = IB_DataSource2
      Anchors = [akLeft, akTop, akRight, akBottom]
      Ctl3D = False
      ParentCtl3D = False
      PreventDeleting = True
      PreventInserting = True
      TabOrder = 5
      AlwaysShowEditor = True
      OnDrawCell = IB_Grid1DrawCell
      OnDrawFocusedCell = IB_Grid1DrawFocusedCell
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 366
    Width = 789
    Height = 180
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 2
    DesignSize = (
      789
      180)
    object Label8: TLabel
      Left = 6
      Top = 8
      Width = 82
      Height = 13
      Caption = 'Arbeits&schritte'
      FocusControl = IB_Grid2
    end
    object IB_NavigationBar3: TIB_NavigationBar
      Left = 90
      Top = 5
      Width = 112
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      DataSource = IB_DataSource3
      ReceiveFocus = False
      CustomGlyphsSupplied = []
    end
    object IB_UpdateBar3: TIB_UpdateBar
      Left = 207
      Top = 5
      Width = 120
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      DataSource = IB_DataSource3
      ReceiveFocus = False
      CustomGlyphsSupplied = []
      VisibleButtons = [ubDelete, ubPost, ubCancel, ubRefreshAll]
    end
    object ComboBox2: TComboBox
      Left = 390
      Top = 6
      Width = 150
      Height = 21
      Style = csDropDownList
      TabOrder = 2
    end
    object Button4: TButton
      Left = 335
      Top = 5
      Width = 25
      Height = 25
      Caption = '+'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button4Click
    end
    object Button6: TButton
      Left = 560
      Top = 5
      Width = 153
      Height = 25
      Caption = 'zuordnen'
      TabOrder = 4
      OnClick = Button6Click
    end
    object IB_Grid2: TIB_Grid
      Left = 2
      Top = 35
      Width = 541
      Height = 142
      Hint = 'Doppelklick in der Spalte Abschluss tr'#228'gt heutiges Datum ein'
      CustomGlyphsSupplied = []
      DefDrawBefore = False
      DataSource = IB_DataSource3
      Anchors = [akLeft, akRight, akBottom]
      ParentShowHint = False
      ShowHint = True
      OnDblClick = IB_Grid2DblClick
      Ctl3D = False
      ParentCtl3D = False
      PreventDeleting = True
      PreventInserting = True
      TabOrder = 5
      AlwaysShowEditor = True
      OnCellDblClick = IB_Grid2CellDblClick
      OnDrawCell = IB_Grid2DrawCell
      OnDrawFocusedCell = IB_Grid2DrawFocusedCell
    end
    object IB_Memo2: TIB_Memo
      Left = 544
      Top = 35
      Width = 242
      Height = 142
      DataField = 'INFO'
      DataSource = IB_DataSource3
      Anchors = [akRight, akBottom]
      TabOrder = 6
      AutoSize = False
    end
  end
  object IB_Query1: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED')
    DatabaseName = '192.168.115.91:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT *'
      'FROM QAUFTRAG'
      'FOR UPDATE')
    ColorScheme = True
    KeyLinks.Strings = (
      'QAUFTRAG.RID')
    RequestLive = True
    AfterPost = IB_Query1AfterPost
    AfterScroll = IB_Query1AfterScroll
    BeforeInsert = IB_Query1BeforeInsert
    Left = 240
    Top = 226
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 272
    Top = 226
  end
  object IB_Query2: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED'
      'VERFALL=NOTIME')
    DatabaseName = '192.168.115.91:test.fdb'
    FieldsDisplayFormat.Strings = (
      'VERFALL=dd.mm.yy')
    FieldsDisplayLabel.Strings = (
      'POSNR=Pos#'
      'NAME=Bezeichnung'
      'DAUER=Dauer'
      'ANLAGENR=Anlage-Nr'
      'MATERIALNR=MA-Nr'
      'OWNER_R=Owner'
      'GRUPPE_R=Gruppe'
      'VERFALL=Verfall')
    FieldsDisplayWidth.Strings = (
      'POSNR=40'
      'NAME=200'
      'DAUER=40'
      'ANLAGENR=110'
      'MATERIALNR=110'
      'OWNER_R=65'
      'GRUPPE_R=80'
      'VERFALL=54')
    FieldsReadOnly.Strings = (
      'DAUER=NOEDIT'
      'GRUPPE_R=NOEDIT'
      'VERFALL=NOEDIT'
      'OWNER_R=NOEDIT')
    FieldsVisible.Strings = (
      'AUFTRAG_R=FALSE'
      'INFO=FALSE'
      'RID=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT'
      '       POSNR'
      '     , NAME'
      '     , ANLAGENR'
      '     , MATERIALNR'
      '     , DAUER'
      '     , QAUFTRAG_R'
      '     , RID'
      '     , INFO'
      '     , GRUPPE_R'
      '     , VERFALL'
      '     , OWNER_R'
      'FROM QPOSTEN'
      'WHERE QAUFTRAG_R=:CROSSREF'
      'ORDER BY POSNR,RID'
      'FOR UPDATE')
    ColorScheme = True
    RequestLive = True
    AfterPost = IB_Query2AfterPost
    AfterScroll = IB_Query2AfterScroll
    BeforePost = IB_Query2BeforePost
    Left = 240
    Top = 264
  end
  object IB_DataSource2: TIB_DataSource
    Dataset = IB_Query2
    Left = 272
    Top = 264
  end
  object IB_Query3: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED')
    DatabaseName = '192.168.115.91:test.fdb'
    FieldsAlignment.Strings = (
      'GRUPPE_R=LEFT')
    FieldsDisplayFormat.Strings = (
      'BEGINN=dd.mm.yy'
      'ABSCHLUSS=dd.mm.yy')
    FieldsDisplayLabel.Strings = (
      'POSNR=Pos#'
      'NAME=Bezeichnung'
      'DAUER=Dauer'
      'GRUPPE_R=Gruppe'
      'BEGINN=Beginn'
      'ABSCHLUSS=Abschluss'
      'BEARBEITER_R=User')
    FieldsDisplayWidth.Strings = (
      'POSNR=40'
      'NAME=210'
      'DAUER=50'
      'BEGINN=54'
      'ABSCHLUSS=54'
      'ANLAGE=80'
      'GRUPPE_R=80'
      'BEARBEITER_R=50')
    FieldsReadOnly.Strings = (
      'GRUPPE_R=NOEDIT'
      'BEARBEITER_R=NOEDIT;NOINSERT;NOSEARCH'
      'BEGINN=NOEDIT')
    FieldsVisible.Strings = (
      'POSTEN_R=FALSE'
      'INFO=FALSE'
      'RID=FALSE'
      'ANLAGE=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT'
      '       POSNR'
      '     , NAME'
      '     , DAUER'
      '     , GRUPPE_R'
      '     , BEGINN'
      '     , ABSCHLUSS'
      '     , BEARBEITER_R'
      '     , ANLAGE'
      '     , QPOSTEN_R'
      '     , RID'
      '     , INFO'
      'FROM MEILENSTEIN'
      'WHERE QPOSTEN_R=:CROSSREF'
      'ORDER BY POSNR,RID'
      'FOR UPDATE')
    ColorScheme = True
    KeyLinks.Strings = (
      'MEILENSTEIN.RID')
    RequestLive = True
    AfterPost = IB_Query3AfterPost
    BeforePost = IB_Query3BeforePost
    Left = 240
    Top = 296
  end
  object IB_DataSource3: TIB_DataSource
    Dataset = IB_Query3
    Left = 272
    Top = 296
  end
  object IB_Query4: TIB_Query
    DatabaseName = '192.168.115.91:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT * '
      'FROM PROFIL')
    Left = 128
    Top = 272
  end
  object IB_Query5: TIB_Query
    DatabaseName = '192.168.115.91:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT * '
      'FROM PHASE '
      'WHERE PROFIL_R=:CROSSREF'
      'ORDER BY POSNR,RID')
    Left = 160
    Top = 272
  end
  object IB_Query6: TIB_Query
    DatabaseName = '192.168.115.91:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT SUM(DAUER) D_SUMME'
      'FROM MEILENSTEIN'
      'WHERE POSTEN_R=:CROSSREF')
    Left = 192
    Top = 272
  end
end
