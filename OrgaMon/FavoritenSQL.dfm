object FormSQLFavoriten: TFormSQLFavoriten
  Left = 0
  Top = 0
  Caption = 'SQL-Favoriten bearbeiten'
  ClientHeight = 432
  ClientWidth = 615
  Color = clBtnFace
  Constraints.MinHeight = 210
  Constraints.MinWidth = 360
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 403
    Width = 615
    Height = 29
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      615
      29)
    object Button1: TButton
      Left = 406
      Top = 2
      Width = 98
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #220'bernehmen'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 510
      Top = 2
      Width = 98
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Abbrechen'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 615
    Height = 403
    Align = alClient
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 145
      Top = 1
      Width = 6
      Height = 372
      Beveled = True
      ExplicitHeight = 318
    end
    object ListView1: TListView
      Left = 1
      Top = 1
      Width = 144
      Height = 372
      Align = alLeft
      Columns = <
        item
          AutoSize = True
          Caption = 'Favoriten'
        end>
      GridLines = True
      HideSelection = False
      RowSelect = True
      SortType = stText
      TabOrder = 0
      ViewStyle = vsReport
      OnColumnClick = ListView1ColumnClick
      OnCompare = ListView1Compare
      OnEditing = ListView1Editing
      OnSelectItem = ListView1SelectItem
    end
    object Panel3: TPanel
      Left = 1
      Top = 373
      Width = 613
      Height = 29
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object Button3: TButton
        Left = 4
        Top = 2
        Width = 98
        Height = 23
        Caption = 'Hinzuf'#252'gen'
        TabOrder = 0
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 108
        Top = 2
        Width = 101
        Height = 23
        Caption = 'Entfernen'
        TabOrder = 1
        OnClick = Button4Click
      end
    end
    object Panel4: TPanel
      Left = 151
      Top = 1
      Width = 463
      Height = 372
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        463
        372)
      object Memo1: TMemo
        Left = 0
        Top = 32
        Width = 463
        Height = 340
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        HideSelection = False
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 1
        WantTabs = True
        WordWrap = False
        OnChange = Memo1Change
      end
      object LabeledEdit1: TLabeledEdit
        Left = 80
        Top = 5
        Width = 375
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 67
        EditLabel.Height = 13
        EditLabel.Caption = 'Bezeichnung: '
        LabelPosition = lpLeft
        TabOrder = 0
        OnChange = LabeledEdit1Change
      end
    end
  end
end
