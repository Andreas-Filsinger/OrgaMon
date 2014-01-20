object FormQGruppe: TFormQGruppe
  Left = 29
  Top = 66
  Caption = 'Gruppen'
  ClientHeight = 447
  ClientWidth = 651
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 400
    Top = 48
    Width = 72
    Height = 13
    Caption = '&Normal-User'
    FocusControl = CheckListBox1
  end
  object Label3: TLabel
    Left = 528
    Top = 48
    Width = 72
    Height = 13
    Caption = '&Spezial-User'
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 521
    Height = 41
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 49
      Height = 13
      Caption = '&Gruppen'
      FocusControl = IB_Grid1
    end
    object IB_UpdateBar1: TIB_UpdateBar
      Left = 184
      Top = 8
      Width = 125
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      DataSource = IB_DataSource1
      ReceiveFocus = False
      CustomGlyphsSupplied = []
      VisibleButtons = [ubEdit, ubDelete, ubPost, ubCancel, ubRefreshAll]
    end
    object IB_NavigationBar1: TIB_NavigationBar
      Left = 72
      Top = 8
      Width = 104
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      DataSource = IB_DataSource1
      ReceiveFocus = False
      CustomGlyphsSupplied = []
    end
    object Button1: TButton
      Left = 336
      Top = 8
      Width = 25
      Height = 25
      Caption = '+'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button1Click
    end
  end
  object IB_Grid1: TIB_Grid
    Left = 0
    Top = 48
    Width = 393
    Height = 297
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    PreventDeleting = True
    TabOrder = 1
  end
  object IB_Memo1: TIB_Memo
    Left = 0
    Top = 344
    Width = 393
    Height = 89
    DataField = 'TEXT'
    DataSource = IB_DataSource1
    TabOrder = 2
    AutoSize = False
  end
  object CheckListBox1: TCheckListBox
    Left = 400
    Top = 64
    Width = 121
    Height = 369
    OnClickCheck = CheckListBox1ClickCheck
    ItemHeight = 13
    TabOrder = 3
  end
  object CheckListBox2: TCheckListBox
    Left = 528
    Top = 64
    Width = 121
    Height = 369
    OnClickCheck = CheckListBox2ClickCheck
    ItemHeight = 13
    TabOrder = 4
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 424
    Top = 8
  end
  object IB_Query1: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED')
    DatabaseName = '192.168.115.91:test.fdb'
    FieldsVisible.Strings = (
      'RID=FALSE'
      'MITGLIEDERLISTE_R=FALSE'
      'TEXT=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT '
      '       KUERZEL'
      '     , NAME'
      '     , TEXT'
      '     , MITGLIEDERLISTE_R'
      '     , RID'
      'FROM GRUPPE'
      'ORDER BY KUERZEL'
      'FOR UPDATE')
    ColorScheme = True
    KeyLinks.Strings = (
      'GRUPPE.RID')
    RequestLive = True
    AfterScroll = IB_Query1AfterScroll
    BeforePost = IB_Query1BeforePost
    Left = 392
    Top = 8
  end
end
