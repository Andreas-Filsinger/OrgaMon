object FormBuchBarKasse: TFormBuchBarKasse
  Left = 0
  Top = 0
  Caption = 'Bar Kassenerl'#246'se'
  ClientHeight = 502
  ClientWidth = 360
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Verdana'
  Font.Style = [fsBold]
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 18
  object Label1: TLabel
    Left = 6
    Top = 14
    Width = 48
    Height = 18
    Caption = '&Name'
    FocusControl = Edit1
  end
  object Label2: TLabel
    Left = 6
    Top = 77
    Width = 65
    Height = 18
    Caption = 'Betr'#228'ge'
  end
  object Label3: TLabel
    Left = 6
    Top = 440
    Width = 28
    Height = 18
    Caption = '&Bar'
    FocusControl = Edit2
  end
  object Label4: TLabel
    Left = 6
    Top = 411
    Width = 63
    Height = 18
    Caption = 'Summe'
  end
  object Label5: TLabel
    Left = 6
    Top = 471
    Width = 74
    Height = 18
    Caption = 'R'#252'ckgeld'
  end
  object Label6: TLabel
    Left = 83
    Top = 57
    Width = 73
    Height = 16
    Caption = '0000 - Konto'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 83
    Top = 117
    Width = 73
    Height = 16
    Caption = '0000 - Konto'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 83
    Top = 177
    Width = 73
    Height = 16
    Caption = '0000 - Konto'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 83
    Top = 237
    Width = 73
    Height = 16
    Caption = '0000 - Konto'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label10: TLabel
    Left = 212
    Top = 76
    Width = 11
    Height = 18
    Caption = '&1'
    FocusControl = Edit3
  end
  object Label11: TLabel
    Left = 212
    Top = 140
    Width = 11
    Height = 18
    Caption = '&2'
    FocusControl = Edit4
  end
  object Label12: TLabel
    Left = 212
    Top = 201
    Width = 11
    Height = 18
    Caption = '&3'
    FocusControl = Edit5
  end
  object Label13: TLabel
    Left = 212
    Top = 256
    Width = 11
    Height = 18
    Caption = '&4'
    FocusControl = Edit6
  end
  object SpeedButton12: TSpeedButton
    Left = 6
    Top = 51
    Width = 23
    Height = 23
    Hint = 'Konten aktualisieren'
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
    ParentShowHint = False
    ShowHint = True
    OnClick = SpeedButton12Click
  end
  object Label14: TLabel
    Left = 83
    Top = 292
    Width = 73
    Height = 16
    Caption = '0000 - Konto'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label15: TLabel
    Left = 212
    Top = 312
    Width = 11
    Height = 18
    Caption = '&5'
    FocusControl = Edit7
  end
  object Label16: TLabel
    Left = 83
    Top = 348
    Width = 73
    Height = 16
    Caption = '0000 - Konto'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label17: TLabel
    Left = 212
    Top = 368
    Width = 11
    Height = 18
    Caption = '&6'
    FocusControl = Edit8
  end
  object SpeedButton1: TSpeedButton
    Left = 32
    Top = 51
    Width = 47
    Height = 23
    Hint = 'Kasse '#246'ffnen'
    Caption = '&S'
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000C40E0000C40E00000000000000000000F4F4F4D1D1D1
      CCCCCCCCCCCCCCCCCCD1D1D1F4F4F4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFB2C5D25AB0E74DABE94EABE951ACE95EB1E7B3C6D2FF
      FFFFFFFFFFF6F6F6D1D1D1CCCCCCCCCCCCCCCCCCD1D1D1F4F4F44FADEA9EE3F7
      BCFBFF95F0FF6AE8FF51CBF854AEEACCCCCCCCCCCCB5C6D15BB0E74DABE94EAB
      E951ACE95EB1E7B2C6D24EACEA8FD1F2A5D2F483C1EF66B3EC52B6EE52ADEA51
      ADEA51ACEA4EABEA9EE2F7BCFBFF95F0FF6AE8FF51CBF854AEEA4EACEA95DBF6
      AFF0FD88E6FD5FDEFF47C4F657B0EA9BF4FF6AE9FF4CADEA8FD0F2A5D2F483C1
      EF66B3EC52B6EE54AEEA4EACEA8DCEF2A5D2F483C1EF66B4EC4EB3EE4FABE987
      C3EF66B4EC4BA9E995DBF6AFF0FD88E6FD5FDEFF47C5F754AEEA4EACEA95DBF6
      AFF0FD88E6FD5FDEFF47C5F656AFEA8FEBFE5FDFFF4AACEA8DCDF2A5D2F384C1
      EF66B3EC4EB3EE54AEEA4EACEA8ECDF2A5D2F384C1EF66B3EC4EB3EE50ABE988
      C4EF67B5EC4DA9E998DAF5B4EFFC8BE4FC60DBFE47C3F654ADEA4FACEA99DAF6
      B4EFFC8BE4FC60DBFE47C2F550AAE98AE6FD60DFFF4FA8E861E1FC58DEFE5ADD
      FD5DDFFE58E0FF53ACE951ABEA62E1FC58DEFE5ADDFD5DDFFE57DFFE4FA9E888
      C3EF67B4EC50A9E973E5F778EBF878EAF879EBF869E4FA53ADEA52ADEA73E6F8
      78EBF878EAF878EBF866E2FA4BA8E889E5FC60DEFF47C4F757B2EA51ABE951AB
      E952ABE960BAEFDAEDFAD9EDFA67BBEE51ABEA51AAE94FA9E956B3EE92C9F188
      C3EF67B3EC4EB3EE54AEEAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF50ACEA9BDBF6B7F0FD8CE5FC60DBFE47C3F654ADEAFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF51ACEA62E1FC59DEFE5A
      DDFD5DDFFE58E0FF53ACE9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF52ADEA73E6F878EBF878EAF879EBF869E4FA53ADEAFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD9EDFA67BBEE51ABEA51
      ABE952ABE960BAEFDAEDFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    ParentShowHint = False
    ShowHint = True
    OnClick = SpeedButton1Click
  end
  object Edit1: TEdit
    Left = 83
    Top = 11
    Width = 266
    Height = 26
    TabOrder = 0
    OnKeyPress = Edit1KeyPress
  end
  object StaticText1: TStaticText
    Left = 83
    Top = 410
    Width = 121
    Height = 21
    Alignment = taRightJustify
    AutoSize = False
    BevelInner = bvNone
    BorderStyle = sbsSunken
    Caption = '0,00 '#8364' '
    TabOrder = 10
  end
  object Edit2: TEdit
    Left = 83
    Top = 437
    Width = 121
    Height = 26
    TabOrder = 7
    OnKeyPress = Edit2KeyPress
  end
  object StaticText2: TStaticText
    Left = 83
    Top = 471
    Width = 121
    Height = 22
    Alignment = taRightJustify
    AutoSize = False
    BevelInner = bvNone
    BorderStyle = sbsSunken
    Caption = '0,00 '#8364' '
    TabOrder = 11
  end
  object StaticText3: TStaticText
    Left = 83
    Top = 75
    Width = 121
    Height = 22
    Alignment = taRightJustify
    AutoSize = False
    BevelInner = bvNone
    BorderStyle = sbsSunken
    Caption = '0,00 '#8364' '
    TabOrder = 12
  end
  object Edit3: TEdit
    Left = 228
    Top = 73
    Width = 121
    Height = 26
    TabOrder = 1
    OnKeyPress = Edit3KeyPress
  end
  object Edit4: TEdit
    Left = 228
    Top = 137
    Width = 121
    Height = 26
    TabOrder = 2
    OnKeyPress = Edit4KeyPress
  end
  object Edit5: TEdit
    Left = 228
    Top = 195
    Width = 121
    Height = 26
    TabOrder = 3
    OnKeyPress = Edit5KeyPress
  end
  object Edit6: TEdit
    Left = 228
    Top = 253
    Width = 121
    Height = 26
    TabOrder = 4
    OnKeyPress = Edit6KeyPress
  end
  object StaticText4: TStaticText
    Left = 83
    Top = 137
    Width = 121
    Height = 22
    Alignment = taRightJustify
    AutoSize = False
    BevelInner = bvNone
    BorderStyle = sbsSunken
    Caption = '0,00 '#8364' '
    TabOrder = 13
  end
  object StaticText5: TStaticText
    Left = 83
    Top = 198
    Width = 121
    Height = 22
    Alignment = taRightJustify
    AutoSize = False
    BevelInner = bvNone
    BorderStyle = sbsSunken
    Caption = '0,00 '#8364' '
    TabOrder = 14
  end
  object StaticText6: TStaticText
    Left = 83
    Top = 255
    Width = 121
    Height = 21
    Alignment = taRightJustify
    AutoSize = False
    BevelInner = bvNone
    BorderStyle = sbsSunken
    Caption = '0,00 '#8364' '
    TabOrder = 15
  end
  object Panel1: TPanel
    Left = 83
    Top = 50
    Width = 266
    Height = 1
    Color = clBtnText
    ParentBackground = False
    TabOrder = 16
  end
  object Panel2: TPanel
    Left = 83
    Top = 105
    Width = 266
    Height = 0
    Color = clBtnText
    ParentBackground = False
    TabOrder = 17
  end
  object Panel3: TPanel
    Left = 83
    Top = 169
    Width = 266
    Height = 1
    Color = clBtnText
    ParentBackground = False
    TabOrder = 18
  end
  object Panel4: TPanel
    Left = 83
    Top = 230
    Width = 266
    Height = 0
    Color = clBtnText
    ParentBackground = False
    TabOrder = 19
  end
  object Button1: TButton
    Left = 228
    Top = 437
    Width = 121
    Height = 56
    Caption = '*'
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clWindowText
    Font.Height = -53
    Font.Name = 'Wingdings'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 228
    Top = 410
    Width = 121
    Height = 25
    Cancel = True
    Caption = 'abbrechen'
    TabOrder = 9
    OnClick = Button2Click
  end
  object Edit7: TEdit
    Left = 228
    Top = 309
    Width = 121
    Height = 26
    TabOrder = 5
    OnKeyPress = Edit7KeyPress
  end
  object StaticText7: TStaticText
    Left = 83
    Top = 310
    Width = 121
    Height = 22
    Alignment = taRightJustify
    AutoSize = False
    BevelInner = bvNone
    BorderStyle = sbsSunken
    Caption = '0,00 '#8364' '
    TabOrder = 20
  end
  object Panel5: TPanel
    Left = 83
    Top = 285
    Width = 266
    Height = 0
    Color = clBtnText
    ParentBackground = False
    TabOrder = 21
  end
  object Panel6: TPanel
    Left = 83
    Top = 400
    Width = 266
    Height = 1
    Color = clBtnText
    ParentBackground = False
    TabOrder = 22
  end
  object Edit8: TEdit
    Left = 228
    Top = 365
    Width = 121
    Height = 26
    TabOrder = 6
    OnKeyPress = Edit8KeyPress
  end
  object StaticText8: TStaticText
    Left = 83
    Top = 366
    Width = 121
    Height = 22
    Alignment = taRightJustify
    AutoSize = False
    BevelInner = bvNone
    BorderStyle = sbsSunken
    Caption = '0,00 '#8364' '
    TabOrder = 23
  end
  object Panel7: TPanel
    Left = 83
    Top = 341
    Width = 266
    Height = 1
    Color = clBtnText
    ParentBackground = False
    TabOrder = 24
  end
end
