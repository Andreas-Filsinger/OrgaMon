object FormRechnungen: TFormRechnungen
  Left = 0
  Top = 0
  Caption = 'FormRechnungen'
  ClientHeight = 660
  ClientWidth = 861
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object ControlBar1: TControlBar
    Left = 0
    Top = 0
    Width = 861
    Height = 49
    Align = alTop
    TabOrder = 0
    ExplicitTop = -6
    ExplicitWidth = 764
  end
  object ControlBar2: TControlBar
    Left = 0
    Top = 610
    Width = 861
    Height = 50
    Align = alBottom
    TabOrder = 1
    ExplicitLeft = 72
    ExplicitTop = 304
    ExplicitWidth = 100
  end
  object CheckListBox1: TCheckListBox
    Left = 0
    Top = 49
    Width = 121
    Height = 561
    Align = alLeft
    TabOrder = 2
    ExplicitLeft = 8
    ExplicitTop = 184
    ExplicitHeight = 97
  end
  inline FrameRechnungUeberblick1: TFrameRechnungUeberblick
    Left = 121
    Top = 49
    Width = 740
    Height = 561
    Align = alClient
    TabOrder = 3
    ExplicitLeft = 142
    ExplicitTop = 191
    inherited Splitter1: TSplitter
      Width = 740
    end
    inherited DrawGrid1: TDrawGrid
      Width = 740
      ExplicitTop = -3
    end
    inherited DrawGrid2: TDrawGrid
      Width = 740
      Height = 325
      ExplicitLeft = 0
      ExplicitTop = 236
      ExplicitWidth = 719
      ExplicitHeight = 233
    end
  end
end
