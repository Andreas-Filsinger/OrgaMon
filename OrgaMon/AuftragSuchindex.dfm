object FormAuftragSuchindex: TFormAuftragSuchindex
  Left = 184
  Top = 141
  BorderStyle = bsDialog
  Caption = 'Suchindex zur Auftragsuche'
  ClientHeight = 46
  ClientWidth = 272
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
    Left = 16
    Top = 6
    Width = 23
    Height = 13
    Caption = '#/#'
  end
  object ProgressBar1: TProgressBar
    Left = 16
    Top = 22
    Width = 150
    Height = 16
    TabOrder = 0
  end
  object Button1: TButton
    Left = 184
    Top = 7
    Width = 75
    Height = 31
    Caption = 'Start'
    TabOrder = 1
    OnClick = Button1Click
  end
end
