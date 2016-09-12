object FormOLAPArbeitsplatz: TFormOLAPArbeitsplatz
  Left = 93
  Top = 192
  Caption = 'OLAP Arbeitsplatz'
  ClientHeight = 651
  ClientWidth = 987
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 11
    Top = 332
    Width = 82
    Height = 14
    Caption = 'Abfragevorlage'
  end
  object SpeedButton3: TSpeedButton
    Left = 433
    Top = 329
    Width = 20
    Height = 21
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
  object Label21: TLabel
    Left = 632
    Top = 333
    Width = 73
    Height = 14
    Caption = 'XLS - Vorlage'
  end
  object SpeedButton2: TSpeedButton
    Left = 956
    Top = 329
    Width = 20
    Height = 21
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
  object DrawGrid1: TDrawGrid
    Left = 4
    Top = 63
    Width = 973
    Height = 250
    ColCount = 4
    Ctl3D = False
    DefaultColWidth = 130
    DefaultRowHeight = 26
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 45
    FixedRows = 0
    GridLineWidth = 0
    Options = [goRowSelect, goThumbTracking]
    ParentCtl3D = False
    ScrollBars = ssVertical
    TabOrder = 0
    OnDrawCell = DrawGrid1DrawCell
    ColWidths = (
      130
      130
      130
      130)
    RowHeights = (
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26
      26)
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 987
    Height = 29
    Caption = 'ToolBar1'
    Flat = False
    Images = ImageList1
    TabOrder = 1
    object ToolButton1: TToolButton
      Left = 0
      Top = 0
      Width = 6
      Caption = 'ToolButton1'
      ImageIndex = 63
      Style = tbsSeparator
    end
    object ComboBox3: TComboBox
      Left = 6
      Top = 0
      Width = 81
      Height = 22
      Style = csDropDownList
      TabOrder = 1
      OnSelect = ComboBox3Select
    end
    object ToolButton40: TToolButton
      Left = 87
      Top = 0
      Width = 21
      Caption = 'ToolButton40'
      ImageIndex = 56
      Style = tbsSeparator
    end
    object ToolButton25: TToolButton
      Left = 108
      Top = 0
      Hint = 'Questionaire starten'
      Caption = 'ToolButton25'
      ImageIndex = 1
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton25Click
    end
    object ToolButton3: TToolButton
      Left = 131
      Top = 0
      Hint = 'SQL Diagnose'
      Caption = 'ToolButton3'
      ImageIndex = 41
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton3Click
    end
    object ToolButton27: TToolButton
      Left = 154
      Top = 0
      Hint = 'Ergebnisliste anzeigen'
      Caption = 'ToolButton27'
      ImageIndex = 59
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton27Click
    end
    object ToolButton8: TToolButton
      Left = 177
      Top = 0
      Width = 47
      Caption = 'ToolButton8'
      ImageIndex = 5
      Style = tbsSeparator
    end
    object ToolButton7: TToolButton
      Left = 224
      Top = 0
      Hint = 'Alles markieren, demarkieren'
      Caption = 'ToolButton7'
      ImageIndex = 36
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton7Click
    end
    object ToolButton9: TToolButton
      Left = 247
      Top = 0
      Hint = 'Markierung umkehren'
      Caption = 'ToolButton9'
      ImageIndex = 37
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton9Click
    end
    object ToolButton10: TToolButton
      Left = 270
      Top = 0
      Hint = 'Nur noch die markierten anzeigen'
      Caption = 'ToolButton10'
      ImageIndex = 35
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton10Click
    end
    object ToolButton5: TToolButton
      Left = 293
      Top = 0
      Hint = 'Nicht mehr markieren'
      Caption = 'ToolButton5'
      ImageIndex = 38
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton5Click
    end
    object ToolButton33: TToolButton
      Left = 316
      Top = 0
      Hint = 'Markierte als Sonderterminliste ausgeben'
      Caption = 'ToolButton33'
      ImageIndex = 93
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton33Click
    end
    object ToolButton38: TToolButton
      Left = 339
      Top = 0
      Hint = 'Alle markierten l'#246'schen'
      Caption = 'ToolButton38'
      ImageIndex = 58
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton2: TToolButton
      Left = 362
      Top = 0
      Hint = 'Alle Markierten ablegen'
      Caption = 'ToolButton2'
      ImageIndex = 68
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton32: TToolButton
      Left = 385
      Top = 0
      Hint = 'letze '#196'nderung auf alle markierten anwenden'
      Caption = 'ToolButton32'
      ImageIndex = 54
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton13: TToolButton
      Left = 408
      Top = 0
      Width = 8
      Caption = 'ToolButton13'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object ToolButton12: TToolButton
      Left = 416
      Top = 0
      Hint = 'Zeige m'#246'gliche Werte an'
      Caption = 'ToolButton12'
      ImageIndex = 39
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton12Click
    end
    object ToolButton16: TToolButton
      Left = 439
      Top = 0
      Hint = #220'bernehme m'#246'gliche Werte'
      Caption = 'ToolButton16'
      ImageIndex = 8
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton16Click
    end
    object ToolButton18: TToolButton
      Left = 462
      Top = 0
      Width = 8
      Caption = 'ToolButton18'
      ImageIndex = 21
      Style = tbsSeparator
    end
    object ToolButton31: TToolButton
      Left = 470
      Top = 0
      Hint = 'Zeige Historische Datens'#228'tze'
      Caption = 'ToolButton31'
      ImageIndex = 47
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton23: TToolButton
      Left = 493
      Top = 0
      Hint = 'Markiere alle, die ge'#228'ndert wurden'
      Caption = 'ToolButton23'
      ImageIndex = 51
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton34: TToolButton
      Left = 516
      Top = 0
      Width = 8
      Caption = 'ToolButton34'
      ImageIndex = 56
      Style = tbsSeparator
    end
    object ToolButton26: TToolButton
      Left = 524
      Top = 0
      Hint = 'Doppelte oder fehlende Seriennummern'
      Caption = 'ToolButton26'
      ImageIndex = 52
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton26Click
    end
    object ToolButton35: TToolButton
      Left = 547
      Top = 0
      Hint = 'Anzahl der Messpunkte pr'#252'fen'
      Caption = 'ToolButton35'
      ImageIndex = 82
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton35Click
    end
    object ToolButton6: TToolButton
      Left = 570
      Top = 0
      Hint = 'Datenausgabe in Internet-Ablagen im XLS Format'
      Caption = 'ToolButton6'
      ImageIndex = 81
      OnClick = ToolButton6Click
    end
    object ToolButton29: TToolButton
      Left = 593
      Top = 0
      Hint = 'WIENGAS Export'
      Caption = 'ToolButton29'
      ImageIndex = 97
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton29Click
    end
    object ToolButton21: TToolButton
      Left = 616
      Top = 0
      Hint = 'Helium Daten einlesen'
      Caption = 'ToolButton21'
      ImageIndex = 40
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton21Click
    end
    object ToolButton36: TToolButton
      Left = 639
      Top = 0
      Width = 8
      Caption = 'ToolButton36'
      ImageIndex = 64
      Style = tbsSeparator
    end
    object ProgressBar1: TProgressBar
      Left = 647
      Top = 0
      Width = 129
      Height = 22
      Smooth = True
      TabOrder = 0
    end
    object ToolButton4: TToolButton
      Left = 776
      Top = 0
      Hint = 'Abbruch'
      Caption = 'ToolButton4'
      ImageIndex = 0
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton4Click
    end
    object ToolButton28: TToolButton
      Left = 799
      Top = 0
      Width = 8
      Caption = 'ToolButton28'
      ImageIndex = 64
      Style = tbsSeparator
    end
    object ToolButton41: TToolButton
      Left = 807
      Top = 0
      Hint = 'Ansicht davor zeigen'
      Caption = 'ToolButton41'
      ImageIndex = 60
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton11: TToolButton
      Left = 830
      Top = 0
      Hint = 'Foto der aktuellen Ansicht'
      Caption = 'ToolButton11'
      ImageIndex = 90
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton43: TToolButton
      Left = 853
      Top = 0
      Hint = 'Ansicht danach anzeigen'
      Caption = 'ToolButton43'
      ImageIndex = 62
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton17: TToolButton
      Left = 876
      Top = 0
      Hint = 'auf neueste Ansicht vor'
      Caption = 'ToolButton17'
      ImageIndex = 91
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton30: TToolButton
      Left = 899
      Top = 0
      Width = 21
      Caption = 'ToolButton30'
      ImageIndex = 63
      Style = tbsSeparator
    end
    object Image2: TImage
      Left = 920
      Top = 0
      Width = 54
      Height = 22
      Cursor = crHandPoint
      Align = alRight
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
  end
  object PageControl1: TPageControl
    Left = 7
    Top = 353
    Width = 970
    Height = 289
    ActivePage = TabSheet4
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Messwerte (TESTS)'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        962
        260)
      object Label2: TLabel
        Left = 312
        Top = 14
        Width = 91
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'REALFLOWRATE'
        FocusControl = Edit22
      end
      object Label3: TLabel
        Left = 318
        Top = 38
        Width = 85
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERVOLUME'
        FocusControl = Edit23
      end
      object Label4: TLabel
        Left = 322
        Top = 63
        Width = 81
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'USEDNOZZLES'
        FocusControl = Edit24
      end
      object Label5: TLabel
        Left = 325
        Top = 86
        Width = 78
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'LABPRESSURE'
        FocusControl = Edit25
      end
      object Label6: TLabel
        Left = 299
        Top = 110
        Width = 104
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'LABTEMPERATURE'
        FocusControl = Edit26
      end
      object Label7: TLabel
        Left = 325
        Top = 133
        Width = 78
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'LABHUMIDITY'
        FocusControl = Edit27
      end
      object Label8: TLabel
        Left = 302
        Top = 158
        Width = 101
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'BIGNOZZLESTEMP'
        FocusControl = Edit28
      end
      object Label9: TLabel
        Left = 285
        Top = 182
        Width = 118
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'SMALLNOZZLESTEMP'
        FocusControl = Edit29
      end
      object Label10: TLabel
        Left = 283
        Top = 206
        Width = 120
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'BIGNOZZLESPRESSUR'
        FocusControl = Edit30
      end
      object Label11: TLabel
        Left = 281
        Top = 231
        Width = 122
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'SMALLNOZZLESPRESS'
        FocusControl = Edit31
      end
      object Label12: TLabel
        Left = 0
        Top = 11
        Width = 88
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'CALIBRATIONID'
        FocusControl = Edit1
      end
      object Label13: TLabel
        Left = 9
        Top = 35
        Width = 79
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'EQUIPMENTID'
        FocusControl = Edit3
      end
      object Label14: TLabel
        Left = 3
        Top = 59
        Width = 85
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'SERIALNUMBER'
        FocusControl = Edit2
      end
      object Label15: TLabel
        Left = 27
        Top = 83
        Width = 61
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'POINTNUM'
        FocusControl = Edit4
      end
      object Label16: TLabel
        Left = 2
        Top = 107
        Width = 86
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'REQFLOWRATE'
        FocusControl = Edit5
      end
      object Label17: TLabel
        Left = 18
        Top = 131
        Width = 70
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'REQVOLUME'
        FocusControl = Edit6
      end
      object Label18: TLabel
        Left = 30
        Top = 155
        Width = 58
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'STABTIME'
        FocusControl = Edit7
      end
      object Label19: TLabel
        Left = 95
        Top = 152
        Width = 35
        Height = 14
        Caption = 'Label2'
      end
      object Label20: TLabel
        Left = 103
        Top = 161
        Width = 35
        Height = 14
        Caption = 'Label2'
      end
      object Label23: TLabel
        Left = 605
        Top = 182
        Width = 130
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERERRORWITHGEA'
        FocusControl = Edit16
      end
      object Label24: TLabel
        Left = 660
        Top = 158
        Width = 75
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERERROR'
        FocusControl = Edit15
      end
      object Label25: TLabel
        Left = 606
        Top = 133
        Width = 129
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'NOTCORRECTEDERROR'
        FocusControl = Edit14
      end
      object Label26: TLabel
        Left = 640
        Top = 110
        Width = 95
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERMINPLOSS'
        FocusControl = Edit13
      end
      object Label27: TLabel
        Left = 637
        Top = 86
        Width = 98
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERMAXPLOSS'
        FocusControl = Edit12
      end
      object Label28: TLabel
        Left = 661
        Top = 63
        Width = 74
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERPLOSS'
        FocusControl = Edit11
      end
      object Label29: TLabel
        Left = 640
        Top = 38
        Width = 95
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERPRESSURE'
        FocusControl = Edit10
      end
      object Label30: TLabel
        Left = 614
        Top = 14
        Width = 121
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERTEMPERATURE'
        FocusControl = Edit9
      end
      object Label31: TLabel
        Left = 8
        Top = 179
        Width = 80
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERPULSES'
        FocusControl = Edit8
      end
      object Label32: TLabel
        Left = 60
        Top = 203
        Width = 28
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'REPS'
        FocusControl = Edit9
      end
      object Label33: TLabel
        Left = 56
        Top = 227
        Width = 32
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'DONE'
        FocusControl = Edit20
      end
      object Edit4: TEdit
        Tag = 29
        Left = 91
        Top = 80
        Width = 190
        Height = 22
        TabOrder = 3
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit2: TEdit
        Tag = 28
        Left = 91
        Top = 56
        Width = 190
        Height = 22
        TabOrder = 1
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit1: TEdit
        Tag = 26
        Left = 91
        Top = 7
        Width = 190
        Height = 22
        TabOrder = 0
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit3: TEdit
        Tag = 27
        Left = 91
        Top = 32
        Width = 190
        Height = 22
        TabOrder = 2
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit5: TEdit
        Tag = 30
        Left = 91
        Top = 105
        Width = 190
        Height = 22
        TabOrder = 4
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit6: TEdit
        Tag = 31
        Left = 91
        Top = 128
        Width = 190
        Height = 22
        TabOrder = 5
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit7: TEdit
        Tag = 32
        Left = 91
        Top = 152
        Width = 190
        Height = 22
        TabOrder = 6
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit8: TEdit
        Tag = 33
        Left = 91
        Top = 175
        Width = 190
        Height = 22
        TabOrder = 7
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit9: TEdit
        Tag = 46
        Left = 738
        Top = 11
        Width = 193
        Height = 22
        TabOrder = 8
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit10: TEdit
        Tag = 47
        Left = 738
        Top = 35
        Width = 193
        Height = 22
        TabOrder = 9
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit11: TEdit
        Tag = 48
        Left = 738
        Top = 59
        Width = 193
        Height = 22
        TabOrder = 10
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit12: TEdit
        Tag = 49
        Left = 738
        Top = 83
        Width = 193
        Height = 22
        TabOrder = 11
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit13: TEdit
        Tag = 50
        Left = 738
        Top = 107
        Width = 193
        Height = 22
        TabOrder = 12
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit14: TEdit
        Tag = 51
        Left = 738
        Top = 131
        Width = 193
        Height = 22
        TabOrder = 13
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit15: TEdit
        Tag = 52
        Left = 738
        Top = 155
        Width = 193
        Height = 22
        TabOrder = 14
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit16: TEdit
        Tag = 53
        Left = 738
        Top = 179
        Width = 193
        Height = 22
        TabOrder = 15
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit19: TEdit
        Tag = 45
        Left = 407
        Top = 226
        Width = 178
        Height = 22
        TabOrder = 16
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit20: TEdit
        Tag = 35
        Left = 91
        Top = 224
        Width = 190
        Height = 22
        TabOrder = 17
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit21: TEdit
        Tag = 34
        Left = 91
        Top = 200
        Width = 190
        Height = 22
        TabOrder = 18
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit22: TEdit
        Tag = 36
        Left = 407
        Top = 10
        Width = 178
        Height = 22
        TabOrder = 19
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit23: TEdit
        Tag = 37
        Left = 407
        Top = 35
        Width = 178
        Height = 22
        TabOrder = 20
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit24: TEdit
        Tag = 38
        Left = 407
        Top = 58
        Width = 178
        Height = 22
        TabOrder = 21
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit25: TEdit
        Tag = 39
        Left = 407
        Top = 82
        Width = 178
        Height = 22
        TabOrder = 22
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit26: TEdit
        Tag = 40
        Left = 407
        Top = 105
        Width = 178
        Height = 22
        TabOrder = 23
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit27: TEdit
        Tag = 41
        Left = 407
        Top = 130
        Width = 178
        Height = 22
        TabOrder = 24
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit28: TEdit
        Tag = 42
        Left = 407
        Top = 154
        Width = 178
        Height = 22
        TabOrder = 25
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit29: TEdit
        Tag = 43
        Left = 407
        Top = 178
        Width = 178
        Height = 22
        TabOrder = 26
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit30: TEdit
        Tag = 44
        Left = 407
        Top = 203
        Width = 178
        Height = 22
        TabOrder = 27
        Text = '*'
        OnChange = Edit95Change
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Messl'#228'ufe (CALIBRATIONS)'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        962
        260)
      object Label44: TLabel
        Left = 40
        Top = 11
        Width = 88
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'CALIBRATIONID'
        FocusControl = Edit31
      end
      object Label45: TLabel
        Left = 49
        Top = 35
        Width = 79
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'EQUIPMENTID'
        FocusControl = Edit33
      end
      object Label46: TLabel
        Left = 59
        Top = 59
        Width = 69
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'FIELD_DATE'
        FocusControl = Edit32
      end
      object Label47: TLabel
        Left = 66
        Top = 83
        Width = 62
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'OPERATOR'
        FocusControl = Edit34
      end
      object Label48: TLabel
        Left = 73
        Top = 107
        Width = 55
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'PROGRAM'
        FocusControl = Edit35
      end
      object Label49: TLabel
        Left = 10
        Top = 131
        Width = 118
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'ADITIONALPROGRAM'
        FocusControl = Edit36
      end
      object Label50: TLabel
        Left = 89
        Top = 155
        Width = 39
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'NOTES'
        FocusControl = Edit37
      end
      object Edit31: TEdit
        Tag = 19
        Left = 130
        Top = 7
        Width = 221
        Height = 22
        TabOrder = 0
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit32: TEdit
        Tag = 21
        Left = 130
        Top = 56
        Width = 221
        Height = 22
        TabOrder = 1
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit33: TEdit
        Tag = 20
        Left = 130
        Top = 32
        Width = 221
        Height = 22
        TabOrder = 2
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit34: TEdit
        Tag = 22
        Left = 130
        Top = 80
        Width = 221
        Height = 22
        TabOrder = 3
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit35: TEdit
        Tag = 23
        Left = 130
        Top = 105
        Width = 221
        Height = 22
        TabOrder = 4
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit36: TEdit
        Tag = 24
        Left = 130
        Top = 128
        Width = 221
        Height = 22
        TabOrder = 5
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit37: TEdit
        Tag = 25
        Left = 130
        Top = 152
        Width = 221
        Height = 22
        TabOrder = 6
        Text = '*'
        OnChange = Edit95Change
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Ausf'#228'lle (REJECTIONS)'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        962
        260)
      object Label76: TLabel
        Left = 34
        Top = 11
        Width = 88
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'CALIBRATIONID'
        FocusControl = Edit61
      end
      object Label77: TLabel
        Left = 43
        Top = 35
        Width = 79
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'EQUIPMENTID'
        FocusControl = Edit63
      end
      object Label78: TLabel
        Left = 20
        Top = 59
        Width = 102
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'POSITIONNUMBER'
        FocusControl = Edit62
      end
      object Label79: TLabel
        Left = 48
        Top = 83
        Width = 74
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'REJECTIONID'
        FocusControl = Edit64
      end
      object Edit61: TEdit
        Tag = 54
        Left = 123
        Top = 7
        Width = 220
        Height = 22
        TabOrder = 0
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit62: TEdit
        Tag = 56
        Left = 123
        Top = 56
        Width = 220
        Height = 22
        TabOrder = 1
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit63: TEdit
        Tag = 55
        Left = 123
        Top = 32
        Width = 220
        Height = 22
        TabOrder = 2
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit64: TEdit
        Tag = 57
        Left = 123
        Top = 80
        Width = 220
        Height = 22
        TabOrder = 3
        Text = '*'
        OnChange = Edit95Change
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Z'#228'hler (METERS)'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        962
        260)
      object Label98: TLabel
        Left = 357
        Top = 14
        Width = 77
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERDATA1'
        FocusControl = Edit112
      end
      object Label99: TLabel
        Left = 357
        Top = 38
        Width = 77
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERDATA2'
        FocusControl = Edit113
      end
      object Label100: TLabel
        Left = 357
        Top = 63
        Width = 77
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERDATA3'
        FocusControl = Edit114
      end
      object Label101: TLabel
        Left = 357
        Top = 86
        Width = 77
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERDATA4'
        FocusControl = Edit115
      end
      object Label102: TLabel
        Left = 357
        Top = 110
        Width = 77
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERDATA5'
        FocusControl = Edit116
      end
      object Label103: TLabel
        Left = 357
        Top = 133
        Width = 77
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERDATA6'
        FocusControl = Edit117
      end
      object Label104: TLabel
        Left = 357
        Top = 158
        Width = 77
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERDATA7'
        FocusControl = Edit118
      end
      object Label105: TLabel
        Left = 357
        Top = 182
        Width = 77
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERDATA8'
        FocusControl = Edit119
      end
      object Label106: TLabel
        Left = 357
        Top = 206
        Width = 77
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERDATA9'
        FocusControl = Edit120
      end
      object Label107: TLabel
        Left = 350
        Top = 231
        Width = 84
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'METERDATA10'
        FocusControl = Edit109
      end
      object Label108: TLabel
        Left = 17
        Top = 11
        Width = 88
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'CALIBRATIONID'
        FocusControl = Edit91
      end
      object Label109: TLabel
        Left = 26
        Top = 35
        Width = 79
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'EQUIPMENTID'
        FocusControl = Edit93
      end
      object Label110: TLabel
        Left = 20
        Top = 59
        Width = 85
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'SERIALNUMBER'
        FocusControl = Edit92
      end
      object Label111: TLabel
        Left = 3
        Top = 83
        Width = 102
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'POSITIONNUMBER'
        FocusControl = Edit94
      end
      object Label112: TLabel
        Left = 29
        Top = 107
        Width = 76
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'FIELD_ORDER'
        FocusControl = Edit95
      end
      object Label113: TLabel
        Left = 76
        Top = 131
        Width = 26
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'ZWK'
        FocusControl = Edit96
      end
      object Label114: TLabel
        Left = 61
        Top = 155
        Width = 44
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'GEARS1'
        FocusControl = Edit97
      end
      object Label115: TLabel
        Left = 112
        Top = 152
        Width = 35
        Height = 14
        Caption = 'Label2'
      end
      object Label116: TLabel
        Left = 119
        Top = 161
        Width = 35
        Height = 14
        Caption = 'Label2'
      end
      object Label127: TLabel
        Left = 61
        Top = 179
        Width = 44
        Height = 14
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'GEARS2'
        FocusControl = Edit98
      end
      object Edit91: TEdit
        Tag = 1
        Left = 107
        Top = 7
        Width = 222
        Height = 22
        TabOrder = 0
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit92: TEdit
        Tag = 3
        Left = 107
        Top = 56
        Width = 222
        Height = 22
        TabOrder = 1
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit93: TEdit
        Tag = 2
        Left = 107
        Top = 32
        Width = 222
        Height = 22
        TabOrder = 2
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit94: TEdit
        Tag = 4
        Left = 107
        Top = 80
        Width = 222
        Height = 22
        TabOrder = 3
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit95: TEdit
        Tag = 5
        Left = 107
        Top = 105
        Width = 222
        Height = 22
        TabOrder = 4
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit96: TEdit
        Tag = 6
        Left = 107
        Top = 128
        Width = 222
        Height = 22
        TabOrder = 5
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit97: TEdit
        Tag = 7
        Left = 107
        Top = 152
        Width = 222
        Height = 22
        TabOrder = 6
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit98: TEdit
        Tag = 8
        Left = 107
        Top = 175
        Width = 222
        Height = 22
        TabOrder = 7
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit109: TEdit
        Tag = 18
        Left = 437
        Top = 226
        Width = 220
        Height = 22
        TabOrder = 8
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit112: TEdit
        Tag = 9
        Left = 437
        Top = 10
        Width = 220
        Height = 22
        TabOrder = 9
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit113: TEdit
        Tag = 10
        Left = 437
        Top = 35
        Width = 220
        Height = 22
        TabOrder = 10
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit114: TEdit
        Tag = 11
        Left = 437
        Top = 58
        Width = 220
        Height = 22
        TabOrder = 11
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit115: TEdit
        Tag = 12
        Left = 437
        Top = 82
        Width = 220
        Height = 22
        TabOrder = 12
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit116: TEdit
        Tag = 13
        Left = 437
        Top = 105
        Width = 220
        Height = 22
        TabOrder = 13
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit117: TEdit
        Tag = 14
        Left = 437
        Top = 130
        Width = 220
        Height = 22
        TabOrder = 14
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit118: TEdit
        Tag = 15
        Left = 437
        Top = 154
        Width = 220
        Height = 22
        TabOrder = 15
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit119: TEdit
        Tag = 16
        Left = 437
        Top = 178
        Width = 220
        Height = 22
        TabOrder = 16
        Text = '*'
        OnChange = Edit95Change
      end
      object Edit120: TEdit
        Tag = 17
        Left = 437
        Top = 203
        Width = 220
        Height = 22
        TabOrder = 17
        Text = '*'
        OnChange = Edit95Change
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Selektions Zusammenfassung'
      ImageIndex = 4
      OnShow = TabSheet5Show
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label22: TLabel
        Left = 19
        Top = 13
        Width = 22
        Height = 14
        Caption = 'Info'
        FocusControl = Memo1
      end
      object SpeedButton1: TSpeedButton
        Left = 43
        Top = 10
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
      object Memo1: TMemo
        Left = 16
        Top = 32
        Width = 937
        Height = 217
        Lines.Strings = (
          'Memo1')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object ComboBox1: TComboBox
    Left = 95
    Top = 329
    Width = 339
    Height = 22
    TabOrder = 3
    OnSelect = ComboBox1Select
  end
  object ToolBar2: TToolBar
    Left = 464
    Top = 326
    Width = 153
    Height = 29
    Align = alNone
    Caption = 'ToolBar2'
    Images = ImageList1
    TabOrder = 4
    object ToolButton15: TToolButton
      Left = 0
      Top = 0
      Width = 17
      Caption = 'ToolButton15'
      ImageIndex = 48
      Style = tbsSeparator
    end
    object ToolButton14: TToolButton
      Left = 17
      Top = 0
      Hint = 'Abfrage speichern'
      Caption = 'ToolButton14'
      ImageIndex = 61
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton14Click
    end
    object ToolButton19: TToolButton
      Left = 40
      Top = 0
      Hint = 'v'#246'llig neue Abfrage beginnen'
      Caption = 'ToolButton19'
      ImageIndex = 4
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton19Click
    end
    object ToolButton20: TToolButton
      Left = 63
      Top = 0
      Hint = 'Abfrage l'#246'schen'
      Caption = 'ToolButton20'
      ImageIndex = 94
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton20Click
    end
    object ToolButton22: TToolButton
      Left = 86
      Top = 0
      Hint = 'Abfrage kopieren'
      Caption = 'ToolButton22'
      ImageIndex = 95
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton22Click
    end
    object ToolButton24: TToolButton
      Left = 109
      Top = 0
      Hint = 'Abfrageverzeichnis zeigen'
      Caption = 'ToolButton24'
      ImageIndex = 9
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton24Click
    end
  end
  object StaticText1: TStaticText
    Left = 4
    Top = 35
    Width = 121
    Height = 30
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSingle
    Caption = 'StaticText1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
  object StaticText2: TStaticText
    Left = 144
    Top = 32
    Width = 121
    Height = 41
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSingle
    Caption = 'StaticText1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
  end
  object StaticText3: TStaticText
    Left = 217
    Top = 32
    Width = 120
    Height = 41
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSingle
    Caption = 'StaticText1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
  end
  object StaticText4: TStaticText
    Left = 296
    Top = 32
    Width = 121
    Height = 41
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSingle
    Caption = 'StaticText1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
  end
  object StaticText5: TStaticText
    Left = 360
    Top = 32
    Width = 121
    Height = 41
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSingle
    Caption = 'StaticText1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
  end
  object StaticText6: TStaticText
    Left = 408
    Top = 32
    Width = 121
    Height = 41
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSingle
    Caption = 'StaticText1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
  end
  object StaticText7: TStaticText
    Left = 497
    Top = 32
    Width = 120
    Height = 41
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSingle
    Caption = 'StaticText1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
  end
  object StaticText8: TStaticText
    Left = 511
    Top = 32
    Width = 122
    Height = 41
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSingle
    Caption = 'StaticText1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
  end
  object StaticText9: TStaticText
    Left = 592
    Top = 32
    Width = 121
    Height = 41
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSingle
    Caption = 'StaticText1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
  end
  object StaticText10: TStaticText
    Left = 672
    Top = 32
    Width = 121
    Height = 41
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSingle
    Caption = 'StaticText1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 14
  end
  object StaticText11: TStaticText
    Left = 752
    Top = 32
    Width = 121
    Height = 41
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSingle
    Caption = 'StaticText1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 15
  end
  object ComboBox2: TComboBox
    Left = 707
    Top = 329
    Width = 249
    Height = 22
    TabOrder = 16
  end
  object ImageList1: TImageList
    Left = 368
    Top = 249
    Bitmap = {
      494C0101620063003C0010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000009001000001002000000000000090
      0100000000000000000000000000000000000000000000000000000000000000
      000000000000000000009999990D959595319191912F8C8C8C07000000000000
      00000000000000000000000000000000000000000000F8F6F800FFFFFF00FFFF
      FF00F7F4F200FBFBFB00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FDFC
      FC00F5F4F300F3F2F200FAF9F900F2F1F1000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A3A3
      A321A1A1A19D9F9F9FF0A1A1A1FFABABABFFA7A7A7FF959595FF8D8D8DE78989
      898A86868616000000000000000000000000EADCD200A9755300EDEDEE00FFFF
      FF00D0BAAB00AF806600F7F6F600FFFFFF00FFFFFF00FFFFFF00FFFFFF00E2CC
      C1009856280096542600C3A08B009A5B31000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A7A7A74AA5A5
      A5F4CECECEFFEDEDEDFFF4F4F4FFF5F5F5FFF4F4F4FFEFEFEFFFE2E2E2FFBABA
      BAFF8A8A8AE7868686350000000000000000EADCD2008F430D0097512400CFBF
      C200D4B5A0008C3D060098614600DFD5D600FFFFFF00FFFFFF00FFFFFF00E1CE
      C1008C3C04008D3E0700BA907500924511000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A9A9A9EADEDE
      DEFFF3F3F3FFDBDBDBFFD2D2D2FFDBDBDBFFD6D6D6FFC0C0C0FFC9C9C9FFE6E6
      E6FFC4C4C4FF8B8B8BEA0000000000000000E9DAD0008F420C008E410A008F46
      13009C7053008E4009008E400900944C1A00D1BDB100FDFCFC00FFFFFF00DBCF
      C7008C3D05008C3D0500BA907500924511000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000ACACACEAF0F0
      F0FFDEDEDEFFD4D4D4FFD2D2D2FFDBDBDBFFD6D6D6FFBFBFBFFFB0B0B0FFB3B3
      B3FFDEDEDEFF909090EA0000000000000000E9DAD0008F420C008F410A008E3F
      08008E4009008F410B008E410A008E4009008F420C00A9806F00F4F3F400E1CE
      C1008C3C04008D3E0600BA907500914410000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000AEAEAEEAF2F2
      F2FFE2E2E2FFD8D8D8FFD5D5D5FFDCDCDCFFD8D8D8FFC0C0C0FFB3B3B3FFB7B7
      B7FFE0E0E0FF969696EA0000000000000000E9DAD0008F420C008E4009009F62
      3E00934914008E4009008E400900985120008D3D06008E4009009F664200C8B4
      BB0090420D008C3D0500BB937800924712000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B0B0B0EAF3F3
      F3FFE7E7E7FFDDDDDDFFD9D9D9FFE0E0E0FFDBDBDBFFC4C4C4FFB8B8B8FFBBBB
      BBFFE1E1E1FF9B9B9BEA0000000000000000F6F0ED00AF7953008C3C0400C197
      7A00ECE0D800A96E46008B3C0300C6A48E00CCAD9900954C19008E3F08009348
      1400B48F7C009D5F3400CBAC9800D9BFAD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B2B2B2EAF4F4
      F4FFEAEAEAFFE1E1E1FFDDDDDDFFE3E3E3FFDEDEDEFFC9C9C9FFBDBDBDFFBFBF
      BFFFE2E2E2FF9E9E9EEA0000000000000000FFFFFF00FBF8F600C7A28A00C198
      7D00FFFFFF00F9F6F300BB8E6F00C6A28D00FEFEFE00E7D7CC009B5A2E008C3C
      04008D410B00AA7F6400E4D5CC00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B4B4B4EAF5F5
      F5FFEEEEEEFFE6E6E6FFE2E2E2FFE6E6E6FFE1E1E1FFCDCDCDFFC2C2C2FFC2C2
      C2FFE3E3E3FFA0A0A0EA0000000000000000FFFFFF00FFFFFF00FFFFFF00FBFA
      FA00FFFFFF00FFFFFF00FFFFFF00FBFAFA00FFFFFF00FFFFFF00F7F3F100E3D9
      D200D2C6C000D4CAC300D9D6D600FAF9F9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B5B5B5EAF6F6
      F6FFEBEBEBFFDEDEDEFFD6D6D6FFD5D5D5FFD1D1D1FFC3C3C3FFBCBCBCFFC0C0
      C0FFE5E5E5FFA3A3A3EA0000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E5E3E300E0E0
      E000BDBBBA00C3C2C100B1B0B000B9B6B7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B7B7B7EAF7F7
      F7FFE7E7E7FFEFEFEFFFF6F6F6FFFBFBFBFFFAFAFAFFF0F0F0FFDEDEDEFFC3C3
      C3FFE6E6E6FFA5A5A5EA0000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00EFEDED00BEBD
      BD00ADAAB800ADA5EB00A098D200B4B2B3000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B9B9B9EAF8F8
      F8FFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFB
      FBFFEAEAEAFFA7A7A7EA0000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7F7FC009B92E9008C7F
      EB008C7EE600B2AAEE009D93E700897BE7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BABABABFE1E1
      E1FFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFB
      FBFFCFCFCFFFA9A9A9A10000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E7E4F9007E6F
      F0004D39F1005948E1004A35F8007363F1000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BCBCBC2ABBBB
      BBD1D0D0D0FFE8E8E8FFF3F3F3FFFDFDFDFFFCFCFCFFEDEDEDFFE0E0E0FFC2C2
      C2FFADADADC3ACACAC1B0000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7F6
      FC008F83F1006959ED006C5DEB00A9A0E8000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BCBC
      BC07BBBBBB55BABABAAEB8B8B8D6B7B7B7FBB6B6B6F9B4B4B4CDB3B3B3A9B1B1
      B146AFAFAF03000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000566266006B777B00717D81006A76
      7A00727E8200828E92006E7A7E006E7A7E006773770059656900758185007A86
      8A00818D910068747800818D9100636F73000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF0000000000BDBDBD0000000000BDBDBD00000000007B7B7B007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007E0000005D0400008F01080075000000B000
      08009000000095030700900E0F00A20000005460640066727600647074005460
      64006A767A00929EA200909CA0000000FF00B8C4C800C7D3D700C8D4D8009AA6
      AA00AAB6BA00B4C0C400A8B4B800838F93000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C0000000000000000000000000000000000000000000FFFF
      FF00FFFFFF0000000000BDBDBD00000000007B7B7B00000000007B7B7B007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000074000000FFFBF100FFFDF900EAFFFC00FFFE
      FB00FBFFF900F2F6EB00FFF4EC006C0000005460640066727600647074005460
      64006A767A00929EA200909CA000A3AFB300B8C4C8000000FF00C8D4D80000FF
      FF0000FFFF00B4C0C400A8B4B80000FFFF0000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C00000FFFF0000FFFF0000FFFF00C0C0C000C0C0
      C000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF007B7B7B007B7B7B00BDBDBD0000000000BDBDBD007B7B7B00000000007B7B
      7B007B7B7B000000000000000000000000000000000000000000000000000000
      000000000000000000000000000091010D00FFFEF9001B000000000501000405
      09000005010000020000FFFDF90086030D004A565A00647074006D797D005763
      6700647074000000FF0099A5A900B7C3C70000FFFF006D797D0094A0A4000000
      FF00C6D2D600C3CFD300BFCBCF0094A0A40000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000808080008080800080808000C0C0C000C0C0
      C00000000000C0C0C00000000000000000000000000000000000FFFFFF00FFFF
      FF0000000000BDBDBD00BDBDBD00000000007B7B7B00BDBDBD00000000007B7B
      7B007B7B7B0000000000000000000000000000000000000A0000000200000402
      020000000100190407001601000071000600FFFFF800E6FFF600EDF8F000F3FF
      FB00F2FAFA00E4FFFE00F8FFF80074000200434F530064707400788488005F6B
      6F00616D7100919DA100A7B3B70000FFFF0000FFFF0000000000546064009CA8
      AC00A7B3B70000FFFF00BECACE00919DA1000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000C0C0C000000000000000000000000000FFFFFF00FFFF
      FF0000000000BDBDBD00BDBDBD0000000000BDBDBD007B7B7B00000000007B7B
      7B007B7B7B0000000000000000000000000000000000020E0200F0F4EF000000
      0000E6FFFF00F9FBFB00F6F3EF007D101900FFFBF600000A0200210F10000B00
      00001F00010002010000FFF9F2009900040046525600616D71000000FF005561
      6500616D7100A7B3B700D2DEE2006A767A000000000000FFFF00414D510097A3
      A7000000FF0000FFFF00BCC8CC000000FF0000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C00000000000C0C0C000000000000000000000000000FFFFFF00FFFF
      FF007B7B7B007B7B7B00BDBDBD00000000007B7B7B00BDBDBD00000000007B7B
      7B007B7B7B000000000000000000000000000000000000050000FDFFFC000200
      000002000000130102001B0C0A0064000000FFF9F900FAFFFE00FBEDF100FFFD
      FF00F6FFFC00D7F8EA00FFFEF500670000004D535A00696F7600737B82005660
      6700717D8300C5D1D700E3EFF5009EA8AF00707A81006E787F00FFFFFF00FFFF
      FF000000FF00FFFFFF00FFFFFF0000FFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C00000000000C0C0C0000000000000000000000000000000000000000000FFFF
      FF00FFFFFF0000000000BDBDBD0000000000BDBDBD00000000007B7B7B007B7B
      7B00000000000000000000000000000000000000000000050000F6FAF5000000
      0000ECFFFF00F3FFFD00F1FFFC0064081300FFFEFC00000200000D010700FBFD
      FF006000030086010B0057080500B2000400333B42007F878E00676F76005A66
      6C006A767C00E7F5FB000000FF00D7E1E8000000FF00FFFFFF00FFFFFF000000
      FF0000FFFF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FF2B
      2B00FF2B2B00FF2B2B00FF2B2B00FF2B2B00FF2B2B00FF2B2B00FF2B2B000000
      0000C0C0C00000000000C0C0C00000000000000000000000000000000000FFFF
      FF00FFFFFF0000000000BDBDBD00000000007B7B7B00000000007B7B7B007B7B
      7B000000000000000000000000000000000000000000111D1100F7FBF6000200
      0000200000001E0000000C0000005E000000FFFCFC00F9FFFD00FFFEFF00E4FC
      FC0070000000FFFFF4004F0C030000000000747F83006F7A7E00848F9300737F
      83000000FF00A6B5B800708184008995990000FFFF00FFFFFF0000FFFF000000
      FF00FFFFFF0000FFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000FF2B2B00FF2B2B00FF2B2B00FF2B2B00FF2B2B00FF2B2B00FF2B2B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000050000FDFFFC00F8F6
      F600FFFEFF00FDFFFF00E5FDF50064101500FFFFF800FFFFF800FDF2EE00F4FF
      FC00BE0009008D0000000000000000000000000000005E696D00B7C2C600C6D2
      D6000000FF007180830000FFFF000000FF00FFFFFF00FFFFFF0000FFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000FF2B2B00FF2B2B00FF2B2B00FF2B2B00FF2B2B00FF2B2B00FF2B2B00FF2B
      2B0000000000000000000000000000000000000000000000000000000000FFFF
      FF00BDBDBD00BDBDBD00BDBDBD007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B00000000000000000000000000000000000000000000050000FAFEF9000F0D
      0D0000000400F2F1F300080C0700770000006B0001007D000200AA0913008C00
      04005807000000000000000000000000000000000000767F82000000FF006D79
      7B0073808200889597008C999B000000FF008D999B00FFFFFF00FFFFFF00FFFF
      FF0000FFFF0000FFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000FF2B2B00FF2B2B00FF2B2B00FF2B2B00FF2B2B00FF2B2B00FF2B
      2B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000090000FDFFFC00F8F6
      F600FFFAFF00F4FFFF00000A0000FFFAF700000C000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF006C767600454F4F0061696900656D6D00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000FFFF000000000000000000000000000000
      000000000000FF2B2B00FF2B2B00FF2B2B00FF2B2B00FF2B2B00FF2B2B00FF2B
      2B00FF2B2B000000000000000000000000000000000000000000000000000000
      000000000000000000007B7B7B007B7B7B007B7B7B0000000000000000000000
      000000000000000000000000000000000000000000000B0E0500E7E4E000FFFF
      FE00F7F0F300FFFEFF0000010000000500000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000500001F251A000003
      00000C100A000004000000080000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000FFFFFF000000FF000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DAC4B100C8B2A000C8B29F00CDB6A300CDB7A200CEB8
      A300CFBAA400CCB8A300C3B6A900EBE5DF0000000000BFBEC000C2C1C300B5B7
      B800BFC3C400B9BDBE00C6CBCC00B3B5B600B4B6B700BBBDBE00BCBEBF00D1D3
      D400C8CACB00C1C3C400C3C1C100C1BFBF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001F75C7002A82D500358DDE00348AE2003088E0002F88E0003089
      E4002B80D9001C6FC900297ED200C8BAAB00C4BFC100C2BDBF00CDCACC00CAC9
      CB00C9C8CA00ABADAE00C4C6C700C4C1C300CDCACC00C1BEC000B8B5B700C2BF
      C100C1BEC000BBB8BA00BBB9B900C9C7C7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF633100FF633100FF633100000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000808080000000
      000000000000000000000000000000000000FDFFFF00FFFCF700FFEAD800FBD0
      A900E4A569004F93D10050BDF1006EE0FF0066D5FF0054C3FF004BB8FF0043B0
      FF003EADFF002E9EFB000D78E600CBB59F00566266006B777B00717D81006A76
      7A00727E8200828E92006E7A7E006E7A7E006773770059656900758185007A86
      8A00818D910068747800818D9100636F73000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF9C3100FF633100000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000000000008080
      800000000000000000000000000000000000FFFEF000E4CDB300B7926C00B380
      4E00C38448005899D10065C5F10082EAFF007DDEFF006BCCFF0064C4FF005BB9
      FF0058BBFF004BB5FF001D7EE100D3BBA3005460640066727600647074005460
      64006A767A00929EA200909CA000A3AFB300B8C4C800C7D3D700C8D4D8009AA6
      AA00AAB6BA00B4C0C400A8B4B800838F93000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF9C3100FF633100000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      000080808000000000000000000000000000F1DBBF00D7B28600C8966100D198
      5B00CE9054004F95D00059A9E9006CC9FC0067C7FD005DBCFA0057B6FB004DA9
      FA004BAAFF0042A6FE001978DA00CDB59E005460640066727600647074005460
      64006A767A00929EA200909CA000A3AFB300B8C4C800C7D3D700C8D4D8009AA6
      AA00AAB6BA00B4C0C400A8B4B800838F93000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF9C3100FF633100000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000808080000000000000000000C9AB8800D1A47100E4AD7000E6AB
      6D00C2884D004F95D0007BC1EF009EF0FF008EF0FF007EE3FD0074D6FE0063C2
      FD0062C3FF0054BCFF001A79DC00D6BFA8004A565A00647074006D797D005763
      670064707400909CA00099A5A900B7C3C700818D91006D797D0094A0A400B0BC
      C000C6D2D600C3CFD300BFCBCF0094A0A4000000000000000000000000000000
      000000000000000000000000000000000000FF9C310000000000000000000000
      000000000000FF9C3100FF633100000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008080800000000000E1C3A000EBC08F00E6B47A00D9A3
      6700CB965D00569BD40088CCF300B9FDFF00A5FFFF008FF7FF0082EAFF006FD5
      FF006DD4FF005BC9FF001E81E000F9E0C900434F530064707400788488005F6B
      6F00616D7100919DA100A7B3B7007B878B00323E420000000000546064009CA8
      AC00A7B3B700A9B5B900BECACE00919DA1000000000000000000000000000000
      000000000000000000000000000000000000FF9C3100FF9C3100000000000000
      000000000000FF9C3100FF633100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080808000DBBFA100E1BD9500E1B58600DCAC
      7800D8A671004E97D600257CD600358EE5003499F200288DE9001C83E0001C85
      E5001F86E8000D7BE6000059D7000000000046525600616D7100707C80005561
      6500616D7100A7B3B700D2DEE2006A767A000000000000000000414D510097A3
      A700BBC7CB00B3BFC300BCC8CC008F9B9F0000000000FF9C3100FF9C3100FF9C
      3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C3100FFCE3100FF9C31000000
      000000000000FF9C3100FF633100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E7CEB400EBCCAB00E4C09800E0B6
      8700DCAD7900D2A06B00E88F4C007B93B2003947590087909900AFC8E100849A
      B500596273000000000000000000000000004D535A00696F7600737B82005660
      6700717D8300C5D1D700E3EFF5009EA8AF00707A81006E787F00828C9300D6E0
      E700C2CCD300C5CFD600C5D4D7007A898C0000000000FF9C3100FFFF9C00FFFF
      9C00FFFF9C00FFFF9C00FFFF9C00FFFF9C00FFFF9C00FFFF9C00FFFF9C00FF63
      310000000000FF9C3100FF633100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FCDFBA00F2D4B100D3B79800DEBF
      9E00E8BF9200DCA97100DC9C6600BBAEA40044372A007F716400D9D4CB00CDBF
      B60075605000000000000000000000000000333B42007F878E00676F76005A66
      6C006A767C00E7F5FB00C6D4DA00D7E1E800CAD4DB00C0CAD100C6D0D700DBE5
      EC00D8E2E900CDD7DE00CFDCDE008B989A0000000000FF633100FF633100FF63
      3100FF633100FF633100FF63310000000000FFFF9C00FFFF9C00FF6331000000
      000000000000FF9C3100FF633100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFEBD200F3DEC80094806E008B74
      5E00DDBD9A00D2A87B00B68E7500B4AEA700464644003231310068666400A5A1
      9B0088868200000000000000000000000000747F83006F7A7E00848F9300737F
      83009EADB000A6B5B800708184008995990096A2A60087939700929EA2008C98
      9C00FFFFFF00FFFFFF00CAD6D8007F8B8D000000000000000000000000000000
      000000000000000000000000000000000000FFFF9C00FF633100000000000000
      000000000000FF9C3100FF633100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DED2C600ACA094000B0100000E02
      0000C2AB9500E0BF9E00614D4C00929598006D6E6E004E4D4D00514F4E007F80
      7F008F929200000000000000000000000000AEB9BD005E696D00B7C2C600C6D2
      D600E2F1F4007180830046575A00ADB9BD007D898D00333F4300323E42004E5A
      5E00C6D2D600FFFFFF00CDD5D5006C7474000000000000000000000000000000
      000000000000000000000000000000000000FF63310000000000000000000000
      000000000000FF9C3100FF633100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E9E0D600C7BEB5003E3833003328
      2000D0BAA800DFC2A3008E797700523C2A009D9D9C00AFB1B100B5B5B5009595
      9600FFE4CB00000000000000000000000000BCC3C600767F8200687174006D79
      7B0073808200889597008C999B00939FA1008D999B008C989A008D999B008793
      950098A4A6008C989A00797D7E009DA1A2000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF9C3100FF633100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFF9EB00FFF8EC00DDD2CA00D6C8
      BC00F5DDC700E5C2A000EBC6AC00DEBC9800DAB68600C99D6800C5956B00F2CE
      B600FFFEFC00000000000000000000000000B3B7B800C2C6C700B9BEBF00AAB2
      B2006E7676006C767600454F4F0061696900656D6D0070787800575F5F004F57
      570060686800A1A9A900C0C2C200C5C7C7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF9C3100FF633100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFF8E800F3E6D800F2E8DE00FBED
      E100F2D8C000FBD9B500F4C69D00E9C29600DFBE9000CFAD8200E8C6A900FFF5
      EB00FFFDFF0000000000000000000000000000000000BFBEC000C2C1C300B5B7
      B800BFC3C400B9BDBE00C6CBCC00B3B5B600B4B6B700BBBDBE00BCBEBF00D1D3
      D400C8CACB00C1C3C400C3C1C100C1BFBF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF633100FF633100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFF800F6EEE700EBE4E100EEE4
      DD00E6D2C000FDDFC200F8D4B600E2C7AC00D7C8AE00F9EBD800FFFEF600FFF7
      F500FCF8FD00000000000000000000000000C4BFC100C2BDBF00CDCACC00CAC9
      CB00C9C8CA00ABADAE00C4C6C700C4C1C300CDCACC00C1BEC000B8B5B700C2BF
      C100C1BEC000BBB8BA00BBB9B900C9C7C7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000295A
      1800527B420042AD210000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000DAC4B100C8B2A000C8B29F00CDB6A300CDB7A200CEB8
      A300CFBAA400CCB8A300C3B6A900EBE5DF000000000000000000000000000000
      00000000000000000000DAC4B100C8B2A000C8B29F00CDB6A300CDB7A200CEB8
      A300CFBAA400CCB8A300C3B6A900EBE5DF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000315A21008494
      8400E7E7E700ADB5AD0039633100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001F75C7002A82D500358DDE00348AE2003088E0002F88E0003089
      E4002B80D9001C6FC900297ED200C8BAAB000000000000000000000000000000
      0000000000001F75C7002A82D500358DDE00348AE2003088E0002F88E0003089
      E4002B80D9001C6FC900297ED200C8BAAB000000000000000000000000000000
      0000000000000000000000DF0000000000000000000000000000000000000000
      00000000000000000000000000000000000031731800292929004A4A4A00D6D6
      D6000000000000000000000000008C8C8C004A7B390000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004F93D10050BDF1006EE0FF0066D5FF0054C3FF004BB8FF0043B0
      FF003EADFF002E9EFB000D78E600CBB59F000000000000000000000000000000
      0000000000004F93D10050BDF1006EE0FF0066D5FF0054C3FF004BB8FF0043B0
      FF003EADFF002E9EFB000D78E600CBB59F000000000000000000000000000000
      00000000000000DF00000000000000DF00000000000000000000000000000000
      000000000000000000000000000000000000737373004A4A4A007B7B7B000000
      000000000000000000000000000000000000EFEFEF00A5A59C00527342000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005899D10065C5F10082EAFF007DDEFF006BCCFF0064C4FF005BB9
      FF0058BBFF004BB5FF001D7EE100D3BBA3000000000000000000000000000000
      0000000000005899D10065C5F10082EAFF007DDEFF006BCCFF0064C4FF005BB9
      FF0058BBFF004BB5FF001D7EE100D3BBA3000000000000000000000000000000
      000000DF000000000000000000000000000000DF000000000000000000000000
      0000000000000000000000000000000000007373730052525200DEDEDE00FFEF
      EF00000000000000000000000000FF6B6B00FFC6C600FFF7F700E7E7E700ADAD
      AD0031632100000000000000000000000000D6D7C900416B4100416B4100416B
      4100416B41004F95D00059A9E9006CC9FC0067C7FD005DBCFA0057B6FB004DA9
      FA004BAAFF0042A6FE001978DA00CDB59E00D6D7C90000008000000080000000
      8000000080004F95D00059A9E9006CC9FC0067C7FD005DBCFA0057B6FB004DA9
      FA004BAAFF0042A6FE001978DA00CDB59E0000000000000000000000000000DF
      0000000000000000000000000000000000000000000000DF0000000000000000
      000000000000000000000000000000000000A5A5A5007B7B7B00FFDEDE00FF73
      7300FFB5B50000000000FFBDBD00FFADAD00FF9C9C00FF7B7B00FFEFEF000000
      0000000000008C8C8C005284420000000000416B4100518851006AB26A006EB6
      6D006EB66D004F95D0007BC1EF009EF0FF008EF0FF007EE3FD0074D6FE0063C2
      FD0062C3FF0054BCFF001A79DC00D6BFA80000008000000080004242FF004242
      FF004242FF004F95D0007BC1EF009EF0FF008EF0FF007EE3FD0074D6FE0063C2
      FD0062C3FF0054BCFF001A79DC00D6BFA800000000000000000000DF000000DF
      000000DF0000000000000000000000000000000000000000000000DF00000000
      0000000000000000000000000000000000004A4A4A00CECECE00FF737300FF9C
      9C00FFC6C60000000000FFEFEF00FFADAD00FF6B6B00FFADAD00FFEFEF000000
      00000000000000000000C6C6C60031841800416B4100568E55005A94590076C4
      75007AC97800569BD40088CCF300B9FDFF00A5FFFF008FF7FF0082EAFF006FD5
      FF006DD4FF005BC9FF001E81E000F9E0C90000008000000080000000F0008080
      FF008080FF00569BD40088CCF300B9FDFF00A5FFFF008FF7FF0082EAFF006FD5
      FF006DD4FF005BC9FF001E81E000F9E0C9000000000000DF000000DF000000DF
      000000DF000000DF0000000000000000000000000000000000000000000000DF
      0000000000000000000000000000000000007B7B7B00636363008C8C8C00FFBD
      BD00FFC6C600000000000000000000000000FFEFEF00FF9C9C00FFEFEF000000
      000000000000000000006B6B6B0000000000416B41006EB56D005C995C005188
      510070BB70004E97D600257CD600358EE5003499F200288DE9001C83E0001C85
      E5001F86E8000D7BE6000059D70000000000000080004242FF000000F0000000
      F0004242FF004E97D600257CD600358EE5003499F200288DE9001C83E0001C85
      E5001F86E8000D7BE6000059D700000000000080000000DF000000DF000000DF
      000000DF000000DF000000DF0000000000000000000000000000000000000000
      000000DF000000000000000000000000000073737300D6D6D600949494003939
      39009C9C9C00E7E7E70000000000000000000000000000000000F7F7F700E7E7
      E70000000000CECECE003994180000000000416B410068AE680070BB70005C99
      5C004D804D0050834F006483AB007B93B2003947590087909900AFC8E100849A
      B500596273003C50630094A1AD0000000000000080004242FF004242FF005C99
      5C000000F0000000F0006483AB007B93B2003947590087909900AFC8E100849A
      B500596273003C50630094A1AD000000000000DF00000080000000DF000000DF
      000000DF000000DF000000DF000000DF00000000000000000000000000000000
      00000000000000DF000000000000000000008C8C8C007B7B7B00DEDEDE00D6D6
      D600848484005A5A5A009C9C9C00E7E7E7000000000000000000DEA5DE00EF31
      EF00D6D6D600637B5A000000000000000000416B410064A664006AB16A006AB1
      6A005C995C00A4EEA200AFA19600BBAEA40044372A007F716400D9D4CB00CDBF
      B600756050004F473C00F1E0CF0000000000000080004242FF004242FF004242
      FF000000F000B9B9FF00AFA19600BBAEA40044372A007F716400D9D4CB00CDBF
      B600756050004F473C00F1E0CF00000000000000000000DF00000080000000DF
      000000DF00000000000000DF000000DF000000DF000000000000000000000000
      0000000000000000000000DF000000000000C6C6C600848484007B7B7B00E7E7
      E700E7E7E700C6C6C600848484005A5A5A008484840000000000DEBDDE00D663
      D600B5B5B5004A9C31000000000000000000416B4100609F600067AB670067AB
      670067AB6700B1F7AF00AAA39C00B4AEA700464644003231310068666400A5A1
      9B00888682004244440097AC990000000000000080004242FF004242FF004242
      FF000000F000B9B9FF00AAA39C00B4AEA700464644003231310068666400A5A1
      9B00888682004244440097AC990000000000000000000000000000DF00000080
      000000DF000000DF000000DF00000000000000DF000000DF0000000000000000
      00000000000000DF00000000000000000000B5B5B500C6C6C6008C8C8C007373
      7300E7E7E700E7E7E700E7E7E700C6C6C6009C9C9C0042424200A5A5A500D6D6
      D60073846B00000000000000000000000000416B41005B955A0060A16000609F
      60004D804D0083D9820092A89400929598006D6E6E004E4D4D00514F4E007F80
      7F008F929200415C4100416B410000000000000080004242FF004242FF000000
      F0000000F0008080FF0092A89400929598006D6E6E004E4D4D00514F4E007F80
      7F008F92920000008000000080000000000000000000000000000000000000DF
      00000080000000DF0000000000000000000000DF000000DF000000DF00000000
      0000000000000000000000000000000000008C8C8400CECECE00C6C6C6008C8C
      8C007B7B7B00DEDEDE00E7E7E700E7E7E700DEDEDE00C6C6C600315221004A7B
      3900317B1800000000000000000000000000416B4100568E55005B955A004776
      4700558C54007DCD7C007DCD7C007C937C009D9D9C00AFB1B100B5B5B5009595
      9600667E6600568E5500416B410000000000000080004242FF004242FF000000
      F0000000F0008080FF008080FF007C937C009D9D9C00AFB1B100B5B5B5009595
      96004242FF004242FF0000008000000000000000000000000000000000000000
      000000DF00000080000000DF000000DF000000DF000000DF000000DF000000DF
      000000000000000000000000000000000000315A2100CECECE00CECECE00CECE
      CE00848484007B7B7B00E7E7E700E7E7E700D6D6D6004A734200000000000000
      000000000000000000000000000000000000416B41004A7A49003C643C005084
      4F006EB66D006FB86F006FB86F006FB86F008DA28D00A09F9F00A9A9A9008398
      82003A613A004A7A4900416B410000000000000080004242FF000000F0000000
      F0004242FF004242FF004242FF004242FF008DA28D00A09F9F00A9A9A9008398
      8200000080000000800000008000000000000000000000000000000000000000
      00000000000000DF00000080000000DF000000DF000000DF000000DF00000000
      0000000000000000000000000000000000000000000073737300BDBDBD009C9C
      9C00315229004AA5290073847300CECECE005A7B4A0000000000000000000000
      000000000000000000000000000000000000416B41004473440076C37500A4EE
      A200A4EEA200A4EEA200A4EEA200A4EEA200A4EEA200A4EEA200A4EEA200A4EE
      A20074BF730043704300416B410000000000000080000000F0008080FF00B9B9
      FF00B9B9FF00B9B9FF00B9B9FF00B9B9FF00B9B9FF00B9B9FF00B9B9FF00B9B9
      FF008080FF000000800000008000000000000000000000000000000000000000
      0000000000000000000000DF00000080000000DF000000000000000000000000
      00000000000000000000000000000000000000000000427331004A634200399C
      18000000000000000000000000004A6B39000000000000000000000000000000
      000000000000000000000000000000000000D6D7C900416B4100416B4100416B
      4100416B4100416B4100416B4100416B4100416B4100416B4100416B4100416B
      4100416B4100416B4100D6D7C90000000000D6D7C90000008000000080000000
      8000000080000000800000008000000080000000800000008000000080000000
      80000000800000008000D6D7C900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009A9B
      9A00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFFFC00FBFFFE00FDFF
      FF00FFFCF700FFEAD800FBD0A900E4A56900C4783000F9A96200ECB67A00FFEF
      C900FFFFF400EFEDED00FFFDFF00F5F4F6000505050000000000010101000000
      0000050505000A0A0A0000000000080808000000000008080800000000000101
      0100000000000000000002020200000000000000000000000000000000009597
      9500C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7
      C600C6C7C600C6C7C600C6C7C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      00000000000000000000000000000000000000000000E6E9E700FFFDF500FFFE
      F000E4CDB300B7926C00B3804E00C3844800C37D3A00CA780D00C7772000AD68
      2F00E8C0A300FCF2E800FAFFFE00FAFFFE000000000080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF00000000000000000000000000000000009091
      9000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFC00FFFBEE00F1DB
      BF00D7B28600C8966100D1985B00CE905400B5773B00B6842C00C77A2B00D170
      2C00AC5A2300CFAC8100F4F5DB00EBF4EA000606060080FFFF0080FFFF0080FF
      FF0080FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000080FFFF00000000000000000000000000000000008688
      860000000000C6C7C600C6C7C600C6C7C600C6C7C60000000000C6C7C600C6C7
      C600C6C7C60000000000C6C7C600000000000000000000000000000000000000
      000000000000000000000000FF0000000000000000000000FF00000000000000
      00000000000000000000000000000000000000000000FFFFFB00E2D4C200C9AB
      8800D1A47100E4AD7000E6AB6D00C2884D00915A2100231D0000AB784600C461
      1D00E1792600AA671800D2BA8400FFFFF2000606060080FFFF0080FFFF0080FF
      FF0080FFFF0000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000080FFFF00000000000000000000000000000000008486
      8400000000000000000000000000008600008486840000860000848684000000
      0000C6C7C60000000000C6C7C600000000000000000000000000000000000000
      0000000000000000FF00000000000000000000000000000000000000FF000000
      00000000000000000000000000000000000000000000FCF2E800E4D3C000E1C3
      A000EBC08F00E6B47A00D9A36700CB965D00C08C57004C4A42002C090000C174
      2F00CD6E0D00D5812100A6722B00FFE8C8000000000080FFFF0080FFFF0080FF
      FF0080FFFF0000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000080FFFF00000000000086000091929100008600008486
      8400008600008486840000860000000000000086000084868400008600000000
      0000C6C7C60000000000C6C7C600000000000000000000000000000000000000
      00000000FF0000000000FF0000000000000000000000000000000000FF000000
      00000000000000000000000000000000000000000000FFF5E500E8D3BE00DBBF
      A100E1BD9500E1B58600DCAC7800D8A67100D19F6A00C5997A007F5423005421
      0000D9963A00B6660D00C5793100F7BF8E000000000080FFFF0080FFFF0080FF
      FF0080FFFF0000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000080FFFF00000000008486840000860000848684000086
      0000848684000086000000000000008600008486840000860000000000000000
      00000000000000000000C6C7C600000000000000000000000000000000000000
      000000000000FF00000000000000FF0000000000000000000000000000000000
      FF000000000000000000000000000000000000000000FAE6D400EAD5C000E7CE
      B400EBCCAB00E4C09800E0B68700DCAD7900D2A06B00E88F4C00E1A75C00AE8B
      3B00A9803100C17C3300C8712F00DF9254000606060080FFFF0080FFFF0080FF
      FF0080FFFF0000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000080FFFF00000000000086000084868400008600008486
      8400008600000000000000860000848684000086000084868400C6C7C600C6C7
      C600C6C7C60000000000C6C7C600000000000000000000000000000000000000
      0000FF000000000000000000000000000000FF00000000000000000000000000
      00000000FF0000000000000000000000000000000000FEEED700E9D1B300FCDF
      BA00F2D4B100D3B79800DEBF9E00E8BF9200DCA97100DC9C6600D0975A00D29B
      5800CB8A4000C97D3100D1803500C2792F00010101000000FF0080FFFF0080FF
      FF0080FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000080FFFF00000000000000000000860000848684000086
      0000000000000086000084868400008600008486840000860000000000000000
      0000C6C7C60000000000C6C7C60000000000000000000000000000000000FF00
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000FF00000000000000000000000000F4EBE100EFE1CE00FFEB
      D200F3DEC80094806E008B745E00DDBD9A00D2A87B00B68E750087613E008E63
      3000CA915300CE874300CD823D00E6A56100000000000000FF000000FF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF00000000000000000000000000008600000000
      000000860000848684000086000084868400C6C7C600C6C7C600C6C7C600C6C7
      C600C6C7C60000000000C6C7C600000000000000000000000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000FF0000000000
      000000000000000000000000FF000000000000000000F4F6F600F3EDE600DED2
      C600ACA094000B0100000E020000C2AB9500E0BF9E00614D4C00170200003114
      0000C6976100D3945800BB7A4300FCCB9B000D0D0D000000FF000000FF000000
      FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF00408080004080800080FFFF00000000000000000000860000000000000086
      00008486840000860000848684000086000084868400C6C7C600000000000000
      0000C6C7C60000000000C6C7C6000000000000000000FF000000FF000000FF00
      0000FF000000FF0000000000000000000000000000000000000000000000FF00
      00000000000000000000000000000000FF0000000000F0F3F700F6F3EF00E9E0
      D600C7BEB5003E38330033282000D0BAA800DFC2A3008E797700523C2A006C4F
      2800D1A57000CE956100C4916900FFE4CB00040404000000FF000000FF000000
      FF000000FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF00000000004080800080FFFF00000000000086000000000000008600008486
      8400008600008486840000860000848684000086000084868400C6C7C600C6C7
      C600C6C7C60000000000C6C7C6000000000080000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000FF00000000000000000000000000000000000000F9F9F900FBF6ED00FFF9
      EB00FFF8EC00DDD2CA00D6C8BC00F5DDC700E5C2A000EBC6AC00DEBC9800DAB6
      8600C99D6800C5956B00F2CEB600FFFEFC00020202000000FF000000FF000000
      FF000000FF000000FF0080FFFF0080FFFF0080FFFF0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF00000000008F908F0000860000848684000086
      0000848684000000000084868400008600008486840000860000000000000000
      000000000000000000000000000000000000FF00000080000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      000000000000FF000000000000000000000000000000FFFFFE00FFFAF100FFF8
      E800F3E6D800F2E8DE00FBEDE100F2D8C000FBD9B500F4C69D00E9C29600DFBE
      9000CFAD8200E8C6A900FFF5EB00FFFDFF0000000000000000000D0D0D000000
      0000000000000000000007070700000000001111110000000000000000000000
      0000000000000000000000000000000000000086000084868400008600008486
      8400000000000000000000000000848684000086000084868400000000000000
      00008486840000000000000000000000000000000000FF00000080000000FF00
      0000FF00000000000000FF000000FF000000FF00000000000000000000000000
      00000000000000000000FF0000000000000000000000F8FDFF00FFFEFA00FFFF
      F800F6EEE700EBE4E100EEE4DD00E6D2C000FDDFC200F8D4B600E2C7AC00D7C8
      AE00F9EBD800FFFEF600FFF7F500FCF8FD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008D8F
      8D00000000000000000000000000000000000000000000000000000000000000
      0000848684000000000000000000000000000000000000000000FF0000008000
      0000FF000000FF000000FF00000000000000FF000000FF000000000000000000
      000000000000FF000000000000000000000000000000F3FCFF00F7FCFF00FFFF
      FE0000000000FCFBFF00FFFAFB00FBECE300F9E1CB00F7E1D600FAF1E800E8E9
      E500FDFFFF00FFFDFF00FEF3F600FFFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000999A
      9900848684008486840084868400848684008486840084868400848684008486
      8400898B8900000000000000000000000000000000000000000000000000FF00
      000080000000FF0000000000000000000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D2B9A700946F63007A554C007A554C00946F6300D2B9A7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006E4844006E48440094797900AD989800AD989800947979006E4844006E48
      4400DAC1AC00000000000000000000000000000000000000000011111100CDAA
      A00000000000C4887500A075680000000000A98C8300A98C8300A98C8300A98C
      8300A98C8300A0756800000000000000000000FFFF000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF0000FF
      FF000000000000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000FF00000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CCB2A2005529
      26008B6E6E00DAD1D100FBFAFA00B8A6A600B8A6A600FBFAFA00DAD1D1009479
      790055292600CCB2A2000000000000000000000000000000000039393900F0CD
      C20000000000F0A68F00F0A68F0000000000EEC5B900EEC5B900EEC5B900EEC5
      B900EEC5B900C3A29800000000000000000000FFFF000000000000FFFF0000FF
      FF0000FFFF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF000000
      000000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000000000
      00000000FF000000000000000000000000000000FF0000000000000000000000
      00000000000000000000000000000000000000000000DAC1AC0055292600C7B9
      B900CFC3C300A8929200000000000000000000000000F6F4F400A68F8F00DAD1
      D100C7B9B90055292600DAC1AC0000000000000000000000000039393900F0CD
      C20000000000F0A68F00F0A68F0000000000EEC5B90000000000000000000000
      000000000000C3A29800000000000000000000FFFF0000000000000000000000
      000000FFFF0000FFFF0000FFFF000000000000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF0000000000000000000000000000000000000000000000FF00000000000000
      000000000000000000000000000000000000000000007A554C008B6E6E00D6CB
      CB00000000000000000000000000000000000000000000000000000000000000
      0000DAD1D100947979007A554C0000000000000000000000000039393900F0CD
      C20000000000F0A68F00F0A68F0000000000EEC5B9000000000000CCFF0000CC
      FF0000000000C3A29800000000000000000000FFFF000000000000FFFF0000FF
      FF000000000000FFFF0000FFFF0000FFFF000000000000FFFF0000FFFF000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000FF000000
      FF000000FF0000000000000000000000000000000000000000000000FF000000
      000000000000000000000000000000000000BCA092006E484400D6CBCB00AD98
      9800E1D9D900D2C6C60000000000000000000000000000000000000000000000
      0000A28A8A00DAD1D100754E4900D2B9A700000000000000000039393900F0CB
      C00000000000000000000000000000000000EEC5B90000000000000000000000
      000000000000C3A29800000000000000000000FFFF0000000000000000000000
      000000FFFF0000FFFF00000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF000000000000FFFF0000FFFF0000FFFF00000000000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      FF0000000000000000000000000000000000754E490094797900FBFAFA00FBFA
      FA00D6CBCB005C34340094797900E1D9D900F6F4F40000000000000000000000
      0000F6F4F4000000000094797900946F6300000000000000000011111100F0CD
      C20000000000EEC5B900EEC5B900EEC5B900EEC5B900EEC5B900EEC5B900EEC5
      B900EEC5B900C3A29800000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF00000080000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      00000000FF000000000000000000000000005F332E00AD989800B8A6A6000000
      0000FBFAFA00E1D9D90084615C00421818006E484400FBFAFA00000000000000
      000000000000B8A6A600AD9898007A554C000000000011111100000000001111
      1100000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF00000080000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000FF0000000000000000005F332E00AD989800B8A6A6000000
      00000000000000000000FBFAFA005C3434005C343400FBFAFA00000000000000
      000000000000B8A6A600AD9898007A554C00000000006A6A6A00F6C8BA00F4B8
      A600F1AA9400F0A68F00F0A68F00F0A68F00F0A68F00F0A68F00F0A68F00F0A6
      8F00F0A68F00C4887500C488750000000000FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000FF00000080000000
      FF000000FF000000FF000000FF000000FF000000FF0000000000000000000000
      000000000000000000000000FF0000000000754E49008B6E6E0000000000F6F4
      F400000000000000000000000000A8929200A892920000000000000000000000
      0000F6F4F4000000000094797900946F6300000000000000000095959500F7CF
      C300F0A68F00F1AA9400F0A68F00F0A68F00F0A68F00F0A68F00F0A68F00F0A6
      8F00F0A68F00F0A68F000000000000000000FFFFFF0000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000FF000000
      80000000FF000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000FF000000000000000000BCA092006E484400DAD1D100A68F
      8F00000000000000000000000000A68F8F00A68F8F0000000000000000000000
      0000A68F8F00DAD1D1006E484400D2B9A7000000000000000000000000009595
      9500F7CFC300F0A68F00F1AA9400F0A68F00F0A68F00F0A68F00F0A68F00F0A6
      8F00F0A68F00000000000000000000000000FFFFFF0000000000FFFFFF00FFFF
      FF0000000000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      FF00000080000000FF000000FF000000FF000000FF000000FF000000FF000000
      000000000000000000000000000000000000000000007A554C008B6E6E00D6CB
      CB00000000000000000000000000A28A8A00A28A8A0000000000000000000000
      0000D6CBCB008B6E6E007A554C00000000000000000000000000000000000000
      000095959500F7CFC300F4B8A600F1AA9400F0A68F00F0A68F00F0A68F00F0A6
      8F0000000000C48875000000000000000000FFFFFF0000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000FF00000080000000FF000000FF000000FF000000FF000000FF000000
      FF0000000000000000000000000000000000000000000000000055292600C7B9
      B900DAD1D100AD989800FBFAFA00B8A6A600B8A6A600F6F4F400A28A8A00DAD1
      D100C7B9B9005529260000000000000000000000000000000000000000000000
      00000000000095959500F7CFC300F4B8A600F1AA9400F0A68F00F3AF9B001111
      1100F1AA9400C48875000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000FF00000080000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000CCB2A2006339
      35008B6E6E00DAD1D100FBFAFA00C7B9B900C7B9B900FBFAFA00D2C6C6008E72
      720055292600CCB2A20000000000000000000000000000000000000000000000
      0000000000000000000095959500F8D0C400F4B8A600F4B8A600515151005151
      5100F3AF9B00C488750000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000080000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007A554C00754E49008E727200AD989800AD9898008E727200754E49007A55
      4C00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000095959500F7CFC30051515100000000008585
      8500F6C8BA00F1AA940000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DAC1AC00CCB2A20084615C005F332E005F332E0084615C00CCB2A200DAC1
      AC00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F000000000000000000C3A2
      9800959595006A6A6A0011111100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00FFFFFF00FFFF
      FF000000FF000000FF000000FF000000FF000000FF00FFFFFF00FFFFFF000000
      FF000000FF000000FF000000FF00FFFFFF0000FFFF000000000000FFFF0000FF
      FF000000000000FFFF0000FFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF00FFFF
      FF00FFFFFF000000FF000000FF000000FF000000FF000000FF00FFFFFF00FFFF
      FF000000FF000000FF000000FF000000FF0000FFFF0000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00FFFFFF00FFFFFF000000FF000000FF000000FF000000FF000000FF00FFFF
      FF00FFFFFF000000FF000000FF000000FF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF00FFFFFF00FFFFFF000000FF000000FF000000FF000000FF000000
      FF00FFFFFF00FFFFFF000000FF000000FF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FFFF0000FF
      FF0000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF000000FF000000FF000000
      FF000000FF000000FF00FFFFFF00FFFFFF000000FF000000FF000000FF000000
      FF000000FF00FFFFFF00FFFFFF000000FF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FFFF0000FF
      FF000000000000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF000000FF000000
      FF000000FF000000FF000000FF00FFFFFF00FFFFFF000000FF000000FF000000
      FF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF00FFFFFF00FFFFFF000000
      FF000000FF000000FF000000FF000000FF00FFFFFF00FFFFFF000000FF000000
      FF000000FF000000FF000000FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00FFFFFF00FFFF
      FF000000FF000000FF000000FF000000FF000000FF00FFFFFF00FFFFFF000000
      FF000000FF000000FF000000FF000000FF00FFFFFF0000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FFFF0000FF
      FF00000000000000000000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF00FFFF
      FF00FFFFFF000000FF000000FF000000FF000000FF000000FF00FFFFFF00FFFF
      FF000000FF000000FF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400848484008484840000000000F7FFFF00EFFFFF00F7FF
      FF00FFFFFF00EFF7E700D6DECE0084948400636B6B007B7B7B00D6D6D600FFFF
      FF00EFFFF700F7FFFF00FFFFFF00FFF7F700000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400848484008484840084848400FFFFFF00F7FFFF00F7FFFF00FFFF
      FF00CEB5B500AD8C8400C6A59C00EFD6C600847B7B00B5ADAD008C8484008C84
      8400EFF7EF00FFFFFF00EFF7EF00FFFFFF00000000000000000000FFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C6000000000000FF
      000000FF000000FF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400000000000000000084848400848484008484840084848400000000000000
      000084848400848484008484840084848400FFF7FF00FFFFFF00F7F7F700EFE7
      DE00C69C9400F7BDB500FFBDB500FFC6BD008C737300A58C8C00B59CA5007363
      6300FFFFFF00F7F7F700FFFFFF00F7FFFF000000000000000000BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD000000000000FF000000FF
      000000FF000000FF000000FF000000000000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE00008484840084848400848484008484
      8400000000000000000084848400848484008484840000000000000000008484
      840084848400848484008484840084848400F7F7FF00FFFFFF00FFFFF700EFDE
      DE00CE9C9C00F7BDB500FFB5AD00FFCEBD008C847B00A5A59C00ADA5A500B5A5
      AD00E7D6D600FFFFFF00FFFFFF00F7FFFF000000000000000000BDBDBD000000
      0000BDBDBD0000000000BDBDBD00000000000000000000FF000000FF000000FF
      000000FF000000FF000000FF000000000000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE00008484840084848400848484008484
      8400000000000000000084848400848484000000000000000000848484008484
      840084848400848484008484840084848400FFFFFF00FFFFFF00FFFFFF00CEC6
      BD00C6AD9C00F7C6B500FFCEB500FFD6C60084847B00E7EFE70063737300BDC6
      C600DED6DE00FFFFFF00F7F7F700FFFFFF000000000000000000BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD000000000000000000000000000000
      000000000000000000000000000000000000FFCE000084848400848484008484
      840084848400848484008484840084848400848484008484840084848400FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE00008484840084848400848484008484
      8400000000000000000084848400000000000000000084848400848484008484
      840084848400848484008484840084848400FFFFFF00F7FFFF00F7FFF700B5AD
      A500DEBDB500FFCEBD00DEA59400AD7B63005A423900E7E7DE004A636300ADBD
      BD00DEDEE700FFF7FF00FFFFFF00F7FFFF000000000000000000BDBDBD000000
      0000BDBDBD00000000000000000000000000BDBDBD0000000000BDBDBD000000
      000000000000000000000000000000000000FFCE000084848400C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60084848400FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE00008484840084848400848484008484
      8400000000000000000000000000000000000000000000000000848484008484
      840084848400848484008484840084848400FFFFFF00F7F7F700FFFFFF00BDA5
      9C00B5847300944231007B1808007B1808005A100800B58C84006B736B0094A5
      A5007B848C00FFEFF700FFFFFF00F7FFFF000000000000000000BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400C6C6C6000000
      FF00C6C6C600C6C6C600C6C6C600C6C6C6000000FF00C6C6C600848484000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400000000000000000084848400848484008484840000000000000000008484
      840084848400848484008484840084848400F7F7FF00FFFFFF00FFFFFF007B52
      4A0063100800841000008C080000940800009410100094424200E7D6D6006B73
      7B009494A500FFFFFF00F7FFFF00EFFFFF000000000000000000BDBDBD000000
      0000BDBDBD0000000000BDBDBD0000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000084848400C6C6C6000000
      FF00C6C6C600C6C6C600C6C6C600C6C6C6000000FF00C6C6C600848484000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400000000000000000084848400848484008484840000000000000000008484
      840084848400848484008484840084848400FFFFFF00F7FFFF00FFFFFF00F7F7
      EF00A5847B005A181000630000008C1008006B080800946B6B008C9484008C7B
      7B00FFF7F700F7FFFF00F7FFFF000000000000000000BDBDBD00BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000084848400C6C6C6000000
      FF000000FF000000FF000000FF000000FF000000FF00C6C6C600848484000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400000000000000000084848400848484008484840000000000000000008484
      84008484840084848400848484008484840000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00CEADA50094635A00A5635A00847363009CA59400DEEFDE00B5BD
      AD00FFFFFF00F7FFFF00F7FFFF00FFFFFF0000000000BDBDBD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000084848400C6C6C6000000
      FF00C6C6C600C6C6C600C6C6C600C6C6C6000000FF00C6C6C600848484000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400000000000000000000000000000000000000000000000000848484008484
      840084848400848484008484840084848400FFFFFF00F7F7F700F7F7F700FFFF
      FF00FFFFFF00FFFFFF00FFFFF700FFF7F700A5B5A5006B635200CEADA500B5AD
      A500F7FFFF00FFFFFF0000000000FFFFFF0000000000BDBDBD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF00000000000000000000000000FFCE000084848400C6C6C6000000
      FF00C6C6C600C6C6C600C6C6C600C6C6C6000000FF00C6C6C60084848400FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000FFFFFF0084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400FFFFFF00FFFFFF00F7F7F700FFFFFF00FFFF
      FF00F7F7F700F7FFFF00EFFFFF00EFFFFF00DECEC6005A0808008C212900C694
      9400FFFFF700FFFFFF00FFFFF700FFFFFF0000000000BDBDBD00000000000000
      000000000000000000000000000000000000000000000000000000000000BDBD
      BD0000000000000000000000000000000000FFCE000084848400C6C6C600C6C6
      C6000000FF000000FF000000FF000000FF00C6C6C600C6C6C60084848400FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000FFFFFF00FFFFFF00848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840084848400FFFFFF00FFFFFF00EFFFFF00FFFFFF00FFFFFF00FFF7
      F700FFFFFF00FFFFFF00EFEFF700EFF7FF00FFF7EF00944A4A0094293100FFCE
      CE00FFFFF700FFFFFF00FFFFF700FFFFFF0000000000BDBDBD00000000000000
      000000000000000000000000000000000000000000000000000000000000BDBD
      BD0000000000000000000000000000000000FFCE000084848400C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60084848400FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00848484008484840084848400848484008484840084848400848484008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7FFFF00FFFFFF0000000000FFF7
      F70000000000FFFFFF00FFFFFF00FFFFFF00DEFFFF00C6CEC6009C848400FFFF
      FF00F7FFFF00FFFFFF00FFFFFF00FFFFFF0000000000BDBDBD00000000000000
      000000000000000000000000000000000000000000000000000000000000BDBD
      BD0000000000000000000000000000000000FFCE000084848400848484008484
      840084848400848484008484840084848400848484008484840084848400FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084848400848484008484840084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7F7F700FFFFFF00FFFF
      FF00F7F7F70000000000FFFFFF00FFF7F700EFFFFF00DEFFF7008CADA500F7FF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000BDBDBD00BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000EFF7
      F700F7FFFF00FFFFFF00FFFFF700FFFFFF00FFEFFF00FFF7FF0094ADAD00F7EF
      EF0000000000FFFFFF00E7F7F700FFFFFF007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DE9C6B00E7AD7300E7B5
      8400F7CEA500F7C69400FFCE9C00FFD6A500FFDEAD00FFE7AD00FFEFC600FFE7
      B500FFE7BD00FFE7BD00FFE7B500FFE7B50000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000FF0000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6632900CE843100D68C4200DE9C
      5200EFB57B00EFAD6B00FFB57300FFBD7B00FFCE8400FFDEA500FFD69400FFD6
      9400FFD69400FFDEAD00FFD69400FFD6940000000000000000000000000000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C6000000
      000000FF000000FF000000FF00000000000000000000000000000000000000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C600000000000000FF000000
      FF000000FF000000FF000000FF000000FF0000FFFF000000000000FFFF0000FF
      FF000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000FFFF0000FFFF0000FFFF00C66B2100CE7B3100D6844200DE94
      5200EFAD7B00EFA56300EFAD6B00FFBD7300FFCE9400FFCE9400FFC68400FFCE
      8400FFCE8C00FFD6AD00FFCE8C00FFCE8400000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD000000000000FF
      000000FF000000FF000000FF000000FF0000000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00000000000000
      FF000000FF000000FF000000FF000000FF0000FFFF000000000000FFFF0000FF
      FF000000000000FFFF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FF
      FF000000000000FFFF0000FFFF0000FFFF00C66B2100CE7B2900CE843900DE94
      4A00E7A56B00E7A55A00EFA56300F7AD7300FFC69400FFBD7B00FFBD7B00FFC6
      8400FFC68400FFE7C600FFEFD600FFCE9C00000000000000000000000000BDBD
      BD0000000000BDBDBD0000000000BDBDBD00000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF0000000000000000000000000000BDBD
      BD0000000000BDBDBD0000000000BDBDBD0000000000BDBDBD00BDBDBD000000
      00000000FF000000FF000000FF000000000000FFFF000000000000FFFF0000FF
      FF000000000000FFFF0000000000000000000000000000FFFF0000FFFF0000FF
      FF000000000000FFFF0000FFFF0000FFFF00BD631800C6732100CE7B3100D68C
      4A00DEA56300DE945200E79C5A00F7BD8400EFB57300F7B57300F7B57300F7BD
      7B00FFCE9C00FFFFF700FFFFFF00FFEFDE00000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD0000000000BDBD
      BD00000000000000FF00000000000000000000FFFF0000000000000000000000
      000000FFFF0000FFFF0000FFFF000000000000FFFF0000FFFF000000000000FF
      FF000000000000FFFF0000FFFF0000FFFF00BD631000C66B1800CE732900D684
      3900DE9C6300DE944A00E79C5A00EFB57B00E7AD6B00EFBD8400F7C69400F7C6
      9400F7BD8C00F7D6B500FFEFDE00F7C69400000000000000000000000000BDBD
      BD0000000000BDBDBD00000000000000000000000000BDBDBD0000000000BDBD
      BD0000000000000000000000000000000000000000000000000000000000BDBD
      BD0000000000BDBDBD00000000000000000000000000BDBDBD0000000000BDBD
      BD000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      00000000000000FFFF0000FFFF0000FFFF00BD5A1000BD631000C66B1800CE7B
      3100DEA56300D6944A00EFCEA500EFBD8C00EFB57B00E7AD6B00E7A55A00E7A5
      6300E7A56300E7A56300EFB57B00EFB57B00000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD0000000000000000000000000000000000000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000FFFF0000FFFF0000FFFF00B54A0800BD5A0800BD631000CE84
      3900EFCEAD00DEAD7B00F7DEC600DE9C5200DE944A00DE944A00DE945200DE9C
      5200DE9C5200DE9C5A00DE9C5200EFBD8C00000000000000000000000000BDBD
      BD0000000000BDBDBD0000000000BDBDBD0000000000BDBDBD0000000000BDBD
      BD0000000000000000000000000000000000000000000000000000000000BDBD
      BD0000000000BDBDBD0000000000BDBDBD0000000000BDBDBD0000000000BDBD
      BD0000000000000000000000000000000000FFFFFF0000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00AD420800B5520800C6631000D6A5
      6300EFD6B500D6944A00DE9C5200CE843900DE8C4200D68C4200DE8C4200DE8C
      4A00DE8C4A00DE944A00D68C4A00E7AD7B000000000000000000BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD000000000000000000000000000000000000000000BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD00000000000000000000000000FFFFFF0000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00A5390800BD5A1800C67B3100C66B
      1000D69C5A00DEA56B00CE843100CE7B2900D6843100D6843900CE843900D684
      3900D68C4200D6844200D68C4200E7B584000000000000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD000000000000000000000000000000000000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD00000000000000000000000000FFFFFF0000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00AD391800BD5A2900B54A0800BD63
      0800EFCEA500FFF7EF00DE9C5A00C6732100CE7B2900CE7B2900CE7B3100CE7B
      3100CE7B3100CE843100CE7B3100D68C42000000000000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD000000000000000000000000000000000000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD00000000000000000000000000FFFFFF0000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00A5392900A5310800AD4A0000CE7B
      3900FFF7EF00FFFFFF00EFDEC600DE9C5A00E79C6300DEA56300DEA56B00D69C
      6300D68C4200C67B2900CE7B2900CE8431000000000000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD000000000000000000000000000000000000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008C181000A5391800C6734A00BD63
      2100DEAD7B00FFFFF700DEAD7300BD631000CE6B1000C66B1800C6732100CE84
      3100D6945200DEA56B00DEA57300E7BD8C000000000000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD000000000000000000000000000000000000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084181000B55242009C310000AD39
      0800B55A1000DEA56300D69C5A00C66B1800CE732100CE7B2900CE7B3100CE7B
      3900CE7B3100CE843900CE8C4200F7E7D6000000000000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD000000000000000000000000000000000000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C4A420084181000941800009C31
      0000AD420800CE8C4A00D69C6300C67B3100CE7B3100CE7B3900CE843900CE84
      4200CE844200CE844200CE844200DEAD7B000000000000000000BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD000000000000000000000000000000000000000000BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6B5B5006B100800840800009421
      0800A5310000CE8C5200C6843900DEAD7B00CE844200CE8C4200CE8C4A00CE8C
      4A00CE8C5200CE8C5200CE8C5200DEA57300000000007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B000000000000000000000000007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CED6D600CED6D600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000CED6D6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CED6D600CED6D60084848400CECE
      CE00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECE
      CE00CECECE00CECECE0000000000CED6D6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000C6C6C600C6C6
      C600000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CED6D600CED6D60084848400DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE0063636300DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00CECECE0000000000CED6D6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000C6C6C600C6C6
      C600000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CED6D600CED6D60084848400FFFF
      FF00DEDEDE00DEDEDE00DEDEDE006363630063636300DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00CECECE0000000000CED6D6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000C6C6C600C6C6
      C600000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CED6D600CED6D60084848400FFFF
      FF00E7E7E700E7E7E7006363630063636300636363006363630063636300DEDE
      DE00DEDEDE00CECECE0000000000CED6D6000000000000000000000000000000
      000000000000FF9C310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF9C31000000
      000000000000000000000000000000000000CED6D600CED6D60084848400FFFF
      FF00EFEFEF00EFEFEF00E7E7E7006363630063636300DEDEDE00B5B5B5006363
      6300DEDEDE00CECECE0000000000CED6D6000000000000000000000000000000
      0000FF9C3100FF9C310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF9C3100FF9C
      310000000000000000000000000000000000CED6D600CED6D60084848400FFFF
      FF00EFEFEF00EFEFEF00EFEFEF00E7E7E70063636300DEDEDE00DEDEDE006363
      6300DEDEDE00CECECE0000000000CED6D600000000000000000000000000FF9C
      3100FFCE3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C
      3100FF9C31000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      000000848400008484000000000000000000000000000000000000000000FF9C
      3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C3100FF9C3100FFCE
      3100FF9C3100000000000000000000000000CED6D600CED6D60084848400FFFF
      FF00EFEFEF0063636300EFEFEF00EFEFEF00E7E7E700DEDEDE00DEDEDE006363
      6300DEDEDE00CECECE0000000000CED6D6000000000000000000FF633100FFFF
      9C00FFFF9C00FFFF9C00FFFF9C00FFFF9C00FFFF9C00FFFF9C00FFFF9C00FFFF
      9C00FF9C31000000000000000000000000000000000000000000008484000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C60000000000008484000000000000000000000000000000000000000000FF9C
      3100FFFF9C00FFFF9C00FFFF9C00FFFF9C00FFFF9C00FFFF9C00FFFF9C00FFFF
      9C00FFFF9C00FF6331000000000000000000CED6D600CED6D60084848400FFFF
      FF00FFFFFF0063636300EFEFEF00EFEFEF0063636300E7E7E700DEDEDE00DEDE
      DE00DEDEDE00CECECE0000000000CED6D600000000000000000000000000FF63
      3100FFFF9C00FFFF9C0000000000FF633100FF633100FF633100FF633100FF63
      3100FF6331000000000000000000000000000000000000000000008484000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C60000000000008484000000000000000000000000000000000000000000FF63
      3100FF633100FF633100FF633100FF633100FF63310000000000FFFF9C00FFFF
      9C00FF633100000000000000000000000000CED6D600CED6D60084848400FFFF
      FF00FFFFFF0063636300B5B5B500EFEFEF006363630063636300E7E7E700DEDE
      DE00DEDEDE00CECECE0000000000CED6D6000000000000000000000000000000
      0000FF633100FFFF9C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF9C00FF63
      310000000000000000000000000000000000CED6D600CED6D60084848400FFFF
      FF00FFFFFF00FFFFFF006363630063636300636363006363630063636300DEDE
      DE00DEDEDE00CECECE0000000000CED6D6000000000000000000000000000000
      000000000000FF63310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF6331000000
      000000000000000000000000000000000000CED6D600CED6D60084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF006363630063636300EFEFEF00E7E7
      E700CECECE00CECECE0000000000CED6D6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CED6D600CED6D60084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0063636300EFEFEF00EFEFEF000000
      0000000000000000000000000000CED6D6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C60000000000C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CED6D600CED6D60084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00EFEFEF008484
      8400FFFFFF0000000000CED6D600CED6D6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CED6D600CED6D60084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00EFEFEF008484
      840000000000CED6D600CED6D600CED6D6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CED6D600CED6D600848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400CED6D600CED6D600CED6D600CED6D6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B0000FFFF0000FFFF0000FFFF0000FFFF000000
      000000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B0000FFFF00000000000000000000FFFF000000
      000000FFFF0000FFFF0000FFFF000000000000FFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000FFFF000000000000FF
      FF0000000000000000000000000000FFFF00CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000007B7B7B007B7B7B0000FFFF0000FFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF000000000000FFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF000000000000FFFF000000000000FFFF0000FF
      FF000000000000FFFF0000FFFF0000FFFF00FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000007B7B7B007B7B7B0000FFFF0000FFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF000000000000FFFF0000FFFF00000000000000
      00000000000000FFFF0000FFFF000000000000FFFF0000FFFF000000000000FF
      FF0000FFFF000000000000FFFF0000FFFF00FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000007B7B7B007B7B7B00FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF00000000000000FFFF0000FFFF000000000000FF
      FF0000FFFF000000000000FFFF000000000000FFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF000000000000FFFF00FFCE000084848400848484008484
      840084848400848484008484840084848400848484008484840084848400FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE000000FFFF00000000000000000000FF
      FF00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF0000FFFF0000000000000000
      0000FFFF0000FFFF0000FFFF00000000000000FFFF0000FFFF00000000000000
      00000000000000FFFF0000FFFF0000FFFF00000000000000000000FFFF0000FF
      FF00000000000000000000FFFF0000FFFF00FFCE000084848400C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60084848400FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE000000FFFF00000000000000000000FF
      FF00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF0000FFFF0000000000000000
      0000FFFF0000FFFF0000FFFF00000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF00CE9C000084848400C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60084848400CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF000000000000FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00CE9C000084848400C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60084848400CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C0000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00CE9C000084848400C6C6C6000000
      FF000000FF000000FF000000FF000000FF000000FF00C6C6C60084848400CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C0000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00CE9C000084848400C6C6C6000000
      FF000000FF000000FF000000FF000000FF000000FF00C6C6C60084848400CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C0000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFF
      FF000000000000000000FFFFFF00FFFFFF00FFCE000084848400C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60084848400FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000FFFFFF000000000000000000FFFF
      FF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFCE000084848400C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60084848400FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000FFFFFF000000000000000000FFFF
      FF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007B7B7B000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFCE000084848400C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60084848400FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFCE000084848400848484008484
      840084848400848484008484840084848400848484008484840084848400FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000084840000848400008484000084
      8400008484000000000000000000000000000000000000000000000000000000
      0000FFCE00000000000000000000000000000000000000000000FFCE00000000
      000000000000000000000000000000000000000000000000000000000000BDBD
      BD0000000000BDBDBD0000000000BDBDBD0000000000BDBDBD0000000000BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000084840000000000000000000000000000000000FFCE
      0000FFCE0000FFCE0000000000000000000000000000FFCE0000FFCE0000FFCE
      000000000000000000000000000000000000000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C60000000000C6C6
      C60000000000C6C6C60000000000000000000000000000000000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE000000000000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000000000000000000000000000000000000000000000000000BDBD
      BD0000000000BDBDBD00000000000000000000000000BDBDBD0000000000BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400000000000000000000000000000000000000
      0000FFCE00000000000000000000000000000000000000000000FFCE00000000
      000000000000000000000000000000000000000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFCE00000000000000000000000000000000000000000000FFCE00000000
      000000000000000000000000000000000000000000000000000000000000BDBD
      BD0000000000BDBDBD0000000000BDBDBD0000000000BDBDBD0000000000BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000FFCE00000000000000000000000000000000000000000000FFCE00000000
      0000000000000000000000000000000000000000000000000000BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFCE00000000000000000000000000000000000000000000FFCE00000000
      0000000000000000000000000000000000000000000000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFCE00000000000000000000000000000000000000000000FFCE00000000
      0000000000000000000000000000000000000000000000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFCE00000000000000000000000000000000000000000000FFCE00000000
      0000000000000000000000000000000000000000000000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFCE00000000000000000000000000000000000000000000FFCE00000000
      0000000000000000000000000000000000000000000000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBDBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BDBDBD00BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084000000FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000007B7B7B0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF00840000008400000084000000FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000000000000000000000000000000000000000FFFFFF007B7B7B007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B7B7B007B7B7B00FFFFFF0000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      0000000000007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF008400
      0000840000008400000084000000FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF007B7B7B007B7B7B0000FFFF00000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000FF000000FF000000
      00000000000000000000C6C6C600000000000000000000000000C6C6C6000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000007B7B7B0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000840000008400
      000084000000FFFFFF008400000084000000FFFFFF00FFFFFF00000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF000000000000FFFF0000000000000000000000FF000000
      FF00000000000000000000000000C6C6C60000000000C6C6C600000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      0000000000007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000084000000840000008400
      0000FFFFFF0000000000000000008400000084000000FFFFFF00000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF007B7B7B000000000000FFFF0000FFFF000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000000000000000000000000000000000000000000000FF000000
      FF0000000000000000000000000000000000C6C6C60000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      0000000000007B7B7B0000000000CE9C0000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C000000000000000000000000000084000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00000000000000
      00000000000000000000000000000000000000000000FFFFFF007B7B7B000000
      00007B7B7B00FFFFFF0000FFFF0000FFFF00000000000000000000FFFF0000FF
      FF00000000000000000000FFFF0000FFFF000000000000000000000000000000
      FF000000FF000000000000000000C6C6C60000000000C6C6C600000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00CE9C0000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000084000000FFFFFF000000
      00000000000000000000000000000000000000000000000000007B7B7B00FFFF
      0000FFFF0000FFFF000000FFFF0000FFFF0000FFFF000000000000FFFF000000
      00000000000000FFFF0000FFFF0000FFFF000000000000000000000000000000
      FF000000FF0000000000C6C6C600000000000000000000000000C6C6C6000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000CE9C0000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084000000FFFF
      FF0000000000000000000000000000000000000000007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B0000FFFF0000FFFF0000FFFF0000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      FF000000FF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00CE9C0000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000000000000000000000000000FFFFFF000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000008400
      0000FFFFFF0000000000000000000000000000000000000000007B7B7B00FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000
      0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      FF000000FF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000084000000FFFFFF00000000000000000000000000000000007B7B7B000000
      00007B7B7B00FFFFFF00FFFF000000000000FFFF0000FFFF0000000000000000
      00000000000000000000FFFF0000FFFF00000000000000000000000000000000
      0000000000000000FF000000FF000000000000000000000000000000FF000000
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000FFFFFF00FFFFFF0000000000FFFFFF0000000000000000000000
      00000000000084000000FFFFFF00000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000FFFF000000000000FFFF0000000000000000
      0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      0000000000000000FF000000FF000000000000000000000000000000FF000000
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000084000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FFFF000000000000000000000000
      0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      000000000000000000000000FF000000FF00000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000000000000000
      0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000
      000000000000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000
      000000000000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0084000000FFFFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000840000008400000084000000FFFFFF0000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000000000840000008400000084000000FFFFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B00000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000840000008400000084000000FFFFFF0000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0084000000840000008400000084000000FFFFFF0000FFFF0000FFFF000000
      000000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000007B7B7B00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000008400
      0000840000000000000000000000000000000084840000848400008484000084
      8400008484000000000000000000000000000000000000000000000000008400
      00008400000084000000FFFFFF008400000084000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000FFFF008400
      00008400000084000000FFFFFF008400000084000000FFFFFF00000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000007B7B7B00BDBDBD000000000000000000BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000008400000084000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000848400000000000000000000000000840000008400
      000084000000FFFFFF0000000000000000008400000084000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000840000008400
      000084000000FFFFFF000000000000FFFF008400000084000000FFFFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000007B7B7B00BDBDBD000000000000000000BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000008400
      000084000000000000000000000000000000FFFFFF00C6C6C600FFFFFF00C6C6
      C600FFFFFF00C6C6C60000000000000000000000000000000000000000008400
      0000FFFFFF000000000000000000000000000000000084000000FFFFFF000000
      000000000000000000000000000000000000000000000000000000FFFF008400
      0000FFFFFF00000000000000000000FFFF000000000084000000FFFFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000007B7B7B00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084000000FFFF
      FF0000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000FFFF0084000000FFFF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000FFFFFF000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF00008400
      0000FFFFFF00FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00848484008484
      8400FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000FFFFFF0000000000000000000000000000000000FFFF0000FFFF
      000000000000FFFF0000FFFF000000000000000000000000000000000000FFFF
      000084000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084000000FFFFFF00000000000000000000000000FFFF0000FFFF
      0000FFFF000000000000FFFF00000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF000084000000FFFFFF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000FFFFFF000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF000084000000FFFFFF00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF00000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF00000000000084000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF0084848400FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF00000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF0084848400FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF00000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007B7B7B00000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF00000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF007B7B7B00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF007B7B7B007B7B7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF007B7B7B007B7B7B007B7B7B00000000000000000000000000C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF007B7B
      7B007B7B7B007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF007B7B7B007B7B
      7B007B7B7B0000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C60000FFFF0000FFFF0000FFFF00C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B000000000000000000000000007B7B7B000000000000FFFF007B7B7B000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF007B7B7B007B7B7B007B7B7B0000000000FFFFFF007B7B7B007B7B7B007B7B
      7B000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600848484008484840084848400C6C6C600C6C6
      C60000000000C6C6C60000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B00000000000000000000FFFF000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C600C6C6C600000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF000000
      00000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF00BDBDBD00FFFFFF00BDBDBD00FFFFFF007B7B7B0000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00FFFFFF000000
      00000000000000000000FFFFFF0000000000000000007B7B7B00FFFFFF000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000C6C6C60000000000C6C6C600000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000007B7B7B007B7B7B00FFFFFF00BDBD
      BD00FFFFFF000000FF00FFFFFF00BDBDBD00FFFFFF007B7B7B007B7B7B000000
      000000000000000000000000000000000000000000007B7B7B00000000000000
      0000000000007B7B7B00FFFFFF0000000000000000007B7B7B0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00BDBDBD00FFFF
      FF00BDBDBD000000FF00BDBDBD00FFFFFF00BDBDBD007B7B7B00000000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF00000000000000
      0000FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00000000007B7B7B00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C6C6C60000000000C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00FFFFFF000000
      FF000000FF000000FF000000FF000000FF00FFFFFF007B7B7B00000000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF00000000007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B0000000000000000007B7B7B00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00BDBDBD00FFFF
      FF00BDBDBD000000FF00BDBDBD00FFFFFF00BDBDBD007B7B7B00000000000000
      0000000000000000000000000000000000007B7B7B0000000000FFFFFF000000
      0000000000007B7B7B00FFFFFF000000000000000000000000007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000007B7B7B007B7B7B00FFFFFF00BDBD
      BD00FFFFFF000000FF00FFFFFF00BDBDBD00FFFFFF007B7B7B007B7B7B000000
      000000000000000000000000000000000000000000007B7B7B00FFFFFF000000
      0000000000007B7B7B000000000000000000000000007B7B7B00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF00BDBDBD00FFFFFF00BDBDBD00FFFFFF007B7B7B0000000000000000000000
      000000000000000000000000000000000000000000007B7B7B0000000000FFFF
      FF00FFFFFF00000000000000000000000000FFFFFF007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B0000000000FFFFFF00FFFFFF007B7B7B007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B000000000000000000000000007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B007B7B7B007B7B7B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000000000000000000000000000000
      000000000000000000000000000000000000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE00000000000000000000000000000000
      000000000000000000000000000000FF00000000000000000000000000000000
      000000000000000000000000000000000000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE00000000000000000000000000000000
      0000000000000000000000FF000000FF000000FF000000000000000000000000
      000000000000000000000000000000000000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE00000000000000000000000000000000
      0000000000000000000000FF000000FF000000FF000000000000000000000000
      000000000000000000000000000000000000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFCE00000000000000000000FFCE
      0000FFCE00000000000000000000FFCE0000FFCE00000000000000000000FFCE
      0000FFCE00000000000000000000FFCE00000000000000000000000000000000
      00000000000000FF000000FF000000FF000000FF000000FF0000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF00000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C0000FFCE00000000000000000000FFCE
      0000FFCE00000000000000000000FFCE0000FFCE00000000000000000000FFCE
      0000FFCE00000000000000000000FFCE00000000000000000000000000000000
      00000000000000FF000000FF000000FF000000FF000000FF0000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FFFFFF00C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C0000FFCE0000FFCE0000000000000000
      00000000000000000000FFCE0000FFCE0000FFCE0000FFCE0000000000000000
      00000000000000000000FFCE0000FFCE00000000000000000000000000000000
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF00000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF00000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C0000FFCE0000FFCE0000000000000000
      00000000000000000000FFCE0000FFCE0000FFCE0000FFCE0000000000000000
      00000000000000000000FFCE0000FFCE00000000000000000000000000000000
      000000000000000000000000000000FF00000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FFFFFF00C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C0000FFCE00000000000000000000FFCE
      0000FFCE00000000000000000000FFCE0000FFCE00000000000000000000FFCE
      0000FFCE00000000000000000000FFCE00000000000000000000000000000000
      000000000000000000000000000000FF00000000000000000000000000000000
      000000000000000000000000000000000000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CE9C00000000000000000000CE9C
      0000CE9C00000000000000000000CE9C0000CE9C00000000000000000000CE9C
      0000CE9C00000000000000000000CE9C00000000000000000000000000000000
      000000000000000000000000000000FF00000000000000000000000000000000
      000000000000000000000000000000000000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C00000000000000000000000000000000
      000000000000000000000000000000FF00000000000000000000000000000000
      000000000000000000000000000000000000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C00000000000000000000000000000000
      000000000000000000000000000000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00FFFFFF000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000007B7B7B00FFFFFF00000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00FFFFFF000000
      000000000000000000007B7B7B007B7B7B007B7B7B0000000000000000000000
      0000000000007B7B7B00FFFFFF00000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B007B7B7B007B7B7B00FFFFFF00FFFFFF00000000007B7B7B007B7B
      7B00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00FFFFFF000000
      00000000000000000000000000007B7B7B00FFFFFF0000000000000000000000
      0000000000007B7B7B00FFFFFF000000000000000000000000000000FF000000
      FF0000000000000000007B7B7B00000000007B7B7B00000000000000FF000000
      FF000000FF0000000000000000000000000000000000000000007B7B7B007B7B
      7B00FFFFFF00FFFFFF00000000007B7B7B0000000000FFFFFF00000000007B7B
      7B007B7B7B00FFFFFF00FFFFFF0000000000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000000000007B7B7B00FFFFFF000000
      000000000000000000007B7B7B007B7B7B00FFFFFF0000000000000000000000
      0000000000007B7B7B00FFFFFF0000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000000000000000000000007B7B7B007B7B7B007B7B
      7B007B7B7B00FFFFFF007B7B7B007B7B7B007B7B7B00FFFFFF00000000000000
      00007B7B7B007B7B7B00FFFFFF0000000000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000000000007B7B7B00FFFFFF000000
      00000000000000000000000000007B7B7B000000000000000000000000000000
      0000000000007B7B7B00FFFFFF0000000000000000000000FF00000000000000
      FF000000FF000000FF007B7B7B00000000007B7B7B0000000000000000000000
      00000000FF000000FF000000000000000000000000007B7B7B00FFFFFF007B7B
      7B007B7B7B007B7B7B00000000007B7B7B000000000000000000000000000000
      0000000000007B7B7B00FFFFFF00FFFFFF00FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE0000FFCE
      0000FFCE0000FFCE0000FFCE0000FFCE0000000000007B7B7B00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF000000
      0000FFFFFF007B7B7B00FFFFFF00000000000000FF000000FF00000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000FF000000FF00000000007B7B7B007B7B7B00FFFFFF000000
      00007B7B7B007B7B7B007B7B7B00FFFFFF00FFFFFF0000000000000000000000
      0000000000007B7B7B007B7B7B00FFFFFF00FFCE00000000000000000000FFCE
      0000FFCE00000000000000000000FFCE0000FFCE00000000000000000000FFCE
      0000FFCE00000000000000000000FFCE0000000000007B7B7B007B7B7B007B7B
      7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B
      7B00FFFFFF007B7B7B00FFFFFF00000000000000FF000000FF00000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      0000000000000000FF000000FF00000000007B7B7B007B7B7B00FFFFFF000000
      0000000000007B7B7B00000000007B7B7B00FFFFFF00FFFFFF00000000000000
      0000000000007B7B7B007B7B7B00FFFFFF00FFFFFF000000000000000000FFFF
      FF00FFFFFF000000000000000000FFFFFF00FFFFFF000000000000000000FFFF
      FF00FFFFFF000000000000000000FFFFFF00000000007B7B7B00FFFFFF007B7B
      7B00FFFFFF007B7B7B007B7B7B007B7B7B00FFFFFF007B7B7B007B7B7B007B7B
      7B00FFFFFF007B7B7B00FFFFFF00000000000000FF000000FF00000000000000
      000000000000000000007B7B7B00000000007B7B7B0000000000000000000000
      0000000000000000FF000000FF00000000007B7B7B007B7B7B00FFFFFF000000
      00000000000000000000000000007B7B7B007B7B7B00FFFFFF00FFFFFF000000
      0000000000007B7B7B007B7B7B00FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF00000000007B7B7B00FFFFFF007B7B
      7B00FFFFFF007B7B7B00000000007B7B7B00000000007B7B7B007B7B7B007B7B
      7B00FFFFFF007B7B7B00FFFFFF00000000000000FF000000FF00000000000000
      000000000000000000000000840000000000000084000000FF00000000000000
      0000000000000000FF000000FF00000000007B7B7B007B7B7B00FFFFFF000000
      000000000000000000007B7B7B007B7B7B007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00000000007B7B7B007B7B7B00FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF00000000007B7B7B00FFFFFF007B7B
      7B0000000000000000007B7B7B0000000000000000007B7B7B00000000007B7B
      7B00FFFFFF007B7B7B00FFFFFF00000000000000FF000000FF00000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000FF000000FF00000000007B7B7B007B7B7B00FFFFFF00FFFF
      FF0000000000000000007B7B7B007B7B7B007B7B7B00000000007B7B7B00FFFF
      FF00FFFFFF007B7B7B007B7B7B0000000000FFFFFF000000000000000000FFFF
      FF00FFFFFF000000000000000000FFFFFF00FFFFFF000000000000000000FFFF
      FF00FFFFFF000000000000000000FFFFFF00000000007B7B7B00FFFFFF000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B007B7B7B00FFFFFF0000000000000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000FF000000000000000000000000007B7B7B0000000000FFFF
      FF00FFFFFF00000000007B7B7B007B7B7B007B7B7B00000000007B7B7B007B7B
      7B00FFFFFF007B7B7B00FFFFFF0000000000CE9C00000000000000000000CE9C
      0000CE9C00000000000000000000CE9C0000CE9C00000000000000000000CE9C
      0000CE9C00000000000000000000CE9C0000000000007B7B7B00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFF
      FF00000000007B7B7B000000000000000000000000000000FF000000FF000000
      FF000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000000000000000000000007B7B7B007B7B7B000000
      0000FFFFFF00FFFFFF007B7B7B007B7B7B007B7B7B00FFFFFF007B7B7B007B7B
      7B007B7B7B007B7B7B000000000000000000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C0000000000007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00FFFF
      FF007B7B7B0000000000000000000000000000000000000000000000FF000000
      FF000000FF00000000007B7B7B00000000007B7B7B0000000000000000000000
      FF000000FF0000000000000000000000000000000000000000007B7B7B007B7B
      7B0000000000FFFFFF00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF007B7B
      7B007B7B7B00000000000000000000000000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C0000CE9C
      0000CE9C0000CE9C0000CE9C0000CE9C0000000000007B7B7B00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B007B7B7B000000000000000000000000007B7B7B007B7B7B007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007B7B7B00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B007B7B7B00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      00007B7B7B007B7B7B00000000007B7B7B007B7B7B00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B007B7B7B007B7B7B007B7B7B00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B007B7B7B00FFFFFF00000000007B7B7B007B7B7B00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B007B7B7B007B7B7B007B7B7B00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000000000007B7B7B000000
      0000000000007B7B7B007B7B7B00FFFFFF00000000007B7B7B007B7B7B00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000000000007B7B7B00000000000000
      000000000000000000007B7B7B007B7B7B00FFFFFF00000000007B7B7B007B7B
      7B00FFFFFF0000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000007B7B7B00FFFFFF00000000000000
      00000000000000000000000000007B7B7B007B7B7B00FFFFFF00000000007B7B
      7B007B7B7B00FFFFFF000000000000000000000000007B7B7B000000FF000000
      FF0000000000000000000000FF000000FF000000FF0000000000000000000000
      000000000000000000000000000000000000000000007B7B7B007B7B7B007B7B
      7B007B7B7B00000000007B7B7B007B7B7B007B7B7B007B7B7B00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF000000
      0000FFFFFF000000000000000000000000007B7B7B007B7B7B00FFFFFF000000
      00000000000000000000FFFFFF00000000007B7B7B007B7B7B00FFFFFF000000
      00007B7B7B007B7B7B00FFFFFF00000000007B7B7B000000FF00000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000007B7B7B007B7B7B007B7B7B000000
      00000000000000000000000000007B7B7B007B7B7B007B7B7B00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF000000
      0000FFFFFF00000000000000000000000000FFFFFF00000000007B7B7B000000
      0000FFFFFF00000000000000000000000000000000007B7B7B007B7B7B00FFFF
      FF00000000007B7B7B000000000000000000FFFFFF007B7B7B007B7B7B00FFFF
      FF00000000007B7B7B007B7B7B00000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B7B00FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF000000
      0000FFFFFF0000000000FFFFFF0000000000FFFFFF00000000007B7B7B000000
      0000FFFFFF0000000000000000000000000000000000000000007B7B7B007B7B
      7B00FFFFFF0000000000000000007B7B7B00FFFFFF00000000007B7B7B007B7B
      7B007B7B7B007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B007B7B7B007B7B7B00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B00FFFFFF007B7B7B007B7B7B000000000000000000000000007B7B
      7B00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B007B7B7B007B7B
      7B00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B007B7B7B00FFFFFF00000000000000000000000000FFFFFF007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B00FFFFFF00000000007B7B7B007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B007B7B7B00FFFFFF00FFFFFF0000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000007B7B7B007B7B7B007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B007B7B7B000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B007B7B7B0000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF007B7B7B007B7B7B000000000000000000000000000000
      0000FFFFFF007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B000000000000000000FFFFFF0000000000FFFFFF0000000000FFFFFF007B7B
      7B0000000000FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF007B7B7B007B7B
      7B0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B7B7B007B7B7B00FFFFFF007B7B7B00000000000000000000000000FFFF
      FF00FFFFFF0000000000BDBDBD0000000000BDBDBD00000000007B7B7B007B7B
      7B000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF00000000007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF000000
      00007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      000000000000FF00000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF00000000000000
      00007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B00000000000000000000000000FFFF
      FF00FFFFFF0000000000BDBDBD00000000007B7B7B00000000007B7B7B007B7B
      7B000000000000000000000000000000000000000000000000007B7B7B000000
      0000000000007B7B7B00000000007B7B7B00FFFFFF007B7B7B0000000000FFFF
      FF007B7B7B0000000000FFFFFF00000000000000000000000000000000000000
      0000FF00000000000000FFFFFF0000000000FF00000000000000000000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF00000000000000
      000000000000FFFFFF007B7B7B00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000007B7B7B000000000000000000FFFFFF00FFFF
      FF007B7B7B007B7B7B00BDBDBD0000000000BDBDBD007B7B7B00000000007B7B
      7B007B7B7B00000000000000000000000000000000007B7B7B00FFFFFF000000
      00007B7B7B00FFFFFF00000000007B7B7B00FFFFFF00000000007B7B7B00FFFF
      FF00000000007B7B7B00FFFFFF0000000000000000000000000000000000FF00
      000000000000FFFFFF00FFFFFF00FFFFFF0000000000FF000000000000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF0000000000FFFF
      FF007B7B7B007B7B7B007B7B7B00FFFFFF007B7B7B007B7B7B007B7B7B007B7B
      7B000000000000000000000000007B7B7B000000000000000000FFFFFF00FFFF
      FF0000000000BDBDBD00BDBDBD00000000007B7B7B00BDBDBD00000000007B7B
      7B007B7B7B00000000000000000000000000000000007B7B7B00FFFFFF000000
      00007B7B7B00FFFFFF00000000007B7B7B00FFFFFF00000000007B7B7B00FFFF
      FF00000000007B7B7B00FFFFFF007B7B7B000000000000000000FF000000FF00
      0000FF00000000000000FFFFFF00FFFFFF00FFFFFF0000000000FF0000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF007B7B7B007B7B
      7B0000000000000000007B7B7B00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B000000000000000000FFFFFF00FFFF
      FF0000000000BDBDBD00BDBDBD0000000000BDBDBD007B7B7B00000000007B7B
      7B007B7B7B000000000000000000000000007B7B7B007B7B7B00FFFFFF000000
      00007B7B7B0000000000000000007B7B7B00FFFFFF00000000007B7B7B00FFFF
      FF00000000007B7B7B007B7B7B000000000000000000FF000000FF000000FF00
      0000FF000000FF00000000000000FFFFFF00FFFFFF00FFFFFF0000000000FF00
      0000000000000000000000000000000000007B7B7B007B7B7B00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00FFFFFF007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B00000000007B7B7B000000000000000000FFFFFF00FFFF
      FF007B7B7B007B7B7B00BDBDBD00000000007B7B7B00BDBDBD00000000007B7B
      7B007B7B7B00000000000000000000000000000000007B7B7B0000000000FFFF
      FF007B7B7B0000000000FFFFFF007B7B7B00FFFFFF00000000007B7B7B000000
      0000000000007B7B7B00000000000000000084000000FF000000FF000000FF00
      0000FF000000FF000000FF00000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000FF0000000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B00000000000000000000000000FFFF
      FF00FFFFFF0000000000BDBDBD0000000000BDBDBD00000000007B7B7B007B7B
      7B000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF00000000007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF000000
      00007B7B7B00FFFFFF000000000000000000FF00000084000000FF000000FF00
      0000FF000000FF000000FF000000FF00000000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FF0000000000000000000000000000007B7B7B007B7B7B000000
      0000FFFFFF00FFFFFF007B7B7B00FFFFFF007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B00000000007B7B7B00000000000000000000000000FFFF
      FF00FFFFFF0000000000BDBDBD00000000007B7B7B00000000007B7B7B007B7B
      7B000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B00FFFFFF00FFFF
      FF007B7B7B00FFFFFF00000000000000000000000000FF00000084000000FF00
      0000FF00000000000000FF000000FF000000FF00000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FF000000000000000000000000000000000000007B7B
      7B007B7B7B00000000007B7B7B00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B00FFFFFF0000000000000000000000000000000000FF0000008400
      0000FF000000FF000000FF00000000000000FF000000FF00000000000000FFFF
      FF0000000000FF00000000000000000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B00FFFFFF007B7B7B007B7B7B007B7B7B000000
      000000000000FFFFFF00FFFFFF007B7B7B00000000000000000000000000FFFF
      FF00BDBDBD00BDBDBD00BDBDBD007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B000000000000000000000000000000000000000000000000007B7B7B00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B7B7B00FFFFFF000000000000000000000000000000000000000000FF00
      000084000000FF0000000000000000000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007B7B7B00FFFFFF0000000000FFFFFF00FFFFFF000000
      00007B7B7B007B7B7B007B7B7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B000000000000000000000000000000000000000000000000000000
      0000FF00000084000000FF000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007B7B7B00FFFFFF007B7B7B007B7B7B00000000000000
      00007B7B7B00FFFFFF007B7B7B00000000000000000000000000000000000000
      000000000000000000007B7B7B007B7B7B007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000084000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B7B7B007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF00000084000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B0000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFF
      FF007B7B7B007B7B7B007B7B7B00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000007B7B7B00000000007B7B7B00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF007B7B7B00000000000000000000000000000000007B7B
      7B007B7B7B0000000000000000000000000000000000000000007B7B7B007B7B
      7B0000000000FFFFFF0000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000FFFFFF000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF007B7B7B007B7B
      7B007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B007B7B7B007B7B7B007B7B
      7B000000000000000000000000007B7B7B0000000000FFFFFF007B7B7B007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B7B7B007B7B7B00FFFFFF000000000000000000000000007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFFFF0000000000000000000000000000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000007B7B7B007B7B7B007B7B7B00FFFF
      FF007B7B7B00FFFFFF007B7B7B00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B0000000000FFFFFF00FFFFFF00FFFF
      FF007B7B7B007B7B7B0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B00FFFFFF000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF000000000000000000000000000000
      00000000000000000000FFFFFF00000000007B7B7B00FFFFFF007B7B7B00FFFF
      FF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B00000000007B7B7B0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000007B7B7B00000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000007B7B7B0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000007B7B7B00FFFFFF007B7B7B00FFFF
      FF007B7B7B00FFFFFF007B7B7B00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF007B7B7B0000000000FFFFFF00FFFFFF00FFFF
      FF007B7B7B000000000000000000FFFFFF000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00000000007B7B7B00FFFFFF00000000000000
      000000000000000000007B7B7B007B7B7B007B7B7B0000000000FFFFFF000000
      000000000000000000007B7B7B00FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF000000000000000000000000000000
      00000000000000000000FFFFFF00000000007B7B7B00FFFFFF007B7B7B00FFFF
      FF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B00000000007B7B7B0000000000FFFFFF007B7B7B000000
      00007B7B7B00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000007B7B7B00FFFFFF00000000000000
      0000000000007B7B7B00FFFFFF0000000000FFFFFF007B7B7B00FFFFFF000000
      000000000000000000007B7B7B00FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000007B7B7B00FFFFFF007B7B7B00FFFF
      FF007B7B7B00FFFFFF007B7B7B00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000007B7B7B0000000000000000007B7B7B00FFFF
      0000FFFF0000FFFF000000000000FFFFFF000000000000000000000000000000
      00000000000000000000FFFFFF00000000007B7B7B00FFFFFF00000000000000
      0000000000007B7B7B00FFFFFF007B7B7B00000000007B7B7B00FFFFFF000000
      000000000000000000007B7B7B00FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000007B7B7B00FFFFFF007B7B7B00FFFF
      FF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B007B7B7B007B7B7B000000
      000000000000FFFFFF00FFFFFF007B7B7B00000000007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000007B7B7B00FFFFFF00000000000000
      0000000000007B7B7B0000000000FFFFFF00FFFFFF007B7B7B00000000000000
      000000000000000000007B7B7B00FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000007B7B7B00FFFFFF007B7B7B00FFFF
      FF007B7B7B00FFFFFF007B7B7B00FFFFFF0000000000FFFFFF00FFFFFF000000
      00007B7B7B007B7B7B007B7B7B007B7B7B0000000000000000007B7B7B00FFFF
      0000FFFF0000FFFF000000000000FFFFFF000000000000000000000000000000
      00000000000000000000FFFFFF00000000007B7B7B0000000000FFFFFF000000
      000000000000000000007B7B7B007B7B7B007B7B7B0000000000000000000000
      000000000000000000007B7B7B000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF000000000000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000007B7B7B00FFFFFF007B7B7B00FFFF
      FF007B7B7B00FFFFFF007B7B7B00FFFFFF007B7B7B007B7B7B00000000000000
      00007B7B7B00FFFFFF007B7B7B000000000000000000000000007B7B7B000000
      00007B7B7B00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000007B7B7B00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B00FFFFFF000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000007B7B7B00FFFFFF007B7B7B00FFFF
      FF007B7B7B00FFFFFF007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007B7B7B007B7B7B0000000000000000000000000000000000000000000000
      00007B7B7B000000000000000000FFFFFF00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000007B7B7B0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B00000000000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF007B7B7B00FFFF
      FF007B7B7B00FFFFFF007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000000000007B7B7B000000
      0000FFFFFF00FFFFFF000000000000000000000000000000000000000000FFFF
      FF007B7B7B0000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF007B7B7B00FFFF
      FF007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000007B7B
      7B007B7B7B0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B007B7B
      7B000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B00FFFFFF007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B007B7B7B000000
      0000FFFFFF007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00FFFFFF00FFFF
      FF007B7B7B007B7B7B0000000000000000000000000000000000000000000000
      8400000000000000000000000000000000000000000000000000000000000000
      840000000000000000000000000000000000000000007B7B7B007B7B7B000000
      0000FFFFFF007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B00FFFFFF00FFFF
      FF007B7B7B007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B007B7B7B00000000007B7B7B00FFFFFF007B7B7B007B7B7B007B7B
      7B00FFFFFF00FFFFFF0000000000000000000000000000000000000084000000
      000000000000000000000000FF00000000000000FF0000000000000000000000
      0000000084000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B007B7B7B00000000007B7B7B00FFFFFF007B7B7B007B7B7B007B7B
      7B00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B000000000000000000FFFFFF007B7B7B000000000000000000FFFFFF007B7B
      7B007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      00000000FF00BDBDBD00FFFFFF0000000000FFFFFF00BDBDBD000000FF000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B000000000000000000FFFFFF007B7B7B000000000000000000FFFFFF007B7B
      7B007B7B7B00FFFFFF0000000000000000000000000000000000000000000000
      000000000000BDBDBD00FFFFFF00BDBDBD00BDBDBD00BDBDBD00000000000000
      00000000000000000000000000000000000000000000000000007B7B7B000000
      0000000000007B7B7B0000000000FFFFFF00000000007B7B7B00000000000000
      00007B7B7B0000000000FFFFFF0000000000000000007B7B7B00000000000000
      FF00BDBDBD0000000000FFFFFF00FFFFFF00FFFFFF0000000000BDBDBD000000
      FF00000000007B7B7B00000000000000000000000000000000007B7B7B000000
      0000000000007B7B7B0000000000FFFFFF00000000007B7B7B00000000000000
      00007B7B7B0000000000FFFFFF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00BDBDBD00FFFFFF00BDBDBD00BDBDBD00BDBDBD00FFFF
      FF0000000000000000000000000000000000000000007B7B7B00FFFFFF000000
      0000FFFFFF00000000007B7B7B0000000000FFFFFF000000000000000000FFFF
      FF00FFFFFF007B7B7B00FFFFFF000000000000000000000000000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF00000000000000000000000000000000007B7B7B00FFFFFF000000
      0000FFFFFF00000000007B7B7B0000000000FFFFFF000000000000000000FFFF
      FF00FFFFFF007B7B7B00FFFFFF00000000000000000000000000FF00FF00FFFF
      0000FFFFFF00FFFFFF00FFFFFF00BDBDBD00FFFFFF00BDBDBD00FFFFFF00FFFF
      0000FF00FF00000000000000000000000000000000007B7B7B00FFFFFF007B7B
      7B000000000000000000000000007B7B7B00FFFFFF00000000007B7B7B007B7B
      7B00000000007B7B7B00FFFFFF000000000000000000000000000000FF000000
      0000FFFFFF00000000000000000000000000FFFFFF00FFFFFF00000000000000
      00000000FF00000000000000000000000000000000007B7B7B00FFFFFF007B7B
      7B000000000000000000000000007B7B7B00FFFFFF00000000007B7B7B007B7B
      7B00000000007B7B7B00FFFFFF00000000000000000000000000FF00FF00FF00
      FF00FFFF0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF0000FF00
      FF00FF00FF00000000000000000000000000000000007B7B7B0000000000FFFF
      FF000000000000000000FFFFFF007B7B7B00FFFFFF0000000000FFFFFF000000
      0000000000007B7B7B00000000000000000000FFFF00000000000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF000000000000FFFF0000000000000000007B7B7B0000000000FFFF
      FF000000000000000000FFFFFF007B7B7B00FFFFFF0000000000FFFFFF000000
      0000000000007B7B7B0000000000000000000000000000FFFF0000FFFF00FFFF
      FF00FF00FF00FFFF0000000000000000000000000000FFFF0000FF00FF00FFFF
      FF0000FFFF0000FFFF00000000000000000000000000000000007B7B7B00FFFF
      FF00FFFFFF007B7B7B00000000007B7B7B00FFFFFF007B7B7B00000000000000
      00007B7B7B00FFFFFF000000000000000000000000007B7B7B00000000000000
      FF00BDBDBD0000000000FFFFFF0000000000FFFFFF0000000000BDBDBD000000
      FF00000000007B7B7B00000000000000000000000000000000007B7B7B00FFFF
      FF00FFFFFF007B7B7B00000000007B7B7B00FFFFFF007B7B7B00000000000000
      00007B7B7B00FFFFFF0000000000000000000000000000FF000000FF000000FF
      FF0000FFFF0000000000BDBDBD00BDBDBD00BDBDBD000000000000FFFF0000FF
      FF0000FF000000FF0000000000000000000000000000FFFFFF007B7B7B007B7B
      7B00FFFFFF00FFFFFF00000000007B7B7B000000000000000000000000007B7B
      7B007B7B7B00FFFFFF00FFFFFF00FFFFFF0000FFFF0000FFFF00000000000000
      00000000FF00BDBDBD00FFFFFF0000000000FFFFFF00BDBDBD000000FF000000
      00000000000000FFFF0000FFFF000000000000000000FFFFFF007B7B7B007B7B
      7B00FFFFFF00FFFFFF00000000007B7B7B000000000000000000000000007B7B
      7B007B7B7B00FFFFFF00FFFFFF00FFFFFF0000000000FFFF0000FFFF000000FF
      000000FF000000000000BDBDBD0000000000BDBDBD000000000000FF000000FF
      0000FFFF0000FFFF000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B00FFFFFF000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B00FFFFFF000000000000FF000000FF000000FF
      FF0000FFFF0000000000BDBDBD00BDBDBD00BDBDBD000000000000FFFF0000FF
      FF0000FF000000FF000000000000000000007B7B7B00FFFFFF00000000000000
      00007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B000000
      000000000000000000007B7B7B00FFFFFF0000000000BDBDBD00BDBDBD007B7B
      7B0000000000000000000000000000000000000000000000000000000000BDBD
      BD007B7B7B007B7B7B0000000000000000007B7B7B00FFFFFF00000000000000
      00007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B000000
      000000000000000000007B7B7B00FFFFFF000000000000FFFF0000FFFF00FFFF
      FF00FF00FF00FFFF0000000000000000000000000000FFFF0000FF00FF0000FF
      FF0000FFFF0000FFFF0000000000000000007B7B7B0000000000FFFFFF000000
      000000000000000000007B7B7B007B7B7B007B7B7B0000000000FFFFFF000000
      000000000000000000007B7B7B000000000000000000BDBDBD00BDBDBD00BDBD
      BD00BDBDBD007B7B7B007B7B7B00000000007B7B7B00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD007B7B7B0000000000000000007B7B7B0000000000FFFFFF000000
      000000000000000000007B7B7B007B7B7B007B7B7B0000000000FFFFFF000000
      000000000000000000007B7B7B00000000000000000000000000FF00FF00FF00
      FF00FFFF0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF0000FF00
      FF00FF00FF00000000000000000000000000000000007B7B7B0000000000FFFF
      FF00FFFFFF007B7B7B00000000007B7B7B00FFFFFF007B7B7B0000000000FFFF
      FF00FFFFFF007B7B7B00000000000000000000FFFF00000000007B7B7B00BDBD
      BD00BDBDBD00000000000000000000FFFF000000000000000000BDBDBD00BDBD
      BD007B7B7B000000000000FFFF0000000000000000007B7B7B0000000000FFFF
      FF00FFFFFF007B7B7B000000000000000000000000007B7B7B0000000000FFFF
      FF00FFFFFF007B7B7B0000000000000000000000000000000000FF00FF00FFFF
      0000FFFFFF00BDBDBD00FFFFFF00BDBDBD00FFFFFF00FFFFFF00FFFFFF00FFFF
      0000FF00FF0000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B0000000000000000007B7B7B00FFFFFF00FFFFFF007B7B7B007B7B
      7B007B7B7B0000000000000000000000000000000000000000007B7B7B000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      00007B7B7B0000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B0000000000FFFFFF0000000000FFFFFF00000000007B7B7B007B7B
      7B007B7B7B00FFFFFF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00BDBDBD00FFFFFF00BDBDBD00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000007B7B7B007B7B7B007B7B7B0000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF000000000000FFFF000000000000FFFF000000000000FFFF0000FF
      FF000000000000000000000000000000000000000000000000007B7B7B000000
      0000000000007B7B7B00000000007B7B7B00FFFFFF007B7B7B0000000000FFFF
      FF007B7B7B0000000000FFFFFF00000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00BDBDBD00FFFFFF00BDBDBD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF00000000000000000000FFFF000000000000FFFF00000000000000000000FF
      FF0000FFFF00000000000000000000000000000000007B7B7B00000000000000
      00007B7B7B0000000000000000007B7B7B0000000000000000007B7B7B000000
      0000000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF00000000000000000000000000000000007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8400000000000000000000000000000000000000000000000000000000000000
      840000000000000000000000000000000000000000000000000000FFFF0000FF
      FF00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF000000000000000000000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000084000000
      000000000000000000000000FF00000000000000FF0000000000000000000000
      000000008400000000000000000000000000000000000000000000FFFF0000FF
      FF000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      000000FFFF0000FFFF000000000000000000000000000000000000000000BDBD
      BD0000000000BDBDBD0000000000BDBDBD000000FF000000FF000000FF00BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF00BDBDBD00FFFFFF0000000000FFFFFF00BDBDBD000000FF000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      00000000000000FFFF000000000000000000000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00000000000000
      FF00BDBDBD0000000000FFFFFF00FFFFFF00FFFFFF0000000000BDBDBD000000
      FF00000000007B7B7B000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF00000000000000000000FFFF0000FFFF00000000000000000000FF
      FF0000FFFF0000FFFF000000000000000000000000000000000000000000BDBD
      BD0000000000BDBDBD0000000000BDBDBD0000000000BDBDBD0000000000BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF00000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF000000000000FFFF00000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF000000000000000000000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000000000
      00000000FF00000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF000000000000000000000000000000000000000000BDBD
      BD0000000000BDBDBD0000000000BDBDBD0000000000BDBDBD0000000000BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF00000000000000000000000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF00000000
      000000000000000000000000000000000000000000007B7B7B00000000000000
      FF00BDBDBD0000000000FFFFFF0000000000FFFFFF0000000000BDBDBD000000
      FF00000000007B7B7B0000000000000000000000000000000000FFFF0000FFFF
      000000000000FFFF0000BDBDBD0000000000000000000000000000000000FFFF
      0000FFFF0000FFFF00000000000000000000000000000000000000000000BDBD
      BD0000000000BDBDBD0000000000BDBDBD0000000000BDBDBD0000000000BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF00BDBDBD00FFFFFF0000000000FFFFFF00BDBDBD000000FF000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF000000000000BDBDBD000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF00000000000000000000000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF00000000000000000000000000000000000000000000BDBD
      BD0000000000000000000000000000000000000000000000000000000000BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF000000FF000000FF000000000000000000000000
      00000000000000000000000000000000000000000000BDBDBD00BDBDBD007B7B
      7B0000000000000000000000000000000000000000000000000000000000BDBD
      BD007B7B7B007B7B7B0000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF00000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF00000000000000000000000000000000000000000000BDBD
      BD00000000000000000000000000FFFF000000000000FFFF000000000000BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF000000FF000000FF000000000000000000000000
      00000000000000000000000000000000000000000000BDBDBD00BDBDBD00BDBD
      BD00BDBDBD007B7B7B007B7B7B00000000007B7B7B00BDBDBD00BDBDBD00BDBD
      BD00BDBDBD007B7B7B0000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF00000000000000000000000000000000000000000000BDBD
      BD0000000000000000000000000000000000000000000000000000000000BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B00BDBD
      BD00BDBDBD00000000007B7B7B00000000007B7B7B0000000000BDBDBD00BDBD
      BD007B7B7B000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF00000000000000000000000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF00000000000000000000000000000000000000000000BDBD
      BD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000000000000000000000000000000000007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      FF00000084000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00000000000000
      000000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      FF00000084000000FF0000000000008484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF007B7B7B000000FF007B7B7B00FFFFFF00000000000000
      0000000000000000000000000000000000007B7B7B0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      FF00000084000000FF0000848400008484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF000000FF000000FF000000FF0000FFFF00FFFFFF0000FF
      FF000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      FF00000084000000FF0000848400008484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF00000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF007B7B7B000000FF007B7B7B00FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      FF00000084000000FF0000848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF000000000000000000000000007B7B7B00000000000000
      000000000000FFFFFF00000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000000000000000000000000000000000FF
      FF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FF
      FF00000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      000000FFFF0000FFFF00000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF000000FF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF00000000000000000000000000000000007B7B7B000000
      0000FFFFFF00000000007B7B7B00000000000000000000000000000084000000
      8400000084000000840000008400000000000000000000000000FFFFFF000000
      000000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBD
      BD0000FFFF0000000000000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF000000FF007B7B7B0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000000000000000
      0000000000007B7B7B0000000000000000000000000000848400008484000084
      840000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF000000000000FFFF00BDBDBD0000FFFF00BDBDBD0000FFFF00BDBDBD0000FF
      FF00BDBDBD0000FFFF00000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF000000FF000000FF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000084840000848400008484000000
      0000000000000000000000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000FF000000FF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000008484000084840000848400000000000000
      000000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF007B7B7B007B7B7B0000FFFF00FFFFFF007B7B7B000000FF000000FF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000848400008484000084840000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF000000FF000000FF00FFFFFF0000FFFF007B7B7B000000FF000000FF0000FF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000084840000848400008484000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF000000FF000000FF007B7B7B00FFFFFF007B7B7B000000FF000000FF00FFFF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000848400000000000000000000000000000000007B7B
      7B00000000007B7B7B00000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF000000FF000000FF000000FF000000FF000000FF00FFFFFF0000FF
      FF00FFFFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B00000000007B7B7B00000000000000000000000000000000007B7B7B000000
      00000000000000000000000000007B7B7B000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF000000FF000000FF000000FF00FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000008484000000
      00000000000000000000000000007B7B7B000000000000000000000000007B7B
      7B00000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B000000
      00007B7B7B007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00000000007B7B
      7B007B7B7B007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      00007B7B7B007B7B7B007B7B7B0000FFFF0000FFFF007B7B7B007B7B7B007B7B
      7B007B7B7B0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BDBDBD000000
      0000BDBDBD00BDBDBD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDBDBD007B7B7B00000000007B7B
      7B00000000000000000000000000000000000000000000000000000000007B7B
      7B00000000007B7B7B000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BDBDBD00BDBD
      BD00BDBDBD00BDBDBD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      00007B7B7B000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDBDBD00BDBDBD007B7B7B000000
      0000000000007B7B7B0000000000000000000000000000000000000000007B7B
      7B0000000000000000007B7B7B007B7B7B000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007B7B7B00000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B0000000000000000000000
      00007B7B7B000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B00000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007B7B7B00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000007B7B7B0000000000000000000000000000000000000000000000
      00007B7B7B000000000000000000000000007B7B7B0000000000000000007B7B
      7B00000000007B7B7B0000000000000000000000000000000000000000000000
      000000000000BDBDBD00000000007B7B7B000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007B7B7B00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B00BDBDBD0000000000BDBDBD0000FFFF0000FFFF0000FFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000FFFF0000FFFF000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000BDBDBD0000000000FF000000FF000000FF00
      00000000FF00FF000000FF000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BDBDBD00000000007B7B7B000000000000FFFF0000FFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000FFFF0000FFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      000000000000000000007B7B7B00000000000000000000000000000000007B7B
      7B0000000000000000000000000000000000000000007B7B7B00000000000000
      00007B7B7B0000000000000000007B7B7B00000000007B7B7B00000000000000
      0000000000007B7B7B00BDBDBD00000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B0000000000000000000000
      00007B7B7B000000000000000000000000007B7B7B0000000000000000007B7B
      7B0000000000000000007B7B7B00BDBDBD000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B007B7B7B007B7B7B0000000000000000007B7B7B00000000000000
      00007B7B7B000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000000000FF
      FF000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B0000000000000000007B7B7B000000
      000000000000000000000000000000000000000000007B7B7B007B7B7B000000
      000000000000000000007B7B7B007B7B7B000000000000000000000000007B7B
      7B00000000007B7B7B0000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000FF
      FF0000FFFF0000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BDBDBD00000000007B7B
      7B007B7B7B007B7B7B00000000007B7B7B000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF00000000000000000000000000FFFFFF0000000000BDBD
      BD00FFFFFF0000000000FFFFFF000000000000000000000000007B7B7B000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B7B7B00BDBDBD0000000000BDBD
      BD00000000007B7B7B00000000007B7B7B007B7B7B007B7B7B00000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      00000000000000FFFF0000FFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BDBDBD00000000007B7B
      7B00BDBDBD007B7B7B00000000007B7B7B000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007B7B7B00BDBDBD000000
      000000000000000000007B7B7B007B7B7B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF00000000000000FF000000000000000000
      000000000000000000000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF00000000000000FFFFFF0000000000FF0000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF007B7B
      7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000FFFFFF0000000000FFFFFF0000000000FF00
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000FF000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF0000000000FF0000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      000000000000000000000000000000000000FF0000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF0000000000FF00000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FF000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF0000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B0000000000FFFF0000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFF000000000000FFFF000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFF0000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000900100000100010000000000800C00000000000000000000
      000000000000000000000000FFFFFF00FC3F800000000000E007000000000000
      C003000000000000C003000000000000C003000000000000C003000000000000
      C003000000000000C003000000000000C003000000000000C003000000000000
      C003000000000000C003000000000000C003000000000000C003000000000000
      E007000000000000FFFF000000000000FFFFFFFFE00FFFFFFFDEC007E00FFFFF
      00008003C007FE0000000001C007FE00000000018003FE000000000180028000
      0000000000019000000000008003800000008000C00790000000C000C0078001
      0000E001C00780038000E007C00780078000F007C007807FF000F003F83F80FF
      FEC0F803F83F81FFFFD2FFFFFFFFFFFFFFFFFC008000FFFFFE3FF8000000FFF1
      F89F00000000FFF1F54F00000000FEF1E3A700000000FE718FD300000000FE31
      57E90000000000113BF40001000000017DFA000700000001BEFD000700000011
      DF7300070000FE31EF8F00070000FE71F77F00070000FEF1F8FF00070000FFF1
      FFFF00078000FFF9FFFF00070000FFFFE3FFFC00FC00FFFFC1FFF800F800FDFF
      0E7FF800F800F8FF1F1FF800F800F27F0E0700000000E73F041900000000C39F
      041C0000000081CF071D0001000100E703C900010001007300C3000100018039
      004300010001C013000700010001E00F000700010001F00F003F00010001F81F
      807F00010001FC7F8EFF00010001FFFFFFFFE000FCFF80000000E000F87F8000
      0000EFFCF07F80000000E844E03F80000000EE14C31F800000000114E59F8000
      0000023CF8CF800000000404F267800000008834E73380000000D004C3998000
      0000A03481CC80000000400400E68000000004300073800000000E3580398000
      FFFFEFF3C0138800FFFFE007E00FFFFFFFFFFFE0F81FC001FC00FDEFF007C001
      0000F8F3C003C0010000F27D8381C0010000E73E8FF1C0010000C38003F0C001
      000081CF0074C001000000E710388000000000731C388000000080392E74C001
      0000C0130E7080010000E00F8E7160010000F00FC00368010000F81FC0039C01
      FFFFFC7FF00F6E21FFFFFFFFF00F9F61FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      0000FFFFFFFFFFFF0000FFFFF9FF00000000F83FFCFF00000000F39FFCFF0000
      0000FF9FFE7F00000000FF9FFE7F00000000FF9FFF3F00000000F83FFF3F0000
      0000F9FFFF9F00000000F9FFF01F00000000F81FFFFF00000000FFFFFFFF0000
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000080008003FFFF000000008001
      FFFF00000000800000000000000080000000000000008001000000000000800F
      0000000000008001801F000000008000801F000000010000801F000080000001
      801F000000020003000000000000000700000000000000070000000028000007
      0000000004010007FFFF0000A0080007FFFF8000C001C000FFFF0000C000C000
      00000000C000C00000000000C000C00000000000C000C00100000000C007C003
      00000000C007C00700000000C007C00700000000800380030000000080038003
      0000000080038003000000008003800300000000800380030000000080038003
      FFFF000080038003FFFF000080038003FFFFFFFFFFFF0000FFFFC001FFFF0000
      FFFF8001FFFF0000FDFF8001FFBF0000F9FF8001FF9F0000F1FF8001FF8F0000
      E0038001C0070000C0038001C0030000C0038001C0030000E0038001C0070000
      F1FF8001FF8F0000F9FF8001FF9F0000FDFF8001FFBF0000FFFF8001FFFF0000
      FFFF8001FFFF0000FFFFFFFFFFFF0000FFFFFFFF0000FFFF8001FFFF0000FFFF
      0001000000000000000100000000000000010000000000000001000000000000
      0001000000000000000100000000000000010000000000000001000000000000
      0001000000000000000100000000000000010000000000000001000000000000
      0001FFFF0000FFFF8003FFFF0000FFFFFFFFFFFFFFFFC007E31FFF03FFFFC007
      FDEFFE00E38FC007FDEFFE00C107C007F39FFE008003C007FDEFFEA88003C007
      FDEFFE018003C007E31FFF79E38FC007FFFFFF4BE38F8003E31F58BDE38F8003
      FDEF5541E38F8003FDEF357FE38F8003F39F377FE38F8003FDEF577FE38F8003
      FDEF577FFFFF8003E31FFFFFFFFF8003FFFF8000FFFFFFFF801F0000C0018001
      801F000080000001801F000099CC0001801F0000CC990001801F0000CE390001
      801F0000E6330001801F0000E4930001800F0000F1C7000180078000F3E70001
      8013C000F9CF00018039F000F9CF0001807DFC00FC9F000180FFFC00FC1F0001
      FFFFFC00FE3F0001FFFFFC00FFFF8003FFFFFCFFC003FFFFFF03F87FC8038003
      EE01F07FC0130001E600E03FC03B00010200C31FC2030001E600E79FC6830001
      EE00FFCFC0030001FF01FFE7C0030001C103FFF3C0030001C181D4E1C0010001
      01C1D55CC000000101FFC4DEC002000101FFD55FC003000103FFECE7C0030001
      07FFFFFFC00300010FFFFFFFC0038003FF7FFFFDFFF8FFFFFF7FFFF8FFF0C007
      FE3FFFF1FFE18003FE3FFFE3FFC30001FC1FFFC7F8870001FC1FE08FE10F0001
      F80FC01FCE1F0000F80F803F9D9F0000F007001FB9AF8000F007001F304FC000
      FE3F001F20CFE001FE3F001F59DFE007FE3F001F9B9FF007FE3F803FA73FF003
      FE3FC07FC87FF803FE3FE0FFF1FFFFFFFEFFFEFFFFFFFEFFFEFFFEFFFFFFFEFF
      FEFFFEFFFFFFFC7F000000000000FC7F000000000000F83F000000000000F83F
      000000000000F01F000000000000F01F000000000000E00F000000000000E00F
      000000000000FC7F000000000000FC7F000000000000FC7F000000000000FC7F
      FEFFFEFFFFFFFC7FFEFFFEFFFFFFFC7F8001FFFFFC1FFFFF9E39F83FF007FFFF
      9C79E00FE043FFFF9E79CC47C2A100009C798463803100009EF9A07382F80000
      855131F910780000800138F91A38000080013C791E18000082813C391C080000
      8DA13C190C4100009FC19C0BA4410000800B8C43900300008007C467C8070000
      800FE00FE38FFFFF801FF83FF83FFFFFFFFFFFFFFFFF8003FCFFFFFFFCFF8003
      F87FF9FFF87F8003F23FF0FFF07F8003E11FF0FFF03F8003D88FE07FE03F8003
      BC47C07FC01F80033E23843F841F80031D111E3F1E0F80038B09FE1FFE0F8003
      C643FF1FFF078003E0E7FF8FFF838003F1CFFFC7FFC18003F89FFFE3FFE08007
      FC7FFFF8FFF8800FFFFFFFFFFFFF801F8000E00FE007FFFF27F8E00FED4BFDFF
      0800C007C813F8FF3000C007DA25F07F388680039249E03F200E80029248C01F
      0C8000011649800F00028003A45B00070080C007C81300039002C007C0038001
      E48EC007C003C003F818C007C003E00FFC90C007C007F00FFC31F83FF81FF81F
      FC03F83FF83FFC7FFC07FFFFFFFFFFFFFC1FFC00F8008000F027F000E0860000
      E7CBC000800E0000DFF50000008000009FF9000000020000BE3A000000800000
      3C5C000000020000391C0000008E0000389C0000001800003A3C000000908000
      5C7D00010031C0009FF900030003F000AFFB00070007FC00D3E7001F001FFC01
      E40F007F007FFC03F83F01FF01FFFC07900388239003FFFFE203C007E203F83F
      CCC3C007CCC3E00FDAB58003DAB5C00795618003956180038E4980038E498003
      AC5B0001AC5B0001C2330001C233000182E0000182E000010000000100000001
      301C0001301C00015C5D00015C5D8003A2230001A3A38003C6074005C543C007
      FC7FC007DA25E00FFFFF8443B6DBF83FC003C007FC7F8823C003C007FC7FC007
      C003C007FC7FC007C003C007FC7F8003C003C007FC7F8003C003C007FC7F8003
      C003C007E00F8003C003C007E00F8003C003C007F01FC007C003C007F01F0001
      C003C007F83F0001C003C007F83F0001C003C007FC7F8003C003C007FC7FC6C7
      C003C007FEFFFC7FC003C007FEFFFFFFF862FFFFFC1FFFFF80E0FFFFF007F83F
      01E0FFFFE003E00F01E0FFFFC001C00731E1C00F8001800331C1800781F08003
      C181800303F80001C307800107FD0001FE17800107FF0001CC37800F07FF0001
      A877800F07FF000140F7801F87FF800301E3C0FF83FF8003C1E3C0FFC1FFC007
      C0E3FFFFE0FFE00FC83FFFFFF9FFF83FFF7EFF00FFFF81FE9001FF00FFFF01E2
      C003FF00F18307E0E003FF00FBC703E0E0030000F9C703F0E0030000F80723C0
      E0030000FD8F3FC000010000FC8FE3C080000023FC8F2230E0070001FE1F0020
      E00F0000FE1F0020E00F0023FE1F0062E0270063FF3F001EC07300C3FF7F001F
      9E790107FFFF001F7EFE03FFFFFF007FFFFFFFFFFC7FFFFF00010001FC7FFE3F
      00010001FC7FF81F00010001FC7FF40F1FF11FF1FC7FE0071FF11DF1FC7F8003
      18311CF1E00F400118311C71E00F000018311C31F01F000018311C71F01F8001
      18311CF1F83FC0031FF11DF1F83FE00F1FF11FF1FC7FF07F00010001FC7FF8FF
      00010001FEFFFFFF00010001FEFFFFFF00000000000000000000000000000000
      000000000000}
  end
end
