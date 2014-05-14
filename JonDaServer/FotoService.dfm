object FormFotoService: TFormFotoService
  Left = 0
  Top = 0
  Caption = 'FormFotoService'
  ClientHeight = 509
  ClientWidth = 734
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 734
    Height = 509
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Mover'
      object Label8: TLabel
        Left = 368
        Top = 385
        Width = 133
        Height = 13
        Caption = 'Arbeit beschr'#228'nken auf RID'
      end
      object ListBox1: TListBox
        Left = 3
        Top = 16
        Width = 574
        Height = 361
        ItemHeight = 13
        TabOrder = 0
      end
      object Button1: TButton
        Left = 354
        Top = 439
        Width = 75
        Height = 25
        Caption = 'Stopp'
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button4: TButton
        Left = 138
        Top = 439
        Width = 129
        Height = 25
        Caption = 'Work one'
        TabOrder = 2
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 3
        Top = 439
        Width = 129
        Height = 25
        Caption = 'Work all'
        TabOrder = 3
        OnClick = Button5Click
      end
      object CheckBox1: TCheckBox
        Left = 3
        Top = 383
        Width = 249
        Height = 17
        Caption = 'Bilder "Eingang" verarbeiten'
        TabOrder = 4
      end
      object CheckBox2: TCheckBox
        Left = 3
        Top = 406
        Width = 249
        Height = 17
        Caption = 'Bilder "Wartende" verarbeiten'
        TabOrder = 5
      end
      object Button10: TButton
        Left = 273
        Top = 439
        Width = 75
        Height = 25
        Caption = 'ensureGlobals'
        TabOrder = 6
        OnClick = Button10Click
      end
      object Button11: TButton
        Left = 435
        Top = 439
        Width = 97
        Height = 25
        Caption = 'Starte sofort!'
        TabOrder = 7
        OnClick = Button11Click
      end
      object Button13: TButton
        Left = 538
        Top = 439
        Width = 75
        Height = 25
        Caption = 'GEN_ID'
        TabOrder = 8
        OnClick = Button13Click
      end
      object Edit7: TEdit
        Left = 368
        Top = 404
        Width = 121
        Height = 21
        TabOrder = 9
      end
      object Button16: TButton
        Left = 280
        Top = 408
        Width = 75
        Height = 25
        Caption = 'Sync'
        TabOrder = 10
        OnClick = Button16Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Uploads'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object SpeedButton8: TSpeedButton
        Left = 3
        Top = 20
        Width = 21
        Height = 22
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
        OnClick = SpeedButton8Click
      end
      object Label2: TLabel
        Left = 3
        Top = 48
        Width = 38
        Height = 13
        Caption = 'unfertig'
      end
      object Label3: TLabel
        Left = 183
        Top = 48
        Width = 51
        Height = 13
        Caption = 'vollst'#228'ndig'
      end
      object ListBox2: TListBox
        Left = 3
        Top = 64
        Width = 174
        Height = 401
        ItemHeight = 13
        TabOrder = 0
      end
      object ListBox7: TListBox
        Left = 183
        Top = 64
        Width = 178
        Height = 401
        ItemHeight = 13
        TabOrder = 1
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Jpegs'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        726
        481)
      object SpeedButton1: TSpeedButton
        Left = 1
        Top = 3
        Width = 21
        Height = 22
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
      object Image1: TImage
        Left = 196
        Top = 80
        Width = 527
        Height = 384
        Anchors = [akLeft, akTop, akRight, akBottom]
        Stretch = True
        ExplicitHeight = 385
      end
      object Label1: TLabel
        Left = 4
        Top = 30
        Width = 30
        Height = 13
        Caption = 'Maske'
      end
      object Edit4: TEdit
        Left = 28
        Top = 3
        Width = 162
        Height = 21
        TabOrder = 0
        Text = 'W:\swm-online\Fotos-0038\'
      end
      object ListBox3: TListBox
        Left = 3
        Top = 80
        Width = 186
        Height = 384
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        TabOrder = 1
        OnClick = ListBox3Click
        OnKeyDown = ListBox3KeyDown
      end
      object Edit5: TEdit
        Left = 44
        Top = 27
        Width = 146
        Height = 21
        TabOrder = 2
        Text = '*'
      end
      object ListBox4: TListBox
        Left = 196
        Top = 3
        Width = 527
        Height = 71
        ItemHeight = 13
        Items.Strings = (
          'F1 : Die Datei ist korrupt - sie muss nochmals '#252'bertragen werden'
          'F2 : Die Umbenennung muss nochmals durchgef'#252'hrt werden'
          'F3 : Dieses Bild ist nicht mehr notwendig, einfach l'#246'schen'
          'F4 : Dieses Bild zur "-Neu" umbenennung vormerken')
        TabOrder = 3
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Unverarbeitet'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object SpeedButton2: TSpeedButton
        Left = 24
        Top = 4
        Width = 21
        Height = 22
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
      object ListBox5: TListBox
        Left = 24
        Top = 32
        Width = 681
        Height = 257
        ItemHeight = 13
        TabOrder = 0
      end
      object Button2: TButton
        Left = 24
        Top = 312
        Width = 113
        Height = 25
        Caption = 'Anfordern'
        TabOrder = 1
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 143
        Top = 312
        Width = 130
        Height = 25
        Caption = 'Neu zuordnen'
        TabOrder = 2
        OnClick = Button3Click
      end
      object Button12: TButton
        Left = 144
        Top = 344
        Width = 129
        Height = 25
        Caption = 'Alle Neu zuordnen'
        TabOrder = 3
        OnClick = Button12Click
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Wartend'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        726
        481)
      object SpeedButton3: TSpeedButton
        Left = 24
        Top = 4
        Width = 21
        Height = 22
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
        OnClick = SpeedButton3Click
      end
      object ListBox6: TListBox
        Left = 24
        Top = 32
        Width = 689
        Height = 393
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 13
        TabOrder = 0
      end
      object Button6: TButton
        Left = 432
        Top = 453
        Width = 281
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Wartende mit Hilfe neuer Infos umbenennen'
        TabOrder = 1
        OnClick = Button6Click
      end
      object Button9: TButton
        Left = 24
        Top = 453
        Width = 225
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'markierten befreien'
        TabOrder = 2
        OnClick = Button9Click
      end
      object CheckBox3: TCheckBox
        Left = 433
        Top = 431
        Width = 280
        Height = 17
        Alignment = taLeftJustify
        Anchors = [akRight, akBottom]
        Caption = 'ZaehlerNummerNeu.xls.csv ber'#252'cksichtigen'
        TabOrder = 3
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Ablegen / Dienste'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label4: TLabel
        Left = 136
        Top = 256
        Width = 228
        Height = 13
        Caption = 'Einzelne Ablage, z.B. "stadtwerke-musterstadt"'
      end
      object Label5: TLabel
        Left = 136
        Top = 202
        Width = 251
        Height = 13
        Caption = 'Stichtag (normalerweise "heute"), z.B. "24.12.2012"'
      end
      object Label6: TLabel
        Left = 136
        Top = 344
        Width = 216
        Height = 13
        Caption = 'Einzelne Datei, z.B. "W:\mitgas\123.zip.html"'
      end
      object Button8: TButton
        Left = 136
        Top = 312
        Width = 209
        Height = 25
        Caption = 'Zips ablegen / Fotos ablegen'
        TabOrder = 0
        OnClick = Button8Click
      end
      object Button14: TButton
        Left = 136
        Top = 392
        Width = 209
        Height = 25
        Caption = '.zip.html -> .zip.html.pdf'
        TabOrder = 1
        OnClick = Button14Click
      end
      object Edit1: TEdit
        Left = 136
        Top = 368
        Width = 377
        Height = 21
        TabOrder = 2
      end
      object ProgressBar1: TProgressBar
        Left = 363
        Top = 395
        Width = 150
        Height = 17
        TabOrder = 3
      end
      object Edit2: TEdit
        Left = 136
        Top = 280
        Width = 228
        Height = 21
        TabOrder = 4
      end
      object Edit3: TEdit
        Left = 136
        Top = 221
        Width = 89
        Height = 21
        TabOrder = 5
      end
      object CheckBox4: TCheckBox
        Left = 136
        Top = 423
        Width = 65
        Height = 17
        Caption = 'Abbruch'
        TabOrder = 6
      end
      object Edit6: TEdit
        Left = 24
        Top = 392
        Width = 89
        Height = 21
        TabOrder = 7
        Text = 'W:\mitgas\'
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'PostgreSQL'
      ImageIndex = 6
      OnShow = TabSheet7Show
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label7: TLabel
        Left = 32
        Top = 24
        Width = 31
        Height = 13
        Caption = 'Label7'
      end
      object Button7: TButton
        Left = 587
        Top = 436
        Width = 75
        Height = 25
        Caption = 'Button7'
        TabOrder = 0
        OnClick = Button7Click
      end
      object ListBox8: TListBox
        Left = 32
        Top = 43
        Width = 630
        Height = 387
        ItemHeight = 13
        TabOrder = 1
      end
    end
    object TabSheet8: TTabSheet
      Caption = 'MemCached'
      ImageIndex = 7
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ListBox9: TListBox
        Left = 32
        Top = 48
        Width = 657
        Height = 337
        ItemHeight = 13
        TabOrder = 0
      end
      object Button15: TButton
        Left = 614
        Top = 400
        Width = 75
        Height = 25
        Caption = 'Button15'
        TabOrder = 1
        OnClick = Button15Click
      end
    end
  end
  object Timer1: TTimer
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 504
    Top = 8
  end
end
