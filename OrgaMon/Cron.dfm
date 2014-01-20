object FormCron: TFormCron
  Left = 0
  Top = 0
  Caption = 'FormCron'
  ClientHeight = 710
  ClientWidth = 809
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 809
    Height = 710
    ActivePage = TabSheet3
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Tagwache'
    end
    object TabSheet2: TTabSheet
      Caption = 'Tagesabschluss'
      ImageIndex = 1
    end
    object TabSheet3: TTabSheet
      Caption = 'Zeitereignis'
      ImageIndex = 2
      object Label1: TLabel
        Left = 64
        Top = 184
        Width = 31
        Height = 13
        Caption = 'Label1'
      end
      object ListBox1: TListBox
        Left = 24
        Top = 24
        Width = 361
        Height = 153
        ItemHeight = 13
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 24
        Top = 186
        Width = 13
        Height = 8
        BevelOuter = bvNone
        Color = clGreen
        TabOrder = 1
      end
    end
  end
  object Timer1: TTimer
    Interval = 1250
    OnTimer = Timer1Timer
    Left = 640
    Top = 88
  end
end
