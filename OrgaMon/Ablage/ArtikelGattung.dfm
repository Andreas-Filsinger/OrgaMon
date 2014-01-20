object FormArtikelGattung: TFormArtikelGattung
  Left = 138
  Top = 129
  Width = 660
  Height = 635
  Caption = 'FormArtikelGattung'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object ParamCheckList1: TParamCheckList
    Left = 8
    Top = 8
    Width = 217
    Height = 561
    AdvanceOnReturn = False
    EmptyParam = '?'
    HoverColor = clNone
    HoverFontColor = clNone
    ParamHint = False
    ParamListSorted = False
    SelectionColor = clHighlight
    SelectionFontColor = clHighlightText
    ShadowColor = clGray
    ShadowOffset = 1
    ShowSelection = False
    Duplicates = True
    ItemHeight = 16
    Items.Strings = (
      '<a href="cobra" class="TOGGLE" hint="cobra">cobra</a>')
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 8
    Top = 576
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
  end
  object JvTreeView1: TJvTreeView
    Left = 264
    Top = 72
    Width = 257
    Height = 361
    Indent = 19
    MultiSelect = True
    TabOrder = 2
    Items.Data = {
      020000001F0000000000000000000000FFFFFFFFFFFFFFFF0000000003000000
      067765727765721C0000000000000000000000FFFFFFFFFFFFFFFF0000000000
      000000036A6F651E0000000000000000000000FFFFFFFFFFFFFFFF0000000000
      000000056C756B61731E0000000000000000000000FFFFFFFFFFFFFFFF000000
      0000000000056C696D626F1F0000000000000000000000FFFFFFFFFFFFFFFF00
      00000000000000066DFC6C6C7274}
    Checkboxes = True
  end
end
