object FormSystemPasswort: TFormSystemPasswort
  Left = 236
  Top = 208
  BorderStyle = bsToolWindow
  Caption = 'Eingabe erforderlich'
  ClientHeight = 80
  ClientWidth = 253
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 220
    Height = 16
    Caption = 'Passwort für den Systembereich:'
  end
  object Edit1: TEdit
    Left = 16
    Top = 40
    Width = 121
    Height = 24
    PasswordChar = '*'
    TabOrder = 0
    Text = 'Edit1'
  end
end
