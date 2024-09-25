﻿object FormLiefMahn: TFormLiefMahn
  Left = 0
  Top = 0
  Caption = 'Lieferanten Mahnungen'
  ClientHeight = 558
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GridBelege: TIB_Grid
    Left = 0
    Top = 41
    Width = 852
    Height = 333
    CustomGlyphsSupplied = []
    DataSource = DSBelege
    Align = alClient
    ParentBackground = False
    PreventDeleting = True
    TabOrder = 0
    DrawingStyle = gdsClassic
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 478
    Width = 852
    Height = 80
    Align = alBottom
    TabOrder = 1
    object Label2: TLabel
      Left = 403
      Top = 6
      Width = 59
      Height = 13
      Caption = 'Tage setzen'
    end
    object Label4: TLabel
      Left = 16
      Top = 6
      Width = 47
      Height = 13
      Caption = 'Sender_R'
    end
    object Label5: TLabel
      Left = 16
      Top = 31
      Width = 99
      Height = 13
      Caption = 'Vorlage_R (Deutsch)'
    end
    object lblStatus: TLabel
      Left = 543
      Top = 6
      Width = 41
      Height = 13
      Caption = 'lblStatus'
    end
    object lblLastMahnlauf: TLabel
      Left = 542
      Top = 56
      Width = 74
      Height = 13
      Caption = 'lblLastMahnlauf'
    end
    object Label1: TLabel
      Left = 16
      Top = 56
      Width = 98
      Height = 13
      Caption = 'Vorlage_R (Englisch)'
      ParentShowHint = False
      ShowHint = True
    end
    object Länder_R: TLabel
      Left = 172
      Top = 30
      Width = 112
      Height = 13
      Caption = 'L'#228'nder mit Vorlage DEU'
      ParentShowHint = False
      ShowHint = True
    end
    object edtMahnOffset: TEdit
      Left = 377
      Top = 3
      Width = 20
      Height = 21
      TabOrder = 3
    end
    object edtSenderR: TEdit
      Left = 127
      Top = 2
      Width = 39
      Height = 21
      Hint = 'RID des Bearbeiters und Versenders aus der Tabelle Personal'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object edtVorlageR_DEU: TEdit
      Left = 127
      Top = 27
      Width = 39
      Height = 21
      Hint = 'RID der Vorlage (Deutsch) aus Tabelle Email'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object cbMahnOffset: TCheckBox
      Left = 172
      Top = 5
      Width = 204
      Height = 17
      Caption = 'N'#228'chste Mahnung: Aktueller Tag zzgl. '
      TabOrder = 4
    end
    object edtVorlageR_ENG: TEdit
      Left = 127
      Top = 54
      Width = 39
      Height = 21
      Hint = 'RID der Vorlage (Englisch) aus Tabelle Email'
      TabOrder = 2
    end
    object edtLaenderDEULst: TEdit
      Left = 292
      Top = 26
      Width = 105
      Height = 21
      Hint = 
        'RID'#39's der L'#228'nder die als Vorlage (Deutsch) erhalten sollen (getr' +
        'ennt mit , )'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 852
    Height = 41
    Align = alTop
    TabOrder = 2
    object Image2: TImage
      Left = 781
      Top = 10
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
    object btnMahnsperre: TSpeedButton
      Left = 502
      Top = 8
      Width = 24
      Height = 22
      Hint = 'Mahnsperre setzen'
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -27
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = btnMahnSperreClick
    end
    object IB_NavigationBar1: TIB_NavigationBar
      Left = 8
      Top = 8
      Width = 116
      Height = 25
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      DataSource = DSBelege
      ReceiveFocus = False
      CustomGlyphsSupplied = []
    end
    object btnLiefMahnlaufStart: TButton
      Left = 130
      Top = 8
      Width = 129
      Height = 25
      Hint = 
        'Startet den Lieferantenmahnlauf uund stellt die notwendigen Date' +
        'n zusammen'
      Caption = 'Mahnlauf aktualisieren'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnLiefMahnlaufStartClick
    end
    object btnLiefMahnVersenden: TButton
      Left = 280
      Top = 8
      Width = 113
      Height = 25
      Hint = 'Esrtellung die Mahnungen und '#252'bertr'#228'gt diese in das Email-Modul'
      Caption = 'Mahnungen erstellen'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnLiefMahnVersendenClick
    end
    object btnPerson: TButton
      Left = 665
      Top = 8
      Width = 25
      Height = 22
      Hint = 'Person '#246'ffnen'
      Caption = '&P'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btnPersonClick
    end
    object btnBestellung: TButton
      Left = 640
      Top = 8
      Width = 25
      Height = 22
      Hint = 'Bestellbeleg '#246'ffnen'
      Caption = '&O'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = btnBestellungClick
    end
    object btnDelMahnsperren: TButton
      Left = 532
      Top = 8
      Width = 29
      Height = 22
      Hint = 'Mahnsperren aufheben'
      Caption = 'Del'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = btnDelMahnsperrenClick
    end
  end
  object pnlLog: TPanel
    Left = 0
    Top = 374
    Width = 852
    Height = 104
    Align = alBottom
    TabOrder = 3
    object memLog: TMemo
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 844
      Height = 96
      Align = alClient
      TabOrder = 0
    end
  end
  object QueryBelege: TIB_Query
    FieldsReadOnly.Strings = (
      'RID=TRUE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'Select'
      'BB.RID as BBELEG_RID, BB.MENGE_ERWARTET,BB.MENGE_GELIEFERT,'
      
        '    P.RID as PERSON_RID, P.NACHNAME, P.VORNAME,P.EMAIL,P.ANREDE,' +
        'P.ANSPRACHE,A.NAME1, A.LAND_R,'
      '    BP.LIEFERANT_R, --BP.VERLAG_R, --,BP.ZUSAGE,'
      '    Count(BP.RID) as ANZPOS'
      '    from BBELEG BB'
      '    JOIN BPOSTEN BP on BB.RID=BP.BELEG_R'
      '    JOIN PERSON P on BP.LIEFERANT_R=P.RID'
      '  --  LEFT JOIN PERSON V on BP.VERLAG_R=P.RID'
      '    JOIN ANSCHRIFT A ON A.RID=P.PRIV_ANSCHRIFT_R'
      '    where BB.MENGE_ERWARTET > BB.MENGE_GELIEFERT'
      '    and (BP.MENGE_ERWARTET>0 and BP.ZUSAGE+2<CURRENT_DATE)'
      '    group by'
      '    BB.RID, BB.MENGE_ERWARTET,BB.MENGE_GELIEFERT,'
      
        '    P.RID, P.NACHNAME, P.VORNAME, P.Email, P.ANREDE,P.ANSPRACHE,' +
        'A.NAME1, A.LAND_R, BP.LIEFERANT_R--,BP.VERLAG_R')
    ColorScheme = True
    KeyLinksAutoDefine = False
    OrderingItems.Strings = (
      'PERSON_RID=PERSON_RID;PERSON_RID DESC'
      'BBELEG_RID=BBELEG_RID;BBELEG_RID DESC'
      'A.NAME1=A.NAME1;A.NAME1 DESC'
      'BP.LIEFERANT_R=BP.LIEFERANT_R;BP.LIEFERANT_R DESC')
    OrderingLinks.Strings = (
      'PERSON_RID=ITEM=1'
      'BBELEG_RID=ITEM=2'
      'A.NAME1=ITEM=3'
      'BP.LIEFERANT_R=ITEM=4')
    RequestLive = True
    Left = 24
    Top = 64
  end
  object DSBelege: TIB_DataSource
    Dataset = QueryBelege
    Left = 104
    Top = 64
  end
  object QueryPosten: TIB_Query
    FieldsReadOnly.Strings = (
      'RID=TRUE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    ColorScheme = True
    KeyLinksAutoDefine = False
    OrderingItems.Strings = (
      'VON_DATUM=VON_DATUM;VON_DATUM DESC'
      'BIS_DATUM=BIS_DATUM;BIS_DATUM DESC'
      'SATZ=SATZ;SATZ DESC'
      'NAME=NAME;NAME DESC')
    OrderingLinks.Strings = (
      'VON_DATUM=ITEM=1'
      'BIS_DATUM=ITEM=2'
      'SATZ=ITEM=3'
      'NAME=ITEM=4')
    RequestLive = True
    Left = 48
    Top = 152
  end
end
