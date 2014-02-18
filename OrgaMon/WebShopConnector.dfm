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
      Caption = 'WebShop - XML RPC'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
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
    object TabSheet2: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'WebShop - Medien'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
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
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
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
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
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
    Left = 8
    Top = 299
    Width = 680
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
    Left = 480
    Top = 64
  end
end
