object FormWebShopConnector: TFormWebShopConnector
  Left = 118
  Top = 111
  Caption = 'eAPI'
  ClientHeight = 535
  ClientWidth = 696
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
  object Label7: TLabel
    Left = 8
    Top = 280
    Width = 9
    Height = 13
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = '#'
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 696
    Height = 274
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = TabSheet2
    Align = alTop
    TabOrder = 0
    object TabSheet1: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'XMLRPC - Server'
      object Label1: TLabel
        Left = 439
        Top = 123
        Width = 48
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '# gef'#252'llt'
      end
      object Label2: TLabel
        Left = 12
        Top = 200
        Width = 69
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Benutzer ID'
      end
      object Label3: TLabel
        Left = 12
        Top = 189
        Width = 65
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Suche '#252'ber'
      end
      object StaticText1: TStaticText
        Left = 216
        Top = 8
        Width = 217
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = 'keine Clicks seit Programmstart'
        TabOrder = 0
      end
      object CheckBox2: TCheckBox
        Left = 12
        Top = 166
        Width = 185
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Log Webshop Calls'
        TabOrder = 1
      end
      object Button1: TButton
        Left = 216
        Top = 118
        Width = 217
        Height = 25
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Leere Passworte f'#252'llen'
        TabOrder = 2
        OnClick = Button1Click
      end
      object Edit1: TEdit
        Left = 87
        Top = 192
        Width = 555
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 3
        Text = 'name@domain'
        OnKeyPress = Edit1KeyPress
      end
      object Button4: TButton
        Left = 648
        Top = 190
        Width = 25
        Height = 25
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '&P'
        TabOrder = 4
        OnClick = Button4Click
      end
      object Button12: TButton
        Left = 17
        Top = 56
        Width = 88
        Height = 27
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Start'
        TabOrder = 5
        OnClick = Button12Click
      end
      object Button13: TButton
        Left = 17
        Top = 85
        Width = 88
        Height = 25
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Stop'
        TabOrder = 6
        OnClick = Button13Click
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'XMLRPC - Funktionen'
      ImageIndex = 4
      OnShow = TabSheet5Show
      object Label13: TLabel
        Left = 3
        Top = 80
        Width = 48
        Height = 13
        Caption = 'Funktion'
      end
      object Label14: TLabel
        Left = 191
        Top = 80
        Width = 80
        Height = 13
        Caption = 'Parameter #1'
      end
      object Label15: TLabel
        Left = 318
        Top = 80
        Width = 80
        Height = 13
        Caption = 'Parameter #2'
      end
      object Label16: TLabel
        Left = 445
        Top = 80
        Width = 80
        Height = 13
        Caption = 'Parameter #3'
      end
      object ComboBox1: TComboBox
        Left = 3
        Top = 99
        Width = 182
        Height = 21
        TabOrder = 0
        Text = 'Versandkosten'
      end
      object Edit4: TEdit
        Left = 191
        Top = 99
        Width = 121
        Height = 21
        TabOrder = 1
        Text = '1032'
      end
      object Edit5: TEdit
        Left = 318
        Top = 99
        Width = 121
        Height = 21
        TabOrder = 2
      end
      object Edit6: TEdit
        Left = 445
        Top = 99
        Width = 121
        Height = 21
        TabOrder = 3
      end
      object Button3: TButton
        Left = 572
        Top = 97
        Width = 75
        Height = 25
        Caption = 'Ausf'#252'hren!'
        TabOrder = 4
        OnClick = Button3Click
      end
    end
    object TabSheet2: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'WebShop - Medien'
      ImageIndex = 1
      object Label4: TLabel
        Left = 8
        Top = 69
        Width = 119
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Lokaler Dateiumfang'
      end
      object Label5: TLabel
        Left = 8
        Top = 91
        Width = 121
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Remote Dateiumfang'
      end
      object Label6: TLabel
        Left = 8
        Top = 114
        Width = 91
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'heutige Uploads'
      end
      object Label8: TLabel
        Left = 392
        Top = 69
        Width = 31
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'bytes'
      end
      object Label9: TLabel
        Left = 391
        Top = 91
        Width = 31
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'bytes'
      end
      object Label10: TLabel
        Left = 392
        Top = 114
        Width = 31
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'bytes'
      end
      object Label11: TLabel
        Left = 8
        Top = 134
        Width = 137
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'heutige Link'#228'nderungen'
      end
      object Label12: TLabel
        Left = 8
        Top = 159
        Width = 150
        Height = 13
        Caption = 'heutige Verbindungsfehler'
      end
      object Button5: TButton
        Left = 508
        Top = 202
        Width = 177
        Height = 41
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'hochladen && verlinken'
        TabOrder = 0
        OnClick = Button5Click
      end
      object CheckBox3: TCheckBox
        Left = 8
        Top = 17
        Width = 96
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'FTP "Upload"'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object StaticText2: TStaticText
        Left = 232
        Top = 64
        Width = 153
        Height = 18
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '#'
        TabOrder = 2
      end
      object StaticText3: TStaticText
        Left = 232
        Top = 87
        Width = 153
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '#'
        TabOrder = 3
      end
      object StaticText4: TStaticText
        Left = 232
        Top = 110
        Width = 153
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '#'
        TabOrder = 4
      end
      object StaticText5: TStaticText
        Left = 169
        Top = 64
        Width = 57
        Height = 18
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '#'
        TabOrder = 5
      end
      object StaticText6: TStaticText
        Left = 169
        Top = 87
        Width = 57
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '#'
        TabOrder = 6
      end
      object StaticText7: TStaticText
        Left = 169
        Top = 110
        Width = 57
        Height = 17
        Hint = 'Automatischer Abbruch bei 100'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '#'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
      end
      object StaticText8: TStaticText
        Left = 169
        Top = 134
        Width = 57
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '#'
        TabOrder = 8
      end
      object CheckBox10: TCheckBox
        Left = 8
        Top = 32
        Width = 96
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'FTP "Delete"'
        Checked = True
        State = cbChecked
        TabOrder = 9
      end
      object Edit2: TEdit
        Left = 169
        Top = 14
        Width = 57
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 10
        Text = 'RID'
        OnKeyPress = Edit2KeyPress
      end
      object Edit3: TEdit
        Left = 232
        Top = 14
        Width = 441
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 11
        Text = 'ShopHost + ShopLink'
      end
      object Button14: TButton
        Left = 508
        Top = 163
        Width = 178
        Height = 24
        Caption = 'FTP - Test'
        TabOrder = 12
        OnClick = Button14Click
      end
      object StaticText9: TStaticText
        Left = 169
        Top = 157
        Width = 57
        Height = 16
        Hint = 'Automatischer Abbruch bei 10'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '#'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 13
      end
      object CheckBox1: TCheckBox
        Left = 8
        Top = 192
        Width = 407
        Height = 17
        Caption = 'beenden nach 100 Uploads'
        Checked = True
        State = cbChecked
        TabOrder = 14
      end
      object CheckBox5: TCheckBox
        Left = 8
        Top = 207
        Width = 425
        Height = 17
        Caption = 'beenden nach 10 Verbindungsproblemen'
        Checked = True
        State = cbChecked
        TabOrder = 15
      end
    end
    object TabSheet3: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'WebShop - MySQL'
      ImageIndex = 2
      object Button6: TButton
        Left = 498
        Top = 192
        Width = 186
        Height = 42
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Dump hochladen'
        TabOrder = 0
        OnClick = Button6Click
      end
      object CheckBox6: TCheckBox
        Left = 80
        Top = 49
        Width = 193
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'LAUFNUMMER setzen'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object CheckBox7: TCheckBox
        Left = 80
        Top = 85
        Width = 217
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'FTP Upload'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object CheckBox8: TCheckBox
        Left = 80
        Top = 103
        Width = 217
        Height = 18
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'DB Switch durchf'#252'hren'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object CheckBox9: TCheckBox
        Left = 80
        Top = 67
        Width = 185
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'MySQL Dump erzeugen'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
      object Button7: TButton
        Left = 24
        Top = 49
        Width = 52
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Einzeltest'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = Button7Click
      end
      object Button8: TButton
        Left = 24
        Top = 67
        Width = 52
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Einzeltest'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        OnClick = Button8Click
      end
      object Button9: TButton
        Left = 24
        Top = 85
        Width = 52
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Einzeltest'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        OnClick = Button9Click
      end
      object Button10: TButton
        Left = 24
        Top = 103
        Width = 52
        Height = 18
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Einzeltest'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        OnClick = Button10Click
      end
    end
    object TabSheet4: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'REST'
      ImageIndex = 3
      object Button11: TButton
        Left = 17
        Top = 39
        Width = 160
        Height = 25
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'REST'
        TabOrder = 0
        OnClick = Button11Click
      end
      object CheckBox4: TCheckBox
        Left = 17
        Top = 17
        Width = 176
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'in bin Server'
        TabOrder = 1
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'memcache'
      ImageIndex = 5
      object Label17: TLabel
        Left = 61
        Top = 24
        Width = 53
        Height = 13
        Caption = 'Host:Port'
      end
      object Label18: TLabel
        Left = 92
        Top = 84
        Width = 22
        Height = 13
        Caption = 'Key'
      end
      object Label19: TLabel
        Left = 82
        Top = 111
        Width = 32
        Height = 13
        Caption = 'Value'
      end
      object SpeedButton1: TSpeedButton
        Left = 422
        Top = 20
        Width = 23
        Height = 22
        Hint = 'Wert aus den Einstellungen '#252'bernehmen'
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC4ADADD0
          BEBE9691917A7A7A9959347A73709A9A9AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFDDCDCDD1BEBEFDFCFCA07E7EEFE1E1848383F1DCCFA84305C6723A7E7D
          7DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4D6D6A57B7B926060916767AE7A7AF4
          E7E7928E8DB6652EA94403B24C01AF6D3AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          C0A1A1DCC2C2DBBDBDD2A7A7E7C2C2F2E5E5B0744AAB4600B96E3BBB6521C05C
          04F1C8A7FFFFFFFFFFFFFFFFFFFFFFFFEEE7E7A97D7DE8D1D1E3C9C9E2C8C8F4
          E8E8B56630B27238C6C4C4BE9674C3610ACA6601E3A04FFFFFFFFFFFFFCCB1B1
          A87676A47474E9D1D1E4CCCCE7D0D0F1E5E5EBCBB9F4E8E5F3E8E8F2E4E4DB9A
          65D16A01DC7903FFFFFFFFFFFFB28888EDD3D3E6D1D1E3CACAECD7D7C29D9DE5
          CDCDF5E2E2E1B6B6DFC2C2E6CFCFF6EDEDE49649D97401FFFFFFFFFFFFAE8282
          EDDEDEF0E2E2E5CCCCF1E0E0AC8181FFFFFFFFFFFFE4C3C3E1C4C4E1C7C7DABE
          BEDFD2D2DC811FFFFFFFFFFFFFE8DBDBC2A0A0D2B4B4E6CDCDF3E5E5A37979B2
          8E8EC8AAAAC59D9DE5CCCCE1C7C7CAA5A5C6B0B0E5DBDBFFFFFFFFFFFFFFFFFF
          D4B3B3DCBFBFEAD6D6ECD9D9F1E2E2DABBBBE6C8C8EBD7D7E4CACAE2C6C6E7CA
          CAC19797C8B3B3FFFFFFFFFFFFFFFFFFD1A8A8FDFBFBF7F1F1E9D3D3E6CECEEF
          DEDEECD9D9E4CACAE3C6C6C19D9DBE9898A67A7AF1ECECFFFFFFFFFFFFFFFFFF
          E5C7C7CEA8A8D2A9A9CFAAAAF2E6E6E8D0D0E6CECEE9D4D4DCC1C1C4A5A5EADE
          DEE9DBDBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFCFCFFFFFFDAB2B2FBF6F6C9
          A4A4C9A3A3CAA6A6E0C7C7CBAAAAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFE6CBCBCAA2A2E4CCCCFFFFFFDBC1C1C7A7A7F5F1F1FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        OnClick = SpeedButton1Click
      end
      object Edit7: TEdit
        Left = 120
        Top = 21
        Width = 297
        Height = 21
        TabOrder = 0
        Text = 'raib23:11211'
      end
      object Button15: TButton
        Left = 453
        Top = 19
        Width = 75
        Height = 25
        Caption = 'open'
        TabOrder = 1
        OnClick = Button15Click
      end
      object Edit8: TEdit
        Left = 120
        Top = 81
        Width = 297
        Height = 21
        TabOrder = 2
        Text = 'sequence.69VVTGKZ1'
      end
      object Button16: TButton
        Left = 453
        Top = 79
        Width = 75
        Height = 25
        Caption = 'read'
        Enabled = False
        TabOrder = 3
        OnClick = Button16Click
      end
      object Button17: TButton
        Left = 453
        Top = 110
        Width = 75
        Height = 25
        Caption = 'write'
        Enabled = False
        TabOrder = 4
        OnClick = Button17Click
      end
      object Button18: TButton
        Left = 453
        Top = 141
        Width = 75
        Height = 25
        Caption = 'inc'
        Enabled = False
        TabOrder = 5
        OnClick = Button18Click
      end
      object Edit9: TEdit
        Left = 120
        Top = 108
        Width = 297
        Height = 21
        TabOrder = 6
      end
      object Button19: TButton
        Left = 453
        Top = 172
        Width = 75
        Height = 25
        Caption = 'delete'
        Enabled = False
        TabOrder = 7
        OnClick = Button19Click
      end
      object Button20: TButton
        Left = 453
        Top = 203
        Width = 75
        Height = 25
        Caption = 'exists'
        Enabled = False
        TabOrder = 8
        OnClick = Button20Click
      end
      object Button21: TButton
        Left = 534
        Top = 172
        Width = 75
        Height = 25
        Caption = 'delete all'
        Enabled = False
        TabOrder = 9
        OnClick = Button21Click
      end
    end
  end
  object ProgressBar2: TProgressBar
    Left = 8
    Top = 511
    Width = 680
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 1
  end
  object CheckBoxAbbruch: TCheckBox
    Left = 607
    Top = 487
    Width = 81
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taLeftJustify
    Caption = 'Abbruch'
    TabOrder = 2
  end
  object ListBoxLog: TListBox
    Left = 0
    Top = 299
    Width = 696
    Height = 182
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ItemHeight = 13
    TabOrder = 3
  end
  object Button2: TButton
    Left = 613
    Top = 280
    Width = 75
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Clear Log'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Panel1: TPanel
    Left = 8
    Top = 497
    Width = 14
    Height = 6
    BevelEdges = []
    BevelOuter = bvNone
    Color = clRed
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 5
  end
  object Timer1: TTimer
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 616
    Top = 40
  end
end
