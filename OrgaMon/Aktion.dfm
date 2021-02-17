object FormAktion: TFormAktion
  Left = 205
  Top = 173
  Caption = 'Aktion'
  ClientHeight = 424
  ClientWidth = 789
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 17
  object Panel1: TPanel
    Left = 4
    Top = 1
    Width = 775
    Height = 54
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 0
    object SpeedButton13: TSpeedButton
      Left = 732
      Top = 13
      Width = 29
      Height = 29
      Hint = '... im Contextfenster'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000904213E76F15
        EC5D00EA6B200404040606060000000000000101010101010101010101010101
        01010101010101010101AB4E1DFF9A3EFF872BFF9750040C0BEFFAF8F8FFFFF6
        FEFDFFF6FFFFFAFFFFF4FCFFF9FEF8FAFBF8FFFFF3FFFE000400A73E0DFE9437
        FF761CFF8441040C0BEFFAF8F8FFFFF6FEFDFFF6FFFFFAFFFFF4FCFFF9FEF8FA
        FBF8FFFFF3FFFE000400BD4C1AFF9B3EFF6C14FB79380F090AFFFEFFF6F1F2FF
        FEFFF3FBFFF8FEFFF9FCFFFFFDFFFFFDFFFEF3F5FFFAFA0B0000BD4C1AFF9B3E
        FF6C14FB7938090000FBF6F7FBFFFFF4FFFDFFF6FAFFF6F9FEF9FBFDFFFFF8FF
        FFF4FFFFEDFBF9000604904213E76F15EC5D00EA6B201A1F1EC3B2B522000035
        00072300002001001400001A0D0B0900000B00002A191D120001AB4E1DFF9A3E
        FF872BFF9750070000F1C7CE54020F62000981030F6500034F0108250000FFFD
        FEF8FFFFDDF2F0000704A73E0DFE9437FF761CFF8441000505CCABAF91000C74
        10105300008C06068102042B0000F5FFF8000200FFFEFF000103BD4C1AFF9B3E
        FF6C14FB793806FFF1A8E2E1EDADB99EB3ABEDC2B9640F0D4B00001D0400F1FF
        FCEFF5F4FFFDFF111216B4633ED57B420E000B09FFFB1AFDEE20E8D700060E10
        030B000300E3C7C61E00000B0C080004000E16150900000B0001EAAD85E15520
        B35208A42C0035FFFE883E008B4400D95827B03F01A54300884D00B03C008535
        00D95827B03F01A54300F7C09BEDA3618B3F00FF825F0E0003E87B47835700D8
        9C66A04F12EB9059FF996FE4804A9E5C29D89C66A04F12EB9059D2B28E96863A
        FF7C51F7D5BDF8D1C3DFB786FF6D2BB05829FA774BFFD8AEFFE4C7E9C082F54D
        2EB05829FA774BFFD8AEFFCCB3A17F3DEE9465DBFFE0FEDBD1FFEAB7DE7826C5
        7245DB9964F9FFD3D2D4C0FFEEACFF5531C57245DB9964F9FFD3E0D7BCEEAC7B
        B95323FFDBBFFCE6C3DCB07BBF5911FFFFFFB3602CFFCDA0FFFCE1F59E5EB37C
        43FFFFFFB3602CFFCDA0FFFFFFFFFFFFFFFFFFBA551EB349148E2D00FFFFFFFF
        FFFFFFFFFF975A169F390877520EFFFFFFFFFFFFFFFFFF975A16}
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton13Click
    end
    object IB_NavigationBar1: TIB_NavigationBar
      Left = 10
      Top = 10
      Width = 156
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Flat = False
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      DataSource = IB_DataSource1
      ReceiveFocus = False
      CustomGlyphsSupplied = []
    end
    object IB_UpdateBar1: TIB_UpdateBar
      Left = 167
      Top = 10
      Width = 246
      Height = 33
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Flat = False
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      DataSource = IB_DataSource1
      ReceiveFocus = False
      CustomGlyphsSupplied = []
      VisibleButtons = [ubEdit, ubInsert, ubDelete, ubPost, ubCancel, ubRefreshAll]
    end
    object Button7: TButton
      Left = 701
      Top = 13
      Width = 29
      Height = 29
      Hint = 'Springe zum Artikel, der unten markiert ist'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '&A'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = Button7Click
    end
  end
  object IB_Grid1: TIB_Grid
    Left = 4
    Top = 55
    Width = 775
    Height = 158
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    TabOrder = 1
    DefaultRowHeight = 22
  end
  object IB_Memo1: TIB_Memo
    Left = 4
    Top = 213
    Width = 775
    Height = 186
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    DataField = 'INTERN'
    DataSource = IB_DataSource1
    TabOrder = 2
    AutoSize = False
  end
  object IB_Query1: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED'
      'BILD=BOOLEAN=Y,N'
      'WEBSHOP=BOOLEAN=Y,N')
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'SELECT '
      ' *'
      'FROM'
      ' AKTION'
      'ORDER BY RID'
      'FOR UPDATE')
    ColorScheme = True
    KeyLinks.Strings = (
      'AKTION.RID')
    RequestLive = True
    Left = 40
    Top = 120
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 120
    Top = 120
  end
end
