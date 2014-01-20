object FormFISxp: TFormFISxp
  Left = 65
  Top = 12
  Width = 805
  Height = 647
  Caption = 'FIS xp'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel
    Left = 8
    Top = 254
    Width = 38
    Height = 13
    Caption = 'Forms:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label9: TLabel
    Left = 96
    Top = 254
    Width = 90
    Height = 13
    Caption = 'Input-Elemente:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label10: TLabel
    Left = 8
    Top = 8
    Width = 68
    Height = 13
    Caption = 'Log/Status:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 712
    Top = 254
    Width = 73
    Height = 13
    Caption = 'JavaParams:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object GroupBox2: TGroupBox
    Left = 184
    Top = 440
    Width = 510
    Height = 161
    Caption = 'Test'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object Label1: TLabel
      Left = 16
      Top = 28
      Width = 53
      Height = 13
      Caption = '1) DatID:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 16
      Top = 60
      Width = 12
      Height = 13
      Caption = '2)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 152
      Top = 28
      Width = 19
      Height = 13
      Caption = '3a)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 152
      Top = 60
      Width = 19
      Height = 13
      Caption = '3b)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 152
      Top = 92
      Width = 12
      Height = 13
      Caption = '4)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 20
      Top = 136
      Width = 33
      Height = 13
      Caption = 'Action:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 296
      Top = 28
      Width = 107
      Height = 13
      Caption = '5a) SerienNr. Neu:'
    end
    object Label12: TLabel
      Left = 296
      Top = 60
      Width = 19
      Height = 13
      Caption = '5b)'
    end
    object Button1: TButton
      Left = 32
      Top = 54
      Width = 90
      Height = 25
      Caption = 'Init'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 176
      Top = 86
      Width = 89
      Height = 25
      Caption = 'ProcessOne'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button2Click
    end
    object EditDatID: TEdit
      Left = 72
      Top = 24
      Width = 49
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = '1805023'
    end
    object Button5: TButton
      Left = 176
      Top = 54
      Width = 89
      Height = 25
      Caption = #220'bernehmen'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 176
      Top = 22
      Width = 89
      Height = 25
      Caption = 'Daten eingeben'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = Button6Click
    end
    object CheckLogEvents: TCheckBox
      Left = 416
      Top = 102
      Width = 81
      Height = 17
      Caption = 'LogEvents'
      Checked = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      State = cbChecked
      TabOrder = 5
    end
    object EditAction: TEdit
      Left = 64
      Top = 132
      Width = 433
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
    end
    object Button8: TButton
      Left = 320
      Top = 54
      Width = 178
      Height = 25
      Caption = 'SerienNr. Neu eintragen'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = Button8Click
    end
    object EditCounterID: TEdit
      Left = 408
      Top = 24
      Width = 89
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
    end
  end
  object Memo3: TMemo
    Left = 8
    Top = 32
    Width = 785
    Height = 209
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Memo3')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Memo_Data: TMemo
    Left = 96
    Top = 272
    Width = 609
    Height = 153
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Memo_Data')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
    OnKeyPress = Memo_DataKeyPress
  end
  object Button4: TButton
    Left = 704
    Top = 576
    Width = 91
    Height = 25
    Cancel = True
    Caption = 'Schlie'#223'en'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = Button4Click
  end
  object Button3: TButton
    Left = 8
    Top = 408
    Width = 82
    Height = 17
    Caption = 'Clear ->'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button7: TButton
    Left = 711
    Top = 8
    Width = 82
    Height = 17
    Caption = 'Clear'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = Button7Click
  end
  object FormList: TListBox
    Left = 8
    Top = 272
    Width = 81
    Height = 129
    ItemHeight = 13
    TabOrder = 6
    OnClick = FormListClick
  end
  object JavaParamsList: TListBox
    Left = 712
    Top = 272
    Width = 81
    Height = 153
    ItemHeight = 13
    TabOrder = 7
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 440
    Width = 169
    Height = 161
    Caption = 'Zugangsdaten'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    object Label13: TLabel
      Left = 16
      Top = 32
      Width = 71
      Height = 13
      Caption = 'Benutzername:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label14: TLabel
      Left = 16
      Top = 88
      Width = 46
      Height = 13
      Caption = 'Passwort:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object EditUser: TEdit
      Left = 16
      Top = 48
      Width = 137
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'blsewa'
    end
    object EditPass: TEdit
      Left = 16
      Top = 104
      Width = 137
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      PasswordChar = '?'
      TabOrder = 1
      Text = 'av76185'
    end
  end
  object Button9: TButton
    Left = 624
    Top = 8
    Width = 75
    Height = 17
    Caption = 'Save HTML'
    TabOrder = 9
    OnClick = Button9Click
  end
  object IdHTTP1: TIdHTTP
    Intercept = IdLogEvent1
    IOHandler = IdSSLIOHandlerSocket1
    MaxLineLength = 65535
    MaxLineAction = maException
    ReadTimeout = 30000
    RecvBufferSize = 65535
    SendBufferSize = 65535
    AllowCookies = True
    HandleRedirects = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = []
    OnRedirect = IdHTTP1Redirect
    Left = 704
    Top = 456
  end
  object IdSSLIOHandlerSocket1: TIdSSLIOHandlerSocket
    SSLOptions.Method = sslvSSLv2
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 736
    Top = 456
  end
  object IdLogEvent1: TIdLogEvent
    OnSend = IdLogEvent1Send
    Active = True
    ReplaceCRLF = False
    OnSent = IdLogEvent1Sent
    OnStatus = IdLogEvent1Status
    Left = 768
    Top = 456
  end
end
