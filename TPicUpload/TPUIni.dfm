object Ini: TIni
  Left = 539
  Top = 371
  BorderIcons = []
  Caption = 'Setup (tpicupload.ini)'
  ClientHeight = 309
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object INIContent: TMemo
    Left = 8
    Top = 8
    Width = 441
    Height = 265
    Ctl3D = False
    ParentCtl3D = False
    ScrollBars = ssVertical
    TabOrder = 0
    OnChange = INIContentChange
  end
  object Button1: TButton
    Left = 360
    Top = 280
    Width = 91
    Height = 25
    Caption = 'Schlie'#223'en'
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
end
