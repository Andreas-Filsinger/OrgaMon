object FormAudit: TFormAudit
  Left = 0
  Top = 0
  Caption = 'Audit'
  ClientHeight = 245
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 52
    Height = 13
    Caption = 'Meldungen'
  end
  object Label2: TLabel
    Left = 253
    Top = 196
    Width = 32
    Height = 13
    Caption = 'Thema'
  end
  object SpeedButton1: TSpeedButton
    Left = 433
    Top = 12
    Width = 22
    Height = 22
    Hint = 'Verzeichnis des aktuellen Benutzers '#246'ffnen'
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000C30E0000C30E00000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFFFFFFFF
      9B52009B52009B52009B52009B52009B52009B52009B52009B52009B52009B52
      009B5200000000000000FFFFFFFFFFFF9B5200FFFFFFFBFF9EFFD19EFBFF9EFF
      D19EFBFF9EFBFF9EFBFF9EFBFF9ECE9C639B5200000000000000FFFFFF9B5200
      FFFFFFFFD19EFFD19EFBFF9EFFD19EFBFF9EFFD19EFBFF9EFBFF9EFBFF9ECE9C
      630000009B5200000000FFFFFF9B5200FFFFFFFFD19EFFD19EFFD19EFFD19EFF
      D19EFBFF9EFFD19EFBFF9EFBFF9E9B52000000009B52000000009B5200FFFFFF
      FFD19EFFD19EFFD19EFFD19EFBFF9EFFD19EFFD19EFBFF9EFFD19ECE9C630000
      00CE9C63CE9C630000009B5200FFFFFFFFD19EFFD19EFFD19EFFD19EFFD19EFF
      D19EFBFF9EFFD19EFBFF9ECE9C63000000CE9C63CE9C630000009B52009B5200
      9B52009B52009B52009B52009B52009B52009B52009B52009B52009B5200CE9C
      63FFD19ECE9C63000000FFFFFF9B5200FFFFFFFFD19EFFD19EFFD19EFFD19EFF
      D19EFFD19EFFD19EFFD19EFFD19EFFD19EFFD19ECE9C63000000FFFFFF9B5200
      FFFFFFFFD19EFFD19EFFD19EFFD19EFFD19EFFD19EFFD19EFFFFFFFFFFFFFFFF
      FFFFFFFFCE9C63000000FFFFFF9B5200FFFFFFFFD19EFFD19EFFD19EFFD19EFF
      D19EFFFFFF9B52009B52009B52009B52009B52009B5200FFFFFFFFFFFFFFFFFF
      9B5200FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9B5200FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9B52009B52009B52009B52009B
      5200FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    ParentShowHint = False
    ShowHint = True
    OnClick = SpeedButton1Click
  end
  object Image2: TImage
    Left = 465
    Top = 12
    Width = 54
    Height = 22
    Cursor = crHandPoint
    AutoSize = True
    Picture.Data = {
      07544269746D61704E0E0000424D4E0E00000000000036000000280000003600
      0000160000000100180000000000180E0000C40E0000C40E0000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFF0000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000FFFFFF0000FFFFFF000000ECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECEC000000FFFFFF0000FFFFFF000000ECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECEC000000FFFFFF0000FFFFFF000000ECECECECECECECEC
      ECECECECECECECECECECDFDFDFB1B1B10902040802030802030A0204BEBEBEE6
      E6E6ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECEC000000FFFFFF0000FFFFFF000000ECECECEC
      ECECECECECECECECECECECB2B2B2050402110C06613E1A8B582D7B4C23482A11
      0D0803070503CDCDCDECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECEC000000FFFFFF0000FFFFFF000000
      ECECECECECECECECECECECECAFAFAF0F0B05734A25BA7D37C5813DD09671C596
      71AF6D328A51213B210F0E0905CDCDCDECECECECECECECECECECECECECECECEC
      ECEC000000ECECECECECECECECECECECECECECEC000000ECECECECECEC000000
      ECECECECECEC000000ECECECECECEC000000ECECECECECECECECEC0000000000
      00000000ECECECECECECECECECECECECECECECECECEC000000FFFFFF0000FFFF
      FF000000ECECECECECECECECECD3D3D30605047C5C34D79451DA8C47D08C5CDA
      B6A6DAAB9BBB773DB06D329E5D263B210F070503E6E6E6ECECECECECECECECEC
      ECECECECECEC000000ECECECECECECECECECECECECECECEC000000ECECECECEC
      EC000000ECECECECECEC000000ECECECECECEC000000ECECECECECEC000000EC
      ECECECECECECECEC000000ECECECECECECECECECECECECECECEC000000FFFFFF
      0000FFFFFF000000ECECECECECECECECEC9191911A140DD8A261DAA15CDA9652
      D08C5CD08C71D08C5CBB7732B07732B06D328A51210D0803BEBEBEECECECECEC
      ECECECECECECECECECEC000000ECECECECECECECECECECECECECECEC000000EC
      ECECECECEC000000ECECECECECEC000000ECECECECECEC000000ECECECECECEC
      000000ECECECECECECECECECECECECECECECECECECECECECECECECECECEC0000
      00FFFFFF0000FFFFFF000000ECECECECECECE5E5E5060402957D57E5B67CE5AB
      67DAA15CD09667DAB6B0E5B691C58147BB7732B07732AF6D32482A11090204EC
      ECECECECECECECECECECECECECEC000000ECECECECECECECECECECECECECECEC
      000000ECECECECECEC000000ECECECECECEC000000ECECECECECEC000000ECEC
      ECECECEC000000000000000000000000000000ECECECECECECECECECECECECEC
      ECEC000000FFFFFF0000FFFFFF000000ECECECECECECCDCDCD040302D0B17EE5
      C086E5B67CE5AB67DAA171DAC0A6EFD5D0DAA171C5813DBB7732B077327B4C23
      050102E5E5E5ECECECECECECECECECECECEC000000ECECECECECECECECECECEC
      ECECECEC000000ECECECECECEC000000ECECECECECEC000000ECECECECECEC00
      0000ECECECECECEC000000ECECECECECECECECEC000000ECECECECECECECECEC
      ECECECECECEC000000FFFFFF0000FFFFFF000000ECECECECECECC7C7C7040304
      D8B78CEFCB91E5C086E5B67CDAAB67DAA171E5C0B0EFCBC5DA8C67C5813DBB77
      32825825050102E2E2E2ECECECECECECECECECECECEC00000000000000000000
      0000000000000000000000ECECECECECEC000000ECECECECECEC000000ECECEC
      ECECEC000000ECECECECECEC000000ECECECECECECECECEC000000ECECECECEC
      ECECECECECECECECECEC000000FFFFFF0000FFFFFF000000ECECECECECECE0E0
      E0050305AE9B80EFCB9BE5B691E5B686E5B691DAAB67DAA171EFD5DADAA191D0
      8147C5813D613E1A080203ECECECECECECECECECECECECECECEC000000ECECEC
      ECECECECECECECECECECECEC000000ECECECECECEC000000ECECECECECEC0000
      00ECECEC000000000000000000ECECECECECEC000000000000000000ECECECEC
      ECECECECECECECECECECECECECEC000000FFFFFF0000FFFFFF000000ECECECEC
      ECECECECEC7D7D7D231E1CE9D0ACEFCB9BEFCBB0EFE0E5EFCBB0E5C0B0FAEAEF
      E5B691DA8C47BA7D37110C06ADADADECECECECECECECECECECECECECECEC0000
      00ECECECECECECECECECECECECECECEC000000ECECECECECECECECECECECECEC
      ECEC000000ECECECECECEC000000ECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECEC000000FFFFFF0000FFFFFF000000
      ECECECECECECECECECC4C4C4070405B19F85EFD5B0EFD5B0EFD5C5EFE0E5EFE0
      E5EFCBB0E5AB67D79451734A25050402DFDFDFECECECECECECECECECECECECEC
      ECEC000000ECECECECECECECECECECECECECECEC000000ECECECECECECECECEC
      ECECECECECEC000000ECECECECECEC000000ECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECEC000000FFFFFF0000FFFF
      FF000000ECECECECECECECECECEBEBEB8C8C8C110E0DB7A489EBD2ADEFD5B0EF
      CB9BEFCB9BE5B686DCA463805F360F0B05B2B2B2ECECECECECECECECECECECEC
      ECECECECECEC000000ECECECECECECECECECECECECECECEC000000ECECECECEC
      EC000000ECECECECECEC000000ECECECECECECECECEC000000000000ECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECEC000000FFFFFF
      0000FFFFFF000000ECECECECECECECECECECECECE9E9E98C8C8C080505241F1D
      B4A085E2C092DDBC86977E581C150E070604AFAFAFECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC0000
      00FFFFFF0000FFFFFF000000ECECECECECECECECECECECECECECECEBEBEBC4C4
      C47D7D7D050405050405050402060402919191D3D3D3ECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECEC000000FFFFFF0000FFFFFF000000ECECECECECECECECECECECECECECECEC
      ECECECECECECECECE0E0E0C7C7C7CDCDCDE5E5E5ECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECEC000000FFFFFF0000FFFFFF000000ECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
      ECECECECECECECECECEC000000FFFFFF0000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000FFFFFF0000FFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
    OnClick = Image2Click
  end
  object ListBox1: TListBox
    Left = 16
    Top = 40
    Width = 503
    Height = 145
    ItemHeight = 13
    TabOrder = 0
  end
  object ProgressBar1: TProgressBar
    Left = 16
    Top = 193
    Width = 233
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 444
    Top = 191
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 2
    OnClick = Button1Click
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 220
    Width = 97
    Height = 17
    Caption = 'Abbruch'
    TabOrder = 3
  end
  object ComboBox1: TComboBox
    Left = 291
    Top = 193
    Width = 146
    Height = 21
    TabOrder = 4
    Items.Strings = (
      'DLA (RWE)'
      'Auftragsnummer (enBW)')
  end
end
