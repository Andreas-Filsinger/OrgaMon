object FormFotoMeldung: TFormFotoMeldung
  Left = 0
  Top = 0
  Caption = 'FormFotoMeldung'
  ClientHeight = 412
  ClientWidth = 496
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 243
    Height = 35
    Caption = 'beziehe TAN ...'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -29
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 204
    Top = 261
    Width = 22
    Height = 13
    Alignment = taRightJustify
    Caption = 'RID'
  end
  object Label3: TLabel
    Left = 164
    Top = 288
    Width = 62
    Height = 13
    Alignment = taRightJustify
    Caption = 'Dateiname'
  end
  object Label4: TLabel
    Left = 194
    Top = 234
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Ger'#228't'
  end
  object Edit1: TEdit
    Left = 232
    Top = 258
    Width = 81
    Height = 21
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 232
    Top = 285
    Width = 217
    Height = 21
    TabOrder = 1
  end
  object RadioButton1: TRadioButton
    Left = 78
    Top = 312
    Width = 169
    Height = 17
    Alignment = taLeftJustify
    Caption = 'FA (Foto vom Ausbau)'
    Checked = True
    TabOrder = 2
    TabStop = True
  end
  object RadioButton2: TRadioButton
    Left = 46
    Top = 335
    Width = 201
    Height = 17
    Alignment = taLeftJustify
    Caption = 'FN (Foto vom Einbauz'#228'hler)'
    TabOrder = 3
  end
  object Button1: TButton
    Left = 269
    Top = 376
    Width = 75
    Height = 25
    Caption = 'Ende'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 350
    Top = 376
    Width = 131
    Height = 25
    Caption = 'n'#228'chste Zuordnung'
    TabOrder = 5
    OnClick = Button2Click
  end
  object ListBox1: TListBox
    Left = 16
    Top = 57
    Width = 465
    Height = 168
    ItemHeight = 13
    TabOrder = 6
  end
  object Edit3: TEdit
    Left = 232
    Top = 231
    Width = 41
    Height = 21
    TabOrder = 7
    Text = '000'
    OnChange = Edit3Change
  end
end
