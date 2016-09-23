object FormPageControlTest: TFormPageControlTest
  Left = 0
  Top = 0
  Caption = 'FormPageControlTest'
  ClientHeight = 577
  ClientWidth = 844
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 761
    Height = 545
    Caption = 'Panel1'
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 759
      Height = 543
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'TabSheet1'
        ExplicitWidth = 751
        DesignSize = (
          536
          515)
        object Button1: TButton
          Left = 24
          Top = 24
          Width = 75
          Height = 25
          Caption = 'Button1'
          TabOrder = 0
        end
        object Button2: TButton
          Left = 172
          Top = 33
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Button2'
          TabOrder = 1
          ExplicitLeft = 387
        end
        object ListBox1: TListBox
          Left = 24
          Top = 64
          Width = 501
          Height = 399
          Anchors = [akLeft, akTop, akRight, akBottom]
          ItemHeight = 13
          TabOrder = 2
          ExplicitWidth = 598
          ExplicitHeight = 198
        end
        object Button3: TButton
          Left = 24
          Top = 486
          Width = 75
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = 'Button3'
          TabOrder = 3
          ExplicitTop = 285
        end
        object Button4: TButton
          Left = 450
          Top = 487
          Width = 75
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'Button4'
          TabOrder = 4
          ExplicitLeft = 547
          ExplicitTop = 286
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'TabSheet2'
        ImageIndex = 1
        ExplicitWidth = 751
      end
    end
  end
end
