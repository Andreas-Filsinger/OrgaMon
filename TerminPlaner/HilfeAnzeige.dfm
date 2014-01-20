object FormHilfeAnzeige: TFormHilfeAnzeige
  Left = 133
  Top = 118
  Width = 696
  Height = 480
  Caption = 'Hilfe'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 688
    Height = 453
    Align = alClient
    Color = 10485759
    Lines.Strings = (
      'Neuanlage eines Termins:'
      '====================='
      ''
      'mit der linken Maustaste die Zellen markieren,'
      'wo der neue Termin stattfinden soll. Danach '
      'mit der rechten Maustaste anklicken -> nun '
      'hineinklicken, um den Text zu ändern.'
      'Nun die Speichern-Taste drücken!'
      ''
      'Verschieben eines Termines:'
      '====================='
      ''
      'a) inerhalb einer und derselben Woche:'
      ''
      'den Termin erst mal anklicken. Mit der Maus auf '
      'die linke obere ecke fahren, bis ein Fadenkreuz sichtbar ist. '
      'Linke Maustaste nun gedrückt halten und Termin verschieben!'
      ''
      'b)  Verschieben über eine Kalenderwoche hinaus '
      ''
      'den Termin erst mal anklicken, danach den Funktionsknopf '
      '"Kopiere einen Termin". Der Termin verschwindet. Nun in'
      'eine andere Woche wechseln (zuvor Speichern nicht vergessen!).'
      'Wo der Termin hin soll mit der linken Maustaste klicken,'
      '(Speichern nicht vergessen!).'
      ''
      'Löschen eines Termins:'
      '==================='
      ''
      'den Termin anklicken, danach das Symbol "durchgestrichenes'
      'Ausrufezeichen" anklicken.'
      '')
    TabOrder = 0
  end
end
