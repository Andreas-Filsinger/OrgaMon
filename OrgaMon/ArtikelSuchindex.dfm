object FormArtikelSuchindex: TFormArtikelSuchindex
  Left = 326
  Top = 196
  BorderStyle = bsDialog
  Caption = 'Erzeuge Suchindex'
  ClientHeight = 33
  ClientWidth = 227
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressBar1: TProgressBar
    Left = 7
    Top = 7
    Width = 151
    Height = 17
    TabOrder = 0
  end
  object Button1: TButton
    Left = 167
    Top = 7
    Width = 48
    Height = 19
    Caption = '&Start'
    TabOrder = 1
    OnClick = Button1Click
  end
end
