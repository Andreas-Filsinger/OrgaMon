object FormFrageLoeschenMonteurInfo: TFormFrageLoeschenMonteurInfo
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  ClientHeight = 90
  ClientWidth = 290
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LabelQuestion: TLabel
    Left = 8
    Top = 8
    Width = 266
    Height = 36
    AutoSize = False
    Caption = 
      'Soll der Status "Monteur informiert" beim fokusierten oder bei a' +
      'lle Datens'#228'tzen gel'#246'scht werden?'
    WordWrap = True
  end
  object ButtonDeleteOneDataset: TButton
    Left = 8
    Top = 50
    Width = 121
    Height = 25
    Caption = 'Fokusierter Datensatz'
    TabOrder = 0
    OnClick = ButtonDeleteOneDatasetClick
  end
  object ButtonAllDatasets: TButton
    Left = 153
    Top = 50
    Width = 121
    Height = 25
    Caption = 'Alle Datens'#228'tze'
    TabOrder = 1
    OnClick = ButtonAllDatasetsClick
  end
end
