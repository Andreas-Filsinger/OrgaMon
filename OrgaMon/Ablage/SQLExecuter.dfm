object FormSQLExecuter: TFormSQLExecuter
  Left = 217
  Top = 163
  Caption = 'Systempflege'
  ClientHeight = 541
  ClientWidth = 659
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 40
    Width = 649
    Height = 489
    ActivePage = TabSheet6
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Inkonsistenter Index'
      object Label2: TLabel
        Left = 360
        Top = 29
        Width = 90
        Height = 13
        Caption = 'inaktive Indizes'
      end
      object Label1: TLabel
        Left = 55
        Top = 211
        Width = 174
        Height = 13
        Caption = '----- referenziert auf ----->>>'
      end
      object Label4: TLabel
        Left = 8
        Top = 24
        Width = 265
        Height = 13
        Caption = '2) Versuch alle Prim'#228'ren Indizes zu aktivieren'
      end
      object Label5: TLabel
        Left = 8
        Top = 160
        Width = 179
        Height = 13
        Caption = '3) "no no" Referenzen aufl'#246'sen'
      end
      object Label6: TLabel
        Left = 360
        Top = 168
        Width = 74
        Height = 13
        Caption = '"no no" Keys'
      end
      object Label7: TLabel
        Left = 8
        Top = 320
        Width = 172
        Height = 13
        Caption = '4) "Dupilcate Value" Diagnose'
      end
      object ListBox1: TListBox
        Left = 360
        Top = 48
        Width = 257
        Height = 81
        ItemHeight = 13
        TabOrder = 0
      end
      object Edit1: TEdit
        Left = 24
        Top = 184
        Width = 153
        Height = 21
        TabOrder = 1
        Text = 'AUSGANGSRECHNUNG'
      end
      object Edit2: TEdit
        Left = 184
        Top = 184
        Width = 73
        Height = 21
        TabOrder = 2
        Text = 'BELEG_R'
      end
      object Edit3: TEdit
        Left = 44
        Top = 232
        Width = 133
        Height = 21
        TabOrder = 3
        Text = 'BELEG'
      end
      object Edit4: TEdit
        Left = 186
        Top = 231
        Width = 121
        Height = 21
        TabOrder = 4
        Text = 'RID'
      end
      object Button3: TButton
        Left = 8
        Top = 264
        Width = 169
        Height = 25
        Caption = 'Referenz-Diagnose und ...'
        TabOrder = 5
        OnClick = Button3Click
      end
      object CheckBox1: TCheckBox
        Left = 192
        Top = 264
        Width = 305
        Height = 17
        Caption = 'auch '#196'nderungen vornehmen!'
        TabOrder = 6
      end
      object Button4: TButton
        Left = 8
        Top = 48
        Width = 113
        Height = 25
        Caption = 'auflisten und ...'
        TabOrder = 7
        OnClick = Button4Click
      end
      object CheckBox2: TCheckBox
        Left = 136
        Top = 40
        Width = 217
        Height = 17
        Caption = 'PRIMARY Keys aktivieren'
        TabOrder = 8
      end
      object CheckBox3: TCheckBox
        Left = 136
        Top = 56
        Width = 217
        Height = 17
        Caption = 'FOREIGN Keys aktivieren'
        TabOrder = 9
      end
      object CheckBox4: TCheckBox
        Left = 136
        Top = 72
        Width = 217
        Height = 17
        Caption = '"den Rest" aktivieren'
        TabOrder = 10
      end
      object ListBox2: TListBox
        Left = 360
        Top = 184
        Width = 257
        Height = 65
        ItemHeight = 13
        TabOrder = 11
      end
      object Button5: TButton
        Left = 472
        Top = 136
        Width = 147
        Height = 25
        Caption = 'Einzelner Key aktivieren'
        TabOrder = 12
        OnClick = Button5Click
      end
      object CheckBox5: TCheckBox
        Left = 192
        Top = 280
        Width = 313
        Height = 17
        Caption = 'Korrektur durch l'#246'schen des Datensatzes'
        TabOrder = 13
      end
      object Edit5: TEdit
        Left = 32
        Top = 352
        Width = 121
        Height = 21
        TabOrder = 14
        Text = 'ARTIKEL'
      end
      object Edit6: TEdit
        Left = 168
        Top = 352
        Width = 121
        Height = 21
        TabOrder = 15
        Text = 'NUMERO'
      end
      object Button13: TButton
        Left = 320
        Top = 352
        Width = 75
        Height = 25
        Caption = 'anzeigen'
        TabOrder = 16
        OnClick = Button13Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Datenbank'
      ImageIndex = 1
      object Button1: TButton
        Left = 40
        Top = 8
        Width = 217
        Height = 25
        Caption = 'SQL Skript-Editor ausf'#252'hren'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 40
        Top = 40
        Width = 217
        Height = 25
        Caption = 'Datenbank Browser'
        TabOrder = 1
        OnClick = Button2Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Stapel-Transaktionen'
      ImageIndex = 2
      object Label3: TLabel
        Left = 16
        Top = 24
        Width = 171
        Height = 13
        Caption = '1) Transaktionstyp ausw'#228'hlen'
      end
      object Label13: TLabel
        Left = 16
        Top = 221
        Width = 134
        Height = 13
        Caption = '2) OLAP Ergebnis laden'
      end
      object Label14: TLabel
        Left = 16
        Top = 288
        Width = 144
        Height = 13
        Caption = '3) Transaktion ausf'#252'hren'
      end
      object Label15: TLabel
        Left = 16
        Top = 417
        Width = 43
        Height = 13
        Caption = '%d/%d'
      end
      object Label16: TLabel
        Left = 128
        Top = 262
        Width = 9
        Height = 13
        Caption = '#'
      end
      object Label17: TLabel
        Left = 573
        Top = 288
        Width = 9
        Height = 13
        Caption = '#'
      end
      object RadioButton1: TRadioButton
        Left = 40
        Top = 56
        Width = 265
        Height = 17
        Caption = 'Personen l'#246'schen'
        TabOrder = 0
      end
      object RadioButton2: TRadioButton
        Left = 40
        Top = 72
        Width = 337
        Height = 17
        Caption = 'Artikel l'#246'schen'
        TabOrder = 1
      end
      object RadioButton3: TRadioButton
        Left = 40
        Top = 88
        Width = 233
        Height = 17
        Caption = 'Belege l'#246'schen'
        TabOrder = 2
      end
      object Button6: TButton
        Left = 32
        Top = 257
        Width = 75
        Height = 25
        Caption = 'laden'
        TabOrder = 3
        OnClick = Button6Click
      end
      object ProgressBar1: TProgressBar
        Left = 16
        Top = 433
        Width = 519
        Height = 17
        TabOrder = 4
      end
      object Button7: TButton
        Left = 542
        Top = 429
        Width = 75
        Height = 25
        Caption = 'Ausf'#252'hren'
        TabOrder = 5
        OnClick = Button7Click
      end
      object RadioButton4: TRadioButton
        Left = 40
        Top = 104
        Width = 305
        Height = 17
        Caption = 'Order l'#246'schen'
        TabOrder = 6
      end
      object ListBox3: TListBox
        Left = 16
        Top = 307
        Width = 601
        Height = 104
        ItemHeight = 13
        TabOrder = 7
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Metadaten'
      ImageIndex = 3
      object SynMemo1: TSynMemo
        Left = 8
        Top = 40
        Width = 633
        Height = 281
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        TabOrder = 0
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Terminal'
        Gutter.Font.Style = []
        Highlighter = SynSQLSyn1
        Lines.Strings = (
          'SynMemo1')
        RemovedKeystrokes = <
          item
            Command = ecContextHelp
            ShortCut = 112
          end>
        AddedKeystrokes = <
          item
            Command = ecContextHelp
            ShortCut = 16496
          end>
      end
      object Button12: TButton
        Left = 8
        Top = 8
        Width = 265
        Height = 25
        Caption = 'Metadaten in die Diagnose'
        TabOrder = 1
        OnClick = Button12Click
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Serversteuerung'
      ImageIndex = 4
      object Label8: TLabel
        Left = 243
        Top = 61
        Width = 225
        Height = 13
        Caption = 'Server durch WAKE ON LAN aufwecken'
      end
      object Label9: TLabel
        Left = 90
        Top = 165
        Width = 210
        Height = 13
        Caption = 'Ping des Datenbank Server Dienstes'
      end
      object Label10: TLabel
        Left = 131
        Top = 108
        Width = 25
        Height = 13
        Caption = 'Host'
      end
      object Label11: TLabel
        Left = 53
        Top = 131
        Width = 103
        Height = 13
        Caption = 'SYSDBA Passwort'
      end
      object Label12: TLabel
        Left = 24
        Top = 24
        Width = 357
        Height = 13
        Caption = 'MAC Hardwareadresse des Netzwerkadapters des Zielsystems'
      end
      object Edit7: TEdit
        Left = 160
        Top = 104
        Width = 121
        Height = 21
        TabOrder = 0
        Text = 'localhost'
      end
      object Button14: TButton
        Left = 304
        Top = 160
        Width = 75
        Height = 25
        Caption = 'ausf'#252'hren'
        TabOrder = 1
        OnClick = Button14Click
      end
      object Button15: TButton
        Left = 472
        Top = 56
        Width = 75
        Height = 25
        Caption = 'ausf'#252'hren'
        TabOrder = 2
        OnClick = Button15Click
      end
      object Edit8: TEdit
        Left = 160
        Top = 128
        Width = 121
        Height = 21
        PasswordChar = '*'
        TabOrder = 3
        Text = 'masterkey'
      end
      object Edit9: TEdit
        Left = 392
        Top = 24
        Width = 129
        Height = 21
        TabOrder = 4
        Text = '00-02-2a-45-4e-ef'
      end
      object CheckBox7: TCheckBox
        Left = 480
        Top = 88
        Width = 161
        Height = 17
        Caption = 'alle 30 Sekunden'
        TabOrder = 5
        OnClick = CheckBox7Click
      end
      object CheckBox8: TCheckBox
        Left = 40
        Top = 224
        Width = 260
        Height = 17
        Caption = 'alle OrgaMon Timer stoppen '
        TabOrder = 6
        OnClick = CheckBox8Click
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Indizierung'
      ImageIndex = 5
      object Label18: TLabel
        Left = 16
        Top = 80
        Width = 9
        Height = 13
        Caption = '#'
      end
      object Button8: TButton
        Left = 16
        Top = 40
        Width = 169
        Height = 25
        Caption = 'Indizierung auffrischen'
        TabOrder = 0
        OnClick = Button8Click
      end
    end
  end
  object IB_ScriptDialog1: TIB_ScriptDialog
    Left = 8
  end
  object IB_BrowseDialog1: TIB_BrowseDialog
    BaseConnection = DataModuleHeBu.IB_Connection1
    BaseTransaction = DataModuleHeBu.IB_Transaction1
    Left = 40
  end
  object IB_Query1: TIB_Query
    DatabaseName = '192.168.115.90:sewa.fdb'
    IB_Connection = DataModuleHeBu.IB_Connection1
    ColorScheme = False
    MasterSearchFlags = [msfOpenMasterOnOpen, msfSearchAppliesToMasterOnly]
    BufferSynchroFlags = []
    FetchWholeRows = True
    Left = 72
  end
  object IB_Script1: TIB_Script
    IB_Connection = DataModuleHeBu.IB_Connection1
    Left = 104
  end
  object IB_Query2: TIB_Query
    DatabaseName = '192.168.115.90:sewa.fdb'
    IB_Connection = DataModuleHeBu.IB_Connection1
    SQL.Strings = (
      'SELECT'
      ' RDB$INDICES.RDB$RELATION_NAME,'
      ' RDB$INDICES.RDB$INDEX_NAME,'
      ' RDB$INDEX_SEGMENTS.RDB$FIELD_NAME'
      'FROM'
      ' RDB$INDICES'
      'JOIN'
      ' RDB$INDEX_SEGMENTS'
      'ON'
      ' RDB$INDICES.RDB$INDEX_NAME=RDB$INDEX_SEGMENTS.RDB$INDEX_NAME'
      'WHERE'
      ' (RDB$INDICES.RDB$SYSTEM_FLAG IS NULL) AND'
      ' (RDB$INDICES.RDB$INDEX_INACTIVE=1)'
      ' ')
    ColorScheme = False
    MasterSearchFlags = [msfOpenMasterOnOpen, msfSearchAppliesToMasterOnly]
    BufferSynchroFlags = []
    FetchWholeRows = True
    Left = 136
  end
  object IB_Metadata1: TIB_Metadata
    IB_Connection = DataModuleHeBu.IB_Connection1
    CodeOptions = []
    Left = 232
  end
  object SynSQLSyn1: TSynSQLSyn
    SQLDialect = sqlInterbase6
    Left = 360
  end
  object SynExporterHTML1: TSynExporterHTML
    Color = clWindow
    CreateHTMLFragment = True
    DefaultFilter = 'HTML Document (*.htm,*.html)|*.htm;*.html'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -10
    Font.Name = 'Courier New'
    Font.Style = []
    Highlighter = SynSQLSyn1
    Title = 'Untitled'
    UseBackground = False
    Left = 392
  end
  object IBServerProperties1: TIBServerProperties
    Protocol = TCP
    LoginPrompt = False
    TraceFlags = []
    Options = [Version]
    Left = 264
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = Timer1Timer
    Left = 424
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'CSV'
    Filter = 'Semikolon seperierte Textdatei (*.csv)|*.csv'
    Left = 800
    Top = 496
  end
end
