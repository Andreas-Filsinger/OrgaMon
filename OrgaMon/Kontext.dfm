object FormKontext: TFormKontext
  Left = 0
  Top = 0
  Caption = 'Kontext'
  ClientHeight = 332
  ClientWidth = 535
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 535
    Height = 332
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Person'
      object CheckListBox1: TCheckListBox
        Left = 16
        Top = 32
        Width = 497
        Height = 235
        OnClickCheck = CheckListBox1ClickCheck
        TabOrder = 0
        OnDblClick = CheckListBox1DblClick
      end
      object Button1: TButton
        Left = 438
        Top = 273
        Width = 75
        Height = 25
        Caption = 'weiter >>'
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button10: TButton
        Left = 488
        Top = 3
        Width = 25
        Height = 25
        Caption = '&P'
        TabOrder = 2
        OnClick = Button10Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Beleg'
      ImageIndex = 1
      object CheckListBox2: TCheckListBox
        Left = 16
        Top = 34
        Width = 497
        Height = 233
        OnClickCheck = CheckListBox1ClickCheck
        TabOrder = 0
        OnDblClick = CheckListBox2DblClick
      end
      object Button4: TButton
        Left = 438
        Top = 273
        Width = 75
        Height = 25
        Caption = 'weiter >>'
        TabOrder = 1
        OnClick = Button4Click
      end
      object Button11: TButton
        Left = 488
        Top = 3
        Width = 25
        Height = 25
        Caption = '&B'
        TabOrder = 2
        OnClick = Button11Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Baustelle'
      ImageIndex = 2
      object CheckListBox3: TCheckListBox
        Left = 16
        Top = 34
        Width = 497
        Height = 233
        OnClickCheck = CheckListBox1ClickCheck
        TabOrder = 0
        OnDblClick = CheckListBox3DblClick
      end
      object Button7: TButton
        Left = 438
        Top = 273
        Width = 75
        Height = 25
        Caption = 'weiter >>'
        TabOrder = 1
        OnClick = Button7Click
      end
      object Button12: TButton
        Left = 488
        Top = 3
        Width = 25
        Height = 25
        Caption = '&O'
        TabOrder = 2
        OnClick = Button12Click
      end
    end
  end
end
