object FormPlanquadratNachfrage: TFormPlanquadratNachfrage
  Left = 178
  Top = 175
  BorderStyle = bsDialog
  Caption = 'Nachgefragt'
  ClientHeight = 95
  ClientWidth = 298
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 3
    Top = 47
    Width = 140
    Height = 13
    Caption = 'Import-RIDs ab (0=alle)'
  end
  object Label2: TLabel
    Left = 47
    Top = 73
    Width = 96
    Height = 13
    Caption = 'Maximale Anzahl'
  end
  object Edit1: TEdit
    Left = 147
    Top = 44
    Width = 65
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object Edit2: TEdit
    Left = 147
    Top = 68
    Width = 65
    Height = 21
    TabOrder = 1
    Text = '0'
  end
  object Button1: TButton
    Left = 218
    Top = 42
    Width = 75
    Height = 49
    Caption = 'Start'
    TabOrder = 2
    OnClick = Button1Click
  end
end
