object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'THTTPGet'
  ClientHeight = 305
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelRevision: TLabel
    Left = 408
    Top = 289
    Width = 51
    Height = 11
    Alignment = taRightJustify
    Caption = 'Rev. '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LabelURL: TLabel
    Left = 8
    Top = 12
    Width = 25
    Height = 13
    Caption = 'URL:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object EditURL: TEdit
    Left = 40
    Top = 8
    Width = 338
    Height = 21
    TabOrder = 0
  end
  object GetButton: TButton
    Left = 384
    Top = 5
    Width = 75
    Height = 25
    Caption = 'Get'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = GetButtonClick
  end
  object MemoLog: TMemo
    Left = 8
    Top = 35
    Width = 451
    Height = 251
    TabOrder = 2
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 352
    Top = 4
  end
end
