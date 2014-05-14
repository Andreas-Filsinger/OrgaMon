object FormGUI: TFormGUI
  Left = 49
  Top = 106
  Caption = 'FormGUI'
  ClientHeight = 548
  ClientWidth = 686
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label28: TLabel
    Left = 9
    Top = 7
    Width = 7
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '0'
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 61
    Width = 686
    Height = 487
    ActivePage = TabSheet6
    Align = alBottom
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Info'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 144
        Top = 40
        Width = 35
        Height = 13
        Caption = '99999'
      end
      object Label2: TLabel
        Left = 72
        Top = 7
        Width = 37
        Height = 13
        Caption = 'Label2'
      end
      object Label3: TLabel
        Left = 21
        Top = 280
        Width = 48
        Height = 13
        Caption = 'Test-Trn'
      end
      object Label21: TLabel
        Left = 6
        Top = 66
        Width = 121
        Height = 13
        Caption = 'Verarbeitungs-Quelle'
      end
      object paStatus: TLabel
        Left = 144
        Top = 26
        Width = 50
        Height = 13
        Caption = 'paStatus'
      end
      object Label25: TLabel
        Left = 513
        Top = 0
        Width = 165
        Height = 69
        Caption = '00000'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -49
        Font.Name = 'Arial Black'
        Font.Style = []
        ParentFont = False
      end
      object Label27: TLabel
        Left = 132
        Top = 279
        Width = 8
        Height = 13
        Caption = '..'
      end
      object Memo1: TMemo
        Left = 2
        Top = 88
        Width = 671
        Height = 137
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 7
        Top = 7
        Width = 51
        Height = 18
        BevelOuter = bvNone
        BorderWidth = 1
        BorderStyle = bsSingle
        Caption = 'Panel1'
        Color = clTeal
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 1
      end
      object Edit1: TEdit
        Left = 72
        Top = 276
        Width = 51
        Height = 21
        TabOrder = 2
        Text = '80652'
      end
      object Button2: TButton
        Left = 230
        Top = 231
        Width = 106
        Height = 68
        Caption = 'verarbeiten'
        TabOrder = 3
        OnClick = Button2Click
      end
      object CheckBox1: TCheckBox
        Left = 368
        Top = 40
        Width = 97
        Height = 18
        Caption = 'Update'
        TabOrder = 4
      end
      object Edit14: TEdit
        Left = 128
        Top = 61
        Width = 169
        Height = 21
        TabOrder = 5
        Text = 'W:\JonDaServer\'
      end
      object Button9: TButton
        Left = 478
        Top = 330
        Width = 179
        Height = 26
        Caption = 'JonDa-Export'
        TabOrder = 6
        OnClick = Button9Click
      end
      object Button12: TButton
        Left = 478
        Top = 262
        Width = 179
        Height = 18
        Caption = 'OrgaMon-Mittelung machen'
        TabOrder = 7
        OnClick = Button12Click
      end
      object Button14: TButton
        Left = 527
        Top = 421
        Width = 130
        Height = 25
        Caption = 'CareTaker Hallo'
        TabOrder = 8
        OnClick = Button14Click
      end
      object CheckBox17: TCheckBox
        Left = 24
        Top = 231
        Width = 169
        Height = 16
        Caption = 'mit Ergebnis TAN Upload'
        TabOrder = 9
      end
      object CheckBox19: TCheckBox
        Left = 16
        Top = 324
        Width = 137
        Height = 18
        Caption = 'FTW Meldungen'
        Checked = True
        State = cbChecked
        TabOrder = 10
      end
      object Button16: TButton
        Left = 303
        Top = 313
        Width = 106
        Height = 25
        Caption = 'Melden!'
        TabOrder = 11
        OnClick = Button16Click
      end
      object Edit20: TEdit
        Left = 151
        Top = 276
        Width = 73
        Height = 21
        TabOrder = 12
      end
      object Button1: TButton
        Left = 305
        Top = 343
        Width = 104
        Height = 26
        Caption = 'Statistik!'
        TabOrder = 13
        OnClick = Button1Click
      end
      object CheckBox22: TCheckBox
        Left = 24
        Top = 248
        Width = 185
        Height = 17
        Caption = 'Daten aus access_log'
        TabOrder = 14
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Einstellungen'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label12: TLabel
        Left = 0
        Top = 24
        Width = 233
        Height = 14
        Caption = 'geplante Aktionen f'#252'r den n'#228'chsten Anruf'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object Label11: TLabel
        Left = 9
        Top = 75
        Width = 32
        Height = 13
        Caption = 'Ger'#228't'
      end
      object Label10: TLabel
        Left = 4
        Top = 100
        Width = 36
        Height = 13
        Caption = 'Aktion'
      end
      object Label14: TLabel
        Left = 15
        Top = 124
        Width = 23
        Height = 13
        Caption = 'TAN'
      end
      object SpeedButton2: TSpeedButton
        Left = 355
        Top = 263
        Width = 24
        Height = 25
        Hint = 'Optionsverzeichnis '#246'ffnen'
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
      object ListBox1: TListBox
        Left = 241
        Top = 72
        Width = 312
        Height = 121
        ItemHeight = 13
        TabOrder = 0
      end
      object Edit4: TEdit
        Left = 42
        Top = 72
        Width = 33
        Height = 21
        TabOrder = 1
        Text = '003'
      end
      object Button7: TButton
        Left = 160
        Top = 168
        Width = 75
        Height = 25
        Caption = '-->'
        TabOrder = 2
        OnClick = Button7Click
      end
      object ComboBox2: TComboBox
        Left = 42
        Top = 97
        Width = 177
        Height = 21
        Style = csDropDownList
        TabOrder = 3
        Items.Strings = (
          'Restaten ignorieren'
          'Bestand leeren <ohne Funktion>'
          'Restaten aus'
          '...')
      end
      object Edit7: TEdit
        Left = 42
        Top = 120
        Width = 121
        Height = 21
        TabOrder = 4
      end
      object Button3: TButton
        Left = 280
        Top = 232
        Width = 99
        Height = 25
        Caption = 'Einstellungen'
        TabOrder = 5
        OnClick = Button3Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Recherche'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label4: TLabel
        Left = 16
        Top = 24
        Width = 25
        Height = 13
        Caption = 'Pfad'
      end
      object Label5: TLabel
        Left = 409
        Top = 67
        Width = 22
        Height = 13
        Caption = 'RID'
      end
      object Label6: TLabel
        Left = 134
        Top = 132
        Width = 23
        Height = 13
        Caption = 'TRN'
      end
      object Label7: TLabel
        Left = 97
        Top = 280
        Width = 44
        Height = 13
        Caption = 'Umfang'
      end
      object Label9: TLabel
        Left = 104
        Top = 160
        Width = 44
        Height = 13
        Caption = 'Dateien'
      end
      object Label13: TLabel
        Left = 319
        Top = 131
        Width = 111
        Height = 13
        Caption = 'Z'#228'hlernummer Neu'
      end
      object Label8: TLabel
        Left = 326
        Top = 155
        Width = 104
        Height = 13
        Caption = 'Z'#228'hlernummer Alt'
      end
      object Label15: TLabel
        Left = 334
        Top = 187
        Width = 93
        Height = 13
        Caption = 'Monteurs-K'#252'rzel'
      end
      object Label16: TLabel
        Left = 375
        Top = 219
        Width = 55
        Height = 13
        Caption = 'Datum ist'
      end
      object Label17: TLabel
        Left = 380
        Top = 283
        Width = 50
        Height = 13
        Caption = 'Protokoll'
      end
      object Label18: TLabel
        Left = 365
        Top = 98
        Width = 65
        Height = 13
        Caption = 'ABNummer'
      end
      object Label19: TLabel
        Left = 387
        Top = 315
        Width = 43
        Height = 13
        Caption = 'Strasse'
      end
      object Label20: TLabel
        Left = 370
        Top = 251
        Width = 61
        Height = 13
        Caption = 'Datum soll'
      end
      object Label22: TLabel
        Left = 378
        Top = 347
        Width = 52
        Height = 13
        Caption = 'Baustelle'
      end
      object Edit2: TEdit
        Left = 72
        Top = 24
        Width = 473
        Height = 21
        TabOrder = 0
        Text = 'W:\JonDaServer\'
        OnExit = Edit2Exit
      end
      object Edit3: TEdit
        Left = 432
        Top = 64
        Width = 121
        Height = 21
        TabOrder = 1
        Text = '*'
      end
      object Button6: TButton
        Left = 464
        Top = 392
        Width = 76
        Height = 25
        Caption = 'Auswerten'
        TabOrder = 2
        OnClick = Button6Click
      end
      object CheckBox5: TCheckBox
        Left = 160
        Top = 152
        Width = 97
        Height = 17
        Caption = '<Ger'#228't>.DAT'
        TabOrder = 3
      end
      object CheckBox6: TCheckBox
        Left = 160
        Top = 168
        Width = 97
        Height = 17
        Caption = 'MONDA.DAT'
        TabOrder = 4
      end
      object CheckBox7: TCheckBox
        Left = 160
        Top = 184
        Width = 97
        Height = 18
        Caption = 'AUFTRAG.DAT'
        Checked = True
        State = cbChecked
        TabOrder = 5
      end
      object CheckBox8: TCheckBox
        Left = 160
        Top = 201
        Width = 97
        Height = 16
        Caption = '<TRN>.DAT'
        Checked = True
        State = cbChecked
        TabOrder = 6
      end
      object ComboBox1: TComboBox
        Left = 160
        Top = 128
        Width = 120
        Height = 21
        TabOrder = 7
        Text = '?????'
        Items.Strings = (
          '1????'
          '10564')
      end
      object CheckBox9: TCheckBox
        Left = 160
        Top = 296
        Width = 120
        Height = 17
        Caption = 'Details'
        Checked = True
        State = cbChecked
        TabOrder = 8
      end
      object CheckBox10: TCheckBox
        Left = 160
        Top = 280
        Width = 120
        Height = 17
        Caption = 'RID ausgeben'
        TabOrder = 9
      end
      object Edit5: TEdit
        Left = 432
        Top = 128
        Width = 121
        Height = 21
        TabOrder = 10
        Text = '*'
      end
      object Edit6: TEdit
        Left = 432
        Top = 152
        Width = 121
        Height = 21
        TabOrder = 11
        Text = '*'
      end
      object Button8: TButton
        Left = 370
        Top = 392
        Width = 74
        Height = 25
        Caption = 'Restaten'
        TabOrder = 12
        OnClick = Button8Click
      end
      object CheckBox11: TCheckBox
        Left = 160
        Top = 215
        Width = 97
        Height = 18
        Caption = 'STAY.DAT'
        TabOrder = 13
      end
      object Edit8: TEdit
        Left = 432
        Top = 184
        Width = 121
        Height = 21
        TabOrder = 14
        Text = '*'
      end
      object Edit9: TEdit
        Left = 432
        Top = 215
        Width = 121
        Height = 21
        TabOrder = 15
        Text = '*'
      end
      object Edit10: TEdit
        Left = 432
        Top = 280
        Width = 121
        Height = 21
        TabOrder = 16
        Text = '*'
      end
      object Edit12: TEdit
        Left = 432
        Top = 97
        Width = 121
        Height = 21
        TabOrder = 17
        Text = '*'
      end
      object Edit11: TEdit
        Left = 432
        Top = 312
        Width = 121
        Height = 21
        TabOrder = 18
        Text = '*'
      end
      object Edit13: TEdit
        Left = 432
        Top = 248
        Width = 121
        Height = 21
        TabOrder = 19
        Text = '*'
      end
      object Edit15: TEdit
        Left = 432
        Top = 345
        Width = 121
        Height = 21
        TabOrder = 20
        Text = '*'
      end
      object CheckBox12: TCheckBox
        Left = 160
        Top = 104
        Width = 97
        Height = 17
        Caption = 'aktuelle'
        TabOrder = 21
      end
      object Button13: TButton
        Left = 256
        Top = 392
        Width = 76
        Height = 25
        Caption = 'STOP'
        TabOrder = 22
        OnClick = Button13Click
      end
      object CheckBox16: TCheckBox
        Left = 160
        Top = 232
        Width = 97
        Height = 17
        Caption = 'LOST.DAT'
        TabOrder = 23
      end
      object Button4: TButton
        Left = 560
        Top = 24
        Width = 97
        Height = 25
        Caption = 'Log einsehen'
        TabOrder = 24
        OnClick = Button4Click
      end
      object Button20: TButton
        Left = 16
        Top = 424
        Width = 225
        Height = 25
        Caption = '+TS.BLA Infos'
        TabOrder = 25
        OnClick = Button20Click
      end
      object CheckBox20: TCheckBox
        Left = 16
        Top = 401
        Width = 97
        Height = 17
        Caption = '.fresh'
        TabOrder = 26
      end
      object CheckBox15: TCheckBox
        Left = 16
        Top = 384
        Width = 97
        Height = 17
        Caption = '- Kopie'
        TabOrder = 27
      end
      object CheckBox21: TCheckBox
        Left = 160
        Top = 247
        Width = 97
        Height = 17
        Caption = '<TRN>.TXT'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 28
      end
      object CheckBox18: TCheckBox
        Left = 160
        Top = 313
        Width = 209
        Height = 17
        Caption = 'nur die Treffer in den TAN Bericht'
        Checked = True
        State = cbChecked
        TabOrder = 29
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Postproduction'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label26: TLabel
        Left = 11
        Top = 237
        Width = 55
        Height = 13
        Caption = 'RFC 1738'
      end
      object Label24: TLabel
        Left = 11
        Top = 425
        Width = 32
        Height = 13
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Ger'#228't'
      end
      object Edit16: TEdit
        Left = 40
        Top = 80
        Width = 321
        Height = 21
        TabOrder = 0
        Text = 'G:\menden002.txt'
      end
      object Button10: TButton
        Left = 384
        Top = 80
        Width = 104
        Height = 25
        Caption = 'Verarbeiten'
        TabOrder = 1
        OnClick = Button10Click
      end
      object Edit17: TEdit
        Left = 40
        Top = 56
        Width = 321
        Height = 21
        TabOrder = 2
        Text = 'G:\menden001.txt'
      end
      object Edit18: TEdit
        Left = 168
        Top = 160
        Width = 225
        Height = 21
        TabOrder = 3
        Text = 'KARL*.TXT'
      end
      object Button15: TButton
        Left = 409
        Top = 160
        Width = 136
        Height = 25
        Caption = 'Parameter Namen'
        TabOrder = 4
        OnClick = Button15Click
      end
      object Edit19: TEdit
        Left = 11
        Top = 256
        Width = 633
        Height = 21
        TabOrder = 5
        Text = 'Edit19'
        OnKeyPress = Edit19KeyPress
      end
      object Button5: TButton
        Left = 11
        Top = 328
        Width = 633
        Height = 25
        Caption = '"000" nach Merkw'#252'rdigkeiten des Datums durchsuchen'
        TabOrder = 6
        OnClick = Button5Click
      end
      object Edit21: TEdit
        Left = 40
        Top = 297
        Width = 32
        Height = 21
        TabOrder = 7
        Text = '0'
      end
      object Button17: TButton
        Left = 11
        Top = 389
        Width = 633
        Height = 25
        Caption = '"XXX.txt" hochladen'
        TabOrder = 8
        OnClick = Button17Click
      end
      object Button11: TButton
        Left = 80
        Top = 419
        Width = 564
        Height = 22
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Bilder: "Prefix" neu berechnen'
        TabOrder = 9
        OnClick = Button11Click
      end
      object Edit22: TEdit
        Left = 46
        Top = 419
        Width = 30
        Height = 21
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        TabOrder = 10
        Text = '055'
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Migration'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Button19: TButton
        Left = 144
        Top = 48
        Width = 225
        Height = 25
        Caption = 'BLA nach BLA+TS'
        TabOrder = 0
        OnClick = Button19Click
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Pflege'
      ImageIndex = 5
      object Button18: TButton
        Left = 11
        Top = 278
        Width = 633
        Height = 43
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Alte zips Ablegen'
        TabOrder = 0
        OnClick = Button18Click
      end
      object Button21: TButton
        Left = 11
        Top = 232
        Width = 633
        Height = 41
        Caption = 'BLA - Reorganisieren, dabei zu alte Infos ablegen'
        TabOrder = 1
        OnClick = Button21Click
      end
      object Button22: TButton
        Left = 11
        Top = 325
        Width = 633
        Height = 43
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Caption = 'Baustellen-Infos laden'
        TabOrder = 2
        OnClick = Button22Click
      end
    end
  end
  object ProgressBar1: TProgressBar
    Left = 7
    Top = 28
    Width = 669
    Height = 16
    TabOrder = 1
  end
  object DCP_md51: TDCP_md5
    Id = 16
    Algorithm = 'MD5'
    HashSize = 128
    Left = 72
    Top = 8
  end
end
