object FormTagesAbschluss: TFormTagesAbschluss
  Left = 273
  Top = 213
  Caption = 'Tagesabschluss'
  ClientHeight = 514
  ClientWidth = 449
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object lblAusfuehrung: TLabel
    Left = 7
    Top = 470
    Width = 85
    Height = 13
    Caption = 'lblAusfuehrung'
  end
  object Label2: TLabel
    Left = 23
    Top = 485
    Width = 57
    Height = 13
    Caption = 'automatik'
  end
  object Label3: TLabel
    Left = 7
    Top = 9
    Width = 256
    Height = 20
    Caption = 'OrgaMon'#8482' Tagesabschluss'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 8
    Top = 432
    Width = 318
    Height = 13
    Caption = 'Info: Umgekehrte Logik! Was aus ist, wird ausgef'#252'hrt...'
  end
  object ProgressBar1: TProgressBar
    Left = 7
    Top = 449
    Width = 296
    Height = 16
    TabOrder = 0
  end
  object CheckListBox1: TCheckListBox
    Left = 8
    Top = 41
    Width = 426
    Height = 390
    BorderStyle = bsNone
    Color = clBtnFace
    ItemHeight = 13
    Items.Strings = (
      'Datensicherung Datenbank'
      'Datensicherung Gesamtsystem'
      'Dateiverzeichnisse aufr'#228'umen'
      'Paket-IDs ermitteln'
      'Tagesabschluss.*.OLAP.txt ausf'#252'hren'
      'Replikation mit einer anderen Datenbank'
      'Monda empfangen/senden'
      'Sync mit dem Fotoserver'
      'Webshop Extern Datenbank upload'
      'Webshop Medien upload'
      'HBCI-Konten: Umsatzabfrage'
      'Diverse Caching Elemente neu erzeugen'
      'Auftrag Speed Suche neu erzeugen'
      'Verkaufsrang berechnen '
      'Lieferzeit berechnen'
      'Personen Speed Suche neu erzeugen'
      'CMS Katalog neu erstellen'
      'Musiker Speed Suche neu erzeugen'
      'Tier Speed Suche neu erzeugen'
      'Artikel Speed Suche im Belege Fenster neu erzeugen'
      'DMO und PRO Mengen setzen'
      'Freigebbare Lagerpl'#228'tze freigeben'
      'ausgeglichene Belege l'#246'schen'
      'Mahnliste erstellen'
      'Vertr'#228'ge anwenden'
      'Abgleich Server Zeitgeber <-> Lokaler Zeitgeber'
      'CareTaker Nachmeldungen'
      'kurz warten')
    TabOrder = 1
  end
  object Button1: TButton
    Left = 308
    Top = 468
    Width = 133
    Height = 38
    Caption = 'Start'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Panel1: TPanel
    Left = 7
    Top = 488
    Width = 13
    Height = 8
    BevelOuter = bvNone
    Color = clGreen
    TabOrder = 3
  end
  object Button2: TButton
    Left = 308
    Top = 448
    Width = 133
    Height = 19
    Caption = 'Einzeltest vorbereiten'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 296
    Top = 81
  end
end
