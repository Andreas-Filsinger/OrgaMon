object FormQProfil: TFormQProfil
  Left = 7
  Top = 29
  Caption = 'Profil und Phase'
  ClientHeight = 423
  ClientWidth = 661
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
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 657
    Height = 41
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 29
      Height = 13
      Caption = '&Profil'
      FocusControl = IB_Grid1
    end
    object IB_NavigationBar1: TIB_NavigationBar
      Left = 88
      Top = 8
      Width = 116
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
      Left = 209
      Top = 8
      Width = 104
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      DataSource = IB_DataSource1
      ReceiveFocus = False
      CustomGlyphsSupplied = []
      VisibleButtons = [ubEdit, ubPost, ubCancel, ubRefreshAll]
    end
    object Button1: TButton
      Left = 318
      Top = 8
      Width = 25
      Height = 25
      Caption = '&+'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button1Click
    end
    object Button4: TButton
      Left = 504
      Top = 8
      Width = 25
      Height = 25
      Caption = 'C'
      TabOrder = 3
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 343
      Top = 8
      Width = 25
      Height = 25
      Caption = '-'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = Button5Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 208
    Width = 657
    Height = 41
    TabOrder = 5
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 34
      Height = 13
      Caption = 'P&hase'
      FocusControl = IB_Grid2
    end
    object IB_NavigationBar2: TIB_NavigationBar
      Left = 88
      Top = 8
      Width = 116
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
      Left = 209
      Top = 8
      Width = 150
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      DataSource = IB_DataSource2
      ReceiveFocus = False
      CustomGlyphsSupplied = []
      VisibleButtons = [ubEdit, ubDelete, ubPost, ubCancel, ubRefreshAll]
    end
    object Button2: TButton
      Left = 366
      Top = 8
      Width = 25
      Height = 25
      Caption = '&+'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button2Click
    end
    object ComboBox1: TComboBox
      Left = 408
      Top = 8
      Width = 145
      Height = 21
      Style = csDropDownList
      TabOrder = 3
    end
    object Button3: TButton
      Left = 560
      Top = 8
      Width = 75
      Height = 25
      Caption = 'zuordnen'
      TabOrder = 4
      OnClick = Button3Click
    end
  end
  object IB_Grid1: TIB_Grid
    Left = 0
    Top = 40
    Width = 537
    Height = 161
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    PreventInserting = True
    TabOrder = 0
  end
  object IB_Grid2: TIB_Grid
    Left = 0
    Top = 248
    Width = 537
    Height = 161
    CustomGlyphsSupplied = []
    DefDrawBefore = False
    DataSource = IB_DataSource2
    PreventInserting = True
    TabOrder = 3
    OnDrawCell = IB_Grid2DrawCell
    OnDrawFocusedCell = IB_Grid2DrawFocusedCell
  end
  object IB_Memo1: TIB_Memo
    Left = 536
    Top = 248
    Width = 121
    Height = 161
    DataField = 'INFO'
    DataSource = IB_DataSource2
    TabOrder = 1
    AutoSize = False
  end
  object IB_Memo2: TIB_Memo
    Left = 536
    Top = 40
    Width = 121
    Height = 161
    DataField = 'INFO'
    DataSource = IB_DataSource1
    TabOrder = 4
    AutoSize = False
  end
  object IB_Query1: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED')
    DatabaseName = '192.168.115.25:test.fdb'
    FieldsDisplayLabel.Strings = (
      'NAME=Bezeichnung'
      'DAUER=Dauer')
    FieldsDisplayWidth.Strings = (
      'NAME=220'
      'DAUER=50')
    FieldsVisible.Strings = (
      'RID=FALSE'
      'INFO=FALSE'
      'ROHSTOFF_R=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT '
      '       NAME'
      '     , DAUER'
      '     , ROHSTOFF_R'
      '     , RID'
      '     , INFO'
      'FROM PROFIL'
      'FOR UPDATE')
    ColorScheme = True
    KeyLinks.Strings = (
      'PROFIL.RID')
    RequestLive = True
    AfterScroll = IB_Query1AfterScroll
    Left = 416
    Top = 8
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 448
    Top = 8
  end
  object IB_Query2: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED')
    DatabaseName = '192.168.115.25:test.fdb'
    FieldsAlignment.Strings = (
      'GRUPPE_R=LEFT')
    FieldsDisplayLabel.Strings = (
      'POSNR=Pos#'
      'NAME=Bezeichnung'
      'DAUER=Dauer'
      'GRUPPE_R=Gruppe')
    FieldsDisplayWidth.Strings = (
      'POSNR=40'
      'NAME=220'
      'DAUER=40'
      'GRUPPE_R=120')
    FieldsReadOnly.Strings = (
      'GRUPPE_R=NOEDIT')
    FieldsVisible.Strings = (
      'RID=FALSE'
      'INFO=FALSE'
      'PROFIL_R=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT '
      '       POSNR'
      '     , NAME'
      '     , DAUER'
      '     , PROFIL_R'
      '     , GRUPPE_R'
      '     , RID'
      '     , INFO'
      'FROM PHASE'
      'WHERE PROFIL_R=:CROSSREF'
      'ORDER BY POSNR,RID'
      'FOR UPDATE')
    ColorScheme = True
    KeyLinks.Strings = (
      'PHASE.RID')
    RequestLive = True
    BeforeInsert = IB_Query2BeforeInsert
    BeforePost = IB_Query2BeforePost
    Left = 416
    Top = 40
  end
  object IB_DataSource2: TIB_DataSource
    Dataset = IB_Query2
    Left = 448
    Top = 40
  end
  object IB_Query3: TIB_Query
    DatabaseName = '192.168.115.25:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT SUM(DAUER) D_SUMME'
      'FROM PHASE'
      'WHERE PROFIL_R=:CROSSREF')
    Left = 416
    Top = 72
  end
  object IB_DSQL1: TIB_DSQL
    DatabaseName = '192.168.115.25:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'DELETE FROM PHASE'
      'WHERE PROFIL_R=:CROSSREF')
    Left = 416
    Top = 104
  end
end
