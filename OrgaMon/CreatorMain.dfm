object FormCreatorMain: TFormCreatorMain
  Left = 144
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Crypt'
  ClientHeight = 648
  ClientWidth = 610
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 30
    Top = 36
    Width = 71
    Height = 13
    Caption = 'MUS-&Quelle:'
  end
  object Label3: TLabel
    Left = 33
    Top = 380
    Width = 107
    Height = 13
    Caption = 'CD ROM-&Ausgabe:'
  end
  object Label4: TLabel
    Left = 32
    Top = 296
    Width = 67
    Height = 13
    Caption = 'Datenbank:'
  end
  object Label5: TLabel
    Left = 34
    Top = 432
    Width = 573
    Height = 65
    AutoSize = False
    Caption = 'Label5'
    WordWrap = True
  end
  object Label6: TLabel
    Left = 32
    Top = 320
    Width = 77
    Height = 13
    Caption = 'Wortanf'#228'nge:'
  end
  object Label7: TLabel
    Left = 32
    Top = 336
    Width = 74
    Height = 13
    Caption = 'Komponisten'
  end
  object Label8: TLabel
    Left = 32
    Top = 352
    Width = 88
    Height = 13
    Caption = 'L'#228'nder, Verlage'
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 279
    Height = 16
    Caption = '1) Noten f'#252'r die CDR zusammenstellen'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label9: TLabel
    Left = 8
    Top = 264
    Width = 313
    Height = 16
    Caption = '2) Artikel-, H'#228'ndler- Daten neu aufbereiten'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label10: TLabel
    Left = 152
    Top = 380
    Width = 44
    Height = 13
    Caption = 'Label10'
  end
  object Label11: TLabel
    Left = 8
    Top = 512
    Width = 457
    Height = 16
    Caption = '3) Berichte einsehen und Passwort f'#252'r eine neue CDR erzeugen'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label12: TLabel
    Left = 10
    Top = 624
    Width = 257
    Height = 13
    Caption = '4) CDR brennen (durch externes Programm)'
  end
  object Label13: TLabel
    Left = 560
    Top = 304
    Width = 12
    Height = 13
    Caption = '%'
  end
  object Button17: TButton
    Left = 32
    Top = 536
    Width = 169
    Height = 25
    Caption = 'Bericht ansehen'
    TabOrder = 18
    OnClick = Button17Click
  end
  object Edit1: TEdit
    Left = 112
    Top = 34
    Width = 313
    Height = 21
    TabOrder = 0
    Text = ' '
    OnExit = Edit1Exit
  end
  object Button4: TButton
    Left = 528
    Top = 616
    Width = 81
    Height = 25
    Caption = '&Ende'
    TabOrder = 1
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 432
    Top = 552
    Width = 177
    Height = 49
    Caption = 'CD &OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = Button5Click
  end
  object CheckListBox1: TCheckListBox
    Left = 32
    Top = 64
    Width = 393
    Height = 193
    BorderStyle = bsNone
    Color = clInfoBk
    Ctl3D = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
  end
  object Button1: TButton
    Left = 32
    Top = 560
    Width = 169
    Height = 25
    Caption = 'Historie ansehen'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 472
    Top = 68
    Width = 137
    Height = 25
    Caption = '<-- Texte '#228'ndern'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button6: TButton
    Left = 472
    Top = 104
    Width = 137
    Height = 25
    Caption = '<-- leeren'
    TabOrder = 6
    OnClick = Button6Click
  end
  object Button3: TButton
    Left = 432
    Top = 32
    Width = 33
    Height = 25
    Caption = '-->'
    TabOrder = 7
    OnClick = Button3Click
  end
  object Button7: TButton
    Left = 472
    Top = 32
    Width = 89
    Height = 25
    Caption = 'Texte '#228'ndern'
    TabOrder = 8
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 568
    Top = 32
    Width = 41
    Height = 25
    Caption = #252
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Wingdings'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = Button8Click
  end
  object ProgressBar1: TProgressBar
    Left = 35
    Top = 402
    Width = 473
    Height = 16
    TabOrder = 10
  end
  object Button10: TButton
    Left = 128
    Top = 288
    Width = 73
    Height = 25
    Caption = 'Import'
    TabOrder = 11
    OnClick = Button10Click
  end
  object Button9: TButton
    Left = 528
    Top = 397
    Width = 81
    Height = 25
    Caption = 'Abbrechen'
    TabOrder = 12
    OnClick = Button9Click
  end
  object Button11: TButton
    Left = 128
    Top = 316
    Width = 73
    Height = 25
    Caption = 'Import'
    TabOrder = 13
  end
  object Button13: TButton
    Left = 128
    Top = 344
    Width = 73
    Height = 25
    Caption = 'Export'
    TabOrder = 14
    OnClick = Button13Click
  end
  object Button12: TButton
    Left = 432
    Top = 328
    Width = 177
    Height = 40
    Caption = '&ERZEUGEN'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 15
    OnClick = Button12Click
  end
  object CheckBox1: TCheckBox
    Left = 432
    Top = 286
    Width = 169
    Height = 17
    Caption = 'als Demo Version'
    TabOrder = 16
  end
  object Edit8: TEdit
    Left = 224
    Top = 290
    Width = 81
    Height = 21
    TabOrder = 17
    Text = 'Edit8'
    OnExit = Edit8Exit
  end
  object Button18: TButton
    Left = 224
    Top = 344
    Width = 169
    Height = 25
    Caption = 'HEntry.txt erzeugen'
    TabOrder = 19
    OnClick = Button18Click
  end
  object Button19: TButton
    Left = 32
    Top = 584
    Width = 169
    Height = 25
    Caption = 'HEntry ansehen'
    TabOrder = 20
    OnClick = Button19Click
  end
  object CheckBox2: TCheckBox
    Left = 432
    Top = 269
    Width = 97
    Height = 17
    Caption = 'f'#252'r .\CD-R'
    Checked = True
    State = cbChecked
    TabOrder = 21
    OnClick = CheckBox2Click
  end
  object CheckBox3: TCheckBox
    Left = 432
    Top = 304
    Width = 97
    Height = 17
    Caption = 'Umfang ca.'
    TabOrder = 22
  end
  object Edit2: TEdit
    Left = 520
    Top = 300
    Width = 34
    Height = 21
    TabOrder = 23
    Text = '20'
  end
  object IB_Query1: TIB_Query
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select'
      ' *'
      'from'
      ' ARTIKEL'
      '')
    Left = 48
    Top = 120
  end
  object IB_Query2: TIB_Query
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT *'
      'FROM SORTIMENT')
    Left = 80
    Top = 120
  end
  object IB_Query3: TIB_Query
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT *'
      'FROM PERSON'
      'WHERE RID=:CROSSREF')
    Left = 112
    Top = 120
  end
  object IB_Query4: TIB_Query
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT *'
      'FROM ANSCHRIFT'
      'WHERE RID=:CROSSREF')
    Left = 152
    Top = 120
  end
end
