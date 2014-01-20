object VerbindungITForm: TVerbindungITForm
  Left = 216
  Top = 156
  BorderStyle = bsToolWindow
  Caption = 'Besucher Terminal'
  ClientHeight = 456
  ClientWidth = 732
  Color = 16697712
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 62
    Top = 119
    Width = 27
    Height = 18
    Alignment = taRightJustify
    Caption = '###'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Black'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 62
    Top = 151
    Width = 27
    Height = 18
    Alignment = taRightJustify
    Caption = '###'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Black'
    Font.Style = []
    ParentFont = False
  end
  object Image1: TImage
    Left = 8
    Top = 279
    Width = 713
    Height = 161
    AutoSize = True
    Stretch = True
    Transparent = True
  end
  object Label4: TLabel
    Left = 248
    Top = 8
    Width = 37
    Height = 13
    Caption = 'Label4'
  end
  object Label5: TLabel
    Left = 9
    Top = 98
    Width = 27
    Height = 13
    Caption = 'Land'
  end
  object Label6: TLabel
    Left = 9
    Top = 120
    Width = 33
    Height = 13
    Caption = 'Name'
  end
  object Label7: TLabel
    Left = 8
    Top = 152
    Width = 32
    Height = 13
    Caption = 'Firma'
  end
  object Label8: TLabel
    Left = 8
    Top = 260
    Width = 66
    Height = 13
    Caption = 'Unterschrift'
  end
  object Label9: TLabel
    Left = 128
    Top = 205
    Width = 4
    Height = 13
  end
  object Label13: TLabel
    Left = 14
    Top = 16
    Width = 44
    Height = 13
    Caption = 'Label13'
  end
  object Label14: TLabel
    Left = 62
    Top = 185
    Width = 27
    Height = 18
    Alignment = taRightJustify
    Caption = '###'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Black'
    Font.Style = []
    ParentFont = False
  end
  object Label15: TLabel
    Left = 10
    Top = 184
    Width = 36
    Height = 13
    Caption = 'Handy'
  end
  object Edit2: TEdit
    Left = 128
    Top = 117
    Width = 153
    Height = 21
    TabOrder = 0
  end
  object Edit3: TEdit
    Left = 128
    Top = 149
    Width = 153
    Height = 21
    TabOrder = 1
  end
  object Button3: TButton
    Left = 288
    Top = 119
    Width = 89
    Height = 18
    Caption = '>> Terminal'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 288
    Top = 151
    Width = 89
    Height = 18
    Caption = '>> Terminal'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 128
    Top = 208
    Width = 105
    Height = 25
    Caption = 'Eingabe l'#246'schen'
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 95
    Top = 119
    Width = 28
    Height = 17
    Caption = '>>'
    TabOrder = 5
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 95
    Top = 151
    Width = 28
    Height = 17
    Caption = '>>'
    TabOrder = 6
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 95
    Top = 183
    Width = 28
    Height = 17
    Caption = '>>'
    TabOrder = 7
    OnClick = Button8Click
  end
  object Edit4: TEdit
    Left = 128
    Top = 181
    Width = 153
    Height = 21
    TabOrder = 8
  end
  object Button9: TButton
    Left = 288
    Top = 183
    Width = 89
    Height = 18
    Caption = '>> Terminal'
    TabOrder = 9
    OnClick = Button9Click
  end
  object CheckBoxAutoTrans: TCheckBox
    Left = 360
    Top = 8
    Width = 289
    Height = 17
    Caption = 'Automatische Daten'#252'bernahme aus Terminal'
    Checked = True
    State = cbChecked
    TabOrder = 10
  end
  object Button1: TButton
    Left = 8
    Top = 209
    Width = 57
    Height = 24
    Caption = 'laden'
    TabOrder = 11
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 400
    Top = 39
    Width = 324
    Height = 234
    ItemHeight = 13
    TabOrder = 12
  end
  object Button2: TButton
    Left = 14
    Top = 35
    Width = 75
    Height = 25
    Caption = 'connect'
    TabOrder = 13
    OnClick = Button2Click
  end
  object Button10: TButton
    Left = 14
    Top = 66
    Width = 75
    Height = 25
    Caption = 'disconnect'
    TabOrder = 14
    OnClick = Button10Click
  end
  object Button11: TButton
    Left = 655
    Top = 8
    Width = 75
    Height = 25
    Caption = 'MSN Open'
    TabOrder = 15
    OnClick = Button11Click
  end
  object Timer1: TTimer
    Interval = 333
    OnTimer = Timer1Timer
    Left = 24
    Top = 304
  end
  object IdTCPClient1: TIdTCPClient
    OnStatus = IdTCPClient1Status
    ConnectTimeout = 2500
    IPVersion = Id_IPv4
    Port = 34
    ReadTimeout = 20
    Left = 64
    Top = 304
  end
end
