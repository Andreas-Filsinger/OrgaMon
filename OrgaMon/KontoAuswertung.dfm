object FormKontoAuswertung: TFormKontoAuswertung
  Left = 221
  Top = 141
  Caption = 'FormKontoAuswertung'
  ClientHeight = 561
  ClientWidth = 607
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 384
    Top = 16
    Width = 35
    Height = 13
    Caption = 'Fehler'
  end
  object Label2: TLabel
    Left = 17
    Top = 200
    Width = 86
    Height = 13
    Caption = 'Ausgabe Konto'
  end
  object von: TLabel
    Left = 31
    Top = 100
    Width = 21
    Height = 13
    Caption = 'von'
  end
  object bis: TLabel
    Left = 36
    Top = 123
    Width = 16
    Height = 13
    Caption = 'bis'
  end
  object Label3: TLabel
    Left = 125
    Top = 100
    Width = 44
    Height = 13
    Caption = '(tt.mm)'
  end
  object Label4: TLabel
    Left = 125
    Top = 124
    Width = 44
    Height = 13
    Caption = '(tt.mm)'
  end
  object Label5: TLabel
    Left = 28
    Top = 76
    Width = 24
    Height = 13
    Caption = 'Jahr'
  end
  object Label6: TLabel
    Left = 127
    Top = 76
    Width = 26
    Height = 13
    Caption = '(jjjj)'
  end
  object Label7: TLabel
    Left = 248
    Top = 80
    Width = 51
    Height = 13
    Caption = 'W'#228'hrung'
  end
  object Button1: TButton
    Left = 219
    Top = 10
    Width = 86
    Height = 21
    Caption = 'laden'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 16
    Top = 9
    Width = 193
    Height = 21
    TabOrder = 1
    Text = 'G:\doc\10504104\2000-fk6.txt'
  end
  object ComboBox1: TComboBox
    Left = 16
    Top = 39
    Width = 193
    Height = 21
    TabOrder = 2
    Text = '*'
  end
  object ListBox1: TListBox
    Left = 384
    Top = 32
    Width = 121
    Height = 97
    ItemHeight = 13
    TabOrder = 3
  end
  object Button2: TButton
    Left = 17
    Top = 160
    Width = 133
    Height = 29
    Caption = 'auswerten'
    TabOrder = 4
    OnClick = Button2Click
  end
  object ListBox2: TListBox
    Left = 16
    Top = 216
    Width = 593
    Height = 313
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 5
  end
  object speichern: TButton
    Left = 20
    Top = 540
    Width = 181
    Height = 21
    Caption = '-> in den Editor'
    TabOrder = 6
    OnClick = speichernClick
  end
  object Edit2: TEdit
    Left = 56
    Top = 96
    Width = 65
    Height = 21
    TabOrder = 7
    Text = '01.04'
  end
  object Edit3: TEdit
    Left = 56
    Top = 120
    Width = 65
    Height = 21
    TabOrder = 8
    Text = '30.06'
  end
  object Button3: TButton
    Left = 310
    Top = 10
    Width = 49
    Height = 21
    Caption = 'edit'
    TabOrder = 9
    OnClick = Button3Click
  end
  object CheckBox1: TCheckBox
    Left = 192
    Top = 104
    Width = 97
    Height = 17
    Caption = 'nur Haben'
    TabOrder = 10
  end
  object CheckBox2: TCheckBox
    Left = 192
    Top = 120
    Width = 97
    Height = 17
    Caption = 'nur Soll'
    TabOrder = 11
  end
  object Edit4: TEdit
    Left = 56
    Top = 72
    Width = 65
    Height = 21
    TabOrder = 12
    Text = '2001'
  end
  object ComboBox2: TComboBox
    Left = 192
    Top = 72
    Width = 41
    Height = 21
    TabOrder = 13
    Text = #8364
    Items.Strings = (
      'DM'
      #8364)
  end
end
