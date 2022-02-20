object FormCareServer: TFormCareServer
  Left = 191
  Top = 228
  Caption = 'CareServer'
  ClientHeight = 575
  ClientWidth = 908
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 908
    Height = 575
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet3: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Tickets'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 0
        Top = 23
        Width = 108
        Height = 12
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Ticket - Mandanten'
      end
      object Label3: TLabel
        Left = 0
        Top = 170
        Width = 80
        Height = 12
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Ticket Quellen'
      end
      object Label4: TLabel
        Left = 395
        Top = 163
        Width = 64
        Height = 12
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Ticket Ziele'
      end
      object Label5: TLabel
        Left = 0
        Top = 317
        Width = 39
        Height = 12
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Tickets'
      end
      object IB_Grid1: TIB_Grid
        Left = 0
        Top = 37
        Width = 385
        Height = 111
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        CustomGlyphsSupplied = []
        DataSource = IB_DataSource1
        TabOrder = 0
        DefaultRowHeight = 16
      end
      object IB_Grid2: TIB_Grid
        Left = 0
        Top = 185
        Width = 385
        Height = 119
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        CustomGlyphsSupplied = []
        DataSource = IB_DataSource2
        TabOrder = 1
        DefaultRowHeight = 16
      end
      object IB_Grid3: TIB_Grid
        Left = 395
        Top = 177
        Width = 496
        Height = 127
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        CustomGlyphsSupplied = []
        DataSource = IB_DataSource3
        TabOrder = 2
        DefaultRowHeight = 16
      end
      object IB_UpdateBar1: TIB_UpdateBar
        Left = 251
        Top = 12
        Width = 120
        Height = 23
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Flat = False
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 3
        DataSource = IB_DataSource1
        ReceiveFocus = False
        CustomGlyphsSupplied = []
        VisibleButtons = [ubEdit, ubInsert, ubDelete, ubPost, ubCancel, ubRefreshAll]
      end
      object IB_UpdateBar2: TIB_UpdateBar
        Left = 251
        Top = 160
        Width = 120
        Height = 23
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Flat = False
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 4
        DataSource = IB_DataSource2
        ReceiveFocus = False
        CustomGlyphsSupplied = []
        VisibleButtons = [ubEdit, ubInsert, ubDelete, ubPost, ubCancel, ubRefreshAll]
      end
      object IB_UpdateBar3: TIB_UpdateBar
        Left = 708
        Top = 155
        Width = 180
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Flat = False
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 5
        DataSource = IB_DataSource3
        ReceiveFocus = False
        CustomGlyphsSupplied = []
        VisibleButtons = [ubEdit, ubInsert, ubDelete, ubPost, ubCancel, ubRefreshAll]
      end
      object IB_Grid5: TIB_Grid
        Left = 0
        Top = 333
        Width = 891
        Height = 140
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        CustomGlyphsSupplied = []
        DataSource = IB_DataSource5
        TabOrder = 6
        DefaultRowHeight = 16
      end
      object IB_UpdateBar5: TIB_UpdateBar
        Left = 708
        Top = 311
        Width = 180
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Flat = False
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 7
        DataSource = IB_DataSource5
        ReceiveFocus = False
        CustomGlyphsSupplied = []
        VisibleButtons = [ubEdit, ubInsert, ubDelete, ubPost, ubCancel, ubRefreshAll]
      end
      object Button5: TButton
        Left = 575
        Top = 309
        Width = 92
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'eMail-Rollback'
        TabOrder = 8
        OnClick = Button5Click
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Rechner'
      ImageIndex = 4
      object Label2: TLabel
        Left = 395
        Top = 23
        Width = 45
        Height = 12
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Rechner'
      end
      object SpeedButton1: TSpeedButton
        Left = 684
        Top = 12
        Width = 20
        Height = 20
        Hint = 'Wake On Lan Paket senden'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C40E0000C40E00000000000000000000DC00FFDC00FF
          DC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00
          FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FF9595957D7D7D7D
          7D7D7B7B7BA6A6A6DC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FF
          DC00FFDC00FF5F5F5F2B2B2B0000000000000000002D2D2D6B6B6BDC00FFDC00
          FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FF3E3E3E0000001616164C4C4C63
          63634E4E4E1818180000003B3B3BDC00FFDC00FFDC00FFDC00FFDC00FFDC00FF
          3D3D3D0000005E5E5EA5A5A5AAAAAAA5A5A5ACACACA1A1A15B5B5B0404044848
          48DC00FFDC00FFDC00FFDC00FF7C7C7C030303515151AFAFAFAAAAAAA7A7A7AE
          AEAEA4A4A4ABABABACACAC525252000000888888DC00FFDC00FFDC00FF4E4E4E
          0C0C0CA2A2A2ADADADAEAEAEB0B0B0A9A9A9B3B3B3ADADADB2B2B29F9F9F0C0C
          0C4B4B4BDC00FFDC00FFDC00FF2B2B2B282828B3B3B3B0B0B0B3B3B3B2B2B2B3
          B3B3B3B3B3AFAFAFB2B2B2B5B5B52B2B2B2B2B2BDC00FFDC00FFDC00FF2D2D2D
          2E2E2EB6B6B6B6B6B6B7B7B7595959010101868686BABABAB2B2B2B8B8B82C2C
          2C2E2E2EDC00FFDC00FFDC00FF3B3B3B181818B9B9B9BBBBBBBBBBBB5C5C5C00
          00008C8C8CBABABABDBDBDB8B8B81C1C1C444444DC00FFDC00FFDC00FF757575
          0000007C7C7CBCBCBCC1C1C15E5E5E0000008E8E8EC2C2C2BEBEBE7B7B7B0000
          00747474DC00FFDC00FFDC00FFDC00FF2121210A0A0AA0A0A0C3C3C361616100
          0000919191C1C1C1A0A0A00C0C0C212121DC00FFDC00FFDC00FFDC00FFDC00FF
          DC00FF1919190101019F9F9F656565010101949494A4A4A40000001A1A1ADC00
          FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FF4C4C4CA6A6A664646400
          00009C9C9CA6A6A64A4A4ADC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FF
          DC00FFDC00FFDC00FFDC00FF6666660303039A9A9ADC00FFDC00FFDC00FFDC00
          FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC
          00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FF}
        ParentShowHint = False
        ShowHint = True
        OnClick = SpeedButton1Click
      end
      object SpeedButton2: TSpeedButton
        Left = 637
        Top = 12
        Width = 20
        Height = 20
        Hint = 'ssh root Login (via putty)'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C40E0000C40E00000000000000000000DC00FFDC00FF
          DC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00
          FFDC00FFDC00FFDC00FFDC00FFDC00FFB1987FB1987FB1987FB1987FB1987FB1
          987FB1987FB1987FB1987FB1987FB1987FB1987FDC00FFDC00FFDC00FFDC00FF
          DC00FFB1987FB1987FB1987FB1987FB1987FB1987FB1987FB1987FB1987FB198
          7FDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFB1987FB1
          987FB1987FDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FF663300
          663300663300663300663300663300663300663300663300663300663300FF94
          00663300663300DC00FFDC00FF66330000000000000000000000000000000000
          0000000000000000000000000000000000000000663300DC00FFDC00FF663300
          0000000000000000000000000000000000000000000000000000000000000000
          00000000663300DC00FFDC00FF6633000000000000FF0000000000FF00000000
          000000FFB600FFB600FFB6000000000000000000663300DC00FFDC00FF663300
          0000000000FF0000000000FF00000000000000FFB600FFB600FFB60000000000
          00000000663300DC00FFDC00FF6633000000FF0000FF0000FF0000FF0000FF00
          000000FFB600FFB600FFB6000000000000000000663300DC00FFDC00FF663300
          0000000000FF0000000000FF00000000000000FFB600FFB600FFB60000000000
          00000000663300DC00FFDC00FF6633000000FF0000FF0000FF0000FF0000FF00
          000000FFB600FFB600FFB6000000000000000000663300DC00FFDC00FF663300
          0000000000FF0000000000FF00000000000000FFB600FFB600FFB60000000000
          00000000663300DC00FFDC00FF66330000000000000000000000000000000000
          0000000000000000000000000000000000000000663300DC00FFDC00FF663300
          6633006633006633006633006633006633006633006633006633006633006633
          00663300663300DC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC
          00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FFDC00FF}
        ParentShowHint = False
        ShowHint = True
        OnClick = SpeedButton2Click
      end
      object SpeedButton3: TSpeedButton
        Left = 590
        Top = 12
        Width = 21
        Height = 20
        Hint = 'Firebird-Version abfragen'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFE1E1FEA3A5FB5658F74749F75658F79496FAE1E2FEFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB3B7FC3740F63745F60A19F40A
          19F40A19F40A19F40A19F40A19F4858EFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          A4AEFB0A22F43850F60A28F40A28F40A28F40A28F40A28F40A28F40A28F40A28
          F4667AF8FFFFFFFFFFFFFFFFFFB3C0FC0931F4284AF51944F50A37F40A37F40A
          37F40A37F40A37F40A37F40A37F40A37F40A37F4859CFAFFFFFFFFFFFF2958F5
          0A40F494ACFA0A45F40A45F40A45F40A45F40A45F40A45F40A45F40A45F40A45
          F40A45F40A45F4E1E9FEB3C8FC0A4EF4769BF9C2D5FD0A53F50A53F50A53F50A
          53F50A53F594B3FBB3C8FC6693F90A53F50A53F50A53F594B5FB85AEFA0B5DF5
          F1F5FEE1EBFE0B61F50B61F50B61F50B61F50B61F5B3CFFCFFFFFFFFFFFFD2E1
          FD1A6BF60B61F54889F84891F84891F8FFFFFFFFFFFF76AEF90B70F50B70F50B
          70F50B70F51A79F6F1F7FEFFFFFFFFFFFF85B7FA0B70F54894F8499CF886BDFA
          FFFFFFFFFFFFFFFFFFC3DEFD499EF80C7FF50C7FF50C7FF595C7FBFFFFFFFFFF
          FFD2E7FD0C7FF5499FF885C5FA76BEF9FFFFFFFFFFFFF1F9FEB4DDFCF1F9FE1A
          94F60B8DF50B8DF585C6FAFFFFFFFFFFFFFFFFFF0B8DF548AAF8B4DFFC3AADF7
          FFFFFFFFFFFF67C1F90C9CF50C9CF50C9CF50C9CF53AAEF7E1F3FEFFFFFFFFFF
          FFF1FAFE0C9CF595D3FBFFFFFF2AB3F6C3EAFDFFFFFFE1F4FE85D4FA0BABF50B
          ABF50BABF576CFF9A4E0FBFFFFFFFFFFFFA4E0FB1AB0F6F1FAFEFFFFFFC3EDFD
          3AC6F7F1FBFEFFFFFFFFFFFF95DFFBA4E4FBFFFFFFFFFFFFFFFFFFFFFFFFF1FB
          FE2AC4F695E0FBFFFFFFFFFFFFFFFFFFA4E9FB58DAF8F1FCFEFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFF1FCFE58DBF867DBF9FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFB4F1FC49E0F8C3F6FDFFFFFFFFFFFFFFFFFFFFFFFFA4F2FB3ADFF795EC
          FBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA4F4FB85F1FAC3
          F9FDC3F9FD85F2FAA4F4FBF1FDFEFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
        OnClick = SpeedButton3Click
      end
      object SpeedButton4: TSpeedButton
        Left = 565
        Top = 12
        Width = 22
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C40E0000C40E00000000000000000000FF00FF444444
          0407050407050407050407050407050407050407050407050407050407050407
          050407056E6E6EFF00FF44444428492E63BD7464C9775EC57257C16C51BD664B
          B96145B65C40B2573BAF5332AA4B32AA4B2A99421523186E6E6E0407056BC37B
          73D3856BCD7D64C9775EC57257C16C51BD664BB96145B65C40B2573BAF5332AA
          4B32AA4B2A99420407050407057FDA8F78D68973D3856BCD7D65C9785EC57251
          BD664BB9614BB96145B65C40B2573BAF5332AA4B32AA4B04070504070586DE95
          7FDA8F78D6896BC37B3866411523180407050407051523182A5F3543AA5840B2
          573BAF5332AA4B0407050407058DE39C86DE955C99670F151058585804070504
          07050407050F15105858580F151035834540B2573BAF5304070504070592E6A0
          6090680407053D3D3DA9A9A9040705040705040705040705B2B2B23D3D3D0407
          05337C4245B65C0407050407057FC089040705040705D1D1D18E8E8E04070504
          07050407050407058E8E8EC9C9C90407050407053D99500407050407058BCF96
          0F1510040705C1C1C18E8E8E1A1A1AD1D1D10407050407058E8E8EBBBBBB0407
          050F151043AA58040705040705A8F4B477B0800407052A2A2AB2B2B22A2A2AF3
          F3F30F1510040705B2B2B22A2A2A04070546935551BD66040705040705A8F4B4
          A8F4B47FBC891523184444440407050407050407050F151044444415231854A3
          635EC57257C16C040705040705ADF7B8A8F4B4A8F4B499EAA66090682D42300F
          15100F15102D423046935571CE826BCD7D65C9785EC572040705040705B1FABC
          ADF7B8A8F4B4A8F4B49EEEAB99EAA692E6A08DE39C86DE9586DE9578D68973D3
          856BCD7D65C978040705040705A6E7AFB1FABCADF7B8A8F4B4A8F4B49EEEAB99
          EAA692E6A08DE39C86DE9586DE957FDA8F73D38563BD740407056E6E6E405944
          A6E7AFB1FABCADF8B9A8F4B4A8F4B49EEEAB9EEEAB92E6A08DE39C86DE9586DE
          9570C57F28492E444444FF00FF6E6E6E04070504070504070504070504070504
          0705040705040705040705040705040705040705444444FF00FF}
        OnClick = SpeedButton4Click
      end
      object SpeedButton5: TSpeedButton
        Left = 660
        Top = 12
        Width = 20
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Glyph.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          08000000000000010000C40E0000C40E000000010000000000000000FF000303
          FF000004FF000006FF00000BFF000C0CFF000016FF001414FF001515FF001A1A
          FF001E1EFF000028FF00002AFF000034FF00202AFF002828FF002929FF003C3C
          FF003E3EFF003F3FFF000042FF000044FF000049FF00004DFF000054FF001457
          FF000061FF000062FF000066FF000068FF000073FF002F6BFF004141FF004848
          FF004B4BFF005454FF005959FF006060FF006565FF006B6BFF006C6CFF007A7A
          FF007B7BFF000083FF000092FF00009AFF0000A1FF0000A4FF0000ADFF0000AE
          FF0000B0FF0000B3FF0000B5FF0000B6FF0000B8FF0000BAFF0000BCFF0014B5
          FF0014BBFF0000C3FF0000CAFF008181FF008484FF008787FF008C8CFF009595
          FF009D9DFF00A0A0FF00A3A3FF00A8A8FF00A9A9FF00ABABFF00AEAEFF00BABA
          FF00BCBCFF00C4C4FF00D6D6FF00D7D7FF00DADAFF00DEDEFF00E4E4FF00E8E8
          FF00EDEDFF00EFEFFF00F0F0FF00F6F6FF00F7F7FF00F8F8FF00FAFAFF00FFFF
          FF00000000000000000000000000000000000000000000000000000000000000
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
          0000000000000000000000000000000000000000000000000000131313134E1F
          3A39393A1925571313131313134C0E2D353131342D044B13131313134D101838
          3230323337182213131313134500172C1E36312F35150549131313132400020B
          1B3B1A0C2B02004213131313000000001C3C0D001603000F1313131327000000
          1D2E060000000008131313134700000006140000000000411313131348000000
          000000000000004613131313582A000000000000000000431313131313132600
          090A0001280010511313131313134000444A00004A113E131313131313132913
          5455120750484F131313131313133F4B13132023131313131313131313135356
          1313213D13131313131313131313131313132A52131313131313}
        OnClick = SpeedButton5Click
      end
      object SpeedButton6: TSpeedButton
        Left = 613
        Top = 12
        Width = 22
        Height = 20
        Hint = 'grafisches xterm starten (via plink+Xming)'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C40E0000C40E00000000000000000000FFFFFFEDF3F7
          C0D4DF8EB0C35292B7407A9ACDCFD1F7F7F7F7F7F7F3F3F396A7B22E81BB83A8
          C7FDFDFDFFFFFFFFFFFFFFFFFF52B0D92DB5EA2DBDF32DC7FE2FB3EB5F727C76
          72715B5A5A2B27272665882ABEFF2AB3F65EA7D7C6D9EAFFFFFFFFFFFF6AC3E6
          2ECBFC2DC5F82AC7FE33829CCFCAC8FFFFFFFFFFFFBAB3B1338DBC28BCFF29BC
          FF29BCFE4BB7EFFFFFFFFFFFFF71C4E32DC7F82ECFFF24A1C94B5153D8D5D4FF
          FFFFFEFFFFFFFDFA36BEF627A4E22891C938B9F5B8E4FAFFFFFFFFFFFFEEF7FA
          AED2E12AA7D07098A4EFE8E6FCFDFDFAFCFCFCFDFDFFFFFF53CFFD2D55602724
          247F9EA6FFFFFFFFFFFFFFFFFFFFFFFFE7E6E63B3C3DC2BFBFFFFFFFF6F7F7FA
          FCFCFCFDFDFDFFFFFFFFFF5E5D5D242424817F7FFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF7C7C7CA5A5A5FFFFFFF7F9F9FBFCFCFCFDFDFEFFFFFEFFFF5151512524
          248F8D8DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCECECE585757F1F3F3FEFFFFFC
          FDFDFCFDFDFEFFFFC2C3C3383838272727C7C6C6FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFDFDFD5C5C5CB1B1B1FFFFFFFDFCFCFCFCFCF0F1F14342422424246664
          64FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDDDDDD807F7FF6F4F3E7
          E5E6FFFEFCC1C2C22D2D2D464646E7E7E7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFAEADAD6FAEBE46C2E17AD0EA797D7F343131B8B7B7FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBDBD2FB2CF2F
          DDFC30D7F7347083544C4BF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFACA9A94A5256C7D5D8B1B9BB414141575757FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9796963938382D
          2C2A3E3D3C2E2D2D616161FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFC1C1C1242424242424282828323232AFADADFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF75747429
          2828343434A6A1A1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
        OnClick = SpeedButton6Click
      end
      object IB_Grid4: TIB_Grid
        Left = 4
        Top = 37
        Width = 285
        Height = 507
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        CustomGlyphsSupplied = []
        DataSource = IB_DataSource4
        TabOrder = 0
        DefaultRowHeight = 16
      end
      object IB_UpdateBar4: TIB_UpdateBar
        Left = 708
        Top = 12
        Width = 180
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Flat = False
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 1
        DataSource = IB_DataSource4
        ReceiveFocus = False
        CustomGlyphsSupplied = []
        VisibleButtons = [ubEdit, ubInsert, ubDelete, ubPost, ubCancel, ubRefreshAll]
      end
      object IB_Memo1: TIB_Memo
        Left = 297
        Top = 37
        Width = 594
        Height = 507
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        DataField = 'INFO'
        DataSource = IB_DataSource4
        TabOrder = 2
        AutoSize = False
      end
    end
    object TabSheet2: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Kryptographie'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label7: TLabel
        Left = 86
        Top = 47
        Width = 43
        Height = 12
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Klartext'
      end
      object Label8: TLabel
        Left = 89
        Top = 128
        Width = 41
        Height = 12
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Base64'
      end
      object Label9: TLabel
        Left = 77
        Top = 99
        Width = 54
        Height = 12
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Rauschen'
      end
      object Label10: TLabel
        Left = 281
        Top = 47
        Width = 41
        Height = 12
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Integer'
      end
      object Label11: TLabel
        Left = 88
        Top = 158
        Width = 41
        Height = 12
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'rfc1738'
      end
      object Label12: TLabel
        Left = 89
        Top = 23
        Width = 20
        Height = 12
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Key'
      end
      object Label14: TLabel
        Left = 131
        Top = 283
        Width = 289
        Height = 12
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '*.log Dateien eines Caretakers direkt entschl'#252'sseln'
      end
      object Label15: TLabel
        Left = 28
        Top = 188
        Width = 104
        Height = 12
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'DatabasePassword'
      end
      object Edit1: TEdit
        Left = 133
        Top = 44
        Width = 119
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 0
        Text = 'Edit1'
      end
      object Edit2: TEdit
        Left = 133
        Top = 96
        Width = 311
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 1
        Text = 'Edit2'
      end
      object Edit3: TEdit
        Left = 133
        Top = 125
        Width = 311
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 2
        Text = 'Edit3'
      end
      object Edit4: TEdit
        Left = 325
        Top = 44
        Width = 119
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 3
        Text = 'Edit4'
      end
      object Edit5: TEdit
        Left = 133
        Top = 155
        Width = 311
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 4
        Text = 'Edit5'
      end
      object Button7: TButton
        Left = 458
        Top = 153
        Width = 69
        Height = 23
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'decode'
        TabOrder = 5
        OnClick = Button7Click
      end
      object Edit6: TEdit
        Left = 133
        Top = 20
        Width = 119
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 6
        Text = '<default>'
      end
      object Button8: TButton
        Left = 248
        Top = 299
        Width = 97
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'entschl'#252'sseln'
        TabOrder = 7
      end
      object Edit7: TEdit
        Left = 131
        Top = 300
        Width = 111
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 8
        Text = 'W:\caretaker\'
      end
      object Edit9: TEdit
        Left = 133
        Top = 185
        Width = 311
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 9
        Text = 'Edit9'
      end
      object Button9: TButton
        Left = 458
        Top = 183
        Width = 69
        Height = 23
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'decode'
        TabOrder = 10
        OnClick = Button9Click
      end
    end
    object TabSheet4: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Funktions Sicherstellung'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label16: TLabel
        Left = 8
        Top = 8
        Width = 84
        Height = 12
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Testergebnisse'
      end
      object Label17: TLabel
        Left = 8
        Top = 476
        Width = 95
        Height = 12
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Namespace &Filter'
        FocusControl = Edit10
      end
      object ListBox2: TListBox
        Left = 8
        Top = 25
        Width = 879
        Height = 442
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ItemHeight = 12
        TabOrder = 0
      end
      object Button10: TButton
        Left = 792
        Top = 472
        Width = 95
        Height = 23
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Tests &starten'
        TabOrder = 1
        OnClick = Button10Click
      end
      object Edit10: TEdit
        Left = 107
        Top = 473
        Width = 677
        Height = 20
        Hint = '~test~.~namspace~'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Text = '*.*'
      end
    end
  end
  object IB_Query1: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED')
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select * from TICKET_GRUPPE for update')
    ColorScheme = True
    OrderingItems.Strings = (
      'NAME=NAME;NAME DESC'
      'RID=RID;RID DESC')
    OrderingLinks.Strings = (
      'NAME=ITEM=1'
      'RID=ITEM=2')
    RequestLive = True
    Left = 56
    Top = 96
  end
  object IB_Query2: TIB_Query
    DatabaseName = '192.168.115.6:test.fdb'
    FieldsVisible.Strings = (
      'DB_KEY=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select * from TICKET_QUELLE for update')
    ColorScheme = True
    OrderingItems.Strings = (
      'TICKET_RECHNER_R=TICKET_RECHNER_R;TICKET_RECHNER_R DESC'
      'TICKET_GRUPPE_R=TICKET_GRUPPE_R;TICKET_GRUPPE_R DESC')
    OrderingLinks.Strings = (
      'TICKET_RECHNER_R=ITEM=1'
      'TICKET_GRUPPE_R=ITEM=2')
    RequestLive = True
    Left = 56
    Top = 240
  end
  object IB_Query3: TIB_Query
    DatabaseName = '192.168.115.6:test.fdb'
    FieldsVisible.Strings = (
      'DB_KEY=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select * from TICKET_ZIEL for update')
    ColorScheme = True
    OrderingItems.Strings = (
      'TICKET_GRUPPE_R=TICKET_GRUPPE_R;TICKET_GRUPPE_R DESC'
      'TICKET_PERSON_R=TICKET_PERSON_R;TICKET_PERSON_R DESC')
    OrderingLinks.Strings = (
      'TICKET_GRUPPE_R=ITEM=1'
      'TICKET_PERSON_R=ITEM=2')
    RequestLive = True
    Left = 632
    Top = 256
  end
  object IB_Query4: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED')
    DatabaseName = '192.168.115.6:test.fdb'
    FieldsVisible.Strings = (
      'INFO=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select '
      ' * '
      'from '
      ' RECHNER '
      'order by '
      ' HOST'
      'for '
      ' update')
    ColorScheme = True
    KeyLinks.Strings = (
      'RECHNER.RID')
    OrderingItems.Strings = (
      'INFO=INFO;INFO DESC'
      'HOST=HOST;HOST DESC'
      'RID=RID;RID DESC')
    OrderingLinks.Strings = (
      'INFO=ITEM=1'
      'HOST=ITEM=2'
      'RID=ITEM=3')
    RequestLive = True
    Left = 520
    Top = 96
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 88
    Top = 96
  end
  object IB_DataSource2: TIB_DataSource
    Dataset = IB_Query2
    Left = 88
    Top = 240
  end
  object IB_DataSource3: TIB_DataSource
    Dataset = IB_Query3
    Left = 664
    Top = 256
  end
  object IB_DataSource4: TIB_DataSource
    Dataset = IB_Query4
    Left = 552
    Top = 96
  end
  object IB_Query5: TIB_Query
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select * from TICKET where'
      ' MOMENT>CURRENT_TIMESTAMP-3'
      'for update')
    ColorScheme = True
    OrderingItems.Strings = (
      'RID=RID;RID DESC'
      'MOMENT=MOMENT;MOMENT DESC'
      'EMAIL=EMAIL;EMAIL DESC'
      'NUMMER=NUMMER;NUMMER DESC'
      'INFO=INFO;INFO DESC'
      'RECHNER_R=RECHNER_R;RECHNER_R DESC')
    OrderingLinks.Strings = (
      'RID=ITEM=1'
      'MOMENT=ITEM=2'
      'EMAIL=ITEM=3'
      'NUMMER=ITEM=4'
      'INFO=ITEM=5'
      'RECHNER_R=ITEM=6')
    RequestLive = True
    Left = 72
    Top = 424
  end
  object IB_DataSource5: TIB_DataSource
    Dataset = IB_Query5
    Left = 136
    Top = 424
  end
  object IdSNMP1: TIdSNMP
    Host = '192.168.115.191'
    ReceiveTimeout = 5000
    Community = 'public'
    Left = 416
    Top = 112
  end
end
