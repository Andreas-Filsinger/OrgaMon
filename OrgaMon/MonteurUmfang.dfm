object FormMonteurUmfang: TFormMonteurUmfang
  Left = 218
  Top = 231
  BorderStyle = bsDialog
  Caption = 'Nachgefragt ...'
  ClientHeight = 137
  ClientWidth = 449
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
    Left = 16
    Top = 8
    Width = 310
    Height = 13
    Caption = 'Es ist kein einzelner Monteur markiert (unterstrichen)!'
  end
  object Label2: TLabel
    Left = 16
    Top = 24
    Width = 215
    Height = 13
    Caption = 'Welchen Umfang soll die Liste haben?'
  end
  object Button1: TButton
    Left = 368
    Top = 104
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 288
    Top = 104
    Width = 75
    Height = 25
    Caption = 'abbrechen'
    TabOrder = 1
    OnClick = Button2Click
  end
  object RadioButton1: TRadioButton
    Left = 16
    Top = 56
    Width = 417
    Height = 17
    Caption = 'alle Monteure dieser Baustelle die dort Termine haben ...'
    TabOrder = 2
  end
  object RadioButton2: TRadioButton
    Left = 16
    Top = 72
    Width = 417
    Height = 17
    Caption = #252'berhaupt alle Monteure, die in dieser KW Termine haben ...'
    TabOrder = 3
  end
end
