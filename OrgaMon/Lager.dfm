object FormLager: TFormLager
  Left = 0
  Top = 1
  Caption = 'Lager'
  ClientHeight = 642
  ClientWidth = 956
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 956
    Height = 41
    Align = alTop
    TabOrder = 0
    object Label10: TLabel
      Left = 528
      Top = 16
      Width = 44
      Height = 13
      Caption = 'Label10'
    end
    object IB_SearchBar1: TIB_SearchBar
      Left = 16
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
    object IB_NavigationBar1: TIB_NavigationBar
      Left = 152
      Top = 8
      Width = 112
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      DataSource = IB_DataSource1
      ReceiveFocus = False
      CustomGlyphsSupplied = []
    end
    object IB_UpdateBar1: TIB_UpdateBar
      Left = 280
      Top = 8
      Width = 186
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 2
      DataSource = IB_DataSource1
      ReceiveFocus = False
      CustomGlyphsSupplied = []
      VisibleButtons = [ubEdit, ubInsert, ubDelete, ubPost, ubCancel, ubRefreshAll]
    end
  end
  object IB_Grid1: TIB_Grid
    Left = 0
    Top = 40
    Width = 953
    Height = 457
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 504
    Width = 953
    Height = 137
    ActivePage = TabSheet4
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Lageranlage'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 7
        Top = 12
        Width = 70
        Height = 13
        Caption = 'XX __ __ __'
      end
      object Label2: TLabel
        Left = 7
        Top = 36
        Width = 70
        Height = 13
        Caption = '__ XX __ __'
      end
      object Label3: TLabel
        Left = 7
        Top = 60
        Width = 70
        Height = 13
        Caption = '__ __ XX __'
      end
      object Label4: TLabel
        Left = 7
        Top = 83
        Width = 70
        Height = 13
        Caption = '__ __ __ XX'
      end
      object Label5: TLabel
        Left = 592
        Top = 40
        Width = 37
        Height = 13
        Caption = 'Label5'
      end
      object Label6: TLabel
        Left = 592
        Top = 11
        Width = 71
        Height = 13
        Caption = 'mit Volumen'
      end
      object Edit1: TEdit
        Left = 80
        Top = 8
        Width = 497
        Height = 25
        TabOrder = 0
        Text = 'A,B,C,D,E,F,G'
        OnChange = Edit1Change
      end
      object Edit2: TEdit
        Left = 80
        Top = 32
        Width = 497
        Height = 25
        TabOrder = 1
        Text = '01-,02-,03-'
        OnChange = Edit2Change
      end
      object Edit3: TEdit
        Left = 80
        Top = 56
        Width = 497
        Height = 25
        TabOrder = 2
        Text = '1,2,3,4,5'
        OnChange = Edit3Change
      end
      object Edit4: TEdit
        Left = 80
        Top = 80
        Width = 497
        Height = 25
        TabOrder = 3
        Text = '1,2,3,4'
        OnChange = Edit4Change
      end
      object Button1: TButton
        Left = 592
        Top = 56
        Width = 169
        Height = 25
        Caption = 'Pl'#228'tze erzeugen'
        TabOrder = 4
        OnClick = Button1Click
      end
      object CheckBox1: TCheckBox
        Left = 592
        Top = 82
        Width = 273
        Height = 17
        Caption = 'auch in die Datenbank einf'#252'gen'
        TabOrder = 5
      end
      object Edit5: TEdit
        Left = 669
        Top = 8
        Width = 60
        Height = 25
        TabOrder = 6
        Text = '1'
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Zuordnung zum Verlag'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label7: TLabel
        Left = 240
        Top = 46
        Width = 5
        Height = 13
        Caption = '-'
      end
      object Label8: TLabel
        Left = 239
        Top = 79
        Width = 5
        Height = 13
        Caption = '-'
      end
      object Label9: TLabel
        Left = 339
        Top = 54
        Width = 37
        Height = 13
        Caption = 'Label9'
      end
      object Label11: TLabel
        Left = 440
        Top = 12
        Width = 55
        Height = 13
        Caption = 'Diversit'#228't'
      end
      object Button2: TButton
        Left = 432
        Top = 80
        Width = 113
        Height = 25
        Caption = 'zuordnen'
        TabOrder = 0
        OnClick = Button2Click
      end
      object ComboBox1: TComboBox
        Left = 8
        Top = 13
        Width = 417
        Height = 25
        TabOrder = 1
        OnChange = ComboBox1Change
        OnDropDown = ComboBox1DropDown
      end
      object Button3: TButton
        Left = 8
        Top = 40
        Width = 75
        Height = 25
        Caption = 'von'
        TabOrder = 2
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 8
        Top = 72
        Width = 73
        Height = 25
        Caption = 'bis'
        TabOrder = 3
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 336
        Top = 72
        Width = 75
        Height = 25
        Caption = 'Summe'
        TabOrder = 4
        OnClick = Button5Click
      end
      object Button6: TButton
        Left = 88
        Top = 40
        Width = 137
        Height = 25
        Caption = 'erster freie'
        TabOrder = 5
        OnClick = Button6Click
      end
      object Edit6: TEdit
        Left = 88
        Top = 72
        Width = 56
        Height = 25
        TabOrder = 6
        Text = '3'
      end
      object Button7: TButton
        Left = 150
        Top = 72
        Width = 75
        Height = 25
        Caption = 'Pl'#228'tze'
        TabOrder = 7
        OnClick = Button7Click
      end
      object CheckBox3: TCheckBox
        Left = 440
        Top = 32
        Width = 289
        Height = 17
        Caption = 'Freigabe, sobald MENGE auf Null f'#228'llt?'
        TabOrder = 8
      end
      object Edit7: TEdit
        Left = 502
        Top = 8
        Width = 46
        Height = 25
        TabOrder = 9
        Text = '1'
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Auswerten'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Button8: TButton
        Left = 72
        Top = 16
        Width = 121
        Height = 25
        Caption = 'Lager Liste Typ "B"'
        TabOrder = 0
        OnClick = Button8Click
      end
      object CheckBox2: TCheckBox
        Left = 208
        Top = 16
        Width = 529
        Height = 17
        Caption = 'nur die belegten'
        TabOrder = 1
      end
      object Button10: TButton
        Left = 72
        Top = 48
        Width = 225
        Height = 25
        Caption = 'Lager Liste Typ "A"'
        TabOrder = 2
        OnClick = Button10Click
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Zuordnen zum Artikel'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Button9: TButton
        Left = 16
        Top = 64
        Width = 225
        Height = 25
        Caption = 'Artikel auf Pl'#228'tze zuteilen'
        TabOrder = 0
        OnClick = Button9Click
      end
      object CheckBox4: TCheckBox
        Left = 16
        Top = 24
        Width = 249
        Height = 17
        Caption = 'Artikel mit Lager-Verlagen einlagern'
        TabOrder = 1
      end
      object CheckBox5: TCheckBox
        Left = 16
        Top = 40
        Width = 273
        Height = 17
        Caption = 'Artikel auf freies Lager einlagern'
        TabOrder = 2
      end
      object Button11: TButton
        Left = 264
        Top = 64
        Width = 169
        Height = 25
        Caption = 'Lagerpl'#228'tze freigeben'
        TabOrder = 3
        OnClick = Button11Click
      end
    end
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 64
    Top = 88
  end
  object IB_Query1: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED'
      'FREIGABE=BOOLEAN=Y,N')
    DatabaseName = '192.168.115.1:test.fdb'
    FieldsVisible.Strings = (
      'STANDORT=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT RID'
      '     , NAME'
      '     , X'
      '     , Y'
      '     , Z'
      '     , VOLUMEN'
      '     , DIVERSITAET'
      '     , VERLAG_R'
      '     , SORTIMENT_R'
      '     , FREIGABE'
      'FROM LAGER'
      'ORDER BY NAME'
      'FOR UPDATE')
    ColorScheme = True
    KeyLinks.Strings = (
      'RID')
    KeyLinksAutoDefine = False
    KeyRelation = 'LAGER'
    OrderingItems.Strings = (
      'RID=RID;RID DESC'
      'NAME=NAME;NAME DESC'
      'X=X;X DESC'
      'Y=Y;Y DESC'
      'Z=Z;Z DESC'
      'VOLUMEN=VOLUMEN;VOLUMEN DESC'
      'DIVERSITAET=DIVERSITAET;DIVERSITAET DESC'
      'VERLAG_R=VERLAG_R;VERLAG_R DESC'
      'FREIGABE=FREIGABE;FREIGABE DESC')
    OrderingLinks.Strings = (
      'RID=ITEM=1'
      'NAME=ITEM=2'
      'X=ITEM=3'
      'Y=ITEM=4'
      'Z=ITEM=5'
      'VOLUMEN=ITEM=6'
      'DIVERSITAET=ITEM=7'
      'VERLAG_R=ITEM=8'
      'FREIGABE=ITEM=9')
    RequestLive = True
    AfterScroll = IB_Query1AfterScroll
    Left = 32
    Top = 88
  end
  object IB_Query2: TIB_Query
    DatabaseName = '192.168.115.1:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT * FROM LAGER '
      '  WHERE'
      ' (NAME>=:CR1) AND'
      ' (NAME<=:CR2) AND'
      ' (VERLAG_R IS NULL)'
      'FOR UPDATE')
    RequestLive = True
    Left = 648
    Top = 8
  end
  object IB_Query3: TIB_Query
    DatabaseName = '192.168.115.1:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT RID'
      '      ,NAME FROM LAGER'
      'WHERE (VERLAG_R IS NULL)'
      'ORDER BY NAME')
    Left = 562
    Top = 426
  end
  object IB_Query4: TIB_Query
    DatabaseName = '192.168.115.1:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT NAME FROM '
      'LAGER WHERE RID=:CROSSREF')
    Left = 594
    Top = 426
  end
  object IB_Query5: TIB_Query
    DatabaseName = '192.168.115.1:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT * FROM ARTIKEL'
      'WHERE (LAGER_R=:CROSSREF)')
    Left = 514
    Top = 418
  end
  object IB_Query6: TIB_Query
    DatabaseName = '192.168.115.1:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT RID,'
      '       LAGER_R'
      'FROM BELEG'
      'WHERE NOT(LAGER_R IS NULL) AND'
      '      ( (LIEFERANSCHRIFT_R=:CROSSREF) OR'
      '        ((PERSON_R=:CROSSREF) AND (LIEFERANSCHRIFT_R IS NULL))'
      '      )')
    Left = 224
    Top = 416
  end
  object IB_Query7: TIB_Query
    DatabaseName = '192.168.115.1:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT RID '
      'FROM LAGER '
      'WHERE VERLAG_R=:CROSSREF')
    Left = 256
    Top = 416
  end
  object IB_Query8: TIB_Query
    DatabaseName = '192.168.115.1:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT RID '
      'FROM BELEG'
      'WHERE LAGER_R=:CROSSREF')
    Left = 288
    Top = 416
  end
end
