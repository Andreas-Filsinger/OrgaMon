object FormMain: TFormMain
  Left = 15
  Top = 304
  BorderStyle = bsToolWindow
  Caption = 'FormMain'
  ClientHeight = 321
  ClientWidth = 761
  Color = clSilver
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image3: TImage
    Left = 8
    Top = 176
    Width = 273
    Height = 57
    Stretch = True
    Transparent = True
  end
  object Image2: TImage
    Left = 6
    Top = 118
    Width = 130
    Height = 50
    AutoSize = True
  end
  object Label1: TLabel
    Left = 7
    Top = 279
    Width = 37
    Height = 13
    Caption = 'Label1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object Image1: TImage
    Left = 9
    Top = 10
    Width = 280
    Height = 99
    AutoSize = True
  end
  object Label2: TLabel
    Left = 9
    Top = 296
    Width = 37
    Height = 13
    Caption = 'Label2'
  end
  object Button1: TButton
    Left = 374
    Top = 32
    Width = 76
    Height = 25
    Caption = 'PLZ Import'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 299
    Top = 7
    Width = 75
    Height = 50
    Caption = '&Personen'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 299
    Top = 59
    Width = 75
    Height = 50
    Caption = 'Artikel'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 299
    Top = 111
    Width = 75
    Height = 50
    Caption = 'Belege'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 607
    Top = 265
    Width = 143
    Height = 50
    Caption = 'Ende'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 450
    Top = 59
    Width = 76
    Height = 25
    Caption = 'Serie'
    TabOrder = 5
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 374
    Top = 163
    Width = 76
    Height = 25
    Caption = 'L'#228'nder'
    TabOrder = 6
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 374
    Top = 188
    Width = 76
    Height = 25
    Caption = 'Texte'
    TabOrder = 7
    OnClick = Button8Click
  end
  object Button10: TButton
    Left = 450
    Top = 188
    Width = 76
    Height = 25
    Caption = '#-Kreise'
    TabOrder = 8
    OnClick = Button10Click
  end
  object Button11: TButton
    Left = 526
    Top = 188
    Width = 76
    Height = 25
    Caption = 'SQL direkt'
    TabOrder = 9
    OnClick = Button11Click
  end
  object Button12: TButton
    Left = 526
    Top = 7
    Width = 76
    Height = 25
    Caption = 'doppelte K'
    TabOrder = 10
    OnClick = Button12Click
  end
  object Button13: TButton
    Left = 526
    Top = 32
    Width = 76
    Height = 25
    Caption = 'Mailing'
    TabOrder = 11
    OnClick = Button13Click
  end
  object Button14: TButton
    Left = 374
    Top = 59
    Width = 76
    Height = 25
    Caption = '... suche'
    TabOrder = 12
    OnClick = Button14Click
  end
  object Button15: TButton
    Left = 602
    Top = 59
    Width = 76
    Height = 25
    Caption = 'Lager'
    TabOrder = 13
    OnClick = Button15Click
  end
  object Button16: TButton
    Left = 450
    Top = 32
    Width = 76
    Height = 25
    Caption = 'Lieferant'
    TabOrder = 14
    OnClick = Button16Click
  end
  object Button17: TButton
    Left = 374
    Top = 84
    Width = 76
    Height = 25
    Caption = 'Sortiment'
    TabOrder = 15
    OnClick = Button17Click
  end
  object Button18: TButton
    Left = 450
    Top = 84
    Width = 76
    Height = 25
    Caption = 'Creator'
    TabOrder = 16
    OnClick = Button18Click
  end
  object Button19: TButton
    Left = 526
    Top = 59
    Width = 76
    Height = 25
    Caption = 'MwSt'
    TabOrder = 17
    OnClick = Button19Click
  end
  object Button20: TButton
    Left = 374
    Top = 215
    Width = 76
    Height = 25
    Caption = 'Termine'
    TabOrder = 18
    OnClick = Button20Click
  end
  object Button21: TButton
    Left = 299
    Top = 163
    Width = 75
    Height = 50
    Caption = 'System'
    TabOrder = 19
    OnClick = Button21Click
  end
  object Button22: TButton
    Left = 602
    Top = 136
    Width = 75
    Height = 25
    Caption = '------'
    TabOrder = 20
  end
  object Button23: TButton
    Left = 450
    Top = 7
    Width = 76
    Height = 25
    Caption = 'Aufkleber'
    TabOrder = 21
    OnClick = Button23Click
  end
  object Button24: TButton
    Left = 374
    Top = 267
    Width = 76
    Height = 25
    Caption = 'Web-Export'
    TabOrder = 22
    OnClick = Button24Click
  end
  object Button25: TButton
    Left = 526
    Top = 163
    Width = 76
    Height = 25
    Caption = 'BackUp'
    TabOrder = 23
    OnClick = Button25Click
  end
  object Button26: TButton
    Left = 450
    Top = 163
    Width = 76
    Height = 25
    Caption = 'ReOrg'
    TabOrder = 24
    OnClick = Button26Click
  end
  object Button9: TButton
    Left = 374
    Top = 7
    Width = 76
    Height = 25
    Caption = '... suche'
    TabOrder = 25
    OnClick = Button9Click
  end
  object Button27: TButton
    Left = 450
    Top = 136
    Width = 152
    Height = 25
    Caption = '&Auftrag bearbeiten'
    TabOrder = 26
    OnClick = Button27Click
  end
  object Button28: TButton
    Left = 450
    Top = 111
    Width = 76
    Height = 25
    Caption = 'Konto'
    TabOrder = 27
    OnClick = Button28Click
  end
  object Button29: TButton
    Left = 602
    Top = 84
    Width = 75
    Height = 25
    Caption = 'Inventur'
    TabOrder = 28
    OnClick = Button29Click
  end
  object Button30: TButton
    Left = 299
    Top = 215
    Width = 75
    Height = 50
    Caption = 'Ereignis'
    TabOrder = 29
    OnClick = Button30Click
  end
  object Button31: TButton
    Left = 602
    Top = 163
    Width = 75
    Height = 25
    Caption = 'Tagesabschluss'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
    TabOrder = 30
    OnClick = Button31Click
  end
  object Button32: TButton
    Left = 374
    Top = 136
    Width = 76
    Height = 25
    Caption = 'Versender'
    TabOrder = 31
    OnClick = Button32Click
  end
  object Button33: TButton
    Left = 450
    Top = 215
    Width = 75
    Height = 25
    Caption = 'German Parcel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
    TabOrder = 32
    OnClick = Button33Click
  end
  object Button34: TButton
    Left = 374
    Top = 111
    Width = 76
    Height = 25
    Caption = '... suche'
    TabOrder = 33
    OnClick = Button34Click
  end
  object Button36: TButton
    Left = 677
    Top = 163
    Width = 75
    Height = 25
    Caption = 'Update'
    TabOrder = 34
    OnClick = Button36Click
  end
  object Button37: TButton
    Left = 677
    Top = 188
    Width = 75
    Height = 25
    Caption = 'Info'
    TabOrder = 35
    OnClick = Button37Click
  end
  object Button38: TButton
    Left = 677
    Top = 84
    Width = 76
    Height = 25
    Caption = 'Verlage'
    TabOrder = 36
    OnClick = Button38Click
  end
  object Button41: TButton
    Left = 299
    Top = 267
    Width = 75
    Height = 50
    Caption = 'WWW'
    Enabled = False
    TabOrder = 37
  end
  object Button42: TButton
    Left = 450
    Top = 267
    Width = 75
    Height = 25
    Caption = 'Statistik'
    TabOrder = 38
    OnClick = Button42Click
  end
  object Button43: TButton
    Left = 602
    Top = 7
    Width = 75
    Height = 25
    Caption = 'Prorata'
    TabOrder = 39
    OnClick = Button43Click
  end
  object Button44: TButton
    Left = 602
    Top = 188
    Width = 75
    Height = 25
    Caption = 'AusgabeArt'
    TabOrder = 40
    OnClick = Button44Click
  end
  object Button45: TButton
    Left = 450
    Top = 292
    Width = 75
    Height = 25
    Caption = 'PDF Mailer'
    TabOrder = 41
    OnClick = Button45Click
  end
  object Button46: TButton
    Left = 677
    Top = 111
    Width = 76
    Height = 25
    Caption = 'Agent'
    TabOrder = 42
    OnClick = Button46Click
  end
  object Button35: TButton
    Left = 374
    Top = 292
    Width = 76
    Height = 25
    Caption = 'WebShop'
    TabOrder = 43
    OnClick = Button35Click
  end
  object Button39: TButton
    Left = 525
    Top = 292
    Width = 75
    Height = 25
    Caption = 'B2B Check'
    TabOrder = 44
    OnClick = Button39Click
  end
  object Button40: TButton
    Left = 525
    Top = 267
    Width = 75
    Height = 25
    Caption = 'Aktion'
    TabOrder = 45
    OnClick = Button40Click
  end
  object Button47: TButton
    Left = 526
    Top = 84
    Width = 75
    Height = 25
    Caption = 'Index NEU'
    TabOrder = 46
    OnClick = Button47Click
  end
end
