object FormAGM_EditCity: TFormAGM_EditCity
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Stadt bearbeiten'
  ClientHeight = 89
  ClientWidth = 375
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LabeledEditCity: TLabeledEdit
    Left = 16
    Top = 24
    Width = 345
    Height = 21
    EditLabel.Width = 79
    EditLabel.Height = 13
    EditLabel.Caption = 'Name der Stadt:'
    TabOrder = 0
    OnKeyDown = LabeledEditCityKeyDown
  end
  object ButtonOk: TButton
    Left = 163
    Top = 51
    Width = 97
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = ButtonOkClick
  end
  object ButtonCancel: TButton
    Left = 266
    Top = 51
    Width = 95
    Height = 25
    Caption = 'Abbrechen'
    TabOrder = 2
    OnClick = ButtonCancelClick
  end
end
