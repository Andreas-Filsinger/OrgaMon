object FormPreAuftrag: TFormPreAuftrag
  Left = -2
  Top = 103
  Caption = 'Auftrags Neuanlage'
  ClientHeight = 195
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 94
    Height = 13
    Caption = 'Auftragsmedium'
  end
  object Label2: TLabel
    Left = 208
    Top = 8
    Width = 108
    Height = 13
    Caption = 'Auftragsmotivation'
  end
  object Button1: TButton
    Left = 358
    Top = 160
    Width = 75
    Height = 25
    Caption = '&OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 279
    Top = 160
    Width = 75
    Height = 25
    Caption = 'ab&brechen'
    TabOrder = 1
    OnClick = Button2Click
  end
  object CheckListBox1: TCheckListBox
    Left = 8
    Top = 24
    Width = 193
    Height = 129
    ItemHeight = 13
    TabOrder = 2
  end
  object CheckListBox2: TCheckListBox
    Left = 208
    Top = 24
    Width = 225
    Height = 129
    ItemHeight = 13
    TabOrder = 3
  end
end
