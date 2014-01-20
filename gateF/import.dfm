object FormImport: TFormImport
  Left = 16
  Top = 14
  BorderStyle = bsDialog
  Caption = 'Projekt - Import'
  ClientHeight = 665
  ClientWidth = 992
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 3
    Top = 19
    Width = 94
    Height = 13
    Caption = 'Schema (*%s) :'
  end
  object Label12: TLabel
    Left = 680
    Top = 20
    Width = 307
    Height = 13
    Caption = '(Schema wurde ge'#228'ndert, speichern nicht vergessen)'
    Visible = False
  end
  object ComboBox1: TComboBox
    Left = 163
    Top = 16
    Width = 408
    Height = 21
    TabOrder = 0
  end
  object Button8: TButton
    Left = 571
    Top = 17
    Width = 24
    Height = 19
    Caption = '->'
    TabOrder = 1
    OnClick = Button8Click
  end
  object Button10: TButton
    Left = 596
    Top = 17
    Width = 75
    Height = 19
    Caption = 'speichern'
    TabOrder = 2
    OnClick = Button10Click
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 48
    Width = 993
    Height = 617
    ActivePage = TabSheet1
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = 'definieren'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label5: TLabel
        Left = 2
        Top = 56
        Width = 100
        Height = 13
        Caption = 'Ziel-Daten-Felder'
      end
      object Label6: TLabel
        Left = 259
        Top = 56
        Width = 76
        Height = 13
        Caption = 'Zuordnungen'
      end
      object Label7: TLabel
        Left = 683
        Top = 56
        Width = 136
        Height = 13
        Caption = 'verf'#252'gbare Quell-Felder'
      end
      object Label8: TLabel
        Left = 684
        Top = 355
        Width = 111
        Height = 13
        Caption = 'Beispielhafte Daten'
      end
      object Label14: TLabel
        Left = 823
        Top = 56
        Width = 10
        Height = 13
        Caption = '()'
      end
      object Label4: TLabel
        Left = 363
        Top = 16
        Width = 89
        Height = 13
        Caption = 'Quelle (*.csv) :'
      end
      object Label17: TLabel
        Left = 8
        Top = 16
        Width = 287
        Height = 13
        Caption = 'ordnen Sie hier Datenspalten einander zu ...'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ListBox1: TListBox
        Left = 0
        Top = 72
        Width = 225
        Height = 377
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = ListBox1DblClick
      end
      object ListBox2: TListBox
        Left = 256
        Top = 72
        Width = 425
        Height = 281
        ItemHeight = 13
        TabOrder = 1
        OnKeyDown = ListBox2KeyDown
      end
      object ListBox3: TListBox
        Left = 681
        Top = 72
        Width = 305
        Height = 280
        ItemHeight = 13
        TabOrder = 2
      end
      object ListBox4: TListBox
        Left = 682
        Top = 371
        Width = 305
        Height = 214
        ItemHeight = 13
        TabOrder = 3
      end
      object Button4: TButton
        Left = 228
        Top = 73
        Width = 26
        Height = 19
        Caption = '->'
        TabOrder = 4
        OnClick = Button4Click
      end
      object Panel1: TPanel
        Left = 256
        Top = 360
        Width = 424
        Height = 89
        TabOrder = 5
        object Label9: TLabel
          Left = 8
          Top = 11
          Width = 16
          Height = 13
          Caption = '#1'
        end
        object Label10: TLabel
          Left = 8
          Top = 35
          Width = 16
          Height = 13
          Caption = '#2'
        end
        object Label11: TLabel
          Left = 8
          Top = 60
          Width = 16
          Height = 13
          Caption = '#3'
        end
        object ComboBox3: TComboBox
          Left = 32
          Top = 8
          Width = 337
          Height = 21
          TabOrder = 0
          OnChange = ComboBox3Change
        end
        object ComboBox4: TComboBox
          Left = 32
          Top = 32
          Width = 337
          Height = 21
          TabOrder = 1
          OnChange = ComboBox4Change
        end
        object ComboBox5: TComboBox
          Left = 32
          Top = 56
          Width = 337
          Height = 21
          TabOrder = 2
          OnChange = ComboBox5Change
        end
        object Button5: TButton
          Left = 376
          Top = 9
          Width = 33
          Height = 19
          Caption = '<-'
          TabOrder = 3
          OnClick = Button5Click
        end
        object Button6: TButton
          Left = 376
          Top = 34
          Width = 33
          Height = 19
          Caption = '<-'
          TabOrder = 4
          OnClick = Button6Click
        end
        object Button7: TButton
          Left = 376
          Top = 58
          Width = 33
          Height = 19
          Caption = '<-'
          TabOrder = 5
          OnClick = Button7Click
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 453
        Width = 681
        Height = 132
        Caption = 'Import durchf'#252'hren'
        TabOrder = 6
        object Label13: TLabel
          Left = 8
          Top = 52
          Width = 4
          Height = 13
        end
        object ProgressBar1: TProgressBar
          Left = 9
          Top = 100
          Width = 568
          Height = 16
          TabOrder = 0
        end
        object Button3: TButton
          Left = 587
          Top = 96
          Width = 75
          Height = 25
          Caption = 'Start'
          TabOrder = 1
          OnClick = Button3Click
        end
      end
      object CheckBox2: TCheckBox
        Left = 813
        Top = 353
        Width = 46
        Height = 17
        Caption = 'alle'
        TabOrder = 7
        OnClick = CheckBox2Click
      end
      object Button2: TButton
        Left = 860
        Top = 353
        Width = 75
        Height = 16
        Caption = 'eindeutig?'
        TabOrder = 8
        OnClick = Button2Click
      end
      object ComboBox2: TComboBox
        Left = 459
        Top = 13
        Width = 481
        Height = 21
        TabOrder = 9
        OnChange = ComboBox2Change
      end
      object Button9: TButton
        Left = 945
        Top = 13
        Width = 33
        Height = 19
        Caption = '->'
        TabOrder = 10
        OnClick = Button9Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'filtern'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 8
        Top = 48
        Width = 365
        Height = 13
        Caption = 'Welche Feld-Inhalte f'#252'hren zum weglassen dieses Datensatzes?'
      end
      object Label3: TLabel
        Left = 8
        Top = 80
        Width = 194
        Height = 13
        Caption = 'Pro Feldinhalt bitte nur eine Zeile:'
      end
      object Label18: TLabel
        Left = 8
        Top = 16
        Width = 420
        Height = 13
        Caption = 
          'erstellen Sie hier eine Negativliste unerw'#252'nschter Datens'#228'tze ..' +
          '.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label19: TLabel
        Left = 8
        Top = 64
        Width = 409
        Height = 13
        Caption = 
          'Auf die "Filter A" und "Filter B" Felder werden die Kriterien an' +
          'gewendet!'
      end
      object Memo1: TMemo
        Left = 8
        Top = 96
        Width = 545
        Height = 481
        TabOrder = 0
        OnChange = Memo1Change
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'umsetzen'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label15: TLabel
        Left = 8
        Top = 64
        Width = 271
        Height = 13
        Caption = '(nur Geb'#228'ude, Format <ALT> ["," <NEU>] ";" )'
      end
      object Label16: TLabel
        Left = 8
        Top = 16
        Width = 703
        Height = 13
        Caption = 
          'geben Sie hier an, welche unerw'#252'nschten Bezeichnungen Sie durch ' +
          'andere, oder k'#252'rzere ersetzen wollen ...'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Edit1: TEdit
        Left = 8
        Top = 80
        Width = 897
        Height = 21
        TabOrder = 0
        OnChange = Edit1Change
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'GZS'
    Filter = 'GaZMa Schema (*.ImportSchema)|*.ImportSchema'
    Left = 760
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'GZS'
    Filter = 'GaZMa Schema (*.ImportSchema)|*.ImportSchema'
    Left = 728
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 696
  end
  object OpenDialog2: TOpenDialog
    DefaultExt = 'CSV'
    Filter = 'CSV (Trennzeichen getrennt) (*.csv)|*.csv'
    Left = 664
  end
end
