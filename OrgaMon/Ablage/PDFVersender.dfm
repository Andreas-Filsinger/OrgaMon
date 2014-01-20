object FormPDFVersender: TFormPDFVersender
  Left = 56
  Top = 261
  Caption = 'FormPDFVersender'
  ClientHeight = 352
  ClientWidth = 854
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 53
    Height = 13
    Caption = 'Diagnose'
  end
  object Label2: TLabel
    Left = 16
    Top = 128
    Width = 20
    Height = 13
    Caption = 'Log'
  end
  object Label3: TLabel
    Left = 16
    Top = 288
    Width = 58
    Height = 13
    Caption = 'RX (pop3)'
  end
  object Label4: TLabel
    Left = 16
    Top = 312
    Width = 57
    Height = 13
    Caption = 'TX (smtp)'
  end
  object Label5: TLabel
    Left = 88
    Top = 312
    Width = 37
    Height = 13
    Caption = 'Label5'
  end
  object ListBox1: TListBox
    Left = 16
    Top = 24
    Width = 833
    Height = 97
    ItemHeight = 13
    TabOrder = 0
  end
  object Button1: TButton
    Left = 680
    Top = 264
    Width = 169
    Height = 73
    Caption = 'jetzt!'
    TabOrder = 1
    OnClick = Button1Click
  end
  object ListBox2: TListBox
    Left = 16
    Top = 144
    Width = 833
    Height = 113
    ItemHeight = 13
    TabOrder = 2
  end
  object CheckBox2: TCheckBox
    Left = 16
    Top = 264
    Width = 257
    Height = 17
    Caption = 'Antworten versenden'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object ProgressBar1: TProgressBar
    Left = 168
    Top = 312
    Width = 497
    Height = 17
    TabOrder = 4
  end
  object ProgressBar2: TProgressBar
    Left = 168
    Top = 288
    Width = 497
    Height = 17
    TabOrder = 5
  end
  object Timer1: TTimer
    Interval = 120000
    OnTimer = Timer1Timer
    Left = 104
    Top = 40
  end
  object IdPOP31: TIdPOP3
    MaxLineAction = maException
    OnWork = IdPOP31Work
    OnWorkBegin = IdPOP31WorkBegin
    OnWorkEnd = IdPOP31WorkEnd
    Left = 136
    Top = 40
  end
  object IB_Query2: TIB_Query
    DatabaseName = '192.168.115.90:hebu.fdb'
    IB_Connection = DataModuleHeBu.IB_Connection1
    SQL.Strings = (
      'SELECT'
      '       TITEL'
      '     , RID'
      'FROM '
      ' ARTIKEL'
      'WHERE'
      ' NUMERO=:CROSSREF')
    ColorScheme = False
    MasterSearchFlags = [msfOpenMasterOnOpen, msfSearchAppliesToMasterOnly]
    BufferSynchroFlags = []
    FetchWholeRows = True
    Left = 200
    Top = 40
  end
  object IB_Query3: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED')
    DatabaseName = '192.168.115.90:hebu.fdb'
    IB_Connection = DataModuleHeBu.IB_Connection1
    SQL.Strings = (
      'SELECT '
      ' * '
      'FROM '
      ' WEBPROFIL '
      'FOR INSERT')
    ColorScheme = False
    MasterSearchFlags = [msfOpenMasterOnOpen, msfSearchAppliesToMasterOnly]
    RequestLive = True
    BufferSynchroFlags = []
    FetchWholeRows = True
    Left = 232
    Top = 40
  end
  object IB_Query4: TIB_Query
    DatabaseName = '192.168.115.90:hebu.fdb'
    IB_Connection = DataModuleHeBu.IB_Connection1
    SQL.Strings = (
      'SELECT'
      ' EMAIL'
      'FROM'
      ' PERSON'
      'WHERE'
      ' RID=:CROSSREF')
    ColorScheme = False
    MasterSearchFlags = [msfOpenMasterOnOpen, msfSearchAppliesToMasterOnly]
    BufferSynchroFlags = []
    FetchWholeRows = True
    Left = 264
    Top = 40
  end
  object IdSMTP1: TIdSMTP
    MaxLineAction = maException
    OnWork = IdSMTP1Work
    OnWorkEnd = IdSMTP1WorkEnd
    Port = 25
    AuthenticationType = atLogin
    Left = 136
    Top = 72
  end
end
