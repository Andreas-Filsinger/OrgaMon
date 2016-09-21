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
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 678
      ExplicitHeight = 321
      object TabSheet1: TTabSheet
        Caption = 'TabSheet1'
        DesignSize = (
          751
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
          Left = 547
          Top = 24
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Button2'
          TabOrder = 1
        end
        object ListBox1: TListBox
          Left = 24
          Top = 64
          Width = 598
          Height = 198
          Anchors = [akLeft, akTop, akRight, akBottom]
          ItemHeight = 13
          TabOrder = 2
        end
        object Button3: TButton
          Left = 24
          Top = 285
          Width = 75
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = 'Button3'
          TabOrder = 3
        end
        object Button4: TButton
          Left = 547
          Top = 286
          Width = 75
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'Button4'
          TabOrder = 4
        end
      end
    end
  end
end
