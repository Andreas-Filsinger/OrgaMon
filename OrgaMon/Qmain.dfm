object FormQMain: TFormQMain
  Left = 0
  Top = 1
  HelpType = htKeyword
  HelpKeyword = '1'
  HelpContext = 1
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  Caption = 'Auftrags'#252'bersicht'
  ClientHeight = 537
  ClientWidth = 792
  Color = clBtnFace
  Constraints.MinHeight = 571
  Constraints.MinWidth = 800
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
    792
    537)
  PixelsPerInch = 96
  TextHeight = 13
  object Label10: TLabel
    Left = 56
    Top = 88
    Width = 44
    Height = 13
    Caption = 'Label10'
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 792
    Height = 544
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = '&'#220'berblick'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        784
        516)
      object Label1: TLabel
        Left = 12
        Top = 492
        Width = 70
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'freie &Suche:'
        FocusControl = Edit1
      end
      object Label3: TLabel
        Left = 28
        Top = 27
        Width = 82
        Height = 13
        Caption = 'Arbeits&bereich'
        FocusControl = ComboBox1
      end
      object Label4: TLabel
        Left = 29
        Top = 65
        Width = 36
        Height = 13
        Caption = '&Status'
        FocusControl = ComboBox2
      end
      object Label5: TLabel
        Left = 288
        Top = 21
        Width = 49
        Height = 13
        Caption = '&Gruppen'
        FocusControl = CheckListBox1
      end
      object Label6: TLabel
        Left = 8
        Top = 8
        Width = 192
        Height = 13
        Caption = 'a) Anzeigeumfang ausw'#228'hlen'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 8
        Top = 112
        Width = 151
        Height = 13
        Caption = 'b) Se&lektierte Auftr'#228'ge'
        FocusControl = IB_Grid1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Image2: TImage
        Left = 555
        Top = 20
        Width = 50
        Height = 17
        Cursor = crHandPoint
        OnDblClick = Image2DblClick
      end
      object Label8: TLabel
        Left = 514
        Top = 22
        Width = 37
        Height = 13
        Caption = '&Owner'
        FocusControl = CheckListBox2
      end
      object Label14: TLabel
        Left = 612
        Top = 21
        Width = 28
        Height = 13
        Caption = '&Rolle'
        FocusControl = ComboBox3
      end
      object ComboBox1: TComboBox
        Left = 28
        Top = 42
        Width = 245
        Height = 21
        Enabled = False
        TabOrder = 3
        Text = '- fest -'
      end
      object Edit1: TEdit
        Left = 85
        Top = 489
        Width = 240
        Height = 21
        Anchors = [akLeft, akBottom]
        TabOrder = 1
        Text = 'BuE-Nr.'
        OnKeyPress = Edit1KeyPress
      end
      object ComboBox2: TComboBox
        Left = 28
        Top = 80
        Width = 245
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 4
        Text = '* - alle'
        Items.Strings = (
          '* - alle'
          '0 - Abschluss in mehr als 2 Tagen'
          '1 - Aktion morgen erforderlich'
          '2 - Aktion heute erforderlich'
          '3 - In Verzug seit heute'
          '4 - In Verzug seit gestern')
      end
      object Button10: TButton
        Left = 545
        Top = 487
        Width = 145
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'zum Auftrag >>>'
        TabOrder = 2
        OnClick = Button10Click
      end
      object IB_Grid1: TIB_Grid
        Left = 8
        Top = 136
        Width = 760
        Height = 344
        CustomGlyphsSupplied = []
        DefDrawBefore = False
        DataSource = IB_DataSource1
        Anchors = [akLeft, akTop, akRight, akBottom]
        OnDblClick = IB_Grid1DblClick
        Ctl3D = False
        ParentCtl3D = False
        PreventDeleting = True
        PreventInserting = True
        TabOrder = 0
        OnDrawCell = IB_Grid1DrawCell
        OnDrawFocusedCell = IB_Grid1DrawFocusedCell
      end
      object CheckListBox1: TCheckListBox
        Left = 288
        Top = 40
        Width = 215
        Height = 65
        OnClickCheck = CheckListBox1ClickCheck
        ItemHeight = 13
        TabOrder = 5
      end
      object Button14: TButton
        Left = 671
        Top = 109
        Width = 97
        Height = 25
        Caption = 'neu an&zeigen'
        TabOrder = 6
        OnClick = Button14Click
      end
      object Button15: TButton
        Left = 646
        Top = 109
        Width = 25
        Height = 25
        Hint = 'neuer Auftrag'
        Caption = '+'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = Button15Click
      end
      object Button1: TButton
        Left = 691
        Top = 487
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Be&enden'
        TabOrder = 8
        OnClick = Button1Click
      end
      object CheckListBox2: TCheckListBox
        Left = 512
        Top = 40
        Width = 256
        Height = 65
        ItemHeight = 13
        TabOrder = 9
      end
      object ComboBox3: TComboBox
        Left = 644
        Top = 17
        Width = 73
        Height = 21
        Style = csDropDownList
        TabOrder = 10
        OnChange = ComboBox3Change
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Basis&daten'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Image1: TImage
        Left = 10
        Top = 56
        Width = 82
        Height = 73
        AutoSize = True
      end
      object Button11: TButton
        Left = 128
        Top = 72
        Width = 105
        Height = 25
        Caption = 'Rohstoffe'
        Enabled = False
        TabOrder = 0
        OnClick = Button11Click
      end
      object Button12: TButton
        Left = 128
        Top = 104
        Width = 105
        Height = 25
        Caption = '&Profile'
        TabOrder = 1
        OnClick = Button12Click
      end
    end
    object TabSheet4: TTabSheet
      Caption = '&Admin'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label9: TLabel
        Left = 504
        Top = 24
        Width = 245
        Height = 13
        Caption = 'MAC Adapter Adress des Fail Over Servers'
      end
      object Label11: TLabel
        Left = 8
        Top = 16
        Width = 126
        Height = 13
        Caption = '1) Server Diagnose'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label12: TLabel
        Left = 8
        Top = 150
        Width = 126
        Height = 13
        Caption = '2) System Tabellen'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label13: TLabel
        Left = 16
        Top = 304
        Width = 59
        Height = 13
        Caption = '3) Admin'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 88
        Top = 304
        Width = 37
        Height = 13
        Caption = 'Label2'
      end
      object Edit2: TEdit
        Left = 8
        Top = 37
        Width = 121
        Height = 21
        TabOrder = 0
        Text = 'localhost'
      end
      object ListBox1: TListBox
        Left = 8
        Top = 65
        Width = 769
        Height = 72
        ItemHeight = 13
        TabOrder = 1
      end
      object Button16: TButton
        Left = 630
        Top = 40
        Width = 121
        Height = 20
        Caption = '! Wake On LAN !'
        TabOrder = 2
        OnClick = Button16Click
      end
      object Edit3: TEdit
        Left = 503
        Top = 40
        Width = 121
        Height = 21
        TabOrder = 3
        Text = '00-07-95-1C-64-7E'
      end
      object Einstellungen: TButton
        Left = 8
        Top = 176
        Width = 137
        Height = 25
        Caption = 'Einstellungen'
        TabOrder = 4
        OnClick = EinstellungenClick
      end
      object Backup: TButton
        Left = 8
        Top = 328
        Width = 137
        Height = 25
        Caption = 'Backup'
        TabOrder = 5
        OnClick = BackupClick
      end
      object Tagesabschluss: TButton
        Left = 8
        Top = 360
        Width = 137
        Height = 25
        Caption = 'Tagesabschluss'
        TabOrder = 6
        OnClick = TagesabschlussClick
      end
      object Button17: TButton
        Left = 151
        Top = 327
        Width = 141
        Height = 26
        Caption = 'Suchindex auffrischen'
        TabOrder = 7
        OnClick = Button17Click
      end
      object Button7: TButton
        Left = 152
        Top = 176
        Width = 105
        Height = 25
        Caption = 'Benutzer'
        TabOrder = 8
        OnClick = Button7Click
      end
      object Button9: TButton
        Left = 8
        Top = 201
        Width = 137
        Height = 25
        Caption = 'Arbeitsbereich'
        TabOrder = 9
        OnClick = Button9Click
      end
      object Button13: TButton
        Left = 152
        Top = 200
        Width = 105
        Height = 25
        Caption = 'Gruppen'
        TabOrder = 10
        OnClick = Button13Click
      end
      object CheckBox1: TCheckBox
        Left = 209
        Top = 41
        Width = 100
        Height = 17
        Alignment = taLeftJustify
        Caption = 'SQL Diagnose'
        TabOrder = 11
      end
      object Button3: TButton
        Left = 320
        Top = 32
        Width = 75
        Height = 25
        Caption = 'Client Ping'
        TabOrder = 12
        OnClick = Button3Click
      end
      object StaticText1: TStaticText
        Left = 300
        Top = 194
        Width = 160
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = 'morgen'
        TabOrder = 13
      end
      object StaticText2: TStaticText
        Left = 300
        Top = 212
        Width = 160
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = 'heute'
        TabOrder = 14
      end
      object StaticText3: TStaticText
        Left = 300
        Top = 230
        Width = 160
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = 'gestern'
        TabOrder = 15
      end
      object StaticText4: TStaticText
        Left = 300
        Top = 248
        Width = 160
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = 'vorgestern'
        TabOrder = 16
      end
      object StaticText5: TStaticText
        Left = 300
        Top = 266
        Width = 160
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = 'vor mehr als 2 Tagen'
        TabOrder = 17
      end
      object StaticText6: TStaticText
        Left = 300
        Top = 176
        Width = 160
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = 'in mehr als 2 Tagen'
        Color = clWhite
        ParentColor = False
        TabOrder = 18
      end
      object Button4: TButton
        Left = 8
        Top = 392
        Width = 285
        Height = 25
        Caption = 'Auftragslogik neu anwenden'
        TabOrder = 19
        OnClick = Button4Click
      end
      object ProgressBar1: TProgressBar
        Left = 8
        Top = 432
        Width = 289
        Height = 16
        TabOrder = 20
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 584
    Top = 320
  end
  object IB_Query1: TIB_Query
    DatabaseName = '192.168.115.25:test.fdb'
    FieldsAlignment.Strings = (
      'GRUPPE_R=LEFT')
    FieldsDisplayFormat.Strings = (
      'EINGANG=dd.mm.yy'
      'VERFALL=dd.mm.yy')
    FieldsDisplayLabel.Strings = (
      'RID=Auftrag#'
      'KUNDE=Kunde (Name)'
      'CODE_BACK_OFFICE=BuE-Nr'
      'EINGANG=Eingang'
      'ABSCHLUSS=Abschluss'
      'KUNDE2=Kunde (Abt.)'
      'NAME=Bezeichnung'
      'GRUPPE_R=von Gruppe'
      'BU_NO=Bu.Auftrags#'
      'VERFALL=bearb. bis'
      'OWNER_R=Owner'
      'AOWNER=A-Owner')
    FieldsDisplayWidth.Strings = (
      'RID=70'
      'KUNDE=100'
      'CODE_BACK_OFFICE=80'
      'EINGANG=54'
      'GRUPPE_R=80'
      'VERFALL=54'
      'ABSCHLUSS=70'
      'KUNDE2=100'
      'NAME=120'
      'BU_NO=90'
      'OWNER_R=65'
      'AOWNER=65')
    FieldsReadOnly.Strings = (
      'VERFALL=NOEDIT')
    FieldsVisible.Strings = (
      'ARBEITSBEREICH_R=FALSE'
      'BEARBEITER_R=FALSE'
      'ANLAGE=FALSE'
      'BEGINN=FALSE'
      'ABSCHLUSS=FALSE'
      'STATUS=FALSE'
      'INFO=FALSE'
      'CODE_FRONT_OFFICE=FALSE'
      'ANFRAGER_R=FALSE'
      'AUFTRAGGEBER_R=FALSE'
      'POSTEN_RID=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT        '
      '       QAUFTRAG.RID'
      '     , QAUFTRAG.KUNDE2'
      '     , QAUFTRAG.KUNDE'
      '     , QAUFTRAG.BU_NO'
      '     , QAUFTRAG.CODE_BACK_OFFICE'
      '     , QAUFTRAG.EINGANG'
      '     , QPOSTEN.NAME'
      '     , QPOSTEN.GRUPPE_R'
      '     , QPOSTEN.VERFALL'
      '     , QPOSTEN.RID AS POSTEN_RID'
      '     , QPOSTEN.OWNER_R'
      'FROM '
      ' QAUFTRAG'
      'LEFT JOIN '
      ' QPOSTEN'
      'ON '
      ' (QAUFTRAG.RID = QPOSTEN.QAUFTRAG_R)')
    ColorScheme = True
    OrderingItems.Strings = (
      'Auftrag#=AUFTRAG.RID;AUFTRAG.RID DESC'
      'Kunde (Abt.)=AUFTRAG.KUNDE2;AUFTRAG.KUNDE2 DESC'
      'Kunde (Name)=AUFTRAG.KUNDE;AUFTRAG.KUNDE DESC'
      'Bu.Auftrags#=AUFTRAG.BU_NO;AUFTRAG.BU_NO DESC'
      'BuE-Nr=AUFTRAG.CODE_BACK_OFFICE;AUFTRAG.CODE_BACK_OFFICE DESC'
      'Eingang=AUFTRAG.EINGANG;AUFTRAG.EINGANG DESC'
      'Bezeichnung=POSTEN.NAME;POSTEN.NAME DESC'
      'von Gruppe=POSTEN.GRUPPE_R;POSTEN.GRUPPE_R DESC'
      'bearb. bis=POSTEN.VERFALL;POSTEN.VERFALL DESC'
      'Owner=POSTEN.OWNER_R;POSTEN.OWNER_R DESC')
    OrderingLinks.Strings = (
      'RID=ITEM=1'
      'KUNDE2=ITEM=2'
      'KUNDE=ITEM=3'
      'BU_NO=ITEM=4'
      'CODE_BACK_OFFICE=ITEM=5'
      'EINGANG=ITEM=6'
      'NAME=ITEM=7'
      'GRUPPE_R=ITEM=8'
      'VERFALL=ITEM=9'
      'OWNER_R=ITEM=10')
    RequestLive = True
    Left = 616
    Top = 320
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 648
    Top = 320
  end
  object IB_Query2: TIB_Query
    DatabaseName = '192.168.115.25:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT '
      ' * '
      'FROM'
      ' QAUFTRAG')
    Left = 552
    Top = 352
  end
  object IB_Query3: TIB_Query
    DatabaseName = '192.168.115.25:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT '
      ' NAME,'
      ' RID'
      'FROM'
      ' QPOSTEN'
      'WHERE'
      ' QAUFTRAG_R=:CROSSREF')
    Left = 584
    Top = 352
  end
end
