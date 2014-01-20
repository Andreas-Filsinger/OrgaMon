object FormVerlag: TFormVerlag
  Left = 36
  Top = 24
  Caption = 'Lieferanten / Lager'
  ClientHeight = 656
  ClientWidth = 781
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
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 781
    Height = 656
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #220'bersicht'
      object Label1: TLabel
        Left = 8
        Top = 43
        Width = 37
        Height = 13
        Caption = 'Verlag'
      end
      object Label2: TLabel
        Left = 308
        Top = 27
        Width = 42
        Height = 13
        Caption = 'Artikel-'
      end
      object Label3: TLabel
        Left = 352
        Top = 27
        Width = 37
        Height = 13
        Caption = 'Lager-'
      end
      object Label4: TLabel
        Left = 568
        Top = 579
        Width = 37
        Height = 13
        Caption = 'Label4'
      end
      object Label5: TLabel
        Left = 56
        Top = 43
        Width = 37
        Height = 13
        Caption = 'Label5'
      end
      object Label6: TLabel
        Left = 308
        Top = 43
        Width = 38
        Height = 13
        Caption = 'Anzahl'
      end
      object Label7: TLabel
        Left = 352
        Top = 43
        Width = 37
        Height = 13
        Caption = 'Menge'
      end
      object Label8: TLabel
        Left = 392
        Top = 27
        Width = 37
        Height = 13
        Caption = 'Lager-'
      end
      object Label9: TLabel
        Left = 392
        Top = 43
        Width = 35
        Height = 13
        Caption = 'Gr'#246#223'e'
      end
      object Label12: TLabel
        Left = 519
        Top = 41
        Width = 53
        Height = 13
        Caption = 'Artikel ...'
      end
      object Label13: TLabel
        Left = 432
        Top = 3
        Width = 37
        Height = 13
        Caption = 'Lager-'
      end
      object Label14: TLabel
        Left = 432
        Top = 15
        Width = 37
        Height = 13
        Caption = 'bedarf'
      end
      object Label10: TLabel
        Left = 476
        Top = 27
        Width = 37
        Height = 13
        Caption = 'Lager-'
      end
      object Label11: TLabel
        Left = 476
        Top = 43
        Width = 34
        Height = 13
        Caption = 'Pl'#228'tze'
      end
      object Label15: TLabel
        Left = 432
        Top = 28
        Width = 16
        Height = 13
        Caption = 'Im'
      end
      object Label16: TLabel
        Left = 432
        Top = 42
        Width = 32
        Height = 13
        Caption = 'Lager'
      end
      object Label17: TLabel
        Left = 384
        Top = 611
        Width = 376
        Height = 13
        Caption = 'notwendig, um zu ermitteln ob es neue Verlags-Zuordnungen gibt'
      end
      object DrawGrid1: TDrawGrid
        Left = 8
        Top = 59
        Width = 753
        Height = 505
        DefaultDrawing = False
        FixedCols = 0
        FixedRows = 0
        GridLineWidth = 0
        Options = [goRowSelect, goThumbTracking]
        ScrollBars = ssVertical
        TabOrder = 0
        OnDblClick = DrawGrid1DblClick
        OnDrawCell = DrawGrid1DrawCell
      end
      object Button1: TButton
        Left = 634
        Top = 571
        Width = 127
        Height = 25
        Caption = 'Liste abgleichen'
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 696
        Top = 35
        Width = 22
        Height = 22
        Hint = 'Zur Adresse springen'
        Caption = '&P'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = Button2Click
      end
      object StaticText1: TStaticText
        Left = 310
        Top = 575
        Width = 40
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '00000'
        TabOrder = 3
      end
      object StaticText2: TStaticText
        Left = 350
        Top = 575
        Width = 40
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '00000'
        TabOrder = 4
      end
      object StaticText3: TStaticText
        Left = 390
        Top = 575
        Width = 40
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '00000'
        TabOrder = 5
      end
      object StaticText4: TStaticText
        Left = 430
        Top = 575
        Width = 40
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '00000'
        TabOrder = 6
      end
      object StaticText5: TStaticText
        Left = 470
        Top = 575
        Width = 40
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '00000'
        TabOrder = 7
      end
      object StaticText6: TStaticText
        Left = 430
        Top = 592
        Width = 40
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '00000'
        TabOrder = 8
      end
      object Button6: TButton
        Left = 720
        Top = 35
        Width = 22
        Height = 22
        Hint = 'Zum Preiscode springen'
        Caption = '&C'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        OnClick = Button6Click
      end
      object ProgressBar1: TProgressBar
        Left = 11
        Top = 15
        Width = 222
        Height = 16
        TabOrder = 10
      end
      object Button5: TButton
        Left = 673
        Top = 35
        Width = 22
        Height = 22
        Hint = 'neue Lagerpl'#228'tze'
        Caption = '&L+'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
        OnClick = Button5Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Definition'
      ImageIndex = 1
      object Label18: TLabel
        Left = 182
        Top = 84
        Width = 183
        Height = 13
        Caption = 'Verlagsstatistikstart neu setzten'
      end
      object Button8: TButton
        Left = 72
        Top = 48
        Width = 457
        Height = 25
        Caption = 'Button8'
        TabOrder = 0
        OnClick = Button8Click
      end
      object Edit1: TEdit
        Left = 368
        Top = 80
        Width = 81
        Height = 21
        TabOrder = 1
        Text = '01.01.2001'
      end
      object Button7: TButton
        Left = 453
        Top = 78
        Width = 75
        Height = 25
        Caption = 'setzen'
        TabOrder = 2
        OnClick = Button7Click
      end
    end
  end
  object IB_Query1: TIB_Query
    DatabaseName = 'fred:C:\hebu\HeBu001.gdb'
    SQL.Strings = (
      'SELECT SUCHBEGRIFF'
      'FROM PERSON WHERE'
      'RID=:CROSSREF')
    ColorScheme = True
    MasterSearchFlags = [msfOpenMasterOnOpen, msfSearchAppliesToMasterOnly]
    BufferSynchroFlags = []
    FetchWholeRows = True
    Left = 40
    Top = 264
  end
  object IB_Query2: TIB_Query
    DatabaseName = 'fred:C:\hebu\HeBu001.gdb'
    SQL.Strings = (
      'SELECT VERLAG_R,'
      '       MENGE ,'
      '       MINDESTBESTAND'
      'FROM ARTIKEL WHERE'
      'NOT(VERLAG_R IS NULL)'
      'ORDER BY VERLAG_R')
    ColorScheme = True
    MasterSearchFlags = [msfOpenMasterOnOpen, msfSearchAppliesToMasterOnly]
    BufferSynchroFlags = []
    FetchWholeRows = True
    Left = 40
    Top = 232
  end
  object IB_Query3: TIB_Query
    DatabaseName = 'fred:C:\hebu\HeBu001.gdb'
    SQL.Strings = (
      'SELECT * FROM VERLAG'
      'WHERE RID=:CROSSREF'
      'FOR UPDATE')
    ColorScheme = True
    MasterSearchFlags = [msfOpenMasterOnOpen, msfSearchAppliesToMasterOnly]
    RequestLive = True
    BufferSynchroFlags = []
    FetchWholeRows = True
    Left = 568
    Top = 48
  end
  object IB_Query4: TIB_Query
    DatabaseName = 'fred:C:\hebu\HeBu001.gdb'
    SQL.Strings = (
      'SELECT RID FROM VERLAG')
    ColorScheme = True
    MasterSearchFlags = [msfOpenMasterOnOpen, msfSearchAppliesToMasterOnly]
    BufferSynchroFlags = []
    FetchWholeRows = True
    Left = 600
    Top = 48
  end
  object IB_DSQL1: TIB_DSQL
    DatabaseName = 'fred:C:\hebu\HeBu001.gdb'
    SQL.Strings = (
      'SELECT COUNT(RID) RID FROM LAGER'
      'WHERE VERLAG_R=:CROSSREF')
    Left = 80
    Top = 232
  end
  object IB_DSQL3: TIB_DSQL
    DatabaseName = 'fred:C:\hebu\HeBu001.gdb'
    SQL.Strings = (
      'SELECT COUNT(RID) RID FROM ARTIKEL'
      'WHERE (VERLAG_R=:CROSSREF) AND'
      '      NOT(LAGER_R IS NULL) '
      '      ')
    Left = 80
    Top = 264
  end
  object IB_Query8: TIB_Query
    DatabaseName = '192.168.115.90:sewa.fdb'
    IB_Connection = DataModuleHeBu.IB_Connection1
    SQL.Strings = (
      'SELECT'
      '     VERLAG_STAT_START'
      'FROM'
      ' ARTIKEL'
      'WHERE'
      ' (VERLAG_R=:CROSSREF) AND'
      ' VERLAG_STAT_START IS NULL'
      'FOR UPDATE '
      ' ')
    ColorScheme = False
    MasterSearchFlags = [msfOpenMasterOnOpen, msfSearchAppliesToMasterOnly]
    RequestLive = True
    BufferSynchroFlags = []
    FetchWholeRows = True
    Left = 144
    Top = 328
  end
end
