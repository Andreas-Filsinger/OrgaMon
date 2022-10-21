object FormArtikelLeistung: TFormArtikelLeistung
  Left = 22
  Top = 19
  Caption = 'Leistungen'
  ClientHeight = 875
  ClientWidth = 1044
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  DesignSize = (
    1044
    875)
  PixelsPerInch = 120
  TextHeight = 17
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1042
    Height = 54
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 0
    object IB_NavigationBar1: TIB_NavigationBar
      Left = 10
      Top = 10
      Width = 156
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      DataSource = IB_DataSource1
      ReceiveFocus = False
      CustomGlyphsSupplied = []
    end
    object IB_UpdateBar1: TIB_UpdateBar
      Left = 167
      Top = 10
      Width = 114
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      DataSource = IB_DataSource1
      ReceiveFocus = False
      CustomGlyphsSupplied = []
      VisibleButtons = [ubPost, ubCancel, ubRefreshAll]
    end
    object Button2: TButton
      Left = 1004
      Top = 21
      Width = 29
      Height = 29
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '&A'
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object IB_Grid1: TIB_Grid
    Left = 0
    Top = 54
    Width = 1040
    Height = 667
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    DefaultRowHeight = 22
  end
  object Panel2: TPanel
    Left = 0
    Top = 722
    Width = 1042
    Height = 152
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 2
    object Label1: TLabel
      Left = 58
      Top = 26
      Width = 36
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Code'
    end
    object Label2: TLabel
      Left = 4
      Top = 55
      Width = 89
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Bezeichnung'
    end
    object Label3: TLabel
      Left = 64
      Top = 84
      Width = 31
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'GOT'
    end
    object Label4: TLabel
      Left = 290
      Top = 82
      Width = 44
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Faktor'
    end
    object Label5: TLabel
      Left = 301
      Top = 111
      Width = 33
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Preis'
    end
    object Label6: TLabel
      Left = 579
      Top = 30
      Width = 70
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Sortiment'
    end
    object Label7: TLabel
      Left = 609
      Top = 69
      Width = 38
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Paket'
    end
    object IB_Text1: TIB_Text
      Left = 655
      Top = 24
      Width = 351
      Height = 30
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      DataField = 'SORTIMENT_R'
      DataSource = IB_DataSource1
      BevelInner = bvLowered
    end
    object IB_Text2: TIB_Text
      Left = 655
      Top = 63
      Width = 351
      Height = 32
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      DataField = 'PAKET_R'
      DataSource = IB_DataSource1
      BevelInner = bvLowered
    end
    object IB_Edit1: TIB_Edit
      Left = 101
      Top = 21
      Width = 158
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      DataField = 'CODE'
      DataSource = IB_DataSource1
      TabOrder = 0
    end
    object IB_Edit2: TIB_Edit
      Left = 101
      Top = 50
      Width = 434
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      DataField = 'TITEL'
      DataSource = IB_DataSource1
      TabOrder = 1
    end
    object IB_Edit3: TIB_Edit
      Left = 101
      Top = 78
      Width = 158
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      DataField = 'VERLAGNO'
      DataSource = IB_DataSource1
      TabOrder = 2
    end
    object IB_Edit4: TIB_Edit
      Left = 341
      Top = 77
      Width = 159
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      DataField = 'FAKTOR'
      DataSource = IB_DataSource1
      TabOrder = 3
    end
    object IB_Edit5: TIB_Edit
      Left = 341
      Top = 106
      Width = 159
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      DataField = 'EURO'
      DataSource = IB_DataSource1
      TabOrder = 4
    end
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 112
    Top = 96
  end
  object IB_Query1: TIB_Query
    DatabaseName = '192.168.115.6:test.fdb'
    FieldsDisplayLabel.Strings = (
      'VERLAGNO=GOT'
      'TITEL=Bezeichnung'
      'EINHEIT_R=EINH')
    FieldsDisplayWidth.Strings = (
      'TITEL=280'
      'CODE=80'
      'VERLAGNO=80'
      'EINHEIT_R=50')
    FieldsReadOnly.Strings = (
      'RID=NOEDIT')
    FieldsVisible.Strings = (
      'PAKET_R=FALSE'
      'SORTIMENT_R=FALSE'
      'RID=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select '
      ' CODE,'
      ' TITEL,'
      ' VERLAGNO,'
      'FAKTOR,'
      'EINHEIT_R,'
      'EURO,'
      'EURP,'
      'SORTIMENT_R,'
      'PAKET_R,'
      ' RID'
      'from artikel'
      'for update')
    ColorScheme = True
    OrderingItems.Strings = (
      'CODE=CODE;CODE DESC'
      'TITEL=TITEL;TITEL DESC'
      'GOT=VERLAGNO;VERLAGNO DESC'
      'FAKTOR=FAKTOR;FAKTOR DESC'
      'EURO=EURO;EURO DESC'
      'EINHEIT_R=EINHEIT_R;EINHEIT_R DESC')
    OrderingLinks.Strings = (
      'CODE=ITEM=1'
      'TITEL=ITEM=2'
      'VERLAGNO=ITEM=3'
      'FAKTOR=ITEM=4'
      'EURO=ITEM=5'
      'EINHEIT_R=ITEM=6')
    RequestLive = True
    Left = 24
    Top = 96
  end
end
