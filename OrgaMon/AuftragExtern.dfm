object FormAuftragExtern: TFormAuftragExtern
  Left = 140
  Top = 163
  Caption = 'Auftrag Extern'
  ClientHeight = 220
  ClientWidth = 738
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 11
    Top = 10
    Width = 528
    Height = 25
    Caption = 'OrgaMon'#8482' Ausgabe Externer Auftragsrouten'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 13
    Top = 160
    Width = 41
    Height = 13
    Caption = 'Vorlauf'
  end
  object Label3: TLabel
    Left = 104
    Top = 160
    Width = 28
    Height = 13
    Caption = 'Tage'
  end
  object ListBox1: TListBox
    Left = 11
    Top = 50
    Width = 721
    Height = 97
    ItemHeight = 13
    TabOrder = 0
  end
  object ProgressBar1: TProgressBar
    Left = 11
    Top = 184
    Width = 633
    Height = 26
    TabOrder = 1
  end
  object Button1: TButton
    Left = 657
    Top = 186
    Width = 77
    Height = 25
    Caption = 'Start'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 59
    Top = 156
    Width = 41
    Height = 21
    TabOrder = 3
    Text = '9'
  end
  object XLSAdapter1: TXLSAdapter
    AllowOverwritingFiles = False
    Left = 56
    Top = 72
  end
  object FlexCelImport1: TFlexCelImport
    Adapter = XLSAdapter1
    Left = 176
    Top = 72
  end
end
