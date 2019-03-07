object FormAuftragMobil: TFormAuftragMobil
  Left = 572
  Top = 345
  Caption = 'Mobil synchronisieren'
  ClientHeight = 537
  ClientWidth = 466
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
  object Label3: TLabel
    Left = 8
    Top = 378
    Width = 9
    Height = 13
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = '#'
  end
  object SpeedButton2: TSpeedButton
    Left = 435
    Top = 349
    Width = 22
    Height = 22
    Hint = 'Diagnoseverzeichnis '#246'ffnen'
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
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
    OnClick = SpeedButton2Click
  end
  object Button1: TButton
    Left = 304
    Top = 378
    Width = 153
    Height = 41
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Empfangen && &Senden'
    TabOrder = 0
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 99
    Width = 449
    Height = 247
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object Label2: TLabel
      Left = 25
      Top = 25
      Width = 62
      Height = 13
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Monteur ...'
    end
    object Memo1: TMemo
      Left = 268
      Top = 43
      Width = 176
      Height = 86
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 0
    end
    object Button2: TButton
      Left = 185
      Top = 42
      Width = 75
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '>>'
      TabOrder = 1
      OnClick = Button2Click
    end
    object ComboBox1: TComboBox
      Left = 25
      Top = 43
      Width = 152
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 2
      Text = '<Monteur ausw'#228'hlen>'
    end
    object CheckBox1: TCheckBox
      Left = 25
      Top = 137
      Width = 410
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Daten auch ins Internet, damit werden sie f'#252'r Monteure abrufbar'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object Button3: TButton
      Left = 408
      Top = 25
      Width = 36
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'clear'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = Button3Click
    end
    object CheckBox2: TCheckBox
      Left = 25
      Top = 153
      Width = 169
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'auch als HTML ausgeben'
      TabOrder = 5
    end
    object CheckBox8: TCheckBox
      Left = 25
      Top = 170
      Width = 273
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Ger'#228'tevolumen, die "0" sind l'#246'schen!'
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
    object CheckBox9: TCheckBox
      Left = 25
      Top = 186
      Width = 217
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'abgearbeitete hochladen!'
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
    object CheckBox11: TCheckBox
      Left = 25
      Top = 203
      Width = 169
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Abgezogene hochladen!'
      Checked = True
      State = cbChecked
      TabOrder = 8
    end
    object CheckBox12: TCheckBox
      Left = 25
      Top = 220
      Width = 200
      Height = 17
      Caption = 'Baustelleninfos hochladen!'
      Checked = True
      State = cbChecked
      TabOrder = 9
    end
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 397
    Width = 282
    Height = 22
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Smooth = True
    TabOrder = 3
  end
  object CheckBox3: TCheckBox
    Left = 17
    Top = 100
    Width = 216
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'OrgaMon Daten -> Mobil - Server'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object GroupBox3: TGroupBox
    Left = 9
    Top = 426
    Width = 450
    Height = 104
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Diagnose'
    TabOrder = 5
    object Label1: TLabel
      Left = 17
      Top = 24
      Width = 32
      Height = 13
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Ger'#228't'
    end
    object Button4: TButton
      Left = 96
      Top = 40
      Width = 105
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Restat-Diagnose'
      TabOrder = 0
      OnClick = Button4Click
    end
    object ComboBox2: TComboBox
      Left = 17
      Top = 42
      Width = 72
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = csDropDownList
      TabOrder = 1
    end
    object Button5: TButton
      Left = 208
      Top = 40
      Width = 129
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Doppelte-Diagnose'
      TabOrder = 2
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 17
      Top = 68
      Width = 241
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Monteur-'#220'berblick'
      TabOrder = 3
      OnClick = Button6Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 449
    Height = 92
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 2
    object CheckBox4: TCheckBox
      Left = 8
      Top = 2
      Width = 217
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Mobile Ergebnisdaten -> OrgaMon'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object CheckBox6: TCheckBox
      Left = 41
      Top = 41
      Width = 297
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'TANs auf dem Server belassen'
      TabOrder = 1
    end
    object CheckBox5: TCheckBox
      Left = 25
      Top = 23
      Width = 313
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'TANs vom Server laden'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object CheckBox10: TCheckBox
      Left = 25
      Top = 60
      Width = 313
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'TANs ins Diagnose-Verzeichnis verschieben'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
  object CheckBox7: TCheckBox
    Left = 8
    Top = 355
    Width = 409
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'FTP-Upload in das Diagnose Verzeichnis (nur zu Testzwecken)'
    TabOrder = 6
  end
end
