object FormServiceFoto: TFormServiceFoto
  Left = 0
  Top = 0
  Caption = 'Foto.Service'
  ClientHeight = 621
  ClientWidth = 815
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel
    Left = 8
    Top = 12
    Width = 18
    Height = 13
    Caption = '--Id'
  end
  object Label17: TLabel
    Left = 8
    Top = 39
    Width = 22
    Height = 13
    Caption = 'Pfad'
  end
  object Label18: TLabel
    Left = 8
    Top = 72
    Width = 26
    Height = 13
    Caption = 'Timer'
  end
  object SpeedButton4: TSpeedButton
    Left = 48
    Top = 36
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
    OnClick = SpeedButton4Click
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 91
    Width = 815
    Height = 530
    ActivePage = TabSheet1
    Align = alBottom
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Mover'
      OnShow = TabSheet1Show
      object Label8: TLabel
        Left = 368
        Top = 385
        Width = 133
        Height = 13
        Caption = 'Arbeit beschr'#228'nken auf RID'
      end
      object ListBox1: TListBox
        Left = 3
        Top = 40
        Width = 574
        Height = 337
        ItemHeight = 13
        TabOrder = 0
      end
      object Button4: TButton
        Left = 608
        Top = 214
        Width = 129
        Height = 25
        Caption = 'workWartend'
        TabOrder = 1
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 608
        Top = 119
        Width = 129
        Height = 25
        Caption = 'workEingang_JPG'
        TabOrder = 2
        OnClick = Button5Click
      end
      object Button11: TButton
        Left = 158
        Top = 9
        Width = 162
        Height = 25
        Caption = 'Starte sofort!'
        TabOrder = 3
        OnClick = Button11Click
      end
      object Button13: TButton
        Left = 354
        Top = 439
        Width = 75
        Height = 25
        Caption = 'GEN_ID'
        TabOrder = 4
        OnClick = Button13Click
      end
      object Edit7: TEdit
        Left = 368
        Top = 404
        Width = 121
        Height = 21
        TabOrder = 5
      end
      object Button16: TButton
        Left = 608
        Top = 55
        Width = 75
        Height = 25
        Caption = 'Sync'
        TabOrder = 6
        OnClick = Button16Click
      end
      object Button29: TButton
        Left = 323
        Top = 9
        Width = 121
        Height = 25
        Caption = '5 Min rum!'
        TabOrder = 7
        OnClick = Button29Click
      end
      object Button1: TButton
        Left = 3
        Top = 9
        Width = 153
        Height = 25
        Caption = 'Start'
        TabOrder = 8
        OnClick = Button1Click
      end
      object Button36: TButton
        Left = 608
        Top = 168
        Width = 129
        Height = 25
        Caption = 'workEingang_TXT'
        TabOrder = 9
        OnClick = Button36Click
      end
      object CheckBox6: TCheckBox
        Left = 608
        Top = 96
        Width = 97
        Height = 17
        Caption = 'nur 1 JPG'
        TabOrder = 10
      end
      object Button10: TButton
        Left = 608
        Top = 256
        Width = 177
        Height = 25
        Caption = 'Ausstehende Fotos'
        TabOrder = 11
        OnClick = Button10Click
      end
    end
    object TabSheet11: TTabSheet
      Caption = 'Info'
      ImageIndex = 10
      object Button24: TButton
        Left = 48
        Top = 56
        Width = 193
        Height = 25
        Caption = 'Baustelle.csv'
        TabOrder = 0
        OnClick = Button24Click
      end
      object Button25: TButton
        Left = 48
        Top = 87
        Width = 193
        Height = 25
        Caption = 'Transaktionen Log'
        TabOrder = 1
        OnClick = Button25Click
      end
      object Button7: TButton
        Left = 48
        Top = 120
        Width = 193
        Height = 25
        Caption = 'senden.html'
        TabOrder = 2
        OnClick = Button7Click
      end
      object Button28: TButton
        Left = 48
        Top = 151
        Width = 193
        Height = 25
        Caption = 'vertrag.html'
        TabOrder = 3
        OnClick = Button28Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Uploads'
      ImageIndex = 1
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
      DesignSize = (
        807
        502)
      object SpeedButton1: TSpeedButton
        Left = 3
        Top = 76
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
        Left = 312
        Top = 104
        Width = 492
        Height = 381
        Anchors = [akLeft, akTop, akRight, akBottom]
        Stretch = True
      end
      object Label1: TLabel
        Left = 4
        Top = 51
        Width = 30
        Height = 13
        Caption = 'Maske'
      end
      object Label9: TLabel
        Left = 8
        Top = 8
        Width = 22
        Height = 13
        Caption = 'Pfad'
      end
      object Label32: TLabel
        Left = 8
        Top = 32
        Width = 33
        Height = 13
        Caption = 'Ablage'
      end
      object Edit4: TEdit
        Left = 68
        Top = 3
        Width = 162
        Height = 21
        TabOrder = 0
        Text = 'W:\swm-online\Fotos-0038\'
      end
      object ListBox3: TListBox
        Left = 3
        Top = 104
        Width = 303
        Height = 381
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        TabOrder = 1
        OnClick = ListBox3Click
        OnKeyDown = ListBox3KeyDown
      end
      object Edit5: TEdit
        Left = 68
        Top = 49
        Width = 146
        Height = 21
        TabOrder = 2
        Text = '*'
      end
      object ListBox4: TListBox
        Left = 312
        Top = 3
        Width = 411
        Height = 95
        ItemHeight = 13
        Items.Strings = (
          'F1 : Die Datei ist korrupt - sie muss nochmals '#252'bertragen werden'
          'F2 : Die Umbenennung muss nochmals durchgef'#252'hrt werden'
          'F3 : Dieses Bild ist nicht mehr notwendig, einfach l'#246'schen'
          'F4 : Dieses Bild zur "-Neu" umbenennung vormerken'
          'F5 : Dateigr'#246'sse des Bildes korrigieren'
          'F6 : Upload in den Sicherungen suchen, dann ins web kopieren')
        TabOrder = 3
      end
      object Button30: TButton
        Left = 68
        Top = 73
        Width = 75
        Height = 25
        Caption = 'Touch'
        TabOrder = 4
        OnClick = Button30Click
      end
      object Edit21: TEdit
        Left = 68
        Top = 26
        Width = 121
        Height = 21
        TabOrder = 5
        TextHint = 'stadtwerke-muster'
      end
      object CheckBox3: TCheckBox
        Left = 160
        Top = 80
        Width = 97
        Height = 17
        Caption = 'Foto anzeigen'
        Checked = True
        State = cbChecked
        TabOrder = 6
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Unverarbeitet'
      ImageIndex = 3
      object SpeedButton2: TSpeedButton
        Left = 29
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
      object Label10: TLabel
        Left = 56
        Top = 8
        Width = 6
        Height = 13
        Caption = '0'
      end
      object Label33: TLabel
        Left = 24
        Top = 472
        Width = 103
        Height = 13
        Caption = 'Anzahl der Log-Zeilen'
      end
      object ListBox5: TListBox
        Left = 24
        Top = 32
        Width = 681
        Height = 298
        ItemHeight = 13
        TabOrder = 0
        OnClick = ListBox5Click
      end
      object Button2: TButton
        Left = 24
        Top = 336
        Width = 113
        Height = 25
        Caption = 'Anfordern'
        TabOrder = 1
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 143
        Top = 336
        Width = 130
        Height = 25
        Caption = 'Neu zuordnen'
        TabOrder = 2
        OnClick = Button3Click
      end
      object Button12: TButton
        Left = 279
        Top = 336
        Width = 129
        Height = 25
        Caption = 'Alle Neu zuordnen'
        TabOrder = 3
        OnClick = Button12Click
      end
      object Button27: TButton
        Left = 630
        Top = 336
        Width = 75
        Height = 25
        Caption = 'Amnestie'
        TabOrder = 4
        OnClick = Button27Click
      end
      object Edit10: TEdit
        Left = 503
        Top = 336
        Width = 121
        Height = 21
        TabOrder = 5
        TextHint = 'Amnestiegrund-'
      end
      object Edit11: TEdit
        Left = 104
        Top = 3
        Width = 121
        Height = 21
        TabOrder = 6
        Text = 'Edit11'
      end
      object Memo1: TMemo
        Left = 24
        Top = 367
        Width = 681
        Height = 98
        Lines.Strings = (
          'Memo1')
        TabOrder = 7
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Wartend'
      ImageIndex = 4
      DesignSize = (
        807
        502)
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
      object Label19: TLabel
        Left = 56
        Top = 8
        Width = 6
        Height = 13
        Caption = '0'
      end
      object ListBox6: TListBox
        Left = 24
        Top = 32
        Width = 770
        Height = 414
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 13
        TabOrder = 0
      end
      object Button9: TButton
        Left = 24
        Top = 474
        Width = 225
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'markierten befreien'
        TabOrder = 1
        OnClick = Button9Click
      end
      object CheckBox2: TCheckBox
        Left = 24
        Top = 451
        Width = 233
        Height = 17
        Caption = 'Foto wieder neu einstellen'
        TabOrder = 2
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Ablegen / Dienste'
      ImageIndex = 5
      OnShow = TabSheet6Show
      object Label4: TLabel
        Left = 189
        Top = 256
        Width = 228
        Height = 13
        Caption = 'Einzelne Ablage, z.B. "stadtwerke-musterstadt"'
      end
      object Label5: TLabel
        Left = 189
        Top = 202
        Width = 251
        Height = 13
        Caption = 'Stichtag (normalerweise "heute"), z.B. "24.12.2012"'
      end
      object Label6: TLabel
        Left = 189
        Top = 373
        Width = 216
        Height = 13
        Caption = 'Einzelne Datei, z.B. "W:\mitgas\123.zip.html"'
      end
      object Label15: TLabel
        Left = 497
        Top = 317
        Width = 89
        Height = 13
        Caption = 'Zielgr'#246'sse [k Byte]'
      end
      object Label16: TLabel
        Left = 497
        Top = 344
        Width = 123
        Height = 13
        Caption = 'erlaubte Abweichung [%]'
      end
      object Button8: TButton
        Left = 189
        Top = 312
        Width = 209
        Height = 25
        Caption = 'Zips ablegen / Fotos ablegen'
        TabOrder = 0
        OnClick = Button8Click
      end
      object Button14: TButton
        Left = 189
        Top = 421
        Width = 209
        Height = 25
        Caption = '.zip.html -> .zip.html.pdf'
        TabOrder = 1
        OnClick = Button14Click
      end
      object Edit1: TEdit
        Left = 189
        Top = 397
        Width = 377
        Height = 21
        TabOrder = 2
      end
      object ProgressBar1: TProgressBar
        Left = 416
        Top = 424
        Width = 150
        Height = 17
        TabOrder = 3
      end
      object Edit2: TEdit
        Left = 189
        Top = 275
        Width = 228
        Height = 21
        TabOrder = 4
      end
      object Edit3: TEdit
        Left = 189
        Top = 221
        Width = 89
        Height = 21
        TabOrder = 5
      end
      object CheckBox4: TCheckBox
        Left = 189
        Top = 452
        Width = 65
        Height = 17
        Caption = 'Abbruch'
        TabOrder = 6
      end
      object Edit6: TEdit
        Left = 24
        Top = 421
        Width = 159
        Height = 21
        TabOrder = 7
        Text = 'Y:\#172\Fotos\'
      end
      object ListBox10: TListBox
        Left = 24
        Top = 20
        Width = 753
        Height = 176
        ItemHeight = 13
        TabOrder = 8
      end
      object Edit12: TEdit
        Left = 628
        Top = 314
        Width = 50
        Height = 21
        TabOrder = 9
        Text = '100'
      end
      object Edit13: TEdit
        Left = 628
        Top = 341
        Width = 50
        Height = 21
        TabOrder = 10
        Text = '10'
      end
      object Button6: TButton
        Left = 189
        Top = 342
        Width = 209
        Height = 25
        Caption = 'doBackup'
        TabOrder = 11
        OnClick = Button6Click
      end
      object Button35: TButton
        Left = 24
        Top = 448
        Width = 159
        Height = 25
        Caption = 'Dubletten l'#246'schen'
        TabOrder = 12
        OnClick = Button35Click
      end
      object Button37: TButton
        Left = 497
        Top = 251
        Width = 181
        Height = 25
        Caption = 'Abwickeln'
        TabOrder = 13
        OnClick = Button37Click
      end
    end
    object TabSheet8: TTabSheet
      Caption = 'Zip-Archive'
      ImageIndex = 7
      object Label34: TLabel
        Left = 13
        Top = 104
        Width = 48
        Height = 13
        Caption = 'Zip-Archiv'
      end
      object Edit22: TEdit
        Left = 68
        Top = 101
        Width = 257
        Height = 21
        TabOrder = 0
        TextHint = 'G:\Pfad\Dateiname.zip'
      end
      object Button15: TButton
        Left = 332
        Top = 99
        Width = 75
        Height = 25
        Caption = 'Unzip'
        TabOrder = 1
        OnClick = Button15Click
      end
      object Memo3: TMemo
        Left = 13
        Top = 6
        Width = 394
        Height = 89
        TabOrder = 2
      end
    end
    object TabSheet9: TTabSheet
      Caption = 'AUFTRAG+TS'
      ImageIndex = 8
      OnShow = TabSheet9Show
      object Label11: TLabel
        Left = 536
        Top = 384
        Width = 37
        Height = 13
        Caption = 'Label11'
      end
      object ListBox11: TListBox
        Left = 48
        Top = 104
        Width = 457
        Height = 257
        ItemHeight = 13
        TabOrder = 0
      end
      object Button18: TButton
        Left = 175
        Top = 75
        Width = 75
        Height = 25
        Caption = 'Suchen'
        TabOrder = 1
        OnClick = Button18Click
      end
      object Edit8: TEdit
        Left = 48
        Top = 77
        Width = 121
        Height = 21
        TabOrder = 2
        Text = 'AUFTRAG_R'
      end
      object Button19: TButton
        Left = 48
        Top = 377
        Width = 457
        Height = 25
        Caption = 'Als Alternative bereitstellen'
        TabOrder = 3
        OnClick = Button19Click
      end
      object Button20: TButton
        Left = 48
        Top = 408
        Width = 457
        Height = 25
        Caption = 'Alternative l'#246'schen!'
        TabOrder = 4
        OnClick = Button20Click
      end
      object Edit9: TEdit
        Left = 48
        Top = 48
        Width = 313
        Height = 21
        TabOrder = 5
      end
      object CheckBox5: TCheckBox
        Left = 56
        Top = 448
        Width = 97
        Height = 17
        Caption = 'Abbruch'
        TabOrder = 6
      end
    end
    object TabSheet10: TTabSheet
      Caption = 'Rollback'
      ImageIndex = 9
      object Label12: TLabel
        Left = 11
        Top = 16
        Width = 30
        Height = 13
        Caption = 'Quelle'
      end
      object Label13: TLabel
        Left = 11
        Top = 394
        Width = 95
        Height = 13
        Caption = 'Transaktionsauszug'
      end
      object Label14: TLabel
        Left = 11
        Top = 429
        Width = 43
        Height = 13
        Caption = 'Baustelle'
      end
      object Edit_Rollback_Quelle: TEdit
        Left = 47
        Top = 15
        Width = 250
        Height = 21
        TabOrder = 0
      end
      object Edit_RollBack_Transaktionen: TEdit
        Left = 145
        Top = 391
        Width = 249
        Height = 21
        TabOrder = 1
        Text = 'W:\JonDaServer\St'#246'rung\Rollback.txt'
      end
      object Button21: TButton
        Left = 416
        Top = 389
        Width = 307
        Height = 25
        Caption = 'Rollback anhand der Transaktion'
        TabOrder = 2
        OnClick = Button21Click
      end
      object ListBox12: TListBox
        Left = 3
        Top = 42
        Width = 720
        Height = 343
        ItemHeight = 13
        TabOrder = 3
      end
      object Edit_Rollback_Baustelle: TEdit
        Left = 145
        Top = 426
        Width = 249
        Height = 21
        TabOrder = 4
        Text = 'EnPara'
      end
      object Button26: TButton
        Left = 416
        Top = 424
        Width = 307
        Height = 25
        Caption = 'Rollback anhand der Baustellenzugeh'#246'rigkeit'
        TabOrder = 5
        OnClick = Button26Click
      end
      object Button31: TButton
        Left = 416
        Top = 456
        Width = 307
        Height = 25
        Caption = 'N-Bug Korrektur'
        TabOrder = 6
        OnClick = Button31Click
      end
      object CheckBox1: TCheckBox
        Left = 144
        Top = 460
        Width = 233
        Height = 17
        Caption = 'Korrektur wirklich durchf'#252'hren'
        TabOrder = 7
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'Wiederholen'
      ImageIndex = 11
      object Label20: TLabel
        Left = 13
        Top = 40
        Width = 145
        Height = 13
        Caption = 'Liste mit "Referenzidenditaet" '
      end
      object Label21: TLabel
        Left = 544
        Top = 40
        Width = 37
        Height = 13
        Hint = 'Anzahl der RIDs'
        Caption = 'Label21'
        ParentShowHint = False
        ShowHint = True
      end
      object Label22: TLabel
        Left = 544
        Top = 56
        Width = 37
        Height = 13
        Hint = 'Anzahl RIDs, DISTINCT'
        Caption = 'Label22'
        ParentShowHint = False
        ShowHint = True
      end
      object Label23: TLabel
        Left = 544
        Top = 75
        Width = 37
        Height = 13
        Hint = #220'brige RIDs'
        Caption = 'Label23'
        ParentShowHint = False
        ShowHint = True
      end
      object Sicherungsverzeichnisse: TLabel
        Left = 16
        Top = 200
        Width = 116
        Height = 13
        Caption = 'Sicherungsverzeichnisse'
      end
      object Label24: TLabel
        Left = 16
        Top = 320
        Width = 105
        Height = 13
        Caption = 'Sicherungsverzeichnis'
      end
      object Label25: TLabel
        Left = 16
        Top = 368
        Width = 33
        Height = 13
        Caption = 'Ablage'
      end
      object Label26: TLabel
        Left = 16
        Top = 411
        Width = 31
        Height = 13
        Caption = 'Datum'
      end
      object Label27: TLabel
        Left = 16
        Top = 457
        Width = 59
        Height = 13
        Caption = 'Bereitstellen'
      end
      object Label28: TLabel
        Left = 144
        Top = 368
        Width = 64
        Height = 13
        Caption = 'ZIP-Passwort'
      end
      object Label29: TLabel
        Left = 544
        Top = 216
        Width = 37
        Height = 13
        Caption = 'Label29'
      end
      object Label30: TLabel
        Left = 544
        Top = 232
        Width = 37
        Height = 13
        Caption = 'Label30'
      end
      object Label31: TLabel
        Left = 544
        Top = 248
        Width = 37
        Height = 13
        Caption = 'Label31'
      end
      object Edit14: TEdit
        Left = 164
        Top = 37
        Width = 258
        Height = 21
        TabOrder = 0
        Text = 'Z:\Kundendaten\sewa\Fotos\Fotos.xls.csv'
      end
      object Button23: TButton
        Left = 440
        Top = 35
        Width = 75
        Height = 25
        Caption = 'laden'
        TabOrder = 1
        OnClick = Button23Click
      end
      object Button32: TButton
        Left = 428
        Top = 217
        Width = 75
        Height = 25
        Caption = 'suchen'
        TabOrder = 2
        OnClick = Button32Click
      end
      object ListBox8: TListBox
        Left = 13
        Top = 82
        Width = 409
        Height = 97
        ItemHeight = 13
        TabOrder = 3
      end
      object Memo2: TMemo
        Left = 16
        Top = 219
        Width = 406
        Height = 89
        Lines.Strings = (
          'Z:\Datensicherung\SEWA\JonDaServer\#147\Fotos\')
        TabOrder = 4
      end
      object Button33: TButton
        Left = 428
        Top = 283
        Width = 75
        Height = 25
        Caption = 'Wiederholen'
        TabOrder = 5
        OnClick = Button33Click
      end
      object Button34: TButton
        Left = 420
        Top = 474
        Width = 75
        Height = 25
        Caption = 'Suchen'
        TabOrder = 6
        OnClick = Button34Click
      end
      object Edit16: TEdit
        Left = 16
        Top = 339
        Width = 398
        Height = 21
        TabOrder = 7
        Text = 'Z:\Datensicherung\SEWA\JonDaServer\'
      end
      object Edit17: TEdit
        Left = 16
        Top = 384
        Width = 121
        Height = 21
        TabOrder = 8
        Text = 'erdgas-suedwest'
      end
      object Edit18: TEdit
        Left = 16
        Top = 430
        Width = 121
        Height = 21
        TabOrder = 9
        Text = '05.07.2016'
      end
      object ListBox13: TListBox
        Left = 512
        Top = 339
        Width = 273
        Height = 137
        ItemHeight = 13
        TabOrder = 10
      end
      object Edit19: TEdit
        Left = 16
        Top = 478
        Width = 398
        Height = 21
        TabOrder = 11
        Text = 'Z:\Datensicherung\SEWA\Anfrage\'
      end
      object Edit20: TEdit
        Left = 144
        Top = 384
        Width = 121
        Height = 21
        PasswordChar = '*'
        TabOrder = 12
        Text = 'Edit20'
      end
      object ProgressBar2: TProgressBar
        Left = 512
        Top = 482
        Width = 273
        Height = 17
        TabOrder = 13
      end
    end
    object TabSheet12: TTabSheet
      Caption = 'Verzeichnisse'
      ImageIndex = 11
      object Label35: TLabel
        Left = 24
        Top = 32
        Width = 186
        Height = 13
        Caption = 'Hauptverzeichnis aller Internetablagen'
      end
      object Label36: TLabel
        Left = 24
        Top = 86
        Width = 204
        Height = 13
        Caption = 'neues Unterverzeichnis (bitte "\" am Ende)'
      end
      object Label37: TLabel
        Left = 24
        Top = 59
        Width = 83
        Height = 13
        Caption = 'Ablage (ohne "\")'
      end
      object Edit23: TEdit
        Left = 248
        Top = 29
        Width = 353
        Height = 21
        Enabled = False
        TabOrder = 0
      end
      object Edit24: TEdit
        Left = 248
        Top = 83
        Width = 353
        Height = 21
        Hint = 'Name des Unterverzeichnisses\'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TextHint = 'test\'
      end
      object Button38: TButton
        Left = 616
        Top = 81
        Width = 113
        Height = 25
        Caption = 'erstellen'
        TabOrder = 3
        OnClick = Button38Click
      end
      object Edit25: TEdit
        Left = 248
        Top = 56
        Width = 121
        Height = 21
        Hint = 'Verzeichnis der Ablage'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TextHint = 'sw-musterland'
      end
    end
  end
  object Edit15: TEdit
    Left = 72
    Top = 36
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object Button17: TButton
    Left = 216
    Top = 7
    Width = 153
    Height = 52
    Caption = 'Init'
    TabOrder = 2
    OnClick = Button17Click
  end
  object ComboBox1: TComboBox
    Left = 48
    Top = 9
    Width = 145
    Height = 21
    TabOrder = 3
    OnSelect = ComboBox1Select
  end
  object Panel1: TPanel
    Left = 48
    Top = 64
    Width = 114
    Height = 21
    BevelEdges = []
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clWindow
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 4
  end
  object Button22: TButton
    Left = 168
    Top = 63
    Width = 25
    Height = 22
    Hint = '<4'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Webdings'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = Button22Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 664
    Top = 24
  end
end
