object FormLAND_R: TFormLAND_R
  Left = 194
  Top = 152
  Caption = 'FormLAND_R'
  ClientHeight = 312
  ClientWidth = 294
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object IB_Text1: TIB_Text
    Left = 16
    Top = 280
    Width = 65
    Height = 17
    DataField = 'STATE'
    DataSource = IB_DataSource1
  end
  object Label1: TLabel
    Left = 16
    Top = 48
    Width = 245
    Height = 13
    Caption = '1) '#252'berf'#252'hrung der korrekten Landesschreibweisen'
  end
  object Label2: TLabel
    Left = 16
    Top = 120
    Width = 214
    Height = 13
    Caption = '2) zur'#252'ckbleibende Eintragungen verbessern'
  end
  object Label3: TLabel
    Left = 88
    Top = 280
    Width = 20
    Height = 13
    Caption = '--->'
  end
  object IB_Grid1: TIB_Grid
    Left = 24
    Top = 144
    Width = 249
    Height = 120
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    TabOrder = 0
  end
  object Button1: TButton
    Left = 208
    Top = 272
    Width = 75
    Height = 25
    Caption = #252'bernehmen'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 32
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 2
    OnClick = Button2Click
  end
  object ComboBox1: TComboBox
    Left = 128
    Top = 272
    Width = 73
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 56
    Top = 8
  end
  object IB_Query1: TIB_Query
    DatabaseName = '192.168.115.90:sewa.fdb'
    IB_Connection = DataModuleHeBu.IB_Connection1
    SQL.Strings = (
      'select distinct '
      ' ('#39'"'#39' || STATE || '#39'"'#39') AS STATE'
      'from anschrift'
      'WHERE '
      ' STATE IS NOT NULL')
    ColorScheme = False
    MasterSearchFlags = [msfOpenMasterOnOpen, msfSearchAppliesToMasterOnly]
    BufferSynchroFlags = []
    FetchWholeRows = True
    Left = 24
    Top = 8
  end
end
