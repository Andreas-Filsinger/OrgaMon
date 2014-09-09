object MainForm: TMainForm
  Left = 319
  Top = 197
  Caption = 'PC/SC Sample Application V1.3'
  ClientHeight = 624
  ClientWidth = 642
  Color = clBtnFace
  Constraints.MaxWidth = 658
  Constraints.MinHeight = 200
  Constraints.MinWidth = 650
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object LogMemo: TMemo
    Left = 0
    Top = 0
    Width = 642
    Height = 624
    TabStop = False
    Align = alClient
    BevelKind = bkFlat
    BorderStyle = bsNone
    Lines.Strings = (
      'LogMemo')
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
    ExplicitTop = 101
    ExplicitHeight = 316
  end
end
