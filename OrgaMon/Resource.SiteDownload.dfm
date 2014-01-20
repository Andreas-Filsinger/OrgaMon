object FormSiteDownload: TFormSiteDownload
  Left = 0
  Top = 0
  Caption = 'Get HTTP'
  ClientHeight = 629
  ClientWidth = 650
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 106
    Top = 103
    Width = 19
    Height = 13
    Caption = 'URL'
  end
  object Label2: TLabel
    Left = 106
    Top = 189
    Width = 68
    Height = 13
    Caption = 'Artikel-Tabelle'
  end
  object Label3: TLabel
    Left = 463
    Top = 103
    Width = 95
    Height = 13
    Caption = 'Dateierweiterungen'
  end
  object Label4: TLabel
    Left = 106
    Top = 342
    Width = 33
    Height = 13
    Caption = 'Bericht'
  end
  object Label5: TLabel
    Left = 8
    Top = 24
    Width = 90
    Height = 13
    Caption = 'Sync.ini Quellpfad:'
  end
  object Label7: TLabel
    Left = 106
    Top = 567
    Width = 17
    Height = 29
    Caption = '#'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 106
    Top = 49
    Width = 48
    Height = 13
    Caption = 'Optionen:'
  end
  object Memo1: TMemo
    Left = 106
    Top = 360
    Width = 533
    Height = 201
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Sync: TButton
    Left = 564
    Top = 594
    Width = 75
    Height = 25
    Caption = 'Sync'
    TabOrder = 1
    OnClick = SyncClick
  end
  object ListBox1: TListBox
    Left = 106
    Top = 232
    Width = 533
    Height = 104
    ItemHeight = 13
    Items.Strings = (
      'NAME;RID'
      'DHP 1023207;1'
      'DHP 1043546-010;2')
    TabOrder = 2
  end
  object ListBox2: TListBox
    Left = 462
    Top = 119
    Width = 177
    Height = 63
    ItemHeight = 13
    Items.Strings = (
      '.pdf'
      '.mp3'
      '.jpg')
    TabOrder = 3
  end
  object Edit2: TEdit
    Left = 106
    Top = 21
    Width = 375
    Height = 21
    TabOrder = 4
  end
  object Button1: TButton
    Left = 564
    Top = 19
    Width = 75
    Height = 25
    Caption = 'Load'
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 486
    Top = 19
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 6
    OnClick = Button2Click
  end
  object CheckBox1: TCheckBox
    Left = 564
    Top = 567
    Width = 97
    Height = 17
    Caption = 'Abbruch'
    TabOrder = 7
  end
  object ProgressBar1: TProgressBar
    Left = 106
    Top = 602
    Width = 451
    Height = 17
    TabOrder = 8
  end
  object ListBox3: TListBox
    Left = 106
    Top = 119
    Width = 350
    Height = 63
    ItemHeight = 13
    Items.Strings = (
      'http://www.productstore.com/imgupload/')
    TabOrder = 9
  end
  object CheckBox2: TCheckBox
    Left = 106
    Top = 64
    Width = 319
    Height = 17
    Caption = '(Delete=JA) L'#246'schen, wenn Link nicht mehr da'
    TabOrder = 10
  end
  object CheckBox3: TCheckBox
    Left = 106
    Top = 80
    Width = 319
    Height = 17
    Caption = '(Filter=JA) NAME soll rein numerisch abgefragt werden'
    TabOrder = 11
  end
  object Button3: TButton
    Left = 488
    Top = 56
    Width = 151
    Height = 25
    Caption = '.jpg aus .gif erstellen'
    TabOrder = 12
    OnClick = Button3Click
  end
  object ProgressBar2: TProgressBar
    Left = 106
    Top = 208
    Width = 533
    Height = 17
    TabOrder = 13
  end
  object IdHTTP1: TIdHTTP
    OnWork = IdHTTP1Work
    OnWorkBegin = IdHTTP1WorkBegin
    OnWorkEnd = IdHTTP1WorkEnd
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = '*/*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/5.0 (Windows NT 6.1; rv:2.0) Gecko/20100101 Firefox/4.0'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    OnHeadersAvailable = IdHTTP1HeadersAvailable
    Left = 16
    Top = 47
  end
  object OpenTextFileDialog1: TOpenTextFileDialog
    DefaultExt = 'ini'
    Filter = 'Quelleinstellungen|*.ini'
    Left = 24
    Top = 89
  end
end
