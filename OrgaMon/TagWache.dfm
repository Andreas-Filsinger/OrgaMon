object FormTagWache: TFormTagWache
  Left = 519
  Top = 412
  BorderStyle = bsDialog
  Caption = 'Tagwache'
  ClientHeight = 295
  ClientWidth = 497
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 251
    Width = 37
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 23
    Top = 264
    Width = 57
    Height = 13
    Caption = 'automatik'
  end
  object Label3: TLabel
    Left = 11
    Top = 10
    Width = 203
    Height = 20
    Caption = 'OrgaMon'#8482' Tagwache'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ProgressBar1: TProgressBar
    Left = 4
    Top = 228
    Width = 345
    Height = 17
    TabOrder = 0
  end
  object CheckListBox1: TCheckListBox
    Left = 7
    Top = 41
    Width = 480
    Height = 180
    BorderStyle = bsNone
    Color = clBtnFace
    ItemHeight = 13
    Items.Strings = (
      'Fotos laden'
      'Mobil auslesen'
      'Auftrag Ergebnis'
      'Automatischer Import'
      'Mobil schreiben'
      'Sync mit dem Fotoserver'
      'OLAP Tagesbericht erstellen'
      'Tagwache OLAPs ausf'#252'hren'
      'kurz warten')
    TabOrder = 1
    OnDblClick = CheckListBox1DblClick
  end
  object Button1: TButton
    Left = 356
    Top = 247
    Width = 131
    Height = 40
    Caption = 'Start'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Panel1: TPanel
    Left = 7
    Top = 267
    Width = 13
    Height = 8
    BevelOuter = bvNone
    Color = clGreen
    TabOrder = 3
  end
  object Button2: TButton
    Left = 356
    Top = 227
    Width = 131
    Height = 19
    Caption = 'Einzeltest vorbereiten'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Timer1: TTimer
    Interval = 1250
    OnTimer = Timer1Timer
    Left = 440
    Top = 22
  end
end
