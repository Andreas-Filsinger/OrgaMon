object FormepIMPORT: TFormepIMPORT
  Left = 103
  Top = 226
  Caption = 'OrgaMon Migration aus EP/GaZMa'
  ClientHeight = 448
  ClientWidth = 611
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 7
    Top = 17
    Width = 225
    Height = 25
    Caption = 'OrgaMon Migration'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object PageControl1: TPageControl
    Left = 7
    Top = 56
    Width = 594
    Height = 345
    ActivePage = TabSheet10
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'EP'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 16
        Top = 17
        Width = 59
        Height = 13
        Caption = 'Quell-Pfad'
      end
      object Label2: TLabel
        Left = 241
        Top = 215
        Width = 89
        Height = 13
        Caption = 'einzelnes Paket'
      end
      object Label10: TLabel
        Left = 283
        Top = 283
        Width = 107
        Height = 13
        Caption = 'einzelne Rechnung'
      end
      object Edit1: TEdit
        Left = 16
        Top = 43
        Width = 225
        Height = 21
        TabOrder = 0
        Text = 'Z:\anfisoft\'
      end
      object Button1: TButton
        Left = 305
        Top = 127
        Width = 169
        Height = 65
        Caption = 'Importieren!'
        TabOrder = 1
        OnClick = Button1Click
      end
      object CheckBox1: TCheckBox
        Left = 248
        Top = 16
        Width = 145
        Height = 17
        Caption = 'Patientenbesitzer'
        TabOrder = 2
      end
      object CheckBox2: TCheckBox
        Left = 248
        Top = 33
        Width = 153
        Height = 16
        Caption = 'Tiere'
        TabOrder = 3
      end
      object CheckBox3: TCheckBox
        Left = 248
        Top = 48
        Width = 209
        Height = 17
        Caption = 'Leistungen/Sortiment/MwSt/Pakete'
        TabOrder = 4
      end
      object CheckBox4: TCheckBox
        Left = 248
        Top = 64
        Width = 162
        Height = 17
        Caption = 'Rechnungen'
        Checked = True
        State = cbChecked
        TabOrder = 5
      end
      object ListBox1: TListBox
        Left = 16
        Top = 97
        Width = 169
        Height = 169
        ItemHeight = 13
        TabOrder = 6
      end
      object Button2: TButton
        Left = 397
        Top = 97
        Width = 77
        Height = 24
        Caption = 'abbrechen'
        TabOrder = 7
        OnClick = Button2Click
      end
      object Edit2: TEdit
        Left = 397
        Top = 280
        Width = 59
        Height = 21
        TabOrder = 8
        Text = '030000'
      end
      object Button3: TButton
        Left = 472
        Top = 211
        Width = 75
        Height = 25
        Caption = 'Button3'
        TabOrder = 9
      end
      object Edit3: TEdit
        Left = 335
        Top = 214
        Width = 121
        Height = 21
        TabOrder = 10
        Text = 'Edit3'
      end
      object Button14: TButton
        Left = 472
        Top = 279
        Width = 75
        Height = 24
        Caption = 'Import'
        TabOrder = 11
        OnClick = Button14Click
      end
      object Button15: TButton
        Left = 81
        Top = 12
        Width = 75
        Height = 25
        Caption = 'default'
        TabOrder = 12
        OnClick = Button15Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'GaZMa'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label3: TLabel
        Left = 7
        Top = 97
        Width = 37
        Height = 13
        Caption = 'Label3'
      end
      object Label5: TLabel
        Left = 7
        Top = 7
        Width = 94
        Height = 13
        Caption = 'Quelldatenbank:'
      end
      object Edit4: TEdit
        Left = 7
        Top = 24
        Width = 562
        Height = 21
        TabOrder = 0
      end
      object Button4: TButton
        Left = 7
        Top = 56
        Width = 114
        Height = 25
        Caption = 'GaZMa Migration'
        TabOrder = 1
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 128
        Top = 56
        Width = 74
        Height = 25
        Caption = 'break'
        TabOrder = 2
        OnClick = Button5Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Geo'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Button6: TButton
        Left = 48
        Top = 33
        Width = 225
        Height = 26
        Caption = 'Datafactory Postalcode'
        TabOrder = 0
        OnClick = Button6Click
      end
      object Button7: TButton
        Left = 48
        Top = 64
        Width = 225
        Height = 25
        Caption = 'Webservice "locate"'
        TabOrder = 1
        OnClick = Button7Click
      end
      object Button8: TButton
        Left = 48
        Top = 97
        Width = 225
        Height = 24
        Caption = 'Webservice "getMap"'
        TabOrder = 2
        OnClick = Button8Click
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Cunz'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label6: TLabel
        Left = 16
        Top = 24
        Width = 59
        Height = 13
        Caption = 'Quell-Pfad'
      end
      object Label7: TLabel
        Left = 33
        Top = 144
        Width = 74
        Height = 13
        Caption = 'Mandant RID'
      end
      object Label8: TLabel
        Left = 264
        Top = 144
        Width = 9
        Height = 13
        Caption = '#'
      end
      object Label9: TLabel
        Left = 305
        Top = 85
        Width = 188
        Height = 13
        Caption = '1) in Person: Den Import starten'
      end
      object Edit5: TEdit
        Left = 16
        Top = 40
        Width = 441
        Height = 21
        TabOrder = 0
        Text = 'I:\KundenUmgebung\puenktlich\dasi-2007-03-19\anfieuro\'
      end
      object Button10: TButton
        Left = 305
        Top = 134
        Width = 169
        Height = 25
        Caption = '3) Rechnungs-Migration'
        TabOrder = 1
        OnClick = Button10Click
      end
      object Button11: TButton
        Left = 305
        Top = 103
        Width = 169
        Height = 25
        Caption = '2) Vertrags-Migration'
        TabOrder = 2
        OnClick = Button11Click
      end
      object Edit6: TEdit
        Left = 128
        Top = 137
        Width = 121
        Height = 21
        TabOrder = 3
        Text = '0'
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Medi-Liste'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Edit7: TEdit
        Left = 33
        Top = 24
        Width = 256
        Height = 21
        TabOrder = 0
        Text = 'Rohstoffe\BLMEDI1.TXT'
      end
      object Button9: TButton
        Left = 295
        Top = 24
        Width = 98
        Height = 72
        Caption = 'Import'
        TabOrder = 1
        OnClick = Button9Click
      end
      object CheckBox7: TCheckBox
        Left = 33
        Top = 79
        Width = 96
        Height = 17
        Caption = 'abbrechen'
        TabOrder = 2
      end
      object StaticText1: TStaticText
        Left = 32
        Top = 56
        Width = 11
        Height = 17
        Caption = '0'
        TabOrder = 3
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Buch'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Button12: TButton
        Left = 33
        Top = 33
        Width = 88
        Height = 25
        Caption = 'SKR03.txt'
        TabOrder = 0
        OnClick = Button12Click
      end
      object Button13: TButton
        Left = 33
        Top = 80
        Width = 160
        Height = 25
        Caption = 'AR/ER Stempel-Migration'
        TabOrder = 1
        OnClick = Button13Click
      end
    end
    object TabSheet7: TTabSheet
      Caption = '1400'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label11: TLabel
        Left = 16
        Top = 16
        Width = 257
        Height = 13
        Caption = 'Migration "AUSGANGSRECHNUNG" -> "1400"'
      end
      object Button16: TButton
        Left = 494
        Top = 271
        Width = 75
        Height = 25
        Caption = 'Start'
        TabOrder = 0
        OnClick = Button16Click
      end
      object ListBox2: TListBox
        Left = 16
        Top = 48
        Width = 553
        Height = 217
        ItemHeight = 13
        TabOrder = 1
      end
      object Abbruch: TCheckBox
        Left = 144
        Top = 272
        Width = 77
        Height = 17
        Caption = 'Abbruch'
        TabOrder = 2
      end
    end
    object TabSheet8: TTabSheet
      Caption = 'eMail'
      ImageIndex = 7
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label12: TLabel
        Left = 3
        Top = 48
        Width = 52
        Height = 13
        Caption = 'BELEG_R'
      end
      object Label13: TLabel
        Left = 3
        Top = 88
        Width = 107
        Height = 13
        Caption = 'eMail - Liste (CSV)'
      end
      object Edit8: TEdit
        Left = 120
        Top = 45
        Width = 81
        Height = 21
        TabOrder = 0
        Text = '84193'
      end
      object Edit9: TEdit
        Left = 120
        Top = 80
        Width = 449
        Height = 21
        TabOrder = 1
        Text = 'System\Newsletter Kunden.csv'
      end
      object Button17: TButton
        Left = 494
        Top = 289
        Width = 75
        Height = 25
        Caption = 'Start'
        TabOrder = 2
        OnClick = Button17Click
      end
      object ListBox3: TListBox
        Left = 3
        Top = 107
        Width = 566
        Height = 176
        ItemHeight = 13
        TabOrder = 3
      end
    end
    object TabSheet10: TTabSheet
      Caption = 'FPSpreadSheet'
      ImageIndex = 9
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Button19: TButton
        Left = 32
        Top = 32
        Width = 121
        Height = 25
        Caption = #214'ffne XLS'
        TabOrder = 0
        OnClick = Button19Click
      end
    end
  end
  object ProgressBar1: TProgressBar
    Left = 7
    Top = 407
    Width = 594
    Height = 28
    TabOrder = 1
  end
  object IB_QueryPERSON: TIB_Query
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select * from person for update')
    RequestLive = True
    Left = 312
    Top = 8
  end
  object IB_QueryANSCHRIFT: TIB_Query
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select * from anschrift for update')
    RequestLive = True
    Left = 344
    Top = 8
  end
  object IB_QueryTIER: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED')
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select * from tier for update')
    RequestLive = True
    Left = 376
    Top = 8
  end
  object IB_QueryARTIKEL: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED')
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select * from artikel for update')
    RequestLive = True
    Left = 408
    Top = 8
  end
  object IB_QuerySORTIMENT: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED')
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select * from sortiment for update')
    RequestLive = True
    Left = 440
    Top = 8
  end
  object IB_QueryMWST: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED')
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select * from mwst for update')
    RequestLive = True
    Left = 472
    Top = 8
  end
  object IB_QueryBELEG: TIB_Query
    ColumnAttributes.Strings = (
      'ANLAGE=NOTREQUIRED'
      'BTYP=NOTREQUIRED'
      'BSTATUS=NOTREQUIRED')
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select '
      ' * '
      'from '
      ' beleg'
      'where'
      ' rid=:CROSSREF'
      'for update')
    RequestLive = True
    Left = 504
    Top = 8
    ParamValues = (
      'CROSSREF=')
  end
  object IB_QueryPOSTEN: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED'
      'ARTIKEL=NOTREQUIRED')
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select '
      ' * '
      'from'
      ' posten'
      'where '
      ' BELEG_R=:CROSSREF'
      'for update')
    RequestLive = True
    Left = 536
    Top = 8
  end
  object IB_QueryAUSGANGSRECHNUNG: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED')
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select '
      ' *'
      'from'
      ' ausgangsrechnung'
      'for update')
    RequestLive = True
    Left = 568
    Top = 8
  end
  object IB_QueryFORDERUNG: TIB_Query
    Left = 256
    Top = 8
  end
end
