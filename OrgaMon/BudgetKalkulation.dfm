object FormBudgetKalkulation: TFormBudgetKalkulation
  Left = 192
  Top = 107
  Caption = 'FormBudgetKalkulation'
  ClientHeight = 556
  ClientWidth = 689
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 608
    Top = 528
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 673
    Height = 497
    Lines.Strings = (
      '// Abrechnung Firma P'#252'nktlich GmbH'
      ''
      '// Abschlag "01" Rechner-System, erhalten!'
      '1;Anzahlung;-10300,00 DM'
      ''
      '// API "1592888"'
      '1;ISDN Fritz Card;129,00 DM'
      '1;MS Office SBE;489,00 DM'
      '1;AVM Ken!;369,00 DM'
      '1;Fracht & Versicherung;26,00 DM'
      ''
      '// API "1588490"'
      '2;Teac 3.5" HD;23,00 DM'
      '2;Cherry Keyboard;23,00 DM'
      '2;Maus MS Defender;18,90 DM'
      '2;Netzwerkkarte;85,00 DM'
      '2;Soundkarte Terratec;31,00 DM'
      '2;Windows 2000 Pro;305,00 DM'
      '2;Geh'#228'use iMac blue;126,00 DM'
      '1;Netzwerk HUB;99,00 DM'
      '2;IBM 30er Platte;309,00 DM'
      '2;CPU Cooler;13,00 DM'
      '2;ASUS Mainboard A7V;321,00 DM'
      '2;Grafik Karte;67,00 DM'
      '2;AMD Duron 650 MHz;136,00 DM'
      '2;DVD;189,00 DM'
      '2;Speicher 128 MByte;159,00 DM'
      '1;Fracht & Versicherung;48,00 DM'
      ''
      '// ALDI'
      '1;TFT Display 15.1";1.291,38 DM'
      '1;CD-Brenner HP;300,86 DM'
      '2;Aktiv Boxen;19,75 DM'
      ''
      '// Software via InterNet'
      
        '1;FTP Voyager f'#252'r Homepage Pflege (Kurz 2,32 DEM=1 USD);115,77 D' +
        'M'
      '1;Power DVD (Kurz 2,32 DEM=1 USD);114,84 DM'
      ''
      '// Atelco'
      '1;CTX Monitor;665,28 DM'
      ''
      '// puretec Starpaket 2.0'
      '12;Puretec "Puenktlich-GmbH" 12 Monate;8,61 DM'
      ''
      '// Arbeitszeit / Lohn'
      '2;Konfiguration/Beschaffung/Bau Rechnersystem pauschal;500,00 DM'
      '2;Windows 2000,DVD,KEN,NETZ, Softwareinstallation;520,00 DM'
      '6;Installation vor Ort am 02.01.2001 '#225';135,00 DM'
      '5;Abschluss-Schulung, 3 Internet-eMail Konten;135,00 DM')
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
end
