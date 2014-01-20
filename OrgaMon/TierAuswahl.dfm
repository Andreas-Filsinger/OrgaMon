object FormTierAuswahl: TFormTierAuswahl
  Left = 275
  Top = 122
  Caption = 'Tier Auswahl'
  ClientHeight = 249
  ClientWidth = 486
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 64
    Height = 14
    Caption = 'Tierauswahl'
  end
  object IB_Grid1: TIB_Grid
    Left = 8
    Top = 32
    Width = 473
    Height = 169
    CustomGlyphsSupplied = []
    DataSource = IB_DataSource1
    TabOrder = 0
  end
  object Button1: TButton
    Left = 408
    Top = 208
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 320
    Top = 208
    Width = 83
    Height = 25
    Caption = 'ab&brechen'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 456
    Top = 8
    Width = 22
    Height = 22
    Caption = '&T'
    TabOrder = 3
    OnClick = Button3Click
  end
  object IB_DataSource1: TIB_DataSource
    Dataset = IB_Query1
    Left = 64
    Top = 56
  end
  object IB_Query1: TIB_Query
    DatabaseName = '192.168.115.25:test.fdb'
    FieldsDisplayLabel.Strings = (
      'RASSE=Rasse'
      'NAME=Name'
      'GEBURT=Geburtsdatum'
      'ART=Art')
    FieldsDisplayWidth.Strings = (
      'ART=130'
      'RASSE=130'
      'NAME=100'
      'GEBURT=90')
    FieldsVisible.Strings = (
      'RID=FALSE'
      'PERSON_R=FALSE')
    IB_Connection = DataModuleDatenbank.IB_Connection1
    SQL.Strings = (
      'select '
      ' art,'
      ' rasse,'
      ' name,'
      ' geburt ,'
      'RID,'
      'PERSON_R'
      'from '
      ' tier '
      'where'
      ' person_r=:CROSSREF'
      'FOR UPDATE')
    RequestLive = True
    Left = 32
    Top = 56
  end
end
