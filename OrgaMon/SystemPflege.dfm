object FormSystemPflege: TFormSystemPflege
  Left = 217
  Top = 163
  Caption = 'Systempflege'
  ClientHeight = 516
  ClientWidth = 651
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 651
    Height = 516
    ActivePage = TabSheet3
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Inkonsistenter Index'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
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
        Left = 7
        Top = 24
        Width = 265
        Height = 13
        Caption = '2) Versuch alle Prim'#228'ren Indizes zu aktivieren'
      end
      object Label5: TLabel
        Left = 7
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
        Left = 7
        Top = 319
        Width = 172
        Height = 13
        Caption = '4) "Dupilcate Value" Diagnose'
      end
      object Label8: TLabel
        Left = 7
        Top = 373
        Width = 162
        Height = 13
        Caption = '5) GENERATOR '#220'berpr'#252'fung'
      end
      object Label9: TLabel
        Left = 150
        Top = 419
        Width = 18
        Height = 13
        Caption = 'auf'
      end
      object ListBox1: TListBox
        Left = 360
        Top = 48
        Width = 258
        Height = 81
        ItemHeight = 13
        TabOrder = 0
      end
      object Edit1: TEdit
        Left = 24
        Top = 184
        Width = 152
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
        Left = 45
        Top = 232
        Width = 131
        Height = 21
        TabOrder = 3
        Text = 'BELEG'
      end
      object Edit4: TEdit
        Left = 186
        Top = 231
        Width = 120
        Height = 21
        TabOrder = 4
        Text = 'RID'
      end
      object Button3: TButton
        Left = 7
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
        Height = 16
        Caption = 'auch '#196'nderungen vornehmen!'
        TabOrder = 6
      end
      object Button4: TButton
        Left = 7
        Top = 48
        Width = 114
        Height = 24
        Caption = 'auflisten und ...'
        TabOrder = 7
        OnClick = Button4Click
      end
      object CheckBox2: TCheckBox
        Left = 137
        Top = 40
        Width = 216
        Height = 18
        Caption = 'PRIMARY Keys aktivieren'
        TabOrder = 8
      end
      object CheckBox3: TCheckBox
        Left = 137
        Top = 56
        Width = 216
        Height = 16
        Caption = 'FOREIGN Keys aktivieren'
        TabOrder = 9
      end
      object CheckBox4: TCheckBox
        Left = 137
        Top = 72
        Width = 216
        Height = 17
        Caption = '"den Rest" aktivieren'
        TabOrder = 10
      end
      object ListBox2: TListBox
        Left = 360
        Top = 184
        Width = 258
        Height = 65
        ItemHeight = 13
        TabOrder = 11
      end
      object Button5: TButton
        Left = 472
        Top = 137
        Width = 146
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
        Left = 24
        Top = 339
        Width = 121
        Height = 21
        TabOrder = 14
        Text = 'ARTIKEL'
      end
      object Edit6: TEdit
        Left = 150
        Top = 339
        Width = 122
        Height = 21
        TabOrder = 15
        Text = 'NUMERO'
      end
      object Button13: TButton
        Left = 279
        Top = 337
        Width = 74
        Height = 25
        Caption = 'anzeigen'
        TabOrder = 16
        OnClick = Button13Click
      end
      object Edit7: TEdit
        Left = 24
        Top = 392
        Width = 121
        Height = 21
        TabOrder = 17
        Text = 'GATTUNG'
      end
      object Button10: TButton
        Left = 150
        Top = 392
        Width = 74
        Height = 22
        Caption = 'pr'#252'fen'
        TabOrder = 18
        OnClick = Button10Click
      end
      object Edit8: TEdit
        Left = 176
        Top = 416
        Width = 71
        Height = 21
        TabOrder = 19
        Text = 'Edit8'
      end
      object Button11: TButton
        Left = 254
        Top = 416
        Width = 77
        Height = 22
        Caption = 'setzen'
        TabOrder = 20
        OnClick = Button11Click
      end
      object Edit9: TEdit
        Left = 24
        Top = 416
        Width = 121
        Height = 21
        TabOrder = 21
        Text = 'Edit9'
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Datenbank'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object SynMemo1: TSynMemo
        Left = 0
        Top = 72
        Width = 643
        Height = 416
        Align = alBottom
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        TabOrder = 0
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Terminal'
        Gutter.Font.Style = []
        Highlighter = SynSQLSyn1
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
        Left = 0
        Top = 31
        Width = 217
        Height = 26
        Caption = 'Metadaten in die Diagnose'
        TabOrder = 1
        OnClick = Button12Click
      end
      object IB_UtilityBar1: TIB_UtilityBar
        Left = 0
        Top = 0
        Width = 643
        Height = 25
        CustomGlyphsSupplied = []
        Flat = False
        BaseConnection = DataModuleDatenbank.IB_Connection1
        BaseTransaction = DataModuleDatenbank.IB_Transaction_W
        VisibleButtons = [wbBrowse, wbDSQL, wbEvents, wbWho, wbScript, wbExtract, wbMonitor, wbProfiler, wbStatus, wbUsers]
        Align = alTop
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 2
      end
      object Button1: TButton
        Left = 407
        Top = 31
        Width = 178
        Height = 25
        Caption = 'W-Transaktions Commit'
        TabOrder = 3
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 223
        Top = 31
        Width = 178
        Height = 25
        Caption = 'R-Transaktions Commit'
        TabOrder = 4
        OnClick = Button2Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Stapel-Transaktionen'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
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
        Width = 266
        Height = 16
        Caption = 'Personen l'#246'schen'
        TabOrder = 0
      end
      object RadioButton2: TRadioButton
        Left = 40
        Top = 72
        Width = 337
        Height = 18
        Caption = 'Artikel l'#246'schen'
        TabOrder = 1
      end
      object RadioButton3: TRadioButton
        Left = 40
        Top = 91
        Width = 233
        Height = 17
        Caption = 'Belege l'#246'schen'
        TabOrder = 2
      end
      object Button6: TButton
        Left = 33
        Top = 257
        Width = 74
        Height = 25
        Caption = 'laden'
        TabOrder = 3
        OnClick = Button6Click
      end
      object ProgressBar1: TProgressBar
        Left = 16
        Top = 433
        Width = 519
        Height = 16
        TabOrder = 4
      end
      object Button7: TButton
        Left = 542
        Top = 429
        Width = 76
        Height = 25
        Caption = 'Ausf'#252'hren'
        TabOrder = 5
        OnClick = Button7Click
      end
      object RadioButton4: TRadioButton
        Left = 40
        Top = 127
        Width = 305
        Height = 17
        Caption = 'Order l'#246'schen'
        TabOrder = 6
      end
      object ListBox3: TListBox
        Left = 16
        Top = 306
        Width = 602
        Height = 104
        ItemHeight = 13
        TabOrder = 7
      end
      object RadioButton5: TRadioButton
        Left = 40
        Top = 110
        Width = 273
        Height = 16
        Caption = 'Belege ausgleichen'
        TabOrder = 8
      end
      object RadioButton6: TRadioButton
        Left = 40
        Top = 144
        Width = 147
        Height = 17
        Caption = 'Freie Transaktion'
        TabOrder = 9
      end
      object Edit12: TEdit
        Left = 200
        Top = 142
        Width = 33
        Height = 21
        TabOrder = 10
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Anzeige'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label10: TLabel
        Left = 16
        Top = 23
        Width = 69
        Height = 13
        Caption = 'Farbrechner'
      end
      object Label11: TLabel
        Left = 16
        Top = 48
        Width = 92
        Height = 13
        Caption = 'HTML-Farbcode:'
      end
      object Label12: TLabel
        Left = 16
        Top = 88
        Width = 78
        Height = 13
        Caption = 'PAPERCOLOR'
      end
      object Edit10: TEdit
        Left = 136
        Top = 48
        Width = 121
        Height = 21
        Hint = 
          'Geben Sie den Code ein (z.B. FF33FF) und dr'#252'cken Sie ENTER, der ' +
          'Farbcode wird dann in die Zwischenablage kopiert'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = 'Edit10'
        TextHint = 
          'Geben Sie den Code ein (z.B. FF33FF) und dr'#252'cken Sie ENTER, der ' +
          'Farbcode wird dann in die Zwischenablage kopiert'
        OnKeyPress = Edit10KeyPress
      end
      object StaticText1: TStaticText
        Left = 136
        Top = 88
        Width = 121
        Height = 25
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = 'StaticText1'
        TabOrder = 1
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Serversteuerung'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox3: TGroupBox
        Left = 13
        Top = 7
        Width = 618
        Height = 104
        Caption = 'Applikations Timer'
        TabOrder = 0
        object CheckBox8: TCheckBox
          Left = 55
          Top = 24
          Width = 194
          Height = 17
          Alignment = taLeftJustify
          Caption = 'alle OrgaMon Timer stoppen '
          TabOrder = 0
          OnClick = CheckBox8Click
        end
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Indizierung'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label18: TLabel
        Left = 16
        Top = 80
        Width = 9
        Height = 13
        Caption = '#'
      end
      object Label19: TLabel
        Left = 16
        Top = 16
        Width = 136
        Height = 13
        Caption = 'Anwendungsverzeichnis'
      end
      object SpeedButton1: TSpeedButton
        Left = 176
        Top = 9
        Width = 25
        Height = 24
        Hint = 'Verzeichnis des aktuellen Benutzers '#246'ffnen'
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000
          0000000000000000000000000000000000000000000000000000FFFFFFFFFFFF
          009E9C009E9C009E9C009E9C009E9C009E9C009E9C009E9C009E9C009E9C009E
          9C009E9C000000000000FFFFFFFFFFFF009E9CFFFFFF9CCFFF9CFFFF9CCFFF9C
          FFFF9CCFFF9CCFFF9CCFFF9CCFFF63CFCE009E9C000000000000FFFFFF009E9C
          FFFFFF9CFFFF9CFFFF9CCFFF9CFFFF9CCFFF9CFFFF9CCFFF9CCFFF9CCFFF63CF
          CE000000009E9C000000FFFFFF009E9CFFFFFF9CFFFF9CFFFF9CFFFF9CFFFF9C
          FFFF9CCFFF9CFFFF9CCFFF9CCFFF009E9C000000009E9C000000009E9CFFFFFF
          9CFFFF9CFFFF9CFFFF9CFFFF9CCFFF9CFFFF9CFFFF9CCFFF9CFFFF63CFCE0000
          0063CFCE63CFCE000000009E9CFFFFFF9CFFFF9CFFFF9CFFFF9CFFFF9CFFFF9C
          FFFF9CCFFF9CFFFF9CCFFF63CFCE00000063CFCE63CFCE000000009E9C009E9C
          009E9C009E9C009E9C009E9C009E9C009E9C009E9C009E9C009E9C009E9C63CF
          CE9CFFFF63CFCE000000FFFFFF009E9CFFFFFF9CFFFF9CFFFF9CFFFF9CFFFF9C
          FFFF9CFFFF9CFFFF9CFFFF9CFFFF9CFFFF9CFFFF63CFCE000000FFFFFF009E9C
          FFFFFF9CFFFF9CFFFF9CFFFF9CFFFF9CFFFF9CFFFF9CFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF63CFCE000000FFFFFF009E9CFFFFFF9CFFFF9CFFFF9CFFFF9CFFFF9C
          FFFFFFFFFF009E9C009E9C009E9C009E9C009E9C009E9CFFFFFFFFFFFFFFFFFF
          009E9CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF009E9CFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF009E9C009E9C009E9C009E9C00
          9E9CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
        OnClick = SpeedButton1Click
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
    object TabSheet7: TTabSheet
      Caption = '&Versionsinfo'
      ImageIndex = 6
      OnShow = TabSheet7Show
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 643
        Height = 488
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 0
        WordWrap = False
      end
    end
    object TabSheet8: TTabSheet
      Caption = 'Performance Test'
      ImageIndex = 7
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label20: TLabel
        Left = 32
        Top = 4
        Width = 113
        Height = 13
        Caption = '1) Testvorbereitung'
      end
      object Label21: TLabel
        Left = 32
        Top = 82
        Width = 129
        Height = 13
        Caption = '2) Datenbank Lesetest'
      end
      object Label22: TLabel
        Left = 133
        Top = 100
        Width = 15
        Height = 22
        Caption = '#'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object Memo2: TMemo
        Left = 48
        Top = 132
        Width = 577
        Height = 350
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object Edit11: TEdit
        Left = 48
        Top = 23
        Width = 577
        Height = 21
        TabOrder = 1
        Text = '*.jpg'
      end
      object Button9: TButton
        Left = 48
        Top = 50
        Width = 129
        Height = 25
        Caption = 'schreiben in DB'
        TabOrder = 2
        OnClick = Button9Click
      end
      object Button14: TButton
        Left = 48
        Top = 101
        Width = 75
        Height = 25
        Caption = 'lesen'
        TabOrder = 3
        OnClick = Button14Click
      end
    end
    object TabSheet9: TTabSheet
      Caption = 'Hardware'
      ImageIndex = 8
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Button15: TButton
        Left = 24
        Top = 40
        Width = 201
        Height = 25
        Caption = #214'ffnen der Kassenschublade'
        TabOrder = 0
        OnClick = Button15Click
      end
    end
  end
  object IB_Query1: TIB_Query
    DatabaseName = '192.168.115.25:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    Left = 56
    Top = 456
  end
  object IB_Query2: TIB_Query
    DatabaseName = '192.168.115.25:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
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
      ' (RDB$INDICES.RDB$SYSTEM_FLAG=0) AND'
      ' (RDB$INDICES.RDB$INDEX_INACTIVE=1)')
    Left = 184
    Top = 464
  end
  object IB_Metadata1: TIB_Metadata
    IB_Connection = DataModuleDatenbank.IB_Connection1
    CodeOptions = []
    Left = 304
    Top = 448
  end
  object SynSQLSyn1: TSynSQLSyn
    SQLDialect = sqlInterbase6
    Left = 352
    Top = 448
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
    Left = 400
    Top = 448
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 30000
    Left = 464
    Top = 456
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'CSV'
    Filter = 'Semikolon seperierte Textdatei (*.csv)|*.csv'
    Left = 528
    Top = 456
  end
  object IB_Script1: TIB_Script
    IB_Connection = DataModuleDatenbank.IB_Connection1
    Left = 128
    Top = 456
  end
end
