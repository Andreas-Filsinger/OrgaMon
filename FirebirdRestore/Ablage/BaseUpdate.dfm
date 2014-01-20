object FormBaseUpdate: TFormBaseUpdate
  Left = 97
  Top = 97
  Caption = 'Update'
  ClientHeight = 428
  ClientWidth = 497
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 497
    Height = 428
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Anwendungs Update'
      OnShow = TabSheet1Show
      object Label2: TLabel
        Left = 243
        Top = 150
        Width = 90
        Height = 13
        Caption = 'Programm Rev.'
      end
      object Label6: TLabel
        Left = 139
        Top = 196
        Width = 194
        Height = 13
        Caption = 'neuestes Update im InterNet Rev.'
      end
      object Label4: TLabel
        Left = 102
        Top = 173
        Width = 231
        Height = 13
        Caption = 'neuestes Update im .\Updates Pfad Rev.'
      end
      object Label9: TLabel
        Left = 8
        Top = 24
        Width = 209
        Height = 16
        Caption = 'Update- und Serviceroutinen'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object SpeedButton4: TSpeedButton
        Left = 335
        Top = 147
        Width = 20
        Height = 20
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFB78183A47874A47874A47874A47874A47874A4
          7874A47874A47874A47874A47874A47874986B66FF00FFFF00FFFF00FFB78183
          FDEFD9F6E3CBF5DFC2F4DBBAF2D7B2F1D4A9F1D0A2EECC99EECC97EECC97F3D1
          99986B66FF00FFFF00FFFF00FFB48176FEF3E3F8E7D3F5E3CBF5DFC3CFCF9F01
          8A02018A02CCC68BEECC9AEECC97F3D199986B66FF00FFFF00FFFF00FFB48176
          FFF7EBF9EBDA018A02D1D6AC018A02D0CF9ECECC98018A02CCC689EFCD99F3D1
          98986B66FF00FFFF00FFFF00FFBA8E85FFFCF4FAEFE4018A02018A02D1D5ADF5
          DFC2F4DBBBCDCC98018A02F0D0A1F3D29B986B66FF00FFFF00FFFF00FFBA8E85
          FFFFFDFBF4EC018A02018A02018A02F5E3C9F5DFC2F4DBBAF2D7B1F0D4A9F5D5
          A3986B66FF00FFFF00FFFF00FFCB9A82FFFFFFFEF9F5FBF3ECFAEFE2F9EADAF8
          E7D2018A02018A02018A02F2D8B2F6D9AC986B66FF00FFFF00FFFF00FFCB9A82
          FFFFFFFFFEFD018A02D6E3C9F9EFE3F8EADAD2D9B3018A02018A02F4DBB9F8DD
          B4986B66FF00FFFF00FFFF00FFDCA887FFFFFFFFFFFFD9EDD8018A02D6E3C8D5
          E0C1018A02D3D8B2018A02F7E1C2F0DAB7986B66FF00FFFF00FFFF00FFDCA887
          FFFFFFFFFFFFFFFFFFD9EDD8018A02018A02D5DFC1FAEDDCFCEFD9E6D9C4C6BC
          A9986B66FF00FFFF00FFFF00FFE3B18EFFFFFFFFFFFFFFFFFFFFFFFFFFFEFDFD
          F8F3FDF6ECF1E1D5B48176B48176B48176B48176FF00FFFF00FFFF00FFE3B18E
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFCFFFEF9E3CFC9B48176E8B270ECA5
          4AC58768FF00FFFF00FFFF00FFEDBD92FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFE4D4D2B48176FAC577CD9377FF00FFFF00FFFF00FFFF00FFEDBD92
          FCF7F4FCF7F3FBF6F3FBF6F3FAF5F3F9F5F3F9F5F3E1D0CEB48176CF9B86FF00
          FFFF00FFFF00FFFF00FFFF00FFEDBD92DAA482DAA482DAA482DAA482DAA482DA
          A482DAA482DAA482B48176FF00FFFF00FFFF00FFFF00FFFF00FF}
        OnClick = SpeedButton4Click
      end
      object SpeedButton1: TSpeedButton
        Left = 335
        Top = 169
        Width = 20
        Height = 20
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFB78183A47874A47874A47874A47874A47874A4
          7874A47874A47874A47874A47874A47874986B66FF00FFFF00FFFF00FFB78183
          FDEFD9F6E3CBF5DFC2F4DBBAF2D7B2F1D4A9F1D0A2EECC99EECC97EECC97F3D1
          99986B66FF00FFFF00FFFF00FFB48176FEF3E3F8E7D3F5E3CBF5DFC3CFCF9F01
          8A02018A02CCC68BEECC9AEECC97F3D199986B66FF00FFFF00FFFF00FFB48176
          FFF7EBF9EBDA018A02D1D6AC018A02D0CF9ECECC98018A02CCC689EFCD99F3D1
          98986B66FF00FFFF00FFFF00FFBA8E85FFFCF4FAEFE4018A02018A02D1D5ADF5
          DFC2F4DBBBCDCC98018A02F0D0A1F3D29B986B66FF00FFFF00FFFF00FFBA8E85
          FFFFFDFBF4EC018A02018A02018A02F5E3C9F5DFC2F4DBBAF2D7B1F0D4A9F5D5
          A3986B66FF00FFFF00FFFF00FFCB9A82FFFFFFFEF9F5FBF3ECFAEFE2F9EADAF8
          E7D2018A02018A02018A02F2D8B2F6D9AC986B66FF00FFFF00FFFF00FFCB9A82
          FFFFFFFFFEFD018A02D6E3C9F9EFE3F8EADAD2D9B3018A02018A02F4DBB9F8DD
          B4986B66FF00FFFF00FFFF00FFDCA887FFFFFFFFFFFFD9EDD8018A02D6E3C8D5
          E0C1018A02D3D8B2018A02F7E1C2F0DAB7986B66FF00FFFF00FFFF00FFDCA887
          FFFFFFFFFFFFFFFFFFD9EDD8018A02018A02D5DFC1FAEDDCFCEFD9E6D9C4C6BC
          A9986B66FF00FFFF00FFFF00FFE3B18EFFFFFFFFFFFFFFFFFFFFFFFFFFFEFDFD
          F8F3FDF6ECF1E1D5B48176B48176B48176B48176FF00FFFF00FFFF00FFE3B18E
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFCFFFEF9E3CFC9B48176E8B270ECA5
          4AC58768FF00FFFF00FFFF00FFEDBD92FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFE4D4D2B48176FAC577CD9377FF00FFFF00FFFF00FFFF00FFEDBD92
          FCF7F4FCF7F3FBF6F3FBF6F3FAF5F3F9F5F3F9F5F3E1D0CEB48176CF9B86FF00
          FFFF00FFFF00FFFF00FFFF00FFEDBD92DAA482DAA482DAA482DAA482DAA482DA
          A482DAA482DAA482B48176FF00FFFF00FFFF00FFFF00FFFF00FF}
        OnClick = SpeedButton1Click
      end
      object SpeedButton2: TSpeedButton
        Left = 335
        Top = 192
        Width = 20
        Height = 20
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFB78183A47874A47874A47874A47874A47874A4
          7874A47874A47874A47874A47874A47874986B66FF00FFFF00FFFF00FFB78183
          FDEFD9F6E3CBF5DFC2F4DBBAF2D7B2F1D4A9F1D0A2EECC99EECC97EECC97F3D1
          99986B66FF00FFFF00FFFF00FFB48176FEF3E3F8E7D3F5E3CBF5DFC3CFCF9F01
          8A02018A02CCC68BEECC9AEECC97F3D199986B66FF00FFFF00FFFF00FFB48176
          FFF7EBF9EBDA018A02D1D6AC018A02D0CF9ECECC98018A02CCC689EFCD99F3D1
          98986B66FF00FFFF00FFFF00FFBA8E85FFFCF4FAEFE4018A02018A02D1D5ADF5
          DFC2F4DBBBCDCC98018A02F0D0A1F3D29B986B66FF00FFFF00FFFF00FFBA8E85
          FFFFFDFBF4EC018A02018A02018A02F5E3C9F5DFC2F4DBBAF2D7B1F0D4A9F5D5
          A3986B66FF00FFFF00FFFF00FFCB9A82FFFFFFFEF9F5FBF3ECFAEFE2F9EADAF8
          E7D2018A02018A02018A02F2D8B2F6D9AC986B66FF00FFFF00FFFF00FFCB9A82
          FFFFFFFFFEFD018A02D6E3C9F9EFE3F8EADAD2D9B3018A02018A02F4DBB9F8DD
          B4986B66FF00FFFF00FFFF00FFDCA887FFFFFFFFFFFFD9EDD8018A02D6E3C8D5
          E0C1018A02D3D8B2018A02F7E1C2F0DAB7986B66FF00FFFF00FFFF00FFDCA887
          FFFFFFFFFFFFFFFFFFD9EDD8018A02018A02D5DFC1FAEDDCFCEFD9E6D9C4C6BC
          A9986B66FF00FFFF00FFFF00FFE3B18EFFFFFFFFFFFFFFFFFFFFFFFFFFFEFDFD
          F8F3FDF6ECF1E1D5B48176B48176B48176B48176FF00FFFF00FFFF00FFE3B18E
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFCFFFEF9E3CFC9B48176E8B270ECA5
          4AC58768FF00FFFF00FFFF00FFEDBD92FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFE4D4D2B48176FAC577CD9377FF00FFFF00FFFF00FFFF00FFEDBD92
          FCF7F4FCF7F3FBF6F3FBF6F3FAF5F3F9F5F3F9F5F3E1D0CEB48176CF9B86FF00
          FFFF00FFFF00FFFF00FFFF00FFEDBD92DAA482DAA482DAA482DAA482DAA482DA
          A482DAA482DAA482B48176FF00FFFF00FFFF00FFFF00FFFF00FF}
        OnClick = SpeedButton2Click
      end
      object StaticText2: TStaticText
        Left = 356
        Top = 148
        Width = 49
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = 'StaticText2'
        TabOrder = 0
      end
      object StaticText3: TStaticText
        Left = 356
        Top = 194
        Width = 48
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = 'StaticText3'
        TabOrder = 1
      end
      object Button8: TButton
        Left = 406
        Top = 193
        Width = 69
        Height = 17
        Caption = 'ausf'#252'hren'
        TabOrder = 2
        OnClick = Button8Click
      end
      object ProgressBar1: TProgressBar
        Left = 8
        Top = 224
        Width = 466
        Height = 16
        TabOrder = 3
      end
      object Button4: TButton
        Left = 406
        Top = 148
        Width = 69
        Height = 17
        Caption = 'ausf'#252'hren'
        TabOrder = 4
        OnClick = Button4Click
      end
      object Button9: TButton
        Left = 406
        Top = 171
        Width = 69
        Height = 17
        Caption = 'ausf'#252'hren'
        TabOrder = 5
        OnClick = Button9Click
      end
      object StaticText6: TStaticText
        Left = 356
        Top = 171
        Width = 49
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = 'StaticText2'
        TabOrder = 6
      end
      object Button5: TButton
        Left = 8
        Top = 88
        Width = 467
        Height = 25
        Caption = 'OrgaMon neu starten'
        TabOrder = 7
        OnClick = Button5Click
      end
      object Button6: TButton
        Left = 8
        Top = 56
        Width = 467
        Height = 25
        Caption = 'Andere Orgamon Instanzen beenden'
        TabOrder = 8
        OnClick = Button6Click
      end
      object Button7: TButton
        Left = 8
        Top = 120
        Width = 467
        Height = 25
        Caption = 'Rechner neu starten'
        TabOrder = 9
        OnClick = Button7Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Datenbank Update'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 153
        Top = 44
        Width = 96
        Height = 13
        Caption = 'Datenbank Rev. '
      end
      object Label7: TLabel
        Left = 10
        Top = 176
        Width = 80
        Height = 13
        Caption = 'SQL Diagnose'
      end
      object Label8: TLabel
        Left = 92
        Top = 65
        Width = 157
        Height = 13
        Caption = 'Updates liegen vor f'#252'r Rev.'
      end
      object Label3: TLabel
        Left = 93
        Top = 84
        Width = 154
        Height = 13
        Caption = 'Anzahl Datenbankbenutzer'
      end
      object Label5: TLabel
        Left = 16
        Top = 16
        Width = 37
        Height = 13
        Caption = 'Label5'
      end
      object StaticText1: TStaticText
        Left = 252
        Top = 43
        Width = 49
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '*'
        TabOrder = 0
      end
      object Button1: TButton
        Left = 401
        Top = 357
        Width = 81
        Height = 25
        Caption = 'weiter >>'
        Default = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 321
        Top = 357
        Width = 75
        Height = 25
        Caption = 'abbrechen'
        TabOrder = 2
        OnClick = Button2Click
      end
      object ListBox1: TListBox
        Left = 8
        Top = 192
        Width = 473
        Height = 141
        ItemHeight = 13
        TabOrder = 3
      end
      object CheckBox1: TCheckBox
        Left = 326
        Top = 338
        Width = 156
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Jeden Schritt best'#228'tigen'
        TabOrder = 4
      end
      object StaticText4: TStaticText
        Left = 252
        Top = 83
        Width = 49
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '*'
        TabOrder = 5
      end
      object Button3: TButton
        Left = 304
        Top = 105
        Width = 169
        Height = 20
        Caption = 'Trennung ank'#252'ndigen'
        TabOrder = 6
        OnClick = Button3Click
      end
      object StaticText5: TStaticText
        Left = 252
        Top = 63
        Width = 49
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '*'
        TabOrder = 7
      end
      object Button10: TButton
        Left = 305
        Top = 42
        Width = 75
        Height = 18
        Caption = 'r'#252'cksetzen'
        TabOrder = 8
        OnClick = Button10Click
      end
      object Button11: TButton
        Left = 305
        Top = 62
        Width = 75
        Height = 18
        Caption = 'ermitteln'
        TabOrder = 9
        OnClick = Button11Click
      end
      object ermitteln: TButton
        Left = 305
        Top = 82
        Width = 75
        Height = 19
        Caption = 'ermitteln'
        TabOrder = 10
        OnClick = ermittelnClick
      end
      object CheckBox2: TCheckBox
        Left = 256
        Top = 128
        Width = 217
        Height = 17
        Caption = 'Zwangstrennung aktivieren'
        TabOrder = 11
        OnClick = CheckBox2Click
      end
    end
  end
  object IB_Query1: TIB_Query
    DatabaseName = 'fred:F:\HeBu.gdb'
    SQL.Strings = (
      'SELECT *'
      'FROM REVISION'
      'ORDER BY RID'
      'FOR UPDATE')
    ColorScheme = False
    MasterSearchFlags = [msfOpenMasterOnOpen, msfSearchAppliesToMasterOnly]
    RequestLive = True
    BufferSynchroFlags = []
    FetchWholeRows = True
    Left = 328
    Top = 5
  end
  object IB_Script1: TIB_Script
    OnError = IB_Script1Error
    Left = 360
    Top = 5
  end
  object IdHTTP1: TIdHTTP
    OnWork = IdHTTP1Work
    OnWorkBegin = IdHTTP1WorkBegin
    OnWorkEnd = IdHTTP1WorkEnd
    AuthRetries = 0
    AuthProxyRetries = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentRangeInstanceLength = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 392
    Top = 5
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2500
    OnTimer = Timer1Timer
    Left = 423
    Top = 5
  end
  object IB_Events1: TIB_Events
    AlertOnRegister = False
    Events.Strings = (
      'PLEASE_DISCONNECT'
      'PLEASE_DOWN')
    Passive = False
    OnEventAlert = IB_Events1EventAlert
    Left = 297
    Top = 5
  end
end
