object FormBudget: TFormBudget
  Left = 80
  Top = 57
  Caption = 'Budgetarbeitsplatz'
  ClientHeight = 553
  ClientWidth = 849
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 194
    Top = 10
    Width = 23
    Height = 23
    Hint = 'bei den Arbeitszeiten fehlende Monteure nachtragen'
    Glyph.Data = {
      E6000000424DE60000000000000076000000280000000E0000000E0000000100
      04000000000070000000C40E0000C40E000010000000000000009999660000FF
      FF00009CCE0063CEFF0000319C003163CE0000008400FFFFFF00C0C0C0006666
      6600313131000000000000000000000000000000000000000000BBBBBBBBBBB7
      77009777777777B7770097BBB00007B7770097BB3B7777B7770097B33BB007B7
      7700977BB22B77B777009700B112B7B7770097777B112BB77700977777B112B7
      77009999999B112B770077777777B1A6B700777777777B444B007777777777B5
      B70077777777777B7700}
    ParentShowHint = False
    ShowHint = True
    OnClick = SpeedButton1Click
  end
  object IB_Grid1: TIB_Grid
    Left = 7
    Top = 39
    Width = 834
    Height = 234
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    TabOrder = 0
  end
  object IB_UpdateBar1: TIB_UpdateBar
    Left = 7
    Top = 10
    Width = 174
    Height = 23
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    DataSource = IB_DataSource1
    ReceiveFocus = False
    CustomGlyphsSupplied = []
    VisibleButtons = [ubEdit, ubInsert, ubDelete, ubPost, ubCancel, ubRefreshAll]
  end
  object PageControl1: TPageControl
    Left = 7
    Top = 280
    Width = 834
    Height = 257
    ActivePage = TabSheet3
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Belege'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label6: TLabel
        Left = 16
        Top = 7
        Width = 52
        Height = 13
        Caption = 'Zeitraum'
      end
      object Label7: TLabel
        Left = 391
        Top = 7
        Width = 96
        Height = 13
        Caption = 'Buchungs-Status'
      end
      object Label8: TLabel
        Left = 16
        Top = 160
        Width = 72
        Height = 13
        Caption = 'Sub-Budget:'
      end
      object Button3: TButton
        Left = 624
        Top = 180
        Width = 185
        Height = 35
        Caption = 'Arbeitszeit Beleg erstellen'
        TabOrder = 0
        OnClick = Button3Click
      end
      object CheckBox1: TCheckBox
        Left = 16
        Top = 180
        Width = 257
        Height = 17
        Caption = 'Monat durch Sch'#228'tzung vervollst'#228'ndigen'
        TabOrder = 1
      end
      object CheckBox2: TCheckBox
        Left = 391
        Top = 180
        Width = 162
        Height = 17
        Caption = 'Lohnsumme angeben'
        TabOrder = 2
      end
      object CheckBox3: TCheckBox
        Left = 391
        Top = 197
        Width = 123
        Height = 18
        Caption = 'Steuer angeben'
        TabOrder = 3
        OnClick = CheckBox3Click
      end
      object CheckBox4: TCheckBox
        Left = 16
        Top = 197
        Width = 323
        Height = 18
        Caption = 'nur einzelnes Budget (ansonsten alle dieser Person)'
        TabOrder = 4
      end
      object Panel1: TPanel
        Left = 16
        Top = 20
        Width = 361
        Height = 133
        BevelKind = bkFlat
        BevelOuter = bvNone
        BorderWidth = 1
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 5
        object Label5: TLabel
          Left = 235
          Top = 104
          Width = 5
          Height = 13
          Caption = '-'
        end
        object Edit6: TEdit
          Left = 149
          Top = 78
          Width = 61
          Height = 21
          TabOrder = 0
          Text = 'MM.JJJJ'
        end
        object Edit7: TEdit
          Left = 149
          Top = 101
          Width = 79
          Height = 21
          TabOrder = 1
          Text = 'TT.MM.JJJJ'
        end
        object Edit8: TEdit
          Left = 248
          Top = 101
          Width = 81
          Height = 21
          TabOrder = 2
          Text = 'TT.MM.JJJJ'
        end
        object RadioButtonZ_Alle: TRadioButton
          Left = 16
          Top = 7
          Width = 107
          Height = 18
          Caption = 'unbeschr'#228'nkt'
          Checked = True
          TabOrder = 3
          TabStop = True
        end
        object RadioButtonZ_Vormonat: TRadioButton
          Left = 16
          Top = 33
          Width = 84
          Height = 16
          Caption = 'Vormonat'
          TabOrder = 4
        end
        object RadioButtonZ_DieserMonat: TRadioButton
          Left = 16
          Top = 56
          Width = 113
          Height = 16
          Caption = 'aktueller Monat'
          TabOrder = 5
        end
        object RadioButtonZ_User: TRadioButton
          Left = 17
          Top = 103
          Width = 106
          Height = 17
          Caption = 'von ... bis ...'
          TabOrder = 6
        end
        object RadioButtonZ_MonatUser: TRadioButton
          Left = 16
          Top = 80
          Width = 113
          Height = 18
          Caption = 'Monat ...'
          TabOrder = 7
        end
      end
      object Panel2: TPanel
        Left = 391
        Top = 20
        Width = 418
        Height = 133
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 6
        object Edit9: TEdit
          Left = 173
          Top = 78
          Width = 197
          Height = 21
          TabOrder = 0
          Text = 'RID,RID,...'
        end
        object RadioButtonB_Alle: TRadioButton
          Left = 7
          Top = 7
          Width = 114
          Height = 18
          Caption = 'alle'
          TabOrder = 1
        end
        object RadioButtonB_ungebuchte: TRadioButton
          Left = 7
          Top = 33
          Width = 114
          Height = 16
          Caption = 'ungebuchte'
          Checked = True
          TabOrder = 2
          TabStop = True
        end
        object RadioButtonB_gebuchteUser: TRadioButton
          Left = 7
          Top = 80
          Width = 162
          Height = 18
          Caption = 'gebuchte in Beleg # ...'
          TabOrder = 3
        end
        object RadioButtonB_gebuchte: TRadioButton
          Left = 7
          Top = 56
          Width = 114
          Height = 16
          Caption = 'gebuchte'
          TabOrder = 4
        end
      end
      object Edit10: TEdit
        Left = 104
        Top = 157
        Width = 121
        Height = 21
        TabOrder = 7
        Text = '*'
      end
      object CheckBox5: TCheckBox
        Left = 392
        Top = 162
        Width = 177
        Height = 16
        Caption = 'Stundensatz angeben'
        Checked = True
        State = cbChecked
        TabOrder = 8
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Berechnung'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 24
        Top = 27
        Width = 57
        Height = 13
        Caption = 'Sekunden'
      end
      object Label2: TLabel
        Left = 250
        Top = 54
        Width = 152
        Height = 13
        Caption = 'Krankenversicherung 13%'
      end
      object Label3: TLabel
        Left = 258
        Top = 81
        Width = 144
        Height = 13
        Caption = 'Rentenversicherung 15%'
      end
      object Label4: TLabel
        Left = 254
        Top = 108
        Width = 147
        Height = 13
        Caption = 'Pauschalversicherung 2%'
      end
      object Edit1: TEdit
        Left = 87
        Top = 24
        Width = 121
        Height = 21
        TabOrder = 0
        Text = '0'
      end
      object Button2: TButton
        Left = 224
        Top = 22
        Width = 178
        Height = 24
        Caption = 'Arbeitsentgelt berechnen'
        TabOrder = 1
        OnClick = Button2Click
      end
      object Edit2: TEdit
        Left = 409
        Top = 24
        Width = 120
        Height = 21
        ReadOnly = True
        TabOrder = 2
        Text = '0,00 '#8364
      end
      object Edit3: TEdit
        Left = 409
        Top = 51
        Width = 120
        Height = 21
        ReadOnly = True
        TabOrder = 3
        Text = 'Edit3'
      end
      object Edit4: TEdit
        Left = 409
        Top = 78
        Width = 120
        Height = 21
        ReadOnly = True
        TabOrder = 4
        Text = 'Edit4'
      end
      object Edit5: TEdit
        Left = 409
        Top = 105
        Width = 120
        Height = 21
        ReadOnly = True
        TabOrder = 5
        Text = 'Edit5'
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Verbuchen'
      ImageIndex = 2
      object Label9: TLabel
        Left = 16
        Top = 16
        Width = 638
        Height = 13
        Caption = 
          'Eintrag einer Belegnummer falls unverbucht - Grundlage ist der  ' +
          'zuletzt erstellte Arbeitszeitbeleg'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
      end
      object Label10: TLabel
        Left = 24
        Top = 56
        Width = 45
        Height = 13
        Caption = 'Beleg #'
      end
      object Edit11: TEdit
        Left = 77
        Top = 53
        Width = 80
        Height = 21
        TabOrder = 0
      end
      object Button11: TButton
        Left = 162
        Top = 53
        Width = 21
        Height = 22
        Hint = 'Beleg# in die Arbeitszeiten eintragen'
        Caption = '*'
        Font.Charset = SYMBOL_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Wingdings'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = Button11Click
      end
    end
  end
  object Button1: TButton
    Left = 818
    Top = 7
    Width = 23
    Height = 25
    Caption = '&A'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button4: TButton
    Left = 791
    Top = 7
    Width = 22
    Height = 25
    Caption = '&P'
    TabOrder = 4
    OnClick = Button4Click
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 64
    Top = 64
  end
  object IB_Query1: TIB_Query
    ColumnAttributes.Strings = (
      'RID=NOTREQUIRED')
    DatabaseName = '192.168.115.6:test.fdb'
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select '
      ' * '
      'from '
      ' BUGET '
      'for update')
    ColorScheme = True
    RequestLive = True
    Left = 32
    Top = 64
  end
end
