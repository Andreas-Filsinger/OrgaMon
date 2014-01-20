object FormObermayerImport: TFormObermayerImport
  Left = 222
  Top = 187
  Width = 391
  Height = 114
  Caption = 'FormObermayerImport'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 56
    Width = 369
    Height = 25
    Caption = 'zusammenf'#252'hren'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 369
    Height = 21
    TabOrder = 1
    Text = 'G:\delphi\contutto\Obermayer\cd_dat1.csv'
  end
  object Edit2: TEdit
    Left = 8
    Top = 32
    Width = 369
    Height = 21
    TabOrder = 2
    Text = 'G:\delphi\contutto\Obermayer\titel.csv'
  end
end
