object BesucherPflegeForm: TBesucherPflegeForm
  Left = 127
  Top = 0
  BorderStyle = bsNone
  Caption = 'BesucherPflegeForm'
  ClientHeight = 725
  ClientWidth = 1010
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 60
    Height = 16
    Caption = 'Besucher'
  end
  object Label2: TLabel
    Left = 11
    Top = 444
    Width = 39
    Height = 16
    Caption = 's&uche'
    FocusControl = Edit1
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 32
    Width = 975
    Height = 401
    ColCount = 7
    FixedCols = 0
    RowCount = 2
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goThumbTracking]
    ParentFont = False
    TabOrder = 0
    OnDblClick = StringGrid1DblClick
    OnKeyDown = StringGrid1KeyDown
  end
  object Edit1: TEdit
    Left = 56
    Top = 440
    Width = 225
    Height = 24
    TabOrder = 1
    OnChange = Edit1Change
    OnKeyPress = Edit1KeyPress
    OnKeyUp = Edit1KeyUp
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 480
    Width = 625
    Height = 233
    Caption = 'Besucher Daten'
    TabOrder = 2
    object Label3: TLabel
      Left = 16
      Top = 60
      Width = 36
      Height = 16
      Caption = '&Name'
      FocusControl = Edit2
    end
    object Label4: TLabel
      Left = 16
      Top = 84
      Width = 35
      Height = 16
      Caption = 'Firma'
    end
    object Label5: TLabel
      Left = 16
      Top = 108
      Width = 25
      Height = 16
      Caption = 'KFZ'
    end
    object Label6: TLabel
      Left = 16
      Top = 158
      Width = 71
      Height = 16
      Caption = 'Bemerkung'
    end
    object Label7: TLabel
      Left = 16
      Top = 182
      Width = 91
      Height = 16
      Caption = 'Besuchsgrund'
    end
    object Label8: TLabel
      Left = 16
      Top = 134
      Width = 41
      Height = 16
      Caption = 'Handy'
    end
    object Label9: TLabel
      Left = 16
      Top = 34
      Width = 46
      Height = 16
      Caption = '&Anrede'
    end
    object Edit2: TEdit
      Left = 144
      Top = 58
      Width = 361
      Height = 24
      TabOrder = 0
      OnKeyPress = Edit2KeyPress
    end
    object Edit3: TEdit
      Left = 144
      Top = 82
      Width = 361
      Height = 24
      TabOrder = 1
      OnKeyPress = Edit3KeyPress
    end
    object Edit4: TEdit
      Left = 144
      Top = 106
      Width = 361
      Height = 24
      TabOrder = 2
      OnKeyPress = Edit4KeyPress
    end
    object Edit5: TEdit
      Left = 144
      Top = 130
      Width = 361
      Height = 24
      TabOrder = 3
      OnKeyPress = Edit5KeyPress
    end
    object Edit6: TEdit
      Left = 144
      Top = 154
      Width = 361
      Height = 24
      TabOrder = 4
      OnKeyPress = Edit6KeyPress
    end
    object Panel1: TPanel
      Left = 56
      Top = 68
      Width = 83
      Height = 2
      Enabled = False
      TabOrder = 5
    end
    object Panel2: TPanel
      Left = 56
      Top = 92
      Width = 83
      Height = 2
      Enabled = False
      TabOrder = 6
    end
    object Panel3: TPanel
      Left = 46
      Top = 116
      Width = 92
      Height = 2
      Enabled = False
      TabOrder = 7
    end
    object Panel4: TPanel
      Left = 92
      Top = 166
      Width = 47
      Height = 2
      Enabled = False
      TabOrder = 8
    end
    object Panel5: TPanel
      Left = 112
      Top = 190
      Width = 26
      Height = 2
      Enabled = False
      TabOrder = 9
    end
    object Edit7: TEdit
      Left = 144
      Top = 179
      Width = 361
      Height = 24
      TabOrder = 10
      OnKeyPress = Edit7KeyPress
    end
    object Panel6: TPanel
      Left = 62
      Top = 142
      Width = 76
      Height = 2
      Enabled = False
      TabOrder = 11
    end
    object Button1: TButton
      Left = 520
      Top = 136
      Width = 89
      Height = 41
      Caption = 'Neuanlage'
      TabOrder = 12
      OnClick = Button1Click
    end
    object Button4: TButton
      Left = 520
      Top = 88
      Width = 89
      Height = 41
      Caption = #196'ndern'
      TabOrder = 13
      OnClick = Button4Click
    end
    object ComboBox1: TComboBox
      Left = 144
      Top = 32
      Width = 89
      Height = 24
      ItemHeight = 16
      TabOrder = 14
      Items.Strings = (
        'Herr'
        'Frau'
        'Gruppe')
    end
    object Panel7: TPanel
      Left = 69
      Top = 43
      Width = 70
      Height = 2
      Enabled = False
      TabOrder = 15
    end
  end
  object ListBox1: TListBox
    Left = 648
    Top = 528
    Width = 353
    Height = 153
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Small Fonts'
    Font.Style = []
    ItemHeight = 11
    ParentFont = False
    TabOrder = 3
  end
  object Button2: TButton
    Left = 648
    Top = 688
    Width = 193
    Height = 25
    Caption = 'a&bbrechen'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 848
    Top = 688
    Width = 153
    Height = 25
    Caption = 'Alles buchen'
    TabOrder = 5
    OnClick = Button3Click
  end
end
